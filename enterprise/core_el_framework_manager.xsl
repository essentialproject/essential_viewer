<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
<xsl:import href="../common/core_strategic_plans.xsl"/>
<xsl:import href="../common/core_utilities.xsl"/>
<xsl:include href="../common/core_doctype.xsl"/>
<xsl:include href="../common/core_common_head_content.xsl"/>
<xsl:include href="../common/core_header.xsl"/>
<xsl:include href="../common/core_footer.xsl"/>
<xsl:include href="../common/core_external_doc_ref.xsl"/>
<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Enterprise_Strategic_Plan','Application_Provider', 'Business_Process', 'Technology_Product', 'Information_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Org Summmary']"/>
	<xsl:variable name="physProcAppsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"/>
	<xsl:variable name="techProdData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Products']"/>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="infoData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="controlFramework" select="/node()/simple_instance[type='Control_Framework']"/>
	<xsl:variable name="controls" select="/node()/simple_instance[type='Control'][name=$controlFramework/own_slot_value[slot_reference = 'cf_controls']/value]"/>
	<xsl:variable name="cte" select="/node()/simple_instance[type='CONTROL_TO_ELEMENT_RELATION'] "/>
	<xsl:variable name="controlToElement" select="/node()/simple_instance[type='CONTROL_TO_ELEMENT_RELATION'][own_slot_value[slot_reference = 'control_to_element_control']/value=$controls/name]"/>
	<xsl:variable name="processControls" select="/node()/simple_instance[type='Business_Process'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
	<xsl:variable name="applicationControls" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
	<xsl:variable name="technologyControls" select="/node()/simple_instance[supertype='Technology_Provider'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
	<xsl:variable name="informationControls" select="/node()/simple_instance[type='Information_Representation'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
	<xsl:variable name="actors" select="/node()/simple_instance[type='Individual_Actor']"/>	
	<xsl:variable name="business_role" select="/node()/simple_instance[type='Individual_Business_Role']"/>	
	<xsl:variable name="actor2role" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']"/>		
	<xsl:variable name="assessment" select="/node()/simple_instance[type='Control_Assessment'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_assessments']/value]"/>
	<xsl:variable name="assessmentFinding" select="/node()/simple_instance[type='Control_Assessment_Finding']"/>
	<xsl:variable name="processFramework" select="/node()/simple_instance[type='Business_Process'][name=$controls/own_slot_value[slot_reference = 'control_supported_by_business']/value]"/>
	<xsl:variable name="commentaryas" select="/node()/simple_instance[type='Commentary'][name=$assessment/own_slot_value[slot_reference = 'assessment_comments']/value]"/>		
	<xsl:variable name="csassessment" select="/node()/simple_instance[type='Control_Solution_Assessment']"/>
	<xsl:variable name="plans" select="/node()/simple_instance[supertype='Strategic_Plan'][name=$assessment/own_slot_value[slot_reference = 'ca_remediation_plans']/value]"/>

	<xsl:variable name="commentarycs" select="/node()/simple_instance[type='Commentary'][name=$csassessment/own_slot_value[slot_reference = 'commentary']/value]"/>
	<xsl:variable name="commentary" select="$commentaryas union $commentarycs"/>
	<xsl:variable name="csa" select="/node()/simple_instance[type='Control_Solution']"/>
	<xsl:key name="assessment_key" match="$assessment" use="own_slot_value[slot_reference = 'control_assessed_element']/value"/>
	<xsl:key name="control_key" match="/node()/simple_instance[type='Control_Solution']" use="own_slot_value[slot_reference = 'control_solution_for_controls']/value"/>
	<xsl:key name="control_assessment_key" match="/node()/simple_instance[type='Control_Solution_Assessment']" use="own_slot_value[slot_reference = 'assessed_control_solution']/value"/>

	<xsl:variable name="solutionBusinessElement" select="/node()/simple_instance[supertype=('Business_Logical', 'Business_Physical')][name=$csa/own_slot_value[slot_reference = 'control_solution_business_elements']/value]"/>
	<xsl:variable name="solutionApplicationElement" select="/node()/simple_instance[supertype=('Application_Logical', 'Application_Physical')][name=$csa/own_slot_value[slot_reference = 'control_solution_application_elements']/value]"/>
	<xsl:variable name="solutionTechnologyElement" select="/node()/simple_instance[supertype=('Technology_Logical', 'Technology_Physical')][name=$csa/own_slot_value[slot_reference = 'control_solution_technology_elements']/value]"/>
	<xsl:variable name="solutionInformationElement" select="/node()/simple_instance[supertype=('Information_Logical', 'Information_Physical')][name=$csa/own_slot_value[slot_reference = 'control_solution_information_elements']/value]"/>
	
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
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiPath">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$anAPIReport"/>
				</xsl:call-template>
			</xsl:variable>
		<xsl:variable name="appPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ppPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$physProcAppsData"/>
			</xsl:call-template>
		</xsl:variable>	
		<xsl:variable name="infoPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$infoData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$techProdData"/>
			</xsl:call-template>
		</xsl:variable>		
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Summary')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>

				<style type="text/css">
				.counts{
					border:1pt solid #d3d3d3;
					margin:3px;
					border-radius:5px;
					width:19%;
					display:inline-block;
					text-align: center;
					font-size:1.5em
				}
				.thead input {
					width: 100%;
					}
					.ess-blob{
						margin: 0 15px 15px 0;
						border: 1px solid #ccc;
						height: 40px;
						width: 140px;
						border-radius: 4px;
						display: table;
						position: relative;
						text-align: center;
						float: left;
					}

					.orgName{
						font-size:2.4em;
						padding-top:30px;
						text-align:center;
					}

					.ess-blobLabel{
						display: table-cell;
						vertical-align: middle;
						line-height: 1.1em;
						font-size: 90%;
					}
					
					.infoButton > a{
						position: absolute;
						bottom: 0px;
						right: 3px;
						color: #aaa;
						font-size: 90%;
					}
					
					#summary-content label{
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
					}
					
					.dataTables_filter label {
						display: inline-block!important;
					}
					
					#summary-content h3{
						font-weight: 600;
					}
					
					.ess-tag{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						font-size: 90%;
					}
					
					.map{
						width: 100%;
						height: 400px;
						min-width: 450px;
						min-height: 400px;
					}
					
					.dashboardPanel{
						padding: 10px 15px;
						border: 1px solid #ddd;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						width: 100%;
					}
					
					.parent-superflex{
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					
					.superflex{
						border: 1px solid #ddd;
						padding: 10px;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						flex-grow: 1;
						flex-basis: 1;
					}
					
					.ess-list-tags{
						padding: 0;
					}
					
					.ess-string{
						background-color: #f6f6f6;
						padding: 5px;
						display: inline-block;
					}
					
					.ess-doc-link{
						padding: 3px 8px;
						border: 1px solid #6dadda;
						border-radius: 4px;
						margin-right: 10px;
						margin-bottom: 10px;
						display: inline-block;
						font-weight: 700;
						background-color: #fff;
						font-size: 85%;
					}
					
					.ess-doc-link:hover{
						opacity: 0.65;
					}
					
					.ess-list-tags li{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						background-color: #eee;
						font-size: 85%;
					}
					
					@media (min-width : 1220px) and (max-width : 1720px){
						.ess-column-split > div{
							width: 450px;
							float: left;
						}
					}
					
					
					.bdr-left-blue{
						border-left: 2pt solid #5b7dff !important;
					}
					
					.bdr-left-indigo{
						border-left: 2pt solid #6610f2 !important;
					}
					
					.bdr-left-purple{
						border-left: 2pt solid #6f42c1 !important;
					}
					
					.bdr-left-pink{
						border-left: 2pt solid #a180da !important;
					}
					
					.bdr-left-red{
						border-left: 2pt solid #f44455 !important;
					}
					
					.bdr-left-orange{
						border-left: 2pt solid #fd7e14 !important;
					}
					
					.bdr-left-yellow{
						border-left: 2pt solid #fcc100 !important;
					}
					
					.bdr-left-green{
						border-left: 2pt solid #5fc27e !important;
					}
					
					.bdr-left-teal{
						border-left: 2pt solid #20c997 !important;
					}
					
					.bdr-left-cyan{
						border-left: 2pt solid #47bac1 !important;
					}
					
					@media print {
						#summary-content .tab-content > .tab-pane {
						    display: block !important;
						    visibility: visible !important;
						}
						
						#summary-content .no-print {
						    display: none !important;
						    visibility: hidden !important;
						}
						
						#summary-content .tab-pane {
							page-break-after: always;
						}
					}
					
					@media screen {						
						#summary-content .print-only {
						    display: none !important;
						    visibility: hidden !important;
						}
					}
					.stat{
						border:1pt solid #d3d3d3;
						border-radius:4px;
						margin:5px;
						padding:3px;
					}
					.lbl-large{    
						font-size: 200%;
						border-radius: 5px;
						/* margin-right: 10%; */
						/* margin-left: 10%; */
						text-align: center;
						display: inline-block;
						padding: 0 30px;
						box-shadow: 2px 2px 2px #d3d3d3;
						font-weight: 900;
					}
					.lbl-big{
						font-size: 150%;
					}
					.roleBlob{
						background-color: rgb(68, 182, 179)
					}
					.planBlob{
						background-color: rgb(205, 196, 132)
					}
					
					.countBox-wrapper {
						display: flex;
						flex-wrap: wrap;
					}
					.countBox{
						min-height:70px;
						width:100px;
						margin:3px;
						text-align: center;
						vertical-align: middle;
						display:block;
						border:1pt solid #d3d3d3;
						border-radius:4px;
						}
					.bar-wrapper {
						display: flex;
						flex-wrap: wrap;
						justify-content: center;
					}
					.bar {
						/* height: 15px; */
						/* max-width: 100px; */
						font-size: 12px;
						border-radius: 4px;
						margin: 2px;
						background-color: #fff;
						border: 1px solid #000;
						padding: 2px;
						}
						.solutionTag,.eleTag {cursor: pointer;}
						.control-name-trigger {
						cursor: help;
						}
						
						.fw+span{
							top: -5px;
						}
					.assessTable{
						padding:3px;
					}	
					.titleTd{
						background-color: #d3d3d3;
						color: #000;
						padding:3px; 
						vertical-align: top;
						}
					.titleTdOdd{
						background-color: #f0f0f0;
						color: #000;
						padding:3px; 
						vertical-align: top;
						}
					.infoTd	{
						padding:3px; 
						}
					
					.eas-logo-spinner {​​​​​​​​
						display: flex;
						justify-content: center;
					}​​​​​​​​
					#editor-spinner {​​​​​​​​
						height: 100vh;
						width: 100vw;
						position: fixed;
						top: 0;
						left:0;
						z-index:999999;
						background-color: hsla(255,100%,100%,0.75);
						text-align: center;
					}​​​​​​​​
					#editor-spinner-text {​​​​​​​​
						width: 100vw;
						z-index:999999;
						text-align: center;
					}​​​​​​​​
					.spin-text {​​​​​​​​
						font-weight: 700;
						animation-duration: 1.5s;
						animation-iteration-count: infinite;
						animation-name: logo-spinner-text;
						color: #aaa;
						float: left;
					}​​​​​​​​
					.spin-text2 {​​​​​​​​
						font-weight: 700;
						animation-duration: 1.5s;
						animation-iteration-count: infinite;
						animation-name: logo-spinner-text2;
						color: #666;
						float: left;
					}​​​​​​​​
					
				</style>
				<script src='https://d3js.org/d3.v5.min.js'></script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>

				<!--ADD THE CONTENT-->
			<div id="editor-spinner" class="hidden">
				<div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;">
					<div class="spin-icon" style="width: 60px; height: 60px;">
						<div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
						<div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
						<div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
					</div>                      
				</div>
				<div id="editor-spinner-text" class="text-center xlarge strong spin-text2"/>
			</div>
			<span id="mainPanel"/>
			<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="assessModal" aria-hidden="true" id="assessModal">
				<div class="modal-dialog modal-lg">
					<div class="modal-content" id="assessModalContent">
						
					</div>
				</div>
			</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
				<script>
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
					<xsl:with-param name="viewerAPIPathApp" select="$appPath"/>
					<xsl:with-param name="viewerAPIPathPP" select="$ppPath"/>
					<xsl:with-param name="viewerAPIPathTech" select="$techPath"/> 
					<xsl:with-param name="viewerAPIPathInfo" select="$infoPath"/>
					
				</xsl:call-template>
				</script>
		
			</body>
			<script>
                    $(document).ready(function(){
                        var windowHeight = $(window).height();
						var windowWidth = $(window).width();
                        $('.simple-scroller').scrollLeft(windowWidth/2);
                    });
                </script>
	<script id="panel-template" type="text/x-handlebars-template">
		<div class="container-fluid" id="summary-content">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1 style="display:inline-block" class="right-15">
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
							<span class="text-darkgrey"></span><xsl:text> </xsl:text>
							<span class="text-primary">{{this.name}}</span>
						</h1>
						<select class="fw select2" id="fw" style="width: 180px;">
							<option><xsl:value-of select="eas:i18n('Select Framework')"/></option>
							<xsl:apply-templates select="$controlFramework" mode="options">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/>
							</xsl:apply-templates>
						</select>
				</div>
				</div>
			</div> 

			<!--Setup Vertical Tabs-->
			<div class="row">
				<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
					<!-- required for floating -->
					<!-- Nav tabs -->
					<ul class="nav nav-tabs tabs-left">
						<li class="active">
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Framework Summary')"/></a>
						</li>
						<li>
							<a href="#controls" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('Controls')"/></a>
						</li>{{#ifGreaterThan busTotal 0}}
						<li>
							<a href="#business" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Business')"/></a>
						</li>{{/ifGreaterThan}}
						{{#ifGreaterThan appsTotal 0}}
						<li>
							<a href="#applications" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Applications')"/></a>
						</li>{{/ifGreaterThan}}
						{{#ifGreaterThan techTotal 0}}
						<li>
							<a href="#technology" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Technology')"/></a>
						</li>{{/ifGreaterThan}}
						{{#ifGreaterThan infoTotal 0}}
						<li>
							<a href="#information" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Information')"/></a>
						</li>{{/ifGreaterThan}}
						{{#ifGreaterThan suppTotal 0}}
						<li>
							<a href="#support" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Support')"/></a>
						</li>{{/ifGreaterThan}}
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Framework Summary')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Framework Summary')"/></h3>
									<label><xsl:value-of select="eas:i18n('Framework Name')"/></label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<div class="ess-string">{{this.description}}</div>
									<div class="clearfix bottom-10"></div>
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-bar-chart right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
									<label><xsl:value-of select="eas:i18n('Total Controls')"/> </label>
									<div class="top-15 bottom-15">
										<div class="keyCount lbl-large bg-orange-100 fontBlack">{{this.controls.length}}</div>
									</div>
									
								</div>
								
								<div class="col-xs-12"/>
								<div class="superflex">
									<div class="counts bg-lightblue-100"><xsl:value-of select="eas:i18n('Business')"/><br/>
										<div class="fontBlack">{{busTotal}}</div> 
									</div>
									<div class="counts bg-lightblue-80"><xsl:value-of select="eas:i18n('Application')"/><br/>
										<div class="fontBlack">{{appsTotal}}</div>
									</div>
									<div class="counts bg-lightblue-60"><xsl:value-of select="eas:i18n('Technology')"/><br/>
										<div class="fontBlack">{{techTotal}}</div>
									</div>
									<div class="counts bg-lightblue-40"><xsl:value-of select="eas:i18n('Information')"/><br/>
										<div class="fontBlack">{{infoTotal}}</div>
									</div>
							<!--	 
									<div class="counts bg-lightblue-20">Support<br/>
										{{suppTotal}} 
									</div> -->
								<!--	<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Roles &amp; People')"/></h3>
								-->
								</div>
							</div>
							<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Coverage')"/></h3>
									<div class="countBox-wrapper">
									{{#each this.controls}}
										<div class="countBox"><xsl:attribute name="style">{{#getColour this}}{{/getColour}}</xsl:attribute>
											<div class="control-name-trigger"><strong>{{this.name}}</strong></div>
											<div class="popover">{{this.description}}</div>
											<div class="bar-wrapper">
												{{#if this.busImpacting}}
												<div class="bar">B:{{this.busImpacting.length}}</div>	
												{{/if}}
												{{#if this.appsImpacting}}
												<div class="bar">A:{{this.appsImpacting.length}}</div>
												{{/if}}
												{{#if this.techImpacting}}
												<div class="bar">T:{{this.techImpacting.length}}</div>
												{{/if}}
												{{#if this.infoImpacting}}
												<div class="bar">I:{{this.infoImpacting.length}}</div>
												{{/if}}
											</div>
										</div>
									{{/each}}
									</div>
								
								</div>
							</div>
						 
						
						<div class="tab-pane" id="controls">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-globe right-10"></i><xsl:value-of select="eas:i18n('Controls')"/></h2>
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i><xsl:value-of select="eas:i18n('Controls')"/></h3>
									<div class="ess-blobWrapper">
										<label>Key</label>
										<ul class="ess-list-tags"> 
											<li class="roleBlob bg-lightblue-100" style="background-color: #648FFF"><xsl:value-of select="eas:i18n('Business')"/></li> 
											<li class="roleBlob bg-lightblue-80" style="background-color: #785EF0"><xsl:value-of select="eas:i18n('Application')"/></li>
											<li class="roleBlob bg-lightblue-60" style="background-color: #DC267F"><xsl:value-of select="eas:i18n('Technology')"/></li>
											<li class="roleBlob bg-lightblue-80" style="background-color: #FE6100"><xsl:value-of select="eas:i18n('Information')"/></li>
										<!--	<li class="roleBlob bg-lightblue-80" style="background-color: #FFB000"><xsl:value-of select="eas:i18n('Support')"/></li>-->
										</ul> 
									</div>
									<div class="bottom-10">
										<table id="dt_supportedcontrols" class="table table-striped table-bordered" >
											<thead>
												<tr>
													
													<th>
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Solutions')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Summary')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												{{#each this.controls}}
												<tr>
													
													<td>
														<ul class="ess-list-tags"> 
															<li class="roleBlob" style="background-color: rgb(132, 213, 237)">{{this.name}}</li> 
														</ul> 
														
													</td>
													<td>
														{{this.description}} 
													</td>
													<td>
														<ul class="ess-list-tags">
															{{#each this.solutions}}
															{{#if this.elements}}
															{{#each this.elements}}
															<li class="roleBlob solutionTag">
																<xsl:attribute name="easid">{{../this.id}}</xsl:attribute>
																<xsl:attribute name="easapp">{{../this.name}}</xsl:attribute>
																<xsl:attribute name="easctrl">{{../../this.name}}</xsl:attribute>
																{{this.name}}<i class="fa fa-info-circle left-5"/>
															</li> 
															{{/each}}
															{{/if}}
															{{/each}}	 
														</ul>
														
													</td>
													<td>
														<ul class="ess-list-tags"> 
															{{#if this.busImpacting}}<li class="roleBlob bg-lightblue-100" style="background-color: #648FFF">{{this.busImpacting.length}}</li> {{/if}}
															{{#if this.appsImpacting}}<li class="roleBlob bg-lightblue-80" style="background-color: #785EF0">{{this.appsImpacting.length}}</li>{{/if}}
															{{#if this.techImpacting}}<li class="roleBlob bg-lightblue-60" style="background-color: #DC267F">{{this.techImpacting.length}}</li>{{/if}}
															{{#if this.infoImpacting}}
															<li class="roleBlob bg-lightblue-80" style="background-color: #FE6100">{{this.infoImpacting.length}}</li>{{/if}}
														<!--	{{#if this.supportImpacting}}
															<li class="roleBlob bg-lightblue-80" style="background-color: #FFB000">{{this.supportImpacting.length}}</li>{{/if}}-->
														</ul> 
													</td>
													
												</tr>
												
												{{/each}}
												
											</tbody>
											<tfoot>
												<tr>
													
													<th>
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Solutions')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Summary')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="tab-pane" id="business">
								<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Usage')"/></h2>
								<div class="parent-superflex">
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Business Controls')"/></h3> 
										 
										<table class="table table-striped table-bordered" id="dt_bustable">
												<thead>
													<tr>
														<th width="150px">
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th width="800px">
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
														 
													</tr>
												</thead>
												<tbody>
														{{#each this.busProcs}}
														<tr>
															<td>{{this.name}}</td>
															<td>{{{this.busHTML}}}</td>
														</tr>

														{{/each}}
												</tbody>
												<tfoot>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
													</tr>
												</tfoot>
											</table>
										<div class="clearfix bottom-10"></div>
									</div>
							</div>
							</div>
						<div class="tab-pane" id="applications">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Usage')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Application Controls')"/></h3> 
									 
									<table class="table table-striped table-bordered" id="dt_apptable">
											<thead>
												<tr>
													<th width="150px">
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th width="800px">
														<xsl:value-of select="eas:i18n('Control')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
													{{#each this.apps}}
													<tr>
														<td>{{this.name}}</td>
														<td>{{{this.appHTML}}}</td>
													</tr>

													{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Control')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									<div class="clearfix bottom-10"></div>
								</div>
						</div>
						</div>
						<div class="tab-pane" id="technology">
								<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Usage')"/></h2>
								<div class="parent-superflex">
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Technology Controls')"/></h3> 
										 
										<table class="table table-striped table-bordered" id="dt_techtable">
												<thead>
													<tr>
														<th width="150px">
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th width="800px">
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
														 
													</tr>
												</thead>
												<tbody>
														{{#each this.techProds}}
														<tr>
															<td>{{this.name}}</td>
															<td>{{{this.techHTML}}}</td>
														</tr>

														{{/each}}
												</tbody>
												<tfoot>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
													</tr>
												</tfoot>
											</table>
										<div class="clearfix bottom-10"></div>
									</div>
							</div>
							</div>
						<div class="tab-pane" id="information">
								<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Usage')"/></h2>
								<div class="parent-superflex">
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Information Controls')"/></h3> 
											
										<table class="table table-striped table-bordered" id="dt_infotable">
												<thead>
													<tr>
														<th width="150px">
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th width="800px">
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
															
													</tr>
												</thead> 
												<tbody>
														{{#each this.info}}
														<tr>
															<td>{{this.name}}</td>
															<td>{{{this.infoHTML}}}</td>
														</tr>

														{{/each}}
												</tbody> 
												<tfoot>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
													</tr>
												</tfoot>
											</table>
										<div class="clearfix bottom-10"></div>
									</div>
							</div>
							</div>
						<div class="tab-pane" id="support">
								<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Usage')"/></h2>
								<div class="parent-superflex">
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Support Controls')"/></h3> 
											
										<table class="table table-striped table-bordered" id="dt_supptable">
												<thead>
													<tr>
														<th width="150px">
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th width="800px">
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
															
													</tr>
												</thead>
												<tbody>
							
												</tbody>
												<tfoot>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Name')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Control')"/>
														</th>
													</tr>
												</tfoot>
											</table>
										<div class="clearfix bottom-10"></div>
									</div>
							</div>
							</div>		
					
					</div>
				</div>
			</div>

			<!--Setup Closing Tag-->
		</div>

	</script>	

 
	<script id="apps-template" type="text/x-handlebars-template">
		<ul class="ess-list-tags">
			{{#each this.controls}} 
				<li class="roleBlob bg-lightblue-80 eleTag" ><xsl:attribute name="easid">{{this.assessment}}</xsl:attribute><xsl:attribute name="easapp">{{../this.name}}</xsl:attribute><xsl:attribute name="easctrl">{{this.name}}</xsl:attribute><xsl:attribute name="style">background-color:{{#getFindingColour this}}{{/getFindingColour}}</xsl:attribute>{{#ifEquals this.assessmentFinding 'Pass'}}<i class="fa fa-check-circle-o"></i>{{else}}<i class="fa fa-times-circle-o"></i>{{/ifEquals}} {{this.name}}</li>
			{{/each}}
		</ul>		
	</script>
	<script id="assess-template" type="text/x-handlebars-template">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"><i class="fa fa-times"/></button>
			<h3><b>Control</b>:{{this.ctrl}}</h3>
			<h3><b>Element</b>:{{this.app}}</h3>
		</div>
		<div class="modal-body">
			{{#each this.assessments}} 
			<table class="assessTable table table-striped">
				<tbody>
					<tr>
						<th><xsl:value-of select="eas:i18n('Assessment Date')"/></th>
						<td colspan="3" class="infoTd">
							<ul class="ess-list-tags">
								<li class="roleBlob bg-lightblue-80" style="background-color: hsla(200, 80%, 80%, 1);color:#000">{{this.assessmentDate}}</li>
							</ul>
						</td>
					</tr>
					<tr>
						<th><xsl:value-of select="eas:i18n('Assessor')"/></th>
						<td colspan="3" class="infoTd">{{this.assessor}}</td>
					</tr>
					<tr>
						<th><xsl:value-of select="eas:i18n('Finding')"/></th>
						<td colspan="3" class="infoTd">
							<ul class="ess-list-tags">
								<li class="roleBlob bg-lightblue-80" >
									<xsl:attribute name="style">background-color:{{#getFindingColour this}}{{/getFindingColour}}</xsl:attribute>
									{{this.assessmentFinding}}
								</li>
							</ul>
						</td>
					</tr>
					<tr>
						<th width="25%"><xsl:value-of select="eas:i18n('Target Remediation Date')"/></th>
						<td class="infoTd">{{#if this.targetRemediationDate}}{{this.targetRemediationDate}}{{else}} - {{/if}}</td>
						<th  width="25%"><xsl:value-of select="eas:i18n('Remediation Completion Date')"/></th>
						<td class="infoTd">{{#if this.completedRemediationDate}}{{this.completedRemediationDate}}{{else}} - {{/if}}</td>
					</tr> 
					{{#if this.plans}}
					<tr>
						<th><xsl:value-of select="eas:i18n('Plans')"/></th>
						<td colspan="3" class="infoTd"><ul class="ess-list-tags">{{#each this.plans}}<li class="planBlob">{{{essRenderInstanceMenuLink this}}}</li> {{/each}}</ul></td>
					</tr>
					{{/if}}
					<tr>
						<th><xsl:value-of select="eas:i18n('Comments')"/></th>
						<td colspan="3" class="infoTd">{{#if this.comments}}{{this.comments}}{{else}} - {{/if}}</td>
					</tr>
				</tbody>
				
			</table>  
			{{/each}}
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		</div>
			 
	</script>
	<script id="appline-template" type="text/x-handlebars-template">
		<span><xsl:attribute name="id">{{this.id}}</xsl:attribute>{{this.name}}<br/>
		{{#if this.proc}}{{#ifEquals this.proc 'Indirect'}}<label class="label" style="background-color: #b07fdd; display:inline-block;width:70px">{{this.proc}}</label>{{else}}<label class="label label-info" style="display:inline-block;width:70px">{{this.proc}}</label>{{/ifEquals}}{{/if}}
		{{#if this.org}}<label class="label label-warning"  style="display:inline-block;width:70px">{{this.org}}</label>{{/if}}
		</span>
	</script>
	<script id="roles-template" type="text/x-handlebars-template"></script>
	<script id="jsonOrg-template" type="text/x-handlebars-template">
		<div class="orgName">{{this.name}}</div>
	</script>
 	<script id="processes-template" type="text/x-handlebars-template"></script>
	<script id="sites-template" type="text/x-handlebars-template"></script>
	<script id="appsnippet-template" type="text/x-handlebars-template"></script>
<script>

<xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template>
 
function showEditorSpinner(message) { $('#editor-spinner-text').text(message);                            
    $('#editor-spinner').removeClass('hidden');
	}
function removeEditorSpinner(){ $('#editor-spinner').addClass('hidden');
    $('#editor-spinner-text').text('');
	};
showEditorSpinner('Loading Data - please wait');

 let products=[<xsl:apply-templates select="$controlFramework" mode="controlFramework"/>];
 let assessment=[<xsl:apply-templates select="$controlToElement" mode="elementAssessments"/>];
 let solutionAssessment=[<xsl:apply-templates select="$csa" mode="solutionAssessments"/>]
 console.log('assessment',assessment)
focusID=products[0].id;

//console.log('focusID',focusID)

	$(document).ready(function ()
	{
		// compile any handlebars templates
		var panelFragment = $("#panel-template").html();
		panelTemplate = Handlebars.compile(panelFragment);
 
		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
	 
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('ifGreaterThan', function(arg1, arg2, options) {
	 
				return (arg1 &gt; arg2) ? options.fn(this) : options.inverse(this);
			});
 
		let panelSet = new Promise(function(myResolve, myReject) {	 
			$('#mainPanel').html(panelTemplate())
			myResolve(); // when successful
			myReject();  // when error
			});
 
		});		 
</script>
		</html>
	</xsl:template>     
	
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/> 
			<xsl:param name="viewerAPIPathApp"/>
			<xsl:param name="viewerAPIPathPP"/>
			<xsl:param name="viewerAPIPathTech"/>
			<xsl:param name="viewerAPIPathInfo"/>
			
			//a global variable that holds the data returned by an Viewer API Report
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
			var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApp"/>';
			var viewAPIDataPP = '<xsl:value-of select="$viewerAPIPathPP"/>';
			var viewAPIDataTech = '<xsl:value-of select="$viewerAPIPathTech"/>';
			var viewAPIDataInfo = '<xsl:value-of select="$viewerAPIPathInfo"/>'; 
			//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		   
		   var promise_loadViewerAPIData = function(apiDataSetURL) {
				return new Promise(function (resolve, reject) {
					if (apiDataSetURL != null) {
						var xmlhttp = new XMLHttpRequest(); 
						xmlhttp.onreadystatechange = function () {
							if (this.readyState == 4 &amp;&amp; this.status == 200) { 
								var viewerData = JSON.parse(this.responseText);
								resolve(viewerData);
								$('#ess-data-gen-alert').hide();
							}
						};
						xmlhttp.onerror = function () {
							reject(false);
						};
						xmlhttp.open("GET", apiDataSetURL, true);
						xmlhttp.send();
					} else {
						reject(false);
					}
				});
			};
		   
	  var orgData=[];
	  var appData=[];
	  var processData=[]
	  var infoData=[]
	  var focusID
 

	  let rolesFragment, appsnippetTemplate, appsnippetFragment, appsFragment, processesFragment, sitesFragment, rolesTemplate, appsTemplate, processesTemplate,sitesTemplate ;
	
			$('document').ready(function () {
				
				$('.selectOrgBox').select2();
	
				rolesFragment = $("#roles-template").html();
				rolesTemplate = Handlebars.compile(rolesFragment);
				
				appsFragment = $("#apps-template").html();
				appsTemplate = Handlebars.compile(appsFragment);
	
				assessFragment = $("#assess-template").html();
				assessTemplate = Handlebars.compile(assessFragment);
				
				processesFragment = $("#processes-template").html();
				processesTemplate = Handlebars.compile(processesFragment);

				jsonFragment = $("#jsonOrg-template").html();
				jsonTemplate = Handlebars.compile(jsonFragment); 
	
				sitesFragment = $("#sites-template").html();
				sitesTemplate = Handlebars.compile(sitesFragment);
					   
				appsnippetFragment = $("#appsnippet-template").html();
				appsnippetTemplate = Handlebars.compile(appsnippetFragment);
				
				var appFragment = $("#appline-template").html();
				appTemplate = Handlebars.compile(appFragment);

				Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				 
					return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
				});
				
				Handlebars.registerHelper('getFindingColour', function(arg1, options) {
					let colourToShow = 'hsla(200, 80%, 60%, 1)';

					if(arg1.assessmentFinding=='Pass'){
						colourToShow='#1da014'
					}
					else if(arg1.assessmentFinding=='Fail'){
						colourToShow='#f10000'
					}
					return colourToShow;
				}); 
 
				Handlebars.registerHelper('getBusColour', function(arg1, arg2, options) {

					let rate= arg1/processData.businessProcesses.length
					if(rate &gt;0){
			 
					}
					cols='';
					if(rate ==0){
						cols='background-color:#ffffff; color: #000000'
					} else if(rate &lt; 0.33){
						cols='background-color:hsla(200, 80%, 90%, 1); color: #000000' 
					}else if(rate &lt; 0.70 &amp;&amp; rate &gt;32){
						cols='background-color: hsla(200, 80%, 70%, 1); color: #ffffff'
					}else {
						cols='background-color: hsla(200, 80%, 50%, 1); color: #ffffff'
					} 
					 
					return cols;
				});

				
				Handlebars.registerHelper('getAppColour', function(arg1, arg2, options) {

					let rate= arg1/appData.applications.length
					if(rate &gt;0){
			 
					}
					cols='';
					if(rate ==0){
						cols='background-color:#ffffff; color: #000000'
					} else if(rate &lt; 0.33){
						cols='background-color:hsla(200, 80%, 90%, 1); color: #000000' 
					}else if(rate &lt; 0.70 &amp;&amp; rate &gt;32){
						cols='background-color: hsla(200, 80%, 70%, 1); color: #ffffff'
					}else {
						cols='background-color: hsla(200, 80%, 50%, 1); color: #ffffff'
					} 
					 
					return cols;
				});

				Handlebars.registerHelper('getColour', function(arg1, arg2, options) {

					let apprate= arg1.appsImpacting.length/appData.applications.length;
					let busrate= arg1.busImpacting.length/appData.applications.length;
					let techrate= arg1.techImpacting.length/appData.applications.length;
					let rate= (apprate + busrate + techrate)/3;
					if(rate &gt;0){
			 
					}
					cols='';
					if(rate ==0){
						cols='background-color:#ffffff; color: #000000'
					} else if(rate &lt; 0.33){
						cols='background-color:hsla(200, 80%, 90%, 1); color: #000000' 
					}else if(rate &lt; 0.70 &amp;&amp; rate &gt;32){
						cols='background-color: hsla(200, 80%, 70%, 1); color: #ffffff'
					}else {
						cols='background-color: hsla(200, 80%, 50%, 1); color: #ffffff'
					} 
					 
					return cols;
				});
				
				Handlebars.registerHelper('getTechColour', function(arg1, arg2, options) {

					let rate= arg1/techProds.technology_products.length
					if(rate &gt;0){
			 
					}
					cols='';
					if(rate ==0){
						cols='background-color:#ffffff; color: #000000'
					} else if(rate &lt; 0.33){
						cols='background-color:hsla(200, 80%, 90%, 1); color: #000000' 
					}else if(rate &lt; 0.70 &amp;&amp; rate &gt;32){
						cols='background-color: hsla(200, 80%, 70%, 1); color: #ffffff'
					}else {
						cols='background-color: hsla(200, 80%, 50%, 1); color: #ffffff'
					} 
					 
					return cols;
				}); 
				Handlebars.registerHelper('rowType', function(arg1) {
					if (arg1 % 2 == 0){
						return 'even';
					} 
					else{
						return 'odd1';
					}
				}); 
			  
				$('.bottomDiv').hide();
	
	//get data
	Promise.all([ 
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataPP),
			promise_loadViewerAPIData(viewAPIDataTech),
			promise_loadViewerAPIData(viewAPIDataInfo)
			
			]).then(function(responses) {
				removeEditorSpinner();
				   appData=responses[0] 
				  
				   processData=responses[1]; 
				   techProds=responses[2]
				   infoData=responses[3];
				 console.log('infoData',infoData)
				//console.log('processData',processData)
				//console.log('techProds',techProds)
				//console.log('products',products)
				//console.log('assessment',assessment)
				   modelData=[]
				   appData.applications.forEach((d)=>{
					   d['controls']=[];
				   })

				   processData.businessProcesses.forEach((d)=>{
						d['controls']=[];
					})
					
				   techProds.technology_products.forEach((d)=>{
						d['controls']=[];
					})

					infoData.information_representation.forEach((d)=>{
						d['controls']=[];
					})
 
				getFocus(focusID);
				
				

				$('#fw').select2();

				$(document).on('change','.fw', function(){

					//console.log('val',$(this).val())
					let framework=$(this).val()

					appData.applications.forEach((d)=>{
						d['controls']=[];
					})
 
					processData.businessProcesses.forEach((d)=>{
						 d['controls']=[];
					 })
					 
					techProds.technology_products.forEach((d)=>{
						 d['controls']=[];
					 })
 
					 infoData.information_representation.forEach((d)=>{
						 d['controls']=[];
					 })

					getFocus(framework)
					})
			
				})
				.catch (function (error) {
					//display an error somewhere on the page   
				});
				
				
	  
			});

function getFocus(idtoUse){
 	
	let focusProduct=products.find((e)=>{
				return e.id==idtoUse;
			})		
			console.log('focusProduct',focusProduct)
					let busTotal=0;
					let appsTotal=0;
					let techTotal=0;
					let infoTotal=0;
					let suppTotal=0;
				
					focusProduct.controls.forEach((e)=>{
					 
						var groupByType = d3.nest()
						.key(function(d) { return d.elementType; })
						.entries(e.impacts);
						
						let busImp=groupByType.find((f)=>{return f.key=='Business_Process'})
						let appImp=groupByType.find((f)=>{return f.key=='Composite_Application_Provider'})
						let techImp=groupByType.find((f)=>{return f.key=='Technology_Product'})
						let dataImp=groupByType.find((f)=>{return f.key=='Information_Representation'})
						
						if(busImp){
							e['busImpacting']=busImp.values;
						} 
						if(appImp){
							e['appsImpacting']=appImp.values;
						}
						if(techImp){
							e['techImpacting']=techImp.values;
						}

						if(dataImp){
							e['infoImpacting']=dataImp.values;
						}
				 
					
						if(e.busImpacting.length&gt;0){
						busTotal=busTotal+e.busImpacting.length;
							e.busImpacting.forEach((f)=>{
							 
								let thisProc=processData.businessProcesses.find((ap)=>{
									return ap.id==f.elementId;
								});
									thisProc.controls.push({"id":e.id,"name":e.name, "assessment":f.id, "assessmentFinding":f.assessmentFinding})
							})
							 
						}
					
						if(e.appsImpacting.length&gt;0){
						appsTotal=appsTotal+e.appsImpacting.length;
					 
							e.appsImpacting.forEach((f)=>{ 
								let thisApp=appData.applications.find((ap)=>{
									return ap.id==f.elementId;
								});
								thisApp.controls.push({"id":e.id,"name":e.name, "assessment":f.id, "assessmentFinding":f.assessmentFinding})
								 
							})
						} 
					 
						if(e.infoImpacting.length&gt;0){
						 
							infoTotal=infoTotal+e.infoImpacting.length;
							console.log('e.infoTotal',infoTotal)
								e.infoImpacting.forEach((f)=>{ 
									let thisData=infoData.information_representation.find((ap)=>{
										return ap.id==f.elementId;
									});
									console.log('thisData',thisData)
									thisData.controls.push({"id":e.id,"name":e.name, "assessment":f.id, "assessmentFinding":f.assessmentFinding})
									 
								})
							}

						if(e.techImpacting.length&gt;0){
						techTotal=techTotal+e.techImpacting.length;
							e.techImpacting.forEach((f)=>{
							let thisTech=techProds.technology_products.find((ap)=>{
								return ap.id==f.elementId;
							});
							thisTech.controls.push({"id":e.id,"name":e.name, "assessment":f.id, "assessmentFinding":f.assessmentFinding})
							})
						}
						 
						if(e.suppImpacting){
						suppTotal=suppTotal+e.suppImpacting.length;
						}
					 
					}) 
					
					focusProduct['busTotal']=busTotal;
					focusProduct['appsTotal']=appsTotal;
					focusProduct['techTotal']=techTotal;
					focusProduct['infoTotal']=infoTotal;
					focusProduct['suppTotal']=suppTotal;
					
				let inScopeApp=appData.applications.filter((e)=>{
					return e.controls.length &gt;0
				}) 
				let inScopeProc=processData.businessProcesses.filter((e)=>{
					return e.controls.length &gt;0
				}) 
				let inScopeTech=techProds.technology_products.filter((e)=>{
					return e.controls.length &gt;0
				})
		 
				let inScopeInfo=infoData.information_representation.filter((e)=>{
					return e.controls.length &gt;0
				})
		 
  				drawView(focusProduct, inScopeApp, inScopeProc, inScopeTech, inScopeInfo)
}			
	
function drawView(controls, apps, busproc, techprod, infoData){
 
	apps.forEach((f)=>{
 
		let thisHTML=appsTemplate(f);
		f['appHTML']=thisHTML
	})
	
	busproc.forEach((f)=>{
		let thisHTML=appsTemplate(f);
		f['busHTML']=thisHTML
	})
	
	techprod.forEach((f)=>{
		let thisHTML=appsTemplate(f);
		f['techHTML']=thisHTML
	})

	infoData.forEach((f)=>{
		let thisHTML=appsTemplate(f);
		f['infoHTML']=thisHTML
	})

	initPopoverTrigger();

	controls['apps']=apps;
	controls['busProcs']=busproc;
	controls['techProds']=techprod; 
	controls['info']=infoData

	console.log('controls',controls)
	$('#mainPanel').html(panelTemplate(controls))

	initTable(apps, busproc, techprod, infoData);
	$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ $($.fn.dataTable.tables(true)).DataTable() .columns.adjust(); });
	
	$('.control-name-trigger').popover({
		container: 'body',
		html: true,
		trigger: 'hover',
		placement: 'auto',
		content: function(){
			return $(this).next().html();
		}
		}).on("show.bs.popover", function(){$(this).data("bs.popover").tip().css("max-width", "600px");});
	
	$('.solutionTag').on('click',function(){
		let theID =$(this).attr('easid');
		let focusAssessment = solutionAssessment.find((e)=>{
			return e.id==theID
		})
		focusAssessment['ctrl']=$(this).attr('easctrl');
		focusAssessment['app']=$(this).attr('easapp');
		$('#assessModalContent').html(assessTemplate(focusAssessment))
		$('#assessModal').modal('show')
	})

	$('.eleTag').on('click',function(){
		let theID =$(this).attr('easid');
		let focusAssessment = assessment.find((e)=>{
			return e.id==theID
		})

		focusAssessment['ctrl']=$(this).attr('easctrl');
		focusAssessment['app']=$(this).attr('easapp');

		$('#assessModalContent').html(assessTemplate(focusAssessment))
		$('#assessModal').modal('show')
	})
}
 
function initTable(dt, dbust, dtecht, dinfo){
 
	$('#dt_apptable tfoot th').each( function () {
		var techtitle = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
	});
	var apptable = $('#dt_apptable').DataTable({
		scrollY: "350px",
		scrollCollapse: true,
		paging: false,
		info: false,
		sort: true, 
		data: dt,
		columns: [
			{ data: "name", width: "250px" },
			{ data: "appHTML", width: "800px" }
		  ],
		dom: 'Bfrtip',
		buttons: [
			'copyHtml5', 
			'excelHtml5',
			'csvHtml5',
			'print'
		]
		});

		

		// Apply the search
		apptable.columns().every( function () {
			var that = this;
	 
			$( 'input', this.footer() ).on( 'keyup change', function () {
				if ( that.search() !== this.value ) {
					that
						.search( this.value )
						.draw();
				}
			} );
		} );
	 
		$('#dt_supportedcontrols tfoot th').each( function () {
			var techtitle = $(this).text();
			$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
		});
		var ctrltable = $('#dt_supportedcontrols').DataTable({
			scrollY: "350px",
			scrollCollapse: true,
			paging: false,
			info: false,
			sort: true,  
			dom: 'Bfrtip',
			buttons: [
				'copyHtml5', 
				'excelHtml5',
				'csvHtml5',
				'print'
			]
			});
	
 
	
			// Apply the search
			ctrltable.columns().every( function () {
				var that = this;
		 
				$( 'input', this.footer() ).on( 'keyup change', function () {
					if ( that.search() !== this.value ) {
						that
							.search( this.value )
							.draw();
					}
				} );
			} );	

 
			$('#dt_bustable tfoot th').each( function () {
				var techtitle = $(this).text();
				$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
			});
			var bustable = $('#dt_bustable').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,  
				dom: 'Bfrtip',
				buttons: [
					'copyHtml5', 
					'excelHtml5',
					'csvHtml5',
					'print'
				]
				});
				// Apply the search
				bustable.columns().every( function () {
					var that = this;
			 
					$( 'input', this.footer() ).on( 'keyup change', function () {
						if ( that.search() !== this.value ) {
							that
								.search( this.value )
								.draw();
						}
					} );
				} );
 
				$('#dt_techtable tfoot th').each( function () {
					var techtitle = $(this).text();
					$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
				});
				var techtable = $('#dt_techtable').DataTable({
					scrollY: "350px",
					scrollCollapse: true,
					paging: false,
					info: false,
					sort: true,
					dom: 'Bfrtip',
					buttons: [
						'copyHtml5', 
						'excelHtml5',
						'csvHtml5',
						'print'
					]
					});
			
					// Apply the search
					techtable.columns().every( function () {
						var that = this;
				 
						$( 'input', this.footer() ).on( 'keyup change', function () {
							if ( that.search() !== this.value ) {
								that
									.search( this.value )
									.draw();
							}
						} );
					} );
 

  		$('#dt_infotable tfoot th').each( function () {
					var techtitle = $(this).text();
					$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
				});
				var infotable = $('#dt_infotable').DataTable({
					scrollY: "350px",
					scrollCollapse: true,
					paging: false,
					info: false,
					sort: true,  
					dom: 'Bfrtip',
					buttons: [
						'copyHtml5', 
						'excelHtml5',
						'csvHtml5',
						'print'
					]
					});
			
					// Apply the search
					infotable.columns().every( function () {
						var that = this;
				 
						$( 'input', this.footer() ).on( 'keyup change', function () {
							if ( that.search() !== this.value ) {
								that
									.search( this.value )
									.draw();
							}
						} );
					} );
 
					$('#dt_supptable tfoot th').each( function () {
						var techtitle = $(this).text();
						$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
					});
					var supptable = $('#dt_supptable').DataTable({
						scrollY: "350px",
						scrollCollapse: true,
						paging: false,
						info: false,
						sort: true,  
						responsive: true,
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
						supptable.columns().every( function () {
							var that = this;
					 
							$( 'input', this.footer() ).on( 'keyup change', function () {
								if ( that.search() !== this.value ) {
									that
										.search( this.value )
										.draw();
								}
							} );
						} );	
			 			
}

function initPopoverTrigger()
{ 
	$('.popover-trigger').popover(
	{
		container: 'body',
		html: true,
		trigger: 'focus',
		placement: 'auto',
		content: function ()
		{
			return $(this).next().html();
		}
	});
};
 	
		</xsl:template>
		<xsl:template name="GetViewerAPIPath">
			<xsl:param name="apiReport"></xsl:param>
	
			<xsl:variable name="dataSetPath">
				<xsl:call-template name="RenderAPILinkText">
					<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
	
			<xsl:value-of select="$dataSetPath"></xsl:value-of>
	
		</xsl:template>	
		
<xsl:template match="node()" mode="controlFramework">
	<xsl:variable name="thiscontrols" select="$controls[name=current()/own_slot_value[slot_reference='cf_controls']/value]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",		
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"controls":[<xsl:for-each select="$thiscontrols">
			    <xsl:variable name="controlSolution" select="key('control_key',current()/name)"/>
				<xsl:variable name="thiscontrolToElement" select="$controlToElement[own_slot_value[slot_reference = 'control_to_element_control']/value=current()/name]"/>
				<xsl:variable name="thiscontrolToElementApps" select="$controlToElement[name=$applicationControls/name]"/>
				
				<xsl:variable name="thisprocessControls" select="$processControls[name=$thiscontrolToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
				<xsl:variable name="thisapplicationControls" select="$applicationControls[name=$thiscontrolToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
				<xsl:variable name="thistechnologyControls" select="$technologyControls[name=$thiscontrolToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
				<xsl:variable name="thisinformationControls" select="$informationControls[name=$thiscontrolToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
				
				{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isRenderAsJSString" select="true()"/>
					</xsl:call-template>",
				"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isRenderAsJSString" select="true()"/>
					</xsl:call-template>",	
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"solutions":[<xsl:for-each select="$controlSolution">
						<xsl:variable name="thissolutionBusinessElement" select="$solutionBusinessElement[name=current()/own_slot_value[slot_reference = 'control_solution_business_elements']/value]"/>
						<xsl:variable name="thissolutionApplicationElement" select="$solutionApplicationElement[name=current()/own_slot_value[slot_reference = 'control_solution_application_elements']/value]"/>
						<xsl:variable name="thissolutionTechnologyElement" select="$solutionTechnologyElement[name=current()/own_slot_value[slot_reference = 'control_solution_technology_elements']/value]"/>
						<xsl:variable name="thissolutionInformationElement" select="$solutionInformationElement[name=current()/own_slot_value[slot_reference = 'control_solution_information_elements']/value]"/>
						<xsl:variable name="allThisElements" select="$thissolutionBusinessElement union $thissolutionApplicationElement union $thissolutionTechnologyElement union $thissolutionInformationElement"/>
						{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						"name":"<xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="isRenderAsJSString" select="true()"/>
						</xsl:call-template>",
						"elements":[<xsl:for-each select="$allThisElements">
								{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
								"name":"<xsl:call-template name="RenderMultiLangInstanceName">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="isRenderAsJSString" select="true()"/>
										</xsl:call-template>"
										}<xsl:if test="position()!=last()">,</xsl:if>
								</xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
								</xsl:for-each>],
				"impacts":[<xsl:for-each select="$thiscontrolToElement">
						<xsl:variable name="thisprocessControls" select="$processControls[name=current()/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
						<xsl:variable name="thisapplicationControls" select="$applicationControls[name=current()/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
						<xsl:variable name="thistechnologyControls" select="$technologyControls[name=current()/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
						<xsl:variable name="thisthisinformationControls" select="$thisinformationControls[name=current()/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
					
						<xsl:variable name="allctrls" select="$thisthisinformationControls union $thisprocessControls union $thisapplicationControls union $thistechnologyControls"/>
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					"elementId":"<xsl:value-of select="eas:getSafeJSString(own_slot_value[slot_reference='control_to_element_ea_element']/value)"/>",
					"elementType":"<xsl:choose>
						<xsl:when test="$allctrls/type='Application_Provider'">Composite_Application_Provider</xsl:when><xsl:otherwise><xsl:value-of select="$allctrls/type"/></xsl:otherwise></xsl:choose>",
					"assessmentIds":[<xsl:for-each select="own_slot_value[slot_reference='control_to_element_assessments']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
					<xsl:variable name="assessmentKey" select="key('assessment_key',current()/name)"/>
					<xsl:variable name="latestAssessmentKey" select="$assessmentKey[position()=last()]"/>
					<xsl:variable name="assessmentResult" select="$assessmentFinding[name=$latestAssessmentKey/own_slot_value[slot_reference='assessment_finding']/value]"/> 
					"assessmentFinding":"<xsl:value-of select="$assessmentResult/own_slot_value[slot_reference='enumeration_value']/value"/>"
				}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
				"busImpacting":[],
				"appsImpacting":[],
				"techImpacting":[],
				"infoImpacting":[]
<!--
				"appsImpacting":[<xsl:for-each select="$thisapplicationControls">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				"busImpacting":[<xsl:for-each select="$thisprocessControls">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				"techImpacting":[<xsl:for-each select="$thistechnologyControls">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
				"infoImpacting":[<xsl:for-each select="own_slot_value[slot_reference='control_related_information']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				"supportImpacting":[<xsl:for-each select="own_slot_value[slot_reference='control_related_support']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]-->
			}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>		

<xsl:template match="node()" mode="solutionAssessments">
<xsl:variable name="assessmentKey" select="key('control_assessment_key',current()/name)"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"assessments":[<xsl:for-each select="$assessmentKey">
<xsl:variable name="assessmentResult" select="$assessmentFinding[name=current()/own_slot_value[slot_reference='assessment_finding']/value]"/> 
<xsl:variable name="assessor" select="$actors[name=current()/own_slot_value[slot_reference='control_solution_assessor']/value]"/>	
<xsl:variable name="thisComments" select="$commentary[name=current()/own_slot_value[slot_reference='commentary']/value]"/>	<!-- future req? -->	
		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
		"assessorid":"<xsl:value-of select="current()/own_slot_value[slot_reference='control_solution_assessor']/value"/>",
		"assessor":"<xsl:value-of select="$assessor/own_slot_value[slot_reference='name']/value"/>",	
		"assessmentDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='assessment_date_iso_8601']/value"/>",
		"assessmentFinding":"<xsl:value-of select="$assessmentResult/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"targetRemediationDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_remediation_target_date_ISO8601']/value"/>",
		"completedRemediationDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_remediation_completion_date_ISO8601']/value"/>",
		"comments":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_finding_impact_comments']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
}<xsl:if test="position()!=last()">,</xsl:if> 
 </xsl:template>

<xsl:template match="node()" mode="elementAssessments">
<xsl:variable name="assessmentKey" select="key('assessment_key',current()/name)"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"assessments":[<xsl:for-each select="$assessmentKey">
		<xsl:variable name="thisplans" select="$plans[name=current()/own_slot_value[slot_reference = 'ca_remediation_plans']/value]"/>
		<xsl:variable name="assessmentResult" select="$assessmentFinding[name=current()/own_slot_value[slot_reference='assessment_finding']/value]"/> 
		<xsl:variable name="assessor" select="$actors[name=current()/own_slot_value[slot_reference='control_assessor']/value]"/>	
		<xsl:variable name="thisComments" select="$commentary[name=current()/own_slot_value[slot_reference='assessment_comments']/value]"/>		
		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
		"assessorid":"<xsl:value-of select="current()/own_slot_value[slot_reference='control_assessor']/value"/>",
		"assessor":"<xsl:value-of select="$assessor/own_slot_value[slot_reference='name']/value"/>",	
		"assessmentDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='assessment_date_iso_8601']/value"/>",
		"assessmentFinding":"<xsl:value-of select="$assessmentResult/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"targetRemediationDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_remediation_target_date_ISO8601']/value"/>",
		"completedRemediationDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_remediation_completion_date_ISO8601']/value"/>",
		"plans":[<xsl:for-each select="$thisplans">{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
		"className":"Enterprise_Strategic_Plan"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"comments":"<xsl:value-of select="$thisComments/own_slot_value[slot_reference='name']/value"/>"		
			}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="options">
<option><xsl:attribute name="value"><xsl:value-of select="current()/name"/></xsl:attribute><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></option>
</xsl:template>

<xsl:template name="RenderJSMenuLinkFunctionsTEMP">
		<xsl:param name="linkClasses" select="()"/>
		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
		var esslinkMenuNames = {
			<xsl:call-template name="RenderClassMenuDictTEMP">
				<xsl:with-param name="menuClasses" select="$linkClasses"/>
			</xsl:call-template>
		}
     
		function essGetMenuName(instance) {  
			console.log('instance',instance)
			let menuName = null;
			if(instance.meta?.anchorClass) {
				menuName = esslinkMenuNames[instance.meta.anchorClass];
			} else if(instance.className) {
				menuName = esslinkMenuNames[instance.className];
			}
			console.log('menuName',menuName)
			return menuName;
		}
		
		Handlebars.registerHelper('essRenderInstanceMenuLink', function(instance){ 
			if(instance != null) {
                let linkMenuName = essGetMenuName(instance); 
				let instanceLink = instance.name;    
				if(linkMenuName) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
                } 
				return instanceLink;
			} else {
				return '';
			}
		});
    </xsl:template>
    <xsl:template name="RenderClassMenuDictTEMP">
		<xsl:param name="menuClasses" select="()"/>
		<xsl:for-each select="$menuClasses">
			<xsl:variable name="this" select="."/>
			<xsl:variable name="thisMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
			"<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
</xsl:stylesheet>
