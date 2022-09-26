/**
 * Copyright (c)2020-2021 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 25.03.2020	JWC	First implementation of open source Report API
 * 19.03.2021	JWC Added code to set permissions on cached files as they are written
 *
 */
package com.enterprise_architecture.essential.report;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermission;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.TransformerFactoryImpl;
import net.sf.saxon.om.TreeInfo;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.essential.report.api.ApiErrorMessage;
import com.enterprise_architecture.essential.report.precache.PreCacheList;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Class to manage the generation of Report APIs - or "Data Views"
 * Only produces JSON documents
 * @author Jonathan W. Carter
 *
 */
public class ReportAPIEngine
{
	protected ServletContext itsServletContext = null;

	protected static final String XML_FILENAME = "reportXML.xml";

	private static final Logger itsLog = LoggerFactory.getLogger(ReportAPIEngine.class);

	private static final int MAX_THREAD_POOL_SIZE = 2;

	private static final String PRE_CACHE_QUERY_XSL_FILENAME = "common/api/core_precache_reportAPI.xsl";

	private static final String REPORT_API_NOT_FOUND = "Requested Report API not found";

	private ExecutorService itsExecutor = null;

	Set<PosixFilePermission> itsPermissionSet = null;

	/**
	 * Location of the cache - on disk. Initialise to a sensible default
	 */
	private String itsCacheDirectory = "/platform/tmp/reportApiCache";
	private static final String REPORT_API_CACHE_LOCATION = "reportAPICacheLocation";

