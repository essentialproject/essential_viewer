/**
 * Copyright (c)2015-2018 Enterprise Architecture Solutions ltd.
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
 * 24.04.2018	DK	First coding
 */
package com.enterprise_architecture.essential.report.security;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;

/**
 * Servlet implementation class AuthnServerCallback. Receives a redirect back from the AuthN Server
 * containing tokens for the authenticated user.
 */
public class AuthnServerCallback extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AuthnServerCallback() {
		super();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		try {
			//System.out.println("received AuthN Server Callback");

			String accessToken = request.getParameter("access_token");
			String tenantId = request.getParameter("tenantId");
			String stateToken = request.getParameter("state");
			//System.out.println("accessToken: " + accessToken);
			//System.out.println("tenantId: " + tenantId);
			//System.out.println("state: " + stateToken);
			
			//set security context for authenticated account
			ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
			aSecurityMgr.setUserSecurityContext(request, accessToken, tenantId);
			String locationHash = getAppLocationHashFromStateToken(aSecurityMgr, stateToken);
			//System.out.println("redirecting to relative location in app: " + locationHash);

			response.sendRedirect(locationHash);
		} catch (Exception e) {
			System.err.println(e.getMessage());
			e.printStackTrace();
		}
	}

	private String getAppLocationHashFromStateToken(ViewerSecurityManager aSecurityMgr, String stateToken) {
		Jws<Claims> jws = Jwts.parser()
				.requireSubject(ViewerSecurityManager.AUTHN_STATE_TOKEN_SUBJECT)
				.setSigningKey(aSecurityMgr.getPropsAuthnStateSigningKey())
				.parseClaimsJws(stateToken);
		String locationHash = (String) jws.getBody().get(ViewerSecurityManager.AUTHN_STATE_TOKEN_LOCATION_HASH);
		
		//System.out.println("locationHash: "+locationHash);
		
		return locationHash;
	}
	
	

	
}
