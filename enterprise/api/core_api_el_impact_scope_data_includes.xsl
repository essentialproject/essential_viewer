<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>

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
	<!-- 07.05.2020 JP  Created	 -->

	
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
	<xsl:variable name="allExternalRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'role_is_external']/value = 'true')]"/>
	<xsl:variable name="allOrgs" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="externalOrgs" select="$allOrgs[own_slot_value[slot_reference = 'external_to_enterprise']/value = 'true']"/>	
	<xsl:variable name="internalOrgs" select="$allOrgs except $externalOrgs"/>
	<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root_Organisation')]"/>
	<xsl:variable name="rootOrg" select="$internalOrgs[name = $rootOrgConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	
	<!-- Channels, Brands, Product Concepts, Product Types and Products -->
	<xsl:variable name="allChannelTypes" select="/node()/simple_instance[type = 'Channel_Type']"/>
	<xsl:variable name="allChannels" select="/node()/simple_instance[type = 'Channel']"/>
	<xsl:variable name="allBrands" select="/node()/simple_instance[type = 'Brand']"/>
	<xsl:variable name="allProdConcepts" select="/node()/simple_instance[type = 'Product_Concept']"/>
	<xsl:variable name="allProdTypes" select="/node()/simple_instance[type = ('Product_Type', 'Composite_Product_Type')]"/>
	<xsl:variable name="allProducts" select="/node()/simple_instance[type = ('Product', 'Composite_Product')]"/>
	<xsl:variable name="externalProducts" select="$allProducts[own_slot_value[slot_reference = 'product_is_external']/value = 'true']"/>	
	<xsl:variable name="internalProducts" select="$allProducts except $externalProducts"/>
	
	<!--<xsl:variable name="extProdTypeStakeholder2Roles" select="/node()/simple_instance[(name = $allProdTypes/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $allExternalRoles/name)]"/>
	<xsl:variable name="extProdTypeStakeholders" select="$externalOrgs[name = $extProdTypeStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>	
	<xsl:variable name="externalProductTypes" select="$allProdTypes[own_slot_value[slot_reference = 'stakeholders']/value = $extProdTypeStakeholder2Roles/name]"/>
	<xsl:variable name="internalProductTypes" select="$allProdTypes except $externalProductTypes"/>-->
	<xsl:variable name="internalProductTypes" select="$allProdTypes[own_slot_value[slot_reference = 'product_type_external_facing']/value = 'Yes']"/>
	<xsl:variable name="externalProductTypes" select="$allProdTypes except $internalProductTypes"/>
	
	<xsl:variable name="extProductStakeholder2Roles" select="/node()/simple_instance[(name = $allProducts/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $allExternalRoles/name)]"/>
	<xsl:variable name="extProductStakeholders" select="$externalOrgs[name = $extProductStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	
	<!-- Business Outcome Service Qualities, Cost Types and Revenue Types -->
	<xsl:variable name="allBusOutcomeSQs" select="/node()/simple_instance[(type = 'Business_Service_Quality') and (own_slot_value[slot_reference = 'sq_for_classes']/value = 'Business_Capability')]"/>
	<xsl:variable name="allCostTypes" select="/node()/simple_instance[type = 'Cost_Component_Type']"/>
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
	<xsl:variable name="allInfoDomains" select="/node()/simple_instance[type = 'Information_Domain']"/>
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
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'application_provider_deployed']/value = $allApplications/name]"/>

	<!-- Sites, Locations and Geo Regions -->
	<xsl:variable name="allAppInstancess" select="/node()/simple_instance[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_technology_instance']/value]"/>
	<xsl:variable name="allTechNodes" select="/node()/simple_instance[name = $allAppInstancess/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value]"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[name = ($allTechNodes, $allOrgs, $allPhysicalProcesses)/own_slot_value[slot_reference = ('technology_deployment_located_at', 'actor_based_at_site', 'process_performed_at_sites')]/value]"/>
	<xsl:variable name="allLocations" select="/node()/simple_instance[(type = 'Geographic_Location') and (name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
	<xsl:variable name="allGeoCodes" select="/node()/simple_instance[name = $allLocations/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
	<xsl:variable name="theGeoRegions" select="/node()/simple_instance[type = 'Geographic_Region']"/>
	<xsl:variable name="countryTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Country')]"/>
	<xsl:variable name="allCountries" select="$theGeoRegions[own_slot_value[slot_reference = 'element_classified_by']/value = $countryTaxTerm/name]"/>
	<xsl:variable name="allCountryParentRegions" select="$theGeoRegions[own_slot_value[slot_reference = 'gr_contained_regions']/value = $allCountries/name]"/>
	<xsl:variable name="allSiteGeoRegions" select="$theGeoRegions[name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allLocationGeoRegions" select="$theGeoRegions[own_slot_value[slot_reference = 'gr_locations']/value = $allLocations/name]"/>
	<xsl:variable name="allGeoRegions" select="$allSiteGeoRegions union $allLocationGeoRegions"/>
	<xsl:variable name="allParentGeoRegions" select="$theGeoRegions[own_slot_value[slot_reference = 'gr_contained_regions']/value = $allGeoRegions/name]"/>

	
	<!-- Value Streams -->
	<xsl:variable name="allValueStages" select="/node()/simple_instance[type = 'Value_Stage']"/>
	<xsl:variable name="allValueStreams" select="/node()/simple_instance[own_slot_value[slot_reference = 'vs_value_stages']/value = $allValueStages/name]"/>
	
	<!-- Strategies -->
	<xsl:variable name="allRoadmaps" select="/node()/simple_instance[type = 'Roadmap']"/>
	<xsl:variable name="allStratPlans" select="/node()/simple_instance[name = $allRoadmaps/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value]"/>
	<xsl:variable name="allStratPlan2ElementRels" select="/node()/simple_instance[name = $allStratPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>
	<xsl:variable name="allChangedElements" select="($allBusCapabilities, $allBusinessProcess, $internalOrgs, $allAppCaps, $allAppServices, $allAppProviderRoles, $allApplications, $allTechCaps, $allTechComps, $allTechProdRoles, $allTechProds)[name = $allStratPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[type = 'Planning_Action']"/>
	
	<xsl:key name="geoRegion_key" match="$allGeoRegions" use="own_slot_value[slot_reference = 'gr_contained_regions']/value"/>
	<xsl:key name="site_key" match="/node()/simple_instance[type='Site']" use="own_slot_value[slot_reference = 'site_geographic_location']/value"/>
	<xsl:key name="bef_key" match="/node()/simple_instance[type='Business_Environment_Factor']" use="own_slot_value[slot_reference = 'bef_category']/value"/>
	
	<!-- Template for rendering the list of Countries  -->
	<xsl:template match="node()" mode="getCountriesJSON">
		<xsl:variable name="this" select="current()"/>
		
	<!--	<xsl:variable name="thisParentRegions" select="$theGeoRegions[own_slot_value[slot_reference = 'gr_contained_regions']/value = $this/name]"/> -->
		<xsl:variable name="thisParentRegions" select="key('geoRegion_key',$this/name)"/>  
		<xsl:variable name="thisLocations" select="$allLocations[name = $this/own_slot_value[slot_reference = 'gr_locations']/value]"/>
	<!--	<xsl:variable name="thisSites" select="$allSites[own_slot_value[slot_reference = 'site_geographic_location']/value = ($this, $thisLocations)/name]"/> -->
		<xsl:variable name="thisSites" select="key('site_key',($this, $thisLocations)/name)"/>  
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"countryCode": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'gr_region_identifier']/value"/>",
		"locationIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisLocations"/>],
		"siteIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSites"/>],
		"parentRegionIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisParentRegions"/>],
		"locations": [],
		"sites": [],
		"parentRegions": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>


	<!-- Template for rendering the list of Parent Geographic Regions  -->
	<xsl:template match="node()" mode="getParentGeoRegionsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisGeoRegions" select="$allGeoRegions[name = $this/own_slot_value[slot_reference = 'gr_contained_regions']/value]"/>
		<xsl:variable name="thisLocations" select="$allLocations[name = $thisGeoRegions/own_slot_value[slot_reference = 'gr_locations']/value]"/>