	/**
	 * Default Constructor
	 */
	public ReportAPIEngine(ServletContext theContext)
	{
		// Set the Servlet context variables
		itsServletContext = theContext;

		// Create a PosixFilePermission set for cache file permissions
		createPermissionSet();

		// Read the context parameter and decide whether to set the page history tracking on or off
		itsCacheDirectory = itsServletContext.getInitParameter(REPORT_API_CACHE_LOCATION);
		itsLog.debug("ReportAPIEngine constructor: Cache location: {}", itsCacheDirectory);

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
	 * Generate the requested Report API View. If we have it in the cache, simply pull it from
	 * the cache and write the JSON to the StringWriter. Otherwise, call the EssentialViewerEngine
	 * to render the JSON, add it to the cache and then return it
	 *
	 * @param theRequest
	 * @param theResponse
	 * @param theViewerEngine
	 * @param aStreamResult
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	public boolean generateReportAPI(HttpServletRequest theRequest,
									 HttpServletResponse theResponse,
									 EssentialViewerEngine theViewerEngine,
									 StringWriter theResultString) throws ServletException, IOException
	{
		boolean isSuccess = true;

		// Get the requested View from the XSL parameter
		String aRequestedView = ScriptXSSFilter.filter(theRequest.getParameter("XSL"));
		itsLog.debug("Requested Report API: {}", aRequestedView);

		// Cached name flattens folders into a single folder, using '.' to namespace
		String aCachedApiName = aRequestedView.replace('/', '.');
		itsLog.debug("Searching for cached Report API: {}", aCachedApiName);

		// Look for the requested Report API in the cache
		String aCachedJSON = findCachedReportApi(aCachedApiName);

		if(aCachedJSON == null)
		{
			itsLog.debug("No cached Report API found. Rendering: {}", aCachedApiName);
			// If not found, use the Viewer to render the JSON, using the un-filtered renderView() method
			StringWriter aRenderedView = new StringWriter();
			boolean isReportApiRendered = theViewerEngine.renderView(theRequest, theResponse, aRenderedView);
			itsLog.debug("Requested rendering of Report API. Result: {}", isReportApiRendered);
			if(isReportApiRendered)
			{
				// Save the computed Report API JSON to the cache
				String aRenderedJson = aRenderedView.toString();
				itsLog.debug("Saving rendered View to cache, {} characters", aRenderedJson.length());
				writeToCache(aCachedApiName, aRenderedJson);
				theResultString.write(aRenderedJson);
			}
			else
			{
				// Handle any errors - e.g. can't find requested XSL
				itsLog.debug("Report API not rendered");
				ApiErrorMessage anErrorMessage = new ApiErrorMessage(0, REPORT_API_NOT_FOUND);
				String anErrorResponse = writeErrorJson(anErrorMessage);
				itsLog.debug("Error message: {}", anErrorResponse);
				theResultString.write(anErrorResponse);
				isSuccess = false;
			}
		}
		else
		{
			// write the cached JSON to theResultString
			theResultString.write(aCachedJSON);
		}

		return isSuccess;
	}

	/**
	 * Clear the cache, e.g. when a new repository snapshot has been received
	 *
	 */
	public void resetCache()
	{
		itsLog.debug("Clearing the cache");
		String aRealPathToCache = itsServletContext.getRealPath(itsCacheDirectory);
		try
		{
			File aCacheDirectory = new File(aRealPathToCache);
			FileUtils.cleanDirectory(aCacheDirectory);
		}
		catch(Exception anEx)
		{
			itsLog.error("Exception encountered when clearing Report API cache: {}", anEx.toString());
		}
		itsLog.debug("Cache cleared");

		// Now pre-cache specific elements
		preCacheReportAPIs();
	}

	/**
	 * Search the cache for a Report API with the supplied name
	 * @param theCachedReportApi the name of the report API requested
	 * @return the content of the cached Report API or null if not in the cache
	 */
	protected String findCachedReportApi(String theCachedReportApi)
	{
		// Look in the cache for the requested Report API
		String aCacheApiPath = itsCacheDirectory + theCachedReportApi;
		String aCacheApiContent = null;
		itsLog.debug("Looking for cached file: {}", aCacheApiPath);
		InputStream anInStream = null;

		try
		{
			anInStream = itsServletContext.getResourceAsStream(aCacheApiPath);
			itsLog.debug("Got input stream. Available bytes: {}", anInStream.available());
			ByteArrayOutputStream anOutStream = new ByteArrayOutputStream();
			int aByteCount = IOUtils.copy(anInStream, anOutStream);
			if(aByteCount > 0)
			{
				aCacheApiContent = anOutStream.toString("UTF-8");
			}
		}
		catch (Exception anEx)
		{
			itsLog.debug("IOException Report API: {}, not in cache. Exception: {}", aCacheApiPath, anEx);
		}
		finally
		{
			if(anInStream != null)
			{
				try
				{
					anInStream.close();
				}
				catch (Exception anEx)
				{
					itsLog.error("Error encountered closing the file system stream: " + anEx.getMessage());
				}
			}
		}
		return aCacheApiContent;
	}

	/**
	 * Get the list of Report APIs that have been identified for pre-caching and iterate through
	 * them, generating each. Reads the is_data_set_api_precached slot on each Data_Set_API instance and
	 * only pre-caches those with this slot set to true.
	 *
	 */
	protected void preCacheReportAPIs()
	{
		// Read the current XML snapshot - we'll read this to get the list of Report APIs to pre-cache
		PreCacheList aPreCacheList = getPreCacheList(XML_FILENAME, PRE_CACHE_QUERY_XSL_FILENAME);

		// Iterate through the pre-cache list
		Iterator<String> aPreCacheIt = aPreCacheList.getPreCacheApis().iterator();
		while(aPreCacheIt.hasNext())
		{
			// Request each Report API View
			String aReportAPI = aPreCacheIt.next();
			ReportAPIRequestor anApiRequestor = new ReportAPIRequestor();
			anApiRequestor.setItsXML(XML_FILENAME);
			anApiRequestor.setItsXSL(aReportAPI);
			itsLog.debug("Created ReportAPIRequestor for Report API: {}", aReportAPI);
			itsLog.debug("Submitting...");
			itsExecutor.submit(anApiRequestor);
		}
	}

	/**
	 * Write the ApiErrorMessage to a string that can be returned to a client
	 * @param theApiErrorMessage
	 * @return String-ified rendering of the ApiErrorMessage
	 */
	protected String writeErrorJson(ApiErrorMessage theApiErrorMessage)
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

	/**
	 * Save theNewJson in the cache
	 * @param theCachedName the unique name of the Report API
	 * @param theNewJson the result content of the Report API
	 */
	protected void writeToCache(String theCachedName, String theNewJson)
	{
		String aRealPathToCache = itsServletContext.getRealPath(itsCacheDirectory);
		String aCacheApiPath = aRealPathToCache + theCachedName;
		itsLog.debug("Writing to cache: {}. Size: {}", theCachedName, theNewJson.length());

		try
		{
			// Open a file in the cache for theCachedName
			itsLog.debug("Cache file: {}", aCacheApiPath);
			File aCachedFile = new File(aCacheApiPath);
			ByteArrayInputStream aJsonByteStream = new ByteArrayInputStream(theNewJson.getBytes());

			// Write theNewJson content into this file
			FileUtils.copyInputStreamToFile(aJsonByteStream, aCachedFile);
			
			// Set the permissions to 777, so that ReportAPI API can clear them
			setFilePermissions(aCacheApiPath);
		}
		catch(Exception anEx)
		{
			itsLog.error("Could not write to Report API cache: {}. Details: {}", theCachedName, anEx.getMessage());
		}
	}

	/**
	 * Create the Permission set for cache files - do this once!
	 */
	private void createPermissionSet()
	{
		itsPermissionSet = new HashSet<>();
		itsPermissionSet.add(PosixFilePermission.OWNER_READ);
		itsPermissionSet.add(PosixFilePermission.OWNER_WRITE);
		itsPermissionSet.add(PosixFilePermission.OWNER_EXECUTE);

		itsPermissionSet.add(PosixFilePermission.GROUP_READ);
		itsPermissionSet.add(PosixFilePermission.GROUP_WRITE);
		itsPermissionSet.add(PosixFilePermission.GROUP_EXECUTE);

		itsPermissionSet.add(PosixFilePermission.OTHERS_READ);
		itsPermissionSet.add(PosixFilePermission.OTHERS_WRITE);
		itsPermissionSet.add(PosixFilePermission.OTHERS_EXECUTE);
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
				//DocumentInfo anXMLSource = aViewerEngine.getXMLSourceDocument(tFactory, anXMLParameter, aFactoryErrorListener);
				TreeInfo anXMLSource = aViewerEngine.getXMLSourceDocument(tFactory, anXMLParameter, aFactoryErrorListener);
				transformer.transform(anXMLSource, new StreamResult(aResultString));
			}
			// Absorb any exceptions that are caught - log it but otherwise no action taken
			catch (Exception anEx)
			{
				// Handle the error message properly.
				itsLog.error("Unmanaged exception caught when creating pre-cache Report API list : {}", anEx);
			}
		}
		catch(Exception anEx)
		{
			// Handle the error message properly.
			itsLog.error("Unmanaged exception caught when creating pre-cache Report API list : {}", anEx);
		}
		String aResultJson = aResultString.toString();
		itsLog.debug("Returned JSON: {}", aResultJson);

