<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/> 
	<xsl:key name="allOrgs" match="simple_instance[type='Group_Actor']" use="type"/>   
	<xsl:key name="allIndivActorsType_key" match="simple_instance[type='Individual_Actor']" use="type"/>
	<xsl:key name="allIndivActors_key" match="simple_instance[type='Individual_Actor']" use="name"/>
	<xsl:key name="allactor_key" match="simple_instance[type=('Group_Actor','Individual_Actor','Job_Position')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
	<xsl:key name="regtoSubject_key" match="simple_instance[type = 'REGULATED_COMPONENT_RELATION']" use="own_slot_value[slot_reference = 'regulated_component_to_element']/value"/> 
	<xsl:key name="regs_key" match="simple_instance[type = 'Regulation']" use="name"/> 
	<xsl:key name="allDocs_key" match="simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
   <xsl:key name="allTaxTerms_key" match="simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
   <xsl:key name="allA2Rs" match="simple_instance[(type = 'ACTOR_TO_ROLE_RELATION')]" use="type"/> 
   <xsl:key name="allActor2RoleRelationsviaActor_key" match="simple_instance[(type = 'ACTOR_TO_ROLE_RELATION')]" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/> 
   <xsl:key name="allRoles_key" match="simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
   <xsl:key name="allroleType_key" match="simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]" use="type"/>
   <xsl:key name="allsite_key" match="simple_instance[(type = 'Site')]" use="name"/>
	<xsl:key name="jobPosition_key" match="simple_instance[(type = 'Job_Position')]" use="name"/>
	<xsl:key name="a2j_key" match="simple_instance[(type = 'ACTOR_TO_JOB_RELATION')]" use="name"/>
<!-- Process-->
<xsl:key name="allphysProc_key" match="simple_instance[(type = 'Physical_Process')]" use="own_slot_value[slot_reference='process_performed_by_actor_role']/value"/>
<xsl:key name="allbusProc_key" match="/node()/simple_instance[(type = 'Business_Process')]" use="name"/>	
<xsl:variable name="businessCriticality" select="/node()/simple_instance[type = 'Business_Criticality']"/>

<!-- Apps --> 
<xsl:key name="app_pro_phys_bus_key" match="simple_instance[(type = 'APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/> 

<xsl:key name="aprPhysProcess_key" match="simple_instance[(type = 'Application_Provider_Role')]" use="own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/> 

