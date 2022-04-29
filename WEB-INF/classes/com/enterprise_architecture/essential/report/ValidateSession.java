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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.essential.report.api.ApiErrorMessage;
import com.enterprise_architecture.essential.report.api.ApiUtils;
import com.enterprise_architecture.essential.report.security.ViewerSecurityManager;

/**
 * Filter for API calls to validate the user has a valid session
 * If not return the correct response code to tell the client to log the user out 
 * 
 * @author David Kumar
 *
 */
@WebFilter(filterName="ValidateSession")
public class ValidateSession implements Filter {
	private static final Logger myLog = LoggerFactory.getLogger(ValidateSession.class);
	@SuppressWarnings("unused")
	private ServletContext myServletContext;
	
	/**
	 * Default constructor
	 */
	public ValidateSession() { /* do nothing */ }
	
	/**
	 * Manage the finalisation of the filter
	 */
	@Override
	public void destroy() { /* do nothing */ }

	@Override
	public void init(FilterConfig theConfig) throws ServletException {
		myServletContext = theConfig.getServletContext();
	}

	@Override
	public void doFilter(ServletRequest theRequest, ServletResponse theResponse, FilterChain theFilterChain) throws IOException, ServletException {
		// The Servlet request will be an HTTP request
		HttpServletRequest anHTTPRequest = (HttpServletRequest) theRequest;
		
		// Validate that the user has a session - pass in false to getSession() to prevent the creation of a new session
		if (anHTTPRequest.getSession(false) == null) {
			/**
			 * Session expired.
			 * Return a 403 code 10 to tell the browser to reload but don't remove the OAuth tokens as these may still be valid.
			 * When the page reloads, ViewerSecurityManager should use the OAuth tokens to create a new session for the user.
			 */
			myLog.info("Session expired, sending response code to tell client to reload app to try and rebuild session.");
			ApiUtils.buildJsonErrorResponse(theResponse, HttpServletResponse.SC_FORBIDDEN, ApiErrorMessage.ErrorCode.BEARER_TOKEN_EXPIRED, "Your session has expired, trying to log you back in.");
		} else if (!ViewerSecurityManager.hasValidEipSessionId(anHTTPRequest)) {
			/**
			 * eip session id invalid.
			 * Return a 403 code 10 to tell the browser to reload but don't remove the OAuth tokens as these may still be valid.
			 * When the page reloads, ViewerSecurityManager should use the OAuth tokens to create a new session for the user.
			 */
			myLog.info("eip session id invalid, sending response code to tell client to reload app to try and rebuild session.");
			ApiUtils.buildJsonErrorResponse(theResponse, HttpServletResponse.SC_FORBIDDEN, ApiErrorMessage.ErrorCode.BEARER_TOKEN_EXPIRED, "Your session has expired, trying to log you back in.");
		} else {
			theFilterChain.doFilter(theRequest, theResponse);
		}
	}
	

}
