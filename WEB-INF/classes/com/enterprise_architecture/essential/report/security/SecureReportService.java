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
 * 27.01.2015	JWC	First coding 
 * 17.04.2015	JWC Completed testing
 * 24.03.2016	JWC Instrumented for SSL debugging
 * 08.02.2017	JWC Removed trace code
 * 28.06.2019	JWC Added use of log4J
 * 27.03.2020	JWC Tweaked to clear cache (report API) on publish of multipart form
 * 15.03.2021	JWC Added new API-based caching functionality
 */
package com.enterprise_architecture.essential.report.security;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.essential.report.EasReportService;
import com.enterprise_architecture.essential.report.ViewerCacheManager;
import com.enterprise_architecture.essential.report.api.ApiErrorMessage;
import com.enterprise_architecture.essential.report.api.ApiResponse;
import com.enterprise_architecture.essential.report.api.ApiUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

/**
 * Secure implementation of the EasReportService, that receives published repository snapshots
 * 
 * @author Jonathan Carter
 * 
 *
 */
public class SecureReportService extends EasReportService 
{
	/**
	 * Serial version ID
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(SecureReportService.class);

	/**
	 * HTTP Header parameter in which to write the bearer token
	 */
	private static final String AUTHORIZATION_HEADER = "Authorization";
	
	/**
	 * API Key HTTP Header Key
	 */
	private static final String API_KEY_HEADER = "x-api-key";
	
	/**
	 * Prefix for the authorization header value
	 */
	private static final String BEARER_PREFIX = "Bearer ";

	/**
	 * Error message used when user not authorised
	 */
	protected static final String NOT_AUTH_MESSAGE = "User not authorised to user Report Service";
	
	/**
	 * Error message used when user account cannot be found - i.e. not authenticated
	 */
	protected static final String NOT_AUTHENTICATED_MESSAGE = "User is not authenticated";

	/**
	 * Content type for posted form data
	 */
	protected final static String MULTIPART_FORM_CONTENT_TYPE = "multipart/form-data";

	/**
	 * Location of the Properties file
	 */
	private static final String CACHE_API_PROPERTIES_FILE = "WEB-INF/classes/cacheApi.properties";

	/**
	 * Name of the property that defines the Report API serivce API endpoint
	 */
	private static final String REPORT_API_SERVICE_URL = "eip.api.reportApi.target";

	/**
	 * Name of the property that defines the Report Reference serivce API endpoint
	 */
	private static final String REPORT_REFERENCE_API_SERVICE_URL = "eip.api.reportReferenceApi.target";

	private String itsReportApiUrl = "";
	private String itsReportReferenceUrl = "";

	private String itsCacheDirectory = "/platform/tmp/reportApiCache";
	private static final String REPORT_API_CACHE_LOCATION = "reportAPICacheLocation";

	/**
	 * Default constructor
	 */
	public SecureReportService() 
	{
		// No specific action to override base class
	}

