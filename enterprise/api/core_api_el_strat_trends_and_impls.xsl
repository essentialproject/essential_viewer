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
	<!-- Strategic Trends -->
	<xsl:variable name="allStratImplLfcStatii" select="/node()/simple_instance[type = 'Strategic_Trend_Implication_Lifecycle_Status']"/>
	<xsl:variable name="allStratImplCategory" select="/node()/simple_instance[type = 'Strategic_Trend_Implication_Category']"/>
	<xsl:variable name="allStratTrends" select="/node()/simple_instance[type = 'Strategic_Trend']"/>
	<xsl:variable name="allStratTrendImpls" select="/node()/simple_instance[name = $allStratTrends/own_slot_value[slot_reference = 'strategic_trend_implications']/value]"/>
	
	<!-- Geo Impacts -->
	<xsl:variable name="allGeoRegions" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_geo_scope']/value]"/>
	
	<!-- Business Environment Factor Impacts -->
	<xsl:variable name="allBusEnvCategories" select="/node()/simple_instance[type = 'Business_Environment_Category']"/>
	<xsl:variable name="allBusEnvFactorRels" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_business_environment_impacts']/value]"/>
	<xsl:variable name="allBusEnvFactors" select="/node()/simple_instance[name = $allBusEnvFactorRels/own_slot_value[slot_reference = 'change_for_bus_env_factor']/value]"/>
	
	<!-- Cost Impacts -->
	<xsl:variable name="allCostTypeImpacts" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_cost_impacts']/value]"/>
	<xsl:variable name="allCostTypes" select="/node()/simple_instance[name = $allCostTypeImpacts/own_slot_value[slot_reference = 'change_for_cost_component_type']/value]"/>
	
	<!-- Revenue Impacts -->
	<xsl:variable name="allRevTypeImpacts" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_revenue_impacts']/value]"/>
	<xsl:variable name="allRevTypes" select="/node()/simple_instance[name = $allRevTypeImpacts/own_slot_value[slot_reference = 'change_for_revenue_component_type']/value]"/>
	
	<!-- Bus Service Quality Impacts -->
	<xsl:variable name="allSvcQualImpacts" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_service_quality_impacts']/value]"/>
	<xsl:variable name="allSvcQuals" select="/node()/simple_instance[name = $allRevTypeImpacts/own_slot_value[slot_reference = 'sqc_service_quality']/value]"/>
	
	<!-- EA Element Impacts -->
	<xsl:variable name="allEAImpacts" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_enterprise_impacts']/value]"/>
	<xsl:variable name="allEAElements" select="/node()/simple_instance[name = $allCostTypeImpacts/own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value]"/>
	<xsl:variable name="allProductConcepts" select="$allEAElements[type = 'Product_Concept']"/>
	<xsl:variable name="allExtRoles" select="$allEAElements[type = 'Group_Business_Role']"/>
	
	<xsl:variable name="allBuCaps" select="$allEAElements[type = 'Business_Capability']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allOrgs" select="/node()/simple_instance[type = 'Group_Actor']"/>
		
	<xsl:variable name="allAppCaps" select="$allEAElements[type = 'Application_Capability']"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="allAPRs" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Composite_Application_Provider', 'Application_Provider')]"/>
	
	<xsl:variable name="allTechCaps" select="$allEAElements[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTPRs" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
	
	<xsl:variable name="allStratPlan2Elements" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="allStratPlans" select="/node()/simple_instance[supertype = 'Strategic_Plan']"/>
	
	<xsl:template match="knowledge_base">
		<xsl:call-template name="getBusinessImpactJSON"/>
	</xsl:template>
	
	
	<!-- Template to return all read only data for the view -->
	<xsl:template name="getBusinessImpactJSON">
		{
		"strategicTrends": [
		<xsl:apply-templates mode="getStratTrendsJSON" select="$allStratTrends"/>
		],
		"implCategories": [
		<xsl:apply-templates mode="RenderBasicEnumJSON" select="$allStratImplCategory"/>
		],
		"implLifecycleStatii": [
		<xsl:apply-templates mode="RenderBasicEnumJSON" select="$allStratImplLfcStatii"/>
		]
		}
	</xsl:template>
	
	
	<!-- Template for rendering the list of Strategic Trends  -->
	<xsl:template match="node()" mode="getStratTrendsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="confidencePercent" select="$this/own_slot_value[slot_reference = 'strategic_trend_confidence_percent']/value"/>
		<xsl:variable name="earliestImpactDate" select="$this/own_slot_value[slot_reference = 'strategic_trend_from_year_iso8601']/value"/>
		
		<xsl:variable name="thisStratTrendImpls" select="$allStratTrendImpls[name = $this/own_slot_value[slot_reference = 'strategic_trend_implications']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"confidencePercent": <xsl:choose><xsl:when test="string-length($confidencePercent) > 0"><xsl:value-of select="$confidencePercent"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"earliestImpactDate": <xsl:choose><xsl:when test="string-length($earliestImpactDate) > 0">"<xsl:value-of select="$earliestImpactDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"implications": [<xsl:apply-templates mode="getStratTrendImplsJSON" select="$thisStratTrendImpls"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Strategic Trend Implications  -->
	<xsl:template match="node()" mode="getStratTrendImplsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLabel" select="$this/own_slot_value[slot_reference = 'sti_label']/value"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="displayString" select="$thisLabel"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="implCat" select="$allStratImplCategory[name = $this/own_slot_value[slot_reference = 'sti_category']/value]"/>
		<xsl:variable name="implCatId" select="$implCat/name"/>
		<xsl:variable name="implCatScore" select="$implCat/own_slot_value[slot_reference = 'enumeration_score']/value"/>
		
		<!-- Geo Impacts -->
		<xsl:variable name="thisGeoScope" select="$allGeoRegions[name = $this/own_slot_value[slot_reference = 'sti_geo_scope']/value]"/>
		
		<!-- Business Environment Factor Impacts -->
		<xsl:variable name="thisBusEnvFactorRels" select="$allBusEnvFactorRels[name = $this/own_slot_value[slot_reference = 'sti_business_environment_impacts']/value]"/>
		
		<!-- Cost Impacts -->
		<xsl:variable name="thisCostTypeImpacts" select="$allCostTypeImpacts[name = $this/own_slot_value[slot_reference = 'sti_cost_impacts']/value]"/>
				
		<!-- Revenue Impacts -->
		<xsl:variable name="allRevTypeImpacts" select="/node()/simple_instance[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_revenue_impacts']/value]"/>
		
		<!-- Bus Service Quality Impacts -->
		<xsl:variable name="thisSvcQualImpacts" select="$allSvcQualImpacts[name = $this/own_slot_value[slot_reference = 'sti_service_quality_impacts']/value]"/>
		
		
		<!-- EA Element Impacts -->
		<xsl:variable name="thisEAImpacts" select="$allEAImpacts[name = $allStratTrendImpls/own_slot_value[slot_reference = 'sti_enterprise_impacts']/value]"/>
		<xsl:variable name="thisBusCapImpacts" select="$thisEAImpacts[own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value = $allBuCaps/name]"/>
		<xsl:variable name="thisAppCapImpacts" select="$thisEAImpacts[own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value = $allAppCaps/name]"/>
		<xsl:variable name="thisTechCapImpacts" select="$thisEAImpacts[own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value = $allTechCaps/name]"/>
		
		<!-- Strategic Plan Impacts -->
		<xsl:variable name="thisBusProcImpacts" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCapImpacts/name]"/>
		<xsl:variable name="thisPhysProcImpacts" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusProcImpacts/name]"/>
		<xsl:variable name="thisOrgImpacts" select="$allOrgs[name = $thisPhysProcImpacts/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		
		<xsl:variable name="thisAppSvcImpacts" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $thisAppCapImpacts/name]"/>
		<xsl:variable name="thisAPRImpacts" select="$allAPRs[own_slot_value[slot_reference = 'implementing_application_service']/value = $thisAppSvcImpacts/name]"/>
		<xsl:variable name="thisAppImpacts" select="$allApps[name = $thisAPRImpacts/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		
		<xsl:variable name="thisTechCompImpacts" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $thisTechCapImpacts/name]"/>
		<xsl:variable name="thisTPRImpacts" select="$allTPRs[own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisTechCompImpacts/name]"/>
		<xsl:variable name="thisTechProdImpacts" select="$allTechProds[name = $thisTPRImpacts/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		
		<xsl:variable name="thisStratPlanElements" select="$thisBusProcImpacts union $thisPhysProcImpacts union $thisOrgImpacts union $thisAppSvcImpacts union $thisAPRImpacts union $thisAppImpacts union $thisTechCompImpacts union $thisTPRImpacts union $thisTechProdImpacts"/>
		
		<xsl:variable name="thisStratPlan2ElementRels" select="$allStratPlan2Elements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $thisStratPlanElements/name]"/>
		<xsl:variable name="thisStratPlanImpacts" select="$allStratPlans[name = $thisStratPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
		
		
		<!-- sinple attributes -->
		<xsl:variable name="thisProbability" select="$this/own_slot_value[slot_reference = 'sti_implication_confidence_level']/value"/>
		<xsl:variable name="thisPriorityScore" select="$this/own_slot_value[slot_reference = 'sti_priority_score']/value"/>		
		
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"categoryId": <xsl:choose><xsl:when test="string-length($implCatId) > 0">"<xsl:value-of select="$implCatId"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"categoryScore": <xsl:choose><xsl:when test="string-length($implCatScore) > 0"><xsl:value-of select="$implCatScore"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"probability": <xsl:choose><xsl:when test="string-length($thisProbability) > 0"><xsl:value-of select="$thisProbability"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"priority": <xsl:choose><xsl:when test="string-length($thisPriorityScore) > 0"><xsl:value-of select="$thisPriorityScore"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"geoScope": [<xsl:apply-templates mode="RenderGeoListJSON" select="$thisGeoScope"/>],
		"busEnvFactorImpacts": [<xsl:apply-templates mode="RenderBusEnvFactorImpactJSON" select="$thisBusEnvFactorRels"/>],
		"costTypeImpacts": [<xsl:apply-templates mode="RenderCostTypeImpactJSON" select="$thisCostTypeImpacts"/>],
		"revTypeImpacts": [<xsl:apply-templates mode="RenderRevTypeImpactJSON" select="$allRevTypeImpacts"/>],
		"svcQualityImpacts": [<xsl:apply-templates mode="RenderSvcQualityImpactJSON" select="$thisSvcQualImpacts"/>],
		"productConceptImpacts": [<xsl:apply-templates mode="RenderEAElementImpactJSON" select="$allEAImpacts[own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value = $allProductConcepts/name]"/>],
		"externalRoleImpacts": [<xsl:apply-templates mode="RenderEAElementImpactJSON" select="$allEAImpacts[own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value = $allExtRoles/name]"/>],
		"busCapImpacts": [<xsl:apply-templates mode="RenderEAElementImpactJSON" select="$thisBusCapImpacts"/>],
		"appCapImpacts": [<xsl:apply-templates mode="RenderEAElementImpactJSON" select="$thisAppCapImpacts"/>],
		"techCapImpacts": [<xsl:apply-templates mode="RenderEAElementImpactJSON" select="$thisTechCapImpacts"/>],
		"stratPlanImpactIds": [<xsl:for-each select="$thisStratPlanImpacts/name">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering a list of Business Environment Factor Impacts  -->
	<xsl:template match="node()" mode="RenderBusEnvFactorImpactJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisFactor" select="$allBusEnvFactors[name = $this/own_slot_value[slot_reference = 'change_for_bus_env_factor']/value]"/>
		<xsl:variable name="changePercent" select="$this/own_slot_value[slot_reference = 'change_percentage']/value"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($thisFactor/name)"/>",
		"change": <xsl:choose><xsl:when test="string-length($changePercent) > 0"><xsl:value-of select="$changePercent"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- Template for rendering a list of Cost Type Impacts  -->
	<xsl:template match="node()" mode="RenderCostTypeImpactJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisCostType" select="$allCostTypes[name = $this/own_slot_value[slot_reference = 'change_for_cost_component_type']/value]"/>
		<xsl:variable name="changePercent" select="$this/own_slot_value[slot_reference = 'change_percentage']/value"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($thisCostType/name)"/>",
		"change": <xsl:choose><xsl:when test="string-length($changePercent) > 0"><xsl:value-of select="$changePercent"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- Template for rendering a list of Revenue Type Impacts  -->
	<xsl:template match="node()" mode="RenderRevTypeImpactJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisRevType" select="$allRevTypes[name = $this/own_slot_value[slot_reference = 'change_for_revenue_component_type']/value]"/>
		<xsl:variable name="changePercent" select="$this/own_slot_value[slot_reference = 'change_percentage']/value"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($thisRevType/name)"/>",
		"change": <xsl:choose><xsl:when test="string-length($changePercent) > 0"><xsl:value-of select="$changePercent"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<!-- Template for rendering a list of Service Quality Impacts  -->
	<xsl:template match="node()" mode="RenderSvcQualityImpactJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisSvcQual" select="$allSvcQuals[name = $this/own_slot_value[slot_reference = 'sqc_service_quality']/value]"/>
		<xsl:variable name="changePercent" select="$this/own_slot_value[slot_reference = 'change_percentage']/value"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($thisSvcQual/name)"/>",
		"change": <xsl:choose><xsl:when test="string-length($changePercent) > 0"><xsl:value-of select="$changePercent"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- Template for rendering a list of EA Element Impacts  -->
	<xsl:template match="node()" mode="RenderEAElementImpactJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisEAElement" select="$allEAElements[name = $this/own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value]"/>
		<xsl:variable name="changePercent" select="$this/own_slot_value[slot_reference = 'change_percentage']/value"/>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($thisEAElement/name)"/>",
		"change": <xsl:choose><xsl:when test="string-length($changePercent) > 0"><xsl:value-of select="$changePercent"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	
	<xsl:template match="node()" mode="RenderBasicEnumJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescriptionForJSON"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="enumScore" select="current()/own_slot_value[slot_reference = 'enumeration_score']/value"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"label": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		<xsl:if test="string-length($enumScore) > 0">,"score": <xsl:value-of select="$enumScore"/></xsl:if>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="xs:string" mode="RenderIdStringListJSON">
		"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderGeoListJSON">
		"<xsl:value-of select="current()/own_slot_value[slot_reference = 'gr_region_identifier']/value"/>"<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- END UTILITY TEMPLATES AND FUNCTIONS -->
	
</xsl:stylesheet>
