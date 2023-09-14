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
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = ('Technology_Product','Technology_Product_Build')]"/> 
	<xsl:key name="allTechProdsKey" match="$allTechProds" use="own_slot_value[slot_reference = 'implements_technology_components']/value"/>

	<xsl:key name="techProd_lfc_models_key" match="/node()/simple_instance[type='Lifecycle_Model']" use="own_slot_value[slot_reference='lifecycle_model_subject']/value"/>
	<xsl:key name="techProd_lfc_usages_key" match="/node()/simple_instance[type='Vendor_Lifecycle_Status_Usage']" use="own_slot_value[slot_reference='used_in_lifecycle_model']/value"/>

	<xsl:variable name="techProdLFCModels" select="key('techProd_lfc_models_key', $allTechProds/name)"></xsl:variable>
	<xsl:variable name="techProdLFCUsages" select="key('techProd_lfc_usages_key', $techProdLFCModels/name)"></xsl:variable>
	<xsl:variable name="techProdLFCs" select="/node()/simple_instance[name = $techProdLFCUsages/own_slot_value[slot_reference='lcm_lifecycle_status']/value]"></xsl:variable>
	<xsl:variable name="currentDateString"><xsl:call-template name="JSFormatDate"><xsl:with-param name="theDate" select="current-date()"/></xsl:call-template></xsl:variable>
 

	<xsl:template match="knowledge_base">
        {"techProdRoles": [<xsl:apply-templates select="$allTechProdRoles" mode="RenderTechProdRoleJSON"/>]
				  	}
	</xsl:template>
	  <xsl:template match="node()" mode="RenderTechProdRoleJSON">
        <xsl:variable name="thisTPR" select="current()"/>
        <xsl:variable name="thisTechCompid" select="$thisTPR/own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
	 	<xsl:variable name="thisTechProdid" select="current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>		
		 <xsl:variable name="thisTechProdStandard" select="key('allTechProdStandardsKey', current()/name)"/>
		 <xsl:variable name="thisTechProd" select="key('allTechProdsKey', current()/name)"/>
		 <xsl:variable name="thisLFCModels" select="key('techProd_lfc_models_key',$thisTechProd/name)"/> 
		 <xsl:variable name="lfcUsages" select="key('techProd_lfc_usages_key',$thisLFCModels/name)"/> 
		 <xsl:variable name="currentLFCName"> <xsl:call-template name="RenderCurrentLFCUName"><xsl:with-param name="lfcUsages" select="$lfcUsages"></xsl:with-param></xsl:call-template> </xsl:variable> 
		{ 
		"id": "<xsl:value-of select="eas:getSafeJSString($thisTPR/name)"/>",
		"osid": "<xsl:value-of select="$thisTPR/name"/>",
		"techProdid": "<xsl:value-of select="eas:getSafeJSString($thisTechProdid)"/>",
		"ostpid": "<xsl:value-of select="$thisTPR/name"/>",
        "techProdName": "<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"techCompid": "<xsl:value-of select="eas:getSafeJSString($thisTechCompid)"/>",
		"ostcid": "<xsl:value-of select="$thisTPR/name"/>",
		<xsl:value-of select="$currentLFCName"/>
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
	<xsl:template name="RenderCurrentLFCUName">
		<xsl:param name="lfcUsages"/>
		<xsl:choose>
			<xsl:when test="count($lfcUsages) = 1">
				<xsl:variable name="currentLFC" select="$techProdLFCs[name = $lfcUsages[1]/own_slot_value[slot_reference='lcm_lifecycle_status']/value]"/>"lifecycle":"<xsl:value-of select="$currentLFC/own_slot_value[slot_reference='enumeration_value']/value"/>","date":"<xsl:value-of select="current()/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>",
			</xsl:when>
			<xsl:otherwise>
				"allLifecycles":[<xsl:for-each select="$lfcUsages"><xsl:sort select="own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"></xsl:sort><xsl:variable name="thisLfcUsage" select="current()"/>
				<xsl:variable name="currentLFC" select="$techProdLFCs[name = $thisLfcUsage/own_slot_value[slot_reference='lcm_lifecycle_status']/value]"/>{"lifecycle":"<xsl:value-of select="$currentLFC/own_slot_value[slot_reference='enumeration_value']/value"/>","date":"<xsl:value-of select="current()/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
			</xsl:otherwise>
		</xsl:choose>
			<xsl:for-each select="$lfcUsages[own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value &lt;= $currentDateString]"><xsl:sort select="own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"></xsl:sort>
					<xsl:if test="position() = last()">
						<xsl:variable name="thisLfcUsage" select="current()"/>
						<xsl:variable name="currentLFC" select="$techProdLFCs[name = $thisLfcUsage/own_slot_value[slot_reference='lcm_lifecycle_status']/value]"/>"lifecycle":"<xsl:value-of select="$currentLFC/own_slot_value[slot_reference='enumeration_value']/value"/>","date":"<xsl:value-of select="current()/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>",
					</xsl:if></xsl:for-each>
	
	</xsl:template>
	
</xsl:stylesheet>
