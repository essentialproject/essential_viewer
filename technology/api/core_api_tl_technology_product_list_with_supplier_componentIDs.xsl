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
   
    
<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/>
<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>   
<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
<xsl:variable name="allTechSuppliers" select="/node()/simple_instance[type='Supplier']"/>	
<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>
<xsl:key name="allTechComponentsKey" match="/node()/simple_instance[type = 'Technology_Component']" use="own_slot_value[slot_reference = 'realised_by_technology_products']/value"/>
<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[(own_slot_value[slot_reference = 'role_for_technology_provider']/value = $allTechProds/name) and (own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComponents/name)]"/>
<xsl:key name="allTechProdRolesKey" match="/node()/simple_instance[supertype='Technology_Provider_Role']" use="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
<xsl:key name="techCapsKey" match="/node()/simple_instance[type='Technology_Capability']" use="own_slot_value[slot_reference = 'realised_by_technology_components']/value"/>
<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[type='Standard_Strength']"/>
<xsl:variable name="allStandardStyles" select="/node()/simple_instance[name = $allStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>	
<xsl:key name="techProdStandardsKey" match="/node()/simple_instance[type='Technology_Provider_Standard_Specification']" use="own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value"/>
<xsl:variable name="allRoadmapInstances" select="$allTechProds"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    <!-- END ROADMAP VARIABLES -->
	
	
	<xsl:template match="knowledge_base">
		{
			"technology_products": [
        <xsl:apply-templates select="$allTechProds" mode="RenderTechProducts"/>
			] 
		}
	</xsl:template>
	
	<xsl:template mode="RenderTechProducts" match="node()">
        <xsl:variable name="thisTechOrgUser2Roles" select="$techOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thsTechUsers" select="$thisTechOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
		<xsl:variable name="theLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value]"/>
		<xsl:variable name="theDeliveryModel" select="$allTechProdDeliveryTypes[name = current()/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
		<xsl:variable name="theStatusScore" select="$theLifecycleStatus/own_slot_value[slot_reference = 'enumeration_score']/value"/>
		<!--	<xsl:variable name="thisTPR" select="$allTechProdRoles[name=current()/own_slot_value[slot_reference='implements_technology_components']/value]"/>-->
		<xsl:variable name="thisTPR" select="key('allTechProdRolesKey', current()/name)"/>
		<!--
	<xsl:variable name="thisTechComp" select="$allTechComponents[name=$thisTPR/own_slot_value[slot_reference='implementing_technology_component']/value]"/> -->
		<xsl:variable name="thisTechComp" select="key('allTechComponentsKey', $thisTPR/name)"/> 
 
		<!--<xsl:variable name="thisTechCap" select="$allTechCaps[name=$thisTechComp/own_slot_value[slot_reference='realisation_of_technology_capability']/value]"/> -->
		<xsl:variable name="thisTechCap" select="key('techCapsKey',$thisTechComp/name)"/> 
		 
		<xsl:variable name="theSupplier" select="$allTechSuppliers[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
		<xsl:variable name="thisTechProdName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisTechProdDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="false()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>	
		
	{  
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>", 
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"caps":[<xsl:for-each select="$thisTechCap">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>", 
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
			"comp":[
		
			<xsl:for-each select="$thisTPR">
				<!--<xsl:variable name="thisTechProdStandards" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = current()/name]"/>-->
				<xsl:variable name="thisTechProdStandards" select="key('techProdStandardsKey', current()/name)"/>
				
				<xsl:variable name="thisStandardStrengths" select="$allStandardStrengths[name = $thisTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
				<xsl:variable name="thisStandardStyles" select="$allStandardStyles[name = $thisStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
			<!--	<xsl:variable name="thisTechComp" select="$allTechComponents[name=current()/own_slot_value[slot_reference='implementing_technology_component']/value]"/> -->
				<xsl:variable name="thisTechComp" select="key('allTechComponentsKey', current()/name)"/> 
		<xsl:for-each select="$thisTechComp">
		{ 
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>", 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","std":"<xsl:choose><xsl:when test="$thisStandardStrengths"><xsl:value-of select="$thisStandardStrengths/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>No Standard Defined</xsl:otherwise></xsl:choose>","stdStyle":"<xsl:value-of select="$thisStandardStyles/own_slot_value[slot_reference = 'element_style_class']/value"/>",
		"stdColour":"<xsl:value-of select="$thisStandardStyles/own_slot_value[slot_reference = 'element_style_colour']/value"/>",
		"stdTextColour":"<xsl:value-of select="$thisStandardStyles/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
			"supplier":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$theSupplier"/>
			</xsl:call-template>",
			"status": "<xsl:value-of select="translate($theLifecycleStatus/name, '.', '_')"/>",
			"statusScore": <xsl:choose><xsl:when test="$theStatusScore > 0"><xsl:value-of select="$theStatusScore"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
			"delivery": "<xsl:value-of select="translate($theDeliveryModel/name, '.', '_')"/>",
			"techOrgUsers": [<xsl:for-each select="$thsTechUsers">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
