<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
 
 <xsl:variable name="dataSubjects" select="/node()/simple_instance[type='Data_Subject']"/>
 <xsl:key name="dataObjects" match="/node()/simple_instance[type='Data_Object']" use="own_slot_value[slot_reference = 'defined_by_data_subject']/value"/>
  <xsl:variable name="synonyms" select="/node()/simple_instance[type='Synonym']"/>
  <xsl:variable name="dataCategory" select="/node()/simple_instance[type='Data_Category']"/>
  <xsl:variable name="actors" select="/node()/simple_instance[type=('Group_Actor')]"/>
  <xsl:variable name="individual" select="/node()/simple_instance[type=('Individual_Actor')]"/>	
  <xsl:variable name="allActors" select="$actors union $individual"/>	
  <xsl:variable name="role" select="/node()/simple_instance[type=('Group_Business_Role','Individual_Business_Role')]"/>	
  <xsl:variable name="actor2Role" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]"/> 
  <xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
  <xsl:key name="roles_key" match="/node()/simple_instance[type='Individual_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
  <xsl:key name="grpactors_key" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
  <xsl:key name="grproles_key" match="/node()/simple_instance[type='Group_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
	<!--
		* Copyright © 2008-2019 Enterprise Architecture Solutions Limited.
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
	<!-- 03.09.2019 JP  Created	 -->
	 
	<xsl:template match="knowledge_base">
		{"data_subjects":[<xsl:apply-templates select="$dataSubjects" mode="dataSubjects"></xsl:apply-templates>],"version":"614"}
	</xsl:template>

 
 <xsl:template match="node()" mode="dataSubjects">
	 <xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	 <xsl:variable name="dos" select="key('dataObjects',current()/name)"/>
	 <xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
    <!-- last two need to be org roles as the slots have been deprecated -->
    {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	 "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	 "synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "dataObjects":[<xsl:for-each select="$dos">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
	 "category":"<xsl:value-of select="$dataCategory[name=current()/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value"/>",
	 "orgOwner":"<xsl:value-of select="$actors[name=current()/own_slot_value[slot_reference='data_subject_organisation_owner']/value]/own_slot_value[slot_reference='name']/value"/>",
	 "stakeholders":[<xsl:for-each select="$thisStakeholders">
                <xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
				<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
				<xsl:variable name="thisgrpActors" select="key('grpactors_key',current()/name)"/>
				<xsl:variable name="thisgrpRoles" select="key('grproles_key',current()/name)"/>
				<xsl:variable name="allthisActors" select="$thisActors union $thisgrpActors"/>
				<xsl:variable name="allthisRoles" select="$thisRoles union $thisgrpRoles"/>
				{"type": "<xsl:value-of select="$allthisActors/type"/>",
				"actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$allthisActors"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
                </xsl:call-template>",  
                "actorId":"<xsl:value-of select="eas:getSafeJSString($allthisActors/name)"/>",
                "roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$allthisRoles"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
                </xsl:call-template>",  
                "roleId":"<xsl:value-of select="eas:getSafeJSString($allthisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>],
	 "indivOwner":"<xsl:value-of select="$individual[name=current()/own_slot_value[slot_reference='data_subject_individual_owner']/value]/own_slot_value[slot_reference='name']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
      
  </xsl:template>
	
</xsl:stylesheet>
 
 
