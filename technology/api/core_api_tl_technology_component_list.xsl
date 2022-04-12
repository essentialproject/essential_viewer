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
   

 	
<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>
<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type='Technology_Product_Role'][own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComponents/name]"/>
<xsl:variable name="allRoadmapInstances" select="$allTechComponents"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    <!-- END ROADMAP VARIABLES -->
	
	
	<xsl:template match="knowledge_base">
		{
			"technology_components": [
        <xsl:apply-templates select="$allTechComponents" mode="RenderallTechComponents"/>
			]
		}
	</xsl:template>
	
	<xsl:template mode="RenderallTechComponents" match="node()">
 	<xsl:variable name="thisTPR" select="$allTechProdRoles[name=current()/own_slot_value[slot_reference='realised_by_technology_products']/value]"/>
		<xsl:variable name="thisTechCompName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisTechCompDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="false()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>	
		
	{ 
			<xsl:call-template name="RenderRoadmapJSONPropertiesForAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"debug":"<xsl:value-of select="count($thisTPR)"/>",
			"caps":[<xsl:for-each select="current()/own_slot_value[slot_reference='realisation_of_technology_capability']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"products":[<xsl:for-each select="$thisTPR/own_slot_value[slot_reference='role_for_technology_provider']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
