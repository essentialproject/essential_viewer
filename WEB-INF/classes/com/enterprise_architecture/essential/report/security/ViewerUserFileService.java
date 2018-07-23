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
 * 19.05.2015	JWC	First coding
 * 17.05.2016	JWC Fixed issue with authZ - make sure to check full URL
 * 25.11.2016	JWC Added new parameter to doPost to create a specified folder 
 * 08.02.2017	JWC	Set file permissions on uploaded files
 * 09.05.2017	JWC Removed setting the file permissions on uploaded files as it caused errors
 */
package com.enterprise_architecture.essential.report.security;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.web.util.UriUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * ViewerUserFileService: REST-based Web Service to provide access to the user-defined files of Essential Viewer. Any file / folder
 * added to the /user folder can be interrogated, updated, added or deleted, using the GET (get details), POST (upload new
 * files), PUT (rename existing file / folder), DELETE (remove the file or folder). 
 * Servlet implementation class ViewerUserFileService
 * 
 */
public class ViewerUserFileService extends HttpServlet 
{
	/**
	 * Code version tracking ID
	 */
	protected static final long serialVersionUID = 1L;
	
	/**
	 * The root folder of the filesystem as provided by this service. Limited to the user folder 
	 */
	protected static final String itsRootFolder = "/user";
	
	/**
	 * Alternative name for the root folder as presented in response messages
	 */
	protected static final String ROOT_FOLDER_NAME = "Home";
	
	/**
	 * Temporary upload folder for the upload of content via POST method 
	 */
	protected String itsUploadTempFolder = "/platform/tmp";
	
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
	
	/**
	 * File size upper limit (before using temp folder) to use.
	 * @since 3.1
	 */
	public static final long UPLOAD_LIMIT_SIZE = 536870912L;
	
	/**
	 * Memory threshold for uploading content
	 */
	public static final int MEMORY_THRESHOLD_SIZE = 102400;

	/**
	 * Request parameter that contains the payload of the request, e.g. content to POST
	 */
	protected static final String PAYLOAD_REQUEST_PARAM = "payload";
	
	/**
	 * Request parameter controlling whether a posted ZIP should be unpacked to the target folder. By default,
	 * ZIP files will be unpacked.
	 */
	protected static final String PAYLOAD_UNPACK_PARAM = "unpack";	
	
	/**
	 * Type value in the response message for elements that represent directories / folders
	 */
	protected static final String FOLDER_PARAM = "folder";
	
	/**
	 * Type value in the response message for elements that represent files
	 */
	protected static final String FILE_PARAM = "file";
	
	/**
	 * Request parameter for the PUT method that defines the new name of the target file / folder
	 */
	protected static final String RENAME_PARAM = "newName";
	
	/**
	 * Request parameter for the target folder for uploading content to POST
	 */
	protected static final String TARGET_FOLDER_PARAM = "targetfolder";
	
	/**
	 * Request parameter enabling overwrite of pre-existing file / folder
	 */
	//protected static final String OVERWRITE_PARAM = "overwrite";
	
	/**
	 * Format for the SimpleDateFormat in which file details will be reported
	 */
	protected static final String FILE_DATE_FORMAT = "yyyy/MM/dd HH:mm:ss";
	
	/**
	 * Set the permissions of any uploaded file once it is in {@link ViewerUserFileService#itsRootFolder} folder
	 */
	protected static final boolean FILE_UPLOAD_READ_PERMISSION = true;
	protected static final boolean FILE_UPLOAD_WRITE_PERMISSION = true;
	protected static final boolean FILE_UPLOAD_EXECUTE_PERMISSION = false;
       
    /**
     * Default constructor
     * @see HttpServlet#HttpServlet()
     */
    public ViewerUserFileService() 
    {
        super();        
    }

