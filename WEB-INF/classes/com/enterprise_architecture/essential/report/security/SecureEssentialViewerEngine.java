/**
 * Copyright (c)2015-2018 Enterprise Architecture Solutions ltd.
 * This file is part of Essential Architecture Manager, 
 * the Essential Architecture Meta Model and The Essential Project.
 *
 * Essential Architecture Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Essential Architecture Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Essential Architecture Manager.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 19.01.2015	JWC	First coding
 * 24.03.2016	JWC Instrumented for SSL debugging
 * 08.02.2017	JWC	Removed trace code
 */
package com.enterprise_architecture.essential.report.security;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.om.DocumentInfo;
import net.sf.saxon.trans.XPathException;

import com.enterprise_architecture.essential.report.EssentialViewerEngine;
import com.enterprise_architecture.essential.report.ViewTransformErrorListener;

/**
 * Essential Viewer Engine that applies fine-grained access control and security to the use of Essential Viewer
 * @author Jonathan Carter
 *
 */
public class SecureEssentialViewerEngine extends EssentialViewerEngine 
{
	/** View template for the access denied message
	 * 
	 */
	protected static final String ACCESS_DENIED_VIEWER = "platform/access_denied.xsl";
	
	/**
	 * View template for the access denied to specified view message
	 */
	protected static final String ACCESS_DENIED_VIEW = "platform/view_access_denied.xsl";
	
	/**
	 * Servlet attribute (Singleton) holding the current configuration of security classifications
	 * on the Report instances in XML format.
	 */
	protected static final String VIEW_SECURITY_CONFIG = "theViewSecurityConfigXML";
	
	/**
	 * Name of the servlet context parameter containing relative path to the XSL performing
	 * query to get the View (Report instance) security classifications
	 */
	protected static final String VIEW_SECURITY_CONFIG_QUERY_PARAM = "viewSecurityConfigQuery";
	
	/**
	 * Servlet attribute (Singleton) holding the security ID of the current repository being
	 * used by the Viewer.
	 */
	protected static final String VIEWER_REPOSITORY_ID = "theRepositoryID";
	
	/**
	 * Name of the servlet context parameter containing relative path to the XSL performing
	 * query to get the repository security ID
	 */
	protected static final String VIEWER_REPOSITORY_ID_QUERY = "viewerRepositoryIDQuery";
	
	/**
	 * Name of the servlet context parameter containing the relative path to the XSL performing
	 * query to test user authorization to access selected View template
	 */
	protected static final String VIEW_USER_AUTHZ_QUERY_PARAM = "userAuthZQuery";
	
	/**
	 * Name of the servlet context parameter containing the relative path to the XSL performing
	 * query to test user authorization to access selected instance
	 */
	protected static final String VIEW_USER_AUTHZ_INSTANCE_QUERY_PARAM = "userAuthZInstanceQuery";
	
	/**
	 * Transformer parameter for the user authorisation query containing user data as a parsed
	 * node set
	 */
	protected static final String USER_PARAM = "userData";
	
	/**
	 * Transformer parameter for the repository ID of the current repository snapshot 
	 */
	protected static final String REPOS_ID_PARAM = "repositoryID";
	
	/**
	 * Transformer parameter for the user authorisation query containing the name of the selected
	 * view template (XSL filename from Report instance)
	 */
	protected static final String VIEW_TEMPLATE_PARAM = "viewTemplate";
	
	/**
	 * Transformer parameter for the user authorisation query containing the type of authorisation being
	 * tested. Either read or edit
	 */
	protected static final String CLASSIFICATION_TYPE_PARAM = "classificationType";
	
	/**
	 * Transformer parameter for the user authorisation containing the classification configuration
	 */
	protected static final String CLASSIFICATION_CONFIG_PARAM = "classificationConfig";
	
	/**
	 * Transformer parameter for the requested instance ID to be tested for user clearance
	 */
	protected static final String INSTANCE_ID_PARAM = "theInstanceID";
	
	/**
	 * Response from the authorisation query when user is NOT authorized
	 */
	protected static final String NO_AUTH_QUERY_RESULT = "ACCESS DENIED";
	
