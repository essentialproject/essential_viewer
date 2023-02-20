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
	<xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Business Capability Dashboard']"></xsl:variable>

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Project','Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>
	<xsl:variable name="apps" select="/node()/simple_instance[type=('Composite_Application_Provider','Application_Provider')]"></xsl:variable>
	
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
		-->
	<xsl:variable name="allRoadmapInstances" select="$apps"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>	
	 
	
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="capsListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
	<xsl:variable name="servicesListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Services']"></xsl:variable>
	<xsl:variable name="actorData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"/>

	<xsl:variable name="goalTaxonomy" select="/node()/simple_instance[type='Taxonomy_Term'][own_slot_value[slot_reference='name']/value='Strategic Goal']"/> 
	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[(type = 'Business_Objective') and not(own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name)]"/>
	<xsl:variable name="allStrategicGoals" select="/node()/simple_instance[(type = 'Business_Goal') or ((type = 'Business_Objective') and (own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name))]"/>
	<xsl:variable name="busGoals" select="$allStrategicGoals"/>
	<xsl:variable name="busCaps" select="/node()/simple_instance[type='Business_Capability']"/>
	<xsl:key name="busCapImpact" match="$busCaps" use="own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value"/>

	<xsl:key name="plantolement_key" match="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_ea_element']/value"/>
	<xsl:key name="projecttoplantolement_key" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference = 'ca_planned_changes']/value"/>

