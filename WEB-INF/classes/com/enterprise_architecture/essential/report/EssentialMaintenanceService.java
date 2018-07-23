/**
 * Copyright (c)2011-2015 Enterprise Architecture Solutions Ltd.
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
 * 15.11.2011	JWC	1st coding.
 * 04.08.2015	JWC Set default value for request parameter
 */
package com.enterprise_architecture.essential.report;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

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

/**
 * REST-style Service Servlet to perform maintenance tasks as requested via a browser GET request.
 * e.g. Clearing down caches
 * Invoke this service and pass a request parameter, name defined by THE_WHEN_REQUEST_PARAM ("when") which takes
 * one of three values:
 * <ul>
 * <li>value = value of WHEN_PRE ("pre"). Clear PRE XML snapshot receive. Clear the cache of all elements that are defined to be cleared BEFORE 
 * the XML snapshot is received.</li>
 * <li>value = value of WHEN_POST ("post"). Clear POST XML snapshot receive. Clear the cache of all elements that are defined to be cleared AFTER 
 * the XML snapshot is received.</li>
 * <li>value = value of WHEN_BOTH ("pre_and_post"). Clear PRE and POST XML snapshot receive. Clear the cache of all elements that are defined to be cleared BEFORE 
 * and AFTER the XML snapshot is received. In practice, this clears all of the cache elements.</li>
 * </ul>
 * The cache configuration is controlled by an XML document conforming to the viewercache.xsd schema. A servlet init parameter, 'cacheConfig' controls the
 * default XML document is used for this cache configuration. Alternatively, a request parameter, name defined by
 * THE_CONFIG_REQUEST_PARAM ("configuration"), can take the local name of the XML configuration file to use. This file must exist in the
 * Essential Viewer web application directory hierarchy. example use:
 * <pre>
 *     http://localhost:8080/essential_viewer/essentialMaintenance?when=pre
 * </pre>
 * With a specific cache configuration:
 * <pre>
 *     http://localhost:8080/essential_viewer_3/essentialMaintenance?when=pre&configuration=myConfig.xml
 * </pre>
 * Clearing the whole cache with a specific configuration:
 * <pre>
 *     http://sikozu.local:8080/essential_viewer_3/essentialMaintenance?when=pre_and_post&configuration=myConfig.xml
 * </pre>
 * @author Jonathan W. Carter <info@enterprise-architecture.com>
 *
 */
public class EssentialMaintenanceService extends HttpServlet implements javax.servlet.Servlet
{
	/**
	 * The name of the serlvet init param that contains the name of the cache config XML file
	 */
	private static final String THE_DEFAULT_CACHE_CONFIG_PARAM = "defaultCacheConfig";
	
	/**
	 * The name of the servlet init param that contains the name of the response XSL file
	 */
	private static final String THE_RESPONSE_XSL_PARAM = "responseXSL";
	
	/**
	 * The name of the servlet init param that contains the name of the response XML file
	 */
	private static final String THE_RESPONSE_XML_PARAM = "responseXML";
	
	/**
	 * The name of the HTTP GET request parameter specifying which subset of cache elements to clear.
	 */
	public static final String THE_WHEN_REQUEST_PARAM = "when";
	
	/**
	 * The name of the HTTP GET request parameter specifying the configuration XML document to use.
	 */
	public static final String THE_CONFIG_REQUEST_PARAM = "configuration";
	
	/**
	  * URL of the Essential Viewer Fatal error static page.
	  */
	public static final String FATAL_ERROR_REPORT_PAGE = "platform/fatal_essential_error.html";
	 
	/**
	 * Request parameter value for the cache elements that are defined to clear before repository XML is received
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_BEFORE_RECEIVE_REPOSITORY CLEAR_BEFORE_REPOSITORY
	 */
	public static final String WHEN_PRE = ViewerCacheManager.CLEAR_BEFORE_RECEIVE_REPOSITORY;
	
	/**
	 * Request parameter value for the cache elements that are defined to clear after repository XML is received
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_AFTER_RECEIVE_REPOSITORY CLEAR_AFTER_REPOSITORY
	 */
	public static final String WHEN_POST = ViewerCacheManager.CLEAR_AFTER_RECEIVE_REPOSITORY;
	
