/**
 * Copyright (c)2012-2020 Enterprise Architecture Solutions ltd. and the Essential Project
 * contributors.
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
 * 16.01.2012	JWC	First implementation of shared Essential Viewer Engine
 * 02.02.2012	JWC Improved use of ErrorListeners - one for cached TransformerFactory, one per Transformer.
 * 27.03.2012	JWC Added 'theURLFullPath' to set of parameters sent to the View Templates.
 * 25.06.2012	JWC Essential Viewer 3.1. Added the support for i18N.
 * 30.01.2013	JWC Added switch (in web.xml) to control page history tracking.
 * 31.01.2013	JWC Addition XSL paramter to show page history switch status
 * 01.02.2013	JWC New page history tracking mechanism
 * 06.02.2013	JWC Additional XSL parameter for the current subject instance
 * 05.06.2013	JWC Added viewerHomePage XSL parameter
 * 06.06.2013	JWC Revised visit history hash mapping
 * 31.07.2013	JWC Defensive programming for handling language cookie and web-cache language param
 * 20.01.2015	JWC Updates to add security hooks
 * 27.03.2019	JWC Added Anti-CSRF capability
 * 28.06.2019	JWC Added use of log4J
 * 14.01.2020	JWC Upgraded to use Saxon 9.9.1
 * 25.02.2020	JWC	Rolled back to use Saxon 9.2.1.5
 * 29.05.2020	JWC Applied upgrade to Saxon 9.9.1
 */
package com.enterprise_architecture.essential.report;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.sf.saxon.Configuration;
import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.om.TreeInfo;
import net.sf.saxon.trans.XPathException;

/**
 * Class to encapsulate the Essential Viewer Engine, simplifying the construction of Servlets
 * and JSPs and ensuring a consistent handling of the XSL transformations and error handling and reporting.
 * This class has been re-factored from of the Essential Viewer Engine v3.0 servlet.<br/>
 * Usage: Assuming request and response are the HttServletRequest and HttpServletResponse received by the Servlet or JSP. Note
 * that JSPs should use <tt>getServletConfig().getServletContext()</tt> to get the servlet context.<br/>
 * <pre>
 * StringWriter aStreamResult = new StringWriter();
 * EssentialViewerEngine anEngine = new EssentialViewerEngine(getServletContext());
 * boolean isSuccess = anEngine.generateView(request, response, aStreamResult);
 * if(isSuccess)
 * {
 *     response.getWriter().print(aStreamResult.toString());
 *     response.getWriter().flush();
 * }
 *
 * </pre>
 * The Essential Viewer Engine expects the following, RESERVED, request parameters:
 * <ul>
 * <li>XML - the name of the Essential repository snap-shot XML</li>
 * <li>XSL - the name of the XSL file that defines the report to run</li>
 * <li>LABEL - a textual string describing the page that is being rendered and used by the Page History
 * functionality. Typically, when defining a link this is the label of the page that is being linked to.</li>
 * <li>PMA - the instance ID of the repository element that is being reported on</li>
 * <li>PMA2 - <i>Optional.</i> Used by some reports to control hiding/unhiding of items on the report and available for use
 * as required by reports</li>
 * <li>PMA3, PMA4 - <i>Optional.</i> Additional optional parameters available for use by reports as required.</li>
 * <li>CT - <i>Optional.</i> The Content Type that should be used in the response from the Servlet. For an Excel file response use application/ms-excel
 * <li>FILE - <i>Optional, but if CT is used, required</i>. The name of the output file that the response will display in the browser's download dialog, e.g. myReport.xls
 * <li>an optional, user-defined set of name/value pairs using the HTTP GET format, e.g. name1=value1&name2=value2
 * <li>PGH - an optional switch to control the page history tracking in the engine. Set to any value, e.g.<tt>0</tt>, to instruct the engine NOT to add the request
 * that it receives to the page history. This overrides the page history tracking that has been set on the Essential Viewer Engine object for the duration of the request only.</li>
 * </ul>
 * <br/>
 * The selected View Template / Report has the following parameters available to use in the XSL:
 * <ul>
 * <li>param1 - the instance ID of the instance in focus for the View / Report.</li>
 * <li>param2 - if specified in the client request, a reserved parameter name that can contain any value required by the View / Report. </li>
 * <li>param3 - if specified in the client request, a reserved parameter name that can contain any value required by the View / Report. </li>
 * <li>param4 - if specified in the client request, a reserved parameter name that can contain any value required by the View / Report. </li>
 * <li>reposXML - the name of the XML document that is holding the Essential repository snapshot that should be used for queries.</li>
 * <li>theURLPrefix - the full URL prefix of the Servlet that can be used to define full-path hyperlinks. e.g. 'http://localhost:8080/essential_viewer/'</li>
 * <li>theURLFullPath - the full URL path (including query string) to the current view to provide links to the current view</li>
 * <li>i18n - the ID of the currently selected language in the IETF format, e.g. en-gb</li>
 * <li>pageHistoryTracking - flags whether or not view page history tracking is enabled or not. Values are 'on' or 'off'</li>
 * <li>theCurrentURL - the relative path for the currently requested URL, e.g. 'report?...'. Intended for use by the Page History template</li>
 * <li>theCurrentXSL - the relative path to the selected View Template XSL file, e.g. application/core_app_def.xsl. Intended for use by the Page History template</li>
 * <li>theSubjectID - the instance ID of the instance that is the subject for the view. Same value as param1 but intended for use by the Page History template</li>
 * <li>theViewerHomePage - the name of the selected portal homepage XSL file to use.
 * <li>A set of user-defined parameters, set as per the contents of theUserParams in the request. These parameters are defined using HTTP GET request
 * parameters, e.g. name1=value1&name2=value2 will provide parameters 'name1' and 'name2' to the View / Report.</li>
 * </ul>
 * <br/>
 * On error, the following parameters are sent to the stylesheet defined by the 'theErrorView' init-param in web.xml.
 * The names of the parameters are defined by the CONSTANT VALUES.
 * <ul>
 * <li>THE_FRIENDLY_MESSAGE_PARAM (theFriendlyMessage) - the user-friendly error message generated by the exception handlers in this class as a String.</li>
 * <li>THE_MESSAGE_PARAM (theMessage) - the error message generated by the exception handlers in this class as a String.</li>
 * <li>THE_STACK_TRACE_PARAM (theStackTrace) - the full stack trace of the exception that was raised as a String</li>
 * <li>THE_TRANSFORMER_MESSAGE_PARAM (theTransformerError) - the error message caught by the ErrorListeners of this class as a String.</li>
 * </ul>
 * The Engine expects a set of Servlet Context parameters to be set in the web.xml file:
 * <ul>
 * <li>homeXSLFile</li>
 * <li>homeLabel</li>
 * <li>defaultReportFile</li>
 * <li>theErrorXML</li>
 * <li>theErrorView</li>
 * <li>transfomerAttributeName</li>
 * <li>pageHistoryTracking</li>
 * <li>viewerHomePage</li>
 * </ul>
 * @author Jonathan W. Carter info@enterprise-architecture.com
 * @version 5.0
 * <br/>
 * Version 2.0 delivers the first of a series of updates for Essential Viewer 3.<br/>
 * Version 2.1 Adds the capability to pass user-defined, arbitrary list of parameters to a
 * View template in a hyperlink. In addition to the reserved parameters, additional, user-defined parameters
 * can be passed in theUserParams parameter as HTTP GET name/value pairs in the form: <i>parameter=value&amp;parameter=value</i>. Note that
 * in the XSL, the '&' should be 'escaped' using the <i>'&amp;amp;'</i> value.<br/>
 * Version 2.2 Improves error handling by introducing the Error View to report the error messages and exception details <br/>
 * Version 2.3 Re-works the management of the page history.<br/>
 * Version 3.0 Caches the source XML document in a Servlet variable to improve performance and reduce memory.<br/>
 * Version 3.1 Re-works version 3.0 to produce separate EssentialViewerEngine class to be used by Servlets and JSPs.
 * Version 3.2 Adds the XSL parameter, theURLFullPath<br/>
 * Version 3.3 supporting Essential Viewer 3.1, adds the i18N support.<br/>
 * Version 3.4 Adds servlet context parameter to control page history tracking and new page tracking mechanism. <br/>
 * Version 3.5 Adds servlet context parameter to control portal redirect, replacing the Home Page Report Constant (in repository) <br/>
 * Version 4.1 Adds defensive programming to ensure language cookie and cache language param are not out of sync. <br/>
 * Version 5.0 Adds framework and hooks for fine-grained security implementations.<br/>
 * <br/>
 *
 */
