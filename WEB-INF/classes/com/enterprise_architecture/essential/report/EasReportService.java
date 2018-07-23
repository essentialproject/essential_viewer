/**
 * Copyright (c)2006-2017 Enterprise Architecture Solutions Ltd.
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
 * 07.11.2006	JWC	1st coding.
 * 06.11.2008	JWC	version 2 to improve memory use during processing of model snapshot.
 * 10.11.2008	JWC	Added checks on saved file to ensure that it was completely saved
 * 27.04.2009	JWC	Javadoc typo fixed.
 * 30.05.2009	JWC	Changed the response status codes to use standard HTTP OK and INTERNAL SERVER ERROR
 * 					Fixes problem with using Apache webserver in front of the web application server.
 * 23.10.2009	JWC	Updated to receive compressed report XML from the EasReportTab
 * 08.06.2010	JWC	Added a check for a NULL pointer on the content type of the request and re-direct
 * 					to the bad request page of Essential Viewer. This handles situations such as when
 * 					a user makes a request to this servlet from a browser, directly.
 * 11.11.2011	JWC Clear the cache on the UML Image rendering tools.
 * 15.11.2011	JWC	Re-worked cache clearing to include XML TransformerFactory and parsed XML document.
 * 					Replaced the itsReceivedXML member variable with local variables.
 * 25.06.2013	JWC Added ability to POST Zipped files to the Report Service
 * 04.07.2013	JWC Re-worked writing of file received via POST of Zipped / raw XML
 * 08.02.2017	JWC Remove trace code
 */
package com.enterprise_architecture.essential.report;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.zip.GZIPInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

/**
 * EAS Report Service provides the interface to the EA reporting capabilities 
 * of the EAS EA Framework - Essential Architecture Manager.
 * The service receives an XML document via HTTP from a EasReportTab Tab Widget in a
 * Protege project containing the current knowledgebase for that project.
 * Since version 2.2 of the EasReportService, the knowledgebase XML is transmitted in 
 * compressed form, using GZIP to compress the XML. <br>
 * To use the service, compress the XML using GZIP and send the resulting binary in the POST message,
 * setting the content type to "binary/octet-stream".
 * <br>
 * Alternatively, for backwards compatibility with Essential Widgets up to and including
 * version 2.2, you can use this service, by sending an HTTP POST with the following parameters
 * <ul>
 * <li>"action" = "report"</li>
 * <li>"kbXML" = &lt;XML document describing your Protege knowledge base&gt;</li>
 * </ul>
 * The "outputReportFile" servlet configuration parameter (in the web.xml file) 
 * specifies the location where the received and processed XML document will
 * be written by the service - ready to be processed by the reporting tools.
 * 
 * @author Jonathan W. Carter <info@enterprise-architecture.com>
 * @version 2.2		Re-worked to receive compressed report XML from the EasReportTab. <br>
 * <br>
 * @version 2.3		Handle bad servlet requests and re-direct to Essential Viewer bad URL page.<br/>
 * <br/>
 * @version 2.4		When a new snapshot of the repository is received successfully, clear down the UML image cache if it exists<br/>
 * <br/>
 * @version 3.0 	Clear generic cache, controlled by XML config, including XML TransformerFactory and cached XML document.
 * <br/>
 * @version 3.1 	Added ability to receive POST of multipart/form-data type containing Zip file. Large Zip files are received, using the folder controlled
 * by the 'uploadTempStore' folder servlet param in web.xml
 * <br/>
 * @version 3.2		Reworked the saving of the file received in multipart/form-data
 */
public class EasReportService extends HttpServlet 
{
	private final static String REPORT_FILE_PARAM = "outputReportFile";
	protected final static String ACTION_PARAM = "action";
	protected final static String REPORT_ACTION = "report";
	protected final static String XML_REQUEST_PARAM = "kbXML";
	/**
	 * The name of the servlet init param that contains the name of the cache config XML file
	 * @since 3.0
	 */
	private static final String THE_CACHE_CONFIG_PARAM = "cacheConfig";
	
