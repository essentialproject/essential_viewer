/**
 * Copyright (c)2019-2020 Enterprise Architecture Solutions ltd. and the Essential Project
 * contributors.
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
 */
package com.enterprise_architecture.essential.report.api;

import java.io.IOException;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;


/**
 * @author David Kumar
 * 
 * Utils class to help with RESTful APIs
 * 
 */
public class ApiUtils {
	private static final Logger myLog = LoggerFactory.getLogger(ApiUtils.class);

	
	/**
	 * build a JSON error response with error code 0 (default error code)
	 */
	public static void buildJsonErrorResponse(ServletResponse theResponse, int theStatus, String theErrorMessageStr) throws IOException {
		ApiErrorMessage anApiErrorMessage = new ApiErrorMessage(theStatus, theErrorMessageStr);
		buildErrorResponse(theResponse, theStatus, anApiErrorMessage);
	}
	
	/**
	 * build a JSON error response with error code 0 (default error code)
	 */
	public static ApiResponse buildJsonErrorResponse(int theStatus, String theErrorMessageStr) {
		ApiErrorMessage anApiErrorMessage = new ApiErrorMessage(theStatus, theErrorMessageStr);
		return buildErrorResponse(theStatus, anApiErrorMessage);
	}
	
	/**
	 * build a JSON error response with a specific error code
	 */
	public static void buildJsonErrorResponse(ServletResponse theResponse, int theStatus, ApiErrorMessage.ErrorCode theErrorCode, String theErrorMessageStr) throws IOException {
		ApiErrorMessage anApiErrorMessage = new ApiErrorMessage(theStatus, theErrorCode, theErrorMessageStr);
		buildErrorResponse(theResponse, theStatus, anApiErrorMessage);
	}
	
	
/*****************************************************************************************************************************************
 * PRIVATE METHODS
 *****************************************************************************************************************************************/
	
	private static void buildErrorResponse(ServletResponse theResponse, int theStatus, ApiErrorMessage theApiErrorMessage) throws IOException {
		ObjectMapper aMapper = new ObjectMapper();
		String aJsonMsgString = "";
		try {
			aJsonMsgString = aMapper.writeValueAsString(theApiErrorMessage);
		} catch (JsonProcessingException jpe) {
			myLog.error("Error creating JSON error message, reason: "+jpe.getMessage(), jpe);
			// do nothing, just log the error
		}
		HttpServletResponse anHttpServletResponse = (HttpServletResponse) theResponse;
		anHttpServletResponse.setStatus(theStatus);
		anHttpServletResponse.setContentType("application/json");
		anHttpServletResponse.setCharacterEncoding("UTF-8");
		anHttpServletResponse.getWriter().write(aJsonMsgString);
	}

	private static ApiResponse buildErrorResponse(int theStatus, ApiErrorMessage theApiErrorMessage) {
		ObjectMapper aMapper = new ObjectMapper();
		String aJsonMsgString = "";
		try {
			aJsonMsgString = aMapper.writeValueAsString(theApiErrorMessage);
		} catch (JsonProcessingException jpe) {
			myLog.error("Error creating JSON error message, reason: "+jpe.getMessage(), jpe);
			// do nothing, just log the error
		}
		return new ApiResponse(theStatus, aJsonMsgString);
	}


	
}
