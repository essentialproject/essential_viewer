/**
 * Copyright (c)2015-2021 Enterprise Architecture Solutions ltd.
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
 * 20.01.2015	JWC	First coding 
 * 21.05.2015	JWC Added the system admin role check
 * 28.07.2015	JWC Extended to support login for Import Utility app, too
 * 29.09.2015	JWC Reworked authorisation test to use full URLs
 * 08.04.2016	JWC Debugged the logout process
 * 03.07.2017	JWC Re-worked AuthZ to use Neo4J graph database
 * 12.07.2017	JWC Further re-work to include AuthN functionality for User data
 * 17.07.2017	DK 	Re-work AuthN to use Okta REST API
 * 21.07.2017	JWC	Remove trace code and commented-out Stormpath code
 * 28.06.2019	JWC Added use of Log4J 
 * 06.04.2020	JWC Created itsGraphDBDriver member variable for when using with ReportAPI
 * 08.04.2021	JWC Added extra Session variable for the user's Account XML Hash
 */
package com.enterprise_architecture.essential.report.security;


import static org.neo4j.driver.v1.Values.parameters;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.ParseException;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.enterprise_architecture.essential.vieweruserdata.User;
import org.neo4j.driver.v1.AuthTokens;
import org.neo4j.driver.v1.Driver;
import org.neo4j.driver.v1.GraphDatabase;
import org.neo4j.driver.v1.Record;
import org.neo4j.driver.v1.Session;
import org.neo4j.driver.v1.StatementResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.easdatamanagement.model.UserProfile;
import com.enterprise_architecture.essential.report.LoadCSRF;
import com.enterprisearchitecture.oauth.EssCookieUtils;
import com.enterprisearchitecture.oauth.OauthTokenConsumerUtils;
import com.enterprisearchitecture.oauth.exception.OauthBearerTokenExpiredException;
import com.enterprisearchitecture.oauth.exception.OauthRefreshTokenInvalidException;
import com.enterprisearchitecture.oauth.model.OauthBearerTokenClaims;
import com.fasterxml.jackson.databind.ObjectMapper;


/**
 * Class to manage the interface and connection to the User Management Service
 * @author Jonathan Carter
 *
 */
public class ViewerSecurityManager 
{
	private static final Logger itsLog = LoggerFactory.getLogger(ViewerSecurityManager.class);
	
	public static final String AUTHN_STATE_TOKEN_SUBJECT = "state";
	public static final String AUTHN_STATE_TOKEN_LOCATION_HASH = "locationHash";
	
	/** 
	 * Request parameter for the user account token
	 */
	protected static final String USER_ACCOUNT_URL = "accountURL";
	
	protected static final String REPOSITORY_ID_URL = "repositoryID";
	
	protected static final String USER_SESSION_VAR = "userDataSession";

	/**
     * The name of a Session attribute that contains a hash of the User's Profile XML
     */
    public static final String USER_PROFILE_HASH = "user.profile.hash";
	
	public static final String USER_ID = "userId";
	
	public static final String USER_FULLNAME = "userFullname";
	
	public static final String USER_EMAIL = "userEmail";
	
	public static final String TENANT_ID = "tenantId";
	
	protected static final String LOGIN_STATUS_VAR = "loginStatusSession";
	
	protected static final String LOGIN_FAILED_FLAG = "loginFailed";
	
	protected static final String PUBLISH_PERMISSION_SUFFIX = ":publisher";
	
	protected static final String INSTANCE_EDIT_PERMISSION = ":instanceEditor";
	
	protected static final String ACCOUNT_PERMISSIONS_KEY = "springSecurityPermissions";
	
	protected static final String VIEWER_GROUP_CRITERIA = "viewer"; 
	
	protected static final String URL_CUSTOM_DATA_KEY = "url";

	protected static final String TENANT_ID_PREFIX = "tenant.";
	
	protected static final String MIRROR_TENANT_DIR_PREFIX = "mirror.";

	protected static final String PLATFORM_ADMIN_ROLE = "systemRole:systemAdmin";

	protected static final String SYSTEM_ADMIN_ROLE = "systemRole:platformAdmin";
	
	protected static final String ACTIVE_DIR_TENANT_FLAG = "adTenant";
	
	protected static final String URL_COMPARISON_START_STRING = "://";
	
	protected static final String AUTHZ_DB_PROPERTIES = "/WEB-INF/security/.neo4j/neo4j.properties";
	
	public static final String XML_USER_DATA_PACKAGE = "org.enterprise_architecture.essential.vieweruserdata";
	
	public static final String SSO_COOKIE_NAME = "eip.session.token";

	private static final String GRAPH_DB_URI_PROPERTY = "graphDB.uri.property";

	private static final String GRAPH_DB_USER_PROPERTY = "graphDB.username.property";

	private static final String GRAPH_DB_PWD_PROPERTY = "graphDB.password.property";
	
	private static final String AUTHN_SERVER_PROPERTIES_FILE = "/WEB-INF/security/.authn-server/authn-server.properties";
	
	private static final String AUTHN_SERVER_BASE_URL = "loginService.base.url";
	
	private static final String AUTHN_STATE_TOKEN_SIGNING_KEY = "loginService.stateToken.signingKey";
	
	private static final String AUTHN_SERVER_LOGIN_URL = "loginService.login.url";
	
