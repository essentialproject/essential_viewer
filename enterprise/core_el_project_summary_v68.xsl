<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<!--
		* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- param1 = the id of the project that is being summarised -->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses2" select="('Individual_Business_Role', 'Group_Business_Role', 'Group_Actor', 'Individual_Actor', 'Programme', 'Project', 'Business_Capability', 'Business_Process', 'Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')"/>

	<xsl:param name="param1"/>

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root Business Capability']"/>

	<xsl:variable name="busCapability" select="$allBusinessCaps[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="busCapName" select="$busCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $busCapability/name]"/>


	<xsl:variable name="project" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="projectName" select="$project/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="projectDesc" select="$project/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="projectApprovalStatus" select="/node()/simple_instance[name = $project/own_slot_value[slot_reference = 'ca_approval_status']/value]"/>
	<xsl:variable name="projectApprovalStatusName" select="$projectApprovalStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
	<xsl:variable name="projectStatus" select="/node()/simple_instance[name = $project/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>
	<xsl:variable name="projectStatusName" select="$projectStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
	<xsl:variable name="projectParentProgramme" select="/node()/simple_instance[name = $project/own_slot_value[slot_reference = 'contained_in_programme']/value]"/>
	<xsl:variable name="projectParentProgrammeName" select="$projectParentProgramme/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="allDates" select="/node()/simple_instance[type = ('Gregorian', 'Quarter', 'Year')]"/>
	
	<xsl:variable name="proposedISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>
	<xsl:variable name="proposedEssStartDateId" select="$project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value"/>
	<xsl:variable name="jsProposedStartDate">
		<xsl:choose>
			<xsl:when test="string-length($proposedISOStartDate) > 0">
				<xsl:value-of select="xs:date($proposedISOStartDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="projectPlannedStartDate" select="$allDates[name = $proposedEssStartDateId]"/>
				<xsl:value-of select="eas:get_start_date_for_essential_time($projectPlannedStartDate)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<xsl:variable name="actualISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>
	<xsl:variable name="actualEssStartDateId" select="$project/own_slot_value[slot_reference = 'ca_actual_start_date']/value"/>
	<xsl:variable name="jsActualStartDate">
		<xsl:choose>
			<xsl:when test="string-length($actualISOStartDate) > 0">
				<xsl:value-of select="xs:date($actualISOStartDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="projectActualStartDate" select="$allDates[name = $actualEssStartDateId]"/>
				<xsl:value-of select="eas:get_start_date_for_essential_time($projectActualStartDate)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	
	<xsl:variable name="targetISOEndDate" select="$project/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>
	<xsl:variable name="targetEssEndDateId" select="$project/own_slot_value[slot_reference = 'ca_target_end_date']/value"/>
	<xsl:variable name="jsTargetEndDate">
		<xsl:choose>
			<xsl:when test="string-length($targetISOEndDate) > 0">
				<xsl:value-of select="xs:date($targetISOEndDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="projectTargetEndDate" select="$allDates[name = $targetEssEndDateId]"/>
				<xsl:value-of select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<xsl:variable name="forecastISOEndDate" select="$project/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>
	<xsl:variable name="forecastEssEndDateId" select="$project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value"/>
	<xsl:variable name="jsForecastEndDate">
		<xsl:choose>
			<xsl:when test="string-length($forecastISOEndDate) > 0">
				<xsl:value-of select="xs:date($forecastISOEndDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="projectForecastEndDate" select="$allDates[name = $forecastEssEndDateId]"/>
				<xsl:value-of select="eas:get_end_date_for_essential_time($projectForecastEndDate)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


	<xsl:variable name="targetEndColour">#FF386A</xsl:variable>
	<xsl:variable name="forecastEndColour">#B6002B</xsl:variable>
	<xsl:variable name="proposedStartColour">#A9D18E</xsl:variable>
	<xsl:variable name="actualStartColour">#008F00</xsl:variable>
	<xsl:variable name="noStyleImpact">#666</xsl:variable>


	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')]"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[(type = 'Application_Service') or (type = 'Composite_Application_Service')]"/>
	<xsl:variable name="allAppRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allBusProc2AppSvcs" select="/node()/simple_instance[type = 'APP_SVC_TO_BUS_RELATION']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
	<xsl:variable name="allStratPlanToElementRelations" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="impactActions" select="/node()/simple_instance[type = 'Planning_Action']"/>
	<xsl:variable name="allImpactActionStyles" select="/node()/simple_instance[name = $impactActions/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>

	<!--	<xsl:variable name="relevantGoalArchStates" select="/node()/simple_instance[name = $project/own_slot_value[slot_reference='project_goal_state']/value]"/>-->
	<xsl:variable name="projectStakeholders" select="$allActor2Roles[name = $project/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="projectActors" select="/node()/simple_instance[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="projectRoles" select="/node()/simple_instance[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="DEBUG" select="''"/>

	<xsl:variable name="relevantDirectStrategicPlans" select="/node()/simple_instance[name = $project/own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value]"/>
	<xsl:variable name="directStrategicPlanImpactedElements" select="/node()/simple_instance[not((type = 'PLAN_TO_ELEMENT_RELATION')) and (name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>

	<xsl:variable name="projectDeprectatedStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>
	<xsl:variable name="impactedElementViaDeprectedStrategicPlansRels" select="/node()/simple_instance[name = $projectDeprectatedStrategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>

	<xsl:variable name="projectStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value)]"/>
	<xsl:variable name="impactedElementViaStrategicPlansRels" select="/node()/simple_instance[name = $projectStrategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>

	<xsl:variable name="projectPlan2ElementRels" select="$allStratPlanToElementRelations[name = $project/own_slot_value[slot_reference = 'ca_planned_changes']/value]"/>
	<xsl:variable name="directImpactedElements" select="/node()/simple_instance[name = $projectPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	<xsl:variable name="directImpactedStrategicPlans" select="/node()/simple_instance[name = $projectPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>

	<xsl:variable name="projectImpactedElements" select="$impactedElementViaDeprectedStrategicPlansRels union $impactedElementViaStrategicPlansRels union $directStrategicPlanImpactedElements union $directImpactedElements"/>
	<xsl:variable name="allRelevantStrategicPlans" select="$relevantDirectStrategicPlans union $directImpactedStrategicPlans"/>

	<!-- Define the meta-class to label mappings across the architecture layers -->
	<xsl:variable name="businessLayerClasses" select="('Business_Objective', 'Business_Driver', 'Business_Capability', 'Business_Process', 'Business_Activity', 'Individual_Business_Role', 'Group_Business_Role', 'Product_Type', 'Product', 'Channel', 'Group_Actor', 'Site', 'Physical_Process', 'Physical_Activity')"/>
	<xsl:variable name="businessLayerLabels" select="(eas:i18n('Business Objective'), eas:i18n('Business Driver'), eas:i18n('Business Capability'), eas:i18n('Business Process'), eas:i18n('Business Activity'), eas:i18n('Individual Role'), eas:i18n('Organisation Role'), eas:i18n('Service Type'), eas:i18n('Service'), eas:i18n('Communication Channel'), eas:i18n('Organisation'), eas:i18n('Location'), eas:i18n('Implemented Process'), eas:i18n('Implemented Activity'))"/>

	<xsl:variable name="infoLayerClasses" select="('Information_View', 'Data_Subject', 'Data_Object', 'Data_Representation', 'Security_Policy', 'Information_Store')"/>
    <xsl:variable name="infoLayerClasses2" select="/node()/simple_instance[type=('Information_View', 'Data_Subject', 'Data_Object', 'Data_Representation', 'Security_Policy', 'Information_Store')]"/>
	<xsl:variable name="infoLayerLabels" select="(eas:i18n('Information Object'), eas:i18n('Data Subject'), eas:i18n('Data Object'), eas:i18n('Data Representation'), eas:i18n('Security Policy'), eas:i18n('Information/Data Store'))"/>

	<xsl:variable name="appLayerClasses" select="('Application_Service', 'Application_Provider_Interface', 'Composite_Application_Provider', 'Application_Provider', 'Application_Function', 'Application_Deployment')"/>
	<xsl:variable name="appLayerLabels" select="(eas:i18n('Application Service'), eas:i18n('Application Interface'),  eas:i18n('Application'), eas:i18n('Application'), eas:i18n('Application Function'), eas:i18n('Application Deployment'))"/>

	<xsl:variable name="techLayerClasses" select="('Technology_Capability', 'Technology_Component', 'Technology_Product', 'Technology_Product_Build', 'Infrastructure_Software_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Hardware_Instance', 'Technology_Node')"/>
	<xsl:variable name="techLayerLabels" select="(eas:i18n('Technology Capability'), eas:i18n('Technology Component'), eas:i18n('Technology Product'), eas:i18n('Technology Build'), eas:i18n('Infrastructure Software Instance'), eas:i18n('Application Software Instance'), eas:i18n('Information/Data Store Instance'), eas:i18n('Hardware Instance'), eas:i18n('Technology Node'))"/>
    
    <xsl:variable name="projectPlanToElements" select="$allStratPlanToElementRelations[name=$project/own_slot_value[slot_reference='ca_planned_changes']/value]"/>

	<!-- Set up the requierd link classes -->
	<xsl:variable name="linkClasses" select="($project union $busCapability union $projectImpactedElements union $allRelevantStrategicPlans union $projectActors union $projectParentProgramme)/type "/>

	<!-- SET THE THRESHOLDS FOR LOW, MEDIUM AND HIGH PROJECT ACTIVITY LEVELS-->
	<!--<xsl:variable name="activityLowThreshold" select="1"/>
	<xsl:variable name="activityMedThreshold" select="5"/>
	<xsl:variable name="activityHighThreshold" select="60"/>-->


	<!-- SET THE THRESHOLDS FOR LOW, MEDIUM AND HIGH PROCESS IMPACT PERCENTAGES -->
	<!--<xsl:variable name="impactLowThreshold" select="20"/>
	<xsl:variable name="impcatMedThreshold" select="40"/>
	<xsl:variable name="impcatHighThreshold" select="60"/>-->

	<xsl:variable name="footPrintClass" select="'gradLevel4  text-white'"/>
	<xsl:variable name="noImpactClass" select="''"/>

	<xsl:variable name="pageLabel">Project Summary - <xsl:value-of select="$projectName"/></xsl:variable>


	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$topLevelBusCapabilities[own_slot_value[slot_reference = 'elements_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$topLevelBusCapabilities"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Project Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeBusCaps"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
                <xsl:for-each select="$linkClasses2">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<script src="js/d3/d3.v2.min.js?release=6.19" type="application/javascript"/>
				<script src="js/d3/timeknots.js?release=6.19" type="application/javascript"/>
				<script type="text/javascript">
				$('document').ready(function(){
					 $(".compModelContent").vAlign();
				});
			</script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Project Summary for')"/>&#160; <xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$project"/>
											<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
										</xsl:call-template></span>
								</h1>
								<xsl:value-of select="$DEBUG"/>
							</div>
						</div>


						<!--Setup Description Section-->
					</div>
					<div class="row">

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:value-of select="$projectDesc"/>
								</p>
							</div>
							<hr/>
						</div>





						<!--Setup Timeline Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Timeline')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="string-length($proposedISOStartDate) + count($proposedEssStartDateId) + string-length($actualISOStartDate) + count($actualEssStartDateId) + string-length($targetISOEndDate) + count($targetEssEndDateId) + string-length($forecastISOEndDate) + count($forecastEssEndDateId) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No start or end dates defined')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<div id="timeline1" style="width:500px;"/>
										<script type="text/javascript">
											var projectTimeline = [
												<xsl:choose>
													<xsl:when test="string-length($proposedISOStartDate) + count($proposedEssStartDateId) + string-length($actualISOStartDate) + count($actualEssStartDateId) > 0">
														<xsl:choose>
															<xsl:when test="$jsActualStartDate = $jsProposedStartDate">
																{name:"Start Date", date: "<xsl:value-of select="$jsActualStartDate"/>", color: "<xsl:value-of select="$actualStartColour"/>"}<xsl:if test="string-length($targetISOEndDate) + count($targetEssEndDateId) + string-length($forecastISOEndDate) + count($forecastEssEndDateId) > 0">,</xsl:if>
															</xsl:when>
															<xsl:otherwise>
																<xsl:if test="string-length($proposedISOStartDate) + count($proposedEssStartDateId) > 0">{name:"Proposed Start Date", date: "<xsl:value-of select="$jsProposedStartDate"/>", color: "<xsl:value-of select="$proposedStartColour"/>"}<xsl:if test="string-length($jsActualStartDate) > 0">,</xsl:if></xsl:if>
																<xsl:if test="string-length($actualISOStartDate) + count($actualEssStartDateId) > 0">{name:"Actual Start Date", date: "<xsl:value-of select="$jsActualStartDate"/>", color: "<xsl:value-of select="$actualStartColour"/>"}<xsl:if test="string-length($targetISOEndDate) + count($targetEssEndDateId) + string-length($forecastISOEndDate) + count($forecastEssEndDateId) > 0">,</xsl:if></xsl:if>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
												</xsl:choose>
												<xsl:choose>
													<xsl:when test="string-length($targetISOEndDate) + count($targetEssEndDateId) + string-length($forecastISOEndDate) + count($forecastEssEndDateId) > 0">
														<xsl:choose>
															<xsl:when test="$jsTargetEndDate = $jsForecastEndDate">
																{name:"Forecast End Date", date: "<xsl:value-of select="$jsForecastEndDate"/>", color: "<xsl:value-of select="$forecastEndColour"/>"}
															</xsl:when>
															<xsl:otherwise>
																<xsl:if test="string-length($targetISOEndDate) + count($targetEssEndDateId) > 0">{name:"Target End Date", date: "<xsl:value-of select="$jsTargetEndDate"/>", color: "<xsl:value-of select="$targetEndColour"/>"}<xsl:if test="string-length($forecastISOEndDate) + count($forecastEssEndDateId) > 0">,</xsl:if></xsl:if>
																<xsl:if test="string-length($forecastISOEndDate) + count($forecastEssEndDateId) > 0">{name:"Forecast End Date", date: "<xsl:value-of select="$jsForecastEndDate"/>", color: "<xsl:value-of select="$forecastEndColour"/>"}</xsl:if>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
												</xsl:choose>
											];
											TimeKnots.draw("#timeline1", projectTimeline, {dateFormat: "%d %B %Y", color: "grey", radius: 20, height: 100, width:500, showLabels: true, labelFormat: "%B %Y"});
										</script>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>





						<!--Setup Status Section-->
						<div class="col-xs-12 col-md-4">
							<div class="sectionIcon">
								<i class="fa fa-check icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Approval Status')"/>
							</h2>


							<div class="content-section">
								<xsl:choose>
									<xsl:when test="string-length($projectApprovalStatusName) > 0">
										<div>
											<strong>
												<xsl:value-of select="$projectApprovalStatusName"/>
											</strong>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('Undefined')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>

							<hr/>
						</div>
						<!--<div class="clear" />-->

						<!--Setup Status Section-->
						<div class="col-xs-12 col-md-4">
							<div class="sectionIcon">
								<i class="fa fa-retweet icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Lifecycle Status')"/>
							</h2>


							<div class="content-section">
								<xsl:choose>
									<xsl:when test="string-length($projectStatusName) > 0">
										<xsl:variable name="statusColour" select="eas:get_element_style_colour($projectStatus)"/>
										<div class="keySample">
											<xsl:attribute name="style" select="concat('background-color: ', $statusColour, ';')"/>
										</div>
										<div>
											<strong>
												<xsl:value-of select="$projectStatusName"/>
											</strong>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('Undefined')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>

							<hr/>
						</div>
						<!--<div class="clear" />-->



						<!--Setup Parent Programme Section-->

						<div class="col-xs-12 col-md-4">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Parent Programme')"/>
							</h2>


							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($projectParentProgramme) > 0">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$projectParentProgramme"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<em>Undefined</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>




						<!--Setup Roles and People Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Roles &amp; People')"/>
							</h2>

							<div class="content-section">
								<xsl:call-template name="Roles"/>
							</div>
							<hr/>
						</div>




						<!--Setup Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-paw icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Footprint')"/>
							</h2>
							<div class="content-section">
								<xsl:variable name="fullWidth" select="count($topLevelBusCapabilities) * 140"/>
								<xsl:variable name="widthStyle" select="concat('width:', $fullWidth, 'px;')"/>
								<p><xsl:value-of select="eas:i18n('The following diagram highlights the conceptual business capabilities directly or indirectly impacted by the')"/>&#160; <xsl:value-of select="$projectName"/>.</p>
								<div class="simple-scroller">
									<div>
										<xsl:attribute name="style" select="$widthStyle"/>
										<xsl:apply-templates mode="RenderBusinessCapabilityColumn" select="$inScopeBusCaps">
											<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
										</xsl:apply-templates>
									</div>
								</div>
							</div>
							<div class="clear"/>
							<hr/>
						</div>
                        
                        
                     <div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color" />
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Business Elements')"/>
							</h2>
							<div class="content-section">
								<xsl:apply-templates select="$projectPlanToElements" mode="DirectImpactedElements">
                                    <xsl:with-param name="classes" select="$businessLayerClasses"/>
                                </xsl:apply-templates>
							</div>
							<hr/>
						</div>


						<!--Impacted Information Elements-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text icon-section icon-color" />
							</div>


							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Information/Data Elements')" />
							</h2>
							<div class="content-section">
								<xsl:apply-templates select="$projectPlanToElements" mode="DirectImpactedElements">
                                    <xsl:with-param name="classes" select="$infoLayerClasses"/>
                                </xsl:apply-templates>
							</div>
							<hr/>
						</div>



						<!--Impacted Application Elements-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-desktop icon-section icon-color"/>
							</div>

							<h2 class="text-primary" >
								<xsl:value-of select="eas:i18n('Impacted Application Elements')"/>
							</h2>
							<div class="content-section">
								<xsl:apply-templates select="$projectPlanToElements" mode="DirectImpactedElements">
                                    <xsl:with-param name="classes" select="$appLayerClasses"/>
                                </xsl:apply-templates>
							</div>
							<hr/>
						</div>


						<!--Impacted Technology Elements-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-cogs icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Technology Elements')"/>
							</h2>
							<div class="content-section">
                                	  
                                            <xsl:apply-templates select="$projectPlanToElements" mode="DirectImpactedElements">
                                                 <xsl:with-param name="classes" select="$techLayerClasses"/>
                                            </xsl:apply-templates>
								
							</div>
							<hr/>
						</div>

						<!--Impacted Processes-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supported Strategic Plans')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="StrategicPlansTable"/>
							</div>
							<hr/>
						</div>



						<!--Impacted Processes-->
                        <div class="col-xs-1"></div>
                        <div class="col-xs-11"  style="border-left:1pt solid #a6a6a6"><p>
                            <h4>Strategic Plan Impacts</h4>
                            These elements are impacted by the projects supporting the above Strategic Plans and should be considered when making changes to this project</p>
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section"  style="font-size:1.4em;color:#a6a6a6"/>
							</div>

							<h2 class="text-primary" style="font-size:1.4em">
								<xsl:value-of select="eas:i18n('Impacted Business Elements')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="ImpactedElements">
									<xsl:with-param name="layerClasses" select="$businessLayerClasses"/>
									<xsl:with-param name="layerLabels" select="$businessLayerLabels"/>
									<xsl:with-param name="layerType">Business</xsl:with-param>
								</xsl:call-template>
							</div>
							<hr/>
						</div>


						<!--Impacted Information Elements-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text icon-section" style="font-size:1.4em;color:#a6a6a6"/>
							</div>


							<h2 class="text-primary" style="font-size:1.4em">
								<xsl:value-of select="eas:i18n('Impacted Information/Data Elements')" />
							</h2>
							<div class="content-section">
								<xsl:call-template name="ImpactedElements">
									<xsl:with-param name="layerClasses" select="$infoLayerClasses"/>
									<xsl:with-param name="layerLabels" select="$infoLayerLabels"/>
									<xsl:with-param name="layerType">Information/Data</xsl:with-param>
								</xsl:call-template>
							</div>
							<hr/>
						</div>



						<!--Impacted Application Elements-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-desktop icon-section" style="font-size:1.4em;color:#a6a6a6"/>
							</div>

							<h2 class="text-primary"  style="font-size:1.4em">
								<xsl:value-of select="eas:i18n('Impacted Application Elements')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="ImpactedElements">
									<xsl:with-param name="layerClasses" select="$appLayerClasses"/>
									<xsl:with-param name="layerLabels" select="$appLayerLabels"/>
									<xsl:with-param name="layerType">Application</xsl:with-param>
								</xsl:call-template>
							</div>
							<hr/>
						</div>


						<!--Impacted Technology Elements-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-cogs icon-section" style="font-size:1.4em;color:#a6a6a6"/>
							</div>

							<h2 class="text-primary" style="font-size:1.4em">
								<xsl:value-of select="eas:i18n('Impacted Technology Elements')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="ImpactedElements">
									<xsl:with-param name="layerClasses" select="$techLayerClasses"/>
									<xsl:with-param name="layerLabels" select="$techLayerLabels"/>
									<xsl:with-param name="layerType">Technology</xsl:with-param>
								</xsl:call-template>
							</div>
							<hr/>
						</div>

                        </div>
						<!--Setup the Supporting Documentation section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
							</h2>

							<div class="content-section">
								<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>
							</div>
							<hr/>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<!-- render a column of business capabilities -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityColumn">

		<div class="compModelColumn">
			<div class="compModelElementContainer">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'compModelContent backColour3 text-white small impact tabTop'"/>
					<xsl:with-param name="anchorClass" select="'text-white small'"/>
				</xsl:call-template>
			</div>
			<xsl:variable name="supportingBusCaps" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderBusinessCapabilityCell" select="$supportingBusCaps">
				<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>



	<!-- render a business capability cell -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityCell">
		<xsl:variable name="busCapChildren" select="eas:findAllSubCaps(current(), ())"/>
		<xsl:variable name="activityTotal">
			<xsl:call-template name="Calculate_Project_Activity">
				<xsl:with-param name="currentCap" select="$busCapChildren"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="divClass">
			<xsl:choose>
				<xsl:when test="$activityTotal = 0">
					<xsl:value-of select="concat('compModelContent small text-darkgrey', $noImpactClass)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('compModelContent small ', $footPrintClass)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="anchorClass">
			<xsl:choose>
				<xsl:when test="$activityTotal = 0">
					<xsl:value-of select="'text-darkgrey'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'text-white'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<div class="compModelElementContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="$divClass"/>
				<xsl:with-param name="anchorClass" select="$anchorClass"/>
			</xsl:call-template>
		</div>
	</xsl:template>




	<xsl:template name="Roles">
		<xsl:choose>
			<xsl:when test="count($projectStakeholders) = 0">
				<p>
					<em>
						<xsl:value-of select="eas:i18n('No stakeholders defined for this project')"/>
					</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Role')"/>
							</th>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Person')"/>
							</th>
							<!-- <th class="cellWidth-20pc">Location</th> -->
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Email')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$projectStakeholders">
							<xsl:variable name="projectActor" select="$projectActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
							<xsl:variable name="actorName" select="$projectActor/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="projectRole" select="$projectRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
							<xsl:variable name="roleName" select="$projectRole/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="actorEmail" select="$projectActor/own_slot_value[slot_reference = 'email']/value"/>
							<tr>
								<td>

									<xsl:choose>
										<xsl:when test="count($projectRole) > 0">
											<strong>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$projectRole"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</strong>
										</xsl:when>
										<xsl:otherwise>
											<em>Role undefined</em>
										</xsl:otherwise>
									</xsl:choose>


								</td>
								<td>

									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$projectActor"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>

								<td>
									<xsl:choose>
										<xsl:when test="string-length($actorEmail) > 0">
											<xsl:variable name="mailToLinkText" select="concat('mailto:', $actorEmail, '?Subject=Re:%20', $projectName)"/>
											<a>
												<xsl:attribute name="href" select="$mailToLinkText"/>
												<xsl:attribute name="target">_top</xsl:attribute>
												<xsl:value-of select="$actorEmail"/>
											</a>
										</xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>

					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template match="node()" name="Calculate_Project_Activity">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>
		<xsl:variable name="orgRolesForCap" select="$allGroupRoles[name = $busProcsForCap/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
		<xsl:variable name="org2RolesForCap" select="$allActor2Roles[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $orgRolesForCap/name]"/>
		<xsl:variable name="orgsForCap" select="$allGroupActors[name = $org2RolesForCap/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>


		<xsl:variable name="appSvc2BusProcsForCap" select="$allBusProc2AppSvcs[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $busProcsForCap/name]"/>
		<xsl:variable name="appSvcsForCap" select="$allAppServices[name = $appSvc2BusProcsForCap/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
		<xsl:variable name="appRolesForSvcsCap" select="$allAppRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $appSvcsForCap/name]"/>
		<xsl:variable name="appsForSvcsCap" select="$allApps[name = $appRolesForSvcsCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		<!-- identify the applications that impact the business capability -->
		<xsl:variable name="physProcsForCap" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $busProcsForCap/name]"/>
		<xsl:variable name="physProcs2AppsForCap" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
		<xsl:variable name="appRolesForCap" select="$allAppRoles[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="appsForRolesCap" select="$allApps[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="appsForCap" select="$allApps[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $appsForSvcsCap"/>

		<xsl:variable name="plansForBusCap" select="$projectImpactedElements[name = $currentCap/name]"/>
		<xsl:variable name="plansforBusProcs" select="$projectImpactedElements[name = $busProcsForCap/name]"/>
		<xsl:variable name="plansforApps" select="$projectImpactedElements[name = $allAppsForCap/name]"/>
		<xsl:variable name="plansforOrgs" select="$projectImpactedElements[name = $orgsForCap/name]"/>

		<xsl:value-of select="count($plansForBusCap union $plansforApps union $plansforBusProcs union $plansforOrgs)"/>
	</xsl:template>


	<!-- Calculate the percentage of processes impacted by projects for a given Business Capability -->
	<xsl:template match="node()" name="Calculate_Percentage_Impact">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>
		<!-- get all affected apps from the relevant architecure states -->
		<xsl:variable name="impactedApps" select="$allApps[name = $projectImpactedElements/name]"/>
		<!-- get all of the physical processes 2 app relations for the apps -->
		<xsl:variable name="physProc2AppRels" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $impactedApps/name]"/>
		<!-- get all of the physical processes for the physical procesess 2 apps -->
		<xsl:variable name="physProcs4App" select="$allPhysProcs[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $physProc2AppRels/name]"/>
		<!-- get all of the logical processes that are implemented by the physical processes and that also realise the current business capability -->
		<xsl:variable name="businessProcsFromApps" select="$busProcsForCap[name = $physProcs4App/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="directlyImpactedProcs" select="$busProcsForCap[name = $projectImpactedElements/name]"/>

		<xsl:variable name="impactedProcs" select="($businessProcsFromApps union $directlyImpactedProcs)"/>
		<xsl:choose>
			<xsl:when test="(count($impactedProcs) > 0) and (count($busProcsForCap) > 0)">
				<xsl:value-of select="floor(count($impactedProcs) div count($busProcsForCap) * 100)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="ImpactedElements">
		<xsl:param name="layerClasses">()</xsl:param>
		<xsl:param name="layerLabels">()</xsl:param>
		<xsl:param name="layerType"/>

		<xsl:variable name="layerElements" select="$projectImpactedElements[type = $layerClasses]"/>
		<xsl:variable name="allDirectPlanLayerElements" select="$layerElements[name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>

		<xsl:choose>
			<xsl:when test="count($layerElements) > 0">
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Type')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n($layerType)"/>&#160;<xsl:value-of select="eas:i18n('Element')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Impact')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$relevantDirectStrategicPlans">
							<xsl:variable name="directPlanLayerElements" select="$layerElements[name = current()/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>
							<xsl:variable name="directPlanImpact" select="$impactActions[name = current()/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
							<xsl:for-each select="$directPlanLayerElements">
								<xsl:call-template name="RenderElementImpactRow">
									<xsl:with-param name="element" select="current()"/>
									<xsl:with-param name="elementImpact" select="$directPlanImpact"/>
									<xsl:with-param name="layerClasses" select="$layerClasses"/>
									<xsl:with-param name="layerLabels" select="$layerLabels"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:for-each>

						<xsl:variable name="thisStrategicPlanRels" select="$projectStrategicPlanRelations[(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $layerElements/name) and not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $allDirectPlanLayerElements/name)]"/>
						<xsl:call-template name="RenderPlan2ElementsRelations">
							<xsl:with-param name="relations" select="$thisStrategicPlanRels"/>
							<xsl:with-param name="usedRelations" select="()"/>
							<xsl:with-param name="layerElements" select="$layerElements"/>
							<xsl:with-param name="layerClasses" select="$layerClasses"/>
							<xsl:with-param name="layerLabels" select="$layerLabels"/>
						</xsl:call-template>

						<xsl:variable name="thisAllDeprectatedStrategicPlanRels" select="$projectDeprectatedStrategicPlanRelations[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $layerElements/name]"/>
						<xsl:variable name="thisFilteredDeprectatedStrategicPlanRels" select="$thisAllDeprectatedStrategicPlanRels[not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $allDirectPlanLayerElements/name)]"/>
						<xsl:variable name="thisDeprectatedStrategicPlanRels" select="$thisFilteredDeprectatedStrategicPlanRels[not((own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and (own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))]"/>
						<xsl:call-template name="RenderPlan2ElementsRelations">
							<xsl:with-param name="relations" select="$thisDeprectatedStrategicPlanRels"/>
							<xsl:with-param name="usedRelations" select="()"/>
							<xsl:with-param name="layerElements" select="$layerElements"/>
							<xsl:with-param name="layerClasses" select="$layerClasses"/>
							<xsl:with-param name="layerLabels" select="$layerLabels"/>
						</xsl:call-template>

						<xsl:variable name="thisAllDirectStrategicPlanRels" select="$projectPlan2ElementRels[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $layerElements/name]"/>
						<xsl:variable name="thisFilteredDirectStrategicPlanRels" select="$thisAllDirectStrategicPlanRels[not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $allDirectPlanLayerElements/name)]"/>
						<xsl:variable name="thisFilteredAgainDirectStrategicPlanRels" select="$thisFilteredDirectStrategicPlanRels[not((own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and (own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))]"/>
						<xsl:variable name="thisDirectStrategicPlanRels" select="$thisFilteredAgainDirectStrategicPlanRels[not((own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $thisDeprectatedStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and (own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $thisDeprectatedStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))]"/>
						<xsl:call-template name="RenderPlan2ElementsRelations">
							<xsl:with-param name="relations" select="$thisDirectStrategicPlanRels"/>
							<xsl:with-param name="usedRelations" select="()"/>
							<xsl:with-param name="layerElements" select="$layerElements"/>
							<xsl:with-param name="layerClasses" select="$layerClasses"/>
							<xsl:with-param name="layerLabels" select="$layerLabels"/>
						</xsl:call-template>

					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em><xsl:value-of select="eas:i18n('No impacted')"/>&#160; <xsl:value-of select="eas:i18n($layerType)"/>&#160; <xsl:value-of select="eas:i18n('elements defined for this Strategic Plan')"/></em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="RenderPlan2ElementsRelations">
		<xsl:param name="relations" select="()"/>
		<xsl:param name="usedRelations" select="()"/>
		<xsl:param name="layerElements" select="()"/>
		<xsl:param name="layerClasses" select="()"/>
		<xsl:param name="layerLabels" select="()"/>

		<xsl:if test="count($relations) > 0">
			<xsl:variable name="nextRelation" select="$relations[1]"/>
			<xsl:if test="not(($nextRelation/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $usedRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and ($nextRelation/own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $usedRelations/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))">
				<xsl:variable name="relatedElement" select="$layerElements[name = $nextRelation/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
				<xsl:variable name="relatedImpact" select="$impactActions[name = $nextRelation/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>
				<xsl:call-template name="RenderElementImpactRow">
					<xsl:with-param name="element" select="$relatedElement"/>
					<xsl:with-param name="elementImpact" select="$relatedImpact"/>
					<xsl:with-param name="layerClasses" select="$layerClasses"/>
					<xsl:with-param name="layerLabels" select="$layerLabels"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="RenderPlan2ElementsRelations">
				<xsl:with-param name="relations" select="$relations except $nextRelation"/>
				<xsl:with-param name="usedRelations" select="$usedRelations union $nextRelation"/>
				<xsl:with-param name="layerElements" select="$layerElements"/>
				<xsl:with-param name="layerClasses" select="$layerClasses"/>
				<xsl:with-param name="layerLabels" select="$layerLabels"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="RenderElementImpactRow">
		<xsl:param name="element"/>
		<xsl:param name="elementImpact"/>
		<xsl:param name="layerClasses"/>
		<xsl:param name="layerLabels"/>

		<xsl:variable name="elementName" select="$element/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="elementRelationName" select="$element/own_slot_value[slot_reference = 'relation_name']/value"/>
		<xsl:variable name="elementDesc" select="$element/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="elementTypeIndex" select="index-of($layerClasses, $element/type)"/>
		<xsl:variable name="elementTypeLabel" select="$layerLabels[$elementTypeIndex]"/>
		<xsl:choose>
			<xsl:when test="string-length($elementName) > 0">
				<tr>
					<td>
						<xsl:value-of select="$elementTypeLabel"/>
					</td>
					<td>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$element"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
					</td>
					<td>
						<xsl:value-of select="$elementDesc"/>
					</td>
					<td class="impact">
						<xsl:for-each select="$elementImpact">
							<xsl:variable name="elementImpactLabel" select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
							<xsl:variable name="elementImpactColour" select="eas:get_planning_action_colour(current())"/>
							<p style="color:{$elementImpactColour}">
								<xsl:value-of select="$elementImpactLabel"/>
							</p>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="string-length($elementRelationName) > 0">
				<tr>
					<td>
						<xsl:value-of select="$elementTypeLabel"/>
					</td>
					<td>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$element"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="displayString" select="$elementRelationName"/>
							</xsl:call-template>
						</strong>
					</td>
					<td>
						<xsl:value-of select="$elementDesc"/>
					</td>
					<td class="impact">
						<xsl:for-each select="$elementImpact">
							<xsl:variable name="elementImpactColour" select="eas:get_planning_action_colour(current())"/>
							<p style="color:{$elementImpactColour}">
								<xsl:call-template name="RenderMultiLangInstanceName">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
								</xsl:call-template>
							</p>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:function name="eas:get_planning_action_colour" as="xs:string">
		<xsl:param name="planningAction"/>

		<xsl:variable name="style" select="$allImpactActionStyles[name = $planningAction/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
		<xsl:choose>
			<xsl:when test="count($style) = 0">
				<xsl:value-of select="$noStyleImpact"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="styleColour" select="$style[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>
				<xsl:choose>
					<xsl:when test="string-length($styleColour) = 0">
						<xsl:value-of select="$noStyleImpact"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$styleColour"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>



	<xsl:template name="StrategicPlansTable">
		<xsl:choose>
			<xsl:when test="count($allRelevantStrategicPlans) > 0">
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Strategic Plan')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Start Date')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('End Date')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="RenderStrategicPlanRow" select="$allRelevantStrategicPlans">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No supported Strategic Plans defined')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>




	<xsl:template mode="RenderStrategicPlanRow" match="node()">
		
		<xsl:variable name="currentPlan" select="current()"/>
		
		<xsl:variable name="planISOStartDate" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
		<xsl:variable name="planEssStartDateId" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value"/>
		<xsl:variable name="jsPlanStartDate">
			<xsl:choose>
				<xsl:when test="string-length($planISOStartDate) > 0">
					<xsl:value-of select="xs:date($planISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="planStartDate" select="$allDates[name = $planEssStartDateId]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($planStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="planISOEndDate" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		<xsl:variable name="planEssEndDate" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value"/>
		<xsl:variable name="jsPlanEndDate">
			<xsl:choose>
				<xsl:when test="string-length($planISOEndDate) > 0">
					<xsl:value-of select="xs:date($planISOEndDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="planEndDate" select="$allDates[name = $planEssEndDate]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($planEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($planISOStartDate) + count($planEssStartDateId) = 0">
						<em>Undefined</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="FullFormatDate">
							<xsl:with-param name="theDate" select="$jsPlanStartDate"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($planISOEndDate) + count($planEssEndDate) = 0">
						<em>Undefined</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="FullFormatDate">
							<xsl:with-param name="theDate" select="$jsPlanEndDate"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>


	<!-- Find all the sub capabilities of the specified parent capability -->
	<xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusinessCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aDirectChildList" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theParentCap/name]"/>
				<xsl:variable name="aNewList" select="$aDirectChildList union $aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

    <xsl:template match="node()" mode="DirectImpactedElements">
        <xsl:param name="classes"/>
        <xsl:variable name="this" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='plan_to_element_ea_element']/value]"/>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Type')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Element')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Impact')"/>
							</th>
						</tr>
					</thead>
					<tbody>
                        <xsl:apply-templates select="$this[type=$classes]" mode="getRow">
                            <xsl:with-param name="action" select="current()/own_slot_value[slot_reference='plan_to_element_change_action']/value"/>
                        </xsl:apply-templates>
					</tbody>
				</table>
       
	</xsl:template>
    
    <xsl:template match="node()" mode="getRow">
    <xsl:param name="action"/>    
        <tr>
            <td>
                <xsl:value-of select="current()/type"/>
            </td>
            <td>
                <xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
                </xsl:call-template></td>
            <td>
            <xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/>
            </td>
            <td><xsl:value-of select="$impactActions[name=$action]/own_slot_value[slot_reference='name']/value"/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
