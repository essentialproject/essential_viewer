/**
 * 
 * Copyright (c)2014-2019 Enterprise Architecture Solutions ltd  
 * All rights reserved
 * Redistribution and use in source and binary forms, with or without modification, is not permitted.
 *
 */
package com.enterprise_architecture.easdatamanagement.model;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TimeZone;

import com.enterprise_architecture.essential.exceptions.BeforeAndAfterValuesTheSameException;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

/**
 * 
 * @author David Kumar
 *
 * An Essential Event is a Kafka notification that denotes some event in the Essential Platform.
 * 
 */
public class EssentialEventNotification {
	/**
	 * Guard against logging large lists of items.
	 * 1000 resources x 2 (before and after lists) in JSON = ~140KB x 2 = ~280KB, 
	 * well below the 1MB configured max record size in Kafka
	 */
	public static final int MAX_PAYLOAD_LIST_SIZE = 1000;
	
	public static final String VALUE_NOT_AVAILABLE = "n/a";
	
	public static SimpleDateFormat itsSdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX"); // ISO8601 date eg. 2019-02-10T10:50:42.389Z
	static {
		itsSdf.setTimeZone(TimeZone.getTimeZone("UTC"));
	}
	
	private String correlationId;
	private String tenantId;
	private Resource author;
	private Date date;
	private DomainEvent.Domain domain;
	private DomainEvent.Event event;
	private Collection<Resource> context = new ArrayList<>();
	private Object payload;
	

