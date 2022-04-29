/**
 * Copyright (c)2019-2021 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 * @author Jonathan W. Carter
 * 
 * 21.03.2019	JWC	1st implementation
 * 25.03.2019	JWC 2nd implementation that uses a proxy pattern to forward the requests
 * 27.03.2019	JWC Migrated into Viewer
 * 07.10.2020	JWC Tighten up some of the settings for HTTP client connections
 * 19.02.2021	JWC	Handle scenarios where the client connection pool is shutdown
 *   
 */
package com.enterprise_architecture.essential.report.api;

import java.io.Closeable;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URI;
import java.net.URL;
import java.util.BitSet;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Formatter;
import java.util.Properties;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpHost;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.AbortableHttpRequest;
import org.apache.http.client.utils.URIUtils;
import org.apache.http.config.SocketConfig;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicHeader;
import org.apache.http.message.BasicHttpEntityEnclosingRequest;
import org.apache.http.message.BasicHttpRequest;
import org.apache.http.message.HeaderGroup;
import org.apache.http.util.EntityUtils;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.easdatamanagement.model.EssentialEventNotification;
import com.enterprise_architecture.easdatamanagement.model.EssentialEventNotification.DomainEvent;
import com.enterprise_architecture.easdatamanagement.model.EssentialEventNotification.Resource;
import com.enterprise_architecture.easdatamanagement.model.EssentialEventNotification.ResourceType;
import com.enterprise_architecture.essential.report.security.ViewerSecurityManager;


/**
 * 
 * Servlet to handle requests from Forms with a Cookie-based bearer token and forward this 
 * to the Essential API Gateway with the bearer token added to the HTTP Request Header.
 * The handling of the Cookie->Bearer Token is handled by the #copyRequestHeaders() method.
 * <br/>Based on the Smiley's HTTP Proxy.
 * 
 * @author Jonathan Carter
 *
 */
@WebServlet(name="essentialAPIPassThru", description="Pass-thru servlet to proxy all requests to Essential API Platform", urlPatterns= {"/api"}, loadOnStartup = 1)
//public class EssentialAPIPassThru extends EssentialAPIServlet
public class EssentialAPIPassThru extends HttpServlet
{
	protected static final BitSet asciiQueryChars;
		static 
		{		  
			char[] c_unreserved = "_-!.~'()*".toCharArray();//plus alphanum
			char[] c_punct = ",;:$&+=".toCharArray();
			char[] c_reserved = "?/[]@".toCharArray();//plus punct
			
			asciiQueryChars = new BitSet(128);
			for(char c = 'a'; c <= 'z'; c++) asciiQueryChars.set((int)c);
			for(char c = 'A'; c <= 'Z'; c++) asciiQueryChars.set((int)c);
			for(char c = '0'; c <= '9'; c++) asciiQueryChars.set((int)c);
			for(char c : c_unreserved) asciiQueryChars.set((int)c);
			for(char c : c_punct) asciiQueryChars.set((int)c);
			for(char c : c_reserved) asciiQueryChars.set((int)c);
			
			asciiQueryChars.set((int)'%');//leave existing percent escapes in place
		}
	
	/** These are the "hop-by-hop" headers that should not be copied.
	   * http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html
	   * I use an HttpClient HeaderGroup class instead of Set&lt;String&gt; because this
	   * approach does case insensitive lookup faster.
	   */
	protected static final HeaderGroup hopByHopHeaders;
		static 
		{
			hopByHopHeaders = new HeaderGroup();
			String[] aHeaders = new String[] {
					"Connection", 
					"Keep-Alive", 
					"Proxy-Authenticate", 
					"Proxy-Authorization",
					"TE", 
					"Trailers", 
					"Transfer-Encoding", 
					"Upgrade"};
			
			for (String aHeader : aHeaders) 
			{
				hopByHopHeaders.addHeader(new BasicHeader(aHeader, null));
			}			
		}
		
	/**
	 * Serial Version UID
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * Location of the application properties
	 */
	private static final String APPLICATION_PROPERTIES_FILE = "WEB-INF/classes/passthru.properties";
	
	/**
	 * Name of the application property in which the target URL is located
	 */
	private static final String TARGET_API_URL_PROPERTY = "eip.api.passthru.target";

	private static final String MAX_HTTP_CLIENT_CONNECTIONS_PROPERTY = "eip.api.passthru.maxConnections";
	private static final String HTTP_CLIENT_CONNECT_TIMEOUT_PROPERTY = "eip.api.passthru.connectTimeout";
	private static final String HTTP_CLIENT_CONNECTIONS_RQ_TIMEOUT_PROPERTY = "eip.api.passthru.connectRequestTimeout";
	private static final String HTTP_CLIENT_SOCKET_TIMEOUT_PROPERTY = "eip.api.passthru.socketTimeout";

	private static final String KAFKA_SERVER_URL_PROPERTY = "eip.kafka.server.url";
	
	private static final String KAFKA_ENABLED_PROPERTY = "eip.kafka.enabled";
	
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
	
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(EssentialAPIPassThru.class);
	
	/**
	 * Preset some variables for the configuration
	 */
	protected int itsReadTimeout = -1;
	protected boolean itsDoPreserveHost = false;
	protected boolean itsDoPreserveCookies = false;
	protected boolean itsDoSendUrlFragment = true;

	protected int itsMaxClientConnections = -1;
	protected int itsClientConnectionTimeout = -1;
	protected int itsClientConnectRQTimeout = -1;
	
	/**
	 * Maintain a variable for the HTTP Client for forwarding requests on
	 */
	private HttpClient itsProxyClient;

	/**
	 * Maintain the HTTP Client connection pool as a member so that we 
	 * can monitor and manage it.
	 * @since 6.11.3.1
	 */
	private PoolingHttpClientConnectionManager itsPoolingConnectionManager;

