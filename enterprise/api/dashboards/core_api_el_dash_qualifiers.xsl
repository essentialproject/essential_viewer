<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<!-- ENUMERATIONS -->
	<xsl:variable name="allDeploymentLifecycles" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="allCodebases" select="/node()/simple_instance[type = 'Codebase_Status']"/>
	<xsl:variable name="allDeliveryModels" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>
	

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
	<!-- 12.02.2021 JP  Created	 -->
	

	<xsl:template match="knowledge_base">
		{
			"Lifecycle_Status": {
				<!--“type”: “Lifecycle_Status”,-->
				"label": "<xsl:value-of select="eas:i18n('Deployment Statuses')"/>",
				"data": [
					<xsl:apply-templates mode="RenderEnumJSON" select="$allDeploymentLifecycles">
						<xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/>
					</xsl:apply-templates>
				]
			},
			"Codebase_Status": {
				<!--“type”: “Codebase_Status”,-->
				"label": "<xsl:value-of select="eas:i18n('Codebases')"/>",
				"data": [
					<xsl:apply-templates mode="RenderEnumJSON" select="$allCodebases">
						<xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/>
					</xsl:apply-templates>
				]
			},
			"Application_Delivery_Model": {
				<!--“type”: “Application_Delivery_Model”,-->
				"label": "<xsl:value-of select="eas:i18n('Delivery Models')"/>",
				"data": [
					<xsl:apply-templates mode="RenderEnumJSON" select="$allDeliveryModels">
						<xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/>
					</xsl:apply-templates>
				]
			}
		}
	</xsl:template>

	
	<xsl:template mode="RenderEnumJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisIndex">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'enumeration_sequence_number']/value"><xsl:value-of select="$this/own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"index": <xsl:value-of select="$thisIndex"/>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
