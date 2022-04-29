package com.enterprise_architecture.easdatamanagement.model;

import java.util.List;

/**
 * 
 * Copyright (c)2014 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 * 
 * Represents a system classification groups
 *
 * @author Abid Ur-Rehman
 * 
 */
public class SystemClassification {
	
	public static final String URI_SELF = "systemClassifications";
	
	private List<ClassificationGroup> classificationGroups;

	public SystemClassification(List<ClassificationGroup> classificationGroups) {
		this.classificationGroups = classificationGroups;
	}

	public List<ClassificationGroup> getClassificationGroups() {
		return classificationGroups;
	}
}
