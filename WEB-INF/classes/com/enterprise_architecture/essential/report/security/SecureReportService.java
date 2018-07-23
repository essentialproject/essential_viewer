/**
 * Copyright (c)2015-2017 Enterprise Architecture Solutions ltd.
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
 */
package com.enterprise_architecture.essential.report.security;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.enterprise_architecture.essential.report.EasReportService;
import com.enterprise_architecture.essential.report.ViewerCacheManager;

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
	 * Default constructor
	 */
	public SecureReportService() 
	{
		// TODO Auto-generated constructor stub
	}

	/**
	 * Intercept the Post received from publishing clients and validate that the specified user
	 * is allowed to publish to Viewer. Looks for token in the request
	 */
	@Override
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse)
			  throws ServletException, IOException
	{	
		//System.out.println("SecureReportService: Doing secure ReportService");
		String aRepositoryURI = theRequest.getParameter(ViewerSecurityManager.REPOSITORY_ID_URL);
		String aUserURI = theRequest.getParameter(ViewerSecurityManager.USER_ACCOUNT_URL);		
		
		// Check Content Type, if multi-part form, then process parameters differently.
		String aContentType = theRequest.getContentType();
		//System.out.println("SecureReportService: Content Type: " + aContentType);
		
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
					List aRequestContentList = anUpload.parseRequest(theRequest);
					Iterator<FileItem> aContentListIt = aRequestContentList.iterator();
					while(aContentListIt.hasNext())
					{
						FileItem anItem = aContentListIt.next();
						String aParamName = anItem.getFieldName();
						if(aParamName.equals(ViewerSecurityManager.USER_ACCOUNT_URL))
						{
							aUserURI = anItem.getString();
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
					System.err.println("Exception encountered while parsing request for security parameters.");
					System.err.println(aFileUploadEx.getMessage());
					aFileUploadEx.printStackTrace(new PrintWriter(System.err));						
				}				
			}	 
		}
		else if(aContentType.contains(COMPRESSED_CONTENT_TYPE))
		{
			// Unsupported as we can't read the auth params
			System.err.println("Essential Report Service: Attempt to send invalid repository snapshot. Unsupported content type.");
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
		
		//System.out.println("SecureReportService: Read User URI from Request: " + aUserURI);
		//System.out.println("SecureReportService: Read Repository URI from Request: " + aRepositoryURI);
		
		// Got all the parameters of the request, now do authentication
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String anAccount = aSecurityMgr.authenticateUserByToken(theRequest, aUserURI);
			
		// Authenticated, so do authorisation
		if(anAccount != null)
		{
			//System.out.println("SecureReportService: User Authenticated by Token. Account = " + anAccount);
			
			if(aSecurityMgr.isUserAuthorisedForPublish(aUserURI, aRepositoryURI))
			{
				//System.out.println("SecureReportService: User authorised for repository: " + aRepositoryURI);
				
				// Authorised 
				boolean isSuccess = false;

				// Clear the pre-cache
				ViewerCacheManager aCacheManager = getCacheManager();
				boolean isCacheClear = clearCache(aCacheManager, ViewerCacheManager.CLEAR_BEFORE_RECEIVE_REPOSITORY);
				if(!isCacheClear)
				{
					System.err.println("EasReportService: Failed to clear cache before repository receive.");
				}
								
				// Based on content type, save the repository XML
				if(aContentType.contains(MULTIPART_FORM_CONTENT_TYPE))
				{
					// Save the XML
					// Test content type
					String aFileContentType = anXMLFile.getContentType();
					
					// Report the content type to aid with trouble shooting due to browser variation
					//System.out.println("Received File: Content Type = " + aFileContentType);
					
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
						if(isSuccess)
						{
							// Clear the post cache
							isSuccess = clearCache(aCacheManager, ViewerCacheManager.CLEAR_AFTER_RECEIVE_REPOSITORY);
						}
					}
					else
					{
						isSuccess = false;
					}
					
					// Delete the uploaded XML
					anXMLFile.delete();
				}
				else
				{
					// Save XML and clear the post-receive cache
					isSuccess = receiveModelSnapshot(aReceivedXML, aCacheManager);
				}
				
				// Return success or fail message
				if(isSuccess)
				{
					theResponse.setStatus(SUCCESS_STATUS);
					theResponse.sendRedirect(UPLOAD_SUCCESS_URL);
				}
				else
				{
					System.err.println("Essential Report Service: Error encountered while receiving repository snapshot.");
					theResponse.setStatus(ERROR_STATUS);
					theResponse.sendRedirect(UPLOAD_ERROR_URL);
				}				
			}
			else
			{
				//System.out.println("ACCESS DENIED - not authorised");
				theResponse.sendError(HttpServletResponse.SC_FORBIDDEN, NOT_AUTH_MESSAGE);
			}
		}
		else
		{
			//System.out.println("ACCESS DENIED - not authenticated");
			theResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, NOT_AUTHENTICATED_MESSAGE);
		}
		
	}
}
