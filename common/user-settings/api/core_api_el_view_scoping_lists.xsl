<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="geoTypeTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Region Type')]"/>
	<xsl:variable name="countryType" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $geoTypeTaxonomy/name) and (own_slot_value[slot_reference = 'name']/value = 'Country')]"/>
	<xsl:variable name="allCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'element_classified_by']/value = $countryType/name]"/>

 	<xsl:variable name="allOrgs" select="/node()/simple_instance[type='Group_Actor']"/>
 	
	<!--
		* Copyright © 2008-2021 Enterprise Architecture Solutions Limited.
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
	<!-- 03.12.2020 JP  Created	 -->
	

	<xsl:template match="knowledge_base">
		{
			"scopingLists": [
				{
					"id": "<xsl:value-of select="$countryType/name"/>",
					"name": "Geography",
					"valueClass": "Geographic_Region",
					"description": "The list of Countries for the enterprise",
					"isGroup": false,
					"icon": "fa-globe",
					"color":"hsla(320, 75%, 35%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderBasicScopeJSON" select="$allCountries">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				},
				{
					"id": "Group_Actor",
					"name": "Business Unit",
					"valueClass": "Group_Actor",
					"description": "The list of business units across the enterprise",
					"isGroup": false,
					"icon": "fa-users",
					"color":"hsla(175, 60%, 40%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderBasicScopeJSON" select="$allOrgs">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				}
			]
		}
	</xsl:template>

	
	<xsl:template mode="RenderBasicScopeJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"			
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
