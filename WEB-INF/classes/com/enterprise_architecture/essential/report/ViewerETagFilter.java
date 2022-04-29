/**
 * Copyright (c)2019 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 01.04.2021	JWC	First implementation of ETag validation filter
 * 15.04.2021   JWC Added support for getting dynamic CSRF Token for cached View
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.enterprise_architecture.essential.report.security.ViewBrowserCache;
import com.enterprise_architecture.essential.report.security.ViewerSecurityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Validate any ETags that are supplied in the request. If they match, then return HTTP 304 to the
 * browser
 * 
 * @author Jonathan Carter
 *
 */
@WebFilter(filterName="ViewerETagFilter")
public class ViewerETagFilter implements Filter
{
    private static final Logger itsLog = LoggerFactory.getLogger(ViewerETagFilter.class);
    private static final String ETAG_REQUEST_HEADER = "If-None-Match";
	
	/**
	 * Default constructor
	 */
	public ViewerETagFilter() 
	{
	
	}

	/**
	 * Manage the finalisation of the filter
	 */
	@Override
	public void destroy() 
	{
		
	}

    /**
	 * Read the CSRF Token from the request and validate it. If not valid,
	 * return an error
	 * 
	 */
	@Override
	public void doFilter(ServletRequest theRequest, ServletResponse theResponse, FilterChain theFilterChain) 
			throws IOException, ServletException 
	{
        itsLog.debug("In doFilter... is this an HTTPServletRequest?");
        // If the request is really an HTTP Servlet request, then process it
        if(theRequest instanceof HttpServletRequest)
        {
            itsLog.debug("....Yes, HttpServletRequest");
            
            // Look at theRequest for the presence of the "If-None-Match" header
            HttpServletRequest anHttpRequest = (HttpServletRequest)theRequest;
            HttpServletResponse anHttpResponse = (HttpServletResponse)theResponse;
            ServletContext aContext = anHttpRequest.getServletContext();
            String anETagFromBrowser = anHttpRequest.getHeader(ETAG_REQUEST_HEADER);            
            itsLog.debug("ETag from Browser is: {}", anETagFromBrowser);

            // Check for the request for a CSRF token first
            String aCsrfTokenRequest = ScriptXSSFilter.filter(anHttpRequest.getParameter("GET-CSRF"));
            itsLog.debug("Is it a CSRF Token request? {}", aCsrfTokenRequest);
            if(aCsrfTokenRequest != null)
            {
                // The browser has asked for the valid CSRF token for the user - get it from user session                
                itsLog.debug("Serving request for user's CSRF Token");
                String aCsrfToken = getCsrfToken(anHttpRequest, anHttpResponse);

                anHttpResponse.setStatus(HttpServletResponse.SC_OK);
                anHttpResponse.setContentType("text/plain");
                anHttpResponse.getWriter().print(aCsrfToken);			
			    anHttpResponse.getWriter().flush();
                return;
            }
            
            // Not a request for the CSRF token, so test the ETag
            if(anETagFromBrowser != null)
            {
                // The browser has supplied the ETag. Now test it
                ViewBrowserCache aBrowserCache = new ViewBrowserCache(aContext);
                
                // Find the User's Hash
                String aUserHash = (String) anHttpRequest.getSession().getAttribute(ViewerSecurityManager.USER_PROFILE_HASH);

                // Get the requested relative path
                String aViewPath = ScriptXSSFilter.filter(anHttpRequest.getParameter("XSL"));
                if(aViewPath == null)
                {
                    aViewPath = aContext.getInitParameter("homeXSLFile");
                }

                // Get the requested repositoryXML 
                String aReposXml = ScriptXSSFilter.filter(anHttpRequest.getParameter("XML"));
                if(aReposXml == null)
                {
                    aReposXml = aContext.getInitParameter("defaultReportFile");
                }
    
                // Compute the current ETag for the requested View
                String aComputedEtag = aBrowserCache.computeETag(aReposXml, aUserHash, aViewPath);

                // Compare to the ETag supplied by the user
                if(aBrowserCache.isMatchingETag(anETagFromBrowser, aComputedEtag))
                {
                    // The cached version that the user has is valid, return HTTP 304
                    anHttpResponse.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                    itsLog.debug("User's If-None-Match header matches cached ETag. Responding with HTTP 304");
                    return;
                }
                else
                {
                    itsLog.debug("User ETag:     {}", anETagFromBrowser);
                    itsLog.debug("Computed ETag: {}", aComputedEtag);
                }
            
                // Couldn't match the user's ETag, so continue                
                theFilterChain.doFilter(theRequest, theResponse);
            }
            else
            {
                // No ETag for this request has been supplied, so continue
                theFilterChain.doFilter(theRequest, theResponse);
            }
        }
        else
        {
            // This wasn't an HTTP Servlet Request, pass on down the filter chain
            theFilterChain.doFilter(theRequest, theResponse);
        }
        
    }

    @Override
	public void init(FilterConfig arg0) throws ServletException 
	{
		
	}

    /**
     * Get the users CSRF Token either from their session or if there is no session,
     * rebuild it and return the token for that session
     * 
     * @param theRequest
     * @param theResponse
     * @return
     */
    private String getCsrfToken(HttpServletRequest theRequest, HttpServletResponse theResponse)
    {
        // Get the user's CSRF Token
        String aToken = (String)theRequest.getSession().getAttribute(LoadCSRF.CSRF_TOKEN);
        itsLog.debug("User's CSRF Token is: {}", aToken);
        
        if(aToken == null)
        {
            itsLog.debug("User CSRF Token could not be found. Re-creating the user's session...");
            
            // Rebuild the user's session and then get the CSRF token
            ViewerSecurityManager aSecurityManager = new ViewerSecurityManager(theRequest.getServletContext());
            itsLog.debug("Instantiated a new ViewerSecurityManager...");

            String aUserSessionXML = aSecurityManager.authenticateUserBySession(theRequest, theResponse);
            itsLog.debug("Got new user session: {}", aUserSessionXML);
            
            // Generate the token and store it in the user's (session)
			aToken = LoadCSRF.generateCsrfToken();
			
			// Add this token to the current request so that it can be used by Viewer to add to XSL parameter
			theRequest.getSession().setAttribute(LoadCSRF.CSRF_TOKEN, aToken);			
			itsLog.debug("Added new CSRF token {} to user with session id {}", aToken, theRequest.getSession().getId());
        }

        return aToken;
    }

}
