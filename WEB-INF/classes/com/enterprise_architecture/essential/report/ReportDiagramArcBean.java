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
 * 15.01.2007	JWC	1st coding.
 */
package com.enterprise_architecture.essential.report;

/**
 * Bean to store Arc details.<br>
 * An arc has a FROM Node, a TO Node, a label
 * (the label reference used on diagrams) and a type (e.g. a Process Flow transition)
 * @author Jonathan W. Carter <jonathan.carter@e-asolutions.com>
 * @version 1.0
 * @since version 1.0
 */
public class ReportDiagramArcBean
{
	private String itsFromNode = "";
	private String itsToNode = "";
	private String itsArcLabel = "";
	private String itsArcType = "";
	/**
	 * @return the itsArcLabel
	 */
	public String getItsArcLabel() {
		return itsArcLabel;
	}
	/**
	 * @param itsArcLabel the itsArcLabel to set
	 */
	public void setItsArcLabel(String itsArcLabel) {
		this.itsArcLabel = itsArcLabel;
	}
	/**
	 * @return the itsArcType
	 */
	public String getItsArcType() {
		return itsArcType;
	}
	/**
	 * @param itsArcType the itsArcType to set
	 */
	public void setItsArcType(String itsArcType) {
		this.itsArcType = itsArcType;
	}
	/**
	 * @return the itsFromNode
	 */
	public String getItsFromNode() {
		return itsFromNode;
	}
	/**
	 * @param itsFromNode the itsFromNode to set
	 */
	public void setItsFromNode(String itsFromNode) {
		this.itsFromNode = itsFromNode;
	}
	/**
	 * @return the itsToNode
	 */
	public String getItsToNode() {
		return itsToNode;
	}
	/**
	 * @param itsToNode the itsToNode to set
	 */
	public void setItsToNode(String itsToNode) {
		this.itsToNode = itsToNode;
	}
}