	/**
	 * @return true if objects are the same in both lists
	 */
	public static boolean areListsTheSame(Collection<?> theFirstList, Collection<?> theSecondList) {
		boolean areTheSame = theFirstList.size() == theSecondList.size();
		if (areTheSame) {
			for (Object aThingFromTheFirstList : theFirstList) {
				// if any resource in list does not match a resource id in the other list, the lists are not the same
				if (theSecondList.stream()
						.filter(item -> item.equals(aThingFromTheFirstList))
						.findAny()
						.orElse(null) == null) {
					areTheSame = false;
				}
			}
		}
		return areTheSame;
	}

	
	/******************************************************************************************************
	 * Enumerations
	 *******************************************************************************************************/
	public enum DomainEvent {
		// domain-events for logging from EDM
		USERS__CREATE_USER(Domain.USERS, Event.CREATE_USER),
		USERS__JIT_PROVISIONING_OF_USER(Domain.USERS, Event.JIT_PROVISIONING_OF_USER),
		USERS__IMPORT_USER(Domain.USERS, Event.IMPORT_USER),
		USERS__DELETE_USER(Domain.USERS, Event.DELETE_USER),
		USERS__UPDATE_USER(Domain.USERS, Event.UPDATE_USER),
		USERS__ACTIVATE_MFA(Domain.USERS, Event.ACTIVATE_MFA),
		USERS__DEACTIVATE_MFA(Domain.USERS, Event.DEACTIVATE_MFA),
		USERS__CHANGE_PASSWORD(Domain.USERS, Event.CHANGE_PASSWORD),
		SYSTEM_USER_DEFAULT_SETTINGS__UPDATE_SETTINGS(Domain.SYSTEM_USER_DEFAULT_SETTINGS, Event.UPDATE_SETTINGS),
		REPOSITORY_USERS__UPDATE_USER(Domain.REPOSITORY_USERS, Event.UPDATE_USER),
		REPOSITORY_USER_DEFAULT_SETTINGS__UPDATE_SETTINGS(Domain.REPOSITORY_USER_DEFAULT_SETTINGS, Event.UPDATE_SETTINGS),
		REPOSITORIES__APPLY_EUP(Domain.REPOSITORIES, Event.APPLY_EUP),
		REPOSITORIES__APPLY_DUP(Domain.REPOSITORIES, Event.APPLY_DUP),
		REPOSITORIES__APPLY_SYSTEM_UPDATE(Domain.REPOSITORIES, Event.APPLY_SYSTEM_UPDATE),
		REPOSITORIES__APPLY_API(Domain.REPOSITORIES, Event.APPLY_API),
		REPOSITORIES__IMPORT_PROTEGE_PROJECT(Domain.REPOSITORIES, Event.IMPORT_PROTEGE_PROJECT),
		REPOSITORIES__EXPORT_PROTEGE_PROJECT(Domain.REPOSITORIES, Event.EXPORT_PROTEGE_PROJECT),
		REPOSITORIES__CREATE_SNAPSHOT(Domain.REPOSITORIES, Event.CREATE_SNAPSHOT),
		REPOSITORIES__RESTORE_SNAPSHOT(Domain.REPOSITORIES, Event.RESTORE_SNAPSHOT),
		REPOSITORIES__DELETE_SNAPSHOT(Domain.REPOSITORIES, Event.DELETE_SNAPSHOT),
		REPOSITORIES__COPY_REPOSITORY(Domain.REPOSITORIES, Event.COPY_REPOSITORY),
		REPOSITORIES__PUBLISH(Domain.REPOSITORIES, Event.PUBLISH),
		REPOSITORY_METAMODEL_CLASSES__CREATE_CLASS(Domain.REPOSITORY_METAMODEL_CLASSES, Event.CREATE_CLASS),
		REPOSITORY_METAMODEL_CLASSES__DELETE_CLASS(Domain.REPOSITORY_METAMODEL_CLASSES, Event.DELETE_CLASS),
		REPOSITORY_METAMODEL_CLASSES__UPDATE_CLASS(Domain.REPOSITORY_METAMODEL_CLASSES, Event.UPDATE_CLASS),
		REPOSITORY_METAMODEL_CLASSES__UPDATE_CLASS_NAME(Domain.REPOSITORY_METAMODEL_CLASSES, Event.UPDATE_CLASS_NAME),
		REPOSITORY_METAMODEL_CLASSES__ADD_SUBCLASS(Domain.REPOSITORY_METAMODEL_CLASSES, Event.ADD_SUBCLASS),
		REPOSITORY_METAMODEL_CLASSES__REMOVE_SUBCLASS(Domain.REPOSITORY_METAMODEL_CLASSES, Event.REMOVE_SUBCLASS),
		REPOSITORY_METAMODEL_CLASS_SLOTS__ADD_SLOT(Domain.REPOSITORY_METAMODEL_CLASS_SLOTS, Event.ADD_SLOT),
		REPOSITORY_METAMODEL_CLASS_SLOTS__REMOVE_SLOT(Domain.REPOSITORY_METAMODEL_CLASS_SLOTS, Event.REMOVE_SLOT),
		REPOSITORY_METAMODEL_CLASS_SLOTS__UPDATE_CLASS_SLOT(Domain.REPOSITORY_METAMODEL_CLASS_SLOTS, Event.UPDATE_CLASS_SLOT),
		REPOSITORY_METAMODEL_SLOTS__CREATE_SLOT(Domain.REPOSITORY_METAMODEL_SLOTS, Event.CREATE_SLOT),
		REPOSITORY_METAMODEL_SLOTS__DELETE_SLOT(Domain.REPOSITORY_METAMODEL_SLOTS, Event.DELETE_SLOT),
		REPOSITORY_METAMODEL_SLOTS__UPDATE_SLOT(Domain.REPOSITORY_METAMODEL_SLOTS, Event.UPDATE_SLOT),
		REPOSITORY_METAMODEL_SLOTS__UPDATE_SLOT_NAME(Domain.REPOSITORY_METAMODEL_SLOTS, Event.UPDATE_SLOT_NAME),
		REPOSITORY_METAMODEL_INSTANCES__CREATE_INSTANCE(Domain.REPOSITORY_METAMODEL_INSTANCES, Event.CREATE_INSTANCE),
		REPOSITORY_METAMODEL_INSTANCES__DELETE_INSTANCE(Domain.REPOSITORY_METAMODEL_INSTANCES, Event.DELETE_INSTANCE),
		REPOSITORY_METAMODEL_INSTANCES__UPDATE_INSTANCE(Domain.REPOSITORY_METAMODEL_INSTANCES, Event.UPDATE_INSTANCE),
		REPOSITORY_METAMODEL_INSTANCES__UPDATE_INSTANCE_NAME(Domain.REPOSITORY_METAMODEL_INSTANCES, Event.UPDATE_INSTANCE_NAME),
		REPOSITORY_CLASSIFICATIONS__CREATE_CLASSIFICATION_GROUP(Domain.REPOSITORY_CLASSIFICATIONS, Event.CREATE_CLASSIFICATION_GROUP),
		REPOSITORY_CLASSIFICATIONS__DELETE_CLASSIFICATION_GROUP(Domain.REPOSITORY_CLASSIFICATIONS, Event.DELETE_CLASSIFICATION_GROUP),
		REPOSITORY_CLASSIFICATIONS__UPDATE_CLASSIFICATION_GROUP(Domain.REPOSITORY_CLASSIFICATIONS, Event.UPDATE_CLASSIFICATION_GROUP),
		REPOSITORY_CLASSIFICATIONS__CREATE_CLASSIFICATION_LEVEL(Domain.REPOSITORY_CLASSIFICATIONS, Event.CREATE_CLASSIFICATION_LEVEL),
		REPOSITORY_CLASSIFICATIONS__DELETE_CLASSIFICATION_LEVEL(Domain.REPOSITORY_CLASSIFICATIONS, Event.DELETE_CLASSIFICATION_LEVEL),
		REPOSITORY_CLASSIFICATIONS__UPDATE_CLASSIFICATION_LEVEL(Domain.REPOSITORY_CLASSIFICATIONS, Event.UPDATE_CLASSIFICATION_LEVEL),
		REPOSITORIES_UI_INSTANCES__DELETE_INSTANCE(Domain.REPOSITORY_UI_INSTANCES, Event.DELETE_INSTANCE),
		REPOSITORIES_UI_INSTANCES__UPDATE_INSTANCE(Domain.REPOSITORY_UI_INSTANCES, Event.UPDATE_INSTANCE),
		REPOSITORIES_UI_INSTANCES__COPY_INSTANCE(Domain.REPOSITORY_UI_INSTANCES, Event.COPY_INSTANCE),
		REPOSITORIES_UI_INSTANCES__CREATE_INSTANCE(Domain.REPOSITORY_UI_INSTANCES, Event.CREATE_INSTANCE),
		REPOSITORIES_UI_INSTANCES__ADD_VALUE_TO_SLOT(Domain.REPOSITORY_UI_INSTANCES, Event.ADD_VALUE_TO_SLOT),
		REPOSITORIES_UI_INSTANCES__REMOVE_VALUE_FROM_SLOT(Domain.REPOSITORY_UI_INSTANCES, Event.REMOVE_VALUE_FROM_SLOT),
		REPOSITORIES_UI_CLASSES__CREATE_CLASS(Domain.REPOSITORY_UI_CLASSES, Event.CREATE_CLASS),
		REPOSITORIES_UI_CLASSES__UPDATE_CLASS(Domain.REPOSITORY_UI_CLASSES, Event.UPDATE_CLASS),
		REPOSITORIES_UI_CLASSES__DELETE_CLASS(Domain.REPOSITORY_UI_CLASSES, Event.DELETE_CLASS),
		REPOSITORIES_UI_CLASSES__UPDATE_SUPERCLASS(Domain.REPOSITORY_UI_CLASSES, Event.UPDATE_SUPERCLASS),
		REPOSITORIES_UI_CLASS_SLOTS__CREATE_AND_ADD_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.CREATE_AND_ADD_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__ADD_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.ADD_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__REMOVE_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.REMOVE_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__UPDATE_CLASS_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.UPDATE_CLASS_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__ADD_VALUE_TO_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.ADD_VALUE_TO_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__REMOVE_VALUE_FROM_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.REMOVE_VALUE_FROM_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__CANCEL_OVERRIDE_OF_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.CANCEL_OVERRIDE_OF_SLOT),
		REPOSITORIES_UI_CLASS_SLOTS__CREATE_INVERSE_SLOT(Domain.REPOSITORY_UI_CLASS_SLOTS, Event.CREATE_INVERSE_SLOT),
		REPOSITORIES_UI_SLOTS__UPDATE_SLOT(Domain.REPOSITORY_UI_SLOTS, Event.UPDATE_SLOT),
		REPOSITORIES_UI_SLOTS__ADD_VALUE_TO_SLOT(Domain.REPOSITORY_UI_SLOTS, Event.ADD_VALUE_TO_SLOT),
		REPOSITORIES_UI_SLOTS__REMOVE_VALUE_FROM_SLOT(Domain.REPOSITORY_UI_SLOTS, Event.REMOVE_VALUE_FROM_SLOT),
		REPOSITORIES_UI_SLOTS__DELETE_SLOT(Domain.REPOSITORY_UI_SLOTS, Event.DELETE_SLOT),
		REPOSITORIES_GRAPHICAL_UI_INSTANCES__CREATE_GRAPH_NODE(Domain.REPOSITORY_GRAPHICAL_UI_INSTANCES, Event.CREATE_GRAPH_NODE),
		REPOSITORIES_GRAPHICAL_UI_INSTANCES__DELETE_GRAPH_NODE(Domain.REPOSITORY_GRAPHICAL_UI_INSTANCES, Event.DELETE_GRAPH_NODE),
		REPOSITORIES_GRAPHICAL_UI_INSTANCES__UPDATE_GRAPH_NODE(Domain.REPOSITORY_GRAPHICAL_UI_INSTANCES, Event.UPDATE_GRAPH_NODE),
		REPOSITORIES_GRAPHICAL_UI_INSTANCES__CREATE_GRAPH_RELATION(Domain.REPOSITORY_GRAPHICAL_UI_INSTANCES, Event.CREATE_GRAPH_RELATION),
		REPOSITORIES_GRAPHICAL_UI_INSTANCES__DELETE_GRAPH_RELATION(Domain.REPOSITORY_GRAPHICAL_UI_INSTANCES, Event.DELETE_GRAPH_RELATION),
		REPOSITORIES_GRAPHICAL_UI_INSTANCES__UPDATE_GRAPH_RELATION(Domain.REPOSITORY_GRAPHICAL_UI_INSTANCES, Event.UPDATE_GRAPH_RELATION),
		// domain-events for Forms logged by Viewer Pass-thru service
		REPOSITORY_FORMS__FORM_API_REQUEST(Domain.REPOSITORY_FORMS, Event.FORM_API_REQUEST),
		// domain-events for APIs logged by API-Platform
		REPOSITORY_APIS__API_REQUEST(Domain.REPOSITORY_APIS, Event.API_REQUEST);
		
		
		private Domain domain;
		private Event event;

