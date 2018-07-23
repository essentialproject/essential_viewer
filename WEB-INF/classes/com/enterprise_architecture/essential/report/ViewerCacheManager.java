/**
 * Copyright (c)2011 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 14.11.2011	JWC	First coding
 */
package com.enterprise_architecture.essential.report;

import java.io.File;
import java.io.InputStream;
import java.util.Iterator;

import javax.servlet.ServletContext;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.enterprise_architecture.essential.viewercache.CacheDefinition;
import org.enterprise_architecture.essential.viewercache.Viewercache;

/**
 * Class to manage the Essential Viewer caches. This includes Servlet attributes that are
 * used for cached variables and cache directories, e.g. for temporary or dynamically-generated images.
 * <br/>
 * ViewerCacheManager is controlled by an XML document as described by viewercache.xsd.
 * This describes the set of variables and the set of directories that make up the cache. Each entry
 * has an attribute describing when this entry should be cleared when the clear cache command is given - eitehr
 * pre (before) or post (after) the Essential Repository XML Snapshot has been received.
 * 
 * @author Jonathan W. Carter
 * @version 1
 * 
 */
public class ViewerCacheManager 
{
	/**
	 * Constant value for identifying cache elements that should be cleared before the repository snapshot XML is received
	 */
	public static final String CLEAR_BEFORE_RECEIVE_REPOSITORY = "pre";
	
	/**
	 * Constant value for identifying cache elements that should be cleared after the repository snapshot XML is received
	 */
	public static final String CLEAR_AFTER_RECEIVE_REPOSITORY = "post";
	
	/**
	 * The package name of the JAXB XML components that manage the XML configuration file
	 */
	public static final String VIEWER_CACHE_XML_PACKAGE = "org.enterprise_architecture.essential.viewercache";
	
	/**
	 * Maintain the configuration that this ViewerCacheManager should use.
	 */
	Viewercache itsViewerCacheDefinition;
	
	/**
	 * @param theCacheConfiguration an input stream to the XML configuration file, that 
	 * corresponds to viewercache.xsd
	 */
	public ViewerCacheManager(InputStream theCacheConfiguration) 
	{
		// Create a JAXBContext
		try
		{
			JAXBContext aContext = JAXBContext.newInstance(VIEWER_CACHE_XML_PACKAGE);
			Unmarshaller anUnmarshaller = aContext.createUnmarshaller();
			
			// Read the configuration from from the XML in the input stream
			itsViewerCacheDefinition = (Viewercache)anUnmarshaller.unmarshal(theCacheConfiguration);
			
			// We've got the config so we're ready to clear the cache according to this config		
			
		}
		catch (JAXBException aJaxbEx)
		{
			System.err.println("ViewerCacheManager Error processing configuration XML file");
			System.err.println("Message: " + aJaxbEx.getLocalizedMessage());
			aJaxbEx.printStackTrace();
		}		
		catch (IllegalArgumentException anIllegalArgEx)
		{
			System.err.println("ViewerCacheManager Error unmarshalling configuration XML file");
			System.err.println("Message: " + anIllegalArgEx.getLocalizedMessage());
			anIllegalArgEx.printStackTrace();
		}
	}
	
	/**
	 * Clear all of the cache elements that were defined in the configuration XML document but only those that were
	 * defined to be cleared at the time specified by theWhen parameter.
	 * @param theServletContext the Servlet context in which the variables are being cached as servlet attributes.
	 * @param theWhen the time at which the cache clear is being called - either CLEAR_BEFORE_RECEIVE_REPOSITORY or
	 * CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_AFTER_RECEIVE_REPOSITORY CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_BEFORE_RECEIVE_REPOSITORY CLEAR_BEFORE_RECEIVE_REPOSITORY
	 * @return true on success, false if some element of the cache was not cleared.
	 */
	public boolean clearCache(ServletContext theServletContext, String theWhen)
	{
		boolean isSuccess = false;
		
		if(itsViewerCacheDefinition != null)
		{
			// Clear the list of variables from the cache
			clearCacheVariables(theServletContext, theWhen);		
			
			// Clear the list of directories from the cache
			isSuccess = clearCacheDirectories(theServletContext, theWhen);
		}
		else
		{
			// Cache does nothing, so succeed.
			isSuccess = true;
		}
		return isSuccess;
	}
	
