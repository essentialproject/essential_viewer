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
	
	<xsl:param name="offset" select="1"/>
	<xsl:param name="limit" select="0"/>
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<!-- Goals and Objectives -->
	<xsl:variable name="stratGoalTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>
	<xsl:variable name="objectiveTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="allBusinessGoals" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $stratGoalTaxTerm/name]"/>
	<xsl:variable name="allBusinessObjectives" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $objectiveTaxTerm/name]"/>
	
	<!-- Reference Model Taxonomy Info -->
	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
	
	
	<!-- Product Concepts -->
	<xsl:variable name="allProdConcepts" select="/node()/simple_instance[type = 'Product_Concept']"/>
	
	<!-- External Organisational Roles -->
	<xsl:variable name="allExternalRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'role_is_external']/value = 'true')]"/>
	
	
	<!-- Business Outcome Service Qualities -->
	<xsl:variable name="allBusOutcomeSQs" select="/node()/simple_instance[type = 'Business_Service_Quality']"/>
	
	
	<!-- Cost Types  -->
	<xsl:variable name="allCostTypes" select="/node()/simple_instance[type = 'Cost_Component_Type']"/>
	
	
	<!-- Revenue Types -->
	<xsl:variable name="allRevenueTypes" select="/node()/simple_instance[type = 'Revenue_Component_Type']"/>
	
	
	<!-- Business Capabilities, Processes and Organisations -->
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
	
	<!-- App Technical Service Qualities -->
	<xsl:variable name="appTechAssessments" select="/node()/simple_instance[(type = 'Technology_Performance_Measure') and (name = $allApplications/own_slot_value[slot_reference='performance_measures']/value)]"/>
	<xsl:variable name="appTechAssessmentSQValues" select="/node()/simple_instance[name = $appTechAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
	
	<!-- Technology -->
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	
	<!-- Customer Journeys -->
	<xsl:variable name="allCustomerJourneyPhases" select="/node()/simple_instance[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $allPhysicalProcesses/name]"/>
	<xsl:variable name="allCustomerJourneys" select="/node()/simple_instance[own_slot_value[slot_reference = 'cj_phases']/value = $allCustomerJourneyPhases/name]"/>
	<xsl:variable name="allCJPhase2EmotionRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_from_cust_journey_phase']/value = $allCustomerJourneyPhases/name]"/>
	<xsl:variable name="allCustomerEmotions" select="/node()/simple_instance[name = $allCJPhase2EmotionRels/own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_to_emotion']/value]"/>
	<xsl:variable name="allCJPhase2ExperienceRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'cust_journey_phase_to_experience_from_cust_journey_phase']/value = $allCustomerJourneyPhases/name]"/>
	<xsl:variable name="allCustomerExperiences" select="/node()/simple_instance[name = $allCJPhase2ExperienceRels/own_slot_value[slot_reference = 'cust_journey_phase_to_experience_to_experience']/value]"/>
	<xsl:variable name="allCJPerformanceMeasures" select="/node()/simple_instance[name = $allCustomerJourneyPhases/own_slot_value[slot_reference = 'performance_measures']/value]"/>
	<xsl:variable name="allCustomerSvcQualVals" select="/node()/simple_instance[name = $allCJPerformanceMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value]"/>
	<xsl:variable name="allCustomerSvcQuals" select="/node()/simple_instance[name = $allCustomerSvcQualVals/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
	
	<!-- Value Streams -->
	<xsl:variable name="allValueStages" select="/node()/simple_instance[name = $allCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
	<xsl:variable name="allValueStreams" select="/node()/simple_instance[own_slot_value[slot_reference = 'vs_value_stages']/value = $allValueStages/name]"/>
	
	<!-- Planning Action -->
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[(type = 'Planning_Action') and (count(own_slot_value[slot_reference = 'planning_action_classes']/value) > 0)]"/>
	
	<!-- Styling -->
	<xsl:variable name="enumLowThreshold" select="-5"/>
	<xsl:variable name="enumLowStyle" select="'lowHeatmapColour'"/>
	<xsl:variable name="enumNeutralThreshold" select="0"/>
	<xsl:variable name="enumNeutralStyle" select="'neutralHeatmapColour'"/>
	<xsl:variable name="enumMediumThreshold" select="5"/>
	<xsl:variable name="enumMediumStyle" select="'mediumHeatmapColour'"/>
	<xsl:variable name="enumHighStyle" select="'highHeatmapColour'"/>
	
	
	<xsl:variable name="emotionVeryLowThreshold" select="-6"/>
	<xsl:variable name="emotionLowThreshold" select="-3"/>
	<xsl:variable name="emotionNeutralThreshold" select="3"/>
	<xsl:variable name="emotionHighThreshold" select="6"/>
	
	<xsl:variable name="negativeEmoIcon" select="'fa-frown-o'"/>
	<xsl:variable name="neutralEmoIcon" select="'fa-meh-o'"/>
	<xsl:variable name="positiveEmoIcon" select="'fa-smile-o'"/>
	
	<xsl:variable name="verySadEmoji">images/svg/very_sad_face_emoji.svg</xsl:variable>
	<xsl:variable name="sadEmoji">images/svg/confused_face_emoji.svg</xsl:variable>
	<xsl:variable name="neutralEmoji">images/svg/neutral_face_emoji.svg</xsl:variable>
	<xsl:variable name="happyEmoji">images/svg/slightly_smiling_face_emoji.svg</xsl:variable>
	<xsl:variable name="veryHappyEmoji">images/svg/smiling_face_emoji.svg</xsl:variable>
	<xsl:variable name="noEmoji">images/svg/no_emoji.svg</xsl:variable>
	
	<xsl:variable name="negativeIcon">images/svg/eas_circle_negative.svg</xsl:variable>
	<xsl:variable name="neutralIcon">images/svg/eas_circle_neutral.svg</xsl:variable>
	<xsl:variable name="positiveIcon">images/svg/eas_circle_positive.svg</xsl:variable>
	<xsl:variable name="noCxIcon">images/svg/eas_circle_unknown.svg</xsl:variable>
	
	<xsl:variable name="kpiLowThreshold" select="2"/>
	<xsl:variable name="kpiLowStyle" select="'lowHeatmapColour'"/>
	<xsl:variable name="kpiNeutralThreshold" select="4"/>
	<xsl:variable name="kpiNeutralStyle" select="'neutralHeatmapColour'"/>
	<xsl:variable name="kpiMediumThreshold" select="7"/>
	<xsl:variable name="kpiMediumStyle" select="'mediumHeatmapColour'"/>
	<xsl:variable name="kpiHighStyle" select="'highHeatmapColour'"/>
	
	<!-- graph model styling constants -->
	<xsl:variable name="inScopeElementWidth">90</xsl:variable>
	<xsl:variable name="inScopeElementHeight">70</xsl:variable>
	<xsl:variable name="inScopeElementColour">hsla(220, 70%, 95%, 1)</xsl:variable>
	<xsl:variable name="inScopeElementStrokeColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	<xsl:variable name="classLabelTextColour">red</xsl:variable>
	<xsl:variable name="elementLabelTextColour">#333333</xsl:variable>
	
	<xsl:variable name="inScopeRelationWidth">90</xsl:variable>
	<xsl:variable name="inScopeRelationHeight">70</xsl:variable>
	<xsl:variable name="inScopeRelationColour">hsla(220, 70%, 95%, 1)</xsl:variable>
	<xsl:variable name="inScopeRelationStrokeColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	
	
	<!-- percentage thresholds for application technical health -->
	<xsl:variable name="techHealthLowThreshold" select="30"/>
	<xsl:variable name="techHealthNeutralThreshold" select="60"/>
	<xsl:variable name="techHealthMediumThreshold" select="80"/>
	
	<xsl:variable name="noHeatmapStyle" select="'noHeatmapColour'"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="getBusinessImpactJSON"/>
	</xsl:template>


	<!-- Template to return all read only data for the view -->
	<xsl:template name="getBusinessImpactJSON">
		{
			"cxStyles": {
				"negative": {
					"label": "<xsl:value-of select="eas:i18n('Poor')"/>",
					"icon": "<xsl:value-of select="$negativeIcon"/>"
				},
				"neutral": {
					"label": "<xsl:value-of select="eas:i18n('OK')"/>",
					"icon": "<xsl:value-of select="$neutralIcon"/>"
				},
				"positive": {
					"label": "<xsl:value-of select="eas:i18n('Good')"/>",
					"icon": "<xsl:value-of select="$positiveIcon"/>"
				},
				"undefined": {
					"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
					"icon": "<xsl:value-of select="$noCxIcon"/>"
				}
			},
			"emotionStyles": {
				"negative": {
					"label": "<xsl:value-of select="eas:i18n('Negative')"/>",
					"emoji": "<xsl:value-of select="$verySadEmoji"/>"
				},
				"quiteNegative": {
					"label": "<xsl:value-of select="eas:i18n('Quite Negative')"/>",
					"emoji": "<xsl:value-of select="$sadEmoji"/>"
				},
				"neutral": {
					"label": "<xsl:value-of select="eas:i18n('Neutral')"/>",
					"emoji": "<xsl:value-of select="$neutralEmoji"/>"
				},
				"quitePositive": {
					"label": "<xsl:value-of select="eas:i18n('Quite Positive')"/>",
					"emoji": "<xsl:value-of select="$happyEmoji"/>"
				},
				"positive": {
					"label": "<xsl:value-of select="eas:i18n('Positive')"/>",
					"emoji": "<xsl:value-of select="$veryHappyEmoji"/>"
				},
				"undefined": {
					"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
					"emoji": "<xsl:value-of select="$noEmoji"/>"
				}
			},
			"productConcepts": [
				<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allProdConcepts"/>
			],
			"externalRoles": [
				<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allExternalRoles"/>
			],
			"busOutcomes": [
				<xsl:apply-templates mode="RenderBasicInstanceJSON" select="$allBusOutcomeSQs"/>
			],
			"costTypes": [
				<xsl:apply-templates mode="RenderBasicEnumJSON" select="$allCostTypes"/>
			],
			"revenueTypes": [
				<xsl:apply-templates mode="RenderBasicEnumJSON" select="$allRevenueTypes"/>
			],
			"businessGoals": [
				<xsl:apply-templates mode="getBusinssGoalsJSON" select="$allBusinessGoals"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"businessObjectives": [
				<xsl:apply-templates mode="getBusinssObjectivesJSON" select="$allBusinessObjectives"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"valueStreams": [
				<xsl:apply-templates mode="getValueStreamJSON" select="$allValueStreams"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"valueStages": [
				<xsl:apply-templates mode="getValueStageJSON" select="$allValueStages"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"customerJourneys": [
				<xsl:apply-templates mode="getCustomerJourneyJSON" select="$allCustomerJourneys"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"customerJourneyPhases": [
				<xsl:apply-templates mode="getCustomerJourneyPhaseJSON" select="$allCustomerJourneyPhases"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"busCaps": [
				<xsl:apply-templates mode="getBusinssCapablitiesJSON" select="$allBusCapabilities"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"bcmData": <xsl:call-template name="RenderBCMJSON"/>,
			"busProcesses": [
				<xsl:apply-templates mode="getBusinssProcessJSON" select="$allBusinessProcess"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"appCaps": [
				<xsl:apply-templates mode="RenderAppCapDetailsJSON" select="$allAppCaps"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"armData": <xsl:call-template name="RenderARMJSON"/>,
			"techCaps": [
				<xsl:apply-templates mode="RenderTechCapDetailsJSON" select="$allTechCaps"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"trmData": <xsl:call-template name="RenderTRMJSON"/>
		<!--,
			"physProcesses": [
				<xsl:apply-templates mode="getPhysicalProcessJSON" select="$allPhysicalProcesses"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"organisations": [
				<xsl:apply-templates mode="getOrganisationJSON" select="$allOrganisations"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"appServices": [
				<xsl:apply-templates mode="getAppServiceJSON" select="$allAppServices"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"applications": [
				<xsl:apply-templates mode="getApplicationJSON" select="$allApplications"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"appProviderRoles": [
				<xsl:apply-templates mode="getAppProviderRoleJSON" select="$allPhyProcAppProRoles"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			]-->
		}
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Business Goals  -->
	<xsl:template match="node()" mode="getBusinssGoalsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'objective_supports_objective']/value = $this/name]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"objectiveIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			"objectives": [],
			"inScope": false,
			"isSelected": false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Business Objectives  -->
	<xsl:template match="node()" mode="getBusinssObjectivesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisSupportedBusinessGoals" select="$allBusinessGoals[name = $this/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"targetDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>",
			"goalIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedBusinessGoals"/>],
			"inScope": true
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Business Capabilities  -->
	<xsl:template match="node()" mode="getBusinssCapablitiesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		<!-- Processes and Orgs -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusinessProcess/name]"/>
		<!--<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>-->
		
		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!--<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-->
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="$allCustomerJourneys[own_slot_value[slot_reference = 'cj_phases']/value = $thisCustomerJourneyPhases/name]"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"ref": "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			<!--"type": elementTypes.busCap,-->
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
						"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
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
			"editorId": "busCapModal",
			"inScope": false
			<xsl:call-template name="RenderGenericMetaProps"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Processes  -->
	<xsl:template match="node()" mode="getBusinssProcessJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $this/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		<!-- Physical Processes -->
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $this/name]"/>
		<!--<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>-->
		
		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!--<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-->
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="$allCustomerJourneys[own_slot_value[slot_reference = 'cj_phases']/value = $thisCustomerJourneyPhases/name]"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"index": <xsl:value-of select="position() - 1"/>,
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		<!--type: elementTypes.busProcess,-->
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
	</xsl:template>
	
	
	<!-- Template to render the heatmap scores and styles for a Value Stream based on the given list of Customer Journey Phases-->
	<xsl:template mode="RenderValueStreamAverageScores" match="node()">
		<xsl:param name="inScopeValueStages"/>
		<xsl:param name="inScopeCJPs"/>
		
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisValueStages" select="$inScopeValueStages[name = $this/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>
		<xsl:variable name="thisCJPs" select="$inScopeCJPs[own_slot_value[slot_reference = 'cjp_value_stages']/value = $thisValueStages/name]"/>
		
		<!-- measures -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCJPs, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCJPs, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCJPs, 0, 0)"/>

		
		<xsl:choose>
			<xsl:when test="count($thisCJPs) > 0">
				{
					"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
					"cxScore": <xsl:value-of select="$custExperienceScore"/>,
					"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
					"cxStyle": "<xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>",
					"emotionScore": <xsl:value-of select="$emotionScore"/>,
					"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
					"emotionStyle": "<xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>",
					"kpiScore": <xsl:value-of select="$kpiScore"/>,
					"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
				}<xsl:if test="not(position()=last())">,
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				{
					"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
					"cxScore": 0,
					"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
					"cxStyle": null,
					"emotionScore": 0,
					"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
					"emotionStyle": null,
					"kpiScore": -1,
					"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
				}<xsl:if test="not(position()=last())">,
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- Templates for rendering the Business Reference Model  -->
	<xsl:template name="RenderBCMJSON">
		
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($rootBusCap/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:value-of select="$rootBusCapLink"/>",
			"childBusCaps": [
				<xsl:apply-templates select="$L0Caps" mode="l0_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
			]
		}
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="l0_caps">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="currentBusCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="L1Caps" select="$allBusCapabilities[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:value-of select="$currentBusCapLink"/>",
			"childBusCaps": [	
				<xsl:apply-templates select="$L1Caps" mode="l1_caps"><xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/></xsl:apply-templates>
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="l1_caps">
		<xsl:variable name="this" select="current()"/>
		
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
				<xsl:with-param name="isForJSONAPI" select="true()"/>
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
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
	<xsl:template match="node()" mode="getPhysicalProcessJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/supertype]"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $this/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<!-- Business Capability -->
		<xsl:variable name="thisBusinessCap" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		
		<!-- Organisation -->
		<xsl:variable name="thisDirectOrganisation" select="$allDirectOrganisations[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelation" select="$allOrg2RoleRelations[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisation" select="$allIndirectOrganisations[name = $thisOrg2RoleRelation/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisation" select="$thisDirectOrganisation union $thisIndirectOrganisation"/>
		
		<!-- Supporting Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $this/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $this/name]"/>

		<!-- measures -->
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
			<!--type: elementTypes.physProcess,-->
			"busCapId": "<xsl:value-of select="eas:getSafeJSString($thisBusinessCap[1]/name)"/>",
			"busCapLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisBusinessCap[1]"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"busProcessId": "<xsl:value-of select="eas:getSafeJSString($thisBusinessProcess/name)"/>",
			"busProcessRef": "<xsl:if test="count($thisBusinessProcess) > 0">busProc<xsl:value-of select="index-of($allBusinessProcess, $thisBusinessProcess)"/></xsl:if>",
			"busProcessName": "<xsl:value-of select="eas:validJSONString($busProcName)"/>",
			"busProcessDescription": "<xsl:value-of select="eas:validJSONString($busProcDesc)"/>",
			"busProcessLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisBusinessProcess"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"orgId": "<xsl:value-of select="eas:getSafeJSString($thisOrganisation/name)"/>",
			"orgRef": "<xsl:if test="count($thisOrganisation) > 0">org<xsl:value-of select="index-of($allOrganisations, $thisOrganisation)"/></xsl:if>",
			"orgName": "<xsl:value-of select="eas:validJSONString($orgName)"/>",
			"orgDescription": "<xsl:value-of select="eas:validJSONString($orgDesc)"/>",
			"orgLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisOrganisation"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
			"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>"<!--, 
			"emotionIcon": "<xsl:value-of select="eas:getEmotionScoreIcon($emotionScore)"/>",
			"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>", 
			"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"-->
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Organisations  -->
	<xsl:template match="node()" mode="getOrganisationJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<!-- Physical Processes -->
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $this/name]"/>
		<xsl:variable name="thisInDirectPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'process_performed_by_actor_role']/value = $thisOrg2RoleRelations/name]"/>
		<xsl:variable name="thisDirectPhysProcs" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'process_performed_by_actor_role']/value = $this/name]"/>
		<xsl:variable name="thisPhysProcs" select="$thisInDirectPhysProcs union $thisDirectPhysProcs"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allPhyProcDirectApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allPhyProcIndirectApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!--<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-->
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="$allCustomerJourneys[own_slot_value[slot_reference = 'cj_phases']/value = $thisCustomerJourneyPhases/name]"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>

		
		{
			<!--id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			index: <xsl:value-of select="position() - 1"/>,
			<!-\-type: elementTypes.organisation,-\->
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			objectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			physProcessIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysProcs"/>],
			appProRoleIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			applicationIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisApplications"/>],
			customerJourneyIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneys"/>],
			customerJourneyPhaseIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			valueStreamIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
			valueStageIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
			overallScores: <xsl:choose>
				<xsl:when test="count($thisCustomerJourneyPhases) > 0">
					{
					cxScore: <xsl:value-of select="$custExperienceScore"/>,
					cxStyleClass: "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
					cxStyle: "<xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>",
					emotionScore: <xsl:value-of select="$emotionScore"/>,
					emotionStyleClass: "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
					emotionStyle: "<xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>",
					kpiScore: <xsl:value-of select="$kpiScore"/>,
					kpiPercent: <xsl:value-of select="round($kpiScore * 10)"/>,
					kpiStyleClass: "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
					}
				</xsl:when>
				<xsl:otherwise>
					{
					cxScore: 0,
					cxStyleClass: "<xsl:value-of select="$noHeatmapStyle"/>",
					cxStyle: cxStyles.undefined,
					emotionScore: 0,
					emotionStyleClass: "<xsl:value-of select="$noHeatmapStyle"/>",
					emotionStyle: emotionStyles.undefined,
					kpiScore: -1,
					kpiStyleClass: "<xsl:value-of select="$noHeatmapStyle"/>"
					}
				</xsl:otherwise>
			</xsl:choose>,
			heatmapScores: [
			<xsl:apply-templates mode="RenderValueStreamAverageScores" select="$allValueStreams">
				<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
				<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
			</xsl:apply-templates>
			],
			editorId: "orgModal",
			inScope: false,
			planningActionIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPlanningActions"/>],
			planningActions: null,
			planningAction: null,
			planningNotes: "",
			hasPlan: false-->
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of App Services  -->
	<xsl:template match="node()" mode="getAppServiceJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<!-- Application Provider Roles -->
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $this/name]"/>
		<xsl:variable name="thisApps" select="$allApplications[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		
		<!-- technical health -->
		<xsl:variable name="thisTechHealthScore" select="eas:getAppListTechHealthScore($thisApps)"/>
		<xsl:variable name="thisTechHealthStyle" select="eas:getAppTechHealthStyle($thisTechHealthScore)"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $thisAppProRoles/name]"/>
		<xsl:variable name="thisPhysProcs" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[name = $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="$allBusCapabilities[name = $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="$allCustomerJourneys[own_slot_value[slot_reference = 'cj_phases']/value = $thisCustomerJourneyPhases/name]"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		index: <xsl:value-of select="position() - 1"/>,
		type: elementTypes.appService,
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		objectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		physProcessIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysProcs"/>],
		appProRoleIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisAppProRoles"/>],
		customerJourneyIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneys"/>],
		customerJourneyPhaseIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
		valueStreamIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStreams"/>],
		valueStageIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisValueStages"/>],
		overallScores: <xsl:choose>
			<xsl:when test="count($thisCustomerJourneyPhases) > 0">
				{
				cxScore: <xsl:value-of select="$custExperienceScore"/>,
				cxStyleClass: "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
				cxStyle: "<xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>",
				emotionScore: <xsl:value-of select="$emotionScore"/>,
				emotionStyleClass: "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
				emotionStyle: "<xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>",
				kpiScore: <xsl:value-of select="$kpiScore"/>,
				kpiPercent: <xsl:value-of select="round($kpiScore * 10)"/>,
				kpiStyleClass: "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
				}
			</xsl:when>
			<xsl:otherwise>
				{
				cxScore: 0,
				cxStyleClass: "<xsl:value-of select="$noHeatmapStyle"/>",
				cxStyle: cxStyles.undefined,
				emotionScore: 0,
				emotionStyleClass: "<xsl:value-of select="$noHeatmapStyle"/>",
				emotionStyle: emotionStyles.undefined,
				kpiScore: -1,
				kpiStyleClass: "<xsl:value-of select="$noHeatmapStyle"/>"
				}
			</xsl:otherwise>
		</xsl:choose>,
		heatmapScores: [
		<xsl:apply-templates mode="RenderValueStreamAverageScores" select="$allValueStreams">
			<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
			<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
		</xsl:apply-templates>
		],
		techHealthScore: <xsl:value-of select="$thisTechHealthScore"/>,
		techHealthStyle: "<xsl:value-of select="$thisTechHealthStyle"/>",
		editorId: "appServiceModal",
		inScope: false,
		planningActionIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPlanningActions"/>],
		planningActions: null,
		planningAction: null,
		planningNotes: "",
		hasPlan: false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Application Provider Roles  -->
	<xsl:template match="node()" mode="getAppProviderRoleJSON">
		<xsl:variable name="this" select="current()"/>
		
		
		<!-- Application -->
		<xsl:variable name="thisApplication" select="$allApplications[name = $this/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		
		<!-- Application Service -->
		<xsl:variable name="thisAppService" select="$allAppServices[name = $this/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $this/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			type: elementTypes.appProRole,
			appId: "<xsl:value-of select="eas:getSafeJSString($thisApplication/name)"/>",
			appRef: "<xsl:if test="count($thisApplication) > 0">app<xsl:value-of select="index-of($allApplications, $thisApplication)"/></xsl:if>",
			appName: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			appDescription: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			appLink: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			serviceId: "<xsl:value-of select="eas:getSafeJSString($thisAppService/name)"/>",
			serviceRef: "<xsl:if test="count($thisAppService) > 0">appService<xsl:value-of select="index-of($allAppServices, $thisAppService)"/></xsl:if>",
			serviceName: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisAppService"/></xsl:call-template>",
			serviceDescription: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisAppService"/></xsl:call-template>",
			serviceLink: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisAppService"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			physProcessIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysicalProcesses"/>],
			customerJourneyPhaseIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			customerJourneyPhases: [],
			editorId: "appProRoleModal",
			planningAction: null,
			cxScore: 0,
			kpiScore: 0
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Applications  -->
	<xsl:template match="node()" mode="getApplicationJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- technical health -->
		<xsl:variable name="thisTechHealthScore" select="eas:getAppTechHealthScore($this)"/>
		<xsl:variable name="thisTechHealthStyle" select="eas:getAppTechHealthStyle($thisTechHealthScore)"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/supertype]"/>
		
		<!-- Application Provider Roles -->
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = $this/name]"/>
		
		<!-- Supported Physical Processes -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($this, $thisAppProRoles)/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessProcesses" select="$allBusinessProcess[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisBusCaps" select="$allBusCapabilities[name = $thisBusinessProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusCaps, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-- Organisations -->
		<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value]"/>
		<xsl:variable name="thisValueStreams" select="$allValueStreams[own_slot_value[slot_reference = 'vs_value_stages']/value = $thisValueStages/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			type: elementTypes.application,
			index: <xsl:value-of select="position() - 1"/>,
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
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
	</xsl:template>
	
	
	<!-- Template for rendering the list of Value Streams  -->
	<xsl:template match="node()" mode="getValueStreamJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Value Stages -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $this/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisCJPs" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_value_stages']/value = $thisValueStages/name]"/>
		
		<!-- Physical Processes -->
		<xsl:variable name="thisPhysProcs" select="$allPhysicalProcesses[name = $thisCJPs/own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value]"/>
		
		<!-- App Provider Roles -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"valueStages": [<xsl:apply-templates mode="getValueStageJSON" select="$thisValueStages"><xsl:sort select="own_slot_value[slot_reference = 'vsg_index']/value"/></xsl:apply-templates>],
			"physProcessIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysProcs"/>],
			"appProRoleIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhyProcAppProRoles"/>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Value Stages  -->
	<xsl:template match="node()" mode="getValueStageJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_value_stages']/value = $this/name]"/>
		
		<xsl:variable name="vsgLabel"><xsl:call-template name="RenderMultiLangCommentarySlot"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="slotName">vsg_label</xsl:with-param></xsl:call-template></xsl:variable>
		
		<!-- measures -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		<xsl:variable name="cxStyleClass" select="eas:getEnumerationScoreStyle($custExperienceScore)"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="displayString" select="$vsgLabel"/><xsl:with-param name="anchorClass">text-white</xsl:with-param></xsl:call-template>",
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"customerJourneyPhases": [],
			"emotionScore": <xsl:value-of select="$emotionScore"/>,
			"cxScore": <xsl:value-of select="$custExperienceScore"/>,
			"kpiScore": <xsl:value-of select="$kpiScore"/>,
			"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
			"cxStyleClass": "<xsl:value-of select="$cxStyleClass"/>",
			"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>",
			"styleClass": "<xsl:value-of select="$cxStyleClass"/>",
			"inScope": false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>


	<!-- Template for rendering the list of Customer Journey Phases  -->
	<xsl:template match="node()" mode="getCustomerJourneyPhaseJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Customer Journey -->
		<xsl:variable name="thisCustomerJourney" select="$allCustomerJourneys[own_slot_value[slot_reference = 'cj_phases']/value = $this/name]"/>
		
		<xsl:variable name="cjpLabel"><xsl:call-template name="RenderMultiLangCommentarySlot"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="slotName">cjp_label</xsl:with-param></xsl:call-template></xsl:variable>
		
		
		<!-- measures -->
		<xsl:variable name="thisCJPhase2EmotionRels" select="$allCJPhase2EmotionRels[own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_from_cust_journey_phase']/value = $this/name]"/>
		<xsl:variable name="thisCustomerEmotions" select="$allCustomerEmotions[name = $thisCJPhase2EmotionRels/own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_to_emotion']/value]"/>
		<xsl:variable name="thisCJPhase2ExperienceRel" select="$allCJPhase2ExperienceRels[own_slot_value[slot_reference = 'cust_journey_phase_to_experience_from_cust_journey_phase']/value = $this/name]"/>
		<xsl:variable name="thisCustomerExperience" select="$allCustomerExperiences[name = $thisCJPhase2ExperienceRel/own_slot_value[slot_reference = 'cust_journey_phase_to_experience_to_experience']/value]"/>
		<xsl:variable name="thisCJPerformanceMeasures" select="$allCJPerformanceMeasures[name = $this/own_slot_value[slot_reference = 'performance_measures']/value]"/>
		<xsl:variable name="thisCustomerSvcQualVals" select="$allCustomerSvcQualVals[name = $thisCJPerformanceMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value]"/>
		
		<!-- Scores -->
		<xsl:variable name="cxScore" select="number($thisCustomerExperience/own_slot_value[slot_reference = 'enumeration_score']/value)"/>
		<xsl:variable name="emotionScore" select="eas:getEnumerationScoreAverage($thisCustomerEmotions)"/>
		<xsl:variable name="kpiScore" select="eas:getServiceQualityScoreAverage($thisCustomerSvcQualVals)"/>
		
	
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="displayString" select="$cjpLabel"/></xsl:call-template>",
			"customerJourneyId": "<xsl:value-of select="eas:getSafeJSString($thisCustomerJourney/name)"/>",
			"cxScore": <xsl:value-of select="$cxScore"/>,
			"emotionScore": <xsl:value-of select="$emotionScore"/>,
			"kpiScore": <xsl:value-of select="$kpiScore"/>
		}<xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
	
	<!-- Template for rendering the list of Customer Journeys  -->
	<xsl:template match="node()" mode="getCustomerJourneyJSON">
		<xsl:variable name="this" select="current()"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
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
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
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
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisSupportedBusCaps" select="$allBusCapabilities[own_slot_value[slot_reference = 'bus_cap_supporting_app_caps']/value = current()/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"supportedBusCaps": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedBusCaps"/>]
		<xsl:call-template name="RenderGenericMetaProps"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderTechCapDetailsJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisSupportedAppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'app_cap_supporting_tech_caps']/value = current()/name]"/>
		<xsl:variable name="thisSupportedBusCaps" select="$allBusCapabilities[own_slot_value[slot_reference = 'bus_cap_supporting_app_caps']/value = $thisSupportedAppCaps/name]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"supportedAppCaps": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedAppCaps"/>],
		"supportedBusCaps": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedBusCaps"/>]
		<xsl:call-template name="RenderGenericMetaProps"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
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
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($techDomainName)"/>",
			"description": "<xsl:value-of select="eas:validJSONString($techDomainDescription)"/>",
			"link": "<xsl:value-of select="$techDomainLink"/>",
			"childTechCaps": [
				<xsl:apply-templates select="$childTechCaps" mode="RenderBasicInstanceJSON"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderBasicInstanceJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
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
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"label": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- START UTILITY TEMPLATES AND FUNCTIONS -->
	<!-- function to calculate the technical health score of a given Application -->
	<xsl:function name="eas:getAppTechHealthScore" as="xs:integer">
		<xsl:param name="theApp"/>
		
		<xsl:variable name="thisAppTechAssessment" select="$appTechAssessments[name = $theApp/own_slot_value[slot_reference='performance_measures']/value]"/>
		<xsl:variable name="thisAppTechAssessmentSQValues" select="$appTechAssessmentSQValues[name = $thisAppTechAssessment/own_slot_value[slot_reference='pm_performance_value']/value]"/>
		
		<xsl:variable name="scoreCount" select="count($thisAppTechAssessmentSQValues)"/>
		<xsl:choose>
			<xsl:when test="$scoreCount > 0">
				<xsl:variable name="thisAppScoreTotal" select="sum($thisAppTechAssessmentSQValues/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
				<xsl:choose>
					<xsl:when test="$thisAppScoreTotal > 0">
						<xsl:value-of select="round($thisAppScoreTotal div ($scoreCount * 5) * 100)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="-1"/>
					</xsl:otherwise>
				</xsl:choose>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="-1"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:function>
	
	
	<!-- function to calculate the average technical health score of a given list of Applications -->
	<xsl:function name="eas:getAppListTechHealthScore" as="xs:integer">
		<xsl:param name="theApps"/>
		

		<xsl:variable name="scoreCount" select="count($theApps)"/>
		<xsl:choose>
			<xsl:when test="$scoreCount > 0">
				<xsl:variable name="thisAppScoreTotal" select="sum(eas:getAppTechHealthScore($theApps))"/>
				<xsl:choose>
					<xsl:when test="$thisAppScoreTotal > 0">
						<xsl:value-of select="round($thisAppScoreTotal div $scoreCount)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="-1"/>
					</xsl:otherwise>
				</xsl:choose>	
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="-1"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:function>
	
	
	<!-- Function to calculate the average score for the given Enumerations -->
	<xsl:function name="eas:getEnumerationScoreAverage" as="xs:float">
		<xsl:param name="enumerations"/>
		
		<xsl:variable name="enumCount" select="count($enumerations)"/>
		<xsl:choose>
			<xsl:when test="$enumCount > 0">
				<xsl:variable name="scoreTotal" select="sum($enumerations/own_slot_value[slot_reference = 'enumeration_score']/value)"/>
				<xsl:choose>
					<xsl:when test="($scoreTotal != 0) and ($enumCount > 0)">
						<xsl:value-of select="$scoreTotal div $enumCount"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<!-- Function to calculate the average score for the given Service Quality Values -->
	<xsl:function name="eas:getServiceQualityScoreAverage" as="xs:float">
		<xsl:param name="serviceQualValues"/>
		
		<xsl:variable name="sqvCount" select="count($serviceQualValues)"/>
		<xsl:choose>
			<xsl:when test="$sqvCount > 0">
				<xsl:variable name="scoreTotal" select="sum($serviceQualValues/own_slot_value[slot_reference = 'service_quality_value_score']/value)"/>
				<xsl:choose>
					<xsl:when test="($scoreTotal != 0) and ($sqvCount > 0)">
						<xsl:value-of select="$scoreTotal div $sqvCount"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Function to calculate the average emotion score for the given Customer Journey Phases -->
	<xsl:function name="eas:getEmotionScoreAverage" as="xs:float">
		<xsl:param name="vsCustJourneyPhases"/>
		<xsl:param name="currentScoreTotal"/>
		<xsl:param name="scoreCount"/>
		
		<xsl:choose>
			<xsl:when test="count($vsCustJourneyPhases) > 0">
				<xsl:variable name="nextCustJourneyPhase" select="$vsCustJourneyPhases[1]"/>
				<xsl:variable name="cjPhase2EmotionRels" select="$allCJPhase2EmotionRels[own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_from_cust_journey_phase']/value = $nextCustJourneyPhase/name]"/>
				<xsl:variable name="cjPhaseCustomerEmotions" select="$allCustomerEmotions[name = $cjPhase2EmotionRels/own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_to_emotion']/value]"/>
				<xsl:variable name="score" select="eas:getEnumerationScoreAverage($cjPhaseCustomerEmotions)"/>
				<xsl:value-of select="eas:getEmotionScoreAverage(remove($vsCustJourneyPhases, 1), $currentScoreTotal + $score, $scoreCount + 1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="($currentScoreTotal != 0) and ($scoreCount > 0)">
						<xsl:value-of select="$currentScoreTotal div $scoreCount"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Function to calculate the average score for the given Enumerations -->
	<xsl:function name="eas:getCxRelationScoreAverage" as="xs:float">
		<xsl:param name="cxRels"/>
		<xsl:param name="cxTotal"/>
		<xsl:param name="cxRelCount"/>
		
		<xsl:variable name="relCount" select="count($cxRels)"/>
		<xsl:choose>
			<xsl:when test="$relCount > 0">
				<xsl:variable name="nextCxRel" select="$cxRels[1]"/>
				<xsl:variable name="nextCustomerExperience" select="$allCustomerExperiences[name = $nextCxRel/own_slot_value[slot_reference = 'cust_journey_phase_to_experience_to_experience']/value]"/>
				<xsl:variable name="nextCxScore" select="$nextCustomerExperience/own_slot_value[slot_reference = 'enumeration_score']/value"/>
				<xsl:value-of select="eas:getCxRelationScoreAverage(remove($cxRels, 1), $cxTotal + $nextCxScore, $cxRelCount + 1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="($cxTotal != 0) and ($cxRelCount > 0)">
						<xsl:value-of select="$cxTotal div $cxRelCount"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Function to calculate the average emotion score for the given Customer Journey Phases -->
	<xsl:function name="eas:getExperienceScoreAverage" as="xs:float">
		<xsl:param name="vsCustJourneyPhases"/>
		<xsl:param name="currentScoreTotal"/>
		<xsl:param name="scoreCount"/>
		
		<xsl:value-of select="0"/>
		<!--<xsl:choose>
			<xsl:when test="count($vsCustJourneyPhases) > 0">
				<xsl:variable name="nextCustJourneyPhase" select="$vsCustJourneyPhases[1]"/>
				<xsl:variable name="cjpPhase2ExperienceRels" select="$allCJPhase2ExperienceRels[own_slot_value[slot_reference = 'cust_journey_phase_to_experience_from_cust_journey_phase']/value = $nextCustJourneyPhase/name]"/>
				
				<xsl:variable name="score" select="eas:getCxRelationScoreAverage($cjpPhase2ExperienceRels, 0, 0)"/>
				<xsl:value-of select="eas:getExperienceScoreAverage(remove($vsCustJourneyPhases, 1), $currentScoreTotal + $score, $scoreCount + 1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="($currentScoreTotal != 0) and ($scoreCount > 0)">
						<xsl:value-of select="$currentScoreTotal div $scoreCount"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>-->
		
	</xsl:function>
	
	
	<!-- Function to calculate the average KPI score for the given Customer Journey Phases -->
	<xsl:function name="eas:getKPIScoreAverage" as="xs:float">
		<xsl:param name="vsCustJourneyPhases"/>
		<xsl:param name="currentScoreTotal"/>
		<xsl:param name="scoreCount"/>
		
		
		<xsl:value-of select="0"/>
		<!--<xsl:choose>
			<xsl:when test="count($vsCustJourneyPhases) > 0">
				<xsl:variable name="nextCustJourneyPhase" select="$vsCustJourneyPhases[1]"/>
				<xsl:variable name="cjpPerformanceMeasures" select="$allCJPerformanceMeasures[name = $nextCustJourneyPhase/own_slot_value[slot_reference = 'performance_measures']/value]"/>
				<xsl:variable name="cjpSvcQualVals" select="$allCustomerSvcQualVals[name = $cjpPerformanceMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value]"/>
				<xsl:variable name="kpiScore" select="eas:getServiceQualityScoreAverage($cjpSvcQualVals)"/>
				<xsl:value-of select="eas:getKPIScoreAverage(remove($vsCustJourneyPhases, 1), $currentScoreTotal + $kpiScore, $scoreCount + 1)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="($currentScoreTotal != 0) and ($scoreCount > 0)">
						<xsl:value-of select="$currentScoreTotal div $scoreCount"/>
					</xsl:when>
					<xsl:otherwise>-1</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>-->
		
	</xsl:function>
	
	<!-- Function to get the style for an enumeration score -->
	<xsl:function name="eas:getEnumerationScoreStyle">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt; $enumLowThreshold"><xsl:value-of select="$enumLowStyle"/></xsl:when>
			<xsl:when test="$score &lt; $enumNeutralThreshold"><xsl:value-of select="$enumNeutralStyle"/></xsl:when>
			<xsl:when test="$score &lt; $enumMediumThreshold"><xsl:value-of select="$enumMediumStyle"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$enumHighStyle"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<!-- Function to get the style for a service quality value score -->
	<xsl:function name="eas:getSQVScoreStyle">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt; 0"><xsl:value-of select="$noHeatmapStyle"/></xsl:when>
			<xsl:when test="$score &lt; $kpiLowThreshold"><xsl:value-of select="$kpiLowStyle"/></xsl:when>
			<xsl:when test="$score &lt; $kpiNeutralThreshold"><xsl:value-of select="$kpiNeutralStyle"/></xsl:when>
			<xsl:when test="$score &lt; $kpiMediumThreshold"><xsl:value-of select="$kpiMediumStyle"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$kpiHighStyle"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Function to get the icon for an emotion score -->
	<xsl:function name="eas:getEmotionScoreIcon">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt; $enumLowThreshold"><xsl:value-of select="$negativeEmoIcon"/></xsl:when>
			<xsl:when test="$score &lt; $enumNeutralThreshold"><xsl:value-of select="$neutralEmoIcon"/></xsl:when>
			<xsl:when test="$score &lt; $enumMediumThreshold"><xsl:value-of select="$positiveEmoIcon"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$positiveEmoIcon"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Function to get the icon for an emotion score -->
	<xsl:function name="eas:getCXScoreStyle">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt; $enumLowThreshold">negative</xsl:when>
			<xsl:when test="$score &lt; $enumNeutralThreshold">neutral</xsl:when>
			<xsl:when test="$score &lt; $enumMediumThreshold">neutral</xsl:when>
			<xsl:otherwise>positive</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Function to get the emoji image for an emotion score -->
	<xsl:function name="eas:getEmotionScoreStyle">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt; $emotionVeryLowThreshold">negative</xsl:when>
			<xsl:when test="$score &lt; $emotionLowThreshold">quiteNegative</xsl:when>
			<xsl:when test="$score &lt; $emotionNeutralThreshold">neutral</xsl:when>
			<xsl:when test="$score &lt; $emotionHighThreshold">quitePositive</xsl:when>
			<xsl:otherwise>positive</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Function to get the style for an application's technical health score -->
	<xsl:function name="eas:getAppTechHealthStyle">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt;= 0"><xsl:value-of select="$noHeatmapStyle"/></xsl:when>
			<xsl:when test="$score &lt; $techHealthLowThreshold"><xsl:value-of select="$kpiLowStyle"/></xsl:when>
			<xsl:when test="$score &lt; $techHealthNeutralThreshold"><xsl:value-of select="$kpiNeutralStyle"/></xsl:when>
			<xsl:when test="$score &lt; $techHealthMediumThreshold"><xsl:value-of select="$kpiMediumStyle"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$kpiHighStyle"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<xsl:template name="RenderGenericMetaProps">
		<xsl:param name="theInstance"/>
		
		,"meta": {
		"anchorClass": "<xsl:value-of select="$theInstance/type"/>"
		}
	</xsl:template>
	
	<!-- END UTILITY TEMPLATES AND FUNCTIONS -->

</xsl:stylesheet>