public class EssentialViewerEngine
{

	/**
	  * XSL Parameter containing the URL prefix, e.g. http://hostname:8080/essential_viewer/
	  * Note that it does include the trailing '/' character
	  * @since 2.0
	  *
	  */
	 public static final String URLPREFIX_PARAM = "theURLPrefix";

	 /**
	  * XSL Paramter containing the full URL path, e.g. http://hostname:8080/essential_viewer/report?XML=reportXML.xml&PMA=
	  * @since 3.2
	  */
	 public static final String URLFULL_PATH_PARAM = "theURLFullPath";

	 /**
	  * XSL Parameter containing the current, relative URL, e.g. report?XML=reportXML.xml&XSL=home.xsl
	  * @since 3.4
	  */
	 public static final String CURRENT_URL_PARAM = "theCurrentURL";

	 /**
	  * XSL Parameter containing the name of the current XSL file (View Template) that has been requested
	  * @since 3.4
	  */
	 public static final String CURRENT_XSL_PARAM = "theCurrentXSL";

	 /**
	  * XSL Parameter containing the instance ID of the current subject, or empty string if no subject instance
	  */
	 public static final String CURRENT_SUBJECT_ID_PARAM = "theSubjectID";

	 /**
	  * The name of the Servlet attribute containing [potentially] the full URL path of the originally requested View.
	  * Enables view chains (e.g. UML rendering) to pass the originally requested URL to the engine.
	  * @since 3.2
	  */
	 public static final String REQUESTED_URL_FULL_PATH_PARAM = "theRequestedURLFullPath";

	 /**
	  * XSL parameter name for the error message value
	  * @since 2.2
	  */
	 public static final String THE_MESSAGE_PARAM = "theMessage";

	 /**
	  * XSL parameter name for the error stack trace value
	  * @since 2.2
	  */
	 public static final String THE_STACK_TRACE_PARAM = "theStackTrace";

	 /**
	  * XSL parameter name for the transformer error message value
	  * @since 2.2
	  */
	 public static final String THE_TRANSFORMER_MESSAGE_PARAM = "theTransformerError";

	 /**
	  * XSL parameter name for the friendly message error value.
	  * @since 2.3
	  */
	 public static final String THE_FRIENDLY_MESSAGE_PARAM = "theFriendlyMessage";

	 /**
	  * XSL parameter name for the page history HTML option code
	  * @since 2.3
	  */
	 public static final String THE_PAGE_HISTORY_PARAM = "pageHistory";

	 /**
	  * Web.xml parameter holding the filename of the XML document used to drive the Error View
	  * @since 2.2
	  */
	 public static final String THE_ERROR_XML_PARAMETER = "theErrorXML";

	 /**
	  * Web.xml parameter holding the filename of the XSL template for the Error View
	  * @since 2.2
	  */
	 public static final String THE_ERROR_VIEW_PARAMETER = "theErrorView";

	 /**
	  * URL of the Essential Viewer Fatal error static page.
	  */
	 public static final String FATAL_ERROR_REPORT_PAGE = "platform/fatal_essential_error.html";

	 /**
	  * The name of the servlet init parameter, whose value specifies the name of the Servlet Attribute
	  * in which the transformer and source XML will be cached.
	  */
	 public static final String XSL_TRANSFORM_FACTORY_PARAM = "transfomerAttributeName";