		DomainEvent(Domain domain, Event event) {
			this.domain = domain;
			this.event = event;
		}
		
		public Domain getDomain() {
			return this.domain;
		}
		
		public Event getEvent() {
			return this.event;
		}
		
		private enum Domain {
			USERS("users"),
			REPOSITORY_USERS("repositories/users"),
			SYSTEM_USER_DEFAULT_SETTINGS("system/user-default-settings"),
			REPOSITORY_USER_DEFAULT_SETTINGS("repositories/user-default-settings"),
			REPOSITORIES("repositories"),
			REPOSITORY_METAMODEL_CLASSES("repositories/meta-model/classes"),
			REPOSITORY_METAMODEL_CLASS_SLOTS("repositories/meta-model/classes/slots"),
			REPOSITORY_METAMODEL_SLOTS("repositories/meta-model/slots"),
			REPOSITORY_METAMODEL_INSTANCES("repositories/meta-model/instances"),
			REPOSITORY_CLASSIFICATIONS("repositories/classifications"),
			REPOSITORY_UI_CLASSES("repositories/ui/classes"),
			REPOSITORY_UI_CLASS_SLOTS("repositories/ui/classes/slots"),
			REPOSITORY_UI_SLOTS("repositories/ui/slots"),
			REPOSITORY_UI_INSTANCES("repositories/ui/instances"),
			REPOSITORY_GRAPHICAL_UI_INSTANCES("repositories/graphical-ui/instances"),
			REPOSITORY_FORMS("repositories/forms"),
			REPOSITORY_APIS("repositories/apis");
			private String prettyName;
			Domain(String name){this.prettyName = name;}
			@Override
			public String toString() {
				return prettyName;
			}
		}
		
