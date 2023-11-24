/** Copyright (c)2008 Enterprise Architecture Solutions ltd.
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
 * 25.04.2008	JP	first release
 */
package com.enterprise_architecture.essential.report;

import java.io.Serializable;

public class ReportBreadcrumb implements Serializable, Comparable {
	
	private String xmlFile;
	private String xslFile;
	private String param1;
	private String param2;
	private String param3;
	private String param4;
	private String label;
	
	
	/** Default constructor
	 * 
	 *
	 */
	public ReportBreadcrumb(){}
	
	/**
	 * @return the label
	 */
	public String getLabel() {
		return label;
	}
	/**
	 * @param label the label to set
	 */
	public void setLabel(String label) {
		this.label = label;
	}
	/**
	 * @return the param1
	 */
	public String getParam1() {
		return param1;
	}
	/**
	 * @param param1 the param1 to set
	 */
	public void setParam1(String param1) {
		this.param1 = param1;
	}
	/**
	 * @return the param2
	 */
	public String getParam2() {
		return param2;
	}
	/**
	 * @param param2 the param2 to set
	 */
	public void setParam2(String param2) {
		this.param2 = param2;
	}
	/**
	 * @return the param3
	 */
	public String getParam3() {
		return param3;
	}
	/**
	 * @param param3 the param3 to set
	 */
	public void setParam3(String param3) {
		this.param3 = param3;
	}
	/**
	 * @return the param4
	 */
	public String getParam4() {
		return param4;
	}
	/**
	 * @param param4 the param4 to set
	 */
	public void setParam4(String param4) {
		this.param4 = param4;
	}
	/**
	 * @return the xmlFile
	 */
	public String getXmlFile() {
		return xmlFile;
	}
	/**
	 * @param xmlFile the xmlFile to set
	 */
	public void setXmlFile(String xmlFile) {
		this.xmlFile = xmlFile;
	}
	/**
	 * @return the xslFile
	 */
	public String getXslFile() {
		return xslFile;
	}
	/**
	 * @param xslFile the xslFile to set
	 */
	public void setXslFile(String xslFile) {
		this.xslFile = xslFile;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Comparable#compareTo(java.lang.Object)
	 */
	public int compareTo(Object obj) throws ClassCastException{
		// TODO Auto-generated method stub
		ReportBreadcrumb aBc = (ReportBreadcrumb) obj;
		return this.getLabel().compareTo(aBc.getLabel());
	}
}
