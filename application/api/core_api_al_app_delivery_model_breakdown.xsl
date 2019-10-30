<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<!-- 03.12.2018 JP  Created	 -->
	
	
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="appCount" select="count($allAppProviders)"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[name = $allAppProviders/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>

	<xsl:template match="knowledge_base">
		{
			"applications": [
				<xsl:apply-templates mode="RenderDeliveryModelProportion" select="$allAppDeliveryModels">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
				</xsl:apply-templates>
				<!--{
				"depModel": "Hosted",
				"proportion": 0.4
				},
				{
				"depModel": "Private Cloud",
				"proportion": 0.2
				},
				{
				"depModel": "Public Cloud",
				"proportion": 0.3
				},
				{
				"depModel": "SaaS",
				"proportion": 0.1
				}-->
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderDeliveryModelProportion" match="node()">
		<xsl:variable name="thisModelCount" select="count($allAppProviders[own_slot_value[slot_reference = 'ap_delivery_model']/value = current()/name])"/>
		<xsl:variable name="thisLabelString" select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
		
		<xsl:variable name="thisLabel">
			<xsl:choose>
				<xsl:when test="string-length($thisLabelString) > 0"><xsl:value-of select="$thisLabelString"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference = 'ap_delnameivery_model']/value"></xsl:value-of></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisPortion">
			<xsl:choose>
				<xsl:when test="($appCount > 0) and ($thisModelCount > 0)">
					<xsl:value-of select="$thisModelCount div $appCount"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		{
		"depModel": "<xsl:value-of select="$thisLabel"/>",
		"proportion": <xsl:value-of select="$thisPortion"/>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