	/**
	 * Error message for exceptions encountered during the authorisation for requested view queries
	 */
	protected static final String AUTH_QUERY_FAILED_MESSAGE = "ERROR: exception during user authorisation query for request view.\n";
	
	protected static final String LOGIN_TEMPLATE = "/platform/login.xsl";
	
	protected static final String PRE_LOGIN_URL = "preLoginURL";

	/**
	 * Flag for the Viewer view templates to know whether they are running in EIP mode or not
	 * SecureViewerEngine sets this to true
	 */
	protected static final String EIP_MODE_FLAG = "eipMode";
	
	protected ViewerSecurityManager itsSecurityMgr;
	
	protected String itsContextPath = "/";
	
	
	/**
	 * @param theServletContext
	 */
	public SecureEssentialViewerEngine(ServletContext theServletContext) 
	{
		super(theServletContext);
		
		// Connect to Stormpath
		itsSecurityMgr = new ViewerSecurityManager(itsServletContext);
		
		// Get and save context path
		String aFileSep = System.getProperty("file.separator");					
		itsContextPath = itsServletContext.getRealPath("") + aFileSep;
	}

	/**
	 * @param theServletContext
	 * @param theIsTrackHistory
	 */
	public SecureEssentialViewerEngine(ServletContext theServletContext,
			boolean theIsTrackHistory) 
	{
		super(theServletContext, theIsTrackHistory);
		
		// Connect to Stormpath
		itsSecurityMgr = new ViewerSecurityManager(itsServletContext);
		
		// Get and save context path
		String aFileSep = System.getProperty("file.separator");					
		itsContextPath = itsServletContext.getRealPath("") + aFileSep;
	}

	/**
	 * Apply security to the generation of the View. Check user is authorised to perform this operation
	 * and force login if the user has not already authenticated.
	 */
	@Override
	public boolean generateView(HttpServletRequest theRequest, 
		 						HttpServletResponse theResponse,
		 						StringWriter theResultString) throws ServletException, IOException
	{
		boolean isSuccess = true;
		// Check user access to the Viewer
		
		// Get user account URL from session
		String anAccount = itsSecurityMgr.authenticateUserBySession(theRequest);		
		System.out.println("SecureViewer: authenticate attempt via session, got account object.");
		
		// Have URL - test authorisation
		// Get the selected View from the request			
		String aRequestedTemplate = theRequest.getParameter("XSL");
		String aRepositoryXML = theRequest.getParameter("XML");					
		
		// If no URL - get Account from Stormpath. Use their login process
		if(anAccount == null)
		{
			// User is not yet authenticated, so redirect to login servlet
			//System.out.println("SecureViewer: Null account, do login process");
			
			// Send the request URL as a parameter so we know where to come back to?
			// Render a login View template.
			performLogin(theRequest, theResponse, aRepositoryXML, theResultString);
			isSuccess = true;
			return isSuccess;
		}
		
		// Get the repository ID
		String aSourceDocPath = getRepositoryXMLPath(aRepositoryXML);
		String aReposID = getRepositoryID(theRequest, theResponse, aSourceDocPath, itsContextPath);
		
		// Get full path to this application - removing the servlet path to drop '/report' if it's included
		System.out.println("SecureViewer: Checking for authorisation for Viewer: " + theRequest.getRequestURL().toString());
		String aRequestURL = theRequest.getRequestURL().toString();
		if(aRequestURL.endsWith("/report"))
		{
			//System.out.println("SecureViewer: Removing any trailing /report characters from URL");		
			aRequestURL = aRequestURL.replace(theRequest.getServletPath(), "");
		}
		else if(aRequestURL.endsWith("/"))
		{
			//System.out.println("SecureViewer: Removing any trailing / characters from URL");			
			aRequestURL = aRequestURL.substring(0, aRequestURL.length()-1);
		}

		System.out.println("SecureViewer: Authorising for URL: " + aRequestURL);
		
		if(itsSecurityMgr.isUserAuthorisedForViewer(anAccount, aReposID, aRequestURL))
		{
			System.out.println("SecureViewer: TRACE == User authorised to access viewer for specified repository");
			// If access allowed, continue
			
			// Check user is allowed to View the selected view.			
			if(isUserAuthZForView(theRequest, theResponse, aRequestedTemplate, aRepositoryXML, itsSecurityMgr))
			{
				return super.generateView(theRequest, theResponse, theResultString);	
			}
			else
			{
				reportSecurityError(theRequest, theResponse, ACCESS_DENIED_VIEW, aRepositoryXML, theResultString);
				isSuccess = true;
				return isSuccess;
			}
		}
		else
		{
			reportSecurityError(theRequest, theResponse, ACCESS_DENIED_VIEWER, aRepositoryXML, theResultString);
			// Clear the user session to enable re-login
			//itsSecurityMgr.removeUserSession(theRequest);
			isSuccess = true;
			return isSuccess;
		}
		
	}
	
