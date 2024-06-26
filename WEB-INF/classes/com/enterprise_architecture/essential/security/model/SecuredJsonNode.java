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

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Manage a set of Security Classifications for any Json Element.
 * Ignore all other Json elements apart from the security classifications
 * 
 * @author Jonathan W. Carter
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SecuredJsonNode 
{
	/**
	 * The securityClassifications object on ANY Json Element
	 */
	private SecurityClassificationSet securityClassifications;
	
	/**
	 * Default constructor
	 */
	public SecuredJsonNode()
	{
		securityClassifications = new SecurityClassificationSet();
	}

	/**
	 * @return the securityClassifications
	 */
	public SecurityClassificationSet getSecurityClassifications() {
		return securityClassifications;
	}

	/**
	 * @param securityClassifications the securityClassifications to set
	 */
	public void setSecurityClassifications(
			SecurityClassificationSet securityClassifications) {
		this.securityClassifications = securityClassifications;
	}
	
	
}
