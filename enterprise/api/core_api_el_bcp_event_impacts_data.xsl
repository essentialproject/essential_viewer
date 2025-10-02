<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:import href="../../common/core_utilities.xsl"/>
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <!--
		* Copyright © 2008-2024 Enterprise Architecture Solutions Limited.
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
    <!-- 18.04.2024 HWG  Created -->
    <xsl:variable name="allBusCapabilities" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Root Business Capability')]"/>
	<xsl:variable name="rootBusCap" select="$allBusCapabilities[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0Caps" select="$allBusCapabilities[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="diffLevelTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Business Differentiation Level')]"/>
	<xsl:variable name="differentiator" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $diffLevelTaxonomy/name) and (own_slot_value[slot_reference = 'name']/value = 'Differentiator')]"/>


    <xsl:variable name="allBusContEvents" select="/node()/simple_instance[type = 'Business_Continuity_Event'][string-length(own_slot_value[slot_reference = 'bce_event_datetime_iso8601']/value) > 0]"/>
    <xsl:variable name="allEventTypes" select="/node()/simple_instance[type = 'Business_Continuity_Event_Type']"/>
    <xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
    <xsl:variable name="allTechNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
    <xsl:variable name="allTechInstances" select="/node()/simple_instance[type = 'Infrastructure_Software_Instance']"/>
    <xsl:variable name="allAppInstances" select="/node()/simple_instance[type = 'Application_Software_Instance']"/>
    <xsl:variable name="allInfoStoreInstances" select="/node()/simple_instance[type = 'Infrastructure_Software_Instance']"/>
    <xsl:variable name="allInfoStores" select="/node()/simple_instance[type = 'Information_Store']"/>
    <xsl:variable name="allInfoReps" select="/node()/simple_instance[type = 'Information_Representation']"/>
    <xsl:variable name="allTechProductUsages" select="/node()/simple_instance[type = 'Technology_Provider_Usage']"/>
    <xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type = 'Technology_Product_Role'][name = $allTechProductUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
    <xsl:variable name="allTechProdBuildArchs" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][name = $allTechProductUsages/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>
    <xsl:variable name="allTechProdBuilds" select="/node()/simple_instance[type = 'Technology_Product_Build']"/>
    
    <xsl:variable name="allTechProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
    <xsl:variable name="allAppDeployments" select="/node()/simple_instance[type = 'Application_Deployment']"/>
    <xsl:variable name="allApps" select="/node()/simple_instance[type = 'Composite_Application_Provider']"/>
    <xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
    <xsl:variable name="prodDeploymentRole" select="/node()/simple_instance[type = 'Deployment_Role'][own_slot_value[slot_reference = 'name']/value = 'Production']"/>
    <xsl:variable name="allCriticalityTiers" select="/node()/simple_instance[type = 'App_Business_Continuity_Criticality_Tier']"/>
    <xsl:variable name="allDRFailOverModels" select="/node()/simple_instance[type = 'Disaster_Recovery_Failover_Model']"/>
    <xsl:variable name="allAppBCProfiles" select="/node()/simple_instance[type = 'Application_Provider_Business_Continuity_Profile'][name = ($allApps, $allAppDeployments)/own_slot_value[slot_reference = 'ea_business_continuity_profile']/value]"/>
    <xsl:variable name="allBCPDurations" select="/node()/simple_instance[type = 'Duration'][name = $allAppBCProfiles/own_slot_value[slot_reference = ('business_continuity_profile_feasible_recovery_point', 'business_continuity_profile_feasible_recovery_time', 'business_continuity_profile_recovery_point_objective', 'business_continuity_profile_recovery_time_objective')]/value]"/>
    <xsl:variable name="allBCExtLinks" select="/node()/simple_instance[type = 'External_Reference_Link'][name = $allAppBCProfiles/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
    
    <xsl:variable name="itServiceOwnerRole" select="/node()/simple_instance[supertype = 'Business_Role'][own_slot_value[slot_reference = 'name']/value = 'IT Service Owner']"/>
    <xsl:variable name="allITServiceOwner2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_to_role']/value = $itServiceOwnerRole/name]"/>
    <xsl:variable name="allITServiceOwnerActors" select="/node()/simple_instance[supertype = 'Actor'][name = $allITServiceOwner2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
    
    <xsl:variable name="allPhysProc2AppRelations" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
    <xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
    <xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
    <xsl:variable name="allOrgs" select="/node()/simple_instance[type = 'Group_Actor']"/>
        
    <xsl:variable name="eventImpactedSites" select="$allSites[name = $allBusContEvents/own_slot_value[slot_reference = 'bce_direct_site_impacts']/value]"/>
    <xsl:variable name="eventImpactedTechNodes" select="$allTechNodes[name = $allBusContEvents/own_slot_value[slot_reference = 'bce_direct_tech_node_impacts']/value]"/>
    <xsl:variable name="eventImpactedTechProducts" select="$allTechProducts[name = $allBusContEvents/own_slot_value[slot_reference = 'bce_direct_tech_provider_impacts']/value]"/>
    <xsl:variable name="eventImpactedApps" select="$allApps[name = $allBusContEvents/own_slot_value[slot_reference = 'bce_direct_app_provider_impacts']/value]"/>
    <xsl:variable name="eventImpactedOrgs" select="$allOrgs[name = $allBusContEvents/own_slot_value[slot_reference = 'bce_direct_actor_impacts']/value]"/>
    <xsl:variable name="allEventDirectImpactedEls" select="$eventImpactedSites union $eventImpactedTechNodes union $eventImpactedTechProducts union $eventImpactedApps union $eventImpactedOrgs"/>
    
    <xsl:template match="knowledge_base">
        {
            "busCaps": [
				<xsl:apply-templates mode="getBusinssCapablitiesJSON" select="$allBusCapabilities"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"bcmData": <xsl:call-template name="RenderBCMJSON"/>,
            "events": [
                <xsl:apply-templates mode="RenderBusContinuityEvent" select="$allBusContEvents"/>
            ],
            "eventTypes": [
                <xsl:apply-templates mode="RenderBCPEnumJSON" select="$allEventTypes"/>
            ],
            "criticalityTiers": [
                <xsl:apply-templates mode="RenderBCPEnumJSON" select="$allCriticalityTiers"/>
            ],
            "failoverModels": [
                <xsl:apply-templates mode="RenderBCPEnumJSON" select="$allDRFailOverModels"/>
            ],
            "itServiceOwners": [
                <xsl:apply-templates mode="RenderBCPStakeholderJSON" select="$allITServiceOwnerActors"/>
            ],
            "impactedElements": {
                <xsl:call-template name="RenderImpactedElements">
                    <xsl:with-param name="directlyImpactedElements" select="$allEventDirectImpactedEls"/>
                </xsl:call-template>
            }
        }
    </xsl:template>
    
    <xsl:template name="RenderBCMJSON">
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			"l0BusCapId": "<xsl:value-of select="eas:getSafeJSString($rootBusCap[1]/name)"/>",
			"l0BusCapName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$rootBusCap"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"l0BusCapLink": "<xsl:value-of select="$rootBusCapLink"/>",
			"l1BusCaps": [
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
		
		{
			"busCapId": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"busCapName": "<xsl:value-of select="$currentBusCapName"/>",
			"busCapLink": "<xsl:value-of select="$currentBusCapLink"/>",
			"l2BusCaps": [	
				<xsl:apply-templates select="$L1Caps" mode="l1_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="l1_caps">
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<xsl:variable name="currentBusCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
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
		
		{
			"busCapId": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"busCapName": "<xsl:value-of select="$currentBusCapName"/>",
			"busCapLink": "<xsl:value-of select="$currentBusCapLink"/>",
			"isDifferentiator": <xsl:value-of select="$isDifferentiator"/>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- Template for rendering the list of Business Capabilities  -->
	<xsl:template match="node()" mode="getBusinssCapablitiesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>

		
		<!-- Processes and Orgs -->
		<xsl:variable name="thisBusinessProcess" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusinessProcess/name]"/>

		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhysProc2AppRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allAppProviderRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps union $thisPhyProcIndirectApps"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"ref": "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"physProcessIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysicalProcesses"/>],
			"appProRoleIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			"applicationIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisApplications"/>],
			"inScope": true
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
    
    
    <xsl:template mode="RenderBusContinuityEvent" match="node()">
        <xsl:variable name="this" select="current()"/>
        
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>
        <xsl:variable name="eventDate" select="$this/own_slot_value[slot_reference = 'bce_event_datetime_iso8601']/value"/>
        <xsl:variable name="eventTypeId" select="$this/own_slot_value[slot_reference = 'bce_event_type']/value"/>
        
        <xsl:variable name="thisImpactedSiteIds" select="$this/own_slot_value[slot_reference = 'bce_direct_site_impacts']/value"/>
        <xsl:variable name="thisImpactedTechNodeIds" select="$this/own_slot_value[slot_reference = 'bce_direct_tech_node_impacts']/value"/>
        <xsl:variable name="thisImpactedTechProductIds" select="$this/own_slot_value[slot_reference = 'bce_direct_tech_provider_impacts']/value"/>
        <xsl:variable name="thisImpactedAppIds" select="$this/own_slot_value[slot_reference = 'bce_direct_app_provider_impacts']/value"/>
        <xsl:variable name="thisImpactedOrgIds" select="$this/own_slot_value[slot_reference = 'bce_direct_actor_impacts']/value"/>
        
        {
        "id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
        "className": "<xsl:value-of select="$this/type"/>",
        "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
        "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
        <xsl:if test="string-length($eventDate) > 0">
            ,"dateTime": "<xsl:value-of select="$eventDate"/>"
        </xsl:if>
        <xsl:if test="string-length($eventTypeId) > 0">
            ,"typeId": "<xsl:value-of select="$eventTypeId"/>"
        </xsl:if>
        ,"siteIds": [<xsl:for-each select="$thisImpactedSiteIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]
        ,"techNodeIds": [<xsl:for-each select="$thisImpactedTechNodeIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]
        ,"techProductIds": [<xsl:for-each select="$thisImpactedTechProductIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]
        ,"appIds": [<xsl:for-each select="$thisImpactedAppIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]
        ,"orgIds": [<xsl:for-each select="$thisImpactedOrgIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="RenderImpactedElements">
        <xsl:param name="directlyImpactedElements"></xsl:param>
        
        <xsl:variable name="this" select="current()"/>
        <!-- GET IMPACTED SITES -->
        
        <!-- GET INDIRECT TECH NODE IMPACTS FOR DIRECTLY IMPACTED SITES-->
        <xsl:variable name="siteTechNodes" select="$allTechNodes[own_slot_value[slot_reference = 'technology_deployment_located_at']/value = $eventImpactedSites/name]"/>
        <xsl:variable name="impactedSiteTechNodes" select="$eventImpactedTechNodes union $siteTechNodes"/>
        
        <!-- GET INDIRECT TECH NODE, TECH PRODUCT USAGE AND APP IMPACTS FOR ALL IMPACTED TECH NODES-->
        <!-- TECH NODES -->
        <xsl:variable name="techNodeSubTechNodes" select="$allTechNodes[name = $impactedSiteTechNodes/own_slot_value[slot_reference = 'contained_technology_nodes']/value]"/>
        <xsl:variable name="techNodeSubSubTechNodes" select="$allTechNodes[name= $techNodeSubTechNodes/own_slot_value[slot_reference = 'contained_technology_nodes']/value]"/>
        <xsl:variable name="techNodeSubSubSubTechNodes" select="$allTechNodes[name = $techNodeSubSubTechNodes/own_slot_value[slot_reference = 'contained_technology_nodes']/value]"/>
        <xsl:variable name="impactedTechNodes" select="$impactedSiteTechNodes union $techNodeSubTechNodes union $techNodeSubSubTechNodes union $techNodeSubSubSubTechNodes"/>
        <!--<xsl:variable name="impactedElsWithTechNodeTechNodes" select="$impactedElsWithSiteTechNodes union $allTechNodeTechNodes"/>-->
        
        <!-- TECH PRODUCT USAGES -->
        <xsl:variable name="techNodeTechInsts" select="$allTechInstances[name = $impactedTechNodes/own_slot_value[slot_reference = 'contained_technology_instances']/value]"/>
        <xsl:variable name="techNodeTechProdUsages" select="$allTechProductUsages[own_slot_value[slot_reference = ('deployed_technology_instances', 'deployed_as_technology_node')]/value = ($techNodeTechInsts, $impactedTechNodes)/name]"/>
        <!--<xsl:variable name="techNodeTechProds" select="$allTechProducts[name = $techNodeTechProdUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>-->
        
        <!-- TECH PRODUCTS -->
        <xsl:variable name="directlyImpactedTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'role_for_technology_provider']/value = $eventImpactedTechProducts/name]"/>
        <xsl:variable name="techProdTechProductUsages" select="$allTechProductUsages[own_slot_value[slot_reference = 'provider_as_role']/value = $directlyImpactedTechProdRoles/name]"/>
        
        <xsl:variable name="impactedTechProductUsages" select="$techNodeTechProdUsages union $techProdTechProductUsages"/>
        <xsl:variable name="impactedTechProdRoles" select="$allTechProdRoles[name = $impactedTechProductUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
        <xsl:variable name="impactedTechProds" select="$allTechProducts[name = $impactedTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
        
        
        <xsl:variable name="impactedTechProdBuildArchs" select="$allTechProdBuildArchs[name = $impactedTechProductUsages/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>
        <xsl:variable name="impactedTechProdBuilds" select="$allTechProdBuilds[name = $impactedTechProdBuildArchs/own_slot_value[slot_reference = 'describes_technology_provider']/value]"/>
        
        <!-- APPS -->
        <xsl:variable name="techNodeAppInsts" select="$allAppInstances[name = $impactedTechNodes/own_slot_value[slot_reference = 'contained_technology_instances']/value]"/>
        <xsl:variable name="impactedAppDeployments" select="$allAppDeployments[own_slot_value[slot_reference = ('application_deployment_technology_instance', 'application_deployment_technical_arch')]/value = ($techNodeAppInsts, $impactedTechProdBuilds)/name]"/>
        <xsl:variable name="techApps" select="$allApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $impactedAppDeployments/name]"/>
        <xsl:variable name="impactedApps" select="$eventImpactedApps union $techApps"/>
        
        <!-- ****FUTURE**** INFO TO APPS -->
        <!--<xsl:variable name="techNodeInfoInsts" select="$allInfoStoreInstances[name = $allTechNodeTechNodes/own_slot_value[slot_reference = 'contained_technology_instances']/value]"/>-->
        
        <!-- PHYSICAL PROCESSES -->
        <xsl:variable name="impactedAPRs" select="$allAppProviderRoles[name = $impactedApps/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
        <xsl:variable name="impactedPhysProc2AppRelations" select="$allPhysProc2AppRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($impactedApps, $impactedAPRs)/name]"/>
        <xsl:variable name="directlyImpactedPhysProcs" select="$allPhysProcs[name = $eventImpactedOrgs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
        <xsl:variable name="indirectlyImpactedPhysProcs" select="$allPhysProcs[name = $impactedPhysProc2AppRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
        <xsl:variable name="impactedPhysProcs" select="$directlyImpactedPhysProcs union $indirectlyImpactedPhysProcs"/>
        
        <!-- BUSINESS PROCESSES -->
        <xsl:variable name="impactedBusProcs" select="$allBusProcs[name = $impactedPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
        
        <!-- ORGS -->
        <xsl:variable name="impactedOrgs" select="($allOrgs[name = $impactedPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]) union $eventImpactedOrgs"/>
        
        "Site": {
            <xsl:apply-templates mode="RenderImpactedSites" select="$eventImpactedSites">
                <xsl:with-param name="inScopeTechNodes" select="$impactedSiteTechNodes"/>
            </xsl:apply-templates>
        },
        "Technology_Node": {
            <xsl:apply-templates mode="RenderImpactedTechNodes" select="$impactedTechNodes">
                <xsl:with-param name="inScopeTechNodes" select="$impactedTechNodes"/>
                <xsl:with-param name="inScopeTechInsts" select="$techNodeTechInsts"/>
                <xsl:with-param name="inScopeTechProdUsages" select="$impactedTechProductUsages"/>
                <xsl:with-param name="inScopeAppInstances" select="$techNodeAppInsts"/>
                <xsl:with-param name="inScopeAppDeployments" select="$impactedAppDeployments"/>
                <xsl:with-param name="inScopeApps" select="$impactedApps"/>
            </xsl:apply-templates>
        },
        "Technology_Provider_Usage": {
            <xsl:apply-templates mode="RenderImpactedTechProdUsages" select="$impactedTechProductUsages">
                <xsl:with-param name="inScopeTechProdBuildArchs" select="$impactedTechProdBuildArchs"/>
                <xsl:with-param name="inScopeTechProdBuilds" select="$impactedTechProdBuilds"/>
                <xsl:with-param name="inScopeTechProdRoles" select="$impactedTechProdRoles"/>
                <xsl:with-param name="inScopeTechProds" select="$impactedTechProds"/>
                <xsl:with-param name="inScopeAppDeployments" select="$impactedAppDeployments"/>
                <xsl:with-param name="inScopeApps" select="$impactedApps"/>
            </xsl:apply-templates>
        },
        "Technology_Product": {
            <xsl:apply-templates mode="RenderImpactedTechProducts" select="$impactedTechProds">
                <xsl:with-param name="inScopeTechProdUsages" select="$techProdTechProductUsages"/>
                <xsl:with-param name="inScopeTechProdBuildArchs" select="$impactedTechProdBuildArchs"/>
                <xsl:with-param name="inScopeTechProdBuilds" select="$impactedTechProdBuilds"/>
                <xsl:with-param name="inScopeTechProdRoles" select="$impactedTechProdRoles"/>
                <xsl:with-param name="inScopeAppDeployments" select="$impactedAppDeployments"/>
                <xsl:with-param name="inScopeApps" select="$impactedApps"/>
            </xsl:apply-templates>
        },
        "Composite_Application_Provider": {
            <xsl:apply-templates mode="RenderCompApps" select="$allApps">
                <xsl:with-param name="inScopePhysProc2AppRelations" select="$impactedPhysProc2AppRelations"/>
                <xsl:with-param name="inScopePhysProcs" select="$impactedPhysProcs"/>
            </xsl:apply-templates>
        },
        "Physical_Process": {
            <xsl:apply-templates mode="RenderImpactedPhysProcs" select="$impactedPhysProcs">
                <xsl:with-param name="inScopeBusProcs" select="$impactedBusProcs"/>
                <xsl:with-param name="inScopeOrgs" select="$impactedOrgs"/>
            </xsl:apply-templates>
        },
        "Group_Actor": {
            <xsl:apply-templates mode="RenderImpactedOrgs" select="$impactedOrgs">
                <xsl:with-param name="inScopePhysProcs" select="$directlyImpactedPhysProcs"/>
            </xsl:apply-templates>
        },
        "Business_Process": {
            <xsl:apply-templates mode="RenderImpactedBusProcs" select="$impactedBusProcs"/>   
        }
    </xsl:template>
    
    
    <xsl:template mode="RenderImpactedSites" match="node()">
        <xsl:param name="inScopeTechNodes" select="()"/>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>
        
        <!-- Get Site Tech Nodes -->
        <xsl:variable name="thisSiteTechNodes" select="$inScopeTechNodes[own_slot_value[slot_reference = 'technology_deployment_located_at']/value = $this/name]"/>
        
        <!-- Render Site -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
            "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "techNodeIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisSiteTechNodes"/>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderImpactedTechNodes" match="node()">
        <xsl:param name="inScopeTechNodes" select="()"/>
        <xsl:param name="inScopeTechInsts" select="()"/>
        <xsl:param name="inScopeTechProdUsages" select="()"/>
        <xsl:param name="inScopeAppInstances" select="()"/>
        <xsl:param name="inScopeAppDeployments" select="()"/>
        <xsl:param name="inScopeApps" select="()"/>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>
        
        <!-- Get contained Tech Nodes -->
        <xsl:variable name="thisSubTechNodes" select="$allTechNodes[name = $this/own_slot_value[slot_reference = 'contained_technology_nodes']/value]"/>
        
        <!-- Get Tech Prod Usages -->
        <xsl:variable name="thisTechInsts" select="$allTechInstances[name = $this/own_slot_value[slot_reference = 'contained_technology_instances']/value]"/>
        <xsl:variable name="thisTechProdUsages" select="$allTechProductUsages[own_slot_value[slot_reference = ('deployed_technology_instances', 'deployed_as_technology_node')]/value = ($thisTechInsts, $this)/name]"/>
        
        <!-- Get Apps -->
        <xsl:variable name="thisAppInsts" select="$allAppInstances[name = $this/own_slot_value[slot_reference = 'contained_technology_instances']/value]"/>
        <xsl:variable name="thisAppDeployments" select="$allAppDeployments[own_slot_value[slot_reference = 'application_deployment_technology_instance']/value = $thisAppInsts/name]"/>
        <xsl:variable name="thisApps" select="$allApps[name = $thisAppDeployments/own_slot_value[slot_reference = 'application_provider_deployed']/value]"/>
         
        <!-- Render Tech Node -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
            "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "techNodeIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisSubTechNodes"/>],
            "techProdUsageIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisTechProdUsages"/>],
            "appIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisApps"/>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderImpactedTechProdUsages" match="node()">
        <xsl:param name="inScopeTechProdBuildArchs" select="()"/>
        <xsl:param name="inScopeTechProdBuilds" select="()"/>
        <xsl:param name="inScopeAppDeployments" select="()"/>
        <xsl:param name="inScopeApps" select="()"/>
        <xsl:param name="inScopeTechProdRoles" select="()"/>
        <xsl:param name="inScopeTechProds" select="()"/>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        
        <!-- Get Tech Product -->
        <xsl:variable name="thisTechProdRole" select="$inScopeTechProdRoles[name = $this/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
        <xsl:variable name="thisTechProd" select="$inScopeTechProds[name = $thisTechProdRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
        
        <!-- Get Site Tech Nodes -->
        <xsl:variable name="thisTechProdBuildArchs" select="$inScopeTechProdBuildArchs[name = $this/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>
        <xsl:variable name="thisTechProdBuilds" select="$inScopeTechProdBuilds[name = $thisTechProdBuildArchs/own_slot_value[slot_reference = 'describes_technology_provider']/value]"/>
        <xsl:variable name="thisAppDeployments" select="$inScopeAppDeployments[own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $thisTechProdBuilds/name]"/>
        <xsl:variable name="thisApps" select="$inScopeApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $thisAppDeployments/name]"/>
        
        <!-- Render Site -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "techProductId": "<xsl:value-of select="eas:getSafeJSString($thisTechProd/name)"/>",
            "appIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisApps"/>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderImpactedTechProducts" match="node()">
        <xsl:param name="inScopeTechProdUsages" select="()"/>
        <xsl:param name="inScopeTechProdBuildArchs" select="()"/>
        <xsl:param name="inScopeTechProdBuilds" select="()"/>
        <xsl:param name="inScopeAppDeployments" select="()"/>
        <xsl:param name="inScopeApps" select="()"/>
        <xsl:param name="inScopeTechProdRoles" select="()"/>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>
        
        <!-- Get SupportedApps -->
        <xsl:variable name="thisTechProdRoles" select="$inScopeTechProdRoles[own_slot_value[slot_reference = 'role_for_technology_provider']/value = $this/name]"/>
        <xsl:variable name="thisTechProdUsages" select="$inScopeTechProdUsages[own_slot_value[slot_reference = 'provider_as_role']/value = $thisTechProdRoles/name]"/>
        <xsl:variable name="thisTechProdBuildArchs" select="$inScopeTechProdBuildArchs[name = $thisTechProdUsages/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>
        <xsl:variable name="thisTechProdBuilds" select="$inScopeTechProdBuilds[name = $thisTechProdBuildArchs/own_slot_value[slot_reference = 'describes_technology_provider']/value]"/>
        <xsl:variable name="thisAppDeployments" select="$inScopeAppDeployments[own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $thisTechProdBuilds/name]"/>
        <xsl:variable name="thisApps" select="$inScopeApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $thisAppDeployments/name]"/>
        
        <!-- Render Site -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
            "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "appIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisApps"/>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderCompApps" match="node()">
        <xsl:param name="inScopePhysProc2AppRelations" select="()"/>
        <xsl:param name="inScopePhysProcs" select="()"/>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>
        
        <!-- IT Service Owner -->
        <xsl:variable name="thisServiceOwner2Role" select="$allITServiceOwner2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
        
        <!-- Get App Deployment Sites -->
        <xsl:variable name="thisAppDeps" select="$allAppDeployments[name = $this/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
        <xsl:variable name="thisProdAppDep" select="$thisAppDeps[own_slot_value[slot_reference = 'application_deployment_role']/value = $prodDeploymentRole/name]"/>
        <xsl:variable name="thisAppTechProdBuilds" select="$allTechProdBuilds[name = $thisAppDeps/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
        <xsl:variable name="thisAppTechProdBuildArchs" select="$allTechProdBuildArchs[name = $thisAppTechProdBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
        <xsl:variable name="thisAppTechProdUsages" select="$allTechProductUsages[name = $thisAppTechProdBuildArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value]"/>
        <xsl:variable name="thisAppTechProdNodes" select="$allTechNodes[own_slot_value[slot_reference = 'used_in_technology_build']/value = $thisAppTechProdUsages/name]"/>
        <xsl:variable name="thisAppTechProdInsts" select="$allTechInstances[own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value = $thisAppTechProdUsages/name]"/>
        
        <xsl:variable name="thisAppInsts" select="($allAppInstances[name = $thisAppDeps/own_slot_value[slot_reference = 'application_deployment_technology_instance']/value]) union $thisAppTechProdInsts"/>
        <xsl:variable name="thisAppTechNodes" select="($allTechNodes[own_slot_value[slot_reference = 'contained_technology_instances']/value = $thisAppInsts/name]) union $thisAppTechProdNodes"/>
        <xsl:variable name="thisAppTechNodeDescendants" select="eas:get_object_descendants($thisAppTechNodes, $allTechNodes, 0, 4, 'inverse_of_contained_technology_nodes')"/>
        <xsl:variable name="thisAppTechNodeAncestors" select="eas:get_object_descendants($thisAppTechNodes, $allTechNodes, 0, 4, 'contained_technology_nodes')"/>
        <xsl:variable name="allThisAppTechNodes" select="$thisAppTechNodeDescendants union $thisAppTechNodeAncestors"/>
        <xsl:variable name="thisAppHostingSites" select="$allSites[name = $allThisAppTechNodes/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
        
        <!-- Get Supported Phys Procs -->
        <xsl:variable name="thisAPRs" select="$allAppProviderRoles[name = $this/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
        <xsl:variable name="thisPhysProc2AppRelations" select="$allPhysProc2AppRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($this, $thisAPRs)/name]"/>
        <xsl:variable name="thisPhysProcs" select="$allPhysProcs[name = $thisPhysProc2AppRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
        
        <!-- BCP Profile Properties -->
        <xsl:variable name="thisBCProfile" select="$allAppBCProfiles[name = $this/own_slot_value[slot_reference = 'ea_business_continuity_profile']/value]"/>
        <xsl:variable name="thisAppDepBCProfile" select="$allAppBCProfiles[name = $thisProdAppDep[1]/own_slot_value[slot_reference = 'ea_business_continuity_profile']/value]"/>
        <xsl:variable name="thisBCPFailoverModel" select="$allDRFailOverModels[name = $thisAppDepBCProfile/own_slot_value[slot_reference = 'business_continuity_profile_failover_model']/value]"/>
        <xsl:variable name="thisBCPNotes">
            <xsl:call-template name="RenderMultiLangInstanceSlot">
                <xsl:with-param name="theSubjectInstance" select="$thisBCProfile"/>
                <xsl:with-param name="displaySlot" select="'ea_notes'"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- <xsl:variable name="thisBCPNotes" select="$thisBCProfile/own_slot_value[slot_reference = 'ea_notes']/value"/> -->
        <xsl:variable name="thisBCPExtLinks" select="$allBCExtLinks[name = $thisBCProfile/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
        
        <xsl:variable name="thisBCPCriticalityTier" select="$allCriticalityTiers[name = $thisBCProfile/own_slot_value[slot_reference = 'app_business_continuity_profile_criticality_tier']/value]"/>
        <!-- <xsl:variable name="thisBCPCriticalityDate" select="$thisBCProfile/own_slot_value[slot_reference = 'NYU_app_bcp_criticality_tiering_date_iso8601']/value"/>
        <xsl:variable name="thisBCPRestorationNo" select="$thisBCProfile/own_slot_value[slot_reference = 'NYU_app_bcp_restoration_sequence_number']/value"/> -->
        <xsl:variable name="thisBCPNextTestDate" select="$thisBCProfile/own_slot_value[slot_reference = 'business_continuity_next_test_date_iso8601']/value"/>
        <xsl:variable name="docsLastUpdated" select="$thisBCProfile/own_slot_value[slot_reference = 'bcp_procedures_last_updated_date_iso8601']/value"/>
        <!-- <xsl:variable name="thisBCPFailoverModelComments" select="$thisBCProfile/own_slot_value[slot_reference = 'NYU_app_bcp_resiliency_solution_comments']/value"/> -->

        <xsl:variable name="thisBCPDurations" select="$allBCPDurations[name = ($thisBCProfile, $thisAppDepBCProfile)/own_slot_value[slot_reference = ('business_continuity_profile_feasible_recovery_point', 'business_continuity_profile_feasible_recovery_time', 'business_continuity_profile_recovery_point_objective', 'business_continuity_profile_recovery_time_objective')]/value]"/>
        <xsl:variable name="thisRPO" select="$thisBCPDurations[name = $thisBCProfile/own_slot_value[slot_reference = 'business_continuity_profile_recovery_point_objective']/value]"/>
        <xsl:variable name="thisRPA" select="$thisBCPDurations[name = $thisBCProfile/own_slot_value[slot_reference = 'business_continuity_profile_feasible_recovery_point']/value]"/>
        <xsl:variable name="thisRTO" select="$thisBCPDurations[name = $thisBCProfile/own_slot_value[slot_reference = 'business_continuity_profile_recovery_time_objective']/value]"/>
        <xsl:variable name="thisRTA" select="$thisBCPDurations[name = $thisBCProfile/own_slot_value[slot_reference = 'business_continuity_profile_feasible_recovery_time']/value]"/>
        
        
        <!-- Render Site -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
            <!-- "link": "<xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>", -->
            "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "hasBCPProfile": <xsl:choose><xsl:when test="count($thisBCProfile) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose> 
            <xsl:if test="count($thisBCPCriticalityTier) > 0">
                ,"criticalityTierId": "<xsl:value-of select="$thisBCPCriticalityTier/name"/>"
            </xsl:if>
            <!-- <xsl:if test="string-length($thisBCPRestorationNo) > 0">
                ,"restorationIndex": <xsl:value-of select="$thisBCPRestorationNo"/>
            </xsl:if> -->
            <!-- <xsl:choose>
                <xsl:when test="string-length($thisBCPRestorationNo) > 0">
                    ,"restorationIndex": <xsl:value-of select="$thisBCPRestorationNo"/>
                </xsl:when>
                <xsl:otherwise>
                    ,"restorationIndex": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="string-length($thisBCPCriticalityDate) > 0">
                    ,"criticalityTierDate": "<xsl:value-of select="$thisBCPCriticalityDate"/>"
                </xsl:when>
                <xsl:otherwise>
                    ,"criticalityTierDate": null
                </xsl:otherwise>
            </xsl:choose> -->
            <xsl:choose>
                <xsl:when test="string-length($thisBCPNextTestDate) > 0">
                    ,"nextBCPTestDate": "<xsl:value-of select="$thisBCPNextTestDate"/>"
                </xsl:when>
                <xsl:otherwise>
                    ,"nextBCPTestDate": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="string-length($docsLastUpdated) > 0">
                    ,"docsLastUpdated": "<xsl:value-of select="$docsLastUpdated"/>"
                </xsl:when>
                <xsl:otherwise>
                    ,"docsLastUpdated": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="count($thisBCPFailoverModel) > 0">
                ,"failoverModelId": "<xsl:value-of select="$thisBCPFailoverModel/name"/>"
            </xsl:if>
            <!-- ,"failoverModelComments": "<xsl:value-of select="$thisBCPFailoverModelComments"/>" -->
            <xsl:choose>
                <xsl:when test="count($thisServiceOwner2Role) > 0">
                    <xsl:variable name="thisITServiceOwner" select="$allITServiceOwnerActors[name = $thisServiceOwner2Role[1]/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
                   <!--  ,"itServiceOwner": {
                        "id": "<xsl:value-of select="$thisITServiceOwner/name"/>",
                        "className": "<xsl:value-of select="$thisITServiceOwner/type"/>",
                        "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisITServiceOwner"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
                    } -->
                    ,"itServiceOwnerId": "<xsl:value-of select="$thisITServiceOwner/name"/>"
                    ,"itServiceOwnerIds": ["<xsl:value-of select="$thisServiceOwner2Role[1]/name"/>"]
                </xsl:when>
                <xsl:otherwise>
                    ,"itServiceOwnerId": null
                    ,"itServiceOwnerIds": []
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="count($thisBCPExtLinks) > 0">
                    ,"externalLinks": [
                        <xsl:apply-templates mode="RenderBCPExternalLinkJSON" select="$thisBCPExtLinks"/>
                    ]
                </xsl:when>
                <xsl:otherwise>
                    ,"externalLinks": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="count($thisRPO) > 0">
                    ,"rpoData": <xsl:call-template name="RenderBCPDurationJSON"><xsl:with-param name="theDuration" select="$thisRPO"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    ,"rpoData": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="count($thisRPA) > 0">
                    ,"rpaData": <xsl:call-template name="RenderBCPDurationJSON"><xsl:with-param name="theDuration" select="$thisRPA"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    ,"rpaData": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="count($thisRTO) > 0">
                    ,"rtoData": <xsl:call-template name="RenderBCPDurationJSON"><xsl:with-param name="theDuration" select="$thisRTO"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    ,"rtoData": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="count($thisRTA) > 0">
                    ,"rtaData": <xsl:call-template name="RenderBCPDurationJSON"><xsl:with-param name="theDuration" select="$thisRTA"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    ,"rtaData": null
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="string-length($thisBCPNotes) > 0">
                    ,"notes": "<xsl:value-of select="$thisBCPNotes"/>"
                </xsl:when>
                <xsl:otherwise>
                    ,"notes": null
                </xsl:otherwise>
            </xsl:choose>
            ,"hostingSiteIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisAppHostingSites"/>]
            ,"physProcIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisPhysProcs"/>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="RenderBCPDurationJSON">
        <xsl:param name="theDuration" select="()"/>
        
        {
            "seconds": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_seconds']/value"/>,
            "minutes": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_minutes']/value"/>,
            "hours": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_hours']/value"/>,
            "days": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_days']/value"/>,
            "weeks": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_weeks']/value"/>,
            "months": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_months']/value"/>,
            "years": <xsl:value-of select="$theDuration/own_slot_value[slot_reference = 'duration_years']/value"/>
        }
        
    </xsl:template>
    
    
    <xsl:template mode="RenderBCPExternalLinkJSON" match="node()">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="thisUrl" select="$this/own_slot_value[slot_reference = 'external_reference_url']/value"/>
        {
            "id": "<xsl:value-of select="$thisId"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "url": "<xsl:value-of select="encode-for-uri($thisUrl)" disable-output-escaping="no" />",
        "rawUrl": "<xsl:value-of select="$thisUrl" disable-output-escaping="yes" />"
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderImpactedPhysProcs" match="node()">
        <xsl:param name="inScopeBusProcs" select="()"/>
        <xsl:param name="inScopeOrgs"></xsl:param>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        
        <!-- Get Bus Proc -->
        <xsl:variable name="thisBusProc" select="$allBusProcs[name = $this/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
        
        <!-- Get Org -->
        <xsl:variable name="thisOrg" select="$allOrgs[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
        
        <!-- Render Physical Process -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            <!-- "name": "<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>", -->
            "busProcId": "<xsl:value-of select="eas:getSafeJSString($thisBusProc/name)"/>",
            "orgId": "<xsl:value-of select="eas:getSafeJSString($thisOrg/name)"/>"
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderImpactedBusProcs" match="node()">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>

        <!-- Render Business Process -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
            "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    
    <xsl:template mode="RenderImpactedOrgs" match="node()">
        <xsl:param name="inScopePhysProcs" select="()"/>
        
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="shortName" select="$this/own_slot_value[slot_reference = 'short_name']/value"/>
        
        <xsl:variable name="thisPhysProcs" select="$allPhysProcs[own_slot_value[slot_reference = 'process_performed_by_actor_role']/value = $this/name]"/>
        
        <!-- Render Org -->
        "<xsl:value-of select="$thisId"/>": {
            "id": "<xsl:value-of select="$thisId"/>",
            "className": "<xsl:value-of select="$this/type"/>",
            "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "short_name": "<xsl:value-of select="eas:getSafeJSString($shortName)"/>",
            "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
            "physProcIds": [<xsl:apply-templates mode="RenderElementIdList" select="$thisPhysProcs"/>]
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template mode="RenderBCPEnumJSON" match="node()">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="thisEnumVal" select="$this/own_slot_value[slot_reference = 'enumeration_value']/value"/>
        {
        "id": "<xsl:value-of select="$thisId"/>",
        "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "label": "<xsl:value-of select="eas:getSafeJSString($thisEnumVal)"/>"
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>

    <xsl:template mode="RenderBCPStakeholderJSON" match="node()">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisId" select="eas:getSafeJSString($this/name)"/>
        <xsl:variable name="email" select="$this/own_slot_value[slot_reference = 'email']/value"/>
        {
        "id": "<xsl:value-of select="$thisId"/>",
        "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "email": "<xsl:value-of select="eas:getSafeJSString($email)"/>"
        }<xsl:if test="not(position() = last())">,
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="RenderElementIdList" match="node()">
        <xsl:variable name="this" select="current()"/>
        "<xsl:value-of select="eas:getSafeJSString($this/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
</xsl:stylesheet>
