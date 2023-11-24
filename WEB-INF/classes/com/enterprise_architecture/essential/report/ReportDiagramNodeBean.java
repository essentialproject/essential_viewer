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
 * 15.01.2007	JWC	1st Coding.
 * 16.04.2007	JWC	Added the optional parent node and temporary drawing attributes.
 * 21.04.2007	JWC	Added the row and column attributes to the node.
 */
package com.enterprise_architecture.essential.report;

/**
 * Store the details of a Node
 * <br>A node has a name (its reference ID in the repository), a label
 * (the label reference used on diagrams) and a type (e.g. a Process Step).
 * In version 1.1, a parent node (optional) can be specified to indicate that this
 * node is contained within another, parent, node. Additionally, drawing attributes
 * have been added to help with holding local information during drawing.
 * @author Jonathan W. Carter <jonathan.carter@e-asolutions.com>
 * @since version 1.0
 * @version 1.1
 *
 */
public class ReportDiagramNodeBean
{
	private String itsName = "";
	private String itsType = "";
	private String itsLabel = "";
	private String itsParentNode = "";
	private int itsXLoc = 0;
	private int itsYLoc = 0;
	private int itsWidth = 0;
	private int itsHeight = 0;
	private int itsRow = 0;
	private int itsColumn = 0;

	/**
	 * Override the equals method in object to enable the indexing methods
	 * of ArrayLists to be used.
	 * <br>Two nodes are considered to be equal if their names match. This is
	 * based on the assumption that instance names are used in the reports.
	 */
	public boolean equals(Object theCompareNode)
	{
		if(theCompareNode != null)
		{
			// If this is a ReportDiagramNodeBean that's been passed in...
			if(ReportDiagramNodeBean.class.isInstance(theCompareNode))
			{
				// If the names match...
				ReportDiagramNodeBean aCompareNode = (ReportDiagramNodeBean)theCompareNode;
				if(itsName.equals(aCompareNode.getItsName()))
				{
					return true;
				}
				else
					return false;
			}
			else
				return false;
		}
		else 
			return false;
	}
	
	/**
	 * @return the itsLabel
	 */
	public String getItsLabel() {
		return itsLabel;
	}
	/**
	 * @param itsLabel the itsLabel to set
	 */
	public void setItsLabel(String itsLabel) {
		this.itsLabel = itsLabel;
	}
	/**
	 * @return the itsName
	 */
	public String getItsName() {
		return itsName;
	}
	/**
	 * @param itsName the itsName to set
	 */
	public void setItsName(String itsName) {
		this.itsName = itsName;
	}
	/**
	 * @return the itsType
	 */
	public String getItsType() {
		return itsType;
	}
	/**
	 * @param itsType the itsType to set
	 */
	public void setItsType(String itsType) {
		this.itsType = itsType;
	}

	/**
	 * @return the itsParentNode
	 * @since version 1.1
	 */
	public String getItsParentNode() {
		return itsParentNode;
	}

	/**
	 * @param itsParentNode the itsParentNode to set
	 * @since version 1.1
	 */
	public void setItsParentNode(String itsParentNode) {
		this.itsParentNode = itsParentNode;
	}

	/**
	 * @return the itsHeight
	 */
	public int getItsHeight() {
		return itsHeight;
	}

	/**
	 * @param itsHeight the itsHeight to set
	 */
	public void setItsHeight(int itsHeight) {
		this.itsHeight = itsHeight;
	}

	/**
	 * @return the itsWidth
	 * @since version 1.1
	 */
	public int getItsWidth() {
		return itsWidth;
	}

	/**
	 * @param itsWidth the itsWidth to set
	 * @since version 1.1
	 */
	public void setItsWidth(int itsWidth) {
		this.itsWidth = itsWidth;
	}

	/**
	 * @return the itsXLoc
	 * @since version 1.1
	 */
	public int getItsXLoc() {
		return itsXLoc;
	}

	/**
	 * @param itsXLoc the itsXLoc to set
	 * @since version 1.1
	 */
	public void setItsXLoc(int itsXLoc) {
		this.itsXLoc = itsXLoc;
	}

	/**
	 * @return the itsYLoc
	 * @since version 1.1
	 */
	public int getItsYLoc() {
		return itsYLoc;
	}

	/**
	 * @param itsYLoc the itsYLoc to set
	 * @since version 1.1
	 */
	public void setItsYLoc(int itsYLoc) {
		this.itsYLoc = itsYLoc;
	}

	/**
	 * @return the itsColumn
	 * @since version 1.1
	 */
	public int getItsColumn() {
		return itsColumn;
	}

	/**
	 * @param itsColumn the itsColumn to set
	 * @since version 1.1
	 */
	public void setItsColumn(int itsColumn) {
		this.itsColumn = itsColumn;
	}

	/**
	 * @return the itsRow
	 * @since version 1.1
	 */
	public int getItsRow() {
		return itsRow;
	}

	/**
	 * @param itsRow the itsRow to set
	 * @since version 1.1
	 */
	public void setItsRow(int itsRow) {
		this.itsRow = itsRow;
	}

}

