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
    
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
    <xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
    <!-- original  <xsl:variable name="allRoadmapInstances" select="$allApps union $allTechProds"/> -->
<xsl:variable name="allRoadmapInstances" select="$allAppCaps"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    <!-- END ROADMAP VARIABLES -->
	
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:template match="knowledge_base">
		{
			"arm": [
				{"left": [<xsl:choose>
                                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name])&gt;0">
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderAppCaps"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayerOld/name]" mode="RenderAppCaps"/>
                                    </xsl:otherwise>
                                </xsl:choose>],
						  		"middle": [<xsl:choose>
                                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name])&gt;0">
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderAppCaps"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayerOld/name]" mode="RenderAppCaps"/>
                                    </xsl:otherwise>
                                </xsl:choose>],
						  		"right": [ <xsl:choose>
                                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name])&gt;0">
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderAppCaps"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayerOld/name]" mode="RenderAppCaps"/>
                                    </xsl:otherwise>
                                </xsl:choose>
						  		]
        }
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderARM" match="node()">
{"left": [<xsl:choose>
                                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name])&gt;0">
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderAppCaps"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayerOld/name]" mode="RenderAppCaps"/>
                                    </xsl:otherwise>
                                </xsl:choose>],
						  		"middle": [<xsl:choose>
                                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name])&gt;0">
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderAppCaps"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayerOld/name]" mode="RenderAppCaps"/>
                                    </xsl:otherwise>
                                </xsl:choose>],
						  		"right": [ <xsl:choose>
                                    <xsl:when test="count($allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name])&gt;0">
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderAppCaps"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayerOld/name]" mode="RenderAppCaps"/>
                                    </xsl:otherwise>
                                </xsl:choose>
						  		]
        }<xsl:if test="not(position() = last())">,</xsl:if>
						  	
	</xsl:template>
<xsl:template mode="RenderAppCaps" match="node()">
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>{
    <!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
		"childAppCaps": [
			<xsl:apply-templates select="$childAppCaps" mode="RenderChildAppCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildAppCaps">

		{<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
</xsl:stylesheet>
