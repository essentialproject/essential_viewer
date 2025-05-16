<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	
	<xsl:variable name="orgs" select="/node()/simple_instance[type='Group_Actor']"/> 
	<xsl:key name="orgs" match="/node()/simple_instance[type='Group_Actor']" use="name"/> 
	<xsl:key name="sites" match="/node()/simple_instance[type='Site']" use="name"/> 
   	<xsl:variable name="sites" select="key('sites', $orgs/own_slot_value[slot_reference='actor_based_at_site']/value)"/> 
	 
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
		{"organisations":[<xsl:apply-templates select="$orgs" mode="orgs"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"614"}
	</xsl:template>

<xsl:template match="node()" mode="orgs">
	<xsl:variable name="thisparents" select="key('orgs', current()/own_slot_value[slot_reference='is_member_of_actor']/value)"/>
	<xsl:variable name="thissites" select="key('sites', current()/own_slot_value[slot_reference='actor_based_at_site']/value)"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')')),
		'external': string(translate(translate(current()/own_slot_value[slot_reference = 'external_to_enterprise']/value, '}', ')'), '{', ')'))
        }"/>
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
   <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
	<xsl:if test="$thisparents">,
		"parents":[<xsl:for-each select="$thisparents">{<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
	   <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]</xsl:if>
		<xsl:if test="$thissites">,
		"site":[<xsl:for-each select="$thissites">{<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
	   <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]</xsl:if>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
 
</xsl:stylesheet>
