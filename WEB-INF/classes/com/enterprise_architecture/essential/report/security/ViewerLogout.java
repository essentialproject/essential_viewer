/**
 * Copyright (c)2015-2019 Enterprise Architecture Solutions ltd.
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
 * 20.04.2015	JWC	First coding 
 * 08.04.2016	JWC Debugged the logout process
 * 28.06.2019	JWC Added use of Log4J
 */
package com.enterprise_architecture.essential.report.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet implementation class ViewerLogout
 * Service to log user out of the Essential Intelligence Platform
 */
public class ViewerLogout extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(ViewerLogout.class);
	
	
	// Define the URL for the homepage of a tenant's selected Viewer
	protected static final String HOME_URL = "";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewerLogout() 
    {
        super();
    }

	/**
	 * Handle the logout request and remove all user sessions and single-sign-on tokens
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
	protected void doGet(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException 
	{
    	// Make sure to redirect to this servlet after logout
    	String aContextPath = theRequest.getContextPath();
    	
    	// TRACE
    	itsLog.debug("Doing logout from context: {}", aContextPath);
    	ViewerSecurityManager.logUserOut(theRequest, theResponse);
    	    	
    	// Redirect to the login page
    	// Authenticated, so redirect to the requested URL			
    	theResponse.sendRedirect(aContextPath + HOME_URL);
	}

}