	/**
	 * Add reserved parameters required by security framework
	 */
	@Override
	protected void initialiseReservedParameters()
	{
		super.initialiseReservedParameters();
		
		itsViewerReservedParameters.add(ViewerSecurityManager.USER_ACCOUNT_URL);
		itsViewerReservedParameters.add(ViewerSecurityManager.REPOSITORY_ID_URL);
	}
	
	/**
	 * Is the user authorised to access the chosen View, defined by the template filename
	 * @return true if the user has access to that template. False otherwise
	 * @param theTemplateFile the [relative path] file name of the requested View template
	 */
	protected boolean isUserAuthZForView(HttpServletRequest theRequest, 
										 HttpServletResponse theResponse,
										 String theTemplateFile, 
										 String theRepositoryXML,
										 ViewerSecurityManager theSecurityMgr)
	{
		boolean isAuthZ = true;
		
		// Got the request details, set up paths etc.
		//If no xsl file is provided, then go to the default page (usually home)
		String aTemplateFile = theTemplateFile;
		if(aTemplateFile == null) 
		{
			aTemplateFile = itsServletContext.getInitParameter("homeXSLFile");
		}
		
		String xmlFile = getRepositoryXMLPath(theRepositoryXML);
		
		// Get the application variable for the XML of the Report Classifications
		String aViewClassification = getViewSecurityConfig(theRequest, theResponse, xmlFile, itsContextPath);
		
		// If Report Classifications is empty - there's been an error. Do not authorize
		// REALLY?
		/*if(aViewClassification.isEmpty())
		{
			isAuthZ = false;
			return isAuthZ;
		}*/
		
		// Get the user custom data XML
		String aUserData = theSecurityMgr.getUserData(theRequest);
		
		String aUserAuthZResult = "";
		
		try
		{
			aUserAuthZResult = queryUserAuthZ(aTemplateFile, aUserData, aViewClassification, itsContextPath);
			
			// If an instance has been requested, PMA query parameter, test authorisation for that instance
			String aRequestedInstanceID = theRequest.getParameter(REQUESTED_INSTANCE_ID_PARAM);
			if(aRequestedInstanceID != null && !aRequestedInstanceID.isEmpty())
			{
				aUserAuthZResult = queryUserAuthZInstance(theRequest, theResponse, xmlFile, aRequestedInstanceID, itsContextPath);				
			}
		}
		catch (Exception ex)
		{
			String aMessage = ex.getMessage();
			reportErrorMessage(theRequest, theResponse, AUTH_QUERY_FAILED_MESSAGE, aMessage, "", new ViewTransformErrorListener(), new ViewTransformErrorListener(), "");
			aUserAuthZResult = "";
		}
		
		// Test results of the transform
		if(aUserAuthZResult.contains(NO_AUTH_QUERY_RESULT))
		{
			isAuthZ = false;
		}
		else
		{
			isAuthZ = true;
		}
		return isAuthZ;
	}
	
