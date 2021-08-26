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
 	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
	<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[name = $allTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
	<xsl:template match="knowledge_base">
        {"techProdRoles": [<xsl:apply-templates select="$allTechProdRoles" mode="RenderTechProdRoleJSON"/>]
				  	}
	</xsl:template>
	  <xsl:template match="node()" mode="RenderTechProdRoleJSON">
        <xsl:variable name="thisTPR" select="current()"/>
        <xsl:variable name="thisTechCompid" select="$thisTPR/own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
	 	<xsl:variable name="thisTechProdid" select="current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>		
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<!--<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="$thisTechComp"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,-->
		"id": "<xsl:value-of select="eas:getSafeJSString($thisTPR/name)"/>",
        "techProdid": "<xsl:value-of select="eas:getSafeJSString($thisTechProdid)"/>",
		"techCompid": "<xsl:value-of select="eas:getSafeJSString($thisTechCompid)"/>",
		"standard": "<!--<xsl:value-of select="$standardStyle"/>-->"
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
    </xsl:template>

</xsl:stylesheet>
