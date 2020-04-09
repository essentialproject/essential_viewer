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
    <xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>
    <xsl:variable name="planningElements" select="/node()/simple_instance[(type = 'PLAN_TO_ELEMENT_RELATION')][own_slot_value[slot_reference = 'plan_to_element_ea_element']/value =$allApps/name]"/>
    <xsl:variable name="strategicPlan" select="/node()/simple_instance[(type = 'Enterprise_Strategic_Plan')][name=$planningElements/own_slot_value[slot_reference = 'plan_to_element_plan']/value ]"/>
    <xsl:variable name="changeActivities" select="/node()/simple_instance[(type = 'Project')][name=$planningElements/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
    <xsl:variable name="planningActions" select="/node()/simple_instance[(type = 'Planning_Action')]"/>
 
    <xsl:variable name="allRoadmapInstances" select="$allApps"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
 
	<xsl:template match="knowledge_base">
		{
			"applications": [
				<xsl:apply-templates mode="RenderApps" select="$allApps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderApps" match="node()">
    <xsl:variable name="thisplanningElements" select="$planningElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value =current()/name]"/>
		{
			<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
            "plan_actions":[<xsl:apply-templates select="$thisplanningElements" mode="renderPlans"/>]			
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
<xsl:template mode="renderPlans" match="node()">
    <xsl:variable name="thisstrategicPlan" select="$strategicPlan[name=current()/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
    <xsl:variable name="thischangeActivities" select="$changeActivities[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"strategic_plan":"<xsl:value-of select="$thisstrategicPlan/own_slot_value[slot_reference='name']/value"/>",
            "strategic_plan_start":"<xsl:value-of select="$thisstrategicPlan/own_slot_value[slot_reference='strategic_plan_valid_from_date_iso_8601']/value"/>",
            "strategic_plan_end":"<xsl:value-of select="$thisstrategicPlan/own_slot_value[slot_reference='strategic_plan_valid_to_date_iso_8601']/value"/>",
            "change_activity":"<xsl:value-of select="$thischangeActivities/own_slot_value[slot_reference='name']/value"/>",
            "change_activity_start_forecast":"<xsl:value-of select="$thischangeActivities/own_slot_value[slot_reference='ca_proposed_start_date_iso_8601']/value"/>",
            "change_activity_start_actual":"<xsl:value-of select="$thischangeActivities/own_slot_value[slot_reference='ca_actual_start_date_iso_8601']/value"/>",
            "change_activity_end_forecast":"<xsl:value-of select="$thischangeActivities/own_slot_value[slot_reference='ca_target_end_date_iso_8601']/value"/>",
            "change_activity_end_actual":"<xsl:value-of select="$thischangeActivities/own_slot_value[slot_reference='name']/value"/>",
            "action":"<xsl:value-of select="$planningActions[name=current()/own_slot_value[slot_reference='plan_to_element_change_action']/value]/own_slot_value[slot_reference='name']/value"/>"
			
		} <xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
