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
import java.util.Properties;

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
import com.enterprisearchitecture.oauth.OauthTokenConsumerUtils;
import com.enterprisearchitecture.oauth.exception.OauthRefreshTokenInvalidException;

/**
 * @author David Kumar
 *
 * Requests can pass through this filter will check if the Bearer token in the request cookies is valid - so verify the signature and check it hasn't expired.
 * If the token has expired, attempt to refresh it using the refresh token (also a cookie).
 * Write the fresh bearer token in to the session attribute.
 * 
 * In all other cases the request will fail, for example:
 * - if the bearer token cannot be verified
 * - if the bearer token has expired but cannot be refreshed
 */
@WebFilter(filterName="ValidateOauthBearerToken")
public class ValidateOauthBearerToken implements Filter {
	private static final Logger myLog = LoggerFactory.getLogger(ValidateOauthBearerToken.class);
	

	private static final String AUTHN_SERVER_PROPERTIES_FILE = "/WEB-INF/security/.authn-server/authn-server.properties";
	private static final String BASE_URL_PROPERTY = "loginService.base.url";
	private static final String OAUTH_TOKEN_URL_PROPERTY = "loginService.oauth.token.url";
	private static final String API_KEY_PROPERTY = "loginService.apiKey";

	
	
	private String myLoginServerBaseUrl;
	private String myLoginServerOauthTokenUrl;
	private String myLoginServerApiKey;
	@SuppressWarnings("unused")
	private ServletContext myServletContext;

	
	/**
	 * Default constructor
	 */
	public ValidateOauthBearerToken() { /* do nothing */ }
	
	/**
	 * Manage the finalisation of the filter
	 */
	@Override
	public void destroy() { /* do nothing */ }
	
	@Override
	public void init(FilterConfig theConfig) throws ServletException {
		myServletContext = theConfig.getServletContext();
		Properties anAuthnServerProperties = getAllApplicationPropertiesFromFile(AUTHN_SERVER_PROPERTIES_FILE, theConfig.getServletContext());
		myLoginServerBaseUrl = anAuthnServerProperties.getProperty(BASE_URL_PROPERTY);
		if (myLoginServerBaseUrl == null || myLoginServerBaseUrl.trim().isEmpty()) {
			myLog.error("No login server base url defined. Make sure to set the {} property in the property file {}", BASE_URL_PROPERTY, AUTHN_SERVER_PROPERTIES_FILE);
		}
		myLoginServerOauthTokenUrl = anAuthnServerProperties.getProperty(OAUTH_TOKEN_URL_PROPERTY);
		if (myLoginServerOauthTokenUrl == null || myLoginServerOauthTokenUrl.trim().isEmpty()) {
			myLog.error("No login server OAuth Token url defined. Make sure to set the {} property in the property file {}", OAUTH_TOKEN_URL_PROPERTY, AUTHN_SERVER_PROPERTIES_FILE);
		}
		myLoginServerApiKey = anAuthnServerProperties.getProperty(API_KEY_PROPERTY);
		if (myLoginServerApiKey == null || myLoginServerApiKey.trim().isEmpty()) {
			myLog.error("No login server API key defined. Make sure to set the {} property in the property file {}", API_KEY_PROPERTY, AUTHN_SERVER_PROPERTIES_FILE);
		}
	}

