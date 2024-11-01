<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/> 
	<xsl:key name="allactortype_key" match="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]" use="type"/>
	<xsl:variable name="allActors" select="key('allactortype_key', ('Group_Actor', 'Individual_Actor'))"/>
	<xsl:key name="allactorname_key" match="$allActors" use="name"/>
	<xsl:key name="allactorSubActor_key" match="$allActors" use="own_slot_value[slot_reference = 'contained_sub_actors']/value"/>
	<xsl:key name="allOrgs_key" match="/node()/simple_instance[(type = 'Group_Actor')]" use="type"/>
	<xsl:variable name="allOrgs" select="key('allOrgs_key', 'Group_Actor')"/>
	<xsl:key name="allOrgsName_key" match="$allOrgs" use="name"/>
	<xsl:variable name="allIndActors" select="$allActors[type = 'Individual_Actor']"/>
	<xsl:variable name="maxDepth" select="5"/>
	<xsl:key name="allsite_key" match="/node()/simple_instance[(type = 'Site')]" use="type"/>
	<xsl:key name="allrole_key" match="/node()/simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]" use="type"/>
	<xsl:key name="alla2r_key" match="/node()/simple_instance[(type = 'ACTOR_TO_ROLE_RELATION')]" use="type"/>

 	<xsl:variable name="allSites" select="key('allsite_key', 'Site')"/>
    <xsl:variable name="allRoles" select="key('allrole_key', ('Group_Business_Role','Individual_Business_Role'))"/>
	<xsl:variable name="allActor2RoleRelations" select="key('alla2r_key', 'ACTOR_TO_ROLE_RELATION')"/>
	<xsl:key name="allallActor2RoleRelations_key" match="$allActor2RoleRelations" use="own_slot_value[slot_reference='act_to_role_to_role']/value"/> 
    <xsl:variable name="businessCriticality" select="/node()/simple_instance[type = 'Business_Criticality']"/>
	<xsl:key name="allphysProc_key" match="/node()/simple_instance[(type = 'Physical_Process')]" use="type"/>
	<xsl:variable name="physicalProcesses" select="key('allphysProc_key', 'Physical_Process')"/>
	<xsl:key name="allphysProcA2R_key" match="$physicalProcesses" use="own_slot_value[slot_reference='process_performed_by_actor_role']/value"/>
	<xsl:variable name="physicalProcessA2s" select="key('allphysProcA2R_key', $allActors/name)"/>
 
    <xsl:variable name="physicalProcessDirect" select="key('allphysProcA2R_key', $allActor2RoleRelations/name)"/>
	<xsl:variable name="physicalProcess" select="$physicalProcessA2s union $physicalProcessDirect"/>

	<xsl:key name="allbusProc_key" match="/node()/simple_instance[(type = 'Business_Process')]" use="type"/>
	<xsl:variable name="businessProcess" select="key('allbusProc_key', 'Business_Process')"/>
	
	<xsl:key name="applicationsUsedMapping_key" match="/node()/simple_instance[(type = 'APP_PRO_TO_PHYS_BUS_RELATION')]" use="type"/>
    <xsl:variable name="applicationsUsedMapping" select="key('applicationsUsedMapping_key', 'APP_PRO_TO_PHYS_BUS_RELATION')"/>


    <xsl:variable name="applicationOrgUser" select="$allRoles[own_slot_value[slot_reference='name']/value='Application Organisation User']"/>
	<xsl:variable name="applicationOrgUserA2R" select="key('allallActor2RoleRelations_key', $applicationOrgUser/name)"/>
	<xsl:key name="ao2rKey" match="$applicationOrgUserA2R" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>

	<xsl:key name="allAPR_key" match="/node()/simple_instance[(type = 'Application_Provider_Role')]" use="type"/>

	<xsl:key name="allApps_key" match="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]" use="type"/>

	<xsl:variable name="applicationsUsedviaAPR" select="key('allAPR_key', 'Application_Provider_Role')"/> 
	<xsl:variable name="appList" select="key('allApps_key',('Application_Provider','Composite_Application_Provider','Application_Provider_Interface'))"/>
	<xsl:key name="appStakeholderKey" match="$appList" use="own_slot_value[slot_reference='stakeholders']/value"/>
	<xsl:variable name="applicationsAOU" select="key('appStakeholderKey', $applicationOrgUserA2R/name)"/>
	<xsl:variable name="applicationsUsedAPR" select="$appList[name=$applicationsUsedviaAPR/own_slot_value[slot_reference='role_for_application_provider']/value]"/>

	<xsl:variable name="applicationsUsed" select="$appList[name=$applicationsUsedMapping/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/>
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
	<xsl:key name="actor_key" match="$allIndActors" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>

	<xsl:key name="allactor_key" match="$allActors" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
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
			 "indivData":[<xsl:apply-templates select="$allIndActors" mode="getIndivduals"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			 "a2r":[<xsl:apply-templates select="$allActor2RoleRelations" mode="geta2r"></xsl:apply-templates>],
			 "roleData":[<xsl:apply-templates select="$allRoles" mode="getAllroles"></xsl:apply-templates>],
			 "a2rs":[<xsl:apply-templates select="$allActor2RoleRelations" mode="a2rsOnly"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			 "version":"616"} 
	</xsl:template>
	<xsl:template mode="geta2r" match="node()">
			<xsl:variable name="thisactor" select="key('allactor_key',current()/name)"/>	
			<xsl:variable name="thisEmployeeRole" select="key('allRoles_key',current()/name)"/>		
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"actorId":"<xsl:value-of select="eas:getSafeJSString($thisactor/name)"/>",
			"roleId":"<xsl:value-of select="eas:getSafeJSString($thisEmployeeRole/name)"/>"
			}<xsl:if test="position()!=last()">,</xsl:if>
			
	</xsl:template>
 
	<xsl:template mode="getOrgs" match="node()">
		<xsl:variable name="orgName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		
		<xsl:variable name="rootOrgIDpre" select="key('allactorSubActor_key', current()/name)"/>
		<xsl:variable name="rootOrgID" select="$rootOrgIDpre/name"/>
		<xsl:variable name="thisparentActor" select="$allActors[name = $rootOrgID]"/> 
		<!--<xsl:variable name="thisChildActors" select="$allOrgs[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
		<xsl:variable name="allOrgUserIds" select="$allActors[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
        <xsl:variable name="thisEmployees" select="$allIndActors[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
