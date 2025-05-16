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
	<xsl:variable name="instanceData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"></xsl:variable>
	<xsl:variable name="actorData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"/>
    <xsl:variable name="apiKPIData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: App KPIs'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"/>
	<xsl:variable name="apiBusKPIData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Bus KPIs'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"/>
   
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

	<xsl:variable name="isEIPMode">
 		<xsl:choose>
 			<xsl:when test="$eipMode = 'true'">true</xsl:when>
 			<xsl:otherwise>false</xsl:otherwise>
 		</xsl:choose>
 	</xsl:variable>
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
		<xsl:variable name="apiInstance">
			<xsl:call-template name="GetViewerAPIPathText">
				<xsl:with-param name="apiReport" select="$instanceData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="apiKPIs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$apiKPIData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable> 
		<xsl:variable name="apiBusKPIs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$apiBusKPIData"></xsl:with-param>
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
				
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"></script>
				<script src="js/kpi_structure.js"/>
				<xsl:if test="$eipMode">
				<script type="text/javascript" src="editors/assets/js/joint-plus/package/joint-plus.js">
				</script>
				</xsl:if>
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
						width:8px;
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
						width: 450px;
						position: fixed;
						z-index: 1;
						top: 76px;
						right: 0;
						background-color: #f6f6f6;
						overflow-x: hidden;
						transition: margin-right 0.5s;
						padding: 10px 10px 10px 10px;
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
						margin-right: -452px;
						z-index:10;
					}
					
					.sidenav .closebtn{
						position: absolute;
						top: 5px;
						right: 5px;
						font-size: 14px;
						margin-left: 50px;
					}

					.sidenavkpi{
						height: calc(100vh - 76px);
						width: 550px;
						margin-right: -552px;
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

					.process-circle{
						display: block;
						min-width: 10px;
						padding: 2px 5px;
						font-size: 10px;
						font-weight: 700;
						line-height: 1;
						text-align: center;
						white-space: nowrap;
						vertical-align: middle;
						background-color: #8e26ab;
						color: #fff;
						border-radius: 10px;
						border: 1px solid #ccc;
						position: absolute;
						right: 5px;
						top: 5px;
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
							width:110px;
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


					.kpiHandle {
						position: fixed; /* changed to fixed */
						right: 30px; /* position on the right edge */
						top: 37%; /* vertically centered */
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
				
				.modal-xl{
					width: 98% !important; /* Adjust this value as needed */
				}
				.app-scores-list, .leftpanel{
					font-size:0.8em;
				}
				.panel > .li{
					font-size:0.5em;

				}
				.panel {
						float: right;
						width: 200px;
						margin: 20px;
						padding: 10px;
						position: absolute;
						right: 0px;
						border: 1px solid #ccc;
						background-color: #f9f9f9;
						top: 60px;
						overflow-y: scroll;
						height:500px;
					}
					.leftpanel{
						height:70%;
						height:500px;
						overflow-y: scroll;
						float: left;
						width: 150px;
						margin: 20px;
						padding: 10px;
						position: absolute;
						left: 0px;
						border: 1px solid #ccc;
						background-color: #f9f9f9;
						top: 70px;
					}
					.modal-dialog {
					height: 95%; /* = 90% of the .modal-backdrop block = %90 of the screen */
					}
					.modal-content {
					height: 100%; /* = 100% of the .modal-dialog block */
					}
					.service-slider {
						width: 100px !important; /* Adjust the width as needed */
						margin-left: 8px;
						-webkit-appearance: none;
						appearance: none;
						height: 7px;
						background: #d3d3d3;
						border-radius: 6px;
						outline: none;
						opacity: 0.7;
						transition: opacity .2s;
						z-index:100;
					}
					.service-slider:hover {
						opacity: 1;
					}
					.service-slider::-webkit-slider-thumb {
						-webkit-appearance: none;
						appearance: none;
						width: 15px;
						height: 15px;
						background: #2bbda0;
						cursor: pointer;
						border-radius: 50%;
					}
					.service-slider::-moz-range-thumb {
						width: 15px;
						height: 15px;
						background: #2bbda0;
						cursor: pointer;
						border-radius: 50%;
					}
					.service-selection label {
						display: flex;
						align-items: center;
						margin-bottom: 10px;
					}
					.service-selection input[type="checkbox"] {
						margin-right: 10px;
					}
					.service-checkbox-label{
						font-size:0.9em;
						font-weight:500;
					}
					.service-selection input[type="checkbox"] {
						transform: scale(0.8); /* Adjust the scale as needed */
					
					}
					.appTimePanel{
						font-size:0.9em;
						border:1pt solid #d3d3d3;
						padding: 2px;
						border-radius:6px;
						margin:2px;
					}
					#dispoInfoCircle {
						position: absolute;
						width: 300px;
						background-color: white;
						border: 1px solid #ccc;
						padding: 2px;
						box-shadow: 0 2px 5px rgba(0,0,0,0.2);
						border-radius: 5px;
						display: none;
						right: 20px;
						top: 20px;
						transition: opacity 0.1s ease-in-out;
						opacity: 1;
						z-index: 100;
					}
					#dispoCircle:hover + #dispoInfoCircle {
						display: block;
						opacity: 1;
					}
					.superscript {
						font-size: 0.8em; /* Adjust the size of the superscript */
						vertical-align: super; /* Align the icon as superscript */
					}
					.valid-option {
						color: green;
						}

						#maturitymodal {
							display: none;
							position: fixed;
							left: 50%;
							top: 50%;
							width: 400px;
							height: 0;
							padding: 20px;
							box-sizing: border-box;
							background: #fff;
							border-radius: 8px;
							box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
							transform: translate(-50%, -50%); 
							overflow-y: auto;
							text-align: center;
							z-index:1001;
						}
						#modal-overlay {
							display: none;
							position: fixed;
							top: 0;
							left: 0;
							width: 100%;
							z-index:900;
							height: 100%;
							background: rgba(0, 0, 0, 0.5);
						}
					.busCriticality{
						display:inline-block;
						visibility: hidden;
					}

					#busCriticalitiesSelect + .select2-container--default .select2-selection--multiple {
							font-size: 0.8em; 
						}
				#paper-container {
					display: flex;
					justify-content: flex-start;
					align-items: flex-start; /* Align to the top */
					overflow: auto; /* Ensure scrolling */
					width: 100%;
					height: 100%;
					position: relative;
				}

				#paper-container .joint-paper {
					top: 40px !important;
					left: 0px !important;
				}
				#processmodal {
					overflow: hidden; /* Prevent accidental modal scroll */
				}
				.processInfoButton{
					display: none;
				}
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
									<span class="text-darkgrey"> <xsl:value-of select="eas:i18n('Business Capability Dashboard')"></xsl:value-of>
									</span> -  
									<span class="text-primary">
										<span id="rootCap"></span>
									</span>
								</h1>  
							</div> 
						</div>
						<div class="col-xs-12" id="optionsBoxContainer">
							<span class="handle"><i class="fa fa-arrow-circle-down handleicon right-5" aria-hidden="true"></i><xsl:value-of select="eas:i18n('View Options')"/></span>
							<div class="optionsPanel">
								<div id="optionsBox">
									<div class="large strong bottom-10"><xsl:value-of select="eas:i18n('Options')"/></div>
									<div class="row">
										<div class="col-md-3">
											<strong class="right-5"><xsl:value-of select="eas:i18n('Caps Style')"/>:</strong>
											<button type="button" aria-label="Show caps" class="btn btn-xs btn-success" id="hideCaps"><xsl:value-of select="eas:i18n('Show')"/></button>
											<strong class="left-30 right-5"><label for="retired"><xsl:value-of select="eas:i18n('Show Retired')"/>:
											<input type="checkbox" id="retired" name="retired"/>
											</label>
											</strong>
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
											<div class="configure"  ><xsl:value-of select="eas:i18n('Switch Capability Style')"/>:
												<!-- <i class="fa fa-cog" style="color:#c3193c" id="config"></i><i class="fa fa-graduation-cap" style="color:#c3193c" id="herm"></i>
												-->
												<div class="radio-group">
													<input type="radio" id="herm" name="type-group" class="radio-group hermRadio" checked="true"/>
													<label for="herm" aria-label="Graduation Cap">
													<i class="fa fa-graduation-cap hermRadio"></i>
													</label>

													<input type="radio" id="bars" name="type-group" class="radio-group"/>
													<label for="bars" aria-label="Bars">
													<i class="fa fa-bars"></i>
													</label>

													<input type="radio" id="brick" name="type-group" class="radio-group"/>
													<label for="brick" aria-label="Brick List">
													<i class="fa fa-th-list"></i>
													</label>

												  
											 
												  </div>
											</div>
										</div>
									</div>									
								</div>
							</div>	
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<div id="modal-overlay"></div>
						<div id="maturitymodal">
							
							<div id="listForMaturity"/>
							<button type="button" aria-label="Close" class="btn btn-warning btn-sm" id="maturity-close-btn"><xsl:value-of select="eas:i18n('Close')"/></button>
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
									
									<div class="busCriticality">
									<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Criticalities')"/>:</strong>
									 <select id="busCriticalitiesSelect"><option value=''><xsl:value-of select="eas:i18n('Not Set')"/></option></select>
									</div>
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
								<select id="leftOrgList" class="form-control orgCompare" style="width:100%"><option value="all"><xsl:value-of select="eas:i18n('Select')"/></option></select>	
								<div class="leftAppColour" style="width:100%">&#160;</div>
							</div>
							<div class="col-xs-6 col-lg-6">
								<label>
									<span><xsl:value-of select="eas:i18n('Organisation')"/> 2</span>
								</label>
								<select id="rightOrgList" class="form-control orgCompare" style="width:100%"><option value="all"><xsl:value-of select="eas:i18n('Select')"/></option></select>		
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
							<button type="button" aria-label="View Rationalisation"  class="btn btn-default appRatButton bottom-15 saveApps"><i class="fa fa-external-link right-5 text-primary "/><xsl:value-of select="eas:i18n('View in Rationalisation')"/></button>	
                            <button type="button" aria-label="Show Disposition" class="btn btn-default timeButton bottom-15 showTime" title="disposition"><i class="fa fa-crosshairs text-primary right-5"/><xsl:value-of select="eas:i18n('Disposition')"/></button>
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
						<div id="kpiSidenav" class="sidenav sidenavkpi">
							<span class="kpiHandle"><i class="fa fa-line-chart" aria-hidden="true"></i></span>
							 
							<h3><xsl:value-of select="eas:i18n('KPIs')"/> <span class="text-primary" id="kpiName"/></h3>
							<xsl:value-of select="eas:i18n('Select KPI')"/>: <select id="kpiSelection"><option><xsl:value-of select="eas:i18n('Choose')"/></option></select>
							<button type="button" aria-label="Clear Values"  class="btn maturityClr btn-info btn-xs"><xsl:value-of select="eas:i18n('Clear Maturity')"/></button><br/>
							<xsl:value-of select="eas:i18n('Maturity Key')"/>: <span class="label label-default" style="background-color:#FF8A8A">1</span>
							<span class="label label-default" style="background-color:#F4DEB3; color:#000000">2</span>
							<span class="label label-default" style="background-color:#F0EAAC; color:#000000">3</span>
							<span class="label label-default" style="background-color:#CCE0AC; color:#000000">4</span>
							<span class="label label-default" style="background-color:#85A98F">5</span> <br/>
							<label class="label label-default"><xsl:value-of select="eas:i18n('KPI Basis')"/></label>
							<form class="right-10">
								<label>
								  <input type="radio" name="kpiOption" value="businessCapabilities" checked="true"/>
								  <xsl:value-of select="eas:i18n('Business Capability')"/>
								</label> 
								
								<label>
								  <input type="radio" name="kpiOption" value="processes"/>
									<xsl:value-of select="eas:i18n('Business Process')"/>
								</label> 
								
								<label>
								  <input type="radio" name="kpiOption" value="applications"/>
								   <xsl:value-of select="eas:i18n('Application')"/>
								</label>
							  </form>
							  <div id="maturityTable"/>
						</div>
						<div id="infoSidepanel" class="sidepanel">
						<label for="recipeListSelect"><span id="recipeTitle"></span></label>
							: <select id="recipeListSelect"/><xsl:text> </xsl:text> <button type="button" aria-label="Clear Highlighting"  id="clr" class="btn btn-success btn-xs"><xsl:value-of select="eas:i18n('Clear Highlight')"/></button>
							<div id="recipeList"/>
							<span class="handle2"><i class="fa fa-file-text-o" aria-hidden="true"></i></span>
						</div>
                        <!-- time modal -->
                        <div class="modal fade " id="timeModal" tabindex="-1" aria-labelledby="timeModal" aria-hidden="true">
                            <div class="modal-dialog modal-xl">
                                <div class="modal-content">
                                    <div class="modal-body">

                                    <h3><b>Disposition Model</b></h3>
									<div class="pull-right " id="dispositionKey"></div>
                                        <div class="leftpanel  service-selection col-xs-1">
                                     
                                        </div>
										<span id="dispoInfoCircle" style="display:none"><xsl:value-of select="eas:i18n('No technical or business fit scores are set for this application, but a disposition value has been set and is being used instead')"/></span>
                                            <svg width="800" height="500" id="dispositionSVG" style="margin-left:150px;top:20px; position:relative"></svg>
										 
                                        </div>
                                        <div class="panel col-xs-2 timeInfo">
                                            <h3>Application Scores</h3>
                                            <div id="app-scores-list"></div>
                                        </div>
                              
                                    <div class="modal-footer" style="border-top:none">
                                        <button type="button" aria-label="Close" class="btn btn-secondary" data-dismiss="modal">Close</button> 
                                    </div>
                                </div>
                            </div>
                        </div>


						<!-- process modal-->

						 <div class="modal fade " id="processModal" tabindex="-1" aria-labelledby="processModal">
                            <div class="modal-dialog modal-xl">
                                <div class="modal-content">
                                    <div class="modal-body"> 
                                    <h3><b>BPMN Flow for <span id="processName"/></b></h3>
									<button type="button" class="btn btn-secondary closeModal" data-dismiss="modal" aria-label="Close modal">   <span aria-hidden="true">Close</span></button> 
									<div class="pull-right" role="note" style="border: 1px solid #555; border-radius: 6px; padding: 5px; font-size: 0.9em; background-color: #f8f9fa; color: #222;" aria-label="Zoom Instructions"><xsl:value-of select="eas:i18n('Hold CTRL to zoom')"/></div>
                                        <div id="paper-container"/> 
                                    </div>
                                    <div class="modal-footer" style="border-top:none">
                                       
                                    </div>
                                </div>
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
<!-- HERM -->
<script id="herm-model-template" type="text/x-handlebars-template">
	<div class="model-section-wrapper">
		<div class="impact bottom-10 xlarge text-primary">Core Capabilities</div>
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
						<div class="valueHead strong bg-primary">ASSURE</div>
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	
                {{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
                {{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
            {{#getApps this}}{{/getApps}} 

			{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
                {{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
            {{#getApps this}}{{/getApps}} 

			{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
                {{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
                {{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
				{{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
				<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	 
				{{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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

<script id="maturitylist-template" type="text/x-handlebars-template">
	 
	<table class="table table-striped table-condensed">
		
		<thead><tr><th>{{#if this.processes}}<xsl:value-of select="eas:i18n('Process')"/>{{else}}<xsl:value-of select="eas:i18n('Application')"/>{{/if}}</th><th><xsl:value-of select="eas:i18n('Score')"/></th> </tr></thead>
		<tbody>
		{{#each this.apps}}
			<tr>
				<th>{{#essRenderInstanceLinkMenuOnly this 'Application_Provider'}}{{/essRenderInstanceLinkMenuOnly}}</th>
				<th><span class="label label-info">{{this.score}}</span></th> 
			</tr>
		{{/each}}
		{{#each this.processes}}
			<tr>
				<th>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</th>
				<th><span class="label label-info">{{this.score}}</span></th> 
			</tr>
		{{/each}}
		</tbody>
	</table>
</script>
 
<script id="maturity-template" type="text/x-handlebars-template">
	<table class="table table-striped table-condensed">
		
		<thead><tr><th><xsl:value-of select="eas:i18n('Capability')"/></th><th><xsl:value-of select="eas:i18n('Score')"/></th><th></th> </tr></thead>
		<tbody>
		{{#each this}}
			<tr>
				<th>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</th>
				<th>{{#getMaturityScoreColour this.score}}{{/getMaturityScoreColour}}</th> 
				<th>{{#if this.processes}}<span class="label label-info">{{this.process.length}}</span> Processes{{/if}}
					{{#if this.apps}}<span class="label label-info">{{this.apps.length}}</span> <xsl:value-of select="eas:i18n('Apps')"/>
					<xsl:text> </xsl:text>
					<i class="fa fa-question-circle maturityCircle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
					{{/if}}

				</th>
			</tr>
		{{/each}}
		</tbody>
	</table>
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
						<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute>{{this.processes}}</span> 		
					<span class="toggle-circle">
						<xsl:attribute name="eascapid">{{id}}</xsl:attribute>
						<i class="fa fa-fw fa-caret-down"></i>
					</span>
					<span class="cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
					{{#getApps this}}{{this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
					<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute>{{this.processes}}</span> 	
				{{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
					<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span>  	
				{{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
					<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	
				{{#getApps this}}{{/getApps}} 				 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
					<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	
			{{#getApps this}}{{/getApps}} 	
			
			{{#getAppsInfo this}}{{/getAppsInfo}} 	
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
					<span class="process-circle "><xsl:attribute name="easidprocess">{{id}}</xsl:attribute></span> 	
				{{#getApps this}}{{/getApps}} 

				{{#getAppsInfo this}}{{/getAppsInfo}} 
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
						{{#if this.disposition}}
						<div class="lifecycle pull-right">
							<xsl:attribute name="style">background-color:{{this.disposition.backgroundColor}};color:{{this.disposition.colour}}</xsl:attribute>
							{{this.disposition.name}}
						</div>
						{{/if}}
						{{#if this.deployment}}
						<div class="lifecycle pull-right">
							<xsl:attribute name="style">background-color:{{lifecycleColor}};color:{{#if lifecycleText}}{{lifecycleText}}{{else}}#000000{{/if}}</xsl:attribute>
							{{this.deployment}}
						</div>
						{{/if}}
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

							<button type="button" aria-label="Show more detail"  class="btn btn-default btn-xs appInfoButton pull-right"><xsl:attribute name="easid">{{id}}</xsl:attribute><xsl:value-of select="eas:i18n('Show Details')"/></button>
						
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
	<script id="process-template" type="text/x-handlebars-template">
		<h3><i class="fa fa-switch"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Processes')"/></h3>
		<p><xsl:value-of select="eas:i18n('Processes supporting the capability with criticality')"/></p>
		<ul>
		{{#each this.filteredProcesses}}
		<div class="appBox"> 
				<xsl:attribute name="easid">{{id}}</xsl:attribute>
				<div class="appBoxSummary">
					<div class="projectBoxTitle pull-left strong">
						<xsl:attribute name="title">{{this.name}}</xsl:attribute><!--onclick="toggleMiniPanel(this)"-->
						<i class="fa fa-caret-right fa-fw right-5 text-white"  onclick="toggleMiniPanel(this)"/>{{#essRenderInstanceMenuLinkLight this}}{{/essRenderInstanceMenuLinkLight}}
					</div>
					<div class="lifecycle pull-right">
							<xsl:attribute name="style">background-color:{{this.backgroundColor}};color:{{this.colour}}</xsl:attribute>
							{{this.criticality}}
					</div>
				</div>
				<div class="clearfix"/>
				<div class="mini-details">
					<div class="small pull-left text-white">
						<div class="left-5 bottom-5"><i class="fa fa-random right-5"></i>Physical Process Implementations: {{this.count}}</div> 
						<div class="left-5 bottom-5"><i class="fa fa-random right-5"></i>Applications Used: {{this.appCount}}</div> 
							
					</div>
					<xsl:if test="$isEIPMode='true'">
					<button type="button" aria-label="Show Process Flow"  class="btn btn-default btn-xs processInfoButton pull-right"><xsl:attribute name="easidProcessButton">{{id}}</xsl:attribute><xsl:attribute name="processname">{{this.name}}</xsl:attribute><xsl:value-of select="eas:i18n('Show Flow')"/></button>
					</xsl:if>
				</div>
			</div>
		{{/each}}
		</ul>
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
	<script id="appTime-template" type="text/x-handlebars-template">
		<div class="appTimePanel">
			<span class="label label-info"><strong> {{this.name}}</strong></span><br/> 
			<span class="label label-default label-sm"><strong>Technical Fit:</strong></span> <small><xsl:text> </xsl:text>Avg:{{techAvg}}</small><br/>
			<span class="label label-default  label-sm"><strong>Business Fit:</strong></span>  <small><xsl:text> </xsl:text>Avg: {{busAvg}}</small>
		</div>
	
	</script>
	<script id="recipe-template" type="text/x-handlebars-template">
		<div class="col-xs-11"> 
		<br/>
		<xsl:value-of select="eas:i18n('Capabilities supporting this selection')"/>:<br/>
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
			<xsl:value-of select="eas:i18n('No Capabilities mapped to goals')"/>
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
		<p><xsl:value-of select="eas:i18n('Objectives supporting this goal')"/>:</p>
		{{#each this.objectives}}
		<i class="fa fa-circle"></i><xsl:text> </xsl:text>{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Objective'}}{{/essRenderInstanceLinkMenuOnlyLight}}<br/>
		{{/each}}
		{{else}}
			<xsl:value-of select="eas:i18n('No Objectives mapped')"/>
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
			<div class="goalCard2"><xsl:attribute name="style">color:#000;border-bottom:7px solid {{goalColour}};overflow-y:auto</xsl:attribute>
				<xsl:attribute name="goalid">{{this.id}}</xsl:attribute>
				<div class="goalHead"><xsl:attribute name="style">border-bottom:2px solid {{goalColour}}</xsl:attribute><xsl:value-of select="eas:i18n('Goal')"/></div>
				<div class="goalMain">{{this.name}}
				</div> 
				<i class="fa fa-info-circle goalInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
			</div>	
		{{/each}}
	</script>
	<script id="infoConcept-template" type="text/x-handlebars-template">
		<div class="infoConceptBoxHide dataBox">
			<xsl:attribute name="easid">{{id}}</xsl:attribute>
			<div><em>{{this.name}}</em></div>
			{{#if this.infoViews.length}}
			<div class="info-circle ">
				<xsl:attribute name="easidinfo">{{id}}</xsl:attribute>
				{{this.infoViews.length}}
			</div>
			{{/if}}
		</div> 
	</script>
	<script id="dispkey-template" type="text/x-handlebars-template"> 
		<i class="fa fa-ellipsis-h"></i><xsl:text> </xsl:text><strong><xsl:value-of select="eas:i18n('Disposition Status Only')"/></strong><i class="fa fa-info-circle right-5 superscript " id="dispoCircle"></i><xsl:text> </xsl:text>
			{{#each this}}
				<i class="fa fa-circle"><xsl:attribute name="style">color: {{backgroundColor}}</xsl:attribute></i>
					<strong>{{enum_name}}</strong>   <xsl:text> </xsl:text>
			{{/each}} 
			
	</script>
</body>
		<script>			
			<xsl:call-template name="RenderViewerAPIJSFunction">
				<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
				<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
				<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param>  
				<xsl:with-param name="viewerAPIPathSvcs" select="$apiSvcs"></xsl:with-param>  
				<xsl:with-param name="viewerAPIPathActor" select="$apiActor"></xsl:with-param>  
				<xsl:with-param name="viewerAPIPathKPIs" select="$apiKPIs"></xsl:with-param>   
				<xsl:with-param name="viewerAPIPathBusKPIs" select="$apiBusKPIs"></xsl:with-param>  		
				<xsl:with-param name="viewerAPIPathInstance" select="$apiInstance"></xsl:with-param>
					
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
		<xsl:param name="viewerAPIPathKPIs"></xsl:param> 
		<xsl:param name="viewerAPIPathBusKPIs"></xsl:param> 
		<xsl:param name="viewerAPIPathInstance"></xsl:param> 
		
	<!--	<xsl:param name="viewerAPIPathScores"></xsl:param>-->
	<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
		var viewAPIDataSvcs = '<xsl:value-of select="$viewerAPIPathSvcs"/>'; 
		var viewAPIDataActor = '<xsl:value-of select="$viewerAPIPathActor"/>';
		var viewAPIDataAppKPI = '<xsl:value-of select="$viewerAPIPathKPIs"/>'; 
		var viewAPIDataBusKPI = '<xsl:value-of select="$viewerAPIPathBusKPIs"/>';
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
		let filterExcludes = [<xsl:for-each select="$theReport/own_slot_value[slot_reference='report_filter_excluded_slots']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>];
	 
		$('#goalsCatBox').hide();

		var repoSetting, processCriticalities, processCountMap, processToAppsMap, finalAppCountByPrId;
		var colourPalette=['#FF8A8A','#F4DEB3','#F0EAAC','#CCE0AC','#85A98F']	
		var colourPaletteText=['#ffffff','#000000','#000000','#000000','#ffffff']	

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
		var instance2planArray, capInstanceMap, projectsArray, busCriticalityValues,goalKeyTemplate;
		var showHideCaps=[];
        var apps, serviceQualityMap, uniqueProcesses;
		var bandsCount=0;
		var sqvsMap, alSQ;
		if(repTitle){
			$('#reportTitle').text(repTitle)
		}

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
   
		// let filtersNo=[<xsl:call-template name="GetReportFilterExcludedSlots"><xsl:with-param name="theReport" select="$theReport"></xsl:with-param></xsl:call-template>];
		var busGoals=[<xsl:apply-templates select="$busGoals" mode="busGoals"/> ]; 
	
		busGoals.forEach(b => {
			const capsImpactList = new Set();
			const consolidated = {};

			b.contributions.forEach(contribution => {
				const { id, name, relatedCaps } = contribution;

				if (!consolidated[id]) {
					consolidated[id] = {
						id,
						name,
						className: 'Business_Goal',
						relatedCaps: []
					};
				}

				consolidated[id].relatedCaps.push(...relatedCaps);
				relatedCaps.forEach(cap => capsImpactList.add(cap));
			});

			b.capsImpacted = [...new Set([...b.capsImpacted, ...capsImpactList])];
			b.contributions = Object.values(consolidated);
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

	$('#recipeListSelect').select2({width:'250px', placeholder: '<xsl:value-of select="eas:i18n('Select an option')"/>' })

	  function createMaps(data) {
			const capToObjMap = new Map();
			const businessGoalsMap = new Map();

			data.forEach(goal => {
				// Update businessGoalsMap
				const objectivesArray = goal.objectives.map(obj => ({
					name: obj.name,
					id: obj.id,
					caps: obj.caps
				}));
				businessGoalsMap.set(goal.name, objectivesArray);

				// Update capToObjMap
				goal.objectives.forEach(({ id: objId, name: objName, caps }) => {
					caps.forEach(({ id: capId }) => {
						if (!capToObjMap.has(capId)) {
							capToObjMap.set(capId, []);
						}
						const objectives = capToObjMap.get(capId);
						if (!objectives.some(obj => obj.objectiveId === objId)) {
							objectives.push({
								objectiveId: objId,
								objectiveName: objName,
								className: 'Business_Objective'
							});
						}
					});
				});
			});

			return { capToObjMap, businessGoalsMap };
		}
  
	let { capToObjMap, businessGoalsMap } = createMaps(busGoals);
   
		let styleSetting = localStorage.getItem('busCapConfig') || repoSetting;
		 
		var originalPositions = {}; 
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
        var kpiData, techFit, selectedServices,busFit, categories, appKPIsformat, workingAppKpisformat, appKPIs, dispositionLifecycleStatus, timeAvailable;
// Process flow popup code
 
	var testBPMN;
<xsl:if test="$isEIPMode = 'true'">
	var graph = new joint.dia.Graph({ type: 'bpmn' }, { cellNamespace: joint.shapes });

var windowWidth = $('#processModal').width();
var windowHeight = $('#processModal').height();;
 

var paper = new joint.dia.Paper({
    width: window.innerWidth - 200,
    height: window.innerHeight - 200,
    model: graph,
    gridSize: 5,
    async: true,
    sorting: joint.dia.Paper.sorting.APPROX,
    interactive: { 
        linkMove: false,
        elementMove: false, // Enable dragging elements
        paper: true // Allow interactions with the background
    },
    snapLabels: true,
    cellViewNamespace: joint.shapes,
    restrictTranslate: false // Allow elements to move freely
});


var paperScroller = new joint.ui.PaperScroller({
    autoResizePaper: true,
    padding: 20,
    paper: paper,
    scrollWhileDragging: true // Enable scrolling while dragging
});
</xsl:if>

	$('.appPanel').hide();
	$('#kpiSelection').select2({width: '250px'});
	var appArray
	var allKpis, myBusKPIs;
	var workingArrayCaps, workingArrayBusCapHierarchy;
	var workingArrayAppsCaps;
	var appToCap=[];
	var processMap=[]; 
	let svsArray=[];
	var scores=[];
	var relevantOrgData=[]; 
	const buscapToAllIdsMap = {};
	var matchedBuscapAndPlanIds = [];


function setViewOptions(thisId) {
    const elements = {
        appCircle: $('.app-circle'),
        projCircle: $('.proj-circle'),
        compareCircle: $('.compare-circle'),
		processCircle: $('.process-circle'),
        keyHolder: $('#keyHolder'),
        comparePanel: $('#comparePanel'),
        goalbox: $('.goalbox'),
        dataBox: $('.dataBox'),
        showTime: $('.showTime'),
        appUsage: $('.appusage'),
        buscap: $('.buscap'),
        infoCircle: $('.info-circle'),
        appRatButton: $('.appRatButton'),
		busCriticalitySel: $('.busCriticality')
    };

    // Hide all elements initially
    elements.appCircle.hide();
    elements.projCircle.hide();
    elements.compareCircle.hide();
	elements.processCircle.hide();
    elements.keyHolder.slideUp();
    elements.comparePanel.slideUp();
    elements.goalbox.hide();
    elements.showTime.hide();
    elements.appUsage.hide();
    elements.dataBox.removeClass('infoConceptBox').addClass('infoConceptBoxHide');
    elements.buscap.removeClass("off-cap");
	elements.busCriticalitySel.css('visibility', 'hidden'); ;

    switch (thisId) {
        case 'apps':
            elements.appCircle.show();
            if (timeAvailable === 1) elements.showTime.show();
            elements.buscap.addClass("off-cap");

            // Batch removing "off-cap" from matching elements
            inScopeCapsApp.forEach(e => {
                $('*[easidscore="' + e.id + '"]').parent().removeClass("off-cap");
            });

            elements.appUsage.show();
            break;

        case 'goals':
            elements.projCircle.show();
            elements.keyHolder.slideDown();
            elements.goalbox.show();
            break;

        case 'compare':
            elements.compareCircle.show();
            elements.comparePanel.slideDown();
            break;

        case 'data':
            elements.dataBox.addClass('infoConceptBox').removeClass('infoConceptBoxHide');
            elements.infoCircle.show();
            break;

        case 'maturity':
            elements.appRatButton.hide();
            openKpiNav();
            break;
			
		case 'criticality':
		 	elements.processCircle.show();
			if(processCriticalities==true){
				elements.busCriticalitySel.css('visibility', 'visible'); 
			}
            elements.appRatButton.hide(); 
            break;
		 case 'processes':
		 	elements.appRatButton.hide(); 
            openKpiNav();
            break;	
    }
}

	function setViewOptions(thisId) {
    const elements = {
        appCircle: $('.app-circle'),
        projCircle: $('.proj-circle'),
        compareCircle: $('.compare-circle'),
		processCircle: $('.process-circle'),
        keyHolder: $('#keyHolder'),
        comparePanel: $('#comparePanel'),
        goalbox: $('.goalbox'),
        dataBox: $('.dataBox'),
        showTime: $('.showTime'),
        appUsage: $('.appusage'),
        buscap: $('.buscap'),
        infoCircle: $('.info-circle'),
        appRatButton: $('.appRatButton'),
		busCriticalitySel: $('.busCriticality')
    };

    // Hide all elements initially
    elements.appCircle.hide();
    elements.projCircle.hide();
    elements.compareCircle.hide();
	elements.processCircle.hide();
    elements.keyHolder.slideUp();
    elements.comparePanel.slideUp();
    elements.goalbox.hide();
    elements.showTime.hide();
    elements.appUsage.hide();
    elements.dataBox.removeClass('infoConceptBox').addClass('infoConceptBoxHide');
    elements.buscap.removeClass("off-cap");
	elements.busCriticalitySel.css('visibility', 'hidden'); ;

    switch (thisId) {
        case 'apps':
            elements.appCircle.show();
            if (timeAvailable === 1) elements.showTime.show();
            elements.buscap.addClass("off-cap");

            // Batch removing "off-cap" from matching elements
            inScopeCapsApp.forEach(e => {
                $('*[easidscore="' + e.id + '"]').parent().removeClass("off-cap");
            });

            elements.appUsage.show();
            break;

        case 'goals':
            elements.projCircle.show();
            elements.keyHolder.slideDown();
            elements.goalbox.show();
            break;

        case 'compare':
            elements.compareCircle.show();
            elements.comparePanel.slideDown();
            break;

        case 'data':
            elements.dataBox.addClass('infoConceptBox').removeClass('infoConceptBoxHide');
            elements.infoCircle.show();
            break;

        case 'maturity':
            elements.appRatButton.hide();
            openKpiNav();
            break;
			
		case 'criticality':
		 	elements.processCircle.show();
			if(processCriticalities==true){
				elements.busCriticalitySel.css('visibility', 'visible'); 
			}
            elements.appRatButton.hide(); 
            break;
    }
}

	$('document').ready(function ()
		{ 

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

			maturityFragment = $("#maturity-template").html();
			maturityTemplate = Handlebars.compile(maturityFragment);
			
			maturityListFragment = $("#maturitylist-template").html();
			maturityListTemplate = Handlebars.compile(maturityListFragment);
			

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

			processFragment = $("#process-template").html();
			processTemplate = Handlebars.compile(processFragment);

			appScoreFragment = $("#appScore-template").html();
			appScoreTemplate = Handlebars.compile(appScoreFragment);

			infoConceptFragment = $("#infoConcept-template").html();
			infoConceptTemplate = Handlebars.compile(infoConceptFragment);
         
			dispkeyFragment = $("#dispkey-template").html();
			dispkeyTemplate = Handlebars.compile(dispkeyFragment);
 
            appTimeFragment = $("#appTime-template").html();
            appTimetemplate = Handlebars.compile(appTimeFragment);

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
 
 
			 $('#keyHolder').html(goalKeyTemplate(busGoals))

			$('.kpiHandle').click(function(){
				
				var icon = $(this).find('i'); 
				 
				if (icon.hasClass('fa-line-chart')) {
					icon.removeClass('fa-line-chart').addClass('fa-times');
					openKpiNav();
					$('.kpiHandle').css('top', '15%');
				} else {
					icon.removeClass('fa-times').addClass('fa-line-chart');
					closeKpiNav();
					$('.kpiHandle').css('top', '37%');
				}
				
			})

			$('.handle2').click(function(){
				$(`.buscap`).removeAttr('style');
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

           
			Handlebars.registerHelper('getLevel', function(arg1) {
				return parseInt(arg1) + 1; 
			});

			Handlebars.registerHelper('incrementIndex', function(value) {
				return parseInt(value) + 1;
			});

			Handlebars.registerHelper('getAppCircStyle', function(arg1) {
				 
			});

			Handlebars.registerHelper('getMaturityScoreColour', function(arg1) {
				return '<span class="label label-default" style="background-color:'+ colourPalette[arg1-1] +';color:'+colourPaletteText[arg1-1]+'">' +arg1+'</span>';
				 
			});
 
			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
			
			Handlebars.registerHelper('getWidth', function(sclen) {
				 
				return (100/sclen.length)-2;
			});

			Handlebars.registerHelper('getProjects', function (bc) {
				// Use optional chaining and check existence only once
				const matchedProjects = matchedBuscapAndPlanIds[bc.id]?.map(id => projectsArray?.find(project => project.id === id)) || [];

				// Lookup capProjects using a single iteration
				const thisProj = capProjects.find(e => e.id === bc.id);

				return thisProj ? thisProj.projects.length : 0;
			});


			Handlebars.registerHelper('getAppsInfo', function (instance) {
				// Find the matching app once
				const app = workingArrayAppsCaps.find(d => d.id === instance.id);
				if (!app || !app.infoConcepts) {
					return '';
				}

				// Filter unique concepts using a Set for better performance
				const seenIds = new Set();
				const uniqueData = app.infoConcepts.filter(({ id }) => {
					if (seenIds.has(id)) {
						return false;
					}
					seenIds.add(id);
					return true;
				});

				// Generate HTML directly
				return uniqueData.map(infoConceptTemplate).join('');
			});
 

			Handlebars.registerHelper('check', function(ins) {
				console.log('INSTANCE', ins)
			})

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

	$('#viewOption').append($('&lt;option>', {
			value: 'apps',
			text: '<xsl:value-of select="eas:i18n('Application Overlay')"/>'
		}));	

	//$('#viewOption').hide()	

 
	if(busGoals.length&gt;0){  
		$('#viewOption').append($('&lt;option>', {
				value: 'goals',
				text: '<xsl:value-of select="eas:i18n('Goals and Projects')"/>'
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
	  
	$('#busCriticalitiesSelect').on('change',function(){
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
		$('.process-circle').toggle() 
		$('.goalbox').slideToggle(); 
	});
 

	$('#viewOption').on('change', function() {
		closeNav();
		var thisId = $(this).val(); 
		setViewOptions(thisId);
	});

   
		
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataCaps), 
			promise_loadViewerAPIData(viewAPIDataSvcs),
			promise_loadViewerAPIData(viewAPIDataActor),
			promise_loadViewerAPIData(viewAPIDataAppKPI),
			promise_loadViewerAPIData(viewAPIDataBusKPI)
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
								text: '<xsl:value-of select="eas:i18n('Compare')"/>'
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

				//KPI set-up
                <xsl:call-template name="RenderKPIMartFunctions"/>
				kpiData = responses[5]; 
				buskpiData = responses[6]; 
				techFit = kpiData.perfCategory.find(e => e.name === 'Technical Fit');
				busFit = kpiData.perfCategory.find(e => e.name === 'Business Fit');
  
				categories = [techFit?.id, busFit?.id];
        
				selectedServices =  getQualityDetailsBySelectedCategories(kpiData.perfCategory, categories, kpiData.serviceQualities);

	//Maturity set-up
	// prepare the Perf categories and KPI data

				function mergeDeep(target, source) {
					for (const key in source) {
						if (Array.isArray(source[key])) {
							// If the key is an array, merge by concatenating arrays and removing duplicates
							target[key] = (target[key] || []).concat(source[key]).reduce((acc, item) => {
								if (!acc.find(i => i.id === item.id)) {
									acc.push(item);
								} else {
									const index = acc.findIndex(i => i.id === item.id);
									acc[index] = mergeDeep(acc[index], item); // Recursively merge if needed
								}
								return acc;
							}, []);
						} else if (source[key] instanceof Object) {
							// If the key is an object, recursively merge
							target[key] = mergeDeep(target[key] || {}, source[key]);
						} else {
							// Otherwise, simply assign the value
							target[key] = source[key];
						}
					}
					return target;
				}

				//merge the KPI data sets into a single structure
				mergeDeep(buskpiData, kpiData);
				
				myBusKPIs=buskpiData 
				buskpiData?.perfCategory?.forEach((c)=>{
					let iconClass= 'fa fa-cogs'
					if (c.classes?.includes('Business_Process')) {
						iconClass= 'fa fa-random'
					}else if (c.classes?.includes('Business_Capability')) {
						iconClass= 'fa fa-sitemap'
					}    
						$('#kpiSelection').append('<option value="'+c.id+'" data-icon="${iconClass}">'+c.name+ '</option>'); 
				})
			 
				// Process both busKPIs and appKPIs to add categories to data
				processKPIs(buskpiData, 'businessCapabilities');
				processKPIs(buskpiData, 'procesess');
				processKPIs(buskpiData, 'applications');		 
 
				alSQ=myBusKPIs.serviceQualities

				serviceQualityMap = alSQ.reduce((map, service) => {
					map[service.id] = service.sqvs;
					return map;
				  }, {});
				    
				sqvsMap = new Map();
						 
				alSQ.forEach(item => {
					
					const maxScore = Math.max(...item.sqvs.map(sqv => Number(sqv.score)));

					// Set a base max of 5 for normalization
					const baseMax = 5;

					// Normalize the scores to the base max of 5
					item.sqvs.forEach(sqv => {
						// Calculate the normalized score
						sqv.normalisedScore= (Number(sqv.score) / maxScore) * baseMax;
						sqvsMap.set(sqv.id, sqv);
					});

					// Update the item's maxScore to be the base max (which is now consistent)
					item.maxScore = baseMax;

				});
	
				allServiceQualities = new Map();

				// Populate the map
				alSQ.forEach(item => {
					allServiceQualities.set(item.id, item);
				});
				
	//maturity done
	
				selectedServices.forEach((s)=>{
					$('.service-selection').append('<label class="service-checkbox-label"><input type="checkbox" class="service-checkbox" value="'+s+'" checked="true"/>'+s+'</label><input type="range" min="0" max="1" step="0.01" value="0.5" class="service-slider" data-service="'+s+'"/>')
				})
				
                const hasUndefined = categories.some(element => element === undefined);
                  
                if (hasUndefined) {  
                }else{
                  
					// this will get the historical and latest average, may want to use in charts
                    appKPIsformat = getScoresByCategory(kpiData.applications, categories);
				 
                    //check need
                    d3.selectAll('.service-checkbox, .service-slider').on('change', function () {
                        selectedServices = d3.selectAll('.service-checkbox:checked').nodes().map(node => node.value);
                        updateChart(workingAppsList);
                    });
                }

                function getHermModel(){
                    $('#subroot').hide();
					$('#recipeTitle').text('<xsl:value-of select="eas:i18n('Recipe')"/>')
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
									}else if(d.name=='Research Delivery' || d.name=='Research Activity' )
									{
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
			
			 uniqueProcesses = [...new Set(workingArray.busCaptoAppDetails.flatMap(item => item.allProcesses))];
 
			 	if (uniqueProcesses.length > 0 &amp;&amp; 'criticality' in uniqueProcesses[0]) {
					processCriticalities = true;
				} 
				workingArray.busCaptoAppDetails.forEach((data) => {
					// Extracting the buscap id
					const buscapId = data.id;

					// Combining all IDs into a single list safely
					buscapToAllIdsMap[buscapId] = [].concat(
						data.allProcesses?.map(process => process.id) || [],  // IDs from allProcesses
						data.physP || [],  // IDs from physP
						data.apps || [],  // IDs from apps
						data.orgUserIds || [],  // IDs from orgUserIds
						data.geoIds || [],  // IDs from geoIds
						data.infoConcepts?.map(info => info.id) || [],  // IDs from infoConcepts
						data.domainIds || []  // IDs from domainIds
					);
				});
 
				filters=responses[1].filters;
				capfilters=responses[0].filters;

				busCriticalityValues= filters.find((c)=>{
					return c.id=='Business_Criticality'	
				})

 				$('#busCriticalitiesSelect').select2({
					width: '200px',  // Width should be a string, not a number
					multiple: true   // 'multiple' should be set as an option for multi-selection
				});
				
				busCriticalityValues.values.forEach((v)=>{
						$('#busCriticalitiesSelect').append('<option value="'+v.id+'" selected="true">'+v.enum_name+'</option>')
				})
				
				filters.sort((a, b) => (a.id > b.id) ? 1 : -1)
		 
				filterExcludes.forEach((e)=>{
					filters=filters.filter((f)=>{
						return f.slotName !=e;
					})
				 })
				 filterExcludes.forEach((e)=>{
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

				const busCapStylesMap = new Map(busCapStyles.map(e => [e.id, e]));
				// Sorts an array of capability objects by the 'order' property,
				// and then recursively sorts any nested 'childrenCaps' arrays.
				function sortCaps(capsArray) {
				// Sort the current array by 'order'
				capsArray.sort((a, b) => {
					// Convert order values to numbers. Treat non-numeric or missing values as Infinity.
					const orderA = isNaN(Number(a.order)) || a.order === "" || a.order == null ? Infinity : Number(a.order);
					const orderB = isNaN(Number(b.order)) || b.order === "" || b.order == null ? Infinity : Number(b.order);
					return orderA - orderB;
				});

				// Recursively sort the childrenCaps array of each item, if it exists.
				for (const item of capsArray) {
					if (item.childrenCaps &amp;&amp; Array.isArray(item.childrenCaps)) {
					sortCaps(item.childrenCaps);
					}
				}
				}
 
			const businessCapabilitiesMap = new Map(
			responses[2].businessCapabilities?.map(e => [e.id, e]) || []
			);

workingArray.busCapHierarchy.forEach(d => {
  // Apply styles if a match exists
  const styleMatch = busCapStylesMap.get(d.id);
  if (styleMatch) {
    d.bgColour = styleMatch.backgroundColour;
    d.colour = styleMatch.colour;
  }

  // Apply business capability details if a match exists
  const capArr = businessCapabilitiesMap.get(d.id);
  if (capArr) {
    d.order = parseInt(capArr.sequenceNumber, 10); // Ensure proper integer parsing

    // Assign position based on positionInParent
    const positionMapping = {
      Front: 2,
      Manage: 1,
      Back: 3
    };
    d.position = positionMapping[capArr.positioninParent] || 0; // Default to 0 if not matched
  }
});

// Sort the entire hierarchy recursively, including any childrenCaps
sortCaps(workingArray.busCapHierarchy);


				rationReport=responses[1].reports.filter((d)=>{return d.name=='appRat'});
  
				 let checkkey= false;
			 
				if(checkkey){$('#pmKey').show()}
				else{
					$('#pmKey').hide()
				}
				 
				 getArrayDepth(workingArray.busCapHierarchy);

			<!-- add org ids for all the related apps for filtering -->
				// Create a lookup map for applications to improve performance
				const applicationsMap = new Map(responses[1].applications.map(ap => [ap.id, ap.orgUserIds]));

				processToAppsMap = new Map();
 
				responses[1].applications.forEach(app => {
					if (!app.physP) return; // Skip if processes do not exist

					app.physP.forEach(process => {
						if (!processToAppsMap.has(process)) {
							processToAppsMap.set(process, []);
						}
						processToAppsMap.get(process).push({
							appId: app.id,
							appName: app.name
						});
					});
				});
  
				const capJumpOptions = [];

				workingArray.busCaptoAppDetails.forEach(d => {
					// Batch append option elements
					capJumpOptions.push($('&lt;option>', {
						value: d.id,
						text: d.name
					}));

					// Aggregate orgUserIds from applications
					const appOrgs = d.apps.flatMap(dap => applicationsMap.get(dap) || []);
					d.orgUserIds = [...new Set([...d.orgUserIds, ...appOrgs])]; // Ensure uniqueness
				});

				// Append all options to #capjump at once
				$('#capjump').append(capJumpOptions);

			 
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
				
				// Precompute maps for quicker lookups
				const codebaseMap = Object.fromEntries(appArray.codebase.map(e => [e.id, e]));
				const lifecycleMap = Object.fromEntries(appArray.lifecycles.map(e => [e.id, e]));
				const deliveryMap = Object.fromEntries(appArray.delivery.map(e => [e.id, e]));
				function mapValuesByValueClass(data) {
					return data.reduce((acc, item) => {
						acc[item.valueClass] = item.values.map(value => ({
							id: value.id,
							sequence: value.sequence,
							enum_name: value.enum_name,
							name: value.name,
							backgroundColor: value.backgroundColor,
							colour: value.colour
						}));
						return acc;
					}, {});
				}

				function getColourByValueClass(data, valueClass, valueId) {
					const valueClassData = data.find(item => item.valueClass === valueClass);
					if (!valueClassData) return null;
					
					const value = valueClassData.values.find(v => v.id === valueId);
					return value ? { backgroundColor: value.backgroundColor, colour: value.colour, name: value.enum_name } : null;
				}

				appArray.applications.forEach(d => {
					// Set default values
					const defaultColor = "#d3d3d3";
					const defaultTextColor = "#000";
					const defaultValue = "Not Set";
				
					// Optimise codebase assignment
					const thisCode = codebaseMap[d.codebaseID] || {};
					d.codebase = d.codebaseID ? thisCode.shortname : defaultValue;
					d.codebaseColor = d.codebaseID ? thisCode.colour : defaultColor;
					d.codebaseText = d.codebaseID ? thisCode.colourText : defaultTextColor;
				
					// Optimise lifecycle assignment
					const thisLife = lifecycleMap[d.lifecycle] || {};
					d.lifecycle = d.lifecycle ? thisLife.shortname : defaultValue;
					d.lifecycleColor = d.lifecycle ? thisLife.colour : defaultColor;
					d.lifecycleText = d.lifecycle ? thisLife.colourText : defaultTextColor;
				
					// Optimise delivery assignment
					const thisDelivery = deliveryMap[d.deliveryID] || {};
					d.delivery = d.deliveryID ? thisDelivery.shortname : defaultValue;
					d.deliveryColor = d.deliveryID ? thisDelivery.colour : defaultColor;
					d.deliveryText = d.deliveryID ? thisDelivery.colourText : defaultTextColor;
				
					// Deduplicate orgUserIds
					d.orgUserIds = [...new Set(d.orgUserIds)];
				
					// Aggregate application capabilities
					d.realises_application_capabilities = d.allServices.flatMap(s => s.capabilities);

					d['disposition'] = getColourByValueClass(filters, "Disposition_Lifecycle_Status", d.dispositionId);


				});
  
				let showInfo = 0;
				const businessCapabilitiesMap = new Map(
					responses[2].businessCapabilities?.map(e => [e.id, e.sequenceNumber]) || []
				);

				// Check if infoConcepts should be shown globally
				showInfo = workingArray.busCaptoAppDetails.some(bc => bc.infoConcepts.length > 1) ? 1 : 0;

				// Iterate over business capabilities efficiently
				workingArray.busCaptoAppDetails.forEach(bc => {
					// Retrieve and set the order from the precomputed map
					const sequenceNumber = businessCapabilitiesMap.get(bc.id);
					if (sequenceNumber !== undefined) {
						bc.order = Number(sequenceNumber); // Convert only if necessary
					}

					// Use flatMap for process mapping to reduce nesting
					processMap.push(...bc.processes.flatMap(bp => 
						bp.physP.map(pbp => ({
							pbpId: pbp,
							pr: bp.name,
							prId: bp.id
						}))
					));
					// Use flatMap for process mapping to reduce nesting
					processMap.push(...bc.processes.flatMap(bp => 
						bp.physP.map(pbp => ({
							pbpId: pbp,
							pr: bp.name,
							prId: bp.id
						}))
					));

					// Map app-to-cap relationships
					appToCap.push(...bc.processes.map(bp => ({
						procId: bp.id,
						bc: bc.name,
						bcId: bc.id
					})));
				});
 
processCountMap = processMap.reduce((acc, item) => {
					acc[item.prId] = (acc[item.prId] || 0) + 1;
					return acc;
				}, {});  

 			const appCountByPrId = new Map();

			processMap.forEach(({ pbpId, prId }) => {
				// Retrieve associated apps for this pbpId
				const apps = processToAppsMap.get(pbpId) || [];

				// If prId is not in map, initialise a new Set
				if (!appCountByPrId.has(prId)) {
					appCountByPrId.set(prId, new Set());
				}

				// Add appIds to the Set (ensures uniqueness)
				apps.forEach(app => appCountByPrId.get(prId).add(app.appId));
			});

			// Convert Set sizes to final count per prId
			 finalAppCountByPrId = {};
			appCountByPrId.forEach((appSet, prId) => {
				finalAppCountByPrId[prId] = appSet.size;
			});
 
				if(showInfo&gt;0){
					$('#viewOption').append($('&lt;option>', {
						value: 'data',
						text: '<xsl:value-of select="eas:i18n('Information Overlay')"/>'
					}));	
				}

				$('#viewOption').append($('&lt;option>', {
						value: 'criticality',
						text: '<xsl:value-of select="eas:i18n('Processes')"/>'
					}));		
 
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
				let dls=allFilters.find((f)=>{
					return f.valueClass=='Disposition_Lifecycle_Status';
				})
		 
				if(dls.values?.length == 4){
					timeAvailable=1;
					$('.showTime').show()
				}else{
					timeAvailable=0;
					$('.showTime').hide()
				}
            
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
                    getHermModel();
				} 
            }
			
			if (styleSetting !== '2') {
		 
				var spanElement = document.getElementById('recipeTitle');
				if (spanElement) {
					spanElement.textContent = '<xsl:value-of select="eas:i18n('Goal')"/>';
				}  

				$(`.goalpill`).removeClass(`goalpillsmall`);
			}else{ 
				$('#herm').prop('checked', true)
				getHermModel();
			}
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
					 
				essInitViewScoping	(redrawView, classesToShow, allFilters, true);
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
		

			}). catch (function (error)
			{
				//display an error somewhere on the page
			});
			
			let scopedApps=[]; 	
			let inScopeCapsApp=[];
			let scopedCaps=[];
			let scopedProcesses=[]; 

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

	panelData.apps.forEach((d) => {
		// Remove duplicates using a Set for efficiency
		d.capsList = [...new Map(d.caps.map(item => [item.id, item])).values()];
		d.processList = [...new Map(d.processes.map(item => [item.id, item])).values()];

		//if (!app.processes) return; // Skip if processes do not exist

    	

	});

	$('#appData').html(appTemplate(panelData));

	workingAppsList=appArrayToShow;

	$('#appsList').empty();
 
	panelData.apps.sort((a, b) => (a.name > b.name) ? 1 : -1)
  
	$('#appsList').html(appListTemplate(panelData))
 
	// logic in case we have no catagory data
    const hasUndefined = categories.some(element => element === undefined);

    if(!hasUndefined){
		// react to sliders
        updateChart(workingAppsList);
        d3.selectAll('.service-checkbox, .service-slider').on('change', function () {
          
            selectedServices = d3.selectAll('.service-checkbox:checked').nodes().map(node => node.value);
            updateChart(workingAppsList);
        });
    }else{
		// just show chart with disposition
		updateChart(workingAppsList);
		
	}
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
			$(this).parent().append('<button type="button" aria-label="reset" class="btn reset-btn btn-xs"><xsl:value-of select="eas:i18n('Reset')"/></button>');

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
		
		let side = $("#appSidenav").css('margin-right');
	
		if(side=='-452px'){ 
		
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
			
			// Create a lookup map for application services
			const serviceMap = new Map(
				svsArray.application_services.flatMap(sv =>
					sv.aprs.map(aprId => [aprId, sv.name])
				)
			);

			thisAllServs.forEach(e => {
				const matchedName = serviceMap.get(e.id);
				if (matchedName) {
					e.name = matchedName;
				}
			});

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

            $(".showTime").on('click', function(){
                $('#timeModal').modal('show')
            })

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
			if (workLeft.allOrgsInScope) { 
				const orgsInScopeSet = new Set(workLeft.allOrgsInScope);

				// Iterate over thisAppArray and match against the Set
				thisAppArray.forEach(ap => {
					const hasMatch = ap.orgUserIds.some(orgId => orgsInScopeSet.has(orgId));
					if (hasMatch) {
						leftMatch.push(ap);
					}
				});
			} 
		}
		let rightMatch=[];
		if(workRight){
			if (workRight.allOrgsInScope) {
				const orgsInScopeSet = new Set(workRight.allOrgsInScope);
				// Iterate over thisAppArray and match against the Set
				thisAppArray.forEach(ap => {
					const hasMatch = ap.orgUserIds.some(orgId => orgsInScopeSet.has(orgId));
					if (hasMatch) {
						rightMatch.push(ap);
					}
				});
			} 
			<!--
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
			-->
		} 
		let allApps=[...rightMatch, ...leftMatch];
		let rowToShow=[]; 
		// Create maps for quick lookups
		const thisAppMap = new Map(thisAppArray.map(a => [a.id, a]));
		const leftMatchSet = new Set(leftMatch.map(la => la.id));
		const rightMatchSet = new Set(rightMatch.map(ra => ra.id));

		// Pre-fetch the selected text from dropdowns
		const leftOrgListText = $('#leftOrgList :selected').text();
		const rightOrgListText = $('#rightOrgList :selected').text();

		allApps.forEach(ap => {
			const thisApp = thisAppMap.get(ap.id);

			if (!thisApp) return; // Skip if app is not in thisAppArray

			// Set left status
			thisApp.left = leftMatchSet.has(ap.id)
				? 'true'
				: leftOrgListText === 'None'
				? 'true'
				: 'false';

			// Set right status
			thisApp.right = rightMatchSet.has(ap.id)
				? 'true'
				: rightOrgListText === 'None'
				? 'true'
				: 'false';

			rowToShow.push(thisApp);
		}); 
		
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
			
			// Filter scopedCaps.resources to get only items whose id is in the combined Set
			let filteredItems = scopedCaps.resources.filter(item => combinedCaps.has(item.id));
	
			let contributionsYes=false;
		
			// Update the HTML content with the filtered items using the recipeTemplate

		 const capMap = filteredItems.reduce((acc, cap) => {
			acc[cap.id] = cap.name;
			return acc;
		}, {});

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

            // Add 'capColour' class to elements for all combined caps
			combinedCaps.forEach(e => {
			    $(`.capBox[eascapid="${e}"]`).addClass('capColour');
				$(`.buscap[eascapid="${e}"]`).addClass('capColour');
			});
			
		}
		else{
			$('#recipeList').html(recipeTemplate(selected));
			selected.contributions.forEach((d, index)=>{
			
				d.relatedCaps.forEach((c)=>{
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


	$('.process-circle').on("click", function ()
	 {  
  
		let processCap=$(this).attr('easidprocess');
	
		let focusCap=workingArrayAppsCaps.find((e)=>{
			return e.id==processCap;
		}); 
  
		let side = $("#appSidenav").css('margin-right');
			
			const busCriticalityMap = new Map(busCriticalityValues.values.map(d => [d.id, d]));

			// Process filteredProcesses efficiently 
			focusCap.filteredProcesses.forEach(s => {
				s['appCount'] = finalAppCountByPrId[s.id] || 0;
				s['count'] = processCountMap[s.id] || 0;

				const match = busCriticalityMap.get(s.criticalityId) || {}; // Get match or default empty object

				if (!s.criticality) s.criticality = 'Not Set'; // Fix assignment issue (should be == instead of =)
				
				s.colour = match.colour || '#ffffff'; // Default to white if no match
				s.backgroundColor = match.backgroundColor || 'grey'; // Default to grey if no match
				 <xsl:if test="$isEIPMode='true'">
					let viewAPIProcessInfo= '<xsl:value-of select="$viewerAPIPathInstance"/>&amp;PMA='+s.id; 
		 			promise_loadViewerAPIData(viewAPIProcessInfo)
						.then(function(response) { 
								 const instance = response.instance.find(inst => inst.name === "defining_business_process_flow");
								if (instance &amp;&amp; instance.values.length > 0) {
								 
									let viewAPIFlowInfo= '<xsl:value-of select="$viewerAPIPathInstance"/>&amp;PMA='+instance.values[0].id; 
		 							promise_loadViewerAPIData(viewAPIFlowInfo)
									.then(function(response) { 
										const diagramInstance = response.instance.find(inst => inst.name === "ea_diagrams");

										if (diagramInstance &amp;&amp; diagramInstance.values &amp;&amp; diagramInstance.values.length > 0) {
											$('.processInfoButton[easidProcessButton="' + s.id +'"]').show()
											$('.processInfoButton[easidProcessButton="' + s.id +'"]').attr('diagramid', diagramInstance.values[0].id);
										}else{
											$('.processInfoButton[easidProcessButton="' + s.id +'"]').hide()
										}
									})
								}else{
										$('.processInfoButton[easidProcessButton="' + s.id +'"]').hide()
								}
								$('.processInfoButton').off().on('click', function(){
									let procName=$(this).attr('processname');
									$('#processName').text(procName);
									let selectedProcess=$(this).attr('easid')
									let selectedDiagram=$(this).attr('diagramid') 
	
									let diagramtoShow={"id": selectedDiagram}
										
									refreshDiagram(diagramtoShow) 
									
									$('#processModal').modal('show');  
								})
	
						})

						</xsl:if>
			});
	
		if(side=='-452px'){ 
		
			$('.appRatButton').hide();
			 $('#appsList').html(processTemplate(focusCap))
			openNav(); 
			workingCapId=processCap; 

			
		}
		else{
			closeNav();
		}
		return false; //stop propogation	

		
	});

}
<xsl:if test="$isEIPMode = 'true'">
function refreshDiagram(aDiagram) {
 
    showEditorSpinner('Loading diagram...');
    essPromise_getAPIElement('/essential-core/v1', 'diagrams', aDiagram.id, 'Diagram')
    .then(function(response) {
	 
		removeEditorSpinner();
        drawBPMN(response.config); 
		 
		$('#processModal').focus();
		$('.closeModal').on('click', function(){
			 
		})
		return;
    })
    .catch(function (error) {
        removeEditorSpinner();
        console.log(error);
        //Show an error message: error
    });
}
function drawBPMN(bpmnData) {
	<xsl:if test="$eipMode">
    document.getElementById('paper-container').appendChild(paperScroller.el);
    const container = document.getElementById('paper-container');

    paperScroller.setCursor('grab'); 
    graph.fromJSON(bpmnData);

    paper.fitToContent({
        padding: 5,
        minWidth: 800,
        minHeight: 600,
        allowNewOrigin: 'any'
    });

    setTimeout(() => {
        paper.scaleContentToFit({
            padding: 5, 
            minScale: 0.1, 
            maxScale: 1, 
            preserveAspectRatio: true
        });
        paperScroller.center();
    }, 300);

    // Enable paper dragging when clicking on the background
    paper.on('blank:pointerdown', function(event, x, y) {
        paperScroller.startPanning(event);
    });

    // Fix zooming
    paperScroller.el.addEventListener('wheel', function(event) {
	
        event.preventDefault(); // Prevent default scrolling

        if (event.ctrlKey || event.metaKey) {
            // Zoom in or out
            let delta = event.deltaY > 0 ? -0.1 : 0.1;
            let newScale = Math.max(0.2, Math.min(paperScroller.zoom() + delta, 2));

            paperScroller.zoom(newScale, { absolute: true, grid: 0.05 });
        } else {
            // Scroll normally if no modifier key is pressed
            paperScroller.el.scrollBy({
                top: event.deltaY,
                left: event.deltaX,
                behavior: 'smooth'
            });
        }
    });

    // Fix container scrolling
    document.getElementById('paper-container').style.overflow = 'auto';
		</xsl:if>
}
</xsl:if>
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
	let a2rDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION');
	let msDef = new ScopingProperty('ms_managed_app_elements', 'Managed_Service');
	let acDef = new ScopingProperty('realises_application_capabilities', 'Application_Capability');
 

		 if(appArray){
			apps=appArray.applications;

			if($('#retired').is(":checked")==false){
				apps= apps.filter((d)=>{
					return d.lifecycle != "Retired";
				})
			}
		 }else{
			apps=[]
		 }
	scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef,a2rDef, msDef, acDef].concat(dynamicAppFilterDefs), appTypeInfo);
	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef].concat(dynamicCapFilterDefs), busCapTypeInfo);
	scopedProcesses = essScopeResources(uniqueProcesses, [], busCapTypeInfo);

	inScopeCapsApp=scopedCaps.resources; 
   
	// Convert scopedApps.resourceIds to a Set for faster lookups
		const scopedAppIdsSet = new Set(scopedApps.resourceIds);
		idToAppsCountMap = new Map();

		workingArrayAppsCaps.forEach(d => {
			// Filter apps using the Set for lookups
			d.filteredApps = d.apps.filter(id => scopedAppIdsSet.has(id));
			idToAppsCountMap.set(d.id, d.filteredApps);
		}); 

		const scopedProcessIdsSet = new Set(scopedProcesses.resourceIds);
		let idToProcessCountMap = new Map();

		const selectedCriticalities = new Set($('#busCriticalitiesSelect').val())
 
		workingArrayAppsCaps.forEach(d => {
			const filteredProcesses = d.allProcesses.filter(process => 
				scopedProcessIdsSet.has(process.id) &amp;&amp;
				(!processCriticalities || selectedCriticalities.has(process.criticalityId))
			);

			idToProcessCountMap.set(d.id, filteredProcesses);
			d.filteredProcesses = filteredProcesses;
		});

  
let workingMatchedBuscapAndProcessIds = Object.fromEntries(idToProcessCountMap);

	// Ensure every resource ID has an entry in workingMatchedBuscapAndPlanIds
	scopedCaps.resourceIds.forEach(id => { 
		if (!(id in workingMatchedBuscapAndPlanIds)) {
			workingMatchedBuscapAndPlanIds[id] = [];
		}
		if (!(id in workingMatchedBuscapAndProcessIds)) {
			workingMatchedBuscapAndProcessIds[id] = [];
		} 
	});
 
	// using pure JS for speed
	const elements = document.querySelectorAll('.proj-circle, .process-circle');
	for (let i = 0; i &lt; elements.length; i++) {
		elements[i].textContent = '0';
	}
 
    for (const key of Object.keys(matchedBuscapAndPlanIds)) {
		const element = document.querySelector(`span.proj-circle[easidproj="${key}"]`);
		if (element) {
			element.textContent = matchedBuscapAndPlanIds[key].length;
		}
	}

	for (const key of Object.keys(workingMatchedBuscapAndProcessIds)) {
		const element = document.querySelector(`span.process-circle[easidprocess="${key}"]`);
		if (element) {
			element.textContent = workingMatchedBuscapAndProcessIds[key].length;
		}
	}
 
	inScopeCapsApp=scopedCaps.resources;  

	let appMod = new Promise(function(resolve, reject) { 
	 	resolve(appsToShow['applications']=scopedApps.resources);
		 reject();
	});

	appMod.then((d)=>{
	 
		
		// Precompute lookup maps for faster access
		const processMapByPbpId = new Map(
			processMap.map(php => [php.pbpId, { id: php.prId, name: php.pr }])
		);
		const appToCapMap = new Map(
			appToCap.map(ac => [ac.procId, { id: ac.bcId, name: ac.bc }])
		);

		appsToShow.applications.forEach(d => {
			const procsForApp = new Set();
			const capForApp = new Set();

			d.physP.forEach(pp => {
				const process = processMapByPbpId.get(pp);
				if (process) {
					procsForApp.add(JSON.stringify(process));

					// Find capabilities related to this process
					const cap = appToCapMap.get(process.id);
					if (cap) {
						capForApp.add(JSON.stringify(cap));
					}
				}
			});

			// Convert sets back to arrays and parse the JSON to restore objects
			d.processes = Array.from(procsForApp).map(proc => JSON.parse(proc));
			d.caps = Array.from(capForApp).map(cap => JSON.parse(cap));
		});


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
 
	updateCapabilitiesWithAppCounts(workingArrayBusCapHierarchy, idToAppsCountMap);
	  
	<!-- filter when root changes-->
 
	$('#subrootcap').off().on('change', function(){
		
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
		  const elements = inScopeCapsApp.map(e => `*[easidscore="${e.id}"]`).join(',');
		  $(elements).parent().removeClass("off-cap");

		// Precompute a map for appArray.applications for faster lookups
		const appMap = new Map(appArray.applications.map(app => [app.id, app]));

		 workingArrayAppsCaps.forEach(d => {
			let compareScoreA = 0;
			let compareScoreB = 0;

			// Resolve the apps for this filteredApps array
			const thisAppArray = d.filteredApps.map(appId => appMap.get(appId)).filter(Boolean);

			if (workLeft) {
				const orgsInScopeSet = new Set(workLeft.allOrgsInScope); // Use a Set for faster lookup
				const capMatch = new Set(); // Use a Set to avoid duplicate matches

				thisAppArray.forEach(app => {
					app.orgUserIds.forEach(orgId => {
						if (orgsInScopeSet.has(orgId)) {
							capMatch.add(orgId);
							compareScoreA = 1;
						}
					});
				});
			}

			if (workRight) {
				const orgsInScopeSet = new Set(workRight.allOrgsInScope); // Use a Set for faster lookup
				const capMatch = new Set();

				thisAppArray.forEach(app => {
					app.orgUserIds.forEach(orgId => {
						if (orgsInScopeSet.has(orgId)) {
							capMatch.add(orgId);
							compareScoreB = 1;
						}
					});
				});
			}

			// Compute the combined compare score
			const compareScoreAll = compareScoreB + compareScoreA;

			// Select the target element once and apply changes
			const $element = $(`*[easidcompare="${d.id}"]`);
			$element.removeClass('bothAppColour leftAppColour rightAppColour');

			if (compareScoreAll > 0) {
				if (compareScoreAll === 2) {
					$element.html('B').addClass('bothAppColour').css("color", "#7438A4");
				} else if (compareScoreA === 1) {
					$element.html('1').addClass('leftAppColour').css("color", "#24A5F4");
				} else {
					$element.html('2').addClass('rightAppColour').css("color", "#1FC1B4");
				}
			} else {
				$element.html('?').css("color", "#fff");
			}
		});


		workingArrayAppsCaps.forEach(d => {
			const appCount = d.filteredApps.length;
		
			// Select elements once
			const $scoreElement = $(`*[easidscore="${d.id}"]`);
			const $capElements = $(`*[eascapid="${d.id}"]`);
		
			// Update app count display
			$scoreElement.html(appCount);
		
			let colour = '#fff';
			const textColour = '#fff';
		
			if (appCount !== 0) {
				$capElements.parent().removeClass("off-cap");
			} else {
				colour = '#d3d3d3';
				$capElements.each(function () {
					if ($(this).hasClass('buscap')) {
						$(this).addClass('off-cap');
					}
				});
			}
		
			if (appCount > 0 &amp;&amp; appCount &lt; 2) {
				colour = '#EDBB99';
			} else if (appCount >= 2 &amp;&amp; appCount &lt; 6) {
				colour = '#BA4A00';
			} else if (appCount >= 6) {
				colour = '#6E2C00';
			}
		
			// Update styles for score element
			$scoreElement.css({ 'background-color': colour, 'color': textColour });
		});

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
			 let elementsToShow = inScopeCapsApp.map(d => `div[eascapid="${d.id}"]`).join(',');
			 if (elementsToShow) {
				$(elementsToShow).each(function () {
					$(this).parents().show(); // Show parent elements
					$(this).show(); // Show the element
				});
			}
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

$('.maturityClr').on('click', function(){

	$('.buscap').removeAttr("style");
	
})

$('#kpiSelection, input[name="kpiOption"]').off('change').on('change', function(){
	$(`.buscap`).removeAttr('style');
		var selectedValue = $('input[name="kpiOption"]:checked').val();
		//console.log('selectedValue',selectedValue)
 
		//console.log('buskpiDataperfCategory',	buskpiData?.perfCategory)
		// Preserve the original myBusKPIs
		let allKpis = JSON.parse(JSON.stringify(myBusKPIs)); 

		// Filter applications based on scopedApps
		allKpis.applications = allKpis.applications.filter(app => 
			scopedApps.resources.some(scopedApp => scopedApp.id === app.id)
		);
		allKpis.processes = allKpis.processes.filter(proc => 
			scopedProcesses.resources.some(scopedProc => scopedProc.id === proc.id)
		);
		 
		const categoryIdToFilter = $('#kpiSelection').val();
		const selectedText = $('#kpiSelection option:selected').text();
		$('#kpiName').text(selectedText)  ;
		const filteredData = getPerfData(allKpis[selectedValue], categoryIdToFilter);
	 
		//loop data here
		function findClosestPastDate(data) { 
			const closestDate = data?.dates.find(dateItem => dateItem.isClosestPastDate === true);
				return closestDate ? closestDate : null; // Return the date if found, otherwise return null
			
		}

		function getAverageScore(serviceQuals) {
			const total = serviceQuals.reduce((sum, qual) => sum + qual.score, 0);
			return total / serviceQuals.length;
		  }
 
		if(selectedValue=='businessCapabilities'){
		 
			let busCaps = buskpiData?.perfCategory?.filter(b => b.classes?.includes('Business_Capability'));
			 
			let tableData=[]
			  
				scopedCaps.resourceIds.forEach((e) => {
					let match =	filteredData.find((c)=>{
						return c.id==e
					})
				
					let closestDate;
					if(match){
							closestDate = findClosestPastDate(match);
						if(closestDate==null){
							closestDate = match.dates[0];
						}

						closestDate?.serviceQuals?.forEach((f)=>{
							f['normalised_score']=sqvsMap.get(f.id).normalisedScore
						})
					
						const totalScore = closestDate?.serviceQuals.reduce((sum, item) => sum + item.normalised_score, 0);
						// Calculate the average score
						const averageScore = totalScore / closestDate.serviceQuals.length;
						closestDate['averageScore']=averageScore;
						
						let colour=sqvsMap.get(closestDate.serviceQuals[0].id);
						let cat=alSQ.find((c)=>{
							return c.id==closestDate.serviceQuals[0].service_quality_type;
						})
					
						const matchingSqv = cat.sqvs.find((d) => {
							return Number(d.score) === Math.round(averageScore);
						});
						
						if(matchingSqv){
							closestDate['colour']=matchingSqv.elementColour ?? '#00000';;
							closestDate['bgColour']=matchingSqv.elementBackgroundColour  ?? '#d3d3d3';;
						}

						if (!closestDate['bgColour']) {  // Check if closestDate['colour'] is empty
							closestDate['bgColour'] = colourPalette[(Math.round(averageScore)-1)];
							closestDate['colour'] = colourPaletteText[(Math.round(averageScore)-1)];
							
						} 
						<!-- override colours for now-->
						closestDate['bgColour'] = colourPalette[(Math.round(averageScore)-1)];
						closestDate['colour'] = colourPaletteText[(Math.round(averageScore)-1)];
					
						$(`.buscap[eascapid="${e}"]`).css({'background-color':closestDate.bgColour, 'color':closestDate.colour});
						
						tableData.push({"id": match.id, "name": match.name, "score": Math.round(averageScore)})
					}
					
			});

			tableData = tableData.sort((a, b) => a.name.localeCompare(b.name));
			$('#maturityTable').html(maturityTemplate(tableData))
			registerMaturity(tableData)
		}else if(selectedValue=='processes'){
			//consolidate processes by bus cap, find av score for processes, score cap
		 
			let tableData=[]
			scopedCaps.resources.forEach((p)=>{ 
					let thisKPIscore=[]
					let svqId;
					let processtableData=[]
 	
					p.allProcesses?.forEach((s)=>{ 
						let match =	filteredData.find((c)=>{
							return c.id==s.id
						})
	
						if(match?.dates){
							const lastDateObj = findClosestPastDate(match);
	  
							if (lastDateObj) {
								svqId=lastDateObj.serviceQuals[0].service_quality_type
	
							const avgScore = getAverageScore(lastDateObj.serviceQuals);

							processtableData.push({"id": match.id, "name": match.name, "score":  Math.ceil(avgScore)})

							thisKPIscore.push(avgScore)
							} else {
								svqId=match.dates[0].serviceQuals[0].service_quality_type
								const avgScore = getAverageScore(match.dates[0].serviceQuals);
								thisKPIscore.push(avgScore)
								processtableData.push({"id": match.id, "name": match.name, "score":  Math.ceil(avgScore)})
							}
						}
						
					})
					if(thisKPIscore.length&gt;0){
						p['processScore']=Math.round(thisKPIscore.reduce((acc, val) => acc + val, 0) / thisKPIscore.length);
					}else{
						p['processScore']=0
					}  
 
					if(svqId){
					let colour=serviceQualityMap[svqId]; 
				 	let col=colour?.find((e)=>{return e.score==p.processScore;}) ||{}
		 
				/*
						 if (!col) {   
							 col['elementBackgroundColour'] = colourPalette[(Math.round(p.processScore)-1)];
							 col['elementColour'] = colourPaletteText[(Math.round(p.processScore)-1)];
							 
						} 
						 if (!col['elementBackgroundColour']) {  
							col['elementBackgroundColour'] = colourPalette[(Math.round(p.processScore)-1)];
							col['elementColour'] = colourPaletteText[(Math.round(p.processScore)-1)];
						} 
						 
						
							if (!col.elementBackgroundColour || col.elementBackgroundColour === "") {
								col.elementBackgroundColour = colourPalette[Math.round(p.processScore) - 1];
								col['elementColour'] = colourPaletteText[(Math.round(p.processScore)-1)];
							}
				*/
							if(p.processScore){ 
								<!-- override colours for now-->
 								col['elementBackgroundColour'] = colourPalette[(Math.round(p.processScore)-1)];
							 	col['elementColour'] = colourPaletteText[(Math.round(p.processScore)-1)];
								$(`.buscap[eascapid="${p.id}"]`).css({'background-color':col.elementBackgroundColour, 'color':col.elementColour});
							}
						 
					}
					tableData.push({"id": p.id, "name": p.name, "score": p.processScore, "processes": processtableData})
					 
			})
		 
		tableData = tableData.sort((a, b) => a.name.localeCompare(b.name));
		$('#maturityTable').html(maturityTemplate(tableData))
		registerMaturity(tableData)

		}else if(selectedValue=='applications'){
			//consolidate apps by bus cap, find av score for processes, score cap
			let tableData=[] 
			scopedCaps.resources.forEach((p)=>{ 
					let thisKPIscore=[]
					let svqId;
					let appstableData=[]
					p.apps?.forEach((s)=>{
						let match =	filteredData.find((c)=>{
							return c.id==s
						})
					 
						if(match?.dates){
							const lastDateObj = findClosestPastDate(match);
						 
							
							if (lastDateObj) {
								svqId=lastDateObj.serviceQuals[0].service_quality_type
							const avgScore = getAverageScore(lastDateObj.serviceQuals);
							appstableData.push({"id": match.id, "name": match.name, "score": Math.ceil(avgScore)})
							thisKPIscore.push(avgScore)
							} else {
								svqId=match.dates[0].serviceQuals[0].service_quality_type
								const avgScore = getAverageScore(match.dates[0].serviceQuals);
								thisKPIscore.push(avgScore)
								appstableData.push({"id": match.id, "name": match.name, "score":  Math.ceil(avgScore)})
							}
						}

					})
					if(thisKPIscore.length&gt;0){
					p['appsScore']=Math.round(thisKPIscore.reduce((acc, val) => acc + val, 0) / thisKPIscore.length);
					}else{
						p['appsScore']=0
					}  
 
					if(svqId){
					let colour=serviceQualityMap[svqId]; 
					let col=colour?.find((e)=>{return e.score==p.appsScore;}) ||{}
						 
						 if (!col) {   
							 col['elementBackgroundColour'] = colourPalette[(Math.round(p.appsScore)-1)];
							 col['elementColour'] = colourPaletteText[(Math.round(p.appsScore)-1)];
							 
						} 
						 if (!col['elementBackgroundColour']) {  
							col['elementBackgroundColour'] = colourPalette[(Math.round(p.appsScore)-1)];
							col['elementColour'] = colourPaletteText[(Math.round(p.appsScore)-1)];
						} 
						 
						
							if (!col.elementBackgroundColour || col.elementBackgroundColour === "") {
								col.elementBackgroundColour = colourPalette[Math.round(p.appsScore) - 1];
								col['elementColour'] = colourPaletteText[(Math.round(p.appsScore)-1)];
							}

							<!-- override colours -->
							if(p.appsScore){ 
 								col['elementBackgroundColour'] = colourPalette[(Math.round(p.appsScore)-1)];
							 	col['elementColour'] = colourPaletteText[(Math.round(p.appsScore)-1)];
								$(`.buscap[eascapid="${p.id}"]`).css({'background-color':col.elementBackgroundColour, 'color':col.elementColour});
							}
						 
					}
					tableData.push({"id": p.id, "name": p.name, "score": p.appsScore, "apps": appstableData})	
					 
			}) 

			tableData = tableData.sort((a, b) => a.name.localeCompare(b.name));
			$('#maturityTable').html(maturityTemplate(tableData))
 			registerMaturity(tableData)
		}
		//$('#kpiSelection').val(categoryIdToFilter).select2({width:'200px'})
})

function registerMaturity(dataForCaps){

	$('.maturityCircle').on('click', function(){
		let selectedCap=$(this).attr('easid');
		$("#modal-overlay").fadeIn(300);
		$("#maturitymodal").css("height", "0").show().animate({
			height: "400px"
		}, 500);

		let match=dataForCaps.find((e)=>{return e.id==selectedCap})
		$('#listForMaturity').html(maturityListTemplate(match))
	 

		$("#maturity-close-btn, #modal-overlay").click(function () {
			$("#maturitymodal").animate({
				height: "0"
			}, 500, function () {
				$("#maturitymodal").hide();
				$("#modal-overlay").fadeOut(300);
			});
		});
	
	})

}

$('.maturity').on('click', function(){
		
		
		allKpis =  myBusKPIs;
		const categoryIdToFilter = "store_681_Class200000";
 
		// filter out KPIs for the selected category, define the property to filter the data for.
		const filteredData = getPerfData(allKpis.businessCapabilities, categoryIdToFilter);
	  
		scopedCaps.resourceIds.forEach((e) => {
			 
		let match =	filteredData.find((c)=>{
			return c.id==e
		})
  
		function findClosestPastDate(data) { 
			const closestDate = data?.dates.find(dateItem => dateItem.isClosestPastDate === true);
				return closestDate ? closestDate : null; // Return the date if found, otherwise return null
			 
		}
		
 
		let closestDate;
		if(match){ 
				 closestDate = findClosestPastDate(match);
			if(closestDate==null){
				  closestDate = match.dates[0];
			}

			closestDate?.serviceQuals?.forEach((f)=>{
				f['normalised_score']=sqvsMap.get(f.id).normalisedScore
			})
		
			const totalScore = closestDate?.serviceQuals.reduce((sum, item) => sum + item.normalised_score, 0);
			// Calculate the average score
			const averageScore = totalScore / closestDate.serviceQuals.length;
			closestDate['averageScore']=averageScore;
			
			let colour=sqvsMap.get(closestDate.serviceQuals[0].id);
			let cat=alSQ.find((c)=>{
				return c.id==closestDate.serviceQuals[0].service_quality_type;
			})
		 
			const matchingSqv = cat.sqvs.find((d) => {
				return Number(d.score) === Math.round(averageScore);
			});

			closestDate['colour']=matchingSqv.elementColour;
			closestDate['bgColour']=matchingSqv.elementBackgroundColour;

			if (!closestDate['bgColour']) {  // Check if closestDate['colour'] is empty
				closestDate['bgColour'] = colourPalette[(Math.round(averageScore)-1)];
			} 
			
			$(`.buscap[eascapid="${e}"]`).css({'background-color':closestDate.bgColour, 'color':closestDate.colour});
			
		}
		
	});
 
})		

}

function redrawView() {
	essRefreshScopingValues()
} 

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
			document.getElementById("appSidenav").style.marginRight = "-452px";
		}

		function openKpiNav()
		{	
			document.getElementById("kpiSidenav").style.marginRight = "0px";
		}


		function openCriticalityNav(){
			document.getElementById("processSidenav").style.marginRight = "0px";
		}
		
		function closeKpiNav()
		{
			workingCapId=0;
			document.getElementById("kpiSidenav").style.marginRight = "-552px";
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

		
function getQualityDetailsBySelectedCategories(categories, selectedCategoryIds, qualitiesDetails) {
    const selectedCategories = categories
    .filter(category => selectedCategoryIds.includes(category.id))
    .flatMap(category => category.qualities);

const uniqueQualityIds = [...new Set(selectedCategories)];

return uniqueQualityIds.map(qualityId => {
    const quality = qualitiesDetails.find(q => q.id === qualityId);
    return quality ? quality.name : null;
}).filter(name => name !== null);
}

function calculateScores(applications, categories) {
    const sliderValues = d3.selectAll('.service-slider').nodes().reduce((acc, slider) => {
        acc[slider.getAttribute('data-service')] = parseFloat(slider.value);
        return acc;
    }, {});
 
    const processedApplications = applications.map(app => {
        const categoryScores = {};

        categories.forEach(cat => {
            const categoryScore = app.categoryScores.find(score => score.categoryId === cat);
            if (categoryScore) {
                const filteredScores = categoryScore.scores.filter(score => selectedServices.includes(score.service));
                const weightedSum = filteredScores.reduce((acc, cur) => acc + (cur.score * sliderValues[cur.service]), 0);
                const totalWeight = filteredScores.reduce((acc, cur) => acc + sliderValues[cur.service], 0);
                const averageScore = weightedSum / totalWeight || 0;

                const latestScores = filteredScores.filter(e => e.isLatest === true);
                const latestScoreSum = latestScores.reduce((sum, item) => sum + item.score, 0);
                const latestScoreAvg = latestScores.length > 0 ? latestScoreSum / latestScores.length : 0;

                if (!categoryScores[cat]) {
                    categoryScores[cat] = {};
                }

                categoryScores[cat]['latest'] = parseFloat(latestScoreAvg.toFixed(1));
                categoryScores[cat]['all'] = averageScore;
            }
        });

        return {
            id: app.id,
            techScoreAll: categoryScores[categories[0]]?.all ?? 0,
            techScore: categoryScores[categories[0]]?.latest ?? 0,
            busScoreAll: categoryScores[categories[1]]?.all ?? 0,
            busScore: categoryScores[categories[1]]?.latest ?? 0
        };
    });

    // Find highest scores for reweighting
    let maxTechScore = Math.max(...processedApplications.map(app => app.techScore));
    let maxBusScore = Math.max(...processedApplications.map(app => app.busScore));
	//set the mimum level for score if highest value is less than 5 
	if(maxTechScore &lt; 5){maxTechScore=5}
	if(maxBusScore &lt; 5){maxBusScore=5}
 
    // Reweight scores and add totalWeightedScore
    return processedApplications.map(app => {
        const weightedTechScore = (app.techScore / maxTechScore) * 5;
        const weightedBusScore = (app.busScore / maxBusScore) * 5; 

        return {
            ...app,
            weightedTechScore: parseFloat(weightedTechScore.toFixed(2)),
            weightedBusScore: parseFloat(weightedBusScore.toFixed(2)), 
        };
    });
}


function updateChart(apps) {

    $('#app-scores-list').empty();
    showFullAppScores(apps)
 
	dispositionLifecycleStatus = new Map();
	filters.find(e => e.id === 'Disposition_Lifecycle_Status').values.forEach(item => {
		dispositionLifecycleStatus.set(item.id, {
			id: item.id,
			name: item.name,
			enum_name: item.enum_name,
			sequence: parseInt(item.sequence, 10),
			backgroundColor: item.backgroundColor,
			colour: item.colour
		});
	});
	const dispArray = Array.from(dispositionLifecycleStatus.values());
 
	let categoriesOrder = [];
	dispArray.forEach((e)=>{
		categoriesOrder.push(e)
	})
  
	categoriesOrder = categoriesOrder.sort((a, b) => {
	    const aSequence = isNaN(a.sequence) ? null : a.sequence;
    	const bSequence = isNaN(b.sequence) ? null : b.sequence;

		if (aSequence === null) return -1;  // If a.sequence is NaN or null, it should go after b
		if (bSequence === null) return 1; // If b.sequence is NaN or null, a should go before b
		return aSequence - bSequence;      // Otherwise, sort by sequence number
	});

	$('#dispositionKey').html(dispkeyTemplate(dispArray))

	$('#dispoCircle').on('mouseover', function() {
        $('#dispoInfoCircle').show(); // 500 milliseconds equals 0.5 seconds
    });

	$('#dispoCircle').on('mouseout', function() {
        $('#dispoInfoCircle').delay(3000).fadeOut(1500); // 500 milliseconds equals 0.5 seconds
    });
 

    // Load data and draw the chart
 
	if(appKPIsformat){
 
    appKPIs = calculateScores(appKPIsformat, categories);
 
		$('.timeInfo, .service-selection').show()
	}else{
		appKPIs=apps
		$('.timeInfo, .service-selection').hide()
	}
 
 
 const data = apps.map(d => {
    const scores = appKPIs.find(app => app.id === d.id);
 
    const disposition = dispositionLifecycleStatus.get(d.ap_disposition_lifecycle_status[0]);
    const sequence = disposition?.sequence || 0;
    const techScore = scores?.weightedTechScore !== undefined ? scores.weightedTechScore : sequence;
    const busScore = scores?.weightedBusScore !== undefined ? scores.weightedBusScore : sequence;
    
    return { 
        name: d.name, 
        id: d.id, 
        techScore, 
        busScore, 
        quadrant: sequence, 
        disposition: disposition?.backgroundColor,
        basedOnDisposition: scores?.techScore === undefined || scores?.busScore === undefined
    };
}).filter(d => d.techScore !== undefined &amp;&amp; d.busScore !== undefined);
 
 
if(timeAvailable == 1 || timeAvailable==0){
 
if(dispArray.length==4){
	data.forEach((e)=>{
		if(e.basedOnDisposition == true){
			let match=categoriesOrder.find((f)=>{
				return f.sequence == e.quadrant;
			})
			 
			if(match){ 
				let range=0;
				let busrange=0;
			
				if(match.sequence==1){
					range = 1.25;
					busrange = 3.75;
				}else if(match.sequence==2){
					range = 3.75;
					busrange = 3.75;
				}else if(match.sequence==3){
					range = 3.75;
					busrange =1.25;
				}else if(match.sequence==4){
					range = 1.25;
					busrange = 1.25;
				} 
				e.techScore=range;
				e.busScore=busrange;
			}else{ 
				e.techScore=0.1;
				e.busScore=0.1;
			}
		}
	})

    const svg = d3.select('svg');
    const width = +svg.attr('width');
    const height = +svg.attr('height');
    const margin = 10;
    const pointRadius = 10;
    const labelOffset = 10;
    const numTries = 50;
	const widthOffset= 50;

    const xScale = d3.scaleLinear().domain([0, 5]).range([margin, width - margin - widthOffset]);
    const yScale = d3.scaleLinear().domain([0, 5]).range([height - margin, margin]);
 
	function placeWithoutOverlap(data) {
		const pointRadius = 1; // Assuming a pointRadius value, adjust as needed
		const numTries = 100; // Assuming a numTries value, adjust as needed
 
		data.forEach((d, i) => {
			let position, tries = 0;
			do {
				position = { x: d.techScore, y: d.busScore };
	
				// Check for overlap with previous points
				let overlap = data.slice(0, i).some(p =>
					Math.sqrt((p.x - position.x) ** 3 + (p.y - position.y) ** 2.5) &lt; 5 * pointRadius
				);
				if (!overlap) break;
	
				// Adjust position to avoid overlap
				position.x += Math.random() * 0.4;
				position.y += Math.random() * 0.4;
	
				// Ensure position.x and position.y do not exceed 5
				position.x = Math.min(position.x, 5);
				position.y = Math.min(position.y, 5);
	
				tries++;
			} while (tries &lt; numTries);
			//inverted for gartner model
			d.x = position.y;
			d.y = position.x;
		});
	}
 
	
	function placeWithoutOverlapDisposition(data) {
		const simulation = d3.forceSimulation(data)
			.force('x', d3.forceX(d => d.techScore).strength(1))
			.force('y', d3.forceY(d => d.busScore).strength(1))
			.force('collide', d3.forceCollide(pointRadius))
			.stop();
	
		// Run the simulation for a set number of iterations
		for (let i = 0; i &lt; 90; i++) simulation.tick();
 
		// Ensure points remain within their quadrants
		data.forEach(d => {
			const quadrant = d.quadrant;
			if (!originalPositions[d.id]) { // Store original positions if not already stored
				switch (quadrant) {
					case 1:
						d.x = Math.random() * 2.5;
						d.y = 2.5 + Math.random() * 2.5;
						break;
					case 2:
						d.x = 2.5 + Math.random() * 2.5;
						d.y = 2.5 + Math.random() * 2.5;
						break;
					case 3:
						d.x = 2.5 + Math.random() * 2.5;
						d.y = Math.random() * 2.5;
						break;
					case 4:
						d.x = Math.random() * 2.5;
						d.y = Math.random() * 2.5;
						break;
				}
				originalPositions[d.id] = { x: d.x, y: d.y }; // Save the original position
			} else {
				d.x = originalPositions[d.id].x; // Restore the original position
				d.y = originalPositions[d.id].y;
			}
 
		});
	}
	
	// Apps with only disposition should be randomly placed, ones with maturity should be close to their maturity value
	let dispOnlyData = data.filter((e) => e.basedOnDisposition === true);
	let maturityVals = data.filter((e) => e.basedOnDisposition !== true);
	
	placeWithoutOverlap(maturityVals);
	  
	placeWithoutOverlapDisposition(dispOnlyData);
  
    const xAxis = d3.axisBottom(xScale).tickSize(0).tickFormat('');
    const yAxis = d3.axisLeft(yScale).tickSize(0).tickFormat('');

    svg.selectAll('.axis').remove(); // Clear existing axes

    svg.append('g').attr('class', 'axis').attr('transform', `translate(0,${yScale(2.5)})`).call(xAxis);
    svg.append('g').attr('class', 'axis').attr('transform', `translate(${xScale(2.5)},0)`).call(yAxis);

    svg.selectAll('.x.label').remove(); // Clear existing x label
    svg.selectAll('.y.label').remove(); // Clear existing y label

    svg.append('text').attr('class', 'x label').attr('text-anchor', 'end').attr('x', width - margin).attr('y', height).style('font-size', '18px').text('Business Fit');
    svg.append('text').attr('class', 'y label').attr('text-anchor', 'end').attr('x', -margin).attr('y', 10).attr('dy', '.75em').style('font-size', '18px').attr('transform', 'rotate(-90)').text('Technical Fit');

    function getQuadrantCenter(pos) {
        let x, y;
        switch (pos) {
            case 1: x = 1.25; y = 3.75; break;
            case 2: x = 3.75; y = 3.75; break;
            case 3: x = 3.75; y = 1.25; break;
            case 4: x = 1.25; y = 1.25; break;
        }
        return { x: xScale(x), y: yScale(y) };
    }

    const watermarks = Array.from(dispositionLifecycleStatus.values()).sort((a, b) => a.sequence - b.sequence).map(d => ({ name: d.name, pos: d.sequence }));

    svg.selectAll('.watermark').remove(); // Clear existing watermarks

    watermarks.forEach(d => {
        const center = getQuadrantCenter(d.pos);
        svg.append('text').attr('class', 'watermark').attr('x', center.x).attr('y', center.y).text(d.name).attr('text-anchor', 'middle').attr('alignment-baseline', 'central').style('font-size', '36px').style('font-weight', 'bold').style('fill', 'rgba(0, 0, 0, 0.07)');
    });

    const dots = svg.selectAll('.dot-group').data(data, d => d.id);

    // Enter new elements
    const dotsEnter = dots.enter().append('g').attr('class', 'dot-group');

    dotsEnter.append('circle').attr('class', 'dot')
	.attr('cx', d => {
		const xPos = xScale(d.x);
		return xPos &lt; 20 ? 20 : xPos;})
	.attr('cy', d => {
        const yPos = yScale(d.y);
        return yPos > 480 ? 480 : yPos;
    }).style('fill', d => d.disposition).style('opacity', 0.5).attr('r', pointRadius).attr('easid',  d => d.id)
	.style("stroke", d => "d.basedOnDisposition" ? "#000000" : "none")
	.style("stroke-width", d => d.basedOnDisposition ? "2": "1")
	   .style("stroke-dasharray", d => d.basedOnDisposition ? "2, 2" : "none") 
        .on('mouseover', function(event, d) {
            d3.selectAll('.dot-group').style('opacity', 0.1);
            d3.select(this.parentNode).style('opacity', 1);
            showSingleAppScore($(this).attr('easid'));
        })
        .on('mouseout', function() {
            d3.selectAll('.dot-group').style('opacity', 1);
            showFullAppScores(apps);
        });

    dotsEnter.append('text').attr('x', d => {
		const xPos = xScale(d.x);
		return xPos &lt; 20 ? 20 : xPos;})
	.attr('y', d => {
        const yPos = yScale(d.y);
        return yPos > 475 ? 475 : yPos;
    }).text(d => d.name).style('font-size', '10px').attr('text-anchor', 'start').attr('alignment-baseline', 'middle').attr('easid',  d => d.id)
        .on('mouseover', function(event, d) {
            d3.selectAll('.dot-group').style('opacity', 0.1);
            d3.select(this.parentNode).style('opacity', 1);
            showSingleAppScore($(this).attr('easid'));
        })
        .on('mouseout', function() {
            d3.selectAll('.dot-group').style('opacity', 1);
            showFullAppScores(apps);
        });

    // Update existing elements
    const dotsUpdate = dotsEnter.merge(dots);
	
    dotsUpdate.select('circle')
        .transition()
        .duration(1000)
        .attr('cx', d => {
			const xPos = xScale(d.x);
			return xPos &lt; 20 ? 20 : xPos;})
		.attr('cy', d => {
			const yPos = yScale(d.y);
			return yPos > 480 ? 480 : yPos;
		}) 

        dotsUpdate.select('text')
        .transition()
        .duration(1000)
        .attr('x', d => {
        
			const xPos = xScale(d.x);
			return xPos &lt; 20 ? 20 : xPos
       
        })
        .attr('y', d => {
			const yPos = yScale(d.y);
			return yPos > 475 ? 475 : yPos;
		})
    

    // Remove old elements
    dots.exit().remove();
	}else{	<!-- Not 4 Needs Consideration 
		function generateThresholds(categoriesOrder) {
			const thresholds = {};
			const numCategories = categoriesOrder.length;
		
			categoriesOrder.forEach((category, index) => {
				const step = 5 / numCategories;
				const techMin = step * index;
				const techMax = step * (index + 1);
				const busMin = step * index;
				const busMax = step * (index + 1);
				thresholds[category.name] = {
					tech: [techMin, techMax],
					bus: [busMin, busMax]
				};
			});
		
			return thresholds;
		}
		
		// Generate thresholds
		console.log('co', categoriesOrder)
		const thresholds = generateThresholds(categoriesOrder);
		console.log('thresh', thresholds);

		// Function to categorize based on scores
		function categorizeData(techValue) {
			console.log('tv',techValue)
			for (const category in thresholds) {
				const techRange = thresholds[category].tech;
		
				if (
					techValue >= techRange[0] &amp;&amp; techValue &lt;= techRange[1] 
				) {
					return category;
				}
			}
			return null; // Return null if no category matches
		}
		

data.forEach((e)=>{
	if(e.basedOnDisposition == true){
		let match=categoriesOrder.find((f)=>{
			return f.sequence == e.quadrant;
		})
		console.log('categoriesOrder',categoriesOrder)
		if(match){
			console.log('range m', match)
			let range=thresholds[match.name].tech[0]+ ((thresholds[match.name].tech[1] - thresholds[match.name].tech[0])/2)
			let busrange=thresholds[match.name].bus[0]+ ((thresholds[match.name].bus[1] - thresholds[match.name].bus[0])/2)
				
			
			console.log('range', range)
			e.techScore=range;
			e.busScore=busrange;
		}else{
			console.log('set to zero')
			e.techScore=0.1;
			e.busScore=0.1;
		}
	}
})

		// Categorize each application
		function categorizeApp(app, thresholds) {
			for (const [category, { tech, bus }] of Object.entries(thresholds)) {
				if (app.techScore >= tech[0] &amp;&amp;app.techScore &lt;= tech[1] &amp;&amp;
					app.busScore >= bus[0] &amp;&amp;app.busScore &lt;= bus[1]) {
					return category;
				}
			}
			return "uncategorized"; // If it doesn't fit into any category
		}
		
		// Categorize each application
		const categorizedData = data.map(app => {
			const category = categorizeApp(app, thresholds);
			return { ...app, category };
		});
		
		// Output the categorized data

		const margin = { top: 20, right: 20, bottom: 30, left: 40 };

		const svg = d3.select('svg');
		const width = +svg.attr('width');
		const height = +svg.attr('height');
		
		const x = d3.scaleLinear().domain([0, 5]).range([margin.left, width - margin.right]);
		const y = d3.scaleLinear().domain([0, 5]).range([height - margin.bottom, margin.top]);
		
		const xAxis = d3.axisBottom(x).ticks(5);
		const yAxis = d3.axisLeft(y)

		svg.append("g")
			.attr("transform", `translate(${margin.left},0)`)
			.call(yAxis);
		
		const bands = Object.keys(thresholds).map((key, i) => {
			return {
				label: key,
				tech: thresholds[key].tech,
				bus: thresholds[key].bus,
				color: d3.schemeCategory10[i % 10]
			};
		});
		if(bandsCount==0){
		bands.forEach(band => {
			svg.append("rect")
				.attr("x", x(band.tech[0]))
				.attr("y", 20)
				.attr("width", x(band.tech[1]) - x(band.tech[0]))
				.attr("height", height)
				.attr("fill", band.color)
				.attr("fill-opacity", 0.1)
				.attr("class", "band");
		
			svg.append("text")
				.attr("x", (x(band.tech[0]) + 10))
				.attr("y", height - 20)
				.attr("dy", ".35em")
				.attr("class", "bandlabel")
				.text(band.label);
		});
	}
	bandsCount=1; 

		// Function to update circles with animation
		function updateCircles(data) {
			console.log('uc', data)
			const circles = svg.selectAll("circle")
				.data(data, d => d.id || d.name); // Use name as fallback if id is missing
		
			circles.enter()
				.append("circle")
				.attr("cx", d => x(d.techScore))
				.attr("cy", d => y(d.busScore))
				.attr("r", 5)
				.style("stroke", d => d.basedOnDisposition ? "#000000": "none")
				.style("stroke-width", d => d.basedOnDisposition ? "2": "1")
       			.style("stroke-dasharray", d => d.basedOnDisposition ? "2, 2" : "none") 
				.style("fill", d => d.disposition)
				.merge(circles)
				.transition()
				.duration(1000)
				.style('opacity', 0.5)
				.attr("cx", d => x(d.techScore))
				.attr("cy", d => y(d.busScore));
		
			circles.exit().remove();
			console.log('dt',data);
		 
			const labels = svg.selectAll(".label")
			.data(data, function(d) { 
				console.log(d);
				return d?.id || ''
			});
		
			labels.enter()
				.append("text")
				.attr("class", "label")
				.attr("x", d => x(d.techScore))
				.attr("y", d => y(d.busScore))
				.attr("dx", 7)
				.attr("dy", ".35em")
				.text(d => d.name)
				.merge(labels)
				.transition()
				.duration(1000)
				.attr("x", d => x(d.techScore))
				.attr("y", d => y(d.busScore));
		
			labels.exit().remove();
		}
	 
		// Update circles with initial data
		console.log('preuc', data)
		updateCircles(data);
		
		// Example: Update circles with new data after 2 seconds
	-->
	<!--	setTimeout(() => {
			data.forEach(d => {
				d.techScore = Math.random() * 5;
				d.busScore = Math.random() * 5;
			});
			updateCircles(data);
		}, 2000);
	-->
	}

  
    }else{
        console.log('no time')
    }
}

function showSingleAppScore(appid) {

    $('#app-scores-list').empty();
    const panel = d3.select('#app-scores-list');
    panel.selectAll('li').remove();
	if(appKPIsformat){
    let app = appKPIsformat.find((a)=>{
        return a.id == appid
    })
	if(app){
    const tech = app.categoryScores?.find(e => e.categoryId === techFit.id);
    const bus = app.categoryScores?.find(e => e.categoryId === busFit.id);
    
    const techScores = tech?.scores?.map(score => `${score.service}: ${score.score}`);
    const busScores = bus?.scores?.map(score => `${score.service}: ${score.score}`);
 

    let techAvg = (tech?.averageScore ?? 0).toFixed(2);
    let busAvg = (bus?.averageScore ?? 0).toFixed(2);

    let dataForApp={"id":app.id, "name": app.name, "techAvg": techAvg,"busAvg":busAvg , "techScore": techScores, "busScore": busScores}
    $('#app-scores-list').append(appTimetemplate(dataForApp))
	}
  }
 
}

function showFullAppScores(listofApps) {

    const panel = d3.select('#app-scores-list');
    panel.selectAll('li').remove();
	if(appKPIsformat){
let filteredAppKPIs = appKPIsformat?.filter(kpi => listofApps.some(app => app.id === kpi.id));

    filteredAppKPIs=filteredAppKPIs?.sort(function(a, b) {
        if(a.name &amp;&amp; b.name){
           return a.name.localeCompare(b.name);
        }
    }); 
filteredAppKPIs?.forEach(app => {
	
if (app?.categoryScores?.length > 0) {
    let tech = app.categoryScores?.find(e => e.categoryId === techFit.id) ?? {};
    let bus = app.categoryScores?.find(e => e.categoryId === busFit.id) ?? {};

    let latestScores = tech?.scores?.filter(e => e.isLatest === true) ?? [];
    let latestBusScores = bus?.scores?.filter(e => e.isLatest === true) ?? [];

    const techScores = latestScores.map(score => `${score.service}: ${score.score}`) ?? [];
    const busScores = latestBusScores.map(score => `${score.service}: ${score.score}`) ?? [];

    const techScoreSum = latestScores.reduce((sum, item) => sum + item.score, 0);
    const techScoreAvg = latestScores.length > 0 ? techScoreSum / latestScores.length : 0;

    const busScoreSum = latestBusScores.reduce((sum, item) => sum + item.score, 0);
    const busScoreAvg = latestBusScores.length > 0 ? busScoreSum / latestBusScores.length : 0;

    let techAvg = techScoreAvg.toFixed(2);
    let busAvg = busScoreAvg.toFixed(2);
	// update scores for chart
 
    let dataForApp = {
        "id": app.id,
        "name": app.name,
        "techAvg": techAvg,
        "busAvg": busAvg,
        "techScore": techScores,
        "busScore": busScores
    };

    $('#app-scores-list').append(appTimetemplate(dataForApp));
	}
        
    });
 }
}

var testBPMNModel = {"type": "bpmn", "cells": [{"usageId": "store_297_Class40006", "type": "bpmn2.Event", "attrs": {"label": {"text": "Energy Price Alert"}}, "size": {"width": 40, "height": 40}, "angle": 0, "z": 324, "position": {"x": 0, "y": 0}, "id": "e614cd39-84ef-45b3-999d-b4115be96378"}, {"usageId": "store_261_Class87", "type": "bpmn2.Gateway", "siblingRank": 0, "attrs": {"label": {"text": "Hedge Product"}}, "size": {"width": 58, "height": 58}, "angle": 0, "z": 325, "position": {"x": 580, "y": -9}, "id": "7d44452b-140f-4caf-89cc-1e1c2b6cdb4a"}, {"usageId": "store_261_Class83", "type": "bpmn2.Activity", "siblingRank": 0, "attrs": {"label": {"text": "Check Market Rates"}}, "size": {"width": 120, "height": 100}, "angle": 0, "z": 327, "position": {"x": 140, "y": -30}, "id": "01612eff-4bed-496e-9431-2300af5fef22"}, {"usageId": "store_261_Class85", "type": "bpmn2.Activity", "siblingRank": 0, "attrs": {"label": {"text": "Request Price"}}, "size": {"width": 120, "height": 100}, "angle": 0, "z": 327, "position": {"x": 360, "y": -30}, "id": "5beb512f-cd80-4ff9-a89f-b4d46ae0d1c5"}, {"usageId": "store_261_Class88", "type": "bpmn2.Activity", "siblingRank": 0, "attrs": {"label": {"text": "Initiate Transaction"}}, "size": {"width": 120, "height": 100}, "angle": 0, "z": 327, "position": {"x": 738, "y": -130}, "id": "81ab087c-3ddc-4863-8cad-22392b0d0c7e"}, {"usageId": "store_261_Class90", "type": "bpmn2.Activity", "siblingRank": 1, "attrs": {"label": {"text": "Wait for Better Price"}}, "size": {"width": 120, "height": 100}, "angle": 0, "z": 327, "position": {"x": 738, "y": 70}, "id": "1305d6a8-e4fc-4740-be64-2e3c1d734c5f"}, {"vertices": [{"x": 310, "y": 20}, {"x": 310, "y": 20}], "relationId": "store_261_Class93", "source": {"id": "01612eff-4bed-496e-9431-2300af5fef22"}, "type": "bpmn2.Flow", "target": {"id": "5beb512f-cd80-4ff9-a89f-b4d46ae0d1c5"}, "labels": [{"attrs": {"label": {"text": "occurs before"}}, "position": {"distance": 0.5, "angle": 0}}], "attrs": {}, "z": 338, "id": "a73c87e6-eeaf-44b3-ae0c-4501dd5e5c45"}, {"vertices": [{"x": 530, "y": 20}, {"x": 530, "y": 20}], "relationId": "store_261_Class94", "source": {"id": "5beb512f-cd80-4ff9-a89f-b4d46ae0d1c5"}, "type": "bpmn2.Flow", "target": {"id": "7d44452b-140f-4caf-89cc-1e1c2b6cdb4a"}, "labels": [{"attrs": {"label": {"text": "occurs before"}}, "position": {"distance": 0.5, "angle": 0}}], "attrs": {}, "z": 338, "id": "3a5772d0-87aa-4973-9142-61ef3c44f988"}, {"vertices": [{"x": 688, "y": 20}, {"x": 688, "y": -80}], "relationId": "store_261_Class95", "source": {"id": "7d44452b-140f-4caf-89cc-1e1c2b6cdb4a"}, "type": "bpmn2.Flow", "target": {"id": "81ab087c-3ddc-4863-8cad-22392b0d0c7e"}, "labels": [{"attrs": {"label": {"text": "occurs before"}}, "position": {"distance": 0.5, "angle": 0}}], "attrs": {}, "z": 338, "id": "cf640e76-b255-4e5d-8f57-88fe78a6e7be"}, {"vertices": [{"x": 688, "y": 20}, {"x": 688, "y": 120}], "relationId": "store_261_Class96", "source": {"id": "7d44452b-140f-4caf-89cc-1e1c2b6cdb4a"}, "type": "bpmn2.Flow", "target": {"id": "1305d6a8-e4fc-4740-be64-2e3c1d734c5f"}, "labels": [{"attrs": {"label": {"text": "occurs before"}}, "position": {"distance": 0.5, "angle": 0}}], "attrs": {}, "z": 338, "id": "259a68f7-f033-491a-8bf2-86089445b2e2"}, {"vertices": [{"x": 90, "y": 20}, {"x": 90, "y": 20}], "relationId": "store_297_Class40007", "source": {"id": "e614cd39-84ef-45b3-999d-b4115be96378"}, "type": "bpmn2.Flow", "target": {"id": "01612eff-4bed-496e-9431-2300af5fef22"}, "labels": [{"attrs": {"label": {"text": "occurs before"}}, "position": {"distance": 0.5, "angle": 0}}], "attrs": {}, "z": 338, "id": "b4db1a85-40d5-440f-bfa8-6ceb01f5df6c"}]}

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
<xsl:template name="GetViewerAPIPathText">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>

	</xsl:template>
</xsl:stylesheet>