	/**
	 * Clear all of the cache variables that were defined in the configuration XML document but only those that were
	 * defined to be cleared at the time specified by theWhen parameter.
	 * @param theServletContext the Servlet context in which the variables are being cached as servlet attributes.
	 * @param theWhen the time at which the cache clear is being called - either CLEAR_BEFORE_RECEIVE_REPOSITORY or
	 * CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_AFTER_RECEIVE_REPOSITORY CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_BEFORE_RECEIVE_REPOSITORY CLEAR_BEFORE_RECEIVE_REPOSITORY
	 */
	private void clearCacheVariables(ServletContext theServletContext, String theWhen)
	{
		if(itsViewerCacheDefinition != null)
		{
			// Get the list of variables to remove
			Iterator<CacheDefinition> anAttributeIt = itsViewerCacheDefinition.getCachevariables().getVariable().iterator();
			while(anAttributeIt.hasNext())
			{
				// Get the next item to remove from the cache
				CacheDefinition aCacheVariable = anAttributeIt.next();
				
				// First only clear the cache elements that are in the current 'when'
				if(aCacheVariable.getWhen().value().equals(theWhen))
				{
					String aVariableName = aCacheVariable.getValue();
					
					// Remove the variable to clear the cache of this variable
					theServletContext.removeAttribute(aVariableName);
				}
			}
		}	
	}
	
	/**
	 * Clear all of the cache directories that were defined in the configuration XML document but only those that were
	 * defined to be cleared at the time specified by theWhen parameter.
	 * @param theContext the Servlet context, required to find the real path to the directory
	 * @param theWhen the time at which the cache clear is being called - either CLEAR_BEFORE_RECEIVE_REPOSITORY or
	 * CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_AFTER_RECEIVE_REPOSITORY CLEAR_AFTER_RECEIVE_REPOSITORY
	 * @see com.enterprise_architecture.essential.report.ViewerCacheManager#CLEAR_BEFORE_RECEIVE_REPOSITORY CLEAR_BEFORE_RECEIVE_REPOSITORY 
	 * @return true if all the directories were fully cleared. False if any files remain.
	 */
	private boolean clearCacheDirectories(ServletContext theContext, String theWhen)
	{
		boolean isSuccess = false;
		if(itsViewerCacheDefinition != null)
		{
			// Get all the directories defined in the configuration
			Iterator<CacheDefinition> aDirectoryList = itsViewerCacheDefinition.getCachedirectories().getDirectory().iterator();
			while(aDirectoryList.hasNext())
			{
				CacheDefinition aCacheDirectory = aDirectoryList.next();
				
				// Only clear those directories that should be cleared in the current "when"
				if(aCacheDirectory.getWhen().value().equals(theWhen))
				{				
					// Get the full path to the directory
					String aCacheDirectoryName = theContext.getRealPath(aCacheDirectory.getValue());
					
					File aDirectory = new File(aCacheDirectoryName);				
					if(aDirectory.exists())
					{
						// Get the list of files in there
						File[] aFileList = aDirectory.listFiles();			
						
						// For each.. Delete it
						boolean isFileDeleteSuccess = true;
						isSuccess = isFileDeleteSuccess;
						for(int i = 0; i < aFileList.length; i++)
						{
							File aFileToDelete = aFileList[i];
							if(aFileToDelete.isFile())
							{
								isFileDeleteSuccess = aFileList[i].delete();
								if(!isFileDeleteSuccess)
								{
									// Notify that we haven't completely succeeded
									isSuccess = false;
								}
							}
							
						}
					}
				}
			}
		}
		else
		{
			// Cache does nothing, so succeed.
			isSuccess = true;
		}
		return isSuccess;
	}
	
}
