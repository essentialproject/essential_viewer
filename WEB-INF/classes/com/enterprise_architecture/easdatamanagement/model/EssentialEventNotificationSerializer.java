/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 */
package com.enterprise_architecture.easdatamanagement.model;

import java.util.Map;

import org.apache.kafka.common.serialization.Serializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author Jonathan W. Carter
 * Serializer for the EssentialEventNotification object when not using Spring
 *
 */
public class EssentialEventNotificationSerializer<T> implements Serializer<T> {
	private Logger itsLog = LoggerFactory.getLogger(EssentialEventNotificationSerializer.class);
	
	@Override
	public void configure(Map<String, ?> configs, boolean isKey) {
		// do nothing
	}
	
	@Override
	public byte[] serialize(String topic, T data) {
		byte[] aSerializedValue = null;
		ObjectMapper anObjectMapper = new ObjectMapper();
		try {
			aSerializedValue = anObjectMapper.writeValueAsBytes(data);
		} catch (Exception anEx) {
			itsLog.error("Exception whilst serializing event: {}", anEx.getMessage());
		}
		return aSerializedValue;
	}
	
	@Override
	public void close() {
		// do nothing
	}

}
