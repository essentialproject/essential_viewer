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

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Application_Service', 'Business_Process', 'Project', 'Enterprise_Strategic_Plan')"></xsl:variable>
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
	<xsl:variable name="allRoadmapInstances" select="$apps"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>	
	 
	-->
	<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Project','Enterprise_Strategic_Plan')]"></xsl:variable>

  <xsl:variable name="planElements" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']"/>
    <xsl:variable name="planningAction" select="/node()/simple_instance[type = 'Planning_Action']"/>
    <xsl:variable name="relatedAppPlans" select="/node()/simple_instance[type = 'Project'][name=$planElements/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
    <xsl:variable name="relatedAppStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][name=$planElements/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="procListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
	<xsl:variable name="logicalprocListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes to App Services']"></xsl:variable>
	<xsl:variable name="appToServiceData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"></xsl:variable>
	
	
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
		<xsl:variable name="apiProcs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$procListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiLogicalProcs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$logicalprocListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>	 
 		<xsl:variable name="apiApptoServices">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appToServiceData"></xsl:with-param>
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
				<script src="js/d3/d3_4-11/d3.min.js"/>
				<title>Business Capability Model</title>
				<style>					
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
					
					.appBox{
						border-radius: 4px;
						margin-bottom: 10px;
						float: left;
						width: 100%;
						border: 1px solid #333;
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
						bottom: 5px;
						right: 5px;
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
						right: 3px;
						bottom: 3px;
						 
					}
					.app-circle-more {
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
						right: 3px;
						bottom: 3px;
						 
					}
					.bc-eye{
						display: inline-block;
						min-width: 8px;
						padding: 2px 2px;
						font-size: 9px;
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
						left: 3px;
						bottom: 3px;
					}
					.bc-eye:hover {
						background-color: #333;
						color: #fff;
						cursor: pointer;
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
					.appblobs{
						display:inline-block;
						border:1pt solid #d3d3d3;
						border-radius:4px;
						height:35px; 
						background-color:white;
						padding:3px;
						font-size:0.9em
                    }
                    .node circle{
						fill: #fff;
						stroke: steelblue;
						stroke-width: 3px;
					}
					
					.node text{
						font: 10px sans-serif;
					}
					
					.link{
						fill: none;
						stroke: #ccc;
						stroke-width: 2px;
					}
					.rectIcon{
						position: absolute;
						bottom:3px;
						right:3px;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Capability Tree')"/></span>
								
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
						<div class="col-xs-12" id="keyHolder">
								Business Capability:<select id="caps"></select>
						</div>

						<div id="model"/>
					
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
						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="appPanel" id="appPanel">
						<div id="appData"></div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

				<!-- caps template -->
			 
 
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
	            			<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>
	            			<!--<div class="ess-tag ess-tag-default"><i class="fa fa-money right-5"/>Cost: {{costValue}}</div>
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
		                			</div>
								</div>
								<div id="capabilities" class="tab-pane fade">
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
								<div id="processes" class="tab-pane fade">
									<p class="strong">This application supports the following Business Processes, supporting {{processList.length}} processes:</p>
									<div>
									{{#if processes}}
									{{#each processList}}
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
				<script id="appBlob-template" type="text/x-handlebars-template">
					{{#each this}}
						<div class="appblobs"  ><xsl:attribute name="appLevel">{{this.level}}</xsl:attribute>{{this.name}}</div>
					{{/each}}
				</script>

				<script id="divBox-template" type="text/x-handlebars-template">
					<b>{{#if this.type}}{{#ifEquals this.type 'Application_Provider_Role'}}{{this.name}}{{else}}{{#essRenderInstanceLinkMenuOnly this type}}{{/essRenderInstanceLinkMenuOnly}}{{/ifEquals}}{{else}}{{this.name}}{{/if}}</b><br/>
					<span style="font-size:5pt">{{this.type}}</span>
					{{#ifEquals this.type 'Business_Capability'}}{{#if this.children}}{{else}}<span class="bc-eye"><i class="fa fa-eye"><xsl:attribute name="id">{{this.id}}</xsl:attribute></i></span>{{/if}}{{/ifEquals}}
						{{#if this.children}} 
							<span class="app-circle"><i class="fa fa-caret-right"></i></span>
						{{/if}}

				</script>

				<script id="appScore-template" type="text/x-handlebars-template">
					{{#each this}}
						{{#ifEquals this.level "0"}}
						<div><xsl:attribute name="class">appInDivBoxL0 appL{{this.level}}</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}
							{{> appMiniTemplate}}</div>
						{{else}}
						<div><xsl:attribute name="class">appInDivBox appL{{this.level}}</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}
							{{> appMiniTemplate}}</div>
						{{/ifEquals}}
					{{/each}}
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
				<script id="keyList-template" type="text/x-handlebars-template">
					{{#each this}}
						<div class="scoreKeyHolder"><b>{{this.name}}</b> <input type="checkbox" class="measures" checked="true"><xsl:attribute name="id">{{this.id}}</xsl:attribute></input>
								{{#each this.sqvs}}
								<div class="scoreKey"> 
										<xsl:attribute name="style">background-color:{{this.elementBackgroundColour}};color:{{elementColour}}</xsl:attribute>{{this.value}}
								</div> 
								{{/each}}
						</div>	
					{{/each}}
				</script>	
		
				
			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathProcs" select="$apiProcs"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathLogicalProcs" select="$apiLogicalProcs"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathApp2Servcs" select="$apiApptoServices"></xsl:with-param> 
					 		
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathProcs"></xsl:param> 
		<xsl:param name="viewerAPIPathLogicalProcs"></xsl:param> 
  		<xsl:param name="viewerAPIPathApp2Servcs"></xsl:param> 
		
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataProcs = '<xsl:value-of select="$viewerAPIPathProcs"/>'; 
		var viewAPIDataLogicalProcs = '<xsl:value-of select="$viewerAPIPathLogicalProcs"/>'; 
 		var viewAPIApp2Servcs= '<xsl:value-of select="$viewerAPIPathApp2Servcs"/>'; 
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


let plans=[<xsl:apply-templates select="$planElements" mode="plans"/>]
//console.log('plans',plans)

		var panelLeft=$('#appSidenav').position().left;
		 
		var level=0;
		var rationalisationList=[];
		let levelArr=[];
		let workingArray=[];
		let workingCapId=0;
		var partialTemplate, l0capFragment;
		showEditorSpinner('Fetching Data...');
		$('document').ready(function ()
		{
			
$('#caps').select2({width:"250px"})

let focusCap='<xsl:value-of select="$param1"/>'
			appFragment = $("#app-template").html();
			appTemplate = Handlebars.compile(appFragment);		
			
			divBoxFragment = $("#divBox-template").html();
			divBoxTemplate = Handlebars.compile(divBoxFragment);
			
			appListFragment = $("#appList-template").html();
			appListTemplate = Handlebars.compile(appListFragment);

			appScoreFragment = $("#appScore-template").html();
			appScoreTemplate = Handlebars.compile(appScoreFragment);


			Handlebars.registerHelper('getLevel', function(arg1) {
				return parseInt(arg1) + 1; 
			});

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
			
			Handlebars.registerHelper('getWidth', function(sclen) {
				 
				return (100/sclen.length)-2;
			});

			Handlebars.registerHelper('getApps', function(instance) { 
				let thisApps=workingArrayAppsCaps.filter((d)=>{
					return d.id ==instance.id
				});
	 
			 let appArr=[];
			 // apply filter on tco rank here
			 if(thisApps[0].apps){
			 thisApps[0].apps.forEach((d)=>{
					let theApp = appArray.applications.find((e)=>{
						return e.id == d;
					});
					theApp['level']=instance.level
					appArr.push(theApp)
				})
			}
 
				
				return appblobTemplate(appArr);
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
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(63, 63, 63)">' + instance.name + '</a>';

		            return instanceLink;
		        }
			});
let projmeta = [<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>];			
var aprToProj
			$('.appPanel').hide();
			var appArray;
			var workingArrayCaps;
			var workingArrayAppsCaps;
			var appToCap=[];
			var processMap=[];
			var scores=[];
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataProcs),
			promise_loadViewerAPIData(viewAPIDataLogicalProcs),
			promise_loadViewerAPIData(viewAPIApp2Servcs)
		//	promise_loadViewerAPIData(viewAPIScores)
			]).then(function (responses)
			{
				 
				workingArray = responses[0];
			  
				meta = responses[1].meta; 
				projmeta.forEach((d)=>{
					meta.push(d)
				})
 
				workingArray.busCapHierarchy.sort(function (a, b) {   
					return a.position - b.position || a.order - b.order;
				});
				
				let selectHTML='';
				for (var i = 0; i &lt; workingArray.busCaptoAppDetails.length; i++) {
					workingArray.busCaptoAppDetails[i]['type']="Business_Capability";
					
					selectHTML=selectHTML+'&lt;option value="'+workingArray.busCaptoAppDetails[i].id+'">'+workingArray.busCaptoAppDetails[i].name+'&lt;/option>'
				}
				$('#caps').append(selectHTML)	
				$("#caps").html($("#caps option").sort(function (a, b) {
					return a.text == b.text ? 0 : a.text &lt; b.text ? -1 : 1
				}))

				$("#caps").prop("selectedIndex", 0).val();
$("#caps").val('Choose');
 
$('#caps').on('change',function(){
	let focus=$('#caps').val() 
	d3.select("#model").select("svg").remove(); 
	selectedCap(focus)
})

if(focusCap.length&gt;0){
	//selectedCap(focusCap);
	$('#caps').val(focusCap).trigger('change'); 
 }

function selectedCap(focus){
let thisCap = workingArray.busCaptoAppDetails.find((d)=>{
    return d.id==focus;
});
 
 
let treeData=[];
function dfs(obj, targetId){
 
    if (obj.id === targetId){
     return obj 
       }
    if (obj.childrenCaps){  
     for (let item of obj.childrenCaps){
        let check = dfs(item, targetId)
        if (check){  
         return check
               }
                 }
                }
    return null
            } 

 let result = null;
 
 for (let obj of workingArray.busCapHierarchy){
 
    result = dfs(obj, focus)
    if (result){ 
     break
       }
	}  
    let directApps =[]; 
thisCap.processes.forEach((d)=>{
	d['type']="Business_Process"
    let thisProc = responses[2].process_to_apps.find((e)=>{
        return e.processid == d.id;
    });
	 
 
if(thisProc){
 
	if(thisProc.appsdirect.length&gt;0){
	thisProc.appsdirect.forEach((s)=>{ 
 
		let match = responses[1].applications.find((el)=>{
			return el.id == s.id
		})   
			if(match){
				s['children']=match.children
				s['type']='Composite_Application_Provider'
			} 
 
		});
	}
}
 
if(thisProc){

	thisProc.appsviaservice.forEach((s)=>{
 	s['type']="Application_Provider_Role";
	 let relatedPlans=plans.filter((ap)=>{
		return ap.impacting==s.id;
				}) 				
			let thisPlans=[];
			let thisProjs=[];
			relatedPlans.forEach((e)=>{
			if(e.plans[0]){

			//e.plans[0]['children']=e.plans[0]
			thisPlans.push(e.plans[0])
			}
			});
			thisPlans=thisPlans.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)

			relatedPlans.forEach((e)=>{
			if(e.projects[0]){
			thisProjs.push(e.projects[0])
			}
			})

			thisProjs=thisProjs.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
			
   	aprToProj=[{"name":"Plans", "colour":"#A3E4D7", "children": thisPlans},{"name":"Projects", "colour":"#A9DFBF", "children": thisProjs}]   
 	//console.log('aprToProj1',aprToProj)
	let appViaProc=[];
	for (let el of responses[1].applications) { 
 
			let match = el.allServices.find((e)=>{
				return e.id == s.id;
			}) 
		 
			el['type']='Composite_Application_Provider';

			if(match){
				appViaProc.push(el)
			}
		} 
		s['test']='test';
		let aprKids=appViaProc
		if(aprToProj){ 
			aprKids=[...appViaProc, ...aprToProj]
			} 
		s['children']=aprKids;
	}); 
	let thisProcServices = responses[3].process_to_service.find((ps)=>{
		return d.id == ps.id
	})
 
thisProcServices['children']=thisProcServices.services
thisProcServices.children.forEach((s)=>{
 	s['type']='Application_Service';
	let bpsvc=[];
	for (let el of responses[4].applications_to_services) { 

		let match = el.services.find((e)=>{
			return e.id == s.id;
		}) 
		
		if(match){
			el['type']="Composite_Application_Provider";
			bpsvc.push(el)
		}
	}
 
	s['children']=[{"name":"Apps Providing", "colour":"#F0E3AC","children": bpsvc}]
	  
});
 
let aprsAndPojects=thisProc.appsviaservice

	 

    d['children']=[{"name":"Services Required", "colour":"#3d85c6", 
	"children": thisProcServices.services},{"name":"Direct Apps", "colour":"#EAC7F5", 
	"children": thisProc.appsdirect},{"name":"Apps via Services", "colour":"#95C9F7", "children": aprsAndPojects}]
} 
})


treeData.push({"id": result.name,"name":result.name,"type":"Business_Capability", "children":[{"name":"Sub-Capabilities", "colour":"#90afa2", "children": result.childrenCaps},{"name":"Processes", "colour":"#7cc4cf", "children": thisCap.processes}]}) 

//console.log('treeData',treeData)
         
treeData=treeData[0];


let colours=[{"name":"Sub-Capabilities", "colour":"#90afa2"},
	{"name":"Business_Capability", "colour":"#90afa2"},
	{"name":"Processes", "colour":"#7cc4cf"},
	{"name":"Business_Process", "colour":"#7cc4cf"},
	{"name":"Direct Apps", "colour":"#67af94"},
	{"name":"Apps via Services", "colour":"rgb(203 193 170)"},
	{"name":"Apps Providing", "colour":"#d6cabf"},
	{"name":"Services Required", "colour":"#20c4f4"},
	{"name":"Service", "colour":"#20c4f4"},
	{"name":"APR", "colour":"#20c4f4"},
	{"name":"Application", "colour":"lightsteelblue"},
	{"name":"Plans", "colour":"#A3E4D7"},
	{"name":"Enterprise_Strategic_Plan", "colour":"#A3E4D7"},
	{"name":"Projects", "colour":"#A9DFBF"},
	{"name":"Composite_Application_Provider", "colour":"#bfc3d6"},
	{"name":"Application_Service", "colour":"#20c4f4"}
	]
	
// Set the dimensions and margins of the diagram
 
			var margin = {top: 20, right: 90, bottom: 30, left: 120},
				width = $(window).width() - margin.left - margin.right,
				height = 700 - margin.top - margin.bottom;
			
			// append the svg object to the body of the page
			// appends a 'group' element to 'svg'
			// moves the 'group' element to the top left margin
		
			var svg = d3.select("#model").append("svg")
				.attr("width", width + margin.right + margin.left)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate("
						+ margin.left + "," + margin.top + ")");
			
			var i = 0,
				duration = 750,
				root;
			
			// declares a tree layout and assigns the size
			var treemap = d3.tree().size([height, width]);
			
			// Assigns parent, children, height, depth
			root = d3.hierarchy(treeData, function(d) { return d.children; });
			root.x0 = height / 2;
			root.y0 = 0;
		
			// Collapse after the second level
			root.children.forEach(collapse);
		
			update(root);
			
			// Collapse the node and all it's children
			function collapse(d) {
				if(d.children) {
				d._children = d.children
				d._children.forEach(collapse)
				d.children = null
				}
			}
			
			function update(source) {
			
				// Assigns the x and y position for the nodes
				var treeData = treemap(root);
			
				// Compute the new tree layout.
				var nodes = treeData.descendants(),
					links = treeData.descendants().slice(1);
			
				// Normalize for fixed-depth.
				nodes.forEach(function(d){ d.y = d.depth * 180});
			
				// ****************** Nodes section ***************************
			
				// Update the nodes...
				var node = svg.selectAll('g.node')
					.data(nodes, function(d) {return d.id || (d.id = ++i); });
			
				// Enter any new modes at the parent's previous position.
				var nodeEnter = node.enter().append('g')
					.attr('class', 'node')
					.attr("transform", function(d) {
					return "translate(" + source.y0 + "," + source.x0 + ")";
				})
				.on('click', click);
			
				// Add Circle for the nodes
				
				nodeEnter.append('foreignObject')
					.attr("x", -85)
					.attr("y", -25)
					.attr("width", 100)
					.attr("height", 50) 
					.style('background-color',function(d){
						let fillcolour;
					
					if(d.data.colour){
				 
						let thisColour=colours.filter((e)=>{
							return e.name == d.data.name;
						})
						if(thisColour.length&gt;0){}else{
							 thisColour=colours.filter((e)=>{
								return e.name == d.data.type;
							})
						}				 
						if(thisColour.length&gt;0){
				 
						fillcolour = thisColour[0].colour ;
 
					if(d.data.children){
						d.data.children.forEach((ch)=>{
							ch['colour']=thisColour[0].colour;
						})
						}

						}
						else if(d.parent.data.colour){
							fillcolour= d.parent.data.colour
						}
						else{
							fillcolour = '#d3d3d3';
						}
						}
						else{
						fillcolour = "lightsteelblue" 
						
						}
					
						return fillcolour ;
					})
					.style('border-radius','5pt')
					.style('box-shadow', '2px 2px 4px #d3d3d3')
					.style('padding','3pt')
					.style('font-size','0.8em')
					.style('line-height', '80%')
					.html(function(d) {  
			 
						 return divBoxTemplate(d.data);
						 
					})
					 
					.style("fill", function(d) {
					let fillcolour;
					
					if(d.data.colour){
 
						let thisColour=colours.filter((e)=>{
							return e.name == d.data.name;
						})
			 
						if(thisColour.length&gt;0){
						fillcolour = thisColour[0].colour ;
						}
						else if(d.parent.data.colour){
							fillcolour= d.parent.data.colour
						}
						else{

							fillcolour = '#d3d3d3';
						}
						}
						else{
						fillcolour = "lightsteelblue" 
						
						}
					
						return d._children ? fillcolour : "#fff";
						
						})
					.style("stroke", function(d){
					return d.data.colour; })    
					;
				
				
			
				/*Add labels for the nodes
				nodeEnter.append("foreignObject")
					.attr("x", -30)
					.attr("y", 10)
					.attr("width", 150)
					.attr("height", 30) 
					.style("font", "10px 'Helvetica Neue'")
					.html(function(d) { return d.data.name})
					.on("mouseover", handleMouseOver)
					.on("mouseout", handleMouseOut);
				;
				*/
			
				// UPDATE
				var nodeUpdate = nodeEnter.merge(node);
			
				// Transition to the proper position for the node
				nodeUpdate.transition()
				.duration(duration)
				.attr("transform", function(d) { 
					return "translate(" + d.y + "," + d.x + ")";
					});
			
				// Update the node attributes and style
				nodeUpdate.select('circle.node')
				.attr('r', 10)
				.style("fill", function(d) {
					let fillcolour;
					if(d.data.colour){
				 
						let thisColour=colours.filter((e)=>{
							return e.name == d.data.name;
						})

						fillcolour = thisColour[0].colour ;
						}
						else{
						fillcolour = "lightsteelblue" 
						
						}
						return d._children ? fillcolour : "#fff";
						
				})
				.attr('cursor', 'pointer');
			
				// handle mouse events
				function handleMouseOver(d, i) {  // Add interactivity
							d3.select(this).attr("dy", -35)
							d3.select(this).style("font-size","12px");
						}
			
					function handleMouseOut(d, i) {
						d3.select(this).attr("dy", -15)
						d3.select(this).style("font-size","10px");;
						}
				
				
				// Remove any exiting nodes
				var nodeExit = node.exit().transition()
					.duration(duration)
					.attr("transform", function(d) {
						return "translate(" + source.y + "," + source.x + ")";
					})
					.remove();
			
				// On exit reduce the node circles size to 0
				nodeExit.select('circle')
				.attr('r', 6);
			
				// On exit reduce the opacity of text labels
				nodeExit.select('text')
				.style('fill-opacity', 1e-6);
				
				
									
				// ****************** links section ***************************
			
				// Update the links...
				var link = svg.selectAll('path.link')
					.data(links, function(d) { return d.id; });
				
				// Enter any new links at the parent's previous position.
				var linkEnter = link.enter().insert('path', "g")
					.attr("class", "link")
					.attr('d', function(d){
						var o = {x: source.x0, y: source.y0}
						return diagonal(o, o)
					});
				
				// UPDATE
				var linkUpdate = linkEnter.merge(link);
				
				// Transition back to the parent element position
				linkUpdate.transition()
					.duration(duration)
					.attr('d', function(d){ return diagonal(d, d.parent) });
				
				// Remove any exiting links
				var linkExit = link.exit().transition()
					.duration(duration)
					.attr('d', function(d) {
						var o = {x: source.x, y: source.y}
						return diagonal(o, o)
					})
					.remove();
				
				// Store the old positions for transition.
				nodes.forEach(function(d){
					d.x0 = d.x;
					d.y0 = d.y;
				});
				
				// Creates a curved (diagonal) path from parent to the child nodes
				function diagonal(s, d) {
				
					path = `M ${s.y} ${s.x}
							C ${(s.y + d.y) / 2} ${s.x},
							${(s.y + d.y) / 2} ${d.x},
							${d.y} ${d.x}`
				
					return path
				}
				
				// Toggle children on click.
				function click(d) {
					//console.log('d',d)
					if (d.children) {
						d._children = d.children;
						d.children = null;
					} else {
						d.children = d._children;
						d._children = null;
					}
					update(d);
				}
				$('.fa-eye').on('click',function(){
					let selectedID = $(this).attr('id');
					$('#caps').val(selectedID).trigger('change');
				})	
				}

				
			}			
				rationReport=responses[1].reports.filter((d)=>{return d.name=='appRat'});
			//	scores = responses[2];
	 	     

				 let checkkey= false;
 
			//	console.log(checkkey);
				if(checkkey){$('#pmKey').show()}
				else{
					$('#pmKey').hide()
				}
			 
			 	getArrayDepth(workingArray.busCapHierarchy);
				 workingArrayAppsCaps=workingArray.busCaptoAppDetails
				 let appUpdateMod = new Promise(function(resolve, reject) { 
					resolve(appArray = responses[1]);
					 reject();
				})
 
				appUpdateMod.then(function(){
 
					level=Math.max(...levelArr);
					levelArr=[];
					for(i=0;i&lt;level+1;i++){  
						levelArr.push({"level":i+1});	 
					}
				
				codebase=appArray.codebase;
				delivery=appArray.delivery;
				lifecycles=appArray.lifecycles;
	 			
				 appArray.applications.forEach((d)=>{
				 	let relatedPlans=plans.filter((ap)=>{
					 	return ap.impacting==d.id;
					 }) 
let thisPlans=[];
let thisProjs=[];
relatedPlans.forEach((e)=>{
	if(e.plans[0]){
		 
		//e.plans[0]['children']=e.plans[0]
		thisPlans.push(e.plans[0])
	}
});
thisPlans=thisPlans.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
 
relatedPlans.forEach((e)=>{
	if(e.projects[0]){
		thisProjs.push(e.projects[0])
	}
})
 
thisProjs=thisProjs.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
				
					d['children']=[{"name":"Plans", "colour":"#A3E4D7", "children": thisPlans},{"name":"Projects", "colour":"#A9DFBF", "children": thisProjs}]   
					let thisCode=codebase.find((e)=>{
						return e.id == d.codebaseID
					});
		
					if(d.codebaseID.length&gt;0){
					d['codebase']=thisCode.shortname;
					d['codebaseColor']=thisCode.colour;
					d['codebaseText']=thisCode.colourText;
					}
					else
					{
						d['codebase']="Not Set";
						d['codebaseColor']="#d3d3d3";
						d['codebaseText']="#000";
					}
				 
					let thisLife=lifecycles.find((e)=>{
						return e.id == d.lifecycle;
					})
					if(d.lifecycle.length&gt;0){
					d['lifecycle']=thisLife.shortname;
					d['lifecycleColor']=thisLife.colour;
					d['lifecycleText']=thisLife.colourText;
					}
					else
					{
						d['lifecycle']="Not Set";
						d['lifecycleColor']="#d3d3d3";
						d['lifecycleText']="#000";
					}

					let thisDelivery=delivery.find((e)=>{
						return e.id == d.deliveryID;
					});
					if(d.deliveryID.length&gt;0){
						d['delivery']=thisDelivery.shortname;
						d['deliveryColor']=thisDelivery.colour;
						d['deliveryText']=thisDelivery.colourText;
						}
						else
						{
							d['delivery']="Not Set";
							d['deliveryColor']="#d3d3d3";
							d['deliveryText']="#000";
						}	
					
						d.orgUserIds = d.orgUserIds.filter((elem, index, self) => self.findIndex( (t) => {return (t === elem)}) === index)
				 });
		 
				//create paired arrays
 
				essInitViewScoping(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain']);
			 
			   removeEditorSpinner()
			   $('.appInDivBoxL0').hide();
			   $('.appInDivBox').hide();

			})
		 
	
			}). catch (function (error)
			{
				//display an error somewhere on the page
			});
			
			let scopedApps=[]; 	
			let inScopeCapsApp=[];
			let scopedCaps=[];

var redrawView=function(){
	workingCapId=0;
	let workingAppsList=[];
	let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
	let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
	let busDomainDef = new ScopingProperty('domainIds', 'Business_Domain');
	
	
	let apps=appArray.applications;
 
	scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef]);
	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef]);
	let appsToShow=[]; 
 
	inScopeCapsApp=scopedCaps.resources; 
 
	let capSelectStyle= $('#hideCaps').text(); 
	if(capSelectStyle=='Hide'){
	 	localStorage.setItem("essentialhideCaps", "Hide");
	$('.buscap').hide();
	inScopeCapsApp.forEach((d)=>{
		$('div[eascapid="'+d.id+'"]').parents().show();
		$('div[eascapid="'+d.id+'"]').show();
	 
		});
	}else
	{	 
		localStorage.setItem("essentialhideCaps", "Show");
		$('.buscap').show(); 
		$('.buscap').addClass("off-cap")
		inScopeCapsApp.forEach((d)=>{
		 
			 $('div[eascapid="'+d.id+'"]').removeClass("off-cap");
		 
			});
	}

	let appMod = new Promise(function(resolve, reject) { 
	 	resolve(appsToShow['applications']=scopedApps.resources);
		 reject();
	});

	appMod.then((d)=>{

		inScopeCapsApp.forEach((d)=>{ 
			let filteredAppsforCap = d.apps.filter((id) => scopedApps.resourceIds.includes(id));
			d['filteredApps']=	filteredAppsforCap;
			
		})
		
		appsToShow.applications.forEach((d)=>{
	
			let procsForApp =[]; 
			let capforApp=[];
			d.physP.forEach((pp)=>{ 
				 processMap.forEach((php)=>{
				 
					if(php.pbpId ==pp)
					{
						procsForApp.push({"id":php.prId,"name":php.pr})
						let cap=appToCap.filter((ac)=>{
							return ac.procId ==php.prId;
						});

						if(cap.length &gt;0){
						capforApp.push({"id":cap[0].bcId,"name":cap[0].bc})
						}
					};
				});
				let uniqueProcs = [...new Set(procsForApp)];
				let uniqueCaps = [...new Set(capforApp)];
				d['processes']=uniqueProcs;
				d['caps']=uniqueCaps;
			});
			 
				 
		})	

	}).then((e)=>{
		let panelPos=$('#appSidenav').position().left
 
		if(parseInt(panelPos)+50 &lt;panelLeft){

			let openCap= $('#capsId').attr('easid');
			 getApps(openCap)
		}
<!--
	$('.app-circle').on("click", function (d)
		{ d.stopImmediatePropagation(); 

				let selected = $(this).attr('easidscore')
 
				if(workingCapId!=selected){ 
			//console.log('selected',selected)
				getApps(selected);

				$(".appInfoButton").on("click", function ()
				{//console.log('appinfo',selected)
					let selected = $(this).attr('easid')

		 
					let appToShow =workingAppsList.filter((d)=>{
						return d.id==selected;	
					});

					let thisCaps = appToShow[0].caps.filter((elem, index, self) => self.findIndex(
								(t) => {return (t.id === elem.id)}) === index);
					let thisProcesses = appToShow[0].processes.filter((elem, index, self) => self.findIndex(
									(t) => {return (t.id === elem.id)}) === index);
					let thisServs = appToShow[0].services.filter((elem, index, self) => self.findIndex(
										(t) => {return (t.id === elem.id)}) === index);							
					appToShow[0]['capList']=thisCaps;
					appToShow[0]['processList']=thisProcesses;
					appToShow[0]['servList']=thisServs; 	 

					//console.log(appToShow[0])
					$('#appData').html(appTemplate(appToShow[0]));
					$('.appPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );

					//$('#appModal').modal('show');
					$('.closePanelButton').on('click',function(){ 
						$('.appPanel').hide();
					})
				});

				var thisf=$('*').filter(function() {
					return $(this).data('level') !== undefined;
				});

				$(".saveApps").on('click', function(){
					var apps={};
					apps['Composite_Application_Provider']=rationalisationList;
					sessionStorage.setItem("context", JSON.stringify(apps));
					location.href='report?XML=reportXML.xml&amp;XSL='+rationReport[0].link+'&amp;PMA=bcm'
				});
				workingCapId=selected;
			}
			else
			{	 
				closeNav();
				
			}
		})-->


function getApps(capid){
	 //console.log('capid',capid)
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
 
		$('#appData').html(appTemplate(panelData));

	workingAppsList=appArrayToShow;

	$('#appsList').empty();
	$('#appsList').html(appListTemplate(panelData))
	openNav(); 
	thisCapAppList[0].apps.forEach((d)=>{ 
		rationalisationList.push(d)
	});
	}
 	//console.log('set app circle to 0')
	//$('.app-circle').text('0')
	/*	$('.app-circle').each(function() {
			$(this).html() &lt; 2 ? $(this).css({'background-color': '#e8d3f0', 'color': 'black'}) : null;
		  
			($(this).html() >= 2 &amp;&amp; $(this).html() &lt; 6) ? $(this).css({'background-color': '#e0beed', 'color': 'black'}): null;
		  
			$(this).html() >= 6 ? $(this).css({'background-color': '#d59deb', 'color': 'black'}) : null;
		  });
	*/
		/*  inScopeCapsApp.forEach(function (d)
		{
			let appCount=d.filteredApps.length;
			$('*[easidscore="' + d.id + '"]').html(appCount);
			let colour='#fff';
			let textColour='#fff';
			if(appCount &lt;2){colour='#EDBB99'} 
			else if(appCount &lt;6){colour='#BA4A00'} 
			else{colour='#6E2C00'}
			$('*[easidscore="' + d.id + '"]').css({'background-color':colour, 'color':textColour})
	
		});
		*/ 
	})


	
}

function redrawView() {
	
	essRefreshScopingValues()
}
});

		function getArrayDepth(arr){  
			arr.forEach((d)=>{
				d['type']="Business_Capability";
			levelArr.push(parseInt(d.level))	
			getArrayDepth(d.childrenCaps);
			 })
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

<xsl:template match="node()" mode="plans">
 <xsl:variable name="thisplanElements" select="current()"/>
    <xsl:variable name="thisplanningAction" select="$planningAction[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>
    <xsl:variable name="thisrelatedAppPlans" select="$relatedAppPlans[name=$thisplanElements/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
    <xsl:variable name="thisrelatedAppStratPlans" select="$relatedAppStratPlans[name=$thisplanElements/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"type":"<xsl:value-of select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='plan_to_element_ea_element']/value]/type"/>",
		"impacting":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='plan_to_element_ea_element']/value)"/>",
	"action":"<xsl:value-of select="$thisplanningAction/own_slot_value[slot_reference = 'name']/value"/>", 
	"plans":[<xsl:for-each select="$thisrelatedAppStratPlans">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","type":"<xsl:value-of select="current()/type"/>"
	}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"projects":[<xsl:for-each select="$thisrelatedAppPlans">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","type":"<xsl:value-of select="current()/type"/>"
	}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>

</xsl:template>	
<xsl:template match="node()" mode="classMetaData"> 
		<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
		{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>
</xsl:stylesheet>