	/**
	 * A semaphore to prevent ensure that only one thread performs the HttpClient
	 * and Connection Pool reset
	 * Initialised to true
	 * @since 6.11.3.1
	 */
	private boolean itIsWorking = true;

	/**
	 * The URL of the Target API Server
	 */
	private String itsTargetAPIURL = "";
	
	/** 
	 * URI object representing #itsTargetAPIURL 
	 */
	private URI itsTargetURIObject; // new URI(itsTargetAPIURL)
	
	/**
	 * An HttpHost derived from the #itsTargetAPIURL
	 */
	private HttpHost itsTargetHost;
	
	/**
	 * Always forward the originating IP address
	 */
	private boolean itsDoForwardIP = true;
	/**
	 * Kafka is disabled until explicitly enabled in platform.properties
	 */
	private boolean itsIsKafkaEnabled = false;
	
	/**
	 * Kafka Producer that is a singleton for this servlet
	 */
	private KafkaProducer<String, EssentialEventNotification> itsProducer;

	
	
	/**
	 * Default constructor for the servlet - no additional action 
	 */
	public EssentialAPIPassThru() 
	{
		super();
	}
	
	@Override
	public void destroy() 
	{
		//Usually, clients implement Closeable:
		if (itsProxyClient instanceof Closeable) 
		{
			try 
			{
				((Closeable) itsProxyClient).close();
				if(itsPoolingConnectionManager != null)
				{
					itsPoolingConnectionManager.shutdown();
				}
			} 
			catch (IOException e) 
			{
			    itsLog.error("While destroying servlet, shutting down HttpClient: "+e, e);
			}
		} 
		else 
		{
			//Older releases require we do this:
			if (itsProxyClient != null)
				itsPoolingConnectionManager.shutdown();				
		}
		
		// close Kafka Producer
		if (itsProducer != null) {
			itsProducer.close();
		}
		
		super.destroy();
	}
	
	/**
	 * Initialise the servlet. Read in the target API server URL from 
	 * the passthru.properties file
	 */
	@Override
	public void init() throws ServletException
	{
		super.init();		
		itsLog.info("--------- initialised ---------");
		
		// Read the API Platform's URL from the properties and save it in itsTargetAPIURL
		String aPropertiesFileName = APPLICATION_PROPERTIES_FILE;
		Properties aPropertyList = new Properties();
		try
		{
			aPropertyList.load(getServletContext().getResourceAsStream(aPropertiesFileName));
		}
		catch(IOException anIOEx)
		{
			itsLog.error("Could not load application properties file: {}", aPropertiesFileName);
			itsLog.error(anIOEx.toString());
		}
		
		// Find the target URL property
		itsTargetAPIURL = (String)aPropertyList.getProperty(TARGET_API_URL_PROPERTY);
		if(itsTargetAPIURL == null || itsTargetAPIURL.length() == 0)
		{
			// The property is not defined, so exit with an error
			itsLog.error("No target API Gateway defined. Make sure to set the {} property in the property file, passthru.properties", TARGET_API_URL_PROPERTY);			
		}

		try
		{
			itsMaxClientConnections = Integer.parseInt((String)aPropertyList.getProperty(MAX_HTTP_CLIENT_CONNECTIONS_PROPERTY));
			itsClientConnectionTimeout = Integer.parseInt((String)aPropertyList.getProperty(HTTP_CLIENT_CONNECT_TIMEOUT_PROPERTY));
			itsClientConnectRQTimeout = Integer.parseInt((String)aPropertyList.getProperty(HTTP_CLIENT_CONNECTIONS_RQ_TIMEOUT_PROPERTY));
			itsReadTimeout = Integer.parseInt((String)aPropertyList.getProperty(HTTP_CLIENT_SOCKET_TIMEOUT_PROPERTY));
		}
		catch (NumberFormatException aNumEx)
		{
			itsLog.error("Invalid property setting for the Max Client Connections or the Client Timeout properties. Resetting to defaults (-1)");
			itsMaxClientConnections = -1;
			itsClientConnectionTimeout = -1;
			itsClientConnectRQTimeout = -1;
			itsReadTimeout = -1;
		}

		// Initialise the target endpoint
		initTarget();
		
		itsLog.debug("Creating the HTTP Client (shared across request threads)...");
		itsProxyClient = createHttpClient();
		itsLog.debug("Initialising the Kafka Producer");
		// Initialise the Kafka Producer for the event logging - if Kafka is enabled
		if (aPropertyList.getProperty(KAFKA_ENABLED_PROPERTY).equalsIgnoreCase("true")) {
			itsIsKafkaEnabled = true;
			Properties aKafkaProps = new Properties();
			aKafkaProps.put("bootstrap.servers", aPropertyList.getProperty(KAFKA_SERVER_URL_PROPERTY));
			aKafkaProps.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
			aKafkaProps.put("value.serializer", "com.enterprise_architecture.easdatamanagement.model.EssentialEventNotificationSerializer");
			aKafkaProps.put("enable.idempotence", "true");
			/**
			 * Added a unique client otherwise we were getting warnings in the logs that our producer instance
			 * already exists. This didn't stop Kafka from logging but was generating a lot of trace in the logs.
			 * Warning was:
			 * javax.management.InstanceAlreadyExistsException: kafka.producer:type=app-info,id=producer-1
			 */
			aKafkaProps.put("client.id", "viewer-pass-thru."+UUID.randomUUID().toString());
			itsProducer = new KafkaProducer<>(aKafkaProps);
		}

		
	}

//	/**
//	 * Handle DELETE requests
//	 * @param theRequest
//	 * @param theResponse
//	 * @throws IOException
//	 * @throws ServletException
//	 */
//	@Override
//	public void doDelete(HttpServletRequest theRequest, HttpServletResponse theResponse) 
//			throws IOException, ServletException
//	{
//		forwardRequest(theRequest, theResponse);
//	}
//	
//	/** 
//	 * Handle GET requests
//	 * @param theRequest
//	 * @param theResponse
//	 * @throws IOException
//	 * @throws ServletException
//	 */
//	@Override
//	public void doGet(HttpServletRequest theRequest, HttpServletResponse theResponse) 
//			throws IOException, ServletException
//	{
//		forwardRequest(theRequest, theResponse);
//	}
//	
//	/** 
//	 * Handle PATCH requests
//	 * 
//	 * @param theRequest
//	 * @param theResponse
//	 * @throws IOException
//	 * @throws ServletException
//	 */	
//	public void doPatch(HttpServletRequest theRequest, HttpServletResponse theResponse) 
//			throws IOException, ServletException
//	{
//		forwardRequest(theRequest, theResponse);
//	}
//	
//	/**
//	 * Handle POST requests
//	 * @param theRequest
//	 * @param theResponse
//	 * @throws IOException
//	 * @throws ServletException
//	 */
//	@Override
//	public void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse) 
//			throws IOException, ServletException
//	{
//		forwardRequest(theRequest, theResponse);
//	}
//	
//	/**
//	 * @param theRequest
//	 * @param theResponse
//	 * @throws IOException
//	 * @throws ServletException
//	 */
//	@Override
//	public void doPut(HttpServletRequest theRequest, HttpServletResponse theResponse) 
//			throws IOException, ServletException
//	{
//		forwardRequest(theRequest, theResponse);
//	}
//	
//	/**
//	 * Forward the specified request to the target API Gateway
//	 * @param theRequest the request - which should be extended and contain the extended header from original cookie containing
//	 * the SSO Cookie
//	 * @param theResponse the response
//	 * @throws IOException 
//	 * @throws ServletException
//	 */
//	private void forwardRequest(HttpServletRequest theRequest, HttpServletResponse theResponse) 
//			throws IOException, ServletException
//	{
//		// Some debug trace
//		itsLog.debug("Request Method: {}", theRequest.getMethod());
//		itsLog.debug("Request x-api-key: {}", theRequest.getHeader("x-api-key"));
//		itsLog.debug("Request ssoToken: {}", theRequest.getHeader("Authorization"));
//		itsLog.debug("Requested URI: {}", theRequest.getRequestURI());
//		itsLog.debug("Requested query string: {}", theRequest.getQueryString());
//		// Use the path from the properties file
//		String aRedirectedPath = itsTargetAPIURL + theRequest.getRequestURI().replace(theRequest.getContextPath(), "") + "?" + theRequest.getQueryString();	
//		theResponse.sendRedirect(aRedirectedPath);
//	}
	
