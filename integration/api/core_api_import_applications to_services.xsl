<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="applications" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]"/> 
	<xsl:variable name="applicationServices" select="/node()/simple_instance[type='Application_Service']"/>
	<xsl:variable name="aprs" select="/node()/simple_instance[type='Application_Provider_Role']"/>

	<xsl:key name="apr_key" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
	<xsl:key name="service_key" match="/node()/simple_instance[type=('Application_Service')]" use="own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
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
		{"applications_to_services":[<xsl:apply-templates select="$applications" mode="appsvc"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"616"}
	</xsl:template>

<xsl:template match="node()" mode="appsvc">
		<xsl:variable name="thisaprs" select="key('apr_key',current()/name)"/>
		<xsl:variable name="thisservices" select="key('service_key',$thisaprs/name)"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
		}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,		
		"services":[<xsl:for-each select="$thisservices">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
		}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
</xsl:stylesheet>
