<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:param name="param1"/>
	
	<xsl:variable name="businessCaps" select="/node()/simple_instance[type='Business_Capability']"></xsl:variable>
	<xsl:variable name="currentBusCap" select="$businessCaps[name = $param1]"/>
	<xsl:variable name="currentBusCapDescendants" select="eas:get_object_descendants($currentBusCap, $businessCaps, 0, 4, 'supports_business_capabilities')"/>
	<xsl:variable name="currentBusCapAncestors" select="eas:get_object_descendants($currentBusCap, $businessCaps, 0, 4, 'contained_business_capabilities')"/>
	<xsl:variable name="thisBusCaps" select="$currentBusCapDescendants union $currentBusCapAncestors"/>
	
	<xsl:variable name="applicationCaps" select="/node()/simple_instance[own_slot_value[slot_reference='app_cap_supports_bus_cap']/value=$thisBusCaps/name]"/>
	<xsl:variable name="acappServices" select="/node()/simple_instance[own_slot_value[slot_reference='realises_application_capabilities']/value=$applicationCaps/name]"/>
	<xsl:variable name="acAPRs" select="/node()/simple_instance[own_slot_value[slot_reference='implementing_application_service']/value=$acappServices/name]"/>
	<xsl:variable name="acapps" select="/node()/simple_instance[own_slot_value[slot_reference='provides_application_services']/value=$acAPRs/name]"/>
	 <!-- via process -->
	<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCaps/name]"></xsl:variable>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"></xsl:variable>
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"></xsl:variable>
	<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
	<xsl:variable name="relevantServices" select="/node()/simple_instance[name=$relevantAppProRoles/own_slot_value[slot_reference='implementing_application_service']/value]"/>
	<xsl:variable name="relevantapps" select="/node()/simple_instance[own_slot_value[slot_reference='provides_application_services']/value=$relevantAppProRoles/name]"/>

	<xsl:variable name="appServices" select="$acappServices union $relevantServices"/>
	<xsl:variable name="APRs" select="$acAPRs union $relevantAppProRoles"/>
	<xsl:variable name="apps" select="$relevantapps union $acapps"/>
	
 	
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
		
		<xsl:variable name="thisAPRs" select="$APRs[own_slot_value[slot_reference='implementing_application_service']/value = $this/name]"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"applicationCount": <xsl:value-of select="count($thisAPRs)"/>,
			"applications": [
				<xsl:apply-templates mode="RenderAPRJSON" select="$thisAPRs">
					<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
				</xsl:apply-templates>
			],
			"meta": {
				"anchorClass": "<xsl:value-of select="$this/type"/>"
			}
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="RenderAPRJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisApp" select="$apps[own_slot_value[slot_reference='provides_application_services']/value = $this/name]"/>
		<xsl:variable name="thisPos" select="position()"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"application": {
				"id": "<xsl:value-of select="$thisApp/name"/>",
				"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisApp"/></xsl:call-template>",
				"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisApp"/></xsl:call-template>",
				"index": <xsl:value-of select="$thisPos"/>,
				"meta": {
					"anchorClass": "<xsl:value-of select="$thisApp/type"/>"
				}
			}
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
