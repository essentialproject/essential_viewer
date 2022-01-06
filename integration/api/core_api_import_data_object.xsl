<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
 
 <xsl:variable name="dataSubjects" select="/node()/simple_instance[type='Data_Subject']"/>
  <xsl:variable name="dataObjects" select="/node()/simple_instance[type='Data_Object']"/>
  <xsl:variable name="synonyms" select="/node()/simple_instance[type='Synonym']"/>
  <xsl:variable name="dataCategory" select="/node()/simple_instance[type='Data_Category']"/>
<!--  <xsl:variable name="actors" select="/node()/simple_instance[type=('Group_Actor')]"/>
  <xsl:variable name="individual" select="/node()/simple_instance[type=('Individual_Actor')]"/>	
	
  <xsl:variable name="allActors" select="$actors union $individual"/>	
  <xsl:variable name="role" select="/node()/simple_instance[type=('Group_Business_Role','Individual_Business_Role')]"/>	
  <xsl:variable name="actor" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')][own_slot_value[slot_reference = 'act_to_role_from_actor']/value=$allActors/name]"/>  -->
	 
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
		{"data_objects":[<xsl:apply-templates select="$dataObjects" mode="dataObjects"></xsl:apply-templates>],"version":"614"}
	</xsl:template>

	 
 <xsl:template match="node()" mode="dataObjects">
	 <xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	 <xsl:variable name="parents" select="$dataSubjects[name=current()/own_slot_value[slot_reference='defined_by_data_subject']/value]"/>
    <!-- last two need to be org roles as the slots have been deprecated -->
    {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	 "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	 "synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
 	 "category":"<xsl:value-of select="$dataCategory[name=current()/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value"/>",
     "isAbstract":"<xsl:value-of select="current()/own_slot_value[slot_reference='data_object_is_abstract']/value"/>",
	 "parents":[<xsl:for-each select="$parents">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
      
  </xsl:template>
	
</xsl:stylesheet>
