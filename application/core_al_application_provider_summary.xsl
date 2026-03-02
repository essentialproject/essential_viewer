<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/> 
	<xsl:include href="../common/odt_document_files/wordTemplates.xsl"/>
	<xsl:include href="core_el_cia_data.xsl"/>
	<xsl:include href="core_al_costs.xsl"/>

	<!--<xsl:include href="../information/menus/core_data_subject_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>
	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/> -->
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Data_Subject', 'Data_Object', 'Supplier', 'Data_Object_Attribute', 'Group_Actor', 'Individual_Actor', 'Application_Provider', 'Application_Service', 'Group_Business_Role', 'Individual_Business_Role', 'Business_Capability', 'Business_Process', 'Composite_Application_Provider', 'Data_Representation', 'Data_Representation_Attribute','Information_Representation', 'Technology_Product','Technology_Node','Data_Object','Project', 'Enterprise_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentDataObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="appMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>
	<xsl:variable name="doData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"></xsl:variable>
	<xsl:variable name="orgData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"></xsl:variable>
	<xsl:variable name="apiPathAppCost" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Cost']"/>
	<xsl:variable name="appLifecycleData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Lifecycles']"></xsl:variable>
	<xsl:variable name="kpiListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: App KPIs'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"></xsl:variable>
	<xsl:variable name="allPhysProcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
	<xsl:variable name="allPlansData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"></xsl:variable>
	<xsl:variable name="techProdData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get All Tech Product Roles']"></xsl:variable>
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	 <xsl:variable name="instanceData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"></xsl:variable>

	<xsl:variable name="lastPublishDateTime" select="/node()/timestamp"/>
	<xsl:variable name="repo" select="/node()/repository/repositoryID"/>
	<xsl:variable name="decisions" select="/node()/simple_instance[type=('Application_Decision','Enterprise_Decision')]"/>
	<xsl:key name="instance" match="/node()/simple_instance[supertype=('EA_Class')]" use="name"/>
	<xsl:key name="overallCurrencyDefault" match="/node()/simple_instance[type='Report_Constant']" use="own_slot_value[slot_reference = 'name']/value"/>
    <xsl:variable name="overallCurrencyDefault" select="key('overallCurrencyDefault', 'Default Currency')"/> 
	<xsl:variable name="currency" select="/node()/simple_instance[type='Currency'][name=$overallCurrencyDefault/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
	<xsl:variable name="isEIPMode">
 		<xsl:choose>
 			<xsl:when test="$eipMode = 'true'">true</xsl:when>
 			<xsl:otherwise>false</xsl:otherwise>
 		</xsl:choose>
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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->
	<xsl:template match="knowledge_base">
		<xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiDataObjects">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$doData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiOrgs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$orgData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiMart">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$appMartData"></xsl:with-param>
				</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiCost">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$apiPathAppCost"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiLife">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appLifecycleData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="apikpi">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$kpiListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiPhysProc">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$allPhysProcData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiPlans">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$allPlansData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiTech">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$techProdData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiBusCap">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable> 
		<xsl:variable name="apiInstance">
			<xsl:call-template name="GetViewerAPIPathText">
				<xsl:with-param name="apiReport" select="$instanceData"></xsl:with-param>
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
				<title><xsl:value-of select="eas:i18n('Application Summary')"/></title>

				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>
				<script src="js/chartjs/Chart.min.js"></script>
				<link href="js/chartjs/Chart.css" type="text/css" rel="stylesheet"></link>
				<script src="js/d3/d3.v5.9.7.min.js"></script>
				
				<script src="js/dagre/dagre.min.js"></script>
				<script src="js/dagre/dagre-d3.min.js"></script>
				<script src="js/FileSaver.min.js"></script>
				<script src="js/jszip/jszip.min.js"></script>
				<script src="js/jointjs/lodash.min.js"></script>
				<script src="js/jointjs/backbone-min.js"></script>
				<script src="js/jointjs/joint.min.js"></script>
				<script src="application/renderTimelineFunction.js" type="text/javascript"></script>
				<xsl:if test="$isEIPMode='true'">
					<script type="text/javascript" src="editors/assets/js/joint-plus/package/joint-plus.js"></script>
					<script src="editors/configurable/sketch-diagram-tab/jointjs-sketch/js/shapes/links.js"></script> 
				</xsl:if>
				<style type="text/css">
					.v-line {
 				   		font-family: arial;
						font-size: 0.9em;
					}
					.headerName > .select2 {top: -3px; font-size: 25px;}
					.headerName > .select2 > .selection > .select2-selection {height: 32px;}
					.dataTables_filter{
					    clear: both;
					    float: right;
					}
					.dataTables_wrapper{
					    margin-top: 0 !important;
					}
					.keyLozenge{
						display: inline-block;
						border-radius: 8px;
						padding: 2px;
						margin-right: 3px;
						width: 90px;
						font-size: 0.8em;
						text-align: center;
						margin-bottom: 3px;
						border: 1pt solid #d3d3d3;
					}
					.keyStandard{
						display: inline-block;
						min-width: 80px;
						border-radius: 4px;
						padding: 5px;
						margin-left: 10px;
						text-align: center;
						font-size: 0.9em;
					}
					
					.link-tools,
					.marker-arrowheads,
					.connection-wrap{
					    display: none;
					}
					.thead input{
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
					    color: #fff;
					    width: 80%;
					    margin-left: 10%;
					    margin-bottom: 3px;
					    padding: 2px;
					    border-radius: 4px;
					    line-height: 1.1em;
					    font-size: 90%;
					    height: 50px;
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
					    height: 15px;
					    width: 15px;
					    border-radius: 15px;
					    border: 1pt solid #ffffff;
					    display: inline-block;
					    background-color: #fff;
					    color: #000;
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
						border-radius: 18px;
						padding: 1.2rem 1.4rem;
						box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
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
					
					
					.stat{
					    border: 1pt solid #d3d3d3;
					    border-radius: 4px;
					    margin: 5px;
					    padding: 3px;
					}
					
					.doc-link-wrapper {
						display: inline-flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					
					.doc-link-blob,
					.doc-link-blob-create{
						display: flex;
					    width: 250px;
					    line-height: 1.1em;
					    border: 1px solid #ccc;
					    border-radius: 4px;
					    position: relative;
					    padding: 10px;
					}
					.bdr-left-blue{
					    border-left: 2pt solid #333 !important;
					}
					.doc-link-icon{
					    font-size: 32px;
					    margin-right: 10px;
					}
					.doc-link-label{
					}
					.doc-description{
					}
					.tagActor{
					    background-color: #3c8996!important;
					    color: #fff!important;
					}
					.appCard{
					    vertical-align: top;
					    border-radius: 4px;
					    border: 1pt solid #d3d3d3;
					    display: inline-block;
					    min-height: 100px;
					    width: 250px;
					    padding: 3px;
					    position: relative;
					}
					.appHeader{
					    font-size: 0.9em;
					}
					.appTableHeader{
					    font-size: 0.8em;
					}
					.dbicon{
					    position: absolute;
					    bottom: 5px;
					    right: 5px;
					    color: #d3d3d3;
					    font-size: 0.7em;
					    text-transform: uppercase;
					}
					.classiflistBox{
					    position: absolute;
					    bottom: 5px;
						overflow-y: auto;
						height:21px; 
					}
					.classiflist{
						display:inline-block;
					}
					.datatype{
					    display: inline-block;
					    width: 250px;
					}
					.datacrud{
					    display: inline-block;
					}
					.secBox{
						border-radius: 14px;
						padding: 5px 10px 5px 10px;
						border: 1px solid #e0e0e0;
						font-size: 12px;
						font-weight: bold;
						text-align: center;
						display: inline-block;
					}
					.leadText{
					    font-weight: bolder;
					    color: #a94040;
					}
					.filterPanel{
					    position: absolute;
					    right: 20px;
					    top: 10px;
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
					.stack-item-instances-wrapper {
						display: flex;
						flex-wrap: wrap;
						gap:15px;
					}
					.stack-item-instances{
					    width: 300px;
					    height: 300px;
					    max-height: 300px;
					    overflow-x: hidden;
					    overflow-y: auto;
					    min-height: 20px;
					    border: 1px solid #ccc;
					    background-color: #fafafa;
					    padding: 10px;
					    border-radius: 4px;
					}
					.node-location{
						position: absolute;
						bottom: 21px;
						width: 278px;
					}
					.tech-item-wrapper{
					    position: relative;
					    padding: 5px;
					    border-radius: 4px;
					    margin-bottom: 10px;
					    border: 1px solid #bbb;
					    border-bottom: 1px solid #666;
					    background-color: #fff;
					}
					
					.tech-item-label{
					    width: 400px;
					    display: inline-block;
					    font-weight: bolder;
					}
					.tech-item-label-sub{
					    width: 400px;
					    display: inline-block;
					    color: #000;
					}
					.tech-item-component{
					    display: inline-block;
					}
					.family-tag{
					    background-color: rgb(68, 182, 179);
					}
					
					.ess-flat-card-wrapper{
					    display: flex;
					    flex-direction: row;
					    flex-wrap: wrap;
					    gap: 15px;
					}
					.ess-flat-card{
					    border: 1px solid #333;
					    min-width: 190px;
					    width: 190px;
					    text-align: center;
					    position: relative;
					}
					
					.ess-flat-card-title{
					    padding: 10px;
					    background-color: #efefef;
					}
					.ess-flat-card-body{
					    padding: 5px;
					}
					.ess-desc{
					    padding: 1px;
					    min-height: 80px;
					    max-height: 80px;
					    overflow-y: auto;
					}
					.ess-flat-card-footer{
					    padding: 10px;
					    position: absolute;
					    bottom: 0px;
					    width: 100%;
					}
					.ess-flat-card-title > span{
					    font-weight: 700;
					    font-size: 125%;
					}
					
					.ess-flat-card-title > div{
					    font-weight: 400;
					    font-size: 90%;
					    color: #666;
					}
					.ess-flat-card-widget-wrapper{
					    display: flex;
					    flex-direction: row;
					    flex-wrap: wrap;
					    gap: 10px;
					    justify-content: center;
					    align-items: top;
					    position: relative;
					}
					
					.ess-flat-card-widget > i{
					    font-size: 115%;
					}
					
					.ess-flat-card-widget > div{
					    font-weight: 700;
					    font-size: 90%;
					}
					.ess-flat-card-widget > i.text-muted{
					    color: #ccc;
					}
					.ess-flat-card-widget-badge{
					    padding: 2px 4px;
					}
					.fa-info-circle{
					    cursor: pointer;
					}
				 
					.full-width-chart-container{
					    width: 100%;
					    height: 200px;
					}

					.perfBox{
					    width: 250px;
					    display: inline-block;
					    border: 1pt solid #ccc;
					    border-radius: 4px;
					    min-height: 200px;
					    vertical-align: top;
					    padding: 5px 10px;
					    margin-right: 10px;
					    background-color: #fefefe;
					    margin-top: 10px;
					    box-shadow: 1px 1px 2px rgba(0,0,0,0.25);
					}
					.perfScoreBoxRed,
					.perfScoreBoxAmber,
					.perfScoreBoxGreen{
					    border-radius: 4px;
					    height: 20px;
					    width: 25px;
					    display: block;
					    text-align: center;
					    font-weight: 900;
					    float: left;
					    margin-right: 5px;
					}
					.perfScoreBoxRed{
					    background-color: #ff0000;
					    color: #fff;
					}
					.perfScoreBoxAmber{
					    background-color: #ffbf00;
					    color: #fff;
					}
					.perfScoreBoxGreen{
					    background-color: #228b22;
					    color: #fff;
					}
					.labelProcess{
					    background-color: #876de6;
					}
					.labelOrg{
					    background-color: #c13f71;
					}
					.eas-logo-spinner{
					    display: flex;
					    justify-content: center;
					}
					#editor-spinner{
					    height: 100vh;
					    width: 100vw;
					    position: fixed;
					    top: 0;
					    left: 0;
					    z-index: 999999;
					    background-color: hsla(255, 100%, 100%, 0.75);
					    text-align: center;
					}
					#editor-spinner-text{
					    width: 100vw;
					    z-index: 999999;
					    text-align: center;
					}
					.spin-text{
					    font-weight: 700;
					    animation-duration: 1.5s;
					    animation-iteration-count: infinite;
					    animation-name: logo-spinner-text;
					    color: #aaa;
					    float: left;
					}
					.spin-text2{
					    font-weight: 700;
					    animation-duration: 1.5s;
					    animation-iteration-count: infinite;
					    animation-name: logo-spinner-text2;
					    color: #666;
					    float: left;
					}
					.label-eas{
						border: 1pt solid #d3d3d3;
						padding: 2px;
						font-size: 1.0em;
					}
					
					g.type-TK > rect{
					    fill: #00ffd0;
					}
					
					text{
					    font-weight: 400;
					    font-size: 14px;
					}
					
					.node rect{
					    stroke: #999;
					    fill: #fff;
					    stroke-width: 1.5px;
					}
					
					.edgePath path{
					    stroke: #333;
					    stroke-width: 1.5px;
					}
					
					.standards{
					    position: absolute;
					    right: 5px;
					    top: 5px;
					    background-color: #f1f1f1;
					    padding: 4px;
					    min-width: 85px;
					    border-radius: 8px;
					    font-size: 12px;
					}
					.wordIcon{
					    position: absolute;
					    right: 15px;
					    top: 15px;
					}
					.lb-md{
					    font-size: 16px;
					}
					.dataCardWrapper{display: flex; gap: 15px; flex-wrap: wrap; position: relative;}
					.dataCard{border: 1px solid #ccc; padding: 10px 10px 30px 10px; width: 300px; position: relative; }
					.label.label-link > a {color: #fff;}
					.label.label-link:hover {opacity: 0.75;}
					.ess-type-label {
						position: absolute;
						color: #ccc;
						right: 5px;
						bottom: 5px;
						font-size: 85%;
						text-transform: uppercase;
					}
					
					
					@media (min-width : 1220px) and (max-width : 1720px){
						.ess-column-split > div{
						width: 450px;
						float: left;
						}
					}
				 
					 
					@media print{
						#summary-content .tab-content > .tab-pane{
						display: block !important;
						visibility: visible !important;
						}
						
						#summary-content .no-print{
						display: none !important;
						visibility: hidden !important;
						}
						
						#summary-content .tab-pane{
						page-break-after: always;
						}
					}
						
					@media screen{
						#summary-content .print-only{
						display: none !important;
						visibility: hidden !important;
						}
					}
					.lb-lg {
						font-size: 1.1em;
					  }
					  .issuebox-wrapper{
					  	display: flex;
					  	flex-wrap: wrap;
					  	gap: 15px;
					  }
					  
					  .issueBox{
						border:1pt solid #d3d3d3;
						border-radius: 4px;
						width: 300px;
						position:relative;
						padding:10px;
					  }
					  .issueStatus{
						position:absolute;
						bottom:3px;
						right:2px;
						font-size:0.9em;

					  }

					  .summary-container {
						width: 100%;
						margin: auto;
						display: flex;
						flex-direction: column;
						justify-content: center;
						align-items: center;
						height: auto;
						font-family: arial, "Source Sans 3";
					  }
					  
					  .service-box {
						width: 100%;
						height: auto;
						padding: 2.5rem 3rem;
						margin: 0.8rem;
						display: flex;
						flex-direction: column;
						background-color: #fefefe;
						-webkit-box-shadow: inset 0px 4px 11px 0px rgba(166, 166, 166, 0.25);
						-moz-box-shadow: inset 0px 4px 11px 0px rgba(166, 166, 166, 0.25);
						box-shadow: inset 0px 4px 11px 0px rgba(166, 166, 166, 0.25);
						border-radius: 0.8rem;
					  }
					  
					  .header {
						display: flex;
						align-items: baseline;
						color: rgb(179, 46, 64);
						font-family: "Source Sans 3";
						justify-content: flex-start;
						margin-bottom: 0.3rem;
					  }
					  .header .fa-solid {
						margin-right: 0.9rem;
						font-size: 1.2rem;
					  }
					  p.app-header {
						margin-bottom: 0;
						margin-left:5px;
						font-size: 1.5em;
						font-weight: 600;
						font-family: arial;
					  }
					  
					  .sub-text {
						font-size: 1em;
						margin-bottom: 1rem;
					  }
					  
					  .pill-badge-container {
						display: flex;
						justify-content: flex-start;
						align-items: center;
						margin-bottom: 2rem;
					  }
					  .key {
						font-weight: 900;
						font-size: 0.9rem;
						margin-right: 0.7rem;
						margin-bottom: 0;
					  }
					  span.service-container-badge {
						margin-right: 0.3rem;
						color: black;
						font-size: 0.75em;
						padding: 0.35rem 1rem;
					  }
					  
					  /***Card container**/
					  .service-card-container {
						display: flex;
						align-items: center;
						flex-wrap: wrap;
						flex-direction: row;
					  }
					  .service-card-container .card {
						width: 100%;
						max-width: 200px;
						height: 120px;
						border-radius: 6px;
						overflow: hidden;
						box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
						background-color: #fff;
						transition: transform 0.3s ease, box-shadow 0.3s ease;
						display: flex;
						flex-direction: column;
						position: relative;
						margin: 3px;
					  }
					  .service-card-container .card:hover {
						transform: translateY(-5px);
						box-shadow: 0 12px 28px rgba(0, 0, 0, 0.15);
					  }
					  
					  .service-card-container .card .c-header {
						padding: 8px;
						background-color: #adb1c2;
						color: white;
						position: relative;
					  }
				 
					  .service-card-container .card .header-title-box {
						display: inline-block;
						background-color: rgba(0, 0, 0);
						padding: 2px 6px;
						border-radius: 4px;
						margin-bottom: 4px;
						font-weight: 500;
						font-size: 10px;
					  }
					  .header-title-box a {
						color: white !important;
						font-weight: 800;
					  }
					  
					  .service-card-container .card .c-body {
						padding: 6px;
						line-height: 1.2;
						color: #333;
						font-size: 11px;
						flex: 1;
						overflow-y: auto;
						scrollbar-width: thin;
					  }
					  
					  .service-card-container .card .c-body p {
						margin-bottom: 4px;
					  }

					  .service-card-container .c-body p {
						margin-bottom: 4px;
					  }
					  
					  .service-card-container .c-body::-webkit-scrollbar {
						width: 4px;
					  }
					  
					  .service-card-container .c-body::-webkit-scrollbar-thumb {
						background-color: #ddd;
						border-radius: 4px;
					  }
					  
					  .service-card-container .c-footer {
						padding: 6px 8px;
						background-color: #f8f9fa;
						border-top: 1px solid #e9ecef;
						display: flex;
						justify-content: flex-end;
						align-items: center;
						font-size: 11px;
					  }

					  .service-card-pops{
						display: inline-block;
						background-color: #dbe0fe;
						border: 1pt solid #d3d3d3;
						padding: 2px 6px;
						border-radius: 4px;
						margin-bottom: 4px;
						font-weight: 500;
						font-size: 10px;
					  }
					  
					  
					  /** Alternate services styling **/
					  
					  .alternate-service-container .card .c-body {
						text-align: left;
						height: 13.8vh;
					  }
					  .alternate-service-container .card .c-body ul {
						list-style: none;
						padding-left: 0px;
					  }
					  .alternate-service-container .card .c-body li {
						margin: 0.3rem 0;
					  }
					  .alternate-service-container .card .c-body li a {
						text-decoration: none;
						color: #2f2f2f;
					  }
					  .alternate-service-container .card .c-body li i {
						color: #b32e40;
						padding-right: 0.5rem;
					  }
					  
					  .alternate-service-container .card .c-body li a:hover {
						text-decoration: underline;
					  }
					  .alternate-service-container .sub-text {
						margin-bottom: 2rem;
					  }
					  .pill-badges{
						font-size:1.2em;
					  }
					  .whiteLabel a{
						color: #ffffff !important;
					  }
					  .lbl-lrg{
						font-size:1.1em;
						background-color:#424242;
					  }
				
					.chart-container {
						display: flex; 
					}
					
					.chart-container canvas {
						width: 50%;
						height: auto; /* Ensure canvas maintains aspect ratio */
					}
					.full-width-chart-container {
						flex: 1; /* Allow the chart container to grow to fill the available space */
					}
					.label-light-grey {
						background-color: #e3e3e3;
						color: #000;
					  }


					.capContainer {
						display: flex;
						gap: 20px;
						margin-top: 20px;
					}
					
					.column {
						flex: 1;
						padding: 10px;
						border-radius: 10px;
						background-color: #f9f9f9;
						box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
					}
					
					.column-header {
						font-size: 18px;
						font-weight: 600;
						margin-bottom: 20px;
						color: #222;
						text-align: center;
						padding-bottom: 10px;
						border-bottom: 1px solid rgba(0, 0, 0, 0.08);
					  }
					  
					  /* Elegant rounded box for capabilities */
					  .rounded-box {
						margin: 16px 0;
						padding: 0;
						position: relative;
						transition: all 0.25s ease;
						border-bottom: 1px solid rgba(0, 0, 0, 0.08);
						background-color: #f2f2f2;
						border-radius: 0px 14px 14px 0px;
					  }
					  
					  /* The actual box styling */
					  .rounded-box::before {
						content: '';
						position: absolute;
						top: 0;
						left: 0;
						right: 0;
						bottom: 0;
						background-color: #ffffff;
						border-radius: 8px;
						box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
						z-index: -1;
						transition: all 0.25s ease;
					  }
					  
					  /* Left accent border */
					  .rounded-box::after {
						content: '';
						position: absolute;
						top: 0;
						left: 0;
						width: 4px;
						height: 100%;
						background-color: #3d3988;
						border-top-left-radius: 8px;
						border-bottom-left-radius: 8px;
						transition: width 0.25s ease;
					  }
					  
					  /* Hover effects for the box */
					  .rounded-box:hover::before {
						box-shadow: 0 6px 16px rgba(61, 57, 136, 0.12);
						transform: translateY(-2px);
					  }
					  
					  .rounded-box:hover::after {
						width: 6px;
					  }
					  
					  /* Link styling */
					  .rounded-box a {
						display: block;
						padding: 16px 20px;
						color: #333;
						text-decoration: none;
						transition: color 0.25s ease;
					  }
					  
					  .rounded-box:hover a {
						color: #3d3988;
					  }
					  
					  /* Strong element styling */
					  .rounded-box strong {
						font-weight: 600;
						letter-spacing: 0.2px;
					  }
					
					.column-header {
						font-weight: bold;
						margin-bottom: 15px;
						text-align: center;
						font-size: 1.2em;
						background-color: #3d3988;
						color: white;
						padding: 10px;
						border-radius: 8px;
					}

					.inline-elements label, .inline-elements .ess-string-inline {
						display: inline-block;
						margin-right: 10px; /* Adjust the spacing as needed */
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

					.control-group{
						display:inline-block;
						padding:2px;
						margin:2px;
						border:1pt solid #d3d3d3;
						text-align:center;
					}

					.panel-heading-sub{
						font-size: 1em;
						font-weight: 600;
						background-color: #3d3988;
						color: white;
						padding: 5px;
						border-radius: 1px;
					}
					.text-red{
						color: #d9534f;
					}
					.text-green{
						color: #358c4d;
					}
					.text-amber{
						color: #f0ad4e;
					}
					.text-blue{
						color: #3c59a7;
					}
					.text-success{
						color: #358c4d;
					}
					.block-success{
						color: #ffffff;
						background-color: #358c4d;
					}
					.block-danger{
						color: #ffffff;
						background-color: #d9534f;
					}
					.block-warning{
						color: #0e0e0e;
						background-color: #f0ad4e;
					}
					.text-danger{
						color: #d9534f;
					}
					.text-warning{
						color: #f0ad4e;
					}
					/* Force sane sizing for the cost-by-type chart */
					.cost-analytics-card { position: relative; }

					// #costByType-chart { width: 100% !important; height: 220px !important; max-height: 220px !important; }
					.cost-analytics-empty { position: absolute; left: 0; right: 0; top: 48px; text-align: center; color: #777; font-style: italic; }

					/* Extra guards to prevent squashing / flex collapse */
					.cost-analytics-card { min-height: 260px; }
					.full-width-chart-container { min-height: 220px; }
					#appcosts .full-width-chart-container, #appcosts #costByType-chart { display: block; }

					  /* Container */
					  .app-tree{position:relative;padding:8px;border-radius:16px;background:linear-gradient(180deg, rgba(255,255,255,0.55), rgba(255,255,255,0.25));backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);box-shadow:0 8px 24px rgba(0,0,0,0.08) inset, 0 4px 16px rgba(0,0,0,0.06)}

					  /* Lists */
					  .app-tree .tree-root{list-style:none;margin:0;padding-left:0}
					  .app-tree .children{list-style:none;margin:6px 0 0 1rem;padding-left:.75rem;position:relative}
					  .app-tree .children::before{content:"";position:absolute;left:0;top:0;bottom:0;width:2px;background:linear-gradient(to bottom, rgba(99,102,241,.35), rgba(99,102,241,.05))}

					  /* Node blocks (chips) */
					  .app-tree .node-line{display:inline-flex;gap:.5rem;align-items:center;padding:6px 10px;border-radius:12px;margin:4px 4px; width:fit-content; max-width:100%; white-space:nowrap;
					    background:rgba(255,255,255,0.35); border:1px solid rgba(255,255,255,0.45);
					    box-shadow:0 2px 8px rgba(31,41,55,0.10), 0 1px 0 rgba(255,255,255,0.35) inset;
					    backdrop-filter:blur(8px); -webkit-backdrop-filter:blur(8px)}
					  .app-tree .node-line:hover{transform:translateY(-1px);box-shadow:0 6px 18px rgba(31,41,55,0.16)}

					  /* Text */
					  .app-tree .node-name{font-weight:650; letter-spacing:.2px}
					  .app-tree .node-meta{font-family:monospace;color:#6b7280;font-size:12px;opacity:.85}

					  /* Root layout: each child on its own line */
					  .app-tree .tree-root > .tree-node{display:block !important;margin:8px 0}
					  .app-tree .tree-root > .tree-node > .node-line{display:inline-flex !important;width:auto !important}

					  /* Nested children: compact inline chips */
					  .app-tree .children > .tree-node{display:inline-block !important;vertical-align:top;margin:4px 8px 4px 0}

					  /* Guard against external width rules */
					  .app-tree .tree-node{max-width:100%}
					  .app-tree .node-line{width:auto !important}
					 
					.ess-section-title{display:flex;align-items:center;gap:.6rem;margin:0 0 1rem;font-weight:700;letter-spacing:.2px}
					.ess-section-title i{opacity:.85}
					.ess-card-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:12px}
					.ess-card{border:1px solid rgba(0,0,0,.08);border-radius:14px;background:linear-gradient(180deg,rgba(255,255,255,.72),rgba(255,255,255,.5));box-shadow:0 6px 18px rgba(15,23,42,.08);padding:12px;transition:transform .2s ease, box-shadow .2s ease}
					.ess-card:hover{transform:translateY(-2px);box-shadow:0 10px 26px rgba(15,23,42,.12)}
					.ess-card .title{font-weight:700;margin-bottom:6px;line-height:1.2}
					.ess-card .meta{font-size:12px;color:#666}
					.ess-chip{display:inline-flex;align-items:center;gap:.35rem;padding:.18rem .6rem;border-radius:999px;border:1px solid rgba(0,0,0,.08);background:#fff;font-size:12px;font-weight:600;margin:.15rem .25rem .15rem 0}
					.ess-chip.muted{background:#f6f6f6;color:#666}
					.ess-chip.primary{background:#e8ecff}
					.ess-chip.success{background:#e6f6ed}
					.ess-chip.warn{background:#fff4e0}
					.ess-chip.danger{background:#ffe8e8}
					.ess-row{display:flex;flex-wrap:wrap;gap:.4rem}
					.ess-soft{opacity:.8}
					.ess-accordion .panel{border-radius:12px;overflow:hidden}
					.ess-accordion .panel-heading{background:linear-gradient(180deg,#fafafa,#f2f2f2)}
					.ess-accordion .panel-title{display:flex;align-items:center;gap:.6rem}
					.ess-spacer{height:8px}
					</style>
			</head>
			<body> 
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template> 
				<xsl:call-template name="ViewUserScopingUI"/>
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
		
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Summary for')"/> </span>&#160;
										<span class="text-primary headerName"><select id="subjectSelection" style="width: 600px;"></select></span>
										<span id="selectMenu"></span>
									</h1> 
									<div class="pull-right wordIcon"> 
										<i class="fa fa-file-word-o fa-2x" id="getWord" title="word"></i> 
									</div>
							</div>
						</div>
					</div>
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
					
					<span id="mainPanel"/>
	
					<div id="comparison" class="modal fade" role="dialog">
						<div class="modal-dialog modal-xl">
							<div class="modal-content">
								<div class="modal-header"> 
									<h4 class="modal-title"><xsl:value-of select="eas:i18n('Application Analysis')"/></h4>
								</div>
								<div class="modal-body">
									<div class="col-xs-3">
									<select class="xySelect" id="xSelect"></select><br/>
									<select class="xySelect" id="ySelect"></select>
										<button id="addSVG">+</button><button id="removeSVG">-</button>
									</div>
									<div class="col-xs-9" id="chartPanel">
										<svg id="bubbles" height="500px">  
										</svg>
									</div>
								</div>
								<div class="clearfix"/>
								<div class="modal-footer">
									<button type="button" class="btn btn-default" data-dismiss="modal">eas:i18n('Close')"/></button>
								</div>
							</div>
						</div>
					</div>

				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

			</body>
			<script>
((function () {
  // Render guards and debug toggle (IIFE scope)
  var _isRendering = false;
  var _lastRenderAt = 0;
  var _pendingChain = false;
  var _lastSignature = '';
  window.__debugCostChart = window.__debugCostChart || false; // set true in console if you want logs

  function ready(fn){
    if(document.readyState !== 'loading'){ fn(); } else { document.addEventListener('DOMContentLoaded', fn); }
  }

  // ---- Debounce helper so we don't spam Chart.js on DOM mutations
  var _renderTimer = null;
  function scheduleRender(delay){
    if (delay == null) delay = 60; // small but noticeable; enough to coalesce rapid changes
    if (_renderTimer) { clearTimeout(_renderTimer); }
    _renderTimer = setTimeout(function(){
      try { renderChart(); } catch(e){ console.error('Cost chart render failed:', e); }
    }, delay);
  }

  // Chain a few renders over ~2s to catch async panel rebuilds (e.g., after currency/app change)
function scheduleRenderChain(){
  if (_pendingChain) return;
  _pendingChain = true;
  var kicks = [0, 200, 700, 1500, 2300];
  kicks.forEach(function(ms, idx){
    setTimeout(function(){
      scheduleRender(idx === 0 ? 0 : 60);
      if (idx === kicks.length - 1) _pendingChain = false;
    }, ms);
  });
}

  function ensureCanvas(){
    // Prefer existing canvas in the cost analytics card
    var existingById = document.getElementById('costByType-chart');
    if (existingById) {
      try { var p = existingById.parentElement; if (p) { p.style.minHeight = '220px'; } } catch(e){}
      return existingById;
    }

    // Fallback: try the appcosts tab and create one if needed
    var tab = document.getElementById('appcosts');
    if(!tab) return null;
    var existing = tab.querySelector('#costByTypeChart');
    if(existing) return existing;
    var wrap = document.createElement('div');
    wrap.className = 'full-width-chart-container';
    var canvas = document.createElement('canvas');
    canvas.id = 'costByTypeChart';
    wrap.appendChild(canvas);
    tab.insertBefore(wrap, tab.firstChild);
    return canvas;
  }

  function groupCostsByType(model){
    function toNumber(x){
      if (x == null) return null;
      if (typeof x === 'number' &amp;&amp; isFinite(x)) return x;
      if (typeof x === 'string'){
        // remove currency symbols/commas e.g. "£1,234.56" or "1 234,56"
        var s = x.replace(/[^0-9.,-]/g,'').trim();
        if(s.indexOf(',') > -1 &amp;&amp; s.indexOf('.') > -1){ s = s.replace(/,/g,''); }
        else if(s.indexOf(',') > -1 &amp;&amp; s.indexOf('.') === -1){ s = s.replace(',', '.'); }
        var n = parseFloat(s);
        return isFinite(n) ? n : null;
      }
      return null;
    }

    function pickAmount(c){
      var cand = [c.annual_total,c.annualTotal,c.annual,c.amount_annual,c.amountAnnual,c.normalised_annual,c.normalized_annual,c.normalisedAnnual,c.normalizedAnnual,c.value_annual,c.valueAnnual,c.total_annual,c.totalAnnual,c.amount,c.value,c.cost,c.price];
      for(var i=0;i&lt;cand.length;i++){ var n = toNumber(cand[i]); if(n!=null) return {n:n, src: 'direct'}; }
      return null;
    }

    function pickFrequency(c){
      var f = (c.frequency||c.cost_frequency||c.period||c.freq||c.billing_period||'').toString().toLowerCase();
      if(!f) return null;
      if(f.indexOf('month')>-1 || f==='m' || f==='monthly') return 12;
      if(f.indexOf('quarter')>-1 || f==='q' || f==='quarterly') return 4;
      if(f.indexOf('year')>-1 || f.indexOf('ann')>-1 || f==='y' || f==='annual' || f==='yearly') return 1;
      if(f.indexOf('week')>-1) return 52;
      if(f.indexOf('day')>-1) return 365;
      if(f.indexOf('adhoc')>-1 || f==='ad-hoc') return 0; // treat as zero unless an annualised rule is defined elsewhere
      return null;
    }

    function computeAnnual(c){
      var direct = pickAmount(c);
      if(direct){ return direct.n; }
      // Derive from amount * frequency
      var amount = toNumber(c.amount||c.value||c.cost||c.price);
      var mult = pickFrequency(c);
      if(amount!=null &amp;&amp; mult!=null){ return amount * mult; }
      // Try nested fields
      if(c.values &amp;&amp; typeof c.values==='object'){
        var amount2 = toNumber(c.values.amount||c.values.value);
        var mult2 = pickFrequency(c.values)||mult;
        if(amount2!=null &amp;&amp; (mult2!=null)) return amount2 * (mult2||1);
      }
      return 0; // unknown
    }

    var out = {};
    if(!model || !model.costs) return out;

    model.costs.forEach(function(c){
      if(!c) return;
      var t = (c.costType || c.cost_type || c.category || 'Unclassified');
      var v = computeAnnual(c);
      if(!out[t]) out[t] = 0;
      out[t] += (isFinite(v) ? v : 0);
    });
    return out;
  }

  function locateCostsModel(){
    var cands = [];
    var g1 = window.__lastAppSummaryModel; if (g1 &amp;&amp; g1.costs) cands.push(g1);
    var g2 = window.__appModel;            if (g2 &amp;&amp; g2.costs) cands.push(g2);

    try {
      var el = document.getElementById('costByTypeData');
      if (el &amp;&amp; el.textContent) {
        var parsed = JSON.parse(el.textContent.trim());
        if (parsed &amp;&amp; parsed.costs) cands.push(parsed);
      }
    } catch(e){}

    try {
      Object.keys(window).forEach(function(k){
        var v = window[k];
        if (v &amp;&amp; typeof v === 'object') {
          if (Array.isArray(v.costs)) cands.push(v);
          else if (Array.isArray(v) &amp;&amp; v.length &amp;&amp; typeof v[0] === 'object') {
            var rec = v[0];
            if ((('type' in rec) || ('category' in rec) || ('cost_type' in rec)) &amp;&amp;
                (('amount' in rec) || ('annual' in rec) || ('annual_total' in rec))) {
              cands.push({ costs: v });
            }
          }
        }
      });
    } catch(e){}

    var best = null, bestScore = -1;
    cands.forEach(function(m){
      var grouped = groupCostsByType(m);
      var sum = Object.keys(grouped).reduce(function(a,k){ return a + (isFinite(grouped[k]) ? grouped[k] : 0); }, 0);
      if (sum > bestScore) { bestScore = sum; best = m; }
    });
    return best || {};
  }

  function clearEmptyMsg(){
    var msg = document.getElementById('costByType-empty-msg');
    if (msg &amp;&amp; msg.parentElement) { try { msg.parentElement.removeChild(msg); } catch(e){} }
  }

  function renderChart(){
	var now = Date.now();
	if (now - _lastRenderAt &lt; 250) { return; }
	if (_isRendering) { return; }
	_isRendering = true;

    if(!window.Chart) { console.warn('Chart.js not loaded; cannot render Cost by Type chart'); return; }

    var model = locateCostsModel();
    try { if(!model.costs &amp;&amp; window.__appSummaryJSON) model = JSON.parse(window.__appSummaryJSON); } catch(e){}

    var grouped = groupCostsByType(model);
    var labels = Object.keys(grouped);
    var values = labels.map(function(k){ return Math.round((grouped[k] + Number.EPSILON) * 100) / 100; });

	var signature = JSON.stringify({ l: labels, v: values });
	var hasCanvas = document.getElementById('costByType-chart') || document.getElementById('costByTypeChart');
	if (signature === _lastSignature &amp;&amp; hasCanvas){
	_lastRenderAt = now;
	_isRendering = false;
	return;
	}
_lastSignature = signature;

    // Remove any prior empty-state message
    clearEmptyMsg();

    var allZero = values.length &amp;&amp; values.every(function(v){ return !v || v===0; });
    if(allZero){
      console.warn('Cost by Type: all values are zero. Check amount/frequency fields in your API payload.');
      var c2 = document.getElementById('costByType-chart') || ensureCanvas();
      if (c2) {
        var msg = document.getElementById('costByType-empty-msg');
        if(!msg){
          msg = document.createElement('div');
          msg.id = 'costByType-empty-msg';
          msg.className = 'cost-analytics-empty';
          msg.textContent = 'No annualised cost amounts to chart';
          (c2.parentElement || document.body).appendChild(msg);
        }
      }
      return;
    }

    var canvas = ensureCanvas() || document.getElementById('costByType-chart');
    if(!canvas){ console.warn('Cost canvas not found; cannot place chart'); return; }

    // Clamp canvas size to avoid runaway height
    try {
      canvas.style.width = '100%';
      canvas.style.height = '220px';
      canvas.style.maxHeight = '220px';
    } catch(e){}

    // If canvas is hidden or has zero size, try to size it and retry shortly
    try {
      if ((canvas.offsetWidth || 0) === 0) {
        var pw = (canvas.parentElement &amp;&amp; canvas.parentElement.offsetWidth) ? canvas.parentElement.offsetWidth : 300;
        canvas.style.width = pw + 'px';
      }
    } catch(e){}

    // Destroy any existing chart instance to avoid duplicates
    try {
      if(canvas.__chart &amp;&amp; typeof canvas.__chart.destroy === 'function') { canvas.__chart.destroy(); }
    } catch(e) {}

    if (window.__debugCostChart) console.log('Rendering CostByType on', canvas.id, { labels: labels, values: values });
    var ctx = canvas.getContext('2d');
    canvas.__chart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          label: 'Annual Cost by Type',
          data: values
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutoutPercentage: 55,
        animation: { duration: 0 },
        legend:   { display: labels.length &lt;= 12, position: 'bottom' },
        tooltips: { enabled: true }
      }
    });
    try { if (canvas.__chart &amp;&amp; typeof canvas.__chart.resize === 'function') { canvas.__chart.resize(); } } catch(e){}
    // One more resize shortly after to catch late CSS/layout
    setTimeout(function(){ try { if (canvas.__chart &amp;&amp; canvas.isConnected) canvas.__chart.resize(); } catch(e){} }, 100);
    try { canvas.height = 220; } catch(e){}

	_lastRenderAt = Date.now();
	_isRendering = false;
  }

  // Re-render when the costs tab becomes visible
  function hookTab(){
    var link = document.querySelector('a[href="#appcosts"]');
    if(!link) return;
    link.addEventListener('shown.bs.tab', function(){ 
		if (isCostsTabActive()) scheduleRenderChain();
		 });
  }

function isCostsTabActive(){
  var pane = document.getElementById('appcosts');
  if (!pane) return true; // render at least once
  return /\bactive\b/.test(pane.className || '');
}

  // Re-render when application or currency changes
  function hookInputs(){
    // Application select (Select2-backed)
    document.addEventListener('change', function(ev){
      var t = ev.target;
      if (!t) return;
      var id = (t.id||'').toLowerCase();
      var name = (t.name||'').toLowerCase();
      if (id === 'subjectselection' || id.indexOf('application') > -1) scheduleRenderChain();
      if (id.indexOf('currency')>-1 || name.indexOf('currency')>-1 || (t.getAttribute &amp;&amp; t.getAttribute('data-role')==='currency')) scheduleRenderChain();
    }, true);

    // Generic currency toggles/buttons
    document.addEventListener('click', function(ev){
      var el = ev.target;
      if (!el) return;
      if (el.matches &amp;&amp; (el.matches('[data-currency]') || el.matches('.currency-toggle'))) 
	  if (isCostsTabActive()) scheduleRenderChain();
    }, true);

    // Custom events some pages fire
    window.addEventListener('currency-changed', function(){ if (isCostsTabActive()) scheduleRenderChain();});
    window.addEventListener('app-summary-model-changed', function(){ if (isCostsTabActive()) scheduleRenderChain(); });
  }

  // Observe DOM for lazily-inserted/replaced chart containers (e.g., when switching application)
function hookObserver(){
  try {
    var costsPane = document.getElementById('appcosts');
    var target = costsPane || document.getElementById('mainPanel') || document.body;
    var mo = new MutationObserver(function(mutations){
      var needs = false;
      for (var i=0;i&lt;mutations.length;i++){
        var m = mutations[i];
        if (m.type === 'childList'){
          // ignore mutations inside the chart’s own container
          var node = (m.target &amp;&amp; m.target.closest) ? m.target.closest('#costByType-chart, .full-width-chart-container') : null;
          if (node) continue;
          if ((m.addedNodes &amp;&amp; m.addedNodes.length) || (m.removedNodes &amp;&amp; m.removedNodes.length)){
            needs = true; break;
          }
        }
      }
      if (needs &amp;&amp; isCostsTabActive()) scheduleRenderChain();
    });
    mo.observe(target, { childList: true, subtree: true });
  } catch(e) { console.warn('MutationObserver not available', e); }
}

  ready(function(){
    try { hookTab(); } catch(e) { console.warn('Tab hook failed', e); }
    try { hookInputs(); } catch(e) { console.warn('Input hook failed', e); }
    try { hookObserver(); } catch(e) { console.warn('Observer hook failed', e); }
    // Initial attempt(s)
    scheduleRenderChain();
  });

  // Allow other scripts to force a stable redraw if needed
  window.triggerCostByTypeRedraw = scheduleRenderChain;
})());
</script>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathDO" select="$apiDataObjects"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathOrgs" select="$apiOrgs"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathMart" select="$apiMart"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathCost" select="$apiCost"></xsl:with-param>     
					<xsl:with-param name="viewerAPIPathLifecycle" select="$apiLife"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathkpi" select="$apikpi"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathPhysProc" select="$apiPhysProc"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathPlans" select="$apiPlans"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathTech" select="$apiTech"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathBusCap" select="$apiBusCap"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathInstance" select="$apiInstance"></xsl:with-param>
				</xsl:call-template>  
			</script>	
 
 	
<script id="lifecycle-template" type="text/x-handlebars-template">	
	<div class="parent-superflex">
		<!--	<div class="superflex">
			 
			<div class="ess-flat-card-wrapper">
					{{#each this.lifecycles}}
						{{#ifEquals this.type 'Lifecycle_Status'}}
					<div class="ess-flat-card">
							<div class="ess-flat-card-title">
							  
								<div><h5><strong>{{#if this.enumname}}{{this.enumname}}{{else}}{{this.name}}{{/if}}</strong></h5></div>
							</div>
							<div class="ess-flat-card-body"> 
								 <div class="ess-flat-card-widget-wrapper">
									<div class="ess-flat-card-widget">
										<strong>Date:</strong> {{dateOf}}
										 
									</div>
									  
								</div> 
							</div>
							<div class="ess-flat-card-footer bg-orange-100"><xsl:attribute name="style">{{#getLifeColour this.id 'Lifecycle_Status'}}{{/getLifeColour}}</xsl:attribute>
								<i class="fa fa-route right-5"></i>
								<span></span>
							</div>
						</div>
						{{/ifEquals}}
					{{/each}}	
				</div>
			</div>		
		-->
			<div class="superflex">
				<svg xmlns="http://www.w3.org/2000/svg" id="svgLifes" height="400px"><xsl:attribute name="width">{{this.svgwidth}}</xsl:attribute>
				<defs>
					<filter id="f1" x="0" y="0" width="300%" height="300%">
						<feOffset result="offOut" in="SourceAlpha" dx="1" dy="1" />
						<feGaussianBlur result="blurOut" in="offOut" stdDeviation="10" />
						<feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
					</filter>
				</defs>
				{{#each this.years}}
				<rect width="31" height="15"  rx="5" style="fill:#fff; stroke-width:1;stroke:rgb(133, 133, 133);"><xsl:attribute name="y">0</xsl:attribute><xsl:attribute name="x">{{this.pos}}</xsl:attribute></rect>	
				<text font-weight="bold" style="stroke:black; stroke-width:1"><xsl:attribute name="y">12</xsl:attribute><xsl:attribute name="x">{{this.pos}}</xsl:attribute>&#160;{{this.year}}</text>
				<line  style="stroke:rgb(213, 213, 213);stroke-width:1" stroke-dasharray="2,2">
						<xsl:attribute name="x1">{{this.pos}}</xsl:attribute>	
						<xsl:attribute name="x2">{{this.pos}}</xsl:attribute>
						 <xsl:attribute name="y1">10</xsl:attribute>	
						 <xsl:attribute name="y2">350</xsl:attribute>
					</line>
				{{/each}}
				{{#each this.lifecycles}}
					{{#ifEquals this.type 'Lifecycle_Status'}}
						<line  style="stroke:rgb(123, 122, 122);stroke-width:1" stroke-dasharray="2,2">
							<xsl:attribute name="x1">{{this.svgPos}}</xsl:attribute>	
							<xsl:attribute name="x2">{{this.svgPos}}</xsl:attribute>
							 <xsl:attribute name="y1">{{#Y1Pos @index 20}}{{/Y1Pos}}</xsl:attribute>	
							 <xsl:attribute name="y2">{{#Y2Pos @index 120}}{{/Y2Pos}}</xsl:attribute>
						</line>
						<circle r="20"><xsl:attribute name="fill">{{this.backgroundColour}}</xsl:attribute><xsl:attribute name="cx">{{this.svgPos}}</xsl:attribute><xsl:attribute name="cy">150</xsl:attribute><xsl:attribute name="style">stroke:{{this.backgroundColour}};stroke-opacity:30%;stroke-width:10;</xsl:attribute></circle>
						
						<rect width="125" height="35"  rx="5" filter="url(#f1)" style="fill:#fff; stroke-width:1;stroke:rgb(133, 133, 133);"><xsl:attribute name="y">{{#YPos @index 22}}{{/YPos}}</xsl:attribute><xsl:attribute name="x">{{#XPos this.svgPos}}{{/XPos}}</xsl:attribute></rect>				
						<text><xsl:attribute name="y">{{#YPos @index 35}}{{/YPos}}</xsl:attribute><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.name}}</text>
						<text><xsl:attribute name="y">{{#YPos @index 50}}{{/YPos}}</xsl:attribute><xsl:attribute name="x">{{this.svgPos}}</xsl:attribute>{{this.dateOf}}</text>
						{{/ifEquals}}
				{{/each}}	
				</svg>
			</div>		
			 
	</div>

</script>
	<script id="panel-template" type="text/x-handlebars-template">

		<div class="container-fluid" id="summary-content">
			
			<!--Setup Vertical Tabs-->
			<div class="row">
				<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
					<!-- required for floating -->
					<!-- Nav tabs -->
					<ul class="nav nav-tabs tabs-left">
						<li class="active">
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Details')"/></a>
						</li> 
						{{#if this.allServices.0.serviceName}}	
						<li>
							<a href="#appservices" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Services')"/></a>
						</li> 
						{{/if}}
						{{#if this.caps}}	
						<li>
							<a href="#buscaps" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Business Capabilities')"/></a>
						</li> 
						{{/if}}
						
						{{#if this.processInfo}}	
						<li>
							<a href="#appProcesses" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Business Processes')"/></a>
						</li> 
						{{/if}}
						{{#if this.classifications}}	
						<li>
							<a href="#appClassifications" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Classifications')"/></a>
						</li> 
						{{/if}}
						{{#if this.security}}	
						<li>
							<a href="#appSecurity" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Security')"/></a>
						</li> 
						{{/if}}
						{{#if this.inIList}}
						<li>
								<a href="#appIntegration" data-toggle="tab" id="appIntTab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Integrations')"/></a>
							</li> 
						{{else}}
						{{#if this.outIList}}
						<li>
							<a href="#appIntegration" data-toggle="tab" id="appIntTab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Integrations')"/></a>
						</li> 
						{{/if}}
						{{/if}}
						{{#if this.applicationTechnology.db}}	
						<li>
							<a href="#appTech" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Technology')"/></a>
						</li> 
						{{else}}
						{{#if this.applicationTechnology.environments}}
							<li>
								<a href="#appTech" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Technology')"/></a>
							</li> 
						{{/if}}
						{{/if}}
						{{#if this.costs}}	
						<li>
							<a href="#appcosts" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Cost')"/></a>
						</li> 
						{{/if}}
						{{#if this.dataObj}}	
						<li>
							<a href="#appdata" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Data')"/></a>
						</li> 
						{{/if}}
						{{#if this.lifecycles}}	
						<li>
							<a href="#appLifecycle" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Lifecycle')"/></a>
						</li> 
						{{/if}}
						{{#if this.pm}}	
						<li>
							<a href="#appKpis" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application KPIs')"/></a>
						</li> 
						{{/if}}
						{{#if this.issues}}
						<li>
							<a href="#issues" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Issues')"/></a>
						</li>
						{{/if}}
						{{#if this.plans}}
						<li>
							<a href="#appPlans" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></a>
						</li>
						{{/if}}
						{{#if this.otherEnums}}
						<li>
							<a href="#otherEnums" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Other')"/></a>
						</li>
						{{/if}}
						{{#if this.eipmode}}
						<li id="diagramli"> 
							<a href="#diagrams" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Diagrams')"/></a>
						</li> 
						{{/if}}
						{{#if this.documents}}
						<li>
							<a href="#documents" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Documents')"/></a>
						</li>
						{{/if}}
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application Details')"/></h2>
							<div class="parent-superflex">
								<div class="superflex" style="width:50%">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application')"/></h3>
									<label><xsl:value-of select="eas:i18n('Name')"/></label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<div class="ess-string">{{{breaklines this.description}}}</div>
									<div class="clearfix bottom-10"></div>
									{{#if this.ap_business_criticality}}
									<label><xsl:value-of select="eas:i18n('Business Criticality')"/></label>
									<div class="ess-string">{{#getInfo this.ap_business_criticality 'Business_Criticality'}}{{/getInfo}}</div>
									<div class="clearfix bottom-10"></div>
									{{/if}}
									{{#if this.supplier}}
									<label><xsl:value-of select="eas:i18n('Application Supplier')"/></label>
									<div class="ess-string">{{#essRenderInstanceMenuLink this.supplier}}{{/essRenderInstanceMenuLink}}</div>
									{{/if}}
									{{#if this.family}}
									<label><xsl:value-of select="eas:i18n('Application Family')"/></label>
									<ul class="ess-list-tags">
										{{#each this.family}}
										<li class="family-tag" style="background-color: rgb(68, 182, 179)">{{this.name}}</li>
										{{/each}}
									</ul>
									{{/if}}
									{{#if this.short_name}}
									<label><xsl:value-of select="eas:i18n('Also Known As')"/></label>
									<div class="ess-string">{{this.short_name}}</div>
									<div class="clearfix bottom-10"></div>
									{{/if}}
									{{#if this.synonyms}}
									<label><xsl:value-of select="eas:i18n('Synonyms')"/></label>
									{{#each this.synonyms}}
										<span class="label label-default">{{this.name}}</span>
									{{/each}} 
									{{/if}}
									
									
									 
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
							 
									<label><xsl:value-of select="eas:i18n('Lifecycle Status')"/></label>
									<div class="bottom-10">
											{{#if this.lifecycle_status_application_provider}}
											 {{#getInfo this.lifecycle_status_application_provider 'Lifecycle_Status'}}{{/getInfo}} 
											{{else}}
											<span class="label label-warning"><xsl:value-of select="eas:i18n('Not Set')"/></span>
											{{/if}}
									</div>
									<label><xsl:value-of select="eas:i18n('Codebase')"/></label>
									<div class="bottom-10">
											{{#if this.ap_codebase_status}}
											 {{#getInfo this.ap_codebase_status 'Codebase_Status'}}{{/getInfo}} 
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label><xsl:value-of select="eas:i18n('Delivery Model')"/></label>
									<div class="bottom-10">
											{{#if this.ap_delivery_model}} 
											{{#getInfo this.ap_delivery_model 'Application_Delivery_Model'}}{{/getInfo}}  
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label><xsl:value-of select="eas:i18n('Disposition')"/></label>
									<div class="bottom-10">
											{{#if this.ap_disposition_lifecycle_status}} 
											{{#getInfo this.ap_disposition_lifecycle_status 'Disposition_Lifecycle_Status'}}{{/getInfo}}  
											 
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label><xsl:value-of select="eas:i18n('Purpose')"/></label>
									<div class="bottom-10">
											{{#if this.application_provider_purpose}}  
											{{#each this.application_provider_purpose}}
											{{#getInfo this 'Application_Purpose'}}{{/getInfo}}   
											{{/each}}
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>								
								
								</div>
								{{#if this.stakeholders}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Ownership')"/></h3>
									 
										{{#each this.stakeholders}}
											{{#ifContains this 'Owner'}}{{/ifContains}}
										{{/each}}
									<div class="clearfix bottom-10"></div>  
								</div> 
								{{/if}}
								{{#if this.children}}
								<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-sitemap right-10"></i><xsl:value-of select="eas:i18n('Contained Applications')"/></h3>
					
									<div class="app-tree">
									<ul class="tree-root">
										{{#each this.children}}
										<li class="tree-node">
											<div class="node-line">
											<span class="node-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
										
											</div>
											{{#if children.length}}
											<ul class="children">
												{{#each children}}
												<li class="tree-node">
													<div class="node-line">
													<span class="node-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
												
													</div>
													{{#if children.length}}
													<ul class="children">
														{{#each children}}
														<li class="tree-node">
															<div class="node-line">
															<span class="node-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
															
															</div>
															{{#if children.length}}
															<ul class="children">
																{{#each children}}
																<li class="tree-node">
																	<div class="node-line">
																	<span class="node-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
																	
																	</div>
																	{{#if children.length}}
																	<ul class="children">
																		{{#each children}}
																		<li class="tree-node">
																			<div class="node-line">
																			<span class="node-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
																			
																			</div>
																			{{#if children.length}}
																			<ul class="children">
																				{{#each children}}
																				<li class="tree-node">
																					<div class="node-line">
																					<span class="node-name">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
																					
																					</div>
																				</li>
																				{{/each}}
																			</ul>
																			{{/if}}
																		</li>
																		{{/each}}
																	</ul>
																	{{/if}}
																</li>
																{{/each}}
															</ul>
															{{/if}}
														</li>
														{{/each}}
													</ul>
													{{/if}}
												</li>
												{{/each}}
											</ul>
											{{/if}}
										</li>
										{{/each}}
									</ul>
									</div>
								</div>
								{{/if}}
								<div class="col-xs-12"/>
								{{#if this.classifications}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list right-10" ></i><xsl:value-of select="eas:i18n('Relevant Regulations')"/></h3>
									<div>
										<b><xsl:value-of select="eas:i18n('Mapped via Data Objects')"/>:</b>
										{{#each this.classifications}} 
										{{#each this.regulation}} 
											{{#if this.name}}
											<span class="label label-info   right-10" style="background-color: #476ecc">{{this.name}}</span>
											{{/if}}
										{{/each}}
										{{/each}}
									</div>
									{{#if this.regulations}}
									<div>
										<b><xsl:value-of select="eas:i18n('Mapped directly to application')"/>: </b>
										{{#each this.regulations}}<span class="label label-info right-5" style="background-color: #476ecc">{{this.name}}</span>{{/each}}
									</div>
									{{/if}}
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-shield right-10"></i><xsl:value-of select="eas:i18n('Classifications')"/></h3>
									<div>
		
										{{#each this.classifications}}
											<span class="label label-info   right-10" style="background-color: #476ecc">{{this.name}}</span>
										{{/each}}
									</div>
								</div>
								{{else}}
									{{#if this.regulations}}
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-list right-10"></i><xsl:value-of select="eas:i18n('Relevant Regulations')"/></h3>
										{{#each this.regulations}}
											<span class="label label-info right-5">{{this.name}}</span>
										{{/each}}
									</div>
									{{/if}}
								 {{/if}}
								 
								<div class="col-xs-12"/>
								{{#if this.stakeholdersList}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('People &amp; Roles')"/></h3>
									
									<table class="table table-striped table-bordered" id="dt_stakeholders">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
											{{#each this.stakeholdersList}} 
											{{#ifEquals this.key ''}}
											{{else}}
											<tr>
												<td class="cellWidth-30pc">
													{{#essRenderInstanceLinkOnly this 'Individual_Actor'}}{{/essRenderInstanceLinkOnly}}
												</td>
												<td class="cellWidth-30pc">
											 
													<ul class="ess-list-tags">
													{{#each this.values}}
														<li class="tagActor" style="background-color: rgb(185, 225, 230);color:#000">{{this.role}}</li>
													{{/each}}
													</ul>
													 
												</td>
												 
											</tr>	
											{{/ifEquals}} 
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Person')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													 
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
								{{#if this.orgStakeholdersList}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Organisations &amp; Roles')"/></h3>
									
									<table class="table table-striped table-bordered" id="dt_stakeholders2">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Organisations')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
											{{#each this.orgStakeholdersList}} 
											<tr>
												<td class="cellWidth-30pc">
														{{#essRenderInstanceLinkOnly this 'Group_Actor'}}{{/essRenderInstanceLinkOnly}}
												</td>
												<td class="cellWidth-30pc">
											 
													<ul class="ess-list-tags">
													{{#each this.values}}
														<li class="tagActor"  style="background-color: rgb(215, 190, 233);color:#000">{{this.role}}</li>
													{{/each}}
													</ul>
													 
												</td>
												 
											</tr>	 
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Organisation')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													 
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
								 
								{{#if this.decisions}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Decisions')"/></h3>
									
									<table class="table table-striped table-bordered" id="decisionsTable">
										<thead>
											<tr>
												<td>Decision</td>
												<td>Reference</td>
												<td>Decision Date</td>
												<td>Decision Description</td>
												<td>Decision Owner</td>
											</tr>
										</thead>
										<tbody>
											{{#each this.decisions}}
											<tr>
												<td>{{this.name}}</td>
												<td>{{this.governance_reference}}</td>
												<td>{{decision_date}}</td>
												<td>{{description}}</td>
												<td>{{ownerInfo.name}}</td>
											</tr>
											{{/each}}
										</tbody>
								
									</table>
								</div>
								{{/if}}
							<div class="clearfix bottom-10"></div>
							 <!-- SVG TEST-->
							
						</div>
						</div>	 
						{{#if this.security}}	
						 
						<div class="tab-pane svgTab" id="appSecurity">
							<div class="parent-superflex">
								<div class="superflex">
									<div>
										<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application Security')"/></h3>
										<p><xsl:value-of select="eas:i18n('Current security posture for the application')"/><xsl:text> </xsl:text> </p>
										<div class="row">
											<!-- Left Column -->
											<div class="col-sm-6">
											  <!-- Security Ratings Dashboard -->
											  <div class="panel panel-default">
												<div class="panel-heading"><h4 class="panel-title"><xsl:value-of select="eas:i18n('Security Ratings')"/></h4></div>
												<div class="panel-body">
												  <div class="row">
													<!-- Confidentiality Card -->
													<div class="col-xs-12">
													  <div class="panel panel-default">
														<div class="panel-heading-sub clearfix">
														  <h5 class="panel-title pull-left"><xsl:value-of select="eas:i18n('Confidentiality')"/></h5>
														  <i data="lock" class="pull-right"></i>
														</div>
														<div class="panel-body">
														  <div class="row">
															<div class="col-xs-6">
															  <p class="text-muted"><xsl:value-of select="eas:i18n('Rating')"/>:<xsl:text> </xsl:text> 
																<span class="lead secBox"><xsl:attribute name="style">color:{{this.security.sec_profile_confidentiality_rating_style.colour}};background-color:{{this.security.sec_profile_confidentiality_rating_style.backgroundColour}};border-color:{{this.security.sec_profile_confidentiality_rating_style.backgroundColour}}E6</xsl:attribute>{{this.security.sec_profile_confidentiality_rating}}</span>
																</p>
															</div>
															<div class="col-xs-6">
															  <p class="text-muted"><xsl:value-of select="eas:i18n('Risk Impact')"/>:<xsl:text> </xsl:text>
															  	<span class="lead secBox"><xsl:attribute name="style">color:{{this.security.sec_profile_confidentiality_risk_impact_style.colour}};background-color:{{this.security.sec_profile_confidentiality_risk_impact_style.backgroundColour}};border-color:{{this.security.sec_profile_confidentiality_risk_impact_style.backgroundColour}}E6</xsl:attribute>{{this.security.sec_profile_confidentiality_risk_impact}}</span>
															  </p>
															</div>
														  </div>
														</div>
													  </div>
													</div>
									  
													<!-- Integrity Card -->
													<div class="col-xs-12">
													  <div class="panel panel-default">
														<div class="panel-heading-sub clearfix">
														  <h5 class="panel-title pull-left"><xsl:value-of select="eas:i18n('Integrity')"/></h5>
														  <i data="shield" class="pull-right"></i>
														</div>
														<div class="panel-body">
														  <div class="row">
															<div class="col-xs-6">
															  <p class="text-muted"><xsl:value-of select="eas:i18n('Rating')"/>:<xsl:text> </xsl:text>
															  	<span class="lead secBox"><xsl:attribute name="style">color:{{this.security.sec_profile_integrity_rating_style.colour}};background-color:{{this.security.sec_profile_integrity_rating_style.backgroundColour}};border-color:{{this.security.sec_profile_integrity_rating_style.backgroundColour}}E6</xsl:attribute>{{this.security.sec_profile_integrity_rating}}</span>
															  </p>
															</div>
															<div class="col-xs-6">
															  <p class="text-muted"><xsl:value-of select="eas:i18n('Risk Impact')"/>:<xsl:text> </xsl:text>
																<span class="lead secBox"><xsl:attribute name="style">color:{{this.security.sec_profile_integrity_risk_impact_style.colour}};background-color:{{this.security.sec_profile_integrity_risk_impact_style.backgroundColour}};border-color:{{this.security.sec_profile_integrity_risk_impact_style.backgroundColour}}E6</xsl:attribute>{{this.security.sec_profile_integrity_risk_impact}}
																</span>
															 </p>
															</div>
														  </div>
														</div>
													  </div>
													</div>
									  
													<!-- Availability Card -->
													<div class="col-xs-12">
													  <div class="panel panel-default">
														<div class="panel-heading-sub clearfix">
														  <h5 class="panel-title pull-left"><xsl:value-of select="eas:i18n('Availability')"/></h5>
														  <i data="refresh-cw" class="pull-right"></i>
														</div>
														<div class="panel-body">
														  <div class="row">
															<div class="col-xs-6">
															  <p class="text-muted"><xsl:value-of select="eas:i18n('Rating')"/>:<xsl:text> </xsl:text>
															  <span class="lead secBox"><xsl:attribute name="style">color:{{this.security.sec_profile_availability_rating_style.colour}};background-color:{{this.security.sec_profile_availability_rating_style.backgroundColour}};border-color:{{this.security.sec_profile_availability_rating_style.backgroundColour}}E6</xsl:attribute><xsl:value-of select="eas:i18n('Rating')"/><xsl:text> </xsl:text>{{this.security.sec_profile_availability_rating}}
															</span>
															</p>
															</div>
															<div class="col-xs-6">
															  <p class="text-muted"><xsl:value-of select="eas:i18n('Risk Impact')"/>:<xsl:text> </xsl:text>
																<span class="lead secBox"><xsl:attribute name="style">color:{{this.security.sec_profile_availability_risk_impact_style.colour}};background-color:{{this.security.sec_profile_availability_risk_impact_style.backgroundColour}};border-color:{{this.security.sec_profile_availability_risk_impact_style.backgroundColour}}E6</xsl:attribute>{{this.security.sec_profile_availability_risk_impact}}</span>
																</p>
															</div>
														  </div>
														</div>
													  </div>
													</div>
												  </div>
												</div>
											  </div>
									  
											  <!-- Additional Details Section -->
											  <div id="detailsSection" class="panel panel-default">
												<div class="panel-heading"><h4 class="panel-title"><xsl:value-of select="eas:i18n('Authentication Details')"/></h4></div>
												<div class="panel-body">
												  <p>
													{{#if this.security.authentication_methods}}
													{{#each this.security.authentication_methods}}
														<span class="label label-default">{{this.name}}</span>
													{{/each}}
													{{else}}
														<xsl:value-of select="eas:i18n('No authentication methods defined')"/>
													{{/if}}
												  </p>
												</div>
											  </div>
											</div>
									  
											<!-- Right Column -->
											<div class="col-sm-6">
											  <!-- Security Measures -->
											  <div class="panel panel-default">
												<div class="panel-heading"><h4 class="panel-title"><xsl:value-of select="eas:i18n('Security Measures')"/></h4></div>
												<div class="panel-body">
												  <ul class="list-group">
													<li class="list-group-item">
													  {{#if (eq this.security.sec_profile_is_data_encrypted_at_rest "true")}}
														<i class="fa fa-check-circle text-success"></i>
													  {{else}}
														<i class="fa fa-times-circle text-danger"></i>
													  {{/if}}
													  <strong><xsl:value-of select="eas:i18n('Data Encryption at Rest')"/>:</strong> {{#if (eq this.security.sec_profile_is_data_encrypted_at_rest "true")}}<xsl:text> </xsl:text>
													  <span class="secBox"><xsl:attribute name="style">color:#ffffff; background-color: green</xsl:attribute><xsl:value-of select="eas:i18n('Implemented')"/></span>{{else}}<xsl:text> </xsl:text>
													  <span class="lead secBox"><xsl:attribute name="style">color:#ffffff; background-color: red</xsl:attribute><xsl:value-of select="eas:i18n('Not Implemented')"/></span>{{/if}}
													</li>
									  
													<li class="list-group-item">
														{{#if (eq this.security.sec_profile_sso_usage "Implemented")}}
														<i class="fa fa-check-circle text-success"></i><xsl:text> </xsl:text> 
													  {{else if (eq this.security.sec_profile_sso_usage "Not Supported")}}
														<i class="fa fa-times-circle text-danger"></i><xsl:text> </xsl:text> 
													  {{else}}
														<i class="fa fa-warning text-warning"></i><xsl:text> </xsl:text> 
													  {{/if}}
														<strong><xsl:value-of select="eas:i18n('Single Sign-On (SSO)')"/>:</strong>
													  {{#if (eq this.security.sec_profile_sso_usage "Implemented")}}
														 <xsl:text> </xsl:text>
														<span class="secBox block-success"> {{this.security.sec_profile_sso_usage}}</span>
													  {{else if (eq this.security.sec_profile_sso_usage "Not Supported")}}
														 <xsl:text> </xsl:text>
														<span class="secBox block-danger"> {{this.security.sec_profile_sso_usage}}</span>
													  {{else}}
														 <xsl:text> </xsl:text>
														<span class="secBox block-warning"> {{this.security.sec_profile_sso_usage}}</span>
													  {{/if}}
													  
													  
													</li>
									  
													<li class="list-group-item">
													  {{#if (eq this.security.sec_profile_mfa_usage "Implemented")}}
														<i class="fa fa-check-circle text-success"></i>
													  {{else if (eq this.security.sec_profile_mfa_usage "Not Supported")}}
														<i class="fa fa-times-circle text-danger"></i>
													  {{else}}
														<i class="fa fa-warning text-warning"></i>
													  {{/if}}
													  <strong><xsl:value-of select="eas:i18n('Multi-Factor Authentication')"/>:</strong> 
													  
													  {{#if (eq this.security.sec_profile_mfa_usage "Implemented")}}
													  <span class="secBox block-success"> {{this.security.sec_profile_mfa_usage}}</span>
														{{else if (eq this.security.sec_profile_mfa_usage "Not Supported")}}
														<span class="secBox block-danger"> {{this.security.sec_profile_mfa_usage}}</span>
														{{else}}
														<span class="secBox block-warning"> {{this.security.sec_profile_mfa_usage}}</span>
														{{/if}} 
													</li>
									  
													<li class="list-group-item">
													  {{#if (eq this.security.sec_profile_rbac_usage "Implemented")}}
														<i class="fa fa-check-circle text-success "></i>
													  {{else if (eq this.security.sec_profile_rbac_usage "Not Supported")}}
														<i class="fa fa-times-circle text-danger"></i>
													  {{else}}
														<i class="fa fa-warning text-warning"></i>
													  {{/if}}
													  <strong><xsl:value-of select="eas:i18n('Role-Based Access Control')"/>:</strong> 
													  
													  {{#if (eq this.security.sec_profile_rbac_usage "Implemented")}}
													  	<span class="secBox block-success"> {{this.security.sec_profile_rbac_usage}}</span>
														{{else if (eq this.security.sec_profile_rbac_usage "Not Supported")}} 
														<span class="secBox block-danger"> {{this.security.sec_profile_rbac_usage}}</span>
														{{else}} 
														<span class="secBox block-warning"> {{this.security.sec_profile_rbac_usage}}</span>
														{{/if}}
													  
													</li>
									  
													<li class="list-group-item">
													  <i class="fa fa-calendar"></i><xsl:text> </xsl:text>
													  <strong><xsl:value-of select="eas:i18n('Access Review Frequency')"/>:</strong> 
													  <span class="secBox">{{this.security.sec_profile_user_access_review_frequency}}</span>
													</li>
									  
													<li class="list-group-item">
													  <div class="lucide-icon">
														{{#if (eq this.security.sec_profile_is_internal_facing "true")}}
														  <i class="fa fa-eye"></i>
														{{/if}}
														{{#if (eq sec_profile_is_external_facing "true")}}
														  <i class="fa fa-slash"></i>
														{{/if}}
													  
													  <strong><xsl:value-of select="eas:i18n('Visibility')"/>:</strong>
													  {{#if (eq this.security.sec_profile_is_internal_facing "true")}}<span class="secBox block-success">Internal</span>{{/if}}
													  {{#if (and (eq this.security.sec_profile_is_internal_facing "true") (eq this.security.sec_profile_is_external_facing "true"))}} &amp; {{/if}}
													  {{#if (eq this.security.sec_profile_is_external_facing "true")}}<span class="secBox block-warning">External</span>{{/if}}
													  {{#unless (or (eq this.security.sec_profile_is_internal_facing "true") (eq this.security.sec_profile_is_external_facing "true"))}}
														<span class="secBox block-muted"><xsl:value-of select="eas:i18n('Not Known')"/></span>
														{{/unless}}
													</div>
													</li>
												  </ul>
												</div>
											  </div>
									  
											  <!-- Security Overview -->
											  <div class="panel panel-default">
												<div class="panel-heading"><h4 class="panel-title"><xsl:value-of select="eas:i18n('Security Summary')"/></h4></div>
												<div class="panel-body">
												  {{#with (calculateSecurityRating this.security.sec_profile_confidentiality_rating sec_profile_integrity_rating this.security.sec_profile_availability_rating)}}
													<p style="font-size:1.3em">
													  <span><xsl:attribute name="class">glyphicon glyphicon-record text-{{color}}</xsl:attribute></span><xsl:text> </xsl:text>
													  <strong><xsl:value-of select="eas:i18n('Overall Security Status')"/>:</strong>
													  <xsl:text> </xsl:text>
													  <span><xsl:attribute name="class">secBox text-{{color}}</xsl:attribute><b>{{status}}</b></span>
													</p>
												  {{/with}} 
												</div>
											  </div>
											</div>
										  </div>
									</div>	
														 
									 
								</div>
							</div>
						</div>
						{{/if}}
						<div class="tab-pane svgTab" id="appIntegration">
							<div class="parent-superflex">
								<div class="superflex">
									<div>
										<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Integrations')"/></h3>
										<p><xsl:value-of select="eas:i18n('High-level integration view of')"/><xsl:text> </xsl:text> <u><xsl:value-of select="eas:i18n('application-level')"/></u> <xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('integrations.  See detailed view with data flow information.')"/></p>
										<div class="pull-right"><button class="btn btn-success interfaceButton"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:value-of select="eas:i18n('View Integration Detail')"/></button></div>
									</div>		
									
									<ul class="nav nav-tabs">
									<li class="active"><a data-toggle="tab" href="#simpleTab" id="simpleTabLink"><xsl:value-of select="eas:i18n('Simple')"/></a></li> 
									<li><a data-toggle="tab" href="#detailedTab" id="detailedTabLink"><xsl:value-of select="eas:i18n('Detailed')"/></a></li>
									</ul>

									<div class="tab-content"> 
									<div id="simpleTab" class="tab-pane fade in active">
										<p><xsl:value-of select="eas:i18n('Excluding APIs')"/></p>
										<div id="svgBox" >
										<svg width="800px" height="600px"/>
									</div>
									</div>
									<div id="detailedTab" class="tab-pane fade">
										<p><xsl:value-of select="eas:i18n('Including APIs')"/></p>
										<div id="appIntegrationDiagram"></div>
									</div>
									</div>
									

									
								</div>
							</div>
						</div>
					 
						
						{{#if this.dataObj}}	
						<div class="tab-pane" id="appdata2">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Data Attributes')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Data Attributes')"/></h3>
									<p>Attributes for this data object</p>
									<table id="dt_dobjecttable" class="table table-striped table-bordered" >
									<thead>
										<tr>
											<th><xsl:value-of select="eas:i18n('Name')"/></th>
											<th><xsl:value-of select="eas:i18n('Description')"/></th>
											<th><xsl:value-of select="eas:i18n('Type')"/></th>
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
											<th><xsl:value-of select="eas:i18n('Name')"/></th>
											<th><xsl:value-of select="eas:i18n('Description')"/></th>
											<th><xsl:value-of select="eas:i18n('Type')"/></th>
										</tr>
									</tfoot>
									</table>
								</div>
							</div>

						</div>
						{{/if}}
						{{#if this.caps}}
						<div class="tab-pane" id="buscaps">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Business Capabilities Supported')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Business Capabilities Supported')"/></h3>
									<div class="capContainer">
										{{#each this.caps}}
										<div class="column">
											<div class="column-header">Level {{#getCapLevel @key}}{{/getCapLevel}}</div>
											{{#each this}}
											<div class="rounded-box"> 
												<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>
											</div>
											{{/each}}
										</div>
										{{/each}}
									</div>
									

								</div>
							</div>
						</div>
						{{/if}}
						
						<div class="tab-pane" id="appClassifications">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Classifications')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Classifications')"/></h3>
									<p><xsl:value-of select="eas:i18n('Classifications that are applied to this application')"/></p>
									{{#if this.ap_business_criticality}}
									<label><xsl:value-of select="eas:i18n('Business Criticality')"/></label>
									<div class="ess-string">{{#getInfo this.ap_business_criticality 'Business_Criticality'}}{{/getInfo}}</div>
									<div class="clearfix bottom-10"></div>
									{{/if}}
									<div class="inline-elements">
									{{#if this.ea_recovery_time_objective}} 
										<label><xsl:value-of select="eas:i18n('Recovery Time Objective')"/></label> 
										<div class="ess-string">{{#getInfo this.ea_recovery_time_objective 'Recovery_Time_Objective'}}{{/getInfo}}</div> 
									{{/if}} 
									{{#if this.ea_recovery_point_objective}} 
										<label><xsl:value-of select="eas:i18n('Recovery Point Objective')"/></label> 
										<div class="ess-string">{{#getInfo this.ea_recovery_point_objective 'Recovery_Point_Objective'}}{{/getInfo}}</div> 
										<div class="clearfix bottom-10"></div> 
									{{/if}}
									</div>
										<h3><xsl:value-of select="eas:i18n('Grouped by Regulation')"/></h3>
										<table cellpadding="10" cellspacing="0" class="table table-striped">
										  <thead>
											<tr>
											  <th><xsl:value-of select="eas:i18n('Regulation')"/></th>
											  <th><xsl:value-of select="eas:i18n('Classification Name')"/></th>
											  <th><xsl:value-of select="eas:i18n('Data Objects')"/></th>
											</tr>
										  </thead>
										  <tbody>
											{{#each this.classificationsByReg}}
											  {{#each this}}
												<tr>
												  {{#if @first}}
													<td rowspan="{{../length}}"><span class="label label-default">{{@../key}}</span></td>
												  {{/if}}
												  <td><span class="label label-default">{{classificationName}}</span></td>
												  <td>	{{#each data_objects}}
															<li><span class="label label-primary">{{this.name}}</span></li>
														{{/each}}
												</td>
												</tr>
											  {{/each}}
											{{/each}}
										  </tbody>
										</table> 
									   
										<h3><xsl:value-of select="eas:i18n('Grouped by Classification Name')"/></h3>
										<table cellpadding="10" cellspacing="0" class="table table-striped">
										  <thead>
											<tr>
											  <th><xsl:value-of select="eas:i18n('Classification Name')"/></th>
											  <th><xsl:value-of select="eas:i18n('Data Objects')"/></th> 
											</tr>
										  </thead>
										  <tbody>
											{{#each this.classificationsByType}}
											  <tr>
												<td><span class="label label-default">{{this.name}}</span></td>
												<td>
												  <ul>
													{{#each data_objects}}
													  <li><span class="label label-primary">{{this.name}}</span></li>
													{{/each}}
												  </ul>
												</td>
												 
											  </tr>
											{{/each}}
										  </tbody>
										</table> 
									  

								</div>
							</div>
							<div class="superflex">
								<h4><xsl:value-of select="eas:i18n('Standards')"/></h4>
								{{#each this.allServices}}
								{{#if this.std}}

								  <table class="table table-striped">
								
									<tbody>
									  <tr>
										<td colspan="2">
										 <b> {{#essRenderInstanceMenuLink this.linkDetails}}{{/essRenderInstanceMenuLink}}</b>
										</td>
									  </tr>
									  <tr>
										<td></td>
										<td>
										  <table class="table table-striped table-condensed">
											<thead>
											  <tr>
												<td><xsl:value-of select="eas:i18n('Standard')"/></td>
												<td><i class="fa fa-sitemap text-primary"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Organisations')"/></td>
												<td><i class="fa fa-globe text-primary"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Geographies')"/></td>
											  </tr>
											</thead>
											<tbody>
											  {{#each this.std}}
											 
												<tr> 
												  <td>
													<button class="btn btn-xs"><xsl:attribute name="style">{{#getStdColour this.strId 'Standard_Strength'}}{{/getStdColour}}</xsl:attribute>
													{{this.str}}</button></td>
												  <td>
													{{#each this.orgs}}
													<i class="fa fa-caret-right"></i><xsl:text> </xsl:text>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}} 
													  <br/>
													{{/each}}
												  </td>
												  <td>
													{{#each this.geo}}
													{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
													<i class="fa fa-caret-right"></i><xsl:text> </xsl:text>{{this.geo}}<br/>
												 	 {{/each}}</td>
												</tr> 
											  {{/each}}
											</tbody>
										  </table>
										</td>
									  </tr>
									</tbody>
								  </table>
								{{/if}}
							  {{/each}}
							  
							</div>
						</div>
						{{#if this.processInfo}}	
						<div class="tab-pane" id="appProcesses">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Business Process Supported')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Business Process Supported')"/></h3>
									<p><xsl:value-of select="eas:i18n('The application supports these business processes')"/></p>
									<table id="dt_processtable" class="table table-striped table-bordered table-compact" >
									<thead>
										<tr>
											<th><xsl:value-of select="eas:i18n('Process')"/></th>
											<th><xsl:value-of select="eas:i18n('Organisation')"/></th>
											<th><xsl:value-of select="eas:i18n('Service')"/></th>
											<th><xsl:value-of select="eas:i18n('Route')"/></th>
										</tr>
										 
									</thead>
									<tbody>
									{{#each this.processInfo}}
									{{#if this.name}}
										<tr>
											<td>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</td>
											<td><span class="label labelOrg">{{this.org}}</span></td>
											<td><span class="label label-success">{{this.svcName}}</span></td>
											<td>
												{{#ifEquals this.direction 'Direct'}}
													<span class="label label-primary">{{this.direction}}</span>
												{{else}}
													<span class="label label-info">{{this.direction}}</span>
												{{/ifEquals}}</td>
										</tr>
										{{/if}}
									{{/each}}
									</tbody>
									<tfoot>
										<tr>
											<th><xsl:value-of select="eas:i18n('Process')"/></th>
											<th><xsl:value-of select="eas:i18n('Organisation')"/></th>
											<th><xsl:value-of select="eas:i18n('Service')"/></th>
											<th><xsl:value-of select="eas:i18n('Route')"/></th>
										</tr>
									</tfoot>
									</table>
								</div>
							</div>

						</div>
						{{/if}}
						{{#if this.applicationTechnology}}	
						<div class="tab-pane" id="appTech">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Application Technology')"/></h2>
							<div class="parent-superflex">
								{{#if this.db}}
								<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Databases')"/></h3>
										<p><xsl:value-of select="eas:i18n('The databases this application is using')"/></p>
										
									{{#each this.db}}
										<i class="fa fa-database"></i>
									
										{{#essRenderInstanceMenuLink this.infoRep}}{{/essRenderInstanceMenuLink}}<br/>
									{{/each}}
								</div>
								{{/if}}
								{{#if this.applicationTechnology.environments}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application Technology')"/></h3>
									<div class="pull-left"><xsl:value-of select="eas:i18n('The technology supporting this application, by environment')"/></div>
									<div class="pull-right">
										<strong><xsl:value-of select="eas:i18n('Standards Key')"/>:</strong>
										{{#if this.stdkey}}
											{{#each this.stdkey}}
												<div class="keyStandard pull-right"><xsl:attribute name="style">background-color:{{this.colour}};color:{{this.colourText}}</xsl:attribute>{{this.name}}</div>
											{{/each}}
										{{/if}}
									</div>
									<div class="clearfix bottom-10"/>
									<div class="stack-item-instances-wrapper">
									{{#each this.applicationTechnology.environments}} 
										<div class="stack-item-instances">
											<div class="impact large bottom-10">{{this.name}}</div>
										{{#each this.products}}
											<div class="tech-item-wrapper">
												<div class="tech-item-label">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
												<div class="xsmall">
													<div class="tech-item-label-sub">
														{{this.compname}}
													</div>
												</div>
												{{#if standards}}
													<div class="standards">
														{{#each this.standards}}
														<i class="fa fa-circle fa-fw"><xsl:attribute name="style">color:{{this.statusBgColour}}</xsl:attribute></i>
														{{/each}} 
														<div class="pull-right left-5"><xsl:value-of select="eas:i18n('Standards')"/> <xsl:text> </xsl:text>
															<a tabindex="-1" class="popover-trigger" data-toggle="popover" style="color:#333;">
																<xsl:attribute name="easid">{​​​​​​​​​{​​​​​​​​​this.id}​​​​​​​​​}​​​​​​​​​</xsl:attribute>
																<i class="fa fa-info-circle"></i>
															</a>
															<div class="popover">
																<h5 class="strong"><xsl:value-of select="eas:i18n('Standards')"/></h5>
																<table class="table table-striped standardsTable">
																	<tr><th width="200px"><xsl:value-of select="eas:i18n('Status')"/></th><th width="300px"><xsl:value-of select="eas:i18n('Organisation')"/></th><th width="300px"><xsl:value-of select="eas:i18n('Geography')"/></th></tr>
																{{#each this.standards}}
																<tr>
																	<td><button type="button" class="btn btn-xs"><xsl:attribute name="style">background-color:{{this.statusBgColour}} !important;color:{{this.statusColour}}</xsl:attribute>{{this.status}}</button></td>
																	<td><small>{{#each this.scopeOrg}}<i class="fa fa-angle-right"></i>  {{this.name}}<br/>{{/each}}</small></td>
																	<td><small>{{#each this.scopeGeo}}<i class="fa fa-angle-right"></i>  {{this.name}}<br/>{{/each}}</small></td>
																</tr>	
																{{/each}}
																</table>
															</div>
														</div>
													</div>
												{{/if}}
											</div>
										{{/each}}
										  
										<div class="pull-left">
											{{#each this.nodes}}
												<span class="label label-primary whiteLabel">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
												<xsl:text> </xsl:text>
												<span class="label label-success">{{this.site}}</span><br/>
											{{/each}}
										</div>
										</div>
									{{/each}}
									</div>
								</div>
								{{/if}}
								{{#if this.prodApplicationTechnology}}
									<div class="superflex">
										<table class="table table-striped table condensed">
											<thead>
												<tr>
												<th><xsl:value-of select="eas:i18n('Production')"/><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Component')"/></th>
												<th><xsl:value-of select="eas:i18n('Product')"/></th>
												<th><xsl:value-of select="eas:i18n('lifecycle')"/></th>
												<th><xsl:value-of select="eas:i18n('Status')"/></th>
												</tr>
											</thead>
											<tbody>
											{{#each prodApplicationTechnology}}
												{{#each this}}
													<tr>
													{{!-- only on the first product, render the component-name cell with the proper rowspan --}}
													{{#if @first}}
														<td><xsl:attribute name="rowspan">{{../this.length}}</xsl:attribute>{{compname}}</td>
													{{/if}}
													<td>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</td>
													<td>
														<div class="service-container-badge badge rounded-pill"><xsl:attribute name="style">color:#000000;background-color:#ffffff; border: 2pt solid #d3d3d3;</xsl:attribute><xsl:attribute name="id">prodLifeId{{id}}</xsl:attribute></div>
													</td>
													<td>
														
														{{#if standards.length}}
														{{#each standards}}
															<div class="service-container-badge badge rounded-pill"><xsl:attribute name="style">color:#000000;background-color:#ffffff; border: 2pt solid {{this.statusBgColour}};</xsl:attribute>{{status}}</div>
														{{/each}}
														{{/if}}
													</td>
													</tr>
												{{/each}}
												{{/each}}
											</tbody>
											</table>

									</div>
								{{/if}}
							</div>

						</div>
						{{/if}}
						{{#if this.costs}}
						<div class="tab-pane" id="appcosts">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></h2>
							<div class="cost-dashboard">
								<div class="costTotal-container"></div>
								<div class="cost-table-card">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Detailed Costs')"/></h3>
									<p class="text-muted"><xsl:value-of select="eas:i18n('All captured cost components for this application in their native values')"/></p>
									<table class="table table-striped table-bordered display compact" id="dt_costs">
										<thead><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Description')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></thead>
										{{#each this.costs}}
										<tr>
											<td><span class="label label-primary">{{this.name}}</span></td>
											<td><span class="label label-primary">{{#getType this.costType}}{{/getType}}</span></td>
											<td>{{this.description}}</td>
											<td>{{#if this.this_currency}}{{this.this_currency}}{{else}}{{this.currency}}{{/if}}{{#formatCurrency this.cost}}{{/formatCurrency}}</td>
											<td>{{#formatDate this.fromDate}}{{/formatDate}}</td>
											<td>{{#formatDate this.toDate}}{{/formatDate}}</td>
										</tr>
										{{/each}}
										<tfoot><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Description')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></tfoot>
									</table>
								</div>
							</div>	
						</div>
						{{/if}} 
						{{#if this.allServices.0.serviceName}}
						<div class="tab-pane" id="appservices">
							<div class="summary-container">
								<!--service container-->
								<div class="service-container service-box">
								  <div class="header">
									<i class="fa fa-desktop" style="padding-right: 0.5rem"></i>
									<p class="app-header"><xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('Application Services')"/></p>
								  </div>
								  <div class="sub-text">
									<xsl:value-of select="eas:i18n('Application Services for this application with lifecycle status and
									function supported')"/>
								  </div>
								  <div class="pill-badge-container">
									<p class="key"><xsl:value-of select="eas:i18n('Key:')"/></p>
									<div class="pill-badges">
										{{#each this.lifecyclesKey}}
												<span
												class="service-container-badge badge rounded-pill"><xsl:attribute name="style">background-color:{{this.colour}};color:{{this.colourText}};</xsl:attribute>{{this.shortname}}</span> 
										{{/each}}
									 
									</div>
								  </div>
								  <div class="service-card-container">
									{{#each this.allServices}}
									<div class="card">
									  <div class="c-header"><xsl:attribute name="style">{{#getLifeColour this.lifecycleId 'Lifecycle_Status'}}{{/getLifeColour}}</xsl:attribute>
										<div class="header-title-box" style="color:white !important">{{#essRenderInstanceLinkOnly this.linkDetails 'Application_Service'}}{{/essRenderInstanceLinkOnly}}
										</div>
									  </div>
									  <div class="c-body">
										{{this.description}}
									  </div>
									  <div class="c-footer">
										<p>
										  {{#if this.functions}}
											<div  class="service-card-pops">
												<small>
												{{this.functions.length}}
												{{#ifEquals this.functions.length 1}}
												<xsl:value-of select="eas:i18n('Function')"/>
													{{else}}
													<xsl:value-of select="eas:i18n('Functions')"/>
												{{/ifEquals}} 
												</small>
												<a tabindex="-1" class="popover-trigger" data-toggle="popover">
													<xsl:attribute name="easid">{​​​​​​​​​{​​​​​​​​​this.id}​​​​​​​​​}​​​​​​​​​</xsl:attribute>
													<i class="fa fa-info-circle fa-xs"></i>
												</a>
												<div class="popover">
													<xsl:value-of select="eas:i18n('Functions')"/>
													<p class="small text-muted">{{#each this.functions}}<i class="fa fa-angle-right"></i> {{this.name}}<br/>{{/each}}</p>
												</div> 
											</div> 
										{{/if}}
										{{#if this.processes}}
											<div class="service-card-pops" style="margin-left:5px;">
												<small>
												{{this.processes.length}} 
												{{#ifEquals this.processes.length 1}}
												<xsl:value-of select="eas:i18n('Process')"/>
												{{else}}
												<xsl:value-of select="eas:i18n('Processes')"/>
												{{/ifEquals}}
												</small>
												<a tabindex="-1" class="popover-trigger" data-toggle="popover">
													<xsl:attribute name="easid">{​​​​​​​​​{​​​​​​​​​this.id}​​​​​​​​​}​​​​​​​​​</xsl:attribute>
													<i class="fa fa-info-circle fa-xs"></i>
												</a>
												<div class="popover">
													<h5 class="strong"><xsl:value-of select="eas:i18n('Processes')"/></h5>
													<p class="small text-muted">{{#each this.processes}}<i class="fa fa-angle-right"></i> {{#essRenderInstanceLinkOnly this 'Business_Process'}}{{/essRenderInstanceLinkOnly}}<br/>{{/each}}</p>
												</div>
											</div> 
											{{/if}}
										</p>
									  </div>
									</div>
									{{/each}}
						  
								  </div>
								</div>
						  
								<!--alternate service container-->
								<div class="alternate-service-container service-box">
								  <div class="header">
									<i class="fa-solid fa-display" style="padding-right: 0.5rem"></i>
									<p class="app-header"><xsl:value-of select="eas:i18n('Alternative Application Services')"/></p>
								  </div>
								  <div class="sub-text">
									<xsl:value-of select="eas:i18n('Application Services this application has which are also provided by other applications')"/>
								  </div>
						  
								  <div class="service-card-container alternate">
									{{#each this.allServices}}
									<div class="card">
									  <div class="c-header">
										<div class="header-title-box" style="color:white !important">{{#essRenderInstanceLinkOnly this.linkDetails 'Application_Service'}}{{/essRenderInstanceLinkOnly}}</div>
									  </div>
									  <div class="c-body">
										<ul class="fa-ul">
											{{#each this.otherAppsProviding}}
											{{#ifEquals this.name ../../name}}
											{{else}}
												<li><i class="fa fa-angle-right fa-li"></i>{{#essRenderInstanceLinkOnly this 'Application_Provider'}}{{/essRenderInstanceLinkOnly}}</li>
											{{/ifEquals}}	
											{{/each}}
										</ul>
									  </div>
									</div>
									{{/each}}
								  </div>
								</div>
							  </div>
							
							</div> 
						{{/if}}
						{{#if this.lifecycles}}	
						<div class="tab-pane" id="appLifecycle">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-road right-10"></i><xsl:value-of select="eas:i18n('Application Lifecycles')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-road right-10"></i><xsl:value-of select="eas:i18n('Application Lifecycles')"/></h3>
									<p><xsl:value-of select="eas:i18n('Lifecycles for the application')"/></p>
<!--
									<i class="fa fa-chevron-circle-left right-5" id="lifecycleDown"></i><small><xsl:value-of select="eas:i18n('Move Start Date')"/></small>
									
									<i class="fa fa-chevron-circle-right right-5" id="lifecycleUp"></i> 
									<div class="pull-right">
										<i class="fa fa-chevron-circle-left right-5" id="lifecycleEndDown"></i>
											<small><xsl:value-of select="eas:i18n('Move End Date')"/></small>
										<i class="fa fa-chevron-circle-right right-5" id="lifecycleEndUp"></i> 
									</div>
								 <div id="lifecyclePanel"></div>
-->
								 <div id="TimelinePanel"></div>
								</div>
							</div> 
						</div>
						{{/if}}
						{{#if this.pm}}	
						<div class="tab-pane" id="appKpis">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-area-chart right-10"></i><xsl:value-of select="eas:i18n('Application KPIs')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-area-chart right-10"></i><xsl:value-of select="eas:i18n('Application KPIs')"/></h3>
								 
									{{#each this.perfsGrp}}
										<div class="perfBox">
											<div class="impact bottom-10">
												{{#getCat this.key}}{{/getCat}}
											</div>
											{{#each this.values}} 
												{{#each this.serviceQuals}}
													<div class="bottom-5">
														<div class="right-5">
															<xsl:attribute name="class">{{#getSQVBox this.score}}{{/getSQVBox}}</xsl:attribute>
															<span>{{this.score}}</span>
														</div>	
														<span>{{this.serviceName}}</span>
													</div>
												{{/each}} 
											{{/each}}
										</div>
									{{/each}}
								</div>
							</div>
						</div>
						{{/if}}
						{{#if this.issues}}
						<div class="tab-pane" id="issues">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-warning right-10"></i> <xsl:value-of select="eas:i18n('Issues')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-fw fa-warning right-10"></i> <xsl:value-of select="eas:i18n('Issues')"/></h3>
									<div class="issuebox-wrapper">
									{{#each this.issues}}
										<div class="issueBox bg-offwhite">
					  						<b><xsl:value-of select="eas:i18n('Issue')"/>:</b><xsl:text> </xsl:text> {{this.name}} <br/>
											<b><xsl:value-of select="eas:i18n('Description')"/>:</b><xsl:text> </xsl:text> {{this.description}}<br/>
											<div class="issueStatus"><span class="label label-info" style="background-color: #476ecc">{{this.status}}</span></div>
										</div>
									{{/each}}
									</div>
					  			</div>
							</div>
						</div>
						{{/if}}
						{{#if this.plans}}	
						<div class="tab-pane" id="appPlans">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-check-circle-o right-10"></i> <xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></h2>
<div class="parent-superflex">
  <div class="superflex">
    <h3 class="text-primary"><i class="fa fa-check-circle-o"></i><span><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></span></h3>
    <p class="ess-soft"><xsl:value-of select="eas:i18n('Plans and projects that impact this application')"/></p>

    {{#if this.plans}}
    <div class="ess-section-title"><i class="fa fa-map"></i><span><xsl:value-of select="eas:i18n('Plans')"/></span></div>
    <div class="ess-card-grid">
      {{#each this.plans}}
      <div class="ess-card">
        <div class="title">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
        <div class="ess-row">
          <span class="ess-chip primary"><i class="fa fa-play"></i>
            {{#if this.validStartDate}}{{#formatDate this.validStartDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
          </span>
          <span class="ess-chip primary"><i class="fa fa-flag-checkered"></i>
            {{#if this.validEndDate}}{{#formatDate this.validEndDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
          </span>
        </div>
      </div>
      {{/each}}
    </div>
    {{/if}}

    {{#if this.aprplans}}
    <div class="ess-section-title" style="margin-top:14px"><i class="fa fa-map-signs"></i><span><xsl:value-of select="eas:i18n('Plans (via Roles)')"/></span></div>
    <div class="ess-card-grid">
      {{#each this.aprplans}}
      <div class="ess-card">
        <div class="title">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
        <div class="ess-row">
          <span class="ess-chip primary"><i class="fa fa-play"></i>
            {{#if this.validStartDate}}{{#formatDate this.validStartDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
          </span>
          <span class="ess-chip primary"><i class="fa fa-flag-checkered"></i>
            {{#if this.validEndDate}}{{#formatDate this.validEndDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
          </span>
        </div>
      </div>
      {{/each}}
    </div>
    {{/if}}

    {{#if this.projects}}
    <div class="ess-section-title" style="margin-top:14px"><i class="fa fa-cubes"></i><span><xsl:value-of select="eas:i18n('Projects')"/></span></div>
    <div class="panel-group ess-accordion" id="accordionProjects">
      {{#each this.projects}}
      <div class="panel panel-default">
        <div class="panel-heading">
          <h4 class="panel-title">
            <span class="label label-primary"><xsl:value-of select="eas:i18n('Project')"/></span>
            <strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>
            <a data-toggle="collapse" data-parent="#accordionProjects">
              <xsl:attribute name="href">#proj{{@index}}</xsl:attribute>
              <span class="ess-chip muted"><i class="fa fa-info-circle"></i><xsl:value-of select="eas:i18n('More Information')"/></span>
            </a>
          </h4>
          <div class="ess-row" style="margin-top:.4rem">
            <span class="ess-chip"><i class="fa fa-calendar-o"></i><xsl:value-of select="eas:i18n('Proposed Start')"/>:
              {{#if this.proposedStartDate}}{{#formatDate this.proposedStartDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
            <span class="ess-chip"><i class="fa fa-calendar"></i><xsl:value-of select="eas:i18n('Actual Start')"/>:
              {{#if this.actualStartDate}}{{#formatDate this.actualStartDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
            <span class="ess-chip"><i class="fa fa-flag"></i><xsl:value-of select="eas:i18n('Target End')"/>:
              {{#if this.targetEndDate}}{{#formatDate this.targetEndDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
            <span class="ess-chip"><i class="fa fa-hourglass-end"></i><xsl:value-of select="eas:i18n('Forecast End')"/>:
              {{#if this.forecastEndDate}}{{#formatDate this.forecastEndDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
          </div>
          <div class="ess-row">
            <span class="ess-chip muted"><xsl:value-of select="eas:i18n('Approval Status')"/>:
              {{#if this.approvalStatus}}<span>{{this.approvalStatus}}</span>{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
            <span class="ess-chip {{#ifEquals this.priority 'High'}}danger{{else}}{{#ifEquals this.priority 'Medium'}}warn{{else}}success{{/ifEquals}}{{/ifEquals}}">
              <xsl:value-of select="eas:i18n('Priority')"/>: {{#if this.priority}}{{this.priority}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
            <span class="ess-chip muted"><xsl:value-of select="eas:i18n('Lifecycle Status')"/>:
              {{#if this.lifecycleStatus}}<span>{{this.lifecycleStatus}}</span>{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}
            </span>
          </div>
        </div>
        <div class="panel-collapse collapse"><xsl:attribute name="id">proj{{@index}}</xsl:attribute>
          <div class="panel-body">
            <div class="ess-row">
              <span class="ess-chip muted"><xsl:value-of select="eas:i18n('EA Reference')"/>: {{#if this.ea_reference}}{{this.ea_reference}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
              <span class="ess-chip muted"><xsl:value-of select="eas:i18n('Parent Programme')"/>: {{#if this.programmeName}}{{this.programmeName}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
            </div>
            <div class="ess-spacer"></div>
            <div>
              <span class="label label-default"><xsl:value-of select="eas:i18n('Description')"/></span>
              <span class="text-muted"> {{#if this.description}}{{this.description}}{{else}}<xsl:value-of select="eas:i18n('Not Set')"/>{{/if}}</span>
            </div>
          </div>
        </div>
      </div>
      {{/each}}
    </div>
    {{/if}}
  </div>

  <div class="col-xs-12"/>

  <div class="superflex">
    <div class="ess-section-title"><i class="fa fa-cogs"></i><span><xsl:value-of select="eas:i18n('Impacts')"/></span></div>
    <p class="ess-soft"><xsl:value-of select="eas:i18n('Projects impacting this application and actions they are taking on this application')"/></p>

    {{#if this.projectElements}}
      {{#each this.projectElements}}
      <div class="ess-row">
        <span class="ess-chip success"><i class="fa fa-map"></i><xsl:value-of select="eas:i18n('Plan')"/></span>
        {{#essRenderInstanceMenuLink this.planInfo}}{{/essRenderInstanceMenuLink}}
      </div>
      <div class="ess-row">
        <span class="ess-chip primary"><i class="fa fa-cube"></i><xsl:value-of select="eas:i18n('Project')"/></span>
        {{#essRenderInstanceMenuLink this.projectInfo}}{{/essRenderInstanceMenuLink}}
      </div>
      <div class="ess-row">
        <span class="ess-chip"><xsl:value-of select="eas:i18n('Proposed Start')"/>: {{#if this.projForeStart}}{{#formatDate this.projForeStart}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
        <span class="ess-chip"><xsl:value-of select="eas:i18n('Actual Start')"/>: {{#if this.projActStart}}{{#formatDate this.projActStart}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
        <span class="ess-chip"><xsl:value-of select="eas:i18n('Target End')"/>: {{#if this.projTargEnd}}{{#formatDate this.projTargEnd}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
        <span class="ess-chip"><xsl:value-of select="eas:i18n('Forecast End')"/>: {{#if this.projForeEnd}}{{#formatDate this.projForeEnd}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
      </div>
      <div class="ess-row">
        <span class="ess-chip warn"><xsl:value-of select="eas:i18n('Action')"/></span>
        <span class="ess-chip" style="border-color:transparent"><xsl:attribute name="style">color:{{this.textColour}};background-color:{{this.colour}};border-color:transparent</xsl:attribute>{{this.action}}</span>
      </div>
      <hr/>
      {{/each}}
    {{else}}
      {{#if this.aprprojectElements}}
        {{#each this.aprprojectElements}}
        <div class="ess-row">
          <span class="ess-chip success"><xsl:value-of select="eas:i18n('Plan')"/></span> {{#essRenderInstanceMenuLink this.planInfo}}{{/essRenderInstanceMenuLink}}
        </div>
        <div class="ess-row">
          <span class="ess-chip primary"><xsl:value-of select="eas:i18n('Project')"/></span> {{#essRenderInstanceMenuLink this.projectInfo}}{{/essRenderInstanceMenuLink}}
        </div>
        <div class="ess-row">
          <span class="ess-chip"><xsl:value-of select="eas:i18n('Proposed Start')"/>: {{#if this.proposedStartDate}}{{#formatDate this.proposedStartDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
          <span class="ess-chip"><xsl:value-of select="eas:i18n('Actual Start')"/>: {{#if this.actualStartDate}}{{#formatDate this.actualStartDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
          <span class="ess-chip"><xsl:value-of select="eas:i18n('Target End')"/>: {{#if this.targetEndDate}}{{#formatDate this.targetEndDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
          <span class="ess-chip"><xsl:value-of select="eas:i18n('Forecast End')"/>: {{#if this.forecastEndDate}}{{#formatDate this.forecastEndDate}}{{/formatDate}}{{else}}<span class="text-muted"><xsl:value-of select="eas:i18n('Not Set')"/></span>{{/if}}</span>
        </div>
        <div class="ess-row">
          <span class="ess-chip warn"><xsl:value-of select="eas:i18n('Action')"/></span>
          <span class="ess-chip" style="border-color:transparent"><xsl:attribute name="style">color:{{this.textColour}};background-color:{{this.colour}};border-color:transparent</xsl:attribute>{{this.apraction}}</span>
        </div>
        <hr/>
        {{/each}}
      {{else}}
        <strong><xsl:value-of select="eas:i18n('No impacts recorded')"/></strong>
      {{/if}}
    {{/if}}
  </div>
</div>
						</div>
						{{/if}}
						{{#if this.otherEnums}}
						<div class="tab-pane" id="otherEnums">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-comment right-10"></i> <xsl:value-of select="eas:i18n('Other')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-comment right-10"></i><xsl:value-of select="eas:i18n('Other')"/></h3>
									<p><xsl:value-of select="eas:i18n('Other values against this application')"/></p>
									{{#each this.otherEnums}}
									{{#ifEquals this.classNm 'distribute costs'}}
									
										{{#ifEquals ../this.otherEnums.length 1}}
											<b><xsl:value-of select="eas:i18n('No additional enumerations set')"/></b>
										{{/ifEquals}}
									{{else}}
									 
									<div class="bottom-10">
										<label>{{this.classNm}}</label>
										{{#ifEquals this.name 'True'}}
												<i class="fa fa-check-circle" style="color:green"></i>
												{{else}}
												{{#ifEquals this.name 'False'}}
												<i class="fa fa-times-circle" style="color:red"></i>
												{{else}}
											 
												<span class="label label-default">
													<xsl:attribute name="style">
														{{#if this.backgroundColor}}background-color:{{this.backgroundColor}};{{/if}}{{#if this.colour}}color:{{this.colour}};{{/if}}
													</xsl:attribute>
														{{this.name}}
												</span>
											{{/ifEquals}}
										{{/ifEquals}}		
									</div>
									{{/ifEquals}}
									{{/each}}		
								 											
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
						<div class="tab-pane" id="appdata">			
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application Data')"/></h3>
									<ul class="nav nav-tabs">
										<li class="active"><a data-toggle="tab" href="#appdatausage"><xsl:value-of select="eas:i18n('Data Usage')"/></a></li>
									{{#if this.requiredData}}	<li><a data-toggle="tab" href="#appdatarequired"><xsl:value-of select="eas:i18n('Data Required')"/></a></li> {{/if}}
									  </ul>
									  
									  <div class="tab-content">
										<div id="appdatausage" class="tab-pane fade in active">
											<h4><xsl:value-of select="eas:i18n('Data Usage')"/></h4>

											<div class="bottom-15">
												<label><xsl:value-of select="eas:i18n('Data Object')"/>:</label><select class="filters" id="doFilter"><option name="all" value="all"><xsl:value-of select="eas:i18n('All')"/></option></select>
			
												<span class="classificationFilter left-30">
													<label><xsl:value-of select="eas:i18n('Classification')"/>:</label><select class="filters classificationFilter" id="classificationFilter"><option name="all" value="all"><xsl:value-of select="eas:i18n('All')"/></option></select>
												</span>
											</div>
											<div class="clearfix"/>
											<div class="dataCardWrapper">
												{{#each thisAppArray}}
												<div class="dataCard bg-offwhite">
														<xsl:attribute name="doid">{{this.dataObjectId}}</xsl:attribute>
														<xsl:attribute name="classifid">{{#each this.classifications}}{{this.id}}{{/each}}</xsl:attribute> 
														<!--<span class="leadText">Data Object</span>:<strong>{{this.dataObject}}</strong>-->
														<div class="large impact bottom-5">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
														{{#each this.values}}
														<div class="appCard2">
															<xsl:attribute name="irid">{{this.idirep}}</xsl:attribute>
															<div class="bottom-5"><strong><xsl:value-of select="eas:i18n('Appears in')"/>: </strong><span class="label label-link bg-darkgrey">{{#essRenderInstanceMenuLink this.irInfo}}{{/essRenderInstanceMenuLink}}</span></div>
															{{#if this.datarepsimplemented}}
															<span class="dbicon">{{this.category}}</span>
														
															<span class="appTableHeader"><strong><xsl:value-of select="eas:i18n('Where')"/>:</strong></span><br/>
															
															{{#each this.datarepsimplemented}}
															<div class="datatype"><span class="appTableHeader">{{#getDataRep this.dataRepid}}{{/getDataRep}}</span> </div>
															<div class="datacrud">
																<div class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</div>
																<div class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</div>
																<div class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</div>
																<div class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
															</div>
															<div class="clearfix"/>
															{{/each}}
															{{else}}
															 
															<div class="datacrud">
																<div class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</div>
																<div class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</div>
																<div class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</div>
																<div class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
															</div>
															{{/if}}		
														</div>
													{{/each}}
													<div class="classiflistBox">
														{{#each this.classifications}}<div class="classiflist"><span class="label label-info">{{this.name}}</span></div>{{/each}}
														</div>
													</div>
												{{/each}}
											</div>
										</div>
										<div id="appdatarequired" class="tab-pane fade">
										<h4><xsl:value-of select="eas:i18n('Data Required')"/></h4>
										<p><xsl:value-of select="eas:i18n('Data the application requires')"/></p>
											
											{{#each requiredData}}
												<span class="label label-info lbl-lrg">{{this.name}}</span>
											{{/each}}
										</div>
									  </div>
								</div>
							</div>
						</div> 
						<div class="tab-pane" id="diagrams">
						<div class="parent-superflex">
							<div class="superflex">
								<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Diagrams')"/></h3>
								<div class="clearfix"/>
								<select id="appDiagrams"><option>Choose</option></select>
								<div id="paper-container"/>
							</div>
						</div>
						</div> 
						{{#if this.documents}}
						<div class="tab-pane" id="documents">
						<div class="parent-superflex">
							<div class="superflex">
								<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Documentation')"/></h3>
								<div class="clearfix"/>
								
								{{#each this.documents}}
									{{#ifEquals this.key 'undefined'}}{{else}}<strong>{{this.key}}</strong><div class="clearfix"/>{{/ifEquals}}
								<div class="doc-link-wrapper top-10">
									{{#each this.values}}
									<div class="doc-link-blob bdr-left-blue">
										<div class="doc-link-icon"><i class="fa fa-file-o"></i></div>
										<div>
											<div class="doc-link-label">
												<a target="_blank">
													<xsl:attribute name="href">{{this.documentLink}}</xsl:attribute>
													{{this.name}}&#160;<i class="fa fa-external-link"></i>
												</a>
											</div>
											<div class="doc-description">{{this.description}}</div>
										</div>
									</div>
									{{/each}}
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
	<script id="costTotal-template" type="text/x-handlebars-template">
		<div class="cost-dashboard-header">
			<div class="cost-header-info">
				<h3 class="cost-heading"><i class="fa fa-money right-10"></i><xsl:value-of select="eas:i18n('Cost Overview')"/></h3>
				<p class="cost-subheading">
					<xsl:value-of select="eas:i18n('Converted to')"/> <span id="costCurrencyLabel" class="cost-pill">{{this.currency}}</span>
					<xsl:text> · </xsl:text>
					<span id="costPeriodLabel">{{this.period}}</span>
				</p>
			</div>
			<div class="cost-controls">
				<label class="cost-control-label" for="ccySelect"><xsl:value-of select="eas:i18n('Currency')"/></label>
				<select id="ccySelect" class="cost-currency-select">
					<option value=""><xsl:value-of select="eas:i18n('Select')"/></option>
				</select>
			</div>
		</div>

		<div class="cost-summary-grid">
			<div class="cost-summary-card accent">
				<div class="cost-summary-label" id="annualCostLabel">{{#if this.inScopeOnly}}<xsl:value-of select="eas:i18n('Actual Regular Annual Cost')"/>{{else}}<xsl:value-of select="eas:i18n('Annualised Regular Annual Cost')"/>{{/if}}</div>
				<div class="cost-summary-value" id="regAnnual">{{this.annualCost}}</div>
			</div>
			<div class="cost-summary-card accent">
				<div class="cost-summary-label" id="monthlyCostLabel">{{#if this.inScopeOnly}}<xsl:value-of select="eas:i18n('Actual Regular Monthly Cost')"/>{{else}}<xsl:value-of select="eas:i18n('Annualised Regular Monthly Cost')"/>{{/if}}</div>
				<div class="cost-summary-value" id="regMonthly">{{this.monthlyCost}}</div>
				<div class="cost-summary-meta">
					<!--
					<span id="costLatestMonthly">{{this.latestMonthly}}</span>
					<span id="costTrend" class="cost-trend {{#if this.trend}}{{this.trend.direction}}{{else}}hidden{{/if}}">
						<i id="costTrendIcon" class="fa {{#if this.trend}}{{this.trend.icon}}{{else}}fa-minus{{/if}}"></i>
						<span id="costTrendLabel">{{#if this.trend}}{{this.trend.label}}{{/if}}</span>
					</span>
					-->
				</div>
			</div>
			{{#if this.adhocCost}}
			<div class="cost-summary-card subtle" id="costAdhocCard">
				<div class="cost-summary-label"><xsl:value-of select="eas:i18n('Adhoc Spend in Period')"/></div>
				<div class="cost-summary-value" id="costAdhoc">{{this.adhocCost}}</div>
				<div class="cost-summary-meta"><xsl:value-of select="eas:i18n('One-off items included')"/></div>
			</div>
			{{/if}}
		</div>

		<div class="cost-analytics-grid">
			<div class="cost-analytics-card wide">
				<div class="cost-card-head">
					<span><xsl:value-of select="eas:i18n('Monthly Trend')"/></span>
					<div class="in-scope-toggle" title="When ON, chart shows 'Actual' costs for active dates. When OFF, shows 'Annualised' full target amounts.">
						<span><xsl:value-of select="eas:i18n('Annual/Actual Mode')"/></span>
						<label class="switch">
							{{#if this.inScopeOnly}}
								<input type="checkbox" id="inScopeToggle" checked="checked"/>
							{{else}}
								<input type="checkbox" id="inScopeToggle"/>
							{{/if}}
							<span class="slider"></span>
						</label>
					</div>
				</div>
				<canvas id="costByMonth-chart"></canvas>
			</div>
			<div class="cost-analytics-card">
				<div class="cost-card-head"><xsl:value-of select="eas:i18n('By Category')"/></div>
				<canvas id="costByCategory-chart"></canvas>
			</div> 
			<div class="cost-analytics-card">
				<div class="cost-card-head"><xsl:value-of select="eas:i18n('By Type')"/></div>
				<canvas id="costByType-chart"></canvas>
			</div>
			<div class="cost-analytics-card">
				<div class="cost-card-head"><xsl:value-of select="eas:i18n('By Frequency')"/></div>
				<canvas id="costByFrequency-chart"></canvas>
			</div>
			<div class="cost-analytics-card">
				<div class="cost-card-head"><xsl:value-of select="eas:i18n('Top Cost Drivers')"/></div>
				<ul class="cost-top-list" id="costTopList">
					{{#if this.topCosts.length}}
						{{#each this.topCosts}}
							<li>
								<div class="cost-top-line">
									<span class="cost-top-name">{{this.label}}</span>
									<span class="cost-top-value">{{this.annual}}</span>
								</div>
								<div class="cost-top-sub">
									{{this.monthly}} <xsl:value-of select="eas:i18n('per month')"/>
								</div>
							</li>
						{{/each}}
					{{else}}
						<li class="cost-top-empty"><xsl:value-of select="eas:i18n('No cost drivers captured yet')"/></li>
					{{/if}}
				</ul>
			</div>
		</div>
	</script>
	<style type="text/css" id="cost-dashboard-styles">
		.cost-dashboard {
			display: flex;
			flex-direction: column;
			gap: 2.5rem;
		}
		.cost-dashboard-header {
			display: flex;
			flex-wrap: wrap;
			justify-content: space-between;
			align-items: flex-end;
			gap: 1.5rem;
			margin-bottom: 1.5rem;
		}
		
		/* In-Scope Toggle Styles */
		.cost-card-head {
			display: flex;
			justify-content: space-between;
			align-items: center;
		}
		.in-scope-toggle {
			display: flex;
			align-items: center;
			gap: 8px;
			font-size: 11px;
			font-weight: 500;
			text-transform: none;
			color: #666;
		}
		.switch {
			position: relative;
			display: inline-block;
			width: 32px;
			height: 18px;
		}
		.switch input { 
			opacity: 0;
			width: 0;
			height: 0;
		}
		.slider {
			position: absolute;
			cursor: pointer;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			background-color: #ccc;
			transition: .4s;
			border-radius: 18px;
		}
		.slider:before {
			position: absolute;
			content: "";
			height: 12px;
			width: 12px;
			left: 3px;
			bottom: 3px;
			background-color: white;
			transition: .4s;
			border-radius: 50%;
		}
		input:checked + .slider {
			background-color: #3d3988;
		}
		input:checked + .slider:before {
			transform: translateX(14px);
		}
		.cost-heading {
			margin: 0;
			font-weight: 600;
			font-size: 1.6rem;
		}
		.cost-subheading {
			margin: 0.25rem 0 0;
			color: #6c757d;
			font-size: 0.95rem;
		}
		.cost-pill {
			display: inline-flex;
			align-items: center;
			padding: 0.2rem 0.6rem;
			background: #f1f4ff;
			border-radius: 999px;
			font-weight: 600;
			color: #2f54eb;
		}
		.cost-controls {
			display: flex;
			flex-direction: column;
			gap: 0.35rem;
			min-width: 200px;
		}
		.cost-controls .select2-container {
			width: 100% !important;
		}
		.cost-control-label {
			font-size: 0.85rem;
			text-transform: uppercase;
			letter-spacing: 0.08em;
			color: #6c757d;
			margin: 0;
		}
		.cost-currency-select {
			width: 100%;
			border-radius: 10px;
			border: 1px solid #d9dee7;
			padding: 0.55rem 0.75rem;
		}
		.cost-summary-grid {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
			gap: 1.25rem;
			margin-bottom: 2rem;
		}
		.cost-summary-card {
			background: #ffffff;
			border-radius: 16px;
			padding: 1.4rem 1.6rem;
			box-shadow: 0 20px 40px rgba(28, 51, 84, 0.08);
			display: flex;
			flex-direction: column;
			gap: 0.6rem;
			position: relative;
			overflow: hidden;
		}
		.cost-summary-card.accent::after {
			content: "";
			position: absolute;
			inset: 0;
			background: linear-gradient(135deg, rgba(47, 84, 235, 0.08), rgba(111, 207, 151, 0.08));
			z-index: 0;
		}
		.cost-summary-card.subtle {
			background: linear-gradient(135deg, rgba(255, 245, 233, 0.65), rgba(255, 255, 255, 0.9));
		}
		.cost-summary-card > * {
			position: relative;
			z-index: 1;
		}
		.cost-summary-label {
			font-size: 0.85rem;
			letter-spacing: 0.04em;
			text-transform: uppercase;
			color: #6c757d;
		}
		.cost-summary-value {
			font-size: 2rem;
			font-weight: 700;
			color: #1c3354;
		}
		.cost-summary-meta {
			font-size: 0.85rem;
			color: #6c757d;
			display: flex;
			align-items: center;
			gap: 0.65rem;
		}
		.cost-trend {
			display: inline-flex;
			align-items: center;
			gap: 0.3rem;
			padding: 0.2rem 0.55rem;
			border-radius: 999px;
			font-weight: 600;
		}
		.cost-trend.hidden {
			display: none;
		}
		.cost-trend.up {
			background: rgba(47, 197, 123, 0.12);
			color: #16803c;
		}
		.cost-trend.down {
			background: rgba(240, 71, 71, 0.12);
			color: #a32020;
		}
		.cost-analytics-grid {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
			gap: 1.5rem;
			margin-bottom: 2rem;
		}
		.cost-analytics-card {
			background: #ffffff;
			border-radius: 18px;
			padding: 1.2rem 1.4rem;
			box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
			display: flex;
			flex-direction: column;
			gap: 0.75rem;
		}
		.cost-analytics-card canvas {
			width: 100% !important;
			height: 260px !important;
		}
		.cost-analytics-card.wide {
			grid-column: span 2;
		}
		@media (max-width: 992px) {
			.cost-analytics-card.wide {
				grid-column: span 1;
			}
		}
		.cost-card-head {
			font-size: 0.95rem;
			font-weight: 600;
			text-transform: uppercase;
			letter-spacing: 0.08em;
			color: #6c757d;
		}
		.cost-top-list {
			list-style: none;
			padding: 0;
			margin: 0;
			display: flex;
			flex-direction: column;
			gap: 0.8rem;
		}
		.cost-top-line {
			display: flex;
			justify-content: space-between;
			align-items: center;
			font-weight: 600;
			color: #1c3354;
		}
		.cost-top-name {
			flex: 1;
			margin-right: 1rem;
		}
		.cost-top-value {
			font-variant-numeric: tabular-nums;
		}
		.cost-top-sub {
			font-size: 0.8rem;
			color: #6c757d;
		}
		.cost-top-empty {
			color: #9aa5b1;
			font-style: italic;
		}
		.cost-table-card {
			background: #ffffff;
			border-radius: 18px;
			padding: 1.5rem;
			box-shadow: 0 15px 35px rgba(15, 23, 42, 0.08);
		}
		.cost-table-card h3 {
			margin-top: 0;
			font-weight: 600;
		}
	</style>
	<script id="kpiWord-template" type="text/x-handlebars-template">
		[{{#each this.perfsGrp}} 
			{{#each this.values}} 
					{"header":"KPI - {{../this.name}}",
					"level":1,
					"intro":"{{this.date}}",
					"type":"bullets",
					"content":[{{#each this.serviceQuals}}
					"{{this.serviceName}} - {{this.score}}"{{#unless @last}},{{/unless}}{{/each}}]}{{#unless @last}},{{/unless}}
				{{/each}}{{#unless @last}},{{/unless}}
		{{/each}}]
	</script>
	<script id="techWord-template" type="text/x-handlebars-template">	
		[{{#each this.environments}}
			{{#ifEquals @index 0}} 
			{"header":"Application Technology",
			"level":1,
			"intro":"{{this.name}}",
			"type":"table",
			"headings":["Product","Component"],
			"content":[{{#each this.products}}{"prod":"{{prodname}}","comp":"{{compname}}"}{{#unless @last}},{{/unless}}{{/each}}]}{{#unless @last}},{{/unless}}
		{{else}}
			{"header":" ",
			"level":1,
			"intro":"{{this.name}}",
			"type":"table",
			"headings":["Product","Component"],
			"content":[{{#each this.products}}{"prod":"{{prodname}}","comp":"{{compname}}"}{{#unless @last}},{{/unless}}{{/each}}]}{{#unless @last}},{{/unless}}
		{{/ifEquals}}
		{{/each}}]
	</script>		
	<script id="select-template" type="text/x-handlebars-template"> 
		 
		<xsl:text> </xsl:text>{{#essRenderInstanceLinkSelect this}}{{/essRenderInstanceLinkSelect}}       
		 
		</script>
	<xsl:call-template name="wordHandlebars"/>
		</html>
	</xsl:template>  

	<xsl:template name="RenderViewerAPIJSFunction"> 
			<xsl:param name="viewerAPIPathApps"></xsl:param>  
			<xsl:param name="viewerAPIPathDO"></xsl:param>
			<xsl:param name="viewerAPIPathOrgs"></xsl:param>
			<xsl:param name="viewerAPIPathMart"></xsl:param>
			<xsl:param name="viewerAPIPathCost"></xsl:param>
			<xsl:param name="viewerAPIPathLifecycle"></xsl:param>
			<xsl:param name="viewerAPIPathkpi"></xsl:param>
			<xsl:param name="viewerAPIPathPhysProc"></xsl:param>
			<xsl:param name="viewerAPIPathPlans"></xsl:param>
			<xsl:param name="viewerAPIPathTech"></xsl:param>
			<xsl:param name="viewerAPIPathBusCap"></xsl:param> 
			<xsl:param name="viewerAPIPathInstance"></xsl:param> 
			
			<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>		
			//a global variable that holds the data returned by an Viewer API Report 
			var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';  
			var viewAPIDataDO = '<xsl:value-of select="$viewerAPIPathDO"/>';  
			var viewAPIDataOrgs = '<xsl:value-of select="$viewerAPIPathOrgs"/>';  
			var viewAPIDataMart = '<xsl:value-of select="$viewerAPIPathMart"/>';   
			var viewAPIDataLifecycles = '<xsl:value-of select="$viewerAPIPathLifecycle"/>'; 
			var viewAPIDataKpi = '<xsl:value-of select="$viewerAPIPathkpi"/>'; 
			var viewAPIDataPhysProcs = '<xsl:value-of select="$viewerAPIPathPhysProc"/>';
			var viewAPIDataPlans = '<xsl:value-of select="$viewerAPIPathPlans"/>';
			var viewAPIDataTech = '<xsl:value-of select="$viewerAPIPathTech"/>';
			var viewAPIDataCapMart = '<xsl:value-of select="$viewerAPIPathBusCap"/>'; 
			
		

<xsl:call-template name="ciaData"/>
<xsl:call-template name="applicationCostData"/>
var rid="<xsl:value-of select="$overallCurrencyDefault/own_slot_value[slot_reference='report_constant_ea_elements']/value"/>"
 
var rcCcyId= {ccyCode: "<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_code']/value"/>", ccySymbol: "<xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/>", ccyName: "<xsl:value-of select="$currency/own_slot_value[slot_reference='name']/value"/>", ccyId: "<xsl:value-of select="$currency/name"/>"};
var dynamicAppFilterDefs=[];
if(rcCcyId.ccyCode==''){
	rcCcyId= {ccyCode: "USD", ccySymbol: "$", ccyName: "Dollar"}

}
var defaultCurrency    

const MS_PER_DAY = 24 * 60 * 60 * 1000;
const BASE_CURRENCY_FALLBACK = 'GBP';
const COST_FREQUENCY_MAP = {
	'Annual_Cost_Component': 'annual',
	'Quarterly_Cost_Component': 'quarterly',
	'Monthly_Cost_Component': 'monthly',
	'Adhoc_Cost_Component': 'adhoc'
};
const FREQUENCY_LABELS = {
	annual: 'Annual',
	quarterly: 'Quarterly',
	monthly: 'Monthly',
	adhoc: 'Adhoc'
};

const toNumber = (value) => {
	if (value === null || value === undefined) return 0;
	if (typeof value === 'number') {
		return Number.isFinite(value) ? value : 0;
	}
	const parsed = parseFloat(value);
	return Number.isFinite(parsed) ? parsed : 0;
};

const toMinorUnits = (value) => Math.round(toNumber(value) * 100);
const minorToNumber = (minor) => minor / 100;

function round2(value) {
	return Math.round((Number(value) + Number.EPSILON) * 100) / 100;
}

function parseExchangeRate(value) {
	if (value === null || value === undefined || value === '') {
		return NaN;
	}
	if (typeof value === 'number') {
		return Number.isFinite(value) ? value : NaN;
	}
	let normalised = String(value).trim();
	if (!normalised) {
		return NaN;
	}
	normalised = normalised.replace(/\s+/g, '');
	if (normalised.includes(',') &amp;&amp; !normalised.includes('.')) {
		normalised = normalised.replace(',', '.');
	} else {
		normalised = normalised.replace(/,/g, '');
	}
	const parsed = parseFloat(normalised);
	return Number.isFinite(parsed) ? parsed : NaN;
}

function parseISODateUtc(value) {
	if (!value) {
		return null;
	}
	if (value instanceof Date &amp;&amp; !Number.isNaN(value.getTime())) {
		return new Date(Date.UTC(value.getUTCFullYear(), value.getUTCMonth(), value.getUTCDate()));
	}
	const date = new Date(value);
	if (Number.isNaN(date.getTime())) {
		return null;
	}
	return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
}

const isValidDate = (date) => date instanceof Date &amp;&amp; !Number.isNaN(date.getTime());

function daysBetweenInclusive(start, end) {
	if (!isValidDate(start) || !isValidDate(end) || end &lt; start) {
		return 0;
	}
	return Math.floor((end.getTime() - start.getTime()) / MS_PER_DAY) + 1;
}

function calculateOverlapDays(startA, endA, startB, endB) {
	if (!isValidDate(startA) || !isValidDate(endA) || !isValidDate(startB) || !isValidDate(endB)) {
		return 0;
	}
	const effectiveStart = startA > startB ? startA : startB;
	const effectiveEnd = endA &lt; endB ? endA : endB;
	return daysBetweenInclusive(effectiveStart, effectiveEnd);
}

function getCurrentYearPeriod() {
	const today = new Date();
	const year = today.getUTCFullYear();
	const start = new Date(Date.UTC(year, 0, 1));
	const end = new Date(Date.UTC(year, 11, 31));
	return { start, end };
}

function formatIsoDate(date) {
	return isValidDate(date) ? date.toISOString().slice(0, 10) : undefined;
}

function getProrationDetails(start, end, periodStart, periodEnd) {
	const startDate = parseISODateUtc(start);
	const endDate = parseISODateUtc(end);
	const periodDays = daysBetweenInclusive(periodStart, periodEnd);
	if (!periodDays) {
		return {
			factor: 0,
			overlapDays: 0,
			periodDays: 0,
			effectiveStart: null,
			effectiveEnd: null
		};
	}
	if (startDate &amp;&amp; endDate &amp;&amp; endDate &lt; startDate) {
		return {
			factor: 0,
			overlapDays: 0,
			periodDays,
			effectiveStart: null,
			effectiveEnd: null
		};
	}
	const effectiveStart = (startDate &amp;&amp; startDate > periodStart) ? startDate : periodStart;
	const effectiveEndCandidate = (endDate &amp;&amp; endDate &lt; periodEnd) ? endDate : periodEnd;
	if (effectiveEndCandidate &lt; effectiveStart) {
		return {
			factor: 0,
			overlapDays: 0,
			periodDays,
			effectiveStart: null,
			effectiveEnd: null
		};
	}
	const effectiveEnd = effectiveEndCandidate;
	const overlapDays = daysBetweenInclusive(effectiveStart, effectiveEnd);
	return {
		factor: overlapDays / periodDays,
		overlapDays,
		periodDays,
		effectiveStart,
		effectiveEnd
	};
}

function getProrationFactor(start, end, periodStart, periodEnd) {
	return getProrationDetails(start, end, periodStart, periodEnd).factor;
}

function normaliseAnnualMinor(amountMinor, frequency) {
	switch (frequency) {
		case 'annual':
			return amountMinor;
		case 'quarterly':
			return amountMinor * 4;
		case 'monthly':
			return amountMinor * 12;
		case 'adhoc':
			return 0;
		default:
			throw new Error(`Unknown frequency '${frequency}'`);
	}
}

function convertMinorCurrency(amountMinor, fromCurrency, toCurrency, exchangeRates, baseCurrency) {
	const from = fromCurrency || baseCurrency;
	const to = toCurrency || baseCurrency;
	if (from === to) {
		return amountMinor;
	}
	const fromRate = exchangeRates[from];
	const toRate = exchangeRates[to];
	if (!Number.isFinite(fromRate) || fromRate &lt;= 0 || !Number.isFinite(toRate) || toRate &lt;= 0) {
		const missing = [];
		if (!Number.isFinite(fromRate) || fromRate &lt;= 0) missing.push(from);
		if (!Number.isFinite(toRate) || toRate &lt;= 0) missing.push(to);
		throw new Error(`Missing exchange rate(s): ${missing.join(', ')}`);
	}
	const amountInBase = (amountMinor / 100) / fromRate;
	const amountInTarget = amountInBase * toRate;
	return Math.round(amountInTarget * 100);
}

function validateExchangeRates(costs, exchangeRates, baseCurrency, targetCurrency) {
	const required = new Set([baseCurrency, targetCurrency]);
	costs.forEach((cost) => {
		if (cost &amp;&amp; cost.currency) {
			required.add(cost.currency);
		}
	});
	const missing = [];
	required.forEach((code) => {
		const rate = exchangeRates[code];
		if (!Number.isFinite(rate) || rate &lt;= 0) {
			missing.push(code);
		}
	});
	if (missing.length > 0) {
		throw new Error(`Missing exchange rate(s): ${missing.join(', ')}`);
	}
}

function mapCostComponent(cost, fallbackCurrency) {
	if (!cost) {
		return null;
	}
	const frequency = COST_FREQUENCY_MAP[cost.costType];
	if (!frequency) {
		const identifier = cost.id || cost.name || 'unknown';
		throw new Error(`Unknown frequency '${cost.costType}' for cost '${identifier}'`);
	}
	const currency = cost.this_currency_code || cost.ccy_code || fallbackCurrency || BASE_CURRENCY_FALLBACK;
	return {
		id: cost.id || cost.name,
		amount: toNumber(cost.cost),
		frequency,
		currency,
		startDate: cost.fromDate || undefined,
		endDate: cost.toDate || undefined,
		meta: {
			category: cost.costCategory || 'Run Cost',
			typeLabel: cost.name || FREQUENCY_LABELS[frequency] || frequency,
			frequencyKey: cost.costType,
			raw: cost
		}
	};
}

function computeCostContribution(cost, config) {
	if (!cost) {
		return null;
	}
	const {
		exchangeRates,
		targetCurrency,
		baseCurrency,
		periodStart,
		periodEnd,
		includeAdhoc = false,
		inScopeOnly = true
	} = config;
	const amountMinor = toMinorUnits(cost.amount);
	const proration = getProrationDetails(cost.startDate, cost.endDate, periodStart, periodEnd);
	const overlaps = proration.overlapDays > 0;
	const isRecurring = cost.frequency !== 'adhoc';
	let annualMinorTarget = 0;
	let monthlyMinorTarget = 0;
	let adhocMinorTarget = 0;
	let included = false;

	if (isRecurring &amp;&amp; overlaps &amp;&amp; proration.periodDays > 0) {
		const annualMinor = normaliseAnnualMinor(amountMinor, cost.frequency);
		if (annualMinor !== 0) {
			const effectiveProration = inScopeOnly ? proration.factor : 1.0;
			const proratedMinor = Math.round(annualMinor * effectiveProration);
			annualMinorTarget = convertMinorCurrency(proratedMinor, cost.currency, targetCurrency, exchangeRates, baseCurrency);
			monthlyMinorTarget = Math.round(annualMinorTarget / 12);
		} else {
			annualMinorTarget = 0;
			monthlyMinorTarget = 0;
		}
		included = true;
	}

	if (!isRecurring) {
		if (includeAdhoc &amp;&amp; overlaps) {
			adhocMinorTarget = convertMinorCurrency(amountMinor, cost.currency, targetCurrency, exchangeRates, baseCurrency);
			included = true;
		} else {
			included = false;
		}
	}

	return {
		id: cost.id,
		frequency: cost.frequency,
		currency: cost.currency,
		annualMinorTarget,
		monthlyMinorTarget,
		adhocMinorTarget,
		included,
		overlaps,
		prorationFactor: inScopeOnly ? proration.factor : 1.0,
		overlapDays: inScopeOnly ? proration.overlapDays : proration.periodDays,
		periodDays: proration.periodDays,
		effectiveStart: inScopeOnly ? proration.effectiveStart : periodStart,
		effectiveEnd: inScopeOnly ? proration.effectiveEnd : periodEnd,
		meta: cost.meta,
		inScopeOnly
	};
}

function summariseCosts(costs, exchangeRates, options = {}) {
	const {
		targetCurrency,
		periodStart,
		periodEnd,
		includeAdhoc = false,
		inScopeOnly = true,
		baseCurrency: providedBaseCurrency
	} = options;
	const baseCurrency = providedBaseCurrency || BASE_CURRENCY_FALLBACK;
	const rates = Object.assign({}, exchangeRates);
	if (!Number.isFinite(rates[baseCurrency]) || rates[baseCurrency] &lt;= 0) {
		rates[baseCurrency] = 1;
	}
	const resolvedPeriod = (() => {
		const defaults = getCurrentYearPeriod();
		const start = periodStart ? parseISODateUtc(periodStart) : defaults.start;
		const end = periodEnd ? parseISODateUtc(periodEnd) : defaults.end;
		if (!isValidDate(start) || !isValidDate(end) || end &lt; start) {
			throw new Error('Invalid reporting period');
		}
		return { start, end };
	})();
	const target = targetCurrency || baseCurrency;

	validateExchangeRates(costs, rates, baseCurrency, target);

	const config = {
		exchangeRates: rates,
		targetCurrency: target,
		baseCurrency,
		periodStart: resolvedPeriod.start,
		periodEnd: resolvedPeriod.end,
		includeAdhoc,
		inScopeOnly
	};

	let totalAnnualMinor = 0;
	let totalAdhocMinor = 0;
	const breakdown = [];

	costs.forEach((cost) => {
		const contribution = computeCostContribution(cost, config);
		if (!contribution) {
			return;
		}
		if (contribution.frequency !== 'adhoc' &amp;&amp; contribution.included) {
			totalAnnualMinor += contribution.annualMinorTarget;
		}
		if (contribution.adhocMinorTarget) {
			totalAdhocMinor += contribution.adhocMinorTarget;
		}
		const monthlyMinor = (contribution.frequency !== 'adhoc')
			? Math.round(contribution.annualMinorTarget / 12)
			: 0;
		breakdown.push({
			id: contribution.id,
			annual: round2(minorToNumber(contribution.annualMinorTarget)),
			monthly: round2(minorToNumber(monthlyMinor)),
			included: contribution.frequency === 'adhoc'
				? (includeAdhoc &amp;&amp; contribution.adhocMinorTarget > 0)
				: contribution.included
		});
	});

	const totals = {
		annual: round2(minorToNumber(totalAnnualMinor)),
		monthly: round2(minorToNumber(Math.round(totalAnnualMinor / 12)))
	};
	if (includeAdhoc) {
		totals.adhoc = round2(minorToNumber(totalAdhocMinor));
	}

	return {
		currency: target,
		totals,
		breakdown
	};
}

function distributeMinorByOverlap(totalMinor, overlaps) {
	const allocations = new Array(overlaps.length).fill(0);
	if (!totalMinor) {
		return allocations;
	}
	const positiveDays = overlaps.map((days) => (days > 0 ? days : 0));
	const totalDays = positiveDays.reduce((sum, days) => sum + days, 0);
	if (!totalDays) {
		allocations[0] = totalMinor;
		return allocations;
	}
	const fractional = [];
	let assigned = 0;
	positiveDays.forEach((days, idx) => {
		if (!days) {
			fractional.push({ idx, remainder: 0 });
			return;
		}
		const exact = (totalMinor * days) / totalDays;
		const floored = Math.floor(exact);
		allocations[idx] = floored;
		assigned += floored;
		fractional.push({ idx, remainder: exact - floored });
	});
	let remainder = totalMinor - assigned;
	if (remainder > 0) {
		fractional.sort((a, b) => b.remainder - a.remainder);
		for (let i = 0; i &lt; fractional.length &amp;&amp; remainder > 0; i += 1) {
			const targetIndex = fractional[i].idx;
			if (positiveDays[targetIndex] > 0) {
				allocations[targetIndex] += 1;
				remainder -= 1;
			}
		}
	}
	return allocations;
}

function buildMonthlySeries(contributions, periodStart, periodEnd) {
	if (!isValidDate(periodStart) || !isValidDate(periodEnd) || periodEnd &lt; periodStart) {
		return { labels: [], minors: [], values: [] };
	}
	const months = [];
	const startCursor = new Date(Date.UTC(periodStart.getUTCFullYear(), periodStart.getUTCMonth(), 1));
	const endCursor = new Date(Date.UTC(periodEnd.getUTCFullYear(), periodEnd.getUTCMonth(), 1));
	for (let cursor = new Date(startCursor); cursor &lt;= endCursor; cursor = new Date(Date.UTC(cursor.getUTCFullYear(), cursor.getUTCMonth() + 1, 1))) {
		const monthStart = new Date(cursor);
		const monthEnd = new Date(Date.UTC(cursor.getUTCFullYear(), cursor.getUTCMonth() + 1, 0));
		const effectiveStart = monthStart &lt; periodStart ? periodStart : monthStart;
		const effectiveEnd = monthEnd > periodEnd ? periodEnd : monthEnd;
		const label = (typeof moment !== 'undefined')
			? moment.utc(monthStart).format('MM/YYYY')
			: `${String(monthStart.getUTCMonth() + 1).padStart(2, '0')}/${monthStart.getUTCFullYear()}`;
		months.push({
			label,
			start: new Date(effectiveStart.getTime()),
			end: new Date(effectiveEnd.getTime())
		});
	}

	const monthlyMinors = new Array(months.length).fill(0);
	contributions.forEach((contribution) => {
		if (!contribution || !contribution.included || contribution.frequency === 'adhoc' || contribution.overlapDays &lt;= 0) {
			return;
		}
		const overlaps = months.map((month) => calculateOverlapDays(
			contribution.effectiveStart,
			contribution.effectiveEnd,
			month.start,
			month.end
		));
		const allocations = distributeMinorByOverlap(contribution.annualMinorTarget, overlaps);
		allocations.forEach((minor, idx) => {
			monthlyMinors[idx] += minor;
		});
	});

	return {
		labels: months.map((month) => month.label),
		minors: monthlyMinors,
		values: monthlyMinors.map((minor) => round2(minorToNumber(minor)))
	};
}

function aggregateCostBy(costs, contributionMap, labelSelector) {
	const totals = new Map();
	costs.forEach((cost) => {
		if (!cost || !cost.id) {
			return;
		}
		const contribution = contributionMap.get(cost.id);
		if (!contribution || !contribution.included || contribution.frequency === 'adhoc') {
			return;
		}
		const label = labelSelector(cost);
		const key = label || 'Uncategorised';
		const current = totals.get(key) || 0;
		totals.set(key, current + contribution.annualMinorTarget);
	});
	const labels = Array.from(totals.keys());
	const minors = labels.map((label) => totals.get(label));
	return {
		labels,
		minors,
		values: minors.map((minor) => round2(minorToNumber(minor)))
	};
}

if (typeof window !== 'undefined') {
	window.summariseCosts = summariseCosts;
}

 
const promise_loadViewerAPIData = async (apiDataSetURL) => {
    if (!apiDataSetURL) return Promise.reject(false);
    try {
        const response = await fetch(apiDataSetURL);
        if (!response.ok) throw new Error("Failed to load data");
        return await response.json();
    } catch (error) {
        console.error("Fetch error:", error);
        return Promise.reject(false);
    }
};
 
const appCostIndex = new Map();
for (const app of costData) {
    appCostIndex.set(app.id, app.costs || []);
}

const apiDataSets = [
    viewAPIDataDO,
    viewAPIDataApps,
    viewAPIDataOrgs,
    viewAPIDataMart,
    viewAPIDataLifecycles,
    viewAPIDataKpi,
    viewAPIDataPhysProcs,
    viewAPIDataPlans,
    viewAPIDataTech,
    viewAPIDataCapMart
];
 
  
			function showEditorSpinner(message) {
				$('#editor-spinner-text').text(message);                            
				$('#editor-spinner').removeClass('hidden');                         
			};
	
			function removeEditorSpinner() {
				$('#editor-spinner').addClass('hidden');
				$('#editor-spinner-text').text('');
			};
	
			showEditorSpinner('Fetching Data...'); 
			var focusAppId='<xsl:value-of select="$param1"/>'
			var allDO=[];
			var appList=[];
			var byPerfName, defaultCcy, ccy, focusApp; 
			var stakeholdertable, interfaceReport;
			var stakeholdertable2, costTotalTemplate; 
			var pmc, procServices,table, costtable, appServiceList, scopedApps;
			var projectElementMap=[];
			var planElementMap=[];
			var today=new Date();
			var yearsArray=[];
			var svgStartDate=new Date (today.setFullYear(today.getFullYear() - 2)); 
			var svgEndDate=new Date (today.setFullYear(today.getFullYear() + 3));
			var svgWidth=1000;
			var appToCapabilityObj;
			var decisions = [<xsl:apply-templates select="$decisions" mode="decisions"/>]; 
<xsl:if test="$isEIPMode='true'">
function refreshDiagram(aDiagram) {
 
    showEditorSpinner('Loading diagram...');
    essPromise_getAPIElement('/essential-core/v1', 'diagrams', aDiagram.id, 'Diagram')
    .then(function(response) { 
		removeEditorSpinner();
        drawDiagram(response.config);  
		 
		return;
    })
    .catch(function (error) {
        removeEditorSpinner();
        console.log(error);
        //Show an error message: error
    });
}
function drawDiagram(diagramData) {
    document.getElementById('paper-container').appendChild(paperScroller.el);
    const container = document.getElementById('paper-container');

    paperScroller.setCursor('grab'); 
    graph.fromJSON(diagramData);

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
}

var graph = new joint.dia.Graph({ type: 'standard.HeaderedRectangle' }, { cellNamespace: joint.shapes });

var windowWidth = $('#processModal').width();
var windowHeight = $('#processModal').height();
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
			$('document').ready(function (){ 
				<xsl:call-template name="wordHandlebarsJS"/>


				Handlebars.registerHelper('toLowerCase', function(str) {
					return str.toLowerCase();
				  });
				  
				  Handlebars.registerHelper('eq', function(a, b) {
					return a === b;
				  });
				  
				  Handlebars.registerHelper('and', function(a, b) {
					return a &amp;&amp; b;
				  });
				  
				  Handlebars.registerHelper('or', function(a, b) {
					return a || b;
				  });
				  
				  Handlebars.registerHelper('calculateSecurityRating', function(confidentiality, integrity, availability) {
					// Simple algorithm to determine overall security rating
					const ratings = {
					  'High': 3,
					  'Medium': 2,
					  'Low': 1
					};
					
					const score = (ratings[confidentiality] || 0) + 
								  (ratings[integrity] || 0) + 
								  (ratings[availability] || 0);
					
					let status, color;
					
					if (score >= 8) {
					  status = 'High';
					  color = 'green';
					} else if (score >= 5) {
					  status = 'Medium';
					  color = 'amber';
					} else {
					  status = 'Low';
					  color = 'red';
					}
					
					return { status, color };
				  });
				  
				  Handlebars.registerHelper('formatDate', function(date) {
					if (!date) {
						return '';
					}
					const parsed = new Date(date);
					if (Number.isNaN(parsed.getTime())) {
						return '';
					}
					const options = { year: 'numeric', month: 'long', day: 'numeric' };
					return parsed.toLocaleDateString(undefined, options);
				  });
				
				Handlebars.registerHelper('getCapLevel', function(arg1) {			 
					return  Number(arg1) +1;
				});

				Handlebars.registerHelper('getDataRep', function(arg1) {
					let thisDr = DRList.find((dr)=>{
						return dr.id==arg1;
					});
				 
					return thisDr.name;
				});

				Handlebars.registerHelper('styler', function(arg1) {

					let match = plans.styles.find((d)=>{
						return d.id == arg1
					})

					return match 
						? `background-color:${match.colour};color:${match.textColour};`
						: 'background-color:#ffffff;color:#000000;';
				
				})

				Handlebars.registerHelper('getSQVBox', function (arg1, options) {
					let col;
					if(arg1&lt;2.1){col='perfScoreBoxRed'} 
					else if(arg1&gt;3.9){col='perfScoreBoxGreen'} 
					else{col='perfScoreBoxAmber'}
	
	
					return col;
				});
	
				Handlebars.registerHelper('getCat', function (arg1, options) {
				 
					let thisPM= pmc.find((p)=>{
						return p.id == arg1
					})
					if(thisPM){
						return thisPM.name
					}else{
						return '';
					}
				});

				Handlebars.registerHelper('getStdColour', function(arg1, arg2) {
				 
				   let stds=appMart.stdStyles.find((e)=>{
					   return e.id==arg1
				   }) 
			 
				   if(stds){
					return 'background-color:'+stds.colour+';color:'+stds.colourText;
					}
					else{
						return 'background-color:#ffffff ;color:#000000';
					}
				    
				})
				Handlebars.registerHelper('getLifeColour', function(arg1, arg2) {
					 
					let list=appList.filters.find((e)=>{
						return e.id==arg2
					}) 
					let itemVals=list.values.find((f)=>{
						return f.id==arg1;
					})

					if(itemVals){
					return 'border-bottom: 6px solid '+itemVals.backgroundColor
					}
					else{
						return 'border-bottom: 6px solid none';
					}

				});

				var currentLang="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>";
				if (!currentLang || currentLang === '') {
					currentLang = 'en-GB';
				}

				Handlebars.registerHelper('formatDate', function(arg1) {
					if (!arg1) {
						return '';
					}
					const parsed = new Date(arg1);
					if (Number.isNaN(parsed.getTime())) {
						return '';
					}
					return formatDateforLocale(parsed.toISOString(), currentLang)
				})			

				

				Handlebars.registerHelper('CRUDVal', function(arg1) {
					if(arg1=='Yes'){
						return '<div class="ess-circle"><i class="fa fa-check-circle-o" style="color:#2dc660;font-size:12pt"></i></div>'
					}else
					if(arg1=='No'){
						return '<div class="ess-circle"><i class="fa fa-times-circle-o" style="color:#c62d2d;;font-size:12pt"></i></div>'
					}else{
						return '<div class="ess-circle"><i class="fa fa-question-circle" style="color:#ffc45f;font-size:12pt"></i></div>'
					}
				});


				function showEditorSpinner(message) {$('#editor-spinner-text').text(message);                            
					$('#editor-spinner').removeClass('hidden');
					}
					
					function removeEditorSpinner(){$('#editor-spinner').addClass('hidden');
					$('#editor-spinner-text').text('');
					};
			showEditorSpinner('Fetching Data')
			Promise.all([ 
				promise_loadViewerAPIData(viewAPIDataDO), 
				promise_loadViewerAPIData(viewAPIDataApps),
				promise_loadViewerAPIData(viewAPIDataOrgs),
				promise_loadViewerAPIData(viewAPIDataMart),
				promise_loadViewerAPIData(viewAPIDataLifecycles),
				promise_loadViewerAPIData(viewAPIDataKpi),
				promise_loadViewerAPIData(viewAPIDataPhysProcs),
				promise_loadViewerAPIData(viewAPIDataPlans),
				promise_loadViewerAPIData(viewAPIDataTech),
				promise_loadViewerAPIData(viewAPIDataCapMart)
				]).then(function (responses){  
					allDO=responses[0];
					DOList=responses[0] ; 
					DRList=responses[0].data_representation ; 
					appList=responses[1]; 
				  
					orgsRolesList=responses[2].a2rs
					allActors=[...responses[2].indivData, ...responses[2].orgData]
					const ownerMap = new WeakMap();
					allActors.forEach(owner => {
						ownerMap.set(owner, owner.id);  // Stores only while the owner object exists
					});
					appMart=responses[3];
				 
					apus=responses[3].apus;
					ccy=responses[3].ccy
					allPerfMeasures=responses[5]
					appLifecycles=responses[4];
					physProc=responses[6]; 
					plans=responses[7]; 
					techProds=responses[8]; 
					busCaps=responses[9];
					const appData=responses[9].busCaptoAppDetails;

					// Function to filter the data
					const filteredDecisions = decisions.filter(item => 
						item.impacts.some(impact => 
							impact.className.toLowerCase().includes('application_provider')
						)
					);
 
					const decisionImpactMap = new Map(); 
					// Populate the map with `impact.id` as the key and `decision` as the value
					filteredDecisions.forEach((decision) => {
						decision.impacts.forEach((impact) => {
							if (!decisionImpactMap.has(impact.id)) {
									decisionImpactMap.set(impact.id, []);
								}
							decisionImpactMap.get(impact.id).push(decision);
						});
					});
  
						function extractCapabilities(buscapArray) {
							const result = {};
    
							// Recursive function to collect id: level
							function traverse(cap) {
								// Add the id as the key and the level as the value in the result object
								result[cap.id] = cap.level;
								
								// If there are children, navigate through them
								if (cap.childrenCaps &amp;&amp; cap.childrenCaps.length > 0) {
									cap.childrenCaps.forEach(child => traverse(child));
								}
							}
						
							// Iterate over the array of capabilities
							buscapArray?.forEach(cap => traverse(cap));
							
							return result;
						}
						
						// Call the function and store the result
						let capabilities = extractCapabilities(busCaps?.busCapHierarchy);
 
					const appToCapabilityMap = new Map();

					appData.forEach(capability => {
						const capId = capability.id;
						const capName = capability.name;
						const capLevel=capabilities[capability.id];
						
						capability.apps?.forEach(appId => {
							if (!appToCapabilityMap.has(appId)) {
								appToCapabilityMap.set(appId, []);
							}
							appToCapabilityMap.get(appId).push({ id: capId, name: capName, className:'Business_Capability', level:capLevel });
						});
					});
					busCaps=[]
					// Convert the map to an object if needed for JSON output or further manipulation
					appToCapabilityObj = Object.fromEntries(appToCapabilityMap);
 
					removeEditorSpinner();
					appMart.application_capabilities=[];
					appMart.capability_hieararchy=[]; 
					interfaceReport=appList.reports.filter((d)=>{return d.name=='appInterface'});
					focusApp=appList.applications.find((e)=>{return e.id==focusAppId});
			
 
					let appDataMap=[]; 
					defaultCurrency = appMart.ccy.find(currency => currency.default === "true");
	 
					<!-- create project pairs for speed -->
					
					plans.allProject?.forEach((p)=>{
					 
						p.p2e?.forEach((pe)=>{
							pe['projectName']=p.name;
							pe['projectID']=p.id;
							projectElementMap.push(pe)

							let clrs= plans.styles.find((s)=>{
								return s.id==pe.actionid;
							});
							if(clrs){
							pe['colour']=clrs.colour;
							pe['textColour']=clrs.textColour;
							}
							else{
								pe['colour']='#d3d3d3';
								pe['textColour']='#000000';
							}
						})
					});

					<!-- get any plans where no project exists but the app is mapped -->
					plans.allPlans?.forEach((p)=>{
						p.planP2E?.forEach((pe)=>{
							pe['name']=p.name;
							pe['id']=p.id;
							planElementMap.push(pe)

							let clrs= plans.styles.find((s)=>{
								return s.id==pe.actionid;
							});
							if(clrs){
							pe['colour']=clrs.colour;
							pe['textColour']=clrs.textColour;
							}
							else{
								pe['colour']='#d3d3d3';
								pe['textColour']='#000000';
							}
						})
					});
				
					pmc=responses[5].perfCategory; 
					let pms=responses[5].applications;
					pms?.forEach((d)=>{ 
						if(d.perfMeasures.length&gt;0){
							d.perfMeasures.forEach((e)=>{
								if(e.categoryid==''){ 
									if(e.serviceQuals[0]){
										e.categoryid=e.serviceQuals[0].categoryId;
									}
								}
							});
						};
						if(d.processPerfMeasures.length&gt;0){
							d.processPerfMeasures.forEach((p)=>{
								p.scores.forEach((e)=>{
									if(e.categoryid==''){ 
										if(e.serviceQuals[0]){
											e.categoryid=e.serviceQuals[0].categoryId;
										}
									}
								});
							});
						};
					});

					let requiredByAppsArray=[];
					// Create a map for DRList to allow constant-time lookups
					const drMap = new Map(Array.isArray(DRList) ? DRList.map((dr) => [dr.id, dr]) : []);
					
					allDO.data_objects?.forEach((e) => {
						// Update dataReps and collect theDrs in one loop
						const theDrs = e.dataReps.map((f) => {
							f['className'] = 'Data_Representation';
							return drMap.get(f.id);  // O(1) lookup instead of find
						});
					
						// Add data object info to classifications in a single pass
						e.classifications.forEach((f) => {
							if (!Array.isArray(f.dataObject)) {
								f.data_object = []; // Initialize as an empty array if it doesn't exist
							  }
							  
							f.data_object.push({"doid": e.id, "doname":e.name});
						 
						});
 
					
						// Replace e.dataReps with the updated theDrs array
						e['dataReps'] = theDrs;
					
						// Combine loops over infoRepsToApps into one pass
						const nested_apps = d3.nest()
							.key((f) => f.name)
							.entries(e.infoRepsToApps)
							.sort((a, b) => a.key.localeCompare(b.key));
					
						e['appsArray'] = nested_apps;
					
						e.infoRepsToApps.forEach((rep) => {
							rep['irInfo'] = {
								"name": rep.nameirep,
								"id": rep.idirep,
								"className": "Information_Representation"
							};
							rep['className'] = 'Data_Representation';  // Moved to single pass
					
							// Use push in a single loop
							appDataMap.push({ "id": rep.appid, "dataObjects": e });
						});
					
						// Push requiredByAppsArray in a single step
						requiredByAppsArray.push({ "id": e.id, "name": e.name, "apps": e.requiredByApps });
					});
					
function collateByApp(data) {
    const appDict = {};

    data.forEach(dataObject => {
        dataObject.apps.forEach(app => {
            if (!appDict[app.id]) {
                appDict[app.id] = { id: app.id, data_objects: [] };
            }
            appDict[app.id].data_objects.push({ id: dataObject.id, name: dataObject.name });
        });
    });

    return Object.values(appDict);
}


// Collating the data objects by app
const collatedApps = collateByApp(requiredByAppsArray);
 
const collatedAppsMap = new Map(collatedApps.map(app => [app.id, app]));


						var appDataSet = d3.nest()
						.key(function(f) { return f.id; })
						.entries(appDataMap);

					 appDataSet.forEach((e)=>{
						 let thisDo=[];
						 e.values.forEach((f)=>{
							 thisDo.push(f.dataObjects);
						 })
						
						 thisDo=thisDo.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index);
					 
						 e['dataObj']=thisDo;
					 })
					 let appServicePairs=[];
					 appAnalytics=[];
					
					 appList.applications.forEach((ap)=>{
						let thisAppClass=[];
						const match = collatedAppsMap.get(ap.id);
						if (match) {
							ap['requiredData'] = match.data_objects;
						}
						ap.allServices.forEach((d)=>{
							d['linkDetails']={"id":d.serviceId, "name":d.serviceName};
							appServicePairs.push({"name":ap.name, "appid":ap.id,"aprId":d.id, "svcId":d.serviceId})
						})

						let thislife = appLifecycles.application_lifecycles.find((a)=>{
							return a.id==ap.id
						 })
						
						 if(thislife){
							
						 	ap['lifecycles']=thislife.allDates;
						 }
						var option = new Option(ap.name, ap.id); 
						$('#subjectSelection').append($(option)); 
						
						let appMap=appDataSet.find((p)=>{
							return p.key==ap.id
						});
						let appClassifications=[];
					
						if(appMap){ 
							let thisAppArray=[];
							
							appMap.dataObj.forEach((am)=>{ 
							
								let filtered=am.appsArray.filter((d)=>{ 
									return d.key == ap.name;
								})	 
						 
								if(filtered){ 
									filtered[0]['dataObject']=am.name;
									filtered[0]['dataObjectId']=am.id;
									filtered[0]['className']='Data_Object';
									filtered[0]['name']=am.name;
									filtered[0]['id']=am.id;
									filtered[0]['classifications']=am.classifications;
									thisAppClass = [...thisAppClass, ...am.classifications];
									thisAppArray.push(filtered[0]);
									  
									if(am.classifications){
										am.classifications.forEach((c)=>{
										c['data_object']=am.name;
										c['data_object_id']=am.id;
										appClassifications.push(c)
										})
									}
								} 
							})
							ap['thisAppArray']=thisAppArray
							ap['dataObj']=appMap.dataObj;
						} 

						const mergedElementsMap = thisAppClass.reduce((acc, elem) => {
							if (!acc[elem.id]) {
							  // Initialize the element if it doesn't exist in the map
							  acc[elem.id] = {
								...elem,
								data_objects: [{ id: elem.data_object_id, name: elem.data_object }] // Initialize as an array of objects
							  };
							} else {
							  // If the element with the same id exists, only append to data_objects without overwriting other properties
							  acc[elem.id].data_objects = [
								...acc[elem.id].data_objects,
								{ id: elem.data_object_id, name: elem.data_object }
							  ];
							}
						  
							return acc;
						  }, {});
						  //   Convert the map back to an array
						 appClassifications = Object.values(mergedElementsMap);

						
						ap['classifications']=appClassifications;

						function groupByRegulation(data) {
						const regulationGroups = data.reduce((acc, item) => {
							const { name, regulation, data_objects } = item; // Use data_objects instead of a single data_object

							regulation.forEach((reg) => {
							if (!acc[reg.name]) {
								acc[reg.name] = [];
							}

							// Find if the current classification is already in the regulation group
							const existingEntry = acc[reg.name].find(entry => entry.classificationName === name);

							if (existingEntry) {
								// If the classification already exists, add all data_objects not already in the array
								data_objects.forEach(dataObj => {
								const existingDataObject = existingEntry.data_objects.find(obj => obj.id === dataObj.id);
								if (!existingDataObject) {
									// Add the new data_object if not already in the array
									existingEntry.data_objects.push({ id: dataObj.id, name: dataObj.name });
								}
								});
							} else {
								// If no classification exists yet, create a new entry with data_objects array
								acc[reg.name].push({
								classificationName: name,
								data_objects: data_objects.map(dataObj => ({ id: dataObj.id, name: dataObj.name }))
								});
							}
							});

							return acc;
						}, {});

						return regulationGroups;
						}

						  
						ap['classificationsByReg']=groupByRegulation(appClassifications);
						ap['classificationsByType']=appClassifications; 
 

						let actorsNRoles=[];
						ap.sA2R.forEach((f)=>{ 
							let thisA2r = orgsRolesList.find((r)=>{
								return r.id==f;
							})
							 
							if(thisA2r){
								actorsNRoles.push(thisA2r)
								} 
						})
 
						ap['stakeholders']=actorsNRoles.filter((f)=>{return f.type!='Group_Actor'});
						ap['orgstakeholders']=actorsNRoles.filter((f)=>{return f.type=='Group_Actor'});;
			 
						ap['pmScore']=0;
						let thisPerfMeasures=pms?.find((e)=>{
							return e.id==ap.id;
						});
						if(thisPerfMeasures){
							ap['pm']=thisPerfMeasures.perfMeasures;
							ap['bpm']=thisPerfMeasures.processPerfMeasures;
						} 
						appAnalytics.push({}) 
						const decision = decisionImpactMap.get(ap.id);   
				 
						if (decision) {
						 
							if (!ap.decisions) {
								ap.decisions = [];  // Ensure the `decisions` property exists
							}
 
							decision.forEach((d)=>{
								d['ownerInfo'] = ownerMap.get(d.owner)
								ap.decisions.push(d);  // Add the decision to the application's decisions array
							})
						}
						ap.decisions?.sort((a, b) => new Date(b.decision_date) - new Date(a.decision_date));

					});
		
					appServiceList= d3.nest()
						.key(function(f) { return f.svcId; })
						.entries(appServicePairs);	 
						
					appLifecycles.application_lifecycles=[];
					$('#subjectSelection').select2();  
					$('#subjectSelection').val(focusAppId).change();
				 
					var selectFragment = $("#select-template").html();
					selectTemplate = Handlebars.compile(selectFragment);
					
					var panelFragment = $("#panel-template").html();
					panelTemplate = Handlebars.compile(panelFragment);

					var techWordFragment = $("#techWord-template").text();
					techWordTemplate = Handlebars.compile(techWordFragment); 

					var kpiWordFragment = $("#kpiWord-template").text();
					kpiWordTemplate = Handlebars.compile(kpiWordFragment); 

					var costTotalFragment = $("#costTotal-template").text();
					costTotalTemplate = Handlebars.compile(costTotalFragment); 
					

					var lifecycleFragment = $("#lifecycle-template").html();
					lifecycleTemplate = Handlebars.compile(lifecycleFragment);
					
					Handlebars.registerHelper('ifContains', function(arg1, arg2, options) {
					 
						if(arg1.role.includes(arg2)){
							return '<label>'+arg1.role+'</label><ul class="ess-list-tags"><li class="tagActor">'+arg1.actor+'</li></ul>'
						}  
					});

					Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});

					Handlebars.registerHelper('test', function(arg1) {
						console.log('test', arg1)
						 
					});

					Handlebars.registerHelper('YPos', function(arg1,arg2, options) {
						let rowVal = (arg1+1)%2; 
						if(rowVal==0){
							return 20 +arg2
						}else{
							return (rowVal*40)+arg2 +150;
						}
						
					});

					Handlebars.registerHelper('Y1Pos', function(arg1,arg2, options) {
						let rowVal = (arg1+1)%2; 
						if(rowVal==0){
							return 45
						}else{
							return (rowVal*40)+arg2 +150;
						}
						
					});

					Handlebars.registerHelper('Y2Pos', function(arg1,arg2, options) {
						let rowVal = (arg1+1)%2; 
						if(rowVal==0){
							return 150;
						}else{

							return 20 +arg2
							
						}
						
					});
					

					Handlebars.registerHelper('XPos', function(arg1, options) {
						 
						return arg1-5;
					});
					
 
					

					Handlebars.registerHelper('getType', function(arg1, arg2, options) {
						if(arg1){

						return arg1.substring(0, arg1.indexOf("_"));
						}
					});

					Handlebars.registerHelper('formatCurrency', function(arg1, arg2, options) {
						var formatter = new Intl.NumberFormat(undefined, {  });
						if(arg1){
						return formatter.format(arg1);
						}
					});
					

					Handlebars.registerHelper('getInfo', function(arg1, arg2, options) {
					 
 					if(arg1){ 
						let list=appList.filters.find((e)=>{
							return e.id==arg2
						}) 
					 	let itemVals = list.values.find((f) => f.id == arg1);

						if (!itemVals) {
							 
						
						} else{ 
						return '<span class="label label-info" style="background-color: '+itemVals.backgroundColor+';color:'+itemVals.color+'">'+itemVals.enum_name+'</span>';
						}
					  }
					});
				 
					
					Handlebars.registerHelper('breaklines', function(html) {
						html = html.replace(/(\r&lt;li&gt;)/gm, '&lt;li&gt;');
					    html = html.replace(/(\r)/gm, '<br/>');
					    return new Handlebars.SafeString(html);
					});
										
					$('#selectMenu').html(selectTemplate(focusApp))
					$('.context-menu-appProviderGenMenu').html('<i class="fa fa-bars"></i> Menu');
					 
					essInitViewScoping(redrawPage, ['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS'], "",true);

	});



});

function mapSecurityProfilesToApps(focusApp, securityProfile) {
	 
  // Step 1: Build a Map for quick security profile lookup by sec_profile_of_element
  const securityMap = new Map();
  securityProfile.forEach(profile => {
	if (profile.sec_profile_of_element) {
	  securityMap.set(profile.sec_profile_of_element, profile);
	}
  });
  // Step 2: Append matching security profile to each application
  
	const matchedSecurity = securityMap.get(focusApp.id);
	if (matchedSecurity) {
		focusApp.security = matchedSecurity;
	}
}

var redrawPage = function () { 
	mapSecurityProfilesToApps(focusApp, securityProfile);
 let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
 let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
 let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
 let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');

 essResetRMChanges();
 let typeInfo = {
	"className": "Application_Provider",
	"label": 'Application',
	"icon": 'fa-desktop'
}

 scopedApps = essScopeResources( appList.applications, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo);
 scopedAppMartApps = essScopeResources(appMart.applications, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo);
 scopedAPUs = essScopeResources( apus, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo);
 
var allowed = scopedApps.resourceIds;
// If Select2, destroy it:
$('#subjectSelection').off();
if ( $('#subjectSelection').hasClass('select2-hidden-accessible') ) {
	$('#subjectSelection').select2('destroy');
}
 

$('#subjectSelection').select2({
  matcher: function(params, data) {
    if (!data.id) return null;

    const inAllowedList = allowed.includes(data.id);
    const searchTerm = (params.term || '').toLowerCase();
    const textMatch = data.text.toLowerCase().includes(searchTerm);

    return inAllowedList &amp;&amp; textMatch ? data : null;
  }
});
 
		// --- Begin: recursive child nesting (max depth 5) ---
		const MAX_CHILD_DEPTH = 5;
		const resourcesById = new Map((scopedApps &amp;&amp; scopedApps.resources ? scopedApps.resources : []).map(r => [r.id, r]));

		function resolveApp(nodeOrId) {
		  if (!nodeOrId) return null;
		  if (typeof nodeOrId === 'string') return resourcesById.get(nodeOrId) || null;
		  if (typeof nodeOrId === 'object' &amp;&amp; nodeOrId.id) return resourcesById.get(nodeOrId.id) || nodeOrId;
		  return null;
		}

		// Helper to create a minimal app object
		function toMinimalApp(node) {
		  if (!node) return null;
		  return {
			id: node.id,
			name: node.name,
			className: node.className,
			children: Array.isArray(node.children) ? node.children : []
		  };
		}

		// Recursively builds a nested children tree up to MAX_CHILD_DEPTH.
		// Uses a path-specific visited set to prevent cycles while allowing siblings to reuse shared nodes.
		function buildChildrenTree(app, depth, pathVisited) {
		  if (!app) return;
		  const nextDepth = depth + 1;
		  const ids = Array.isArray(app.children) ? app.children : [];

		  // At max depth: convert remaining ids to minimal objects, but do not recurse further
		  if (depth >= MAX_CHILD_DEPTH) {
			app.children = ids
			  .map(resolveApp)
			  .filter(Boolean)
			  .map(toMinimalApp);
			return;
		  }

		  const out = [];
		  for (const childRef of ids) {
			const childObj = resolveApp(childRef);
			if (!childObj) continue;
			const childId = childObj.id;
			if (!childId || pathVisited.has(childId)) {
			  continue; // avoid cycles / bad data
			}
			// Build a minimal clone and recurse
			const minimal = toMinimalApp(childObj);
			pathVisited.add(childId);
			buildChildrenTree(minimal, nextDepth, pathVisited);
			pathVisited.delete(childId);
			out.push(minimal);
		  }
		  app.children = out;
		}
		// --- End: recursive child nesting ---

		if (focusApp) {
		  buildChildrenTree(focusApp, 0, new Set([focusApp.id].filter(Boolean)));
		}
	 console.log('focusApp',focusApp)
		focusApp['caps']=appToCapabilityObj[focusApp.id] || null;
	
		const groupedAndSorted = focusApp.caps?.reduce((acc, item) => {
			if (item.level !== undefined) { // Skip items that don't have a level
				const level = item.level;
				if (!acc[level]) {
					acc[level] = [];
				}
				acc[level].push(item);
			}
			return acc;
		}, {});
		
		if(groupedAndSorted){
			// Sort each group by name
			Object.keys(groupedAndSorted).forEach(level => {
				groupedAndSorted[level].sort((a, b) => a.name.localeCompare(b.name));
			});
			focusApp.caps=groupedAndSorted
		}
	
	let panelSet = new Promise(function(myResolve, myReject) {
	 
	let filterenumerationValues=[];
	let focusKeys = focusApp ? Object.keys(focusApp) : [];
	 
	let appEnums=[]
	appList.filters.forEach((d)=>{
	
		let inFilters=focusKeys.find((e)=>{
			return d.slotName==e
		}) 
		
		if(inFilters){
			let thisFilter=appList.filters.find((e)=>{
				return e.slotName ==inFilters
			})
			
			let thisSelected=thisFilter.values.find((f)=>{
				return f.id==focusApp[inFilters]
			})
			if(thisSelected){ 
			thisSelected['class']=thisFilter.valueClass;
			thisSelected['classNm']=thisFilter.name;
			appEnums.push(thisSelected)
			}
		}
	})
	let itemsToRemove=[{'class': 'Lifecycle_Status'},{'class': 'Disposition_Lifecycle_Status'},{'class': 'Codebase_Status'},{'class': 'Application_Purpose'},{'class': 'Application_Delivery_Model'},{'class': 'SYS_CONTENT_VISIBILITY'},{'class': 'SYS_CONTENT_QUALITY_STATUS'},{'class': 'SYS_CONTENT_APPROVAL_STATUS'},{'class':'system_is_published'}, {'class': 'Business_Criticality'}];
	 
	const clsToRemove = itemsToRemove.map(item => item.class);
	const filteredArray = appEnums.filter(item => !clsToRemove.includes(item.class))
	  
	if(filteredArray &amp;&amp; focusApp){
		focusApp['otherEnums']=filteredArray
	}
	let allProcsforApps=[];
	let allProjforApps=[];
	if(focusApp){
		let thisTech=appMart.application_technology?.find((d)=>{
			return d.id==focusApp.id
		}) 
	
		//console.log('thisTech',thisTech)
		let key=[];
		thisTech?.environments?.forEach((e)=>{
			e.products=e.products?.filter((elem, index, self) => self.findIndex( (t) =>{return (t.tpr === elem.tpr)})=== index)
	
			e.products.forEach((t)=>{
				t['className']='Technology_Product';
				let thistechProds=techProds.techProdRoles?.find((p)=>{
					return p.id==t.tpr;
				}); 
				 t['id']=t.prod;
				 t['name']=t.prodname;
				if(thistechProds){
					
					t['standards']=thistechProds.standard
					t.standards?.forEach((d)=>{
						key.push({"id":d.id, "name":d.status,"colour":d.statusBgColour, "colourText":d.statusColour})
					})
				}
			})
	
			e.nodes.forEach(node => {
				node.className = 'Technology_Node';
			  });
	
		}); 
	 
		key=key.filter((elem, index, self) => self.findIndex( (t) =>{return (t.name === elem.name)})=== index)
	 
		focusApp['stdkey']=key;
		focusApp['applicationTechnology']=thisTech;

		const groupedByCompname = thisTech.environments 
		.filter(env => env.role === 'Production') 
		.flatMap(env => env.products) 
		.reduce((acc, product) => {
			const key = product.compname;
			if (!acc[key]) acc[key] = [];
			acc[key].push(product);
			return acc;
		}, {});
	 
		Object.entries(groupedByCompname).forEach(([componentName, products]) => {	 
			products.forEach(e => {
			
			let prodMatch='<xsl:value-of select="$viewerAPIPathInstance"/>&amp;PMA='+e.id; 
			promise_loadViewerAPIData(prodMatch)
				.then(function(response) {   
							 let match=response.instance.find((v)=>{return v.name == 'vendor_product_lifecycle_status'})
							 	 if(match?.values){
									e['life']=match.values[0].name	

									$('#prodLifeId'+e.id+' ').text(e.life)
								 }
							})
					})  

		})

		focusApp['prodApplicationTechnology']=groupedByCompname;
 
	
		allDO.app_infoRep_Pairs = allDO.app_infoRep_Pairs?.map(item => ({
			...item,
			className: 'Information_Representation'
		}));
	
		
		let thisDB=allDO.app_infoRep_Pairs?.filter((ap)=>{
			return ap.appId==focusApp.id &amp;&amp; ap.persisted=='true';
		})
	 
		focusApp['db']=thisDB;
	
	<!-- this application direct -->
		let thisElements=projectElementMap.filter((p)=>{
			return p.impactedElement == focusApp.id
		})
	 
		let thisPlanElementMap
		thisElements.forEach((e)=>{
			 thisPlanElementMap=planElementMap.filter((d)=>{
				return d.id!=e.id;
			})
			e['planInfo']={"id":e.planid, "name":e.plan, "className":"Enterprise_Strategic_Plan"};
			e['projectInfo']={"id":e.projectID, "name":e.projectName, "className":"Project"}
		})
	 
		let thisPlanElements=planElementMap.filter((p)=>{
			return p.impactedElement == focusApp.id
		})
	 
		let thisProj=[];
		let thisPlan=[]; 
		thisPlanElements.forEach((d)=>{
			thisPlan.push(d)
		})
	
		thisElements.forEach((d)=>{
			let thisProjDetail=plans.allProject?.find((p)=>{
				return d.projectID==p.id
			})
			thisProj.push(thisProjDetail);
			if(thisProjDetail.proposedStartDate){
				d['projForeStart']=thisProjDetail.proposedStartDate;
				d['projActStart']=thisProjDetail.actualStartDate;
				d['projForeEnd']=thisProjDetail.forecastEndDate;
				d['projTargEnd']=thisProjDetail.targetEndDate;
			}
			let thisPlans=plans.allPlans?.find((p)=>{
				return d.planid==p.id
			})
			
			thisPlan.push(thisPlans)
		})
	
		<!-- indirect via service -->
		let thisaprProj=[];
		let thisaprPlan=[]; 
		focusApp.allServices.forEach((f)=>{
		let thisaprElements=projectElementMap?.filter((p)=>{
			return p.impactedElement == f.id
		})
	 
		let thisPlanElementMap
		thisaprElements?.forEach((e)=>{
			 thisPlanElementMap=planElementMap.filter((d)=>{
				return d.id!=e.id;
			})
		})
		  
		let thisaprPlanElements=thisPlanElementMap?.filter((p)=>{
			return p.impactedElement == f.id
		})
		  
		thisaprPlanElements?.forEach((d)=>{
			thisaprPlan.push(d)
		})
	
		thisaprElements?.forEach((d)=>{
			let thisProjDetail=plans.allProject?.find((p)=>{
				return d.projectID==p.id
			})
			d['planInfo']={"id":d.planid, "name":d.plan, "className":"Enterprise_Strategic_Plan"};
			d['projectInfo']={"id":d.projectID, "name":d.projectName, "className":"Project"}
			 
			thisProjDetail['plan']=d.plan;
			thisProjDetail['planId']=d.planid;
			thisProjDetail['apraction']=d.action;
			if(thisProjDetail){
				thisaprProj.push(thisProjDetail);
			}
			if(thisProjDetail.proposedStartDate){
				d['projForeStart']=thisProjDetail.proposedStartDate;
				d['projActStart']=thisProjDetail.actualStartDate;
				d['projForeEnd']=thisProjDetail.forecastEndDate;
				d['projTargEnd']=thisProjDetail.targetEndDate;
			}
			let thisaprPlans=plans.allPlans?.find((p)=>{
				return d.planid==p.id
			})
			if(thisaprPlans){
				 
				thisaprPlan.push(thisaprPlans)
			}
		})
	}) 
	
	let resApr = {};
	 
	
	thisaprPlan?.forEach(a => resApr[a.id] = {...resApr[a.id], ...a});
	thisaprPlan = Object.values(resApr);
	 
	focusApp['aprplans']=thisaprPlan;
	focusApp['aprprojects']=thisaprProj;
	
	focusApp['aprprojectElements']=thisaprProj;
	<!-- merge objects -->
	
	let res = {};
	if(thisPlan){
		thisPlan.forEach(a => {
			if (a) {
			  res[a.id] = { ...res[a.id], ...a };
			}
		  });
		  
		thisPlan = Object.values(res);
	}else{
		thisPlan=[]
	}
	  
		focusApp['plans']=thisPlan;
		focusApp['projects']=thisProj;
	 
		if(focusApp.projects){
			focusApp.projects.forEach((p)=>{
				p['programmeName'] = plans.programmes?.find((s) => {
					return p?.programme ? p.programme === s.id : false;
				})?.name ?? null;
				})
			}
	
	 
		focusApp['projectElements']=thisElements;  
	 
	if(focusApp.physP){
		focusApp.physP.forEach((d)=>{
			 
			let thisProcess=physProc.process_to_apps.find((e)=>{
				return e.id==d;
			})
		 
			let mappedSvc= thisProcess.appsviaservice.filter((s)=>{
				return s.appid == focusApp.id
			})
	 
			if(mappedSvc.length&gt;0){
				mappedSvc.forEach((sv)=>{
				let thisAppSvc=focusApp.allServices.find((e)=>{
					return e.id==sv.id;
				})
			 
				allProcsforApps.push({"id":thisProcess.processid,"name":thisProcess.processName, "className": "Business_Process", "orgid":thisProcess.orgid, "org":thisProcess.org, "svcid":thisAppSvc.id, "svcName":thisAppSvc.serviceName, "direction":"via Service"})
			})
	
			}else{
		 
				allProcsforApps.push({"id":thisProcess.id,"name":thisProcess.processName,"orgid":thisProcess.orgid, "org":thisProcess.org, "svcid":"", "svcName":"", "direction":"Direct"})
			}
		})
	}
	
	 procServices = d3.nest()
	  .key(function(d) { return d.svcid})
	  .entries(allProcsforApps);
	 
	
	focusApp['processInfo']=allProcsforApps;
	
	} 
	let stakeholdersList=[]; 
	if(focusApp &amp;&amp; focusApp.stakeholders){
	stakeholdersList = d3.nest()
	  .key(function(d) { return d.actor; })
	  .entries(focusApp.stakeholders);
	
	  stakeholdersList?.forEach((d)=>{
		let sid = focusApp.stakeholders.find((s)=>{
			return s.actor==d.key
		})
		d['id']=sid.actorid;
		d['name']=d.key;
	})
	}
	
	if(focusApp){
	  focusApp['stakeholdersList']=stakeholdersList;
	
	  focusApp.lifecycles?.forEach((e,i)=>{
		  
		let thisL=appLifecycles.lifecycleJSON.find((l)=>{
			return e.id==l.id
		})
		
		if(thisL?.colour){
		e['enumname']=thisL.name;
		e['colour']=thisL.colour;
		e['backgroundColour']=thisL.backgroundColour;
		}else{
			e['colour']='#000000';
			e['backgroundColour']='#d3d3d3';
		}
		if(thisL?.seq){
		e['seq']=thisL?.seq;
		}
		else{
			e['seq']=i
		}
	  })
	   
	let orgStakeholdersList = d3.nest()
	.key(function(d) { return d.actor; })
	.entries(focusApp.orgstakeholders);
	 
	orgStakeholdersList.forEach((d)=>{
		let sid = focusApp.orgstakeholders.find((s)=>{
			return s.actor==d.key
		})
		d['id']=sid.actorid;
		d['name']=d.key;
	})
	focusApp['orgStakeholdersList']=orgStakeholdersList;
	
	let appDetail=appMart.applications.find((d)=>{
		return d.id==focusApp.id
	});

	appDetail.costs = appCostIndex.get(appDetail.id) || [];
 
		if(appDetail.documents){
			let docsCategory = d3.nest()
			.key(function(d) { return d.type; })
			.entries(appDetail.documents);
			
			focusApp['documents']=docsCategory;
		}
		if(appDetail.short_name !=""){
			focusApp['short_name']=appDetail.short_name;
		}
		if(appDetail.synonyms?.length&gt;0){ 
			focusApp['synonyms']=appDetail.synonyms;
		}
	if (!defaultCurrency || Object.keys(defaultCurrency).length === 0) {
		defaultCurrency = rcCcyId || {};
	}

	const baseCurrency = defaultCurrency.ccyCode || rcCcyId.ccyCode || BASE_CURRENCY_FALLBACK;

	const buildExchangeRateMap = (overrideCode, overrideRate) => {
		const map = {};
		if (Array.isArray(ccy)) {
			ccy.forEach((currency) => {
				if (!currency || !currency.ccyCode) {
					return;
				}
				const rate = parseExchangeRate(currency.exchangeRate);
				map[currency.ccyCode] = (Number.isFinite(rate) &amp;&amp; rate &gt; 0) ? rate : 1;
			});
		}
		const baseFallback = parseExchangeRate(defaultCurrency.exchangeRate);
		if (!Number.isFinite(map[baseCurrency]) || map[baseCurrency] &lt;= 0) {
			map[baseCurrency] = (Number.isFinite(baseFallback) &amp;&amp; baseFallback &gt; 0) ? baseFallback : 1;
		}
		if (overrideCode) {
			if (Number.isFinite(overrideRate) &amp;&amp; overrideRate &gt; 0) {
				map[overrideCode] = overrideRate;
			} else if (!Number.isFinite(map[overrideCode]) || map[overrideCode] &lt;= 0) {
				map[overrideCode] = 1;
			}
		}
		return map;
	};

	const periodBounds = getCurrentYearPeriod();
	const periodStartIso = formatIsoDate(periodBounds.start);
	const periodEndIso = formatIsoDate(periodBounds.end);

	const costInputs = (appDetail.costs || []).map((cost) => mapCostComponent(cost, baseCurrency)).filter(Boolean);
	focusApp['costs']=appDetail.costs;

	const locale = navigator.language || 'en-US';
	const formatCurrencyValue = (value, currencyCode) => new Intl.NumberFormat(locale, { style: 'currency', currency: currencyCode }).format(value);
	const trendSuffix = "<xsl:value-of select="eas:i18n('vs previous month')"/>";
	const trendNewLabel = "<xsl:value-of select="eas:i18n('New month of spend')"/>";
	const noDriversLabel = "<xsl:value-of select="eas:i18n('No cost drivers captured yet')"/>";
	const perMonthLabel = "<xsl:value-of select="eas:i18n('per month')"/>";

	const formatDisplayDate = (date) => {
		try {
			return new Intl.DateTimeFormat(locale, { year: 'numeric', month: 'short', day: 'numeric' }).format(date);
		} catch (error) {
			return date.toISOString().slice(0, 10);
		}
	};

	const costMetaMap = new Map();
	costInputs.forEach((cost) => {
		costMetaMap.set(cost.id, cost.meta || {});
	});

	const buildCostNumbers = (state) => {
		const periodLabel = `${formatDisplayDate(periodBounds.start)} – ${formatDisplayDate(periodBounds.end)}`;
		const defaults = {
			numbers: {
				annualCost: '—',
				monthlyCost: '—',
				currency: currentTargetCurrencyCode,
				period: periodLabel,
				latestMonthly: '—',
				trend: null,
				topCosts: [],
				adhocCost: null,
				inScopeOnly: currentInScopeOnly
			},
			raw: {
				annual: 0,
				monthly: 0,
				currency: currentTargetCurrencyCode
			}
		};
		if (!state || costSummaryError) {
			return defaults;
		}

		const annual = state.summary.totals.annual;
		const monthly = state.summary.totals.monthly;
		const currency = state.summary.currency;
		const latestMonthlyValue = state.monthly.values.length ? state.monthly.values[state.monthly.values.length - 1] : 0;
		const previousMonthlyValue = state.monthly.values.length > 1 ? state.monthly.values[state.monthly.values.length - 2] : null;

		let trend = null;
		if (previousMonthlyValue !== null) {
			const delta = latestMonthlyValue - previousMonthlyValue;
			if (Math.abs(previousMonthlyValue) > 0.00001) {
				const percent = (delta / Math.abs(previousMonthlyValue)) * 100;
				const rounded = round2(percent);
				const precision = Math.abs(rounded) >= 10 ? rounded.toFixed(0) : rounded.toFixed(1);
				trend = {
					direction: delta >= 0 ? 'up' : 'down',
					label: `${delta >= 0 ? '+' : ''}${precision}% ${trendSuffix}`,
					icon: delta >= 0 ? 'fa-arrow-up' : 'fa-arrow-down'
				};
			} else if (Math.abs(delta) > 0.00001) {
				trend = {
					direction: 'up',
					label: trendNewLabel,
					icon: 'fa-star'
				};
			}
		}

		const formattedTopCosts = (state.summary.breakdown || [])
			.filter((item) => item.included &amp;&amp; Math.abs(item.annual) > 0)
			.sort((a, b) => Math.abs(b.annual) - Math.abs(a.annual))
			.slice(0, 3)
			.map((item) => {
				const meta = costMetaMap.get(item.id) || {};
				const label = meta.typeLabel || meta.category || item.id;
				return {
					id: item.id,
					label,
					annual: formatCurrencyValue(item.annual, currency),
					monthly: formatCurrencyValue(item.monthly, currency)
				};
			});

		const adhocValue = state.summary.totals.adhoc;

		return {
			numbers: {
				annualCost: formatCurrencyValue(annual, currency),
				monthlyCost: formatCurrencyValue(monthly, currency),
				currency,
				period: periodLabel,
				latestMonthly: formatCurrencyValue(latestMonthlyValue, currency),
				trend,
				topCosts: formattedTopCosts,
				adhocCost: adhocValue ? formatCurrencyValue(adhocValue, currency) : null,
				inScopeOnly: currentInScopeOnly,
				annualLabel: currentInScopeOnly ? "<xsl:value-of select="eas:i18n('Actual Regular Annual Cost')"/>" : "<xsl:value-of select="eas:i18n('Annualised Regular Annual Cost')"/>",
				monthlyLabel: currentInScopeOnly ? "<xsl:value-of select="eas:i18n('Actual Regular Monthly Cost')"/>" : "<xsl:value-of select="eas:i18n('Annualised Regular Monthly Cost')"/>"
			},
			raw: {
				annual,
				monthly,
				currency
			}
		};
	};

	const renderTopCostList = (items) => {
		const listEl = $('#costTopList');
		if (!listEl.length) {
			return;
		}
		listEl.empty();
		if (!items || !items.length) {
			listEl.append('<li class="cost-top-empty">' + noDriversLabel + '</li>');
			return;
		}
		items.forEach((item) => {
			listEl.append(
				'<li>' +
					'<div class="cost-top-line">' +
						'<span class="cost-top-name">' + item.label + '</span>' +
						'<span class="cost-top-value">' + item.annual + '</span>' +
					'</div>' +
					'<div class="cost-top-sub">' + item.monthly + ' ' + perMonthLabel + '</div>' +
				'</li>'
			);
		});
	};

	const initialiseCurrencySelector = () => {
		const selectEl = $('#ccySelect');
		if (!selectEl.length) {
			return;
		}

		const currentSelection = ccy.find((currency) => currency.ccyCode === currentTargetCurrencyCode);

		const defaultOption = '<option value="">' + "<xsl:value-of select="eas:i18n('Select')"/>" + '</option>';
		selectEl.empty().append(defaultOption);
		ccy.forEach((currency) => {
			selectEl.append('<option value="' + currency.id + '">' + currency.ccyCode + '</option>');
		});

		if (selectEl.data('select2')) {
			selectEl.off('change').select2('destroy');
		}

		selectEl.select2({
			width: '100%'
		});

		if (currentSelection) {
			selectEl.val(currentSelection.id).trigger('change.select2');
		}

		selectEl.off('change').on('change', function() {
			const currency = $(this).val();
			updateCharts(currency);
		});

		// Add In-Scope Toggle listener
		$(document).off('change', '#inScopeToggle').on('change', '#inScopeToggle', function() {
			currentInScopeOnly = $(this).is(':checked');
			updateCharts();
		});
	};

	const computeCostSummaryForCurrency = (targetCurrencyCode, overrideRate) => {
		const effectiveRates = buildExchangeRateMap(targetCurrencyCode, overrideRate);
		const summary = summariseCosts(costInputs, effectiveRates, {
			targetCurrency: targetCurrencyCode,
			periodStart: periodStartIso,
			periodEnd: periodEndIso,
			includeAdhoc: false,
			inScopeOnly: currentInScopeOnly,
			baseCurrency
		});
		const contributions = costInputs.map((cost) => computeCostContribution(cost, {
			exchangeRates: effectiveRates,
			targetCurrency: targetCurrencyCode,
			baseCurrency,
			periodStart: periodBounds.start,
			periodEnd: periodBounds.end,
			includeAdhoc: false,
			inScopeOnly: currentInScopeOnly
		}));
		const contributionMap = new Map();
		contributions.forEach((item) => {
			if (item &amp;&amp; item.id) {
				contributionMap.set(item.id, item);
			}
		});
		const categoryAggregate = aggregateCostBy(costInputs, contributionMap, (cost) => cost.meta?.category);
		const typeAggregate = aggregateCostBy(costInputs, contributionMap, (cost) => cost.meta?.typeLabel);
		const frequencyAggregate = aggregateCostBy(costInputs, contributionMap, (cost) => FREQUENCY_LABELS[cost.frequency] || cost.meta?.frequencyKey || cost.frequency);
		const monthlySeries = buildMonthlySeries(contributions, periodBounds.start, periodBounds.end);
		return {
			summary,
			contributions,
			contributionMap,
			aggregates: {
				category: categoryAggregate,
				type: typeAggregate,
				frequency: frequencyAggregate
			},
			monthly: monthlySeries
		};
	};

	let currentInScopeOnly = true;
	let currentTargetCurrencyCode = defaultCurrency.ccyCode || baseCurrency;
	let costSummaryState = null;
	let costSummaryError = null;

	function updateCharts(currency) {
		const ccyMatch = (ccy &amp;&amp; currentTargetCurrencyCode) ? ccy.find(d => d.ccyCode === currentTargetCurrencyCode) : null;
		const currencyId = currency || $('#ccySelect').val() || (ccyMatch ? ccyMatch.id : null);
		const ccySelected = ccy ? ccy.find(d => d.id == currencyId) : null;
		if (!ccySelected) {
			return;
		}
		currentTargetCurrencyCode = ccySelected.ccyCode || baseCurrency;
		const selectedRate = parseExchangeRate(ccySelected.exchangeRate);
		try {
			costSummaryState = computeCostSummaryForCurrency(
				currentTargetCurrencyCode,
				(Number.isFinite(selectedRate) &amp;&amp; selectedRate &gt; 0) ? selectedRate : undefined
			);
			costSummaryError = null;
		} catch (error) {
			console.error('Cost summary error:', error);
			costSummaryError = error;
			$('.costTotal-container').html('<div class="alert alert-danger">' + error.message + '</div>');
			return;
		}

		const presentation = buildCostNumbers(costSummaryState);
		costNumbers = presentation.numbers;
		costNumbersRaw = presentation.raw;

		if ($('.costTotal-container').find('#regAnnual').length === 0) {
			$('.costTotal-container').html(costTotalTemplate(costNumbers));
			initialiseCurrencySelector();
		}

		$('#regAnnual').text(costNumbers.annualCost);
		$('#regMonthly').text(costNumbers.monthlyCost);
		$('#annualCostLabel').text(presentation.numbers.annualLabel);
		$('#monthlyCostLabel').text(presentation.numbers.monthlyLabel);
		$('#costCurrencyLabel').text(costNumbers.currency);
		$('#costPeriodLabel').text(costNumbers.period);
		$('#costLatestMonthly').text(costNumbers.latestMonthly);

		const trendElement = $('#costTrend');
		if (trendElement.length) {
			trendElement.removeClass('up down hidden');
			if (costNumbers.trend) {
				trendElement.addClass(costNumbers.trend.direction);
			} else {
				trendElement.addClass('hidden');
			}
		}

		const adhocCard = $('#costAdhocCard');
		if (adhocCard.length) {
			if (costNumbers.adhocCost) {
				$('#costAdhoc').text(costNumbers.adhocCost);
				adhocCard.show();
			} else {
				adhocCard.hide();
			}
		}

		renderTopCostList(costNumbers.topCosts);

		cbfLabels = costSummaryState.aggregates.frequency.labels;
		cbfVals = costSummaryState.aggregates.frequency.values;
		cbcLabels = costSummaryState.aggregates.category.labels;
		cbcVals = costSummaryState.aggregates.category.values;
		cbtLabels = costSummaryState.aggregates.type.labels;
		cbtVals = costSummaryState.aggregates.type.values;
		monthsList = costSummaryState.monthly.labels;
		sumsList = costSummaryState.monthly.values;

		if (!chartCostByFrequency || !chartCostByCategory || !chartCostByType || !chartCostByMonth) {
			return;
		}

		chartCostByFrequency.data.labels = cbfLabels;
		chartCostByFrequency.data.datasets[0].data = cbfVals;
		chartCostByCategory.data.labels = cbcLabels;
		chartCostByCategory.data.datasets[0].data = cbcVals;
		chartCostByType.data.labels = cbtLabels;
		chartCostByType.data.datasets[0].data = cbtVals;
		chartCostByMonth.data.labels = monthsList;
		chartCostByMonth.data.datasets[0].data = sumsList;
		chartCostByMonth.options.scales.yAxes[0].ticks.callback = function(value) {
			return formatCurrencyValue(value, costNumbersRaw.currency);
		};

		chartCostByFrequency.update();
		chartCostByCategory.update();
		chartCostByType.update();
		chartCostByMonth.update();
	}
	try {
		costSummaryState = computeCostSummaryForCurrency(currentTargetCurrencyCode);
	} catch (error) {
		console.error('Cost summary error:', error);
		costSummaryError = error;
	}

	let costNumbersPresentation = buildCostNumbers(costSummaryState);
	let costNumbers = costNumbersPresentation.numbers;
	let costNumbersRaw = costNumbersPresentation.raw;
	let cbcLabels=[];
	let cbcVals=[];
	let cbtLabels=[];
	let cbtVals=[];
	let cbfLabels=[];
	let cbfVals=[];
	let monthsList=[];
	let sumsList=[];

	if (costSummaryState &amp;&amp; !costSummaryError) {
		cbcLabels = costSummaryState.aggregates.category.labels;
		cbcVals = costSummaryState.aggregates.category.values;
		cbtLabels = costSummaryState.aggregates.type.labels;
		cbtVals = costSummaryState.aggregates.type.values;
		cbfLabels = costSummaryState.aggregates.frequency.labels;
		cbfVals = costSummaryState.aggregates.frequency.values;
		monthsList = costSummaryState.monthly.labels;
		sumsList = costSummaryState.monthly.values;
	} else if (costSummaryError) {
		$('.costTotal-container').html('<div class="alert alert-danger">' + costSummaryError.message + '</div>');
	}
	 
	focusApp['supplier']=appDetail?.supplier;
	
	focusApp.allServices.forEach((p)=>{
		let svcs= appMart.application_services.find((s)=>{
			return s.id==p.serviceId;
		});
	 
		let processesMapped=procServices.find((e)=>{
			return e.key==p.id;
		})
	 
		let otherAppsProviding=appServiceList.find((e)=>{
			return e.key==p.serviceId;
		})
	 
		if(otherAppsProviding){
			otherAppsProviding.values = otherAppsProviding.values.map(app => {
				return {
					...app,
					id: app.appid
				};
			});
			p['otherAppsProviding']=otherAppsProviding.values;
		}
	  
		let thisFunc=[]; 
		if(svcs){
			svcs.functions?.forEach((f)=>{
				let func=appMart.application_functions.find((s)=>{
					return s.id==f
				});
				thisFunc.push(func)
			})
			p['functions']=thisFunc;
		
			p['description']=svcs?.description;
	
	
	let match = svcs.APRs.filter((s)=>{
		return  s.appId == focusApp.id;
	})
	 
	p['std']=match[0].stds
	
		}
		if(processesMapped){
			p['processes']=processesMapped.values;
		}
	
	
	})
	 
	if(focusApp.pm){
	byPerfName = d3.nest()
		.key(function(d) { return d.categoryid })
		.entries(focusApp.pm) 
	  
		byPerfName.forEach((v)=>{
			v.values.sort((a, b) => b.date.localeCompare(a.order))
		})
	 
	byPerfName=byPerfName.filter((d)=>{
		return d.key!="";
	});
	focusApp['perfsGrp']=byPerfName
	}
	focusApp['lifecyclesKey']=appList.lifecycles
	 
	<xsl:if test="$isEIPMode='true'">focusApp.eipmode=true</xsl:if>
 
	$('#mainPanel').html(panelTemplate(focusApp))
	
	$('[data-toggle="collapse"]').on('click', function() {
		 
						var button = $(this).find('.toggle-btn');
						if (button.text().trim() === 'More Information') {
							button.text('Less Information');
						} else {
							button.text('More Information');
						}
					});
	//get width for svg;
	$('.interfaceButton').off('click.interface').on('click', function(){
		let appId=$(this).attr('easid')
		location.href='report?XML=reportXML.xml&amp;XSL='+interfaceReport[0].link+'&amp;PMA='+appId
	})
	
	$('.costTotal-container').html(costTotalTemplate(costNumbers));
	renderTopCostList(costNumbers.topCosts);
	
	function renderLifecycleTimeline(containerId, lifecycleData) {
		  const $container = $('#' + containerId);
	
		  if ($container.length === 0) {
			console.error('Container not found: ' + containerId);
			return;
		  }
	
		  $container.html(`
			<div class="controls">
			  <div class="control-group">
				<div class="date-display">Start Date</div>
				<div class="button-group"> 
				  <button id="startDateBackSmall"><i class="fa fa-caret-left"></i></button>
				  <button id="startDateForwardSmall"><i class="fa fa-caret-right"></i></button> 
				</div>
			  </div>
			  <div class="control-group">
				<div class="date-display">End Date</div>
				<div class="button-group"> 
				  <button id="endDateBackSmall"><i class="fa fa-caret-left"></i></button>
				  <button id="endDateForwardSmall"><i class="fa fa-caret-right"></i></button> 
				</div>
			  </div>
			  <div class="control-group">
				<button id="zoomIn">Zoom In</button>
				<button id="zoomOut">Zoom Out</button>
				<button id="resetView" class="reset-button">Reset View</button>
				<button id="exportPNG">Export as PNG</button>
			  </div>
			</div>
			<div id="timeline"></div>
			<div class="legend" id="legend"></div>
			<div class="tooltip" id="tooltip"></div>
		  `);
	 
		  lifecycleData.sort((a, b) => new Date(a.dateOf) - new Date(b.dateOf));
	
		  // Constants for SVG dimensions and styling
		  const tlwidth = 1100;
		  const tlheight = 400;
		  const margin = { top: 50, right: 50, bottom: 120, left: 50 };
		  const innerWidth = tlwidth - margin.left - margin.right;
		  const innerHeight = tlheight - margin.top - margin.bottom;
		  const nodeRadius = 15;
		  const lineHeight = 6;
	
		  // Process dates
		  const dates = lifecycleData.map(d => new Date(d.dateOf));
		  const actualMinDate = new Date(Math.min(...dates));
		  const actualMaxDate = new Date(Math.max(...dates));
		  
		  // Add default buffers
		  let currentMinDate = new Date(actualMinDate);
		  let currentMaxDate = new Date(actualMaxDate);
		  currentMinDate.setMonth(currentMinDate.getMonth() - 3);
		  currentMaxDate.setMonth(currentMaxDate.getMonth() + 3);
	
		  // Initialize timeline variables
		  let svg, tooltipEl;
	
		  // Format date for display
		  function formatDateForDisplay(date) {
			  return date.toLocaleDateString('en-US', {
				  year: 'numeric',
				  month: 'short',
				  day: 'numeric'
			  });
		  }
	 
	
		  // Create and draw the timeline
		  function drawTimeline() {
			  // Clear previous timeline
			  const timelineContainer = document.getElementById('timeline');
			  timelineContainer.innerHTML = '';
			  
			  // Create SVG element
			  svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
			  svg.setAttribute("width", tlwidth);
			  svg.setAttribute("height", tlheight);
			   svg.setAttribute("viewBox", "0 0 " + tlwidth + " " + tlheight);
			  svg.setAttribute("style", "max-width: 100%; height: auto;");
	
			  // Create a background for the timeline
			  const background = document.createElementNS("http://www.w3.org/2000/svg", "rect");
			  background.setAttribute("x", margin.left);
			  background.setAttribute("y", margin.top);
			  background.setAttribute("width", innerWidth);
			  background.setAttribute("height", innerHeight);
			  background.setAttribute("fill", "#f9f9f9");
			  background.setAttribute("rx", "8");
			  svg.appendChild(background);
	
			  // Function to map date to x position
			  const getX = (date) => {
				  const totalDays = (currentMaxDate - currentMinDate) / (1000 * 60 * 60 * 24);
				  const currentDays = (new Date(date) - currentMinDate) / (1000 * 60 * 60 * 24);
				  return margin.left + (currentDays / totalDays) * innerWidth;
			  }
	
			  // Create timeline line
			  const timeline = document.createElementNS("http://www.w3.org/2000/svg", "line");
			  timeline.setAttribute("x1", margin.left);
			  timeline.setAttribute("y1", margin.top + innerHeight / 2);
			  timeline.setAttribute("x2", margin.left + innerWidth);
			  timeline.setAttribute("y2", margin.top + innerHeight / 2);
			  timeline.setAttribute("stroke", "#ccc");
			  timeline.setAttribute("stroke-width", lineHeight);
			  timeline.setAttribute("stroke-linecap", "round");
			  svg.appendChild(timeline);
	
			  // Get visible items
			  const visibleItems = lifecycleData.filter(item => {
				  const itemDate = new Date(item.dateOf);
				  return itemDate >= currentMinDate &amp;&amp; itemDate &lt;= currentMaxDate;
			  });
	
			  // Create markers for each visible status
			  tooltipEl = document.getElementById('tooltip');
			  let lastLabelY = 0;
			  let labelYDirection = 1;
	
			  visibleItems.forEach((item, index) => {
				  const x = getX(item.dateOf);
				  const y = margin.top + innerHeight / 2;
				  
				  // Create a circle for the milestone
				  const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
				  circle.setAttribute("cx", x);
				  circle.setAttribute("cy", y);
				  circle.setAttribute("r", nodeRadius);
				  circle.setAttribute("fill", item.backgroundColour);
				  circle.setAttribute("stroke", "#fff");
				  circle.setAttribute("stroke-width", "2");
				  circle.setAttribute("class", "milestone");
				  circle.setAttribute("data-id", item.id);
				  svg.appendChild(circle);
	 
				  // Create a line connecting the circle to the label
				  // Alternate above and below the timeline
				  const labelY = y + (labelYDirection * (nodeRadius + 40));
				  labelYDirection *= -1;
				  lastLabelY = labelY;
	
				  const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
				  line.setAttribute("x1", x);
				  line.setAttribute("y1", y + (labelY > y ? nodeRadius : -nodeRadius));
				  line.setAttribute("x2", x);
				  line.setAttribute("y2", labelY - (labelY > y ? 20 : -20));
				  line.setAttribute("stroke", item.backgroundColour);
				  line.setAttribute("stroke-width", "2");
				  line.setAttribute("stroke-dasharray", "3,3");
				  svg.appendChild(line);
	
				  // Create a text label for the milestone
				  const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
				  label.setAttribute("x", x);
				  label.setAttribute("y", labelY);
				  label.setAttribute("text-anchor", "middle");
				  label.setAttribute("fill", "#333");
				  label.setAttribute("font-size", "12px");
				  label.textContent = item.enumname;
				  svg.appendChild(label);
	
				  // Create a smaller date label
				  const dateLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
				  dateLabel.setAttribute("x", x);
				  dateLabel.setAttribute("y", labelY + (labelY > y ? 20 : -20));
				  dateLabel.setAttribute("text-anchor", "middle");
				  dateLabel.setAttribute("fill", "#777");
				  dateLabel.setAttribute("font-size", "11px");
				  dateLabel.textContent = formatDateForDisplay(new Date(item.dateOf));
				  svg.appendChild(dateLabel);
	
				  // Add event listeners for tooltip
				  circle.addEventListener('mouseover', (e) => {
					 tooltipEl.innerHTML = `
						<div style="font-weight: bold; margin-bottom: 5px;">${item.enumname}</div>
						<div>Date: ${new Date(item.dateOf).toLocaleDateString('en-US', {
							year: 'numeric',
							month: 'long',
							day: 'numeric'
						})}</div>
						<div>Sequence: ${item.seq}</div>
						`;
					  tooltipEl.style.opacity = '1';
					  tooltipEl.style.left = (e.pageX + 10) + 'px';
					  tooltipEl.style.top = (e.pageY + 10) + 'px';
				  });
	
				  circle.addEventListener('mouseout', () => {
					  tooltipEl.style.opacity = '0';
				  });
	
				  circle.addEventListener('mousemove', (e) => {
					  tooltipEl.style.left = (e.pageX + 10) + 'px';
					  tooltipEl.style.top = (e.pageY + 10) + 'px';
				  });
			  });
	
			  // Add subtle grid lines
			  const numGridLines = 6;
			  for (let i = 0; i &lt;= numGridLines; i++) {
				  const x = margin.left + (i * innerWidth / numGridLines);
				  const gridLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
				  gridLine.setAttribute("x1", x);
				  gridLine.setAttribute("y1", margin.top);
				  gridLine.setAttribute("x2", x);
				  gridLine.setAttribute("y2", margin.top + innerHeight);
				  gridLine.setAttribute("stroke", "#ddd");
				  gridLine.setAttribute("stroke-width", "1");
				  gridLine.setAttribute("stroke-dasharray", "3,3");
				  svg.appendChild(gridLine);
	
				  // Add date labels on the grid lines
				  const dateOffset = i / numGridLines;
				  const date = new Date(currentMinDate.getTime() + dateOffset * (currentMaxDate.getTime() - currentMinDate.getTime()));
				  const dateText = document.createElementNS("http://www.w3.org/2000/svg", "text");
				  dateText.setAttribute("x", x);
				  dateText.setAttribute("y", margin.top + innerHeight + 20);
				  dateText.setAttribute("text-anchor", "middle");
				  dateText.setAttribute("fill", "#555");
				  dateText.setAttribute("font-size", "11px");
				  dateText.textContent = date.toLocaleDateString('en-US', {
					  year: 'numeric',
					  month: 'short'
				  });
				  svg.appendChild(dateText);
			  }
	   
			  // Append the SVG to the container
			  timelineContainer.appendChild(svg);
		  }
	
		  // Create the legend for all items (not just visible ones)
		  function createLegend() {
			  const legendContainer = document.getElementById('legend');
			  legendContainer.innerHTML = '';
			  
			  lifecycleData.forEach(item => {
				  const legendItem = document.createElement('div');
				  legendItem.className = 'legend-item';
				  
				  const colorBox = document.createElement('div');
				  colorBox.className = 'legend-color';
				  colorBox.style.backgroundColor = item.backgroundColour;
				  
				  const label = document.createElement('span');
				 label.textContent = `${item.seq}. ${item.enumname}`;
				  
				  legendItem.appendChild(colorBox);
				  legendItem.appendChild(label);
				  legendContainer.appendChild(legendItem);
			  });
		  }
	
		  // Date manipulation functions
			function moveStartDate(years) {
					const newDate = new Date(currentMinDate);
					newDate.setFullYear(newDate.getFullYear() + years);
	
					const minEndDate = new Date(currentMaxDate);
					minEndDate.setFullYear(minEndDate.getFullYear() - 1);
	
					if (newDate &lt; minEndDate) {
						currentMinDate = newDate; 
						drawTimeline();
					}
			}
	
		  function moveEndDate(years) {
				const newDate = new Date(currentMaxDate);
				newDate.setFullYear(newDate.getFullYear() + years);
	
				const maxStartDate = new Date(currentMinDate);
				maxStartDate.setFullYear(maxStartDate.getFullYear() + 1);
	
				if (newDate > maxStartDate) {
					currentMaxDate = newDate; 
					drawTimeline();
				}
			}
	
		  // Reset to original view with buffer
		  function resetView() {
			  currentMinDate = new Date(actualMinDate);
			  currentMaxDate = new Date(actualMaxDate);
			  currentMinDate.setMonth(currentMinDate.getMonth() - 3);
			  currentMaxDate.setMonth(currentMaxDate.getMonth() + 3); 
			  drawTimeline();
		  }
	
		  // Zoom functions
		  function zoomIn() {
			  // Zoom in by reducing the range by 25% from both sides
			  const currentRange = currentMaxDate - currentMinDate;
			  const adjustment = currentRange * 0.125; // 12.5% from each side
			  
			  const newMinDate = new Date(currentMinDate.getTime() + adjustment);
			  const newMaxDate = new Date(currentMaxDate.getTime() - adjustment);
			  
			  // Ensure there's still a reasonable range
			  if (newMaxDate - newMinDate >= 30 * 24 * 60 * 60 * 1000) { // At least 30 days
				  currentMinDate = newMinDate;
				  currentMaxDate = newMaxDate; 
				  drawTimeline();
			  }
		  }
	
		  function zoomOut() {
			  // Zoom out by increasing the range by 50% from both sides
			  const currentRange = currentMaxDate - currentMinDate;
			  const adjustment = currentRange * 0.25; // 25% to each side
			  
			  currentMinDate = new Date(currentMinDate.getTime() - adjustment);
			  currentMaxDate = new Date(currentMaxDate.getTime() + adjustment); 
			  drawTimeline();
		  }
	
		  // Initialize the visualization
		  function initialize() { 
			  drawTimeline();
			  //createLegend();
			  
			  // Set up event listeners for controls 
			  $('#startDateBackSmall').off('click.dateNav').on('click', () => moveStartDate(-1));
			   $('#startDateForwardSmall').off('click.dateNav').on('click', () => moveStartDate(1)); 
			   
			   $('#endDateBackSmall').off('click.dateNav').on('click', () => moveEndDate(-1));
			   $('#endDateForwardSmall').off('click.dateNav').on('click', () => moveEndDate(1)); 
			  
			  $('#zoomIn').off('click.viewCtrl').on('click', zoomIn);
			  $('#zoomOut').off('click.viewCtrl').on('click', zoomOut);
			  $('#resetView').off('click.viewCtrl').on('click', resetView);
			  $('#exportPNG').off('click.viewCtrl').on('click', function () {
					const svgElement = document.querySelector('#timeline svg');
					if (!svgElement) return;
	
					const svgData = new XMLSerializer().serializeToString(svgElement);
					const canvas = document.createElement('canvas');
					canvas.width = svgElement.viewBox.baseVal.width;
					canvas.height = svgElement.viewBox.baseVal.height;
					const ctx = canvas.getContext('2d');
	
					const img = new Image();
					const svgBlob = new Blob([svgData], {type: 'image/svg+xml;charset=utf-8'});
					const url = URL.createObjectURL(svgBlob);
	
					img.onload = function () {
						ctx.drawImage(img, 0, 0);
						URL.revokeObjectURL(url);
	
						const pngData = canvas.toDataURL('image/png');
						const downloadLink = document.createElement('a');
						downloadLink.href = pngData;
						downloadLink.download = 'lifecycle_timeline.png';
						document.body.appendChild(downloadLink);
						downloadLink.click();
						document.body.removeChild(downloadLink);
					};
	
					img.src = url;
				});
	
	
		  }
	
		  // Start the visualization
		  initialize();
	
		  // The rest of your original JS can follow here —
		  // just replace `document.getElementById(...)` with `$('#...')` where appropriate
		  // and set up event handlers using jQuery: e.g., `$('#zoomIn').on('click', ...)`
	
		  // Example:
		  // $('#zoomIn').on('click', function () { zoomIn(); });
		  // or use jQuery equivalents for manipulating SVG if needed
	
		  // After setup:
		  initialize(); // if you wrap the internal logic as an `initialize()` function inside
		}
	if(focusApp.lifecycles.length>0){
		renderLifecycleTimeline('TimelinePanel', focusApp.lifecycles)
	}
	 <!--
	svgWidth=$('#lifecyclePanel').parent().parent().parent().parent().width()-30;
	focusApp['svgwidth']=svgWidth;
	
	function getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, thisDatetoShow){
	 
		startDate=new Date(chartStartDate);       
		endDate= new Date(chartEndDate);
		thisDate= new Date(thisDatetoShow);
		pixels= chartWidth/(endDate-startDate);
	   
		return ((thisDate-startDate)*pixels)+chartStartPoint;
		}
	
		function getYearDiff(date1, date2) {
			return Math.abs(date2.getFullYear() - date1.getFullYear());
		  }
	  
		focusApp.lifecycles.forEach((d)=>{
			d['svgPos']=getPosition(20, svgWidth,  svgStartDate, svgEndDate, d.dateOf)
		 })
	
	function getYears(sd,ed){	
		yearsArray=[]; 
		 let getYears = getYearDiff(sd,ed)+1; 
		
		 for(i=0; i&lt;getYears+1; i++){
			 let yr=sd.getFullYear()+i
			
			yearsArray.push({"year":yr, "pos":getPosition(20, svgWidth,  sd, ed, yr+'-01-01')})
		 }
		
		 focusApp['years']=yearsArray;
	}
		 getYears(svgStartDate,svgEndDate) 
	$('#lifecyclePanel').html(lifecycleTemplate(focusApp)) 
	 
	$('#lifecycleUp').off().on("click", function(){
	 
		focusApp.years.shift();
	 
		svgStartDate=new Date (svgStartDate.setFullYear(svgStartDate.getFullYear() + 1));
	 
		focusApp.lifecycles.forEach((d)=>{
			d['svgPos']=getPosition(20, svgWidth,  svgStartDate, svgEndDate, d.dateOf)
		 })
		 getYears(svgStartDate,svgEndDate)
	  
		 $('#lifecyclePanel').html(lifecycleTemplate(focusApp)) 
	})
	
	$('#lifecycleEndUp').off().on("click", function(){ 
	
		svgEndDate=new Date (svgEndDate.setFullYear(svgEndDate.getFullYear() + 1));
	 
		focusApp.lifecycles.forEach((d)=>{
			d['svgPos']=getPosition(20, svgWidth,  svgStartDate, svgEndDate, d.dateOf)
		 })
		 getYears(svgStartDate,svgEndDate) 
		 $('#lifecyclePanel').html(lifecycleTemplate(focusApp)) 
	})
	 
	$('#lifecycleEndDown').off().on("click", function(){
		focusApp.years.pop();
		svgEndDate=new Date (svgEndDate.setFullYear(svgEndDate.getFullYear() -1 ));
	 
		focusApp.lifecycles.forEach((d)=>{
			d['svgPos']=getPosition(20, svgWidth,  svgStartDate, svgEndDate, d.dateOf)
		 })
	 
		 getYears(svgStartDate,svgEndDate) 
		$('#lifecyclePanel').html(lifecycleTemplate(focusApp)) 
	})
	$('#lifecycleDown').off().on("click", function(){
		 
		svgStartDate=new Date (svgStartDate.setFullYear(svgStartDate.getFullYear() - 1));
	 
		focusApp.lifecycles.forEach((d)=>{
			d['svgPos']=getPosition(20, svgWidth,  svgStartDate, svgEndDate, d.dateOf)
		})
		getYears(svgStartDate,svgEndDate)
	 
		$('#lifecyclePanel').html(lifecycleTemplate(focusApp)) 
	}) 
	-->
	initialiseCurrencySelector();
	
	let chartCostByFrequency;
	let chartCostByCategory;
	let chartCostByType;
	let chartCostByMonth;
	if(cbfLabels.length&gt;0){
	chartCostByFrequency = new Chart(document.getElementById("costByFrequency-chart"), {
	  type: 'doughnut',
	  data: {
		labels: cbfLabels,
		datasets: [
		  {
			label: "Frequency",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			data: cbfVals
		  }
		]
	  },
  options: {
	responsive: true,
	maintainAspectRatio: false,
	title: {
	  display: true,
	  text: 'Cost By Frequency'
	},
	legend: {
	  position: "bottom",
	  align: "middle"
	}
  }
	});
	
	// Repeat for other charts
	chartCostByCategory = new Chart(document.getElementById("costByCategory-chart"), {
	  type: 'doughnut',
	  data: {
		labels: cbcLabels,
		datasets: [
		  {
			label: "Type",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			data: cbcVals
		  }
		]
	  },
  options: {
	responsive: true,
	maintainAspectRatio: false,
	title: {
	  display: false,
	  text: 'Cost By Category'
	},
	legend: {
	  position: "bottom",
	  align: "middle"
	}
  }
	});
	chartCostByType = new Chart(document.getElementById("costByType-chart"), {
	  type: 'doughnut',
	  data: {
		labels: cbtLabels,
		datasets: [
		  {
			label: "Type",
			backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
			data: cbtVals
		  }
		]
	  },
  options: {
	responsive: true,
	maintainAspectRatio: false,
	title: {
	  display: true,
	  text: 'Cost By Type'
	},
	legend: {
	  position: "bottom",
	  align: "middle"
	}
  }
	});
	
	chartCostByMonth = new Chart(document.getElementById("costByMonth-chart"), {
	  type: 'bar',
	  data: {
		labels: monthsList,
		datasets: [
		  {
			label: "Cost Per Month",
			backgroundColor: "#f5aa42",
			data: sumsList
		  }
		]
	  },
  options: {
	responsive: true,
	maintainAspectRatio: false,
	scales: {
	  yAxes: [{
		ticks: {
		  beginAtZero: true,
		  callback: function(value) {
			return formatCurrencyValue(value, costNumbersRaw.currency);
		  }
		}
	  }]
	},
	plugins: {
	  labels: false
	}
  }
	});
	
	
	
	
	}
	}
	
	
	$(".ess-flat-card-title").matchHeight();
	// Info Circle Popovers
	
	
	$('.popover-trigger').popover({
		container: 'body',
		html: true,
		trigger: 'focus',
		placement: 'auto',
		sanitize:false,
		content: function(){
		return $(this).next().html();
		}
	});
	
	let classSelectData=[];
	let doSelectData=[];
	let irSelectData=[];
	if(focusApp &amp;&amp; focusApp.thisAppArray){
		focusApp.thisAppArray.forEach((d)=>{
			d.classifications.forEach((c)=>{
				classSelectData.push(c)
			})
			
			doSelectData.push({"name": d.dataObject, "id": d.dataObjectId})
			
			d.values.forEach((ir)=>{
				ir['irInfo']={"name": ir.nameirep, "id": ir.idirep, "className":"Information_Representation"};
				irSelectData.push({"name": ir.nameirep, "id": ir.idirep}) 
			})
		});
		 
	}
	 
	irSelectData=irSelectData.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
	if(classSelectData.length&gt;0){
	classSelectData=classSelectData.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
	classSelectData.forEach((c)=>{
		var option = new Option(c.name, c.id); 
		$('#classificationFilter').append($(option)); 
	})
	} 
	
	
	doSelectData.forEach((c)=>{
		var option = new Option(c.name, c.id); 
	$('#doFilter').append($(option)); 
	})
	irSelectData.forEach((c)=>{
		var option = new Option(c.name, c.id); 
		$('#irFilter').append($(option)); 
	})
	
	 
	$('#classificationFilter').select2({width:"200px"});
	$('#doFilter').select2({width:"200px"}); 
	$('#irFilter').select2({width:"200px"}); 
	if(focusApp &amp;&amp; focusApp.thisAppArray){
		$('.classificationFilter').hide();
	 
		let showCheck=0;
		focusApp.thisAppArray.forEach((a)=>{
		 
			if(a.classifications.length&gt;0){
				showCheck=showCheck+1
				} 
		})
		if(showCheck&gt;0){
			$('.classificationFilter').show();
		}
		else{
			$('.classificationFilter').hide();
		}
	}
	
	$('.filters').on('change',function(){
	let doId=$('#doFilter').val(); 
	let irId=$('#irFilter').val(); 
	let classId=$('#classificationFilter').val(); 
	
	$('.dataCard').hide()
	if(classId=='all'){ 
		$('.dataCard').show()
	}
	else{
	 
		$('[classifid='+classId+']').show()
	}
	 
	if(doId=='all'){ 
	}
	else{
		$('.dataCard[doid!='+doId+']').hide()
	}
	<!--
	$('.appCard2').show();
	if(irId=='all'){ 
	}
	else{
		$('.appCard2[irid!='+irId+']').hide()
	}
	-->
	 
	
	});
	
	myResolve(); // when successful
	myReject(); // when error
	});
	
	panelSet.then(function(response) {
	
		//get diagrams - only works on Cloud/Docker
		<xsl:if test="$isEIPMode='true'">
	let viewAPIDiagramInfo= '<xsl:value-of select="$viewerAPIPathInstance"/>&amp;PMA='+focusApp.id; 
						 promise_loadViewerAPIData(viewAPIDiagramInfo)
							.then(function(response) { 
	 
									 const instance = response.instance.find(inst => inst.name === "ea_diagrams");
						 console.log('diagram',instance);
						 			if(!instance){$('#diagramli').hide();}else{
										 $('#diagramli').show();
									 }
										if (instance &amp;&amp; instance.values.length > 0) { 
											$('#appDiagrams').empty();
											$('#appDiagrams').append('<option>Choose</option>')
											instance.values.forEach((s)=>{
											 
												$('#appDiagrams').append('<option value="'+s.id+'">'+s.name+'</option>') 
											})
											$('#appDiagrams').select2({width:"200px"});
	
											$('#appDiagrams').off().on('change', function(){  
												let selectedDiagram=$(this).val()
				
												let diagramtoShow={"id": selectedDiagram}
													
												refreshDiagram(diagramtoShow)  
											})
										}else{
												
										}  
							})
							
			</xsl:if>
	<!-- set word -->
	 $('#getWord').off().on('click',function(){
	  <xsl:call-template name="RenderOfficetUtilityFunctions"/>
	 
	 getWord(focusApp)
	})
	
	
	var getXML = function promise_getExcelXML(excelXML_URL) {
		return new Promise(
		function (resolve, reject) {
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.onreadystatechange = function () {
				if (this.readyState == 4 &amp;&amp; this.status == 200) {
					//console.log(prefixString);
					resolve(this.responseText);
				}
			};
			xmlhttp.onerror = function () {
				reject(false);
			};
			xmlhttp.open("GET", excelXML_URL, true);
			xmlhttp.send();
		});
	};
	 
	function getWord(applicationToReport){ 
	 <!-- calls to get the ODT structure which the content needs -->
	let  stylesXML, metaXML, manifestXML, mimetypeXML, settingsXML;
	
	 byPerfName?.forEach((d)=>{
	 let thisPM= pmc.find((p)=>{
		return p.id == d.key
	})
	if(thisPM){
		d['name']=thisPM.name
	}
	})
	 
	getXML('common/odt_document_files/styles.xml').then(function(response){ 
		stylesXML=response; 
	}).then(function(response){  
	
		getXML('common/odt_document_files/meta.xml').then(function(response){ 
		metaXML=response; 
	}).then(function(response){  
	
		getXML('common/odt_document_files/META-INF/manifest.xml').then(function(response){ 
			manifestXML=response; 
	}).then(function(response){  
	
		getXML('common/odt_document_files/mimetype').then(function(response){ 
			mimetypeXML=response; 
	}).then(function(response){  
		getXML('common/odt_document_files/settings.xml').then(function(response){ 
			settingsXML=response; 
	}).then(function(response){  
	  
	var zip = new JSZip();
	 
	let services=[];
	applicationToReport.allServices.forEach((e)=>{
		services.push(e.serviceName)
	});
	let family=[]
	applicationToReport.family.forEach((e)=>{
		let tableInfo=[];
		tableInfo.push(e.id);
		tableInfo.push(e.name);
		family.push(tableInfo)
	});
	<!-- structure content  header then type, prep the data before sending to the template 
	types = paragraph, 
			bullets - send an array of values, 
			table - provide headings as array, array per row, 
			image - just sends prompt to paste in
	
	Level - not used yet
	***** Paragraph Format *****
	"content":["text1", "text2", "text3"]
	
	***** Bullet Format *****
	"content":["Bullet 1", "Bullet 2", "Bullet 3"]
	
	***** Table Format *****
	 "headings":["Col1", "Col2", "Col3"]
	 "content":[{"row1":"a1","row2":"a2","row3":"a3"},
				{"row1":"b1","row2":"b2","row3":"b3"},
				{"row1":"c1","row2":"c2","row3":"c3"}
				]
				
	leave a blank header if don't want one between elements, allows multiple elements to be stacked in words  			
	-->
	let appKeys=Object.keys(applicationToReport)
	 
	let enumerationValues=[];
	appKeys.forEach((d)=>{
	 
		let inFilters=appList.filters.find((e)=>{
			return e.slotName==d
		}) 
		 
		if(inFilters){
		  
			let itemVals=inFilters.values.find((f)=>{
				return f.id==applicationToReport[d];
			})
		 
			if(itemVals){
				enumerationValues.push(inFilters.name+': '+itemVals.name)
			}
		}
	})
	
	<!-- format data for word document -->
	let familyString='Application Family: ';
	applicationToReport.family.forEach((d,i)=>{ 
			familyString=familyString+d.name+', ' 
	})
	
	let textContent=[familyString.slice(0, -2)];
	
	textContent=[...textContent,...enumerationValues]
	
	let stakeholderWord=[]
	applicationToReport.stakeholders.forEach((e)=>{
		stakeholderWord.push([e.actor, e.role])
	})
	 
	let orgStakeholderWord=[]
	applicationToReport.orgstakeholders.forEach((e)=>{
		orgStakeholderWord.push([e.actor, e.role])
	});
	
	let regulations=[]
	applicationToReport.classifications.forEach((e)=>{
		regulations.push([e.shortName])
	})
	
	let processInfoWord=[]
	applicationToReport.processInfo.forEach((e)=>{
		processInfoWord.push([e.name, e.org, e.direction, e.svcName])
	})
	
	let integrationsWord=[]
	let inboundString='Inbound: ';
	applicationToReport.inIList.forEach((e)=>{
		inboundString=inboundString+e.name+', ' 
	})
	
	integrationsWord.push([inboundString.slice(0, -2)])
	
	let outboundString='Outbound: ';
	applicationToReport.outIList.forEach((e)=>{
		outboundString=outboundString+e.name+', ' 
	})
	
	integrationsWord.push([outboundString.slice(0, -2)])
	
	integrationsWord.push(['Paste image here'])
	 
	let techJSON = {}
	techJSON=techWordTemplate(applicationToReport.applicationTechnology)
	 
	techJSON=JSON.parse(techJSON);
	
	let kpiJSON = {}
	kpiJSON=kpiWordTemplate(applicationToReport);
	kpiJSON=JSON.parse(kpiJSON);
	 
	 
	
	let costInfoWord=[];
	applicationToReport.costs?.forEach((e)=>{
		costInfoWord.push([e.name, e.cost, e.costType.replace(/_/g,' ').replace('Cost Component',''), e.fromDate, e.toDate]) 
	})
	
	let dataObjInfoWord=[];
	applicationToReport.dataObj?.forEach((e)=>{
		dataObjInfoWord.push(e.name) 
	})
	
	let lifecyclesInfoWord=[];
	applicationToReport.lifecycles?.forEach((e)=>{
		lifecyclesInfoWord.push([e.enumname, e.dateOf]) 
	})
	 
	docContent={"name":applicationToReport.name,            
				"sections":[
				{"header":"Description",
							"level":1,
							"type":"paragraph",
							"content":[applicationToReport.description]},
				{"header":"Key Information","level":1,"intro":"Key information related to this application","type":"paragraph","content":textContent}, 
				{"header":"Services Provided",
							"level":1,
							"intro":"Application services provided by this application and used by business processes",
							"type":"bullets",
							"content":services},
				{"header":"Stakeholders",
							"level":1,
							"intro":"Business stakeholders for this application",
							"type":"table",
							"headings":["Name","Role"],
							"content":stakeholderWord},
				{"header":"Organisations &amp; Roles",
							"level":1,
							"intro":"Organisational stakeholders for this application",
							"type":"table",
							"headings":["Name","Role"],
							"content":orgStakeholderWord},
				{"header":"Regulations Impacting",
							"level":1,
							"intro":"Regulations impacting this application",
							"type":"bullets",
							"content":regulations},							
				{"header":"Architecture",
							"intro":"Technology used by this application",
							"level":1,
							"type":"image",
							"content":"Please paste image here"},							
				{"header":"Test",
							"intro":"Technology used by this application",
							"level":1,
							"type":"image",
							"content":[]},
				{"header":"Process Support",
							"level":1,
							"intro":"Processes supported by this application and whether mapped via a service or directly",
							"type":"table",
							"headings":["Process", "Organisation", "Type", "Service"],
							"content":processInfoWord},
				{"header":"Integrations",
							"level":1,
							"intro":"Application integrations into an out of the application",
							"type":"paragraph", 
							"content":integrationsWord},
							<!-- techJSON -->			
				{"header":"Application Costs",
							"level":1,
							"intro":"Costs of the application",
							"type":"table",
							"headings":["Cost Type", "Value", "Type", "From Date", "To Date"],
							"content":costInfoWord},	
				{"header":"Data Objects",
							"level":1,
							"intro":"Data Objects used by this application",
							"type":"bullets",
							"content":dataObjInfoWord},	
				{"header":"Lifecycle Dates",
							"level":1,
							"intro":"Lifecycle dates for the application",
							"type":"table",
							"headings":["Stage", "Date From"],
							"content":lifecyclesInfoWord},
								
				]};
	
	techJSON.forEach((d)=>{ 
		docContent.sections?.push(d)
	
	});
	kpiJSON.forEach((d)=>{
	 
		docContent.sections.push(d)
	
	});
				<xsl:call-template name="wordKeyVariablesJS"/>
				let contentBody=wordTemplate(docContent);
				
				let content= contentHead+contentBody+contentFoot;
	 
	
				generateWordZip(content, manifestXML,metaXML,mimetypeXML,settingsXML,stylesXML,'appSummaryExport')
	
	})
	})
	})
	}) 
	}) 
	};  
	
	// end of word set-up
		
	
	<!--	setGraph(); -->
	 
	 
		$('#decisionsTable').DataTable() 
	 
	if(stakeholdertable){
	$('#dt_stakeholders').DataTable().destroy()
	
	stakeholdertable=null;
	}
	
	$('#dt_stakeholders tfoot th').each( function () {
	let stakeholdertitle = $(this).text();
	$(this).html( '&lt;input type="text" placeholder="Search '+stakeholdertitle+'" /&gt;' );
	});
	
	
	stakeholdertable = $('#dt_stakeholders').DataTable({
	scrollY: "350px",
	scrollCollapse: true,
	paging: false,
	info: false,
	sort: true,
	responsive: true,
	columns: [
	{ "width": "30%" },
	{ "width": "30%" }
	],
	dom: 'Bfrtip',
	buttons: [
	'copyHtml5',
	'excelHtml5',
	'csvHtml5',
	'pdfHtml5',
	'print'
	]
	});
	
	// Apply the search
	stakeholdertable.columns().every( function () {
	let thatst1 = this;
	
	$( 'input', this.footer() ).on( 'keyup change', function () {
	if ( thatst1.search() !== this.value ) {
	thatst1
	.search( this.value )
	.draw();
	}
	});
	});
	
	
	if(stakeholdertable2) {
	stakeholdertable2
	.rows()
	.invalidate()
	.destroy();
	}
	
	
	$('#dt_stakeholders2 tfoot th').each( function () {
	let stakeholdertitle2 = $(this).text();
	$(this).html( '&lt;input type="text" placeholder="Search '+stakeholdertitle2+'" /&gt;' );
	} );
	
	
	stakeholdertable2 = $('#dt_stakeholders2').DataTable({
	scrollY: "350px",
	scrollCollapse: true,
	paging: false,
	info: false,
	sort: true,
	responsive: true,
	columns: [
	{ "width": "30%" },
	{ "width": "30%" }
	],
	dom: 'Bfrtip',
	buttons: [
	'copyHtml5',
	'excelHtml5',
	'csvHtml5',
	'pdfHtml5',
	'print'
	]
	});
	// Apply the search
	stakeholdertable2.columns().every( function () {
	let thatst2 = this;
	
	$( 'input', this.footer() ).on( 'keyup change', function () {
	if ( thatst2.search() !== this.value ) {
	thatst2
	.search( this.value )
	.draw();
	}
	} );
	});
	stakeholdertable2.columns.adjust();
	stakeholdertable.columns.adjust();
	if(table){
	table=null;
	$('#dt_dobjecttable').DataTable().destroy();
	
	}
	$('#dt_dobjecttable tfoot th').each( function () {
	let title = $(this).text();
	$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
	} );
	
	
	table = $('#dt_dobjecttable').DataTable({
	scrollY: "350px",
	scrollCollapse: true,
	paging: false,
	info: false,
	sort: true,
	responsive: true,
	columns: [
	{ "width": "30%" } ,
	{ "width": "50%" } ,
	{ "width": "20%" }
	],
	dom: 'Bfrtip',
	buttons: [
	'copyHtml5',
	'excelHtml5',
	'csvHtml5',
	'pdfHtml5',
	'print'
	]
	});
	
	
	// Apply the search
	table.columns().every( function () {
	let that = this;
	
	$( 'input', this.footer() ).on( 'keyup change', function () {
	if ( that.search() !== this.value ) {
	that
	.search( this.value )
	.draw();
	}
	} );
	});
	table.columns.adjust();
	
	
	// $('#mainPanel').html(panelTemplate(focusDO))

	if ($.fn.DataTable.isDataTable('#dt_costs')) {
		$('#dt_costs').DataTable().clear().destroy();
	}
	
	$('#dt_costs tfoot th').each( function () {
		let titleCost = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+titleCost+'" /&gt;' );
		} );
	
	costtable = $('#dt_costs').DataTable({ 
		paging: false,
	deferRender:    true,
	scrollY:        350,
	scrollCollapse: true,
	info: true,
	sort: true, 
	responsive: false,
	columns: [
		{ "width": "20%" },
		{ "width": "10%" },
		{ "width": "25%" },
		{ "width": "15%" },
		{ "width": "15%" },
		{ "width": "15%" }
	  ],
	dom: 'Bfrtip',
	buttons: [
		'copyHtml5', 
		'excelHtml5',
		'csvHtml5',
		'pdfHtml5',
		'print'
	]
	});
	
	costtable.columns().every( function () {
		let that = this;
		
		$( 'input', this.footer() ).on( 'keyup change', function () {
		if ( that.search() !== this.value ) {
		that
		.search( this.value )
		.draw();
		}
		} );
		});
		costtable.columns.adjust()
	
	<!-- process table -->	
	
	$('#dt_processtable tfoot th').each( function () {
		let titleProcess = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+titleProcess+'" /&gt;' );
		} );
	
	var windowHeight = $(window).innerHeight();
	
	procstable = $('#dt_processtable').DataTable({ 
		paging: false,
		deferRender:    true,
		scrollY:        windowHeight-450,
		scrollCollapse: true,
		info: true,
		sort: true, 
		responsive: false,
		columns: [
			{ "width": "20%" },
			{ "width": "20%" },
			{ "width": "20%" },
			{ "width": "20%" }
		  ],
		dom: 'Bfrtip',
		buttons: [
			'copyHtml5', 
			'excelHtml5',
			'csvHtml5',
			'pdfHtml5',
			'print'
		]
		});
	
	procstable.columns().every( function () {
		let that = this;
		
		$( 'input', this.footer() ).on( 'keyup change', function () {
		if ( that.search() !== this.value ) {
		that
		.search( this.value )
		.draw();
		}
		} );
		});
	
	procstable.columns.adjust()
	
	<!-- end setGraph -->
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	
		if(e.target.id=='appIntTab'){ 
			createSVGIntegration(focusApp);
		}
		if(e.target.id=='detailedTabLink'){ 
			createSVGIntegration(focusApp);
		}
		if(e.target.id=='detailedTabLink'){ 
			createSVGIntegration(focusApp);
		}
		if(e.target.id=='simpleTabLink'){ 
			createSVGIntegration(focusApp);
		}
		
		e.target // newly activated tab
		e.relatedTarget // previous active tab
		$(".ess-flat-card-title").matchHeight();
	  });
	 
	  function getRelatedApus(apus, focusApp) {
		// Step 1: Find initial set
		let related = apus.filter(apu => 
		  apu.fromAppId === focusApp.id || apu.toAppId === focusApp.id
		);
	  
		// Step 2: Check for Application_Provider_Interface
		let additionalIds = [];
	  
		related.forEach(apu => {
		  if (apu.fromtype === "Application_Provider_Interface") {
			additionalIds.push(apu.fromAppId);
		  }
		  if (apu.totype === "Application_Provider_Interface") {
			additionalIds.push(apu.toAppId);
		  }
		});
	  
		// Step 3: Find apus related to those Interface IDs
		additionalIds.forEach(interfaceId => {
		  const moreRelated = apus.filter(apu => 
			apu.fromAppId === interfaceId || apu.toAppId === interfaceId
		  );
		  related.push(...moreRelated);
		});
	  
		// Optional: Remove duplicates
		const uniqueRelated = [];
		const seen = new Set();
	  
		related.forEach(apu => {
		  if (!seen.has(apu.id)) {
			seen.add(apu.id);
			uniqueRelated.push(apu);
		  }
		});
	  
		return uniqueRelated;
	  }  

	  function createGraphFromApus(relatedApus) {
		const nodesMap = new Map();
		let edges = [];
	    const fromCounts = {};
		const toCounts = {};

		relatedApus.forEach(apu => {
		  // Only process if both fromAppId and toAppId are in scopedAppMart
		  if (!(scopedAppMartApps.resourceIds.includes(apu.fromAppId) &amp;&amp; scopedAppMartApps.resourceIds.includes(apu.toAppId))) {
			return;
		  }
 
			fromCounts[apu.fromAppId] = (fromCounts[apu.fromAppId] || 0) + 1;
			toCounts[apu.toAppId] = (toCounts[apu.toAppId] || 0) + 1;
		
		  // Add 'from' node
		  if (!nodesMap.has(apu.fromAppId)) {
			nodesMap.set(apu.fromAppId, {
			  id: apu.fromAppId,
			  label: apu.fromApp || apu.fromAppId, // fallback if no name
			  type: apu.fromtype
			});
		  }
	  
		  // Add 'to' node
		  if (!nodesMap.has(apu.toAppId)) {
			nodesMap.set(apu.toAppId, {
			  id: apu.toAppId,
			  label: apu.toApp || apu.toAppId,
			  type: apu.totype
			});
		  }
	  
		  // Add edge
		  let labelInfo = ''
		  apu.info.forEach((d)=>{})
		  edges.push({
			id: apu.id,
			source: apu.toAppId,
			target: apu.fromAppId,
			label: apu.info || "", // optional: name the edge
			type: apu.infoData?.[0]?.type || "" // optional: could show type of connection
		  });
		}); 

		const keys1 = Object.keys(fromCounts);
		const keys2 = Object.keys(toCounts);
		const onlyIn1 = keys1.filter(k => !toCounts.hasOwnProperty(k));
		const onlyIn2 = keys2.filter(k => !fromCounts.hasOwnProperty(k));
		let leftOver = [...onlyIn1, ...onlyIn2];
  
		const diffSet = new Set(leftOver); 
		const apisInDiff = leftOver.filter(id => {
			const node = nodesMap.get(id);
			return node?.type === 'Application_Provider_Interface';
		});

		
		// Convert nodesMap to array
		var nodes = Array.from(nodesMap.values());

		const toRemove = new Set(apisInDiff);
 
		// Filter out unwanted nodes
		const filteredNodes = nodes.filter(node => !toRemove.has(node.id));
 
		// Filter out any edge that touches a removed node
		const filteredEdges = edges.filter(edge =>
			!toRemove.has(edge.source) &amp;&amp; !toRemove.has(edge.target)
			);
	
		nodes=filteredNodes;
		edges=filteredEdges;
		return { nodes, edges };
	  }
	
	
	  // Auto-calculate x, y if missing in nodes
	  function autoPositionNodes(nodes) {
		const spacingX = 150;
		const spacingY = 100;
		let currentX = 50;
		let currentY = 50;
		let rowCount = 0;
		const maxPerRow = 5;
	  
		nodes.forEach(node => {
		  if (node.x == null || node.y == null) {
			node.x = currentX;
			node.y = currentY;
			rowCount++;
			if (rowCount >= maxPerRow) {
			  currentX = 50;
			  currentY += spacingY;
			  rowCount = 0;
			} else {
			  currentX += spacingX;
			}
		  }
		});
	  }  


function createSVGIntegration(data){ 
	// Create the input graph
	var g = new dagreD3.graphlib.Graph()
	  .setGraph({})
	  .setDefaultEdgeLabel(function() { return {}; });
	  
	const relatedApus = getRelatedApus(scopedAPUs.resources, focusApp);
 
  	const { nodes, edges } = createGraphFromApus(relatedApus);
	autoPositionNodes(nodes);
	  
	let appList =[...focusApp.inIList, ...focusApp.outIList];
	appList.push({"name":focusApp.name, "id":focusApp.id})
	
	appList=appList.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id &amp;&amp; t.name === elem.name)})=== index) 
	 
	appList.forEach((d)=>{
		g.setNode(d.id, {label:d.name});
	})
	 
	
	g.nodes().forEach(function(v) {
	  var node = g.node(v);
	  // Round the corners of the nodes
	  node.rx = node.ry = 5;
	});
	//set edges
	focusApp.inIList?.forEach((e)=>{
		g.setEdge(e.id, focusApp.id, {curve: d3.curveBasis})
	});
	focusApp.outIList?.forEach((e)=>{
		g.setEdge(focusApp.id, e.id, {curve: d3.curveBasis})
	});
	 
	// Create the renderer
	var render = new dagreD3.render();
	
	// Set up an SVG group so that we can translate the final graph.
	g.graph().rankDir = 'LR';
	g.graph().nodesep = 20;
	g.graph().acyclicer='greedy'
	var svg = d3.select("#svgBox").select("svg"),
		svgGroup = svg.append("g");
	
	// Run the renderer. This is what draws the final graph.
	 render(d3.select("svg g"), g);
	 var inner = svg.select("g");
	 var zoom = d3.zoom().on("zoom", function() {
		inner.attr("transform", d3.event.transform);
	});
	svg.call(zoom);
	//setTimeout(renderSVG,2000);
	
	// Center the graph
	var xCenterOffset = g.graph().width / 2;
	 
	svgGroup.attr("transform", "translate(20, 20)");

// Initialize JointJS graph and paper
        const appgraph = new joint.dia.Graph();
        const apppaper = new joint.dia.Paper({
            el: document.getElementById('appIntegrationDiagram'),
            model: appgraph,
            width: 800,
            height: 500,
            gridSize: 10,
            drawGrid: true,
            background: {
                color: 'rgba(0, 0, 0, 0.05)'
            }
        });

        // Function to render diagram from JSON
		function renderDiagram(diagramJson) {
    appgraph.clear();

    var g = new dagre.graphlib.Graph()
        .setGraph({
            rankdir: 'LR',
            nodesep: 50,
            ranksep: 100,
            marginx: 10,
            marginy: 10,
            edgesep: 20,
            ranker: 'longest-path',
            acyclicer: 'greedy'
        })
        .setDefaultEdgeLabel(function () { return {}; });

    diagramJson.nodes.forEach(node => {
        g.setNode(node.id, {
            label: node.label || node.id,
            width: 80,
            height: 60,
            style: node.type === 'Application_Provider_interface'
                ? 'fill: grey;'
                : ''
        });
    });

    diagramJson.edges.forEach(edge => {
        g.setEdge(edge.source, edge.target);
    });

    dagre.layout(g);

    const nodeMap = {};
    g.nodes().forEach(nodeId => {
        const n = g.node(nodeId);

        // 1. Text splitter function
        const wrapText = (text, maxCharsPerLine) => {
            const words = text.split(' ');
            const lines = [];
            let currentLine = '';

            words.forEach(word => {
                if ((currentLine + word).length &lt;= maxCharsPerLine) {
                    currentLine += word + ' ';
                } else {
                    lines.push(currentLine.trim());
                    currentLine = word + ' ';
                }
            });

            if (currentLine.length > 0) {
                lines.push(currentLine.trim());
            }

            return lines.join('\n');
        };

        const wrappedLabel = wrapText(n.label || nodeId, 15);

        let nd = diagramJson.nodes.find((n) => {
            return n.id == nodeId;
        });

        const isInterface = nd.type === 'Application_Provider_Interface';

        const fillColor = isInterface ? '#000000' : '#4285f4';
        const strokeColor = isInterface ? '#d3d3d3' : '#2a67c7';

        // Determine the size of the node based on the wrapped text
        const nodeWidth = Math.max(100, wrappedLabel.length * 5);  // Dynamic width based on text
        const nodeHeight = Math.max(50, wrappedLabel.split('\n').length * 18); // Dynamic height based on number of lines

        const rect = new joint.shapes.standard.Rectangle({
            id: nodeId,
            position: { x: n.x, y: n.y },
            size: { width: nodeWidth, height: nodeHeight },  // Adjusted size
            attrs: {
                body: {
                    fill: fillColor,
                    stroke: strokeColor,
                    strokeWidth: 2,
                    rx: 5,
                    ry: 5
                },
                label: {
                    text: wrappedLabel,
                    style: {
                        fill: 'white',
                        fontFamily: 'Arial, sans-serif',
                        textAnchor: 'middle',
                        textVerticalAnchor: 'middle',
                        fontSize: Math.max(10, 15 - wrappedLabel.split('\n').length)  // Shrink text if it's long
                    }
                }
            }
        });

        appgraph.addCell(rect);
        nodeMap[nodeId] = rect;
    });

    diagramJson.edges.forEach(edge => {
        if (nodeMap[edge.source] &amp;&amp; nodeMap[edge.target]) {
            const link = new joint.shapes.standard.Link({
                source: { id: nodeMap[edge.source].id },
                target: { id: nodeMap[edge.target].id },
                router: { name: 'manhattan' },
                connector: { name: 'rounded' },
                attrs: {
                    line: {
                        stroke: '#333333',
                        strokeWidth: 1,
                        targetMarker: {
                            type: 'path',
                            d: 'M 10 -5 0 0 10 5 z'
                        }
                    }
                },
                labels: [
                    {
                        position: 0.5,
                        attrs: {
                            text: {
                                text: '',  // Add edge labels if needed
                                style: {
                                    fill: 'black',
                                    fontSize: 8,
                                    fontFamily: 'Arial, sans-serif'
                                }
                            },
                            rect: {
                                fill: 'none'
                            }
                        }
                    }
                ]
            });
            appgraph.addCell(link);
        }
    });

    // 🛠 Now that ALL nodes and edges are added — do fit and scale
    apppaper.fitToContent({
        padding: 20,
        allowNewOrigin: 'any',
        useModelGeometry: true
    });

    apppaper.scaleContentToFit({
        padding: 20,
        preserveAspectRatio: true,
        minScale: 0.5,
        maxScale: 2
    });
}



		const exampleDiagram = {
			nodes: nodes,
			edges: edges
		};
		
		renderDiagram(exampleDiagram);
 
	}
	
	}).then(function(){
	$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
	$($.fn.dataTable.tables(true)).DataTable()
	.columns.adjust();
	});
	
	
	})
	
	$('#subjectSelection').off().on('change',function(){
 
	let selected=$(this).val(); 
	
	let newfocusApp=scopedApps.resources.find((f)=>{
		return f.id==selected;
	});
 
	focusApp=newfocusApp;  
	$('#selectMenu').html(selectTemplate(focusApp))
	
	$('.context-menu-appProviderGenMenu').html('<i class="fa fa-bars"></i> Menu');
	  
	redrawPage(focusApp);
	});
	}
var redrawView = function () {
	// Move your existing logic here that builds column headers, DataTables config, etc.
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
	<xsl:template match="node()" mode="decisions">
		{
			<xsl:variable name="impacts" select="key('instance', current()/own_slot_value[slot_reference = 'decision_elements']/value)"/> 
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
			"className":"<xsl:value-of select="current()/type"/>"	
			<!-- Precompute all cleaned values in variables -->
			<xsl:variable name="name" select="translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')"/>
			<xsl:variable name="description" select="translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')')"/>
			<xsl:variable name="governance_reference" select="translate(translate(current()/own_slot_value[slot_reference = 'governance_reference']/value, '}', ')'), '{', ')')"/>
			<xsl:variable name="decision_date" select="translate(translate(current()/own_slot_value[slot_reference = 'decision_date_iso_8601']/value, '}', ')'), '{', ')')"/>
			<xsl:variable name="owner" select="translate(translate(current()/own_slot_value[slot_reference = 'decision_made_by_actor']/value, '}', ')'), '{', ')')"/>
			<!-- Construct the combined map in one step -->
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': $name,
				'description': $description,
				'governance_reference': $governance_reference,
				'decision_date': $decision_date,
				'owner': $owner
			}"/>
			<!-- Directly serialize the map to JSON without extra processing -->
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':false()})"/>,
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> ,
			<!-- Process impacts -->
			"impacts":[
			<xsl:for-each select="$impacts">
				{
					"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
					"className":"<xsl:value-of select="current()/type"/>",
					<!-- Precompute impact name once -->
					<xsl:variable name="impactName" select="translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')"/>
					<!-- Create map for each impact -->
					<xsl:variable name="impactMap" as="map(*)" select="map{
						'name': $impactName
					}"/>
					<!-- Serialize each impact map directly -->
					<xsl:variable name="resultCombined" select="serialize($impactMap, map{'method':'json', 'indent':false()})"/>
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
					<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>	 
				}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>]
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