	 /**
	  * The name of the XSL parameter that contains the selected i18n language code.
	  */
	 public static final String VIEWER_I18N_PARAM = "i18n";

	 /**
	  * Error message suggestion for zero-size XML repository snapshot
	  * @since 2.2
	  */
	 private static final String ZERO_SIZE_XML_MESSAGE = "The XML repository snapshot file is empty. Please try to re-publish your repository snapshot from the modelling environment.";

	 /**
	  * The name of the request parameter containing the requested instance ID
	  * @since 5.0
	  */
	 protected static final String REQUESTED_INSTANCE_ID_PARAM = "PMA";

	 /**
	  * Initial 'friendly' error message for file not found
	  * @since 2.2
	  */
	 protected static final String FILE_NOT_FOUND_MESSAGE = "Essential Viewer could not find the requested file";

	 /**
	  * Initial 'friendly' error message for stylesheet error messages
	  * @since 2.2
	  */
	 protected static final String XSL_STYLESHEET_ERROR_MESSAGE = "Essential Viewer encountered an error with the request View Template XSL stylesheet";

	 /**
	  * Initial 'friendly' error message for transform XPath errors
	  * @since 2.2
	  */
	 protected static final String XPATH_ERROR_MESSAGE = "Essential Viewer encountered an error while generating the requested View";

	 /**
	  * Initial 'friendly' error message for MalformedURLException errors
	  * @since 2.2
	  */
	 protected static final String MALFORMED_URL_MESSAGE = "Essential Viewer found invalid characters in the file path to the requested View Template XSL document. Check your Web Application deployment path and the defined path to the selected View Template";

	 /**
	  * Separator to use in the visit history parameter string to separate each individual visit
	  */
	 protected static final String VISIT_SEPARATOR = "\u00A7";

	 /**
	  * Separator to use in the visit history parameter string to separate the URL from the label in each visit.
	  */
	 protected static final String VISIT_URL_LABEL_SEPARATOR = "\u00B1";

	 /**
	  * Error message raised on System.err when all attempts to report an error have failed.
	  */
	 private static final String IOEX_IN_FATAL_ERROR_REPORT_MESSAGE = "Essential Viewer FATAL ERROR: Cannot redirect to FATAL_ERROR_REPORT_PAGE.";

	 /**
	  * Error message raised when the shared XML source document cannot be found.
	  */
	 protected static final String NO_XML_SOURCE_MESSAGE = "Could not find source XML document";

	 /**
	  * Request parameter for the selected language used to control web caching engines.
	  * Should always be in sync with the VIEWER_I18N_PARAM value
	  * @since 4.1
	  */
	 protected static final String WEB_CACHE_LANGUAGE_PARAM = "cl";

	 /**
 	  * Logger for the current class
	  */
	 private static final Logger itsLog = LoggerFactory.getLogger(EssentialViewerEngine.class);


	/**
	  * The set of reserved XSL parameter names
	  * @since 2.1 of Essential Viewer Engine
	  */
	 //private static LinkedHashSet<String> itsViewerReservedParameters;
	 protected static LinkedHashSet<String> itsViewerReservedParameters;

	 /**
	  * Maintain the Servlet Context for this instance of the Essential Viewer Engine
	  */
	 protected ServletContext itsServletContext = null;

	 /**
	  * Flag to run the engine without tracking the page history.
	  * When set to false, any existing history is passed on but the most recent request is not added to the history
	  */
	 private boolean itIsTrackingHistory;

	/**
	 * Name of the Servlet Context parameter that holds the value of the page history tracking switch
	 * When set to "on" page history tracking is enabled, when set to "off" no page visit history is maintained
	 * @since 3.4
	 */
	private final static String PAGE_HISTORY_TRACKING_PARAM = "pageHistoryTracking";

	/**
	 * Switch value when page history tracking is enabled.
	 * @since 3.4
	 */
	public final static String PAGE_TRACKING_ON = "on";

	/**
	 * Switch value when page history tracking is disabled.
	 * @since 3.4
	 */
	public final static String PAGE_TRACKING_OFF = "off";

	/**
	 * Name of the Servlet Context parameter that holds the value for the home page XSL file that
	 * the Viewer should use.
	 * @since 3.5
	 */
	public final static String VIEWER_HOME_PAGE_PARAM = "viewerHomePage";

	/**
	 * XSL parameter containing the name of the XSL file to use for the homepage of the Viewer.
	 */
	public final static String VIEWER_HOME_PAGE_XSL_PARAM = "theViewerHomePage";

	/**
	 * Error message for missing viewerHomePage context parameter.
	 * @since 3.5
	 */
	private static final String NO_VIEWER_HOME_PAGE_IN_WEB_XML_MESSAGE = "WARNING: Essential Viewer could not find the required 'viewerHomePage' context parameter in the web.xml. Using factory default";

	/**
	 * Default home page in case the web.xml does not define this.
	 * @since 3.5
	 */
	public final static String VIEWER_HOME_PAGE_FACTORY_DEFAULT = "home.xsl";

	/**
	 * XSL parameter that is passed to the transformer telling the View templates whether
	 * the page history tracking is on or not.
	 * Values will be the same as
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#PAGE_TRACKING_ON PAGE_TRACKING_ON and
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#PAGE_TRACKING_OFF PAGE_TRACKING_OFF
	 * @since 3.4
	 */
	public final static String VIEWER_PAGETRACKING_PARAM = "trackPageHistory";

	/**
	 * Default constructor for the Viewer Engine.
	 * Initialise the list of reserved request parameters
	 * @param theServletContext the servlet context object from the Servlet / JSP that is creating the instance
	 * of the EssentialViewerEngine.
	 */
	public EssentialViewerEngine(ServletContext theServletContext)
	{
		// Initialise the reserved parameters
		initialiseReservedParameters();

		// Set the Servlet context variables
		itsServletContext = theServletContext;

		// Read the context parameter and decide whether to set the page history tracking on or off
		String aPageTrackSwitch = theServletContext.getInitParameter(PAGE_HISTORY_TRACKING_PARAM);
		if(aPageTrackSwitch.equals(PAGE_TRACKING_ON))
		{
			itIsTrackingHistory = true;
		}
		else
			itIsTrackingHistory = false;

	}

