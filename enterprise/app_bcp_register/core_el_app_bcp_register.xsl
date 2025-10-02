<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:include href="../../common/core_doctype.xsl"/>
	<xsl:include href="../../common/core_common_head_content.xsl"/>
	<xsl:include href="../../common/core_header.xsl"/>
	<xsl:include href="../../common/core_footer.xsl"/>
	<xsl:include href="../../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../../common/datatables_includes.xsl"/>
	<xsl:include href="../../common/core_handlebars_functions.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>



	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Group_Actor', 'Composite_Application_Provider', 'Site')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[own_slot_value[slot_reference = 'cct_for_classes']/value = 'Application_Provider']"/>
	
	<xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
	
	<xsl:variable name="costPurposeTax" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Tech Cost Purposes')]"/>
	<xsl:variable name="allCostPurposes" select="/node()/simple_instance[name = $costPurposeTax/own_slot_value[slot_reference = 'taxonomy_terms']/value]"/>
	
	<xsl:variable name="appBCPDatasetAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Resiliency Data']"/>
	
	<xsl:variable name="appBCPAPIPath">
		<xsl:call-template name="RenderAPILinkText">  <!-- change to RenderAPILinkTextTestingNoCache for local testing -->
			<xsl:with-param name="theXSL" select="$appBCPDatasetAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>
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

	<xsl:variable name="DEBUG" select="''"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent">
					<xsl:with-param name="requiresDataTables" select="false()"/>
				</xsl:call-template>
				<xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<!-- <xsl:call-template name="dataTablesLibrary"/> -->
				<!-- <link rel="stylesheet" type="text/css" href="js/DataTables/checkboxes/dataTables.checkboxes.css"/>
				<script src="js/DataTables/checkboxes/dataTables.checkboxes.min.js"/> -->
				
				<!-- D3 Library -->
				<script type="text/javascript" src="https://d3js.org/d3.v7.min.js"></script>
				
				<!-- Blast Radius Rendering Helper Functions -->
				<script type="text/javascript" src="enterprise/app_bcp_register/core_blast_radius_graph.js"></script>
				
				<!-- Chart JS Library -->
				<script src="js/chartjs/Chart.min.js"></script>
				<script src="js/chartjs/chartjs-plugin-labels.min.js"></script>
				
				<!-- Date manipulation and formatting library -->
				<script type="text/javascript" src="js/moment/moment.js"/>

				<!-- Slider Library -->
				<link rel="stylesheet" type="text/css" href="js/nouislider/2025/nouislider.min.css"/>
				<script src="js/nouislider/2025/nouislider.min.js"/>
				<script src="js/DataTables/2.1.8/datatables.min.js"/>

				<link href="js/DataTables/2.1.8/datatables.min.css" rel="stylesheet"/>
				<script type="text/javascript" src="js/DataTables/2.1.8/datatables.min.js"></script>

				<!-- eCharts Library -->
				<!-- <script type="text/javascript" src="user/js/echarts.min.js"/> -->

				
				<!-- Add the month picker libraries if not already included as part of roadmap enablement -->
				 
				<link href="js/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />
				<link href="js/jquery-ui/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" />
				<link href="js/jquery-ui-month-picker/MonthPicker.min.css" rel="stylesheet" type="text/css" />
				<script type="text/javascript" src="js/jquery.maskedinput.min.js"/>
				<script type="text/javascript" src="js/jquery-ui-month-picker/MonthPicker.min.js"/>
			 
				
				<link rel="stylesheet" href="js/yearpicker/yearpicker.css"/>
				<script type="text/javascript" src="js/yearpicker/yearpicker.js"/>
				
				<link rel="stylesheet" href="js/select2/css/select2.min.css"/>
				<script type="text/javascript" src="js/select2/js/select2.min.js"/>
				
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Application BCP Dashboard')"/></title>
				<script>
					$(document).ready(function(){
						$('#toggle-filter').click(function(){
							$(this).toggleClass('fa-caret-down');
							$(this).toggleClass('fa-caret-right');
							$(this).parent().next().slideToggle();
						});
					});
				</script>
				<style>
					.ess-section-title {
						font-size: 16px;
						border-bottom: 1px solid #ddd;
						padding-bottom: 5px;
						text-transform: uppercase;
						font-weight: 300;
					}
					.chart-wrapper{
						min-height: 300px;
						overflow: hidden;
						position: relative;
					}
					#type-criticality-pie,#type-criticality-bar,#prim-sol-type-chart-pie,#prim-sol-type-chart-bar,#delivery-chart-pie,#delivery-chart-bar,#codebase-chart-pie,#codebase-chart-bar {
						position: absolute;
						transition: left 1s, right 1s;
					}
					#type-criticality-bar,#prim-sol-type-chart-bar,#codebase-chart-bar,#delivery-chart-bar {
						right: -1000px;
					}
					#toggle-filter {width: 16px;}
					.cost-year-picker {width: 80px!important;}
					.filter-title {text-transform: uppercase; display: inline-block; margin-right: 15px; min-width: 150px;}
					
					.inline-block {display: inline-block;}

					.focus-bcp-evt {
						color: #c79dcc;
					}

					.ess-string{
					    background-color: #f6f6f6;
					    padding: 5px;
					    display: inline-block;
					}

					.duration-d-flex {
						display: flex;
						gap: 10px;
						flex-wrap: wrap;
					}
					.duration-d-flex > div {
						width: 60px;
					}

					.ess-duration-clr-btn {
						height: 35px;
					}

					.duration-filter-lbl {
						vertical-align: bottom;
						font-weight: 700;
					}

					/*** Detail container**/
					  #ess-event-blast-radius-node-dets .card {
						background-color:#ffffff;
						border-radius: 8px;
						border: 1px solid #eee;
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.25);
					  }
					  #ess-event-blast-radius-node-dets .card .c-header {
						padding: 5px;
						background-color: #f6f6f6;
						line-height: 1.1em;
						width: 100%;
						position: relative;
					  }
					  #ess-event-blast-radius-node-dets .card .c-header .label {
						position: absolute;
						top: 5px;
						right: 5px;
					  }
					  #ess-event-blast-radius-node-dets .card .c-body {
						padding: 0;
						font-size: 90%;
						line-height: 1.1em;
						color: #5c5c5c;
						max-height: 200px;
						overflow-y: auto;
					  }
					  #ess-event-blast-radius-node-dets .card .c-footer {
						height: 3vh;
						background-color: #f6f6f6;
						border-radius: 0 0 15px 15px;
						display: flex;
						justify-content: center;
						align-items: center;
						 
					  }
					  #ess-event-blast-radius-node-dets .card .c-footer p {
						font-size: 0.8em;
						margin-bottom: 0;
						font-weight: 800;
					  }
					  #ess-event-blast-radius-node-dets .card .c-footer .footer-badge {
						font-size: 0.5em;
						background-color: #69c9ff;
					  }
					  .label-dark {
						background-color: #666;
					  }
				</style>
				<!-- ***REQUIRED*** ADD THE JS LIBRARIES IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
				 
			</head>
			<body class="bg-offwhite">
				<!--<xsl:call-template name="RenderRoadmapWidgetButton"/>-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
			 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application BCP Dashboard')"/></span>
								</h1><xsl:value-of select="$DEBUG"/>
							</div>
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<div class="col-md-12">
							<div class="panel panel-default">
								<div class="panel-body">
									<div class="eas-logo-spinner top-20">
										<div class="spin-icon">
											<div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
											<div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
											<div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
										</div> 
										<div class="spin-text"><xsl:value-of select="eas:i18n('Loading...')"/></div>
									</div>
									<div class="ess-section-title bottom-10"><i id="toggle-filter" class="fa fa-caret-right"/><xsl:value-of select="eas:i18n('Dashboard Settings/Filters')"/></div>
									<div class="filter-section hiddenDiv">
										<div class="row">
											<div class="col-md-12">
												<div class="filter-title"><xsl:value-of select="eas:i18n('Application Scope')"/></div>
												<!-- <input id="ess-show-bcp-profiled" type="checkbox" class="left-5 right-20 cost-type-chkbx" checked="checked"></input>
												<label><xsl:value-of select="eas:i18n('Show Profiled Apps')"/></label>	 -->
												<input id="ess-show-non-bcp-profiled" type="checkbox" class="left-5 right-20 cost-type-chkbx"></input>
												<label><xsl:value-of select="eas:i18n('Show Apps Without BCP Profile')"/></label>									
											</div>
											<div class="col-md-12 top-20">
												<div class="filter-title"><xsl:value-of select="eas:i18n('BCP Risk Thresholds')"/></div>
												<div>
													<div id="buscap-risk-th-slider" class="inline-block"></div>
													<label class="inline-block left-30">Low Risk:</label>
													<input id="bc-low-risk-thresh" class="form-control inline-block left-5"/>
													<label class="inline-block">or Fewer Apps</label>
													<label class="inline-block left-30">Medium Risk:</label>
													<input id="bc-med-risk-thresh" class="form-control inline-block left-5"/>
													<label class="inline-block">or Fewer Apps</label>
												</div>
											</div>
											<div class="col-md-4 top-20">
												<div class="filter-title"><xsl:value-of select="eas:i18n('Recovery Point Objective Filter')"/></div>
												<div>
													<div class="duration-d-flex top-10">
														<span class="duration-filter-lbl right-10">More Than/Equal To:</span>
														<div>
															<input eas-type="rpo" eas-prop="days" value="0" type="number" step="1" min="0" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">days</span>
														</div>
														<div>
															<input eas-type="rpo" eas-prop="hours" value="0" type="number" step="1" min="0" max="23" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">hours</span>
														</div>
														<div>
															<input eas-type="rpo" eas-prop="minutes" value="0" type="number" step="1" min="0" max="59" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">mins</span>
														</div>
														<div>
															<input eas-type="rpo" eas-prop="seconds" value="0" type="number" step="1" min="0" max="59" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">secs</span>
														</div>
														<button eas-type="rpo" class="btn btn-primary left-10 ess-duration-clr-btn">Clear</button>
													</div>
												</div>
											</div>
											<div class="col-md-4 top-20">
												<div class="filter-title"><xsl:value-of select="eas:i18n('Recovery Time Objective Filter')"/></div>
												<div>
													<div class="duration-d-flex top-10">
														<span class="duration-filter-lbl right-10">More Than/Equal To:</span>
														<div>
															<input eas-type="rto" eas-prop="days" value="0" type="number" step="1" min="0" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">days</span>
														</div>
														<div>
															<input eas-type="rto" eas-prop="hours" value="0" type="number" step="1" min="0" max="23" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">hours</span>
														</div>
														<div>
															<input eas-type="rto" eas-prop="minutes" value="0" type="number" step="1" min="0" max="59" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">mins</span>
														</div>
														<div>
															<input eas-type="rto" eas-prop="seconds" value="0" type="number" step="1" min="0" max="59" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">secs</span>
														</div>
														<button eas-type="rto" class="btn btn-primary left-10 ess-duration-clr-btn">Clear</button>
													</div>
												</div>
											</div>
											<div class="col-md-4 top-20">
												<div class="filter-title"><xsl:value-of select="eas:i18n('Recovery Time Actual Filter')"/></div>
												<div>
													<div class="duration-d-flex top-10">
														<span class="duration-filter-lbl right-10">More Than/Equal To:</span>
														<div>
															<input eas-type="rta" eas-prop="days" value="0" type="number" step="1" min="0" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">days</span>
														</div>
														<div>
															<input eas-type="rta" eas-prop="hours" value="0" type="number" step="1" min="0" max="23" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">hours</span>
														</div>
														<div>
															<input eas-type="rta" eas-prop="minutes" value="0" type="number" step="1" min="0" max="59" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">mins</span>
														</div>
														<div>
															<input eas-type="rta" eas-prop="seconds" value="0" type="number" step="1" min="0" max="59" class="ess-duration-input form-control"/>
															<span class="ebfw-duration-lbl left-5">secs</span>
														</div>
														<button eas-type="rta" class="btn btn-primary left-10 ess-duration-clr-btn">Clear</button>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					    <div class="col-xs-12">
							<div class="row">
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-body">
											<div class="pull-right"><i class="fa fa-pie-chart right-10" id="show-criticality-pie"/><i class="fa fa-bar-chart" id="show-criticality-bar"/></div>
											<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('App Count by Criticality Tier')"/></div>
											<div class="chart-wrapper">
												<canvas id="type-criticality-pie" width="400" height="150"/>
												<canvas id="type-criticality-bar" width="400" height="150"/>
											</div>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-body">
											<div class="pull-right"><i class="fa fa-pie-chart right-10" id="show-prim-sol-type-pie"/><i class="fa fa-bar-chart" id="show-prim-sol-type-bar"/></div>
											<div class="ess-section-title bottom-10">App Count by Primary Solution Type</div>
											<div class="chart-wrapper">
												<canvas id="prim-sol-type-chart-pie" width="400" height="150"></canvas>
												<canvas id="prim-sol-type-chart-bar" width="400" height="150"></canvas>
											</div>
										</div>
									</div>
								</div>
								<div class="col-md-12">
									<div class="panel panel-default">
										<div class="panel-body">
											<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Top 10 Applications by RTA Differential')"/></div>
											<div class="chart-wrapper">
												<canvas id="top10-chart" width="400" height="100"></canvas>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- <div class="col-xs-12">
							<div class="row">
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-body">
											<div class="pull-right"><i class="fa fa-pie-chart right-10" id="show-codebase-pie"/><i class="fa fa-bar-chart" id="show-codebase-bar"/></div>
											<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Application Cost by Codebase')"/></div>
											<div class="chart-wrapper">
												<canvas id="codebase-chart-pie" width="400" height="150"></canvas>
												<canvas id="codebase-chart-bar" width="400" height="150"></canvas>
											</div>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-body">
											<div class="pull-right"><i class="fa fa-pie-chart right-10" id="show-delivery-pie"/><i class="fa fa-bar-chart" id="show-delivery-bar"/></div>
											<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Application Cost by Delivery Model')"/></div>
											<div class="chart-wrapper">
												<canvas id="delivery-chart-pie" width="400" height="150"></canvas>
												<canvas id="delivery-chart-bar" width="400" height="150"></canvas>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div> -->
						<div class="col-md-12">
							<div class="panel panel-default">
								<div class="panel-body">
									<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Business Capability View')"/></div>
									<div class="simple-scroller" id="bcmContainer"/>
								</div>
							</div>
						</div>
						<div class="col-md-12">
							<div class="panel panel-default">
								<div class="panel-body">
									<div class="ess-section-title bottom-10">Table View</div>
									<table id="dt_apps" class="table table-striped table-bordered" style="width: 7000px">
										<thead>
											<!-- <tr>
												<th><xsl:value-of select="eas:i18n('Application Name')"/></th>
												<th><xsl:value-of select="eas:i18n('Description')"/></th>
												<th><xsl:value-of select="eas:i18n('Criticality Tier')"/></th>
												<th><xsl:value-of select="eas:i18n('Tier Establishment Date')"/></th>
												<th><xsl:value-of select="eas:i18n('Restoration Order')"/></th>
												<th><xsl:value-of select="eas:i18n('RPO')"/></th>
												<th><xsl:value-of select="eas:i18n('RTO')"/></th>
												<th><xsl:value-of select="eas:i18n('RTA')"/></th>
												<th><xsl:value-of select="eas:i18n('RTA Differential')"/></th>
												<th><xsl:value-of select="eas:i18n('Last Event Date')"/></th>
												<th><xsl:value-of select="eas:i18n('Last Event Type')"/></th>
												<th><xsl:value-of select="eas:i18n('Next Test Date')"/></th>
												<th><xsl:value-of select="eas:i18n('Resiliency Solution Type')"/></th>
												<th><xsl:value-of select="eas:i18n('Service Owner')"/></th>
												<th><xsl:value-of select="eas:i18n('Hosting Locations')"/></th>
												<th><xsl:value-of select="eas:i18n('Document Last Updated')"/></th>
												<th><xsl:value-of select="eas:i18n('Notes')"/></th>
												<th><xsl:value-of select="eas:i18n('Supporting Data')"/></th>
												<th><xsl:value-of select="eas:i18n('Supporting Data Links')"/></th>
											</tr> -->
										</thead>
										<tfoot>
											<tr id="dt_apps_footer"></tr>
											<!-- <tr>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Name')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Description')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Tier')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Tier Date')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Order')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' RPO')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' RTO')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' RTA')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Differential')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Event Date')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Event Type')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Test Date')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Solution Type')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Service Owner')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Location')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Date')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Notes')"/></xsl:attribute></input>
												</th>
												<th>
													<input type = "text"><xsl:attribute name="placeHolder">Search<xsl:value-of select="eas:i18n(' Supporting Data')"/></xsl:attribute></input>
												</th>
												<th>&#160;</th>
											</tr> -->
										</tfoot>
										<tbody/>
									</table>
								</div>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- View Event Blast Radius Modal -->
				<div class="modal fade" id="ess-event-blast-radius-modal" tabindex="-1" role="dialog" aria-labelledby="ess-event-blast-radius-label">
					<div class="modal-dialog modal-lg" role="document">
						<div class="modal-content" id="ess-event-blast-radius-modal-content">
							<!-- <div class="modal-header">
								<p class="modal-title xlarge" id="{{id}}-edit-instance-label"><strong><span class="text-darkgrey">{{dictionary.editInstanceModalTitlePrefix}} </span><span class="ess-edit-multi-instance-name"></span></strong></p>
								<p>{{dictionary.editInstanceModalIntroPrefix}}<strong><span class="ess-edit-multi-instance-name"></span></strong></p>
							</div> -->
							<div id="ess-event-blast-radius-modal-container" class="modal-body">
								<div class="ess-section-title bottom-10"><i class="focus-bcp-evt fa fa-bullseye right-5"/>Event Blast Radius - <span id="ess-event-blast-radius-modal-lbl" class="strong"></span></div>
								<div class="row">
									<div class="col-xs-12 col-md-7 col-lg-7">
										<svg id="ess-event-blast-radius-svg" width="800" height="500"></svg>
									</div>
									<div class="col-xs-12 col-md-5 col-lg-5" id="ess-event-blast-radius-node-dets">
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" data-dismiss="modal" style="width:120px">Close</button>
							</div>
						</div>
					</div>
				</div>


				<!-- View Event Blast Radius Modal -->
				<div class="modal fade" id="ess-app-bcp-deps-modal" tabindex="-1" role="dialog" aria-labelledby="ess-app-bcp-deps-label">
					<div class="modal-dialog modal-lg" role="document">
						<div class="modal-content" id="ess-app-bcp-deps-modal-content">
							<!-- <div class="modal-header">
								<p class="modal-title xlarge" id="{{id}}-edit-instance-label"><strong><span class="text-darkgrey">{{dictionary.editInstanceModalTitlePrefix}} </span><span class="ess-edit-multi-instance-name"></span></strong></p>
								<p>{{dictionary.editInstanceModalIntroPrefix}}<strong><span class="ess-edit-multi-instance-name"></span></strong></p>
							</div> -->
							<div id="ess-app-bcp-deps-modal-container" class="modal-body">
								<div class="ess-section-title bottom-10">Application BCP Dependencies</div>
								<svg width="800" height="300"></svg>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" data-dismiss="modal" style="width:120px">Close</button>
							</div>
						</div>
					</div>
				</div>
				<div id="bcpSideNav" class="sidenav">
					<a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()">
						<i class="fa fa-times"></i> 
					</a>
					<br/> 
					<div id="bcpSideNavList"/> 
				</div> 

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
			<script>
				var catalogueTable, appLinkTemplate, docLinkTemplate, tableListTemplate, extDocLinkTemplate, appTableFooterTemplate, escapedTableListTemplate, appRTDiffTemplate, eventTypeTemplate, blastRadiusDetailTemplate;

				//utility function to check if two arrays have values in common
				function hasCommonElements(arr1,arr2) {
				   var bExists = false;
				   $.each(arr2, function(index, value){
				
				     if($.inArray(value,arr1)!=-1){
				        bExists = true;
				     }
				
				     if(bExists){
				         return false;  //break
				     }
				   });
				   return bExists;
				}
				
				<!-- Read only JSON objects -->
				var viewData = {};
				var allApplications, allEvents, allEventTypes = [];
				var elementsDictionary = {};
				var inScopeApplications = [];
				var dashFilters = {};
				const APP_RTO_RISK_THRESHOLDS = [
					{
						"label": "No Risk",
						"bgClr": "#12ae00",
						"txtClr": "#ffffff",
						"style": "no-bcp-risk",
						"lowerThreshold": 0,
						"upperThreshold": 0,
						"isRisk": false
					},
					{
						"label": "Low Risk",
						"bgClr": "#e7b416",
						"txtClr": "#1c1b19",
						"style": "risk-low-color",
						"lowerThreshold": 1,
						"upperThreshold": 1.25,
						"isRisk": true
					},
					{
						"label": "Medium Risk",
						"bgClr": "#db7b2b",
						"txtClr": "#ffffff",
						"style": "risk-med-color",
						"lowerThreshold": 1.25,
						"upperThreshold": 1.5,
						"isRisk": true
					},
					{
						"label": "High Risk",
						"bgClr": "#cc3232",
						"txtClr": "#ffffff",
						"style": "risk-high-color",
						"lowerThreshold": 1.5,
						"upperThreshold": 10000000, //TEMP HACK TO SIMPLIFY LOGIC
						"isRisk": true
					},
					{
						"label": "Not Defined",
						"bgClr": "#999999",
						"txtClr": "#ffffff",
						"style": "busRefModel-blob-noheatmap",
						"isRisk": false
					}
				];

				//var dashFilters.busCapLowThreshNumber = 3;
				//var dashFilters.busCapMedThreshNumber = 5;

				function initDashFilters() {
					dashFilters = essGetLocalEssentialInstanceSettings("Business_Continuity_Event");
					if(!dashFilters.busCapMedThreshNumber) {
						dashFilters = {
							"busCapLowThreshNumber": 3,
							"busCapMedThreshNumber": 5,
							"showNonBCPApps": false
						}
						saveBCPDashSettings();
					}
				}

				function saveBCPDashSettings() {
					essSaveLocalEssentialInstanceSettings("Business_Continuity_Event", dashFilters);
				}

				function initDurationFilters() {
					let durationFilters = dashFilters.durationFilters;
					let durationProps = ["days", "hours", "minutes", "seconds"];
					let durationTemplate = {
						"days": 0,
						"hours": 0,
						"minutes": 0,
						"seconds": 0
					}
					if(!durationFilters) {
						dashFilters.durationFilters = {
							"rpo": JSON.parse(JSON.stringify(durationTemplate)),
							"rto": JSON.parse(JSON.stringify(durationTemplate)),
							"rta": JSON.parse(JSON.stringify(durationTemplate)),
							"rtaDiff": JSON.parse(JSON.stringify(durationTemplate))
						}
						saveBCPDashSettings();
					}
					$('.ess-duration-input').each(function() {
						let duratonType = $(this).attr('eas-type');
						let duratonProp = $(this).attr('eas-prop');
						if(duratonType?.length > 0 &amp;&amp; duratonProp?.length > 0) {
							let durationVal = dashFilters.durationFilters[duratonType][duratonProp];
							$(this).val(durationVal);
						}
					})
					.on('change', function(evt) {
						let duratonType = $(this).attr('eas-type');
						let duratonProp = $(this).attr('eas-prop');
						let durationVal = $(this).val();
						if(durationVal?.length > 0 &amp;&amp; duratonType?.length > 0 &amp;&amp; duratonProp?.length > 0) {
							dashFilters.durationFilters[duratonType][duratonProp] = parseInt(durationVal);
							redrawView();
							saveBCPDashSettings();
						}
					});

					$('.ess-duration-clr-btn')
					.on('click', function(evt) {
						let duratonType = $(this).attr('eas-type');
						if(duratonType?.length > 0) {
							durationProps.forEach(prop => {
								$('.ess-duration-input[eas-type="' + duratonType + '"][eas-prop="' + prop + '"]').val(0);
								dashFilters.durationFilters[duratonType][prop] = 0;
							});
							redrawView();
							saveBCPDashSettings();
						}
					});
				}


				function initBusCapRiskThresholdSlider() {
					let slider = document.getElementById('buscap-risk-th-slider');

					noUiSlider.create(slider, {
						start: [dashFilters.busCapLowThreshNumber, dashFilters.busCapMedThreshNumber],
						step: 1,
						connect: [true, true, true],
						range: {
							'min': [1],
							'max': [10]
						}
					});

					let connect = slider.querySelectorAll('.noUi-connect');
					let classes = ['risk-low-color', 'risk-med-color', 'risk-high-color'];

					for (var i = 0; i &lt; connect.length; i++) {
						connect[i].classList.add(classes[i]);
					}

					let lowThreshNumber = document.getElementById('bc-low-risk-thresh');
					lowThreshNumber.value = dashFilters.busCapLowThreshNumber;
					let lowThreshRating = APP_RTO_RISK_THRESHOLDS[1];
					$('#bcm-risk-low-leg').css('background-color', lowThreshRating.bgClr);
					$('#bcm-risk-low-val').text(dashFilters.busCapLowThreshNumber);

					let medThreshNumber = document.getElementById('bc-med-risk-thresh');
					medThreshNumber.value = dashFilters.busCapMedThreshNumber;
					let medThreshRating = APP_RTO_RISK_THRESHOLDS[2];
					$('#bcm-risk-med-leg').css('background-color', medThreshRating.bgClr);
					$('#bcm-risk-med-val').text(dashFilters.busCapMedThreshNumber);

					let highThreshRating = APP_RTO_RISK_THRESHOLDS[3];
					$('#bcm-risk-high-leg').css('background-color', highThreshRating.bgClr);
					$('#bcm-risk-high-val').text(dashFilters.busCapMedThreshNumber);

					slider.noUiSlider.on('end', function (values, handle) {
						let value = values[handle];

						if (handle) {
							medThreshNumber.value = Math.round(value);
							$('#bcm-risk-med-val').text(medThreshNumber.value);
							$('#bcm-risk-high-val').text(medThreshNumber.value);
							dashFilters.busCapMedThreshNumber = medThreshNumber.value;
							//console.log("UPDATE LOW BC RISK THRESHOLD TO:" + value);
						} else {
							lowThreshNumber.value = Math.round(value);
							$('#bcm-risk-low-val').text(lowThreshNumber.value);
							dashFilters.busCapLowThreshNumber = lowThreshNumber.value;
							//console.log("UPDATE MEDIUM BC RISK THRESHOLD TO:" + value);
						}
						saveBCPDashSettings();
						addBusCapBCPRiskOverlays();
					});

					lowThreshNumber.addEventListener('change', function () {
						if(this.value &lt;= dashFilters.busCapMedThreshNumber) {
							dashFilters.busCapLowThreshNumber = this.value;
							slider.noUiSlider.set([dashFilters.busCapLowThreshNumber, null]);
							$('#bcm-risk-low-val').text(dashFilters.busCapLowThreshNumber);
							addBusCapBCPRiskOverlays();
							saveBCPDashSettings();
						} else {
							this.value = dashFilters.busCapLowThreshNumber;
						}
					});

					medThreshNumber.addEventListener('change', function () {
						if(this.value >= dashFilters.busCapLowThreshNumber) {
							dashFilters.busCapMedThreshNumber = this.value;
							slider.noUiSlider.set([null, dashFilters.busCapMedThreshNumber]);
							$('#bcm-risk-med-val').text(dashFilters.busCapMedThreshNumber);
							$('#bcm-risk-high-val').text(dashFilters.busCapMedThreshNumber);
							addBusCapBCPRiskOverlays();
							saveBCPDashSettings();
						} else {
							this.value = dashFilters.busCapMedThreshNumber;
						}
					});
				}


				//function to get the total cost of the applications supporting a given business capability
				function getBusCapBCPRisk(thisBusCap) {
					let appsForBusCap = inScopeApplications.filter(function(anApp) {
						return thisBusCap.applicationIds.includes(anApp.id);
					});

					let bcpProfiledApps = appsForBusCap.filter(app => app.rtoData &amp;&amp; app.rtaData);
					let bcpRiskApps = bcpProfiledApps.filter(app => app.rtoRiskRating?.isRisk);
			        
			        thisBusCap['applications'] = appsForBusCap;
					thisBusCap['bcpProfiledApps'] = bcpProfiledApps;
			        thisBusCap['bcpRiskApps'] = bcpRiskApps;
					thisBusCap['hasNoBCPAppRisk'] = true;
					if(appsForBusCap.length > 0) {
						// thisBusCap['hasNoBCPAppRisk'] = (appsForBusCap.length == bcpProfiledApps.length) &amp;&amp; (!bcpRiskApps.length > 0);
						thisBusCap['hasNoBCPAppRisk'] = !bcpRiskApps.length > 0;
					}
					 
			        return bcpRiskApps.length;		
				}
				
				function addBusCapBCPRiskOverlays() {
					//set the app counts and styles for Bus Cap blobs
					$('.busRefModel-blob').each(function(i, obj) {
					    let busCapId = $(this).attr('id');
					    let theBusCap = viewData.busCaps.find(function(aBusCap) {
					    	return aBusCap.id == busCapId;
					    });
					    if(theBusCap != null) {
					    	let bcpBusCapAppCount = 0
							let bcpRiskAppCount = getBusCapBCPRisk(theBusCap);
							if(theBusCap['applications']?.length > 0) {
								if(dashFilters.showNonBCPApps) {
									bcpBusCapAppCount = theBusCap['applications'].length;
								} else {
									bcpBusCapAppCount = theBusCap['bcpProfiledApps'].length;
								}
							}
					    	
					    	let bcpRiskAppCountId = '#' + busCapId + '-bcp-risk-app-text';
					    	if(bcpBusCapAppCount > 0) {					    		
					    		//$(infoId).removeClass('hiddenDiv');
					    		let popupId = '#' + busCapId + '_popup';
								//console.log('theBusCap',theBusCap)
					    		$(popupId).html(bcmPopupTemplate(theBusCap));	
								if(bcpBusCapAppCount == 1) {
									$(bcpRiskAppCountId).text(bcpBusCapAppCount + ' App');
								} else {
									$(bcpRiskAppCountId).text(bcpBusCapAppCount + ' Apps');
								}
					    	} else {
					    		$(bcpRiskAppCountId).text('-');
					    	}
					    	
							let noRiskThreshStyle = APP_RTO_RISK_THRESHOLDS[0];
							let lowThreshStyle = APP_RTO_RISK_THRESHOLDS[1];
							let medThreshStyle = APP_RTO_RISK_THRESHOLDS[2];
							let highThreshStyle = APP_RTO_RISK_THRESHOLDS[3];
					    	
							if(!bcpBusCapAppCount > 0) {
								$(this).attr('class', 'busRefModel-blob busRefModel-blob-noheatmap');
							} else if(theBusCap.hasNoBCPAppRisk) {
								$(this).attr('class', 'busRefModel-blob ' + noRiskThreshStyle.style);
							} else if((bcpRiskAppCount > 0) &amp;&amp; (bcpRiskAppCount &lt;= dashFilters.busCapLowThreshNumber)) {
					    		$(this).attr('class', 'busRefModel-blob ' + lowThreshStyle.style);
					    	} else if((bcpRiskAppCount > 0) &amp;&amp; (bcpRiskAppCount &lt;= dashFilters.busCapMedThreshNumber)) {
					    		$(this).attr('class', 'busRefModel-blob ' +  + medThreshStyle.style);
					    	} else if(bcpRiskAppCount > dashFilters.busCapMedThreshNumber) {
					    		$(this).attr('class', 'busRefModel-blob ' +  + highThreshStyle.style);
					    	} else {
								$(this).attr('class', 'busRefModel-blob busRefModel-blob-noheatmap');
							}
					    }
					});
				}

				const essClassDepsDict = {
					"Business_Continuity_Event": {
						"depProps": ["sites", "techNodes", "techProducts", "apps", "orgs"]
					},
					"Site": {
						"depProps": ["techNodes", "orgs"]
					},
					"Technology_Node": {
						"depProps": ["techNodes", "apps"]
					},
					"Technology_Product": {
						"depProps": ["apps"]
					},
					"Composite_Application_Provider": {
						"depProps": ["physProcs"]
					},
					"Group_Actor": {
						"depProps": ["physProcs"]
					},
					"Physical_Process": {
						"depProps": ["busProc", "org"]
					},
					"Business_Process": {
						"depProps": []
					}
				}

				const MAX_BLAST_RADIUS_DEPTH = 20;
				const BLAST_RADIUS_CHILD_PROP = "dependencies";

				function getElImpactBlastRadius(parent, child, childrenPropName, depIdList, depth) {
					if(child.className == 'Physical_Process') {
						//treat physical processes as leaf elements to avoid recursing orgs
						if(child.org &amp;&amp; !(depIdList.includes(child.org.id))) {
							depIdList.push(child.org.id);
							parent[childrenPropName].push(child.org);
						}
						if(child.busProc &amp;&amp; !(depIdList.includes(child.busProc.id))) {
							depIdList.push(child.busProc.id);
							parent[childrenPropName].push(child.busProc);
						}
					} else {
						if(parent &amp;&amp; !(depIdList.includes(child.id))) {
							depIdList.push(child.id);
							parent[childrenPropName].push(child);
						}
						if(depth &lt;= MAX_BLAST_RADIUS_DEPTH) {
							let depProps = essClassDepsDict[child.className]?.depProps;
							if(depProps?.length > 0) {
								child[childrenPropName] = [];
								depProps.forEach(dp => {
									let dpElements = child[dp];
									dpElements?.forEach(dpEl => {
										getElImpactBlastRadius(child, dpEl, childrenPropName, depIdList, depth + 1);
									});
								});
							}
						}
					}
				}

				function getBCPEventBlastRadius(bcpEvent) {
					bcpEvent[BLAST_RADIUS_CHILD_PROP] = [];
					getElImpactBlastRadius(null, bcpEvent, BLAST_RADIUS_CHILD_PROP, [], 0);
					console.log("UPDATED BLAST RADIUS FOR:", bcpEvent);
				}

				//function to set the rto diff rating of an app
				function setAppRTORiskRating(app) {
					if(app.rtoDuration &amp;&amp; app.rtaDuration) {
						app.rtoRiskRating = APP_RTO_RISK_THRESHOLDS[0]; 
						if(app.rtDiffRatio) {
							let thisRiskRating = APP_RTO_RISK_THRESHOLDS.find(rt => (app.rtDiffRatio > rt.lowerThreshold) &amp;&amp; (app.rtDiffRatio &lt;= rt.upperThreshold));
							app.rtoRiskRating = thisRiskRating;
						}
					} else {
						app.rtoRiskRating = APP_RTO_RISK_THRESHOLDS[4];
					}
				}

				//initialise the RTO/RTA Differential duration for a given app
				function initAppRTORTADifferential(app) {
					
					if(app.rpoData) {
						app.rpoDuration = moment.duration(app.rpoData);
					} else {
						app.rpoDuration = null;
					}
					if(app.rpaData) {
						app.rpaDuration = moment.duration(app.rpaData);
					} else {
						app.rpaDuration = null;
					}

					if(app.rtoData) {
						app.rtoDuration = moment.duration(app.rtoData);
					} else {
						app.rtoDuration = null;
					}
					if(app.rtaData) {
						app.rtaDuration = moment.duration(app.rtaData);
					} else {
						app.rtaDuration = null;
					}
					if(app.rtoDuration &amp;&amp; app.rtaDuration) {
						//console.log('RTO (secs) for ' + app.name, app.rtoDuration.as('seconds'));
						//console.log('RTA (secs) for ' + app.name, app.rtaDuration.as('seconds'));
						app.rtDiffDuration = moment.duration(app.rtoDuration.as('seconds') - app.rtaDuration.as('seconds'), 'seconds');
						let appRTOSecs = app.rtoDuration.as('seconds');
						let appRTASecs = app.rtaDuration.as('seconds');
						let rtDiffDurationSecs = appRTOSecs - appRTASecs;
						if(app.rtDiffDuration?.as('seconds') &lt; 0) {
							let rtDiffRatio = appRTASecs / appRTOSecs;
							app.rtDiffRatio =  Math.round((rtDiffRatio + Number.EPSILON) * 100) / 100;
						}
						//app.rtDiffDuration = app.rtoDuration.subtract(app.rtaDuration);
						//app.rtDiffDuration = moment().duration(app.rtoDuration.diff(app.rtaDuration));
					} else {
						app.rtDiffDuration = null;
					}
					setAppRTORiskRating(app);
				}
				
				//Initialise the data supporting the Dashboard
				function initDashboardData() {
					elementsDictionary = viewData.impactedElements;
					allApplications = Object.values(elementsDictionary.Composite_Application_Provider);
					allEvents = viewData.events;
					allEventTypes = viewData.eventTypes;
					let allDRModels = viewData.failoverModels;
					let allTiers = viewData.criticalityTiers;
					let allITServiceOwners = viewData.itServiceOwners;

					//Sort the events by date
					allEvents.sort(function(a, b){
			    		if (b.dateTime > a.dateTime) {return -1;}
					  	if (a.dateTime &lt; b.dateTime) {return 1;}
					  	return 0;
			    	});

					// connect up the impact data into a graph/tree
					setUpImpactsHierarchy();

					console.log('ALL APPLICATIONS', allApplications);
					//set the most recent event that impacts each app
					allApplications.forEach(anApp => {
						//console.log('SETTING APP DURATION PROPS', anApp);
						anApp.criticalityTier = allTiers.find(tier => tier.id == anApp.criticalityTierId);
						anApp.criticalityTierIds = [];
						if(anApp.criticalityTierId) {
							anApp.criticalityTierIds.push(anApp.criticalityTierId)
						}

						anApp.failoverModel = allDRModels.find(drm => drm.id == anApp.failoverModelId);
						anApp.failoverModelIds = [];
						if(anApp.failoverModelId) {
							anApp.failoverModelIds.push(anApp.failoverModelId)
						}

						anApp.itServiceOwner = allITServiceOwners.find(indiv => indiv.id == anApp.itServiceOwnerId);
						<!-- anApp.itServiceOwnerIds = [];
						if(anApp.itServiceOwnerId) {
							anApp.itServiceOwnerIds.push(anApp.itServiceOwnerId)
						} -->

						initAppRTORTADifferential(anApp);

						anApp.lastEvent = getAppRecentEvent(anApp);
					});

					//initialise the filters
					//dashFilters.showNonBCPApps = false;

					//set the current Application scope
					inScopeApplications = allApplications;				
				}

				function getAppRecentEvent(anApp) {
					return allEvents.find(evt => evt.impactedAppIds.includes(anApp.id));
				}

				function setUpImpactsHierarchy() {
					// Get the instance lists
					let theOrgs = Object.values(elementsDictionary.Group_Actor);
					let thePhysProcs = Object.values(elementsDictionary.Physical_Process);
					let theApps = allApplications;
					let theTechProds = Object.values(elementsDictionary.Technology_Product);
					let theTechProdUsages = Object.values(elementsDictionary.Technology_Provider_Usage);
					let theTechNodes = Object.values(elementsDictionary.Technology_Node);
					let theSites = Object.values(elementsDictionary.Site);

					//Set Org Impacts
					theOrgs.forEach(org => {
						org.physProcs = [];
						org.physProcIds?.forEach(anId => {
							let aPP = elementsDictionary.Physical_Process[anId];
							if(aPP) {
								org.physProcs.push(aPP);
							}
						});
					});

					// Set Physical Process Impacts
					thePhysProcs.forEach(aPP => {
						let anOrg = elementsDictionary.Group_Actor[aPP.orgId];
						if(anOrg) {
							aPP.org = anOrg;
						}
						let aBusProc = elementsDictionary.Business_Process[aPP.busProcId];
						if(aBusProc) {
							aPP.busProc = aBusProc;
						}
					});
					
					// Set App Impacts
					theApps.forEach(app => {
						app.physProcs = [];
						app.physProcIds?.forEach(anId => {
							let aPP = elementsDictionary.Physical_Process[anId];
							if(aPP) {
								app.physProcs.push(aPP);
							}
						});

						app.hostingSites = [];
						app.hostingSiteIds?.forEach(anId => {
							let aSite = elementsDictionary.Site[anId];
							if(aSite) {
								app.hostingSites.push(aSite);
							}
						});
					});

					// Set Tech Product Usage Impacts
					theTechProdUsages.forEach(techProdUsage => {
						techProdUsage.apps = [];
						techProdUsage.appIds?.forEach(anId => {
							let anApp = elementsDictionary.Composite_Application_Provider[anId];
							if(anApp) {
								techProdUsage.apps.push(anApp);
							}
						});
					});

					// Set Tech Product Impacts
					theTechProds.forEach(techProd => {
						techProd.apps = [];
						techProd.appIds?.forEach(anId => {
							let anApp = elementsDictionary.Composite_Application_Provider[anId];
							if(anApp) {
								techProd.apps.push(anApp);
							}
						});
					});

					// Set Tech Node Impacts
					theTechNodes.forEach(techNode => {
						techNode.apps = [];
						techNode.appIds?.forEach(anId => {
							let anApp = elementsDictionary.Composite_Application_Provider[anId];
							if(anApp) {
								techNode.apps.push(anApp);
							}
						});

						techNode.techProdUsages = [];
						techNode.techProdUsageIds?.forEach(anId => {
							let aTPU = elementsDictionary.Technology_Provider_Usage[anId];
							if(aTPU) {
								techNode.techProdUsages.push(aTPU);
							}
						});

						techNode.techNodes = [];
						techNode.techNodeIds?.forEach(anId => {
							let aTechNode = elementsDictionary.Technology_Node[anId];
							if(aTechNode) {
								techNode.techNodes.push(aTechNode);
							}
						});
					});
					
					// Set Site Impacts
					theSites.forEach(site => {
						site.techNodes = [];
						site.techNodeIds?.forEach(anId => {
							let aTechNode = elementsDictionary.Technology_Node[anId];
							if(aTechNode) {
								site.techNodes.push(aTechNode);
							}
						});
					});
					
					// Set Event Direct Impacts and App Blast Radius
					allEvents.forEach(evt => {
						//set event type
						let evtType = allEventTypes.find(type => type.id == evt.typeId);
						if(evtType) {
							evt.type = evtType;
						}

						//set direct impacts
						evt.apps = [];
						evt.appIds?.forEach(anId => {
							let anApp = elementsDictionary.Composite_Application_Provider[anId];
							if(anApp) {
								evt.apps.push(anApp);
							}
						});
						evt.impactedApps = evt.apps;

						evt.techProducts = [];
						evt.techProductIds?.forEach(anId => {
							let aTP = elementsDictionary.Technology_Product[anId];
							if(aTP) {
								evt.techProducts.push(aTP);
							}
						});
						evt.impactedTechProducts = evt.techProducts;
						evt.impactedTechProductUsages = [];

						evt.techNodes = [];
						evt.techNodeIds?.forEach(anId => {
							let aTechNode = elementsDictionary.Technology_Node[anId];
							if(aTechNode) {
								evt.techNodes.push(aTechNode);
							}
						});
						evt.impactedTechNodes = evt.techNodes;

						evt.orgs = [];
						evt.orgIds?.forEach(anId => {
							let anOrg = elementsDictionary.Group_Actor[anId];
							if(anOrg) {
								evt.orgs.push(anOrg);
							}
						});
						evt.impactedOrgs = evt.orgs;
						evt.impactedPhysProcs = [];
						evt.impactedBusProcs = [];

						evt.sites = [];
						evt.siteIds?.forEach(anId => {
							let aSite = elementsDictionary.Site[anId];
							if(aSite) {
								evt.sites.push(aSite);
							}
						});
						evt.impactedSites = evt.sites;

						evt.sites?.forEach(site => {
							getEventSiteBlastRadius(site, evt);
						});

						evt.techNodes?.forEach(tn => {
							getEventTechNodeBlastRadius(tn, evt);
						});

						evt.techProducts?.forEach(tp => {
							getEventTechProductBlastRadius(tp, evt);
						});

						evt.impactedApps?.forEach(app => {
							getEventAppBlastRadius(app, evt);
						});

						evt.orgs?.forEach(org => {
							getEventOrgBlastRadius(org, evt);
						});

						evt.impactedAppIds = evt.impactedApps.map(app => app.id);
						evt.impactedApps.sort(function(a, b){
							if (b.name > a.name) {return -1;}
							if (a.name &lt; b.name) {return 1;}
					  	return 0;
			    	});

					});


					function getEventSiteBlastRadius(site, evt) {
						if(!evt.impactedSites.includes(site)) {
							evt.impactedSites.push(site);
						}
						site.techNodes?.forEach(tn => {
							if(!evt.impactedTechNodes.includes(tn)) {
								evt.impactedTechNodes.push(tn);
								getEventTechNodeBlastRadius(tn, evt);
							}
						});
					}

					function getEventTechNodeBlastRadius(techNode, evt) {
						
						techNode.techNodes?.forEach(tn => {
							if(!evt.impactedTechNodes.includes(tn)) {
								evt.impactedTechNodes.push(tn);
								getEventTechNodeBlastRadius(tn, evt);
							}
						});

						techNode.techProdUsages?.forEach(tpu => {
							if(!evt.impactedTechProductUsages.includes(tpu)) {
								evt.impactedTechProductUsages.push(tpu);
								getEventTechProdUsageBlastRadius(tpu, evt);
							}
						});

						techNode.apps?.forEach(app => {
							if(!evt.impactedApps.includes(app)) {
								evt.impactedApps.push(app);
								getEventAppBlastRadius(app, evt);
							}
						});
					}

					function getEventTechProdUsageBlastRadius(tpu, evt) {
						
						tpu.apps?.forEach(app => {
							if(!evt.impactedApps.includes(app)) {
								evt.impactedApps.push(app);
								getEventAppBlastRadius(app, evt);
							}
						});
					}

					function getEventTechProductBlastRadius(techProd, evt) {
						
						techProd.apps?.forEach(app => {
							if(!evt.impactedApps.includes(app)) {
								evt.impactedApps.push(app);
								getEventAppBlastRadius(app, evt);
							}
						});
					}

					function getEventAppBlastRadius(app, evt) {
						
						app.physProcs?.forEach(pp => {
							if(!evt.impactedPhysProcs.includes(pp)) {
								evt.impactedPhysProcs.push(pp);
								getEventPhysProcBlastRadius(pp, evt);
							}
						});
					}

					function getEventPhysProcBlastRadius(pp, evt) {
						let org = pp.org;
						let busProc = pp.busProc;
						if(org &amp;&amp; !evt.impactedOrgs.includes(org)) {
							evt.impactedOrgs.push(org);
							getEventOrgBlastRadius(pp, org);
						}

						if(busProc &amp;&amp; !evt.impactedBusProcs.includes(busProc)) {
							evt.impactedBusProcs.push(busProc);
						}
					}

					function getEventOrgBlastRadius(org, evt) {
						org.physProcs?.forEach(pp => {
							if(!evt.impactedPhysProcs.includes(pp)) {
								evt.impactedPhysProcs.push(pp);
								getEventPhysProcBlastRadius(pp, evt);
							}
						});
					}
				}

				//Charts
				const BACKGROUND_COLOUR_PALETTE = [     
					'#03A9F4',
					'#E91E63',
					'#9C27B0',
					'#3F51B5',
					'#4CAF50',
					'#FF5722',
					'#FFC107',
					'#00BCD4',
					'#795548',
					'#607D8B'
				];
				const BACKGROUND_COLOUR_FOR_UNDEFINED = "#333333"

				const BORDER_COLOUR_PALETTE = [
					'#03A9F4',
					'#E91E63',
					'#9C27B0',
					'#3F51B5', 
					'#4CAF50',
					'#FF5722',
					'#FFC107',
					'#00BCD4',
					'#795548',
					'#607D8B'
				];
				const BORDER_COLOUR_FOR_UNDEFINED = "#333333"

				const BORDER_WIDTH = 1

	
				
				//function to draw the Top 10 most expensive Applications bar chart
				var top10Chart;

				<!-- function drawTop10AppRTADeficitChart_ECHART() {
					let appsWithRTDiff = inScopeApplications.filter(app => app.rtDiffDuration != null);
					appsWithRTDiff.sort(function(a, b){
			    		if (b.rtDiffDuration.as('seconds') > a.rtDiffDuration.as('seconds')) {return -1;}
					  	if (a.rtDiffDuration.as('seconds') &lt; b.rtDiffDuration.as('seconds')) {return 1;}
					  	return 0;
			    	});
			    	
			    	//get the top 10 apps for RTA deficit
			    	let minCount = Math.min(10, appsWithRTDiff.length);
			    	let top10Apps = [];
			    	for (var i = 0; i &lt; minCount; i++) {
			         	let anApp = appsWithRTDiff[i];
			         	top10Apps.push(anApp);
			        }

					top10Apps.sort(function(a, b){
			    		if (b.rtDiffDuration.as('seconds') &lt; a.rtDiffDuration.as('seconds')) {return -1;}
					  	if (a.rtDiffDuration.as('seconds') > b.rtDiffDuration.as('seconds')) {return 1;}
					  	return 0;
			    	});

					var chartDom = document.getElementById('top10-chart');
					var myChart = echarts.init(chartDom);
					var option;

					const labelRight = {
						position: 'right'
					};

					const negColour = {
						color: '#a90000'
					};


					let top10Labels = top10Apps.map(app => app.name);

					let top10Data = top10Apps.map(function(app) {
						let rtaDiffMins = app.rtDiffDuration.as('minutes');
						let t10Data = {
							"value": rtaDiffMins
						}
						if(rtaDiffMins &lt;= 0) {
							t10Data.label = labelRight;
							t10Data.itemStyle = negColour;
						}
						return t10Data;
					})


					option = {
						tooltip: {
							trigger: 'axis',
							axisPointer: {
								type: 'shadow'
							}
						},
						margin: { right: 300 }, 
						grid: {
							top: 80,
							bottom: 30
						},
						xAxis: {
							type: 'value',
							position: 'top',
							splitLine: {
								lineStyle: {
									type: 'dashed'
								}
							}
						},
						yAxis: {
							type: 'category',
							axisLine: { show: false },
							axisLabel: { show: false },
							axisTick: { show: false },
							splitLine: { show: false },
							data: top10Labels
						},
						series: [
							{
								name: 'RTA Differential',
								type: 'bar',
								stack: 'Total',
								label: {
									show: true,
									formatter: '{b}'
								},
								data: top10Data
							}
						]
					};

					option &amp;&amp; myChart.setOption(option);
				} -->

				function closeNav() {
					document.getElementById("bcpSideNav").style.marginRight = "-752px";
				}

				function toggleMiniPanel(element){
					$(element).parent().parent().nextAll('.mini-details').slideToggle();
					$(element).toggleClass('fa-caret-right');
					$(element).toggleClass('fa-caret-down');
				};

				/*Auto resize panel during scroll*/
				$(window).scroll(function () {
					if ($(this).scrollTop() &gt; 40) {
						$('#appSidenav').css('position', 'fixed');
						$('#appSidenav').css('height', 'calc(100% - 38px)');
						$('#appSidenav').css('top', '38px');
					}
					if ($(this).scrollTop() &lt; 40) {
						$('#appSidenav').css('position', 'fixed');
						$('#appSidenav').css('height', 'calc(100% - 38px)');
						$('#appSidenav').css('top', '76px');
					}
				});

				function initBCMModel() {
					<!-- Initialise business capability model -->
					//initialise the BCM model
					var bcmFragment   = $("#bcm-template").html();
					var bcmTemplate = Handlebars.compile(bcmFragment);
					$("#bcmContainer").html(bcmTemplate(viewData.bcmData)).promise().done(function(){  
						//initialise the bcp data for the BCM bcp overlays
						//initBCMBCPOverlayData();
						
						<!--Tooltips and Popovers-->
						$('.bus-cap-info').click(function() {
							let busCapId = $(this).attr('eas-id');
							let busCap = viewData.busCaps.find(bc => bc.id == busCapId);
							if(busCap) {
								let busCapApps = busCap.applications;
								$('#bcpSideNavList').html(busCapAppListTemplate(busCap)).promise().done(function(){
									document.getElementById("bcpSideNav").style.marginRight = "0px";
								});
							}
						});
						<!-- $('.bus-cap-info').popover({
							container: 'body',
							animation: true,
							html: true,
							trigger: 'hover',
							content: function(){
								return $(this).next().html();
							}
						}); -->
					});
				}



				function drawTop10AppRTADeficitChart() {
                  //console.log('inScopeApplications');//console.log(inScopeApplications)
					let appsWithRTDiff = inScopeApplications.filter(app => app.rtDiffDuration != null);
					appsWithRTDiff.sort(function(a, b){
			    		if (b.rtDiffDuration?.as('seconds') > a.rtDiffDuration?.as('seconds')) {return -1;}
					  	if (a.rtDiffDuration?.as('seconds') &lt; b.rtDiffDuration?.as('seconds')) {return 1;}
					  	return 0;
			    	});
			    	
			    	//get the top 10 apps for RTA deficit
			    	let minCount = Math.min(10, appsWithRTDiff.length);
			    	let top10Apps = [];
			    	for (var i = 0; i &lt; minCount; i++) {
			         	let anApp = appsWithRTDiff[i];
			         	top10Apps.push(anApp);
			         }

					top10Apps.sort(function(a, b){
			    		if (b.rtDiffDuration?.as('seconds') > a.rtDiffDuration?.as('seconds')) {return -1;}
					  	if (a.rtDiffDuration?.as('seconds') &lt; b.rtDiffDuration?.as('seconds')) {return 1;}
					  	return 0;
			    	});
			         
			         //get the labels for the chart y axis
			         let top10Labels = top10Apps.map(function(anApp) {
			         	return anApp.name;
			         });

					 let top10Data = top10Apps.map(function(anApp) {
			         	return anApp.rtDiffDuration?.as('minutes');
			         });
			         
					
					let top10ChartData = {
						'labels': top10Labels,
						'values': top10Data
					}
					 
					if(top10Chart != null) {
						top10Chart.destroy();
					}

					top10Chart = drawDurationDiffBarChart('top10-chart', top10ChartData, BACKGROUND_COLOUR_PALETTE, BORDER_COLOUR_PALETTE, BORDER_WIDTH);
				}
				
				
				//function to draw the Cost Type pie chart
				var criticalityTierPie, criticalityTierBar;
				function getCriticalityTierTotal(thisCriticalityTier) {
					return inScopeApplications.filter(anApp => anApp.criticalityTier?.id == thisCriticalityTier.id).length;	
				}

				
				//function to draw the Criticality Tier charts
				function drawCriticalityTierCharts() {
					let thisCriticalityTiers = viewData.criticalityTiers;
					thisCriticalityTiers?.sort(function(a, b){
			    		if (b.name > a.name) {return -1;}
					  	if (a.name &lt; b.name) {return 1;}
					  	return 0;
			    	});
					
					let tierLabels = thisCriticalityTiers.map(aTier => aTier.name);
					tierLabels.push('No Tier');
			        let tierTotals = thisCriticalityTiers.map(aTier => getCriticalityTierTotal(aTier));
					let noTierAppCount = inScopeApplications.filter(anApp => !anApp.criticalityTier).length;
					tierTotals.push(noTierAppCount);

					let chartBGColours = [];
					let chartBorderColours = [];

					for (let i = 0; i &lt; thisCriticalityTiers.length	; i++) {
			         	chartBGColours.push(BACKGROUND_COLOUR_PALETTE[i]);
						chartBorderColours.push(BORDER_COLOUR_PALETTE[i]);
			         }
					 chartBGColours.push(BACKGROUND_COLOUR_FOR_UNDEFINED);
					 chartBorderColours.push(BORDER_COLOUR_FOR_UNDEFINED);
					
					let tierData = {
						'labels': tierLabels,
						'values': tierTotals
					}
					
					if(criticalityTierPie != null) {
				        criticalityTierPie.destroy();
				    }
					

					criticalityTierPie = drawPieChart('type-criticality-pie', tierData, chartBGColours, chartBorderColours, BORDER_WIDTH, 'criticalityTier', 'No Tier');
					
					if(criticalityTierBar != null) {
				        criticalityTierBar.destroy();
				    }

					criticalityTierBar = drawCountBarChart('type-criticality-bar', tierData, chartBGColours, chartBorderColours, BORDER_WIDTH, 'criticalityTier', 'No Tier');
				}

				//function to draw the Cost Type pie chart
				var primSolTypePie, primSolTypeBar;
				function getPrimSolTypeTotal(thisSolType) {
					return inScopeApplications.filter(anApp => anApp.failoverModel?.id == thisSolType.id).length;	
				}

				//function to draw the Primary Solution Type pie chart
				function drawPrimarySolTypeCharts() {
					let thisPrimSolutionTypes = viewData.failoverModels;
					thisPrimSolutionTypes?.sort(function(a, b){
			    		if (b.name > a.name) {return -1;}
					  	if (a.name &lt; b.name) {return 1;}
					  	return 0;
			    	});
					
					let solTypeLabels = thisPrimSolutionTypes.map(solType => solType.name);
					solTypeLabels.push('No Solution Type');
			        let solTypeTotals = thisPrimSolutionTypes.map(solType => getPrimSolTypeTotal(solType));
					let noSolTypeAppCount = inScopeApplications.filter(anApp => !anApp.failoverModel).length;
					solTypeTotals.push(noSolTypeAppCount);

					let chartBGColours = [];
					let chartBorderColours = [];

					for (let i = 0; i &lt; thisPrimSolutionTypes.length	; i++) {
			         	chartBGColours.push(BACKGROUND_COLOUR_PALETTE[i]);
						chartBorderColours.push(BORDER_COLOUR_PALETTE[i]);
			         }
					 chartBGColours.push(BACKGROUND_COLOUR_FOR_UNDEFINED);
					 chartBorderColours.push(BORDER_COLOUR_FOR_UNDEFINED);
					
					let primSolTypeData = {
						'labels': solTypeLabels,
						'values': solTypeTotals
					}
					
					if(primSolTypePie != null) {
				        primSolTypePie.destroy();
				    }
					

					primSolTypePie = drawPieChart('prim-sol-type-chart-pie', primSolTypeData, chartBGColours, chartBorderColours, BORDER_WIDTH, 'failoverModel', 'No Solution Type');
					
					if(primSolTypeBar != null) {
				        primSolTypeBar.destroy();
				    }

					primSolTypeBar = drawCountBarChart('prim-sol-type-chart-bar', primSolTypeData, chartBGColours, chartBorderColours, BORDER_WIDTH, 'failoverModel', 'No Solution Type');
				}
				
				
				//function to draw a pie chart
				function drawPieChart(containerId, chartData, bgColours, borderColours, borderWidth, appProp, emptyLabel) {
					var ctx = document.getElementById(containerId).getContext('2d');
					var myChart = new Chart(ctx, {
					    type: 'doughnut',
					    responsive: true,
					    data: {
					        labels: chartData.labels,
					        datasets: [{
					            label: 'Application Counts',
					            data: chartData.values,
								backgroundColor: bgColours,
								borderColor: borderColours,
								borderWidth: borderWidth
					        }]
					    },
					    <xsl:call-template name="pie-chart-options"/>
					});

					let canvas = document.getElementById(containerId);
					if(appProp &amp;&amp; emptyLabel) {
						canvas.onclick = function(evt) {
							let activePoints = myChart.getElementsAtEvent(evt);
							if (activePoints[0]) {
								let chartData = activePoints[0]['_chart'].config.data;
								const idx = activePoints[0]['_index'];

								const label = chartData.labels[idx];
								const value = chartData.datasets[0].data[idx];
								let thisApps = [];
								if(label == emptyLabel) {
									thisApps = inScopeApplications?.filter(app => !app[appProp]);
								} else {
									thisApps = inScopeApplications?.filter(app => app[appProp]?.name == label);
								}
								if(thisApps.length > 0) {
									thisApps.sort(function(a, b){
										if (b.name > a.name) {return -1;}
										if (a.name &lt; b.name) {return 1;}
										return 0;
									});
									let appListData = {
										"link": label + ' (' + value + ' Applications)',
										"applications": thisApps
									}
									$('#bcpSideNavList').html(busCapAppListTemplate(appListData)).promise().done(function(){
										document.getElementById("bcpSideNav").style.marginRight = "0px";
									});
								}
								console.log('CLICKED ON:', thisApps);
							}
						};
					}
					
					return myChart;
					
				}
				
				
				//function to draw a pie chart
				function drawMiniPieChart(containerId, chartData) {
					var ctx = document.getElementById(containerId).getContext('2d');
					var myChart = new Chart(ctx, {
					    type: 'doughnut',
					    responsive: true,
					    data: {
					        labels: chartData.labels,
					        datasets: [{
					            label: 'Total Cost',
					            data: chartData.values,
					            <xsl:call-template name="chart-colours"/>
					        }]
					    },
					    <xsl:call-template name="mini-pie-chart-options"/>
					});
					
					return myChart;
				}
	
				
				//function to draw a bar chart
				function drawDurationDiffBarChart(containerId, chartData, bgColours, borderColours, lineWidth) {
					var ctx = document.getElementById(containerId).getContext('2d');
					var myChart = new Chart(ctx, {
					    type: 'horizontalBar',
					    responsive: true,
					    data: {
					        labels: chartData.labels,
					        datasets: [{
					            label: 'Recovery Time Deficit',
					            data: chartData.values,
					            backgroundColor: bgColours,
								borderColor: borderColours,
								borderWidth: lineWidth
					        }]
					    },
					    <xsl:call-template name="bar-chart-options">
							<xsl:with-param name="chartType" select="'DURATION'"/>
						</xsl:call-template>
					});
				}

				function drawCountBarChart(containerId, chartData, bgColours, borderColours, lineWidth, appProp, emptyLabel) {
					var ctx = document.getElementById(containerId).getContext('2d');
					var myChart = new Chart(ctx, {
					    type: 'horizontalBar',
					    responsive: true,
					    data: {
					        labels: chartData.labels,
					        datasets: [{
					            label: 'Application Count',
					            data: chartData.values,
					            backgroundColor: bgColours,
								borderColor: borderColours,
								borderWidth: lineWidth
					        }]
					    },
					    <xsl:call-template name="bar-chart-options">
							<xsl:with-param name="chartType" select="'COUNT'"/>
						</xsl:call-template>
					});

					let canvas = document.getElementById(containerId);
					if(appProp &amp;&amp; emptyLabel) {
						canvas.onclick = function(evt) {
							let activePoints = myChart.getElementsAtEvent(evt);
							if (activePoints[0]) {
								let chartData = activePoints[0]['_chart'].config.data;
								const idx = activePoints[0]['_index'];

								const label = chartData.labels[idx];
								const value = chartData.datasets[0].data[idx];
								let thisApps = [];
								if(label == emptyLabel) {
									thisApps = inScopeApplications?.filter(app => !app[appProp]);
								} else {
									thisApps = inScopeApplications?.filter(app => app[appProp]?.name == label);
								}
								if(thisApps.length > 0) {
									thisApps.sort(function(a, b){
										if (b.name > a.name) {return -1;}
										if (a.name &lt; b.name) {return 1;}
										return 0;
									});
									let appListData = {
										"link": label + ' (' + value + ' Applications)',
										"applications": thisApps
									}
									$('#bcpSideNavList').html(busCapAppListTemplate(appListData)).promise().done(function(){
										document.getElementById("bcpSideNav").style.marginRight = "0px";
									});
								}
								console.log('CLICKED ON:', thisApps);
							}
						};
					}
				}
				
				
				var barOptions_stacked = {
					legend: {
						onClick: null
					},
	                scales: {
	                    xAxes: [{
	                        stacked: true,
	                        ticks: {
							   	precision: 0,
							   	stepSize: 10000,
								beginAtZero: true,
								callback: function(value, index, values) {
									return Math.round(value);
								}
					    	}
	                    }],
	                    yAxes: [{
	                        stacked: true,
	                        barPercentage: 0.5,
				            barThickness: 10,
				            maxBarThickness: 10,
				            minBarLength: 2,
				            gridLines: {
				                offsetGridLines: true
				            },
				            type: 'category',
							position: 'left',
							display: true,
							ticks: {
								reverse: true
							},
							afterFit: function(scaleInstance) {
							   	scaleInstance.width = 200; // sets the width to 100px
							}
	                    }],
	                    barPercentage: 0.4
	                },
	                tooltips: {
	    				mode: 'index',
	    				intersect: false,
						callbacks: {
							label: function(tooltipItem, data) {
								let val = data.datasets[tooltipItem.datasetIndex]?.data[tooltipItem.index] || 0;
								return data.datasets[tooltipItem.datasetIndex]?.label + ': ' + Math.round(val);
							}
						}
	    			},
	    			pointRadius: 10,
	    			responsive: true,
	            }
					
				
				//function to draw a stacked bar chart
				function drawStackedBarChart(containerId, chartData) {					
				
					var ctx = document.getElementById(containerId).getContext('2d');
					var myChart = new Chart(ctx, {
					    type: 'horizontalBar',
					    responsive: true,
					    data: chartData,
					    options: barOptions_stacked
					});
					
					return myChart;
				}
				
				//function to draw a bar chart
				function drawBarChartOLD(containerId, chartData, bgColours, borderColours, borderWidth) {
					var ctx = document.getElementById(containerId).getContext('2d');
					var myChart = new Chart(ctx, {
					    type: 'horizontalBar',
					    responsive: true,
					    data: {
					        labels: chartData.labels,
					        datasets: [{
					            label: 'Total Cost',
					            data: chartData.values,
					            backgroundColor: bgColours,
								borderColor: borderColours,
								borderWidth: borderWidth
					        }]
					    },
					    <xsl:call-template name="bar-chart-options"/>
					});
					return myChart;
				}
			
				
				//funtion to set contents of the Application catalogue table
				function drawApplicationsTable() {		
					if(catalogueTable == null) {
						initAppsTable();
					} else {
						let appTableColumns = getAppTableColumns();
						catalogueTable.clear();
						//catalogueTable.columns.add(appTableColumns);
						catalogueTable.rows.add(inScopeApplications);
    					catalogueTable.draw();
    				}
				}

				
				//function to calculate the column definitions required for the app table
				function getAppTableColumnDefs() {
					let externalLinkMax = 0;
					for (let index = 0; index &lt; inScopeApplications?.length; index++) {
						const anApp = inScopeApplications[index];
						if(anApp.externalLinks?.length > externalLinkMax) {
							externalLinkMax = anApp.externalLinks?.length;
						}
					}

					let appColumnDefs = [
						{
							"targets": 0,
							"title": "Application Name",
							"data" : "name",
							"defaultContent": "",
							"width": "150px",
							"render": function( d, type, row, meta ){
								if(row != null) {
									return appLinkTemplate(row);
								}
							}
						},
						{
							"targets": 1,
							"title": "Description",
							"data" : "description",
							"defaultContent": "",
							"width": "200px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									return d;
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 2,
							"title": "Criticality Tier",
							"data" : "criticalityTier",
							"width": "50px",
							"defaultContent": "",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d?.name) {
									return d.name;
								} else {
									return "-";
								}
							}
						},
						<!-- {
							"targets": 3,
							"title": "Tier Establishment Date",
							"data" : "criticalityTierDate",
							"width": "50px",
							"type": "date",
							"defaultContent": "",
							"visible": true,
							"render": function( data, type, row ){
								if(data) {
									if ( type === 'sort' || type === 'type' ) {
										return data ? data : '';
									}
									if ( type === 'display' ) {
										// Manipulate your display data
										return data ? moment(data).format('Do MMM YYYY') : '-';
									}
									return data ? moment(data).format('Do MMM YYYY') : '-';
								} else {
									return "-";
								}
							}
						}, -->
						<!-- {
							"targets": 4,
							"title": "Tier Restoration Order",
							"data" : "restorationIndex",
							"width": "50px",
							"defaultContent": "",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									return d;
								} else {
									return "-";
								}
							}
						}, -->
						{
							"targets": 3,
							"title": "RPO",
							"data" : "rpoDuration",
							"defaultContent": "",
							"width": "60px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									if ( type === 'sort' || type === 'type' ) {
										return d ? d.as('seconds') : '-';
									}
									if ( type === 'display' ) {
										// Format the duration
										return d.format("d [days], h [hrs], m [min], s [sec]");
									}
									return d ? d.format("d [days], h [hrs], m [min], s [sec]") : '-';
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 4,
							"title": "RTO",
							"data" : "rtoDuration",
							"defaultContent": "",
							"width": "60px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									if ( type === 'sort' || type === 'type' ) {
										return d ? d.as('seconds') : '-';
									}
									if ( type === 'display' ) {
										// Format the duration
										return d.format("d [days], h [hrs], m [min], s [sec]");
									}
									return d ? d.format("d [days], h [hrs], m [min], s [sec]") : '-';
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 5,
							"title": "RTA",
							"data" : "rtaDuration",
							"defaultContent": "",
							"width": "60px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									if ( type === 'sort' || type === 'type' ) {
										return d ? d.as('seconds') : '-';
									}
									if ( type === 'display' ) {
										// Format the duration
										return d.format("d [days], h [hrs], m [min], s [sec]");
									}
									return d ? d.format("d [days], h [hrs], m [min], s [sec]") : '-';
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 6,
							"title": "RTA Differential",
							"data" : "rtDiffDuration",
							"defaultContent": "",
							"width": "60px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									if ( type === 'sort' || type === 'type' ) {
										return d ? d.as('seconds') : '-';
									}
									if ( type === 'display' ) {
										// Format the duration
										return appRTDiffTemplate(row);
									}
									return d ? appRTDiffTemplate(row) : '-';
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 7,
							"title": "Last Event Date",
							"data" : "lastEvent",
							"width": "60px",
							"type": "date",
							"defaultContent": "",
							"visible": true,
							"render": function( data, type, row ){
								if ( type === 'sort' || type === 'type' ) {
									return data?.dateTime ? data.dateTime : '';
								}
								if ( type === 'display' ) {
									// Manipulate your display data
									return data?.dateTime ? (moment(data.dateTime).format('Do MMM YYYY')) : '-';
								}
								return data?.dateTime ? moment(data.dateTime).format('Do MMM YYYY') : '-';
							}
						},
						{
							"targets": 8,
							"title": "Last Event Type",
							"data" : "lastEvent",
							"width": "60px",
							"defaultContent": "",
							"visible": true,
							"render": function( data, type, row ){
								if(data?.type) {
									let brData = {
										"evt": data,
										"app": row
									}
									return eventTypeTemplate(brData);
								} else {
									return '-';
								}
							}
						},
						{
							"targets": 9,
							"title": "Next Planned Test",
							"data" : "nextBCPTestDate",
							"defaultContent": "",
							"type": "date",
							"width": "60px",
							"visible": true,
							"render": function( data, type, row ){
								if ( type === 'sort' || type === 'type' ) {
									return data ? data : '';
								}
								if ( type === 'display' ) {
									// Manipulate your display data
									return data ? moment(data).format('Do MMM YYYY') : '-';
								}
								return data ? moment(data).format('Do MMM YYYY') : '-';
							}
						},
						{
							"targets": 10,
							"title": "Resiliency Solution Type",
							"data" : "failoverModel",
							"defaultContent": "",
							"width": "50px",
							"visible": true,
							"render": function(d){
								if(d?.name?.length > 0) {
									return d.name;
								} else {
									return "-";
								}
							}
						},
						<!-- {
							"targets": 13,
							"title": "Resiliency Solution Comments",
							"data" : "failoverModelComments",
							"defaultContent": "",
							"width": "200px",
							"visible": true,
							"render": function(d){
								if(d?.length > 0) {
									return d;
								} else {
									return "-";
								}
							}
						}, -->
						{
							"targets": 11,
							"title": "Service Owner",
							"data" : "itServiceOwner",
							"defaultContent": "",
							"width": "60px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d?.name) {
									return d.name;
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 12,
							"title": "Hosting Locations",
							"data" : "hostingSites",
							"defaultContent": "",
							"width": "60px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d?.length > 0) {
									//console.log("Host Sites for " + row.name, d);
									let siteString = "";
									d.forEach(function(site, idx) {
										if(idx > 0) {
											siteString = siteString + ", ";
										}
										siteString = siteString + site.name;
									});
									return siteString;
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 13,
							"title": "Document Last Updated",
							"data" : "docsLastUpdated",
							"width": "60px",
							"defaultContent": "",
							"visible": true,
							"render": function( data, type, row ){
								if(data) {
									if ( type === 'sort' || type === 'type' ) {
										return data ? data : '-';
									}
									if ( type === 'display' ) {
										// Manipulate your display data
										return data ? moment(data).format('Do MMM YYYY') : '-';
									}
									return data ? moment(data).format('Do MMM YYYY') : '-';
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 14,
							"title": "Notes",
							"data" : "notes",
							"defaultContent": "",
							"width": "250px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d) {
									return d;
								} else {
									return "-";
								}
							}
						},
						{
							"targets": 15,
							"title": "Supporting Documents",
							"data" : "externalLinks",
							"type": "html",
							"defaultContent": "",
							"width": "180px",
							"visible": true,
							"render": function( d, type, row, meta ){
								if(d?.length > 0) {
									let linkList = [];
									d.forEach(link => {
										
										linkList.push(docLinkTemplate(link));
									});
									let listData = {
										"list": linkList
									}
									return escapedTableListTemplate(listData);
								} else {
									return "-";
								}
							}
						}
					];

					for (let index = 0; index &lt; externalLinkMax; index++) {
						let colIdx = 15 + index + 1;
						let newColDef = {
							"targets": colIdx,
							"title": "Supporting Document Link " + (index + 1),
							"data" : "externalLinks",
							"type": "html",
							"defaultContent": "",
							"width": "180px",
							"visible": false,
							"render": function( d, type, row, meta ){
								if(d?.length > index) {
									let thisExtLink = d[index];
									if(thisExtLink) {
										let extLinkData = {
											"link": thisExtLink
										}
										return extDocLinkTemplate(extLinkData);
									} else {
										return "";
									}
								} else {
									return "";
								}
							}
						}
						appColumnDefs.push(newColDef);
					}
				    
					//console.log('TABLE COLUMNS', appColumns);
				    return appColumnDefs;
				}
				
				
				//function to initialise the applications table
				function initAppsTable() {
					//START INITIALISE UP THE CATALOGUE TABLE

				    <!-- $('#dt_apps tfoot th').each( function () {
				        var title = $(this).text();
				        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
				    } ); -->
				    
					let appColumnDefs = getAppTableColumnDefs();
					//let appColumns = [{width: "120px"}, {width: "180px"}, {width: "40px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "50px"}, {width: "300px"}, {width: "300px"}, {width: "300px"}];
					
					// Setup - add a text input to each footer cell
					$('#dt_apps_footer').html(appTableFooterTemplate(appColumnDefs));

					catalogueTable = $('#dt_apps').DataTable({
						paging: false,
						autoWidth: false,
						deferRender: true,
			            scrollY: 350,
						fixedColumns: true,
						scrollX: true,
			            scrollCollapse: true,
						info: true,
						sort: true,
						data: inScopeApplications,
						defaultContent: '',
						stateSave: true,
						responsive: false,
						//dom: 'Bflrtip',
						columnDefs: appColumnDefs,
						//columns: appColumns,
						language: {
							searchBuilder: {
								title: 'Filter:',
								condition: 'Condition',
								data: 'Select Column'
							}
						},
						layout: {
							topStart: {
								searchBuilder: {
									// config options here
								}
							},
							<!-- top: {
								search: {
									placeholder: 'Search'
								}
							}, -->
							topEnd: {
								buttons: [
									'colvis',
									{
										extend: 'copyHtml5',
										exportOptions: {
											columns: ':visible'
										}
									},
									{
										extend: 'excelHtml5',
										exportOptions: {
											columns: ':visible'
											<!-- format: {
												body: function ( data, column, row ) {
													return data;
													// Strip <li> tags to make them carriage returns
													//return column === 17 ?
														// THIS WORKS:  data.replace(/test/ig, "blablabla"):
														//data.replace( /&lt;li\s*\/?>/ig, "\n" ) :
														//data;
												}
											} -->
										},
										customize: function(xlsx) {
											var sheet = xlsx.xl.worksheets['sheet1.xml'];
											//console.log("EXCEL SHEET", sheet);
											// Loop over all cells in sheet
											$('row c', sheet).each( function (idx) {
												// if cell starts with http
												if ( $('is t', this).text().indexOf("http") === 0 ) {
													let thisText = $('is t', this).text();
													//console.log('CELL IDX: ' + idx + ', value = ' + thisText);
													// (2.) change the type to `str` which is a formula
													$(this).attr('t', 'str');
													let fullContent = $('is t', this).text();
													let linkSegments = fullContent.split("$$$$");
													//append the formula
													$(this).append('<f>' + 'HYPERLINK("'+ linkSegments[0] + '","' + linkSegments[0] +'")'+ '</f>');
													//remove the inlineStr
													$('is', this).remove();
													// (3.) underline
													$(this).attr( 's', '4' );
												}
											});
										}
									},
									{
										extend: 'csvHtml5',
										exportOptions: {
											columns: ':visible'
										}
									}
								]
							}
						},
					    <!-- buttons: [
							'colvis',
				            'copyHtml5', 
				            'excelHtml5',
				            'csvHtml5'
				        ], -->
						 drawCallback: function (settings) {
							//click handler for event blast radius button
							$('.ess-evt-impact-btn').off('click').on('click', function () {
								let blastRadiusClickFunction = function(aBcpEvt, focusAppId) {
									let bcpDetailData = {
										"evt": aBcpEvt,
										"focusAppId": focusAppId
									}
									$('#ess-event-blast-radius-node-dets').html(blastRadiusDetailTemplate(bcpDetailData));
								}

								let bcpEvtId = $(this).attr('eas-id');
								let bcpAppId = $(this).attr('eas-app-id');
								let bcpEvt = allEvents.find(bcpe => bcpe.id == bcpEvtId);
								if (bcpEvt) {
									console.log('Clicked on BCP Event: ', bcpEvt);
									//d3.select("#ess-event-blast-radius-svg").remove();
									$("#ess-event-blast-radius-svg").html("").promise().done(function () {
										getBCPEventBlastRadius(bcpEvt);
										renderBlastRadiusGraph("ess-event-blast-radius-svg", bcpEvt, bcpAppId, null);
										blastRadiusClickFunction(bcpEvt, bcpAppId);
										$('#ess-event-blast-radius-modal-lbl').text(bcpEvt.name);
										$('#ess-event-blast-radius-modal').modal('show');
									});
								}
							});


							//click handler for appbcp dependencies button
							$('.ess-app-deps-btn').off('click').on('click', function () {
								let appId = $(this).attr('eas-id');
								let thisApp = inScopeApplications.find(app => app.id == appId);
								if (thisApp) {
									console.log('Clicked on App: ', thisApp);
									$('#ess-app-bcp-deps-modal').modal('show');
								}
							});

						 }
					});
					
					
					// Apply the search
				  catalogueTable.columns().every( function () {
				        var that = this;
				 
				        $( 'input', this.footer() ).on( 'keyup change', function () {
				            if ( that.search() !== this.value ) {
				                that
				                    .search( this.value )
				                    .draw();
				            }
				        } );
				    } );
				     
				    //catalogueTable.columns.adjust();
					catalogueTable.columns.adjust().draw();
				    
				    $(window).resize( function () {
				        catalogueTable.columns.adjust();
				    });
				    //END INITIALISE UP THE CATALOGUE TABLE
				}
				
				<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
			  	//function to redraw the view based on the current scope
				function redrawView() {
					essResetRMChanges();
					let appTypeInfo = {
						"className": "Composite_Application_Provider",
						"label": 'Application',
						"icon": 'fa-desktop'
					}
					
					let criticalityTierScopingDef = new ScopingProperty('criticalityTierIds', 'App_Business_Continuity_Criticality_Tier'); 
					let hostingSitesScopingDef = new ScopingProperty('hostingSiteIds', 'Site'); 
					let drModelScopingDef = new ScopingProperty('failoverModelIds', 'Disaster_Recovery_Failover_Model'); 
					let appIndivScopingDef = new ScopingProperty('itServiceOwnerIds', 'ACTOR_TO_ROLE_RELATION');
					//let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
					//let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS'); 
					let scopedApps = essScopeResources(allApplications, [criticalityTierScopingDef, hostingSitesScopingDef, drModelScopingDef, appIndivScopingDef], appTypeInfo);
	
					inScopeApplications = scopedApps.resources;
					console.log('scopedApps',scopedApps)
					//console.log('AFTER FILTER SCOPED APPS', inScopeApplications)

					//Apply view specific filters
					if(!dashFilters.showNonBCPApps) {
						inScopeApplications = inScopeApplications.filter(app => app.hasBCPProfile);
					}

					if(dashFilters.durationFilters) {
						//Apply RPO filter
						let rpoFilter = dashFilters.durationFilters.rpo;
						if(rpoFilter) {
							let rpoFilterDuration = moment.duration(rpoFilter)?.as('seconds');
							if(rpoFilterDuration > 0) {
								inScopeApplications = inScopeApplications.filter(app => {
									return app.rpoDuration?.as('seconds') > rpoFilterDuration;
								});
							}
						}

						//Apply RTO filter
						let rtoFilter = dashFilters.durationFilters.rto;
						if(rtoFilter) {
							let rtoFilterDuration = moment.duration(rtoFilter)?.as('seconds');
							if(rtoFilterDuration > 0) {
								inScopeApplications = inScopeApplications.filter(app => {
									return app.rtoDuration?.as('seconds') > rtoFilterDuration;
								});
							}
						}

						//Apply RTA filter
						let rtaFilter = dashFilters.durationFilters.rta;
						if(rtaFilter) {
							let rtaFilterDuration = moment.duration(rtaFilter)?.as('seconds');
							if(rtaFilterDuration > 0) {
								inScopeApplications = inScopeApplications.filter(app => {
									return app.rtaDuration?.as('seconds') > rtaFilterDuration;
								});
							}
						}
					}
					
					//draw the charts
					drawTop10AppRTADeficitChart();
					drawCriticalityTierCharts();
					drawPrimarySolTypeCharts();

					addBusCapBCPRiskOverlays();
					
					//redraw the applications table
					drawApplicationsTable();
				}
				
				
				//a global variable that holds the data returned by an Viewer API Report
	 			<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>	
				var appBCPDataPath = '<xsl:value-of select="$appBCPAPIPath"/>';
				
				var promise_loadViewerAPIData = function(apiDataSetURL) {
		            return new Promise(function (resolve, reject) {
		                if (apiDataSetURL != null) {
		                    var xmlhttp = new XMLHttpRequest();  
		                    xmlhttp.onreadystatechange = function () {
		                        if (this.readyState == 4 &amp;&amp; this.status == 200) {		
		                            let viewerData = JSON.parse(this.responseText);
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

				$(document).ready(function(){
					initDashFilters();
				
					let hbFragment   = $("#app-link").html();
					appLinkTemplate = Handlebars.compile(hbFragment);

					hbFragment   = $("#app-table-footer").html();
					appTableFooterTemplate = Handlebars.compile(hbFragment);

					hbFragment   = $("#bcp-doc-link").html();
					docLinkTemplate = Handlebars.compile(hbFragment);

					hbFragment   = $("#bcp-table-list").html();
					tableListTemplate = Handlebars.compile(hbFragment);

					hbFragment   = $("#bcp-escaped-table-list").html();
					escapedTableListTemplate = Handlebars.compile(hbFragment);

					hbFragment   = $("#bcp-ext-doc-link-template").html();
					extDocLinkTemplate = Handlebars.compile(hbFragment);

					hbFragment   = $("#app-list-template").html();
					busCapAppListTemplate = Handlebars.compile(hbFragment);

					var bcmPopupFragment = $("#bcm-popup-template").html();
					bcmPopupTemplate = Handlebars.compile(bcmPopupFragment);

					hbFragment = $("#app-rt-diff-template").html();
					appRTDiffTemplate = Handlebars.compile(hbFragment);

					hbFragment = $("#event-type-cell-template").html();
					eventTypeTemplate = Handlebars.compile(hbFragment);

					hbFragment = $("#blast-radius-detail-template").html();
					blastRadiusDetailTemplate = Handlebars.compile(hbFragment);

					Handlebars.registerHelper('displayDuration', function(momDuration){
						if(momDuration != null) {
							return momDuration.format("d [days], h [hrs], m [min], s [sec]");
						} else {
							return '-';
						}
					});

					Handlebars.registerHelper('displayBCPDate', function(isoDate){
						if(isoDate != null) {
							return moment(isoDate).format("DD MMM YYYY");
						} else {
							return '-';
						}
					});

					Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});
					
					//fetch the viewer data then initialise the view
					promise_loadViewerAPIData(appBCPDataPath)
					.then(function(response) {
						if(dashFilters.showNonBCPApps) {
							$("#ess-show-non-bcp-profiled").prop('checked', true);
						}
                   
            			viewData = response;
						console.log('viewData',viewData);
               
			   			initDurationFilters();
			   			initBCMModel();
						initBusCapRiskThresholdSlider();
            			initDashboardData();
            			$('.eas-logo-spinner').hide();

						//init show non-BCP profiled apps
						$("#ess-show-non-bcp-profiled").change(function() {
							if($(this).prop( "checked" )) {						
								dashFilters.showNonBCPApps = true;
							} else {
								dashFilters.showNonBCPApps = false;
							}
							saveBCPDashSettings();
							//redraw the view
							redrawView();	
						});
					    
						//Toggle Criticality Tier Type Chart between Pie and Bar
						$('#show-criticality-bar').click(function(){
							$('#type-criticality-pie').css('left','-1000px');
							$('#type-criticality-bar').css('right','0');
						});
						$('#show-criticality-pie').click(function(){
							$('#type-criticality-bar').css('right','-1000px');
							$('#type-criticality-pie').css('left','0');
						});
						
						
						//Toggle Primary Solution Type between Pie and Bar
						$('#show-prim-sol-type-bar').click(function(){
							$('#prim-sol-type-chart-pie').css('left','-1000px');
							$('#prim-sol-type-chart-bar').css('right','0');
						});
						$('#show-prim-sol-type-pie').click(function(){
							$('#prim-sol-type-chart-bar').css('right','-1000px');
							$('#prim-sol-type-chart-pie').css('left','0');
						});
						
						<!--Tooltips and Popovers-->
						$('.fa-info-circle').click(function() {
							$('[role="tooltip"]').remove();
						});
						$('.fa-info-circle').popover({
							container: 'body',
							animation: true,
							html: true,
							trigger: 'click',
							content: function(){
								return $(this).next().html();
							}
						});
						
						//draw the view
						essInitViewScoping(redrawView, ['App_Business_Continuity_Criticality_Tier', 'Disaster_Recovery_Failover_Model', 'Site', 'ACTOR_TO_ROLE_RELATION'], [], true);
					
						//format the charts
						$('.chart-wrapper').matchHeight();
					});
				});
			</script>

				<!-- Handlebars template to render an individual application as text-->
				<script id="app-link" type="text/x-handlebars-template">
					<!-- <i class="right-10 ess-app-deps-btn fa fa-arrows-alt textColourBlue">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						<xsl:attribute name="title"><xsl:value-of select="eas:i18n('View Event Impact')"/></xsl:attribute>
					</i> -->
					<span>{{#hbessRenderInstanceLinkMenu this 'Composite_Application_Provider'}}{{/hbessRenderInstanceLinkMenu}}</span>
				</script>

				<!-- Handlebars template to render an individual application as text-->
				<script id="app-rt-diff-template" type="text/x-handlebars-template">
					<span class="keySampleWide right-5">
						<xsl:attribute name="style">background-color:{{#if rtoRiskRating}}{{rtoRiskRating.bgClr}}{{else}}#2dc937{{/if}};</xsl:attribute>
						<xsl:attribute name="title">{{#if rtDiffRatio}}{{rtDiffRatio}} x RTO{{/if}}</xsl:attribute>
					</span>
					<span>{{displayDuration rtDiffDuration}}</span>
				</script>

				<!-- Handlebars template to render an event type -->
				<script id="event-type-cell-template" type="text/x-handlebars-template">
					<i class="right-10 ess-evt-impact-btn fa fa-bullseye focus-bcp-evt">
						<xsl:attribute name="title"><xsl:value-of select="eas:i18n('View Event Impact')"/></xsl:attribute>
						<xsl:attribute name="eas-id">{{evt.id}}</xsl:attribute>
						<xsl:attribute name="eas-app-id">{{app.id}}</xsl:attribute>
					</i>
					<span>{{evt.type.name}}</span>
				</script>


				<!-- Handlebars template to render an individual application as text-->
				<script id="bcp-doc-link" type="text/x-handlebars-template">
					<a target="_blank"><xsl:attribute name="href">{{this.rawUrl}}</xsl:attribute>{{this.name}}</a>
				</script>

				<!-- Handlebars template to render an individual application as text-->
				<script id="bcp-table-list" type="text/x-handlebars-template">
						{{#each list}}	
							{{#if @first}}{{rawUrl}}$$$${{name}}{{/if}}
						{{/each}}
				</script>

				<!-- Handlebars template to render an individual external document link-->
				<script id="bcp-ext-doc-link-template" type="text/x-handlebars-template">
						{{link.rawUrl}}$$$${{link.name}}
				</script>

				<!-- Handlebars template to render an individual application as text-->
				<script id="bcp-escaped-table-list" type="text/x-handlebars-template">
					<ul>
						{{#each list}}	
							<li>{{{this}}}</li>
						{{/each}}
					</ul>
				</script>

				<!-- Handlebars template to render an individual application as text-->
				<script id="app-table-footer" type="text/x-handlebars-template">
					{{#each this}}	
						<th>
							<input type = "text"><xsl:attribute name="placeHolder">Search {{title}}</xsl:attribute></input>
						</th>
					{{/each}}
				</script>

				<!-- Apps list for sidebar -->
				<script id="app-list-template" type="text/x-handlebars-template">
					 	<span id="capsId"><xsl:attribute name="easid">{{id}}</xsl:attribute><h3>{{{link}}}</h3></span>
						{{#if applications.length}}
							{{#each applications}}
								<div class="appBox">
									<xsl:attribute name="easid">{{id}}</xsl:attribute>
									<div class="appBoxSummary">
										<div class="appBoxTitle pull-left strong">
											<xsl:attribute name="title">{{name}}</xsl:attribute>
											<i class="fa fa-caret-right fa-fw right-5 text-white app-details-caret" onclick="toggleMiniPanel(this)"/>{{#hbessRenderInstanceLinkMenu this 'Composite_Application_Provider'}}{{/hbessRenderInstanceLinkMenu}}
										</div>
										<div class="app-bcp-risk-blob pull-right">
											<xsl:attribute name="style">background-color:{{rtoRiskRating.bgClr}};color:{{rtoRiskRating.txtClr}}</xsl:attribute>
											{{rtoRiskRating.label}}
										</div>
									</div>
									<div class="clearfix"/>
									<div class="mini-details">
										<div class="small pull-left text-white">
											<div class="left-5 bottom-5"><i class="fa fa-database right-5"></i><strong>Recovery Point Objective: </strong>{{#if rpoDuration}}{{displayDuration rpoDuration}}{{else}}<span>Undefined</span>{{/if}}</div>
											<hr/>
											<div class="left-5 bottom-5"><i class="fa fa-bullseye right-5"></i><strong>Recovery Time Objective: </strong>{{#if rtoDuration}}{{displayDuration rtoDuration}}{{else}}<span>Undefined</span>{{/if}}</div>
											<div class="left-5 bottom-5"><i class="fa fa-clock-o right-5"></i><strong>Recovery Time Actual: </strong>{{#if rtaDuration}}{{displayDuration rtaDuration}}{{else}}<span>Undefined</span>{{/if}}</div>
											<div class="left-5 bottom-5">
												<i>
													<xsl:attribute name="class">fa {{#if rtDiffDuration}}{{#if rtoRiskRating.isRisk}}fa-exclamation-triangle{{else}}fa-check-circle-o{{/if}}{{else}}essicon-radialdots{{/if}} right-5</xsl:attribute>
													<xsl:attribute name="style">{{#if rtDiffDuration}}color:{{rtoRiskRating.bgClr}};{{/if}}</xsl:attribute>
												</i>
												<strong>Recovery Time Difference: </strong>{{#if rtDiffDuration}}{{displayDuration rtDiffDuration}}{{#if rtoRiskRating.isRisk}} over {{else}} under {{/if}}RTO{{else}}<span>Undefined</span>{{/if}}
											</div>
										</div>
									</div>
									<div class="clearfix"/>
								</div>
							{{/each}}
						{{else}}
							<p>No Applications in scope</p>
						{{/if}}
				</script>

			<xsl:call-template name="bus_cap_model"/>
			<script type="text/javascript" src="js/moment/moment-duration-format.js"></script>
		</html>
	</xsl:template>
	
	<xsl:template name="bar-chart-options">
		<xsl:param name="chartType"/>
		options: {
	    	legend: {
	    		onClick: null,
	        	display: false
	        },
	        tooltips: {
		        callbacks: {
			        label: function(tooltipItem, data) {
						//console.log(tooltipItem);
						<xsl:choose>
							<xsl:when test="$chartType = 'COUNT'">
								let d = tooltipItem.xLabel;
								return d + ' Applications';
							</xsl:when>
							<xsl:otherwise>
								let d = moment.duration(tooltipItem.xLabel, 'minutes');
								if(d > 0) {
									return d.format("d [days], h [hrs], m [min]") + ' under RTO';
								} else if(d &lt; 0) {
									return d.format("d [days], h [hrs], m [min]")  + ' over RTO';
								}  else {
									return d.format("d [days], h [hrs], m [min]");
								}
							</xsl:otherwise>
						</xsl:choose>
			        }
		        }
	        },
	        scales: {
	        	yAxes: [{
		            //barPercentage: 0.5,
		            //barThickness: 30,
		            maxBarThickness: 30,
		            //minBarLength: 2,
		            gridLines: {
		                offsetGridLines: true
		            },
		            type: 'category',
					position: 'left',
					display: true,
					<!-- ticks: {
						reverse: true
					}, -->
					afterFit: function(scaleInstance) {
					   	scaleInstance.width = 200; // sets the width to 100px
					}
		        }],
	            xAxes: [{
	                ticks: {
					   	precision: 0,
					   	//stepSize: 1,
						beginAtZero: true,
						callback: function(value, index, values) {
							return Math.round(value);
						}
			    	},
					scaleLabel: {
						display: true,
						<xsl:choose>
							<xsl:when test="$chartType = 'COUNT'">
								labelString: 'Application Count'
							</xsl:when>
							<xsl:otherwise>
								labelString: 'RTA Differential (minutes)'
							</xsl:otherwise>
						</xsl:choose>
					}
	            }]
	        }
	    }
	</xsl:template>
	
	
	<xsl:template name="mini-pie-chart-options">
		options: {
			tooltips: {
				callbacks: {
					label: function(tooltipItem, data) {
						let val = data.datasets[0].data[tooltipItem.index] || 0;
						return Math.round(val) + ' Applications';
					}
				}
			},
	    	legend: {
	        	display: true,
	        	position: 'right',
	        	onClick: null,
	        	labels: {
		        	defaultFontSize: 6
	        	}
	        },	        
	        plugins: {
	    		labels: {
	    			render: 'percentage',
				    fontColor: ['white','white','white','white','white','white','white','white','white'],
				    precision: 2
	    		}
	    	}
	    }
	</xsl:template>
	
	
	<xsl:template name="pie-chart-options">
		options: {
			tooltips: {
				callbacks: {
					label: function(tooltipItem, data) {
						let val = data.datasets[0].data[tooltipItem.index] || 0;
						return Math.round(val) + ' Applications';
					}
				}
			},
			legend: {
				onClick: null,
				display: true,
				position: 'right'
			},	        
			plugins: {
				labels: {
					render: 'percentage',
					fontColor: ['white','white','white','white','white','white','white','white','white'],
					precision: 2
				}
			}
		}
	</xsl:template>
	
	
	<xsl:template name="chart-colours">
	    backgroundColor: [     
            '#03A9F4',
            '#E91E63',
            '#9C27B0',
            '#3F51B5',
            '#4CAF50',
            '#FF5722',
            '#FFC107',
            '#00BCD4',
            '#795548',
            '#607D8B'
        ],
        borderColor: [
            '#03A9F4',
            '#E91E63',
            '#9C27B0',
            '#3F51B5', 
            '#4CAF50',
            '#FF5722',
            '#FFC107',
            '#00BCD4',
            '#795548',
            '#607D8B'
        ],
        borderWidth: 1
	</xsl:template>
	
	<xsl:template name="top10-chart">
		<canvas id="top10-chart" width="400" height="150"></canvas>
		<script>
		var ctx = document.getElementById('top10-chart').getContext('2d');
		var myChart = new Chart(ctx, {
		    type: 'horizontalBar',
		    responsive: true,
		    data: {
		        labels: ['Application 1', 'Application 2', 'Application 3', 'Application 4', 'Application 5', 'Application 6', 'Application 7', 'Application 8', 'Application 9', 'Application 10'],
		        datasets: [{
		            label: 'Total Cost',
		            data: [1200, 1980, 2301, 5362, 32736, 3729, 5362, 32736, 37291, 7625],
		            <xsl:call-template name="chart-colours"/>
		        }]
		    },
		    <xsl:call-template name="bar-chart-options"/>
		});
		</script>
	</xsl:template>
	
	<xsl:template name="differentiation-pie">
		<canvas id="diff-chart-pie" width="400" height="150"></canvas>
		<script>
		var ctx = document.getElementById('diff-chart-pie').getContext('2d');
		var myChart = new Chart(ctx, {
		    type: 'doughnut',
		    responsive: true,
		    data: {
		        labels: ['System of Innovation', 'System of Record', 'System of Differentiation'],
		        datasets: [{
		            label: 'Total Cost',
		            data: [1621000, 876000, 1111000],
		            <xsl:call-template name="chart-colours"/>
		        }]
		    },
		    <xsl:call-template name="pie-chart-options"/>
		});
		</script>
	</xsl:template>
	
	
	<xsl:template name="type-bar">
		<canvas id="type-criticality-bar" width="400" height="150"></canvas>
		<script>
		var ctx = document.getElementById('type-criticality-bar').getContext('2d');
		var myChart = new Chart(ctx, {
		    type: 'horizontalBar',
		    responsive: true,
		    data: {
		        labels: ['Maintenance', 'Internal', 'Platform'],
		        datasets: [{
		            label: 'Total Cost',
		            data: [1621000, 876000, 1111000],
		            <xsl:call-template name="chart-colours"/>
		        }]
		    },
		    <xsl:call-template name="bar-chart-options"/>
		});
		</script>
	</xsl:template>
	
	
	<xsl:template name="type-pie">
		<canvas id="type-criticality-pie" width="400" height="150"></canvas>
		<script>
		var ctx = document.getElementById('type-criticality-pie').getContext('2d');
		var myChart = new Chart(ctx, {
		    type: 'doughnut',
		    responsive: true,
		    data: {
		        labels: ['Maintenance', 'Internal', 'Platform'],
		        datasets: [{
		            label: 'Total Cost',
		            data: [1621000, 876000, 1111000],
		            <xsl:call-template name="chart-colours"/>
		        }]
		    },
		    <xsl:call-template name="pie-chart-options"/>
		});
		</script>
	</xsl:template>
	
	
	
	<!-- Template to return all read only data for the view -->
	<!--<xsl:template name="getReadOnlyJSON">
		{
			busCaps: [
				<xsl:apply-templates mode="getBusinssCapablitiesJSON" select="$allBusCapabilities"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>
			],
			bcmData: <xsl:call-template name="RenderBCMJSON"/>,
			diffLevels: [
				<xsl:apply-templates mode="RenderEnumerationJSONList" select="$appDifferentiationLevels">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
				</xsl:apply-templates>
			],
			costTypes: [
				<xsl:apply-templates mode="RenderEnumerationJSONList" select="$inScopeCostTypes">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
				</xsl:apply-templates>
			],
			codebases: [
				<xsl:apply-templates mode="RenderEnumerationJSONList" select="$appCodebases">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
				</xsl:apply-templates>
			],
			appDelModels: [
				<xsl:apply-templates mode="RenderEnumerationJSONList" select="$appDelModels">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
				</xsl:apply-templates>
			],
			applications: [
				<xsl:apply-templates mode="RenderApplicationJSON" select="$inScopeApps"/>
			],
			organisations: [
				<xsl:apply-templates mode="getFiltereaElementJSON" select="$inScopeOwningOrgs">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			],
			productTypes: [
				<xsl:apply-templates mode="getProductTypeJSON" select="$allProductTypes">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			],
			<!-\-products: [
				<xsl:apply-templates mode="getFiltereaElementJSON" select="$allProducts">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			],-\->
			costPurposes: [
				<xsl:apply-templates mode="getFiltereaElementJSON" select="$allCostPurposes">
					<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
				</xsl:apply-templates>
			],
			<xsl:call-template name="chart-colours"/>
		}
	</xsl:template>-->
	
	<xsl:template name="bus_cap_model">
		
		<style type="text/css">
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

			.no-bcp-risk {
				background-color: #12ae00;
				color: #ffffff;
			}

			<!-- .low-bcp-risk {
				background-color: #e7b416;
				color: #1c1b19;
			}

			.med-bcp-risk {
				background-color: #db7b2b;
				color: #ffffff;
			}

			.high-bcp-risk {
				background-color: #cc3232;
				color: #ffffff;
			} -->
			
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
			
			.bus-cap-info:hover, 
			.fa-info-circle:hover,
			#toggle-filter:hover,
			.ess-evt-impact-btn:hover,
			.ess-app-deps-btn:hover,
			.app-details-caret:hover {
				cursor: pointer;
			}
			
			.popover {
				max-width: none;
			}

			/***************
			Slider Classes
			****************/
			.risk-low-color {
				background: #e7b416;
				color: #1c1b19;
			}
			.risk-med-color {
				background: #db7b2b;
				color: #ffffff;
			}
			.risk-high-color {
				background: #cc3232;
				color: #ffffff;
			}

			#slider-no-overlap .noUi-handle-lower {
				right: 0;
			}
			#slider-no-overlap .noUi-handle-upper {
				right: -34px;
			}

			#buscap-risk-th-slider {
				width: 350px;
			}

			#bc-low-risk-thresh,
			#bc-med-risk-thresh {
				padding: 7px;
				margin: 15px 5px 5px;
				width: 50px;
			}

			/***************
			Side Panel Classes
			****************/
			.sidenav{ 
				height: calc(100vh - 78px);
				width: 500px;
				position: fixed;
				z-index: 1;
				top: 78px;
				right: 0;
				background-color: #f6f6f6;
				overflow-x: hidden;
				transition: margin-right 0.5s;
				padding: 10px 10px 10px 10px;
				box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
				margin-right: -752px;
			} 

			.sidenav .closebtn {
				position: absolute;
				top: 5px;
				right: 10px;
				font-size: 14px;
				margin-left: 50px;
			} 

			@media screen and (max-height : 450px){
				.sidenav { 
					padding-top: 53px;
				} 
				.sidenav a { 
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

			.app-bcp-risk-blob{
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

			.mini-details {
				display: none;
				position: relative;
				float: left;
				width: 100%;
				padding: 5px 5px 0 5px;
				background-color: #454545;
			}
			
		</style>
		
		<!-- Handlebars template to render the BCM -->
		<script id="bcm-template" type="text/x-handlebars-template">
			<div class="row">
				<div class="col-xs-12">
					<h3 class="pull-left">{{{l0BusCapLink}}} Capabilities</h3>
					<div class="keyContainer pull-right left-30">
						<div class="keyLabel">Legend:</div>
						<div class="keySampleWide busRefModel-blob-noheatmap"/>
						<div class="keySampleLabel">No Apps Defined</div>
						<div class="keySampleWide no-bcp-risk" />
						<div class="keySampleLabel">No BCP Risk Apps</div>
						<div id="bcm-risk-low-leg" class="keySampleWide"/>
						<div class="keySampleLabel">&lt;= <span id="bcm-risk-low-val"></span> BCP Risk Apps</div>
						<div id="bcm-risk-med-leg" class="keySampleWide"/>
						<div class="keySampleLabel">&lt;= <span id="bcm-risk-med-val"></span> BCP Risk Apps</div>
						<div id="bcm-risk-high-leg" class="keySampleWide"/>
						<div class="keySampleLabel">> <span id="bcm-risk-high-val"></span> BCP Risk Apps</div>
					</div>
					<!-- <div class="keyContainer pull-right right-30">
						<div class="keyLabel">Strategic Impact:</div>
						<div class="keySampleWide bg-aqua-100"/>
						<div class="keySampleLabel">High</div>
						<div class="keySampleWide bg-aqua-60"/>
						<div class="keySampleLabel">Medium</div>
						<div class="keySampleWide bg-aqua-20"/>
						<div class="keySampleLabel">Low</div>
						<span class="left-10"><i class="fa fa-flag right-5"/>Differentiator</span>
					</div> -->
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
										<div><xsl:attribute name="class">blobAnnotationC {{stratImpactStyle}}</xsl:attribute>
											<span><xsl:attribute name="id">{{busCapId}}-bcp-risk-app-text</xsl:attribute>-</span>
										</div>
										<div class="blobAnnotationR">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-midgrey bus-cap-info">												
												<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{busCapId}}</xsl:text></xsl:attribute>
											</i>
											<!-- <div class="hiddenDiv busCapPopop">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_popup</xsl:text></xsl:attribute>
												<p><em>No BCP Risk Applications</em></p>
											</div> -->
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
		
		<!-- Handlebars template to render the BCM popups -->
		<script id="bcm-popup-template" type="text/x-handlebars-template">
			{{#if bcpRiskApps.length}}
				<small>
					<p>{{description}}</p>
					<h4>Details</h4>
					<table class="table table-striped table-condensed small">
						<thead>
							<tr>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application')"/></th>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('RTO')"/></th>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('RTA')"/></th>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Diff')"/></th>
							</tr>
						</thead>
						<tbody>
							{{#each bcpRiskApps}}
								<tr>
									<td>{{#essRenderInstanceLinkOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkOnly}}</td>
									<td>{{displayDuration rtoDuration}}</td>							
									<td>{{displayDuration rtaDuration}}</td>
									<td>
										{{#if rtDiffRatio}}
											<div>
												<xsl:attribute name="class">keySampleWide right-5 {{rtoRiskRating.style}}</xsl:attribute>
											</div>
											<div class="keySampleLabel">{{rtDiffRatio}} x RTO</div>
										{{else}}
											<span>-</span>
										{{/if}}
									</td>
								</tr>
							{{/each}}
						</tbody>
					</table>
				</small>
			{{else}}
				<p><em>No BCP Risk Applications</em></p>
			{{/if}}
		</script>
		
		<!-- Handlebars template to render the BCM popups -->
		<script id="blast-radius-detail-template" type="text/x-handlebars-template">
			<div class="card">
				<div class="c-header">
					<!-- <div>BCP Event: <strong>{{evt.name}}</strong></div>
					<div class="clearfix"/> -->
					<div>
						<span class="right-5"><xsl:value-of select="eas:i18n('Event Date')"/>:</span>
						<span class="ess-string strong">{{displayBCPDate evt.dateTime}}</span>
					</div>
					<div class="label label-dark uppercase">{{evt.type.name}}</div>
					<div class="small text-muted">
						{{evt.description}}
					</div>
				</div>
				<div class="c-body">
					{{#if evt.impactedApps}}
					<table class="table table-striped table-condensed small">
						<thead>
							<tr>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application')"/></th>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('RTO')"/></th>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('RTA')"/></th>
								<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Diff')"/></th>
							</tr>
						</thead>
						<tbody>
							{{#each evt.impactedApps}}
								<tr>
									<td>
										{{#ifEquals id ../focusAppId}}
											<strong class="textColourRed">
												{{#essRenderInstanceLinkOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkOnly}}*
											</strong>
										{{else}}
												{{#essRenderInstanceLinkOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkOnly}}
										{{/ifEquals}}
									</td>
									<td>{{displayDuration rtoDuration}}</td>							
									<td>{{displayDuration rtaDuration}}</td>
									<td>
										<div class="keySampleWide right-5">
											<xsl:attribute name="style">background-color:{{rtoRiskRating.bgClr}};color:{{rtoRiskRating.txtClr}};</xsl:attribute>
										</div>
										<div class="keySampleLabel">{{rtDiffRatio}} x RTO</div>
									</td>
								</tr>
							{{/each}}
						</tbody>
					</table>
					{{else}}
						<p>No Impacted Applications</p>
					{{/if}}
				</div>
			</div>
		</script>
		
		
	</xsl:template>
	
	<!--<!-\- Templates for rendering the Business Reference Model  -\->
	<xsl:template name="RenderBCMJSON">
		<xsl:variable name="rootBusCapName" select="$rootBusCap/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		
		{
			l0BusCapId: "<xsl:value-of select="eas:getSafeJSString($rootBusCap[1]/name)"/>",
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
		
		<!-\-<xsl:variable name="busCapDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>-\->
		
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
			stratImpactStyle: "<xsl:value-of select="$stratImpactStyle"/>"
			<!-\-<xsl:choose>
				<xsl:when test="current()/name = $$L1Caps/name">inScope: true</xsl:when>
				<xsl:otherwise>inScope: false</xsl:otherwise>
			</xsl:choose>-\->
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<!-\- Template for rendering the list of Business Capabilities  -\->
	<xsl:template match="node()" mode="getBusinssCapablitiesJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisBusCapDescendants" select="eas:get_object_descendants(current(), $allBusCapabilities, 0, 4, 'supports_business_capabilities')"/>
		
		<!-\- goals and objectives -\->
		<xsl:variable name="thisBusinessObjectives" select="$allBusinessObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisBusinessGoals" select="$allBusinessGoals[name = $thisBusinessObjectives/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
		
		
		<!-\- Processes and Orgs -\->
		<xsl:variable name="thisBusinessProcess" select="$allBusinessProcess[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCapDescendants/name]"/>
		<xsl:variable name="thisPhysicalProcesses" select="$allPhysicalProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusinessProcess/name]"/>
		<!-\-<xsl:variable name="thisDirectOrganisations" select="$allDirectOrganisations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisOrg2RoleRelations" select="$allOrg2RoleRelations[name = $thisPhysicalProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisIndirectOrganisations" select="$allIndirectOrganisations[name = $thisOrg2RoleRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisOrganisations" select="$thisDirectOrganisations union $thisIndirectOrganisations"/>-\->
		
		<!-\- Applications -\->
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysicalProcesses/name]"/>
		<xsl:variable name="thisPhyProcAppProRoles" select="$allPhyProcAppProRoles[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisPhyProcDirectApps" select="$allApps[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisPhyProcIndirectApps" select="$allApps[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisApplications" select="$thisPhyProcDirectApps union $thisPhyProcIndirectApps"/>
		<!-\-<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisPhyProcAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>-\->
		
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			ref: "busCap<xsl:value-of select="index-of($allBusCapabilities, $this)"/>",
			name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			description: "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			<!-\-type: elementTypes.busCap,-\->
			goalIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessGoals"/>],
			objectiveIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusinessObjectives"/>],
			physProcessIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhysicalProcesses"/>],
			appProRoleIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisPhyProcAppProRoles"/>],
			applicationIds: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisApplications"/>],
			inScope: true
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-\- Render a JSON object representing a an Application -\->
	<xsl:template match="node()" mode="RenderApplicationJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="appDiffLevel" select="$appDifferentiationLevels[name = $this/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		<xsl:variable name="appCodebase" select="$appCodebases[name = $this/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
		<xsl:variable name="appDelModel" select="$appDelModels[name = $this/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
		
		<xsl:variable name="appCosts" select="$inScopeCosts[own_slot_value[slot_reference = 'cost_for_elements']/value = $this/name]"/>
		<xsl:variable name="appCostComponents" select="$inScopeCostComponents[name = $appCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
		
		<!-\- Owning Org -\->
		<xsl:variable name="thisOwningOrg2Role" select="$owningOrg2Roles[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thisOwningOrg" select="$inScopeOwningOrgs[name = $thisOwningOrg2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		
		<!-\- Supported Products/Product Types -\->
		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = $this/name]"/>
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $thisAppProRoles/name]"/>
		<xsl:variable name="thisIndirectPhysProcs" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="thisPhyProc2AppProRoleRelations" select="$allPhyProc2AppProRoleRelations[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $this/name]"/>
		<xsl:variable name="thisDirectPhysProcs" select="$allPhysicalProcesses[name = $thisPhyProc2AppProRoleRelations/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="thisPhysProcs" select="$thisIndirectPhysProcs union $thisDirectPhysProcs"/>
		<xsl:variable name="thisProds" select="$allProducts[own_slot_value[slot_reference = 'product_implemented_by_process']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisProdTypes" select="$allProductTypes[name = $thisProds/own_slot_value[slot_reference = 'instance_of_product_type']/value]"/>
		
		<!-\- Supported Bus Caps -\->
		<xsl:variable name="thisBusinessProcesses" select="$allBusinessProcess[name = $thisPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>		
		<xsl:variable name="thisBusCaps" select="$allBusCapabilities[name = $thisBusinessProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

		{
		<!-\- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -\->
		<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
		"diffLevelId": <xsl:choose><xsl:when test="$appDiffLevel/name">"<xsl:value-of select="eas:getSafeJSString($appDiffLevel[1]/name)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"codebaseId": <xsl:choose><xsl:when test="$appCodebase/name">"<xsl:value-of select="eas:getSafeJSString($appCodebase[1]/name)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"delModelId": <xsl:choose><xsl:when test="$appDelModel/name">"<xsl:value-of select="eas:getSafeJSString($appDelModel[1]/name)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"costs": [
			<xsl:apply-templates mode="RenderAppCostsJSON" select="$appCostComponents"/>
		],
		"owningOrgId": <xsl:choose><xsl:when test="count($thisOwningOrg) > 0">"<xsl:value-of select="eas:getSafeJSString($thisOwningOrg[1]/name)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"productTypeIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProdTypes"/>],
		"productIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProds"/>],
		"busCapCount": <xsl:value-of select="count($thisBusCaps)"/>
		<!-\-<xsl:apply-templates mode="RenderApplicationCostsJSON" select="$inScopeCostTypes"><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence']/value"/><xsl:with-param name="thisCostComps" select="$appCostComponents"/></xsl:apply-templates>-\->
		}<xsl:if test="not(position()=last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RenderAppCostsJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisTypeId" select="$this/own_slot_value[slot_reference = 'cc_cost_component_type']/value"/>
		<xsl:variable name="thisReccurrence" select="$this/type"/>
		<xsl:variable name="thisStartDate" select="$this/own_slot_value[slot_reference = 'cc_cost_start_date_iso_8601']/value"/>
		<xsl:variable name="thisEndDate" select="$this/own_slot_value[slot_reference = 'cc_cost_end_date_iso_8601']/value"/>
		<xsl:variable name="thisAmount" select="$this/own_slot_value[slot_reference = 'cc_cost_amount']/value"/>
		<xsl:variable name="thisCostPurpose" select="$allCostPurposes[name = $this/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"costTypeId": <xsl:choose><xsl:when test="count($thisTypeId) > 0">"<xsl:value-of select="eas:getSafeJSString($thisTypeId[1])"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"costPurposeId": <xsl:choose><xsl:when test="count($thisCostPurpose) > 0">"<xsl:value-of select="eas:getSafeJSString($thisCostPurpose[1]/name)"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"recurrence": "<xsl:value-of select="$thisReccurrence"/>",
		"startDate": <xsl:choose><xsl:when test="count($thisStartDate) > 0">"<xsl:value-of select="$thisStartDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"endDate": <xsl:choose><xsl:when test="count($thisEndDate) > 0">"<xsl:value-of select="$thisEndDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		<xsl:if test="string-length($thisAmount) > 0">,"amount": <xsl:value-of select="$thisAmount"/></xsl:if>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-\- Template for rendering the list of a filtering element  -\->
	<xsl:template match="node()" mode="getFiltereaElementJSON">
		<xsl:variable name="this" select="current()"/>
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>"
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>
	
	<!-\- Template for rendering the list of product types and their associated products  -\->
	<xsl:template match="node()" mode="getProductTypeJSON">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisProducts" select="$allProducts[own_slot_value[slot_reference = 'instance_of_product_type']/value = $this/name]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		name: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		products: [
			<xsl:apply-templates mode="getFiltereaElementJSON" select="$thisProducts">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>
		]
		}<xsl:if test="not(position()=last())">,</xsl:if> 
	</xsl:template>-->

</xsl:stylesheet>
