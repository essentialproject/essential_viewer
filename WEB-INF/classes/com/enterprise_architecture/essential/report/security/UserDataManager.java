/**
 * Copyright (c)2015-2017 Enterprise Architecture Solutions ltd.
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
 * 01.04.2015	JWC	First coding 
 * 12.07.2017	JWC Updated for user information in Neo4J Graph DB
 * 21.07.2017	DK / JWC Completed Graph DB / remove Stormpath
 */
package com.enterprise_architecture.essential.report.security;

import static org.neo4j.driver.v1.Values.parameters;

import java.io.StringWriter;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.enterprise_architecture.essential.vieweruserdata.ClassificationTypeValues;
import org.enterprise_architecture.essential.vieweruserdata.ClearanceList;
import org.enterprise_architecture.essential.vieweruserdata.ClearanceType;
import org.enterprise_architecture.essential.vieweruserdata.User;
import org.enterprise_architecture.essential.vieweruserdata.ViewerURLList;
import org.neo4j.driver.v1.Record;
import org.neo4j.driver.v1.Session;
import org.neo4j.driver.v1.StatementResult;

import com.enterprise_architecture.easdatamanagement.model.UserProfile;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Manage user data between JSON from Stormpath and the XML used by Secure Viewer Engine
 * @author Jonathan Carter
 *
 */
public class UserDataManager 
{
	protected User itsXMLData;
	
	protected final static String XML_USER_DATA_PACKAGE = "org.enterprise_architecture.essential.vieweruserdata";
	
	/**
	 * Default constructor, initialises the attributes
	 */
	public UserDataManager() 
	{
		itsXMLData = new User();
	}

	/**
	 * Constructor that takes a Stormpath Account and reads it into this object, from where it can be marshalled into
	 * XML
	 * @param theIdpAccount the Identity provider (Stormpath) user account
	 * @param theGraphDBSession a session open to the GraphDB
	 * @param theGraphUserId the user ID within the GraphDB
	 */
	public UserDataManager(Session theGraphDBSession, String theGraphUserId)
	{
		itsXMLData = new User();
		itsXMLData.setEmail("");
		itsXMLData.setFirstname("");
		itsXMLData.setLastname("");
		// Get the user's unique ID
		// Get the IdP account 
		itsXMLData.setUri(theGraphUserId);
		
		// Get the tenant ID to which this Account belongs	
		// Using aTenantName and the aURI find the user UUID in our Graph
		
		// Get the allowed viewers
		getViewersForUser(theGraphUserId, theGraphDBSession);
		
		// Get the user clearance levels
		getClearanceForUser(theGraphUserId, theGraphDBSession);
	}

	/**
	 * Constructor that takes a Stormpath Account and reads it into this object, from where it can be marshalled into
	 * XML
	 * @param theIdpAccount the Identity provider (Stormpath) user account
	 * @param theGraphDBSession a session open to the GraphDB
	 * @param theGraphUserId the user ID within the GraphDB
	 */
	public UserDataManager(Session theGraphDBSession, String theGraphUserId, UserProfile theUserProfile)
	{
		itsXMLData = new User();
		itsXMLData.setEmail(theUserProfile.getEmail());
		itsXMLData.setFirstname(theUserProfile.getFirstName());
		itsXMLData.setLastname(theUserProfile.getLastName());
		// Get the user's unique ID
		// Get the IdP account 
		itsXMLData.setUri(theGraphUserId);
		
		// Get the tenant ID to which this Account belongs	
		// Using aTenantName and the aURI find the user UUID in our Graph
		
		// Get the allowed viewers
		getViewersForUser(theGraphUserId, theGraphDBSession);
		
		// Get the user clearance levels
		getClearanceForUser(theGraphUserId, theGraphDBSession);
	}
	
	/**
	 * Get the XML representation of the UserData that is used by the Viewer
	 * @return an XML document conforming to the vieweruserdata.xsd schema
	 */
	public String getUserXML()
	{
		// De-marshall itsXMLData into XML string
		String anXMLUser = "";
		StringWriter anXMLWriter = new StringWriter();
		try
		{
			JAXBContext aContext = JAXBContext.newInstance(XML_USER_DATA_PACKAGE);
			Marshaller aMarshaller = aContext.createMarshaller();
			aMarshaller.marshal(itsXMLData, anXMLWriter);
			anXMLUser = anXMLWriter.toString();
		}
		catch (JAXBException aJaxbEx)
		{
			System.err.println("SecureViewer: Error marshalling user account data");
			System.err.println("Message: " + aJaxbEx.getLocalizedMessage());
			aJaxbEx.printStackTrace();
		}		
		catch (IllegalArgumentException anIllegalArgEx)
		{
			System.err.println("SecureViewer: Error marshalling user account data");
			System.err.println("Message: " + anIllegalArgEx.getLocalizedMessage());
			anIllegalArgEx.printStackTrace();
		}
		return anXMLUser;
	}
	
