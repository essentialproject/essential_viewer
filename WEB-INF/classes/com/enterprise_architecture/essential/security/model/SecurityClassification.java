/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd.
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
 * 30.03.2020	JWC	First coding 
 */
package com.enterprise_architecture.essential.security.model;

/**
 * Manage a security classification in terms of a classification group and a classification level in that
 * group.
 * @author Jonathan W. Carter
 *
 */
public class SecurityClassification 
{
	private String group = "";
	
	private String level = "";
	
	private String index = "";
		
	/**
	 * Default constructor
	 */
	public SecurityClassification()
	{
		
	}

	/**
	 * @return the group
	 */
	public String getGroup() {
		return group;
	}

	/**
	 * @param group the group to set
	 */
	public void setGroup(String group) {
		this.group = group;
	}

	/**
	 * @return the level
	 */
	public String getLevel() {
		return level;
	}

	/**
	 * @param level the level to set
	 */
	public void setLevel(String level) {
		this.level = level;
	}
	
	/**
	 * @return the index
	 */
	public String getIndex() {
		return index;
	}

	/**
	 * @param index the index to set
	 */
	public void setIndex(String index) {
		this.index = index;
	}

	
}
