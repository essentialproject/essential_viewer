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
				<title><xsl:value-of select="eas:i18n('Summary')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css?release=6.19" type="text/css" rel="stylesheet"></link>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css?release=6.19" media="screen" rel="stylesheet" type="text/css"></link>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js?release=6.19" type="text/javascript"></script>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js?release=6.19" type="text/javascript"></script>

				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css?release=6.19"/>

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
						width: 140px;
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

					.node rect {
						fill: #fff; /* White background */
						stroke: steelblue; /* Blue border */
						stroke-width: 2px;
						rx: 10; /* Rounded corners */
						ry: 10;
					}

					/* Styling for the text inside the nodes */
			 
					.node text {
						font: 11px sans-serif;
						text-anchor: middle; /* Center the text horizontally */ 
					}
			
					/* Styling for the connecting lines */
					.link {
						fill: none;
						stroke: #ccc;
						stroke-width: 2px;
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
				<script src='js/d3/d3.v5.9.7.min.js'></script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>

				<!--ADD THE CONTENT-->
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

		<div class="container-fluid" id="summary-content">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
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
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<div class="ess-string">{{{this.description}}}</div>
									<div class="clearfix bottom-10"></div>
									<label><xsl:value-of select="eas:i18n('Parent Organisation(s)')"/></label>
									<ul class="ess-list-tags">
									{{#each this.parents}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
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
									<h3 class="text-primary"><i class="fa fa-table right-10"></i><xsl:value-of select="eas:i18n('Organisation Hierarchy')"/></h3><span id="hierarchyInfo"><label class="label label-warning">No hierarchy defined for this organisation</label></span>
									<div class="bottom-10"><div class="pull-right"> 
										<!--<button class="btn btn-sm btn-secondary" id="download-svg"><i class="fa fa-cloud-download"/></button>
										-->
									</div>
										<div id="orgchart"/>
										<div class="chart-container" style=" padding-top:10px; width:100%; height:1800px "> </div>
									</div>

								</div>  
							 
						</div>
						<div class="tab-pane" id="processes">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-globe right-10"></i>Business Processes</h2>
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Business Processes</h3>
									<div class="ess-blobWrapper">
									 {{#each this.allBusProcs}}
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
									{{/each}}	
									</div>
								</div>
							</div>
						
			 			<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Process Implementations</h3>
									Application Mapping Key: <label class="label   ess-mini-badge" style="background-color: rgb(170, 194, 213);color:#000">Direct to Process</label><xsl:text> </xsl:text><label class="label  ess-mini-badge" style="background-color:rgb(210, 169, 190);color:#000">Via Application Service</label>
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
                                                    <th>
														<xsl:value-of select="eas:i18n('Organisation Performing')"/>
													</th>
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
                                                        <td>
															<ul class="ess-list-tags"> 
																	<li class="roleBlob" style="background-color: rgb(132, 213, 237)">{{this.org}}</li> 
															</ul> 
															
														</td>
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

												{{/each}}

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Process')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Organisation Performing')"/>
													</th>
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
										<li>Public</li>
										<li>Public</li>
										<li>Public</li>
										<li>Public</li>
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
		let processSet = new Promise(function(myResolve, myReject) {	 
			 
						
						procTable = $('#dt_supportedprocesses').DataTable({
						scrollY: "350px",
						scrollCollapse: true,
						paging: true,
						info: false,
						pageLength: 5,
						sort: true,
						responsive: true,
						columns: [
							{ "width": "40%" },
							{ "width": "15%" },
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
									that
										.search( this.value )
										.draw();
								}
							} );
						} );


					
						
					
						
					 
			myResolve(); // when successful
			myReject();  // when error
			});
		
			processSet.then(function(response) {  
						procTable.columns.adjust();
						
						$(window).resize( function () {
							procTable.columns.adjust();
						});
						procTable.columns.adjust().draw();
						 

			})
		 
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
	  var appsData=[];
	  var orgOptions='';
	  var processLookupObj;
	  var focusID="<xsl:value-of select='eas:getSafeJSString($param1)'/>";
	  var rolesFragment, appsnippetTemplate, appsnippetFragment, appsFragment, processesFragment, sitesFragment, rolesTemplate, appsTemplate, processesTemplate,sitesTemplate ;
	
			$('document').ready(function () {
				
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
				let orgRoles=[];		
				   orgData=responses[0].orgData; 

				   orgData.forEach((o)=>{
						orgOptions=orgOptions+'<option value="'+o.id+'">'+o.name+'</option>'
				   })

				   function createOrgChart(org, orgData) {
					const orgChart = {
						id: org.id,
						name: org.name,
						description: org.description,
						parentOrgs: org.parentOrgs,
						childOrgs: [],
						allChildOrgs: org.allChildOrgs,
						parents: org.parents
					};
				
					// Find child organisations recursively
					org.childOrgs.forEach(childId => {
						const childOrg = orgData.find(item => item.id === childId);
						if (childOrg) {
							orgChart.childOrgs.push(createOrgChart(childOrg, orgData));
						}
					});
				
					return orgChart;
				}
				
				function createFullHierarchy(orgData) {
					const hierarchies = {};
				
					// Create hierarchy for every org in the array
					orgData.forEach(org => {
						hierarchies[org.id] = createOrgChart(org, orgData);
					});
				
					return hierarchies;
				}
				const fullHierarchy = createFullHierarchy(orgData);
console.log('fullHierarchy',fullHierarchy);


				   console.log('orgOptions',orgOptions)
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

				   console.log('appData',appData)
				  let orgProductTypes=[];
			
				   products.forEach((prod)=>{
				 
					   prod.processes.forEach((e)=>{
						
							let thisMatch=physProc.process_to_apps.filter((p)=>{
								return p.id == e;
							});
					 	   console.log('thisMatch',thisMatch)
							if(thisMatch){ 
								thisMatch.forEach((m)=>{
									 
									if(m['product']){
										m['product'].push(prod.name); 
									}
									else
									{
										m['product']=[prod.name];	
									} 
								})
							 
							}
						 
					   })
					   
				   })
  
				   modelData=[]
				   console.log(orgData)
				   orgData.forEach((d)=>{
  
					 if(orgRoles.length&gt;0){
						let thisRoles=orgRoles.find((or)=>{
							return or.id==d.id;
						});
						if(thisRoles){
							d['orgRoles']=thisRoles.roles;
						};
					 };

					let parent=[];
					let childrenOrgs=[];
					d.parentOrgs.forEach((e)=>{
						let thisParent=orgData.find((f)=>{
							return f.id == e
						}); 
						if(thisParent){
						parent.push({"name":thisParent.name,"id":thisParent.id})	
						}
					})
					d['parents']=parent; 
					if(d.childOrgs){
						d.childOrgs.forEach((e)=>{ 
							let thisChild=orgData.find((f)=>{
								return f.id == e
							});  
							childrenOrgs.push({"name":thisChild.name,"id":thisChild.id})	
						})
					}
					d['childrenOrgs']=childrenOrgs;

					   let allAppsUsed=[];
					   let allBusProcs=[];
					   let allSubOrgs=[];
					   let allSites=[];
					   let allAppsUsedParent=[];
					   let allBusProcsParent=[];
					   let allParentOrgs=[];
					   let allSitesParent=[];
		
					   d.applicationsUsedbyOrgUser.forEach((e)=>{
						 allAppsUsed.push(e)
					   })
					   d.applicationsUsedbyProcess.forEach((e)=>{
						allAppsUsed.push(e)
					  });
 		 	 
					  d.businessProcess?.forEach((e)=>{
						  e['className']='Business_Process';
						allBusProcs.push(e)
					  }); 
			 	
					  if(d.site){
						d.site.forEach((e)=>{
							allSites.push(e)
						});
						}
						
					 if(d.parentOrgs?.length&gt;0){
						d.parentOrgs?.forEach((e)=>{	
							let thisOrg=orgData.find((f)=>{
								return f.id == e
							});
						 if(thisOrg){
							allParentOrgs.push({"id":thisOrg.id, "name":thisOrg.name}) 
							  }
							
							getParents(thisOrg, allAppsUsedParent, allBusProcsParent, allParentOrgs, allSitesParent)
						
						   });
						  
						 } 

						if(d.childOrgs?.length&gt;0){

					   d.childOrgs.forEach((e)=>{
					 
						let thisOrg=orgData.find((f)=>{
							return f.id == e
						});
					 
						allSubOrgs.push({"id":thisOrg.id, "name":thisOrg.name}) 
				
						getChildren(thisOrg, allAppsUsed, allBusProcs, allSubOrgs, allSites)
						  
					   })
					   
					}
					
					   allAppsUsed=allAppsUsed.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allAppsUsedParent=allAppsUsedParent.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)

					   allBusProcs=allBusProcs.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allSubOrgs=allSubOrgs.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allSites=allSites.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   let appList=[]; 
					   let parentappList=[]; 
					   allAppsUsedParent = allAppsUsedParent.filter(x => !allAppsUsed.includes(x)); 
					   let appsAndAPIs= [...appData.applications, ...appData.apis]; 
					   allAppsUsed.forEach((ap)=>{ 
						   let thisApp=appsAndAPIs.find((e)=>{
							   return e.id == ap.id;
						   })
						   appList.push(thisApp)
					   });
 
					   allAppsUsedParent.forEach((ap)=>{ 
						let thisApp=appData.applications.find((e)=>{
							return e.id == ap.id;
						})
						parentappList.push(thisApp)
						})
	 
					   d['allAppsUsedParent']=parentappList;
					   d['allAppsUsed']=appList;
					   d['allBusProcs']=allBusProcs;
					   d['allChildren']=allSubOrgs;
					   d['allSites']=allSites;
						 //  $('.selectOrgBox').append('&lt;option value='+d.id+' >'+d.name+'&lt;option>');
					
					});

					<!--- HERE   --> 
					redrawPage(focusID)
 
				})
				.catch (function (error) {
					//display an error somewhere on the page   
				});
				
	  
			});

		
		 
				// Function to create hierarchy for selected id
				
				
				// Function to create hierarchy for selected id (handling both parents and children)
				function createOrgChart(orgId, orgData, visited = new Set(), depth = 0, maxDepth = 10) {
					if (visited.has(orgId) || depth > maxDepth) {
						return null; // Prevent infinite recursion or deep stack issues
					}
		
					const org = orgData.find(item => item.id === orgId);
					if (!org) {
						return null;
					}
		
					visited.add(orgId); // Mark the node as visited
		
					const chart = {
						id: org.id,
						name: org.name,
						description: org.description,
						parentOrgs: org.parentOrgs,
						children: org.childOrgs.map(childId => {
							const childOrg = orgData.find(item => item.id === childId);
							return createOrgChart(childOrg.id, orgData, visited, depth + 1, maxDepth);
						}).filter(child => child !== null),
						parents: org.parentOrgs.map(parentId => {
							const parentOrg = orgData.find(item => item.id === parentId);
							return createOrgChart(parentOrg.id, orgData, visited, depth + 1, maxDepth);
						}).filter(parent => parent !== null)
					};
		
					visited.delete(orgId); // Allow this org to be revisited in other branches
					return chart;
				}
		
				// Create a visualisation of the org chart using D3.js
				function drawOrgChart(orgChartData) { 
					const windowHeight = $(window).innerHeight();
					const svgContainer = d3.select("#orgchart")
					.append("svg")
					.attr("id", "orgChartSvg")
					.attr("width", "800px")
					.attr("height", windowHeight - 200);
	
					console.log('orgChartData',orgChartData)
					$('#hierarchyInfo').hide();
				const g = svgContainer.append("g");
	
				const treeLayout = d3.tree().nodeSize([180, 100]); // Adjust spacing here for closer nodes
	
				// Generate the hierarchy from the selected org data
				const root = d3.hierarchy(orgChartData);
				treeLayout(root);
	
				// Get the bounding box for the tree layout (to dynamically resize the SVG)
				const minX = d3.min(root.descendants(), d => d.x);
				const maxX = d3.max(root.descendants(), d => d.x);
				const minY = d3.min(root.descendants(), d => d.y);
				const maxY = d3.max(root.descendants(), d => d.y);
	
				let width = maxX - minX + 200; // Add padding
				const height = maxY - minY + 200; // Add padding

				const parentWidth = $('#orgchart').parent().width();
				const screenWidth = $(window).width();
			 
				if (width > 1000) { 
					width = screenWidth - 300; 
				  }
				 
				svgContainer
					.attr("width", width)
					.attr("height", height);
	
				g.attr("transform", `translate(${(width / 2) - (minX + maxX) / 2}, ${100 - minY})`); // Center the chart
	
				// Implement zoom behavior
				const zoom = d3.zoom()
					.scaleExtent([0.1, 6]) // Set zoom range (min and max zoom)
					.on("zoom", function() {
						g.attr("transform", d3.event.transform); // Update the transform on zoom
					});
	
				// Apply the zoom behavior to the SVG container
				svgContainer.call(zoom);
	
				// Draw links between nodes using right-angle connectors
				g.selectAll(".link")
					.data(root.links())
					.enter()
					.append("path")
					.attr("class", "link")
					.attr("d", d => `
						M${d.source.x},${d.source.y}
						V${(d.source.y + d.target.y) / 2}
						H${d.target.x}
						V${d.target.y}
					`)  // Right-angle path generation
					.attr("fill", "none")
					.attr("stroke", "#ccc")
					.attr("stroke-width", 2); // Line styles applied directly
	
				// Draw nodes
				const node = g.selectAll(".node")
					.data(root.descendants())
					.enter()
					.append("g")
					.attr("class", "node")
					.attr("transform", d => "translate(" + d.x + "," + d.y + ")");
	
				// Add rounded rectangle for each node
				node.append("rect")
					.attr("width", 120)
					.attr("height", 50)
					.attr("x", -60)  // Center the rect horizontally
					.attr("y", -25)  // Center the rect vertically
					.attr("rx", 10)  // Rounded corners for width
					.attr("ry", 10)  // Rounded corners for height
					.attr("fill", "#fff")  // White background color
					.attr("stroke", "steelblue")  // Blue border
					.attr("stroke-width", 2);  // Stroke width
	
				// Add text inside each node
				node.append("text")
					.attr("x", 0) // Center the text horizontally
					.attr("y", -5) // Slightly above the center
					.text(d => d.data.name);
				}
		 
