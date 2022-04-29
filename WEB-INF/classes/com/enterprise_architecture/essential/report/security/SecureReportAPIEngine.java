/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd.
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
 * 27.03.2020	JWC	First coding 
 */
package com.enterprise_architecture.essential.report.security;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.enterprise_architecture.essential.viewclassification.ClassificationType;
import org.enterprise_architecture.essential.viewclassification.Viewclassification;
import org.enterprise_architecture.essential.vieweruserdata.ClearanceList;
import org.enterprise_architecture.essential.vieweruserdata.ClearanceType;
import org.enterprise_architecture.essential.vieweruserdata.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.enterprise_architecture.essential.report.EssentialViewerEngine;
import com.enterprise_architecture.essential.report.ReportAPIEngine;
import com.enterprise_architecture.essential.report.ScriptXSSFilter;
import com.enterprise_architecture.essential.report.api.ApiErrorMessage;
import com.enterprise_architecture.essential.security.model.SecurityClassification;
import com.enterprise_architecture.essential.security.model.SecurityClassificationSet;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

/**
 * Report API Engine that applies fine-grained security to the rendering of Report APIs as they
 * are pulled from the cache
 * @author Jonathan Carter
 *
 */
public class SecureReportAPIEngine extends ReportAPIEngine 
{
	private static final Logger itsLog = LoggerFactory.getLogger(SecureReportAPIEngine.class);
	
	private static final String ERROR_USER_ACCOUNT_NOT_FOUND = "Could not find user account in current session";
	
	private static final String SECURITY_CLASSIFICATIONS_ATTRIBUTE_NAME = "securityClassifications";

	private static final Object INVALID_JSON_VALUE_MESSAGE = "** INVALID JSON VALUE **";
	
	protected String itsContextPath = "/";
	
	protected ViewerSecurityManager itsSecurityMgr;
	
	public SecureReportAPIEngine(ServletContext theServletContext)
	{
		super(theServletContext);
		
		// Connect to the security manager
		itsSecurityMgr = getSecurityManager();
		
		// Get and save context path
		String aFileSep = System.getProperty("file.separator");
		itsContextPath = itsServletContext.getRealPath("") + aFileSep;
		
		itsLog.debug("Constructed SecureReportAPIEngine");
	}
	