	/**
	 * Get the current security classification set for all of the Report instances in the
	 * current repository
	 * @param theSourceDocumentFullPath theSourceDocumentFullPath the full (from the Servlet Context) for the source document. This full file name defines the XML source URI.
	 * @param theContextPath the full (from the Servlet Context) path from which query templates should be loaded.
	 * @param theErrorListener an Error Listener to catch any errors found while building the specified XML Source document.
	 * @return an XML document containing the classification configuration using schema: platform/viewerclassification.xsd
	 * @throws XPathException
	 */
	protected synchronized String getViewSecurityConfig(HttpServletRequest theRequest, 
														HttpServletResponse theResponse,
														String theSourceDocumentFullPath,
														String theContextPath)
	{
		String aViewSecurityConfig = (String) itsServletContext.getAttribute(VIEW_SECURITY_CONFIG);
		
		// Check to see if it has been set and the document loaded
		if(aViewSecurityConfig == null)
		{
			/*StringWriter aStringWriter = new StringWriter();
			PrintWriter aPrintWriter = new PrintWriter(aStringWriter);
			
			// Create it by querying the repository
			String aQueryXSL = (String)itsServletContext.getInitParameter(VIEW_SECURITY_CONFIG_QUERY_PARAM);
			
			// Create a separate Error lister for the cached factory 
			ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
			// And for the local transformer
			ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
			try
			{
				// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
				TransformerFactoryImpl tFactory = getTransformerFactory(theSourceDocumentFullPath, aFactoryErrorListener);

				// Make sure we have the correct transform factory error listener especially if it has been cached
				aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();
				
				//System.out.println("Query XSL = " + aQueryXSL);
				String aQueryFullPath = theContextPath + aQueryXSL;
				File anXSLFile = new File(aQueryFullPath);
				Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
				
				// Set a new local error listener for the transformer.
				transformer.setErrorListener(aTransformError);
				
				// Use the cached (or not) reportXML
				DocumentInfo anXMLSource = getXMLSourceDocument(tFactory, theSourceDocumentFullPath, aFactoryErrorListener);
				transformer.transform(anXMLSource, new StreamResult(aStringWriter));
				aViewSecurityConfig = aStringWriter.toString();
			}
			catch (XPathException anXPathEx)
			{
				// Bad characters, e.g.
				// Illegal HTML character: decimal 133
				// Character reference "&#24" is an invalid XML character.
				// Premature end of file - reportXML.xml is 0KB
				// Ignore the client abort exception.
				anXPathEx.printStackTrace(aPrintWriter);
				String aMessage = anXPathEx.getMessageAndLocation();
				
				// Absorb client abort messages - e.g. pressed stop or clicked on a link
				// before the current response completed. They raise XPath Exceptions...
				if(aMessage.contains("ClientAbortException"))
				{
					// Do nothing - just absorb the exception.
				}
				else
				{
					reportErrorMessage(theRequest, theResponse, XPATH_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
					aViewSecurityConfig = "";
				}
			}			
			
			catch (TransformerConfigurationException aStyleSheetError)
			{
				// e.g. XPath syntax error at char 0 on line 56 in {}:
				String aMessage = aStyleSheetError.getMessageAndLocation();
				aStyleSheetError.printStackTrace(aPrintWriter);
				reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
				aViewSecurityConfig = "";
			}
									
			catch (Exception anEx) 
			{
				// Handle the error message properly.
				anEx.printStackTrace(aPrintWriter);
				reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
				aViewSecurityConfig = "";
			}*/
			
			// Create it by querying the repository
			String aQueryXSL = (String)itsServletContext.getInitParameter(VIEW_SECURITY_CONFIG_QUERY_PARAM);
			aViewSecurityConfig = doTransformQuery(theRequest, theResponse, theSourceDocumentFullPath, aQueryXSL);
			
			// Add the security config to the singleton
			itsServletContext.setAttribute(VIEW_SECURITY_CONFIG, aViewSecurityConfig);			
		}
		
		return aViewSecurityConfig;
	}
	
	/**
	 * Get the Security ID of the current repository
	 * @param theSourceDocumentFullPath theSourceDocumentFullPath the full (from the Servlet Context) for the source document. This full file name defines the XML source URI.
	 * @param theContextPath the full (from the Servlet Context) path from which query templates should be loaded.
	 * @param theErrorListener an Error Listener to catch any errors found while building the specified XML Source document.
	 * @return a string containing the ID of the repository that is being queried by the current viewer
	 * @throws XPathException
	 */
	protected synchronized String getRepositoryID(HttpServletRequest theRequest, 
												  HttpServletResponse theResponse,
												  String theSourceDocumentFullPath,
												  String theContextPath)
	{
		String aRepositoryID = (String) itsServletContext.getAttribute(VIEWER_REPOSITORY_ID);
		
		// Check to see if it has been set and the document loaded
		if(aRepositoryID == null)
		{			
			// Create it by querying the repository
			String aQueryXSL = (String)itsServletContext.getInitParameter(VIEWER_REPOSITORY_ID_QUERY);
			aRepositoryID = doTransformQuery(theRequest, theResponse, theSourceDocumentFullPath, aQueryXSL);
			
			// Add the security config to the singleton
			itsServletContext.setAttribute(VIEWER_REPOSITORY_ID, aRepositoryID);			
		}
		
		return aRepositoryID;
	}
	
