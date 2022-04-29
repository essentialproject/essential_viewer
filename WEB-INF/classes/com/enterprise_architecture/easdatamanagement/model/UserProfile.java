/**
 * 
 * Copyright (c)2014-2018 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 * 
 * A user profile as a DTO from the AuthN Server
 *
 * @author David Kumar
 * 
 */
package com.enterprise_architecture.easdatamanagement.model;

public class UserProfile {
	private String id;
	private String email;
	private String firstName;
	private String lastName;
	private String tenantId;
	
	public UserProfile() {} // required by Jackson for deserialisation
	
	public UserProfile(String id, String tenantId) {
		this.id = id;
		this.email = "";
		this.firstName = "";
		this.lastName = "";
		this.tenantId = tenantId;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getFullname() {
		return firstName + " " + lastName;
	}
	public String getTenantId() {
		return tenantId;
	}
	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
	

}
