<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<!--
		* Copyright © 2008-2023 Enterprise Architecture Solutions Limited.
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
	<!-- START VIEW SPECIFIC VARIABLES -->
	<!-- Goals and Objectives -->
	<xsl:variable name="stratGoalTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>
	<xsl:variable name="objectiveTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="allBusinessGoalsOld" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $stratGoalTaxTerm/name]"/>
	<xsl:variable name="allBusinessGoalsNew" select="/node()/simple_instance[type = 'Business_Goal']"/>
	<xsl:variable name="allBusinessGoals" select="$allBusinessGoalsNew union $allBusinessGoalsOld"/>
	<xsl:variable name="allBusinessObjectives" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $objectiveTaxTerm/name]"/>
	
	<!-- Business Capabilities, Processes and Organisations -->
	<xsl:key name="allBusCapabilities" match="/node()/simple_instance[type = 'Business_Capability']" use="type"/>
	<xsl:key name="allBusCapabilitiesname" match="/node()/simple_instance[type = 'Business_Capability']" use="name"/>
	<xsl:key name="allBusProcesses" match="/node()/simple_instance[type = 'Business_Process']" use="own_slot_value[slot_reference = 'realises_business_capability']/value"/>
	<xsl:key name="allBusProcessesname" match="/node()/simple_instance[type = 'Business_Process']" use="name"/>
	<xsl:key name="allLabel" match="/node()/simple_instance[type = 'Label']" use="name"/>
	<xsl:key name="allPhysicalProcesses" match="/node()/simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/> 
	<xsl:key name="allPhysicalProcessesPerf" match="/node()/simple_instance[type = 'Physical_Process']" use="name"/> 
	
	<xsl:key name="allPhysicalProcessesA2R" match="/node()/simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'process_performed_by_actor_role']/value"/> 
	
	<xsl:key name="allPhysicalProcessesname" match="/node()/simple_instance[type = 'Physical_Process']" use="name"/> 
  
	<xsl:variable name="allBusCapabilities" select="key('allBusCapabilities', 'Business_Capability')"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Root Business Capability')]"/>
	<xsl:variable name="rootBusCap" select="key('allBusCapabilitiesname', $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value)"/>
	<xsl:variable name="L0Caps" select="key('allBusCapabilitiesname', $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value)"/>
	<xsl:variable name="diffLevelTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Business Differentiation Level')]"/>
	<xsl:variable name="differentiator" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $diffLevelTaxonomy/name) and (own_slot_value[slot_reference = 'name']/value = 'Differentiator')]"/>

	<xsl:key name="allOrgs" match="/node()/simple_instance[type = 'Group_Actor']" use="type"/> 
	<xsl:key name="allOrgsname" match="/node()/simple_instance[type = 'Group_Actor']" use="name"/> 
	<xsl:key name="allA2Rsname" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/> 
 
	<xsl:variable name="allBusinessProcess" select="key('allBusProcesses', $allBusCapabilities/name)"/>
	<xsl:variable name="allPhysicalProcesses" select="key('allPhysicalProcesses', $allBusinessProcess/name)"/>
	<xsl:variable name="allDirectOrganisations" select="key('allOrgsname', $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
	<xsl:variable name="allOrg2RoleRelations" select="key('allA2Rsname', $allPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
	<xsl:variable name="allIndirectOrganisations" select="key('allOrgsname', $allOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
	<xsl:variable name="allOrganisations" select="$allDirectOrganisations union $allIndirectOrganisations"/>
	
	<!-- Applications -->
	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:key name="allAppProviderRolesname" match="/node()/simple_instance[type = 'Application_Provider_Role']" use="name"/>
	<xsl:key name="allApps" match="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]" use="name"/>
	<xsl:key name="allServices" match="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')]" use="name"/>

	<xsl:key name="allPhyProc2AppProRoleRelations" match="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/>
	<xsl:key name="allPhyProc2AppProRoleRelationsViaRol" match="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
	<xsl:key name="allPhyProc2AppProRoleRelationsProc" match="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/>
	<xsl:variable name="allPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsProc', $allPhysicalProcesses/name)"/>
	<xsl:variable name="allPhyProcAppProRoles" select="key('allAppProviderRolesname', $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
	<xsl:variable name="allPhyProcDirectApps" select="key('allApps',$allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value)"/>
	<xsl:variable name="allPhyProcIndirectApps" select="key('allApps', $allPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
	<xsl:variable name="allApplications" select="$allPhyProcDirectApps union $allPhyProcIndirectApps"/>
	<xsl:key name="allApplicationsname" match="$allApplications" use="name"/>
	<xsl:variable name="allAppServices" select="key('allServices', $allAppProviderRoles/own_slot_value[slot_reference = 'implementing_application_service']/value)"/>
	
 
	<!-- App Technical Service Qualities -->
	<xsl:key name="allPerfMeasures" match="/node()/simple_instance[(supertype ='Performance_Measure')]" use="name"/>
	<!--<xsl:variable name="appTechAssessments" select="/node()/simple_instance[(type = 'Technology_Performance_Measure') and (name = $allApplications/own_slot_value[slot_reference='performance_measures']/value)]"/> -->
	<xsl:variable name="appTechAssessments" select="key('allPerfMeasures', $allApplications/own_slot_value[slot_reference='performance_measures']/value)[type = 'Technology_Performance_Measure']"/>
	<xsl:key name="allSQVs" match="/node()/simple_instance[(supertype ='Service_Quality_Value')]" use="name"/>
	<xsl:key name="allSQTypes" match="/node()/simple_instance[(supertype ='Service_Quality')]" use="type"/>
	<xsl:key name="allSQs" match="/node()/simple_instance[(supertype ='Service_Quality')]" use="name"/>
	<xsl:variable name="appTechAssessmentSQValues" select="key('allSQVs', $appTechAssessments/own_slot_value[slot_reference='pm_performance_value']/value)"/>
	<xsl:key name="allUoMs" match="/node()/simple_instance[(type ='Unit_Of_Measure')]" use="name"/>
	<xsl:key name="allUoMType" match="/node()/simple_instance[(type ='Unit_Of_Measure')]" use="type"/>
	<!-- Customer Journeys -->
	<xsl:key name="allCustomerJourneyPhases" match="/node()/simple_instance[(type ='Customer_Journey_Phase')]" use="own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value"/>
	<xsl:variable name="allCustomerJourneyPhases" select="key('allCustomerJourneyPhases', $allPhysicalProcesses/name)"/>
	<xsl:key name="allCustomerJourneys" match="/node()/simple_instance[(type ='Customer_Journey')]" use="own_slot_value[slot_reference = 'cj_phases']/value"/>
	<xsl:variable name="allCustomerJourneys" select="key('allCustomerJourneys', $allCustomerJourneyPhases/name)"/>
	<xsl:key name="allCustomerJourneysEmotion" match="/node()/simple_instance[(type ='CUST_JOURNEY_PHASE_TO_EMOTION_RELATION')]" use="own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_from_cust_journey_phase']/value"/>
	<xsl:variable name="allCJPhase2EmotionRels" select="key('allCustomerJourneysEmotion', $allCustomerJourneyPhases/name)"/>
	<xsl:variable name="allCustomerEmotions" select="/node()/simple_instance[(type ='Customer_Emotion')][name = $allCJPhase2EmotionRels/own_slot_value[slot_reference = 'cust_journey_phase_to_emotion_to_emotion']/value]"/>
	<xsl:key name="allCJPhase2ExperienceRels" match="/node()/simple_instance[(type ='CUST_JOURNEY_PHASE_TO_EXPERIENCE_RELATION')]" use="own_slot_value[slot_reference = 'cust_journey_phase_to_experience_from_cust_journey_phase']/value"/>
	<xsl:variable name="allCJPhase2ExperienceRels" select="key('allCJPhase2ExperienceRels', $allCustomerJourneyPhases/name)"/>
	<xsl:variable name="allCustomerExperiences" select="/node()/simple_instance[(type ='Customer_Experience_Rating')][name = $allCJPhase2ExperienceRels/own_slot_value[slot_reference = 'cust_journey_phase_to_experience_to_experience']/value]"/>
	<xsl:variable name="allCJPerformanceMeasures" select="key('allPerfMeasures', $allCustomerJourneyPhases/own_slot_value[slot_reference = 'performance_measures']/value)"/> 
	<xsl:variable name="allCustomerSvcQualVals" select="key('allSQVs', $allCJPerformanceMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value)"/>
	<xsl:variable name="allCustomerSvcQuals" select="key('allSQs', $allCustomerSvcQualVals/own_slot_value[slot_reference = 'usage_of_service_quality']/value)"/>
	
	<!-- Value Streams -->
	<xsl:key name="allValueStages" match="/node()/simple_instance[type='Value_Stage']" use="type"/>
	<xsl:key name="allValueStreams" match="/node()/simple_instance[type='Value_Stream']" use="type"/>
	<xsl:key name="allValueStagesname" match="/node()/simple_instance[type='Value_Stage']" use="name"/>
	<xsl:key name="allValueStreamsname" match="/node()/simple_instance[type='Value_Stream']" use="name"/>
	<xsl:key name="allValueStreamsvs" match="/node()/simple_instance[type='Value_Stream']" use="own_slot_value[slot_reference = 'vs_value_stages']/value"/>
	<xsl:variable name="allValueStages" select="key('allValueStagesname', $allCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value)"/>
	<xsl:variable name="allValueStreams" select="key('allValueStreamsvs', $allValueStages/name)"/>
	
	<!-- Planning Action -->
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[(type = 'Planning_Action') and (count(own_slot_value[slot_reference = 'planning_action_classes']/value) > 0)]"/>
	
	<!-- value stream details-->
	<xsl:key name="allProductType" match="/node()/simple_instance[type = 'Product_Type']" use="type"/>
	<xsl:key name="allBusRoleType" match="/node()/simple_instance[type = 'Business_Role_Type']" use="type"/>
	<xsl:key name="allBusRole" match="/node()/simple_instance[supertype = 'Business_Role']" use="type"/>
	<xsl:key name="allBusRoleTypename" match="/node()/simple_instance[type = 'Business_Role_Type']" use="name"/>
	<xsl:key name="allBusRolename" match="/node()/simple_instance[type = ('Individual_Business_Role','Group_Business_Role')]" use="name"/>
	<xsl:key name="allBusCondition" match="/node()/simple_instance[type = 'Business_Condition']" use="type"/>
	<xsl:key name="allBusEvent" match="/node()/simple_instance[type = 'Business_Event']" use="type"/>
	<xsl:key name="allBusConditionname" match="/node()/simple_instance[type = 'Business_Condition']" use="name"/>
	<xsl:key name="allBusEventname" match="/node()/simple_instance[type = 'Business_Event']" use="name"/>
	
	<xsl:key name="allCustEmotiontoStage" match="/node()/simple_instance[type = 'VALUE_STAGE_TO_EMOTION_RELATION']" use="name"/>
	<xsl:key name="allCustEmotions" match="/node()/simple_instance[type = 'Customer_Emotion']" use="name"/>
	<xsl:key name="allCustEmotionstype" match="/node()/simple_instance[type = 'Customer_Emotion']" use="type"/>
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
	
	<!-- percentage thresholds for application technical health -->
	<xsl:variable name="techHealthLowThreshold" select="30"/>
	<xsl:variable name="techHealthNeutralThreshold" select="60"/>
	<xsl:variable name="techHealthMediumThreshold" select="80"/>
	
	<xsl:variable name="noHeatmapStyle" select="'noHeatmapColour'"/>

    <xsl:key name="physProcKey" match="/node()/simple_instance[type='Physical_Process']" use="name"/>
	<xsl:variable name="custEmotions" select="/node()/simple_instance[type='Customer_Emotion']"/>
	<xsl:variable name="custEx" select="/node()/simple_instance[type='Customer_Experience_Rating']"/>
	<xsl:variable name="custServiceQual" select="/node()/simple_instance[type='Business_Service_Quality'][contains(own_slot_value[slot_reference='name']/value,'Customer ')]"/>
 
	<xsl:variable name="custServiceQualVal" select="/node()/simple_instance[type='Business_Service_Quality_Value'][own_slot_value[slot_reference='usage_of_service_quality']/value=$custServiceQual/name]"/>
	<xsl:key name="custJourneyKey" match="/node()/simple_instance[type='Customer_Journey']" use="type"/>
	<xsl:variable name="custJourney" select="key('custJourneyKey', 'Customer_Journey')"/>
	<xsl:key name="custJourneyName" match="$custJourney" use="name"/>
	<xsl:key name="custJourneyPhaseKey" match="/node()/simple_instance[type='Customer_Journey_Phase']" use="type"/>
	<xsl:variable name="custJourneyPhase" select="key('custJourneyPhaseKey','Customer_Journey_Phase')"/>
	<xsl:key name="custJourToExKey" match="/node()/simple_instance[type='CUST_JOURNEY_PHASE_TO_EXPERIENCE_RELATION']" use="name"/>
 
	<xsl:key name="custJourToEmKey" match="/node()/simple_instance[type='CUST_JOURNEY_PHASE_TO_EMOTION_RELATION']" use="name"/>
	<xsl:key name="perfMeasureKey" match="/node()/simple_instance[type='Business_Performance_Measure']" use="name"/>
	<xsl:key name="bsqvKey" match="/node()/simple_instance[type='Business_Service_Quality_Value']" use="name"/>
	<xsl:variable name="language" select="/node()/simple_instance[type = 'Language']"/>  
	<xsl:variable name="synonym" select="/node()/simple_instance[type = 'Synonym'][name=$allStatus/own_slot_value[slot_reference='synonyms']/value]"/>  
	<xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"/>  
	<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"/>  
	<xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>  
   <xsl:variable name="techdelivery" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/> 
	<xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="techlifecycle" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	<xsl:variable name="projlifecycle" select="/node()/simple_instance[type = 'Project_Lifecycle_Status']"/>
   <xsl:variable name="stdStrengths" select="/node()/simple_instance[type = 'Standard_Strength']"/>
   <xsl:variable name="products" select="/node()/simple_instance[type='Product']"/>
	<xsl:variable name="allStatus" select="$codebase union $delivery union $lifecycle union $techlifecycle union $stdStrengths"/>
	<xsl:template match="knowledge_base">
		{  
			"planningActions": [
			<xsl:apply-templates mode="getPlanningActionsJSON" select="$allPlanningActions"><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:apply-templates>
			],
			"goals": [
			<xsl:apply-templates mode="getBusinssGoalsJSON" select="$allBusinessGoals"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"objectives": [
			<xsl:apply-templates mode="getBusinssObjectivesJSON" select="$allBusinessObjectives"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			], 
			"valueStreams": [
			<xsl:apply-templates mode="getValueStreamJSON" select="key('allValueStreams', 'Value_Stream')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			"valueStages": [
			<xsl:apply-templates mode="getValueStageJSON" select="key('allValueStages', 'Value_Stage')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
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
			],
			"productTypes":[<xsl:apply-templates mode="simpleList" select="key('allProductType', 'Product_Type')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"businessRoleTypes":[<xsl:apply-templates mode="simpleList" select="key('allBusRoleType', 'Business_Role_Type')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"orgBusinessRole":[<xsl:apply-templates mode="simpleList" select="key('allBusRole', 'Group_Business_Role')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"individualBusinessRoles":[<xsl:apply-templates mode="simpleList" select="key('allBusRole', 'Individual_Business_Role')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"businessConditions":[<xsl:apply-templates mode="simpleList" select="key('allBusCondition', 'Business_Condition')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"businessEvents":[<xsl:apply-templates mode="simpleList" select="key('allBusEvent', 'Business_Event')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"unitsofMeasure":[<xsl:apply-templates mode="simpleEnumList" select="key('allUoMType', 'Unit_Of_Measure')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>], 
			"customerEmotions":[<xsl:apply-templates mode="simpleEnumList" select="key('allCustEmotionstype', 'Customer_Emotion')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>],
			"custEx":[<xsl:apply-templates select="$custEx" mode="standard"/>],
			"custEmotions":[<xsl:apply-templates select="$custEmotions" mode="standard"/>],
			"custServiceQual":[<xsl:apply-templates select="$custServiceQual" mode="dataLookup"/>],
			"custServiceQualVal":[<xsl:apply-templates select="$custServiceQualVal" mode="valLookup"/>],
			"custJourney":[<xsl:apply-templates select="$custJourney" mode="custJourney"/>],
			"custJourneyPhase":[<xsl:apply-templates select="$custJourneyPhase" mode="custJourneyPhase"/>],
			"busServiceQuals":[<xsl:apply-templates mode="simpleList" select="key('allSQTypes', 'Business_Service_Quality')"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>]
		}
	</xsl:template>
	
	<!-- Template for rendering the list of Planning Actions  -->
	<xsl:template match="node()" mode="getPlanningActionsJSON">
		<xsl:variable name="this" select="current()"/>
		{
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Business Goals  -->
	<xsl:template match="node()" mode="getBusinssGoalsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'objective_supports_objective']/value = $this/name]"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"objectiveIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessObjectives"/>],
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
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"targetDate": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>",
			"goalIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisSupportedBusinessGoals"/>],
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
		<xsl:variable name="thisBusinessProcess" select="key('allBusProcesses', $thisBusCapDescendants/name)"/>
		<xsl:variable name="thisPhysicalProcesses" select="key('allPhysicalProcesses', $thisBusinessProcess/name)"/>

		<!--<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>-->
		
		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsProc', $thisPhysicalProcesses/name)"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="key('allAppProviderRolesname',  $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
		<xsl:variable name="thisPhyProcDirectApps" select="key('allApplicationsname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value)"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="key('allApplicationsname',  $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!--<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-->
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="key('allCustomerJourneyPhases', $thisPhysicalProcesses/name)"/>
		<xsl:variable name="thisCustomerJourneys" select="key('allCustomerJourneys', $thisCustomerJourneyPhases/name)"/>
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="key('allValueStagesname', $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value)"/>
		<xsl:variable name="thisValueStreams" select="key('allValueStreamsvs', $thisValueStages/name)"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"ref": "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"type": {
				"list": "busCaps",
				"colour": "black",
				"label": "Business Capability",
				"defaultButton": "View",
				"isLink": false,
				"essClass": "Business_Capability"
			},
			"goalIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessGoals"/>],
			"objectiveIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessObjectives"/>],
			"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysicalProcesses"/>],
			"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			"applicationIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisApplications"/>],
			"customerJourneyIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneys"/>],
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"valueStreamIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStreams"/>],
			"valueStageIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStages"/>],
			"overallScores": <xsl:choose>
				<xsl:when test="count($thisCustomerJourneyPhases) > 0">
					{
						"cxScore": <xsl:value-of select="$custExperienceScore"/>,
						"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
						"cxStyle": <xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>,
						"emotionScore": <xsl:value-of select="$emotionScore"/>,
						"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
						"emotionStyle": <xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>,
						"kpiScore": <xsl:value-of select="$kpiScore"/>,
						"kpiPercent": <xsl:value-of select="round($kpiScore * 10)"/>,
						"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
					}
				</xsl:when>
				<xsl:otherwise>
					{
						"cxScore": 0,
						"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
						"cxStyle": {
							"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
							"icon": "<xsl:value-of select="$noCxIcon"/>"
						},
						"emotionScore": 0,
						"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
						"emotionStyle": {
							"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
							"emoji": "<xsl:value-of select="$noEmoji"/>"
						},
						"kpiScore": -1,
						"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
					}
				</xsl:otherwise>
			</xsl:choose>,
			"heatmapScores": [
				<xsl:apply-templates mode="RenderValueStreamAverageScores" select="key('allValueStreams', 'Value_Stream')">
					<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
					<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
				</xsl:apply-templates>
			],
			"editorId": "busCapModal",
			"inScope": false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Business Processes  -->
	<xsl:template match="node()" mode="getBusinssProcessJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<xsl:variable name="thisBusinessCapabilities" select="key('allBusCapabilitiesname', $this/own_slot_value[slot_reference = 'realises_business_capability']/value)"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		<!-- Physical Processes -->
		<xsl:variable name="thisPhysicalProcesses" select="key('allPhysicalProcesses', $this/name)"/>
		<!--<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>-->
		
		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsProc', $thisPhysicalProcesses/name)"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="key('allAppProviderRolesname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
		<xsl:variable name="thisPhyProcDirectApps" select="key('allApplicationsname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value)"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="key('allApplicationsname',  $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!--<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-->
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="key('allCustomerJourneys', $thisCustomerJourneyPhases/name)"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="key('allValueStagesname', $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value)"/>
		<xsl:variable name="thisValueStreams" select="key('allValueStreamsvs', $thisValueStages/name)"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"index": <xsl:value-of select="position() - 1"/>,
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
        <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"type": {
			"list": "busProcesses",
			"colour": "#5cb85c",
			"label": "Business Process",
			"defaultButton": "No Change",
			"isLink": false,
			"essClass": "Business_Process"
		},
		"busCapIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessCapabilities"/>],
		"goalIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessGoals"/>],
		"objectiveIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessObjectives"/>],
		"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysicalProcesses"/>],
		"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
		"applicationIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisApplications"/>],
		"customerJourneyIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneys"/>],
		"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
		"valueStreamIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStreams"/>],
		"valueStageIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStages"/>],
		"overallScores": <xsl:choose>
			<xsl:when test="count($thisCustomerJourneyPhases) > 0">
				{
				"cxScore": <xsl:value-of select="$custExperienceScore"/>,
				"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
				"cxStyle": <xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>,
				"emotionScore": <xsl:value-of select="$emotionScore"/>,
				"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
				"emotionStyle": <xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>,
				"kpiScore": <xsl:value-of select="$kpiScore"/>,
				"kpiPercent": <xsl:value-of select="round($kpiScore * 10)"/>,
				"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
				}
			</xsl:when>
			<xsl:otherwise>
				{
				"cxScore": 0,
				"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
				"cxStyle": {
					"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
					"icon": "<xsl:value-of select="$noCxIcon"/>"
				},
				"emotionScore": 0,
				"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
				"emotionStyle": {
					"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
					"emoji": "<xsl:value-of select="$noEmoji"/>"
				},
				"kpiScore": -1,
				"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
				}
			</xsl:otherwise>
		</xsl:choose>,
		"heatmapScores": [
		<xsl:apply-templates mode="RenderValueStreamAverageScores" select="key('allValueStreams', 'Value_Stream')">
			<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
			<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
		</xsl:apply-templates>
		],
		"editorId": "busProcessModal",
		"inScope": false,
		"planningActionIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPlanningActions"/>],
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
					"id": "<xsl:value-of select="$this/name"/>",
					"cxScore": <xsl:value-of select="$custExperienceScore"/>,
					"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
					"cxStyle": <xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>,
					"emotionScore": <xsl:value-of select="$emotionScore"/>,
					"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
					"emotionStyle": <xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>,
					"kpiScore": <xsl:value-of select="$kpiScore"/>,
					"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
				}<xsl:if test="not(position()=last())">,
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				{
					"id": "<xsl:value-of select="$this/name"/>",
					"cxScore": 0,
					"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
					"cxStyle": {
						"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
						"icon": "<xsl:value-of select="$noCxIcon"/>"
					},
					"emotionScore": 0,
					"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
					"emotionStyle": {
						"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
						"emoji": "<xsl:value-of select="$noEmoji"/>"
					},
					"kpiScore": -1,
					"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
				}<xsl:if test="not(position()=last())">,
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- Templates for rendering the Business Reference Model  -->
	<xsl:template name="RenderBCMJSON">
		<xsl:variable name="rootBusCapName" select="$rootBusCap/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'l0BusCapName': string(translate(translate($rootBusCap/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')) 
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
			"l0BusCapId": "<xsl:value-of select="$rootBusCap/name"/>", 
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
		<xsl:variable name="L1Caps" select="key('allBusCapabilitiesname', current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value)"/>
		
		{
			"busCapId": "<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'busCapName': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')) 
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
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
			"busCapId": "<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'busCapName': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')) 
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
			"busCapLink": "<xsl:value-of select="$currentBusCapLink"/>",
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
		<xsl:variable name="thisBusinessProcess" select="key('allBusProcessesname', $this/own_slot_value[slot_reference = 'implements_business_process']/value)"/>
		
		<!-- Business Capability -->
		<xsl:variable name="thisBusinessCap" select="key('allBusCapabilitiesname', $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value)"/>
		
		<!-- Organisation -->
		<xsl:variable name="thisDirectOrganisation" select="$allDirectOrganisations[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelation" select="$allOrg2RoleRelations[name = $this/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisation" select="$allIndirectOrganisations[name = $thisOrg2RoleRelation/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisation" select="$thisDirectOrganisation union $thisIndirectOrganisation"/>
		
		<!-- Supporting Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsProc', $this/name)"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="key('allAppProviderRolesname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
		<xsl:variable name="thisPhyProcDirectApps" select="key('allApplicationsname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value)"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="key('allApplicationsname', $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $this/name]"/>

		<!-- measures -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		

		{
			"id": "<xsl:value-of select="$this/name"/>",
			"type": {
				"list": "physProcesses",
				"colour": "#5cb85c",
				"label": "Physical Process",
				"defaultButton": "No Change",
				"isLink": true,
				"essClass": "Physical_Process"
			},
			"busCapId": "<xsl:value-of select="$thisBusinessCap[1]/name"/>",
			"busCapLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisBusinessCap[1]"/></xsl:call-template>",
			"busProcessId": "<xsl:value-of select="$thisBusinessProcess/name"/>",
			"busProcessRef": "<xsl:if test="count($thisBusinessProcess) > 0">busProc<xsl:value-of select="index-of($allBusinessProcess, $thisBusinessProcess)"/></xsl:if>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'busProcessName': string(translate(translate($thisBusinessProcess/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'busProcessDescription': string(translate(translate($thisBusinessProcess/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
				'orgName': string(translate(translate($thisOrganisation/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'orgDescription': string(translate(translate($thisOrganisation/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"busProcessLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisBusinessProcess"/></xsl:call-template>",
			"orgId": "<xsl:value-of select="$thisOrganisation/name"/>",
			"orgRef": "<xsl:if test="count($thisOrganisation) > 0">org<xsl:value-of select="index-of($allOrganisations, $thisOrganisation)"/></xsl:if>",
			"orgLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisOrganisation"/></xsl:call-template>",
			"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			"applicationIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisApplications"/>],
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"customerJourneyPhases": [],
			"planningActionIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPlanningActions"/>],
			"planningActions": [],
			"planningAction": null,
			"editorId": "physProcModal",
			"emotionScore": <xsl:value-of select="$emotionScore"/>,
			"cxScore": <xsl:value-of select="$custExperienceScore"/>,
			"kpiScore": <xsl:value-of select="$kpiScore"/>,
			"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
			"emotionIcon": "<xsl:value-of select="eas:getEmotionScoreIcon($emotionScore)"/>",
			"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
			"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Organisations  -->
	<xsl:template match="node()" mode="getOrganisationJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<!-- Physical Processes -->
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $this/name]"/>
		<!-- fix here #### map to role -->
		<xsl:variable name="thisInDirectPhysProcsa2r" select="key('allA2Rsname', $thisOrg2RoleRelations/name)"/>
		<xsl:variable name="thisInDirectPhysProcs" select="key('allPhysicalProcessesPerf', $thisInDirectPhysProcsa2r/own_slot_value[slot_reference = 'performs_physical_processes']/value)"/>
		<xsl:variable name="thisDirectPhysProcs" select="key('allPhysicalProcessesA2R', $this/name)"/>
		<xsl:variable name="allthisPhysProcs" select="$thisInDirectPhysProcs union $thisDirectPhysProcs"/>
		<xsl:variable name="thisPhysProcs" select="$allthisPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="key('allBusProcessesname', $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value)"/>
		
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="key('allBusCapabilitiesname', $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value)"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-- Applications -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsProc', $thisPhysProcs/name)"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="key('allAppProviderRolesname',$thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
		<xsl:variable name="thisPhyProcDirectApps" select="key('allApplicationsname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value)"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="key('allApplicationsname', $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps except $thisPhyProcIndirectApps"/>
		<!--<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-->
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="key('allCustomerJourneys', $thisCustomerJourneyPhases/name)"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="key('allValueStagesname', $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value)"/>
		<xsl:variable name="thisValueStreams" select="key('allValueStreamsvs', $thisValueStages/name)"/>  
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
 
		{ 
			"id": "<xsl:value-of select="$this/name"/>",
			"index": <xsl:value-of select="position() - 1"/>,
			"type": {
				"list": "organisations",
				"colour": "#9467bd",
				"label": "Organisation",
				"defaultButton": "No Change",
				"isLink": false,
				"essClass": "Group_Actor"
			},
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"objectiveIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessObjectives"/>],
			"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysProcs"/>],
			"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			"applicationIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisApplications"/>],
			"customerJourneyIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneys"/>],
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"valueStreamIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStreams"/>],
			"valueStageIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStages"/>],
			"overallScores": <xsl:choose>
				<xsl:when test="count($thisCustomerJourneyPhases) > 0">
					{
					"cxScore": <xsl:value-of select="$custExperienceScore"/>,
					"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
					"cxStyle": <xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>,
					"emotionScore": <xsl:value-of select="$emotionScore"/>,
					"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
					"emotionStyle": <xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>,
					"kpiScore": <xsl:value-of select="$kpiScore"/>,
					"kpiPercent": <xsl:value-of select="round($kpiScore * 10)"/>,
					"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
					}
				</xsl:when>
				<xsl:otherwise>
					{
					"cxScore": 0,
					"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
					"cxStyle": {
						"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
						"icon": "<xsl:value-of select="$noCxIcon"/>"
					},
					"emotionScore": 0,
					"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
					"emotionStyle": {
						"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
						"emoji": "<xsl:value-of select="$noEmoji"/>"
					},
					"kpiScore": -1,
					"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
					}
				</xsl:otherwise>
			</xsl:choose>,
			"heatmapScores": [
			<xsl:apply-templates mode="RenderValueStreamAverageScores" select="key('allValueStreams', 'Value_Stream')">
				<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
				<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
			</xsl:apply-templates>
			],
			"editorId": "orgModal",
			"inScope": false,
			"planningActionIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPlanningActions"/>],
			"planningActions": null,
			"planningAction": null,
			"planningNotes": "",
			"hasPlan": false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of App Services  -->
	<xsl:template match="node()" mode="getAppServiceJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Relevant Planning Actions -->
		<xsl:variable name="thisPlanningActions" select="$allPlanningActions[own_slot_value[slot_reference = 'planning_action_classes']/value = $this/(supertype, type)]"/>
		
		<!-- Application Provider Roles -->
		<!--<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $this/name]"/>-->
		<xsl:variable name="thisAppProRoles" select="key('allAppProviderRolesname',  $this/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value)"/>
		
		<xsl:variable name="thisApps" select="key('allApplicationsname', $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
		
		<!-- technical health -->
		<xsl:variable name="thisTechHealthScore" select="eas:getAppListTechHealthScore($thisApps)"/>
		<xsl:variable name="thisTechHealthStyle" select="eas:getAppTechHealthStyle($thisTechHealthScore)"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsViaRol', $thisAppProRoles/name)"/>
		<xsl:variable name="thisPhysProcs" select="key('allPhysicalProcessesname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value)"/>
		
		<!-- Business Process -->
		<xsl:variable name="thisBusinessProcess" select="key('allBusProcessesname', $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value)"/>
		
		<!-- Business Capabilities -->
		<xsl:variable name="thisBusinessCapabilities" select="key('allBusCapabilitiesname', $thisBusinessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value)"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusinessCapabilities, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-- Customer Journeys -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisCustomerJourneys" select="key('allCustomerJourneys', $thisCustomerJourneyPhases/name)"/>
		
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="key('allValueStagesname', $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value)"/>
		<xsl:variable name="thisValueStreams" select="key('allValueStreamsvs', $thisValueStages/name)"/>
		
		
		<!-- overall scores -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"index": <xsl:value-of select="position() - 1"/>,
		"type": {
			"list": "appServices",
			"colour": "#4ab1eb",
			"label": "Application Service",
			"defaultButton": "No Change",
			"isLink": false,
			"essClass": "Application_Service"
		},
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
        <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"objectiveIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessObjectives"/>],
		"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysProcs"/>],
		"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisAppProRoles"/>],
		"customerJourneyIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneys"/>],
		"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
		"valueStreamIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStreams"/>],
		"valueStageIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStages"/>],
		"overallScores": <xsl:choose>
			<xsl:when test="count($thisCustomerJourneyPhases) > 0">
				{
				"cxScore": <xsl:value-of select="$custExperienceScore"/>,
				"cxStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($custExperienceScore)"/>",
				"cxStyle": <xsl:value-of select="eas:getCXScoreStyle($custExperienceScore)"/>,
				"emotionScore": <xsl:value-of select="$emotionScore"/>,
				"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
				"emotionStyle": <xsl:value-of select="eas:getEmotionScoreStyle($emotionScore)"/>,
				"kpiScore": <xsl:value-of select="$kpiScore"/>,
				"kpiPercent": <xsl:value-of select="round($kpiScore * 10)"/>,
				"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>"
				}
			</xsl:when>
			<xsl:otherwise>
				{
				"cxScore": 0,
				"cxStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
				"cxStyle": {
					"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
					"icon": "<xsl:value-of select="$noCxIcon"/>"
				},
				"emotionScore": 0,
				"emotionStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>",
				"emotionStyle": {
					"label": "<xsl:value-of select="eas:i18n('Undefined')"/>",
					"emoji": "<xsl:value-of select="$noEmoji"/>"
				},
				"kpiScore": -1,
				"kpiStyleClass": "<xsl:value-of select="$noHeatmapStyle"/>"
				}
			</xsl:otherwise>
		</xsl:choose>,
		"heatmapScores": [
		<xsl:apply-templates mode="RenderValueStreamAverageScores" select="key('allValueStreams', 'Value_Stream')">
			<xsl:with-param name="inScopeValueStages" select="$thisValueStages"/>
			<xsl:with-param name="inScopeCJPs" select="$thisCustomerJourneyPhases"/>
		</xsl:apply-templates>
		],
		"techHealthScore": <xsl:value-of select="$thisTechHealthScore"/>,
		"techHealthStyle": "<xsl:value-of select="$thisTechHealthStyle"/>",
		"editorId": "appServiceModal",
		"inScope": false,
		"planningActionIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPlanningActions"/>],
		"planningActions": null,
		"planningAction": null,
		"planningNotes": "",
		"hasPlan": false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Application Provider Roles  -->
	<xsl:template match="node()" mode="getAppProviderRoleJSON">
		<xsl:variable name="this" select="current()"/>
		
		
		<!-- Application -->
		<xsl:variable name="thisApplication" select="key('allApplicationsname', $this/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
		
		<!-- Application Service -->
		<xsl:variable name="thisAppService" select="key('allServices', $this/own_slot_value[slot_reference = 'implementing_application_service']/value)"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $this/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="key('allPhysicalProcessesname',  $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value)"/>
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"type": {
				"list": "appProviderRoles",
				"colour": "#4ab1eb",
				"label": "Application Function",
				"defaultButton": "No Change",
				"isLink": true,
				"essClass": "Application_Provider_Role"
			},
			"appId": "<xsl:value-of select="$thisApplication/name"/>",
			"appRef": "<xsl:if test="count($thisApplication) > 0">app<xsl:value-of select="index-of($allApplications, $thisApplication)"/></xsl:if>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'appName': string(translate(translate($thisApplication/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'appDescription': string(translate(translate($thisApplication/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
				'serviceName': string(translate(translate($thisAppService/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'serviceDescription': string(translate(translate($thisAppService/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
        	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"appLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/></xsl:call-template>",
			"serviceId": "<xsl:value-of select="$thisAppService/name"/>",
			"serviceRef": "<xsl:if test="count($thisAppService) > 0">appService<xsl:value-of select="index-of($allAppServices, $thisAppService)"/></xsl:if>",
			"serviceLink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisAppService"/></xsl:call-template>",
			"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysicalProcesses"/>],
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"customerJourneyPhases": [],
			"editorId": "appProRoleModal",
			"planningAction": null,
			"cxScore": 0,
			"kpiScore": 0
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
		<!--<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = $this/name]"/>-->
		<xsl:variable name="thisAppProRoles" select="key('allAppProviderRolesname',  $this/own_slot_value[slot_reference = 'provides_application_services']/value)"/>
		
		<!-- Supported Physical Processes -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = ('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($this, $thisAppProRoles)/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="key('allPhysicalProcessesname',  $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value)"/>
		
		<!-- objectives -->
		<xsl:variable name="thisBusinessProcesses" select="key('allBusProcessesname', $thisPhysicalProcesses/own_slot_value[slot_reference = 'implements_business_process']/value)"/> 
		<xsl:variable name="thisBusCaps" select="key('allBusCapabilitiesname', $thisBusinessProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value)"/>
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants($thisBusCaps, $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		
		<!-- Organisations -->
<!--
		<xsl:variable name="thisInDirectPhysProcsa2r" select="key('allA2Rsname', $thisOrg2RoleRelations/name)"/>
		<xsl:variable name="thisInDirectPhysProcs" select="key('allOrgsname', $thisInDirectPhysProcsa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>-->
 
		<xsl:variable name="thisDirectOrganisations" select="key('allOrgsname',  $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
		<xsl:variable name="thisOrg2RoleRelations" select="key('allA2Rsname',  $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
		<xsl:variable name="thisIndirectOrganisations" select="key('allOrgsname',  $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value = $thisPhysicalProcesses/name]"/>
		
		<!-- Value Streams -->
		<xsl:variable name="thisValueStages" select="key('allValueStagesname',  $thisCustomerJourneyPhases/own_slot_value[slot_reference = 'cjp_value_stages']/value)"/>
		<xsl:variable name="thisValueStreams" select="key('allValueStreamsvs', $thisValueStages/name)"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"type": {
					"list": "applications",
					"colour": "#337ab7",
					"label": "Application",
					"defaultButton": "No Change",
					"isLink": false,
					"essClass": "Composite_Application_Provider"
			},
			"index": <xsl:value-of select="position() - 1"/>,
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>", 
			"objectiveIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisBusinessObjectives"/>],
			"objectives": null,
			"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisAppProRoles"/>],
			"appProRoles": null,
			"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysicalProcesses"/>],
			"physProcesses": null,
			"organisationIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisOrganisations"/>],
			"organisations": null,
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"customerJourneyPhases": [],
			"valueStreamIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStreams"/>],
			"valueStreams": null,
			"valueStageIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisValueStages"/>],
			"editorId": "appModal",
			"planningActionIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPlanningActions"/>],
			"planningActions": null,
			"planningAction": null,
			"planningNotes": "",
			"hasPlan": false,
			"techHealthScore": <xsl:value-of select="$thisTechHealthScore"/>,
			"techHealthStyle": "<xsl:value-of select="$thisTechHealthStyle"/>",
			"cxScore": 0,
			"kpiScore": 0
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Value Streams  -->
	<xsl:template match="node()" mode="getValueStreamJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Value Stages -->
		<xsl:variable name="thisValueStages" select="key('allValueStagesname', $this/own_slot_value[slot_reference = 'vs_value_stages']/value)"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisCJPs" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_value_stages']/value = $thisValueStages/name]"/>
		
		<!-- Physical Processes -->
		<xsl:variable name="thisPhysProcs" select="key('allPhysicalProcessesname', $thisCJPs/own_slot_value[slot_reference = 'cjp_supporting_phys_processes']/value)"/>
		
		<!-- App Provider Roles -->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="key('allPhyProc2AppProRoleRelationsProc', $thisPhysProcs/name)"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="key('allAppProviderRolesname', $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
		
		<!-- Prod Type Ids -->
		<xsl:variable name="thisProdTypeIds" select="$this/own_slot_value[slot_reference = 'vs_product_types']/value"/>

		<xsl:variable name="thisBusRoleType" select="key('allBusRoleTypename', current()/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value)"/>
		<xsl:variable name="thisRoleType" select="key('allBusRolename', current()/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value)"/>
		<xsl:variable name="thisTriggerEvents" select="key('allBusEventname', current()/own_slot_value[slot_reference = 'vs_trigger_events']/value)"/>
		<xsl:variable name="thisOutcomeEvents" select="key('allBusEventname', current()/own_slot_value[slot_reference = 'vs_outcome_events']/value)"/>
		<xsl:variable name="thisTriggerConditions" select="key('allBusConditionname', current()/own_slot_value[slot_reference = 'vs_trigger_conditions']/value)"/>
		<xsl:variable name="thisOutcomeConditions" select="key('allBusConditionname', current()/own_slot_value[slot_reference = 'vs_outcome_conditions']/value)"/>
		
		{  
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"valueStages": [<xsl:apply-templates mode="getValueStageJSON" select="$thisValueStages"><xsl:sort select="own_slot_value[slot_reference = 'vsg_index']/value"/></xsl:apply-templates>],
			"physProcessIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhysProcs"/>],
			"appProRoleIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			"prodTypeIds": [<xsl:for-each select="$thisProdTypeIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
			"roles":[<xsl:for-each select="$thisBusRoleType union $thisRoleType">{"id": "<xsl:value-of select="current()/name"/>",
			"type": "<xsl:value-of select="current()/type"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"triggerEvents":[<xsl:for-each select="$thisTriggerEvents">{"id": "<xsl:value-of select="current()/name"/>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"outcomeEvents":[<xsl:for-each select="$thisOutcomeEvents">{"id": "<xsl:value-of select="current()/name"/>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"triggerConditions":[<xsl:for-each select="$thisTriggerConditions">{"id": "<xsl:value-of select="current()/name"/>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"outcomeConditions":[<xsl:for-each select="$thisOutcomeConditions">{"id": "<xsl:value-of select="current()/name"/>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>] 
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Value Stages  -->
	<xsl:template match="node()" mode="getValueStageJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Customer Journey Phases -->
		<xsl:variable name="thisCustomerJourneyPhases" select="$allCustomerJourneyPhases[own_slot_value[slot_reference = 'cjp_value_stages']/value = $this/name]"/>
		
		<xsl:variable name="vsgLabel">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'vsg_display_label']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'vsg_display_label']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderMultiLangCommentarySlot"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="slotName">vsg_label</xsl:with-param></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- measures -->
		<xsl:variable name="emotionScore" select="eas:getEmotionScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="custExperienceScore" select="eas:getExperienceScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="kpiScore" select="eas:getKPIScoreAverage($thisCustomerJourneyPhases, 0, 0)"/>
		<xsl:variable name="thisBusRoleType" select="key('allBusRoleTypename', current()/own_slot_value[slot_reference = 'vsg_participants']/value)"/>
		<xsl:variable name="thisRoleType" select="key('allBusRolename', current()/own_slot_value[slot_reference = 'vsg_participants']/value)"/>
		<xsl:variable name="cxStyleClass" select="eas:getEnumerationScoreStyle($custExperienceScore)"/>
		<xsl:variable name="thisCustomerEmotions" select="key('allCustEmotiontoStage', current()/own_slot_value[slot_reference = 'vsg_emotions']/value)"/>
		<xsl:variable name="thisPerfMeasures" select="key('allPerfMeasures', current()/own_slot_value[slot_reference = 'performance_measures']/value)"/>	
		<xsl:variable name="thisEntranceEvents" select="key('allBusEventname', current()/own_slot_value[slot_reference = 'vsg_entrance_events']/value)"/>
		<xsl:variable name="thisExitEvents" select="key('allBusEventname', current()/own_slot_value[slot_reference = 'vsg_exit_events']/value)"/>
		<xsl:variable name="thisEntranceConditions" select="key('allBusConditionname', current()/own_slot_value[slot_reference = 'vsg_entrance_conditions']/value)"/>
		<xsl:variable name="thisExitConditions" select="key('allBusConditionname', current()/own_slot_value[slot_reference = 'vsg_exit_conditions']/value)"/>	
		<xsl:variable name="thisValStream" select="key('allValueStreamsname',current()/own_slot_value[slot_reference = 'vsg_value_stream']/value)"/>
		<xsl:variable name="thisValStage" select="key('allValueStagesname',current()/own_slot_value[slot_reference = 'vsg_value_stream']/value)"/>
		{ 
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
				'label': string(translate(translate($vsgLabel,'}',')'),'{',')')),
				'index': string(translate(translate(current()/own_slot_value[slot_reference = ('vsg_index')]/value,'}',')'),'{',')')) 
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="displayString" select="$vsgLabel"/><xsl:with-param name="anchorClass">text-white</xsl:with-param></xsl:call-template>",
			"customerJourneyPhaseIds": [<xsl:apply-templates mode="RenderAsIsElementIDListForJs" select="$thisCustomerJourneyPhases"/>],
			"customerJourneyPhases": [],
			"emotionScore": <xsl:value-of select="$emotionScore"/>,
			"cxScore": <xsl:value-of select="$custExperienceScore"/>,
			"kpiScore": <xsl:value-of select="$kpiScore"/>,
			"emotionStyleClass": "<xsl:value-of select="eas:getEnumerationScoreStyle($emotionScore)"/>",
			"cxStyleClass": "<xsl:value-of select="$cxStyleClass"/>",
			"kpiStyleClass": "<xsl:value-of select="eas:getSQVScoreStyle($kpiScore)"/>",
			"styleClass": "<xsl:value-of select="$cxStyleClass"/>",
			"inScope": false,
			<xsl:variable name="combinedVSMap" as="map(*)" select="map{
				'name': string(translate(translate($thisValStream/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'id': string(translate(translate($thisValStream/name,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultVSCombined" select="serialize($combinedVSMap, map{'method':'json', 'indent':true()})" />
			<xsl:variable name="combinedVStageMap" as="map(*)" select="map{
				'name': string(translate(translate($thisValStage/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'id': string(translate(translate($thisValStage/name,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultVStageCombined" select="serialize($combinedVStageMap, map{'method':'json', 'indent':true()})" />
			"valueStream":{<xsl:value-of select="substring-before(substring-after($resultVSCombined,'{'),'}')"/>},
			"parentValueStage":{<xsl:value-of select="substring-before(substring-after($resultVStageCombined,'{'),'}')"/>},
			"roles":[<xsl:for-each select="$thisBusRoleType union $thisRoleType">{"id": "<xsl:value-of select="current()/name"/>",
			"type": "<xsl:value-of select="current()/type"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"emotions":[
			<xsl:for-each select="$thisCustomerEmotions">
			<xsl:variable name="emotion" select="key('allCustEmotions', current()/own_slot_value[slot_reference = ('value_stage_to_emotion_to_emotion')]/value)"/>	
			{"id": "<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'emotion': string(translate(translate($emotion/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'relation_description': string(translate(translate(current()/own_slot_value[slot_reference = ('relation_description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
			}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			"perfMeasures":[<xsl:for-each select="$thisPerfMeasures">{
				<xsl:variable name="bsqv" select="key('allSQVs', current()/own_slot_value[slot_reference = ('pm_performance_value')]/value)"/>	 
				<xsl:variable name="thisServQuals" select="key('allSQs', $bsqv/own_slot_value[slot_reference = 'usage_of_service_quality']/value)"/>
				<xsl:variable name="thisUOMs" select="key('allUoMs', $bsqv/own_slot_value[slot_reference = 'service_quality_value_uom']/value)"/>
				
				"id": "<xsl:value-of select="current()/name"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'kpiVal': string(translate(translate($bsqv/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'quality': string(translate(translate($thisServQuals/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'uom': string(translate(translate($thisUOMs/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
			}<xsl:if test="not(position()=last())">,</xsl:if> 
			</xsl:for-each>],	
		"entranceEvents":[<xsl:for-each select="$thisEntranceEvents">{"id": "<xsl:value-of select="current()/name"/>",
		"type": "<xsl:value-of select="current()/type"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"entranceCondition":[<xsl:for-each select="$thisEntranceConditions">{"id": "<xsl:value-of select="current()/name"/>",
		"type": "<xsl:value-of select="current()/type"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"exitCondition":[<xsl:for-each select="$thisExitConditions">{"id": "<xsl:value-of select="current()/name"/>",
		"type": "<xsl:value-of select="current()/type"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"exitEvent":[<xsl:for-each select="$thisExitEvents">{"id": "<xsl:value-of select="current()/name"/>",
		"type": "<xsl:value-of select="current()/type"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>


	<!-- Template for rendering the list of Customer Journey Phases  -->
	<xsl:template match="node()" mode="getCustomerJourneyPhaseJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Customer Journey -->
		<xsl:variable name="thisCustomerJourney" select="key('allCustomerJourneys', $this/name)"/>
		
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
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="displayString" select="$cjpLabel"/></xsl:call-template>",
			"customerJourneyId": "<xsl:value-of select="$thisCustomerJourney/name"/>",
			"cxScore": <xsl:value-of select="$cxScore"/>,
			"emotionScore": <xsl:value-of select="$emotionScore"/>,
			"kpiScore": <xsl:value-of select="$kpiScore"/>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Customer Journeys  -->
	<xsl:template match="node()" mode="getCustomerJourneyJSON">
		<xsl:variable name="this" select="current()"/>
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<xsl:template match="node()" mode="simpleList">  
		{
			"id": "<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	<xsl:template match="node()" mode="simpleEnumList">  
		<xsl:variable name="styleClass" select="eas:get_element_style_class(current())"/>
		<xsl:variable name="styleColour" select="eas:get_element_style_colour(current())"/>
		<xsl:variable name="styleTextColour" select="eas:get_element_style_textcolour(current())"/>
		{
			"id": "<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
				'enumeration_value': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
				'enumeration_sequence_number': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_sequence_number')]/value,'}',')'),'{',')')),
				'enumeration_score': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_score')]/value,'}',')'),'{',')')),
				'colour': string(translate(translate($styleColour,'}',')'),'{',')')),
				'class': string(translate(translate($styleClass,'}',')'),'{',')')),
				'textColour': string(translate(translate($styleTextColour,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template> 
	<!-- END READ ONLY JSON DATA TEMPLATES -->
	
	
	
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
		
		<xsl:choose>
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
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Function to calculate the average KPI score for the given Customer Journey Phases -->
	<xsl:function name="eas:getKPIScoreAverage" as="xs:float">
		<xsl:param name="vsCustJourneyPhases"/>
		<xsl:param name="currentScoreTotal"/>
		<xsl:param name="scoreCount"/>
		
		<xsl:choose>
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
		</xsl:choose>
		
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
			<xsl:when test="$score &lt; $enumLowThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('Poor')"/>",
					"icon": "<xsl:value-of select="$negativeIcon"/>"
				}
			</xsl:when>
			<xsl:when test="$score &lt; $enumNeutralThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('OK')"/>",
					"icon": "<xsl:value-of select="$neutralIcon"/>"
				}
			</xsl:when>
			<xsl:when test="$score &lt; $enumMediumThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('OK')"/>",
					"icon": "<xsl:value-of select="$neutralIcon"/>"
				}
			</xsl:when>
			<xsl:otherwise>
				{
					"label": "<xsl:value-of select="eas:i18n('Good')"/>",
					"icon": "<xsl:value-of select="$positiveIcon"/>"
				}
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Function to get the emoji image for an emotion score -->
	<xsl:function name="eas:getEmotionScoreStyle">
		<xsl:param name="score"/>
		
		<xsl:choose>
			<xsl:when test="$score &lt; $emotionVeryLowThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('Negative')"/>",
					"emoji": "<xsl:value-of select="$verySadEmoji"/>"
				}
			</xsl:when>
			<xsl:when test="$score &lt; $emotionLowThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('Quite Negative')"/>",
					"emoji": "<xsl:value-of select="$sadEmoji"/>"
				}
			</xsl:when>
			<xsl:when test="$score &lt; $emotionNeutralThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('Neutral')"/>",
					"emoji": "<xsl:value-of select="$neutralEmoji"/>"
				}
			</xsl:when>
			<xsl:when test="$score &lt; $emotionHighThreshold">
				{
					"label": "<xsl:value-of select="eas:i18n('Quite Positive')"/>",
					"emoji": "<xsl:value-of select="$happyEmoji"/>"
				}
			</xsl:when>
			<xsl:otherwise>
				{
					"label": "<xsl:value-of select="eas:i18n('Positive')"/>",
					"emoji": "<xsl:value-of select="$veryHappyEmoji"/>"
				}
			</xsl:otherwise>
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
	
	<xsl:template mode="RenderAsIsElementIDListForJs" match="node()">
		"<xsl:value-of select="current()/name"/>"<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="custJourney">
<xsl:variable name="thisProd" select="$products[name=current()/own_slot_value[slot_reference='cj_products']/value]"/> 
   {"id":"<xsl:value-of select="current()/name"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
      'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
      'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
    }" />
 
  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
    "products":[<xsl:for-each select="$thisProd">{"id":"<xsl:value-of select="current()/name"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
       'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
     }" />
   <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
     <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
   <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template> 

<xsl:template match="node()" mode="physProc">
   <xsl:variable name="thisPPs" select="key('physProcKey', current()/own_slot_value[slot_reference='cjp_supporting_phys_processes']/value)"/> 
</xsl:template>

<xsl:template match="node()" mode="custJourneyPhase">
<xsl:variable name="thisCJ" select="key('custJourneyName', current()/own_slot_value[slot_reference='cjp_customer_journey']/value)"/> 
<xsl:variable name="thisCJExp" select="key('custJourToExKey', current()/own_slot_value[slot_reference='cjp_experience_rating']/value)"/> 
<xsl:variable name="thisExp" select="$custEx[name=$thisCJExp/own_slot_value[slot_reference='cust_journey_phase_to_experience_to_experience']/value]"/> 
<xsl:variable name="thisCJEm" select="key('custJourToEmKey', current()/own_slot_value[slot_reference='cjp_emotions']/value)"/> 
<xsl:variable name="thisEmotions" select="$custEmotions[name=$thisCJEm/own_slot_value[slot_reference='cust_journey_phase_to_emotion_to_emotion']/value]"/> 
<xsl:variable name="thisPPs" select="key('physProcKey', current()/own_slot_value[slot_reference='cjp_supporting_phys_processes']/value)"/> 
<xsl:variable name="thisPerfMeasures" select="key('perfMeasureKey', current()/own_slot_value[slot_reference='performance_measures']/value)"/>   
<xsl:variable name="thisBSQs" select="key('bsqvKey', $thisPerfMeasures/own_slot_value[slot_reference='pm_performance_value']/value)"/> 
   {"id":"<xsl:value-of select="current()/name"/>",  
   "index":"<xsl:value-of select="current()/own_slot_value[slot_reference='cjp_index']/value"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
      'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
      'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
      'cjp_customer_journey': string(translate(translate($thisCJ/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
      'cjp_experience_rating': string(translate(translate($thisExp/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
    }" />
  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
    "emotions":[<xsl:for-each select="$thisEmotions">{"id":"<xsl:value-of select="current()/name"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
       'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
       'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
     }" />
   <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
     <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
     "physProcs":[<xsl:for-each select="$thisPPs">{"id":"<xsl:value-of select="current()/name"/>", 
     <xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
      }" />
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
      <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
   "bsqvs":[<xsl:for-each select="$thisBSQs">{"id":"<xsl:value-of select="current()/name"/>", 
      <xsl:variable name="combinedMap" as="map(*)" select="map{
         'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
       }" />
     <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
       <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
   <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>  
<xsl:template match="node()" mode="standard">
      <xsl:variable name="thislanguage" select="$language"/>  
      <xsl:variable name="thissynonym" select="$synonym[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>  
      <xsl:variable name="thisstyle" select="$style[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/>  
      {"id":"<xsl:value-of select="current()/name"/>",
      <xsl:variable name="combinedMap" as="map(*)" select="map{
         'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
         'label': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
         'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
      }" />
      <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
      <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
      "colour":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",	 
      "class":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_class']/value"/>",
      "seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
      "score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>",
      "synonyms":[<xsl:for-each select="$thissynonym">
         <xsl:variable name="thislanguage" select="$language[name=current()/own_slot_value[slot_reference='synonym_language']/value]"/>  
         {"name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
         <xsl:variable name="combinedMap" as="map(*)" select="map{
            'translationName': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')), 
            'language': string(translate(translate($thislanguage/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')), 
            'translationDesc': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
         }" />
         <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
         <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
   </xsl:template>	
  
   <xsl:template match="node()" mode="dataLookup">
		{"id":"<xsl:value-of select="current()/name"/>",
		<xsl:variable name="tempName" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name', 'relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
		<xsl:variable name="result" select="serialize($tempName, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
		<xsl:variable name="tempDescription" as="map(*)" select="map{'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))}"></xsl:variable>
		<xsl:variable name="result1" select="serialize($tempDescription, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result1,'{'),'}')"></xsl:value-of>,
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>  

<xsl:template match="node()" mode="valLookup">
	<xsl:variable name="thisstyle" select="$style[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/> 
	   {"id":"<xsl:value-of select="current()/name"/>",
	   "score":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>",
	   <xsl:variable name="combinedMap" as="map(*)" select="map{
		  'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		  'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
		  'value': string(translate(translate(current()/own_slot_value[slot_reference = 'service_quality_value_value']/value,'}',')'),'{',')')),
		  'colour': string(translate(translate($thisstyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value,'}',')'),'{',')')),
		  'textColour': string(translate(translate($thisstyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value,'}',')'),'{',')')),
		  'classStyle': string(translate(translate($thisstyle[1]/own_slot_value[slot_reference = 'element_style_class']/value,'}',')'),'{',')'))
	  }" />
	  <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
	   <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>  
</xsl:stylesheet>
