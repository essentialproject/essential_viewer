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
	<xsl:variable name="linkClasses" select="('Strategic_Trend_Implication', 'Application_Capability', 'Business_Capability', 'Business_Goal', 'Business_Objective')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	<!-- Get default geographic map -->
	<xsl:variable name="geoMapReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Geographic Map')]"/>
	<xsl:variable name="geoMapInstance" select="/node()/simple_instance[name = $geoMapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="geoMapId">
		<xsl:choose>
			<xsl:when test="count($geoMapInstance) > 0"><xsl:value-of select="$geoMapInstance[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:when>
			<xsl:otherwise>world_mill</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="geoMapPath">
		<xsl:choose>
			<xsl:when test="count($geoMapInstance) > 0"><xsl:value-of select="$geoMapInstance[1]/own_slot_value[slot_reference = 'description']/value"/></xsl:when>
			<xsl:otherwise>js/jvectormap/jquery-jvectormap-world-mill.js</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="thisStratTrendImpl" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="thisImplLabel" select="$thisStratTrendImpl/own_slot_value[slot_reference = 'sti_label']/value"/>
	<xsl:variable name="thisStratImplEAImpactRels" select="/node()/simple_instance[name = $thisStratTrendImpl/own_slot_value[slot_reference = 'sti_enterprise_impacts']/value]"/>
	<xsl:variable name="thisStratImplEAImpacts" select="/node()/simple_instance[name = $thisStratImplEAImpactRels/own_slot_value[slot_reference = 'implication_to_element_to_ea_element']/value]"/>
	
	
	<!-- Goals and Objectives -->
	<xsl:variable name="stratGoalTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>
	<xsl:variable name="objectiveTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="allBusinessGoals" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $stratGoalTaxTerm/name]"/>
	<xsl:variable name="allBusinessObjectives" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $objectiveTaxTerm/name]"/>
	
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
	
	<!-- Products -->
	<xsl:variable name="allProductConcepts" select="/node()/simple_instance[type = 'Product_Concept']"/>
	
	<!-- Eco System Roles -->
	<xsl:variable name="allStakeholderRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'role_for_classes']/value = 'Strategic_Trend_Implication')]"/>
	
	<!-- Value Streams -->
	<xsl:variable name="allValueStages" select="/node()/simple_instance[type='Value_Stage']"/>
	<xsl:variable name="allValueStreams" select="/node()/simple_instance[own_slot_value[slot_reference = 'vs_value_stages']/value = $allValueStages/name]"/>
	
	
	
	<!-- Application and Technology Reference Models -->
	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
	
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	<xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
	
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	
	
	
	<!-- Applications -->
	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allPhyProc2AppProRoleRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $allPhysicalProcesses/name]"/>
	<xsl:variable name="allPhyProcAppProRoles" select="$allAppProviderRoles[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="allPhyProcDirectApps" select="/node()/simple_instance[name = $allPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allPhyProcIndirectApps" select="/node()/simple_instance[name = $allPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allApplications" select="$allPhyProcDirectApps union $allPhyProcIndirectApps"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[name = $allAppProviderRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
	

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


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:call-template name="RenderModalReportContent">
					<xsl:with-param name="essModalClassNames" select="$linkClasses"/>
				</xsl:call-template>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Strategic Implication Dashboard')"/>: <xsl:value-of select="$thisImplLabel"/></title>
				
				<!-- gannt chart library -->
				<script src="js/dhtmlxgantt/dhtmlxgantt.js"/>
				<link href="js/dhtmlxgantt/dhtmlxgantt.css" rel="stylesheet"/>
				<link rel="stylesheet" href="css/dthmlxgantt_eas_skin.css"/>
				
				<!-- Date formatting library -->
				<script type="text/javascript" src="js/moment/moment.js"/>
				
				
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"/>
				<script src="{$geoMapPath}" type="text/javascript"/>
				
				<!-- Start Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				
				<!-- Start Templating Libraries -->
				<script src="js/handlebars-v4.1.2.js"/>
				
				<!-- Chart library -->
				<script src="js/chartjs/Chart.min.js"/>
				
				<style type="text/css">
					
					.map{
						width: 100%;
						height: 360px;
					}
					
					.bus-env-chart {
						height: 300px;
					}
					
					
					.goal_Outer, .blob_Outer{
						width: 140px;
						float: left;
						margin: 0 15px 15px 0;
						box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
						opacity: 1;
    					-webkit-transition: opacity 1000ms linear;
    					transition: opacity 1000ms linear;
					}
					
					.goal_Box, .blob_Box{
						width: 100%;
						height: 60px;
						padding: 5px;
						text-align: center;
						border-radius: 0px;
						border: 1px solid #ccc;
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
						background-color: hsla(37, 92%, 55%, 1) !important;
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
	
					.v3-refModel-l0-outer{
						<!--background-color: pink;-->
						border: 1px solid #aaa;
						padding: 10px 10px 0px 10px;
						border-radius: 4px;
						background-color: #eee;
					}
					
					.v3-refModel-l0-title{
						margin-bottom: 5px;
						line-height: 1.1em;
					}
					
					.v3-refModel-l1-outer{
					}
					
					.v3-refModel-l1-title{
					}
					
					.v3-refModel-blob, .v3-busRefModel-blob, .v3-appRefModel-blob, .v3-techRefModel-blob {
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
					
					.v3-busRefModel-blob-noheatmap {
						background-color: #999;
					}
					
					.v3-busRefModel-blob-selected {
						border: 3px solid red!important;
					}
					
					.v3-refModel-blob:hover {border: 2px solid #666;}
					
					.v3-refModel-blob-title{
						display: table-cell;
						vertical-align: middle;
						line-height: 1em;
					}
					
					.v3-refModel-blob-info {
						position: absolute;
						bottom: -2px;
						right: 1px;
					}
					
					.v3-refModel-blob-info > i {
						color: #fff;
					}
					
					.refModel-blob-refArch {
						position: absolute;
						bottom: 0px;
						left: 2px;
					}
					.v3-busRefModel-blobWrapper{
						border: 1px solid #ccc;
						display:  block;
						width: 130px;
						height: 74px;
						float: left;
						margin-right: 10px;
						margin-bottom: 10px;
						background-color: #fff;
					}
					
					.v3-busRefModel-blobAnnotationWrapper {
						width:100%;
						height: 24px;
						font-size: 12px;
						line-spacing: 1.1em;
						background-color: #fff;
					}
					
					.v3-blobAnnotationL,.v3-blobAnnotationR,.v3-blobAnnotationC {
						float:left;
						padding: 2px;
						text-align: center;
						border-top: 1px solid #ccc;
						height: 100%;
					}
					
					.v3-blobAnnotationL {width: 25%;}
					.v3-blobAnnotationC {width: 50%; border-left: 1px solid #ccc;border-right: 1px solid #ccc;}
					.v3-blobAnnotationR {width: 25%;}
					
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
					    background: url(images/value_chain_arrow_end_grey.png) #ddd no-repeat right center;
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
					
					/****************************************************************
					
					Gantt Chart Styles
					******************************************************************/

						
					
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
				
				<xsl:call-template name="refModelStyles"/>
				
				
				<script>
					function showHelpButton(){
						setTimeout(function(){$('.helpButton').fadeIn(1000);}, 1000);
						$('.helpButton').draggable();
					};

					
				</script>
				
				
				<style>
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Strategic Implication Dashboard')"/></span>
								</h1>
								<h2><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$thisStratTrendImpl"/><xsl:with-param name="displayString" select="$thisImplLabel"/></xsl:call-template></h2>
							</div>
						</div>

						<!-- Header Section-->
						<!--<div class="col-xs-12">
							<a class="btn btn-primary" role="button" data-toggle="collapse" href="#implList" aria-expanded="false" aria-controls="implList">
								Select Implication
							</a>
						</div>
											
						<div  id="implList" class="col-xs-12">
							<div class="dashboardPanel bg-offwhite match1">
								<table class="small table table-striped table-bordered" id="dt_implList">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Trend')"/>						
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Implication')"/>						
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Priority')"/>						
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Status')"/>									
											</th>
										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Trend')"/>						
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Implication')"/>						
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Priority')"/>						
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Status')"/>									
											</th>
										</tr>
									</tfoot>
									<tbody/>									
								</table>
							</div>
						</div>-->
						
						
						<!-- Section Tabs-->
						<div class="col-xs-12">
							<!-- Nav tabs -->
							<ul id="impactTabs" class="nav nav-tabs" role="tablist">
								<li role="presentation" class="active"><a href="#busenvImpactTab" aria-controls="busenvImpactTab" role="tab" data-toggle="tab">Business Environment Impact</a></li>
								<li role="presentation"><a href="#stratImpactTab" aria-controls="stratImpactTab" role="tab" data-toggle="tab">Strategy Impact</a></li>
								<li role="presentation"><a href="#finImpactTab" aria-controls="finImpactTab" role="tab" data-toggle="tab">Financial Impact</a></li>
								<li role="presentation"><a href="#kpiImpactTab" aria-controls="kpiImpactTab" role="tab" data-toggle="tab">KPI Impact</a></li>
								<li role="presentation"><a href="#busImpactTab" aria-controls="busImpactTab" role="tab" data-toggle="tab">Business Impact</a></li>
								<li role="presentation"><a href="#itImpactTab" aria-controls="itImpactTab" role="tab" data-toggle="tab">IT Impact</a></li>
							</ul>
							
							<div class="tab-content">
								<div role="tabpanel" class="tab-pane fade in active" id="busenvImpactTab"><xsl:call-template name="BusinessEnvironmentImpactContent"/></div>
								<div role="tabpanel" class="tab-pane fade" id="stratImpactTab"><xsl:call-template name="StrategyImpactContent"/></div>
								<div role="tabpanel" class="tab-pane fade" id="finImpactTab"><xsl:call-template name="FinancialImpactContent"/></div>
								<div role="tabpanel" class="tab-pane fade" id="kpiImpactTab"><xsl:call-template name="KPIImpactContent"/></div>
								<div role="tabpanel" class="tab-pane fade" id="busImpactTab"><xsl:call-template name="BusinessImpactContent"/></div>
								<div role="tabpanel" class="tab-pane fade" id="itImpactTab"><xsl:call-template name="ITImpactContent"/></div>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					<!-- Handlebar templates -->
					var goalTemplate, goalDetailTemplate, valueStagesTemplate, productTemplate, stakeholderTemplate, busCapDetailTemplate, ganttStratPlanTemplate;
					
					<!-- Read only JSON objects -->
					var viewData = <xsl:call-template name="getReadOnlyJSON"/>;
					
			
					// Dynamic User defined JSON objects
					var dynamicUserData = {
						currentStrategicPlan: null,
						currentPlanningActions: null,
						roadmap: null,
						strategicPlans: [],
						planDeps: []
					};
					
					
					function setCurrentValueStream(vsId) {
						var currentValueStream = viewData.valueStreams.find(function(aVS) {
							return aVS.id == vsId;
						});
						
						if(currentValueStream != null) {
							// console.log('Setting current value stream: ' + currentValueStream.valueStages.length);
							// setValueStageStyles(valueStream.valueStages);							
							$("#valueStagesContainer").html(valueStagesTemplate(currentValueStream));
						}
					}
					
					
					function updateStatsForCountry(aCode) {
						//get the relevant data sets for the given code
						
						//set the pre and post values for the relevant business environment factors


						//set the pre and post values for the relevant cost types
						
						
						//set the pre and post values for the relevant revenue types
						
						
						//set the pre and post values for the relevant business outcomes
					}
					
					<!--var implListTable;
        
			        function drawImplicationTable() {
			          // Setup - add a text input to each footer cell
					    $('#dt_implList tfoot th').each( function (index) {
					    	if(index > 0) {
					        	var title = $(this).text();
					        	$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					        }
					    } );
						
						implListTable = $('#dt_implList').DataTable({
							scrollY: "300px",
							scrollCollapse: true,
							paging: false,
							info: false,
							sort: true,
							responsive: true,
							order: [[1, 'asc']],
							select: true,
							columns: [
								{ "width": "15%" },
								{ "width": "30%" },
							    { "width": "35%" },
							    { "width": "10%" },
							    { "width": "10%" },
							 ],
							dom: 'frtip'
						});
						
						//Add the events handlers when selecting rows in the relevant reference architectures table
						implListTable
				        .on( 'select', function ( e, dt, type, indexes ) {
				            //do something
				        } )
				        .on( 'deselect', function ( e, dt, type, indexes ) {
				        	//do something
				        } );
						
											
						// Apply the search
					    implListTable.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    implListTable.columns.adjust();
					    
					    $(window).resize( function () {
					        implListTable.columns.adjust();
					    });
        
        }-->
					
					
					/********************************************************
					BUSINESS ENVIRONMENT FACTORS CHART FUNCTIONS
					********************************************************/
					
					// function to initialise the costs and revenues charts
					function renderBusEnvFactorChart(chartContainerId) {
							var chartCtx = $(chartContainerId);
							
							
							var bevLabels = {				
								'#busenv1content': [
								    "Trade control",
								    "Competition regulation",
								    "Corruption Level"
							  	 ],
							  	 '#busenv2content': [
								  	 "Exchange rate",
								    "Exchange rate",
								    "Gross domestic product trend"
							  	 ],
							  	 '#busenv3content': [
							  	 	"Crime levels",
								    "Health consciousness",
								    "Buying habits",
								    "Attitudes towards customer service"
							  	 ],
							  	 '#busenv4content': [
							  	 	 "Automation",
								    "Level of innovation",
								    "Internet infrastructure",
								    "Access to new technology"
							  	 ],
							  	 '#busenv5content': [
							  	 	 "Data protection laws",
								    "Consumer protection laws",
								    "Antitrust laws"
							  	 ],
							  	 '#busenv6content': [
							  	 	 "Attitudes towards green products"
							  	 ]
						  	 }
		
		
						  	 var bevData1 = {				
								'#busenv1content': [3.2, 5.6, 6.8],
							  	 '#busenv2content': [6, 5, 6],
							  	 '#busenv3content': [6, 5, 6, 7],
							  	 '#busenv4content': [6, 5, 6, 7],
							  	 '#busenv5content': [6, 5, 6],
							  	 '#busenv6content': [6]
						  	 }
						  	 
						  	 var bevData2 = {				
								 '#busenv1content': [4.3, 7.3, 5.3],
							  	 '#busenv2content': [6, 5, 6],
							  	 '#busenv3content': [6, 5, 6, 7],
							  	 '#busenv4content': [6, 5, 6, 7],
							  	 '#busenv5content': [6, 5, 6],
							  	 '#busenv6content': [2]
						  	 }
							
							
							var tempCostChartData = {
							  labels: bevLabels[chartContainerId],
							  datasets: [
							    {
							      label: "2019",
							      backgroundColor: "rgba(10,20,30,0.3)",
							      borderColor: "rgba(10,20,30,1)",
							      borderWidth: 1,
							      data: bevData1[chartContainerId]
							    },
							    {
							      label: "2025",
							      backgroundColor: "rgba(50,150,200,0.3)",
							      borderColor: "rgba(50,150,200,1)",
							      borderWidth: 1,
							      data: bevData2[chartContainerId]
							    }
							  ]
							};
							
							var chartOptions = {
							  responsive: true,
							  legend: {
							    position: "top"
							  },
							  title: {
							    display: false
							  },
							  scales: {
							    yAxes: [{
							      ticks: {
							        beginAtZero: true
							      }
							    }]
							  }
							};
							
							new Chart(chartCtx, {
							    type: "horizontalBar",
							    data: tempCostChartData,
							    options: chartOptions
							});
					}
					
					
					
					
					/*****************************
					FINANCIAL CHART FUNCTIONS
					******************************/
					
					var costsBarChart, revenuesBarChart;
					
					// function to initialise the costs and revenues charts
					function initFinancialCharts() {
						if(costsBarChart == null) {
							var chartCtx = $('#costContainer');
							
							var tempCostChartData = {
							  labels: [
							    "Manufacturing",
							    "IT",
							    "People",
							    "Maintenance"
							  ],
							  datasets: [
							    {
							      label: "Impact %",
							      backgroundColor: "rgba(50,150,200,0.3)",
							      borderColor: "rgba(10,20,30,1)",
							      borderWidth: 1,
							      data: [-20, 15, -6, -7]
							    }
							  ]
							};
							
							var chartOptions = {
							  responsive: true,
							  legend: {
							    position: "top"
							  },
							  title: {
							    display: false
							  },
							  scales: {
							    yAxes: [{
							      ticks: {
							        beginAtZero: false
							      }
							    }]
							  }
							};
							
							costsBarChart = new Chart(chartCtx, {
							    type: "horizontalBar",
							    data: tempCostChartData,
							    options: chartOptions
							  });
						}
						
						if(revenuesBarChart == null) {
							var revChartCtx = $('#revsContainer');
							
							var tempRevChartData = {
							  labels: [
							    "Commission",
							    "Consulting Services",
							    "Direct Product Sales"
							  ],
							  datasets: [
							    {
							      label: "Impact %",
							      backgroundColor: "rgba(50,150,200,0.3)",
							      borderColor: "rgba(10,20,30,1)",
							      borderWidth: 1,
							      data: [-5, 15, 27]
							    }
							  ]
							};
							
							var revChartOptions = {
							  responsive: true,
							  legend: {
							    position: "top"
							  },
							  title: {
							    display: false
							  },
							  scales: {
							    yAxes: [{
							      ticks: {
							        beginAtZero: false
							      }
							    }]
							  }
							};
							
							costsBarChart = new Chart(revChartCtx, {
							    type: "horizontalBar",
							    data: tempRevChartData,
							    options: revChartOptions
							  });
						}
					}
					
					
					/*****************************
					KPI CHART FUNCTIONS
					******************************/
					
					var kpiBarChart;
					
					// function to initialise the kpi charts
					function initKPIChart() {
						if(kpiBarChart == null) {
							var chartCtx = $('#kpiContainer');
							
							var tempKPIChartData = {
							  labels: [
							    "New Customer Growth",
							    "Custoemr Complaints",
							    "Emmissions Offset",
							    "Fines"
							  ],
							  datasets: [
							    {
							      label: "2019",
							      backgroundColor: "rgba(10,20,30,0.3)",
							      borderColor: "rgba(10,20,30,1)",
							      borderWidth: 1,
							      data: [3, 5, 6, 7]
							    },
							    {
							      label: "2025",
							      backgroundColor: "rgba(50,150,200,0.3)",
							      borderColor: "rgba(50,150,200,1)",
							      borderWidth: 1,
							      data: [4, 7, 3, 6]
							    }
							  ]
							};
							
							var chartOptions = {
							  responsive: true,
							  legend: {
							    position: "top"
							  },
							  title: {
							    display: false
							  },
							  scales: {
							    yAxes: [{
							      ticks: {
							        beginAtZero: true
							      }
							    }]
							  }
							};
							
							kpiBarChart = new Chart(chartCtx, {
							    type: "horizontalBar",
							    data: tempKPIChartData,
							    options: chartOptions
							  });
						}
						
					}
					
					
					/*****************************
					START GANNT CHART FUNCTIONS
					******************************/
					var roadmapPlans;
					var selectedRoadmapPlanId;
					
					// utility function to format a JS date object to apprpriate format for gantt chart
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
					
					
					// function to update a strategic plan usuing the gantt chart
					function updateGanntStrategicPlan(ganttPlan) {
						<!--var thisStratPlan = getObjectById(dynamicUserData.strategicPlans, "id", ganttPlan.id);
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
						}-->
					}
					
					// function to initialise the roadmpa gantt chart
					function initRoadmapGantt() {
						if(roadmapPlans == null) {
							var aStratPlan, roadmapData;
							roadmapPlans = {
								data:[],
								links: []
							};
							
							//test roadmap data
							var testRoadmapData = [
								{
									id: 'plan1',
									text: 'Plan 1',
									description: 'This is plan 1',
									start_date: '01-02-2020',
									end_date: '01-08-2021'
								},
								{
									id: 'plan2',
									text: 'Plan 2',
									description: 'This is plan 2',
									start_date: '01-11-2019',
									end_date: '01-05-2020'
								},{
									id: 'plan3',
									text: 'Plan 3',
									description: 'This is plan 3',
									start_date: '03-05-2020',
									end_date: '25-08-2022'
								}
							];
							
							
							<!--for (var i = 0; dynamicUserData.strategicPlans.length > i; i += 1) {
								aStratPlan = dynamicUserData.strategicPlans[i];
								roadmapData = {
									id: aStratPlan.id,
									text: aStratPlan.name,
									description: aStratPlan.description,
									start_date: aStratPlan.startDate,
									end_date: aStratPlan.endDate
								};
								roadmapPlans.data.push(roadmapData);
							}-->
							
							roadmapPlans.data = testRoadmapData;
							
							gantt.config.scale_unit = "year";
							gantt.config.readonly = true;
							gantt.config.subscales = [
							    {unit:"month", step:1, date:"%F"}
							];
							gantt.config.step = 1;
							gantt.config.time_step = 7*24*60;
							gantt.config.min_duration = 7*24*60*60*1000;  // 1 week minimum duration
							gantt.config.date_scale = "%Y";
							gantt.config.fit_tasks = true;
							gantt.config.start_date = new Date(2018, 01, 01);
							gantt.config.end_date = new Date(2021, 12, 31);
							
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
							
							gantt.attachEvent("onTaskClick", function(id, e) {
								return false;
							});
							
							
							<!--//event listener to update Strategic Plan panel
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
							<!-\-gantt.attachEvent("onTaskDblClick", function(id, e) {
							    return false;
							});-\->
							<!-\-//event listener for when a plan is dragged
							gantt.attachEvent("onAfterTaskDrag", function(id, mode, e){
							    console.log("You've just finished dragging an item with id="+id);
							});-\->
							//
							
							gantt.attachEvent("onLinkDblClick", function(id,e){
							    return true;
							});
							
							//event listener when a strategic plan is updated
							gantt.attachEvent("onAfterTaskUpdate", function(id,item){
								updateGanntStrategicPlan(item);
								<!-\-var taskEndDate = gantt.calculateEndDate(item);
							    console.log("You've just finished updating an item with end date = "+ taskEndDate);-\->
							});	
							
							//event listener when a link is created between strategic plans
							gantt.attachEvent("onAfterLinkAdd", function(id,item){
							    //record the link
							    roadmapPlans.links.push(item);
							    console.log('Linked plan count after add: ' + roadmapPlans.links.length);
							    <!-\-var linkedPlans = getObjectsByIds(dynamicUserData.strategicPlans, "id", [item.source, item.target]);
							    if(linkedPlans.length == 2) {
							    	console.log('Linked ' + linkedPlans[1].name + ' depends on ' + linkedPlans[0].name);
							    } else {
							    	console.log('Linked plans not found');
							    }-\->
							});
							
							//event listener when a link between strategic plans is deleted
							gantt.attachEvent("onAfterLinkDelete", function(id,item){
							    var linkIndex = roadmapPlans.links.indexOf(item);
							    if (linkIndex > -1) {
							    	roadmapPlans.links.splice(linkIndex, 1);
							    }
							    console.log('Linked plan count after delete: ' + roadmapPlans.links.length);
							});-->
							
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
					
					/*****************************
					PAGE INITIALISATION FUNCTIONS
					******************************/
					
					function applyImpactFootprint() {
						viewData.impacts.forEach(function(anImpId) {
							$('div[id="' + anImpId + '_blob"]').addClass('neutralHeatmapColour');
						});
						
						viewData.impacts.forEach(function(anImpId) {
							$('div[id="' + anImpId + '"]').addClass('neutralHeatmapColour');
						});
					}
					
					$(document).ready(function(){
						//drawImplicationTable();
					
						$('.match1').matchHeight();
						
						<!-- Initialise strategic goals handlebars template -->
						
						//goals and objectives
						var goalFragment   = $("#strategic-goal-template").html();
						goalTemplate = Handlebars.compile(goalFragment);
						$("#goalsContainer").html(goalTemplate(viewData));
						
						//products
						var productFragment   = $("#product-template").html();
						productTemplate = Handlebars.compile(productFragment);
						$("#productsContainer").html(productTemplate(viewData));
						
						
						//eco-system stakeholders
						var stakeholderFragment   = $("#stakeholder-template").html();
						stakeholderTemplate = Handlebars.compile(stakeholderFragment);
						$("#stakeholdersContainer").html(stakeholderTemplate(viewData));
										
										
						//value streams templates				
						var valueStreamsListFragment   = $("#value-streams-list-template").html();
						var valueStreamsListTemplate = Handlebars.compile(valueStreamsListFragment);
						
						$('#valueStreamsList').select2({
						    placeholder: "Select Value Stream"
						});
						
						$("#valueStreamsList").html(valueStreamsListTemplate(viewData));
															
						$('#valueStreamsList').on('change', function (evt) {
						  var thisValueStreamId = $(this).select2("val");
						  if(thisValueStreamId != null) {
						  	setCurrentValueStream(thisValueStreamId);
						  }  
						});
								
						<!-- Initialise value stages handlebars templates -->
						var valueStagesFragment   = $("#value-stage-template").html();
						valueStagesTemplate = Handlebars.compile(valueStagesFragment);
						
						//initialise the BCM model
						var bcmFragment   = $("#bcm-template").html();
						var bcmTemplate = Handlebars.compile(bcmFragment);
						$("#bcmContainer").html(bcmTemplate(viewData.bcmData));
						
						
						//initialise the ARM model
						var armFragment   = $("#arm-template").html();
						var armTemplate = Handlebars.compile(armFragment);
						$("#appRefModelContainer").html(armTemplate(viewData.armData));
						
						//initialise the TRM model
						var trmFragment   = $("#trm-template").html();
						var trmTemplate = Handlebars.compile(trmFragment);
						$("#techRefModelContainer").html(trmTemplate(viewData.trmData));
						$('.matchHeight2').matchHeight();
			 			$('.matchHeightTRM').matchHeight();
						
						<!-- Strategic Plan Details -->
						var ganttStratPlanFragment   = $("#gantt-strat-plan-details-template").html();
						ganttStratPlanTemplate = Handlebars.compile(ganttStratPlanFragment);
						
						//Render the geographic map
						$('#mapScope').vectorMap(
							{
								map: '<xsl:value-of select="$geoMapId"/>',
                                zoomOnScroll: false,
								backgroundColor: 'transparent',
								hoverOpacity: 0.7,
								hoverColor: false,
								regionsSelectable: true,
								regionsSelectableOne: true,
								regionStyle: {
								    initial: {
									    fill: '#ccc',
									    "fill-opacity": 1,
									    stroke: 'none',
									    "stroke-width": 0,
									    "stroke-opacity": 1
								    },
								    selected: {
									    fill: 'blue'
									}
							    },
							    markerStyle: {
							    	initial: {
								        fill: 'yellow',
								        stroke: 'black',
							        }
							    },
							    onRegionClick: function(e, code) {
							    	console.log('Clicked on: ' + code);
							    	updateStatsForCountry(code);
							    },
							    <!--markers: [{latLng: [41.90, 12.45], name: 'My App'}],-->
							    series: {
							    regions: [{
							    	values: {},
							    	attribute: 'fill'
							    }]
							  }
							}
						);
						
						
						$('a[href="#stratImpactTab"]').on('shown.bs.tab', function (e) {
						  	initRoadmapGantt();
						});
						
						$('a[href="#finImpactTab"]').on('shown.bs.tab', function (e) {
						  	initFinancialCharts();
						});
						
						$('a[href="#kpiImpactTab"]').on('shown.bs.tab', function (e) {
						  	initKPIChart();
						});
						
						$('.busEnvPills a').on('shown.bs.tab', function (e) {
						  	var contentId = $(this).attr('href') + 'content';
						  	console.log('Clicked on pill: ' + contentId);
						  	renderBusEnvFactorChart(contentId);
						});
						
						
						$('.appRefModel-blob').addClass('v3-busRefModel-blob-noheatmap');
						
						applyImpactFootprint()
						
					});
				</script>
				
				<xsl:call-template name="HandlebarsTemplates"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- Content for the Business Environment Impact tab -->
	<xsl:template name="BusinessEnvironmentImpactContent">
		<div class="row">
			<!-- Geographic Map -->
			<div class="col-xs-6">
				<h3 class="section-title"><xsl:value-of select="eas:i18n('Geographic Scope')"/></h3>
				<div class="dashboardPanel bg-offwhite match-be">
					<div class="map" id="mapScope"/>					
				</div>
				<div class="clearfix"></div>
			</div>
			
				
			<!-- Business Environment Factors  -->
			<div class="col-xs-6">
				<h3 class="section-title"><xsl:value-of select="eas:i18n('Business Environment Factors')"/></h3>
				<div class="dashboardPanel bg-offwhite match-be">
					
					<ul class="busEnvPills nav nav-tabs nav-justified" role="tablist">
						<li role="presentation" class="active">
							<a  data-toggle="tab" href="#busenv1" role="tab"><i class="fa fa-building right-5" aria-hidden="true"></i>Political</a>
						</li>
						<li role="presentation">
							<a class="" data-toggle="tab" href="#busenv2" role="tab"><i class="fa fa-money right-5" aria-hidden="true"></i>Economic</a>
						</li>
						<li role="presentation" class="">
							<a class="" data-toggle="tab" href="#busenv3" role="tab"><i class="fa fa-users right-5" aria-hidden="true"></i>Social</a>
						</li>
						<li role="presentation" class="">
							<a class="" data-toggle="tab" href="#busenv4" role="tab"><i class="fa fa-cogs right-5" aria-hidden="true"></i>Technological</a>
						</li>
						<li role="presentation" class="">
							<a class="" data-toggle="tab" href="#busenv5" role="tab"><i class="fa fa-balance-scale right-5" aria-hidden="true"/>Legal</a>
						</li>
						<li role="presentation" class="">
							<a class="" data-toggle="tab" href="#busenv5" role="tab"><i class="fa fa-globe right-5" aria-hidden="true"></i>Environmental</a>
						</li>
					</ul>
					
					<div class="tab-content bg-white">
						<div role="tabpanel" class="tab-pane fade in active" id="busenv1">
							<div class="bus-env-chart simple-scroller">
								<canvas id="busenv1content"/>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="busenv2">
							<div class="bus-env-chart simple-scroller">
								<canvas id="busenv2content"/>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="busenv3">
							<div class="bus-env-chart simple-scroller">
								<canvas id="busenv3content"/>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="busenv4">
							<div class="bus-env-chart simple-scroller">
								<canvas id="busenv4content"/>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="busenv5">
							<div class="bus-env-chart simple-scroller">
								<canvas id="busenv5content"/>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="busenv6">
							<div class="bus-env-chart simple-scroller">
								<canvas id="busenv6content"/>
							</div>
						</div>
					</div>
						
								
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
	</xsl:template>
	
	<!-- Content for the Strategy Impact tab -->
	<xsl:template name="StrategyImpactContent">
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Goals and Objectives')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<!-- STRATEGIC GOALS CONTAINER -->
			<div id="goalsContainer"/>					
		</div>
		<div class="clearfix"></div>
		
		<div class="row">
			<div class="col-xs-12">
				<h3 class="section-title"><xsl:value-of select="eas:i18n('Plans')"/></h3>
			</div>
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
	</xsl:template>
	
	<!-- Content for the Financial Impact tab -->
	<xsl:template name="FinancialImpactContent">
		<!-- Costs -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Costs')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<canvas id="costContainer" width="100%"/>				
		</div>
		<div class="clearfix"></div>
		
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Revenues')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<canvas id="revsContainer" width="100%"/>				
		</div>
		<div class="clearfix"></div>
	</xsl:template>
	
	<!-- Content for the Financial Impact tab -->
	<xsl:template name="KPIImpactContent">
		<!-- KPIs -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Business Outcomes')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<canvas id="kpiContainer" width="100%"/>				
		</div>
		<div class="clearfix"></div>
		
	</xsl:template>
	
	<!-- Content for the Business Impact tab -->
	<xsl:template name="BusinessImpactContent">
		<!-- Eco-System Stakeholders -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Eco System Stakeholders')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<div id="stakeholdersContainer"/>					
		</div>
		<div class="clearfix"></div>
		
		<!-- Product Concepts -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Products')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<div id="productsContainer"/>					
		</div>
		<div class="clearfix"></div>
		
		<!-- Value Streams -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Value Streams')"/></h3>
		<div class="dashboardPanel bg-offwhite">
			<div class="row">
				<div class="col-xs-12">
					<p class="small pull-left">
						<em>Select a Value Stream to view impact</em>
					</p>
					<div class="pull-right">
						<span class="right-10"><strong>Heatmap:</strong></span>
						<label class="radio-inline">
							<input type="radio" name="vsHeatmapRadioOptions" id="vsHeatmapRadioCx" value="cx" checked="checked"/> Customer Experience
						</label>
						<label class="radio-inline">
							<input type="radio" name="vsHeatmapRadioOptions" id="vsHeatmapRadioKpi" value="kpi"/> Customer Service
						</label>
					</div>
				</div>
			</div>
			
			<select id="valueStreamsList" style="width:100%;"/>
			<div class="clearfix"/>
			<div id="valueStagesContainer" class="top-15"/>					
		</div>
		<div class="clearfix"></div>
		
		<!-- Business Capabilities -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Business Footprint')"/></h3>
		<div class="dashboardPanel bg-offwhite equalHeight1">
			<div class="simple-scroller" id="bcmContainer"/>					
		</div>
	</xsl:template>
	
	<!-- Content for the IT Architecture Impact tab -->
	<xsl:template name="ITImpactContent">
		
		<!-- Application Capabilities -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Application Footprint')"/></h3>
		<div class="dashboardPanel bg-offwhite equalHeight1">
			<div class="simple-scroller" id="appRefModelContainer"></div>					
		</div>
		
		<!-- Technology Capabilities -->
		<h3 class="section-title"><xsl:value-of select="eas:i18n('Technology Footprint')"/></h3>
		<div class="dashboardPanel bg-offwhite equalHeight1">
			<div class="simple-scroller" id="techRefModelContainer"></div>					
		</div>
		
	</xsl:template>
	
	
	<xsl:template name="HandlebarsTemplates">
		<!-- Handlebars template to render a strategic goal -->
		<script id="strategic-goal-template" type="text/x-handlebars-template">
			{{#goals}}
				<div class="goal_Outer">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<!--Use colours bg-lightgrey bg-brightred-100 bg-darkgreen-100 to heatmap here-->
					<div class="goal_Box bg-lightgrey">
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
					<div class="threeColModel_valueChainObject small bg-orange-100">
						<span class="text-primary">{{{link}}}</span>
					</div>
				</div>
			{{/valueStages}}
		</script>
		
		
		<!-- Handlebars template to render a product concept -->
		<script id="product-template" type="text/x-handlebars-template">
			{{#products}}
				<div class="blob_Outer">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<div class="blob_Box bg-lightgrey">
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_inner</xsl:text></xsl:attribute>
						<div class="blob_Label">
							<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_label</xsl:text></xsl:attribute>
							{{{link}}}
						</div>
						<i class="fa fa-info-circle infoButton"/>
						<div class="hiddenDiv">
							<p>{{description}}</p>
						</div>
					</div>
				</div>
			{{/products}}
		</script>
		
		
		<!-- Handlebars template to render a eco-system stakeholder -->
		<script id="stakeholder-template" type="text/x-handlebars-template">
			{{#stakeholders}}
				<div class="blob_Outer">
					<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					<div class="blob_Box bg-lightgrey">
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_inner</xsl:text></xsl:attribute>
						<div class="blob_Label">
							<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_label</xsl:text></xsl:attribute>
							{{{link}}}
						</div>
						<i class="fa fa-info-circle infoButton"/>
						<div class="hiddenDiv">
							<p>{{description}}</p>
						</div>
					</div>
				</div>
			{{/stakeholders}}
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
						<div class="v3-refModel-l0-outer">
							<div class="v3-refModel-l0-title fontBlack large">
								{{{busCapLink}}}
							</div>
							{{#l2BusCaps}}
								<div class="v3-busRefModel-blobWrapper">
									<div class="v3-busRefModel-blob v3-busRefModel-blob-noheatmap">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}</xsl:text></xsl:attribute>
										<div class="v3-refModel-blob-title">
											{{{busCapLink}}}
										</div>
										<div class="v3-refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_info</xsl:text></xsl:attribute>									
										</div>
									</div>
									<div class="v3-busRefModel-blobAnnotationWrapper">
										<div class="v3-blobAnnotationL">{{#if isDifferentiator}}<i class="fa fa-flag"></i>{{/if}}</div>
										<div>
											<xsl:attribute name="class">v3-blobAnnotationC {{stratImpactStyle}}</xsl:attribute>
											{{stratImpactLabel}}
										</div>
										<div class="v3-blobAnnotationR">
											<i class="fa fa-info-circle text-midgrey bus-cap-info" data-toggle="modal" data-target="#busCapModal">
												<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{busCapId}}</xsl:text></xsl:attribute>
											</i>
										</div>
									</div>
								</div>
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
		
		<xsl:call-template name="appRefModelInclude"/>
		<xsl:call-template name="techRefModelInclude"/>
		
	</xsl:template>
	
	
	
	<!-- Template to return all read only data for the view -->
	<xsl:template name="getReadOnlyJSON">
		{
			'impacts': [
			<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisStratImplEAImpacts"/>
			],
			'goals': [
			<xsl:apply-templates mode="getBusinssGoalsJSON" select="$allBusinessGoals"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			'objectives': [
			<xsl:apply-templates mode="getBusinssObjectivesJSON" select="$allBusinessObjectives"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			'valueStreams': [
			<xsl:apply-templates mode="getValueStreamJSON" select="$allValueStreams"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			'valueStages': [
			<xsl:apply-templates mode="getValueStageJSON" select="$allValueStages"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			'products': [
				<xsl:apply-templates mode="RenderProducts" select="$allProductConcepts"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			'stakeholders': [
				<xsl:apply-templates mode="RenderStakeholderRoles" select="$allStakeholderRoles"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			'bcmData': <xsl:call-template name="RenderBCMJSON"/>,
			'armData': {
				'left': [
				<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderAppCaps"/>
				],
				'middle': [
				<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderAppCaps"/>
				],
				'right': [
				<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderAppCaps"/>
				]
			},
			'trmData': {
				'top': [
				<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name]" mode="RenderTechDomains"/>
				],
				'left': [
				<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderTechDomains"/>
				],
				'middle': [
				<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderTechDomains"/>
				],
				'right': [
				<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderTechDomains"/>
				],
				'bottom': [
				<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name]" mode="RenderTechDomains"/>
				]
			}
		}
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
		l0BusCapId: "<xsl:value-of select="eas:getSafeJSString($rootBusCap/name)"/>",
		l0BusCapName: "<xsl:value-of select="$rootBusCapName"/>",
		l0BusCapLink: "<xsl:value-of select="$rootBusCapLink"/>",
		l1BusCaps: [
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
		<xsl:variable name="L1Caps" select="$allBusCapabilities[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		
		{
		busCapId: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		busCapName: "<xsl:value-of select="$currentBusCapName"/>",
		busCapLink: "<xsl:value-of select="$currentBusCapLink"/>",
		l2BusCaps: [	
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
		busCapId: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		busCapName: "<xsl:value-of select="$currentBusCapName"/>",
		busCapLink: "<xsl:value-of select="$currentBusCapLink"/>",
		isDifferentiator: <xsl:value-of select="$isDifferentiator"/>,
		stratImpactStyle: "<xsl:value-of select="$stratImpactStyle"/>",
		stratImpactLabel: "<xsl:value-of select="$stratImpactLabel"/>"
		<!--<xsl:choose>
				<xsl:when test="current()/name = $$L1Caps/name">inScope: true</xsl:when>
				<xsl:otherwise>inScope: false</xsl:otherwise>
			</xsl:choose>-->
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-- Template for rendering the list of Business Goals  -->
	<xsl:template match="node()" mode="getBusinssGoalsJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'objective_supports_objective']/value = $this/name]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="anchorClass">text-white</xsl:with-param><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		objectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
		objectives: [],
		inScope: false,
		isSelected: false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Business Objectives  -->
	<xsl:template match="node()" mode="getBusinssObjectivesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisSupportedBusinessGoals" select="$allBusinessGoals[name = $this/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		targetDate: "<xsl:value-of select="$this/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>",
		goalIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisSupportedBusinessGoals"/>],
		inScope: true
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderStakeholderRoles">
		<xsl:variable name="theName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="theDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="theLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="eas:validJSONString($theName)"/>",
			description: "<xsl:value-of select="eas:validJSONString($theDescription)"/>",
			link: "<xsl:value-of select="$theLink"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderProducts">
		<xsl:variable name="theName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="theDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="theLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="eas:validJSONString($theName)"/>",
			description: "<xsl:value-of select="eas:validJSONString($theDescription)"/>",
			link: "<xsl:value-of select="$theLink"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<!-- Template for rendering the list of Business Capabilities  -->
	<xsl:template match="node()" mode="getBusinssCapablitiesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-- goals and objectives -->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			ref: "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			type: elementTypes.busCap,
			goalIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessGoals"/>],
			objectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			inScope: false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-- Template for rendering the list of Value Streams  -->
	<xsl:template match="node()" mode="getValueStreamJSON">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Value Stages -->
		<xsl:variable name="thisValueStages" select="$allValueStages[name = $this/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		valueStages: [<xsl:apply-templates mode="getValueStageJSON" select="$thisValueStages"><xsl:sort select="own_slot_value[slot_reference = 'vsg_index']/value"/></xsl:apply-templates>]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- Template for rendering the list of Value Stages  -->
	<xsl:template match="node()" mode="getValueStageJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="vsgLabel"><xsl:call-template name="RenderMultiLangCommentarySlot"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="slotName">vsg_label</xsl:with-param></xsl:call-template></xsl:variable>
		
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="displayString" select="$vsgLabel"/><xsl:with-param name="anchorClass">text-white</xsl:with-param></xsl:call-template>",
		inScope: false
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	
	<!-- APPLICATION REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderAppCaps" match="node()">
		<xsl:variable name="appCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>
		
		{	
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="eas:validJSONString($appCapName)"/>",
			description: "<xsl:value-of select="eas:validJSONString($appCapDescription)"/>",
			link: "<xsl:value-of select="$appCapLink"/>",
			childAppCaps: [
				<xsl:apply-templates select="$childAppCaps" mode="RenderChildAppCaps"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildAppCaps">
		<xsl:variable name="appCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="eas:validJSONString($appCapName)"/>",
			description: "<xsl:value-of select="eas:validJSONString($appCapDescription)"/>",
			link: "<xsl:value-of select="$appCapLink"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	
	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="techDomainName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="eas:validJSONString($techDomainName)"/>",
		description: "<xsl:value-of select="eas:validJSONString($techDomainDescription)"/>",
		link: "<xsl:value-of select="$techDomainLink"/>",
		childTechCaps: [
		<xsl:apply-templates select="$childTechCaps" mode="RenderChildTechCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildTechCaps">
		<xsl:variable name="techCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="eas:validJSONString($techCapName)"/>",
			description: "<xsl:value-of select="eas:validJSONString($techCapDescription)"/>",
			link: "<xsl:value-of select="$techCapLink"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>

</xsl:stylesheet>