	/**
	 * The name of the servlet init param that contains the name of the folder to use as the upload
	 * temporary store.
	 */
	private static final String UPLOAD_TEMP_CONFIG_PARAM = "uploadTempStore";
	
	// 30.05.2009 JWC	Changed to use standard HTTP codes.
	protected final static int ERROR_STATUS = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
	protected final static int SUCCESS_STATUS = HttpServletResponse.SC_OK;
	
	// 22.10.2009 JWC	Added to support compressed requests.
	protected final static String COMPRESSED_CONTENT_TYPE = "binary/octet-stream";
	
	/**
	 * Content type for posted form data
	 */
	protected final static String MULTIPART_FORM_CONTENT_TYPE = "multipart/form-data";
	
	/**
	 * Content type for a Zip archive
	 */
	protected final static String ZIPFILE_CONTENT_TYPE = "application/zip";
	
	/**
	 * Alternative pattern to find zip file content type for browsers that don't use standard type
	 */
	protected final static String ALT_ZIP_CONTENT_TYPE = "zip";
	
	/**
	 * Finally, another alternative to check for ZIP in POSTed multipart/form-data payload
	 */
	protected final static String ASSUME_ZIP_CONTENT_TYPE = "octet";
	
	/**
	 * Content type for un-compressed XML
	 */
	protected final static String XML_CONTENT_TYPE = "text/xml";
	
	// 08.06.2010 JWC	Added to handle NULL pointer exceptions from no content type set in request,
	// e.g. when a browser makes a request to this service.
	protected final static String BAD_REQUEST_REDIRECT_URL = "report?XML=reportXML.xml&XSL=platform/badurl.xsl";
	
	protected final static String UPLOAD_SUCCESS_URL = "platform/postXMLFormSuccess.html";
	
	protected final static String UPLOAD_ERROR_URL = "platform/postXMLFormError.html";
	
	/**
	 * The name of the XML file to save the repository snapshot to.
	 */
	private String itsOutputFileLocation = "";	
	
	/**
	 * The name of the UML image cache directory to clear down
	 * @since 2.4
	 */
	private String itsCacheConfigurationFile = "";
	
	/**
	 * The name of the temporary folder to use when receiving an uploaded XML report file.
	 * Default value is overridden by the servlet init param #UPLOAD_TEMP_CONFIG_PARAM
	 * @since 3.1
	 */
	protected String itsUploadTempFolder = "/platform/tmp";
	
	/**
	 * File size upper limit (before using temp folder) to use.
	 * @since 3.1
	 */
	public static final long UPLOAD_LIMIT_SIZE = 536870912L;
	
	/**
	 * Memory threshold for uploading content
	 * @since 3.1
	 */
	public static final int MEMORY_THRESHOLD_SIZE = 102400;
	
	// Protected member variable to hold a single copy of the model received to reduce
	// memory requirements. Protected to allow subclasses to operate on it.
	//protected String itsReceivedXML = "";
	