	private static final String AUTHN_SERVER_USER_PROFILE_URL = "loginService.user-profile.url";
	
	private static final String AUTHN_SERVER_REST_LOGIN_URL = "loginService.rest-login.url";
	
	private static final String AUTHN_SERVER_API_KEY = "loginService.apiKey";
	
	private static final String AUTHN_SERVER_OAUTH_TOKEN_URL = "loginService.oauth.token.url";
	
	public static final String USER_TENANT_API_KEY = "tenant.api.key";
	
	public static final String SESSION_ATTR_BEARER_TOKEN = "bearerToken";
	
	public static final String SESSION_ATTR_EIP_SESSION_ID = "eipSessionId";
	
	private static final String EIP_SESSION_ID_COOKIE_NAME = "eip.session.id";

	/**
	  * Maintain the Servlet Context for this instance of the Essential Viewer Engine
	  */
	protected ServletContext itsServletContext = null;
	 
	
	protected Properties itsAuthZProperties = null;
	private Properties itsAuthnServerProperties = null;
	
	/**
	 * Singleton member variable to manage the GraphDB connections
	 */
	private static Driver itsGraphDBDriver = null;
	
	
	
/********************************************************************************************
 * STATIC methods
 *********************************************************************************************/

	/**
	 * Invalidates the user session and removes all authentication token cookies
	 * @param theHttpRequest
	 * @param theHttpResponse
	 * @throws IOException
	 */
	public static void logUserOut(HttpServletRequest theHttpRequest, HttpServletResponse theHttpResponse) {
		itsLog.info("Logging user out, invalidating session and removing all authentication token cookies");

		// remove OAuth tokens
		OauthTokenConsumerUtils.removeAllOauthTokenCookies(theHttpResponse);
		invalidateSession(theHttpRequest);
	}

	/**
	 * Validate that the user has the correct eip session id (the platform session id shared between the apps).
	 * Will invalidate the user session if user has incorrect eip session id.
	 * 
	 * If the eip session id in the request cookie is different to that stored in the user session, then something has changed
	 * (ie. the user has logged in again somewhere else), and then we need to recreate the user session
	 * to remove any stale session data.
	 */
	public static boolean hasValidEipSessionId(HttpServletRequest theRequest) {
		boolean hasValidEipSessionId = true;
		String aCookieEipSessionId = EssCookieUtils.getCookieValue(theRequest, EIP_SESSION_ID_COOKIE_NAME);
		if (aCookieEipSessionId == null) {
			// Missing the eip session id in the request cookies, probably expired, skip the session id check
			itsLog.debug("No eip session id in cookie with name: {}, skipping session id check.", EIP_SESSION_ID_COOKIE_NAME);
		} else {
			String aStoredEipSessionId = (String) theRequest.getSession().getAttribute(SESSION_ATTR_EIP_SESSION_ID);
			if (aStoredEipSessionId == null || !aStoredEipSessionId.equals(aCookieEipSessionId)) {
				itsLog.debug("eip session id in cookies does not match current user session, recreating user session...");
				hasValidEipSessionId = false;
				invalidateSession(theRequest);
				// create a new session and associate the eip.session.id with it
				theRequest.getSession().setAttribute(SESSION_ATTR_EIP_SESSION_ID, aCookieEipSessionId);
			}
		}
		return hasValidEipSessionId;
	}

	private static void invalidateSession(HttpServletRequest theHttpRequest) {
		HttpSession aSession = theHttpRequest.getSession(false);
		if(aSession != null) {
			aSession.invalidate();
			/**
			 * DK 2020-11-30
			 * Workaround to add an anti-CSRF token to the session after we clear the session data, as expected by the transformer.
			 * The LoadCSRF filter is first in the stack so invalidating the session here will delete the CSRF token from the session.
			 * This is fine if we're logging out as we redirect to login but causes a null pointer in the transformer if we are recreating 
			 * the session and serving the page.
			 */
			String aCsrfToken = LoadCSRF.generateCsrfToken();
			theHttpRequest.getSession().setAttribute(LoadCSRF.CSRF_TOKEN, aCsrfToken);
		}
	}

	private static String addPathParameterToUrl(String theUrl, String theKey, String theValue) {
		if (!theUrl.contains(theKey)) {
			throw new IllegalArgumentException("unknown URL path parameter: "+theKey);
		}
		return theUrl.replace(theKey, theValue);
	}

	private static void validateUrl(String theUrl) {
		if (theUrl.contains("{") || theUrl.contains("}")) {
			throw new IllegalArgumentException("URL still contains unsubstituted path parameters: "+theUrl);
		}
	}

	
	
	/********************************************************************************************
	 * PUBLIC and PROTECTED methods
	 *********************************************************************************************/

	/**
	 * Default constructor
	 */
	public ViewerSecurityManager() 
	{
	}
	
	public ViewerSecurityManager(ServletContext theServletContext) 
	{
		itsServletContext = theServletContext;
		
		// 03.07.2017 JWC Load the Neo4J connection details
		itsAuthZProperties = new Properties();
		try
		{
			itsAuthZProperties.load(itsServletContext.getResourceAsStream(AUTHZ_DB_PROPERTIES));
		}
		catch(IOException anAuthZIOEx)
		{
			itsLog.error("ViewerSecurityManager Constructor failed. Could not load AuthZ Properties: {}", anAuthZIOEx);
		}
		
		itsAuthnServerProperties = new Properties();
		try
		{
			itsAuthnServerProperties.load(itsServletContext.getResourceAsStream(AUTHN_SERVER_PROPERTIES_FILE));
		}
		catch(IOException anAuthZIOEx)
		{
			itsLog.error("ViewerSecurityManager Constructor failed. Could not load AuthN Server Properties: {}", anAuthZIOEx);
		}
		
		// initialise driver for Neo4j
		itsGraphDBDriver = getGraphDBDriver();		
		
	}
	
