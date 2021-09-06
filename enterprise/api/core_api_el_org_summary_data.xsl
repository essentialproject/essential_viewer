<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/> 
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]"/>
	<xsl:variable name="allOrgs" select="/node()/simple_instance[(type = 'Group_Actor')]"/>
	
	<xsl:variable name="allIndActors" select="$allActors[type = 'Individual_Actor']"/>
	<xsl:variable name="maxDepth" select="6"/>
 
 	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
    <xsl:variable name="allRoles" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
	<xsl:variable name="allActor2RoleRelations" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
 
	<xsl:variable name="physicalProcessA2s" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference='process_performed_by_actor_role']/value=$allActors/name]"/>

    <xsl:variable name="physicalProcessDirect" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference='process_performed_by_actor_role']/value=$allActor2RoleRelations/name]"/>
	<xsl:variable name="physicalProcess" select="$physicalProcessA2s union $physicalProcessDirect"/>
	<xsl:variable name="businessProcess" select="/node()/simple_instance[type = 'Business_Process']"/>
	
	<xsl:variable name="applicationsUsedMapping" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	
	<xsl:variable name="applicationsUsedviaAPR" select="/node()/simple_instance[type = ('Application_Provider_Role')][name=$applicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/>
	
	<xsl:variable name="applicationsUsedAPR" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')][name=$applicationsUsedviaAPR/own_slot_value[slot_reference='role_for_application_provider']/value]"/>

	<xsl:variable name="applicationsUsed" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')][name=$applicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allApplicationsUsed" select="$applicationsUsed union $applicationsUsedAPR"/>
	<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"/>
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
			 {"orgData":[<xsl:apply-templates select="$allOrgs" mode="getOrgs"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			 "appsList":[<xsl:apply-templates select="$allApplicationsUsed" mode="appsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>]} 
	</xsl:template>

 
	<xsl:template mode="getOrgs" match="node()">
		<xsl:variable name="orgName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
	
		<xsl:variable name="rootOrgID" select="$allActors[own_slot_value[slot_reference = 'contained_sub_actors']/value = current()/name]/name"/>
		<xsl:variable name="thisparentActor" select="$allActors[name = $rootOrgID]"/>
		<xsl:variable name="thisinScopeActors" select="eas:get_org_descendants($thisparentActor, $allActors, 0)"/>
		<xsl:variable name="parentActorName" select="$thisparentActor/own_slot_value[slot_reference = 'name']/value"/>

		<xsl:variable name="thisactor2role" select="$allActor2RoleRelations[own_slot_value[slot_reference='act_to_role_from_actor']/value=current()/name]"/>		
	
		<xsl:variable name="thisphysicalProcessA2R" select="$physicalProcess[own_slot_value[slot_reference='process_performed_by_actor_role']/value=$thisactor2role/name]"/>
		<xsl:variable name="thisphysicalProcessDirect" select="$physicalProcess[own_slot_value[slot_reference='process_performed_by_actor_role']/value=$thisinScopeActors/name]"/>
		<xsl:variable name="thisphysicalProcess" select="$thisphysicalProcessA2R union $thisphysicalProcessDirect"/>

		<xsl:variable name="thisapplicationsUsedMapping" select="$applicationsUsedMapping[name=$thisphysicalProcess/own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value]"/>
		
		<xsl:variable name="thisapplicationsUsedviaAPR" select="applicationsUsedviaAPR[name=$thisapplicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/>
		
		<xsl:variable name="thisapplicationsUsedAPR" select="$applicationsUsedAPR[name=$thisapplicationsUsedviaAPR/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
	
		<xsl:variable name="thisapplicationsUsed" select="$applicationsUsed[name=$thisapplicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisallApplicationsUsed" select="$thisapplicationsUsed union $thisapplicationsUsedAPR"/>
	
		<xsl:variable name="thisbaseSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	
		<xsl:variable name="thisA2RForActor" select="$allActor2RoleRelations[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="thisRolesForActor" select="$allRoles[name = $thisA2RForActor/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
 
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
    	"data":[{"vis":[<xsl:call-template name="PrintOrgChart"><xsl:with-param name="rootNode" select="$thisparentActor"/><xsl:with-param name="parentNode" select="current()"/><xsl:with-param name="inScopeActors" select="$thisinScopeActors"/><xsl:with-param name="level" select="1"/></xsl:call-template>]}],
	    "site":[<xsl:apply-templates select="$thisbaseSites" mode="getSiteJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"orgUsers":[<xsl:apply-templates select="$thisRolesForActor" mode="getSiteJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"physicalProcess":[<xsl:apply-templates select="$thisphysicalProcess" mode="getPhysicalProcessJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"applicationsUsed":[<xsl:apply-templates select="$thisallApplicationsUsed" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]  }<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
	
	<xsl:template mode="getSiteJSON" match="node()">
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"link":"<xsl:call-template name="RenderInstanceLinkForJS">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template mode="getPhysicalProcessJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisBusProc" select="$businessProcess[name=$this/own_slot_value[slot_reference='implements_business_process']/value]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString($thisBusProc/name)"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template mode="appsJSON" match="node()">
		<xsl:variable name="thisStatus" select="$codebase[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]"/>
			
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"codebase":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$thisStatus"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template mode="getAppsJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template name="PrintOrgChart">
			<xsl:param name="rootNode"/>
			<xsl:param name="parentNode"/>
			<xsl:param name="inScopeActors"/>
			<xsl:param name="level"/>
	
			<xsl:choose>
				<xsl:when test="count($rootNode) > 0">
					<xsl:variable name="rootName" select="$rootNode/own_slot_value[slot_reference = 'name']/value"/>
					<xsl:text>{"id": "ROOT","name": "</xsl:text>
					<xsl:value-of select="$rootName"/>
					<xsl:text>","data":{}, "children":[</xsl:text>
					<xsl:call-template name="PrintActorTreeDataNamed">
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="inScopeActors" select="$inScopeActors"/>
						<xsl:with-param name="level" select="$level"/>
					</xsl:call-template>
					<xsl:text>]}</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="PrintActorTreeDataNamed">
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="inScopeActors" select="$inScopeActors"/>
						<xsl:with-param name="level" select="$level"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
	
		</xsl:template>
		<xsl:template name="PrintActorTreeDataNamed">
				<xsl:param name="parentNode"/>
				<xsl:param name="inScopeActors"/>
				<xsl:param name="level"/>
		
				<xsl:variable name="parentName" select="$parentNode/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:text>{"id": "</xsl:text>
				<xsl:value-of select="$parentNode/name"/>
				<xsl:text>","name": "</xsl:text>
				<xsl:value-of select="$parentName"/>
				<xsl:text>","data":{}, "children":[</xsl:text>
		
				<xsl:if test="$level &lt; $maxDepth">
					<xsl:variable name="childActors" select="$inScopeActors[name = $parentNode/own_slot_value[slot_reference = 'contained_sub_actors']/value]" as="node()*"/>
					<xsl:for-each select="$childActors">
						<xsl:call-template name="PrintActorTreeDataNamed">
							<xsl:with-param name="parentNode" select="current()"/>
							<xsl:with-param name="inScopeActors" select="$inScopeActors"/>
							<xsl:with-param name="level" select="$level + 1"/>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="position() != count($childActors)">
								<xsl:text>, </xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>]}</xsl:text>
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
