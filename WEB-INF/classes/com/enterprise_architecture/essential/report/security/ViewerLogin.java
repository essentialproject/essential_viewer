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
 * 19.01.2015	JWC	First coding
 * 24.01.2017	JWC Added validation to login form
 * 28.06.2019	JWC Added use of log4J
 */
package com.enterprise_architecture.essential.report.security;


import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.impl.TextCodec;

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

	private static final String AUTHN_SERVER_CALLBACK_URI = "/authnServerCallback";
	
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(ViewerLogin.class);
	
	
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
		itsLog.debug("Got login request from user: {}, with password: {}, for tenant {}. Requested URL: {}", aUser, aPassword, aTenantName, aRequestedURL);
		
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String baseUrl = "https://"+request.getHeader("host");
		String callbackUri = baseUrl+request.getContextPath()+AUTHN_SERVER_CALLBACK_URI;
		String redirectUrl = getAuthnServerRedirectUrl(aSecurityMgr, aRequestedURL, callbackUri);
		response.sendRedirect(redirectUrl);
	}
	
	private String getAuthnServerRedirectUrl(ViewerSecurityManager aSecurityMgr, String locationHash, String callbackUri) {
		String redirectUrl = null;
		try {
			String nonce = "n-0S6_WzA2Mj"; //TODO generate this everytime and verify it when token returned to prevent replay attacks
			//create JWT to use as state for use when we get called back
			JwtBuilder jwtBuilder = Jwts.builder()
					.setSubject(ViewerSecurityManager.AUTHN_STATE_TOKEN_SUBJECT)
					.claim(ViewerSecurityManager.AUTHN_STATE_TOKEN_LOCATION_HASH, locationHash)
					.signWith(
						SignatureAlgorithm.HS256,
						TextCodec.BASE64.decode(aSecurityMgr.getPropsAuthnStateSigningKey())
						);
			
			String stateToken = jwtBuilder.compact();
			redirectUrl = aSecurityMgr.getPropsAuthnServerLoginUrl()
						+ "?redirect_uri="+URLEncoder.encode(callbackUri, "UTF-8")
						+ "&nonce="+URLEncoder.encode(nonce, "UTF-8")
						+ "&state="+URLEncoder.encode(stateToken, "UTF-8");
			itsLog.debug("AuthN Server redirect URL: {}", redirectUrl);
		} catch (Exception e) {
			itsLog.error("Failed to build URL to redirect to AuthN Server: {}",e);			
			throw new IllegalArgumentException("Failed to contact Authentication Server, unable to authenticate user.");
		}
		return redirectUrl;
	}


}
