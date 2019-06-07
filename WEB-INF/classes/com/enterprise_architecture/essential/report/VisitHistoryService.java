/**
 * Copyright (c)2013-2018 Enterprise Architecture Solutions Ltd.
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
 * 31.01.2013	JWC	1st coding.
 * 06.06.2013	JWC Revised visit history hash mapping
 * 05.07.2018	JWC Updated to address potential for script code injection into the history
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.enterprise_architecture.essential.pagehistory.ObjectFactory;
import org.enterprise_architecture.essential.pagehistory.PageHistory;
import org.enterprise_architecture.essential.pagehistory.VisitType;

/**
 * AJAX Service that reports the history of views and pages that the
 * current session has visited.
 * The service is invoked by making a GET or POST request with no parameters required.
 * The visit history is returned as an XML document with schema defined
 * by platform/pagehistory.xsd
 * 
 * @author Jonathan Carter <info@enterprise-architecture.com>
 * @version 1.1
 *
 */
public class VisitHistoryService extends HttpServlet 
{
	/**
	 * Serial version ID - use version number.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * String name of the session variable containing the page history. Default to shared
	 * with Essential Viewer Engine.
	 */
	private String itsPageHistorySessionVariable = "visitedPages";
	
	/**
	 * String name of the context parameter page history tracking switch
	 */
	private final static String PAGE_HISTORY_TRACKING_PARAM = "ajaxPageHistoryTracking";
	
	/**
	 * String name of the context parameter specifying the default visit label
	 */
	private final static String DEFAULT_VISIT_LABEL_PARAM = "ajaxDefaultVisitLabel";
	
	/**
	 * Content type of the response - XML in UTF-8
	 */
	private static final String CONTENT_TYPE = "text/xml; charset=utf-8";
	
	/**
	 * Default value for the encoding of the response. Can be overridden by the Default Character
	 * Encoding context parameter in web.xml
	 */
	private static String itsXMLEncoding = "UTF-8";
	
	/**
	 * Schema location included in the response XML header.
	 */
	public static final String XSD_LOCATION = "http://www.enterprise-architecture.org/essential/pagehistory pagehistory.xsd";
	
	/**
	 * Configuration variable controlling the session attribute in which to maintain the visit history.
	 * Set to <tt>visitiedPages</tt> to share the history maintenance with the Essential Viewer Engine.
	 */
	public static final String VISIT_VARIABLE_NAME = "ajaxVisitVariable";
	
	/**
	 * HTTP Post parameter for sending the URL of a new visit to record in the history 
	 */
	public static final String URL_REQUEST_PARAM = "url";
	
	/**
	 * HTTP Post parameter for sending the label for a new visit to record in the history 
	 */
	public static final String LABEL_REQUEST_PARAM = "label";
	
	/**
	  * Flag to run the engine without tracking the page history.
	  * When set to false, any existing history is passed on but the most recent request is not added to the history
	  */
	private boolean itIsTrackingHistory;
	
	/**
	 * Attribute to define the default visit label to use. Controlled by the <tt>ajaxDefaultVisitLabel</tt>
	 * context parameter in web.xml
	 */
	private String itsDefaultVisitLabel = "";

	
	/**
	 * Override the initialisation and initialise the service
	 */
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		
		// Set the character encoding of the XML response.
		itsXMLEncoding = getServletContext().getInitParameter("defaultCharacterEncoding");		
		
		// Read the context parameter and decide whether to set the page history tracking on or off
		String aPageTrackSwitch = getServletContext().getInitParameter(PAGE_HISTORY_TRACKING_PARAM);		
		if(aPageTrackSwitch.equals(EssentialViewerEngine.PAGE_TRACKING_ON))
		{
			itIsTrackingHistory = true;
		}
		else
			itIsTrackingHistory = false;
		
		// Set the page history variable name to use.
		itsPageHistorySessionVariable = getServletContext().getInitParameter(VISIT_VARIABLE_NAME);
		
