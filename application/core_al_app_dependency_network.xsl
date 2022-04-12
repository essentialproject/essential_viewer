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

	<xsl:variable name="startUsage" select="$allProcessUsages[(type = 'Start_Process_Flow')]"/>
	<xsl:variable name="startRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':FROM']/value = $startUsage/name]"/>

	<!-- get the list of Business Processes in scope -->
	<xsl:variable name="business_processes" select="/node()/simple_instance[(name = $processUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $processUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<!-- get the list of Business Roles in scope -->
	<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name = $business_processes/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
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


	<xsl:variable name="pageType">
		<xsl:value-of select="eas:i18n('Enterprise Application Dependency Network')"/>
	</xsl:variable>
	<xsl:variable name="pageTitle" select="$pageType"/>

	<xsl:variable name="peopleIconList" select="('person-icon-darkblue.png', 'person-icon-green.png', 'person-icon-lightblue.png', 'person-icon-pink.png', 'person-icon-purple.png', 'person-icon-red.png', 'person-icon-yellow.png', 'person-icon-brown.png')"/>
	<xsl:variable name="undefinedPeopleIcon" select="'person-icon-empty.png'"/>
	<xsl:variable name="undefinedPeopleIconPath" select="'images/person-icon-empty.png'"/>
	<xsl:variable name="peopleColourList" select="('#313CA3', '#417505', '#4A90E2', '#E09CA4', '#824DB1', '#D0021B', '#F5A623', '#8B572A')"/>


	<!-- Node colour variables -->
	<xsl:variable name="networkColourBlue">#28BBE3</xsl:variable>
	<xsl:variable name="networkColourPink">#df0b68</xsl:variable>
	<xsl:variable name="networkColourOrange">#f89520</xsl:variable>
	<xsl:variable name="networkColourGreen">#44A643</xsl:variable>
	<xsl:variable name="networkColourPurple">#A64189</xsl:variable>
	<xsl:variable name="networkColourBlack">#444</xsl:variable>
	
	<xsl:variable name="edgeColourBlack">#333</xsl:variable>
	<xsl:variable name="edgeColourBlue">#69DFFF</xsl:variable>
	<!-- end node colour variables -->
	
	
	<!-- SET THE VARIABLES THAT ARE REQUIRED REPEATEDLY THROUGHOUT -->
	<xsl:variable name="allAppProviderUsages" select="/node()/simple_instance[(type = 'Static_Application_Provider_Usage')]"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[name = $allAppProviderUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	<xsl:variable name="allAppStaticArchs" select="/node()/simple_instance[name = $allAppProviderUsages/own_slot_value[slot_reference = 'used_in_static_app_provider_architecture']/value]"/>
	<xsl:variable name="allApp2AppRelations" select="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']"/>
	
	<xsl:variable name="appCatTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Provider Categories')]"/>
	<xsl:variable name="appCatTerms" select="/node()/simple_instance[name = $appCatTaxonomy/own_slot_value[slot_reference = 'taxonomy_terms']/value]"/>
	<xsl:variable name="moduleAppCat" select="$appCatTerms[own_slot_value[slot_reference = 'name']/value = 'Application Module']"/>
	<xsl:variable name="userAppCat" select="$appCatTerms[own_slot_value[slot_reference = 'name']/value = 'Business User Application']"/>
	<xsl:variable name="interfaceAppCat" select="$appCatTerms[own_slot_value[slot_reference = 'name']/value = 'Integration Module']"/>
	
	<xsl:variable name="appDiffLevelTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Differentiation Level')]"/>
	<xsl:variable name="appDiffLevelTerms" select="/node()/simple_instance[name = $appDiffLevelTaxonomy/own_slot_value[slot_reference = 'taxonomy_terms']/value]"/>
	<xsl:variable name="sysOfRecordDiffLevel" select="$appDiffLevelTerms[own_slot_value[slot_reference = 'name']/value = 'System of Record']"/>
	<xsl:variable name="sysOfDifferentiationLevel" select="$appDiffLevelTerms[own_slot_value[slot_reference = 'name']/value = 'System of Differentiation']"/>
	<xsl:variable name="sysofInnovationLevel" select="$appDiffLevelTerms[own_slot_value[slot_reference = 'name']/value = 'System of Innovation']"/>
	
	
	<!--<xsl:variable name="packagedCodebase" select="$appCodeBases[own_slot_value[slot_reference = 'name']/value = 'Packaged']"/>
	<xsl:variable name="packagedCodebaseColour" select="eas:get_element_style_colour($packagedCodebase)"/>
	<xsl:variable name="customPackageCodebase" select="$appCodeBases[own_slot_value[slot_reference = 'name']/value = 'Customised_Package']"/>
	<xsl:variable name="customPackageCodebaseColour" select="eas:get_element_style_colour($customPackageCodebase)"/>
	<xsl:variable name="bespokeCodebase" select="$appCodeBases[own_slot_value[slot_reference = 'name']/value = 'Bespoke']"/>
	<xsl:variable name="bespokeCodebaseColour" select="eas:get_element_style_colour($bespokeCodebase)"/>-->
	
	<xsl:variable name="allCompApps" select="/node()/simple_instance[type = 'Composite_Application_Provider']"/>
	<xsl:variable name="compApps" select="$allCompApps[own_slot_value[slot_reference = 'contained_application_providers']/value = $allAppProviders/name]"/>
	<xsl:variable name="allRenderedAppProviders" select="$allAppProviders union $compApps"/>
	
	<xsl:variable name="appCodeBases" select="/node()/simple_instance[name = $allRenderedAppProviders/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
	<xsl:variable name="appCodebaseStyles" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $appCodeBases/name]"/>
	
	<xsl:variable name="appDeliveryModels" select="/node()/simple_instance[name = $allRenderedAppProviders/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
	<xsl:variable name="appDeliveruModelStyles" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $appDeliveryModels/name]"/>


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
				<script src="js/jquery-migrate-1.4.1.min.js" type="text/javascript"/>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<!--Dependencies for JointJS UML Diagram-->
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>
				<script src="js/lodash/index.js"/>
				<script src="js/backbone/backbone.js"/>
				<script src="js/graphlib/graphlib.core.js"/>
				<script src="js/dagre/dagre.core.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/svg-pan-zoom/svg-pan-zoom.min.js"/>
				<!--Dependencies for JointJS UML Diagram Ends-->
				<style>
					#paper{
						position: relative;
						margin-left: auto;
						margin-right: auto;
						min-width: 460px;
						min-height: 800px;
						width: 90vw;
						border-style: solid;
						border-width: 1px;
						border-radius: 15px;
						border-color: lightgray;
					}
				</style>
				<script>
					var legendTemplate;
					
					// the list of JSON objects representing the codebases associated with the apps
				  	var allCodebases = {
						enumerationValues: [<xsl:apply-templates select="$appCodeBases" mode="getEnumerationJSON"><xsl:with-param name="styles" select="$appCodebaseStyles"/><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:apply-templates>]
				  	};
				  	
				  	var allDeliveryModels = {
						enumerationValues: [<xsl:apply-templates select="$appDeliveryModels" mode="getEnumerationJSON"><xsl:with-param name="styles" select="$appDeliveruModelStyles"/><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:apply-templates>]
				  	};
				  	
				  	function renderLegend(overlayValue) {
				  		if(overlayValue == 'codebase') {
				  			$("#legendTable").html(legendTemplate(allCodebases));
				  		} else if(overlayValue == 'deliveryModel') {
				  			$("#legendTable").html(legendTemplate(allDeliveryModels));
				  		} else {
				  			$('#legendTable').html('<xsl:call-template name="renderBasicLegend"/>');
				  		}
				  	}
					
					$(document).ready(function() {										
						var legendFragment   = $("#legend-template").html();
						legendTemplate = Handlebars.compile(legendFragment);
					});
				</script>
			</head>
			<!--<template id="link-controls-template">
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
			</template>-->
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey">
									<xsl:value-of select="$pageTitle"/>
									<!--<xsl:value-of select="$DEBUG"/>-->
								</span>
							</h1>
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
								<xsl:when test="count($allAppProviders) = 0">
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
														<!--<option value="BT">Bottom To Top</option>-->
														<!--<option value="RL">Right to Left</option>-->
														<option value="LR" selected="selected">Top to Bottom</option>
														<option value="TB">Left to Righ</option>
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
													<label for="ranksep">Application Spacing</label>
													<input id="ranksep" type="range" min="1" max="100" value="50" class="form-control"/>
												</div>
												<div class="width200px pull-left right-30">
													<label for="edgesep">Dependency Spacing:</label>
													<input id="edgesep" type="range" min="1" max="100" value="50" class="form-control"/>
												</div>
												<div class="width200px pull-left right-30">
													<label for="nodesep">Row/Column Spacing:</label>
													<input id="nodesep" type="range" min="1" max="100" value="50" class="form-control"/>
												</div>
												<div class="verticalSpacer_20px"/>
												<div class="width120px pull-left"><strong>Select Overlay:</strong></div>
												<div class="width100px pull-left">
													<input id="noOverlay" type="radio" name="overlay" value="" checked="checked"/>
													<label for="noOverlay">None</label>
												</div>
												<div class="width100px pull-left">
													<input id="cbOverlay" type="radio" name="overlay" value="codebase"/>
													<label for="cbOverlay">Codebase</label>
												</div>
												<div class="width150px pull-left">
													<input id="dmOverlay" type="radio" name="overlay" value="deliveryModel"/>
													<label for="dmOverlay">Delivery Model</label>
												</div>
											</div>
											<div class="clearfix"></div>
											<!--<xsl:call-template name="overlaySelector"/>-->
                                            
                                            <!--<div class="width100px pull-left">
                                                <select id="apps2choose" onchange="highlight(this.value)">
                                                    <option value=""></option>
                                                    <xsl:apply-templates mode="setOptions" select="$allAppProviders">
                                                    </xsl:apply-templates>
                                                </select>
                                            </div>  -->  
											<div class="width100px pull-right">
												<button id="resetButton" onclick="resetZoom()">Reset Model</button>
											</div>
											<xsl:call-template name="legend"/>
											<!--<div class="clearfix"></div>-->
											
											<!--<div class="width100px pull-left">
												<button id="save-to-pdf">Save as PDF</button>
											</div>-->
											<div class="verticalSpacer_5px"/>
											<div id="paper"/>
										</div>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<xsl:call-template name="processModelScript"/>
                <script>
                function highlight(app){
                    //console.log(app);
                    	$('[model-id="' + app + '"] > rect').attr('fill','red');
                    }
                
                </script>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="renderBasicLegend">
		<tbody><tr><td rowspan="2" class="small vAlignTop"><strong><xsl:value-of select="eas:i18n('Legend')"/>:</strong></td><td><div class="busProcessLegend"/></td></tr><tr class="small"><td><strong><xsl:value-of select="eas:i18n('Application')"/></strong></td></tr></tbody>
	</xsl:template>

	<xsl:template mode="RenderStartEvent" match="node()">
		<xsl:variable name="eventId" select="concat('startEvent', position())"/>
		<xsl:variable name="eventLabel">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable> elements.push( new StartEventShape({ id: '<xsl:value-of select="$eventId"/>'}).setText('<xsl:value-of select="$eventLabel"/>') );<xsl:text>
			
		</xsl:text>
	</xsl:template>

	<xsl:template mode="RenderGoalEvent" match="node()">
		<xsl:variable name="eventId" select="concat('goalEvent', position())"/>
		<xsl:variable name="eventLabel">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable> elements.push( new GoalEventShape({ id: '<xsl:value-of select="$eventId"/>'}).setText('<xsl:value-of select="$eventLabel"/>') );<xsl:text>
			
		</xsl:text>
	</xsl:template>
	
	
	<xsl:template mode="RenderCompositeApp" match="node()">
		<xsl:variable name="appId" select="concat('compApp', position())"/>
		<xsl:variable name="appIconPath">
			<!--<xsl:call-template name="RenderIconPath">
				<xsl:with-param name="businessRole" select="$defined_business_roles[name = current()/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
			</xsl:call-template>-->
		</xsl:variable>
		<xsl:variable name="appName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisAppDeliveruModel" select="$appDeliveryModels[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
		<xsl:variable name="thisAppDeliveruModelStyle" select="$appDeliveruModelStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $thisAppDeliveruModel/name]"/>
		<xsl:variable name="thisDeliveryModelColour">
			<xsl:choose>
				<xsl:when test="count($thisAppDeliveruModelStyle) > 0">
					['<xsl:value-of select="$thisAppDeliveruModelStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>', '<xsl:value-of select="$thisAppDeliveruModelStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>']
				</xsl:when>
				<xsl:otherwise>['lightgray', '#333333']</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisCodebase" select="$appCodeBases[name = current()/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
		<xsl:variable name="thisCodebaseStyle" select="$appCodebaseStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $thisCodebase/name]"/>
		<xsl:variable name="thisCodebaseColour">
			<xsl:choose>
				<xsl:when test="count($thisCodebaseStyle) > 0">
					['<xsl:value-of select="$thisCodebaseStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>', '<xsl:value-of select="$thisCodebaseStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>']
				</xsl:when>
				<xsl:otherwise>['lightgray', '#333333']</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- SET THE CODEBASE STATIS ATTRIBUTE OF THE SHAPE YTO THE APPROPRIATE COLOUR -->
		
		var newAppRect = new Shape({ id: '<xsl:value-of select="$appId"/>', codebase: <xsl:value-of select="$thisCodebaseColour"/>, deliveryModel: <xsl:value-of select="$thisDeliveryModelColour"/>, attrs: {class: 'class<xsl:value-of select="position() mod 2"/> <xsl:value-of select="$appId"/>', image: { 'xlink:href': '<xsl:value-of select="$appIconPath"/>' } } }).setText('<xsl:value-of select="$appName"/>');
		elements.push(newAppRect);<xsl:text>
		</xsl:text>
	</xsl:template>


	<xsl:template mode="RenderBusProc" match="node()">
		<xsl:variable name="busProcId" select="concat('busProc', position())"/>
		<xsl:variable name="busRoleIconPath">
			<xsl:call-template name="RenderIconPath">
				<xsl:with-param name="businessRole" select="$defined_business_roles[name = current()/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="busProcName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
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
	
	
	<xsl:template mode="RenderAppLink" match="node()">
		<xsl:variable name="parentUsage" select="$allAppProviderUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="childUsage" select="$allAppProviderUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		
		<xsl:if test="(count($parentUsage) > 0) and (count($childUsage) > 0)">
			<xsl:variable name="parentUsageId">
				<xsl:call-template name="GetAppNodeId">
					<xsl:with-param name="aNode" select="$parentUsage"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:variable name="childUsageId">
				<xsl:call-template name="GetAppNodeId">
					<xsl:with-param name="aNode" select="$childUsage"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:if test="(string-length($parentUsageId) > 0) and (string-length($childUsageId) > 0) and ($parentUsageId != $childUsageId)">
				<xsl:choose>
					<xsl:when test="$parentUsage/type = 'Business_Process_Flow_Decision'"> links.push( new DecisionResponseLink() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') .setLabelText('<xsl:value-of select="current()/own_slot_value[slot_reference = ':relation_label']/value"/>') );<xsl:text>
						
					</xsl:text>
					</xsl:when>
					<xsl:otherwise> links.push( new Link() .connect('<xsl:value-of select="$parentUsageId"/>', '<xsl:value-of select="$childUsageId"/>') );<xsl:text>
						
					</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	


	<xsl:template name="GetAppNodeId">
		<xsl:param name="aNode"/>
		
		<xsl:variable name="nodeCompApp" select="$allAppProviders[name = $aNode/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		<xsl:choose>
			<xsl:when test="count($nodeCompApp) > 0">
				<xsl:variable name="nodeIndex" select="index-of($allAppProviders, $nodeCompApp)"/>
				<xsl:value-of select="concat('compApp', $nodeIndex)"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
		</xsl:choose>
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
	
	
	
	<xsl:template name="overlaySelector">
		<div class="processLegend floatLeft top-30">
			<div class="verticalSpacer_5px"/>
			<div class="width100px pull-left">
				<input id="noOverlay" type="radio" name="overlay" value="none" checked="checked"/>
				<label for="noOverlay">None</label>
			</div>
			<div class="width100px pull-left">
				<input id="cbOverlay" type="radio" name="overlay" value="codebase"/>
				<label for="cbOverlay">Codebase</label>
			</div>
			<div class="width150px pull-left">
				<input id="dmOverlay" type="radio" name="overlay" value="deliveryModel"/>
				<label for="dmOverlay">Delivery Model</label>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template mode="getEnumerationJSON" match="node()">
		<xsl:param name="styles" select="()"/>
		<xsl:variable name="thisName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>
		<xsl:variable name="thisStyle" select="$styles[own_slot_value[slot_reference = 'style_for_elements']/value = current()/name]"/>
		<xsl:variable name="thisColour">
			<xsl:choose>
				<xsl:when test="count($thisStyle) > 0">
					<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>
				</xsl:when>
				<xsl:otherwise>lightgray</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		{name: '<xsl:value-of select="$thisName"/>', colour: '<xsl:value-of select="$thisColour"/>'}<xsl:if test="not(position() = last())">, </xsl:if>
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



			<script id="legend-template" type="text/x-handlebars-template">
				<tbody>
					<tr>
						<td rowspan="2" class="small vAlignTop">
							<strong><xsl:value-of select="eas:i18n('Legend')"/>:</strong>
						</td>
						{{#enumerationValues}}
						<td>
							<svg class="event_legend" width="80px" height="30px" viewBox="0 0 80 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
								<g stroke="none" stroke-width="1" fill="none">
									<rect width="80px" height="30px" rx="10" ry="10" stroke="#333333" stroke-width="1"><xsl:attribute name="fill" select="'{{colour}}'"/></rect>
								</g>
								
							</svg>
						</td>
						{{/enumerationValues}}
						
					</tr>
					<tr class="small">
						{{#enumerationValues}}
						<td>
							<strong>
								{{name}}
							</strong>
						</td>
						{{/enumerationValues}}
						
					</tr>
				</tbody>
			</script>
			<table id="legendTable" class="text-center">
				
				<!--<tbody>
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
						<td>
							<svg class="event_legend" width="80px" height="30px" viewBox="0 0 80 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
								<g stroke="none" stroke-width="1" fill="none">
									<rect width="80px" height="30px" rx="10" ry="10" fill="lightgray" stroke="#333333" stroke-width="1"/>
								</g>
								
							</svg>
						</td>
						<!-\-<xsl:for-each select="$defined_business_roles">
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
						</td>-\->
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
						<td>
							<strong>
								<xsl:value-of select="eas:i18n('Undefined')"/>
							</strong>
						</td>
						<!-\-<xsl:for-each select="$defined_business_roles">
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
						</td>-\->
					</tr>
				</tbody>-->
			</table>
		</div>
	</xsl:template>

	<xsl:template name="processModelScript">
		
		<script>
			var paper;
			var modelSVG;
			var pannedGraph;
			
			function resetZoom() {
				pannedGraph.reset();
			}
			
			
			
			'use strict';
			

			// Based on the methodology from here: http://ihaochi.com/2015/03/14/exporting-svg-to-pdf-in-javascript.html
			// Libraries used:
			// 		saveSvgAsPng - https://github.com/exupero/saveSvgAsPng
			// 		jsPDF - https://github.com/MrRio/jsPDF
			$(function() {
					var $svg = modelSVG,
			    		$save = $('#save-to-pdf');
			        
			  	$save.on('click', function() {
			    		// Convert it to PDF first
			    		pdflib.convertToPdf($svg[0], function(doc) {
			        		// Get the file name and download the pdf
			        		var filename = 'app-dependency-network.pdf';
			            pdflib.downloadPdf(filename, doc);
			        });
			    });
			});
			
			(function(global, $) {
					function convertToPdf(svg, callback) {
			        // Call svgAsDataUri from saveSvgAsPng.js
			        window.svgAsDataUri(svg, {}, function(svgUri) {
			            // Create an anonymous image in memory to set 
			            // the png content to
			            var $image = $('<img/>'),
			            		image = $image[0];
			
			            // Set the image's src to the svg png's URI
			            image.src = svgUri;
			            $image
			                .on('load', function() {
			                    // Once the image is loaded, create a canvas and
			                    // invoke the jsPDF library
			                    var canvas = document.createElement('canvas'),
			                        ctx = canvas.getContext('2d'),
			                        doc = new jsPDF('portrait', 'pt'),
			                        imgWidth = image.width,
			                        imgHeight = image.height;
			
			                    // Set the canvas size to the size of the image
			                    canvas.width = imgWidth;
			                    canvas.height = imgHeight;
			
			                    // Draw the image to the canvas element
			                    ctx.drawImage(image, 0, 0, imgWidth, imgHeight);
			
			                    // Add the image to the pdf
			                    var dataUrl = canvas.toDataURL('image/jpeg');
			                    doc.addImage(dataUrl, 'JPEG', 0, 0, imgWidth, imgHeight);
			
			                    callback(doc);
			                });
			        });
			    }
			
			    function downloadPdf(fileName, pdfDoc) {
			    		// Dynamically create a link
			        var $link = $('<a/>'),
			        		link = $link[0],
			        		dataUriString = pdfDoc.output('dataurlstring');
			      	
			        // On click of the link, set the HREF and download of it
			        // so that it behaves as a link to a file
			        $link.on('click', function() {
			          link.href = dataUriString;
			          link.download = fileName;
			          $link.detach(); // Remove it from the DOM once the download starts
			        });
			
					// Add it to the body and immediately click it
			        $('body').append($link);
			        $link[0].click();
			    }
			    
			    // Export this mini-library to the global scope
			    global.pdflib = global.pdflib || {};
			    global.pdflib.convertToPdf = convertToPdf;
			    global.pdflib.downloadPdf = downloadPdf;
			})(window, window.jQuery);
			
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
			            width: 90,
			            height: 40
			        },
			        codebase: [],
			        deliveryModel: [],
			        attrs: {
			            rect: {
			                refWidth: '100%',
			                refHeight: '100%',
			                fill: '#ffffff',
			                stroke: '#666666',
			                strokeWidth: 1,
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
			                fontSize: 9
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
			        	var newText = joint.util.breakText(text, { width: 80 });
			            /*this.attr('.word1/text', text || '');*/
			            return this.attr('text/text', newText || '');
			        },
			        setFill: function(propertyName) {
			        	if(propertyName.length > 0) {
			        		this.attr('rect/fill', this.get(propertyName)[0] );
			        		this.attr('text/fill', this.get(propertyName)[1] );
			        	} else {
			        		this.attr('rect/fill', 'white' );
			        		this.attr('text/fill', '#333333');
			        	}
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
			                    d: 'M 5 -5 0 0 5 5 z'
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
			        },
			        setFill: function(propertyName) {
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
			
			            paper = this.options.paper;
			            modelSVG = paper.svg;
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
			            
			            var overlayValue = $("input[name='overlay']:checked").val();
			            var thisCell;
			            for (i = 0; cells.length > i; i += 1) {
				  			thisCell = cells[i];
				  			thisCell.setFill(overlayValue);
				  			//console.log("Node: " + thisCell.id);
				  		}
				  		
			            pannedGraph = svgPanZoom(modelSVG, {controlIconsEnabled: false, minZoom: 0.1});
			            
			            renderLegend(overlayValue);
			            
			           <!-- panAndZoom = svgPanZoom(targetElement.childNodes[0], 
						{
						    viewportSelector: targetElement.childNodes[0].childNodes[0],
						    fit: false,
						    zoomScaleSensitivity: 0.4,
						    panEnabled: false
						});-->
			            
			           <!-- var paperDiv = document.getElementById('paper')
			            var panAndZoom = svgPanZoom(paperDiv.childNodes[0], 
				        {
				            viewportSelector: paperDiv.childNodes[0].childNodes[0],
				            fit: false,
				            zoomScaleSensitivity: 0.4,
				            panEnabled: false
				        });-->
			
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
            
                        <xsl:apply-templates mode="RenderCompositeApp" select="$allAppProviders"/>
			
						<xsl:apply-templates mode="RenderAppLink" select="$allApp2AppRelations"/>
            
                        <!--<xsl:apply-templates mode="RenderGoalEvent" select="$goalEvents"/>
			            
			            <xsl:apply-templates mode="RenderBusProc" select="$business_processes"/>
            
                        <xsl:apply-templates mode="RenderDecision" select="$decisionUsages"/>
            
                        <xsl:apply-templates mode="RenderDecisionLink" select="$decisionUsages"/>
            
                        <xsl:apply-templates mode="RenderProcessLink" select="$processFlowRelations"/>
            
                        <xsl:apply-templates mode="RenderStartEventLink" select="$startEventRelations"/>
            
                        <xsl:apply-templates mode="RenderGoalEventLink" select="$goalEventRelations"/>-->
            
			            
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
			
			        // template: document.getElementById('link-controls-template').content
			
			    });
			
			    var controls = new LayoutControls({
			        el: document.getElementById('layout-controls'),
			        paper: new joint.dia.Paper({
			            el: document.getElementById('paper'),
			            interactive: function(cellView) {
			                return cellView.model.isElement();
			            }
			        }).on({
			            <!--'link:pointerdown': LinkControls.create,
			            'blank:pointerdown element:pointerdown': LinkControls.remove-->
			        }, LinkControls),
			        adjacencyList: {}
			    }).on({
			        'layout': LinkControls.refresh
			    }, LinkControls);
			
			    controls.layout();
			    		    	
			
			})(joint);
        </script>
	</xsl:template>
    
    <xsl:template match="node()" mode='setOptions'>
        <xsl:variable name="this" select="current()"/>
    <option value="{concat('compApp', position())}"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></option>
    </xsl:template>

</xsl:stylesheet>
