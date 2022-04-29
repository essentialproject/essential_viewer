/**
 * Copyright (c)2015-2021 Enterprise Architecture Solutions ltd.
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
 * 06.04.2020	JWC Added destroy method 
 * 31.03.2021	JWC Added the browser-based View caching
 * 06.04.2021	JWC Re-worked ETag approach
 */
package com.enterprise_architecture.essential.report.security;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.enterprise_architecture.essential.report.ReportServlet;
import com.enterprise_architecture.essential.report.ScriptXSSFilter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.CacheControl;

/**
 * Essential Report Servlet, which is responsible for receiving requests to Essential Viewer,
 * that applies detailed security policies to those requests.  
 * @author Jonathan Carter
 *
 */
public class SecureReportServlet extends ReportServlet 
{
	private static final Logger itsLog = LoggerFactory.getLogger(SecureReportServlet.class);

	/**
	 * Initialise the instance of the class. No override action
	 */
	public SecureReportServlet() 
	{
		super();
	}
	
	/**
	 * Tidy up any open resources before destroying the servlet
	 * In particular the Neo4J driver
	 */
	@Override
	public void destroy()
	{
		ViewerSecurityManager aSecurityManager = (ViewerSecurityManager) getServletContext().getAttribute(SecureEssentialViewerEngine.VIEWER_SECURITY_MANAGER_SINGLETON_VARNAME);
		if(aSecurityManager != null)
		{
			aSecurityManager.closeResources();
		}
	}

	/**
	 * Initialise this Servlet
	 * Create the View caching component
	 */
	@Override
	public void init() throws ServletException 
	{		
		super.init();
	}   

	/**
	 * Add the request to the ViewBrowserCache
	 * 
	 * @param theRequest
	 */
	protected void addToViewBrowserCache(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		// Compute a new ETag for the request and write it to the response
		ViewBrowserCache aBrowserCache = new ViewBrowserCache(getServletContext());
		
		// Find the User's Hash
		String aUserHash = (String) theRequest.getSession().getAttribute(ViewerSecurityManager.USER_PROFILE_HASH);
	
		// Get the requested relative path
		String aViewPath = ScriptXSSFilter.filter(theRequest.getParameter("XSL"));
		if(aViewPath == null)
		{
			aViewPath = theRequest.getServletContext().getInitParameter("homeXSLFile");
		}

		// Get the requested repositoryXML 
		String aReposXml = ScriptXSSFilter.filter(theRequest.getParameter("XML"));
		if(aReposXml == null)
		{
			aReposXml = theRequest.getServletContext().getInitParameter("defaultReportFile");
		}
		// Compute the current ETag for the requested View
		String anEtag = aBrowserCache.computeETag(aReposXml, aUserHash, aViewPath);
		itsLog.debug(">>>> Computed ETag: {}", anEtag);

		// Add the caching header to the response with the ETag in, if we have computed a valid ETag
		if(anEtag != null){
			theResponse.addHeader("ETag", anEtag);
		}
		itsLog.debug(">>> Before CacheControl. Response ETag Header: {}", theResponse.getHeaders("ETag"));

		// Set the cache control headers
		CacheControl aCacheControl = CacheControl.noCache().noTransform();
		theResponse.addHeader("cache-control", aCacheControl.getHeaderValue());
		itsLog.debug(">>> After CacheControl. Response ETag Header: {}", theResponse.getHeaders("ETag"));

	}
	
	/**
	 * Create a secure implementation of the Essential Viewer Engine
	 * @return an instance of an implementation of Essential Viewer Engine that applies security
	 * @see com.enterprise_architecture.essential.report.security.SecureEssentialViewerEngine
	 */
	@Override
	protected SecureEssentialViewerEngine getViewerEngine()
	{
		SecureEssentialViewerEngine anEngine = new SecureEssentialViewerEngine(getServletContext());		
		return anEngine;
	}

	/**
	 * Get the Viewer Id from the context path of the request.
	 * Remove any '/' characters before returning the name of the current
	 * Viewer servlet
	 * 
	 * @param theRequest
	 * @return
	 */
	protected String getViewerId(HttpServletRequest theRequest)
	{
		// the Context path should be "viewer/". Split by "/"
		String[] aContextComponents = theRequest.getContextPath().split("/");
		
		// We only want the last component
		String aViewerId = aContextComponents[(aContextComponents.length)-1];
		return aViewerId;
	}

}
