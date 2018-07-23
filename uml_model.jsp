<?xml version="1.0" encoding="ISO-8859-1"?>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page language="java" contentType="text/html" %>
<%@ page import="java.lang.String"%>
<%@ page import="java.io.StringWriter"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="net.sourceforge.plantuml.SourceStringReader"%>
<%@ page import="com.enterprise_architecture.essential.report.EssentialViewerEngine" %>
<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<%
/**
 * 
 * This JSP is used to create UML-based models leveraging the PlantUML
 * open source framework. 
 *
 * XSL parameter is used as parameter that defines the XSL to be used to create the model
 * PAGEXSL is a special parameter that defines the target HTML page that will include the 
 * rendered UML image.
 * All other parameters are used in the normal manner
 * 
 * Copyright (c)2011-2012 Enterprise Architecture Solutions ltd.
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
 * Updated 13.08.2011 JP created
 * Updated 17.01.2012 JWC updated to use Essential Viewer Engine
 * Updated 27.03.2012 JWC updated to capture and pass original full path of the requested URL
 * Updated 06.03.2013 NJW updated imagePathPrefix from using FS to "/" 
 * @author Jason Powell <info@enterprise-architecture.com>
 * @author Jonathan Carter <info@enterprise-architecture.com>
 *
 */
 	String IMAGE_SUFFIX = ".png";
 	String IMAGE_MAP_SUFFIX = ".cmapx";
	String pageXSLFile = request.getParameter("PAGEXSL");
	boolean isSuccess = true;
	
	// Create a hashcode from the request string to uniquely identify the image.
	String requestString = request.getServletPath();	
	requestString = requestString + "?" + request.getQueryString();
	
	// Remove leading '/' on this URL
	requestString = requestString.substring(1);	
	Integer imageNameHash = new Integer(requestString.hashCode());
	
	// 27.03.2012 JWC - Find the full path of the request URL
	String aRequestURLFullPath = request.getRequestURL().toString();
	String aQueryString = request.getQueryString();
	if(aQueryString != null)
	{
		aRequestURLFullPath += "?" + aQueryString;
	}
	application.setAttribute("theRequestedURLFullPath", aRequestURLFullPath);
	
	// end of capture of full URL path of request
	
	HashMap<Integer, String> imageMap = (HashMap<Integer, String>) application.getAttribute("imageMap");
	if(imageMap == null) {
		imageMap =  new HashMap<Integer, String>();
		application.setAttribute("imageMap", imageMap);
	}

	String imagePath = (String) imageMap.get(imageNameHash);
	String imageMapPath = "";
	String imageFilename = "";
	
	// If no cached image exists, create it
	if(imagePath == null)
	{
		StringWriter aResultScript = new StringWriter();
		
		// USE ESSENTIAL VIEWER ENGINE - build the UML script
		EssentialViewerEngine anEngine = new EssentialViewerEngine(getServletConfig().getServletContext(), true);
		isSuccess = anEngine.generateView(request, response, aResultScript);
		
		if(isSuccess)
		{
			// If the UML script was created successfully, set up and invoke PlantUML
			String umlScript = aResultScript.toString();
	
			String FS = System.getProperty("file.separator");
			String ctx = getServletConfig().getServletContext().getRealPath("") + FS;
			
			String imageFileName = imageNameHash.toString();
			String imageMapFileName = imageNameHash.toString() + IMAGE_MAP_SUFFIX;
			String imagePathPrefix = "graph_images" + "/" + "uml" + "/";
			imagePath = imagePathPrefix + imageFileName;
			imageMapPath = imagePathPrefix + imageMapFileName;
			
			String fullImagePath = ctx + imagePath + IMAGE_SUFFIX;
			FileOutputStream png = new FileOutputStream(fullImagePath);
	
			SourceStringReader reader = new SourceStringReader(umlScript);
			// Write the image to "png"
			String desc = reader.generateImage(png);
			png.close();
		
			imageMap.put(imageNameHash, imagePath);	
			imageFilename = imagePath + IMAGE_SUFFIX;
			imageMapPath = imagePath + IMAGE_MAP_SUFFIX;
		}
		else
		{
			return;
		}
	}	
	// We've got the image and image map in the cache.
	else
	{
		imageMapPath = imagePath + IMAGE_MAP_SUFFIX;
		imageFilename = imagePath + IMAGE_SUFFIX;		
	}
	
%>
<% if(isSuccess) { 
%>
<!-- Forward the request on to the page rendering View template.
	Reset the XSL to the page template, not the script template, add the image file name and
	image map file name.
	Finally, use the PGH switch to override the page history tracking to turn it off for this
	request only, as we want the request to the JSP in the history, not the page view -->
<jsp:forward page="/report" >
	<jsp:param name="XSL" value="<%=pageXSLFile %>" />
 	<jsp:param name="imageFilename" value="<%=imageFilename %>" />
 	<jsp:param name="imageMapPath" value="<%=imageMapPath %>" />
 	<jsp:param name="PGH" value="0" />
</jsp:forward>
 		
<% } else {
	System.out.println("Error encountered while building UML script");
	return;
} %>
