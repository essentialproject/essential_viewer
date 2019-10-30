<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
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
	<!-- 25.07.2019 JP  Created	 -->

	
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	
	<!-- Business Capabilities, Processes and Organisations -->
	<!--<xsl:variable name="allBusCapabilities" select="/node()/simple_instance[type = 'Business_Capability']"/>-->
	<xsl:variable name="focusInstance" select="/node()/simple_instance[name = $param1]"/>
	
	<!-- Planning Action -->
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[(type = 'Planning_Action') and (count(own_slot_value[slot_reference = 'planning_action_classes']/value) > 0)]"/>
	
	<xsl:variable name="instancePlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = ($focusInstance/supertype, $focusInstance/type)]"/>
	
	

	<xsl:template match="knowledge_base">
		<xsl:call-template name="getModalJSON"/>
	</xsl:template>


	<!-- Template to return all read only data for the view -->
	<xsl:template name="getModalJSON">
		{
			"focusInstance": <xsl:apply-templates mode="RenderModalInstanceJSON" select="$focusInstance"/>
		}
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderModalInstanceJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"planningActions": [
			<xsl:apply-templates mode="getSimpleJSONList" select="$instancePlanningActions"><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- END UTILITY TEMPLATES AND FUNCTIONS -->

</xsl:stylesheet>
