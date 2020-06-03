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
	
	
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
    
    <xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="L1BusCaps" select="$allBusCaps[name = $L0BusCaps/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
    <xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
   
    
	<xsl:template match="knowledge_base">
		{
			"bcm": [
				<xsl:apply-templates mode="RenderCaps" select="$rootBusCap">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderCaps" match="node()">
        <xsl:variable name="rootBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
	{
		"l0BusCapId": "<xsl:value-of select="current()/name"/>",
		"l0BusCapName": "<xsl:value-of select="eas:validJSONString($rootBusCapName)"/>",
        "l0BusCapDescription": "<xsl:value-of select="eas:validJSONString($rootBusCapDescription)"/>",
        "l0BusCapLink": "<xsl:value-of select="$rootBusCapLink"/>",
        "l1BusCaps": [
		<xsl:apply-templates select="$L0BusCaps" mode="l0_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
        
<!--        
		{
		"l0BusCapId": "<xsl:value-of select="current()/name"/>",
		"l0BusCapName": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
        "l0BusCapDescription": "<xsl:value-of select="eas:renderJSText(current()/own_slot_value[slot_reference = 'description']/value)"/>",
        "l0BusCapLink": "link",
        "l1BusCaps": [
		<xsl:apply-templates select="$L0BusCaps" mode="l0_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
-->
	</xsl:template>

	<xsl:template match="node()" mode="l0_caps">
		<xsl:variable name="L1Caps" select="$allBusCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		 <xsl:variable name="thisBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		{
		"busCapId": "<xsl:value-of select="current()/name"/>",
		"busCapName": "<xsl:value-of select="$thisBusCapName"/>",
		"busCapDescription": "<xsl:value-of select="$thisBusCapDescription"/>",
		"busCapLink": "<xsl:value-of select="$thisBusCapLink"/>",
		"l2BusCaps": [	
        <xsl:apply-templates select="$L1Caps" mode="l1_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates> ]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template> 
    
	<xsl:template match="node()" mode="l1_caps">
		 <xsl:variable name="thisBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
        <xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), ())"/>
        <xsl:variable name="this" select="current()/name"/>
		{
			  "busCapId": "<xsl:value-of select="current()/name"/>",
		      "busCapName": "<xsl:value-of select="eas:validJSONString($thisBusCapName)"/>",
		      "busCapDescription": "<xsl:value-of select="$thisBusCapDescription"/>",
		      "busCapLink": "<xsl:value-of select="$thisBusCapLink"/>",
        "debug":"",
        "subCaps":[<xsl:for-each select="$relevantBusCaps"><xsl:if test="current()/name!=$this">{"id":"<xsl:value-of select="current()/name"/>","name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>    
       <xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aNewList" select="$aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
