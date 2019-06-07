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
 * 20.01.2015	JWC	First coding 
 * 21.05.2015	JWC Added the system admin role check
 * 28.07.2015	JWC Extended to support login for Import Utility app, too
 * 29.09.2015	JWC Reworked authorisation test to use full URLs
 * 08.04.2016	JWC Debugged the logout process
 * 03.07.2017	JWC Re-worked AuthZ to use Neo4J graph database
 * 12.07.2017	JWC Further re-work to include AuthN functionality for User data
 * 17.07.2017	DK 	Re-work AuthN to use Okta REST API
 * 21.07.2017	JWC	Remove trace code and commented-out Stormpath code 
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
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpHeaders;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
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

import com.enterprise_architecture.easdatamanagement.model.AuthenticatedUser;
import com.enterprise_architecture.easdatamanagement.model.UserCredentials;
import com.enterprise_architecture.easdatamanagement.model.UserProfile;
import com.fasterxml.jackson.databind.ObjectMapper;


/**
 * Class to manage the interface and connection to the User Management Service
 * @author Jonathan Carter
 *
 */
public class ViewerSecurityManager 
{
	
	public static final String AUTHN_STATE_TOKEN_SUBJECT = "state";
	public static final String AUTHN_STATE_TOKEN_LOCATION_HASH = "locationHash";
	
	/** 
	 * Request parameter for the user account token
	 */
	protected static final String USER_ACCOUNT_URL = "accountURL";
	
	protected static final String REPOSITORY_ID_URL = "repositoryID";
	
	protected static final String USER_SESSION_VAR = "userDataSession";
	
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
	
	
	
	/**
	  * Maintain the Servlet Context for this instance of the Essential Viewer Engine
	  */
	protected ServletContext itsServletContext = null;
	 
	
	protected Properties itsAuthZProperties = null;
	private Properties itsAuthnServerProperties = null;
	

	/*
	 * TODO move to Utils package
	 */
	private static String addPathParameterToUrl(String theUrl, String theKey, String theValue) {
		if (!theUrl.contains(theKey)) {
			throw new IllegalArgumentException("unknown URL path parameter: "+theKey);
		}
		return theUrl.replace(theKey, theValue);
	}

