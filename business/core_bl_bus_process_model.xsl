<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_uml_model_links.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param2 = the path of the dynamically generated UML model -->
	<xsl:param name="param2"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Group_Actor', 'Individual_Actor', 'Individual_Business_Role', 'Information_View')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:param name="imageFilename"/>
	<xsl:param name="imageMapPath"/>

	<xsl:variable name="modelSubject" select="/node()/simple_instance[name = $param1]"/>
	<!--<xsl:variable name="modelSubjectName" select="$modelSubject/own_slot_value[slot_reference='name']/value" />-->
	<xsl:variable name="modelSubjectName">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$modelSubject"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="overallProcessFlow" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
	<xsl:variable name="processFlowRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_process_flow']/value = $overallProcessFlow/name]"/>

	<!-- get the list of process owners in scope -->
	<xsl:variable name="processOwnerRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Process Owner')]"/>
	<xsl:variable name="processOwnerActor2Roles" select="/node()/simple_instance[(name = $business_processes/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processOwnerRole/name)]"/>
	<xsl:variable name="processOwners" select="/node()/simple_instance[name = $processOwnerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

	<!-- get theinput and output services for the procedure -->
	<xsl:variable name="procedurePhysProc" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $modelSubject/name]"/>
	<xsl:variable name="inputServices" select="/node()/simple_instance[name = $procedurePhysProc/own_slot_value[slot_reference = 'phys_bp_consumes_products']/value]"/>
	<xsl:variable name="outputServices" select="/node()/simple_instance[own_slot_value[slot_reference = 'product_implemented_by_process']/value = $procedurePhysProc/name]"/>

	<!-- get the list of Business Process Usages in scope -->
	<xsl:variable name="allProcessUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name]"/>
	<xsl:variable name="processUsages" select="$allProcessUsages[(type = 'Business_Activity_Usage') or (type = 'Business_Process_Usage')]"/>
	<xsl:variable name="decisionUsages" select="$allProcessUsages[(type = 'Business_Process_Flow_Decision')]"/>
	<xsl:variable name="processAndDecsionUsages" select="$processUsages union $decisionUsages"/>
	<xsl:variable name="processPerfRoleUsages" select="$allProcessUsages[type = 'Business_Role_Usage_In_Process']"/>
	

	<xsl:variable name="startUsage" select="$allProcessUsages[(type = 'Start_Process_Flow')]"/>
	<xsl:variable name="startRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':FROM']/value = $startUsage/name]"/>

	<!-- get the list of Business Processes in scope -->
	<xsl:variable name="business_processes" select="/node()/simple_instance[(name = $processUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $processUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<!-- get the list of Business Roles in scope -->
	<xsl:variable name="allRoles" select="/node()/simple_instance[type = ('Group_Business_Role', 'Individual_Business_Role')]"/>
	<xsl:variable name="direct_business_roles" select="$allRoles[name = $business_processes/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
	<xsl:variable name="processPerfRoles" select="$allRoles[name = $processPerfRoleUsages/own_slot_value[slot_reference = 'business_role_used']/value]"/>
	<xsl:variable name="perfRoleRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':TO']/value = $processPerfRoleUsages/name]"/>
	<xsl:variable name="defined_business_roles" select="$direct_business_roles union $processPerfRoles"/>
	<xsl:variable name="decisionMakers" select="/node()/simple_instance[name = $decisionUsages/own_slot_value[slot_reference = 'bpfd_decision_makers']/value]"/>

	<xsl:variable name="allProcess2InfoRels" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'busproctype_uses_infoviews']/value]"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[name = $allProcess2InfoRels/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>

	<!-- get the list of Start Events in scope -->
	<xsl:variable name="startEventUsages" select="$allProcessUsages[type = 'Initiating_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="startEvents" select="/node()/simple_instance[name = $startEventUsages/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value]"/>
	<xsl:variable name="startEventRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':FROM']/value = $startEventUsages/name]"/>

	<!-- get the list of Goal Events in scope -->
	<xsl:variable name="goalEventUsages" select="$allProcessUsages[type = 'Raised_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="goalEvents" select="/node()/simple_instance[name = $goalEventUsages/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value]"/>
	<xsl:variable name="goalEventRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':TO']/value = $goalEventUsages/name]"/>

	<!-- get the start node -->
	<!--<xsl:variable name="startNode" select="/node()/simple_instance[(own_slot_value[slot_reference='used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'Start_Process_Flow')]"/>-->

	<!-- get the end node -->
	<xsl:variable name="endNode" select="/node()/simple_instance[(own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'End_Process_Flow')]"/>


	<!--<xsl:variable name="firstProcessRelation" select="$processFlowRelations[own_slot_value[slot_reference=':FROM']/value = $startEventUsages/name]"/>-->
	<xsl:variable name="firstProcessUsage" select="$processUsages[name = ($startEventRelations, $startRelations)/own_slot_value[slot_reference = ':TO']/value]"/>
	<xsl:variable name="firstBusProc" select="$business_processes[(name = $firstProcessUsage/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $firstProcessUsage/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<xsl:variable name="relationList" select="eas:generateRelationList($firstProcessUsage, $processFlowRelations, ())"/>
	<xsl:variable name="orderedStepIds" select="$relationList/own_slot_value[slot_reference = ':FROM']/value"/>
	<xsl:variable name="orderedProcessSteps" select="$allProcessUsages[name = $relationList/own_slot_value[slot_reference = ':FROM']/value]"/>

	<xsl:variable name="pageType">
		<xsl:value-of select="eas:i18n('Business Process Model')"/>
	</xsl:variable>
	<xsl:variable name="pageTitle" select="concat($pageType, ' - ', $modelSubjectName)"/>

	<xsl:variable name="peopleIconList" select="('person-icon-darkblue.png', 'person-icon-green.png', 'person-icon-lightblue.png', 'person-icon-pink.png', 'person-icon-purple.png', 'person-icon-red.png', 'person-icon-yellow.png', 'person-icon-brown.png')"/>
	<xsl:variable name="undefinedPeopleIcon" select="'person-icon-empty.png'"/>
	<xsl:variable name="undefinedPeopleIconPath" select="'images/person-icon-empty.png'"/>
	<xsl:variable name="peopleColourList" select="('#313CA3', '#417505', '#4A90E2', '#E09CA4', '#824DB1', '#D0021B', '#F5A623', '#8B572A')"/>

	<xsl:variable name="DEBUG" select="''"/>

	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->
	<!--05.08.2016 NJW Updated to Support Viewer v5-->



	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<meta http-equiv="expires" content="-1"/>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageTitle"/>
				</title>
				<script src="js/jquery-migrate-1.4.1.min.js?release=6.19" type="text/javascript"/>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<!--Dependencies for JointJS UML Diagram-->
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css?release=6.19"/>
				<script src="js/lodash/index.js?release=6.19"/>
				<script src="js/backbone/backbone.js?release=6.19"/>
				<script src="js/graphlib/graphlib.core.js?release=6.19"/>
				<script src="js/dagre/dagre.core.js?release=6.19"/>
				<script src="js/jointjs/joint.min.js?release=6.19"/>
				<!--Dependencies for JointJS UML Diagram Ends-->
				<style>
					#paper{
						position: relative;
						margin-left: auto;
						margin-right: auto;
						min-width: 460px;
						min-height: 300px;
					}</style>
			</head>
			<template id="link-controls-template">
				<div id="link-controls" class="controls">
					<label for="labelpos">LabelPos:</label>
					<select id="labelpos">
						<option value="c">c</option>
						<option value="r">r</option>
						<option value="l">l</option>
					</select>
					<label for="minlen">MinLen:</label>
					<input id="minlen" type="range" min="1" max="5" value="1"/>
					<label for="weight">Weight:</label>
					<input id="weight" type="range" min="1" max="10" value="1"/>
					<label for="labeloffset">LabelOffset:</label>
					<input id="labeloffset" type="range" min="1" max="10" value="10"/>
				</div>
			</template>
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference = 'description']/value"/>

				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey">
									<xsl:value-of select="$pageTitle"/>
									<!-- <xsl:value-of select="$DEBUG"/> -->
								</span>
							</h1>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Description')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:value-of select="eas:i18n('The following table provides high level details for the')"/>&#160;<strong><xsl:value-of select="$modelSubjectName"/></strong>&#160;<xsl:value-of select="eas:i18n('process')"/>. <div class="verticalSpacer_10px"/>
								<xsl:call-template name="ProcessSummaryTable"/>
							</div>
							<hr/>
						</div>


						<!--Setup Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Model')"/>
								</h2>
							</div>
							<xsl:choose>
								<xsl:when test="not($overallProcessFlow)">
									<div class="content-section">
										<p>No Model Defined</p>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="content-section">
										<div class="simple-scroller">
											
											<div id="layout-controls" class="bottom-30">
												<!--<div class="col-xs-2">
														<label for="ranker">Layout Type:</label>
														<select id="ranker" class="form-control">
															<option value="network-simplex" selected="selected">Network Simplex</option>
															<option value="tight-tree">Tight Tree</option>
															<option value="longest-path">Longest Path</option>
														</select>
													</div>-->
												<div class="width200px pull-left right-30">
													<label for="rankdir">Model Direction:</label>
													<select id="rankdir" class="form-control">
														<option value="TB" selected="selected">Top to Bottom</option>
														<!--<option value="BT">Bottom To Top</option>-->
														<!--<option value="RL">Right to Left</option>-->
														<option value="LR">Left to Right</option>
													</select>
												</div>
												<div class="width200px pull-left right-30">
													<label for="align">Model Alignment:</label>
													<select id="align" class="form-control">
														<option value="UL" selected="selected">Left</option>
														<option value="UR">Right</option>
														<!--<option value="DL">Down and Left</option>
															<option value="DR">Down and Right</option>-->
													</select>
												</div>
												<div class="width200px pull-left right-30">
													<label for="ranksep">Object Spacing</label>
													<input id="ranksep" type="range" min="1" max="100" value="50" class="form-control"/>
												</div>
												<div class="width200px pull-left right-30">
													<label for="edgesep">Edge Spacing:</label>
													<input id="edgesep" type="range" min="1" max="100" value="50" class="form-control"/>
												</div>
												<div class="width200px pull-left right-30">
													<label for="nodesep">Row/Column Spacing:</label>
													<input id="nodesep" type="range" min="1" max="100" value="50" class="form-control"/>
												</div>
											</div>
											<div class="clearfix"></div>
											<xsl:call-template name="legend"/>
											<div class="clearfix"></div>
											<div id="paper"/>
										</div>
									</div>
								</xsl:otherwise>
							</xsl:choose>

							<hr/>
						</div>

						<!--Setup Process Steps Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-valuechain  icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Process Steps')"/>
								</h2>
								<xsl:choose>
									<xsl:when test="count($allProcessUsages) > 0">
										<div class="content-section">
											<xsl:value-of select="eas:i18n('The following steps are defined for the')"/>&#160;<strong><xsl:value-of select="$modelSubjectName"/></strong>&#160;<xsl:value-of select="eas:i18n('process')"/>. <div class="verticalSpacer_10px"/>
											<xsl:call-template name="ProcessSteps"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No steps defined for this process')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<xsl:call-template name="processModelScript"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template mode="RenderStartEvent" match="node()">
		<xsl:variable name="eventId" select="concat('startEvent', position())"/>
		<xsl:variable name="eventLabel">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable> elements.push( new StartEventShape({ id: '<xsl:value-of select="$eventId"/>'}).setText('<xsl:value-of select="$eventLabel"/>') );<xsl:text>
			
		</xsl:text>
	</xsl:template>

	<xsl:template mode="RenderGoalEvent" match="node()">
		<xsl:variable name="eventId" select="concat('goalEvent', position())"/>
		<xsl:variable name="eventLabel">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable> elements.push( new GoalEventShape({ id: '<xsl:value-of select="$eventId"/>'}).setText('<xsl:value-of select="$eventLabel"/>') );<xsl:text>
			
		</xsl:text>
	</xsl:template>


	<xsl:template mode="RenderBusProc" match="node()">
		<xsl:variable name="busProcId" select="concat('busProc', position())"/>
		<xsl:variable name="busProcUsage" select="$processUsages[own_slot_value[slot_reference = ('business_process_used', 'business_activity_used')]/value = current()/name]"/>
		<xsl:variable name="perfRoleRelation" select="$perfRoleRelations[own_slot_value[slot_reference = ':FROM']/value = $busProcUsage/name]"/>
		<xsl:variable name="perfRoleUsage" select="$processPerfRoleUsages[name = $perfRoleRelation/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="perfRole" select="$processPerfRoles[name = $perfRoleUsage/own_slot_value[slot_reference = 'business_role_used']/value]"/>

		<xsl:variable name="busRoleIconPath">
			<xsl:choose>
				<xsl:when test="count($perfRole) > 0">
					<xsl:call-template name="RenderIconPath">
						<xsl:with-param name="businessRole" select="$perfRole[1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderIconPath">
						<xsl:with-param name="businessRole" select="$defined_business_roles[name = current()/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="busProcName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable> elements.push( new Shape({ id: '<xsl:value-of select="$busProcId"/>', attrs: { image: { 'xlink:href': '<xsl:value-of select="$busRoleIconPath"/>' } } }).setText('<xsl:value-of select="$busProcName"/>') );<xsl:text>
			
		</xsl:text>
	</xsl:template>


	<xsl:template mode="RenderDecision" match="node()">
		<xsl:variable name="decisionTextId" select="concat('decisionText', position())"/>
		<xsl:variable name="decisionPointId" select="concat('decisionPoint', position())"/>
		<xsl:variable name="decisionLabel" select="current()/own_slot_value[slot_reference = 'business_process_arch_display_label']/value"/> elements.push( new DecisionTextShape({ id: '<xsl:value-of select="$decisionTextId"/>' }).setText('<xsl:value-of select="$decisionLabel"/>') );<xsl:text>
			
		</xsl:text> elements.push( new DecisionPointShape({ id: '<xsl:value-of select="$decisionPointId"/>' }).setText('') );<xsl:text>
			
		</xsl:text>
	</xsl:template>


	<xsl:template mode="RenderDecisionLink" match="node()">
		<xsl:variable name="decisionTextId" select="concat('decisionText', position())"/>
		<xsl:variable name="decisionPointId" select="concat('decisionPoint', position())"/> links.push( new DecisionLink() .connect('<xsl:value-of select="$decisionTextId"/>', '<xsl:value-of select="$decisionPointId"/>') );<xsl:text>
			
		</xsl:text>
	</xsl:template>


	<xsl:template mode="RenderStartProcessLink" match="node()">
		<!--<xsl:variable name="parentUsage" select="$processAndDecsionUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>-->
		<xsl:variable name="childUsage" select="$processAndDecsionUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="parentUsageId" select="'StartNode'"/>

		<xsl:variable name="childUsageId">
			<xsl:call-template name="GetToNodeId">
				<xsl:with-param name="aNode" select="$childUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="(string-length($parentUsageId) > 0) and (string-length($childUsageId) > 0)"> links.push( new Link() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') );<xsl:text>
					
			</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:template mode="RenderStartEventLink" match="node()">
		<xsl:variable name="parentUsage" select="$startEventUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="childUsage" select="$processAndDecsionUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>


		<xsl:variable name="parentUsageId">
			<xsl:call-template name="GetFromNodeId">
				<xsl:with-param name="aNode" select="$parentUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="childUsageId">
			<xsl:call-template name="GetToNodeId">
				<xsl:with-param name="aNode" select="$childUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="(string-length($parentUsageId) > 0) and (string-length($childUsageId) > 0)"> links.push( new Link() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') );<xsl:text>
					
			</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:template mode="RenderGoalEventLink" match="node()">
		<xsl:variable name="parentUsage" select="$processAndDecsionUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="childUsage" select="$goalEventUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>


		<xsl:variable name="parentUsageId">
			<xsl:call-template name="GetFromNodeId">
				<xsl:with-param name="aNode" select="$parentUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="childUsageId">
			<xsl:call-template name="GetToNodeId">
				<xsl:with-param name="aNode" select="$childUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="(string-length($parentUsageId) > 0) and (string-length($childUsageId) > 0)"> links.push( new Link() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') );<xsl:text>
					
			</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:template mode="RenderProcessLink" match="node()">
		<xsl:variable name="parentUsage" select="$processAndDecsionUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="childUsage" select="$processAndDecsionUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="parentUsageId">
			<xsl:call-template name="GetFromNodeId">
				<xsl:with-param name="aNode" select="$parentUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="childUsageId">
			<xsl:call-template name="GetToNodeId">
				<xsl:with-param name="aNode" select="$childUsage"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="(string-length($parentUsageId) > 0) and (string-length($childUsageId) > 0)">
			<xsl:choose>
				<xsl:when test="$parentUsage/type = 'Business_Process_Flow_Decision'"> links.push( new DecisionResponseLink() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') .setLabelText('<xsl:value-of select="current()/own_slot_value[slot_reference = ':relation_label']/value"/>') );<xsl:text>
					
				</xsl:text>
				</xsl:when>
				<xsl:otherwise> links.push( new Link() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') );<xsl:text>
					
				</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

	</xsl:template>


	<xsl:template name="GetFromNodeId">
		<xsl:param name="aNode"/>

		<xsl:choose>
			<xsl:when test="$aNode/type = ('Business_Process_Usage', 'Business_Activity_Usage')">
				<xsl:variable name="nodeBusProc" select="$business_processes[(name = $aNode/own_slot_value[slot_reference = ('business_process_used', 'business_activity_used')]/value)]"/>
				<xsl:variable name="nodeIndex" select="index-of($business_processes, $nodeBusProc)"/>
				<xsl:value-of select="concat('busProc', $nodeIndex)"/>
			</xsl:when>
			<xsl:when test="$aNode/type = ('Business_Process_Flow_Decision')">
				<xsl:variable name="nodeIndex" select="index-of($decisionUsages, $aNode)"/>
				<xsl:value-of select="concat('decisionPoint', $nodeIndex)"/>
			</xsl:when>
			<xsl:when test="$aNode/type = ('Initiating_Business_Event_Usage_In_Process')">
				<xsl:variable name="nodeEvent" select="$startEvents[(name = $aNode/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value)]"/>
				<xsl:variable name="nodeIndex" select="index-of($startEvents, $nodeEvent)"/>
				<xsl:value-of select="concat('startEvent', $nodeIndex)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="GetToNodeId">
		<xsl:param name="aNode"/>

		<xsl:choose>
			<xsl:when test="$aNode/type = ('Business_Process_Usage', 'Business_Activity_Usage')">
				<xsl:variable name="nodeBusProc" select="$business_processes[(name = $aNode/own_slot_value[slot_reference = ('business_process_used', 'business_activity_used')]/value)]"/>
				<xsl:variable name="nodeIndex" select="index-of($business_processes, $nodeBusProc)"/>
				<xsl:value-of select="concat('busProc', $nodeIndex)"/>
			</xsl:when>
			<xsl:when test="$aNode/type = ('Business_Process_Flow_Decision')">
				<xsl:variable name="nodeIndex" select="index-of($decisionUsages, $aNode)"/>
				<xsl:value-of select="concat('decisionText', $nodeIndex)"/>
			</xsl:when>
			<xsl:when test="$aNode/type = ('Raised_Business_Event_Usage_In_Process')">
				<xsl:variable name="nodeEvent" select="$goalEvents[(name = $aNode/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value)]"/>
				<xsl:variable name="nodeIndex" select="index-of($goalEvents, $nodeEvent)"/>
				<xsl:value-of select="concat('goalEvent', $nodeIndex)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="ProcessSummaryTable">
		<xsl:variable name="procDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$modelSubject"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="thisProcessOwnerActor2Role" select="/node()/simple_instance[(name = $modelSubject/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processOwnerRole/name)]"/>
		<xsl:variable name="thisProcessOwner" select="/node()/simple_instance[name = $thisProcessOwnerActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>


		<xsl:variable name="inputBusProc2Info" select="$allProcess2InfoRels[(own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value = $modelSubject/name) and (own_slot_value[slot_reference = 'busproctype_reads_infoview']/value = 'Yes')]"/>
		<xsl:variable name="inputInfo" select="$allInfoViews[name = $inputBusProc2Info/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>

		<xsl:variable name="outputBusProc2Info" select="$allProcess2InfoRels[(own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value = $modelSubject/name) and (own_slot_value[slot_reference = ('busproctype_updates_infoview', 'busproctype_creates_infoview')]/value = 'Yes')]"/>
		<xsl:variable name="outputInfo" select="$allInfoViews[name = $outputBusProc2Info/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>


		<xsl:variable name="procGuidingFactors" select="/node()/simple_instance[(name = $modelSubject/own_slot_value[slot_reference = 'commentary']/value)]"/>

		<xsl:variable name="procKPIs" select="/node()/simple_instance[(name = $modelSubject/own_slot_value[slot_reference = 'performance_indicators']/value)]"/>

		<table class="table table-bordered ">
			<tr>
				<th class="cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Description')"/>
				</th>
				<td>
					<xsl:value-of select="$procDesc"/>
				</td>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="eas:i18n('Owner')"/>
				</th>
				<td>
					<xsl:choose>
						<xsl:when test="count($thisProcessOwner) > 0">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$thisProcessOwner"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<em>
								<xsl:value-of select="eas:i18n('No procedure owner defined')"/>
							</em>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="eas:i18n('Inputs')"/>
				</th>
				<td>
					<xsl:choose>
						<xsl:when test="count($inputInfo union $inputServices) > 0">
							<xsl:if test="count($inputInfo) > 0">
								<em>Information</em>
								<br/>
								<ul>
									<xsl:for-each select="$inputInfo">
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<xsl:if test="count($inputServices) > 0">
								<em>Services</em>
								<br/>
								<ul>
									<xsl:for-each select="$inputServices">
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<em>
								<xsl:value-of select="eas:i18n('No inputs defined')"/>
							</em>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<th>
				<xsl:value-of select="eas:i18n('Outputs')"/>
			</th>
			<td>
				<xsl:choose>
					<xsl:when test="count($outputInfo union $outputServices) > 0">
						<xsl:if test="count($outputInfo) > 0">
							<em>Information</em>
							<br/>
							<ul>
								<xsl:for-each select="$outputInfo">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:if>
						<xsl:if test="count($outputServices) > 0">
							<em>Services</em>
							<br/>
							<ul>
								<xsl:for-each select="$outputServices">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<em>
							<xsl:value-of select="eas:i18n('No outputs defined')"/>
						</em>
					</xsl:otherwise>
				</xsl:choose>
				<!--<xsl:choose>
						<xsl:when test="count($outputInfo) > 0">
							<ul>
								<xsl:for-each select="$outputInfo">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()" />
											<xsl:with-param name="theXML" select="$reposXML" />
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:otherwise><em><xsl:value-of select="eas:i18n('No outputs defined')"/></em></xsl:otherwise>
					</xsl:choose>-->
			</td>
			<!--<tr>
				<th><xsl:value-of select="eas:i18n('Guiding Factors')"/></th>
				<td>
					<xsl:choose>
						<xsl:when test="count($procGuidingFactors) > 0">
							<ul>
								<xsl:for-each select="$procGuidingFactors">
									<li>
										<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:otherwise><em><xsl:value-of select="eas:i18n('No guiding factors defined')"/></em></xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>-->
			<tr>
				<th>
					<xsl:value-of select="eas:i18n('Starting Events')"/>
				</th>
				<td>
					<xsl:choose>
						<xsl:when test="count($startEvents) > 0">
							<ul>
								<xsl:for-each select="$startEvents">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="displayString" select="current()/own_slot_value[slot_reference = 'business_process_used']/value"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:otherwise>
							<em>
								<xsl:value-of select="eas:i18n('No start events defined')"/>
							</em>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="ProcessSteps">

		<table class="table table-bordered" id="dt_Cat">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('No')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Step')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Owner')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Next Step')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('No')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Step')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Owner')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Next Step')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<!--<xsl:apply-templates mode="ProcessStepRow" select="$relationList"/>	-->
				<xsl:call-template name="RenderProcessStepRow">
					<xsl:with-param name="inScopeRelations" select="$relationList"/>
					<xsl:with-param name="stepsFound" select="()"/>
				</xsl:call-template>
				<!--<xsl:for-each select="$orderedStepIds">
					<xsl:call-template name="ProcessStepRow">
						<xsl:with-param name="stepId" select="current()"/>
					</xsl:call-template>
				</xsl:for-each>-->
			</tbody>
		</table>
		<script>
			$(document).ready(function(){
				// Setup - add a text input to each footer cell
			    $('#dt_Cat tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
			    } );
				
				var table = $('#dt_Cat').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "5%" },
				    { "width": "30%" },
				    { "width": "35%" },
				    { "width": "20%" },
				    { "width": "10%" }
				  ],
				dom: 'Bfrtip',
			    buttons: [
		            'copyHtml5', 
		            'excelHtml5',
		            'csvHtml5',
		            'pdfHtml5',
		            'print'
		        ]
				});
				
				
				// Apply the search
			    table.columns().every( function () {
			        var that = this;
			 
			        $( 'input', this.footer() ).on( 'keyup change', function () {
			            if ( that.search() !== this.value ) {
			                that
			                    .search( this.value )
			                    .draw();
			            }
			        } );
			    } );
			    
			    table.columns.adjust();
			    
			    $(window).resize( function () {
			        table.columns.adjust();
			    });
			});
		</script>
	</xsl:template>


	<xsl:template name="RenderProcessStepRow">
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="stepsFound"/>


		<xsl:if test="count($inScopeRelations) > 0">
			<xsl:variable name="thisRelation" select="$inScopeRelations[1]"/>
			<xsl:variable name="newInScopeRelationList" select="remove($inScopeRelations, 1)"/>

			<xsl:variable name="currentStep" select="$allProcessUsages[name = $thisRelation/own_slot_value[slot_reference = ':FROM']/value]"/>
			<xsl:choose>
				<xsl:when test="not($currentStep/name = $stepsFound/name)">
					<xsl:variable name="newStepsFound" select="insert-before($stepsFound, count($stepsFound) + 1, $currentStep)"/>

					<xsl:variable name="currentStepProcess" select="$business_processes[(name = $currentStep/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $currentStep/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
					<xsl:variable name="stepOwner" select="$defined_business_roles[name = $currentStepProcess/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
					<xsl:variable name="decisionMaker" select="$decisionMakers[name = $currentStep/own_slot_value[slot_reference = 'bpfd_decision_makers']/value]"/>
					<xsl:variable name="currentStepIndex" select="eas:getStepIndex($currentStep, 1, $relationList, ())"/>

					<xsl:variable name="nextStepRelations" select="$relationList[own_slot_value[slot_reference = ':FROM']/value = $currentStep/name]"/>

					<tr>
						<td>
							<xsl:value-of select="$currentStepIndex"/>
						</td>
						<td>
							<strong>
								<xsl:choose>
									<xsl:when test="count($currentStepProcess) > 0">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="count($currentStep) > 0">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</strong>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="count($currentStepProcess) > 0">
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="count($currentStep) > 0">
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>-</xsl:otherwise>
							</xsl:choose>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="count($stepOwner) > 0">
									<ul>
										<xsl:for-each select="$stepOwner">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											<li>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:when>
								<xsl:when test="count($decisionMaker) > 0">
									<ul>
										<xsl:for-each select="$decisionMaker">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											<li>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:when>
								<xsl:otherwise>-</xsl:otherwise>
							</xsl:choose>
						</td>
						<td>
							<ul>
								<xsl:for-each select="$nextStepRelations">
									<xsl:sort select="own_slot_value[slot_reference = ':relation_label']/value"/>
									<xsl:variable name="currentRelation" select="current()"/>
									<xsl:variable name="nextStep" select="$allProcessUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
									<xsl:variable name="nextStepIndex" select="eas:getStepIndex($nextStep, 1, $relationList, ())"/>
									<!--<xsl:variable name="nextStepRelation" select="$relationList[own_slot_value[slot_reference=':TO']/value = current()/name]"/>-->
									<xsl:if test="$nextStepIndex > 0">
										<xsl:choose>
											<xsl:when test="$currentStep/type = 'Business_Process_Flow_Decision'">
												<xsl:variable name="decisionResponse">
													<xsl:choose>
														<xsl:when test="count($currentRelation/own_slot_value[slot_reference = ':relation_commentary']/value) > 0">
															<xsl:call-template name="RenderMultiLangCommentarySlot">
																<xsl:with-param name="theSubjectInstance" select="$currentRelation"/>
																<xsl:with-param name="slotName" select="':relation_commentary'"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$currentRelation/own_slot_value[slot_reference = ':relation_label']/value"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<li><xsl:value-of select="$nextStepIndex"/>&#160;[<xsl:value-of select="$decisionResponse"/>]</li>
											</xsl:when>
											<xsl:otherwise>
												<li>
													<xsl:value-of select="$nextStepIndex"/>
												</li>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</ul>
						</td>
					</tr>
					<xsl:call-template name="RenderProcessStepRow">
						<xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/>
						<xsl:with-param name="stepsFound" select="$newStepsFound"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderProcessStepRow">
						<xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/>
						<xsl:with-param name="stepsFound" select="$stepsFound"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

	</xsl:template>


	<xsl:template mode="ProcessStepRow" match="node()">
		<xsl:variable name="currentStep" select="$allProcessUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="nextStep" select="$allProcessUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="currentStepIndex" select="eas:getStepIndex($currentStep, 1, $relationList, ())"/>
		<!--<xsl:variable name="nextStepRelations" select="$relationList[own_slot_value[slot_reference=':FROM']/value = $nextStep/name]"/>-->


		<xsl:variable name="currentStepProcess" select="$business_processes[(name = $currentStep/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $currentStep/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
		<xsl:variable name="stepOwner" select="$defined_business_roles[name = $currentStepProcess/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
		<xsl:variable name="decisionMaker" select="$decisionMakers[name = $currentStep/own_slot_value[slot_reference = 'bpfd_decision_makers']/value]"/>

		<xsl:variable name="relevantOwnerActor2Roles" select="$processOwnerActor2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="relevantOwners" select="/node()/simple_instance[name = $relevantOwnerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="stepDesc" select="$currentStepProcess/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<xsl:value-of select="$currentStepIndex"/>
			</td>
			<td>
				<strong>
					<xsl:choose>
						<xsl:when test="count($currentStepProcess) > 0">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="count($currentStep) > 0">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($currentStepProcess) > 0">
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="count($currentStep) > 0">
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($stepOwner) > 0">
						<ul>
							<xsl:for-each select="$stepOwner">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:when test="count($decisionMaker) > 0">
						<ul>
							<xsl:for-each select="$decisionMaker">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$nextStep">
						<xsl:variable name="nextStepRelation" select="$relationList[own_slot_value[slot_reference = ':FROM']/value = current()/name]"/>
						<xsl:choose>
							<xsl:when test="count($nextStepRelation) > 0">
								<xsl:variable name="nextStepIndex" select="index-of($relationList, $nextStepRelation[1])"/>
								<li>
									<a>
										<xsl:attribute name="href">#<xsl:value-of select="$nextStepIndex"/></xsl:attribute>
										<xsl:value-of select="$nextStepIndex"/>
									</a>
								</li>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:template>


	<!--<xsl:template mode="ProcessStepRow" match="node()">
		<xsl:variable name="currentStep" select="current()"/>
		<xsl:variable name="currentStepIndex" select="index-of($orderedProcessSteps, current())"/>
		<xsl:variable name="relevantOwnerActor2Roles" select="$processOwnerActor2Roles[name = current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="relevantOwners" select="/node()/simple_instance[name=$relevantOwnerActor2Roles/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
		<xsl:variable name="stepName" select="current()/own_slot_value[slot_reference='name']/value"/>
		<xsl:variable name="stepDesc" select="current()/own_slot_value[slot_reference='description']/value"/>
		<tr>
			<td>
				<a id="top">
					<xsl:attribute name="id">#<xsl:value-of select="$currentStepIndex"/></xsl:attribute>
					<xsl:value-of select="$currentStepIndex"/>
				</a>
			</td>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$currentStep" />
						<xsl:with-param name="theXML" select="$reposXML" />
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($stepDesc) > 0">
						<xsl:value-of select="$stepDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>		
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantOwners) > 0">
						<ul>
							<xsl:for-each select="$relevantOwners">
								<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()" />
										<xsl:with-param name="theXML" select="$reposXML" />
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				-
			</td>
		</tr>
	</xsl:template>-->


	<xsl:template name="ProcessStepRow">
		<xsl:param name="stepId"/>

		<xsl:variable name="currentStep" select="$processUsages[name = $stepId]"/>
		<xsl:variable name="currentStepIndex" select="index-of($orderedStepIds, $stepId)"/>
		<xsl:variable name="relevantOwnerActor2Roles" select="$processOwnerActor2Roles[name = $currentStep/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="relevantOwners" select="$processOwners[name = $relevantOwnerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="stepName" select="$currentStep/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="stepDesc" select="$currentStep/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<a id="top">
					<xsl:attribute name="id">#<xsl:value-of select="$currentStepIndex"/></xsl:attribute>
					<xsl:value-of select="$currentStepIndex"/>
				</a>
			</td>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($stepDesc) > 0">
						<xsl:value-of select="$stepDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantOwners) > 0">
						<ul>
							<xsl:for-each select="$relevantOwners">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td> - </td>
		</tr>
	</xsl:template>



	<xsl:function name="eas:generateDecisionRelationList" as="node()*">
		<xsl:param name="decisions"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="relationsFound"/>

		<xsl:variable name="responseRelations" select="$inScopeRelations[own_slot_value[slot_reference = ':FROM']/value = $decisions/name]"/>
		<xsl:variable name="nextDecisionRelations" select="$responseRelations[(own_slot_value[slot_reference = ':TO']/value = $decisionUsages/name)]"/>
		<xsl:variable name="nextProcessUsages" select="$allProcessUsages[name = $responseRelations/own_slot_value[slot_reference = ':TO']/value]"/>

		<xsl:choose>
			<xsl:when test="count($nextDecisionRelations) > 0">
				<xsl:variable name="nextDecisions" select="$allProcessUsages[name = $nextDecisionRelations/own_slot_value[slot_reference = ':TO']/value]"/>
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $responseRelations"/>

				<xsl:variable name="childDecisionRelations" select="eas:generateDecisionRelationList($nextDecisions, $newInScopeRelations, ())"/>

				<xsl:variable name="otherProcUsages" select="$nextProcessUsages except $nextDecisions"/>
				<xsl:variable name="otherProcRelations" select="$responseRelations[own_slot_value[slot_reference = ':TO']/value = $otherProcUsages/name]"/>

				<xsl:variable name="allSubDecisionRelations" select="$otherProcRelations, $nextDecisionRelations, $childDecisionRelations"/>

				<xsl:choose>
					<xsl:when test="count($otherProcUsages) > 0">
						<xsl:sequence select="eas:generateRelationList($otherProcUsages, $newInScopeRelations except $allSubDecisionRelations, $allSubDecisionRelations)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$relationsFound, $allSubDecisionRelations"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($responseRelations) > 0">
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $responseRelations"/>

				<xsl:sequence select="eas:generateRelationList($nextProcessUsages, $newInScopeRelations, $responseRelations)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$relationsFound"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<xsl:function name="eas:generateRelationList" as="node()*">
		<xsl:param name="busProcUsage"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="relationsFound"/>


		<xsl:variable name="nextProcRelations" select="$inScopeRelations[(own_slot_value[slot_reference = ':FROM']/value = $busProcUsage/name)]"/>
		<xsl:variable name="nextProcessUsages" select="$allProcessUsages[(name = $nextProcRelations/own_slot_value[slot_reference = ':TO']/value)]"/>

		<xsl:variable name="nextDecisionRelations" select="$nextProcRelations[(own_slot_value[slot_reference = ':TO']/value = $decisionUsages/name)]"/>

		<xsl:choose>
			<xsl:when test="count($nextDecisionRelations) > 0">

				<xsl:variable name="decisionInScopeRelations" select="$inScopeRelations except $nextDecisionRelations"/>
				<xsl:variable name="nextDecisionUsages" select="$allProcessUsages[(name = $nextDecisionRelations/own_slot_value[slot_reference = ':TO']/value)]"/>

				<xsl:variable name="decisionRelationList" select="eas:generateDecisionRelationList($nextDecisionUsages, $decisionInScopeRelations, $nextDecisionRelations)"/>

				<xsl:variable name="otherProcUsages" select="$nextProcessUsages except $nextDecisionUsages"/>
				<xsl:variable name="otherProcRelations" select="$nextProcRelations[own_slot_value[slot_reference = ':TO']/value = $otherProcUsages/name]"/>

				<xsl:choose>
					<xsl:when test="count($otherProcUsages) > 0">
						<xsl:sequence select="eas:generateRelationList($otherProcUsages, $decisionInScopeRelations except $decisionRelationList, ($otherProcRelations, $nextDecisionRelations, $decisionRelationList))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$relationsFound, $nextDecisionRelations, $decisionRelationList"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($nextProcRelations) > 0">
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $nextProcRelations"/>

				<xsl:sequence select="eas:generateRelationList($nextProcessUsages, $newInScopeRelations, ($relationsFound, $nextProcRelations))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$relationsFound, $nextProcRelations"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<xsl:function name="eas:getStepIndex" as="xs:integer">
		<xsl:param name="step"/>
		<xsl:param name="currentIndex"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="stepsFound"/>

		<xsl:choose>
			<xsl:when test="count($inScopeRelations) > 0">
				<xsl:variable name="thisRelation" select="$inScopeRelations[1]"/>
				<xsl:variable name="newInScopeRelationList" select="remove($inScopeRelations, 1)"/>

				<xsl:variable name="currentStep" select="$allProcessUsages[name = $thisRelation/own_slot_value[slot_reference = ':FROM']/value]"/>
				<xsl:choose>
					<xsl:when test="$currentStep/name = $step/name">
						<xsl:value-of select="$currentIndex"/>
					</xsl:when>
					<xsl:when test="$currentStep/name = $stepsFound/name">
						<xsl:value-of select="eas:getStepIndex($step, $currentIndex, $newInScopeRelationList, $stepsFound)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="newStepsFound" select="insert-before($stepsFound, count($stepsFound) + 1, $currentStep)"/>
						<xsl:value-of select="eas:getStepIndex($step, $currentIndex + 1, $newInScopeRelationList, $newStepsFound)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<xsl:template name="RenderIconPath">
		<xsl:param name="businessRole"/>

		<xsl:choose>
			<xsl:when test="count($businessRole) > 0">
				<xsl:variable name="iconIndex" select="index-of($defined_business_roles, $businessRole)"/>
				<xsl:variable name="iconFileName" select="$peopleIconList[$iconIndex]"/>
				<xsl:value-of select="concat('images/', $iconFileName)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('images/', $undefinedPeopleIcon)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="legend">
		<div class="processLegend floatLeft top-30">
			<div class="verticalSpacer_5px"/>
			<style>
				#legendTable{
					width: auto;
				}
				
				#legendTable td{
					padding: 0 30px 10px 0;
				}
				
				.event_legend{
					-webkit-filter: drop-shadow(2px 2px 2px #aaa);
					filter: drop-shadow(2px 2px 2px #aaa);
					top: 3px;
					position: relative;
				}</style>




			<table id="legendTable" class="text-center">
				<tbody>
					<tr>
						<td rowspan="2" class="small vAlignTop">
							<strong><xsl:value-of select="eas:i18n('Legend')"/>:</strong>
						</td>
						<td>
							<div class="busProcessLegend"/>
						</td>
						<td>
							<div class="busProcessLegend backColour10"/>
						</td>
						<td>
							<svg class="event_legend" width="80px" height="30px" viewBox="0 0 80 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
								<defs>
									<polygon id="blockArrow" points="0 0 70 0 80 15 70 30 0 30"/>
								</defs>
								<g stroke="none" stroke-width="1" fill="none">
									<g>
										<use fill="#6593c8" fill-rule="evenodd" xlink:href="#blockArrow"/>
										<path stroke="#666" stroke-width="1" d="M0,0 L70,0 L80,15 L70,30 L0,30 L0,0 Z"/>
									</g>
								</g>

							</svg>
						</td>
						<xsl:for-each select="$defined_business_roles">
							<xsl:variable name="rolePath">
								<xsl:call-template name="RenderIconPath">
									<xsl:with-param name="businessRole" select="current()"/>
								</xsl:call-template>
							</xsl:variable>
							<td>
								<img alt="person icon">
									<xsl:attribute name="src" select="$rolePath"/>
								</img>
							</td>
						</xsl:for-each>
						<td>
							<img alt="person icon">
								<xsl:attribute name="src" select="$undefinedPeopleIconPath"/>
							</img>
						</td>
					</tr>
					<tr class="small">
						<td>
							<strong>
								<xsl:value-of select="eas:i18n('Process Step')"/>
							</strong>
						</td>
						<td>
							<strong>
								<xsl:value-of select="eas:i18n('Decision')"/>
							</strong>
						</td>
						<td>
							<strong>
								<xsl:value-of select="eas:i18n('Event')"/>
							</strong>
						</td>
						<xsl:for-each select="$defined_business_roles">
							<td>
								<strong>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>
								</strong>
							</td>
						</xsl:for-each>
						<td>
							<strong>
								<xsl:value-of select="eas:i18n('Undefined Role')"/>
							</strong>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template name="processModelScript">
		<script>
            
            (function() {
            
                var StartEventShape = joint.dia.Element.define('eas.StartEventShape', {
			        size: {
			            width: 150,
			            height: 50
			        },
			        attrs: {
			            polygon: {
			            	refWidth: '100%',
			                refHeight: '100%',
			            	fill: '#6593c8',
			                stroke: '#666666',
			                strokeWidth: 2,
			                rx: 10,
			                ry: 10,
				                points: "0,0 0,60 130,60 150,30 130, 0"
			            },
			            text: {
			                'text-anchor': 'middle',
			                refX: '45%',
			                refY: '55%',
			                fill: '#ffffff',
			                yAlignment: 'middle',
			                xAlignment: 'middle',
			                'font-family': "Arial",
			                fontSize: 12
			            }
			        }
			    }, 
			    {
			        markup: '<polygon/><text/>',
                    setText: function(text) {
			        	var newText = joint.util.breakText(text, { width: 120 });
			            return this.attr('text/text', newText);
			        }
			    });
			    
			    
			    var GoalEventShape = joint.dia.Element.define('eas.GoalEventShape', {
			        size: {
			            width: 150,
			            height: 50
			        },
			        attrs: {
			            polygon: {
			            	refWidth: '100%',
			                refHeight: '100%',
			            	fill: '#6593c8',
			                stroke: '#666666',
			                strokeWidth: 2,
			                rx: 10,
			                ry: 10,
				                points: "0,30 30,60 150,60 150,0 30, 0"
			            },
			            text: {
			                'text-anchor': 'middle',
			                refX: '55%',
			                refY: '55%',
			                fill: '#ffffff',
			                yAlignment: 'middle',
			                xAlignment: 'middle',
			                'font-family': "Arial",
			                fontSize: 12
			            }
			        }
			    }, 
			    {
			        markup: '<polygon/><text/>',
                    setText: function(text) {
			        	var newText = joint.util.breakText(text, { width: 120 });
			            return this.attr('text/text', newText);
			        }
			    });
            

			    var Shape = joint.dia.Element.define('eas.Shape', {
			        size: {
			            width: 150,
			            height: 60
			        },
			        attrs: {
			            rect: {
			                refWidth: '100%',
			                refHeight: '100%',
			                fill: '#ffffff',
			                stroke: '#666666',
			                strokeWidth: 2,
			                rx: 10,
			                ry: 10
			            },
			            text: {
			                'text-anchor': 'middle',
			                refX: '50%',
			                refY: '50%',
			                fill: '#333333',
			                yAlignment: 'middle',
			                xAlignment: 'middle',
			                'font-family': "Arial",
			                fontSize: 12
			            },
			            image: {
			            	'ref-x': 3,
			            	'ref-y': 3,
			            	ref: 'rect',
			            	width: 16,
			            	height: 16 
			            }
			        }
			    }, 
			    {
			        markup: '<rect/><image/><text/>',
			        /*markup: '<rect/><text><tspan class="word1"/> <tspan dy="10" class="word2"/></text>',*/
			
			        setText: function(text) {
			        	var newText = joint.util.breakText(text, { width: 130 });
			            /*this.attr('.word1/text', text || '');*/
			            return this.attr('text/text', newText || '');
			        }
			    });
			    
			    
			    var DecisionTextShape = joint.dia.Element.define('eas.DecisionTextShape', {
			        size: {
			            width: 150,
			            height: 50
			        },
			        attrs: {
			            rect: {
			                refWidth: '100%',
			                refHeight: '100%',
			                fill: '#a9c66f',
			                stroke: '#666666',
			                strokeWidth: 2,
			                rx: 20,
			                ry: 20
			            },
			            text: {
			            	'text-anchor': 'middle',
			                refX: '50%',
			                refY: '50%',
			                fill: '#333333',
			                yAlignment: 'middle',
			                xAlignment: 'middle',
			                'font-family': "Arial",
			                fontSize: 12
			            }
			        }
			    }, 
			    {
			        markup: '<rect/><text/>',
			        /*markup: '<rect/><text><tspan class="word1"/> <tspan dy="10" class="word2"/></text>',*/
			
			        setText: function(text) {
			        	var newText = joint.util.breakText(text, { width: 150 });
			            /*this.attr('.word1/text', text || '');*/
			            return this.attr('text/text', newText || '');
			        }
			    });
			    
			    
			    var DecisionPointShape = joint.dia.Element.define('eas.DecisionShape', {
			        size: {
			            width: 30,
			            height: 30
			        },
			        attrs: {
			            rect: {
			                transform: 'rotate(45)',
			                refWidth: '100%',
			                refHeight: '100%',
			                fill: '#a9c66f',
			                stroke: '#333333',
			                strokeWidth: 2,
			                rx: 4,
			                ry: 4
			            },
			            text: {
			                refX: '50%',
			                refY: '50%',
			                yAlignment: 'middle',
			                xAlignment: 'middle',
			                fontSize: 30
			            }
			        }
			    }, {
			        markup: '<rect/><text/>',
			
			        setText: function(text) {
			            return this.attr('text/text', '');
			        }
			    });
			
			    var Link = joint.dia.Link.define('eas.ProcessLink', {
			        attrs: {
			            '.connection': {
			                stroke: '#333333',
			                strokeWidth: 2,
			                pointerEvents: 'none',
			                targetMarker: {
			                    type: 'path',
			                    fill: '#333333',
			                    stroke: 'none',
			                    d: 'M 10 -10 0 0 10 10 z'
			                }
			            }
			        },
			        connector: {
			            name: 'rounded'
			        },
			        z: -1,
			        weight: 1,
			        minLen: 1,
			        labelPosition: 'c',
			        labelOffset: 10,
			        labelSize: {
			            width: 30,
			            height: 30
			        },
			        labels: [{
			            markup: '<text/>',
			            attrs: {
			                text: {
			                    fill: '#333333',
			                    textAnchor: 'middle',
			                    refY: 5,
			                    refY2: '-50%',
			                    fontSize: 12,
			                    cursor: 'pointer'
			                }
			            },
			            size: {
			                width: 30, height: 30
			            }
			        }]
			
			    }, {
			        markup: '<path class="connection"/><g class="labels"/>',
			
			        connect: function(sourceId, targetId) {
			            return this.set({
			                source: { id: sourceId },
			                target: { id: targetId }
			            });
			        },
			
			        setLabelText: function(text) {
			            return this.prop('labels/0/attrs/text/text', text || '');
			        }
			    });
			    
			    
			     var DecisionResponseLink = joint.dia.Link.define('eas.DecisionResponseLink', {
			        attrs: {
			            '.connection': {
			                stroke: 'gray',
			                strokeWidth: 2,
			                pointerEvents: 'none',
			                targetMarker: {
			                    type: 'path',
			                    fill: '#333333',
			                    stroke: 'none',
			                    d: 'M 10 -10 0 0 10 10 z'
			                }
			            }
			        },
			        connector: {
			            name: 'rounded'
			        },
			        z: -1,
			        weight: 1,
			        minLen: 1,
			        labelPosition: 'c',
			        labelOffset: 10,
			        labelSize: {
			            width: 30,
			            height: 30
			        },
			        labels: [{
			            markup: '<rect/><text/>',
			            attrs: {
			                text: {
			                    fill: '#333333',
			                    textAnchor: 'middle',
			                    refY: 5,
			                    refY2: '-50%',
			                    fontSize: 12,
			                    cursor: 'pointer'
			                },
			                rect: {
			                    transform: 'rotate(45)',
			                    fill: 'white',
			                    stroke: 'white',
			                    strokeWidth: 1,
			                    refWidth: '100%',
			                    refHeight: '50%',
			                    refY: '-65%',
			                    rx: 5,
			                    ry: 5
			                }
			            },
			            size: {
			                width: 30, height: 30
			            }
			        }]
			
			    }, {
			        markup: '<path class="connection"/><g class="labels"/>',
			
			        connect: function(sourceId, targetId) {
			            return this.set({
			                source: { id: sourceId },
			                target: { id: targetId }
			            });
			        },
			
			        setLabelText: function(text) {
			            return this.prop('labels/0/attrs/text/text', text || '');
			        }
			    });
			    
			    
			    var DecisionLink = joint.dia.Link.define('eas.DecisionLink', {
			        attrs: {
			            '.connection': {
			                stroke: '#333333',
			                strokeWidth: 2,
			                pointerEvents: 'none',
			                targetMarker: {
			                    type: 'path',
			                    fill: '#333333',
			                    stroke: 'none',
			                    d: 'M 10 -10 0 0 10 10 z'
			                }
			            }
			        },
			        connector: {
			            name: 'rounded'
			        },
			        z: -1,
			        weight: 1,
			        minLen: 1,
			        labelPosition: 'c',
			        labelOffset: 10,
			        labelSize: {
			            width: 30,
			            height: 30
			        },
			        labels: [{
			            markup: '<text/>',
			            attrs: {
			                text: {
			                    fill: 'gray',
			                    textAnchor: 'middle',
			                    refY: 5,
			                    refY2: '-50%',
			                    fontSize: 10,
			                    cursor: 'pointer'
			                }
			            },
			            size: {
			                width: 30, height: 30
			            }
			        }]
			
			    }, {
			        markup: '<path class="connection"/><g class="labels"/>',
			
			        connect: function(sourceId, targetId) {
			            return this.set({
			                source: { id: sourceId },
			                target: { id: targetId }
			            });
			        },
			
			        setLabelText: function(text) {
			            return this.prop('labels/0/attrs/text/text', text || '');
			        }
			    });
			    
			    
			    
			
			    var LayoutControls = joint.mvc.View.extend({
			
			        events: {
			            change: 'layout',
			            input: 'layout'
			        },
			
			        options: {
			            padding: 30,
			            height: $('#paper').height(),
 						width: $('#paper').width(),
			        },
			
			        init: function() {
			
			            var options = this.options;
			            if (options.adjacencyList) {
			                options.cells = this.buildGraphFromAdjacencyList(options.adjacencyList);
			            }
			
			            this.listenTo(options.paper.model, 'change', function(cell, opt) {
			                if (opt.layout) {
			                    this.layout();
			                }
			            });
			        },
			
			        layout: function() {
			
			            var paper = this.options.paper;
			            var graph = paper.model;
			            var cells = this.options.cells;
			
			            joint.layout.DirectedGraph.layout(cells, this.getLayoutOptions());
			
			            if (graph.getCells().length === 0) {
			                // The graph could be empty at the beginning to avoid cells rendering
			                // and their subsequent update when elements are translated
			                graph.resetCells(cells);
			            }
			
			            paper.fitToContent({
			                padding: this.options.padding,
			                allowNewOrigin: 'any'
			            });
			
			            this.trigger('layout');
			        },
			
			        getLayoutOptions: function() {
			            return {
			                setVertices: true,
			                setLabels: true,
			                ranker: this.$('#ranker').val(),
			                rankDir: this.$('#rankdir').val(),
			                align: this.$('#align').val(),
			                rankSep: parseInt(this.$('#ranksep').val(), 10),
			                edgeSep: parseInt(this.$('#edgesep').val(), 10),
			                nodeSep: parseInt(this.$('#nodesep').val(), 10)
			            };
			        },
			
			        buildGraphFromAdjacencyList: function(adjacencyList) {
			
			            var elements = [];
			            var links = [];
			            
			            <!--elements.push(
			                    new StartEventShape({id: 'StartEventNode'}).setText('Hello')
			            );-->
            
                        <xsl:apply-templates mode="RenderStartEvent" select="$startEvents"/>
            
                        <xsl:apply-templates mode="RenderGoalEvent" select="$goalEvents"/>
			            
			            <xsl:apply-templates mode="RenderBusProc" select="$business_processes"/>
            
                        <xsl:apply-templates mode="RenderDecision" select="$decisionUsages"/>
            
                        <xsl:apply-templates mode="RenderDecisionLink" select="$decisionUsages"/>
            
                        <xsl:apply-templates mode="RenderProcessLink" select="$processFlowRelations"/>
            
                        <xsl:apply-templates mode="RenderStartEventLink" select="$startEventRelations"/>
            
                        <xsl:apply-templates mode="RenderGoalEventLink" select="$goalEventRelations"/>
            
			            
			            <!--elements.push(
			                    new DecisionPointShape({ id: 'TestDecision' }).setText('')
			            );
			            
			            elements.push(
			                    new DecisionTextShape({ id: 'TestDecisionText' }).setText('This is a decision')
			            );
			            
			            links.push(
			                        new Link()
			                            .connect('TestDecisionText', 'TestDecision')
			            );-->
			
			            <!--Object.keys(adjacencyList).forEach(function(parentLabel) {
			                // Add element
			                elements.push(
			                    new Shape({ id: parentLabel }).setText(parentLabel)
			                );
			                // Add links
			                /*adjacencyList[parentLabel].forEach(function(childLabel) {
			                    links.push(
			                        new Link()
			                            .connect(parentLabel, childLabel)
			                            .setLabelText(parentLabel + '-' + childLabel)
			                    );
			                });*/
			            });
			            
			            links.push(
			                        new Link()
			                            .connect('TestDecision', 'a')
			                            .setLabelText('Yes')
			            );
			            
			            links.push(
			                        new Link()
			                            .connect('TestDecision', 'b')
			                            .setLabelText('No')
			            );
			            
			            links.push(
			                        new Link()
			                            .connect('g', 'TestDecisionText')
			            );-->
			
			            // Links must be added after all the elements. This is because when the links
			            // are added to the graph, link source/target
			            // elements must be in the graph already.
			            return elements.concat(links);
			        }
			
			    });
			
			    var LinkControls = joint.mvc.View.extend({
			
			        highlighter: {
			            name: 'stroke',
			            options: {
			                attrs: {
			                    'stroke': 'lightcoral',
			                    'stroke-width': 4
			                }
			            }
			        },
			
			        events: {
			            change: 'updateLink',
			            input: 'updateLink'
			        },
			
			        init: function() {
			            this.highlight();
			            this.updateControls();
			        },
			
			        updateLink: function() {
			            this.options.cellView.model.set(this.getModelAttributes(), { layout: true });
			        },
			
			        updateControls: function() {
			
			            var link = this.options.cellView.model;
			
			            this.$('#labelpos').val(link.get('labelPosition'));
			            this.$('#labeloffset').val(link.get('labelOffset'));
			            this.$('#minlen').val(link.get('minLen'));
			            this.$('#weight').val(link.get('weight'));
			        },
			
			        getModelAttributes: function() {
			            return {
			                minLen: parseInt(this.$('#minlen').val(), 10),
			                weight: parseInt(this.$('#weight').val(), 10),
			                labelPosition: this.$('#labelpos').val(),
			                labelOffset: parseInt(this.$('#labeloffset').val(), 10)
			            };
			        },
			
			        onRemove: function() {
			            this.unhighlight();
			        },
			
			        highlight: function() {
			            this.options.cellView.highlight('rect', { highlighter: this.highlighter });
			        },
			
			        unhighlight: function() {
			            this.options.cellView.unhighlight('rect', { highlighter: this.highlighter });
			        }
			
			    }, {
			
			        create: function(linkView) {
			            this.remove();
			            this.instance = new this({
			                el: this.template.cloneNode(true).getElementById('link-controls'),
			                cellView: linkView
			            });
			            this.instance.$el.insertAfter('#layout-controls');
			        },
			
			        remove: function() {
			            if (this.instance) {
			                this.instance.remove();
			                this.instance = null;
			            }
			        },
			
			        refresh: function() {
			            if (this.instance) {
			                this.instance.unhighlight();
			                this.instance.highlight();
			            }
			        },
			
			        instance: null,
			
			        template: document.getElementById('link-controls-template').content
			
			    });
			
			    var controls = new LayoutControls({
			        el: document.getElementById('layout-controls'),
			        paper: new joint.dia.Paper({
			            el: document.getElementById('paper'),
			            interactive: function(cellView) {
			                return cellView.model.isElement();
			            }
			        }).on({
			            'link:pointerdown': LinkControls.create,
			            'blank:pointerdown element:pointerdown': LinkControls.remove
			        }, LinkControls),
			        adjacencyList: {
			            a: ['b','c','d'],
			            b: ['d', 'e'],
			            c: [],
			            d: [],
			            e: ['e'],
			            f: [],
			            g: ['b','i'],
			            h: ['f'],
			            i: ['f','h']
			        }
			    }).on({
			        'layout': LinkControls.refresh
			    }, LinkControls);
			
			    controls.layout();
			
			})(joint);
        </script>
	</xsl:template>

</xsl:stylesheet>
