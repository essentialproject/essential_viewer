/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 24.06.2020	JWC	First implementation of Report Reference
 *  
 */
package com.enterprise_architecture.essential.report.security;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.om.TreeInfo;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.essential.report.EssentialViewerEngine;
import com.enterprise_architecture.essential.report.ViewTransformErrorListener;
import com.enterprise_architecture.essential.report.api.ApiErrorMessage;
import com.enterprise_architecture.essential.report.api.ApiResponse;
import com.enterprise_architecture.essential.report.api.ApiUtils;
import com.enterprise_architecture.essential.report.precache.PreCacheReferenceList;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Class to manage the generation of Report Reference instances - or "Data Views" in Essential Reference API
 * Only produces JSON documents
 * @author Jonathan W. Carter
 *
 */
public class ReportReferenceEngine 
{
	protected ServletContext itsServletContext = null;
	
	protected static final String XML_FILENAME = "reportXML.xml";
	
	private static final Logger itsLog = LoggerFactory.getLogger(ReportReferenceEngine.class);
	
	private static final int MAX_THREAD_POOL_SIZE = 2;	
	
	private static final String PRE_CACHE_QUERY_XSL_FILENAME = "common/api/core_precache_reportReference.xsl";
    
    private static final String VIEWER_RESET_URI = "/collections/viewer-collections";

    private static final String VIEWER_COLLECTION_PREFIX = "viewer.";

    /**
	 * HTTP Header parameter in which to write the bearer token
	 */
	private static final String AUTHORIZATION_HEADER = "Authorization";
	
	/**
	 * Prefix for the authorization header value
	 */
	private static final String BEARER_PREFIX = "Bearer ";
	
	/**
	 * API Key HTTP Header Key
	 */
	private static final String API_KEY_HEADER = "x-api-key";

    private static final String EIP_PROPERTIES_FILE = "WEB-INF/classes/passthru.properties";

    private static final String ESSENTIAL_REFERENCE_BATCH_API_URL_PROPERTY = "eip.api.passthru.target";

    private static final String ESSENTIAL_REFERENCE_BATCH_API_PREFIX = "/essential-reference-batch/v1/stores/";

    private static final String VIEWER_POST_URL = "/collections/";

    private static final String ESSENTIAL_REF_API_PARAMETER_NAME = "json-file";
	
    private String itsEssentialReferenceURLPrefix = "";

    private ExecutorService itsExecutor = null;
    
    /**
	 * Default to production mode, which sanitises error responses from APIs
	 */
	private boolean itsProductionMode = true;
	
	/**
	 * Default Constructor
	 */
	public ReportReferenceEngine(ServletContext theContext, boolean theIsProductionMode)
	{
		// Set the Servlet context variables
        itsServletContext = theContext;
        
        // Set the production mode flag
        itsProductionMode = theIsProductionMode;
		
		// Read the context parameter and decide whether to set the page history tracking on or off
        itsLog.debug("ReportReferenceEngine constructor");
        
        // Read the API Platform's URL prefix from the properties and save it in itsEssentialReferenceURLPrefix
		String aPropertiesFileName = EIP_PROPERTIES_FILE;
		Properties aPropertyList = new Properties();
		try
		{
			aPropertyList.load(theContext.getResourceAsStream(aPropertiesFileName));
		}
		catch(IOException anIOEx)
		{
			itsLog.error("Could not load application properties file: {}", aPropertiesFileName);
			itsLog.error(anIOEx.toString());
		}
        
        // Loaded properties, now read them
        // Find the target URL property
		String anAPIHostname = (String)aPropertyList.getProperty(ESSENTIAL_REFERENCE_BATCH_API_URL_PROPERTY);
		if(anAPIHostname == null || anAPIHostname.length() == 0)
		{
			// The property is not defined, so exit with an error
			itsLog.error("No target API Gateway defined. Make sure to set the {} property in the property file, eip.properties", ESSENTIAL_REFERENCE_BATCH_API_URL_PROPERTY);			
        }
        else
        {
            // We have a target hostnaame for the API Gateway, so build the Essential Batch Refresh API prefix
            if(anAPIHostname.endsWith("/"))
            {
                anAPIHostname = anAPIHostname.substring(0, anAPIHostname.length() - 1);
            }            
            itsEssentialReferenceURLPrefix = anAPIHostname + ESSENTIAL_REFERENCE_BATCH_API_PREFIX;
        }
		
		if(itsExecutor == null)
		{
			itsExecutor = Executors.newFixedThreadPool(MAX_THREAD_POOL_SIZE);
		}
	}
	