	/** Clean up any resources when the ViewerSecurityManager is destroyed
	 * 
	 */
	public void closeResources()
	{
		itsLog.debug("Closing resources...");
		if(itsGraphDBDriver != null)
		{
			// Only attempt to close the driver if it is not null
			try 
			{
				itsGraphDBDriver.close();
			} catch(Exception e) 
			{
				itsLog.warn("Error closing Neo4j connection, reason: {}", e.getMessage());
			}
		}
	}
	
	/**
	 * property Getters
	 * @return get the AuthN Server Login URL
	 */
	public String getPropsAuthnServerBaseUrl() {
		return itsAuthnServerProperties.getProperty(AUTHN_SERVER_BASE_URL);
	}
	
	/**
	 * property Getters
	 * @return get the AuthN Server Login URL
	 */
	public String getPropsAuthnServerLoginUrl() {
		return itsAuthnServerProperties.getProperty(AUTHN_SERVER_LOGIN_URL);
	}
	
	/**
	 * property Getters
	 * @return get the AuthN Server User Profile URL
	 */
	public String getPropsAuthnServerUserProfileUrl() {
		return itsAuthnServerProperties.getProperty(AUTHN_SERVER_USER_PROFILE_URL);
	}
	
	/**
	 * DK 2020-06-16
	 * TODO remove this property from config, no longer used
	 * 
	 * property Getters
	 * @return get the AuthN Server User Profile URL
	 */
	public String getPropsAuthnServerRestLoginUrl() {
		return itsAuthnServerProperties.getProperty(AUTHN_SERVER_REST_LOGIN_URL);
	}
	
	/**
	 * property Getters
	 * @return get the AuthN Server State Token signing key
	 */
	public String getPropsAuthnStateSigningKey() {
		return itsAuthnServerProperties.getProperty(AUTHN_STATE_TOKEN_SIGNING_KEY);
	}
	
	/**
	 * property Getters
	 * @return get the AuthN Server API Key
	 */
	public String getPropsAuthnApiKey() {
		return itsAuthnServerProperties.getProperty(AUTHN_SERVER_API_KEY);
	}
	
	/**
	 * property Getters
	 * @return get the AuthN Server API Key
	 */
	public String getPropsAuthnServerOauthTokenUrl() {
		return itsAuthnServerProperties.getProperty(AUTHN_SERVER_OAUTH_TOKEN_URL);
	}

