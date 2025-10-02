<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:variable name="geoTypeTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Region Type')]"/>
	<xsl:variable name="regionType" select="/node()/simple_instance[type='Taxonomy_Term'][(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $geoTypeTaxonomy/name) and (own_slot_value[slot_reference = 'name']/value = ('Region','Geopolitical Region'))]"/>
	<xsl:variable name="countryType" select="/node()/simple_instance[type='Taxonomy_Term'][(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $geoTypeTaxonomy/name) and (own_slot_value[slot_reference = 'name']/value = 'Country')]"/>
	<xsl:variable name="allCountries" select="/node()/simple_instance[type='Geographic_Region']"/>
	<xsl:variable name="allRegions" select="/node()/simple_instance[type='Geographic_Region'][own_slot_value[slot_reference = 'element_classified_by']/value = $regionType/name]"/>

 	<xsl:variable name="allOrgs" select="/node()/simple_instance[type='Group_Actor'][own_slot_value[slot_reference = 'external_to_enterprise']/value !='true']"/>
 
	<xsl:variable name="allSites" select="/node()/simple_instance[type='Site']"/>
	<xsl:variable name="allBCPCriticalityTiers" select="/node()/simple_instance[type='App_Business_Continuity_Criticality_Tier']"/>
	<xsl:variable name="allDRFailoverModels" select="/node()/simple_instance[type='Disaster_Recovery_Failover_Model']"/>
 
	 <xsl:variable name="scopedClassNames" select="('Composite_Application_Provider')"/>
	 <xsl:variable name="allActor2Roles" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']"/>
	 <xsl:variable name="relevantRoles" select="/node()/simple_instance[(name = $allActor2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value) and (own_slot_value[slot_reference = 'role_for_classes']/value = $scopedClassNames) and (own_slot_value[slot_reference = 'name']/value = ('IT Service Owner'))]"/>
	 <xsl:variable name="relevantActor2Roles" select="$allActor2Roles[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $relevantRoles/name]"/>
	 <xsl:variable name="relevantActors" select="/node()/simple_instance[name = $relevantActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	 <xsl:variable name="contentStatus" select="/node()/simple_instance[type='SYS_CONTENT_APPROVAL_STATUS']"/>
	 <xsl:variable name="maxDepth" select="6"/>
 
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
				<!-- {
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
					"id": "<xsl:value-of select="$regionType/name"/>",
					"name": "<xsl:for-each select="$regionType"><xsl:choose><xsl:when test="string-length(current()/own_slot_value[slot_reference = 'taxonomy_term_label']/value) = 0"><xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/></xsl:otherwise></xsl:choose><xsl:if test="position() != last()">&#160;/&#160;</xsl:if></xsl:for-each>",
					"valueClass": "Geographic_Region",
					"description": "The list of Regions for the enterprise",
					"isGroup": true,
					"icon": "fa-globe",
					"color":"hsla(39, 100%, 50%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderRegionGroupJSON" select="$allRegions">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				}, -->
			<!--	{
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
				},-->
				{
					"id": "Group_Actor",
					"name": "Business Function",
					"valueClass": "Group_Actor",
					"description": "The list of business units and their children",
					"isGroup": true,
					"icon": "fa-users",
					"color":"hsla(175, 60%, 40%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderOrgGroupScopeJSON" select="$allOrgs">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				},
				{
					"id": "Site",
					"name": "Host Location",
					"valueClass": "Site",
					"description": "The sites that host It components that are subject to resiliency",
					"isGroup": false,
					"icon": "fa-map-marker-alt",
					"color":"hsla(201, 100%, 37%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderBasicScopeJSON" select="$allSites">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				},
				<!-- {
					"id": "SYS_CONTENT_APPROVAL_STATUS",
					"name": "Content Status",
					"valueClass": "SYS_CONTENT_APPROVAL_STATUS",
					"description": "The status of an enterprise component in the repository",
					"isGroup": false,
					"icon": "fa-certificate",
					"color":"hsla(300, 76%, 72%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderBasicScopeJSONEnum" select="$contentStatus">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				}, -->
				{
					"id": "Disaster_Recovery_Failover_Model",
					"name": "Resliency Solution Type",
					"valueClass": "Disaster_Recovery_Failover_Model",
					"description": "The type of Resiliency Solution in place for an IT Component",
					"isGroup": false,
					"icon": "fa-window-restore",
					"color":"hsla(19, 100%, 37%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderBasicScopeJSON" select="$allDRFailoverModels">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				},
				{
					"id": "App_Business_Continuity_Criticality_Tier",
					"name": "Criticality Tier",
					"valueClass": "App_Business_Continuity_Criticality_Tier",
					"description": "The Resiliency Criticality Tier of an IT Component",
					"isGroup": false,
					"icon": "fa-sort-amount-up",
					"color":"hsla(19, 100%, 37%, 1)",
					"values": [
						<xsl:apply-templates mode="RenderBasicScopeJSON" select="$allBCPCriticalityTiers">
							<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						</xsl:apply-templates>
					]
				}
				<xsl:if test="count($relevantRoles) > 0">,
					<xsl:apply-templates mode="RenderStakeholderListJSON" select="$relevantRoles">
						<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
					</xsl:apply-templates>
				</xsl:if>
			]
		}
	</xsl:template>

	
	<xsl:template mode="RenderBasicScopeJSON" match="node()">
		<xsl:variable name="this" select="current()"/>{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"			
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	<xsl:template mode="RenderBasicScopeJSONEnum" match="node()">
			<xsl:variable name="this" select="current()"/>{
				"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
				"name": "<xsl:value-of select="$this/own_slot_value[slot_reference='enumeration_value']/value"/>"
				<!--"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"-->			
			}<xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:template>
	

	<xsl:template mode="RenderStakeholderListJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisActor2Roles" select="$relevantActor2Roles[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $this/name]"/>
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:value-of select="$thisName"/>",
		"valueClass": "ACTOR_TO_ROLE_RELATION",
		"description": "The list of individuals or organisations that play the role of <xsl:value-of select="$thisName"/>",
		"isGroup": false,
		"icon": "fa-users",
		"color":"hsla(170, 65%, 15%, 1)",
		"values": [
			<xsl:apply-templates mode="RenderActor2RoleScopeJSON" select="$thisActor2Roles">
				<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
			</xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

	<xsl:template mode="RenderActor2RoleScopeJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisActor" select="$relevantActors[name = $this/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisActor"/></xsl:call-template>"			
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

	
	<xsl:template mode="RenderBasicScopeJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		{"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"			
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>	

	<xsl:template mode="RenderOrgGroupScopeJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisinScopeChildActors" select="eas:get_org_descendants(current(), $allOrgs, 0)"/>
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",                 
			"group": [<xsl:apply-templates mode="RenderBasicScopeJSON" select="$thisinScopeChildActors">
					<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
				</xsl:apply-templates>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

		<xsl:template mode="RenderRegionGroupJSON" match="node()">
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="thisCountries" select="$allCountries[name = $this/own_slot_value[slot_reference = 'gr_contained_regions']/value]"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",                 
			"group": [
				<xsl:apply-templates mode="RenderBasicScopeJSON" select="$thisCountries">
					<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
				</xsl:apply-templates>
			]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

	<xsl:function name="eas:get_org_descendants" as="node()*">
	<xsl:param name="parentNode"/> 
	<xsl:param name="inScopeActors"/>
	<xsl:param name="level"/>
	<xsl:copy-of select="$parentNode"/>
	<xsl:if test="$level &lt; $maxDepth">
		<xsl:variable name="childOrgs" select="$allOrgs[name = $parentNode/own_slot_value[slot_reference = 'contained_sub_actors']/value]" as="node()*"/>
			<xsl:for-each select="$childOrgs">
		      <xsl:copy-of select="eas:get_org_descendants(current(), $allOrgs, $level + 1)"/> 
		</xsl:for-each>
	</xsl:if>
</xsl:function>
</xsl:stylesheet>