	/**
	 * Alternative constructor for the Essential Viewer Engine that enables user to control whether this
	 * instance of the Engine should be tracking - that is, adding to - the page / view history.
	 * @param theServletContext the servlet context object from the Servlet / JSP that is creating the instance
	 * of the EssentialViewerEngine.
	 * @param theIsTrackHistory Set to true to add to the pages / views requested history, false to pass the existing history
	 * through without adding to it. This is particularly useful for sub-views such as SVG renderings that are delivering
	 * components of a View page and should therefore not appear in the View Pages History.
	 */
	public EssentialViewerEngine(ServletContext theServletContext, boolean theIsTrackHistory)
	{
		// Initialise the reserved parameters
		initialiseReservedParameters();

		// Set the Servlet context variables
		itsServletContext = theServletContext;
		itIsTrackingHistory = theIsTrackHistory;
	}

	/**
	 * Generate the requested view into theResultString based on the request parameters specified in theHTTPServletRequest
	 *
	 * @param theRequest the request received by the Servlet / JSP that is using the Engine.
	 * @param theResponse the response object for the request received by the Servlet / JSP that is using the Engine. Required in case
	 * error handling is required, which will build an alternative response.
	 * @param theResultString a result string into which the generated View should be delivered.
	 * @return true on success of creating the requested View, false on error. Note that error handling includes
	 * reporting of the error with details, and on a 'false' return, the calling Servlet / JSP should NOT write any
	 * further content to theResponse object
	 * @since 6.10 - refactored to call new renderView() method.
	 * @throws ServletException
	 * @throws IOException
	 */
	public boolean generateView(HttpServletRequest theRequest,
		 						HttpServletResponse theResponse,
		 						StringWriter theResultString) throws ServletException, IOException
	{
		// Just call the render method in open-source configuration
		return renderView(theRequest, theResponse, theResultString);
	}