	/**
	 * Run the query to test whether user is authorised to access the specified View
	 * @param theTemplate the name of the View template that has been requested
	 * @param theUserData the user data including all clearance information
	 * @param theContextPath the full path prefix for the current working directory
	 * @return AUTHORISED if the user is authorised, ACCESS DENIED if not.
	 */
	protected String queryUserAuthZ(String theTemplate, String theUserData, String theViewClassification, String theContextPath)
		throws Exception
	{
		String anAuthResult = "";
		
		// Run an XML transformer on the report XML with the specified user data
		// Create a new transformer for security clearance check
		TransformerFactory aFactory = TransformerFactory.newInstance();
		
		// Transform the Report Classification XML document to render the Error View
		String aUserAuthZQuery = itsServletContext.getInitParameter(VIEW_USER_AUTHZ_QUERY_PARAM);
		String aFullQueryPath = theContextPath + aUserAuthZQuery;
		Transformer aTransformer = aFactory.newTransformer(new StreamSource(aFullQueryPath));
		
		// Set transformer param for user data $userData
		aTransformer.setParameter(USER_PARAM, new StreamSource(new StringReader(theUserData)));
		
		// Set transformer param for the template name $template
		aTransformer.setParameter(VIEW_TEMPLATE_PARAM, theTemplate);
		
		// Set transformer parameter for the clearance / classification type
		aTransformer.setParameter(CLASSIFICATION_TYPE_PARAM, "read");
		
		StringWriter aResultString = new StringWriter();
		aTransformer.transform(new StreamSource(new StringReader(theViewClassification)), new StreamResult(aResultString));
		anAuthResult = aResultString.toString();
		
		return anAuthResult;
	}
	
	/**
	 * Run the query to test whether the user is authorised to access the specified instance
	 * @param theRequest the request
	 * @param theResponse the response
	 * @param theSourceDocumentFullPath the full path to the repository snapshot XML.
	 * @param theInstanceID the ID of the requested instance
	 * @param theContextPath the full path prefix for the current working directory
	 * @return AUTHORISED if the user is authorised, ACCESS DENIED if not.
	 */
	protected String queryUserAuthZInstance(HttpServletRequest theRequest,
											HttpServletResponse theResponse,
											String theSourceDocumentFullPath,
											String theInstanceID,
											String theContextPath)
	{
		String anAuthResult = "";
		
		StringWriter aStringWriter = new StringWriter();
		PrintWriter aPrintWriter = new PrintWriter(aStringWriter);
		
		// Create it by querying the repository
		String aQueryXSL = (String)itsServletContext.getInitParameter(VIEW_USER_AUTHZ_INSTANCE_QUERY_PARAM);
		
		// Create a separate Error lister for the cached factory 
		ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
		// And for the local transformer
		ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactoryImpl tFactory = getTransformerFactory(theSourceDocumentFullPath, aFactoryErrorListener);

			// Make sure we have the correct transform factory error listener especially if it has been cached
			aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();
			
			//System.out.println("Query XSL = " + aQueryXSL);
			String aQueryFullPath = theContextPath + aQueryXSL;
			File anXSLFile = new File(aQueryFullPath);
			Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
			
			// Set a new local error listener for the transformer.
			transformer.setErrorListener(aTransformError);
			
			// Set the instance ID parameter
			transformer.setParameter(INSTANCE_ID_PARAM, theInstanceID);
			
			// Set the user data, classification config and clearance type parameters
			setTransformerParameters(transformer, theRequest);
			
			// Use the cached (or not) reportXML
			DocumentInfo anXMLSource = getXMLSourceDocument(tFactory, theSourceDocumentFullPath, aFactoryErrorListener);
			transformer.transform(anXMLSource, new StreamResult(aStringWriter));
			anAuthResult = aStringWriter.toString();
		}
		catch (XPathException anXPathEx)
		{
			// Bad characters, e.g.
			// Illegal HTML character: decimal 133
			// Character reference "&#24" is an invalid XML character.
			// Premature end of file - reportXML.xml is 0KB
			// Ignore the client abort exception.
			anXPathEx.printStackTrace(aPrintWriter);
			String aMessage = anXPathEx.getMessageAndLocation();
			
			// Absorb client abort messages - e.g. pressed stop or clicked on a link
			// before the current response completed. They raise XPath Exceptions...
			if(aMessage.contains("ClientAbortException"))
			{
				// Do nothing - just absorb the exception.
			}
			else
			{
				reportErrorMessage(theRequest, theResponse, XPATH_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
				anAuthResult = NO_AUTH_QUERY_RESULT;
			}
		}			
		
		catch (TransformerConfigurationException aStyleSheetError)
		{
			// e.g. XPath syntax error at char 0 on line 56 in {}:
			String aMessage = aStyleSheetError.getMessageAndLocation();
			aStyleSheetError.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
			anAuthResult = NO_AUTH_QUERY_RESULT;
		}
								
		catch (Exception anEx) 
		{
			// Handle the error message properly.
			anEx.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
			anAuthResult = NO_AUTH_QUERY_RESULT;
		}
		
		return anAuthResult;
	}
	
