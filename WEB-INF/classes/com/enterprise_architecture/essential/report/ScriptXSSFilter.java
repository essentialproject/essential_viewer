/**
 * Copyright (c)2015-2020 Enterprise Architecture Solutions ltd.
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
 * 28.06.2019	JWC Added use of Log4J
 * 14.01.2020	JWC Upgraded use of Spring to 5.2.1 for URI formatting
 */
package com.enterprise_architecture.essential.report;

import com.google.common.base.CharMatcher;

/**
 * Class to identify and filter out (remove) any content in a String that
 * matches the pattern of an XSS attempt, e.g. a script function call.
 * 
 */
public abstract class ScriptXSSFilter extends Object
{
    protected static final String MATCH_STRING = "()<>\\[]|{}";

    /**
     * Constructor for use by subclasses
     */
    protected ScriptXSSFilter()
    {
        super();
    }

    /**
     * Filter the supplied string to remove any character that is defined in the MATCH_STRING
     * 
     * Uses the Google Guava CharMatcher to remove any disallowed characters that could execute
     * script functionality. 
     * Alternative approach is to filter for a regular expression
     * and return an empty string in place of theOriginal string, using the regex:
     * <tt>"[a-z|A-Z]+\\(.*\\)"</tt>
     * @param theOriginalString
     * @return the Original String with any characters in MATCH_STRING removed
     */
    public static String filter(String theOriginalString)
    {
        if(null != theOriginalString)
        {
            String aValidString = CharMatcher.anyOf(MATCH_STRING).removeFrom(theOriginalString);
            return aValidString;
        }
        else
        {
            return theOriginalString;
        }
    }
}