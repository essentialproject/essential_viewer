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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>
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
				<script src="js/d3/d3.min.js"></script>
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
.bc-body{
    font-family: 'Lato', sans-serif;
    font-size:16px;
    margin:0;
}
.bc-body h1,
.bc-body h2,
.bc-body h3,
.bc-body h4,
.bc-body h5,
.bc-body h6,
.bc-body p{
    margin:0;
}
.bc-body a,
.bc-body button{
    -webkit-transition: ease all 0.5s;
    -o-transition: ease all 0.5s;
    -moz-transition: ease all 0.5s;
    transition: ease all 0.5s;
}
.bc-body .a-i-end {
    -webkit-box-align: end;
    -webkit-align-items: flex-end;
       -moz-box-align: end;
        -ms-flex-align: end;
            align-items: flex-end;
}
.bc-body .a-i-center {
    -webkit-box-align: center;
    -webkit-align-items: center;
       -moz-box-align: center;
        -ms-flex-align: center;
            align-items: center;
}
.bc-body .j-c-between {
    -webkit-box-pack: justify;
    -webkit-justify-content: space-between;
       -moz-box-pack: justify;
        -ms-flex-pack: justify;
            justify-content: space-between;
}
.bc-body .a-i-start {
    -webkit-box-align: start;
    -webkit-align-items: flex-start;
       -moz-box-align: start;
        -ms-flex-align: start;
            align-items: flex-start;
}
.bc-body .d-flex {
    display: -webkit-box;
    display: -webkit-flex;
    display: -moz-box;
    display: -ms-flexbox;
    display: flex;
}
.bc-body .container-fluid {
    padding:0 15px;
}
.bc-body .container-fluid.p-50 {
    padding:0 50px;
}
.bc-body .container{
    max-width:1170px;
    width: 100%;
    margin:0 auto;
}
.bg-dark{
    background:#000;
}