	/**
	 * Report a security error, such as access denied to the user.
	 * @param theRequest the HTTPServletRequest that the user made
	 * @param theResponse the HTTPServletResponse with which to send the error
	 * @param theErrorViewTemplate the name of the error view template to send to user.
	 * @param theXMLSourceDoc the name of the XML document that should be transformed to report the error
	 * @param theResultString the output response to which the security error will be reported
	 */
	protected void reportSecurityError(HttpServletRequest theRequest,
									   HttpServletResponse theResponse, 
									   String theErrorViewTemplate, 
									   String theXMLSourceDoc, 
									   StringWriter theResultString)
	{
		//System.out.println("ACCESS DENIED");
		StringWriter aStringWriter = new StringWriter();
		PrintWriter aPrintWriter = new PrintWriter(aStringWriter);
		String aSourceDocumentFullPath = getRepositoryXMLPath(theXMLSourceDoc);
		String anErrorView = itsContextPath + theErrorViewTemplate;
		
		// Create a separate Error lister for the cached factory 
		ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
		// And for the local transformer
		ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactoryImpl tFactory = getTransformerFactory(aSourceDocumentFullPath, aFactoryErrorListener);

			// Make sure we have the correct transform factory error listener especially if it has been cached
			aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();
			
			File anXSLFile = new File(anErrorView);
			Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
			
			// Set a new local error listener for the transformer.
			transformer.setErrorListener(aTransformError);
						
			// Use the cached (or not) reportXML
			DocumentInfo anXMLSource = getXMLSourceDocument(tFactory, aSourceDocumentFullPath, aFactoryErrorListener);
			transformer.transform(anXMLSource, new StreamResult(theResultString));
		}
		catch (XPathException anXPathEx)
		{
			// Bad characters, e.g.
			// Illegal HTML character: decimal 133
			// Character reference "&#24" is an invalid XML character.
			// Premature end of file - reportXML.xml is 0KB
			// Ignore the client abort exception.
			anXPathEx.printStackTrace(aPrintWriter);
			String aMessage = anXPathEx.getMessageAndLocation();
			
			// Absorb client abort messages - e.g. pressed stop or clicked on a link
			// before the current response completed. They raise XPath Exceptions...
			if(aMessage.contains("ClientAbortException"))
			{
				// Do nothing - just absorb the exception.
			}
			else
			{
				reportErrorMessage(theRequest, theResponse, XPATH_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");				
			}
		}			
		
		catch (TransformerConfigurationException aStyleSheetError)
		{
			// e.g. XPath syntax error at char 0 on line 56 in {}:
			String aMessage = aStyleSheetError.getMessageAndLocation();
			aStyleSheetError.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");			
		}
								
		catch (Exception anEx) 
		{
			// Handle the error message properly.
			anEx.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");			
		}
	}
	
