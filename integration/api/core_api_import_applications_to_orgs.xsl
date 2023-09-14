<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="applications" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]"/> 
	<xsl:variable name="a2r" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')][name=$applications/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="actor" select="/node()/simple_instance[type=('Group_Actor')][name=$a2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/> 
	<xsl:variable name="appOwner" select="/node()/simple_instance[type=('Group_Business_Role')][own_slot_value[slot_reference = 'name']/value='Application Organisation Owner']"/>
	 
	<xsl:key name="actorKey" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
 
	 
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
		{"applications_to_orgs":[<xsl:apply-templates select="$applications" mode="apporg"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]}
	</xsl:template>

<xsl:template match="node()" mode="apporg">
	<xsl:variable name="thisa2r" select="$a2r[name=current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<!--<xsl:variable name="thisactor" select="$actor[name=$thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/> -->
	<xsl:variable name="thisactor" select="key('actorKey', $thisa2r/name)"/> 
	<xsl:variable name="thisa2rOwner" select="$thisa2r[own_slot_value[slot_reference = 'act_to_role_to_role']/value=$appOwner/name]"/> 
	<xsl:variable name="thisOwnerActors" select="key('actorKey', $thisa2rOwner/name)"/> 
	
	{	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"owner":[<xsl:for-each select="$thisOwnerActors">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
		"actors":[<xsl:for-each select="$thisactor">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
</xsl:stylesheet>