-->
<xsl:variable name="allOrgUserIds" select="key('allactorname_key', current()/own_slot_value[slot_reference = 'contained_sub_actors']/value)"/>
<xsl:variable name="thisChildActors" select="key('allOrgsName_key', current()/own_slot_value[slot_reference = 'contained_sub_actors']/value)"/>

<xsl:variable name="thisEmployees" select="$allOrgUserIds[type='Individual_Actor']"/>
     
		  
       
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

  <xsl:variable name="thisA2RForAppOrgUser" select="key('ao2rKey', current()/name)"/>
 <!--	       <xsl:variable name="thisA2RForAppOrgUser" select="$applicationOrgUserA2R[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>-->
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
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,         
        "parentOrgs":[<xsl:for-each select="$thisparentActor">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"childOrgs":[<xsl:for-each select="$thisChildActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
		"allChildOrgs":[<xsl:for-each select="$relevantchildren">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"documents":[<xsl:for-each select="$thisDocs">
		<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
		{"id":"<xsl:value-of select="current()/name"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
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
		{<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
		"roles":[<xsl:for-each select="$thisEmployeeRoles">{
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"site":[<xsl:apply-templates select="$thisbaseSites" mode="getSimpleJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"orgUsersA2R":[<xsl:apply-templates select="$thisA2RForAppOrgUser" mode="getSimpleJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "orgUserIds":[<xsl:for-each select="$allOrgUserIds">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
        "businessProcess":[<xsl:apply-templates select="$thisphysicalProcess" mode="getPhysicalProcessJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "applicationsUsedbyProcess":[<xsl:apply-templates select="$thisallApplicationsUsed" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
        "applicationsUsedbyOrgUser":[<xsl:apply-templates select="$thisA2RForAppOrgUserApps" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
	
	<xsl:template mode="getSimpleJSON" match="node()">
		{<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template mode="getPhysicalProcessJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
<!--	<xsl:variable name="thisBusProc" select="$businessProcess[name=$this/own_slot_value[slot_reference='implements_business_process']/value]"/>
-->	
		<xsl:variable name="thisBusProc" select="key('businessProcess_key',current()/name)"/>	
        <xsl:variable name="thisBusProcCriticality" select="$businessCriticality[name=$thisBusProc/own_slot_value[slot_reference='bpt_business_criticality']/value]"/>
		{<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
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
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"actor":"<xsl:value-of select="$a2rs/name"/>", 
		"a2rs":[<xsl:for-each select="$a2rs">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
		"roles":[<xsl:for-each select="$thisroles">{
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template mode="getIndivduals" match="node()">	
			<xsl:variable name="thisEmployeeA2Rs" select="key('allActor2RoleRelationsviaActor_key',current()/name)"/>	
			<xsl:variable name="thisEmployeeRoles" select="key('allRoles_key',$thisEmployeeA2Rs/name)"/>	
		{<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",  
		"roles":[<xsl:for-each select="$thisEmployeeA2Rs">
				<xsl:variable name="thissubEmployeeRoles" select="key('allRoles_key',current()/name)"/>
				{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"roleid":"<xsl:value-of select="eas:getSafeJSString($thissubEmployeeRoles/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template mode="getAllroles" match="node()">	
		{<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
	
	<xsl:template mode="a2rsOnly" match="node()">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="thisactor2role" select="key('allactor_key',current()/name)"/>
			<xsl:variable name="thisroles" select="key('allRoles_key',current()/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'actor': string(translate(translate($thisactor2role/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
			"actorid":"<xsl:value-of select="eas:getSafeJSString($thisactor2role/name)"/>",	 
			"type":"<xsl:value-of select="$thisactor2role/type"/>",	
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'role': string(translate(translate($thisroles/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		 	}<xsl:if test="position()!=last()">,</xsl:if>
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