	/**
	 * Override the initialisation and initialise the service
	 */
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		
		// Get the configuration properties
		itsOutputFileLocation = getServletConfig().getInitParameter(REPORT_FILE_PARAM);
		itsCacheConfigurationFile = getServletConfig().getInitParameter(THE_CACHE_CONFIG_PARAM);
		itsUploadTempFolder = getServletConfig().getInitParameter(UPLOAD_TEMP_CONFIG_PARAM);
	}

	/**
	 * Passes a GET on to the POST method, as the service expects to receive
	 * an XML document.
	 * @param theRequest the request message
	 * @param theResponse the response message
	 * @exception ServletException when a servlet exception occurs
	 * @exception IOException in the event of an IOException
	 */
	protected void doGet(HttpServletRequest theRequest, HttpServletResponse theResponse)
			  throws ServletException, IOException 
	{		
	
		//forward all GET requests to doPost()
		this.doPost(theRequest, theResponse);
	}
	
	/**
	 * Receive the service request and read the XML document that is 
	 * in the request. From version 2.2 of this code, if the content type received is "binary/octet-stream"
	 * then uncompress the received request before processing it. The test for compressed
	 * content is performed first and if the content type is not binary, this service assumes
	 * compatibility mode, to receive a request from Essential Widgets version 2.2 and earlier
	 * @param theRequest the request message containing the XML document
	 * @param theResponse the response message sent back to the service client.
	 * @exception ServletException when an exception within the Servlet environment
	 * occurs
	 * @exception IOException in the event of an IOException. However, if the
	 * service fails to save the XML report sent to it by clients, an exception
	 * is not raised. Rather the error message is written to StdErr
	 * @since 3.0 includes Viewer cache management.
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse)
			  throws ServletException, IOException
	{	
		// 14.11.2011 JWC - Perform any pre-receive cache clearing that might be required	
		ViewerCacheManager aCacheManager = getCacheManager();
		String aReceivedXML = "";
		
		boolean isCacheClear = clearCache(aCacheManager, ViewerCacheManager.CLEAR_BEFORE_RECEIVE_REPOSITORY);
		if(!isCacheClear)
		{
			System.err.println("EasReportService: Failed to clear cache before repository receive.");
		}
		
		// 22.10.2009 JWC - Check for compressed request and if so, uncompress the request
		// before processing
		String aContentType = theRequest.getContentType();
		
		// Report the content type to aid with trouble shooting due to browser variation
		//System.out.println("Received POST: Content Type = " + aContentType);
		
		// 08.06.2010 JWC - Check we haven't got a NULL pointer on the Content Type
		if(aContentType == null)
		{
			// Then this is a bad request - redirect the request to the Essential Viewer BAD URL page
			theResponse.sendRedirect(BAD_REQUEST_REDIRECT_URL);
			return;
		}
		// end of 08.06.2010 JWC addition
		
		if(aContentType.equals(COMPRESSED_CONTENT_TYPE))
		{
			// The request is a compressed XML document
			// Stream theRequest into a String via the GZIPInputStream
			GZIPInputStream aDecompressFilter = null;
			ObjectInputStream anObjectIn = null;
			
			synchronized(theRequest)
			{
				try
				{
					// Trace
					aDecompressFilter = new GZIPInputStream(theRequest.getInputStream());
					anObjectIn = new ObjectInputStream(aDecompressFilter);
					
					// Read the un-compressed XML from the Object.
					aReceivedXML = (String)anObjectIn.readObject();
										
					if(receiveModelSnapshot(aReceivedXML, aCacheManager))
					{
						theResponse.setStatus(SUCCESS_STATUS);	
					}
					else
					{
						theResponse.setStatus(ERROR_STATUS);
					}
				}
				catch(IOException anIOEx)
				{
					System.err.println("Exception encountered while de-compressing received XML.");
					System.err.println(anIOEx.getMessage());
					anIOEx.printStackTrace(new PrintWriter(System.err));
					theResponse.setStatus(ERROR_STATUS);
				}	
				catch(ClassNotFoundException aClassEx)
				{
					System.err.println("Exception encountered while de-compressing received XML.");
					System.err.println(aClassEx.getMessage());
					aClassEx.printStackTrace(new PrintWriter(System.err));	
					theResponse.setStatus(ERROR_STATUS);
				} 
				finally
				{
					// Release the streaming resources for the de-compress
					if(aDecompressFilter != null)
					{
						aDecompressFilter.close();
					}
					if(anObjectIn != null)
					{
						anObjectIn.close();
					}
				}
			}
		}
		else if(aContentType.contains(MULTIPART_FORM_CONTENT_TYPE))
		{
			boolean isSuccess = false;
			
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
			
			// Process the upload
			synchronized(theRequest)
			{
				try
				{
					// Test the content type and handle accordingly
					List anXMLFileList = anUpload.parseRequest(theRequest);
					Iterator<FileItem> anXMLListIt = anXMLFileList.iterator();
					while(anXMLListIt.hasNext())
					{
						FileItem aFile = anXMLListIt.next();
						String aParamName = aFile.getFieldName();
						if(aParamName.equals(XML_REQUEST_PARAM))
						{
							// Test content type
							String aFileContentType = aFile.getContentType();
							
							// Report the content type to aid with trouble shooting due to browser variation
							//System.out.println("Received File: Content Type = " + aFileContentType);
							
							// Look for ZIP content type - handle less standard browsers
							if(aFileContentType.equals(ZIPFILE_CONTENT_TYPE) ||
									aFileContentType.contains(ALT_ZIP_CONTENT_TYPE) ||
									aFileContentType.contains(ASSUME_ZIP_CONTENT_TYPE))
							{
								// Handle a ZIP file
								ZipInputStream aZipInStream = new ZipInputStream(aFile.getInputStream());
								
								// Stream the ZipInStream into a String.
								// Get the ZIP file XML content
								isSuccess = savePostedFile(aZipInStream);
								aZipInStream.close();									
							}
							else if(aFileContentType.equals(XML_CONTENT_TYPE))
							{
								// Handle uncompressed XML
								isSuccess = savePostedFile(aFile);
							}
							else
							{
								isSuccess = false;
							}
							
							// Tidy up and clear cache if receive was successful
							if(isSuccess)
							{
								isSuccess = clearCache(aCacheManager, ViewerCacheManager.CLEAR_AFTER_RECEIVE_REPOSITORY);		
							}
							aFile.delete();
						}
					}
				}
				catch(FileUploadException aFileUploadEx)
				{
					System.err.println("Exception encountered while parsing request to receive uploaded XML report snapshot.");
					System.err.println(aFileUploadEx.getMessage());
					aFileUploadEx.printStackTrace(new PrintWriter(System.err));	
					isSuccess = false;
				}
				catch(Exception aWritingEx)
				{
					System.err.println("Exception encountered while writing received XML file.");
					System.err.println(aWritingEx.getMessage());
					aWritingEx.printStackTrace(new PrintWriter(System.err));	
					isSuccess = false;
				}
				if(isSuccess)
				{
					theResponse.setStatus(SUCCESS_STATUS);
					theResponse.sendRedirect(UPLOAD_SUCCESS_URL);
				}
				else
				{
					System.err.println("Essential Report Service: Attempt to send invalid repository snapshot. Unsupported content type.");
					theResponse.setStatus(ERROR_STATUS);
					theResponse.sendRedirect(UPLOAD_ERROR_URL);
				}
			}	 
		}
		else
		{
			// Compatibility mode - non compressed, POST parameters
		
			// Read the action
			String anAction = theRequest.getParameter(ACTION_PARAM);
					
			// If the action is "report"
			if((anAction != null) && anAction.equals(REPORT_ACTION))
			{
				// Read the message payload - the XML
				// Do this synchronized to ensure process completes atomically.
				synchronized(theRequest) 
				{
					aReceivedXML = theRequest.getParameter(XML_REQUEST_PARAM);
				
					if(receiveModelSnapshot(aReceivedXML, aCacheManager))
					{
						theResponse.setStatus(SUCCESS_STATUS);	
					}
					else
					{
						theResponse.setStatus(ERROR_STATUS);
					}
				}
			}
		}
		return;
	}
	
	/**
	 * Save the XML representation of the EA repository/knowledgebase
	 * to the location specified by the REPORT_FILE_PARAM configuration
	 * parameter. The received model snapshot is the source XML document 
	 * containing the EA repository / Protege knowledgebase.
	 * A check to compare the size of the received XML to the size of the saved file
	 * is made to ensure that the complete snapshot is saved successfully.
	 * v2.0	06.11.2008	JWC revised to use member variable
	 * @param theReceivedXML a String containing the XML document that was received from the client.
	 * @return true if theReportSource was successfully saved. False otherwise
	 * @since 3.0 15.11.2011 JWC revised to use method parameter to ensure thread-safe
	 */
	protected synchronized boolean saveReportSource(String theReceivedXML)
	{
		boolean isSuccess = false;
		
		// Open a file to save to.
		try
		{
			String aRealFile = this.getServletContext().getRealPath(itsOutputFileLocation);
			FileWriter aFile = new FileWriter(aRealFile);
						
			try
			{
				// Write the XML document
				aFile.write(theReceivedXML);
			}	
			finally
			{
				// Close the file
				aFile.close();
				
				// Check file size = received XML size.
				File aWrittenFile = new File(aRealFile);
				long aWrittenFileLength = aWrittenFile.length();
				if(aWrittenFileLength == theReceivedXML.length())
				{
					isSuccess = true;
				}
				else
				{
					isSuccess = false;
				}
			}
		}
		catch (IOException ioEx)
		{
			System.err.println("Exception opening/writing EA repository source file");
			System.err.println(ioEx.getMessage());
			ioEx.printStackTrace(new PrintWriter(System.err));
		}
		
		return isSuccess;
	}
	
	/**
	 * Process the received XML document as required by operating on the 
	 * itsReceivedXML attribute of this class.
	 * Currently, this does nothing, but overriding this method
	 * allows pre-processing of the XML before it is saved.
	 * @param theReceivedXML a String containing the XML document that was received from the client.
	 * @since 3.0 with String parameter
	 */
	protected void processXML(String theReceivedXML)
	{
		// Currently do nothing	
	}
	
	/**
	 * Receive the snapshot of the model and send it to be 
	 * processed, and then saved. Synchronized at this level to 
	 * ensure that the complete model snapshot processing is completed atomically.
	 * v2.0  06.11.2008 JWC
	 * @param theReceivedXML a String containing the XML document that was received from the client.
	 * @param theCacheManager the Viewer Cache Manager that is being used. This is called to clear the 
	 * Viewer cache when this method has completed receiving the XML Model snapshot.
	 * @return true if receiving process completed properly, false if there was a 
	 * failure.
	 * @since v3.0 15.11.2011 JWC with new parameters String and ViewerCacheManager
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager ViewerCacheManager
	 */
	protected boolean receiveModelSnapshot(String theReceivedXML, ViewerCacheManager theCacheManager)
	{
		boolean isSuccess = false;
		if(theReceivedXML != null)
		{
			// Process the XML as required
			processXML(theReceivedXML);
			
			// Save it to the configured location
			if(saveReportSource(theReceivedXML))
			{
				isSuccess = true;	
			}
			else
			{
				isSuccess = false;
			}
		}
		
		// Clear the member variable to reset it and free memory
		theReceivedXML = new String();
		
		// 11.11.2011 JWC - Clear the cache
		if(isSuccess)
		{
			isSuccess = clearCache(theCacheManager, ViewerCacheManager.CLEAR_AFTER_RECEIVE_REPOSITORY);		
		}
		
		return isSuccess;
	}
	
	/**
	 * Clear the cache. The contents to be cleared are defined in the XML document
	 * that is identified by the THE_CACHE_CONFIG_PARAM.
	 * @param theCacheManager the Viewer Cache Manager that is being used. This is called to clear the 
	 * Viewer cache when this method has completed receiving the XML Model snapshot. 
	 * @param thePreOrPost defines whether the cache is being cleared before or after the 
	 * XML repository snapshot has been received. Uses CLEAR_AFTER_RECEIVE_REPOSITORY 
	 * or CLEAR_BEFORE_RECEIVE_REPOSITORY
	 * @return true on success or false if the cache was not cleared successfully.
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_AFTER_RECEIVE_REPOSITORY CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_BEFORE_RECEIVE_REPOSITORY CLEAR_BEFORE_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager ViewerCacheManager
	 * @since 3.0
	 */
	protected synchronized boolean clearCache(ViewerCacheManager theCacheManager, String thePreOrPost)
	{
		boolean isSuccess = false;
		
		ServletContext aContext = getServletContext();
		ViewerCacheManager aCacheManager = theCacheManager;
		
		// If it hasn't been created, create the Cache Manager
		if(aCacheManager == null)
		{
			aCacheManager = getCacheManager();
		}
		
		// Clear the cache
		isSuccess = aCacheManager.clearCache(aContext, thePreOrPost);
		if(!isSuccess)
		{
			System.err.println("EasReportService: Could not clear Essential Viewer Cache successfully.");
		}
		
		return isSuccess;
	}
	
	/**
	 * Get a new instance of a the Viewer Cache Manger. This method manages streaming the source XML
	 * configuration file to the ViewerCacheManager
	 * @return ViewerCacheManager the cache manager object initialised with the cache configuration.
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager ViewerCacheManager
	 */
	protected ViewerCacheManager getCacheManager()
	{
		// Find the name of the config file, with its full path
		String aConfigFile = getServletContext().getRealPath(itsCacheConfigurationFile);
		ViewerCacheManager aCacheManager = null;
		try
		{						
			// Open a File stream for the configuration and send it to the constructor for the cache manager
			FileInputStream anInStream = new FileInputStream(aConfigFile);				
			aCacheManager = new ViewerCacheManager(anInStream);				
		}
		catch (FileNotFoundException aFileNotFound)
		{
			// Just report an error - this is not a fatal error for the EasReportService
			System.err.println("EasReportService: Could not find cache configuration file: " + aConfigFile);
		}
		
		return aCacheManager;
	}
	
	/**
	 * Save a compressed repository snapshot received via the multipart/form-data 
	 * POST approach
	 * 
	 * @param theZipInStream handle to the ZipInputStream to read the received Zip file
	 * @return true on success, false if any problems were encountered
	 * @since 3.2
	 */
	protected synchronized boolean savePostedFile(ZipInputStream theZipInStream)
	{
		boolean isSuccess = false;
		
		// Stream the posted file and uncompress to file
		try
		{
			String aRealFile = this.getServletContext().getRealPath(itsOutputFileLocation);
			FileOutputStream anOutFileStream = new FileOutputStream(aRealFile);
			ZipEntry aZipEntry = theZipInStream.getNextEntry();
			
			IOUtils.copyLarge(theZipInStream, anOutFileStream);
			isSuccess = true;
		}
		catch(IOException anXMLFileEx)
		{
			// Catch and report IO Exception reading update script file
			System.err.println("Essential Report Service: IO Exception while reading received Zip archive. Details:");
			System.err.println(anXMLFileEx.toString());
			isSuccess = false;
		}
		catch(NullPointerException anNPE)
		{
			System.err.println("Essential Report Service: Exception reading received Zip archive. Details:");
			System.err.println(anNPE.toString());
			isSuccess = false;
		}
		catch(Exception anZipFileEx)
		{
			// Catch and report any other Exception reading update script file
			System.err.println("Essential Report Service: Exception reading received Zip archive. Details:");	
			System.err.println(anZipFileEx.toString());
			isSuccess = false;
		}
		
		return isSuccess;
		
	}
	
	/**
	 * Save an uncompressed repository snapshot received via the multipart/form-data 
	 * POST approach
	 * @param theUncompressedItem the posted element received by the report service
	 * @return true if received and saved successfully. false in the case of any errors
	 * @since 3.2
	 */
	protected synchronized boolean savePostedFile(FileItem theUncompressedItem)
	{
		boolean isSuccess = false;
		
		// Open a file to save to.
		try
		{
			String aRealFile = this.getServletContext().getRealPath(itsOutputFileLocation);
			File aFile = new File(aRealFile);
				
			theUncompressedItem.write(aFile);
			isSuccess = true;
		}
		catch (Exception ioEx)
		{
			System.err.println("Exception writing EA repository source file");
			System.err.println(ioEx.getMessage());
			ioEx.printStackTrace(new PrintWriter(System.err));
			isSuccess = false;
		}		
		
		return isSuccess;
	}
	
}

