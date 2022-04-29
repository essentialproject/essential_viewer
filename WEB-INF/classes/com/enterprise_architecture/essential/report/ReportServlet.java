/** Copyright (c)2008-2021 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 25.04.2008	JP	first release
 * 05.11.2008	JWC	Check for missing LABEL param and default it if it is not there. 
 * 					Prevents corruption of session breadcrumb and null pointer exceptions
 * 11.11.2008	JWC	Removed trace statements
 * 25.11.2008	JWC Set the content type to text/html as missing content type was causing
 * 					Sharepoint problems.
 * 14.10.2009	JWC	Added the contribution from Mathwizard to pass content type parameters 
 * 					which enables easy generation of things like spreadsheets.
 * 07.11.2011	JWC	Add theURLPrefix parameter to the Transformer Context, to enable them to build
 * 					the full URL path for linking, as required.
 * 08.11.2011	JWC	Added the capability to pass user-defined, arbitrary list of parameters to a
 * 					View template in a hyperlink.
 * 09.11.2011	JWC	Improved error handling
 * 10.11.2011	JWC Re-worked page history tracking
 * 11.11.2011	JWC/NW Revised the page history XSL parameter.
 * 15.11.2011	JWC v3 Cached XML source and transformer factory
 * 17.01.2012	JWC Re-worked to use the Essential Viewer Engine
 * 14.06.2012	JWC/NW Explicitly set character coding in response to specified parameter (e.g. UTF-8)
 * 					to fix unicode character rendering problems.
 * 19.01.2015	JWC	Reworked to include ability to use alternative EssentialViewerEngine implementations
 * 08.04.2021	JWC Added the steps to create View Browser Cache and tweaks to response headers
 * 
 */ 
package com.enterprise_architecture.essential.report;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//import org.owasp.html.PolicyFactory;
//import org.owasp.html.Sanitizers;


