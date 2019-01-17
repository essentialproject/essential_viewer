/**
 * Copyright (c)2015 Enterprise Architecture Solutions ltd.
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
 * 20.04.2015	JWC	First coding 
 */

package com.enterprise_architecture.essential.report.security;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.enterprise_architecture.essential.vieweruserdata.User;

import com.enterprise_architecture.essential.report.EssentialMaintenanceService;

/**
 * Servlet implementation class SecureMaintenanceService
 * Secure version of the Maintenance Service which validates that user is authorised to invoke the service
 */
public class SecureMaintenanceService extends EssentialMaintenanceService 
{
	/**
	 * Serial version ID for this class
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * User not authorised response message
	 */
	protected static final String USER_NOT_AUTHORISED = "Sorry, you are not authorised to use this service.";
	
	/**
	 * Servlet parameter defining the default XML file location, used to drive the authorisation
	 */
	protected static final String THE_DEFAULT_XML_PARAM = "defaultReportFile";
	
	/**
	 * Default name of the report XML
	 */
	protected String itsReportXML = "reportXML.xml";

    /**
     * Default constructor. 
     */
    public SecureMaintenanceService() 
    {
    	super();
    }
    
    /**
	 * Override the initialisation and initialise the service
	 */
    @Override
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		
		// Get the configuration properties		
		itsReportXML = getServletContext().getInitParameter(THE_DEFAULT_XML_PARAM);
	}

	/**
	 * Apply authentication and authorisation to invoke the service before performing it
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
	protected void doGet(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException 
	{
		// Authenticate the user
 		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
 		
 		// Get user account URL from session
 		String anAccount = aSecurityMgr.authenticateUserBySession(theRequest);
 		if(anAccount == null)
 		{
 			// User is not yet authenticated, so redirect to login servlet
 			// Get the selected View from the request			
 					
			// Send the request URL as a parameter so we know where to come back to?
			// Render a login View template.
 			performLogin(theRequest, theResponse);
 			return;
 		}
 		
 		// Get the User URI from anAccount
 		User aUser = aSecurityMgr.parseUserData(anAccount);
 		String aUserURI = aUser.getUri();
 		
 		// Get the repository ID from the repository
 		String aRepositoryURI = getRepositoryID(theRequest, theResponse);
 		
    	// Check user is authorised - can they do a publish to this Viewer environment?
 		if(aSecurityMgr.isUserAuthorisedForPublish(aUserURI, aRepositoryURI))
		{	
 			// If authN and authZ, run the service
 			super.doGet(theRequest, theResponse);
		}
 		else
 		{
 			reportResponseMessage(theRequest, theResponse, USER_NOT_AUTHORISED, "");
 		}
	}
    
    /**
     * Perform the login process to authenticate the user. When login completes successfully, the user is returned
     * to the result of the request
     * @param theRequest the user request.
     * @param theResponse the response returned to the user - initially the login page
     */
	protected void performLogin(HttpServletRequest theRequest,
								HttpServletResponse theResponse)
	{
		//System.out.println("ACCESS DENIED");
		ServletContext aServletContext = getServletContext();
		String anXMLSourceDoc = itsReportXML;
		
		StringWriter aStringWriter = new StringWriter();
		PrintWriter aPrintWriter = new PrintWriter(aStringWriter);
		String aContextPath = aServletContext.getRealPath("") + System.getProperty("file.separator") ;
		String aSourceDocumentFullPath = aContextPath + anXMLSourceDoc;
		String aLoginView = aContextPath + SecureEssentialViewerEngine.LOGIN_TEMPLATE;
		
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactory aFactory = TransformerFactory.newInstance();
			
			// Make sure we have the correct transform factory error listener especially if it has been cached			
			File anXSLFile = new File(aLoginView);
			Transformer transformer = aFactory.newTransformer(new StreamSource(anXSLFile));
			
			// Set transformer parameter for the original requested URL
			String aCurrentURL = theRequest.getServletPath();	
			aCurrentURL = aCurrentURL + "?" + theRequest.getQueryString();
			
			// Remove leading '/' on this URL
			aCurrentURL = aCurrentURL.substring(1);		
			
			transformer.setParameter(SecureEssentialViewerEngine.PRE_LOGIN_URL, aCurrentURL);
			
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
			
			File anXMLSource = new File(aSourceDocumentFullPath);			
			transformer.transform(new StreamSource(anXMLSource), new StreamResult(theResponse.getOutputStream()));
		}			
		catch (Exception anEx) 
		{
			// Handle the error message properly.
			anEx.printStackTrace(aPrintWriter);
			reportResponseMessage(theRequest, theResponse, anEx.getMessage(), "");			
		}
	}
	
	/**
	 * Get the Security ID of the current repository
	 * @param theSourceDocumentFullPath theSourceDocumentFullPath the full (from the Servlet Context) for the source document. This full file name defines the XML source URI.
	 * @param theContextPath the full (from the Servlet Context) path from which query templates should be loaded.
	 * @param theErrorListener an Error Listener to catch any errors found while building the specified XML Source document.
	 * @return a string containing the ID of the repository that is being queried by the current viewer
	 */
	protected synchronized String getRepositoryID(HttpServletRequest theRequest, 
												  HttpServletResponse theResponse)
	{
		String aRepositoryID = (String) getServletContext().getAttribute(SecureEssentialViewerEngine.VIEWER_REPOSITORY_ID);
		
		// Check to see if it has been set and the document loaded
		if(aRepositoryID == null)
		{			
			// Create it by querying the repository
			String aQueryXSL = (String)getServletContext().getInitParameter(SecureEssentialViewerEngine.VIEWER_REPOSITORY_ID_QUERY);
			String aResponsePageXML = getServletContext().getRealPath(itsReportXML);
			StringWriter aStringWriter = new StringWriter();
			
			// Create a new Transformer that uses the specified View template
			TransformerFactory aFactory = TransformerFactory.newInstance();
			try
			{
				// Set the message and stack trace parameters 
				File aView = new File(getServletContext().getRealPath(aQueryXSL));
				Transformer aTransformer = aFactory.newTransformer(new StreamSource(aView));			
				
				try
				{
					File anXML = new File(aResponsePageXML);
					aTransformer.transform(new StreamSource(anXML), new StreamResult(aStringWriter));
					aRepositoryID = aStringWriter.toString();					
				}
				catch (Exception anEx)
				{
					// report the error to the console - if we can't produce the Error View
					anEx.printStackTrace();

					// Then report this via the serious fail static report page.
					theResponse.sendRedirect(FATAL_ERROR_REPORT_PAGE);
				}
			}
			catch (Exception anEx)
			{
				// report the error to the console - if we can't produce the Error View
				anEx.printStackTrace();

				// Then report this via the serious fail static report page.
				try
				{
					theResponse.sendRedirect(FATAL_ERROR_REPORT_PAGE);
				}
				catch (IOException anIOEx)
				{
					System.err.println(IOEX_IN_FATAL_ERROR_REPORT_MESSAGE);
					anIOEx.printStackTrace();
				}
			}			
			// Add the security config to the singleton
			getServletContext().setAttribute(SecureEssentialViewerEngine.VIEWER_REPOSITORY_ID, aRepositoryID);			
		}
		
		return aRepositoryID;
	}
}