	/**
	 * Apply security to the generation/retrieval of the Report API. Check user is authorised to perform this operation
	 * and force login if the user has not already authenticated.
	 * 
	 * @param theRequest
	 * @param theResponse
	 * @param theViewerEngine
	 * @param theResultString
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */	
	public boolean generateReportAPI(HttpServletRequest theRequest,
									 HttpServletResponse theResponse,
									 EssentialViewerEngine theViewerEngine,
									 StringWriter theResultString) throws ServletException, IOException
	{
		boolean isSuccess = true;
		
		itsLog.debug("In SECURE version of generateReportAPI. ViewerEngine type: {}", theViewerEngine.getClass().getName());
		SecureEssentialViewerEngine aSecureViewer = (SecureEssentialViewerEngine) theViewerEngine;
		
		itsLog.debug("Revised approach to override implemented. Cast the received Viewer Engine.");
		// Apply User AuthN / AuthZ now (this is the entry point) or defer to theViewerEngine?
		// Get the Viewer's ViewClassifications
		
		// Have to apply now as we may be pulling from the cache.
		// Check user access to the Viewer
		
		// Get user account URL from session
		String anAccount = itsSecurityMgr.authenticateUserBySession(theRequest, theResponse);
		itsLog.debug("Authenticate attempt via session, got account object.");
		
		// Have URL - test authorisation
		// Get the selected View from the request			
		String aRequestedTemplate = ScriptXSSFilter.filter(theRequest.getParameter("XSL"));
		String aRepositoryXML = ScriptXSSFilter.filter(theRequest.getParameter("XML"));					
		
		// If no Account is in the session - report an error and stop
		if(anAccount == null)
		{
			// User is not yet authenticated, so redirect to login servlet
			itsLog.error("Null user account");
			reportSecurityError(theResultString, 403, ERROR_USER_ACCOUNT_NOT_FOUND);			
			isSuccess = false;
			return isSuccess;
		}
		
		// Get the repository ID
		String aSourceDocPath = aSecureViewer.getRepositoryXMLPath(aRepositoryXML);
		String aReposID = aSecureViewer.getRepositoryID(theRequest, theResponse, aSourceDocPath, itsContextPath);
		
		// Get full path to this application - removing the servlet path to drop '/report' if it's included
		itsLog.debug("SecureViewer: Checking for authorisation for Viewer: {}", theRequest.getRequestURL().toString());		
		String aRequestURL = theRequest.getRequestURL().toString();
		if(aRequestURL.endsWith("/reportApi"))
		{
			itsLog.debug("SecureViewer: Removing any trailing /report characters from URL");		
			aRequestURL = aRequestURL.replace(theRequest.getServletPath(), "");
		}
		else if(aRequestURL.endsWith("/"))
		{
			itsLog.debug("SecureViewer: Removing any trailing / characters from URL");			
			aRequestURL = aRequestURL.substring(0, aRequestURL.length()-1);
		}

		itsLog.debug("SecureViewer: Authorising for URL: {}", aRequestURL);		
		if(itsSecurityMgr.isUserAuthorisedForViewer(anAccount, aReposID, aRequestURL))
		{
			itsLog.debug("SecureViewer: TRACE == User authorised to access viewer for specified repository");			
			// If access allowed, continue
			
			// Check user is allowed to View the selected view.			
			if(aSecureViewer.isUserAuthZForView(theRequest, theResponse, aRequestedTemplate, aRepositoryXML, itsSecurityMgr))
			{
				itsLog.debug("SecureReportAPI: User authZ-ed for specified View: {}", aRequestedTemplate);
				// Here is where we call up the base ReportAPICache to get the unfiltered view
				StringWriter anUnfilteredAPIWriter = new StringWriter();
				isSuccess = super.generateReportAPI(theRequest, theResponse, aSecureViewer, anUnfilteredAPIWriter);
				
				itsLog.debug("Got or rendered Report Api. Size: {} chars", anUnfilteredAPIWriter.toString().length());
				// Got the Report API View, now filter it
				// Get the user custom data XML
				String aUserData = itsSecurityMgr.getUserData(theRequest, theResponse);
				itsLog.debug("Got user profile XML: {}", aUserData);
				String aFilteredJson = applySecurityFilter(aUserData, anUnfilteredAPIWriter.toString(), getViewClassifications(), aReposID);
				
				// Write the filtered content to theResultString
				theResultString.write(aFilteredJson);
			}
			else
			{
				reportSecurityError(theResultString, 403, SecureEssentialViewerEngine.ACCESS_DENIED_VIEW);
				isSuccess = true;
				return isSuccess;
			}
		}
		else
		{
			reportSecurityError(theResultString, 403, SecureEssentialViewerEngine.ACCESS_DENIED_VIEW);			
			isSuccess = true;
			return isSuccess;
		}
		
		return isSuccess;
	}
	
	/**
	 * Apply the security filters as defined in theUnfilteredJson for this specific user
	 * according to their clearance levels
	 * @param theUserDataXML
	 * @param theUnfilteredJson
	 * @param theSecurityClassifications
	 * @param theRepositoryId
	 * @return the filtered JSON removing all elements for which the user is not cleared
	 */
	protected String applySecurityFilter(String theUserDataXML, 
										 String theUnfilteredJson, 
										 Viewclassification theSecurityClassifications,
										 String theRepositoryId)
	{
		String aFilteredJson = "";
		
		// Process theUnfilteredJson to remove elements for which the user has no clearance
		try
		{
			// Unmarshall the User XML
			JAXBContext aJaxbContext = JAXBContext.newInstance(User.class);
			Unmarshaller aUserUnMarshaller = aJaxbContext.createUnmarshaller();
			User aUser = (User) aUserUnMarshaller.unmarshal(new StringReader(theUserDataXML));
			itsLog.debug("Unmarshalled XML into User object. URI: {}", aUser.getUri());
			
			// Parse the Json into a HashMap, filtering out all content that the user is not cleared for
			HashMap<String, Object> aFilteredJsonMap = filterJson(aUser, 
																  theUnfilteredJson, 
																  theSecurityClassifications,
																  theRepositoryId);
			itsLog.debug("Filtered JSON into HashMap. Has {} elements", aFilteredJsonMap.size());
			
			// Now have a HashMap containing the content for the specific user
			// Render it back to JSON 
			Gson aJsonResult = new Gson();
			aFilteredJson = aJsonResult.toJson(aFilteredJsonMap);
			
			// and return it
			itsLog.debug("Filtered JSON is {}", aFilteredJson);
		}
		catch(Exception ex)
		{
			itsLog.error("Exception whilst parsing the User account details from Session: {}", ex);
		}
		return aFilteredJson;
	}
	
