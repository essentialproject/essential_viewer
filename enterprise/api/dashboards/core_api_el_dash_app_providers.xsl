<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	
	<!-- ALL BUS CAPS -->
	<xsl:variable name="allApplications" select="/node()/simple_instance[type=('Composite_Application_Provider', 'Application_Provider')]"/>
	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = $allApplications/name]"/>
	<xsl:variable name="allPhyProc2AppProRoleRelations" select="/node()/simple_instance[own_slot_value[slot_reference = ('apppro_to_physbus_from_appprorole', 'apppro_to_physbus_from_apppro')]/value = ($allApplications, $allAppProviderRoles)/name]"/>
	<xsl:variable name="allPhysicalProcesses" select="/node()/simple_instance[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>		
	<xsl:variable name="allBusinessProcess" select="/node()/simple_instance[name = $allPhysicalProcesses/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[name = $allBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
	
	<!-- ENUMERATIONS -->
	<!--<xsl:variable name="allDeploymentLifecycles" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="allCodebases" select="/node()/simple_instance[type = 'Codebase_Status']"/>
	<xsl:variable name="allDeliveryModels" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>-->
	
	
	<!-- ALL SUPPORTED ORGS -->
	<xsl:variable name="allPhysProcPerformers" select="/node()/simple_instance[name = $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="fullOrgSet" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allDirectOrgs" select="$allPhysProcPerformers[name = $fullOrgSet/name]"/>
	<xsl:variable name="allOrg2RoleRelations" select="$allPhysProcPerformers[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allIndirectOrgs" select="$fullOrgSet[name = $allOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allOrganisations" select="$allDirectOrgs union $allIndirectOrgs"/>
	
	<!-- ALL GEO REGIONS -->
	<xsl:variable name="allSites" select="/node()/simple_instance[name = ($allOrganisations, $allPhysicalProcesses)/own_slot_value[slot_reference = ('actor_based_at_site', 'process_performed_at_sites')]/value]"/>
	<xsl:variable name="allLocations" select="/node()/simple_instance[(type = 'Geographic_Location') and (name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
	<xsl:variable name="theGeoRegions" select="/node()/simple_instance[type = 'Geographic_Region']"/>
	<xsl:variable name="countryTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Country')]"/>
	<xsl:variable name="allCountries" select="$theGeoRegions[own_slot_value[slot_reference = 'element_classified_by']/value = $countryTaxTerm/name]"/>
	<xsl:variable name="allCountryParentRegions" select="$theGeoRegions[own_slot_value[slot_reference = 'gr_contained_regions']/value = $allCountries/name]"/>
	<xsl:variable name="allSiteGeoRegions" select="$theGeoRegions[name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allLocationGeoRegions" select="$theGeoRegions[own_slot_value[slot_reference = 'gr_locations']/value = $allLocations/name]"/>
	<xsl:variable name="allGeoRegions" select="$allSiteGeoRegions union $allLocationGeoRegions"/>
	

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
	<!-- 12.02.2021 JP  Created	 -->
	

	<xsl:template match="knowledge_base">
		{
			"meta": {
				"type": "Application_Provider",
				"label": "<xsl:value-of select="eas:i18n('Applications')"/>",
				"properties": {
					"supportedBusCaps": {
						"type": "Business_Capability",
						"label": "<xsl:value-of select="eas:i18n('Supported Business Capabilities')"/>"
					},
					"supportedOrgs": {
						"type": "Group_Actor",
						"label": "<xsl:value-of select="eas:i18n('Supported Organisations')"/>"
					},
					"usedInRegions": {
						"type": "Geographic_Region",
						"label": "<xsl:value-of select="eas:i18n('Used in Regions')"/>"
					}
				},
				"qualifiers": {
					"codebase": {
						"type": "Codebase_Status",
						"label": "<xsl:value-of select="eas:i18n('Codebase')"/>"
					},
					"deploymentStatus": {
						"type": "Lifecycle_Status",
						"label": "<xsl:value-of select="eas:i18n('Deployment Status')"/>"
					},
					"deliveryModel": {
						"type": "Application_Delivery_Model",
						"label": "<xsl:value-of select="eas:i18n('Delivery Model')"/>"
					}
				}
			},
			"data": [
				<xsl:apply-templates mode="RenderAppJSON" select="$allApplications">
					<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
				</xsl:apply-templates>
			]
		}
	</xsl:template>

	
	<xsl:template mode="RenderAppJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- THIS BUS CAPS -->
		<xsl:variable name="thisAppProviderRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = $this/name]"/>
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_appprorole', 'apppro_to_physbus_from_apppro')]/value = ($this, $thisAppProviderRoles)/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>		
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusCaps" select="$allBusCaps[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>	
		
		<!-- THIS SUPPORTED ORGS -->
		<xsl:variable name="thisPhysProcPerformers" select="$allPhysProcPerformers[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisDirectOrgs" select="$thisPhysProcPerformers[type = 'Group_Actor']"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$thisPhysProcPerformers[type = 'ACTOR_TO_ROLE_RELATION']"/>
		<xsl:variable name="thisIndirectOrgs" select="$fullOrgSet[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrgs union $thisIndirectOrgs"/>
		
		<!-- THIS COUNTRIES -->
		<xsl:variable name="thisSites" select="$allSites[name = ($this, $thisPhysicalProcesses)/own_slot_value[slot_reference = ('actor_based_at_site', 'process_performed_at_sites')]/value]"/>
		<xsl:variable name="thisLocations" select="$allLocations[(type = 'Geographic_Location') and (name = $thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
		<xsl:variable name="thisSiteGeoRegions" select="$allSiteGeoRegions[name = $thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisLocationGeoRegions" select="$allLocationGeoRegions[own_slot_value[slot_reference = 'gr_locations']/value = $thisLocations/name]"/>
		<xsl:variable name="thisRegions" select="$thisSiteGeoRegions union $thisLocationGeoRegions"/>
		
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			<!--"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",-->
			"supportedBusCaps": [<xsl:for-each select="$thisBusCaps">"<xsl:value-of select="name"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"supportedOrgs": [<xsl:for-each select="$thisOrganisations">"<xsl:value-of select="name"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"usedInRegions": [<xsl:for-each select="$thisRegions">"<xsl:value-of select="name"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"qualifiers": {
				"codebase": ["<xsl:value-of select="$this/own_slot_value[slot_reference = 'ap_codebase_status']/value"/>"],
				"deploymentStatus": ["<xsl:value-of select="$this/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value"/>"],
				"deliveryModel": ["<xsl:value-of select="$this/own_slot_value[slot_reference = 'ap_delivery_model']/value"/>"]
			}
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
