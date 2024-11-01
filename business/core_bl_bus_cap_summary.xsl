<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
 

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
    <xsl:param name="param1"></xsl:param>
	<xsl:variable name="aprs" select="/node()/simple_instance[type='Application_Provider_Role']"/>
	<!--
		* Copyright © 2008-2023 Enterprise Architecture Solutions Limited.
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
 
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Business_Process',  'Composite_Application_Provider', 'Application_Provider','Application_Service')"/>
	<!-- END GENERIC LINK VARIABLES -->

    <xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
 	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"></xsl:variable>
 	<xsl:variable name="capsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
 	<xsl:variable name="domData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Domains']"></xsl:variable>
 	<xsl:variable name="stratData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Strategic Data']"></xsl:variable>
	<xsl:variable name="proc2ServiceData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes to App Services']"></xsl:variable>
	<xsl:variable name="physproc2AppData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
	<xsl:variable name="allPlansData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"></xsl:variable>
	<xsl:variable name="kpiListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Bus KPIs'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"></xsl:variable>
	
	<xsl:template match="knowledge_base">
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
        <xsl:variable name="apiProcess">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$processData"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>    
        <xsl:variable name="apiCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$capsData"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable> 
        <xsl:variable name="apiDom">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$domData"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable> 
        <xsl:variable name="apiStrat">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$stratData"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiProc2Service">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$proc2ServiceData"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable> 
		<xsl:variable name="apiPhysProc2App">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$physproc2AppData"></xsl:with-param>
            </xsl:call-template>
        </xsl:variable> 
		<xsl:variable name="apiPlans">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$allPlansData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
        <xsl:variable name="apikpi">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$kpiListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title><xsl:value-of select="eas:i18n('Business Capability Summary')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css?release=6.19" type="text/css" rel="stylesheet"></link>
				<script src="js/d3/d3.min.js?release=6.19"></script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			<style>
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
						display:inline-block;
						height:22px;
						width:40px;
						border:1pt solid #d3d3d3;
						border-radius:4px;
						margin:2px; 
						font-size:1em;
						font-weight:bolder;
						background-color:#ffffff;
						color:#000;
						text-align: center;
						position:relative;  
						bottom:1px;
					}
					.ess-circle{
						height:15px;
						width:15px;
						border-radius: 15px;
						border:1pt solid #ffffff;
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
					
					.superflex  h3{
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
						background-color: #3c8996;
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

					.stack-item-instances {
						width: 40%;
						height: 300px;
						max-height: 300px;
						overflow-x: hidden;
						overflow-y: auto;
						min-height: 20px;
						flex-direction: column;
						border:1pt solid #d3d3d3;
						background-colour:#e3e3e3;
						display:flex;
						margin:2px;
						padding:2px;
						display: inline-block;
					}
					.tech-item-wrapper {
						padding: 5px;
						border-radius: 4px;
						margin-bottom: 10px;
						border: 1px solid #dedede;
						border-bottom: 1px solid #bbb;
						background-color:#c5c0c9;
					}
					 
					.tech-item-label {
						width: 400px;
						display: inline-block;
						font-weight:bolder;
					}
					.tech-item-label-sub {
						width: 400px;
						display: inline-block;
						color:#fff;
					}
					.tech-item-component {
						display: inline-block;
					}
					.family-tag{
						background-color: rgb(68, 182, 179)
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
								}
								.ess-flat-card-title{
								    padding: 10px;
								    background-color: #efefef;
								}
								.ess-flat-card-body{
								    padding: 10px;
								 
								}
								.ess-desc{
								    padding: 1px;
									min-height: 90px;
									max-height: 90px;
									overflow-y: auto;
								}
								.ess-flat-card-footer{
								    padding: 10px;
									position: relative
								
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
								}
								
								.ess-flat-card-widget > i{
								    font-size: 115%;
								}
								
								.ess-flat-card-widget > div{
								    font-weight: 700;
								    font-size: 80%;
								}
								.ess-flat-card-widget > i.text-muted{
								    color: #ccc;
								}
								.ess-flat-card-widget-badge{
								    padding: 2px 4px;
								
								}
								.fa-info-circle {
									cursor: pointer;
								}
								.chart-container {
									width: 500px;
									height:300px
								}
								.full-width-chart-container{
									width: 100%;
									height:200px
								}
								.selectAppClass{
									font-size:0.8em;
								}
								.perfBox{
						width:250px;
						display: inline-block;
						border:1pt solid #666;
						border-radius:4px;
						min-height:200px;
						vertical-align:top;
						padding: 5px 10px;
						margin-right: 10px;
						background-color: rgb(255, 255, 255);
						margin-top: 10px;
					}
					.perfScoreBoxRed,.perfScoreBoxAmber,.perfScoreBoxGreen {
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
						background-color:#FF0000;
						color:#fff;
					}
					.perfScoreBoxAmber{
						background-color:#FFBF00;
						color:#fff;
					}
					.perfScoreBoxGreen{
						background-color:#228B22;
						color:#fff;
					}
					.labelProcess{
						background-color: #876de6;
					}
					.labelOrg{
						background-color: #c13f71;
					}
					.labelLong{
						.white-space:normal; 
					}
					.eas-logo-spinner {​​​​
						display: flex;
						justify-content: center;
					}​​​​​​​​​​​
					#editor-spinner {​​​​​​​​​​​
						height: 100vh;
						width: 100vw;
						position: fixed;
						top: 0;
						left:0;
						z-index:999999;
						background-color: hsla(255,100%,100%,0.75);
						text-align: center;
					}​​​​​​​​​​​
					#editor-spinner-text {​​​​​​​​​​​
						width: 100vw;
						z-index:999999;
						text-align: center;
					}​​​​​​​​​​​
					.spin-text {​​​​​​​​​​​
						font-weight: 700;
						animation-duration: 1.5s;
						animation-iteration-count: infinite;
						animation-name: logo-spinner-text;
						color: #aaa;
						float: left;
					}​​​​​​​​​​​
					.spin-text2 {​​​​​​​​​​​
						font-weight: 700;
						animation-duration: 1.5s;
						animation-iteration-count: infinite;
						animation-name: logo-spinner-text2;
						color: #666;
						float: left;
					}​​​​​​​​​​​
					.keyLozenge{
						display:inline-block;
						width:60px;
						border-radius:8px;
						padding:2px;
						margin-right:3px;
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
						min-width: calc(100% - 10px);
						width: calc(100% - 10px);
						max-width: calc(100% - 10px);
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
					.bigger{
                        font-size:1.1em;
                    }
                    .objHolder{
                        border:1px solid #ccc;
                        border-radius: 4px;
                        padding:5px;
                        display:inline-block;
						width:350px;
						position: relative;
                    }
                    
                    .ess-bcs-obj-wrapper {
                    	display: flex;
                    	flex-wrap: wrap;
                    	gap: 10px;
                    }
                    
					.processBox{
                        border:1px solid #ccc;
                        border-radius: 4px;
                        padding:5px;
						min-height:60px;
						width:200px;
						vertical-align: top;
						border-bottom: 3px solid #a343c4;
                    }
                    
                    .ess-bcs-appservice-wrapper {
                    	display: flex;
                    	gap: 10px;
                    	flex-wrap: wrap;
                    	position: relative;
                    }
                    
					.serviceBox{
						border:1px solid #ccc;
						border-radius:4px;
						width: 500px;
						padding:5px;
						padding-bottom: 15px;
						position: relative;
					}
					.svName{
						border:1pt solid #d3d3d3;
						border-radius:3px;
						width: 200px; 
						background-color:#f2f2f2;
						display:inline-block; 
						padding:2px;
					}
					.svProcesses{
						display:inline-block; 
						padding:2px;
						margin-left:3px;
					}
					.processLabel {
						background-color: #e3e7d6 !important;
						font-size:0.85em;
					}
					.appLabel {
						background-color: #ddcce2 !important;
						font-size:0.85em;
					}
					.ess-bcs-info-wrapper {
						display: flex;
						gap: 10px;
						flex-wrap: wrap;
					}
					
					.infoConceptBox{
						border:1px solid #ccc;
						border-radius:4px;
						width: 300px; 
						padding:10px;
						margin:2px;
					}
					.infoDesc{
						padding:3px;
					}
					.selectAppClass{
					    position: relative;
						font-size:0.9em;
					    top: -3px;
					}
					
					.ess-bcs-process-wrapper {
						display: flex;
						gap: 10px;
						flex-wrap: wrap;
					}
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
	                                <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Capability Summary for')"/> </span>&#160;
	                            	<span class="text-primary headerName xselectAppClass"><select id="subjectSelection" style="width: 800px;"></select></span>
								</h1>
	                        </div>
	                    </div>
	                </div>
	
					<div class="clear"/>
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
	                <div id="mainPanel"/>
				</div>


				<!-- ADD THE PAGE FOOTER -->
                <xsl:call-template name="Footer"/>
                <script>			
                        <xsl:call-template name="RenderViewerAPIJSFunction">
                            <xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
                            <xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param>  
                            <xsl:with-param name="viewerAPIPathProcess" select="$apiProcess"></xsl:with-param>  
                            <xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param>
                            <xsl:with-param name="viewerAPIPathDoms" select="$apiDom"></xsl:with-param>
                            <xsl:with-param name="viewerAPIPathStrat" select="$apiStrat"></xsl:with-param>
                            <xsl:with-param name="viewerAPIPathProc2Serv" select="$apiProc2Service"></xsl:with-param>
                            <xsl:with-param name="viewerAPIPathPhysProc2App" select="$apiPhysProc2App"></xsl:with-param>
                            <xsl:with-param name="viewerAPIPathPlans" select="$apiPlans"></xsl:with-param>
							<xsl:with-param name="viewerAPIPathkpi" select="$apikpi"></xsl:with-param>
                        </xsl:call-template>  
                    </script>          
                    <script id="panel-template" type="text/x-handlebars-template">

                        <div id="summary-content">
                            
                            <!--Setup Vertical Tabs-->
                            <div class="row">
                                <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
                                    <!-- required for floating -->
                                    <!-- Nav tabs -->
                                    <ul class="nav nav-tabs tabs-left">
                                        <li class="active">
                                            <a href="#details" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Business Capability Details')"/></a>
                                        </li> 
                                        
                                        {{#if this.processes}}	
                                        <li>
                                            <a href="#capProcesses" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Business Processes')"/></a>
                                        </li> 
                                        {{/if}}
                                        {{#if this.apps}}	
                                        <li>
                                            <a href="#capApps" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Applications')"/></a>
                                        </li> 
                                        {{/if}}
                                        {{#if this.costs}}	
                                        <li>
                                            <a href="#capcosts" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></a>
                                        </li> 
                                        {{/if}}
										{{#if this.infoConcepts}}	
                                        <li>
                                            <a href="#supportingInformation" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supporting Information')"/></a>
                                        </li> 
										{{/if}}
										{{#if this.servicesSupporting}}	
                                        <li>
                                            <a href="#SupportingApplicationServices" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supporting Application Services')"/></a>
                                        </li> 
										{{/if}}
                                        {{#if this.pm}}	
                                        <li>
                                            <a href="#capKpis" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Capability KPIs')"/></a>
                                        </li> 
                                        {{/if}}
                                        {{#if this.plans}}
                                        <li>
                                            <a href="#capPlans" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></a>
                                        </li>
                                        {{/if}}
										{{#if this.otherEnums}}
										<li>
											<a href="#otherEnums" data-toggle="tab"><i class="fa fa-fw fa-tag right-10"></i ><xsl:value-of select="eas:i18n('Other')"/></a>
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
                                            <h2 class="print-only"><i class="fa fa-fw fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Business Capability Details')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Business Capability Details')"/></h3>
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
                                                     
                                                </div>
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
                                                    <label><xsl:value-of select="eas:i18n('Domain(s)')"/></label>
                                                    {{#if this.domains}}
                                                    {{#each this.domains}}
                                                    <span class="label label-default">{{this.name}}</span>
                                                    {{/each}}
                                                    {{else}}
                                                        <div class="ess-string"><xsl:value-of select="eas:i18n('None Mapped')"/></div>
                                                    {{/if}}
                                                    <label><xsl:value-of select="eas:i18n('Parent(s)')"/></label>
                                                    {{#if this.parentBusinessCapability}}
                                                    {{#each this.parentBusinessCapability}}
                                                    <div class="bottom-10">
                                                                <span class="label label-warning">{{this.name}}</span> 
                                                    </div>   
                                                    {{/each}}
                                                    {{else}}
                                                    <div class="bottom-10">
                                                            <span class="label label-primry">None</span> 
                                                    </div>   
                                                    {{/if}}                                             
                                                </div>
                                            	<div class="col-xs-12"/>
                                            </div>
                                        	
	                                        <div class="parent-superflex">       
	                                            <div class="superflex"> 
	                                            <h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Sub Capabilities')"/></h3> 
	                                            <div id="busCapModel"/>
	                                            </div>
	                                        	<div class="col-xs-12"/>
	                                        </div>
											{{#if this.drivers}} 
	                                        <div class="parent-superflex"> 
	                                            <div class="superflex"> 
	                                            <h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Related Business Objectives')"/></h3>                             
	                                            {{#if this.drivers}} 
	                                            	<h4 class="text-primary"><xsl:value-of select="eas:i18n('Supporting Drivers')"/></h4>
	                                                {{#each this.drivers}}
														{{#ifEquals this.key 'undefined'}}<xsl:value-of select="eas:i18n('None set')"/>
														{{else}}
	                                                	<span class="label label-primary right-5">{{this.key}}</span>
														{{/ifEquals}}
	                                                {{/each}}
	                                            	<div class="clearfix bottom-10"/>
	                                            {{/if}}
	                                            {{#if this.objectives}} 
	                                            	<h4 class="text-primary"><xsl:value-of select="eas:i18n('Supporting Objectives')"/></h4>
	                                            	<div class="ess-bcs-obj-wrapper">                                         		
		                                                {{#each this.objectives}}
		                                                <div class="objHolder">
		                                                	<div class="ess-type-label"><xsl:value-of select="eas:i18n('Business Objective')"/></div>
		                                                	<div class="impact">{{this.key}}</div>
															<label><xsl:value-of select="eas:i18n('Drivers:')"/></label>
		                                                    {{#each this.drivers}}
																{{#if this.key}}	
			                                                		<span class="label label-primary right-5">{{this.key}}</span>
																{{/if}}
		                                                    {{/each}}
															{{#if this.values.0.targetDate}}
																<label><xsl:value-of select="eas:i18n('Target Date:')"/></label>
			                                                	<span class="ess-string">{{this.values.0.targetDate}}</span>
															{{/if}}
		                                                </div>
		                                                {{/each}}
	                                                 </div>
	                                            <div class="clearfix bottom-10"></div>
	                                             {{/if}}
	                                            </div>
	                                        </div>	
											{{else}}
											{{#if this.objectives}}
											<div class="parent-superflex"> 
	                                            <div class="superflex"> 
	                                            <h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Related Business Objectives')"/></h3>                             
	                                            {{#if this.drivers}} 
													 
	                                            <h4 class="text-primary"><i class="fa fa-caret-right right-10"></i><xsl:value-of select="eas:i18n('Drivers Supporting')"/></h4>
	                                                {{#each this.drivers}}
													{{#ifEquals this.key 'undefined'}}<xsl:value-of select="eas:i18n('None set')"/>
													{{else}}
	                                                <span class="label label-primary bigger">{{this.key}}</span> &#160;
													{{/ifEquals}}
	                                                {{/each}}
	                                                 
	                                            <div class="clearfix bottom-10"></div>
	                                             {{/if}}
	                                             {{#if this.objectives}} 
	                                            <h4 class="text-primary"><i class="fa fa-caret-right right-10"></i><xsl:value-of select="eas:i18n('Objectives Supporting')"/></h4>
	                                                {{#each this.objectives}}
	                                                <div class="objHolder">
														<table>
														<tr>
															<td width="40%"><span class="label label-default"><xsl:value-of select="eas:i18n('Objective:')"/></span></td>
															<td>
																<span class="label label-success labelLong">{{this.key}}</span>
															</td>
														</tr>
	                                                    {{#each this.drivers}}
														{{#if this.key}}
														<tr>
															<td><span class="label label-default"><xsl:value-of select="eas:i18n('Driver:')"/></span></td>
															<td><span class="label label-primary labelLong"  >{{this.key}}</span></td>
														</tr>
														{{/if}}
	                                                    {{/each}}
														{{#if this.values.0.targetDate}}
														<tr>
															<td><span class="label label-default"><xsl:value-of select="eas:i18n('Target Date:')"/></span></td>
															<td>
															<span class="label label-warning">{{this.values.0.targetDate}}</span>
															</td>
														</tr>
														{{/if}}
														</table>
	                                                </div>
	                                                {{/each}}
	                                                 
	                                            <div class="clearfix bottom-10"></div>
	                                             {{/if}}
	                                            </div>
	                                        </div>
											{{/if}}
											{{/if}}
	                                   </div>
                                       <div class="tab-pane" id="supportingInformation">
                                       	<h2 class="print-only"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supporting Information')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supporting Information')"/></h3>
                                                	<div class="ess-bcs-info-wrapper">
														{{#each this.infoConcepts}}
														<div class="infoConceptBox bg-aqua-80">
															<div class="strong bottom-5">{{this.name}}</div>
															{{#if this.description}}
															<div class="infoDesc bg-aqua-20">
																{{this.description}}
															</div>
															{{/if}}
														</div>
														{{/each}}
                                                	</div>
												</div>
	                                        </div>
                                        </div>
                                        <div class="tab-pane" id="SupportingApplicationServices">
                                            <h2 class="print-only top-30"><i class="fa fa-fw fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Supporting Application Services')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
												<h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Supporting Application Services')"/></h3>
                                                    <p><xsl:value-of select="eas:i18n('The following Application Services are required to support the')"/> {{this.name}} <xsl:value-of select="eas:i18n('Business Capability.  The processes requiring them are shown')"/></p>
                                                	<div class="ess-bcs-appservice-wrapper">
														{{#each this.servicesSupporting}}
															<div class="serviceBox bg-offwhite">
																<div class="ess-type-label"><xsl:value-of select="eas:i18n('Application Service')"/></div>
																<div class="impact large bottom-5">{{this.key}}</div>
																<div class="bottom-10">
																	<div><strong><xsl:value-of select="eas:i18n('Processes Requiring')"/></strong></div>
																	{{#each this.values}}
																		<span class="label label-link bg-darkgreen-60 right-5 bottom-5">{{#essRenderInstanceLinkOnly this 'Business_Process'}}{{/essRenderInstanceLinkOnly}}</span>
																	{{/each}}
																</div>
																{{#if this.usingApps}}
																<div class="bottom-10">
																	<div><strong><i class="fa fa-tag text-aqua"></i>&#160;<b><xsl:value-of select="eas:i18n('Applications')"/><xsl:text> </xsl:text> <u><xsl:value-of select="eas:i18n('using')"/></u> <xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('the services to support a process')"/></b></strong></div>
																	{{#each this.usingApps}}
																		<span class="label label-link bg-aqua-100 right-5 bottom-5">{{#essRenderInstanceLinkOnly this 'Application_Provider'}}{{/essRenderInstanceLinkOnly}}</span>
																	{{/each}}
																</div>
																{{/if}}
																{{#if this.potentialApps}}
																<div class="bottom-10">
																	<div><strong><i class="fa fa-tag text-darkgrey"></i>&#160;<b><xsl:value-of select="eas:i18n('Applications')"/> <xsl:text> </xsl:text> <u><xsl:value-of select="eas:i18n('that can')"/></u> <xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('provide the service but are not used in a process')"/></b></strong></div>
																	{{#each this.potentialApps}}
																		<span class="label label-link bg-darkgrey right-5 bottom-5">{{#essRenderInstanceLinkOnly this 'Application_Provider'}}{{/essRenderInstanceLinkOnly}}</span>
																	{{/each}}
																</div>
																{{/if}}
															</div>
														{{/each}}
                                                	</div>
												</div>
                                            </div>
                                        </div>

                                        {{#if this.processes}}	
                                        <div class="tab-pane" id="capProcesses">
                                            <h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Supporting Business Processes')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Supporting Business Processes')"/></h3>
                                                    <p><xsl:value-of select="eas:i18n('The business processes supporting this business capability and the teams performing the processes')"/></p>
                                                	<div class="ess-bcs-process-wrapper">
														{{#each this.processes}}
														<div class="processBox">
															{{#essRenderInstanceLinkOnly this 'Business_Process'}}{{/essRenderInstanceLinkOnly}}<br/>
															{{#each this.actors}}
																<span class="label label-primary">{{this.name}}</span>
															{{/each}}
	                                                    </div>
														{{/each}}
													</div>
                                                  <!--  
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
                                                    {{#each this.processes}}
                                                        <tr>
                                                            <td><span class="label labelProcess">{{this.name}}</span></td>
                                                            <td><span class="label labelOrg">{{this.org}}</span></td>
                                                            <td><span class="label label-success">{{this.svcName}}</span></td>
                                                            <td>
                                                            </td>
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
													-->
                                                </div>
                                            </div>
                
                                        </div>
                                        {{/if}}
                                        {{#if this.apps}}	
                                        <div class="tab-pane" id="capApps">
                                            <h2 class="print-only top-30"><i class="fa fa-fw fa-area-chart right-10"></i><xsl:value-of select="eas:i18n('Supporting Applications')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-area-chart right-10"></i><xsl:value-of select="eas:i18n('Supporting Applications')"/></h3>
                                                    <table class="table table-striped table-bordered" id="dt_applications">
                                                            <thead>
                                                                <tr>
                                                                    <th class="cellWidth-30pc">
                                                                        <xsl:value-of select="eas:i18n('Application')"/>
                                                                    </th>
                                                                    <th class="cellWidth-30pc">
                                                                        <xsl:value-of select="eas:i18n('Description')"/>
                                                                    </th>
                                                                     
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            {{#each this.apps}} 
                                                            <tr>
                                                                <td class="cellWidth-30pc">
                                                                      {{#essRenderInstanceLinkOnly this 'Application_Provider'}}{{/essRenderInstanceLinkOnly}}
                                                                      
                                                                </td>
                                                                <td class="cellWidth-30pc">
                                                                     {{this.description}} 
                                                                </td>
                                                            </tr>	 
                                                            {{/each}}
                                                            </tbody>
                                                            <tfoot>
                                                                <tr>
                                                                        <th class="cellWidth-30pc">
                                                                                <xsl:value-of select="eas:i18n('Application')"/>
                                                                        </th>
                                                                        <th class="cellWidth-30pc">
                                                                            <xsl:value-of select="eas:i18n('Description')"/>
                                                                        </th>
                                                                </tr>
                                                            </tfoot>
                                                        </table>
                                                </div>
                                            </div>
                                        </div>
                                        {{/if}}
                                        {{#if this.costs}}
                                        <div class="tab-pane" id="capcosts">
                                                <h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></h2>
                                                <div class="parent-superflex">
                                                        <div class="superflex">
                                                            <div class="chart-container">
                                                                <canvas id="costByType-chart" ></canvas>
                                                            </div>
                                                        </div>
                                                        <div class="superflex">
                                                            <div class="chart-container">
                                                                <canvas id="costByFrequency-chart" ></canvas>
                                                            </div> 
                                                            </div>
                                                </div>
                                                <div class="superflex">
                                                        <div class="full-width-chart-container">
                                                            <canvas id="costByMonth-chart" height="50px"></canvas>
                                                        </div>
                
                                                </div>
                                                <div class="parent-superflex">
                                                    <div class="superflex">
                                                        <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Costs')"/></h3>
                                                        <p><xsl:value-of select="eas:i18n('Costs related to this application')"/></p>
                                                        <table class="table table-striped table-bordered display compact" id="dt_costs">
                                                                <thead><tr><th>Cost</th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></thead>
                                                                {{#each this.costs}}
                                                                <tr>
                                                                    <td><span class="label label-primary">{{this.name}}</span></td>
                                                                    <td><span class="label label-primary">{{#getType this.costType}}{{/getType}}</span></td>
                                                                    <td>{{this.currency}}{{#formatCurrency this.cost}}{{/formatCurrency}}</td>
                                                                    <td>{{this.fromDate}}</td>
                                                                    <td>{{this.toDate}}</td>
                                                                </tr>
                                                                {{/each}}
                                                                <tfoot><tr><th><xsl:value-of select="eas:i18n('Cost')"/></th><th><xsl:value-of select="eas:i18n('Type')"/></th><th><xsl:value-of select="eas:i18n('Value')"/></th><th><xsl:value-of select="eas:i18n('From Date')"/></th><th><xsl:value-of select="eas:i18n('To Date')"/></th></tr></tfoot>
                                                                
                                                        </table>
                                                    </div>
                                                </div>
                    
                                            </div>
                                        {{/if}}
                                        {{#if this.pm}}	
                                        <div class="tab-pane" id="capKpis">
                                            <h2 class="print-only top-30"><i class="fa fa-fw fa-chart-area right-10"></i><xsl:value-of select="eas:i18n('Application KPIs')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-chart-area right-10"></i><xsl:value-of select="eas:i18n('Application KPIs')"/></h3>
                                                 
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
                                        {{#if this.plans}}	
                                        <div class="tab-pane" id="capPlans">
                                            <h2 class="print-only top-30"><i class="fa fa-fw fa-chart-area right-10"></i> <xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></h2>
                                            <div class="parent-superflex">
                                                <div class="superflex">
                                                    <h3 class="text-primary"><i class="fa fa-chart-area right-10"></i><xsl:value-of select="eas:i18n('Plans &amp; Projects')"/></h3>
                                                    <p><xsl:value-of select="eas:i18n('Plans and projects that impact this application')"/></p>
                                                    <h4><xsl:value-of select="eas:i18n('Plans')"/></h4>
                                                    {{#each this.plans}}
                                                        <span class="label label-success"><xsl:value-of select="eas:i18n('Plan')"/></span>&#160;<b>{{this.name}}</b> <br/>
                                                        <span class="label label-default"><xsl:value-of select="eas:i18n('From')"/></span>&#160; {{this.validStartDate}} 
                                                        <span class="label label-default"><xsl:value-of select="eas:i18n('To')"/></span>&#160; {{this.validEndDate}} 
														<br/> 
                                                    {{/each}}
                                                    <h4>Projects</h4>
                                                    {{#each this.projects}}
                                                        <span class="label label-primary"><xsl:value-of select="eas:i18n('Project')"/></span>&#160;<b>{{this.name}} </b><br/>
														{{#each this.items}}
														<span class="label label-warning"><xsl:value-of select="eas:i18n('What')"/></span><xsl:text> </xsl:text>{{this.name}}<xsl:text> </xsl:text><span class="label label-info"><xsl:value-of select="eas:i18n('Action')"/></span> &#160;{{this.action}} <br/>
														{{/each}}
                                                      
                                                        <span class="label label-default"><xsl:value-of select="eas:i18n('Proposed Start')"/></span>&#160; {{this.proposedStartDate}} 
                                                        <span class="label label-default"><xsl:value-of select="eas:i18n('Actual Start')"/></span> &#160;{{this.actualStartDate}} 
                                                        <span class="label label-default"><xsl:value-of select="eas:i18n('Target End')"/></span>&#160; {{this.targetEndDate}} 
                                                        <span class="label label-default"><xsl:value-of select="eas:i18n('Forecast End')"/></span> &#160;{{this.forecastEndDate}}
														   
														<hr/>
                                                    {{/each}}
                                                    
                                                </div>
                                            </div>
											<!--
                                            <div class="superflex">
                                                <h3 class="text-primary"><i class="fa fa-chart-area right-10"></i><xsl:value-of select="eas:i18n('Impacts with Plans containing and the projects implementing</h3>
                                                {{#each this.projectElements}}
                                                    <span class="label label-success"><xsl:value-of select="eas:i18n('Plan</span>&#160; {{this.plan}}&#160;
                                                    <span class="label label-primary"><xsl:value-of select="eas:i18n('Project</span>&#160;{{this.projectName}}&#160;
                                                    <span class="label label-default"><xsl:value-of select="eas:i18n('Action</span>&#160;<span class="label label-default"><xsl:attribute name="style">color:{{this.colour}};background-color:{{this.textColour}}</xsl:attribute>{{this.action}}</span>&#160;
                									<br/>
                                                {{/each}}
                                            </div>
										-->
                                        </div>
                                        {{/if}}
										{{#if this.otherEnums}}
										<div class="tab-pane" id="otherEnums">
											<h2 class="print-only top-30"><i class="fa fa-fw fa-comment right-10"></i><xsl:value-of select="eas:i18n(' Other')"/></h2>
											<div class="parent-superflex">
												<div class="superflex">
													<h3 class="text-primary"><i class="fa fa-comment right-10"></i><xsl:value-of select="eas:i18n('Other')"/></h3>
													<p><xsl:value-of select="eas:i18n('Other values against this Application')"/></p> 
														
														{{#each this.otherEnums}}
														<div class="bottom-10">
															<label>{{this.classNm}}</label>
															<span class="label lable-link">
																<xsl:attribute name="style">background-color:{{#if this.backgroundColor}}{{this.backgroundColor}}{{else}}#4a82d1{{/if}};color:{{#if this.colour}}{{this.colour}}{{else}}#ffffff{{/if}}</xsl:attribute>
																{{this.name}}
															</span>
														</div>
														{{/each}}
												</div>
											</div>
										</div>
										{{/if}}
                                        {{#if this.documents}}
                                        <div class="tab-pane" id="documents">
                                        <div class="parent-superflex">
                                            <div class="superflex">
                                                <h3 class="text-primary"><i class="fa fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Documentation')"/></h3>
												{{#each this.documents}}
													{{#ifEquals this.key 'undefined'}}{{else}}<b>{{this.key}}</b><div class="clearfix"/>{{/ifEquals}}
													{{#each this.values}}
													<div class="doc-link-blob bdr-left-blue">
														<div class="doc-link-icon"><i class="fa fa-file-o"></i></div>
														<div class="doc-link-label"><a target="_blank"><xsl:attribute name="href">{{this.documentLink}}</xsl:attribute>{{this.name}}&#160;<i class="fa fa-external-link"></i></a></div>
														<div class="doc-description">{{this.description}}</div>
													</div>
													{{/each}}
													<br/>
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
				
<script>
 <xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
var subProcesses=[];

function showEditorSpinner(message) {
    $('#editor-spinner-text').text(message);                            
    $('#editor-spinner').removeClass('hidden');
    };
function removeEditorSpinner(){$('#editor-spinner').addClass('hidden');
    $('#editor-spinner-text').text('');
    };
 
 let aprs = [<xsl:for-each select="$aprs">{"id":"<xsl:value-of select="current()/name"/>", "svcid":"<xsl:value-of select="current()/own_slot_value[slot_reference='implementing_application_service']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>];
 
showEditorSpinner('Fetching Data..')
$(document).ready(function() {                    
	var procFragmentFront   = $("#proc-template").html();
	procTemplateFront = Handlebars.compile(procFragmentFront);
 
    var panelFragment = $("#panel-template").html();
        panelTemplate = Handlebars.compile(panelFragment);
	
	Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
		return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
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

 
	$('#processTable').append(procTemplateFront(subProcesses));
	
	
	$("span[easid='but']").click(function() {
 
    $(this).children().toggleClass("fa-caret-up fa-caret-down");
	});
	
	
	$("button[easid='but']").click(function() {
    $(this).children().toggleClass("fa-caret-up fa-caret-down");
	});
});

</script>
    <!-- caps template -->
<script id="model-l0-template" type="text/x-handlebars-template">
    <div class="capModel">
 
        {{#each this}}
            <div class="l0-cap"><xsl:attribute name="id">{{id}}</xsl:attribute>
                <span class="cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
            <br/> 
                    {{> l1CapTemplate}}
                    
            </div>
        {{/each}}
    </div>
</script>

<!-- SubCaps template called iteratively -->
<script id="model-l1cap-template" type="text/x-handlebars-template">
    <div class="l1-caps-wrapper caplevel"> 
        {{#each this.childrenCaps}}
        <div class="l1-cap bg-darkblue-40 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
            <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
  
                {{> l2CapTemplate}} 	
               
        </div> 
        
        {{/each}}
    </div>
</script>

<!-- SubCaps template called iteratively -->
<script id="model-l2cap-template" type="text/x-handlebars-template">
    <div class="l2-caps-wrapper caplevel "> 
        {{#each this.childrenCaps}}
        <div class="l2-cap buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
            <span class="sub-cap-label">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</span>
            {{> l2CapTemplate}} 	 
        </div>
        {{/each}}
    </div>
</script>

<script id="proc-template" type="text/x-handlebars-template">
{{#each this}}
<tr style="border-top:1pt solid #d3d3d3"><td style="vertical-align:top;padding:3px">{{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}</td>
	<td  style="vertical-align:top;padding:3px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
		<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
			<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#ifEquals this.flow  'Y'}}&#160;<i class="fa fa-random"></i>{{/ifEquals}}{{/each}}</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
		</div>
		{{/each}}</td>
	<td  style="vertical-align:top;padding:3px">{{this.description}}</td></tr>
{{/each}}
</script>	

<script id="page-template" type="text/x-handlebars-template">
	<div class="container-fluid">
        <div class="row">
            <div class="col-xs-12">
                <div class="page-header">
                    <h1>
                        <span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: Business Capability Summary - </span> 
                        {{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}
                    </h1>
                </div>
            </div>


            <!--Setup Description Section-->
        </div>
        <div class="row">
{{#if this.description}}
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-list-ul icon-section icon-color"/>
                </div>

                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Description')"/>
                </h2>

                <div class="content-section">
                    {{this.description}}
                </div>
                <hr/>

            </div>
{{/if}}


            <!--Setup Domain Section-->
        {{#if this.businessDomain}}     
		  
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa essicon-radialdots icon-section icon-color"/>
                </div>
                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Business Domain')"/>
                </h2>

                <div class="content-section">
					{{#each this.businessDomains}}      
                     	{{this.name}} 
                	{{/each}}
                </div>
                <hr/>
            </div> 
			{{/if}}
          {{else}}
          {{#if this.multiBusDomains}}           
          <div class="col-xs-12">
              <div class="sectionIcon">
                  <i class="fa essicon-radialdots icon-section icon-color"/>
              </div>
              <h2 class="text-primary">
                  <xsl:value-of select="eas:i18n('Business Domain')"/>
              </h2>

              <div class="content-section">
                  {{#if this.multiBusDomains}}
                      {{#each this.multiBusDomains}}{{this.name}}{{/each}}
                 {{else}} 
                      {{this.businessDomain}}
                 {{/if}}
              </div>
              <hr/>
          </div>
          {{/if}}  
          {{/if}}

            <!--Setup Parent Capability Section-->
            {{#if this.parentBusinessCapability}}  
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-sitemap icon-section icon-color"/>
                </div>
                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Parent Business Capability')"/>
                </h2>

                <div class="content-section">
                {{#each this.parentBusinessCapability}}
                    {{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}
                {{/each}}
                </div>
                <hr/>
            </div>
{{/if}}
            <!--Setup Parent Capability Section json-->
            <div class="col-xs-12">
                    <div class="sectionIcon">
                        <i class="fa fa-table icon-section icon-color"/>
                    </div>
                    <h2 class="text-primary">
                        <xsl:value-of select="eas:i18n('Business Capability Model')"/>
                    </h2>
                    {{#each this.childrenCaps}}

                        <div style="border-radius:6px; background-color:#ede9e9; padding:2px; width:150px;vertical-align:top;border:1pt solid #d3d3d3;text-align: center;display:inline-block;margin:3px"><b>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</b>
                                {{#each this.childrenCaps}}
                                <div style="border-radius:3px; margin-top:3px; padding:2px; background-color:#fff; width:142px;margin-left:0px;padding-left:3px;min-height:50px;border:1pt solid #d5c6c6">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}
                                        {{#each this.childrenCaps}}
                                        <div style="border-radius:3px; background-color:rgb(244, 244, 244); width:132px;margin-left:0px;padding-left:3px;min-height:50px;border:1pt solid #d5c6c6">{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
                                        {{/each}}
                                </div>
                                {{/each}}
                        </div>

                    {{/each}}
                
                    <hr/>
                </div>
    
            <!--Setup Supporting Processes Section-->
     
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa essicon-boxesdiagonal icon-section icon-color"/>
                </div>

                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Supporting Processes')"/>
                </h2>

                <div class="content-section">
                    
 
                            <p>The following Business Processes are directly associated with this Business Capability</p>
                            <br/>
                            <table class="table table-bordered table-striped" id="processTable">
                                <thead>
                                    <tr>
                                        <th class="cellWidth-20pc">Process Name</th>
                                         
                                    </tr>
                                </thead>
                                <tbody>
                                      {{#each this.processes}}    
                                    <tr>
                                            <td>
                                                    {{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}
                                            </td>
                                             
                                        </tr>
                                    {{/each}}
                                </tbody>
                            </table>
                        
                </div>
                <hr/>
            </div> 

            <!--Setup Supporting Info Section
<xsl:if test="$allInfoConcepts">
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-files-o icon-section icon-color"/>
                </div>
                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Supporting Information')"/>
                </h2>

              <div class="content-section">
                 
                            <p><xsl:value-of select="eas:i18n('The following Information Concepts support the')"/>&#160; {{this.name}}&#160; <xsl:value-of select="eas:i18n('Business Capability')"/></p>

                            <table class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th class="cellWidth-30pc">
                                            <xsl:value-of select="eas:i18n('Information Concept')"/>
                                        </th>
                                        <th class="cellWidth-70pc">
                                            <xsl:value-of select="eas:i18n('Description')"/>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:apply-templates select="$allInfoConcepts" mode="RenderInfoRow">
                                        <xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
                                    </xsl:apply-templates>
                                </tbody>
                            </table>
                      
                </div> 
                <hr/>
            </div>
</xsl:if>
-->

            {{#if this.apps}}
            <!--Setup Supporting Apps Section-->
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-tablet icon-section icon-color"/>
                </div>

                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Supporting Applications')"/>
                </h2>

                <div class="content-section">

                            <p><xsl:value-of select="eas:i18n('The following Applications support the')"/>&#160; {{this.name}}&#160; <xsl:value-of select="eas:i18n('Business Capability')"/></p>

                            <table class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th class="cellWidth-30pc">
                                            <xsl:value-of select="eas:i18n('Application')"/>
                                        </th>
                                        <th class="cellWidth-70pc">
                                            <xsl:value-of select="eas:i18n('Description')"/>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                {{#each this.apps}}
                                    <tr><td>{{#essRenderInstanceLinkOnly this 'Application_Provider'}}{{/essRenderInstanceLinkOnly}}</td><td>{{this.description}}</td></tr>
                                {{/each}}
                                </tbody>
                            </table>
            
                </div>
                <hr/>
            </div>
            {{/if}}



       <!--    Setup Supporting Objectives Section
           <xsl:if test="$relevantServiceQualityValues">
            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-check icon-section icon-color"/>
                </div>
                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Related Business Objectives')"/>
                </h2>

                <div class="content-section">
                    <xsl:call-template name="Objectives"/>
                </div>
                <hr/>
            </div>
            </xsl:if>
 -->


            <!--Setup Related Projects Section

            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-calendar icon-section icon-color"/>
                </div>

                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Related Projects')"/>
                </h2>

                <div class="content-section">
                    <xsl:call-template name="Projects"/>
                </div>
                <hr/>
            </div>
-->


            <!--Setup the Supporting Documentation section-->

            <div class="col-xs-12">
                <div class="sectionIcon">
                    <i class="fa fa-file-text-o icon-section icon-color"/>
                </div>

                <h2 class="text-primary">
                    <xsl:value-of select="eas:i18n('Supporting Documentation')"/>
                </h2>
 
                <div class="content-section">
                    <xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>
                </div> 
                <hr/>
            </div>



            <!--Setup Closing Tags-->
        </div>
    </div>
    </script>
			</body>
		</html>
	</xsl:template>


 

	<!-- render an Information Concept table row  -->
	<xsl:template match="node()" mode="RenderInfoRow">
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

 


	<xsl:template match="node()" mode="NameBulletList">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>


<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param> 
        <xsl:param name="viewerAPIPathProcess"></xsl:param> 
        <xsl:param name="viewerAPIPathCaps"></xsl:param>
        <xsl:param name="viewerAPIPathDoms"></xsl:param>
        <xsl:param name="viewerAPIPathStrat"></xsl:param>
		<xsl:param name="viewerAPIPathProc2Serv"></xsl:param>
		<xsl:param name="viewerAPIPathPhysProc2App"></xsl:param>
		<xsl:param name="viewerAPIPathPlans"></xsl:param>
		<xsl:param name="viewerAPIPathkpi"></xsl:param>
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>'; 
        var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>'; 
        var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
        var viewAPIDataDoms = '<xsl:value-of select="$viewerAPIPathDoms"/>'; 
        var viewAPIDataStratData = '<xsl:value-of select="$viewerAPIPathStrat"/>';
		var viewAPIDataProc2Service = '<xsl:value-of select="$viewerAPIPathProc2Serv"/>';
		var viewAPIDataPhysProc2App = '<xsl:value-of select="$viewerAPIPathPhysProc2App"/>';
		var viewAPIDataPlans = '<xsl:value-of select="$viewerAPIPathPlans"/>';
		var viewAPIDataKpi = '<xsl:value-of select="$viewerAPIPathkpi"/>'; 
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

var partialTemplate, l0capFragment, appTable; 
var projectElementMap=[];
var planElementMap=[];
let thisCapId='<xsl:value-of select="$param1"/>';
 
$('document').ready(function () {

        l0capFragment = $("#model-l0-template").html();
        l0CapTemplate = Handlebars.compile(l0capFragment);
        
        templateFragment = $("#model-l1cap-template").html();
        l1CapTemplate = Handlebars.compile(templateFragment);
        Handlebars.registerPartial('l1CapTemplate', l1CapTemplate);
        
        templateFragment = $("#model-l2cap-template").html();
        l2CapTemplate = Handlebars.compile(templateFragment);
        Handlebars.registerPartial('l2CapTemplate', l2CapTemplate);

		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
        });
        
        Handlebars.registerHelper('breaklines', function(html) {
			html = html.replace(/(\r&lt;li&gt;)/gm, '&lt;li&gt;');
		    html = html.replace(/(\r)/gm, '<br/>');
		    return new Handlebars.SafeString(html);
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
                instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:#0171c0">' + instance.name + '</a>';
        
                return instanceLink;
            }
        });
        
    var pageFragmentFront   = $("#page-template").html();
    pageTemplate = Handlebars.compile(pageFragmentFront);

	var workingArray,plans, capsArray,capToObjTable, strategyTable, unmappedObj,appArray, processArray, domsArray,physProcs, svcMapping;
 
	Promise.all([
		promise_loadViewerAPIData(viewAPIData),
		promise_loadViewerAPIData(viewAPIDataApps), 
        promise_loadViewerAPIData(viewAPIDataProcess),
        promise_loadViewerAPIData(viewAPIDataCaps),
        promise_loadViewerAPIData(viewAPIDataDoms),
        promise_loadViewerAPIData(viewAPIDataStratData),
		promise_loadViewerAPIData(viewAPIDataProc2Service),
		promise_loadViewerAPIData(viewAPIDataPhysProc2App),
		promise_loadViewerAPIData(viewAPIDataPlans),
		promise_loadViewerAPIData(viewAPIDataKpi)
	]).then(function (responses) {
		
        workingArray = responses[0]; 
        appArray = responses[1]; 
         processArray = responses[2]; 
         capsArray = responses[3]; 
         domsArray=responses[4].businessDomains;
		 svcMapping=responses[6];
         physProcs=responses[7];
  
		plans=responses[8];  
		pmc=responses[9].perfCategory; 
		let pms=responses[9].businessCapabilities; 
		
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
		});
 
$('#subjectSelection').select2()
workingArray.busCaptoAppDetails=workingArray.busCaptoAppDetails.sort((a, b) => a.name.localeCompare(b.name));
workingArray.busCaptoAppDetails.forEach((e)=>{ 
	$('#subjectSelection').append('&lt;option value="'+e.id+'">'+e.name+'&lt;/option>')

	e['pmScore']=0;
	let thisPerfMeasures=pms?.find((f)=>{
		return f.id==e.id;
	});
 
	if(thisPerfMeasures){
		e['pm']=thisPerfMeasures.perfMeasures; 
	}
})
 
$("#subjectSelection option[value='"+thisCapId+"']").attr("selected", "selected");
 


		<!-- create project pairs for speed --> 
					plans.allProject.forEach((p)=>{
						p.p2e.forEach((pe)=>{
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
 
        removeEditorSpinner();
		
         strategyTable=[];
        responses[5].drivers?.forEach((d)=>{ 
            d.goals?.forEach((e)=>{ 
                e.objectives?.forEach((f)=>{ 
                    f.supportingCapabilities?.forEach((g)=>{ 
                    strategyTable.push({"capid":g, "objectiveId":f.id, "targetDate":f.targetDate, "objectiveName":f.name,"goalId":e.id, "goalName":e.name,"driverId":d.id, "driverName":d.name})
                    })
                })
            })
        })
         capToObjTable =[]; <!-- for obj not mapped to drivers -->
        responses[5].objectives?.forEach((d)=>{
            d.supportingCapabilities?.forEach((g)=>{ 
                capToObjTable.push({"capid":g, "objectiveId":d.id,  "targetDate":d.targetDate, "objectiveName":d.name})
            })
        });
  
        unmappedObj = capToObjTable.filter(function(obj) {
        return !strategyTable.some(function(obj2) {
            return obj.capid == obj2.capid;
        });
    }); 


	svcMapping.process_to_service.forEach((d)=>{
	 
		let appsProvidingService=[];
		d.services.forEach((e)=>{
		appArray.applications.forEach((a)=>{
	 
			let match=a.allServices.find((s)=>{
				return s.serviceId == e.id;
			}); 
			if(match){
				appsProvidingService.push({"id":a.id, "name":a.name})
			}
		})
		e['appsProviding']=appsProvidingService
	})
	})
	 
unmappedObj.forEach((d)=>{
    strategyTable.push(d)
})
 
redrawView()

	}).catch(function (error) {
		//display an error somewhere on the page
	});

	let scopedApps = [];
	let inScopeCapsApp = [];
	let scopedCaps = [];
	let scopedSvcs = [];

	var redrawView = function () {
 
			let workingAppsList = [];
			let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
			let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
			let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
		//	let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
 
			let caps = workingArray.busCaptoAppDetails;
	 
 
<!-- get plan/project items associated with the Cap -->
let focusCap = capsArray.businessCapabilities.find((d)=>{
	return d.id==thisCapId
})

let capDetail = workingArray.busCaptoAppDetails.find((f)=>{
	return f.id == thisCapId
});
 
focusCap['pm']=capDetail.pm;
focusCap['domainIds']=capDetail.domainIds;

let capElements=[];  
let processElements=[];
let appElements=[];
 
if(focusCap.pm){
	byPerfName = d3.nest()
		.key(function(d) { return d.categoryid })
		.entries(focusCap.pm) 
	  
		byPerfName.forEach((v)=>{
			v.values.sort((a, b) => b.date.localeCompare(a.order))
		})
	 
	byPerfName=byPerfName.filter((d)=>{
		return d.key!="";
	});
	focusCap['perfsGrp']=byPerfName
	}

projectElementMap.forEach((element) => {
	if (element.impactedElement === thisCapId) {
		capElements.push(element);
	} else if (capDetail.processes.some((pr) => pr.id === element.impactedElement)) {
	  processElements.push(element);
	} else if (capDetail.apps.some((p) => p.impactedElement === element.impactedElement)) {
	  appElements.push(element);
	}
  }); 

  let thisElements = [...capElements, ...processElements, ...appElements];
   
let thisPlanElementMap
thisElements?.forEach((e)=>{
	 thisPlanElementMap=planElementMap.filter((d)=>{
		return d.id!=e.id;
	})
});
 
let thisPlanElements=planElementMap.filter((p)=>{
	return p.impactedElement == thisCapId
})

let thisProj=[];
let thisPlan=[]; 
thisPlanElements?.forEach((d)=>{
	thisPlan.push(d)
})
 
thisElements.forEach((d)=>{
	if(plans){
	let thisProjDetail=plans?.allProject?.find((p)=>{
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
	}
})
 
 thisPlan = Array.from(new Set(thisPlan.map((item) => item.id))).map((id) => {
	return thisPlan.find((item) => item.id === id);
  });

let plansMap = new Map(plans.allPlans?.map(plan => [plan.id, plan]));

thisPlan.forEach((p) => {
    let matchPlan = plansMap.get(p.id);

    if (matchPlan) {
        p['validStartDate'] = matchPlan.validStartDate;
        p['validEndDate'] = matchPlan.validEndDate;
    }
});


        let thisStrat=strategyTable.filter((c)=>{
            return c.capid==focusCap.id
        })
		 
		focusCap['projects']=thisProj;
		focusCap['plans']=thisPlan; 
		focusCap['projectElements']=thisElements;
	
		thisProj.forEach((d)=>{
			let items=[];
			thisElements.forEach((el)=>{
				let match=d.p2e.find((e)=>{
					return e.id == el.id;
				});
				if(match){
				items.push({"name":el.name,"action":match.action})
				}
			})
			d['items']=items
		}); 

        let objByName = d3.nest()
        .key(function(d) { return d.objectiveName; })
        .entries(thisStrat);
        
        let driverByName = d3.nest()
        .key(function(d) { return d.driverName; })
        .entries(thisStrat);
 
		if(thisStrat.length&gt;0){
       	 focusCap['drivers']=driverByName
      	  focusCap['objectives']=objByName
		}
 
		objByName?.forEach((d)=>{
			let subdriverByName = d3.nest()
			.key(function(d) { return d.driverName; })
			.entries(d.values);
			let thisDrvs=[];
			subdriverByName.forEach((f)=>{
				thisDrvs.push(f.key)
			});
			d['drivers']=subdriverByName;

		})
	 
      
        let capApps=[];
        let physpro=[];
 
        let thisDomains=[];
 
	if(focusCap.domainIds==['']){ focusCap.domainIds=[]}
        focusCap.domainIds?.forEach((f)=>{ 
	 
            let doms=domsArray.find((e)=>{
                return e.id==f
            }) 
		 
            thisDomains.push({"id":f, "name":doms.name})
        });
 
        focusCap.domains = thisDomains; 
		
		 
		focusCap = Object.assign({}, capDetail, focusCap);
 
		let filterenumerationValues=[];
		let focusKeys=Object.keys(focusCap)  

		let capEnums=[]
		workingArray.filters.forEach((d)=>{

		let inFilters=focusKeys.find((e)=>{
			return d.slotName==e
		}) 

		if(inFilters){
			let thisFilter=workingArray.filters.find((e)=>{
				return e.slotName ==inFilters
			})
	
			let thisSelected=thisFilter.values.find((f)=>{
				return f.id==focusCap[inFilters]
			})
			if(thisSelected){ 
			thisSelected['class']=thisFilter.valueClass;
			thisSelected['classNm']=thisFilter.name;
			capEnums.push(thisSelected)
			}
		}
	})
 
	  focusCap['processes']=capDetail.processes
	  let thisApps=[];
	
	  capDetail.apps.forEach((ap)=>{
			let thisApp=appArray.applications.find((d)=>{
				return d.id == ap;
			})
			thisApps.push(thisApp)
		});
	 
	  focusCap['apps']=thisApps;
 
	  let docsCategory = d3.nest()
		.key(function(d) { return d.type; })
		.entries(focusCap.documents);
		
		focusCap['documents']=docsCategory;
	  function dfs(obj, targetId){
		if (obj.id === targetId){
			return obj
		}
		if (obj.childrenCaps)
		{
			for (let item of obj.childrenCaps) {

			let check = dfs(item, targetId)
			if (check){
			return check
				}
			}
		}
		return null
	}
		
		let result = null 
		for (let obj of workingArray.busCapHierarchy){
			result = dfs(obj, thisCapId)
			if (result) {
				break
			}
		}	
 
		focusCap['childrenCaps']=result?.childrenCaps;
 
		let capAppServices=[];
		let capAppMap=[]; 
        focusCap.processes?.forEach((e)=>{

			let thisProcSvcs=svcMapping.process_to_service.find((f)=>{
				return f.id == e.id;
			});
			 
			thisProcSvcs?.services.forEach((s)=>{
				capAppServices.push({"processId":e.id, "name":e.name, "serviceId":s.id,"serviceName":s.name, sname:{"name":s.name, "id":s.id},"apps":s.appsProviding})
			})
 
			e.physP.forEach((p)=>{
				 
				let thisPhys=physProcs.process_to_apps.find((pp)=>{
					return pp.id==p;
				})
			 
				let thisRow=thisPhys.appsviaservice.forEach((s)=>{
					let thisApp=appArray.applications.find((a)=>{
						return a.id ==s.appid
					})
					 if(thisApp){
						s['appName']=thisApp.name;
						let svmtch=aprs.find((e)=>{
							return e.id==s.id
						})
						s['svcid']=svmtch.svcid;
						capAppMap.push(s)
					}
				})
			})
		  
			let thisProcInfo = processArray.businessProcesses.find((f)=>{
				return f.id == e.id;
			});

			if(thisProcInfo){
				e['actors']=thisProcInfo.actors;
			}
		})
	 
		var servByName = d3.nest()
        .key(function(d) { return d.serviceName; })
        .entries(capAppServices);
 
		var servicesByName = d3.nest()
        .key(function(d) { return d.svcid })
		.key(function(d) { return d.appName; })
        .entries(capAppMap);
 
	 	focusCap['servicesSupporting']=servByName; 
 
		focusCap.servicesSupporting?.forEach((s)=>{
	 
			 	let relevantApps=servicesByName.find((c)=>{
					return c.key==s.values[0].serviceId;
				}) 
			 
			if(relevantApps){
				relevantApps.values.forEach((a)=>{
					a['id']=a.values[0].appid;
					a['name']=a.values[0].appName;
				})
				s['usingApps']=relevantApps.values	
			}
			s['potentialApps']=s.values[0].apps; 

			if(s.usingApps?.length&gt;0){
		 
			const results = s.potentialApps.filter(o1 => !s.usingApps.some(o2 => o1.id === o2.id));
			s['potentialApps']=results;
			}
		})
		<!-- add enumerations already included in the page here to avoid duplicating in the other tab -->
		let itemsToRemove=[];
 
		const clsToRemove = itemsToRemove.map(item => item.class);
		const filteredArray = capEnums.filter(item => !clsToRemove.includes(item.class))
 
		if(filteredArray){
			focusCap['otherEnums']=filteredArray
		}
 
        let panelSet = new Promise(function(myResolve, myReject) { $('#mainPanel').html(panelTemplate(focusCap))
            myResolve();  
            myReject();
        })
        
        panelSet.then(function(response){

        if(appTable) {
            appTable
            .rows()
            .invalidate()
            .destroy();
            }
             
            $('#dt_applications tfoot th').each( function () {
            let appTitle = $(this).text();
            $(this).html( '&lt;input type="text" placeholder="&#xf002; '+appTitle+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
            } );
             
            appTable = $('#dt_applications').DataTable({
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
            appTable.columns().every( function () {
            let thatapp = this;
            
            $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( thatapp.search() !== this.value ) {
                thatapp
            .search( this.value )
            .draw();
            }
            });
        })

        $('a[data-toggle="tab"]').on('shown.bs.tab', function(e){$($.fn.dataTable.tables(true)).DataTable() .columns.adjust();});

	if(focusCap.childrenCaps){
		if(focusCap.childrenCaps?.length==0){
	
			if(focusCap.children?.length&gt;0){
		
				$('#busCapModel').html(l0CapTemplate(focusCap.children));
				}
				else{
				$('#busCapModel').html('No sub-capabilities mapped')
			}
		}
		else{
        	$('#busCapModel').html(l0CapTemplate(focusCap.childrenCaps));
		}
	} else if(focusCap.children?.length&gt;0){
		$('#busCapModel').html(l0CapTemplate(focusCap.children));
	}
 
		function debounce(func, wait, immediate) {
			var timeout;
			return function() {
				var context = this, args = arguments;
				var later = function() {
					timeout = null;
					if (!immediate) func.apply(context, args);
				};
				var callNow = immediate &amp;&amp; !timeout;
				clearTimeout(timeout);
				timeout = setTimeout(later, wait);
				if (callNow) func.apply(context, args);
			};
		}

		
    })
	
}

$('#subjectSelection').on('change', function(event){
	event.stopPropagation();
	thisCapId= $(this).val(); 
	redrawView(); 
})
});

function getArrayDepth(arr) {

	arr.forEach((d) => {
		levelArr.push(parseInt(d.level))
		getArrayDepth(d.childrenCaps);
	})
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

</xsl:stylesheet>