	/**
	 * From the specified Graph User Id, find the first name and last name and
	 * set the corresponding values in itsXMLData
	 * @param theGraphUserId
	 */
	protected void getUserFirstNameAndLastName(String theGraphUserId, Session theGraphDBSession)
	{		
		// Query the GraphDB, using theGraphDBSession
		StatementResult aResult = theGraphDBSession.run("MATCH (u:User) WHERE u.uuid={userUuid} RETURN u.firstName as firstName, u.lastName as lastName", 
													  	parameters("userUuid", theGraphUserId));
		
		// Read the result set to validate user has permission to access the repository
		// If there is content in the result, then user has permission. If empty set, then no permission. 
		if (aResult.hasNext()) 
		{
			Record aRecord = aResult.next();
			itsXMLData.setFirstname(aRecord.get("firstName").asString());
			itsXMLData.setLastname(aRecord.get("lastName").asString());
			// DEbug test code
			//System.out.println("Found user has permission to publish to repository: " + aRecord.get("firstName").asString() + " " + aRecord.get("lastName").asString());
			// We only need one valid record for success			
		}
	}
	
	/** From the specified Graph User ID, find the set of Viewers that are available to this
	 * user.
	 * @param theGraphUserId
	 * @param theGraphDBSession
	 */
	protected void getViewersForUser(String theGraphUserId, Session theGraphDBSession)
	{
		// Query the Graph DB, using theGraphDBSession
		StatementResult aResult = theGraphDBSession.run("MATCH (u:User)-[:HAS_VIEWER_SETTINGS]->(vs:ViewerSettings{status:'ACTIVE'})-[:BELONGS_TO_VIEWER]->(v:Viewer) " + 
													   "WHERE u.uuid={userUuid} " +
													   "RETURN v.url AS url", 
													   parameters("userUuid", theGraphUserId));

		// Read the result set and load these results into itsXMLData
		ViewerURLList aViewerURLList = new ViewerURLList();
		while (aResult.hasNext()) 
		{
			Record aRecord = aResult.next();
			String aViewerURL = aRecord.get("url").asString();
			aViewerURLList.getViewer().add(aViewerURL);
			//System.out.println("User has viewer: " + aRecord.get("url").asString());
		}
		itsXMLData.setViewers(aViewerURLList);
	}
	
	/** From the specified Graph User ID, find the set of clearances that have been assigned to 
	 * this user
	 * @param theGraphUserId
	 * @param theGraphDBSession
	 */
	protected void getClearanceForUser(String theGraphUserId, Session theGraphDBSession)
	{
		// Query the GraphDB to get all the clearances that this user has for all repositories
		StatementResult aResult = theGraphDBSession.run("MATCH (u:User)-[:HAS_REPOSITORY_SETTINGS]->(rs:RepositorySettings)-[:BELONGS_TO_REPOSITORY]->(r:Repository) " +
														"WHERE u.uuid={userUuid} " +
														"RETURN rs.readClearance as readClearance, rs.editClearance as editClearance, r.uuid as repoId",
														parameters("userUuid", theGraphUserId));
		
		// Read the result set and load itsXMLData with the clearance levels for repositories returned
		ClearanceList aUserClearance = new ClearanceList();
		
		// Iterate through the result set to build the ClearanceList
		while(aResult.hasNext())
		{
			Record aRecord = aResult.next();
			String aRepository = aRecord.get("repoId").asString();
			
			// Get the READ clearance levels			
			String aReadClearanceMap = aRecord.get("readClearance").asString();
			marshallClearanceAndAddToList(aUserClearance, aRepository, aReadClearanceMap, ClassificationTypeValues.READ);
			
			// Read the EDIT clearance levels
			String anEditClearanceMap = aRecord.get("editClearance").asString();
			marshallClearanceAndAddToList(aUserClearance, aRepository, anEditClearanceMap, ClassificationTypeValues.EDIT);
		}
		// Capture this in the user XML
		itsXMLData.setClearanceList(aUserClearance);
	}

	private void marshallClearanceAndAddToList(ClearanceList theUserClearance, String theRepository, String theClearanceMap, ClassificationTypeValues theClassificationType)
	{
		try
		{
			ObjectMapper mapper = new ObjectMapper();
			@SuppressWarnings("unchecked")
			Map<String, String> aReadMap = mapper.readValue(theClearanceMap, Map.class);
			if(aReadMap != null) //required to deal with 'null' value returned 
			{
				Set<Entry<String, String>> entries = aReadMap.entrySet();
				for (Entry<String, String> entry : entries) 
				{
					ClearanceType aReadClearance = new ClearanceType(); 
					aReadClearance.setRepository(theRepository);
					aReadClearance.setType(theClassificationType);
					aReadClearance.setGroup(entry.getKey());
					aReadClearance.setLevel(entry.getValue());
					theUserClearance.getClearance().add(aReadClearance);
				}
			}
		}
		catch(Exception anEx)
		{
			System.err.println("SecureViewer: Error marshalling user "+theClassificationType.value()+" clearance data");
			System.err.println("Message: " + anEx.getLocalizedMessage());
			anEx.printStackTrace();
		}
	}

}
