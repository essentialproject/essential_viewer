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
 * 17.01.2007	JWC	1st coding.
 */
package com.enterprise_architecture.essential.report;

/**
 * Bean to store the details required for an iteration through an Arc list
 * to render the current arc
 * @author Jonathan W. Carter <jonathan.carter@e-asolutions.com>
 * @since v1.0
 * @version 1.0
 *
 */
public class ArcIteration 
{
	private int itsFromIndex = 0;
	private int itsToIndex = 0;
	private int itsOffset = 0;
	private String itsCurrentArcName = "";
	
	/** Default constructor
	 * 
	 *
	 */
	public ArcIteration()
	{
		
	}
	
	/**
	 * @return the itsCurrentArcName
	 */
	public String getItsCurrentArcName() {
		return itsCurrentArcName;
	}
	/**
	 * @param itsCurrentArcName the itsCurrentArcName to set
	 */
	public void setItsCurrentArcName(String itsCurrentArcName) {
		this.itsCurrentArcName = itsCurrentArcName;
	}
	/**
	 * @return the itsFromIndex
	 */
	public int getItsFromIndex() {
		return itsFromIndex;
	}
	/**
	 * @param itsFromIndex the itsFromIndex to set
	 */
	public void setItsFromIndex(int itsFromIndex) {
		this.itsFromIndex = itsFromIndex;
	}
	/**
	 * @return the itsOffset
	 */
	public int getItsOffset() {
		return itsOffset;
	}
	/**
	 * @param itsOffset the itsOffset to set
	 */
	public void setItsOffset(int itsOffset) {
		this.itsOffset = itsOffset;
	}
	/**
	 * @return the itsToIndex
	 */
	public int getItsToIndex() {
		return itsToIndex;
	}
	/**
	 * @param itsToIndex the itsToIndex to set
	 */
	public void setItsToIndex(int itsToIndex) {
		this.itsToIndex = itsToIndex;
	}
	
	
}