<!--	<xsl:variable name="scoreData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: App KPIs']"></xsl:variable>
-->
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiActor">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$actorData"/>
				</xsl:call-template>
		</xsl:variable>
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
					.goalbox{
						font-weight: 400;
						position: absolute;
						bottom:0px;
						min-height: 10px;
						width:95%;
						text-align: center;
						display:none;
					}
					.goalpill{
						border-radius:5px;
						margin-left:2px;
						border:1pt solid #d3d3d3;
						position: relative;
						display:inline-block;
						width:15px;
						height: 8px; 
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

					.projectBoxTitle {
						width: 300px;
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
						display: block;
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
					.proj-circle{
						display: none;
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
					.proj-circle:hover {
						background-color: #333;
						color: #fff;
						cursor: pointer;
					}

					.compare-circle{
						display: none;
						min-width: 10px;
						padding: 2px 5px;
						font-size: 10px;
						font-weight: 700;
						line-height: 1;
						text-align: center;
						white-space: nowrap;
						vertical-align: middle;
						background-color: rgb(247, 247, 247);
						color: #fff;
						border-radius: 10px;
						border: 1px solid #ccc;
						position: absolute;
						right: 5px;
						top: 5px;
					}
					.compare-circle:hover {
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
					.goalInfo{
						position:absolute;
						right:2px;
						bottom:2px;
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
					.goalCard{
						height:70px;
						display: inline-block;
						border-radius: 4px;
						font-size:0.8em;
						width:100px;
						border:1pt solid #d3d3d3;
						vertical-align: top;
						margin-bottom: 5px;
						padding:2px;

					}
					.popOpenGoals{
						padding:2px;
						margin-left:15px;
						border:1pt solid #d3d3d3;
						border-radius:5px;
						font-size:0.8em;
						text-align: center;
						}
						.goalCard2{
							height:90px;
							display: inline-block;
							border-radius: 4px;
							font-size:0.8em;
							width:100px;
							border:1pt solid #d3d3d3;
							color:#fff;
							vertical-align: top;
							margin-bottom: 5px;
							padding:2px;
							position:relative;
	
						}	
						.goalHead{
						 position:relative;
						 top:-2px;
						 left:-2px;
						 width:98px;
						 border-radius: 4px 4px 0px 0px;
						 height:15px;
						 font-size:0.9em;
						 background-color: #636363;
						 color:#fff;
						 padding-left:2px;
						}
						.goalMain{
						 position:relative;
						 font-size:0.93em;
						 top:2px;
						 padding-right:3px;
						 border-radius: 4px;
						 width:100px;
						}
					.leftAppColourBlob{
						background-color: #24A5F4;
						color: #24A5F4;
						border-radius:4px;
						border:1pt solid #fff;
						width:50px;
						margin:2px;
						height:10px;
						font-size: 5pt;
					}
					.leftAppColour{
						background-color: #24A5F4;
						color: #fff;
						border:1pt solid #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
						}
					
					.rightAppColourBlob{
						background-color: #1FC1B4;
						color: #1FC1B4;
						border-radius:4px;
						border:1pt solid #fff;
						width:50px;
						margin:2px;
						height:10px;
						font-size: 5pt;
					}	
					.rightAppColour{
						background-color: #1FC1B4;
						color: #fff;
						border:1pt solid #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.bothAppColour{
						background-color: #7438A4;
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.noAppColour{
						background-color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					.infoConceptBox{
						border:1pt solid #d3d3d3;
						border-radius: 5px;
						font-size:9pt;
						display:inline-block;
						background-color: #fff;
						color:#000;
						padding:2px;
						margin:2px; 
						min-width:48px;
						text-align: center;
					}
					.infoConceptBoxHide{
						border:0pt solid #d3d3d3;
						border-radius: 5px;
						font-size:0pt;
						display:inline-block;
						background-color: #fff;
						padding:0px;
						margin:0px; 	
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
									<span class="text-darkgrey"><span id="reportTitle"><xsl:value-of select="eas:i18n('Business Capability Dashboard')"></xsl:value-of></span> - </span>
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
						</div>
						<div class="col-xs-12 col-md-8">
								<div class="legend">
									<div class="inline-block right-30">
										<strong class="right-10"><xsl:value-of select="eas:i18n('Application Usage Key')"></xsl:value-of>:</strong>
										<i class="fa fa-square shigh right-5"></i><xsl:value-of select="eas:i18n('High')"/>
										<i class="fa fa-square smed left-10 right-5"></i><xsl:value-of select="eas:i18n('Medium')"/>
										<i class="fa fa-square slow left-10 right-5"></i><xsl:value-of select="eas:i18n('Low')"/>
									</div>
								</div>
								<div class=" top-10">
									<strong class="right-5"><xsl:value-of select="eas:i18n('Caps Style')"/>:</strong>
									<button class="btn btn-xs btn-success" id="hideCaps">Show</button>
									<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Show Retired')"/>:</strong>
									<input type="checkbox" id="retired" name="retired"/>
									<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Perspectives')"/>:</strong>
									<select name="viewOption" id="viewOption"/>
									<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Jump To')"/>:</strong>
									<select name="capjump" id="capjump"/>
									
								</div>
								<div class="showApps right-30" id="pmKey">
									<xsl:value-of select="eas:i18n('Ratings')"></xsl:value-of>:<input type="checkbox" id="fit" name="fit"></input>
								</div>
								<div class="top-10 bottom-10">
									<div class="" id="keyHolder" style="display:none"/>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="pull-right" id="blobLevel"/>
							</div>
						<div id="comparePanel" style="display:none">
							<div class="col-xs-6 col-lg-6">
								<label>
									<span><xsl:value-of select="eas:i18n('Organisation')"/> 1</span>
								</label>
								<select id="leftOrgList" class="form-control orgCompare" style="width:100%"><option value="all">All</option></select>	
								<div class="leftAppColour" style="width:100%">&#160;</div>
							</div>
							<div class="col-xs-6 col-lg-6">
								<label>
									<span><xsl:value-of select="eas:i18n('Organisation')"/> 2</span>
								</label>
								<select id="rightOrgList" class="form-control orgCompare" style="width:100%"><option value="all">All</option></select>		
								<div class="rightAppColour" style="width:100%">&#160;</div>
							</div>
							<div class="col-xs-12">
								<div class="bothAppColour top-10" style="width:100%; text-align:center;"><strong><xsl:value-of select="eas:i18n('Both')"/></strong></div>
								<hr/>
							</div>
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
							<div class="l0-cap"><xsl:attribute name="level">{{this.level}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
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
						<div class="l1-cap bg-darkblue-40 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
							{{#getApps this}}{{/getApps}} 
								{{> l2CapTemplate}} 	
								<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>		 
						</div> 
						
						{{/each}}
					</div>
				</script>
				
				<!-- SubCaps template called iteratively -->
				<script id="model-l2cap-template" type="text/x-handlebars-template">
					<div class="l2-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l2-cap buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
							{{#getApps this}}{{/getApps}} 
								{{> l3CapTemplate}}
							<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	 	 
						</div>
						{{/each}}
					</div>
				</script>
				
				<!-- SubCaps template called iteratively -->
				<script id="model-l3cap-template" type="text/x-handlebars-template">
					<div class="l3-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l3-cap bg-lightblue-80 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>	
							{{#getApps this}}{{/getApps}} 				 
								{{> l4CapTemplate}} 	
							<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>		 
						</div>
						{{/each}}
					</div>	
				</script>

				<script id="model-l4cap-template" type="text/x-handlebars-template">
					<div class="l4-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
					{{#each this.childrenCaps}}
					<div class="l4-cap bg-lightblue-80 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
						<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
						<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>
						<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
						<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
						{{#getApps this}}{{/getApps}} 		
							{{> l5CapTemplate}}
							<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>			 
					</div>
					{{/each}}
					</div>
			</script>
				
				<!-- SubCaps template called iteratively -->
				<script id="model-l5cap-template" type="text/x-handlebars-template">
					<div class="l4-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
						{{#each this.childrenCaps}}
						<div class="l5on-cap bg-lightblue-20 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
							<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute>{{this.apps.length}}</span>	
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
							{{#getApps this}}{{/getApps}} 
							<div class="l5-caps-wrapper caplevel"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
									{{> l5CapTemplate}}
								<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
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
				<script id="compare-template" type="text/x-handlebars-template">
					<div class="row">
							<div class="col-sm-8">
								<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>
								<!--<div class="ess-tag ess-tag-default"><i class="fa fa-money right-5"/>Cost: {{costValue}}</div>
								<div class="inline-block">{{#calcComplexity totalIntegrations capsCount processesSupporting servicesUsed.length}}{{/calcComplexity}}</div>-->
							</div>
							<div class="col-sm-4">
								<div class="text-right">
									<i class="fa fa-times closePanelButton left-30"></i>
								</div>
								<div class="clearfix"/>
							</div>
					</div>
					<div class="row">
							<div class="col-sm-8">
								<table>
									<thead><tr><th width="33%">Application</th><th width="33%">	{{this.left}}</th><th width="33%">{{this.right}}</th></tr></thead>
									<tbody>
										{{#each this.rows}}
											<tr><td>{{this.name}}</td><td>{{#getBlob this.left 'left'}}{{/getBlob}}</td><td>{{#getBlob this.right 'right'}}{{/getBlob}}</td></tr>
										{{/each}}
									</tbody>
								</table>
							
							</div>
					</div>

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
				<script id="project-template" type="text/x-handlebars-template">
					<h3>Projects</h3>
					<ul>
					{{#each this.projects}}
					<div class="appBox"> 
							<xsl:attribute name="easid">{{id}}-{{this.name}}</xsl:attribute>
							<div class="appBoxSummary">
								<div class="projectBoxTitle pull-left strong">
									<xsl:attribute name="title">{{this.name}}</xsl:attribute>
									<i class="fa fa-caret-right fa-fw right-5 text-white" onclick="toggleMiniPanel(this)"/>{{#essRenderInstanceLinkMenuOnly this 'Project'}}{{/essRenderInstanceLinkMenuOnly}}
								</div>
							</div>
							<div class="clearfix"/>
							<div class="mini-details">
								<div class="small pull-left text-white">
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Proposed Start Date: {{proposedstartDate}}</div>
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Actual Start Date: {{actualstartDate}}</div>
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Target End Date: {{targetEndDate}}</div>
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Forecast End Date: {{forecastendDate}}</div>
									 
								</div>
<!--
									<button class="btn btn-default btn-xs appInfoButton pull-right"><xsl:attribute name="easid">{{id}}</xsl:attribute>Show Details</button>
-->
								
							</div>
							<div class="clearfix"/>
						</div>
					{{/each}}
					</ul>
				</script>

				<script id="goal-template" type="text/x-handlebars-template">
					<div class="col-xs-11">
					<h3>{{this.name}}</h3>
					<p>Objectives supporting this goal:</p>
					{{#each this.objectives}}
					<i class="fa fa-circle"></i> {{this.name}}<br/>
					{{/each}}
					</div>
					<div class="col-xs-1">
						<div class="text-right">
							<i class="fa fa-times closePanelButton left-30"></i>
						</div>
					</div>
					
				</script>
				
				<script id="goalKey-template" type="text/x-handlebars-template">
					{{#each this}}
					<!--	<div class="goalCard"><xsl:attribute name="style">color:{{goaltxtColour}};background-color:{{goalColour}}</xsl:attribute>{{this.name}} 
						</div>	
					-->
						<div class="goalCard2"><xsl:attribute name="style">color:#000;border-bottom:7px solid {{goalColour}}</xsl:attribute>
							<div class="goalHead"><xsl:attribute name="style">border-bottom:2px solid {{goalColour}}</xsl:attribute>Goal</div>
							<div class="goalMain">{{this.name}}
							</div> 
							<i class="fa fa-info-circle goalInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
						</div>	
					{{/each}}
				</script>
				<script id="infoConcept-template" type="text/x-handlebars-template">
					<div class="infoConceptBoxHide dataBox"><xsl:attribute name="easid">{{id}}</xsl:attribute>{{this.name}} <xsl:text> </xsl:text>
						<!-- 
							link to info views <span class="info-circle "><xsl:attribute name="easidinfo">{{id}}</xsl:attribute>{{this.infoViews.length}}</span>
						-->
					</div> 
				</script>
			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathSvcs" select="$apiSvcs"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathActor" select="$apiActor"></xsl:with-param>   
					
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
		<xsl:param name="viewerAPIPathActor"></xsl:param> 
		
	<!--	<xsl:param name="viewerAPIPathScores"></xsl:param>-->
		
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
		var viewAPIDataSvcs = '<xsl:value-of select="$viewerAPIPathSvcs"/>'; 
		var viewAPIDataActor = '<xsl:value-of select="$viewerAPIPathActor"/>'; 
		
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


		//set report title, this is based on the report label, IMPORTANT: do not chnage the report name, only the label
		const queryString = window.location.search;
		const urlParams = new URLSearchParams(queryString);
		const repTitle = urlParams.get('LABEL')
 
		if(repTitle){
			$('#reportTitle').text(repTitle)
		}

	 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};

		let filtersNo=[<xsl:call-template name="GetReportFilterExcludedSlots"><xsl:with-param name="theReport" select="$theReport"></xsl:with-param></xsl:call-template>];
		var busGoals=[<xsl:apply-templates select="$busGoals" mode="busGoals"/> ];
		var capProjects=[<xsl:apply-templates select="$busCaps" mode="capChanges"/>]
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

			compareFragment = $("#compare-template").html();
			compareTemplate = Handlebars.compile(compareFragment);		

			blobsFragment = $("#blob-template").html();
			blobTemplate = Handlebars.compile(blobsFragment);
			
			appListFragment = $("#appList-template").html();
			appListTemplate = Handlebars.compile(appListFragment);

			goalKeyFragment = $("#goalKey-template").html();
			goalKeyTemplate = Handlebars.compile(goalKeyFragment);

			goalFragment = $("#goal-template").html();
			goalTemplate = Handlebars.compile(goalFragment);
			 
			projectFragment = $("#project-template").html();
			projectTemplate = Handlebars.compile(projectFragment);

			appScoreFragment = $("#appScore-template").html();
			appScoreTemplate = Handlebars.compile(appScoreFragment);

			infoConceptFragment = $("#infoConcept-template").html();
			infoConceptTemplate = Handlebars.compile(infoConceptFragment);

			Handlebars.registerHelper('getLevel', function(arg1) {
				return parseInt(arg1) + 1; 
			});

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
			
			Handlebars.registerHelper('getWidth', function(sclen) {
				 
				return (100/sclen.length)-2;
			});

			Handlebars.registerHelper('getProjects', function(bc) {
			 
				 let thisProj=capProjects.find((e)=>{
					 return e.id==bc.id
				 });
				
				 if(thisProj){
					return thisProj.projects.length;
				 }else{
					 return 0;
				 }
			});

			Handlebars.registerHelper('setGoals', function(gls) {
				divData='';
				busGoals.forEach((bg)=>{
					if(bg.capsList.includes(gls.id)){
						divData=divData+'<div class="goalpill" data-toggle="tooltip" title="'+bg.name+'"  style="background-color:'+bg.goalColour+'"/>'
					}else{
						divData=divData+'<div class="goalpill" style="background-color:#fff"/>'
					}
				})
			 
				return divData
			});

			Handlebars.registerHelper('getApps', function(instance) {
			 
				let thisApps=workingArrayAppsCaps.filter((d)=>{
					return d.id ==instance.id
				});
			 
				let appHtml='<br/>';
				let appArr=[];
				thisApps[0].infoConcepts?.forEach((inf)=>{ 
					 
					appHtml=appHtml+infoConceptTemplate(inf);
				}) 
				return appHtml;
			});

			Handlebars.registerHelper('getCompareApps', function(alist) {
 
			});
			



			Handlebars.registerHelper('getColour', function(arg1) {
				let colour='#fff';
				if(parseInt(arg1) ==0 ){colour='#d3d3d3'}
				else if(parseInt(arg1) &lt;2){colour='#EDBB99'}
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
			 
			Handlebars.registerHelper('getBlob', function (instance, type) {
					
					if(instance=='true'){	
						if(type=='left'){
							return 	'<div class="leftAppColourBlob">T</div>'
						}	
						else{
							return 	'<div class="rightAppColourBlob">T</div>'
						}
					}
			})
			
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

	$('#viewOption').append($('&lt;option>', {
			value: 'apps',
			text: 'Application Overlay'
		}));	

	//$('#viewOption').hide()	
	if(busGoals.length&gt;0){  
		$('#viewOption').append($('&lt;option>', {
				value: 'goals',
				text: 'Goals and Projects'
			}));	
	}
	$('#viewOption').select2({width:'200px'});

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

	$('.orgCompare').on('change',function(){
		redrawView()
})

	$('.popOpenGoals2').on('click', function(){
		$('.app-circle').toggle();
		$('.keyToggle').toggleClass('fa-caret-up fa-caret-down')
		$('#keyHolder').toggle()
		$('.proj-circle').toggle()
		$('.goalbox').slideToggle();
	});

	$('#viewOption').on('change', function(){
		let thisId=$(this).val();
		if(thisId=='apps'){
			$('.app-circle').show();  
			$('.proj-circle').hide();
			$('.compare-circle').hide(); 
			$('#keyHolder').slideUp();
			$('#comparePanel').slideUp() 
			$('.goalbox').hide();
			$('.dataBox').removeClass('infoConceptBox').addClass('infoConceptBoxHide');
		}else if(thisId=='goals'){
			$('.app-circle').hide();  
			$('.proj-circle').show();
			$('.compare-circle').hide();
			$('#comparePanel').slideUp()
			$('#keyHolder').slideDown()  
			$('.goalbox').show();
			$('.dataBox').removeClass('infoConceptBox').addClass('infoConceptBoxHide');
		}else if(thisId=='compare'){
			$('.app-circle').hide();  
			$('.compare-circle').show();  
			$('.proj-circle').hide()
			$('#keyHolder').slideUp() 
			$('#comparePanel').slideDown() 
			$('.goalbox').hide();
			$('.dataBox').removeClass('infoConceptBox').addClass('infoConceptBoxHide');
		}else if(thisId=='data'){
			$('.dataBox').addClass('infoConceptBox').removeClass('infoConceptBoxHide');
			$('.info-circle').css('display','block')
		}
	})
<!--
	$('.popOpenGoals').on('click', function(){
		toggle_visibility('app-circle') 
		$('.keyToggle').toggleClass('fa-caret-up fa-caret-down')
		toggle_visibility('proj-circle') 
		$('#keyHolder').slideToggle() 
		toggle_visibility('goalbox');
	});


	function toggle_visibility(className) {
		
		var elements = document.getElementsByClassName(className),
			n = elements.length;
		for (var i = 0; i &lt; n; i++) {
		  var e = elements[i];
	 
		  if(e.style.display == 'block') {
			e.style.display = 'none';
		  } else {
			e.style.display = 'block';
		  }
	   }
	 }
	-->
			$('.appPanel').hide();
			var appArray;
			var workingArrayCaps;
			var workingArrayAppsCaps;
			var appToCap=[];
			var processMap=[]; 
			let svsArray=[];
			var scores=[];
			var relevantOrgData=[]; 
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataCaps), 
			promise_loadViewerAPIData(viewAPIDataSvcs),
			promise_loadViewerAPIData(viewAPIDataActor)
			]).then(function (responses)
			{
			// 	console.log('viewAPIData',responses[0]);
			//	console.log('viewAPIDataApps',responses[1]);
			 //	console.log('viewAPIDataCaps',responses[2]);
			//	console.log('viewAPIDataSvcs',responses[3]);
			//	console.log('viewAPIDataActos',responses[4]);
				
				responses[4].orgData.forEach((d)=>{
					relevantOrgData.push({"id":d.id,"name":d.name, "allOrgsInScope": d.allChildOrgs})
				});
				responses[4]=[]; 
				if(relevantOrgData.length&gt;0){
						$('#viewOption').append($('&lt;option>', {
								value: 'compare',
								text: 'Compare'
							})); 
				}
				let workingArray = responses[0];
				svsArray = responses[3]
				meta = responses[1].meta; 
 
				meta.push({"classes":["Project"],"menuId":"projGenMenu"})
				filters=responses[1].filters;
				capfilters=responses[0].filters;

				filters.sort((a, b) => (a.id > b.id) ? 1 : -1)
		 
				filtersNo.forEach((e)=>{
					filters=filters.filter((f)=>{
						return f.slotName !=e;
					})
				 })
				 filtersNo.forEach((e)=>{
					capfilters=capfilters.filter((f)=>{
						return f.slotName !=e;
					})
				 })
 
				dynamicAppFilterDefs=filters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});

				dynamicCapFilterDefs=capfilters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
			 
				busGoals.forEach((e)=>{
					let capsList=[];
					e.objectives.forEach((c)=>{
						c.caps.forEach((sc)=>{
							capsList=[...capsList, ...sc.childCaps]
						})
					})
					e['capsList']=capsList;
				})
		 $('#keyHolder').html(goalKeyTemplate(busGoals))

		 $('.goalInfo').on('click',function(d){

			let goalId=$(this).attr('easid');
			thisgoal= busGoals.find((d)=>{
				return d.id==goalId;
			}) 
			$('#appData').html(goalTemplate(thisgoal));
			$('.appPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
	
			//$('#appModal').modal('show');
			$('.closePanelButton').on('click',function(){ 
				$('.appPanel').hide();
			})
		 })




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
  
				 let checkkey= false;
			 
				if(checkkey){$('#pmKey').show()}
				else{
					$('#pmKey').hide()
				}
			
				 getArrayDepth(workingArray.busCapHierarchy);
				 
			<!-- add org ids for all the related apps for filtering -->
				 workingArray.busCaptoAppDetails.forEach((d)=>{
					$('#capjump').append($('&lt;option>', {
						value: d.id,
						text: d.name
					}));
					let appOrgs=[];
					d.apps.forEach((dap)=>{
						let matchApp=responses[1].applications.find((ap)=>{
						 return ap.id==dap;
						});
					appOrgs=[...appOrgs, ...matchApp.orgUserIds];
					});
			   
					d['orgUserIds']=[...d.orgUserIds, ...appOrgs];
					 
				});

				var sel = $('#capjump');
				var selected = sel.val(); // cache selected value, before reordering
				var opts_list = sel.find('option');
				opts_list.sort(function(a, b) { return $(a).text() > $(b).text() ? 1 : -1; });
				sel.html('').append(opts_list);
				sel.val(selected);
				$('#capjump').select2({'width':'200px'});
		 
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
				let showInfo=0;
				workingArray.busCaptoAppDetails.forEach((bc)=>{
					//if infoConcepts in array then tell view to show
					if(bc.infoConcepts){showInfo=1}
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

				if(showInfo&gt;0){
					$('#viewOption').append($('&lt;option>', {
						value: 'data',
						text: 'Information Overlay'
					}));	
				}
				
				let capMod = new Promise(function(resolve, reject) { 
					resolve($('#capModelHolder').html(l0CapTemplate(workingArray.busCapHierarchy)));
					reject();
			   })
			    
			   capMod.then((d)=>{
				workingArray=[];
				filters=[...capfilters, ...filters];
			essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], filters, capfilters);
			   });

			  
			   removeEditorSpinner()
			   $('.appInDivBoxL0').hide();
			   $('.appInDivBox').hide();
			})

			relevantOrgData.forEach((org)=>{
				$('#leftOrgList').append($('&lt;option>', {
					value: org.id,
					text: org.name
				}));
				$('#rightOrgList').append($('&lt;option>', {
					value: org.id,
					text: org.name
				}));
			})
			$('#leftOrgList').select2();
			$('#rightOrgList').select2();
				 
		//	$('#scope-panel').append('<div style="position:relative;bottom:0px; right:10px; font-size:8pt; font-weight:bold; text-align:right">Available Filters: Business Unit, Geographic Region, Content Status</div>');
 

			}). catch (function (error)
			{
				//display an error somewhere on the page
			});
			
			let scopedApps=[]; 	
			let inScopeCapsApp=[];
			let scopedCaps=[];

var redrawView=function(){
	$('#capjump').prop('disabled', 'disabled');
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
	<!--	inScopeCapsApp.forEach((d)=>{
		 console.log('inScopeCapsApp',inScopeCapsApp)
			 $('div[eascapid="'+d.id+'"]').removeClass("off-cap");
		 
			});
		-->		
	}

	let appMod = new Promise(function(resolve, reject) { 
	 	resolve(appsToShow['applications']=scopedApps.resources);
		 reject();
	});

	appMod.then((d)=>{

		workingArrayAppsCaps.forEach((d)=>{ 
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

		$('.proj-circle').hide()
		$('.goalbox').hide();

		$('body').on("click", '.proj-circle', function ()
		{ 
			 
			let projCap=$(this).attr('easidproj');
			
			let focusCap=capProjects.find((e)=>{
				return e.id==projCap;
			})
			if(workingCapId!=projCap){
				$('.appRatButton').hide();
				$('#appsList').html(projectTemplate(focusCap))
				openNav(); 
				workingCapId=projCap;
			}
			else{
				closeNav();
			}
					
		})
		if($('#viewOption').val()=='apps'){
			$('.app-circle ').css('display','block')
		}else{
			$('.app-circle ').css('display','none')
		}
	$('.app-circle').on("click", function (d)
		{ d.stopImmediatePropagation(); 
			$('.appRatButton').show();
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
		$('.compare-circle').on("click", function (d){
			d.stopImmediatePropagation(); 
			let leftOrg=$('#leftOrgList').val();
			let rightOrg=$('#rightOrgList').val();
			let workLeft=relevantOrgData.find((e)=>{ return e.id==leftOrg})
			let workRight=relevantOrgData.find((e)=>{ return e.id==rightOrg})
			let capid=$(this).attr('easidcompare');	
			let thisCapAppList = inScopeCapsApp.filter(function (d)
				{
					return d.id == capid;
				});		
	 
			let thisAppArray=[]
			thisCapAppList[0].filteredApps.forEach((app)=>{
				let thisApps= appArray.applications.find((d)=>{
					return d.id ==app;
				})
				thisAppArray.push(thisApps)
			})
			let leftMatch=[];
			if(workLeft){
				
				thisAppArray.forEach((ap)=>{
					if(workLeft.allOrgsInScope){
						workLeft.allOrgsInScope.forEach((wl)=>{
							let match=ap.orgUserIds.find((ap)=>{
								return ap==wl;
							})
							if(match){
						 
								leftMatch.push(ap) 
							}
						})
					}
				})
	 
			}
			let rightMatch=[];
			if(workRight){
				let capMatch=[];
				thisAppArray.forEach((ap)=>{
					if(workRight.allOrgsInScope){
						workRight.allOrgsInScope.forEach((wl)=>{
							let match=ap.orgUserIds.find((ap)=>{
								return ap==wl;
							})
							if(match){ 
						 
								rightMatch.push(ap) 
							}
						})
					}
				})  
			} 
			let allApps=[...rightMatch, ...leftMatch];
			let rowToShow=[]; 
			allApps.forEach((ap)=>{
				let thisApp=thisAppArray.find((a)=>{
					return a.id==ap.id;
				}) 
				let inLeft=leftMatch.find((la)=>{
					return la.id==ap.id;
				})
				let inRight=rightMatch.find((la)=>{
					return la.id==ap.id;
				}) 
				if(inLeft){
					thisApp['left']='true'
				}else{
					if($('#leftOrgList :selected').text()=='All'){
						thisApp['left']="true"}
					else{
						thisApp['left']='false'
					}
				}

				if(inRight){
					thisApp['right']='true'
				}else{
					if($('#rightOrgList :selected').text()=='All'){
						thisApp['right']="true"}
					else{
						thisApp['right']='false'
					}
				}
				rowToShow.push(thisApp)
			})
			
			let dataToShow=[];
			dataToShow['left']=$('#leftOrgList :selected').text();
			dataToShow['right']=$('#rightOrgList :selected').text(); 
			dataToShow['name']=thisCapAppList[0].name;
			dataToShow['id']=thisCapAppList[0].id;
			dataToShow['rows']=rowToShow;
			dataToShow.rows=dataToShow.rows.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
			
			$('#appData').html(compareTemplate(dataToShow));
			$('.appPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );

			//$('#appModal').modal('show');
			$('.closePanelButton').on('click',function(){ 
				$('.appPanel').hide();
			})

		})

function getApps(capid){
 
	let thisCapAppList =  workingArrayAppsCaps.filter(function (d)
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
		let capName= workingArrayAppsCaps.filter((d)=>{return d.id==capid})
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
	rationalisationList=[];
	thisCapAppList[0].apps.forEach((d)=>{ 
		rationalisationList.push(d)
	});
	}

	let leftOrg=$('#leftOrgList').val();
	let rightOrg=$('#rightOrgList').val(); 
	let workLeft=relevantOrgData.find((e)=>{ return e.id==leftOrg})
	let workRight=relevantOrgData.find((e)=>{ return e.id==rightOrg})
	let appCount=0
<!--	$('.app-circle').text('0')
		$('.app-circle').each(function() {
			console.log('addap',$(this).html() )
			if($(this).html() ==0) {$(this).parent().addClass("off-cap")
				console.log('added off-cap')
				}

			$(this).html() &lt; 2 ? $(this).css({'background-color': '#e8d3f0', 'color': 'black'}) : null;
		  
			($(this).html() >= 2 &amp;&amp; $(this).html() &lt; 6) ? $(this).css({'background-color': '#e0beed', 'color': 'black'}): null;
		  
			$(this).html() >= 6 ? $(this).css({'background-color': '#d59deb', 'color': 'black'}) : null;
		  });
		-->
		  
	  
		  inScopeCapsApp.forEach((e)=>{
			  
			  $('*[easidscore="' + e.id + '"]').parent().removeClass("off-cap")
		  
		  })

		  workingArrayAppsCaps.forEach(function (d)
		{

			compareScoreA=0;
			compareScoreB=0; 
	 
		//	orgUserIds:

			let thisAppArray=[]
			d.filteredApps.forEach((app)=>{
				let thisApps= appArray.applications.find((d)=>{
					return d.id ==app;
				})
				thisAppArray.push(thisApps)
			})
	  
			if(workLeft){
				let capMatch=[];
				thisAppArray.forEach((ap)=>{
					workLeft.allOrgsInScope.forEach((wl)=>{
						let match=ap.orgUserIds.find((ap)=>{
							return ap==wl;
						})
						if(match){
							capMatch.push(match)
							compareScoreA=1
						}
					})
				})
			
			}
			if(workRight){
				let capMatch=[];
				thisAppArray.forEach((ap)=>{
					workRight.allOrgsInScope.forEach((wl)=>{
						let match=ap.orgUserIds.find((ap)=>{
							return ap==wl;
						})
						if(match){ 
							capMatch.push(match)
							compareScoreB=1
						}
					})
				}) 
			}


			let compareScoreAll = compareScoreB + compareScoreA;
			$('*[easidcompare="' + d.id + '"]').removeClass('bothAppColour leftAppColour rightAppColour');
			if(compareScoreAll&gt;0){
				
				if(compareScoreAll==2){
					
					$('*[easidcompare="' + d.id + '"]').html('B').addClass('bothAppColour').css("color","#7438A4");
				}else{
					if(compareScoreA==1){ 
						$('*[easidcompare="' + d.id + '"]').html('1').addClass('leftAppColour').css("color","#24A5F4");
					}else{
						$('*[easidcompare="' + d.id + '"]').html('2').addClass('rightAppColour').css("color","#1FC1B4");
					}
				}
			}else{
			$('*[easidcompare="' + d.id + '"]').html('?').css("color","#fff");;
			}

	 
		});
		workingArrayAppsCaps.forEach(function (d)
		  {
			
			  let appCount=d.filteredApps.length;
			  $('*[easidscore="' + d.id + '"]').html(appCount);
			 
			  let colour='#fff';
			let textColour='#fff'; 
			if(appCount !=0 ){
				$('*[eascapid="' + d.id + '"]').parent().removeClass("off-cap");
		 
		}
			if(appCount ==0 ){colour='#d3d3d3';
			$('*[eascapid="' + d.id + '"]').addClass("off-cap");
		}   
			else if(appCount &lt;2){colour='#EDBB99'}
			else if(appCount &lt;6){colour='#BA4A00';
			
		} 
			else{colour='#6E2C00'}
			$('*[easidscore="' + d.id + '"]').css({'background-color':colour, 'color':textColour})
		  })
		$('#capjump').prop('disabled', false);
	})


	
}

function redrawView() {
	essRefreshScopingValues()
}
});
$('#capjump').prop('disabled', 'disabled');

$('#capjump').change(function(){
	var id = "#" + $(this).val();
 
	$('html, body').animate({
		scrollTop: $(id).offset().top
	}, 5000);
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
	<xsl:template match="node()" mode="busGoals">
					<xsl:variable name="this" select="current()"/>
					<xsl:variable name="goalBusObjs" select="$allBusObjectives[name=$this/own_slot_value[slot_reference = 'goal_supported_by_objectives']/value]"/> 
					<xsl:variable name="pseudoGoalbusObjs" select="$allBusObjectives[name=$this/own_slot_value[slot_reference = 'objective_supported_by_objective']/value]"/> 
					<xsl:variable name="busObjs" select="$goalBusObjs union $pseudoGoalbusObjs"/> 
					{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="isRenderAsJSString" select="true()"/>
						</xsl:call-template>",
					"className":"<xsl:value-of select="current()/type"/>",
					"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
					"objectives":[<xsl:apply-templates select="$busObjs" mode="objs"/>],
					"goalColour":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
					"goaltxtColour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>",
					}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="objs">
			<xsl:variable name="busCapsImpacted" select="key('busCapImpact',current()/name)"/>
				{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
			"caps":[<xsl:for-each select="$busCapsImpacted">
					<xsl:variable name="relevantBusCaps" select="eas:get_cap_descendants(current(), $busCaps, 0, 10, 'supports_business_capabilities')"/>
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
					"childCaps":[<xsl:for-each select="$relevantBusCaps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="capChanges">
			<xsl:variable name="busCapP2es" select="key('plantolement_key',current()/name)"/>
			<xsl:variable name="busCapProjects" select="key('projecttoplantolement_key',$busCapP2es/name)"/>
				{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
			"projects":[<xsl:for-each select="$busCapProjects">
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
					"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
					"actualstartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_actual_start_date_iso_8601']/value"/>",
					"forecastendDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_forecast_end_date_iso_8601']/value"/>",
					"proposedstartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_proposed_start_date_iso_8601']/value"/>",
					"targetEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='ca_target_end_date_iso_8601']/value"/>",
					}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:function name="eas:get_cap_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeOrgs"/>
		<xsl:param name="level"/>
		<xsl:param name="maxDepth"/>
		<xsl:param name="slotName"/>
		<xsl:sequence select="$parentNode"/>
		<xsl:if test="$level &lt; $maxDepth">
		 <xsl:variable name="childOrgs" select="$inScopeOrgs[own_slot_value[slot_reference = $slotName]/value = $parentNode/name]" as="node()*"/> 
			<xsl:for-each select="$childOrgs">
				<xsl:sequence select="eas:get_object_descendants(current(), ($inScopeOrgs), $level + 1, $maxDepth, $slotName)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>
</xsl:stylesheet>