	/**
	 * Authenticate the user. Check for user information in the session.
	 * If nothing found, returns NULL, in which case the login authentication
	 * process or check for user token should be used.
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels. Or <tt>null</tt> if no session exists 
	 */
	public String authenticateUserBySession(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		// check on each request, will invalidate the session if not valid
		hasValidEipSessionId(theRequest);

		/**
		 * The logic to get a fresh the bearer token could have been implemented as a Servlet filter 
		 * but we wanted to keep the logic in one class for portability.
		 * 
		 * On each request we test if we have a valid bearer token, including trying to refresh it if it has expired.
		 * If for any reason, we cannot get a valid bearer token, then the user is logged out.
		 * This is usually because the bearer token and refresh token have both expired, requiring the user to log in again.
		 * The refresh token expiry time thus becomes the session expiry time which can then be the same across all apps.
		 * We also get the benefits of Single Sign Out as removing the bearer and refresh token cookies will sign the user out
		 * of all the apps.
		 * 
		 * note - the Tomcat session time no longer signs the user out, once the Tomcat session has expired the user will be
		 * automatically signed back in again if they have a valid bearer token (this is what happens with SSO).
		 * It is good to choose a Tomcat session length that is longer than the refresh token length to avoid unnecessary 
		 * Tomcat session timeouts and auto sign-ins.
		 */
		
		String aUserXml = null;
		if (OauthTokenConsumerUtils.hasBearerTokenOrRefreshToken(theRequest)) {
			try {
				String aLoginServerBaseUrl = getPropsAuthnServerBaseUrl();
				String aLoginServerOauthTokenUrl = getPropsAuthnServerOauthTokenUrl();
				String aLoginServerApiKey = getPropsAuthnApiKey();
				String aFreshBearerToken = OauthTokenConsumerUtils.getFreshBearerToken(theRequest, theResponse, aLoginServerBaseUrl+aLoginServerOauthTokenUrl, aLoginServerApiKey);

				if (!doesBearerTokenBelongToCurrentUser(theRequest, aFreshBearerToken)) {
					/**
					 * We have a valid bearer token but its for a different user than the one in session.
					 * Invalidate the session for the current user and create a new session for the new user.
					 */
					itsLog.debug("OAuth token presented is not for the user currently logged in. Invalidating user session and recreating for new user.");
					invalidateSession(theRequest);
				}
				
				/**
				 * Convert bearer token to a long-life bearer token that can be passed to other services.
				 * Add to session attributes so other methods have access to the long-life token.
				 */
				String aLongLifeBearerToken = OauthTokenConsumerUtils.produceLongLifeBearerToken(aFreshBearerToken);
				theRequest.getSession().setAttribute(ViewerSecurityManager.SESSION_ATTR_BEARER_TOKEN, aLongLifeBearerToken);
				
				aUserXml = getUserXmlFromSession(theRequest, theResponse);
			} catch (OauthRefreshTokenInvalidException e) {
				/**
				 * Normal case - bearer and refresh tokens have expired.
				 * This method will return null which will redirect the user to the login page.
				 */
				itsLog.info(e.getMessage());
			} catch (Exception e) {
				/**
				 * There is some problem refreshing the bearer token so we should log it,
				 * then this method will return null which will redirect the user to the login page.
				 */
				itsLog.info(e.getMessage(), e);
			}
		}
		
		/**
		 * Okay, no user in session and unable to create a session from Oauth cookies.
		 * Let's see if there is a bearer token in the header - this is to support
		 * server-to-server calls to render a view (specifically Gotenberg PDF rendering engine).
		 * 
		 * note - this is expected to be a long-life bearer token from a server-to-server call and therefore we
		 * don't attempt to convert it in to a long-life bearer token.
		 */
		if(aUserXml == null) {
			String aRequestAuthzValue = theRequest.getHeader("Authorization");
			if (aRequestAuthzValue != null) {
				String[] aPartsOfAuthz = aRequestAuthzValue.split(" ");
				if (aPartsOfAuthz.length != 2) {
					itsLog.error("Invalid token, authorisation header value: {}, expecting 2 parts, found {} part(s)", aRequestAuthzValue, aPartsOfAuthz.length);
					throw new IllegalArgumentException("Invalid token");
				}
				String anAuthzType = aPartsOfAuthz[0].trim();
				String anAuthzToken = aPartsOfAuthz[1].trim();
				switch (anAuthzType) {
				case "Bearer":
					aUserXml = authenticateUserByToken(theRequest, anAuthzToken);
					break;
				default:
					itsLog.error("Invalid token, unrecognised authorization type: "+anAuthzType);
					throw new IllegalArgumentException("Invalid token");
				}
			}
		}
		
		// Is there an Account in the User Session?
		if(aUserXml != null)
		{
			// User account has been found, so can find corresponding API Key			
			// Is the API Key already saved in user session?
			String aTenantAPIKey = (String)theRequest.getSession().getAttribute(USER_TENANT_API_KEY);
			
			if(aTenantAPIKey == null)
			{
				// If not, get it from the Graph Database				
				aTenantAPIKey = getUserAPIKeyFromSession(theRequest);

				// And save in the session if it is not null
				if(aTenantAPIKey != null)
				{
					HttpSession aSession = theRequest.getSession(true);
					aSession.setAttribute(USER_TENANT_API_KEY, aTenantAPIKey);
				}
			}
		} else {
			/**
			 * Normal case, user has logged out and we return here with no bearer or refresh token.
			 * This method will return null which will redirect the user to the login page.
			 */
			itsLog.info("No user XML, can be caused by user manually logging out which removes the OAuth token cookies.");
		}
		
		return aUserXml;
	}
	
	/**
	 * Server-to-server token validation
	 * @param theRequest the user request received by the Secure Viewer
	 * @param theBearerToken as retrieved from the user request via the #USER_ACCOUNT_URL parameter
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels. Or <tt>null</tt> if no token exists  	 
	 */
	public String authenticateUserByToken(HttpServletRequest theRequest, String theBearerToken)
	{
		// add to the session attributes in case we need to pass the bearer token on down the stack.
		theRequest.getSession().setAttribute(ViewerSecurityManager.SESSION_ATTR_BEARER_TOKEN, theBearerToken);
		
		String aUserXml = null;
		try {
			OauthBearerTokenClaims aClaims = OauthTokenConsumerUtils.getVerifiedClaimsFromBearerToken(theBearerToken);
			String aUserId = aClaims.getUserId();
			String aTenantId = aClaims.getTenantId();
			
			// note - we haven't retrieved a user profile as we don't need it for server-to-server API calls
			aUserXml = getUserXmlFromUserManager(aUserId);
			if(aUserXml != null)
			{
				setUserSession(theRequest, aUserXml, new UserProfile(aUserId, aTenantId));

				// Have definitely got a session, so find the Api Key for this tenant				
				String aTenantAPIKey = getUserAPIKeyFromSession(theRequest);

				// And save in the session if it is not null
				if(aTenantAPIKey != null)
				{
					HttpSession aSession = theRequest.getSession(true);
					aSession.setAttribute(USER_TENANT_API_KEY, aTenantAPIKey);
				}	
			}
		} catch (Exception e) {
			// just log the problem, this method will return null and the calling method will handle the error
			itsLog.error("Error creating session for user, reason: "+e.getMessage(), e);
		}
		return aUserXml;
	}
	
	/**
	 * Get the custom data for the user's account and return it in XML form, defined by vieweruserdata.xsd
	 * @return XML document representing relevant user data including all clearance levels
	 */
	public String getUserData(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		// Check from user session
		String aUserDataXML = getUserXmlFromSession(theRequest, theResponse);
		
		return aUserDataXML;
	}
	
