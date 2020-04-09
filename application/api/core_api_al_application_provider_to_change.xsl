<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
    <xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
    <xsl:variable name="allAppstoPlans" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][own_slot_value[slot_reference='plan_to_element_ea_element']/value=$allAppProviders/name]"/>
	<xsl:variable name="allProjects" select="/node()/simple_instance[type = ('Project','Programme') and (own_slot_value[slot_reference = 'ca_planned_changes']/value= $allAppstoPlans/name)]"/>
    <xsl:variable name="allStrategicPlans" select="/node()/simple_instance[(type = 'Enterprise_Strategic_Plan') and (own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $allAppstoPlans/name)]"/>
    <xsl:variable name="appProRoles" select="/node()/simple_instance[(type = 'Application_Provider_Role')][name=$allAppProviders/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
    
    <xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[type ='APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value=$appProRoles/name]"/>
    <xsl:variable name="relevantAppServices" select="/node()/simple_instance[type=('Application_Service','Composite_Application_Service')][name=$appProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
    <xsl:variable name="relevantAppCaps" select="/node()/simple_instance[type='Application_Capability'][name=$relevantAppServices/own_slot_value[slot_reference = 'realises_application_capabilities']/value]"/>
    
    <xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[type='Physical_Process'][name=$relevantAppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
    <xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[type='Business_Process'][name=$relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
    <xsl:variable name="relevantBusProcs" select="/node()/simple_instance[type='Business_Capability'][name=$relevantPhysProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
    

    
    <xsl:variable name="allRoadmapInstances" select="$allAppProviders"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
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
			"applicationChange": [
				<xsl:apply-templates mode="RenderApplications" select="$allAppProviders">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
    <xsl:template mode="RenderApplications" match="node()">
    <xsl:variable name="thisAppstoPlans" select="$allAppstoPlans[own_slot_value[slot_reference='plan_to_element_ea_element']/value=current()/name]"/>
	<xsl:variable name="thisProjects" select="$allProjects[own_slot_value[slot_reference = 'ca_planned_changes']/value= $thisAppstoPlans/name]"/>
    <xsl:variable name="thisStrategicPlans" select="$allStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $thisAppstoPlans/name]"/>
    <xsl:variable name="thisappProRoles" select="$appProRoles[name=current()/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
       
    <xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value=$thisappProRoles/name]"/>
    <xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[name=$thisrelevantAppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
    <xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[name=$thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
    <xsl:variable name="thisrelevantBusProcs" select="$relevantBusProcs[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
    <xsl:variable name="thisrelevantAppServices" select="$relevantAppServices[name=$thisappProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
    <xsl:variable name="thisrelevantAppCaps" select="$relevantAppCaps[name=$thisrelevantAppServices/own_slot_value[slot_reference = 'realises_application_capabilities']/value]"/>    
        
		{
			<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"change":[<xsl:apply-templates select="$thisProjects" mode="items"/>],
            "strategicPlans":[<xsl:apply-templates select="$thisStrategicPlans" mode="items"/>],
            "busCapabilitiesSupporting":[<xsl:for-each select="$thisrelevantBusProcs">"<xsl:value-of select="current()/name"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
            "appCapabilitiesSupporting":[<xsl:for-each select="$thisrelevantAppCaps">"<xsl:value-of select="current()/name"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
 <xsl:template match="node()" mode="items">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
     <xsl:variable name="startDate"><xsl:choose> <xsl:when test="current()/type='Enterprise_Strategic_Plan'"><xsl:value-of select="own_slot_value[slot_reference='strategic_plan_valid_from_date_iso_8601']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="own_slot_value[slot_reference='ca_actual_start_date_iso_8601']/value"/></xsl:otherwise></xsl:choose></xsl:variable>
	 <xsl:variable name="endDate"><xsl:choose><xsl:when test="current()/type='Enterprise_Strategic_Plan'"><xsl:value-of select="own_slot_value[slot_reference='strategic_plan_valid_to_date_iso_8601']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="own_slot_value[slot_reference='ca_forecast_end_date_iso_8601']/value"/></xsl:otherwise></xsl:choose></xsl:variable> 	
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
        {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
        "description": "<xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/>",
        "startDate":"<xsl:value-of select="$startDate"/>",
        "endDate":"<xsl:value-of select="$endDate"/>",
		"link": "<xsl:value-of select="$thisLink"/>"}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>  
    
</xsl:stylesheet>
   

