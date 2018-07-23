package com.enterprise_architecture.easdatamanagement.model;

import java.util.HashMap;
import java.util.Map;

/**
 * 
 * Copyright (c)2014 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 * Represents the classification level
 * 
 * @author Abid Ur-Rehman
 * 
 */
public class ClassificationLevel implements Comparable<ClassificationLevel> {
	
	public static final String SECURITY_READ_CLASSIFICATION_SLOT = "system_security_read_classification";
	public static final String SECURITY_EDIT_CLASSIFICATION_SLOT = "system_security_edit_classification";
	public static final String LINK_SELF = "self";
	public static final String URI_SELF = "levels";
	public static final String EA_CLASSIFICATION_LEVEL = "EA_Content_Classification";
	public static final String SECURITY_INDEX_SLOT = "security_classification_index";
	public static final String NAME_SLOT = "name";
	public static final String CLASSIFICATION_GROUP_SLOT = "contained_in_content_classification_group";
	public static final String ATTR_NAME = "name";
	public static final String ATTR_INDEX = "index";
	private Map<String,String> _links = new HashMap<String,String>();
	
	private String id;
	private String name;
	private boolean access;
	private Integer index;
	
	public ClassificationLevel(){}
	
	public ClassificationLevel(String name, boolean access, Integer index){
		this.name = name;
		this.access = access;
		this.index = index;
	}
	
	public ClassificationLevel(String groupId, String id, String name, boolean access, Integer index){
		this.id = id;
		this.name = name;
		this.access = access;
		this.index = index;
		_links.put(LINK_SELF, SystemClassification.URI_SELF+ "/" +ClassificationGroup.URI_SELF+ "/" +groupId+ "/" +URI_SELF+ "/" +getId());
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public String getId() {
		return id;
	}
	
	public void setAccess(boolean access) {
		this.access = access;
	}

	public boolean getAccess() {
		return access;
	}
	
	public Integer getIndex() {
		return index;
	}

	public void setIndex(Integer index) {
		this.index = index;
	}
	
	public Map<String, String> get_links() {
		return _links;
	}

	@Override
	public int compareTo(ClassificationLevel other) {
		if (this.index.intValue() > other.index.intValue()) {
			return 1;
		} else {
			return -1;
		}
	}
	
}