	/**
	 * Read the user data from the session XML into a useable object
	 * @param theUserXML the XML containing the user information
	 * @return the object that is represented by the XML
	 */
	protected User parseUserData(String theUserXML)
	{
		User aUserInfo = new User();
		
		try
		{
			JAXBContext aContext = JAXBContext.newInstance(XML_USER_DATA_PACKAGE);
			Unmarshaller anUnmarshaller = aContext.createUnmarshaller();
			
			// Read the configuration from from the XML in the input stream
			aUserInfo = (User)anUnmarshaller.unmarshal(IOUtils.toInputStream(theUserXML, "UTF-8"));
			
		}
		catch (Exception e)
		{
			itsLog.error("Error processing user data XML: {}", e);
		}		
		
		return aUserInfo;
	}
	
	/**
	 * Check whether the user is authorised to access this viewer
	 * @param theAccount XML representation
	 * @param theRepositoryURI the ID of the repository that is being provided by this viewer
	 * @param theViewerName the name of the Viewer web application, e.g. 'essential_viewer'
	 * @return true if authorised, false if not
	 */
	public boolean isUserAuthorisedForViewer(String theAccount, String theRepositoryURI, String theViewerName)
	{
		boolean isAuthZ = false;
		
		// Parse the Account XML into a JAXB object
		User aUser = parseUserData(theAccount);
		String anAccountURI = aUser.getUri();
		
		// GOT Viewers List in User object.
		Iterator<String> aViewerListIt = aUser.getViewers().getViewer().iterator();
		while(aViewerListIt.hasNext())
		{
			String aViewerURL = aViewerListIt.next();
			
			// If there's a trailing '/' in the account info, remove it
			if(aViewerURL.endsWith("/"))
			{
				aViewerURL = aViewerURL.substring(0, aViewerURL.length()-1);				
			}			
			if(isGroupForViewer(theViewerName, aViewerURL))
			{
				// Check that account can access repository if the repository URI is not empty
				if(theRepositoryURI != null && !theRepositoryURI.isEmpty())
				{
					if(isUserAuthorisedForRepository(anAccountURI, theRepositoryURI))
					{
						isAuthZ = true;
						break;
					}
				}
				else
				{
					// if the account can access the viewer, they're authorised
					isAuthZ = true;
					break;	
				}				
			}
		}
				
		// If yes, then continue, else isAuthZ is false;
		return isAuthZ;
	}
	
	/**
	 * Check whether the user is authorised to access the repository in this viewer
	 * @param theUserURI the user account URI
	 * @param theRepositoryURI the ID of the repository that is hosted in this viewer
	 * @return true if authorised, false is not
	 */
	public boolean isUserAuthorisedForRepository(String theUserURI, String theRepositoryURI)
	{
		boolean isAuthZ = false;
		
		// Connect to the Graph Database and check user AuthZ
		//Driver aGraphDBDriver = 
		Session aGraphDBSession = getGraphDBDriver().session();
		
		// Query the GraphDB
		StatementResult aResult = aGraphDBSession.run("MATCH (u:User)-[:HAS_REPOSITORY_SETTINGS]->(rs:RepositorySettings{status:'ACTIVE'})-[:BELONGS_TO_REPOSITORY]->(r:Repository) " +
													  "WHERE u.uuid={userUuid} AND r.uuid={repositoryUuid} " +
													  "RETURN r.name AS repositoryName", 
													  parameters("userUuid", theUserURI, "repositoryUuid", theRepositoryURI));
		
		// Read the result set to validate user has permission to access the repository
		// If there is content in the result, then user has permission. If empty set, then no permission. 
		if (aResult.hasNext()) 
		{
			// Can we still succeed without popping the Record?			
			isAuthZ = true;
			
			// DEbug test code
			//System.out.println("Found user has permission to access repository: " + theRepositoryURI);
			// We only need one valid record for success			
		}
		else
		{
			// Log that the user has not been authorized to access the repository
			itsLog.debug("ViewerSecurityManager.isUserAuthorisedForRepository(). User: {} not authorized for repository: {}", theUserURI, theRepositoryURI);
		}
		
		// Release the connection to the Graph Database
		aGraphDBSession.close();		
		
		// End of Graph DB implementation
		
		// If yes, isAuthZ is true, else false
		return isAuthZ;
	}
	
	/**
	 * Check whether the user is authorised to publish to this Viewer
	 * @param theUserURI the user ID
	 * @param theRepositoryURI the ID of the repository that is being published
	 * @return true if authorised, false if not
	 */
	public boolean isUserAuthorisedForPublish(String theUserURI, String theRepositoryURI)
	{
		boolean isAuthZ = false;
		
		// Connect to the Graph Database and check user AuthZ
		Session aGraphDBSession = getGraphDBDriver().session();
		
		// Query the GraphDB
		StatementResult aResult = aGraphDBSession.run("MATCH (u:User)-[:HAS_REPOSITORY_SETTINGS]->(rs:RepositorySettings{status:'ACTIVE'})-[:BELONGS_TO_REPOSITORY]->(r:Repository) " +
													  "WHERE u.uuid={userUuid} AND r.uuid={repositoryUuid} " +
													  "RETURN r.name AS repositoryName, exists((rs)-[:BELONGS_TO_REPOSITORY_ROLE]->(:RepositoryRole{name:'publisher'})) AS hasRole", 
													  parameters("userUuid", theUserURI, "repositoryUuid", theRepositoryURI));
		
		// Read the result set to validate user has permission to access the repository
		// If there is content in the result, then user has permission. If empty set, then no permission. 
		if (aResult.hasNext()) 
		{
			// Can we still succeed without popping the Record?			
			isAuthZ = true;
			
			// DEbug test code
			itsLog.debug("Found user has permission to publish to repository: {}", theRepositoryURI);
			// We only need one valid record for success			
		}
		
		// Release the connection to the Graph Database
		aGraphDBSession.close();		
		
		// End of Graph DB implementation
		
		// If yes, isAuthZ is true, else false
		return isAuthZ;
	}
	
