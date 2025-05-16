<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>
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
    <xsl:variable name="enterpriseStrategicPlans" select="/node()/simple_instance[type='Enterprise_Strategic_Plan']"/>
    <xsl:variable name="busStrategicPlans" select="/node()/simple_instance[type='Business_Strategic_Plan']"/>
    <xsl:variable name="appStrategicPlans" select="/node()/simple_instance[type='Application_Strategic_Plan']"/>
    <xsl:variable name="infoStrategicPlans" select="/node()/simple_instance[type='Information_Strategic_Plan']"/>
    <xsl:variable name="techStrategicPlans" select="/node()/simple_instance[type='Technology_Strategic_Plan']"/>
    <xsl:variable name="securityStrategicPlans" select="/node()/simple_instance[type='Security_Strategic_Plan']"/>
    <xsl:variable name="allStrategicPlans" select="$enterpriseStrategicPlans union $busStrategicPlans union $appStrategicPlans union $infoStrategicPlans union $techStrategicPlans union $securityStrategicPlans "/>
	<xsl:variable name="programmes" select="/node()/simple_instance[type='Programme']"/>
	<xsl:variable name="planningActions" select="/node()/simple_instance[type='Planning_Action']"/>
	<xsl:variable name="planningStatus" select="/node()/simple_instance[type='Planning_Status']"/>
	<xsl:variable name="projectStatus" select="/node()/simple_instance[type=('Project_Approval_Status','Project_Lifecycle_Status')]"/>
	<xsl:variable name="budgetApproval" select="/node()/simple_instance[type=('Budget_Approval_Status')]"/>
	<xsl:variable name="currency" select="/node()/simple_instance[type='Currency']"/>
	<xsl:key name="allDocs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
	<xsl:key name="allTaxTerms_key" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
	
	<xsl:variable name="p2eNodes" select="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']"/>

	<xsl:key name="allActor2RolesKey" match="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']" use="name"/>
    <xsl:variable name="allRoadmaps" select="/node()/simple_instance[type='Roadmap']"/>
	<!--<xsl:variable name="programmeStakeholders" select="$allActor2Roles[name = $programmes/own_slot_value[slot_reference = 'stakeholders']/value]"/>-->
	<xsl:variable name="programmeStakeholders" select="key('allActor2RolesKey', $programmes/own_slot_value[slot_reference = 'stakeholders']/value)"/>
	<xsl:key name="programmeStakeholders" match="$programmeStakeholders" use="name"/>
	
	<xsl:variable name="fullprojectsList" select="/node()/simple_instance[type='Project']"/>

	<xsl:key name="orgs_key" match="/node()/simple_instance[type='Group_Actor']" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
	<xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor','Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
    <xsl:key name="roles_key" match="/node()/simple_instance[type=('Individual_Business_Role','Group_Business_Role')]" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
    
	<xsl:key name="milestone_key" match="/node()/simple_instance[type='Change_Milestone']" use="own_slot_value[slot_reference = 'cm_change_activity']/value"/>
	<xsl:key name="planToProj_key" match="/node()/simple_instance[supertype='Strategic_Plan']" use="own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value"/>
	 
 
	<xsl:key name="objectives_key" match="/node()/simple_instance[type=('Information_Architecture_Objective', 'Technology_Architecture_Objective', 'Application_Architecture_Objective', 'Business_Objective')]" use="own_slot_value[slot_reference = 'objective_supported_by_strategic_plan']/value"/> 
	<xsl:variable name="drivers" select="/node()/simple_instance[type=('Business_Driver', 'Application_Driver', 'Information_Driver', 'Technology_Driver')]"/>
	
	<!-- Set up the required link classes --> 
	<xsl:key name="projects2plan_key" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference = 'ca_planned_changes']/value"/>

	<xsl:key name="projects_key" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference = 'contained_in_programme']/value"/>
	<xsl:key name="budgets_key" match="/node()/simple_instance[type='Budget']" use="own_slot_value[slot_reference = 'budget_for_change_activity']/value"/>
	<xsl:key name="budget_elements_key" match="/node()/simple_instance[supertype='Budgetary_Element']" use="own_slot_value[slot_reference = 'budgetary_element_of_budget']/value"/>
	<xsl:key name="cost_component_key" match="/node()/simple_instance[type='Cost_Component_Type']" use="name"/>
	
	<xsl:key name="costs_key" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	<xsl:key name="cost_elements_key" match="/node()/simple_instance[supertype='Cost_Component']" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>

	<xsl:key name="p2e_key" match="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_change_activity']/value"/>
	<xsl:key name="p2efromPlan_key" match="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_plan']/value"/>
	<xsl:key name="projectsfromPlan_key" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference = 'ca_planned_changes']/value"/>
	
	<xsl:key name="plans_key" match="/node()/simple_instance[supertype='Strategic_Plan']" use="own_slot_value[slot_reference = 'strategic_plan_for_elements']/value"/>
	<xsl:key name="plans4Programme_key" match="/node()/simple_instance[supertype='Strategic_Plan']" use="own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value"/>
	<xsl:key name="allImpactedElements" match="/node()/simple_instance[supertype='EA_Class']" use="name"/>
	
	<xsl:variable name="allProjects" select="key('projects_key',$programmes/name)"/>	
	<xsl:variable name="allP2E" select="key('p2e_key',$allProjects/name)"/>
	<xsl:variable name="allPlan" select="key('plans_key',$allP2E/name)"/>
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider_Interface', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function', 'Application_Function_Implementation', 'Enterprise_Strategic_Plan', 'Information_Representation','Programme','Enterprise_Strategic_Plan','Project','Roadmap')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="appsTechData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"/>
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"></xsl:variable>
	<xsl:variable name="capsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
 
	<xsl:template match="knowledge_base">
		{
			"programmes":[<xsl:apply-templates select="$programmes" mode="programme"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
 			"allPlans":[<xsl:apply-templates select="$allStrategicPlans" mode="plan"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
	 		"styles":[<xsl:apply-templates select="$planningActions union $projectStatus union $planningStatus" mode="styles"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
 	 		"roadmaps":[<xsl:apply-templates select="$allRoadmaps" mode="roadmaps"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
	 		"allProject":[<xsl:apply-templates select="$fullprojectsList" mode="projects"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
	 		"currency":"<xsl:value-of select="$defaultCurrencySymbol"/>",
			"currencyId":"<xsl:value-of select="$defaultCurrency/name"/>",
			"currencyData":[<xsl:apply-templates select="$currency" mode="ccyData"></xsl:apply-templates>]
		}
	</xsl:template>
	  
	<xsl:template match="node()" mode="plan">
			<xsl:variable name="thisPlanStatus" select="$planningStatus[name=current()/own_slot_value[slot_reference = 'strategic_plan_status']/value]"/> 
			<xsl:variable name="p2eforplan" select="key('p2efromPlan_key', current()/name)"/>
			<xsl:variable name="projectsforplan" select="key('projectsfromPlan_key', $p2eforplan/name)"/>  
			<xsl:variable name="objectivesforplan" select="key('objectives_key', current()/name)"/>  
			<xsl:variable name="driversforplan" select="$drivers[name=current()/own_slot_value[slot_reference = 'strategic_plan_drivers']/value]"/>  <!--
			<xsl:variable name="thisStakeholders" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>-->
			<xsl:variable name="thisStakeholders" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
			<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
			<!--<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>-->
			<xsl:variable name="thisStakeholdersOrgsPre" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
			<xsl:variable name="thisStakeholdersOrgs" select="$thisStakeholdersOrgsPre[own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
			<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/> 
			{
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"ea_reference":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ea_reference']/value"/>",
			"className":"<xsl:value-of select="current()/type"/>",
			"dependsOn":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'depends_on_strategic_plans']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"validStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>", 
			"validEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>",
			"planP2E":[<xsl:for-each select="$p2eforplan">
					<xsl:variable name="thisAction" select="$planningActions[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/> 
				<!--	<xsl:variable name="ele2" select="$allImpactedElements[name=current()/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>-->
					<xsl:variable name="ele" select="key('allImpactedElements', current()/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value)"/>
					<xsl:variable name="thisProj" select="key('projects2plan_key',current()/name)"/> 
					{ 
					"planInfo":{<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>},
					"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					"actionid":"<xsl:value-of select="eas:getSafeJSString($thisAction/name)"/>",
					"projectId":"<xsl:value-of select="eas:getSafeJSString($thisProj/name)"/>",
					"impactedElement":"<xsl:value-of select="eas:getSafeJSString($ele/name)"/>",
					"eletype":"<xsl:value-of select="$ele/type"/>",
					<xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate($ele/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
						'relation_description': string(translate(translate(current()/own_slot_value[slot_reference = 'relation_description']/value,'}',')'),'{',')')),
						'projectname': string(translate(translate($thisProj/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
						'action': string(translate(translate($thisAction/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					}" />
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> }<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
			"objectives":[<xsl:for-each select="$objectivesforplan">
					{ <xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
						'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
					}" />
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
					"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"drivers":[<xsl:for-each select="$driversforplan">
				{ <xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],	
			"planStatus":"<xsl:choose><xsl:when test="$thisPlanStatus"><xsl:value-of select="$thisPlanStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:when><xsl:otherwise>Not Set</xsl:otherwise></xsl:choose>",
			"projects":[<xsl:apply-templates select="$projectsforplan" mode="projects"></xsl:apply-templates>],
			"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
					<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
					"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>],
			"stakeholders":[<xsl:for-each select="$thisStakeholders">
					<xsl:variable name="thisOrgs" select="key('orgs_key',current()/name)"/>
					<xsl:variable name="thisIndivActors" select="key('actors_key',current()/name)"/>
					<xsl:variable name="thisActors" select="$thisIndivActors union $thisOrgs"/>
					<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
					{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
						'actorName': string(translate(translate($thisActors/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
						'roleName': string(translate(translate($thisRoles/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
					}"></xsl:variable>
					<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
					<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
					"type":"<xsl:value-of select="current()/type"/>",
					"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
					"type":"<xsl:value-of select="$thisActors/type"/>",
					"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>],
			"documents":[<xsl:for-each select="$thisDocs">
				<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
				{"id":"<xsl:value-of select="current()/name"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{ 
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
					'documentLink': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value, '}', ')'), '{', ')'))
				}"></xsl:variable>
				<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
				<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
				"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
				"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
				"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>		
	
	<xsl:template match="node()" mode="programme">
			<xsl:variable name="thisprogrammeStakeholders" select="key('programmeStakeholders', current()/own_slot_value[slot_reference = 'stakeholders']/value)"/> 
			<xsl:variable name="thisProjects" select="key('projects_key',current()/name)"/>
			<xsl:variable name="thisProgrammeStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'ca_approval_status']/value]"/> 
			<xsl:variable name="thisPlansViaProgramme" select="key('plans4Programme_key',current()/name)"/>
			<xsl:variable name="thisMilestones" select="key('milestone_key',current()/name)"/>
			<xsl:variable name="thisActors" select="key('orgs_key',$thisprogrammeStakeholders/name)"/> 
		<!--	<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>-->
			<xsl:variable name="thisStakeholdersOrgsPre" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
			<xsl:variable name="thisStakeholdersOrgs" select="$thisStakeholdersOrgsPre[own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
			<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
			{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')'))
			  }"></xsl:variable>
			  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
			"className":"<xsl:value-of select="current()/type"/>",
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"ea_reference":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ea_reference']/value"/>",
			"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
							<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
							"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>],
			"stakeholders":[<xsl:for-each select="$thisprogrammeStakeholders">
								<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
								<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
								{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
									'actorName': string(translate(translate($thisActors/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
									'roleName': string(translate(translate($thisRoles/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
								  }"></xsl:variable>
								  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
								  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
								"type":"<xsl:value-of select="current()/type"/>",
								"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
								"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>],
			"milestones":[<xsl:for-each select="$thisMilestones">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",			
				<xsl:variable name="combinedMap" as="map(*)" select="map{ 
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
				}"></xsl:variable>
				<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
				<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
							"milestone_date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'cm_date_iso_8601']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"proposedStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>",
			"targetEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>",
			"actualStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>",
			"forecastEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>",
			"budget":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_change_budget']/value"/>",
			"approvalStatus":"<xsl:choose><xsl:when test="$thisProgrammeStatus"><xsl:value-of select="$thisProgrammeStatus/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>Not Set</xsl:otherwise></xsl:choose>", 
			"approvalId":"<xsl:value-of select="eas:getSafeJSString($thisProgrammeStatus/name)"/>",
			"plans":[<xsl:apply-templates select="$thisPlansViaProgramme" mode="plan"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
			"projects":[<xsl:apply-templates select="$thisProjects" mode="projects"></xsl:apply-templates>],
			"documents":[<xsl:for-each select="$thisDocs">
				<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
				{"id":"<xsl:value-of select="current()/name"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{ 
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
					'documentLink': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value, '}', ')'), '{', ')'))
				}"></xsl:variable>
				<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
				<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
				"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
				"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
				"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
	
	<xsl:template match="node()" mode="roadmaps">
			<xsl:variable name="thisPlanStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'strategic_plan_status']/value]"/> 
			<!--<xsl:variable name="thisStakeholders" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
			<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
			<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>-->
			<xsl:variable name="thisStakeholders" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
			<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
			<xsl:variable name="thisStakeholdersOrgsPre" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
			<xsl:variable name="thisStakeholdersOrgs" select="$thisStakeholdersOrgsPre[own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
			{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')'))
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
			"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
					<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
					"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>],
			"stakeholders":[<xsl:for-each select="$thisStakeholders">
								<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
								<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
								{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
									'actorName': string(translate(translate($thisActors/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
									'roleName': string(translate(translate($thisRoles/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
								}"></xsl:variable>
								<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
								<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>, 
								"type":"<xsl:value-of select="current()/type"/>",
								"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
								"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>],	
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"ea_reference":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ea_reference']/value"/>",
			"strategicPlans":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"className":"<xsl:value-of select="current()/type"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>  
	
	<xsl:template match="node()" mode="projects"> 
			{
				<xsl:variable name="thisP2E" select="key('p2e_key',current()/name)"/>
				<xsl:variable name="thisProjStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>  
				<xsl:variable name="thisApprovalStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'ca_approval_status']/value]"/> 
			<!--	<xsl:variable name="thisStakeholders" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
				<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
				<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>-->
				<xsl:variable name="thisStakeholders" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
				<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
				<xsl:variable name="thisStakeholdersOrgsPre" select="key('allActor2RolesKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
				<xsl:variable name="thisStakeholdersOrgs" select="$thisStakeholdersOrgsPre[own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
				<xsl:variable name="thisMilestones" select="key('milestone_key',current()/name)"/>
				<xsl:variable name="thisBudget" select="key('budgets_key',current()/name)"/>
				<xsl:variable name="thisBudgetElements" select="key('budget_elements_key',$thisBudget/name)"/>
				<xsl:variable name="thisCost" select="key('costs_key',current()/name)"/>
				<xsl:variable name="thisCostElements" select="key('cost_elements_key',$thisCost/name)"/>
				<xsl:variable name="thisStratPlans" select="key('planToProj_key',current()/name)"/>
				<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",	 	
			<xsl:variable name="combinedMap" as="map(*)" select="map{ 
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
				'description': string(translate(translate(current()//own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
				'priority': string(translate(translate(current()//own_slot_value[slot_reference = ('project_business_priority')]/value, '}', ')'), '{', ')')),
				'ea_reference': string(translate(translate(current()//own_slot_value[slot_reference = ('ea_reference')]/value, '}', ')'), '{', ')'))
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>, 
			"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
					<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
					"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>],  
			"programme":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'contained_in_programme']/value"/>",
			"budget":[<xsl:for-each select="$thisBudgetElements">{
						"recurrence":"<xsl:value-of select="current()/type"/>",
					<!--	"ccy":"<xsl:value-of select="$currency[name=current()/own_slot_value[slot_reference='cc_cost_currency']/value]/name"/>",-->
						"amount":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='budget_amount']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='budget_amount']/value"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
						"startDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='budget_start_date_iso_8601']/value"/>",
						"endDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='budget_end_date_iso_8601']/value"/>",
						"approved":"<xsl:value-of select="$budgetApproval[name=current()/own_slot_value[slot_reference='budget_approval_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
						}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"costs":[<xsl:for-each select="$thisCostElements">{<xsl:variable name="costCat" select="key('cost_component_key', current()/own_slot_value[slot_reference='cc_cost_component_type']/value)"/>
					"recurrence":"<xsl:value-of select="current()/type"/>",
					<xsl:variable name="combinedMap" as="map(*)" select="map{ 
						'category': string(translate(translate($costCat/own_slot_value[slot_reference='enumeration_value']/value, '}', ')'), '{', ')'))
					}"></xsl:variable>
					<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
					<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
					"ccy":"<xsl:value-of select="$currency[name=current()/own_slot_value[slot_reference='cc_cost_currency']/value]/name"/>",
					"amount":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='cc_cost_amount']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_amount']/value"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
					"startDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_start_date_iso_8601']/value"/>",
					"endDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_end_date_iso_8601']/value"/>",
					<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
					}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],		
			"strategicPlans":[<xsl:for-each select="$thisStratPlans">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",			
			<xsl:variable name="combinedMap" as="map(*)" select="map{ 
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>, <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
					}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],		
			"stakeholders":[<xsl:for-each select="$thisStakeholders">
						<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
						<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
						{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
							'actorName': string(translate(translate($thisActors/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
							'roleName': string(translate(translate($thisRoles/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
						}"></xsl:variable>
						<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
						<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
						"type":"<xsl:value-of select="current()/type"/>",
						"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
						"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>], 
			"milestones":[<xsl:for-each select="$thisMilestones">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",			
			<xsl:variable name="combinedMap" as="map(*)" select="map{ 
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>, 
						"milestone_date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'cm_date_iso_8601']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"className":"<xsl:value-of select="current()/type"/>",
			"proposedStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>",
			"targetEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>",
			"actualStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>",
			"forecastEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>",
			"lifecycleStatus":"<xsl:choose><xsl:when test="$thisProjStatus/own_slot_value[slot_reference = 'name']/value"><xsl:value-of select="$thisProjStatus/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>Unknown</xsl:otherwise></xsl:choose>",
			"lifecycleStatusID":"<xsl:value-of select="eas:getSafeJSString($thisProjStatus/name)"/>",
			"lifecycleStatusOrder":"<xsl:choose><xsl:when test="$thisProjStatus/own_slot_value[slot_reference = 'enumeration_sequence_number']/value"><xsl:value-of select="$thisProjStatus/own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:when><xsl:otherwise>9</xsl:otherwise></xsl:choose>",
			"approvalStatus":"<xsl:choose><xsl:when test="$thisApprovalStatus"><xsl:value-of select="$thisApprovalStatus/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>Not Set</xsl:otherwise></xsl:choose>",
			"approvalId":"<xsl:value-of select="eas:getSafeJSString($thisApprovalStatus/name)"/>",
			"p2e":[<xsl:for-each select="$thisP2E">{ 
							<xsl:variable name="thisPlan" select="key('plans_key',current()/name)"/>
							<xsl:variable name="thisAction" select="$planningActions[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/> 
						<!--	<xsl:variable name="ele" select="$allImpactedElements[name=current()/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>-->
							<xsl:variable name="ele" select="key('allImpactedElements', current()/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value)"/>
							"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
							"actionid":"<xsl:value-of select="eas:getSafeJSString($thisAction/name)"/>", 
							"impactedElement":"<xsl:value-of select="eas:getSafeJSString($ele/name)"/>",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate($ele/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
								'relation_description': string(translate(translate(current()/own_slot_value[slot_reference = 'relation_description']/value,'}',')'),'{',')')),
								'action': string(translate(translate($thisAction/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
								'plan': string(translate(translate($thisPlan/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
							}" />
							<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
						  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
							"eletype":"<xsl:value-of select="translate($ele/type,'_',' ')"/>",
							"type":"<xsl:value-of select="$ele/supertype"/>",
							"planid":"<xsl:value-of select="eas:getSafeJSString($thisPlan/name)"/>"
						}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"documents":[<xsl:for-each select="$thisDocs">
							<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
							{"id":"<xsl:value-of select="current()/name"/>",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
								'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
								'documentLink': string(translate(translate(current()/own_slot_value[slot_reference = 'external_reference_url']/value,'}',')'),'{',')'))
							}" />
							<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
						  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
							"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
							"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
							"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
						</xsl:for-each>],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="styles">
		<xsl:variable name="thisStyle" select="eas:get_element_style_instance(current())"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"colour":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		"icon":"<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>",
		"textColour":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#000000</xsl:otherwise></xsl:choose>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="ccyData">
		{	
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",	
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
				'exchangeRate': string(translate(translate(current()/own_slot_value[slot_reference = 'currency_exchange_rate']/value,'}',')'),'{',')')),
				'symbol': string(translate(translate(current()/own_slot_value[slot_reference = 'currency_symbol']/value,'}',')'),'{',')')),
				'code': string(translate(translate(current()/own_slot_value[slot_reference = 'currency_code']/value,'}',')'),'{',')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
			"default":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_is_default']/value"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template name="RenderJSMenuLinkFunctionsTEMP">
			<xsl:param name="linkClasses" select="()"/>
			const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
			var esslinkMenuNames = {
				<xsl:call-template name="RenderClassMenuDictTEMP">
					<xsl:with-param name="menuClasses" select="$linkClasses"/>
				</xsl:call-template>
			}
		 
			function essGetMenuName(instance) { 
				let menuName = null;
				if(instance.meta?.anchorClass) {
					menuName = esslinkMenuNames[instance.meta.anchorClass];
				} else if(instance.className) {
					menuName = esslinkMenuNames[instance.className];
				}
				return menuName;
			}
			
			Handlebars.registerHelper('essRenderInstanceMenuLink', function(instance){
				if(instance != null) {
					let linkMenuName = essGetMenuName(instance); 
					let instanceLink = instance.name;   
					if(linkMenuName) {
						let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
						let linkClass = 'context-menu-' + linkMenuName;
						let linkId = instance.id + 'Link';
						instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
						
						<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
					} 
					return instanceLink;
				} else {
					return '';
				}
			});
		</xsl:template>
		<xsl:template name="RenderClassMenuDictTEMP">
			<xsl:param name="menuClasses" select="()"/>
			<xsl:for-each select="$menuClasses">
				<xsl:variable name="this" select="."/>
				<xsl:variable name="thisMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
				"<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
				</xsl:if>
			</xsl:for-each>
			
		</xsl:template>
</xsl:stylesheet>