	/**
	 * Filter theJsonString by applying a test for the user's security clearance against each 
	 * node's security classification
	 * @param theUserProfile the user's profile, including their clearance levels
	 * @param theJsonString the JSON for which user clearance is being tested
	 * @param theSecurityClassifications the current security classifications for the current repository
	 * @param theRepositoryId the ID of the repository that is in the current Viewer snapshot
	 * @return the filtered JSON as a HashMap
	 */
	protected HashMap<String, Object> filterJson(User theUserProfile, 
												 String theJsonString,
												 Viewclassification theSecurityClassifications,
												 String theRepositoryId)
	{
		itsLog.debug("Parsing JSON String: {}", theJsonString);
		HashMap<String, Object> aMap = new HashMap<String, Object>();		
		try
		{
			JsonElement anElement = JsonParser.parseString(theJsonString);
			JsonObject anObject = anElement.getAsJsonObject();
			Set<Map.Entry<String, JsonElement>> aNodeSet = anObject.entrySet();
			Iterator<Map.Entry<String, JsonElement>> anIterator = aNodeSet.iterator();
			 
			// Iterate through theJsonString, testing theUserProfile's access
			while(anIterator.hasNext())
			{
				Map.Entry<String, JsonElement> anEntry = anIterator.next();
				String aKey = anEntry.getKey();
				JsonElement aValue = anEntry.getValue();
				 
				if(null != aValue)
				{
					if(!aValue.isJsonPrimitive())
					{
						// We have a JsonElement. Test it's security before adding it to the HashMap
						if(aValue.isJsonObject())
						{
							// Test the securityClassifications attribute of the node/JsonElement 
							boolean isUserCleared = isUserClearedForJsonElement(theUserProfile, getSecuredJsonNode(aValue), theSecurityClassifications, theRepositoryId);
							 
							// Only if authZ do we copy the element into aMap and continue down the tree
							if(isUserCleared)
							{
								itsLog.debug("Adding cleared element");
								aMap.put(aKey, filterJson(theUserProfile, aValue.toString(), theSecurityClassifications, theRepositoryId));
							}							
						}
						else if(aValue.isJsonArray() && aValue.toString().contains(":"))
						{
							// Iterator through the array and test the securityClassifications of each object in the array
							List<HashMap<String, Object>> aList = new ArrayList<HashMap<String, Object>>();
							JsonArray aJsonArray = aValue.getAsJsonArray();
							if(null != aJsonArray)
							{
								for(JsonElement aJsonArrayElement : aJsonArray)
								{
									boolean isUserClearedForElement = isUserClearedForJsonElement(theUserProfile, getSecuredJsonNode(aJsonArrayElement), theSecurityClassifications, theRepositoryId);
									if(isUserClearedForElement)
									{
										itsLog.debug("User cleared for element in array...");
										aList.add(filterJson(theUserProfile, aJsonArrayElement.toString(), theSecurityClassifications, theRepositoryId));
									}									
								}
								 
								// Add the resulting list of objects into the HashMap
								itsLog.debug("Adding list to HashMap. Size: {}", aList.size());
								aMap.put(aKey, aList);						
							}
						}
						else if(aValue.isJsonArray() && !aValue.toString().contains(":"))
						{
							// A plain JsonArray, with no objects cannot have a security classification
							itsLog.debug("Adding a plain array - no objects - to HashMap");
							aMap.put(aKey, aValue.getAsJsonArray());
						}
					}
					else
					{
						// It's a primitive entry that has no security classification
						// Make sure to render in the correct format/type
						JsonPrimitive aPrimitive = aValue.getAsJsonPrimitive();
						if(aPrimitive.isString())
						{
							aMap.put(aKey, aValue.getAsString());
						}
						else if(aPrimitive.isNumber())
						{
							aMap.put(aKey, unwrapNumber(aValue.getAsNumber()));
						}
						else if(aPrimitive.isBoolean())
						{							
							aMap.put(aKey, aValue.getAsBoolean());
						}
						else 
						{
							// It's not a string, number or boolean, so it can't be good.
							aMap.put(aKey, INVALID_JSON_VALUE_MESSAGE);
						}				
					}
				}
			}
		}
		catch(Exception anEx)
		{
			itsLog.error("Exception whilst parsing ReportAPI JSON: {}", anEx);
		}
		// Post-process the map to remove all "securityClassifications" elements 
		itsLog.debug("Removing the security classifications element");
		aMap.remove(SECURITY_CLASSIFICATIONS_ATTRIBUTE_NAME);
		
		return aMap;
	}
	
