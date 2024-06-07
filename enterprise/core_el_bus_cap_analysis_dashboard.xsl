<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<!-- END GENERIC PARAMETERS -->
	<xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Business Capability Dashboard']"></xsl:variable>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"></xsl:variable>
	<xsl:key name="busCapsKey" match="/node()/simple_instance[type='Business_Capability']" use="name"/> 
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability','Business_Goal', 'Business_Objective', 'Project','Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>
	<xsl:variable name="apps" select="/node()/simple_instance[type=('Composite_Application_Provider','Application_Provider')]"></xsl:variable>
	<xsl:key name="eleStyle" match="/node()/simple_instance[type='Element_Style']" use="own_slot_value[slot_reference='style_for_elements']/value"/>

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
 
	
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="capsListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
	<xsl:variable name="servicesListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Services']"></xsl:variable>
	<xsl:variable name="actorData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"/>

	<xsl:variable name="goalTaxonomy" select="/node()/simple_instance[type='Taxonomy_Term'][own_slot_value[slot_reference='name']/value='Strategic Goal']"/> 
	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[(type = 'Business_Objective') and not(own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name)]"/>
	<xsl:variable name="allStrategicGoals" select="/node()/simple_instance[(type = 'Business_Goal') or ((type = 'Business_Objective') and (own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name))]"/>
	<xsl:variable name="busGoals" select="$allStrategicGoals"/>

	<xsl:variable name="objContribution" select="/node()/simple_instance[type='Objective_Type_Contribution_Level']"/>
	<xsl:variable name="goalCategories" select="/node()/simple_instance[type='Business_Goal_Category']"/>
	<xsl:key name="busGoalCategory" match="$goalCategories" use="name"/>
	<xsl:variable name="busCaps" select="/node()/simple_instance[type='Business_Capability']"/>
	<xsl:key name="busCapImpact" match="$busCaps" use="own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value"/>
	<xsl:key name="busCapObjRelationKey" match="/node()/simple_instance[type='BUSCAP_TO_BUS_OBJ_TYPE_RELATION']" use="own_slot_value[slot_reference = 'buscap_to_bus_obj_type_bus_obj_type']/value"/>
	<xsl:key name="busCapImpactFromCapObjRelation" match="$busCaps" use="own_slot_value[slot_reference = 'buscap_supported_bus_goals_objs']/value"/>

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
				
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"></script>
				<title>Business Capability Model</title>
				<style>
					<!-- old style -->
						.l0-capOld{
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
						.l1-caps-wrapperOld{
							display: flex;
							flex-wrap: wrap;
							margin-top: 10px;
						}
						
						.l2-caps-wrapperOld,.l3-caps-wrapperOld,.l4-caps-wrapperOld,.l5-caps-wrapperOld,.l6-caps-wrapperOld{
							margin-top: 10px;
						}
						
						.l1-capOld,.l2-capOld,.l3-capOld,.l4-capOld{
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

						.l1-capOld{
							min-width: 200px;
							width: 200px;
							max-width: 200px;
						}
						
						.l2-capOld{
							border: 1pt solid #ccc;
							border-left: 3px solid hsla(200, 80%, 50%, 1);					
							background-color: #fff;
							min-width: 180px;
							width: 180px;
							max-width: 180px;
						}
						
						.l3-capOld{
							border: 1pt solid #ccc;
							border-left: 3px solid rgb(125, 174, 198);					
							background-color: rgb(218, 214, 214);
							min-width: 160px;
							width: 160px;
							max-width: 160px;
							min-height: 60px;

						}
						
						.l4-capOld{
							border: 1pt solid #ccc;
							border-left: 3px solid rgb(180, 200, 210);					
							background-color: rgb(164, 164, 164);
							min-width: 140px;
							width: 140px;
							max-width: 140px;
							min-height: 60px;

						}
						.l5on-capOld{
							min-width: 90%;
							width: 90%; 
							min-height: 50px;
							border:1pt solid #d3d3d3;
							background-color:#fff;
							margin:2px;

						}

					<!-- new -->
					.l0-cap{
						border: 1px solid #ccc;
						border-left: 3px solid hsla(200, 80%, 50%, 1);
						border-bottom: 1px solid #fff;
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 10px;
						margin-bottom: 15px;
						font-weight: 700;
						position: relative;
					}
					.l1-caps-wrapper {
						display: flex;
						flex-wrap: wrap;
						gap: 10px;
						justify-content: flex-start; /* Aligns items to the start */
					}
					
					.l1-cap {
						flex: 1;
						flex-shrink: 0;
						flex-basis: calc(33% - 10px); /* Set to 33% for up to 3 items per row */
						min-width: 160px; /* Adjust minimum width as needed */
						/* Rest of your styles */
					}
					
					/* Ensuring the last item in the row can grow more if needed */
					.l1-caps-wrapper .l1-cap:last-child {
						flex-grow: 2; /* Allows the last item to grow more if it's alone in the last row */
					}
					
					.l2-caps-wrapper,.l3-caps-wrapper,.l4-caps-wrapper,.l5-caps-wrapper,.l6-caps-wrapper{
						margin-top: 0px;
						display: flex;
						gap: 5px;
						flex-wrap: wrap;
						flex-direction: row;
						max-width: 590px;
					}
					
					.l1-cap,.l2-cap,.l3-cap{
						border-bottom: 1px solid #fff;
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 5px 5px;
						font-weight: 400;
						position: relative;
						min-height: 60px;
						line-height: 1.1em;
						min-width: 160px;
					}
					.l4-cap{
						border-bottom: 1px solid #fff;
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 5px 5px;
						font-weight: 400;
						position: relative;
						min-height: 60px;
						line-height: 1.1em;
						width:98%;
						min-width: 60px;
					}
					
					.l2-cap{
						border: 1px solid #ccc;
						border-left: 3px solid hsla(200, 80%, 50%, 1);					
						background-color: #fff;
						font-size:0.9em;
						width: 175px;
						z-index:5;
					}
					
					.l3-cap{
						border: 1px solid #ccc;
						border-left: 3px solid hsla(200, 80%, 70%, 1);					
						background-color: #ddd;
						font-size:0.9em;
						width: 175px;
						z-index:5;

					}
					
					.l4-cap{
						border: 1px solid #ccc;
						border-left: 3px solid rgb(180, 200, 210);					
						background-color: rgb(164, 164, 164);
						width: 100%;
						font-size:0.9em;
						z-index:5;
					}

					.l5on-cap{
						min-width: 95%;
						width: 95%; 
						min-height: 50px;
						border:1pt solid #d3d3d3;
						background-color:#fff;
						font-size:0.85em;
						z-index:5;
					}

					.off-cap{
						border: 1pt solid #ccc;
						border-left: 3px solid #666;
						background-color: #c8c2e8;
					}
					
					.off-cap > .sub-cap-label > a {color: #606060!important;}
					
					.l0-cap > .cap-label {font-size: 1.1em; text-transform: uppercase; font-weight: 700; margin-bottom:0px}
					.l1-cap > .cap-label {font-size: 1em; font-weight: 700;width: 120px;}
					.l2-cap > .cap-label {font-size: 1em;width: 120px;}
					.l3-cap > .cap-label {font-size: 0.9em;width: 120px;}
					.l4-cap > .cap-label {font-size: 0.9em;width: 120px;}
					
					.cap-label,.sub-cap-label{
						margin-right: 20px;
						margin-bottom: 10px;
						margin-top:0px;
						display: inline-block;
						height: 24px;
						line-height: 1.1em;
					}
					.sub-cap-label{
						font-size:0.95em;
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
					.goalboxtop{
						font-weight: 400;
						position: absolute;
						top:27px;
						min-height: 10px;
						width:95%;
						text-align: left;
						display:none;
						z-index:0;
					}

					.goalpill{
						border-radius:5px;
						margin-left:2px;
						border:1pt solid #d3d3d3;
						position: relative;
						display:inline-block;
						width:10px;
						height: 8px; 
					}

					.goalpillsmall{
						border-radius:5px;
						margin-left:2px;
						border:1pt solid #d3d3d3;
						position: relative;
						display:inline-block;
						width:7px;
						height: 8px;
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
						z-index:10;
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
							padding-top: 41px;
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

					.inscope-icon{
						display: none;
						position: absolute;
						right: 3px;
						bottom: 2px;
						font-size: 0.8em;
						color: rgb(41 91 138);
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
						color: #000000;
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
					.appIncapBoxWrapperL0{
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
					.appIncapBoxWrapper{
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
							height:120px;
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
							position: relative;
							border-radius: 4px 4px 0px 0px;
							background-color: #636363;
							color: #fff;
							padding: 1px 5px;
						}
						.goalMain{
							padding-right: 3px;
							border-radius: 4px;
							padding: 5px;
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
					.reset-btn{
						background-color: #666;
						color: #fff;
						position: absolute;
						bottom: 2px;
						right: 5px;
						font-size: 85%;
					}
                    .configure{
                        position: absolute;
						top: -11px;
						right: 30px;
                    }
					.infoBox{
						height:0px;
						display:none;
						opacity:0;
					}
					/* Handle to open the toppanel */
					#optionsBoxContainer {
						position: relative; 
						top:-20px /* Container to position the handle relative to */
					}
					
					.handle {
						position: absolute; /* Positioned relative to optionsBoxContainer */
						top: 0; /* Align with the top of the container */
						right: 50%; /* Align with the right of the container */
						z-index: 3; /* Higher z-index to be on top */
						background-color: #333;
						color: white;
						padding: 0px 5px;
						cursor: pointer;
						text-align: center; 
						border-radius: 0px 0px 5px 5px; /* Rounded corners on the left */
						font-size: 85%;
					}

					/* The sidepanel (hidden by default) */
					  .sidepanel {
						  height: 100%;
						  width: 0;
						  position: fixed;
						  z-index: 1002; /* Ensure it's above other content */
						  top: 0;
						  right: -300px;
						  background-color: #111111;
						  overflow-x: hidden;
						  transition: 0.5s;
						  padding: 45px 10px 10px 10px;
						  color:#ffffff;
					  }
					  
					  /* Handle to open the sidepanel */
					  .handle2 {
						  position: fixed; /* changed to fixed */
						  right: 30px; /* position on the right edge */
						  top: 30%; /* vertically centered */
						  z-index: 3; /* higher z-index to be on top */
						  background-color: #333;
						  color: white;
						  padding: 5px 10px;
						  cursor: pointer;
						  text-align: center;
						  border-radius: 5px 0 0 5px; /* rounded corners on the left */
						  transform: translateX(100%); /* move it right so it's visible */
						  transition: 0.5s;
					  }
					
					#optionsBox {
						overflow-x: hidden; /* Ensure content does not overflow when collapsed */
						height: 0; /* Start collapsed */
						/* Other styles as needed */
						position:relative;
					}
					.optionsPanel{
						width:100%;
						height:100%;
						border-radius: 4px;
						padding: 0;
						border: 0px solid #ccc;
						background-color: #f6f6f6;
					}

					#goalsCatBox {
						position: relative;
						top: -3px;
					}

					.legend{
						display:inline-block;
					}
					.goalBlock{
						border:1pt solid #d3d3d3;
						border-radius:6px;
						background-color:#ffffff;
						color:black;
						padding:3px;
						margin:2px;
					}

					.model-section-wrapper {
						border: 1px solid #ccc;
						padding: 10px;
						margin: 10px 0;
						background-color: #fcfcfc;
					}

                    .valueHead{
						border-radius:4px;
						padding: 5px;
					}

					.herm-flex-grow-gap-10 {
						display: flex;
						flex: 1;
						gap: 10px;
					}

					.herm-lt-left {
						flex-direction: column;
					}

					.herm-lt-right {
						flex-wrap: wrap;
					}
					
					.shared-box-wrapper {
						display: flex;
						flex-wrap: nowrap;
						flex: 1;
						gap: 10px;
						flex-direction: column;
						flex-basis: 100%;
					}

					.capBox{
					  border:1px solid #ccc;
					  background-color: #fff;
					  width: 120px;
					  height:60px;
					  border-radius:4px;
					  padding:5px;
					  font-size:0.8em;
                      position:relative;
					}

					.value-chain-wrapper {
						display: flex;
						flex: 1;
						flex-direction: column;
						gap: 10px;
					}
		  
					.capBoxWrapper{
						border:1px solid #ccc;
						border-radius:4px;
						padding:5px;
						background-color: #eee;
						flex: 1;
						gap: 5px;
					}

					.capBoxL1Wrapper {
						display: flex;
						flex-wrap: wrap;
						gap: 5px;
					}

					.capBoxWrapper5{
						width:19%; 
						display:inline-block;
			
					  }
					
					.busCapFocus{
						position: absolute;
						bottom: 2px;
						right: 5px;
						color: #c3193c;
						z-index:8;
					}

					.busCapFocus:hover {
						cursor: pointer;
						opacity: 0.75;
					}

					#keyHolder {
						display: flex;
						gap: 10px;
					}

					/* Custom container class to remove margins and paddings */
					.my-custom-container, .my-custom-container .row {
						margin-right: 0;
						margin-left: 0;
						padding-right: 0;
						padding-left: 0;
					}
					
					.research-box {
		  
				  }

				  .enabling-box {
					display: flex;
					gap: 10px;
					flex: 1;
				  }
					
				/* Responsive adjustments */
				@media (max-width: 1024px) {
					.learning-teaching-box,
					.research-box {
					grid-template-columns: repeat(3, 1fr); /* Adjust to a 3 column layout for tablets */
					}
				}
				
				@media (max-width: 768px) {
					.learning-teaching-box,
					.research-box {
					grid-template-columns: 1fr; /* Stack items on top of each other for mobile */
					}
					.capBox {
					width: 100%; /* Full width for containers on mobile */
					}
					.shared,
					.shared2 {
					grid-column: 1; /* All items take up the full width */
					}
				}
				.capHead{
					font-size:0.9em;
					font-weight:bold;
					flex-basis: 100%;
				}
                .subroot{
                    padding-top:5px;
                }
				.capColour{
					background-color: #ff8badb3;
					color:#ffffff;
				}
				.shade1 { background-color: #ff8bad; }  
				.shade2 { background-color: #ffb9ce; }  
				.shade3 { background-color: #ffe8ef; }
				.shade4 { background-color: #fff3f7; }
				.shade5 { background-color: #6fa8aa; }  
				.shade7 { background-color: #8fbbbd; }
				.shade8 { background-color: #bfd8d9; }
				.shade6 { background-color: #cfe2e3; }  
				
	</style>
 
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
 
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
						<div class="col-xs-12" id="optionsBoxContainer">
							<span class="handle"><i class="fa fa-arrow-circle-down handleicon right-5" aria-hidden="true"></i>View Options</span>
							<div class="optionsPanel">
								<div id="optionsBox">
									<div class="large strong bottom-10">Options</div>
									<div class="row">
										<div class="col-md-3">
											<strong class="right-5"><xsl:value-of select="eas:i18n('Caps Style')"/>:</strong>
											<button class="btn btn-xs btn-success" id="hideCaps">Show</button>
											<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Show Retired')"/>:</strong>
											<input type="checkbox" id="retired" name="retired"/>
										</div>
										<div class="col-md-3">
											<div id="subroot">
												<strong class="right-5"><xsl:value-of select="eas:i18n('Root Capability')"/>:</strong>
												<select name="subrootcap" id="subrootcap" class="subrootcap"/>
											</div>
										
										</div>	
										<div class="col-md-4">	
											<div id="goalsCatBox">
												<strong class="right-5"><xsl:value-of select="eas:i18n('Goals Categories')"/>:</strong>
												<select name="goalsCategory" id="goalsCategory" class="goalsCategory form-control" multiple="multiple"/>
											</div>
										</div>
										<div class="col-md-2">
											<div class="configure"  ><xsl:value-of select="eas:i18n('Switch Capability Style:')"/>
												<!-- <i class="fa fa-cog" style="color:#c3193c" id="config"></i><i class="fa fa-graduation-cap" style="color:#c3193c" id="herm"></i>
												-->
												<div class="radio-group">
													<input type="radio" id="herm" name="type-group" class="radio-group hermRadio" checked="true"/>
													<label for="radio3"><i class="fa fa-graduation-cap hermRadio"></i></label>
		
													<input type="radio" id="bars" name="type-group" class="radio-group"/>
													<label for="radio1"><i class="fa fa-bars"></i></label>
												  
													<input type="radio" id="brick" name="type-group" class="radio-group"/>
													<label for="radio2"><i class="fa fa-th-list"></i></label>
												  
											 
												  </div>
											</div>
										</div>
									</div>									
								</div>
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
								
								<div class=" top-10">
								<!--	<strong class="right-5"><xsl:value-of select="eas:i18n('Caps Style')"/>:</strong>
									<button class="btn btn-xs btn-success" id="hideCaps">Show</button> 
									<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Show Retired')"/>:</strong>
									<input type="checkbox" id="retired" name="retired"/>-->
									<strong class="right-5"><xsl:value-of select="eas:i18n('Perspectives')"/>:</strong>
									<select name="viewOption" id="viewOption"/>
									<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Jump To')"/>:</strong>
									<select name="capjump" id="capjump"/>
								<!--	<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Root Capability')"/>:</strong>
									<select name="subrootcap" id="subrootcap"/>-->
								</div>
								<div class="showApps right-30" id="pmKey">
									<xsl:value-of select="eas:i18n('Ratings')"></xsl:value-of>:<input type="checkbox" id="fit" name="fit"></input>
								</div>
								<div class="top-10 bottom-10">
									<div class="" id="keyHolder" style="display:none"/>
									
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="pull-right" id="blobLevel"/><br/><br/>
								<div class="pull-right "> 
								
									<div class="legend">
										<div class="inline-block right-30 appusage">
											<strong class="right-10"><xsl:value-of select="eas:i18n('Application Usage Key')"></xsl:value-of>:</strong>
											<i class="fa fa-square shigh right-5"></i><xsl:value-of select="eas:i18n('High')"/>
											<i class="fa fa-square smed left-10 right-5"></i><xsl:value-of select="eas:i18n('Medium')"/>
											<i class="fa fa-square slow left-10 right-5"></i><xsl:value-of select="eas:i18n('Low')"/>
										</div>
										<div class="inline-block left-30">
											<i class="fa fa-bullseye right-5 text-primary"/>
											<xsl:value-of select="eas:i18n('Click to focus')"/>
										</div>
									</div>
							</div>
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
								<select id="rightOrgList" class="form-control orgCompare" style="width:100%"><option value="all"><xsl:value-of select="eas:i18n('All')"/></option></select>		
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
						<div id="infoSidepanel" class="sidepanel">
							<b><span id="recipeTitle"></span></b>: <select id="recipeListSelect"/><xsl:text> </xsl:text> <button id="clr" class="btn btn-success btn-xs">Clear Highlight</button>
							<div id="recipeList"/>
							<span class="handle2"><i class="fa fa-file-text-o" aria-hidden="true"></i></span>
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
<!-- HERM -->
<script id="herm-model-template" type="text/x-handlebars-template">
	<div class="model-section-wrapper">
		<div class="impact bottom-10 xlarge text-primary">Core Capabilities and Value Chains</div>
		<div>
			<div class="impact bottom-10 large">Learning &amp; Teaching</div>
			<div class="learning-teaching-box herm-flex-grow-gap-10">
				<div id="design" class="herm-lt-left herm-flex-grow-gap-10" style="flex:1">
					<div class="value-chain-wrapper" style="flex:1">
						<div class="valueHead strong bg-primary">DESIGN</div>
						<div id="designBox" class="herm-flex-grow-gap-10" />
					</div>
				</div>
				<div class="herm-lt-right herm-flex-grow-gap-10" style="flex:5">
					<div class="herm-lt-right-sub herm-flex-grow-gap-10">
						<div class="value-chain-wrapper" style="flex:4">
							<div class="valueHead strong bg-primary">RECRUIT</div>
							<div id="recruit" class="herm-flex-grow-gap-10" />
						</div>	
						<div class="value-chain-wrapper" style="flex:2">
							<div class="valueHead strong bg-primary">ENROL</div>
							<div id="enroll" class="herm-flex-grow-gap-10" />
						</div>
						<div class="value-chain-wrapper" style="flex:2">
							<div class="valueHead strong bg-primary">DELIVER</div>
							<div id="deliver" class="herm-flex-grow-gap-10" />
						</div>
						<div class="value-chain-wrapper" style="flex:1">
							<div class="valueHead strong bg-primary">ASSESS</div>
							<div id="assess" class="herm-flex-grow-gap-10" />
						</div>
						<div class="value-chain-wrapper" style="flex:1">
							<div class="valueHead strong bg-primary">CONFER</div>
							<div id="confer" class="herm-flex-grow-gap-10" />
						</div>
					</div>
					<div class="shared-box-wrapper">
						<div class="sharedBox">
							<div id="studentManage" class="herm-flex-grow-gap-10" />
						</div>
						<div class="sharedBox">
							<div id="studentSupport" class="herm-flex-grow-gap-10" />
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="top-30">
			<div class="impact bottom-10 large">Research</div>
			<div class="research-box herm-flex-grow-gap-10">
				<div class="herm-res-wrapper herm-flex-grow-gap-10">
					<div class="value-chain-wrapper" style="flex:2">
						<div class="valueHead strong bg-primary">PLAN</div>				
						<div id="planBox" class="herm-flex-grow-gap-10"/>
					</div>
					<div class="value-chain-wrapper" style="flex:1">
						<div class="valueHead strong bg-primary">FUND</div>
						<div id="fundBox" class="herm-flex-grow-gap-10"/>
					</div>
					<div class="value-chain-wrapper" style="flex:2">
						<div class="valueHead strong bg-primary">ASSUME</div>
						<div id="assureBox" class="herm-flex-grow-gap-10"/>
					</div>
					<div class="value-chain-wrapper" style="flex:3">
						<div class="valueHead strong bg-primary">CONDUCT</div>
						<div class="herm-flex-grow-gap-10">
							<div id="conductBox" class="herm-flex-grow-gap-10" style="flex:1"/>
							<div id="conductBox2" class="herm-flex-grow-gap-10" style="flex:2"/>
						</div>
					</div>
					<div class="value-chain-wrapper" style="flex:2">
						<div class="valueHead strong bg-primary">DISSEMINATE</div>
						<div id="disseminate" class="herm-flex-grow-gap-10"/>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="model-section-wrapper top-30">
		<div class="impact bottom-15 xlarge text-primary">Enabling Capabilities</div>
		<div class="shared-box-wrapper herm-flex-grow-gap-10">
			<div class="enabling-box herm-flex-grow-gap-10">
				<div class="herm-flex-grow-gap-10" style="flex:1">
					<div id="strategymgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:5">
					<div id="bcmmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:5">
					<div id="grcmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:1">
					<div id="librarymgmt" class="herm-flex-grow-gap-10"></div>
				</div>
			</div>
			<div class="enabling-box">
				<div class="herm-flex-grow-gap-10" style="flex:2">
					<div id="advancemgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:3">
					<div id="mktgmmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:3">
					<div id="engagementmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:2">
					<div id="legalmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:2">
					<div id="itmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
			</div>
			<div class="enabling-box">
				<div class="herm-flex-grow-gap-10" style="flex:1">
					<div id="hremgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:1">
					<div id="financemmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
			</div>
			<div class="enabling-box">
				<div class="herm-flex-grow-gap-10" style="flex:2">
					<div id="infomgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:2">
					<div id="facilitiesmmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
				<div class="herm-flex-grow-gap-10" style="flex:3">
					<div id="supportingmmgmt" class="herm-flex-grow-gap-10"></div>
				</div>
			</div>
		</div>
    </div>

</script>
<script id="caps-template" type="text/x-handlebars-template">
    <div class="capBoxWrapper buscap">
        <div class="capHead bottom-10">{{this.name}}</div>
		<div class="capBoxL1Wrapper">
        {{#each this.childrenCaps}}
        {{#ifEquals ../this.width  5}}
            <div class="capBox buscap capBox5"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
                <span class="sub-cap-label"> {{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
                <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
                <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
                <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
				 	
                {{#getApps this}}{{/getApps}} 
                    {{> l2CapTemplate}} 	
                    {{#if this.childrenCaps}}
                    <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                    {{else}}
                    <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                    {{/if}}

					 	
                </div>
        {{else}}
        {{#ifEquals ../this.width  4}}
            <div class="capBox buscap capBox4"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
                <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
				<i class="fa fa-bullseye busCapFocus"></i>
                <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
                <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
                <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
                {{#getApps this}}{{/getApps}} 
                    {{> l2CapTemplate}} 	
                    {{#if this.childrenCaps}}
                    <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                    {{else}}
                    <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                    {{/if}}
                </div>
        {{else}}
        {{#ifEquals ../this.width  3}}
        <div class="capBox buscap capBox3"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
            <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
			<i class="fa fa-bullseye busCapFocus"></i> 
            <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
            <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
            <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
            {{#getApps this}}{{/getApps}} 
                {{> l2CapTemplate}} 	
                {{#if this.childrenCaps}}
                <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                {{else}}
                <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                {{/if}}
            </div>
        {{else}}
        {{#ifEquals ../this.width 2}}
            <div class="capBox buscap capBox2"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
                <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
				<i class="fa fa-bullseye busCapFocus"></i> 
                <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
                <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
                <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
                {{#getApps this}}{{/getApps}} 
                    {{> l2CapTemplate}} 	
                    {{#if this.childrenCaps}}
                    <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                    {{else}}
                    <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                    {{/if}}
                </div>
        {{else}}
        {{#ifEquals ../this.width 6}}
        <div class="capBox buscap capBox6"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
            <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
			<i class="fa fa-bullseye busCapFocus"></i> 
            <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
            <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
            <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
            {{#getApps this}}{{/getApps}} 
                {{> l2CapTemplate}} 	
                {{#if this.childrenCaps}}
                <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                {{else}}
                <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                {{/if}}
            </div>
        {{else}}
        {{#ifEquals ../this.width 7}}
            <div class="capBox buscap capBox7"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
                <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
				<i class="fa fa-bullseye busCapFocus"></i> 
                <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
                <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
                <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
                {{#getApps this}}{{/getApps}} 
                    {{> l2CapTemplate}} 	
                    {{#if this.childrenCaps}}
                    <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                    {{else}}
                    <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                    {{/if}}
                </div>
        {{else}}
            <div class="capBox buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
                <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
				<i class="fa fa-bullseye busCapFocus"></i> 
                <span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
                <span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
                <span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
                {{#getApps this}}{{/getApps}} 
                    {{> l2CapTemplate}} 	
                    {{#if this.childrenCaps}}
                    <div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
                    {{else}}
                    <div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
                    {{/if}}
                </div>
        {{/ifEquals}}
    {{/ifEquals}}
        {{/ifEquals}}
    {{/ifEquals}}
        {{/ifEquals}} 
        {{/ifEquals}}
        {{/each}}
	</div>
    </div>
</script>	
<script id="caps5-template" type="text/x-handlebars-template">
    <div class="capBoxWrapper5 buscap">
		<div class="capBoxL1Wrapper">
			<div class="capHead bottom-10">{{this.name}}</div>
			{{#each this.childrenCaps}}
			<div class="capBox buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
				<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
				<i class="fa fa-bullseye busCapFocus"></i> 
				<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
				<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
				<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
				{{#getApps this}}{{/getApps}} 
					{{> l2CapTemplate}} 	
					{{#if this.childrenCaps}}
					<div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
					{{else}}
					<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
					{{/if}}
				</div>
			
			{{/each}}
		</div>
    </div>
</script>	
<script id="divs-template" type="text/x-handlebars-template">
    <div class="capBoxWrapper buscap">
		<div class="capBoxL1Wrapper">
			<div class="capHead bottom-10">{{this.name}}</div>
			{{#each this.childrenCaps}}
			<div class="capBox buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
				<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
				<i class="fa fa-bullseye busCapFocus"></i>
				<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
				<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
				<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
				{{#getApps this}}{{/getApps}} 
					{{> l2CapTemplate}} 	
					{{#if this.childrenCaps}}
					<div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
					{{else}}
					<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
					{{/if}}
				</div>
			{{/each}}
		</div>
    </div>
</script>	



				<!-- caps template -->
				<script id="model-l0-template" type="text/x-handlebars-template">
		         	<div class="capModel">
						{{#each this}}
							<div class="l0-cap">
								<xsl:attribute name="level">{{this.level}}</xsl:attribute>
								<xsl:attribute name="id">{{id}}</xsl:attribute>
								<xsl:attribute name="style">background-color:{{bgColour}};color:{{colour}}</xsl:attribute>
								<span class="app-circle ">
									<xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>
									{{this.apps.length}}
								</span>
								<span class="toggle-circle">
									<xsl:attribute name="eascapid">{{id}}</xsl:attribute>
									<i class="fa fa-fw fa-caret-down"></i>
								</span>
								<span class="cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
							 	{{#getApps this}}{{this}}{{/getApps}} 
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
							<i class="fa fa-bullseye busCapFocus"></i> 
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
							{{#getApps this}}{{/getApps}} 
								{{> l2CapTemplate}} 	
								{{#if this.childrenCaps}}
								<div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
								{{else}}
								<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
								{{/if}}
								<!--	 
							<span class="inscope-icon"><xsl:attribute name="easidscope">{{id}}</xsl:attribute><i class="fa fa-bookmark"></i></span>
							-->
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
							<i class="fa fa-bullseye busCapFocus"></i> 
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
							{{#getApps this}}{{/getApps}} 
								{{> l3CapTemplate}}
								{{#if this.childrenCaps}}
								<div class="goalbox goalboxtop">{{#setGoals this}}{{/setGoals}}</div>	
								{{else}}
								<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
								{{/if}}
							<!--
							<span class="inscope-icon"><xsl:attribute name="easidscope">{{id}}</xsl:attribute><i class="fa fa-bookmark"></i></span> 	 
							-->
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
							<i class="fa fa-bullseye busCapFocus"></i> 
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>	
							{{#getApps this}}{{/getApps}} 				 
								{{> l4CapTemplate}} 	
							<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>		
							<!--
							<span class="inscope-icon"><xsl:attribute name="easidscope">{{id}}</xsl:attribute><i class="fa fa-bookmark"></i></span> 
							-->
						</div>
						{{/each}}
					</div>	
				</script>

				<script id="model-l4cap-template" type="text/x-handlebars-template">
					<div class="l4-caps-wrapper caplevel "><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute>
					{{#each this.childrenCaps}}
					<div class="l4-cap bg-lightblue-80 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
						<span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
						<i class="fa fa-bullseye busCapFocus"></i>
						<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>
						<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
						<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
						{{#getApps this}}{{/getApps}} 		
							{{> l5CapTemplate}}
							<div class="goalbox">{{#setGoals this}}{{/setGoals}}</div>	
							<!--	
							<span class="inscope-icon"><xsl:attribute name="easidscope">{{id}}</xsl:attribute><i class="fa fa-bookmark"></i></span>	 
							-->
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
							<i class="fa fa-bullseye busCapFocus"></i>
							<span class="app-circle "><xsl:attribute name="easidscore">{{id}}</xsl:attribute><xsl:attribute name="style">{{#getColour this.apps.length}}{{/getColour}}</xsl:attribute>{{this.apps.length}}</span>	
							<span class="proj-circle "><xsl:attribute name="easidproj">{{id}}</xsl:attribute>{{#getProjects this}}{{/getProjects}}</span>
							<span class="compare-circle "><xsl:attribute name="easidcompare">{{id}}</xsl:attribute></span>
							{{#getApps this}}{{/getApps}} 
							<div class="l5-caps-wrapper caplevel"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="level">{{#getLevel this.level}}{{/getLevel}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
									{{> l5CapTemplate}}
								<div class="goalbox ">{{#setGoals this}}{{/setGoals}}</div>	
								<!--
								<span class="inscope-icon"><xsl:attribute name="easidscope">{{id}}</xsl:attribute><i class="fa fa-bookmark"></i></span>
								-->
								</div>	
						</div>
						{{/each}}
					</div>	
				</script>
				<script id="blob-template" type="text/x-handlebars-template">
					<div class="blobBoxTitle right-10"> 
						<strong><xsl:value-of select="eas:i18n('Show to Level')"/>:</strong>
					</div> 
					{{#each this}}
					<div class="blobBox">
						<div class="blobNum">{{this.level}}</div>
					  	<div class="blob"><xsl:attribute name="id">{{this.level}}</xsl:attribute></div>
					</div>
					{{/each}}
					<div class="blobBox">
					 
						<div class="blobNum"> 
						<!--  hover over to say that blobs are clickable to chnage level
							<i class="fa fa-info-circle levelinfo " style="font-size:10pt"> 
							</i>
						-->	 
						</div>
				
					</div>
				</script>
				<script id="goalList-template" type="text/x-handlebars-template">
					{{#each this}} 
						<div class="goalBlock">
						<h4><i class="fa fa-bullseye" style="color:#4da44d"></i><xsl:text> </xsl:text>{{name}}</h4>
					 
						 {{#each this.thisObj}}
						 
							<i class="fa fa-tag" style="padding-left:10px;color:#448ac6"></i><xsl:text> </xsl:text>	{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}<br/>
						
							{{/each}}
						</div>  
					{{/each}}
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
										<div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{capsList.length}} <xsl:value-of select="eas:i18n('Supported Business Capabilities')"/></div>
										<div class="left-5 bottom-5"><i class="fa fa-users right-5"></i>{{orgUserIds.length}} <xsl:value-of select="eas:i18n('Supported Organisations')"/></div>
										<div class="left-5 bottom-5"><i class="fa essicon-boxesdiagonal right-5"></i>{{processList.length}} <xsl:value-of select="eas:i18n('Supported Processes')"/></div>
										<div class="left-5 bottom-5"><i class="fa essicon-radialdots right-5"></i>{{services.length}} <xsl:value-of select="eas:i18n('Services Used')"/></div>
									</div>

										<button class="btn btn-default btn-xs appInfoButton pull-right"><xsl:attribute name="easid">{{id}}</xsl:attribute><xsl:value-of select="eas:i18n('Show Details')"/></button>
									
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
									<thead><tr><th width="33%"><xsl:value-of select="eas:i18n('Application')"/></th><th width="33%">	{{this.left}}</th><th width="33%">{{this.right}}</th></tr></thead>
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
								<li class="active"><a data-toggle="tab" href="#summary"><xsl:value-of select="eas:i18n('Summary')"/></a></li>
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
						<div><xsl:attribute name="class">appIncapBoxWrapperL0 appL{{this.level}}</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}
							{{> appMiniTemplate}}</div>
						{{else}}
						<div><xsl:attribute name="class">appIncapBoxWrapper appL{{this.level}}</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}
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
					<h3><i class="fa fa-calendar"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Projects')"/></h3>
					<ul>
					{{#each this.projects}}
					<div class="appBox"> 
							<xsl:attribute name="easid">{{id}}-{{this.name}}</xsl:attribute>
							<div class="appBoxSummary">
								<div class="projectBoxTitle pull-left strong">
									<xsl:attribute name="title">{{this.name}}</xsl:attribute>
									<i class="fa fa-caret-right fa-fw right-5 text-white" onclick="toggleMiniPanel(this)"/>{{#essRenderInstanceMenuLinkLight this}}{{/essRenderInstanceMenuLinkLight}}
								</div>
							</div>
							<div class="clearfix"/>
							<div class="mini-details">
								<div class="small pull-left text-white">
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Proposed Start Date: {{plannedStartDate}}</div>
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Actual Start Date: {{actualStartDate}}</div>
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Target End Date: {{plannedEndDate}}</div>
									<div class="left-5 bottom-5"><i class="fa fa-calendar right-5"></i>Forecast End Date: {{forecastEndDate}}</div>
									 
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
				<script id="recipe-template" type="text/x-handlebars-template">
					<div class="col-xs-11"> 
					<br/>
					<p>Capabilities supporting this selection:</p>
					{{#if this}}
						{{#ifEquals this.className 'Business_Goal'}}
							{{#each this.contributions}}
								<h5><span><xsl:attribute name="class">label label-info shade{{incrementIndex @index}}</xsl:attribute>{{this.name}}</span></h5>
								{{#each this.fullcaps}}
									<i class="fa fa-circle"></i><xsl:text> </xsl:text>{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnlyLight}}<br/>
								{{/each}}
							{{/each}}
						{{else}}
						{{#each this}}
						<i class="fa fa-circle"></i><xsl:text> </xsl:text>{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnlyLight}}<br/>
						{{/each}}
						{{/ifEquals}}
					{{else}}
						No Capabilities mapped to goals
					{{/if}}
					</div>
					<!-- <div class="col-xs-1">
						<div class="text-right">
							<i class="fa fa-times closePanelButton left-30"></i>
						</div>
					</div> -->
					
				</script>

				<script id="goal-template" type="text/x-handlebars-template">
					<div class="col-xs-11">
					<h3>{{this.name}}</h3>
					{{#if this.objectives}}
					<p>Objectives supporting this goal:</p>
					{{#each this.objectives}}
					<i class="fa fa-circle"></i><xsl:text> </xsl:text>{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Objective'}}{{/essRenderInstanceLinkMenuOnlyLight}}<br/>
					{{/each}}
					{{else}}
						No Objectives mapped
					{{/if}}
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
							<xsl:attribute name="goalid">{{this.id}}</xsl:attribute>
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
	<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
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
<xsl:variable name="paramValue" select="$theReport/own_slot_value[slot_reference='report_supporting_config']/value"/> 
		let reportParams= <xsl:choose><xsl:when test="string-length($paramValue) > 0"><xsl:value-of select="$paramValue"/></xsl:when><xsl:otherwise><xsl:text>''</xsl:text></xsl:otherwise></xsl:choose>
		$('#goalsCatBox').hide();
console.log(reportParams)
		var repoSetting;

		if(reportParams.default=='herm'){
			repoSetting=2
		}else if(reportParams.default=='bricks'){
			repoSetting=1;

			$('.hermRadio').hide()
		}else{
			repoSetting=0;
	
			$('.hermRadio').hide()
		}
		//set report title, this is based on the report label, IMPORTANT: do not chnage the report name, only the label
		const queryString = window.location.search;
		const urlParams = new URLSearchParams(queryString);
		const repTitle = urlParams.get('LABEL')
		var instance2planArray, capInstanceMap, projectsArray;
		var showHideCaps=[];
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
		<xsl:variable name="rootBusCap" select="key('busCapsKey', $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value)"></xsl:variable>
		<xsl:variable name="L0BusCaps" select="key('busCapsKey' , $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value)"></xsl:variable>
		let busCapStyles=[<xsl:apply-templates select="$L0BusCaps" mode="capStyles"/>]	
   
		let filtersNo=[<xsl:call-template name="GetReportFilterExcludedSlots"><xsl:with-param name="theReport" select="$theReport"></xsl:with-param></xsl:call-template>];
		var busGoals=[<xsl:apply-templates select="$busGoals" mode="busGoals"/> ]; 
	
		busGoals.forEach((b)=>{
			let capsImpactList=[];
			const consolidated = {};
			b.contributions.forEach(contribution => {
				if (!consolidated[contribution.id]) {
					consolidated[contribution.id] = {
						id: contribution.id,
						name: contribution.name,
						className:'Business_Goal',
						relatedCaps: []
					};
				}
				consolidated[contribution.id].relatedCaps = consolidated[contribution.id].relatedCaps.concat(contribution.relatedCaps);
				capsImpactList=[...capsImpactList, ...consolidated[contribution.id].relatedCaps] 
			});
		 let uniqueData = [...b.capsImpacted, ...capsImpactList]
		 b.capsImpacted= [...new Set(uniqueData)]
		 b.contributions= Object.values(consolidated);		 
		});
	

	
	
		var goalCategories = [<xsl:apply-templates select="$goalCategories" mode="goalCategories"/> ];
		var capProjects=[<xsl:apply-templates select="$busCaps" mode="capChanges"/>]
		var panelLeft=$('#appSidenav').position().left;

		if(goalCategories.length&gt;0){
			 
			$('#goalsCatBox').show();
				$.each(goalCategories, function(index, item) {
					$('#goalsCategory').append($('<option></option>').val(item.id).text(item.name));
				}); 

				$('#goalsCategory').select2({width:'250px'})
			}
		//create select box for goals/recipes

		busGoals.sort(function(a, b) {
			return a.name.localeCompare(b.name);
		}); 
		$('#recipeListSelect').append($('<option></option>'))
		$.each(busGoals, function(index, item) {
			$('#recipeListSelect').append($('<option></option>').val(item.id).text(item.name));
		});

		$('#recipeListSelect').select2({width:'250px',   
			placeholder: "Select an option" })
  
 

	  function createMaps(data) {
		let capToObjMap = new Map();
		let businessGoalsMap = new Map();
	
		data.forEach(goal => {
	
			// Update businessGoalsMap
			let objectivesArray = goal.objectives.map(obj => ({ name: obj.name, id: obj.id, caps: obj.caps }));
			businessGoalsMap.set(goal.name, objectivesArray);
	
			// Update capToObjMap
			goal.objectives.forEach(objective => {
				objective.caps.forEach(cap => {
					let currentCap = cap.id;
					let objectiveKey = `${objective.id}-${objective.name}`;
	
					if (!capToObjMap.has(currentCap)) {
						capToObjMap.set(currentCap, new Map());
					}
	
					let objectivesMap = capToObjMap.get(currentCap);
					if (!objectivesMap.has(objectiveKey)) {
						objectivesMap.set(objectiveKey, {
							objectiveId: objective.id,
							objectiveName: objective.name,
							className:'Business_Objective'
						});
					}
				});
			});
		});
	
		// Convert inner Maps back to Arrays for capToObjMap
		for (let [cap, objectivesMap] of capToObjMap) {
			capToObjMap.set(cap, Array.from(objectivesMap.values()));
		}
	
		return { capToObjMap, businessGoalsMap };
	}
	
	// Usage
 
	let { capToObjMap, businessGoalsMap } = createMaps(busGoals);
 
	// Logging the maps to see the results

	
		let styleSetting = localStorage.getItem('busCapConfig') || repoSetting;
		 
		var level=0;
		var rationalisationList=[];
		let levelArr=[];
		let workingCapId=0;
		var partialTemplate, l0capFragment;
		showEditorSpinner('Fetching Data...');
		var dynamicAppFilterDefs=[];	
		var dynamicCapFilterDefs=[];
		var idToAppsCountMap;
		var appsToShow=[]; 

		$('document').ready(function ()
		{ 
				// Store the initial top position of the handle
				var initialHandleTop = $('.handle').css('top');
				$('#clr').hide();
				$('.handle').click(function() {
					var panelHeight = $('#optionsBox').height();
				
					if (panelHeight > 0) {
						// If the panel is open, close it to 0px and move the handle back to its initial position
						$('#optionsBox').animate({ height: '0' }, 500);
						$('.handle').animate({ top: initialHandleTop }, 500);
						$('.optionsPanel').css({'border-width': '0px', 'padding': '0'});
					} else {
						// Calculate the new top position for the handle
						var newTopPosition = 91; // This is the height of the opened optionsBox
				
						// If the panel is closed, open it to 85px and move the handle at the same time
						$('#optionsBox').animate({ height: '70px' }, 500);
						$('.handle').animate({ top: newTopPosition + 'px' }, 500);
						$('.optionsPanel').css({'border-width': '1px', 'padding': '10px'});
					}
					var icon = $(this).find('i'); 
						if (icon.hasClass('fa-arrow-circle-down')) {
							icon.removeClass('fa-arrow-circle-down').addClass('fa-arrow-circle-up');
						} else {
							icon.removeClass('fa-arrow-circle-up').addClass('fa-arrow-circle-down');
						}
					
				});
				$('.handle2').click(function(){
					var panelWidth = $('#infoSidepanel').width();
					if (panelWidth > 0) {
						// If the panel is open (width > 0), close it
						$('#infoSidepanel').css('position', '0');
						$('#infoSidepanel').css('right', '-300px');
						$('.handle2').css('top', '30%');
					} else {
						// If the panel is closed (width = 0), open it
						$('#infoSidepanel').css('width', '250px');
						$('#infoSidepanel').css('right', '0px');
						$('.handle2').css('top', '10px');
					}
					var icon = $(this).find('i'); 
					if (icon.hasClass('fa-file-text-o')) {
						icon.removeClass('fa-file-text-o').addClass('fa-times');
					} else {
						icon.removeClass('fa-times').addClass('fa-file-text-o');
					}
				});
			
			

			$('#scopeOn').hide(); 

            //herm BCM
			hermFragment = $("#herm-model-template").html();
			hermTemplate = Handlebars.compile(hermFragment);

            capsFragment = $("#caps-template").html();
			capsTemplate = Handlebars.compile(capsFragment);

			divsFragment = $("#divs-template").html();
			divsTemplate = Handlebars.compile(divsFragment);

            //general BCM

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

			goalListFragment = $("#goalList-template").html();
			goalsListTemplate = Handlebars.compile(goalListFragment);
			

			goalKeyFragment = $("#goalKey-template").html();
			goalKeyTemplate = Handlebars.compile(goalKeyFragment);

			goalFragment = $("#goal-template").html();
			goalTemplate = Handlebars.compile(goalFragment);
			 
			recipeFragment = $("#recipe-template").html();
			recipeTemplate = Handlebars.compile(recipeFragment);
		 
			projectFragment = $("#project-template").html();
			projectTemplate = Handlebars.compile(projectFragment);

			appScoreFragment = $("#appScore-template").html();
			appScoreTemplate = Handlebars.compile(appScoreFragment);

			infoConceptFragment = $("#infoConcept-template").html();
			infoConceptTemplate = Handlebars.compile(infoConceptFragment);

			Handlebars.registerHelper('getLevel', function(arg1) {
				return parseInt(arg1) + 1; 
			});

			Handlebars.registerHelper('incrementIndex', function(value) {
				return parseInt(value) + 1;
			});

			Handlebars.registerHelper('getAppCircStyle', function(arg1) {
				 
			});

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
			
			Handlebars.registerHelper('getWidth', function(sclen) {
				 
				return (100/sclen.length)-2;
			});

			Handlebars.registerHelper('getProjects', function(bc) {
			 
				let thisProjArr = projectsArray?.filter(project => matchedBuscapAndPlanIds[bc.id]?.includes(project.id));
		 
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
					if(bg.capsList.includes(gls.id) || bg.capsImpacted.includes(gls.id)){
						divData=divData+'<div class="goalpill" data-toggle="tooltip" title="'+bg.name+'"  style="background-color:'+bg.goalColour+'"><xsl:attribute name="goalCapId">'+gls.id+'</xsl:attribute></div>';
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
		 
				if(thisApps.length&gt;0){
					thisApps[0].infoConcepts?.forEach((inf)=>{ 
						
						appHtml=appHtml+infoConceptTemplate(inf);
					}) 
					return appHtml;
				}
			});

			Handlebars.registerHelper('getCompareApps', function(alist) {
 
			});
			
			Handlebars.registerHelper('getColour', function(arg1) {
			 
				let colour='#fff';
				let textColour='#000';
				if(parseInt(arg1) ==0 ){colour='#d3d3d3'}
				else if(parseInt(arg1) &lt;2){colour='#EDBB99';textColour='#000000'}
				else if(parseInt(arg1) &lt;6){colour='#BA4A00';textColour='#ffffff'}
				else if(parseInt(arg1) &gt;5){colour='#6E2C00';textColour='#ffffff'} 
			 
				return 'background-color:'+colour+';color:'+textColour; 
			});
<!--
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
		-->
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
		
	}else{
		$('.handle2').hide();
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


	function setViewOptions(thisId){
	 
		var $appCircle = $('.app-circle');
		var $projCircle = $('.proj-circle');
		var $compareCircle = $('.compare-circle');
		var $keyHolder = $('#keyHolder');
		var $comparePanel = $('#comparePanel');
		var $goalbox = $('.goalbox');
		var $dataBox = $('.dataBox');

		$appCircle.hide();  
		$projCircle.hide();
		$compareCircle.hide();
		$keyHolder.slideUp();
		$comparePanel.slideUp();
		$goalbox.hide();
		$('.appusage').hide()
		$dataBox.removeClass('infoConceptBox').addClass('infoConceptBoxHide');

		if (thisId == 'apps') {
			$appCircle.show();

			$('.buscap').addClass("off-cap")
		  	inScopeCapsApp.forEach((e)=>{
			  $('*[easidscore="' + e.id + '"]').parent().removeClass("off-cap")
		  	})
			$('.appusage').show()
		} else if (thisId == 'goals') {
			$('.buscap').removeClass("off-cap")
			$projCircle.show();
			$keyHolder.slideDown();
			$goalbox.show();
		 
		} else if (thisId == 'compare') {
			$('.buscap').removeClass("off-cap")
			$compareCircle.show();
			$comparePanel.slideDown();
		} else if (thisId == 'data') {
			$('.buscap').removeClass("off-cap")
			$dataBox.addClass('infoConceptBox').removeClass('infoConceptBoxHide');
			$('.info-circle').css('display', 'block'); // Only used in this case, so not cached
		}
	}




	$('#viewOption').on('change', function() {
		var thisId = $(this).val(); 
		setViewOptions(thisId);
	});

   
			$('.appPanel').hide();
			var appArray;
			var workingArrayCaps, workingArrayBusCapHierarchy;
			var workingArrayAppsCaps;
			var appToCap=[];
			var processMap=[]; 
			let svsArray=[];
			var scores=[];
			var relevantOrgData=[]; 
			const buscapToAllIdsMap = {};
			var matchedBuscapAndPlanIds = [];
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
				workingArrayBusCapHierarchy=workingArray.busCapHierarchy
 
				$('#subrootcap').append('<option value='All'>All</option>')
				workingArrayBusCapHierarchy.forEach((c)=>{
				 	$('#subrootcap').append('<option value="'+c.id+'">'+c.name+'</option>')
				})
				$('#subrootcap').select2();
				svsArray = responses[3]
				//meta = responses[1].meta; 
			 
				//meta.push({"classes":["Project"],"menuId":"projGenMenu"})
				 
                function getHermModel(){
                    $('#subroot').hide();
					$('#recipeTitle').text('Recipe')
                                    $('#capModelHolder').html(hermTemplate())
    
                                    workingArray.busCapHierarchy.forEach((e)=>{
                                     
                                            e.childrenCaps.forEach((d)=>{
                                                if(d.name=='Curriculum Management'){
                                                    $('#designBox').html(capsTemplate(d))
                                                }else if(d.name=='Student Recruitment'){
                                                    $('#recruit').html(divsTemplate(d))
                                                }else if(d.name=='Student Admission'){
                                                    $('#recruit').append(divsTemplate(d))
                                                }else if(d.name=='Student Enrolment'){
                                                    $('#enroll').html(capsTemplate(d))
                                                }else if(d.name=='Curriculum Delivery'){
                                                    $('#deliver').html(capsTemplate(d))
                                                }else if(d.name=='Student Assessment'){
                                                    $('#assess').html(capsTemplate(d))
                                                }else if(d.name=='Completion Management'){
                                                    $('#confer').html(capsTemplate(d))
                                                }else if(d.name=='Student Management'){
                                                    $('#studentManage').html(capsTemplate(d))
                                                }else if(d.name=='Student Support'){
                                                    $('#studentSupport').html(capsTemplate(d))
                                                }else if(d.name=='Research Opportunities &amp; Planning'){
                                                    d['width']=2
                                                    $('#planBox').html(capsTemplate(d))
                                                }else if(d.name=='Research Funding'){
                                                    $('#fundBox').html(capsTemplate(d))
                                                }else if(d.name=='Research Assurance'){
                                                    d['width']=2
                                                    $('#assureBox').html(capsTemplate(d))
                                                }else if(d.name=='Research Management'){
                                                    $('#conductBox').html(capsTemplate(d))
                                                }else if(d.name=='Research Delivery'){
                                                    d['width']=2
                                                    $('#conductBox2').append(capsTemplate(d))
                                                }else if(d.name=='Research Dissemination'){
                                                    d['width']=2
                                                    $('#disseminate').html(capsTemplate(d))
                                                }
                                                else if(d.name=='Strategy Management'){
                                                    d['width']=1
                                                    $('#strategymgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Business Capability Management'){
                                                    d['width']=5
                                                    $('#bcmmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Governance, Risk, &amp; Compliance'){
                                                    d['width']=5
                                                    $('#grcmgmt').html(capsTemplate(d))		
                                                } 
                                                else if(d.name=='Library Administration'){
                                                    d['width']=1
                                                    $('#librarymgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Advancement Management'){
                                                    d['width']=2
                                                    $('#advancemgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Marketing Management'){
                                                    d['width']=3
                                                    $('#mktgmmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Engagement &amp; Relationship Management'){
                                                    d['width']=3
                                                    $('#engagementmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Legal Services'){
                                                    d['width']=2
                                                    $('#legalmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Information &amp; Communication Technology Management'){
                                                    d['width']=2
                                                    $('#itmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Human Resource Management'){
                                                    d['width']=5
                                                    $('#hremgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Financial Management'){
                                                    d['width']=7
                                                    $('#financemmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Information Management'){
                                                    d['width']=4
                                                    $('#infomgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Facilities &amp; Estate Management'){
                                                    d['width']=3
                                                    $('#facilitiesmmgmt').html(capsTemplate(d))
                                                } 
                                                else if(d.name=='Supporting Services'){
                                                    d['width']=5
                                                    $('#supportingmmgmt').html(capsTemplate(d))
                                                } 
                                                    
                                            })
                                       })

					$(`.goalpill`).addClass(`goalpillsmall`);
                }
			
			 
				workingArray.busCaptoAppDetails.forEach((data)=>{
				
					// Extracting the buscap id
					const buscapId = data.id;
					
					// Combining all IDs into a single list
					buscapToAllIdsMap[buscapId] = [
						...data.allProcesses.map(process => process.id), // IDs from allProcesses
						...data.physP, // IDs from physP
						...data.apps, // IDs from apps
						...data.orgUserIds, // IDs from orgUserIds
						...data.geoIds, // IDs from geoIds
						...(data.infoConcepts.map(info => info.id) || []), // IDs from infoConcepts, with a fallback to an empty array
						...data.domainIds // IDs from domainIds
					];
				})  

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
					e.objectives?.forEach((c)=>{
						c.caps.forEach((sc)=>{
							capsList=[...capsList, sc.id]
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
			$(document).on('click','.closePanelButton', function(){ 
				event.stopPropagation(); // Prevents the event from bubbling up the DOM tree
				event.preventDefault(); 
				$('.appPanel').hide();
			})
		 })


				workingArray.busCapHierarchy.forEach((d)=>{
					let styleMatch=busCapStyles.find((e)=>{
						return d.id ==e.id
					})
					if(styleMatch){
						d['bgColour']=styleMatch.backgroundColour
						d['colour']=styleMatch.colour
					}	

			 
					let capArr=responses[2].businessCapabilities?.find((e)=>{
						return e.id==d.id;
					}); 
					if(capArr){
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
						if(matchApp){
							appOrgs=[...appOrgs, ...matchApp.orgUserIds];
						}
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
		 
						if(thisLevel==1){
							$('.toggle-circle').hide()
						}else{
							$('.toggle-circle').show()
						}
					//	setScoreApps()
 
						$.each(showHideCaps, function(index, eascapid) {
							// Hide the children of the div with the current eascapid
							$('#' + eascapid).find('div.l1-caps-wrapper:first').hide();
							$('#' + eascapid).find('div.l1-caps-wrapperOld:first').hide();
						});
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
					if(bc.infoConcepts.length&gt;1){
                        showInfo=1;
                    }
					let capArr=responses[2].businessCapabilities?.find((e)=>{
						return e.id==bc.id;
					}); 
					if(capArr){
					bc["order"]=parseInt(capArr.sequenceNumber);
					}
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
					resolve();
					//resolve($('#capModelHolder').html(l0CapTemplate(workingArray.busCapHierarchy)));
					reject();
			   })
			    
			   capMod.then((d)=>{
 
				//workingArray=[];
				<!-- filters=[...capfilters, ...filters];
				console.log('filters', filters)
				essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], filters, capfilters); -->
				let allFilters=[...capfilters, ...filters];

            
                    $('.radio-group input[type="radio"]').change(function() {
                        
                      if(this.id === "bars") {
                        localStorage.setItem('busCapConfig', 0);
                        $('#subroot').show();
                        $('#capModelHolder').html(l0CapTemplate(workingArrayBusCapHierarchy))
                        getStyle(0) 
                          } 
                      else if(this.id === "brick") {
                        localStorage.setItem('busCapConfig', 1);
                        $('#subroot').show();
                        $('#capModelHolder').html(l0CapTemplate(workingArrayBusCapHierarchy))
                        getStyle(1) 
                      } 
                      else if(this.id === "herm") {
                        localStorage.setItem('busCapConfig', 2);
                        getHermModel()
                        
                           
                      }
                      registerEvents()
                      redrawView()
                    });
                 

                $('#config').click(function(){
				
                   
					localStorage.setItem('busCapConfig', styleSetting);
                    getStyle(styleSetting)
                    }) 

                
                $('#herm').click(function(){
                    $('#capModelHolder').html(hermTemplate()) 

                    workingArray.busCapHierarchy.forEach((e)=>{
                      
                            e.childrenCaps.forEach((d)=>{
                                if(d.name=='Curriculum Management'){
                                    $('#designBox').html(capsTemplate(d))
                                }else if(d.name=='Student Recruitment'){
                                    $('#recruit').html(divsTemplate(d))
                                }else if(d.name=='Student Admission'){
                                    $('#recruit').append(divsTemplate(d))
                                }else if(d.name=='Student Enrolment'){
                                    $('#enroll').html(capsTemplate(d))
                                }else if(d.name=='Curriculum Delivery'){
                                    $('#deliver').html(capsTemplate(d))
                                }else if(d.name=='Student Assessment'){
                                    $('#assess').html(capsTemplate(d))
                                }else if(d.name=='Completion Management'){
                                    $('#confer').html(capsTemplate(d))
                                }else if(d.name=='Student Management'){
                                    $('#studentManage').html(capsTemplate(d))
                                }else if(d.name=='Student Support'){
                                    $('#studentSupport').html(capsTemplate(d))
                                }else if(d.name=='Research Opportunities &amp; Planning'){
                                    d['width']=2
                                    $('#planBox').html(capsTemplate(d))
                                }else if(d.name=='Research Funding'){
                                    $('#fundBox').html(capsTemplate(d))
                                }else if(d.name=='Research Assurance'){
                                    d['width']=2
                                    $('#assureBox').html(capsTemplate(d))
                                }else if(d.name=='Research Management'){
                                    $('#conductBox').html(capsTemplate(d))
                                }else if(d.name=='Research Delivery'){
                                    d['width']=2
                                    $('#conductBox2').append(capsTemplate(d))
                                }else if(d.name=='Research Dissemination'){
                                    d['width']=2
                                    $('#disseminate').html(capsTemplate(d))
                                }
                                else if(d.name=='Strategy Management'){
                                    d['width']=1
                                    $('#strategymgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Business Capability Management'){
                                    d['width']=5
                                    $('#bcmmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Governance, Risk, &amp; Compliance'){
                                    d['width']=5
                                    $('#grcmgmt').html(capsTemplate(d))		
                                } 
                                else if(d.name=='Library Administration'){
                                    d['width']=1
                                    $('#librarymgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Advancement Management'){
                                    d['width']=2
                                    $('#advancemgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Marketing Management'){
                                    d['width']=3
                                    $('#mktgmmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Engagement &amp; Relationship Management'){
                                    d['width']=3
                                    $('#engagementmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Legal Services'){
                                    d['width']=2
                                    $('#legalmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Information &amp; Communication Technology Management'){
                                    d['width']=2
                                    $('#itmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Human Resource Management'){
                                    d['width']=5
                                    $('#hremgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Financial Management'){
                                    d['width']=7
                                    $('#financemmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Information Management'){
                                    d['width']=4
                                    $('#infomgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Facilities &amp; Estate Management'){
                                    d['width']=3
                                    $('#facilitiesmmgmt').html(capsTemplate(d))
                                } 
                                else if(d.name=='Supporting Services'){
                                    d['width']=5
                                    $('#supportingmmgmt').html(capsTemplate(d))
                                } 
                                     
                                    
    
                                  
                            })
                       })
                       registerEvents()
                    }) 
			
                getStyle(styleSetting)

          function getStyle(styleSet){      
				var firstOptionValue = $('#recipeListSelect option:first').val();
				$('#recipeListSelect').val(firstOptionValue).trigger('change');
				$('#recipeList').empty();
	
				if (styleSet == 0) {
					$('#capModelHolder').html(l0CapTemplate(workingArray.busCapHierarchy))
				
                    $('#bars').prop('checked', true)
					for (let i = 0; i &lt;= 5; i++) {
						$(`.l${i}-cap`).addClass(`l${i}-capOld`);
						$(`.l${i}-caps-wrapper`).addClass(`l${i}-caps-wrapperOld`);
					}
					
				} else if (styleSet == 1) {
					$('#capModelHolder').html(l0CapTemplate(workingArray.busCapHierarchy))
				
                    $('#brick').prop('checked', true)
					for (let i = 0; i &lt;= 5; i++) {
						$(`.l${i}-cap`).removeClass(`l${i}-capOld`);
						$(`.l${i}-caps-wrapper`).removeClass(`l${i}-caps-wrapperOld`);
					}
					 
				} else {
				
                    $('#herm').prop('checked', true)
                    getHermModel()

				}
			
            }
			
    if (styleSetting !== '2') {
 
      
		 
		var spanElement = document.getElementById('recipeTitle');
		if (spanElement) {
			spanElement.textContent = 'Goal';
		}  

		$(`.goalpill`).removeClass(`goalpillsmall`);
    }else{
        
        $('#herm').prop('checked', true)
        getHermModel();
    }
    
                
				essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], allFilters, true);
			   });

			  
			   removeEditorSpinner()
			   $('.appIncapBoxWrapperL0').hide();
			   $('.appIncapBoxWrapper').hide();
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

const appTypeInfo = {
	"className": "Application_Provider",
	"label": 'Application',
	"icon": 'fa-desktop'
}
const busCapTypeInfo = {
	"className": "Business_Capability",
	"label": 'Business Capability',
	"icon": 'fa-landmark'
}


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


function registerEvents(){
  
	$('.busCapFocus').off().on('click', function(event) { 

		// Prevent event bubbling
		event.stopPropagation();

		// Hide all divs
		$('.buscap').hide();
		//$('.value-chain-wrapper').hide();

		// Show the clicked div and its children
		$(this).closest('.buscap').show();
		//$(this).closest('.value-chain-wrapper').show();

		// Traverse and show all parent divs
		$(this).parents('.buscap,.value-chain-wrapper').show();
		$(this).closest('.buscap').find('*').show();
		//$(this).closest('.value-chain-wrapper').find('*').show();

		let voId=$('#viewOption').val()
			setViewOptions(voId)


		if ($(this).find('.reset-btn').length === 0) {
			$(this).parent().append('<button class="btn reset-btn btn-xs">Reset</button>');

			$('.reset-btn').off().on('click', function(event) {
				event.stopPropagation();
				event.preventDefault();
		
			//	$('.buscap').show();
				$('.reset-btn').remove(); // Remove all reset buttons
				redrawView();
			});
		}
	});

	function filterGoalsByCapId(goals, capId) {
 
		goals.forEach(goal => {
			const matchedObjectives = new Set();
			
			// Iterate through each objective of the goal.
			goal.objectives.forEach(objective => {
				// Check if any cap or childCap in the objective matches the capId.
				objective.caps.forEach(cap => {
					if (cap.id === capId || (cap.childCaps.some(childCap => childCap.id === capId))) {
						matchedObjectives.add(objective);
					}
				});
			});
	
			// Convert the Set back to an array and attach to the goal.
			goal.thisObj = Array.from(matchedObjectives);
		});
	}
	

	$('.goalpill').on('click', function(){
		let goalId=$(this).attr('goalCapId');

		let thisGoals=[];
		busGoals.forEach((bg)=>{  
			if(bg.capsList.includes(goalId) || bg.capsImpacted.includes(goalId)){
				thisGoals.push(bg)
			}
		})

		let list=filterGoalsByCapId(thisGoals, goalId);
 		<!--
		let thisCap=capToObjMap.get(goalId);
 
		let matchingGoals = [];
		thisCap.forEach((o)=>{
			o.id=o.objectiveId;
			o.name=o.objectiveName;
			o.className='Business_Objective';
			businessGoalsMap.forEach((objectives, goalName) => {
				objectives.forEach(objective => {
					if (objective.id === o.objectiveId) {
						o['goal']=goalName;
					}
				});
			});
		})

		let groupedByGoal = {};

		thisCap.forEach(item => {
			let goal = item.goal;
	
			if (!groupedByGoal[goal]) {
				groupedByGoal[goal] = [{"name": goal, objectives:[]}];
			}
		
			groupedByGoal[goal][0].objectives.push({
				objectiveId: item.objectiveId,
				objectiveName: item.objectiveName,
				id: item.id,
				className:'Business_Objective',
				name: item.name
			});
		});-->
	console.log('thisGoals', thisGoals)
		$('#appsList').html(goalsListTemplate(thisGoals))
		$('.appRatButton').hide(); 
		openNav(); 
			
	 })
 
	$('.proj-circle').on("click", function ()
	 {  
		let projCap=$(this).attr('easidproj');
		
		let focusCap=capProjects.find((e)=>{
			return e.id==projCap;
		})
 
		let thisProjArr=[]
		thisProjArr = projectsArray?.filter(project => matchedBuscapAndPlanIds[focusCap.id].includes(project.id));
		
		for (let i = 0; i &lt; thisProjArr.length; i++) {
			thisProjArr[i].className = "Project";
		}
		 
		focusCap.projects=thisProjArr;
		if(workingCapId!=projCap){ 
			$('.appRatButton').hide();
			$('#appsList').html(projectTemplate(focusCap))
			openNav(); 
			workingCapId=projCap;
		}
		else{
			closeNav();
		}
		return false; //stop propogation	
	});

	$('.app-circle').on("click", function (d)
	 { d.stopImmediatePropagation(); 
        console.log('click app crcl')
		$('.appPanel').hide();
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

	$('#recipeListSelect').on('change',function(){
		$('#clr').show();
		$('.buscap').removeClass('capColour');
		$('.capBox').removeClass('capColour');
		let selected=busGoals.find((b)=>{
			return b.id==$(this).val();
		})
 
		if(selected){
			// Combine capsImpacted and capsList into a single Set to avoid redundant processing
			let combinedCaps = new Set([...(selected?.capsImpacted || []), ...(selected?.capsList || [])]);
			
			// Add 'capColour' class to elements for all combined caps
			combinedCaps.forEach(e => {
			//	$(`.capBox[eascapid="${e}"]`).addClass('capColour');
			//	$(`.buscap[eascapid="${e}"]`).addClass('capColour');
			});
			
			// Filter scopedCaps.resources to get only items whose id is in the combined Set
			let filteredItems = scopedCaps.resources.filter(item => combinedCaps.has(item.id));
	
	 
			let contributionsYes=false;
		
			// Update the HTML content with the filtered items using the recipeTemplate
	

		 const capMap = filteredItems.reduce((acc, cap) => {
			acc[cap.id] = cap.name;
			return acc;
		}, {});
		console.log('selected',selected)
		selected.contributions.forEach(cont => { 
				contributionsYes=true;
				cont.fullcaps = cont.relatedCaps.map(capId => ({
				id: cont.id,
				className: 'Business_Capability',
				name: capMap[capId] || capId
			}));
		});
	
	
		if(contributionsYes == false){
			$('#recipeList').html(recipeTemplate(filteredItems));
		}
		else{
			$('#recipeList').html(recipeTemplate(selected));
			selected.contributions.forEach((d, index)=>{
				console.log(d.name)
				d.relatedCaps.forEach((c)=>{
					console.log('index',index)
					$(`.capBox[eascapid="${c}"]`).addClass('shade'+(index+1));
					$(`.buscap[eascapid="${c}"]`).addClass('shade'+(index+1));
				})
			})
		 
		}

		$('#clr').off().on('click', function(){
			$('.buscap').removeClass('capColour');
			$('.capBox').removeClass('capColour');
			$('[class*="shade"]').removeClass(function(index, className) {
                return (className.match(/shade\d+/g) || []).join(' ');
            });
		})
	}
	
	})


	$('#goalsCategory').on('change', function(){
		selected= $('#goalsCategory').val()
 
		$('.goalCard2').hide();
		$('.goalpill').hide()
		if(selected.length>0){
		selected.forEach((s) => {
		 
			let match = busGoals.filter((b) => {
				return b.categories.includes(s);
			});
			 
			
			match.forEach((m)=>{
				$('.goalCard2[goalid="'+m.id+'"]').show(); 
			})

			match.forEach((m)=>{
					m.capsImpacted.forEach((c)=>{ 
					$('.goalpill[goalcapid="'+c+'"]').show();
				})
			})

			$('#recipeListSelect').select2('destroy');
			$('#recipeListSelect').empty();
			$('#recipeListSelect').append($('<option></option>'))
			$.each(match, function(index, item) {
				$('#recipeListSelect').append($('<option></option>').val(item.id).text(item.name));
				
			});

			$('#recipeListSelect').select2({width:'250px',   
				placeholder: "Select an option" })
			})
		}else{
			$('.goalCard2').show();
			$('.goalpill').show()
			$('#recipeListSelect').select2('destroy');
			$('#recipeListSelect').empty();
			$('#recipeListSelect').append($('<option></option>'))
			$.each(busGoals, function(index, item) {
				$('#recipeListSelect').append($('<option></option>').val(item.id).text(item.name));
			});

			$('#recipeListSelect').select2({width:'250px',   
				placeholder: "Select an option" })
		 
		}

	})

}

var redrawView=function(){
  
	essResetRMChanges();

	if(!instance2planArray){
 
		projectsArray=essRMApiData.rpp?.changeActivities ? essRMApiData.rpp?.changeActivities : [];
 
		data=essRMApiData?.plans
		instance2planArray = {};
		data?.forEach(item => {
			instance2planArray[item.instId] = item.changeActivityId;
		});
	  
		const groupedCapsById = {};

Object.entries(buscapToAllIdsMap).forEach(([buscapId, idsList]) => {
    idsList.forEach(id => {
        if (id !== '' &amp;&amp; instance2planArray.hasOwnProperty(id) &amp;&amp; instance2planArray[id] !== '') {
            const planId = instance2planArray[id];

            // Initialize a Set for this buscapId if it hasn't been added yet
            if (!groupedCapsById[buscapId]) {
                groupedCapsById[buscapId] = new Set();
            }

            // Add the planId to the Set associated with buscapId
            groupedCapsById[buscapId].add(planId);
        }
    });
});

// Convert the Sets back to arrays
Object.keys(groupedCapsById).forEach(buscapId => {
    groupedCapsById[buscapId] = Array.from(groupedCapsById[buscapId]);
});

matchedBuscapAndPlanIds = groupedCapsById;

	}


	const workingMatchedBuscapAndPlanIds = { ...matchedBuscapAndPlanIds };

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
   

	scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), appTypeInfo);
	
	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef].concat(dynamicCapFilterDefs), busCapTypeInfo);

	inScopeCapsApp=scopedCaps.resources; 

	scopedCaps.resourceIds.forEach(id => {
		// Check if the id is not a key in workingMatchedBuscapAndPlanIds
		if (!workingMatchedBuscapAndPlanIds.hasOwnProperty(id)) {
			// Set the value for this id in workingMatchedBuscapAndPlanIds to an empty array
			workingMatchedBuscapAndPlanIds[id] = [];
		}
	});
	document.querySelectorAll('.proj-circle').forEach(element => {
        element.textContent = '0';
    });
 
    for (const key in matchedBuscapAndPlanIds) {
        if (matchedBuscapAndPlanIds.hasOwnProperty(key)) {
            // Find the corresponding HTML element
            const element = document.querySelector(`span.proj-circle[easidproj="${key}"]`);
            if (element) {
                // Update the element's text with the length of the array
                element.textContent = matchedBuscapAndPlanIds[key].length;
            }
        }
    }
 
	inScopeCapsApp=scopedCaps.resources;  
	

	let appMod = new Promise(function(resolve, reject) { 
	 	resolve(appsToShow['applications']=scopedApps.resources);
		 reject();
	});

	appMod.then((d)=>{
	 
		workingArrayAppsCaps.forEach((d)=>{ 
			let filteredAppsforCap = d.apps.filter((id) => scopedApps.resourceIds.includes(id));
			d['filteredApps']=	filteredAppsforCap;
			
		})

		idToAppsCountMap = new Map();
 
		workingArrayAppsCaps.forEach(function (d) {
			 
			idToAppsCountMap.set(d.id, d.filteredApps);
		});

		// idToAppsCountMap now contains the mapping of Ids to counts 
		
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
  
		if(workingArrayAppsCaps.length &gt; scopedCaps.resources.length){
			$('#scopeOn').show()
			scopedCaps.resourceIds.forEach((s)=>{
				$('[easidscope="'+s+'"]').show();
			})
		}else{
			$('.inscope-icon').hide();
			$('#scopeOn').hide();
		}

	function updateCapabilitiesWithAppCounts(capabilities, idToAppsCountMap) {
		capabilities.forEach(cap => {
			// Update the apps count if the cap id is found in the map
			if (idToAppsCountMap.has(cap.id)) {
				cap.apps = idToAppsCountMap.get(cap.id);
			}
	
			// Recursively update children capabilities, if they exist
			if (cap.childrenCaps &amp;&amp; cap.childrenCaps.length > 0) {
				updateCapabilitiesWithAppCounts(cap.childrenCaps, idToAppsCountMap);
			}
		});
	}
	
	// Example usage
	updateCapabilitiesWithAppCounts(workingArrayBusCapHierarchy, idToAppsCountMap);
	
		
	<!-- filter when root changes-->
 
	$('#subrootcap').on('change', function(){
		
		updateCapabilitiesWithAppCounts(workingArrayBusCapHierarchy, idToAppsCountMap);
		
		let selected=$(this).val(); 
		if(selected =='All'){
            
			$('#capModelHolder').html(l0CapTemplate(workingArrayBusCapHierarchy))
		}else{ 
			capsToShow=workingArrayBusCapHierarchy.find((d)=>{
			return d.id==selected;
		}) 
			$('#capModelHolder').html(l0CapTemplate([capsToShow]))
		}
	registerEvents()
	let voId=$('#viewOption').val()
	setViewOptions(voId)
	});

	let leftOrg=$('#leftOrgList').val();
	let rightOrg=$('#rightOrgList').val(); 
	let workLeft=relevantOrgData.find((e)=>{ return e.id==leftOrg})
	let workRight=relevantOrgData.find((e)=>{ return e.id==rightOrg})
	let appCount=0
  
		registerEvents()
		

			$('.toggle-circle').off().on('click', function() {
			
				// Toggle the chevron icon
				var icon = $(this).find('i');
				icon.toggleClass('fa-caret-down fa-caret-right');
		
				// Toggle the first child div of the parent element
				var contentDiv =  $(this).parent().find('div.l1-caps-wrapper:first')
		
				contentDiv.toggle();
		
				// Get the eascapid attribute
				var eascapid = $(this).attr('eascapid');
		
				// Check if the content is now visible
				if (contentDiv.is(':visible')) {
					var index = showHideCaps.indexOf(eascapid);
					if (index !== -1) {
						showHideCaps.splice(index, 1);
					}
				} else {
					// Add the eascapid to the array if it's not already there
					if ($.inArray(eascapid, showHideCaps) === -1) {
						showHideCaps.push(eascapid);
					}
					// Remove the eascapid from the array if it exists
					
				}
				 
			});
		
	  	$('.buscap').addClass("off-cap")
		  inScopeCapsApp.forEach((e)=>{
			  $('*[easidscore="' + e.id + '"]').parent().removeClass("off-cap")
		  })

		  workingArrayAppsCaps.forEach(function (d)
		{
			compareScoreA=0;
			compareScoreB=0; 
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
			$('*[eascapid="' + d.id + '"]').each(function() {
				if ($(this).hasClass('buscap')) {
					$(this).addClass('off-cap');
				}
			});
			
		}   
			else if(appCount &lt;2){colour='#EDBB99'}
			else if(appCount &lt;6){colour='#BA4A00';
			
		} 
			else{colour='#6E2C00'}
			$('*[easidscore="' + d.id + '"]').css({'background-color':colour, 'color':textColour})
		  })

<!--
		  $('.buscap').hide()
		 
		  inScopeCapsApp.forEach((d)=>{
	
			$('*[eascapid="' + d.id + '"]').show()
		  })
		  -->
		$('#capjump').prop('disabled', false);
		let capSelectStyle= $('#hideCaps').text(); 
	
	if(capSelectStyle=='Hiding'){
		localStorage.setItem("essentialhideCaps", "Hiding");

	<!-- logic, hide any apps out of scope,  hide any capabilities out of scope. -->

		$('.buscap').hide();
		inScopeCapsApp.forEach((d)=>{
			$('div[eascapid="'+d.id+'"]').parents().show();
			$('div[eascapid="'+d.id+'"]').show();
			});
		}else
		{	 
			localStorage.setItem("essentialhideCaps", "Showing");
		$('.buscap').show(); 
			
		}
	})



 
	let voId=$('#viewOption').val()
	setViewOptions(voId)

	<!--
	if($('#viewOption').val()=='apps'){
		$('.app-circle ').css('display','block')
	 	

	}else{
		$('.app-circle ').css('display','none')
	}
-->

$('.handle2').click(function(){
			var panelWidth = $('#infoSidepanel').width();
			if (panelWidth > 0) {
				// If the panel is open (width > 0), close it
				$('#infoSidepanel').css('width', '0');
				$('.handle2').css('top', '30%');
			} else {
				// If the panel is closed (width = 0), open it
				$('#infoSidepanel').css('width', '450px');
				$('.handle2').css('top', '10px');
			}
		});

}

function redrawView() {
	essRefreshScopingValues()
}
});
$('#capjump').prop('disabled', 'disabled');

$('#capjump').change(function(){
	var id = "#" + $(this).val();
  
	$('html, body').animate({
		scrollTop: $(id).offset().top -75
	}, 5000);
  });

		function getArrayDepth(arr){  
			arr.forEach((d)=>{
			levelArr.push(parseInt(d.level))	
			if(d.childrenCaps){
				getArrayDepth(d.childrenCaps);
			}

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
		<xsl:variable name="busCapsImpacted" select="key('busCapImpact',current()/name)"/>
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="goalBusObjs" select="$allBusObjectives[name=$this/own_slot_value[slot_reference = 'goal_supported_by_objectives']/value]"/> 
		<xsl:variable name="pseudoGoalbusObjs" select="$allBusObjectives[name=$this/own_slot_value[slot_reference = 'objective_supported_by_objective']/value]"/> 
		<xsl:variable name="busObjs" select="$goalBusObjs union $pseudoGoalbusObjs"/> 
		<xsl:variable name="thisBusCategories" select="key('busGoalCategory',current()/own_slot_value[slot_reference='business_goal_category']/value)"/> 
		<xsl:variable name="busCapsRelation" select="key('busCapObjRelationKey',current()/name)"/>
		{ 
				"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
				"categories":[<xsl:for-each select="$thisBusCategories">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				"className":"<xsl:value-of select="current()/type"/>",
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
				"objectives":[<xsl:apply-templates select="$busObjs" mode="objs"/>],
				"goalColour":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
				"goaltxtColour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>",
				"contributions":[<xsl:for-each select="$busCapsRelation">
				<xsl:variable name="busCapsRelation" select="$objContribution[name=current()/own_slot_value[slot_reference='obj_type_delivery_contribution_level']/value]"/>
				{"id":"<xsl:value-of select="eas:getSafeJSString($busCapsRelation/name)"/>", 
					"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$busCapsRelation"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>", 
				"relatedCaps":[<xsl:for-each select="current()/own_slot_value[slot_reference='buscap_to_bus_obj_type_buscap']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],		
				"capsImpacted":[<xsl:for-each select="$busCapsImpacted">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="goalCategories">
		{ 
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>", 
			"enumname":"<xsl:call-template name="RenderMultiLangInstanceSlot">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="displaySlot" select="'enumeration_value'"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="objs">
			<xsl:variable name="busCapsImpacted" select="key('busCapImpact',current()/name)"/>
			<xsl:variable name="busCapsRelation" select="key('busCapObjRelationKey',current()/name)"/>
				{
					"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
				"className":"<xsl:value-of select="current()/type"/>",
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
				"caps":[<xsl:for-each select="$busCapsImpacted">
					<xsl:variable name="relevantBusCaps" select="eas:get_cap_descendants(current(), $busCaps, 0, 10, 'supports_business_capabilities')"/>
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
					"childCaps":[<xsl:for-each select="$relevantBusCaps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>],
				"contributions":[<xsl:for-each select="$busCapsRelation">
				<xsl:variable name="busCapsRelation" select="$objContribution[name=current()/own_slot_value[slot_reference='obj_type_delivery_contribution_level']/value]"/>
				{"id":"<xsl:value-of select="eas:getSafeJSString($busCapsRelation/name)"/>", 
				"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$busCapsRelation"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>", 
				"relatedCaps":[<xsl:for-each select="current()/own_slot_value[slot_reference='buscap_to_bus_obj_type_buscap']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>		
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
					"className":"Project",
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
	<xsl:template match="node()" mode="capStyles">
		<xsl:variable name="capStyle" select="key('eleStyle', current()/name)"/>
		{
			"id":"<xsl:value-of select="current()/name"/>",
			"backgroundColour":"<xsl:value-of select="$capStyle/own_slot_value[slot_reference='element_style_colour']/value"/>",
			"colour":"<xsl:value-of select="$capStyle/own_slot_value[slot_reference='element_style_text_colour']/value"/>"
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