	/**
	 * Do additional configuration - read the properties file to get the URL of the 
	 * caching APIs
	 */
	@Override
	public void init(ServletConfig theConfig) throws ServletException
	{
		super.init(theConfig);

		// Get the relative location of the local cache 
		itsCacheDirectory = getServletContext().getInitParameter(REPORT_API_CACHE_LOCATION);

		// Read the API Platform's URL prefix from the properties and save it in itsEssentialReferenceURLPrefix
		String aPropertiesFileName = CACHE_API_PROPERTIES_FILE;
		Properties aPropertyList = new Properties();
		try
		{
			aPropertyList.load(theConfig.getServletContext().getResourceAsStream(aPropertiesFileName));
		}
		catch(IOException anIOEx)
		{
			itsLog.error("Could not load application properties file: {}", aPropertiesFileName);
			itsLog.error(anIOEx.toString());
		}
        
        // Loaded properties, now read them
        // Find the target URL property for the Report API
		String aReportAPIHostname = (String)aPropertyList.getProperty(REPORT_API_SERVICE_URL);
		if(aReportAPIHostname == null || aReportAPIHostname.length() == 0)
		{
			// The property is not defined, so exit with an error
			itsLog.error("No target Report API Gateway defined. Make sure to set the {} property in the property file, cachceApi.properties", REPORT_API_SERVICE_URL);			
        }
        else
        {
            // We have a target hostnaame for the API Gateway, so build the Essential Batch Refresh API prefix
            if(aReportAPIHostname.endsWith("/"))
            {
                aReportAPIHostname = aReportAPIHostname.substring(0, aReportAPIHostname.length() - 1);
            }            
            itsReportApiUrl = aReportAPIHostname;
        }
		// Find the target URL property for the Report Reference API
		String aReportReferenceHostname = (String)aPropertyList.getProperty(REPORT_REFERENCE_API_SERVICE_URL);
		if(aReportReferenceHostname == null || aReportReferenceHostname.length() == 0)
		{
			// The property is not defined, so exit with an error
			itsLog.error("No target Report API Gateway defined. Make sure to set the {} property in the property file, cachceApi.properties", REPORT_REFERENCE_API_SERVICE_URL);			
        }
        else
        {
            // We have a target hostnaame for the API Gateway, so build the Essential Batch Refresh API prefix
            if(aReportReferenceHostname.endsWith("/"))
            {
                aReportReferenceHostname = aReportReferenceHostname.substring(0, aReportReferenceHostname.length() - 1);
            }            
            itsReportReferenceUrl = aReportReferenceHostname;
        }
	}

