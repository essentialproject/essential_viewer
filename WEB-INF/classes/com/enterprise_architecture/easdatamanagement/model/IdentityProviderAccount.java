/**
 * 
 * Copyright (c)2014-2017 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 * @author David Kumar
 * 
 */
package com.enterprise_architecture.easdatamanagement.model;

public class IdentityProviderAccount {
	private String id;
	private String email;
	
	public IdentityProviderAccount(String id, String email) {
		this.id = id;
		this.email = email;
	};
	
	public String getId() {
		return id;
	}
	
	public String getEmail() {
		return email;
	}
	
	
}
