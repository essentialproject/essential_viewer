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
    	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = ('Reference Model Layout','Application Capability Category'))]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
<!-- fallback to old values if app caps missing -->
	<xsl:variable name="leftRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = ('Management','Foundation')]"/>
	<xsl:variable name="rightRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Enabling']"/>
	<xsl:variable name="middleRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = ('Shared','Core')]"/>
 
	
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
    <xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
    <xsl:variable name="allRoadmapInstances" select="$allAppCaps"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    
	<xsl:template match="knowledge_base">
		{
			"application_capabilities": [
				<xsl:apply-templates select="$L1AppCaps" mode="RenderApplicationCapabilities"/>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderApplicationCapabilities" match="node()">
		<xsl:variable name="appServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"appServices": [	
				<xsl:apply-templates select="$appServices" mode="RenderAppServices"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>

    <xsl:template match="node()" mode="RenderAppServices">
		<xsl:variable name="thisAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = current()/name]"/>

		<xsl:variable name="thisAppsIn" select="$thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
        
		{<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
        "apps": [<xsl:for-each select="$thisAppsIn">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
</xsl:stylesheet>