	/**
	 * Implement the GET method. Return details about the file or folder as defined in the request parameters
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{		
		// Get request parameters and serve the request
		String aFile = request.getParameter(FILE_PARAM);
		String aFolder = request.getParameter(FOLDER_PARAM);
		String aUserID = request.getParameter(ViewerSecurityManager.USER_ACCOUNT_URL);
		
		// Authenticate the user
		// Got all the parameters of the request, now do authentication
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String anAccount = aSecurityMgr.authenticateUserByToken(request, aUserID);
		
		if(anAccount != null)
		{
			if(isAccountAuthorized(aSecurityMgr, request, anAccount))
			{
				// If a file has been requested, return its contents
				if(aFile != null && !aFile.isEmpty())
				{		
					String aRedirectURL = request.getContextPath() + itsRootFolder + "/" + aFile;
					try
					{
						aRedirectURL = UriUtils.encodeUri(aRedirectURL, "UTF-8");
						response.sendRedirect(aRedirectURL);
					}
					catch(UnsupportedEncodingException anEx)
					{
						response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
						sendResponse(response, "{\"status\": 500, \"message\": \"Error in URL encoding.\", \"details\" : \"" + anEx.toString() + "\"}");
					}
					
				}
				else if(aFolder != null && !aFolder.isEmpty())
				{
					// Check folder exists
					String aFolderPath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aFolder);
					File aUserFolder = new File(aFolderPath);
					if(aUserFolder != null && aUserFolder.isDirectory())
					{
						// Return the list of files in folder
						String aJSONResponse = getFolderJSON(aUserFolder, aFolder, request);
						response.setStatus(200);				
						sendResponse(response, aJSONResponse);
					}
					else
					{
						response.setStatus(HttpServletResponse.SC_NOT_FOUND);
						sendResponse(response, "{\"status\": 404, \"message\": \"No folder with the specified name found.\", \"folder\" : \"" + aFolder + "\"}");
					}
				}
				else
				{
					// No file or folder request, so return list of files in root folder
					String aFolderPath = getServletContext().getRealPath(itsRootFolder);
					File aUserFolder = new File(aFolderPath);
					String aJSONResponse = getFolderJSON(aUserFolder, "", request);
					response.setStatus(200);				
					sendResponse(response, aJSONResponse);
				}
			}
			else
			{
				// Not authorised
				sendNotAuthZResponse(response);
			}				
		}
		else
		{
			// Not authenticated
			sendNotAuthNResponse(response);
		}		
	}

	/**
	 * Implement the POST method. Receive new files / folder to upload to the target folder. ZIP files can be sent intact
	 * or can be unpacked by this method, as defined by the #PAYLOAD_UNPACK_PARAM
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse) throws ServletException, IOException 
	{
		//String aRepositoryURI = theRequest.getParameter(ViewerSecurityManager.REPOSITORY_ID_URL);
		String aUserURI = theRequest.getParameter(ViewerSecurityManager.USER_ACCOUNT_URL);		
		
		// Check Content Type, if multi-part form, then process parameters differently.
		String aContentType = theRequest.getContentType();
		//System.out.println("Content Type: " + aContentType);
		
		if(aContentType == null)
		{
			// Then this is a bad request - redirect the request to the Essential Viewer BAD URL page
			theResponse.setStatus(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
			sendResponse(theResponse, "{\"status\": 415, \"message\": \"POST content type must be multipart form\"}");
			return;
		}
		
		FileItem aPayload = null;
		String anUnPack = "";
		String aTargetFolder = "";
		String aNewFolderName = "";
		
		// Check to see if this is a request to create a new folder
		// Read the request parameters directly into the TargetFolder and NewFolderName variables
		// TargetFolder will be over-written, if this is not set.
		String aRequestTargetFolder = theRequest.getParameter(TARGET_FOLDER_PARAM);
		aNewFolderName = theRequest.getParameter(FOLDER_PARAM);		
		
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
						else if(aParamName.equals(TARGET_FOLDER_PARAM))
						{
							aTargetFolder = anItem.getString();
							anItem.delete();
						}
						else if(aParamName.equals(FOLDER_PARAM))
						{
							aNewFolderName = anItem.getString();
							anItem.delete();
						}
						else if(aParamName.equals(PAYLOAD_UNPACK_PARAM))
						{
							anUnPack = anItem.getString();
							anItem.delete();
						}
						else if(aParamName.equals(PAYLOAD_REQUEST_PARAM))
						{
							// Hold onto the XML content until we have performed the authN and authZ
							aPayload = anItem;							
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
		
		else
		{
			// Then this is a bad request - redirect the request to the Essential Viewer BAD URL page
			theResponse.setStatus(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
			sendResponse(theResponse, "{\"status\": 415, \"message\": \"POST content type must be multipart form\"}");
						
		}
		
		// Got all the parameters of the request, now do authentication
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String anAccount = aSecurityMgr.authenticateUserByToken(theRequest, aUserURI);
		//String anAccount = "test";
		// Authenticated, so do authorisation

		if(anAccount != null)
		{
			if(isAccountAuthorized(aSecurityMgr, theRequest, anAccount))
			{
				// Authorised 
				boolean isSuccess = false;
				
				// Check Target folder is set
				if(aTargetFolder == null)
				{
					aTargetFolder = "";
				}
				
				// 25.11.2016 JWC - Check to see if we should be creating a new folder instead of unpacking...
				if(aNewFolderName != null && !aNewFolderName.equals(""))
				{
					// We have the new folder name, so create that folder in the
					// specified Target Folder
					isSuccess = saveNewFolder(aNewFolderName, aRequestTargetFolder);
					if(isSuccess)
					{
						// Succeeded in creating folder and there was no additional payload
						theResponse.setStatus(HttpServletResponse.SC_CREATED);
						sendResponse(theResponse, "{\"status\": 201, \"message\": \"Recevied request to create folder " + aNewFolderName + " in " + aTargetFolder + "\"}");
					}
					else
					{
						// Did not succeed in creating the folder. Stop and respond with error
						System.err.println("Essential Viewer User File Service: Error encountered while creating new folder, " + aNewFolderName + " in " + aTargetFolder);
						theResponse.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
						sendResponse(theResponse, "{\"status\": 404, \"message\": \"Error encountered while creating folder, " + aNewFolderName + " in " + aTargetFolder + "\"}");
					}
				}
				
				// Based on content type, save the payload to the target location XML
				if(aContentType.contains(MULTIPART_FORM_CONTENT_TYPE))
				{
					// Save the payload
					// Test content type
					String aFileContentType = aPayload.getContentType();
					
					// Report the content type to aid with trouble shooting due to browser variation
					//System.out.println("Received File: Content Type = " + aFileContentType);
					
					// Look for ZIP content type - handle less standard browsers
					if(aFileContentType.equals(ZIPFILE_CONTENT_TYPE) ||
							aFileContentType.contains(ALT_ZIP_CONTENT_TYPE))
					{
						if(anUnPack.equals("true"))
						{
							// Handle a ZIP file
							ZipInputStream aZipInStream = new ZipInputStream(aPayload.getInputStream());
							
							// Stream the ZipInStream into a String.
							// Get the ZIP file XML content
							isSuccess = savePostedFile(aZipInStream, aTargetFolder);
							aZipInStream.close();
						}
						else
						{
							// Just write the zip to the target folder
							isSuccess = savePostedFile(aPayload, aPayload.getName(), aTargetFolder);
						}
					}
					else
					{
						// Handle uncompressed XML
						isSuccess = savePostedFile(aPayload, aPayload.getName(), aTargetFolder);						
					}
					
					// Delete the uploaded XML
					aPayload.delete();
				}				
				
				// Return success or fail message
				if(isSuccess)
				{
					theResponse.setStatus(HttpServletResponse.SC_CREATED);
					sendResponse(theResponse, "{\"status\": 201, \"message\": \"Recevied payload for upload to folder " + aTargetFolder + "\", \"unpack\" : \"" + anUnPack + "\"}");
				}
				else
				{
					System.err.println("Essential Viewer User File Service: Error encountered while receiving user payload.");
					theResponse.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					sendResponse(theResponse, "{\"status\": 500, \"message\": \"Error encountered while receiving payload for upload to folder " + aTargetFolder + "\", \"unpack\" : \"" + anUnPack + "\"}");
				}				
			}
			else
			{
				// Not authorised
				sendNotAuthZResponse(theResponse);
			}				
		}
		else
		{
			// Not authenticated
			sendNotAuthNResponse(theResponse);
		}	
	}

	/**
	 * Implement the PUT method. Change the name of the specified file or folder.
	 * @see HttpServlet#doPut(HttpServletRequest, HttpServletResponse)
	 */
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		String aRequestPayload = IOUtils.toString(request.getReader());
		