	/**
	 * Generate the requested view into theResultString based on the request parameters specified in theHTTPServletRequest
	 * and avoiding any application of security/filter, e.g. in support of the ReportAPIEngine.
	 * @param theRequest the request received by the Servlet / JSP that is using the Engine.
	 * @param theResponse the response object for the request received by the Servlet / JSP that is using the Engine. Required in case
	 * error handling is required, which will build an alternative response.
	 * @param theResultString a result string into which the generated View should be delivered.
	 * @return true on success of creating the requested View, false on error. Note that error handling includes
	 * reporting of the error with details, and on a 'false' return, the calling Servlet / JSP should NOT write any
	 * further content to theResponse object.
	 */
	public boolean renderView(HttpServletRequest theRequest,
							  HttpServletResponse theResponse,
							  StringWriter theResultString) throws ServletException, IOException
	{
		boolean isSuccess = true;
		// Find the page visit history from the request in here, rather than the calling Servlet
		HttpSession aSess = theRequest.getSession();
		HashMap<String, String> visitedPages = (HashMap<String, String>)aSess.getAttribute("visitedPages");

		// If no visited pages are found, create a new set.
		if(visitedPages == null)
		{
			visitedPages = new HashMap<String, String>();
			theRequest.getSession().setAttribute("visitedPages", visitedPages);
		}

		// Organised the visit page history, now produce the requested View
		String FS = System.getProperty("file.separator");
		String xslFile = ScriptXSSFilter.filter(theRequest.getParameter("XSL"));
		String xmlFile, label;
		String paramValue = "";
		String paramValue2 = "";
		String paramValue3 = "";
		String paramValue4 = "";
		String aCacheLang = "";
		String aPageHistoryTrack = ScriptXSSFilter.filter(theRequest.getParameter("PGH"));
		boolean isPageHistTrack = true;

		// Get the homepage context parameter
		String aViewerHomePage = itsServletContext.getInitParameter(VIEWER_HOME_PAGE_PARAM);
		if(aViewerHomePage == null)
		{
			// Report an error to the error logs
			itsLog.error(NO_VIEWER_HOME_PAGE_IN_WEB_XML_MESSAGE);
			aViewerHomePage = VIEWER_HOME_PAGE_FACTORY_DEFAULT;
		}

		// Check to see if the page history tracking has been overridden
		if(aPageHistoryTrack != null)
		{
			isPageHistTrack = false;
		}

		//If no xsl file is provided, then go to the default page (usually home)
		if(xslFile == null)
		{
			xslFile = itsServletContext.getInitParameter("homeXSLFile");
			xmlFile = itsServletContext.getInitParameter("defaultReportFile");
			label = itsServletContext.getInitParameter("homeLabel");
		}
		else
		{
			//otherwise go to the requested page
			xmlFile = ScriptXSSFilter.filter(theRequest.getParameter("XML"));
			xslFile = ScriptXSSFilter.filter(theRequest.getParameter("XSL"));
			label = ScriptXSSFilter.filter(theRequest.getParameter("LABEL"));
			paramValue = ScriptXSSFilter.filter(theRequest.getParameter(REQUESTED_INSTANCE_ID_PARAM));
			paramValue2 = ScriptXSSFilter.filter(theRequest.getParameter("PMA2"));
			paramValue3 = ScriptXSSFilter.filter(theRequest.getParameter("PMA3"));
			paramValue4 = ScriptXSSFilter.filter(theRequest.getParameter("PMA4"));
		}

		// 31.07.2013 JWC
		// Get the selected language that the web cache will use
		aCacheLang = ScriptXSSFilter.filter(theRequest.getParameter(WEB_CACHE_LANGUAGE_PARAM));

		// 05.11.2008 JWC
		// Make sure label is set to something meaningful to prevent NULL pointer
		// exception in code that expects this to be set. This shouldn't happen
		// but we should handle slips in custom reports gracefully.
		if(label == null)
		{
			// It's not been set by the request parameter, LABEL
			// so set it to the default
			label = itsServletContext.getInitParameter("homeLabel");
		}

		String origXMLFile = xmlFile;

		/**
		 * 01.02.2013 JWC
		 */
		String aCurrentURL = theRequest.getServletPath();
		aCurrentURL = aCurrentURL + "?" + theRequest.getQueryString();

		// Remove leading '/' on this URL
		aCurrentURL = ScriptXSSFilter.filter(aCurrentURL.substring(1));

		String aCurrentXSL = xslFile;
		/**
		 * 01.02.2013 JWC - end.
		 */

		// Generate the visited pages HTML fragment
		// If page history tracking is disabled, visitedPages will be empty
		String visitXSLParam = createPageVisitXSLParameter(visitedPages);

		if(itIsTrackingHistory && isPageHistTrack)
		{
			//if the requested page is not already in the page visits Hashmap then add it
			String visitKey = aCurrentURL;

			if(!visitedPages.values().contains(visitKey))
			{
				//add the URL and label to the visited pages Hashmap
				visitedPages.put(visitKey, label);
			}
		}

		//	Get the real path for xml and xsl files;
		String ctx = itsServletContext.getRealPath("") + FS;
		xslFile = ctx + xslFile;
		xmlFile = ctx + xmlFile;

		// 07.11.2011 JWC	Find the URL prefix
		String aRequestURL = theRequest.getRequestURL().toString();
		String aServletPath = theRequest.getServletPath();
		String aURLList[] = aRequestURL.split(aServletPath);

		// If the last character of the URL prefix is not '/', add it
		String aURL = aURLList[0];
		String aURLPrefix = aURL;
		if(aURL.charAt(aURL.length()-1) != '/')
		{
			aURLPrefix = aURL.concat("/");
		}

		// 27.03.2012 JWC 	Find the URL full path
		String aRequestURLFullPath = getRequestURLFullPath(theRequest);

		// 25.06.2012 JWC 	Find the selected i18n language selection or set default if not found
		EssentialLanguageCookie aLangCookie = new EssentialLanguageCookie(itsServletContext);
		String anI18NCode = aLangCookie.getLanguage(theRequest, theResponse);
		// end of i18n, 25.06.2012

		// Ensure that the Cache Language and Cookie language are in sync
		if(aCacheLang != null && aCacheLang.length() > 0)
		{
			if(!aCacheLang.equals(anI18NCode))
			{
				anI18NCode = aCacheLang;
				aLangCookie.setLanguage(theRequest, theResponse, anI18NCode);
			}
		}

		StringWriter aStringWriter = new StringWriter();
		PrintWriter aPrintWriter = new PrintWriter(aStringWriter);

		// Generate the required report
		// Create a separate Error lister for the cached factory
		ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
		// And for the local transformer
		ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactoryImpl tFactory = getTransformerFactory(xmlFile, aFactoryErrorListener);

			// 02.02.2012 JWC
			// Make sure we have the correct transform factory error listener especially if it has been cached
			aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();

			// 09.11.2011 JWC Updated to use File object to improve cross-platform file path
			// tolerance for paths to XSL files.
			File anXSLFile = new File(xslFile);
			Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
			// Set a new local error listener for the transformer.
			transformer.setErrorListener(aTransformError);

			if(paramValue != null) {
				transformer.setParameter("param1", paramValue);
			}
			if(paramValue2 != null) {
				transformer.setParameter("param2", paramValue2);
			}
			if(paramValue3 != null) {
				transformer.setParameter("param3", paramValue3);
			}
			if(paramValue4 != null) {
				transformer.setParameter("param4", paramValue4);
			}
			if(origXMLFile != null) {
				transformer.setParameter("reposXML", origXMLFile);
			}
			// 07.11.2011 JWC	Set theURLPrefix parameter on the XSL
			if(aURLPrefix != null)
			{
				transformer.setParameter(URLPREFIX_PARAM, aURLPrefix);
			}
			// 27.03.2012 JWC	Set theURLFullPath parameter to the XSL engine
			if(aRequestURLFullPath != null)
			{
				transformer.setParameter(URLFULL_PATH_PARAM, aRequestURLFullPath);
			}
			transformer.setParameter(THE_PAGE_HISTORY_PARAM, visitXSLParam);

			// 25.06.2012 JWC 	Set the selected i18n language code
			if(anI18NCode != null)
			{
				transformer.setParameter(VIEWER_I18N_PARAM, anI18NCode);
			}

			// 31.01.2013 JWC	Set the trackPageHistory flag
			if(itIsTrackingHistory)
			{
				transformer.setParameter(VIEWER_PAGETRACKING_PARAM, PAGE_TRACKING_ON);
			}
			else
			{
				transformer.setParameter(VIEWER_PAGETRACKING_PARAM, PAGE_TRACKING_OFF);
			}
			// 01.02.2013 JWC Add the current URL param
			transformer.setParameter(CURRENT_URL_PARAM, aCurrentURL);
			transformer.setParameter(CURRENT_XSL_PARAM, aCurrentXSL);
			// 06.02.2013 JWC Add the current subject ID param
			// Add some guard code during migration to Saxon 9.9
			if(paramValue != null)
			{
				transformer.setParameter(CURRENT_SUBJECT_ID_PARAM, paramValue);
			}
			else
			{
				itsLog.debug("Null value in variable: paramValue");
			}

			// Add the home page XSL parameter
			transformer.setParameter(VIEWER_HOME_PAGE_XSL_PARAM, aViewerHomePage);

			// Get all the user-defined parameters from the request. We've
			// already handled the reserved parameters.
			Enumeration<String> aParamNameListIt = theRequest.getParameterNames();
			while(aParamNameListIt.hasMoreElements())
			{
				// Find the name of the parameter
				String aParamName = ScriptXSSFilter.filter(aParamNameListIt.nextElement());

				// Ignore any reserved parameters
				if(!isParameterReserved(aParamName))
				{
					// Get the parameter value from the request
					String aValue = ScriptXSSFilter.filter(theRequest.getParameter(aParamName));

					// Set the parameter on the Transformer.
					transformer.setParameter(aParamName, aValue);
				}
			}

			// 27.03.2019 JWC - Add the X-CSRF-TOKEN to the set of parameters
			transformer.setParameter(LoadCSRF.CSRF_TOKEN, theRequest.getSession().getAttribute(LoadCSRF.CSRF_TOKEN));

			// 29.01.2015 JWC Add any additional parameters
			setTransformerParameters(transformer, theRequest, theResponse);

			try
			{
				// 15.11.2011 JWC Updated to use cached XML document.
				TreeInfo anXMLSource = getXMLSourceDocument(tFactory, xmlFile, aFactoryErrorListener);
				transformer.transform(anXMLSource, new StreamResult(theResultString));
			}
			// IMPROVE ERROR HANDLING OF THE TRANSFORM HERE
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
					reportErrorMessage(theRequest, theResponse, XPATH_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, visitXSLParam);
					isSuccess = false;
				}
			}

			catch (TransformerConfigurationException aStyleSheetError)
			{
				// e.g. XPath syntax error at char 0 on line 56 in {}:
				String aMessage = aStyleSheetError.getMessageAndLocation();
				aStyleSheetError.printStackTrace(aPrintWriter);
				reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, visitXSLParam);
				isSuccess = false;
			}
			catch (Exception anEx)
			{
				// Handle the error message properly.
				itsLog.error("Unmanaged exception caught: {}", anEx);
				reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, visitXSLParam);
				isSuccess = false;
			}
		}
		catch (TransformerConfigurationException aStyleSheetError)
		{
			// e.g. XPath syntax error at char 0 on line 56 in {}:
			// File Not Found
			// MalformedURLException
			// XTSE0650: No template exists
			String aMessage = aStyleSheetError.getMessageAndLocation();

			aStyleSheetError.printStackTrace(aPrintWriter);
			reportErrorMessage(theRequest, theResponse, XSL_STYLESHEET_ERROR_MESSAGE, aMessage, aStringWriter.toString(), aFactoryErrorListener, aTransformError, visitXSLParam);
			isSuccess = false;
		}
		catch(Exception anEx)
		{
			// Handle the error message properly.
			itsLog.error("Unmanaged exception caught: {}", anEx);
			reportErrorMessage(theRequest, theResponse, "", anEx.getMessage(), aStringWriter.toString(), aFactoryErrorListener, aTransformError, visitXSLParam);
			isSuccess = false;
		}

		return isSuccess;
	}

	/**
	 * Build the XSL String parameter containing the page visits.
	 * Ignore page visits from previous versions of Essential Viewer.
	 * @param theVisits the session variable containing the visit history
	 * @return a structured string where each visit is separated by the VISIT_SEPARATOR character and the URL and Label are separated by the VISIT_URL_LABEL_SEPARATOR
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#VISIT_SEPARATOR VISIT_SEPARATOR
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#VISIT_URL_LABEL_SEPARATOR VISIT_URL_LABEL_SEPARATOR
	 * @since 2.3
	 */
	protected String createPageVisitXSLParameter(HashMap<String, String> theVisits)
	{
		String aVisitParameter = "";

		// Get the visit list keys - the labels
		ArrayList<String> aVisitKeyList = new ArrayList<String>();
		aVisitKeyList.addAll(theVisits.keySet());
		Collections.sort(aVisitKeyList);
		Iterator<String> aVisitKeyIt = aVisitKeyList.listIterator();
		String aVisitKey = "";
		while(aVisitKeyIt.hasNext())
		{
			try
			{
				// Get the URL that matches the key.
				aVisitKey = aVisitKeyIt.next();
				String aVisitLabel = theVisits.get(aVisitKey);

				aVisitParameter = aVisitParameter + aVisitKey + VISIT_URL_LABEL_SEPARATOR + aVisitLabel + VISIT_SEPARATOR;
			}
			catch(ClassCastException aClassCast)
			{
				// Most likely received an Essential Viewer v2 visit history - ignore
			}
		}
		return aVisitParameter;
	}

	/**
	 * Test the name of the specified Servlet Request parameter to see if it is a reserved parameter
	 * or not.
	 * @param theParameterName the parameter name to test
	 * @return true if the parameter name is one of the names reserved by Essential Viewer Engine or false
	 * if the parameter is an allowed user-defined parameter.
	 * @since 2.1
	 */
	protected boolean isParameterReserved(String theParameterName)
	{
		boolean isReserved = false;

		if (itsViewerReservedParameters.contains(theParameterName))
		{
			isReserved = true;
		}

		return isReserved;
	}

	/**
	 * Report error messages to the user using the Error View. At the very least, render theMessage which
	 * is typically the top-level error message from an exception and optionally render theStackTrace.
	 * These values are passed to the Error View as the XSL parameters, <i>theMessage</i> and <i>theStackTrace</i>
	 * @param theRequest the client HTTP request to provide access to the request parameters.
	 * @param theHTTPResponse the response object to reply to the requesting client
	 * @param theFriendlyMessage the user-friendly error message
	 * @param theMessage the error message that has been raised
	 * @param theStackTrace the stack trace from the exception that has reported theMessage.
	 * @param theFactoryErrors the error listener that is being used by the (cached) Transformer Factory.
	 * @param theTransformErrors the error listener that was used by the transformer
	 * @param theVisitHistoryHTML the HTML option list code for the page history, or empty String for no history
	 *
	 */
	protected void reportErrorMessage(HttpServletRequest theRequest,
									  HttpServletResponse theHTTPResponse,
									  String theFriendlyMessage,
									  String theMessage,
									  String theStackTrace,
									  ViewTransformErrorListener theFactoryErrors,
									  ViewTransformErrorListener theTransformErrors,
									  String theVisitHistoryHTML)
	{
		// Check size of reportXML.xml if = 0, report this and suggest re-try
		String aFS = System.getProperty("file.separator");
		String aReportXMLFilename = ScriptXSSFilter.filter(theRequest.getParameter("XML"));
		String aFullPath = itsServletContext.getRealPath("") + aFS;
		aReportXMLFilename = aFullPath + aReportXMLFilename;
		String anErrorXMLFilename = aFullPath + itsServletContext.getInitParameter(THE_ERROR_XML_PARAMETER);
		String anErrorViewFilename = aFullPath + itsServletContext.getInitParameter(THE_ERROR_VIEW_PARAMETER);
		File aReportXML = new File(aReportXMLFilename);

		String aFriendlyMessage = theFriendlyMessage;
		if (aReportXML.length() < 1)
		{
			aFriendlyMessage = aFriendlyMessage  + " " + ZERO_SIZE_XML_MESSAGE;
		}

		// Get the transformer's error messages
		StringBuffer aTransformErrorList = new StringBuffer();
		Iterator<String> anErrorListIt = theTransformErrors.getItsTransformError().listIterator();
		boolean isFirst = true;
		while(anErrorListIt.hasNext())
		{
			if(!isFirst)
			{
				aTransformErrorList.append(" : ");
			}
			String anError = anErrorListIt.next();
			if(anError.contains("FileNotFound"))
			{
				aFriendlyMessage = aFriendlyMessage + " " + FILE_NOT_FOUND_MESSAGE;
			}
			else if (anError.contains("MalformedURL"))
			{
				aFriendlyMessage = aFriendlyMessage + " " + MALFORMED_URL_MESSAGE;
			}
			aTransformErrorList.append(anError);
			if(isFirst)
			{
				isFirst = false;
			}

		}

		// 02.02.2012 JWC
		// Add in any messages from the TransformerFactory.
		ArrayList<String> anErrorsList = theFactoryErrors.getItsTransformError();
		Iterator<String> aFactoryErrorListIt = anErrorsList.listIterator();
		while(aFactoryErrorListIt.hasNext())
		{
			if(!isFirst)
			{
				aTransformErrorList.append(" : ");
			}
			String anError = aFactoryErrorListIt.next();

			if(anError.contains("FileNotFound"))
			{
				aFriendlyMessage = aFriendlyMessage + " " + FILE_NOT_FOUND_MESSAGE;
			}
			else if (anError.contains("MalformedURL"))
			{
				aFriendlyMessage = aFriendlyMessage + " " + MALFORMED_URL_MESSAGE;
			}
			aTransformErrorList.append(anError);
			if(isFirst)
			{
				isFirst = false;
			}

		}

		// Record that we have reported these errors on the cached factory error listener
		theFactoryErrors.reportedErrors(anErrorsList);

		// End of new edits 02.02.2012 JWC

		// Create a new Transformer that uses the Error View template
		TransformerFactory aFactory = TransformerFactory.newInstance();
		try
		{
			// Set the message and stack trace parameters
			// Transform the Error XML document to render the Error View
			File anErrorView = new File(anErrorViewFilename);
			Transformer aTransformer = aFactory.newTransformer(new StreamSource(anErrorView));
			aTransformer.setParameter(THE_FRIENDLY_MESSAGE_PARAM, aFriendlyMessage);
			aTransformer.setParameter(THE_MESSAGE_PARAM, theMessage);
			aTransformer.setParameter(THE_STACK_TRACE_PARAM, theStackTrace);
			aTransformer.setParameter(THE_TRANSFORMER_MESSAGE_PARAM, aTransformErrorList.toString());
			aTransformer.setParameter(THE_PAGE_HISTORY_PARAM, theVisitHistoryHTML);
			try
			{
				File anErrorXML = new File(anErrorXMLFilename);
				aTransformer.transform(new StreamSource(anErrorXML), new StreamResult(theHTTPResponse.getOutputStream()));
			}
			catch (Exception anEx)
			{
				// report the error to the console - if we can't produce the Error View
				itsLog.error("Exception caught in XML transform, building reportErrorMessage: {}", anEx);

				// Then report this via the serious fail static report page.
				theHTTPResponse.sendRedirect(FATAL_ERROR_REPORT_PAGE);
			}

		}
		catch (Exception anEx)
		{
			// report the error to the console - if we can't produce the Error View
			itsLog.error("Exception caught in reportErrorMessage: {}", anEx);

			// Then report this via the serious fail static report page.
			try
			{
				theHTTPResponse.sendRedirect(FATAL_ERROR_REPORT_PAGE);
			}
			catch (IOException anIOEx)
			{
				itsLog.error(IOEX_IN_FATAL_ERROR_REPORT_MESSAGE + ": {}", anIOEx);
			}
		}


	}

	/**
	 * Get a reference to the shared Transformer Factory that is being managed in the Viewer cache. If the
	 * transformer factory has not yet been created, a new instance is created and the specified source XML document
	 * pre-loaded, parsed and added to the document pool of the factory. The method is synchronised since we are
	 * potentially performing I/O if the transformer factory is not found in the cache.
	 * @param theSourceDocumentFullPath the full (from the Servlet Context) for the source document. This full file name defines the XML source URI.
	 * @param theErrorListener an Error Listener to catch any errors found while building the specified XML Source document.
	 * @return a reference to the cached Transformer Factory from which a new Transformer instance can be created
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#XSL_TRANSFORM_FACTORY_PARAM XSL_TRANSFORM_FACTORY_PARAM
	 */
	public synchronized TransformerFactoryImpl getTransformerFactory(String theSourceDocumentFullPath,
																		ViewTransformErrorListener theErrorListener)
		throws XPathException
	{
		// First, check to see if the TransformerFactory is already in the ServletContext.
		String aParamName = itsServletContext.getInitParameter(XSL_TRANSFORM_FACTORY_PARAM);
		TransformerFactoryImpl aTransformerFactory = (TransformerFactoryImpl) itsServletContext.getAttribute(aParamName);

		// Check to see if it has been set and the document loaded
		if(aTransformerFactory == null)
		{
			// If not, create a new Factory and load the XML source document
			aTransformerFactory = new TransformerFactoryImpl();

			// Create the XML document
			// Include tolerance of various filename formats etc. using the File
			File anXMLFile = new File(theSourceDocumentFullPath);
			Configuration aConfig = aTransformerFactory.getConfiguration();
			aTransformerFactory.setErrorListener(theErrorListener);
			
			// Build a new parsed document from the XML source
			// Updated for Saxon 9.7+
			TreeInfo aDocInfo = aConfig.buildDocumentTree(new StreamSource(anXMLFile));

			// Add it to the document pool so that we can re-use it
			aConfig.getGlobalDocumentPool().add(aDocInfo, anXMLFile.toURI().toString());

			// Add the resulting Transformer Factory to the cache via a Servlet attribute
			itsServletContext.setAttribute(aParamName, aTransformerFactory);
		}

		return aTransformerFactory;
	}

	/**
	 * Get the parsed, XML Source document object from the cache. If it is not found in the cache, create
	 * it and add it to the cache. The method is synchronised since we are potentially performing I/O if the requested
	 * XML URI is not found in the cache.
	 * @param theFactory the Transformer Factory to use - typically this is retrieved from the cache, which
	 * is a Servlet Attribute, with name defined by XSL_TRANSFORM_FACTORY_PARAM.
	 * @param theFullSourceName the full (from the Servlet Context) for the source document. This full file name defines the XML source URI.
	 * @param theErrorListener an Error Listener to catch any errors found while building the specified XML Source document.
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#XSL_TRANSFORM_FACTORY_PARAM XSL_TRANSFORM_FACTORY_PARAM
	 * @return a reference to the parsed XML source document that can be used as the input Source object for a Transformer.transform() call.
	 */
	public synchronized TreeInfo getXMLSourceDocument(TransformerFactoryImpl theFactory, String theFullSourceName, ViewTransformErrorListener theErrorListener)
			throws XPathException
	{
		TreeInfo aParsedDocument = null;

		// Avoid any NPE!
		if(theFactory != null)
		{
			String aDocURI = new File(theFullSourceName).toURI().toString();
			aParsedDocument = theFactory.getConfiguration().getGlobalDocumentPool().find(aDocURI);

			// If we couldn't find the document, load it
			if(aParsedDocument == null)
			{
				Configuration aConfig = theFactory.getConfiguration();
				theFactory.setErrorListener(theErrorListener);
				
				// Include tolerance of various filename formats etc. using the File
				File anXMLFile = new File(theFullSourceName);

				// Build a new parsed document from the XML source
				aParsedDocument = aConfig.buildDocumentTree(new StreamSource(anXMLFile));

				// Add it to the Document Pool
				aConfig.getGlobalDocumentPool().add(aParsedDocument, anXMLFile.toURI().toString());
			}
		}

		return aParsedDocument;
	}

	/**
	 * Initialise the set of request parameters that are reserved and have specific meaning to the
	 * Essential Viewer Engine.
	 */
	protected void initialiseReservedParameters()
	{
		// Create a new hash set to hold them.
		itsViewerReservedParameters = new LinkedHashSet<String>();
		itsViewerReservedParameters.add("XML");
		itsViewerReservedParameters.add("XSL");
		itsViewerReservedParameters.add("LABEL");
		itsViewerReservedParameters.add("PMA");
		itsViewerReservedParameters.add("PMA2");
		itsViewerReservedParameters.add("PMA3");
		itsViewerReservedParameters.add("PMA4");
		itsViewerReservedParameters.add("CT");
		itsViewerReservedParameters.add("FILE");
		itsViewerReservedParameters.add("PGH");
		itsViewerReservedParameters.add(VIEWER_I18N_PARAM);
	}


	/**
	 * Get the full URL path of the requested view.
	 * @param theRequest the request that has been received by the Engine.
	 * @since 3.2
	 * @return the full URL path including the 'http' and query string. View templates that require a chain
	 * of components, e.g. JSP to create dynamic images should set the servlet attribute defined by the
	 * REQUESTED_URL_FULL_PATH_PARAM to pass the original, requested URL to the engine.
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#REQUESTED_URL_FULL_PATH_PARAM REQUESTED_URL_FULL_PATH_PARAM
	 */
	protected String getRequestURLFullPath(HttpServletRequest theRequest)
	{
		// Check to see if the URL full path has been set by a calling component
		String aRequestURLFullPath = (String)itsServletContext.getAttribute(REQUESTED_URL_FULL_PATH_PARAM);
		if((aRequestURLFullPath != null) && (aRequestURLFullPath.length() > 0))
		{
			// The path has been passed from an earlier stage in a chained view template
			// We have the value, so reset the servlet attribute
			itsServletContext.removeAttribute(REQUESTED_URL_FULL_PATH_PARAM);
		}
		else
		{
			// We haven't been supplied with the full path, so compute it

			aRequestURLFullPath = theRequest.getRequestURL().toString();
			String aQueryString = ScriptXSSFilter.filter(theRequest.getQueryString());
			if(aQueryString != null)
			{
				aRequestURLFullPath += "?" + aQueryString;
			}
		}

		return aRequestURLFullPath;
	}

	/**
	 * Set additional transformer parameters. On each request the engine will add
	 * a core set of parameters to the transformer. Additional parameters can be
	 * set here.
	 * @param theTransformer the transformer to which the parameters should be added
	 */
	protected void setTransformerParameters(Transformer theTransformer, HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		// Nothing to implement in the base implementation
	}

	/**
	 * Get whether the Essential Viewer Engine is to track the page / view visited history
	 * @return the itIsTrackingHistory, if true then the page history is being tracked and false if
	 * the page history is not being tracked.
	 */
	public boolean isItIsTrackingHistory()
	{
		return itIsTrackingHistory;
	}

	/**
	 * Set whether the Essential Viewer Engine should track the page / view visited history.
	 * @param theIsTrackingHistory When set to true, each request is recorded in the page history. When set
	 * to false, the requests are not added to the history but any elements in the history are maintained.
	 * This is particularly useful for sub-views such as SVG renderings that are delivering
	 * components of a View page and should therefore not appear in the View Pages History.
	 */
	public void setItIsTrackingHistory(boolean theIsTrackingHistory) {
		itIsTrackingHistory = theIsTrackingHistory;
	}

}
