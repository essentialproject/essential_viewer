<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
<xsl:import href="../common/core_strategic_plans.xsl"/>
<xsl:import href="../common/core_utilities.xsl"/>
<xsl:include href="../common/core_doctype.xsl"/>
<xsl:include href="../common/core_handlebars_functions.xsl"/>
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
    <xsl:variable name="enterpriseStrategicPlans" select="/node()/simple_instance[type='Enterprise_Strategic_Plan']"/>
    <xsl:variable name="busStrategicPlans" select="/node()/simple_instance[type='Business_Strategic_Plan']"/>
    <xsl:variable name="appStrategicPlans" select="/node()/simple_instance[type='Application_Strategic_Plan']"/>
    <xsl:variable name="infoStrategicPlans" select="/node()/simple_instance[type='Information_Strategic_Plan']"/>
    <xsl:variable name="techStrategicPlans" select="/node()/simple_instance[type='Technology_Strategic_Plan']"/>
    <xsl:variable name="securityStrategicPlans" select="/node()/simple_instance[type='Security_Strategic_Plan']"/>
    <xsl:variable name="allStrategicPlans" select="$enterpriseStrategicPlans union $busStrategicPlans union $appStrategicPlans union $infoStrategicPlans union $techStrategicPlans union $securityStrategicPlans "/>
	<xsl:variable name="programmes" select="/node()/simple_instance[type='Programme']"/>
	<xsl:variable name="planningActions" select="/node()/simple_instance[type='Planning_Action']"/>
	<xsl:variable name="planningStatus" select="/node()/simple_instance[type='Planning_Status']"/>
	<xsl:variable name="projectStatus" select="/node()/simple_instance[type=('Project_Approval_Status','Project_Lifecycle_Status')]"/>
	<xsl:variable name="budgetApproval" select="/node()/simple_instance[type=('Budget_Approval_Status')]"/>
	
	<xsl:variable name="p2eNodes" select="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']"/>
    <xsl:variable name="allRoadmaps" select="/node()/simple_instance[type='Roadmap']"/>
	<xsl:variable name="programmeStakeholders" select="$allActor2Roles[name = $programmes/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	 
	<xsl:variable name="fullprojectsList" select="/node()/simple_instance[type='Project']"/>

	<xsl:key name="orgs_key" match="/node()/simple_instance[type='Group_Actor']" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
	<xsl:key name="actors_key" match="/node()/simple_instance[type='Individual_Actor']" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
    <xsl:key name="roles_key" match="/node()/simple_instance[type=('Individual_Business_Role','Group_Business_Role')]" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
    
	<xsl:key name="milestone_key" match="/node()/simple_instance[type='Change_Milestone']" use="own_slot_value[slot_reference = 'cm_change_activity']/value"/>
	
 
	<xsl:key name="objectives_key" match="/node()/simple_instance[type=('Information_Architecture_Objective', 'Technology_Architecture_Objective', 'Application_Architecture_Objective', 'Business_Objective')]" use="own_slot_value[slot_reference = 'objective_supported_by_strategic_plan']/value"/> 
	<xsl:variable name="drivers" select="/node()/simple_instance[type=('Business_Driver', 'Application_Driver', 'Information_Driver', 'Technology_Driver')]"/>
	
	<!-- Set up the required link classes -->

	<xsl:key name="projects_key" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference = 'contained_in_programme']/value"/>
	<xsl:key name="budgets_key" match="/node()/simple_instance[type='Budget']" use="own_slot_value[slot_reference = 'budget_for_change_activity']/value"/>
	<xsl:key name="budget_elements_key" match="/node()/simple_instance[supertype='Budgetary_Element']" use="own_slot_value[slot_reference = 'budgetary_element_of_budget']/value"/>
	
	<xsl:key name="costs_key" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	<xsl:key name="cost_elements_key" match="/node()/simple_instance[supertype='Cost_Component']" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>

	<xsl:key name="p2e_key" match="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_change_activity']/value"/>
	<xsl:key name="p2efromPlan_key" match="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_plan']/value"/>
	<xsl:key name="projectsfromPlan_key" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference = 'ca_planned_changes']/value"/>
	<xsl:key name="projectsDirectfromPlan_key" match="/node()/simple_instance[type='Project']" use="name"/>
	
	
	<xsl:key name="plans_key" match="/node()/simple_instance[supertype='Strategic_Plan']" use="own_slot_value[slot_reference = 'strategic_plan_for_elements']/value"/>
	<xsl:key name="plans4Programme_key" match="/node()/simple_instance[supertype='Strategic_Plan']" use="own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value"/>
	<xsl:variable name="allImpactedElements" select="/node()/simple_instance[name = $p2eNodes/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	
	<xsl:variable name="allProjects" select="key('projects_key',$programmes/name)"/>	
	<xsl:variable name="allP2E" select="key('p2e_key',$allProjects/name)"/>
	<xsl:variable name="allPlan" select="key('plans_key',$allP2E/name)"/>
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider_Interface', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function', 'Application_Function_Implementation', 'Enterprise_Strategic_Plan', 'Information_Representation','Programme','Enterprise_Strategic_Plan','Project','Roadmap')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="appsTechData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"/>
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"></xsl:variable>
	<xsl:variable name="capsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="planningData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"></xsl:variable>
	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>

	<xsl:key name="lifes" match="/node()/simple_instance[(type = 'Element_Style')]" use="own_slot_value[slot_reference = 'style_for_elements']/value"/>
				
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
 
		<xsl:variable name="capPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsData"/>
			</xsl:call-template>
		</xsl:variable> 
		<xsl:variable name="processPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$processData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="atPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsTechData"/>
			</xsl:call-template>
		</xsl:variable>	
		<xsl:variable name="planningDataPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$planningData"/>
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
				<title><xsl:value-of select="eas:i18n('Strategic Plan Dashboard')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css?release=6.19" type="text/css" rel="stylesheet"></link>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css?release=6.19" media="screen" rel="stylesheet" type="text/css"></link>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js?release=6.19" type="text/javascript"></script>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js?release=6.19" type="text/javascript"></script>

				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css?release=6.19"/>

                <style type="text/css">
          
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

					.orgName{
						font-size:2.4em;
						padding-top:30px;
						text-align:center;
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
						position:relative;
					}
					
					.ess-list-tags{
						padding: 0;
					}
					.ess-list-tags-obj{
						background-color:darkslategrey;
						color:#fff
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
					.roleBlobCap{
						background-color: rgb(68, 182, 179);
						font-size:0.8em;
					}
					.numBadge{
						text-align: center
					}
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
					.countInDivBox{
						position:relative;
						border:1pt solid #d3d3d3; 
						background-color: rgb(250, 250, 250);
						height:30px; 
						border-radius:8px; 
						width:40px;
						display:inline-block;
						margin:2px;
						padding:2px;
						padding-top:5px;
						text-align:center;
						font-size:1em;
						font-weight: bold;
						vertical-align: middle;
						display:inline-block;
					}
					 
					.scores{
						position:absolute;
						bottom:3px;
					}
					.tdcentre{
						text-align:center;
						font-size:20px;
					}

					.sidenav{
						height: calc(100vh - 41px);
						width: 850px;
						position: fixed;
						z-index: 100;
						top: 67px;
						right: 0;
						background-color: #f7f7f7;
						overflow-x: hidden;
						transition: margin-right 0.5s;
						padding: 10px 10px 10px 10px;
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
						margin-right: -852px; 
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
					.roadmap{
						color:rgb(206, 116, 185)
					}
					.plan{
						color:rgb(116, 116, 211)
					}
					.programme{
						color:rgb(104, 186, 187);
					}
					.grey{
						color:#c6c6c6
						}
						
					.grad{height: 100%;
  						background-color: white; /* For browsers that do not support gradients */
  						background-image: linear-gradient(135deg, white, #f5f5f5);
					}
					.scoreBlob{
						border-radius:5px;
						width:30px;
						height:30px;
						text-align: center;
						padding:5px;
						margin:5px;
						vertical-align: middle;
						font-weight:bold;
						display:inline-block;
					}
					.scoreBlobBig{
						border-radius:5px;
						width:80px;
						height:80px;
						text-align: center;
						padding:0px;
						margin:5px;
						vertical-align: top;
						font-weight:bold;
						display:inline-block;
						
					}
					.scoreName{
						border-radius:5px;
						border:1pt solid #d3d3d3;
						height:30px;
						text-align: center;
						vertical-align: top;
						padding:5px;
						margin:5px;
						font-weight:bold;
						display:inline-block;
					}
					.info_tab{
						
						color:#000;
						border-radius:8pt;
						width:100%;
						height:80px;
						text-align:center;
						vertical-align: middle;
						font-size:3em;
						font-weight:bold;
						padding:10px;
						margin:5px;
					}
					.projectsColour{
						background-color:#f5b427;
					}
					.projectsActiveColour{
						background-color:#bb8ce9;
						color:#fff;
					}
					.projectsOntrackColour{
						background-color: #e68181;
						color:#000;
					}
					.filterBox{
						position: absolute;
						top: 0px;
						right: -10px;
						background-color: #e3e3e3;
						height:50px
					}
					.years{
						display:inline-block;
					}
					.form-group .form-control {
							padding-left: 2.375rem;
						}
						.form-group{
						position:relative;
						}
						.form-group .form-control-icon {
							position: absolute;
							z-index: 2;
							display: block;
							width: 2.375rem;
							height: 2.375rem;
							line-height: 2.375rem;
							text-align: center;
							pointer-events: none;
							color: #aaa;
							right:0;
							top: 0px;
						}
						.hover{
							color:#cdb81f;
						}
						.fa-rotate-45 {
							-webkit-transform: rotate(45deg);
							-moz-transform: rotate(45deg);
							-ms-transform: rotate(45deg);
							-o-transform: rotate(45deg);
							transform: rotate(45deg);
						}
						.actionCount{
							text-align: center;
							border-radius:6px;
							border:1pt solid #d3d3d3;
							background-color: #e9e9e9;
							margin:3px;
						}
						.objcard{
							display:inline-block;
							min-height:75px;
							font-weight:bold;
							width: 120px;
							vertical-align:top;
							border:1pt solid #d3d3d3;
							border-radius:6px;
							padding:3px;
							background-color: #47c3ae;
							color:#303030;
							text-align: center;
							margin:2px;
							font-size:0.8em;
							box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
						}
					.detail-outer {
						padding: 5px 5px 10px 5px;
						position: relative;
						display: inline-block;
						background-color: #d3d3d3; width:46%; color: #000; 
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.35);
						background-color:#fff;
						vertical-align:top;
						min-height:175px;
					}
					.detail-outer-name {
						font-size: 105%;
						font-weight: 600;
						display: inline-block;
					}
					.detail-outer-type {
						opacity: 0.75;
					}
					.detail-outer-obj-count {
						position: absolute;
						top: 5px;
						right: 5px;
						letter-spacing: 1px;
						cursor: help;
					}
					.count-bar {
						border-radius: 3px;
						<!--background-color: #EEC200;-->
						width: 100%;
						height: 5px;
					}
					
					.detail-inner-wrapper {
						display: flex;
						gap: 15px;
						flex-wrap: wrap;
						flex-direction: row;
					}
					.detail-inner {
						min-width: 160px;
						padding: 5px 20px 25px 20px;
						position: relative;
						border-radius: 30px;
						flex-basis: auto;
						font-weight: 600;
						font-size: 1em;
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.35);
						background-color: var(--dark-grey);
					}
					.detail-inner-name {
					}
					.detail-inner-type {
						position: absolute;
						bottom: 5px;
						left: 20px;
						opacity: 0.5;
						font-weight: 300;
						font-size: 80%;
					}
					.detail-inner > i {
						position: absolute;
						bottom: 5px;
						right: 15px;
						opacity: 0.5;
						font-size: 90%;
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
					.monopoly-card-container {
						display: flex;
						justify-content: top;
						align-items: top; 
					}
					
					.monopoly-card {
						width: 120px;
						min-height:80px;
						padding: 7px;
						border: 2px solid black;
						border-radius: 10px;
						background-color: whitesmoke;
						text-align: center;
						margin: 3px;
						position: relative;
						border-left: 4px solid lightseagreen;
						box-shadow: 
					}
					
					.card-name {
						font-size: 0.9em;
						font-weight: normal;
						color: darkblue;
						margin-bottom: 10px;
					}
					
					.card-action {
						font-size: 0.9em;
						color: black;
						position: absolute;
						bottom: 2px;
						right: 6px;
					}
					.card-head {
						font-size: 0.5em;
						color: black;
						background-color: white;
						position: absolute;
						top: -5px;
						padding: 2px;
						padding-right: 4px;
						left: -1px;
						border: 1px solid black;
						border-radius: 10px 0px 10px 0px;
					}
					
				 
				</style>
				<script src='js/d3/d3.v5.9.7.min.js'></script>
				<script src='js/chartjs/Chart.min.js'></script>
                <script src="js/chartjs/chartjs-plugin-labels.min.js?release=6.19"></script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
			<!--
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
			-->

		<div class="container-fluid" id="summary-content">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Roadmap Dashboard')"/>  </span>
						 			</h1>
                    </div>
				</div>
			</div>
			<div class="row">
				<div class="pull-right bottom-5 right-5">
				Start Date: 
				<select class="years" id="startYear"></select>
					 End Date: 
				<select class="years" id="endYear"></select>
					 Programme:
				<select class="prog years" id="programme"><option value="all">All</option></select>
				</div>
			</div>
			<!--Setup Vertical Tabs-->
			<div class="row">
				<span id="planTabs">/</span>
			</div>

			<!--Setup Closing Tag-->
		</div>
 					<div id="appSidenav" class="sidenav">
						<i class="fa fa-times slideClose" style="right:3px;position:absolute;color:rgb(101, 101, 101)"></i>
						<div class="clearfix"/>
						<br/>
						<div class="left-20">
							<h2><span id="popTitle"/></h2>
							<div id="informationBox"/>
						</div>
					</div>
				<!--ADD THE CONTENT-->
					<div class="modal fade" id="impactsModal">
						<div class="modal-dialog modal-lg">
							<div class="modal-content">
							
							<!-- Modal Header -->
							<div class="modal-header">
							<h4 class="modal-title">Project Impacts</h4>
							</div>
							
							<!-- Modal body -->
							<div class="modal-body" id="modalContent">
							
							</div>
							
							<!-- Modal footer -->
							<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
							</div>
							
					  		</div>
						</div>
				  	</div>
				<div id="appPanel">
					<div class="text-right"><i class="fa fa-times closePanelButton left-30"></i></div>
                    <div id="slideUpData" style="height: 200px; overflow: auto"></div>
                </div>	
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
				<script>
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
					<xsl:with-param name="viewerAPIPathCap" select="$capPath"/>
					<xsl:with-param name="viewerAPIPathAT" select="$atPath"/>
					<xsl:with-param name="viewerAPIPathProcess" select="$processPath"/>
					<xsl:with-param name="viewerAPIPathPlanning" select="$planningDataPath"/>
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
	<script id="planInformation-template" type="text/x-handlebars-template">
			<h3><span class="uppercase detail-outer-type" style="font-weight:300"><i class="fa fa-fw fa-columns right-5"></i><xsl:text> </xsl:text>Plan</span><br/>
			{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</h3> 
			<span class="label label-default lbPanel">Description</span><br/> <b>{{this.description}}</b> <br/>
			<span class="label label-default lbPanel">Plan Start</span> <xsl:text> </xsl:text><span class="label label-info">{{this.validStartDate}}</span>
			
			<span class="label label-default lbPanel left-20">Plan Complete</span><xsl:text> </xsl:text> <span class="label label-info">{{this.validEndDate}}</span><br/>
			<span class="label label-default lbPanel">Status</span> <xsl:text> </xsl:text> <b>{{this.planStatus}}</b> <br/>
			<span class="label label-default lbPanel">Objectives</span><br/>
			{{#each this.objectives}} 
				<div class="objcard">{{this.name}}</div>
			{{/each}}
			 <br/><br/>
			 <span class="label label-default top-10 lbPanel">Projects</span><br/>
			{{#each this.projects}} 
			<div class="detail-outer top-5">
				<div class="detail-outer-type uppercase small top-5"><i class="fa fa-fw fa-calendar right-5"></i>Project</div>
				<div class="detail-outer-name obj-detail planClick">
					<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
					{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
				</div>
				
				<div class="top-10"><strong>Start Date: </strong>{{this.actualStartDate}}</div>
				<div><strong>End Date: </strong>{{this.forecastEndDate}}</div>
				<div class="costsPanel">
					{{#if this.costbreakdown}}
					<b>Costs</b><br/>
					{{#each this.costbreakdown}}
						{{#ifEquals @key 'Adhoc_Cost_Component'}}
							<span class="label label-info">Adhoc</span> {{../this.currency}}{{formatCost this}}<br/>
						{{else}}
						
						<span class="label label-info">Annual</span> {{../this.currency}}{{formatCost this}}<br/>
						{{/ifEquals}}
					{{/each}}
					{{/if}}
				</div>
				<div class="plan-attr-wrapper top-10" style="display: flex; gap:10px;">
					<div class="infoBlock" style="background-color: var(--yellow);">{{this.p2e.length}}<span> Impacts</span>
					<i class="fa fa-info-circle impactsInfo left-5"><xsl:attribute name="impactid">{{this.id}}</xsl:attribute></i>

					</div>
				</div>
			</div>
			
			
			{{/each}}
			{{#each this.stakeholders}} {{/each}}
			
	</script>			
	<script id="planRowSvg-template" type="text/x-handlebars-template">
		<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
			<!-- required for floating -->
			<!-- Nav tabs -->
			<span id="tabs"/>
			<ul class="nav nav-tabs tabs-left" style="max-height: 80vh;overflow-y: auto">
				<li class="active">
					<a href="#roadmapTab" data-toggle="tab"><i class="fa fa-fw fa-road right-10"></i><xsl:value-of select="eas:i18n('All Roadmaps')"/></a>
				</li>		
				<li>
					<a href="#plansTab" data-toggle="tab"><i class="fa fa-fw fa-calendar right-10"></i><xsl:value-of select="eas:i18n('All Plans')"/></a>
				</li>
				<li>
					<a href="#plansProjTab" data-toggle="tab"><i class="fa fa-fw fa-calendar right-10"></i><xsl:value-of select="eas:i18n('All Plans &amp; Projects')"/></a>
				</li>
			{{#each this}}
			<li>
				<a data-toggle="tab"><xsl:attribute name="href">#{{this.id}}</xsl:attribute><xsl:attribute name="id">{{this.id}}Tab</xsl:attribute><i class="fa fa-fw fa-columns right-10"><xsl:attribute name="id">{{this.id}}i</xsl:attribute></i>{{name}}</a>
			</li>
			{{/each}}
			</ul>
				
				
		</div>

		<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
		 
			<div class="tab-content">
			
				<div class="tab-pane active" id="roadmapTab">
						<h2 class="print-only top-30"><i class="fa fa-fw fa-lock right-10"></i><xsl:value-of select="eas:i18n('Roadmaps')"/></h2>
				
						<div class="parent-superflex">
							<div class="superflex grad">
								<h3 class="text-primary"><i class="fa fa-road right-10"></i><xsl:value-of select="eas:i18n('Roadmaps')"/></h3>       
								<svg id="roadmapsSvg" width="100%"></svg>                           
							</div>
						</div>			
				</div>
				<div class="tab-pane" id="plansTab">
						<h2 class="print-only top-30"><i class="fa fa-fw fa-lock right-10"></i><xsl:value-of select="eas:i18n('Plans Timeline')"/></h2>
				
						<div class="parent-superflex">
							<div class="superflex grad">
								<h3 class="text-primary"><i class="fa fa-road right-10"></i><xsl:value-of select="eas:i18n('Strategic Plans Timeline')"/></h3>                                  
									<svg width="100%" height="30px">
									<text x="5" y="14">Key:</text>
									<circle cx="40" r="7" stroke="black" stroke-width="2" fill="white" cy="10"></circle>
									<text x="50" y="14">Start Date</text>
									<circle cx="190" r="7" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA" cy="10"></circle>
									<text x="200" y="14">Completion Date</text>
									</svg>
									<svg id="plansSvg" width="100%"></svg>
								<div class="clearfix bottom-10"></div>
							</div>
							<div class="col-xs-12"/>
						</div>		
				</div> 
				<div class="tab-pane" id="plansProjTab">
						<h2 class="print-only top-30"><i class="fa fa-fw fa-lock right-10"></i><xsl:value-of select="eas:i18n('Plans Timeline')"/></h2>
				
						<div class="parent-superflex">
							<div class="superflex grad">
								<h3 class="text-primary"><i class="fa fa-road right-10"></i><xsl:value-of select="eas:i18n('Strategic Plans and Projects')"/></h3>                                  
									<svg width="100%" height="30px">
									<text x="5" y="14">Key:</text>
									<circle cx="40" r="7" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA" cy="10"></circle>
									<text x="50" y="14">Proposed Start Date</text>
									<circle cx="190" r="7" stroke="black" stroke-width="2" fill="white" cy="10"></circle>
									<text x="200" y="14">Actual Start Date</text>
									<circle cx="340" r="7" stroke="green" stroke-width="2" fill="white" cy="10"></circle>
									<text x="350" y="14">Forecast End Date</text>
									<circle cx="490" r="7" stroke="gray" stroke-width="2" fill="white" cy="10"></circle>
									<text x="500" y="14">Target End Date</text>
									</svg>
									<div class="lifekey pull-right bottom-5"></div>
									<svg id="plansProjSvg" width="100%"></svg>
								<div class="clearfix bottom-10"></div>
							</div>
							<div class="col-xs-12"/>
						</div>		
				</div>
		 	
			{{#each this}}
				<div class="tab-pane"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
						<h2 class="print-only top-30"><i class="fa fa-fw fa-lock right-10"></i><xsl:value-of select="eas:i18n('Projects Overview')"/></h2>
			
					<div class="parent-superflex">
						<div class="superflex grad">
							<div class="container-fluid">
								<div class="row">
									<h3 class="text-primary"><i class="fa fa-columns right-10"></i>{{this.name}}</h3>
									<svg width="100%" height="30px">
									<text x="5" y="14">Key:</text>
									<circle cx="40" r="7" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA" cy="10"></circle>
									<text x="50" y="14">Proposed Start Date</text>
									<circle cx="190" r="7" stroke="black" stroke-width="2" fill="white" cy="10"></circle>
									<text x="200" y="14">Actual Start Date</text>
									<circle cx="340" r="7" stroke="green" stroke-width="2" fill="white" cy="10"></circle>
									<text x="350" y="14">Forecast End Date</text>
									<circle cx="490" r="7" stroke="gray" stroke-width="2" fill="white" cy="10"></circle>
									<text x="500" y="14">Target End Date</text>
									</svg>
									<div class="lifekey pull-right bottom-5"></div>
								
									<svg><xsl:attribute name="svgid">svg-{{this.id}}</xsl:attribute></svg>
								</div>
							</div>
						</div>
					</div>
				</div>
			{{/each}}	
			</div>
		</div>

	</script>
	<script id="projectPlansSvg-template" type="text/x-handlebars-template">
		{{#each this.years}} 
			<circle r="4" stroke="black" stroke-width="1" fill="none"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">7</xsl:attribute></circle>
			<text y="10" style="font-size:8pt"><xsl:attribute name="x">{{#yearText this.pos}}{{/yearText}}</xsl:attribute>{{this.year}}</text>
		<line style="stroke:rgb(182, 182, 182);stroke-width:1" stroke-dasharray="5,5"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">10</xsl:attribute><xsl:attribute name="y1">{{#lineHeight ../this.length}}{{/lineHeight}}</xsl:attribute></line>
		{{/each}}

		{{#each this}} 
		{{#ifEquals type 'Project'}}
		<polygon stroke="#00000059" stroke-width="1" ><xsl:attribute name="fill">{{#getProjectColour this}}{{/getProjectColour}}59</xsl:attribute><xsl:attribute name="points">{{#nudgeBack this.forecastEndDatePos this }}{{/nudgeBack}},{{#getTopRight @index forecastEndDatePos}}{{/getTopRight}}  {{this.forecastEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.forecastEndDatePos this}}{{/nudgeBack}},{{#getbottomRight @index forecastEndDatePos}}{{/getbottomRight}} {{this.actualStartDatePos}},{{#getbottomLeft @index actualStartDatePos}}{{/getbottomLeft}} {{this.actualStartDatePos}},{{#getTopLeft @index actualStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
    	<foreignObject eas-type="projname" x="23" width="280" class="nameClick">
                <xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                <xsl:attribute name="y">{{#getFORow @index this}}{{/getFORow}}</xsl:attribute>
                <xsl:attribute name="height">40</xsl:attribute>
                <xhtml> 
                        {{#ifEquals this.late 'Yes'}}<i class="fa fa-exclamation-triangle" style="color:#FF0000"></i>
						{{/ifEquals}}<span style="font-size:1em"><i class="fa fa-tasks"></i> {{{essRenderInstanceMenuLink this}}} </span> 
						{{this.hasProjects}}
                     <!--   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
                </xhtml>
            </foreignObject>	
            {{#ifEquals this.actualStartDate ""}}
            {{else}}
		  <circle cx="20" r="9" stroke="black" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.actualStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
            {{/ifEquals}}
             {{#ifEquals this.proposedStartDate ""}}
             {{else}}
		  <circle cx="20" r="8" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA"><xsl:attribute name="cx">{{this.proposedStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
             {{/ifEquals}}
             {{#ifEquals this.forecastEndDate ""}}
             {{else}}
		  <circle cx="20" r="8" stroke="green" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.forecastEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
            {{/ifEquals}}
			  {{#if this.targetEndDate}}
             {{#ifEquals this.targetEndDate ""}}
             {{else}}
		  	<circle cx="20" r="9" stroke="gray" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.targetEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
           {{/ifEquals}}
		   {{/if}}
		{{else}}
		<polygon fill="#c6a6ee73" stroke="black" stroke-width="1" ><xsl:attribute name="points">{{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getTopRight @index validEndDatePos}}{{/getTopRight}}  {{this.validEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getbottomRight @index validEndDatePos}}{{/getbottomRight}} {{this.validStartDatePos}},{{#getbottomLeft @index validStartDatePos}}{{/getbottomLeft}} {{this.validStartDatePos}},{{#getTopLeft @index validStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
 <!--
			// top right sq, x, y
			// point x,y
			// bottom right x, y
			//bottom left x,y
			//top left x, y
 -->
		 <foreignObject eas-type="progname" x="3" width="280" class="nameClick">
                <xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                <xsl:attribute name="y">{{#getFORow @index this}}{{/getFORow}}</xsl:attribute>
                <xsl:attribute name="height">40</xsl:attribute>
                <xhtml> 
					<div style="white-space: normal; word-wrap: break-word;width:270px">
					<xsl:text> </xsl:text><span style="font-size:1em">{{{essRenderInstanceMenuLink this}}} 
						</span>
					</div>
	    		 </xhtml>
        </foreignObject>
	  <circle cx="20" r="8" stroke="black" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.validStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
		  <circle cx="20" r="8" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA"><xsl:attribute name="cx">{{this.validEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
		  {{/ifEquals}}
		{{/each}}	
	</script> 
	<script id="projectSvg-template" type="text/x-handlebars-template">
		{{#each this.years}} 
			<circle r="4" stroke="black" stroke-width="1" fill="none"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">7</xsl:attribute></circle>
			<text y="10" style="font-size:8pt"><xsl:attribute name="x">{{#yearText this.pos}}{{/yearText}}</xsl:attribute>{{this.year}}</text>
			<line style="stroke:rgb(182, 182, 182);stroke-width:1" stroke-dasharray="5,5"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">10</xsl:attribute><xsl:attribute name="y1">{{#projectlineHeight ../this}}{{/projectlineHeight}}</xsl:attribute></line>
		{{/each}}
		{{#each this.focusProjects}} 
		<polygon stroke="black" stroke-width="1" ><xsl:attribute name="fill">{{#getProjectColour this}}{{/getProjectColour}}</xsl:attribute><xsl:attribute name="points">{{#nudgeBack this.forecastEndDatePos}}{{/nudgeBack}},{{#getTopRight @index forecastEndDatePos}}{{/getTopRight}}  {{this.forecastEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.forecastEndDatePos}}{{/nudgeBack}},{{#getbottomRight @index forecastEndDatePos}}{{/getbottomRight}} {{this.actualStartDatePos}},{{#getbottomLeft @index actualStartDatePos}}{{/getbottomLeft}} {{this.actualStartDatePos}},{{#getTopLeft @index actualStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
    	<foreignObject eas-type="projname" x="3" width="280" class="nameClick">
                <xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                <xsl:attribute name="y">{{#getFORow this.pos this}}{{/getFORow}}</xsl:attribute>
                <xsl:attribute name="height">40</xsl:attribute>
                <xhtml> 
                        {{#ifEquals this.late 'Yes'}}<i class="fa fa-exclamation-triangle" style="color:#FF0000"></i>
						{{/ifEquals}}<span style="font-size:1.1em">{{{essRenderInstanceMenuLink this}}} </span> 
						{{this.hasProjects}}
                     <!--   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
                </xhtml>
            </foreignObject>	
            {{#ifEquals this.actualStartDate ""}}
            {{else}}
		  <circle cx="20" r="9" stroke="black" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.actualStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow this.pos}}{{/getRow}}</xsl:attribute></circle>
            {{/ifEquals}}
             {{#ifEquals this.proposedStartDate ""}}
             {{else}}
		  <circle cx="20" r="8" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA"><xsl:attribute name="cx">{{this.proposedStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow this.pos}}{{/getRow}}</xsl:attribute></circle>
             {{/ifEquals}}
             {{#ifEquals this.forecastEndDate ""}}
             {{else}}
		  <circle cx="20" r="8" stroke="green" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.forecastEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow this.pos}}{{/getRow}}</xsl:attribute></circle>
            {{/ifEquals}}
             {{#ifEquals this.targetEndDate ""}}
             {{else}}
		  <circle cx="20" r="9" stroke="gray" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.targetEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow this.pos}}{{/getRow}}</xsl:attribute></circle>
           {{/ifEquals}}
		 <!--

		  <rect class="infoBox" height="15" style="fill:rgb(118, 39, 174);stroke-width:0;stroke:rgb(255,255,255); rx:3"><xsl:attribute name="eastype">proj</xsl:attribute><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="width">{{#getRecWidth this.p2e.length}}{{/getRecWidth}}</xsl:attribute><xsl:attribute name="x">{{#getRecX this.targetEndDatePos}}{{/getRecX}}</xsl:attribute><xsl:attribute name="y">{{#getRecRow @index}}{{/getRecRow}}</xsl:attribute></rect>
		 <text fill="white" font-weight="bold" class="infoBox" ><xsl:attribute name="eastype">proj</xsl:attribute><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="x">{{#getRecXText this.targetEndDatePos this.p2e.length}}{{/getRecXText}}</xsl:attribute><xsl:attribute name="y">{{#getRowText @index}}{{/getRowText}}</xsl:attribute>{{this.p2e.length}}</text>
		 -->
        
          {{#each this.milestones}}
            <text style="font-size:0.8em"><xsl:attribute name="x">{{this.milestoneDatePos}}</xsl:attribute><xsl:attribute name="y" >{{#getRowMilestoneText ../this.pos}}{{/getRowMilestoneText}}</xsl:attribute>{{#formatName this.name}}{{/formatName}}<title>{{this.name}}</title></text>
            <polygon class="milestone"  style="fill:rgb(252, 252, 252);stroke:rgb(55, 26, 55);stroke-width:1"><xsl:attribute name="points">{{#getPolyPoints this.milestoneDatePos ../this.pos}}{{/getPolyPoints}} </xsl:attribute></polygon>
         <!--   <circle cx="20" r="5" stroke="green" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.milestoneDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow ../this.pos}}{{/getRow}}</xsl:attribute></circle>-->
          
          {{/each}}
		{{/each}}	
	</script> 

	<script id="roadmapSvgPlans-template" type="text/x-handlebars-template">
		{{#each this.years}} 
			<circle r="4" stroke="black" stroke-width="1" fill="none"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">7</xsl:attribute></circle>
			<text y="10" style="font-size:8pt"><xsl:attribute name="x">{{#yearText this.pos}}{{/yearText}}</xsl:attribute>{{this.year}}</text>
			<line style="stroke:rgb(182, 182, 182);stroke-width:1" stroke-dasharray="5,5"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">10</xsl:attribute><xsl:attribute name="y1">{{#roadmaplineHeight ../this}}{{/roadmaplineHeight}}</xsl:attribute></line>
		{{/each}}
		{{#each this}} 
			{{#ifEquals this.className 'Enterprise_Strategic_Plan'}}
			<polygon stroke="black" stroke-width="1" ><xsl:attribute name="fill">#c6a6ee73</xsl:attribute><xsl:attribute name="points">{{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getTopRight @index validEndDatePos}}{{/getTopRight}}  {{this.validEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getbottomRight @index validEndDatePos}}{{/getbottomRight}} {{this.validStartDatePos}},{{#getbottomLeft @index validStartDatePos}}{{/getbottomLeft}} {{this.validStartDatePos}},{{#getTopLeft @index validStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
			<foreignObject eas-type="projname" x="30" width="270" class="nameClick">
					<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
					<xsl:attribute name="y">{{#getFORow @index this}}{{/getFORow}}</xsl:attribute>
					<xsl:attribute name="height">40</xsl:attribute>
					<xhtml> 
							<i class="fa fa-fw fa-columns right-10"></i><span style="font-size:1em">{{{essRenderInstanceMenuLink this}}} </span> 
						<!--	<i class="fa fa-caret-right expandPlan"><xsl:attribute name="planId">{{this.id}}</xsl:attribute></i>
						   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
					</xhtml>
			</foreignObject>	
			{{else}}
			<polygon stroke="black" stroke-width="1" ><xsl:attribute name="fill">#2980B9</xsl:attribute><xsl:attribute name="points">{{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getTopRight @index validEndDatePos}}{{/getTopRight}}  {{this.validEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getbottomRight @index validEndDatePos}}{{/getbottomRight}} {{this.validStartDatePos}},{{#getbottomLeft @index validStartDatePos}}{{/getbottomLeft}} {{this.validStartDatePos}},{{#getTopLeft @index validStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
			<foreignObject eas-type="projname" x="3" width="280" class="nameClick">
					<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
					<xsl:attribute name="y">{{#getFORow @index this}}{{/getFORow}}</xsl:attribute>
					<xsl:attribute name="height">40</xsl:attribute>
					<xhtml> 
							<span style="font-size:1.1em">{{{essRenderInstanceMenuLink this}}} </span> 
						{{#ifEquals this.selected 'Yes'}}<i class="fa fa-arrow-circle-up closeRoadmap"><xsl:attribute name="roadmapId">{{this.id}}</xsl:attribute></i>{{/ifEquals}}
						<!--   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
					</xhtml>
			</foreignObject>	

			{{/ifEquals}}
		{{/each}}	
	</script>
	<script id="roadmapSvg-template" type="text/x-handlebars-template">
				{{#each this.years}} 
			<circle r="4" stroke="black" stroke-width="1" fill="none"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">7</xsl:attribute></circle>
			<text y="10" style="font-size:8pt"><xsl:attribute name="x">{{#yearText this.pos}}{{/yearText}}</xsl:attribute>{{this.year}}</text>
			<line style="stroke:rgb(182, 182, 182);stroke-width:1" stroke-dasharray="5,5"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">10</xsl:attribute><xsl:attribute name="y1">{{#roadmaplineHeight ../this}}{{/roadmaplineHeight}}</xsl:attribute></line>
		{{/each}}
		{{#each this}} 
		<polygon stroke="black" stroke-width="1" ><xsl:attribute name="fill">#2980B9</xsl:attribute><xsl:attribute name="points">{{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getTopRight @index validEndDatePos}}{{/getTopRight}}  {{this.validEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getbottomRight @index validEndDatePos}}{{/getbottomRight}} {{this.validStartDatePos}},{{#getbottomLeft @index validStartDatePos}}{{/getbottomLeft}} {{this.validStartDatePos}},{{#getTopLeft @index validStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
    	<foreignObject eas-type="projname" x="3" width="280" class="nameClick">
                <xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                <xsl:attribute name="y">{{#getFORow @index this}}{{/getFORow}}</xsl:attribute>
                <xsl:attribute name="height">40</xsl:attribute>
                <xhtml> 
                        <span style="font-size:1.1em">{{{essRenderInstanceMenuLink this}}} </span> 
						<i class="fa fa-arrow-circle-right expandRoadmap"><xsl:attribute name="roadmapId">{{this.id}}</xsl:attribute></i>
                     <!--   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
                </xhtml>
            </foreignObject>	
		{{#each this.plans}}
			<circle r="5" class="plancircle" stroke="#d3d3d3" stroke-width="2" fill="#d3d3d3AA"><xsl:attribute name="cx">{{this.validEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @../index}}{{/getRow}}</xsl:attribute><xsl:attribute name="easplanid">{{this.id}}</xsl:attribute><xsl:attribute name="easid">{{../this.name}}</xsl:attribute></circle>

		{{/each}} 
		{{/each}}	
	</script>
	<script id="roadmapSvg2-template" type="text/x-handlebars-template">
		{{#each this.years}} 
			<circle r="4" stroke="black" stroke-width="1" fill="none"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">7</xsl:attribute></circle>
			<text y="10" style="font-size:8pt"><xsl:attribute name="x">{{#yearText this.pos}}{{/yearText}}</xsl:attribute>{{this.year}}</text>
			<line style="stroke:rgb(182, 182, 182);stroke-width:1" stroke-dasharray="5,5"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">10</xsl:attribute><xsl:attribute name="y1">{{#lineHeight ../this.length}}{{/lineHeight}}</xsl:attribute></line>
		{{/each}}
		{{#each this}} 
            <line style="stroke:rgb(206, 116, 185);stroke-width:30"><xsl:attribute name="x1">{{this.validEndDatePos}}</xsl:attribute><xsl:attribute name="x2">{{this.validStartDatePos}}</xsl:attribute><xsl:attribute name="y2">{{#getRow @index}}{{/getRow}}</xsl:attribute><xsl:attribute name="y1">{{#getRow @index}}{{/getRow}}</xsl:attribute></line>
            <foreignObject eas-type="progname" x="3" width="280" class="nameClick">
                <xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                <xsl:attribute name="y">{{#getFORow this.pos this}}{{/getFORow}}</xsl:attribute>
                <xsl:attribute name="height">40</xsl:attribute>
                <xhtml> 
                        {{#ifEquals this.plans.length 0}}{{else}}<i class="fa fa-info-circle roadInfo"><xsl:attribute name="onclick">roadInfo('{{this.id}}')</xsl:attribute></i>{{/ifEquals}} <xsl:text> </xsl:text>{{{essRenderInstanceMenuLink this}}} 
                        <!--   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
                </xhtml>
            </foreignObject>

		 <!-- <text x="3"><xsl:attribute name="y">{{#getRowText @index}}{{/getRowText}}</xsl:attribute>{{this.name}}</text>-->
		  <circle cx="20" r="8" stroke="black" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.validStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
		  <circle cx="20" r="8" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA"><xsl:attribute name="cx">{{this.validEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
		{{/each}}	
	</script>
	<script id="planSvg-template" type="text/x-handlebars-template">
		{{#each this.years}} 
			<circle r="4" stroke="black" stroke-width="1" fill="none"><xsl:attribute name="cx">{{this.pos}}</xsl:attribute><xsl:attribute name="cy">7</xsl:attribute></circle>
			<text y="10" style="font-size:8pt"><xsl:attribute name="x">{{#yearText this.pos}}{{/yearText}}</xsl:attribute>{{this.year}}</text>
		<line style="stroke:rgb(182, 182, 182);stroke-width:1" stroke-dasharray="5,5"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">10</xsl:attribute><xsl:attribute name="y1">{{#lineHeight ../this.length}}{{/lineHeight}}</xsl:attribute></line>
		{{/each}}
		{{#each this}} 
<!--			<path stroke-linecap="round" style="stroke:#5cbde2;stroke-width:30"><xsl:attribute name="d">M{{this.validStartDatePos}} {{#getRow @index}}{{/getRow}} l{{this.validEndDatePosStroke}} 0</xsl:attribute></path>-->
           <!--<path stroke-linecap="round" style="stroke:#5cbde2;stroke-width:30"><xsl:attribute name="d">M{{this.validStartDatePos}} {{#getRow @index}}{{/getRow}} l{{this.validEndDatePosStroke}} -30 l0 60 l-408.4031599123768 -30</xsl:attribute></path>-->
			<polygon fill="#c6a6ee73" stroke="black" stroke-width="1" ><xsl:attribute name="points">{{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getTopRight @index validEndDatePos}}{{/getTopRight}}  {{this.validEndDatePos}},{{#getRow @index}}{{/getRow}} {{#nudgeBack this.validEndDatePos}}{{/nudgeBack}},{{#getbottomRight @index validEndDatePos}}{{/getbottomRight}} {{this.validStartDatePos}},{{#getbottomLeft @index validStartDatePos}}{{/getbottomLeft}} {{this.validStartDatePos}},{{#getTopLeft @index validStartDatePos}}{{/getTopLeft}}</xsl:attribute></polygon> 
 <!--
			// top right sq, x, y
			// point x,y
			// bottom right x, y
			//bottom left x,y
			//top left x, y
 -->
		<!--	<line style="stroke:rgb(67, 67, 67);stroke-width:4"><xsl:attribute name="x1">{{this.todayPos}}</xsl:attribute><xsl:attribute name="x2">{{this.validStartDatePos}}</xsl:attribute><xsl:attribute name="y2">{{#getRow @index}}{{/getRow}}</xsl:attribute><xsl:attribute name="y1">{{#getRow @index}}{{/getRow}}</xsl:attribute></line> -->
            <foreignObject eas-type="progname" x="3" width="280" class="nameClick">
                <xsl:attribute name="easid">{{this.id}}</xsl:attribute>
                <xsl:attribute name="y">{{#getFORow this.pos this}}{{/getFORow}}</xsl:attribute>
                <xsl:attribute name="height">40</xsl:attribute>
                <xhtml>  
					<div style="white-space: normal; word-wrap: break-word;">
						<!--{{#ifEquals this.projects.length 0}}{{else}}<i class="fa fa-info-circle"><xsl:attribute name="onclick">projInfo('{{this.id}}')</xsl:attribute></i>{{/ifEquals}}-->
						<xsl:text> </xsl:text><span style="font-size:1em">{{{essRenderInstanceMenuLink this}}} 
						</span>
					</div>
						
                        <!--   {{#formatName this.name}}{{/formatName}}:{{#getFORow  this.pos}}{{/getFORow}}-->
                </xhtml>
            </foreignObject>
			<!--
			<rect height="15" class="infoBox" style="fill:rgb(39, 174, 77);stroke-width:0;stroke:rgb(0,0,0); rx:3"><xsl:attribute name="eastype">plan</xsl:attribute><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="width">{{#getRecWidth this.projects.length}}{{/getRecWidth}}</xsl:attribute><xsl:attribute name="x">{{#getRecX this.validEndDatePos}}{{/getRecX}}</xsl:attribute><xsl:attribute name="y">{{#getRecRow @index}}{{/getRecRow}}</xsl:attribute></rect>
			<text fill="white" class="infoBox" font-weight="bold"><xsl:attribute name="eastype">plan</xsl:attribute><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="x">{{#getRecXText this.validEndDatePos this.projects.length}}{{/getRecXText}}</xsl:attribute><xsl:attribute name="y">{{#getRowText @index}}{{/getRowText}}</xsl:attribute>{{this.projects.length}}</text>
			-->
		 <!-- <text x="3"><xsl:attribute name="y">{{#getRowText @index}}{{/getRowText}}</xsl:attribute>{{this.name}}</text>-->
		  <circle cx="20" r="8" stroke="black" stroke-width="2" fill="white"><xsl:attribute name="cx">{{this.validStartDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
		  <circle cx="20" r="8" stroke="#89CFF0" stroke-width="2" fill="#ffffffAA"><xsl:attribute name="cx">{{this.validEndDatePos}}</xsl:attribute><xsl:attribute name="cy">{{#getRow @index}}{{/getRow}}</xsl:attribute></circle>
		{{/each}}	
	</script>
	
<script id="impacts-template" type="text/x-handlebars-template">
	<h3>Impacts</h3>

	<div class="monopoly-card-container">
	{{#each this.p2e}}
		<div class="monopoly-card">
			<div class="card-name">{{this.name}}</div>
			<div class="card-action"><span class="label label-info">{{this.action}}</span></div>
			<div class="card-head">{{this.eletype}}</div>
		</div>  
	{{/each}}
	</div>
</script>	 
<script id="life-template" type="text/x-handlebars-template">
Project Status:
 {{#each this}}
	{{#ifEquals this.className 'Project_Lifecycle_Status'}}
	<span class="label"><xsl:attribute name="style">color:{{this.colour}};background-color:{{this.bgColour}}</xsl:attribute>{{this.name}}</span>
	{{/ifEquals}}
 {{/each}}
</script>
<script id="planstableRow-template" type="text/x-handlebars-template">
	<table class="table table-striped table-bordered" id="dt_stratPlans">
			<thead>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Plan')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-10pc" >
						<xsl:value-of select="eas:i18n('Valid From Start Date')"/>
					</th>
					<th class="cellWidth-10pc">
						<xsl:value-of select="eas:i18n('Valid To Start Date')"/>
					</th>
					<th class="cellWidth-10pc">
						<xsl:value-of select="eas:i18n('Projects')"/>
					</th>
				</tr>
			 </thead>
			 <tbody>
				{{#each this}}<tr><td><i class="fa fa-paper-plane-o plan"/><xsl:text> </xsl:text>{{{essRenderInstanceMenuLink this}}}</td><td></td><td>{{validStartDate}}</td><td>{{validEndDate}}</td><td class="tdcentre"><span class="label label-success">{{this.projects.length}}</span></td></tr>{{/each}}
			</tbody>
			<tfoot>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Roadmap')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-10pc" >
						<xsl:value-of select="eas:i18n('Valid From Start Date')"/>
					</th>
					<th class="cellWidth-10pc">
						<xsl:value-of select="eas:i18n('Valid To Start Date')"/>
					</th>
					<th class="cellWidth-10pc">
						<span class="label label-success impactsButton" easprojid="store_283_Class1902" easprogid="store_283_Class1932">12</span><xsl:value-of select="eas:i18n('Projects')"/>
					</th>
				</tr>
			</tfoot>
		</table>
</script>

<script>;	 
 
 <xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template>

	var defaultCurrency='<xsl:value-of select="/node()/simple_instance[type='Currency'][own_slot_value[slot_reference='currency_is_default']/value='true']/own_slot_value[slot_reference='currency_symbol']/value"/>';


 	var lifes=[<xsl:apply-templates select="$projectStatus" mode="lifecycle"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>];
 console.log('defaultCurrency', defaultCurrency)
lifes=lifes.sort((a, b) => a.enumeration_value - b.enumeration_value);

	 
	 <!-- plans via Project -->
	let allPlans=[<xsl:apply-templates select="$allStrategicPlans" mode="plan"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>];
	let styles=[<xsl:apply-templates select="$planningActions union $projectStatus union $planningStatus" mode="styles"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>];
 	let roadmaps=[<xsl:apply-templates select="$allRoadmaps" mode="roadmaps"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>];
	let allProject=[<xsl:apply-templates select="$fullprojectsList" mode="projects"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>];
	let currency = "<xsl:value-of select="$defaultCurrencySymbol"/>";
	let activeTab
console.log('allp', allPlans)
	var tab = $('.tab-content > .active').get(0);  
	
	$(document).ready(function ()
	{
		// compile any handlebars templates
		

		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('formatCost', function (arg1) {
			return new Intl.NumberFormat().format(arg1) 
		});


		Handlebars.registerHelper('checkStatus', function(arg1, arg2, options) {
			let colours='';
			let cst =parseInt(arg1.totalCost.replace(/[$,]+/g,""))
			let bud =parseInt(arg1.totalBudget.replace(/[$,]+/g,""))
			if(cst &gt; bud){
				colours='background-color:#FF0000;color:#fff';
			}
			else{
				colours='background-color:#4f8f4f;color:#fff';
			}
			return colours;
		});
		
		Handlebars.registerHelper('getProjectColour', function(arg1, options) {
			let lifeCol= lifes.find((s)=>{
				return s.id==arg1.lifecycleStatusId

			})
            if(lifeCol){
			    return lifeCol.bgColour;
            }else{
                return '#d3d3d3';
            }
		});

		Handlebars.registerHelper('getRowText', function(arg1, options) {
			return (arg1 * 42)+43;
		});
		
        Handlebars.registerHelper('getFORow', function(arg1, arg2, options) {
			if(arg2){
				 
				if(arg2.name.length &gt;45){
					return (arg1 * 42)+20;

				}else{

					return (arg1 * 42)+30;
				}

			} else{
				return (arg1 * 42)+30;
			}
		});
		
        Handlebars.registerHelper('getRecRow', function(arg1, options) {
			return (arg1 * 42)+32;
		});

		Handlebars.registerHelper('getRecWidth', function(arg1, options) {
			if(arg1 &lt;10){
				return 16
			}
			else if(arg1 &lt;100){
				return 23
			}
			else if(arg1 &lt;1000){
				return 33
			}
			else{
				return 43
			}
			return (arg1 * 42)+5;
		});
		

		Handlebars.registerHelper('getRecXText', function(arg1, arg2, options) {
			let x=19;
			if(arg2 &gt;99){x=15}
			else if(arg2 &gt;9){x=17}

			return (arg1 + 19);
		});
		
		Handlebars.registerHelper('getRecX', function(arg1, options) {
			return (arg1 + 15);
		});

        Handlebars.registerHelper('getRowMilestoneText', function(arg1) {
			return (arg1 * 42)+33;
        });
        
        Handlebars.registerHelper('formatName', function(arg1) {
                if(arg1.length&gt;35){
                    arg1=arg1.substring(0,35)+'...';
                }
            	return arg1;
        });
		 
		Handlebars.registerHelper('getRow', function(arg1, options) {
			return (arg1 * 42)+40;
		});
		Handlebars.registerHelper('yearText', function(arg1, options) {
			return (arg1 + 7);
		});
		Handlebars.registerHelper('lineHeight', function(arg1, options) {
			return (arg1 *42)+80;
        });

        Handlebars.registerHelper('projectlineHeight', function(arg1, options) {
            return (arg1.focusProjects.length *42)+80;

        });

		Handlebars.registerHelper('roadmaplineHeight', function(arg1, options) {
            return (arg1.length *42)+80;

        });

		
		Handlebars.registerHelper('nudgeBack', function(arg1, arg2) {
			//take 40px off for polygons
			return arg1 -20;
		});
		Handlebars.registerHelper('getTopRight', function(arg1, arg2) {
			//getTopRight @index validEndDatePosStroke
			return (arg1 * 42)+25;
		});

		Handlebars.registerHelper('getPoint', function(arg1) {
			//getPoint @index validEndDatePosStroke
			return arg1 + 40;
		});
		
		Handlebars.registerHelper('getbottomRight', function(arg1, arg2) {
			//getTopRight @index validEndDatePosStroke
			return (arg1 * 42)+55;
		});

		Handlebars.registerHelper('getbottomLeft', function(arg1, arg2) {
			//getbottomLeft @index validStartDatePos
			return (arg1 * 42)+55;
		});

		Handlebars.registerHelper('getTopLeft', function(arg1, arg2) {
			//getTopLeft @index validStartDatePos
			return (arg1 * 42)+25;
		});
        
        Handlebars.registerHelper('getPolyPoints', function(arg1, arg2) {
            let x1=arg1 - 5;
            let y1=(arg2 * 42)+40;
            let x2=arg1;
            let y2=(arg2 * 42)+35;
            let x3=arg1 + 5
            let y3=(arg2 * 42)+45; 
             
            let points= x1+','+y1+' '+ x2+','+y2+' '+x3+','+y1+' '+x2+','+y3; 
            return points;
		})
		
		Handlebars.registerHelper('shade', function(arg1, arg2) {
				let op=0.1*arg2;
				return 1-(1 * op);
		});

		Handlebars.registerHelper('showPlan', function(arg1, arg2, options) {
	
			let match=0;
			let res=[]
			let resHTML='';
			arg1.forEach((e)=>{
				var thisPlan = d3.nest()
				.key(function(d) { return d.planid; })
				.entries(e.p2e);
			
			let results = arg2.plans.filter(({ key: id1 }) => !thisPlan.some(({ key: id2 }) => id2 === id1));
			if(results.length&gt;0){
				results.forEach((r)=>{
					res.push(r)
					resHTML=resHTML+'<li class="roleBlob sp" style="background-color: rgb(161,178,195)">'+r.name+'</li>';
					})
				}
			})
				return resHTML;
		});
	});
		
	
</script>
		</html>
	</xsl:template>     
	
	<xsl:template name="RenderViewerAPIJSFunction"> 
			<xsl:param name="viewerAPIPathCap"/>
			<xsl:param name="viewerAPIPathAT"/> 
			<xsl:param name="viewerAPIPathProcess"/>
			<xsl:param name="viewerAPIPathPlanning"/>
			
			//a global variable that holds the data returned by an Viewer API Report 
			var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCap"/>';
			var viewAPIDataAT = '<xsl:value-of select="$viewerAPIPathAT"/>';
			var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>';
			var viewAPIDataPlanning = '<xsl:value-of select="$viewerAPIPathPlanning"/>';
			//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
			let programmesToShow=[];
			let plansToShowAll=[];
			let roadmapsToShow=[];
			let projectToShow=[];

			let progToShowData=[];
			let plansToShow=[];
			let rmaps=[]
			let projs=[];
			let liveProjects;
			$('#appPanel').hide();
		   var programmes=[<xsl:apply-templates select="$programmes" mode="programme"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>];
	console.log('programmes',programmes)
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
	  let today=moment().format('YYYY-MM-DD');  
	  var orgData=[];
	  var appsData=[];
	  let posCount;
	  var focusID="<xsl:value-of select='eas:getSafeJSString($param1)'/>";
	  let currentYear='01-01-'+ new Date().getFullYear();
	  let chartStartDate = '01-01-'+ (new Date().getFullYear()-1);
	  let chartEndDate='01-01-'+ (new Date().getFullYear()+4)
	  // change dat format needed for safari browsers
	  currentYear=currentYear.replace(/-/g, '/');
	  chartStartDate=chartStartDate.replace(/-/g, '/');
	  chartEndDate=chartEndDate.replace(/-/g, '/');
	  let thisYr= new Date().getFullYear()-1
	  let getYears=[];
		for(i=0; i&lt; 5;i++){ 
			getYears.push({"year":'01/01/'+thisYr});
			thisYr=thisYr+1
		};	
let currentYearYYYY = new Date().getFullYear();
let startYear = new Date(chartStartDate).getFullYear() - 4;
let endYear = new Date(chartStartDate).getFullYear() + 7;
let endDropYear=startYear+9;
for (let y = startYear; y &lt;= endYear; y++) {
	  if(y==currentYearYYYY-1){
  		$('#startYear').append('<option value="' + y + '" selected="true">' + y + '</option>');
	  }
	  else{
		$('#startYear').append('<option value="' + y + '">' + y + '</option>');
	  }
  if(y==endDropYear){
  	$('#endYear').append('<option value="' + y + '" selected="true">' + y + '</option>');
  }
  else{
	  $('#endYear').append('<option value="' + y + '">' + y + '</option>');
  }
}


$('#startYear').select2({width:100})
$('#endYear').select2({width:100})
$('#programme').select2({width:200})


$('#startYear').val(currentYearYYYY);
$('#endYear').val(currentYearYYYY + 4);

programmes.forEach((e)=>{
	 $('#programme').append('<option value="' + e.id + '">' + e.name + '</option>');
})

	  let chartStartPoint= 300;

	  var rolesFragment, appsnippetTemplate, appsnippetFragment, appsFragment, processesFragment, sitesFragment, rolesTemplate, appsTemplate, processesTemplate,sitesTemplate ;
	
			$('document').ready(function () {

				var impactsFragment = $("#impacts-template").html();
				impactsTemplate = Handlebars.compile(impactsFragment);
				
				var lifeFragment = $("#life-template").html();
				lifesTemplate = Handlebars.compile(lifeFragment);

				var projectsvgFragment = $("#projectSvg-template").html();
				projectsvgTemplate = Handlebars.compile(projectsvgFragment);
	 
		 		var projectPlanssvgFragment = $("#projectPlansSvg-template").html();
				projectPlanssvgTemplate = Handlebars.compile(projectPlanssvgFragment);
		 
				var planssvgFragment = $("#planSvg-template").html();
				planssvgTemplate = Handlebars.compile(planssvgFragment);

				var planstabsvgFragment = $("#planRowSvg-template").html();
				planstabsvgTemplate = Handlebars.compile(planstabsvgFragment);
 
				var roadmapsvgFragment = $("#roadmapSvg-template").html();
				roadmapsvgTemplate = Handlebars.compile(roadmapsvgFragment);
				
				var roadmapsvgwithPlansFragment = $("#roadmapSvgPlans-template").html();
				roadmapsvgwithPlansTemplate = Handlebars.compile(roadmapsvgwithPlansFragment);

				var sptableInfoFragment = $("#planstableRow-template").html();
				sptableInfo = Handlebars.compile(sptableInfoFragment);
				 
				var planInfoFragment = $("#planInformation-template").html();
				planInfo = Handlebars.compile(planInfoFragment); 
	 

 
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
				focusProgramme='<xsl:value-of select="$param1"/>';
	//get data
	Promise.all([ 
			promise_loadViewerAPIData(viewAPIDataCaps),
			promise_loadViewerAPIData(viewAPIDataAT),
			promise_loadViewerAPIData(viewAPIDataProcess),
			promise_loadViewerAPIData(viewAPIDataPlanning)
			]).then(function(responses) {
 
				   capData=responses[0];
				   appTechData=responses[1]; 
				   processData=responses[2]; 
				   plans=responses[3];
 
if(roadmaps.length&gt;0){
	roadmaps.forEach((rd)=>{
		let rdPlans=[];

		if(rd.strategicPlans.length&gt;0){ 
		rd.strategicPlans.forEach((sp)=>{ 
			let thisPlan=allPlans.find((pl)=>{
				return pl.id==sp;
			}); 
		if(thisPlan.validStartDate ==''){thisPlan.validStartDate = moment(today)}
		if(thisPlan.validEndDate ==''){thisPlan.validEndDate = moment(today)}		
			rdPlans.push(thisPlan)
		})
	
	}
	 
		rd['plans']=rdPlans;

		rdPlans.sort(function(a,b){
		let vala=new Date(a.validStartDate).getTime();
		let valb=new Date(b.validStartDate).getTime();
		return vala - valb; 
		});
		if(rdPlans.length&gt;0){
		let lastDate = new Date(Math.max(...rdPlans.map(e => new Date(e.validEndDate))));
		
		rd['start']= moment(rdPlans[0].validStartDate, "YYYY-MM-DD").toDate();
		rd['startYY']= rdPlans[0].validStartDate;
		rd['end']=moment(lastDate, "YYYY-MM-DD").toDate(); 
		rd['endYY']=moment(lastDate).toISOString().substring(0,10); 
		}
		else
		{
			rd['start']= moment().toDate();
			rd['startYY']= moment().toDate();;
			rd['end']=moment().toDate();; 
			rd['endYY']=moment().toISOString().substring(0,10); 
		}
		});

};
 
		projectToShow=[]
			if(allProject.length&gt;0){					
				allProject.filter((e)=>{
					let thisDate;
					if(e.targetEndDate){
						thisDate = moment(e.targetEndDate, "YYYY-MM-DD").toDate()}
					else if(e.proposedStartDate){
						thisDate = moment(e.forecastEndDate, "YYYY-MM-DD").toDate()}    
					else if(e.actualStartDate){
						thisDate = moment(e.actualStartDate, "YYYY-MM-DD").toDate()}
					else if(e.proposedStartDate){
						thisDate = moment(e.proposedStartDate, "YYYY-MM-DD").toDate()}
					else{
						thisDate=moment(today).subtract(1, 'days')
					}   
					projectToShow.push(e)
			//		if((moment(thisDate).isSameOrAfter(moment(today)))){projectToShow.push(e)}
					if((moment(e.targetEndDate).isSameOrAfter(moment(today)))){liveProjects=liveProjects+1}
				});  
			}
				if(roadmaps){
					roadmaps.filter((road)=>{

						let thisDate;
						if(road.end){
							thisDate = moment(road.end, "YYYY-MM-DD").toDate()}
						else if(road.start){
							thisDate = moment(road.start, "YYYY-MM-DD").toDate()}   
						else{
							thisDate=moment(today).subtract(1, 'days')
						}   
						if((moment(thisDate).isSameOrAfter(moment(today)))){roadmapsToShow.push(road)}
					});
				}
				  
			programmesToShow['inperiod']='checked';
			if(allPlans.length&gt;0){			
				allPlans.filter((e)=>{
					let thisDate; 
					if(e.validEndDate){
						thisDate = moment(e.validEndDate, "YYYY-MM-DD").toDate()}
					else if(e.validStartDate){
						thisDate = moment(e.validStartDate, "YYYY-MM-DD").toDate()}    
					else{
						thisDate=moment(today).subtract(1, 'days')
					}   
					plansToShowAll.push(e)
	//				if((moment(thisDate).isSameOrAfter(moment(today)))){plansToShowAll.push(e)}
				})  
			}
				 
			plansToShow=plansToShowAll;
/*
			plansToShow=plansToShow.filter((e)=>{
				return e.projects.length > 0;
			})

	*/		
			projs=projectToShow; 
 
			projs.forEach((p)=>{
				let costNum=expandCostData(p.costs)
				let tots=calculateTotals(costNum)
		 
				p['costbreakdown']=tots;
				p['currency']=defaultCurrency;
			})
			$('#planTabs').html(planstabsvgTemplate(plansToShow))

			drawView(plansToShow, projs, roadmapsToShow );
			essInitViewScoping(redrawView, ['Group_Actor', 'SYS_CONTENT_APPROVAL_STATUS']);

		})
		.catch (function (error) {
			//display an error somewhere on the page   
		});

	});	

// Redraws the view by applying scope to different resource types and drawing the view with the scoped resources
var redrawView = function () { 
    // Define scoping properties
    let orgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
    let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
    let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');

    // Apply scoping to resources
    let scopedPlan = essScopeResources(plansToShow, [orgScopingDef, geoScopingDef, visibilityDef]);
    let scopedProject = essScopeResources(projectToShow, [orgScopingDef, geoScopingDef, visibilityDef]); 
	
    // Removing duplicate projects
    scopedProject.resources = scopedProject.resources.filter((elem, index, self) => 
        self.findIndex( (t) => { return (t.id === elem.id)}) === index
    );


    let scopedProgramme = essScopeResources(programmesToShow, [orgScopingDef, geoScopingDef, visibilityDef]);
    let scopedRoadmaps = essScopeResources(roadmapsToShow, [orgScopingDef, geoScopingDef, visibilityDef]);

    // Prepare new resources to show
    let newPlanToShow=[]
    scopedPlan.resources.forEach((d)=>{
        newPlanToShow.push(d);
    })
    newPlanToShow['years'] = plansToShow.years;
    newPlanToShow['posCount'] = plansToShow.posCount;

    let newProjectToShow=[]
    scopedProject.resources.forEach((d)=>{
        newProjectToShow.push(d);
    })
    newProjectToShow['years'] = projectToShow.years;
    newProjectToShow['posCount'] = projectToShow.posCount;


    // Draw view with new resources
    drawView(newPlanToShow, newProjectToShow, newRoadmapsToShow)
}

// Draw view by filtering out plans without any projects and creating dataset
function drawView(plansToShow, projs, roadmaps){
    // Filter out plans that don't have any projects
	/*
    plansToShow = plansToShow.filter((e)=>{
        return e.projects.length > 0
    })
	*/
    // Prepare dataset
    let dataSet=[{
        "plans": plansToShow,
        "projects": projs,
		"roadmapsToShow": roadmapsToShow
    }]

    // Promise to resolve or reject
    let panelSet = new Promise(function(myResolve, myReject) {
        let csddate = moment(chartStartDate, 'DD-MM-YYYY').toISOString();
        let ceddate = moment(chartEndDate, 'DD-MM-YYYY').toISOString();
        myResolve(); // when successful
        myReject();  // when error
    });

    // When Promise is resolved, call setSVG function
    panelSet.then(function(response) {
        setSVG(plansToShow, projs, roadmapsToShow);
    });

    // Handle tab shown event
    $('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ 
        $($.fn.dataTable.tables(true)).DataTable().columns.adjust(); 
    });

    // Trigger click event on active tab
    $('#' + activeTab + 'Tab').click();

    // Handle years change event
    $('.years').on('change', function(){
        setNewYears()
    });

function setNewYears(){
	let sd=$('#startYear').val()
	let ed=$('#endYear').val()
	chartStartDate = '01-01-'+ sd;
	chartEndDate='01-01-'+ ed;
	chartStartDate=chartStartDate.replace(/-/g, '/');
	chartEndDate=chartEndDate.replace(/-/g, '/');
	getYears=[];
	thisYr=parseInt(sd);
	
	for(i=0; i&lt; (ed-sd);i++){  
		getYears.push({"year":'01-01-'+(parseInt(thisYr)+i)});
 
		
	};
		
	let check=$(this).is(":checked")
	filterDates(check)
}

}
/**
 * Filters and displays data based on date criteria.
 * @param {boolean} cbox - Checkbox value indicating whether to filter data or not.
 */
function filterDates(cbox) {
  var newtab = $('.tab-content > .active').get(0);
  var activeTab = $(newtab).attr('id');
  var programmesToShow = [];
  var plansToShow = [];
  var roadmapsToShow = [];
  var projectToShow = [];

  if (cbox === true) {
    var liveProjects = 0;

    projs.filter((e) => {
      let thisDate;

      if (e.targetEndDate) {
        thisDate = moment(e.targetEndDate, "YYYY-MM-DD").toDate();
      } else if (e.proposedStartDate) {
        thisDate = moment(e.forecastEndDate, "YYYY-MM-DD").toDate();
      } else if (e.actualStartDate) {
        thisDate = moment(e.actualStartDate, "YYYY-MM-DD").toDate();
      } else if (e.proposedStartDate) {
        thisDate = moment(e.proposedStartDate, "YYYY-MM-DD").toDate();
      } else {
        thisDate = moment(today).subtract(1, 'days').toDate();
      }

      if (moment(thisDate).isSameOrAfter(moment(today))) {
        projectToShow.push(e);
      }
      if (moment(e.targetEndDate).isSameOrAfter(moment(today))) {
        liveProjects = liveProjects + 1;
      }
    });

    allPlans.filter((e) => {
      let thisDate;

      if (e.validEndDate) {
        thisDate = moment(e.validEndDate, "YYYY-MM-DD").toDate();
      } else if (e.validStartDate) {
        thisDate = moment(e.validStartDate, "YYYY-MM-DD").toDate();
      } else {
        thisDate = moment(today).subtract(1, 'days').toDate();
      }

      if (moment(thisDate).isSameOrAfter(moment(today))) {
        plansToShow.push(e);
      }
    });
  } else {
    allProject.forEach((d) => {
      projectToShow.push(d);
    });
    plansToShow = allPlans;
  }

  $('#programme').on('change', function() {
    let progSelection = $('#programme').val();

    projectToShow = projectToShow.filter((e) => {
      return e.programme == progSelection;
    });

    redrawView();
  });

  drawView(plansToShow, projectToShow);
}

function roadInfo(rdId){ 
	let focusRoadmap = roadmaps.find((e)=>{
		return e.id == rdId;
	});
	let thisPlans=focusRoadmap.plans; 
	let popsvgWidth = 730;
	let plLength = (typeof thisPlans === 'undefined') ? 1 : thisPlans.length+1;
	$('#roadmapPlansSVG').attr('height', (plLength+1)*34);
	  
	// where timeline begins
	var popchartWidth= popsvgWidth-(chartStartPoint+30);
	getYears.forEach((y)=>{
		y['pos']=getPosition(chartStartPoint, popchartWidth, chartStartDate, chartEndDate, y.year)
	});

	let lastYear=getYears[getYears.length - 1] 

	var plcount=0;
    
	thisPlans['years']=getYears;
 
    thisPlans.forEach((pl)=>{
		pl["todayPos"]= getPosition(chartStartPoint, popchartWidth, chartStartDate, chartEndDate, new Date());
		
        pl["validStartDatePos"]= getPosition(chartStartPoint, popchartWidth, chartStartDate, chartEndDate, pl.validStartDate);
        pl["validEndDatePos"]= getPosition(chartStartPoint, popchartWidth, chartStartDate, chartEndDate, pl.validEndDate);
        pl["validEndDatePosStroke"]= pl.validEndDatePos - pl.validStartDatePos;

        if(pl.validStartDatePos ==""){
			pr["actualStartDatePos"]=255;		
		}
		if(pl.validStartDatePos ==""){
			pr["validEndDatePos"]=255;		
		}
		if(pl.todayPos&lt;pl.validStartDatePos){
			pl.todayPos=pl.validStartDatePos;
		}
		if(pl.todayPos&gt;pl.validEndDatePos){
				pl.todayPos=pl.validEndDatePos;
        }
        if(!(pl.validEndDatePos)){
			pl.todayPos=250;
        }
		 
        pl['posCount']=plcount;
        pl['pos']=plcount;
        plcount=plcount+1;
    })
    thisPlans['posCount']=plcount+2;
	
}


function setSVG(thisPlans, thisProjects, thisRoadmaps) {

let progSelection = $('#programme').val();

var svgWidth = $(window).width() * 0.79;
var planLength = (typeof thisPlans === 'undefined') ? 1 : thisPlans.length + 1; 
var projectLength = (typeof thisProjects === 'undefined') ? 1 : thisProjects.length + 1;
var roadmapLength = (typeof thisRoadmaps === 'undefined') ? 1 : thisRoadmaps.length + 1;
$('#plansSvg').attr('height', (planLength + 1) * 48);

let allProjLen=1
thisPlans.forEach((d)=>{
	allProjLen=allProjLen+d.projects.length
})

$('#plansProjSvg').attr('height', (planLength + allProjLen) * 48);
$('#projectsSvg').attr('height', (projectLength + 1) * 48);
$('#roadmapsSvg').attr('height', (roadmapLength + 1) * 48);


// where timeline begins
var chartWidth = svgWidth - (chartStartPoint + 50);

getYears.forEach((y) => {
	y['pos'] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, y.year)
});
let lastYear = getYears[getYears.length - 1];

if (isNaN(lastYear)) {
	lastYear = getYears[getYears.length - 2]
}


if (lastYear) {
	let lydate = moment(lastYear.year, 'DD-MM-YYYY').toISOString();

	let yearEnd = parseInt(moment(lydate).year()) + 1;

	let finalYear = '01-01-' + (yearEnd + 1);

	getYears.push({
		"year": finalYear,
		"pos": getPosition(chartStartPoint, chartWidth, chartStartDate.replace(/-/g, '/'), chartEndDate.replace(/-/g, '/'), finalYear.replace(/-/g, '/'))
	})
}
console.log('gy2',getYears)
var plcount = 0;
thisPlans['years'] = getYears;
thisPlans.forEach((pl) => {
	pl["todayPos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, new Date());


	pl["validStartDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, pl.validStartDate);
	pl["validEndDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, pl.validEndDate);
	pl["validEndDatePosStroke"] = pl.validEndDatePos - pl.validStartDatePos;

	if (pl.validStartDatePos == "") {
		pr["actualStartDatePos"] = 255;
	}
	if (pl.validStartDatePos == "") {
		pr["validEndDatePos"] = 255;
	}
	if (pl.todayPos &lt; pl.validStartDatePos) {
		pl.todayPos = pl.validStartDatePos;
	}
	if (pl.todayPos &gt; pl.validEndDatePos) {
		pl.todayPos = pl.validEndDatePos;
	}
	if (!(pl.validEndDatePos)) {
		pl.todayPos = 250;
	}

	pl['posCount'] = plcount;
	pl['pos'] = plcount;
	plcount = plcount + 1;
	
})
thisPlans['posCount'] = plcount + 2;

$('#plansSvg').html(planssvgTemplate(thisPlans))


//set up plans proj array.

let allPlanProjArray=[]

 
thisPlans.forEach((d)=>{
	allPlanProjArray.push(d);
	d.projects.forEach((e)=>{
		e['type']='Project';
		allPlanProjArray.push(e)
	})
	 
})

allPlanProjArray['ppheight']=(allPlanProjArray.length*46)+20;
allPlanProjArray['years']=getYears; 
 
thisPlans.forEach((d) => {
	let planProjectLength = (typeof d.projects === 'undefined') ? 1 : d.projects.length + 1;
	d['years'] = getYears;

	let lifeColours = lifes.filter((s) => {
		return (s.className == 'Project_Lifecycle_Status')
	})

	d['lifeColours'] = lifeColours
	let projcount = 0;

	d['focusProjects'] = d.projects

	if (progSelection !== 'all') {
		let focusProjects = d.focusProjects.filter((e) => {
			return e.programme == progSelection
		})
		d.focusProjects = focusProjects;
	}

	if (d.focusProjects.length &gt; 0) {
		d['hasProjects'] = 'Y';
	} else {
		d['hasProjects'] = 'N';
	}

	d.focusProjects.forEach((pr) => {
		pr["todayPos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, new Date());
		pr["proposedStartDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, pr.proposedStartDate)
		pr["targetEndDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, pr.targetEndDate)
		pr["actualStartDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, pr.actualStartDate)
		pr["forecastEndDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, pr.forecastEndDate)
		if (pr.milestones) {
			pr.milestones.forEach((m) => {
				m["milestoneDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, m.milestone_date)
			});
		}

		if (pr.todayPos &gt; pr.targetEndDatePos) {
			pr.todayPos = pr.targetEndDatePos;
		}
		if (pr.todayPos &lt; pr.proposedStartDatePos) {
			pr.todayPos = pr.proposedStartDatePos;
		}

		if (pr.actualStartDate == "") {
			pr["actualStartDatePos"] = pr["proposedStartDatePos"];
		}

		if ((pr.forecastEndDatePos - 1) &lt;= pr.targetEndDatePos) {
			pr['onTrack'] = "Yes";
		} else {
			pr['onTrack'] = "No";
		}
		pr['posCount'] = projcount;
		pr['pos'] = projcount;
		projcount = projcount + 1;

		let thisApprovalStyle = styles.find((s) => {
			return pr.approvalId == s.id
		});
		if (thisApprovalStyle) {
			if (thisApprovalStyle.icon) {
				pr['approvalIcon'] = thisApprovalStyle.icon;
			} else {
				pr['approvalIcon'] = 'fa-question-circle';
			}
		}
		let monthsDiff = moment(pr.forecastEndDate).diff(moment(pr.actualStartDate), 'months', true)
		let yearsDiff = moment(pr.forecastEndDate).diff(moment(pr.actualStartDate), 'year', true)

	})

	if (d.hasProjects == 'Y') {

		$('#' + d.id + 'Tab').css('color', '#999999')
		$('#' + d.id + 'i').css('color', '#c3193c')
	} else {
		$('#' + d.id + 'Tab').css('color', '#d3d3d3')
		$('#' + d.id + 'i').css('color', '#d3d3d3')
	}
	let plength = (d.projects.length * 46)+20;
	$('[svgid="svg-' + d.id + '"]').css('width', '100%');
	$('[svgid="svg-' + d.id + '"]').css('height', plength + 'px');
	$('[svgid="svg-' + d.id + '"]').html(projectsvgTemplate(d));


	thisRoadmaps.forEach((rm) => {
		rm["todayPos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, new Date());
		rm["validStartDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, rm.startYY)
		rm["validEndDatePos"] = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, rm.endYY)
	});
	thisRoadmaps['years'] = getYears;

	$('#roadmapsSvg').html(roadmapsvgTemplate(thisRoadmaps))

	$(document).off('.expandRoadmap').on('click','.expandRoadmap', function(){
		let cleanRoadmap=[...thisRoadmaps];
		
		let targetId=$(this).attr('roadmapId');

		var index = cleanRoadmap.findIndex(function(obj) {
			return obj.id === targetId;
		});
		var focusRM = cleanRoadmap.find(function(obj) {
			return obj.id === targetId;
		});
		focusRM['selected']='Yes';
		let plansToUse=focusRM.plans;

	cleanRoadmap.splice(index+1, 0, ...plansToUse);
	cleanRoadmap['years']=thisRoadmaps.years

	$('#roadmapsSvg').attr('height', (cleanRoadmap.length + 1) * 48);
	$('#roadmapsSvg').html(roadmapsvgwithPlansTemplate(cleanRoadmap)) 
	focusRM['selected']='';
	})

	$(document).on('click','.closeRoadmap', function(){
		$('#roadmapsSvg').html(roadmapsvgTemplate(thisRoadmaps))
	});

	$(document).off('click', '.plancircle').on('click','.plancircle', function(){
		let thisId=$(this).attr('easplanid');
		
		let planMatch=plans.allPlans.find((d)=>{
			return d.id==thisId
		});

		let planMatch2=allPlans.find((d)=>{
			return d.id==thisId
		});
		// merge projects visa P2E and directly mapped to plan
		function mergePlans(planMatch, planMatch2) {
			planMatch2.forEach(plan2 => {
			 
				const exists = planMatch.some(plan => plan.id === plan2.id);
			 
				if (!exists) {
					planMatch.push(plan2);
				}
			});
			return planMatch;
		}
		 
	  mergePlans(planMatch.projects, planMatch2.projects);


		planMatch.projects.forEach((d)=>{
			d.p2e = d.p2e.reduce((acc, current) => {
				const x = acc.find(item => item.impactedElement === current.impactedElement);
				if (!x) {
				  return acc.concat([current]);
				} else {
				  return acc;
				}
			  }, []);

			  let costNum=expandCostData(d.costs)
				let tots=calculateTotals(costNum)
		 
				d['costbreakdown']=tots;

				d['currency']=defaultCurrency;
		})


		console.log('pm',planMatch)

	$('#informationBox').html(planInfo(planMatch))
		openNav();

	$('.impactsInfo').on('click' , function(){
			let thisId=$(this).attr('impactid')
			let focusPlan=planMatch.projects.find((e)=>{return e.id==thisId});
		console.log('fp', focusPlan)
			$('#slideUpData').html(impactsTemplate(focusPlan));
			$('#appPanel').show( "blind",  { direction: 'down', mode: 'show' },200 );
			
			//$('#appModal').modal('show');
			$('.closePanelButton').on('click',function(){
			
				$('#appPanel').hide();
			})

		})
	})

	$(document).on('click','.slideClose', function(){
		closeNav();
	})

})

$('#plansProjSvg').html(projectPlanssvgTemplate(allPlanProjArray))

$('.lifekey').html(lifesTemplate(lifes))
}

function getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, thisDatetoShow){
 
	if(thisDatetoShow){
		thisDatetoShow=	moment(thisDatetoShow).format('YYYY-MM-DD');  
	thisDatetoShow=thisDatetoShow.replace(/-/g, '/')
	} 
	startDate = new Date(chartStartDate.replace(/-/g, '/'));
	endDate = new Date(chartEndDate.replace(/-/g, '/'));
 
    thisDate= new Date(thisDatetoShow); 
    pixels= chartWidth/(endDate-startDate);
	let thisDateforChart=((thisDate-startDate)*pixels)+chartStartPoint;
	if(isNaN(thisDateforChart)){thisDateforChart=-100}

	if(thisDateforChart&lt;chartStartPoint){
		thisDateforChart = chartStartPoint;
	}
    return thisDateforChart
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

function openNav()
{	
	document.getElementById("appSidenav").style.marginRight = "0px";
}

function closeNav()
{
	workingCapId=0;
	document.getElementById("appSidenav").style.marginRight = "-854px";
}

function generateMonthlyCosts(data, startYear, years) {
    let monthlyCosts = [];
    let currentDate = new Date(startYear, 0, 1); // Starting from January of the start year
    let endDate = new Date(startYear + years, 0, 1); // Up to the beginning of the year after the last year

    while (currentDate &lt; endDate) {
        let totalCostForMonth = 0;

        data.forEach(item => {
            let itemStartDate = new Date(item.startDate);
            let itemEndDate = item.endDate ? new Date(item.endDate) : endDate;

            if (itemStartDate &lt;= currentDate &amp;&amp; currentDate &lt;= itemEndDate) {
                if (item.recurrence === "Monthly_Budgetary_Element") {
                    totalCostForMonth += item.amount;
                } else if (item.recurrence === "Annual_Budgetary_Element") {
                    // Divide the annual amount by 12 to distribute it across the months
                    totalCostForMonth += item.amount / 12;
                }
            }
        });

        monthlyCosts.push({
            date: currentDate.toISOString().substring(0, 7), // Format as YYYY-MM
            totalCost: totalCostForMonth
        });

        currentDate.setMonth(currentDate.getMonth() + 1); // Move to the next month
    }

    return monthlyCosts;
}

function expandCostData(costs) {
	const months = { 'Monthly_Cost_Component': 1, 'Quarterly_Cost_Component': 3 };
	let expandedCosts = {};

	costs.forEach(cost => {
		let { recurrence, amount, startDate, endDate } = cost;

		// Initialize array for each cost type if not already initialized
		if (!expandedCosts[recurrence]) {
			expandedCosts[recurrence] = [];
		}

		// Parse the start and end dates
		let currentDate = new Date(startDate);
		const end = new Date(endDate);

		// Set monthly or quarterly increments
		let incrementMonths = months[recurrence] || 0;

		// Generate rows based on recurrence
		if (incrementMonths > 0) {
			while (currentDate &lt;= end) {
				expandedCosts[recurrence].push([currentDate.toISOString().split('T')[0], amount]); // Format as [date, amount]
				currentDate.setMonth(currentDate.getMonth() + incrementMonths);
			}
		} else {
			// For Adhoc, just add a single entry
			expandedCosts[recurrence].push([startDate, amount]); // Format as [date, amount]
		}
	});

	return expandedCosts;
}

//budget function
function expandBudgetData(budgets) {
const months = { 'Monthly_Budgetary_Element': 1, 'Quarterly_Budgetary_Element': 3 };
let expandedBudgets = {};

budgets.forEach(budget => {
	let { recurrence, amount, startDate, endDate } = budget;

	// Initialize array for each Budget type if not already initialized
	if (!expandedBudgets[recurrence]) {
		expandedBudgets[recurrence] = [];
	}

	// Parse the start and end dates
	let currentDate = new Date(startDate);
	const end = new Date(endDate);

	// Set monthly or quarterly increments
	let incrementMonths = months[recurrence] || 0;

	// Generate rows based on recurrence
	if (incrementMonths > 0) {
		while (currentDate &lt;= end) {
			expandedBudgets[recurrence].push([currentDate.toISOString().split('T')[0], amount]); // Format as [date, amount]
			currentDate.setMonth(currentDate.getMonth() + incrementMonths);
		}
	} else {
		// For Adhoc, just add a single entry
		expandedBudgets[recurrence].push([startDate, amount]); // Format as [date, amount]
	}
});
console.log('expandedBudget', expandedBudgets)
return expandedBudgets;
}    

//calculate totals

function calculateTotals(costData) {
const totals = {};

// Iterate over each property in the cost data
Object.keys(costData).forEach(key => {
	// Initialize total to 0 for each component
	totals[key] = 0;

	// Sum up all amounts in the data arrays for each component
	costData[key].forEach(costEntry => {
		totals[key] += costEntry[1]; // Add the second element of each array which is the cost
	});

});

return totals; 
}

//merges dates with the same data type but on different lines
function mergeAndSumDateValues(dataObject) {
// Iterate over each property in the data object
for (const key in dataObject) {
	const dateSums = {};  // Temporary object to hold sums of values by date for the current property

	// Process each date-value pair in the current property
	dataObject[key].forEach(([date, value]) => {
		if (dateSums[date]) {
			dateSums[date] += value;  // Add to the existing sum for this date
		} else {
			dateSums[date] = value;  // Initialize with the first value for this date
		}
	});

	// Replace the original array with a new array of merged and summed date-values
	dataObject[key] = Object.entries(dateSums).map(([date, sum]) => [date, sum]);
}

return dataObject;  // Optionally return the modified object for further use
}
 	
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

<xsl:template match="node()" mode="plan">
		<xsl:variable name="thisPlanStatus" select="$planningStatus[name=current()/own_slot_value[slot_reference = 'strategic_plan_status']/value]"/> 
		<xsl:variable name="p2eforplan" select="key('p2efromPlan_key', current()/name)"/>
		<xsl:variable name="projectsforplan" select="key('projectsfromPlan_key', $p2eforplan/name)"/> 

		<xsl:variable name="projectsdirectforplan" select="key('projectsDirectfromPlan_key', current()/own_slot_value[slot_reference='strategic_plan_supported_by_projects']/value)"/> 
 
		<xsl:variable name="objectivesforplan" select="key('objectives_key', current()/name)"/>  
		<xsl:variable name="driversforplan" select="$drivers[name=current()/own_slot_value[slot_reference = 'strategic_plan_drivers']/value]"/>  
		<xsl:variable name="thisStakeholders" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
		<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
		 
		{ 
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",	
        "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        "className":"<xsl:value-of select="current()/type"/>",
		"validStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>", 
		"validEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>",
		"objectives":[<xsl:for-each select="$objectivesforplan">
			{ "name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
			"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"drivers":[<xsl:for-each select="$driversforplan">
			{ "name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
			"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],	
		"planStatus":"<xsl:choose><xsl:when test="$thisPlanStatus"><xsl:value-of select="$thisPlanStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:when><xsl:otherwise>Not Set</xsl:otherwise></xsl:choose>",
		"projects":[<xsl:apply-templates select="$projectsforplan union $projectsdirectforplan" mode="projects"></xsl:apply-templates>],
		"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
				<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
				"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>],
		"stakeholders":[<xsl:for-each select="$thisStakeholders">
				<xsl:variable name="thisOrgs" select="key('orgs_key',current()/name)"/>
				<xsl:variable name="thisIndivActors" select="key('actors_key',current()/name)"/>
				<xsl:variable name="thisActors" select="$thisIndivActors union $thisOrgs"/>
				<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
				{"actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisActors"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
				"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
				"roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisRoles"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
				"type":"<xsl:value-of select="$thisActors/type"/>",
				"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>		
<xsl:template match="node()" mode="lifecycle">
	<xsl:variable name="thisLife" select="key('lifes',current()/name)"/>
	{
	"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
	"className":"<xsl:value-of select="current()/type"/>",
	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"colour":"<xsl:value-of select="$thisLife/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
	"bgColour":"<xsl:value-of select="$thisLife/own_slot_value[slot_reference='element_style_colour']/value"/>",
	"enumeration_value":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise></xsl:choose>
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="programme">
		<xsl:variable name="thisprogrammeStakeholders" select="$programmeStakeholders[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/> 
		<xsl:variable name="thisProjects" select="key('projects_key',current()/name)"/>
		<xsl:variable name="thisProgrammeStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'ca_approval_status']/value]"/> 
        <xsl:variable name="thisPlansViaProgramme" select="key('plans4Programme_key',current()/name)"/>
        <xsl:variable name="thisMilestones" select="key('milestone_key',current()/name)"/>
        <xsl:variable name="thisActors" select="key('orgs_key',$thisprogrammeStakeholders/name)"/> 
		<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
        "className":"<xsl:value-of select="current()/type"/>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",	
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
				<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
				"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>],
		"stakeholders":[<xsl:for-each select="$thisprogrammeStakeholders">
				<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
				<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
				{"actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisActors"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
				"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
				"roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisRoles"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
				"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>],
        "milestones":[<xsl:for-each select="$thisMilestones">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",			
        "name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
        "milestone_date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'cm_date_iso_8601']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"proposedStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>",
		"targetEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>",
		"actualStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>",
		"forecastEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>",
		"budget":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_change_budget']/value"/>",
		"approvalStatus":"<xsl:choose><xsl:when test="$thisProgrammeStatus"><xsl:value-of select="$thisProgrammeStatus/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>Not Set</xsl:otherwise></xsl:choose>", 
		"approvalId":"<xsl:value-of select="eas:getSafeJSString($thisProgrammeStatus/name)"/>",
		"plans":[<xsl:apply-templates select="$thisPlansViaProgramme" mode="plan"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"projects":[<xsl:apply-templates select="$thisProjects" mode="projects"></xsl:apply-templates>],
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>	

<xsl:template match="node()" mode="roadmaps">
		<xsl:variable name="thisPlanStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'strategic_plan_status']/value]"/> 
		<xsl:variable name="thisStakeholders" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
		<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",	
		"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
				<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
				"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>],
		"stakeholders":[<xsl:for-each select="$thisStakeholders">
				<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
				<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
				{"actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisActors"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
				"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
				"roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisRoles"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",	
				"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>],	
        "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        "strategicPlans":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
        "className":"<xsl:value-of select="current()/type"/>"}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>  

<xsl:template match="node()" mode="projects"> 
		{
			<xsl:variable name="thisP2E" select="key('p2e_key',current()/name)"/>
			<xsl:variable name="thisProjStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>  
			<xsl:variable name="thisApprovalStatus" select="$projectStatus[name=current()/own_slot_value[slot_reference = 'ca_approval_status']/value]"/> 
			<xsl:variable name="thisStakeholders" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
			<xsl:variable name="thisActors" select="key('orgs_key',$thisStakeholders/name)"/> 
			<xsl:variable name="thisStakeholdersOrgs" select="$allActor2Roles[name=current()/own_slot_value[slot_reference='stakeholders']/value][own_slot_value[slot_reference='act_to_role_from_actor']/value=$thisActors/name]"/>
			<xsl:variable name="thisMilestones" select="key('milestone_key',current()/name)"/>
			<xsl:variable name="thisBudget" select="key('budgets_key',current()/name)"/>
			<xsl:variable name="thisBudgetElements" select="key('budget_elements_key',$thisBudget/name)"/>
			<xsl:variable name="thisCost" select="key('costs_key',current()/name)"/>
			<xsl:variable name="thisCostElements" select="key('cost_elements_key',$thisCost/name)"/>
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",			
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"orgUserIds":[<xsl:for-each select="$thisStakeholdersOrgs">
				<xsl:variable name="thisActors" select="key('orgs_key',current()/name)"/> 
				"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>"<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>],  
		"budget":[<xsl:for-each select="$thisBudgetElements">{
				"recurrence":"<xsl:value-of select="current()/type"/>",
				"amount":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='budget_amount']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='budget_amount']/value"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
				"startDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='budget_start_date_iso_8601']/value"/>",
				"endDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='budget_end_date_iso_8601']/value"/>",
				"currency":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_currency']/value"/>",
				"approved":"<xsl:value-of select="$budgetApproval[name=current()/own_slot_value[slot_reference='budget_approval_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"costs":[<xsl:for-each select="$thisCostElements">{
				"recurrence":"<xsl:value-of select="current()/type"/>",
				"currency":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_currency']/value"/>",
				"amount":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='cc_cost_amount']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_amount']/value"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
				"startDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_start_date_iso_8601']/value"/>",
				"endDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_end_date_iso_8601']/value"/>"
				}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],		
		"programme":"<xsl:value-of select="current()/own_slot_value[slot_reference='contained_in_programme']/value"/>",
		"stakeholders":[<xsl:for-each select="$thisStakeholders">
		<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
		<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
		{"actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="$thisActors"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",	
		"actorId":"<xsl:value-of select="eas:getSafeJSString($thisActors/name)"/>",
		"roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="$thisRoles"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",	
		"roleId":"<xsl:value-of select="eas:getSafeJSString($thisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>], 
		"milestones":[<xsl:for-each select="$thisMilestones">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",			
        "name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
        "milestone_date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'cm_date_iso_8601']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"className":"<xsl:value-of select="current()/type"/>",
		"proposedStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>",
		"targetEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>",
		"actualStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>",
		"forecastEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>",
		"lifecycleStatus":"<xsl:choose><xsl:when test="$thisProjStatus/own_slot_value[slot_reference = 'name']/value"><xsl:value-of select="$thisProjStatus/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>Unknown</xsl:otherwise></xsl:choose>",
		"lifecycleStatusId":"<xsl:choose><xsl:when test="$thisProjStatus/name"><xsl:value-of select="eas:getSafeJSString($thisProjStatus/name)"/></xsl:when><xsl:otherwise>Unknown</xsl:otherwise></xsl:choose>",
		"approvalStatus":"<xsl:choose><xsl:when test="$thisApprovalStatus"><xsl:value-of select="$thisApprovalStatus/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise>Not Set</xsl:otherwise></xsl:choose>",
		"approvalId":"<xsl:value-of select="eas:getSafeJSString($thisApprovalStatus/name)"/>",
		"p2e":[<xsl:for-each select="$thisP2E">{ 
			<xsl:variable name="thisPlan" select="key('plans_key',current()/name)"/>
			<xsl:variable name="thisAction" select="$planningActions[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/> 
			<xsl:variable name="ele" select="$allImpactedElements[name=current()/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"actionid":"<xsl:value-of select="eas:getSafeJSString($thisAction/name)"/>",
			"action":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisAction"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
			"impactedElement":"<xsl:value-of select="eas:getSafeJSString($ele/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$ele"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
			"eletype":"<xsl:value-of select="translate($ele/type,'_',' ')"/>",
			"type":"<xsl:value-of select="$ele/supertype"/>",
			"plan":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisPlan"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
			"planid":"<xsl:value-of select="eas:getSafeJSString($thisPlan/name)"/>"
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="styles">
	<xsl:variable name="thisStyle" select="eas:get_element_style_instance(current())"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"colour":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
	"icon":"<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>",
	"textColour":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#000000</xsl:otherwise></xsl:choose>"}<xsl:if test="position()!=last()">,</xsl:if>
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