<!--		<xsl:variable name="thisSites" select="$allSites[own_slot_value[slot_reference = 'site_geographic_location']/value = ($thisGeoRegions, $thisLocations)/name]"/>		-->
		<xsl:variable name="thisSites" select="key('site_key',($this, $thisLocations)/name)"/>  
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"subRegionIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisGeoRegions"/>],
		"locationIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisLocations"/>],
		"siteIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSites"/>],
		"subRegions": [],
		"locations": [],
		"sites": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of lowest level Geographic Regions  -->
	<xsl:template match="node()" mode="getGeoRegionsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLocations" select="$allLocations[name = $this/own_slot_value[slot_reference = 'gr_locations']/value]"/>
		<!--		<xsl:variable name="thisSites" select="$allSites[own_slot_value[slot_reference = 'site_geographic_location']/value = ($thisGeoRegions, $thisLocations)/name]"/>		-->
		<xsl:variable name="thisSites" select="key('site_key',($this, $thisLocations)/name)"/>  
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"countryCode": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'gr_region_identifier']/value"/>",
		"locationIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisLocations"/>],
		"siteIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSites"/>],
		"locations": [],
		"sites": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Locations  -->
	<xsl:template match="node()" mode="getLocationsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!--		<xsl:variable name="thisSites" select="$allSites[own_slot_value[slot_reference = 'site_geographic_location']/value = $this/name]"/>		-->
		<xsl:variable name="thisSites" select="key('site_key',$this/name)"/>  
		<xsl:variable name="thisGeoCode" select="$allGeoCodes[name = $this/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		<xsl:if test="count($thisGeoCode) > 0">
			<xsl:variable name="lat" select="$thisGeoCode/own_slot_value[slot_reference='geocode_latitude']/value"/>
			<xsl:variable name="long" select="$thisGeoCode/own_slot_value[slot_reference='geocode_longitude']/value"/>
			"latLong": [<xsl:value-of select="$lat"/>, <xsl:value-of select="$long"/>],
		</xsl:if>
		"siteIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSites"/>],
		"sites": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Sites  -->
	<xsl:template match="node()" mode="getSitesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLocation" select="$allLocations[name = $this/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisGeoCode" select="$allGeoCodes[name = $this/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
		<xsl:if test="count($thisGeoCode) > 0">
			<xsl:variable name="lat" select="$thisGeoCode/own_slot_value[slot_reference='geocode_latitude']/value"/>
			<xsl:variable name="long" select="$thisGeoCode/own_slot_value[slot_reference='geocode_longitude']/value"/>
			", latLong": [<xsl:value-of select="$lat"/>, <xsl:value-of select="$long"/>]
		</xsl:if>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>

	
	<!-- Template for rendering the list of Business Environment Categories  -->
	<xsl:template match="node()" mode="getBusinssEnvCategoriesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusEnvFactors" select="key('bef_key',$this/name)"/>  
	<!--	<xsl:variable name="thisBusEnvFactors" select="$allBusEnvFactors[own_slot_value[slot_reference = 'bef_category']/value = $this/name]"/>-->
		<xsl:variable name="thisBusEnvCatIcon" select="eas:get_element_style_icon($this)"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"icon": "<xsl:value-of select="$thisBusEnvCatIcon"/>", 
		"busEnvFactorIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusEnvFactors"/>],
		"busEnvFactors": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Environment Categories  -->
	<xsl:template match="node()" mode="getBusinssEnvFactorsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusEnvCatId" select="own_slot_value[slot_reference = 'bef_category']/value"/>
		
		
		<!--<xsl:variable name="thisCorrelations" select="$allBusEnvCorrelations[name = $this/own_slot_value[slot_reference = 'bus_env_factor_correlations']/value]"/>
		<xsl:variable name="thisDepELementIds" select="$thisCorrelations/own_slot_value[slot_reference = 'dependency_to_element']/value"/>-->
			

		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'bef_label']/value"/>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"busEnvCategoryId": <xsl:choose><xsl:when test="string-length($thisBusEnvCatId) > 0">"<xsl:value-of select="eas:getSafeJSString($thisBusEnvCatId)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		<!--"dependencyIds": [<xsl:for-each select="$thisDepELementIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]-->
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Product Concepts  -->
	<xsl:template match="node()" mode="getProductConceptsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisProdTypeIds" select="$this/own_slot_value[slot_reference = 'product_concept_realised_by_type']/value"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"prodTypeIds": [<xsl:for-each select="$thisProdTypeIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"prodTypes": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderProductTypeJSON">
		<xsl:param name="customerFacing" select="true()"/>
		
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="isCustomerFacing">
			<xsl:choose>
				<xsl:when test="$customerFacing">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"customerFacing": <xsl:value-of select="$isCustomerFacing"/>,
		"meta": {
			"anchorClass": "<xsl:value-of select="$this/type"/>"
		}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- Template for rendering the list of Internal Product Types  -->
	<!--<xsl:template match="node()" mode="getInternalProductTypesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisProdIds" select="$this/own_slot_value[slot_reference = 'product_type_instances']/value"/>
		<xsl:variable name="thisExtProdTypes" select="$externalProductTypes[name = $this/own_slot_value[slot_reference = 'contained_product_types']/value]"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"externalPoductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtProdTypes"/>],
		"productIds": [<xsl:for-each select="$thisProdIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"externalPoductTypes": [],
		"products": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->
	
	<!-- Template for rendering the list of External Product Types  -->
	<!--<xsl:template match="node()" mode="getExternalProductTypesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisProdIds" select="$this/own_slot_value[slot_reference = 'product_type_instances']/value"/>
		<xsl:variable name="thisExtProdTypes" select="$externalProductTypes[name = $this/own_slot_value[slot_reference = 'contained_product_types']/value]"/>
		
		<xsl:variable name="thisProdTypeStakeholder2Roles" select="$extProdTypeStakeholder2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thisProdTypeStakeholders" select="$extProdTypeStakeholders[name = $thisProdTypeStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"externalPoductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtProdTypes"/>],
		"externalOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProdTypeStakeholders"/>],
		"productIds": [<xsl:for-each select="$thisProdIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"externalPoductTypes": [],
		"externalOrgs": [],
		"products": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->
	
	
	<!--<!-\- Template for rendering the list of Products  -\->
	<xsl:template match="node()" mode="getInternalProductsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisExtProducts" select="$externalProducts[name = $this/own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value]"/>
		<xsl:variable name="thisProductStakeholder2Roles" select="$extProductStakeholder2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thisExtStakeholders" select="$extProductStakeholders[name = $thisProductStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="isExternal" select="$this/own_slot_value[slot_reference = 'product_is_external']/value = 'true'"/>
		
		<!-\-<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'phys_bp_supported_by_products ']/value = $this/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="suppBusCapIds" select="$thisBusCapDescendants/name"/>-\->

		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"suppExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtProducts"/>],
		"suppExtOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtStakeholders"/>],
		<!-\-"suppBusCapIds": [<xsl:for-each select="$suppBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],-\->
		"isExternal": <xsl:choose><xsl:when test="$isExternal">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-\- Template for rendering the list of Products  -\->
	<xsl:template match="node()" mode="getExternalProductsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-\- supporting external producets and orgs -\->
		<xsl:variable name="thisExtProducts" select="$externalProducts[name = $this/own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value]"/>
		<xsl:variable name="thisProductStakeholder2Roles" select="$extProductStakeholder2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thisExtStakeholders" select="$extProductStakeholders[name = $thisProductStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="isExternal" select="$this/own_slot_value[slot_reference = 'product_is_external']/value = 'true'"/>
		
		<!-\- dependent internal products -\->
		<xsl:variable name="depIntProducts" select="$internalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $this/name]"/>
		<xsl:variable name="depIntProdTypes" select="$allProdTypes[name = $depIntProducts/own_slot_value[slot_reference = 'instance_of_product_type']/value]"/>
			
		<!-\- dependent external products -\->
		<xsl:variable name="depExtProducts" select="$externalProducts[own_slot_value[slot_reference = ('product_supporting_products', 'product_contained_products')]/value = $this/name]"/>
		
		
		<!-\- dependent bus caps -\->
		<xsl:variable name="suppPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'phys_bp_supported_by_products ']/value = $this/name]"/>
		<xsl:variable name="suppBusProcs" select="$allBusinessProcess[name = $suppPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $suppBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="depBusCapIds" select="$thisBusCapDescendants/name"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"suppExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtProducts"/>],
		"suppExtOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisExtStakeholders"/>],
		"depIntProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$depIntProducts"/>],
		"depExtProductIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$depExtProducts"/>],
		"depIntProductTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$depIntProdTypes"/>],
		"depBusCapIds": [<xsl:for-each select="$depBusCapIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"isExternal": <xsl:choose><xsl:when test="$isExternal">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->
	
	
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
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
		
		<!--<xsl:variable name="thisExtStakeholder2Roles" select="$allActor2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $this/name]"/>
		<xsl:variable name="thisExtRoleIds" select="$thisExtStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value"/>-->
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
		<!--"extRoleIds": [<xsl:for-each select="$thisExtRoleIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]-->
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Internal Orgs  -->
	<xsl:template match="node()" mode="getIntOrgsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisParentOrgId" select="$this/own_slot_value[slot_reference = 'is_member_of_actor']/value"/>
		<xsl:variable name="thisChildOrgs" select="$allOrgs[name = $this/own_slot_value[slot_reference = 'contained_sub_actors']/value]"/>
		
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		<xsl:if test="count($thisParentOrgId) > 0">
			"parentOrgId": "<xsl:value-of select="eas:getSafeJSString($thisParentOrgId[1])"/>",
		</xsl:if>
		"childOrgIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisChildOrgs"/>],
		"isRoot": <xsl:choose><xsl:when test="$this/name = $rootOrg/name">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
		"childOrgs": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Goals  -->
	<xsl:template match="node()" mode="getBusinssGoalsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'objective_supports_objective']/value = $this/name]"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"objectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			"objectives": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Business Objectives  -->
	<xsl:template match="node()" mode="getBusinssObjectivesJSON">
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="thisTargetDate" select="$this/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"targetDate": <xsl:choose><xsl:when test="string-length($thisTargetDate) > 0">"<xsl:value-of select="$thisTargetDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Roadmaps  -->
	<xsl:template match="node()" mode="getRoadmapsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisStratPlans" select="$allStratPlans[name = $this/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value]"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"stratPlanIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisStratPlans"/>],
		"stratPlans": []
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
				
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"startDate": <xsl:choose><xsl:when test="string-length($thisStartDate) > 0">"<xsl:value-of select="$thisStartDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"endDate": <xsl:choose><xsl:when test="string-length($thisEndDate) > 0">"<xsl:value-of select="$thisEndDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"plannedChanges": [<xsl:apply-templates mode="getPlannedChangesJSON" select="$thisStratPlan2ElementRels"><xsl:with-param name="changedElements" select="$thisChangedElements"/></xsl:apply-templates>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Strategic Plan Changes  -->
	<xsl:template match="node()" mode="getPlannedChangesJSON">
		<xsl:param name="changedElements"/>
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisChangedElement" select="$changedElements[name = $this/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
		<xsl:variable name="thisPlanningActionId" select="$this/own_slot_value[slot_reference = 'plan_to_element_change_action']/value"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"planningActionId": <xsl:choose><xsl:when test="string-length($thisPlanningActionId) > 0">"<xsl:value-of select="$thisPlanningActionId"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
			"changedElement": {
				"id": "<xsl:value-of select="eas:getSafeJSString($thisChangedElement/name)"/>",
				"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisChangedElement"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisChangedElement"/></xsl:call-template>",
				"meta": {
					"anchorClass": "<xsl:value-of select="$thisChangedElement/type"/>"
				}
			}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	
	<!-- Template for rendering the list of Business Capabilities  -->
	<xsl:template match="node()" mode="getBusinssCapablitiesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($this, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="thisBusProcessIds" select="$thisBusCapDescendants/own_slot_value[slot_reference = 'realised_by_business_processes']/value"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"ref": "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"busProcessIds": [<xsl:for-each select="$thisBusProcessIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"busProcesses": []
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getBusinssProcessJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"
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
		"id": "<xsl:value-of select="$this/name"/>",
		"index": <xsl:value-of select="position() - 1"/>,
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
		
		<xsl:variable name="this" select="$rootBusCap"/>

		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"childBusCaps": [
				<xsl:apply-templates select="$L0Caps" mode="l0_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
			],
			"meta": {
				"anchorClass": "Business_Capability"
			}
		}
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="l0_caps">

		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="L1Caps" select="$allBusCapabilities[name = $this/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		
		
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"childBusCaps": [	
			<xsl:apply-templates select="$L1Caps" mode="l1_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
		],
		"meta": {
			"anchorClass": "Business_Capability"
		}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="l1_caps">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($this, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		<xsl:variable name="isDifferentiator">
			<xsl:choose>
				<xsl:when test="$thisBusCapDescendants/own_slot_value[slot_reference = 'element_classified_by']/value = $differentiator/name">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"isDifferentiator": <xsl:value-of select="$isDifferentiator"/>,
			"meta": {
				"anchorClass": "Business_Capability"
			}
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
			"id": "<xsl:value-of select="$this/name"/>",
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
	
	
	<!-- Template for rendering the list of Information Domains  -->
	<xsl:template match="node()" mode="getInfoDomainJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Application Services -->
		<xsl:variable name="thisInfoConcepts" select="$allInfoConcepts[own_slot_value[slot_reference = 'info_concept_info_domain']/value = $this/name]"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>

		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"infoConceptIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisInfoConcepts"/>],
		"infoConcepts": [],
		"meta": {
			"anchorClass": "Information_Domain"
		}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Information Ccncepts  -->
	<xsl:template match="node()" mode="getInfoConceptJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Application Services -->
		<xsl:variable name="thisInfoViews" select="$allInfoViews[own_slot_value[slot_reference = 'refinement_of_information_concept']/value = $this/name]"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"infoViewIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisInfoViews"/>],
		"infoViews": [],
		"meta": {
			"anchorClass": "Information_Concept"
		}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Information Views  -->
	<xsl:template match="node()" mode="getInfoViewJSON">
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"meta": {
			"anchorClass": "Information_View"
		}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of App Capabilities  -->
	<xsl:template match="node()" mode="getAppCapabilityJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Application Services -->
		<xsl:variable name="thisAppCapDescendants" select="eas:get_object_descendants($this, $allAppCaps, 0, 4, 'contained_in_application_capability')"/>
		<xsl:variable name="thisAppServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $thisAppCapDescendants/name]"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"index": <xsl:value-of select="position() - 1"/>,
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",		
		<!--type: elementTypes.appService,-->
		"appServiceIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisAppServices"/>],
		"appServices": [],
		"meta": {
			"anchorClass": "Application_Capability"
		}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of App Services  -->
	<xsl:template match="node()" mode="getAppServiceJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Application Provider Roles -->
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $this/name]"/>
		<xsl:variable name="thisApps" select="$allApplications[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"index": <xsl:value-of select="position() - 1"/>,
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",		
		<!--type: elementTypes.appService,-->
		"appIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisApps"/>],
		"apps": [],
		"meta": {
			"anchorClass": "Application_Service"
		}
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Applications  -->
	<xsl:template match="node()" mode="getApplicationJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"index": <xsl:value-of select="position() - 1"/>,
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"meta": {
			"anchorClass": "Composite_Application_Provider"
		}
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
			id: "<xsl:value-of select="$this/name"/>",
			type: elementTypes.application,
			index: <xsl:value-of select="position() - 1"/>,
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="displayString" select="$vsgLabel"/><xsl:with-param name="anchorClass">text-white</xsl:with-param></xsl:call-template>",
			"parentValStreamId": "",
			"parentValStageId": ""
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>

	
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
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = $this/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"childAppCaps": [
				<xsl:apply-templates select="$childAppCaps" mode="RenderBasicInstanceJSON"/>		
			],
			"meta": {
				"anchorClass": "<xsl:value-of select="$this/type"/>"
			}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getTechCapabilityJSON">
		<xsl:variable name="this" select="current()"/>

		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		
		<xsl:variable name="thisTechCompIds" select="$this/own_slot_value[slot_reference = 'realised_by_technology_components']/value"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"techCompIds": [<xsl:for-each select="$thisTechCompIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"meta": {
			"anchorClass": "Technology_Capability"
		}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getTechComponentJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		

		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"meta": {
			"anchorClass": "Technology_Component"
		}
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
		"id": "<xsl:value-of select="$this/name"/>",
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
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="techDomainName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = $this/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:value-of select="$techDomainName"/>",
			"description": "<xsl:value-of select="$techDomainDescription"/>",
			"link": "<xsl:value-of select="$techDomainLink"/>",
			"childTechCaps": [
				<xsl:apply-templates select="$childTechCaps" mode="RenderBasicInstanceJSON"/>		
			],
			"meta": {
			"anchorClass": "Technology_Domain"
			}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderBasicInstanceJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"meta": {
				"anchorClass": "<xsl:value-of select="$this/type"/>"
			}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderBasicEnumJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!--<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>-->
		
		
		<xsl:variable name="thisName" select="$this/own_slot_value[slot_reference = 'enumeration_value']/value"/>
		
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"meta": {
			"anchorClass": "<xsl:value-of select="$this/type"/>"
		}
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="xs:string" mode="RenderIdStringListJSON">
		"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- END UTILITY TEMPLATES AND FUNCTIONS -->

</xsl:stylesheet>
