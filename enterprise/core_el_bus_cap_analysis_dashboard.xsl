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
	 
	-->
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
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
				<script src="js/d3/d3.min.js"></script>
				<title>Business Capability Model</title>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Capability Dashboard')"></xsl:value-of> - </span>
									<span class="text-primary">
										<span id="rootCap"></span>
									</span>
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
							<div id="blobLevel" ></div>
							<div class="pull-right Key"><b><xsl:value-of select="eas:i18n('Caps Style')"></xsl:value-of>:</b><button class="btn btn-xs btn-secondary" id="hideCaps">Show</button><xsl:text> </xsl:text><xsl:text> </xsl:text>
								<b><xsl:value-of select="eas:i18n('Show Retired')"></xsl:value-of>	</b><input type="checkbox" id="retired" name="retired"/>
								<xsl:text> </xsl:text>
							<b><xsl:value-of select="eas:i18n('Application Usage Key')"></xsl:value-of></b>: <i class="fa fa-square shigh"></i> - <xsl:value-of select="eas:i18n('High')"/><xsl:text> </xsl:text> <i class="fa fa-square smed"></i> - <xsl:value-of select="eas:i18n('Medium')"/> <xsl:text> </xsl:text> <i class="fa fa-square slow"></i> - <xsl:value-of select="eas:i18n('Low')"/></div>
							<div class="pull-right showApps Key right-30" id="pmKey"><xsl:value-of select="eas:i18n('Ratings')"></xsl:value-of>:<input type="checkbox" id="fit" name="fit"></input></div>
						</div>
						<div class="col-xs-12" id="keyHolder">

						</div>

						<div class="col-xs-12" id="capModelHolder">
						</div>
						<div id="appSidenav" class="sidenav">
							<button class="btn btn-default appRatButton bottom-15 saveApps"><i class="fa fa-external-link right-5 text-primary "/>View in Rationalisation</button>
							<a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()">
								<i class="fa fa-times"></i>
							</a>
							<div class="clearfix"/>
							<!--<div class="iconCubeHeader"><i class="fa fa-th-large right-5"></i>Capabilities</div>
							<div class="iconCubeHeader"><i class="fa fa-users right-5"></i>Users</div>
							<div class="iconCubeHeader"><i class="fa essicon-boxesdiagonal right-5"></i>Processes</div>
							<div class="iconCubeHeader"><i class="fa essicon-radialdots right-5"></i>Services</div>-->
							<div class="app-list-scroller top-5">

								<div id="appsList"></div>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>


				<!-- Modal for content
				<div id="appModal" class="modal fade" role="dialog">
					<div class="modal-dialog">

						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal">
									<i class="fa fa-times"></i>
								</button>
								<h4 class="modal-title">APP INFORMATION</h4>
							</div>
							<div class="modal-body">
								<div id="appInfo">APP INFORMATION</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
				-->

				<div class="appPanel" id="appPanel">
						<div id="appData"></div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

				<!-- caps template -->
				<script id="model-l0-template" type="text/x-handlebars-template">
		         	<div class="capModel">
						{{#each this}}
							<div class="l0-cap"><xsl:attribute name="level">{{this.level}}</xsl:attribute>
								<span class="cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<br/>	{{#getApps this}}{{this}}{{/getApps}} 
							<!--	<span class="app-circle "> <xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
							-->
									{{> l1CapTemplate}}
								 
							</div>
						{{/each}}
					</div>
				</script>

				<!-- SubCaps template called iteratively -->
				<script id="model-l1cap-template" type="text/x-handlebars-template">
					<div class="l1-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l1-cap bg-darkblue-40 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
							{{#getApps this}}{{/getApps}} 
								{{> l2CapTemplate}} 	 
						</div>
						{{/each}}
					</div>
				</script>
				
				<!-- SubCaps template called iteratively -->
				<script id="model-l2cap-template" type="text/x-handlebars-template">
					<div class="l2-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l2-cap buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
							{{#getApps this}}{{/getApps}} 
								{{> l3CapTemplate}} 	 
						</div>
						{{/each}}
					</div>
				</script>
				
				<!-- SubCaps template called iteratively -->
				<script id="model-l3cap-template" type="text/x-handlebars-template">
					<div class="l3-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l3-cap bg-lightblue-80 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>		
							{{#getApps this}}{{/getApps}} 				 
								{{> l4CapTemplate}} 		 
						</div>
						{{/each}}
					</div>	
				</script>

				<script id="model-l4cap-template" type="text/x-handlebars-template">
					<div class="l4-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
					{{#each this.childrenCaps}}
					<div class="l4-cap bg-lightblue-80 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute>
						<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
						<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
						{{#getApps this}}{{/getApps}} 		
							{{> l5CapTemplate}}		 
					</div>
					{{/each}}
					</div>
			</script>
				
				<!-- SubCaps template called iteratively -->
				<script id="model-l5cap-template" type="text/x-handlebars-template">
					<div class="l4-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l5on-cap bg-lightblue-20 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>	 
							{{#getApps this}}{{/getApps}} 
							<div class="l5-caps-wrapper caplevel"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
									{{> l5CapTemplate}}
								</div>	
						</div>
						{{/each}}
					</div>	
				</script>
				<script id="blob-template" type="text/x-handlebars-template">
					<div class="blobBoxTitle right-10"> 
						<strong>Select Level:</strong>
					</div> 
					{{#each this}}
					<div class="blobBox">
						<div class="blobNum">{{this.level}}</div>
					  	<div class="blob"><xsl:attribute name="id">{{this.level}}</xsl:attribute></div>
					</div>
					{{/each}}
					<div class="blobBox">
						<br/>
						<div class="blobNum"> 
						<!--  hover over to say that blobs are clickable to chnage level
							<i class="fa fa-info-circle levelinfo " style="font-size:10pt"> 
							</i>
						-->	 
						</div>
				
					</div>
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
										<div class="left-5 bottom-5"><i class="fa essicon-radialdots right-5"></i>{{services.length}} Services Used</div>
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
								<li><a data-toggle="tab" href="#capabilities"><xsl:value-of select="eas:i18n('Capabilities')"/><span class="badge dark">{{capabilitiesSupporting}}</span></a></li>
								<li><a data-toggle="tab" href="#processes"><xsl:value-of select="eas:i18n('Processes')"/><span class="badge dark">{{processesSupporting}}</span></a></li>
								<li><a data-toggle="tab" href="#integrations"><xsl:value-of select="eas:i18n('Integrations')"/><span class="badge dark">{{totalIntegrations}}</span></a></li>
			                 	<li><a data-toggle="tab" href="#services"><xsl:value-of select="eas:i18n('Services')"/></a></li>
								<li></li>
							</ul>
							
					
							<div class="tab-content">
								<div id="summary" class="tab-pane fade in active">
									<div>
				                    	<strong><xsl:value-of select="eas:i18n('Description')"/></strong>
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
												<i class="fa fa-users right-5"/>{{processList.length}} <xsl:value-of select="eas:i18n('Processes Supported')"/></div>
		                				<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:#6849D0;color:#ffffff</xsl:attribute>
												<i class="fa fa-exchange right-5"/>{{totalIntegrations}} <xsl:value-of select="eas:i18n('Integrations')"/> ({{inI}} in / {{outI}} out)</div>
		                			</div>
								</div>
								<div id="capabilities" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Capabilities')"/>:</p>
									<div>
									{{#if capList}} 
									{{#each capList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#f5ffa1;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}}
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
									{{/if}}
									</div>
								</div> 
								<div id="processes" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Processes, supporting')"/> {{processList.length}} <xsl:value-of select="eas:i18n('processes')"/>:</p>
									<div>
									{{#if processes}}
									{{#each processList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
									{{/if}}
									</div>
								</div>
								<div id="services" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application provide the following services, i.e. could be used')"/>:</p>
									<div>
									{{#if allservList}}
									{{#each allservList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#c1d0db;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
									{{/if}}
								</div>
									<p class="strong"><xsl:value-of select="eas:i18n('The following services are actually used in business processes')"/>:</p>
									<div>
									{{#if services}}
									{{#each servList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#73B9EE;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
									{{/if}}
									</div>
								</div>
								<div id="integrations" class="tab-pane fade">
			                    <p class="strong"><xsl:value-of select="eas:i18n('This application has the following integrations')"/>:</p>
			                	<div class="row">
			                		<div class="col-md-6">
			                			<div class="impact bottom-10"><xsl:value-of select="eas:i18n('Inbound')"/></div>
			                				{{#each inIList}}
			                                <div class="ess-tag bg-lightblue-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                		<div class="col-md-6">
			                			<div class="impact bottom-10"><xsl:value-of select="eas:i18n('Outbound')"/></div>
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
					<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathSvcs" select="$apiSvcs"></xsl:with-param>  
					
				<!--	<xsl:with-param name="viewerAPIPathScores" select="$apiScores"></xsl:with-param>-->
					
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathCaps"></xsl:param> 
		<xsl:param name="viewerAPIPathSvcs"></xsl:param> 
		
		
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

		var panelLeft=$('#appSidenav').position().left;
		 
		var level=0;
		var rationalisationList=[];
		let levelArr=[];
		let workingCapId=0;
		var partialTemplate, l0capFragment;
		showEditorSpinner('Fetching Data...');
		var dynamicAppFilterDefs=[];	
		var dynamicCapFilterDefs=[];
		$('document').ready(function ()
		{
			l0capFragment = $("#model-l0-template").html();
			l0CapTemplate = Handlebars.compile(l0capFragment);
			
			templateFragment = $("#model-l1cap-template").html();
			l1CapTemplate = Handlebars.compile(templateFragment);
			Handlebars.registerPartial('l1CapTemplate', l1CapTemplate);
			
			templateFragment = $("#model-l2cap-template").html();
			l2CapTemplate = Handlebars.compile(templateFragment);
			Handlebars.registerPartial('l2CapTemplate', l2CapTemplate);
			
			keyListFragment = $("#keyList-template").html();
			keyListTemplate = Handlebars.compile(keyListFragment);
			Handlebars.registerPartial('keyListTemplate', keyListTemplate);

			appMiniFragment = $("#appmini-template").html();
			appMiniTemplate = Handlebars.compile(appMiniFragment);
			Handlebars.registerPartial('appMiniTemplate', appMiniTemplate);

			templateFragment = $("#model-l3cap-template").html();
			l3CapTemplate = Handlebars.compile(templateFragment);
			Handlebars.registerPartial('l3CapTemplate', l3CapTemplate);
			
			templateFragment = $("#model-l4cap-template").html();
			l4CapTemplate = Handlebars.compile(templateFragment);
			Handlebars.registerPartial('l4CapTemplate', l4CapTemplate);

			templateFragment = $("#model-l5cap-template").html();
			l5CapTemplate = Handlebars.compile(templateFragment);
			Handlebars.registerPartial('l5CapTemplate', l5CapTemplate);

			appFragment = $("#app-template").html();
			appTemplate = Handlebars.compile(appFragment);		

			blobsFragment = $("#blob-template").html();
			blobTemplate = Handlebars.compile(blobsFragment);
			
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
			 
				let appHtml='';
				let appArr=[];
/*				thisApps[0].apps.forEach((f)=>{
					let mappedApp=scores.applications.filter((d)=>{
						return d.id==f;
					});

				let thisProcs=[];
				mappedApp[0].processes.forEach((d)=>{
					thisApps[0].physP.forEach((e)=>{
						if(e==d.id){
							thisProcs.push(d);
						}
					})

				})
				let scArr=[]; 
				if(thisProcs[0]){
				thisProcs.forEach((sc)=>{  
					if(sc.scores){ 
					sc.scores.forEach((s)=>{  
						scArr.push(s) 
						 });
						}
					});
				}
				 
				if(mappedApp[0].scores){ 
					mappedApp[0].scores.forEach((s)=>{  
						scArr.push(s) 
						 });
						}
	 
				var totals = d3.nest()
					.key(function(d) { return d.type; })
					.rollup(function(v) { return {
						count: v.length,
						total: d3.sum(v, function(d) { return d.score; }),
						avg: d3.mean(v, function(d) { return d.score; })
					}; })
					.entries(scArr);
				
				let thisQuals=[];
			
				scores.serviceQualities.forEach((sq)=>{
					let appMap=totals.filter((s)=>{
						return s.key==sq.id;
					})
				
					if(appMap.length &gt; 0){
						let thisScore=Math.round(appMap[0].values.avg)

						let qualInfo=sq.sqvs.find((q)=>{
							return q.score==thisScore;
						})
					thisQuals.push({"id":sq.id,"name":sq.shortName,"score":thisScore, "bgColour":qualInfo.elementBackgroundColour, "color":qualInfo.elementColour})
					}else
					{
						thisQuals.push({"id":sq.id,"name":sq.shortName,"score":0})
					}
				});
				appArr.push({"id":f,"name":mappedApp[0].app,"level":instance.level, "scores":thisQuals});

				})
				appHtml= appScoreTemplate(appArr);
				return appHtml;
*/
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
			
			let selectCapStyle=localStorage.getItem("essentialhideCaps");
			if(selectCapStyle){
				document.getElementById("hideCaps").innerHTML = localStorage.getItem("essentialhideCaps");
			}

	$('#hideCaps').on('click',function(){
		let capState=$('#hideCaps').text() 
		if(capState=='Hiding'){
			$('#hideCaps').text('Showing')
			redrawView()
		}
		else
		{
			$('#hideCaps').text('Hiding')
			redrawView()
		}
	});

	$('#retired').on('change',function(){
			
			redrawView()
	})

			$('.appPanel').hide();
			var appArray;
			var workingArrayCaps;
			var workingArrayAppsCaps;
			var appToCap=[];
			var processMap=[]; 
			let svsArray=[];
			var scores=[];
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataCaps), 
	 		promise_loadViewerAPIData(viewAPIDataSvcs)
			]).then(function (responses)
			{
			 //	console.log('viewAPIData',responses[0]);
			//	console.log('viewAPIDataApps',responses[1]);
			 //	console.log('viewAPIDataCaps',responses[2]);
			//	console.log('viewAPIDataSvcs',responses[3]);
				let workingArray = responses[0];
				svsArray = responses[3]
				meta = responses[1].meta; 
				filters=responses[1].filters;
				capfilters=responses[0].filters;

				
				responses[1].filters.sort((a, b) => (a.id > b.id) ? 1 : -1)
				 console.log('capfilters',responses[1].filters)
				dynamicAppFilterDefs=filters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});

				dynamicCapFilterDefs=capfilters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
			 
				
		 
				workingArray.busCapHierarchy.forEach((d)=>{
			 
					let capArr=responses[2].businessCapabilities.find((e)=>{
						return e.id==d.id;
					}); 
					d["order"]=parseInt(capArr.sequenceNumber);
					if(capArr.positioninParent=='Front'){ 
						d["position"]=2;
					}
					else
					if(capArr.positioninParent=='Manage'){ 
						d["position"]=1;
					}
					if(capArr.positioninParent=='Back'){ 
						d["position"]=3;
					}
					
				});

				workingArray.busCapHierarchy.sort(function (a, b) {   
					return a.position - b.position || a.order - b.order;
				});
				
		 
				rationReport=responses[1].reports.filter((d)=>{return d.name=='appRat'});
			//	scores = responses[2];
			//	console.log(scores); 

				 let checkkey= false;
			/*	 scores.applications.some((d)=>{
					if(d.processes.length&gt;0)
					{ 
						d.processes.some((e)=>{
						if(e.scores.length &gt; 0){
							checkkey=true; 
						}	
					 	})
					}else{
					}

				});
			*/
			//	console.log(checkkey);
				if(checkkey){$('#pmKey').show()}
				else{
					$('#pmKey').hide()
				}
			/*	 
				$('#keyHolder').hide();
				scores.serviceQualities.forEach((d)=>{
					d.sqvs.sort((a, b) => (a.score > b.score) ? -1 : 1)
				})

 				$('#keyHolder').html(keyListTemplate(scores.serviceQualities)) 
			*/
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
			 
					$('#blobLevel').html(blobTemplate(levelArr))
	
					$('.blob').on('click',function(){
						let thisLevel=$(this).attr('id')
						let fit=$('#fit').is(":checked");
						level=thisLevel;
						$('.caplevel').show();
						$('.caplevel[level='+thisLevel+']').hide();
						$('.blob').css('background-color','#ffffff')
						for(i=0;i&lt;thisLevel;i++){
							$('.blob[id='+(i+1)+']').css('background-color','#ccc')
						}
					//	setScoreApps()
					}) 
/*
					$('#fit').on('click',function(){ 
						setScoreApps();
					});

					$('.measures').on('click',function(){ 
						let thisId= $(this).attr('id');
						let thisVal=$(this).prop('checked');
					//	console.log(thisId)
						if(thisVal==true){
							$('.'+thisId).show();
						}
						else{
							$('.'+thisId).hide();
						}
					});

					function setScoreApps(){
						let fit=$('#fit').is(":checked");
						if(fit == true){
							$('#keyHolder').show();
							$('.appInDivBoxL0').hide();
							$('.appInDivBox').hide();
							$('.appL'+(level-1)).show();
						}
						else{
							$('#keyHolder').hide();
							$('.appInDivBoxL0').hide();
							$('.appInDivBox').hide();
						}
					}
*/
				$('#rootCap').text(workingArray.rootCap);	
				
				codebase=appArray.codebase;
				delivery=appArray.delivery;
				lifecycles=appArray.lifecycles;
	 			
				 appArray.applications.forEach((d)=>{

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
					
					if(d.lifecycle.length != 0){
						d['lifecycle']=thisLife?.shortname;
						d['lifecycleColor']=thisLife?.colour;
						d['lifecycleText']=thisLife?.colourText;
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
				
				workingArray.busCaptoAppDetails.forEach((bc)=>{
				 
					let capArr=responses[2].businessCapabilities.find((e)=>{
						return e.id==bc.id;
					}); 
					bc["order"]=parseInt(capArr.sequenceNumber);
					bc.processes.forEach((bp)=>{
				 
						bp.physP.forEach((pbp)=>{
					 
							processMap.push({"pbpId":pbp,"pr":bp.name, "prId":bp.id});

						});
						appToCap.push({"procId":bp.id,"bc": bc.name, "bcId":bc.id})
					});

				});
				
				let capMod = new Promise(function(resolve, reject) { 
					resolve($('#capModelHolder').html(l0CapTemplate(workingArray.busCapHierarchy)));
					reject();
			   })
			   
		
			   capMod.then((d)=>{
				workingArray=[];
			essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], responses[1].filters, responses[0].filters);
			   });
			   removeEditorSpinner()
			   $('.appInDivBoxL0').hide();
			   $('.appInDivBox').hide();
			})
				 
		//	$('#scope-panel').append('<div style="position:relative;bottom:0px; right:10px; font-size:8pt; font-weight:bold; text-align:right">Available Filters: Business Unit, Geographic Region, Content Status</div>');
 

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

	if($('#retired').is(":checked")==false){
		apps= apps.filter((d)=>{
			return d.lifecycle != "Retired";
		})
	}

	console.log('dynamicAppFilterDefs',dynamicAppFilterDefs)
 
	scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs));
	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef].concat(dynamicCapFilterDefs));
	let appsToShow=[]; 
 
	inScopeCapsApp=scopedCaps.resources; 
 
	let capSelectStyle= $('#hideCaps').text(); 
	if(capSelectStyle=='Hiding'){
	 	localStorage.setItem("essentialhideCaps", "Hiding");
	$('.buscap').hide();
	inScopeCapsApp.forEach((d)=>{
		$('div[eascapid="'+d.id+'"]').parents().show();
		$('div[eascapid="'+d.id+'"]').show();
	 
		});
	}else
	{	 
		localStorage.setItem("essentialhideCaps", "Showing");
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
					 
							cap.forEach((cp)=>{
								capforApp.push({"id":cp.bcId,"name":cp.bc})
							})
						
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

	$('.app-circle').on("click", function (d)
		{ d.stopImmediatePropagation(); 

				let selected = $(this).attr('easidscore')
 
				if(workingCapId!=selected){ 
			
				getApps(selected);

				$(".appInfoButton").on("click", function ()
				{
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
					let thisAllServs = appToShow[0].allServices.filter((elem, index, self) => self.findIndex(
								(t) => {return (t.id === elem.id)}) === index);		
								 
					thisServs.sort((a, b) => (a.name > b.name) ? 1 : -1)

					appToShow[0]['capList']=thisCaps;
					appToShow[0]['processList']=thisProcesses;
					appToShow[0]['servList']=thisServs;  
					thisAllServs.forEach((e)=>{
						 
						svsArray.application_services.forEach((sv)=>{
							let match = sv.aprs.find((f)=>{
								 
								return f == e.id	
							})
						 if(match){
							e['name']=sv.name	 
							 }
						})
						 
					})
					thisAllServs.sort((a, b) => (a.name > b.name) ? 1 : -1)

					appToShow[0]['allservList']=thisAllServs; 
  		 
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
		})


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
 
	panelData.apps.sort((a, b) => (a.name > b.name) ? 1 : -1)
  
	$('#appsList').html(appListTemplate(panelData))
	openNav(); 
	thisCapAppList[0].apps.forEach((d)=>{ 
		rationalisationList.push(d)
	});
	}
	$('.app-circle').text('0')
		$('.app-circle').each(function() {
			$(this).html() &lt; 2 ? $(this).css({'background-color': '#e8d3f0', 'color': 'black'}) : null;
		  
			($(this).html() >= 2 &amp;&amp; $(this).html() &lt; 6) ? $(this).css({'background-color': '#e0beed', 'color': 'black'}): null;
		  
			$(this).html() >= 6 ? $(this).css({'background-color': '#d59deb', 'color': 'black'}) : null;
		  });
	
		  inScopeCapsApp.forEach(function (d)
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
	})


	
}

function redrawView() {
	essRefreshScopingValues()
}
});

		function getArrayDepth(arr){  
			arr.forEach((d)=>{
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
</xsl:stylesheet>
