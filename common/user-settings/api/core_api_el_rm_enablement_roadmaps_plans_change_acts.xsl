<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:import href="../../../common/core_utilities.xsl"/>
	<xsl:import href="../../../common/core_js_functions.xsl"/>
	<!--
		* Copyright © 2008-2021 Enterprise Architecture Solutions Limited.
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
	<!-- 24.10.2021 JP  Created template-->

	
	<xsl:variable name="changeTypeTax" select="/node()/simple_instance[(type = 'Taxonomy')][own_slot_value[slot_reference = 'name']/value ='Planning Action Change Types']"/>
	<xsl:variable name="changeTypeTaxTerms" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value =$changeTypeTax/name]"/>
	<xsl:variable name="planningActions" select="/node()/simple_instance[own_slot_value[slot_reference = 'element_classified_by']/value =$changeTypeTaxTerms/name]"/>
	<xsl:variable name="plan2ElementRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'plan_to_element_change_action']/value =$planningActions/name]"/>
	<xsl:variable name="changeActivities" select="/node()/simple_instance[name=$plan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
	<xsl:variable name="strategicPlans" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value][name=$plan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
	<xsl:variable name="roadmaps" select="/node()/simple_instance[own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $strategicPlans/name]"/>

 
	<xsl:template match="knowledge_base">
		{
			"roadmaps": [
				<!-- Render Id, name, description -->
				<xsl:apply-templates mode="RenderIdName" select="$roadmaps"/>			
			],
			"strategicPlans": [
				<!-- Render Id, name, description, start date, end date, parent roadmap -->
				<xsl:apply-templates mode="RenderStrategicPlan" select="$strategicPlans"/>	
			],
			"changeActivities": [
				<!-- Render Id, name, description, proposed start date, planned end date, actual start date, forecast/actual end date -->
				<xsl:apply-templates mode="RenderChangeActivity" select="$changeActivities"/>	
			],
			"planningActions": [
				<xsl:apply-templates mode="RenderPlanningAction" select="$planningActions"/>	
			]
		}
	</xsl:template>

	
	<xsl:template mode="RenderIdName" match="node()">
		<xsl:variable name="this" select="current()"/>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

	<xsl:template mode="RenderPlanningAction" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="changeType" select="$changeTypeTaxTerms[name = $this/own_slot_value[slot_reference = 'element_classified_by']/value]"/>

		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"changeType": "<xsl:value-of select="$changeType/own_slot_value[slot_reference = 'name']/value"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

	<xsl:template mode="RenderStrategicPlan" match="node()">
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="thisRoadmap" select="$roadmaps[own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $this/name]"/>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"startDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>",
		"endDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>",
		"parentRoadmapId": "<xsl:value-of select="eas:getSafeJSString($thisRoadmap[1]/name)"/>",
		"type": "<xsl:value-of select="substring-before($this/type, '_')"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template mode="RenderChangeActivity" match="node()">
		<xsl:variable name="this" select="current()"/>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"plannedStartDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>",
		"plannedEndDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>",
		"actualStartDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>",
		"forecastEndDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>",
		"type": "<xsl:value-of select="$this/type"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
