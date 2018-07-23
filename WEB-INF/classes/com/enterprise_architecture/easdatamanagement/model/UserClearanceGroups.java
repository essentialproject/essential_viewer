package com.enterprise_architecture.easdatamanagement.model;

import java.util.HashMap;
import java.util.Map;

/**
 * 
 * Copyright (c)2014 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 * @author David Kumar
 * 
 * Model of User's clearance levels
 * There is a set of clearance levels per repository, with each level being a tuple of clearance group:level
 */
public class UserClearanceGroups {
	private Map<String, Map<String, String>> clearanceRepoMap;	//map of repos to clearance group:level tuples
	
	public UserClearanceGroups(Map<String, Map<String, String>> clearanceRepoMap) {
		this.clearanceRepoMap = clearanceRepoMap;
	}
	
	/**
	 * @param repoId the repository
	 * @return map of clearance group:level tuples for the repository
	 * or empty map if no clearance groups found for the repository
	 */
	public Map<String, String> getClearanceGroups(String repoId){
		Map<String, String> clearanceGroups = clearanceRepoMap.get(repoId);
		if (null == clearanceGroups) {
			clearanceGroups = new HashMap<>();
		}
		return clearanceGroups;
	}
}
