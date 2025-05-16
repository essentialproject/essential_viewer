<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="busProcs" select="/node()/simple_instance[type='Business_Process']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')]"/>
	<xsl:variable name="allActor2RoleRelations" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]"/>
	<xsl:variable name="allActorsInstances" select="$allActors union $allActor2RoleRelations"/>
	<xsl:key name="physProcsKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
	<xsl:key name="physProcsToAppKey" match="$allProctoApp" use="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value"/>

	<xsl:variable name="physProcs" select="key('physProcsKey', $busProcs/name)"/>
	   
	<!-- data linked to processes-->

	<xsl:variable name="allProctoApp" select="/node()/simple_instance[type='PHYSBUSPROC_TO_APPINFOREP_RELATION']"/>
	<xsl:key name="physProcstoMapKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'physbusproc_uses_appinforeps']/value"/>
	<xsl:key name="busProcsKey" match="/node()/simple_instance[type='Business_Process']" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/>
	
	<xsl:key name="allActors_key" match="$allActors" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
	

	<xsl:variable name="currentDataObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="dsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Subjects']"></xsl:variable>
	<xsl:variable name="doData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	
	<xsl:key name="regRels" match="/node()/simple_instance[type='REGULATED_COMPONENT_RELATION']" use="own_slot_value[slot_reference='regulated_component_regulation']/value"/>
	<xsl:key name="regkey" match="/node()/simple_instance[type='Regulation']" use="type"/>	
	<xsl:key name="regname" match="/node()/simple_instance[type='Regulation']" use="name"/>			
	<xsl:variable name="regulation" select="key('regkey', 'Regulation')"/>

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
		{
		"busProcs":[<xsl:apply-templates select="$busProcs" mode="procInfo"/>],
		"physProcs":[<xsl:apply-templates select="$physProcs" mode="physProcInfo"/>],
		"appProToProcess":[<xsl:apply-templates select="$allProctoApp" mode="infoToProcess"/>],
		"regulations":[<xsl:apply-templates select="$regulation" mode="regulation"/>],
		"version":"618"
		}
	</xsl:template>

	<xsl:template match="." mode="regulation">
		<xsl:variable name="reg" select="key('regRels', current()/name)"/>

		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>", 
		"elements":[<xsl:for-each select="$reg/own_slot_value[slot_reference = 'regulated_component_to_element']/value">{"id":"<xsl:value-of select="."/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
<xsl:template match="node()" mode="procInfo">
	<xsl:variable name="physProcess" select="key('physProcsKey', current()/name)"/>
	<xsl:variable name="physProcesstoApp" select="key('physProcsToAppKey', current()/name)"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		 </xsl:call-template>",
		"physProcesses":[
		<xsl:for-each select="$physProcess"> 
		<xsl:variable name="thisActor" select="$allActorsInstances[name=current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisActorviaA2R" select="key('allActors_key',$thisActor/name)"/>
		<xsl:variable name="physProcesstoApp" select="key('physProcsToAppKey', current()/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
			<xsl:choose>
				<xsl:when test="$thisActor/type='ACTOR_TO_ROLE_RELATION'"> 
				"actor":"<xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="$thisActorviaA2R"/>
							<xsl:with-param name="isForJSONAPI" select="true()"/>
						</xsl:call-template>",
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActorviaA2R/name)"/>",			
				</xsl:when>
				<xsl:otherwise> 
				"actor":"<xsl:call-template name="RenderInstanceLinkForJS">
							<xsl:with-param name="theSubjectInstance" select="$thisActor"/>
							<xsl:with-param name="isForJSONAPI" select="true()"/>
						</xsl:call-template>",
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActor/name)"/>",		
				</xsl:otherwise>
			</xsl:choose>
			"usages":[<xsl:for-each select="$physProcesstoApp">  
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					"name":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isForJSONAPI" select="true()"/>
					</xsl:call-template>",
					"appInfoRep":"<xsl:value-of select="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if> 
				</xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if> 
	</xsl:for-each>]
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="physProcInfo">  
	 <xsl:variable name="thisActor" select="$allActorsInstances[name=current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisActorviaA2R" select="key('allActors_key',$thisActor/name)"/>
		<xsl:variable name="physProcesstoApp" select="key('physProcsToAppKey', current()/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
			<xsl:choose>
				<xsl:when test="$thisActor/type='ACTOR_TO_ROLE_RELATION'"> 
				"actor":"<xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="$thisActorviaA2R"/>
							<xsl:with-param name="isForJSONAPI" select="true()"/>
						</xsl:call-template>",
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActorviaA2R/name)"/>"			
				</xsl:when>
				<xsl:otherwise> 
				"actor":"<xsl:call-template name="RenderInstanceLinkForJS">
							<xsl:with-param name="theSubjectInstance" select="$thisActor"/>
							<xsl:with-param name="isForJSONAPI" select="true()"/>
						</xsl:call-template>",
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActor/name)"/>"
				</xsl:otherwise>
			</xsl:choose>
			<!--"usages":[<xsl:for-each select="$physProcesstoApp">  
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					"name":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isForJSONAPI" select="true()"/>
					</xsl:call-template>",
					"appInfoRep":"<xsl:value-of select="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if> 
				</xsl:for-each>]-->
			}<xsl:if test="position()!=last()">,</xsl:if> 
 
</xsl:template>
<xsl:template match="node()" mode="infoToProcess"> 
<xsl:variable name="physProcesstoApp" select="key('physProcstoMapKey', current()/name)"/>
<xsl:variable name="busProcess" select="key('busProcsKey', $physProcesstoApp/name)"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"app_info_rep":"<xsl:value-of select="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		 </xsl:call-template>",
	"processes":[<xsl:for-each select="$busProcess">
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>"
			}<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>
		],
	"physicalProcesses":[<xsl:for-each select="current()/own_slot_value[slot_reference='physbusproc_to_appinfoview_from_physbusproc']/value">
			{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"
			}<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>
		]
	}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template>
</xsl:stylesheet>