	/**
	 * Request parameter value for the cache elements that are defined to clear before and those after repository XML is received
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_BEFORE_RECEIVE_REPOSITORY CLEAR_BEFORE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_AFTER_RECEIVE_REPOSITORY CLEAR_AFTER_REPOSITORY	 
	 */
	public static final String WHEN_BOTH = ViewerCacheManager.CLEAR_BEFORE_RECEIVE_REPOSITORY + "_and_" + ViewerCacheManager.CLEAR_AFTER_RECEIVE_REPOSITORY;

	/** 
	 * Success message
	 * 
	 */
	private static final String SUCCESS_MESSAGE = "Success. Essential Viewer Cache cleared successfully";

	/**
	 * Failure message
	 */
	private static final String FAILURE_MESSAGE = "Failed. Essential Viewer Cache was not cleared successfully";
	
	/** 
	 * Cache Manager issue - bad config file 
	 */
	private static final String NULL_CACHE_MANAGER_MESSAGE = "Could not initialise cache manager. Could not find or process the specified cache configuration file: ";
	
	/**
	  * Error message raised on System.err when all attempts to report an error have failed.
	  */
	protected static final String IOEX_IN_FATAL_ERROR_REPORT_MESSAGE = "Essential Viewer FATAL ERROR: Cannot redirect to FATAL_ERROR_REPORT_PAGE.";

	/**
	 * the XSL parameter that will contain the response message
	 */
	protected static final String THE_MESSAGE_PARAM = "theMessage";
	
	/**
	 * the XSL parameter that will contain the real path to the config
	 */
	protected static final String THE_REAL_PATH_PARAM = "theRealPath";
	
	/**
	 * String holding the local filename of the cache configuration XML to use.
	 */
	private String itsCacheConfigurationFile = "";
	
	private String itsXSLPage = "";
	
	protected String itsXML = "";
	