	/**
	 * Find the index of the classification level in the set of current security classifications.
	 * @param theClassification
	 * @param theSecurityClassifications
	 * @return empty string if classification has a level/group that does not match the defined classifications
	 */
	protected String getClassificationIndex(SecurityClassification theClassification, Viewclassification theSecurityClassifications)
	{
		String aClearanceIndex = "";
		Iterator<ClassificationType> aClassificationTypeIt = theSecurityClassifications.getClassificationGroups().getClassification().iterator();
		while(aClassificationTypeIt.hasNext())
		{
			ClassificationType aClassification = aClassificationTypeIt.next();
			String aGroup = aClassification.getGroup();
			String aLevel = aClassification.getLevel();
			String anIndex = aClassification.getIndex();
			
			// Is this the correct group/level combo?
			if(theClassification.getGroup().equals(aGroup) &&
			   theClassification.getLevel().equals(aLevel))
			{
				aClearanceIndex = anIndex;
				break;
			}
		}
		
		return aClearanceIndex;
	}
	
	/**
	 * Find the index of the user's clearance level in the set of current security classifications.
	 * @param theClearance
	 * @param theSecurityClassifications
	 * @return empty string if user has no clearance levels that match these classifications
	 */
	protected String getClearanceIndex(ClearanceType theClearance, Viewclassification theSecurityClassifications)
	{
		String aClearanceIndex = "";
		Iterator<ClassificationType> aClassificationTypeIt = theSecurityClassifications.getClassificationGroups().getClassification().iterator();
		while(aClassificationTypeIt.hasNext())
		{
			ClassificationType aClassification = aClassificationTypeIt.next();
			String aGroup = aClassification.getGroup();
			String aLevel = aClassification.getLevel();
			String anIndex = aClassification.getIndex();
			
			// Is this the correct group/level combo?
			if(theClearance.getGroup().equals(aGroup) &&
			   theClearance.getLevel().equals(aLevel))
			{
				aClearanceIndex = anIndex;
				break;
			}
		}
		
		return aClearanceIndex;
	}
	
	/**
	 * Map a JsonElement, representing a node in the Json Tree that is being evaluating for user clearance,
	 * to a POJO that represents the classifications of this JsonElement.
	 * @param theJson the element that is being tested for clearance
	 * @return a POJO that holds the security classifications
	 */
	protected SecurityClassificationSet getSecuredJsonNode(JsonElement theJson)
	{
		SecurityClassificationSet aSecuredJsonNode = null;
		try
		{
			ObjectMapper aJacksonMapper = new ObjectMapper();
			aSecuredJsonNode = (SecurityClassificationSet) aJacksonMapper.readValue(theJson.toString(), SecurityClassificationSet.class);			 
		}
		catch(Exception anEx)
		{
			itsLog.error("Error parsing JsonElement into a SecuredJsonNode POJO: {}", anEx);
		}
		if(aSecuredJsonNode != null)
		{
			itsLog.debug("Getting security classifications for element: {}, Classification count: {}", theJson.toString(), aSecuredJsonNode.getSecurityClassifications().size());
		}
		return aSecuredJsonNode;
	}
	
