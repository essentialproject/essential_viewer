<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="applications" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]"/> 
	<xsl:variable name="codebase" select="/node()/simple_instance[type='Codebase_Status']"/> 
	<xsl:variable name="delivery" select="/node()/simple_instance[type='Application_Delivery_Model']"/> 
	<xsl:variable name="lifecycle" select="/node()/simple_instance[type='Lifecycle_Status']"/> 
 
	 
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
		{"applications":[<xsl:apply-templates select="$applications" mode="apps"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]}
	</xsl:template>

<xsl:template match="node()" mode="apps">
		<xsl:variable name="thiscodebase" select="$codebase[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]"/>
		<xsl:variable name="thisdelivery" select="$delivery[name=current()/own_slot_value[slot_reference='ap_delivery_model']/value]"/>
		<xsl:variable name="thislifecycle" select="$lifecycle[name=current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
			 </xsl:call-template>",
		"class":"<xsl:value-of select="current()/type"/>",	 
		"codebase_name":"<xsl:value-of select="$thiscodebase/own_slot_value[slot_reference='name']/value"/>",
		"dispositionId":"<xsl:value-of select="own_slot_value[slot_reference='ap_disposition_lifecycle_status']/value"/>",
		"delivery_name":"<xsl:value-of select="$thisdelivery/own_slot_value[slot_reference='name']/value"/>",
		"codebase":"<xsl:value-of select="$thiscodebase/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"delivery":"<xsl:value-of select="$thisdelivery/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"lifecycle":"<xsl:value-of select="$thislifecycle/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
		"lifecycle_name":"<xsl:value-of select="$thislifecycle/own_slot_value[slot_reference='name']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
</xsl:stylesheet>