	/**
	 * Check whether the user is authorised to use the Import Utility
	 * @param theUserURI the user ID
	 * @return true if authorised, false if not
	 */
	public boolean isUserAuthorisedForImport(String theUserURI)
	{
		boolean isAuthZ = false;
		
		// Connect to the Graph Database and check user AuthZ		
		Session aGraphDBSession = getGraphDBDriver().session();
		
		// Query the GraphDB
		StatementResult aResult = aGraphDBSession.run("MATCH (u:User)-[:HAS_REPOSITORY_SETTINGS]->(rs:RepositorySettings{status:'ACTIVE'})-[:BELONGS_TO_REPOSITORY]->(r:Repository) " +
													  "WHERE u.uuid={userUuid} " +
													  "RETURN r.name AS repositoryName, exists((rs)-[:BELONGS_TO_REPOSITORY_ROLE]->(:RepositoryRole{name:'instanceEditor'})) AS hasRole", 
													  parameters("userUuid", theUserURI));

		// Read the result set to validate user has permission to access the repository
		// If there is content in the result, then user has permission. If empty set, then no permission. 
		if (aResult.hasNext()) 
		{
			isAuthZ = true;
			
			// DEbug test code
			itsLog.debug("Found user has permission for import. User URI: {}", theUserURI);
			// We only need one valid record for success			
		}

		// Release the connection to the Graph Database
		aGraphDBSession.close();		
		
		// End of Graph DB implementation
		
		// If yes, isAuthZ is true, else false
		return isAuthZ;
	}
	
	/**
	 * Check to see whether the user can access the specified viewer and has a system admin role
	 * @param theAccount the XML representation of the user Account information, e.g. from their session
	 * @param theViewerName the name of the Viewer that they are administering
	 * @return true if the account has correct system admin role
	 */
	public boolean isUserSystemAdminForViewer(String theAccount, String theViewerName)
	{
		boolean isSysAdmin = false;
		
		// DEBUG
		itsLog.debug("Test user authZ-ised with account = {}", theAccount);
		// First test that the user is authorised to access the specified Viewer
		boolean canAccessViewer = isUserAuthorisedForViewer(theAccount, "", theViewerName);
		
		// DEBUG
		itsLog.debug("Viewer = {}", theViewerName);
				
		if(canAccessViewer)
		{
			// Check that they have system admin role
			User aUser = parseUserData(theAccount);
			
			// Get the user account
			String anAccountURI = aUser.getUri();
			
			// DEBUG
			itsLog.debug("User can access viewer. User URI = {}", anAccountURI);	
			
			// Connect to the Graph Database and check user AuthZ
			Session aGraphDBSession = getGraphDBDriver().session();
			
			// DEBUG
			itsLog.debug("ViewerSecurityManager.isUserSystemAdminForViewer(): Test user authZ-ised with account = {}", theAccount);
			
			// Query the GraphDB
			StatementResult aResult = aGraphDBSession.run("MATCH (u:User) " +
														  "WHERE u.uuid={userUuid} " +
														  "RETURN u.firstName AS firstName, u.lastName AS lastName, exists((u)-[:BELONGS_TO_SYSTEM_ROLE]->(:SystemRole{name:'systemAdmin'})) AS hasRole", 
														  parameters("userUuid", anAccountURI));

			// Read the result set to validate user has permission to access the repository
			// If there is content in the result, then user has permission. If empty set, then no permission. 
			if (aResult.hasNext()) 
			{
				isSysAdmin = true;
				
				// DEbug test code
				itsLog.debug("Found user has permission for import. User URI: {}", anAccountURI);
				// We only need one valid record for success
			}
			
			// DEBUG
			itsLog.debug("Tested permission, cleaning up...");
						

			// Release the connection to the Graph Database
			aGraphDBSession.close();			
			
			// END OF GRAPH DB Implementation
		}
		return isSysAdmin;
	}
	
	
/********************************************************************************************
 * PRIVATE methods
 *********************************************************************************************/
	
	/**
	 * Get the user information from the user's session
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels
	 */
	private String getUserXmlFromSession(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		// Look for the user XML in the user session
		String aUserXml = (String)theRequest.getSession().getAttribute(USER_SESSION_VAR);
	
		// If not found, check for SSO Cookie
		if(aUserXml == null)
		{
			try {
				itsLog.debug("No user session, attempting to use bearer token...");
				/**
				 * note - we are using the refreshed bearer token here, not the one from the cookie that might be stale
				 * If we need access to this refreshed nearer token elsewhere, it's stored as a request attribute above.
				 */
				String aBearerToken = (String) theRequest.getSession().getAttribute(ViewerSecurityManager.SESSION_ATTR_BEARER_TOKEN);
				if (aBearerToken != null) {
					OauthBearerTokenClaims aClaims = OauthTokenConsumerUtils.getVerifiedClaimsFromBearerToken(aBearerToken);
					String anAccountID = aClaims.getUserId();
					String aTenantId = aClaims.getTenantId();
					UserProfile aUserProfile = getUserProfile(theRequest, aTenantId, anAccountID);
					aUserXml = getUserXmlFromUserManager(anAccountID, aUserProfile);
					setUserSession(theRequest, aUserXml, aUserProfile);
				}
			} catch (Exception e) {
				/**
				 * There is some problem unpacking the bearer token claims so we should log it,
				 * then this method will return null which will redirect the user to the login page.
				 */
				itsLog.error(e.getMessage(), e);
			}
		}
		return aUserXml;
	}

