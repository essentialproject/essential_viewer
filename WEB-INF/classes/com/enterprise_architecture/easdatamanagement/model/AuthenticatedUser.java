/**
 * 
 * Copyright (c)2014-2018 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 * 
 * The authenticated user as a DTO from the AuthN Server
 *
 * @author David Kumar
 * 
 */
package com.enterprise_architecture.easdatamanagement.model;

public class AuthenticatedUser {
	private String tenantId;
	private String userId;
	
	public String getTenantId() {
		return tenantId;
	}
	
	public String getUserId() {
		return userId;
	}
	
}
