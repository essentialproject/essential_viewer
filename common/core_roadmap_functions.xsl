<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="core_utilities.xsl"/>
	<xsl:import href="core_js_functions.xsl"/>
	
	<!-- COMMON VARIABLES -->
	<!-- Core Roadmap EA elements -->
	<xsl:variable name="rmAllRoadmaps" select="/node()/simple_instance[type = 'Roadmap']"/>
	<xsl:variable name="rmAllArchitectureStates" select="/node()/simple_instance[type = 'Architecture_State']"/>
	<xsl:variable name="rmAllStrategicPlans" select="/node()/simple_instance[supertype = 'Strategic_Plan']"/>
	<xsl:variable name="rmAllStrategicPlanToElementRelations" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="rmAllPlanningActions" select="/node()/simple_instance[(name = $rmAllStrategicPlanToElementRelations/own_slot_value[slot_reference = 'plan_to_element_change_action']/value)]"/>
	<xsl:variable name="rmAllObjectives" select="/node()/simple_instance[(name = $rmAllStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value)]"/>
	<xsl:variable name="rmAllObjectiveClasses" select="/node()/class[name = ('Business_Objective', 'Information_Architecture_Objective', 'Application_Architecture_Objective', 'Technology_Architecture_Objective')]"/>
	<xsl:variable name="rmAllObjectiveClassStyles" select="eas:getObjectiveStyles()"/>
	
	<!-- Taxonomy to categorise Planning Actions in terms of the nature of their effect-->
	<xsl:variable name="rmPlanningActionTypeTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Planning Action Change Types')]"/>
	<xsl:variable name="rmAllPlanningActionTypes" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $rmPlanningActionTypeTaxonomy/name]"/>
	<xsl:variable name="rmCreatePlanningActionType" select="$rmAllPlanningActionTypes[own_slot_value[slot_reference = 'name']/value = 'Creation Change']"/>
	<xsl:variable name="rmEnhancePlanningActionType" select="$rmAllPlanningActionTypes[own_slot_value[slot_reference = 'name']/value = 'Enhancement Change']"/>
	<xsl:variable name="rmReducePlanningActionType" select="$rmAllPlanningActionTypes[own_slot_value[slot_reference = 'name']/value = 'Reduction Change']"/>
	<xsl:variable name="rmRemovePlanningActionType" select="$rmAllPlanningActionTypes[own_slot_value[slot_reference = 'name']/value = 'Removal Change']"/>
	<xsl:variable name="rmNoChangePlanningActionType" select="$rmAllPlanningActionTypes[own_slot_value[slot_reference = 'name']/value = 'No Change']"/>
	
	<!-- JSON Objects representing the styling details for Planning Action Types -->
	<xsl:variable name="rmCreatePlanningActionStyleJSON"><xsl:call-template name="RenderElementStyleJSON"><xsl:with-param name="element" select="$rmCreatePlanningActionType"></xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="rmEnhancePlanningActionStyleJSON"><xsl:call-template name="RenderElementStyleJSON"><xsl:with-param name="element" select="$rmEnhancePlanningActionType"></xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="rmReducePlanningActionStyleJSON"><xsl:call-template name="RenderElementStyleJSON"><xsl:with-param name="element" select="$rmReducePlanningActionType"></xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="rmRemovePlanningActionStyleJSON"><xsl:call-template name="RenderElementStyleJSON"><xsl:with-param name="element" select="$rmRemovePlanningActionType"></xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="rmNoChangePlanningActionStyleJSON"><xsl:call-template name="RenderElementStyleJSON"><xsl:with-param name="element" select="$rmNoChangePlanningActionType"></xsl:with-param></xsl:call-template></xsl:variable>
	
	<!-- Lists of Planning Actions separated by the nature of their effect -->
	<xsl:variable name="rmCreatePlanningActions" select="$rmAllPlanningActions[own_slot_value[slot_reference = 'element_classified_by']/value = $rmCreatePlanningActionType/name]"/>
	<xsl:variable name="rmEnhancePlanningActions" select="$rmAllPlanningActions[own_slot_value[slot_reference = 'element_classified_by']/value = $rmEnhancePlanningActionType/name]"/>
	<xsl:variable name="rmReducePlanningActions" select="$rmAllPlanningActions[own_slot_value[slot_reference = 'element_classified_by']/value = $rmReducePlanningActionType/name]"/>
	<xsl:variable name="rmRemovePlanningActions" select="$rmAllPlanningActions[own_slot_value[slot_reference = 'element_classified_by']/value = $rmRemovePlanningActionType/name]"/>
	
	<!-- Lists of Strategic Plan to Element Relations separated by the nature of their effect -->
	<xsl:variable name="rmCreatePlansForElements" select="$rmAllStrategicPlanToElementRelations[own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $rmCreatePlanningActions/name]"/>
	<xsl:variable name="rmEnhancePlansForElements" select="$rmAllStrategicPlanToElementRelations[own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $rmEnhancePlanningActions/name]"/>
	<xsl:variable name="rmReducePlansForElements" select="$rmAllStrategicPlanToElementRelations[own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $rmReducePlanningActions/name]"/>
	<xsl:variable name="rmRemovePlansForElements" select="$rmAllStrategicPlanToElementRelations[own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $rmRemovePlanningActions/name]"/>
	
	
	<!-- String values to be used in Javascript to represent the different types of change -->
	<xsl:variable name="createStatusValue"><xsl:value-of select="$rmCreatePlanningActionType/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/></xsl:variable>
	<xsl:variable name="enhanceStatusValue"><xsl:value-of select="$rmEnhancePlanningActionType/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/></xsl:variable>
	<xsl:variable name="reduceStatusValue"><xsl:value-of select="$rmReducePlanningActionType/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/></xsl:variable>
	<xsl:variable name="removeStatusValue"><xsl:value-of select="$rmRemovePlanningActionType/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/></xsl:variable>
	<xsl:variable name="unchangedStatusValue"><xsl:value-of select="$rmNoChangePlanningActionType/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/></xsl:variable>
	
	<xsl:variable name="rmObjectiveRefOffset" select="2"/>
	
	<xsl:variable name="rmRoadmapPanelIntro" select="eas:i18n('Select a start and end date to scope the contents of this view based on the changes to the enterprise landscape that occur within the time frame')"/>
	<xsl:variable name="rmRoadmapChangesIntro" select="eas:i18n('The table below lists the changes that occur  within the selected time frame')"/>
	<xsl:variable name="rmStartDateLabel" select="eas:i18n('View From Date')"/>
	<xsl:variable name="rmStartDateDescription" select="eas:i18n('The date from when changes to the enterprise landscape will be considered')"/>
	<xsl:variable name="rmEndDateLabel" select="eas:i18n('View To Date')"/>
	<xsl:variable name="rmEndDateDescription" select="eas:i18n('The date up to when changes to the enterprise landscape will be considered')"/>
	
	<!-- COMMON XSL TEMPLATES AND FUNCTIONS -->
	<!-- FUNCTION THAT DETERMINES WHETHER ROADMAPS ARE DEFINED FOR ONE OR MORE OF THE GIVEN LIST OF INSTANCES -->
	<xsl:function name="eas:isRoadmapEnabled" as="xs:boolean">
		<xsl:param name="instanceList"/>
		
		<xsl:variable name="stratPlanInstances" select="$instanceList[name = $rmAllStrategicPlanToElementRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
		<xsl:variable name="archStateInstances" select="$instanceList[name = $rmAllArchitectureStates/own_slot_value[slot_reference = ('arch_state_application_conceptual','arch_state_application_logical', 'arch_state_application_physical', 'arch_state_application_relations', 'arch_state_business_conceptual', 'arch_state_business_logical', 'arch_state_business_physical', 'arch_state_business_relations', 'arch_state_information_conceptual', 'arch_state_information_logical', 'arch_state_physical_information', 'arch_state_information_relations', 'arch_state_technology_conceptual', 'arch_state_technology_logical', 'arch_state_technology_physical', 'arch_state_technology_relations', 'arch_state_security_management', 'arch_state_strategy_management')]/value]"/>
		
		<xsl:value-of select="count(($stratPlanInstances, $archStateInstances)) > 0"/>
	</xsl:function>
	
	<!-- FUNCTION THAT RETURNS A LIST OF ELEMENT STYLE INSTANCES FOR THE OBJECTIVE META-CLASSES -->
	<xsl:function name="eas:getObjectiveStyles" as="node()*">
		<xsl:for-each select="$rmAllObjectiveClasses">
			<xsl:sequence select="eas:get_element_style_instance(current())"/>
		</xsl:for-each>
	</xsl:function>
	
	<!-- FUNCTION THAT RETURNS A LABEL FOR A GIVEN META-CLASS -->
	<xsl:function name="eas:getClassLabel" as="xs:string">
		<xsl:param name="metaClass"/>
		
		<xsl:value-of select="translate($metaClass/name, '_', ' ')"/>
	</xsl:function>
	
	<xsl:template name="RenderRoadmapJSLibraries">
		<xsl:param name="roadmapEnabled"/>
		
		<!-- HANDLEBARS LIBRARY -->
		<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
		
		<xsl:if test="$roadmapEnabled">
			<!-- MONTH PICKER LIBRARIES AND STYLESHEETS -->
			<link href="js/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />
			<link href="js/jquery-ui/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" />
			<link href="js/jquery-ui-month-picker/MonthPicker.min.css" rel="stylesheet" type="text/css" />
			<!--<script type="text/javascript" src="js/jquery-ui/jquery-ui.min.js"/>-->
			<script type="text/javascript" src="js/jquery.maskedinput.min.js"/>
			<script type="text/javascript" src="js/jquery-ui-month-picker/MonthPicker.min.js"/>
			
			<!-- TIMELINE LIBRARIES AND STYLESHEETS -->
			<link rel="stylesheet" href="js/jquery-timeline/timeline.min.css"/>
			<script type="text/javascript" src="js/jquery-timeline/timeline.min.js"/>
			
		</xsl:if>
	</xsl:template>
	

	
	
	<!-- TEMPLATE TO RENDERS A JSON OBJECT CONTAINING THE COMMON INSTANCE PROPERTIES AND ROADMAP RELATED PROPERTIES -->
	<xsl:template name="RenderRoadmapJSONProperties">
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		<xsl:param name="theDisplayInstance"/>
		<xsl:param name="theDisplayLabel"/>
		<xsl:param name="theRoadmapInstance"/>
		<xsl:param name="theTargetReport" select="()"/>
		<xsl:param name="allTheRoadmapInstances" select="()"/>
		
		
		<xsl:variable name="thisId"><xsl:value-of select="eas:getSafeJSString($theRoadmapInstance/name)"/></xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:choose>
				<xsl:when test="$theDisplayLabel">
					<xsl:value-of select="$theDisplayLabel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/>
				<xsl:with-param name="displayString" select="$thisName"/>
				<xsl:with-param name="targetReport" select="$theTargetReport"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDescription"><xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/></xsl:call-template></xsl:variable>
		
		<xsl:variable name="createPlansForElement" select="$rmCreatePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="enhancePlansForElement" select="$rmEnhancePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="reducePlansForElement" select="$rmReducePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="removePlansForElement" select="$rmRemovePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="allPlansForElement" select="$createPlansForElement union $enhancePlansForElement union $reducePlansForElement union $removePlansForElement"/>
		<xsl:variable name="allThisPlans" select="$rmAllStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $allPlansForElement/name]"/>
		
		<xsl:variable name="thisRoadmapChangeName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$theRoadmapInstance"/></xsl:call-template></xsl:variable>
		<xsl:variable name="thisRoadmapLink"><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="targetReport" select="$theTargetReport"/><xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/><xsl:with-param name="displayString" select="$thisRoadmapChangeName"/></xsl:call-template></xsl:variable>
		
		
		<!-- Variable containing all architecture states that are relevant for elements that share the same class as the Roadmap instance -->
		<xsl:variable name="allTheRoadmapInstancesArchStates" select="$rmAllArchitectureStates[own_slot_value[slot_reference = ('arch_state_application_conceptual','arch_state_application_logical', 'arch_state_application_physical', 'arch_state_application_relations', 'arch_state_business_conceptual', 'arch_state_business_logical', 'arch_state_business_physical', 'arch_state_business_relations', 'arch_state_information_conceptual', 'arch_state_information_logical', 'arch_state_physical_information', 'arch_state_information_relations', 'arch_state_technology_conceptual', 'arch_state_technology_logical', 'arch_state_technology_physical', 'arch_state_technology_relations', 'arch_state_security_management', 'arch_state_strategy_management')]/value = $allTheRoadmapInstances/name]"/>
		<!-- Variable containing all architecture states that contain the Roadmap instance -->
		<xsl:variable name="allThisRoadmapInstanceArchStates" select="$rmAllArchitectureStates[own_slot_value[slot_reference = ('arch_state_application_conceptual','arch_state_application_logical', 'arch_state_application_physical', 'arch_state_application_relations', 'arch_state_business_conceptual', 'arch_state_business_logical', 'arch_state_business_physical', 'arch_state_business_relations', 'arch_state_information_conceptual', 'arch_state_information_logical', 'arch_state_physical_information', 'arch_state_information_relations', 'arch_state_technology_conceptual', 'arch_state_technology_logical', 'arch_state_technology_physical', 'arch_state_technology_relations', 'arch_state_security_management', 'arch_state_strategy_management')]/value = $theRoadmapInstance/name]"/>
		
		"id": "<xsl:value-of select="$thisId"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDescription)"/>"<xsl:if test="$isRoadmapEnabled">,
		<xsl:if test="count($theTargetReport) = 0">"menu": "<xsl:value-of select="eas:getElementContextMenuName($theDisplayInstance)"/>",</xsl:if>
		"roadmap": {
			"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
			"isVisible": true,
			"plansForPeriod": [],
			"archStatesForPeriod": [],
			"objectivesForPeriod": [],
			"rmStyle": <xsl:value-of select="$rmNoChangePlanningActionStyleJSON"/>, <!-- default to no change style -->
			"rmLink": "<xsl:value-of select="$thisRoadmapLink"/>",
			"rmMetaClassStyle": "rmMetaClassStyles.<xsl:value-of select="eas:getSafeJSString($theRoadmapInstance/type)"/>",
			"rmEALayer": "<xsl:value-of select="eas:rmGetInstanceEALayer($theRoadmapInstance)"/>",
			"strategicPlans": [
				<xsl:apply-templates mode="RenderElementStrategicPlanJSON" select="$allPlansForElement">
					<!--<xsl:sort select="$allThisPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = name]/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>-->
				</xsl:apply-templates>
			],
			"archStates": [
				<xsl:if test="count($allThisRoadmapInstanceArchStates) > 0">
					<xsl:apply-templates mode="RenderElementArchStateJSON" select="$allTheRoadmapInstancesArchStates">
						<xsl:with-param name="thisArchStates" select="$allThisRoadmapInstanceArchStates"/>
						<xsl:sort select="own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
					</xsl:apply-templates>
				</xsl:if>
			]
		}</xsl:if>	
	</xsl:template>
	
	
	<!-- TEMPLATE TO SET THE VISIBILITY AND CHANGE JSON PROPERTIES FOR STRATEGIC PLAN TO ELEMENT RELATION-->
	<xsl:template name="RenderStratPlanForElementChangeJSON">
		<xsl:param name="thisStratPlanForElement"/>
		
		<xsl:choose>
			<xsl:when test="$thisStratPlanForElement/name = $rmCreatePlansForElements/name">
				"roadmapStatus": "<xsl:value-of select="$createStatusValue"/>",
				"rmStyle": "rmCreateStyle",
				"visibility": true,
			</xsl:when>
			<xsl:when test="$thisStratPlanForElement/name = $rmEnhancePlansForElements/name">
				"roadmapStatus": "<xsl:value-of select="$enhanceStatusValue"/>",
				"rmStyle": "rmEnhanceStyle",
				"visibility": true,
			</xsl:when>
			<xsl:when test="$thisStratPlanForElement/name = $rmReducePlansForElements/name">
				"roadmapStatus": "<xsl:value-of select="$reduceStatusValue"/>",
				"rmStyle": "rmReduceStyle",
				"visibility": true,
			</xsl:when>
			<xsl:when test="$thisStratPlanForElement/name = $rmRemovePlansForElements/name">
				"roadmapStatus": "<xsl:value-of select="$removeStatusValue"/>",
				"rmStyle": "rmRemoveStyle",
				"visibility": false,
			</xsl:when>
			<xsl:otherwise>
				"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
				"rmStyle": "rmNoChangeStyle",
				"visibility": true,
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- TEMPLATE TO RENDER A JSON OBJECT PROVIDING THE ID, START AND END DATES OF A STRATEGIC PLAN -->
	<xsl:template mode="RenderElementStrategicPlanJSON" match="node()">
		<xsl:variable name="thisPlanForElement" select="current()"/>
		
		<xsl:variable name="thisPlan" select="$rmAllStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $thisPlanForElement/name]"/>
		<xsl:variable name="thisPlanningAction" select="$rmAllPlanningActions[name = $thisPlanForElement/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>
		<xsl:variable name="planId" select="eas:getSafeJSString($thisPlan/name)"/>
		<xsl:variable name="planLink"><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisPlan"/></xsl:call-template></xsl:variable>
		<xsl:variable name="planStartDate" select="$thisPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
		<xsl:variable name="planEndDate" select="$thisPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		
		<xsl:variable name="planDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="$thisPlanForElement"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="planRoadmapStatus">
			<xsl:choose>
				<xsl:when test="$thisPlanForElement/name = $rmCreatePlansForElements/name">
					"roadmapStatus": "<xsl:value-of select="$createStatusValue"/>",
					"rmStyle": "rmCreateStyle",
					"visibility": true
				</xsl:when>
				<xsl:when test="$thisPlanForElement/name = $rmEnhancePlansForElements/name">
					"roadmapStatus": "<xsl:value-of select="$enhanceStatusValue"/>",
					"rmStyle": "rmEnhanceStyle",
					"visibility": true
				</xsl:when>
				<xsl:when test="$thisPlanForElement/name = $rmReducePlansForElements/name">
					"roadmapStatus": "<xsl:value-of select="$reduceStatusValue"/>",
					"rmStyle": "rmReduceStyle",
					"visibility": true
				</xsl:when>
				<xsl:when test="$thisPlanForElement/name = $rmRemovePlansForElements/name">
					"roadmapStatus": "<xsl:value-of select="$removeStatusValue"/>",
					"rmStyle": "rmRemoveStyle",
					"visibility": false
				</xsl:when>
				<xsl:otherwise>
					"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
					"rmStyle": "rmNoChangeStyle",
					"visibility": true
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
			
		
		
		{
			"id": "<xsl:value-of select="$planId"/>",
			"description": "<xsl:value-of select="eas:validJSONString($planDesc)"/>",
			"changeLabel": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisPlanningAction"/></xsl:call-template>",
			"startDate": "<xsl:value-of select="$planStartDate"/>",
			"endDate": "<xsl:value-of select="$planEndDate"/>",
			<xsl:value-of select="$planRoadmapStatus"/>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A JSON OBJECT PROVIDING THE ID, START AND END DATES OF AN ELEMENT's ARCHITECTURE STATE -->
	<xsl:template mode="RenderElementArchStateJSON" match="node()">
		<xsl:param name="thisArchStates"/> <!-- The arch states in which the lement exists -->
		
		<xsl:variable name="thisArchStateIndex" select="position()"/>
		
		<xsl:variable name="thisArchState" select="current()"/>
		<xsl:variable name="archStateId" select="eas:getSafeJSString($thisArchState/name)"/>
		<xsl:variable name="archStateStartDate" select="$thisArchState/own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
		<xsl:variable name="archStateEndDate" select="$thisArchState/own_slot_value[slot_reference = 'end_date_iso_8601']/value"/>
		
		<xsl:variable name="instanceInArchState" select="count($thisArchStates[name = $thisArchState/name]) > 0"/>
		<xsl:variable name="instanceExistsBeforeArchState" select="count($thisArchStates[own_slot_value[slot_reference = 'start_date_iso_8601']/value &lt; $thisArchState/own_slot_value[slot_reference = 'start_date_iso_8601']/value]) > 0"/>
		
		<!-- Define the Roadmap statis JSON properties for this arch state for the current element -->
		<xsl:variable name="thisArchStateRoadmapStatus">
			<xsl:choose>
				<!-- Set to NOCHANGE if the element exists in the first arch state -->
				<xsl:when test="$instanceInArchState and ($thisArchStateIndex = 1)">
					"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
					"rmStyle": "rmNoChangeStyle",
					"visibility": true
				</xsl:when>
				<!-- Set to NOCHANGE if the element exists in the current arch state and existed in at least one prior arch state -->
				<xsl:when test="$instanceInArchState and $instanceExistsBeforeArchState">
					"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
					"rmStyle": "rmNoChangeStyle",
					"visibility": true
				</xsl:when>
				<!-- Set to CREATE if the element exists in the current arch state but did not exists in any prior arch states -->
				<xsl:when test="$instanceInArchState and not($instanceExistsBeforeArchState)">
					"roadmapStatus": "<xsl:value-of select="$createStatusValue"/>",
					"rmStyle": "rmCreateStyle",
					"visibility": true
				</xsl:when>
				<!-- Set to REMOVE if the element does not exist in the current arch state -->
				<xsl:when test="not($instanceInArchState)">
					"roadmapStatus": "<xsl:value-of select="$removeStatusValue"/>",
					"rmStyle": "rmRemoveStyle",
					"visibility": false
				</xsl:when>
				<!-- Otherwise set to NOCHANGE -->
				<xsl:otherwise>
					"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
					"rmStyle": "rmNoChangeStyle",
					"visibility": true
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		{
		"id": "<xsl:value-of select="$archStateId"/>",
		"startDate": "<xsl:value-of select="$archStateStartDate"/>",
		"endDate": "<xsl:value-of select="$archStateEndDate"/>",
		<xsl:value-of select="$thisArchStateRoadmapStatus"/>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A JSON OBJECT PROVIDING THE ID, START AND AEND DATES OF A STRATEGIC PLAN -->
	<xsl:template mode="RenderStrategicPlanJSON" match="node()">

		<xsl:variable name="thisPlan" select="current()"/>
		<xsl:variable name="planId" select="eas:getSafeJSString($thisPlan/name)"/>
		<xsl:variable name="planLink"><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisPlan"/></xsl:call-template></xsl:variable>
		<xsl:variable name="planStartDate" select="$thisPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
		<xsl:variable name="planEndDate" select="$thisPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		<xsl:variable name="planRoadmaps" select="$rmAllRoadmaps[own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $thisPlan/name]"/>
		<xsl:variable name="planObjectives" select="$rmAllObjectives[(name = $thisPlan/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value)]"/>
		
		<xsl:variable name="planName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisPlan"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="planDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisPlan"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"id": "<xsl:value-of select="$planId"/>",
		"name": "<xsl:value-of select="eas:validJSONString($planName)"/>",
		"link": "<xsl:value-of select="$planLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($planDesc)"/>",
		"startDate": "<xsl:value-of select="$planStartDate"/>",
		"endDate": "<xsl:value-of select="$planEndDate"/>",
		"roadmaps": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$planRoadmaps"/>],
		"objectives": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$planObjectives"/>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A JSON OBJECT PROVIDING THE DETAILS OF AN ARCHITECTURE STATE -->
	<xsl:template mode="RenderArchStateJSON" match="node()">
		
		<xsl:variable name="thisArchState" select="current()"/>
		<xsl:variable name="archStateId" select="eas:getSafeJSString($thisArchState/name)"/>
		<xsl:variable name="archStateLink"><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisArchState"/></xsl:call-template></xsl:variable>
		<xsl:variable name="archStateStartDate" select="$thisArchState/own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
		<xsl:variable name="archStateEndDate" select="$thisArchState/own_slot_value[slot_reference = 'end_date_iso_8601']/value"/>
		<xsl:variable name="archStateRoadmaps" select="$rmAllRoadmaps[own_slot_value[slot_reference = 'roadmap_architecture_states']/value = $thisArchState/name]"/>
		<xsl:variable name="archStateObjectives" select="$rmAllObjectives[(name = $thisArchState/own_slot_value[slot_reference = 'arch_state_objectives']/value)]"/>
		
		<xsl:variable name="archStateName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$archStateId"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="archStateDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisArchState"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		{
		"id": "<xsl:value-of select="$archStateId"/>",
		"name": "<xsl:value-of select="eas:validJSONString($archStateName)"/>",
		"link": "<xsl:value-of select="$archStateLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($archStateDesc)"/>",
		"startDate": "<xsl:value-of select="$archStateStartDate"/>",
		"endDate": "<xsl:value-of select="$archStateEndDate"/>",
		"roadmaps": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$archStateRoadmaps"/>],
		"objectives": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$archStateObjectives"/>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A JSON OBJECT REPRESENTING AN OBJECTIVE -->
	<xsl:template match="node()" mode="RenderRoadmapObjectiveJSON">
		
		<xsl:variable name="thisMetaClass" select="$rmAllObjectiveClasses[name = current()/type]"/>
		<xsl:variable name="metaClassStyle" select="$rmAllObjectiveClassStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $thisMetaClass/name]"/>
		<xsl:variable name="metaClassLabel" select="eas:getClassLabel($thisMetaClass)"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisRef" select="position() + $rmObjectiveRefOffset"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"ref": <xsl:value-of select="$thisRef"/>,
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"type": "<xsl:value-of select="$metaClassLabel"/>",
		"icon": "<xsl:value-of select="$metaClassStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"targetDate": "<xsl:value-of select="current()/own_slot_value[slot_reference = ('bo_target_date_iso_8601', 'ao_target_date_iso_8601', 'io_target_date_iso_8601', 'tao_target_date_iso_8601')]/value"/>"
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A GENERIC JSON OBJECT FOR DETAILS OF AN ELEMENT -->
	<xsl:template match="node()" mode="RenderGenericRoadmapJSON">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
    
	
	<!-- TEMPLATE TO RENDER THE ROADMAP JAVASCRIPT VARIABLES AND FUNCTIONS -->
	<!-- Parameter: roadmapInstances - the complete list of essential instances in scope for the view that need to be roadmap aware -->
	<xsl:template name="RenderCommonRoadmapJavscript">
		<xsl:param name="roadmapInstances" as="node()*"/>
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		
		<script type="text/javascript">
			//Defines whether the roadmap is enabled for this view
				var roadmapEnabled = <xsl:choose><xsl:when test="$isRoadmapEnabled">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>;
			
			<!-- TEMPLATE TO RENDER COMMONLY USED JAVASCRIPT UTILITY FUNCTIONS -->
			<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
		</script>
		
		<xsl:if test="$isRoadmapEnabled">
			<xsl:variable name="relevantPlanToElements" select="$rmAllStrategicPlanToElementRelations[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $roadmapInstances/name]"/>
			<xsl:variable name="relevantStrategicPlans" select="$rmAllStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $relevantPlanToElements/name]"/>
			<xsl:variable name="relevantArchStates" select="$rmAllArchitectureStates[own_slot_value[slot_reference = ('arch_state_application_conceptual','arch_state_application_logical', 'arch_state_application_physical', 'arch_state_application_relations', 'arch_state_business_conceptual', 'arch_state_business_logical', 'arch_state_business_physical', 'arch_state_business_relations', 'arch_state_information_conceptual', 'arch_state_information_logical', 'arch_state_physical_information', 'arch_state_information_relations', 'arch_state_technology_conceptual', 'arch_state_technology_logical', 'arch_state_technology_physical', 'arch_state_technology_relations', 'arch_state_security_management', 'arch_state_strategy_management')]/value = $roadmapInstances/name]"/>
			<xsl:variable name="relevantRoadmaps" select="$rmAllRoadmaps[own_slot_value[slot_reference = ('roadmap_architecture_states', 'roadmap_strategic_plans') ]/value = ($relevantStrategicPlans, $relevantArchStates)/name]"/>
			<xsl:variable name="relevantObjectives" select="$rmAllObjectives[name = ($relevantStrategicPlans, $relevantArchStates)/own_slot_value[slot_reference = ('arch_state_objectives', 'strategic_plan_supports_objective')]/value]"/>
			
			<xsl:variable name="relevantMetaClasses" select="/node()/class[name = $roadmapInstances/type]"/>
			
			
			<style type="text/css">
				.rmDate {
					float:left;
					margin-right:20px;
				}
				
				.rm-plain-text {
					color: #404040;
					font-weight: bold;
				}
				
				.rm-create-text {
					color: #4f8956;
					font-weight: bold;
				}
				
				.rm-enhance-text {
					color: #1B51A5;
					font-weight: bold;
				}
				
				.rm-reduce-text {
					color: #F59C3D;
					font-weight: bold;
				}
				
				.rm-remove-text {
					color: #ccc;
					font-weight: bold;
				}
				
				.rm-panel-wrapper{
					padding: 10px;
					border: 1px solid #aaa;
					box-shadow: 2px 2px 4px #ccc;
					float: left;
					width: 100%;
				}
				
				.rm-ea-layer-text{
					 text-transform: capitalize; 
				}
				
				.timeline-container {
					margin: 15px 0;
				}
				
				.month-picker-open-button {
					height: 26px;
					width: 24px;
					margin-bottom: 2px;
					border-radius:0 4px 4px 0;
					margin-left: -1px;
				}
				.timeline-node {
					background-size: 70%;
					transition: all 0.25s ease 0;
				}
				.timeline-event-view {
					margin: 5px 0;
				}
				#ess-roadmap-widget-bar {
					<!--height: 35px;-->
					float: left;
					width: 100%;
					padding: 4px 10px;
					position: relative;
					top: 0px;
					z-index: 100;
					background-color: #f6f6f6;
					box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.5);
				}
				#ess-roadmap-widget-bar > div {
					
				}
				#ess-roadmap-widget-toggle {
					cursor: pointer;
				}
				#ess-roadmap-content-container {
					width: 100%;
					padding: 15px;
					position: relative;
					right: 0px;
					<!--top: 34px;-->
					margin-bottom: 15px;
					background-color: #eee;
					border-top: 1px solid #ccc;
					border-bottom: 1px solid #ccc;
					display: none;
					float: left;
				}
				
				.ess-roadmap-widget-picker {
					color: black !important;
					width: 70px;
					text-align: center;
				}
				
				.month-picker {
					box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
				}
				
				.month-picker .ui-widget {
					font-family: 'Source Sans Pro', sans-serif;
					font-size: 0.9em;
				}
				
				.month-picker .ui-button {
					border: none;
					background: #eee;
					padding: .3em .9em;
				}
				
				.month-picker .ui-widget-header {
					border: none;
					background: #ccc;
					
				}
				
				.month-picker .ui-state-disabled {
					opacity: 1
				}
				
				.month-picker-previous > .ui-button,.month-picker-next > .ui-button{
					background: none;
					position: relative;
					top: -2px;
				}
				.month-picker-year-table .ui-button {
					width: auto;
				}
				
				.rm-animation-btn {
					font-size: 1.4em;
				}
				
				.rm-animation-btn:hover {
					cursor: pointer;
				}
				
				.rm-btn-active {
					color: green;
				}
				
				.rm-btn-disabled {
					color: lightgrey;
				}
				
				.rm-animation-date-blink {
					animation-name: blink;
					animation-duration: 1500ms;
					animation-iteration-count: infinite;
				}
				
				@keyframes blink {
			    	0% {color: black;}
			    	50% {color: red;}
			    	100% {color: black;}
			    }
			</style>
			<script>
				$(window).scroll(function() {
					if ($(this).scrollTop()>40) {
						//$('#ess-roadmap-widget-bar').css('top','0px');
						$('#ess-roadmap-widget-bar').css('position','fixed');
					}
					if ($(this).scrollTop()&lt;40) {
						//$('#ess-roadmap-widget-bar').css('top', '00px');
						$('#ess-roadmap-widget-bar').css('position','relative');
					}
				});
				$(document).ready(function(){
					$('#ess-roadmap-widget-toggle').click(function(){
						$('#ess-roadmap-content-container').slideToggle();
						rmDrawChangedElementsTable();
					});
					
				});
			</script>

			<script type="text/javascript">
				
				//DEFINE TOP LEVEL ROADMAP VARIABLES
				var rmChangedElementsTable;
			
				var rmCreateStyle = <xsl:value-of select="$rmCreatePlanningActionStyleJSON"/>;
				var	rmEnhanceStyle = <xsl:value-of select="$rmEnhancePlanningActionStyleJSON"/>;
				var rmReduceStyle = <xsl:value-of select="$rmReducePlanningActionStyleJSON"/>;
				var rmRemoveStyle = <xsl:value-of select="$rmRemovePlanningActionStyleJSON"/>;
				var rmNoChangeStyle = <xsl:value-of select="$rmNoChangePlanningActionStyleJSON"/>;
			
				//define styling properties for the relevant meta classes
				var rmMetaClassStyles = {
					<xsl:for-each select="$relevantMetaClasses">
						<xsl:variable name="thisClassStyleJSON">
							<xsl:call-template name="RenderClassStyleJSON">
								<xsl:with-param name="class" select="current()"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="thisStyleName" select="eas:getSafeJSString(current()/name)"/>
						<!-- Add the property for the given instance's meta-class -->
						'<xsl:value-of select="$thisStyleName"/>': <xsl:value-of select="$thisClassStyleJSON"/><xsl:if test="not(position() = last())">,
						</xsl:if>			
					</xsl:for-each>
				};
			
				var rmStartDate, rmEndDate, rmStartDateString, rmEndDateString, rmEALayerTemplate, rmMetaclassTemplate, rmElementLinkTemplate, rmElementPlansTemplate, rmChangesTemplate;
				var rmRelevantObjectives = [];
				
				var rmRoadmapAwareElements = [];
				
				var rmRoadmapChanges = {
					'business': [],
					'information': [],
					'application': [],
					'technology': [],
					'other': []
				};
				
				var rmRoadmapChangeList = [];
				
				//initialise the set of roadmap changes
				function initRoadmapChanges() {
					rmRoadmapChanges['business'] = [];
					rmRoadmapChanges['information'] = [];
					rmRoadmapChanges['application'] = [];
					rmRoadmapChanges['technology'] = [];
					rmRoadmapChanges['other'] = [];
					
					rmRoadmapChangeList = [];
				}
			
				//function to initialise the start and end dates
				function rmInitDates() {
					var today = new Date();
					var y = today.getFullYear(), m = today.getMonth();
					rmStartDate = new Date(y, m, 1);
					rmStartDateString = formatDate(rmStartDate);
					
					rmEndDate = new Date(y, m + 1, 0);
					rmEndDateString = formatDate(rmEndDate);
				}
				
				//function to format a date object to yyyy-mm-dd format
				function formatDate(date) {
				    var d = new Date(date),
				        month = '' + (d.getMonth() + 1),
				        day = '' + d.getDate(),
				        year = d.getFullYear();
				
				    if (month.length &lt; 2) month = '0' + month;
				    if (day.length &lt; 2) day = '0' + day;
				
				    return [year, month, day].join('-');
				}
				
				
				//function to format a date object to dd-MMM-yyyy format
				function niceFormatDate(date) {
				  var monthNames = [
				    "Jan", "Feb", "Mar",
				    "Apr", "May", "Jun", "Jul",
				    "Aug", "Sep", "Oct",
				    "Nov", "Dec"
				  ];
				
				  var day = date.getDate();
				  var monthIndex = date.getMonth();
				  var year = date.getFullYear();
				
				  return day + ' ' + monthNames[monthIndex] + ' ' + year;
				}
		
				//function to initialise the start and end dates
				function rmDateIsValid(aStartDate, anEndDate) {
					return anEndDate >= aStartDate;
				}
				
				
				//roadmap animation variables
				var roadmapTimer;
				var roadmapStepCount = 1;
				var roadmapTimerInterval = 1500;
				var roadmapMaxStepCount = 10;
				var roadmapTimerMonths = 6;
				
				function roadmapTimerEvent() {
					if(roadmapStepCount &lt;= roadmapMaxStepCount) {
				  		console.log('Roadmap Animated');
				  		let newDateMoment = moment(rmEndDate).add(roadmapTimerMonths, 'months');
				  		let newDate = newDateMoment.toDate();
						$('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
						rmUpdateEndDate(newDate);
				  		roadmapStepCount++;
				  	} else {
				  		$('#rmWidgetEndDateSelect').removeClass('rm-animation-date-blink');
				  	}
				}
				
				//function to start the animation of the roadmap at set intervals
				function startRoadmapAnimation() {
					$('#rmWidgetEndDateSelect').addClass('rm-animation-date-blink');
					roadmapTimer = setInterval(roadmapTimerEvent, roadmapTimerInterval);
				}
				
				//function to stop the animation of the roadmap at set intervals
				function endRoadmapAnimation() {
					console.log('Roadmap Animation Paused');
					if(roadmapTimer != null) {
						clearInterval(roadmapTimer);
						$('#rmWidgetEndDateSelect').removeClass('rm-animation-date-blink');
					}
				}
				
				//function to reset the animation of the roadmap at set intervals
				function resetRoadmapAnimation() {
					//remove the roadmap timer, if one exists
					if(roadmapTimer != null) {
						clearInterval(roadmapTimer);
						$('#rmWidgetEndDateSelect').removeClass('rm-animation-date-blink');
					}
					//reset the end date to today + 1 month
					let newDateMoment = moment().add(1, 'months');
			  		let newDate = newDateMoment.toDate();
					$('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
					rmUpdateEndDate(newDate);
					
					//reset the roadmap animation variables
					roadmapStepCount = 1;
					roadmapTimer = null;
					console.log('Resetting roadmap animation');
				}
			
				//the list of roadmaps associated with elements
				var rmRoadmaps = {
					'rmRoadmaps': [
						<xsl:apply-templates mode="RenderGenericRoadmapJSON" select="$relevantRoadmaps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					]
				};
				
				//the list of strategic plans associated with elements
				var rmStrategicPlans = {
					'rmStrategicPlans': [
						<xsl:apply-templates mode="RenderStrategicPlanJSON" select="$relevantStrategicPlans">
							<xsl:sort select="own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
						</xsl:apply-templates>
					]
				};
					
				//the list of architecture states associated with elements
				var rmArchStates = {
					'rmArchStates': [
						<xsl:apply-templates mode="RenderArchStateJSON" select="$relevantArchStates">
							<xsl:sort select="own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
						</xsl:apply-templates>
					]
				};
				
				//the list of objectives met by strategic plans or architecture states
				var rmObjectives = {
					'rmObjectives': [
						<xsl:apply-templates mode="RenderRoadmapObjectiveJSON" select="$relevantObjectives">
							<xsl:sort select="own_slot_value[slot_reference = ('bo_target_date_iso_8601', 'ao_target_date_iso_8601', 'io_target_date_iso_8601', 'tao_target_date_iso_8601')]/value"/>
						</xsl:apply-templates>
					]
				};
				
				//register Handlebars helper to determine if an element has been created
				Handlebars.registerHelper('rmIsCreated', function(rmStatus, options) {
				    var fnTrue = options.fn, 
				        fnFalse = options.inverse;
				
					if(rmStatus == '<xsl:value-of select="$createStatusValue"/>') {
						return fnTrue(this);
					} else {
						return fnFalse(this);
					}
				});	
				
				//register Handlebars helper to determine if an element has been enhanced
				Handlebars.registerHelper('rmIsEnhanced', function(rmStatus, options) {
				    var fnTrue = options.fn, 
				        fnFalse = options.inverse;
				
					if(rmStatus == '<xsl:value-of select="$enhanceStatusValue"/>') {
						return fnTrue(this);
					} else {
						return fnFalse(this);
					}
				});	
				
				//register Handlebars helper to determine if an element has been reduced in usage
				Handlebars.registerHelper('rmIsReduced', function(rmStatus, options) {
				    var fnTrue = options.fn, 
				        fnFalse = options.inverse;
				
					if(rmStatus == '<xsl:value-of select="$reduceStatusValue"/>') {
						return fnTrue(this);
					} else {
						return fnFalse(this);
					}
				});	
				
				//register Handlebars helper to determine if an element has been removed
				Handlebars.registerHelper('rmIsRemoved', function(rmStatus, options) {
				    var fnTrue = options.fn, 
				        fnFalse = options.inverse;
				
					if(rmStatus == '<xsl:value-of select="$removeStatusValue"/>') {
						return fnTrue(this);
					} else {
						return fnFalse(this);
					}
				});	
				
				//register Handlebars helper to determine if an element is unchanged
				Handlebars.registerHelper('rmIsUnchanged', function(rmStatus, options) {
				    var fnTrue = options.fn, 
				        fnFalse = options.inverse;
				
					if(rmStatus == '<xsl:value-of select="$unchangedStatusValue"/>') {
						return fnTrue(this);
					} else {
						return fnFalse(this);
					}
				});	
				
				//register Handlebars helper to determine if an element has been changed
				Handlebars.registerHelper('rmIsChanged', function(rmStatus, options) {
				    var fnTrue = options.fn, 
				        fnFalse = options.inverse;
				
					if(rmStatus != '<xsl:value-of select="$unchangedStatusValue"/>') {
						return fnTrue(this);
					} else {
						return fnFalse(this);
					}
				});	
				
				//function to update the start date of the roadmap
				function rmUpdateStartDate(newDate) {
					rmStartDate = newDate;
					rmStartDateString = formatDate(rmStartDate);				
					$('#rm-button-start-date').text(niceFormatDate(rmStartDate));
					
					//redraw the view
					redrawView();			

					updateTimeline();
				}
				
				//function to update the end date of the roadmap
				function rmUpdateEndDate(newDate) {
					rmEndDate = newDate;
					rmEndDateString = formatDate(rmEndDate);
					$('#rm-button-end-date').text(niceFormatDate(rmEndDate));
					
					//redraw the view
					redrawView();
					
					updateTimeline();
				}
				
				//function to get a list of objectives in scope for the start and end dates
				function getRelevantObjectives() {
					startDateString = formatDate(rmStartDate);
					endDateString = formatDate(rmEndDate);
					
					relevantObjectives = [];
					for (var i = 0; rmObjectives.rmObjectives.length > i; i += 1) {
						anObjective = rmObjectives.rmObjectives[i];
						if((anObjective.targetDate >= startDateString) &amp;&amp; (anObjective.targetDate &lt;= endDateString)) {
							relevantObjectives.push(anObjective);
						}
					}
					return relevantObjectives;
				}
				
				//function to set the roadmapStatus and isVisible properties of a given list of elements based on the given start and end dates
				function rmSetElementListRoadmapStatus(elementArrays) {
					var elements, anElement;

					//reset the lists of raodmap changes
					initRoadmapChanges();
					
					//set the roadmap status of all relevant roadmap aware elements
					for (var i = 0; elementArrays.length > i; i += 1) {
						elements = elementArrays[i];
						for (var j = 0; elements.length > j; j += 1) {
							anElement = elements[j];
							//Set the roadmap status of the element
							rmSetElementRoadmapStatus(anElement);		
						}
					}
				}
				
				//function to set the roadmap related properties of the given element based on the given start and end dates
				function rmSetElementRoadmapStatus(element) {
					
					if(!roadmapEnabled) {
						element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
						element.roadmap.rmStyle = rmNoChangeStyle;
						element.roadmap.isVisible = true;
						element.roadmap.plansForPeriod = [];
						element.roadmap.objectivesForPeriod = [];
					} 
					else if(element.roadmap.strategicPlans.length > 0) {
						rmSetElementStrategicPlanRoadmapStatus(element);			
					} 
					else if(element.roadmap.archStates.length > 0) {
						rmSetElementArchStateRoadmapStatus(element);			
					} else {
						element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
						element.roadmap.rmStyle = rmNoChangeStyle;
						element.roadmap.isVisible = true;
						element.roadmap.plansForPeriod = [];
						element.roadmap.objectivesForPeriod = [];
					}
				}
				
				
				//function to update the roadmap status of an element based on its associated strategic plans
				function rmSetElementStrategicPlanRoadmapStatus(element) {
					var aStrategicPlan, anObjective;
					var relevantStratgicPlans = [];
					var strategicPlansForPeriod = [];
					var relevantObjectives = [];
					var createdInFuture = false;
					
					var strategicPlans = element.roadmap.strategicPlans;
					for (var i = 0; strategicPlans.length > i; i += 1) {
						aStrategicPlan = strategicPlans[i];
						if(aStrategicPlan.endDate &lt;= rmEndDateString) {
							relevantStratgicPlans.push(aStrategicPlan);
							
							if(aStrategicPlan.startDate >= rmStartDateString) {
								strategicPlansForPeriod.push(aStrategicPlan);
								
								//Add any objectives supported by the strategic plan that have a target date less than or equal to the given end date
								fullStrategicPlan = getObjectById(rmStrategicPlans.rmStrategicPlans, 'id', aStrategicPlan.id);
								for (var j = 0; fullStrategicPlan.objectives.length > j; j += 1) {
									anObjectiveId = fullStrategicPlan.objectives[j];
									if(anObjectiveId != null) {
										anObjective = getObjectById(rmObjectives.rmObjectives, 'id', anObjectiveId);				
										if((anObjective != null) &amp;&amp; (anObjective.targetDate &lt;= rmEndDateString)) {
											relevantObjectives.push(anObjectiveId);
										}
									}
								}
							}
						}  
						else { 
							//identify whether this plan has a create effect for the element in the future
							if(aStrategicPlan.roadmapStatus == '<xsl:value-of select="$createStatusValue"/>') {
								createdInFuture = true;
							}
						}
					}
					//set the element's plans and objectives that are relevenat for the given start and end dates
					element.roadmap.plansForPeriod = strategicPlansForPeriod;
					//element.roadmap.objectivesForPeriod = relevantObjectives.unique()
					
					//Update the roadmapStatus, styling and isVisible properties of the element				
					var relevantPlanCount = relevantStratgicPlans.length;
					
					//if there are one or more strategic plans for the period, add the element to list of changes
					if(relevantPlanCount > 0) {
						rmRoadmapChanges[element.roadmap.rmEALayer].push(element);
					}
					
					//if the element is created past the given end date, set the element to not visible
					if(createdInFuture) {
						element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
						element.roadmap.rmStyle = rmRemoveStyle;
						element.roadmap.isVisible = false;
					}  //the element's status is determined by the last plan before the end date
					else if(relevantPlanCount > 0) {
						var lastPlan = relevantStratgicPlans[relevantPlanCount - 1];	
						
						//set the status to unchanged, visible and with default styling if the element has no plans before the start date and not been removed before the given start date
						if((lastPlan.endDate &lt; rmStartDateString) &amp;&amp; !(lastPlan.roadmapStatus == '<xsl:value-of select="$removeStatusValue"/>')) { 
							element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
							element.roadmap.rmStyle = rmNoChangeStyle;
							element.roadmap.isVisible = true;
						} else {
							element.roadmap.roadmapStatus = lastPlan.roadmapStatus;
							element.roadmap.rmStyle = lastPlan.rmStyle;
							element.roadmap.isVisible = lastPlan.visibility;
							rmRoadmapChangeList.push(element);
							element.roadmap.plansForPeriod = relevantStratgicPlans;
						}
					} //if there are no plans before the end date and it is not created in the future, then set to visible with default styling
					else {
						element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
						element.roadmap.rmStyle = rmNoChangeStyle;
						element.roadmap.isVisible = true;
					}
				}
				
				
				//function to update the roadmap status of an element based on its associated architecture states
				function rmSetElementArchStateRoadmapStatus(element) {
					var anArchState, anObjective;
					var relevantArchStates = [];
					var archStatesForPeriod = [];
					var relevantObjectives = [];
					var createdInFuture = false;
					
					var thisArchStates = element.roadmap.archStates;
					for (var i = 0; thisArchStates.length > i; i += 1) {
						anArchState = thisArchStates[i];
						if(anArchState.startDate &lt;= rmEndDateString) {
							relevantArchStates.push(anArchState);
							
							//Add any objectives supported by the architecture state that have a target date less than or equal to the given end date
							fullArchState = getObjectById(rmArchStates.rmArchStates, 'id', anArchState.id);
							for (var j = 0; fullArchState.objectives.length > j; j += 1) {
								anObjectiveId = fullArchState.objectives[j];
								if(anObjectiveId != null) {
									anObjective = getObjectById(rmObjectives.rmObjectives, 'id', anObjectiveId);				
									if((anObjective != null) &amp;&amp; (anObjective.targetDate &lt;= rmEndDateString)) {
										relevantObjectives.push(anObjectiveId);
									}
								}
							}
						}  
						else { 
							//identify whether this arch state has a create effect for the elementafter the roadmap end date
							if(anArchState.roadmapStatus == '<xsl:value-of select="$createStatusValue"/>') {
								createdInFuture = true;
							}
						}
					}
					//set the element's architecture states and objectives that are relevant for the given start and end dates
					element.roadmap.archStatesForPeriod = relevantArchStates;
					//element.roadmap.objectivesForPeriod = relevantObjectives.unique()
					
					//Update the roadmapStatus, styling and isVisible properties of the element				
					var relevantArchStateCount = relevantArchStates.length;
					
					
					//if the element is created past the given end date, set the element to not visible
					if(createdInFuture) {
						element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
						element.roadmap.rmStyle = rmRemoveStyle;
						element.roadmap.isVisible = false;
					} //the element's status is determined by the last arch state before the end date
					else if(relevantArchStateCount > 0) {
						var lastArchState = relevantArchStates[relevantArchStateCount - 1];	
						
						//set the status to unchanged, visible and with default styling if the element has no plans before the start date and not been removed before the given start date
						if((lastArchState.endDate &lt; rmStartDateString) &amp;&amp; !(lastArchState.roadmapStatus == '<xsl:value-of select="$removeStatusValue"/>')) { 
							element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
							element.roadmap.rmStyle = rmNoChangeStyle;
							element.roadmap.isVisible = true;
						} else {
							element.roadmap.roadmapStatus = lastArchState.roadmapStatus;
							element.roadmap.rmStyle = lastArchState.rmStyle;
							element.roadmap.isVisible = lastArchState.visibility;
							
							//if the status of element has changed withi the selected time frame, add the lement to list of changes
							if (lastArchState.roadmapStatus != '<xsl:value-of select="$unchangedStatusValue"/>') {
								rmRoadmapChanges[element.roadmap.rmEALayer].push(element);
								rmRoadmapChangeList.push(element);
							}
						}
					}  //if there are no arch state before the end date and it is not created in the future, then set to visible with default styling
					else {
						element.roadmap.roadmapStatus = '<xsl:value-of select="$unchangedStatusValue"/>';
						element.roadmap.rmStyle = rmNoChangeStyle;
						element.roadmap.isVisible = true;
					}
				}
				
				
				//function that returns an array containing only the given elements that are visible
				function rmGetVisibleElements(elements) {
					var filteredElements = [];
					var anElement;
					for (var i = 0; elements.length > i; i += 1) {
						anElement = elements[i];
						if(anElement.roadmap.isVisible) {
							filteredElements.push(anElement);
						}
					}
					
					return filteredElements;
				}
				
				
				
				//function to set the roadmap styles of DOM elements in the view
				function setDOMRoadmapStyles() {
					$('.rmTextContainer', rmRoadmapAwareElements).each(function(index ) {
						elementMenu = $(this).attr('eas-menu');
						elementStyle = $(this).attr('eas-style');
						anchorStyle = elementMenu + ' ' + elementStyle + '';
						
						anchor = $(this).children().first();
						anchor.removeClass();
						anchor.addClass(anchorStyle);
					});
				}
				
				//function to refresh the style of a DOM element
				function refreshDOMRoadmapStyles(elementId, elementHBTemplate, jsonData) {
					$(elementId).html(elementHBTemplate(jsonData)).promise().done(function(){
				        setDOMRoadmapStyles($(elementId));
				    });
				}
				
				
				//function to set the roadmap styles of DOM elements in the view
				function setDOMRoadmapStyles(inScopeElements) {
					$('.rmTextContainer', inScopeElements).each(function(index ) {
						elementMenu = $(this).attr('eas-menu');
						elementStyle = $(this).attr('eas-style');
						anchorStyle = elementMenu + ' ' + elementStyle + '';
						
						anchor = $(this).children().first();
						anchor.removeClass();
						anchor.addClass(anchorStyle);
					});
				}
				
				//function to register a datatable event listener for after it has been drawn
				function registerRoadmapDatatable(table) {
					table.on( 'draw', function () {
						setDataTableRoadmapStyles($(this));
					});
				}
				
				//function to set the roadmap styles of anchors (links) in the view
				function setDataTableRoadmapStyles(table) {
					$('.rmTextContainer', table).each(function(index ) {
						elementMenu = $(this).attr('eas-menu');
						elementStyle = $(this).attr('eas-style');
						anchorStyle = elementMenu + ' ' + elementStyle + '';
						
						anchor = $(this).children().first();
						anchor.removeClass();
						anchor.addClass(anchorStyle);
					});
					
					addInfoPopupListeners();
				}
				
				function addInfoPopupListeners() {
					$('.rm-change-popup').click(function() {
                        $('[role="tooltip"]').remove();
                    });
                    
                    $('.rm-change-popup').popover({
                        container: 'body',
                        html: true,
                        trigger: 'click',
                        content: function(){
                            return $(this).next().html();
                        }
                    });
				}
				
				
				<!-- function to draw the table of elements that have been changed within the selected roadmap period -->
				function rmDrawChangedElementsTable() {
					if(rmChangedElementsTable == null) {
						
						// Setup - add a text input to each footer cell
					    $('#rmChangedElementsTable tfoot th').each( function() {
					        	var title = $(this).text();
					        	$(this).html( '&lt;input class="rmChangedElementsTableSearch" type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
						
						//create the table
						rmChangedElementsTable = $('#rmChangedElementsTable').DataTable({
							scrollY: "250px",
							scrollCollapse: true,
							paging: false,
							info: false,
							sort: true,
							responsive: false,
							data: rmRoadmapChangeList,
							columns: [	
							    { <!-- Layer -->
							    	"data" : "id",
							    	"width": "10%",
							    	"render": function(data, type, row, meta){
						                if(row !== null){              
						                    return rmEALayerTemplate(row);
						                } else {
						                    return "";
						                }
						            }
							    },
							    { <!-- Type -->
							    	"data" : "id",
							    	"width": "20%",
							    	"render": function(data, type, row, meta){
						                if(row !== null){              
						                    return rmMetaclassTemplate(row);
						                } else {
						                    return "";
						                }
						            }
							    },
							    { <!-- Element Link -->
							    	"data" : "id",
							    	"width": "30%",
							    	"render": function(data, type, row, meta){
						                if(row !== null){              
						                    return rmElementLinkTemplate(row);
						                } else {
						                    return "";
						                }
						            }
							    },
							    <!--{  <!-\- Element Description -\->
							    	"data" : "description",
							    	"width": "20%"
							    },-->
							    {  <!-- Change -->
							    	"data" : "id",
							    	"width": "15%",
							    	"render": function(data, type, row, meta){
						                if(row !== null){              
						                    return rmElementPlansTemplate(row);
						                } else {
						                    return "";
						                }
						            }
							    },
							    <!--{  <!-\- Plan/Arch State Description -\->
							    	"data" : "roadmap",
							    	"width": "15%",
							    	"render": function(d){
						                if(d !== null){              
						                    return "Plan/Arch State Description";
						                } else {
						                    return "";
						                }
						            }
							    },-->
							    {  <!-- Plan/Arch State Start Date -->
							    	"data" : "id",
							    	"width": "10%",
							    	"render": function(data, type, row, meta){
						                if(row !== null){
						                    for (var i = 0; row.roadmap.plansForPeriod.length > i; i += 1) {
						                    	var aPlan = row.roadmap.plansForPeriod[i];
						                    	if(aPlan.startDate.length > 0) {
						                    		return moment(aPlan.startDate, "YYYY-MM-DD").format('Do MMM YYYY') + '<br/>';
												}
						                    	else {
						                    		return "NO PLAN START DATE <br/>";
						                    	}
						                    }
						                    if(row.roadmap.plansForPeriod.length == 0) {
						                    	for (var i = 0; row.roadmap.archStatesForPeriod.length > i; i += 1) {
							                    	var anArchState = row.roadmap.archStatesForPeriod[i];
							                    	if(anArchState.startDate.length > 0) {
							                    		return moment(anArchState.startDate, "YYYY-MM-DD").format('Do MMM YYYY') + '<br/>';
													}
							                    	else {
							                    		return "NO ARCH STATE START DATE <br/>";
							                    	}
							                    }
						                    } else {
						                    	return "";
						                    }
						                } else {
						                    return "";
						                }
						            }
							    },
							    {  <!-- Plan/Arch State End Date -->
							    	"data" : "id",
							    	"width": "10%",
							    	"render": function(data, type, row, meta){
						                if(row !== null){
						                    for (var i = 0; row.roadmap.plansForPeriod.length > i; i += 1) {
						                    	var aPlan = row.roadmap.plansForPeriod[i];
						                    	if(aPlan.endDate.length > 0) {
						                    		return moment(aPlan.endDate, "YYYY-MM-DD").format('Do MMM YYYY') + '<br/>';
												}
						                    	else {
						                    		return "<br/>";
						                    	}
						                    }
						                    if(row.roadmap.plansForPeriod.length == 0) {
						                    	for (var i = 0; row.roadmap.archStatesForPeriod.length > i; i += 1) {
							                    	var anArchState = row.roadmap.archStatesForPeriod[i];
							                    	if(anArchState.endDate.length > 0) {
							                    		return moment(anArchState.endDate, "YYYY-MM-DD").format('Do MMM YYYY') + '<br/>';
													}
							                    	else {
							                    		return "<br/>";
							                    	}
							                    }
						                    } else {
						                    	return "";
						                    }
						                } else {
						                    return "";
						                }
						            }
							    }
							 ],
							 "order": [[0, 'asc']],
							  dom: 'frtip'
						});
						
											
						// Apply the search
					    rmChangedElementsTable.columns().every( function () {
					        var that = this;
					 
					        $( '.rmChangedElementsTableSearch', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    rmChangedElementsTable.columns.adjust();
					    
					    $(window).resize( function () {
					        rmChangedElementsTable.columns.adjust();
					    });
					    
					    registerRoadmapDatatable(rmChangedElementsTable);
					}
				}
				
				//function to update the Roadmap Changes table
				function rmUpdateChangedElementsTable() {
					if(rmChangedElementsTable == null) {
						rmDrawChangedElementsTable();
					} else {
						rmChangedElementsTable.clear();
						rmChangedElementsTable.rows.add(rmRoadmapChangeList);
					}
					rmChangedElementsTable.draw();
				}

				

				//function to update the timeline
				function updateTimeline() {
					//remove all events representing objectives from the timeline
					objectiveRefs = [];
					for (var i = 0; rmRelevantObjectives.length > i; i += 1) {
						objectiveRefs.push(rmRelevantObjectives[i].ref);
					}
					$("#myTimeline").timeline('removeEvent', objectiveRefs);
					
					
					//update the start date point
					$("#myTimeline").timeline('updateEvent', [{eventId: 1, row: 1, start: rmStartDateString, bdColor: '#333', bgColor: '#fff', image: 'images/fa-svg/black/png/256/flag-o.png', margin: 10, label: '<xsl:value-of select="$rmStartDateLabel"/>', content:'<xsl:value-of select="$rmStartDateDescription"/>' } ]);
					
					//update the end date point
					$("#myTimeline").timeline('updateEvent', [{eventId: 2, row: 1, start:rmEndDateString, bdColor: '#333', bgColor: '#333', image: 'images/fa-svg/white/png/256/flag-checkered.png', margin: 10, label: '<xsl:value-of select="$rmEndDateLabel"/>', content:'<xsl:value-of select="$rmEndDateDescription"/>'<!--, relation: {before: 1, linesize: 10, linecolor: '#4f8956'}-->} ]);
					
					//add timeline events representing the relevant objectives
					rmRelevantObjectives = getRelevantObjectives();
					for (var j = 0; rmRelevantObjectives.length > j; j += 1) {
						anObjective = rmRelevantObjectives[j];
						anObjectiveTitle = anObjective.type + ': ' + anObjective.name;
						if(j % 2 == 0) {
							rowNo = 2;
						} else {
							rowNo = 1;
						}
						$("#myTimeline").timeline('addEvent', [{eventId: anObjective.ref, label: anObjectiveTitle, content: anObjective.description, row: rowNo, margin: 10, start: anObjective.targetDate, bdColor: '#4196D9', bgColor: '#4196D9', image: anObjective.icon }]);
					}
					$(".timeline-event-view").html('');
					
					//update the roadmap changes section
					rmUpdateChangedElementsTable();
					<!--$("#rmRoadmapChangesDiv").html(rmChangesTemplate(rmRoadmapChanges));
					setDOMRoadmapStyles($('#rmRoadmapChangesDiv'));-->
					
				}
				
				$(document).ready(function(){
					//create the roodmap panel
					var rmPanelFragment   = $("#rm-roadmap-panel-template").html();
					var rmPanelTemplate = Handlebars.compile(rmPanelFragment);
					$("#rmRoadmapPanel").html(rmPanelTemplate());
					
					//create the handlebars templates for the roodmap changes section
					$.fn.dataTable.moment('Do MMM YYYY');
					
					var rmEALayerFragment   = $("#rm-ea-layer-template").html();
					rmEALayerTemplate = Handlebars.compile(rmEALayerFragment);
					
					var rmMetaclassFragment   = $("#rm-metaclass-template").html();
					rmMetaclassTemplate = Handlebars.compile(rmMetaclassFragment);
					
					var rmElementLinkFragment   = $("#rm-element-link-template").html();
					rmElementLinkTemplate = Handlebars.compile(rmElementLinkFragment);
					
					var rmElementPlansFragment   = $("#rm-element-plans-template").html();
					rmElementPlansTemplate = Handlebars.compile(rmElementPlansFragment);
					
					<!--var rmChangesFragment   = $("#rm-roadmap-changes-template").html();
					rmChangesTemplate = Handlebars.compile(rmChangesFragment);-->
				
					<!-- Roadmap animation listeners -->
					$('#playRoadmap').on('click', function(evt) {
						//start roadmap animation
						startRoadmapAnimation();
						$('.rm-animation-btn').removeClass('rm-btn-active');
						$('#playRoadmap').addClass('rm-btn-active');
						$('#pauseRoadmap').removeClass('rm-btn-disabled');
						$('#resetRoadmap').removeClass('rm-btn-disabled');
					});
					
					$('#pauseRoadmap').on('click', function(evt) {
						if(!$(this).hasClass('rm-btn-disabled')) {
							//pause roadmap animation
							endRoadmapAnimation();
							$('.rm-animation-btn').removeClass('rm-btn-active');
							$('#pauseRoadmap').addClass('rm-btn-active');
						}
					});
					
					$('#resetRoadmap').on('click', function(evt) {
						if(!$(this).hasClass('rm-btn-disabled')) {
							//reset roadmap animation
							resetRoadmapAnimation();
							$('.rm-animation-btn').removeClass('rm-btn-active');
							$('#resetRoadmap').addClass('rm-btn-disabled');
							$('#pauseRoadmap').addClass('rm-btn-disabled');
						}
					});
					
					$("#rmEnabledCheckbox").change(function() {
						if($(this).prop( "checked" )) {
							//console.log('Roadmap Enabled');
							$("#myTimeline").timeline('show');
							$('#rmStartDateSelect').MonthPicker('Enable');
							$('#rmEndDateSelect').MonthPicker('Enable');
							$('#rmChangesPanel').show();
							roadmapEnabled = true;
							// Update the Roadmap Widget Button
							$('#rm-button-active').show();
							$('#rm-button-inactive').hide();
						} else {
							//console.log('Roadmap Disabled');
							$("#myTimeline").timeline('hide');
							$('#rmStartDateSelect').MonthPicker('Disable');
							$('#rmEndDateSelect').MonthPicker('Disable');
							$('.timeline-event-view').html('');
							$('#rmChangesPanel').hide();
							roadmapEnabled = false;
							// Update the Roadmap Widget Button
							$('#rm-button-active').hide();
							$('#rm-button-inactive').show();
						}
						//redraw the view
						redrawView();		
					});
					
					//initalise the start and end date selectors
					rmInitDates();
					$('#rmStartDateSelect').MonthPicker({
						ShowIcon: true,
						ButtonIcon: 'ui-icon-calendar',
						ShowOn: 'both',
						UseInputMask: true,
						Animation: 'fadeToggle',
						SelectedMonth: 0,
						OnAfterChooseMonth: function( selectedDate ){
							if(rmDateIsValid(selectedDate, rmEndDate)) {
								$('#rmDateError').html('');
								y = selectedDate.getFullYear(), m = selectedDate.getMonth();
								newDate = new Date(y, m, 1);
								$('#rmWidgetStartDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
								rmUpdateStartDate(newDate);
							} else {
								$('#rmDateError').html('Start date must be before end date');
								$('#rmStartDateSelect').MonthPicker('option', 'SelectedMonth', rmStartDate);
							}
						} 
					});
					
					$('#rmEndDateSelect').MonthPicker({
						ShowIcon: true,
						ButtonIcon: 'ui-icon-calendar',
						ShowOn: 'both',
						UseInputMask: true,
						Animation: 'fadeToggle',
						SelectedMonth: 0,
						OnAfterChooseMonth: function( selectedDate ){
							if(rmDateIsValid(rmStartDate, selectedDate)) {
								$('#rmDateError').html('');
								y = selectedDate.getFullYear(), m = selectedDate.getMonth();
								newDate = new Date(y, m + 1, 0);
								$('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
								rmUpdateEndDate(newDate);
							} else {
								$('#rmDateError').html('End date miust be after start date');
								$('#rmEndDateSelect').MonthPicker('option', 'SelectedMonth', rmEndDate);
							}
						} 
					});
					
					
					$('#rmWidgetStartDateSelect').MonthPicker({
						ShowIcon: false,
						ButtonIcon: 'ui-icon-calendar',
						ShowOn: 'both',
						UseInputMask: true,
						Animation: 'fadeToggle',
						SelectedMonth: 0,
						OnAfterChooseMonth: function( selectedDate ){
							if(rmDateIsValid(selectedDate, rmEndDate)) {
								$('#rmDateError').html('');
								y = selectedDate.getFullYear(), m = selectedDate.getMonth();
								newDate = new Date(y, m, 1);
								$('#rmStartDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
								rmUpdateStartDate(newDate);
							} else {
								$('#rmWidgetStartDateSelect').MonthPicker('option', 'SelectedMonth', rmStartDate);
							}
						} 
					});
					
					
					$('#rmWidgetEndDateSelect').MonthPicker({
					    ShowIcon: false,
					    ButtonIcon: 'ui-icon-calendar',
					    ShowOn: 'both',
					    UseInputMask: true,
					    Animation: 'fadeToggle',
					    SelectedMonth: 0,
					    OnAfterChooseMonth: function( selectedDate ){
						    if(rmDateIsValid(rmStartDate, selectedDate)) {
							    y = selectedDate.getFullYear(), m = selectedDate.getMonth();
							    newDate = new Date(y, m + 1, 0);	
							    $('#rmEndDateSelect').MonthPicker('option', 'SelectedMonth', newDate);
							    rmUpdateEndDate(newDate);
						    } else {
						    	$('#rmWidgetEndDateSelect').MonthPicker('option', 'SelectedMonth', rmEndDate);
						    }
					    } 
					});
					
					<!--$('#rmStartDateSelect').MonthPicker().css('backgroundColor', 'lightyellow');-->
				
					// Initialise the Roadmap Widget Button dates
					$('#rm-button-start-date').text(niceFormatDate(rmStartDate));
					$('#rm-button-end-date').text(niceFormatDate(rmEndDate));
					
					<!--$('#rm-button-start-date').text(rmStartDateString);
					$('#rm-button-end-date').text(rmEndDateString);-->
					
				
					//Initialise the timeline
					$("#myTimeline").timeline({
						type: 'point',
					  	scale: 'years',
					  	range: 10,
					  	showHeadline: false,
					  	rows: 2,
					  	rowHeight: 60,
					  	datetimeFormat: { meta: 'g:i A, D F j, Y' },
					  	rangeAlign: 'left',
					  	langsDir: 'js/jquery-timeline/langs/'
					});
					
					//Initialise the start and end date events
					<!--var currentDate = new Date().toISOString();
					$("#myTimeline").timeline('addEvent', [ {start:'2018-07-24 00:00', row:1,label:'Start Date',content:'The start date'} ], function( self, data ){ console.log('Added Start Event!'); });-->
				
				});
			</script>
			
			<!-- Handlebars template to render the Roadmap Panel section -->
			<script id="rm-roadmap-panel-template" type="text/x-handlebars-template">
				
				<div class="rmDate">
					<label for="rmStartDateSelect">View Changes From:</label>
					<input id="rmStartDateSelect" type="text"/>
				</div>
				<div class="rmDate">
					<label for="rmEndDateSelect" class="alignCentre">To:</label>
					<input id="rmEndDateSelect" type="text"/>
				</div>
				<p id="rmDateError" class="textColourRed"/>
				
				<!-- Timeline Block -->
				<div class="clearfix"/>
				<div id="myTimeline">
					<xsl:variable name="rmCurrentDateString"><xsl:call-template name="JSFormatDate"><xsl:with-param name="theDate" select="current-date()"/></xsl:call-template></xsl:variable>
					<ul class="timeline-events">
					    <li>
					    	<xsl:attribute name="data-timeline-node">{eventId: 1, row: 1, margin: 10, start:'<xsl:value-of select="functx:add-months($rmCurrentDateString, -1)"/>', bdColor: '#333', bgColor: '#fff', image: 'images/fa-svg/black/png/256/flag-o.png', content:'<xsl:value-of select="$rmStartDateDescription"/>' }</xsl:attribute>
					    	<xsl:value-of select="$rmStartDateLabel"/>
					    </li>
					    <li>
					    	<xsl:attribute name="data-timeline-node">{eventId: 2, row: 1, margin: 10, start:'<xsl:value-of select="$rmCurrentDateString"/>', bdColor: '#333', bgColor: '#333', image: 'images/fa-svg/white/png/256/flag-checkered.png', content:'<xsl:value-of select="$rmEndDateDescription"/>'}</xsl:attribute>
					    	<xsl:value-of select="$rmEndDateLabel"/>
					    </li>
					</ul>
				</div>
				<!-- Timeline Event Detail View Area -->
				<div class="timeline-event-view"/>
				
			</script>
			
			
			<!-- Handlebars template to render the Roadmap Changes section -->
			<script id="rm-roadmap-changes-template" type="text/x-handlebars-template">
				
				<div class="rm-panel-wrapper bg-white top-15">
				<h3 class="xlarge fontBold"><i class="fa fa-list-ul right-5"/>Roadmap Changes</h3>
				{{#if business.length}}
					<h3>Business</h3>
					<ul>
						{{#each business}}
							<li>
								<xsl:call-template name="RenderHandlebarsRoadmapChangeDOMContents"/>
							</li>
						{{/each}}
					</ul>			
				{{/if}}
				{{#if information.length}}
					<h3>Information/Data</h3>
					<ul>
						{{#each information}}
							<li>
								<xsl:call-template name="RenderHandlebarsRoadmapChangeDOMContents"/>
							</li>
						{{/each}}
					</ul>
				{{/if}}
				{{#if application.length}}
					<h3 class="fontLight">Application</h3>
					{{#each application}}
							<xsl:call-template name="RenderHandlebarsRoadmapChangeDOMContents"/>				
					{{/each}}
				{{/if}}
				{{#if technology.length}}
					<h3>Technology</h3>
					<ul>
						{{#each technology}}
							<li>
								<xsl:call-template name="RenderHandlebarsRoadmapChangeDOMContents"/>
							</li>
						{{/each}}
					</ul>
				{{/if}}
				{{#if other.length}}
					<h3>Other</h3>
					<ul>
						{{#each other}}
							<li>
								<xsl:call-template name="RenderHandlebarsRoadmapChangeDOMContents"/>
							</li>
						{{/each}}
					</ul>
				{{/if}}
				</div>
			</script>
			
			<!-- Handlebars template to render the EA Layer of an element -->
			<script id="rm-ea-layer-template" type="text/x-handlebars-template">
				<span class="rm-ea-layer-text">{{roadmap.rmEALayer}}</span>
			</script>
			
			
			<!-- Handlebars template to render the meta-class for an element -->
			<script id="rm-metaclass-template" type="text/x-handlebars-template">
				<i><xsl:attribute name="class">right-10 {{roadmap.rmMetaClassStyle.styleIcon}} {{roadmap.rmMetaClassStyle.styleClass}}</xsl:attribute></i>
				<span><xsl:attribute name="class">right-10 {{roadmap.rmMetaClassStyle.styleClass}}</xsl:attribute>{{roadmap.rmMetaClassStyle.styleLabel}}</span>
			</script>
			
			<!-- Handlebars template to render a link for a roadmpa enabled element -->
			<script id="rm-element-link-template" type="text/x-handlebars-template">
				<span>
					<xsl:attribute name="id">{{id}}</xsl:attribute>
					<xsl:attribute name="class">rmTextContainer</xsl:attribute>
					<xsl:attribute name="eas-menu">{{menu}}</xsl:attribute>
					<xsl:attribute name="eas-style">rm-plain-text</xsl:attribute>
					{{{roadmap.rmLink}}}{{#if description.length}}<i class="left-10 rm-change-popup fa fa-info-circle"/><div class="text-default xsmall hiddenDiv">{{description}}</div>{{/if}}
				</span>
			</script>
			
			<!-- Handlebars template to render a list of planned changes for a given element -->
			<!--<script id="rm-element-plans-template" type="text/x-handlebars-template">
				<span>
					<i><xsl:attribute name="class">right-10 {{roadmap.rmStyle.styleClass}} {{roadmap.rmStyle.styleIcon}}</xsl:attribute></i>
					{{{roadmap.roadmapStatus}}}
				</span>
			</script>-->
			<script id="rm-element-plans-template" type="text/x-handlebars-template">
				{{#each roadmap.plansForPeriod}}
					<span>
						<xsl:attribute name="class">{{rmStyle.styleClass}}</xsl:attribute>
						<i><xsl:attribute name="class">right-10 rm-change-popup {{rmStyle.styleIcon}} {{rmStyle.styleClass}}</xsl:attribute></i>{{#if description.length}}<div class="text-default xsmall hiddenDiv">{{description}}</div>{{/if}}
						{{{roadmapStatus}}}
					</span>{{#unless @last}}<br/>{{/unless}}
				{{/each}}
				{{#unless roadmap.plansForPeriod.length}}
					<span>
						<xsl:attribute name="class">{{roadmap.rmStyle.styleClass}}</xsl:attribute>
						<i><xsl:attribute name="class">right-10 {{roadmap.rmStyle.styleIcon}}</xsl:attribute></i>
						{{{roadmap.roadmapStatus}}}
					</span>
				{{/unless}}
			</script>
			
			<div class="row">
				<div class="col-xs-12 rmPanel">
					<div class="rm-panel-wrapper bg-white">
						<h3 class="xlarge fontBold"><i class="fa fa-road right-5"></i>Roadmap Scope</h3>
						<p class="fontLight large"><xsl:value-of select="$rmRoadmapPanelIntro"/></p>
						<div id="rmRoadmapPanel"/>
					</div>
				</div>
				<div id="rmChangesPanel" class="col-xs-12 rmPanel top-20">
					<!--<div id="rmRoadmapChangesDiv"/>-->
					<div class="rm-panel-wrapper bg-white">
						<h3 class="xlarge fontBold"><i class="fa fa-exchange right-5"></i>Roadmap Changes</h3>
						<p class="fontLight large"><xsl:value-of select="$rmRoadmapChangesIntro"/></p>
						<table id="rmChangedElementsTable" class="table table-striped table-condensed small">
							<thead>
								<tr>
									<th><xsl:value-of select="eas:i18n('Layer')"/></th>
									<th><xsl:value-of select="eas:i18n('Type')"/></th>
									<th><xsl:value-of select="eas:i18n('Element')"/></th>
									<!--<th><xsl:value-of select="eas:i18n('Description')"/></th>-->
									<th class="bg-darkblue-120"><xsl:value-of select="eas:i18n('Change')"/></th>
									<!--<th class="bg-darkblue-120"><xsl:value-of select="eas:i18n('Rationale')"/></th>-->
									<th class="bg-darkblue-120"><xsl:value-of select="eas:i18n('Start Date')"/></th>
									<th class="bg-darkblue-120"><xsl:value-of select="eas:i18n('End Date')"/></th>
								</tr>
							</thead>
							<tbody/>
							<tfoot>
								<tr>
									<th><xsl:value-of select="eas:i18n('Layer')"/></th>
									<th><xsl:value-of select="eas:i18n('Type')"/></th>
									<th><xsl:value-of select="eas:i18n('Element')"/></th>
									<!--<th><xsl:value-of select="eas:i18n('Description')"/></th>-->
									<th><xsl:value-of select="eas:i18n('Change')"/></th>
									<!--<th><xsl:value-of select="eas:i18n('Rationale')"/></th>-->
									<th><xsl:value-of select="eas:i18n('Start Date')"/></th>
									<th><xsl:value-of select="eas:i18n('End Date')"/></th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
	</xsl:if>
		
	</xsl:template>
	
	<!-- RENDER THE CONTENTS OF A HANDLEBARS ROADMAP ENABLED DOM ELEMENT -->
	<xsl:template name="RenderHandlebarsRoadmapDOMContents">
		<xsl:attribute name="id">{{id}}</xsl:attribute>
		<xsl:attribute name="class">rmTextContainer</xsl:attribute>
		<xsl:attribute name="eas-menu">{{menu}}</xsl:attribute>
		<xsl:attribute name="eas-style">{{roadmap.rmStyle.styleClass}}</xsl:attribute>
		{{{link}}}<i><xsl:attribute name="class">left-10 {{roadmap.rmStyle.styleIcon}} {{roadmap.rmStyle.styleClass}}</xsl:attribute></i>
	</xsl:template>
	
	<!-- RENDER THE CONTENTS OF A HANDLEBARS ROADMAP ENABLED DOM ELEMENT -->
	<xsl:template name="RenderHandlebarsRoadmapChangeDOMContents">
		<i><xsl:attribute name="class">right-10 {{roadmap.rmMetaClassStyle.styleIcon}} {{roadmap.rmMetaClassStyle.styleClass}}</xsl:attribute></i>
		<span><xsl:attribute name="class">right-10 {{roadmap.rmMetaClassStyle.styleClass}}</xsl:attribute>{{roadmap.rmMetaClassStyle.styleLabel}}</span>
		<span>
			<xsl:attribute name="id">{{id}}</xsl:attribute>
			<xsl:attribute name="class">rmTextContainer</xsl:attribute>
			<xsl:attribute name="eas-menu">{{menu}}</xsl:attribute>
			<xsl:attribute name="eas-style">{{roadmap.rmStyle.styleClass}}</xsl:attribute>
			{{{roadmap.rmLink}}}<i><xsl:attribute name="class">left-10 {{roadmap.rmStyle.styleIcon}} {{roadmap.rmStyle.styleClass}}</xsl:attribute></i>
		</span><br/>
	</xsl:template>
	
	
	
	<!-- RENDER A ROADMAP ENABLED HANDLEBARS BULLET (<LI>) DOM ELEMENT -->
	<xsl:template name="RenderHandlebarsRoadmapBullet">
		<li>
			<xsl:call-template name="RenderHandlebarsRoadmapDOMContents"/>
		</li>
	</xsl:template>
	
	<!-- RENDER A ROADMAP ENABLED HANDLEBARS SPAN DOM ELEMENT -->
	<xsl:template name="RenderHandlebarsRoadmapSpan">
		<span>
			<xsl:call-template name="RenderHandlebarsRoadmapDOMContents"/>
		</span>
	</xsl:template>
	
	<!--<xsl:template name="RenderRoadmapWidgetButton">
		<div id="ess-roadmap-widget-button" class="bg-black text-white">
			<div>
				<i class="fa fa-calendar right-5"/>
				<strong>Roadmap</strong>: <span id="rm-button-active">
					<span id="rm-button-start-date"/><span> - </span><span id="rm-button-end-date"/></span><span id="rm-button-inactive" style="display: none;">Disabled</span></div>
		</div>
	</xsl:template>-->
	
	<xsl:template name="RenderRoadmapWidgetButton">
		<div id="ess-roadmap-widget-bar">
			<div class="pull-left" style="margin-top: 3px;">
				<span class="right-5"><strong>Roadmap Enabled?</strong></span>
				<input id="rmEnabledCheckbox" type="checkbox" checked="checked"/>
			</div>
			<div class="pull-right">
				<div class="pull-left">
					<span class="right-5"><strong>Roadmap:</strong></span>
					<span id="rm-button-active">
						<input id="rmWidgetStartDateSelect" class="ess-roadmap-widget-picker" type="text"/>
						<span class="left-10 right-10"><strong>to</strong></span>
						<input id="rmWidgetEndDateSelect" class="ess-roadmap-widget-picker" type="text"/>
					</span>
					<span id="rm-button-inactive" style="display: none;">Disabled</span>
				</div>
				<div class="pull-left" style="margin-top: 3px;">
					<div class="left-30">
						<i id="playRoadmap" class="rm-animation-btn fa fa-play-circle right-10"/>
						<i id="pauseRoadmap" class="rm-animation-btn rm-btn-disabled fa fa-pause-circle right-10"/>
						<i id="resetRoadmap" class="rm-animation-btn rm-btn-disabled fa fa-history right-10"/>
					</div>
				</div>
			</div>
		</div>
		<script>
			function enabledRoadmapButton(){
				$('#ess-roadmap-widget-toggle').parent().removeClass('disabled');
			}
			enabledRoadmapButton();
		</script>
	</xsl:template>
	
	<!-- FUNCTION TO DEFINE THE EA LAYER JSON PROPERTY VALUE FOR A GIVEN INSTANCE -->
	<xsl:function name="eas:rmGetInstanceEALayer" as="xs:string">
		<xsl:param name="theInstance" as="node()"/>
		
		<xsl:variable name="theInstanceSupertypes" select="$theInstance/supertype"/>
		<xsl:choose>
			<xsl:when test="$theInstanceSupertypes = 'Business_Layer'"><xsl:value-of select="eas:i18n('business')"/></xsl:when>
			<xsl:when test="$theInstanceSupertypes = 'Information_Layer'"><xsl:value-of select="eas:i18n('information')"/></xsl:when>
			<xsl:when test="$theInstanceSupertypes = 'Application_Layer'"><xsl:value-of select="eas:i18n('application')"/></xsl:when>
			<xsl:when test="$theInstanceSupertypes = 'Technology_Layer'"><xsl:value-of select="eas:i18n('technology')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="eas:i18n('other')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:function>
    
<xsl:template name="RenderRoadmapJSONPropertiesDataAPI">
		<xsl:param name="isRoadmapEnabled" select="false()"/>
		<xsl:param name="theDisplayInstance"/>
		<xsl:param name="theDisplayLabel"/>
		<xsl:param name="theRoadmapInstance"/>
		<xsl:param name="theTargetReport" select="()"/>
		<xsl:param name="allTheRoadmapInstances" select="()"/>
		
		
		<xsl:variable name="thisId"><xsl:value-of select="eas:getSafeJSString($theRoadmapInstance/name)"/></xsl:variable>
		
		<xsl:variable name="thisName">
			<xsl:choose>
				<xsl:when test="$theDisplayLabel">
					<xsl:value-of select="$theDisplayLabel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/>
				<xsl:with-param name="displayString" select="$thisName"/>
				<xsl:with-param name="targetReport" select="$theTargetReport"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDescription"><xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/></xsl:call-template></xsl:variable>
		
		<xsl:variable name="createPlansForElement" select="$rmCreatePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="enhancePlansForElement" select="$rmEnhancePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="reducePlansForElement" select="$rmReducePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="removePlansForElement" select="$rmRemovePlansForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $theRoadmapInstance/name]"/>
		<xsl:variable name="allPlansForElement" select="$createPlansForElement union $enhancePlansForElement union $reducePlansForElement union $removePlansForElement"/>
		<xsl:variable name="allThisPlans" select="$rmAllStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $allPlansForElement/name]"/>
		
		<xsl:variable name="thisRoadmapChangeName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$theRoadmapInstance"/></xsl:call-template></xsl:variable>
		<xsl:variable name="thisRoadmapLink"><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="targetReport" select="$theTargetReport"/><xsl:with-param name="theSubjectInstance" select="$theDisplayInstance"/><xsl:with-param name="displayString" select="$thisRoadmapChangeName"/></xsl:call-template></xsl:variable>
		
		
		<!-- Variable containing all architecture states that are relevant for elements that share the same class as the Roadmap instance -->
		<xsl:variable name="allTheRoadmapInstancesArchStates" select="$rmAllArchitectureStates[own_slot_value[slot_reference = ('arch_state_application_conceptual','arch_state_application_logical', 'arch_state_application_physical', 'arch_state_application_relations', 'arch_state_business_conceptual', 'arch_state_business_logical', 'arch_state_business_physical', 'arch_state_business_relations', 'arch_state_information_conceptual', 'arch_state_information_logical', 'arch_state_physical_information', 'arch_state_information_relations', 'arch_state_technology_conceptual', 'arch_state_technology_logical', 'arch_state_technology_physical', 'arch_state_technology_relations', 'arch_state_security_management', 'arch_state_strategy_management')]/value = $allTheRoadmapInstances/name]"/>
		<!-- Variable containing all architecture states that contain the Roadmap instance -->
		<xsl:variable name="allThisRoadmapInstanceArchStates" select="$rmAllArchitectureStates[own_slot_value[slot_reference = ('arch_state_application_conceptual','arch_state_application_logical', 'arch_state_application_physical', 'arch_state_application_relations', 'arch_state_business_conceptual', 'arch_state_business_logical', 'arch_state_business_physical', 'arch_state_business_relations', 'arch_state_information_conceptual', 'arch_state_information_logical', 'arch_state_physical_information', 'arch_state_information_relations', 'arch_state_technology_conceptual', 'arch_state_technology_logical', 'arch_state_technology_physical', 'arch_state_technology_relations', 'arch_state_security_management', 'arch_state_strategy_management')]/value = $theRoadmapInstance/name]"/>
		
		"id": "<xsl:value-of select="$thisId"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDescription)"/>"<xsl:if test="$isRoadmapEnabled">,
		<xsl:if test="count($theTargetReport) = 0">"menu": "<xsl:value-of select="eas:getElementContextMenuName($theDisplayInstance)"/>",</xsl:if>
		"roadmap": {
			"roadmapStatus": "<xsl:value-of select="$unchangedStatusValue"/>",
			"isVisible": true,
			"plansForPeriod": [],
			"archStatesForPeriod": [],
			"objectivesForPeriod": [],
			"rmStyle": <xsl:value-of select="$rmNoChangePlanningActionStyleJSON"/>, <!-- default to no change style -->
			"rmLink": "<xsl:value-of select="$thisRoadmapLink"/>",
			"rmMetaClassStyle": "rmMetaClassStyles.<xsl:value-of select="eas:getSafeJSString($theRoadmapInstance/type)"/>",
			"rmEALayer": "<xsl:value-of select="eas:rmGetInstanceEALayer($theRoadmapInstance)"/>",
			"strategicPlans": [
				<xsl:apply-templates mode="RenderElementStrategicPlanJSON" select="$allPlansForElement">
					<!--<xsl:sort select="$allThisPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = name]/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>-->
				</xsl:apply-templates>
			],
			"archStates": [
				<xsl:if test="count($allThisRoadmapInstanceArchStates) > 0">
					<xsl:apply-templates mode="RenderElementArchStateJSON" select="$allTheRoadmapInstancesArchStates">
						<xsl:with-param name="thisArchStates" select="$allThisRoadmapInstanceArchStates"/>
						<xsl:sort select="own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
					</xsl:apply-templates>
				</xsl:if>
			]
		}</xsl:if>	
	</xsl:template>
	
	
</xsl:stylesheet>