/* ================================= */
/* ------- Tabs Section CSS -------- */
/* ================================= */
.bc-main-wrapp {
	padding: 0;
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 100%;
	overflow: hidden;
	margin-bottom: 0;
	height: 350px;
	box-shadow: 0 0 30px 0 rgba(0,0,0,0.20);
}
.bc-heading{
    margin-bottom:20px;
}
.bc-heading h3{
    font-size:18px;
}
.bc-heading h3,
.bc-heading h4 {
	color:#fff;
    font-weight:600;
}
.bc-heading h4 {
    font-size:26px; 
}
.bc-tabs-nav.nav-tabs > li > a {
	font-weight: 600;
	padding: 5px 30px;
	font-size: 14px;
    margin:0;
    color:#fff;
}
.bc-tabs-nav.nav-tabs > li > a,
.bc-tabs-nav.nav-tabs > li.active > a,
.bc-tabs-nav.nav-tabs > li.active > a:focus,
.bc-tabs-nav.nav-tabs > li.active > a:hover,
.bc-tabs-nav.nav-tabs > li > a:focus,
.bc-tabs-nav.nav-tabs > li > a:hover {
	-webkit-border-radius:5px 5px 0 0;
       -moz-border-radius:5px 5px 0 0;
            border-radius:5px 5px 0 0;
			border:none;
}
.bc-tabs-nav.nav-tabs > li.active > a,
.bc-tabs-nav.nav-tabs > li.active > a:focus,
.bc-tabs-nav.nav-tabs > li.active > a:hover,
.bc-tabs-nav.nav-tabs > li > a:focus,
.bc-tabs-nav.nav-tabs > li > a:hover {
    color: #222;
	background-color: #fff;
}
.bc-tabs-nav.nav-tabs > li:hover {
	background-color:transparent !important;
}
.bc-tabs-nav.nav-tabs > li {
    border:none !important;
}
.bc-heading.d-flex {
	margin-top:15px;
	-webkit-box-pack:end;
	-webkit-justify-content:flex-end;
	   -moz-box-pack:end;
	    -ms-flex-pack:end;
	        justify-content:flex-end;
}
.bc-heading.d-flex,
.bc-change-view {
	-webkit-box-align: center;
	-webkit-align-items: center;
	   -moz-box-align: center;
	    -ms-flex-align: center;
	        align-items: center;
}
.bc-change-view {
	background: #C3193C;
	height: 39px;
	width: 39px;
	padding: 5px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -moz-box;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-pack: center;
	-webkit-justify-content: center;
	   -moz-box-pack: center;
	    -ms-flex-pack: center;
	        justify-content: center;
}
.bc-change-view, .bc-card-view-option {
	-webkit-border-radius: 5px;
	   -moz-border-radius: 5px;
	        border-radius: 5px;
			cursor: pointer;

}
.bc-change-view .bc-default-change-view,
.bc-active-view .bc-change-view .bc-default-view {
    display:none;
}
.bc-change-view .bc-default-change-view,
.bc-active-view .bc-change-view .bc-default-view,
.bc-card-view-option,
.bc-card-view-option .bc-collapse-all,
.bc-card-view-active .bc-card-view-option .bc-expand-all,
.bc-card-view-active .bc-card-view-option .bc-collapse-all {
	-webkit-transition: ease all 0.5s;
	-o-transition: ease all 0.5s;
	-moz-transition: ease all 0.5s;
	transition: ease all 0.5s;
}
.bc-active-view .bc-change-view .bc-default-change-view{
    display:block;
}
.bc-card-view-option {
	border: 2px solid #C3193C;
	color: #fff;
	padding: 7px 50px;
	margin-right:15px;
}
.bc-card-view-option:hover{
	background:#C3193C;
}
.bc-card-view-option .bc-collapse-all,
.bc-card-view-active .bc-card-view-option .bc-expand-all {
	display: none;
}
.bc-card-view-active .bc-card-view-option .bc-collapse-all {
	display: block;
}
/** Main tab **/
.bc-business-capability-wrapp{
    display: -webkit-box;
    display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: nowrap;
    flex-wrap: nowrap;
    margin:0 -10px;
}
.bc-business-capability {
	-webkit-box-flex: 0;
	-ms-flex: 0 0 15px;
	flex: 0 0 10%;
	max-width: 10%;
	width: 100%;
	padding: 0 10px;
	margin-bottom:5px;
	position: relative;
}
.bc-business-capability .bc-business-capability-box,
.bc-sub-business-capability .bc-business-capability-box,
.bc-business-capability h4,
.bc-business-capability .bc-business-capability-box p {
	-webkit-transition: ease all 0.5s;
	-o-transition: ease all 0.5s;
	-moz-transition: ease all 0.5s;
	transition: ease all 0.5s;
}
.bc-business-capability h4 {
	font-weight: 900;
	font-size: 14px;
	line-height: 18px;
	color: #FFFFFF;
	text-align: center;
	margin-bottom: 10px;
	min-height:45px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: -moz-box;
	display: flex;
	-webkit-box-align:  flex-start;
	-webkit-align-items:  flex-start;
	-ms-flex-align:  flex-start;
	-moz-box-align: start;
	     align-items: flex-start;
	-webkit-box-pack: center;
	-webkit-justify-content: center;
	-ms-flex-pack: center;
	-moz-box-pack: center;
	     justify-content: center;
	position: -webkit-sticky;
	position: sticky;
	top: 0;
	left: 0;
	right: 0;
	margin: 0 auto;
	background: #000;
}
.bc-business-capability .bc-business-capability-box {
	background: #C3193C;
	border-radius: 10px;
	border: 2px solid #fff;
	text-align: center;
    padding:15px 10px;
    cursor: pointer;
}
.bc-sub-business-capability .bc-business-capability-box {
	background: #fff;
	border-color:#C3193C;
}
.bc-business-capability .bc-business-capability-box h5 {
	white-space: nowrap;
	font-weight: bold;
    font-size:16px;
    line-height:16px;
    text-align: center;
    color: #FFFFFF;
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    -webkit-box-align: center;
    -webkit-align-items: center;
        -ms-flex-align: center;
            align-items: center;
    -webkit-box-pack: center;
    -webkit-justify-content: center;
        -ms-flex-pack: center;
            justify-content: center;
    margin-bottom:5px;
}
.bc-business-capability .bc-business-capability-box h5 span {
	display: inline-block;
	margin-right: 10px;
	max-width: 20px;
	width: 100%;
}
.bc-business-capability .bc-business-capability-box h5 span img{
	width:100%;
}
.bc-business-capability .bc-business-capability-box p {
	font-size: 12px;
	text-align: center;
	color: #FFFFFF;
	line-height: 16px;
}
.bc-business-capability .bc-business-capability-box p.read-next,
.bc-card-view-active .bc-business-capability .bc-business-capability-box.read-more p.read-next{
	opacity:0;
	height:0;
	visibility: hidden;
}
.bc-card-view-active .bc-business-capability .bc-business-capability-box p.read-next{
	opacity:1;
	height:100%;
	visibility: visible;
}
.bc-business-capability .bc-business-capability-box.read-more p.read-next{
	opacity:1;
	height:100%;
	visibility: visible;
}
.bc-business-capability .arrow-icon {
	display: block;
	text-align: center;
	color: #fff;
	font-size: 15px;
	margin: 10px 0 0 0;
	line-height: 13px;
}
.bc-business-sub-capability .bc-business-capability-box {
	background: #fff;
	border: 2px solid #C3193C;
	margin-top: 10px;
}
.bc-business-sub-capability .bc-business-capability-box h5,
.bc-business-sub-capability .bc-business-capability-box p{
    color:#C3193C;
}
.bc-business-capability{
	height:100%;
	max-height:260px;
}
#content-panel {
	width: 100%;
	position: relative;
}
.modal-backdrop {
	z-index: -1;
}