	/** 
	 * Manage a singleton of the ViewerSecurityManager so that we can share and close the Neo4J connections
	 *  
	 * @return
	 */
	protected ViewerSecurityManager getSecurityManager()
	{
		ViewerSecurityManager aSecurityManager = (ViewerSecurityManager) itsServletContext.getAttribute(SecureEssentialViewerEngine.VIEWER_SECURITY_MANAGER_SINGLETON_VARNAME);
		if(null == aSecurityManager)
		{
			// Create a new instance of the singleton
			aSecurityManager = new ViewerSecurityManager(itsServletContext);
			
			// Save it in the ServletContext
			itsServletContext.setAttribute(SecureEssentialViewerEngine.VIEWER_SECURITY_MANAGER_SINGLETON_VARNAME, aSecurityManager);
		}
		
		return aSecurityManager;
	}
	
	/**
	 * Manage access to the current Viewer's security classifications
	 * @return a POJO containing the security classifications and default classification (if set) for the current
	 * Viewer snapshot
	 * 
	 */
	protected Viewclassification getViewClassifications()
	{		
		Viewclassification aViewClassifications = null;
		
		// Compute the Viewer Classifications object
		// Get the XML String from the application singleton
		String aViewSecurityConfig = (String)itsServletContext.getAttribute(SecureEssentialViewerEngine.VIEW_SECURITY_CONFIG);
		
		if(aViewSecurityConfig == null || aViewSecurityConfig.length() == 0)
		{
			// Report a scenario that should NOT happen
			itsLog.error("No View Classification XML found. This should not happen!");
		}
		
		// Parse the XML into a SecurityClassifications object
		try
		{
			JAXBContext aJaxbContext = JAXBContext.newInstance(Viewclassification.class);
			Unmarshaller anUnMarshaller = aJaxbContext.createUnmarshaller();
			aViewClassifications = (Viewclassification) anUnMarshaller.unmarshal(new StringReader(aViewSecurityConfig));
		}
		catch(Exception anEx)
		{
			itsLog.error("Exception whilst parsing Viewer Security classificaitons: {}", anEx);
		}
		
		return aViewClassifications;
	}
	
	/**
	 * Get the ID of the repository that is rendered in the current Viewer snapshot
	 * @return
	 */
	protected String getViewerRepositoryID()
	{
		// Get the current repository ID
		String aViewerRepositoryID = (String)itsServletContext.getAttribute(SecureEssentialViewerEngine.VIEWER_REPOSITORY_ID);
		
		return aViewerRepositoryID;
	}
	
	/**
	 * Check whether theUser is cleared for the theClassification
	 *  
	 * @param theUser the user profile information
	 * @param theClassification the security classification to test for clearance
	 * @param theSecurityClassifications the set of classifications available in the current viewer
	 * repository snapshot
	 * @param theRepositoryId the ID of the repository in the current viewer snapshot
	 * @return true if the user is cleared for the specified classification. False otherwise.
	 */
	protected boolean isUserClearedForClassification(User theUser, 
													 SecurityClassification theClassification,
													 Viewclassification theSecurityClassifications,
													 String theRepositoryId)
	{
		boolean isClearedForClassification = false;
		String aSecurityGroup = theClassification.getGroup();
		String aSecurityLevel = theClassification.getLevel();	
		String aSecurityIndex = theClassification.getIndex();
		itsLog.debug("Testing user clearance for classfication: Group: {}, Level: {}, Index: {}", aSecurityGroup, aSecurityLevel, aSecurityIndex);
		
		ClearanceList aUserClearanceList = theUser.getClearanceList();		
		Iterator<ClearanceType> aUserClearanceIt = aUserClearanceList.getClearance().iterator();		
		while(aUserClearanceIt.hasNext() && !isClearedForClassification)
		{
			ClearanceType aUserClearance = aUserClearanceIt.next();
			String aUserRepos = aUserClearance.getRepository();
			String aUserGroup = aUserClearance.getGroup();
			String aUserLevel = aUserClearance.getLevel();
			String aUserIndex = getClearanceIndex(aUserClearance, theSecurityClassifications);
			
			itsLog.debug("Testing User Clearance: Repository: {}, Group: {}, Level: {}, Index{}", aUserRepos, aUserGroup, aUserLevel, aUserIndex);
			// Test this clearance level against the classification
			if(aUserRepos.equals(theRepositoryId) &&
			   aUserGroup.equals(aSecurityGroup) &&
			   !aUserIndex.isEmpty() &&
			   !aSecurityIndex.isEmpty())
			{
				int aClassificationIndexValue = Integer.parseInt(aSecurityIndex);
				int aUserClearanceIndexValue = Integer.parseInt(aUserIndex);
				if(aUserClearanceIndexValue >= aClassificationIndexValue)
				{
					// If the user is cleared. Stop processing						
					isClearedForClassification = true;
					itsLog.debug(">>>>> User cleared for classfication: Clearance: {}", isClearedForClassification);
					break;
				}				
			}
		}
		
		return isClearedForClassification;
	}
	
