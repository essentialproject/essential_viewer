<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/> 

	<!--<xsl:include href="../information/menus/core_data_subject_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>
	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Data_Subject', 'Data_Object', 'Data_Object_Attribute', 'Group_Actor', 'Individual_Actor', 'Application_Provider', 'Group_Business_Role', 'Individual_Business_Role', 'Business_Process', 'Composite_Application_Provider', 'Data_Representation', 'Data_Representation_Attribute')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<!-- processes-->
	<xsl:variable name="busProcs" select="/node()/simple_instance[type='Business_Process']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')]"/>
	<xsl:variable name="allActor2RoleRelations" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]"/>
	<xsl:variable name="allActorsInstances" select="$allActors union $allActor2RoleRelations"/>
	<xsl:key name="allActorsInstances" match="$allActorsInstances" use="name"/>
	<xsl:key name="physProcsKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
	<xsl:key name="physProcsToAppKey" match="$allProctoApp" use="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value"/>

	<xsl:variable name="physProcs" select="key('physProcsKey', $busProcs/name)"/>
	   
	<!-- data linked to processes-->

	<xsl:variable name="allProctoApp" select="/node()/simple_instance[type='PHYSBUSPROC_TO_APPINFOREP_RELATION']"/>
	<xsl:key name="physProcstoMapKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'physbusproc_uses_appinforeps']/value"/>
	<xsl:key name="busProcsKey" match="/node()/simple_instance[type='Business_Process']" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/>
	
	<xsl:key name="allActors_key" match="$allActors" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
	

	<xsl:variable name="currentDataObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="dsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Subjects']"></xsl:variable>
	<xsl:variable name="doData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	
	<xsl:key name="regRels" match="/node()/simple_instance[type='REGULATED_COMPONENT_RELATION']" use="own_slot_value[slot_reference='regulated_component_regulation']/value"/>
	<xsl:key name="regkey" match="/node()/simple_instance[type='Regulation']" use="type"/>	
	<xsl:key name="regname" match="/node()/simple_instance[type='Regulation']" use="name"/>			
	<xsl:variable name="regulation" select="key('regkey', 'Regulation')"/>
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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->
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
				<title><xsl:value-of select="eas:i18n('Data Object Summary')"/></title>
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
					.ess-wide-blob{
						margin: 0 15px 15px 0;
						border: 1px solid #ccc;
						min-height: 40px;
						width: 250px;
						border-radius: 4px;
						display: table;
						position: relative;
						text-align: center;
						float: left;
					}
					
					.ess-blobLabel{ 
						vertical-align: middle;
						line-height: 1.1em;
						font-size: 90%;
					}
					.ess-app{
						vertical-align: middle;
						background-color: #707297;
						color:#fff;
						width:80%;
						margin-left: 10%;
						margin-bottom:3px;
						padding:2px;
						border-radius:4px;
						line-height: 1.1em;
						font-size: 90%;
						height:50px;
					}
					.ess-crud{
						display: inline-block;
						border: 1pt solid #d3d3d3;
						border-radius: 4px;
						font-size: 16px;
						font-weight: 700;
						background-color: #fff;
						margin-right: 5px;
						padding: 2px 5px;
					}
					.ess-circle{
						height:15px;
						width:15px;
						border-radius: 15px;
						border:0pt solid #d3d3d3;
						display:inline-block;
						background-color:white;
						color:#000;
						font-weight: bold;
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
					.tagActor{
						background-color: #d9dadb; //#3c8996;
						color:#fff;
					}
					.appCard{
						vertical-align: top;
						border-radius:4px;
						border:1pt solid #d3d3d3;
						display:inline-block;
						min-height:100px;
						width:250px;
						padding:3px;
						position:relative;
					}
					.appHeader{
						font-size:0.9em;
					}
					.appTableHeader{
						font-size:0.8em;
					}
					.dbicon{
						position:absolute;
						bottom:5px;
						right:5px;
						color:#d3d3d3;
						font-size:0.7em;
						text-transform: uppercase;
					}
					.appCard2{
						vertical-align: top;
						border-radius:4px;
						border:1pt solid #d3d3d3; 
					 
						width:100%;
						padding:3px;
						position:relative;
					}
					.dataCard{
						border-radius:4px;
						padding:2px;
						border:1pt solid #d3d3d3;
					}
					.classiflist{
						position:absolute;
						top:5px;
						right:5px; 
						font-size:1em; 
					}
					.datatype{
						display: inline-block;
						width:250px;
					}
					.datacrud{
						display: inline-block
					}
					.leadText{
						font-weight: bolder;
						color:#a94040;
					}
					.ess-dos-processes-wrapper,.ess-dos-apps-wrapper{display: flex; gap: 15px; flex-wrap: wrap; position: relative;}
					.ess-dos-process,.ess-dos-app{border: 1px solid #ccc; padding: 10px; width: 300px; position: relative; }
					.label.label-link > a {color: #fff;}
					.label.label-link:hover {opacity: 0.75;}
				</style>
				<script>
	 
					
					$(document).ready(function(){
						 const tabs = document.querySelectorAll('ul.nav-tabs li');
							const tabPanels = document.querySelectorAll('.tab-content > div');

							tabs.forEach((tab, index) => {
							tab.addEventListener('keydown', (event) => {
								if (event.key === 'Enter' || event.key === ' ') {
								event.preventDefault();
								selectTab(index);
								}
							});
							});

							function selectTab(index) {
							tabs.forEach((tab, i) => {
								tab.setAttribute('aria-selected', i === index);
							});
							tabPanels.forEach((panel, i) => {
								panel.style.display = i === index ? 'block' : 'none';
							});
							tabs[index].focus();
							}

					});
				</script>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Data Object Summary for')"/> </span><xsl:text> </xsl:text>
									<span class="text-primary headerName"><select id="subjectSelection"  aria-label="Select Data Subject"></select></span>
								</h1>
							</div>
						</div>
					</div>
					<div id="mainPanel" role="main" aria-label="Data Object Summary Panel"/>
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
					<ul class="nav nav-tabs tabs-left" role="tablist">
						<li class="active" role="presentation">
							<a href="#details" id="tab-details" data-toggle="tab" role="tab" aria-controls="details" aria-selected="true">
							<i class="fa fa-fw fa-tag right-10" aria-hidden="true"></i>
							<xsl:value-of select="eas:i18n('Data Object Details')"/>
							</a>
						</li>
						{{#if this.dataAttributes}}	
						<li role="presentation">
							<a href="#datattributes" data-toggle="tab" role="tab" aria-controls="datattributes" aria-selected="false"><i class="fa fa-fw fa-tag right-10" aria-hidden="true"></i><xsl:value-of select="eas:i18n('Data Attributes')"/></a>
						</li> 
						{{/if}}
						<!--		
						{{#if this.dataReps}}
				 		<li>
							<a href="#datarep" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Data Object Storage/Usage</a>
						</li>
						{{/if}}
						-->
						{{#if this.processes}}
				 		<li role="presentation">
							<a href="#dataprocess" data-toggle="tab" role="tab" aria-controls="datattributes" aria-selected="false"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Process Usage')"/></a>
						</li>
						{{/if}}
						{{#if this.appsArray}}
				 		<li role="presentation">
							<a href="#dataapps" data-toggle="tab" role="tab" aria-controls="datattributes" aria-selected="false"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Usage')"/></a>
						</li>
						{{else}}
							{{#if this.requiredByApps}}
								<li role="presentation">
									<a href="#dataapps" data-toggle="tab" role="tab" aria-controls="datattributes" aria-selected="false"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Usage')"/></a>
								</li>
							{{/if}}
						{{/if}}
						
						{{#if this.externalDocs}}
						<li role="presentation">
							<a href="#documents" data-toggle="tab" role="tab" aria-controls="datattributes" aria-selected="false"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Documents')"/></a>
						</li>
						{{/if}}
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Data Object Details')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Data Object')"/></h3>
									<label id="name-label" for="name-for-data-object">
										<xsl:value-of select="eas:i18n('Name')"/>
									</label>
									<div id="name-for-data-object" class="ess-string" aria-labelledby="name-for-data-object">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label id="name-label" for="description-for-data-object">
										<xsl:value-of select="eas:i18n('Description')"/>
									</label>
									<div id="description-for-data-object" class="ess-string" aria-labelledby="description-for-data-object">{{{breaklines this.description}}}</div>
									
									<div class="clearfix bottom-10"></div>
									 
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
									<label  id="data-category-label"><xsl:value-of select="eas:i18n('Data Category')"/></label>
									<div class="bottom-10" role="text" aria-labelledby="data-category-label">
											{{#if this.category}}
											<span class="label label-info">{{this.category}}</span>
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label id="parent-data-subject-label"><xsl:value-of select="eas:i18n('Parent Data Subject')"/></label>
									<div class="bottom-10" role="text" aria-labelledby="parent-data-subject-label">
											{{#if this.parents}}
											{{#each this.parents}}
											<span class="label label-success">{{this.name}}</span>
											{{/each}}
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label id="system-of-record-label"><xsl:value-of select="eas:i18n('System of Record')"/></label>
									<div class="bottom-10" role="text" aria-labelledby="system-of-record-label">
											{{#if this.systemOfRecord}}
											{{#each this.systemOfRecord}}
											<span class="label label-primary">{{this.name}}</span>
											{{/each}}
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									
									 
								
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Ownership')"/></h3>
									{{#if this.stakeholders}}
										{{#each this.stakeholders}}
											{{#ifContains this 'Owner'}}{{/ifContains}}
										{{/each}}
									{{/if}}
								
									<div class="clearfix bottom-10"></div>  
								</div> 
								<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Relevant Regulations')"/></h3>
									{{#each this.classifications}}<span class="label label-info">{{this.name}}</span>{{/each}}
									{{#ifEquals this.classifications 0}}<span class="label label-primary">None</span>{{/ifEquals}}
								</div>
							 
								<div class="col-xs-12"/>
								{{#if this.stakeholdersList}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('People &amp; Roles')"/></h3>
									
									<table class="table table-striped table-bordered" id="dt_stakeholders"  aria-describedby="stakeholdersDesc">
									  <caption id="stakeholdersDesc">
										<xsl:value-of select="eas:i18n('List of stakeholders with roles')"/>
										</caption>
											<thead>
												<tr>
													<th class="cellWidth-30pc"  scope="col"> 
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th class="cellWidth-30pc"  scope="col">
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
											{{#each this.stakeholdersList}} 
											<tr>
												<td class="cellWidth-30pc">
													{{this.key}}
												</td>
												<td class="cellWidth-30pc">
											 
													<ul class="ess-list-tags">
													{{#each this.values}}
														<li class="tagActor">{{{essRenderInstanceMenuLink this}}}</li>
													{{/each}}
													</ul>
													 
												</td>
												 
											</tr>	 
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th  scope="col">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th  scope="col">
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													 
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
								 
							<div class="clearfix bottom-10"></div>
							 
					  
						</div>
						 
						</div>	
						{{#if this.dataAttributes}}	
					<div class="tab-pane" id="datattributes" role="tabpanel" aria-labelledby="tab-attributes">
							<h2 class="print-only top-30">
								<i class="fa fa-fw fa-tag right-10" aria-hidden="true"></i>
								<xsl:value-of select="eas:i18n('Data Attributes')"/>
							</h2>

							<div class="parent-superflex">
								<div class="superflex">
								<h3 class="text-primary">
									<i class="fa fa-desktop right-10" aria-hidden="true"></i>
									<xsl:value-of select="eas:i18n('Data Attributes')"/>
								</h3>

								<p id="dobjecttable-desc">
									<xsl:value-of select="eas:i18n('Attributes for this data object')"/>
								</p>

								<table id="dt_dobjecttable"
										class="table table-striped table-bordered"
										aria-describedby="dobjecttable-desc"
										summary="This table lists attributes for the selected data object, including name, description, and type.">

									<caption class="sr-only">
									<xsl:value-of select="eas:i18n('Data Object Attributes Table')"/>
									</caption>

									<thead>
									<tr>
										<th scope="col"><xsl:value-of select="eas:i18n('Name')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Description')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Type')"/></th>
									</tr>
									</thead>

									<tbody>
									{{#each this.dataAttributes}}
									<tr>
										<td>{{this.name}}</td>
										<td>{{this.description}}</td>
										<td>{{this.type}}</td>
									</tr>
									{{/each}}
									</tbody>

									<tfoot>
									<tr>
										<th scope="col"><xsl:value-of select="eas:i18n('Name')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Description')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Type')"/></th>
									</tr>
									</tfoot>
								</table>
								</div>
							</div>
						</div>

						{{/if}}
			<!--	 	<div class="tab-pane" id="datarep">
						  <div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Data Storage Usage</h3>
									<p>How this Data Object is stored and / or used in Application systems</p>
									<div class="ess-blobWrapper">
									 {{#each this.dataReps}}
										<div class="ess-wide-blob bdr-left-orange" id="someid">
											<div class="ess-blobLabel">
												{{this.name}}
											</div>
											{{#each this.apps}}
											<div class="ess-app">
												{{this.name}}
												<div class="clearfix"/>
												<div class="ess-crud">C: {{#CRUDVal this.create}}{{/CRUDVal}}</div>
												<div class="ess-crud">R: {{#CRUDVal this.read}}{{/CRUDVal}}</div>
												<div class="ess-crud">U: {{#CRUDVal this.update}}{{/CRUDVal}}</div>
												<div class="ess-crud">D: {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
												 
											</div>
											{{/each}}
										</div>
									{{/each}}	
									</div>
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Data Usage</h3>
									<p>How this Data Object is used in Application systems</p>
									<div class="ess-blobWrapper">
									 {{#each this.tables}}
										<div class="ess-wide-blob bdr-left-orange" id="someid">
											<div class="ess-blobLabel">
													{{#each this.apps}}{{this.name}}{{/each}}<br/>
													{{this.dataRep}}
											</div>
											
											<div class="ess-app"> 
												<div class="clearfix"/>
												<div class="ess-crud">C: {{#CRUDVal this.create}}{{/CRUDVal}}</div>
												<div class="ess-crud">R: {{#CRUDVal this.read}}{{/CRUDVal}}</div>
												<div class="ess-crud">U: {{#CRUDVal this.update}}{{/CRUDVal}}</div>
												<div class="ess-crud">D: {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
												 
											</div> 
											{{#each ../this.classifications}}<span class="label label-info">{{this.shortName}}</span>{{/each}}
										</div>
									{{/each}}	
									</div>
								</div>
							</div>
						 
						</div>
					-->	
						<div class="tab-pane" id="dataapps" role="tabpanel" aria-labelledby="tab-dataapps">
						<div class="parent-superflex">
						
							<!-- Applications Using the Data Object -->
							<div class="superflex">
							<h3 class="text-primary" id="apps-using-heading">
								<i class="fa fa-desktop right-10" aria-hidden="true"></i>
								<xsl:value-of select="eas:i18n('Applications Using the Data Object')"/>
							</h3>

							<div class="ess-dos-apps-wrapper" aria-labelledby="apps-using-heading">
								{{#each this.appsArray}}
								<section class="ess-dos-app bg-offwhite" role="region" aria-label="{{this.name}}">
								<h4 class="large impact bottom-5">
									{{{essRenderInstanceMenuLink this}}}
								</h4>

								{{#each this.values}}
								<div class="bottom-5">
									<strong><xsl:value-of select="eas:i18n('Appears in')"/>:</strong>
									<span class="label label-link bg-darkgrey">{{this.nameirep}}</span>
								</div>

								<div>
									{{#if this.datarepsimplemented}} 
									<span class="dbicon" aria-label="{{this.category}}">{{this.category}}</span>
									<span class="classiflist">
										{{#each ../this.classifications}}
										<span class="label label-info">{{this.name}}</span>
										{{/each}}
									</span>
									<div><strong><xsl:value-of select="eas:i18n('Where')"/>:</strong></div>

									{{#each this.datarepsimplemented}}
									<div class="datatype">
										<span class="appTableHeader">{{#getDataRep this.dataRepid}}{{/getDataRep}}</span>
									</div>
									<div class="datacrud" aria-label="CRUD permissions">
										<span class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</span>
										<span class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</span>
										<span class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</span>
										<span class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</span>
									</div>
									<div class="clearfix"></div>
									{{/each}}

									{{else}}
									<div class="datacrud" aria-label="CRUD permissions">
										<div class="strong small bottom-5">
										<xsl:value-of select="eas:i18n('Operations')"/>:
										</div>
										<span class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</span>
										<span class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</span>
										<span class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</span>
										<span class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</span>
									</div>
									{{/if}}
								</div>
								{{/each}}
								</section>
								{{/each}}
							</div>
							</div>

							<!-- Applications Impacted by the Information Representation(s) -->
							<div class="superflex">
							<h3 class="text-primary" id="apps-impacted-heading">
								<i class="fa fa-desktop right-10" aria-hidden="true"></i>
								<xsl:value-of select="eas:i18n('Applications Impacted by the Information Representation(s) using the Object')"/>
							</h3>

							<div class="ess-dos-apps-wrapper" aria-labelledby="apps-impacted-heading">
								{{#each this.appsImpactedArray}}
								<section class="ess-dos-app bg-offwhite" role="region" aria-label="{{this.name}}">
								<h4 class="large impact bottom-5">
									{{{essRenderInstanceMenuLink this}}}
								</h4>

								{{#each this.values}}
								<div class="bottom-5">
									<strong><xsl:value-of select="eas:i18n('Appears in')"/>:</strong>
									<span class="label label-link bg-darkgrey">{{this.nameirep}}</span>
								</div>

								<div>
									{{#if this.datarepsimplemented}} 
									<span class="dbicon" aria-label="{{this.category}}">{{this.category}}</span>
									<span class="classiflist">
										{{#each ../this.classifications}}
										<span class="label label-info">{{this.name}}</span>
										{{/each}}
									</span>
									<div><strong><xsl:value-of select="eas:i18n('Where')"/>:</strong></div>

									{{#each this.datarepsimplemented}}
									<div class="datatype">
										<span class="appTableHeader">{{#getDataRep this.dataRepid}}{{/getDataRep}}</span>
									</div>
									<div class="datacrud" aria-label="CRUD permissions">
										<span class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</span>
										<span class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</span>
										<span class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</span>
										<span class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</span>
									</div>
									<div class="clearfix"></div>
									{{/each}}

									{{else}}
									<div class="datacrud" aria-label="CRUD permissions">
										<div class="strong small bottom-5">
										<xsl:value-of select="eas:i18n('Operations')"/>:
										</div>
										<span class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</span>
										<span class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</span>
										<span class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</span>
										<span class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</span>
									</div>
									{{/if}}
								</div>
								{{/each}}
								</section>
								{{/each}}

								<!-- Required by other apps -->
								{{#each this.requiredByApps}}
								<section class="ess-dos-app bg-offwhite" role="region" aria-label="{{this.name}} required data object">
								<p>
									<button class="btn btn-primary btn-xs" aria-label="Required application">Required</button>
									<span>by</span>
								</p>
								<h4 class="large impact bottom-5">
									{{{essRenderInstanceMenuLink this}}}
								</h4>
								</section>
								{{/each}}
							</div>
							</div>

						</div>
						</div>

						{{#if processes}}
						<div class="tab-pane" id="dataprocess" role="tabpanel" aria-labelledby="tab-dataprocess">
						<div class="parent-superflex">
							<div class="superflex">

							<h3 class="text-primary" id="dataprocess-heading">
								<i class="fa fa-desktop right-10" aria-hidden="true"></i>
								<xsl:value-of select="eas:i18n('Processes')"/>
							</h3>

							<div class="ess-dos-processes-wrapper" aria-labelledby="dataprocess-heading">
								{{#each processes}}

								<section class="ess-dos-process bg-offwhite" role="region" aria-label="{{this.name}}">
								<h4 class="large impact bottom-5">
									{{{essRenderInstanceMenuLink this}}} 
								</h4>

								<p class="bottom-5">
									<strong><xsl:value-of select="eas:i18n('Performed by')"/>: </strong>
									<span class="label label-link bg-darkgrey">{{{essRenderInstanceMenuLink this.actor}}} </span>
								</p>

								<p class="bottom-5">
									<strong><xsl:value-of select="eas:i18n('Using')"/>: </strong>
									<span class="label label-link bg-purple-40">
									{{this.nameirep}} ({{this.category}})
									</span>
								</p>

								<div class="datacrud" aria-label="CRUD operations for {{this.name}}">
									<p class="strong small bottom-5">
									<xsl:value-of select="eas:i18n('Operations')"/>:
									</p>
									<div class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</div>
									<div class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</div>
									<div class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</div>
									<div class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
								</div>
								</section>

								{{/each}}
							</div>

							</div>
						</div>
						</div>
						{{else}}
							{{#if this.requiredByProcesses}}
								<div class="tab-pane" id="dataprocess" role="tabpanel" aria-labelledby="tab-dataprocess">
									<div class="parent-superflex">
										<div class="superflex">
											<h3 class="text-primary" id="dataprocess-heading">
												<i class="fa fa-desktop right-10" aria-hidden="true"></i>
												<xsl:value-of select="eas:i18n('Processes')"/>
											</h3>

											<div class="ess-dos-processes-wrapper" aria-labelledby="dataprocess-heading">
												{{#each this.requiredByProcesses}}
												<section class="ess-dos-process bg-offwhite" role="region" aria-label="{{this.name}}">
													<p>
														<button class="btn btn-primary btn-xs" aria-label="Required process">Required</button>
														<span>by</span>
													</p>
													<h4 class="large impact bottom-5">
														{{{essRenderInstanceMenuLink this}}}
													</h4>
												</section>
												{{/each}}
											</div>

										</div>
									</div>
								</div>
							{{/if}}

						{{/if}}
						{{#if this.externalDocs}}
					<div class="tab-pane" id="documents" role="tabpanel" aria-labelledby="tab-documents">
					<div class="parent-superflex">
						<div class="superflex">

						<h3 class="text-primary" id="documents-heading">
							<i class="fa fa-desktop right-10" aria-hidden="true"></i>
							<xsl:value-of select="eas:i18n('Documentation')"/>
						</h3>

						{{#each this.externalDocs}}
						<section class="doc-link-blob bdr-left-blue" role="region" aria-labelledby="doc-title-{{@index}}">
							
							<div class="doc-link-icon" aria-hidden="true">
							<i class="fa fa-file-o"></i>
							</div>

							<div class="doc-link-label">
							<h4 id="doc-title-{{@index}}">
								<a
								target="_blank"
								rel="noopener noreferrer"
								aria-label="Open documentation: {{this.name}} (opens in a new window)"><xsl:attribute name="href">{{this.link}}</xsl:attribute>
								{{this.name}} <i class="fa fa-external-link" aria-hidden="true"></i>
								</a>
							</h4>
							</div>

							<div class="doc-description">
							{{this.description}}
							</div>

						</section>
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
			var regulations=[<xsl:apply-templates select="$regulation" mode="regulation"/>]
	 
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
			var busProcs=[<xsl:apply-templates select="$busProcs" mode="procInfo"/>];
			var physProcs=[<xsl:apply-templates select="$physProcs" mode="physProcInfo"/>];
			var appProToProcess=[<xsl:apply-templates select="$allProctoApp" mode="infoToProcess"/>];
 console.log('physProcs',physProcs)
  console.log('busProcs',busProcs)
			var allDO=[];
			var table;
			var stakeholdertable;
			var stakeholdertable2;

			$('document').ready(function (){ 
				Handlebars.registerHelper('getDataRep', function(arg1) {
					let thisDr = DRList.find((dr)=>{
						return dr.id==arg1;
					}); 
					return thisDr.name;
				});
				
				$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
				  $('[data-toggle="tooltip"]').tooltip();
				})
				
				

				Handlebars.registerHelper('CRUDVal', function(arg1) {
					if(arg1=='Yes'){
						return '<div class="ess-circle" title="Yes" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-check-circle-o" style="color:#5cb85c;font-size:12pt"></i></div>'
					}else
					if(arg1=='No'){
						return '<div class="ess-circle" title="No" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-times-circle-o" style="color:#d9534f;;font-size:12pt"></i></div>'
					}else{
						return '<div class="ess-circle" title="Unknown" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-question-circle" style="color:#f0ad4e;font-size:12pt"></i></div>'
					}
				});
 
			Promise.all([ 
				promise_loadViewerAPIData(viewAPIDataDO) 
				]).then(function (responses){  
				 
					allDO=responses[0];
					let focusDOid='<xsl:value-of select="$param1"/>';
					let focusDO=allDO.data_objects.find((f)=>{
						return f.id==focusDOid
					})


					if(focusDO){
						//do nothing
					}else{
						focusDO=allDO.data_objects[0];
						}
					
					DOList=responses[0] ; 
					DRList=responses[0].data_representation ; 
		  
					allDO.data_objects.forEach((e)=>{
					 
						var option = new Option(e.name, e.id); 
						$('#subjectSelection').append($(option));  
							let theDrs=[]
							e.dataReps.forEach((f)=>{
								let thisDr=DRList.find((dr)=>{
									return dr.id ==f.id;
								}); 
								theDrs.push(thisDr)
							});
							e['dataReps']=theDrs
  
							var nested_apps = d3.nest()
								.key(function(f) { return f.id; })
								.entries(e.infoRepsToApps); 

								nested_apps.forEach((d)=>{
									let thisApp=e.infoRepsToApps.find((f)=>{
										return d.key == f.id;
									})
									d['name']=thisApp.name;
									d['id']=thisApp.id;
									d['className']='Application_Provider';
								})

								nested_apps=nested_apps.sort((a, b) => a.key.localeCompare(b.name))

								const useData = [];
								const impactedBy = [];

								nested_apps.forEach(app => {
									const datareps = app.values?.[0]?.datarepsimplemented || [];

									if (datareps.length > 0) {
										useData.push(app);
									} else {
										impactedBy.push(app);
									}
								});


							e['appsArray']=useData;
							e['appsImpactedArray']=impactedBy; 
							e['processes']=[];
							e.infoRepsToApps.forEach((doira)=>{
								let thisProcess=appProToProcess.filter((f)=>{
									return f.app_info_rep == doira.id
								})
								 
						 if(thisProcess.length&gt;0){
								thisProcess[0].physicalProcesses.forEach((p)=>{
									let match=physProcs.find((m)=>{
										return m.id==p.id
									})
									if(match){
										e.processes.push({"id":thisProcess[0].processes[0].id,"infoRepid":thisProcess[0].app_info_rep,"name":thisProcess[0].processes[0].name, "actor":match.actorDetail, "category": doira.category, "nameirep":doira.nameirep, "create":doira.create, "read":doira.read, "update":doira.update ,"delete":doira.delete, "persisted": doira.persisted, "className":'Business_Process'})
									}

								})
							}

							})
						 
						});

					$('#subjectSelection').select2(); 
					$('#subjectSelection').val(focusDOid).change();

					var panelFragment = $("#panel-template").html();
					panelTemplate = Handlebars.compile(panelFragment);

					
					Handlebars.registerHelper('ifContains', function(arg1, arg2, options) {
					 
						if(arg1.roleName.includes(arg2)){
							return '<label>'+arg1.roleName+'</label><ul class="ess-list-tags"><li class="tagActor">'+arg1.actorName+'</li></ul>'
						}  
					});

					Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});
			
					redrawPage(focusDO)
	});

	function redrawPage(focusDO) {
		regulations.forEach((d)=>{
			let match=d.elements.find((e)=>{
				return e.id==focusDO.id;
			})
			 
			if(match){
				focusDO.classifications.push({"id":match.id,"name":d.name})
			}
		})

		focusDO.classifications  = focusDO.classifications.filter((obj, index, self) =>
		index === self.findIndex((t) => (
		  t.name === obj.name
		))
	  );
	    let panelSet = new Promise(function (myResolve, myReject) {
	        
	        let stakes = d3.nest().key(function (d) {
	            return d.roleName;
	        }).key(function (d) {
	            return d.actorName;
	        }).entries(focusDO.stakeholders);
	        
	        
	        focusDO[ 'stakeholdersList'] = stakes;
	        
	        stakes.forEach((k) => {
	            k.values.forEach((s) => {
	                s[ 'name'] = s.key;
	                s[ 'id'] = s.values[0].actorId;
	                s[ 'className'] = 'Individual_Actor';
	            });
	        })
	      //  console.log('DO', focusDO)
	        $('#mainPanel').html(panelTemplate(focusDO))
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
	            responsive: true,
	            columns:[ {
	                "width": "30%"
	            }, {
	                "width": "50%"
	            }, {
	                "width": "20%"
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
	        table.columns().every(function () {
	            let that = this;
	            
	            $('input', this.footer()).on('keyup change', function () {
	                if (that.search() !== this.value) {
	                    that.search(this.value).draw();
	                }
	            });
	        });
	        table.columns.adjust();
	        
	        
	        // $('#mainPanel').html(panelTemplate(focusDO))
	        
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
	        
	        let focusDO = allDO.data_objects.find((f) => {
	            return f.id == selected;
	        });
	        redrawPage(focusDO);
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
<xsl:template match="node()" mode="procInfo">
	<xsl:variable name="physProcess" select="key('physProcsKey', current()/name)"/>
	<xsl:variable name="physProcesstoApp" select="key('physProcsToAppKey', current()/name)"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMapName" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultName" select="serialize($combinedMapName, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultName,'{'),'}')"/>,
		"physProcesses":[
		<xsl:for-each select="$physProcess"> 
		<xsl:variable name="thisActor" select="key('allActorsInstances', current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
		<xsl:variable name="thisActorviaA2R" select="key('allActors_key',$thisActor/name)"/>
		<xsl:variable name="physProcesstoApp" select="key('physProcsToAppKey', current()/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMapName" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultName" select="serialize($combinedMapName, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultName,'{'),'}')"/>,
			<xsl:choose>
				<xsl:when test="$thisActor/type='ACTOR_TO_ROLE_RELATION'"> 
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'actor': string(translate(translate($thisActorviaA2R/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActorviaA2R/name)"/>",			
				</xsl:when>
				<xsl:otherwise> 
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate($thisActor/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"actorDetail":{"id":"<xsl:value-of select="eas:getSafeJSString($thisActor/name)"/>",<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "className":"Group_Actor"},
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActor/name)"/>",		
				</xsl:otherwise>
			</xsl:choose>
			"usages":[<xsl:for-each select="$physProcesstoApp">  
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						<xsl:variable name="combinedMapName" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					}" />
					<xsl:variable name="resultName" select="serialize($combinedMapName, map{'method':'json', 'indent':true()})" />
					<xsl:value-of select="substring-before(substring-after($resultName,'{'),'}')"/>,
					"appInfoRep":"<xsl:value-of select="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if> 
				</xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if> 
	</xsl:for-each>]
	}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template>
<xsl:template match="node()" mode="physProcInfo">  
	 <xsl:variable name="thisActor" select="key('allActorsInstances', current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
		<xsl:variable name="thisActorviaA2R" select="key('allActors_key',$thisActor/name)"/>
		<xsl:variable name="physProcesstoApp" select="key('physProcsToAppKey', current()/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMapName" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultName" select="serialize($combinedMapName, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultName,'{'),'}')"/>,
			<xsl:choose>
				<xsl:when test="$thisActor/type='ACTOR_TO_ROLE_RELATION'"> 
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'actor': string(translate(translate($thisActorviaA2R/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActorviaA2R/name)"/>"			
				</xsl:when>
				<xsl:otherwise> 
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate($thisActor/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"actorDetail":{"id":"<xsl:value-of select="eas:getSafeJSString($thisActor/name)"/>",<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "className":"Group_Actor"},
				"actorid":"<xsl:value-of select="eas:getSafeJSString($thisActor/name)"/>"
				</xsl:otherwise>
			</xsl:choose>
			<!--"usages":[<xsl:for-each select="$physProcesstoApp">  
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					"name":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="isForJSONAPI" select="true()"/>
					</xsl:call-template>",
					"appInfoRep":"<xsl:value-of select="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if> 
				</xsl:for-each>]-->
			}<xsl:if test="position()!=last()">,</xsl:if> 
 
</xsl:template>
<xsl:template match="node()" mode="infoToProcess"> 
<xsl:variable name="physProcesstoApp" select="key('physProcstoMapKey', current()/name)"/>
<xsl:variable name="busProcess" select="key('busProcsKey', $physProcesstoApp/name)"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"app_info_rep":"<xsl:value-of select="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"processes":[<xsl:for-each select="$busProcess">
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
			}<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>
		],
	"physicalProcesses":[<xsl:for-each select="current()/own_slot_value[slot_reference='physbusproc_to_appinfoview_from_physbusproc']/value">
			{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"
			}<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>
		],
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
				console.log('linkMenuName', linkMenuName)
					console.log('instanceLink', instanceLink)
						console.log('instance', instance)
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
	<xsl:template match="." mode="regulation">
		<xsl:variable name="reg" select="key('regRels', current()/name)"/>

		{"id":"<xsl:value-of select="current()/name"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"elements":[<xsl:for-each select="$reg/own_slot_value[slot_reference = 'regulated_component_to_element']/value">{"id":"<xsl:value-of select="."/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
</xsl:stylesheet>