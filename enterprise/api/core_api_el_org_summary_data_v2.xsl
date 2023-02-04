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
	<xsl:variable name="allApplicationsUsed" select="$applicationsUsed union $applicationsUsedAPR union $applicationsAOU"/>
	<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"/>

	<xsl:key name="allActor2RoleRelations_key" match="$allActor2RoleRelations" use="own_slot_value[slot_reference = 'act_to_role_to_role']/value"/> 
	<xsl:key name="allActor2RoleRelationsviaActor_key" match="$allActor2RoleRelations" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/> 
	
	<xsl:key name="physicalProcessA2s_key" match="$physicalProcessA2s" use="own_slot_value[slot_reference = 'process_performed_by_actor_role']/value"/> 
	<xsl:key name="businessProcess_key" match="$businessProcess" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/> 
	<xsl:key name="app_pro_phys_bus_key" match="$applicationsUsedMapping" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/> 
	<xsl:key name="aprPhysProcess_key" match="$applicationsUsedviaAPR" use="own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/> 
	<xsl:key name="appToapr_key" match="$allApplicationsUsed" use="own_slot_value[slot_reference = 'provides_application_services']/value"/> 
	<xsl:key name="appToPhysDirect_key" match="$allApplicationsUsed" use="own_slot_value[slot_reference = 'app_pro_supports_phys_proc']/value"/>
	<xsl:key name="applicationsAOU_key" match="$applicationsAOU" use="own_slot_value[slot_reference = 'stakeholders']/value"/>
	<xsl:key name="allRoles_key" match="$allRoles" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
	<xsl:key name="actor_key" match="$allActors" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
	<xsl:key name="allactor2r_key" match="$allActor2RoleRelations" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/> 

	<xsl:key name="allDocs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
	<xsl:key name="allTaxTerms_key" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
	 
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
			 "orgRoles":[<xsl:apply-templates select="$allOrgs" mode="a2rs"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			 "a2rs":[<xsl:apply-templates select="$allActor2RoleRelations" mode="a2rsOnly"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			 "version":"615"} 
	</xsl:template>

 
	<xsl:template mode="getOrgs" match="node()">
		<xsl:variable name="orgName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
	
		<xsl:variable name="rootOrgID" select="$allActors[own_slot_value[slot_reference = 'contained_sub_actors']/value = current()/name]/name"/>
		<xsl:variable name="thisparentActor" select="$allActors[name = $rootOrgID]"/> 
		<xsl:variable name="thisChildActors" select="$allOrgs[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
		<xsl:variable name="allOrgUserIds" select="$allActors[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
        <xsl:variable name="thisEmployees" select="$allActors[type='Individual_Actor'][name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
       
		<xsl:variable name="parentActorName" select="$thisparentActor/own_slot_value[slot_reference = 'name']/value"/>
	<!--	<xsl:variable name="thisactor2role" select="$allActor2RoleRelations[own_slot_value[slot_reference='act_to_role_from_actor']/value=current()/name]"/>-->
		<xsl:variable name="thisactor2role" select="key('allActor2RoleRelations_key',current()/name)"/>		
		<xsl:variable name="thisphysicalProcessA2R" select="key('physicalProcessA2s_key',$thisactor2role/name)"/>	
		<xsl:variable name="thisphysicalProcessDirect" select="key('physicalProcessA2s_key',current()/name)"/>	
	<!--<xsl:variable name="thisphysicalProcessA2R" select="$physicalProcess[own_slot_value[slot_reference='process_performed_by_actor_role']/value=$thisactor2role/name]"/>
		<xsl:variable name="thisphysicalProcessDirect" select="$physicalProcess[own_slot_value[slot_reference='process_performed_by_actor_role']/value=current()/name]"/>
	-->		<xsl:variable name="thisphysicalProcess" select="$thisphysicalProcessA2R union $thisphysicalProcessDirect"/>

	<!--	<xsl:variable name="thisapplicationsUsedMapping" select="$applicationsUsedMapping[name=$thisphysicalProcess/own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value]"/>
	-->		<xsl:variable name="thisapplicationsUsedMapping" select="key('app_pro_phys_bus_key',$thisphysicalProcess/name)"/>	
	<xsl:variable name="thisapplicationsUsedviaAPR" select="key('aprPhysProcess_key',$thisapplicationsUsedMapping/name)"/>	
	<!--	<xsl:variable name="thisapplicationsUsedviaAPR" select="$applicationsUsedviaAPR[name=$thisapplicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/>
-->
<xsl:variable name="thisapplicationsUsedAPR" select="key('appToapr_key',$thisapplicationsUsedviaAPR/name)"/>	
<!--
		<xsl:variable name="thisapplicationsUsedAPR" select="$allApplicationsUsed[name=$thisapplicationsUsedviaAPR/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
-->
<!--		<xsl:variable name="thisapplicationsUsed" select="$allApplicationsUsed[name=$thisapplicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/> -->
		<xsl:variable name="thisapplicationsUsed" select="key('appToPhysDirect_key',$thisapplicationsUsedMapping/name)"/>	
		
		<xsl:variable name="thisallApplicationsUsed" select="$thisapplicationsUsed union $thisapplicationsUsedAPR"/>
	
		<xsl:variable name="thisbaseSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>

		<xsl:variable name="thisA2RForActor" select="key('allActor2RoleRelationsviaActor_key',current()/name)"/>	

<!--	
		<xsl:variable name="thisA2RForActor" select="$allActor2RoleRelations[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
-->
        <xsl:variable name="thisA2RForAppOrgUser" select="$applicationOrgUserA2R[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="thisA2RForAppOrgUserApps" select="key('applicationsAOU_key',$thisA2RForAppOrgUser/name)"/>	
<!--	
        <xsl:variable name="thisA2RForAppOrgUserApps" select="$applicationsAOU[own_slot_value[slot_reference = 'stakeholders']/value = $thisA2RForAppOrgUser/name]"/>
-->
<xsl:variable name="thisRolesForActor" select="key('allRoles_key',$thisA2RForActor/name)"/>	
<!--
        <xsl:variable name="thisRolesForActor" select="$allRoles[name = $thisA2RForActor/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
-->     
<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
<!-- for all children, not just direct -->
<xsl:variable name="relevantchildren" select="eas:get_descendants(current(), $allActors, 0, 10, 'is_member_of_actor')"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isForJSONAPI" select="true()"/>
                </xsl:call-template>",
        "description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
            </xsl:call-template>",             
        "parentOrgs":[<xsl:for-each select="$thisparentActor">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"childOrgs":[<xsl:for-each select="$thisChildActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
		"allChildOrgs":[<xsl:for-each select="$relevantchildren">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"documents":[<xsl:for-each select="$thisDocs">
		<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>",
		"documentLink":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'external_reference_url']/value"/>",
		"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
		"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
		"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>],   
		"orgEmployees":[<xsl:for-each select="$thisEmployees"> 
				<xsl:variable name="thisEmployeeA2Rs" select="key('allActor2RoleRelationsviaActor_key',current()/name)"/>	
				<xsl:variable name="thisEmployeeRoles" select="key('allRoles_key',$thisEmployeeA2Rs/name)"/>	
				  
				<!--
            <xsl:variable name="thisEmployeeA2Rs" select="$allActor2RoleRelations[name = current()/own_slot_value[slot_reference = 'actor_plays_role']/value]"/>
            <xsl:variable name="thisEmployeeRoles" select="$allRoles[name = $thisEmployeeA2Rs/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>-->
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
		"roles":[<xsl:for-each select="$thisEmployeeRoles">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"site":[<xsl:apply-templates select="$thisbaseSites" mode="getSimpleJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"orgUsersA2R":[<xsl:apply-templates select="$thisA2RForAppOrgUser" mode="getSimpleJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "orgUserIds":[<xsl:for-each select="$allOrgUserIds">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
        "businessProcess":[<xsl:apply-templates select="$thisphysicalProcess" mode="getPhysicalProcessJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "applicationsUsedbyProcess":[<xsl:apply-templates select="$thisallApplicationsUsed" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "applicationsUsedbyOrgUser":[<xsl:apply-templates select="$thisA2RForAppOrgUserApps" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
	
	<xsl:template mode="getSimpleJSON" match="node()">
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template mode="getPhysicalProcessJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
<!--	<xsl:variable name="thisBusProc" select="$businessProcess[name=$this/own_slot_value[slot_reference='implements_business_process']/value]"/>
-->	
		<xsl:variable name="thisBusProc" select="key('businessProcess_key',current()/name)"/>	
        <xsl:variable name="thisBusProcCriticality" select="$businessCriticality[name=$thisBusProc/own_slot_value[slot_reference='bpt_business_criticality']/value]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
        "id":"<xsl:value-of select="eas:getSafeJSString($thisBusProc/name)"/>",
        "criticality":"<xsl:value-of select="$thisBusProcCriticality/own_slot_value[slot_reference='enumeration_value']/value"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template mode="getAppsJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template mode="a2rs" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="a2rs" select="key('allactor2r_key',current()/name)"/>
		<xsl:variable name="thisroles" select="key('allRoles_key',$a2rs/name)"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"actor":"<xsl:value-of select="$a2rs/name"/>", 
		"a2rs":[<xsl:for-each select="$a2rs">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
		"roles":[<xsl:for-each select="$thisroles">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template mode="a2rsOnly" match="node()">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="thisactor2role" select="key('actor_key',current()/name)"/>
			<xsl:variable name="thisroles" select="key('allRoles_key',current()/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"actor":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$thisactor2role"/>
					<xsl:with-param name="isForJSONAPI" select="true()"/>
				 </xsl:call-template>", 
			"actorid":"<xsl:value-of select="eas:getSafeJSString($thisactor2role/name)"/>",	 
			"type":"<xsl:value-of select="$thisactor2role/type"/>",	
		 	"role":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$thisroles"/>
					<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:function name="eas:get_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeOrgs"/>
		<xsl:param name="level"/>
		<xsl:param name="maxDepth"/>
		<xsl:param name="slotName"/>
		<xsl:sequence select="$parentNode"/>
		<xsl:if test="$level &lt; $maxDepth">
		 <xsl:variable name="childOrgs" select="$inScopeOrgs[own_slot_value[slot_reference = $slotName]/value = $parentNode/name]" as="node()*"/> 
			<xsl:for-each select="$childOrgs">
				<xsl:sequence select="eas:get_object_descendants(current(), ($inScopeOrgs), $level + 1, $maxDepth, $slotName)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>
</xsl:stylesheet>
