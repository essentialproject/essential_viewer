<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" >
	<!--
        * Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
    -->
	<!-- 29.11.2011 JP - A set of utility templates that can be used by many other templates -->

	
	<xsl:param name="globalEAContentOwnerRoleXML"/>
	<xsl:param name="allFeedbackActor2RoleRelationsXML"/>
	<xsl:param name="allFeedbackActorsXML"/>
	<xsl:param name="allEAContentOwnersXML"/>
	<eas:apiRequests>
		
		{
			"apiRequestSet": [
				{
				"variable": "globalEAContentOwnerRoleXML",
				"query": "/instances/type/Individual_Business_Role/slots?name=Global EA Content Owner"
				},
				{
				"variable": "allFeedbackActor2RoleRelationsXML",
				"query": "/instances/type/ACTOR_TO_ROLE_RELATION"
				},
				{
				"variable": "allFeedbackActorsXML",
				"query": "/instances/type/Individual_Actor"
				},
				{
				"variable": "allEAContentOwnersXML",
				"query": "/instances/type/EA_Content_Owner"
				}
			]
		}
		
	</eas:apiRequests>
	<xsl:variable name="globalEAContentOwnerRole" select="$globalEAContentOwnerRoleXML//simple_instance"/>
	<xsl:variable name="allFeedbackActor2RoleRelations" select="$allFeedbackActor2RoleRelationsXML//simple_instance"/>
	<xsl:variable name="allFeedbackActors" select="$allFeedbackActorsXML//simple_instance"/>
	<xsl:variable name="allEAContentOwners" select="$allEAContentOwnersXML//simple_instance"/>
	<xsl:key name="contentOwnersKey" match="$allEAContentOwners" use="own_slot_value[slot_reference = 'owned_ea_content']/value"/>
	<xsl:key name="allFeedbackActor2RoleRelationsNameKey" match="$allFeedbackActor2RoleRelations" use="name"/>
	<xsl:key name="allFeedbackActor2RoleRelationsKey" match="$allFeedbackActor2RoleRelations" use="own_slot_value[slot_reference = 'act_to_role_to_role']/value"/>
	<xsl:key name="allFeedbackActorsNameKey" match="$allFeedbackActors" use="name"/>
	<!-- Get all ACTOR_TO_ROLE_RELATION  and Actor instances -->
	<!--<xsl:variable name="eaContentOwnerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference='name']/value = 'EA Content Owner')]"/>-->
	<!--<xsl:variable name="globalEAContentOwnerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Global EA Content Owner')]"/>
	<xsl:variable name="allFeedbackActor2RoleRelations" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allFeedbackActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>-->

	<!-- Get a list of Actors who are the content owners of given EA content -->
	<xsl:template name="GetContentOwnerEmailAddresses">
		<!-- @param: contentID - This is the ID of the EA instance against which the content owner actors need to be provided -->
		<xsl:param name="contentID"/>

		<!-- Get the specified content owner Actors for the given EA content -->
		<!--
			<xsl:variable name="contentOwners" select="$allEAContentOwners[own_slot_value[slot_reference = 'owned_ea_content']/value = $contentID]"/>
			<xsl:variable name="ownerActor2Roles" select="$allFeedbackActor2RoleRelations[name = $contentOwners/own_slot_value[slot_reference = 'owning_individual']/value]"/>
				
			<xsl:variable name="ownerActors" select="$allFeedbackActors[name = $ownerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		-->

		<xsl:variable name="contentOwners" select="key('contentOwnersKey', $contentID)"/>

		<xsl:variable name="ownerActor2Roles" select="key('allFeedbackActor2RoleRelationsNameKey', $contentOwners/own_slot_value[slot_reference = 'owning_individual']/value)"/>


		<xsl:variable name="ownerActors" select="key('allFeedbackActorsNameKey', $ownerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>

		<xsl:for-each select="$ownerActors">
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'email']/value"/>
			<xsl:if test="position() &lt; last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

	<!-- Get a list of Actors who are the global content owners -->
	<xsl:template name="GetGlobalContentOwnerEmailAddresses">

		<!-- Do the same for the Global Content Owners -->
		<!--
			<xsl:variable name="globalOwners" select="/node()/simple_instance[type = 'Global_EA_Content_Owner']"/>
			<xsl:variable name="globalActor2Roles" select="$allFeedbackActor2RoleRelations[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $globalEAContentOwnerRole/name]"/>
			<xsl:variable name="globalActors" select="$allFeedbackActors[name = $globalActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		-->
		<xsl:variable name="globalActor2Roles" select="key('allFeedbackActor2RoleRelationsKey',$globalEAContentOwnerRole/name)"/>
		
		<xsl:variable name="globalActors" select="key('allFeedbackActorsNameKey', $globalActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
		<xsl:for-each select="$globalActors">
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'email']/value"/>
			<xsl:if test="position() &lt; last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
