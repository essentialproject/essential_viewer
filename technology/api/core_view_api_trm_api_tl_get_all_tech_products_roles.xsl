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
	 <xsl:variable name="allTechStandards" select="/node()/simple_instance[type = 'Standard_Strength']"/>

	 <xsl:variable name="allGeos" select="/node()/simple_instance[type = ('Geographic_Region','Geographic_Location')]"/>
	 <xsl:variable name="allOrgs" select="/node()/simple_instance[type = ('Group_Actor')]"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
	<xsl:key name="allTechProdStandardsKey" match="/node()/simple_instance[type = 'Technology_Provider_Standard_Specification']" use="own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value"/>
	<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[name = $allTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
	<xsl:template match="knowledge_base">
        {"techProdRoles": [<xsl:apply-templates select="$allTechProdRoles" mode="RenderTechProdRoleJSON"/>]
				  	}
	</xsl:template>
	  <xsl:template match="node()" mode="RenderTechProdRoleJSON">
        <xsl:variable name="thisTPR" select="current()"/>
        <xsl:variable name="thisTechCompid" select="$thisTPR/own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
	 	<xsl:variable name="thisTechProdid" select="current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>		
		 <xsl:variable name="thisTechProdStandard" select="key('allTechProdStandardsKey', current()/name)"/>
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<!--<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="$thisTechComp"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,-->
		"id": "<xsl:value-of select="eas:getSafeJSString($thisTPR/name)"/>",
        "techProdid": "<xsl:value-of select="eas:getSafeJSString($thisTechProdid)"/>",
		"techCompid": "<xsl:value-of select="eas:getSafeJSString($thisTechCompid)"/>",
		"standard": [<xsl:for-each select="$thisTechProdStandard">
				<xsl:variable name="thisTechStd" select="$allTechStandards[name=current()/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>		 
				<xsl:variable name="thisTechStdGeo" select="$allGeos[name=current()/own_slot_value[slot_reference = 'sm_geographic_scope']/value]"/>		 
				<xsl:variable name="thisTechStdOrg" select="$allOrgs[name=current()/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>		 
		
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>", 
				"status":"<xsl:value-of select="$thisTechStd/own_slot_value[slot_reference = 'enumeration_value']/value"/>",
				"statusColour":"<xsl:value-of select="eas:get_element_style_textcolour($thisTechStd)"/>",
				"statusBgColour":"<xsl:value-of select="eas:get_element_style_colour($thisTechStd)"/>",
				"scopeGeo":[
				<xsl:for-each select="$thisTechStdGeo">
				{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>"}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
			 ],
			 	"scopeOrg":[
				<xsl:for-each select="$thisTechStdOrg">
				{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>"}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
		  ]}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
    </xsl:template>

</xsl:stylesheet>