/* ================================= */
/* ---- Section View Change CSS ---- */
/* ================================= */
.bc-active-view .bc-business-capability {
	height: auto;
	overflow-x: auto;
	scrollbar-width: thin;
	-webkit-box-flex: 0;
	-webkit-flex: 0 0 100%;
	   -moz-box-flex: 0;
	    -ms-flex: 0 0 100%;
	        flex: 0 0 100%;
	max-width: 100%;
	max-height:100%;
}
.bc-active-view .bc-business-capability,
.bc-active-view .bc-business-sub-capability,
.bc-active-view .bc-business-sub-capability  {
	display: -webkit-box;
	display: -webkit-flex;
	display: -moz-box;
	display: -ms-flexbox;
	display: flex;
}
.bc-active-view .bc-business-capability,
.bc-active-view .bc-business-capability h4,
.bc-active-view .bc-business-sub-capability {
	-webkit-box-align: center;
	-webkit-align-items: center;
	   -moz-box-align: center;
	    -ms-flex-align: center;
	        align-items: center;
}
.bc-active-view .bc-business-capability .bc-business-capability-box h5,
.bc-active-view .bc-business-capability .bc-business-capability-box h5 span{
	display: block;
}
.bc-active-view .bc-business-capability .bc-business-capability-box h5 span {
	display: block;
	margin: 10px auto;
}
.bc-active-view .bc-business-capability-wrapp {
	display: block;
}
.bc-active-view .bc-business-capability h4 {
	min-width: 130px;
	max-width: 130px;
	margin: 0 10px 0 0;
	text-align: left;
	line-height: 20px;
	font-size: 14px;
	-webkit-box-pack: start;
	-webkit-justify-content: flex-start;
	-moz-box-pack: start;
	-ms-flex-pack: start;
	justify-content: flex-start;
	position: -webkit-sticky;
	position: sticky;
	left: 0;
	background: #000;
	z-index: 999;
	align-items: center;
	min-height: 146px;
	border-radius: 0 15px 15px 0;
}
.bc-active-view .bc-business-capability .bc-business-capability-box {
	min-height: auto;
	height:auto;
	min-width:170px;
	max-width:170px;
	margin:0 0 10px 0;
	-webkit-transition: ease all 0.5s;
	-o-transition: ease all 0.5s;
	-moz-transition: ease all 0.5s;
	transition: ease all 0.5s;
	padding: 0 10px 15px 10px;
}
.bc-active-view.bc-main-wrapp {
	overflow-y: auto;
	overflow-x: hidden;
}
.bc-active-view #content-panel {
	overflow-x: hidden;
}
.bc-active-view .bc-business-capability .arrow-icon {
	min-width:30px;
	-webkit-transform: rotate(-90deg);
	   -moz-transform: rotate(-90deg);
	    -ms-transform: rotate(-90deg);
	     -o-transform: rotate(-90deg);
	        transform: rotate(-90deg);
	margin: -10px 0 0 0;
}
/* ================================= */
/* ------------ Model CSS ---------- */
/* ================================= */
.bc-business-model.fade.in,
.bc-business-sub-model.fade.in{
	background: rgba(0,0,0,0.8);
}
.bc-business-model .modal-dialog,
.bc-business-sub-model .modal-dialog {
    -webkit-transform: translate(0,-50%) !important;
    -ms-transform: translate(0,-50%) !important;
        transform: translate(0,-50%) !important;
    top: 50%;
    margin: 0 auto;
    -webkit-transition: ease all 0.5s;
    -o-transition: ease all 0.5s;
    transition: ease all 0.5s;
}
.bc-business-model .modal-content,
.bc-business-sub-model .modal-content{
    background: #C3193C;
	-webkit-border-radius: 10px;
	        border-radius: 10px;
	border: 2px solid #fff;
    padding:30px;
}
.bc-business-sub-model .modal-content{
    background: #fff;
	border: 2px solid #C3193C;
}
.bc-business-model .modal-content .modal-header,
.bc-business-sub-model .modal-content .modal-header{
    border:none;
}
.bc-business-model .modal-content .modal-header .close,
.bc-business-sub-model .modal-content .modal-header .close {
	color: #fff;
	text-shadow: none;
	opacity: 1;
}
.bc-business-sub-model .modal-content .modal-header .close {
	color: #C3193C;
}
.bc-business-model .modal-content .modal-header h4,
.bc-business-sub-model .modal-content .modal-header h4 {
	font-size: 22px;
	color: #fff;
	font-weight: 600;
	letter-spacing: 1px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-align: center;
	-webkit-align-items: center;
	    -ms-flex-align: center;
	        align-items: center;
}
.bc-business-sub-model .modal-content .modal-header h4 {
	color: #C3193C;
}
.bc-business-model .modal-content .modal-header h4 span,
.bc-business-sub-model .modal-content .modal-header h4 span {
	display: inline-block;
	margin: 0 15px 0 0;
}
.bc-business-model .modal-content .modal-body p,
.bc-business-sub-model .modal-content .modal-body p{
    color:#fff;
    font-size:16px;
    line-height:30px;
}
.bc-business-sub-model .modal-content .modal-body p{
    color:#333;
}