<xsl:key name="appToapr_key" match="simple_instance[type = ('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'provides_application_services']/value"/> 
<xsl:key name="appToPhysDirect_key" match="simple_instance[type = ('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'app_pro_supports_phys_proc']/value"/>
<xsl:key name="appToApr_key" match="simple_instance[type = ('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'provides_application_services']/value"/>
<xsl:key name="appToAppUser_key" match="simple_instance[type = ('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'stakeholders']/value"/>
	
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
			 {"orgData":[<xsl:apply-templates select="key('allOrgs', 'Group_Actor')" mode="org"/>],
			 "orgRoles":[<xsl:apply-templates select="key('allOrgs', 'Group_Actor')" mode="a2rs"></xsl:apply-templates>],
			 "indivData":[<xsl:apply-templates select="key('allIndivActorsType_key', 'Individual_Actor')" mode="getIndivduals"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			<!-- "a2r":[<xsl:apply-templates select="$allActor2RoleRelations" mode="geta2r"></xsl:apply-templates>]-->
			 "roleData":[<xsl:apply-templates select="key('allroleType_key', ('Group_Business_Role', 'Individual_Business_Role'))" mode="getAllroles"></xsl:apply-templates>],
			 "a2rs":[<xsl:apply-templates select="key('allA2Rs', 'ACTOR_TO_ROLE_RELATION')" mode="a2rsOnly"></xsl:apply-templates>],
			 "version":"621"} 
	</xsl:template>

	<xsl:template match="node()" mode="org">
		<xsl:variable name="regsForOrg" select="key('regtoSubject_key', current()/name)"/>
		<xsl:variable name="thisRegs" select="key('regs_key', $regsForOrg/own_slot_value[slot_reference='regulated_component_regulation']/value)"/>
		<xsl:variable name="allOrgUserIds" select="key('allactorname_key', current()/own_slot_value[slot_reference = 'contained_sub_actors']/value)"/>
		<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>  
		<xsl:variable name="thisEmployees" select="key('allIndivActors_key', current()/own_slot_value[slot_reference = 'contained_sub_actors']/value)"/>  
		<xsl:variable name="thisbaseSites" select="key('allsite_key', current()/own_slot_value[slot_reference = 'actor_based_at_site']/value)"/>
		<!--phys procs-->
		<xsl:variable name="thisa2r" select="key('allActor2RoleRelationsviaActor_key', current()/name)"></xsl:variable>
		<xsl:variable name="thisphysicalProcessA2R" select="key('allphysProc_key',($thisa2r/name, current()/name))"/>	
	  
		<xsl:variable name="thisapplicationsUsedMapping" select="key('app_pro_phys_bus_key',$thisphysicalProcessA2R/name)"/>	
		<xsl:variable name="thisapplicationsUsedviaAPR" select="key('aprPhysProcess_key',$thisapplicationsUsedMapping/name)"/>
			  
		<xsl:variable name="thisapplicationsUsedAPR" select="key('appToApr_key',$thisapplicationsUsedviaAPR/name)"/>  
		<xsl:variable name="thisapplicationsUsedDirect" select="key('appToPhysDirect_key',$thisapplicationsUsedMapping/name)"/>
	 	<xsl:variable name="thisapplicationsUsedActor" select="key('appToAppUser_key',$thisa2r/name)"/>
	 
		
		{ 
		  "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		  "parent":[<xsl:for-each select="current()/own_slot_value[slot_reference='is_member_of_actor']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		  <xsl:variable name="combinedMap" as="map(*)"
			select="map{
			  'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			  'short_name': string(translate(translate(current()/own_slot_value[slot_reference = ('short_name')]/value,'}',')'),'{',')')),
			  'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			
			}"/>
		  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
		  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		  "regulations": [
			<xsl:for-each select="$thisRegs">
			  {
				"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)"
				  select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
				  }"/>
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
			  }<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>
		  ], 
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
			  {
				  "id": "<xsl:value-of select=" current()/name"/>",
				  <xsl:variable name="combinedMap" as="map(*)"
					  select="map{
					  'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					  'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
					  }"/>
				  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
				  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				  "roleA2Rs":[<xsl:for-each select="$thisEmployeeA2Rs">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				  "roles":[<xsl:for-each select="$thisEmployeeRoles">{
					  <xsl:variable name="combinedMap" as="map(*)" select="map{
						  'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					  }" />
					  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
					  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
			  }<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>],
		  "site":[<xsl:apply-templates select="$thisbaseSites" mode="getSimpleJSON"></xsl:apply-templates>],
		  "businessProcess":[<xsl:apply-templates select="$thisphysicalProcessA2R" mode="getBusinessProcessJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		  "applicationsUsedbyProcess":[<xsl:apply-templates select="$thisapplicationsUsedDirect union $thisapplicationsUsedAPR" mode="getAppsJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		  "applicationsUsedbyOrgUser":[<xsl:for-each select="$thisapplicationsUsedActor">{"id":"<xsl:value-of select="current()/name"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		  "children":[<xsl:for-each select="current()/own_slot_value[slot_reference='contained_sub_actors']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]	  
		   
		}<xsl:if test="position()!=last()">,</xsl:if>
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
	  <xsl:template mode="a2rs" match="node()">
		  <xsl:variable name="this" select="current()"/>
		  <xsl:variable name="a2rs" select="key('allActor2RoleRelationsviaActor_key',current()/name)"/>
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
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		  }<xsl:if test="position()!=last()">,</xsl:if>
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
	  <xsl:template mode="getIndivduals" match="node()">	
		  <xsl:variable name="thisEmployeeA2Rs" select="key('allActor2RoleRelationsviaActor_key',current()/name)"/>	
		  <xsl:variable name="thisEmployeeRoles" select="key('allRoles_key',$thisEmployeeA2Rs/name)"/>	
		  <xsl:variable name="thisA2J" select="key('a2j_key',current()/own_slot_value[slot_reference='actor_has_jobs']/value)"/>
		  
	  {<xsl:variable name="combinedMap" as="map(*)" select="map{
		  'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	  }" />
	  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
	  "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",  
	  "positions":[<xsl:for-each select="$thisA2J">
		<xsl:variable name="thisJobPosition" select="key('jobPosition_key',$thisA2J/own_slot_value[slot_reference='actor_to_job_to_job']/value)"/>
		  {"id":"<xsl:value-of select="eas:getSafeJSString($thisJobPosition/name)"/>", 
		  <xsl:variable name="combinedMap" as="map(*)" select="map{
			  'name': string(translate(translate($thisJobPosition/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		  }" />
		  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
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
	  <xsl:template mode="getBusinessProcessJSON" match="node()">
			  <xsl:variable name="this" select="current()"/>
	   
			  <xsl:variable name="thisBusProc" select="key('allbusProc_key',current()/own_slot_value[slot_reference='implements_business_process']/value)"/>	
			  <xsl:variable name="thisBusProcCriticality" select="$businessCriticality[name=$thisBusProc/own_slot_value[slot_reference='bpt_business_criticality']/value]"/>
			  {<xsl:variable name="combinedMap" as="map(*)" select="map{
				  'name': string(translate(translate($thisBusProc/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
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
</xsl:stylesheet>