	/**
	 * Sub-classes can override specific behaviour of {@link org.apache.http.client.config.RequestConfig}.
	 */
	protected RequestConfig buildRequestConfig() 
	{
		// TODO - Validate these parameters are 'vanilla' / sensible for standard HTTP Clients
		return RequestConfig.custom()
				.setRedirectsEnabled(true) // Handle redirects = true
	            .setCookieSpec(CookieSpecs.IGNORE_COOKIES) // we handle them in the servlet instead
	            .setConnectTimeout(itsClientConnectionTimeout)
	            .setSocketTimeout(itsReadTimeout)
	            .setConnectionRequestTimeout(itsClientConnectRQTimeout)
	            .build();
	}

	/**
	  * Sub-classes can override specific behaviour of {@link org.apache.http.config.SocketConfig}.
	  */
	protected SocketConfig buildSocketConfig() 
	{
		if (itsReadTimeout < 1) 
		{
			return null;
		}
		// TODO - Validate these parameters are 'vanilla' / sensible for standard HTTP Clients
		return SocketConfig.custom().setSoTimeout(itsReadTimeout).build();
	}
	
	/**
	 * Close quietly
	 * @param closeable
	 */
	protected void closeQuietly(Closeable closeable) 
	{
	    try 
	    {
	    	closeable.close();
	    } 
	    catch (IOException e) 
	    {
	    	itsLog.error(e.getMessage(), e);
	    }
	}
	
	/**
	   * Copy a request header from the servlet client to the proxy request.
	   * This is easily overridden to filter out certain headers if desired.
	   */
	protected void copyRequestHeader(HttpServletRequest theServletRequest, 
									 HttpRequest theProxyRequest,
	                                 String theHeaderName) 
	{
	    //Instead the content-length is effectively set via InputStreamEntity
	    if (theHeaderName.equalsIgnoreCase(HttpHeaders.CONTENT_LENGTH))
	    	return;
	    if (hopByHopHeaders.containsHeader(theHeaderName))
	    	return;
	    
	    Enumeration<String> aHeaders = theServletRequest.getHeaders(theHeaderName);
	    while (aHeaders.hasMoreElements()) 
	    {
	    	//sometimes more than one value
	    	String aHeaderValue = aHeaders.nextElement();
	      
	    	// In case the proxy host is running multiple virtual servers,
	    	// rewrite the Host header to ensure that we get content from
	    	// the correct virtual server
	    	if (!itsDoPreserveHost && theHeaderName.equalsIgnoreCase(HttpHeaders.HOST)) 
	    	{
	    		HttpHost aHost = getTargetHost(theServletRequest);
	    		aHeaderValue = aHost.getHostName();
	    		if (aHost.getPort() != -1)
	    			aHeaderValue += ":" + aHost.getPort();
	    	} 
	    		    	
	    	// Ignore all cookies as we're proxying for the API Gateway
//	    	else if (!itsDoPreserveCookies && theHeaderName.equalsIgnoreCase(org.apache.http.cookie.SM.COOKIE)) 
//	    	{
//	    		aHeaderValue = getRealCookie(aHeaderValue);
//	    	}
	    	theProxyRequest.addHeader(theHeaderName, aHeaderValue);
	    }
	}
	
