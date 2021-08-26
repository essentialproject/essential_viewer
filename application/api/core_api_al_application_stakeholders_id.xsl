<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
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
	<xsl:variable name="a2rs" select="/node()/simple_instance[(type = 'ACTOR_TO_ROLE_RELATION')][name=$allAppProviders/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="actors" select="/node()/simple_instance[(type = 'Group_Actor')][name=$a2rs/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
	<xsl:template match="knowledge_base">
        {"appStakeholders": [
            <xsl:apply-templates mode="RenderAppStakeholderJSONList" select="$allAppProviders">
                <xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
            </xsl:apply-templates>]}
	</xsl:template>
	
	<xsl:template mode="RenderAppStakeholderJSONList" match="node()">
	<xsl:variable name="thisa2rs" select="$a2rs[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="thisactors" select="$actors[name=$thisa2rs/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "stakeholders":[<xsl:if test="current()/own_slot_value[slot_reference='stakeholders']/value"><xsl:for-each select="current()/own_slot_value[slot_reference='stakeholders']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each></xsl:if>],
		"stakeholderIDs":[<xsl:for-each select="$thisactors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>

</xsl:stylesheet>
