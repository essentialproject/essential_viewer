/**
 * Copyright (c)2007-2008 Enterprise Architecture Solutions ltd.
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
 * 04.05.2007	JP	1st coding.
 */
package com.enterprise_architecture.essential.report;
/**
 * Bean to store details for a cell in a Binary Mapping Table.<br>
 * @author Jason Powell <jason.powell@e-asolutions.com>
 * @version 1.0
 * @since version 1.0
 */
public class BinaryMappingCellBean {
	public static final int EMPTY = 0;
	public static final int GREEN_COLOUR = 1;
	public static final int AMBER_COLOUR = 2;
	public static final int RED_COLOUR = 3;
	
	private int colour;
	private String subTitle;
	private String subDescription;
	private String link;
	/**
	 * @return the colour
	 */
	public int getColour() {
		return colour;
	}
	/**
	 * @param colour the colour to set
	 */
	public void setColour(int colour) {
		this.colour = colour;
	}
	/**
	 * @return the subDescription
	 */
	public String getSubDescription() {
		return subDescription;
	}
	/**
	 * @param subDescription the subDescription to set
	 */
	public void setSubDescription(String subDescription) {
		this.subDescription = subDescription;
	}
	/**
	 * @return the subTitle
	 */
	public String getSubTitle() {
		return subTitle;
	}
	/**
	 * @param subTitle the subTitle to set
	 */
	public void setSubTitle(String subTitle) {
		this.subTitle = subTitle;
	}
	/**
	 * @return the link
	 */
	public String getLink() {
		if(this.link.equals("")) {
			return "#";
		} else {
			return link;
		}
	}
	/**
	 * @param link the link to set
	 */
	public void setLink(String link) {
		this.link = link;
	}

}
