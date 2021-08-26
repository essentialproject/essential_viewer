<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:import href="../../common/core_el_ref_model_include.xsl"/>
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
	
    <xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
   
    
	<xsl:template match="knowledge_base">
		{
			"businessCapabilityHierarchy": [
				<xsl:apply-templates select="$rootBusCap" mode="subCaps">
					<xsl:with-param name="level" select="0"/>
					<xsl:with-param name="maxDepth" select="5"/>
			 	</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template match="node()" mode="subCaps">
	<xsl:param name="level"/>
<xsl:param name="maxDepth"/>		
		<xsl:variable name="rootBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="busCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>


<xsl:variable name="children" select="$allBusCaps[name=current()/own_slot_value[slot_reference='contained_business_capabilities']/value]"/>	
	<xsl:if test="$level &lt; $maxDepth">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>",
	"link":"<xsl:value-of select="$busCapLink"/>",	
	"children":[<xsl:apply-templates select="$children" mode="subCaps">
				<xsl:with-param name="level" select="$level +1"/>
		<xsl:with-param name="maxDepth" select="$maxDepth"/></xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>
