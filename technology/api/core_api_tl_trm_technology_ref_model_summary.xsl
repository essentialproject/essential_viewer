<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
	<!--
		* Copyright © 2008-2020 Enterprise Architecture Solutions Limited.
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
	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
	
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = ('Technology_Component', Composite_Technology_Component)]"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	
	<xsl:variable name="allDocLinks" select="/node()/simple_instance[own_slot_value[slot_reference = 'referenced_ea_instance']/value = ($allTechDomains, $allTechCaps, $allTechComps)/name]"/>
	<xsl:variable name="allDocTypes" select="/node()/simple_instance[name = $allDocLinks/own_slot_value[slot_reference = 'element_classified_by']/value]"/>	
	
	
	<xsl:template match="knowledge_base">
		{
			"techDomains": [
				<xsl:apply-templates select="$allTechDomains" mode="RenderTechDomains"/>
			],
			"techCapDetails": [
				<xsl:apply-templates select="$allTechCaps" mode="TechCapDetails"/>
			],
			"techComponents": [
				<xsl:apply-templates select="$allTechComps" mode="RenderTechCompDetails"/>
			]
		}
	</xsl:template>
	
	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="techDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techDomainDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="current()/own_slot_value[slot_reference = 'contains_technology_capabilities']"/>
		<xsl:variable name="thisRefLayer" select="$refLayers[name = current()/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		
		<xsl:variable name="thisDocLink">
			<xsl:call-template name="GetTechDocLink">
				<xsl:with-param name="element" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="$techDomainName"/>",
		"description": "<xsl:value-of select="eas:renderJSText($techDomainDescription)"/>",
		"link": "<xsl:value-of select="$techDomainLink"/>",
		<xsl:if test="string-length($thisDocLink) > 0">"docLink": <xsl:value-of select="$thisDocLink"/>,</xsl:if>
		"refLayer": "<xsl:value-of select="$thisRefLayer/own_slot_value[slot_reference = 'name']/value"/>", 
		"childTechCapIds": [
		<xsl:for-each select="$childTechCaps/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="TechCapDetails">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="techCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCapDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techComponents" select="current()/own_slot_value[slot_reference = 'realised_by_technology_components']"/>
		
		<xsl:variable name="thisDocLink">
			<xsl:call-template name="GetTechDocLink">
				<xsl:with-param name="element" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="$techCapName"/>",
		"link": "<xsl:value-of select="$techCapLink"/>",
		<xsl:if test="string-length($thisDocLink) > 0">"docLink": <xsl:value-of select="$thisDocLink"/>,</xsl:if>
		"description": "<xsl:value-of select="eas:renderJSText($techCapDescription)"/>",
		
		"techComponentIds": [	
		<xsl:for-each select="$techComponents/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderTechCompDetails">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="techCompName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCompDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCompLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
		<!--<xsl:variable name="thisTechProdRoles2" select="current()/own_slot_value[slot_reference = 'realised_by_technology_products']"/>-->
		<xsl:variable name="thisDocLink">
			<xsl:call-template name="GetTechDocLink">
				<xsl:with-param name="element" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="$techCompName"/>",
		"link": "<xsl:value-of select="$techCompLink"/>",
		<xsl:if test="string-length($thisDocLink) > 0">"docLink": <xsl:value-of select="$thisDocLink"/>,</xsl:if>
		"description": "<xsl:value-of select="eas:renderJSText($techCompDescription)"/>",
		"techProdCount": <xsl:value-of select="count($thisTechProdRoles)"/>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="summaryRefModelLegendInclude">
		<script id="rag-overlay-legend-template" type="text/x-handlebars-template">
			<div class="keyTitle">Legend:</div>
			<div class="keySampleWide bg-purple-100"/>
			<div class="keyLabel">High</div>
			<div class="keySampleWide bg-purple-60"/>
			<div class="keyLabel">Medium</div>
			<div class="keySampleWide bg-purple-20"/>
			<div class="keyLabel">Low</div>
			<div class="keySampleWide bg-lightgrey"/>
			<div class="keyLabel">No Products In Use</div>
		</script>
		
		<script id="no-overlay-legend-template" type="text/x-handlebars-template">
			<div class="keyTitle">Legend:</div>
			<div class="keySampleWide bg-darkblue-80"/>
			<div class="keyLabel">{{inScope}}</div>
			<div class="keySampleWide bg-lightgrey"/>
			<div class="keyLabel">No Products In Use</div>
		</script>
		
	</xsl:template>
	
	<!-- Function to return the url of an elements document link -->
	<xsl:template name="GetTechDocLink">
		<xsl:param name="element"/>		
		<xsl:variable name="thisDocLinks" select="$allDocLinks[own_slot_value[slot_reference = 'referenced_ea_instance']/value = $element/name]"/>
		<xsl:choose>
			<xsl:when test="count($thisDocLinks) > 0">
				<xsl:variable name="thisDocTypes" select="$allDocTypes[name = $thisDocLinks[1]/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
				<xsl:variable name="docTypeLabel">
					<xsl:choose>
						<xsl:when test="count($thisDocTypes) > 0">
							<xsl:value-of select="$thisDocTypes[1]/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
						</xsl:when>
						<xsl:otherwise>Document Link</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:text>{"type": "</xsl:text><xsl:value-of select="$docTypeLabel"/><xsl:text>","url": "</xsl:text><xsl:value-of select="$thisDocLinks[1]/own_slot_value[slot_reference = 'external_reference_url']/value"/>"}				
			</xsl:when>
			<xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
</xsl:stylesheet>
