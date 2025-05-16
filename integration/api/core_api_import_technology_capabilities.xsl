<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
  <xsl:variable name="techDomain" select="/node()/simple_instance[type='Technology_Domain']"/>
  <xsl:variable name="techCapabilities" select="/node()/simple_instance[type='Technology_Capability']"/>

  <xsl:key name="techCapabilitiesKey" match="$techCapabilities" use="name"/>
  <xsl:key name="techComponentsKey" match="/node()/simple_instance[type='Technology_Component']" use="name"/>
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
		{"technology_capabilities":[<xsl:apply-templates select="$techCapabilities" mode="techCapabilities"></xsl:apply-templates>],
		"technology_capability_hierarchy":[<xsl:apply-templates select="$techCapabilities" mode="techCapabilityHierarchy"></xsl:apply-templates>], "version":"620"}
	</xsl:template>

	
<xsl:template mode="techCapabilities" match="node()">
	<xsl:variable name="parent" select="$techDomain[name=current()/own_slot_value[slot_reference='belongs_to_technology_domain']/value]"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"type":"<xsl:value-of select="current()/type"/>",
	"className":"<xsl:value-of select="current()/type"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')')),
		'domain': string(translate(translate($parent/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
		}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"domainId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference = 'belongs_to_technology_domain']/value)"/>",
	<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template> 
<xsl:template mode="techCapabilityHierarchy" match="node()">
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"type":"<xsl:value-of select="current()/type"/>",
"className":"<xsl:value-of select="current()/type"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	<xsl:if test="current()/type='Technology_Capability'">
	"supportingCapabilities":[<xsl:apply-templates select="key('techCapabilitiesKey', current()/own_slot_value[slot_reference='contained_technology_capabilities']/value)" mode="techCapabilityHierarchy"></xsl:apply-templates>],</xsl:if>
	"components":[<xsl:apply-templates select="key('techComponentsKey', current()/own_slot_value[slot_reference='realised_by_technology_components']/value)" mode="techCapabilityHierarchy"></xsl:apply-templates>],
	<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
