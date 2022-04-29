/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 26.03.2020	JWC	First implementation
 *  
 */
package com.enterprise_architecture.essential.report.precache;

import java.util.ArrayList;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Class to deserialize a JSON description of URLs to pre cache
 * 
 * @author Jonathan W. Carter
 *
 */
@JsonIgnoreProperties(ignoreUnknown=true)
public class PreCacheList 
{
	//private static final Logger itsLog = LoggerFactory.getLogger(PreCacheList.class);
	
	/**
	 * Set of Report APIs to pre-cache
	 */
	private ArrayList<String> preCacheApis = new ArrayList<String>();

	/**
	 * @return the preCacheApis
	 */
	public ArrayList<String> getPreCacheApis() {
		return preCacheApis;
	}

	/**
	 * @param preCacheApis the preCacheApis to set
	 */
	public void setPreCacheApis(ArrayList<String> preCacheApis) {
		this.preCacheApis = preCacheApis;
	}
	
}
