<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/> 
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]"/>
	<xsl:variable name="allOrgs" select="/node()/simple_instance[(type = 'Group_Actor')]"/>
	
	<xsl:variable name="allIndActors" select="$allActors[type = 'Individual_Actor']"/>
	<xsl:variable name="maxDepth" select="5"/>
 
 	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
    <xsl:variable name="allRoles" select="/node()/simple_instance[type = ('Group_Business_Role','Individual_Business_Role')]"/>
	<xsl:variable name="allActor2RoleRelations" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
    <xsl:variable name="businessCriticality" select="/node()/simple_instance[type = 'Business_Criticality']"/>
	<xsl:variable name="physicalProcessA2s" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference='process_performed_by_actor_role']/value=$allActors/name]"/>

    <xsl:variable name="physicalProcessDirect" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference='process_performed_by_actor_role']/value=$allActor2RoleRelations/name]"/>
	<xsl:variable name="physicalProcess" select="$physicalProcessA2s union $physicalProcessDirect"/>
	<xsl:variable name="businessProcess" select="/node()/simple_instance[type = 'Business_Process']"/>
	
    <xsl:variable name="applicationsUsedMapping" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
    <xsl:variable name="applicationOrgUser" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference='name']/value='Application Organisation User']"/>
	<xsl:variable name="applicationOrgUserA2R" select="$allActor2RoleRelations[own_slot_value[slot_reference='act_to_role_to_role']/value=$applicationOrgUser/name]"/>
	<xsl:variable name="applicationsUsedviaAPR" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="applicationsAOU" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')][own_slot_value[slot_reference='stakeholders']/value=$applicationOrgUserA2R/name]"/>
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
			 {"orgData":[<xsl:apply-templates select="$allOrgs" mode="getOrgs"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],"version":"614"} 
	</xsl:template>

 
	<xsl:template mode="getOrgs" match="node()">
		<xsl:variable name="orgName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
	
		<xsl:variable name="rootOrgID" select="$allActors[own_slot_value[slot_reference = 'contained_sub_actors']/value = current()/name]/name"/>
		<xsl:variable name="thisparentActor" select="$allActors[name = $rootOrgID]"/> 
        <xsl:variable name="thisChildActors" select="$allOrgs[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
        <xsl:variable name="thisEmployees" select="$allActors[type='Individual_Actor'][name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
       
		<xsl:variable name="parentActorName" select="$thisparentActor/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="thisactor2role" select="$allActor2RoleRelations[own_slot_value[slot_reference='act_to_role_from_actor']/value=current()/name]"/>		
		<xsl:variable name="thisphysicalProcessA2R" select="$physicalProcess[own_slot_value[slot_reference='process_performed_by_actor_role']/value=$thisactor2role/name]"/>
		<xsl:variable name="thisphysicalProcessDirect" select="$physicalProcess[own_slot_value[slot_reference='process_performed_by_actor_role']/value=current()/name]"/>
		<xsl:variable name="thisphysicalProcess" select="$thisphysicalProcessA2R union $thisphysicalProcessDirect"/>

		<xsl:variable name="thisapplicationsUsedMapping" select="$applicationsUsedMapping[name=$thisphysicalProcess/own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value]"/>
		
		<xsl:variable name="thisapplicationsUsedviaAPR" select="$applicationsUsedviaAPR[name=$thisapplicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/>
		
		<xsl:variable name="thisapplicationsUsedAPR" select="$allApplicationsUsed[name=$thisapplicationsUsedviaAPR/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
	
		<xsl:variable name="thisapplicationsUsed" select="$allApplicationsUsed[name=$thisapplicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisallApplicationsUsed" select="$thisapplicationsUsed union $thisapplicationsUsedAPR"/>
	
		<xsl:variable name="thisbaseSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	
        <xsl:variable name="thisA2RForActor" select="$allActor2RoleRelations[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
        <xsl:variable name="thisA2RForAppOrgUser" select="$applicationOrgUserA2R[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>

        <xsl:variable name="thisA2RForAppOrgUserApps" select="$applicationsAOU[own_slot_value[slot_reference = 'stakeholders']/value = $thisA2RForAppOrgUser/name]"/>
   
        <xsl:variable name="thisRolesForActor" select="$allRoles[name = $thisA2RForActor/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
         
 
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
                </xsl:call-template>",
        "description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",             
        "parentOrgs":[<xsl:for-each select="$thisparentActor">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
        "childOrgs":[<xsl:for-each select="$thisChildActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
        "orgEmployees":[<xsl:for-each select="$thisEmployees">
            <xsl:variable name="thisEmployeeA2Rs" select="$allActor2RoleRelations[name = current()/own_slot_value[slot_reference = 'actor_plays_role']/value]"/>
            <xsl:variable name="thisEmployeeRoles" select="$allRoles[name = $thisEmployeeA2Rs/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
            {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
            "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
            "roles":[<xsl:for-each select="$thisEmployeeRoles">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                    <xsl:with-param name="theSubjectInstance" select="current()"/>
                    <xsl:with-param name="isRenderAsJSString" select="true()"/>
                </xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	    "site":[<xsl:apply-templates select="$thisbaseSites" mode="getSiteJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "orgUsers":[<xsl:apply-templates select="$thisRolesForActor" mode="getSiteJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "businessProcess":[<xsl:apply-templates select="$thisphysicalProcess" mode="getPhysicalProcessJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "applicationsUsedbyProcess":[<xsl:apply-templates select="$thisallApplicationsUsed" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "applicationsUsedbyOrgUser":[<xsl:apply-templates select="$thisA2RForAppOrgUserApps" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
	
	<xsl:template mode="getSiteJSON" match="node()">
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template mode="getPhysicalProcessJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisBusProc" select="$businessProcess[name=$this/own_slot_value[slot_reference='implements_business_process']/value]"/>
        <xsl:variable name="thisBusProcCriticality" select="$businessCriticality[name=$thisBusProc/own_slot_value[slot_reference='bpt_business_criticality']/value]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
        "id":"<xsl:value-of select="eas:getSafeJSString($thisBusProc/name)"/>",
        "criticality":"<xsl:value-of select="$thisBusProcCriticality/own_slot_value[slot_reference='enumeration_value']/value"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template mode="getAppsJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
