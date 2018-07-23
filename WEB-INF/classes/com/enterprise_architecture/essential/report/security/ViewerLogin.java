/**
 * Copyright (c)2015-2017 Enterprise Architecture Solutions ltd.
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
 * 24.01.2017	JWC Added validation to login form
 */
package com.enterprise_architecture.essential.report.security;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.IOUtils;
import org.enterprise_architecture.essential.vieweruserdata.User;

/**
 * Servlet implementation class ViewerLogin.
 * Manages login requests from clients by validating the user credentials against the user management 
 * components
 */
public class ViewerLogin extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	
	private static final String USER_ID_PARAM = "username";
	
	private static final String PASSWORD_PARAM = "password";
	
	private static final String TENANT_NAME_PARAM = "tenantName";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewerLogin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		// Read the supplied parameters
		String aUser = request.getParameter(USER_ID_PARAM);
		String aPassword = request.getParameter(PASSWORD_PARAM);
		String aTenantName = request.getParameter(TENANT_NAME_PARAM);
		String aRequestedURL = request.getParameter(SecureEssentialViewerEngine.PRE_LOGIN_URL);
		
		// TRACE
		//System.out.println("Got login request from user: " + aUser);
		//System.out.println("With password =" + aPassword);
		//System.out.println("For tenant: " + aTenantName);
		//System.out.println("Requested URL: " + aRequestedURL);
		// END TRACE
		
		// Ensure that values for tenant, user and password have been supplied
		if(aTenantName.length() > 0 && aUser.length() > 0 && aPassword.length() > 0)
		{
			// Sufficient details have been supplied
		
			// Got the parameters get the Account details and save in Application params:
			ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
			String anAccount = aSecurityMgr.authenticateUserByLogin(request, aTenantName, aUser, aPassword);
			
			if(anAccount != null)
			{
				// TRACE 
				//System.out.println("Logged in - got account");
				
				// Set the SSO Token for single-sign on
				String anAccountID = getAccountID(anAccount);
				String aDomain = request.getServerName();
				EipSSOCookie aCookie = new EipSSOCookie(getServletContext());
				aCookie.setAccountID(request, response, anAccountID, aDomain);
				
				// Remove any error flag from session
				request.getSession().removeAttribute(ViewerSecurityManager.LOGIN_STATUS_VAR);
				
				// Authenticated, so redirect to the requested URL			
				response.sendRedirect(aRequestedURL);
			}
			else
			{
				// Continue on to the error report step
				
				// TRACE 
				//System.out.println("Details supplied but login failed - account is null");				
			}
		}
		else
		{
			// Catch that details were missing on the form from user
			// TRACE 
			//System.out.println("Login failed - missing details from user");
						
			// Not Authenticated, so redirect to login page
			HttpSession aSession = request.getSession(true);
			aSession.setAttribute(ViewerSecurityManager.LOGIN_STATUS_VAR, ViewerSecurityManager.LOGIN_FAILED_FLAG);
			response.sendRedirect(aRequestedURL);
		}
		
	}
	
	/**
	 * Find the ID of the Account from the XML representation of the account details
	 * @param theAccountXML the user data in XML format
	 * @return the ID of the Account
	 */
	protected String getAccountID(String theAccountXML)
	{
		String anAccountID = "";
		User aUserInfo = new User();
		
		try
		{
			JAXBContext aContext = JAXBContext.newInstance(ViewerSecurityManager.XML_USER_DATA_PACKAGE);
			Unmarshaller anUnmarshaller = aContext.createUnmarshaller();
			
			// Read the configuration from from the XML in the input stream
			aUserInfo = (User)anUnmarshaller.unmarshal(IOUtils.toInputStream(theAccountXML));
			anAccountID = aUserInfo.getUri();				
		}
		catch (JAXBException aJaxbEx)
		{
			System.err.println("ViewerSecurityManager Error processing user data XML");
			System.err.println("Message: " + aJaxbEx.getLocalizedMessage());
			aJaxbEx.printStackTrace();
		}		
		catch (IllegalArgumentException anIllegalArgEx)
		{
			System.err.println("ViewerSecurityManager Error processing user data XML");
			System.err.println("Message: " + anIllegalArgEx.getLocalizedMessage());
			anIllegalArgEx.printStackTrace();
		}
		
		return anAccountID;
	}

}
