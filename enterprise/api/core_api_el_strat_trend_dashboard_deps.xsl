<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
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
	<!-- 03.12.2018 JP  Created	 -->

	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<!-- Bus Environment Categories and Factors -->
	<xsl:variable name="allBusEnvCategories" select="/node()/simple_instance[type = 'Business_Environment_Category']"/>
	<xsl:variable name="allBusEnvFactors" select="/node()/simple_instance[type = 'Business_Environment_Factor']"/>
	<xsl:variable name="allBusEnvCorrelations" select="/node()/simple_instance[name = $allBusEnvFactors/own_slot_value[slot_reference = 'bus_env_factor_correlations']/value]"/>
	
	
	<!-- Goals and Objectives -->
	<xsl:variable name="stratGoalTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>
	<xsl:variable name="objectiveTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="legacyBusinessGoals" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $stratGoalTaxTerm/name]"/>
	<xsl:variable name="directBusinessGoals" select="/node()/simple_instance[type = 'Business_Goal']"/>
	<xsl:variable name="allBusinessGoals" select="$legacyBusinessGoals union $directBusinessGoals"/>
	<xsl:variable name="allBusinessObjectives" select="$allObjectives except $legacyBusinessGoals"/>
	
	
	<!-- Reference Model Taxonomy Info -->
	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
	
	
	<!-- External Organisational Roles -->
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allExternalRoles" select="$allActor2Roles[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'role_is_external']/value = 'true')]"/>
	<xsl:variable name="allOrgs" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="externalOrgs" select="$allOrgs[own_slot_value[slot_reference = 'external_to_enterprise']/value = 'true']"/>	
	<xsl:variable name="internalOrgs" select="$allOrgs except $externalOrgs"/>
	<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root_Organisation')]"/>
	<xsl:variable name="rootOrg" select="$internalOrgs[name = $rootOrgConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	
	<!-- Product Concepts -->
	<xsl:variable name="allProdConcepts" select="/node()/simple_instance[type = 'Product_Concept']"/>
	<xsl:variable name="allProdTypes" select="/node()/simple_instance[type = 'Product_Type']"/>
	<xsl:variable name="allProducts" select="/node()/simple_instance[type = ('Product', 'Composite_Product')]"/>
	<xsl:variable name="externalProducts" select="$allProducts[own_slot_value[slot_reference = 'product_is_external']/value = 'true']"/>	
	<xsl:variable name="internalProducts" select="$allProducts except $externalProducts"/>
	<xsl:variable name="extProductStakeholder2Roles" select="/node()/simple_instance[(name = $allProducts/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $allExternalRoles/name)]"/>
	<xsl:variable name="extProductStakeholders" select="$externalOrgs[name = $extProductStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	
	<!-- Business Outcome Service Qualities -->
	<xsl:variable name="allBusOutcomeSQs" select="/node()/simple_instance[type = 'Business_Service_Quality']"/>
	
	
	<!-- Cost Types  -->
	<xsl:variable name="allCostTypes" select="/node()/simple_instance[type = 'Cost_Component_Type']"/>
	
	
	<!-- Revenue Types -->
	<xsl:variable name="allRevenueTypes" select="/node()/simple_instance[type = 'Revenue_Component_Type']"/>
	
	
	<!-- Business Domain, Capabilities, Processes and Organisations -->
	<xsl:variable name="allBusDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>
	<xsl:variable name="allBusCapabilities" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Root Business Capability')]"/>
	<xsl:variable name="rootBusCap" select="$allBusCapabilities[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0Caps" select="$allBusCapabilities[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="diffLevelTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Business Differentiation Level')]"/>
	<xsl:variable name="differentiator" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $diffLevelTaxonomy/name) and (own_slot_value[slot_reference = 'name']/value = 'Differentiator')]"/>
	
	<xsl:variable name="allBusinessProcess" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusCapabilities/name]"/>
	<xsl:variable name="allPhysicalProcesses" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $allBusinessProcess/name]"/>
	<xsl:variable name="allDirectOrganisations" select="/node()/simple_instance[(type='Group_Actor') and (name = $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
	<xsl:variable name="allOrg2RoleRelations" select="/node()/simple_instance[(type='ACTOR_TO_ROLE_RELATION') and (name = $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
	<xsl:variable name="allIndirectOrganisations" select="/node()/simple_instance[name = $allOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allOrganisations" select="$allDirectOrganisations union $allIndirectOrganisations"/>
	
	<!-- Applications -->
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	<xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
	
	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allPhyProc2AppProRoleRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $allPhysicalProcesses/name]"/>
	<xsl:variable name="allPhyProcAppProRoles" select="$allAppProviderRoles[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="allPhyProcDirectApps" select="/node()/simple_instance[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allPhyProcIndirectApps" select="/node()/simple_instance[name = $allPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allApplications" select="$allPhyProcDirectApps union $allPhyProcIndirectApps"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[name = $allAppProviderRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
	
	<!-- Information and Data -->
	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[type = 'Information_Concept']"/>
	<xsl:variable name="allDataSubjects" select="/node()/simple_instance[type = 'Data_Subject']"/>
	
	<!-- Technology -->
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[name = $allTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>

	<xsl:variable name="allTPRUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'provider_as_role']/value = $allTechProdRoles/name]"/>
	<xsl:variable name="allTechArchs" select="/node()/simple_instance[name = $allTPRUsages/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>
	<xsl:variable name="allTechProdBuilds" select="/node()/simple_instance[own_slot_value[slot_reference = 'technology_provider_architecture']/value = $allTechArchs/name]"/>
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $allTechProdBuilds/name]"/>

	
	<!-- Value Streams -->
	<xsl:variable name="allValueStages" select="/node()/simple_instance[type = 'Value_Stage']"/>
	<xsl:variable name="allValueStreams" select="/node()/simple_instance[own_slot_value[slot_reference = 'vs_value_stages']/value = $allValueStages/name]"/>
	
	<!-- Strategies -->
	<xsl:variable name="allRoadmaps" select="/node()/simple_instance[type = 'Roadmap']"/>
	<xsl:variable name="allStratPlans" select="/node()/simple_instance[name = $allRoadmaps/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value]"/>
	<xsl:variable name="allStratPlan2ElementRels" select="/node()/simple_instance[name = $allStratPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>
	<xsl:variable name="allChangedElements" select="($allBusCapabilities, $allBusinessProcess, $internalOrgs, $allAppCaps, $allAppServices, $allAppProviderRoles, $allApplications, $allTechCaps, $allTechComps, $allTechProdRoles, $allTechProds)[name = $allStratPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[type = 'Planning_Action']"/>
	

	<xsl:template match="knowledge_base">
		<xsl:call-template name="getBusinessImpactJSON"/>
	</xsl:template>


	<!-- Template to return all read only data for the view -->
	<xsl:template name="getBusinessImpactJSON">
		{
			"busEnvCategories": [
				<xsl:apply-templates mode="getBusinssEnvCategoriesJSON" select="$allBusEnvCategories"/>
			],
			"busEnvFactors": [
				<xsl:apply-templates mode="getBusinssEnvFactorsJSON" select="$allBusEnvFactors"/>
			],
			"productConcepts": [
				<xsl:apply-templates mode="getProductConceptsJSON" select="$allProdConcepts"/>
			],
			"productTypes": [
				<xsl:apply-templates mode="getProductTypesJSON" select="$allProdTypes"/>
			],
			"internalProducts": [
				<xsl:apply-templates mode="getInternalProductsJSON" select="$internalProducts"/>
			],
			"externalProducts": [
				<xsl:apply-templates mode="getExternalProductsJSON" select="$externalProducts"/>
			],
			"externalRoles": [
				<xsl:apply-templates mode="getExtRolesJSON" select="$allExternalRoles"/>
			],
			"externalOrgs": [
				<xsl:apply-templates mode="getExtOrgsJSON" select="$externalOrgs"/>
			],
			"internalOrgs": [
				<xsl:apply-templates mode="getIntOrgsJSON" select="$internalOrgs"/>
			],
			"strategicGoals": [
				<xsl:apply-templates mode="getBusinssGoalsJSON" select="$allBusinessGoals"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"strategicObjectives": [
				<xsl:apply-templates mode="getBusinssObjectivesJSON" select="$allBusinessObjectives"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"roadmaps": [
				<xsl:apply-templates mode="getRoadmapsJSON" select="$allRoadmaps"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"strategicPlans": [
				<xsl:apply-templates mode="getStrategicPlansJSON" select="$allStratPlans"/>
			],
			"busServiceQualities": [
				<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allBusOutcomeSQs"/>
			],
			"costTypes": [
				<xsl:apply-templates mode="RenderBasicEnumJSON" select="$allCostTypes"/>
			],
			"revenueTypes": [
				<xsl:apply-templates mode="RenderBasicEnumJSON" select="$allRevenueTypes"/>
			],
			"valueStreams": [
				<xsl:apply-templates mode="getValueStreamJSON" select="$allValueStreams"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"valueStages": [
				<xsl:apply-templates mode="getValueStageJSON" select="$allValueStages"/>
			],
			"busCaps": [
				<xsl:apply-templates mode="getBusinssCapablitiesJSON" select="$allBusCapabilities"/>
			],
			"bcmData": <xsl:call-template name="RenderBCMJSON"/>,
			<!--"irmData": <xsl:call-template name="RenderARMJSON"/>,
			"drmData": <xsl:call-template name="RenderARMJSON"/>,-->
			"appCaps": [
				<xsl:apply-templates mode="RenderAppCapDetailsJSON" select="$allAppCaps"/>
			],
			"armData": <xsl:call-template name="RenderARMJSON"/>,
			"techCaps": [
				<xsl:apply-templates mode="RenderTechCapDetailsJSON" select="$allTechCaps"/>
			],
			"trmData": <xsl:call-template name="RenderTRMJSON"/>
		}
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Environment Categories  -->
	<xsl:template match="node()" mode="getBusinssEnvCategoriesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusEnvFactors" select="$allBusEnvFactors[own_slot_value[slot_reference = 'bef_category']/value = $this/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"busEnvFactorIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusEnvFactors"/>],
		"busEnvFactors": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Environment Categories  -->
	<xsl:template match="node()" mode="getBusinssEnvFactorsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusEnvCatId" select="own_slot_value[slot_reference = 'bef_category']/value"/>
		
		<xsl:variable name="thisCorrelations" select="$allBusEnvCorrelations[name = $this/own_slot_value[slot_reference = 'bus_env_factor_correlations']/value]"/>
		<xsl:variable name="thisDepELementIds" select="$thisCorrelations/own_slot_value[slot_reference = 'dependency_to_element']/value"/>
				
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'bef_label']/value"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"busEnvCategoryId": <xsl:choose><xsl:when test="string-length($thisBusEnvCatId) > 0">"<xsl:value-of select="eas:getSafeJSString($thisBusEnvCatId)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"dependencyIds": [<xsl:for-each select="$thisDepELementIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Product Concepts  -->
	<xsl:template match="node()" mode="getProductConceptsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisProdTypeIds" select="$this/own_slot_value[slot_reference = 'product_concept_realised_by_type']/value"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"prodTypeIds": [<xsl:for-each select="$thisProdTypeIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"prodTypes": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Product Types  -->
	<xsl:template match="node()" mode="getProductTypesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisProdIds" select="$this/own_slot_value[slot_reference = 'product_type_instances']/value"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"productIds": [<xsl:for-each select="$thisProdIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"products": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Products  -->
	<xsl:template match="node()" mode="getInternalProductsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisExtProducts" select="$externalProducts[name = $this/own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value]"/>
		<xsl:variable name="thisProductStakeholder2Roles" select="$extProductStakeholder2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thisExtStakeholders" select="$extProductStakeholders[name = $thisProductStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="isExternal" select="$this/own_slot_value[slot_reference = 'product_is_external']/value = 'true'"/>
		
		<!--<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'phys_bp_supported_by_products ']/value = $this/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="suppBusCapIds" select="$thisBusCapDescendants/name"/>-->

		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"suppExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtProducts"/>],
		"suppExtOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtStakeholders"/>],
		<!--"suppBusCapIds": [<xsl:for-each select="$suppBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],-->
		"isExternal": <xsl:choose><xsl:when test="$isExternal">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Products  -->
	<xsl:template match="node()" mode="getExternalProductsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- supporting external producets and orgs -->
		<xsl:variable name="thisExtProducts" select="$externalProducts[name = $this/own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value]"/>
		<xsl:variable name="thisProductStakeholder2Roles" select="$extProductStakeholder2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thisExtStakeholders" select="$extProductStakeholders[name = $thisProductStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="isExternal" select="$this/own_slot_value[slot_reference = 'product_is_external']/value = 'true'"/>
		
		<!-- dependent internal products -->
		<xsl:variable name="depIntProducts" select="$internalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $this/name]"/>
		<xsl:variable name="depIntProdTypes" select="$allProdTypes[name = $depIntProducts/own_slot_value[slot_reference = 'instance_of_product_type']/value]"/>
			
		<!-- dependent external products -->
		<xsl:variable name="depExtProducts" select="$externalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $this/name]"/>
		
		
		<!-- dependent bus caps -->
		<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'phys_bp_supported_by_products ']/value = $this/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="depBusCapIds" select="$thisBusCapDescendants/name"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"suppExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtProducts"/>],
		"suppExtOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtStakeholders"/>],
		"depIntProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$depIntProducts"/>],
		"depExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$depExtProducts"/>],
		"depIntProductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$depIntProdTypes"/>],
		"depBusCapIds": [<xsl:for-each select="$depBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"isExternal": <xsl:choose><xsl:when test="$isExternal">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of External Roles  -->
	<xsl:template match="node()" mode="getExtRolesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisExtStakeholder2Roles" select="$extProductStakeholder2Roles[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $this/name]"/>
		<xsl:variable name="thisProds" select="$externalProducts[own_slot_value[slot_reference = 'stakeholders']/value = $thisExtStakeholder2Roles/name]"/>
		<xsl:variable name="thisDependentIntProds" select="$internalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $thisProds/name]"/>
		<xsl:variable name="thisDepIntProdTypes" select="$allProdTypes[name = $thisDependentIntProds/own_slot_value[slot_reference = 'instance_of_product_type']/value]"/>
		<xsl:variable name="thisDepIntProdConcepts" select="$allProdConcepts[name = $thisDepIntProdTypes/own_slot_value[slot_reference = 'product_type_realises_concept']/value]"/>
		<xsl:variable name="thisDependentExtProds" select="$externalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $thisProds/name]"/>
		<xsl:variable name="thisExtOrgIds" select="$thisExtStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
		
		<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'phys_bp_supported_by_products ']/value = $thisProds/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="suppBusCapIds" select="$thisBusCapDescendants/name"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"extOrgIds": [<xsl:for-each select="$thisExtOrgIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"productIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProds"/>],
		"depIntProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDependentIntProds"/>],
		"depIntProductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepIntProdTypes"/>],
		"depIntProductConceptIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepIntProdConcepts"/>],
		"depExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDependentExtProds"/>],
		"depBusCapIds": [<xsl:for-each select="$suppBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of External Orgs  -->
	<xsl:template match="node()" mode="getExtOrgsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisExtStakeholder2Roles" select="$extProductStakeholder2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $this/name]"/>
		<xsl:variable name="thisProds" select="$externalProducts[own_slot_value[slot_reference = 'stakeholders']/value = $thisExtStakeholder2Roles/name]"/>
		<xsl:variable name="thisDependentIntProds" select="$internalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $thisProds/name]"/>
		<xsl:variable name="thisDepIntProdTypes" select="$allProdTypes[name = $thisDependentIntProds/own_slot_value[slot_reference = 'instance_of_product_type']/value]"/>
		<xsl:variable name="thisDependentExtProds" select="$externalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $thisProds/name]"/>
		
		
		<xsl:variable name="thisExtRoleIds" select="$thisExtStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value"/>
		
		<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'phys_bp_supported_by_products ']/value = $thisProds/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="suppBusCapIds" select="$thisBusCapDescendants/name"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"extRoleIds": [<xsl:for-each select="$thisExtRoleIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"productIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProds"/>],
		"depIntProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDependentIntProds"/>],
		"depIntProductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepIntProdTypes"/>],
		"depExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDependentExtProds"/>],
		"depBusCapIds": [<xsl:for-each select="$suppBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Internal Orgs  -->
	<xsl:template match="node()" mode="getIntOrgsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="allActor2Roles" select="$allActor2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $this/name]"/>
		<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'process_performed_by_actor_role ']/value = ($allActor2Roles, $this)/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
			
		<xsl:variable name="thisProds" select="$allProducts[own_slot_value[slot_reference = 'product_implemented_by_process']/value = $suppPhysProcs/name]"/>
			
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="suppBusCapIds" select="$thisBusCapDescendants/name"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
				
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[own_slot_value[slot_reference = 'vs_supporting_bus_processes']/value = $suppBusProcs/name]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"depProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProds"/>],
		"depBusCapIds": [<xsl:for-each select="$suppBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"depObjectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		"depValueStreamIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
		"depValueStageIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Goals  -->
	<xsl:template match="node()" mode="getBusinssGoalsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'objective_supports_objective']/value = $this/name]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"objectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Business Objectives  -->
	<xsl:template match="node()" mode="getBusinssObjectivesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisSupportedBusinessGoals" select="$allBusinessGoals[name = $this/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		<xsl:variable name="thisTargetDate" select="$this/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"targetDate": <xsl:choose><xsl:when test="string-length($thisTargetDate) > 0">"<xsl:value-of select="$thisTargetDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
			"depGoalIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedBusinessGoals"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Roadmaps  -->
	<xsl:template match="node()" mode="getRoadmapsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisStratPlans" select="$allStratPlans[name = $this/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"stratPlanIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisStratPlans"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Strategic Plans  -->
	<xsl:template match="node()" mode="getStrategicPlansJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisStartDate" select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
		<xsl:variable name="thisEndDate" select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		
		<xsl:variable name="thisRoadmaps" select="$allRoadmaps[own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $this/name]"/>
		<xsl:variable name="thisStratPlan2ElementRels" select="$allStratPlan2ElementRels[name = $this/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>
		<xsl:variable name="thisChangedElements" select="$allChangedElements[name = $thisStratPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
		
		<!-- changed bus caps -->
		<xsl:variable name="changedBusProcs" select="$allBusinessProcess[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedBusCaps" select="$allBusCapabilities[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedBusProcCaps" select="$allBusCapabilities[name = $changedBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisDepBusCaps" select="$changedBusCaps union $changedBusProcCaps"/>
		
		<!-- changed app caps -->
		<xsl:variable name="changedApps" select="$allApplications[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedAppAPRs" select="$allAppProviderRoles[name = $changedApps/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
		<xsl:variable name="changedAPRs" select="$allAppProviderRoles[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedAppServices" select="$allAppServices[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedAPRServices" select="$allAppServices[name = ($changedAPRs, $changedAppAPRs)/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
		<xsl:variable name="thisDepAppServices" select="$changedAppServices union $changedAPRServices"/>
		<xsl:variable name="thisDepAppCaps" select="$allAppCaps[name = $thisDepAppServices/own_slot_value[slot_reference = 'realises_application_capabilities']/value]"/>
		
		<!-- changed tech caps -->
		<xsl:variable name="changedTechProds" select="$allTechProds[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedTechProdTPRs" select="$allTechProdRoles[name = $changedTechProds/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
		<xsl:variable name="changedTPRs" select="$allTechProdRoles[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedTechComps" select="$allTechComps[name = $thisChangedElements/name]"/>
		<xsl:variable name="changedTPRServices" select="$allTechComps[name = ($changedTPRs, $changedTechProdTPRs)/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:variable name="thisDepTechComps" select="$changedTechComps union $changedTPRServices"/>
		<xsl:variable name="thisDepTechCaps" select="$allTechCaps[name = $thisDepTechComps/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value]"/>
		
		<xsl:variable name="thisDepObjectives" select="$allObjectives[name = $this/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value]"/>
		<xsl:variable name="thisDepBusinessGoals" select="$allBusinessGoals[name = $thisDepObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		<xsl:variable name="thisDepStratPlans" select="$allStratPlans[name = $this/own_slot_value[slot_reference = 'supports_strategic_plan']/value]"/>
		
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"startDate": <xsl:choose><xsl:when test="string-length($thisStartDate) > 0">"<xsl:value-of select="$thisStartDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"endDate": <xsl:choose><xsl:when test="string-length($thisEndDate) > 0">"<xsl:value-of select="$thisEndDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"plannedChanges": [<xsl:apply-templates mode="getPlannedChangesJSON" select="$thisStratPlan2ElementRels"><xsl:with-param name="changedElements" select="$thisChangedElements"/></xsl:apply-templates>],
		"depGoalIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepBusinessGoals"/>],
		"depObjectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepObjectives"/>],
		"depRoadmapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisRoadmaps"/>],
		"depBusCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepBusCaps"/>],
		"depAppCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepAppCaps"/>],
		"depTechCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepTechCaps"/>],
		"depStratPlanIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepStratPlans"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Strategic Plan Changes  -->
	<xsl:template match="node()" mode="getPlannedChangesJSON">
		<xsl:param name="changedElements"/>
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisChangedElement" select="$changedElements[name = $this/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
		<xsl:variable name="thisPlanningActionId" select="$this/own_slot_value[slot_reference = 'plan_to_element_change_action']/value"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"planningActionId": <xsl:choose><xsl:when test="string-length($thisPlanningActionId) > 0">"<xsl:value-of select="$thisPlanningActionId"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
			"changedElement": {
				"id": "<xsl:value-of select="eas:getSafeJSString($thisChangedElement/name)"/>",
				"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisChangedElement"/></xsl:call-template>",
				"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisChangedElement"/></xsl:call-template>"
			}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	
	<!-- Template for rendering the list of Business Capabilities  -->
	<xsl:template match="node()" mode="getBusinssCapablitiesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		<!-- Processes -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusinessProcess/name]"/>

		<!-- Products -->
		<xsl:variable name="thisProds" select="$allProducts[own_slot_value[slot_reference = 'product_implemented_by_process']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisDepIntProdTypes" select="$allProdTypes[name = $thisProds/own_slot_value[slot_reference = 'instance_of_product_type']/value]"/>
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[own_slot_value[slot_reference = 'vs_supporting_bus_processes']/value = $thisBusinessProcess/name]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>

		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"ref": "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"depGoalIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessGoals"/>],
			"depObjectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			"depValueStreamIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
			"depValueStageIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
			"depIntProductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisDepIntProdTypes"/>],
			"depIntProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProds"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Processes  -->
	<!--<xsl:template match="node()" mode="getBusinssProcessJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-\- Relevant Planning Actions -\->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $this/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-\- goals and objectives -\->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		<!-\- Physical Processes -\->
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $this/name]"/>
		<!-\-<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>-\->
		
		<!-\- Applications -\->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!-\-<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-\->
		
		<!-\- Customer Journeys -\->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="$allCustomerJourneys[own_slot_value[slot_reference = 'cj_phases']/value = $thisCustomerJourneyPhases/name]"/>
		
		
		<!-\- Value Streams -\->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		
		<!-\- overall scores -\->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"index": <xsl:value-of select="position() - 1"/>,
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		<!-\-type: elementTypes.busProcess,-\->
		"busCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessCapabilities"/>],
		"goalIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessGoals"/>],
		"objectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		"physProcessIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysicalProcesses"/>],
		"appProRoleIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
		"applicationIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisApplications"/>],
		"customerJourneyIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneys"/>],
		"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
		"valueStreamIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
		"valueStageIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
		"overallScores": <xsl:choose>
			<xsl:when test="count($thisCustomerJourneyPhases) > 0">
				{
				"cxScore": <xsl:value-of select="$custExperienceScore"/>,
				"xStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
				"cxStyle": "<xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>",
				"emotionScore": <xsl:value-of select="$emotionScore"/>,
				"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
				"emotionStyle": "<xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>",
				"kpiScore": <xsl:value-of select="$kpiScore"/>,
				"kpiPercent": <xsl:value-of select="round($kpiScore * 10)"/>,
				"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
				}
			</xsl:when>
			<xsl:otherwise>
				{
				"cxScore": 0,
				"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
				"cxStyle": null,
				"emotionScore": 0,
				"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
				"emotionStyle": null,
				"kpiScore": -1,
				"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
				}
			</xsl:otherwise>
		</xsl:choose>,
		"heatmapScores": [
		<xsl:apply-templates mode="RenderValueStreamAverageScores" select="$allValueStreams">
			<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
			<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
		</xsl:apply-templates>
		],
		"editorId": "busProcessModal",
		"inScope": false,
		"planningActionIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPlanningActions"/>],
		"planningActions": null,
		"planningAction": null,
		"planningNotes": "",
		"hasPlan": false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->
	
	
	
	<!-- Templates for rendering the Business Reference Model  -->
	<xsl:template name="RenderBCMJSON">

		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($rootBusCap/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
			"link": "<xsl:value-of select="$rootBusCapLink"/>",
			"childBusCaps": [
				<xsl:apply-templates select="$L0Caps" mode="l0_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
			]
		}
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="l0_caps">
		<xsl:variable name="currentBusCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="L1Caps" select="$allBusCapabilities[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
			"link": "<xsl:value-of select="$currentBusCapLink"/>",
			"childBusCaps": [	
				<xsl:apply-templates select="$L1Caps" mode="l1_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="l1_caps">
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="currentBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="isDifferentiator">
			<xsl:choose>
				<xsl:when test="$thisBusCapDescendants/own_slot_value[slot_reference = 'element_classified_by']/value = $differentiator/name">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="objectiveCount" select="count($thisBusinessObjectives)"/>
		<xsl:variable name="stratImpactStyle">
			<xsl:choose>
				<xsl:when test="$objectiveCount = 0">bg-midgrey</xsl:when>
				<xsl:when test="$objectiveCount = 1">bg-aqua-20</xsl:when>
				<xsl:when test="$objectiveCount &lt;= 2">bg-aqua-60</xsl:when>
				<xsl:otherwise>bg-aqua-120</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="stratImpactLabel">
			<xsl:choose>
				<xsl:when test="$objectiveCount = 0">-</xsl:when>
				<xsl:when test="$objectiveCount = 1">Low</xsl:when>
				<xsl:when test="$objectiveCount &lt;= 2">Medium</xsl:when>
				<xsl:otherwise>High</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
			"link": "<xsl:value-of select="$currentBusCapLink"/>",
			"isDifferentiator": <xsl:value-of select="$isDifferentiator"/>,
			"stratImpactStyle": "<xsl:value-of select="$stratImpactStyle"/>",
			"stratImpactLabel": "<xsl:value-of select="$stratImpactLabel"/>"
			<!--<xsl:choose>
				<xsl:when test="current()/name = $$L1Caps/name">inScope: true</xsl:when>
				<xsl:otherwise>inScope: false</xsl:otherwise>
			</xsl:choose>-->
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- Template for rendering the list of Physical Processes  -->
	<!--<xsl:template match="node()" mode="getPhysicalProcessJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-\- Relevant Planning Actions -\->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/supertype]"/>
		
		<!-\- Business Process -\->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $this/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<!-\- Business Capability -\->
		<xsl:variable name="thisBusinessCap" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		
		<!-\- Organisation -\->
		<xsl:variable name="thisDirectOrganisation" select="$allDirectOrganisations[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelation" select="$allOrg2RoleRelations[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisation" select="$allIndirectOrganisations[name = $thisOrg2RoleRelation/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisation" select="$thisDirectOrganisation union $thisIndirectOrganisation"/>
		
		<!-\- Supporting Applications -\->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $this/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		
		<!-\- Customer Journeys -\->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $this/name]"/>

		<!-\- measures -\->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		<xsl:variable name="busProcName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBusinessProcess"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="busProcDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisBusinessProcess"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="orgName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisOrganisation"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="orgDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisOrganisation"/></xsl:call-template>
		</xsl:variable>
		

		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			<!-\-type: elementTypes.physProcess,-\->
			"busCapId": "<xsl:value-of select="eas:getSafeJSString($thisBusinessCap[1]/name)"/>",
			"busCapLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisBusinessCap[1]"/></xsl:call-template>",
			"busProcessId": "<xsl:value-of select="eas:getSafeJSString($thisBusinessProcess/name)"/>",
			"busProcessRef": "<xsl:if test="count($thisBusinessProcess) > 0">busProc<xsl:value-of select="index-of($allBusinessProcess, $thisBusinessProcess)"/></xsl:if>",
			"busProcessName": "<xsl:value-of select="eas:validJSONString($busProcName)"/>",
			"busProcessDescription": "<xsl:value-of select="eas:validJSONString($busProcDesc)"/>",
			"busProcessLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisBusinessProcess"/></xsl:call-template>",
			"orgId": "<xsl:value-of select="eas:getSafeJSString($thisOrganisation/name)"/>",
			"orgRef": "<xsl:if test="count($thisOrganisation) > 0">org<xsl:value-of select="index-of($allOrganisations, $thisOrganisation)"/></xsl:if>",
			"orgName": "<xsl:value-of select="eas:validJSONString($orgName)"/>",
			"orgDescription": "<xsl:value-of select="eas:validJSONString($orgDesc)"/>",
			"orgLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisOrganisation"/></xsl:call-template>",
			"appProRoleIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			"applicationIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisApplications"/>],
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"customerJourneyPhases": [],
			"planningActionIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPlanningActions"/>],
			"planningActions": [],
			"planningAction": null,
			"editorId": "physProcModal",
			"emotionScore": <xsl:value-of select="$emotionScore"/>,
			"cxScore": <xsl:value-of select="$custExperienceScore"/>,
			"kpiScore": <xsl:value-of select="$kpiScore"/>, 
			"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>"<!-\-, 
			"emotionIcon": "<xsl:value-of select="eas:getEmotionScoreIcon($emotionScore)"/>",
			"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>", 
			"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"-\->
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->
	
	
	
	
	<!-- Template for rendering the list of App Services  -->
	<xsl:template match="node()" mode="getAppServiceJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Application Provider Roles -->
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $this/name]"/>
		<xsl:variable name="thisApps" select="$allApplications[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		
		<!-- PhysProcs -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_appprorole', 'apppro_to_physbus_from_apppro')]/value = ($thisAppProRoles, $thisApps)/name]"/>
		<xsl:variable name="thisPhysProcs" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		
		<!-- Organisations -->
		<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
				
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>

		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[own_slot_value[slot_reference = 'vs_supporting_bus_processes']/value = $thisBusinessProcess/name]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		index: <xsl:value-of select="position() - 1"/>,
		type: elementTypes.appService,
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		depObjectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		depBusCapIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusCapDescendants"/>],
		depValueStreamIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
		depValueStageIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
		depOrgIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisOrganisations"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	

	
	<!-- Template for rendering the list of Applications  -->
	<!--<xsl:template match="node()" mode="getApplicationJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-\- technical health -\->
		<xsl:variable name="thisTechHealthScore" select="eas:getAppTechHealthScore($this)"/>
		<xsl:variable name="thisTechHealthStyle" select="eas:getAppTechHealthStyle($thisTechHealthScore)"/>
		
		<!-\- Relevant Planning Actions -\->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/supertype]"/>
		
		<!-\- Application Provider Roles -\->
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = $this/name]"/>
		
		<!-\- Supported Physical Processes -\->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($this, $thisAppProRoles)/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		
		<!-\- objectives -\->
		<xsl:variable name="thisBusinessProcesses" select="$allBusinessProcess[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusCaps" select="$allBusCapabilities[name = $thisBusinessProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusCaps, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-\- Organisations -\->
		<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>

		<!-\- Value Streams -\->
		<xsl:variable name="thisValueStages" select="$allValueStages[own_slot_value[slot_reference = 'vs_supporting_bus_processes']/value = $thisBusinessProcesses/name]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			type: elementTypes.application,
			index: <xsl:value-of select="position() - 1"/>,
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			techHealthScore: 8,
			objectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			objectives: null,
			appProRoleIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisAppProRoles"/>],
			appProRoles: null,
			physProcessIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysicalProcesses"/>],
			physProcesses: null,
			organisationIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisOrganisations"/>],
			organisations: null,
			customerJourneyPhaseIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			customerJourneyPhases: [],
			valueStreamIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
			valueStreams: null,
			valueStageIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
			editorId: "appModal",
			planningActionIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPlanningActions"/>],
			planningActions: null,
			planningAction: null,
			planningNotes: "",
			hasPlan: false,
			techHealthScore: <xsl:value-of select="$thisTechHealthScore"/>,
			techHealthStyle: "<xsl:value-of select="$thisTechHealthStyle"/>",
			cxScore: 0,
			kpiScore: 0
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->
	
	
	<!-- Template for rendering the list of Value Streams  -->
	<xsl:template match="node()" mode="getValueStreamJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Value Stages -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $this/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>

		<!-- Products -->
		<xsl:variable name="thisProdTypes" select="$allProdTypes[name = $this/own_slot_value[slot_reference = 'vs_product_types']/value]"/>
		<xsl:variable name="thisProdIds" select="$thisProdTypes/own_slot_value[slot_reference = 'product_type_instances']/value"/>

		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"valueStageIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"><xsl:sort select="own_slot_value[slot_reference = 'vsg_index']/value"/></xsl:apply-templates>],
			"depIntProductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProdTypes"/>],
			"depIntProductIds": [<xsl:for-each select="$thisProdIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Value Stages  -->
	<xsl:template match="node()" mode="getValueStageJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="parentValStreamId" select="$allValueStreams[name = $this/own_slot_value[slot_reference = 'vsg_value_stream']/value]"/>
		<xsl:variable name="parentValStageId" select="$allValueStages[name = $this/own_slot_value[slot_reference = 'vsg_value_stream']/value]"/>
		<xsl:variable name="vsgLabel"><xsl:call-template name="RenderMultiLangCommentarySlot"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="slotName">vsg_label</xsl:with-param></xsl:call-template></xsl:variable>


		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="displayString" select="$vsgLabel"/><xsl:with-param name="anchorClass">text-white</xsl:with-param></xsl:call-template>",
			"parentValStreamId": "",
			"parentValStageId": ""
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>


	
	
	<!-- END READ ONLY JSON DATA TEMPLATES -->
	
	
	<!-- APPLICATION REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template name="RenderARMJSON">
		{
			"left": [
				<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderAppCaps"/>
			],
			"middle": [
				<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderAppCaps"/>
			],
			"right": [
				<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderAppCaps"/>
			]		
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderAppCaps" match="node()">
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
			"childAppCaps": [
				<xsl:apply-templates select="$childAppCaps" mode="RenderBasicInstanceJSON"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderAppCapDetailsJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<!-- Application Provider Roles -->
		<xsl:variable name="thisAppServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $thisAppServices/name]"/>
		<xsl:variable name="thisApps" select="$allApplications[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
				
		<!-- PhysProcs -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_appprorole', 'apppro_to_physbus_from_apppro')]/value = ($thisAppProRoles, $thisApps)/name]"/>
		<xsl:variable name="thisPhysProcs" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		
		<!-- Organisations -->
		<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[own_slot_value[slot_reference = 'vs_supporting_bus_processes']/value = $thisBusinessProcess/name]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisSupportedBusCaps" select="$allBusCapabilities[own_slot_value[slot_reference = 'bus_cap_supporting_app_caps']/value = current()/name]"/>
		<xsl:variable name="allSupportedBusCaps" select="$thisSupportedBusCaps union $thisBusinessCapabilities"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($allSupportedBusCaps, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"depBusCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusCapDescendants"/>],
		"depObjectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		"depValueStreamIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
		"depValueStageIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
		"depIntOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisOrganisations"/>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderTechCapDetailsJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<!--<xsl:variable name="thisDesc" select="normalize-space(current()/own_slot_value[slot_reference = 'description']/value)"/>-->
		
		
		<xsl:variable name="thisTechComps" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		<xsl:variable name="thisTPRs" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisTechComps/name]"/>
		<xsl:variable name="allTPRUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'provider_as_role']/value = $allTechProdRoles/name]"/>
		<xsl:variable name="allTechArchs" select="/node()/simple_instance[name = $allTPRUsages/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>
		<xsl:variable name="allTechProdBuilds" select="/node()/simple_instance[own_slot_value[slot_reference = 'technology_provider_architecture']/value = $allTechArchs/name]"/>
		<xsl:variable name="allAppDeployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $allTechProdBuilds/name]"/>
		<xsl:variable name="thisApps" select="$allApplications[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $allAppDeployments/name]"/>
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = $thisApps/name]"/>
		<xsl:variable name="thisAppServices" select="$allAppServices[own_slot_value[slot_reference = 'implementing_application_service']/value = $thisAppProRoles/name]"/>
		<xsl:variable name="thisTechSupportedAppCaps" select="$allAppCaps[name = $thisAppServices/own_slot_value[slot_reference = 'realises_application_capabilities']/value]"/>
		
		<!-- PhysProcs -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_appprorole', 'apppro_to_physbus_from_apppro')]/value = ($thisAppProRoles, $thisApps)/name]"/>
		<xsl:variable name="thisPhysProcs" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		
		<!-- Organisations -->
		<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[own_slot_value[slot_reference = 'vs_supporting_bus_processes']/value = $thisBusinessProcess/name]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
	
		<xsl:variable name="thisDirecSupportedAppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'app_cap_supporting_tech_caps']/value = current()/name]"/>
		<xsl:variable name="thisSupportedAppCaps" select="$thisDirecSupportedAppCaps union $thisTechSupportedAppCaps"/>
		<xsl:variable name="thisDirecSupportedBusCaps" select="$allBusCapabilities[own_slot_value[slot_reference = 'bus_cap_supporting_app_caps']/value = $thisSupportedAppCaps/name]"/>
		<xsl:variable name="thisSupportedBusCaps" select="$thisDirecSupportedBusCaps union $thisBusinessCapabilities"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisSupportedBusCaps, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"depAppCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedAppCaps"/>],
		"depBusCapIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedBusCaps"/>],
		"depObjectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		"depValueStreamIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
		"depValueStageIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
		"depIntOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisOrganisations"/>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!--<xsl:template match="node()" mode="RenderBasicInstanceJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>-->
	
	
	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template name="RenderTRMJSON">
		{
		"top": [
		<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name]" mode="RenderTechDomains"/>
		],
		"left": [
		<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderTechDomains"/>
		],
		"middle": [
		<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderTechDomains"/>
		],
		"right": [
		<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderTechDomains"/>
		],
		"bottom": [
		<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name]" mode="RenderTechDomains"/>
		]
		}
	</xsl:template>
	
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="techDomainName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($techDomainName)"/>",
			"description": "<xsl:value-of select="normalize-unicode($techDomainDescription)"/>",
			"link": "<xsl:value-of select="$techDomainLink"/>",
			"childTechCaps": [
				<xsl:apply-templates select="$childTechCaps" mode="RenderBasicInstanceJSON"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderBasicInstanceJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderBasicEnumJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"label": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="xs:string" mode="RenderIdStringListJSON">
		"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- END UTILITY TEMPLATES AND FUNCTIONS -->

</xsl:stylesheet>