	/**
	 * Clean up any resources when the parent servlet is destroyed
	 * or this object is finalized
	 */
	public void closeResources()
	{
		if(itsExecutor != null)
		{
			// When all have completed, shutdown the executor
			itsLog.debug("Closing resources. Shutting down the ExecutorService...");
			itsExecutor.shutdown();
		}
	}
	
	/**
	 * Reset the NoSQL Cache, e.g. when a new repository snapshot has been received
	 * Clear the current cached JSON then re-create it
	 */
    public void resetNoSQLCache(HttpServletRequest theRequest, String theRepositoryID)
	{
		itsLog.debug(">>>> Clearing the NoSQL cache");
        // Connect directly to the Essential Reference API
        itsLog.debug("Building request headers for call to Essential Reference API.");
        String aBearerToken = getBearerToken(theRequest);
        String aBearerHeader = "";
        
        // Build the bearer token from what we get back from getBearerToken()
        if (aBearerToken != null) 
        {
	    	aBearerHeader = BEARER_PREFIX + aBearerToken;
        } 
        else 
        {
            itsLog.error("No bearer token stored in session, not added to headers for request. Aborting...");
            return;
	    }
	    
	    // Add the API Key for the tenant
	    itsLog.debug("Adding user's tenant API key to header");
	    String anAPIKey = getAPIKey(theRequest);
	    if(anAPIKey == null)	     
        {
            itsLog.error("No API Key stored in session, not added to headers for request. Aborting...");
            return;
	    }

        itsLog.debug("Clearing NoSQL Cache with Bearer token: {}, API key: {}", aBearerHeader, anAPIKey);
        // Clear the cache via the collections/viewer-collections request
        clearNoSQLCache(theRepositoryID, aBearerHeader, anAPIKey);
		itsLog.debug("Cache cleared");
		
		// Now pre-cache specific elements		
        preCacheReportReferenceDocs(theRepositoryID, aBearerHeader, anAPIKey);
        itsLog.debug("Finished resetNoSQLCache(). Executor threads are still running to build the new NoSQL content");
	}
    
    /**
     * Clear the NoSQL "Cache" of JSON for use by Viewer. Delete all collections in the specified Store (database)
     * that have the special Viewer prefix, {@link #VIEWER_RESET_URI}
     * @param theRepositoryId 
     * @param theBearerToken
     * @param theAPIKey
     */
    protected void clearNoSQLCache(String theRepositoryId, String theBearerToken, String theAPIKey)
    {
        // Make a DELETE request to the Essential Reference Batch API to clear ALL the cached Viewer JSON
        // for the specified repository

        // Build the request URL for the Essential Reference Batch API
        // Reference the parsed properties that contain the prefix of the service request, e.g.
        // http://<hostname>:8085
        if(!itsEssentialReferenceURLPrefix.endsWith("/"))
        {
            // Add a trailing '/' if it's missing in the properties
            itsEssentialReferenceURLPrefix = itsEssentialReferenceURLPrefix + "/";
        }
        String anEssentialAPIURL = itsEssentialReferenceURLPrefix + theRepositoryId;
        itsLog.debug("Clearing the Viewer JSON cache in NoSQL using URL stub: {}", anEssentialAPIURL);
        ApiResponse anApiResponse = doDeleteHttpRequest(anEssentialAPIURL, theAPIKey, theBearerToken, theRepositoryId);
        if(anApiResponse.getStatusCode() == HttpServletResponse.SC_OK)
        {
            itsLog.debug("Cleared Viewer JSON cache in NoSQL Store: {}", theRepositoryId);
        }
        else
        {
            itsLog.error("Failed to clear Viewer JSON cache in NoSQL Store: {}", theRepositoryId);
            itsLog.error("Check logs for more details");
        }
    }

