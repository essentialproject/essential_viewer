<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="taxonomy" select="/node()/simple_instance[type='Taxonomy'][own_slot_value[slot_reference='name']/value=('Reference Model Layout')]"/> 
	<xsl:variable name="taxonomyCat" select="/node()/simple_instance[type='Taxonomy'][own_slot_value[slot_reference='name']/value=('Application Capability Category')]"/> 
	<xsl:variable name="taxonomyTerm" select="/node()/simple_instance[type='Taxonomy_Term'][name=$taxonomy/own_slot_value[slot_reference='taxonomy_terms']/value]"/> 
	<xsl:variable name="taxonomyTermCat" select="/node()/simple_instance[type='Taxonomy_Term'][name=$taxonomyCat/own_slot_value[slot_reference='taxonomy_terms']/value]"/> 
	<xsl:variable name="appCaps" select="/node()/simple_instance[type='Application_Capability']"/> 
 	<xsl:variable name="busCaps" select="/node()/simple_instance[type='Business_Capability']"/> 
	<xsl:variable name="busDomains" select="/node()/simple_instance[type='Business_Domain']"/> 
	 
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
		{"application_capabilities":[<xsl:apply-templates select="$appCaps" mode="appCaps"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"615"}
	</xsl:template>

<xsl:template match="node()" mode="appCaps">
 <xsl:variable name="supportedBusCaps" select="$busCaps[name=current()/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value]"/>
 <xsl:variable name="parentAppCaps" select="$appCaps[name=current()/own_slot_value[slot_reference='contained_in_application_capability']/value]"/>
 <xsl:variable name="businessDomains" select="$busDomains[name=current()/own_slot_value[slot_reference='mapped_to_business_domain']/value]"/>
<xsl:variable name="refLayer" select="$taxonomyTerm[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>
<xsl:variable name="categoryLayer" select="$taxonomyTermCat[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>	
	{
	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
             </xsl:call-template>",
		"appCapCategory":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$categoryLayer"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"businessDomain":[<xsl:for-each select="$businessDomains">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"ParentAppCapability":[<xsl:for-each select="$parentAppCaps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"SupportedBusCapability":[<xsl:for-each select="$supportedBusCaps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"ReferenceModelLayer":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$refLayer"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template> 
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
 
</xsl:stylesheet>
