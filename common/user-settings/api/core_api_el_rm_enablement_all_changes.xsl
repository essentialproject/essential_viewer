<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
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
	<xsl:variable name="strategicPlans" select="/node()/simple_instance[supertype='Strategic_Plan'][string-length(own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value) > 0]"/>
	<xsl:variable name="plan2ElementRels" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][string-length(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) > 0][own_slot_value[slot_reference = 'plan_to_element_plan']/value = $strategicPlans/name][own_slot_value[slot_reference = 'plan_to_element_change_action']/value =$planningActions/name]"/>
	<xsl:variable name="allChangedElements" select="/node()/simple_instance[name = $plan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	<xsl:variable name="changeActivities" select="/node()/simple_instance[name=$plan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
	<xsl:variable name="roadmaps" select="/node()/simple_instance[own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $strategicPlans/name]"/>

	<xsl:template match="knowledge_base">
		{
			"plans": [
				<xsl:apply-templates mode="RenderPlan2Element" select="$plan2ElementRels"/>
			]
		}
	</xsl:template>
	
	<xsl:template mode="RenderPlan2Element" match="node()">
		<xsl:variable name="thisPlan2El" select="current()"/>
		
		<xsl:variable name="thisElId" select="$thisPlan2El/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value"/>
		<xsl:variable name="thisPlanningAction" select="$planningActions[name = $thisPlan2El/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>
		<xsl:variable name="thisActionType" select="$changeTypeTaxTerms[name = $thisPlanningAction/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		<xsl:variable name="thisPlan" select="$strategicPlans[name=$thisPlan2El/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
		<xsl:variable name="thisRoadmaps" select="$roadmaps[own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $thisPlan/name]"/>
		<xsl:variable name="thisChangeActivityId" select="$thisPlan2El/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value"/>
		<xsl:variable name="planEndDate" select="$thisPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		{
		"instId": "<xsl:value-of select="eas:getSafeJSString($thisElId)"/>",
		"roadmapIds": [<xsl:for-each select="$thisRoadmaps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"changeActivityId": "<xsl:value-of select="eas:getSafeJSString($thisChangeActivityId)"/>",
		"planId": "<xsl:value-of select="eas:getSafeJSString($thisPlan/name)"/>",
		"actionId": "<xsl:value-of select="eas:getSafeJSString($thisPlanningAction/name)"/>",
		"actionType": "<xsl:value-of select="$thisActionType/own_slot_value[slot_reference = 'name']/value"/>",
		"end": "<xsl:value-of select="$planEndDate"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
