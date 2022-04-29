/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 25.03.2020	JWC	First implementation of open source Report API
 * 
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;
import java.io.StringWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Servlet to manage requests for Report API views
 * A cache of Report API views is managed until a new repository snapshot is received
 * 
 * @author Jonathan W. Carter
 *
 */
@WebServlet(name="ReportAPIServlet", description="Renders Report APIs and caches them on-demand", urlPatterns = {"/reportApi"})
public class ReportAPIServlet extends HttpServlet 
{

	/**
	 * Serial version ID
	 */
	private static final long serialVersionUID = 1L;
	
	private static final Logger itsLog = LoggerFactory.getLogger(ReportAPIServlet.class);
	
	private ReportAPIEngine itsReportAPIEngine = null;

	/**
	 * Default constructor
	 */
	public ReportAPIServlet() 
	{
		super();
	}
	
	/**
	 * Clean up any resources when the servlet is destroyed 
	 */
	@Override
	public void destroy() 
	{
		try
		{
			itsReportAPIEngine.closeResources();
		}
		catch(Exception anEx)
		{
			itsLog.warn("Error closing the ReportAPIEngine resources. Reason: {}", anEx);
		}
	}
	
	/**
	 * Basic doGet handler.
	 * @see com.enterprise_architecture.essential.report.ReportAPIEngine Report API Engine
	 * 
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		//HttpSession aSess = request.getSession();
		
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
		response.setHeader("Pragma","no-cache"); //HTTP 1.0
		response.setDateHeader ("Expires", 0); //prevents caching at the proxy server 
		
		// Set the content type for JSON documents
		response.setContentType("application/json");
		
		// Set the character encoding of the output, picking up the default from the context params
		response.setCharacterEncoding(getServletContext().getInitParameter("defaultCharacterEncoding"));
		
		// Use Essential Viewer Engine to produce the requested View.
		StringWriter aStreamResult = new StringWriter();
		
		// Create an instance of the ReportAPIEngine, giving it the parameters it needs to use EssentialViewerEngine
		if(itsReportAPIEngine == null)
		{
			itsReportAPIEngine = getReportAPIEngine();
		}
		EssentialViewerEngine aViewerEngine = getViewerEngine();
		
		itsLog.debug("ReportAPIEngine type: {}", itsReportAPIEngine.getClass().getName());
		itsLog.debug("ViewerEngine type: {}", aViewerEngine.getClass().getName());
		boolean isSuccess = itsReportAPIEngine.generateReportAPI(request, response, aViewerEngine, aStreamResult);
		
		itsLog.debug("doGet() completed. isSuccess: {}", isSuccess);
		
		response.getWriter().print(aStreamResult.toString());			
		response.getWriter().flush();		
	}
	
	/**
	 * Encapsulate the instantiation of the Report API Engine in a method that can be overridden by 
	 * subclasses
	 * @return an instance of the required Report API Engine
	 * @since 1.0
	 */
	protected ReportAPIEngine getReportAPIEngine()
	{
		ReportAPIEngine aReportApiEngine = new ReportAPIEngine(getServletContext());
		return aReportApiEngine;
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
	
	@Override
	public void init() throws ServletException
	{
		super.init();
		
		itsLog.debug("Initialising the Report API Servlet");
	}

}
