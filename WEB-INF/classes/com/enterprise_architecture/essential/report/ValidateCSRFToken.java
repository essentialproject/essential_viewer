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

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.essential.report.api.ApiErrorMessage;
import com.enterprise_architecture.essential.report.api.ApiUtils;

/**
 * Validate a CSRF Token for client requests to relevant resources - e.g. the API 
 * 
 * @author Jonathan Carter
 *
 */
@WebFilter(filterName="ValidateCSRF")
public class ValidateCSRFToken implements Filter 
{
	private static final Logger itsLog = LoggerFactory.getLogger(ValidateCSRFToken.class);
	
	/**
	 * Default constructor
	 */
	public ValidateCSRFToken() 
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
		// The Servlet request will be an HTTP request
		HttpServletRequest anHTTPRequest = (HttpServletRequest)theRequest;
		
		// Get the CSRF token that was sent with the request
		String aToken = (String)anHTTPRequest.getHeader(LoadCSRF.CSRF_TOKEN);
		
		// Validate that this is defined in our cache of CSRF tokens
		String aCachedToken = (String)anHTTPRequest.getSession().getAttribute(LoadCSRF.CSRF_TOKEN);
		if(aCachedToken != null && aCachedToken.equals(aToken))
		{
			// If we have the token in the cache, then all is good and we can continue
			itsLog.debug("CSRF Token accepted: {}", aCachedToken);
			theFilterChain.doFilter(theRequest, theResponse);
		}
		else
		{
			/**
			 * Potential CSRF has been detected and we need to return an error of some kind
			 * Return a 403 code 10 to tell the browser to reload but don't remove the OAuth tokens as these may still be valid.
			 * When the page reloads, ViewerSecurityManager should use the OAuth tokens to create a new session for the user.
			 */
			itsLog.error("CSRF Token not valid. Raising exception to halt processing now. Request: {}", anHTTPRequest.getRequestURL());
			ApiUtils.buildJsonErrorResponse(theResponse, HttpServletResponse.SC_FORBIDDEN, ApiErrorMessage.ErrorCode.BEARER_TOKEN_EXPIRED, "Your session has expired, trying to log you back in.");
		}
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException 
	{
		
	}

}