		// Set the default visit label
		itsDefaultVisitLabel = getServletContext().getInitParameter(DEFAULT_VISIT_LABEL_PARAM);
	}
	
	/**
	 * Respond to an HTTP GET.
	 * Forwards the GET to the POST method from which the response will be returned
	 */
	protected void doGet(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException 
	{
		// Forward to the GET operation
		doPost(theRequest, theResponse);
	}
	
	/**
	 * Receive the service request and return the visited pages history in the XML document
	 * @param theRequest the client request object
	 * @param theResponse the object in which to return the response
	 * @throws IOException if any I/O errors are encountered.
	 * @throws ServletException if any problems are encountered
	 * 
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException
	{
		// Set the content type
		theRequest.setCharacterEncoding(itsXMLEncoding);
		theResponse.setContentType(CONTENT_TYPE);
		ObjectFactory anObjFactory = new ObjectFactory();
		PageHistory aPageHistory = anObjFactory.createPageHistory();
				
		// If page history tracking is enabled
		if(itIsTrackingHistory)
		{
			// Read the input parameters
			String aURL = theRequest.getParameter(URL_REQUEST_PARAM);
			String aLabel = theRequest.getParameter(LABEL_REQUEST_PARAM);
			
			// Debug
//			System.out.println(">>> VisitHistoryService.doPost(). un-encoded URL = " + aURL);
//			System.out.println(">>> VisitHistoryService.doPost(). un-encoded Label = " + aLabel);
			
			// Encode the URL using the HTTPServletResponse
			aURL = theResponse.encodeURL(aURL);
			// URL Encode the label to make sure that no scripting can be rendered in here			
			aLabel = URLEncoder.encode(aLabel, itsXMLEncoding);
			aLabel = aLabel.replace('+', ' ');
			
			// Debug
//			System.out.println(">>> Encoding...");
//			System.out.println(">>> VisitHistoryService.doPost(). Encoded URL = " + aURL);
//			System.out.println(">>> VisitHistoryService.doPost(). Encoded Label = " + aLabel);
//			System.out.println(">>> ");
			// Add the new visit to the history
			HashMap<String, String> visitedPages = addToHistory(aURL, aLabel, theRequest);
						
			// Process the Visited Pages list to build the XML Objects
			aPageHistory = buildHistory(visitedPages);
		}
		else
		{
			// Return an XML document, empty with enabled attribute set to false.			
			// Build the XML object
			aPageHistory.setEnabled(false);
		}
		
		// Set the character encoding of the XML response.
		theResponse.setCharacterEncoding(itsXMLEncoding);
		
		// Marshall the object into the XML String
		try
		{
			JAXBContext aJaxBContext = JAXBContext.newInstance(PageHistory.class);
			Marshaller aMarshaller = aJaxBContext.createMarshaller();
			
			// output pretty printed
			aMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			aMarshaller.setProperty(Marshaller.JAXB_ENCODING, itsXMLEncoding);
			aMarshaller.setProperty(Marshaller.JAXB_SCHEMA_LOCATION, XSD_LOCATION);
			
			// Load the XML into the response
			aMarshaller.marshal(aPageHistory, theResponse.getOutputStream());
		}
		catch (JAXBException aJaxbEx)
		{
			System.err.println("VisitHistoryService Error processing configuration XML file");
			System.err.println("Message: " + aJaxbEx.getLocalizedMessage());
			aJaxbEx.printStackTrace();
		}		
		catch (IllegalArgumentException anIllegalArgEx)
		{
			System.err.println("VisitHistoryService Error unmarshalling configuration XML file");
			System.err.println("Message: " + anIllegalArgEx.getLocalizedMessage());
			anIllegalArgEx.printStackTrace();
		}
	}
	
	/**
	 * Build the PageHistory object that will be used to create the XML response
	 * from the visit list in theVisits.
	 * @param theVisits the list of views and pages that have been visited.
	 * @return a JAXB object representing the visit list page history.
	 * @see org.enterprise_architecture.essential.pagehistory.PageHistory PageHistory
	 */
	protected PageHistory buildHistory(HashMap<String, String> theVisits)
	{
		ObjectFactory anObjFactory = new ObjectFactory();
		PageHistory aPageHistory = anObjFactory.createPageHistory();
		
		// Check that we have a set of visits
		if(theVisits != null)
		{
			// Get the visit list keys - the labels, sorted alphabetically
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
					
					VisitType aVisit = anObjFactory.createVisitType();
					aVisit.setUrl(aVisitKey);
					aVisit.setLabel(aVisitLabel);
					aPageHistory.getVisit().add(aVisit);
				}
				catch(ClassCastException aClassCast)
				{
					// Most likely received an Essential Viewer v2 visit history - ignore
				}
			}
		}
		aPageHistory.setEnabled(true);
		
		return aPageHistory;
	}
	
	/**
	 * Add a new visit to the history.
	 * A visit is defined by the URL of the visit and a label. Only visits with a non-empty, non-null URL will
	 * be added. If no label is specified, the default visit label is used.
	 * If a visit with the specified URL has already been recorded, then this visit is ignored, to avoid duplicates.
	 * @see com.enterprise_architecture.essential.report.VisitHistoryService#itsDefaultVisitLabel the default visit label
	 * @param theURL the URL of the visit that is being made
	 * @param theLabel the label that should be displayed for the visit
	 * @param theRequest the HTTP request that contains the session variable containing the visit history
	 * @return a HashMap of the visits, keyed by the URL.
	 */
	protected HashMap<String, String> addToHistory(String theURL, String theLabel, HttpServletRequest theRequest)
	{
		// Find the session and get the current page history
		HttpSession aSession = theRequest.getSession();
		
		HashMap<String, String> visitedPages = (HashMap<String, String>)aSession.getAttribute(itsPageHistorySessionVariable);
		
		// If no visited pages are found, create a new set.
		if(visitedPages == null) 
		{
			visitedPages = new HashMap<String, String>();
			theRequest.getSession().setAttribute(itsPageHistorySessionVariable, visitedPages);			
		}
		
		// Add the new visit - but only if we have a URL
		if((theURL != null) && !theURL.isEmpty())
		{
			//if the requested page is not already in the page visits Hashmap then add it
			String visitKey = theURL;
					
			if(!visitedPages.values().contains(visitKey)) 
			{
				//add the URL and label to the visited pages Hashmap
				if((theLabel != null) && !theLabel.isEmpty())
				{
					visitedPages.put(visitKey, theLabel);					
				}
				else
				{
					// If there's no specified label, use the default
					visitedPages.put(itsDefaultVisitLabel, visitKey);					
				}
			}
		}
				
		return visitedPages;
	}
	
}