	/**
	   * Copy request headers from the servlet client to the proxy request.
	   * This is easily overridden to add your own.
	   */
	protected void copyRequestHeaders(HttpServletRequest theServletRequest, HttpRequest theProxyRequest) 
	{
	    // Get an Enumeration of all of the header names sent by the client
	    Enumeration<String> enumerationOfHeaderNames = theServletRequest.getHeaderNames();
	    while (enumerationOfHeaderNames.hasMoreElements()) 
	    {
	    	String aHeaderName = enumerationOfHeaderNames.nextElement();
	    	copyRequestHeader(theServletRequest, theProxyRequest, aHeaderName);
	    }
	    
	    // Add the Bearer Token
	    itsLog.debug("Adding bearer token to header");
	    String aBearerToken = getBearerToken(theServletRequest);
	    if (aBearerToken != null) {
	    	String aBearerHeader = BEARER_PREFIX + aBearerToken;
	    	theProxyRequest.addHeader(AUTHORIZATION_HEADER, aBearerHeader);
	    } else {
	    	itsLog.error("No bearer token stored in session, not added to headers for request.");
	    }
	    
	    // Add the API Key for the tenant
	    itsLog.debug("Adding user's tenant API key to header");
	    String anAPIKey = getAPIKey(theServletRequest);
	    if(anAPIKey != null)
	    {
	    	theProxyRequest.addHeader(API_KEY_HEADER, anAPIKey);
	    } else {
	    	itsLog.error("No API Key stored in session, not added to headers for request.");
	    }
	}
	
	/** Copy response body data (the entity) from the proxy to the servlet client. */
	protected void copyResponseEntity(HttpResponse theProxyResponse, 
									  HttpServletResponse theServletResponse,
									  HttpRequest theProxyRequest, 
									  HttpServletRequest theServletRequest)
											  throws IOException 
	{
	    HttpEntity entity = theProxyResponse.getEntity();
	    if (entity != null) 
	    {
	    	OutputStream servletOutputStream = theServletResponse.getOutputStream();
	    	entity.writeTo(servletOutputStream);
	    }
	}

	
	/** Copy a proxied response header back to the servlet client.
	   * This is easily overwritten to filter out certain headers if desired.
	   */
	protected void copyResponseHeader(HttpServletRequest theServletRequest,
	                                  HttpServletResponse theServletResponse, 
	                                  Header theHeader) 
	{
	    String aHeaderName = theHeader.getName();
	    if (hopByHopHeaders.containsHeader(aHeaderName))
	    	return;
	    
	    
	    String aHeaderValue = theHeader.getValue();
	    /**
	     * DK 2020-06-26
	     * We ignore any cookies in the response as only Viewer should be setting
	     * cookies for the browser - not services lower down in the stack.
	     */
	    if (aHeaderName.equalsIgnoreCase(org.apache.http.cookie.SM.SET_COOKIE) ||
	        aHeaderName.equalsIgnoreCase(org.apache.http.cookie.SM.SET_COOKIE2)) 
	    {
	    	// do nothing
	    	itsLog.debug("Ignoring cookie in response with value: "+aHeaderValue);
	    } 
	    else if (aHeaderName.equalsIgnoreCase(HttpHeaders.LOCATION))
	    {
	    	// LOCATION Header may have to be rewritten.
	    	theServletResponse.addHeader(aHeaderName, rewriteUrlFromResponse(theServletRequest, aHeaderValue));
	    } 
	    else 
	    {
	    	theServletResponse.addHeader(aHeaderName, aHeaderValue);
	    }
	}
	
//	/**
//	   * Copy cookie from the proxy to the servlet client.
//	   * Replaces cookie path to local path and renames cookie to avoid collisions.
//	   */
//	  protected void copyProxyCookie(HttpServletRequest servletRequest,
//	                                 HttpServletResponse servletResponse, String headerValue) {
//	    //build path for resulting cookie
//	    String path = servletRequest.getContextPath(); // path starts with / or is empty string
//	    path += servletRequest.getServletPath(); // servlet path starts with / or is empty string
//	    if(path.isEmpty()){
//	      path = "/";
//	    }
//
//	    for (HttpCookie cookie : HttpCookie.parse(headerValue)) {
//	      //set cookie name prefixed w/ a proxy value so it won't collide w/ other cookies
//	      String proxyCookieName = doPreserveCookies ? cookie.getName() : getCookieNamePrefix(cookie.getName()) + cookie.getName();
//	      Cookie servletCookie = new Cookie(proxyCookieName, cookie.getValue());
//	      servletCookie.setComment(cookie.getComment());
//	      servletCookie.setMaxAge((int) cookie.getMaxAge());
//	      servletCookie.setPath(path); //set to the path of the proxy servlet
//	      // don't set cookie domain
//	      servletCookie.setSecure(cookie.getSecure());
//	      servletCookie.setVersion(cookie.getVersion());
//	      servletCookie.setHttpOnly(cookie.isHttpOnly());
//	      servletResponse.addCookie(servletCookie);
//	    }
//	  }

	
	/** Copy proxied response headers back to the servlet client. */  
	protected void copyResponseHeaders(HttpResponse theProxyResponse, 
									   HttpServletRequest theServletRequest,
	                                   HttpServletResponse theServletResponse) 
	{
	    for (Header aHeader : theProxyResponse.getAllHeaders()) 
	    {
	    	copyResponseHeader(theServletRequest, theServletResponse, aHeader);
	    }
	}

	/**
	  * Called from {@link #init(javax.servlet.ServletConfig)}.
	  * HttpClient offers many opportunities for customization.
	  * In any case, it should be thread-safe.
	  */
	protected HttpClient createHttpClient() 
	{
		// Build a pooling connection manager, explicitly, so that we can control the pool
		itsLog.debug("Creating HttpClient for Proxy. Max Number of Connections: {}", itsMaxClientConnections);
		//PoolingHttpClientConnectionManager aPoolingConnectionManager = new PoolingHttpClientConnectionManager();
		if(itsPoolingConnectionManager != null)
		{
			// Reset the connection manager
			itsPoolingConnectionManager.shutdown();
		}
		itsPoolingConnectionManager = new PoolingHttpClientConnectionManager();
		itsPoolingConnectionManager.setMaxTotal(itsMaxClientConnections);
		itsPoolingConnectionManager.setDefaultMaxPerRoute(itsMaxClientConnections);
		
		// Include the pooling connection manager in the HttpClient builder
		HttpClientBuilder aClientBuilder = HttpClientBuilder.create()
															.setConnectionManager(itsPoolingConnectionManager)
															.setConnectionManagerShared(true)
															.setDefaultRequestConfig(buildRequestConfig())
															.setDefaultSocketConfig(buildSocketConfig());
	    
	    return aClientBuilder.build();
	}

