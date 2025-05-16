<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>
	<!-- END GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="reportPath" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
	<xsl:variable name="reportPathApps" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
	-->
	<xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Application Reference Model']"></xsl:variable>
	
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
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="appsMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"></xsl:variable>
	<xsl:variable name="appCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities 2 Services']"></xsl:variable>
	
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
		<xsl:variable name="apiAppsMart">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsMartData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiProcess">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$processData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
		<xsl:variable name="apiAppCaps">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$appCapData"></xsl:with-param>
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
				<script src="js/d3/d3.min.js?release=6.19"></script>
				<title>Application Reference Model</title>
				<style>
					.l0-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid #077d32;
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
						background-color: #dbd7d7;
						border-left: 3px solid #40ca72;	
					}
					
					.l2-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid #0cd254;					
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
						border-left: 3px solid rgb(190, 208, 194);					
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
					
					.cap-label,.sub-cap-label{
						margin-right: 20px;
						margin-bottom: 10px;
					}
					
					.sidenav{
						height: calc(100vh - 76px);
						width: 350px;
						position: fixed;
						z-index: 1;
						top: 76px;
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
							padding-top: 43px;
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
					.appsvc-circle{
						display: inline-block;
						min-width: 10px;
						padding: 2px 5px;
						font-size: 8px;
						font-weight: 700;
						line-height: 1;
						text-align: center;
						white-space: nowrap;
						vertical-align: middle;
						background-color: rgb(63, 63, 63);
						color: rgb(255, 255, 255);
						border-radius: 10px;
						border: 1px solid rgb(255, 255, 255);
						
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
					.svcLozenge{
						display:inline-block;
						width:90%;
						height:35px;
						color:#333;
						background-color: #f6f6f6;
						border-radius:4px;
						padding:2px;
						margin:2px;
						font-size:0.8em;
						border:1pt solid rgb(140, 140, 140);
						border-left: 3px solid #f39c1f;
						position:relative;
					}
				// bc style
				
				.bg-dark{
					background:#000;
				}

				
				.helpMe {
					position: absolute;
					right: 35px;
					top: 95px;
					color:red;
				}
				
				#content-panel {
					width: 100%;
					position: relative;
				}
				.modal-backdrop {
					z-index: -1;
				}

				.off-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid rgb(125, 174, 198);					
						background-color: rgb(237, 237, 237);
						color:#d3d3d3;  

					}
				.popover {
					max-width: 400px;
					}

				.platformService{
					background-color: #ddb0e1;	
				}
				</style>
			 
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
                <xsl:call-template name="ViewUserScopingUI"/>
			 	<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Reference Model')"></xsl:value-of>  </span>
									<span class="text-primary">
										<span id="rootCap"></span>
									</span>
								</h1>
							</div>
						</div>
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
							<div class="clearfix"/>
							<div class="pull-right" style="width:350px">
									<xsl:value-of select="eas:i18n('Building Block')"/><sup><i class="fa fa-info-circle platformInfo"></i><xsl:text> </xsl:text>
										<div class="text-default small hiddenDiv">
											<xsl:value-of select="eas:i18n('e.g. An HR System - Modelled as Composite Application Service, i.e. a collection of services')"/>
										</div></sup>
									<select class="select2" name="servicesCompositOnlt" multiple="multiple" id="selCompBox">
									</select>
									<div class="pull-right Key" style="position:absolute;top:-5px;right:20px">
										<b><xsl:value-of select="eas:i18n('Caps Style')"/>:</b><button class="btn btn-xs btn-secondary" id="hideCaps"><xsl:value-of select="eas:i18n('Showing')"/></button><xsl:text> </xsl:text>
										<b><xsl:value-of select="eas:i18n('Application Usage Key')"/></b>:&#160;<i class="fa fa-square shigh"></i>&#160;-&#160;<xsl:value-of select="eas:i18n('High')"/>&#160;&#160;<i class="fa fa-square smed"></i>&#160;-&#160;<xsl:value-of select="eas:i18n('Medium')"/>&#160;&#160;<i class="fa fa-square slow"></i>&#160;-&#160;<xsl:value-of select="eas:i18n('Low')"/>
								</div>
							</div>
						</div>
						<div class="col-xs-12" id="keyHolder" >

						</div>

						<div class="col-xs-12" id="capModelHolder">
						</div>
						<div id="appSidenav" class="sidenav">
							<button class="btn btn-default appRatButton bottom-15 saveApps"><i class="fa fa-external-link right-5 text-primary "/><xsl:value-of select="eas:i18n('View in Rationalisation')"/></button>
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
				<script id="model-l0-template" type="text/x-handlebars-template">
		         	<div class="capModel">
						{{#each this}}
							<div class="l0-cap"><xsl:attribute name="level">{{this.level}}</xsl:attribute>
								<span class="cap-label">{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<br/>	 
									{{> l1CapTemplate}}
									{{#getApps this}}{{/getApps}} 
							</div>
						{{/each}}
					</div>
				</script>

				<!-- SubCaps template called iteratively -->
				<script id="model-l1cap-template" type="text/x-handlebars-template">
					<div class="l1-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l1-cap bg-purple-20 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
						<!--	<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="score">{{this.apps.length}}</xsl:attribute>{{this.apps.length}}</span> -->
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
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
						<!--	<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="score">{{this.apps.length}}</xsl:attribute>{{this.apps.length}}</span> -->
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
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
						<!--	<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="score">{{this.apps.length}}</xsl:attribute>{{this.apps.length}}</span>	 -->	
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
						<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
					<!--	<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="score">{{this.apps.length}}</xsl:attribute>{{this.apps.length}}</span> -->
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
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="score">{{this.apps.length}}</xsl:attribute>{{this.apps.length}}</span>	 
							{{#getApps this}}{{/getApps}} 
							<div class="l5-caps-wrapper caplevel"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
									{{> l5CapTemplate}}
								</div>	
						</div>
						{{/each}}
					</div>	
				</script>
				 
				<script id="svc-template" type="text/x-handlebars-template">
					{{#each this}} 
						<div class="svcLozenge"><xsl:attribute name="eassvcid">{{this.id}}</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}
						<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="svcscore">{{this.APRs.length}}</xsl:attribute>{{this.APRs.length}}</span>	 
						</div>	
					{{/each}}
				</script>	
				<script id="blob-template" type="text/x-handlebars-template">
					<div class="blobBoxTitle right-10"> 
						<strong><xsl:value-of select="eas:i18n('Select Level')"/></strong>
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
						 <span id="capsId"><xsl:attribute name="easid">{{this.svc}}</xsl:attribute><h3>Service: {{this.svcName}} </h3>
							
							<a tabindex="0" class="popover-trigger">
								<i class="fa fa-info-circle helpMe"></i>
							</a>
							<div class="popover">
								<div class="strong"><xsl:value-of select="eas:i18n('Help')"/></div>
								<div class="text-muted"><xsl:value-of select="eas:i18n('The information on the applications that provide this application service')"/>. <br/>
								<xsl:value-of select="eas:i18n('The')"/>&#160;<b><xsl:value-of select="eas:i18n('Application Lifecycle')"/></b>&#160;<xsl:value-of select="eas:i18n('is the lifecycle status of the application')"/><br/>
								<b><xsl:value-of select="eas:i18n('Application Service Lifecycle')"/></b>&#160;<xsl:value-of select="eas:i18n('is the lifecycle of the application use of this service (Application Provider Role)')"/><br/>
								<xsl:value-of select="eas:i18n('This will only appear if you have the data captured')"/><br/>
								<p>
								<xsl:value-of select="eas:i18n('Once an application is expanded - click the arrow by the application name - you can see some basic information and also where')"/> <br/>
								<xsl:value-of select="eas:i18n('any organisation standards exist for this application/service mapping.')"/> 
								</p>
								<p class="small"><xsl:value-of select="eas:i18n('Note: Click this pop-up to close it')"/></p>
								</div>
							</div>
							<span class="appsvc-circle ">S</span>:&#160;<xsl:value-of select="eas:i18n('Application Service Lifecycle')"/><br/>
							<span class="appsvc-circle ">A</span>:&#160;<xsl:value-of select="eas:i18n('Application Lifecycle')"/> 
						</span>
						{{#each this.apps}}
							 
							<div class="appBox">
								<xsl:attribute name="easid">{{this.app.id}}</xsl:attribute>
								<div class="appBoxSummary">
									<div class="appBoxTitle pull-left strong">
										<xsl:attribute name="title">{{this.app.name}}</xsl:attribute>
										<i class="fa fa-caret-right fa-fw right-5 text-white" onclick="toggleMiniPanel(this)"/>{{#essRenderInstanceLinkMenuOnly this.app 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}
									</div>
									<div class="lifecycle pull-right">				
										 {{#getLifecycle this.app.lifecycle 'app'}}{{/getLifecycle}}
										 {{#if this.app.tosvcLifecycle}}
											 {{#getLifecycle this.app.tosvcLifecycle 'svc'}}{{/getLifecycle}} 
										 {{/if}}
									</div>
								</div>
								<div class="clearfix"/>
								<div class="mini-details">
									<div class="small pull-left text-white">
										<div class="left-5 bottom-5"><i class="fa fa-th right-5"></i>{{this.app.allServices.length}} <xsl:value-of select="eas:i18n('Supported Services')"/> </div>
										<div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{this.app.services.length}} <xsl:value-of select="eas:i18n('Services Used')"/> </div>
										<div class="left-5 bottom-5"><i class="fa fa-sign-in right-5"></i>{{this.app.inIList.length}} <xsl:value-of select="eas:i18n('Applications In')"/> </div>
										<div class="left-5 bottom-5"><i class="fa fa-sign-out right-5"></i>{{this.app.outIList.length}} <xsl:value-of select="eas:i18n('Applications Out')"/> </div>
								 
										{{#if this.stds}}
										<table width="100%">
											<tr><th width="150px">Organisation</th><th>Status</th></tr>
											{{#each this.stds}}
												{{#each this.orgs}}
											<tr><td>{{#ifEquals this.org ''}}Global{{else}}{{this.name}}{{/ifEquals}}</td><td> {{#getStdColour ../this.strId ../this.str}}{{/getStdColour}}  </td></tr>
												{{/each}}
											{{/each}}
										</table>	
										{{/if}}
									</div>

									<button class="btn btn-default btn-xs appInfoButton pull-right"><xsl:attribute name="easid">{{this.app.id}}</xsl:attribute><xsl:value-of select="eas:i18n('Show Details')"/></button>
									
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
								<li class="active"><a data-toggle="tab" href="#summary"><xsl:value-of select="eas:i18n('Summary')"/></a></li>
								<li><a data-toggle="tab" href="#capabilities"><xsl:value-of select="eas:i18n('Application Capabilities')"/> <span class="badge dark">{{capsImpacting.length}}</span></a></li>
								<li><a data-toggle="tab" href="#buscapabilities"><xsl:value-of select="eas:i18n('Business Capabilities')"/> <span class="badge dark">{{busCapsImpacting.length}}</span></a></li>
								<li><a data-toggle="tab" href="#processes"><xsl:value-of select="eas:i18n('Processes')"/> <span class="badge dark">{{processList.length}}</span></a></li>
								<li><a data-toggle="tab" href="#integrations"><xsl:value-of select="eas:i18n('Integrations')"/> <span class="badge dark">{{totalIntegrations}}</span></a></li>
			                 	<li><a data-toggle="tab" href="#services"><xsl:value-of select="eas:i18n('Services')"/>  <span class="badge dark">{{allServices.length}}</span></a></li>
								<li></li>
							</ul>

					
							<div class="tab-content">
								<div id="summary" class="tab-pane fade in active">
									<div>
				                    	<strong><xsl:value-of select="eas:i18n('Description')"/> </strong>
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
												<i class="fa fa-users right-5"/>{{processes.length}} <xsl:value-of select="eas:i18n('Processes Supported')"/></div>
		                				<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:#6849D0;color:#ffffff</xsl:attribute>
												<i class="fa fa-exchange right-5"/>{{totalIntegrations}} <xsl:value-of select="eas:i18n('Integrations')"/> ({{inI}} <xsl:value-of select="eas:i18n('in')"/> / {{outI}} <xsl:value-of select="eas:i18n('out')"/>)</div>
		                			</div>
								</div>
								<div id="capabilities" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Application Capabilities:')"/> </p>
									<div>
									{{#if capsImpacting}}
									{{#each capsImpacting}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/> </p>
									{{/if}}
									</div>
								</div>
								<div id="buscapabilities" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Capabilities')"/> :</p>
									<div class='pull-right'><i class="fa fa-random"></i> <xsl:value-of select="eas:i18n('Mapped via Process')"/> </div>
									<div>
									{{#if busCapsImpacting}}
									{{#each busCapsImpacting}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}} {{#ifEquals this.source 'Process'}}<i class="fa fa-random"></i>{{/ifEquals}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/> </p>
									{{/if}}
									</div>
								</div>	
								<div id="processes" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Processes, supporting')"/>  {{processes.length}} <xsl:value-of select="eas:i18n('physical processes')"/> :</p>
									<div>
									{{#if processList}}
									{{#each processList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/> </p>
									{{/if}}
									</div>
								</div>
								<div id="services" class="tab-pane fade">
									<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Services')"/> :</p>
									<div>
									{{#if servList}}
									{{#each servList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#73B9EE;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/> </p>
									{{/if}}
									</div>
								</div>
								<div id="integrations" class="tab-pane fade">
			                    <p class="strong"><xsl:value-of select="eas:i18n('This application has the following integrations')"/> :</p>
			                	<div class="row">
			                		<div class="col-md-6">
			                			<div class="impact bottom-10"><xsl:value-of select="eas:i18n('Inbound')"/> </div>
			                				{{#each inIList}}
			                                <div class="ess-tag bg-lightblue-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                		<div class="col-md-6">
			                			<div class="impact bottom-10"><xsl:value-of select="eas:i18n('Outbound')"/> </div>
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
					<xsl:with-param name="viewerAPIPathAppsMart" select="$apiAppsMart"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathProcess" select="$apiProcess"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathAppCaps" select="$apiAppCaps"></xsl:with-param> 
					
				<!--	<xsl:with-param name="viewerAPIPathScores" select="$apiScores"></xsl:with-param>-->
					
				</xsl:call-template>  
			</script>
<script>

  $(document).ready(function() {

	showInfoTooltips()
    var scrollFunction = function() {
      var scrollPosition = $(this).scrollTop();
      if(scrollPosition == 0) {
        $(this).removeClass('heading-fixed');
      }
      else {
        $(this).addClass('heading-fixed');
      }
    }
        
        $('.bc-business-capability').scroll(scrollFunction);
  });

  $( document ).ready(function() {
    var heights = $(".panel").map(function() {
        return $(this).height();
    }).get(),

    maxHeight = Math.max.apply(null, heights);

    $(".panel").height(maxHeight);
 
  });

 
</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathAppsMart"></xsl:param>
		<xsl:param name="viewerAPIPathProcess"></xsl:param>
		<xsl:param name="viewerAPIPathAppCaps"></xsl:param>
		
		
	<!--	<xsl:param name="viewerAPIPathScores"></xsl:param>-->
		
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataAppsMart = '<xsl:value-of select="$viewerAPIPathAppsMart"/>';
		var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>';
		var viewAPIDataAppCaps = '<xsl:value-of select="$viewerAPIPathAppCaps"/>';
		
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

		let filterExcludes = [<xsl:for-each select="$theReport/own_slot_value[slot_reference='report_filter_excluded_slots']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>];
	 
	 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};

		var panelLeft = $('#appSidenav').position().left;

		var level = 0;
		var rationalisationList = [];
		let levelArr = [];
		let workingArr = [];
		let workingCapId = 0;
		var workingSvcs;
		let appCaps = []; 
		var partialTemplate, l0capFragment;
		showEditorSpinner('Fetching Data...');

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

$('document').ready(function () {
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

		svcFragment = $("#svc-template").html();
		svcTemplate = Handlebars.compile(svcFragment);

		appListFragment = $("#appList-template").html();
		appListTemplate = Handlebars.compile(appListFragment);

		appScoreFragment = $("#appScore-template").html();
		appScoreTemplate = Handlebars.compile(appScoreFragment);

		Handlebars.registerHelper('getLevel', function (arg1) {
			return parseInt(arg1) + 1;
		});

		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('getWidth', function (sclen) {

			return (100 / sclen.length) - 2;
		});

		Handlebars.registerHelper('getApps', function (instance) {

			let appHtml = '';
			let appArr = [];
			
			instance.supportingServices.forEach((d) => {
				let thisSvc = workingArray.application_services.find((e) => {
					return e.id == d;
				})
			 
				appArr.push(thisSvc)
			})
			
			appArr.sort((a, b) => {
				// Convert the string values to numbers using parseInt (or Number)
				const seqA = parseInt(a.sequence_number, 10);
				const seqB = parseInt(b.sequence_number, 10);
				return seqA - seqB;
			});

			appHtml = svcTemplate(appArr);

			return appHtml;
		});

		Handlebars.registerHelper('getColour', function (arg1) {
			let colour = '#fff';

			if (parseInt(arg1) &lt; 2) {
				colour = '#EDBB99'
			} else if (parseInt(arg1) &lt; 6) {
				colour = '#BA4A00'
			} else if (parseInt(arg1) &gt; 5) {
				colour = '#6E2C00'
			}

			return colour;
		});

		Handlebars.registerHelper('getStdColour', function (arg1, arg2) {
 
			let thisCol= stdStyles.find((d)=>{
				return d.id==arg1;
			}); 
			if(thisCol){
				return '<div class="lifecycle pull-right"><xsl:attribute name="style">background-color:'+thisCol.colour+' ;color:'+ thisCol.colourText+'</xsl:attribute>'+arg2+'</div>';
			}
			else
			{
				return '<div class="lifecycle pull-right" style="background-color:#d3d3d3 ;color:#000000">'+arg2+'</div>'
			}
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

		Handlebars.registerHelper('getLifecycle', function (instance, type) {

			let lbgclr = '#ffffff';
			let lclr = '#000000';
			let lname = 'Not Set';

			if (instance) {
				let thisLife = lifes.find((d) => {
					return d.id == instance;
				});

				if (thisLife.colourText) {
					lclr = thisLife.colourText;
				}
				if (thisLife.colourText) {
					lbgclr = thisLife.colour;
				}
				if (thisLife.shortname) {
					lname = thisLife.shortname
				}
			};

			let lifeType = 'A';
			if (type == 'svc') {
				lifeType = 'S';
			}


			let lifeHTML = '<div class="lifecycle pull-right"><xsl:attribute name="style">background-color:' + lbgclr + ';color:' + lclr + ';margin-left:3px</xsl:attribute><span class="appsvc-circle ">' + lifeType + '</span> ' + lname + '</div>'

			return lifeHTML;
		})

		Handlebars.registerHelper('essRenderInstanceLinkMenuOnly', function (instance, type) {
 
if(instance){
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
		$('.app-circle').removeClass("off-cap");
		redrawView()
	}
	else
	{ 
		$('#hideCaps').text('Hiding')
		redrawView()
	}
});

	$('.appPanel').hide();
	var appArray;
	var workingsvcArray;
	var workingArrayCaps = [];
	var workingArrayAppsCaps;
	var workingCaps, compserv;

	var appToCap = [];
	var processMap = [];
	var scores = [];
	var lifes = [];
	var stdStyles = [];
	Promise.all([
		promise_loadViewerAPIData(viewAPIData),
		promise_loadViewerAPIData(viewAPIDataApps),
		promise_loadViewerAPIData(viewAPIDataAppsMart),
		promise_loadViewerAPIData(viewAPIDataProcess),
		promise_loadViewerAPIData(viewAPIDataAppCaps)
		//	promise_loadViewerAPIData(viewAPIScores)
	]).then(function (responses) {

		workingArray = responses[2]; 
		stdStyles = responses[2].stdStyles;
		meta = responses[1].meta;
		appfilters = responses[1].filters

		compserv=responses[1].compositeServices;

		filterExcludes.forEach((e)=>{
			appfilters=appfilters.filter((f)=>{
				return f.slotName !=e;
			})
		 })
 
		appfilters.sort((a, b) => (a.id > b.id) ? 1 : -1)
		dynamicAppFilterDefs=appfilters?.map(function(filterdef){
			return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
		});
 
		let selBoxCompOptionsHtml = compserv?.map(service => ' &lt;option name="' + service.id + '" value="' + service.id + '">' + service.name + '&lt;/option>').join('');
       
		$('#selCompBox').append(selBoxCompOptionsHtml);
		$('#selCompBox').select2({width:'250px'})
		 
		workingArray.capability_hierarchy.forEach((f) => {
			workingArrayCaps.push(f.id)
		});
 
		workingCaps = responses[0];
		workingSvcs = responses[0].application_services;

		appCaps = responses[4].application_capabilities_services;
		processMap = responses[3].businessProcesses;
		lifes = responses[1].lifecycles
		rationReport = responses[1].reports.filter((d) => {
			return d.name == 'appRat'
		});

 
		getArrayDepth(workingArray.capability_hierarchy);

		workingArrayAppsCaps = workingArray.application_capabilities;
		workingsvcArray = workingArray.application_services;
		let appUpdateMod = new Promise(function (resolve, reject) {
			resolve(appArray = responses[1]);
			reject();
		})

		appUpdateMod.then(function () {


			level = Math.max(...levelArr);
			levelArr = [];
			for (i = 0; i  &lt; level+1 ; i++) {
				levelArr.push({
					"level": i + 1
				});
			};

			$('#blobLevel').html(blobTemplate(levelArr))

			$('.blob').on('click', function () {
				let thisLevel = $(this).attr('id')
				let fit = $('#fit').is(":checked");
				level = thisLevel;
				$('.caplevel').show();
				$('.caplevel[level=' + thisLevel + ']').hide();
				$('.blob').css('background-color', '#ffffff')
				for (i = 0; i  &lt; thisLevel; i++) {
					$('.blob[id=' + (i + 1) + ']').css('background-color', '#ccc')
				}
				//setScoreApps()
			})


			let capMod = new Promise(function (resolve, reject) {
				resolve($('#capModelHolder').html(l0CapTemplate(workingArray.capability_hierarchy)));
				reject();
			})
//console.log('appfilters',appfilters)

			capMod.then((d) => {
				workingArray = [];
				// known classes added by EAS, slot allows exclusion in the report instance
				hardClasses=[{"class":"Group_Actor", "slot":"stakeholders"},
						{"class":"Geographic_Region", "slot":"ap_site_access"},
						{"class":"SYS_CONTENT_APPROVAL_STATUS", "slot":"system_content_quality_status"},
						{"class":"Product_Concept", "slot":"product_concept_supported_by_capability"},
						{"class":"Business_Domain", "slot":"belongs_to_business_domain"},
						{"class":"ACTOR_TO_ROLE_RELATION", "slot":"act_to_role_to_role"},
						{"class":"Managed_Service", "slot":"ms_managed_app_elements'"},
						{"class":"Application_Capability", "slot":"realises_application_capabilities"}]

						hardClasses = hardClasses.filter(item => 
							!filterExcludes.some(exclude => item.slot.includes(exclude))
						);

					let classesToShow = hardClasses.map(item => item.class);
					 
					essInitViewScoping	(redrawView, classesToShow, appfilters, true);
				
			});
			removeEditorSpinner()
			$('.appInDivBoxL0').hide();
			$('.appInDivBox').hide();


			codebase = appArray.codebase;
			delivery = appArray.delivery;
			appArray.applications.forEach((d) => {

				let thisCode = codebase.find((e) => {
					return e.id == d.codebaseID
				});

				if (d.codebaseID.length  &gt; 0) {
					d['codebase'] = thisCode.shortname;
				} else {
					d['codebase'] = "Not Set";
				}

				let thisDelivery = delivery.find((e) => {
					return e.id == d.deliveryID;
				});
				if (d.deliveryID.length  &gt; 0) {
					d['delivery'] = thisDelivery.shortname;
				} else {
					d['delivery'] = "Not Set";
				}
				d.realises_application_capabilities = d.allServices.flatMap(s => s.capabilities);
			});
		})

	}).catch(function (error) {
		//display an error somewhere on the page
	});

	let scopedApps = [];
	let inScopeCapsApp = [];
	let scopedCaps = [];
	let scopedSvcs = [];

	var appTypeInfo = {
		"className": "Application_Provider",
		"label": 'Application',
		"icon": 'fa-desktop'
	}
	var appSvcTypeInfo = {
		"className": "Application_Service",
		"label": 'Application Service',
		"icon": 'fa-tv'
	}
	var busCapTypeInfo = {
		"className": "Business_Capability",
		"label": 'Business Capability',
		"icon": 'fa-landmark'
	}
var scopedService;
	var redrawView = function () { 
			essResetRMChanges();

			workingCapId = 0;
			let workingAppsList = [];
			let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
			let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
			let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
			let a2rScopingDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION'); 
			let msDef = new ScopingProperty('ms_managed_app_elements', 'Managed_Service');
			let acDef = new ScopingProperty('realises_application_capabilities', 'Application_Capability');
			
		//	let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
	 

			let apps = appArray.applications;

			scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef, a2rScopingDef, msDef, acDef].concat(dynamicAppFilterDefs), appTypeInfo);
			scopedCaps = essScopeResources(workingArrayAppsCaps, [visibilityDef], busCapTypeInfo);

			workingsvcArray.forEach(obj => {
				delete obj.filteredAPRs;
			});

			scopedService = essScopeResources(workingsvcArray, [visibilityDef], appSvcTypeInfo);

			let appsToShow = [];
			inScopeCapsApp = scopedCaps.resources;
			$('.svcLozenge').removeClass("off-cap")
			$('.svcLozenge').show();
			workingArrayCaps.forEach((f) => {
				$('div[eascapid="' + f + '"]').show();
			});

			scopedService.resources.forEach((e) => { 
				$('div[eassvcid="' + e + '"]').show();
			});
 
			inScopeCapsApp.forEach((d) => {

				$('div[eascapid="' + d.id + '"]').parents().show();
				$('div[eascapid="' + d.id + '"]').show();

			});

			let appMod = new Promise(function (resolve, reject) {
				resolve(appsToShow['applications'] = scopedApps.resources);
				reject();
			});

			appMod.then((d) => {
		
					inScopeCapsApp.forEach((c) => {
						// reduce services to reflect filter
						let filteredAppSvcsforCap = c.supportingServices.filter((id) => scopedService.resourceIds.includes(id));

						let filteredAPRs = [];
						filteredAppSvcsforCap.forEach((d) => {
							let thisAPR = scopedService.resources.find((e) => {
								return e.id == d;
							});
							filteredAPRs.push(thisAPR)
						});
 
						// reduce apps to reflect filter
						
						filteredAPRs.forEach((d) => {
							let filteredApps = [];
							d.APRs.forEach((f) => {
								let thisApp = scopedApps.resources.find((e) => {
									return e.id == f.appId;
								})
								if (thisApp) {
									filteredApps.push(d)
								}
							})
							d['filteredAPRs'] = filteredApps

						})

						c['filteredSvcs'] = filteredAppSvcsforCap;
						c['filteredSvcsList'] = filteredAPRs;

					})

				}).then((e) => {
						let panelPos = $('#appSidenav').position().left

						if (parseInt(panelPos) + 50  &lt; panelLeft) {

							let openCap = $('#capsId').attr('easid');
							getApps(openCap)
						}

						$('.app-circle').on("click", function (d) {
							d.stopImmediatePropagation();

							let selected = $(this).attr('easidscore')

							if (workingCapId != selected) {

								getApps(selected);

								$(".appInfoButton").on("click", function () {
									let selected = $(this).attr('easid')


									let appToShow = appArray.applications.filter((d) => {
										return d.id == selected;
									});

								let appBusCaps=[]
									workingCaps.busCaptoAppDetails.forEach((e)=>{
										let appmatch=e.apps.find((f)=>{
											return f==appToShow[0].id

										})
										if(appmatch){
											appBusCaps.push(e)
										}
									})

									let thisProcesses = appToShow[0].physP.filter((elem, index, self) => self.findIndex(
										(t) => {
											return (t === elem)
										}) === index);
									let thisServs = appToShow[0].allServices.filter((elem, index, self) => self.findIndex(
										(t) => {
											return (t.id === elem.id)
										}) === index);
									let thisUsedServs = appToShow[0].services.filter((elem, index, self) => self.findIndex(
										(t) => {
											return (t.id === elem.id)
										}) === index);


									procListTosShow = [];

									thisProcesses.forEach((d) => {
										let thisProcMap = workingCaps.physicalProcessToProcess.find((e) => {
											return e.pPID == d;
										})
										if (thisProcMap) {
											let thisProc = processMap.find((e) => {
												return e.id == thisProcMap.procID;
											});
											procListTosShow.push(thisProc);
										}

									});
									procListTosShow = procListTosShow.filter((elem, index, self) => self.findIndex((t) => {
										return (t.id === elem.id)
									}) === index)
									let servsArr = [];

									thisServs.forEach((d) => {

										workingsvcArray.forEach((sv) => {
											sv.APRs.forEach((ap) => {

												if (ap.id == d.id) {
													servsArr.push(sv)
												};
											});
										});
									});
									let thisAppCapArray = [];
									appCaps.forEach((d) => {
										d.services.forEach((e) => {
											let svMatch = servsArr.find((f) => {
												return f.id == e.id
											});
											if (svMatch) {
												thisAppCapArray.push(d)
											}
										})
									})

									thisAppCapArray = thisAppCapArray.filter((elem, index, self) => self.findIndex((t) => {
										return (t.id === elem.id)
									}) === index)
								
									let busCapImpact=[];
									thisAppCapArray.forEach((c)=>{
										let thisAC=workingArrayAppsCaps.find((ac)=>{
											return ac.id==c.id
										}); 

										if(thisAC){
											thisAC.SupportedBusCapability.forEach((f)=>{
												busCapImpact.push(f)
											});
										}
									});

									busCapImpact = busCapImpact.filter((elem, index, self) => self.findIndex((t) => {
										return (t.id === elem.id)
									}) === index)
										
									let acMeta=busCapImpact[0]?.meta;
							 console.log('busCapImpact',busCapImpact)
									 appBusCaps.map(obj => ({ ...obj, type:'Business_Capability', source:'Process' }));	
									let allCaps=[...appBusCaps, ...busCapImpact]

									appToShow[0]['processList'] = procListTosShow;
									appToShow[0]['servList'] = servsArr;
									appToShow[0]['servUsedList'] = thisUsedServs;
									appToShow[0]['capsImpacting'] = thisAppCapArray;
									appToShow[0]['busCapsImpacting'] = allCaps;
									$('#appData').html(appTemplate(appToShow[0]));
									$('.appPanel').show("blind", {
										direction: 'down',
										mode: 'show'
									}, 500);

									//$('#appModal').modal('show');
									$('.closePanelButton').on('click', function () {
										$('.appPanel').hide();
									})
								});

								var thisf = $('*').filter(function () {
									return $(this).data('level') !== undefined;
								});

								$(".saveApps").on('click', function () {
									var apps = {};

									apps['Composite_Application_Provider'] = rationalisationList;
									sessionStorage.setItem("context", JSON.stringify(apps));
									location.href = 'report?XML=reportXML.xml&amp;XSL=' + rationReport[0].link + '&amp;PMA=bcm'
								});
								workingCapId = selected;
							} else {
								closeNav();

							}
						})


function getApps(svcid) {

	let panelData = [];
	let svcName = scopedService.resources.filter((d) => {
		return d.id == svcid
	})
	//get Apps
	let thisAppsList = [];
	svcName[0].APRs.forEach((d) => {

		let appIn = scopedApps.resources.find((app) => {
			return app.id == d.appId;
		});

		if(appIn){
			if(d.lifecycle){
					appIn['tosvcLifecycle'] = d.lifecycle;
			}
				d['app'] = appIn;
				thisAppsList.push(appIn)
			}
	});


	panelData['svc'] = svcid;
	panelData['svcName'] = svcName[0].name;
 
	let scopedAPRs=[];

	svcName[0].APRs.forEach((sv)=>{
		let inSvc = scopedApps.resourceIds.find((a)=>{
			return sv.appId == a;
		})
		if(inSvc){
			scopedAPRs.push(sv)
		}
	});

	panelData['apps'] = scopedAPRs
 
	$('#appData').html(appTemplate(panelData));

	$('#appsList').empty();
	$('#appsList').html(appListTemplate(panelData))

	initPopoverTrigger();
 
	openNav();
	thisAppsList.forEach((d) => {
		rationalisationList.push(d.id)
	});
}
 
$('.app-circle').text('0')
$('.app-circle').each(function () {
 
	$(this).html() &lt;
	2 ? $(this).css({
		'background-color': '#EDBB99',
		'color': 'black'
	}) : null;  

	($(this).html() >= 2 &amp;&amp; $(this).html() &lt; 6) ? $(this).css({
		'background-color': '#BA4A00',
		'color': 'black'
	}): null; 

	$(this).html() >= 6 ? $(this).css({
		'background-color': '#6E2C00',
		'color': 'black'
	}) : null;  
 
 
	
});

$('.app-circle').each(function () {
	if($(this).attr('svcscore')){ 
		$(this).attr('svcscore',0);
	}
});

scopedService.resources.forEach(function (d) {

let appCount = 0
if (d.filteredAPRs) {
	appCount = d.filteredAPRs.length;
}

 
d['svcscore']=appCount;
$('*[easidscore="' + d.id + '"]').html(appCount);

$('*[easidscore="' + d.id + '"]' ).attr( "svcscore",appCount );
let colour = '#fff';
let textColour = '#fff';
if (appCount &lt; 2) {
colour = '#EDBB99'
} else if (appCount &lt; 6) {
colour = '#BA4A00'
} else {
colour = '#6E2C00'
}
$('*[easidscore="' + d.id + '"]').css({
'background-color': colour,
'color': textColour
})

});

$('.app-circle').each(function () {
					
	if($(this).attr('svcscore')){ 
		if($(this).attr('svcscore')==0){
								 
			let capSelectStyle= $('#hideCaps').text(); 
 							
			if(capSelectStyle=='Hiding'){
				localStorage.setItem("essentialhideCaps", "Hiding");
				$(this).parent().hide();	 
			}else
			{	 
				localStorage.setItem("essentialhideCaps", "Showing");
				$(this).parent().show();

			if(scopedApps.resourceIds.length &lt; appArray.applications.length){
					$(this).parent().addClass("off-cap")
			}
			
			}
		}
	}
})
})

}

	$('#selCompBox').on('change', function() {
		// Get the selected value
		var selectedValue = $(this).val(); 
		// Find the corresponding object in compServ
		$('.svcLozenge').removeClass('platformService');
		$('#selBox option').prop('selected', false); 
		
		selectedValue.forEach((sel)=>{
			var selectedObj = compserv.find(obj => obj.id === sel);
			selectedObj.containedService.forEach(function(s) {
				$('[eassvcid="'+s+'"]').addClass('platformService');
			})
		})
	})

});

function getArrayDepth(arr) {

	arr.sort((a, b) => {
		const numA = a.sequence_number === "" ? Infinity : parseInt(a.sequence_number, 10);
		const numB = b.sequence_number === "" ? Infinity : parseInt(b.sequence_number, 10);
		return numA - numB;
	});

	arr.forEach((d) => {
		levelArr.push(parseInt(d.level))
		getArrayDepth(d.childrenCaps);
	})
}

function openNav() {
	document.getElementById("appSidenav").style.marginRight = "0px";
}

function closeNav() {
	workingCapId = 0;
	document.getElementById("appSidenav").style.marginRight = "-352px";
}

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

$('.closePanel').slideDown();

function toggleMiniPanel(element) {
	$(element).parent().parent().nextAll('.mini-details').slideToggle();
	$(element).toggleClass('fa-caret-right');
	$(element).toggleClass('fa-caret-down');
};

function showInfoTooltips(){
	$('[role="tooltip"]').remove();
	$('.fa-info-circle').popover({
		container: 'body',
		html: true,
		trigger: 'click',
		content: function(){
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
</xsl:stylesheet>