	/**
	 * Set additional transformer parameters. On each request the engine will add 
	 * a core set of parameters to the transformer. Additional parameters can be 
	 * set here.
	 * @param theTransformer the transformer to which the parameters should be added
	 */
	protected void setTransformerParameters(Transformer theTransformer, HttpServletRequest theRequest)
	{
		// Nothing to implement in the base implementation
		String aViewSecurityConfig = (String) itsServletContext.getAttribute(VIEW_SECURITY_CONFIG);
		String aRepositoryID = (String)itsServletContext.getAttribute(VIEWER_REPOSITORY_ID);
				
		// Set transformer param for user data $userData
		theTransformer.setParameter(CLASSIFICATION_CONFIG_PARAM, new StreamSource(new StringReader(aViewSecurityConfig)));
				
		// Set transformer parameter for the clearance / classification type
		theTransformer.setParameter(CLASSIFICATION_TYPE_PARAM, "read");
		
		// Set the Viewer EIP Mode flag to true
		theTransformer.setParameter(EIP_MODE_FLAG, "true");
		
		// Set the repository ID for the current repository
		theTransformer.setParameter(REPOS_ID_PARAM, aRepositoryID);
		
		// Get the user data and pass that to the transformer
		String aUserData = itsSecurityMgr.getUserData(theRequest);
		theTransformer.setParameter(USER_PARAM, new StreamSource(new StringReader(aUserData)));	
		
	}
	
	protected void performLogin(HttpServletRequest theRequest,
			   					HttpServletResponse theResponse,
			   					String theXMLSourceDoc,
			   					StringWriter theResultString)
	{
		//System.out.println("ACCESS DENIED");
		String anXMLSourceDoc = theXMLSourceDoc;
		if(anXMLSourceDoc == null)
		{
			anXMLSourceDoc = itsServletContext.getInitParameter("defaultReportFile");
		}
		
		StringWriter aStringWriter = new StringWriter();
		PrintWriter aPrintWriter = new PrintWriter(aStringWriter);
		String aContextPath = itsServletContext.getRealPath("") + System.getProperty("file.separator") ;
		String aSourceDocumentFullPath = aContextPath + anXMLSourceDoc;
		String aLoginView = aContextPath + LOGIN_TEMPLATE;
		
		// Create a separate Error lister for the cached factory 
		ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
		// And for the local transformer
		ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactoryImpl tFactory = getTransformerFactory(aSourceDocumentFullPath, aFactoryErrorListener);
			
			// Make sure we have the correct transform factory error listener especially if it has been cached
			aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();
			
			File anXSLFile = new File(aLoginView);
			Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
			
			// Set transformer parameter for the original requested URL
			String aCurrentURL = theRequest.getServletPath();	
			aCurrentURL = aCurrentURL + "?" + theRequest.getQueryString();
			
			// Remove leading '/' on this URL
			aCurrentURL = aCurrentURL.substring(1);		
			
			transformer.setParameter(PRE_LOGIN_URL, aCurrentURL);
			
			// Get previous login status
			String aLoginStatus = (String)theRequest.getSession().getAttribute(ViewerSecurityManager.LOGIN_STATUS_VAR);
			if(aLoginStatus != null)
			{
				// We have a previous failed attempt
				if(aLoginStatus.equals(ViewerSecurityManager.LOGIN_FAILED_FLAG))
				{
					transformer.setParameter(ViewerSecurityManager.LOGIN_FAILED_FLAG, "true");					
				}
			}
			
			// Set a new local error listener for the transformer.
			transformer.setErrorListener(aTransformError);
			
			// Use the cached (or not) reportXML
			DocumentInfo anXMLSource = getXMLSourceDocument(tFactory, aSourceDocumentFullPath, aFactoryErrorListener);
			transformer.transform(anXMLSource, new StreamResult(theResultString));
		}
		catch (XPathException anXPathEx)
		{
			// Bad characters, e.g.
			// Illegal HTML character: decimal 133
			// Character reference "&#24" is an invalid XML character.
			// Premature end of file - reportXML.xml is 0KB
			// Ignore the client abort exception.
			anXPathEx.printStackTrace(aPrintWriter);
			String aMessage = anXPathEx.getMessageAndLocation();
			
			// Absorb client abort messages - e.g. pressed stop or clicked on a link
			// before the current response completed. They raise XPath Exceptions...
			if(aMessage.contains("ClientAbortException"))
			{
				// Do nothing - just absorb the exception.
			}
			else
			{
				reportErrorMessage(theRequest, theResponse, XPATH_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");				
			}
		}			
		
		catch (TransformerConfigurationException aStyleSheetError)
		{
			// e.g. XPath syntax error at char 0 on line 56 in {}:
			String aMessage = aStyleSheetError.getMessageAndLocation();
			aStyleSheetError.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");			
		}
					
		catch (Exception anEx) 
		{
			// Handle the error message properly.
			anEx.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");			
		}
	}
	