	/**
	 * Override the initialisation and initialise the service
	 */
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		
		// Get the configuration properties
		itsCacheConfigurationFile = getServletConfig().getInitParameter(THE_DEFAULT_CACHE_CONFIG_PARAM);
		itsXSLPage = getServletConfig().getInitParameter(THE_RESPONSE_XSL_PARAM);
		itsXML = getServletConfig().getInitParameter(THE_RESPONSE_XML_PARAM);
	}
	
	/**
	 * Process the request message from the client and perform the specified actions
	 * @param theRequest the client request object
	 * @param theResponse the object in which to return the response
	 * @throws ServletException if any problems are encountered
	 * @throws IOException if any I/O errors are encountered.
	 */
	protected void doGet(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException 
	{
		String aClearWhen = theRequest.getParameter(THE_WHEN_REQUEST_PARAM);
		String aCacheConfig = theRequest.getParameter(THE_CONFIG_REQUEST_PARAM);
		
		// 04.08.2015 - JWC default aClearWhen if not set
		if(aClearWhen == null)
		{
			aClearWhen = WHEN_BOTH;			
		}
		
		// Override the default configuration if we have received an specific configuration to use		
		if(aCacheConfig == null)
		{
			aCacheConfig = itsCacheConfigurationFile;
		}
			
		// Create a new ViewerCacheManager.
		ViewerCacheManager aCacheManager = getCacheManager(aCacheConfig);
		boolean isSuccess = false;
		
		if(aCacheManager != null)
		{
			// Test the aClearWhen message and clear as requested.
			if(aClearWhen.equals(WHEN_PRE))
			{
				// Clear the cache pre
				isSuccess = aCacheManager.clearCache(getServletContext(), WHEN_PRE);
			}
			else if(aClearWhen.equals(WHEN_POST))
			{
				// Clear the cache post
				isSuccess = aCacheManager.clearCache(getServletContext(), WHEN_POST);
			}
			else if(aClearWhen.equals(WHEN_BOTH))
			{
				// Clear all the cache elements - pre and post.
				ServletContext aContext = getServletContext();
				isSuccess = aCacheManager.clearCache(aContext, WHEN_PRE);
				isSuccess = aCacheManager.clearCache(aContext, WHEN_POST);
			}
			
			if(isSuccess)
			{
				reportResponseMessage(theRequest, theResponse, SUCCESS_MESSAGE, "");			
			}
			else
			{
				reportResponseMessage(theRequest, theResponse, FAILURE_MESSAGE, "");
			}
		}
		else
		{
			// NULL Cache Manager - report this
			String aMessage = NULL_CACHE_MANAGER_MESSAGE + aCacheConfig;
			String aRealPath = getServletContext().getRealPath("");
			reportResponseMessage(theRequest, theResponse, aMessage, aRealPath);
		}
	}
	
	/**
	 * Handle the POST message from the client.
	 * Currently, just forward to the GET method.
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException
	{
		// Forward to the GET operation
		doGet(theRequest, theResponse);
	}
	
	/**
	 * Get a new instance of a the Viewer Cache Manger. This method manages streaming the source XML
	 * configuration file to the ViewerCacheManager
	 * @param theCacheConfig the shortname (just the local-context file name) of the cache configuration
	 * XML document to use.
	 * @return ViewerCacheManager the cache manager object initialised with the cache configuration.
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager ViewerCacheManager
	 */
	protected ViewerCacheManager getCacheManager(String theCacheConfig)
	{
		// Find the name of the config file, with its full path
		String aConfigFile = getServletContext().getRealPath(theCacheConfig);
		ViewerCacheManager aCacheManager = null;
		
		try
		{						
			// Open a File stream for the configuration and send it to the constructor for the cache manager
			FileInputStream anInStream = new FileInputStream(aConfigFile);				
			aCacheManager = new ViewerCacheManager(anInStream);				
		}
		catch (FileNotFoundException aFileNotFound)
		{
			// Just report an error - this is not a fatal error for the EasReportService
			System.err.println("EasReportService: Could not find cache configuration file: " + aConfigFile);
		}
		
		return aCacheManager;
	}
	
	/**
	 * Report the response to the request - this is an HTML page containing the message, rendered via an
	 * XSL View template.
	 * @param theRequest the client request object.
	 * @param theHTTPResponse the response object in which the response is delivered to the client
	 * @param theMessage the message that is passed to the View in an XSL param, named by THE_MESSAGE_PARAM
	 * @see com.enterprise_architecture.essential.report.EssentialMaintenanceService#THE_MESSAGE_PARAM THE_MESSAGE_PARAM
	 */
	protected void reportResponseMessage(HttpServletRequest theRequest, 
			  						  HttpServletResponse theHTTPResponse, 			  
			  						  String theMessage,
			  						  String theCacheRealPath)
	{
		String aResponsePageXSL = getServletContext().getRealPath(itsXSLPage);
		String aResponsePageXML = getServletContext().getRealPath(itsXML);
		
		// Create a new Transformer that uses the specified View template
		TransformerFactory aFactory = TransformerFactory.newInstance();
		try
		{
			// Set the message and stack trace parameters 
			// Transform the Error XML document to render the Error View			
			File aView = new File(aResponsePageXSL);
			Transformer aTransformer = aFactory.newTransformer(new StreamSource(aView));			
			aTransformer.setParameter(THE_MESSAGE_PARAM, theMessage);
			aTransformer.setParameter(THE_REAL_PATH_PARAM, theCacheRealPath);
		
			try
			{
				File anXML = new File(aResponsePageXML);
				aTransformer.transform(new StreamSource(anXML), new StreamResult(theHTTPResponse.getOutputStream()));
			}
			catch (Exception anEx)
			{
				// report the error to the console - if we can't produce the Error View
				anEx.printStackTrace();

				// Then report this via the serious fail static report page.
				theHTTPResponse.sendRedirect(FATAL_ERROR_REPORT_PAGE);
			}
		}
		catch (Exception anEx)
		{
			// report the error to the console - if we can't produce the Error View
			anEx.printStackTrace();

			// Then report this via the serious fail static report page.
			try
			{
				theHTTPResponse.sendRedirect(FATAL_ERROR_REPORT_PAGE);
			}
			catch (IOException anIOEx)
			{
				System.err.println(IOEX_IN_FATAL_ERROR_REPORT_MESSAGE);
				anIOEx.printStackTrace();
			}
		}
	}
	
}