	/**
	 * Is the user cleared to access anything that is classified by the default classification
	 * @param theUser
	 * @param theSecurityClassifications
	 * @param theRepositoryId the ID of the current repository snapshot in the Viewer
	 * @return true if user is cleared
	 */
	protected boolean isUserClearedForDefaultClassification(User theUser, 
															Viewclassification theSecurityClassifications,
															String theRepositoryId)
	{
		// By default, user is NOT cleared for access
		boolean isUserCleared = false;
		
		itsLog.debug("Testing user clearance against default classfications");
		
		// If there are no valid default classifications, then user is cleared
		if(theSecurityClassifications.getDefaultClassification() == null ||
		   theSecurityClassifications.getDefaultClassification().getReadClassification() == null ||
		   theSecurityClassifications.getDefaultClassification().getReadClassification().getLevel().isEmpty())
		{
			itsLog.debug("No default classifications defined, so user is cleared");
			isUserCleared = true;
		}
		else
		{
			// Evaluate the user's clearance against each classification.
			itsLog.debug("Testing user clearance against each default classification");			
			Iterator<ClearanceType> aUserClearanceIt = theUser.getClearanceList().getClearance().iterator();
			while(aUserClearanceIt.hasNext())
			{
				ClearanceType aUserClearance = aUserClearanceIt.next();				
				
				// Test each against the default classification
				ClassificationType aDefaultClassification = theSecurityClassifications.getDefaultClassification().getReadClassification();
				String aUserClearanceGroup = aUserClearance.getGroup();				
				String aUserClearanceRepository = aUserClearance.getRepository();
				
				itsLog.debug("Testing user clearance for repository: {} against current repository: {}", aUserClearanceRepository, theRepositoryId);
				// First test the repository attribute
				if(aUserClearanceRepository.equals(theRepositoryId))
				{
					// If any are a 'not cleared' then stop and return false
					String aDefaultGroup = aDefaultClassification.getGroup();
					String aDefaultIndex = aDefaultClassification.getIndex();
					
					itsLog.debug("Default classfication group: {}, level: {}, index: {}", aDefaultGroup, aDefaultClassification.getLevel(), aDefaultIndex);
					
					// Get the Indexes and compare values.
					String aUserClearanceIndex = getClearanceIndex(aUserClearance, theSecurityClassifications);
					itsLog.debug("User clearance group: {}, level: {}, index: {}", aUserClearanceGroup, aUserClearance.getLevel(), aUserClearanceIndex);
					if(aUserClearanceGroup.equals(aDefaultGroup) &&
					   !aUserClearanceIndex.isEmpty() &&
					   !aDefaultIndex.isEmpty())
					{
						int aDefaultIndexValue = Integer.parseInt(aDefaultClassification.getIndex());
						int aUserClearanceIndexValue = Integer.parseInt(aUserClearanceIndex);
						if(aUserClearanceIndexValue >= aDefaultIndexValue)
						{
							// If the user is cleared						
							isUserCleared = true;
							itsLog.debug(">>>>> User cleared for default classfication");
							break;
						}
					}						
				}
				
			}
			
		}
		
		return isUserCleared;		
	}
	