	/**
	 * Execute the proxied request
	 * @param theServletRequest
	 * @param theServletResponse
	 * @param theProxyRequest
	 * @return
	 * @throws IOException
	 */
	protected HttpResponse doExecute(HttpServletRequest theServletRequest, 
									 HttpServletResponse theServletResponse,
									 HttpRequest theProxyRequest) throws IOException 
	{
		itsLog.debug("Proxy {} URI: {} -- {}", 
				theServletRequest.getMethod(), 
				theServletRequest.getRequestURI(), 
				theProxyRequest.getRequestLine().getUri());		
		if(itsProxyClient == null)
		{
			itsLog.warn("HttpClient was null! Recreating...");
			
			// If the client is null (it shouldn't be), (re)create it 
			// to make sure that we don't get a null pointer exception etc.
			// A synchronized block in the handleRequestException() will make
			// sure that this can't be called if the proxy client is in process 
			// of being re-created
			itsProxyClient = createHttpClient();
		}
		return itsProxyClient.execute(getTargetHost(theServletRequest), theProxyRequest);
	}
	
//	/** The string prefixing rewritten cookies. */
//	  protected String getCookieNamePrefix(String name) {
//	    return "!Proxy!" + getServletConfig().getServletName();
//	  }
//
	
	/**
	   * Encodes characters in the query or fragment part of the URI.
	   *
	   * <p>Unfortunately, an incoming URI sometimes has characters disallowed by the spec.  HttpClient
	   * insists that the outgoing proxied request has a valid URI because it uses Java's {@link URI}.
	   * To be more forgiving, we must escape the problematic characters.  See the URI class for the
	   * spec.
	   *
	   * @param theIn example: name=value&amp;foo=bar#fragment
	   * @param theEncodePercent determine whether percent characters need to be encoded
	   */
	protected CharSequence encodeUriQuery(CharSequence theIn, boolean theEncodePercent) 
	{
	    //Note that I can't simply use URI.java to encode because it will escape pre-existing escaped things.
	    StringBuilder anOutBuf = null;
	    Formatter aFormatter = null;
	    for(int i = 0; i < theIn.length(); i++) 
	    {
	    	char c = theIn.charAt(i);
	    	boolean isEscape = true;
	    	if (c < 128) 
	    	{
	    		if (asciiQueryChars.get((int)c) && !(theEncodePercent && c == '%')) 
	    		{
	    			isEscape = false;
	    		}
	    	} 
	    	else if (!Character.isISOControl(c) && !Character.isSpaceChar(c)) 
	    	{//not-ascii
	    		isEscape = false;
	    	}
	    	if (!isEscape) 
	    	{
	    		if (anOutBuf != null)
	    			anOutBuf.append(c);
	    	} 
	    	else 
	    	{
	    		//escape
	    		if (anOutBuf == null) 
	    		{
	    			anOutBuf = new StringBuilder(theIn.length() + 5*3);
	    			anOutBuf.append(theIn,0,i);
	    			aFormatter = new Formatter(anOutBuf);
	    		}
	    		//leading %, 0 padded, width 2, capital hex
	    		aFormatter.format("%%%02X",(int)c);
	    	}
	    }
	    return anOutBuf != null ? anOutBuf : theIn;
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
	 * Reads a configuration parameter. By default it reads servlet init parameters but
	 * it can be overridden.
	 */
	protected String getConfigParam(String theKey)
	{
		return getServletConfig().getInitParameter(theKey);
	}
	
	// Get the header value as a long in order to more correctly proxy very large requests
	private long getContentLength(HttpServletRequest request) 
	{
	    String contentLengthHeader = request.getHeader("Content-Length");
	    if (contentLengthHeader != null) 
	    {
	    	return Long.parseLong(contentLengthHeader);
	    }
	    return -1L;
	}
	
	/**
	   * The http client used.
	   * @see #createHttpClient()
	   */
	protected HttpClient getProxyClient() 
	{
	    return itsProxyClient;
	}
	
//	/**
//	   * Take any client cookies that were originally from the proxy and prepare them to send to the
//	   * proxy.  This relies on cookie headers being set correctly according to RFC 6265 Sec 5.4.
//	   * This also blocks any local cookies from being sent to the proxy.
//	   */
//	  protected String getRealCookie(String cookieValue) {
//	    StringBuilder escapedCookie = new StringBuilder();
//	    String cookies[] = cookieValue.split("[;,]");
//	    for (String cookie : cookies) {
//	      String cookieSplit[] = cookie.split("=");
//	      if (cookieSplit.length == 2) {
//	        String cookieName = cookieSplit[0].trim();
//	        if (cookieName.startsWith(getCookieNamePrefix(cookieName))) {
//	          cookieName = cookieName.substring(getCookieNamePrefix(cookieName).length());
//	          if (escapedCookie.length() > 0) {
//	            escapedCookie.append("; ");
//	          }
//	          escapedCookie.append(cookieName).append("=").append(cookieSplit[1].trim());
//	        }
//	      }
//	    }
//	    return escapedCookie.toString();
//	  }
//		
	
	protected HttpHost getTargetHost(HttpServletRequest theRequest)
	{
		String aHost = "";
		int aPort = -1;
		try
		{
			URL aURL = new URL(itsTargetAPIURL);
			aHost = aURL.getHost();
			aPort = aURL.getPort();			
		}
		catch (Exception anEx)
		{
			itsLog.error("Error getting Target URL: " + anEx.getMessage());
		}
		
		return new HttpHost(aHost, aPort);
	}
	
	protected String getTargetUri(HttpServletRequest theRequest)
	{
		return itsTargetAPIURL;
	}
	
	/**
	 * Handle a request exception
	 * @param proxyRequest
	 * @param e
	 * @throws ServletException
	 * @throws IOException
	 */
	protected void handleRequestException(HttpRequest proxyRequest, Exception e) throws ServletException, IOException 
	{
		itsLog.debug("Handling an HTTP Client Request exception: {}", e.toString());
		
		// We've had an exception on the request, if it's an IllegalStateException,
		// reset the proxy client, just to be sure
		if (e instanceof IllegalStateException)
		{
			// Mark the semaphore as false - the HttpClient is NOT working
			itIsWorking = false;
			synchronized(this)
			{
				// Synchronize here to ensure that multiple threads with IllegalStateExceptions don't all attempt to reset
				if(itIsWorking == false)
				{
					itsLog.error("IllegalStateException being handled... {}", e);
					if(itsProxyClient != null)		
					{
						try 
						{
							itsLog.debug("Closing the proxy HTTP client...");
							((Closeable) itsProxyClient).close();						
						} 
						catch (IOException anIoEx) 
						{
							itsLog.error("While closing Proxy Client, shutting down HttpClient: {}", anIoEx);
						}
					}
					// Make sure that the connection pool has been shutdown, since the client is closed
					if(itsPoolingConnectionManager != null)
					{
						itsLog.debug("Shutting down the connection pool");
						itsPoolingConnectionManager.shutdown();
					}
					// Make sure any resources associated with the proxy client are freed
					itsProxyClient = null;
					itsLog.debug("HttpClient closed and nulled.");
					
					// Create a new client				
					itsLog.debug("Creating a new HTTP Client...");
					itsProxyClient = createHttpClient();
					itsLog.debug("New HTTP Client and connection pool created.");
					itsLog.warn("Received and handled IllegalStateException. HttpClient and Connection Pool reset. Client: {}, Connection pool max total: {}", itsProxyClient.toString(), itsPoolingConnectionManager.getMaxTotal());
					
					// We've reset the HttpClient, so now it is working
					itIsWorking = true;
				}
			}
		}
		
		// Otherwise, just raise the exceptions, the HttpClient object will sort itself out, no need
		// to force it to rebuild itself.
		// 
		
	    //abort request, according to best practice with HttpClient
	    if (proxyRequest instanceof AbortableHttpRequest) 
	    {
	    	AbortableHttpRequest abortableHttpRequest = (AbortableHttpRequest) proxyRequest;
	    	abortableHttpRequest.abort();
	    }
	    if (e instanceof RuntimeException)
	    	throw (RuntimeException)e;
	    if (e instanceof ServletException)
	    	throw (ServletException)e;
	    //noinspection ConstantConditions
	    if (e instanceof IOException)
	    	throw (IOException) e;
	    throw new RuntimeException(e);
	}
	
	/** 
	 * Initialise the connection to the proxied host, the Essential API Platform
	 * @throws ServletException
	 */
	protected void initTarget() throws ServletException 
	{
	    //test it's valid
	    try 
	    {
	    	itsTargetURIObject = new URI(itsTargetAPIURL);
	    } 
	    catch (Exception e) 
	    {
	    	throw new ServletException("Trying to process targetUri init parameter: "+e,e);
	    }
	    itsTargetHost = URIUtils.extractHost(itsTargetURIObject);
	}
	
	protected HttpRequest newProxyRequestWithEntity(String theMethod, 
													String theProxyRequestUri,
													HttpServletRequest theServletRequest)
															throws IOException 
	{
		HttpEntityEnclosingRequest anEnclosingProxyRequest =
				new BasicHttpEntityEnclosingRequest(theMethod, theProxyRequestUri);
		// Add the input entity (streamed)
		//  note: we don't bother ensuring we close the servletInputStream since the container handles it
		anEnclosingProxyRequest.setEntity(
				new InputStreamEntity(theServletRequest.getInputStream(), getContentLength(theServletRequest)));
		
		return anEnclosingProxyRequest;
	}
	
	protected String rewriteQueryStringFromRequest(HttpServletRequest theServletRequest, String theQueryString) 
	{
	    return theQueryString;
	}
	
	/**
	   * Allow overrides of {@link javax.servlet.http.HttpServletRequest#getPathInfo()}.
	   * Useful when url-pattern of servlet-mapping (web.xml) requires manipulation.
	   */
	protected String rewritePathInfoFromRequest(HttpServletRequest theServletRequest) 
	{
	    return theServletRequest.getPathInfo();
	}

	/**
	   * Reads the request URI from {@code servletRequest} and rewrites it, considering targetUri.
	   * It's used to make the new request.
	   */
	protected String rewriteUrlFromRequest(HttpServletRequest theServletRequest) 
	{
	    StringBuilder uri = new StringBuilder(500);
	    uri.append(getTargetUri(theServletRequest));
	    
	    // Handle the path given to the servlet
	    String aPathInfo = rewritePathInfoFromRequest(theServletRequest);
	    
	    if (aPathInfo != null) 
	    {
	    	//ex: /my/path.html
	    	// getPathInfo() returns decoded string, so we need encodeUriQuery to encode "%" characters
	    	uri.append(encodeUriQuery(aPathInfo, true));
	    }
	    
	    // Handle the query string & fragment
	    String aQueryString = theServletRequest.getQueryString();//ex:(following '?'): name=value&foo=bar#fragment
	    String aFragment = null;
	    //split off fragment from queryString, updating queryString if found
	    if (aQueryString != null) 
	    {
	    	int fragIdx = aQueryString.indexOf('#');
	    	if (fragIdx >= 0) 
	    	{
	    		aFragment = aQueryString.substring(fragIdx + 1);
	    		aQueryString = aQueryString.substring(0,fragIdx);
	    	}
	    }

	    aQueryString = rewriteQueryStringFromRequest(theServletRequest, aQueryString);
	    if (aQueryString != null && aQueryString.length() > 0) 
	    {
	    	uri.append('?');
	    	// queryString is not decoded, so we need encodeUriQuery not to encode "%" characters, to avoid double-encoding
	    	uri.append(encodeUriQuery(aQueryString, false));
	    }

	    if (itsDoSendUrlFragment && aFragment != null) 
	    {
	    	uri.append('#');
	    	// fragment is not decoded, so we need encodeUriQuery not to encode "%" characters, to avoid double-encoding
	    	uri.append(encodeUriQuery(aFragment, false));
	    }
	    return uri.toString();
	}
	
	/**
	   * For a redirect response from the target server, this translates {@code theUrl} to redirect to
	   * and translates it to one the original client can use.
	   */
	protected String rewriteUrlFromResponse(HttpServletRequest theServletRequest, String theUrl) 
	{	    
	    final String targetUri = getTargetUri(theServletRequest);
	    if (theUrl.startsWith(targetUri)) 
	    {
		    /*-	       
		     * The URL points back to the back-end server.
		     * Instead of returning it verbatim we replace the target path with our
		     * source path in a way that should instruct the original client to
		     * request the URL pointed through this Proxy.
		     * We do this by taking the current request and rewriting the path part
		     * using this servlet's absolute path and the path from the returned URL
		     * after the base target URL.
		     */
		    StringBuffer curUrl = theServletRequest.getRequestURL();//no query
		    int pos;
		    // Skip the protocol part
		    if ((pos = curUrl.indexOf("://"))>=0) 
		    {
		        // Skip the authority part
		        // + 3 to skip the separator between protocol and authority
		        if ((pos = curUrl.indexOf("/", pos + 3)) >=0) 
		        {
		        	// Trim everything after the authority part.
		        	curUrl.setLength(pos);
		        }
		    }
		    // Context path starts with a / if it is not blank
		    curUrl.append(theServletRequest.getContextPath());
		    // Servlet path starts with a / if it is not blank
		    curUrl.append(theServletRequest.getServletPath());
		    curUrl.append(theUrl, targetUri.length(), theUrl.length());
		    return curUrl.toString();
	    }
	    return theUrl;
	}
	
	@Override
	protected void service(HttpServletRequest theServletRequest, HttpServletResponse theServletResponse)
			throws ServletException, IOException 
	{
		try {
		
		    //initialize request attributes from caches if unset by a subclass by this point
	//	    if (theServletRequest.getAttribute(ATTR_TARGET_URI) == null) {
	//	      theServletRequest.setAttribute(ATTR_TARGET_URI, targetUri);
	//	    }
	//	    if (theServletRequest.getAttribute(ATTR_TARGET_HOST) == null) {
	//	      theServletRequest.setAttribute(ATTR_TARGET_HOST, targetHost);
	//	    }
			
			// Some debug trace
			itsLog.debug("Request Method: {}", theServletRequest.getMethod());
			itsLog.debug("Requested URI: {}", theServletRequest.getRequestURI());
			itsLog.debug("Requested query string: {}", theServletRequest.getQueryString());
			if (itsLog.isDebugEnabled()) {
				// this logs cookies as well as they are passed in the request header
				Collections.list(theServletRequest.getHeaderNames()).stream().forEach(h -> itsLog.debug("Request header {} : {}", h, theServletRequest.getHeader(h)));
			}
	
		    // Make the Request
		    //note: we won't transfer the protocol version because I'm not sure it would truly be compatible
		    String aMethod = theServletRequest.getMethod();
		    String aProxyRequestUri = rewriteUrlFromRequest(theServletRequest);
		    HttpRequest aProxyRequest;
		    
		    //spec: RFC 2616, sec 4.3: either of these two headers signal that there is a message body.
		    if (theServletRequest.getHeader(HttpHeaders.CONTENT_LENGTH) != null ||
		        theServletRequest.getHeader(HttpHeaders.TRANSFER_ENCODING) != null) 
		    {
		    	itsLog.debug("Request with entity, method: {}", aMethod);
		    	aProxyRequest = newProxyRequestWithEntity(aMethod, aProxyRequestUri, theServletRequest);
		    } 
		    else 
		    {
		    	itsLog.debug("Simple request - basic request for method: {}", aMethod);
		    	aProxyRequest = new BasicHttpRequest(aMethod, aProxyRequestUri);
		    }
		    
		    // Copy all the request headers across
		    copyRequestHeaders(theServletRequest, aProxyRequest);
	
		    // Set the X-Forwarded-For header
		    setXForwardedForHeader(theServletRequest, aProxyRequest);
	
	    	itsLog.info("Proxy request, method: {}", aMethod);
	    	itsLog.info("Proxy request, url: {}", aProxyRequestUri);
			if (itsLog.isInfoEnabled()) {
				Header[] aListOfHeaders = aProxyRequest.getAllHeaders();
				for (Header aHeader : aListOfHeaders) {
					itsLog.info("Proxy request header {} : {}", aHeader.getName(), aHeader.getValue());
				}
			}
	
		    
		    HttpResponse aProxyResponse = null;
		    try 
		    {
		    	// log the event
		    	logEventToKafka(theServletRequest);
		    	
		    	// Execute the request
		    	aProxyResponse = doExecute(theServletRequest, theServletResponse, aProxyRequest);
	
		    	// Process the response:
	
				// Pass the response code. This method with the "reason phrase" is deprecated but it's the
				//   only way to pass the reason along too.
				int statusCode = aProxyResponse.getStatusLine().getStatusCode();
				itsLog.info("Proxy response status code {}", statusCode);
				  
				//noinspection deprecation
				theServletResponse.setStatus(statusCode, aProxyResponse.getStatusLine().getReasonPhrase());
	
				// Copying response headers to make sure SESSIONID or other Cookie which comes from the remote
				// server will be saved in client when the proxied url was redirected to another one.
				// See issue [#51](https://github.com/mitre/HTTP-Proxy-Servlet/issues/51)
				copyResponseHeaders(aProxyResponse, theServletRequest, theServletResponse);
	
				if (statusCode == HttpServletResponse.SC_NOT_MODIFIED) 
				{
					// 304 needs special handling.  See:
					// http://www.ics.uci.edu/pub/ietf/http/rfc1945.html#Code304
					// Don't send body entity/content!
					theServletResponse.setIntHeader(HttpHeaders.CONTENT_LENGTH, 0);
				} 
				else 
				{
					// Send the content to the client
					copyResponseEntity(aProxyResponse, theServletResponse, aProxyRequest, theServletRequest);
				}
		    } 
		    catch (Exception e) 
		    {
		    	handleRequestException(aProxyRequest, e);
				
				// Once we understand that we can automatically recover from IllegalStateException,
				// we could send a "try again" HTTP Response Code to the Editor client. For now,
				// handleRequestException will throw even the IllegalStateException, which will be caught
				// and handled below (line 1191)
		    } 
		    finally 
		    {
		    	// make sure the entire entity was consumed, so the connection is released
		    	if (aProxyResponse != null)
		    		EntityUtils.consumeQuietly(aProxyResponse.getEntity());
		    	//Note: Don't need to close servlet outputStream:
		    	// http://stackoverflow.com/questions/1159168/should-one-call-close-on-httpservletresponse-getoutputstream-getwriter
		    }
		} catch (Exception e) {
			itsLog.error("Error making API request: "+e.getMessage(), e);
			ApiUtils.buildJsonErrorResponse(theServletResponse, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
		}
	}

	private void setXForwardedForHeader(HttpServletRequest theServletRequest, HttpRequest theProxyRequest) 
	{
		if (itsDoForwardIP) 
		{
			String forHeaderName = "X-Forwarded-For";
			String forHeader = theServletRequest.getRemoteAddr();
			String existingForHeader = theServletRequest.getHeader(forHeaderName);
			if (existingForHeader != null) 
			{
				forHeader = existingForHeader + ", " + forHeader;
			}
			theProxyRequest.setHeader(forHeaderName, forHeader);

			String protoHeaderName = "X-Forwarded-Proto";
			String protoHeader = theServletRequest.getScheme();
			theProxyRequest.setHeader(protoHeaderName, protoHeader);
		}
	}

	/**
	 * Note - we do not log GET requests. We are only interested in events that change data.
	 */
	private void logEventToKafka(HttpServletRequest theServletRequest) {
		String aMethod = theServletRequest.getMethod();
		if (itsIsKafkaEnabled && !aMethod.equalsIgnoreCase("GET")) {
			try {
				// payload is the API being called
				String aRequestUrl = theServletRequest.getRequestURI();
				String aQueryString = theServletRequest.getQueryString();
				String aFullRequestUrl = aRequestUrl;
				if(aQueryString != null && !aQueryString.isEmpty()) {
					aFullRequestUrl = aRequestUrl + "?" + aQueryString; 
				}
				String aCorrelationId = theServletRequest.getHeader("x-request-id");
				if (aCorrelationId == null) {
					// can't correlate request without correlation id
					throw new IllegalArgumentException("missing correlation id");
				}
				
				HttpSession aSession = theServletRequest.getSession(false);
				String aTenantId = (String) aSession.getAttribute(ViewerSecurityManager.TENANT_ID);
				if (aTenantId == null) {
					// can't log event without a tenant id as used to specify Kafka topic
					throw new IllegalArgumentException("missing tenant id");
				}
				String aUserEmail = (String) aSession.getAttribute(ViewerSecurityManager.USER_EMAIL);
				if (aUserEmail == null) {
					itsLog.warn("No email specified for user in session for event logging.");
					aUserEmail = EssentialEventNotification.VALUE_NOT_AVAILABLE;
				}
				String aUsername = (String) aSession.getAttribute(ViewerSecurityManager.USER_FULLNAME);
				if (aUsername == null) {
					itsLog.warn("No name specified for user in session for event logging.");
					aUsername = EssentialEventNotification.VALUE_NOT_AVAILABLE;
				}
				
				// context is the Viewer Form that made the API request
				String aFormId = theServletRequest.getHeader("x-form-id");
				if (aFormId == null) {
					itsLog.warn("No form id specified in headers for event logging.");
					aFormId = EssentialEventNotification.VALUE_NOT_AVAILABLE;
				}
				String aFormName = theServletRequest.getHeader("x-form-name");
				if (aFormName == null) {
					itsLog.warn("No form name specified in headers for event logging.");
					aFormName = EssentialEventNotification.VALUE_NOT_AVAILABLE;
				}
				
				// note - we use user's email as author id in event log
				Resource anAuthor = new Resource(ResourceType.USER, aUserEmail, aUsername);
				DomainEvent aDomainEvent = DomainEvent.REPOSITORY_FORMS__FORM_API_REQUEST;
				EssentialEventNotification anEvent = new EssentialEventNotification.Builder(aCorrelationId, aTenantId, anAuthor, aDomainEvent)
						.withContext(ResourceType.FORM, aFormId, aFormName)
						.withPayloadAttributeValues("method", aMethod)
						.withPayloadAttributeValues("url", aFullRequestUrl)
						.build();
					
				String aTopic = "essential-events.tenants." + aTenantId;
				itsProducer.send(new ProducerRecord<String, EssentialEventNotification>(aTopic, anEvent));
			} catch (Exception e) {
				// only log the exception, so service does not fail if cannot log to Kafka
				itsLog.warn("Unable to send Kafka event notification, reason: "+e.getMessage());
			}
		}
	}
	
}
