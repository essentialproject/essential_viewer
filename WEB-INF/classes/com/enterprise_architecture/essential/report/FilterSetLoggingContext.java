/**
 * Copyright (c)2021 Enterprise Architecture Solutions ltd. and the Essential Project
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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

/**
 * Filter to set the logging context
 * 
 * @author David Kumar
 *
 */
@WebFilter(filterName="SetLoggingContext")
public class FilterSetLoggingContext implements Filter {
	@SuppressWarnings("unused")
	private static final Logger itsLog = LoggerFactory.getLogger(FilterSetLoggingContext.class);
	@SuppressWarnings("unused")
	private ServletContext myServletContext;

	private static final String LOGGER_TENANT_CONTEXT = "log-tenantId";
	private static final String LOGGER_USER_CONTEXT = "log-userId";
	private static final String LOGGER_CORRELATION_CONTEXT = "log-correlationId";
	private static final String LOGGER_NO_CONTEXT = "NO CONTEXT";
	private static final String HEADER_REQUEST_ID = "x-request-id";


	
	/**
	 * Default constructor
	 */
	public FilterSetLoggingContext() { /* do nothing */ }
	
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

		// set the logging context on every request
		String aCorrelationId = anHTTPRequest.getHeader(HEADER_REQUEST_ID);
		String correlationContext = aCorrelationId == null ? LOGGER_NO_CONTEXT : aCorrelationId;
		MDC.put(LOGGER_CORRELATION_CONTEXT, correlationContext);
		// no tenant or user context this early in the request, just set it to empty string for now
		MDC.put(LOGGER_TENANT_CONTEXT, "");
		MDC.put(LOGGER_USER_CONTEXT, "");
		
		// continue the filter chain
		theFilterChain.doFilter(theRequest, theResponse);
	}
	

}
