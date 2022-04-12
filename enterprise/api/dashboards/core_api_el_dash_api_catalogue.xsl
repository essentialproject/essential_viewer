<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="datasetAPIs" select="node()/simple_instance[(type = 'Data_Set_API')]"/>
	<xsl:variable name="dashboardAPITag" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Dashboard API')]"/>
	<xsl:variable name="dashboardAPIs" select="$datasetAPIs[own_slot_value[slot_reference = 'element_classified_by']/value = $dashboardAPITag/name]"/>
	<xsl:variable name="qualifiersDashboardAPI" select="$datasetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core Dashboard API: Qualifiers']"/>
	

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
			"catalogue": [
				<xsl:apply-templates mode="RenderDashAPIJSON" select="$dashboardAPIs">
					<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
				</xsl:apply-templates>
				<xsl:if test="$qualifiersDashboardAPI and count($dashboardAPIs) > 0">,</xsl:if>
				<xsl:if test="$qualifiersDashboardAPI">
					<xsl:call-template name="RenderQualifiersDashAPIJSON">
						<xsl:with-param name="qualAPI" select="$qualifiersDashboardAPI"/>
					</xsl:call-template>
				</xsl:if>
			]
		}
	</xsl:template>

	
	<xsl:template mode="RenderDashAPIJSON" match="node()">
		{
			"id": "<xsl:value-of select="name"/>",
			"label": "<xsl:value-of select="own_slot_value[slot_reference = 'report_label']/value"/>",
			"type": "<xsl:value-of select="own_slot_value[slot_reference = 'report_anchor_class']/value"/>",
			"path": "<xsl:value-of select="own_slot_value[slot_reference = 'report_xsl_filename']/value"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="RenderQualifiersDashAPIJSON">
		<xsl:param name="qualAPI"/>
		{
		"id": "qualifiers",
		"label": "<xsl:value-of select="$qualAPI/own_slot_value[slot_reference = 'report_label']/value"/>",
		"type": "<xsl:value-of select="$qualAPI/own_slot_value[slot_reference = 'report_anchor_class']/value"/>",
		"path": "<xsl:value-of select="$qualAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>"
		}
	</xsl:template>
		
</xsl:stylesheet>
