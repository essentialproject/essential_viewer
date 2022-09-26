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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>
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
	 rto_for_business_criticalities and rpo_for_business_criticalities
	 Recovery_Time_Objective  slot ea_recovery_time_objective
	 Recovery_Point_Objective slot  ea_recovery_point_objective  

	  rto_for_business_criticalities on RTO to Business_Criticality

	  rpo_for_business_criticalities on RPO to Business_Criticality
	-->
	<xsl:variable name="rtoRpo" select="/node()/simple_instance[type=('Recovery_Time_Objective','Recovery_Point_Objective')]"/>
	<xsl:variable name="busCriticality" select="/node()/simple_instance[type=('Business_Criticality')]"/> 
	<xsl:variable name="processCriticality" select="/node()/simple_instance[type=('Business_Process')][own_slot_value[slot_reference='bpt_business_criticality']/value=$busCriticality/name]"/>
	<xsl:variable name="rtoApps" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][own_slot_value[slot_reference='ea_recovery_time_objective']/value=$rtoRpo/name]"/>
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="capsListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
	<xsl:variable name="servicesListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Services']"></xsl:variable>

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
		<xsl:variable name="apiSvcs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$servicesListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
	 
<!--		<xsl:variable name="apiScores">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$scoreData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
	-->
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<script src="js/d3/d3.v5.9.7.min.js"></script>
				<title>Business Process RTO/RPO Mapping</title>
				<style>
					.l0-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid hsla(200, 80%, 50%, 1);
						border-bottom: 1px solid #fff;
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 10px;
						margin-bottom: 15px;
						font-weight: 700;
						position: relative;
					}
					.l1-caps-wrapper{
						display: flex;
						flex-wrap: wrap;
						margin-top: 10px;
					}
					
					.l2-caps-wrapper,.l3-caps-wrapper,.l4-caps-wrapper,.l5-caps-wrapper,.l6-caps-wrapper{
						margin-top: 10px;
					}
					
					.l1-cap,.l2-cap,.l3-cap,.l4-cap{
						border-bottom: 1px solid #fff;
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 5px;
						margin: 0 10px 10px 0;
						font-weight: 400;
						position: relative;
						min-height: 60px;
						line-height: 1.1em;
					}
					
					.l1-cap{
						min-width: 200px;
						width: 200px;
						max-width: 200px;
					}
					
					.l2-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid hsla(200, 80%, 50%, 1);					
						background-color: #fff;
						min-width: 180px;
						width: 180px;
						max-width: 180px;
					}
					
					.l3-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid rgb(125, 174, 198);					
						background-color: rgb(218, 214, 214);
						min-width: 160px;
						width: 160px;
						max-width: 160px;
						min-height: 60px;

					}
					
					.l4-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid rgb(180, 200, 210);					
						background-color: rgb(164, 164, 164);
						min-width: 140px;
						width: 140px;
						max-width: 140px;
						min-height: 60px;

					}

					.l5on-cap{
						min-width: 90%;
						width: 90%; 
						min-height: 50px;
						border:1pt solid #d3d3d3;
						background-color:#fff;
						margin:2px;

					}

					.off-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid rgb(125, 174, 198);					
						background-color: rgb(237, 237, 237);
						color:#d3d3d3;  

					}
					
					.cap-label,.sub-cap-label{
						margin-right: 20px;
						margin-bottom: 10px;
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
					.rpoblob{
						border-radius: 16px;
						display: inline-block;
						min-width: 40px;
						text-align: center;
						font-weight: bold;
						padding: 0 10px;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process RTO/RPO Mapping')"></xsl:value-of> </span>
									
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
						<div class="col-xs-12" id="keyHolder"/>

						<div class="col-md-6">
							
							
						</div>
						<div class="col-xs-12">
							<div class="pull-left right-30">
								<div class="keyLabel">Legend</div>
							<div class="keySampleWide backColourRed"/>
							<div class="keySampleLabel">Less than Process Required RPO/RTO</div>
							<div class="keySampleWide backColourGreen"/>
							<div class="keySampleLabel">Same or above Process Required RPO/RTO</div>
							</div>
							<script>
								$(document).ready(function(){
								$('.fa-question-circle').popover({
								container: 'body',
								html: true,
								trigger: 'click',
								placement: 'auto',
								content: function(){
								return $(this).next().html()
								}
								}).on("show.bs.popover", function(){$(this).data("bs.popover").tip().css("max-width", "600px");});
								});
							</script>
							<div class="pull-left">
								<span class="impact">About RPO/RTO</span>
								<i class="fa fa-question-circle left-5"/>
								<div class="hiddenDiv">
									<p>Recovery Time Objective (RTO) is the duration of time and a service level within which a business process must be restored after a disaster in order to avoid unacceptable consequences associated with a break in continuity. In other words, the RTO is the answer to the question: “How much time did it take to recover after notification of business process disruption?</p>
									<p>RPO designates the variable amount of data that will be lost or will have to be re-entered during network downtime. RTO designates the amount of “real time” that can pass before the disruption begins to seriously and unacceptably impede the flow of normal business operations.
									</p>
								</div>
							</div>
						</div>
						<div class="col-xs-12" id="mainTable">
							<table class="table" id="rpTable" width="100%">
								<thead>
									<tr>
										<th>Process</th>
										<th>RTO</th>
										<th>RPO</th>
										<th>Applications</th>
									</tr>
								</thead>
								<tbody id="rtorpotable"/>
								<tfoot>
									<tr>
										<th>Process</th>
										<th>RTO</th>
										<th>RPO</th>
										<th>Applications</th>
									</tr>
								</tfoot>
							</table>
						</div>

						<div class="col-xs-12" id="dataHolder"/>
						
						<!--Setup Closing Tags-->
				
						</div>
				</div>


			 
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

				<!-- caps template -->
 
				<script id="app-template" type="text/x-handlebars-template">
	 
					<div class="row">
	                
					</div>
				</script>
						
	<script id="row-template" type="text/x-handlebars-template">
		{{#each this}}
		{{#if this.name}}
			<tr>
				<td class="" >
					{{name}}
						<span class="critical">
								<div class="rpoblob"><xsl:attribute name="style">background-color:{{this.enumColour}};color:{{this.enumTextColour}}</xsl:attribute>{{criticality}}</div>
						</span>
				</td>
				<td>
						{{#if this.rpo}}
							{{this.rpo}}
						{{else}}
							Not Set
						{{/if}}
				</td>
				<td>
						{{#if this.rto}}	
							{{this.rto}}
						{{else}}
							Not Set
						{{/if}}
				</td>
				<td class="">
					<strong class="right-5">Count:</strong>
					<div class="rpoblob" style="background-color:#000;color:#fff">{{this.applications.length}}</div>
				 	<span class="number-box bg-red left-15 right-5">
						{{#getRPORTOColours this}}{{/getRPORTOColours}}
					</span> 
			 		<div class="pull-right right-20">
						<span class="action-btn" data-toggle="collapse" href="#InnerDataId1" aria-expanded="false" aria-controls="InnerDataId1"><xsl:attribute name="easidparent">{{this.id}}</xsl:attribute>
							<i class="fa fa-caret-down"></i>
						</span>
					</div>
				</td>
		</tr>
		<tr class="inner-tr collapse in" aria-expanded="false" style="display:hide; background-color:#f6f6f6;"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<td class="impact" colspan="" width="250px">
					<span color="#d3d3d3">{{name}}</span>	
				</td>
				<td class="" colspan="" width="100px">
				</td>
				<td class="" colspan="" width="100px">
				</td>
				<td class="">
				
						<div class="application-section">
							<table>
								<thead>
									<tr><th width="300px">Application</th><th width="100px">RPO</th><th width="100px">RTO</th></tr>
								</thead>
								{{#each this.applications}}
								<tr>
									<td>{{name}}</td>
									<td>{{#setRPO this ../this}}{{/setRPO}}</td>
									<td>{{#setRTO this ../this}}{{/setRTO}}</td>
								</tr>
								{{/each}}
							</table> 
						</div> 
				</td>
		</tr>
		{{/if}}
		{{/each}}
	</script>	
</body>	
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathSvcs" select="$apiSvcs"></xsl:with-param>  				
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathCaps"></xsl:param> 
		<xsl:param name="viewerAPIPathSvcs"></xsl:param> 
	let workingArray=[];	
	let appsRTORPOVals=[<xsl:apply-templates select="$rtoApps" mode="apps"/>]	
	let RTORPOEnums=[<xsl:apply-templates select="$rtoRpo" mode="rtoRpo"/>]
	let criticalEnums=[<xsl:apply-templates select="$busCriticality" mode="criticality"/>]
	let processCriticality=[<xsl:apply-templates select="$processCriticality" mode="processCriticality"/>];
 
	<!--	<xsl:param name="viewerAPIPathScores"></xsl:param>-->
		
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
		var viewAPIDataSvcs = '<xsl:value-of select="$viewerAPIPathSvcs"/>'; 
		
		
<!--		var viewAPIScores= '<xsl:value-of select="$viewerAPIPathScores"/>';-->
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

	
	 	showEditorSpinner('Fetching Data...');
		$('document').ready(function ()
		{
			$('#rpTable tfoot th').each( function () {
				var srchtitle = $(this).text();
				$(this).html( '&lt;input type="text" placeholder="Search '+srchtitle+'" /&gt;' );
			});

<!--			let rpTable = $('#rpTable').dataTable({  
				"autoWidth" : false,
				"columns": [
					{ width: '250px'},
					{ width: '100px'},
					{ width: '100px'}, 
					{ width: '500px'} 
			
				]  })

				rpTable.columns().every( function () {
					var that = this;
			 
					$( 'input', this.footer() ).on( 'keyup change', function () {
						if ( that.search() !== this.value ) {
							that
								.search( this.value )
								.draw();
						}
					} );
				} );
			-->
		

			appFragment = $("#app-template").html();
			appTemplate = Handlebars.compile(appFragment);
			
			var rowFragment = $("#row-template").html();
			rowTemplate = Handlebars.compile(rowFragment);

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});

			Handlebars.registerHelper('setRPO', function (arg1, arg2, options) {
				let processScore=arg2.rpoNum;
				let thisScore=100
				if(arg1.rpo){
					thisScore=arg1.rpo.enumNum;
				}
				
				if(thisScore&lt;=processScore){
					return '<div class="rpoblob" style="background-color:green;color:#fff;border:2pt solid #fff">'+arg1.rpo.enum+'</div>';
				}
				else
				{
					if(arg1.rpo){
						return '<div class="rpoblob" style="background-color:red;color:#fff;border:2pt solid #fff">'+arg1.rpo.enum+'</div>';
					}
					else{
						return '<div class="rpoblob" style="background-color:#d3d3d3;color:#000;border:2pt solid #fff">Not Set</div>';	
					}
				}


			})
			Handlebars.registerHelper('setRTO', function (arg1, arg2, options) {
				let processScore=arg2.rtoNum;
				let thisScore=100
				if(arg1.rto){
					thisScore=arg1.rto.enumNum;
				}
				
				if(thisScore&lt;=processScore){
					return '<div class="rpoblob" style="background-color:green;color:#fff;border:2pt solid #fff">'+arg1.rto.enum+'</div>';
				}
				else
				{
					if(arg1.rpo){
						return '<div class="rpoblob" style="background-color:red;color:#fff;border:2pt solid #fff">'+arg1.rto.enum+'</div>';
					}
					else{
						return '<div class="rpoblob" style="background-color:#d3d3d3;color:#000;border:2pt solid #fff">Not Set</div>';	
					}
				}


			})

			Handlebars.registerHelper('getRPORTOColours', function (arg1, options) {
				let thisRpoScore=parseInt(arg1.rpoNum);
				let thisRtoScore=parseInt(arg1.rtoNum)

				let rtgreenScore=0;
				let rtredScore=0
				let rpgreenScore=0;
				let rpredScore=0
			 if(thisRpoScore){
		 
			 }
			 
				arg1.applications.forEach((d)=>{
					 
					if(d.rpo){ 
						if(d.rpo.enumNum &lt;= thisRpoScore){
							rpgreenScore=rpgreenScore+1;
						}
						else
						{
							rpredScore=rpredScore+1;
						}
					}else
					{
						rpredScore=rpredScore+1;
					}
				 
					if(d.rto) {
						if(d.rto.enumNum &lt;= thisRtoScore){
							rtgreenScore=rtgreenScore+1;
						}
						else
						{
							rtredScore=rtredScore+1;
						}
			 
					}else
					{ 
						rtredScore=rtredScore+1;
					}
				})
 
 return '<strong class="right-5">RPO:</strong><div class="rpoblob right-5" style="background-color:#5cb85c;color:#fff">'+rpgreenScore+' </div><div class="rpoblob right-5" style="background-color:#ce4844;color:#fff">'+rpredScore+'</div><xsl:text> </xsl:text> <strong class="left-15 right-5">RTO:</strong> <div class="rpoblob right-5" style="background-color:#5cb85c;color:#fff">'+rtgreenScore+'</div><div class="rpoblob" style="background-color:#ce4844;color:#fff">'+rtredScore+'</div>';
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
			
			processCriticality.forEach((d)=>{
				let thisCriticality=criticalEnums.find((e)=>{
					return e.id == d.criticality;
				})

				d['criticality']=thisCriticality.enum;
				d['criticalityNum']=thisCriticality.enumNum;
		 
			})
 
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataCaps), 
	 		promise_loadViewerAPIData(viewAPIDataSvcs)
			]).then(function (responses)
			{
				workingArray=[];
			 
				responses[0].process_to_apps.forEach((d)=>{
				 
					let thisCriticality=processCriticality.find((f)=>{
						return f.id == d.processid;
					}) 
					d['enumColour']="#d3d3d3";
					d['enumTextColour']= "#000000";
					if(thisCriticality){
						d['criticality']=thisCriticality.criticality;
						d['criticalityNum']=thisCriticality.criticalityNum;
						let thisEnum= criticalEnums.find((e)=>{
							return e.enumNum==thisCriticality.criticalityNum
						});
						if(thisEnum.enumColour){
						d['enumColour']=thisEnum.enumColour;
						d['enumTextColour']= thisEnum.enumTextColour;
						}
					}else{
						d['criticality']='Not Set';
						d['criticalityNum']=0;
					}
				

					let thisApps=[];
			 
					if(d.appsdirect.length&gt;0){ 
						d.appsdirect.forEach((e)=>{
							thisApps.push(e.id)
						});
					}
					if(d.appsviaservice.length&gt;0){ 
						d.appsviaservice.forEach((e)=>{ 
							if(e.appid.length&gt;0){
								thisApps.push(e.appid)
							} 
						}) 
					}	

 					
					let appInfo=[]; 
					thisApps.forEach((e)=>{ 
						let appMatch=responses[1].applications.find((f)=>{
							return f.id == e;
						}); 
						let rtoRpo=appsRTORPOVals.find((ap)=>{
							return ap.id==e;
						}) ;

						if(rtoRpo){
							let thisRpo = RTORPOEnums.find((f)=>{
								return rtoRpo.rpo == f.id;
							})
							let thisRto = RTORPOEnums.find((f)=>{
								return rtoRpo.rto == f.id;
							})
							appMatch['rto']=thisRpo;
							appMatch['rpo']=thisRto;
						} 
						appInfo.push(appMatch);
					})

 
					let thisrtrpEnu= criticalEnums.find((e)=>{
						return e.enumNum==d.criticalityNum
					});
				
					if(thisrtrpEnu){
					 
					let thisRpo = RTORPOEnums.find((f)=>{
						return thisrtrpEnu.linkedRPO[0] == f.id;
					})
					
					let thisRto = RTORPOEnums.find((f)=>{
						return thisrtrpEnu.linkedRPO[0] == f.id;
					})
					if(thisRto){}else{thisRto=[]}
					if(thisRpo){}else{thisRpo=[]}
				
					workingArray.push({"id":d.id,"id":d.processid,"name":d.processName,"org":d.org, "applications":appInfo,"criticality":d.criticality,"criticalityNum":d.criticalityNum, "rpo":thisRpo.name,"rto":thisRto.name, "rpoNum":thisRpo.enumNum,"rtoNum":thisRto.enumNum, "enumColour": d.enumColour, "enumTextColour": d.enumTextColour})	
					}	
					else
					{
						workingArray.push({"id":d.id,"id":d.processid,"name":d.processName,"org":d.org,"criticality":"High","applications":appInfo,"criticality":d.criticality,"criticalityNum":d.criticalityNum, "enumColour": d.enumColour, "enumTextColour": d.enumTextColour})	
					}
						 
				})

				removeEditorSpinner()
  
				var byProcess = d3.nest()
						.key(function(d) { return d.id; })
						.entries(workingArray);
				 
				let newArray=[];
				byProcess.forEach((d)=>{
					let thisInfo=workingArray.find((n)=>{
						return d.key==n.id
					})
					 
					d['name']=thisInfo.name;
					let apps=[]; 
					let procInfo={};
					d.values.forEach((v,i)=>{ 
						if(i==0){

						}
						 
						v.applications.forEach((e)=>{ 
							apps.push(e) 
						})
				 				
						procInfo={'criticality': v.criticality, 'criticalityNum': v.criticalityNum, 'enumColour': v.enumColour, 'enumTextColour': v.enumTextColour, 'id': v.id, 'name': v.name, 'org': v.org, 'rpo': v.rpo, 'rpoNum': v.rpoNum, rto: v.rto, rtoNum: v.rtoNum}
						
					})
					let newapps=[...new Set(apps)]; 
						let procs = {'process':d.name, 'applications':newapps}
						Object.assign(procs, procInfo);
						newArray.push(procs)
					
				})

				//newArray=newArray.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
 
				workingArray=newArray;
				essInitViewScoping(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain']);
 
				var apptable = $('#rpTable').DataTable({
					scrollY: "350px",
					scrollCollapse: true,
					paging: false,
					columns: [
						{ width: '250px'},
						{ width: '75px'},
						{ width: '75px'}, 
						{ width: '500px'} 
					
					  ],
					  bSort : false  
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

					$('.collapse').hide()
					$('.action-btn').on('click',function(){
						let thisId=$(this).attr('easidparent');
						$('#'+thisId).toggle()
					})
					$('.paginate_button').on('click',function(){
						$('pag')
						$('.collapse').hide()
					})
					

					
			}).catch (function (error)
			{
				//display an error somewhere on the page
			});
			

var redrawView=function(){
 
	let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
	let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
	let busDomainDef = new ScopingProperty('domainIds', 'Business_Domain');
	
	<!--scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef]);
	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef]);
	-->
  
	$('#rtorpotable').html(rowTemplate(workingArray));
}


function redrawView() {
	essRefreshScopingValues()
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
	<xsl:template match="node()" mode="processCriticality"> 
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"criticality":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='bpt_business_criticality']/value)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="rtoRpo"> 
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"enum":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"enumNum":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>",
		"linkedCriticalities":[<xsl:for-each select="current()/own_slot_value[slot_reference='rto_for_business_criticalities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each><xsl:for-each select="current()/own_slot_value[slot_reference='rpo_for_business_criticalities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="criticality"> 
		<xsl:variable name="rto" select="$rtoRpo[own_slot_value[slot_reference='rto_for_business_criticalities']/value=current()/name]"/>
		<xsl:variable name="rpo" select="$rtoRpo[own_slot_value[slot_reference='rpo_for_business_criticalities']/value=current()/name]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"enum":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"enumNum":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>",
		"enumColour":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
		"enumTextColour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>",	
		"linkedRTO":[<xsl:for-each select="$rto">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"linkedRPO":[<xsl:for-each select="$rpo">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="apps"> 
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"rto":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ea_recovery_time_objective']/value)"/>",
	"rpo":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ea_recovery_point_objective']/value)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