var selectedOrgChart

function redrawPage(focusOrg){ 
console.log('focusOrg', focusOrg)
console.log('orgData', orgData)
	 selectedOrgChart = createOrgChart(focusOrg, orgData);
	console.log('selectedOrgChart', selectedOrgChart)


	let toShow = orgData.find((e)=>{
		return e.id == focusOrg;
		})

		toShow['parentNodeId']=null;
		  
		  let appProcMap=[];
		  orgProductTypes=[]; 
		 
		  toShow.allBusProcs.forEach((e)=>{ 
			let thisProcess=physProc.process_to_apps.filter((f)=>{
				return e.id == f.processid;
			});


			if(thisProcess){
				thisProcess.forEach((pr)=>{
				 
				pr['criticality']=e.criticality;
				pr['caps']= processLookupObj[pr.processid] || '';
				appProcMap.push(pr)
				if(thisProcess.product){
				orgProductTypes=[...orgProductTypes, ...pr.product];
				}
				})
			}

			appProcMap = appProcMap.filter((ap)=>{
				return toShow.id == ap.orgid;
			});

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
		
		toShow['physicalProcesses']=[...parentProcs, ...childProcs, ...appProcMap]
		toShow.physicalProcesses=toShow.physicalProcesses.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
		
		toShow.physicalProcesses.sort((a,b) => (a.processName > b.processName) ? 1 : ((b.processName > a.processName) ? -1 : 0))
		toShow.physicalProcesses.forEach(pp => {
			pp.appsdirect = pp.appsdirect.map(app => ({ ...app, appName: app.name }));
		
			pp.appsviaservice = pp.appsviaservice.map(app => {
				let thisApp = appData.applications.find(fa => fa.id == app.appid);
				return thisApp ? { ...app, appName: thisApp.name } : app;
			});
		});
		
 var docSort = d3.nest()
	 .key(function(d) { return d.index; })
	 .entries(toShow.documents);
  toShow.documents=docSort;
  console.log('to', toShow)

 drawView(toShow, modelData);

}			
  
function getChildren(arr, allApp, allBus, allOrgs, allSites){ 
	if(arr.applicationsUsedbyOrgUser){
		arr.applicationsUsedbyOrgUser.forEach((f)=>{
			allApp.push(f)
	  }) 
	   }
	   if(arr.applicationsUsedbyProcess){
		arr.applicationsUsedbyProcess.forEach((f)=>{
			allApp.push(f)
	  })
	   } 
	   if(arr.businessProcess){
		arr.businessProcess.forEach((e)=>{
		allBus.push(e)
	  });
	} 
	if(arr.site.length&gt;0){
		arr.site.forEach((e)=>{
			allSites.push(e)
		  });
	}
	if(arr.childOrgs){ 
		if(arr.length&gt;0){
		arr.childOrgs?.forEach((e1)=>{  
			let thisOrg=orgData.find((f)=>{
				return f.id == e1
			}); 
			allOrgs.push({"id":thisOrg.id, "name":thisOrg.name})
			getChildren(thisOrg, allApp, allBus, allOrgs, allSites)
		})
		}
	}
	
}	

function getParents(arr, allApp, allBus, allOrgs, allSites){ 
 
 
	if(arr.applicationsUsedbyOrgUser){
		arr.applicationsUsedbyOrgUser.forEach((f)=>{
			allApp.push(f)
	  }) 
	   }
	 
	   if(arr.applicationsUsedbyProcess){
		arr.applicationsUsedbyProcess.forEach((f)=>{
			allApp.push(f)
	  })
	   }
	     
	   if(arr.businessProcess){
		arr.businessProcess.forEach((e)=>{
		allBus.push(e)
	  });
	} 
	if(arr.site.length&gt;0){
		arr.site.forEach((e)=>{
			allSites.push(e)
		  });
	}
 
	if(arr.childOrgs){ 
 
		if(arr.length&gt;0){
		arr.parentOrgs?.forEach((e1)=>{  
			let thisOrg=orgData.find((f)=>{
				return f.id == e1
			}); 
 
			if(thisOrg){
			allOrgs.push({"id":thisOrg.id, "name":thisOrg.name})
			}
			getParents(thisOrg, allApp, allBus, allOrgs, allSites)
		})
		 }
	}
 
}			
			
function drawView(orgToShowData, modelData){  
	$('#mainPanel').html(panelTemplate(orgToShowData))
	$('#subjectSelection').append(orgOptions); 
	$('#subjectSelection').select2(); 
 
	$('#subjectSelection').val(orgToShowData.id).trigger('change');
 
	drawOrgChart(selectedOrgChart);
/*
	document.getElementById("download-svg").addEventListener("click", function() {
		const svg = document.getElementById("orgChartSvg");
		const serializer = new XMLSerializer();
		const svgString = serializer.serializeToString(svg);

		const svgBlob = new Blob([svgString], { type: "image/svg+xml;charset=utf-8" });
		const url = URL.createObjectURL(svgBlob);

		// Create a download link for the SVG
		const link = document.createElement("a");
		link.href = url;
		link.download = "org_chart.svg";
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);

		URL.revokeObjectURL(url); // Clean up
	});
*/
	initPopoverTrigger();
	initTable(orgToShowData);
	console.log('modelData', modelData)
	$('#subjectSelection').off().on('change', function(){
		modelData=[] 
		redrawPage($(this).val());
	})
}
 
function initTable(dt){
	$('#dt_supportedprocesses tfoot th').each( function () {
				 
		var protitle = $(this).text(); 
		$(this).html( '&lt;input class="procIn" type="text" placeholder="Search '+protitle+'" /&gt;' );
	
	});

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