		return aResultJson;
	}

	/**
	 * Make a request to get the set of Report API to pre-cache
	 * @param theXMLParameter
	 * @param theXSLParameter
	 * @return
	 */
	private PreCacheList getPreCacheList(String theXMLParameter, String theXSLParameter)
	{
		String aPreCacheJson = getPreCacheJson(theXMLParameter, theXSLParameter);
		PreCacheList aPreCacheList = null;

		try
		{
			ObjectMapper aMapper = new ObjectMapper();
			aPreCacheList = (PreCacheList) aMapper.readValue(aPreCacheJson, PreCacheList.class);
		}
		catch(Exception anEx)
		{
			itsLog.error("Error reading the pre-cache configuration: {}", anEx.getMessage());
		}
		return aPreCacheList;
	}

	/**
	 * Ensure that any cached file is available to read/write/execute by both Viewer
	 * and this ReportAPI Service
	 * 
	 * @param theFilePath
	 */
	private void setFilePermissions(String theFilePath)
	{
		try
		{
			Path aPath = Paths.get(theFilePath);
			Files.setPosixFilePermissions(aPath, itsPermissionSet);
		}
		catch(Exception anException)
		{
			// E.g. attempt to do this on Windows will throw exception - but that's OK
			itsLog.debug("Failed to create cache file permissions. Exception: {}", anException);
		}
	}

	/**
	 * Inner class that runs in an ExecutorService thread pool
	 */
	class ReportAPIRequestor implements Runnable
	{
		String itsXML = "";
		String itsXSL = "";


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

		@Override
		public void run()
		{
			// Using the defined parameters, call the getPreCacheJson() method
			String aReportAPIJson = getPreCacheJson(itsXML, itsXSL);

			// Save the Json in the cache
			String aCachedApiName = itsXSL.replace('/', '.');
			writeToCache(aCachedApiName, aReportAPIJson);
		}
	}
}