	/*
	 * TODO move to Utils package
	 */
	private static void validateUrl(String theUrl) {
		if (theUrl.contains("{") || theUrl.contains("}")) {
			throw new IllegalArgumentException("URL still contains unsubstituted path parameters: "+theUrl);
		}
	}

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
			System.err.println("ViewerSecurityManager Constructor failed. Could not load AuthZ Properties");
		}
		
		itsAuthnServerProperties = new Properties();
		try
		{
			itsAuthnServerProperties.load(itsServletContext.getResourceAsStream(AUTHN_SERVER_PROPERTIES_FILE));
		}
		catch(IOException anAuthZIOEx)
		{
			System.err.println("ViewerSecurityManager Constructor failed. Could not load AuthN Server Properties");
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
	 * Test whether the specified account is authorised to perform the specified role
	 * @param theAccount
	 * @param theRole
	 * @return
	 */
	/*public boolean isAccountAuthZ(String theAccount, String theRole)
	{
		// Is the supplied account valid?
		if(theAccount != null)
		{
			return true;
		}
		else
			return false;
		//return false;
	}*/

	public AuthenticatedUser authenticateUserByLogin(HttpServletRequest theRequest, String theTenant, String theUsername, String thePassword) {
		CloseableHttpClient client = null;
		try {
			String restLoginUrl = getPropsAuthnServerRestLoginUrl();
			validateUrl(restLoginUrl);
			URIBuilder builder = new URIBuilder(restLoginUrl);
			client = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(builder.build());
			UserCredentials userCredentials = new UserCredentials(theTenant, theUsername, thePassword);
			ObjectMapper mapper = new ObjectMapper();
			String json = mapper.writeValueAsString(userCredentials);
			httpPost.setEntity(new StringEntity(json));
			httpPost.addHeader(HttpHeaders.CONTENT_TYPE, "application/json");

			CloseableHttpResponse httpResponse = client.execute(httpPost);
			
			HttpEntity entity = httpResponse.getEntity();
			StatusLine status = httpResponse.getStatusLine();
			String responseStr = EntityUtils.toString(entity, StandardCharsets.UTF_8.name());
			if (status.getStatusCode() != 200) {
				System.err.println("SecureViewer: Error authN user");
				return null;
			}
			EntityUtils.consume(entity);
			return new ObjectMapper().readValue(responseStr, AuthenticatedUser.class);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (client != null) {
				try {
					client.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	/**
	 * Authenticate the user. Check for user information in the session.
	 * If nothing found, returns NULL, in which case the login authentication
	 * process or check for user token should be used.
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels. Or <tt>null</tt> if no session exists 
	 */
	public String authenticateUserBySession(HttpServletRequest theRequest)
	{
		String anAccount = null;
		
		// Is there an Account in the User Session?
		anAccount = getAccountFromSession(theRequest);
		
		return anAccount;
	}
	
	/**
	 * Server-to-server token validation
	 * @param theRequest the user request received by the Secure Viewer
	 * @param theUserToken as retrieved from the user request via the #USER_ACCOUNT_URL parameter
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels. Or <tt>null</tt> if no token exists  	 
	 */
	public String authenticateUserByToken(HttpServletRequest theRequest, String theUserToken)
	{
		String anAccount = null;
		anAccount = getAccountFromUserManager(theUserToken); //we don't have a user profile but don't need it for server-to-server API calls
		if(anAccount != null)
		{
			setUserSession(theRequest, anAccount);
		}
		return anAccount;
	}
	
	public String setUserSecurityContext(HttpServletRequest theRequest, String theAccessToken, String theTenantId)
	{
		String anAccount = null;
		String aUserId = theAccessToken; //TODO review, access token is currently the user id
		UserProfile aUserProfile = getUserProfile(theRequest, theTenantId, aUserId);
		anAccount = getAccountFromUserManager(aUserId, aUserProfile);
		if (anAccount != null)
		{
			// Keep the session
			setUserSession(theRequest, anAccount);
		}
		return anAccount;
	}
	
	/**
	 * Get the custom data for the user's account and return it in XML form, defined by vieweruserdata.xsd
	 * @return XML document representing relevant user data including all clearance levels
	 */
	public String getUserData(HttpServletRequest theRequest)
	{
		String aUserDataXML = "";
		
		// Check from user session
		aUserDataXML = getAccountFromSession(theRequest);
		
		return aUserDataXML;
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
		Driver aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
													 AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																 	  itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
		Session aGraphDBSession = aGraphDBDriver.session();
		
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
			System.out.println("ViewerSecurityManager.isUserAuthorisedForRepository(). User: " + theUserURI + " not authorized for repository: " + theRepositoryURI);
		}
		
		// Release the connection to the Graph Database
		aGraphDBSession.close();
		aGraphDBDriver.close();
		
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
		Driver aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
													 AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																 	  itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
		Session aGraphDBSession = aGraphDBDriver.session();
		
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
			// System.out.println("Found user has permission to publish to repository: " + theRepositoryURI);
			// We only need one valid record for success			
		}
		
		// Release the connection to the Graph Database
		aGraphDBSession.close();
		aGraphDBDriver.close();
		
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
		Driver aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
													 AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																 	  itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
		Session aGraphDBSession = aGraphDBDriver.session();
		
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
			//System.out.println("Found user has permission for import. User URI: " + theUserURI);
			// We only need one valid record for success			
		}

		// Release the connection to the Graph Database
		aGraphDBSession.close();
		aGraphDBDriver.close();
		
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
		// System.out.println("ViewerSecurityManager.isUserSystemAdminForViewer(): Test user authZ-ised with account = " + theAccount);
		// First test that the user is authorised to access the specified Viewer
		boolean canAccessViewer = isUserAuthorisedForViewer(theAccount, "", theViewerName);
		
		// DEBUG
		// System.out.println("ViewerSecurityManager.isUserSystemAdminForViewer(): Viewer = " + theViewerName);
				
		if(canAccessViewer)
		{
			// Check that they have system admin role
			User aUser = parseUserData(theAccount);
			
			// Get the user account
			String anAccountURI = aUser.getUri();
			
			// DEBUG
			// System.out.println("ViewerSecurityManager.isUserSystemAdminForViewer(): User can access viewer. User URI = " + anAccountURI);	
			
			// Connect to the Graph Database and check user AuthZ
			Driver aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
														 AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																	 	  itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
			Session aGraphDBSession = aGraphDBDriver.session();
			
			// DEBUG
			// System.out.println("ViewerSecurityManager.isUserSystemAdminForViewer(): Test user authZ-ised with account = " + theAccount);
			
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
				// System.out.println("Found user has permission for import. User URI: " + anAccountURI);
				// We only need one valid record for success
			}
			
			// DEBUG
			// System.out.println("ViewerSecurityManager.isUserSystemAdminForViewer(): Tested permission, cleaning up...");
						

			// Release the connection to the Graph Database
			aGraphDBSession.close();
			aGraphDBDriver.close();
			
			// END OF GRAPH DB Implementation
		}
		return isSysAdmin;
	}
	
	/**
	 * Get the user information from the user's session
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels
	 */
	protected String getAccountFromSession(HttpServletRequest theRequest)
	{
		// Look for the user Account in the user session
		String anAccount = null;
		
		anAccount = (String)theRequest.getSession().getAttribute(USER_SESSION_VAR);
		
		// If not found, check for SSO Cookie
		if(anAccount == null)
		{
			EipSSOCookie aCookie = new EipSSOCookie(itsServletContext);
			String anAccountID = aCookie.getAccountID(theRequest);
			if(anAccountID != null)
			{
				anAccount = getAccountFromToken(theRequest, anAccountID);
				setUserSession(theRequest, anAccount);
			}
		}
		
		return anAccount;
	}
	
	/**
	 * Find the user account using the specified user account ID token
	 * @param theToken the ID of the Account
	 * @return the XML representation of the User Account
	 */
	protected String getAccountFromToken(HttpServletRequest theRequest, String theToken)
	{
		String anAccount = null;
		String aUserId = theToken; //TODO review, access token is currently the user id
		String aTenantId = null;
		Driver aGraphDBDriver = null;
		Session aGraphDBSession = null;
		try
		{
		    // Open a connection to the GraphDB		    
			aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
														 AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																	 	  itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
			aGraphDBSession = aGraphDBDriver.session();
			aTenantId = getTenantIdForGraphUser(aUserId, aGraphDBSession);
		}
		catch(Exception anEx)
		{
			System.err.println("SecureViewer: Error siging in user with token");
			System.err.println("Message: " + anEx.getLocalizedMessage());
			anEx.printStackTrace();
		}
		finally
		{
			// Close the connections to the database
			if(aGraphDBSession != null)
			{
				aGraphDBSession.close();
			}
			if(aGraphDBDriver != null)
			{
				aGraphDBDriver.close();
			}
		}
		UserProfile aUserProfile = getUserProfile(theRequest, aTenantId, aUserId);
		anAccount = getAccountFromUserManager(aUserId, aUserProfile);
		return anAccount;
	}

	/**
	 * Get the user information from the user management platform
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels
	 */
	protected String getAccountFromUserManager(String theUserId, UserProfile theUserProfile)
	{		
		// Get the account from the Identity Provder
		//Account anADAccount = null;
		String anAccountXML = null;		
		Driver aGraphDBDriver = null;
		Session aGraphDBSession = null;
		
		try
		{
			// Connect to the Graph Database and check user AuthZ
			aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
												  AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																   itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
			aGraphDBSession = aGraphDBDriver.session();

			// Process the user account data
			UserDataManager aUserData = new UserDataManager(aGraphDBSession, theUserId, theUserProfile);
			anAccountXML = aUserData.getUserXML();
			//System.out.println(anAccountXML);
		}
		catch(Exception anEx)
		{
			System.err.println("SecureViewer: Error authN user");
			System.err.println("Message: " + anEx.getLocalizedMessage());
			anEx.printStackTrace();
		}
		finally
		{
			// Close the connections to the database
			if(aGraphDBSession != null)
			{
				aGraphDBSession.close();
			}
			if(aGraphDBDriver != null)
			{
				aGraphDBDriver.close();
			}
		}
		
		return anAccountXML;
	}

	/**
	 * Get the user information from the user management platform
	 * @return an XML document representing the user's custom data, including
	 * all their clearance levels
	 */
	private String getAccountFromUserManager(String theUserId)
	{		
		// Get the account from the Identity Provder
		//Account anADAccount = null;
		String anAccountXML = null;		
		Driver aGraphDBDriver = null;
		Session aGraphDBSession = null;
		
		try
		{
			// Connect to the Graph Database and check user AuthZ
			aGraphDBDriver = GraphDatabase.driver(itsAuthZProperties.getProperty(GRAPH_DB_URI_PROPERTY), 
												  AuthTokens.basic(itsAuthZProperties.getProperty(GRAPH_DB_USER_PROPERTY), 
																   itsAuthZProperties.getProperty(GRAPH_DB_PWD_PROPERTY)));
			aGraphDBSession = aGraphDBDriver.session();

			// Process the user account data
			// DEBUG
			//System.out.println("ViewerSecurityManager.getAccountFromUserManager(): Getting User Data for user ID = " + theUserId);			
			UserDataManager aUserData = new UserDataManager(aGraphDBSession, theUserId);
			// DEBUG
			//System.out.println("ViewerSecurityManager.getAccountFromUserManager(): UserData XML = " + aUserData.getUserXML());			
						
			anAccountXML = aUserData.getUserXML();
			//System.out.println(anAccountXML);
		}
		catch(Exception anEx)
		{
			System.err.println("SecureViewer: Error authN user");
			System.err.println("Message: " + anEx.getLocalizedMessage());
			anEx.printStackTrace();
		}
		finally
		{
			// Close the connections to the database
			if(aGraphDBSession != null)
			{
				aGraphDBSession.close();
			}
			if(aGraphDBDriver != null)
			{
				aGraphDBDriver.close();
			}
		}
		
		return anAccountXML;
	}

	/**
	 * Add the returned user account details to the user's session
	 * @param theAccountDetails
	 */
	protected void setUserSession(HttpServletRequest theRequest, String theAccountDetails)
	{
		HttpSession aSession = theRequest.getSession(true);
		aSession.setAttribute(USER_SESSION_VAR, theAccountDetails);
	}
	
	/**
	 * Remove the user account details from the user's session, e.g. for logout or unauthorised access to viewer as a whole
	 * @param theRequest
	 */
	public void removeUserSession(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		HttpSession aSession = theRequest.getSession(false);
		if(aSession != null)
		{
			try
			{
				// Remove the user session
				aSession.removeAttribute(USER_SESSION_VAR);
				
				// Remove any single sign on tokens
				String aDomain = theRequest.getServerName();
				
				// Trace the domain of the SSO Cookie
				//System.out.println("ViewerSecurityManager.removeUserSession Domain = " + aDomain);
				
				EipSSOCookie aCookie = new EipSSOCookie(itsServletContext);
				aCookie.removeAccountID(theRequest, theResponse, aDomain);
			}		
			catch(IllegalStateException anIllegalState)
			{
				// Report issues with removing session and cookie
				System.err.println("ViewerSecurityManager: error removing user session: " + anIllegalState.toString());			
			}
	
			// Invalidate the User Session to ensure all resources are released
			try
			{
				aSession.invalidate();
			}
			catch(IllegalStateException anIllegalState)
			{
				// Report issues with removing session and cookie
				System.err.println("ViewerSecurityManager: error invalidating user session: " + anIllegalState.toString());						
			}
		}
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
			aUserInfo = (User)anUnmarshaller.unmarshal(IOUtils.toInputStream(theUserXML));	
			
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
		
		return aUserInfo;
	}
	
	/**
	 * Compare the specified viewer name with the URL custom data from a Group. If 
	 * they match, then this is the Group for the viewer
	 * @param theViewerName the name of the current viewer application, with its full URL
	 * @param theGroupURL the full URL for a Viewer Group
	 * @return true if theViewerName ends with the value of theGroupURL
	 */
	protected boolean isGroupForViewer(String theViewerName, String theGroupURL)
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
		
		//System.out.println("Requested Viewer URL is: " + aViewerURL);
		
		String aGroupURL = theGroupURL;
		// If the Group URL starts with https://... trim that off, as per aViewerURL
		int aGroupURLStart = theGroupURL.indexOf(URL_COMPARISON_START_STRING);		
		if(aGroupURLStart >= 0)
		{
			aGroupURL = theGroupURL.substring(aGroupURLStart);		
		}
		
		//System.out.println("Requested Group URL is: " + aGroupURL);
		
		//if(aViewerURL.equalsIgnoreCase(aGroupURL))
		String aLowerCaseViewerURL = aViewerURL.toLowerCase();
		if(aLowerCaseViewerURL.endsWith(aGroupURL.toLowerCase()))
		{
			isGroup = true;
		}
		//System.out.println("ViewerSecurityManager.isGroupForViewer, user is authZ to see Viewer is:" + isGroup);
		
		return isGroup;
	}
	
