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
 * Model for the error messages returned as JSON by the API
 * 
 * Note - if you update this model, you'll need to update any API consumers that handle error messages
 */
public class ApiErrorMessage {
	private int statusCode;
	private Message message;

	/**
	 * Inner class for nested JSON structure of error message
	 */
	public class Message {
		private int errorCode = ErrorCode.GENERAL_ERROR.value; //default error code;
		private String errorMessage;
		
		public Message(String errorMessage) {
			this.errorMessage = errorMessage;
		}
		
		public Message(ErrorCode errorCode, String errorMessage) {
			this.errorCode = errorCode.value;
			this.errorMessage = errorMessage;
		}
		
		public int getErrorCode() {
			return errorCode;
		}
		
		public String getErrorMessage() {
			return errorMessage;
		}
		
	}
	
	/**
	 * Enumeration of error codes to keep them standardised
	 */
	public enum ErrorCode {
		//0-9 server error - user cannot recover
		GENERAL_ERROR(0),
		//10-19 AuthN error - user can recover
		BEARER_TOKEN_EXPIRED(10);
		
		public int value;
		
		private ErrorCode(int value) {
			this.value = value;
		}
	}

	
	public ApiErrorMessage(int statusCode, String errorMessage) {
		this.statusCode = statusCode;
		this.message = new Message(errorMessage);
	}

	public ApiErrorMessage(int statusCode, ErrorCode errorCode, String errorMessage) {
		this.statusCode = statusCode;
		this.message = new Message(errorCode, errorMessage);
	}

	public int getStatusCode() {
		return statusCode;
	}

	public Message getMessage() {
		return message;
	}

}
