<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Composite_Application_Provider', 'Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="referenceLifecycleStatus" select="/node()/simple_instance[(type = 'Lifecycle_Status') and (own_slot_value[slot_reference = 'name']/value = 'Reference')]"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	
	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[own_slot_value[slot_reference = 'belongs_to_technology_domain']/value = $allTechDomains/name]"/>
	
	<xsl:variable name="allTechComposites" select="/node()/simple_instance[(type = 'Technology_Composite') and (own_slot_value[slot_reference = 'technology_component_lifecycle_status']/value = $referenceLifecycleStatus/name)]"/>
	<xsl:variable name="allTechCompArchitectures" select="/node()/simple_instance[name = $allTechComposites/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="allTechCompUsages" select="/node()/simple_instance[name = $allTechCompArchitectures/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
	<xsl:variable name="allTechCompRelations" select="/node()/simple_instance[name = $allTechCompArchitectures/own_slot_value[slot_reference = 'invoked_functions_relations']/value]"/>
	<xsl:variable name="allTechComponents" select="/node()/simple_instance[name = $allTechCompUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
	<xsl:variable name="allRelevantTechCaps" select="$allTechCaps[name = $allTechComponents/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value]"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[(own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComponents/name) and (own_slot_value[slot_reference = 'role_for_technology_provider']/value)]"/>
	<xsl:variable name="allTechProducts" select="/node()/simple_instance[name = $allTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="allTechProdSuppliers" select="/node()/simple_instance[name = $allTechProducts/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	
	<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
	<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[type = 'Standard_Strength']"/>
	<xsl:variable name="allStandardsStyles" select="/node()/simple_instance[name = $allStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	
	<xsl:variable name="allPerformanceMeasures" select="/node()/simple_instance[name = $allTechComposites/own_slot_value[slot_reference = 'performance_measures']/value]"/>
	<xsl:variable name="allServiceQualityVals" select="/node()/simple_instance[name = $allPerformanceMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value]"/>
	<xsl:variable name="allServiceQualities" select="/node()/simple_instance[name = $allServiceQualityVals/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
	
	
	<xsl:variable name="highScoreThreshold">60</xsl:variable>
	<xsl:variable name="medScoreThreshold">30</xsl:variable>
	
	<xsl:variable name="refArchTechCompWidth">90</xsl:variable>
	<xsl:variable name="refArchTechCompHeight">70</xsl:variable>
	<xsl:variable name="refArchTechCompColour">hsla(220, 70%, 95%, 1)</xsl:variable>
	<xsl:variable name="refArchTechCompStrokeColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	<xsl:variable name="refArchTechCompTextColour">#333333</xsl:variable>
	
	<xsl:variable name="defaultTPRWidth">140</xsl:variable>
	<xsl:variable name="defaultTPRHeight">100</xsl:variable>
	<xsl:variable name="defaultTechProdHeight">40</xsl:variable>
	
	<xsl:variable name="selectedTPRWidth">160</xsl:variable>
	<xsl:variable name="selectedTPRHeight">110</xsl:variable>
	<xsl:variable name="selectedTechProdHeight">50</xsl:variable>
	
	<xsl:variable name="nonCompliantStyleClass">backColourRed</xsl:variable>
	<xsl:variable name="nonCompliantColour">#CB0E3A</xsl:variable>
	
	<xsl:variable name="defaultTPRColour">#FFFFFF</xsl:variable>
	<xsl:variable name="defaultTPRStrokeColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	<xsl:variable name="defaultTPRTextColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	
	<xsl:variable name="selectedTPRColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	<xsl:variable name="selectedTPRStrokeColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	<xsl:variable name="selectedTPRTextColour">#FFFFFF</xsl:variable>
	
	<xsl:variable name="undefinedTechProdColour">#A6A6A6</xsl:variable>
	<xsl:variable name="techProdTextColour">#FFFFFF</xsl:variable>
	
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
	<!-- 11.05.2018 JP  Created	 -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent">
					<xsl:with-param name="requiresDataTables" select="false()"/>
				</xsl:call-template>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:call-template name="dataTablesLibrary"/>
				<link rel="stylesheet" type="text/css" href="js/DataTables/checkboxes/dataTables.checkboxes.css"/>
				<script src="js/DataTables/checkboxes/dataTables.checkboxes.min.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Standard Technology Product Selector')"/></title>
				
				<!--<xsl:call-template name="RenderGDPRDashboardJSLibraries"/>-->
				
				<script src="js/lightbox-master/ekko-lightbox.min.js"/>
				<link href="js/lightbox-master/ekko-lightbox.min.css" rel="stylesheet" type="text/css"/>
				<script type="text/javascript">
					$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
					    event.preventDefault();
					    $(this).ekkoLightbox({always_show_close: false});
					}); 
				</script>
				
				<!-- Start JointJS Diagramming Libraries and Styles-->
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>
				<script src="js/lodash/index.js"/>
				<script src="js/backbone/backbone.js"/>
				<script src="js/graphlib/graphlib.core.js"/>
				<script src="js/dagre/dagre.core.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/jointjs/ga.js" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.js"/>	

				<!-- Start Slider libraries and styles -->
				<script type="text/javascript" src="js/bootstrap-slider/bootstrap-slider.min.js"></script>
				<link rel="stylesheet" href="js/bootstrap-slider/bootstrap-slider.min.css"/>
				
				<!-- Start Service Quality Gauge library -->
				<script type="text/javascript" src="js/gauge.min.js"></script>
				
				<!-- Start Drag and Drop Libraries and Styles -->
				<script type="text/javascript" src="js/dragula/dragula.min.js"></script>
				<link rel="stylesheet" href="js/dragula/dragula.min.css"/>
				
				<!-- Start Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				
				<!-- Start Templating Libraries -->
				<script src="js/handlebars-v4.1.2.js"/>
				
				<style type="text/css">
					.Rect{
						pointer-events: none;
					}
					
					.leftPanel{
						width:  calc(50% - 10px);
						<!--margin-right: 15px;-->
						float: left;
					}
					
					.rightPanel{
						width: calc(50% - 10px);
						float: left;
					}
					
					.bottomPanel{
						width:100%;
						float: left;
					}
					
					.appSelection,
					.dataSelection{
						padding: 10px;
						width: 100%;
						min-height: 300px;
						float: left;
					}
					
					.workspace{
						width: 100%;
						min-height: 300px;
						float: left;
					}
					
					.dropspace{
						border: 2px dashed #aaa;
						padding: 5px;
						width: 100%;
						height: 40px;
						min-height: 60px;
						float: left;
					}
					
					.techArchitecture{
						height: 100%;
					}
					
					.section-title{
						padding: 5px;
						color: white;
					}
					
					.blob_Outer{
						width: 140px;
						float: left;
						margin: 0 15px 15px 0;
						box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
						opacity: 1;
    					-webkit-transition: opacity 1000ms linear;
    					transition: opacity 1000ms linear;
					}
					
					.blob_Box{
						width: 100%;
						height: 60px;
						padding: 5px;
						text-align: center;
						border-radius: 0px;
						<!--border: 1px solid #666;-->
						position: relative;
						display: table;
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
					
					.app-text, .org-text {
						color: hsla(320, 75%, 35%, 1);
					}
					
					.workspaceL0_Outer{
						width: 100%;
						float: left;
					}
					
					.workspaceL0{
						padding-left: 15px;
						border: 1px solid #666;
						border-radius: 4px;
						float: left;
						margin-bottom: 20px;
						position: relative;
						width: 100%;
						min-height: 100px;
					}
					
					.appScope{
						width: 100%;
						min-height: 200px;
					}
					
					.appDataContainer{
						width: 100%;
						min-height: 100px;
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
					
					.fa-chevron-right{
						position: absolute;
						top: 12px;
						right: 5px;
					}
					
					.eas-Node {
					    padding: 4px;
					    min-height: 40px;
					    border-radius: 0px;
					    width: 140px;
					    font-size: 10px;
					    text-align: center;
					    position: relative;
					    box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
					}
					
					.node-name { font-weight: bold; font-size: 12px;}
					
					.eas-Node > p {
						margin: 0;
					}
					
					
					#modal-custom header{
					  background: #eee;
					  margin-bottom: 10px;
					  overflow: hidden;
					  border-radius: 3px 3px 0 0;
					  width: 100%;
					}
					
					#modal-custom header a{
					  display: block;
					  float: left;
					  width: 50%;
					  padding: 0;
					  text-align: center;
					  background: #ddd;
					  color: #999;
					  height: 65px;
					  vertical-align: middle;
					  line-height: 65px;
					  font-family: 'Lato', arial;
					  font-size: 15px;
					  transition: all 0.3s ease;
					}
					
					#modal-custom header a:not(.active):hover{
					  box-shadow: inset 0 -10px 20px -10px #aaa
					} 
					
					#modal-custom header a.active{
					  background: #fff;
					  color: #777;
					}
					#modal-custom .sections{
					  overflow: hidden;
					}
					
					#modal-custom section{
					  padding: 30px;
					}
					
					#modal-custom section input:not([type="checkbox"]), #modal-custom section button{
					  width: 100%;
					  border-radius: 3px;
					  border: 1px solid #ddd;
					  margin-bottom: 26px;
					  padding: 15px;
					  font-size: 14px;
					}
					
					#modal-custom section button{
					  height: 46px;
					  padding: 0;
					}
					
					#modal-custom section input:focus{
					  border-color:#28CA97;
					}
					
					#modal-custom section label[for="countryList"]{
					  margin-bottom: 26px;
					  padding: 15px;
					  font-size: 14px;
					  color: #999;
					}
					
					#modal-custom section span{
					  margin-bottom: 26px;
					  font-size: 14px;
					  color: red;
					  display: block;
					}
					
					#modal-custom section footer{
					  overflow: hidden;
					}
					
					#modal-custom section button{
					  background: #28CA97;
					  color: white;
					  margin: 0;
					  border: 0;
					  cursor: pointer;
					  width: 50%;
					  float: left;
					}
					
					#modal-custom section button:hover{
					  opacity: 0.8;
					}
					
					#modal-custom section button:nth-child(1){
					  border-radius: 3px 0 0 3px;
					  background: #aaa;
					}
					
					#modal-custom section button:nth-child(2){
					  border-radius: 0 3px 3px 0;
					}
					
					#modal-custom .icon-close{
					  background: #FFF;
					  margin-bottom: 10px;
					  position: absolute;
					  right: -8px;
					  top: -8px;
					  font-size: 14px;
					  font-weight: bold;
					  border-radius: 50%;
					  width: 30px;
					  height: 30px;
					  border: 0;
					  color: #a9a9a9;
					  cursor: pointer;
					}
					
					#modal-custom .icon-close:hover, #modal-custom .icon-close:focus{
					  color: black;
					}
					
					#modal-custom.hasScroll .icon-close{
					  display: none;
					}
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
					
					.refModel-blob, .busRefModel-blob, .appRefModel-blob, .techRefModel-blob {
						width: 120px!important;
					}
					
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}
					
					.helpButton{
						position: absolute;
						z-index: 100;
						top: -60px;
						right: 15px;
						width: 200px;
						box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
					}

					
					table.dataTable tbody tr.selected {
					    color: #333333 !important;
					    background-color: <xsl:value-of select="$refArchTechCompColour"/> !important;
					}
					
					.xxsmall {font-size: 85%}
					.xxxsmall {font-size: 75%}
					
					
					#dt_selectedTechProds > tbody > tr > td > a {color: #0171C0!important;}
					
					#dt_appTechArchsExport > tbody > tr > td > a {color: #0171C0!important;}
					
					/********************************************************************/
					/*** SERVICE QUALITY GAUGE STYLES ***/
					.gaugePanel{
					  width: 40%;
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
				</style>
				
				<xsl:call-template name="refModelStyles"/>
				
				
				<script>
					$(document).ready(function(){					
						//INITIALISE THE DROP DOWN LISTS
						$('#techArchList').select2({
						    placeholder: "Select IT Solutions",
						    theme: "bootstrap"
						});									
					});
					
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
				
				<script>
					var currentAppTemplate, techArchListTemplate, serviceQualityFitSectionTemplate, serviceQualityFitTemplate, techCapBlobTemplate, techCapListTemplate, techCompListTemplate, techProdTemplate, techCompPopupTemplate, techProdPopupTemplate;
					
					var selectedAppId, selectedApp, selectedTechArchId, selectedTechArch, selectedTechCompId, selectedTechComp, selectedTechProdId;
					var selectedRefArchsTable, refArchListTable, selectedTechProdsTable, appTechArchsExportTable;
					var refArchGraph, refArchClusters, refArchRelations, graph, clusters, relations, selectedTechProdCell;
					var gaugeOpts;
					var newAppId = 1;
					
			
					var windowWidth = $(window).width()*2;
					var windowHeight = $(window).height()-150;
	
				    // the list of JSON objects representing the applications of the enterprise
					var applications = {
						applications: [
							{
								id: 'NEW',
								name: '<xsl:value-of select="eas:i18n('CREATE NEW SHARED PLATFORM')"/>',
								description: '<xsl:value-of select="eas:i18n('A Shared Platform that is yet to be implemented')"/>',
								link: '<span><xsl:attribute name="class">app-text</xsl:attribute><xsl:value-of select="eas:i18n('CREATE NEW SHARED PLATFORM')"/></span>',
								selected: false
							}<xsl:if test="count($allApps) > 0">,
							</xsl:if>
							<xsl:apply-templates select="$allApps" mode="getApplications">
								<xsl:sort><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:sort>
							</xsl:apply-templates>
						]
					};
					
					
					// the JSON objects for the list of Technology Capabilities
				    var techCapabilities = [
				    	<xsl:apply-templates mode="RenderTechCapabilityJSON" select="$allTechCaps">
				    		<xsl:sort><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:sort>
				    	</xsl:apply-templates>
				    ];
					
					// the JSON object structure for the Technology Reference Model (TRM)
				  	var trmData = {
				  		top: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		left: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		middle: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		right: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		bottom: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name]" mode="RenderTechDomains"/>
				  		]
				  	};
				    
				     // the JSON objects for the list of Technology Reference Architecture Patterns
				    var techArchPatterns = {
				    	techArchPatterns: [
				    		<xsl:apply-templates mode="RenderTechArchitecturePatternJSON" select="$allTechComposites">
				    			<xsl:sort><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:sort>
				    		</xsl:apply-templates>
				    	]
				    };
				    
				    //the JSON objects for thelist of technology service qualities
				    var techServiceQualities = {
				    	techServiceQualities: [
					    	<xsl:apply-templates mode="RenderTechSvcQualityJSON" select="$allServiceQualities">
					    		<xsl:sort><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:sort>
					    	</xsl:apply-templates>
					    ]
					};
				    
				    // the JSON objects for the list of Technology Components
				    var techComponents = [
				    	<xsl:apply-templates mode="RenderTechComponentJSON" select="$allTechComponents">
				    		<xsl:sort><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:sort>
				    	</xsl:apply-templates>
				    ];
				    
				    
				     // the JSON objects for the list of Compliance Levels
				    var complianceLevels = [
				    	<xsl:apply-templates mode="RenderComplianceLevelJSON" select="$allStandardStrengths">
				    		<xsl:sort><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:sort>
				    	</xsl:apply-templates>
				    ];
				    
				     //the list of ids fpr the Technology Capabilities that are relevant to the current scope
				    var selectedTechCapIds = [];
				    
				    //the list of ids for the Reference Architectures that are relevant to the current scope
				    var selectedRefArchIds =  [];
				    
				    //the JSON objects for the Technology Products that have been selected to implement Technology Architectures
				    var selectedTechProds = [];
				    
				    //the JSON objects for the export of the overall Application Technology Architecture
				    var appTechArchExport = [];
					  	
				  	
				  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
					
					
					<!-- START APPLICATION SELECTION FUNCTIONS -->
					function setCurrentApp(appId) {
						thisApp = getObjectById(applications.applications, "id", appId);
						selectedApp = thisApp;
						//console.log("Setting Current App Blob: " + thisApp.name);
						if(thisApp != null) {
							$("#app-selection").html(currentAppTemplate(thisApp));
						}
						$('.fa-info-circle').click(function() {
							$('[role="tooltip"]').remove();
						});
						$('.fa-info-circle').popover({
							container: 'body',
							html: true,
							trigger: 'click',
							placement: 'auto',
							content: function(){
								return $(this).next().html();
							}
						});
					}
					
					
					<!-- START SEVICE QUALITY FUNCTIONS -->
					//Function to set given weighting against a given service quality
					function setServiceQualityWeighting(serviceQualityId, weighting) {
						var aTSQ = getObjectById(techServiceQualities.techServiceQualities, 'id', serviceQualityId);
						aTSQ.weighting = weighting;
						//console.log('Changed Value of ' + aTSQ.name + ' to: ' + aTSQ.weighting);
					}
					
					
					//function to refresg the service quality weighting sliders
					function refreshServiceQualitySliders() {
						for (var i = 0; techServiceQualities.techServiceQualities.length > i; i += 1) {
							aTSQ = techServiceQualities.techServiceQualities[i];
							$('#' + aTSQ.id).bootstrapSlider('relayout');
						}
					}
				
					<!-- START REFERENCE ARCHITECTURE MODEL VARABLES AND FUNCTIONS -->				
					//function to test whether an element has a given class
					function hasClass(el, name) {
						return new RegExp('(?:^|\\s+)' + name + '(?:\\s+|$)').test(el.className);
					}
					
					//function to add a given class to an element
					function addClass(el, name) {
						if (!hasClass(el, name)) {
							el.className = el.className ? [el.className, name].join(' ') : name;
						}
					}
					
					//function to remove a given class from an element
					function removeClass(el, name) {
						if (hasClass(el, name)) {
							el.className = el.className.replace(new RegExp('(?:^|\\s+)' + name + '(?:\\s+|$)', 'g'), '');
						}
					}
					
					//Create a Reference Architecture Tech Product Role element
					function createRefArchCluster(aTechComp) {
						var strokeWidth = 2;
						var fillColour = "<xsl:value-of select="$refArchTechCompColour"/>";
						var strokeColour = "<xsl:value-of select="$refArchTechCompStrokeColour"/>";
						var textColour = "<xsl:value-of select="$refArchTechCompTextColour"/>";
						
					
						var newCluster = new joint.shapes.custom.Cluster({ 
							position: { 
								x: 100, 
								y: 20
							},
							size: { 
								width: <xsl:value-of select="$refArchTechCompWidth"/>,
								height: <xsl:value-of select="$refArchTechCompHeight"/> 
							},
							attrs: {
								techCompId: aTechComp.id,
								rect: { 
									'stroke-width': strokeWidth,
									fill: fillColour,
									stroke: strokeColour,
									rx: 15,
									ry: 15
								},
								text: { 
									text: wrapClusterName(aTechComp.name, 80, 100),
									fill: textColour,
									'font-weight': 'bold',
									'font-size': 12,
									'ref-x': .5,
			                        'ref-y': .5
								}
							}
						});
						
						return newCluster;
					};
					
					
					//function to render a given set of links between technology components
					function createRefArchLinks(inScopeLinks) {
						var aRelation, aLink;
						refArchRelations = [];
						for (var i = 0; inScopeLinks.length > i; i += 1) {
							aLink = inScopeLinks[i];
							aRelation = new joint.dia.Link({ 
							 	source: {
							 		id: refArchClusters[aLink.sourceRef].id
							 	},
							 	target: { 
						 			id: refArchClusters[aLink.targetRef].id 
						 		},
					 			attrs: {
						 			'.marker-target': {
						 					d: 'M 10 0 L 0 5 L 10 10 z',
						 					fill: '<xsl:value-of select="$refArchTechCompStrokeColour"/>',
											stroke: '<xsl:value-of select="$refArchTechCompStrokeColour"/>'
					 				},
					 				'.connection': {
					 					'stroke-width': 2,
					 					stroke: '<xsl:value-of select="$refArchTechCompStrokeColour"/>'
				 					},
				 					'.link-tools': {
				 						display : 'none'
				 					},
				 					'.marker-arrowheads': { 
				 						display: 'none'
				 					},
				 					'.connection-wrap': {
				 						display: 'none'
				 					}
				 				}
					    });
				 			refArchRelations.push(aRelation);			 			
				 		};
				 		_.each(refArchRelations, function(r) { refArchGraph.addCell(r); });
					}
					
					//Create a Reference Architecture Tech Product Role element
					function createCluster(aTechComp) {
						var strokeWidth = 1;
						//var fillColour = "#ed8000";
						var fillColour = "<xsl:value-of select="$defaultTPRColour"/>";
						var strokeColour = "<xsl:value-of select="$defaultTPRStrokeColour"/>";
						var textColour = "<xsl:value-of select="$defaultTPRTextColour"/>";
						
					
						var newCluster = new joint.shapes.custom.Cluster({ 
							position: { 
								x: 100, 
								y: 20
							},
							size: { 
								width: <xsl:value-of select="$defaultTPRWidth"/>,
								height: <xsl:value-of select="$defaultTPRHeight"/> 
							},
							attrs: {
								techCompId: aTechComp.id,
								rect: { 
									'stroke-width': strokeWidth,
									fill: fillColour,
									stroke: strokeColour 
								},
								text: { 
									text: wrapClusterName(aTechComp.name, 80, 100),
									fill: textColour,
									'font-weight': 'bold' 
								}
							}
						});
						
						return newCluster;
					};
					
					function createTechProdClusterBlock(aCluster) {
						var clusterXpos = aCluster.get('position').x + 0;
					 	var clusterYpos = aCluster.get('position').y + 60; 
					 	
					 	var blockFillColour = "<xsl:value-of select="$undefinedTechProdColour"/>";
						var blockText = 'Product Undefined';
						
						var existingSelectedTechProd = getExistingTechProdForTechArch(selectedTechArch.id, aCluster.attr('techCompId'));
					 	if(existingSelectedTechProd != null) {
					 		blockFillColour = existingSelectedTechProd.complianceColour;
					 		blockText = existingSelectedTechProd.techProdName;
					 	}
					 				
						createClusterBlock(aCluster, blockText, blockFillColour, clusterXpos, clusterYpos);
					}
					
					function createClusterBlock(parentCluster, blockText, blockColour, blockXpos, blockYPos) {	
						var parentTechCompId = parentCluster.attr('techCompId');					
						var clusterBlock = new joint.shapes.basic.Rect({ 
						 	position:{ x: blockXpos, y: blockYPos },
						 	size: { width: <xsl:value-of select="$defaultTPRWidth"/>, height: <xsl:value-of select="$defaultTechProdHeight"/> },
						 	attrs: {
						 		techCompId: parentTechCompId,
						 		cellBlockType: 'techProdBlock',
						 		techProdColour: '<xsl:value-of select="$undefinedTechProdColour"/>',
						 		rect: { 
						 			stroke: '<xsl:value-of select="$defaultTPRStrokeColour"/>',
						 			fill: blockColour 
						 		},
						 		text: { 
						 			fill: '<xsl:value-of select="$techProdTextColour"/>',
						 			text: blockText,
						 			'font-weight': 'bold',
						 			'font-size': 11,
						 			'font-variant': 'small-caps',
						 			'text-transform': 'capitalize' 
						 		}
						 	}
						 }); 
						 parentCluster.embed(clusterBlock);
						 graph.addCells([clusterBlock]); 
					}
					
					
					//function to render a given set of links between technology components
					function createTechCompLinks(inScopeLinks) {
						var aRelation, aLink;
						relations = [];
						for (var i = 0; inScopeLinks.length > i; i += 1) {
							aLink = inScopeLinks[i];
							aRelation = new joint.dia.Link({ 
							 	source: {
							 		id: clusters[aLink.sourceRef].id
							 	},
							 	target: { 
						 			id: clusters[aLink.targetRef].id 
						 		},
					 			attrs: {
						 			'.marker-target': {
						 					d: 'M 10 0 L 0 5 L 10 10 z'
					 				},
					 				'.connection': {
					 					'stroke-width': 2 
				 					},
				 					'.link-tools': {
				 						display : 'none'
				 					},
				 					'.marker-arrowheads': { 
				 						display: 'none'
				 					},
				 					'.connection-wrap': {
				 						display: 'none'
				 					}
				 				}
					    });
				 			relations.push(aRelation);			 			
				 		};
				 		_.each(relations, function(r) { graph.addCell(r); });
					}
					
					
					function wrapClusterName(nameText, aWidth, aHeight) {
						return joint.util.breakText(nameText, {
						    width: aWidth,
						    height: aHeight
						});
					};
					
					//funtion to update the reference architecture model
					function updateRefArchLogicalModel(aSelectedTechArch) {
						
						var aTechComp, techProd, techCompCluster;
						refArchClusters = {};
						refArchGraph.clear();
						
						var inScopeLinks = aSelectedTechArch.techCompLinks;
						var inScopeTechComps = getObjectsByIds(techComponents, 'id', aSelectedTechArch.techComponents);


						//create the technology component nodes
						for (var i = 0; inScopeTechComps.length > i; i += 1) {
							aTechComp = inScopeTechComps[i];
							techCompCluster = createRefArchCluster(aTechComp) ;
							refArchClusters[aTechComp.ref] = techCompCluster;
						}
						_.each(refArchClusters, function(c) { refArchGraph.addCell(c); });

									
						//create the architecture relations
						createRefArchLinks(inScopeLinks);
						
						//lay out the model
						joint.layout.DirectedGraph.layout(refArchGraph, { setLinkVertices: false, rankDir: "TB", nodeSep: 100, edgeSep: 100 });
					
					}

					//funtion to update the reference architecture model
					function updateReferenceArch(aSelectedTechArch) {
						
						var aTechComp, techProd, techCompCluster;
						clusters = {};
						graph.clear();
						
						var inScopeLinks = aSelectedTechArch.techCompLinks;
						var inScopeTechComps = getObjectsByIds(techComponents, 'id', aSelectedTechArch.techComponents);

						//console.log('in scope tech comps: ' + aSelectedTechArch.techComponents.length);
						
						//create the technology component nodes
						for (var i = 0; inScopeTechComps.length > i; i += 1) {
							aTechComp = inScopeTechComps[i];
							techCompCluster = createCluster(aTechComp) ;
							clusters[aTechComp.ref] = techCompCluster;
						}
						_.each(clusters, function(c) { graph.addCell(c); });

									
						//create the architecture relations
						createTechCompLinks(inScopeLinks);
						
						//lay out the model
						joint.layout.DirectedGraph.layout(graph, { setLinkVertices: false, rankDir: "TB", nodeSep: 100, edgeSep: 100 });
						
						_.each(clusters, 
							function(c) { 
								createTechProdClusterBlock(c);
							}
						);					
					}
					<!-- END DATA LINEAGE VARIABLES AND FUNCTIONS -->
					
					<!-- START SELECTED TECH PRODUCTS TABLE FUNCTIONS -->
					
					//function to create the data structure needed to render business process table rows
					function renderSelectedTechProductsData(theSelectedTechProducts) {
						var dataTableSet = [];
						var dataTableRow, appLink;
						
						if(selectedApp != null) {
							appLink = selectedApp.link;
						} else {
							appLink = ''
						};
						
						//console.log('Selected Prod Count: ' + selectedTechProds[0].techProdlink);
						
						for (var i = 0; theSelectedTechProducts.length > i; i += 1) {
							dataTableRow = [];
							aSelectedTechProd = theSelectedTechProducts[i];
							
							dataTableRow.push(appLink);
							dataTableRow.push(aSelectedTechProd.techArchLink);
							dataTableRow.push(aSelectedTechProd.techCompLink);
							dataTableRow.push(aSelectedTechProd.techProdSupplierLink);
							dataTableRow.push(aSelectedTechProd.techProdLink);
							dataTableRow.push(aSelectedTechProd.complianceLevel);
							
							dataTableSet.push(dataTableRow);
						}
						
						return dataTableSet;
					}
					
					
					//funtion to set contents of the Selected Technology Products
					function setSelectedTechProductsTable() {					
						var selectedTechProdsTableData = renderSelectedTechProductsData(selectedTechProds);								
						selectedTechProdsTable.clear();
						selectedTechProdsTable.rows.add(selectedTechProdsTableData);
    					selectedTechProdsTable.draw();
					}
					
					
					//function to force the redrawing of the Selected Technology Products table
					function redrawSelectedTechProductsTable() {
						selectedTechProdsTable.draw();
					}
					<!-- END SELECTED TECH PRODUCTS TABLE FUNCTIONS -->
					
					
					<!-- START APPLICATION TECHNOLOGY ARCHITECTURE EXPORT TABLE FUNCTIONS -->
					
					//function to create the data structure needed to render the application technology architecture export table rows
					function renderAppTechArchExportData() {
						var dataTableSet = [];
						var usedTechProdRoleIds = [];
						var dataTableRow, appLink, aSelectedRefArch, thisRefArchRelations, aRefArchRelation, fromTechProdRole, toTechProdRole;
						var fromTechProdRoleId, toTechProdRoleId;
						
						if(selectedApp != null) {
							//set the intro text for the application technology architecture export table
							$('#appTechArchLinksIntro').html('The table below provides a means to export a spreadsheet that can be imported to capture the underlying technology product architecture for the selected IT solution');
							//set the application link value
							appLink = selectedApp.link;
						} else {
							//set the intro text for the application technology architecture export table
							$('#appTechArchLinksIntro').html('AN APPLICATION MUST BE SELECTED TO CREATE EXPORT');
							return;
						};
						
						//get the list of selected Reference Architectures
						thisSelectedRefArchs = getObjectsByIds(techArchPatterns.techArchPatterns, "id", selectedRefArchIds);
						
						for (var i = 0; thisSelectedRefArchs.length > i; i += 1) {
							aSelectedRefArch = thisSelectedRefArchs[i];
							thisRefArchRelations = aSelectedRefArch.techCompLinks;
							
							for (var j = 0; thisRefArchRelations.length > j; j += 1) {
								aRefArchRelation = thisRefArchRelations[j];
								fromTechProdRole = getExistingTechProdForTechArch(aSelectedRefArch.id, aRefArchRelation.sourceId);
								toTechProdRole = getExistingTechProdForTechArch(aSelectedRefArch.id, aRefArchRelation.targetId);
								
								if(fromTechProdRole != null) {
									fromTechProdRoleId = fromTechProdRole.techCompId + fromTechProdRole.techProdId;
								} else  {
									fromTechProdRoleId = '';
								}
								
								if(toTechProdRole != null) {
									toTechProdRoleId = toTechProdRole.techCompId + toTechProdRole.techProdId;
								} else  {
									toTechProdRoleId = '';
								}
								
								
								if((fromTechProdRole != null) &amp;&amp; (toTechProdRole == null) &amp;&amp; (usedTechProdRoleIds.includes(fromTechProdRoleId))) {
									continue;
								};
								
								if((fromTechProdRole == null) &amp;&amp; (toTechProdRole != null) &amp;&amp; (usedTechProdRoleIds.includes(toTechProdRoleId))) {
									continue;
								};
								
								if((fromTechProdRole != null) || (toTechProdRole != null)) {
									//Add a row to the data set
									dataTableRow = [];
									dataTableRow.push(appLink);
									dataTableRow.push('Production');
									
									//If set, add the details for the source Technology Product Role
									if(fromTechProdRole != null) {
										dataTableRow.push(fromTechProdRole.techProdLink);
										dataTableRow.push(fromTechProdRole.techCompLink);
										
										usedTechProdRoleIds.push(fromTechProdRoleId);
									} else {
										dataTableRow.push('');
										dataTableRow.push('');
									}
									//If set, add the details for the target Technology Product Role
									if(toTechProdRole != null) {
										dataTableRow.push(toTechProdRole.techProdLink);
										dataTableRow.push(toTechProdRole.techCompLink);
										
										usedTechProdRoleIds.push(toTechProdRoleId);
									} else {
										dataTableRow.push('');
										dataTableRow.push('');
									}
									dataTableRow.push(aSelectedRefArch.name);
									
									dataTableSet.push(dataTableRow);
								}
							}
						}
						
						return dataTableSet;
					}
					
					
					//funtion to set contents of the application technology architecture export table
					function setAppTechArchExportTable() {					
						var inScopeAppTechArchExportData = renderAppTechArchExportData();								
						appTechArchsExportTable.clear();
						appTechArchsExportTable.rows.add(inScopeAppTechArchExportData);
    					appTechArchsExportTable.draw();
					}
					
					
					//function to force the redrawing of the application technology architecture export table
					function redrawAppTechArchExportTable() {
						appTechArchsExportTable.draw();
					}
					<!-- END APPLICATION TECHNOLOGY ARCHITECTURE EXPORT TABLE FUNCTIONS -->
					
					
					
					<!-- START RELEVANT REF ARCHITECTURES TABLE FUNCTIONS -->
					//function to set the service quality fit for a given reference architecture
					function setServiceQualityFitScore(aRefArch) {
						var refArchSvcQualityScores = aRefArch.techServiceQualityVals;
						var maxWeightedScore = 0;
						var totalWeightedScore = 0;
						var aSvcQualScore, aSvcQual;
						
						for (var i = 0; refArchSvcQualityScores.length > i; i += 1) {
							aSvcQualScore = refArchSvcQualityScores[i];
							aSvcQual = getObjectById(techServiceQualities.techServiceQualities, 'id', aSvcQualScore.id);
							//console.log('Service Quality Score for ' + aSvcQual.name + ' of ' + aRefArch.name + ': ' + aSvcQualScore.score);
							maxWeightedScore = maxWeightedScore + (aSvcQual.weighting * 10);
							totalWeightedScore = totalWeightedScore + (aSvcQual.weighting * aSvcQualScore.score);
						};
						
						if((maxWeightedScore > 0) &amp;&amp; (totalWeightedScore > 0)) {
							aRefArch.serviceQualityFit = Math.round((totalWeightedScore / maxWeightedScore) * 100);
						} else {
							aRefArch.serviceQualityFit = 0;
						}
						//console.log('Service Quality Fit for ' + aRefArch.name + ': ' + aRefArch.serviceQualityFit);						
					}
					
					//function to create the data structure needed to render relevant reference architectures table rows
					function renderRelevantRefArchitectureData(theRelevantRefArchs) {
						var dataTableSet = [];
						var dataTableRow;
						
						//console.log('Selected Prod Count: ' + selectedTechProds[0].techProdlink);
						var aRelevantRefArch;
						for (var i = 0; theRelevantRefArchs.length > i; i += 1) {
							dataTableRow = [];
							aRelevantRefArch = theRelevantRefArchs[i];
							
							dataTableRow.push(aRelevantRefArch.id);
							dataTableRow.push(aRelevantRefArch.link);
							<!--dataTableRow.push(aRelevantRefArch.description);-->
							dataTableRow.push(aRelevantRefArch.techCapabilities);
							
							dataTableSet.push(dataTableRow);
						}
						
						return dataTableSet;
					}
					
					
					//funtion to set contents of the relevant reference architectures table
					function setRelevantRefArchitecturesTable() {		
						//identify the reference architectures that provide the selected technology capabilities
						var relevantRefArchs = [];
						var aRefArch, techCapsIntersect;
						for (var i = 0; techArchPatterns.techArchPatterns.length > i; i += 1) {
							aRefArch = techArchPatterns.techArchPatterns[i];
							techCapsIntersect = getArrayIntersect([aRefArch.techCapabilities, selectedTechCapIds]);
							if(techCapsIntersect.length > 0) {
								//set the service quality fit of the reference architecture
								setServiceQualityFitScore(aRefArch);
								relevantRefArchs.push(aRefArch);
							}
						}
					
						//create the JSON objects required to populate the relevant reference architectures table
						var relevantRefArchsData = [];
						var refArchData, techCapList, techCapListObject, techCapListHTML;
						for (var j = 0; relevantRefArchs.length > j; j += 1) {
							aRefArch = relevantRefArchs[j];
							
							techCapList = getObjectsByIds(techCapabilities, 'id', aRefArch.techCapabilities);
							techCapListObject = {
								techCapabilities: techCapList
							};
							
							techCapListHTML = techCapListTemplate(techCapListObject);
							
							refArchData = {
								id: aRefArch.id,
								link: aRefArch.link,
								description: aRefArch.description,
								techCapabilities: techCapListHTML
							};
							
							relevantRefArchsData.push(refArchData);
						}
						
						//set the table contents
						var relevantRefArchsTableData = renderRelevantRefArchitectureData(relevantRefArchsData);								
						refArchListTable.clear();
						refArchListTable.rows.add(relevantRefArchsTableData);
    					
    					var currentRowId;
    					for (var k = 0; refArchListTable.rows().data().length > k; k += 1) {
    						currentRowId = refArchListTable.cell(k, 0).data();
	    					if(selectedRefArchIds.indexOf(currentRowId) > -1) {
			                  refArchListTable.cell(k, 0).checkboxes.select();
			               	}
		               	;}
		               	refArchListTable.draw();
					}
					
					//function to force the redrawing of the Reference Architecture List table
					function redrawRefArchListTable() {
						//update the list of relevant reference architectures
						setRelevantRefArchitecturesTable();
						
						//refresh the reference architecture logical model and the service quality gauges
						refreshSelectedRefArchs();

					}
					
					//function to set the Service Quality Fit Header for a reference architecture selected in the table
					function setServiceQualityFit(refArchId) {
						
						var aRefArchData = {
								scores: []
						};
						
						//if a reference architecture id has been provided
						if(refArchId.length > 0) {
							var aRefArch = getObjectById(techArchPatterns.techArchPatterns, 'id', refArchId);
						
							var refArchSvcQualityScore = aRefArch.serviceQualityFit;
							if(refArchSvcQualityScore >= <xsl:value-of select="$highScoreThreshold"/>) {
								aRefArchData['high'] = true;
							} else if(refArchSvcQualityScore >= <xsl:value-of select="$medScoreThreshold"/>) {
								aRefArchData['medium'] = true;
							} else {
								aRefArchData['low'] = true;
							};
							
							var refArchSvcQualityScores = aRefArch.techServiceQualityVals;
							var aSvcQualScore, aSvcQual, aSvcQualScoreData;
							
							for (var i = 0; refArchSvcQualityScores.length > i; i += 1) {
								aSvcQualScore = refArchSvcQualityScores[i];
								aSvcQual = getObjectById(techServiceQualities.techServiceQualities, 'id', aSvcQualScore.id);
								aSvcQualScoreData = {
									id: aSvcQualScore.id + '_score',
									name: aSvcQual.name,
									score: aSvcQualScore.score
								};
								aRefArchData.scores.push(aSvcQualScoreData);
							};	
							//update the reference architecture logical model
							updateRefArchLogicalModel(aRefArch);
						} else {
							//reset the service quality header and the guages
							aRefArchData['none'] = true;
							//clear the reference architecture logical model
							refArchGraph.clear();
						};
						
						//create the service quality fit header and gauge DOM elements
						$('#serviceQualityFitDiv').html(serviceQualityFitSectionTemplate(aRefArchData));
						
						//initialise any guages that have been created
						var aScore, target, gauge;
						for (var j = 0; aRefArchData.scores.length > j; j += 1) {
							aScore = aRefArchData.scores[j];
							
							//initialise the corresponding gauge
							target = document.getElementById(aScore.id);
							gauge = new Gauge(target).setOptions(gaugeOpts);
							gauge.maxValue = 10;
							gauge.animationSpeed = 32;
							gauge.set(aScore.score);		
						};		
					}

					
					<!-- END RELEVANT REF ARCHITECTURES TABLE FUNCTIONS -->
					
					<!-- START SELECTED REF ARCHITECTURES FUNCTIONS -->
					//function to create the data structure needed to render selected reference architectures table rows
					function renderSelectedRefArchitectureData(theSelectedRefArchs) {
						var dataTableSet = [];
						var dataTableRow;
						
						//console.log('Selected Prod Count: ' + selectedTechProds[0].techProdlink);
						var aSelectedRefArch;
						for (var i = 0; theSelectedRefArchs.length > i; i += 1) {
							dataTableRow = [];
							aSelectedRefArch = theSelectedRefArchs[i];
							
							dataTableRow.push(aSelectedRefArch.link);
							dataTableRow.push(aSelectedRefArch.description);
							dataTableRow.push(aSelectedRefArch.serviceQualityFit);
							
							dataTableSet.push(dataTableRow);
						}
						
						return dataTableSet;
					}
					
					
					//function to refresh the selected reference architecture table and technology capabilty footprint
					function refreshSelectedRefArchs() {
						//get the selected reference architectures
						var selectedRefArchs = getObjectsByIds(techArchPatterns.techArchPatterns, 'id', selectedRefArchIds);
						
						var thisSelectedRefArchDataList = [];
						var refArchTechCapLists = [];
						var aRefArch, aRefArchData, refArchSvcQualityScore, refArchSvcQualityFit;
						for (var i = 0; selectedRefArchs.length > i; i += 1) {
							aRefArch = selectedRefArchs[i];
							refArchTechCapLists.push(aRefArch.techCapabilities);
							
							aRefArchData = {
								id: aRefArch.id,
								name: aRefArch.name,
								link: aRefArch.link,
								description: aRefArch.description,
								serviceQualityFit: ''
							};
							
							refArchSvcQualityScore = aRefArch.serviceQualityFit;
							if(refArchSvcQualityScore >= <xsl:value-of select="$highScoreThreshold"/>) {
								aRefArchData['high'] = true;
							} else if(refArchSvcQualityScore >= <xsl:value-of select="$medScoreThreshold"/>) {
								aRefArchData['medium'] = true;
							} else {
								aRefArchData['low'] = true;
							};
							aRefArchData.serviceQualityFit = serviceQualityFitTemplate(aRefArchData);
							thisSelectedRefArchDataList.push(aRefArchData);
						};
						
						//refresh the selected reference architecture table
						var selectedRefArchsTableData = renderSelectedRefArchitectureData(thisSelectedRefArchDataList);								
						selectedRefArchsTable.clear();
						selectedRefArchsTable.rows.add(selectedRefArchsTableData);
    					selectedRefArchsTable.draw();
						
						//refresh the technology capability footprint
						var techCapsForSelectedRefArchs = getUniqueArrayVals(refArchTechCapLists);
						var techCapList = getObjectsByIds(techCapabilities, 'id', selectedTechCapIds);
						var aTechCap;
						for (var j = 0; techCapList.length > j; j += 1) {
							aTechCap = techCapList[j];
							if(techCapsForSelectedRefArchs.indexOf(aTechCap.id) > -1) {
								aTechCap.covered = true;
							} else {
								aTechCap.covered = false;
							}
						};
						var techCapBlobs = {
							techCapabilities: techCapList
						};
						$("#techCapFootprintDiv").html(techCapBlobTemplate(techCapBlobs));
						
						//re-initialise the popups				
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
					}
					 
					<!-- END SELECTED REF ARCHITECTURES FUNCTIONS -->
					
		
					<!-- START TECHNOLOGY PRODUCT SELECTION FUNCTIONS -->
					//function to update the list of selected reference architectures
					function updateSelectedRefArchsList() {
						var selectedRefArchs = getObjectsByIds(techArchPatterns.techArchPatterns, 'id', selectedRefArchIds);
						var selectedRefArchsList = {
							techArchPatterns: selectedRefArchs
						}
						$("#techArchList").html(techArchListTemplate(selectedRefArchsList));
					}
					
					//function to update the list of Technology Components and the Reference Architecture given a selected Technology Architecture Pattern
					function setCurrentTechArch(aTechArchId) {
						//Get the selected Technolgy Architecture Pattern and associated Technology Components
						var aTechArch = getObjectById(techArchPatterns.techArchPatterns, 'id', aTechArchId);
						var theTechComps = getObjectsByIds(techComponents, 'id', aTechArch.techComponents);
						selectedTechArchId = aTechArchId;
						selectedTechArch = aTechArch;
						
						$("#tech-prod-selection").html('');
						$("#userInstruction").html('Select a Technology Component');

						//Update the Technology Reference Model
						updateReferenceArch(selectedTechArch);
						
					}
					
					<!-- Function to update the set of Technology Products given a selected Technology Component -->
					function setCurrentTechComp(aTechCompId) {
						//Get the selected Technolgy Component and associated Technology Products
						var aTechComp = getObjectById(techComponents, 'id', aTechCompId);
						selectedTechCompId = aTechCompId;
						selectedTechComp = aTechComp;
						var theTechProds = aTechComp.techProducts;
						
						//Update the set of selectable Technology Products
						$("#tech-prod-selection").html(techProdTemplate(selectedTechComp));
						$("#userInstruction").html('Drag Product Here');
						
						//re-initialise the popups				
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
						
					}
					
					
					<!-- Function to reset the set of Technology Products and selected Technology Component -->
					function removeCurrentTechComp() {
						selectedTechCompId = null;
						selectedTechComp = null;
						
						//remove the set of selectable Technology Products
						$("#tech-prod-selection").html('');	
						$("#userInstruction").html('Select a Technology Component');	
						
					}
					
					
					//Get an existing selected technology product given a reference architectire and technology component
					function getExistingTechProdForTechArch(techArchId, techCompId) {
						var aSelectedTechProd;
						for (var i = 0; selectedTechProds.length > i; i += 1) {
							aSelectedTechProd = selectedTechProds[i];
							if((aSelectedTechProd.techArchId == techArchId) &amp;&amp; (aSelectedTechProd.techCompId == techCompId)) {
								return aSelectedTechProd;
							}
						}
						return null;			
					}
					
					//Update an existing technology product or add a new Selected Tech Product object
					function addSelectedTechProduct(productId) {
					
						var selectedTechProd;
						if((selectedTechArch != null) &amp;&amp; (selectedTechComp != null) &amp;&amp; (productId != null)) {
											
							selectedTechProd = getObjectById(selectedTechComp.techProducts, 'techProdId', productId);									
							var existingSelectedTechProd = getExistingTechProdForTechArch(selectedTechArch.id, selectedTechComp.id);
							
							if(existingSelectedTechProd != null) {
								existingSelectedTechProd.techProdId = selectedTechProd.techProdId,
								existingSelectedTechProd.techProdLink = selectedTechProd.techProdLink,
								existingSelectedTechProd.techProdName = selectedTechProd.techProdName,
								existingSelectedTechProd.techProdDesc = selectedTechProd.techProdDesc,
								existingSelectedTechProd.techProdSupplierLink = selectedTechProd.techProdSupplierLink,
								existingSelectedTechProd.complianceLevel = selectedTechProd.complianceLevel,
								existingSelectedTechProd.complianceColour = selectedTechProd.complianceColour;
							} else {
								var newSelectedTechProd = {
									techArchId: selectedTechArch.id,
									techArchLink: selectedTechArch.link,
									techCompId: selectedTechProd.techCompId,
									techCompLink: selectedTechProd.techCompLink,
									techProdId: selectedTechProd.techProdId,
									techProdLink: selectedTechProd.techProdLink,
									techProdName: selectedTechProd.techProdName,
									techProdDesc: selectedTechProd.techProdDesc,
									techProdSupplierLink: selectedTechProd.techProdSupplierLink,
									complianceLevel: selectedTechProd.complianceLevel,
									complianceColour: selectedTechProd.complianceColour
								};
							
								selectedTechProds.push(newSelectedTechProd);
							}
						}
						
						return selectedTechProd;
					}
					
					<!-- END TECHNOLOGY PRODUCT SELECTION FUNCTIONS -->
					
					//FUNCTION TO INITIALISE THE PAGE
					$(document).ready(function(){
						//INITIALISE THE DROP DOWN LISTS
						$('#applicationList').select2({
							placeholder: "Select or create a Shared Platform",
							theme: "bootstrap"
						});
						
						var appSelectFragment   = $("#app-select-template").html();
						var appSelectTemplate = Handlebars.compile(appSelectFragment);
						$("#applicationList").html(appSelectTemplate(applications));
						
						
						$('#applicationList').on('change', function (evt) {
							var thisAppId = $(this).select2("val");
							if(thisAppId != null) {
								if(thisAppId == "NEW") {
									$('#appModal').modal('show');
								} else {
									if(thisAppId != "") {
										selectedAppId = thisAppId;
										setCurrentApp(thisAppId);
									}
								}
							} 
						});
						
						var techArchListFragment   = $("#tech-arch-list-template").html();
						techArchListTemplate = Handlebars.compile(techArchListFragment);
						
						$('#techArchList').select2({
						    placeholder: "Select Reference Architecture",
						    theme: "bootstrap"
						});
											
						//$("#techArchList").html(techArchListTemplate(techArchPatterns));
															
						$('#techArchList').on('change', function (evt) {
						  var thisTechArchId = $(this).select2("val");
						  if(thisTechArchId != null) {
						  	setCurrentTechArch(thisTechArchId);
						  } else {
						  	//clear the tech component drop down list, tech products and reference architecture model
						  }
						});
						
						
						<!-- CREATE THE SELECTED APP TEMPLATE -->
						//set up the selected App Template
						var currentAppFragment   = $("#application-template").html();
						currentAppTemplate = Handlebars.compile(currentAppFragment);
						
						//add event listenera for the New Application Modal window
						$('#cancelNewAppBtn').on('click', function (evt) {
							 //Tidy up the modal
						    $('#newAppName').val('');
						    $('#newAppDesc').val('');
						    $('#newAppError').text('');
							    
							$('#applicationList').val(null).trigger('change');
						});
						
						$('#createNewAppBtn').on('click', function (evt) {
							var appId = 'newApp' + newAppId;
							var appName = $('#newAppName').val();
							var appDesc = $('#newAppDesc').val();
							
							if(appName.length > 0) {
								var newApp = {id: appId, name: appName, link: appName, description: appDesc, selected: true};
								applications.applications.push(newApp);
								newAppId++;
								
								// Create a DOM Option and pre-select by default
							    var newOption = new Option(appName, appId, true, true);
							    selectedAppId = appId;
								setCurrentApp(appId);
								
							    // Append it to the select
							    $('#applicationList').append(newOption).trigger('change');
							    
							    // Close the Modal
							    $('#appModal').modal('hide');
							    
							    //Tidy up the modal
							    $('#newAppName').val('');
							    $('#newAppDesc').val('');
							    $('#newAppError').text('');
							   
						    } else {
						    	$('#newAppError').text('Please enter an application name');
						    }
						    
						});
						
						<!-- START TECHNOLOGY CAPABILITY SELECTION FUNCTIONS -->
						//initialise the TRM model
						var trmFragment   = $("#trm-template").html();
						var trmTemplate = Handlebars.compile(trmFragment);
						$("#techRefModelContainer").html(trmTemplate(trmData));
						$('.matchHeight2').matchHeight();
			 			$('.matchHeightTRM').matchHeight();
			 			
			 			$('.techRefModel-blob').on('click', function (evt) {
							var thisTechCapId = $(this).attr('id');
							var thisTechCap = getObjectById(techCapabilities, 'id', thisTechCapId);
							//console.log('Clicked on Tech Cap: ' + $(this).attr('id'));
							
							//remove the tech cap from or to the selected list
							var techCapIndex = selectedTechCapIds.indexOf(thisTechCapId);
							if (techCapIndex > -1) {
								selectedTechCapIds.splice(techCapIndex, 1);
								thisTechCap.inScope = false;
								$(this).removeClass();
								$(this).addClass("techRefModel-blob bg-midgrey");
							} else {
								selectedTechCapIds.push(thisTechCapId);
								thisTechCap.inScope = true;
								$(this).removeClass();
								$(this).addClass("techRefModel-blob bg-darkgreen-80");
							}						
						});
						
						<!-- START TECHNOLOGY SERVICE QUALITIES FUNCTIONS -->
						//create the service quality sliders
						var tsqFragment   = $("#tech-service-quality-template").html();
						var tsqTemplate = Handlebars.compile(tsqFragment);
						$("#tsqWeightingContainer").html(tsqTemplate(techServiceQualities));
					
						// initialise the service quality sliders
						var aTSQ;
						for (var i = 0; techServiceQualities.techServiceQualities.length > i; i += 1) {
							aTSQ = techServiceQualities.techServiceQualities[i];
							$('#' + aTSQ.id).bootstrapSlider({
							    ticks: [0, 1, 2, 3],
							    ticks_labels: ['n/a', 'Low', 'Medium', 'High'],
							    ticks_snap_bounds: 1,
							    tooltip: 'hide',
							    value: 1
							})
							.on( 'slideStop', function () {
					            //set the weighting for this Service Quality Value
					            setServiceQualityWeighting($(this).attr('id'), $(this).bootstrapSlider('getValue'));
					        });
						}
						
						//SET UP THE RELEVANT REFERENCE ARCHITECTURES TABLE
						//Set up the html template for technology capabilities shown in the relevant reference architectures table
						var techCapListFragment   = $("#tech-capability-bullets").html();
						techCapListTemplate = Handlebars.compile(techCapListFragment);
						
						
						// Setup - add a text input to each footer cell
					    $('#dt_refArchList tfoot th').each( function (index) {
					    	if(index > 0) {
					        	var title = $(this).text();
					        	$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					        }
					    } );
						
						refArchListTable = $('#dt_refArchList').DataTable({
							scrollY: "300px",
							scrollCollapse: true,
							paging: false,
							info: false,
							sort: true,
							responsive: true,
							order: [[1, 'asc']],
							select: true,
							columns: [
							    { "width": "5%", "orderable": false },
							    { "width": "35%" },
							    <!--{ "width": "40%" },-->
							    { "width": "55%" },
							 ],
							 
							 columnDefs: [
						         {
						            'targets': 0,
						            'checkboxes': {
						               'selectRow': false,
						               'selectCallback': function(nodes, selected){
						                  	// get list of ref architecture ids for selected rows
						                  	//console.log(refArchListTable.column(0).checkboxes);
						                  	selectedRefArchIds = refArchListTable.column(0).checkboxes.selected();
						                  	//refresh the selected reference architectures section
						                  	refreshSelectedRefArchs();					                  	
						               }
						            }
						         }
						      ],
							dom: 'frtip'
						});
						
						//Add the events handlers when selecting rows in the relevant reference architectures table
						refArchListTable
				        .on( 'select', function ( e, dt, type, indexes ) {
				            var rowData = refArchListTable.rows( indexes ).data().toArray();
				            setServiceQualityFit(rowData[0][0]);
				        } )
				        .on( 'deselect', function ( e, dt, type, indexes ) {
				        	setServiceQualityFit('');
				        } );
						
											
						// Apply the search
					    refArchListTable.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    refArchListTable.columns.adjust();
					    
					    $(window).resize( function () {
					        refArchListTable.columns.adjust();
					    });
					    
					    //SET UP THE REFERENCE ARCHITECTURE LOGICAL COMPONENT MODEL
					    refArchGraph = new joint.dia.Graph;
					
						var refArchPaper = new joint.dia.Paper({
							el: $('#refArchModelDiv'),
					        width: 1920,
					        height: 350,
					        gridSize: 1,
					        model: refArchGraph
					    });
					    
					    refArchPaper.setOrigin(30,30);
					    
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
						  percentColors: [[0.0, "#CB0E3A" ], [0.50, "#F59C3D"], [1.0, "#1EAE4E"]], // !!!!
						  strokeColor: '#E0E0E0',
						  generateGradient: true
						};
					    
					    
					    //SET UP THE SELECTED REFERENCE ARCHITECTURES TABLE
					    // Setup - add a text input to each footer cell
					    <!--$('#dt_selectedRefArchs tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );-->
						
						selectedRefArchsTable = $('#dt_selectedRefArchs').DataTable({
							scrollY: "350px",
							scrollCollapse: true,
							paging: false,
							info: true,
							sort: true,
							responsive: true,
							columns: [
							    { "width": "30%" },
							    { "width": "50%" },
							    { "width": "20%" }
							  ]
						});
											
						// Apply the search
					   <!-- selectedRefArchsTable.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );-->
					    
					    selectedRefArchsTable.columns.adjust();
					    
					    $(window).resize( function () {
					        selectedRefArchsTable.columns.adjust();
					    });
					    
					    //Initialise the reference architecture service quality fit header template
					    var serviceQualityFitSectionFragment   = $("#service-quality-fit-section-template").html();
						serviceQualityFitSectionTemplate = Handlebars.compile(serviceQualityFitSectionFragment);
					    
					    //Initialise the reference architecture service quality fit template
					    var serviceQualityFitFragment   = $("#service-quality-fit-template").html();
						serviceQualityFitTemplate = Handlebars.compile(serviceQualityFitFragment);
					    
						//SET UP THE TECHNOLOGY CAPABILITY FOOTPRINT BLOB TEMPLATE
						var techCapBlobFragment   = $("#tech-capability-blob-template").html();
						techCapBlobTemplate = Handlebars.compile(techCapBlobFragment);
						
						//SET UP THE TECHNOLOGY PRODUCTS BLOB TEMPLATE
						var techProdFragment   = $("#tech-product-template").html();
						techProdTemplate = Handlebars.compile(techProdFragment);
						
					    
					    //SET UP THE SELECTED TECH PRODUCTS TABLE
						// Setup - add a text input to each footer cell
					    $('#dt_selectedTechProds tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
						
						selectedTechProdsTable = $('#dt_selectedTechProds').DataTable({
							scrollY: "350px",
							scrollCollapse: true,
							paging: false,
							info: false,
							sort: true,
							responsive: true,
							columns: [
								{ "width": "20%" },
							    { "width": "20%" },
							    { "width": "15%" },
							    { "width": "15%" },
							    { "width": "20%" },
							    { "width": "10%" }
							  ],
							dom: 'Bfrtip',
						    buttons: [
					            'copyHtml5',
					            'csvHtml5'
					        ]
						});
											
						// Apply the search
					    selectedTechProdsTable.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    selectedTechProdsTable.columns.adjust();
					    
					    $(window).resize( function () {
					        selectedTechProdsTable.columns.adjust();
					    });
					    
					    
					     //SET UP THE APPLICATION TECHNOLOGY ARCHITECTURE EXPORT TABLE
						// Setup - add a text input to each footer cell
					     $('#dt_appTechArchsExport tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
					    
					    appTechArchsExportTable = $('#dt_appTechArchsExport').DataTable({
							scrollY: "350px",
							scrollCollapse: true,
							paging: false,
							info: false,
							sort: true,
							responsive: true,
							columns: [
								{ "width": "15%" },
							    { "width": "10%" },
							    { "width": "15%" },
							    { "width": "15%" },
							    { "width": "15%" },
							    { "width": "15%" },
							    { "width": "15%" }
							  ],
							dom: 'Bfrtip',
						    buttons: [
					            'copyHtml5'
					        ]
						});
											
						// Apply the search
					    appTechArchsExportTable.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    appTechArchsExportTable.columns.adjust();
					    
					    $(window).resize( function () {
					        appTechArchsExportTable.columns.adjust();
					    });
					    
					    				    
					    //SET UP THE REFERENCE ARCHITECTURE TECHNOLOGY PRODUCT MODEL
					    graph = new joint.dia.Graph;
					
						var paper = new joint.dia.Paper({
							el: $('#techArchModelDiv'),
					        width: 1920,
					        height: windowHeight,
					        gridSize: 1,
					        model: graph
					    });
					    
					    paper.setOrigin(30,30);
			
						paper.on('blank:pointerclick', 
						    function(evt, x, y) { 
							 	_.each(paper.model.getElements(), function(el) {
							 		if(el.attr('cellBlockType') != 'techProdBlock') {
							        	el.transition('attrs/rect/fill', '<xsl:value-of select="$defaultTPRColour"/>', {
											duration: 300,
										    valueFunction: joint.util.interpolate.hexColor,
										    timingFunction: joint.util.timing.linear
										});
										el.transition('attrs/text/fill', '<xsl:value-of select="$defaultTPRTextColour"/>', {
										    duration: 300,
										    valueFunction: joint.util.interpolate.hexColor,
										    timingFunction: joint.util.timing.linear
										});
										el.transition('size', { width: <xsl:value-of select="$defaultTPRWidth"/>, height: <xsl:value-of select="$defaultTPRHeight"/> }, {
										    duration: 300,
										    valueFunction: joint.util.interpolate.object,
										    timingFunction: joint.util.timing.linear
										});
										techProdBlocks = el.getEmbeddedCells();
								        _.each(techProdBlocks, 
								        	function(el) {								
												el.transition('size', { width: <xsl:value-of select="$defaultTPRWidth"/>, height: <xsl:value-of select="$defaultTechProdHeight"/> }, {
												    duration: 300,
												    valueFunction: joint.util.interpolate.object,
												    timingFunction: joint.util.timing.linear
												});
								        	}
								        );
								      }
							     });	
								
								 removeCurrentTechComp();
						    }
					    );
					
					    
					    paper.on('cell:pointerclick', 
						    function(cellView, evt, x, y) { 
						    	//cellView.model.attr('rect/fill', 'black');
					    		var selectedTechCompId = cellView.model.attr('techCompId');
					    		var selectedTechComp = getObjectById(techComponents, 'id', selectedTechCompId);
						    	//console.log('Mouse over on: ' + selectedTechComp.name);
						    	
						    	if (cellView.model.attr('cellBlockType') == 'techProdBlock') {
						    		return;
						    	}
						    	
						    	var cellId = cellView.model.id;
							 	_.each(cellView.paper.model.getElements(), function(el) {
							        if(!(el.id == cellId) &amp;&amp; (el.attr('cellBlockType') != 'techProdBlock')) {
							        	el.transition('attrs/rect/fill', '#FFFFFF', {
										    valueFunction: joint.util.interpolate.hexColor,
										    timingFunction: joint.util.timing.linear
										});
										el.transition('attrs/text/fill', '<xsl:value-of select="$defaultTPRTextColour"/>', {
										    valueFunction: joint.util.interpolate.hexColor,
										    timingFunction: joint.util.timing.linear
										});
										el.transition('size', { width: <xsl:value-of select="$defaultTPRWidth"/>, height: <xsl:value-of select="$defaultTPRHeight"/> }, {
										    valueFunction: joint.util.interpolate.object,
										    timingFunction: joint.util.timing.linear
										});
										techProdBlocks = el.getEmbeddedCells();
								        _.each(techProdBlocks, 
								        	function(el) {								
												el.transition('size', { width: <xsl:value-of select="$defaultTPRWidth"/>, height: <xsl:value-of select="$defaultTechProdHeight"/> }, {
												    valueFunction: joint.util.interpolate.object,
												    timingFunction: joint.util.timing.linear
												});
								        	}
								        );
							        } 
							     });
							     cellView.model.transition('attrs/rect/fill', '<xsl:value-of select="$selectedTPRColour"/>', {
	    							duration: 300,
								    valueFunction: joint.util.interpolate.hexColor,
								    timingFunction: joint.util.timing.linear
								});
								cellView.model.transition('attrs/text/fill', '<xsl:value-of select="$selectedTPRTextColour"/>', {
	    							duration: 300,
								    valueFunction: joint.util.interpolate.hexColor,
								    timingFunction: joint.util.timing.linear
								});
							     cellView.model.transition('size', { width: <xsl:value-of select="$selectedTPRWidth"/>, height: <xsl:value-of select="$selectedTPRHeight"/> }, {
	    							duration: 300,
								    valueFunction: joint.util.interpolate.object,
								    timingFunction: joint.util.timing.linear
								});
								techProdBlocks = cellView.model.getEmbeddedCells();
								//console.log('Embedded Block Count: ' + techProdBlocks);
						        _.each(techProdBlocks, 
						        	function(el) {
						        		selectedTechProdCell = el;
										el.transition('size', { width: <xsl:value-of select="$selectedTPRWidth"/>, height: <xsl:value-of select="$selectedTechProdHeight"/> }, {
											duration: 300,
										    valueFunction: joint.util.interpolate.object,
										    timingFunction: joint.util.timing.linear
										});
						        	}
						        );			
								
								 setCurrentTechComp(selectedTechCompId);
						    }
					    );
					    
						
						// Create a custom element.
						// ------------------------
						joint.shapes.custom = {};
						joint.shapes.custom.Cluster = joint.shapes.basic.Rect.extend({
							markup: '<g class="rotatable droppableTechComp"><g class="scalable"><rect></rect></g><text></text></g>',
						    defaults: joint.util.deepSupplement({
						        type: 'custom.Cluster',
						        attrs: {
						            rect: { fill: '<xsl:value-of select="$defaultTPRColour"/>', stroke: '<xsl:value-of select="$defaultTPRStrokeColour"/>', 'stroke-width': 5 },
						            text: { 
						            	fill: '<xsl:value-of select="$defaultTPRTextColour"/>',
						            	'ref-x': .5,
			                        	'ref-y': .3
						            }
						        }
						    }, joint.shapes.basic.Rect.prototype.defaults)
						});
						
						//SET UP THE DRAG AND DROP BEHAVIOURS
						var dragContainers = [document.querySelector('#tech-prod-selection'), document.querySelector('.techArchitecture')];
						dragContainerList = dragula(dragContainers, {
							revertOnSpill: true,
							removeOnSpill: false,
							moves: function (el, source) {
								$('.dropspace').removeClass('shrink');
								$('.dropspace').addClass('grow');
								selectedTechProdId = el.id;
								//console.log('Dragging Tech Prod: ' + selectedTechProdId);
								return true; // Allow drag for all elements except ??
							},
							copy: function (el, source) {
								//Always copy the element
								return true;
							},
							accepts: function (el, target) {
								//Only accept if the target element is a droppable tech component
								var objId = el.id;
								
								//console.log('Dropping Elememt with class ' + el.classList + ' on target with class: ' + target.classList);
								if((hasClass(el, 'draggableTechProd')) &amp;&amp; (hasClass(target, 'techArchitecture'))) {
									//console.log('Dropping Elememt');
									return true;
								} else {
									return false;
								}			
							}
						}).on('drop', function (el) {
							var objId = el.id;
							//Add a new Selected Tech Product object
							var selectedTechProd = addSelectedTechProduct(objId);			
							setSelectedTechProductsTable();
							
							el.style.opacity = '0';
							setTimeout(function(){el.parentNode.removeChild(el);}, 1000);
							
							selectedTechProdCell.transition('attrs/rect/fill', selectedTechProd.complianceColour, {
								duration: 1000,
							    valueFunction: joint.util.interpolate.hexColor,
							    timingFunction: joint.util.timing.linear
							});
							selectedTechProdCell.attr('techProdColour', selectedTechProd.complianceColour);
							selectedTechProdCell.attr('text/text', selectedTechProd.techProdName);
							
							//var refModelElements = graph.getElements();
							setTimeout(function(){$('.dropspace').removeClass('grow');}, 1000);
							setTimeout(function(){$('.dropspace').addClass('shrink');}, 1000);
						});
					});
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
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Standard Technology Product Selector</span>
								</h1><xsl:value-of select="$DEBUG"/>
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
								<div class="workflowStep" id="step2" onclick="menuSelect(2);setTimeout(refreshServiceQualitySliders, 600);">
									<div class="workflowID bg-black">2</div>
									<div class="worksflowTitle bg-lightgrey">Select Technology Capabilities</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
								<div class="workflowStep" id="step3" onclick="menuSelect(3);setTimeout(redrawRefArchListTable, 600);showHelpButton();">
									<div class="workflowID bg-black">3</div>
									<div class="worksflowTitle bg-lightgrey">Select Reference Architectures</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
								<div class="workflowStep" id="step4" onclick="menuSelect(4);;setTimeout(updateSelectedRefArchsList, 600);">
									<div class="workflowID bg-black">4</div>
									<div class="worksflowTitle bg-lightgrey">Select Technology Products</div>
									<div class="workflowArrow bg-darkgrey">
										<i class="fa fa-chevron-right left-10"/>
									</div>
								</div>
								<div class="workflowStep" id="step5" onclick="menuSelect(5);setTimeout(redrawSelectedTechProductsTable, 600);setTimeout(setAppTechArchExportTable, 600);">
									<div class="workflowID bg-black">5</div>
									<div class="worksflowTitle bg-lightgrey">Review Results</div>
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
								<xsl:call-template name="RenderTechCapSelectionSection"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step3Content">
								<xsl:call-template name="RenderTechArchSelectionSection"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step4Content">
								<xsl:call-template name="RenderTechSelectorPanels"/>
							</div>
							<div class="workFlowContent top-20 hiddenDiv" id="step5Content">
								<xsl:call-template name="RenderResultsPanel"/>
							</div>
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
		</html>
	</xsl:template>
	
	
	<xsl:template name="introPage">
		<!-- HTML TEMPLATE FOR THE APPLICATIONS DROP DOWN CONTENT -->
		<script id="app-select-template" type="text/x-handlebars-template">
			<option/>
			{{#applications}}
				<option>
					<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					{{name}}
				</option>
			{{/applications}}
		</script>
		
		<!-- HTML TEMPLATE FOR THE SELECTED APPLICATION -->
		<script id="application-template" type="text/x-handlebars-template">
			<div class="blob_Outer">
				<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
				<div class="blob_Box bg-pink-20">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_inner</xsl:text></xsl:attribute>
					<div class="blob_Label">
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_label</xsl:text></xsl:attribute>
						{{{link}}}
					</div>
					<i class="fa fa-info-circle infoButton"/>
					<div class="hiddenDiv">{{description}}</div>
				</div>
			</div>
		</script>
		
		<h2 class="text-primary bottom-15">Welcome to the Technology Product Selector</h2>
		<p class="lead"><strong>This report assists you in the selection of appropriate and standards compliant Technology Products needed to implement a given Shared Platform.</strong></p>
		<!-- Modal -->
		<div class="modal fade" id="appModal" role="dialog" aria-labelledby="myModalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
						<h2 class="modal-title text-primary" id="myModalLabel">New Shared Platform Details</h2>
					</div>
					<div class="modal-body">
						<h4 class="bottom-15">Enter details for the new Shared Platform</h4>
						<form>
							<div class="form-group">
								<label for="newAppName">Platform Name</label>
								<input id="newAppName" class="form-control" type="text" placeholder="Name"/>
							</div>
							<div class="form-group">
								<label for="newAppDesc">Platform Description</label>
								<input id="newAppDesc" class="form-control" type="text" placeholder="Description"/>
							</div>
						</form>
						<span id="newAppError"/>
					</div>
					<div class="modal-footer">
						<button type="button" id="cancelNewAppBtn" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="button" id="createNewAppBtn" class="btn btn-primary">Create Shared Platform</button>
					</div>
				</div>
			</div>
		</div>
		<div class="appSelection dashboardPanel bg-offwhite bottom-30 pull-left">
			<p class="lead">Please select or create the Shared Platform to be implemented:</p>
			<select id="applicationList" style="width:40%;"/>
			<div class="clearfix bottom-15"/>
			<div id="app-selection"/>
		</div>
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE TECHNOLOGY CAPABILITY SELECTION PAGE -->
	<xsl:template name="RenderTechCapSelectionSection">
		<xsl:call-template name="techRefModelBasicInclude"/>
		
		<script id="tech-service-quality-template" type="text/x-handlebars-template">
			{{#techServiceQualities}}
				<div class="serviceQualOuter">
					<div class="serviceQual-title fontBlack large">{{name}}</div>
					<input type="text">
						<xsl:attribute name="id">{{{id}}}</xsl:attribute>
					</input>
				</div>
			{{/techServiceQualities}}
		</script>
		
		<script>
			$(document).ready(function() {
			 	$('.matchHeight1').matchHeight();
			});
		</script>
		<div class="row">
			<div class="col-xs-12 col-md-9">
				<h3 class="section-title bg-black">i. Select Technology Capabilities<span class="pull-right xxxsmall"><i class="fa fa-sitemap text-white right-5"/>Reference Architecture Available</span></h3>
				<div class="dashboardPanel bg-offwhite">
					<div class="row">
						<!-- REFERENCE MODEL CONTAINER -->
						<div class="simple-scroller" id="techRefModelContainer"/>					
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-md-3">
				<h3 class="section-title bg-black">ii. Select Requirements</h3>
				<div class="dashboardPanel bg-offwhite">	
					<div class="row">
						<!-- REFERENCE MODEL CONTAINER -->
						<div class="simple-scroller" id="techSvcQualities">
							<div class="col-xs-12">
								<div id="tsqWeightingContainer"/>						
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template name="RenderTechArchSelectionSection">
		
		<script id="tech-capability-bullets" type="text/x-handlebars-template">
			<ul>
			{{#techCapabilities}}
				{{#if inScope}}
					<li class="textColourRed"><strong>{{name}}</strong></li>
				{{else}}
					<li>{{name}}</li>
				{{/if}}
			{{/techCapabilities}}
			</ul>
		</script>
		
		<script id="service-quality-fit-section-template" type="text/x-handlebars-template">
			{{#if none}}
				<h4 class="section-title backColourGrey">Service Quality Fit</h4>
			{{/if}}
			{{#if high}}
				<h4 class="section-title backColourGreen">Service Quality Fit - High</h4>
			{{/if}}
			{{#if medium}}
				<h4 class="section-title backColourOrange">Service Quality Fit - Medium</h4>
			{{/if}}
			{{#if low}}
				<h4 class="section-title backColourRed">Service Quality Fit - Low</h4>
			{{/if}}
			{{#scores}}
				<div class="gaugePanel">
					<div class="gaugeContainer top-10">
						<canvas style="width: 100%;">
							<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
						</canvas>
					</div>
					<div class="gaugeLabel strong">{{name}}</div>
				</div>
			{{/scores}}
		</script>
		
		<script id="service-quality-fit-template" type="text/x-handlebars-template">
			{{#if high}}
				<button class="btn btn-block backColourGreen">High</button>
			{{/if}}
			{{#if medium}}
				<button class="btn btn-block backColourOrange">Medium</button>
			{{/if}}
			{{#if low}}
				<button class="btn btn-block backColourRed">Low</button>
			{{/if}}
		</script>
		
		<script id="tech-capability-blob-template" type="text/x-handlebars-template">
			{{#techCapabilities}}
				<div class="blob_Outer">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<div>
						<xsl:attribute name="class"><xsl:text disable-output-escaping="yes">blob_Box {{#if covered}}bg-darkblue-100{{else}}backColourGrey{{/if}}</xsl:text></xsl:attribute>
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_inner</xsl:text></xsl:attribute>
						<div class="blob_Label">
							<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_label</xsl:text></xsl:attribute>
							{{{link}}}
						</div>
						<i class="fa fa-info-circle infoButton"/>
						<div class="hiddenDiv">{{description}}</div>
					</div>
				</div>
			{{/techCapabilities}}
		</script>
		<div class="row">
			<div class="col-xs-12 col-md-4">
				<h3 class="section-title bg-black">i. Reference Architecture List</h3>
				<div class="dashboardPanel bg-offwhite" style="height: 451px;">	
					<div class="bottom-30 pull-left">
						<table class="small table table-striped table-bordered" id="dt_refArchList">
							<thead>
								<tr>
									<th>&#32;</th>
									<th>
										<xsl:value-of select="eas:i18n('Name')"/>						
									</th>
									<!--<th>
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>-->
									<th>
										<xsl:value-of select="eas:i18n('Capabilities')"/>									
									</th>
								</tr>
							</thead>
							<tfoot>
								<tr>
									<th>&#32;</th>
									<th>
										<xsl:value-of select="eas:i18n('Name')"/>						
									</th>
									<!--<th>
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>-->
									<th>
										<xsl:value-of select="eas:i18n('Capabilities')"/>									
									</th>
								</tr>
							</tfoot>
							<tbody/>									
						</table>			
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-md-8">
				<h3 class="section-title bg-black">ii. Reference Architecture Details</h3>
				<div class="dashboardPanel bg-offwhite">
					<div class="row">
						<div class="col-md-8">
							<h4 class="section-title bg-darkgrey">Logical Model</h4>
							<div class="simple-scroller">
								<div id="simple-scroller-inner" nostyle="margin: 0 auto;">
									<div id="refArchModelDiv"/>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div id="serviceQualityFitDiv" class="bg-white pull-left">
								<h4 class="section-title bg-darkgrey">Service Quality Fit</h4>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-xs-12">
				<h3 class="section-title bg-black">iii. Selected Reference Architectures</h3>
				<div class="dashboardPanel bg-offwhite">
					<div class="row">
						<div class="col-md-6 pull-left">
							<h4 class="section-title bg-darkgrey">Reference Architectures</h4>
							<table class="small table table-striped table-bordered" id="dt_selectedRefArchs">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Name')"/>						
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th class="alignCentre">
											<xsl:value-of select="eas:i18n('Service Quality Fit')"/>									
										</th>
									</tr>
								</thead>
								<!--<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Name')"/>						
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Service Quality Fit')"/>									
										</th>
									</tr>
								</tfoot>-->
								<tbody/>				
							</table>
						</div>
						<div class="col-md-6 pull-left">
							<h4 class="section-title bg-darkgrey">Technology Capability Footprint</h4>
							<div id="techCapFootprintDiv"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--Help Panel Starts-->
		<div class="btn btn-default helpButton hiddenDiv" href="images/screenshots/tech-prod-selector-help.png" data-toggle="lightbox"><i class="fa fa-question-circle right-5"/><span class="fontBlack">Help with this page</span></div>
		<!--Help Panel Ends-->

	</xsl:template>
	
	
	<!-- TENMPLATE TO RENDER THE MAIN SECTIONS OF THE PAGE -->
	<xsl:template name="RenderTechSelectorPanels">
		<script id="tech-arch-list-template" type="text/x-handlebars-template">
			<option/>
			{{#techArchPatterns}}
		  		<option>
		  			<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
		  			{{name}}
		  		</option>
			{{/techArchPatterns}}
		</script>
		<script id="tech-comp-list-template" type="text/x-handlebars-template">
			<option/>
			{{#techComponents}}
		  		<option>
		  			<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
		  			{{name}}
		  		</option>
			{{/techComponents}}
		</script>
		<script id="tech-product-template" type="text/x-handlebars-template">
			{{#techProducts}}
				<div class="blob_Outer draggableTechProd">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{techProdId}}</xsl:text></xsl:attribute>
					<div>
						<xsl:attribute name="class"><xsl:text disable-output-escaping="yes">blob_Box {{complianceStyle}}</xsl:text></xsl:attribute>
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{techProdId}}_inner</xsl:text></xsl:attribute>
						<div class="blob_Label">
							<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{techProdId}}_label</xsl:text></xsl:attribute>
							{{{techProdLink}}}
						</div>
						<i class="fa fa-info-circle infoButton"/>
						<div class="hiddenDiv">{{techProdDesc}}</div>
					</div>
				</div>
			{{/techProducts}}
		</script>
		<div id="panelWrapper">
			<div class="row">
				<div class="col-xs-12 col-md-6">
					<h3 class="section-title bg-black">i. Select Reference Architecture</h3>
					<div class="dashboardPanel bg-offwhite bottom-15">
						<p class="small">
								<em>Select a Reference Architecture to be implemented</em>
							</p>
							<select id="techArchList" style="width:100%;"/>
					</div>
					<div class="clearfix"></div>
					<h3 class="section-title bg-black">ii. Select Technology Products</h3>
					<div class="dashboardPanel bg-offwhite">
						<div class="techProdSelection pull-left">
							
							<div class="bottom-10"/>
							<p class="small">
								<em>Select a Technology Component on the right then drag a Technology Product on to each Component in the selected Architecture</em>
							</p>
							<!--<select id="techComponentList" style="width:100%;"/>-->
							<div class="clearfix bottom-10"/>
							<div id="keyContainer">
								<div class="keyLabel">Legend:</div>
								<xsl:apply-templates mode="RenderStandardStrengthLegendKey" select="$allStandardStrengths">
									<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
								</xsl:apply-templates>
								<div>
									<xsl:attribute name="class">keySample <xsl:value-of select="$nonCompliantStyleClass"/></xsl:attribute>
								</div>
								<div class="keySampleLabel">Non Compliant</div>
							</div>
							<div class="verticalSpacer_10px"/>
							<div id="tech-prod-selection"/>					
						</div>
						</div>
					</div>
					<div class="col-xs-12 col-md-6">
						<h3 class="section-title bg-black">iii. Reference Architecture Workspace</h3>
						<div class="dashboardPanel bg-offwhite">
						<div class="dropspace bg-white">
							<p id="userInstruction" class="text-lightgrey xlarge fontBlack alignCentre">Select a Reference Architecture</p>
							<div class="workspaceL0_Outer techArchitecture" id="tech-architecture"/>				
						</div>
						<div class="workspace bg-offwhite">
							<div class="workspaceL0_Outer">
								<div>
									<script>
										$(document).ready(function(){
											var windowWidth = $(window).width()*2;
											$('#simple-scroller-inner').width(windowWidth);
										});
									</script>
									<div class="simple-scroller">
										<div id="simple-scroller-inner" nostyle="margin: 0 auto;">
											<div id="techArchModelDiv"/>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template name="RenderResultsPanel">
		<h3 class="section-title bg-black">i. Selected Technology Products</h3>
			<div class="dashboardPanel bg-white">
				<p>The table below lists the technology products selected to implement the Shared Platform.</p>
				<table class="table table-striped table-bordered" id="dt_selectedTechProds">
					<thead>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Application')"/>								
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Reference Architecture')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Technology Component')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Product Supplier')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Product')"/>									
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Compliance Level')"/>									
							</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Application')"/>								
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Reference Architecture')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Technology Component')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Product Supplier')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Product')"/>									
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Compliance Level')"/>									
							</th>
						</tr>
					</tfoot>
					<tbody/>				
				</table>	
			</div>
			<div class="verticalSpacer_20px"/>
			<h3 class="section-title bg-black">ii. Application Technology Architecture Export</h3>
			<div class="dashboardPanel bg-white">
				<p id="appTechArchLinksIntro">The table below provides a means to export a spreadsheet that can be imported to capture the underlying technology product architecture for the selected IT solution.</p>
				<table class="table table-striped table-bordered" id="dt_appTechArchsExport">
					<thead>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Application')"/>								
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Environment')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('From Technology Product')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('From Technology Component')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('To Technology Product')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('To Technology Component')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Reference Architecture')"/>
							</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Application')"/>								
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Environment')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('From Technology Product')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('From Technology Component')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('To Technology Product')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('To Technology Component')"/>						
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Reference Architecture')"/>
							</th>
						</tr>
					</tfoot>
					<tbody/>				
				</table>	
			</div>
	</xsl:template>
	
	<!-- TEMPLATE TO CREATE A TECHNOLOGY CAPABILITY JSON OBJECT -->
	<xsl:template match="node()" mode="RenderTechCapabilityJSON">
		<xsl:variable name="this" select="current()"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"></xsl:with-param><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">app-text</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			inScope: false
		}<xsl:if test="not(position()=last())">,
		</xsl:if> 
	</xsl:template>
	
	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="techDomainName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template></xsl:variable>
		<xsl:variable name="techDomainDescription"><xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template></xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = $this/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			name: "<xsl:value-of select="$techDomainName"/>",
			description: "<xsl:value-of select="$techDomainDescription"/>",
			link: "<xsl:value-of select="$techDomainLink"/>",
			childTechCaps: [
				<xsl:apply-templates select="$childTechCaps" mode="RenderChildTechCaps"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildTechCaps">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="techCapName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template></xsl:variable>
		<xsl:variable name="techCapDescription"><xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template></xsl:variable>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			name: "<xsl:value-of select="$techCapName"/>",
			link: "<xsl:value-of select="$techCapLink"/>",
			description: "<xsl:value-of select="$techCapDescription"/>",
			isRelevant: <xsl:choose><xsl:when test="$this/name = $allRelevantTechCaps/name">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- Template to render the JSON structure for a Technology Service Quality -->
	<xsl:template mode="RenderTechSvcQualityJSON" match="node()">	
		<xsl:variable name="thisTechSvcQual" select="current()"/>
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($thisTechSvcQual/name)"/>',
			name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisTechSvcQual"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			description: '<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisTechSvcQual"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			weighting: 1
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- Template to render the JSON structure for a Technology Architecture Pattern -->
	<xsl:template mode="RenderTechArchitecturePatternJSON" match="node()">
		<xsl:variable name="thisTechComposite" select="current()"/>
		
		<xsl:variable name="thisTechCompArchitecture" select="$allTechCompArchitectures[name = $thisTechComposite/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
		<xsl:variable name="thisTechCompUsages" select="$allTechCompUsages[name = $thisTechCompArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
		<xsl:variable name="thisTechCompRelations" select="$allTechCompRelations[name = $thisTechCompArchitecture/own_slot_value[slot_reference = 'invoked_functions_relations']/value]"/>
		<xsl:variable name="thisTechComponents" select="$allTechComponents[name = $thisTechCompUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
		
		<xsl:variable name="thisTechCaps" select="$allTechCaps[name = $thisTechComponents/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value]"/>
		
		<xsl:variable name="thisPerformanceMeasure" select="$allPerformanceMeasures[name = $thisTechComposite/own_slot_value[slot_reference = 'performance_measures']/value]"/>
		<xsl:variable name="thisServiceQualityVals" select="$allServiceQualityVals[name = $thisPerformanceMeasure/own_slot_value[slot_reference = 'pm_performance_value']/value]"/>
		<!--<xsl:variable name="thisServiceQualities" select="$allServiceQualities[name = $thisServiceQualityVals/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>-->
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($thisTechComposite/name)"/>',
			name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisTechComposite"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			description: '<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisTechComposite"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			link: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisTechComposite"/></xsl:call-template>',
			techCapabilities: [<xsl:apply-templates mode="RenderInstanceIdJSONList" select="$thisTechCaps"/>],
			techServiceQualityVals: [<xsl:apply-templates mode="RenderTechSvcQualsForTechArchJSON" select="$thisServiceQualityVals"><xsl:sort select="own_slot_value[slot_reference = 'usage_of_service_quality']/value"/></xsl:apply-templates>],
			techComponents: [<xsl:apply-templates mode="RenderInstanceIdJSONList" select="$thisTechComponents"/>],
			techCompLinks: [
				<xsl:apply-templates mode="RenderTechComponentLinkJSON" select="$thisTechCompRelations"><xsl:with-param name="relevantTechCompUsages" select="$thisTechCompUsages"/><xsl:with-param name="relevantTechComps" select="$thisTechComponents"/></xsl:apply-templates>
			],
			serviceQualityFit: 0
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- Template to render the JSON structure for the Technology Capabilities implemented by a Technology Architecture -->
	<xsl:template mode="RenderTechCapForTechArchJSON" match="node()">	
		<xsl:variable name="thisTechCap" select="current()"/>
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($thisTechCap/name)"/>',
			name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisTechCap"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			link: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisTechCap"/></xsl:call-template>'
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<!-- Template to render the JSON structure for the Service Quality Values for a Technology Architecture -->
	<xsl:template mode="RenderTechSvcQualsForTechArchJSON" match="node()">	
		<xsl:variable name="thisTechSvcQualVal" select="current()"/>
		
		<xsl:variable name="thisTechSvcQual" select="$allServiceQualities[name = $thisTechSvcQualVal/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
		<xsl:variable name="thisTechSvcQualScore" select="$thisTechSvcQualVal/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>
		
		<xsl:variable name="thisScore">
			<xsl:choose>
				<xsl:when test="string-length($thisTechSvcQualScore) > 0"><xsl:value-of select="$thisTechSvcQualScore"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		{
			id: '<xsl:value-of select="eas:getSafeJSString($thisTechSvcQual/name)"/>',
			name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisTechSvcQual"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			score: <xsl:value-of select="$thisScore"/>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<!-- Template to render the JSON structure for a Technology Component Relation -->
	<xsl:template mode="RenderTechComponentLinkJSON" match="node()">
		<xsl:param name="relevantTechCompUsages"/>
		<xsl:param name="relevantTechComps"/>
		
		<xsl:variable name="currentTechArchLink" select="current()"/>
		
		<xsl:variable name="sourceTechCompUsage" select="$relevantTechCompUsages[name = $currentTechArchLink/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="sourceTechComp" select="$relevantTechComps[name = $sourceTechCompUsage/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
		<xsl:variable name="targetTechCompUsage" select="$relevantTechCompUsages[name = $currentTechArchLink/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="targetTechComp" select="$relevantTechComps[name = $targetTechCompUsage/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>	
		
		{
			sourceId: '<xsl:value-of select="eas:getSafeJSString($sourceTechComp/name)"/>',
			sourceRef: 'techComp<xsl:value-of select="index-of($allTechComponents, $sourceTechComp)"/>',
			targetId: '<xsl:value-of select="eas:getSafeJSString($targetTechComp/name)"/>',
			targetRef: 'techComp<xsl:value-of select="index-of($allTechComponents, $targetTechComp)"/>'
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- Template to render the JSON structure for a Technology Component -->
	<xsl:template mode="RenderTechComponentJSON" match="node()">
		<xsl:variable name="currentTechComponent" select="current()"/>
		
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $currentTechComponent/name]"/>
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($currentTechComponent/name)"/>',
			ref: 'techComp<xsl:value-of select="index-of($allTechComponents, $currentTechComponent)"/>',
			name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$currentTechComponent"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			description: '<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$currentTechComponent"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			link: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$currentTechComponent"/></xsl:call-template>',
			techProducts: [<xsl:apply-templates mode="RenderTechProductForTechCompJSON" select="$thisTechProdRoles"><xsl:with-param name="thisTechComp" select="$currentTechComponent"/></xsl:apply-templates>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- Template to render the JSON structure for a Technology Product -->
	<xsl:template mode="RenderTechProductForTechCompJSON" match="node()">
		<xsl:param name="thisTechComp"/>	
		<xsl:variable name="thisTechProdRole" select="current()"/>
		<xsl:variable name="thisTechProduct" select="$allTechProducts[name = $thisTechProdRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="thisTechProdSupplier" select="$allTechProdSuppliers[name = $thisTechProduct/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:variable name="thisTechProdStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $thisTechProdRole/name]"/>
		<xsl:variable name="thisStandardStrength" select="$allStandardStrengths[name = $thisTechProdStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
		<xsl:variable name="thisStandardsStyle" select="$allStandardsStyles[name = $thisStandardStrength/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
		
		
		<xsl:variable name="complianceStyle">
			<xsl:choose>
				<xsl:when test="count($thisStandardsStyle) > 0">
					<xsl:value-of select="$thisStandardsStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nonCompliantStyleClass"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="complianceColour">
			<xsl:choose>
				<xsl:when test="count($thisStandardsStyle) > 0">
					<xsl:value-of select="$thisStandardsStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nonCompliantColour"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="complianceLabel">
			<xsl:choose>
				<xsl:when test="count($thisStandardStrength) > 0">
					<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisStandardStrength"/></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>Non Compliant</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($thisTechProdRole/name)"/>',
			techProdId: '<xsl:value-of select="eas:getSafeJSString($thisTechProduct/name)"/>',
			techProdName: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisTechProduct"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			techProdLink: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisTechProduct"/><xsl:with-param name="anchorClass" select="'text-white'"/></xsl:call-template>',
			techProdDesc: '<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisTechProduct"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			techProdSupplierLink: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisTechProdSupplier"/></xsl:call-template>',
			techCompId: '<xsl:value-of select="eas:getSafeJSString($thisTechComp/name)"/>',
			techCompRef: 'techComp<xsl:value-of select="index-of($allTechComponents, $thisTechComp)"/>',
			techCompLink: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisTechComp"/></xsl:call-template>',
			techCompDesc: '<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$thisTechComp"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>',
			complianceStyle: '<xsl:value-of select="$complianceStyle"/>',
			complianceColour: '<xsl:value-of select="$complianceColour"/>',
			complianceLevel: '<button><xsl:attribute name="class">btn btn-block <xsl:value-of select="$complianceStyle"/></xsl:attribute><xsl:value-of select="$complianceLabel"/></button>'
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- Template to render the JSON structure for a Technology Product -->
	<xsl:template mode="RenderTechProductJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($this/name)"/>',
			name: '<xsl:value-of select="$thisName"/>',
			description: '<xsl:value-of select="$thisDesc"/>',
			link: '<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>'
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	
	<!-- Template to render the JSON structure for a Compiance Level -->
	<xsl:template mode="RenderComplianceLevelJSON" match="node()">
				
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			id: '<xsl:value-of select="eas:getSafeJSString($this/name)"/>',
			name: '<xsl:value-of select="$thisName"/>',
			description: '<xsl:value-of select="$thisDesc"/>',
			style: '',
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getApplications">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			name: "<xsl:value-of select="$thisName"/>",
			description: "<xsl:value-of select="$thisDesc"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">app-text</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			selected: false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<xsl:template mode="RenderInstanceIdJSONList" match="node()">
		<xsl:variable name="this" select="current()"/>
		'<xsl:value-of select="eas:getSafeJSString($this/name)"/>'<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	<xsl:template mode="RenderStandardStrengthLegendKey" match="node()">
		<xsl:variable name="thisStandardStrength" select="current()"/>
		<xsl:variable name="thisStandardsStyle" select="$allStandardsStyles[name = $thisStandardStrength/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
		
		<div>
			<xsl:attribute name="class">keySample <xsl:value-of select="$thisStandardsStyle/own_slot_value[slot_reference = 'element_style_class']/value"/></xsl:attribute>
		</div>
		<div class="keySampleLabel"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisStandardStrength"/></xsl:call-template></div>
	</xsl:template>

</xsl:stylesheet>
