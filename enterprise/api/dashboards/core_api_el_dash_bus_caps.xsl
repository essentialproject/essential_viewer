<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	
	<!-- ALL LEAF BUS CAPS -->
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type='Business_Capability']"/>
	<xsl:variable name="leafBusCaps" select="$allBusCaps[(own_slot_value[slot_reference = 'supports_business_capabilities']/value) and not(own_slot_value[slot_reference = 'contained_business_capabilities']/value)]"/>
	
	<!-- ALL DELIVERING ORGS -->
	<xsl:variable name="allBusinessProcess" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusCaps/name]"/>
	<xsl:variable name="allPhysicalProcesses" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $allBusinessProcess/name]"/>
	<xsl:variable name="allDirectOrganisations" select="/node()/simple_instance[(type='Group_Actor') and (name = $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
	<xsl:variable name="allOrg2RoleRelations" select="/node()/simple_instance[(type='ACTOR_TO_ROLE_RELATION') and (name = $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
	<xsl:variable name="allIndirectOrganisations" select="/node()/simple_instance[name = $allOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allOrganisations" select="$allDirectOrganisations union $allIndirectOrganisations"/>
	
	<!-- ALL SUPPORTING APPS -->
	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allPhyProc2AppProRoleRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $allPhysicalProcesses/name]"/>
	<xsl:variable name="allPhyProcAppProRoles" select="$allAppProviderRoles[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="allPhyProcDirectApps" select="/node()/simple_instance[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allPhyProcIndirectApps" select="/node()/simple_instance[name = $allPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allApplications" select="$allPhyProcDirectApps union $allPhyProcIndirectApps"/>
	
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
				"type": "Business_Capability",
				"label": "<xsl:value-of select="eas:i18n('Business Capabilities')"/>",
				"properties": {
					"providedByOrgs": {
						"type": "Group_Actor",
						"label": "<xsl:value-of select="eas:i18n('Provided by Organisations')"/>"
					},
					"supportedByApps": {
						"type": "Application_Provider",
						"label": "<xsl:value-of select="eas:i18n('Supported by Applications')"/>"
					},
					"providedInGeos": {
						"type": "Geographic_Region",
						"label": "<xsl:value-of select="eas:i18n('Provided in Regions')"/>"
					}
				}
			},
			"data": [
			<xsl:apply-templates mode="RenderBusCapJSON" select="$leafBusCaps">
				<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
			</xsl:apply-templates>
			]
		}
	</xsl:template>

	
	<xsl:template mode="RenderBusCapJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- THIS DELIVERING ORGS -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[own_slot_value[slot_reference = 'realises_business_capability']/value = $this/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusinessProcess/name]"/>
		<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[(type='Group_Actor') and (name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[(type='ACTOR_TO_ROLE_RELATION') and (name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>
		
		<!-- THIS SUPPORTING APPS -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allAppProviderRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps union $thisPhyProcIndirectApps"/>
		
		<!-- THIS COUNTRIES -->
		<xsl:variable name="thisSites" select="$allSites[name = ($thisOrganisations, $thisPhysicalProcesses)/own_slot_value[slot_reference = ('actor_based_at_site', 'process_performed_at_sites')]/value]"/>
		<xsl:variable name="thisLocations" select="$allLocations[(type = 'Geographic_Location') and (name = $thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
		<xsl:variable name="thisSiteGeoRegions" select="$allSiteGeoRegions[name = $thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisLocationGeoRegions" select="$allLocationGeoRegions[own_slot_value[slot_reference = 'gr_locations']/value = $thisLocations/name]"/>
		<xsl:variable name="thisRegions" select="$thisSiteGeoRegions union $thisLocationGeoRegions"/>
		
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			<!--"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",-->
			"providedByOrgs": [<xsl:for-each select="$thisOrganisations">"<xsl:value-of select="name"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"supportedByApps": [<xsl:for-each select="$thisApplications">"<xsl:value-of select="name"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"providedInGeos": [<xsl:for-each select="$thisRegions">"<xsl:value-of select="name"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
		
</xsl:stylesheet>
