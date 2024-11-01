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

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Business_Capability', 'Business_Process', 'Application_Provider', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product','Technology_Capability', 'Supplier', 'Individual_Actor', 'Information_Representation','Technology_Node','Application_Capability', 'Strategic_Plan', 'Project','Enterprise_Strategic_Plan')"/>
	
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"/>
	<xsl:variable name="physProcAppsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
	<xsl:variable name="apiSimplepath" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"/>
	<xsl:variable name="planning2Element" select="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="allPlans" select="/node()/simple_instance[supertype='Strategic_Plan']"/>
	<xsl:key name="plans" match="$allPlans" use="own_slot_value[slot_reference='strategic_plan_for_elements']/value"/> 

	<xsl:variable name="planningAction" select="/node()/simple_instance[type='Planning_Action']"/>
	<xsl:key name="essStyle" match="/node()/simple_instance[type='Element_Style']" use="own_slot_value[slot_reference='style_for_elements']/value"/>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="capsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appTechData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"></xsl:variable>
	<!-- START VIEW SPECIFIC SETUP VARIABLES -->
	
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
		<xsl:variable name="capPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appTechPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appTechData"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="ppPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$physProcAppsData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiSimple">
			<xsl:call-template name="GetViewerAPIPathText">
				<xsl:with-param name="apiReport" select="$apiSimplepath"/>
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
				<script src='js/d3/d3.v5.9.7.min.js'></script> 
				<script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
				<script src='common/js/pre_set_echarts.js'></script> 
				<script src="js/vis/vis.min.js?release=6.19" type="application/javascript"/>
                <link href="js/vis/vis.min.css?release=6.19" media="screen" rel="stylesheet" type="text/css"/>
				<style type="text/css">
					.tooltip {
						position: absolute;
						pointer-events: none; 
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
					
					.dataTables_filter label{
						display: inline-block!important;
					}
					
					#summary-content label{
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
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
					
					.ess-mini-badge {
						display: inline-block!important;
						padding: 2px 5px;
						border-radius: 4px;
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
							page-break-after: avoid;
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
						margin-right: 10%;
						margin-left: 10%;
						text-align: center;
						/* display: inline-block; */
						/* width: 60px; */
						box-shadow: 2px 2px 2px #d3d3d3;
					}
					.lbl-big{
						font-size: 150%;
					}
					.roleBlob{
						background-color: rgb(68, 182, 179)
					}


						//date box

						.date-box {
							background-color: #000;
							color: #fff;
							border: 2px solid #fff;
							padding: 20px;
							max-width: 400px;
							margin: 20px auto;
							font-family: 'Courier New', Courier, monospace; /* Mimics the monospace font of flight boards */
							border-radius: 10px;
							box-shadow: 0 0 15px rgba(255, 255, 255, 0.5);
						}

						.dateTitle {
							font-size: 13px;
							margin-bottom: 4px;
							letter-spacing: 0px;
							font-weight: bold;
						}

						.dateColumns {
							display: flex;
							justify-content: space-between;
						}

						.dateColumn {
							width: 48%;
							background-color: #696969; /* Slightly lighter background for columns */
							padding: 4px;
							border-radius: 5px;
						}

						.dateLabel {
							font-weight: bold;
							margin-bottom: 8px;
							font-size: 12px;
							color:#ffffff;
						}

						.dateNums {
							color: #ffe14c;  
							font-size: 13px;
							font-weight:bold;
							padding-left:10px
						}

						.animated-path {
							fill: none;
							stroke-width: 4;
							stroke-linecap: round;
							stroke-linejoin: round;
							stroke-dasharray: 500; /* Adjusted for each segment based on its length */
							stroke-dashoffset: 500;
							animation: draw-path 2s linear forwards; /* Each segment animates separately */
						}
						.connect-line {
							fill: none; 
							stroke-linecap: round;
							stroke-linejoin: round;
							stroke-dasharray: 500; /* Adjusted for each segment based on its length */
							stroke-dashoffset: 500;
							animation: draw-path 2s linear forwards; /* Each segment animates separately */
							stroke: #2980b9; /* Default color for connecting lines */
							stroke-width: 2;
						}
						.text {
							font-family: Arial, sans-serif;
							font-size: 12px; 
							fill: #000000;
							
						}
						.name-text {
							font-weight: bold;
							dy: "-1em"; /* Shifts the name text up */
						}
						.date-text {
							dy: "1em"; /* Positions the date text just below the center line */
						}
						@keyframes draw-path {
							from { stroke-dashoffset: 500; }
							to { stroke-dashoffset: 0; }
						}
						.classHeader{
							border-radius:6px;
							border:1px solid #d3d3d3;
							padding:3px;
							border-left: 4px solid #2da2a2;
							font-size:1.3em;
							font-weight:bold;
							width:33%;
						}
						.planBox{
							border:1pt solid #d3d3d3;
							border-radius:6px;
							padding:2px;
							font-size:0.9em;
							text-align: center;
							background-color:#5321aa;
							color:white;
						}
						.capToBox{
							border:1pt solid #d3d3d3;
							padding:2px;
							position:relative
						} 
						.capBox{
							border:1pt solid #d3d3d3;
							padding:2px;
							position:relative;
							display: inline-block;
						} 
						.l0-cap{
							border: 1px solid #ccc;
							border-left: 3px solid hsla(200, 80%, 50%, 1);
							border-bottom: 1px solid #fff;
							border-radius:5px;
							box-shadow:1px 1px 3px #e3e3e3;
							padding: 10px;
							margin-bottom: 15px;
							font-weight: 700;
							position: relative;
							background-color: #ffffff;
						}
						.l1-caps-wrapper {
							display: flex;
							flex-wrap: wrap;
							gap: 10px;
							justify-content: flex-start; /* Aligns items to the start */
						}
						.l1-cap {
						flex: 1;
						flex-shrink: 0;
						flex-basis: calc(33% - 10px); /* Set to 33% for up to 3 items per row */
						min-width: 160px; /* Adjust minimum width as needed */
						/* Rest of your styles */
						}
						.l1-cap,.l2-cap,.l3-cap{
						border-bottom: 1px solid #fff;
						border-left: 3px solid rgb(19, 139, 198);
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 5px 5px;
						font-weight: 400;
						position: relative;
						min-height: 60px;
						line-height: 1.1em;
						min-width: 160px;
						background-color: #ffffff
					}
					.impactCount{
						position:absolute;
						top:2px;
						right:3px;
						width:18px;
						height:18px;
						border:2px solid #4dc199;
						background-color:white;
						border-radius:15px;
						font-size: 0.8em; 
    					text-align: center;
						font-weight:bold;
					}
					.sidenav{ 
						height: calc(100vh - 78px); 
						width: 500px; 
						position: fixed; 
						z-index: 100; 
						top: 78px; 
						right: 0; 
						background-color: #f6f6f6; 
						overflow-x: hidden; 
						transition: margin-right 0.5s; 
						padding: 10px 10px 10px 10px; 
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px; 
						margin-right: -752px; 
						} 

						.sidenav .closebtn{ 
						position: absolute; 
						top: 5px; 
						right: 10px; 
						font-size: 14px; 
						margin-left: 50px; 
						} 
						@media screen and (max-height : 450px){ 
							.sidenav{ 
							padding-top: 53px; 
							} 
							.sidenav a{ 
							font-size: 14px; 
							} 
						}
						.impactBoxStyle{
							width:98%;
							border:1pt solid #d3d3d3;
							position:relative;
							padding:2px;
							margin:2px;
							border-left:3px solid #2da2a2;
							border-radius:6px;
						} 
						.impactType{
							border:1pt solid #d3d3d3;
							position:absolute;
							right:2px;
							top:2px;
							padding:2px;
							color:white;
							background-color: black;
							border-radius:6px;
						}
						.summaryPanelRight{
							 position:absolute; 
							 bottom:15px; 
							 right:3px
						}
	</style>
				
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				<!--ADD THE CONTENT-->
				<span id="mainPanel"/>
			
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
				<script>
				<xsl:call-template name="RenderHandlebarsUtilityFunctions"></xsl:call-template>
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
					<xsl:with-param name="viewerAPIPathApp" select="$appPath"/>
					<xsl:with-param name="viewerAPIPathCap" select="$capPath"/>
					<xsl:with-param name="viewerAPIPathPP" select="$ppPath"/>
				    <xsl:with-param name="viewerAPIPathSimple" select="$apiSimple"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathAppTech" select="$appTechPath"/>
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
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('Project')"></xsl:value-of>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Summary for')"/> </span><xsl:text> </xsl:text>
							<span class="text-primary headerName"><select id="subjectSelection" style="width: 600px;"></select></span>
					
						</h1>
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
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('Overview')"/></a>
						</li>
						<li>
							<a href="#impacts" data-toggle="tab"><i class="fa fa-fw fa-exchange right-10"></i><xsl:value-of select="eas:i18n('Impacts')"/><xsl:text> </xsl:text> <i class="fa fa-spinner fa-spin impactsSpinner"></i></a>
						</li> 
						<li>
							<a href="#stratplans" data-toggle="tab"><i class="fa fa-fw fa-calendar right-10"></i><xsl:value-of select="eas:i18n('Strategic Plans')"/><xsl:text> </xsl:text> <i class="fa fa-spinner fa-spin impactsSpinner"></i></a>
						</li> 
						<li>{{#or this.costs this.budget}}
							<a href="#financials" data-toggle="tab"><i class="fa fa-fw fa-area-chart right-10"></i><xsl:value-of select="eas:i18n('Financials')"/></a>
							{{/or}}
						</li> 
						<li>
							<a href="#documents" data-toggle="tab"><i class="fa fa-fw fa-book right-10"></i><xsl:value-of select="eas:i18n('Documentation &amp; Links')"/></a>
						</li> 
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-search right-10"></i><xsl:value-of select="eas:i18n('Project Overview')"/></h2>
							<div class="parent-superflex">
								<div class="superflex" style="max-width:50%;position:relative">
									<h3 class="text-primary"><i class="fa fa-search right-10"></i><xsl:value-of select="eas:i18n('Project Overview')"/></h3>
									<label><xsl:value-of select="eas:i18n('Project Name')"/></label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<div class="ess-string">{{{this.description}}}</div>
									<div class="clearfix bottom-10"></div> 
									<label><xsl:value-of select="eas:i18n('Approval')"/></label>
									<div class="ess-string">{{{this.approvalStatus}}}</div>
									<div class="clearfix bottom-10"></div> 
									<label><xsl:value-of select="eas:i18n('Status')"/></label>
									<div class="ess-string"><xsl:attribute name="style">{{#if this.lifecycleInfo}}background-color:{{this.lifecycleInfo.colour}};color:{{this.lifecycleInfo.textColour}}{{/if}}</xsl:attribute>{{{this.lifecycleStatus}}}</div>
									<div class="clearfix bottom-10"></div> 
									<div class="pull-right summaryPanelRight">
									{{#if this.priority}}
									<label><xsl:value-of select="eas:i18n('Priority')"/></label>
									<div class="ess-string">{{this.priority}}</div>
									{{/if}}
									{{#if this.ea_reference}}
									<label><xsl:value-of select="eas:i18n('EA_Reference')"/></label>
									<div class="ess-string">{{this.ea_reference}}</div>
									{{/if}}
									</div>
								</div>
								<div class="superflex">
									{{#if this.programmeName.name}}
									<h3 class="text-primary"><i class="fa fa-clone right-10"></i><xsl:value-of select="eas:i18n('Parent Programme')"/></h3>
									<div class="ess-string">{{this.programmeName.name}}</div>

									{{/if}}
									<h3 class="text-primary"><i class="fa fa-calendar-o right-10"></i><xsl:value-of select="eas:i18n('Key Dates')"/></h3>
									<div class="date-box">
										<div class="dateTitle">Start Date</div>
										<div class="dateColumns">
											<div class="dateColumn">
												<div class="dateLabel">Proposed</div>
												<div class="dateNums">{{setDate this.proposedStartDate}}</div>
											</div>
											<div class="dateColumn">
												<div class="dateLabel">Actual</div>
												<div class="dateNums">{{setDate this.actualStartDate}}</div>
											</div>
										</div>
									</div>
									<div class="date-box">
										<div class="dateTitle">End Date</div>
										<div class="dateColumns">
											<div class="dateColumn">
												<div class="dateLabel">Target</div>
												<div class="dateNums">{{setDate this.targetEndDate}}</div>
											</div>
											<div class="dateColumn">
												<div class="dateLabel">Forecast</div>
												<div class="dateNums">{{setDate this.forecastEndDate}}</div>
											</div>
										</div>
									</div>
								</div> 
							<!--
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Timeline')"/></h3>
										
									<div id="projectGantt" style='width:100%; height:100%;'></div>
									
								</div>
								<div class="col-xs-12"/>
								-->
							 
								<div class="superflex"> 
										<h3 class="text-primary"><i class="fa fa-calendar right-10"></i><xsl:value-of select="eas:i18n('Key Dates')"/></h3>
										
										<svg id="svgdates" height="150px"/>
										<!-- FUTURE USE 
										<div style="width: 100%; max-width: 1000px; margin: auto;">
											<svg width="100%" height="150px" viewBox="0 0 1000 200" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg">
												 
												<line x1="50" y1="70" y2="70" stroke="black" stroke-width="2"><xsl:attribute name="x2">{{this.projectDates.last}}</xsl:attribute></line>
											 
											{{#each this.projectDates}}
												{{#ifEquals this.name 'Today'}}
													<circle cy="70" r="10"><xsl:attribute name="stroke">{{this.color}}</xsl:attribute><xsl:attribute name="cx">{{this.svgPos}}</xsl:attribute><xsl:attribute name="class">pulsingCircle</xsl:attribute><animate 
														attributeName="r"
														from="10"
														to="5"
														dur="2s"
														repeatCount="indefinite"
													/></circle>
													<text y="90" font-size="10" text-anchor="middle"><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.name}}</text>
												{{else}}
													<circle cy="70" r="30"><xsl:attribute name="fill">{{this.color}}</xsl:attribute><xsl:attribute name="cx">{{this.svgPos}}</xsl:attribute></circle>
													
											
													{{#if (isEven @index)}}
														 
														<text y="120" font-size="12" text-anchor="middle"><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.name}}</text>
														<text y="140" font-size="14" text-anchor="middle"><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.date}}</text>
													{{else}}
													 
														<text y="10" font-size="12" text-anchor="middle"><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.name}}</text>
														<text y="30" font-size="14" text-anchor="middle"><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.date}}</text>
													{{/if}}
												{{/ifEquals}}	
											{{/each}}
										</svg> 
									
										</div>
										--> 
								</div>
								{{#if this.thisStakeholders}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('People, Organisations &amp; Roles')"/></h3>
									 
									<table class="table table-striped table-bordered" id="dt_stakeholders">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person')"/>/<xsl:value-of select="eas:i18n('Organisation')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
												 
												</tr>
											</thead>
											<tbody>
											{{#each this.thisStakeholders}}
											<tr>
												<td class="cellWidth-30pc">
														<i class="fa fa-user text-success right-5"></i>	{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
												</td>
												<td class="cellWidth-30pc">
													<ul class="ess-list-tags"> 
														<li class="roleBlob" style="background-color: rgb(96, 217, 214)">{{this.roleName}}</li> 
													</ul>
												</td>											 
											</tr>		
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th class="cellWidth-30pc">
															<xsl:value-of select="eas:i18n('Person')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
									
								</div>
								{{/if}}
							
							</div>
						 
						</div> 
						
						<div class="tab-pane" id="impacts">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-file-text-o right-10"></i>Impacts</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<ul class="nav nav-tabs tabs-top">
										<li class="active">
											<a href="#bcmImpacts" data-toggle="tab"><i class="fa fa-fw fa-sitemap right-10"></i><xsl:value-of select="eas:i18n('BCM Impacts')"/></a>
										</li>
										<li>
											<a href="#allImpacts" data-toggle="tab"><i class="fa fa-fw fa-exchange right-10"></i><xsl:value-of select="eas:i18n('All Impacts')"/></a>
										</li>									
									</ul>
									<div class="tab-content">	
										<div class="tab-pane active" id="bcmImpacts"> 
											<h3 class="text-primary"><i class="fa fa-sitemap right-10"></i><xsl:value-of select="eas:i18n('Business Capability Impacts')"/></h3>

											<div id="capModel"/>
										</div>
										<div class="tab-pane" id="allImpacts"> 
											<div id="impactsBox"/>
										</div>

								</div>
							</div>
						</div>
					</div>
						<div class="tab-pane" id="stratplans">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-file-text-o right-10"></i>Strategic Plans</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h2 class="text-primary">
										<i class="fa fa-arrow-circle-right right-10"></i>
										<xsl:value-of select="eas:i18n('Supported Strategic Plans')"/>
									</h2>
									<div class="content-section">
										This section shows the strategic plans that this project supports, and any impact its delivery schedule has on the delivery schedule of those plans
										<div id="planimpacts"></div>
										<small>Note: if no dates are shown then they are not defined for the plan</small>
									</div>
									 
								</div>
								<div class="superflex" style="min-width:600px">
									<h2 class="text-primary">
										<i class="fa fa-tasks right-10"></i>
										<xsl:value-of select="eas:i18n('Project to Strategic Plans Overlay')"/>
									</h2>
							 
									<div id="planProjGanttChart" width="800" height="400"></div>
									<p><small>Note: Plans or Projects with no <b>to</b> and <b>from</b> date are not shown</small></p>
								</div>
								<div class="superflex">
									<h2 class="text-primary">
										<i class="fa fa-arrow-circle-left right-10"></i>
										<xsl:value-of select="eas:i18n('Strategic Plan Dependencies')"/>
									</h2> 
                            		<p>Strategic plans that are dependent on the strategic plans that this project is supporting.  Note, any change in this project may have knock-on effects.</p>
									<div id="planDependencies"></div>
								</div>
							
							</div>

						</div>
						<div class="tab-pane" id="financials">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-area-chart right-10"></i>Financials</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-area-chart right-10"></i>Financials</h3>
								</div>
								<div class="col-xs-12"/>
								{{#if this.costs}}
								<div class="superflex">	
									<h3 class="text-primary">
										<i class="fa fa-money right-10"></i>
										<xsl:value-of select="eas:i18n('Costs')"/>
									</h3> 
									<ul class="nav nav-tabs tabs-top">
										<li class="active">
												<a href="#costsChart" data-toggle="tab"><i class="fa fa-fw fa-bar-chart right-10"></i><xsl:value-of select="eas:i18n('Chart')"/></a><xsl:text> </xsl:text>
										</li>
										<li> 
												<a href="#costNums" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('List')"/></a>
										</li>									
									</ul>
									<div class="tab-content">	
										<div class="tab-pane active" id="costsChart"> 
											<div id="lineChart" style="width: 100%; width: 500px; height: 300px;"></div> 
												<small>All Currencies converted to default currency</small> 
										</div>
										<div class="tab-pane" id="costNums"> 

										<!--	<div id="totalCosts"/>-->
											<table class="table table-condensed table-striped table-bordered" id="costTable">
												<thead>
													<tr>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('Type')"/>
														</th>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('Start Date')"/>
														</th>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('End Date')"/>
														</th>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('Amount')"/>
														</th>
													
													</tr>
												</thead>
												{{#each this.costs}}
												<tbody>
													<tr>
														<td class="cellWidth-20pc">
															{{setCostType this.recurrence}}
														</td>
														<td class="cellWidth-20pc">
															{{setDate this.startDate}}
														</td>
														<td class="cellWidth-20pc">
															{{setDate this.endDate}}
														</td>
														<td class="cellWidth-20pc">
															{{../this.ccy}}{{formatCost this.amount}}
															{{#if this.localAmount}}
															({{this.ccy}}{{formatCost this.localAmount}})
															{{/if}}
														</td>
														
													</tr>
												</tbody>
												{{/each}}

											</table>
										 
										</div>
									</div>
										
									 
								</div>
								{{else}}
								<div id="lineChart" style="width: 100%; width: 500px; height: 300px;display:none"></div> 
								{{/if}}
								{{#if this.budget}}
								<div class="superflex" id="superBox">	
									<h3 class="text-primary">
										<i class="fa fa-bookmark-o right-10"></i>
										<xsl:value-of select="eas:i18n('Budgets')"/>
									</h3> 	 
									<ul class="nav nav-tabs tabs-top">
										<li class="active">
											 
												<a href="#budgetChart" data-toggle="tab"><i class="fa fa-fw fa-bar-chart right-10"></i><xsl:value-of select="eas:i18n('Chart')"/></a><xsl:text> </xsl:text>
											 
										</li>
										<li>
											 
												<a href="#budgetNums" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('List')"/></a>
											 
										</li>
									</ul>
									<div class="tab-content">	
										<div class="tab-pane active" id="budgetChart"> 
											<div id="budgetCharts" style="width: 100%; width: 500px; height: 300px;"></div>
										</div>
										<div class="tab-pane" id="budgetNums"> 
											<table class="table table-condensed table-striped table-bordered" id="budgetTable">
												<thead>
													<tr>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('Type')"/>
														</th>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('Start Date')"/>
														</th>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('End Date')"/>
														</th>
														<th class="cellWidth-20pc">
															<xsl:value-of select="eas:i18n('Amount')"/>
														</th>
													
													</tr>
												</thead>
												{{#each this.budget}}
												<tbody>
													<tr>
														<td class="cellWidth-20pc">
															{{setCostType this.recurrence}}
														</td>
														<td class="cellWidth-20pc">
															{{setDate this.startDate}}
														</td>
														<td class="cellWidth-20pc">
															{{setDate this.endDate}}
														</td>
														<td class="cellWidth-20pc">
															{{formatCost this.amount}}
														</td>
														
													</tr>
												</tbody>
												{{/each}}

											</table>
										</div> 
									</div>
								</div>
								{{else}}
									<div id="budgetCharts" style="width: 100%; width: 500px; height: 300px;display:none"></div>
								{{/if}}
							</div>
						</div>
						<div class="tab-pane" id="documents">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-file-text-o right-10"></i>Documents</h2>
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-file-text-o right-10"></i>Documents</h3>
									{{#each this.documents}}  
										  {{#each this.values}} 
											{{#ifEquals @index 0}}
												{{#if this.type}}
													<h3>{{this.type}}</h3>
												{{else}}
													<h3>General</h3>
												{{/if}}
											{{/ifEquals}}
											<i class="fa fa-caret-right"></i> {{this.name}}: <a><xsl:attribute name="href">{{this.documentLink}}</xsl:attribute><i class="fa fa-link"></i></a><br/>
										{{/each}} 
									{{/each}}
								</div>
							</div>
						
						</div>
					</div>
				</div>
			</div>
			<div id="sidenav" class="sidenav"> 
				<a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()"> 
				<i class="fa fa-times"></i> 
				</a> 
				<h3>Impacts</h3>
				<div id="impactsListPanel"/> 
			</div> 
			<!--Setup Closing Tag-->
		</div>

	</script>	

	<script id="capmodel-template2" type="text/x-handlebars-template">
		{{#each this}}
			<div class="capToBox">
			{{this.name}}
			{{#if this.childrenCaps}}
				<div class="children">
				{{> capmodel this.childrenCaps}}
				</div>
			{{/if}}
			</div>
		{{/each}}
	
	</script>

	<script id="capmodel-partial2" type="text/x-handlebars-template">
	{{#each this}}
		<div class="capBox">
		{{this.name}}
		{{#if this.childrenCaps}}
			<div class="children">
			{{> capmodel this.childrenCaps}}
			</div>
		{{/if}}
		</div>
		<br/>
	{{/each}}
	</script>
	<script id="capmodel-template" type="text/x-handlebars-template">
		<div class="capModel">
			{{#each this}}
				<div class="l0-cap"><xsl:attribute name="easimpactid">{{id}}</xsl:attribute> 
					<xsl:attribute name="id">{{id}}</xsl:attribute>
					{{this.name}}
						{{> capmodel}}
					<div class="impactCount"><xsl:attribute name="easimpactid">{{id}}</xsl:attribute><i class="fa fa-spinner fa-spin fa-xs" style="font-size: 0.8em;"></i> </div>	
				</div>
			{{/each}}
		</div>
	</script>
	<script id="capmodel-partial" type="text/x-handlebars-template">
		<div class="l1-caps-wrapper">
			{{#each this.childrenCaps}}
			<div class="l1-cap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute><xsl:attribute name="easimpactid">{{id}}</xsl:attribute>
				<span class="sub-cap-label">{{this.name}}</span>
				{{> capmodel}}
				<div class="impactCount"><xsl:attribute name="easimpactid">{{id}}</xsl:attribute>
					<i class="fa fa-spinner fa-spin fa-xs" style="font-size: 0.8em;"></i>
				</div>
			</div>
			{{/each}}
		</div>	
	</script>
	
	<script id="planDependencies-template" type="text/x-handlebars-template">
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
                    	<td> {{#if this.dependsOn}}{{#each this.dependsOn}}{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}<br/>{{#if this.planEndDate}}<span class="label label-primary"> Ends: {{this.planEndDate}}</span><br/>{{/if}}{{/each}}{{else}}none{{/if}}</td>
                    	<td class="text-center"><i class="fa fa-arrow-left"></i></td>
                    	<td>{{{name}}}</td>
                    	<td class="text-center"><i class="fa fa-arrow-right"></i></td>
                    	<td>{{#if this.supports}}{{#each this.supports}}{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}<br/>{{#if this.planStartDate}}<span class="label label-primary">Starts: {{this.planStartDate}}</span>{{/if}}<br/>{{/each}}{{else}}none{{/if}}</td>
                    </tr>
             {{/each}}
                	</tbody>
                </table>    
             {{else}}
                No Dependencies
             {{/if}}
	</script>
	<script id="list-template" type="text/x-handlebars-template">
		{{#if this}}
			<table class="table table-bordered table-striped ">
		 {{#each this}}
				<tr><td width="60%"><i class="fa fa-tasks"></i><xsl:text> </xsl:text>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</td><td> {{#if status}}<span class="label label-default">{{this.status}}</span>{{/if}}{{#if this.endDate}}<div class="pull-right">From: <span class="label label-primary">{{this.startDate}}</span> To: <span class="label label-primary">{{this.endDate}}</span></div><div class="pull-right top-5"><label style="width:80px"><xsl:attribute name="class">label label-info risk{{id}}</xsl:attribute>{{this.risk}}</label></div>{{/if}}</td></tr>
		 {{/each}}
			</table>    
		 {{else}}
			No Associated Plans
		 {{/if}}
	   
	</script>
	<script id="impactlist-template" type="text/x-handlebars-template">
		{{#each this}}
		<div class="impactBoxStyle"><xsl:attribute name="style">border-left: 4px solid {{this.bgColour}}</xsl:attribute>
			{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}<br/>
			<div class="impactType"><xsl:attribute name="style">color: {{this.colour}}; background-color:{{this.bgColour}}</xsl:attribute>{{this.action}}</div>
			<small>{{#tidyKey this.instance.0.type}}{{/tidyKey}}</small>
		</div>
	
		{{/each}}
	</script>
	<script id="roles-template" type="text/x-handlebars-template">

	</script>
	<script id="jsonOrg-template" type="text/x-handlebars-template">
		<div class="orgName">{{this.name}}</div>
	</script>
 
	<script id="impacts-template" type="text/x-handlebars-template">
		{{#each this}}
		<div class="classHeader">{{#tidyKey @key}}{{/tidyKey}}</div>
		<table border="0" class="table table-condensed table-striped">
		<thead>
			<tr>
			{{#if this.[0]}}
				{{#each this.[0]}}
				<th><xsl:attribute name="style">{{#getWidth @key}}{{/getWidth}}</xsl:attribute>{{@key}}</th>
				{{/each}}
			{{/if}}
			</tr>
		</thead>
		<tbody>
			{{#each this}}
			<tr>
				{{#each this}}
					{{#if (isObject this)}}
						{{#if (eq @key 'name')}} 
							<td>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</td>
						{{else}}
							<td><button class="btn  btn-xs"><xsl:attribute name="style">background-color:{{this.bgColour}};color:{{this.colour}}</xsl:attribute>{{this.name}}</button></td>
						{{/if}}
						
						{{else}}
						{{#if (eq @key 'change')}} 
							<td> {{this}} </td>
						{{else}}
							{{#if (eq @key 'plan')}} 
								<td><div class="planBox" width="100px">{{this}}</div></td>
							{{else}}
						
								<td>{{this}}</td>
							{{/if}}
						{{/if}}
					{{/if}}
				{{/each}}
			</tr>
			{{/each}}
		</tbody>
		</table>
	{{/each}}
	</script>
	<script id="gantt-template" type="text/x-handlebars-template">
		<svg><xsl:attribute name="width">1200</xsl:attribute><xsl:attribute name="height">{{this.height}}</xsl:attribute>
			{{#each this.tasks}}
			<rect stroke="#ddd" stroke-width="1"><xsl:attribute name="x">{{this.startPos}}</xsl:attribute><xsl:attribute name="y">{{#getYPos @index 40}}{{/getYPos}}</xsl:attribute><xsl:attribute name="width">{{#getRectWidth this}}{{/getRectWidth}}</xsl:attribute><xsl:attribute name="height">40</xsl:attribute><xsl:attribute name="fill">{{this.colour}}</xsl:attribute></rect>
			<text font-size="13" text-anchor="left"><xsl:attribute name="x">10</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 15 40}}{{/getYPosText}}</xsl:attribute>{{this.name}}</text>
			<text font-size="10" text-anchor="left"><xsl:attribute name="x">10</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 25 40}}{{/getYPosText}}</xsl:attribute><xsl:value-of select="eas:i18n('Start')"/>:{{this.isoStart}}</text>
			<text font-size="10" text-anchor="left"><xsl:attribute name="x">10</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 35 40}}{{/getYPosText}}</xsl:attribute><xsl:value-of select="eas:i18n('End')"/>:{{this.isoEnd}}</text>
	
			{{#if this.type}}
			<rect class="box" stroke="#ddd" fill="#000000" rx="5" stroke-width="1"><xsl:attribute name="x">195</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 28 40}}{{/getYPosText}}</xsl:attribute><xsl:attribute name="width">30</xsl:attribute><xsl:attribute name="height">8</xsl:attribute></rect>
			
			<text font-size="8" fill="#ffffff" text-anchor="left"><xsl:attribute name="x">200</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 35 40}}{{/getYPosText}}</xsl:attribute> <xsl:value-of select="eas:i18n('PLAN')"/></text>
			{{else}} 
			<rect class="box" stroke="#ddd" fill="#000000" rx="4" stroke-width="1"><xsl:attribute name="x">195</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 28 40}}{{/getYPosText}}</xsl:attribute><xsl:attribute name="width">40</xsl:attribute><xsl:attribute name="height">8</xsl:attribute></rect>
			<text font-size="8" fill="#ffffff" text-anchor="left"><xsl:attribute name="x">200</xsl:attribute><xsl:attribute name="y">{{#getYPosText @index 35 40}}{{/getYPosText}}</xsl:attribute><xsl:value-of select="eas:i18n('PROJECT')"/></text>
			{{/if}}

			{{/each}}
			{{#each this.months}}
			<circle r="10" fill="#d3d3d3" stroke-fill="black"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">10</xsl:attribute></circle>
			<text font-size="12" font-weight="bold" text-anchor="middle"><xsl:attribute name="x">{{this.pos}}</xsl:attribute><xsl:attribute name="y">15</xsl:attribute>{{this.monthNumber}}</text>
			{{#ifEquals this.monthNumber 1}}
			<text font-size="12" text-anchor="middle"><xsl:attribute name="x">{{this.pos}}</xsl:attribute><xsl:attribute name="y">35</xsl:attribute>{{this.year}}</text>
			{{/ifEquals}}
			{{#ifEquals @index 0}}
			<text font-size="12" text-anchor="middle"><xsl:attribute name="x">{{this.pos}}</xsl:attribute><xsl:attribute name="y">35</xsl:attribute>{{this.year}}</text>
			{{/ifEquals}}
			<line style="stroke:rgb(183, 182, 182);stroke-width:1" stroke-dasharray="5,5" y1="40"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute> <xsl:attribute name="y2">{{../this.height}}</xsl:attribute> </line>
			
			{{/each}}
		</svg>
	</script>
	<script id="cost-template" type="text/x-handlebars-template">
		<div>
			{{#each this}}
				{{#ifEquals @key 'Adhoc_Cost_Component'}}
					<span class="label label-info">Adhoc Costs:</span> ${{this}}<br/>
				{{/ifEquals}}
				{{#ifEquals @key 'Annual_Cost_Component'}}
					<span class="label label-info">Annual Costs:</span> ${{this}}<br/>
				{{/ifEquals}}
				{{#ifEquals @key 'Quarterly_Cost_Component'}}
					<span class="label label-info">Quarterly Costs:</span> ${{this}}<br/>
				{{/ifEquals}}
				{{#ifEquals @key 'Monthly_Cost_Component'}}
					<span class="label label-info">Monthly Costs:</span> ${{this}}<br/>
				{{/ifEquals}}
			{{/each}}
		</div>
	</script>
	

		</html>
	</xsl:template>     
	
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/> 
			<xsl:param name="viewerAPIPathApp"/>
			<xsl:param name="viewerAPIPathPP"/>
			<xsl:param name="viewerAPIPathSimple"/>
			<xsl:param name="viewerAPIPathCap"/>
			<xsl:param name="viewerAPIPathAppTech"/>
			
			//a global variable that holds the data returned by an Viewer API Report
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
			var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApp"/>';
			var viewAPIDataPP = '<xsl:value-of select="$viewerAPIPathPP"/>'; 
			var viewAPIDataCap = '<xsl:value-of select="$viewerAPIPathCap"/>'; 
			var viewerAPIPathSimple = '<xsl:value-of select="$viewerAPIPathSimple"/>'; 
			var viewerAPIPathAppTech = '<xsl:value-of select="$viewerAPIPathAppTech"/>';
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
		    
var focusID="<xsl:value-of select='eas:getSafeJSString($param1)'/>";
var planningActions = [<xsl:apply-templates select="$planningAction" mode="planningAction"/>];
var plan2Elements = [<xsl:apply-templates select="$planning2Element" mode="planning2Element"/>];
var planDepends =[<xsl:apply-templates select="$allPlans" mode="supportPlans"/>];
var bcm, bcmImpactsArray;

const planningActionsMap = new Map(); 
var listTemplate
const p2emap = plan2Elements.reduce((acc, item) => {
    if (!acc[item.planId]) {
        acc[item.planId] = [];
    }
    acc[item.planId].push(item);
    return acc;
}, {});

 
planningActions.forEach(item => {
    planningActionsMap.set(item.id, { name: item.name, enumValue: item.enumValue, colour:item.colour, bgColour: item.bgColour });
});

var rolesTemplate, toShow, modelData, panelTemplate, projData;
var selectionHTML='';			
function getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, thisDatetoShow){
			
	const startDate=new Date(chartStartDate);       
	const endDate= new Date(chartEndDate);
	const thisDate= new Date(thisDatetoShow);
	pixels= chartWidth/(endDate-startDate);

	return ((thisDate-startDate)*pixels)+chartStartPoint;
}

function calculateEffectiveAnnualRate(data) {
    data.forEach(item => {
        if (item.recurrence === "Monthly_Budgetary_Element") {
            let months = 12; // Default number of months

            if (item.endDate) {
                let startDate = new Date(item.startDate);
                let endDate = new Date(item.endDate);
                let yearDiff = endDate.getFullYear() - startDate.getFullYear();
                let monthDiff = (endDate.getMonth() - startDate.getMonth()) + 1; // Including end month
                months = (yearDiff * 12) + monthDiff;
            }

            item.effectiveAnnualRate = item.amount * Math.min(months, 12); // Cap at 12 months for a year
        }

        if (item.recurrence === "Annual_Budgetary_Element") {
            item.effectiveAnnualRate = item.amount;
        }
    });
}

function generateMonthlyCosts(data, startYear, years) {
    let monthlyCosts = [];
    let currentDate = new Date(startYear, 0, 1); // Starting from January of the start year
    let endDate = new Date(startYear + years, 0, 1); // Up to the beginning of the year after the last year

    while (currentDate &lt; endDate) {
        let totalCostForMonth = 0;

        data.forEach(item => {
            let itemStartDate = new Date(item.startDate);
            let itemEndDate = item.endDate ? new Date(item.endDate) : endDate;

            if (itemStartDate &lt;= currentDate &amp;&amp; currentDate &lt;= itemEndDate) {
                if (item.recurrence === "Monthly_Budgetary_Element") {
                    totalCostForMonth += item.amount;
                } else if (item.recurrence === "Annual_Budgetary_Element") {
                    // Divide the annual amount by 12 to distribute it across the months
                    totalCostForMonth += item.amount / 12;
                }
            }
        });

        monthlyCosts.push({
            date: currentDate.toISOString().substring(0, 7), // Format as YYYY-MM
            totalCost: totalCostForMonth
        });

        currentDate.setMonth(currentDate.getMonth() + 1); // Move to the next month
    }

    return monthlyCosts;
}

var currencies, defaultCcy, defaultCcySymbol;

			$('document').ready(function () {
				$('#viewpoint-bar').hide();
				var listFragment = $("#list-template").html();
				listTemplate = Handlebars.compile(listFragment);
				 
				var planDependFragment = $("#planDependencies-template").html();
				planDependTemplate = Handlebars.compile(planDependFragment);
			 
				var impactlistFragment = $("#impactlist-template").html();
				impactlistTemplate = Handlebars.compile(impactlistFragment);

				var capmodelFragment = $("#capmodel-template").html();
				capmodelTemplate = Handlebars.compile(capmodelFragment);

				Handlebars.registerPartial('capmodel', Handlebars.compile(document.getElementById('capmodel-partial').innerHTML));

				var panelFragment = $("#panel-template").html();
				panelTemplate = Handlebars.compile(panelFragment);

				var impactsFragment = $("#impacts-template").html();
				impactsTemplate = Handlebars.compile(impactsFragment);

				var ganttFragment = $("#gantt-template").html();
				ganttTemplate = Handlebars.compile(ganttFragment);
				
				Handlebars.registerHelper('or', function(a, b, options) {
					if (a || b) {
					 
						if(a?.length &gt; 0){ 
						return options.fn(this);
						}else if (b?.length &gt;0 ){
							return options.fn(this);
						}
						else{
							return options.inverse(this);
						}

					} else {
						return options.inverse(this);
					}
				});

				Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
					return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
				}); 

				Handlebars.registerHelper('yearLine', function(arg1) {
					return 30;
				}); 
				

				Handlebars.registerHelper('getYPos', function(arg1, ht) {
					return arg1 * ht +40;
				}); 

				Handlebars.registerHelper('getYPosText', function(arg1, offset, ht) {

					return (arg1 * ht) +ht + offset;
				}); 
				

				Handlebars.registerHelper('getRectWidth', function(arg1) {
				 
					return arg1.endPos - arg1.startPos;
				}); 
				

				Handlebars.registerHelper('isObject', function(value) {
					return typeof value === 'object' &amp;&amp; value !== null;
				});

				Handlebars.registerHelper('eq', function(value1, value2) {
					return value1 === value2;
				});

				Handlebars.registerHelper('tidyKey', function(arg1) {
					return arg1.replaceAll('_',' ')
				}); 
				

				Handlebars.registerHelper('getWidth', function(arg1) {
					if(arg1 == 'name'){
						return 'width: 200px';
					}else if(arg1 == 'action'){
						return 'width: 100px';
					}else if(arg1 == 'type'){
						return 'width: 150px';
					}else if(arg1 == 'change'){
						return 'width: 250px';
					}else if(arg1 == 'plan'){
						return 'width: 100px';
					}else{
						
					}
				}); 
				

				Handlebars.registerHelper('isEven', function (index) {
					return index % 2 === 0;
				});

				Handlebars.registerHelper('formatCost', function (arg1) {
					return new Intl.NumberFormat().format(arg1) 
				});

				Handlebars.registerHelper('setCostType', function(arg1) {
					if(arg1.includes('Annual')){
						return 'Annual'
					}else if(arg1.includes('Monthly')){
						return 'Monthly'
					}else if(arg1.includes('Quarterly')){
						return 'Quarterly'
					}else if(arg1.includes('Adhoc')){
						return 'Adhoc'
					}
				})
				Handlebars.registerHelper('setDate', function(arg1) {
					
					//set dates for the key dates
					
					if(arg1){
						// Create a new Date object from the ISO date string
						const date = new Date(arg1);
						let currentLang="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>"

						if (!currentLang || currentLang === '') {
							currentLang = 'en-GB';
						}
					
						return formatDateforLocale(date, currentLang)
											
					}else{
						return 'Not Set'
					}
					 
				}); 

		
				let panelSet = new Promise(function(myResolve, myReject) {	 
				
					$('#mainPanel').html(panelTemplate())
					myResolve(); // when successful
					myReject();  // when error
					});
   
				
				$('.selectOrgBox').select2();
	
				rolesFragment = $("#roles-template").html();
				rolesTemplate = Handlebars.compile(rolesFragment);

				jsonFragment = $("#jsonOrg-template").html();
				jsonTemplate = Handlebars.compile(jsonFragment); 

				costFragment = $("#cost-template").html();
				costTemplate = Handlebars.compile(costFragment); 
				
				Handlebars.registerHelper('rowType', function(arg1) {
					if (arg1 % 2 == 0){
						return 'even';
					} 
					else{
						return 'odd1';
					}
				}); 
			
	
	//get data
	Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataPP),
			promise_loadViewerAPIData(viewAPIDataCap),
			promise_loadViewerAPIData(viewerAPIPathAppTech)
			]).then(function(responses) {
					projData=responses[0];
					currencies = projData.currencyData
					defaultCcy = projData.currencyId;
					defaultCcySymbol = projData.currency;
				
					let styles=projData.styles;
					let impactsArray=[];
				
					bcm=responses[3].busCapHierarchy;
					const { busCaptoAppDetails } = responses[3];
					const { applications } = responses[1];
					const { application_technology_architecture } = responses[4];

					const appMap = new Map(applications.map(app => [app.id, app]));
					const techMap = new Map(application_technology_architecture.map(tech => [tech.id, tech]));

					bcmImpactsArray = busCaptoAppDetails.map(item => {
						const {
							id, name, allProcesses, apps, thisapps, processes, orgUserIds, physP
						} = item;

						const allProcessesIds = allProcesses.map(proc => proc.id);
						const thisProcessesIds = processes.map(proc => proc.id);

						const entry = {
							id,
							name,
							allProcesses: allProcessesIds,
							apps,
							thisApps: thisapps,
							thisProcesses: thisProcessesIds,
							orgUserIds,
							physicalProcess: physP,
							sites: [],
							services: [],
							aprs: [],
							tech: [],
							allImpacts: []
						};

						const siteSet = new Set();
						const serviceSet = new Set();
						const aprSet = new Set();
						const techSet = new Set();

						entry.thisApps.forEach(appId => {
							const appMatch = appMap.get(appId);
							if (appMatch) {
								appMatch.siteIds.forEach(site => siteSet.add(site));
								appMatch.allServicesIdOnly.forEach(service => aprSet.add(service.id));
								appMatch.allServices.forEach(service => serviceSet.add(service.id));
							}

							const techMatch = techMap.get(appId);
							if (techMatch) {
								techMatch.supportingTech.forEach(techItem => {
									if (techItem.fromTechProductId) techSet.add(techItem.fromTechProductId);
									if (techItem.toTechProductId) techSet.add(techItem.toTechProductId);
								});
							}
						});

						entry.sites = Array.from(siteSet);
						entry.services = Array.from(serviceSet);
						entry.aprs = Array.from(aprSet);
						entry.tech = Array.from(techSet);

						entry.allImpacts = [
							
							...entry.services,
							...entry.sites,
							...entry.thisProcesses,
							...entry.thisApps,
							...entry.orgUserIds,
							...entry.physicalProcess,
							...entry.aprs,
							...entry.tech
						];
						entry.allImpacts.push(entry.id)

						return entry;
					});

					projData.allProject.forEach((e)=>{
						e['lifecycleInfo']= styles.find((s)=>{
							return s.id == e.lifecycleStatusID || s.id == e.lifecycleStatusID.replace(/\./g, "_");
						}) 
				 
						var option = new Option(e.name, e.id); 
						selectionHTML=selectionHTML+'<option value="'+e.id+'">'+e.name+'</option>';
					
					})
				 
				    appData=responses[1];
				    physProc=responses[2];  

				   modelData=[]
				 
				//	$('.selectOrgBox').val(focusID);  
				//	$('.selectOrgBox').trigger('change');
					
				 toShow = projData.allProject.find((e)=>{
					return e.id == focusID;
					})
  
/*
			 var docSort = d3.nest()
			 	.key(function(d) { return d.index; })
			 	.entries(toShow.documents);
			  toShow.documents=docSort;


			 console.log('to',toShow)
*/			 
			 
essInitViewScoping	(redrawView,['SYS_CONTENT_APPROVAL_STATUS'], "", true);
  
				}) 	
			}) 

			function openNav(){  
				document.getElementById("sidenav").style.marginRight = "0px"; 
			} 

			function closeNav() { 
					workingCapId=0; 
					document.getElementById("sidenav").style.marginRight = "-752px"; 
				}

var redrawView=function(){
	 
	$('.impactsSpinner').show();
	essResetRMChanges();   
	if(toShow){
	toShow['programmeName'] = projData.programmes?.find((p) => {
		return toShow?.programme ? toShow.programme === p.id : false;
	})?.name ?? null;
	}
 

	let impacts=essRMApiData.plans.filter((p)=>{
		return p.changeActivityId==toShow.id
	});
	  
	var impactList=[];
	var plansList=[];
	var list = new Promise((resolve, reject) => {
		let impactList = [];
		let promises = impacts.map((d, index) => {
			plansList.push(d.planId);
	
			function loadImpactWithRetry(d, retry = false) {
				let viewAPIImpacts = '<xsl:value-of select="$viewerAPIPathSimple"/>&amp;PMA=' + d.instId;
	
				// If retrying, amend the instId slightly (e.g., by adding a suffix or prefix)
				if (retry) {
					let dotPattern = d.instId.replace(/v(\d+_\d+(_\d+)?)/, (match) => {
						return match.replace(/_/g, '.'); // Replace underscores with dots
					});
					
					viewAPIImpacts = '<xsl:value-of select="$viewerAPIPathSimple"/>&amp;PMA=' + dotPattern;
				}
	
				return promise_loadViewerAPIData(viewAPIImpacts)
					.then(impact => {
					 
	
						let thisp2eplan = p2emap[d.planId];
						thisp2eplan = thisp2eplan.find((e) => {
							return e.instId == impact.id;
						});
	
						impact['action'] = planningActionsMap.get(d.actionId).name;
						impact['colour'] = planningActionsMap.get(d.actionId).colour;
						impact['bgColour'] = planningActionsMap.get(d.actionId).bgColour;
						impact['plan'] = thisp2eplan.plan;
						impact['description'] = thisp2eplan.description;
	
						impactList.push(impact);
					})
					.catch(error => {
						console.error('Error loading impact for instId:', d.instId, error);
	
						// If not already retried, attempt retrying with amended instId
						if (!retry) {
							console.log('Retrying with amended instId...');
							return loadImpactWithRetry(d, true);
						} else {
							console.error('Retry also failed for instId:', d.instId);
							// Optionally, push some default or error value to impactList here
						}
					});
			}
	
			// Return the promise from loadImpactWithRetry so it can be tracked
			return loadImpactWithRetry(d);
		});
	
		Promise.all(promises)
			.then(() => {
				 
				resolve(impactList);
			})
			.catch(error => {
				reject('Error loading impacts: ' + error);
			});
	});
	;
	
	list.then(impactList => { 

		function addImpactCounts(bcmImpactsArray, impactList) {
				// Create a Set of impact IDs for fast lookup
				const impactSet = new Set(impactList.map(impact => impact.id));

				// Iterate through each element in bcmImpactsArray
				bcmImpactsArray.forEach(item => {
					// Initialize the count for impacts to 0
					item.impactCount = 0;
					item['impactAllList']=[]
					if (item.allImpacts &amp;&amp; Array.isArray(item.allImpacts)) {
						// Count how many impact IDs from impactSet are in the allImpacts array
						item.allImpacts.forEach(impactId => {
							if (impactSet.has(impactId)) {
								item.impactCount += 1;
								item.impactAllList.push(impactId)
							}
						});
					}
				});

				return bcmImpactsArray;
			}
			addImpactCounts(bcmImpactsArray, impactList)
		$('.impactsSpinner').hide(); 

		const bcmImpactNum = bcmImpactsArray.filter((e)=>{
			return e.impactCount != 0
		})
	 
		$('.impactCount').text('0')
		bcmImpactNum.forEach((e)=>{
			$('.l0-cap[easimpactid="'+e.id+'"]').css('background-color', '#e9ebf6')
			$('.l1-cap[easimpactid="'+e.id+'"]').css('background-color', '#e9ebf6')
			$('.impactCount[easimpactid="'+e.id+'"]').parent().css('background-color', '#e9ebf6')
			$('.impactCount[easimpactid="'+e.id+'"]').text(e.impactCount)

		})

		$('.impactCount').off().on('click', function(){
			let easimpactid = $(this).attr('easimpactid')
			let bcMatch=bcmImpactNum.find((f)=>{
				return f.id == easimpactid
			})
			let bcToShow=[];
			bcMatch?.impactAllList.forEach((d)=>{
				let match=impactList.find((im)=>{
					return d==im.id
				})
				bcToShow.push(match)
			})
		
			$('#impactsListPanel').html(impactlistTemplate(bcToShow))
			 
			openNav()
		})
		function groupByType(data) {
			const result = {};
		
			data.forEach(item => {
			 
				const firstInstanceType = item.instance[0].type;
		
				if (!result[firstInstanceType]) {
					result[firstInstanceType] = [];
				}
		
				result[firstInstanceType].push(item);
			});
		
			return result;
		}
		
		function createTablesForGroups(groupedData) {
			const tables = {};
		
			for (const [type, items] of Object.entries(groupedData)) {
				const table = [];
				items.forEach(item => {
					
					const descriptionInstance = item.instance.find(inst => inst.name === 'description');
					const description = descriptionInstance ? descriptionInstance.value.id : 'N/A';
				 
					let desc;
					if (descriptionInstance &amp;&amp; descriptionInstance.value) {
						desc = descriptionInstance.value;
					} else {
						desc = 'N/A';
					}
					table.push({
						name: {"name": item.name, "id": item.id, "className":type},
						description: desc,
						change:item.description,
						plan:item.plan,
						action: {"name": item.action, colour: item.colour, bgColour: item.bgColour}
					
					});
				});
				tables[type] = table;
			}
		
			return tables;
		}

		const groupedData = groupByType(impactList);
 
		const tables = createTablesForGroups(groupedData);

		function removeDuplicates(arr) {
			const seen = new Set();
			return arr.filter(item => {
				const duplicate = seen.has(item.description);
				seen.add(item.description);
				return !duplicate;
			});
		}

		for (let key in tables) {
			if (Array.isArray(tables[key])) {
				tables[key] = removeDuplicates(tables[key]);
			}
		}

  plansList = [...new Set(plansList)]; 
  let pDetail=[];
  plansList.forEach((p)=>{
	let match=essRMApiData.rpp.strategicPlans.find((s)=>{
		return s.id==p
	}) 
  
function parseDate(dateStr) {
    // Attempt to parse as ISO format first
    let date = new Date(dateStr); 
    if (!isNaN(date)) {
        return date;
    }

    // If parsing as ISO fails, attempt to parse as locale format
    try {
        date = new Date(Date.parse(dateStr)); 
        if (!isNaN(date)) {
            return date;
        }else{
			const parts = dateStr.split('/');
			if (parts.length !== 3) {
				 
				return null;
			}
			const day = parseInt(parts[0], 10);
			const month = parseInt(parts[1], 10) - 1; // Months are zero-indexed in JavaScript Date
			const year = parseInt(parts[2], 10);

			const date = new Date(year, month, day);
			if (isNaN(date)) {
				console.error("Invalid date:", dateStr);
				return null;
			}
			return date;
		}
    } catch (e) {
        console.error("Failed to parse date:", dateStr);
    }

    // If parsing fails, return null or handle accordingly
    return null;
}

let matchEndDate = parseDate(match.endDate);
let forecastEndDate = parseDate(toShow.forecastEndDate);

function isISODateFormat(dateString) {
    // Regex to check if the date is in ISO format (YYYY-MM-DD)
    const regex = /^\d{4}-\d{2}-\d{2}$/;
    return regex.test(dateString);
}

	if(matchEndDate &lt; forecastEndDate ){
		function isISODateFormat(dateString) {
			// Regex to check if the date is in ISO format (YYYY-MM-DD)
			const regex = /^\d{4}-\d{2}-\d{2}$/;
			return regex.test(dateString);
		}

		risklevel='Delays';
	   }else
	   { risklevel='On Track';}
	   match['risk']=risklevel
	   match['startDateISO']=match.startDate;
	   match['endDateISO']=match.endDate;
	   if (!isISODateFormat(match.startDate)) {
			match.startDate = formatDateforLocale(match.startDate);
		}
		if (!isISODateFormat(match.endDate)) {
        	match.endDate = formatDateforLocale(match.endDate);
    	}
 
	pDetail.push(match)
 
  })
  
  var keydates=[];
                

	keydates.push({"id":toShow.id, name:toShow.name,  startDate: toShow.actualStartDate, endDate: toShow.forecastEndDate, colour: "#4CAF50", style:'background-color:#de8585'});
	
	pDetail.forEach(function(d){
		if(d.startDate &amp;&amp; d.endDate){
			let col="#4CAF50"
			if(d.type == 'Enterprise'){ 
				col="#03b6fc";
				keydates.push({"id":d.id, name:d.name,  startDate: d.startDateISO, endDate: d.endDateISO, colour:col, type:'Enterprise' });
			}else{
				keydates.push({"id":d.id, name:d.name,  startDate: d.startDateISO, endDate: d.endDateISO, colour:col });
			}
		}
	})
 
			let tasks=keydates
			tasks.forEach((s) => {
				if (s &amp;&amp; s.startDate) {  // Guard condition for startDate
					s['isoStart'] = formatDateforLocale(s.startDate);
				}
			
				if (s &amp;&amp; s.endDate) {  // Guard condition for endDate
					s['isoEnd'] = formatDateforLocale(s.endDate);
				}
			});
			
 
 
  const svg = document.getElementById("planProjGanttChart");
			 
			let parentWidth=$('#planProjGanttChart').parent().width();
		 
			var svgWidth = parentWidth ; 
			if(svgWidth&lt;=0){svgWidth=800}
			var startPoint=  20 // where timeline begins 
			var ganttWidth= svgWidth-(startPoint+30); 
			$('#planProjGanttChart').css('width', parentWidth);
 
 
 
		const minDate = new Date(Math.min(...tasks.map(task => new Date(task.startDate))));
        const maxDate = new Date(Math.max(...tasks.map(task => new Date(task.endDate))));

		function generateMonthYearArray(minDate, maxDate) {
			const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
			let dateArray = [];
			let currentYear = minDate.getFullYear();
			let currentMonth = minDate.getMonth();

			// Iterate from minDate to maxDate
			while (new Date(currentYear, currentMonth) &lt;= maxDate) {
				dateArray.push({
					year: currentYear,
					month: currentMonth,
					monthNumber: currentMonth+1,
					monthName: months[currentMonth],
					pos: getPosition(250, ganttWidth, minDate, maxDate, currentYear + '-' + (currentMonth+1) +'-01')
				});

				// Move to the next month
				currentMonth++;
				if (currentMonth > 11) {
					currentMonth = 0;
					currentYear++;
				}
			}

			    // If the array has more than 15 months, pick out every third month from January 
				if (dateArray.length > 15) {
					dateArray = dateArray.filter((date, index) => (date.month % 3 === 0));
				}

			return dateArray;
		}

		const monthsAndYears = generateMonthYearArray(minDate, maxDate);
 

		tasks.forEach((t)=>{
 			t['startPos']=getPosition(250, ganttWidth, minDate, maxDate, t.startDate)
			t['endPos']=getPosition(250, ganttWidth, minDate, maxDate, t.endDate)
		})

		let ht = (tasks.length * 42)+40 

		svgData={
			width:parentWidth,
			tasks:tasks,
			months:monthsAndYears,
			height: ht
		}
 
		$('#planProjGanttChart').html(ganttTemplate(svgData))
 
		
		pDetail.forEach((p)=>{
			let planDeps=[];
		let planSups=[];
			let match = planDepends.find((e)=>{
				return e.id==p.id
			})
			 
			match.dependsOn.forEach((e)=>{
				let don=essRMApiData.rpp.strategicPlans.find((s)=>{
					return s.id==e
				}) 
				don['className']='Enterprise_Strategic_Plan';
				planDeps.push(don)
			})
			match.supports.forEach((e)=>{
				let sup=essRMApiData.rpp.strategicPlans.find((s)=>{
					return s.id==e
				}) 
				sup['className']='Enterprise_Strategic_Plan';
				planSups.push(sup)
			})
			p['className']='Enterprise_Strategic_Plan';
			p['dependsOn']=planDeps;
			p['supports']=planSups; 
		})

		$('#planDependencies').html(planDependTemplate(pDetail))
		
/*
	var container = document.getElementById("visualization");

	// Create a DataSet (allows two way data-binding)
	var items = new vis.DataSet(keydates);

	// Configuration for the Timeline

	var today = new Date();
	// Calculate the start and end dates
	var startDate = new Date(today.getFullYear() - 2, today.getMonth(), today.getDate());
	var endDate = new Date(today.getFullYear() + 2, today.getMonth(), today.getDate());

	// Configuration for the Timeline
	var options = {
		start: startDate,
		end: endDate
	};

	// Create a Timeline
	var timeline = new vis.Timeline(container, items, options);      	
*/
const order = [
    "Business_Capability",
	"Business_Process",
    "Group_Actor",
    "Site",
	"Application_Capability",
    "Composite_Application_Provider",
	"Application_Provider",
	"Application_Prrovider_Role",
	"Application_Provider_Interface",
    "Technology_Capability",
    "Technology_Component",
	"Technology_Composite",
	"Technology_Provider",
	"Technology_Provider_Role",
	"Technology_Product",
	"Technology_Node",
	"Information_Representation"
];
 
const sortedData = order.reduce((acc, key) => {
    if (tables[key]) {
        acc[key] = tables[key];
    }
    return acc;
}, {});
 

$('#impactsBox').html(impactsTemplate(sortedData)) 
$('#planimpacts').html(listTemplate(pDetail))
	}).catch(error => {
		console.error(error);
		// Optionally, you could display an error somewhere on the page
	});
 
	 
	let ccShow=false
	// Create a Map for quick lookup of currencies by their id
	const currencyMap = new Map(currencies.map(e => [e.id, e]));
	toShow['ccy']=defaultCcySymbol
	// Iterate over the costs and adjust the amount
	toShow.costs.forEach((c) => {
		if (c.ccy !== defaultCcy) {
			ccShow=true;
			const currency = currencyMap.get(c.ccy);  // Fast lookup
			if (currency) {  // Ensure currency exists
				const exchangeRate = parseFloat(currency.exchangeRate) || 1;  // Default to 1 if invalid
				c['localAmount'] = c.amount;  // Save original amount
				c.amount = c.amount * exchangeRate;  // Adjust amount
				
			}
	 
		  if (currency) {
				c['ccy'] = currency.symbol || '$';
			} else {
				// Handle the case where currency is undefined
				c['ccy'] = '$';
			}
		}
	});
  
	costArray=expandCostData(toShow.costs)
	budgetArray=expandBudgetData(toShow.budget)
 

	let totals=calculateTotals(costArray);
	let budgets=calculateTotals(budgetArray);
 
	<!-- end -->

		let orgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
		let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
		let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
		let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
		let busDomainDef = new ScopingProperty('domainIds', 'Business_Domain');
 
		calculateEffectiveAnnualRate(toShow.budget)
		var monthlyCosts = generateMonthlyCosts(toShow.budget, 2023, 3);


 
		//create SVG Timeline Information	
		let data=[ 
				{"id": "abc1", "name": "Proposed Start", "data": toShow.proposedStartDate, "color": "#e74c3c"},
				{"id": "abc2", "name": "Actual Start", "data": toShow.actualStartDate, "color": "#2ecc71"},
				{"id": "abc3", "name": "Forecast End", "data": toShow.forecastEndDate, "color": "#3498db"},
				{"id": "abc4", "name": "Target End", "data": toShow.targetEndDate, "color": "#FFA500"}
				]			 
				
				<!-- future use
				const originalToday = new Date(); // Store the original today date
					let chartStartDate = new Date(originalToday.setFullYear(originalToday.getFullYear() - 2));

					// Reset originalToday to the current date
					const today = new Date();
					let chartEndDate = new Date(today.setFullYear(today.getFullYear() + 3));

					const todayFinal = new Date();
					
					//if dates earlier than chart start make them the start date
					if (toShow.proposedStartDate) {
						const proposedDate = new Date(toShow.proposedStartDate);
						if (proposedDate &lt; chartStartDate) {
							chartStartDate = proposedDate;
						}
					}
					
					if (toShow.actualStartDate) {
						const actualDate = new Date(toShow.actualStartDate);
						if (actualDate &lt; chartStartDate) {
							chartStartDate = actualDate;
						}
					}

					let proposedStart	= getPosition(60, 1000, chartStartDate, chartEndDate, toShow.proposedStartDate)
					let actualStart	= getPosition(60, 1000, chartStartDate, chartEndDate, toShow.actualStartDate)
					let forecastEnd	= getPosition(60, 1000, chartStartDate, chartEndDate, toShow.forecastEndDate)
					let targetEnd	= getPosition(60, 1000, chartStartDate, chartEndDate, toShow.targetEndDate)
					let todayDate = getPosition(60, 1000, chartStartDate, chartEndDate, todayFinal)
					

					toShow['projectDates']=[{name:"Proposed Start Date", date: "2020-01-01", svgPos: proposedStart, color: "#A9D18E"},
					{name:"Actual Start Date", date: "2020-03-01", svgPos: actualStart, color: "#008F00"},
					{name:"Target End Date", date: "2024-01-01", svgPos: targetEnd, color: "#FF386A"},
					{name:"Forecast End Date", date: "2024-06-01", svgPos: forecastEnd, color: "#B6002B"},
					{name:"Today", date: "", svgPos: todayDate, color: "#000000"}];

					let maxSvgPosObject = toShow.projectDates.reduce((maxObj, currentObj) => {
						return (currentObj.svgPos > maxObj.svgPos) ? currentObj : maxObj;
					}, toShow.projectDates[0]);
				
					maxSvgPosObject.last = true;

					toShow.projectDates['last']=maxSvgPosObject.svgPos;

				-->	
 
					toShow['thisStakeholders']=toShow.stakeholders.map(actor => {
						return {
							"name": actor.actorName,
							"id": actor.actorId,
							"className": "Individual_Actor",
							"roleName": actor.roleName,
							"roleId": actor.roleId
						};
					});
					
					if(toShow.documents){
						let docsCategory = d3.nest()
						.key(function(d) { return d.type; })
						.entries(toShow.documents);
						
						toShow['documents']=docsCategory;
					}
 

	let panelSet = new Promise(function(myResolve, myReject) {
	
			$('#mainPanel').html(panelTemplate(toShow))

			myResolve(); // when successful
			myReject(); // when error
			});
			
	panelSet.then(function(response) {
 
		 
		$('#capModel').html(capmodelTemplate(bcm))
		var table = $('#dt_stakeholders').DataTable();

		// Append a text input to each footer cell for column filtering
	    $('#dt_stakeholders tfoot th').each(function() {
			var title = $(this).text();
			$(this).html('<input type="text" placeholder="Search ' + title + '" />');
		});
	
		// Apply the search
		table.columns().every(function() {
			var that = this;
			
			$('input', this.footer()).on('keyup change clear', function() {
				if (that.search() !== this.value) {
					that.search(this.value).draw();
				}
			});
		});

		$('#subjectSelection').html(selectionHTML); 
		$('#subjectSelection').select2();
		function setSelectedOption(optionId) {
			$('#subjectSelection').val(optionId);
		}
	
		// Example usage: set the selected option by id
		let selectedOptionId = toShow.id // Replace with the desired option id
		setSelectedOption(selectedOptionId);
		$('#subjectSelection').val(toShow.id).trigger('change.select2');;
		<!-- echarts cost --> 
		const costData = [];

		if (costArray.Annual_Cost_Component &amp;&amp; costArray.Annual_Cost_Component.length > 0) {
			costData.push({
				name: 'Annual',
				type: 'line',
				data: costArray.Annual_Cost_Component
			});
		}
		
		if (costArray.Monthly_Cost_Component &amp;&amp; costArray.Monthly_Cost_Component.length > 0) {
			costData.push({
				name: 'Monthly',
				type: 'line',
				data: costArray.Monthly_Cost_Component
			});
		}
		
		if (costArray.Quarterly_Cost_Component &amp;&amp; costArray.Quarterly_Cost_Component.length > 0) {
			costData.push({
				name: 'Quarterly',
				type: 'line',
				data: costArray.Quarterly_Cost_Component
			});
		}
		

		const budgetData = [];

		if (budgetArray.Annual_Budgetary_Element &amp;&amp; budgetArray.Annual_Budgetary_Element.length > 0) {
			budgetData.push({
				name: 'Annual',
				type: 'line',
				data: budgetArray.Annual_Budgetary_Element
			});
		}
		
		if (budgetArray.Adhoc_Budgetary_Element &amp;&amp; budgetArray.Adhoc_Budgetary_Element.length > 0) {
			budgetData.push({
				name: 'Adhoc',
				type: 'line',
				data: budgetArray.Adhoc_Budgetary_Element
			});
		}
		
		if (budgetArray.Monthly_Budgetary_Element &amp;&amp; budgetArray.Monthly_Budgetary_Element.length > 0) {
			budgetData.push({
				name: 'Monthly',
				type: 'line',
				data: budgetArray.Monthly_Budgetary_Element
			});
		}
		
		if (budgetArray.Quarterly_Budgetary_Element &amp;&amp; budgetArray.Quarterly_Budgetary_Element.length > 0) {
			budgetData.push({
				name: 'Quarterly',
				type: 'line',
				data: budgetArray.Quarterly_Budgetary_Element
			});
		}
 
		createMultiDateLineChart('lineChart', '', costData, ['Annual', 'Monthly', 'Quarterly']);
 		createMultiDateLineChart('budgetCharts', '', budgetData, ['Adhoc', 'Annual', 'Monthly', 'Quarterly']);
		<!--
 
        var lineOption = {
             
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                data: ['Annual','Monthly', 'Quarterly']
            },
			grid: {
				left: '50px', // You can use percentage or pixel value, e.g., '50px'
			},
            xAxis: {
                type: 'time',
                boundaryGap: false
            },
            yAxis: {
                type: 'value',
                axisLabel: {
                    formatter: defaultCcySymbol+'{value}'
                }
            },
            series: costData
        };
	
		lineChart.setOption(lineOption);
	-->
 
		$('#totalCosts').html(costTemplate(totals))

		<!-- end echarts -->

		$('#subjectSelection').on('change', function(){
			toShow = projData.allProject.find((e)=>{
				return e.id == $(this).val();
				})
 
				toShow['thisStakeholders']=toShow.stakeholders.map(actor => {
						return {
							"name": actor.actorName,
							"id": actor.actorId,
							"className": "Individual_Actor",
							"roleName": actor.roleName,
							"roleId": actor.roleId
						};
					});

					if(toShow.documents){
						let docsCategory = d3.nest()
						.key(function(d) { return d.type; })
						.entries(toShow.documents);
						
						toShow['documents']=docsCategory;
					}
				 
			redrawView();	
		})
 
	})
 

		//set SVG time circles

					const svgNamespace = "http://www.w3.org/2000/svg";
					const svgElement = document.querySelector('#svgdates');
					 
					let currentX = 150; // Start at the center of the first loop
					// Get the parent element of the SVG
					const parentElement = svgElement.parentNode.parentNode;

					// Retrieve the client width of the parent element
					let svgWidth = parentElement.clientWidth;// Calculate total width needed based on number of data items
				 
					let currentXdynamic = (svgWidth-100)/data.length;
					let lineWidth = currentXdynamic-80;
					 
					svgElement.setAttribute('width', svgWidth.toString()); // Set dynamic width based on calculated width

					data.forEach((item, index) => {
					  // Create each circle with its specific color
					  const circle = document.createElementNS(svgNamespace, 'path');
					  circle.setAttribute('d', `M${currentX},60 a10,10 0 1,0 80,0 a10,10 0 1,0 -80,0`);
					  circle.setAttribute('stroke', item.color);
					  circle.classList.add('animated-path');
					  circle.style.animationDelay = `${index * 0.1}s`;
					  svgElement.appendChild(circle);
					
					  if (index &lt; data.length - 1) {
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
					  let nameLen=item.name.length *6.25
				 
					  const nameText = document.createElementNS(svgNamespace, 'text');
					  nameText.setAttribute('class', 'name-text');
					  nameText.setAttribute('x', currentX );
					  nameText.setAttribute('y', '115');
					  nameText.textContent = item.name;
					  svgElement.appendChild(nameText);
					  
					  const formattedDate = item.data ? formatDateforLocale(item.data) : null;
					  const dateText = document.createElementNS(svgNamespace, 'text');
					  dateText.setAttribute('class', 'date-text');
					  dateText.setAttribute('x', currentX + 8);
					  dateText.setAttribute('y', '65');
					  dateText.textContent = formattedDate;
					  svgElement.appendChild(dateText);
					
					  currentX += currentXdynamic; // Move to next circle's center
					});
 
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
		<xsl:template name="GetViewerAPIPathText">
			<xsl:param name="apiReport"></xsl:param>
	
			<xsl:variable name="dataSetPath">
				<xsl:call-template name="RenderLinkText">
					<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
	
			<xsl:value-of select="$dataSetPath"></xsl:value-of>
	
		</xsl:template>
		<xsl:template match="node()" mode="supportPlans">
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"supports":[<xsl:for-each select="current()/own_slot_value[slot_reference='supports_strategic_plan']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"dependsOn":[<xsl:for-each select="current()/own_slot_value[slot_reference='depends_on_strategic_plans']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		 
		}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="planning2Element">
		<xsl:variable name="thisplan" select="key('plans', current()/name)"/>
			{"id":"<xsl:value-of select="current()/name"/>",
			"idForAPI":"<xsl:value-of select="current()/name"/>",
			<xsl:variable name="temp" as="map(*)" select="map{
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('relation_description')]/value, '}', ')'), '{', ')')),
				'plan': string($thisplan/own_slot_value[slot_reference = 'name']/value),
				'planId': string($thisplan/name),
				'instId':string(current()/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value)
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"></xsl:value-of>
		}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
	<xsl:template match="node()" mode="planningAction">
		<xsl:variable name="styleForThis" select="key('essStyle', current()/name)"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="temp" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
			'enumName': string(current()/own_slot_value[slot_reference = 'enumeration_value']/value),
			'colour': string($styleForThis/own_slot_value[slot_reference = 'element_style_text_colour']/value),
			'bgColour': string($styleForThis/own_slot_value[slot_reference = 'element_style_colour']/value)
		}"></xsl:variable>
		<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"></xsl:value-of>
	}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