	public static boolean doesBearerTokenBelongToCurrentUser(HttpServletRequest theRequest, String theFreshBearerToken) throws OauthBearerTokenExpiredException {
		boolean isCorrectBearerToken = false;
		String aUserId = (String) theRequest.getSession().getAttribute(USER_ID);
		String aTenantId = (String) theRequest.getSession().getAttribute(TENANT_ID);
		
		if (aUserId != null && aTenantId != null) {
			// we have a user in session, now check it is the same user as in the bearer token claims
			OauthBearerTokenClaims aClaims = OauthTokenConsumerUtils.getVerifiedClaimsFromBearerToken(theFreshBearerToken);
			if (aClaims.getTenantId().equals(aTenantId) && aClaims.getUserId().equals(aUserId)) {
				itsLog.debug("Bearer token matches, user in session is the same as user in the bearer token claims.");
				isCorrectBearerToken = true;
			} else {
				itsLog.debug("Bearer token does not match, the user in session does not match the user in the bearer token claims.");
			}
		} else {
			// no user in session, so bearer token is okay to use
			itsLog.debug("Bearer token okay, no user in session.");
			isCorrectBearerToken = true;
		}
		return isCorrectBearerToken;
	}
	
	/**
	 * Get the user information from the user management platform
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels
	 */
	private String getUserXmlFromUserManager(String theUserId)
	{		
		return getUserXmlFromUserManager(theUserId, null);
	}

	/**
	 * Get the user information from the user management platform
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels
	 */
	private String getUserXmlFromUserManager(String theUserId, UserProfile theUserProfile)
	{		
		String aUserXml = null;
		Session aGraphDBSession = null;
		
		try
		{
			// Connect to the Graph Database and check user AuthZ
			aGraphDBSession = getGraphDBDriver().session();

			// Process the user account data
			// DEBUG
			itsLog.debug("ViewerSecurityManager.getUserXmlFromUserManager(): Getting User Data for user ID = {}", theUserId);			
			UserDataManager aUserData = new UserDataManager(aGraphDBSession, theUserId, theUserProfile);
			// DEBUG
			itsLog.debug("ViewerSecurityManager.getUserXmlFromUserManager(): UserData XML = {}", aUserData.getUserXML());			
						
			aUserXml = aUserData.getUserXML();
			itsLog.debug("User account XML: {}", aUserXml);
		}
		catch(Exception anEx)
		{
			itsLog.error("SecureViewer: Error authN user: {}"+anEx.getMessage(), anEx);
		}
		finally
		{
			// Close the connections to the database
			if(aGraphDBSession != null)
			{
				aGraphDBSession.close();
			}			
		}
		
		return aUserXml;
	}
	
	/**
	 * Look up the API key for the specified tenant
	 * @param theTenantId
	 * @param theGraphDBSession
	 * @return the API key
	 */
	private String getAPIKeyForTenant(String theTenantId, Session theGraphDBSession)
	{
		String anAPIKey = null;
		StatementResult aResult = theGraphDBSession.run(
				"MATCH (p:Platform)-[:HAS_TENANT]->(t:Tenant) WHERE t.uuid={tenantId} RETURN t.apiKey as apiKey",
				parameters("tenantId", theTenantId));
		
		// Read the result set to find the Graph User Id in the Graph
		if(aResult.hasNext())
		{
			Record aRecord = aResult.next();
			anAPIKey = aRecord.get("apiKey").asString();
		}

		return anAPIKey;
	}

	/**
	 * Add the returned user account details to the user's session
	 * @param theAccountDetails
	 */
	private void setUserSession(HttpServletRequest theRequest, String theAccountDetails, UserProfile aUserProfile)
	{
		HttpSession aSession = theRequest.getSession(true);
		aSession.setAttribute(USER_SESSION_VAR, theAccountDetails);
		aSession.setAttribute(USER_PROFILE_HASH, Integer.toString(theAccountDetails.hashCode()));
		aSession.setAttribute(USER_ID, aUserProfile.getId());
		aSession.setAttribute(USER_FULLNAME, aUserProfile.getFullname());
		aSession.setAttribute(USER_EMAIL, aUserProfile.getEmail());
		aSession.setAttribute(TENANT_ID, aUserProfile.getTenantId());
	}
	
