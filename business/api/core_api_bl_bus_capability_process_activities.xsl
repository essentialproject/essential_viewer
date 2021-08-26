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
	

    <xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
    <xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
    <xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusCaps/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantActivities" select="/node()/simple_instance[type='Physical_Activity'][own_slot_value[slot_reference = 'parent_physical_processes']/value = $relevantPhysProcs/name]"/>
   	<xsl:variable name="a2r" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="actor" select="/node()/simple_instance[supertype='Actor']"/>
	<xsl:variable name="site" select="/node()/simple_instance[supertype='Site'][name=$relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>	
	<xsl:template match="knowledge_base">
		{
			"buscaps": [
				<xsl:apply-templates mode="RenderCaps" select="$allBusCaps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderCaps" match="node()">
        <xsl:variable name="rootBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="false()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
         
		<xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), ())"/>
		 
			<xsl:variable name="thisBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
			
	{
		"busCapId": "<xsl:value-of select="current()/name"/>",
		"busCapName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
        "processes":[<xsl:apply-templates select="$thisBusProcs" mode="RenderProcesses"/>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
        
    </xsl:template>
	
	<xsl:template mode="RenderProcesses" match="node()">
	<xsl:variable name="thisPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = current()/name]"/>
		{
		"processId": "<xsl:value-of select="current()/name"/>",
		"processName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"physical":[<xsl:apply-templates select="$thisPhysProcs" mode="RenderPhysicalProcesses"/>]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	
	</xsl:template>

		<xsl:template mode="RenderPhysicalProcesses" match="node()">
				<xsl:variable name="thisa2r" select="$a2r[name=current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisactor" select="$actor[name=$thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>	
		<xsl:variable name="thisactorDirect" select="$actor[name=current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>	
			<xsl:variable name="orgForProcess" select="$thisactor union $thisactorDirect"/>
	<xsl:variable name="thisrelevantActivities" select="$relevantActivities[own_slot_value[slot_reference = 'parent_physical_processes']/value = current()/name]"/>
		<xsl:variable name="thissite" select="$site[name=current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>	
		{
		"processId": "<xsl:value-of select="current()/name"/>",
		"processName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"orgName": "<xsl:value-of select="$orgForProcess/own_slot_value[slot_reference = 'name']/value"/>",	
		"site":"<xsl:value-of select="$thissite/own_slot_value[slot_reference = 'name']/value"/>",
		"siteid":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value"/>",	
		"activities":[<xsl:apply-templates select="$thisrelevantActivities" mode="RenderActivities"/>]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	
	</xsl:template>
	<xsl:template mode="RenderActivities" match="node()">
	<xsl:variable name="thisa2r" select="$a2r[name=current()/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value]"/>
	<xsl:variable name="thisactor" select="$actor[name=$thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>	
		{
		"activityId": "<xsl:value-of select="current()/name"/>",
		"activityName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"actor":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisactor"/></xsl:call-template>"
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
		
    
       <xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aDirectChildList" select="$allBusCaps[own_slot_value[slot_reference='supports_business_capabilities']/value = $theParentCap/name]"/>
				<xsl:variable name="aNewList" select="$aDirectChildList union $aChildList except $theParentCap"/>
				<xsl:variable name="aNewList" select="$aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