	@Override
	public void doFilter(ServletRequest theRequest, ServletResponse theResponse, FilterChain theFilterChain) throws IOException, ServletException {
		// The Servlet request will be an HTTP request
		HttpServletRequest anHttpRequest = (HttpServletRequest) theRequest;
		HttpServletResponse anHttpResponse = (HttpServletResponse) theResponse;
		
		try {
			String aSessionBearerToken = null;
			if (OauthTokenConsumerUtils.hasBearerTokenOrRefreshToken(anHttpRequest)) {
				/**
				 * Cookie based AuthZ.
				 * Convert the bearer token to a long-life bearer token and add it to a session attribute and continue processing the filter chain.
				 * We add it to the session attribute to allow processes further down the request chain to have access to
				 * a long-life token they can call other services with.
				 * 
				 * Else if we were not able to refresh the bearer token, send a specific error code to allow the client to take action.
				 * 
				 * note - we only catch OauthBearerTokenExpiredException exceptions here as any exception thrown
				 * lower down the chain will pass through this filter and we only want to log out the user if there
				 * was a problem with their bearer token.
				 */
				String aFreshBearerToken = OauthTokenConsumerUtils.getFreshBearerToken(anHttpRequest, anHttpResponse, myLoginServerBaseUrl+myLoginServerOauthTokenUrl, myLoginServerApiKey);
				if (!ViewerSecurityManager.doesBearerTokenBelongToCurrentUser(anHttpRequest, aFreshBearerToken)) {
					/**
					 * We have a valid bearer token but its for a different user than the one in session.
					 * Return a 403 code 10 to tell the browser to reload but don't remove the OAuth tokens as these may still be valid.
					 * When the page reloads, ViewerSecurityManager should use the OAuth tokens to create a new session for the user.
					 */
					myLog.warn("OAuth token presented is not for the user currently logged in. Log user out and create session for new user.");
					ApiUtils.buildJsonErrorResponse(anHttpResponse, HttpServletResponse.SC_FORBIDDEN, ApiErrorMessage.ErrorCode.BEARER_TOKEN_EXPIRED, "Bearer token is invalid or has expired and cannot be refreshed, please log back in.");
				}
				aSessionBearerToken = OauthTokenConsumerUtils.produceLongLifeBearerToken(aFreshBearerToken);
				myLog.info("Valid bearer token in cookies");
			} else {
				
				// TODO no cookies and no header
				
				/**
				 * Okay, no Oauth cookies.
				 * Let's see if there is a bearer token in the header - this is to support
				 * server-to-server calls to render a view (specifically Gotenberg PDF rendering engine).
				 * 
				 * note - this is expected to be a long-life bearer token from a server-to-server call and therefore we
				 * don't attempt to convert it in to a long-life bearer token.
				 */
				String aRequestAuthzValue = anHttpRequest.getHeader("Authorization");
				if (aRequestAuthzValue == null) {
					throw new IllegalArgumentException("Invalid token, no authorisation header found");
				}
				String[] aPartsOfAuthz = aRequestAuthzValue.split(" ");
				if (aPartsOfAuthz.length != 2) {
					throw new IllegalArgumentException("Invalid token, authorisation header value: "+aRequestAuthzValue+", expecting 2 parts, found "+aPartsOfAuthz.length+" part(s)");
				}
				String anAuthzType = aPartsOfAuthz[0].trim();
				String anAuthzToken = aPartsOfAuthz[1].trim();
				switch (anAuthzType) {
				case "Bearer":
					OauthTokenConsumerUtils.getVerifiedClaimsFromBearerToken(anAuthzToken);
					aSessionBearerToken = anAuthzToken;
					myLog.info("Valid bearer token in header");
					break;
				default:
					throw new IllegalArgumentException("Invalid token, unrecognised authorization type: "+anAuthzType);
				}
			}
			
			if (aSessionBearerToken == null) {
				throw new IllegalArgumentException("No bearer token found");
			}
			anHttpRequest.getSession(false).setAttribute(ViewerSecurityManager.SESSION_ATTR_BEARER_TOKEN, aSessionBearerToken);
			theFilterChain.doFilter(theRequest, theResponse);
		} catch (OauthRefreshTokenInvalidException e) {
			/**
			 * Normal case - bearer and refresh tokens have expired.
			 */
			myLog.debug(e.getMessage(), e);
			buildErrorResponseAndLogUserOut(anHttpRequest, anHttpResponse);
		} catch (Exception e) {
			/**
			 * Log this as an error, something has gone wrong refreshing the bearer token
			 */
			myLog.error(e.getMessage(), e);
			buildErrorResponseAndLogUserOut(anHttpRequest, anHttpResponse);
		}
	}
	
	
	
	/*********************************************************************************************************
	 * PRIVATE methods
	 *********************************************************************************************************/
	
	private Properties getAllApplicationPropertiesFromFile(String thePropertiesFile, ServletContext theServletContext) {
		Properties aPropertyList = new Properties();
		try {
			aPropertyList.load(theServletContext.getResourceAsStream(thePropertiesFile));
		} catch(IOException anIOEx) {
			myLog.error("Could not load application properties file: {}", thePropertiesFile);
			myLog.error(anIOEx.toString());
		}
		return aPropertyList;
	}
	
	private void buildErrorResponseAndLogUserOut(HttpServletRequest theHttpRequest, HttpServletResponse theHttpResponse) throws IOException {
		ViewerSecurityManager.logUserOut(theHttpRequest, theHttpResponse);
		ApiUtils.buildJsonErrorResponse(theHttpResponse, HttpServletResponse.SC_FORBIDDEN, ApiErrorMessage.ErrorCode.BEARER_TOKEN_EXPIRED, "Bearer token is invalid or has expired and cannot be refreshed, please log back in.");
	}

}