	/**
	 * Compare the specified viewer name with the URL custom data from a Group. If 
	 * they match, then this is the Group for the viewer
	 * @param theViewerName the name of the current viewer application, with its full URL
	 * @param theGroupURL the full URL for a Viewer Group
	 * @return true if theViewerName ends with the value of theGroupURL
	 */
	private boolean isGroupForViewer(String theViewerName, String theGroupURL)
	{
		boolean isGroup = false;
		
		// Test the ViewerName against the GroupName
		// Test the full URL, not just the application name		
		// 01.03.2017 JWC - Trim off the scheme part of both URLs before comparing
		int aViewerURLStart = theViewerName.indexOf(URL_COMPARISON_START_STRING);		
		String aViewerURL = theViewerName.substring(aViewerURLStart);
		
		// If there's a trailing '/' in the viewer URL, remove it
		if(aViewerURL.endsWith("/"))
		{
			aViewerURL = aViewerURL.substring(0, aViewerURL.length()-1);				
		}
		
		itsLog.debug("Requested Viewer URL is: {}", aViewerURL);
		
		String aGroupURL = theGroupURL;
		// If the Group URL starts with https://... trim that off, as per aViewerURL
		int aGroupURLStart = theGroupURL.indexOf(URL_COMPARISON_START_STRING);		
		if(aGroupURLStart >= 0)
		{
			aGroupURL = theGroupURL.substring(aGroupURLStart);		
		}
		
		itsLog.debug("Requested Group URL is: {}", aGroupURL);
		
		//if(aViewerURL.equalsIgnoreCase(aGroupURL))
		String aLowerCaseViewerURL = aViewerURL.toLowerCase();
		if(aLowerCaseViewerURL.endsWith(aGroupURL.toLowerCase()))
		{
			isGroup = true;
		}
		itsLog.debug("User is authZ to see Viewer? is: {}", isGroup);
		
		return isGroup;
	}

	/**
	 * Return a reference to the singleton GraphDB driver
	 * If it is uninitialised (i.e. still == null), create a new instance
	 * Otherwise, return the current instance.
	 * @return a reference to the singleton GraphDB driver
	 */
	private Driver getGraphDBDriver()
	{
		// If the singleton is null, create an instance
		if(itsGraphDBDriver == null)
		{
			itsLog.debug("Creating singleton instance of GraphDBDriver...");
			// initialise driver for Neo4j
			try 
			{
				itsGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
														AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																		itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
			} 
			catch(Exception e) 
			{
				itsLog.error("Could not connect to Neo4j, reason: {}", e.getMessage());
			}
		}
		// Now we know we have an initialised singleton, return it.
		return itsGraphDBDriver;
	}

	private UserProfile getUserProfile(HttpServletRequest theRequest, String tenantId, String userId) throws ParseException, IOException, URISyntaxException {
		CloseableHttpClient client = null;
		try {
			String apiKey = getPropsAuthnApiKey();
			String baseUrl = getPropsAuthnServerBaseUrl();			
			String userProfileUrl = baseUrl+getPropsAuthnServerUserProfileUrl();
			userProfileUrl = addPathParameterToUrl(userProfileUrl, "{tenantId}", tenantId);
			userProfileUrl = addPathParameterToUrl(userProfileUrl, "{userId}", userId);
			validateUrl(userProfileUrl);
			
			
			//trace
			itsLog.debug("getUserProfile from Login App URL: {}", userProfileUrl);
			
			URIBuilder builder = new URIBuilder(userProfileUrl);
			client = HttpClients.createDefault();
			HttpGet httpGet = new HttpGet(builder.build());
			httpGet.addHeader("x-api-key", apiKey);

			CloseableHttpResponse httpResponse = client.execute(httpGet);
			
			HttpEntity entity = httpResponse.getEntity();
			StatusLine status = httpResponse.getStatusLine();
			String responseStr = EntityUtils.toString(entity, StandardCharsets.UTF_8.name());
			if (status.getStatusCode() != 200) {
				throw new IllegalStateException(status+":"+responseStr);
			}
			EntityUtils.consume(entity);
			
			//trace
			itsLog.debug("getUserProfile response: {}", responseStr);
			
			UserProfile aUserProfile = new ObjectMapper().readValue(responseStr, UserProfile.class);
			// tenant id not in the API response, added to POJO for convenience
			aUserProfile.setTenantId(tenantId);
			return aUserProfile;
		} 
		finally 
		{
			if (client != null) 
			{
				try 
				{
					client.close();
				}
				catch (IOException e) 
				{
					itsLog.error("Finally, IOException: {}", e);
				}
			}
		}
	}
	
	/**
	 * Get the API key for the specified user
	 * @param theUserId
	 * @return
	 */
	private String getUserAPIKeyFromSession(HttpServletRequest theRequest)
	{
		String anAPIKey = null;
		
		// Read the User ID from theRequest, if it's not there, return NULL - user not identified
		String aUserId = (String)theRequest.getSession().getAttribute(USER_ID);
		String aTenantId = (String)theRequest.getSession().getAttribute(TENANT_ID);
		
		if(aTenantId == null || aTenantId.isEmpty())
		{
			itsLog.error("No tenant id in user session. Returning NULL Tenant API key.");
			return anAPIKey;
		}
		if(aUserId == null || aUserId.isEmpty())
		{
			itsLog.error("No user id in user session. Returning NULL Tenant API key.");
			return anAPIKey;
		}
		
		// Connect to the Graph Database and check user AuthZ
		Session aGraphDBSession = getGraphDBDriver().session();
		anAPIKey = getAPIKeyForTenant(aTenantId, aGraphDBSession);
			
		// Close the connections to the database
		if(aGraphDBSession != null)
		{
			aGraphDBSession.close();
		}
		return anAPIKey;
	}
	
}
