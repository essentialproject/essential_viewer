<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:pro="http://protege.stanford.edu/xml"
	xmlns:eas="http://www.enterprise-architecture.org/essential"
	xmlns:functx="http://www.functx.com"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
	xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
	xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">
	
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="core_model_graph_js_functions_v2.xsl"/>
	
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../common/ods_spreadsheet_files/excelTemplate.xsl"/>
	
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Composite_Application_Provider', 'Application_Service', 'Business_Capability', 'Business_Process', 'Business_Objective', 'Group_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	
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
	
	<xsl:variable name="noHeatmapStyle" select="'noHeatmapColour'"/>
	
	<xsl:variable name="analysisDatasetAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: Strategy Planner Analysis Data']"></xsl:variable>
	<xsl:variable name="analysisDatasetAPIUrl">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$analysisDatasetAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="DEBUG" select="''"/>
	<!--
		* Copyright © 2008-2018 Enterprise Architecture Solutions Limited.
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
	<!-- 17.09.2018 JP  Created	 -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:call-template name="dataTablesLibrary"/>
				<link rel="stylesheet" type="text/css" href="js/DataTables/checkboxes/dataTables.checkboxes.css"/>
				<script src="js/DataTables/checkboxes/dataTables.checkboxes.min.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Strategy Planner')"/></title>

				<!-- modal javascript library -->
				<script src="js/lightbox-master/ekko-lightbox.min.js"/>
				<link href="js/lightbox-master/ekko-lightbox.min.css" rel="stylesheet" type="text/css"/>
				
				<!-- Start Service Quality Gauge library -->
				<script type="text/javascript" src="js/gauge.min.js"></script>
				
				<!-- Start JointJS Diagramming Libraries and Styles-->
				<!--<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>
				<script src="js/jointjs/lodash.min.js"/>
				<script src="js/jointjs/backbone-min.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/jointjs/ga.js" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.min.js"/>	-->
				
				<!-- gannt chart library -->
				<script src="js/dhtmlxgantt/dhtmlxgantt.js"></script>
				<link href="js/dhtmlxgantt/dhtmlxgantt.css" rel="stylesheet"/>
				<link rel="stylesheet" href="css/dthmlxgantt_eas_skin.css"/>
					
				<script type="text/javascript">
					$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
					    event.preventDefault();
					    $(this).ekkoLightbox({always_show_close: false});
					}); 
				</script>
				
				
				<!-- Start Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				
				<!-- Start Templating Libraries -->
				<script type="javascript" src="js/handlebars.min-v4.7.7.js"/>
				
				<style type="text/css">
					
					.section-title{
						padding: 5px;
						color: white;
					}
					
					.goal_Outer{
						width: 140px;
						float: left;
						margin: 0 15px 15px 0;
						box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
						opacity: 1;
    					-webkit-transition: opacity 1000ms linear;
    					transition: opacity 1000ms linear;
					}
					
					.goal_Box{
						width: 100%;
						height: 60px;
						padding: 5px;
						text-align: center;
						border-radius: 0px;
						<!--border: 1px solid #666;-->
						position: relative;
						display: table;
						font-size: 12px;
					}
					
					
					.product_Outer{
						width: 140px;
						float: left;
						margin: 0 15px 15px 0;
						box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
						opacity: 1;
						-webkit-transition: opacity 1000ms linear;
						transition: opacity 1000ms linear;
					}
					
					.product_Box{
						width: 100%;
						height: 60px;
						padding: 5px;
						text-align: center;
						border-radius: 5px;
						<!--border: 1px solid #666;-->
						position: relative;
						display: table;
						font-size: 12px;
					}
					
					.blob_Label{
						display: table-cell;
						vertical-align: middle;
						line-height: 1.1em;
					}
					
					.infoButton{
						position: absolute;
						bottom: 3px;
						right: 3px;
					}
					
					.lowHeatmapColour{
						background-color: hsla(352, 99%, 41%, 1);
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
						
					.neutralHeatmapColour{
						background-color: hsla(37, 92%, 55%, 1);
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.mediumHeatmapColour{
						background-color: hsla(89, 73%, 48%, 1);
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.highHeatmapColour{
						background-color: hsla(119, 42%, 46%, 1);
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.noHeatmapColour{
						background-color: #999;
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.plan-title{
						font-size: 1.2em;
					}
					
					.workflowStep{
						width: 18%;
						font-size: 1.2em;
						height: 50px;
						font-weight: 700;
						margin-right: 10px;
						position: relative;
						float: left;
						line-height: 1em;
						cursor: pointer;
					}
					
					@media (max-width : 992px){
						.workflowStep{font-size: 1em;}
					}
					
					@media (max-width : 767px){
						.workflowStep{font-size: 0.9em;}
					}
					
					.workflowID,
					.workflowArrow{
						height: 100%;
						float: left;
						padding: 2px 5px;
						width: 15%;
					}
					
					.workflowID,
					.workflowArrow{
						font-size: 1.3em;
						text-align: center;
					}
					
					.worksflowTitle{
						height: 100%;
						float: left;
						padding: 2px 5px;
						position: relative;
						width: 70%;
					}
					
					.workflowArrow >.fa-chevron-right{
						position: absolute;
						top: 12px;
						right: 5px;
					}
					
					.scopeHeading {
						font-size: 120%;
						font-weight: bold;
					}
					
					.in-scope-element {
						background-color: hsla(175, 60%, 40%, 1);
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.out-of-scope-element{
						background-color: #999;
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
	
					.refModel-l0-outer{
						<!--background-color: pink;-->
						border: 1px solid #aaa;
						padding: 10px 10px 0px 10px;
						border-radius: 4px;
						background-color: #eee;
					}
					
					.refModel-l0-title{
						margin-bottom: 5px;
						line-height: 1.1em;
					}
					
					.refModel-l1-outer{
					}
					
					.refModel-l1-title{
					}
					
					.refModel-blob, .busRefModel-blob, .appRefModel-blob, .techRefModel-blob {
						display: table;
						width: 128px;
						height: 48px;
						padding: 2px 12px;
						max-height: 50px;
						overflow: hidden;
						border: 3px solid #fff!important;
						<!--background-color: #fff;-->
						<!--border-radius: 4px;-->
						<!--float: left;-->
						<!--margin-right: 10px;-->
						<!--margin-bottom: 10px;-->
						text-align: center;
						font-size: 12px;
						position: relative;
					}
					
					.busRefModel-blob-noheatmap {
						background-color: #999;
					}
					
					.busRefModel-blob-selected {
						border: 3px solid red!important;
					}
					
					.refModel-blob:hover {border: 2px solid #666;}
					
					.refModel-blob-title{
						display: table-cell;
						vertical-align: middle;
						line-height: 1em;
					}
					
					.refModel-blob-info {
						position: absolute;
						bottom: -2px;
						right: 1px;
					}
					
					.refModel-blob-info > i {
						color: #fff;
					}
					
					.refModel-blob-refArch {
						position: absolute;
						bottom: 0px;
						left: 2px;
					}
					.busRefModel-blobWrapper{
						border: 1px solid #ccc;
						display:  block;
						width: 130px;
						height: 74px;
						float: left;
						margin-right: 10px;
						margin-bottom: 10px;
						background-color: #fff;
					}
					
					.busRefModel-blobAnnotationWrapper {
						width:100%;
						height: 24px;
						font-size: 12px;
						line-spacing: 1.1em;
						background-color: #fff;
					}
					
					.blobAnnotationL,.blobAnnotationR,.blobAnnotationC {
						float:left;
						padding: 2px;
						text-align: center;
						border-top: 1px solid #ccc;
						height: 100%;
					}
					
					.blobAnnotationL {width: 25%;}
					.blobAnnotationC {width: 50%; border-left: 1px solid #ccc;border-right: 1px solid #ccc;}
					.blobAnnotationR {width: 25%;}
					
					.fa-flag {color: #c3193c;}
					
					.fa-info-circle:hover {cursor: pointer;}
					.summaryBlock,
					.summaryBlockHeader{
						padding: 5px;
						position: relative;
						display: table;
						width: 100%;
					}
					
					.summaryBlock{
						height: 50px;
					}
					
					.summaryBlockLabel{
						display: table-cell;
						vertical-align: middle;
					}
					
					.summaryBlockResult{
						display: table-cell;
						vertical-align: middle;
						text-align: center;
					}
					
					.summaryBlockNumber{
						text-align: center;
					}
					
					.summaryBlockDesc{
						text-align: center;
					}
					
					.summaryBlock > i{
						position: absolute;
						right: 5px;
						bottom: 3px;
					}
					
					.serviceQualOuter{
						height: 90px;
						margin-bottom: 10px;
						border: 1px solid #aaa;
						padding: 10px 10px 0px 30px;
						border-radius: 4px;
						background-color: #eee;
					}
					
					.serviceQual-title{
						margin-bottom: 10px;
						line-height: 1.1em;
					}
					
					
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}
					
					.pl_action_button {
						min-width: 80px;
						padding: 2px;
					}
					
					.modal_action_button {
						width: 110px;
					}

					.actionSelected { 
						background-color: hsla(220, 70%, 85%, 1) !important;
					}
					
					.helpButton{
						position: absolute;
						z-index: 100;
						top: -80px;
						right: 15px;
						width: 200px;
						box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
					}		
					
					.threeColModel_valueChainColumnContainer .threeColModel_modalValueChainColumnContainer{
					    margin-right: 8px;
					    float: left;
					    position: relative;
					    box-sizing: content-box;
					    display: table;
					}
					
					.threeColModel_valueChainObject{
					    width: 115px;
					    padding: 5px 20px 5px 5px;
					    height: 40px;
					    text-align: center;
					    background: url(images/value_chain_arrow_end_grey.png) no-repeat right center;
					    position: relative;
					    box-sizing: content-box;
					    display: table-cell;
					    vertical-align:middle;
					}
					
					
					.threeColModel_valueChainObject:hover{
					    opacity: 0.75;
					    cursor: pointer;
					    box-sizing: content-box;
					}
					
					.popover {
					    max-width: 400px;
					}
					
					@media (min-width: 768px) {
					  .modal .modal-xl {
					    width: 90%;
					   max-width:1200px;
					  }
					}
					
					td.details-control::after {
					    content: "\f0da";
					    font-family:'FontAwesome';
					    cursor: pointer;
					    font-size: 150%;
					}
					tr.shown td.details-control::after {
					    content: "\f0d7";
					    font-family:'FontAwesome';
					    cursor: pointer;
					    font-size: 150%;
					}
					
					.dt-checkboxes-select-all,.dt-checkboxes-cell {text-align:left!important;}
					
					.selected-gantt-plan {
						background: #23964d;
						border: 2px solid #23964d;
					}
					
					.selected-gantt-title {
						color: #23964d;
					}
					
					/********************************************************************/
					/*** SERVICE QUALITY GAUGE STYLES ***/
					.gaugePanel{
					  width: 100%;
					  float: left;
					}
					
					.gaugeLabel{
					  width: 100%;
					  float: left;
					  line-height: 1.1em;
					  text-align: center;
					}
					
					.gaugeContainer{
					  width: 100%;
					  float: left;
					  text-align: center;
					}
					/********************************************************************/
					
					ul.multi-column-list {
					  columns: 2;
					  -webkit-columns: 2;
					  -moz-columns: 2;
					}
				</style>
				<xsl:call-template name="RenderModelGraphStyle"/>
				
				<!--<xsl:call-template name="refModelStyles"/>-->
				
				<script src="js/FileSaver.min.js"></script>
				<script src="js/jszip/jszip.min.js"></script>
				
				<script>
					
					function showHelpButton(){
						setTimeout(function(){$('.helpButton').fadeIn(1000);}, 1000);
						$('.helpButton').draggable();
					};
					
					function menuSelect(stepID){
						$('.workFlowContent').hide();
						$('#step'+stepID+'Content').animate({width:'toggle'},500);
						$('.worksflowTitle').removeClass('bg-darkgrey');
						$('.worksflowTitle').addClass('bg-lightgrey');
						$('#step'+stepID).find('.worksflowTitle').removeClass('bg-lightgrey');
						$('#step'+stepID).find('.worksflowTitle').addClass('bg-darkgrey');
					};
					
				</script>
				
				<xsl:call-template name="RenderModelGraphJS"/>
				
				<script>
					<!-- Handlebar templates -->
					var goalTemplate, goalDetailTemplate, valueStagesTemplate, modalValueStagesTemplate, busCapDetailTemplate, noActionButtonTemplate, planningActionButtonTemplate, physProcsRowTemplate, physProcsOrgRowTemplate, physProcsBusProcessRowTemplate, appServiceRowTemplate, appRowTemplate, stratPlanDetailsTemplate, ganttStratPlanTemplate;
					var busCapModalContentTemplate, busProcessModalContentTemplate, orgModalContentTemplate, appServiceContentTemplate, appModalContentTemplate, stratPlanErrorsTemplate, roadmapExcelJSONTemplate, dropdownTemplate;
					
					<!-- Global JS Variables -->
					var strategicPlanTable, stratPlanObjsTable, stratPlanPhysProcsTable, stratPlanAppProRolesTable, stratPlanElementsTable;
					var gaugeOpts;
					var elementUnderReview;
					var currentModal;
					var appUnderReviewIndex, appServiceUnderReviewIndex, orgUnderReviewIndex, busProcessUnderReviewIndex = 0;
					var modalHeatmap = 'cx';
					var modalHistory = [];
					var nextModalElement;
			
					var windowWidth = $(window).width()*2;
					var windowHeight = $(window).height()-150;
					
					<!-- styles and icons -->
					var cxStyles = {
						negative: {
							label: "<xsl:value-of select="eas:i18n('Poor')"/>",
							icon: "<xsl:value-of select="$negativeIcon"/>"
						},
						neutral: {
							label: "<xsl:value-of select="eas:i18n('OK')"/>",
							icon: "<xsl:value-of select="$neutralIcon"/>"
						},
						positive: {
							label: "<xsl:value-of select="eas:i18n('Good')"/>",
							icon: "<xsl:value-of select="$positiveIcon"/>"
						},
						undefined: {
							label: "<xsl:value-of select="eas:i18n('Undefined')"/>",
							icon: "<xsl:value-of select="$noCxIcon"/>"
						},
					}
					
					var emotionStyles = {
						negative: {
							label: "<xsl:value-of select="eas:i18n('Negative')"/>",
							emoji: "<xsl:value-of select="$verySadEmoji"/>"
						},
						quiteNegative: {
							label: "<xsl:value-of select="eas:i18n('Quite Negative')"/>",
							emoji: "<xsl:value-of select="$sadEmoji"/>"
						},
						neutral: {
							label: "<xsl:value-of select="eas:i18n('Neutral')"/>",
							emoji: "<xsl:value-of select="$neutralEmoji"/>"
						},
						quitePositive: {
							label: "<xsl:value-of select="eas:i18n('Quite Positive')"/>",
							emoji: "<xsl:value-of select="$happyEmoji"/>"
						},
						positive: {
							label: "<xsl:value-of select="eas:i18n('Positive')"/>",
							emoji: "<xsl:value-of select="$veryHappyEmoji"/>"
						},
						undefined: {
							label: "<xsl:value-of select="eas:i18n('Undefined')"/>",
							emoji: "<xsl:value-of select="$noEmoji"/>"
						}
					}
	
				    <!-- Read only JSON objects -->
					var analysisDatasetAPIUrl = '<xsl:value-of select="$analysisDatasetAPIUrl"/>';
					var viewData = {};
					
					<!-- Temporarily User defined JSON objects -->
					var tempUserData = {
						currentHeatmap: "cx",
						currentValueStream: null,
						selectedBusCapIds: [],
						selectedBusCaps: [],
						inScopeCustJourneyPhases: [],
						inScopeObjectives: [],
						inScopeBusProcesses: [],
						inScopePhysProcesses: [],
						inScopeOrgs: [],
						inScopeAppServices: [],
						inScopeAppProRoles: [],
						inScopeApps: [],
						newStratPlanId: 1
					};
					
					<!-- Dynamic User defined JSON objects -->
					var dynamicUserData = {
						currentBusModelId: <xsl:choose><xsl:when test="string-length($param1) > 0">"<xsl:value-of select="$param1"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
						currentStrategicPlan: null,
						currentPlanningActions: null,
						roadmap: null,
						strategicPlans: [],
						planDeps: []
					};
					
					var roadmapPlans;
					var selectedRoadmapPlanId;
					
				  	
				  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>		
					
					<!-- START DATA SETUP FUNCTIONS -->
					<!-- Initiatives -->
					
					<!-- Business Capability -->
					function populateBusCapLists(aBusCap) {
						//where required, populate the business capability's object properties
						
						
						if(aBusCap.objectives == null) {
							var theObjs = getObjectsByIds(viewData.objectives, "id", aBusCap.objectiveIds);
							aBusCap.objectives = theObjs;
						}
						
						
						if(aBusCap.valueStreams == null) {
							var theVSs = getObjectsByIds(viewData.valueStreams, "id", aBusCap.valueStreamIds);
							aBusCap.valueStreams = theVSs;
						}
						
						if(aBusCap.physProcesses == null) {
							var thePhysProcs = getObjectsByIds(viewData.physProcesses, "id", aBusCap.physProcessIds);
							aBusCap.physProcesses = thePhysProcs;
							populatePhysProcsObjects(thePhysProcs);
						}
						
						if(aBusCap.appProRoles == null) {
							var theAppProRoles = getObjectsByIds(viewData.appProviderRoles, "id", aBusCap.appProRoleIds);
							aBusCap.appProRoles = theAppProRoles;
						}
						
						// app services, derived form the app pro roles
						var anAppProRole, otherAPRs, aService, appService;
						var serviceList = [];
						var thisAppIndex;
						var altAppCount;
						if(aBusCap.services == null) {
							for (var j = 0; aBusCap.appProRoles.length > j; j += 1) {
								anAppProRole = aBusCap.appProRoles[j];
								appService = getObjectById(viewData.appServices, "id", anAppProRole.serviceId);
								otherAPRs = getObjectsByIds(viewData.appProviderRoles, "serviceId", [anAppProRole.serviceId]);
								otherAppIds = getObjectListPropertyVals(otherAPRs, "appId");
								otherApps = getObjectsByIds(viewData.applications, "id", otherAppIds);
								if(otherApps.length > 0) {
									altAppCount = otherApps.length;
								} else {
									altAppCount = 1;
								}
								aService = {
									id: anAppProRole.id,
									appService: appService,
									altAppCount: altAppCount,
									altApps: otherApps
								}
								serviceList.push(aService);
							}
							aBusCap.services = serviceList;
						}	
					}
					
					
					<!-- Business Process -->
					function populateBusProcessLists(aBusProcess) {
						//where required, populate the business process's object properties
						if(aBusProcess.planningActions == null) {
							var thePlanningActions = getObjectsByIds(viewData.planningActions, "id", aBusProcess.planningActionIds);
							aBusProcess.planningActions = thePlanningActions;
						}
						
						if(aBusProcess.busCaps == null) {
							var theBusCaps = getObjectsByIds(viewData.busCaps, "id", aBusProcess.busCapIds);
							aBusProcess.busCaps = theBusCaps;
						}
						
						if(aBusProcess.objectives == null) {
							var theObjs = getObjectsByIds(viewData.objectives, "id", aBusProcess.objectiveIds);
							aBusProcess.objectives = theObjs;
						}
						
						
						if(aBusProcess.valueStreams == null) {
							var theVSs = getObjectsByIds(viewData.valueStreams, "id", aBusProcess.valueStreamIds);
							aBusProcess.valueStreams = theVSs;
						}
						
						if(aBusProcess.physProcesses == null) {
							var thePhysProcs = getObjectsByIds(viewData.physProcesses, "id", aBusProcess.physProcessIds);
							aBusProcess.physProcesses = thePhysProcs;
							populatePhysProcsObjects(thePhysProcs);
						}
						
						if(aBusProcess.appProRoles == null) {
							var theAppProRoles = getObjectsByIds(viewData.appProviderRoles, "id", aBusProcess.appProRoleIds);
							aBusProcess.appProRoles = theAppProRoles;
						}
						
						// app services, derived form the app pro roles
						var anAppProRole, otherAPRs, aService, appService;
						var serviceList = [];
						var thisAppIndex;
						var altAppCount;
						if(aBusProcess.services == null) {
							for (var j = 0; aBusProcess.appProRoles.length > j; j += 1) {
								anAppProRole = aBusProcess.appProRoles[j];
								appService = getObjectById(viewData.appServices, "id", anAppProRole.serviceId);
								otherAPRs = getObjectsByIds(viewData.appProviderRoles, "serviceId", [anAppProRole.serviceId]);
								otherAppIds = getObjectListPropertyVals(otherAPRs, "appId");
								otherApps = getObjectsByIds(viewData.applications, "id", otherAppIds);
								if(otherApps.length > 0) {
									altAppCount = otherApps.length;
								} else {
									altAppCount = 1;
								}
								aService = {
									id: anAppProRole.id,
									appService: appService,
									altAppCount: altAppCount,
									altApps: otherApps
								}
								serviceList.push(aService);
							}
							aBusProcess.services = serviceList;
						}	
					}
					
					
					<!-- Organisation -->
					function populateOrgLists(anOrg) {
						//where required, populate the organisation's object properties
						if(anOrg.planningActions == null) {
							var thePlanningActions = getObjectsByIds(viewData.planningActions, "id", anOrg.planningActionIds);
							anOrg.planningActions = thePlanningActions;
						}
						
						
						if(anOrg.objectives == null) {
							var theObjs = getObjectsByIds(viewData.objectives, "id", anOrg.objectiveIds);
							anOrg.objectives = theObjs;
						}
						
						
						if(anOrg.valueStreams == null) {
							var theVSs = getObjectsByIds(viewData.valueStreams, "id", anOrg.valueStreamIds);
							anOrg.valueStreams = theVSs;
						}
						
						if(anOrg.physProcesses == null) {
							var thePhysProcs = getObjectsByIds(viewData.physProcesses, "id", anOrg.physProcessIds);
							anOrg.physProcesses = thePhysProcs;
							populatePhysProcsObjects(thePhysProcs);
						}
						
						if(anOrg.appProRoles == null) {
							var theAppProRoles = getObjectsByIds(viewData.appProviderRoles, "id", anOrg.appProRoleIds);
							anOrg.appProRoles = theAppProRoles;
						}
						
						// app services, derived form the app pro roles
						var anAppProRole, otherAPRs, aService, appService;
						var serviceList = [];
						var thisAppIndex;
						var altAppCount;
						if(anOrg.services == null) {
							for (var j = 0; anOrg.appProRoles.length > j; j += 1) {
								anAppProRole = anOrg.appProRoles[j];
								appService = getObjectById(viewData.appServices, "id", anAppProRole.serviceId);
								otherAPRs = getObjectsByIds(viewData.appProviderRoles, "serviceId", [anAppProRole.serviceId]);
								otherAppIds = getObjectListPropertyVals(otherAPRs, "appId");
								otherApps = getObjectsByIds(viewData.applications, "id", otherAppIds);
								if(otherApps.length > 0) {
									altAppCount = otherApps.length;
								} else {
									altAppCount = 1;
								}
								aService = {
									id: anAppProRole.id,
									appService: appService,
									altAppCount: altAppCount,
									altApps: otherApps
								}
								serviceList.push(aService);
							}
							anOrg.services = serviceList;
						}	
					}
					
					
					<!-- Application Service -->
					function populateAppServiceLists(anAppService) {
						//where required, populate the app service's object properties
						if(anAppService.planningActions == null) {
							var thePlanningActions = getObjectsByIds(viewData.planningActions, "id", anAppService.planningActionIds);
							anAppService.planningActions = thePlanningActions;
						}
						
						
						if(anAppService.objectives == null) {
							var theObjs = getObjectsByIds(viewData.objectives, "id", anAppService.objectiveIds);
							anAppService.objectives = theObjs;
						}
						
						
						if(anAppService.valueStreams == null) {
							var theVSs = getObjectsByIds(viewData.valueStreams, "id", anAppService.valueStreamIds);
							anAppService.valueStreams = theVSs;
						}
						
						if(anAppService.physProcesses == null) {
							var thePhysProcs = getObjectsByIds(viewData.physProcesses, "id", anAppService.physProcessIds);
							anAppService.physProcesses = thePhysProcs;
							populatePhysProcsObjects(thePhysProcs);
						}
						
						if(anAppService.appProRoles == null) {
							var theAppProRoles = getObjectsByIds(viewData.appProviderRoles, "id", anAppService.appProRoleIds);
							anAppService.appProRoles = theAppProRoles;
						}
						
						if(anAppService.applications == null) {
							var theAppIds = getObjectIds(anAppService.appProRoles, "appId");
							var theApps = getObjectsByIds(viewData.applications, "id", theAppIds);
							anAppService.applications = theApps;
						}
						
					}
					
					
					<!-- function to populate the object properties of a given application -->
					function populateAppLists(anApp) {
						//where required, populate the application's object properties
						if(anApp.planningActions == null) {
							var thePlanningActions = getObjectsByIds(viewData.planningActions, "id", anApp.planningActionIds);
							anApp.planningActions = thePlanningActions;
						}
						
						if(anApp.organisations == null) {
							var theOrgs = getObjectsByIds(viewData.organisations, "id", anApp.organisationIds);
							anApp.organisations = theOrgs;
						}
						
						if(anApp.objectives == null) {
							var theObjs = getObjectsByIds(viewData.objectives, "id", anApp.objectiveIds);
							anApp.objectives = theObjs;
						}
						
						if(anApp.valueStreams == null) {
							var theVSs = getObjectsByIds(viewData.valueStreams, "id", anApp.valueStreamIds);
							anApp.valueStreams = theVSs;
						}
						
						if(anApp.physProcesses == null) {
							var thePhysProcs = getObjectsByIds(viewData.physProcesses, "id", anApp.physProcessIds);
							anApp.physProcesses = thePhysProcs;
							populatePhysProcsObjects(thePhysProcs);
						}
						
						if(anApp.appProRoles == null) {
							var theAppProRoles = getObjectsByIds(viewData.appProviderRoles, "id", anApp.appProRoleIds);
							anApp.appProRoles = theAppProRoles;
						}
						
						// app services, derived form the app pro roles
						var anAppProRole, otherAPRs, aService, appService;
						var serviceList = [];
						var thisAppIndex;
						var altAppCount;
						if(anApp.services == null) {
							for (var j = 0; anApp.appProRoles.length > j; j += 1) {
								anAppProRole = anApp.appProRoles[j];
								appService = getObjectById(viewData.appServices, "id", anAppProRole.serviceId);
								otherAPRs = getObjectsByIds(viewData.appProviderRoles, "serviceId", [anAppProRole.serviceId]);
								otherAppIds = getObjectListPropertyVals(otherAPRs, "appId");
								//remove the current app from the list of alternatives
								var thisAppIndex = otherAppIds.indexOf(anApp.id);
								if(thisAppIndex > -1) {
									otherAppIds.splice(thisAppIndex, 1);
								}
								otherApps = getObjectsByIds(viewData.applications, "id", otherAppIds);
								if(otherApps.length > 0) {
									altAppCount = otherApps.length;
								} else {
									altAppCount = 1;
								}
								aService = {
									id: anAppProRole.id,
									appService: appService,
									altAppCount: altAppCount,
									altApps: otherApps
								}
								serviceList.push(aService);
							}
							anApp.services = serviceList;
						}	
					}
					
					
					function populateAppProRoleObjects(anAppProRole) {
					
						if(anAppProRole.application == null) {
							var theApp = getObjectById(viewData.applications, "id", anAppProRole.appId);
							anAppProRole.application = theApp;
						}
						
						if(anAppProRole.service == null) {
							var theAppService = getObjectById(viewData.appServices, "id", anAppProRole.serviceId);
							anAppProRole.service = theAppService;
						}

					}
					
					<!-- function to populate the object properties of a given physical process -->
					function populatePhysProcsObjects(aPhysProcList) {
						var aPhysProc;
						
						for (var i = 0; viewData.physProcesses.length > i; i += 1) {
							aPhysProc = viewData.physProcesses[i];
							
							if(aPhysProc.busProcess == null) {
								var theBusProcess = getObjectById(viewData.busProcesses, "id", aPhysProc.busProcessId);
								aPhysProc.busProcess = theBusProcess;
							}
							
							if(aPhysProc.organisation == null) {
								var theOrg = getObjectById(viewData.organisations, "id", aPhysProc.orgId);
								aPhysProc.org = theOrg;
							}
						}
					}
					
					
					function populatePhysProcObjects(aPhysProc) {
							
						if(aPhysProc.busProcess == null) {
							var theBusProcess = getObjectById(viewData.busProcesses, "id", aPhysProc.busProcessId);
							aPhysProc.busProcess = theBusProcess;
						}
						
						if(aPhysProc.organisation == null) {
							var theOrg = getObjectById(viewData.organisations, "id", aPhysProc.orgId);
							aPhysProc.org = theOrg;
						}
						
						if(aPhysProc.appProRoles == null) {
							var theAppProRoles = getObjectsByIds(viewData.appProviderRoles, "id", aPhysProc.appProRoleIds);
							aPhysProc.appProRoles = theAppProRoles;
						}
						
						if(aPhysProc.applications == null) {
							var theApps = getObjectsByIds(viewData.applications, "id", aPhysProc.applicationIds);
							aPhysProc.applications = theApps;
						}
					}
					
					
					<!-- function to populate the object properties of the goals -->
					function initGoals() {
						var theObjs;
						for (var i = 0; viewData.goals.length > i; i += 1) {
							aGoal = viewData.goals[i];
							theObjs = getObjectsByIds(viewData.objectives, "id", aGoal.objectiveIds);
							aGoal.objectives = theObjs;
							console.log('Objective count for goal ' + aGoal.name + ': ' + aGoal.objectives.length);
						}
					}
					
					<!-- END DATA SETUP FUNCTIONS -->
					
					<!-- START GOAL FUNCTIONS -->
					<!-- function to update the styling the goals -->
					function updateGoalStyles() {
						var thisGoalBlob, thisGoalId, thisGoal;
						$('.goal_Outer').each(function() {
							thisGoalBlob = $(this);
							thisGoalId = $(this).attr('id');
							thisGoal = getObjectById(viewData.goals, "id", thisGoalId);
							if((thisGoal.inScope) || (tempUserData.selectedBusCaps.length == 0)) {
								thisGoalBlob.attr("class", 'goal_Outer in-scope-element');
							} else {
								thisGoalBlob.attr("class", 'goal_Outer out-of-scope-element');
							}							
						});
					}
					
					
					<!-- END GOAL FUNCTIONS -->
					
					
					<!-- START VALUE STREAMS FUNCTIONS -->
					function initValueStreams() {
						<!--for (var i = 0; viewData.valueStreams.length > i; i += 1) {
							valStream = viewData.valueStreams[i];
							
							//Add references to the actual Customer Journey Phase objects
							for (var j = 0; valStream.valueStages.length > j; j += 1) {
								valStage = valStream.valueStages[j];
								valStage.customerJourneyPhases = getObjectsByIds(viewData.customerJourneyPhases, "id", valStage.customerJourneyPhaseIds);
							}
							
							//Set the initial overlay style for the value stages
							//setValueStageStyles(valStream.valueStages);
						}-->
					}
					
					<!-- function to update the heatmap overlay of a given list of value stages -->
					function updateValueStageStyles(theValueStages) {
						for (var i = 0; theValueStages.length > i; i += 1) {
							valStage = theValueStages[i];
							cxScore = valStage.cxScore;
							if(cxScore &lt; -5) {
								valStage.styleClass = 'bg-darkred-80';
							} else if(cxScore &lt; 0) {
								valStage.styleClass = 'bg-orange-100';
							} else if(cxScore &lt;= 5) {
								valStage.styleClass = 'bg-lightgreen-80';
							} else {
								valStage.styleClass = 'bg-brightgreen-100';
							}
							//console.log('Setting VS ' + valStage.name + ' style to: ' + valStage.styleClass);
						}
					}
					
					function refreshValueStageChevronStyles() {
						var thisVSChevron, thisVSId, thisVS, thisVSStyle;
						$('.threeColModel_valueChainColumnContainer').each(function() {
							thisVSChevron = $(this);
							thisVSId = $(this).attr('id');
							thisVS = getObjectById(viewData.valueStages, "id", thisVSId);
							//setValueStageStyle(thisVS);
							var heatmap = tempUserData.currentHeatmap;
							switch (heatmap) {
							    case 'cx':
							        thisVSStyle = thisVS.cxStyleClass;
							        break; 
							    case 'emotion':
							        thisVSStyle = thisVS.emotionStyleClass;
							        break; 
							    case 'kpi':
							        thisVSStyle = thisVS.kpiStyleClass;
							        break;
							    default:
							    	thisVSStyle = 'noHeatmapColour';
							        break;
							}
							thisVSChevron.attr("class", 'threeColModel_valueChainColumnContainer pull-left ' + thisVSStyle);							
						});
					}
					
					
					function refreshModalValueStageChevronStyles(aVSIdList, heatmap) {
						var thisVSChevron, thisVSId, thisVS;
						var thisVSStyle = 'out-of-scope-element';
						$('.threeColModel_modalValueChainColumnContainer').each(function() {
							thisVSChevron = $(this);
							thisVSId = $(this).attr('eas-id');
							
							if(aVSIdList.indexOf(thisVSId) &lt; 0) {
								thisVSChevron.attr("class", 'threeColModel_modalValueChainColumnContainer pull-left noHeatmapColour');	
							} else {
								thisVS = getObjectById(viewData.valueStages, "id", thisVSId);
								
								switch (heatmap) {
								    case 'cx':
								        thisVSStyle = thisVS.cxStyleClass;
								        break; 
								    case 'emotion':
								        thisVSStyle = thisVS.emotionStyleClass;
								        break; 
								    case 'kpi':
								        thisVSStyle = thisVS.kpiStyleClass;
								        break; 
								}
								thisVSChevron.attr("class", 'threeColModel_modalValueChainColumnContainer pull-left ' + thisVSStyle);	
							}
													
						});
					}
					
					<!--function setValueStageStyle(valStage) {
						if((valStage.inScope) || (tempUserData.selectedBusCaps.length == 0)) {
							switch (tempUserData.currentHeatmap) {
							    case 'cx':
							        valStage.styleClass = valStage.cxStyleClass;
							        break; 
							    case 'emotion':
							        valStage.styleClass = valStage.emotionStyleClass;
							        break; 
							    case 'kpi':
							        valStage.styleClass = valStage.kpiStyleClass;
							        break; 
							}
						} else {
							valStage.styleClass = 'out-of-scope-element';
						}
					}-->
					
					
					function setValueStageStyles(theValueStages) {
						for (var i = 0; theValueStages.length > i; i += 1) {
							valStage = theValueStages[i];
							if((valStage.inScope) || (tempUserData.selectedBusCaps.length == 0)) {
								switch (tempUserData.currentHeatmap) {
								    case 'cx':
								        valStage.styleClass = valStage.cxStyleClass;
								        break; 
								    case 'emotion':
								        valStage.styleClass = valStage.emotionStyleClass;
								        break; 
								    case 'kpi':
								        valStage.styleClass = valStage.kpiStyleClass;
								        break; 
								}
							} else {
								valStage.styleClass = 'out-of-scope-element';
							}
							// console.log('Setting VS ' + valStage.name + ' style to: ' + valStage.styleClass);
						}
					}
					

					
					function setCurrentValueStream(vsId) {
						tempUserData.currentValueStream = getObjectById(viewData.valueStreams, "id", vsId);
						
						if(tempUserData.currentValueStream != null) {
							// console.log('Setting current value stream: ' + tempUserData.currentValueStream.valueStages.length);
							// setValueStageStyles(valueStream.valueStages);							
							$("#valueStagesContainer").html(valueStagesTemplate(tempUserData.currentValueStream));
						}
					}
					<!-- END VALUE STREAMS FUNCTIONS -->
					
					
					
					<!-- START BUSINESS CAPABILITY FUNCTIONS -->
					<!-- function to update the heatmap styles for business capabilities -->
					function updateBusCapHeatmaps() {
					
						var thisBusCapBlob, busCapStyle;
						$('.busRefModel-blob').each(function() {
							thisBusCapBlob = $(this);
							thisBusCapId = $(this).attr('id');
							thisBusCap = getObjectById(viewData.busCaps, "id", thisBusCapId);
							
							updateBusCapBlobHeatmap(thisBusCapBlob, thisBusCap)
						});
					}
					
					
					<!-- function to update the lists of in scope elements -->
					function updateInScopeElements() {
					
						//update inScope lists
						// goals
						updateInScopeList(viewData.goals, "goalIds");
						
						//objectives
						updateInScopeList(viewData.objectives, "objectiveIds");
						
						// value stages
						updateInScopeList(viewData.valueStages, "valueStageIds");					
						
						//customer journey phases
						<!-- MAY NOT BE NEEEDED -->
						<!--var newCustJourneyList = updateInScopeObjectList(viewData.customerJourneyPhases, "customerJourneyPhaseIds"); 
						tempUserData.inScopeCustJourneyPhases = newCustJourneyList;-->
						
						//physical processes
						var newPhysProcList = updateInScopeObjectList(viewData.physProcesses, "physProcessIds"); 
						//merge the list of physical processes in scope for selected business capabilities with those already selected for the strategic plan
						//tempUserData.inScopePhysProcesses = getUniqueArrayVals([newPhysProcList, dynamicUserData.currentStrategicPlan.busProcesses]);
						tempUserData.inScopePhysProcesses = newPhysProcList;
						
						//app pro roles
						var newAppProRoleList = updateInScopeObjectList(viewData.appProviderRoles, "appProRoleIds"); 
						//merge the list of application provider roles in scope for selected business capabilities with those already selected for the strategic plan
						//tempUserData.inScopeAppProRoles = getUniqueArrayVals([newAppProRoleList, dynamicUserData.currentStrategicPlan.appServices]);
						tempUserData.inScopeAppProRoles = newAppProRoleList;
						
						//apps
						var newAppList = updateInScopeObjectList(viewData.applications, "applicationIds"); 
						//merge the list of applications in scope for selected business capabilities with those already selected for the strategic plan
						//tempUserData.inScopeApps = getUniqueArrayVals([newAppList, dynamicUserData.currentStrategicPlan.applications]);
						tempUserData.inScopeApps = newAppList;
					}
					
					<!-- function to set the inScope properties for the given list elements -->
					function updateInScopeList(fullList, property) {
						var elementIdArrays = [];
						var aBusCap, anElement;
						
						for (var i = 0; tempUserData.selectedBusCaps.length > i; i += 1) {
							aBusCap = tempUserData.selectedBusCaps[i];
							if(aBusCap[property].length > 0) {
								elementIdArrays.push(aBusCap[property]);
							}
						}
						var inScopeElementIDs = getUniqueArrayVals(elementIdArrays);
						
						for (var j = 0; fullList.length > j; j += 1) {
							anElement = fullList[j];
							if(inScopeElementIDs.indexOf(anElement.id) >= 0) {
								anElement.inScope = true;
							} else {
								anElement.inScope = false;
							}
						}
						
						//console.log(property + ' count: ' + inScopeElementIDs.length);
					}
					
					
					<!-- function to update the given list of in scope elements -->
					function updateInScopeObjectList(fullList, property) {
						var elementIdArrays = [];
						var aBusCap, anElement;
						
						for (var i = 0; tempUserData.selectedBusCaps.length > i; i += 1) {
							aBusCap = tempUserData.selectedBusCaps[i];
							if(aBusCap[property].length > 0) {
								elementIdArrays.push(aBusCap[property]);
							}
						}
						var inScopeElementIDs = getUniqueArrayVals(elementIdArrays);

						var newList = getObjectsByIds(fullList, "id", inScopeElementIDs);
						console.log(property + ' count: ' + newList.length);
						
						return newList;
					}
					
					
					<!-- function to update the heatmap style for a given business capability blob -->
					function updateBusCapBlobHeatmap(thisBusCapBlob, thisBusCap) {
					
						var busCapStyle = "";
						if(thisBusCap.inScope) {
							busCapStyle = "busRefModel-blob-selected ";
						}
						if(thisBusCap != null) {
							if(tempUserData.currentValueStream != null) {
								var thisBusCapHeatmap = getObjectById(thisBusCap.heatmapScores, "id", tempUserData.currentValueStream.id);
								if(thisBusCapHeatmap != null) {
									switch (tempUserData.currentHeatmap) {
									    case 'cx':
									        busCapStyle = busCapStyle + "busRefModel-blob " + thisBusCapHeatmap.cxStyleClass;
									        break; 
									    case 'emotion':
									        busCapStyle = busCapStyle + "busRefModel-blob " + thisBusCapHeatmap.emotionStyleClass;
									        break; 
									    case 'kpi':
									        busCapStyle = busCapStyle + "busRefModel-blob " + thisBusCapHeatmap.kpiStyleClass;
									        break; 
									}
									thisBusCapBlob.attr("class", busCapStyle);
								}
							} else {
								thisBusCapBlob.attr("class", busCapStyle  + "busRefModel-blob busRefModel-blob-noheatmap");
							}
						}
					}
					
					
					<!-- END BUSINESS CAPABILITY FUNCTIONS -->
					
					
					<!-- START STRATEGIC PLAN FORM FUNCTIONS -->
					<!-- functon to draw the tables contained in the Strategic PLans stage -->
					function initRoadmapScopeView() {
						drawStrategicPlanPhysProcTable();	
					}
					
					
					function initStrategicPlansView() {
						drawStrategicPlanObjsTable();
						drawStrategicPlansTable();
						drawModelGraph();
					}
					
					
					<!-- function to refresh the contents of the strategic plan form with the current strategic plan -->
					function refreshStrategicPlanForm() {
						//clear the name and description fields
						$('#stratPlanName').val('');
						$('#stratPlanDesc').val('');
											
						//reset appropriate lists of elements and variables
						tempUserData.inScopeObjectives = [];
											
						//update the strategic plan form tables
						//objectives		
						updateStrategicPlanObjsTable();
							
						//elements
						updateStrategicPlanElementsTable();			
						
						//graph model
						refreshGraphModel()
						
					}
	
					
					<!-- utility function to add a given number of days to a date -->
					function addDateDays(aDate, days) {
					    var newDate = new Date(aDate);
					    newDate.setDate(newDate.getDate() + days);
					    return newDate;
					}
					
					
					function addDateMonths(aDate, months) {
					    var newDate = new Date(aDate);
					    newDate.setMonth(newDate.getMonth() + months);
					    return newDate;
					}
					
					<!-- function to format the start and end dates for a Strategic Plan -->
					function formatStratPlanDates(aPlan) {
						aPlan.displayStartDate = moment(aPlan.startDate).format('Do MMM YYYY');
						aPlan.displayEndDate = moment(aPlan.endDate).format('Do MMM YYYY');
					}
					
					<!-- function to format the start and end dates for a Strategic Plan -->
					function formatExcelStratPlanDates(aPlan) {
						aPlan.excelStartDate = moment(aPlan.startDate).format('YYYY-MM-DD');
						aPlan.excelEndDate = moment(aPlan.endDate).format('YYYY-MM-DD');
					}
					
					<!-- function to create a new Roadmap -->
					function newRoadmap() {	
						var aNewRoadmap = {
							"extId": 'RM' + (+new Date).toString(36),
							"name": null,
							"description": null
						};
						
						return aNewRoadmap;		
					}
					
					
					<!-- function to create a new Strategic Plan -->
					function newPlanningActions() {	
						var somePlanningActions = {
							"objectives": [],
							"busProcesses": [],
							"organisations": [],
							"appServices": [],
							"applications": []
						};
						
						return somePlanningActions;		
					}
					
					
					<!-- function to create a new Strategic Plan -->
					function newStrategicPlan() {	
						var todaysDate = new Date();
						var newStratgegicPlan = {
							"id": 'SP' + (+new Date).toString(36),
							"name": "",
							"description": "",
							"startDate": todaysDate,
							"displayStartDate": "",
							"excelStartDate": "",
							"endDate": addDateMonths(todaysDate, 1),
							"displayEndDate": "",
							"excelEndDate": "",
							"objectives": [],
							"elements": [],
							"busProcesses": [],
							"organisations": [],
							"appServices": [],
							"applications": [],
							"changedElements": []
						};
						formatStratPlanDates(newStratgegicPlan);
						formatExcelStratPlanDates(newStratgegicPlan);
						
						//tempUserData.newStratPlanId = tempUserData.newStratPlanId + 1;
						
						return newStratgegicPlan;		
					}
					
					<!-- function to return the HTML for a planning action button -->
					function renderPlanningActionButton(objectList, anId) {
						var theObj = getObjectById(objectList, "id" , anId);
						if(theObj != null) {
							if(theObj.planningAction != null) {
								return planningActionButtonTemplate(theObj);							
							} else {
								return noActionButtonTemplate(theObj);
							}
						} else {
							return "";
						}
					}
					
					
					<!-- function to update the list of Objectives selected for the current Strategic Plan -->
					<!--function refreshStratPlanObjectives(selectedObjIds) {
						var anObj, anObjId;
						var newObjList = [];
						for (var i = 0; viewData.objectives.length > i; i += 1) {
							anObj = viewData.objectives[i];
							if(selectedObjIds.indexOf(anObj.id) > -1) {
								anObj.isSelected = true;
								newObjList.push(anObj);
							} else {
								anObj.isSelected = false;
							}
						}
						dynamicUserData.currentPlanningActions.objectives = newObjList;
					}-->
					
					
					
					<!-- function to update the contents of the Strategic Plan Physical Processes table -->
					function updateStrategicPlanPhysProcTable() {
						if(stratPlanPhysProcsTable != null) {
							stratPlanPhysProcsTable.clear();
						    stratPlanPhysProcsTable.rows.add(tempUserData.inScopePhysProcesses);
				    
						    stratPlanPhysProcsTable.draw();	
					    }
					}
					
					
					<!-- function to draw the strategic plan physical processes table -->
					function drawStrategicPlanPhysProcTable() {
						if(stratPlanPhysProcsTable == null) {
							
							// Setup - add a text input to each footer cell
						    $('#stratPlanPhysProcsTable tfoot th').each( function() {
						        	var title = $(this).text();
						        	$(this).html( '&lt;input class="stratPlanPhysProcsSearch" type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							//create the table
							stratPlanPhysProcsTable = $('#stratPlanPhysProcsTable').DataTable({
								scrollY: "400px",
								scrollCollapse: true,
								paging: false,
								info: false,
								sort: true,
								responsive: false,
								data: tempUserData.inScopePhysProcesses,
								columns: [	
								    { 
								    	"data" : "busProcessLink",
								    	"width": "35%" 
								    },
								    {
								    	"data" : "busProcessId",
								    	"width": "15%",
								    	"render": function(d){
							                if(d !== null){              
							                    	return renderPlanningActionButton(viewData.busProcesses, d);
								             } else {
								                    return "";
								             }
							            }
								    },
								    {
								    	"data" : "orgLink",
								    	"width": "35%" 
								    },
								    {
								    	"data" : "orgId",
								    	"width": "15%",
								    	"render": function(d){
							                if(d !== null){              
							                    return renderPlanningActionButton(viewData.organisations, d);
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
						    stratPlanPhysProcsTable.columns().every( function () {
						        var that = this;
						 
						        $( '.stratPlanPhysProcsSearch', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						    
						    stratPlanPhysProcsTable.columns.adjust();
						    
						    $(window).resize( function () {
						        stratPlanPhysProcsTable.columns.adjust();
						    });
						}
					}
					
					
					<!-- function to update the contents of the applications table -->
					function updateStrategicPlanAppProRolesTable() {
						if(stratPlanAppProRolesTable != null) {
							stratPlanAppProRolesTable.clear();
					    	stratPlanAppProRolesTable.rows.add(tempUserData.inScopeAppProRoles);
			    
					    	stratPlanAppProRolesTable.draw();	
					    }
					}
					
					
					<!-- function to draw the strategic plan applications table -->
					function drawStrategicPlanAppProRolesTable() {
						if(stratPlanAppProRolesTable == null) {
							
							// Setup - add a text input to each footer cell
						    $('#stratPlanAppProRolesTable tfoot th').each(function() {
						        	var title = $(this).text();
						        	$(this).html( '&lt;input class="stratPlanAPRSearch" type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							//create the table
							stratPlanAppProRolesTable = $('#stratPlanAppProRolesTable').DataTable({
								scrollY: "300px",
								scrollCollapse: true,
								paging: false,
								info: false,
								sort: true,
								responsive: false,
								data: tempUserData.inScopeAppProRoles,
								columns: [	
								    { 
								    	"data" : "appLink",
								    	"width": "35%" 
								    },
								    {
								    	"data" : "appId",
								    	"width": "15%",
								    	"render": function(d){
							                if(d !== null){              
							                    	return renderPlanningActionButton(viewData.applications, d);
								             } else {
								                    return "";
								             }
							            }
								    },
								    {
								    	"data" : "serviceLink",
								    	"width": "35%" 
								    },
								    {
								    	"data" : "serviceId",
								    	"width": "15%",
								    	"render": function(d){
							                if(d !== null){              
							                    return renderPlanningActionButton(viewData.appServices, d);
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
						    stratPlanAppProRolesTable.columns().every( function () {
						        var that = this;
						 
						        $( '.stratPlanAPRSearch', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						    
						    stratPlanAppProRolesTable.on( 'draw', function () {
							    if(appUnderReviewIndex > 0) {
							    	//console.log('App List selected row: ' + appUnderReviewIndex);
							    	//stratPlanAppProRolesTable.scroller.toPosition( appUnderReviewIndex );
							    }
						    });
						    
						    stratPlanAppProRolesTable.columns.adjust();
						    
						    $(window).resize( function () {
						        stratPlanAppProRolesTable.columns.adjust();
						    });
						}
					}
					
					<!-- END STRATEGIC PLAN FUNCTIONS -->
					
					
					<!-- START BUSINESS CAPABILITY MODEL VARABLES AND FUNCTIONS -->	
	
					<!-- function to render the content of the applications modal dialog -->
					function renderBusCapModalContent(aBusCap) {
					
						//save the given bus cap
						elementUnderReview = aBusCap;
						currentModal = $('#busCapModal');
						
						//if required, populate the required object lists of the given bus cap
						populateBusCapLists(aBusCap);	
						
						
						//render the bus cap modal content
						//set up the object to be pasesed to handlebars
						var aBusCapContentJSON = {
							busCap: aBusCap,
							modalHistory: modalHistory
						}
						$("#busCapModelContent").html(busCapModalContentTemplate(aBusCapContentJSON));
									
						<!-- function to render the customer service kpi gauge -->
						function renderBusCapCustSvcGauge() {
							var score = Math.round(aBusCap.overallScores.kpiScore * 10);
							//set the customer service gauge
							var gaugeTarget = document.getElementById('busCapModalCustSvcGauge');
							var gauge = new Gauge(gaugeTarget).setOptions(gaugeOpts);
							gauge.maxValue = 100;
							gauge.animationSpeed = 32;
							gauge.set(score);
							
						}
						
						//render the customer service kpi gauge
						setTimeout(renderBusCapCustSvcGauge,600);
						
						//console.log('Bus Cap Value Streams: ' + aBusCap.valueStreamIds.length);
						
						
						//add an event listener to the value stages hetamap radio buttons
						modalHeatmap = 'cx';
						$('input:radio[name="modalVSHeatmapRadioOptions"]').change(function(){
							//get the current heatmapp type
							modalHeatmap = $(this).val();
							
							//update the heatmaps
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						
						//Initialise the valuestream list as a select2 drop down
						$('#busCapValueStreamsList').select2({theme: "bootstrap"});
						
						//initialise the value stages section
						if(aBusCap.valueStreams.length > 0) { 
							var initVS = aBusCap.valueStreams[0];
							$("#busCapValueStagesContainer").html(modalValueStagesTemplate(initVS));
							
							//set the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([aBusCap.physProcessIds, initVS.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(aBusCap.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#busCapModalPhysProcsTBody").html(physProcsRowTemplate(physProcsData)); 
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([aBusCap.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(aBusCap.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS
							}
							$("#busCapModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							//console.log('Phys Proc Count: ' + servicesForVSIds);
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(aBusCap.valueStageIds, modalHeatmap);
						}
						
						//add an event listener to the value stages dropdown list
						$('#busCapValueStreamsList').on('change', function (evt) {
							var aValStreamId = $("#busCapValueStreamsList").val();
							var aValStream = getObjectById(elementUnderReview.valueStreams, "id", aValStreamId);
							$("#busCapValueStagesContainer").html(modalValueStagesTemplate(aValStream)); 
							
							//update the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([elementUnderReview.physProcessIds, aValStream.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(elementUnderReview.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#busCapModalPhysProcsTBody").html(physProcsRowTemplate(physProcsData)); 
							//console.log('Phys Proc Count: ' + physProcsForVSIds.length);
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([elementUnderReview.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(elementUnderReview.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS
							}
							$("#busCapModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						$('.modalReviewBtn').on('click', function (evt) {
				
							var elementId = $(this).attr('eas-id');
							var elementList = $(this).attr('eas-elements');
							var element = getObjectById(viewData[elementList], "id", elementId);
							
							nextModalElement = element;
							modalHistory.push(elementUnderReview);

							$('#busCapModal').modal('hide');
						});
						
						$('.modalCloseAllBtn').on('click', function (evt) {
							//reset the modal history
							modalHistory = [];
							currentModal = null;
							nextModalElement = null;							
							elementUnderReview = null;
							
							//hide the app modal
							$('#busCapModal').modal('hide');
						});

					
					}
					
					
					<!-- function to render the content of the business process modal dialog -->
					function renderBusProcessModalContent(aBusProcess, aBusProcessIndex) {
					
						//save the given bus process
						elementUnderReview = aBusProcess;
						currentModal = $('#busProcessModal');
						
						//if required, populate the required object lists of the given bus process
						populateBusProcessLists(aBusProcess);	
						
						
						//set up the list of planning actions of the modal
						var planningActionList = [];
						var anAction, actionOption, isSelected;
						var currentAction = aBusProcess.planningAction;
						actionOption = {
							id: "NO_CHANGE",
							name: "No Change"
						};
						planningActionList.push(actionOption);
						for (var i = 0; aBusProcess.planningActions.length > i; i += 1) {
							anAction = aBusProcess.planningActions[i];
							actionOption = {
								id: anAction.id,
								name: anAction.name
							};
							planningActionList.push(actionOption);
						}
						
						//set up the object to be pasesed to handlebars
						var aBusProcessContentJSON = {
							busProcess: aBusProcess,
							planningActions: planningActionList,
							modalHistory: modalHistory
						}
						
						//render the bus process modal content
						$("#busProcessModelContent").html(busProcessModalContentTemplate(aBusProcessContentJSON));
						
						
						<!-- function to render the customer service kpi gauge -->
						function renderBusProcessCustSvcGauge() {
							var score = Math.round(aBusProcess.overallScores.kpiScore * 10);
							//set the customer service gauge
							var gaugeTarget = document.getElementById('busProcessModalCustSvcGauge');
							var gauge = new Gauge(gaugeTarget).setOptions(gaugeOpts);
							gauge.maxValue = 100;
							gauge.animationSpeed = 32;
							gauge.set(score);
							
						}
						
						//render the customer service kpi gauge
						setTimeout(renderBusProcessCustSvcGauge,600);
						
						//Initialise the planning action list as a select2 drop down
						$('#busProcessModalPlanningActionList').select2({theme: "bootstrap"});
						
						//pre-select the current planning action 
						if(currentAction == null) {
							$("#busProcessModalPlanningActionList").val("NO_CHANGE").trigger('change');
						} else {
							$('#busProcessModalPlanningActionList').val(currentAction.id).trigger('change');
							$("#busProcessModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
						}
						
						$('#busProcessModalPlanningActionList').on('select2:select', function (e) {
						    var newActionId = e.params.data.id;
						    var stratPlanBusProcessIndex = dynamicUserData.currentPlanningActions.busProcesses.indexOf(elementUnderReview);
						    var stratPlanElementIndex = dynamicUserData.currentStrategicPlan.elements.indexOf(elementUnderReview);
						    if(newActionId == 'NO_CHANGE') {
								$("#busProcessModalPlanningActionList + .select2 .select2-selection__rendered").removeClass('actionSelected');
								
								elementUnderReview.planningAction = null;
							  	elementUnderReview.hasPlan = false;
							  	elementUnderReview.selected = false;
							  	
							  	//if required, remove the bus process from the list of planning actions in scope
							  	if (stratPlanBusProcessIndex > -1) {
									dynamicUserData.currentPlanningActions.busProcesses.splice(stratPlanBusProcessIndex, 1);
								}
								//if required, remove the bus process from the current strategic plan
							  	if (stratPlanElementIndex > -1) {
									dynamicUserData.currentStrategicPlan.elements.splice(stratPlanElementIndex, 1);
								}
							} else {
								$("#busProcessModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
								
								var selectedAction  = getObjectById(viewData.planningActions, "id", newActionId);
							  	elementUnderReview.planningAction = selectedAction;
							  	elementUnderReview.hasPlan = true;
							  	
							  	//if required, add the bus process to the current strateic plan
							  	if (stratPlanBusProcessIndex &lt; 0) {
									dynamicUserData.currentPlanningActions.busProcesses.push(elementUnderReview);
								}
							}
							updateStrategicPlanPhysProcTable();
						});
						
						$('#busProcessPlanNotes').on('change', function (e) {
							elementUnderReview.planningNotes = $(this).val();
						});
						
						
						//add an event listener to the value stages hetamap radio buttons
						modalHeatmap = 'cx';
						$('input:radio[name="modalVSHeatmapRadioOptions"]').change(function(){
							//get the current heatmapp type
							modalHeatmap = $(this).val();
							
							//update the heatmaps
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						
						//Initialise the valuestream list as a select2 drop down
						$('#busProcessValueStreamsList').select2({theme: "bootstrap"});
						
						//initialise the value stages section
						if(aBusProcess.valueStreams.length > 0) { 
							var initVS = aBusProcess.valueStreams[0];
							$("#busProcessValueStagesContainer").html(modalValueStagesTemplate(initVS));
							
							//set the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([aBusProcess.physProcessIds, initVS.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(aBusProcess.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#busProcessModalPhysProcsTBody").html(physProcsOrgRowTemplate(physProcsData)); 
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([aBusProcess.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(aBusProcess.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS,
								thisModal: 'busProcessModal'
							}
							$("#busProcessModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(aBusProcess.valueStageIds, modalHeatmap);
						}
						
						//add an event listener to the value stages dropdown list
						$('#busProcessValueStreamsList').on('change', function (evt) {
							var aValStreamId = $("#busProcessValueStreamsList").val();
							var aValStream = getObjectById(elementUnderReview.valueStreams, "id", aValStreamId);
							$("#busProcessValueStagesContainer").html(modalValueStagesTemplate(aValStream)); 
							
							//update the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([elementUnderReview.physProcessIds, aValStream.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(elementUnderReview.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#busProcessModalPhysProcsTBody").html(physProcsOrgRowTemplate(physProcsData)); 
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([elementUnderReview.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(elementUnderReview.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS,
								thisModal: 'busProcessModal'
							}
							$("#busProcessModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
							
						});
						
						$('.modalReviewBtn').on('click', function (evt) {
				
							var elementId = $(this).attr('eas-id');
							var elementList = $(this).attr('eas-elements');
							var element = getObjectById(viewData[elementList], "id", elementId);
							
							nextModalElement = element;
							modalHistory.push(elementUnderReview);

							$('#busProcessModal').modal('hide');
						});
						
						$('.modalCloseAllBtn').on('click', function (evt) {
							//reset the modal history
							modalHistory = [];
							currentModal = null;
							nextModalElement = null;
							elementUnderReview = null;							
							
							//hide the app modal
							$('#busProcessModal').modal('hide');
						});

					}
					
					
					
					<!-- function to render the content of the organisation modal dialog -->
					function renderOrgModalContent(anOrg, anOrgIndex) {
					
						//save the given org
						elementUnderReview = anOrg;
						currentModal = $('#orgModal');
						
						//if required, populate the required object lists of the given org
						populateOrgLists(anOrg);	
						
						
						//set up the list of planning actions of the modal
						var planningActionList = [];
						var anAction, actionOption, isSelected;
						var currentAction = anOrg.planningAction;
						actionOption = {
							id: "NO_CHANGE",
							name: "No Change"
						};
						planningActionList.push(actionOption);
						for (var i = 0; anOrg.planningActions.length > i; i += 1) {
							anAction = anOrg.planningActions[i];
							actionOption = {
								id: anAction.id,
								name: anAction.name
							};
							planningActionList.push(actionOption);
						}
						
						//set up the object to be pasesed to handlebars
						var anOrgContentJSON = {
							org: anOrg,
							planningActions: planningActionList,
							modalHistory: modalHistory
						}
						
						//render the org modal content
						$("#orgModelContent").html(orgModalContentTemplate(anOrgContentJSON));
						
						
						<!-- function to render the customer service kpi gauge -->
						function renderOrgCustSvcGauge() {
							var score = Math.round(anOrg.overallScores.kpiScore * 10);
							//set the customer service gauge
							var gaugeTarget = document.getElementById('orgModalCustSvcGauge');
							var gauge = new Gauge(gaugeTarget).setOptions(gaugeOpts);
							gauge.maxValue = 100;
							gauge.animationSpeed = 32;
							gauge.set(score);
							
						}
						
						//render the customer service kpi gauge
						setTimeout(renderOrgCustSvcGauge,600);
						
						//Initialise the planning action list as a select2 drop down
						$('#orgModalPlanningActionList').select2({theme: "bootstrap"});
						
						//pre-select the current planning action 
						if(currentAction == null) {
							$("#orgModalPlanningActionList").val("NO_CHANGE").trigger('change');
						} else {
							$('#orgModalPlanningActionList').val(currentAction.id).trigger('change');
							$("#orgModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
						}
						
						$('#orgModalPlanningActionList').on('select2:select', function (e) {
						    var newActionId = e.params.data.id;
						    var stratPlanOrgIndex = dynamicUserData.currentPlanningActions.organisations.indexOf(elementUnderReview);
						    var stratPlanElementIndex = dynamicUserData.currentStrategicPlan.elements.indexOf(elementUnderReview);
						    if(newActionId == 'NO_CHANGE') {
								$("#orgModalPlanningActionList + .select2 .select2-selection__rendered").removeClass('actionSelected');
								
								elementUnderReview.planningAction = null;
							  	elementUnderReview.hasPlan = false;
							  	elementUnderReview.selected = false;
							  	
							  	//if required, remove the org from the current list of planning actions
							  	if (stratPlanOrgIndex > -1) {
									dynamicUserData.currentPlanningActions.organisations.splice(stratPlanOrgIndex, 1);
								}
								
								//if required, remove the org from the current strategic plan
								if (stratPlanElementIndex > -1) {
									dynamicUserData.currentStrategicPlan.elements.splice(stratPlanElementIndex, 1);
								}
							} else {
								$("#orgModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
								
								var selectedAction  = getObjectById(viewData.planningActions, "id", newActionId);
							  	elementUnderReview.planningAction = selectedAction;
							  	elementUnderReview.hasPlan = true;
							  	
							  	//if required, add the org to the current strateic plan
							  	if (stratPlanOrgIndex &lt; 0) {
									dynamicUserData.currentPlanningActions.organisations.push(elementUnderReview);
								}
							}
							updateStrategicPlanPhysProcTable();
						});
						
						$('#orgPlanNotes').on('change', function (e) {
							elementUnderReview.planningNotes = $(this).val();
						});
						
						//add an event listener to the value stages hetamap radio buttons
						modalHeatmap = 'cx';
						$('input:radio[name="modalVSHeatmapRadioOptions"]').change(function(){
							//get the current heatmapp type
							modalHeatmap = $(this).val();
							
							//update the heatmaps
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						//Initialise the valuestream list as a select2 drop down
						$('#orgValueStreamsList').select2({theme: "bootstrap"});
						
						//initialise the value stages section
						if(anOrg.valueStreams.length > 0) { 
							var initVS = anOrg.valueStreams[0];
							$("#orgValueStagesContainer").html(modalValueStagesTemplate(initVS));
							
							//set the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([anOrg.physProcessIds, initVS.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(anOrg.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#orgModalPhysProcsTBody").html(physProcsBusProcessRowTemplate(physProcsData)); 
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([anOrg.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(anOrg.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS
							}
							$("#orgModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(anOrg.valueStageIds, modalHeatmap);
						}
						
						//add an event listener to the value stages dropdown list
						$('#orgValueStreamsList').on('change', function (evt) {
							var aValStreamId = $("#orgValueStreamsList").val();
							var aValStream = getObjectById(elementUnderReview.valueStreams, "id", aValStreamId);
							$("#orgValueStagesContainer").html(modalValueStagesTemplate(aValStream)); 
							
							//update the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([elementUnderReview.physProcessIds, aValStream.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(elementUnderReview.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#orgModalPhysProcsTBody").html(physProcsBusProcessRowTemplate(physProcsData)); 
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([elementUnderReview.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(elementUnderReview.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS
							}
							$("#orgModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						
						$('.modalReviewBtn').on('click', function (evt) {
				
							var elementId = $(this).attr('eas-id');
							var elementList = $(this).attr('eas-elements');
							var element = getObjectById(viewData[elementList], "id", elementId);
							
							nextModalElement = element;
							modalHistory.push(elementUnderReview);

							$('#orgModal').modal('hide');
						});
						
						$('.modalCloseAllBtn').on('click', function (evt) {
							//reset the modal history
							modalHistory = [];
							currentModal = null;
							nextModalElement = null;
							elementUnderReview = null;							
							
							//hide the app modal
							$('#orgModal').modal('hide');
						});
					
					}
					
					
					<!-- function to render the content of the application service modal dialog -->
					function renderAppServiceModalContent(anAppService, anAppServiceIndex) {
					
						//save the given app service
						elementUnderReview = anAppService;
						currentModal = $('#appServiceModal');
						
						//if required, populate the required object lists of the given app service
						populateAppServiceLists(anAppService);	
						
						
						//set up the list of planning actions of the modal
						var planningActionList = [];
						var anAction, actionOption, isSelected;
						var currentAction = anAppService.planningAction;
						actionOption = {
							id: "NO_CHANGE",
							name: "No Change"
						};
						planningActionList.push(actionOption);
						for (var i = 0; anAppService.planningActions.length > i; i += 1) {
							anAction = anAppService.planningActions[i];
							actionOption = {
								id: anAction.id,
								name: anAction.name
							};
							planningActionList.push(actionOption);
						}
						
						//set up the object to be pasesed to handlebars
						var anAppServiceContentJSON = {
							appService: anAppService,
							planningActions: planningActionList,
							modalHistory: modalHistory
						}
						
						//render the org modal content
						$("#appServiceModelContent").html(appServiceModalContentTemplate(anAppServiceContentJSON));
						
						
						<!-- function to render the customer service kpi gauge -->
						function renderAppServiceCustSvcGauge() {
							var score = Math.round(anAppService.overallScores.kpiScore * 10);
							//set the customer service gauge
							var gaugeTarget = document.getElementById('appServiceModalCustSvcGauge');
							var gauge = new Gauge(gaugeTarget).setOptions(gaugeOpts);
							gauge.maxValue = 100;
							gauge.animationSpeed = 32;
							gauge.set(score);
						}

						//render the customer service kpi gauge
						setTimeout(renderAppServiceCustSvcGauge,600);
						
						<!-- function to render the technical health gauge -->
						function renderAppServiceTechHealthGauge() {
							var score = anAppService.techHealthScore;
							//set the technical health gauge
							var gaugeTarget = document.getElementById('appServiceModalTechHealth');
							var gauge = new Gauge(gaugeTarget).setOptions(gaugeOpts);
							gauge.maxValue = 100;
							gauge.animationSpeed = 32;
							gauge.set(score);
						}
						
						//render the technical health gauge
						setTimeout(renderAppServiceTechHealthGauge,600);
						
						//Initialise the planning action list as a select2 drop down
						$('#appServiceModalPlanningActionList').select2({theme: "bootstrap"});
						
						//pre-select the current planning action 
						if(currentAction == null) {
							$("#appServiceModalPlanningActionList").val("NO_CHANGE").trigger('change');
						} else {
							$('#appServiceModalPlanningActionList').val(currentAction.id).trigger('change');
							$("#appServiceModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
						}
						
						$('#appServiceModalPlanningActionList').on('select2:select', function (e) {
						    var newActionId = e.params.data.id;
						    var stratPlanAppServiceIndex = dynamicUserData.currentPlanningActions.appServices.indexOf(elementUnderReview);
						    var stratPlanElementIndex = dynamicUserData.currentStrategicPlan.elements.indexOf(elementUnderReview);
						    if(newActionId == 'NO_CHANGE') {
								$("#appServiceModalPlanningActionList + .select2 .select2-selection__rendered").removeClass('actionSelected');
								
								elementUnderReview.planningAction = null;
							  	elementUnderReview.hasPlan = false;
							  	elementUnderReview.selected = false;
							  	
							  	//if required, remove the app service from the current list of planning actions
							  	if (stratPlanAppServiceIndex > -1) {
									dynamicUserData.currentPlanningActions.appServices.splice(stratPlanAppServiceIndex, 1);
								}
								
								//if required, remove the app service from the current strategic plan
								if (stratPlanElementIndex > -1) {
									dynamicUserData.currentStrategicPlan.elements.splice(stratPlanElementIndex, 1);
								}
								
							} else {
								$("#appServiceModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
								
								var selectedAction  = getObjectById(viewData.planningActions, "id", newActionId);
							  	elementUnderReview.planningAction = selectedAction;
							  	elementUnderReview.hasPlan = true;
							  	
							  	//if required, add the app service to the current strateic plan
							  	if (stratPlanAppServiceIndex &lt; 0) {
									dynamicUserData.currentPlanningActions.appServices.push(elementUnderReview);
								}
							}
							updateStrategicPlanAppProRolesTable();
						});
						
						$('#appServicePlanNotes').on('change', function (e) {
							elementUnderReview.planningNotes = $(this).val();
						});
						
						
						//add an event listener to the value stages hetamap radio buttons
						modalHeatmap = 'cx';
						$('input:radio[name="modalVSHeatmapRadioOptions"]').change(function(){
							//get the current heatmapp type
							modalHeatmap = $(this).val();
							
							//update the heatmaps
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						
						//Initialise the valuestream list as a select2 drop down
						$('#appServiceValueStreamsList').select2({theme: "bootstrap"});
						
						//initialise the value stages section
						if(anAppService.valueStreams.length > 0) { 
							var initVS = anAppService.valueStreams[0];
							$("#appServiceValueStagesContainer").html(modalValueStagesTemplate(initVS));
							
							//set the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([anAppService.physProcessIds, initVS.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(anAppService.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#appServiceModalPhysProcsTBody").html(physProcsRowTemplate(physProcsData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(anAppService.valueStageIds, modalHeatmap);
							
							<!--//set the list of relevant apps for the selectd Value Stream
							var appProRolesForVSIds = getArrayIntersect([anAppService.appProRoleIds, initVS.appProRoleIds]); 
							var appProRolesForVS = getObjectsByIds(anAppService.appProRoles, "id", appProRolesForVSIds);
							var appsForVSIds = getObjectIds(appProRolesForVS, "appId");
							var appsForVS = getObjectsByIds(anAppService.applications, "id", appsForVSIds);-->
							
							
						}
						
						//add an event listener to the value stages dropdown list
						$('#appServiceValueStreamsList').on('change', function (evt) {
							var aValStreamId = $("#appServiceValueStreamsList").val();
							var aValStream = getObjectById(elementUnderReview.valueStreams, "id", aValStreamId);
							$("#appServiceValueStagesContainer").html(modalValueStagesTemplate(aValStream)); 
							
							//set the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([elementUnderReview.physProcessIds, initVS.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(elementUnderReview.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#appServiceModalPhysProcsTBody").html(physProcsRowTemplate(physProcsData)); 
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);

						});
						
						
						
						//set the list of apps that implement the app service
						var appData = {
							applications: anAppService.applications
						}
						$("#appServiceModalServiceTBody").html(appRowTemplate(appData)); 
						
						
						$('.modalReviewBtn').on('click', function (evt) {
				
							var elementId = $(this).attr('eas-id');
							var elementList = $(this).attr('eas-elements');
							var element = getObjectById(viewData[elementList], "id", elementId);
							
							nextModalElement = element;
							modalHistory.push(elementUnderReview);

							$('#appServiceModal').modal('hide');
						});
						
						
						$('.modalCloseAllBtn').on('click', function (evt) {
							//reset the modal history
							modalHistory = [];
							currentModal = null;
							nextModalElement = null;
							elementUnderReview = null;							
							
							//hide the app modal
							$('#appServiceModal').modal('hide');
						});
					
					}
					
					
					
					<!-- function to render the content of the applications modal dialog -->
					function renderAppModalContent(anApp, appIndex) {
					
						elementUnderReview = anApp;
						appUnderReviewIndex = appIndex;
						currentModal = $('#appModal');
						
						//if required, populate the required object lists of the given app
						populateAppLists(anApp);	
						
						
						//set up the list of planning actions of the modal
						var planningActionList = [];
						var anAction, actionOption, isSelected;
						var currentAction = anApp.planningAction;
						actionOption = {
							id: "NO_CHANGE",
							name: "No Change"
						};
						planningActionList.push(actionOption);
						for (var i = 0; anApp.planningActions.length > i; i += 1) {
							anAction = anApp.planningActions[i];
							actionOption = {
								id: anAction.id,
								name: anAction.name
							};
							planningActionList.push(actionOption);
						}
						
						//set up the object to be pasesed to handlebars
						appContentJSON = {
							application: anApp,
							planningActions: planningActionList,
							modalHistory: modalHistory
						}
						
						//render the app modal content
						$("#appModelContent").html(appModalContentTemplate(appContentJSON));
						
						<!-- function to render the technical health gauge -->
						function renderAppTechHealthGauge() {
							var score = anApp.techHealthScore;
							//set the technical health gauge
							var gaugeTarget = document.getElementById('appModalTechHealth');
							var gauge = new Gauge(gaugeTarget).setOptions(gaugeOpts);
							gauge.maxValue = 100;
							gauge.animationSpeed = 32;
							gauge.set(score);
							//console.log('Gauge canvas: ' + gaugeTarget);
						}
						
						//render the technical health gauge
						setTimeout(renderAppTechHealthGauge,600);
						
						
						//Initialise the planning action list as a select2 drop down
						$('#appModalPlanningActionList').select2({theme: "bootstrap"});
						
						//pre-select the current planning action 
						if(currentAction == null) {
							$("#appModalPlanningActionList").val("NO_CHANGE").trigger('change');
						} else {
							$('#appModalPlanningActionList').val(currentAction.id).trigger('change');
							$("#appModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
						}
						
						$('#appModalPlanningActionList').on('select2:select', function (e) {
						    var newActionId = e.params.data.id;
						    var stratPlanAppIndex = dynamicUserData.currentPlanningActions.applications.indexOf(elementUnderReview);
						    var stratPlanElementIndex = dynamicUserData.currentStrategicPlan.elements.indexOf(elementUnderReview);
						    if(newActionId == 'NO_CHANGE') {
								$("#appModalPlanningActionList + .select2 .select2-selection__rendered").removeClass('actionSelected');
								
								elementUnderReview.planningAction = null;
							  	elementUnderReview.hasPlan = false;
							  	elementUnderReview.selected = false;
							  	
							  	//if required, remove the app from the current list of planning actions
							  	if (stratPlanAppIndex > -1) {
									dynamicUserData.currentPlanningActions.applications.splice(stratPlanAppIndex, 1);
								}
								
								//if required, remove the app from the current strategic plan
								if (stratPlanElementIndex > -1) {
									dynamicUserData.currentStrategicPlan.elements.splice(stratPlanElementIndex, 1);
								}
							} else {
								$("#appModalPlanningActionList + .select2 .select2-selection__rendered").addClass('actionSelected');
								
								var selectedAction  = getObjectById(viewData.planningActions, "id", newActionId);
							  	elementUnderReview.planningAction = selectedAction;
							  	elementUnderReview.hasPlan = true;
							  	
							  	//if required, add the app to the current strateic plan
							  	if (stratPlanAppIndex &lt; 0) {
									dynamicUserData.currentPlanningActions.applications.push(elementUnderReview);
								}
							}
							updateStrategicPlanAppProRolesTable();
						});
								
						$('#appPlanNotes').on('change', function (e) {
							elementUnderReview.planningNotes = $(this).val();
						});
						
						//add an event listener to the value stages hetamap radio buttons
						modalHeatmap = 'cx';
						$('input:radio[name="modalVSHeatmapRadioOptions"]').change(function(){
							//get the current heatmapp type
							modalHeatmap = $(this).val();
							
							//update the heatmaps
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						
						//Initialise the valuestream list as a select2 drop down
						$('#appValueStreamsList').select2({theme: "bootstrap"});
						
						//initialise the value stages section
						if(anApp.valueStreams.length > 0) { 
							var initVS = anApp.valueStreams[0];
							$("#appValueStagesContainer").html(modalValueStagesTemplate(initVS));
							
							//set the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([anApp.physProcessIds, initVS.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(anApp.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#appModalPhysProcsTBody").html(physProcsRowTemplate(physProcsData)); 
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([anApp.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(anApp.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS
							}
							$("#appModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							//console.log('Phys Proc Count: ' + servicesForVSIds);
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						}
						
						//add an event listener to the value stages dropdown list
						$('#appValueStreamsList').on('change', function (evt) {
							var aValStreamId = $("#appValueStreamsList").val();
							var aValStream = getObjectById(elementUnderReview.valueStreams, "id", aValStreamId);
							$("#appValueStagesContainer").html(modalValueStagesTemplate(aValStream)); 
							
							//update the list of relevant physical processes for the selectd Value Stream
							var physProcsForVSIds = getArrayIntersect([elementUnderReview.physProcessIds, aValStream.physProcessIds]); 
							var physProcsForVS = getObjectsByIds(elementUnderReview.physProcesses, "id", physProcsForVSIds);
							var physProcsData = {
								physProcs: physProcsForVS
							}
							$("#appModalPhysProcsTBody").html(physProcsRowTemplate(physProcsData)); 
							//console.log('Phys Proc Count: ' + physProcsForVSIds.length);
							
							//set the list of relevant app services for the selectd Value Stream
							var servicesForVSIds = getArrayIntersect([elementUnderReview.appProRoleIds, initVS.appProRoleIds]); 
							var servicesForVS = getObjectsByIds(elementUnderReview.services, "id", servicesForVSIds);
							var serviceData = {
								appServices: servicesForVS
							}
							$("#appModalServiceTBody").html(appServiceRowTemplate(serviceData)); 
							//console.log('Phys Proc Count: ' + servicesForVSIds);
							
							//update the styling of the value stages
							refreshModalValueStageChevronStyles(elementUnderReview.valueStageIds, modalHeatmap);
						});
						
						$('.modalReviewBtn').on('click', function (evt) {
				
							var elementId = $(this).attr('eas-id');
							var elementList = $(this).attr('eas-elements');
							var element = getObjectById(viewData[elementList], "id", elementId);
							
							nextModalElement = element;
							modalHistory.push(elementUnderReview);

							$('#appModal').modal('hide');
						});
						
						
						$('.modalCloseAllBtn').on('click', function (evt) {
							//reset the modal history
							modalHistory = [];
							currentModal = null;
							nextModalElement = null;							
							
							//hide the app modal
							$('#appModal').modal('hide');
						});
					
					}
					
					<!-- END MODAL DIALOG FUNCTIONS -->
					
					
					
					<!-- START STRATEGIC PLANS TABLE FUNCTIONS -->
					<!-- function to update the contents of the Strategic Plan Objectives table -->
					function updateStrategicPlanObjsTable() {
						var inScopeObjectives = tempUserData.inScopeObjectives;
						var currentStratPlanObjs = dynamicUserData.currentStrategicPlan.objectives;
						
						stratPlanObjsTable.clear();
					    stratPlanObjsTable.rows.add(inScopeObjectives);
					    
					    //set the checkboxes for each row in the table
					    var anObjId, anObj;
    					for (var k = 0; stratPlanObjsTable.rows().data().length > k; k += 1) {
    						anObjId = stratPlanObjsTable.cell(k, 0).data();
    						anObj = getObjectById(viewData.objectives, "id", anObjId);
	    					if(currentStratPlanObjs.indexOf(anObj) >= 0) {
			                  stratPlanObjsTable.cell(k, 0).checkboxes.select();
			               	}
		               	;}			    
					    stratPlanObjsTable.draw();	
					}
					
					
					<!-- function to draw the strategic plan objectives table -->
					function drawStrategicPlanObjsTable() {
						if(stratPlanObjsTable == null) {

							// Setup - add a text input to each footer cell
						    $('#stratPlanObjsTable tfoot th').each( function(index) {
						    if(index > 0) {
						        	var title = $(this).text();
						        	$(this).html( '&lt;input class="stratPlanObjsSearch" type="text" placeholder="Search '+title+'" /&gt;' );
						    }
						    } );
							
							stratPlanObjsTable = $('#stratPlanObjsTable').DataTable({
								scrollY: "150px",
								scrollCollapse: true,
								paging: false,
								info: false,
								sort: true,
								responsive: false,
								order: [[1, 'asc']],
								data: tempUserData.inScopeObjectives,
								columns: [
								    {
								    	"width": "5%",
								    	"orderable": false,
								    	"data": "id",
								    },
								    {
								    	"width": "65%",
								    	"data": "link"
								    },
								    {
								    	"width": "30%",
								    	"data": "targetDate"
								    }
								 ],				 
								 columnDefs: [
							         {
							            'targets': 0,
							            'checkboxes': {
							               'selectRow': false,
							               'selectCallback': function(nodes, selected){
							                  	// get list of selected objectives
							                  	var selectedObjIds = stratPlanObjsTable.column(0).checkboxes.selected();
							                  	//refresh the list of supported objectives for the current plan
							                  	dynamicUserData.currentStrategicPlan.objectives = getObjectsByIds(viewData.objectives, "id", selectedObjIds);				                  	
							               }
							            }
							         }
							      ],
								dom: 'frtip'
							});
							
												
							// Apply the search
						    stratPlanObjsTable.columns().every( function () {
						        var that = this;
						 
						        $( '.stratPlanObjsSearch', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						    
						    stratPlanObjsTable.columns.adjust();
						    
						    $(window).resize( function () {
						        stratPlanObjsTable.columns.adjust();
						    });
						}
					}
					
					
					<!-- function to save the list of elements against the given strategic plan -->
					function clonePlanElement(anElement) {
						var aClone = {
							id: anElement.id,
							name: anElement.name,
							description: anElement.description,
							link: anElement.link,
							type: anElement.type,
							planningAction: anElement.planningAction,
							planningNotes: anElement.planningNotes
						}
						return aClone;
					}
					
					
					<!-- function to reset the planning properties of a given element -->
					function resetPlanElement(anElement) {
						anElement.selected = false;
						anElement.planningAction = null;
						anElement.planningNotes = "";
						anElement.hasPlan = false;
					}
					
					
					<!-- function to save the list of elements against the given strategic plan -->
					function saveElementsToPlan(aPlan) {
						var planElements = aPlan.elements;
						var anElement, elementClone;
						for (var i = 0; planElements.length > i; i += 1) {
							//clone the element
							anElement = planElements[i];
							elementClone = clonePlanElement(anElement);
							
							//add the element clone to the type specific list in the plan
							aPlan[anElement.type.list].push(elementClone);
							
							//add the cloned element clone to the complete list of elements in the plan
							aPlan.changedElements.push(elementClone);
							
							//reset the origibal element
							resetPlanElement(anElement);
						}
					}
					
					
					
					<!-- function to render the content for the detail of a strategic plan -->
					function showStrategicPlanTableDetail ( d ) {
					    // `d` is the original data object for the row
						return stratPlanDetailsTemplate(d); 
					}
					
					<!-- function to update the contents of the Strategic Plans table -->
					function updateStrategicPlansTable() {
						if(strategicPlanTable != null) {
							strategicPlanTable.clear();
						    strategicPlanTable.rows.add(dynamicUserData.strategicPlans);
						    strategicPlanTable.draw();
					    }
					}
					
					
					<!-- function to draw the Strategic Plans table -->
					function drawStrategicPlansTable() {
						
						if(strategicPlanTable == null) {
							
							<!-- Draw the Strategic Plan Table -->
							// Setup - add a text input to each footer cell
						    $('#dt_stratPlanList tfoot th').each( function () {
						        	var title = $(this).text();
						        	$(this).html( '&lt;input class="stratPlansSearch" type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							strategicPlanTable = $('#dt_stratPlanList').DataTable({
								scrollY: "300px",
								scrollCollapse: true,
								paging: false,
								info: false,
								sort: true,
								responsive: false,
								data: dynamicUserData.strategicPlans,
								columns: [
									{
						                "className": 'details-control',
						                "orderable": false,
						                "data": null,
						                "defaultContent": '',
						                "width": "5%"
						            },	
								    { 
								    	"data" : "name",
								    	"width": "25%" 
								    },
								    {
								    	"data" : "description",
								    	"width": "40%" 
								    },
								    {
								    	"data" : "objectives",
								    	"width": "30%",
								    	"render": function(d){
							                if(d !== null){
							                    var objList = "<ul>";
							                    $.each(d, function(k, v){
							                        objList += "<li>" + v.link + "</li>";
							                    });
							                    return objList + "</ul>";
							                }else{
							                    return "";
							                }
							            }
								    }
								 ],
								 "order": [[1, 'asc']],
								  dom: 'frtip'
							});
							
												
							// Apply the search
						    strategicPlanTable.columns().every( function () {
						        var that = this;
						 
						        $( '.stratPlansSearch', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						    
						    
						    strategicPlanTable.columns.adjust();
						    
						    $(window).resize( function () {
						        strategicPlanTable.columns.adjust();
						    });
						} else {
							updateStrategicPlansTable();
						}
					}
					
					<!-- END STRATEGIC PLANS TABLE FUNCTIONS -->
					
					
					<!-- START STRATEGIC PLAN DEFINITION FUNCTIONS -->
					<!-- function to update the given list of in scope elements -->
					function updateStratPlanRelevantObjectivesList() {
						var elementIdArrays = [];
						var anElement;
						
						var elementList = dynamicUserData.currentStrategicPlan.elements;
						for (var i = 0; elementList.length > i; i += 1) {
							anElement = elementList[i];
							if(anElement.objectiveIds.length > 0) {
								elementIdArrays.push(anElement.objectiveIds);
							}
						}
						var inScopeObjectiveIDs = getUniqueArrayVals(elementIdArrays);
						console.log('Element Count: ' + elementList.length);
						
						var newObjList = getObjectsByIds(viewData.objectives, "id", inScopeObjectiveIDs);

						//merge the list of objectives in scope for selected elements with those already selected for the current the strategic plan
						tempUserData.inScopeObjectives = getUniqueArrayVals([newObjList, dynamicUserData.currentStrategicPlan.objectives]);
					}
					
					
					<!-- function to add an element to the current strategic plan -->
					function addStratPlanElement(anElement) {
						var elementIndex = dynamicUserData.currentStrategicPlan.elements.indexOf(anElement);
						if (elementIndex > -1) {
							dynamicUserData.currentStrategicPlan.elements.splice(elementIndex, 1);
							anElement.selected = false;
						} else {
							dynamicUserData.currentStrategicPlan.elements.push(anElement);
							anElement.selected = true;
						}
						//update the list if objectives in scope for the selected elements
						updateStratPlanRelevantObjectivesList();
						
						updateStrategicPlanObjsTable();
						updateStrategicPlanElementsTable();
					}
					
					
					<!-- function to rmeove an element to the current strategic plan -->
					function removeStratPlanElement(anElement) {
						var elementIndex = dynamicUserData.currentStrategicPlan.elements.indexOf(anElement);
						if (elementIndex > -1) {
							dynamicUserData.currentStrategicPlan.elements.splice(elementIndex, 1);
							anElement.selected = false;
						}
						updateStrategicPlanElementsTable();
					}
					
					
					<!-- function to update the contents of the Strategic Plan Physical Processes table -->
					function updateStrategicPlanElementsTable() {
						if(stratPlanElementsTable != null) {
							stratPlanElementsTable.clear();
						    stratPlanElementsTable.rows.add(dynamicUserData.currentStrategicPlan.elements);
				    
						    stratPlanElementsTable.draw();	
					    }
					}
					
					
					<!-- function to draw the strategic plan physical processes table -->
					function drawStrategicPlanElementsTable() {
						if(stratPlanElementsTable == null) {
							
							// Setup - add a text input to each footer cell
						    $('#stratPlanElementsTable tfoot th').each( function() {
						        	var title = $(this).text();
						        	$(this).html( '&lt;input class="stratPlanElementsSearch" type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							//create the table
							stratPlanElementsTable = $('#stratPlanElementsTable').DataTable({
								scrollY: "300px",
								scrollCollapse: true,
								paging: false,
								info: false,
								sort: true,
								responsive: false,
								data: dynamicUserData.currentStrategicPlan.elements,
								columns: [	
								    { 
								    	"data" : "type.label",
								    	"width": "35%" 
								    },
								    { 
								    	"data" : "link",
								    	"width": "40%" 
								    },
								    {
								    	"data" : "id",
								    	"width": "25%",
								    	"render": function(d, type, row, meta){
								    		var elementList = viewData[row.type.list];
							                if(d !== null){              
							                    	return renderPlanningActionButton(elementList, d);
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
						    stratPlanElementsTable.columns().every( function () {
						        var that = this;
						 
						        $( '.stratPlanElementsSearch', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						    
						    stratPlanElementsTable.columns.adjust();
						    
						    $(window).resize( function () {
						        stratPlanElementsTable.columns.adjust();
						    });
						}
					}
					<!-- END STRATEGIC PLAN DEFINITION FUNCTIONS -->
					
					
					<!-- START GANNT CHART FUNCTIONS -->
					<!-- utility function to format a JS date object to apprpriate format for gantt chart -->
					function formatGanttDate(aDate) {
						var dd = aDate.getDate();
						var mm = aDate.getMonth()+1; //January is 0!
						
						var yyyy = aDate.getFullYear();
						if(dd&lt;10){
						    dd='0'+dd;
						} 
						if(mm&lt;10){
						    mm='0'+mm;
						} 
						var formattedDate = dd + '-' + mm + '-' + yyyy;
						return formattedDate;
					}
					
					
					<!-- function to update a strategic plan usuing the gantt chart -->
					function updateGanntStrategicPlan(ganttPlan) {
						var thisStratPlan = getObjectById(dynamicUserData.strategicPlans, "id", ganttPlan.id);
						if(thisStratPlan != null) {
							var planEndDate = gantt.calculateEndDate(ganttPlan);
							thisStratPlan.name = ganttPlan.text;
							thisStratPlan.startDate = ganttPlan.start_date;
							thisStratPlan.endDate = planEndDate;
							formatStratPlanDates(thisStratPlan);
							formatExcelStratPlanDates(thisStratPlan);
							
							if(thisStratPlan.id == selectedRoadmapPlanId) {
								$("#ganttStratPlanContainer").html(ganttStratPlanTemplate(thisStratPlan));
							}
						}
					}
					
					<!-- function to initialise the roadmpa gantt chart -->
					function initRoadmapGantt() {
						if(roadmapPlans == null) {
							var aStratPlan, roadmapData;
							roadmapPlans = {
								data:[],
								links: []
							};
							
							
							for (var i = 0; dynamicUserData.strategicPlans.length > i; i += 1) {
								aStratPlan = dynamicUserData.strategicPlans[i];
								roadmapData = {
									id: aStratPlan.id,
									text: aStratPlan.name,
									description: aStratPlan.description,
									start_date: aStratPlan.startDate,
									end_date: aStratPlan.endDate
								};
								roadmapPlans.data.push(roadmapData);
							}
							
							gantt.config.scale_unit = "year";
							gantt.config.subscales = [
							    {unit:"month", step:1, date:"%F"}
							];
							gantt.config.step = 1;
							gantt.config.time_step = 7*24*60;
							gantt.config.min_duration = 7*24*60*60*1000;  // 1 week minimum duration
							gantt.config.date_scale = "%Y";
							gantt.config.fit_tasks = true;
							gantt.config.start_date = new Date(2019, 01, 01);
							gantt.config.end_date = new Date(2025, 12, 31);
							
							var textEditor = {type: "text", map_to: "text"};
							gantt.config.columns=[
							    {name:"text", label:"Plan Name",  tree:true, width:'*', editor: textEditor }
							];
							gantt.config.autoscroll = true;
							gantt.config.lightbox.sections=[
								{name:"template", height:16, type:"template", map_to:"my_template"}, 
							    {name:"description", height:60, map_to:"description", type:"textarea"},
							    {name:"time", height:72, type:"duration", map_to:"auto", focus:true}
							];
							gantt.locale.labels.section_template = "";
							gantt.attachEvent("onBeforeLightbox", function(id) {
							    var task = gantt.getTask(id);
							    task.my_template = '<span class="plan-title"><strong>Plan Name:</strong>&#160;' + task.text + '</span>';
							    return true;
							});
							//event listener to update Strategic PLan panel
							gantt.attachEvent("onTaskClick", function(id, e) {
								//highlight the selected plan
							    var oldId = selectedRoadmapPlanId;
							    selectedRoadmapPlanId = id;
							    if(oldId != null) {
							    	gantt.refreshTask(oldId);
							    }
							    gantt.refreshTask(id);
							    
							    //update the Strategic Plan Details panel
							    var thisStratPlan = getObjectById(dynamicUserData.strategicPlans, "id", selectedRoadmapPlanId);
								if(thisStratPlan != null) {
									$("#ganttStratPlanContainer").html(ganttStratPlanTemplate(thisStratPlan));
								}    
							});
							
							//disable double clicking on a plan
							<!--gantt.attachEvent("onTaskDblClick", function(id, e) {
							    return false;
							});-->
							<!--//event listener for when a plan is dragged
							gantt.attachEvent("onAfterTaskDrag", function(id, mode, e){
							    console.log("You've just finished dragging an item with id="+id);
							});-->
							//
							
							gantt.attachEvent("onLinkDblClick", function(id,e){
							    return true;
							});
							
							//event listener when a strategic plan is updated
							gantt.attachEvent("onAfterTaskUpdate", function(id,item){
								updateGanntStrategicPlan(item);
								<!--var taskEndDate = gantt.calculateEndDate(item);
							    console.log("You've just finished updating an item with end date = "+ taskEndDate);-->
							});	
							
							//event listener when a link is created between strategic plans
							gantt.attachEvent("onAfterLinkAdd", function(id,item){
							    //record the link
							    roadmapPlans.links.push(item);
							    console.log('Linked plan count after add: ' + roadmapPlans.links.length);
							    <!--var linkedPlans = getObjectsByIds(dynamicUserData.strategicPlans, "id", [item.source, item.target]);
							    if(linkedPlans.length == 2) {
							    	console.log('Linked ' + linkedPlans[1].name + ' depends on ' + linkedPlans[0].name);
							    } else {
							    	console.log('Linked plans not found');
							    }-->
							});
							
							//event listener when a link between strategic plans is deleted
							gantt.attachEvent("onAfterLinkDelete", function(id,item){
							    var linkIndex = roadmapPlans.links.indexOf(item);
							    if (linkIndex > -1) {
							    	roadmapPlans.links.splice(linkIndex, 1);
							    }
							    console.log('Linked plan count after delete: ' + roadmapPlans.links.length);
							});
							
							gantt.templates.task_class = function(start,end,task){
							    if(task.id == selectedRoadmapPlanId){
							        return "selected-gantt-plan";
							    } else{
							        return "";
							    }
							};
							 
					        gantt.init("roadmap-gantt");
							gantt.parse(roadmapPlans);
						} else {
							updateRoadmapGantt();
						}
					}
					
					<!-- function to update teh contents of the roadmpa gantt chart -->
					function updateRoadmapGantt() {
						if(roadmapPlans != null) {
							for (var i = 0; dynamicUserData.strategicPlans.length > i; i += 1) {
								aStratPlan = dynamicUserData.strategicPlans[i];
								roadmapData = {
									id: aStratPlan.id,
									text: aStratPlan.name,
									description: aStratPlan.description,
									start_date: aStratPlan.startDate,
									end_date: aStratPlan.endDate
								};
								roadmapPlans.data.push(roadmapData);
							}
							
							gantt.parse(roadmapPlans);
						}
					}
					
					<!-- END GANNT CHART FUNCTIONS -->
					
					<!-- START EXCEL EXPORT FUNCTIONS -->
					<!-- function to initialise the roadmap excel export -->
					function initRoadmapExcel() {
						Handlebars.registerHelper("add", function(index, value, options) {
							return parseInt(index) + parseInt(value);
						});
						
						let roadmapExcelJSONFragment = $("#roadmap-excel-json-template").html();
						roadmapExcelJSONTemplate = Handlebars.compile(roadmapExcelJSONFragment);;
					}
					
					//function to create the list of strategic plan dependecies
					function createAppDependencies() {
						var aLink, aDep, linkedPlans;
						var deps = [];
						for (var i = 0; roadmapPlans.links.length > i; i += 1) {
							aLink = roadmapPlans.links[i];
							linkedPlans = getObjectsByIds(dynamicUserData.strategicPlans, "id", [aLink.source, aLink.target]);
							if(linkedPlans.length == 2) {
								aDep = {
									plan: linkedPlans[1].name,
									dependsOnPlan: linkedPlans[0].name
								};
								deps.push(aDep);
							}
						}
						return deps;
					}
					
					//function to calculate the total rows for a given roadmap data set
					function calcExcelRowCounts(dataSet, property) {
						var rowCount = 0;
						var dataElement;
						for (var i = 0; dataSet.length > i; i += 1) {
							dataElement = dataSet[i];
							if(dataElement != null) {
								rowCount = rowCount + dataElement[property].length;
							}
						}
						return rowCount;
					}
					
					function exportRoadmapExcel() {

						//set the list of strategic plan dependencies
						dynamicUserData.planDeps = createAppDependencies();
					
						let excelJSONString = roadmapExcelJSONTemplate(dynamicUserData);
						let excelJSON = JSON.parse(excelJSONString);
						
						//Initialise an array of Excel worksheets with the Roadmap and Strategic Plans worksheets 
						let thisExcelSheets = [excelJSON.roadmap, excelJSON.strategicPlans];
						
						//Add Strategic Plan to Objectives mapping
						let rowIdx = 8;
						dynamicUserData.strategicPlans?.forEach(plan => {
							plan.objectives?.forEach(obj => {
								excelJSON.stratPlanObjectives.data.push({
									"row": rowIdx,
									"roadmap": plan.name,
									"name": obj.name	
								});
								rowIdx++;
							});
						});
						thisExcelSheets.push(excelJSON.stratPlanObjectives);
						
						//Add Strategic Plan Dependencies
						rowIdx = 8;
						dynamicUserData.planDeps?.forEach(dep => {
							excelJSON.stratPlanDependencies.data.push({
								"row": rowIdx,
								"StrategicPlan": dep.plan,
								"DependsOnPlan": dep.dependsOnPlan	
							});
							rowIdx++;
						});
						thisExcelSheets.push(excelJSON.stratPlanDependencies);
						
						//Add Strategic Plan Application Changes
						rowIdx = 8;
						dynamicUserData.strategicPlans?.forEach(plan => {
							plan.applications?.forEach(app => {
								excelJSON.plannedAppChanges.data.push({
									"row": rowIdx,
									"StrategicPlan": plan.name,
									"ImpactedApplication": app.name,
									"PlannedChange": app.planningAction.name,
									"ChangeRationale": app.planningNotes
								});
								rowIdx++;
							});
						});
						thisExcelSheets.push(excelJSON.plannedAppChanges);
						
						//Add Strategic Plan Application Service Changes
						rowIdx = 8;
						dynamicUserData.strategicPlans?.forEach(plan => {
							plan.appServices?.forEach(appSvc => {
								excelJSON.plannedAppServiceChanges.data.push({
									"row": rowIdx,
									"StrategicPlan": plan.name,
									"ImpactedApplicationService": appSvc.name,
									"PlannedChange": appSvc.planningAction.name,
									"ChangeRationale": appSvc.planningNotes
								});
								rowIdx++;
							});
						});
						thisExcelSheets.push(excelJSON.plannedAppServiceChanges);
						
						//Add Strategic Plan Business Process Changes
						rowIdx = 8;
						dynamicUserData.strategicPlans?.forEach(plan => {
							plan.busProcesses?.forEach(busProc => {
								excelJSON.plannedBusProcChanges.data.push({
									"row": rowIdx,
									"StrategicPlan": plan.name,
									"ImpactedBusinessProcess": busProc.name,
									"PlannedChange": busProc.planningAction.name,
									"ChangeRationale": busProc.planningNotes
								});
								rowIdx++;
							});
						});
						thisExcelSheets.push(excelJSON.plannedBusProcChanges);
						
						//Add Strategic Plan Organisation Changes
						rowIdx = 8;
						dynamicUserData.strategicPlans?.forEach(plan => {
							plan.organisations?.forEach(org => {
								excelJSON.plannedOrgChanges.data.push({
									"row": rowIdx,
									"StrategicPlan": plan.name,
									"ImpactedOrganisation": org.name,
									"PlannedChange": org.planningAction.name,
									"ChangeRationale": org.planningNotes
								});
								rowIdx++;
							});
						});
						thisExcelSheets.push(excelJSON.plannedOrgChanges);
						
						console.log('Roadmap Data', dynamicUserData);
						console.log('Excel JSON', excelJSON);
						
						<!-- if lookups then set to true -->
						let excelFile={"sheets":thisExcelSheets, "lookups": "false"};
						<xsl:call-template name="RenderOfficetUtilityFunctions"/>

						setExcel(excelFile, "Strategic_Roadmap_Export");

					}
					
					<!-- END EXCEL EXPORT FUNCTIONS -->
					
					
					//function to show the next modal when another modal is hidden
					function showNextModal(elementUnderReview) {
						console.log('Next Element: ' + nextModalElement);
						elementUnderReview = null;	
						if(nextModalElement != null) {
							var elementModal = nextModalElement.editorId;
							$('#' + elementModal).modal('show');
						} else if(modalHistory.length > 0) {
							nextModalElement = modalHistory.pop();
							var elementModal = nextModalElement.editorId;
							$('#' + elementModal).modal('show');	
						}
					}
					
					var promise_loadViewerAPIData = function (apiDataSetURL) {
						return new Promise(function (resolve, reject)
							{
							if (apiDataSetURL != null)
							{
							var xmlhttp = new XMLHttpRequest();
							xmlhttp.onreadystatechange = function ()
							{
							if (this.readyState == 4 &amp;&amp; this.status == 200)
							{
							
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
							}
							};
							xmlhttp.onerror = function ()
							{
							reject(false);
							};
							
							xmlhttp.open("GET", apiDataSetURL, true);
							xmlhttp.send();
							} else
							{
							reject(false);
							}
						});
					}
					
					
					//FUNCTION TO INITIALISE THE PAGE
					$(document).ready(function(){
						<!-- Excel handlebars functions -->
						<xsl:call-template name="excelHandlebarsJS"/>
					
						promise_loadViewerAPIData(analysisDatasetAPIUrl)
						.then(function (response){ 
						
							viewData = response;
							initGoals();
							
							<!-- ROADMAP DEFINITION SECTION -->
							<!-- Initialise the roadmap object -->
							dynamicUserData.roadmap = newRoadmap();
											
							var dropdownFragment   = $("#dropdown-list-template").html();
							dropdownTemplate = Handlebars.compile(dropdownFragment);
						
						
							<!-- add event listeneers to the name and description text boxes for the Roadmap -->
							$('#roadmapNameInput').on('change', function (evt) {
							  var roadmapName = $(this).val();
							  $('#roadmapNameLabel').text(roadmapName);
							  $('#roadmapNameTitle').text(' - ' + roadmapName); 
							  if(roadmapName.length > 0) {
							  	dynamicUserData.roadmap.name = roadmapName;
							  } else {
							  	dynamicUserData.roadmap.name = null;
							  }
							});
							
							$('#roadmapDescInput').on('change', function (evt) {
							  var roadmapDesc = $(this).val();
							  $('#roadmapDescriptionLabel').text(roadmapDesc);
							  dynamicUserData.roadmap.description = roadmapDesc;
							});
						
							<!-- START STRATEGIC PLAN DEFINITION SECTIONS -->
							<!-- Initialise strategic goals handlebars template -->
							
	
						
							<!-- START STRATEGIC PLAN DEFINITION SECTIONS -->
							<!-- Initialise strategic goals handlebars template -->
							
							var goalFragment   = $("#strategic-goal-template").html();
							goalTemplate = Handlebars.compile(goalFragment);
							$("#goalsContainer").html(goalTemplate(viewData));
							updateGoalStyles();
							
							<!-- Initialise value streams -->
							initValueStreams();
						
							var valueStreamsListFragment   = $("#value-streams-list-template").html();
							var valueStreamsListTemplate = Handlebars.compile(valueStreamsListFragment);
							
							$('#valueStreamsList').select2({
							    placeholder: "Select Value Stream",
							    theme: "bootstrap"
							});
												
							$("#valueStreamsList").html(valueStreamsListTemplate(viewData));
																
							$('#valueStreamsList').on('change', function (evt) {
							  var thisValueStreamId = $(this).select2("val");
							  if(thisValueStreamId != null) {
							  	setCurrentValueStream(thisValueStreamId);
							  	updateBusCapHeatmaps();
							  }  
							});
							
							<!-- Initialise value stages handlebars templates -->
							var valueStagesFragment   = $("#value-stage-template").html();
							valueStagesTemplate = Handlebars.compile(valueStagesFragment);
							
							var modalValueStagesFragment   = $("#modal-value-stage-template").html();
							modalValueStagesTemplate = Handlebars.compile(modalValueStagesFragment);
							
							<!-- add an event listener to the the value stream heatmap radio buttons -->
							setValueStageStyles(viewData.valueStages);
							$('input:radio[name="vsHeatmapRadioOptions"]').change(function(){
								//set the current heatmapp type
								tempUserData.currentHeatmap = $(this).val();
								
								//update the heatmaps
								refreshValueStageChevronStyles();
								updateBusCapHeatmaps();
							});
	
						
							<!-- Initialise business capability model -->
							//initialise the BCM model
							var bcmFragment   = $("#bcm-template").html();
							var bcmTemplate = Handlebars.compile(bcmFragment);
							$("#bcmContainer").html(bcmTemplate(viewData.bcmData));
							
							$('.busRefModel-blob').on('click', function (evt) {
								var thisBusCapBlob = $(this);
								var thisBusCapId = $(this).attr('id');							
								var thisBusCap = getObjectById(viewData.busCaps, 'id', thisBusCapId);
								
								//remove the bus cap from, or add to the selected list
								var busCapIndex = tempUserData.selectedBusCapIds.indexOf(thisBusCapId);
								if (busCapIndex > -1) {
									tempUserData.selectedBusCapIds.splice(busCapIndex, 1);
									tempUserData.selectedBusCaps.splice(busCapIndex, 1);
									thisBusCap.inScope = false;
								} else {
									tempUserData.selectedBusCapIds.push(thisBusCapId);
									tempUserData.selectedBusCaps.push(thisBusCap);
									thisBusCap.inScope = true;
								}
								updateBusCapBlobHeatmap(thisBusCapBlob, thisBusCap);
								updateInScopeElements();
								updateGoalStyles();
								setValueStageStyles(viewData.valueStages);
								refreshValueStageChevronStyles();
								updateStrategicPlanPhysProcTable();
								if(stratPlanAppProRolesTable != null) {
									updateStrategicPlanAppProRolesTable();
								}
							});
							
							
							
							<!-- Set up strategic plan form event handlers -->
							<!-- Initialise the current strategic plan -->
							dynamicUserData.currentPlanningActions = newPlanningActions();
						
							<!-- Initialise the current strategic plan -->
							dynamicUserData.currentStrategicPlan = newStrategicPlan();
						
							<!-- name text box -->
							$('#stratPlanName').on('change', function (evt) {
							  var newName = $(this).val();
							  if(newName.length > 0) {
							  	dynamicUserData.currentStrategicPlan.name = newName;
							  } else {
							  	$(this).val(dynamicUserData.currentStrategicPlan.name);
							  }
							});
							
							<!-- description text box -->
							$('#stratPlanDesc').on('change', function (evt) {
							  dynamicUserData.currentStrategicPlan.description = $(this).val();
							});
							
							<!-- Initialise planning action button templates -->
							var noActionButtonFragment   = $("#no-action-button-template").html();
							noActionButtonTemplate = Handlebars.compile(noActionButtonFragment);
							var planningActionButtonFragment   = $("#planning-action-button-template").html();
							planningActionButtonTemplate = Handlebars.compile(planningActionButtonFragment);
							
							
							<!-- Initialise graph model -->
							<!-- D3 CODE -->
							
							
							<!-- initialise element modal dialogs -->
							
							<!-- Initialise modal content handlebars templates -->
							var busCapModalContentFragment   = $("#bus-cap-modal-content-template").html();
							busCapModalContentTemplate = Handlebars.compile(busCapModalContentFragment);
							
							var busProcessModalContentFragment   = $("#bus-process-modal-content-template").html();
							busProcessModalContentTemplate = Handlebars.compile(busProcessModalContentFragment);
							
							var orgModalContentFragment   = $("#org-modal-content-template").html();
							orgModalContentTemplate = Handlebars.compile(orgModalContentFragment);
						
							var appServiceModalContentFragment   = $("#app-service-modal-content-template").html();
							appServiceModalContentTemplate = Handlebars.compile(appServiceModalContentFragment);
						
							var appModalContentFragment   = $("#app-modal-content-template").html();
							appModalContentTemplate = Handlebars.compile(appModalContentFragment);
							
							var physProcsRowFragment   = $("#modal-physproc-row-template").html();
							physProcsRowTemplate = Handlebars.compile(physProcsRowFragment);
							
							var physProcsOrgRowFragment   = $("#modal-physproc-org-row-template").html();
							physProcsOrgRowTemplate = Handlebars.compile(physProcsOrgRowFragment);
							
							var physProcsBusProcessRowFragment   = $("#modal-physproc-bus-process-row-template").html();
							physProcsBusProcessRowTemplate = Handlebars.compile(physProcsBusProcessRowFragment);
							
							var appServiceRowFragment   = $("#modal-appservice-row-template").html();
							appServiceRowTemplate = Handlebars.compile(appServiceRowFragment);
							
							var appRowFragment   = $("#modal-app-row-template").html();
							appRowTemplate = Handlebars.compile(appRowFragment);
							
							var stratPlanErrorsFragment   = $("#strat-plan-errors-template").html();
							stratPlanErrorsTemplate = Handlebars.compile(stratPlanErrorsFragment);
						
							
							
							<!-- initialise event listener for business capability modal being displayed-->
							$('#busCapModal').on('show.bs.modal', function (event) {
								if(nextModalElement != null) {
									renderBusCapModalContent(nextModalElement);
									nextModalElement = null;
								} else {	
								  var thisTrigger = $(event.relatedTarget); //  the element that triggered the modal
								  
								  var aBusCapId = thisTrigger.attr('eas-id');
								  var aBusCap = getObjectById(viewData.busCaps, "id", aBusCapId);
								  
								  if(aBusCap != null) {
								  	renderBusCapModalContent(aBusCap);
								  }
								}
							});
							
							<!-- initialise event listener for business capability modal being hidden-->
							$('#busCapModal').on('hidden.bs.modal', function (event) {
								showNextModal(elementUnderReview);
							});
							
							
							<!-- initialise event listener for business process modal being displayed-->
							$('#busProcessModal').on('show.bs.modal', function (event) {
								if(nextModalElement != null) {
									renderBusProcessModalContent(nextModalElement, nextModalElement.index);
									nextModalElement = null;
								} else {	
								  var thisTrigger = $(event.relatedTarget); //  the element that triggered the modal
								  
								  var aBusProcId = thisTrigger.attr('eas-id');
								  
								  var aBusProcessIndex = thisTrigger.attr('eas-index');
								  var aBusProcess = getObjectById(viewData.busProcesses, "id", aBusProcId);
								  
								  if(aBusProcess != null) {
								  	renderBusProcessModalContent(aBusProcess, aBusProcessIndex);
							  	  }
							  }
							});
							
							
							<!-- initialise event listener for business process modal being hidden-->
							$('#busProcessModal').on('hidden.bs.modal', function (event) {
								showNextModal(elementUnderReview);
								refreshGraphModel();
							});
							
							
							<!-- initialise event listener for organisation modal being displayed-->
							$('#orgModal').on('show.bs.modal', function (event) {
								if(nextModalElement != null) {
									renderOrgModalContent(nextModalElement, nextModalElement.index);
									nextModalElement = null;
								} else {	
								  var thisTrigger = $(event.relatedTarget); //  the element that triggered the modal
								  
								  var anOrgId = thisTrigger.attr('eas-id');
								  var anOrgIndex = thisTrigger.attr('eas-index');
								  var anOrg = getObjectById(viewData.organisations, "id", anOrgId);
								  
								  if(anOrg != null) {
								  	renderOrgModalContent(anOrg, anOrgIndex);
								  }
								}
							});
							
							<!-- initialise event listener for org modal being hidden-->
							$('#orgModal').on('hidden.bs.modal', function (event) {
								showNextModal(elementUnderReview);
								refreshGraphModel();
							});
							
							
							<!-- initialise event listener for application service modal button-->
							$('#appServiceModal').on('show.bs.modal', function (event) {
								if(nextModalElement != null) {
									renderAppServiceModalContent(nextModalElement, nextModalElement.index);
									nextModalElement = null;
								} else {
								  var button = $(event.relatedTarget); // Button that triggered the modal
								  
								  var anAppServiceId = button.attr('eas-id');
								  var anAppServiceIndex = button.attr('eas-index');
								  var anAppService = getObjectById(viewData.appServices, "id", anAppServiceId);
								  
								  if(anAppService != null) {
								  	renderAppServiceModalContent(anAppService, anAppServiceIndex);
								  }
								}
							});
							
							<!-- initialise event listener for app service modal being hidden-->
							$('#appServiceModal').on('hidden.bs.modal', function (event) {
								showNextModal(elementUnderReview);
								refreshGraphModel();
							});
							
							<!-- initialise event listener for applications modal button-->
							$('#appModal').on('show.bs.modal', function (event) {
								if(nextModalElement != null) {
									renderAppModalContent(nextModalElement, nextModalElement.index);
									nextModalElement = null;
								} else {
									  var button = $(event.relatedTarget); // Button that triggered the modal
									  
									  var anAppId = button.attr('eas-id');
									  var anAppIndex = button.attr('eas-index');
									  var anApp = getObjectById(viewData.applications, "id", anAppId);
									  
									  if(anApp != null) {
									  	renderAppModalContent(anApp, anAppIndex);
									  }
								}
							});
							
							
							<!-- initialise event listener for application modal being hidden-->
							$('#appModal').on('hidden.bs.modal', function (event) {
								showNextModal(elementUnderReview);
								refreshGraphModel();
							});
							
							//SET UP THE DEFAULT OPTIONS FOR SERVICE QUALITY GAUGES
						    gaugeOpts = {
							  lines: 12,
							  angle: 0.15,
							  lineWidth: 0.44,
							  pointer: {
							    length: 0.9,
							    strokeWidth: 0.035,
							    color: '#000000'
							  },
							  limitMax: 'false', 
							  percentColors: [[0.0, "#D0011B" ], [0.50, "#F6A623"], [1.0, "#44A643"]], // !!!!
							  strokeColor: '#E0E0E0',
							  generateGradient: true
							};
							
							
							<!-- add event listeneer to create plan button -->
							$('#createStratPlanBtn').on('click', function (evt) {
								
								//validate the current strategic plan
								var currentPlan = dynamicUserData.currentStrategicPlan;
								var thisErrors = [];
								if(currentPlan.name.length == 0) {
									thisErrors.push("name");
								};
								if(currentPlan.objectives.length == 0) {
									thisErrors.push("at least one objective");
								};
								if(currentPlan.elements.length == 0) {
									thisErrors.push("at least one element to be changed");
								};
								
								//if validation is passed, add the current plan to the list of plans and reset the current plan
								if(thisErrors.length == 0) {
								
									currentPlan['extId'] = 'SP' + (+new Date).toString(36); 
								
									//save the elements that are part of the current plan as well as the planned change
									saveElementsToPlan(currentPlan);
									
									//add the current strategic plan to the list of strategic plans
									
									dynamicUserData.strategicPlans.push(currentPlan);
									
									updateStrategicPlansTable();
									updateRoadmapGantt();
									
									//reset the current strategic plan
									dynamicUserData.currentStrategicPlan = newStrategicPlan();
									
									//refresh the strategic plan form
									refreshStrategicPlanForm();
									
									//scroll down to the strategic plans table
									document.querySelector('#dt_stratPlanList').scrollIntoView({ 
									  behavior: 'smooth' 
									});
	
								} else {
									//display errors
									var errorList = {
										title: 'Incomplete Strategic Plan',
										messages: thisErrors
									};
									$("#stratPlanErrorModalList").html(stratPlanErrorsTemplate(errorList));
									$('#stratPlanErrorModal').modal('show');				
								}

								if(dynamicUserData.strategicPlans?.length > 0) {
									$('#createRoadmapBtn').prop("disabled", false);
									$('#exportRoadmapBtn').prop("disabled", false);
								} else {
									$('#createRoadmapBtn').prop("disabled", true);
									$('#exportRoadmapBtn').prop("disabled", true);
								}
							});
							
							//initialise the Strategic Plan detail handlebars template
							var stratPlanDetailsFragment   = $("#strat-plan-details-template").html();
							stratPlanDetailsTemplate = Handlebars.compile(stratPlanDetailsFragment);
							
							//Add detail button event listeneer
						    $('#dt_stratPlanList tbody').on('click', 'td.details-control', function () {
						    	//console.log('expanding the details');
						    	
						        var tr = $(this).closest('tr');
						        var row = strategicPlanTable.row( tr );
						 
						        if ( row.child.isShown() ) {
						            // This row is already open - close it
						            row.child.hide();
						            tr.removeClass('shown');
						        }
						        else {
						            // Open this row
						            row.child( showStrategicPlanTableDetail(row.data()) ).show();
						            tr.addClass('shown');
						        }
						    } );
						    
						    <!-- Roadmap Gantt Chart initiation -->
							var ganttStratPlanFragment   = $("#gantt-strat-plan-details-template").html();
							ganttStratPlanTemplate = Handlebars.compile(ganttStratPlanFragment);
							
							<xsl:if test="$eipMode">
						
								<!-- Initialise the Crweate Strategic Plan button -->
								$('#createRoadmapBtn').on('click', function (evt) {
									
									var thisErrors = [];
									<!--if(dynamicUserData.roadmap.name == null) {
										thisErrors.push("roadmap name");
									};
									if(dynamicUserData.strategicPlans.length == 0) {
										thisErrors.push("at least one strategic plan");
									};-->
									
									//if validation is passed, add the current plan to the list of plans and reset the current plan
									if(thisErrors.length == 0) {
										console.log(dynamicUserData);
										let newEssRodmapData = new essRoadmap(dynamicUserData.roadmap, dynamicUserData.strategicPlans);
										console.log('NEW ROADMAP');
										console.log(newEssRodmapData);
										console.log(JSON.stringify(newEssRodmapData));
										
										essPromise_createAPIElement('/essential-utility/v3',newEssRodmapData,'instances','Roadmap')
										.then(function(response){
											//console.log('Roadmap Created');
											console.log(response);
											$('#createRoadmapBtn').text('Roadmap Created');
											$('#createRoadmapBtn').prop("disabled", true);
										})
										.catch(function (error) {
											console.log(error);
											$('#createRoadmapBtn').text('Error');
										});
									} else {
										var errorList = {
											title: 'Missing Roadmap Details',
											messages: thisErrors
										};
										$("#stratPlanErrorModalList").html(stratPlanErrorsTemplate(errorList));
										$('#stratPlanErrorModal').modal('show');			
									}
								});
							</xsl:if>
							
							<!-- Initialise the excel export button -->
							$('#exportRoadmapBtn').on('click', function (evt) {
								console.log('CLICKED ON EXPORT ROADMAP');
								var thisErrors = [];
								
								//if validation is passed, add the current plan to the list of plans and reset the current plan
								if(thisErrors.length == 0) {						
									exportRoadmapExcel();
								} else {
									var errorList = {
										title: 'Missing Roadmap Details',
										messages: thisErrors
									};
									$("#stratPlanErrorModalList").html(stratPlanErrorsTemplate(errorList));
									$('#stratPlanErrorModal').modal('show');			
								}
							});
	
							<!--Tooltips and Popovers-->
							$('.fa-info-circle').click(function() {
								$('[role="tooltip"]').remove();
							});
							$('.fa-info-circle').popover({
								container: 'body',
								html: true,
								trigger: 'click',
								content: function(){
									return $(this).next().html();
								}
							});
							<!--Tooltips and Popovers Ends-->
							
							<!--Show/hide next div-->
							$('.showDetailTrigger').click(function(){
								$(this).next().slideToggle();
							});
							<!--Show/hide next div ends-->
						
							//pre-select the first value stream
							if(viewData.valueStreams.length > 0) {
								var firstValStream = viewData.valueStreams[0];
								$('#valueStreamsList').val(firstValStream.id);
								setCurrentValueStream(firstValStream.id);
								updateBusCapHeatmaps();
							}
							
							$('.equalHeight1').matchHeight();
						});
						
					});
					
					class essPlanForElement {
					constructor(changedElement) {
					this.className = "PLAN_TO_ELEMENT_RELATION";
					if(changedElement.planningNotes) {
					this.relation_description = changedElement.planningNotes;
					}
					this.name = "";
					this.plan_to_element_ea_element = {
						"id": changedElement.id,
						"className": changedElement.type.essClass
					}
					this.plan_to_element_change_action = {
						'id': changedElement.planningAction.id,
						'className': 'Planning_Action'
					}
					}
					}
					
					class essStratPlan {
						constructor(plan) {
							this.className = "Enterprise_Strategic_Plan";
							if(plan.description) {
								this.description = plan.description;
							}
							this.strategic_plan_valid_from_date_iso_8601 = plan.excelStartDate;
							this.strategic_plan_valid_to_date_iso_8601 = plan.excelEndDate;
							this.name = plan.name;
							this.strategic_plan_status = {
								"className": "Planning_Status",
								"name": "Proposed Plan"
							}
							if(plan.objectives) {
								let thisObjs = [];							
								plan.objectives.forEach(function(obj) {
									thisObjs.push({
										"id": obj.id,
										"className": "Business_Objective"
									});   
								});
								this.strategic_plan_supports_objective = thisObjs;
							}
							this.strategic_plan_for_elements = plan.changedElements.map(change => new essPlanForElement(change));
						}
					}
					
					class essRoadmap {
						constructor(roadmap, plans) {
							this.className = "Roadmap";
							this.description = 'Roadmap for the implementation of ' + roadmap.name;
							this.name = roadmap.name;
							this.roadmap_strategic_plans = plans.map(plan => new essStratPlan(plan));
						}
					}
					<!-- END PAGE DRAWING FUNCTIONS -->
				</script>
				<style>
					.grow {
						height: 120px!important;
						transition: height 0.4s;
					}
					.shrink{
						height: 40px!important;
						transition: height 1s;
					}
				</style>
			</head>
			<body>
				
			<script id="dropdown-list-template" type="text/x-handlebars-template">
				{{#each this}}
					<option/>
					<option>
						<xsl:attribute name="value">{{id}}</xsl:attribute>
						{{name}}
					</option>
				{{/each}}
			</script>
				
				
				
				<!--<script type="text/javascript">
				    $(window).on('load',function(){
				        $('#appProcModal').modal('show');
				    });
				</script>-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					
					<!--MODAL DIALOGS CODE-->
					<script id="modal-physproc-row-template" type="text/x-handlebars-template">
						<p class="impact large"><i class="fa essicon-boxesdiagonal right-5"/>Implementing Processes</p>
						{{#if physProcs.length}}
							<table class="table table striped table-condensed small">
								<thead>
									<tr>
										<th colspan="2" class="cellWidth-25pc vAlignTop">Business Capability</th>
										<th class="cellWidth-25pc vAlignTop">Business Process</th>
										<th class="cellWidth-10pc vAlignTop">Plan</th>
										<th class="cellWidth-15pc vAlignTop">Performed by Organisation</th>
										<th class="cellWidth-10pc vAlignTop">Plan</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CX</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CE</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CSv</th>
									</tr>
								</thead>
								<tbody>
									{{#each physProcs}}
										<tr>
											<td>{{{busCapLink}}}</td>
											<td class="cellWidth-10pc">
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{busCapId}}</xsl:attribute>
													<xsl:attribute name="eas-elements">busCaps</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button btn-default</xsl:attribute>
													Review					
												</button>
											</td>
											<td>{{{busProcessLink}}}</td>
											<td>
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{busProcess.id}}</xsl:attribute>
													<xsl:attribute name="eas-elements">busProcesses</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if busProcess.hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
													{{#if busProcess.hasPlan}}{{busProcess.planningAction.name}}{{else}}No Change{{/if}}					
												</button>
											</td>
											<td>{{{orgLink}}}</td>
											<td>
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{org.id}}</xsl:attribute>
													<xsl:attribute name="eas-elements">organisations</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if org.hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
													{{#if org.hasPlan}}{{org.planningAction.name}}{{else}}No Change{{/if}}					
												</button>
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{cxStyleClass}}</xsl:attribute>
												&#160;
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{emotionStyleClass}}</xsl:attribute>
												<i>
													<xsl:attribute name="class">fa-2x fa {{emotionIcon}}</xsl:attribute>
												</i>
												<!--{{emotionScore}}-->
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{kpiStyleClass}}</xsl:attribute>
												&#160;
											</td>
										</tr>
									{{/each}}
								</tbody>										
							</table>
						{{else}}
							<p><em>No processes captured</em></p>
						{{/if}}
						<div class="col-xs-12"><hr/></div>		
					</script>
					

					<script id="modal-physproc-org-row-template" type="text/x-handlebars-template">
						<p class="impact large"><i class="fa essicon-boxesdiagonal right-5"/>Performing Organisations</p>
						{{#if physProcs.length}}
							<table class="table table striped table-condensed small">
								<thead>
									<tr>
										<th class="cellWidth-70pc vAlignTop">Organisation</th>
										<th class="cellWidth-15pc vAlignTop">Plan</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CX</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CE</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CSv</th>
									</tr>
								</thead>
								<tbody>
									{{#each physProcs}}
										<tr>
											<td>{{{orgLink}}}</td>
											<td>
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{org.id}}</xsl:attribute>
													<xsl:attribute name="eas-elements">organisations</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if org.hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
													{{#if org.hasPlan}}{{org.planningAction.name}}{{else}}No Change{{/if}}					
												</button>
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{cxStyleClass}}</xsl:attribute>
												&#160;
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{emotionStyleClass}}</xsl:attribute>
												<i>
													<xsl:attribute name="class">fa-2x fa {{emotionIcon}}</xsl:attribute>
												</i>
												<!--{{emotionScore}}-->
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{kpiStyleClass}}</xsl:attribute>
												&#160;
											</td>
										</tr>
									{{/each}}
								</tbody>										
							</table>
						{{else}}
							<p><em>No organisations captured</em></p>
						{{/if}}
						<div class="col-xs-12"><hr/></div>
					</script>
					
					
					<script id="modal-physproc-bus-process-row-template" type="text/x-handlebars-template">
						<p class="impact large"><i class="fa essicon-boxesdiagonal right-5"/>Processeses Performed</p>
						{{#if physProcs.length}}
							<table class="table table striped table-condensed small">
								<thead>
									<tr>
										<th class="cellWidth-30pc vAlignTop">Business Process</th>
										<th class="cellWidth-40pc vAlignTop">Description</th>
										<th class="cellWidth-15pc vAlignTop">Plan</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CX</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CE</th>
										<th class="cellWidth-5pc alignCentre vAlignTop">CSv</th>
									</tr>
								</thead>
								<tbody>
									{{#each physProcs}}
										<tr>
											<td>{{{busProcessLink}}}</td>
											<td>{{{busProcessDescription}}}</td>
											<td>
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{busProcess.id}}</xsl:attribute>
													<xsl:attribute name="eas-elements">busProcesses</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if busProcess.hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
													{{#if busProcess.hasPlan}}{{busProcess.planningAction.name}}{{else}}No Change{{/if}}					
												</button>
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{cxStyleClass}}</xsl:attribute>
												&#160;
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{emotionStyleClass}}</xsl:attribute>
												<i>
													<xsl:attribute name="class">fa-2x fa {{emotionIcon}}</xsl:attribute>
												</i>
												<!--{{emotionScore}}-->
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{kpiStyleClass}}</xsl:attribute>
												&#160;
											</td>
										</tr>
									{{/each}}
								</tbody>										
							</table>
						{{else}}
							<p><em>No processes captured</em></p>
						{{/if}}
						<div class="col-xs-12"><hr/></div>		
					</script>
					
					
					
					<script id="modal-appservice-row-template" type="text/x-handlebars-template">
						<p class="impact large"><i class="fa essicon-boxesdiagonal right-5"/>Supporting Applications</p>
						{{#if appServices.length}}
							<table class="table table striped table-condensed small">
								<thead>
									<tr>
										<th rowspan="2" class="cellWidth-20pc vAlignTop">Application Service</th>
										<th rowspan="2" class="cellWidth-25pc vAlignTop">Description</th>
										<th rowspan="2" class="cellWidth-10pc vAlignTop">Plan</th>
										<th class="cellWidth-45pc vAlignTop" colspan="3">Alternative Applications</th>
									</tr>
									<tr>
										<th class="cellWidth-20pc small vAlignTop">Application</th>
										<th class="cellWidth-10pc small vAlignTop">Plan</th>
										<th class="cellWidth-15pc small vAlignTop alignCentre">Tech Health</th>
									</tr>
								</thead>
								<tbody>
									{{#each appServices}}
										<tr>
											<td>
												<xsl:attribute name="rowspan">{{altAppCount}}</xsl:attribute>
												{{{appService.link}}}
											</td>
											<td>
												<xsl:attribute name="rowspan">{{altAppCount}}</xsl:attribute>
												{{appService.description}}
											</td>
											<td>
												<xsl:attribute name="rowspan">{{altAppCount}}</xsl:attribute>
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{appService.id}}</xsl:attribute>
													<xsl:attribute name="eas-elements">appServices</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if appService.hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
													{{#if appService.hasPlan}}{{appService.planningAction.name}}{{else}}No Change{{/if}}					
												</button>
											</td>
											{{#each altApps}}
												{{#if @first}}
													<td>{{{link}}}</td>
													<td>
														<button data-toggle="modal">
															<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
															<xsl:attribute name="eas-elements">applications</xsl:attribute>
															<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
															{{#if hasPlan}}{{planningAction.name}}{{else}}No Change{{/if}}					
														</button>
													</td>
													<td>
														<xsl:attribute name="class">alignCentre {{techHealthStyle}}</xsl:attribute>
														{{techHealthScore}}%
													</td>
												</tr>
												{{else}}
													<tr>
														<td>{{{link}}}</td>
														<td>
															<button data-toggle="modal">
																<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
																<xsl:attribute name="eas-elements">applications</xsl:attribute>
																<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
																{{#if hasPlan}}{{planningAction.name}}{{else}}No Change{{/if}}							
															</button>
														</td>
														<td>
															<xsl:attribute name="class">alignCentre {{techHealthStyle}}</xsl:attribute>
															{{techHealthScore}}%
														</td>
													</tr>
												{{/if}}
											{{/each}}	
									{{/each}}
								</tbody>	
							</table>
						{{else}}
							<p><em>No applications captured</em></p>
						{{/if}}
						<div class="col-xs-12"><hr/></div>
					</script>
					
					
					<script id="modal-app-row-template" type="text/x-handlebars-template">
						<p class="impact large"><i class="fa essicon-boxesdiagonal right-5"/>Implementing Applications</p>
						{{#if applications.length}}
							<table class="table table striped table-condensed small">
								<thead>
									<tr>
										<th class="cellWidth-30pc vAlignTop">Application</th>
										<th class="cellWidth-50pc vAlignTop">Description</th>
										<th class="cellWidth-10pc vAlignTop">Plan</th>
										<th class="cellWidth-10pc alignCentre vAlignTop">Tech Health</th>
									</tr>
								</thead>
								<tbody>
									{{#each applications}}
										<tr>
											<td>
												{{{link}}}
											</td>
											<td>
												{{description}}
											</td>
											<td>
												<button data-toggle="modal">
													<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
													<xsl:attribute name="eas-elements">applications</xsl:attribute>
													<xsl:attribute name="class">alignLeft modalReviewBtn btn btn-xs modal_action_button {{#if hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
													{{#if hasPlan}}{{planningAction.name}}{{else}}No Change{{/if}}					
												</button>
											</td>
											<td>
												<xsl:attribute name="class">alignCentre {{techHealthStyle}}</xsl:attribute>
												{{#if techHealthScore}}{{techHealthScore}}%{{/if}}
											</td>
										</tr>	
									{{/each}}
								</tbody>	
							</table>
						{{else}}
							<p><em>No applications captured</em></p>
						{{/if}}
						<div class="col-xs-12"><hr/></div>
					</script>
					
					
					<!--<script id="modal-appservice-row-template" type="text/x-handlebars-template">
						{{#each appServices}}
							<tr>
								<td>{{{link}}}</td>
								<td>{{description}}</td>
								<td>
									<ul>
										{{#each altApps}}
											<li>
												{{{link}}}
												&#160;
												<button class="alignLeft appModalReview btn btn-xs neutralHeatmapColour modal_action_button">
													<xsl:attribute name="eas-id">1</xsl:attribute>
													Decommission
													
												</button>
											</li>
										{{/each}}
									</ul>
								</td>
							</tr>
						{{/each}}
					</script>-->
					
					<!-- Handlebars template for the contents of the Business Capability Modal -->
					<script id="bus-cap-modal-content-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title xlarge" id="busCapModalLabel"><strong><span class="text-darkgrey">Business Capability: </span><span id="bus-cap-modal-subject" class="text-primary">{{{busCap.link}}}</span></strong></p>
							<p>{{busCap.description}}</p>			
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-xs-12">
									<p class="impact large"><i class="fa fa-bullseye right-5"/>Impacted Objectives</p>
									<ul class="multi-column-list">
										{{#each busCap.objectives}}
											<li>{{{link}}}</li>
										{{/each}}
									</ul>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="alignCentre col-md-4">
									<p class="impact large"><i class="fa fa-comments right-5"/>Customer Experience</p>
									<img height="180px">
										<xsl:attribute name="src">{{busCap.overallScores.cxStyle.icon}}</xsl:attribute>
									</img>								
								</div>
								<div class="alignCentre col-md-4">
									<p class="impact large"><i class="fa fa-concierge-bell-alt right-5"/>Customer Service</p>
									<div class="gaugePanel">
										<div class="gaugeContainer top-10">
											<canvas id="busCapModalCustSvcGauge" style="width: 100%;" width="200" height="100"/>								
										</div>
									</div>
								</div>
								<div class="alignCentre col-md-4">
									<p class="impact large"><i class="fa fa-brain right-5"/>Customer Emotions</p>
									<img height="180px">
										<xsl:attribute name="src">{{busCap.overallScores.emotionStyle.emoji}}</xsl:attribute>
									</img>
								</div>
								<div class="clearfix"/>
								<div class="col-xs-4">
									<div class="gaugeLabel strong">{{busCap.overallScores.cxStyle.label}}</div>
								</div>
								<div class="col-xs-4">
									{{#if overallScores.kpiPercent}}
										<div class="gaugeLabel strong">{{busCap.overallScores.kpiPercent}}%</div>
									{{else}}
										<div class="gaugeLabel strong">Undefined</div>
									{{/if}}
								</div>
								<div class="col-xs-4">
									<div class="gaugeLabel strong">{{busCap.overallScores.emotionStyle.label}}</div>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12">
									<div class="row">
										<div class="col-xs-12">
											<p class="impact large"><i class="fa fa-chevron-right right-5"/>Supported Value Streams</p>
											<p class="small pull-left">
												<em>Select a Value Stream to view supported Processes and Applications</em>
											</p>
											<div class="pull-right">
												<span class="right-10"><strong>Heatmap:</strong></span>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="busCapHeatmapRadio" value="cx" checked="checked"/>
													Customer Experience
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="busCapHeatmapRadio" value="emotion"/>
													Customer Emotion
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="busCapHeatmapRadio" value="kpi"/>
													Customer Service
												</label>
											</div>
										</div>
									</div>							
									<select id="busCapValueStreamsList" style="width:300px;" class="select2">
										{{#each busCap.valueStreams}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
									<div class="clearfix"/>
									<!-- VALUE STAGES CONTAINER -->
									<div id="busCapValueStagesContainer" class="top-15"/>	
								</div>
								<div class="col-xs-12"><hr/></div>
								<div id="busCapModalPhysProcsTBody" class="col-md-12"/>
								<div id="busCapModalServiceTBody" class="col-md-12"/>			
							</div>
						</div>
						<div class="modal-footer">
							{{#if modalHistory.length}}
								<button type="button" class="modalCloseAllBtn btn btn-danger">Close All</button>
							{{/if}}
							<button type="button" class="btn btn-success" data-dismiss="modal">{{#if modalHistory.length}}Back{{else}}Close{{/if}}</button>
						</div>
					</script>
					
					<!-- Bus Cap Modal -->
					<div class="modal fade" id="busCapModal" tabindex="-1" role="dialog" aria-labelledby="busCapModalLabel">
						<div class="modal-dialog modal-xl" role="document">
							<div class="modal-content" id="busCapModelContent"/>						
						</div>
					</div>
					
					
					<!-- Handlebars template for the contents of the Business Process Modal -->
					<script id="bus-process-modal-content-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title xlarge" id="busProcessModalLabel"><strong><span class="text-darkgrey">Business Process: </span><span id="bus-process-modal-subject" class="text-primary">{{{busProcess.link}}}</span></strong></p>
							<p>{{busProcess.description}}</p>
							<div class="row">
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-check-circle right-5"/>Select Planned Change:</p>
									<select id="busProcessModalPlanningActionList" class="select2" style="width: 100%;">
										{{#each planningActions}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
								</div>
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-edit right-5"/>Planning Notes:</p>
									<textarea id="busProcessPlanNotes" class="form-control" placeholder="Enter notes to explain rationale for the planning action">{{busProcess.planningNotes}}</textarea>
								</div>
							</div>
							<div class="clearfix bottom-15"></div>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-xs-12">
									<p class="impact large"><i class="fa fa-bullseye right-5"/>Impacted Objectives</p>
									<ul class="multi-column-list">
										{{#each busProcess.objectives}}
											<li>{{{link}}}</li>
										{{/each}}
									</ul>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="alignCentre col-md-4">
									<p class="impact large"><i class="fa fa-comments right-5"/>Customer Experience</p>
									<img height="180px">
										<xsl:attribute name="src">{{busProcess.overallScores.cxStyle.icon}}</xsl:attribute>
									</img>								
									
								</div>
								<div class="alignCentre col-md-4">
									<p class="impact large"><i class="fa fa-concierge-bell-alt right-5"/>Customer Service</p>
									<div class="gaugePanel">
										<div class="gaugeContainer top-10">
											<canvas id="busProcessModalCustSvcGauge" style="width: 100%;" width="200" height="100"/>								
										</div>
									</div>
								</div>
								<div class="alignCentre col-md-4">
									<p class="impact large"><i class="fa fa-brain right-5"/>Customer Emotions</p>
									<img height="180px">
										<xsl:attribute name="src">{{busProcess.overallScores.emotionStyle.emoji}}</xsl:attribute>
									</img>
								</div>
								<div class="clearfix"></div>
								<div class="col-xs-4">
									<div class="gaugeLabel strong">{{busProcess.overallScores.cxStyle.label}}</div>
								</div>
								<div class="col-xs-4">
									{{#if busProcess.overallScores.kpiPercent}}
										<div class="gaugeLabel strong">{{busProcess.overallScores.kpiPercent}}%</div>
									{{else}}
										<div class="gaugeLabel strong">Undefined</div>
									{{/if}}
								</div>
								<div class="col-xs-4">
									<div class="gaugeLabel strong">{{busProcess.overallScores.emotionStyle.label}}</div>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12">
									<div class="row">
										<div class="col-xs-12">
											<p class="impact large"><i class="fa fa-chevron-right right-5"/>Supported Value Streams</p>
											<p class="small pull-left">
												<em>Select a Value Stream to view relevant Organisations and Applications</em>
											</p>
											<div class="pull-right">
												<span class="right-10"><strong>Heatmap:</strong></span>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="busProcessHeatmapRadio" value="cx" checked="checked"/>
													Customer Experience
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="busProcessHeatmapRadio" value="emotion"/>
													Customer Emotion
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="busProcessHeatmapRadio" value="kpi"/>
													Customer Service
												</label>
											</div>
										</div>
									</div>							
									<select id="busProcessValueStreamsList" style="width:300px;" class="select2">
										{{#each busProcess.valueStreams}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
									<div class="clearfix"/>
									<!-- VALUE STAGES CONTAINER -->
									<div id="busProcessValueStagesContainer" class="top-15"/>	
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12" id="busProcessModalPhysProcsTBody"/>				
								<div class="col-md-12" id="busProcessModalServiceTBody"/>				
							</div>
						</div>
						<div class="modal-footer">
							{{#if modalHistory.length}}
								<button type="button" class="modalCloseAllBtn btn btn-danger">Close All</button>
							{{/if}}
							<button type="button" class="btn btn-success" data-dismiss="modal">{{#if modalHistory.length}}Back{{else}}Close{{/if}}</button>
						</div>
					</script>
					
					<!-- Bus Process Modal -->
					<div class="modal fade" id="busProcessModal" tabindex="-1" role="dialog" aria-labelledby="busProcessModalLabel">
						<div class="modal-dialog modal-xl" role="document">
							<div class="modal-content" id="busProcessModelContent"/>						
						</div>
					</div>
					
					
					
					<!-- Handlebars template for the contents of the Organisation Modal -->
					<script id="org-modal-content-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title xlarge" id="orgModalLabel"><strong><span class="text-darkgrey">Organisation: </span><span id="org-modal-subject" class="text-primary">{{{org.link}}}</span></strong></p>
							<p>{{org.description}}</p>
							<div class="row">
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-check-circle right-5"/>Select Planned Change:</p>
									<select id="orgModalPlanningActionList" class="select2" style="width: 100%;">
										{{#each planningActions}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
								</div>
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-edit right-5"/>Planning Notes:</p>
									<textarea id="orgPlanNotes" class="form-control" placeholder="Enter notes to explain rationale for the planning action">{{org.planningNotes}}</textarea>
								</div>
							</div>
							<div class="clearfix bottom-15"></div>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-xs-12">
									<p class="impact large"><i class="fa fa-bullseye right-5"/>Impacted Objectives</p>
									<ul class="multi-column-list">
										{{#each org.objectives}}
											<li>{{{link}}}</li>
										{{/each}}
									</ul>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="alignCentre col-xs-4">
									<p class="impact large"><i class="fa fa-comments right-5"/>Customer Experience</p>
									<img height="180px">
										<xsl:attribute name="src">{{org.overallScores.cxStyle.icon}}</xsl:attribute>
									</img>								
									
								</div>
								<div class="alignCentre col-xs-4">
									<p class="impact large"><i class="fa fa-concierge-bell-alt right-5"/>Customer Service</p>
									<div class="gaugePanel">
										<div class="gaugeContainer top-10">
											<canvas id="orgModalCustSvcGauge" style="width: 100%;" width="200" height="100"/>								
										</div>
										
									</div>
								</div>
								<div class="alignCentre col-xs-4">
									<p class="impact large"><i class="fa fa-brain right-5"/>Customer Emotions</p>
									<img height="180px">
										<xsl:attribute name="src">{{org.overallScores.emotionStyle.emoji}}</xsl:attribute>
									</img>
									
								</div>
								<div class="clearfix"/>
								<div class="col-xs-4">
									<div class="gaugeLabel strong">{{org.overallScores.cxStyle.label}}</div>
								</div>
								<div class="col-xs-4">
									{{#if org.overallScores.kpiPercent}}
										<div class="gaugeLabel strong">{{org.overallScores.kpiPercent}}%</div>
									{{else}}
										<div class="gaugeLabel strong">Undefined</div>
									{{/if}}
								</div>
								<div class="col-xs-4">
									<div class="gaugeLabel strong">{{org.overallScores.emotionStyle.label}}</div>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12">
									<div class="row">
										<div class="col-xs-12">
											<p class="impact large"><i class="fa fa-chevron-right right-5"/>Supported Value Streams</p>
											<p class="small pull-left">
												<em>Select a Value Stream to view relevant Processes and Applications</em>
											</p>
											<div class="pull-right">
												<span class="right-10"><strong>Heatmap:</strong></span>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="orgHeatmapRadio" value="cx" checked="checked"/>
													Customer Experience
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="orgHeatmapRadio" value="emotion"/>
													Customer Emotion
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="orgHeatmapRadio" value="kpi"/>
													Customer Service
												</label>
											</div>
										</div>
									</div>							
									<select id="orgValueStreamsList" style="width:300px;" class="select2">
										{{#each org.valueStreams}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
									<div class="clearfix"/>
									<!-- VALUE STAGES CONTAINER -->
									<div id="orgValueStagesContainer" class="top-15"/>	
								</div>
								<div class="col-xs-12"><hr/></div>
								<div id="orgModalPhysProcsTBody" class="col-md-12"/>
								<div id="orgModalServiceTBody" class="col-md-12"/>		
							</div>
						</div>
						<div class="modal-footer">
							{{#if modalHistory.length}}
								<button type="button" class="modalCloseAllBtn btn btn-danger">Close All</button>
							{{/if}}
							<button type="button" class="btn btn-success" data-dismiss="modal">{{#if modalHistory.length}}Back{{else}}Close{{/if}}</button>
						</div>
					</script>
					
					<!-- Organisation Modal -->
					<div class="modal fade" id="orgModal" tabindex="-1" role="dialog" aria-labelledby="orgModalLabel">
						<div class="modal-dialog modal-xl" role="document">
							<div class="modal-content" id="orgModelContent"/>						
						</div>
					</div>
					
					
					<!-- Handlebars template for the contents of the Application Service Modal -->
					<script id="app-service-modal-content-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title xlarge" id="appServiceModalLabel"><strong><span class="text-darkgrey">Application Service: </span><span id="app-service-modal-subject" class="text-primary">{{{appService.link}}}</span></strong></p>
							<p>{{appService.description}}</p>
							<div class="row">
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-check-circle right-5"/>Select Planned Change:</p>
									<select id="appServiceModalPlanningActionList" class="select2" style="width: 100%;">
										{{#each planningActions}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
								</div>
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-edit right-5"/>Planning Notes:</p>
									<textarea id="appServicePlanNotes" class="form-control" placeholder="Enter notes to explain rationale for the planning action">{{appService.planningNotes}}</textarea>
								</div>
							</div>
							
							
							<div class="clearfix bottom-15"></div>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-xs-12">
									<p class="impact large"><i class="fa fa-bullseye right-5"/>Impacted Objectives</p>
									<ul class="multi-column-list">
										{{#each appService.objectives}}
											<li>{{{link}}}</li>
										{{/each}}
									</ul>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-3">
									<p class="impact large"><i class="fa fa-cog right-5"/>Technical Health</p>
									<div class="gaugePanel">
										<div class="gaugeContainer top-10">
											<canvas id="appServiceModalTechHealth" style="width: 100%;" width="150" height="100"/>								
										</div>
										
									</div>
								</div>
								<div class="alignCentre col-md-3">
									<p class="impact large"><i class="fa fa-comments right-5"/>Customer Experience</p>
									<img height="180px">
										<xsl:attribute name="src">{{appService.overallScores.cxStyle.icon}}</xsl:attribute>
									</img>								
									
								</div>
								<div class="alignCentre col-md-3">
									<p class="impact large"><i class="fa fa-concierge-bell-alt right-5"/>Customer Service</p>
									<div class="gaugePanel">
										<div class="gaugeContainer top-10">
											<canvas id="appServiceModalCustSvcGauge" style="width: 100%;" width="150" height="100"/>								
										</div>
										
									</div>
								</div>
								<div class="alignCentre col-md-3">
									<p class="impact large"><i class="fa fa-brain right-5"/>Customer Emotions</p>
									<img height="180px">
										<xsl:attribute name="src">{{appService.overallScores.emotionStyle.emoji}}</xsl:attribute>
									</img>
									
								</div>
								<div class="clearfix"/>
								<div class="col-xs-3">
									{{#if appService.overallScores.kpiPercent}}
										<div class="gaugeLabel strong">{{appService.techHealthScore}}%</div>
									{{else}}
										<div class="gaugeLabel strong">Undefined</div>
									{{/if}}
								</div>
								<div class="col-xs-3">
									<div class="gaugeLabel strong">{{appService.overallScores.cxStyle.label}}</div>
								</div>
								<div class="col-xs-3">
									{{#if appService.overallScores.kpiPercent}}
										<div class="gaugeLabel strong">{{appService.overallScores.kpiPercent}}%</div>
									{{else}}
										<div class="gaugeLabel strong">Undefined</div>
									{{/if}}
								</div>
								<div class="col-xs-3">
									<div class="gaugeLabel strong">{{appService.overallScores.emotionStyle.label}}</div>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12">
									<div class="row">
										<div class="col-xs-12">
											<p class="impact large"><i class="fa fa-chevron-right right-5"/>Supported Value Streams</p>
											<p class="small pull-left">
												<em>Select a Value Stream to view relevant Processes and Applications</em>
											</p>
											<div class="pull-right">
												<span class="right-10"><strong>Heatmap:</strong></span>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="appServiceHeatmapRadio" value="cx" checked="checked"/>
													Customer Experience
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="appServiceHeatmapRadio" value="emotion"/>
													Customer Emotion
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="appServiceHeatmapRadio" value="kpi"/>
													Customer Service
												</label>
											</div>
										</div>
									</div>							
									<select id="appServiceValueStreamsList" style="width:300px;" class="select2">
										{{#each appService.valueStreams}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
									<div class="clearfix"/>
									<!-- VALUE STAGES CONTAINER -->
									<div id="appServiceValueStagesContainer" class="top-15"/>	
								</div>
								<div class="col-xs-12"><hr/></div>
								<div id="appServiceModalPhysProcsTBody" class="col-md-12"/>
								<div id="appServiceModalServiceTBody" class="col-md-12"/>		
							</div>
						</div>
						<div class="modal-footer">
							{{#if modalHistory.length}}
								<button type="button" class="modalCloseAllBtn btn btn-danger">Close All</button>
							{{/if}}
							<button type="button" class="btn btn-success" data-dismiss="modal">{{#if modalHistory.length}}Back{{else}}Close{{/if}}</button>
						</div>
					</script>
					
					<!-- Application Service Modal -->
					<div class="modal fade" id="appServiceModal" tabindex="-1" role="dialog" aria-labelledby="appServiceModalLabel">
						<div class="modal-dialog modal-xl" role="document">
							<div class="modal-content" id="appServiceModelContent"/>						
						</div>
					</div>
					
					
					<!-- Handlebars template for the contents of the Application Modal -->
					<script id="app-modal-content-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title xlarge" id="appModalLabel"><strong><span class="text-darkgrey">Application: </span><span id="app-modal-subject" class="text-primary">{{{application.link}}}</span></strong></p>
							<p>{{application.description}}</p>
							<div class="row">
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-check-circle right-5"/>Select Planned Change:</p>
									<select id="appModalPlanningActionList" class="select2" style="width: 100%;">
										{{#each planningActions}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												<!--<xsl:attribute name="selected">{{#if isSelected}}selected{{/if}}</xsl:attribute>-->
												{{name}}
											</option>
										{{/each}}
									</select>
								</div>
								<div class="col-md-6">
									<p class="impact large textColourRed"><i class="fa fa-edit right-5"/>Planning Notes:</p>
									<textarea id="appPlanNotes" class="form-control" placeholder="Enter notes to explain rationale for the planning action">{{application.planningNotes}}</textarea>
								</div>
							</div>	
							<div class="clearfix bottom-15"></div>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-md-3">
									<p class="impact large"><i class="fa fa-cog right-5"/>Technical Health</p>
									<!--<p class="subtitle textColourGreen">8/10</p>-->
									<div class="gaugePanel">
										<div class="gaugeContainer top-10">
											<canvas id="appModalTechHealth" style="width: 100%;" width="200" height="100"/>								
										</div>
										
									</div>
								</div>
								<div class="col-md-5">
									<p class="impact large"><i class="fa fa-bullseye right-5"/>Impacted Objectives</p>
									<ul>
										{{#each application.objectives}}
											<li>{{{link}}}</li>
										{{/each}}
									</ul>
								</div>
								<div class="col-md-4">
									<p class="impact large"><i class="fa fa-users right-5"/>Organisation Users</p>
									<ul>
										{{#each application.organisations}}
											<li>{{{link}}}</li>
										{{/each}}
									</ul>
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12">
									<div class="row">
										<div class="col-xs-12">
											<p class="impact large"><i class="fa fa-chevron-right right-5"/>Supported Value Streams</p>
											<p class="small pull-left">
												<em>Select a Value Stream to view supported Processes</em>
											</p>
											<div class="pull-right">
												<span class="right-10"><strong>Heatmap:</strong></span>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="appHeatmapRadio" value="cx" checked="checked"/>
													Customer Experience
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="appHeatmapRadio" value="emotion"/>
													Customer Emotion
												</label>
												<label class="radio-inline">
													<input type="radio" name="modalVSHeatmapRadioOptions" id="appHeatmapRadio" value="kpi"/>
													Customer Service
												</label>
											</div>
										</div>
									</div>							
									<select id="appValueStreamsList" style="width:300px;" class="select2">
										{{#each application.valueStreams}}
											<option>
												<xsl:attribute name="value">{{id}}</xsl:attribute>
												{{name}}
											</option>
										{{/each}}
									</select>
									<div class="clearfix"/>
									<!-- VALUE STAGES CONTAINER -->
									<div id="appValueStagesContainer" class="top-15"/>	
								</div>
								<div class="col-xs-12"><hr/></div>
								<div class="col-md-12" id="appModalPhysProcsTBody"/>
								<div id="appModalServiceTBody" class="col-md-12"/>							
							</div>
						</div>
						<div class="modal-footer">
							{{#if modalHistory.length}}
								<button type="button" class="modalCloseAllBtn btn btn-danger">Close All</button>
							{{/if}}
							<button type="button" class="btn btn-success" data-dismiss="modal">{{#if modalHistory.length}}Back{{else}}Close{{/if}}</button>
							<!--<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
							<button id="appModalSaveBtn" type="button" class="btn btn-success">Save Changes</button>-->
						</div>
					</script>
					
						<!-- Application Dashboard Modal -->
						<div class="modal fade" id="appModal" tabindex="-1" role="dialog" aria-labelledby="appModalLabel">
							<div class="modal-dialog modal-xl" role="document">
								<div class="modal-content" id="appModelContent"/>						
							</div>
						</div>
					
					
					<!-- Handlebars template for the contents of the Strategic Plan Errors Modal -->
					<script id="strat-plan-errors-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title large text-darkgrey"><strong>{{title}}</strong></p>
						</div>
						<div class="modal-body">
							<p class="textColourRed">Missing {{#each messages}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}</p>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
						</div>
					</script>
					
					<!-- Strategic Plan Error Modal -->
					<div id="stratPlanErrorModal" class="modal fade" tabindex="-1" role="dialog">
						<div class="modal-dialog" role="document">
							<div id="stratPlanErrorModalList" class="modal-content"/>			
						</div>
					</div>
					<!--ENDS-->
					
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Strategy Planner')"/></span>
									<span id="roadmapNameTitle" class="text-primary"/>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="workflowNavigation">
								<div class="workflowStep" id="step1" onclick="menuSelect(1)">
									<div class="workflowID bg-black">1</div>
									<div class="worksflowTitle bg-darkgrey">Introduction</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div> 
								<div class="workflowStep" id="step2" onclick="menuSelect(2);setTimeout(initRoadmapScopeView, 600);">
									<div class="workflowID bg-black">2</div>
									<div class="worksflowTitle bg-lightgrey">Define Roadmap Scope</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
								<div class="workflowStep" id="step3" onclick="menuSelect(3);clearGraphModel();setTimeout(initStrategicPlansView, 600);">
									<div class="workflowID bg-black">3</div>
									<div class="worksflowTitle bg-lightgrey">Define Strategic Plans</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
								<div class="workflowStep" id="step4" onclick="menuSelect(4);setTimeout(initRoadmapGantt, 600);">
									<div class="workflowID bg-black">4</div>
									<div class="worksflowTitle bg-lightgrey">Define Roadmap</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
								<div class="workflowStep" id="step5" onclick="menuSelect(5);setTimeout(initRoadmapExcel, 600);">
									<div class="workflowID bg-black">5</div>
									<div class="worksflowTitle bg-lightgrey">Export Roadmap</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
							</div>
							<div class="clearfix"/>
							<div class="workFlowContent top-20" id="step1Content">
								<xsl:call-template name="introPage"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step2Content">
								<xsl:call-template name="RenderRoadmapScopeSection"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step3Content">
								<xsl:call-template name="RenderStrategicPlansSection"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step4Content">
								<xsl:call-template name="RenderRoadmapSection"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step5Content">
								<xsl:call-template name="RenderResultsSection"/>
							</div>
							<xsl:if test="not($eipMode)">
								
							</xsl:if>
						</div>			
						<div class="col-xs-12">
							<hr/>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
					});
				</script>
			</body>
			<!-- Excel handlebars template -->
			<xsl:call-template name="excelHandlebars"/>
		</html>
	</xsl:template>
	
	
	<xsl:template name="introPage">
		<h2 class="text-primary bottom-15">Welcome to the Strategy Planner</h2>
		<p class="lead"><strong>This report assists you in the definition of an architecture strategy as a Roadmap of Strategic Plans.</strong></p>
		<div class="appSelection dashboardPanel bg-offwhite bottom-30 pull-left">
			<p class="lead">Please provide a name and description for the Roadmap to be defined.</p>
			<label for="roadmapNameInput" class="impact top-20">Roadmap Name:</label>
			<input id="roadmapNameInput" class="form-control bottom-10" placeholder="Enter a name"/>
			<label for="roadmapDescInput" class="impact">Description:</label>
			<textarea id="roadmapDescInput" class="form-control bottom-10" placeholder="Enter a description"/>
		</div>
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE STRATEGIC PLAN CONFIGURATION SECTION -->
	<xsl:template name="RenderRoadmapScopeSection">
		<!-- Handlebars template to render a strategic goal -->
		<script id="strategic-goal-template" type="text/x-handlebars-template">
			{{#goals}}
				<div class="goal_Outer">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<div class="goal_Box">
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_inner</xsl:text></xsl:attribute>
						<div class="blob_Label">
							<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_label</xsl:text></xsl:attribute>
							{{{link}}}
						</div>
						<i class="fa fa-info-circle infoButton"/>
						<div class="hiddenDiv">
							<i class="fa fa-bullseye right-5"/><span class="impact">Objectives</span>
							<ul>
								{{#each objectives}}
									<li>
										<xsl:attribute name="class">{{#unless inScope}}text-lightgrey{{/unless}}</xsl:attribute>
										{{{link}}}
									</li>
								{{/each}}
							</ul>
						</div>
					</div>
				</div>
			{{/goals}}
		</script>
		
		
		<!-- Handlebars template to render the list of value streams -->
		<script id="value-streams-list-template" type="text/x-handlebars-template">
			<option/>
			{{#valueStreams}}
		  		<option>
		  			<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
		  			{{name}}
		  		</option>
			{{/valueStreams}}
		</script>
		
		<!-- Handlebars template to render value stages -->
		<script id="value-stage-template" type="text/x-handlebars-template">
			{{#valueStages}}
				<div>
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<xsl:attribute name="class">threeColModel_valueChainColumnContainer pull-left {{styleClass}}</xsl:attribute>
					<div class="threeColModel_valueChainObject small backColour18">
						<span class="text-white">{{{link}}}</span>
					</div>
				</div>
			{{/valueStages}}
		</script>
		
		
		<!-- Handlebars template to render value stages in modals -->
		<script id="modal-value-stage-template" type="text/x-handlebars-template">
			{{#valueStages}}
				<div>
					<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<xsl:attribute name="class">threeColModel_modalValueChainColumnContainer pull-left {{styleClass}}</xsl:attribute>
					<div class="threeColModel_valueChainObject small backColour18">
						<span class="text-white">{{{link}}}</span>
					</div>
				</div>
			{{/valueStages}}
		</script>
		
		
		<!-- Handlebars template to render the BCM -->
		<script id="bcm-template" type="text/x-handlebars-template">
			<div class="row">
				<div class="col-xs-12">
					<h3 class="pull-left">{{{l0BusCapLink}}} Capabilities</h3>
					<div class="keyContainer pull-right">
						<div class="keyLabel">Strategic Impact:</div>
						<div class="keySampleWide bg-aqua-100"/>
						<div class="keySampleLabel">High</div>
						<div class="keySampleWide bg-aqua-60"/>
						<div class="keySampleLabel">Medium</div>
						<div class="keySampleWide bg-aqua-20"/>
						<div class="keySampleLabel">Low</div>
						<span class="left-10"><i class="fa fa-flag right-5"/>Differentiator</span>
					</div>
				</div>
			</div>
			
			{{#each l1BusCaps}}					
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer">
							<div class="refModel-l0-title fontBlack large">
								{{{busCapLink}}}
							</div>
							{{#l2BusCaps}}
								<!--<a href="#" class="text-default">-->
								<div class="busRefModel-blobWrapper">
									<div class="busRefModel-blob busRefModel-blob-noheatmap">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{busCapLink}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_info</xsl:text></xsl:attribute>									
										</div>
									</div>
									<div class="busRefModel-blobAnnotationWrapper">
										<div class="blobAnnotationL">{{#if isDifferentiator}}<i class="fa fa-flag"></i>{{/if}}</div>
										<div>
											<xsl:attribute name="class">blobAnnotationC {{stratImpactStyle}}</xsl:attribute>
											{{stratImpactLabel}}
										</div>
										<div class="blobAnnotationR">
											<i class="fa fa-info-circle text-midgrey bus-cap-info" data-toggle="modal" data-target="#busCapModal">
												<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{busCapId}}</xsl:text></xsl:attribute>
											</i>
											<!--<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_popup</xsl:text></xsl:attribute>												
												<small>
													<p>{{busCapDescription}}</p>
													<h4>Details</h4>
													<table class="table table-striped table-condensed small">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																<th class="cellWidth-140"><xsl:value-of select="eas:i18n('Application Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_app_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>
												</small>
											</div>-->
										</div>
									</div>
								</div>
								<!--</a>-->
							{{/l2BusCaps}}
							<div class="clearfix"/>
						</div>
						{{#unless @last}}
							<div class="clearfix bottom-10"/>
						{{/unless}}
					</div>
				</div>
			{{/each}}				
		</script>
		
		
		<!-- Handlebars template to render an application popup -->
		<script id="application-card-template" type="text/x-handlebars-template">
			
		</script>
		
		<!-- Handlebars template to render an application provider role popup -->
		<script id="app-service-card-template" type="text/x-handlebars-template">
			
		</script>
		
		<!-- Handlebars template to render a business process popup -->
		<script id="bus-process-card-template" type="text/x-handlebars-template">
			
		</script>
		
		<!-- Handlebars template to render an organisation popup -->
		<script id="organisation-card-template" type="text/x-handlebars-template">

		</script>
		
		<!-- Handlebars template to render strategic plan details -->
		<script id="strat-plan-details-template" type="text/x-handlebars-template">
			<small>
				<h4>Planned Changes</h4>
				<table class="table table-striped table-condensed small">
					<thead>
						<tr>
							<th class="cellWidth-10pc"><xsl:value-of select="eas:i18n('Type')"/></th>
							<th class="cellWidth-20pc"><xsl:value-of select="eas:i18n('Name')"/></th>
							<th class="cellWidth-30pc"><xsl:value-of select="eas:i18n('Description')"/></th>
							<th class="cellWidth-15pc"><xsl:value-of select="eas:i18n('Planned Change')"/></th>
							<th class="cellWidth-25pc"><xsl:value-of select="eas:i18n('Rationale')"/></th>
						</tr>
					</thead>
					<tbody>
						{{#each changedElements}}
							<tr>
								<td>{{type.label}}</td>
								<td>{{{link}}}</td>
								<td>{{description}}</td>
								<td>
									<button class="btn btn-sm btn-primary pl_action_button">
										{{planningAction.name}}				
									</button>
								</td>
								<td>{{planningNotes}}</td>
							</tr>
						{{/each}}
					</tbody>
				</table>
			</small>
		</script>
		
		<!-- Handlebars template to render a no change button -->
		<script id="no-action-button-template" type="text/x-handlebars-template">
			<button class="btn btn-sm btn-default pl_action_button" data-toggle="modal">
				<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
				<xsl:attribute name="eas-index">{{index}}</xsl:attribute>
				<xsl:attribute name="data-target">#{{editorId}}</xsl:attribute>
				No Change			
			</button>
		</script>
		
		<!-- Handlebars template to render a planning action button -->
		<script id="planning-action-button-template" type="text/x-handlebars-template">
			<button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal">
				<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
				<xsl:attribute name="eas-index">{{index}}</xsl:attribute>
				<xsl:attribute name="data-target">#{{editorId}}</xsl:attribute>
				{{planningAction.name}}
			</button>
		</script>

		<!-- Handlebars template to render the roadmap data in json format for exporting as Excel -->
		<script id="roadmap-excel-json-template" type="text/x-handlebars-template">
			{
				"roadmap": {
					"id": 1,
					"name":"Roadmap",
					"worksheetNameNice":"Roadmap",
					"worksheetName":"Roadmap",
					"description":"The Roadmap that has been created",
					"heading":[
						{"col":"B", "name":"Id"},
						{"col":"C", "name":"Name"},
						{"col":"D", "name":"Description"}
					],
					"data": [
						{
							"row": 8,
							"id": "{{roadmap.extId}}",
							"name": "{{roadmap.name}}",
							"description": "{{roadmap.description}}"
						}
					]
				},
				"strategicPlans": {
					"id": 2,
					"name":"Strategic Plans",
					"worksheetNameNice":"Strategic Plans",
					"worksheetName":"Strategic_Plans",
					"description":"The strategic plans contained in the Roadmap",
					"heading":[
						{"col":"B", "name":"Roadmap"}, 
						{"col":"C", "name":"Name"},
						{"col":"D", "name":"Description"},
						{"col":"E", "name":"StartDate"},
						{"col":"F", "name":"EndDate"}
					],
					"data": [
						{{#each strategicPlans}}
							{{#unless @first}},{{/unless}}
							{
								"row": {{add @index 8 0}},
								"roadmap": "{{../roadmap.name}}",
								"name": "{{name}}",
								"description": "{{description}}",
								"startdate": "{{excelStartDate}}",
								"enddate": "{{excelEndDate}}"
							}
						{{/each}}
					]
				},
				"stratPlanObjectives": {
					"id": 3,
					"name":"Strategic Plan Objectives",
					"worksheetNameNice":"Strategic Plan Objectives",
					"worksheetName":"Strategic_Plan_Objectives",
					"description":"Maps Strategic Plans to the Objectives that they support",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"SupportedObjective"}
					],
					"data": []
				},
				"stratPlanDependencies": {
					"id": 4,
					"name":"Strategic Plan Dependencies",
					"worksheetNameNice":"Strategic Plan Dependencies",
					"worksheetName":"Strategic_Plan_Dependencies",
					"description":"Define the dependencies between Strategic Plans",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"DependsOnPlan"}
					],
					"data": []
				},
				"plannedAppChanges": {
					"id": 5,
					"name":"Application Planning Actions",
					"worksheetNameNice":"Application Planning Actions",
					"worksheetName":"Application_Planning_Actions",
					"description":"The changes that are planned to Applications",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedApplication"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				},
				"plannedAppServiceChanges": {
					"id": 6,
					"name":"Application Service Planning Actions",
					"worksheetNameNice":"Application Service Planning Actions",
					"worksheetName":"Application_Service_Planning_Actions",
					"description":"The changes that are planned to Application Services",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedApplicationService"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				},
				"plannedBusProcChanges": {
					"id": 7,
					"name":"Business Process Planning Actions",
					"worksheetNameNice":"Business Process Planning Actions",
					"worksheetName":"Business Process_Planning_Actions",
					"description":"The changes that are planned to Business Processes",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedBusinessProcess"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				},
				"plannedOrgChanges": {
					"id": 8,
					"name":"Organisation Planning Actions",
					"worksheetNameNice":"Organisation Planning Actions",
					"worksheetName":"Organisation_Planning_Actions",
					"description":"The changes that are planned to Organisations",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedOrganisation"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				}
			}
		</script>

		
		<!-- Render the Strategic Plan Configuration HTML -->
		<div class="row">
			
		
			<div class="col-xs-12">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Strategic Goals and Objectives')"/></h3>
				<div class="dashboardPanel bg-offwhite">
					<!-- STRATEGIC GOALS CONTAINER -->
					<div id="goalsContainer"/>					
				</div>
				<div class="clearfix"></div>

				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Value Streams')"/></h3>
				<div class="dashboardPanel bg-offwhite">
					<div class="row">
						<div class="col-xs-12">
							<p class="small pull-left">
								<em>Select a Value Stream to view Business Capability heatmap</em>
							</p>
							<div class="pull-right">
								<span class="right-10"><strong>Heatmap:</strong></span>
								<label class="radio-inline">
									<input type="radio" name="vsHeatmapRadioOptions" id="vsHeatmapRadioCx" value="cx" checked="checked"/> Customer Experience
								</label>
								<label class="radio-inline">
									<input type="radio" name="vsHeatmapRadioOptions" id="vsHeatmapRadioEm" value="emotion"/> Customer Emotion
								</label>
								<label class="radio-inline">
									<input type="radio" name="vsHeatmapRadioOptions" id="vsHeatmapRadioKpi" value="kpi"/> Customer Service
								</label>
							</div>
						</div>
					</div>
					
					<select id="valueStreamsList" style="width:100%;"/>
					<div class="clearfix"/>
					<!-- VALUE STAGES CONTAINER -->
					<div id="valueStagesContainer" class="top-15"/>					
				</div>
				<div class="clearfix"></div>
				
				
				<div class="clearfix"></div>
			</div>
		
			<div class="col-xs-12 col-md-8">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Business Capabilities')"/></h3>
				<div class="dashboardPanel bg-offwhite equalHeight1">
					<!-- BUSINESS CAPABILITY MODEL CONTAINER -->
					<div class="simple-scroller" id="bcmContainer"/>					
				</div>
			</div>
			<div class="col-xs-12 col-md-4">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Selected Scope')"/></h3>
				<div class="dashboardPanel equalHeight1">	
					<!-- ELEMENT SELECTOR AND STRATEGIC PLAN CONFIGURATION FORM -->
					<div class="form-group">
						<!--<label for="stratPlanName" class="impact">Name:</label>
						<input id="stratPlanName" class="form-control bottom-10" placeholder="Enter a name"/>
						<label for="stratPlanDesc" class="impact">Description:</label>
						<textarea id="stratPlanDesc" class="form-control bottom-10" placeholder="Enter a description"/>-->
						<!--<p class="scopeHeading text-primary">Objectives</p>
						<table id="stratPlanObjsTable" class="table table-striped table-condensed small">
							<thead>
								<tr>
									<th class="text-center">&#160;</th>
									<th>Objective</th>
									<th>Target Date</th>
								</tr>
							</thead>
							<tbody/>
							<tfoot>
								<th>&#160;</th>
								<th>Objectives</th>
								<th>Date</th>
							</tfoot>
						</table>-->
						
						<div class="top-10 bottom-10">
							<!-- Nav tabs -->
							<ul class="nav nav-tabs" role="tablist">
								<li role="presentation" class="active"><a href="#processesTab" aria-controls="home" role="tab" data-toggle="tab">Processes</a></li>
								<li role="presentation"><a href="#appsTab" aria-controls="profile" role="tab" data-toggle="tab" onclick="setTimeout(drawStrategicPlanAppProRolesTable, 300);">Applications</a></li>
							</ul>
							
							<!-- Tab panes -->
							<div class="tab-content">
								<div role="tabpanel" class="tab-pane active" id="processesTab">
									<div class="clearfix top-15"></div>
									<table id="stratPlanPhysProcsTable" class="table table-striped table-condensed small">
										<thead>
											<tr>
												<th>Process</th>
												<th>&#160;</th>
												<th>Organisation</th>
												<th>&#160;</th>
											</tr>
										</thead>
										<tbody>
											<!--<tr>
												<td>Make Tea</td>
												<td><button class="btn btn-sm btn-default pl_action_button" data-toggle="modal" data-target="#myModal">No Change</button></td>
												<td>Brewmeister General</td>
												<td>
													<button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal" data-target="#myModal">Reduce</button></td>
											</tr>
											<tr>
												<td>Prepare Bread</td>
												<td><button class="btn btn-sm btn-default pl_action_button" data-toggle="modal" data-target="#myModal">No Change</button></td>
												<td>Master Baker</td>
												<td><button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal" data-target="#myModal">Reduce</button></td>
											</tr>
											<tr>
												<td>Serve Sandwich</td>
												<td><button class="btn btn-sm btn-default pl_action_button" data-toggle="modal" data-target="#myModal">No Change</button></td>
												<td>Sandwich Man</td>
												<td><button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal" data-target="#myModal">Reduce</button></td>
											</tr>-->
										</tbody>
										<tfoot>
											<tr>
												<th>&#160;</th>
												<th>&#160;</th>
												<th>&#160;</th>
												<th>&#160;</th>
											</tr>
										</tfoot>	
									</table>
								</div>
								<div role="tabpanel" class="tab-pane" id="appsTab">
									<table id="stratPlanAppProRolesTable" class="table table-striped table-condensed small">
										<thead>
											<tr>
												<th>Application</th>
												<th>&#160;</th>
												<th>Service</th>
												<th>&#160;</th>
											</tr>
										</thead>
										<tbody>
											<!--<tr>
												<td>App 1</td>
												<td>
													<button class="btn btn-sm btn-default pl_action_button" data-toggle="modal" data-target="#myModal">
														No Change
														
													</button>
												</td>
												<td>Service 1</td>
												<td><button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal" data-target="#myModal">Reduce</button></td>
											</tr>
											<tr>
												<td>App 2</td>
												<td><button class="btn btn-sm btn-default pl_action_button" data-toggle="modal" data-target="#myModal">No Change</button></td>
												<td>Service 2</td>
												<td><button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal" data-target="#myModal">Reduce</button></td>
											</tr>
											<tr>
												<td>App 3</td>
												<td><button class="btn btn-sm btn-default pl_action_button" data-toggle="modal" data-target="#myModal">No Change</button></td>
												<td>Service 3</td>
												<td><button class="btn btn-sm btn-primary pl_action_button" data-toggle="modal" data-target="#myModal">Reduce</button></td>
											</tr>-->
										</tbody>
										<tfoot>
											<tr>
												<th>Application</th>
												<th>&#160;</th>
												<th>Service</th>
												<th>&#160;</th>
											</tr>
										</tfoot>
									</table>
								</div>
							</div>
						</div>
						
						<!--<button id="createStratPlanBtn" class="btn btn-success">Create Plan</button>
						<button id="resetStratPlanBtn" class="btn btn-danger pull-right">Reset Plan</button>-->
					</div>
				</div>
			</div>
		</div>
		<!--<div class="row">
			<div class="col-xs-12 col-md-12">
				<h3 class="section-title bg-black">Strategic Plans</h3>
				<div class="dashboardPanel">
						<table class="table table-striped table-bordered" id="dt_stratPlanList">
							<thead>
								<tr>
									<th></th>
									<th>
										<xsl:value-of select="eas:i18n('Strategic Plan Name')"/>						
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Supported Objectives')"/>									
									</th>
								</tr>
							</thead>
							<tbody/>
							<tfoot>
								<tr>
									<th></th>
									<th>
										<xsl:value-of select="eas:i18n('Name')"/>						
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Supported Objectives')"/>									
									</th>
								</tr>
							</tfoot>
							<tbody/>									
						</table>	
				</div>
			</div>
		</div>-->
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE STRATEGIC PLAN CONFIGURATION SECTION -->
	<xsl:template name="RenderStrategicPlansSection">
		<div class="row">
			<div class="col-xs-12 col-md-4">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('New Strategic Plan')"/></h3>
				<div class="dashboardPanel">	
					<!-- ELEMENT SELECTOR AND STRATEGIC PLAN CONFIGURATION FORM -->
					<div class="form-group">
						<label for="stratPlanName" class="text-primary impact">Name*</label>
						<input id="stratPlanName" class="form-control bottom-10" placeholder="Enter a name"/>
						<label for="stratPlanDesc" class="text-primary impact">Description</label>
						<textarea id="stratPlanDesc" class="form-control bottom-10" placeholder="Enter a description"/>
						<p class="scopeHeading text-primary">Supported Objectives*</p>
						<table id="stratPlanObjsTable" class="table table-striped table-condensed small">
							<thead>
								<tr>
									<th class="text-center">&#160;</th>
									<th>Objective</th>
									<th>Target Date</th>
								</tr>
							</thead>
							<tbody/>
							<tfoot>
								<th>&#160;</th>
								<th>Objectives</th>
								<th>Date</th>
							</tfoot>
						</table>
						<p class="scopeHeading text-primary">Plan Elements*</p>
						<table id="stratPlanElementsTable" class="table table-striped table-condensed small">
							<thead>
								<tr>
									<th>Type</th>
									<th>Name</th>
									<th>Change</th>
								</tr>
							</thead>
							<tbody/>
							<tfoot>
								<th>Type</th>
								<th>Name</th>
								<th>Change</th>
							</tfoot>
						</table>
						<div class="top-10 bottom-10"/>
						<button id="createStratPlanBtn" class="btn btn-success">Create Plan</button>
						<button id="resetStratPlanBtn" class="btn btn-danger pull-right">Reset Plan</button>
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-md-8">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Roadmap Scope')"/></h3>
				<div class="dashboardPanel bg-offwhite">
					<div class="simple-scroller" id="modelGraphContainer">
						<xsl:call-template name="RenderModelGraphSVG"/>
					</div>	
				</div>
				<div class="clearfix"/>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12 col-md-12">
				<h3 class="section-title bg-black">Strategic Plans</h3>
				<div class="dashboardPanel">
					<table class="table table-striped table-bordered" id="dt_stratPlanList">
						<thead>
							<tr>
								<th></th>
								<th>
									<xsl:value-of select="eas:i18n('Strategic Plan Name')"/>						
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Supported Objectives')"/>									
								</th>
							</tr>
						</thead>
						<tbody/>
						<tfoot>
							<tr>
								<th></th>
								<th>
									<xsl:value-of select="eas:i18n('Name')"/>						
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Supported Objectives')"/>									
								</th>
							</tr>
						</tfoot>
						<tbody/>									
					</table>	
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE ROAMDAP TIMELINES SECTION -->
	<xsl:template name="RenderRoadmapSection">
		<script id="gantt-strat-plan-details-template" type="text/x-handlebars-template">
			<p class="impact large selected-gantt-title">Strategic Plan Details</p>
			<p><label>Name: </label><span>{{name}}</span></p>
			<div class="simple-scroller" style="height: 360px;">
				<div><label>Description: </label><span>{{description}}</span></div>
				<div><label>Start Date: </label><span>{{displayStartDate}}</span><br/><label>End Date: </label><span>{{displayEndDate}}</span></div>			
				<div><label>Supported Objectives: </label></div>
				{{#if objectives.length}}
				<ul>
					{{#each objectives}}
						<li>{{{link}}}</li>
					{{/each}}
				</ul>
				{{else}}
					<em>No objectives defined</em>
				{{/if}}
				<div><label>Planned Changes: </label></div>
				<table id="stratPlanElementsTable" class="table table-striped table-condensed small">
					<thead>
						<tr>
							<th>Type</th>
							<th>Name</th>
							<th>Change</th>
						</tr>
					</thead>
					<tbody>
						{{#each changedElements}}
							<tr>
								<td>{{type.label}}</td>
								<td>{{{link}}}</td>
								<td><span class="impact">{{planningAction.name}}</span></td>
							</tr>
						{{/each}}
					</tbody>
				</table>
			</div>
		</script>
		
		<div class="row">
			<div class="col-xs-12 col-md-12">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Roadmap Planner')"/></h3>
				<div class="row">
					<div class="col-md-10">
						<p class="large"><span class="impact">Name: </span><span id="roadmapNameLabel" class="text-primary impact"/></p>
						<p><span class="impact">Description: </span><span id="roadmapDescriptionLabel"/></p>
					</div>
					<xsl:if test="$eipMode">
						<div class="col-md-2">
							<div class="pull-right">
								<button id="createRoadmapBtn" disabled="true" class="btn bg-darkgreen-100">Create Roadmap</button>
							</div>
						</div>
					</xsl:if>
				</div>
				<div class="row">
					<div class="col-sm-6 col-md-8 col-lg-9">
						<div class="dashboardPanel bg-offwhite" style="height: 451px;">	
							<!-- ROADMAP COMPONENT -->
							<div id="roadmap-gantt" style='width:100%; height:400px;'></div>
						</div>
					</div>
					<div class="col-sm-6 col-md-4 col-lg-3">
						<div id="ganttStratPlanContainer" class="dashboardPanel bg-offwhite" style="height: 451px;">	
							<p class="impact large">Strategic Plan Details</p>					
						</div>
					</div>
				</div>
				
			</div>
		</div>
	</xsl:template>
	
	<!-- TEMPLATE TO RENDER THE ROADMAP DOWNLOAD SECTION -->
	<xsl:template name="RenderResultsSection">
		<div class="row">
			<div class="col-xs-12 col-md-12">
				<h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Download Roadmap Content')"/></h3>
				<div class="dashboardPanel bg-white">
					<p><xsl:value-of select="eas:i18n('Click button to download roadmap data as spreadsheet')"/></p>
					<button id="exportRoadmapBtn" disabled="true" class="btn btn-primary">Export Data</button>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>