	/** 
	 * Is the user cleared to access a JsonElement that has the specified set of classifications?
	 * @param theUser object representing the user and their clearance levels
	 * @param theClassificationSet the set of classifications for which the user's clearance is to be tested
	 * @param theSecurityClassifications the full set of available classifications in the current repository snapshot in the
	 * viewer
	 * @param theRepositoryId the Id of the repository snapshot that the Viewer is using currently
	 * @return true if the user is cleared, false otherwise
	 */
	protected boolean isUserClearedForJsonElement(User theUser, 
												  SecurityClassificationSet theClassificationSet, 
												  Viewclassification theSecurityClassifications,
												  String theRepositoryId)	
	{
		// Default to true - so, if no classifications are found, the user is cleared for access 
		boolean isUserCleared = true;
		
		itsLog.debug("Testing user clearance");
		
		// If the secured Json for the node is empty, test against default classification.
		if(theClassificationSet == null || theClassificationSet.getSecurityClassifications().isEmpty())
		{
			itsLog.debug("No explicit classifications, using default classification...");
			return isUserClearedForDefaultClassification(theUser, theSecurityClassifications, theRepositoryId);
		}
		
		// Otherwise, we must now compare user clearance with each classification in the set
		//ClearanceList aUserClearanceList = theUser.getClearanceList();
		Iterator<SecurityClassification> aClassificationIt = theClassificationSet.getSecurityClassifications().iterator();
		while(aClassificationIt.hasNext() && isUserCleared)
		{
			SecurityClassification aClassification = aClassificationIt.next();
			String aSecurityGroup = aClassification.getGroup();
			String aSecurityLevel = aClassification.getLevel();	
			String aSecurityIndex = aClassification.getIndex();
			
			// Simplified by making sure the index is in the JSON document already...
			// Look up index of this classification as it won't be in the Json
			//String aClassificationIndex = getClassificationIndex(aClassification, theSecurityClassifications);			
			itsLog.debug("Testing Security Classification: Repository: {}, Group: {}, Level: {}, Index{}", theRepositoryId, aSecurityGroup, aSecurityLevel, aSecurityIndex);
			boolean isUserClearedForClassifcation = isUserClearedForClassification(theUser, 
																				   aClassification, 
																				   theSecurityClassifications,
																				   theRepositoryId);
			
			// If the user is not cleared for this classification, then they are not cleared for this object
			if(!isUserClearedForClassifcation)
			{
				itsLog.debug(">>>>> User not cleared.");
				isUserCleared = false;				
			}
		}
		
		return isUserCleared;
	}
	
	/**
	 * Render an error message JSON document
	 * 
	 * @param theResponseString the response string into which the error JSON will be written
	 * @param theErrorCode the error code
	 * @param theErrorMessage the error message
	 */
	protected void reportSecurityError(StringWriter theResponseString, int theErrorCode, String theErrorMessage)
	{
		ApiErrorMessage anErrorMessage = new ApiErrorMessage(theErrorCode, theErrorMessage);
		String anErrorResponse = writeErrorJson(anErrorMessage);
		itsLog.debug("Error message: {}", anErrorResponse);
		theResponseString.write(anErrorResponse);
	}

	/** 
	 * Methods borrowed from Google GsonJsonProvider class to identify and render numeric values
	 * correctly in output JSON
	*/
	/**
	 * Is n a primitive number?
	 * 
	 * @param the number to test
	 * @return true if type is Integer, Double, Long, BigDecimal, BigInteger
	 */
	private static boolean isPrimitiveNumber(final Number n) {
        return n instanceof Integer ||
                n instanceof Double ||
                n instanceof Long ||
                n instanceof BigDecimal ||
                n instanceof BigInteger;
    }
 
	/**
	 * Unpack a number element to render the underlying value correctly, 
	 * whether it is a form of integer or a form of floating point number.
	 * @param n
	 * @return
	 */
    private static Number unwrapNumber(final Number n) {
        Number unwrapped;
 
        if (!isPrimitiveNumber(n)) {
            BigDecimal bigDecimal = new BigDecimal(n.toString());
            if (bigDecimal.scale() <= 0) {
                if (bigDecimal.compareTo(new BigDecimal(Integer.MAX_VALUE)) <= 0) {
                    unwrapped = bigDecimal.intValue();
                } else if (bigDecimal.compareTo(new BigDecimal(Long.MAX_VALUE)) <= 0){
                    unwrapped = bigDecimal.longValue();
                } else {
                    unwrapped = bigDecimal;
                }
            } else {
                final double doubleValue = bigDecimal.doubleValue();
                if (BigDecimal.valueOf(doubleValue).compareTo(bigDecimal) != 0) {
                    unwrapped = bigDecimal;
                } else {
                    unwrapped = doubleValue;
                }
            }
        } else {
            unwrapped = n;
        }
        return unwrapped;
    }
}