	/**
	 * Intercept the Post received from publishing clients and validate that the specified user
	 * is allowed to publish to Viewer. Looks for token in the request
	 */
	@Override
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse)
			  throws ServletException, IOException
	{	
		itsLog.debug("SecureReportService: Doing secure ReportService. Path: {}", getViewerId(theRequest));
		
		String aRepositoryURI = theRequest.getParameter(ViewerSecurityManager.REPOSITORY_ID_URL);
		String aBearerToken = theRequest.getParameter(ViewerSecurityManager.USER_ACCOUNT_URL);
		
		// Check Content Type, if multi-part form, then process parameters differently.
		String aContentType = theRequest.getContentType();
		itsLog.debug("SecureReportService: Content Type: " + aContentType);
		
		if(aContentType == null)
		{
			// Then this is a bad request - redirect the request to the Essential Viewer BAD URL page
			theResponse.sendRedirect(BAD_REQUEST_REDIRECT_URL);
			return;
		}
		
		String aReceivedXML = "";
		FileItem anXMLFile = null;
		
		// Allow multi-part form or application form encoded
		if(aContentType.contains(MULTIPART_FORM_CONTENT_TYPE))
		{			
			DiskFileItemFactory aDiskFactory = new DiskFileItemFactory();
			// Use the upload directory as the temporary file store for large images
			String aRepositoryPath = getServletContext().getRealPath(itsUploadTempFolder);
			aDiskFactory.setRepository(new File(aRepositoryPath));
			
			// Set in-memory threshold to 100KB
			aDiskFactory.setSizeThreshold(MEMORY_THRESHOLD_SIZE);
			
			// Set up the uploader
			ServletFileUpload anUpload = new ServletFileUpload(aDiskFactory);
			
			// Set the max size just under the Tomcat default limit of 2MB
			anUpload.setSizeMax(UPLOAD_LIMIT_SIZE);
			
			// Process the upload to get the security parameters
			synchronized(theRequest)
			{
				try
				{
					// Test the content type and handle accordingly
					//@SuppressWarnings("unchecked")
					List<FileItem> aRequestContentList = anUpload.parseRequest(theRequest);
					Iterator<FileItem> aContentListIt = aRequestContentList.iterator();
					while(aContentListIt.hasNext())
					{
						FileItem anItem = aContentListIt.next();
						String aParamName = anItem.getFieldName();
						if(aParamName.equals(ViewerSecurityManager.USER_ACCOUNT_URL))
						{
							aBearerToken = anItem.getString();
							anItem.delete();
						}
						else if(aParamName.equals(ViewerSecurityManager.REPOSITORY_ID_URL))
						{
							aRepositoryURI = anItem.getString();
							anItem.delete();
						}
						else if(aParamName.equals(XML_REQUEST_PARAM))
						{
							// Hold onto the XML content until we have performed the authN and authZ
							anXMLFile = anItem;							
						}
					}
				}
				catch(FileUploadException aFileUploadEx)
				{
					itsLog.error("Exception encountered while parsing request for security parameters. {}", aFileUploadEx);
				}				
			}	 
		}
		else if(aContentType.contains(COMPRESSED_CONTENT_TYPE))
		{
			// Unsupported as we can't read the auth params
			itsLog.error("Attempt to send invalid repository snapshot. Unsupported content type.");
			theResponse.setStatus(ERROR_STATUS);
			theResponse.sendRedirect(UPLOAD_ERROR_URL);
		}
		else
		{
			// Compatibility mode - non compressed, POST parameters			
			// Read the message payload - the XML
			// Do this synchronized to ensure process completes atomically.
			synchronized(theRequest) 
			{
				aReceivedXML = theRequest.getParameter(XML_REQUEST_PARAM);
			}
		}
		
		// Got all the parameters of the request, now do authentication
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String anAccount = aSecurityMgr.authenticateUserByToken(theRequest, aBearerToken);
		String aUserId = (String) theRequest.getSession(false).getAttribute(ViewerSecurityManager.USER_ID);
		
		// Authenticated, so do authorisation
		if(anAccount != null)
		{
			itsLog.debug("User Authenticated by Token. Account = {}", anAccount);
			
			if(aSecurityMgr.isUserAuthorisedForPublish(aUserId, aRepositoryURI))
			{
				itsLog.debug("User authorised for repository: {}", aRepositoryURI);
				
				// Authorised 
				boolean isSuccess = false;

				// Clear the pre-cache
				ViewerCacheManager aCacheManager = getCacheManager();
				boolean isCacheClear = clearCache(aCacheManager, ViewerCacheManager.CLEAR_BEFORE_RECEIVE_REPOSITORY, theRequest);
				if(!isCacheClear)
				{
					itsLog.error("EasReportService: Failed to clear cache before repository receive.");
				}
								
				// Based on content type, save the repository XML
				if(aContentType.contains(MULTIPART_FORM_CONTENT_TYPE))
				{
					// Save the XML
					// Test content type
					String aFileContentType = anXMLFile.getContentType();
					
					// Report the content type to aid with trouble shooting due to browser variation
					itsLog.debug("Received File: Content Type = {}", aFileContentType);
					
					// Look for ZIP content type - handle less standard browsers
					if(aFileContentType.equals(ZIPFILE_CONTENT_TYPE) ||
							aFileContentType.contains(ALT_ZIP_CONTENT_TYPE) ||
							aFileContentType.contains(ASSUME_ZIP_CONTENT_TYPE))
					{
						// Handle a ZIP file
						ZipInputStream aZipInStream = new ZipInputStream(anXMLFile.getInputStream());
						
						// Stream the ZipInStream into a String.
						// Get the ZIP file XML content
						isSuccess = savePostedFile(aZipInStream);
						aZipInStream.close();
					}
					else if(aFileContentType.equals(XML_CONTENT_TYPE))
					{
						// Handle uncompressed XML
						isSuccess = savePostedFile(anXMLFile);						
					}
					else
					{
						isSuccess = false;
					}
					
					// If the repository snapshot has been received, clear any cached Views 
					if(isSuccess)
					{
						// Clear the post cache
						isSuccess = clearCache(aCacheManager, ViewerCacheManager.CLEAR_AFTER_RECEIVE_REPOSITORY, theRequest);
					}
					
					// Delete the uploaded XML
					anXMLFile.delete();										
				}
				else
				{
					// Save XML and clear the post-receive cache
					isSuccess = receiveModelSnapshot(aReceivedXML, aCacheManager, theRequest);
				}
				
				// *******
				// If successfully received the Model Snapshot, build the documents 
				// to be loaded into the Essential Reference Batch API				
				itsLog.debug("**** Requesting reset of the Report Reference Collections");

				// Find the specific Viewer that we are publishing to
				//String aViewerId = theRequest.getContextPath().replace("/", "");
				String aViewerId = getViewerId(theRequest);
				preCacheReportReferenceAPIs(aViewerId, aRepositoryURI, getBearerToken(theRequest), getAPIKey(theRequest));
				
				//boolean isProductionMode = true;
				//ReportReferenceEngine aReportReferenceEngine = new ReportReferenceEngine(getServletContext(), isProductionMode);
				//aReportReferenceEngine.resetNoSQLCache(theRequest, aRepositoryURI);
				//aReportReferenceEngine.closeResources();		
		
				// *******
				
				// Return success or fail message
				if(isSuccess)
				{
					theResponse.setStatus(SUCCESS_STATUS);
					theResponse.sendRedirect(UPLOAD_SUCCESS_URL);
				}
				else
				{
					itsLog.error("Essential Report Service: Error encountered while receiving repository snapshot.");
					theResponse.setStatus(ERROR_STATUS);
					theResponse.sendRedirect(UPLOAD_ERROR_URL);
				}				
			}
			else
			{
				itsLog.error("Essential Report Service: Error publishing 403 ACCESS DENIED, message: "+NOT_AUTH_MESSAGE);
				theResponse.sendError(HttpServletResponse.SC_FORBIDDEN, NOT_AUTH_MESSAGE);
			}
		}
		else
		{
			itsLog.error("Essential Report Service: Error publishing 401 UNAUTHORIZED, message: "+NOT_AUTHENTICATED_MESSAGE);
			theResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, NOT_AUTHENTICATED_MESSAGE);
		}
		
	}
	
	/**
	 * Send a request to the Report API service to pre-cache the APIs
	 */
	@Override
	protected void preCacheReportAPIs(String theViewerId)
	{
		// Add theViewerId to the tail of the URL
		String aRequestUrl = itsReportApiUrl + "/" + theViewerId;
		
		// Make the Http GET request
		HttpGet aGet = new HttpGet(aRequestUrl);
		ApiResponse aResponse = doHttpRequest(aGet, "", "", theViewerId);
		if(aResponse.getStatusCode() == HttpStatus.SC_OK)
		{
			itsLog.debug("Response from the Report API Service: {}", aResponse);
		}
		else
		{
			itsLog.error("Failed to set Report API Service cache. Error code: {}. Error Message: {}", aResponse.getStatusCode(), aResponse.getJsonResponse());
			itsLog.error("API Request: {}", aRequestUrl);
		}

		// Double-check that the cache directory has been removed, as expected
		resetCache();
	}

	/**
	 * Send a request to the Report Reference API to pre-cache content
	 * in the Essential Reference service
	 * 
	 * @param theViewerId
	 * @param theBearerToken
	 * @param theApiKey
	 */
	protected void preCacheReportReferenceAPIs(String theViewerId,
											   String theRepositoryId,
											   String theBearerToken,
											   String theApiKey)
	{
		// Add theViewerId to the tail of the URL
		String aRequestUrl = itsReportReferenceUrl + "/" + theViewerId + "/repositories/" + theRepositoryId;
		itsLog.debug("Making pre-cache request to the Report Reference API: {}", aRequestUrl);
		
		// Add theBearerToken and theApiKey to the request headers
		String anAuthZ = BEARER_PREFIX + theBearerToken;

		// Make the Http GET request
		HttpGet aGet = new HttpGet(aRequestUrl);
		ApiResponse aResponse = doHttpRequest(aGet, theApiKey, anAuthZ, theRepositoryId);
		if(aResponse.getStatusCode() == HttpStatus.SC_OK)
		{
			itsLog.debug("Response from the Report API Service: {}", aResponse);
		}
		else
		{
			itsLog.error("Failed to set Report API Service cache. Error code: {}. Error Message: {}", aResponse.getStatusCode(), aResponse.getJsonResponse());
			itsLog.error("API Request: {}", aRequestUrl);
		}
	}

	/**
     * Make an HTTP Request to the specified target
     * @param theHttpRequest
     * @param theApiKey
     * @param theAuthorisation
     * @param theViewerId
     * @return
     */
    private ApiResponse doHttpRequest(HttpRequestBase theHttpRequest, 
                                      String theApiKey, 
                                      String theAuthorisation,
                                      String theRepositoryId) 
	{
		ApiResponse anApiResponse;
		CloseableHttpClient anHttpclient = null;

		try 
		{
			anHttpclient = HttpClients.createDefault();
			theHttpRequest.addHeader(AUTHORIZATION_HEADER, theAuthorisation);
			theHttpRequest.addHeader(API_KEY_HEADER, theApiKey);
			
			CloseableHttpResponse anHttpResponse = anHttpclient.execute(theHttpRequest);
			try 
			{
				HttpEntity anEntity = anHttpResponse.getEntity();
				StatusLine aStatus = anHttpResponse.getStatusLine();
                
                // Accept SC_OK (for successful DELETEs) or SC_CREATED (for successful POSTs)
				if (aStatus.getStatusCode() == HttpStatus.SC_OK || aStatus.getStatusCode() == HttpStatus.SC_CREATED) 
				{
					String aResponseJson = EntityUtils.toString(anEntity);
					EntityUtils.consume(anEntity);
					anApiResponse = parseApiResponse(aResponseJson);
					itsLog.debug("Request successfully made to Essential Reference Batch API");
				} 
				else 
				{
					/*
					 * Error during call to API
					 */
					String aReason = aStatus.getReasonPhrase();
					int aStatusCode = aStatus.getStatusCode();
					// default response if no error response body
					anApiResponse = ApiUtils.buildJsonErrorResponse(aStatusCode, aReason);
					if (anEntity != null) 
					{
						// we've got an error response, so pass this back
						String aResult = EntityUtils.toString(anEntity);
                        if (aStatusCode == HttpStatus.SC_INTERNAL_SERVER_ERROR) 
                        {
							// sanitise the response - don't want to expose any script errors, etc
							anApiResponse = ApiUtils.buildJsonErrorResponse(aStatusCode, "Error executing the Essential Reference Batch API");
                        } 
                        else 
                        {
							// okay to return non-500 error messages, will contain info on access denied or unauthorised.
							anApiResponse = new ApiResponse(aStatusCode, aResult);
						}
						itsLog.error("Error encountered invoking Essential Batch Reference API, status code:{}, reason:{}, message:{}", aStatusCode, aReason, aResult);
					} 
					else 
					{
						itsLog.error("Error encountered invoking Essential Batch Reference API, no error message returned, status code:{}, reason:{}", aStatusCode, aReason);
					}
				}
			} 
			finally 
			{
				try 
				{
					anHttpResponse.close();
					anHttpclient.close();
				} catch(Exception e) 
				{
					// Log SEVERE that we failed to clear the settings
					itsLog.error("Error encountered closing the Status Response and HTTPClient: " + e.getMessage());
				}
			}
		} 
		catch(Exception e) 
		{
			// Log error message
			itsLog.error("Exception caught: error encountered posting DUP to EDM service: " + e.getMessage());
			anApiResponse = ApiUtils.buildJsonErrorResponse(HttpStatus.SC_INTERNAL_SERVER_ERROR, "Exception caught: error encountered running request on the specified repository\", \"repository\" : \"" + theRepositoryId + "\"");
		}
		finally
		{
			if(anHttpclient != null)
			{
				try
				{
					anHttpclient.close();
				}
				catch (Exception anEx)
				{
					itsLog.error("Error encountered closing the Status Response and HTTPClient: " + anEx.getMessage());
					anApiResponse = ApiUtils.buildJsonErrorResponse(HttpStatus.SC_INTERNAL_SERVER_ERROR, "Exception caught: error encountered running request on the specified repository\", \"repository\" : \"" + theRepositoryId + "\"");
				}
			}
		}
		return anApiResponse;
	}

	/**
	 * Get the bearer token from the request attributes
	 * @param theServletRequest
	 * @return the bearer token or null if no bearer token found
	 */
	private String getBearerToken(HttpServletRequest theServletRequest)
	{
		/**
		 * Note - the cookies in a ServletRequest cannot be updated so the bearer token is stored in a session attribute to allow 
		 * it to be refreshed in the ValidateOauthBearerToken filter.  
		 */
		return (String) theServletRequest.getSession(false).getAttribute(ViewerSecurityManager.SESSION_ATTR_BEARER_TOKEN);
	}
	
	/**
	 * Get the tenant's API key from the request attributes. The Viewer should have already cached this
	 * @param theServletRequest
	 * @return the API for the user's tenant or null if no API key is found
	 */
	private String getAPIKey(HttpServletRequest theServletRequest)
	{
		return (String)theServletRequest.getSession(false).getAttribute(ViewerSecurityManager.USER_TENANT_API_KEY);
	}

	/** 
	 * Parse the JSON to get the correct HTTP Status code from the response from the execution of the script
	 * If no statusCode JSON attribute is in the start of the response message, return 200.
	 * @param theResponseJson
	 * @return anApiResponse
	 */
	private ApiResponse parseApiResponse(String theResponseJson)
	{
		ObjectMapper aMapper = new ObjectMapper();
		try 
        {
			ApiErrorMessage anApiErrorMessage = (ApiErrorMessage) aMapper.readValue(theResponseJson, ApiErrorMessage.class);
			return new ApiResponse(anApiErrorMessage.getStatusCode(), theResponseJson);
		} 
        catch (IOException e) 
		{
			// couldn't parse the JSON, use fallback method below

			itsLog.debug("Parsing response NOT ApiErrorMessage...");

			// CANNOT ASSUME that statusCode is at the start of theResponseJson string!!
			// ADD SOME DEBUG LOGGING so that we can see what the code is being set to etc.
			int aStatusCode = 200;
			ApiResponse aResponse;
			try
			{
				JsonObject aResponseParser = new Gson().fromJson(theResponseJson, JsonObject.class);
				aStatusCode = aResponseParser.get("statusCode").getAsInt();
				itsLog.debug("Response code set to: {}", aStatusCode);
			}
			catch(JsonSyntaxException aJsonSyntaxEx)
			{
				// We can't parse the Json - default response to 200
				itsLog.debug("JsonSyntaxException when parsing theResponseJson. Defaulting to 200");
				aStatusCode = 200;
			}
			catch(Exception aStatusCodeEx)
			{
				// There's a problem with the statusCode attribute or it is missing - default to 200
				itsLog.debug("Exception in getting the statusCode from valid JSON from theResponseJson. Defaulting to 200");
				aStatusCode = 200;
			}
			
			// We have the correct Status Code from theResponseJson - build the response
			aResponse = new ApiResponse(aStatusCode, theResponseJson);
			return aResponse;
		}
	}

	/**
	 * Clear the cache directory and all cached content
	 * 
	 */
	private void resetCache()
	{
		itsLog.debug("Clearing the cache");
		String aRealPathToCache = getServletContext().getRealPath(itsCacheDirectory);
		try
		{
			File aCacheDirectory = new File(aRealPathToCache);
			FileUtils.deleteDirectory(aCacheDirectory);
		}
		catch(Exception anEx)
		{
			itsLog.error("Exception encountered when clearing Report API cache: {}", anEx.toString());
		}
		itsLog.debug("Cache cleared");
	}
	
}