		private enum Event {
			CREATE_USER("create-user"),
			JIT_PROVISIONING_OF_USER("just-in-time-provisioning-of-user"),
			IMPORT_USER("import-user"),
			DELETE_USER("delete-user"),
			UPDATE_USER("update-user"),
			ACTIVATE_MFA("activate-mfa"),
			DEACTIVATE_MFA("deactivate-mfa"),
			CHANGE_PASSWORD("change-password"),
			UPDATE_SETTINGS("update-settings"),
			APPLY_EUP("apply-eup"),
			APPLY_DUP("apply-dup"),
			APPLY_SYSTEM_UPDATE("apply-system-update"),
			APPLY_API("apply-api"),
			IMPORT_PROTEGE_PROJECT("import-protege-project"),
			EXPORT_PROTEGE_PROJECT("export-protege-project"),
			CREATE_SNAPSHOT("create-snapshot"),
			DELETE_SNAPSHOT("delete-snapshot"),
			RESTORE_SNAPSHOT("restore-snapshot"),
			COPY_REPOSITORY("overwrite-repository-with-copy"),
			PUBLISH("publish"),
			UPDATE_CLASS("update-class"),
			UPDATE_SLOT("update-slot"),
			UPDATE_INSTANCE("update-instance"),
			ADD_SUBCLASS("add-subclass"),
			REMOVE_SUBCLASS("remove-subclass"),
			ADD_SLOT("add-slot"),
			REMOVE_SLOT("remove-slot"),
			CREATE_CLASS("create-class"),
			DELETE_CLASS("delete-class"),
			CREATE_SLOT("create-slot"),
			DELETE_SLOT("delete-slot"),
			CREATE_INSTANCE("create-instance"),
			DELETE_INSTANCE("delete-instance"),
			COPY_INSTANCE("copy-instance"),
			UPDATE_CLASS_NAME("update-class-name"),
			UPDATE_SUPERCLASS("update-superclass"),
			CREATE_AND_ADD_SLOT("create-and-add-slot"),
			UPDATE_SLOT_NAME("upate-slot-name"),
			UPDATE_INSTANCE_NAME("update-instance-name"),
			ADD_VALUE_TO_SLOT("add-values-to-slot"),
			REMOVE_VALUE_FROM_SLOT("remove-value-from-slot"),
			UPDATE_CLASS_SLOT("update-class-slot"),
			CANCEL_OVERRIDE_OF_SLOT("cancel-override-of-slot"),
			CREATE_INVERSE_SLOT("create-inverse-slot"),
			CREATE_CLASSIFICATION_GROUP("create-classification-group"),
			DELETE_CLASSIFICATION_GROUP("delete-classification-group"),
			UPDATE_CLASSIFICATION_GROUP("update-classification-group"),
			CREATE_CLASSIFICATION_LEVEL("create-classification-level"),
			DELETE_CLASSIFICATION_LEVEL("delete-classification-level"),
			UPDATE_CLASSIFICATION_LEVEL("update-classification-level"),
			CREATE_GRAPH_NODE("create-graph-node"),
			DELETE_GRAPH_NODE("delete-graph-node"),
			UPDATE_GRAPH_NODE("update-graph-node"),
			CREATE_GRAPH_RELATION("create-graph-relation"),
			DELETE_GRAPH_RELATION("delete-graph-relation"),
			UPDATE_GRAPH_RELATION("update-graph-relation"),
			FORM_API_REQUEST("form-api-request"),
			API_REQUEST("api-request");
			private String prettyName;
			Event(String name){this.prettyName = name;}
			@Override
			public String toString() {
				return prettyName;
			}
		}
	};
	
	public enum ResourceType {
		// Context for events logged by EDM
		SUPERUSER("superuser"),
		USER("user"),
		REPOSTIORY("repository"),
		VIEWER("viewer"),
		SYSTEM_ROLE("system-role"),
		REPOSITORY_ROLE("repository-role"),
		CLEARANCE_GROUP("clearance-group"),
		CLEARANCE_LEVEL("clearance-level"),
		METAMODEL_CLASS("metamodel-class"),
		METAMODEL_SLOT("metamodel-slot"),
		METAMODEL_INSTANCE("metamodel-instance"),
		GRAPH_INSTANCE("graph-instance"),
		GRAPH_NODE_INSTANCE("graph-node-instance"),
		GRAPH_RELATION_INSTANCE("graph-relation-instance"),
		// Context for Forms logged by Viewer Pass-thru service
		FORM("form"),
		// Context for API requests logged by API-Platform
		API_REQUEST("api-request");
		private String prettyName;
		ResourceType(String name){this.prettyName = name;}
		@Override
		public String toString() {
			return prettyName;
		}
	}
	
	
	/******************************************************************************************************
	 * Public Inner Class
	 *******************************************************************************************************/
	public static class Resource {
		private ResourceType type;
		private String id;
		private String name;

		public Resource() {};
		
		public Resource(ResourceType type, String id, String name) {
			this.id = id;
			this.name = name;
			this.type = type;
		};

		public String getType() {
			return type.toString();
		}
		
		public String getId() {
			return id;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}
		
		/**
		 * Override equals used to compare before and after values to check event needs logging
		 */
		@Override
		public boolean equals(Object o) {
			if (o == this) return true; // self check
			if (o == null) return false; // null check
			if (!(o instanceof Resource)) return false; // type check

			Resource other = (Resource) o;
			return this.id.equals(other.id);
		}
	}
	
	@JsonSerialize
	public static class EmptyPayload {
		
		public EmptyPayload() {};
		
	}

	public static class Builder {
		private String correlationId;
		private String tenantId;
		private Resource author;
		private Date date;
		private DomainEvent domainEvent;
		
		public Builder(String correlationId, String tenantId, Resource author, DomainEvent domainEvent) {
			this.correlationId = correlationId;
			this.tenantId = tenantId;
			this.author = author;
			this.date = new Date();
			this.domainEvent = domainEvent;
		}
		
		public ContextBuilder withContext(ResourceType type, String id, String name) {
			return new ContextBuilder(correlationId, tenantId, author, date, domainEvent, new Resource(type, id, name));
		}
		
		public ContextBuilder withContext(Resource theResource) {
			return new ContextBuilder(correlationId, tenantId, author, date, domainEvent, theResource);
		}
		
		public ContextBuilder withContext(Collection<Resource> theListOfResources) {
			return new ContextBuilder(correlationId, tenantId, author, date, domainEvent, theListOfResources);
		}
		
		public ContextBuilder withNoContext() {
			return new ContextBuilder(correlationId, tenantId, author, date, domainEvent);
		}
		
	}
	
	public static class ContextBuilder {
		private String correlationId;
		private String tenantId;
		private Resource author;
		private Date date;
		private DomainEvent domainEvent;
		private Collection<Resource> context = new ArrayList<>();
		
		public ContextBuilder(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent) {
			this.correlationId = correlationId;
			this.tenantId = tenantId;
			this.author = author;
			this.date = date;
			this.domainEvent = domainEvent;
		}
		
		public ContextBuilder(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent, Resource aSingleContext) {
			this(correlationId, tenantId, author, date, domainEvent);
			this.context.add(aSingleContext);
		}
		
		public ContextBuilder(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent, Collection<Resource> theContextList) {
			this(correlationId, tenantId, author, date, domainEvent);
			this.context.addAll(theContextList);
		}
		
		public ContextBuilder withContext(ResourceType type, String id, String name) {
			this.context.add(new Resource(type, id, name));
			return this;
		}
		
		public ContextBuilder withContext(Resource theResource) {
			this.context.add(theResource);
			return this;
		}
		
		public ContextBuilder withContext(Collection<Resource> theListOfResources) {
			this.context.addAll(theListOfResources);
			return this;
		}
		
		/**
		 * Use case - when the payload is just a POJO representing the state of the payload, eg. a created user
		 */
		public PayloadBuilder withPayload(Object payload) {
			return new PayloadBuilder(correlationId, tenantId, author, date, domainEvent, context, payload);
		}
		
		/**
		 * Use case - when the payload is the before and after snapshot of a POJO, eg. a user before and after it was updated
		 * @throws BeforeAndAfterValuesTheSameException 
		 */
		public PayloadBuilder withPayloadBeforeAndAfter(Object beforePayload, Object afterPayload) {
			Map<String, Object> aPayload = new HashMap<>();
			aPayload.put("before", beforePayload);
			aPayload.put("after", afterPayload);
			if (beforePayload.equals(afterPayload)) {
				throw new BeforeAndAfterValuesTheSameException("Payload before and after values are the same.");
			}
			return new PayloadBuilder(correlationId, tenantId, author, date, domainEvent, context, aPayload);
		}

		/**
		 * Use case - when the payload is the before and after snapshot of a collection of resources, eg. a list of repositories a user has access to before and after it was updated
		 * @throws BeforeAndAfterValuesTheSameException 
		 */
		public PayloadBuilder withPayloadBeforeAndAfterCollections(String attributeName, Collection<?> beforeCollection, Collection<?> afterCollection) {
			Map<String, Object> aPayload = new HashMap<>();
			Map<String, Object> aBeforeMap = new HashMap<>();
			Map<String, Object> anAfterMap = new HashMap<>();
			aPayload.put("before", aBeforeMap);
			aPayload.put("after", anAfterMap);
			
			if (beforeCollection.size() > MAX_PAYLOAD_LIST_SIZE) {
				aBeforeMap.put(attributeName, "Contains "+beforeCollection.size()+" items, too many items to list.");
			} else {
				aBeforeMap.put(attributeName, beforeCollection);
			}
			if (afterCollection.size() > MAX_PAYLOAD_LIST_SIZE) {
				anAfterMap.put(attributeName, "Contains "+ afterCollection.size()+" items, too many items to list.");
			} else {
				anAfterMap.put(attributeName, afterCollection);
			}
			
			if (areListsTheSame(beforeCollection, afterCollection)) {
				throw new BeforeAndAfterValuesTheSameException("Payload before and after values are the same.");
			}
			return new PayloadBuilder(correlationId, tenantId, author, date, domainEvent, context, aPayload);
		}
		
		/**
		 * Use case - when the payload is the a set of attributes with before and after values, eg. a selection of fields from a user before and after it was updated
		 */
		public PayloadBuilderFromBeforeAndAfterAttributes withPayloadBeforeAndAfterAttributeValues(String attributeName, Object beforeValue, Object afterValue) {
			PayloadBuilderFromBeforeAndAfterAttributes aPayloadBuilder = new PayloadBuilderFromBeforeAndAfterAttributes(correlationId, tenantId, author, date, domainEvent, context);
			aPayloadBuilder.withPayloadBeforeAndAfterAttributeValues(attributeName, beforeValue, afterValue);
			return aPayloadBuilder;
		}

		/**
		 * Use case - when the payload is a set of attributes describing an event, ie. a filename for an import
		 */
		public PayloadBuilderFromAttributes withPayloadAttributeValues(String attributeName, Object value) {
			PayloadBuilderFromAttributes aPayloadBuilder = new PayloadBuilderFromAttributes(correlationId, tenantId, author, date, domainEvent, context);
			aPayloadBuilder.withPayloadAttributeValues(attributeName, value);
			return aPayloadBuilder;
		}

		public PayloadBuilder withNoPayload() {
			EmptyPayload anEmptyPayload = new EmptyPayload();
			return new PayloadBuilder(correlationId, tenantId, author, date, domainEvent, context, anEmptyPayload);
		}
	}
	
	public static class PayloadBuilder {
		private String correlationId;
		private String tenantId;
		private Resource author;
		private Date date;
		private DomainEvent domainEvent;
		private Collection<Resource> context = new ArrayList<>();
		private Object payload;
		
		// private constructor, can only be created from Builder class
		private PayloadBuilder(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent, Collection<Resource> context, Object payload) {
			this.correlationId = correlationId;
			this.tenantId = tenantId;
			this.author = author;
			this.date = date;
			this.domainEvent = domainEvent;
			this.context = context;
			this.payload = payload;
		}

		public EssentialEventNotification build() {
			return new EssentialEventNotification(correlationId, tenantId, author, date, domainEvent, context, payload);
		}
	}
	
	public static class PayloadBuilderFromBeforeAndAfterAttributes {
		private String correlationId;
		private String tenantId;
		private Resource author;
		private Date date;
		private DomainEvent domainEvent;
		private Collection<Resource> context = new ArrayList<>();
		private Map<String, Object> mapAttributeToBeforeValues = new HashMap<>();
		private Map<String, Object> mapAttributeToAfterValues = new HashMap<>();
		
		// private constructor, can only be created from Builder class
		private PayloadBuilderFromBeforeAndAfterAttributes(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent, Collection<Resource> context) {
			this.correlationId = correlationId;
			this.tenantId = tenantId;
			this.author = author;
			this.date = date;
			this.domainEvent = domainEvent;
			this.context = context;
		}
		
		public PayloadBuilderFromBeforeAndAfterAttributes withPayloadBeforeAndAfterAttributeValues(String attributeName, Object beforeValue, Object afterValue) {
			mapAttributeToBeforeValues.put(attributeName, beforeValue);
			mapAttributeToAfterValues.put(attributeName, afterValue);
			return this;
		}

		public PayloadBuilderWithValidatedBeforeAndAfterAttributes validatePayloadValuesChanged() {
			for (Entry<String, Object> aBeforeEntry : mapAttributeToBeforeValues.entrySet()) {
				String aKey = aBeforeEntry.getKey();
				Object aBeforeValue = aBeforeEntry.getValue();
				Object anAfterValue = mapAttributeToAfterValues.get(aKey);
				if (aBeforeValue.equals(anAfterValue)) {
					throw new BeforeAndAfterValuesTheSameException("Payload before and after values are the same for attribute: "+aKey);
				}
			}
			return new PayloadBuilderWithValidatedBeforeAndAfterAttributes(correlationId, tenantId, author, date, domainEvent, context, mapAttributeToBeforeValues, mapAttributeToAfterValues);
		}
	}
	
	
	public static class PayloadBuilderWithValidatedBeforeAndAfterAttributes {
		private String correlationId;
		private String tenantId;
		private Resource author;
		private Date date;
		private DomainEvent domainEvent;
		private Collection<Resource> context = new ArrayList<>();
		private Map<String, Object> mapAttributeToBeforeValues = new HashMap<>();
		private Map<String, Object> mapAttributeToAfterValues = new HashMap<>();
		
		// private constructor, can only be created from Builder class
		private PayloadBuilderWithValidatedBeforeAndAfterAttributes(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent, Collection<Resource> context, Map<String, Object> mapAttributeToBeforeValues, Map<String, Object> mapAttributeToAfterValues) {
			this.correlationId = correlationId;
			this.tenantId = tenantId;
			this.author = author;
			this.date = date;
			this.domainEvent = domainEvent;
			this.context = context;
			this.mapAttributeToBeforeValues = mapAttributeToBeforeValues;
			this.mapAttributeToAfterValues = mapAttributeToAfterValues;
		}
		
		public EssentialEventNotification build() {
			// construct payload from attribute maps
			Map<String, Map<String, Object>> aPayloadMap = new HashMap<>();
			Map<String, Object> aBeforePayload = new HashMap<>();
			Map<String, Object> anAfterPayload = new HashMap<>();
			aPayloadMap.put("before", aBeforePayload);
			aPayloadMap.put("after", anAfterPayload);
			for (Entry<String, Object> aBeforeEntry : mapAttributeToBeforeValues.entrySet()) {
				aBeforePayload.put(aBeforeEntry.getKey(), aBeforeEntry.getValue());
			}
			for (Entry<String, Object> anAfterEntry : mapAttributeToAfterValues.entrySet()) {
				anAfterPayload.put(anAfterEntry.getKey(), anAfterEntry.getValue());
			}
			return new EssentialEventNotification(correlationId, tenantId, author, date, domainEvent, context, aPayloadMap);
		}
	}
	
	public static class PayloadBuilderFromAttributes {
		private String correlationId;
		private String tenantId;
		private Resource author;
		private Date date;
		private DomainEvent domainEvent;
		private Collection<Resource> context = new ArrayList<>();
		private Map<String, Object> mapAttributeToValues = new HashMap<>();
		
		// private constructor, can only be created from Builder class
		private PayloadBuilderFromAttributes(String correlationId, String tenantId, Resource author, Date date, DomainEvent domainEvent, Collection<Resource> context) {
			this.correlationId = correlationId;
			this.tenantId = tenantId;
			this.author = author;
			this.date = date;
			this.domainEvent = domainEvent;
			this.context = context;
		}
		
		public PayloadBuilderFromAttributes withPayloadAttributeValues(String attributeName, Object value) {
			mapAttributeToValues.put(attributeName, value);
			return this;
		}
		
		public EssentialEventNotification build() {
			return new EssentialEventNotification(correlationId, tenantId, author, date, domainEvent, context, mapAttributeToValues);
		}
	}
	
	
	
	
	/******************************************************************************************************
	 * Public methods
	 *******************************************************************************************************/

	// private constructor, can only be created from PayloadBuilder class
	private EssentialEventNotification(
				String correlationId, 
				String tenantId, 
				Resource author, 
				Date date, 
				DomainEvent domainEvent,
				Collection<Resource> context,
				Object payload
			) {
		this.correlationId = correlationId;
		this.tenantId = tenantId;
		this.author = author;
		this.date = date;
		this.domain = domainEvent.getDomain();
		this.event = domainEvent.getEvent();
		this.context = context;
		this.payload = payload;
	};

	public String getCorrelationId() {
		return correlationId;
	}

	public String getTenantId() {
		return tenantId;
	}

	public Resource getAuthor() {
		return author;
	}
	
	public String getDate() {
		return itsSdf.format(date);
	}

	public String getDomain() {
		return domain.toString();
	}

	public String getEvent() {
		return event.toString();
	}

	public Collection<Resource> getContext() {
		return context;
	}

	public Object getPayload() {
		return payload;
	}
	
	public void setTimestamp(Date timestamp) {
		this.date = timestamp;
	}


}