//	/**
//	 * Check whether the specified Tenant Directory is a mirror of an AD synchronised directory
//	 * @param theTenantDir the Tenant Directory
//	 * @param theUserName the username, which could be their email address but not necessarily
//	 * @return Stormpath Account object for the user if this is a mirror, null if not
//	 */
//	protected Account isAdTenantUser(Directory theTenantDir, String theUserName) 
//	{
//		AccountCriteria accountCriteria = Accounts.where(Accounts.username().eqIgnoreCase(theUserName)).withCustomData().withDirectory().offsetBy(0).limitTo(1);		
//		AccountList accounts = theTenantDir.getAccounts(accountCriteria);
//		
//		for (Account result : accounts) 
//		{
//			if(result != null)
//			{				
//				CustomData customData = result.getCustomData();
//				if (customData != null) 
//				{
//					Boolean isAdTenantUser = (Boolean) customData.get(ACTIVE_DIR_TENANT_FLAG);
//					if (isAdTenantUser != null && isAdTenantUser) 
//					{
//						return result;
//					}
//				}
//			}
//		}
//		
//		// Test for AD user using their email address as username, to close any back-doors.
//		AccountCriteria accountCriteriaByEmail = Accounts.where(Accounts.email().eqIgnoreCase(theUserName)).withCustomData().withDirectory().offsetBy(0).limitTo(1);
//		AccountList emailAccounts = theTenantDir.getAccounts(accountCriteriaByEmail);
//		
//		for (Account result : emailAccounts) 
//		{
//			if(result != null)
//			{				
//				CustomData customData = result.getCustomData();
//				if (customData != null) 
//				{
//					Boolean isAdTenantUser = (Boolean) customData.get(ACTIVE_DIR_TENANT_FLAG);
//					if (isAdTenantUser != null && isAdTenantUser) 
//					{				
//						return result;
//					}
//				}
//			}
//		}
//		
//		return null;
//	}
	
	/**
	 * Get the ID of the specified tenant in the Graph DB 
	 * @param theTenantName the name of the tenant
	 * @param theGraphDBSession the session on the Graph DB
	 * @return the tenant ID in the graph DB
	 */
	protected String getGraphTenantId(String theTenantName, Session theGraphDBSession)
	{
		String aTenantID = null;
		// This is a Cypher query to find the tenant uuid in the graph.
		// Query the GraphDB, using theGraphDBSession
		StatementResult aResult = theGraphDBSession.run("MATCH (p:Platform)-[:HAS_TENANT]->(t:Tenant{status:'ACTIVE'}) WHERE t.name={tenantName} RETURN t.uuid as graphTenantId", 
													  	parameters("tenantName", theTenantName));
		
		// Read the result set to find the tenant ID in the Graph	 
		if (aResult.hasNext()) 
		{
			Record aRecord = aResult.next();
			aTenantID = aRecord.get("graphTenantId").asString();
			
			// DEbug test code
			//System.out.println("Found tenant ID: " + aTenantID);
		}
	
		return aTenantID;
	}
		
	/**
	 * Find the user ID from the Graph DB for the corresponding Idp Account Id
	 * @param theGraphTenantId the ID of the tenant in the graph
	 * @param theIdpAccountId the IdP Account ID
	 * @param theGraphDBSession the session open on the Graph DB
	 * @return the ID of the user account in the Graph DB
	 */
	protected String getGraphUserId(String theGraphTenantId, String theIdpAccountId, Session theGraphDBSession)
	{
		//This is a Cypher query to find the user uuid in the graph.
		String aUserID = null;
		StatementResult aResult = theGraphDBSession.run("MATCH (p:Platform)-[:HAS_ACCOUNT]->(a:Account)-[:HAS_USER]->(u:User)<-[:HAS_USER]-(t:Tenant) WHERE a.idpUuid={idpAccountUuid} AND t.uuid={tenantUuid} RETURN u.uuid as graphUserId",
														parameters("idpAccountUuid", theIdpAccountId, "tenantUuid", theGraphTenantId));
		
		// Read the result set to find the Graph User Id in the Graph
		if(aResult.hasNext())
		{
			Record aRecord = aResult.next();
			aUserID = aRecord.get("graphUserId").asString();
			
			// Debug test code
			//System.out.println("Found user ID: " + aUserID);
		}
		
		return aUserID;
	}
	
	private String getTenantIdForGraphUser(String theGraphUserId, Session theGraphDBSession)
	{
		//This is a Cypher query to find the user uuid in the graph.
		String aTenantId = null;
		StatementResult aResult = theGraphDBSession.run("MATCH (u:User)<-[:HAS_USER]-(t:Tenant) WHERE u.uuid={userUuid} RETURN t.uuid as tenantId",
														parameters("userUuid", theGraphUserId));
		
		// Read the result set to find the Graph User Id in the Graph
		if(aResult.hasNext())
		{
			Record aRecord = aResult.next();
			aTenantId = aRecord.get("tenantId").asString();
		}
		
		return aTenantId;
	}

	private UserProfile getUserProfile(HttpServletRequest theRequest, String tenantId, String userId) {
		CloseableHttpClient client = null;
		try {
			String apiKey = getPropsAuthnApiKey();
			String baseUrl = getPropsAuthnServerBaseUrl();			
			String userProfileUrl = baseUrl+getPropsAuthnServerUserProfileUrl();
			userProfileUrl = addPathParameterToUrl(userProfileUrl, "{tenantId}", tenantId);
			userProfileUrl = addPathParameterToUrl(userProfileUrl, "{userId}", userId);
			validateUrl(userProfileUrl);
			
			
			//trace
			//System.out.println(">>>>> getUserProfile from Login App URL: "+userProfileUrl);
			
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
			//System.out.println(">>>>> getUserProfile response: "+responseStr);

			
			return new ObjectMapper().readValue(responseStr, UserProfile.class);
		} catch (IOException e) {
			System.err.println(e.getMessage());
			e.printStackTrace();
		} catch (URISyntaxException e) {
			System.err.println(e.getMessage());
			e.printStackTrace();
		} finally {
			if (client != null) {
				try {
					client.close();
				} catch (IOException e) {
					System.err.println(e.getMessage());
					e.printStackTrace();
				}
			}
		}
		
		return null;
	}
	
}
