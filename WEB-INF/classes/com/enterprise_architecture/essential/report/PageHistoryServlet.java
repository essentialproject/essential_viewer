/**
 * Copyright (c)2008-2019 Enterprise Architecture Solutions ltd.
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
 * 13.11.2008	JWC	Removed trace statements
 * 10.11.2011	JWC Deprecated the PageHistoryServlet
 * 28.06.2019	JWC Added use of log4J
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet implementation class for Servlet: PageHistoryServlet
 * @author Jason Powell <info@enterprise-architecture.com>
 * @author Jonathan Carter <info@enterprise-architecture.com>
 * @deprecated The revised page history capability in Essential Viewer Engine 2.3 no longer uses this class and it cannot handle the user-defined parameters
 */
 public class PageHistoryServlet extends com.enterprise_architecture.essential.report.ReportServlet implements javax.servlet.Servlet 
 {
 
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(PageHistoryServlet.class);	
		 
	 /* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public PageHistoryServlet() {
		super();
	}   	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		HashMap<String, ReportBreadcrumb> visitedPages = (HashMap<String, ReportBreadcrumb>) session.getAttribute("visitedPages");
		if(visitedPages == null) {
			visitedPages = new HashMap<String, ReportBreadcrumb>();
			request.getSession().setAttribute("visitedPages", visitedPages);
		}
		String pageKey = request.getParameter("page");
		// 13.11.2008 JWC
		// System.out.println("Page Key: " + pageKey);
		String FS = System.getProperty("file.separator");
		String xmlFile, xslFile;
		String paramValue = "";
		String paramValue2 = "";
		String paramValue3 = "";
		String paramValue4 = "";
		if(pageKey != null) 
		{
			ReportBreadcrumb bc = visitedPages.get(pageKey);
			// 13.11.2008 JWC
			//System.out.println("Retrieved Visited Page: " + bc.getLabel());
			
			// 25.11.2008 JWC - Handle expired sessions, where breadcrumb is null
			if(bc != null)
			{
				//Set up the transformation parameters from the breadcrumb			
				xslFile = bc.getXslFile();
				xmlFile = bc.getXmlFile();
				paramValue = bc.getParam1();
				paramValue2 = bc.getParam2();
				paramValue3 = bc.getParam4();
				paramValue4 = bc.getParam4();
			}
			else
			{
				// If the session has expired and there was no breadcrumb
				// divert user back to home page
				xslFile = this.getInitParameter("homeXSLFile");
				xmlFile = this.getInitParameter("defaultReportFile");
			}
		}
//If no breadcrumb is found for the page, then go to the default page (usually home)
		else {
				xslFile = this.getInitParameter("homeXSLFile");
				xmlFile = this.getInitParameter("defaultReportFile");
		} 
		String origXMLFile = xmlFile;
			
//		get the real path for xml and xsl files;
		String ctx = getServletContext().getRealPath("") + FS;
		xslFile = ctx + xslFile;
		xmlFile = ctx + xmlFile;

			
		//create the page history parameter for the xsl
		String visitedPagesHTML = this.createPageVisitsHTML(visitedPages);
		
		//Generate the required report
		TransformerFactory tFactory = TransformerFactory.newInstance();
		try {
			Transformer transformer = tFactory.newTransformer(new StreamSource(xslFile));
		
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
			transformer.setParameter("pageHistory", visitedPagesHTML);
			
			try {
				transformer.transform(new StreamSource(xmlFile), new StreamResult(response.getOutputStream()));
			} catch (Exception e) {
				itsLog.error("Exception caught: {}", e);
			}
		} catch(Exception e) {
			itsLog.error("Exception caught); {}", e);
		}
	}  	  	  	    
}
