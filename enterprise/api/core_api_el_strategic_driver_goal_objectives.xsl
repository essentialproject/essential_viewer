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
	<!-- 03.09.2019 JP  Created	 template-->
    <xsl:variable name="drivers" select="/node()/simple_instance[(type = 'Business_Driver')]"/>

	<xsl:variable name="goalTaxonomy" select="/node()/simple_instance[type='Taxonomy_Term'][own_slot_value[slot_reference='name']/value='Strategic Goal']"/> 
	<xsl:variable name="allObjectives" select="/node()/simple_instance[(type = 'Business_Objective') and not(own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name)]"/>
	<xsl:variable name="allStrategicGoals" select="/node()/simple_instance[(type = 'Business_Goal') or ((type = 'Business_Objective') and (own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name))]"/>
	<xsl:variable name="allGoals" select="$allStrategicGoals"/>
	<xsl:variable name="busCaps" select="/node()/simple_instance[type='Business_Capability']"/>
	<xsl:key name="busCapImpact" match="$busCaps" use="own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value"/>
	<xsl:key name="motivatingObjKey" match="$allObjectives" use="own_slot_value[slot_reference = 'bo_motivated_by_driver']/value"/>
	<xsl:key name="goalObjKey" match="$allObjectives" use="own_slot_value[slot_reference = 'objective_supports_goals']/value"/>
	<xsl:key name="oldgoalObjKey" match="$allObjectives" use="own_slot_value[slot_reference = 'objective_supports_objective']/value"/>
	<xsl:template match="knowledge_base">
		{
			"drivers": [
				<xsl:apply-templates mode="RenderDrivers" select="$drivers">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			],
			"objectives": [ <!-- all objectives, incl those not mapped to drivers -->
				<xsl:apply-templates mode="renderObjectives" select="$allObjectives">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderDrivers" match="node()">
    <xsl:variable name="thisGoals" select="$allGoals[own_slot_value[slot_reference='bo_motivated_by_driver']/value=current()/name]"/>
	<xsl:variable name="motivatingObjs" select="key('motivatingObjKey',current()/name)"/>
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"type": "Business_Driver",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
            "goals":[<xsl:apply-templates select="$thisGoals" mode="renderGoals"/>], 
            "motivatingObjectives":[<xsl:for-each select="$motivatingObjs">{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]  
		} <xsl:if test="not(position()=last())">, </xsl:if>
	</xsl:template>
	<xsl:template mode="renderGoals" match="node()">
	 <xsl:variable name="goalObjs" select="key('goalObjKey',current()/name)"/>
	 <xsl:variable name="oldgoalObjs" select="key('oldgoalObjKey',current()/name)"/>
	 <xsl:variable name="allObjsMappedtoGoal" select="$goalObjs union $oldgoalObjs"/>
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"type": "Business_Goal",
			"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
            "supportingCapabilities":[<xsl:for-each select="current()/own_slot_value[slot_reference='supporting_business_capabilities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"objectives":[<xsl:apply-templates select="$allObjsMappedtoGoal" mode="renderObjectives"/>] 		
		} <xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
	<xsl:template mode="renderObjectives" match="node()">
		   {
			   "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			   "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			   "type": "<xsl:value-of select="current()/type"/>",
			   "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>",
			   "targetDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='bo_target_date_iso_8601']/value"/>",
			   "boDriverMotivated":[<xsl:for-each select="current()/own_slot_value[slot_reference='bo_motivated_by_driver']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			   "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			   "supportingCapabilities":[<xsl:for-each select="current()/own_slot_value[slot_reference='supporting_business_capabilities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]
			   
		   } <xsl:if test="not(position()=last())">,</xsl:if>
	   </xsl:template>
</xsl:stylesheet>
