/**
 * Copyright (c)2021 Enterprise Architecture Solutions ltd.
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
 * 30.03.2021	JWC	First coding
 * 06.04.2021   JWC Re-written without Redis
 * 12.04.2021   JWC Fixed NPE in isMatchingETag()
 */
package com.enterprise_architecture.essential.report.security;

import java.io.File;

import javax.servlet.ServletContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Singleton class to manage the set of ETags to control user browser caching
 * 
 */
public class ViewBrowserCache 
{
    private static final Logger itsLog = LoggerFactory.getLogger(ViewBrowserCache.class);

    private ServletContext itsServletContext = null;
    
    public ViewBrowserCache(ServletContext theConfig)
    {
        itsServletContext = theConfig;
        
    }

    /**
     * Compute a new ETag
     * 
     * @param theViewerId
     * @param theUserHash
     * @param theViewPath
     * @return
     */
    public String computeETag(String theRepositorySnapshot, String theUserHash, String theViewPath)
    {
        String aTokenString = null;
        if(theUserHash != null)
        {
            String aReportXMLDate = getReportXMLDate(theRepositorySnapshot);
            String aViewLastModified = getViewLastModified(theViewPath);
            String aViewerHash = Integer.toString(aReportXMLDate.hashCode());
            String aViewHash = Integer.toString(aViewLastModified.hashCode());
            aTokenString = "W/\"" + aViewerHash + ":" + theUserHash + ":" + aViewHash + "\"";
            itsLog.debug("Repository Snapshot: {}. ReportXMLDate: {}. Computed ETag is: {}", theRepositorySnapshot, aReportXMLDate, aTokenString);
        }
        else
        {
            itsLog.debug("No user profile. Token is NULL. Repository Snapshot: {}. ReportXMLDate: {}", theRepositorySnapshot, getReportXMLDate(theRepositorySnapshot));
            itsLog.debug("View path: {}. Last modified: {}", theViewPath, getViewLastModified(theViewPath));
        }
        return aTokenString;
    }

    /**
     * Compare theUserTag to theCurrentETag, testing whether the ETag supplied by the
     * user matches the current, re-computed current Etag
     * 
     * @param theUserETag
     * @param theCurrentETag
     * @return true if the ETags match
     */
    public boolean isMatchingETag(String theUserETag, String theCurrentETag)
    {
        boolean isMatchingETag = false;

        // Check that neither ETag is null
        if(theCurrentETag == null || theUserETag == null)
        {
            return isMatchingETag;
        }

        // We have valid ETags that can be compared
        String[] aUserETag = theUserETag.split(":");
        String[] aComputedETag = theCurrentETag.split(":");
        int aHashCodeElements = aComputedETag.length;
        int aCount = 0;
        
        // Compare each component of the ETags. Most significant first
        while(aCount < aHashCodeElements)
        {
            String aUserComponent = aUserETag[aCount];
            String aComputedComponent = aComputedETag[aCount];
            if(aUserComponent != null && 
               aUserComponent.equals(aComputedComponent))
            {
                isMatchingETag = true;
                aCount = aCount + 1;
            }
            else
            {
                // ETags don't match
                isMatchingETag = false;
                break;
            }
        }
        return isMatchingETag;
    }

    /**
     * Get the date for the last modification to the reportXML.xml file
     * 
     * @return the date as a String rendering of the integer number of seconds since 1970
     */
    private String getReportXMLDate(String theRespositorySnapshot)
    {
        File aReportXMLFile = new File(itsServletContext.getRealPath("/" + theRespositorySnapshot));
        String aTimestamp = String.valueOf(aReportXMLFile.lastModified());
        return aTimestamp;
    }

    /**
     * Compute the String to hash for the View path
     * 
     * @param theViewPath
     * @return
     */
    private String getViewLastModified(String theViewPath) 
    {
        itsLog.debug("Computing last modified date for path: {}", theViewPath);
        String aViewPath = "/";
        if(theViewPath != null)
        {
            if(!theViewPath.startsWith("/"))
            {
                aViewPath = aViewPath + theViewPath;
            }
            else
            {
                // Path already has a leading /
                aViewPath = theViewPath;
            }
        }

        File aViewFile = new File(itsServletContext.getRealPath(aViewPath));
        String aViewComponent = theViewPath + ":" + String.valueOf(aViewFile.lastModified());
        return aViewComponent;
    }

}
