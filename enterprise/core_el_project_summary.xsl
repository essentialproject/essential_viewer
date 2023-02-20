<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_js_functions.xsl"/>
    <xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

    <xsl:variable name="this" select="/node()/simple_instance[name = $param1]"/>
    <xsl:variable name="thisPlannedChanges" select="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION'][name = $this/own_slot_value[slot_reference='ca_planned_changes']/value]"/>
    <xsl:variable name="thisPlannedChangeElements" select="/node()/simple_instance[name = $thisPlannedChanges/own_slot_value[slot_reference='plan_to_element_ea_element']/value]"/>
    <!-- plans that touch common elements to this project -->
    <xsl:variable name="allStrategicPlans" select="/node()/simple_instance[type='Enterprise_Strategic_Plan']"/>
    <xsl:variable name="thisInterestedStrategicPlans" select="$allStrategicPlans[own_slot_value[slot_reference='strategic_plan_for_elements']/value=$thisPlannedChanges/name]"/>
    
    <!-- plans that this project supports-->
    <xsl:variable name="thisdirectStrategicPlans" select="/node()/simple_instance[type='Enterprise_Strategic_Plan'][name=$this/own_slot_value[slot_reference='ca_strategic_plans_supported']/value]"/>
	<xsl:variable name="thisStrategicPlansviaElement" select="/node()/simple_instance[type='Enterprise_Strategic_Plan'][name=$thisPlannedChanges/own_slot_value[slot_reference='plan_to_element_plan']/value]"/>

    <xsl:variable name="planningActions" select="/node()/simple_instance[type='Planning_Action']"/>
	<xsl:variable name="projectApprovalStatus" select="/node()/simple_instance[name = $this/own_slot_value[slot_reference = 'ca_approval_status']/value]"/>
	<xsl:variable name="projectApprovalStatusName" select="$projectApprovalStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
	<xsl:variable name="projectStatus" select="/node()/simple_instance[name = $this/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>
	<xsl:variable name="projectStatusName" select="$projectStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
	<xsl:variable name="projectParentProgramme" select="/node()/simple_instance[name = $this/own_slot_value[slot_reference = 'contained_in_programme']/value]"/>
	<xsl:variable name="projectParentProgrammeName" select="$projectParentProgramme/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="allDates" select="/node()/simple_instance[type = ('Gregorian', 'Quarter', 'Year')]"/>
	<xsl:variable name="allStratStatus" select="/node()/simple_instance[type = 'Planning_Status']"/>
	
	<xsl:variable name="proposedISOStartDate" select="$this/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>
	<xsl:variable name="proposedEssStartDateId" select="$this/own_slot_value[slot_reference = 'ca_proposed_start_date']/value"/>
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
	
	
	<xsl:variable name="actualISOStartDate" select="$this/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>
	<xsl:variable name="actualEssStartDateId" select="$this/own_slot_value[slot_reference = 'ca_actual_start_date']/value"/>
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
	
	
	
	<xsl:variable name="targetISOEndDate" select="$this/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>
	<xsl:variable name="targetEssEndDateId" select="$this/own_slot_value[slot_reference = 'ca_target_end_date']/value"/>
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
	
	
	<xsl:variable name="forecastISOEndDate" select="$this/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>
	<xsl:variable name="forecastEssEndDateId" select="$this/own_slot_value[slot_reference = 'ca_forecast_end_date']/value"/>
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
    
    <xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root Business Capability']"/>

	<xsl:variable name="busCapability" select="$allBusinessCaps[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="busCapName" select="$busCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $busCapability/name]"/>
    <xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
    
    
    <xsl:variable name="targetEndColour">#FF386A</xsl:variable>
	<xsl:variable name="forecastEndColour">#B6002B</xsl:variable>
	<xsl:variable name="proposedStartColour">#A9D18E</xsl:variable>
	<xsl:variable name="actualStartColour">#008F00</xsl:variable>
	<xsl:variable name="noStyleImpact">#666</xsl:variable>
    <xsl:variable name="footPrintClass" select="'gradLevel4  text-white'"/>
	<xsl:variable name="noImpactClass" select="''"/>

    <xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')]"/>
        <xsl:variable name="allAppDeployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'application_provider_deployed']/value = $allApps/name]"/>
        <xsl:variable name="allTechBuilds" select="/node()/simple_instance[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
	<xsl:variable name="allTechBuildArchs" select="/node()/simple_instance[name = $allTechBuilds/own_slot_value[slot_reference = ('technology_provider_architecture','technology_product_architecture')]/value]"/>
	<xsl:variable name="allTechProvRoleUsages" select="/node()/simple_instance[(name = $allTechBuildArchs/own_slot_value[slot_reference = ('contained_architecture_components','contained_techProd_components')]/value) and (type = ('Technology_Provider_Usage','Technology_Product_Usage','Technology_Product_Dependency'))]"/>
        <xsl:variable name="allTechProvs" select="/node()/simple_instance[supertype = 'Technology_Provider']"/>
	<xsl:variable name="allTechProRoles" select="/node()/simple_instance[(type,supertype) = ('Technology_Provider_Role','Technology_Product_Role','Technology_Component')]"/>
        <xsl:variable name="allAppTechProvRoles" select="$allTechProRoles[name = $allTechProvRoleUsages/own_slot_value[slot_reference = ('provider_as_role','technology_product_as_role','tpd_technology_component')]/value]"/>
        <xsl:variable name="allAppTechProvs" select="$allTechProvs[name = $allAppTechProvRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
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
    <xsl:variable name="allChanges" select="/node()/simple_instance[type = ('Change_Activity','Project','Project_Activity','Programme')][name=$allStratPlanToElementRelations/own_slot_value[slot_reference='plan_to_element_change_activity']/value]"/>
	<!--	<xsl:variable name="relevantGoalArchStates" select="/node()/simple_instance[name = $project/own_slot_value[slot_reference='project_goal_state']/value]"/>-->
	<xsl:variable name="projectStakeholders" select="$allActor2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="projectActors" select="/node()/simple_instance[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="projectRoles" select="/node()/simple_instance[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="businessLayerClasses" select="('Business_Objective', 'Business_Driver', 'Business_Capability', 'Business_Process', 'Business_Activity', 'Individual_Business_Role', 'Group_Business_Role', 'Product_Type', 'Product', 'Channel', 'Group_Actor', 'Site', 'Physical_Process', 'Physical_Activity', 'Group_Actor', 'Individual_Actor')"/>
	<xsl:variable name="businessLayerLabels" select="(eas:i18n('Business Objective'), eas:i18n('Business Driver'), eas:i18n('Business Capability'), eas:i18n('Business Process'), eas:i18n('Business Activity'), eas:i18n('Individual Role'), eas:i18n('Organisation Role'), eas:i18n('Service Type'), eas:i18n('Service'), eas:i18n('Communication Channel'), eas:i18n('Organisation'), eas:i18n('Location'), eas:i18n('Implemented Process'), eas:i18n('Implemented Activity'))"/>

	<xsl:variable name="infoLayerClasses" select="('Information_View', 'Data_Subject', 'Data_Object', 'Data_Representation', 'Security_Policy', 'Information_Store')"/>
	<xsl:variable name="infoLayerLabels" select="(eas:i18n('Information Object'), eas:i18n('Data Subject'), eas:i18n('Data Object'), eas:i18n('Data Representation'), eas:i18n('Security Policy'), eas:i18n('Information/Data Store'))"/>

	<xsl:variable name="appLayerClasses" select="('Application_Service', 'Composite_Application_Provider', 'Application_Provider', 'Application_Function', 'Application_Deployment')"/>
	<xsl:variable name="appLayerLabels" select="(eas:i18n('Application Service'), eas:i18n('Application'), eas:i18n('Application'), eas:i18n('Application Function'), eas:i18n('Application Deployment'))"/>

	<xsl:variable name="techLayerClasses" select="('Technology_Capability', 'Technology_Component', 'Technology_Product', 'Technology_Product_Build', 'Infrastructure_Software_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Hardware_Instance', 'Technology_Node')"/>
	<xsl:variable name="techLayerLabels" select="(eas:i18n('Technology Capability'), eas:i18n('Technology Component'), eas:i18n('Technology Product'), eas:i18n('Technology Build'), eas:i18n('Infrastructure Software Instance'), eas:i18n('Application Software Instance'), eas:i18n('Information/Data Store Instance'), eas:i18n('Hardware Instance'), eas:i18n('Technology Node'))"/>
<xsl:variable name="supportLayerClasses" select="('Project', 'Enterprise_Strategic_Plan', 'Programme', 'Project_Activity','Supplier')"/>
	<!-- Set up the requierd link classes -->
	<xsl:variable name="linkClasses" select="($businessLayerClasses, $infoLayerClasses, $appLayerClasses, $techLayerClasses, $supportLayerClasses) "/>

	<!-- END GENERIC LINK VARIABLES -->

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

        Vis.js Timeline license:
        The MIT License (MIT)

        Copyright (c) 2014-2017 Almende B.V. and contributors
        Copyright (c) 2017-2019 vis.js contributors

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
                * 
	-->
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <script src="js/d3/d3.v2.min.js" type="application/javascript"/>
				<script src="js/d3/timeknots.js" type="application/javascript"/>
                
				<script src="js/vis/vis.min.js" type="application/javascript"/>
                <link href="js/vis/vis.min.css" media="screen" rel="stylesheet" type="text/css"/>

				<!-- Add bootstrap datepicker libraries -->
				<script type="text/javascript" src="js/bootstrap-datepicker/js/bootstrap-datepicker.min.js"/>
				<link rel="stylesheet" type="text/css" href="js/bootstrap-datepicker/css/bootstrap-datepicker.min.css"/>

				<script type="text/javascript">
				$('document').ready(function(){
					 $(".compModelContent").vAlign();
				});
                </script>

				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Project Overview</title>
                <style>
                    .popover{
						min-width:400px;
                        max-width: 800px;
					}
                    .popover.my-popover .arrow {
                            top: 9% !important;
                        }
                    .smallText{font-size:0.8em}
                </style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/> 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Project Summary for')"/>&#160;
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$this"/>
											<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
										</xsl:call-template></span>
								</h1>
							</div>
						</div> 
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>

							<div class="content-section">
								<div id="description"/>
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
								<div id="approval"/>
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
								<div id="lifecycle"/>
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
								<div id="parent"/>
							</div>
							<hr/>
						</div>




						<!--Setup Roles and People Section-->
						<div class="col-xs-9">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Roles &amp; People')"/>
							</h2>

							<div class="content-section">
								<div id="roles"/>
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
								<p><xsl:value-of select="eas:i18n('The following diagram highlights the business capabilities directly or indirectly impacted by the')"/>&#160; <xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>.</p>
								<div class="simple-scroller" style="padding-left:10px">
									<div>
										<xsl:attribute name="style" select="$widthStyle"/>
										<xsl:apply-templates mode="RenderBusinessCapabilityColumn" select="$topLevelBusCapabilities">
											<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
										</xsl:apply-templates>
									</div>
								</div>
							</div>
							<div class="clear"/>
							<hr/>
                            
                            <div class="sectionIcon">
								<i class="fa fa-cubes icon-section icon-color" />
							</div><h4><h2 class="text-primary">Impacts</h2>This section shows the elements that this project is impacting.</h4>
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
								<div id="busimpacts"></div>
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
								<div id="infoimpacts"></div>
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
								<div id="appimpacts"></div>
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
                                	  <div id="techimpacts"></div>
                                        
							</div>
							<hr/>
						</div>

						<!--Impacted Plans-->
						<div class="col-xs-12">
                           
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
                            <div class="form-group" style="float:right;width:200px">
                                <h5><b>Project End Date Change Impact</b></h5>
                                    <div class='input-group date' >
                                        <input type='text' class="form-control"  id='datechecker'/>
                                        <span class="input-group-addon" >
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supported Strategic Plans')"/>
							</h2>
							<div class="content-section">
                                This section shows the strategic plans that this project supports, and any impact its delivery schedule has on the delivery schedule of those plans
								<div id="planimpacts"></div>
                                <small>Note: if no dates are shown then they are not defined for the plan</small>
							</div>
							<hr/>
						</div>
                        
                        <div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
                           
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Strategic Plan Elements')"/>
							</h2>
							<div class="content-section">
                                This section shows the elements impacted for each strategic plan
                                <h3>Plans</h3>
                                <div id="planactive"></div>
                            	<h3>Project to Strategic Plans Overlay</h3>
                             </div>
                        </div>
						
                       <!--  <div class="col-xs-2" style="border:1pt solid #d3d3d3;border-radius:3px">
                                <div class="form-group">
                                    <h5>Project End Date Change Impact</h5>
                                    <div class='input-group date' >
                                        <input type='text' class="form-control"  id='datechecker'/>
                                        <span class="input-group-addon" >
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                    -->
                        <div class="col-xs-12">        
							<div id="visualization"></div>
							<p><small>Note: Plans or Projects with no <b>to</b> and <b>from</b> date are not shown</small></p>
                        </div>
                        <div class="col-xs-12 top-15">
                        	<hr/>
                            <h3 class="text-primary">Impact Analysis</h3>
                            
                            These elements are being changed by this project but are also being changed by other projects
                            <h4 class="top-10">Project Overlaps</h4>
                            <div id="impactAnalysis"/>
                            <h4 class="top-10">Strategic Plan Dependencies</h4>
                            Strategic plans that are dependent on the strategic plans that this project is supporting.  Note, any change in this project may have knock-on effects.
                            <div id="downstreamPlans" class="top-15"/>
                        </div>
                        <div class="col-xs-12">
                        	<hr/>
                        </div>

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
					
				
						

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                <xsl:call-template name="impactHandlebarsTemplate"/>
                <xsl:call-template name="impactPopHandlebarsTemplate"/>
                <xsl:call-template name="listHandlebarsTemplate"/>
                <xsl:call-template name="stratImpactHandlebarsTemplate"/>
                <xsl:call-template name="roleHandlebarsTemplate"/>
                <xsl:call-template name="plandepsHandlebarsTemplate"/> 
			</body>
            <script>
                 $(function () {
                    $('[data-toggle="popover"]').popover()
                    });
                
                $('.popover-dismiss').popover({
                  trigger: 'focus'
                });
                
                
                
                var project={"projectID":"<xsl:value-of select="$this/name"/>",
                         "projectName":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="$this"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>",
                         "projectDesc":"<xsl:call-template name="RenderMultiLangInstanceDescription">
											<xsl:with-param name="isRenderAsJSString" select="true()"/>
											<xsl:with-param name="theSubjectInstance" select="$this"/>
										</xsl:call-template>",
                         "approvalStatus":"<xsl:value-of select="$projectApprovalStatusName"/>",  
	                     "projectStatus":"<xsl:value-of select="$projectStatusName"/>",  
	                     "projectParentProgrammeName":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="$projectParentProgramme"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>",  
                         "proposedStartDate":"<xsl:value-of select="$jsProposedStartDate"/>",
                         "actualStartDate":"<xsl:value-of select="$jsActualStartDate"/>",
                         "targetEndDate":"<xsl:value-of select="$jsTargetEndDate"/>",
                         "forecastEndDate":"<xsl:value-of select="$jsForecastEndDate"/>",
                         "impactedElements":[<xsl:apply-templates select="$thisPlannedChanges" mode="layerInfo"/>],
                         "strategicPlansActual":[<xsl:apply-templates select="$thisInterestedStrategicPlans" mode="plansInfo"/>],
                         "strategicPlansExplict":[<xsl:apply-templates select="$thisdirectStrategicPlans" mode="plansInfo"/>],
                         "allStratPlans":[<xsl:apply-templates select="$thisInterestedStrategicPlans union $thisdirectStrategicPlans union $thisStrategicPlansviaElement" mode="plansInfo"/>],
                         "stakeholders":[<xsl:apply-templates select="$projectStakeholders" mode="stakeholders"/>]};
                
                //console.log('project', project)
              //  $('#datechecker').val('setDate',);
                $("#datechecker").datepicker('setDate',new Date(project.forecastEndDate));
                var keydates=[];
                
                keydates.push({"id":project.projectID, content:project.projectName,  start: project.actualStartDate, end: project.forecastEndDate, style:'background-color:#de8585'});
                
                project.strategicPlansExplict.forEach(function(d){
                    if(d.planStartDate &amp;&amp; d.planEndDate){
                        keydates.push({"id":d.id, content:d.name,  start: d.planStartDate, end: d.planEndDate});
                    }
                    })
          
                 
                var buscaps=[<xsl:apply-templates mode="getCaps" select="$topLevelBusCapabilities">
									</xsl:apply-templates>];
                
                var elements=[<xsl:apply-templates mode="getElements" select="$thisPlannedChangeElements">
									</xsl:apply-templates>]
                
                var impactsFragment = $("#impact-template").html();
				var impactTemplate = Handlebars.compile(impactsFragment);
                
                var impactsPopFragment = $("#impact-pop-template").html();
				var impactPopTemplate = Handlebars.compile(impactsPopFragment);
                
                var listFragment = $("#list-template").html();
				var listTemplate = Handlebars.compile(listFragment);
                
                var stratImpactFragment = $("#stratImpact-template").html();
				var stratImpactTemplate = Handlebars.compile(stratImpactFragment);
                
                var roleFragment = $("#role-template").html();
				var roleTemplate = Handlebars.compile(roleFragment);
                
                var plandepsFragment = $("#plandeps-template").html();
				var plandepsTemplate = Handlebars.compile(plandepsFragment);
                
                $(document).ready(function() {
                $(function () {
                $('#datechecker').datepicker();
                    });
          
                $('#description').html(project.projectDesc);
                $('#approval').text(project.approvalStatus);
                $('#lifecycle').text(project.projectStatus);
                $('#parent').text(project.projectParentProgrammeName);
                
                
                project.allStratPlans.forEach(function(d){
                    var risklevel;
                    if(d.planEndDate &lt; project.forecastEndDate){
                     risklevel='Delays';
                    }else
                    { risklevel='On Track';}
                    d['risk']=risklevel

                })
                let thisStratPlan=uniq(project.allStratPlans);
                
                 $("#planimpacts").html(listTemplate(thisStratPlan));
                 $("#roles").html(roleTemplate(project.stakeholders));  
                project.strategicPlansActual.forEach(function(d){
                    var thisList=[];
                     project.impactedElements.forEach(function(e){
                        if(d.id===e.planID){
                        
                        thisList.push(e);
                        }
                    });
                    d['planElements']=thisList;
                    var risklevel;
                    if(d.planEndDate &lt; project.forecastEndDate){
                    risklevel='Delays';
                    }else
                    { risklevel='On Track';}
                    d['risk']=risklevel
                    
                
                })
                
                
                $("#planactive").html(listTemplate(project.strategicPlansActual));   
                
                
                $("#downstreamPlans").html(plandepsTemplate(project.strategicPlansExplict));  
                
                
                $("div[style*='padding-top: 18px']").css('padding-top','2px');
                $("div[style*='padding-top: 9.5px']").css('padding-top','2px');                              
                   project.impactedElements.forEach(function(d){
                        if(d.instanceType==='Business_Capability'){
                            buscaps.forEach(function(e){
               
                                if(e.id===d.id){
                                    $('.'+e.id).css({'background-color':'#000000FF','color':'#ffffffff'});
                                }else if(e.subcaps)
                                {e.subcaps.forEach(function(f){
                                     if(f.id===d.id){        

                                        $('.'+f.id).css({'background-color':'#000000FF','color':'#ffffffff'});
                                        }else if(f.subcaps)
                                        {f.subcaps.forEach(function(g){
                                             if(g.id===d.id){
                                              $('.'+f.id).css({'background-color':'#000000FF','color':'#ffffffff'});
                                                };
                                            });
                                        };
                                    });
                                };
                            });
                        };
                    });
            
                var impacts=[];
                const pushIfNotIncluded = function(arr,obj){const index = arr.findIndex(object => object.id === obj.id); if (index===-1) arr.push(obj);};
                buscaps.forEach(function(e){   
                e.subcaps.forEach(function(f){
                    var thisCap={};
                    var count=0;
                    var elems=[];
                    thisCap['capability']=f.name;
                    thisCap['id']=f.id;
                        count=count+f.impacts[0].numberImpacted;
                        if(f.impacts[0].numberImpacted &gt;0){
                                f.impacts[0].elements.forEach(function(h){
                                        //if (!elems.includes(h)) elems.push(h);
                                        pushIfNotIncluded(elems,h);
                                        })
                             }
                        if(f.subcaps){
                         f.subcaps.forEach(function(g){
                                 count=count+g.impacts[0].numberImpacted;
                            if(g.impacts[0].numberImpacted &gt;0){
                                g.impacts[0].elements.forEach(function(h){
                                        //if (!elems.includes(h))elems.push(h);
                                        pushIfNotIncluded(elems,h);
                                        })
                             }
                                            });
                                        }
                      thisCap['count']=count;
                     if(elems.length&gt;0){
                        thisCap['elements']=elems;
                        }
                      impacts.push(thisCap);
                });
                                   
         
                 });
                
                impacts.forEach(function(d){
                $('#info'+d.id).text(d.count);
                if (d.count>0){$('#info'+d.id).attr('style','background-color:orange')}
                });
                
            var busI=project.impactedElements.filter(function(d){
                    return d.layer==='Business';
                })
                var appI=project.impactedElements.filter(function(d){
                    return d.layer==='Application';
                })
                var techI=project.impactedElements.filter(function(d){
                    return d.layer==='Technology';
                })
                var infoI=project.impactedElements.filter(function(d){
                    return d.layer==='Information/Data';
                })
              
                $("#busimpacts").html(impactTemplate(busI));
                $("#appimpacts").html(impactTemplate(appI));
                $("#techimpacts").html(impactTemplate(techI));
                $("#infoimpacts").html(impactTemplate(infoI));     
  
                $("#impactAnalysis").html(stratImpactTemplate(elements));     
                
                
        $('.badge').click(function(){
            thisBadge=$(this).attr('easid');
            var items=impacts.filter(function(d){
                return d.id===thisBadge;
                })    
                
                $('.popoverText').html(impactPopTemplate(items[0]));
                })
                
        $('#datechecker').change(function(){
                var thisdate=$('#datechecker').val();
                
                
                 project.strategicPlansExplict.forEach(function(d){
                console.log(d.planEndDate+":"+thisdate);
                    if(new Date(d.planEndDate) &lt; new Date(thisdate)){
           console.log('plan less')
                     $('.risk'+d.id).css('border','3pt solid red');
                    }else
                    {   console.log('plan greater')
                $('.risk'+d.id).css('border','none');}
                  

                })
                
                })  
                
        <!-- vis timeline -->
    var container = document.getElementById("visualization");

            // Create a DataSet (allows two way data-binding)
            var items = new vis.DataSet(keydates);

            // Configuration for the Timeline
            var options = {};

            // Create a Timeline
            var timeline = new vis.Timeline(container, items, options);            


           
                });
    function uniq(a) {
            var seen = {};
            return a.filter(function(item) {
                return seen.hasOwnProperty(item.id) ? false : (seen[item.id] = true);
            });
        }              
            </script>
		</html>
	</xsl:template>
     <xsl:template match="node()" mode="layerInfo"> 
         <xsl:variable name="thisInstancePlannedChangeElements" select="$thisPlannedChangeElements[name = current()/own_slot_value[slot_reference='plan_to_element_ea_element']/value]"/>
         <xsl:apply-templates select="$thisInstancePlannedChangeElements" mode="layerInfoDetails">
            <xsl:with-param name="change" select="current()/own_slot_value[slot_reference='plan_to_element_change_action']/value"/>
            <xsl:with-param name="thePlan" select="current()/own_slot_value[slot_reference='plan_to_element_plan']/value"/> 
         </xsl:apply-templates>
    </xsl:template>     
    
    <xsl:template match="node()" mode="layerInfoDetails">
    <xsl:param name="change"/> 
    <xsl:param name="thePlan"/> 
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>","layer":"<xsl:choose><xsl:when test="supertype='Business_Layer'">Business</xsl:when>
        <xsl:when test="supertype='Application_Layer'">Application</xsl:when>
        <xsl:when test="supertype='Technology_Layer'">Technology</xsl:when>
        <xsl:when test="supertype='Information_Layer'">Information/Data</xsl:when>
        <xsl:otherwise>Support</xsl:otherwise></xsl:choose>","changeType":"<xsl:value-of select="$planningActions[name=$change]/own_slot_value[slot_reference='name']/value"/>","instanceType":"<xsl:value-of select="current()/type"/>", "niceTypeName":"<xsl:value-of select="translate(current()/type,'_',' ')"/>", "plan":"<xsl:value-of select="$thisInterestedStrategicPlans[name=$thePlan]/own_slot_value[slot_reference='name']/value"/>","planID":"<xsl:value-of select="$thePlan"/>"}, 
    </xsl:template>
    
    <xsl:template match="node()" mode="plansInfo">
        <xsl:variable name="deps" select="$allStrategicPlans[name=current()/own_slot_value[slot_reference='depends_on_strategic_plans']/value]"/>
        <xsl:variable name="sups" select="$allStrategicPlans[name=current()/own_slot_value[slot_reference='supports_strategic_plan']/value]"/>
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","status":"<xsl:value-of select="$allStratStatus[name=current()/own_slot_value[slot_reference='strategic_plan_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>","planStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_from_date_iso_8601']/value"/>","planEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_to_date_iso_8601']/value"/>",
        "dependsOn":[<xsl:for-each select="$deps"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","planStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_from_date_iso_8601']/value"/>","planEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_to_date_iso_8601']/value"/>"},</xsl:for-each>],
        "supports":[<xsl:for-each select="$sups"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","planStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_from_date_iso_8601']/value"/>","planEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_to_date_iso_8601']/value"/>"},</xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>  
    </xsl:template>   
        
  
    	<xsl:template match="node()" mode="RenderBusinessCapabilityColumn">

		<div class="compModelColumn">
			<div class="compModelElementContainer"><xsl:attribute name="id"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>
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
		<xsl:variable name="activityTotal">0
			<!--<xsl:call-template name="Calculate_Project_Activity">
				<xsl:with-param name="currentCap" select="$busCapChildren"/>
			</xsl:call-template>
    -->
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
           <xsl:text> </xsl:text><xsl:value-of select="eas:getSafeJSString(current()/name)"/>
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


        <div class="compModelElementContainer"><xsl:attribute name="id"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>
            <div style="position:absolute;top:-7px;left:-7px"><span class="badge badge-secondary" href="#" data-toggle="popover" title="Impacts" data-html="true" data-content="&lt;p style='fontsize:8px;'>Number of elements impacted may be less than displayed number of impacts on the capability as an element may be impacted through several paths&lt;/p>&lt;div class='popoverText'>"><xsl:attribute name="id">info<xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute><xsl:attribute name="easid"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>0</span> </div>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="$divClass"/>
				<xsl:with-param name="anchorClass" select="$anchorClass"/>
			</xsl:call-template>
		</div>
	</xsl:template>
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
 
    <xsl:template match="node()" mode="getCaps">

		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
         "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
         "subcaps":[
			<xsl:variable name="supportingBusCaps" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="subcaps" select="$supportingBusCaps">
			</xsl:apply-templates>
		],
        "impacts":[<xsl:apply-templates mode="impacts" select="current()">
			</xsl:apply-templates>]
        }<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
    <xsl:template match="node()" mode="subcaps">
        <xsl:variable name="this" select="current()/name"/>
        <xsl:variable name="busCapChildren" select="eas:findAllSubCaps(current(), ())"/>
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
		 "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			 <xsl:with-param name="theSubjectInstance" select="current()"/>
			 <xsl:with-param name="isRenderAsJSString" select="true()"/>
		 </xsl:call-template>",
        <xsl:if test="count($busCapChildren) &gt;1">
         "subcaps":[
                <xsl:for-each select="$busCapChildren">
                    <xsl:if test="current()/name!=$this">
                {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
                        "name":"<xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="isRenderAsJSString" select="true()"/>
						</xsl:call-template>",
                        "impacts":[<xsl:apply-templates mode="impacts" select="current()">
			</xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
                    </xsl:if>
                </xsl:for-each>],</xsl:if>
        "impacts":[<xsl:apply-templates mode="impacts" select="current()">
			</xsl:apply-templates>]},    
	</xsl:template>
    <xsl:template match="node()" mode="impacts">
    <xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = current()/name]"/>
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
                <xsl:variable name="allAppDeploymentsForCap"  select="$allAppDeployments[own_slot_value[slot_reference = 'application_provider_deployed']/value = $allAppsForCap/name]"/>
                <xsl:variable name="aTechBuild" select="$allTechBuilds[name = $allAppDeploymentsForCap/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
		<xsl:variable name="aTechBuildArch" select="$allTechBuildArchs[name = $aTechBuild/own_slot_value[slot_reference = ('technology_provider_architecture','technology_product_architecture')]/value]"/>
		<xsl:variable name="aTechProUsageList" select="$allTechProvRoleUsages[name = $aTechBuildArch/own_slot_value[slot_reference = ('contained_architecture_components','contained_techProd_components')]/value]"/>
                <xsl:variable name="aTechProRole" select="$allAppTechProvRoles[name = $aTechProUsageList/own_slot_value[slot_reference = ('provider_as_role','technology_product_as_role','tpd_technology_component')]/value]"/>
                <xsl:variable name="techProdForCap" select="$allAppTechProvs[name = $aTechProRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
        <xsl:variable name="plansForBusCap" select="$thisPlannedChangeElements[name = current()/name]"/>
		<xsl:variable name="plansforBusProcs" select="$thisPlannedChangeElements[name = $busProcsForCap/name]"/>
		<xsl:variable name="plansforApps" select="$thisPlannedChangeElements[name = $allAppsForCap/name]"/>
		<xsl:variable name="plansforOrgs" select="$thisPlannedChangeElements[name = $orgsForCap/name]"/>
		<xsl:variable name="plansforTechProds" select="$thisPlannedChangeElements[name = $techProdForCap/name]"/>
                /**TORTOT<xsl:value-of select="$plansforTechProds"/>**/
        
        {"numberImpacted":<xsl:value-of select="count($plansForBusCap union $plansforApps union $plansforBusProcs union $plansforOrgs union $plansforTechProds)"/>,<xsl:if test="count($plansForBusCap union $plansforApps union $plansforBusProcs union $plansforOrgs union $plansforTechProds)&gt;0">"elements":[
        <xsl:if test="$plansForBusCap">
           
        <xsl:for-each select="$plansForBusCap">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","id":"<xsl:value-of select="current()/name"/>"},
        </xsl:for-each></xsl:if>
        <xsl:if test="$plansforBusProcs">
            
        <xsl:for-each select="$plansforBusProcs">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","id":"<xsl:value-of select="current()/name"/>"},</xsl:for-each></xsl:if>
        <xsl:if test="$plansforApps">
            
        <xsl:for-each select="$plansforApps">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","type":"<xsl:value-of select="current()/type"/>","id":"<xsl:value-of select="current()/name"/>"},</xsl:for-each></xsl:if>
        <xsl:if test="$plansforOrgs">
           
        <xsl:for-each select="$plansforOrgs">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","type":"<xsl:value-of select="current()/type"/>","id":"<xsl:value-of select="current()/name"/>"},</xsl:for-each></xsl:if>
        
        <xsl:if test="$plansforTechProds">
           
        <xsl:for-each select="$plansforTechProds">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","type":"<xsl:value-of select="current()/type"/>","id":"<xsl:value-of select="current()/name"/>"},</xsl:for-each></xsl:if>
        ]</xsl:if>}
        
    </xsl:template>
    
    <xsl:template name="impactHandlebarsTemplate">
		<script id="impact-template" type="text/x-handlebars-template">
            {{#if this}}
            <table class="table table-bordered table-striped">
            	<tr><th width="25%">Type</th><th>Name</th><th width="25%">Action</th></tr>
            {{#each this}}
                <tr><td>{{niceTypeName}}</td><td>{{{name}}}</td><td>{{changeType}}</td></tr>
            {{/each}}
            {{else}}
                No Impacts
            {{/if}}
            </table>
        </script>
    </xsl:template>
     <xsl:template name="impactPopHandlebarsTemplate">
		<script id="impact-pop-template" type="text/x-handlebars-template">
            {{#if this.elements}}
            <table class="table table-bordered table-striped smallText">
                <tr><th>Type</th><th>Name</th></tr>
            {{#each this.elements}}
                <tr><td>{{type}}</td><td>{{{name}}}</td></tr>
            {{/each}}
            {{else}}
                No Impacts
            {{/if}}
            </table>
        </script>
    </xsl:template>
     <xsl:template name="listHandlebarsTemplate">
		<script id="list-template" type="text/x-handlebars-template">
            {{#if this}}
                <table class="table table-bordered table-striped ">
             {{#each this}}
                    <tr><td><i class="fa fa-tasks"></i><xsl:text> </xsl:text> {{{name}}}<xsl:text> </xsl:text> {{#if status}}<span class="label label-default">{{this.status}}</span>{{/if}}{{#if this.planEndDate}}<div class="pull-right">From: <span class="label label-primary">{{this.planStartDate}}</span> To: <span class="label label-primary">{{this.planEndDate}}</span><xsl:text> </xsl:text> <label style="width:80px"><xsl:attribute name="class">label label-info risk{{id}}</xsl:attribute>{{this.risk}}</label></div>{{/if}}</td>{{#if this.planElements}}<td>{{#each this.planElements}}<i class="fa fa-caret-right"></i><xsl:text> </xsl:text> {{{name}}}<br/>{{/each}}</td>{{/if}}</tr>
             {{/each}}
                </table>    
             {{else}}
                No Associated Plans
             {{/if}}
           
        </script>
    </xsl:template>
    
    <xsl:template match="node()" mode="getElements">
        <xsl:variable name="thisItem" select="current()"/> 
         <xsl:variable name="thisPlanEle" select="$allStratPlanToElementRelations[own_slot_value[slot_reference='plan_to_element_ea_element']/value=current()/name]"/>
        <xsl:variable name="thisChanges" select="$allChanges[name=$thisPlanEle/own_slot_value[slot_reference='plan_to_element_change_activity']/value]"/>
        <xsl:for-each select="$thisChanges">
        <xsl:if test="current()/name!=$this/name">
            <xsl:variable name="thisP2E" select="$thisPlanEle[own_slot_value[slot_reference='plan_to_element_change_activity']/value=current()/name]"/>
            <xsl:variable name="thisStratPlan" select="$allStrategicPlans[own_slot_value[slot_reference='strategic_plan_for_elements']/value=$thisP2E/name]"/>
            {"id":"<xsl:value-of select="$thisItem/name"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisItem"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>","changeid":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","changename":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>","changeStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_actual_start_date_iso_8601']/value"/>","changeEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_forecast_end_date_iso_8601']/value"/>", "stratplanid":"<xsl:value-of select="$thisStratPlan/name"/>","stratplanname":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisStratPlan"/></xsl:call-template>"},
        </xsl:if>
        </xsl:for-each>
    </xsl:template> 
  <xsl:template name="stratImpactHandlebarsTemplate">
		<script id="stratImpact-template" type="text/x-handlebars-template">
            {{#if this}}
                <table class="table table-bordered table-striped ">
                    <tr><th>Element</th><th></th><th>Change Activity</th><th></th><th>Strategic Plan</th></tr>
             {{#each this}}
                    <tr><td>{{{name}}}</td><td style="text-align:center"><i class="fa fa-arrow-circle-right"></i><br/><span class="small">being implemented by</span></td><td>{{{changename}}}<br/>
                        <span class="label label-primary">{{#if changeStartDate}}{{changeStartDate}}{{else}}Not Defined{{/if}}</span><xsl:text> </xsl:text><span class="label label-primary">{{#if changeEndDate}}{{changeEndDate}}{{else}}Not Defined{{/if}}</span></td><td  style="text-align:center"><i class="fa fa-arrow-circle-right"></i><br/><span class="small">supporting plan</span></td><td>{{{stratplanname}}}</td></tr>
             {{/each}}
                </table>    
             {{else}}
                No Associated Plans
             {{/if}}
           
        </script>
    </xsl:template>  
    <xsl:template name="roleHandlebarsTemplate">
		<script id="role-template" type="text/x-handlebars-template">
            {{#if this}}
                <table class="table table-bordered table-striped ">
                    <tr><th><i class="fa fa-user" style="color:#d14a4a"></i> Person</th><th><i class="fa fa-briefcase"  style="color:#d14a4a"> </i> Role</th></tr>
                     
             {{#each this}}
                    <tr><td>{{{name}}}</td><td>{{role}}</td></tr>
             {{/each}}
                </table>    
             {{else}}
                No Associated People or Roles
             {{/if}}
           
        </script>
    </xsl:template>  
    <xsl:template match="node()" mode="stakeholders">
            <xsl:variable name="projectActor" select="$projectActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
            <xsl:variable name="actorName" select="$projectActor/own_slot_value[slot_reference = 'name']/value"/>
            <xsl:variable name="projectRole" select="$projectRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
            <xsl:variable name="roleName" select="$projectRole/own_slot_value[slot_reference = 'name']/value"/>
            <xsl:variable name="actorEmail" select="$projectActor/own_slot_value[slot_reference = 'email']/value"/>
            {"id":"<xsl:value-of select="$projectActor/name"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$projectActor"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>","role":"<xsl:value-of select="$roleName"/>"},
    </xsl:template>
     <xsl:template name="plandepsHandlebarsTemplate">
		<script id="plandeps-template" type="text/x-handlebars-template">
            {{#if this}}
                <table class="table table-bordered table-striped">
                	<thead>
                		<tr>
                			<th>Depends On</th>
                			<th>&#160;</th>
                			<th class="bg-aqua-100">Plan</th>
                			<th>&#160;</th>
                			<th>Supports</th>
                		</tr>
                	</thead>
                	<tbody>
                		
                	
                	
             {{#each this}}
                    <tr>
                    	<td> {{#if this.dependsOn}}{{#each this.dependsOn}}{{{name}}}<br/>{{#if this.planEndDate}}<span class="label label-primary"> Ends: {{this.planEndDate}}</span><br/>{{/if}}{{/each}}{{else}}none{{/if}}</td>
                    	<td class="text-center"><i class="fa fa-arrow-left"></i></td>
                    	<td>{{{name}}}</td>
                    	<td class="text-center"><i class="fa fa-arrow-right"></i></td>
                    	<td>{{#if this.supports}}{{#each this.supports}}{{{name}}}<br/>{{#if this.planStartDate}}<span class="label label-primary">Starts: {{this.planStartDate}}</span>{{/if}}<br/>{{/each}}{{else}}none{{/if}}</td>
                    </tr>
             {{/each}}
                	</tbody>
                </table>    
             {{else}}
                No Dependencies
             {{/if}}
           
        </script>
    </xsl:template>  
</xsl:stylesheet>
