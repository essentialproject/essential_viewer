<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="core_api_el_impact_scope_data_includes.xsl"/>
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


	<xsl:template match="knowledge_base">
		{
		"countryParentRegions": [
		<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allCountryParentRegions"/>
		],
		"countries": [
		<xsl:apply-templates mode="getCountriesJSON" select="$allCountries"/>
		],
		"locations": [
		<xsl:apply-templates mode="getLocationsJSON" select="$allLocations"/>
		],
		"sites": [
		<xsl:apply-templates mode="getSitesJSON" select="$allSites"/>
		],
		"busModels": [
		<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allBusModels"/>
		],
		"busEnvCategories": [
		<xsl:apply-templates mode="getBusinssEnvCategoriesJSON" select="$allBusEnvCategories"/>
		],
		"busEnvFactors": [
		<xsl:apply-templates mode="getBusinssEnvFactorsJSON" select="$allBusEnvFactors"/>
		],
		"channelTypes": [
		<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allChannelTypes"/>
		],
		"brands": [
		<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allBrands"/>
		],
		"busServiceQualities": [
		<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allBusOutcomeSQs"/>
		],
		"linesOfBusiness": [
		<xsl:apply-templates mode="RenderProductTypeJSON" select="$internalProductTypes"/>
		],
		"supportingProductTypes": [
		<xsl:apply-templates mode="RenderProductTypeJSON" select="$externalProductTypes"><xsl:with-param name="customerFacing" select="false()"/></xsl:apply-templates>
		],
		"externalRoles": [
			<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allExternalRoles"/>
		],
		<!--"internalProducts": [
		<xsl:apply-templates mode="getInternalProductsJSON" select="$internalProducts"/>
		],
		"externalProducts": [
		<xsl:apply-templates mode="getExternalProductsJSON" select="$externalProducts"/>
		],-->
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
		"busCaps": [
		<xsl:apply-templates mode="getBusinssCapablitiesJSON" select="$allBusCapabilities"/>
		],
		"bcmData": <xsl:call-template name="RenderBCMJSON"/>,
		"busProcesses": [
		<xsl:apply-templates mode="getBusinssProcessJSON" select="$allBusinessProcess"/>
		],
		"infoDomains": [
		<xsl:apply-templates mode="getInfoDomainJSON" select="$allInfoDomains"/>
		],
		"infoConcepts": [
		<xsl:apply-templates mode="getInfoConceptJSON" select="$allInfoConcepts"/>
		],
		"infoViews": [
		<xsl:apply-templates mode="getInfoViewJSON" select="$allInfoViews"/>
		],
		"appCaps": [
		<xsl:apply-templates mode="getAppCapabilityJSON" select="$allAppCaps"/>
		],
		"armData": <xsl:call-template name="RenderARMJSON"/>,
		"appServices": [
		<xsl:apply-templates mode="getAppServiceJSON" select="$allAppServices"/>
		],
		"techCaps": [
		<xsl:apply-templates mode="getTechCapabilityJSON" select="$allTechCaps"/>
		],
		"trmData": <xsl:call-template name="RenderTRMJSON"/>,
		"techComponents": [
		<xsl:apply-templates mode="getTechComponentJSON" select="$allTechComps"/>
		]
		}
	</xsl:template>


</xsl:stylesheet>
