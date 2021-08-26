<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:param name="param1"/>
	
	<xsl:variable name="businessCaps" select="/node()/simple_instance[type='Business_Capability']"></xsl:variable>
	<xsl:variable name="currentBusCap" select="$businessCaps[name = $param1]"/>
	<xsl:variable name="currentBusCapDescendants" select="eas:get_object_descendants($currentBusCap, $businessCaps, 0, 4, 'supports_business_capabilities')"/>
	<xsl:variable name="currentBusCapAncestors" select="eas:get_object_descendants($currentBusCap, $businessCaps, 0, 4, 'contained_business_capabilities')"/>
	<!--<xsl:variable name="thisBusCaps" select="$currentBusCapDescendants union $currentBusCapAncestors"/>-->
	<xsl:variable name="thisBusCaps" select="$currentBusCapDescendants"/>
	
	<xsl:variable name="allApplicationCaps" select="/node()/simple_instance[type='Application_Capability']"></xsl:variable>
	<xsl:variable name="applicationCaps" select="$allApplicationCaps[own_slot_value[slot_reference='app_cap_supports_bus_cap']/value=$thisBusCaps/name]"/>
	<xsl:variable name="appCapDescendants" select="eas:get_object_descendants($applicationCaps, $allApplicationCaps, 0, 5, 'contained_in_application_capability')"/>
	<xsl:variable name="appServices" select="/node()/simple_instance[own_slot_value[slot_reference='realises_application_capabilities']/value=$appCapDescendants/name]"/>
	<xsl:variable name="APRs" select="/node()/simple_instance[own_slot_value[slot_reference='implementing_application_service']/value=$appServices/name]"/>
	<xsl:variable name="apps" select="/node()/simple_instance[own_slot_value[slot_reference='provides_application_services']/value=$APRs/name]"/>
 	
 	
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
	

	<xsl:template match="knowledge_base">
		{
			"id": "<xsl:value-of select="$currentBusCap/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$currentBusCap"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$currentBusCap"/></xsl:call-template>",
			"applicationServices": [
				<xsl:apply-templates mode="RenderAppServiceJSON" select="$appServices">
					<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
				</xsl:apply-templates>
			],
			"meta": {
				"anchorClass": "<xsl:value-of select="$currentBusCap/type"/>"
			}
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderAppServiceJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!--<xsl:variable name="thisAPRs" select="$APRs[own_slot_value[slot_reference='implementing_application_service']/value = $this/name]"/>-->
		<xsl:variable name="thisAppCap" select="$applicationCaps[name = $this/own_slot_value[slot_reference='realises_application_capabilities']/value]"/>
		<xsl:variable name="thisBusCap" select="$businessCaps[name = $thisAppCap/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value]"/>
		<xsl:variable name="thisBusCapIdx" select="$thisBusCap[1]/own_slot_value[slot_reference='business_capability_index']/value"/>
		
		<xsl:variable name="thisIndex">
			<xsl:choose>
				<xsl:when test="$thisBusCapIdx"><xsl:value-of select="$thisBusCapIdx"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"index": <xsl:value-of select="$thisIndex"/>,
			"meta": {
				"anchorClass": "<xsl:value-of select="$this/type"/>"
			}
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
