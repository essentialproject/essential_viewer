<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="core_api_el_arch_impact_includes.xsl"/>
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
	<!-- 24.03.2020 JP  Created	 -->

	<!-- START VIEW SPECIFIC VARIABLES -->
	
	
	<xsl:template match="knowledge_base">
		<xsl:call-template name="getJSON"/>
	</xsl:template>
	
	
	<!-- Template to return all data for the view -->
	<xsl:template name="getJSON">
		{
			"impacts": {
			<!-- BUSINESS LAYER IMPACTS -->
			<xsl:if test="not($impactBusinessCapabilities)">"":{}</xsl:if><xsl:apply-templates mode="BusCapImpactJSON" select="$impactBusinessCapabilities"/>
			<xsl:if test="$impactBusEnvFactors">,</xsl:if><xsl:apply-templates mode="BusEnvFactorImpactJSON" select="$impactBusEnvFactors"/>
			<xsl:if test="$impactChannelTypes">,</xsl:if><xsl:apply-templates mode="ChannelTypeImpactJSON" select="$impactChannelTypes"/>
			<xsl:if test="$impactBrands">,</xsl:if><xsl:apply-templates mode="BrandImpactJSON" select="$impactBrands"/>
			<xsl:if test="$impactProdTypes">,</xsl:if><xsl:apply-templates mode="ProdTypeImpactJSON" select="$impactProdTypes"/>
			<xsl:if test="$impactExternalRoles">,</xsl:if><xsl:apply-templates mode="RoleImpactJSON" select="$impactExternalRoles"/>
			<!--<xsl:if test="$impactBusProcesses">,</xsl:if><xsl:apply-templates mode="BusProcImpactJSON" select="$impactBusProcesses"/>-->
			<xsl:if test="$impactInfoConcepts">,</xsl:if><xsl:apply-templates mode="InfoConceptImpactJSON" select="$impactInfoConcepts"/>
			<!--<xsl:if test="$impactInfoViews">,</xsl:if><xsl:apply-templates mode="InfoViewImpactJSON" select="$impactInfoViews"/>-->
			<xsl:if test="$impactApplicationCapabilities">,</xsl:if><xsl:apply-templates mode="AppCapImpactJSON" select="$impactApplicationCapabilities"/>
			<!--<xsl:if test="$impactApplicatonServices">,</xsl:if><xsl:apply-templates mode="AppServiceImpactJSON" select="$impactApplicatonServices"/>
			<xsl:if test="$impactAppProviders">,</xsl:if><xsl:apply-templates mode="AppImpactJSON" select="$impactAppProviders"/>-->
			<xsl:if test="$impactTechCapabilities">,</xsl:if><xsl:apply-templates mode="TechCapImpactJSON" select="$impactTechCapabilities"/>
			<!--<xsl:if test="$impactTechComponents">,</xsl:if><xsl:apply-templates mode="TechCompImpactJSON" select="$impactTechComponents"/>
			<xsl:if test="$impactTechProducts">,</xsl:if><xsl:apply-templates mode="TechProdImpactJSON" select="$impactTechProducts"/>-->
			<xsl:if test="$impactCostTypes">,</xsl:if><xsl:apply-templates mode="CostTypeImpactJSON" select="$impactCostTypes"/>
			<xsl:if test="$impactRevenueTypes">,</xsl:if><xsl:apply-templates mode="RevenueTypeImpactJSON" select="$impactRevenueTypes"/>
			<xsl:if test="$impactBusOutcomeSQs">,</xsl:if><xsl:apply-templates mode="BusOutcomeImpactJSON" select="$impactBusOutcomeSQs"/>
			}
		}
	</xsl:template>
	
	
</xsl:stylesheet>
