<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
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
	<!-- 03.09.2019 JP  Created	 template-->
    <xsl:variable name="drivers" select="/node()/simple_instance[(type = 'Business_Driver')]"/>
    <xsl:variable name="stratGoalTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>
	<xsl:variable name="objectiveTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="stratGoals" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $stratGoalTaxTerm/name]"/>
	<xsl:variable name="stratObjectives" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $objectiveTaxTerm/name]"/>
    <xsl:variable name="goals" select="/node()/simple_instance[(type = 'Business_Goal')]"/>
    <xsl:variable name="allGoals" select="$goals union $stratGoals"/>	
	<!--
    <xsl:variable name="allRoadmapInstances" select="$allAppProviders"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    -->
	<xsl:template match="knowledge_base">
		{
			"drivers": [
				<xsl:apply-templates mode="RenderDrivers" select="$drivers">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderDrivers" match="node()">
    <xsl:variable name="thisGoals" select="$allGoals[own_slot_value[slot_reference='bo_motivated_by_driver']/value=current()/name]"/>
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
			"description": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'description']/value"/>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
            "goals":[<xsl:apply-templates select="$thisGoals" mode="renderGoals"/>],
            "objectives":[]
			<!--<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,-->
			
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	<xsl:template mode="renderGoals" match="node()">
     <xsl:variable name="thisGoals" select="$allGoals[own_slot_value[slot_reference='supporting_business_capabilities']/value=current()/name]"/>   
        
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
			"description": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'description']/value"/>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
            "supportingCapabilities":[<xsl:for-each select="current()/own_slot_value[slot_reference='supporting_business_capabilities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]
			<!--<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,-->
			
		} <xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
