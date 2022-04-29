/**
 * Copyright (c)2015 Enterprise Architecture Solutions ltd.
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
 * 03.06.2015	JWC Added the rootFolder attribute
 */
package com.enterprise_architecture.essential.report.security;

import java.util.Map;

/**
 * Class to hold the details of a folder, including all the sub folders and contained files
 * @author Jonathan Carter
 *
 */
public class FolderDetails 
{
	protected String rootFolder;
	
	protected String currentFolder;
	
	protected FileDetails parentFolder;

	protected Map<String, FileDetails> files;
	
	/**
	 * @return the rootFolder
	 */
	public String getRootFolder() {
		return rootFolder;
	}

	/**
	 * @param rootFolder the rootFolder to set
	 */
	public void setRootFolder(String rootFolder) {
		this.rootFolder = rootFolder;
	}

	/**
	 * @return the currentFolder
	 */
	public String getCurrentFolder() {
		return currentFolder;
	}

	/**
	 * @param currentFolder the currentFolder to set
	 */
	public void setCurrentFolder(String currentFolder) {
		this.currentFolder = currentFolder;
	}
	
	/**
	 * @return the parentFolder
	 */
	public FileDetails getParentFolder() {
		return parentFolder;
	}

	/**
	 * @param parentFolder the parentFolder to set
	 */
	public void setParentFolder(FileDetails parentFolder) {
		this.parentFolder = parentFolder;
	}

	/**
	 * @return the files
	 */
	public Map<String, FileDetails> getFiles() {
		return files;
	}

	/**
	 * @param files the files to set
	 */
	public void setFiles(Map<String, FileDetails> files) {
		this.files = files;
	}

	/**
	 * 
	 */
	public FolderDetails() 
	{

	}

}
