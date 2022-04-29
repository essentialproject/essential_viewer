/**
 * 
 * Copyright (c)2014-2019 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 */
package com.enterprise_architecture.essential.report.api;

/**
 * @author David Kumar
 * 
 * Model for the JSON response from the Python API
 */
public class ApiResponse {
	private int statusCode;
	private String jsonResponse;
	
	public ApiResponse(int statusCode, String jsonResponse) {
		this.statusCode = statusCode;
		this.jsonResponse = jsonResponse;
	}

	public int getStatusCode() {
		return statusCode;
	}

	public String getJsonResponse() {
		return jsonResponse;
	}
	
}