	/**
	 * Get the list of Report References that have been identified for pre-caching and iterate through
	 * them, generating each. Reads the is_data_set_api_precached slot on each Data_Set_API instance and
	 * only pre-caches those with this slot set to true.
	 * 
	 */
	protected void preCacheReportReferenceDocs(String theRepositoryId, String theBearerToken, String theAPIKey)
	{		
		// Read the current XML snapshot - we'll read this to get the list of Report References to pre-cache		
		PreCacheReferenceList aPreCacheList = getPreCacheList(XML_FILENAME, PRE_CACHE_QUERY_XSL_FILENAME);
				
		// Iterate through the pre-cache list	
		Iterator<String> aPreCacheIt = aPreCacheList.getPreCacheReferences().iterator();
		while(aPreCacheIt.hasNext())
		{		
			// Request each Report Reference View
			String aReportReference = aPreCacheIt.next();
			ReportReferenceRequestor anApiRequestor = new ReportReferenceRequestor();
			anApiRequestor.setItsXML(XML_FILENAME);
            anApiRequestor.setItsXSL(aReportReference);
            anApiRequestor.setItsRepositoryId(theRepositoryId);
            anApiRequestor.setItsBearerToken(theBearerToken);
            anApiRequestor.setItsAPIKey(theAPIKey);
			itsLog.debug("Created ReportReferenceRequestor for Report Reference: {}", aReportReference);
			itsLog.debug("Submitting...");
			itsExecutor.submit(anApiRequestor);						
		}		
	}
	
	/**
	 * Write the ApiErrorMessage to a string that can be returned to a client
	 * @param theApiErrorMessage
	 * @return String-ified rendering of the ApiErrorMessage
	 */
	/*protected String writeErrorJson(ApiErrorMessage theApiErrorMessage)
	{
		ObjectMapper aMapper = new ObjectMapper();
		String aJsonMsgString = "";
		try 
		{
			aJsonMsgString = aMapper.writeValueAsString(theApiErrorMessage);
		} 
		catch (JsonProcessingException jpe) 
		{
			itsLog.error("Error creating JSON error message, reason: "+jpe.getMessage(), jpe);
			// do nothing, just log the error
		}
		return aJsonMsgString;
	}
	*/
	/**
	 * Save theNewJson in the NoSQL cache
	 * @param theCachedName the unique name of the Report Reference collection
	 * @param theNewJson the result content of the Report Reference collection
	 */
    protected void writeToCache(String theCachedName, 
                                String theNewJson, 
                                String theRepositoryId, 
                                String theBearerToken, 
                                String theAPIKey)
	{
		itsLog.debug("Writing to Essential Reference API: {}. Size: {}. Repository ID: {}", theCachedName, theNewJson.length(), theRepositoryId);
        
        // Make a request to the Essential Reference Batch API to load the specified collection (theCachedName)
        if(!itsEssentialReferenceURLPrefix.endsWith("/"))
        {
            // Add a trailing '/' if it's missing in the properties
            itsEssentialReferenceURLPrefix = itsEssentialReferenceURLPrefix + "/";
        }
        String anEssentialAPIURL = itsEssentialReferenceURLPrefix + theRepositoryId;
        itsLog.debug("Loading Viewer JSON cache in NoSQL using URL stub: {}", anEssentialAPIURL);
        if(theNewJson == null || theNewJson.length() == 0)
        {
            itsLog.error("Cannot make POST request with empty Payload");
        }
        // Make a POST request        
        String aCollectionName = VIEWER_COLLECTION_PREFIX + theCachedName;
        ApiResponse anApiResponse = doPostHttpRequest(anEssentialAPIURL, 
                                                      theAPIKey, 
                                                      theBearerToken, 
                                                      theRepositoryId, 
                                                      aCollectionName, 
                                                      theNewJson);
        if(anApiResponse.getStatusCode() == HttpServletResponse.SC_CREATED)
        {
            itsLog.debug("Added collection, {}, to Viewer JSON cache in NoSQL Store: {}", aCollectionName, theRepositoryId);
        }
        else
        {
            itsLog.error("Failed to clear Viewer JSON cache in NoSQL Store: {}", theRepositoryId);
            itsLog.error("Check logs for more details");
        }
        
    }

    /**
     * Make a DELETE HTTP request that will reset the Viewer's "cache" collections
     * @param theRequestURLStub
     * @param theApiKey
     * @param theBearerToken
     * @param theRepositoryId
     * @return
     */
    private ApiResponse doDeleteHttpRequest(String theRequestURLStub,
                                            String theApiKey,
                                            String theBearerToken,
                                            String theRepositoryId)
    { 
        // Compute the URL for the delete request,
        String aDeleteURL = theRequestURLStub + VIEWER_RESET_URI;
        HttpDelete aDelete = new HttpDelete(aDeleteURL);
        return doHttpRequest(aDelete, theApiKey, theBearerToken, theRepositoryId);
    }

