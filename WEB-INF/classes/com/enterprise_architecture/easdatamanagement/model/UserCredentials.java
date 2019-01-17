/**
 * 
 * Copyright (c)2014-2018 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 * 
 * A set of user credentials as a DTO
 *
 * @author David Kumar
 * 
 */
package com.enterprise_architecture.easdatamanagement.model;

public class UserCredentials {
	private String tenantName;
	private String username;
	private String password;
	
	public UserCredentials(String theTenantName, String theUsername, String thePassword) {
		this.tenantName = theTenantName;
		this.username = theUsername;
		this.password = thePassword;
	}

	public String getTenantName() {
		return tenantName;
	}
	
	public String getUsername() {
		return username;
	}
	
	public String getPassword() {
		return password;
	}
	

}
