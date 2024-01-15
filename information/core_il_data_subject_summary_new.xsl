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
	<xsl:variable name="linkClasses" select="('Data_Object','Individual_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="dataSubjectRels" select="/node()/simple_instance[type='Data_Subject']"/>
	
	<xsl:variable name="allInfoRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $param1]"/>
	<xsl:variable name="allDatabases" select="$allInfoRels[own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true']"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[name = $allDatabases/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
	 
	<xsl:variable name="allInfoRepStakeholders" select="/node()/simple_instance[$allInfoReps/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allDBActors" select="/node()/simple_instance[name = $allInfoRepStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allDBRoles" select="/node()/simple_instance[name = $allInfoRepStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="dsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Subjects']"></xsl:variable>
	<xsl:variable name="doData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects']"></xsl:variable>

				
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
		<xsl:variable name="apiDataSubjects">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$dsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiDataObjects">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$doData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Data Subject Summary')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css?release=6.19" type="text/css" rel="stylesheet"></link>
		 
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css?release=6.19"/>
				<script src="js/lodash/index.js?release=6.19"/>
				<script src="js/backbone/backbone.js?release=6.19"/>
				<script src="js/graphlib/graphlib.core.js?release=6.19"/>
				<script src="js/dagre/dagre.core.js?release=6.19"/>
				<script src="js/jointjs/joint.min.js?release=6.19"/>
				<script src="js/jointjs/ga.js?release=6.19" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js?release=6.19"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.js?release=6.19"/>
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"></script>
				<style type="text/css">
					div.dataTables_wrapper {margin-top: 0;}
					.headerName > .select2 {top: -3px; font-size: 28px;}
					.headerName > .select2 > .selection > .select2-selection {height: 32px;}
					.link-tools,
					.marker-arrowheads,
					.connection-wrap{
						display: 'none'
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
					
					.superflex > label{
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
					}
					
					.superflex > h3{
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
					.doc-link-blob, .doc-link-blob-create {
						width: 200px;
						height: 80px;
						line-height: 1.1em;
						border: 1px solid #ccc;
						border-radius: 4px;
						position: relative;
						float: left;
						margin: 0 10px 10px 0;
						padding: 10px 20px 10px 10px;
					}
					.bdr-left-blue {
						border-left: 2pt solid #5b7dff!important;
					}
					.doc-link-icon {
						width: 25%;
						height: 100%;
						float: left;
						font-size: 24px;
						font-size: 32px;
						padding-top: 3px;
					}
					.doc-link-label {
						width: 75%;
						height: 10%;
						float: left;
						font-size: 100%;
						display: flex;
						align-items: center;
					}
					.doc-description{
						width: 100%;
						height: 90%; 
						top:3px;
						font-size: 90%;
						align-items: center;
					}
					.headerName{
						font-size:0.8em
					}
					.tagActor{
						background-color: #d9dadb; //#3c8996;
						color:#fff;
					}
				</style>
 
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Data Subject Summary for')"/> </span><xsl:text> </xsl:text>
									<span class="text-primary headerName"><select id="subjectSelection"  ></select></span>
								</h1>
							</div>
						</div>
					</div>				
					<div id="mainPanel"/>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
					<xsl:with-param name="viewerAPIPathDS" select="$apiDataSubjects"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathDO" select="$apiDataObjects"></xsl:with-param> 
					
				</xsl:call-template>  
			</script>	
			
	<script id="panel-template" type="text/x-handlebars-template">

		<div id="summary-content">
			
			<!--Setup Vertical Tabs-->
			<div class="row">
				<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
					<!-- required for floating -->
					<!-- Nav tabs -->
					<ul class="nav nav-tabs tabs-left">
						<li class="active">
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-desktop right-10"></i>Data Subject Details</a>
						</li>
						{{#if this.dataObjects}}	
						<li>
							<a href="#dataobjects" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Related Data Objects</a>
						</li>
						{{/if}}
					<!--	<li>
							<a href="#business" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Business Use</a>
						</li>
						-->
						{{#if this.externalDocs}}
						<li>
							<a href="#documents" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i >Documents</a>
						</li>
						{{/if}}
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-desktop right-10"></i>Data Subject Details</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Data Subject</h3>
									<label>Name</label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label>Description</label>
									<div class="ess-string">{{{breaklines this.description}}}</div>
									<div class="clearfix bottom-10"></div>
									 
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i>Key Information</h3>
									<label>Data Category</label>
									<div class="bottom-10">
											{{#if this.category}}
											<span class="label label-info">{{this.category}}</span>
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label>Supporting Data Objects</label>
									<div class="bottom-10">
										{{#if this.category}}
										<span class="label label-info">{{this.dataObjects.length}}</span>
										{{else}}
										<span class="label label-warning">None Mapped</span>
										{{/if}}
									</div>
									 
								
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i>Ownership</h3>
									{{#if this.stakeholders}}
										{{#each this.stakeholders}}
											{{#ifContains this 'Owner'}}{{/ifContains}}
										{{/each}}
									{{/if}}
									<div class="clearfix bottom-10"></div>  
								</div>
								<div class="col-xs-12"/>
								{{#if this.indStakeholder}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i>People &amp; Roles</h3>
									
									<table class="table table-striped table-bordered" id="dt_stakeholders">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
											{{#each this.indStakeholder.values}} 
											<tr>
												<td class="cellWidth-30pc">
													<ul class="ess-list-tags">
														{{#each this.values}}
															<li>{{this.roleName}}</li>
														{{/each}}
													</ul>
												</td>
												<td class="cellWidth-30pc">
													<ul class="ess-list-tags">
													  <li class="tagActor">{{{essRenderInstanceMenuLink this}}}</li>
													</ul>
												</td>
												 
											</tr>	 
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													 
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
								 
							<div class="clearfix bottom-10"></div>
							{{#if this.groupStakeholder}}
							<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i>Organisational Roles</h3>
									 
									<table class="table table-striped table-bordered" id="dt_stakeholders2">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
											{{#each this.groupStakeholder.values}} 
											<tr>
												
												<td class="cellWidth-30pc">
											 
													<ul class="ess-list-tags">
													{{#each this.values}}
														<li>{{this.roleName}}</li>
													{{/each}}
													</ul>
													 
												</td>
												<td class="cellWidth-30pc">
													{{this.key}}
												</td>
											</tr>	 
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													 
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
									
								</div>
						 
						</div>
						{{/if}}
						</div>	
						{{#if this.dataObjects}}	
						<div class="tab-pane" id="dataobjects">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i>Data Objects</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Data Objects</h3>
									<table id="dt_dobjecttable" class="table table-striped table-bordered" >
									<thead>
										<tr>
											<th>Name</th>
										</tr>
									</thead>
									<tbody>
									{{#each this.dataObjects}}
										<tr><td>{{{essRenderInstanceMenuLink this}}}</td></tr>
									{{/each}}
									</tbody>
									<tfoot>
										<tr>
											<th>Name</th>
										</tr>
									</tfoot>
									</table>
								</div>
							</div>

						</div>
						{{/if}}
				<!--		<div class="tab-pane" id="business">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i>Model</h2>
						 		<div class="col-xs-12" >
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Model</h3>
									<div class="bottom-10">
										<div class="simple-scroller" id="modelHolder">
											<div id="modelContainer"/>
										</div>
									</div>

								</div>  
								 
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Business Processes</h3>
									<div class="ess-blobWrapper">
									 {{#each this.uniqueProc}}
										<div class="ess-blob bdr-left-orange" id="someid">
											<div class="ess-blobLabel">
												<a href="#" id="someidLink">{{this.name}}</a>
											</div>
											<div class="infoButton" id="someid_info">
												<a tabindex="0" class="popover-trigger">
													<i class="fa fa-info-circle"></i>
												</a>
												<div class="popover">
													<div class="strong">{{this.name}}</div>
													<div class="small text-muted">Object Description</div>
												</div>
											</div>
										</div>
									{{/each}}	
									</div>
								</div>
							</div>
						
							<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Process Implementations</h3>
									<div class="bottom-10">
										<table id="dt_supportedprocesses" class="table table-striped table-bordered" >
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Supported Processes')"/>
													</th>
                                                    <th>
														<xsl:value-of select="eas:i18n('Application Service Used')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Business Units Supported')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('User Locations')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												 {{#each this.physicalProcesses}}
													<tr>
														<td>
															 {{this.name}}
														</td>
                                                        <td>
															{{#each this.servicesSupported}}
																{{this.name}}
															{{/each}}
														</td>
														<td>
															{{this.performedBy}}
														</td>
														<td>
															{{this.criticality}}
														</td>
														<td>
															{{#each this.locations}}
																{{this.name}}
															{{/each}}
														</td>
													</tr>

												{{/each}}

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Supported Processes')"/>
													</th>
                                                    <th>
														<xsl:value-of select="eas:i18n('Application Service Used')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Business Units Supported')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('User Locations')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</div>

								</div> 
						</div>
						-->
						{{#if this.externalDocs}}
						<div class="tab-pane" id="documents">
						<div class="parent-superflex">
							<div class="superflex">
								<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Documentation</h3>
								{{#each this.externalDocs}}
									<div class="doc-link-blob bdr-left-blue">
										<div class="doc-link-icon"><i class="fa fa-file-o"></i></div>
										<div class="doc-link-label"><a target="_blank"><xsl:attribute name="href">{{this.link}}</xsl:attribute>{{this.name}}<xsl:text> </xsl:text><i class="fa fa-external-link"></i></a></div>
										<div class="doc-description">{{this.description}}</div>
									</div>
								{{/each}}
							</div>
						</div>
						</div>
						{{/if}}
					</div>
				</div>
			</div>

			<!--Setup Closing Tag-->
		</div>

	</script>			

		</html>
	</xsl:template>  

	<xsl:template name="RenderViewerAPIJSFunction"> 
			<xsl:param name="viewerAPIPathDS"></xsl:param>  
			<xsl:param name="viewerAPIPathDO"></xsl:param>
			//a global variable that holds the data returned by an Viewer API Report 
			var viewAPIDataDS = '<xsl:value-of select="$viewerAPIPathDS"/>';  
			var viewAPIDataDO = '<xsl:value-of select="$viewerAPIPathDO"/>';  
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
			}; 
	
			 function showEditorSpinner(message) {
				$('#editor-spinner-text').text(message);                            
				$('#editor-spinner').removeClass('hidden');                         
			};
	
			function removeEditorSpinner() {
				$('#editor-spinner').addClass('hidden');
				$('#editor-spinner-text').text('');
			};
			
			Handlebars.registerHelper('breaklines', function(html) {
				html = html.replace(/(\r&lt;li&gt;)/gm, '&lt;li&gt;');
			    html = html.replace(/(\r)/gm, '<br/>');
			    return new Handlebars.SafeString(html);
			});

			showEditorSpinner('Fetching Data...'); 
			<xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
				<xsl:with-param name="linkClasses" select="$linkClasses"/>
			</xsl:call-template>
			var allDS=[];
			var table;
			var stakeholdertable;
			var stakeholdertable2;

			$('document').ready(function (){ 
			Promise.all([
				promise_loadViewerAPIData(viewAPIDataDS),
				promise_loadViewerAPIData(viewAPIDataDO) 
				]).then(function (responses){  
					allDS=responses[0];
					let focusDSid='<xsl:value-of select="$param1"/>';
					let focusDS=allDS.data_subjects.find((f)=>{
						return f.id==focusDSid
					})
				 
					DOList=focusDS ;
					
					allDS.data_subjects.forEach((e)=>{
						var option = new Option(e.name, e.id); 
						$('#subjectSelection').append($(option));  
						})
						
					$('#subjectSelection').select2({width:'350px'}); 
					$('#subjectSelection').val(focusDSid).change();
					var panelFragment = $("#panel-template").html();
					panelTemplate = Handlebars.compile(panelFragment);

					Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});

					Handlebars.registerHelper('ifContains', function(arg1, arg2, options) {
						 
						if(arg1.roleName.includes(arg2)){
							return '<label>'+arg1.roleName+'</label><ul class="ess-list-tags"><li>'+arg1.actorName+'</li></ul>'
						}  
					});
			
					redrawPage(focusDS)
	});

	
	function redrawPage(focusDS) {
	    console.log('redraw')
	    let panelSet = new Promise(function (myResolve, myReject) {
	    
	        let stakes = d3.nest().key(function (d) {
	            return d.type;
	        }).key(function (d) {
	            return d.actorName;
	        }).entries(focusDS.stakeholders);
	        
	        stakes.forEach((k) => {
	            k.values.forEach((s) => {
	                s[ 'name'] = s.key;
	                s[ 'id'] = s.values[0].actorId;
	                s[ 'className'] = 'Individual_Actor';
	            });
	        })
	        
	        focusDS[ 'groupStakeholder'] = stakes.find((e) => {
	            return e.key == 'Group_Actor'
	        });
	        focusDS[ 'indStakeholder'] = stakes.find((e) => {
	            return e.key == 'Individual_Actor'
	        });
	      
	        focusDS.dataObjects.forEach((d) => {
	            d[ 'className'] = 'Data_Object';
	        })
	        $('#mainPanel').html(panelTemplate(focusDS))
	        myResolve();
	        // when successful
	        myReject();
	        // when error
	    });
	    
	    panelSet.then(function (response) {
	        <!-- setGraph();
	        -->
	    
	        if (stakeholdertable) {
	            $('#dt_stakeholders').DataTable().destroy()
	            
	            stakeholdertable = null;
	        }
	        
	        $('#dt_stakeholders tfoot th').each(function () {
	            let stakeholdertitle = $(this).text();
	            $(this).html( '&lt;input type="text" placeholder="&#xf002; '+stakeholdertitle+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
	        });
	        
	        
	        stakeholdertable = $('#dt_stakeholders').DataTable({
	            scrollY: "350px",
	            scrollCollapse: true,
	            paging: false,
	            info: false,
	            sort: true,
	            "bFilter": false,
	            responsive: true,
	            columns:[ {
	                "width": "30%"
	            }, {
	                "width": "30%"
	            }],
	            dom: 'Bfrtip',
	            buttons:[
	            'copyHtml5',
	            'excelHtml5',
	            'csvHtml5',
	            'pdfHtml5',
	            'print']
	        });
	        
	        // Apply the search
	        stakeholdertable.columns().every(function () {
	            let thatst1 = this;
	            
	            $('input', this.footer()).on('keyup change', function () {
	                if (thatst1.search() !== this.value) {
	                    thatst1.search(this.value).draw();
	                }
	            });
	        });
	        stakeholdertable.columns.adjust();
	        
	        if (stakeholdertable2) {
	            stakeholdertable2.rows().invalidate().destroy();
	        }
	        
	        
	        $('#dt_stakeholders2 tfoot th').each(function () {
	            let stakeholdertitle2 = $(this).text();
	            $(this).html( '&lt;input type="text" placeholder="&#xf002; '+stakeholdertitle2+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
	        });
	        
	        
	        stakeholdertable2 = $('#dt_stakeholders2').DataTable({
	            scrollY: "350px",
	            scrollCollapse: true,
	            paging: false,
	            info: false,
	            sort: true,
	            "bFilter": false,
	            responsive: true,
	            columns:[ {
	                "width": "30%"
	            }, {
	                "width": "30%"
	            }],
	            dom: 'Bfrtip',
	            buttons:[
	            'copyHtml5',
	            'excelHtml5',
	            'csvHtml5',
	            'print']
	        });
	        // Apply the search
	        stakeholdertable2.columns().every(function () {
	            let thatst2 = this;
	            
	            $('input', this.footer()).on('keyup change', function () {
	                if (thatst2.search() !== this.value) {
	                    thatst2.search(this.value).draw();
	                }
	            });
	        });
	        stakeholdertable2.columns.adjust();
	        
	        if (table) {
	            table = null;
	            $('#dt_dobjecttable').DataTable().destroy();
	        }
	        $('#dt_dobjecttable tfoot th').each(function () {
	            let title = $(this).text();
	            $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
	        });
	        
	        
	        table = $('#dt_dobjecttable').DataTable({
	            scrollY: "350px",
	            scrollCollapse: true,
	            paging: false,
	            info: false,
	            sort: true,
	            "bFilter": false,
	            responsive: true,
	            columns:[ {
	                "width": "100%"
	            }],
	            dom: 'Bfrtip',
	            buttons:[
	            'copyHtml5',
	            'excelHtml5',
	            'csvHtml5',
	            'print']
	        });
	        
	        
	        // Apply the search
	        table.columns().every(function () {
	            let that = this;
	            
	            $('input', this.footer()).on('keyup change', function () {
	                if (that.search() !== this.value) {
	                    that.search(this.value).draw();
	                }
	            });
	        });
	        table.columns.adjust();
	        
	        
	        //	$('#mainPanel').html(panelTemplate(focusDO))
	        
	        <!-- function for UML if needed
	        function setGraph(classes, relations) {
	            var graph = new joint.dia.Graph;
	            var windowWidth = 500; //$('#modelHolder').width();
	            var windowHeight = 500;//$('#modelHolder').height();
	            
	            var paper = new joint.dia.Paper({
	                el: $('#modelContainer'),
	                gridSize: 1,
	                width: windowWidth,
	                height: windowHeight,
	                model: graph
	            });
	            
	            var uml = joint.shapes.uml;
	            
	            var classes = {
	                
	                customer_address: new uml.OtherDataObject({
	                    size: {
	                        width: 240, height: 75
	                    },
	                    position: {
	                        x: 0, y: 0
	                    },
	                    attrs: {
	                        a: {
	                            'xlink:href': 'report?XML=reportXML.xml&amp;XSL=information/core_il_data_object_model.xsl&amp;PMA=store_113_Class19&amp;cl=en-gb', cursor: 'pointer'
	                        }
	                    },
	                    name: 'Customer: Address'
	                }),
	                
	                
	                customer_acontactdetails: new uml.DataObject({
	                    size: {
	                        width: 240, height: 108
	                    },
	                    position: {
	                        x: 0, y: 0
	                    },
	                    attrs: {
	                        a: {
	                            'xlink:href': 'report?XML=reportXML.xml&amp;XSL=information/core_il_data_object_model.xsl&amp;PMA=store_113_Class21&amp;cl=en-gb', cursor: 'pointer'
	                        }
	                    },
	                    name: 'Customer :&amp;Contact Details', attributes:[ 'Customer Address: String',
	                    'Customer Name: String',
	                    'Customer Postcode/Zipcode: String']
	                }),
	                
	                
	                geographiclocation: new uml.DataObject({
	                    size: {
	                        width: 240, height: 75
	                    },
	                    position: {
	                        x: 0, y: 0
	                    },
	                    attrs: {
	                        a: {
	                            'xlink:href': 'report?XML=reportXML.xml&amp;XSL=information/core_il_data_object_model.xsl&amp;PMA=store_113_Class43&amp;cl=en-gb', cursor: 'pointer'
	                        }
	                    },
	                    name: 'Geographic Location'
	                })
	            };
	            
	            _.each(classes, function (c) {
	                graph.addCell(c);
	            });
	            
	            var relations =[
	            
	            new uml.Association({
	                source: {
	                    id: classes.customer_acontactdetails.id
	                },
	                target: {
	                    id: classes.geographiclocation.id
	                },
	                labels:[ {
	                    position: -20, attrs: {
	                        text: {
	                            text: '1'
	                        }
	                    }
	                }, {
	                    position: .2, attrs: {
	                        text: {
	                            text: 'customer country'
	                        }
	                    }
	                }]
	            }), new uml.Generalization({
	                source: {
	                    id: classes.customer_address.id
	                },
	                target: {
	                    id: classes.customer_acontactdetails.id
	                }
	            })];
	            
	            _.each(relations, function (r) {
	                graph.addCell(r);
	            });
	            
	            joint.layout.DirectedGraph.layout(graph, {
	                setLinkVertices: false
	            });
	            paper.scale(1, 1);
	            
	            
	            var graph = new joint.dia.Graph();
	            
	            var paper = new joint.dia.Paper({
	                el: $('#modelContainer'),
	                width: 800,
	                height: 600,
	                gridSize: 1,
	                model: graph,
	                perpendicularLinks: true,
	                restrictTranslate: true
	            });
	            
	            var member = function (x, y, rank, name, image, background, textColor) {
	                
	                textColor = textColor || "#000";
	                
	                var cell = new joint.shapes.org.Member({
	                    position: {
	                        x: x, y: y
	                    },
	                    attrs: {
	                        '.card': {
	                            fill: background, stroke: 'none'
	                        },
	                        image: {
	                            'xlink:href': '/images/demos/orgchart/' + image, opacity: 0.7
	                        },
	                        '.rank': {
	                            text: rank, fill: textColor, 'word-spacing': '-5px', 'letter-spacing': 0
	                        },
	                        '.name': {
	                            text: name, fill: textColor, 'font-size': 13, 'font-family': 'Arial', 'letter-spacing': 0
	                        }
	                    }
	                });
	                graph.addCell(cell);
	                return cell;
	            };
	            
	            function link(source, target, breakpoints) {
	                
	                var cell = new joint.shapes.org.Arrow({
	                    source: {
	                        id: source.id
	                    },
	                    target: {
	                        id: target.id
	                    },
	                    vertices: breakpoints,
	                    attrs: {
	                        '.connection': {
	                            'fill': 'none',
	                            'stroke-linejoin': 'round',
	                            'stroke-width': '2',
	                            'stroke': '#4b4a67'
	                        }
	                    }
	                });
	                graph.addCell(cell);
	                return cell;
	            }
	            
	            
	            var testJson =[ {
	                "Employee_id": "345345",
	                "name": "Helga Martinez",
	                "Contact_Info": {
	                    "skype": "mySkype",
	                    "email": "myemail@email.com"
	                },
	                "Position": "PM",
	                "LOB": "my lob",
	                "Location": "onshore",
	                "Profile_Picture": "URL",
	                "Read_More": "optional section"
	            }, {
	                "Employee_id": "786",
	                "name": "jordan loaiza",
	                "Contact_Info": {
	                    "skype": "the Skype",
	                    "email": "theemail@email.com"
	                },
	                "Position": "Dev",
	                "LOB": "the lob",
	                "Location": "offshore",
	                "Profile_Picture": "url/URL",
	                "Read_More": "optional section"
	            }, {
	                "Employee_id": "23425",
	                "name": "marvin solano",
	                "Contact_Info": {
	                    "skype": "3 Skype",
	                    "email": "3email@email.com"
	                },
	                "Position": "Front-End",
	                "LOB": "3 LOB",
	                "Location": "offshore",
	                "Profile_Picture": "url/URL/3",
	                "Read_More": "optional section"
	            }, {
	                "Employee_id": "7657",
	                "name": "leroy bernard",
	                "Contact_Info": {
	                    "skype": "5 Skype",
	                    "email": "5email@email.com"
	                },
	                "Position": "Sr Software Engineer",
	                "LOB": "5 LOB",
	                "Location": "onshore",
	                "Profile_Picture": "url/URL/5",
	                "Read_More": "optional section"
	            }, {
	                "Employee_id": "78987",
	                "name": "diego porras",
	                "Contact_Info": {
	                    "skype": "6 Skype",
	                    "email": "6email@email.com"
	                },
	                "Position": "Sr Front-End",
	                "LOB": "6 LOB",
	                "Location": "onshore",
	                "Profile_Picture": "url/URL/6",
	                "Read_More": "tons of things to say about me . . ."
	            }];
	            
	            
	            
	            var levels =[ '#30d0c6', '#7c68fd', '#feb563']
	            var head = member(300, 70, testJson[0].Position, testJson[0].name, testJson[0].Profile_Picture, levels[0]);
	            var objUsers = {
	            };
	            var x = -200;
	            var y = 200;
	            $.each(testJson, function (i, item) {
	                if (i !== 0) {
	                    x = x + 200;
	                    objUsers[item.name] = member(x, y, item.Position, item.name, item.Profile_Picture, levels[1]);
	                    link(head, objUsers[item.name],[ {
	                        x: 385, y: 180
	                    }, {
	                        x: x + 100, y: 180
	                    }]);
	                }
	            });
	        }
	        -->
	        <!-- end setGraph -->
	    }).then(function () {
	        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	            $($.fn.dataTable.tables(true)).DataTable().columns.adjust();
	        });
	    })
	    
	    $('#subjectSelection').one('change', function () {
	        let selected = $(this).val();
	        
	        let focusDS = allDS.data_subjects.find((f) => {
	            return f.id == selected;
	        });
	        redrawPage(focusDS);
	    });
	}
	});

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