		ObjectMapper aRequestJSON = new ObjectMapper();
		Map<String, String> aNewNameMap = aRequestJSON.readValue(aRequestPayload, Map.class);
		
		// Update the specified resource
		// Get request parameters and serve the request
		String aNewName = aNewNameMap.get(RENAME_PARAM);
		String anAccountID = aNewNameMap.get(ViewerSecurityManager.USER_ACCOUNT_URL);
		
		String aFile = request.getParameter(FILE_PARAM);
		String aFolder = request.getParameter(FOLDER_PARAM);
		
		// Authenticate the user
		// Got all the parameters of the request, now do authentication
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String anAccount = aSecurityMgr.authenticateUserByToken(request, anAccountID);
		
		if(anAccount != null)
		{
			if(isAccountAuthorized(aSecurityMgr, request, anAccount))
			{
				
				if(aNewName != null && !aNewName.isEmpty())
				{
					// If a file has been requested, return its contents
					if(aFile != null && !aFile.isEmpty())
					{
						// Find the file
						String aFilePath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aFile);
						File aRenameFile = new File(aFilePath);
						if(aRenameFile != null && aRenameFile.isFile())
						{
							// Rename the file
							boolean isRenamed = false;
							String aNewFilePath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aNewName);
							File aNewFile = new File(aNewFilePath);
							isRenamed = aRenameFile.renameTo(aNewFile);
							FileDetails aNewDetail = new FileDetails();
							aNewDetail.setType(FILE_PARAM);
							aNewDetail.setName(aNewName);
							aNewDetail.setHref(getFileHref(request, "", aNewDetail));
							if(isRenamed)
							{
								ObjectMapper aMapper = new ObjectMapper();
								String aJSONResponse = aMapper.writeValueAsString(aNewDetail);
								response.setStatus(HttpServletResponse.SC_ACCEPTED);
								sendResponse(response, aJSONResponse);
							}
							else
							{
								// Could not rename the file
								response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
								sendResponse(response, "{\"status\": 500, \"message\": \"Could not rename file\", \"file\" : \"" + aFile + "\"}");
							}
						}
						else
						{
							// No file or folder request, nothing to delete
							response.setStatus(HttpServletResponse.SC_NOT_FOUND);
							sendResponse(response, "{\"status\": 404, \"message\": \"No file found to rename\", \"file\" : \"" + aFile + "\"}");
						}
					}
					else if(aFolder != null && !aFolder.isEmpty())
					{
						// Rename the folder
						String aFolderPath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aFolder);
						File aUserFolder = new File(aFolderPath);
						if(aUserFolder != null && aUserFolder.isDirectory())
						{
							// Rename the folder
							boolean isRenamed = false;
							String aNewFolderPath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aNewName);
							File aNewFile = new File(aNewFolderPath);
							isRenamed = aUserFolder.renameTo(aNewFile);
							FileDetails aNewDetail = new FileDetails();
							aNewDetail.setType(FOLDER_PARAM);
							aNewDetail.setName(aNewName);
							aNewDetail.setHref(getFileHref(request, "", aNewDetail));
							if(isRenamed)
							{
								ObjectMapper aMapper = new ObjectMapper();
								String aJSONResponse = aMapper.writeValueAsString(aNewDetail);
								response.setStatus(HttpServletResponse.SC_ACCEPTED);
								sendResponse(response, aJSONResponse);
							}
							else
							{
								// Could not rename the file
								response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
								sendResponse(response, "{\"status\": 500, \"message\": \"Could not rename folder\", \"folder\" : \"" + aFolder + "\"}");
							}
						}
						else
						{
							response.setStatus(HttpServletResponse.SC_NOT_FOUND);
							sendResponse(response, "{\"status\": 404, \"message\": \"No folder with the specified name found.\", \"folder\" : \"" + aFolder + "\"}");
						}				
					}
					else
					{
						// No file or folder request, so return list of files in root folder
						response.setStatus(HttpServletResponse.SC_NOT_FOUND);
						sendResponse(response, "{\"status\": 404, \"message\": \"Must specify file or folder to rename\"}");
					}
				}
				else
				{
					// No file or folder request, so return list of files in root folder
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					sendResponse(response, "{\"status\": 404, \"message\": \"Must specify file or folder to rename\"}");
				}
			}
			else
			{
				// Not authorised
				sendNotAuthZResponse(response);
			}				
		}
		else
		{
			// Not authenticated
			sendNotAuthNResponse(response);
		}	

	}

	/**
	 * Implement the DELETE method. Delete the specified file or folder. If a folder is specified as the target to 
	 * delete, all the contained files are deleted before the folder itself is removed.
	 * @see HttpServlet#doDelete(HttpServletRequest, HttpServletResponse)
	 */
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		// Delete the specified resource
		// Get request parameters and serve the request
		String aFile = request.getParameter(FILE_PARAM);
		String aFolder = request.getParameter(FOLDER_PARAM);
		String aUserID = request.getParameter(ViewerSecurityManager.USER_ACCOUNT_URL);
		
		// Authenticate the user
		// Got all the parameters of the request, now do authentication
		ViewerSecurityManager aSecurityMgr = new ViewerSecurityManager(getServletContext());
		String anAccount = aSecurityMgr.authenticateUserByToken(request, aUserID);
		
		if(anAccount != null)
		{
			if(isAccountAuthorized(aSecurityMgr, request, anAccount))
			{
				// If a file has been requested, return its contents
				if(aFile != null && !aFile.isEmpty())
				{
					// Find the file
					String aFilePath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aFile);
					File aDeleteFile = new File(aFilePath);
					if(aDeleteFile != null && aDeleteFile.isFile())
					{
						boolean isDeleted = aDeleteFile.delete();
						if(isDeleted)
						{
							// Delete the file
							response.setStatus(HttpServletResponse.SC_ACCEPTED);
							sendResponse(response, "{\"status\": 202, \"message\": \"Deleted file\", \"file\" : \"" + aFile + "\"}");
						}
						else
						{
							// Could not delete the file
							response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
							sendResponse(response, "{\"status\": 500, \"message\": \"Could not delete file\", \"file\" : \"" + aFile + "\"}");
						}
					}
					else
					{
						// No file or folder request, nothing to delete
						response.setStatus(HttpServletResponse.SC_NOT_FOUND);
						sendResponse(response, "{\"status\": 404, \"message\": \"No file found to delete\", \"file\" : \"" + aFile + "\"}");
					}
					
				}
				else if(aFolder != null && !aFolder.isEmpty())
				{
					// Check folder exists
					String aFolderPath = getServletContext().getRealPath(itsRootFolder + System.getProperty("file.separator") + aFolder);
					File aUserFolder = new File(aFolderPath);
					if(aUserFolder != null && aUserFolder.isDirectory())
					{
						// Delete all the contained files
						boolean isFileListDeleted = true;
						File[] aSourceFileList = aUserFolder.listFiles();
						for(int i = 0; i < aSourceFileList.length; i++)
						{
							File aNextFile = aSourceFileList[i];
							if(aNextFile != null)
							{
								isFileListDeleted = aNextFile.delete();
							}
						}
						// Delete the folder itself
						boolean isDeleted = aUserFolder.delete();
						if(isDeleted && isFileListDeleted)
						{
							// Successfully deleted
							response.setStatus(HttpServletResponse.SC_ACCEPTED);
							sendResponse(response, "{\"status\": 202, \"message\": \"Deleted folder and its contents\", \"folder\" : \"" + aFolder + "\"}");
						}
						else if(!isFileListDeleted)
						{
							// Could not delete file list
							response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
							sendResponse(response, "{\"status\": 500, \"message\": \"Could not delete files in folder\", \"folder\" : \"" + aFolder + "\"}");
						}
						else
						{
							// Could not delete the folder itself
							response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
							sendResponse(response, "{\"status\": 500, \"message\": \"Could not delete folder\", \"folder\" : \"" + aFolder + "\"}");
						}
					}
					else
					{
						response.setStatus(HttpServletResponse.SC_NOT_FOUND);
						sendResponse(response, "{\"status\": 404, \"message\": \"No folder with the specified name found to delete.\", \"folder\" : \"" + aFolder + "\"}");
					}
				}
				else
				{
					// No file or folder request, nothing to delete
					response.setStatus(HttpServletResponse.SC_NOT_FOUND);
					sendResponse(response, "{\"status\": 404, \"message\": \"No file found to delete\", \"file\" : \"" + aFile + "\"}");
				}
			}
			else
			{
				// Not authorised
				sendNotAuthZResponse(response);
			}				
		}
		else
		{
			// Not authenticated
			sendNotAuthNResponse(response);
		}	
	}
	
	/**
	 * Send a JSON response response message to the servlet requestor.
	 * @param theResponse the response object to which the response will be sent.
	 * @param theResponseMessage the response message to be included in the response.
	 * @throws IOException any IO exceptions encountered during the attempt to send the response.
	 */
	protected void sendResponse(HttpServletResponse theResponse, String theResponseMessage) throws IOException
	{
		theResponse.setContentType("application/json");
		theResponse.setCharacterEncoding("UTF-8");		
		theResponse.getWriter().print(theResponseMessage);
		theResponse.getWriter().flush();
	}
	
	/**
	 * Get the JSON object that represents the specified folder.
	 * @param theFolder the current folder that is being reported
	 * @param theRelativeFolderPath the relative (from the /user root) path to the current folder 
	 * @param theRequest the client request from which re-purposed URLs will be constructed.
	 * @return the JSON string representing the contents of the folder in a response message.
	 */
	protected String getFolderJSON(File theFolder, String theRelativeFolderPath, HttpServletRequest theRequest)
	{
		String aJSON = "";
		
		// Check that the folder is not null and is a directory
		if(theFolder != null && theFolder.isDirectory())
		{
			FolderDetails aFolder = new FolderDetails();
			aFolder.setRootFolder(itsRootFolder);
			aFolder.setCurrentFolder(theRelativeFolderPath);
			
			// Get parent folder details
			String aParentFolderName = getRelativeParentFolder(theRelativeFolderPath);			
			FileDetails aParentFolder = new FileDetails();
			aParentFolder.setName(aParentFolderName);
			aParentFolder.setType(FOLDER_PARAM);
			SimpleDateFormat aSimpleDate = new SimpleDateFormat(FILE_DATE_FORMAT);
			aParentFolder.setLastModified(aSimpleDate.format(theFolder.lastModified()));
			
			aParentFolder.setHref(getFolderHref(theRequest, aParentFolderName, aParentFolder));
			if(aParentFolderName.isEmpty())
			{
				aParentFolder.setName(ROOT_FOLDER_NAME);
			}
			
			aFolder.setParentFolder(aParentFolder);
			
			// Get the contained files and folders
			Map<String, FileDetails> aFileList = new HashMap<String, FileDetails>();
			
			File[] aSourceFileList = theFolder.listFiles();
			for(int i = 0; i < aSourceFileList.length; i++)
			{
				File aNextFile = aSourceFileList[i];
				if(aNextFile != null)
				{
					FileDetails aFile = new FileDetails();					
					aFile.setName(aNextFile.getName());
					if(aNextFile.isDirectory())
					{
						aFile.setType(FOLDER_PARAM);
					}
					else
					{
						aFile.setType(FILE_PARAM);
											
					}
					aFile.setFileType(FilenameUtils.getExtension(aFile.getName()));	
					aSimpleDate = new SimpleDateFormat(FILE_DATE_FORMAT);
					aFile.setLastModified(aSimpleDate.format(aNextFile.lastModified()));
					String aFileHref = getFileHref(theRequest, theRelativeFolderPath, aFile);
					aFile.setHref(aFileHref);
					aFileList.put(aFile.getName(), aFile);
				}
			}
			aFolder.setFiles(aFileList);
			try
			{
				ObjectMapper aJsonMapper = new ObjectMapper();
				aJSON = aJsonMapper.writeValueAsString(aFolder);
			}
			catch(Exception ex)
			{
				
			}
		}
		return aJSON;
	}
	
	/**
	 * Get the String that represents the specified file
	 * @param theRequest the HTTP request from which a faux HTTP request URL to this service can be constructed
	 * @param theRelativeFolderPath the relative (to the faux-root folder) of the file, that should be used in the URL
	 * @param theFile the file itself that should be rendered as part of the URL.
	 * @return a String that represents the URL from this service to the requested File.
	 */
	protected String getFileHref(HttpServletRequest theRequest, String theRelativeFolderPath, FileDetails theFile)
	{
		String anHref = "";
		String aRelPath = "";
		// Handle files at the top of the directory structure
		if(!theRelativeFolderPath.isEmpty())
		{
			aRelPath = theRelativeFolderPath + "/";
		}
		
		// Build the full URL to the file on this service
		String aRequestPath = theRequest.getRequestURL().toString();
		String aQuery = "?" + theFile.getType() + "=" + aRelPath + theFile.getName();
		anHref = aRequestPath + aQuery;
		return anHref;
		
	}
	
	/**
	 * Get the String that represents the specified folder
	 * @param theRequest theRequest the HTTP request from which a faux HTTP request URL to this service can be constructed
	 * @param theRelativeFolderPath theRelativeFolderPath the relative (to the faux-root folder) of the folder, that should be used in the URL
	 * @param theFile the folder itself that should be rendered as part of the URL.
	 * @return a String that represents the URL from this service to the requested folder.
	 */
	protected String getFolderHref(HttpServletRequest theRequest, String theRelativeFolderPath, FileDetails theFile)
	{
		String anHref = "";
		
		// Add any required parameters to the URL
		String aRequestPath = theRequest.getRequestURL().toString();
		String aQuery = "";
		if(theRelativeFolderPath.isEmpty())
		{
			aQuery = "";
		}
		else
		{
			aQuery = "?" + theFile.getType() + "=" + theFile.getName();
		}
		
		anHref = aRequestPath + aQuery;
		return anHref;
		
	}
	
	/**
	 * Check that the authenticated account is authorised to invoked the service
	 * @param theAccount XML representation of the user account, potentially from user session
	 * @return true if the account is authorised to invoke the service, false otherwise
	 */
	protected boolean isAccountAuthorized(ViewerSecurityManager theSecurityManager, HttpServletRequest theRequest, String theAccount)
	{
		boolean isAuthZ = false;
		//boolean isAuthZ = true;

		if(theAccount != null)
		{
			// Get the fully-qualified Viewer name
			String aServletPath = theRequest.getServletPath();
			StringBuffer aRequestURL = theRequest.getRequestURL();
			String aViewerName = aRequestURL.substring(0, aRequestURL.lastIndexOf(aServletPath));
			
			//String aViewerName = theRequest.getContextPath();
			
			// Is account ID associated with the System Admin Role?
			// Call ViewerSecurityManager to find out
			isAuthZ = theSecurityManager.isUserSystemAdminForViewer(theAccount, aViewerName);
		}
		return isAuthZ;
	}
	
	/**
	 * Get the relative parent folder for the specified file
	 * @param theRelativeFileName the relative path to the file 
	 * @return the relative string to the specified folder that contains theRelativeFileName
	 */
	protected String getRelativeParentFolder(String theRelativeFileName)
	{
		String aParentFolder = "";
		int aPathLocation = theRelativeFileName.lastIndexOf("/");
		
		if(aPathLocation > 0)
		{
			aParentFolder = theRelativeFileName.substring(0, aPathLocation);
		}
		return aParentFolder;
		
	}
	
	/**
	 * Send a JSON response for when the user is not authorized to use the service
	 * @param theResponse the not authorised (FORBIDDEN) message.
	 * @throws IOException IOExceptions are not handled and are passed to the calling method.
	 */
	protected void sendNotAuthZResponse(HttpServletResponse theResponse) throws IOException
	{
		theResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
		sendResponse(theResponse, "{\"status\": 403, \"message\": \"Not authorised for this request\"}");
	}
	
	/**
	 * Send a JSON response for when the user is not authenticated to use the service
	 * @param theResponse the not authorised (UNAUTHORIZED) message.
	 * @throws IOException IOExceptions are not handled and are passed to the calling method.
	 */
	protected void sendNotAuthNResponse(HttpServletResponse theResponse) throws IOException
	{
		theResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
		sendResponse(theResponse, "{\"status\": 401, \"message\": \"User account not authenticated\"}");
	}
	
	/**
	 * Save the file that has been POSTed to the service and set its permissions to those defined by
	 * {@link ViewerUserFileService#FILE_UPLOAD_READ_PERMISSION}, {@link ViewerUserFileService#FILE_UPLOAD_WRITE_PERMISSION},
	 * {@link ViewerUserFileService#FILE_UPLOAD_EXECUTE_PERMISSION} 
	 * @param theUncompressedItem the item to be saved, uncompressed.
	 * @param theFileName the name of the file to which the item is to be saved
	 * @param theTargetFolder the target folder location to which the file is to be saved.
	 * @return true if the file has been successfully saved, false in the case of any failure to save.
	 */
	protected synchronized boolean savePostedFile(FileItem theUncompressedItem, String theFileName, String theTargetFolder)
	{
		boolean isSuccess = false;
		
		// Open a file to save to.
		try
		{
			String aRelativeTargetPath = theFileName;
			if(!theTargetFolder.isEmpty())
			{
				aRelativeTargetPath = theTargetFolder + "/" + theFileName;
			}
			
			String aRealFile = this.getServletContext().getRealPath(itsRootFolder + "/" + aRelativeTargetPath);
			File aFile = new File(aRealFile);
				
			theUncompressedItem.write(aFile);	
			
			// Set the permissions on the new file
			//aFile.setReadable(FILE_UPLOAD_READ_PERMISSION);
			//aFile.setWritable(FILE_UPLOAD_WRITE_PERMISSION);
			//aFile.setExecutable(FILE_UPLOAD_EXECUTE_PERMISSION);
			
			isSuccess = true;
		}
		catch (Exception ioEx)
		{
			System.err.println("Essential Viewer User File Service: Exception writing user upload uncompressed payload file");
			System.err.println(ioEx.getMessage());
			ioEx.printStackTrace(new PrintWriter(System.err));
			isSuccess = false;
		}		
		
		return isSuccess;
	}
	
	/**
	 * Save a ZIP file to the target folder, uncompressing it (and unpacking it, if required) before writing it to the file system, 
	 * and set its permissions to those defined by
	 * {@link ViewerUserFileService#FILE_UPLOAD_READ_PERMISSION}, {@link ViewerUserFileService#FILE_UPLOAD_WRITE_PERMISSION},
	 * {@link ViewerUserFileService#FILE_UPLOAD_EXECUTE_PERMISSION}.
	 * @param theSourceArchive the compressed element that has been received in a ZIP archive. Directory structures are
	 * unpacked and replicated in the target folder.
	 * @param theTargetFolder the name of the target folder to which the ZIP file contents should be saved. 
	 * @return true if successfully unpacked and saved. False in the event of any inability to do so. 
	 */
	protected synchronized boolean savePostedFile(ZipInputStream theSourceArchive, String theTargetFolder)
	{
		boolean isSuccess = false;
		
		// Stream the posted file and uncompress to file
		try
		{
			String aRealFilePath = this.getServletContext().getRealPath(itsRootFolder + "/" + theTargetFolder);
			FileOutputStream aDeployedFile = null;
			ZipEntry aZipEntry = null;
			while((aZipEntry = theSourceArchive.getNextEntry()) != null)
			{
				// Ignore explicit directory entries as openOutputStream will create any required
				if(!aZipEntry.isDirectory())
				{
	  			  	String entryFileName = aZipEntry.getName();
	  			  	String aTargetFile = aRealFilePath + File.separator + entryFileName;
	  			  	File aConfigFile = new File(aTargetFile);
	  			  	
  			  		aDeployedFile = FileUtils.openOutputStream(aConfigFile, false);
  			  		IOUtils.copy(theSourceArchive, aDeployedFile);
  			  		
  			  		aDeployedFile.close();
  			  		
  			  		// Set the permissions on the new file
  			  		//aConfigFile.setReadable(FILE_UPLOAD_READ_PERMISSION);
  			  		//aConfigFile.setWritable(FILE_UPLOAD_WRITE_PERMISSION);
  			  		//aConfigFile.setExecutable(FILE_UPLOAD_EXECUTE_PERMISSION);  			  		
				}
			}
			
			isSuccess = true;
		}
		catch(IOException anXMLFileEx)
		{
			// Catch and report IO Exception reading update script file
			System.err.println("Essential Viewer User File Service: Error encountered while receiving user payload.: IO Exception while reading received Zip archive. Details:");
			System.err.println(anXMLFileEx.toString());
			isSuccess = false;
		}
		catch(NullPointerException anNPE)
		{
			System.err.println("Essential Viewer User File Service: Error encountered while receiving user payload.: Exception reading received Zip archive. Details:");
			System.err.println(anNPE.toString());
			isSuccess = false;
		}
		catch(Exception anZipFileEx)
		{
			// Catch and report any other Exception reading update script file
			System.err.println("Essential Viewer User File Service: Error encountered while receiving user payload.: Exception reading received Zip archive. Details:");	
			System.err.println(anZipFileEx.toString());
			isSuccess = false;
		}
		
		return isSuccess;
		
	}
	
	/**
	 * Create and save the specified new folder within the target folder.
	 * Note that the new folder can specify a path with multiple, new parent folders, e.g. newA/newB/newC
	 * in the target folder.
	 * @param theNewFolderName the name of the new folder to create, which can include new parent folders
	 * @param theTargetFolder the folder in which the new folder will be created
	 * @return true if the new folder is created, false otherwise.
	 */
	protected synchronized boolean saveNewFolder(String theNewFolderName, String theTargetFolder)
	{
		boolean isSuccess = false;
		
		if(theNewFolderName != null && !theNewFolderName.equals(""))
		{
			try
			{
				String aRelativeTargetPath = theNewFolderName;
				if(!theTargetFolder.isEmpty())
				{
					aRelativeTargetPath = theTargetFolder + "/" + theNewFolderName;
				}
				
				String aRealFile = this.getServletContext().getRealPath(itsRootFolder + "/" + aRelativeTargetPath);
				File aFile = new File(aRealFile);
				
				if(!aFile.exists())
				{
					isSuccess = aFile.mkdirs();
					
					if(isSuccess)
					{
						// Set the permissions on the new file
	  			  		//aFile.setReadable(FILE_UPLOAD_READ_PERMISSION);
	  			  		//aFile.setWritable(FILE_UPLOAD_WRITE_PERMISSION);
	  			  		//aFile.setExecutable(FILE_UPLOAD_EXECUTE_PERMISSION);
					}
				}
				
			}
			catch (Exception ioEx)
			{
				System.err.println("Essential Viewer User File Service: Exception creating new folder");
				System.err.println(ioEx.getMessage());
				ioEx.printStackTrace(new PrintWriter(System.err));
				isSuccess = false;
			}
		}
		else
		{
			System.err.println("Essential Viewer User File Service: Attempt to create new folder with empty or null name.");
			isSuccess = false;
		}
		
		return isSuccess;
	}
	

}