/** Verticaliy Scroll **/
#content-panel,
.bc-active-view .bc-business-capability {
	overflow-x: auto;
	scrollbar-color: #C3193C #ddd;
	scrollbar-width: thin;
	-ms-overflow-style: none;
}
.bc-active-view .bc-business-capability {
	overflow-y: hidden;
	margin-bottom:10px;
}
#content-panel::-webkit-scrollbar,
.bc-active-view .bc-business-capability::-webkit-scrollbar{
	height: 3px;
	background-color: #fff;
}
#content-panel::-webkit-scrollbar-track,
.bc-active-view .bc-business-capability::-webkit-scrollbar-track{
	box-shadow: inset 0 0 0px rgba(0, 0, 0, 0);
	-webkit-box-shadow: inset 0 0 0px rgba(0, 0, 0, 0);
}
#content-panel::-webkit-scrollbar-thumb,
.bc-active-view .bc-business-capability::-webkit-scrollbar-thumb{
	height: 3px;
	background-color: #C3193C;
}
#content-panel::-webkit-scrollbar-thumb:hover,
.bc-active-view .bc-business-capability::-webkit-scrollbar-thumb:hover {
	background-color: #C3193C;
}
#content-panel::-webkit-scrollbar:vertical,
.bc-active-view .bc-business-capability::-webkit-scrollbar:vertical{
	display: none;
}
.bc-active-view .bc-business-capability::-webkit-scrollbar:horizontal {
	display: inherit;
}
/** Verticaliy Scroll **/
.bc-business-capability{
	overflow-y: auto;
	scrollbar-color: #C3193C #ddd;
	scrollbar-width: thin;
	-ms-overflow-style: none;
}
.bc-business-capability::-webkit-scrollbar {
	width:3px;
}
.bc-business-capability::-webkit-scrollbar-track{
	-webkit-box-shadow: inset 0 0 0px rgba(0, 0, 0, 0);
	box-shadow: inset 0 0 0px rgba(0, 0, 0, 0);
}
.bc-business-capability::-webkit-scrollbar{
	width: 3px;
	background-color: #fff;
} 
.bc-business-capability::-webkit-scrollbar-thumb{
	border-radius: 40px;
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
	box-shadow: inset 0 0 6px rgba(0,0,0,.3);
	background-color: #C3193C;
}
.bc-business-capability::-webkit-scrollbar:horizontal {
	display: none;
}
/* -------- Responsive CSS --------- */
@media (min-width: 1601px) {
}
@media (max-width: 1600px) {
    #business-capability-here {
        overflow-x: auto;
        width: 100%;
    }
    .bc-business-capability {
        height: 450px;
    }
    .bc-business-capability .bc-business-capability-box p {
        font-size: 14px;
        line-height: 18px;
    }
    .bc-business-capability .bc-business-capability-box h5 {
        font-size: 16px;
        margin-bottom: 5px;
    }
    .bc-business-capability .bc-business-capability-box {
        padding: 15px 10px;
    }
    .bc-business-capability {
        -webkit-box-flex: 0;
        -webkit-flex: 0 0 15%;
           -moz-box-flex: 0;
            -ms-flex: 0 0 15%;
                flex: 0 0 15%;
        max-width: 15%;
    }
}
@media (max-width: 1320px){
}
@media (max-width:1199px) {
}
@media (max-width: 1600px) {
}
@media (max-width: 1200px) {
}
@media (max-width: 991px) {
    .bc-business-capability {
        -webkit-box-flex: 0;
        -webkit-flex: 0 0 25%;
        -moz-box-flex: 0;
        -ms-flex: 0 0 25%;
        flex: 0 0 25%;
        max-width: 25%;
    }
}
@media (max-width: 767px) {
    .bc-business-capability {
        -webkit-box-flex: 0;
        -webkit-flex: 0 0 33.33%;
        -moz-box-flex: 0;
        -ms-flex: 0 0 33.33%;
        flex: 0 0 33.33%;
        max-width: 33.33%;
    }
}
@media (max-width: 575px) {
    .bc-business-capability {
        -webkit-box-flex: 0;
        -webkit-flex: 0 0 50%;
        -moz-box-flex: 0;
        -ms-flex: 0 0 50%;
        flex: 0 0 50%;
        max-width: 50%;
    }
}
.off-cap{
		border: 1pt solid #ccc;
		border-left: 3px solid rgb(125, 174, 198);					
		background-color: rgb(237, 237, 237);
		color:#d3d3d3;  

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
							<div class="pull-right Key">
								<b>Caps Style:</b><button class="btn btn-xs btn-secondary" id="hideCaps">Showing</button><xsl:text> </xsl:text>
								<b>Application Usage Key</b>: <i class="fa fa-square shigh"></i> - High<xsl:text> </xsl:text> <i class="fa fa-square smed"></i> - Medium <xsl:text> </xsl:text> <i class="fa fa-square slow"></i> - Low
						
						</div>
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
						 <span id="capsId"><xsl:attribute name="easid">{{this.svc}}</xsl:attribute><h3>{{this.svcName}}</h3>
							<span class="appsvc-circle ">S</span>: Application Service Lifecycle<br/>
							<span class="appsvc-circle ">A</span>: Application Lifecycle 
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
										 {{#getLifecycle this.app.tosvcLifecycle 'svc'}}{{/getLifecycle}}
									</div>
								</div>
								<div class="clearfix"/>
								<div class="mini-details">
									<div class="small pull-left text-white">
										<div class="left-5 bottom-5"><i class="fa fa-th right-5"></i>{{this.app.allServices.length}} Supported Services</div>
										<div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{this.app.services.length}} Services Used</div>
										<div class="left-5 bottom-5"><i class="fa fa-sign-in right-5"></i>{{this.app.inIList.length}} Applications In</div>
										<div class="left-5 bottom-5"><i class="fa fa-sign-out right-5"></i>{{this.app.outIList.length}} Applications Out</div>
								 
										{{#if this.stds}}
										<table width="100%">
											<tr><th width="150px">Organisation</th><th>Status</th></tr>
											{{#each this.stds}}
											<tr><td>{{this.org}}</td><td> {{#getStdColour this.strId this.str}}{{/getStdColour}}  </td></tr>
											{{/each}}
										</table>	
										{{/if}}
									</div>

									<button class="btn btn-default btn-xs appInfoButton pull-right"><xsl:attribute name="easid">{{this.app.id}}</xsl:attribute>Show Details</button>
									
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
								<li><a data-toggle="tab" href="#capabilities">Capabilities<span class="badge dark">{{capsImpacting.length}}</span></a></li>
								<li><a data-toggle="tab" href="#processes">Processes<span class="badge dark">{{processList.length}}</span></a></li>
								<li><a data-toggle="tab" href="#integrations">Integrations<span class="badge dark">{{totalIntegrations}}</span></a></li>
			                 	<li><a data-toggle="tab" href="#services">Services <span class="badge dark">{{allServices.length}}</span></a></li>
								<li></li>
							</ul>

					
							<div class="tab-content">
								<div id="summary" class="tab-pane fade in active">
									<div>
				                    	<strong>Description</strong>
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
												<i class="fa fa-users right-5"/>{{processes.length}} Processes Supported</div>
		                				<div class="ess-tag ess-tag-default">
												<xsl:attribute name="style">background-color:#6849D0;color:#ffffff</xsl:attribute>
												<i class="fa fa-exchange right-5"/>{{totalIntegrations}} Integrations ({{inI}} in / {{outI}} out)</div>
		                			</div>
								</div>
								<div id="capabilities" class="tab-pane fade">
										<p class="strong">This application supports the following Business Capabilities:</p>
										<div>
										{{#if capsImpacting}}
										{{#each capsImpacting}}
											<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
										{{/each}} 
										{{else}}
											<p class="text-muted">None Mapped</p>
										{{/if}}
										</div>
									</div>
								<div id="processes" class="tab-pane fade">
									<p class="strong">This application supports the following Business Processes, supporting {{processes.length}} physical processes:</p>
									<div>
									{{#if processList}}
									{{#each processList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted">None Mapped</p>
									{{/if}}
									</div>
								</div>
								<div id="services" class="tab-pane fade">
									<p class="strong">This application supports the following Services:</p>
									<div>
									{{#if servList}}
									{{#each servList}}
										<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#73B9EE;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
									{{/each}} 
									{{else}}
										<p class="text-muted">None Mapped</p>
									{{/if}}
									</div>
								</div>
								<div id="integrations" class="tab-pane fade">
			                    <p class="strong">This application has the following integrations:</p>
			                	<div class="row">
			                		<div class="col-md-6">
			                			<div class="impact bottom-10">Inbound</div>
			                				{{#each inIList}}
			                                <div class="ess-tag bg-lightblue-100">{{name}}</div>
			                            	{{/each}}
			                		</div>
			                		<div class="col-md-6">
			                			<div class="impact bottom-10">Outbound</div>
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
jQuery(function ($) {
  "use strict";
    
  jQuery(function ($) {
    $(".bc-change-view").on("click", function () {
      $(".bc-main-wrapp").toggleClass("bc-active-view");
    });
  });

  jQuery(function ($) {
    $(".bc-card-view-option").on("click", function () {
      $(".bc-main-wrapp").toggleClass("bc-card-view-active");
    });
  });

  $('.bc-business-capability-box').click(function(){
    $(this).toggleClass('read-more');
 });

  $(document).ready(function() {
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
			console.log('stdStyles',stdStyles); 
		console.log('arg1',arg1);
			let thisCol= stdStyles.find((d)=>{
				return d.id==arg1;
			});
			console.log('thisCol',thisCol)
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
	var workingCaps;

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
			for (i = 0; i  &lt; level ; i++) {
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


			capMod.then((d) => {
				workingArray = [];
				
				essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'ACTOR_TO_ROLE_RELATION', 'SYS_CONTENT_APPROVAL_STATUS']);

				
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
			});
		})

	}).catch(function (error) {
		//display an error somewhere on the page
	});

	let scopedApps = [];
	let inScopeCapsApp = [];
	let scopedCaps = [];
	let scopedSvcs = [];

	var redrawView = function () { 
			workingCapId = 0;
			let workingAppsList = [];
			let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
			let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
			let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
			let a2rScopingDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION');
		//	let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
	 

			let apps = appArray.applications;

			scopedApps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef, a2rScopingDef]);
			scopedCaps = essScopeResources(workingArrayAppsCaps, [visibilityDef]);
			scopedService = essScopeResources(workingsvcArray, [geoScopingDef, visibilityDef]);
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


									appToShow[0]['processList'] = procListTosShow;
									appToShow[0]['servList'] = servsArr;
									appToShow[0]['servUsedList'] = thisUsedServs;
									appToShow[0]['capsImpacting'] = thisAppCapArray;
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
 
if(d.lifecycle){
		appIn['tosvcLifecycle'] = d.lifecycle;
}
if(appIn){
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
 console.log('panelData',panelData)
	$('#appData').html(appTemplate(panelData));

	$('#appsList').empty();
	$('#appsList').html(appListTemplate(panelData))
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
});

function getArrayDepth(arr) {

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
$('window').scroll(function () {
	if ($(this).scrollTop() &gt; 40) {
		$('#appSidenav').css('position', 'fixed');
		$('#appSidenav').css('height', 'calc(100%)');
		$('#appSidenav').css('top', '0');
	}
	if ($(this).scrollTop() &lt; 40) {
		$('#appSidenav').css('position', 'fixed');
		$('#appSidenav').css('height', 'calc(100% - 40px)');
		$('#appSidenav').css('top', '41px');
	}
});

$('.closePanel').slideDown();

function toggleMiniPanel(element) {
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
