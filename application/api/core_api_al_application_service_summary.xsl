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
	<!-- 03.09.2019 JP  Created	 -->
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')][name=$param1]"/>
   <!-- Get all
    <xsl:otherwise><xsl:variable name="allAppServices" select="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')]"/>
	-->
    <xsl:variable name="allAppSvstoBP" select="/node()/simple_instance[type = 'APP_SVC_TO_BUS_RELATION'][own_slot_value[slot_reference='appsvc_to_bus_from_appsvc']/value=$allAppServices/name]"/>
    <xsl:variable name="couldUseBusinessProcesses" select="/node()/simple_instance[type = 'Business_Process'][own_slot_value[slot_reference='bp_supported_by_app_svc']/value=$allAppSvstoBP/name]"/>
    <xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role'][name=$allAppServices/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
    <xsl:variable name="allAppProtoPhysProc" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value=$allAppProviderRoles/name]"/>
    <xsl:variable name="allPhysProcSupporting" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$allAppProtoPhysProc/name]"/>
     <xsl:variable name="allPhysActSupporting" select="/node()/simple_instance[type = 'Physical_Activity'][own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$allAppProtoPhysProc/name]"/>
    <xsl:variable name="allPhysProctoBP" select="/node()/simple_instance[type = 'Business_Process'][name=$allPhysProcSupporting/own_slot_value[slot_reference='implements_business_process']/value]"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')][name=$allAppProviderRoles/own_slot_value[slot_reference='role_for_application_provider']/value]"/>

    
  
    <xsl:variable name="allRoadmapInstances" select="$allAppServices"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    
	<xsl:template match="knowledge_base">
		{
			"service": [
				<xsl:apply-templates mode="RenderService" select="$allAppServices">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderService" match="node()">
		 <xsl:variable name="thisAppSvstoBP" select="$allAppSvstoBP[own_slot_value[slot_reference='appsvc_to_bus_from_appsvc']/value=current()/name]"/>
        <xsl:variable name="thiscouldUseBusinessProcesses" select="$couldUseBusinessProcesses[own_slot_value[slot_reference='bp_supported_by_app_svc']/value=$thisAppSvstoBP/name]"/>
        <xsl:variable name="thisAppProviderRoles" select="$allAppProviderRoles[name=current()/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
       

		{
			<!--id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisAppName"/>",
			description: "<xsl:value-of select="$thisAppDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",-->
			<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
            "couldDoProcess": [<xsl:for-each select="$thiscouldUseBusinessProcesses">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
            "applications":[<xsl:apply-templates select="$thisAppProviderRoles" mode="RenderServiceApps"/>]
        
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
    
    <xsl:template mode="RenderServiceApps" match="node()">
         <xsl:variable name="thisAppProtoPhysProc" select="$allAppProtoPhysProc[own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value=current()/name]"/>
        <xsl:variable name="thisPhysProcSupporting" select="$allPhysProcSupporting[own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$thisAppProtoPhysProc/name]"/>
         <xsl:variable name="thisPhysActSupporting" select="$allPhysActSupporting[own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$thisAppProtoPhysProc/name]"/>
        <xsl:variable name="thisPhysProctoBP" select="$allPhysProctoBP[name=$thisPhysProcSupporting/own_slot_value[slot_reference='implements_business_process']/value]"/>
        <xsl:variable name="thisAppProviders" select="$allAppProviders[name=current()/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
            {"application":"<xsl:value-of select="$thisAppProviders/own_slot_value[slot_reference = 'name']/value"/>",
            "debug":"",
            "doesDoProcess": [<xsl:for-each select="$thisPhysProctoBP">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]} <xsl:if test="not(position()=last())">,</xsl:if> 
    
    </xsl:template>
</xsl:stylesheet>
