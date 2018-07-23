/**
 * Copyright (c)2012-2013 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 25.06.2012	JWC	First implementation of shared Essential Language Service
 * 26.02.2013	JWC Updated to use a servlet-to-servlet forward rather than redirect to support
 * 					caching
 * 05.03.2013	JWC Back to the re-direct approach to ensure that the target page (after selecting
 * 					language) can be cached.
 * 
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * REST-style Service Servlet to set the display language for Essential Viewer for the user that is
 * calling the service via an HTTP. Note that GET is also supported, although REST convention dictates that POST is preferred.
 * The service sets a user cookie to the selected IETF language flag (as recommended by W3C). 
 * Parameters supported by the service are as follows:
 * <ul>
 * <li>i18n - the selected IETF language flag, e.g. en-gb</li>
 * <li>currentPage - the URL of the current page that was being viewed when the language was selected. 
 * This is used by the EssentialLanguageService to return the user to that page once the language selection has
 * been recorded - and is then applied to the currentPage.</li>
 * </ul>
 * The service also uses Servlet Context parameters that are set in <tt>web.xml</tt>:
 * <ul>
 * <li>i18nCookieName - the name of the Cookie to set. REQUIRED</li>
 * <li>i18nDefault - the default IETF language selection. If no value is set by the user, this value will be used in the users' Cookie.</li>
 * <li>i18nCookieDomain - the domain value to be used by the Cookie. Can be used when hosting Essential Viewer across multiple
 * servers and you wish the users' language choice to apply across all Essential Viewer servers in a domain. Leave this empty if no domain setting is required. OPTIONAL</li>
 * <li>cookieTimeout - the time in seconds that the Cookie remains valid on the users' browser</li>
 * </ul>
 * @author Jonathan W. Carter <info@enterprise-architecture.com>
 * @version 1.2
 * @see com.enterprise_architecture.essential.report.EssentialLanguageCookie EssentialLanguageCookie
 */
public class EssentialLanguageService extends HttpServlet implements javax.servlet.Servlet
{	
	/**
	 * Service parameter name to hold the language code.
	 */
	private static final String LANGUAGE_PARAM = "i18n";
	
	/**
	 * Service parameter name to hold the return URL value.
	 */
	private static final String RETURN_URL_PARAM = "currentPage";
		
	/**
	 * Override the initialisation and initialise the service
	 */
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		
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
		// Get the request parameters
		String aSelectedLanguage = theRequest.getParameter(LANGUAGE_PARAM);
		String aReturnURL = theRequest.getParameter(RETURN_URL_PARAM);
		
		// Get the user's Cookie
		EssentialLanguageCookie aCookie = new EssentialLanguageCookie(getServletContext());		
		
		// Set the cookie as required		
		aCookie.setLanguage(theRequest, theResponse, aSelectedLanguage);
	
		// Return them to the page that they came from
		theResponse.sendRedirect(aReturnURL);
		//theRequest.getRequestDispatcher(aReturnURL).forward(theRequest, theResponse);
	}
	
	/**
	 * Process the request message from the client and perform the specified actions
	 * @param theRequest the client request object
	 * @param theResponse the object in which to return the response
	 * @throws ServletException if any problems are encountered
	 * @throws IOException if any I/O errors are encountered. 
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException
	{
		// Forward to doGet - as servlet supports POST and GET similarly and ensures consistency
		doGet(theRequest, theResponse);
	}
}
