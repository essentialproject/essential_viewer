<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="nodes" select="/node()/simple_instance[type=('Technology_Node')]"/>
	<xsl:variable name="attribute" select="/node()/simple_instance[type=('Attribute')][own_slot_value[slot_reference='name']/value='IP Address']"/> 
	<xsl:variable name="attributeValue" select="/node()/simple_instance[type=('Attribute_Value')][name=$nodes/own_slot_value[slot_reference='technology_node_attributes']/value][own_slot_value[slot_reference='attribute_value_of']/value=$attribute/name]"/>
	<xsl:variable name="site" select="/node()/simple_instance[type=('Site')][name=$nodes/own_slot_value[slot_reference='technology_deployment_located_at']/value]"/> 
	 
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
		{"nodes":[<xsl:apply-templates select="$nodes" mode="nodes"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"614"}
	</xsl:template>

	
<xsl:template match="node()" mode="nodes">
	<xsl:variable name="thisattributeValue" select="$attributeValue[name=current()/own_slot_value[slot_reference='technology_node_attributes']/value]"/>
	<xsl:variable name="thissite" select="$site[name=current()/own_slot_value[slot_reference='technology_deployment_located_at']/value]"/> 

	{	
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"hostedIn":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thissite"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"ipAddress":"<xsl:value-of select="$thisattributeValue/own_slot_value[slot_reference='attribute_value']/value"/>",
		"ipAddresses":[<xsl:for-each select="$thisattributeValue/own_slot_value[slot_reference='attribute_value']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
</xsl:stylesheet>