	/**
	 * Get a full path to the repository XML ready for transformers
	 * @param theRepositoryXML the name of the repository XML to use.
	 * @return the path to the repository XML file
	 */
	protected String getRepositoryXMLPath(String theRepositoryXML)
	{
		String aRepositoryXML = theRepositoryXML;
		if(aRepositoryXML == null)
		{
			aRepositoryXML = itsServletContext.getInitParameter("defaultReportFile");
		}
		
		String xmlFile = itsContextPath + aRepositoryXML;
		return xmlFile;
	}
	
	/**
	 * Perform a query using XSL on the specified XML source document
	 * @param theRequest the original servlet request - for error reporting 
	 * @param theResponse the original servlet response - for error reporting
	 * @param theSourceDocumentFullPath the full path to the source XML document to query
	 * @param theQueryXSL the relative path to the XSL in which the query is contained
	 * @return a string of results, the format of which is determined by the query XSL
	 */
	protected String doTransformQuery(HttpServletRequest theRequest,
									  HttpServletResponse theResponse,
									  String theSourceDocumentFullPath, 
									  String theQueryXSL)
	{
		String aQueryResult = "";
		StringWriter aStringWriter = new StringWriter();
		PrintWriter aPrintWriter = new PrintWriter(aStringWriter);
		
		// Create it by querying the repository
		String aQueryXSL = theQueryXSL;
		
		// Create a separate Error lister for the cached factory 
		ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
		// And for the local transformer
		ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactoryImpl tFactory = getTransformerFactory(theSourceDocumentFullPath, aFactoryErrorListener);

			// Make sure we have the correct transform factory error listener especially if it has been cached
			aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();
			
			String aQueryFullPath = itsContextPath + aQueryXSL;
			File anXSLFile = new File(aQueryFullPath);
			Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
			
			// Set a new local error listener for the transformer.
			transformer.setErrorListener(aTransformError);
			
			// Use the cached (or not) reportXML
			DocumentInfo anXMLSource = getXMLSourceDocument(tFactory, theSourceDocumentFullPath, aFactoryErrorListener);
			transformer.transform(anXMLSource, new StreamResult(aStringWriter));
			aQueryResult = aStringWriter.toString();
		}
		catch (XPathException anXPathEx)
		{
			// Bad characters, e.g.
			// Illegal HTML character: decimal 133
			// Character reference "&#24" is an invalid XML character.
			// Premature end of file - reportXML.xml is 0KB
			// Ignore the client abort exception.
			anXPathEx.printStackTrace(aPrintWriter);
			String aMessage = anXPathEx.getMessageAndLocation();
			
			// Absorb client abort messages - e.g. pressed stop or clicked on a link
			// before the current response completed. They raise XPath Exceptions...
			if(aMessage.contains("ClientAbortException"))
			{
				// Do nothing - just absorb the exception.
				aQueryResult = "";
			}
			else
			{
				reportErrorMessage(theRequest, theResponse, XPATH_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
				aQueryResult = "";
			}
		}			
		
		catch (TransformerConfigurationException aStyleSheetError)
		{
			// e.g. XPath syntax error at char 0 on line 56 in {}:
			String aMessage = aStyleSheetError.getMessageAndLocation();
			aStyleSheetError.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
			aQueryResult = "";
		}
								
		catch (Exception anEx) 
		{
			// Handle the error message properly.
			anEx.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, "");
			aQueryResult = "";
		}
		
		return aQueryResult;
	}
}
