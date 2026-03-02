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
	<xsl:variable name="linkClasses" select="('Application_Service', 'Business_Process', 'Application_Provider', 'Site', 'Group_Actor', 'Technology_Component')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"/>
	<xsl:variable name="physProcAppsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
  
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="capsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="products" select="/node()/simple_instance[type='Product']"/>
	<xsl:variable name="productType" select="/node()/simple_instance[type='Product_Type']"/>
	
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
		<xsl:variable name="capPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ppPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$physProcAppsData"/>
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
				<title><xsl:value-of select="eas:i18n('Organisation Summary')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"></link>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"></script>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js" type="text/javascript"></script>
				
				<script src="js/lodash/lodash.js"></script> 
				<script src="js/backbone/backbone.js"></script> 
 
				<script src="js/jointjs/joint.min.js"></script> 
				<script src="js/jointjs/joint.layout.DirectedGraph.min.js"></script>
				<script src="js/jstree/jstree.min.js"></script>
				<script src="js/jointjs/joint.layout.DirectedGraph.min.js"></script>
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>

				<style type="text/css">
				.thead input {
					width: 100%;
					}

					.ess-blobWrapper {
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}

					.ess-blob{
						border: 1px solid #ccc;
						min-height: 40px;
						width: 145px;
						border-radius: 4px;
						position: relative;
						text-align: center;
						padding: 5px;
						display: flex;
						justify-content: center;
						align-items: center;
					}

					.orgName{
						font-size:2.4em;
						padding-top:30px;
						text-align:center;
					}

					.ess-blobLabel{
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
					.radioLabel {
						display: inline-block;
						margin-left: 10px; 
					}
					// new Chart

					#orgchart svg {
						border: 1px solid #ddd;
					  }
					  .link {
						fill: none;
						stroke: #ccc;
						stroke-width: 2;
					  }
					  .node rect {
						fill: #fff;
						stroke: steelblue;
						stroke-width: 2;
					  }
					  .node text {
						font-size: 10px;
					  }

					 
			
					/* Styling for the connecting lines */
					.link {
						fill: none;
						stroke: #ccc;
						stroke-width: 2px;
					}
					.regulationBox{
						min-height:90px;
						width:200px;
						border:1px solid #d3d3d3;
						border-radius:4px;
						border-left: 5px solid #368e6c;
						padding:2px;
						display:inline-block;
						vertical-align: top;
					}
					#paper {
						width: 1000px;
						height: 600px;
						border: 1px solid #ddd;
						overflow: auto;
						flex-grow: 1;
					}
					.orgheader {
						padding: 10px;
						background-color: #f5f5f5;
						border-bottom: 1px solid #ddd;
						display: flex;
						justify-content: space-between;
						align-items: center;
					}
					.controls {
						display: flex;
						gap: 10px;
					}
					.org-element text {
						font-family: Arial, sans-serif;
						fill: #333;
						cursor: pointer;
					}
					.org-element rect {
						fill: #E8F0FE;
						stroke: #4285F4;
						stroke-width: 2px;
						rx: 5;
						ry: 5;
						cursor: pointer;
					}
					.org-element.highlighted rect {
						fill: #C6DAFC;
						stroke: #1967D2;
					}
					.link-tool .tool-remove circle {
						fill: #FF5252;
					}
					.link-tool .tool-remove path {
						fill: white;
					}

					#paper .jstree-node li {
						list-style: none !important;
						/* if you still see indentation, you can also add: */
						margin-left: 0;
						padding-left: 0;
						}
				</style>
				<script>
					
					function initDataStoredMap(){
						$('#mapDataStored-parent').append('<div id="mapDataStored" class="map"></div>');
						mapDataStored = $('#mapDataStored').vectorMap(
							{
								map: 'world_mill',
                                zoomOnScroll: false,
								backgroundColor: 'transparent',
								hoverOpacity: 0.7,
								hoverColor: false,
								regionStyle: {
								    initial: {
									    fill: '#ccc',
									    "fill-opacity": 1,
									    stroke: 'none',
									    "stroke-width": 0,
									    "stroke-opacity": 1
								    }
							    },
							    markerStyle: {
							    	initial: {
								        fill: 'yellow',
								        stroke: 'black',
							        }
							    },
							    series: {
								    regions: [{
								    	values: {'US':'hsla(220, 70%, 40%, 1)', 'FR': 'hsla(220, 70%, 40%, 1)'},
								    	attribute: 'fill'
								    }]
								},
							}
						);
					}
					
					function initSupportMap(){
						$('#mapSupport-parent').append('<div id="mapSupport" class="map"></div>');
						mapSupport = $('#mapSupport').vectorMap(
							{
								map: 'world_mill',
                                zoomOnScroll: false,
								backgroundColor: 'transparent',
								hoverOpacity: 0.7,
								hoverColor: false,
								regionStyle: {
								    initial: {
									    fill: '#ccc',
									    "fill-opacity": 1,
									    stroke: 'none',
									    "stroke-width": 0,
									    "stroke-opacity": 1
								    }
							    },
							    markerStyle: {
							    	initial: {
								        fill: 'yellow',
								        stroke: 'black',
							        }
							    },
							    series: {
								    regions: [{
								    	values: {'IN':'hsla(320, 75%, 50%, 1)', 'GB': 'hsla(320, 75%, 50%, 1)'},
								    	attribute: 'fill'
								    }]
								}
							}
						);
					}
					
				

					
					$(document).ready(function(){
						
						
						$('a[href="#residency"]').on('shown.bs.tab', function (e) {
							initDataStoredMap();
							initSupportMap();
						});
						$('a[href="#residency"]').on('hidden.bs.tab', function (e) {
							mapDataStored.remove();
							mapSupport.remove();
						});
                        
					});
				</script>
				<script src='js/d3/d3.v7.9.0.min.js'></script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>

				<!--ADD THE CONTENT-->
			<div class="container-fluid" id="summary-content">
				<div class="row">
					<div class="col-xs-12">
						<div class="page-header">
							<h1>
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Organisation Summary for')"/> </span><xsl:text> </xsl:text> 
								<span class="text-primary headerName"><select id="subjectSelection" style="width: 600px;"></select></span>
								
							</h1>
						</div>
					</div>
				</div>
				<div id="APIWarning" class="alert alert-warning" style="display:none">
					<xsl:value-of select="eas:i18n('WARNING: The API has been updated - No data related to children is showing, please republish to see the child data')"/>.	
				</div>
			</div>
			
			<span id="mainPanel"/>
			
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
				<script>
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
					<xsl:with-param name="viewerAPIPathApp" select="$appPath"/>
					<xsl:with-param name="viewerAPIPathPP" select="$ppPath"/>
					<xsl:with-param name="viewerAPIPathCap" select="$capPath"/>
					
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

		<div class="container-fluid">
			
			<!--Setup Vertical Tabs-->
			<div class="row">
				<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
					<!-- required for floating -->
					<!-- Nav tabs -->
					<ul class="nav nav-tabs tabs-left">
						<li class="active">
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Organisation Details')"/></a>
						</li>
						<li>
							<a href="#hierarchy" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('Organisation Hierarchy')"/></a>
						</li>
						{{#if this.allBusProcs}}
						<li>
							<a href="#processes" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Processes')"/></a>
						</li>
						{{/if}}
						{{#if this.allAppsUsed}}
						<li>
							<a href="#applications" class="appTab" data-toggle="tab"><i class="fa fa-fw fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application Usage')"/></a>
						</li>
						{{/if}}
						{{#if this.documents}}
						<li>
							<a href="#documents" class="appTab" data-toggle="tab"><i class="fa fa-fw fa-file-text-o right-10"></i><xsl:value-of select="eas:i18n('Documents')"/></a>
						</li>
						{{/if}}
					<!-- 	<li>
							<a href="#projects" data-toggle="tab"><i class="fa fa-fw fa-calendar-check-o right-10"></i><xsl:value-of select="eas:i18n('Plans and Projects')"/></a>
						</li>-->
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Organisation Details')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Organisation')"/></h3>
									<label><xsl:value-of select="eas:i18n('Organisation Name')"/></label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									{{#if this.description}}
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<div class="ess-string">{{{this.description}}}</div>
									<div class="clearfix bottom-10"></div>
									{{/if}}
									{{#if this.parents}}
										<label><xsl:value-of select="eas:i18n('Parent Organisation(s)')"/></label>
										<ul class="ess-list-tags">
										{{#each this.parents}}
											<li>{{this.name}}</li>
										{{/each}}
										</ul>
									{{/if}}
									<label><xsl:value-of select="eas:i18n('Direct Child Organisation(s)')"/></label>
									<ul class="ess-list-tags">
									{{#each this.childrenOrgs}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-bar-chart right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
									<label><xsl:value-of select="eas:i18n('Processes')"/> </label>
									<div class="bottom-10">
										<div class="keyCount lbl-large bg-orange-100">{{this.allBusProcs.length}}</div>
									 
									<label><xsl:value-of select="eas:i18n('Applications Used')"/><xsl:text> </xsl:text><small>(<xsl:value-of select="eas:i18n('excl. Parents')"/>)</small></label>
									 
									<div class="keyCount lbl-large bg-brightgreen-100">{{this.allAppsUsed.length}}</div>	 							
									</div>
									
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Primary Locations')"/></h3>
									<label><xsl:value-of select="eas:i18n('Sites')"/></label>
									<ul class="ess-list-tags">
										{{#each this.allSites}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
									
								</div>
								{{#if this.regulations}}
								<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Regulations')"/></h3>
									<xsl:value-of select="eas:i18n('Regulations impacting this organisation')"/>
									<br/>
										{{#each this.regulations}}
											<div class="regulationBox">
													{{this.name}}<br/>
												<span style="font-size:0.8em">{{this.description}}</span>
											</div>
										{{/each}}
									
									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
						 
								<div class="col-xs-12"/>
								{{#if this.orgProductTypes}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Products/Services Supported')"/></h3>
									
									<ul class="ess-list-tags"> 
										{{#each this.orgProductTypes}}
											<li class="roleBlob" style="background-color: rgb(179, 197, 208)">{{this}}</li> 
										{{/each}}
									</ul> 
									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
								{{#if this.orgEmployees}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('People &amp; Roles')"/></h3>
									 
									<table class="table table-striped table-bordered" id="dt_stakeholders">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
												 
												</tr>
											</thead>
											<tbody>
											{{#each this.orgEmployees}}
											<tr>
												<td class="cellWidth-30pc">
														<i class="fa fa-user text-success right-5"></i>	{{this.name}}
												</td>
												<td class="cellWidth-30pc">
													<ul class="ess-list-tags">
														{{#each this.roles}}
														{{#ifEquals this.name 'Application Organisation User'}}
															<i class="fa fa-user text-success right-5"></i> <xsl:value-of select="eas:i18n('Application User')"/>
														{{else}}
															<li class="roleBlob" style="background-color: rgb(96, 217, 214)">{{this.name}}</li>
														{{/ifEquals}} 
														{{/each}} 
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
								{{#if this.orgRoles}}
								<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Organisation Roles')"/></h3>
										<ul class="ess-list-tags">
											{{#each this.orgRoles}}
												<li class="roleBlob" style="background-color: rgb(96, 217, 144)">{{this.name}}</li>
											{{/each}}
										</ul>
									 
	
										<div class="clearfix bottom-10"></div>
										
								</div>
								{{/if}}
							</div>
						</div>
						<div class="tab-pane" id="hierarchy">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Hierarchy')"/></h2>
						 		<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i><xsl:value-of select="eas:i18n('Organisation Hierarchy')"/></h3>
									<div class="bottom-10"><div class="pull-right"> 
										<!--<button class="btn btn-sm btn-secondary" id="download-svg"><i class="fa fa-cloud-download"/></button>
										-->
                                        <button class="btn btn-sm btn-secondary" id="recenterChartBtn"><i class="fa fa-target"/><xsl:value-of select="eas:i18n('Re-centre')"/></button>
									</div>
								        <div id="paper" style="width: 100%; height: 600px;"></div>
									</div>

								</div>  
							 
						</div>
						<div class="tab-pane" id="processes">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-globe right-10"></i><xsl:value-of select="eas:i18n('Business Processes')"/></h2>
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i><xsl:value-of select="eas:i18n('Business Processes')"/></h3>
									<p><xsl:value-of select="eas:i18n('Business processes and their criticality')"/></p>
									<div class="ess-blobWrapper">
									 {{#each this.allBusProcs}}
									  {{#if this.name}}
										<div class="ess-blob bdr-left-orange" id="someid">
											<div class="ess-blobLabel">
												 {{{essRenderInstanceMenuLink this}}} 
											</div>
											<div class="infoButton" id="someid_info">
												<a tabindex="0" class="popover-trigger">
													<i class="fa fa-info-circle"></i>
												</a>
												<div class="popover">
													<div class="strong">{{this.name}}</div>
													<div class="small text-muted">{{this.description}}</div>
													<ul class="ess-list-tags">
														<li style="background-color: rgb(163, 214, 194)">{{this.criticality}}</li>
													</ul> 
												</div>
											</div>
										</div>
										{{/if}}
									{{/each}}	
									</div>
								</div>
							</div>
						
			 			<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Process Implementations</h3>
									Application Mapping Key: <label class="label   ess-mini-badge" style="background-color: rgb(170, 194, 213);color:#000">Direct to Process</label><xsl:text> </xsl:text><label class="label  ess-mini-badge" style="background-color:rgb(210, 169, 190);color:#000">Via Application Service</label>
									<p>Processes for this specific organisation, not including children</p>
									<div class="bottom-10">
										<table id="dt_supportedprocesses" class="table table-striped table-bordered" >
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Process')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Capabilities Supporting')"/>
													</th>
													<!--
                                                    <th>
														<xsl:value-of select="eas:i18n('Organisation Performing')"/>
													</th>
													-->
													<th>
														<xsl:value-of select="eas:i18n('Product')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Applications Used')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												 {{#each this.physicalProcesses}}
												 {{#if this.processName}}
													<tr>
														<td>
															{{this.processName}}
														</td>
														<td>
															
															<ul class="ess-list-tags"> 
																{{#each this.caps}}
																<li class="roleBlob" style="background-color: #f3da67">{{this}}</li> 
																{{/each}}
															</ul> 
															 
														</td>
														<!--
                                                        <td>
															<ul class="ess-list-tags"> 
																	<li class="roleBlob" style="background-color: rgb(132, 213, 237)">{{this.org}}</li> 
															</ul> 
															
														</td>
														-->
														<td>
															<ul class="ess-list-tags">
																{{#each this.product}}
																	<li class="roleBlob" style="background-color: rgb(213, 203, 170)">{{this}}</li>
																{{/each}} 
															</ul> 
														</td>
														<td>
															{{#if this.criticality}}
															<ul class="ess-list-tags">
																<li style="background-color: rgb(163, 214, 194)">{{this.criticality}}</li>
															</ul> 
															{{/if}}
														</td>
														<td>
															<ul class="ess-list-tags">
															{{#each this.appsdirect}}
																<li class="roleBlob" style="background-color: rgb(170, 194, 213)">{{this.appName}}</li>
															{{/each}} 
															{{#each this.appsviaservice}}
																<li class="roleBlob" style="background-color: rgb(210, 169, 190)">{{this.appName}}</li>
															{{/each}} 
															</ul>
														</td>
													</tr>
												 {{/if}}
												{{/each}}

											</tbody>
											<tfoot>
												<tr>
													<th class="procIn">
														<xsl:value-of select="eas:i18n('Process')"/>
													</th>
													<th class="procIn">
														<xsl:value-of select="eas:i18n('Capabilities Supporting')"/>
													</th>
													<!--
													<th>
														<xsl:value-of select="eas:i18n('Organisation Performing')"/>
													</th>
													-->
													<th class="procIn">
														<xsl:value-of select="eas:i18n('Product')"/>
													</th>
													<th class="procIn">
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Applications Used')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</div>

								</div>  
						</div>
						<div class="tab-pane" id="applications">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i>Usage</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i>Supporting Apps</h3>
									Applications used by this organisation or its children organisations. <br/>
									Key: <label class="label label-info ess-mini-badge">Via Process</label><xsl:text> </xsl:text><label class="label label-warning ess-mini-badge">Via App Org User</label><label class="label ess-mini-badge" style="background-color: #b07fdd;">Via Child Org</label>
									<label class="label ess-mini-badge" style="background-color: #646068;">Via Parent</label>
									<div class="clearfix top-15"/>
									
									<div style="position:absolute;right:20px;z-index:100">
										<b><xsl:value-of select="eas:i18n('Include Parent')"/></b>: Hide: <input type="radio" name="parentFilter" value="withoutParent" checked="true" />
										Show: <input type="radio" name="parentFilter" value="withParent" /> 
									</div>
									<table class="table table-striped table-bordered" id="dt_apptable">
											<thead>
												<tr>
													<th width="150px">
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th width="800px">
														<xsl:value-of select="eas:i18n('Description')"/>
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
																<xsl:value-of select="eas:i18n('Description')"/>
															</th>
															 
														</tr>
											</tfoot>
										</table>
									<div class="clearfix bottom-10"></div>
								</div>
						</div>
						</div>
						<div class="tab-pane" id="projects">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-lock right-10"></i><xsl:value-of select="eas:i18n('Plans and Projects')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Strategic Plans')"/></h3>
									<label><xsl:value-of select="eas:i18n('No. of Strategic Plans')"/></label>
									<div class="bottom-15">
										<span class="label label-info lbl-big">5</span>
									</div>
									<label><xsl:value-of select="eas:i18n('Strategic Plans List')"/></label>
								
									<ul class="ess-list-tags">
									</ul>
									 
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i><xsl:value-of select="eas:i18n('Projects')"/></h3>
									<label><xsl:value-of select="eas:i18n('No. of Projects')"/></label>
									<div class="bottom-15">
										<span class="label label-primary lbl-big">5</span>
									</div>
									<ul class="ess-list-tags">
										<li>Proj 1</li>
									</ul>
									 
								</div>
								
								 
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

			<!--Setup Closing Tag-->
		</div>

	</script>	
	<script id="appline-template" type="text/x-handlebars-template">
		<span><xsl:attribute name="id">{{this.id}}</xsl:attribute>{{{essRenderInstanceMenuLink this}}}<br/>
			{{#if this.proc}}{{#ifEquals this.proc 'Indirect'}}<label class="label ess-mini-badge" style="background-color: #b07fdd;">{{this.proc}}</label>{{else}}<label class="label label-info ess-mini-badge">{{this.proc}}</label>{{/ifEquals}}{{/if}}
			{{#if this.org}}{{#ifEquals this.org 'Parent'}}<label class="label ess-mini-badge" style="background-color: #646068;">{{this.org}}</label>{{else}}<label class="label label-warning ess-mini-badge">{{this.org}}</label>{{/ifEquals}}{{/if}}
		</span>
	</script>
	<script id="roles-template" type="text/x-handlebars-template"></script>
	<script id="jsonOrg-template" type="text/x-handlebars-template">
		<div class="orgName">{{this.name}}</div>
	</script>
	<script id="apps-template" type="text/x-handlebars-template"></script>
	<script id="processes-template" type="text/x-handlebars-template"></script>
	<script id="sites-template" type="text/x-handlebars-template"></script>
	<script id="appsnippet-template" type="text/x-handlebars-template"></script>
<script>;	   
  <xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template>
 let products=[<xsl:apply-templates select="$products" mode="products"/>];
  
	$(document).ready(function ()
	{
		// compile any handlebars templates
		var panelFragment = $("#panel-template").html();
		panelTemplate = Handlebars.compile(panelFragment);
 
		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
	 
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});
 
		let panelSet = new Promise(function(myResolve, myReject) {	 
			$('#mainPanel').html(panelTemplate())
			myResolve(); // when successful
			myReject();  // when error
			});
   
				});
		
		let procTable
 
		 
</script>
		</html>
	</xsl:template>     
	
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/> 
			<xsl:param name="viewerAPIPathApp"/>
			<xsl:param name="viewerAPIPathPP"/>
			<xsl:param name="viewerAPIPathCap"/>
			//a global variable that holds the data returned by an Viewer API Report
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
			var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApp"/>';
			var viewAPIDataPP = '<xsl:value-of select="$viewerAPIPathPP"/>';
			var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCap"/>';
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
      var appsData=[], currentChart; // Added currentChart here
      var currentOrgIdForChart = null; // To track which org the chart is for
	  var orgOptions='';
	  var processLookupObj,orgHierarchy, toShow, orgById, focusOrg;
	  var focusID="<xsl:value-of select='eas:getSafeJSString($param1)'/>";
	  var rolesFragment, appsnippetTemplate, appsnippetFragment, appsFragment, processesFragment, sitesFragment, rolesTemplate, appsTemplate, processesTemplate,sitesTemplate ;
	  
	  function findOrgById(horgs, targetId) {  
		const result = _search(horgs, targetId, []);
		if (!result) return null;
	  
		const { node, ancestors } = result;
		const children = Array.isArray(node.children) ? node.children : [];
  		const allApps = _collectApplications(children);
		return {
		  org: node,
		  parents: ancestors,
		  children,
		  allApps
		};
	  }

	  
	    function buildSingleHierarchy(orgs, rootId, includeContext = true) { 
				const MAX_DEPTH = 10;
				if (!orgs || !Array.isArray(orgs)) return { id: rootId, name: 'Unknown', children: [] };
				const map = new Map();

				for (const org of orgs) {
					if (!org || !org.id) continue;
					const { id, parent, name } = org;
					const parents = Array.isArray(parent)
					? parent
					: parent != null
					? [parent]
					: [];
					map.set(id, { id, name: name || 'Unnamed', parents, children: [] });
				}

				
				for (const node of map.values()) {
					for (const pid of node.parents) {
					const p = map.get(pid);
					if (p) p.children.push(node);
					}
				}

				
				const visited  = new Set();
				const inStack  = new Set();
				const cycles   = [];

				function dfs(node, depth) {
					// Cycle detection
					if (inStack.has(node.id)) {
					cycles.push(node.id);
					return null;
					}
					if (visited.has(node.id)) {
					// Already processed this branch
					return { id: node.id, name: node.name, children: [] };
					}

					inStack.add(node.id);

					// Build the result node
					const result = { id: node.id, name: node.name, children: [] };

					if (depth &lt; MAX_DEPTH) {
					for (const child of node.children) {
						const sub = dfs(child, depth + 1);
						if (sub) result.children.push(sub);
					}
					}
					// else depth === MAX_DEPTH → leave children empty

					inStack.delete(node.id);
					visited.add(node.id);
					return result;
				}

                            const rootNode = map.get(rootId);
                            if (!rootNode) return { id: rootId, name: 'Root not found', children: [] };

							let startNode = rootNode;
							if (includeContext &amp;&amp; rootNode.parents &amp;&amp; rootNode.parents.length > 0) {
								const parentNode = map.get(rootNode.parents[0]);
								// If we find a parent, use it as startNode to provide context
								if (parentNode) {
									startNode = parentNode;
								}
							}

                            const subtree = dfs(startNode, 1);
							return subtree || { id: rootId, name: rootNode.name, children: [] };

                            

                            return subtree;
                            }
	 
	  function _search(nodes, targetId, ancestors) {
		for (const node of nodes) {
		  if (node.id === targetId) {
			return { node, ancestors };
		  }
		  if (node.children &amp;&amp; node.children.length) {
			const found = _search(node.children, targetId, [...ancestors, node]);
			if (found) {
			  return found;
			}
		  }
		}
		return null;
	  }

	  function _collectApplications(nodes) {
		const appsSet = new Set();
	  
		function traverse(list) {
		  for (const node of list) { 
			if (Array.isArray(node.applicationsUsedbyProcess)) {
			  node.applicationsUsedbyProcess.forEach(app => appsSet.add(app));
			}
			if (node.children &amp;&amp; node.children.length) {
			  traverse(node.children);
			}
		  }
		}
	  
		traverse(nodes);
		return Array.from(appsSet);
	  }

			$(document).ready(function () {
				
				$('.selectOrgBox').select2();
	
				rolesFragment = $("#roles-template").html();
				rolesTemplate = Handlebars.compile(rolesFragment);
				
				appsFragment = $("#apps-template").html();
				appsTemplate = Handlebars.compile(appsFragment);
	
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
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataPP),
			promise_loadViewerAPIData(viewAPIDataCaps)
			
			]).then(function(responses) {
 
				if(responses[0].version == "616"){ 
					$('#APIWarning').css('display', 'block');
				}
			let orgRoles=[];		
				orgData=responses[0].orgData; 
     
 

           function mapOrgsToApps(apps) {
            // Use a Map internally for fastest key lookups
            const orgMap = new Map();

            for (let i = 0, nApps = apps.length; i &lt; nApps; i++) {
                const app = apps[i];
                // extract once per app
                const entry = { id: app.id };
                const orgs = app.orgUserIds;
                for (let j = 0, nOrgs = orgs.length; j &lt; nOrgs; j++) {
                const org = orgs[j];
                const arr = orgMap.get(org);
                if (arr) {
                    arr.push(entry);
                } else {
                    orgMap.set(org, [entry]);
                }
                }
            }

            // Convert Map back to a plain object (if you prefer)
            const result = Object.create(null);
            for (const [org, appsList] of orgMap) {
                result[org] = appsList;
            }
            return result;
            }

 			const orgToApps = mapOrgsToApps(responses[1].applications);
            
				   orgData.forEach((o)=>{
						orgOptions=orgOptions+'<option value="'+o.id+'">'+o.name+'</option>'
                         
					if(!o.parent){
						o['parent']=o.parentOrgs;	
					}
                         
				   })
            //orgMap 
				orgById = orgData.reduce((map, org) => {
                    map[org.id] = org;
                    return map;
                }, {});

				const orgArray = Object.values(orgById).map(org => ({
				id:   org.id,
				text: org.name
				})).sort((a, b) => a.text.localeCompare(b.text));;
		
				const count = orgArray.length;
				const $select = $('#subjectSelection');
			
				$select.empty(); 
				if (count > 1000) {
				 
				//  for large lists
				$select.select2({
					ajax: {
					transport: (params, success, failure) => {
						const term    = (params.data.q || '').toLowerCase();
						const matches = orgArray
						.filter(o => o.text.toLowerCase().includes(term))
						.slice(0, 50);              // only return the first 50
						success({ results: matches });
					},
					processResults: data => data,  // our transport already returned {results: [...]}
					delay: 150
					},
					placeholder:   'Select an Organisation',
					minimumInputLength: 1,
					allowClear:    true,
					width:         '400px'
				})

				focusText = orgById[focusID].name
				$('#subjectSelection').append(new Option(focusText, focusID, true, true)); 
				} else {
				 
					const options = orgArray.map(o =>{
						const isSel = (o.id === focusID); 
						return new Option(o.text, o.id, false, isSel)
					});
					
					$select.append(options).select2({
						width: '400px'
					});
				}
 		 
				   let busCaps=responses[3].busCaptoAppDetails;

				   const processLookup = new Map();

					// Standard `for` loops for better performance in large arrays
					for (let i = 0; i &lt; busCaps.length; i++) {
						const cap = busCaps[i];
						
						// Iterate through the processes in `allProcesses`
						for (let j = 0; j &lt; cap.processes.length; j++) {
							const process = cap.processes[j];

							// If the process ID already exists, add the capability to the array
							if (processLookup.has(process.id)) {
								processLookup.get(process.id).push(cap.name);
							} else {
								// Otherwise, create a new array with the current capability
								processLookup.set(process.id, [cap.name]);
							}
						}
					}

					// Convert the Map back to an object if needed
					processLookupObj = Object.fromEntries(processLookup);
				 
				   responses[3].busCapHierarchy=[];
				   responses[3].physicalProcessToProcess=[];
				   if(responses[0].orgRoles){
				   	orgRoles=responses[0].orgRoles;
				   }
				   appData=responses[1];
				   physProc=responses[2];  
 
                   const appsAndAPIs = [...appData.applications, ...appData.apis];
                    const appById = appsAndAPIs.reduce((m, app) => {
                    m[app.id] = app;
                    return m;
                    }, {});

				  let orgProductTypes=[];
					// Build a Map for quick id → app lookup
					const physappById = new Map(
						physProc.process_to_apps.map(app => [app.id, app])
						);

						// For each product and each of its process-ids, look up the app in O(1)
						for (const prod of products) {
						for (const procId of prod.processes) {
							const app = physappById.get(procId);
							if (!app) continue;

							// Initialise the array once, then push
							app.product = app.product ?? [];
							app.product.push(prod.name);
						}
					}

				   modelData=[]  
				 
                        const rolesMap    = new Map(orgRoles   .map(or => [or.id, or.roles]));
                        const uniqueById  = arr => Array.from(new Map(arr.map(x => [x.id, x])).values());
                        const appsMap     = orgToApps;              // assume { orgId: [ { id,…}, … ], … }
                        const nodesById   = orgById;                // assume { id: { id, name, children:[…], … }, … }
                        const getApps     = id => appsMap[id] || [];
                        const getNode     = id => nodesById[id] || {};
 
                        for (const d of orgData) {

                        const {
                            id,
                            children: childIds = [],
                            parent:   parentIds = [],
                            site:     sites     = [],
                            businessProcess: selfProcsRaw = []
                        } = d;
 
                        if (rolesMap.has(id)) {
                            d.orgRoles = rolesMap.get(id);
							
                        }
						 
 						d.orgRoles = [...new Map(d.orgRoles.map(role => [role.name, role])).values()];
						 
                        const childrenOrgs = childIds
                            .map(getNode)
                            .filter(n => n.id != null);

                        const parents = parentIds
                            .map(getNode)
                            .filter(n => n.id != null);
 
                        d.childrenOrgs = childrenOrgs;
                        d.parents      = parents;
                        d.orgUserIds   = childrenOrgs.map(c => c.id);
						d.allSites = [
						...new Map(childrenOrgs.flatMap(c => c.site?.map(site => [site.id, site])).filter(Boolean)).values()
						];

                        const ownApps = getApps(id);
                        d.ownApps = ownApps;
 
                        const childrenApps = childrenOrgs.flatMap(c => {
                            const procApps = Array.isArray(c.applicationsUsedbyProcess)
                            ? c.applicationsUsedbyProcess
                            : [];
                            return [...getApps(c.id), ...procApps];
                        });

                     
                        const childProcs = childrenOrgs.flatMap(c =>
                            Array.isArray(c.businessProcess) ? c.businessProcess : []
                        );
                        const allBusProcs = uniqueById([...selfProcsRaw, ...childProcs])
                            .map(proc => ({ ...proc, className: 'Business_Process' }));
                       
						allBusProcs.sort((a, b) => {
							const nameA = a.name?.toLowerCase() || '';
							const nameB = b.name?.toLowerCase() || '';
							return nameA.localeCompare(nameB);
							});

						d.allBusProcs = allBusProcs; 
                        const allAppIds = Array.from(
                            new Set([...ownApps, ...childrenApps].map(a => a.id))
                        ).map(id => ({ id }));
                        d.allAppsUsed = allAppIds;

            
                        const parentAppsRaw = parents.flatMap(p => {
                            const procApps = Array.isArray(p.applicationsUsedbyProcess)
                            ? p.applicationsUsedbyProcess
                            : [];
                            return [...getApps(p.id), ...procApps];
                        });
                        const allParentAppIds = Array.from(
                            new Set(parentAppsRaw.map(a => a.id))
                        ).map(id => ({ id }));
                        d.allAppsUsedParent = allParentAppIds;
  
						d.allSites = d.allSites || [];
						d.allSites = [...d.allSites, ...d.site];

 
                        const allChildren = childrenOrgs.flatMap(c =>
                            (c.children || []).map(getNode).filter(n => n.id != null)
                        );
                        d.allChildren = uniqueById(allChildren);
 
                        d.ownApps = ownApps.map(a => appById[a.id]).filter(Boolean);
                        d.allAppsUsed= d.allAppsUsed.map(a => appById[a.id]).filter(Boolean);
                        d.allAppsUsedParent  = d.allAppsUsedParent .map(a => appById[a.id]).filter(Boolean);
                        }
 
					<!--- HERE   --> 
					redrawPage(focusID)
 
				})
				.catch (function (error) {
					//display an error somewhere on the page   
				});
				 
			});
			
			function countItemsByProperty(root, propName, maxDepth = 3) {
				let total = 0;

				function recurse(obj, currentDepth) {
					if (
					currentDepth > maxDepth ||
					obj === null ||
					typeof obj !== 'object'
					) {
					return;
					}

					if (Array.isArray(obj[propName])) {
					total += obj[propName].length;
					}

					for (const val of Object.values(obj)) {
					recurse(val, currentDepth + 1);
					}
				}

				recurse(root, 1);
				return total;
				}
function drawOrgChart(orgChartData, containerId = 'paper') {
    if (!orgChartData || !orgChartData.id) {
        const container = document.getElementById(containerId);
        if (container) container.innerHTML = '<div class="alert alert-info">No hierarchy data available for this organization.</div>';
        return null;
    }
    let total = countItemsByProperty(orgChartData, 'children', 2);

    if (total > 21) {
        // Handle large org chart with jstree (unchanged)
        selectedOrgChart.org.children = selectedOrgChart.org.children.map(key => {
            const org = orgById[key];
            return {
                id: org.id,
                text: org.name
            };
        });

        const flatTreeData = {
            id: selectedOrgChart.org.id,       
            text: selectedOrgChart.org.name,     
            children: selectedOrgChart.org.children
        };

        $('#paper').on('select_node.jstree', function (e, data) {
            const clickedId = data.node.id;  
            redrawPage(clickedId);
        }).jstree({
            core: {
                data: flatTreeData
            },
            plugins: ['types'],
            types: {
                'default': {
                    'icon': 'fa fa-angle-right fa-fw'
                }
            }
        }).on('ready.jstree loaded.jstree', function(e, ctx) {
            ctx.instance.open_all();  // Keep expanded if desired
        });
    } else {
        const container = document.getElementById(containerId);
        if (!container) {
            return null;
        }

        container.innerHTML = '';
        const graph = new joint.dia.Graph();
        const paper = new joint.dia.Paper({
            el: container,
            model: graph,
            width: container.clientWidth || 1000,
            height: container.clientHeight || 600,
            gridSize: 1,
            drawGrid: true,
            background: { color: '#F8F9FA' },
            interactive: true,
            cellViewNamespace: joint.shapes,
            defaultConnectionPoint: {
                name: 'rectangle',
                args: { selector: 'rect', sticky: true }
            },
            defaultLink: new joint.shapes.standard.Link({
                router: { name: 'orthogonal' },
                connector: { name: 'normal' },
                connectionPoint: { name: 'rectangle', args: { selector: 'rect' } },
                attrs: {
                    '.connection': {
                        stroke: '#ccc',
                        strokeWidth: 2
                    },
                    '.marker-target': {
                        d: 'M 10 -5 0 0 10 5 z',
                        fill: '#ccc',
                        refX: '100%',
                        refY: '50%',
                        markerUnits: 'strokeWidth'
                    }
                }
            })
        });

        // Attach click event to nodes after paper creation (for small org charts)
        paper.on('element:pointerclick', function(view) {
            const modelId = view.model.id;
            if (modelId) {
                redrawPage(modelId);
            }
        });

        // Define the element type
        const OrgElement = joint.dia.Element.define('org.Element', {
            attrs: {
                rect: {
                    refWidth: '100%',
                    refHeight: '100%',
                    rx: 5,
                    ry: 5,
                    strokeWidth: 2,
                    stroke: '#4285F4',
                    fill: '#E8F0FE',
                    cursor: 'pointer'
                },
                text: {
                    refX: '50%',
                    refY: '50%',
                    textAnchor: 'middle',
                    textVerticalAnchor: 'middle',
                    fontSize: 18, // Adjust font size
                    fontWeight: 'bold',
                    fontFamily: 'Arial, sans-serif',
                    fill: '#333',
                    text: '',
                    cursor: 'pointer'
                }
            }
        }, {
            markup: [
                { tagName: 'rect', selector: 'rect' },
                { tagName: 'text', selector: 'text' }
            ]
        });

        // Helper to wrap text and add the box
        function makeOrgBox(node, x, y) {
            if (typeof node == 'string') {
                node = orgById[node];
            }
            const rawName = node?.name || node?.data?.name || 'Unnamed';
            if (!node) return;
            const maxWidth = 300;
            const desiredWidth = Math.min(maxWidth, Math.max(250, rawName.length * 12)); // Dynamic width with 250px floor
            const wrapped = joint.util.breakText(rawName, {
                width: desiredWidth - 20,
                height: 80
            });

            const id = node.id ?? node.data?.id ?? _.uniqueId('node_');

            // Create the element
            const element = new OrgElement({
                id,
                position: { x, y },
                size: { width: desiredWidth, height: 80 },
                attrs: {
                    text: { text: wrapped }
                }
            }).addTo(graph);

            // Attach click event to the node view (for each node)
            // (No need, as the paper-level handler is set above)

            return element;
        }

        const elements = {};
        elements[orgChartData.id] = makeOrgBox(orgChartData, 300, 50);

        // Recursive function to add children
        function addChildren(parentData, parentEl, offsetX = 0, level = 1) {
            const children = parentData.children || [];
            if (!children.length) return;

            const spacing = 300;
            const vSpacing = 120;
            const startX = offsetX - ((children.length - 1) * spacing / 2);

            children.forEach((child, i) => {
                const x = startX + i * spacing;
                const y = level * vSpacing;
                const box = makeOrgBox(child, x, y);
                if (!box) return;  // Guard against undefined boxes
                elements[child.id] = box;

                const link = new joint.shapes.standard.Link({
                    source: { id: parentEl.id, anchor: { name: 'center' } },
                    target: { id: box.id, anchor: { name: 'center' } },
                    connectionPoint: { name: 'rectangle', args: { selector: 'rect' } },
                    router: { name: 'orthogonal' },
                    connector: { name: 'rounded' },
                    attrs: {
                        '.connection': { stroke: '#ccc', strokeWidth: 2 },
                        '.marker-target': {
                            d: 'M 10 -5 0 0 10 5 z',
                            fill: '#ccc',
                            refX: '100%',
                            refY: '50%',
                            markerUnits: 'strokeWidth'
                        }
                    }
                });

                graph.addCell(link);

                addChildren(child, box, x, level + 1);
            });
        }

        addChildren(orgChartData, elements[orgChartData.id]);

        // Auto-layout
        try {
            joint.layout.DirectedGraph.layout(graph, {
                rankDir: 'TB', nodeSep: 50, edgeSep: 40, rankSep: 80, marginX: 20, marginY: 20
            });
        } catch (err) {
            console.error('Layout error:', err);
        }

        // Enable dragging (panning) functionality on paper
        let isPanning = false;
        let panStartX, panStartY;
        let paperTx, paperTy;

        paper.el.addEventListener('mousedown', function(evt) {
            isPanning = true;
            panStartX = evt.clientX;
            panStartY = evt.clientY;
            const currentTranslate = paper.translate();
            paperTx = currentTranslate.tx;
            paperTy = currentTranslate.ty;
            paper.el.style.cursor = 'grabbing';
        });

        paper.el.addEventListener('mousemove', function(evt) {
            if (isPanning) {
                const dx = evt.clientX - panStartX;
                const dy = evt.clientY - panStartY;
                paper.translate(paperTx + dx, paperTy + dy); // Update translation
            }
        });

        paper.el.addEventListener('mouseup', function() {
            isPanning = false;
            paper.el.style.cursor = 'grab';
        });

        // Add zoom functionality
        paper.el.addEventListener('wheel', function(event) {
            event.preventDefault();
            const delta = Math.max(-1, Math.min(1, (event.deltaY || -event.detail)));
            const currentScale = paper.scale().sx;
            const newScale = currentScale + delta * 0.1;

            // Limit zoom scale
            const minScale = 0.2;
            const maxScale = 3;
            if (newScale &lt; minScale || newScale > maxScale) return;

            const clientX = event.clientX;
            const clientY = event.clientY;
            // Correct coordinate conversion for JointJS zoom
            const localMousePoint = paper.clientToLocalPoint({ x: clientX, y: clientY });
            paper.scale(newScale, newScale, localMousePoint.x, localMousePoint.y);
        });

        // Center the chart and adjust for the viewport size
        paper.scaleContentToFit({ padding: 50, maxScale: 1 });

        return { graph, paper, elements };
    }
}


	
		 
var selectedOrgChart

function redrawPage(focusOrg){   
	if (!focusOrg) return;
	const focusText = orgById[focusOrg]?.name || focusOrg; 
	
	const $select = $('#subjectSelection');
	if ($select.length) {
		if ($select.hasClass("select2-hidden-accessible")) {
			// Select2 handles its own update, but we might need to add the option if it's missing (AJAX mode)
			if (!$select.find("option[value='" + focusOrg + "']").length) {
				$select.append(new Option(focusText, focusOrg, true, true));
			}
			$select.val(focusOrg).trigger('change.select2');
		} else {
			$select.val(focusOrg);
		}
	}
 
	// selectedOrgChart = findOrgById(orgHierarchy, focusOrg); 
	let getOrg = buildSingleHierarchy(orgData, focusOrg); 
 
	if (!getOrg) {
		console.error("Could not build hierarchy for", focusOrg);
		return;
	}
 
	selectedOrgChart = {org:{id:getOrg.id, name: getOrg.name || 'Unknown', children: getOrg.children || []}};

       toShow = orgData.find((e)=>{
		return e.id == focusOrg;
		}) 
		
		if (!toShow) {
			console.error("Could not find organization data for", focusOrg);
			return;
		}
		
		toShow['parentNodeId']=null;
		toShow.allBusProcs = toShow.allBusProcs || [];
		
		  let appProcMap=[]; orgProductTypes=[]; toShow.allBusProcs.forEach((e)=>{ 
			let thisProcess=physProc.process_to_apps.filter((f)=>{
				return e.id == f.processid; }); 
				if(thisProcess){ thisProcess.forEach((pr)=>{ 
					pr['criticality']=e.criticality; 
					pr['caps']= processLookupObj[pr.processid] || ''; appProcMap.push(pr) 

					if(thisProcess.product){ 
						orgProductTypes=[...orgProductTypes, ...pr.product];
					}
				})
			}

			appProcMap = appProcMap.filter((ap)=>{
				return toShow.id == ap.orgid; }); 
				orgProductTypes=orgProductTypes.filter((elem, index, self) => self.findIndex( (t) => {return (t === elem)}) === index) 
				toShow['orgProductTypes']=orgProductTypes
		  }); 
		
		let parentProcs = appProcMap.filter((e)=>{
			  return e.orgid ==  toShow.id;
		  });
	 
		  let childProcs = toShow.allChildren.flatMap(e => {
			let thisProcs = appProcMap.filter(f => f.orgid == e.id).map(p => ({
				...p,
				criticality: e.criticality
			}));
			return thisProcs;
		});
	 
		// Merge all three lists once, de-dup by id
		const merged = [...parentProcs, ...childProcs, ...appProcMap];
			const byId   = new Map();
			for (const proc of merged) {
			if (!byId.has(proc.id)) {
				byId.set(proc.id, proc);
			}
		}
		const phys = Array.from(byId.values());

		// 2) Sort by processName
		phys.sort((a, b) => a.processName.localeCompare(b.processName));

		// 3) Build an appId → appObject map once
		const appById = appData.applications.reduce((m, app) => {
			m[app.id] = app;
			return m;
		}, {});

		// 4) Enrich each proc in one pass
		for (const pr of phys) {
			// appsdirect: just add the name (no find)
			for (let i = 0; i&lt; pr.appsdirect.length; i++) {
				const app = pr.appsdirect[i];
				pr.appsdirect[i] = { ...app, appName: app.name };
			}

				// appsviaservice: lookup via our map
				for (let i = 0; i&lt; pr.appsviaservice.length; i++) {
					const svc = pr.appsviaservice[i];
					const app = appById[svc.appid];
					if (app) {
					pr.appsviaservice[i] = { ...svc, appName: app.name };
					}
					// else leave svc as-is
				}
			}

		// 5) Stick it back on toShow
		toShow.physicalProcesses = phys;

		if (toShow.documents?.length > 0) {
				// Create a new object to store documents grouped by their index
				const groupedDocs = {};

				// Iterate over the documents and group by index
				toShow.documents.forEach(d => {
					// Ensure index is not empty or null, otherwise group under "no_index"
					const index = (d.index === "" || d.index == null) ? "no_index" : d.index;

					// Initialize the array if it doesn't exist
					if (!groupedDocs[index]) {
						groupedDocs[index] = [];
					}

					// Push the document to the respective index group
					groupedDocs[index].push(d);
				});

				// If you want to filter out "no_index" documents, you can do so here
				if (groupedDocs["no_index"]) {
					delete groupedDocs["no_index"]; // Remove the "no_index" group if desired
				}

				// Convert the grouped object to an array of objects, if needed
				toShow.documents = Object.keys(groupedDocs).map(key => ({
					key: key,
					values: groupedDocs[key]
				}));
			}
 
  //console.log('TS:', toShow)
 drawView(toShow, modelData);

}			
			
function drawView(orgToShowData, modelData){   
	$('#mainPanel').html(panelTemplate(orgToShowData))
    //currentChart = drawOrgChart(selectedOrgChart.org);  
	initPopoverTrigger();
	initTable(orgToShowData); 
	$('#subjectSelection').on('change', function(){
		modelData=[] 
          currentOrgIdForChart = null; // Reset to force redraw on tab click for new org
		redrawPage($(this).val());
	});

    $(document).on('click', '#recenterChartBtn', function() {
        if (currentChart &amp;&amp; currentChart.paper) {
            currentChart.paper.scaleContentToFit({ padding: 50, maxScale: 1 });
        }
    });



    // Detach previous event handlers to avoid multiple bindings
    $('a[data-toggle="tab"][href="#hierarchy"]').off('shown.bs.tab');

    // Attach event handler for when the hierarchy tab is shown
	       
							
    $('a[data-toggle="tab"][href="#hierarchy"]').on('shown.bs.tab', function (e) {
 
        const paperDiv = document.getElementById('paper');


 
	  if(selectedOrgChart==null){
   			let getOrg =buildSingleHierarchy(orgData, toShow.id); 
			selectedOrgChart = {org:{id:getOrg.id, name: getOrg.name, children: getOrg.children}};
	  }
	    
        if (selectedOrgChart &amp;&amp; selectedOrgChart.org &amp;&amp; paperDiv) {

            // Only draw if it's a new org or chart hasn't been drawn for this org yet
            if (currentOrgIdForChart !== selectedOrgChart.org.id || !paperDiv.hasChildNodes()) {
 
                currentChart = drawOrgChart(selectedOrgChart.org);
                currentOrgIdForChart = selectedOrgChart.org.id;
            } else if (currentChart &amp;&amp; currentChart.paper) {
                // If chart exists for the current org, just ensure dimensions are correct
                currentChart.paper.setDimensions(paperDiv.clientWidth, paperDiv.clientHeight);
                currentChart.paper.scaleContentToFit({ padding: 50, maxScale: 1 });
            }
        } else {
            // Show message if no data
            $('#paper').empty(); // Clear paper if no data
        }
    });

    // If the hierarchy tab is already active, manually trigger the 'shown.bs.tab' event.
    if ($('ul.nav-tabs li.active a[href="#hierarchy"]').length > 0) {
        setTimeout(function() {
            $('a[data-toggle="tab"][href="#hierarchy"]').trigger('shown.bs.tab');
        }, 100); 
    }

    // General tab shown event for DataTables column adjustment
    $('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ $($.fn.dataTable.tables(true)).DataTable().columns.adjust(); });

    // Window resize handler for the org chart
    $(window).off('resize.orgchart').on('resize.orgchart', function() {
        if (currentChart &amp;&amp; currentChart.paper &amp;&amp; $('#paper').is(':visible')) {
            const $container = $('#paper');
            currentChart.paper.setDimensions($container.width(), $container.height());
            currentChart.paper.scaleContentToFit({ padding: 50, maxScale: 1 });
        }
    });
  
}
 
function initTable(dt){
	$('#dt_supportedprocesses tfoot th').each( function () {
				 
		var protitle = $(this).text(); 
		$(this).html( '&lt;input class="procIn" type="text" placeholder="Search '+protitle+'" /&gt;' );
	
	});

		procTable = $('#dt_supportedprocesses').DataTable({
					scrollY: "350px",
					scrollCollapse: true,
					paging: true,
					info: false,
					pageLength: 25,
					sort: true,
					responsive: true,
					columns: [
						{ "width": "30%" },
						{ "width": "30%" },
						{ "width": "15%" } ,
						{ "width": "10%" } ,
						{ "width": "15%" }   
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
			procTable.columns().every( function () {
				var thatp = this;
			
				$( '.procIn', this.footer() ).on( 'keyup change', function () {
					if ( thatp.search() !== this.value ) {
						thatp
							.search( this.value )
							.draw();
					}
				} );
			} );
			procTable.columns.adjust();
						
			$(window).resize( function () {
				procTable.columns.adjust();
			});
			procTable.columns.adjust().draw();
	$('#dt_stakeholders tfoot th').each( function () {
		var title = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
	} );
									
		var table = $('#dt_stakeholders').DataTable({
		scrollY: "350px",
		scrollCollapse: true,
		paging: false,
		info: false,
		sort: true,
		responsive: true,
		columns: [
			{ "width": "30%" },
			{ "width": "30%" } 
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
 
	let apps=[];
	dt.allAppsUsed.forEach((d)=>{
 
	let thisorg=dt.applicationsUsedbyOrgUser.find((e)=>{
		return e.id==d.id
	})
	if(thisorg){thisorg='App Org User'}else{thisorg=''}

	let thisproc=dt.applicationsUsedbyProcess.find((e)=>{
		return e.id==d.id
	})
	if(thisproc){thisproc='Process'}else{thisproc=''}

	if(thisproc =='' &amp;&amp; thisorg==''){thisproc='Indirect'}

	apps.push({"id":d.id,"name":d.name,"description":d.description,"org":thisorg,"proc":thisproc, "parent":""})
	
	let appHTML

	if(d.class!='Application_Provider_Interface'){
		 appHTML=appTemplate({"id":d.id,"name":d.name,"description":d.description,"org":thisorg,"proc":thisproc, "className":"Application_Provider"})
	}else{
		appHTML=appTemplate({"id":d.id,"name":d.name,"description":d.description,"org":thisorg,"proc":thisproc, "className":"Application_Provider_Interface"})

	}
 
	d['appHTML']=appHTML;

}); 
// Map through allAppsUsedParent and add properties
dt.allAppsUsedParent = dt.allAppsUsedParent.map(d => {
    apps.push({
        "id": d.id,
        "name": d.name,
        "description": d.description,
        "org": "Parent",
        "proc": "",
        "parent": "Parent"
    });
    
    return {
        ...d,
        appHTML: appTemplate({
            "id": d.id,
            "name": d.name,
            "description": d.description,
            "org": "Parent",
            "proc": "",
            "parent": "Parent",
            "className": "Application_Provider"
        })
    };
});

// Filter out apps that already exist in allAppsUsed
dt.allAppsUsedParent = dt.allAppsUsedParent.filter(parentApp => 
    !dt.allAppsUsed.some(app => app.id === parentApp.id)
);

// Merge allAppsUsed with allAppsUsedParent
dt.allAppsUsed = dt.allAppsUsed.concat(dt.allAppsUsedParent);


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
			data: dt.allAppsUsed,
			responsive: true,
			columns: [
				{ data: "appHTML", width: "250px" },
				{ data: "description", width: "800px" }
			],
			dom: 'Bfrtip',
			buttons: [
				'copyHtml5', 
				'excelHtml5',
				'csvHtml5',
				'pdfHtml5',
				'print'
			],
			// Initial filter to hide rows with "parent" in the "appHTML" column
			initComplete: function() {
				this.api().column(0).search('^((?!parent).)*$', true, false).draw();
			}
		});

		$("input[name='parentFilter']").change(function() {
			if ($(this).val() == "withoutParent") {
				apptable.column(0).search('^((?!parent).)*$', true, false).draw();
			} else {
				apptable.column(0).search('').draw();
			}
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
		$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ $($.fn.dataTable.tables(true)).DataTable() .columns.adjust(); } );
  		
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
		
<xsl:template match="node()" mode="products">
		<xsl:variable name="thisProductType" select="$productType[name=current()/own_slot_value[slot_reference='instance_of_product_type']/value]"></xsl:variable>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"productType":[<xsl:for-each select="$thisProductType">{
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],	
		"processes":[<xsl:for-each select="own_slot_value[slot_reference='product_implemented_by_process']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
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
			let menuName = null;
			if(instance.meta?.anchorClass) {
				menuName = esslinkMenuNames[instance.meta.anchorClass];
			} else if(instance.className) {
				menuName = esslinkMenuNames[instance.className];
			}
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
