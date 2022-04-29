/**
 * 
 * Copyright (c)2014-2019 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 */
package com.enterprise_architecture.essential.exceptions;

/**
 *
 * @author David Kumar
 *
 */
public class BeforeAndAfterValuesTheSameException extends RuntimeException {
	private static final long serialVersionUID = 717328850245126616L;

	public BeforeAndAfterValuesTheSameException(String message) {
		super(message);
	}

	public BeforeAndAfterValuesTheSameException(Throwable throwable) {
		super(throwable);
	}

	public BeforeAndAfterValuesTheSameException(String message, Throwable throwable) {
		super(message, throwable);
	}

	public String getMessage() {
		return super.getMessage();
	}
	
}