    /**
     * Make an HTTP Request to the specified target
     * @param theHttpRequest
     * @param theApiKey
     * @param theAuthorisation
     * @param theRepositoryId
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
                        if (itsProductionMode && aStatusCode == HttpStatus.SC_INTERNAL_SERVER_ERROR) 
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
			anApiResponse = ApiUtils.buildJsonErrorResponse(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Exception caught: error encountered running request on the specified repository\", \"repository\" : \"" + theRepositoryId + "\"");
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
					anApiResponse = ApiUtils.buildJsonErrorResponse(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Exception caught: error encountered running request on the specified repository\", \"repository\" : \"" + theRepositoryId + "\"");
				}
			}
		}
		return anApiResponse;
	}

    /**
     * Build a POST request, creating a form request body
     * @param theRequestURLStub
     * @param theApiKey
     * @param theAuthorisation
     * @param theRepositoryId
     * @param theCollectionName
     * @param theJsonPayload
     * @return
     */
    private ApiResponse doPostHttpRequest(String theRequestURLStub,
                                          String theApiKey,
                                          String theAuthorisation,
                                          String theRepositoryId,
                                          String theCollectionName,
                                          String theJsonPayload)
    {
        String aPostURL = theRequestURLStub + VIEWER_POST_URL + theCollectionName;
        if((theJsonPayload != null) && (theJsonPayload.length() > 0)) 
		{
            HttpPost anAPIPost = new HttpPost(aPostURL);
            
            // Add the JSON payload to the request body
			MultipartEntityBuilder aMultiPartEntity = MultipartEntityBuilder.create();
			/**
             * Add the JSON payload to the request body
             * DK/NW 2023/03/22 - set character encoding to UTF-8 to fix issues with encoding non-ASCII chrs
             */
			aMultiPartEntity.addTextBody(ESSENTIAL_REF_API_PARAMETER_NAME, theJsonPayload, ContentType.create("application/json", StandardCharsets.UTF_8));
			anAPIPost.setEntity(aMultiPartEntity.build());
			return doHttpRequest(anAPIPost, theApiKey, theAuthorisation, theRepositoryId);
        } 
        else 
        {
			throw new IllegalArgumentException("No script specified");
		}
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
	 * Compute the pre-cache configuration by invoking the PRE_CACHE_QUERY_XSL_FILENAME XSL
	 * on the specified XML
	 * @param theXMLParameter
	 * @param theXSLParameter
	 * @return a String in JSON form
	 */
	private String getPreCacheJson(String theXMLParameter, String theXSLParameter)
	{
		// Compute the full path the source XML
		String anXMLParameter = itsServletContext.getRealPath("/") + theXMLParameter;
		itsLog.debug("XML Full Path is: {}", anXMLParameter);
		String anXSLParameter = itsServletContext.getRealPath("/") + theXSLParameter;
		itsLog.debug("XSL Full Path is: {}", anXSLParameter);
		
		// Generate the required report
		// Create a separate Error lister for the cached factory 
		ViewTransformErrorListener aFactoryErrorListener = new ViewTransformErrorListener();
		// And for the local transformer
		ViewTransformErrorListener aTransformError = new ViewTransformErrorListener();
		StringWriter aResultString = new StringWriter();
		EssentialViewerEngine aViewerEngine = new EssentialViewerEngine(itsServletContext);
		
		try
		{
			// Get the transformer factory that contains the xmlFile - ready parsed - for us to use
			TransformerFactoryImpl tFactory = aViewerEngine.getTransformerFactory(anXMLParameter, aFactoryErrorListener);

			// 02.02.2012 JWC
			// Make sure we have the correct transform factory error listener especially if it has been cached
			aFactoryErrorListener = (ViewTransformErrorListener)tFactory.getErrorListener();
			
			// 09.11.2011 JWC Updated to use File object to improve cross-platform file path
			// tolerance for paths to XSL files.
			File anXSLFile = new File(anXSLParameter);
			Transformer transformer = tFactory.newTransformer(new StreamSource(anXSLFile));
			// Set a new local error listener for the transformer.
			transformer.setErrorListener(aTransformError);
			
			try 
			{
				// 15.11.2011 JWC Updated to use cached XML document.
				TreeInfo anXMLSource = aViewerEngine.getXMLSourceDocument(tFactory, anXMLParameter, aFactoryErrorListener);
				transformer.transform(anXMLSource, new StreamResult(aResultString));				
			} 			
			// Absorb any exceptions that are caught - log it but otherwise no action taken						
			catch (Exception anEx) 
			{
				// Handle the error message properly.
				itsLog.error("Unmanaged exception caught when creating pre-cache Report Reference list : {}", anEx);
			}
		} 
		catch(Exception anEx) 
		{
			// Handle the error message properly.			
			itsLog.error("Unmanaged exception caught when creating pre-cache Report Reference list : {}", anEx);			
		}
		String aResultJson = aResultString.toString();
		itsLog.debug("Returned JSON: {}", aResultJson);
		
		return aResultJson;
	}
	
	/**
	 * Make a request to get the set of Report Reference instances to pre-cache
	 * @param theXMLParameter
	 * @param theXSLParameter
	 * @return 
	 */
	private PreCacheReferenceList getPreCacheList(String theXMLParameter, String theXSLParameter)
	{		
		String aPreCacheJson = getPreCacheJson(theXMLParameter, theXSLParameter);
		PreCacheReferenceList aPreCacheList = null;
		
		try
		{
			ObjectMapper aMapper = new ObjectMapper();
			aPreCacheList = (PreCacheReferenceList) aMapper.readValue(aPreCacheJson, PreCacheReferenceList.class);
		}
		catch(Exception anEx)
		{
			itsLog.error("Error reading the pre-cache configuration: {}", anEx.getMessage());
		}
		return aPreCacheList;
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
		try {
			ApiErrorMessage anApiErrorMessage = (ApiErrorMessage) aMapper.readValue(theResponseJson, ApiErrorMessage.class);
			return new ApiResponse(anApiErrorMessage.getStatusCode(), theResponseJson);
		} catch (IOException e) {
			// couldn't parse the JSON, use fallback method below
			String aStringWithWhitespacesRemoved = theResponseJson.replace(" ", "");
			if (itsLog.isWarnEnabled() && aStringWithWhitespacesRemoved.startsWith("{\"statusCode\":")) {
				itsLog.warn("Couldn't parse the JSON response from the Reference API even though it looks like an error response as it starts with \"statusCode\". Falling back to string matching. Response JSON: {}"+theResponseJson);
			}
			int aStatusCode;
			if(aStringWithWhitespacesRemoved.startsWith("{\"statusCode\":4"))
				aStatusCode = 400; // catch-all 4xx
			else if(aStringWithWhitespacesRemoved.startsWith("{\"statusCode\":5"))
				aStatusCode = 500; // catch-all 5xx
			else
				aStatusCode = 200; // we make this the default as when the API runs successfully it doesn't return a status code in the response JSON
			return new ApiResponse(aStatusCode, theResponseJson);
		}
	}

	/**
	 * Inner class that runs in an ExecutorService thread pool
	 */
	class ReportReferenceRequestor implements Runnable
	{
		String itsXML = "";
        String itsXSL = "";
        String itsAPIKey = "";
        String itsBearerToken = "";
        String itsRepositoryId = "";
		
		/**
		 * @return the itsXML
		 */
		public String getItsXML() {
			return itsXML;
		}

		/**
		 * @param itsXML the itsXML to set
		 */
		public void setItsXML(String itsXML) {
			this.itsXML = itsXML;
		}

		/**
		 * @return the itsXSL
		 */
		public String getItsXSL() {
			return itsXSL;
		}

		/**
		 * @param itsXSL the itsXSL to set
		 */
		public void setItsXSL(String itsXSL) {
			this.itsXSL = itsXSL;
        }
        
        public String getItsAPIKey() {
            return itsAPIKey;
        }

        public void setItsAPIKey(String itsAPIKey) {
            this.itsAPIKey = itsAPIKey;
        }

        public String getItsBearerToken() {
            return itsBearerToken;
        }

        public void setItsBearerToken(String itsBearerToken) {
            this.itsBearerToken = itsBearerToken;
        }

        public String getItsRepositoryId() {
            return itsRepositoryId;
        }

        public void setItsRepositoryId(String itsRepositoryId) {
            this.itsRepositoryId = itsRepositoryId;
        }

		@Override
		public void run() 
		{
			// Using the defined parameters, call the getPreCacheJson() method
			String aReportReferenceJson = getPreCacheJson(itsXML, itsXSL);
			
			// Save the Json in the cache
            String aCachedReferenceView = itsXSL.replace('/', '.');
            String aCachedReferenceName = StringUtils.removeEnd(aCachedReferenceView, ".xsl");	
			writeToCache(aCachedReferenceName, aReportReferenceJson, itsRepositoryId, itsBearerToken, itsAPIKey);			
		}
	}
}
