<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<!-- END GENERIC PARAMETERS -->
	<xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Application Dashboard']"></xsl:variable>
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Composite_Application_Provider')"></xsl:variable>
 
	 
	<!-- END GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="reportPath" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
	<xsl:variable name="reportPathApps" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
	-->
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
PPTX - powerpoint generation

Copyright (c) 2015-Present Brent Ely
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, 
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 
	-->
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
    <xsl:variable name="capsListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
    <xsl:variable name="physProcListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
    

<!--	<xsl:variable name="scoreData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: App KPIs']"></xsl:variable>
-->
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiBCM">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiCaps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsListData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="apiPhysProc">
                <xsl:call-template name="GetViewerAPIPath">
                    <xsl:with-param name="apiReport" select="$physProcListData"></xsl:with-param>
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
                <script src="js/d3/d3.min.js"></script>
                <script src="js/chartjs/Chart.min.js"></script>
				<script src="js/chartjs/chartjs-plugin-labels.min.js"></script>
				<script src="js/pptxgenjs/dist/pptxgen.bundle.js"></script>
				<title>Application Dashboard</title>
				<style>
					html {
						scroll-behavior: smooth;
					}
					#appBox {
						display: flex;
						flex-wrap: no-wrap;
						gap: 5px;
						flex-direction: column;
						height: calc(100vh - 250px);
						overflow-y: auto;
					}
					.appBox {
						border: 1px solid #ccc;
						border-radius: 4px;
						border-left: 3px solid #1A9FF9;
						padding: 5px 20px 5px 5px;
						background-color: #fff;
						display: flex;
						align-items: center;
						position: relative;
					}

					.appBoxLabel{
						width: 220px;
						white-space: nowrap;
						overflow: hidden;
						text-overflow: ellipsis;
					}
                    #appPanel {
						background-color: rgba(0,0,0,0.85);
						padding: 10px;
						border-top: 1px solid #ccc;
						position: fixed;
						bottom: 0;
						left: 0;
						z-index: 100;
						width: 100%;
						height: 350px;
						color: #fff;
                    }
                    .sidenav{
						height: calc(100vh - 41px);
						width: 350px;
						position: fixed;
						z-index: 1;
						top: 41px;
						right: 0;
						background-color: #f6f6f6;
						overflow-x: hidden;
						transition: margin-right 0.5s;
						padding: 10px 10px 10px 10px;
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
						margin-right: -352px;
					}
					
					.sidenav .closebtn{
						position: absolute;
						top: 5px;
						right: 5px;
						font-size: 14px;
						margin-left: 50px;
					}
					
					@media screen and (max-height : 450px){
						.sidenav{
							padding-top: 15px;
						}
					
						.sidenav a{
							font-size: 14px;
						}
					}
					
					.app-list-scroller {
						height: calc(100vh - 150px);
						overflow-x: hidden;
						overflow-y: auto;
					}
					
			
					
					.appBox a {
						color: #fff!important;
					}
					
					.appBox a:hover {
						color: #ddd!important;
					}
					
					.appBoxSummary {
						background-color: #333;
						padding: 5px;
						float: left;
						width: 100%;
					}
					
					.appBoxTitle {
						width: 200px;
						white-space: nowrap;
						overflow: hidden;
						text-overflow: ellipsis;
					}
					
					.appInfoButton {
						position: absolute;
						bottom: 3px;
                        right: 5px;
                        color: #aaa;
                        cursor: pointer;
					}
					
					.app-circle{
						display: inline-block;
						min-width: 10px;
						padding: 2px 5px;
						font-size: 10px;
						font-weight: 700;
						line-height: 1;
						text-align: center;
						white-space: nowrap;
						vertical-align: middle;
						background-color: #fff;
						color: #333;
						border-radius: 10px;
						border: 1px solid #ccc;
						position: absolute;
						right: 5px;
						top: 5px;
					}
					
					.app-circle:hover {
						background-color: #333;
						color: #fff;
						cursor: pointer;
					}

					.lifecycle{
						position: relative;
						/* height: 20px; */
						border-radius: 8px;
						min-width: 60px;
						font-size: 11px;
						line-height: 11px;
						padding: 2px 4px;
						border: 2px solid #fff;
						text-align: center;
						background-color: grey;
						color: #fff;
					}

					.lifecycleMain{
						position:relative;
						right:0px;
						bottom:20px;
						height:20px;
						border-radius:5pt;
						width:80px;
						font-size:10pt;
						border:1pt solid #d3d3d3; 
						text-align:center;
						background-color:grey;
						color:#fff;
					}

					.blob{
						height:10px;
						border-radius:8px;
						width:30px;
						border:1px solid #666; 
						background-color: #ccc;
						}

					.blobNum{
						color: rgb(140, 132, 112);
						font-weight:bold;
						font-size:9pt;
						text-align:center;
					}
					
					.blobBox,.blobBoxTitle{
						display: inline-block;
					}
					
					.blobBox {
						position: relative;
						top: -12px;
					}
					#appPanel {
						background-color: rgba(0,0,0,0.85);
						padding: 10px;
						border-top: 1px solid #ccc;
						position: fixed;
						bottom: 0;
						left: 0;
						z-index: 100;
						width: 100%;
						height: 350px;
						color: #fff;
					}
					#appData{

                    }
                    .dark a {
                    	color: #fff;
                    }
					.light a {
						color: #000
					}
					
					.smallCardWrapper {
						display: flex;
						flex-wrap: wrap;
					}

					.smallCard{
						width:160px; 
						height:60px;
						min-height:60px;
						max-height:60px;
						margin: 0 10px 10px 0;
						padding:5px;
						border-radius:4px;
						line-height: 1em;
					}

					.noneMapped{
						background-color: #f6f6f6;
						border: 1pt solid #ccc;
						border-bottom: 1px solid #aaa;
						color: #aaa;
					} 

					.caps {
						background-color: #fff;;
						border: 1pt solid #ccc;
						border-bottom: 1px solid #aaa;
						border-left:3px solid #a93e4e;
						}
						
					.procs {
						background-color: #fff;;
						border: 1pt solid #ccc;
						border-bottom: 1px solid #aaa;
						border-left:3px solid #8c50d2;

						}
					.svcs {
						background-color: #fff;;
						border: 1pt solid #ccc;
						border-bottom: 1px solid #aaa;
						border-left:3px solid #d7a51b;
					}
					.iconCube{
						background-color: #fff;
						border: 1pt solid #ccc;
						color: #333;
						width: 50px;
						min-width: 50px;
						margin-right: 5px;
						line-height: 12px;
						padding: 3px 4px;
						border-radius: 4px;
						display: inline-block;
					}

					.iconCubeHeader{
						margin-right: 10px;
						font-size: 12px;
						display: inline-block;
					}
					
					.mini-details {
						display: none;
						position: relative;
						float: left;
						width: 100%;
						padding: 5px 5px 0 5px;
						background-color: #454545;
					}
					
					.tab-content {
                    	padding-top: 10px;
                    }
                    .ess-tag-default {
                    	background-color: #adb5bd;
                    	color: #333;
                    }
                    
                    .ess-tag-default > a{
                    	color: #333!important;
                    }
                    
                    .ess-tag {
                    	padding: 3px 12px;
                    	border: 1px solid #222;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    }
                	.inline-block {display: inline-block;}
                	.ess-small-tabs > li > a {
                		padding: 5px 15px;
                	}
                	.badge.dark {
                		background-color: #555!important;
                	}
                	.vertical-scroller {
                		overflow-x:hidden;
                		overflow-y: auto;
                		padding-right: 5px;
                	}
					.Key {
						position:relative;
						top:-30px;
					}
					.shigh{color: #6E2C00}
					.smed {color:#BA4A00} 
					.slow{color: #EDBB99 }
                	.vertical-scroller.dark::-webkit-scrollbar { width: 8px; height: 3px;}
					.vertical-scroller.dark::-webkit-scrollbar-button {  background-color: #666; }
					.vertical-scroller.dark::-webkit-scrollbar-track {  background-color: #646464;}
					.vertical-scroller.dark::-webkit-scrollbar-track-piece { background-color: #222;}
					.vertical-scroller.dark::-webkit-scrollbar-thumb { height: 50px; background-color: #666; border-radius: 3px;}
					.vertical-scroller.dark::-webkit-scrollbar-corner { background-color: #646464;}}
					.vertical-scroller.dark::-webkit-resizer { background-color: #666;}
					
					table.sticky-headers > thead > tr > th {
						position: sticky;
						top: -10px;
					}
					input.form-control.dark {
						color: #333;
					}
					.eas-logo-spinner {
						display: flex;
						justify-content: center;
					}
					.appInDivBoxL0{
						border:1pt solid #d3d3d3; 
						background-color: rgb(250, 250, 250);
						height:40px; 
						border-radius:8px; 
						width:170px;
						display:inline-block;
						margin:2px;
						padding:2px;
						font-size:0.8em;
						vertical-align: top; 
						position:relative;
					}
					.appInDivBox{
						position:relative;
						border:1pt solid #d3d3d3; 
						background-color: rgb(250, 250, 250);
						height:40px; 
						border-radius:8px; 
						width:90%;
						display:inline-block;
						margin:2px;
						padding:2px;
						font-size:0.8em;
						vertical-align: top;
						display:block;
					}
					.scoreHolder {
						position:absolute;
						width:100%;
						bottom:-5px;
					}
					.score {
						display:inline-block;
						border-radius:4px;
						font-size:0.8em; 
						text-align:center;
						line-height: 8px;
   						 height: 7pt;
						border:1pt solid #838282;
					}
					.scoreKeyHolder {
						position:relative; ;
						display:inline-block;
						margin-right:15px;
						border:1pt solid #d3d3d3;
						border-radius:4px;
						padding-left:2px;
						padding-right:2px;
						margin-bottom:5px;
					}
					.scoreKey {
						display:inline-block;
						border-radius:4px;
						font-size:0.9em; 
						text-align:center;
						line-height: 12px;
   						 height: 12pt;
							padding:3px;
					}
					.appCounter{
						border-radius: 4px;
						background-color:#333;
						color:#fff;
						font-size:18px;
						font-weight:bold;
						padding: 5px 10px;
						display: inline-block;
						width: 100%;
					}  
					.titleHead{
						font-size:14pt
					}
					#chartsArea {
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					.ess-chart-wrapper {
						width: calc(50% - 15px);
					}
					.panel-heading {
						position: relative;
					}
					.btt_link {
						position:absolute;
						font-size: 10px;
						right:5px;
						top: 5px;
					}
					.btt_link > a{
						color: #333;
						font-style: italic;
					}
					#chart-quick-links {
						display: flex;
						gap: 10px;
						margin-bottom: 10px;
					}
					
					.quick-link:hover{
						text-decoration: none;
					}
					.quick-link-label {
						border: 1px solid #ccc;
						padding: 5px;
						background-color: #f6f6f6;
						color: #333;
						font-size: 10px;
					}
					.quick-link-label:hover {
						border: 1px solid #000;
						background-color:#333;
						color: #fff;
						cursor: pointer;
					}
					<!--.sentToPowerPoint{
						background-color:green;
						color:#fff;
					}-->
					.sendToPP {
						position:absolute;
						top: 5px;
						right: 5px;
					}
					
					.panel-body{
						position: relative;
					}
					
				</style>
				<!--	 <xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
				-->
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				<!--	<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
				
					<div class="clearfix"></div>
				</div>
			-->
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Dashboard')"></xsl:value-of> </span>
								 
								</h1>
							</div>
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<div class="col-xs-12">
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
						</div>
						<div class="col-xs-12">
							<div class="row">
								<div class="col-md-2">
									<div id='filtersHolder'/>
									<div class="input-group bottom-10">
										<span class="input-group-addon"><i class="fa fa-search"/></span>
										<input type="text" class="form-control" id="appFilterBox" placeholder="Filter..." />
									</div>
									<div id="appBox"></div>
		                        </div>
								<div class="col-md-10">
									<div>
										<label>Business Capability:</label>
										<select id="busCaps" style="width: 200px;">
											<option id="all">All</option>
										</select>
										<div class="pull-right">
											<button id="generate" class="btn btn-success"><i class="fa fa-cogs right-5"/>Generate PowerPoint<span></span></button>
										</div>

									</div>
									<div class="appCounter top-10 bg-primary"><i class="fa fa-desktop right-10"/>Applications In Scope: <span id="appVal">0</span></div>									
									<div id="chart-quick-links" class="top-15"/>
									<div id="appInfoBox">
										<div id="chartsArea"/>
									</div>
								</div>
							</div>
						</div>

						<div class="col-xs-12" id="dataHolder">
                        </div>
                        <!--
						<div id="appSidenav" class="sidenav">
							<button class="btn btn-default appRatButton bottom-15 saveApps"><i class="fa fa-external-link right-5 text-primary "/>View in Rationalisation</button>
							<a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()">
								<i class="fa fa-times"></i>
							</a>
							<div class="clearfix"/>
						 
							<div class="app-list-scroller top-5">

								<div id="appsList"></div>
							</div>
                        </div>
                        -->
						<!--Setup Closing Tags-->
					</div>
				</div>


				<div class="appPanel" id="appPanel">
						<div id="appData"></div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

		<script id="filters-template" type="text/x-handlebars-template">
		{{#each this}}
		{{this.name}}:
		<select class="filters"><xsl:attribute name="id">{{this.name}}</xsl:attribute>
			<option value="all">All</option>
			{{#each this.vals}}
				<option><xsl:attribute name="value">{{this.id}}</xsl:attribute>{{this.name}}</option>
			{{/each}}
		</select>
		{{/each}}
		</script>

				<!-- Apps list for sidebar -->
				<script id="appList-template" type="text/x-handlebars-template">
					 	<span id="capsId"><xsl:attribute name="easid">{{this.cap}}</xsl:attribute><h3>{{this.capName}}</h3></span>
						{{#each this.apps}}
							<div class="appBox">
								<xsl:attribute name="easid">{{id}}</xsl:attribute>
								<div class="appBoxSummary">
									<div class="appBoxTitle pull-left strong">
										<xsl:attribute name="title">{{this.name}}</xsl:attribute>
										<i class="fa fa-caret-right fa-fw right-5 text-white" onclick="toggleMiniPanel(this)"/>{{#essRenderInstanceLinkMenuOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}
									</div>
									<div class="lifecycle pull-right">
										<xsl:attribute name="style">background-color:{{lifecycleColor}};color:{{#if lifecycleText}}{{lifecycleText}}{{else}}#000000{{/if}}</xsl:attribute>
										{{this.lifecycle}}
									</div>
								</div>
								<div class="clearfix"/>
								<div class="mini-details">
									<div class="small pull-left text-white">
										<div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{capsList.length}} Supported Business Capabilities</div>
										<div class="left-5 bottom-5"><i class="fa fa-users right-5"></i>{{orgUserIds.length}} Supported Organisations</div>
										<div class="left-5 bottom-5"><i class="fa essicon-boxesdiagonal right-5"></i>{{processList.length}} Supported Processes</div>
										<div class="left-5 bottom-5"><i class="fa essicon-radialdots right-5"></i>{{services.length}} Services Provided</div>
									</div>

										<button class="btn btn-default btn-xs appInfoButton pull-right"><xsl:attribute name="easid">{{id}}</xsl:attribute>Show Details</button>
									
								</div>
								<div class="clearfix"/>
							</div>
						{{/each}}
					 
				</script>

				<script id="app-template" type="text/x-handlebars-template">
					<div class="row">
	            		<div class="col-sm-8">
	            			<!--	<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>
	            		<div class="ess-tag ess-tag-default"><i class="fa fa-money right-5"/>Cost: {{costValue}}</div>
	                		<div class="inline-block">{{#calcComplexity totalIntegrations capsCount processesSupporting servicesUsed.length}}{{/calcComplexity}}</div>-->
	            		</div>
	            		<div class="col-sm-4">
	            			<div class="text-right">
	            				<!--<span class="dropdown">
	            					<button class="btn btn-default btn-sm dropdown-toggle panelHistoryButton" data-toggle="dropdown"><i class="fa fa-clock-o right-5"/>Panel History<i class="fa fa-caret-down left-5"/></button>
		            				<ul class="dropdown-menu dropdown-menu-right">
										<li><a href="#">Page 1</a></li>
										<li><a href="#">Page 2</a></li>
										<li><a href="#">Page 3</a></li>
									</ul>
	            				</span>-->
	            				<i class="fa fa-times closePanelButton left-30"></i>
	            			</div>
	            			<div class="clearfix"/>
	            		</div>
	            	</div>
					
					<div class="row">
	                	<div class="col-sm-12">
							<ul class="nav nav-tabs ess-small-tabs">
								<li class="active"><a data-toggle="tab" href="#summary">Summary</a></li>
								<li><a data-toggle="tab" href="#capabilities">Capabilities<span class="badge dark">{{capabilitiesSupporting}}</span></a></li>
								<li><a data-toggle="tab" href="#processes">Processes<span class="badge dark">{{processesSupporting}}</span></a></li>
								<li><a data-toggle="tab" href="#integrations">Integrations<span class="badge dark">{{totalIntegrations}}</span></a></li>
			                 	<li><a data-toggle="tab" href="#services">Services</a></li>
								<li></li>
							</ul>

					
							<div class="tab-content">
								<div id="summary" class="tab-pane fade in active">
									<div>
				                    	<strong>Description</strong>
				                    	<br/>
				                        {{description}}    
				                    </div>
		                			<div class="ess-tags-wrapper top-10">
		                				<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#2EB8BF;color:#ffffff</xsl:attribute>
											<i class="fa fa-code right-5"/>{{codebase}}</div>
		                				<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:#24A1B7;color:#ffffff</xsl:attribute>
											<i class="fa fa-desktop right-5"/>{{delivery}}</div>
		                				<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:#A884E9;color:#ffffff</xsl:attribute>
												<i class="fa fa-users right-5"/>{{processList.length}} Processes Supported</div>
		                				<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:#6849D0;color:#ffffff</xsl:attribute>
												<i class="fa fa-exchange right-5"/>{{totalIntegrations}} Integrations ({{inI}} in / {{outI}} out)</div>
										{{#each this.appFilters}}
										<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:{{this.value.backgroundColor}};color:{{this.value.colour}}</xsl:attribute>
											<i class="fa fa-circle right-5"/>{{this.value.name}}<span class="fontNormal xsmall"> [{{this.name}}]</span></div>
								
										{{/each}}
									</div>
									
								</div>
							<!--	<div id="capabilities" class="tab-pane fade">
									<p class="strong">This application supports the following Business Capabilities:</p>
									<div>
									{{#if capList}} 
									{{#each capList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#f5ffa1;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}}
									{{else}}
										<p class="text-muted">None Mapped</p>
									{{/if}}
									</div>
                                </div>
                            -->     
								<div id="processes" class="tab-pane fade">
									<p class="strong">This application supports the following Business Processes, supporting {{processList.length}} processes:</p>
									<div>
									{{#if processes}}
									{{#each processes}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted">None Mapped</p>
									{{/if}}
									</div>
								</div>
								<div id="services" class="tab-pane fade">
									<p class="strong">This application supports the following Services:</p>
									<div>
									{{#if services}}
									{{#each servList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#73B9EE;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted">None Mapped</p>
									{{/if}}
									</div>
								</div>
								<div id="integrations" class="tab-pane fade">
			                    <p class="strong">This application has the following integrations:</p>
			                	<div class="row">
			                		<div class="col-md-6">
			                			<div class="impact bottom-10">Inbound</div>
			                				{{#each inIList}}
			                                <div class="ess-tag bg-lightblue-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                		<div class="col-md-6">
			                			<div class="impact bottom-10">Outbound</div>
			                				{{#each outIList}}
			                                <div class="ess-tag bg-pink-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                	</div>
			                </div>
			                 
							</div>
						</div>
					</div>
				</script>
			 
				<script id="appmini-template" type="text/x-handlebars-template">
					<div class="scoreHolder">
					{{#each this.scores}}
						
						<div><xsl:attribute name="class">score {{this.id}}</xsl:attribute> 
							<xsl:attribute name="style">width:{{#getWidth ../this.scores}}{{/getWidth}}%;background-color:{{this.bgColour}};color:{{color}}</xsl:attribute>{{this.name}}
						</div>	
					{{/each}}
					</div>
                </script>
				<script id="quick-links-template" type="text/x-handlebars-template">
					{{#each this}}
						<a class="quick-link">
							<xsl:attribute name="href">#{{this.id}}</xsl:attribute>
							<div class="quick-link-label">{{this.name}}</div>
						</a>
					{{/each}}	
				</script>
                <script id="charts-template" type="text/x-handlebars-template">
				{{#each this}}
					<div class="ess-chart-wrapper">
						<xsl:attribute name="name">{{this.id}}</xsl:attribute>
						<div class="panel panel-default">
							<div class="panel-heading">
								<strong>{{this.name}}</strong>
								<div class="btt_link"><a href="#">back to top</a></div>
							</div>
							<div class="panel-body">
								<canvas width="800" height="450"><xsl:attribute name="id">{{this.id}}</xsl:attribute></canvas>
								<button class="btn btn-default btn-xs sendToPP">
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
									<i class="fa fa-share right-5"/>
									Send to PowerPoint
								</button>
							</div>
							 
						</div>
					</div>
				{{/each}}	
				</script>
                <script id="appsBox-template" type="text/x-handlebars-template">
                    {{#each this}}
                        <div class="appBox">
                        	<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                        	<xsl:attribute name="title">{{this.name}}</xsl:attribute>
                        	<div class="appBoxLabel">{{#essRenderInstanceLinkMenuOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}</div>
                        	<i class="fa fa-info-circle appInfoButton">
                        		<xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
						</div>
                    {{/each}}
                </script>

			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathPhysProc" select="$apiPhysProc"></xsl:with-param>   
                    
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathCaps"></xsl:param> 
        <xsl:param name="viewerAPIPathPhysProc"></xsl:param> 
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
        var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
		var viewAPIDataPhysProc = '<xsl:value-of select="$viewerAPIPathPhysProc"/>'; 
		var pres = new PptxGenJS();
		var selectedPPTCount =0;
 		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200){
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
							$('#ess-data-gen-alert').hide();
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
        }; 

	 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};

	//	var panelLeft=$('#appSidenav').position().left;
	let filtersNo=[<xsl:call-template name="GetReportFilterExcludedSlots"><xsl:with-param name="theReport" select="$theReport"></xsl:with-param></xsl:call-template>]

	let codebases;
    let codebaseLabels=[];
    let codebaseData=[];
    let codebaseColour=[];
    let codebaseTextColour=[];
    let deliveryLabels=[];
    let deliveryData=[];
    let deliveryColour=[];
    let lifecycleLabels=[];
    let lifecycleData=[];
    let lifecycleColour=[];
	let appArray=[];
    let meta=[];
    
    let busCapAppList=[];
    let thisNewChart;
    let thisDeliveryChart;
    let allCaps=[];
	let allApps=[]; 
	let filters=[];
		var level=0;
		var rationalisationList=[];
		let levelArr=[];
		let workingCapId=0;
		var partialTemplate, l0capFragment;
	var dynamicAppFilterDefs=[];	
	//	showEditorSpinner('Fetching Data...');
		$('document').ready(function ()
		{
             $('#busCaps').select2();
             
			appMiniFragment = $("#appmini-template").html();
			appMiniTemplate = Handlebars.compile(appMiniFragment);
			Handlebars.registerPartial('appMiniTemplate', appMiniTemplate);

			appFragment = $("#app-template").html();
			appTemplate = Handlebars.compile(appFragment);		

	 		appListFragment = $("#appList-template").html();
            appListTemplate = Handlebars.compile(appListFragment);
            
            appBoxFragment = $("#appsBox-template").html();
            appBoxTemplate = Handlebars.compile(appBoxFragment);

			quickLinksFragment = $("#quick-links-template").html();
			quickLinksTemplate = Handlebars.compile(quickLinksFragment);
            
            chartFragment = $("#charts-template").html();
            chartTemplate = Handlebars.compile(chartFragment);

			filtersFragment = $("#filters-template").html();
            filtersTemplate = Handlebars.compile(filtersFragment);
           

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});


			Handlebars.registerHelper('getApps', function(instance) {
			 
				let thisApps=workingArrayAppsCaps.filter((d)=>{
					return d.id ==instance.id
				});
			 
				let appHtml='';
				let appArr=[];

			});

			Handlebars.registerHelper('getColour', function(arg1) {
				let colour='#fff';

				if(parseInt(arg1) &lt;2){colour='#EDBB99'}
				else if(parseInt(arg1) &lt;6){colour='#BA4A00'}
				else if(parseInt(arg1) &gt;5){colour='#6E2C00'} 

				return colour; 
			});

		    const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
			function essGetMenuName(instance) {
		        let menuName = null;
		        if ((instance != null) &amp;&amp;
		            (instance.meta != null) &amp;&amp;
		            (instance.meta.classes != null)) {
		            menuName = instance.meta.menuId;
		        } else if (instance.classes != null) {
		            menuName = instance.meta.classes;
		        }
		        return menuName;
		    }

			Handlebars.registerHelper('essRenderInstanceLinkMenuOnly', function (instance, type) {
		 
		        let thisMeta = meta.filter((d) => {
		            return d.classes.includes(type)
				});
				  
				instance['meta'] = thisMeta[0]
			 
		        let linkMenuName = essGetMenuName(instance);
		        let instanceLink = instance.name;
		        if (linkMenuName != null) {
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		            let linkClass = 'context-menu-' + linkMenuName;
		            let linkId = instance.id + 'Link';
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(63, 63, 63) !important">' + instance.name + '</a>';
		            return instanceLink;
		        }
			});
			
			Handlebars.registerHelper('essRenderInstanceLinkMenuOnlyLight', function (instance, type) {
		 
		        let thisMeta = meta.filter((d) => {
		            return d.classes.includes(type)
				});
				  
				instance['meta'] = thisMeta[0]
			 
		        let linkMenuName = essGetMenuName(instance);
		        let instanceLink = instance.name;
		        if (linkMenuName != null) {
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		            let linkClass = 'context-menu-' + linkMenuName;
		            let linkId = instance.id + 'Link';
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(237, 237, 237)">' + instance.name + '</a>';

		            return instanceLink;
		        }
		    });
			

			$('.appPanel').hide();
	 
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
            promise_loadViewerAPIData(viewAPIDataCaps),
            promise_loadViewerAPIData(viewAPIDataPhysProc)  
			]).then(function (responses)
			{
			
                meta=responses[1].meta
                codebases=responses[1].codebase;
                deliveryModels=responses[1].delivery;
                lifecycleModels=responses[1].lifecycles;
				 filters=responses[1].filters;
				 
				 filtersNo.forEach((e)=>{
					filters=filters.filter((f)=>{
						return f.slotName !=e;
					})
				 })

				dynamicAppFilterDefs=filters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});

				//$('#filtersHolder').html(filtersTemplate(filters));
 
				$('#chartsArea').html(chartTemplate(filters));
				$('#chart-quick-links').html(quickLinksTemplate(filters));

				//$('.filters').select2();
				
                allApps=responses[1].applications
				appArray = allApps;
                let allPhys=responses[3] 
                allApps.forEach((d)=>{
                    let thisProc=[];
                    
                    d.physP.forEach((e)=>{
                        let thisMatch = allPhys.process_to_apps.find((f)=>{
                            return f.id ==e;
                        })
                        thisProc.push(thisMatch);
                    });
                    let uniqueProcs = thisProc.filter((elem, index, self) => self.findIndex( (t) => {return (t.processName === elem.processName)}) === index) 
                    d['processes']=uniqueProcs;
 
                    let thisCodebase=codebases.find((e)=>{
                        return e.id==d.codebaseID;
                    }) 
                    if(thisCodebase){
           
                    d['codebase']=thisCodebase.shortname
                    }
                    else{
                        d['codebase']='Not set'
                    }
                    let thisDelivery=deliveryModels.find((e)=>{
                        return e.id==d.deliveryID;
                    })  
                    if(thisDelivery){
           
                    d['delivery']=thisDelivery.shortname
                    }
                    else{
                        d['delivery']='Not set'
                    }
                    
                })

				$('.filters').on('change',function(){
					redrawView();
				});
				$('#appFilterBox').on('keyup',function(){
					let thisval=$(this).val();
					let newAppList=[]; 
					if(thisval==''){
						newAppList=allApps; 
					}
					else{
						newAppList=allApps.filter(item => item.name.toLowerCase().includes(thisval.toLowerCase())); 
					}
					$('#appBox').html(appBoxTemplate(newAppList))
				});
				appFilterBox

                busCapAppList = responses[0].busCaptoAppDetails;
                allCaps = responses[2].businessCapabilities;
 
                let optionHTML='';
                busCapAppList.forEach((d)=>{  
                    optionHTML=optionHTML+'&lt;option value='+d.id+' >'+d.name+'&lt;/option>';
                });
             $('#busCaps').append(optionHTML);
			//console.log('allApps',allApps)
             $('#appBox').html(appBoxTemplate(allApps))

            redraw(allApps)

             $('#busCaps').on('change',function(){
					redrawView();
			 })

			 essInitViewScoping	(redrawView,['Group_Actor', 'SYS_CONTENT_APPROVAL_STATUS'], filters);
	
			  
			}). catch (function (error)
			{
				//display an error somewhere on the page
			});
        })
 

function redraw(apps){
//do apps stuff
 
$('#appBox').html(appBoxTemplate(apps))

var appCount = d3.nest()
  .key(function(d) {return d.codebaseID})
  .entries(apps); 

}


var charts = [];
var chartData=[];
function drawChart(canvasId, type, labels, inputData, title, colours) {
	//console.log('canvasId',canvasId)
	//console.log('canvasId',type)
	//console.log('canvasId',labels)
	//console.log('canvasId',inputData)
 
	if(charts[canvasId]){charts[canvasId].destroy()};			
 	charts[canvasId] = new Chart(document.getElementById(canvasId), { type: 'doughnut',
                data: {
                  labels: labels ,
                  datasets: [
                    {
                      label: canvasId,
					  backgroundColor: colours,
					  //backgroundColor: ['#a6cee3','#1f78b4', '#b2df8a','#33a02c', '#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928'],
                      data: inputData
                    }
                  ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    legend: {
                        display: true,
                        position: 'bottom'
                        },
                    title: {
                        display: false,
                        text: title
                        },
                    plugins: {
                      labels: {
                        render: 'value'
                      },
                      
                    },
                  }
});

chartData[canvasId]=({"name":title, "values":inputData, "labels":labels, "colours":colours})

return (charts[canvasId] !== null);
}

$(document).on('click', '.appInfoButton',function ()
    {
        let selected = $(this).attr('easid')

        let appToShow =allApps.filter((d)=>{
            return d.id==selected;	
        });
 
        // let thisCaps = appToShow[0].caps.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index);
        // let thisProcesses = appToShow[0].processes.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index);
        let thisServs = appToShow[0].services.filter((elem, index, self) => self.findIndex(
                            (t) => {return (t.id === elem.id)}) === index);							
        //  appToShow[0]['capList']=thisCaps;
        //  appToShow[0]['processList']=thisProcesses;


		let appFilters=[];
		filters.forEach((d)=>{
			 <!-- hardcoded as these are already in the view, may want to remove another time -->
			if(d.name=='Codebase Status' || d.name=='Application Delivery Model'){}
			else{
			let appSlotMapped=appToShow[0][d.slotName];

			if(appSlotMapped){
				let thisVal=d.values.find((e)=>{
					return e.id==appSlotMapped[0]
				})
				if(thisVal){
					let nm=d.name[0].toUpperCase()+d.name.substring(1);
				appFilters.push({"name":nm, "value":thisVal})
					}
				}
			}
			});
		
				
		appToShow[0]['appFilters']=appFilters
        $('#appData').html(appTemplate(appToShow[0]));
 
        $('.appPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );

   
        $('.closePanelButton').on('click',function(){ 
            $('.appPanel').hide();
        })
    });

var redrawView=function(){
 
	let workingAppsList=[];
	let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
	let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
	let busDomainDef = new ScopingProperty('domainIds', 'Business_Domain');
	
	let apps=appArray;

	scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs));
 
	let selectedCap = $('#busCaps').val();
                
                 if(selectedCap =='All'){
                    
                 }
                 else{
                 let chosenCap = busCapAppList.find((d)=>{
                     return d.id == selectedCap;
				 }); 
			
                 let showApps=[];
                 chosenCap.apps.forEach((ap)=>{
                    let thisApp=scopedApps.resources.find((a)=>{
                        return a.id == ap;
					})
					
					if(thisApp){
						showApps.push(thisApp)
					}
                 });
				scopedApps.resources = showApps;
				}
		
				$('#appVal').text(scopedApps.resources.length)
				filters.forEach((d)=>{
					var filterCount = d3.nest()
					.key(function(e) {return e[d.slotName]}) 
					.entries(scopedApps.resources);
				 
					let labels=[];
					let labelcolours=[];
					let inputData=[];
					let missingBackgroundColour=['#a6cee3','#1f78b4', '#b2df8a','#33a02c', '#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928'];
                   
					filterCount.forEach((e,i)=>{  
					 
							let thisFilter=d.values.find((f)=>{return f.id==e.key})
						 
							if(thisFilter){
							labels.push(thisFilter.name +' ('+e.values.length+')'); 
							labelcolours.push(thisFilter.backgroundColor)
						 
							}
							else
							{labels.push('Not Set ('+e.values.length+')');
							labelcolours.push(missingBackgroundColour[i])
						 
							}
						 
							inputData.push(e.values.length)
							
						})
					 
					drawChart(d.id, 'doughnut', labels, inputData, d.name, labelcolours) 
					//console.log('chartData',  chartData);
					var COLORS_ACCENT = ["4472C4", "ED7D31", "FFC000", "70AD47"]; // 1,2,4,6
					var COLORS_SPECTRUM = ["56B4E4", "126CB0", "672C7E", "E92A31", "F06826", "E9AF1F", "51B747", "189247"]; // B-G spectrum wheel
					var COLORS_CHART = ["003f5c", "0077b6", "084c61", "177e89", "3066be", "00a9b5", "58508d", "bc5090", "db3a34", "ff6361", "ffa600"];
					var COLORS_VIVID = ["ff595e", "F38940", "ffca3a", "8ac926", "1982c4", "5FBDE1", "6a4c93"]; // (R, Y, G, B, P)
					$('.sendToPP').off().on('click', function(){

						let filt=[]
						let filterText=' (';
						$('.ess-scope-blob-label').each(function(){
							filt.push($( this ).text())
							filterText=filterText+$( this ).text()+', ';
						});
				 
						filterText=filterText.slice(0, -2)+')';

						if(filterText.length&lt;4){
							filterText=''
						}

						$(this).addClass('sentToPowerPoint');
						$(this).addClass('btn-success');
						selectedPPTCount = selectedPPTCount+1;
						$('#generate').children('span').html(' ('+selectedPPTCount+')');
				
						let slide = pres.addSlide();
						selected=$(this).attr('easid');
						let clrs=[]
						chartData[selected].colours.forEach((c)=>{
							clrs.push(c.slice(1))
						})
						
						
						
						let labelClean=[];
						chartData[selected].labels.forEach((e)=>{
							labelClean.push(e)
						})
						chartData[selected].labels=labelClean;
 
						slide.addChart(pres.ChartType.doughnut, [chartData[selected]], { 
							x: 0.2,
							y: 0.2,
							w: "95%",
							h: "90%",
							name: "Apps by Codebase",
							chartArea: { fill: { color: "F1F1F1" } },
							chartColors: clrs,
							//
							legendPos: "l",
							legendFontFace: "Courier New",
							showLegend: true,
							//
							showLeaderLines: true,
							showPercent: false,
							showValue: true,
							dataLabelColor: "000000",                        
							showTitle: true,    
							title: chartData[selected].name + filterText,
							dataLabelFontSize: 12,
							dataLabelPosition: "bestFit", // 'bestFit' | 'outEnd' | 'inEnd' | 'ctr' 
							}) 
					})

					$('#generate').off().on('click', function(){
						pres.writeFile({ fileName: "Essential Presentation.pptx" });
					})
				})
 

 redraw(scopedApps.resources)
 
    $(".appInfoButton").on("click", function ()
    {
        let selected = $(this).attr('easid')
 
        let appToShow =allApps.filter((d)=>{
            return d.id==selected;	
        });

       let thisServs = appToShow[0].services.filter((elem, index, self) => self.findIndex(
                            (t) => {return (t.id === elem.id)}) === index);							
 
        appToShow[0]['servList']=thisServs; 	 
 
        $('#appData').html(appTemplate(appToShow[0]));
 
        $('.appPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
 
        $('.closePanelButton').on('click',function(){ 
            $('.appPanel').hide();
        })
    });
 
    }
function applyFilters(apps){
		filters.forEach((d)=>{
		apps.resources.forEach((ap)=>{

		 
			let thisEnum = ap.enums.find((e)=>{
				return d.name==e.type;
			})
		 
		})
 
	})
		return apps
}
function getApps(capid){
	 
	let thisCapAppList = inScopeCapsApp.filter(function (d)
	{
		return d.id == capid;
	});
   
	appsToShow['applications']=scopedApps.resources;
	
	let filteredApps = thisCapAppList[0].apps.filter((id) => scopedApps.resourceIds.includes(id));

	let test = thisCapAppList[0].apps.filter((id) => scopedApps.resourceIds.includes(id));
	
	let appArrayToShow=[];
	filteredApps.forEach((app)=>{
		let anApp=appArray.applications.filter((d)=>{
			return d.id ==app;
		})
		
		appArrayToShow.push(anApp[0]);
	})

	let panelData=[];
		panelData['apps']=appArrayToShow;
		let capName=inScopeCapsApp.filter((d)=>{return d.id==capid})
		panelData['cap']=capid;
		panelData['capName']=capName[0].name; 

panelData.apps.forEach((d)=>{
	let capsList = d.caps.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
	d['capsList']=capsList;
	let processList = d.processes.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
	d['processList']=processList;
})

		$('#appData').html(appTemplate(panelData));

	workingAppsList=appArrayToShow;

	$('#appsList').empty();
	$('#appsList').html(appListTemplate(panelData))
	openNav(); 
	thisCapAppList[0].apps.forEach((d)=>{ 
		rationalisationList.push(d)
	});
    }
    
 

function redrawView() {
	essRefreshScopingValues()
}




		function openNav()
		{	
			document.getElementById("appSidenav").style.marginRight = "0px";
		}
		
		function closeNav()
		{
			workingCapId=0;
			document.getElementById("appSidenav").style.marginRight = "-352px";
		}
	
		/*Auto resize panel during scroll*/
		$('window').scroll(function() {
			if ($(this).scrollTop() &gt; 40) {
				$('#appSidenav').css('position','fixed');
				$('#appSidenav').css('height','calc(100%)');
				$('#appSidenav').css('top','0');
			}
			if ($(this).scrollTop() &lt; 40) {
				$('#appSidenav').css('position','fixed');
				$('#appSidenav').css('height','calc(100% - 40px)');
				$('#appSidenav').css('top','41px');
			}
		});

		$('.closePanel').slideDown();
		
		function toggleMiniPanel(element){
			$(element).parent().parent().nextAll('.mini-details').slideToggle();
			$(element).toggleClass('fa-caret-right');
			$(element).toggleClass('fa-caret-down');
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

 
</xsl:stylesheet>
