/**
 * Copyright 2009-2016 Enterprise Architecture Solutions Ltd.
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
 * 20.11.2006	JWC	1st coding.
 * 03.03.2016	JWC Made max image file size a configuration parameter
 */
package com.enterprise_architecture.essential.report;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * ReportServiceImages provides the service in Essential Viewer for receiving the images for
 * each of the GraphWidgets in the Essential Modeller. These are received as image files in a 
 * Multi-part MIME message using the Apache FileUpload classes.
 * @author Jonathan Carter
 * @version 1.1
 * 
 */
public class ReportServiceImages extends HttpServlet
{
	// Use the HTTP responses defined in EasReportService
	private final static int ERROR_STATUS = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
	private final static int SUCCESS_STATUS = HttpServletResponse.SC_OK;
	private final static String IMAGES_DIRECTORY_PARAM = "outputDirectory";
	private String itsOutputFileLocation = "";
	
	// Define the name of the maximum image size init parameter
	private final static String IMAGES_UPLOAD_MAX_SIZE = "maxRequestSize";
	
	/**
	 * Override the initialisation and initialise the service
	 */
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		
		// Get the configuration properties
		itsOutputFileLocation = getServletConfig().getInitParameter(IMAGES_DIRECTORY_PARAM);
	}

	/**
	 * Passes a GET on to the POST method, as the service expects to receive
	 * an image file in a multi-part MIME post.
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
	 * Receive a POST message. The ReportServiceImages servlet expects to receive image files
	 * as Multipart MIME messages. Returns success when an image file has been received and 
	 * saved to the output directory, which is defined in web.xml in the 'outputDirectory' parameter.
	 * @param theRequest the request message
	 * @param theResponse the response message
	 * @exception ServletException when a servlet exception occurs
	 * @exception IIOException in the event of an IOException
	 */
	protected void doPost(HttpServletRequest theRequest, HttpServletResponse theResponse)
	  		  throws ServletException, IOException
	{		
		DiskFileItemFactory aDiskFactory = new DiskFileItemFactory();
		// Use the upload directory as the temporary file store for large images
		String aReposFilename = getServletContext().getRealPath(itsOutputFileLocation + "/tmp");
		aDiskFactory.setRepository(new File(aReposFilename));
		
		// Set in-memory threshold to 100KB
		aDiskFactory.setSizeThreshold(102400);
		
		// Set up the uploader
		ServletFileUpload anUpload = new ServletFileUpload(aDiskFactory);
		
		// Set the max size for an image file to just under the Tomcat default limit
		// 03.03.2016 JWC revised to use configuration servlet init param
		long aRequestSizeLimit = Long.parseLong(getServletConfig().getInitParameter(IMAGES_UPLOAD_MAX_SIZE));
		anUpload.setSizeMax(aRequestSizeLimit);
				
		// Process the upload
		synchronized(theRequest)
		{
			try
			{
				// Get the images that are being sent.
				List anImageFileList = anUpload.parseRequest(theRequest);
				Iterator anImageListIt = anImageFileList.iterator();
				while(anImageListIt.hasNext())
				{
					// Get the image file
					FileItem anImageFile = (FileItem)anImageListIt.next();			
					// Save the file to the output directory
					String aRealSavePath = this.getServletContext().getRealPath(itsOutputFileLocation);
					File anImage = new File(aRealSavePath, anImageFile.getName());
					anImageFile.write(anImage);
				}
				theResponse.setStatus(SUCCESS_STATUS);
			}
			catch(FileUploadException aFileUploadEx)
			{
				System.err.println("Exception encountered while parsing request to receive uploaded image.");
				System.err.println(aFileUploadEx.getMessage());
				aFileUploadEx.printStackTrace(new PrintWriter(System.err));	
				theResponse.setStatus(ERROR_STATUS);
			}
			catch(Exception aWritingEx)
			{
				System.err.println("Exception encountered while writing received image file.");
				System.err.println(aWritingEx.getMessage());
				aWritingEx.printStackTrace(new PrintWriter(System.err));	
				theResponse.setStatus(ERROR_STATUS);
			}
		}
		return;
	}
	
}
