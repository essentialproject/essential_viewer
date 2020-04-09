<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:import href="../../common/core_el_ref_model_include.xsl"/>
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
    <xsl:variable name="leftRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = ('Management','Foundation')]"/>
	<xsl:variable name="rightRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Enabling']"/>
	<xsl:variable name="middleRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = ('Shared','Core')]"/>
    
<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
	

<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	
<xsl:variable name="allRoadmapInstances" select="$allTechProds"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    <!-- END ROADMAP VARIABLES -->
	
	
	<xsl:template match="knowledge_base">
		{
			"trm": [
				{
                    "top": [
                        <xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name]" mode="RenderTechDomains"/>
                    ],
                    "left": [
                        <xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderTechDomains"/>
                    ],
                    "middle": [
                        <xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderTechDomains"/>
                    ],
                    "right": [
                        <xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderTechDomains"/>
                    ],
                    "bottom": [
                        <xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name]" mode="RenderTechDomains"/>
                    ]
                }
			]   
		}
	</xsl:template>
	
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="techDomainName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="false()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="$techDomainName"/>",
		"description": "<xsl:value-of select="$techDomainDescription"/>",
		"link": "<xsl:value-of select="$techDomainLink"/>",
		"childTechCaps": [
		<xsl:apply-templates select="$childTechCaps" mode="RenderChildTechCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildTechCaps">
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="TechCapDetails">
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"techComponents": [	
				<xsl:apply-templates select="$techComponents" mode="RenderTechComponents"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderTechComponents">
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
        <xsl:variable name="thisTechProdsIn" select="distinct-values($thisTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value)"/>
		{<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
        tprs: [<xsl:for-each select="$thisTechProdRoles">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
       <!-- techProds: [<xsl:for-each select="$thisTechProdsIn">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]-->
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