/**
 * Servlet implementation class for Servlet: ReportServlet
 * which provides a service to render reports using the specified XSL file to perform
 * XSLT on the Essential Architecture Manager model snap-shot, operating in a REST style.
 * <br>This class expects to be serving HTML reports, as it sets the content type to 
 * 'text/html'. A separate servlet, ReportServletSVG is provided for rendering SVG reports
 * and it expects to be included in an HTML &lt;object/&gt; statement.<br>
 * <br>Optionally, the servlet can be instructed to create the report in a downloadable document, 
 * e.g. MS Excel spreadsheet, using the CT and FILE parameters. (thanks to Mathwizard for this 
 * contribution).<br>
 * Servlet expects the following request parameters
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
 * </ul>
 * Version 2.0 delivers the first of a series of updates for Essential Viewer 3.<br/>
 * Version 2.1 Adds the capability to pass user-defined, arbitrary list of parameters to a
 * View template in a hyperlink. In addition to the reserved parameters, additional, user-defined parameters
 * can be passed in theUserParams parameter as HTTP GET name/value pairs in the form: <i>parameter=value&amp;parameter=value</i>. Note that
 * in the XSL, the '&' should be 'escaped' using the <i>'&amp;amp;'</i> value.<br/>
 * Version 2.2 Improves error handling by introducing the Error View to report the error messages and exception details <br/>
 * Version 2.3 Re-works the management of the page history.<br/>
 * Version 3.0 Caches the source XML document in a Servlet variable to improve performance and reduce memory.
 * <br/>
 * Version 3.1 Re-factors the view-rendering into the Essential Viewer Engine to simplify the servlet.
 * <br/>
 * Version 3.2 Uses character encoding servlet parameter to control character encoding of response output.
 * <br/>
 * The selected View Template / Report has the following parameters available to use in the XSL:
 * <ul>
 * <li>param1 - the instance ID of the instance in focus for the View / Report.</li>
 * <li>param2 - if specified in the client request, a reserved parameter name that can contain any value required by the View / Report. </li>
 * <li>param3 - if specified in the client request, a reserved parameter name that can contain any value required by the View / Report. </li>
 * <li>param4 - if specified in the client request, a reserved parameter name that can contain any value required by the View / Report. </li>
 * <li>reposXML - the name of the XML document that is holding the Essential repository snapshot that should be used for queries.</li>
 * <li>theURLPrefix - the full URL prefix of the Servlet that can be used to define full-path hyperlinks. e.g. 'http://localhost:8080/essential_viewer/'</li>
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
 * @see com.enterprise_architecture.essential.report.ReportServletSVG ReportServletSVG
 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine EssentialViewerEngine
 * @author Jason Powell <info@e-asolutions.com>
 * @author Jonathan Carter <info@e-asolutions.com>
 * @version 3.2
 * 
 *
 */
 public class ReportServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet
 {
	 
    /**
     * Default constructor for the servlet. 
     * All initialisation takes place in the init() method.
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public ReportServlet() 
	{
		super();
	}   
	
	/**
	 * Initialise the servlet then call the superclass initialisation.
	 * @see javax.servlet.GenericServlet#init()
	 * @since 2.1
	 */
	public void init() throws ServletException 
	{		
		super.init();
	}   
	
	/**
	 * Basic doGet handler. Includes option to receive the report as a downloadable document,
	 * e.g. an MS Excel spreadsheet, using the optional CT and FILE parameters. Thanks to Mathwizard
	 * for this contribution.
	 * Revised in version 3.1 of this code to use the Essential Viewer Engine.
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine Essential Viewer Engine
	 * 
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		HttpSession aSess = request.getSession();
		HashMap<String, String> visitedPages = (HashMap<String, String>)aSess.getAttribute("visitedPages");
		
		// If no visited pages are found, create a new set.
		if(visitedPages == null) 
		{
			visitedPages = new HashMap<String, String>();
			request.getSession().setAttribute("visitedPages", visitedPages);
		}
		response.setDateHeader ("Expires", 0); //prevents caching at the proxy server 
		
		// Add Mathwizard's code to produce a document - 14.10.2009 JWC
		String aContentType = null;
		String aFilename = null;

		aContentType = ScriptXSSFilter.filter(request.getParameter("CT"));
		aFilename = ScriptXSSFilter.filter(request.getParameter("FILE"));

		// Set the content type - 14.10.2009 JWC - code from Mathwizard
		if(aContentType != null) 
		{
		    response.setContentType(aContentType);
		}
		else
		{
			// Set the content type for HTML - 25.11.2008 JWC
			response.setContentType("text/html");
		}
		
		// 14.06.2012 - JWC/NW set the character encoding of the output
		response.setCharacterEncoding(getServletContext().getInitParameter("defaultCharacterEncoding"));
		
		// Setup the report filename that will be downloaded - 14.10.2009 JWC / code from Mathwizard
		if(aFilename != null) 
		{
		    response.setHeader("Content-Disposition", "attachment; filename=\"" + aFilename + "\"");
		}
		
		// Use Essential Viewer Engine to produce the requested View.
		StringWriter aStreamResult = new StringWriter();
		EssentialViewerEngine anEngine = getViewerEngine();
		boolean isSuccess = anEngine.generateView(request, response, aStreamResult);

		// Add the computed View to the ViewBrowserCache
		addToViewBrowserCache(request, response);

		if(isSuccess)
		{
			// Use OWASP Sanitizer
			//PolicyFactory aPolicy = Sanitizers.FORMATTING.and(Sanitizers.BLOCKS);
			//String aSafeHTML = aPolicy.sanitize(aStreamResult.toString());
			
			// Write the resulting view to the response.
			//response.getWriter().print(aSafeHTML);
			response.getWriter().print(aStreamResult.toString());			
			response.getWriter().flush();
		}
		// On error, the Essential Viewer Engine error handling will respond to the client.
	}  	
	
	/**
	 * Handle POST requests from the clients.
	 * This class manages all requests via GET messages, so any POST requests are simply forwarded
	 * to doGet()
	 * @param theRequest the HTTP request
	 * @param theResponse the response message
	 * @since 2.1
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse)
	  				throws ServletException, IOException
	{
		// Forward this to doGet()
		doGet(theRequest, theResponse);
	}
	
	/**
	 * Encapsulate the instantiation of the Viewer Engine in a method that can be overridden by 
	 * subclasses
	 * @return an instance of the required Essential Viewer Engine
	 * @since 5.0
	 */
	protected EssentialViewerEngine getViewerEngine()
	{
		EssentialViewerEngine anEngine = new EssentialViewerEngine(getServletContext());
		return anEngine;
	}
	
	/**
	 * Build the HTML code for the page history selections.
	 * @param visits a HashMap containing the set of labels and the corresponding breadcrumb object representing a page that has been visited
	 * @return a String containing the HTML fragment for the set of options for a combo-box.
	 * @deprecated The revised approach to the page history is coded using createPageVisitXSLParameter() as part of Essential Viewer Engine.
	 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine#createPageVisitXSLParameter createPageVisitXSLParameter
	 * @since 2.3
	 */
	protected String createPageVisitsHTML(HashMap<String, ReportBreadcrumb> visits) 
	{
		String itemSpaces = "";
		int noOfChars = 150;
		for(int i=1;i<noOfChars;i++) 
		{
			itemSpaces = itemSpaces + " ";
		}
		String visitsHTML = "<option value=\"-1\">-" + itemSpaces + "</option>" ;
		ArrayList<ReportBreadcrumb> visitsArray = new ArrayList<ReportBreadcrumb>();
		visitsArray.addAll(visits.values());
		Collections.sort(visitsArray);
		Iterator iter = visitsArray.iterator();
		ReportBreadcrumb aVisit;
		String visitKey;
		while(iter.hasNext()) {
			aVisit = (ReportBreadcrumb) iter.next();
			visitKey = aVisit.getXslFile() + aVisit.getParam1() + aVisit.getParam2();
			itemSpaces = "";
			for(int j = 0; j < (noOfChars - aVisit.getLabel().length()); j++) 
			{
				itemSpaces = itemSpaces + " ";
			}
			visitsHTML = visitsHTML + "<option value=\"" + visitKey + "\">" + aVisit.getLabel() + itemSpaces + "</option>" ;
		}

		return visitsHTML;
	}
	
	/**
	 * Add the request to the ViewBrowserCache
	 * 
	 * @param theRequest
	 */
	protected void addToViewBrowserCache(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		// No action take in open-source edition

	}
}