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

	
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component'][name=$allTechCaps/own_slot_value[slot_reference='realised_by_technology_components']/value]"/>
	<xsl:variable name="allTPRs" select="/node()/simple_instance[type = 'Technology_Product_Role'][own_slot_value[slot_reference='implementing_technology_component']/value=$allTechComps/name]"/>
	<xsl:variable name="techOrgUser" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference='name']/value='Technology Organisation User']"/>
	<xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference='act_to_role_to_role']/value=$techOrgUser/name]"/>
	<xsl:variable name="techOrgActor" select="/node()/simple_instance[type = 'Group_Actor'][name=$a2r/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
	<xsl:variable name="productsForOrgs" select="/node()/simple_instance[type = 'Technology_Product'][own_slot_value[slot_reference='stakeholders']/value=$a2r/name]"/>
  
    
	<xsl:template match="knowledge_base">
		{
			"technology_capabilities": [
				<xsl:apply-templates select="$allTechCaps" mode="RenderTechnologyCapabilities"/>
			]
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderTechnologyCapabilities" match="node()">
		<xsl:variable name="allRelevantTechCaps" select="eas:get_object_descendants(current(), $allTechCaps, 0, 6, 'contained_in_technology_capability')"/>
		
		<xsl:variable name="thistechComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $allRelevantTechCaps/name]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"techComponents": [	
				<xsl:apply-templates select="$thistechComponents" mode="RenderTechComponents"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
	</xsl:template>

  	<xsl:template match="node()" mode="RenderTechComponents">
<xsl:variable name="thistechTPRs" select="$allTPRs[own_slot_value[slot_reference='implementing_technology_component']/value=current()/name]"/>
<xsl:variable name="thisproductsForOrgs" select="$productsForOrgs[name=$thistechTPRs/own_slot_value[slot_reference='role_for_technology_provider']/value]"/>
<xsl:variable name="thisa2r" select="$a2r[name=$thisproductsForOrgs/own_slot_value[slot_reference='stakeholders']/value]"/>
<xsl:variable name="thistechOrgActor" select="$techOrgActor[name=$thisa2r/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
	

		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>", 
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"tprs":"<xsl:value-of select="count($thistechTPRs)"/>",
		"usersList":[<xsl:for-each select="$thistechOrgActor">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>	

	
</xsl:stylesheet>
