<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_utilities.xsl"/>
    <xsl:include href="../common/core_doctype.xsl"/>
    <xsl:include href="../common/core_common_head_content.xsl"/>
    <xsl:include href="../common/core_header.xsl"/>
    <xsl:include href="../common/core_handlebars_functions.xsl"/>
    <xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
    <xsl:include href="../common/core_footer.xsl"/>
    <xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the ID of the strategic plan to be summarised -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

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
	<!--29.10.2011 NW Created New Strategic Plan Summary View-->
	<!--12.02.2019 JP Updated to support dates captured in ISO-8601 format-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<!--<xsl:variable name="linkClasses" select="('Information_Concept', 'Data_Subject', 'Information_Representation', 'Data_Representation', 'Information_View', 'Data_Object', 'Information_Store', 'Physical_Data_Object','Business_Driver', 'Group_Actor','Individual_Actor','Business_Capability','Business_Objective', 'Business_Process', 'Individual_Business_Role', 'Group_Business_Role', 'Product_Type', 'Site', 'Data_Object', 'Information_View', 'Application_Provider', 'Application_Service', 'Technology_Component', 'Business_Strategic_Plan', 'Information_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan','Technology_Composite', 'Technology_Product', 'Technology_Product_Build','Project','Business_Objective','Information_Architecture_Objective','Application_Architecture_Objectives','Technology_Architecture_Objectives', 'Application_Deployment','Application_Software_Instance','Infrastructure_Software_Instance','Information_Store_Instance', 'Technology_Node')"/>-->
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="allStratPlanToElementRelations" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="impactActions" select="/node()/simple_instance[type = 'Planning_Action']"/>
	<xsl:variable name="allImpactActionStyles" select="/node()/simple_instance[name = $impactActions/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>

	<xsl:variable name="currentPlan" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentPlanName" select="$currentPlan/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentPlanDesc" select="$currentPlan/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="currentPlanComments" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_comments']/value"/>
	<!--<xsl:variable name="impactedElements" select="/node()/simple_instance[name=$currentPlan/own_slot_value[slot_reference='strategic_plan_for_element']/value]"/>-->
	<xsl:variable name="currentPlanAction" select="/node()/simple_instance[name = $currentPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
	<xsl:variable name="currentPlanStatus" select="/node()/simple_instance[name = $currentPlan/own_slot_value[slot_reference = 'strategic_plan_status']/value]"/>
	<xsl:variable name="dependentPlans" select="/node()/simple_instance[name = $currentPlan/own_slot_value[slot_reference = 'depends_on_strategic_plans']/value]"/>
	<xsl:variable name="supportingPlans" select="/node()/simple_instance[name = $currentPlan/own_slot_value[slot_reference = 'supports_strategic_plan']/value]"/>
	<xsl:variable name="supportedObjectives" select="/node()/simple_instance[name = $currentPlan/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value]"/>
	<xsl:variable name="supportingProjects" select="/node()/simple_instance[name = $currentPlan/own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value]"/>

	<xsl:variable name="relevantServiceQualityValues" select="/node()/simple_instance[name = $supportedObjectives/own_slot_value[slot_reference = 'bo_measures']/value]"/>
	<xsl:variable name="relevantServiceQualities" select="/node()/simple_instance[name = $relevantServiceQualityValues/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>

	<xsl:variable name="endColour">#FF386A</xsl:variable>
	<xsl:variable name="startColour">#A9D18E</xsl:variable>
	<xsl:variable name="noStyleImpact">#666</xsl:variable>

	<xsl:variable name="directStrategicPlanImpactedElements" select="/node()/simple_instance[not((type = 'PLAN_TO_ELEMENT_RELATION')) and (name = $currentPlan/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>
	<xsl:variable name="directPlanImpact" select="$impactActions[name = $currentPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>

	<xsl:variable name="deprectatedStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $currentPlan/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>
	<xsl:variable name="impactedElementViaDeprectedStrategicPlansRels" select="/node()/simple_instance[name = $deprectatedStrategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>

	<xsl:variable name="strategicPlanRelations" select="$allStratPlanToElementRelations[(name = $currentPlan/own_slot_value[slot_reference = ('strategic_plan_for_elements', 'strategic_plan_for_element')]/value)]"/>
	<xsl:variable name="impactedElementViaStrategicPlansRels" select="/node()/simple_instance[name = $strategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	<xsl:variable name="supportingProjectsViaStrategicPlansRels" select="/node()/simple_instance[name = $strategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>

	<xsl:variable name="allSupportingProjects" select="$supportingProjects union $supportingProjectsViaStrategicPlansRels"/>


	<xsl:variable name="impactedElements" select="$impactedElementViaDeprectedStrategicPlansRels union $impactedElementViaStrategicPlansRels"/>

	<!-- Define the meta-class to label mappings across the architecture layers -->
	<xsl:variable name="businessLayerClasses" select="('Business_Objective', 'Business_Driver', 'Business_Capability', 'Business_Process', 'Business_Activity', 'Individual_Business_Role', 'Group_Business_Role', 'Product_Type', 'Product', 'Channel', 'Group_Actor', 'Site', 'Physical_Process', 'Physical_Activity')"/>
	<xsl:variable name="businessLayerLabels" select="(eas:i18n('Business Objective'), eas:i18n('Business Driver'), eas:i18n('Business Capability'), eas:i18n('Business Process'), eas:i18n('Business Activity'), eas:i18n('Individual Role'), eas:i18n('Organisation Role'), eas:i18n('Service Type'), eas:i18n('Service'), eas:i18n('Communication Channel'), eas:i18n('Organisation'), eas:i18n('Location'), eas:i18n('Implemented Process'), eas:i18n('Implemented Activity'))"/>

	<xsl:variable name="infoLayerClasses" select="('Information_View', 'Data_Subject', 'Data_Object', 'Data_Representation', 'Security_Policy', 'Information_Store')"/>
	<xsl:variable name="infoLayerLabels" select="(eas:i18n('Information Object'), eas:i18n('Data Subject'), eas:i18n('Data Object'), eas:i18n('Data Representation'), eas:i18n('Security Policy'), eas:i18n('Information/Data Store'))"/>

	<xsl:variable name="appLayerClasses" select="('Application_Service', 'Application_Provider_Interface', 'Composite_Application_Provider','Application_Provider_Interface','Application_Provider_Role', 'Application_Provider', 'Application_Function', 'Application_Deployment')"/>
	<xsl:variable name="appLayerLabels" select="(eas:i18n('Application Service'), eas:i18n('Application Interface'), eas:i18n('Application'), eas:i18n('Application'), eas:i18n('Application Function'), eas:i18n('Application Deployment'))"/>

	<xsl:variable name="techLayerClasses" select="('Technology_Capability', 'Technology_Component', 'Technology_Product','Technology_Product_Build', 'Technology_Product_Build_Role', 'Technology_Product_Role', 'Technology_Product_Build','Technology_Provider_Role', 'Infrastructure_Software_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Hardware_Instance', 'Technology_Node')"/>
	<xsl:variable name="techLayerLabels" select="(eas:i18n('Technology Capability'), eas:i18n('Technology Component'), eas:i18n('Technology Product'), eas:i18n('Technology Build'), eas:i18n('Infrastructure Software Instance'), eas:i18n('Application Software Instance'), eas:i18n('Information/Data Store Instance'), eas:i18n('Hardware Instance'), eas:i18n('Technology Node'))"/>

	<!-- Set up the requierd link classes -->
	<xsl:variable name="impactedElementClasses" select="($currentPlan union $impactedElements union $dependentPlans union $supportingPlans union $supportedObjectives)/type"/>
	<xsl:variable name="linkClasses" select="($impactedElementClasses, 'Project', 'Programme')"/>

	<xsl:variable name="allDates" select="/node()/simple_instance[(type = 'Year') or (type = 'Quarter') or (type = 'Gregorian')]"/>

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
	<xsl:variable name="planEssEndDateId" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value"/>
	<xsl:variable name="jsPlanEndDate">
		<xsl:choose>
			<xsl:when test="string-length($planISOEndDate) > 0">
				<xsl:value-of select="xs:date($planISOEndDate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="planEndDate" select="$allDates[name = $planEssEndDateId]"/>
				<xsl:value-of select="eas:get_end_date_for_essential_time($planEndDate)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="noStartDate" select="(string-length($planISOStartDate) = 0) and (count($currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value) = 0)"/>
	
	<xsl:variable name="noEndDate" select="(string-length($planISOEndDate) = 0) and (count($currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value) = 0)"/>
	
	<xsl:variable name="noPlanDates" select="$noStartDate and $noEndDate"/>

	<xsl:variable name="genericPageLabel">
		<xsl:value-of select="eas:i18n('Strategic Plan Summary')"/>
	</xsl:variable>
	<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' - ', $currentPlanName)"/>
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>

	<xsl:variable name="DEBUG" select="count($supportingProjectsViaStrategicPlansRels)"/>


	<xsl:template match="knowledge_base">
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
				<script src="js/d3/d3.v2.min.js?release=6.19" type="application/javascript"/>
				<script src="js/d3/timeknots.js?release=6.19" type="application/javascript"/>
                <link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>
				<script src='js/d3/d3.v5.9.7.min.js'></script> 
                <link rel="stylesheet" href="css/ess-summary.css"/>
				<style>
					.typeBox{
						padding-left: 2px;
						padding-right: 2px;
						margin-top:3px;
						border:1pt solid #d3d3d3;
						border-radius:5px;
					}
				</style>

			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template> 
            <xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
		 
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Strategic Plan Summary')"/>&#160;<xsl:value-of select="eas:i18n('for')"/>&#160;</span>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
										<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
									</xsl:call-template>
								</h1>
							</div>
						</div>
						<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
							<!-- required for floating -->
							<!-- Nav tabs -->
							<ul class="nav nav-tabs tabs-left" role="tablist">
								<li class="active" role="presentation">
									<a href="#details" id="tab-details" role="tab" aria-controls="details" aria-selected="true" tabindex="0" data-toggle="tab">
									<i class="fa fa-fw fa-users right-10" aria-hidden="true"></i>
									<xsl:value-of select="eas:i18n('Overview')"/>
									</a>
								</li>
								<li role="presentation">
									<a href="#impacts" id="tab-impacts" role="tab" aria-controls="impacts" aria-selected="false" tabindex="-1" data-toggle="tab">
									<i class="fa fa-fw fa-random right-10" aria-hidden="true"></i>
									<xsl:value-of select="eas:i18n('Impacts')"/>
									</a>
								</li>
								<li role="presentation">
									<a href="#projects" id="tab-projects" role="tab" aria-controls="projects" aria-selected="false" tabindex="-1" data-toggle="tab">
									<i class="fa fa-fw fa-wrench right-10" aria-hidden="true"></i>
									<xsl:value-of select="eas:i18n('Projects')"/>
									</a>
								</li>
								<li role="presentation">
									<a href="#documents" id="tab-documents" role="tab" aria-controls="documents" aria-selected="false" tabindex="-1" data-toggle="tab">
									<i class="fa fa-fw fa-book right-10" aria-hidden="true"></i>
									<xsl:value-of select="eas:i18n('Documentation &amp; Links')"/>
									</a>
								</li>
								</ul>

						</div>
						<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
							<!-- Tab panes -->
							<div class="tab-content">
								<div class="tab-pane active" id="details" role="tabpanel" aria-labelledby="tab-details">
									<div class="parent-superflex">
										<div class="superflex">
											<h3 class="text-primary">
												<i class="fa fa-users right-10" aria-hidden="true"></i>
												<xsl:value-of select="eas:i18n('Plan Overview')"/>
											</h3>
											
											<label for="plan-name">
												<xsl:value-of select="eas:i18n('Plan Name')"/>
											</label>
											<div class="ess-string" id="plan-name">
												<xsl:call-template name="RenderMultiLangInstanceName">
													<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
												</xsl:call-template>
											</div>

											<div class="clearfix bottom-10"></div>

											<label for="plan-description">
												<xsl:value-of select="eas:i18n('Description')"/>
											</label>
											<div class="ess-string" id="plan-description">
												<xsl:call-template name="RenderMultiLangInstanceDescription">
													<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
												</xsl:call-template>
											</div>

											<div class="clearfix bottom-10"></div> 

											<label for="plan-status">
												<xsl:value-of select="eas:i18n('Status')"/>
											</label>
											<div class="ess-string" id="plan-status">
												<xsl:choose>
													<xsl:when test="count($currentPlanStatus) &gt; 0">
														<xsl:variable name="statusColour">
															<xsl:choose>
																<xsl:when test="$currentPlanStatus/own_slot_value[slot_reference='enumeration_value']/value='Active'">#1db41d</xsl:when>
																<xsl:when test="$currentPlanStatus/own_slot_value[slot_reference='enumeration_value']/value='Old'">#666</xsl:when>
																<xsl:otherwise>#4848d1</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<div class="keySample" aria-hidden="true">
															<xsl:attribute name="style" select="concat('background-color: ', $statusColour, ';')"/>
														</div>
														<div class="textStatus">
															<xsl:value-of select="$currentPlanStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
														</div>
													</xsl:when>
													<xsl:otherwise>
														<p>-</p>
													</xsl:otherwise>
												</xsl:choose>
											</div>

											<div class="clearfix bottom-10"></div> 
										</div>

										<div class="superflex">
											<h2 class="text-primary" id="timeline-heading">
												<i class="fa fa-calendar right-10" aria-hidden="true"></i>
												<xsl:value-of select="eas:i18n('Timeline')"/>
											</h2>
											<div role="region" aria-labelledby="timeline-heading">
												<xsl:choose>
													<xsl:when test="$noPlanDates">
														<em><xsl:value-of select="eas:i18n('No start or end dates defined')"/></em>
													</xsl:when>
													<xsl:otherwise> 
														<svg id="svgdates" aria-label="Timeline graphic"/> 
													</xsl:otherwise>
												</xsl:choose>
											</div>
										</div>

										<div class="superflex">
											<h2 class="text-primary" id="objectives-heading">
												<i class="fa fa-paper-plane right-10" aria-hidden="true"></i>
												<xsl:value-of select="eas:i18n('Supported Objectives')"/>
											</h2>  
											<div class="objcard-container" role="region" aria-labelledby="objectives-heading">
												<xsl:for-each select="$supportedObjectives">
													<xsl:variable name="currentObj" select="current()"/>
													<xsl:variable name="objectiveName" select="own_slot_value[slot_reference = 'name']/value"/>
													<xsl:variable name="objectiveDesc" select="own_slot_value[slot_reference = 'description']/value"/>
													<xsl:variable name="relatedDrivers" select="$allDrivers[name = current()/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
													<xsl:variable name="measureValues" select="$relevantServiceQualityValues[name = $currentObj/own_slot_value[slot_reference = 'bo_measures']/value]"/>

													<div class="objcard">
														<div class="objcontent">
															<i class="fa fa-bullseye text-primary right-5" aria-hidden="true"></i>
															<b> <xsl:value-of select="eas:i18n('Name')"/>: </b>     
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
															<br/>

															<xsl:if test="$objectiveDesc">
																<div class="descriptionBox">
																	<xsl:value-of select="$objectiveDesc"/>
																</div>
															</xsl:if>
															<div class="icon">
																<i class="fa fa-arrow-circle-o-right" aria-hidden="true"></i>
															</div>
														</div>

														<div class="objpanel" style="overflow-y:scroll">
															<h5>
																<i class="fa fa-line-chart text-primary right-5" aria-hidden="true"></i>
																<b><xsl:value-of select="eas:i18n('KPIs')"/></b>
															</h5> 
															<xsl:choose>
																<xsl:when test="count($measureValues) > 0">
																	<xsl:for-each select="$measureValues">
																		<xsl:variable name="measureType" select="$relevantServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
																		<i class="fa fa-caret-right text-primary right-5" aria-hidden="true"></i>
																		<xsl:value-of select="$measureType/own_slot_value[slot_reference = 'name']/value"/> - 
																		<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/><br/>
																	</xsl:for-each> 
																</xsl:when>
																<xsl:otherwise><xsl:value-of select="eas:i18n('None Mapped')"/></xsl:otherwise>
															</xsl:choose> 

															<h5>
																<i class="fa fa-tags text-primary right-5" aria-hidden="true"></i>
																<b><xsl:value-of select="eas:i18n('Drivers')"/></b>
															</h5> 

															<xsl:for-each select="$relatedDrivers"> 
																<i class="fa fa-caret-right text-primary right-5" aria-hidden="true"></i>
																<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/> <br/>
															</xsl:for-each>

															<div class="close">
																<i class="fa fa-arrow-circle-o-left" aria-hidden="true"></i>
															</div>
														</div>
													</div>
												</xsl:for-each>    
											</div>
										</div>

										<div class="superflex" style="width: 100%;">
											<h2 class="text-primary" id="dependencies-heading">
												<i class="fa fa-map-signs right-10" aria-hidden="true"></i>
												<xsl:value-of select="eas:i18n('Strategic Plan Dependencies')"/>
											</h2> 
											<div role="region" aria-labelledby="dependencies-heading">
												<div class="badgeHeader" style="background-color:green;color:white">
													<i class="fa fa-caret-left right-5" style="color:white" aria-hidden="true"></i> 
													<xsl:value-of select="eas:i18n('Depends On')"/> 
												</div> 
												<xsl:call-template name="StrategicPlansTable">
													<xsl:with-param name="thePlans" select="$dependentPlans"/>
												</xsl:call-template>

												<div class="badgeHeader" style="background-color:#d96060; color:white; text-align:right;">
													<xsl:value-of select="eas:i18n('Supports')"/>
													<i class="fa fa-caret-right left-5" style="color:white" aria-hidden="true"></i> 
												</div>

												<xsl:call-template name="StrategicPlansTable">
													<xsl:with-param name="thePlans" select="$supportingPlans"/>
												</xsl:call-template>

												<div class="badgeHeader" style="background-color:#D96EE6; color:white; text-align:left;">
													<i class="fa fa-warning right-5" style="color:white" aria-hidden="true"></i> 
													<xsl:value-of select="eas:i18n('Indirect')"/> 
												</div>
												<p><xsl:value-of select="eas:i18n('Plans impacting the same elements as this plan')"/></p>
												<div id="tertiaryImpacts"/>
											</div>
										</div>
									</div> 
								</div>

							<div class="tab-pane" id="impacts" role="tabpanel" aria-labelledby="tab-impacts">
								<!-- <h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Plan Impacts')"/></h2>-->
								<div class="parent-superflex">
									<div class="superflex">
										<h3 class="text-primary" id="impacts-heading">
											<i class="fa fa-random right-10" aria-hidden="true"></i>
											<xsl:value-of select="eas:i18n('Plan Impacts')"/>
										</h3>
										<div id="impactsTable" role="region" aria-labelledby="impacts-heading"/>
									</div>
								</div> 
							</div> 

							<div class="tab-pane" id="projects" role="tabpanel" aria-labelledby="tab-projects">
								<!-- <h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Projects')"/></h2>-->
								<div class="parent-superflex">
									<div class="superflex">
										<h2 class="text-primary" id="projects-heading">
											<i class="fa fa-wrench right-10" aria-hidden="true"></i>
											<xsl:value-of select="eas:i18n('Projects')"/>
										</h2>
										<p><xsl:value-of select="eas:i18n('Projects implementing this strategic plan')"/></p>
										<div role="region" aria-labelledby="projects-heading">
											<xsl:call-template name="Projects"/>
										</div>
									</div>
								</div> 
							</div> 

							<div class="tab-pane" id="documents" role="tabpanel" aria-labelledby="tab-documents">
	<!-- <h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Documents')"/></h2> -->
								<div class="parent-superflex">
									<div class="superflex"> 
										<h2 class="text-primary" id="documents-heading">
											<i class="fa fa-book right-10" aria-hidden="true"></i>
											<xsl:value-of select="eas:i18n('Documents')"/>
										</h2>

										<div role="region" aria-labelledby="documents-heading">
											<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/>
											<xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
											
											<xsl:call-template name="RenderExternalDocRefList">
												<xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/>
											</xsl:call-template>
											
											<xsl:if test="not(anExternalDocRefList)">
												<xsl:text> </xsl:text>
												<xsl:value-of select="eas:i18n('None Mapped')"/>
											</xsl:if>
										</div>

									</div>
								</div> 
							</div>

							</div> 
						</div> 
						<!--Setup Description Section-->




							<!--Setup Strat Plan Action Section-->
						<xsl:if test="count($directPlanImpact) > 0">
							<xsl:variable name="planImpactStyle" select="concat('impact ', eas:get_element_style_class($directPlanImpact))"/>
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-check icon-section icon-color"/>
								</div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Plan Action')"/>
								</h2>
								<div>
									<p>
										<xsl:attribute name="class" select="$planImpactStyle"/>
										<xsl:value-of select="$currentPlanAction/own_slot_value[slot_reference = 'enumeration_value']/value"/>
									</p>
									<xsl:if test="count($currentPlanComments) > 0">
										<p>
											<strong><xsl:value-of select="eas:i18n('Comments')"/>: </strong>
											<xsl:value-of select="$currentPlanComments"/>
										</p>
									</xsl:if>
								</div>
								<hr/>
							</div>
						</xsl:if>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
            <script id="impacts-template" type="text/x-handlebars-template">
               <table class="table table-striped" role="table">
						<thead>
							<tr>
								<th scope="col"><xsl:value-of select="eas:i18n('Type')"/></th>
								<th scope="col"><xsl:value-of select="eas:i18n('Name')"/></th>
								<th scope="col"><xsl:value-of select="eas:i18n('Description')"/></th>
								<th scope="col"><xsl:value-of select="eas:i18n('Action')"/></th>
							</tr>
						</thead>
						<tbody>
							{{#each this}}
							<tr>
								<td>
									<i style="color:#810947" aria-hidden="true">
										<xsl:attribute name="class">fa {{this.icon}} right-5</xsl:attribute>
									</i>
									{{this.type}}
								</td>
								<td>{{this.name}}</td>
								<td>{{this.description}}</td>
								<td><span class="label label-success">{{this.action}}</span></td>
							</tr>
							{{/each}}
						</tbody>
					</table>

            </script>
            <script id="tertiary-template" type="text/x-handlebars-template">
				{{#if this}}
				{{#isNotEmpty this}}

				<table class="table" role="table">
					<thead>
						<tr>
							<th scope="col" class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Strategic Plan')"/>
							</th>
							<th scope="col" class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Impacting')"/>
							</th>
							<th scope="col" class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('End Date')"/>
							</th>
						</tr>
					</thead>

					{{#each this}} 
					<tbody> 
						<tr>
							<td>
								<div class="planBox">
									{{@key}}
								</div>
							</td>
							<td>
								{{#each this}}
								<div class="planElement">
									{{this.elementName}}
									<span class="label label-info">{{actionType}}</span>
								</div>
								{{/each}}
							</td>
							<td>
								<div class="dateColumn">
									{{setDate this.0.endDate}}
								</div>
							</td>
						</tr>
					</tbody>
					{{/each}}

				</table>    

				{{/isNotEmpty}}
				{{/if}}
            </script>
            <script>
				$('#viewpoint-bar').hide();
                var impactedElements=[<xsl:apply-templates select="$impactedElements" mode="impacts"/>];
 
var impactTemplate;
var thisId='<xsl:value-of select="$param1"/>';
 
$(document).ready(function(){
    var impactsFragment = $("#impacts-template").html();
    impactTemplate = Handlebars.compile(impactsFragment);

    var tertiaryFragment = $("#tertiary-template").html();
    tertiaryImpactsTemplate = Handlebars.compile(tertiaryFragment);
	
    Handlebars.registerHelper('isNotEmpty', function (obj, options) {
		return Object.keys(obj).length > 0 ? options.fn(this) : options.inverse(this);
	});

	essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], '', true);
    Handlebars.registerHelper('setDate', function(arg1) {
        if (arg1) {
            // Create a new Date object from the ISO date string
            const date = new Date(arg1);
    
            // Function to get the day with suffix
            function getDayWithSuffix(day) {
                const j = day % 10,
                      k = day % 100;
                if (j == 1 &amp;&amp; k != 11) {
                    return day + "st";
                }
                if (j == 2 &amp;&amp; k != 12) {
                    return day + "nd";
                }
                if (j == 3 &amp;&amp; k != 13) {
                    return day + "rd";
                }
                return day + "th";
            }
    
            // Get the day, month and year
            const day = date.getDate();
            const month = date.toLocaleString('en-GB', { month: 'long' });
            const year = date.getFullYear().toString(); // last 2 digits of year
    
            // Format the date in dd MonthName YY with suffix
            return `${getDayWithSuffix(day)} ${month} ${year}`;
        } else {
            return 'Not Set';
        }
    });
    
    var setDatehelper = Handlebars.helpers.setDate;


                let timelineData=[ 
				{"id": "abc1", "name": "Start Date", "data": "<xsl:value-of select="$jsPlanStartDate"/>", "color": "#e74c3c"},
				{"id": "abc2", "name": "End Start", "data": "<xsl:value-of select="$jsPlanEndDate"/>", "color": "#2ecc71"}
				]		
                //convert date to nice format
                timelineData.forEach((d)=>{
                    d['newDate']=setDatehelper(d.data)
                })
                //create svg timeline
                const svgNamespace = "http://www.w3.org/2000/svg";
					const svgElement = document.querySelector('#svgdates');
					 
					let currentX = 30; // Start at the center of the first loop
					// Get the parent element of the SVG
					const parentElement = svgElement.parentNode.parentNode;
              
					// Retrieve the client width of the parent element
					let svgWidth = parentElement.clientWidth;// Calculate total width needed based on number of data items
				 
					let currentXdynamic = (svgWidth)/timelineData.length;
					let lineWidth = currentXdynamic-80;
					 
					svgElement.setAttribute('width', svgWidth.toString()); // Set dynamic width based on calculated width
					
					timelineData.forEach((item, index) => {
					  // Create each circle with its specific color
					  const circle = document.createElementNS(svgNamespace, 'path');
					  circle.setAttribute('d', `M${currentX},60 a10,10 0 1,0 80,0 a10,10 0 1,0 -80,0`);
					  circle.setAttribute('stroke', item.color);
					  circle.classList.add('animated-path');
					  circle.style.animationDelay = `${index * 0.1}s`;
					  svgElement.appendChild(circle);
					
					  if (index &lt; timelineData.length - 1) {
						if (index == 0) {
						// Draw connecting line in default color
						const line = document.createElementNS(svgNamespace, 'path');
						line.setAttribute('d', `M${currentX + 80},60 L${currentX + 80 + lineWidth},60`);
						line.setAttribute('stroke', '#2980b9');
						line.classList.add('connect-line');
						line.setAttribute('stroke-width', '2');
						line.style.animationDelay = `${index * 2}s`;
						svgElement.appendChild(line);
					  }else{
						const line = document.createElementNS(svgNamespace, 'path');
						line.setAttribute('d', `M${currentX + 80},60 L${currentX + 80+ lineWidth},60`);
						line.setAttribute('stroke', '#2980b9');
						line.classList.add('connect-line');
						line.setAttribute('stroke-width', '2');
						line.style.animationDelay = `${index * 0.3}s`;
						svgElement.appendChild(line);
					  }
					}
					  
					  // Add name and date text
					  const nameText = document.createElementNS(svgNamespace, 'text');
					  nameText.setAttribute('class', 'name-text');
					  nameText.setAttribute('x', currentX + 40);
					  nameText.setAttribute('y', '65');
					  nameText.textContent = item.name;
					  svgElement.appendChild(nameText);
					
					  const dateText = document.createElementNS(svgNamespace, 'text');
					  dateText.setAttribute('class', 'date-text');
					  dateText.setAttribute('x', currentX + 40);
					  dateText.setAttribute('y', '115');
					  dateText.textContent = item.newDate;
                      dateText.setAttribute('style', 'font-weight: bold;');
					  svgElement.appendChild(dateText);
					
					  currentX += currentXdynamic; // Move to next circle's center
					});
		 
})


var redrawView=function(){
    essResetRMChanges();
 
 
		projectsArray=essRMApiData.rpp?.changeActivities ? essRMApiData.rpp?.changeActivities : [];
 console.log('essRMApiData',essRMApiData)
		let data=essRMApiData?.plans
        let plans= essRMApiData?.rpp?.strategicPlans;
		instance2planArray = {};
 
        console.log('projectsArray',projectsArray)
        console.log('plans',plans) 

        const groupByInstId = (data) => {
            return data.reduce((acc, item) => {
                // Check if the instId key already exists in the accumulator
                if (!acc[item.instId]) {
                    acc[item.instId] = []; // If not, create a new array for this instId
                }
                acc[item.instId].push(item); // Add the current item to the array for this instId
                return acc;
            }, {}); // Initialize the accumulator as an empty object
        };
        const groupedData = groupByInstId(data);
 
const planMap = Object.fromEntries(plans.map(plan => [plan.id, plan]));
 

let tertiaryImpacts=[]
impactedElements.forEach((e)=>{ 
	
    if(groupedData[e.id] &amp;&amp; groupedData[e.id].length&gt;1){
        let otherPlans=groupedData[e.id].filter((p)=>{
            return p.planId !== thisId
        })
        const seenIds = new Set();
        let uniquePlans = otherPlans.filter(plan => {
            const isDuplicate = seenIds.has(plan.planId);
            seenIds.add(plan.planId);
            return !isDuplicate;
        });

        uniquePlans.forEach((s)=>{ 
            s['planName']=planMap[s.planId].name;
        })

        tertiaryImpacts.push({"id":e.id, "name": e.name, "plans": uniquePlans})

    }
})
 
 
    const typePriority = ['Business_', 'Application_Provider', 'Composite_Application','Application_Service', 'Technology_', 'Information_Component'];

   let icons= [{type:'business',icon:'fa-tasks'},{type:'application',icon:'fa-desktop'},{type:'technology',icon:'fa-server'},{type:'information',icon:'fa-table'}, {type:'data',icon:'fa-database'},{type:'actor', icon:'fa-users'}]

    impactedElements.sort((a, b) => {
    const getIndex = (type) => {
        const index = typePriority.findIndex(element => type.startsWith(element));
        return index === -1 ? 999 : index; // return a large number if not found
    };

    return getIndex(a.type) - getIndex(b.type);
    });

    function findIcon(type) {
        // Normalize the type string to lower case
        const normalizedType = type.toLowerCase();
        // Find the first icon where the type keyword is found in the object's type property
        const foundIcon = icons.find(icon => normalizedType.includes(icon.type));
        // Return the icon class if found, otherwise undefined
        return foundIcon ? foundIcon.icon : "fa-circle";
    }
    
    impactedElements = impactedElements.map(item => ({
        ...item,
        icon: findIcon(item.type), 
        type: item.type.replace(/_/g, ' ')
    }));

    console.log('impactedElements',impactedElements)
 
    const groupedPlans = {};

    tertiaryImpacts.forEach(element => {
        element.plans.forEach(plan => {
            if (!groupedPlans[plan.planName]) {
                groupedPlans[plan.planName] = [];
            }
            groupedPlans[plan.planName].push({
                elementName: element.name,
                actionType: plan.actionType,
                endDate: plan.end
            });
        });
    });
    
    console.log('gps', groupedPlans);
 
$('#impactsTable').html(impactTemplate(impactedElements));
$('#tertiaryImpacts').html(tertiaryImpactsTemplate(groupedPlans))

}

document.querySelectorAll('.objcard').forEach(card => {
    card.querySelector('.icon').addEventListener('click', function() {
        card.querySelector('.objpanel').classList.add('open');
    });

    card.querySelector('.close').addEventListener('click', function() {
        card.querySelector('.objpanel').classList.remove('open');
    });
});

            </script>
		</html>
	</xsl:template>



	<!--<xsl:template name="PlanDependencies">
		<!-\-I've put a simple xsl:choose in here but you''ll need to set the test properly-\->
		<xsl:choose>
			<xsl:when test="count($dependentPlans) > 0">
				<ul>
					<xsl:for-each select="$dependentPlans">
						<xsl:variable name="planName" select="own_slot_value[slot_reference='name']/value"/>
						<li>
							<!-\-<a>
								<xsl:call-template name="RenderLinkHref">
									<xsl:with-param name="theXSL" select="'enterprise/core_el_strategic_plan_summary.xsl'" />
									<xsl:with-param name="theInstanceID" select="current()/name" />
									<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
									<xsl:with-param name="theHistoryLabel">Strategic Plan Summary - <xsl:value-of select="$planName" /></xsl:with-param>
									<xsl:with-param name="theParam4" select="$param4" />
									<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
								</xsl:call-template>
								<xsl:value-of select="$planName" />
							</a>-\->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No dependent plans defined for this Strategic Plan')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="SupportsPlans">
		<!-\-I've put a simple xsl:choose in here but you''ll need to set the test properly-\->
		<xsl:choose>
			<xsl:when test="count($supportingPlans) > 0">
				<ul>
					<xsl:for-each select="$supportingPlans">
						<xsl:variable name="planName" select="own_slot_value[slot_reference='name']/value"/>
						<li>
							<!-\-<a>
								<xsl:call-template name="RenderLinkHref">
									<xsl:with-param name="theXSL" select="'enterprise/core_el_strategic_plan_summary.xsl'" />
									<xsl:with-param name="theInstanceID" select="current()/name" />
									<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
									<xsl:with-param name="theHistoryLabel">Strategic Plan Summary - <xsl:value-of select="$planName" /></xsl:with-param>
									<xsl:with-param name="theParam4" select="$param4" />
									<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
								</xsl:call-template>
								<xsl:value-of select="$planName" />
							</a>-\->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No supporting plans defined for this Strategic Plan')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->

	<xsl:template name="Objectives">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($supportedObjectives) > 0">
				<table class="table ">
					<thead>
						<tr>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Objective')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('KPIs')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Motivating Drivers')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$supportedObjectives">
							<xsl:variable name="currentObj" select="current()"/>
							<xsl:variable name="objectiveName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="objectiveDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="relatedDrivers" select="$allDrivers[name = current()/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
							<xsl:variable name="measureValues" select="$relevantServiceQualityValues[name = $currentObj/own_slot_value[slot_reference = 'bo_measures']/value]"/>
							<tr>
								<td>
									<div class="objectiveBox">
                                        <xsl:call-template name="RenderInstanceLink">
                                            <xsl:with-param name="theSubjectInstance" select="current()"/>
                                            <xsl:with-param name="theXML" select="$reposXML"/>
                                            <xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
                                        </xsl:call-template>
                                    </div>
								</td>
								<td>
                                    <xsl:if test="$objectiveDesc">
                                        <div class="objectiveBoxData">
                                            <xsl:value-of select="$objectiveDesc"/>
                                        </div>
                                    </xsl:if>
                                </td>
								<td>
                                    
                                        <xsl:choose>
                                            <xsl:when test="count($measureValues) > 0">
                                                <div class="objectiveBoxDataList"> 
                                                        <xsl:for-each select="$measureValues">
                                                            <xsl:variable name="measureType" select="$relevantServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
                                                           - <xsl:value-of select="$measureType/own_slot_value[slot_reference = 'name']/value"/> - <xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/><br/>
                                                        </xsl:for-each> 
                                                </div>
                                            </xsl:when>
                                            <xsl:otherwise>-</xsl:otherwise>
                                        </xsl:choose> 
								</td>
								<td>
                                    <xsl:if test="$relatedDrivers">
                                        <div class="objectiveBoxDataList">
                                 
                                                <xsl:for-each select="$relatedDrivers"> 
                                                         <xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/> <br/>
                                                </xsl:for-each>
                                      
                                        </div>
                                    </xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No supporting Objectives defined for this Strategic Plan')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Projects">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($allSupportingProjects) > 0">
				<table class="table table-striped">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Project')"/>
							</th>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Planned Start Date')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Actual Start Date')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Target End Date')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Forecast End Date')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$allSupportingProjects">
							<xsl:variable name="project" select="current()"/>
							<xsl:variable name="projectName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="projectDesc" select="own_slot_value[slot_reference = 'description']/value"/>

							<xsl:variable name="projectStartDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
							<xsl:variable name="projectActualStartDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
							<xsl:variable name="projectEndDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
							<xsl:variable name="projectForecastEndDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_forecast_end_date']/value]"/>


							<xsl:variable name="plannedISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>
							<xsl:variable name="jsPlannedStartDate">
								<xsl:choose>
									<xsl:when test="string-length($plannedISOStartDate) > 0">
										<xsl:value-of select="xs:date($plannedISOStartDate)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="projectPlannedStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value]"/>
										<xsl:value-of select="eas:get_start_date_for_essential_time($projectPlannedStartDate)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							

							<xsl:variable name="actualISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>
							<xsl:variable name="jsActualStartDate">
								<xsl:choose>
									<xsl:when test="string-length($actualISOStartDate) > 0">
										<xsl:value-of select="xs:date($actualISOStartDate)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="projectActualStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
										<xsl:value-of select="eas:get_start_date_for_essential_time($projectActualStartDate)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							

							<xsl:variable name="targetEndISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>
							<xsl:variable name="jsTargetEndDate">
								<xsl:choose>
									<xsl:when test="string-length($targetEndISOStartDate) > 0">
										<xsl:value-of select="xs:date($targetEndISOStartDate)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="projectTargetEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
										<xsl:value-of select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
	
							<xsl:variable name="forecastEndISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>
							<xsl:variable name="jsForecastEndDate">
								<xsl:choose>
									<xsl:when test="string-length($forecastEndISOStartDate) > 0">
										<xsl:value-of select="xs:date($forecastEndISOStartDate)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="projectForecastEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value]"/>
										<xsl:value-of select="eas:get_end_date_for_essential_time($projectForecastEndDate)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>


							<!--<xsl:variable name="projectFormatOLD">
								<xsl:variable name="projectTargetEndDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
								<xsl:if test="(count($projectTargetEndDate) > 0) and (count($planEndDate) > 0)">
									<xsl:variable name="projectEndDate" select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>
									<xsl:variable name="planEndDate" select="eas:get_end_date_for_essential_time($planEndDate)"/>
									<xsl:if test="$projectEndDate > $planEndDate">backColourRed textColourWhite</xsl:if>
								</xsl:if>
							</xsl:variable>-->
							
							<xsl:variable name="jsProjectEndDate">
								<xsl:choose>
									<xsl:when test="(string-length($forecastEndISOStartDate) > 0) or ($project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value)"><xsl:value-of select="$jsForecastEndDate"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$jsTargetEndDate"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="projectFormat">
								<xsl:if test="not($noEndDate) and ($jsProjectEndDate)">
									<xsl:if test="$jsProjectEndDate > $jsPlanEndDate">backColourRed textColourWhite</xsl:if>
								</xsl:if>
							</xsl:variable>

							<xsl:variable name="plannedStartStyle" select="eas:get_date_style($jsPlanEndDate, $jsPlannedStartDate)"/>
							<xsl:variable name="actualStartStyle" select="eas:get_date_style($jsPlanEndDate, $jsActualStartDate)"/>
							<xsl:variable name="targetEndStyle" select="eas:get_date_style($jsPlanEndDate, $jsTargetEndDate)"/>
							<xsl:variable name="forecastEndStyle" select="eas:get_date_style($jsPlanEndDate, $jsForecastEndDate)"/>
							<xsl:if test="current()/type = 'Project'">
							<tr>
								<td>
									
                                    <div class="planBox"> 
                                        <xsl:call-template name="RenderInstanceLink">
                                            <xsl:with-param name="theSubjectInstance" select="current()"/>
                                            <xsl:with-param name="theXML" select="$reposXML"/>
                                            <xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
                                            <!--<xsl:with-param name="anchorClass" select="$projectFormat"/>-->
                                        </xsl:call-template>
                                    </div> 
								</td>
								<td>
									<div class="planBoxDescription">
										<!--<xsl:attribute name="class" select="$projectFormat"/>-->
										<xsl:value-of select="$projectDesc"/>
                                    </div>
								</td>
								<td>       
                                    <div class="dateColumn">
                              
                                        <xsl:choose>
                                            <xsl:when test="(count($project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value) > 0) or (count($plannedISOStartDate) > 0)">
                                                <xsl:call-template name="FullFormatDate">
                                                    <xsl:with-param name="theDate" select="$jsPlannedStartDate"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <em>undefined</em>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
								</td>
								<td>
                                   
                                    <div class="dateColumn">
                                        <xsl:choose>
                                            <xsl:when test="(count($project/own_slot_value[slot_reference = 'ca_actual_start_date']/value) > 0) or (count($actualISOStartDate) > 0)">
                                                <xsl:call-template name="FullFormatDate">
                                                    <xsl:with-param name="theDate" select="$jsActualStartDate"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <em>undefined</em>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
								</td>
								<td> 
									
                                    <div class="dateColumn">
                                        <xsl:choose>
                                            <xsl:when test="(count($project/own_slot_value[slot_reference = 'ca_target_end_date']/value) > 0) or (count($targetEndISOStartDate) > 0)">
                                                <xsl:call-template name="FullFormatDate">
                                                    <xsl:with-param name="theDate" select="$jsTargetEndDate"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <em>
                                                    <xsl:value-of select="eas:i18n('undefined')"/>
                                                </em>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
								</td>
								<td>
									 
                                    <div class="dateColumn">
                                        <xsl:choose>
                                            <xsl:when test="(count($project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value) > 0) or (count($forecastEndISOStartDate) > 0)">
                                                <xsl:call-template name="FullFormatDate">
                                                    <xsl:with-param name="theDate" select="$jsForecastEndDate"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <em>
                                                    <xsl:value-of select="eas:i18n('undefined')"/>
                                                </em>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
								</td>
							</tr>
						</xsl:if>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No supporting Projects defined for this Strategic Plan')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="ImpactedElements">
		<xsl:param name="layerElements" select="()"/>
		<xsl:param name="layerClasses" select="()"/>
		<xsl:param name="layerLabels" select="()"/>
		<xsl:param name="layerType" select="()"/>


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
				<xsl:for-each select="$directStrategicPlanImpactedElements">
					<xsl:call-template name="RenderElementImpactRow">
						<xsl:with-param name="element" select="current()"/>
						<xsl:with-param name="elementImpact" select="$directPlanImpact"/>
						<xsl:with-param name="layerClasses" select="$layerClasses"/>
						<xsl:with-param name="layerLabels" select="$layerLabels"/>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:variable name="thisStrategicPlanRels" select="$strategicPlanRelations[(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $layerElements/name) and not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $directStrategicPlanImpactedElements/name)]"/>
				<xsl:call-template name="RenderPlan2ElementsRelations">
					<xsl:with-param name="relations" select="$thisStrategicPlanRels"/>
					<xsl:with-param name="usedRelations" select="()"/>
					<xsl:with-param name="layerElements" select="$layerElements"/>
					<xsl:with-param name="layerClasses" select="$layerClasses"/>
					<xsl:with-param name="layerLabels" select="$layerLabels"/>
				</xsl:call-template>

				<xsl:variable name="thisAllDeprectatedStrategicPlanRels" select="$deprectatedStrategicPlanRelations[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $layerElements/name]"/>
				<xsl:variable name="thisFilteredDeprectatedStrategicPlanRels" select="$thisAllDeprectatedStrategicPlanRels[not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $directStrategicPlanImpactedElements/name)]"/>
				<xsl:variable name="thisDeprectatedStrategicPlanRels" select="$thisFilteredDeprectatedStrategicPlanRels[not((own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and (own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))]"/>
				<xsl:call-template name="RenderPlan2ElementsRelations">
					<xsl:with-param name="relations" select="$thisDeprectatedStrategicPlanRels"/>
					<xsl:with-param name="usedRelations" select="()"/>
					<xsl:with-param name="layerElements" select="$layerElements"/>
					<xsl:with-param name="layerClasses" select="$layerClasses"/>
					<xsl:with-param name="layerLabels" select="$layerLabels"/>
				</xsl:call-template>


			</tbody>
		</table>
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
						 <xsl:value-of select="translate($element/type,'_',' ')"/>
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
		<xsl:param name="thePlans"/>
		<xsl:choose>
			<xsl:when test="count($thePlans) > 0">
				<table class="table">
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
						<xsl:apply-templates mode="RenderStrategicPlanRow" select="$thePlans">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No supporting plans defined')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>




	<xsl:template mode="RenderStrategicPlanRow" match="node()">
		
		<xsl:variable name="thisPlanISOStartDate" select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
		<xsl:variable name="jsThisPlanStartDate">
			<xsl:choose>
				<xsl:when test="string-length($thisPlanISOStartDate) > 0">
					<xsl:value-of select="xs:date($thisPlanISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="planStartDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($planStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="thisPlanISOEndDate" select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		<xsl:variable name="jsThisPlanEndDate">
			<xsl:choose>
				<xsl:when test="string-length($thisPlanISOEndDate) > 0">
					<xsl:value-of select="xs:date($thisPlanISOEndDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="planEndDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($planEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<tr>
			<td>
                <div class="planBox">
                    <xsl:call-template name="RenderInstanceLink">
                        <xsl:with-param name="theSubjectInstance" select="current()"/>
                    </xsl:call-template>
                </div>
			</td>
			<td>
                <div class="planBoxDescription">
                    <xsl:call-template name="RenderMultiLangInstanceDescription">
                        <xsl:with-param name="theSubjectInstance" select="current()"/>
                    </xsl:call-template>
                </div>
			</td>
			<td>
                <div class="dateColumn">
                    <xsl:choose>
                        <xsl:when test="(count(current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value) = 0) and (count($thisPlanISOStartDate) = 0)">
                            <em>Undefined</em>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="FullFormatDate">
                                <xsl:with-param name="theDate" select="$jsThisPlanStartDate"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
			</td>
			<td>
                <div class="dateColumn">
                    <xsl:choose>
                        <xsl:when test="(count(current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value) = 0) and (count($thisPlanISOEndDate) = 0)">
                            <em>Undefined</em>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="FullFormatDate">
                                <xsl:with-param name="theDate" select="$jsThisPlanEndDate"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
			</td>
		</tr>
	</xsl:template>


	<xsl:function name="eas:get_date_style" as="xs:string">
		<xsl:param name="targetDate"/>
		<xsl:param name="givenDate"/>


		<xsl:choose>
			<xsl:when test="(count($givenDate) > 0) and (not($noEndDate))">
				<xsl:choose>
					<xsl:when test="$givenDate > $targetDate">backColourRed textColourWhite</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

<xsl:template match="node()" mode="impacts">
    <xsl:variable name="thisStrategicPlanRels" select="$strategicPlanRelations[(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value =current()/name) and not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $directStrategicPlanImpactedElements/name)]"/>
 

    <xsl:variable name="thisAllDeprectatedStrategicPlanRels" select="$deprectatedStrategicPlanRelations[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = current()/name]"/>
    <xsl:variable name="thisFilteredDeprectatedStrategicPlanRels" select="$thisAllDeprectatedStrategicPlanRels[not(own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $directStrategicPlanImpactedElements/name)]"/>
    <xsl:variable name="thisDeprectatedStrategicPlanRels" select="$thisFilteredDeprectatedStrategicPlanRels[not((own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and (own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $thisStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))]"/>

    <xsl:variable name="action" select="$impactActions[name=$thisStrategicPlanRels/own_slot_value[slot_reference='plan_to_element_change_action']/value]"/>
    <xsl:variable name="actionOld" select="$impactActions[name=$thisDeprectatedStrategicPlanRels/own_slot_value[slot_reference='strategic_planning_action']/value]"/>
   <xsl:variable name="action" select="$action union $actionOld"/>
    <!--
    <xsl:call-template name="RenderPlan2ElementsRelations">
        <xsl:with-param name="relations" select="$thisDeprectatedStrategicPlanRels"/>
        <xsl:with-param name="usedRelations" select="()"/>
        <xsl:with-param name="layerElements" select="$layerElements"/>
        <xsl:with-param name="layerClasses" select="$layerClasses"/>
        <xsl:with-param name="layerLabels" select="$layerLabels"/>
    </xsl:call-template>
-->
<xsl:variable name="elementName" select="$thisStrategicPlanRels/own_slot_value[slot_reference = 'name']/value"/>
<xsl:variable name="elementRelationName" select="$thisStrategicPlanRels/own_slot_value[slot_reference = 'relation_name']/value"/>
<xsl:variable name="elementDesc" select="$thisStrategicPlanRels/own_slot_value[slot_reference = 'description']/value"/>  
<xsl:choose>
	<xsl:when test="count($action)>1">
		<xsl:variable name="main" select="current()"/>
		<xsl:for-each select="$action">
		{
			"id":"<xsl:value-of select="$main/name"/>",
			<xsl:variable name="temp" as="map(*)" select="map{
				'description': string(translate(translate($main/own_slot_value[slot_reference = ('relation_description')]/value, '}', ')'), '{', ')')),
				'name': string($main/own_slot_value[slot_reference = 'name']/value)
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"></xsl:value-of>,
			"type":"<xsl:value-of select="$main/type"/>",
		    "action":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>" 
		
		}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
		{
			"id":"<xsl:value-of select="current()/name"/>",
			<xsl:variable name="temp" as="map(*)" select="map{
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('relation_description')]/value, '}', ')'), '{', ')')),
				'name': string(current()/own_slot_value[slot_reference = 'name']/value)
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"></xsl:value-of>,
			"type":"<xsl:value-of select="current()/type"/>",
		    "action":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$action"/>
			</xsl:call-template>" 
		
		} 
	</xsl:otherwise>
	</xsl:choose>	
	<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>


</xsl:stylesheet>
