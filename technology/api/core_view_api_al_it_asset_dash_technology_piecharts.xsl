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
    	
	
	<xsl:variable name="allTechnologyProviders" select="/node()/simple_instance[type = ('Technology_Product')]"/>
 	<xsl:variable name="techOrgUser" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference='name']/value=('Technology Organisation User')]"/>
	<xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference='act_to_role_to_role']/value=$techOrgUser/name]"/>
	<xsl:variable name="appOrgActor" select="/node()/simple_instance[type = 'Group_Actor'][name=$a2r/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
	<xsl:variable name="release" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	<xsl:variable name="delivery" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/>
	<xsl:variable name="lifecycleColour" select="/node()/simple_instance[type='Element_Style']"/>
 
  <!--  <xsl:variable name="allRoadmapInstances" select="$allTechnologyProviders"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    -->
	<xsl:template match="knowledge_base">
		{
			"delivery": [
				<xsl:apply-templates select="$delivery" mode="RenderDeliveryPieData"/>
			],
			"release": [
				<xsl:apply-templates select="$release" mode="RenderReleasePieData"/>
			]
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderDeliveryPieData" match="node()">
	 	<xsl:variable name="thisTechnologyProviders" select="$allTechnologyProviders[own_slot_value[slot_reference='technology_provider_delivery_model']/value=current()/name]"/>
		 <xsl:variable name="thisColour" select="$lifecycleColour[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/>
     
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		 	"name":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isRenderAsJSString" select="true()"/>
					</xsl:call-template>",
			"count": <xsl:value-of select="count($thisTechnologyProviders)"></xsl:value-of>,
			"piecount": <xsl:value-of select="count($thisTechnologyProviders)"></xsl:value-of>,
			"colour":"<xsl:choose><xsl:when test="$thisColour/own_slot_value[slot_reference='element_style_colour']/value"><xsl:value-of select="$thisColour/own_slot_value[slot_reference='element_style_colour']/value"></xsl:value-of></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		    "orgsUsage":[<xsl:apply-templates select="$thisTechnologyProviders" mode="renderOrgData"/>]
 	 
	 	}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
 
	</xsl:template>
	
	<xsl:template mode="RenderReleasePieData" match="node()">
	 	<xsl:variable name="thisTechnologyProviders" select="$allTechnologyProviders[own_slot_value[slot_reference='vendor_product_lifecycle_status']/value=current()/name]"/>
		 <xsl:variable name="thisColour" select="$lifecycleColour[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/>
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		 	"name":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isRenderAsJSString" select="true()"/>
					</xsl:call-template>",
			"count": <xsl:value-of select="count($thisTechnologyProviders)"></xsl:value-of>,
			"piecount": <xsl:value-of select="count($thisTechnologyProviders)"></xsl:value-of>,
			"colour":"<xsl:choose><xsl:when test="$thisColour/own_slot_value[slot_reference='element_style_colour']/value"><xsl:value-of select="$thisColour/own_slot_value[slot_reference='element_style_colour']/value"></xsl:value-of></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		    "orgsUsage":[<xsl:apply-templates select="$thisTechnologyProviders" mode="renderOrgData"/>]
		 
	 	}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>

	</xsl:template>
	
	<xsl:template mode="renderOrgData" match="node()">
		<xsl:variable name="thisOrgs" select="$a2r[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	
					{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"orgs":[<xsl:for-each select="$thisOrgs">
			<xsl:variable name="thisOrgActor" select="$appOrgActor[name=current()/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
			{"id": "<xsl:value-of select="eas:getSafeJSString($thisOrgActor/name)"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>]
		 
	 	}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
	</xsl:template>
  
</xsl:stylesheet>
