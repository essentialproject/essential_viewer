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
	<xsl:variable name="linkClasses" select="('Data_Subject', 'Data_Object', 'Supplier', 'Data_Object_Attribute', 'Group_Actor', 'Individual_Actor', 'Application_Provider', 'Application_Service', 'Group_Business_Role', 'Individual_Business_Role', 'Business_Process', 'Composite_Application_Provider', 'Data_Representation', 'Data_Representation_Attribute','Information_Representation', 'Technology_Product','Technology_Node','Data_Object','Project', 'Enterprise_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentDataObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="appMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>
	<xsl:variable name="doData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	<xsl:variable name="orgData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"></xsl:variable>
	<xsl:variable name="apiPathAppCost" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Cost']"/>
	<xsl:variable name="appLifecycleData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Lifecycles']"></xsl:variable>
	<xsl:variable name="kpiListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: App KPIs']"></xsl:variable>
	<xsl:variable name="allPhysProcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
	<xsl:variable name="allPlansData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"></xsl:variable>
	<xsl:variable name="techProdData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get All Tech Product Roles']"></xsl:variable>

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

				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css?release=6.19" type="text/css" rel="stylesheet"></link>
				<script src="js/chartjs/Chart.min.js?release=6.19"></script>
				<script src="js/chartjs/chartjs-plugin-labels.min.js?release=6.19"></script>
				<link href="js/chartjs/Chart.css?release=6.19" type="text/css" rel="stylesheet"></link>
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"></script>
				<script src="js/dagre/dagre-d3.min.js?release=6.19"></script>
				<script src="js/FileSaver.min.js?release=6.19"></script>
				<script src="js/jszip/jszip.min.js?release=6.19"></script>

				<style type="text/css">
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
					.classiflist{
					    position: absolute;
					    bottom: 5px;
					    left: 5px;
					}
					.datatype{
					    display: inline-block;
					    width: 250px;
					}
					.datacrud{
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
					    background-color: #ccc;
					}
					
					.tech-item-label{
					    width: 400px;
					    display: inline-block;
					    font-weight: bolder;
					}
					.tech-item-label-sub{
					    width: 400px;
					    display: inline-block;
					    color: #fff;
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
					.chart-container{
					    width: 500px;
					    height: 300px;
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
					​​​​​​​​​​​ #editor-spinner{
					    height: 100vh;
					    width: 100vw;
					    position: fixed;
					    top: 0;
					    left: 0;
					    z-index: 999999;
					    background-color: hsla(255, 100%, 100%, 0.75);
					    text-align: center;
					}
					​​​​​​​​​​​ #editor-spinner-text{
					    width: 100vw;
					    z-index: 999999;
					    text-align: center;
					}
					​​​​​​​​​​​ .spin-text{
					    font-weight: 700;
					    animation-duration: 1.5s;
					    animation-iteration-count: infinite;
					    animation-name: logo-spinner-text;
					    color: #aaa;
					    float: left;
					}
					​​​​​​​​​​​ .spin-text2{
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
					    background-color: #fff;
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
						min-width: 190px;
						width: 190px;
						text-align: center;
						margin-right: 1.5rem;
						margin-bottom: 1.5rem;
						border-radius: 15px;
						border: none;
						-webkit-box-shadow: 0px 2px 4px 1px rgba(79, 79, 79, 0.3);
						-moz-box-shadow: 0px 2px 4px 1px rgba(79, 79, 79, 0.3);
						box-shadow: 0px 2px 4px 1px rgba(79, 79, 79, 0.3);
					  }
					  .service-card-container .card .c-header {
						height: 8.5vh;
						padding: 0.8em;
						background-color: #f6f6f6;
						display: flex;
						justify-content: center;
						align-items: flex-start;
						text-align: center;
						width: 100%;
						margin: 0 auto;
						border-radius: 15px 15px 0 0;
					  }
					  .service-card-container .card .c-header p {
						font-weight: 600;
						font-size: 0.85em;
						margin-bottom: 0;
						line-height: 1.5rem;
					  }
					  .service-card-container .card .c-body {
						padding: 0.8rem 0.9rem;
						font-size: 0.8em;
						line-height: 1.2em;
						color: #5c5c5c;
						height: 10vh;
						overflow-y: scroll;
						margin-bottom: 1rem;
						font-weight: 400; 
					  }
					  .service-card-container .card .c-footer {
						height: 3vh;
						background-color: #f6f6f6;
						border-radius: 0 0 15px 15px;
						display: flex;
						justify-content: center;
						align-items: center;
						 
					  }
					  .service-card-container .card .c-footer p {
						font-size: 0.8em;
						margin-bottom: 0;
						font-weight: 800;
					  }
					  .service-card-container .card .c-footer .footer-badge {
						font-size: 0.5em;
						background-color: #69c9ff;
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
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Summary for')"/> </span>&#160;
										<span class="text-primary headerName"><select id="subjectSelection" style="width: 600px;"></select></span>
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
									<h4 class="modal-title">Application Analysis</h4>
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
									<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
								</div>
							</div>
						</div>
					</div>

				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
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
					
				</xsl:call-template>  
			</script>	
			<script>


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
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Application Details</a>
						</li> 
						{{#if this.allServices.0.serviceName}}	
						<li>
							<a href="#appservices" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Application Services</a>
						</li> 
						{{/if}}
						
						{{#if this.processInfo}}	
						<li>
							<a href="#appProcesses" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Business Processes</a>
						</li> 
						{{/if}}
						{{#if this.inIList}}
						<li>
								<a href="#appIntegration" data-toggle="tab" id="appIntTab"><i class="fa fa-fw fa-tag right-10"></i>Integrations</a>
							</li> 
						{{else}}
						{{#if this.outIList}}
						<li>
							<a href="#appIntegration" data-toggle="tab" id="appIntTab"><i class="fa fa-fw fa-tag right-10"></i>Integrations</a>
						</li> 
						{{/if}}
						{{/if}}
						{{#if this.applicationTechnology.db}}	
						<li>
							<a href="#appTech" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Technology</a>
						</li> 
						{{else}}
						{{#if this.applicationTechnology.environments}}
							<li>
								<a href="#appTech" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Technology</a>
							</li> 
						{{/if}}
						{{/if}}
						{{#if this.costs}}	
						<li>
							<a href="#appcosts" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Application Cost</a>
						</li> 
						{{/if}}
						{{#if this.dataObj}}	
						<li>
							<a href="#appdata" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Application Data</a>
						</li> 
						{{/if}}
						{{#if this.lifecycles}}	
						<li>
							<a href="#appLifecycle" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Application Lifecycle</a>
						</li> 
						{{/if}}
						{{#if this.pm}}	
						<li>
							<a href="#appKpis" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i>Application KPIs</a>
						</li> 
						{{/if}}
						{{#if this.issues}}
						<li>
							<a href="#issues" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i >Issues</a>
						</li>
						{{/if}}
						{{#if this.plans}}
						<li>
							<a href="#appPlans" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i >Plans &amp; Projects</a>
						</li>
						{{/if}}
						{{#if this.otherEnums}}
						<li>
							<a href="#otherEnums" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i >Other</a>
						</li>
						{{/if}}
						{{#if this.documents}}
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
							<h2 class="print-only"><i class="fa fa-fw fa-desktop right-10"></i>Application Details</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Application</h3>
									<label>Name</label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label>Description</label>
									<div class="ess-string">{{this.description}}</div>
									<div class="clearfix bottom-10"></div>
									{{#if this.ap_business_criticality}}
									<label>Business Criticality</label>
									<div class="ess-string">{{#getInfo this.ap_business_criticality 'Business_Criticality'}}{{/getInfo}}</div>
									<div class="clearfix bottom-10"></div>
									{{/if}}
									{{#if this.supplier}}
									<label>Application Supplier</label>
									<div class="ess-string">{{#essRenderInstanceMenuLink this.supplier}}{{/essRenderInstanceMenuLink}}</div>
									{{/if}}
									{{#if this.family}}
									<label>Application Family</label>
									<ul class="ess-list-tags">
										{{#each this.family}}
										<li class="family-tag" style="background-color: rgb(68, 182, 179)">{{this.name}}</li>
										{{/each}}
									</ul>
									{{/if}}
									
									 
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i>Key Information</h3>
							 
									<label>Lifecycle Status</label>
									<div class="bottom-10">
											{{#if this.lifecycle_status_application_provider}}
											 {{#getInfo this.lifecycle_status_application_provider 'Lifecycle_Status'}}{{/getInfo}} 
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label>Codebase</label>
									<div class="bottom-10">
											{{#if this.ap_codebase_status}}
											 {{#getInfo this.ap_codebase_status 'Codebase_Status'}}{{/getInfo}} 
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label>Delivery Model</label>
									<div class="bottom-10">
											{{#if this.ap_delivery_model}} 
											{{#getInfo this.ap_delivery_model 'Application_Delivery_Model'}}{{/getInfo}}  
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label>Disposition</label>
									<div class="bottom-10">
											{{#if this.ap_disposition_lifecycle_status}} 
											{{#getInfo this.ap_disposition_lifecycle_status 'Disposition_Lifecycle_Status'}}{{/getInfo}}  
											 
											{{else}}
											<span class="label label-warning">Not Set</span>
											{{/if}}
									</div>
									<label>Purpose</label>
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
									<h3 class="text-primary"><i class="fa fa-building right-10"></i>Ownership</h3>
									 
										{{#each this.stakeholders}}
											{{#ifContains this 'Owner'}}{{/ifContains}}
										{{/each}}
									<div class="clearfix bottom-10"></div>  
								</div> 
								{{/if}}
								{{#if this.children}}
								<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-sites right-10"></i>Contained Applications</h3>
									{{#each this.children}}
									<span class="label label-eas" style="border-bottom:2pt solid #0078ff59">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
									{{/each}}
								</div>
									
								{{/if}}
								<div class="col-xs-12"/>
								{{#if this.classifications}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i>Relevant Regulations</h3>
									<div>
										<b>Mapped via Data Objects:</b>
										{{#each this.classifications}}<span class="label label-info   right-10" style="background-color: #476ecc">{{this.name}}</span>{{/each}}
									</div>
									{{#if this.regulations}}
									<div>
										<b>Mapped directly to application: </b>
										{{#each this.regulations}}<span class="label label-info right-5" style="background-color: #476ecc">{{this.name}}</span>{{/each}}
									</div>
									{{/if}}
								</div>
								{{else}}
									{{#if this.regulations}}
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-list-alt right-10" style="background-color: #476ecc"></i>Relevant Regulations</h3>
										{{#each this.regulations}}
											<span class="label label-info right-5">{{this.name}}</span>
										{{/each}}
									</div>
									{{/if}}
								 {{/if}}
								 
								<div class="col-xs-12"/>
								{{#if this.stakeholdersList}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i>People &amp; Roles</h3>
									
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
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i>Organisations &amp; Roles</h3>
									
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
								 
							<div class="clearfix bottom-10"></div>
							 <!-- SVG TEST-->
							
						</div>
						</div>	 
						<div class="tab-pane svgTab" id="appIntegration">
							<div class="parent-superflex">
								<div class="superflex">
									<div>
										<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Integrations</h3>
										<p>High-level integration view of <u>application-level</u> integrations.  See detailed view for a higher level of granularity, including APIs and data flow information.</p>
										<div class="pull-right"><button class="btn btn-success interfaceButton"><xsl:attribute name="easid">{{this.id}}</xsl:attribute>View Integration Detail</button></div>
									</div>						 
									<div id="svgBox">
										<svg width="800px" height="600px"/>
									</div>
								</div>
							</div>
						</div>
					 
						
						{{#if this.dataObj}}	
						<div class="tab-pane" id="appdata2">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i>Data Attributes</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Data Attributes</h3>
									<p>Attributes for this data object</p>
									<table id="dt_dobjecttable" class="table table-striped table-bordered" >
									<thead>
										<tr>
											<th>Name</th>
											<th>Description</th>
											<th>Type</th>
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
											<th>Name</th>
											<th>Description</th>
											<th>Type</th>
										</tr>
									</tfoot>
									</table>
								</div>
							</div>

						</div>
						{{/if}}
						
						{{#if this.processInfo}}	
						<div class="tab-pane" id="appProcesses">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i>Business Process Supported</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Business Process Supported</h3>
									<p>The application supports these business processes</p>
									<table id="dt_processtable" class="table table-striped table-bordered table-compact" >
									<thead>
										<tr>
											<th>Process</th>
											<th>Organisation</th>
											<th>Service</th>
											<th>Route</th>
										</tr>
										 
									</thead>
									<tbody>
									{{#each this.processInfo}}
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
									{{/each}}
									</tbody>
									<tfoot>
										<tr>
											<th>Process</th>
											<th>Organisation</th>
											<th>Service</th>
											<th>Route</th>
										</tr>
									</tfoot>
									</table>
								</div>
							</div>

						</div>
						{{/if}}
						{{#if this.applicationTechnology}}	
						<div class="tab-pane" id="appTech">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i>Application Technology</h2>
							<div class="parent-superflex">
								{{#if this.db}}
								<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Databases</h3>
										<p>The databases this application is using</p>
										
									{{#each this.db}}
										<i class="fa fa-database"></i>
									
										{{#essRenderInstanceMenuLink this.infoRep}}{{/essRenderInstanceMenuLink}}<br/>
									{{/each}}
								</div>
								{{/if}}
								{{#if this.applicationTechnology.environments}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Application Technology</h3>
									<div class="pull-left">The technology supporting this application, by environment</div>
									<div class="pull-right">
										<strong>Standards Key:</strong>
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
														<div class="pull-right left-5">Standards 
															<a tabindex="-1" class="popover-trigger" data-toggle="popover" style="color:#333;">
																<xsl:attribute name="easid">{​​​​​​​​​{​​​​​​​​​this.id}​​​​​​​​​}​​​​​​​​​</xsl:attribute>
																<i class="fa fa-info-circle"></i>
															</a>
															<div class="popover">
																<h5 class="strong">Standards</h5>
																<table class="table table-striped standardsTable">
																	<tr><th width="200px">Status</th><th width="300px">Organisation</th><th width="300px">Geography</th></tr>
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
							</div>

						</div>
						{{/if}}
						{{#if this.costs}}
						<div class="tab-pane" id="appcosts">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i>Costs</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<div class="costTotal-container">
										 
									</div>
								</div>
								<div class="superflex">
									<div class="chart-container">
										<canvas id="costByCategory-chart" ></canvas>
									</div>
								</div>
								<div class="superflex">
									<div class="col-xs-6">
										<div class="chart-container">
											<canvas id="costByType-chart" ></canvas>
										</div>
									</div>
									<div class="col-xs-5">
										<div class="chart-container">
											<canvas id="costByFrequency-chart" ></canvas>
										</div>
									</div> 
								</div>
								<div class="col-xs-12"/>
								<div class="superflex">
									<div class="full-width-chart-container" style="margin-bottom: 70px;">
										<canvas id="costByMonth-chart" height="70px"></canvas>
									</div>
								</div>
								<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Costs</h3>
									<p>Costs related to this application</p>
									<table class="table table-striped table-bordered display compact" id="dt_costs">
										<thead><tr><th>Cost</th><th>Type</th><th>Value</th><th>From Date</th><th>To Date</th></tr></thead>
										{{#each this.costs}}
										<tr>
											<td><span class="label label-primary">{{this.name}}</span></td>
											<td><span class="label label-primary">{{#getType this.costType}}{{/getType}}</span></td>
											<td>{{this.currency}}{{#formatCurrency this.cost}}{{/formatCurrency}}</td>
											<td>{{this.fromDate}}</td>
											<td>{{this.toDate}}</td>
										</tr>
										{{/each}}
										<tfoot><tr><th>Cost</th><th>Type</th><th>Value</th><th>From Date</th><th>To Date</th></tr></tfoot>
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
									<p class="app-header"><xsl:text> </xsl:text> Application Services</p>
								  </div>
								  <div class="sub-text">
									Application Services for this application with lifecycle status and
									function supported
								  </div>
								  <div class="pill-badge-container">
									<p class="key">Key:</p>
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
										<p>{{#essRenderInstanceLinkOnly this.linkDetails 'Application_Service'}}{{/essRenderInstanceLinkOnly}}</p>
									  </div>
									  <div class="c-body">
										{{this.description}}
									  </div>
									  <div class="c-footer">
										<p>
										  {{#if this.functions}}
											<div style="font-size:0.8em">
												<small>
												{{this.functions.length}}
												{{#ifEquals this.functions.length 1}}
													Function
													{{else}}
													Functions
												{{/ifEquals}} 
												</small>
												<a tabindex="-1" class="popover-trigger" data-toggle="popover">
													<xsl:attribute name="easid">{​​​​​​​​​{​​​​​​​​​this.id}​​​​​​​​​}​​​​​​​​​</xsl:attribute>
													<i class="fa fa-info-circle fa-xs"></i>
												</a>
												<div class="popover">
													Functions
													<p class="small text-muted">{{#each this.functions}}<i class="fa fa-angle-right"></i> {{this.name}}<br/>{{/each}}</p>
												</div> 
											</div> 
										{{/if}}
										{{#if this.processes}}
											<div style="margin-left:5px; font-size:0.8em">
												<small>
												{{this.processes.length}} 
												{{#ifEquals this.processes.length 1}}
												Process
												{{else}}
												Processes
												{{/ifEquals}}
												</small>
												<a tabindex="-1" class="popover-trigger" data-toggle="popover">
													<xsl:attribute name="easid">{​​​​​​​​​{​​​​​​​​​this.id}​​​​​​​​​}​​​​​​​​​</xsl:attribute>
													<i class="fa fa-info-circle fa-xs"></i>
												</a>
												<div class="popover">
													<h5 class="strong">Processes</h5>
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
									<p class="app-header">Alternative Application Services</p>
								  </div>
								  <div class="sub-text">
									Application Services this application has which are also provided by other applications
								  </div>
						  
								  <div class="service-card-container alternate">
									{{#each this.allServices}}
									<div class="card">
									  <div class="c-header">
										<p>{{#essRenderInstanceLinkOnly this.linkDetails 'Application_Service'}}{{/essRenderInstanceLinkOnly}}</p>
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
							<h2 class="print-only top-30"><i class="fa fa-fw fa-road right-10"></i>Application Lifecycles</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-road right-10"></i>Application Lifecycles</h3>
									<p>Lifecycles for the application</p>

									<i class="fa fa-chevron-circle-left right-5" id="lifecycleDown"></i><small>Move Start Date</small>
									
									<i class="fa fa-chevron-circle-right right-5" id="lifecycleUp"></i> 
									<div class="pull-right">
										<i class="fa fa-chevron-circle-left right-5" id="lifecycleEndDown"></i>
											<small>Move End Date</small>
										<i class="fa fa-chevron-circle-right right-5" id="lifecycleEndUp"></i> 
									</div>
								 <div id="lifecyclePanel"></div>
								</div>
							</div> 
						</div>
						{{/if}}
						{{#if this.pm}}	
						<div class="tab-pane" id="appKpis">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-area-chart right-10"></i>Application KPIs</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-area-chart right-10"></i>Application KPIs</h3>
								 
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
							<h2 class="print-only top-30"><i class="fa fa-fw fa-warning right-10"></i> Issues</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-fw fa-warning right-10"></i> Issues</h3>
									<div class="issuebox-wrapper">
									{{#each this.issues}}
										<div class="issueBox bg-offwhite">
					  						<b>Issue:</b><xsl:text> </xsl:text> {{this.name}} <br/>
											<b>Description:</b><xsl:text> </xsl:text> {{this.description}}<br/>
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
							<h2 class="print-only top-30"><i class="fa fa-fw fa-check-circle-o right-10"></i> Plans &amp; Projects</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i>Plans &amp; Projects</h3>
									<p>Plans and projects that impact this application</p>
									<h4>Plans</h4>
									{{#each this.plans}}
										<span class="label label-success">Plan</span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>&#160;
										<span class="label label-default">From</span>&#160;	{{#if this.validStartDate}} {{this.validStartDate}} {{else}}Not Set	{{/if}}
										<span class="label label-default">To</span>&#160;{{#if this.validEndDate}}{{this.validEndDate}}{{else}}Not Set  	{{/if}}
										<br/>
									{{/each}}
									{{#each this.aprplans}} 
										<span class="label label-success">Plan</span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong> &#160;
										<span class="label label-default">From</span>&#160;	{{#if this.validStartDate}} {{this.validStartDate}} {{else}}Not Set	{{/if}}
										<span class="label label-default">To</span>&#160;{{#if this.validEndDate}}{{this.validEndDate}}{{else}}Not Set  	{{/if}}
										<br/>
									{{/each}}
									{{#if this.projects}}
									<h4>Projects</h4>
									{{#each this.projects}}
										<span class="label label-primary">Project</span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}} </strong>
										<br/>
										<span class="label label-default">Proposed Start</span>&#160;{{#if this.proposedStartDate}}{{this.proposedStartDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Actual Start</span> &#160;{{#if this.actualStartDate}}{{this.actualStartDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Target End</span>&#160;{{#if this.targetEndDate}} {{this.targetEndDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Forecast End</span> &#160;{{#if this.forecastEndDate}}{{this.forecastEndDate}}  {{else}} Not Set{{/if}}
										<br/>
									
									{{/each}}
									{{#each this.aprprojects}}
										<span class="label label-primary">Project</span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</strong>
										<br/>
										<span class="label label-default">Proposed Start</span>&#160;{{#if this.proposedStartDate}}{{this.proposedStartDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Actual Start</span> &#160;{{#if this.actualStartDate}}{{this.actualStartDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Target End</span>&#160;{{#if this.targetEndDate}} {{this.targetEndDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Forecast End</span> &#160;{{#if this.forecastEndDate}}{{this.forecastEndDate}}  {{else}} Not Set{{/if}}
										<br/>
									
									{{/each}}
									{{else}}
									{{#if this.aprprojects}} 
									<h4>Projects</h4>
									{{#each this.aprprojects}}
										<span class="label label-primary">Project</span>&#160;<strong>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}} </strong>
										<br/>
										<span class="label label-default">Proposed Start</span>&#160;{{#if this.proposedStartDate}}{{this.proposedStartDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Actual Start</span> &#160;{{#if this.actualStartDate}}{{this.actualStartDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Target End</span>&#160;{{#if this.targetEndDate}} {{this.targetEndDate}} {{else}} Not Set{{/if}}
										<span class="label label-default">Forecast End</span> &#160;{{#if this.forecastEndDate}}{{this.forecastEndDate}} {{else}} Not Set{{/if}}
										<br/> 
									
									{{/each}}
									{{/if}}
									{{/if}}
									
								</div>
							
								<div class="col-xs-12"/>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-cogs right-10"></i>Impacts</h3>
									<p>Projects impacting this application and actions they are taking on this application </p>
									{{#if this.projectElements}}
									{{#each this.projectElements}}
										<span class="label label-success">Plan</span>&#160;{{#essRenderInstanceMenuLink this.planInfo}}{{/essRenderInstanceMenuLink}}
										<br/>
										<span class="label label-primary">Project</span>&#160;{{#essRenderInstanceMenuLink this.projectInfo}}{{/essRenderInstanceMenuLink}}<br/>
										<span class="label label-default">Proposed Start</span>&#160;{{#if this.projForeStart}}{{this.projForeStart}} {{else}} Not Set{{/if}} 
											<span class="label label-default">Actual Start</span> &#160;{{#if this.projActStart}}{{this.projActStart}} {{else}} Not Set{{/if}} 
											<span class="label label-default">Target End</span>&#160;{{#if this.projTargEnd}}{{this.projTargEnd}} {{else}} Not Set{{/if}} 
											<span class="label label-default">Forecast End</span> &#160;{{#if this.projForeEnd}}{{this.projForeEnd}} {{else}} Not Set{{/if}}  
											<br/>
											<span class="label label-info">Action</span>&#160;<span class="label label-default"><xsl:attribute name="style">color:{{this.textColour}};background-color:{{this.colour}}</xsl:attribute>{{this.action}}</span>
										
										<hr/>
									{{/each}}
									{{#each this.aprprojectElements}}
										<span class="label label-success">Plan</span>&#160;{{this.plan}}&#160;
										<br/>
										<span class="label label-primary">Project</span>&#160;{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}&#160;<br/>
										<span class="label label-default">Proposed Start</span>&#160;{{#if this.proposedStartDate}} {{this.proposedStartDate}}  {{else}} Not Set{{/if}}
											<span class="label label-default">Actual Start</span> &#160;{{#if this.actualStartDate}}{{this.actualStartDate}} {{else}} Not Set{{/if}} 
											<span class="label label-default">Target End</span>&#160;{{#if this.targetEndDate}} {{this.targetEndDate}}  {{else}} Not Set{{/if}}
											<span class="label label-default">Forecast End</span> &#160;{{#if this.forecastEndDate}}{{this.forecastEndDate}} {{else}} Not Set{{/if}}  
											<br/>
											<span class="label label-info">Action</span>&#160;<span class="label label-default"><xsl:attribute name="style">color:{{this.textColour}};background-color:{{this.colour}}</xsl:attribute>{{this.apraction}}</span>
										
										<hr/>
									{{/each}}
									{{else}}
									{{#if this.aprprojectElements}}
									{{#each this.aprprojectElements}}
										<span class="label label-success">Plan</span>{{#essRenderInstanceMenuLink this.planInfo}}{{/essRenderInstanceMenuLink}}
										<br/>
										<span class="label label-primary">Project</span>{{#essRenderInstanceMenuLink this.projectInfo}}{{/essRenderInstanceMenuLink}}<br/>
										<span class="label label-default">Proposed Start</span>&#160;{{#if this.proposedStartDate}} {{this.proposedStartDate}}  {{else}} Not Set{{/if}}
											<span class="label label-default">Actual Start</span> &#160;{{#if this.actualStartDate}}{{this.actualStartDate}} {{else}} Not Set{{/if}} 
											<span class="label label-default">Target End</span>&#160;{{#if this.targetEndDate}} {{this.targetEndDate}}  {{else}} Not Set{{/if}}
											<span class="label label-default">Forecast End</span> &#160;{{#if this.forecastEndDate}}{{this.forecastEndDate}} {{else}} Not Set{{/if}}  
											<br/>
											<span class="label label-info">Action</span>&#160;<span class="label label-default"><xsl:attribute name="style">color:{{this.textColour}};background-color:{{this.colour}}</xsl:attribute>{{this.apraction}}</span>
											
										<hr/>
									{{/each}}
									{{else}}
									<strong>No impacts recorded</strong>
									{{/if}}
									{{/if}}
								</div>
							</div>
						</div>
						{{/if}}
						{{#if this.otherEnums}}
						<div class="tab-pane" id="otherEnums">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-comment right-10"></i> Other</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-comment right-10"></i>Other</h3>
									<p>Other values against this application</p>
									{{#each this.otherEnums}}
									{{#ifEquals this.classNm 'distribute costs'}}
									
										{{#ifEquals ../this.otherEnums.length 1}}
											<b>No additional enumerations set</b>
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
				<!--			<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Applications</h3>
									{{#each thisAppArray}}
									{{#each this.values}}
									<div class="appCard">  
										{{../this.dataObject}}<br/>
												<span class="appHeader"><strong>Appears In:</strong> {{this.nameirep}}</span><br/>
												{{#if this.datarepsimplemented}}
												<span class="dbicon">{{this.category}}</span>
												<span class="appTableHeader"><strong>Where:</strong></span><br/>
												
												{{#each this.datarepsimplemented}}
													<span class="appTableHeader">{{#getDataRep this.dataRepid}}{{/getDataRep}}</span><br/>
													<div class="ess-crud">C: {{#CRUDVal this.create}}{{/CRUDVal}}</div>
													<div class="ess-crud">R: {{#CRUDVal this.read}}{{/CRUDVal}}</div>
													<div class="ess-crud">U: {{#CRUDVal this.update}}{{/CRUDVal}}</div>
													<div class="ess-crud">D: {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
													<br/>
												{{/each}}
												{{else}}
												 
													<div class="ess-crud">C: {{#CRUDVal this.create}}{{/CRUDVal}}</div>
													<div class="ess-crud">R: {{#CRUDVal this.read}}{{/CRUDVal}}</div>
													<div class="ess-crud">U: {{#CRUDVal this.update}}{{/CRUDVal}}</div>
													<div class="ess-crud">D: {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
												
												{{/if}}
												<br/> 
									</div>
									{{/each}}
									{{/each}}
								</div>
							</div>
						-->				
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Applications</h3>
									<div class="bottom-15">
										<label>Data Object:</label><select class="filters" id="doFilter"><option name="all" value="all">All</option></select>
										<!--					 
										<label class="left-30">Info Representation:</label><select class="filters" id="irFilter"><option name="all" value="all">All</option></select> 
										-->
										<span class="classificationFilter left-30">
											<label>Classification:</label><select class="filters classificationFilter" id="classificationFilter"><option name="all" value="all">All</option></select>
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
													<div class="bottom-5"><strong>Appears in: </strong><span class="label label-link bg-darkgrey">{{#essRenderInstanceMenuLink this.irInfo}}{{/essRenderInstanceMenuLink}}</span></div>
													{{#if this.datarepsimplemented}}
													<span class="dbicon">{{this.category}}</span>
													<span class="classiflist">{{#each ../this.classifications}}<span class="label label-info">{{this.name}}</span>{{/each}}</span>
													<span class="appTableHeader"><strong>Where:</strong></span><br/>
													
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
											</div>
										{{/each}}
									</div>
								</div>
							</div>
						</div>
						{{#if this.documents}}
						<div class="tab-pane" id="documents">
						<div class="parent-superflex">
							<div class="superflex">
								<h3 class="text-primary"><i class="fa fa-desktop right-10"></i>Documentation</h3>
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
		<h3 class="text-primary"><i class="fa fa-money right-10"></i><b>Costs</b></h3>
		
		<h3><b>Annual Cost</b>: {{this.annualCost}}</h3>
		<h3><b>Monthly Cost</b>: {{this.monthlyCost}}</h3>
	</script>
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
	
			showEditorSpinner('Fetching Data...'); 
			var focusAppId='<xsl:value-of select="$param1"/>'
			var allDO=[];
			var appList=[];
			var byPerfName, defaultCcy; 
			var stakeholdertable, interfaceReport;
			var stakeholdertable2, costTotalTemplate; 
			var pmc, procServices,table, costtable, appServiceList;
			var projectElementMap=[];
			var planElementMap=[];
			var today=new Date();
			var yearsArray=[];
			var svgStartDate=new Date (today.setFullYear(today.getFullYear() - 2)); 
			var svgEndDate=new Date (today.setFullYear(today.getFullYear() + 3));
			var svgWidth=1000;
			$('document').ready(function (){ 
				<xsl:call-template name="wordHandlebarsJS"/>

				Handlebars.registerHelper('getDataRep', function(arg1) {
					let thisDr = DRList.find((dr)=>{
						return dr.id==arg1;
					});
				 
					return thisDr.name;
				});

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

				Handlebars.registerHelper('getLifeColour', function(arg1, arg2) {
					 
					let list=appList.filters.find((e)=>{
						return e.id==arg2
					}) 
					let itemVals=list.values.find((f)=>{
						return f.id==arg1;
					})

					if(itemVals){
					return 'border-bottom: 3px solid '+itemVals.backgroundColor
					}
					else{
						return 'border-bottom: 3px solid none';
					}

				});

				

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
				promise_loadViewerAPIData(viewAPIDataTech)
				]).then(function (responses){  
					allDO=responses[0];
					let focusDO=allDO.data_objects[0];
					DOList=responses[0] ; 
					DRList=responses[0].data_representation ; 
					appList=responses[1]; 
					orgsRolesList=responses[2].a2rs
					appMart=responses[3];
					allPerfMeasures=responses[5]
					appLifecycles=responses[4];
					physProc=responses[6]; 
					plans=responses[7]; 
					techProds=responses[8]; 
					removeEditorSpinner();
					appMart.application_capabilities=[];
					appMart.capability_hieararchy=[]; 
					interfaceReport=appList.reports.filter((d)=>{return d.name=='appInterface'});
					let thefocusApp=appList.applications.find((e)=>{return e.id==focusAppId});
 
					let appDataMap=[];
			//console.log('appMart',appMart)
			defaultCurrency = appMart.ccy.find(currency => currency.default === "true");
			//console.log('defaultCurrency',defaultCurrency)
					<!-- create project pairs for speed -->
					
					plans.allProject.forEach((p)=>{
					 
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
					plans.allPlans.forEach((p)=>{
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


					allDO.data_objects.forEach((e)=>{
					 
							let theDrs=[]
							e.dataReps.forEach((f)=>{
								f['className']='Data_Representation';
								let thisDr=DRList.find((dr)=>{
									return dr.id ==f.id;
								}); 
								theDrs.push(thisDr)
							});
							e['dataReps']=theDrs
							
							e.infoRepsToApps.forEach((rep)=>{
								rep['irInfo']={"name":rep.nameirep, "id":rep.idirep, "className":"Information_Representation"};
							})
						
							var nested_apps = d3.nest()
								.key(function(f) { return f.name; })
								.entries(e.infoRepsToApps);
								nested_apps=nested_apps.sort((a, b) => a.key.localeCompare(b.key))
 
							e['appsArray']=nested_apps;
					

							e.infoRepsToApps.forEach((ap)=>{
								ap['className']='Data_Representation';
								appDataMap.push({"id":ap.appid, "dataObjects":e})
							})
						});

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
									thisAppArray.push(filtered[0]);
									if(am.classifications[0]){
										appClassifications.push(am.classifications[0])
									}
								}
							})
							ap['thisAppArray']=thisAppArray
							ap['dataObj']=appMap.dataObj;
						}
						
						appClassifications=appClassifications.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)
						ap['classifications']=appClassifications;
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
					});
		
					appServiceList= d3.nest()
						.key(function(f) { return f.svcId; })
						.entries(appServicePairs);	 
						
					appLifecycles.application_lifecycles=[];
					$('#subjectSelection').select2();  
					$('#subjectSelection').val(focusAppId).change();
					
					
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
					 				
						let itemVals=list.values.find((f)=>{
							return f.id==arg1;
						})
					 
						return '<span class="label label-info" style="background-color: '+itemVals.backgroundColor+';color:'+itemVals.color+'">'+itemVals.name+'</span>';
						}
					});
					
			
					redrawPage(thefocusApp)
	});

function redrawPage(focusApp){ 
	
	if (focusApp.children) {
		focusApp.children = focusApp.children.map(d => appList.applications.find(f => d === f.id)).filter(Boolean);
	}
 
 
let panelSet = new Promise(function(myResolve, myReject) {
 
let filterenumerationValues=[];
let focusKeys=Object.keys(focusApp)
 
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
let itemsToRemove=[{'class': 'Lifecycle_Status'},{'class': 'Disposition_Lifecycle_Status'},{'class': 'Codebase_Status'},{'class': 'Application_Purpose'},{'class': 'Application_Delivery_Model'}];
 
const clsToRemove = itemsToRemove.map(item => item.class);
const filteredArray = appEnums.filter(item => !clsToRemove.includes(item.class))
  
if(filteredArray){
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

	allDO.app_infoRep_Pairs = allDO.app_infoRep_Pairs.map(item => ({
		...item,
		className: 'Information_Representation'
	}));

	
	let thisDB=allDO.app_infoRep_Pairs.filter((ap)=>{
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
		let thisProjDetail=plans.allProject.find((p)=>{
			return d.projectID==p.id
		})
		thisProj.push(thisProjDetail);
		if(thisProjDetail.proposedStartDate){
			d['projForeStart']=thisProjDetail.proposedStartDate;
			d['projActStart']=thisProjDetail.actualStartDate;
			d['projForeEnd']=thisProjDetail.forecastEndDate;
			d['projTargEnd']=thisProjDetail.targetEndDate;
		}
		let thisPlans=plans.allPlans.find((p)=>{
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
		let thisProjDetail=plans.allProject.find((p)=>{
			return d.projectID==p.id
		})
		d['planInfo']={"id":d.planid, "name":d.plan, "className":"Enterprise_Strategic_Plan"};
		d['projectInfo']={"id":d.projectID, "name":d.projectName, "className":"Project"}
		 
		thisProjDetail['plan']=d.plan;
		thisProjDetail['planId']=d.planid;
		thisProjDetail['apraction']=d.action;
	 
		thisaprProj.push(thisProjDetail);
		if(thisProjDetail.proposedStartDate){
			d['projForeStart']=thisProjDetail.proposedStartDate;
			d['projActStart']=thisProjDetail.actualStartDate;
			d['projForeEnd']=thisProjDetail.forecastEndDate;
			d['projTargEnd']=thisProjDetail.targetEndDate;
		}
		let thisaprPlans=plans.allPlans.find((p)=>{
			return d.planid==p.id
		})
		thisaprPlan.push(thisaprPlans)
	})
}) 

let resApr = {};
thisaprPlan.forEach(a => resApr[a.id] = {...resApr[a.id], ...a});
thisaprPlan = Object.values(resApr);
 
focusApp['aprplans']=thisaprPlan;
focusApp['aprprojects']=thisaprProj;

focusApp['aprprojectElements']=thisaprProj;
<!-- merge objects -->

let res = {};
thisPlan.forEach(a => res[a.id] = {...res[a.id], ...a});
thisPlan = Object.values(res);
  
	focusApp['plans']=thisPlan;
	focusApp['projects']=thisProj;
 
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
	 	
			allProcsforApps.push({"id":thisProcess.id,"name":thisProcess.processName, "className": "Business_Process", "orgid":thisProcess.orgid, "org":thisProcess.org, "svcid":thisAppSvc.id, "svcName":thisAppSvc.serviceName, "direction":"via Service"})
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
if(focusApp.stakeholders){
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
 
if(appDetail.documents){
	let docsCategory = d3.nest()
	.key(function(d) { return d.type; })
	.entries(appDetail.documents);
	
	focusApp['documents']=docsCategory;
}
let costByCategory=[];
let costByType=[];
let costByFreq =[];
if(appDetail.costs){
	focusApp['costs']=appDetail.costs;
	costByCategory = d3.nest()
		.key(function(d) { return d.costCategory; })
		.rollup(function(v) { return {
	total: d3.sum(v, function(d) { return d.cost; })
}})
.entries(appDetail.costs);


costByType = d3.nest()
.key(function(d) { return d.name; })
.rollup(function(v) { return {
	total: d3.sum(v, function(d) { return d.cost; })
}})
.entries(appDetail.costs);

costByFreq = d3.nest()
.key(function(d) { return d.costType; })
.rollup(function(v) { return {
	total: d3.sum(v, function(d) { return d.cost; })
}})
.entries(appDetail.costs);
}
let costDivider;
let fromDateArray=[];
let toDateArray=[];
let totalCostForPanel=0
if(appDetail.costs) {
	appDetail.costs.forEach((d)=>{
		if(d.fromDate!=''){
			fromDateArray.push(d.fromDate)
		}
		if(d.toDate!=''){
		toDateArray.push(d.toDate)
		}

	if(d.costType == "Adhoc_Cost_Component"){ 
			//calculate the number of months between start and end dates
			if(d.fromDate != null &amp;&amp; d.toDate != null) {
				let endDate = moment(d.toDate);
				let startDate = moment(d.fromDate);
				let monthDiff = endDate.diff(startDate, 'months', true);
				if(monthDiff > 0) {
					costDivider = monthDiff;
				}
			}
		}
	else 	
	if(d.costType == "Annual_Cost_Component"){ 
			//calculate the monthly cost by dividing the amount by 12
			costDivider = 12;
		}
	if(d.costType == "Quarterly_Cost_Component"){ 	
			//calculate the monthly cost by dividing the amount by 3
			costDivider = 3;					
	}
	if(d.costType == "Monthly_Cost_Component"){ 	
		//calculate the monthly cost by dividing the amount by 3
		costDivider = 1;					
}
	 
if(d.cost > 0) {
	d['monthlyAmount'] = d.cost / costDivider;									
}
})
}

appDetail.costs?.forEach((c)=>{
	totalCostForPanel=totalCostForPanel+c.monthlyAmount
})
 
let costNumbers={};
var formatter = new Intl.NumberFormat(undefined, {  });
costNumbers['annualCost']= appDetail.costs[0]?.currency + formatter.format(Math.round(totalCostForPanel) *12)
costNumbers['monthlyCost']= appDetail.costs[0]?.currency + formatter.format(Math.round(totalCostForPanel))
  
fromDateArray= fromDateArray.sort((a, b) => a.localeCompare(b))
toDateArray= toDateArray.sort((a, b) => a.localeCompare(b))
 

let momentStartFinYear = moment(fromDateArray[0]);
let momentEndFinYear = moment(toDateArray[toDateArray.length-1]);  
if(momentEndFinYear &lt; moment()) {momentEndFinYear=moment()}
let costChartRowList=[];
let costCurrency;
	appDetail.costs?.forEach(function(aCost) {
		costCurrency=aCost.ccy_code;
		if(!aCost.toDate){aCost['toDate']=momentEndFinYear.format('YYYY-MM-DD')}
		if(!aCost.fromDate  || aCost.fromDate == ''){aCost['fromDate']=momentStartFinYear.format('YYYY-MM-DD')}
		if((aCost.fromDate != null) &amp;&amp; (aCost.toDate != null)) {
			let thisStart = moment.max(moment(aCost.fromDate), momentStartFinYear);
			let thisEnd = moment.min(moment(aCost.toDate), momentEndFinYear);
			let monthCount = Math.max(thisEnd.diff(thisStart, 'months', true), 0);
			aCost['monthCount'] = Math.round(monthCount)+1;
			aCost['monthStart'] = Math.max(thisStart.diff(momentStartFinYear, 'months', true), 0);
			aCost['inScopeAmount'] = Math.round(aCost['monthlyAmount'] * monthCount);
		}
		
		let momentCostStart = moment(aCost.startDate);
		if((aCost.fromDate != null) &amp;&amp; ( moment(aCost.fromDate).isSameOrAfter(momentStartFinYear) ) &amp;&amp; ( moment(aCost.fromDate).isSameOrAfter(momentEndFinYear) )) {
		if( (aCost.fromDate != null) &amp;&amp; (moment(aCost.fromDate).isBetween(momentStartFinYear, momentEndFinYear, null, '[]'))  ) {
			aCost['inScopeAmount'] = aCost.cost;
		} else {
			aCost['inScopeAmount'] = 0;
		}
	}
	let costChartRow=[];
		for(i=1;i&lt;aCost.monthStart;i++){
			costChartRow.push(0)
		}
		for(i=0;i&lt;aCost.monthCount;i++){
			costChartRow.push(aCost.monthlyAmount)
		}
	
		costChartRowList.push(costChartRow)
})

let monthsListCount = Math.max(momentEndFinYear.diff(momentStartFinYear, 'months', true), 0);
let monthsList=[];


let sumsList=[]
for(i=0;i&lt;monthsListCount+1;i++){
	monthsList.push(moment(momentStartFinYear).add(i, 'months').format('MM/YYYY'));
	let tot=0;
	costChartRowList.forEach((e)=>{
		if(e[i]){
			tot=tot+e[i];
		}
	})
	sumsList[i] = tot;
}

cbcLabels=[];
cbcVals=[];
 
cbtLabels=[];
cbtVals=[];

cbfLabels=[];
cbfVals=[]; 
costByCategory.forEach((f)=>{ 
if(f.key=='undefined'){ 
f['key']='Run Cost'
} 
	cbcLabels.push(f.key);
	cbcVals.push(f.value.total);
})

costByType.forEach((f)=>{
	cbtLabels.push(f.key);
	cbtVals.push(f.value.total);
})

let totalCost=0;
costByFreq.forEach((f)=>{
	cbfLabels.push(f.key);
	cbfVals.push(f.value.total);
})
 
 
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
 
$('#mainPanel').html(panelTemplate(focusApp))


//get width for svg;
$('.interfaceButton').off().on('click', function(){
	let appId=$(this).attr('easid')
	location.href='report?XML=reportXML.xml&amp;XSL='+interfaceReport[0].link+'&amp;PMA='+appId
})

$('.costTotal-container').html(costTotalTemplate(costNumbers))
 
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

if(cbfLabels.length&gt;0){
new Chart(document.getElementById("costByFrequency-chart"), {
    type: 'doughnut',
    data: {
      labels: cbfLabels,
      datasets: [
        {
          label: "Frequency",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: cbfVals
        }
      ]
    },
    options: {
	responsive: true,
      title: {
        display: true,
        text: 'Cost By Frequency'
	  },
	  legend: {
		position: "right",
		align: "middle"
	}
    }
});


new Chart(document.getElementById("costByCategory-chart"), {
    type: 'doughnut',
    data: {
      labels: cbcLabels,
      datasets: [
        {
          label: "Type",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: cbcVals
        }
      ]
    },
    options: {
	  responsive: true,
      title: {
        display: true,
        text: 'Cost By Category'
	  },
	  legend: {
		position: "right",
		align: "middle"
	}
    }
});
 
new Chart(document.getElementById("costByType-chart"), {
    type: 'doughnut',
    data: {
      labels: cbtLabels,
      datasets: [
        {
          label: "Type",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: cbtVals
        }
      ]
    },
    options: {
	  responsive: true,
      title: {
        display: true,
        text: 'Cost By Type'
	  },
	  legend: {
		position: "right",
		align: "middle"
	}
    }
});
 
 

new Chart(document.getElementById("costByMonth-chart"), {
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
		scales: {
		  yAxes: [{
			ticks: {
			  beginAtZero: true,
			  callback: function(value) {
				 
				return new Intl.NumberFormat('en-US', { style: 'currency', currency: costCurrency }).format(value);
			  }
			}
		  }]
		},
		plugins: {
			labels: false // Disable the labels plugin for this chart
		  }
	  }
});

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
if(focusApp.thisAppArray){
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
if(focusApp.thisAppArray){
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

 byPerfName.forEach((d)=>{
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
	e.target // newly activated tab
	e.relatedTarget // previous active tab
	$(".ess-flat-card-title").matchHeight();
  });
 

function createSVGIntegration(data){ 
// Create the input graph
var g = new dagreD3.graphlib.Graph()
  .setGraph({})
  .setDefaultEdgeLabel(function() { return {}; });
  
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
 
}



}).then(function(){
$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
$($.fn.dataTable.tables(true)).DataTable()
.columns.adjust();
});


})

$('#subjectSelection').one('change',function(){
let selected=$(this).val(); 

let focusApp=appList.applications.find((f)=>{
	return f.id==selected;
});
 
redrawPage(focusApp);
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
<xsl:template match="node()" mode="dataSubject">
	
</xsl:template>
</xsl:stylesheet>