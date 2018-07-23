package com.enterprise_architecture.easdatamanagement.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 
 * Copyright (c)2014 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 * 
 * Represents a classification group
 *
 * @author Abid Ur-Rehman
 * 
 */
public class ClassificationGroup {
	
	public static final String LINK_SELF = "self";
	public static final String URI_SELF = "groups";
	public static final String EA_CLASSIFICATION_GROUP = "EA_Content_Classification_Group";
	public static final String EA_DEFAULT_CLASSIFICATION = "EA_Default_Classification";
	public static final String CLEARANCE_READ = "clearanceRead";
	public static final String CLEARANCE_EDIT = "clearanceEdit";
	public static final String CLASSIFICATION_SLOT = "contains_content_classifications";
	public static final String SYSTEM_SECUTIRY_READ_CLASSIFICATION = "system_security_read_classification";
	public static final String SYSTEM_SECUTIRY_EDIT_CLASSIFICATION = "system_security_edit_classification";
	public static final String READ_CLASSIFICATION_FACET = "essential_baseline_v4.3_Class12";
	public static final String EDIT_CLASSIFICATION_FACET = "essential_baseline_v4.3_Class11";
	public static final String TUPLE_SPLITTER = ":";
	public static final String CLASSIFICATION_TYPE = "classificationType";
	public static final String CLASSIFICATION_LEVELS = "classificationLevels";
	public static final String ATTR_NAME = "name";
	private Map<String,String> _links = new HashMap<String,String>();
	
	private String id;
	
	private String name;
	
	private List<ClassificationLevel> levels;
	
	public ClassificationGroup(){}
	
	public ClassificationGroup(String id, String name){
		this.id = id;
		this.name = name;
		_links.put(LINK_SELF, SystemClassification.URI_SELF+ "/" +URI_SELF+ "/" +getId());
	}
	
	public ClassificationGroup(String name) {
		this.name = name;
		_links.put(LINK_SELF, URI_SELF +"/"+getId());
	}

	public String getName() {
		return name;
	}
	public String getId() {
		return id;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<ClassificationLevel> getLevels() {
		return levels;
	}
	public void setLevels(List<ClassificationLevel> levels) {
		this.levels = levels;
	}
	
	public Map<String, String> get_links() {
		return _links;
	}
	
	/**
	 * Clones the object
	 */
	public ClassificationGroup clone(){
		ClassificationGroup clone = new ClassificationGroup();
		clone.setName(this.getName());
		List<ClassificationLevel> newLevels = new ArrayList<>();
		for(ClassificationLevel level: this.getLevels()){
			ClassificationLevel newLevel = new ClassificationLevel(
					level.getName(), level.getAccess(), level.getIndex());
			newLevels.add(newLevel);
		}
		clone.setLevels(newLevels);
		return clone;
	}

}
