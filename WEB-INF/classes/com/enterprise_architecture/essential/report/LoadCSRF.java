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
 * 27.03.2019	JWC	First implementation of CSRF filter
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;
import java.security.SecureRandom;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Load a CSRF Token into every client request and add it to the user session
 * 
 * @author Jonathan Carter
 *
 */
@WebFilter(filterName="LoadCSRFFilter")
public class LoadCSRF implements Filter 
{
	/**
	 * Name of the CSRF Token session attribute
	 */
	public static final String CSRF_TOKEN_CACHE = "csrfTokenCache";
	public static final String CSRF_TOKEN = "X-CSRF-TOKEN";
	
	private static final Logger itsLog = LoggerFactory.getLogger(LoadCSRF.class); 

	/**
	 * Default constructor for the CSRF Token loader
	 */
	public LoadCSRF() 
	{
		
	}

	/**
	 * Manage the destruction of this filter
	 * 
	 */
	@Override
	public void destroy() 
	{
		
	}

	/**
	 * Do the filter. Process the servlet request and check for the token
	 * in the user session.
	 */
	@Override
	public void doFilter(ServletRequest theRequest, 
						 ServletResponse theResponse,
						 FilterChain theFilterChain) 
								 throws IOException, ServletException 
	{
		// The Servlet Request will be an HTTP Request
		HttpServletRequest anHttpRequest = (HttpServletRequest) theRequest;
		itsLog.debug("CSRF filter invoked for request for resource {}", anHttpRequest.getRequestURI());
		
		// Check the user session for the CSRF Token
		String aUserToken = (String)anHttpRequest.getSession().getAttribute(CSRF_TOKEN);
		
		// If there is no user token, create it
		if(aUserToken == null)
		{
			// Generate the token and store it in the user's (session)
			String aToken = generateCsrfToken();
			
			// Add this token to the current request so that it can be used by Viewer to add to XSL parameter
			anHttpRequest.getSession().setAttribute(CSRF_TOKEN, aToken);			
			itsLog.debug("Added new CSRF token {} to user with session id {}", aToken, anHttpRequest.getSession().getId());
		}
		else
		{
			itsLog.debug("User with session id {} already has CSRF token {}", anHttpRequest.getSession().getId(), aUserToken);
		}
		
		// Continue the filter chain...
		theFilterChain.doFilter(theRequest, theResponse);
	}

	/** 
	 * Initialise the filter
	 */
	@Override
	public void init(FilterConfig arg0) throws ServletException 
	{
			
	}

	public static String generateCsrfToken() {
		return RandomStringUtils.random(20, 0, 0, true, true, null, new SecureRandom());
	}

}
