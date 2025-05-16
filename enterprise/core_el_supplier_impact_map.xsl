<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Composite_Application_Provider', 'Technology_Product', 'Technology_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="busCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCaps" select="/node()/simple_instance[type = 'Report_Constant'][own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$busCaps[name = $rootBusCaps/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="rootLevelBusCaps" select="$busCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="supplier" select="/node()/simple_instance[type = 'Supplier']"/>
<!--
	<xsl:variable name="supplierContracts" select="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION'][own_slot_value[slot_reference = 'obligation_component_to_element']/value = $allTechProds/name or own_slot_value[slot_reference = 'obligation_component_to_element']/value = $allApps/name]"/>
	<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	<xsl:variable name="contracts" select="/node()/simple_instance[type = 'Compliance_Obligation'][name = $supplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value][own_slot_value[slot_reference = 'compliance_obligation_licenses']/value = $alllicenses/name]"/>
	<xsl:variable name="licenses" select="/node()/simple_instance[type = 'License'][name = $contracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
	<xsl:variable name="actualContracts" select="/node()/simple_instance[type = 'Contract'][own_slot_value[slot_reference = 'contract_uses_license']/value = $licenses/name]"/>
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>

-->
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="geoLocation" select="/node()/simple_instance[type = 'Geographic_Location'][name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="geoCode" select="/node()/simple_instance[type = 'GeoCode'][name = $geoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
  
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Supplier Impact']"/>
    <xsl:variable name="supplierData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Suppliers']"></xsl:variable>
    <xsl:variable name="supplierKPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Support KPIs'[own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"></xsl:variable>
	<xsl:variable name="capsAppsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
    <xsl:variable name="techProdSuppData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"></xsl:variable>
     <!--<xsl:variable name="techProdSuppData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Products and Suppliers']"></xsl:variable>
   
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
        <xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathSupplier">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$supplierData"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathSupplierKPI">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$supplierKPI"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$capsAppsData"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathTechProds">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$techProdSuppData"/>
            </xsl:call-template>
        </xsl:variable>
     
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<script type="text/javascript" src="js/d3/d3.v2.min.js?release=6.19"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Supplier Map</title>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css?release=6.19" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js?release=6.19" type="text/javascript"/>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js?release=6.19" type="text/javascript"/>
				<script src="js/chartjs/Chart.min.js?release=6.19"></script>

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
						min-height:70px;
					}
					.l1-caps-wrapper{
						display: flex;
						flex-wrap: wrap;
						margin-top: 10px;
					}

                    .l1-cap,.l2-cap,.l3-cap,.l4-cap{
						border-bottom: 1px solid #fff;
						border-radius:5px;
						box-shadow:1px 1px 3px #e3e3e3;
						padding: 5px 25px 5px 5px;
						margin: 0 10px 10px 0;
						font-weight: 400;
						position: relative;
						min-height: 70px;
						line-height: 1.1em;
                        font-size:0.9em;
                        color:#000000 !important;
                        width:13%;
                        display:inline-block;
                        vertical-align:top;
					}
                    .sub-cap-label > a{
                        color:#000000 !important;
                    }

					.tile-stats{
						transition: all 300ms ease-in-out;
						border-radius: 10px 10px 10px 10px;
						border: 1pt solid #d3d3d3;
					}
					
					.tile-stats .icon{
						width: 60px;
						height: 60px;
						color: #e5bebe;
						position: absolute;
						right: 30px;
						top: 10px;
						z-index: 1;
						opacity: 0.75;
					}
					
					.tile-stats .icon i{
						font-size: 60px;
					}
					
					.tile-stats .count{
						font-size: 30px;
						font-weight: bold;
						line-height: 1.65857
					}
					
					.tile-stats .count,
					.tile-stats h3,
					.tile-stats p{
						position: relative;
						margin: 0;
						margin-left: 10px;
						z-index: 5;
						padding: 0
					}
					
					.tile-stats h3{
						color: #BAB8B8
					}
					
					.tile-stats p{
						margin-top: 5px;
						font-size: 12px
					}
					
					.card{
						width: 150px; /* Set width of cards */
						border: 1px solid #d3d3d3; /* Set up Border */
						border-radius: 1px; /* Slightly Curve edges */
						overflow: hidden; /* Fixes the corners */
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis */
						margin: 3px;
						box-shadow: 3px 3px 3px #d3d3d3;
					}
					
					.card-process{
						text-align: center;
						font-size: 12px;
						font-weight: 600;
						border-bottom: 1px solid #d3d3d3;
						background-color: #d0d6d6;
						color: #2f2a2a;
						padding: 5px 10px;
						height: 30pt;
					}
					
					.card-header{
						color: #ffffff;
						text-align: center;
						font-size: 11px;
						font-weight: 600;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
					
						border-bottom: 1px solid #aea9f0;
						background-color: #6c6d6d;
						padding: 5px 10px;
					}
					
					.card-main{
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis to Vertical */
						justify-content: center; /* Group Children in Center */
						align-items: center; /* Group Children in Center (+axis) */
						padding: 5px 0; /* Add padding to the top/bottom */
					}
					
					.card-tech{
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis to Vertical */
						justify-content: center; /* Group Children in Center */
						align-items: center; /* Group Children in Center (+axis) */
						padding: 5px 0;
						font-size: 8pt;
						background-color: #d9bebe; /* Add padding to the top/bottom */
					}
					
					.card-score-main{
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis to Vertical */
						justify-content: center; /* Group Children in Center */
						align-items: center; /* Group Children in Center (+axis) */
						padding: 15px 0; /* Add padding to the top/bottom */
						background-color: #e8e8e8;
					}
					
					.main-description{
						color: #080707;
						font-size: 10px;
						text-align: left;
						padding-left: 5px;
						height: 10px;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
					}
					
					.tech-description{
						font-size: 8pt;
						text-align: center;
					}
					
					
					rect{
						fill: #00ffd0;
					}
					
					text{
						font-weight: 300;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
						font-size: 10px;
						font-weight: bold;
					}
					
					.node rect{
						stroke: #999;
						fill: #fff;
						stroke-width: 1px;
					}
					
					.edgePath path{
						stroke: #333;
						stroke-width: 1px;
					}
					
					.processes{
						font-size: 8pt;
					}
					
					.h3text{
						font-size: 1.5 vw
					}
					
					.normaltext{
						font-size: 1.2 vw
					}
					
					.fas{
						font-size: 1.0 vw
					}
					
					.capBox{
						margin: 3px;
						horizontal-align: center;
						vertical-align: center;
						border-radius: 4px;
						font-size: 8pt;
						float: left;
						padding: 5px 5px 0 5px;
						border: 1pt solid #ccc;
						width: 100%;
						}
					
					.refModel-blob,
					.busRefModel-blob,
					.appRefModel-blob,
					.techRefModel-blob{
						display: flex;
						align-items: center;
						justify-content: center;
						width: 120px;
						max-width: 120px;
						height: 50px;
						padding: 3px;
						max-height: 50px;
						overflow: hidden;
						border: 1px solid #aaa;
						border-radius: 4px;
						float: left;
						margin-right: 10px;
						margin-bottom: 10px;
						text-align: center;
						font-size: 12px;
						position: relative;
					}
					
					.refModel-blob-title{
						line-height: 1em;
					}
					
					.refModel-l0-title{
						margin-bottom: 5px;
						line-height: 1.1em;
					}
					
					.appList{
						background-color: #666;
						color: #fff;
						width: 100%;
						border: 1pt solid #d3d3d3;
						padding: 5px;
						margin-top: 10px;
					}
					
					.appList > i {
						margin-right: 5px;
					}
					
					.appList > span > a {
						color: #fff;
					}
					
					.appCapList{
						background-color: #ffffff;
						border-bottom: 1pt solid #d3d3d3;
						padding: 3px 6px;
						color: #333;
						margin-top: 5px;
					}
					
					.appCapList i.fa-sitemap,.appCapList i.fa-server {
						margin-right: 5px;
					}
					.appCapList i.fa-info-circle {
						margin-left: 5px;
					}
					.appListBg{
						background-color: #ffffff;
						border-bottom: 1pt solid #d3d3d3;
                        padding-left: 10px}

                    .appListtech{
                        background-color: #fff;
                        color:#000;
                        padding-left: 5px;
                        padding-top: 2px;
                        border-bottom: 1pt solid #d3d3d3;}
                    
                    .mini-details {
                            display: none;
                            position: relative;
                            float: left;
                            width: 100%;
                            padding: 5px 5px 0 5px;
                            background-color: #454545;
                        }
					
					.suppName{
						padding: 5px 10px;
					}
					
					.planBody,
					planHead{
						float: left;
					}
					
					.planHead{
						width: 100%;
						font-size: 12pt;
						font-weight: bold
					}
					
					.planName{
						font-size: 11pt;
						font-weight: normal;
						padding-left: 10px
					}
					
					.planImpact{
						background-color: #eaeaea;
						font-size: 11pt;
						font-weight: nomal
					}
					
					.planDate{
						float: right;
						//background-color: #f0f0f0;
						//border: 0pt solid #d3d3d3;
						padding: 3px;
						position:relative;
						top:-35px;
						right:20px
					}
					#supplierDiv,#supplierDiv2{
						overflow-y:scroll;
						max-height:calc(100vh - 250px);
						font-size: 90%;
					}
                    .supplier-circle{
                        min-width: 10px;
						padding: 2px 5px;
						font-size: 10px;
						font-weight: 700;
						line-height: 1;
                        border: 1pt solid #000000;
                        background-color:white;
						text-align: center;
                        position:absolute;
                        right:3px;
                        top:4px;
						white-space: nowrap;
						vertical-align: middle;
						width: 22px;
						border-radius: 10px;
						height: 16px;
                    }

                    .sidenav{
						height: calc(100vh - 78px);
						width: 500px;
						position: fixed;
						z-index: 1;
						top: 78px;
						right: 0;
						background-color: #f6f6f6;
						overflow-x: hidden;
						transition: margin-right 0.5s;
						padding: 10px 10px 10px 10px;
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
						margin-right: -752px;
					}
					
					.sidenav .closebtn{
						position: absolute;
						top: 5px;
						right: 10px;
						font-size: 14px;
						margin-left: 50px;
					}
					
					@media screen and (max-height : 450px){
						.sidenav{
							padding-top: 53px;
						}
					
						.sidenav a{
							font-size: 14px;
						}
					}
                    .supplierBox{
						border-radius: 4px;
						margin-bottom: 10px;
						float: left;
						width: 100%;
						border: 1px solid #333;
					}
					
					.supplierBox a {
						color: #fff!important;
					}
					
					.supplierBox a:hover {
						color: #ddd!important;
					}
					
					.supplierBoxSummary {
						background-color: #333;
						padding: 5px;
						float: left;
						width: 100%;
					}
					
					.supplierBoxTitle {
						width: 200px;
						white-space: nowrap;
						overflow: hidden;
						text-overflow: ellipsis;
					}
                    #supplierPanel {
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
                    .closePanelButton{
                        position:absolute;
                        right:10px;
                    }
                    .esgScoreHolderBox{
                        position: absolute;
                        bottom:3px;
                    }
                    .esgScoreHolder{
                        width:25px;
                        display:inline-block;
                        position: relative;
                        bottom:3px;
                        
                    }
                    .topEsg{
                        width:23px;
                        background-color: #554d88;
                        color:white;
                        border-radius: 4px 4px 0px 0px;
                        text-align: center;
                    }
                    .btmEsg{
                        width:23px;
                        background-color: #f0f0f0;
                        color:#000000;
                        border-radius: 0px 0px 4px 4px;
                        text-align: center;
                    }
                    .lozenge{
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
                    .esgTitle{
                        border-radius: 2px;
                        border-radius: 5px 0px 0px 5px;
                        margin: 2px;
                        text-align: center;
                        background-color: #ffffff;
                        color: #535353;
                        font-size: 0.8em;
                        padding-right: 8px;
                        padding-left: 2px;
                        margin-right: -6px;
                    }
                    .monopoly-card {
                        
                        width: 119px;
                        border: 2px solid black;
                        border-radius: 10px;
                        background-color: #f3f3f3;
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                        font-family: 'Arial', sans-serif;
                        margin: 6px;
                        padding: 3px;
                        display:inline-block;
                        height:70px;
                       
                        vertical-align: top;
                    }

                    .card-title {
                        background-color: #338d16;
                        color: white;
                        text-align: center;
                        padding: -2px;
                        border-radius: 8px 8px 0 0;
                        font-weight: bold;
                        font-size: 0.8em;
                    }

                    .card-content {
                        padding: 6px;
                        text-align: center;
                        font-size: 0.8em;
                        height: 43px;
                        overflow-y: auto;
                    }
                   #suppcanvas {
                        background-color: white;
                    }
                    .highlightClass{
                        background-color: #44a3fb;
                    }
                    .keyDiv{
                        font-size:0.9em;
                        border-radius:6px;
                        display:inline-block;
                        margin:2px;
                        padding:3px;
                        padding-left:5px;
                        padding-right:5px;
                    }
                    .contractBox{
                        border:1pt solid #ffffff;
                        border-radius:5px;
                        max-height:160px;
                        overflow-y: auto;
                        display: inline-block;
                        padding:2px;
                        width:210px;
                        margin:2px;
                        background-color:#e3e3e3;
                        color:#000;
                    }
                    
				</style>
				<script>

                        var suppTemplate;
                        var capTemplate,capHeader;
                        $(document).ready(function() {
                            var suppFragment = $("#supplier-template").html();
                            suppTemplate = Handlebars.compile(suppFragment);
                    
                            var capFragment = $("#capability-template").html();
                            capTemplate = Handlebars.compile(capFragment);

                            var headerFragment = $("#caphead-template").html();
                            capHeader = Handlebars.compile(headerFragment);
                            

                            var esgFragment = $("#esg-template").html();
                            esgScoreTemplate = Handlebars.compile(esgFragment);
                            

                            var summaryFragment = $("#suppSummaryTemplate").html();
                            summaryTemplate = Handlebars.compile(summaryFragment);
                            
                            var keyFragment = $("#key-template").html();
                            keyTemplate = Handlebars.compile(keyFragment);
                      
                            var timeFragment = $("#time-template").html();
                            timeTemplate = Handlebars.compile(timeFragment);

                            supplierListFragment = $("#supplierList-template").html();
			                supplierListTemplate = Handlebars.compile(supplierListFragment);
                            
                            $('#pickSuppliers').select2({width:'250px', theme: "bootstrap"});
                        });
                </script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
                <xsl:call-template name="ViewUserScopingUI"></xsl:call-template> 
				<!-- ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Supplier Impact')"/>
									</span>
								</h1>
							</div>
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<div class="col-xs-9">
							<div class="pull-left">
								<span class="right-10"><strong>Supplier Filter</strong>:</span>
								<select id="pickSuppliers" class="select2">
									<option name="All">Choose</option>
									 
								</select>
							</div>
						</div>
						
										
						<div class="key pull-right" id="sqvKey"></div>
						<div class="col-xs-12 top-15">
							<div class="clearfix"/>
							<ul class="nav nav-tabs">
								<li class="active">
									<a data-toggle="tab" href="#cap">Capability Overview</a>
								</li>
								<li>
									<a data-toggle="tab" href="#plans">Other Overview</a>
								</li>
							</ul>

							<div class="tab-content">
								<div id="cap" class="tab-pane fade in active">
									<div class="row">
										<div class="col-xs-12">
                                            <div class="top-15" id="capabilitiesDivHeader"/>
                                            
											<div class="top-15" id="capabilitiesDiv"/>
										</div>
									</div>
								</div>
								<div id="plans" class="tab-pane fade">
									<h4 class="top-15">Plans impacting elements of the business supported by the supplier</h4>
									<hr/>
									<div class="row">
										<div class="col-xs-9">
											<div id="supplierTime"/>
										</div>
										<div class="col-xs-3">
											<div id="supplierDiv2"/>
										</div>
									</div>
								</div>

							</div>
						</div>
                        
                        <script id="suppSummaryTemplate" type="text/x-handlebars-template">
                            <h2>{{this.name}}</h2>
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#mainTab">Summary</a></li>
                                <li><a data-toggle="tab" href="#processTab">Processes {{#if this.processInfo.0.processes}} {{this.processInfo.0.processes.length}}{{else}}0{{/if}}</a></li>
                                <li><a data-toggle="tab" href="#appsTab">Applications {{this.apps.length}}</a></li> 
                                <li><a data-toggle="tab" href="#techTab">Technology {{this.technologies.length}}</a></li> 
                                <li><a data-toggle="tab" href="#contractsTab">Contracts {{this.contracts.length}}</a></li> 
                            </ul>
                        
                            <div class="tab-content">
                                <div id="mainTab" class="tab-pane fade in active">
                                    {{this.name}}
                                    <br/>
                                    {{#if this.esgScore}}
                                    <div class="esgTitle"><xsl:attribute name="style">width:100px;display:inline-block</xsl:attribute> ESG Status </div>
                                   <div class="lozenge">
                                    <xsl:attribute name="style">{{#getStyle this.esgScore}}{{/getStyle}};width:150px;display:inline-block</xsl:attribute>
                                        {{#if this.esgValue}}
                                        {{this.esgValue}}
                                        {{else}}
                                        Not rated
                                        {{/if}}
                                    </div>
                                    <br/>
                                    <canvas id="suppcanvas"/>
                                    {{/if}}
                                </div>
                                <div id="processTab" class="tab-pane fade in" style="overflow-y:auto">
                                    {{#if this.processInfo.0.processes}}
                                    {{#each this.processInfo.0.processes}}
                                    <div class="monopoly-card">
                                        <div class="card-title"><xsl:attribute name="style">background-color:#ebca38; color:#000000</xsl:attribute>Process</div>
                                        <div class="card-content"> {{#essRenderInstanceMenuLink this.busProc}}{{/essRenderInstanceMenuLink}}</div>
                                    </div>
                                    {{/each}}
                                    {{else}}
                                        No processes impacted
                                    {{/if}}
                                </div>
                                <div id="appsTab" class="tab-pane fade in" style="overflow-y:auto"> 
                                    {{#each this.apps}}
                                        <div class="monopoly-card">
                                            <div class="card-title"><xsl:attribute name="style">background-color:#42ecf5; color:#000000</xsl:attribute>Application</div>
                                            <div class="card-content"> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                                        </div>
                                    {{/each}} 
                                    {{#if this.appsImpacted}}
                                    These applications are impacted by the technologies from this supplier<br/>
                                        {{#each this.appsImpacted}}
                                            <div class="monopoly-card">
                                                <div class="card-title"><xsl:attribute name="style">background-color:#42ecf5; color:#000000</xsl:attribute>Application</div>
                                                <div class="card-content"> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                                            </div>
                                        {{/each}} 
                                    {{/if}}
                                </div>
                                <div id="techTab" class="tab-pane fade in" style="overflow-y:auto">
                                    {{#if this.technologies}}
                                    {{#each this.technologies}}  
                                        <div class="monopoly-card">
                                        <div class="card-title"><xsl:attribute name="style">background-color:#4287f5</xsl:attribute>Technology</div>
                                        <div class="card-content"> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                                    </div>
                                    {{/each}}
                                    {{else}}
                                    No technologies in scope 
                                    {{/if}}
                                </div>
                                
                                <div id="contractsTab" class="tab-pane fade in" style="overflow-y:auto">
                                    {{#if this.contracts}}
                                    {{#each this.contracts}} 
                                    <div class="contractBox">
                                        Name: {{this.description}}<br/>
                                        Description: {{this.description}}<br/>
                                        Start:     {{this.startDate}}<br/>
                                        Renewal:     {{this.renewalDate}}<br/>
                                        Model: {{this.renewalModel}}<br/>
                                        Notice:     {{this.renewalNoticeDays}}<br/>
                                        Review Days: {{this.renewalReviewDays}}<br/>
                                    </div>    
                                    {{/each}}
                                    {{else}}
                                        No contract information captured 
                                    {{/if}}
                                </div>
                            </div>
                        </script>
                        <script id="supplierList-template" type="text/x-handlebars-template">
                            <h3>Supplier Information</h3>
                            {{#each this}}
                               <div class="supplierBox">
                                   <xsl:attribute name="easid">{{id}}</xsl:attribute>
                                   <div class="supplierBoxSummary">
                                       <div class="supplierBoxTitle pull-left strong text-white" data-toggle="tooltip">
                                           <xsl:attribute name="title">{{this.name}}</xsl:attribute>
                                           <i class="fa fa-caret-right fa-fw right-5 text-white" onclick="toggleMiniPanel(this)"/>{{#essRenderInstanceMenuLinkLight this}}{{/essRenderInstanceMenuLinkLight}}
                                       </div>
                                       {{#ifEquals ../this.esgOn true}}
                                       <div class="lozenge pull-right">
                                            <xsl:attribute name="style">{{#getStyle this.esgScore}}{{/getStyle}}</xsl:attribute>
                                                {{#if this.esgValue}}
                                                {{this.esgValue}}
                                                {{else}}
                                                Not rated
                                                {{/if}}
                                            </div>
                                        <div class="esgTitle pull-right">ESG</div>
                                        {{else}}
                                        {{/ifEquals}}
                                   </div>
                                   <div class="clearfix"/>
                                   <div class="mini-details">
                                       <div class="small pull-left text-white">
                                           <div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{licences.length}} Licenses</div>
                                           <div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{#if processInfo.0.processes}}{{processInfo.0.processes.length}}{{else}}0{{/if}}  Processes Supported </div>
                                           <div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{#if appInfo.apps}}{{appInfo.apps.length}}{{else}}0{{/if}} Applications</div>
                                           <div class="left-5 bottom-5"><i class="fa fa-th-large right-5"></i>{{technologies.length}} Technologies</div>
                                       </div>
   
                                           <button class="btn btn-default btn-xs showSupplier pull-right"><xsl:attribute name="easid">{{id}}</xsl:attribute>Show Details</button>
                                       
                                   </div>
                                   <div class="clearfix"/>
                               </div>
                           {{/each}}
                        
                   </script> 
						
                        <script>
                        <xsl:call-template name="RenderViewerAPIJSFunction">
                            <xsl:with-param name="viewerAPIPath" select="$apiPath"/>
                            <xsl:with-param name="viewerAPIPathSupp" select="$apiPathSupplier"/>
                            <xsl:with-param name="viewerAPIPathSuppKpi" select="$apiPathSupplierKPI"/>
                            <xsl:with-param name="viewerAPIPathCaps" select="$apiPathCaps"/>
                            <xsl:with-param name="viewerAPIPathTechProds" select="$apiPathTechProds"/>
                        </xsl:call-template>
                </script>
					</div>
				</div>
                <div id="appSidenav" class="sidenav">
                    <a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()">
                        <i class="fa fa-times"></i>
                    </a>
                    <div id="supplierList"/>
                </div>
                <div class="supplierPanel" id="supplierPanel">
                    <i class="fa fa-times closePanelButton left-30"></i>
                    <div id="summaryDetails"/>
                </div>
				<!-- modal -->
				<xsl:call-template name="supHandlebarsTemplate"/>
				<xsl:call-template name="capHandlebarsTemplate"/>
				<xsl:call-template name="timeHandlebarsTemplate"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
  
	<xsl:template name="timeHandlebarsTemplate">
		<script id="time-template" type="text/x-handlebars-template">
    {{#each this}}
        <div class="planHead" style="margin:5px;padding:3px;border-left:3px solid #cc1919;border-radius:3px;min-height:70px;box-shadow:5px 5px 5px #d3d3d3;padding-bottom:15px:"><span style="color:gray">Plan: </span>{{this.name}}<br/>
			<small> From: {{this.fromDate}} to {{this.endDate}} </small><br/>
            <div class="planName planBody"> {{this.impactType}} {{{this.impactName}}} <i> uses </i>   <b>{{{this.app}}}</b></div>
            <div class="planDate planBody">
            {{#if actionRqdA}}<button class="btn btn-success btn-xs">{{this.actionRqdA}}</button> <button class="btn btn-danger btn-xs">{{this.actionRqdC}}</button>{{/if}} <xsl:text> </xsl:text><button class="btn btn-info btn-xs">{{this.impactAction}}</button></div>
            </div>
        <div class="clearfix"/>
{{/each}}
    </script>
	</xsl:template>

	<xsl:template name="supHandlebarsTemplate">
		<script id="supplier-template" type="text/x-handlebars-template">
         
            {{#each apps}}
                <div><xsl:attribute name="class">appList elementName</xsl:attribute><xsl:attribute name="data-easid">{{this.id}}</xsl:attribute> <i class="fa fa-desktop"/>  <span style="font-size:1.1em ">{{{this.name}}}</span>
                    
                {{#each capabilitiesImpacted}}
                    <div><xsl:attribute name="class">appCapList cap{{this.id}}</xsl:attribute><i class="fa fa-sitemap"/> {{{this.name}}} 
                        <i class="fa fa-info-circle impAppsTrigger" data-toggle="popover" data-placement="bottom"/>
                        <div class="hidden popupTitle">
                          <span class="fontBlack uppercase">
                                <xsl:value-of select="eas:i18n('Processes Impacting')"/>
                            </span>
                        </div>
                        <div class="hidden popupContent">
                            {{#each processes}}
                                <i class="fa fa-circle-o"/> {{{this.name}}}<br/>
                            {{/each}}
                        </div>
                    
                    </div> 
                {{/each}}</div>
            {{/each}}
            
          
            {{#each technologies}}
            <div class="appList elementName"><xsl:attribute name="data-easid">{{this.id}}</xsl:attribute> <i class="fa fa-server"/> <span style="font-size:1.1em"> {{{this.name}}}</span>
            {{#each impacted}}
                
                 {{#each caps}}
                    <div><xsl:attribute name="class">appCapList cap{{this.id}}</xsl:attribute><i class="fa fa-sitemap"/> {{{this.name}}}
                        <i class="fa fa-info-circle impAppsTrigger" data-toggle="popover" data-placement="bottom"/>
                        <div class="hidden popupTitle">
                          <span class="fontBlack uppercase">
                                <xsl:value-of select="eas:i18n('Processes Impacting')"/>
                            </span>
                        </div>
                        <div class="hidden popupContent">
                            {{#each processes}}
                                <i class="fa fa-circle-o"/> {{{this.name}}}<br/>
                            {{/each}}
                        </div>
                    
                    </div> 
                    {{/each}}
                {{/each}}
             {{#each impacted}}    
                {{#each apps}}
                <div><xsl:attribute name="class">appListtech</xsl:attribute><i class="fa fa-desktop"/> {{{this.name}}}</div> 
                {{/each}}    
                
            {{/each}}    
            </div>
            {{/each}}
              
        </script>
	</xsl:template>


	<xsl:template name="capHandlebarsTemplate">
        <script id="caphead-template" type="text/x-handlebars-template">
           <a class="scrollDiv"><xsl:attribute name="href">#{{this.id}}</xsl:attribute><xsl:attribute name="easHtmId">{{this.id}}</xsl:attribute><label class="label label-primary capLabels"><xsl:attribute name="easHeadId">{{this.id}}</xsl:attribute>{{this.name}}</label></a> 
        </script>
        
		<script id="capability-template-old" type="text/x-handlebars-template">
            <div><xsl:attribute name="class">col-xs-12 capBox</xsl:attribute><div class="refModel-l0-title fontBlack large">{{name}}</div>
                    <div class="clearfix"/>
                     {{#each this.subCaps}}
                        <div>
                            <xsl:attribute name="class">busRefModel-blob bg-darkblue-40 {{this.id}}</xsl:attribute>
                            <div class="refModel-blob-title">{{this.name}}</div>
                        </div>
                     {{/each}}
                </div>
             <div class="clearfix"/>
        </script>
        <script id="key-template" type="text/x-handlebars-template">
            {{#if this}}
                <b>ESG Key</b>:<xsl:text> </xsl:text>
                {{#each this}}
                    <div class="keyDiv"><xsl:attribute name="style">background-color:{{this.elementBackgroundColour}};color:{{this.elementColour}}</xsl:attribute> {{this.value}}</div>
                {{/each}}
            {{/if}}
        </script>
        
        <script id="esg-template" type="text/x-handlebars-template">
            <div class="esgScoreHolderBox">
                {{#if this.esgScoreCounts}}
                    {{#each this.esgScoreCounts}} 
                        <div class="esgScoreHolder">
                            <div class="topEsg"><xsl:attribute name="style">{{#getStyle this.score}}{{/getStyle}}</xsl:attribute>
                                {{this.score}}
                            </div>
                            <div class="btmEsg">
                                {{this.count}}
                            </div>
                        </div> 
                    {{/each}}
                {{/if}}
            </div>
        </script>
        <script id="capability-template" type="text/x-handlebars-template">
            <div class="l0-cap"><xsl:attribute name="id">{{id}}</xsl:attribute> 
                <span class="cap-label">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
                <span class="supplier-circle" data-toggle="tooltip">
                    <xsl:attribute name="supplierId">{{id}}</xsl:attribute>
                    {{#getSupplierInfo this}}{{/getSupplierInfo}} 
                </span>   
                <br/>
                {{#each this.subCaps}}     
                    <div class="l1-cap bg-darkblue-40 buscap"><xsl:attribute name="eascapid">{{id}}</xsl:attribute><xsl:attribute name="id">{{id}}</xsl:attribute>
                    <div class="sub-cap-label">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div>
                     
                    <span class="supplier-circle" data-toggle="tooltip">
                        <xsl:attribute name="supplierId">{{id}}</xsl:attribute>
                    </span>  
                    <span class="esg-rating" data-toggle="tooltip">
                        <xsl:attribute name="esgId">{{id}}</xsl:attribute>
                    </span>   
                        </div>	
                    {{/each}}        
            </div>
        </script>
    
	</xsl:template>

	<xsl:template match="node()" mode="getMarkers">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisgeoLocation" select="$geoLocation[name = $this/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisgeoCode" select="$geoCode[name = $thisgeoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
		<xsl:variable name="lat" select="$thisgeoCode/own_slot_value[slot_reference = 'geocode_latitude']/value"/>
		<xsl:variable name="long" select="$thisgeoCode/own_slot_value[slot_reference = 'geocode_longitude']/value"/>
		<xsl:if test="$lat"> {latLng: [<xsl:value-of select="$lat"/>,<xsl:value-of select="$long"/>], name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisgeoLocation"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>', style: {fill: '#faa053'}, id:'<xsl:value-of select="$thisgeoLocation/own_slot_value[slot_reference = 'gl_identifier']/value"/>'},</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="busCaps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="subCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","subCaps":[ <xsl:apply-templates select="$subCaps" mode="subCaps"/>]}, </xsl:template>
	<xsl:template match="node()" mode="subCaps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="relatedCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","relatedCaps":[ <xsl:apply-templates select="$relatedCaps" mode="relatedCaps"/>] }, </xsl:template>
	<xsl:template match="node()" mode="relatedCaps">
		<xsl:param name="num" select="1"/>
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="relatedCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","num":<xsl:value-of select="$num"/>}, <xsl:if test="$num &lt; 10"><xsl:apply-templates select="$relatedCaps" mode="relatedCaps"><xsl:with-param name="num" select="$num + 1"/></xsl:apply-templates></xsl:if>
	</xsl:template>

    
    <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/>
        <xsl:param name="viewerAPIPathSupp"/>
        <xsl:param name="viewerAPIPathSuppKpi"/>
        <xsl:param name="viewerAPIPathCaps"/>
        <xsl:param name="viewerAPIPathTechProds"/>
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
        var viewAPIDataSupp = '<xsl:value-of select="$viewerAPIPathSupp"/>';
        var viewAPIDataSuppKPI = '<xsl:value-of select="$viewerAPIPathSuppKpi"/>';
        var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>';
        var viewAPIDataTechProd = '<xsl:value-of select="$viewerAPIPathTechProds"/>';

        var capabilityInfoArray; 
        var supplierJSON;
        var esgOn=false;
		var plansJSON;
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
                //console.log(apiDataSetURL);    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
            //console.log(this.responseText);  
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
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
        <xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
        var style, supplierPms, sqvs;
        $(document).ready(function() {
            $('#supplierPanel').hide();

            Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			}); 

            Handlebars.registerHelper('getSupplierInfo', function(instance) {
                
            })
            Handlebars.registerHelper('getStyle', function(instance) {
                
                 if(instance){}else{
                    instance=0
                }
                    let thisStyle= style?.sqvs?.find((s)=>{
                        return s.score==instance;
                    }) 
                    if(thisStyle){
                        return 'background-color:'+ thisStyle.elementBackgroundColour +';color:'+thisStyle.elementColour;
                    }
                    else{
                        return 'background-color:#ffffff;color:#000';
                    }
                
            })

           
        Promise.all([ 
				promise_loadViewerAPIData(viewAPIData), 
                promise_loadViewerAPIData(viewAPIDataSupp), 
                promise_loadViewerAPIData(viewAPIDataSuppKPI), 
                promise_loadViewerAPIData(viewAPIDataCaps), 
                promise_loadViewerAPIData(viewAPIDataTechProd)
                ]).then(function(response) {		
                let data = response[0];
			  
				$('#ess-data-gen-alert').hide();
                var focusSupplier=[];
        let apptech=response[4].application_technology;


        supplierJSON=data.suppliers.sort((a, b) => {
            if (a.name &lt; b.name) return -1;
            if (a.name > b.name) return 1;
            return 0;
        });;

      // Create a map for quick lookup of suppliers by technology ID
        const supplierMap = new Map();
        supplierJSON.forEach(s => {
            s.technologies.forEach(t => {
                supplierMap.set(t.id, { id: s.id, name: s.name });
            });
        });

        // Optimized mapping
        const appToTechnology = apptech.map(item => {
            // Directly constructing the products array with supplier info
            const products = item.environments.flatMap(env =>
                env.products.map(prod => {
                    const supplier = supplierMap.get(prod.prod) || {};
                    return {
                        ...prod,
                        supplierId: supplier.id,
                        supplierName: supplier.name
                    };
                })
            );

            return { id: item.id, name: item.name, products };
        });

 

        const suppliersGrouped = [];

        appToTechnology.forEach(app => {
            app.products.forEach(product => {
                if (product.supplierId) {
                    // Find or create the supplier entry
                    let supplierEntry = suppliersGrouped.find(s => s.id === product.supplierId);
                    if (!supplierEntry) {
                        supplierEntry = {
                            id: product.supplierId,
                            name: product.supplierName,
                            apps: [],
                            products: []
                        };
                        suppliersGrouped.push(supplierEntry);
                    }

                    // Add the app to the supplier, if not already included
                    if (!supplierEntry.apps.some(a => a.id === app.id)) {
                        supplierEntry.apps.push({ id: app.id, name: app.name });
                    }

                    // Add the product to the supplier, if not already included
                    if (!supplierEntry.products.some(p => p.id === product.id)) {
                        supplierEntry.products.push({ id: product.id, name: product.name });
                    }
                }
            });
        });

        supplierJSON.forEach((e)=>{
            $('#pickSuppliers').append('&lt;option value="'+e.id+'">'+e.name+'&lt;/option>');    
        })
        capabilityJSON=data.capabilities;
        plansJSON=data.plans;      
        esgStyle=response[2].serviceQualities 
        supplierPms=response[2];
        let name = "ESG Rating"; // Ensure this is set correctly
        if(esgStyle[0]){
          style = esgStyle.find(s => s.name === name);
          sqvs = esgStyle[0].sqvs;
          esgOn=true;
        }else{
            style ={};
            sqvs=[];
        }
        if(sqvs){ 
            sqvs = sqvs.sort((a, b) => parseInt(a.score) - parseInt(b.score));
         $('#sqvKey').html(keyTemplate(sqvs))
        }
      capabilityJSON.forEach(function(d){
        d['boxHeight']=((Math.floor(d.subCaps.length / 7)+1) * 55)+20;
      })

      //find apps for suppliers

      function addBusinessCapabilityIdsToSuppliers(supplierApps, supplierProcesses, businessCapabilities, technologyMap) {
         
        // Iterate through each supplier
        supplierApps.forEach(supplier => {
            // Initialize an array to store matched business capability IDs
            supplier.matchedBusinessCapabilities = [];
    
            // Check each app of the supplier
            supplier.apps.forEach(supplierApp => {
                // Compare with each business capability
                businessCapabilities.forEach(businessCapability => {
                    // Check if the business capability contains the app ID
                    const hasApp = businessCapability.apps.some(businessAppId => businessAppId === supplierApp.id);
    
                    // If the app is found, add the business capability ID to the supplier
                    if (hasApp) {
                        supplier.matchedBusinessCapabilities.push(businessCapability.id);
                    }
                });
            });
        });

        technologyMap.forEach(supplier => {
            // Initialize an array to store matched business capability IDs
            supplier.matchedBusinesstechCapabilities = [];
    
            // Check each app of the supplier
            supplier.apps.forEach(supplierApp => {
                // Compare with each business capability
                businessCapabilities.forEach(businessCapability => {
                    // Check if the business capability contains the app ID
                    const hasApp = businessCapability.apps.some(businessAppId => businessAppId === supplierApp.id);
    
                    // If the app is found, add the business capability ID to the supplier
                    if (hasApp) {
                        supplier.matchedBusinesstechCapabilities.push(businessCapability.id);
                    }
                });
            });
       
        })

        

        supplierProcesses.forEach(supplier => {
            // Initialize an array to store matched business capability IDs
            supplier.matchedBusinessCapabilitiesProcess = [];

            // Check each app of the supplier
            supplier.processes?.forEach(supplierProcess => {

                // Compare with each business capability
                businessCapabilities.forEach(businessCapability => { 
                    // Check if the business capability contains the app ID
                    const hasProcess = businessCapability.allProcesses
                    .some((businessProcessId) => {

                    if( businessProcessId.id === supplierProcess.busProc.id){
                        supplier.matchedBusinessCapabilitiesProcess.push(businessCapability.id);
                    }
                        return businessProcessId.id === supplierProcess.busProc.id});
                    
                    // If the app is found, add the business capability ID to the supplier
                    if (hasProcess) {
                
                        supplier.matchedBusinessCapabilitiesProcess.push(businessCapability.id);
                    }
                });
            });

            ;
        });
    
     }

    // ADD TECHNOLOGY
    addBusinessCapabilityIdsToSuppliers(response[1].suppliersApps, response[1].suppliersProcess, response[3].busCaptoAppDetails, suppliersGrouped);
    
    // TO DO group apps for caps and children caps


    supplierJSON.forEach(supplier => {

        // Find apps for the current supplier by ID
        let apps = response[1].suppliersApps.filter(app => app.id.replace(/\./g, "_") === supplier.id.replace(/\./g, "_"));
        if(apps){apps=apps[0]}
        // Find processes for the current supplier by ID
        let processes = response[1].suppliersProcess.filter((process) => {

            let sa=process.supplierActor.replace(/\./g, "_")
           return sa === supplier.id})
        

        if(processes){processes=processes}
        let tech = suppliersGrouped.filter(tech => tech.id.replace(/\./g, "_") === supplier.id.replace(/\./g, "_"));
        let tech0
        if(tech){
            tech0=tech[0]
            let techApps = tech0?.apps.map(item => {
                    return { ...item, className: "Composite_Application_Provider" };
                    });
            supplier['appsImpacted']=techApps;
            
        }

        // Add apps and processes to the supplier

        let mergedArray = [
        ...(apps?.matchedBusinessCapabilities || []),
        ...(processes?.matchedBusinessCapabilitiesProcess || []),
        ...(tech0?.matchedBusinesstechCapabilities || [])
    
        ];

        supplier.appInfo = apps;
        supplier.processInfo = processes;
        supplier.techInfo = tech;
        supplier['allCaps']=mergedArray;
    });
   
    // Now response[0].suppliers contains the merged data
 
    function getMostRecentESGRatings(suppliers) {
        return suppliers.map(supplier => {

            supplier.perfMeasures.forEach(measure => {
                if (!measure.categoryid &amp;&amp; measure.serviceQuals.length > 0) {
                    measure.categoryid = measure.serviceQuals[0].categoryId[0] || '';
                }
            });
            // Filter performance measures to include only those with 'ESG Ratings'
 
            let esgMeasures = supplier.perfMeasures
            .filter(measure => 
                measure.serviceQuals.some(qual => 
                    Array.isArray(qual.categoryName) ?
                        qual.categoryName.includes('ESG Ratings') || qual.categoryName.includes('App Fit') :
                        qual.categoryName === 'ESG Ratings' || qual.categoryName === 'App Fit'
                )
            );
        
    
            // Check if esgMeasures is empty
            if (esgMeasures.length === 0) {
                // If empty, you can choose to skip this supplier or return a default value
                return null; // or provide a default object structure
            }
    
            // Find the most recent measure
            let mostRecentMeasure = esgMeasures.reduce((latest, current) => 
                new Date(latest.date) > new Date(current.date) ? latest : current);
    
            // Extract the relevant data from the most recent measure
            let mostRecentQual = mostRecentMeasure.serviceQuals
            .find(qual => 
                Array.isArray(qual.categoryName) ?
                    qual.categoryName.includes('ESG Ratings') :
                    qual.categoryName === 'ESG Ratings'
            );
        
    
            return {
                supplierId: supplier.id,
                score: mostRecentQual ? mostRecentQual.score : 'No score',
                value: mostRecentQual ? mostRecentQual.value : 'No value',
                esgid:mostRecentQual ? mostRecentQual.id : 'none',
            };
        }).filter(result => result !== null); // Filter out null values if you chose to return null for empty esgMeasures
    }

    function updateSuppliersWithESGRatings(supplierJSON, result) {
        result.forEach(res => {
            let matchingSupplier = supplierJSON.find(supplier => supplier.id === res.supplierId);
            if (matchingSupplier) {
                // Assuming you want to add score and value at the supplier level
                matchingSupplier.esgScore = res.score;
                matchingSupplier.esgValue = res.value;
            }
        });
        return supplierJSON;
    }
    
    
    let result = getMostRecentESGRatings(response[2].suppliers);

    let updatedSuppliers = updateSuppliersWithESGRatings(supplierJSON, result);
  //  console.log('updatedSuppliers',updatedSuppliers)
    let capabilitySuppliers = {};
    supplierJSON.forEach(supplier => {
    
        supplier.allCaps.forEach(capId => {
            if (!capabilitySuppliers[capId]) {
                capabilitySuppliers[capId] = new Set();
            }
            // Convert esgScore to a number, default to 0 if NaN
            const esgScore = Number(supplier.esgScore);
            capabilitySuppliers[capId].add({
                "id": supplier.id,
                "name": supplier.name,
                "className": "Supplier",
                "esgScore": isNaN(esgScore) ? 0 : esgScore
            });
           
        });
    });
    

    capabilityInfoArray = Object.keys(capabilitySuppliers).map(key => {
        const suppliers = Array.from(capabilitySuppliers[key]);
   
        let result = setSuppliers(suppliers)
    
        return {
            capId: key,
            count: result.filteredSuppliers.length,
            supplierNames: result.filteredSuppliers,
            esgScoreCounts:result.esgScoreCounts // New format for ESG score counts
        };
    });
 
      capabilityJSON.forEach(function(d){
        $("#capabilitiesDivHeader").append(capHeader(d))
        $("#capabilitiesDiv").append(capTemplate(d));
      })

      $('.scrollDiv').on('click', function(event) {
                let ele=$(this).attr('easHtmId')
          
                event.preventDefault(); // Prevent the default anchor behavior
                const targetDiv = document.getElementById(ele);
                if (targetDiv) { 
                    window.scrollTo(0, targetDiv.offsetTop  ); // Scrolls to 40px above the div
                }  
            });

        essInitViewScoping(redrawView,['SYS_CONTENT_APPROVAL_STATUS'],"", true);
            
        });

		
         })
         
         var supplierInfo = {
            "className": "supplier",
            "label": 'Supplier',
            "icon": 'fa-truck'
        }
 
         var redrawView=function(){
            essResetRMChanges(); 
    
           let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
         
           let scopedSuppliers= essScopeResources(supplierJSON, [visibilityDef], supplierInfo);
      
        
            let workingCapInfoArray=[];
            capabilityInfoArray.forEach((c)=>{
                let filteredSup = c.supplierNames.filter(supp1 => 
                scopedSuppliers.resourceIds.some(supp2 => supp2 === supp1.id));
 
                let res=setSuppliers(filteredSup)
        
                workingCapInfoArray.push({
                    "capId":c.capId,
                    "count":res.filteredSuppliers.length,
                    "esgScoreCounts": res.esgScoreCounts,
                    "supplierNames":res.filteredSuppliers,
                    })
                     
            });

            workingCapInfoArray.forEach((c)=>{ 
                $('[supplierId='+ c.capId +']').text(c.count);
                if(esgOn==true){
                $('[esgId='+ c.capId +']').html(esgScoreTemplate(c))
                }
            })
            
            $('.supplier-circle').on('click',function(){
                let capId = $(this).attr('supplierId'); // Assuming jQuery is used
                let selected = workingCapInfoArray.find(c => c.capId === capId);
                 
                if (selected) {
                    let suppliers = selected.supplierNames.map(s => {
                        return scopedSuppliers.resources.find(sd => s.id === sd.id) || {}; // Fallback to an empty object if not found
                    }).filter(supplierDetails => Object.keys(supplierDetails).length > 0); // Filter out any empty objects                
                    if(esgOn==true){
                        suppliers['esgOn']=true;
                       }

                    $('#supplierList').html(supplierListTemplate(suppliers))
                    openNav(); 

                    $('.showSupplier').on('click',function(){
                        let selectedSupplier=$(this).attr('easid');

                        let match=supplierPms.suppliers.find((e)=>{
                            return e.id == selectedSupplier;
                        })
                         
                        const pmGroups = match.perfMeasures.reduce((groups, measure) => {
						const category = supplierPms.perfCategory.find((c) => c.id === measure.categoryid);
						const groupName = category ? category.name : 'Unknown';
						const group = groups.find((g) => g.key === measure.categoryid);
						
						if (group) {
						  group.values.push(measure);
						} else {
						  groups.push({ key: measure.categoryid, name: groupName, values: [measure] });
						}
						
						return groups;
					  }, []);
					  
					   
					  let pmAv=[];
					  pmGroups.forEach((p)=>{
					  let averages = p.values.map(value => {
						// Get the sum of the scores for each date.
						let sum = value.serviceQuals.reduce((total, qual) => {
							return total + Number(qual.score);
						}, 0);
					
						// Calculate the average by dividing the sum by the number of scores.
						let average = sum / value.serviceQuals.length;
					
						// Return the date and the average score for that date.
						return {
							date: value.date,
							averageScore: average
						};
					});
					pmAv.push({"id":p.key,"name":p.name,"av":averages, "svs":p.values})
						  
				})
	
				 
                let supplierToShow={"id":match.id,"name":match.instance, "pms":pmAv}
                let chartColours =["#003f5c", "#58508d", "#bc5090","#ff6361","#ffa600", "#00876c", "#46966f", "#6ca675", "#8fb47d", "#afc389", "#cfd198", "#eee0ab", "#eac98e", "#e7b175", "#e49762", "#e17c56", "#dc5f50","#d43d51"]
								 
                let chartLabels=[];
                let maxValforScale=3;
                let labels =[]
                let chartData=[];

                    supplierToShow.pms.forEach((p)=>{
                    
                        if(p.av){
                            p.av.forEach((sv)=>{
                                labels.push(sv.date)
                                chartData.push(sv.averageScore)
                            })
                        }
                    })
             
                    let chosenSupplier=suppliers.find((s)=>{
                        return s.id == selectedSupplier
                    })
                
                        $('#summaryDetails').html(summaryTemplate(chosenSupplier))
                        $('.supplierPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
 
                        $('.closePanelButton').on('click',function(){ 
                            $('.supplierPanel').hide();
                        });
 
                         
                    if (esgOn == true) { 

                        function initializeChart() {
                           
                            var canvas = document.getElementById('suppcanvas');
                            if (canvas &amp;&amp; canvas.getContext) {
                                var ctx = canvas.getContext('2d');
                                var chartId = new Chart(ctx, {
                                    type: 'line',
                                    data: {
                                        labels: labels,
                                        datasets: [{
                                            label: "ESG Score By Date",
                                            data: chartData,
                                            backgroundColor: "#ffffff",
                                            borderColor: 'black',
                                            borderWidth: 2,
                                            pointRadius: 5,
                                            fill: false,
                                        }],
                                    },
                                    options: {
                                        responsive: false, // Set true if you want the chart to be responsive
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero: true,
                                                    min: 0,
                                                    font: {
                                                        size: 8
                                                    },
                                                    callback: function (value) {
                                                        if (Number.isInteger(value)) {
                                                            return value;
                                                        }
                                                    },
                                                }
                                            }],
                                            xAxes: [{
                                                ticks: {
                                                    font: {
                                                        size: 8
                                                    },
                                                },
                                            }],
                                        },
                                        legend: {
                                            labels: {
                                                font: {
                                                    size: 10
                                                }
                                            }
                                        }
                                    },
                                });
                            }
                        } 

                        function waitForCanvas() {
                            var canvas = document.getElementById('suppcanvas');
                    
                            if (!canvas) {
                                // Canvas not available yet, wait for a bit and then try again
                          
                                setTimeout(waitForCanvas, 500); // Adjust the timeout as needed
                            } else {
                                initializeChart();
                            }
                        }
               
                        waitForCanvas();
                    }



                    })
                } 
            })


            $('#pickSuppliers').on('change', function(){
                let selected = $(this).val();

                let supp=supplierJSON.find((c)=>{
                    return c.id==selected
                })
 
               
                $('.l1-cap').removeClass('highlightClass')
                $('.capLabels').removeClass('label-primary').addClass('label-default')
                supp.allCaps.forEach((e)=>{
                   
                    $('.l1-cap[eascapid="'+e+'"]').addClass('highlightClass')
                
                    let parent=$('#'+e +' .l1-cap').parent('div').attr('id');
                    if(parent){
                        //easHeadId
                        $('.capLabels[easHeadId="'+parent+'"]').addClass('label-primary')
                    }

                })
			
			let plans=[];	

			supp.apps.forEach(function(d){
				plansJSON.forEach(function(e){
					e.impacts.forEach(function(ef){
		  
					if(ef.impacted_element===d.id){e['impactName']=d.name;e['impactId']=d.id;e['impactType']='';e['impactAction']=ef.planned_action;plans.push(e)}
	
				d.capabilitiesImpacted.forEach(function(c){
					if(c.id===ef.impacted_element){e['impactName']=c.name;e['impactId']=c.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The capability'; plans.push(e)}
				
				c.processes.forEach(function(p){
					if(p.id===ef.impacted_element){e['impactName']=p.name;e['impactId']=p.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The process';plans.push(e)}
							});
						});
					});
			   });  

               
			});
			supp.technologies.forEach(function(d){
				plansJSON.forEach(function(e){
					e.impacts.forEach(function(ef){
		  
					if(ef.impacted_element===d.id){e['impactName']='The organisation ';e['app']=d.name;e['impactId']=d.id;e['impactType']='';e['impactAction']=ef.planned_action;plans.push(e)}
					d.impacted.forEach(function(i){
						if(i.apps){
							  i.apps.forEach(function(a1){
							  if(a1.id===ef.impacted_element){e['impactName']=a1.name;e['impactId']=a1.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The application';plans.push(e)}  
							  })  
							}
						if(i.processes){
							  i.processes.forEach(function(a1){
							  if(a1.id===ef.impacted_element){e['impactName']=a1.name;e['impactId']=a1.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The process';plans.push(e)}  
							  })  
							}
						if(i.caps){
							  i.caps.forEach(function(a1){
							  if(a1.id===ef.impacted_element){e['impactName']=a1.name;e['impactId']=a1.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The capability';plans.push(e)}  
							  })  
							} 
		  
						  })
					
				});
			   });
	
			});

			let plans_array_tech = plans.filter(function(elem, index, self) {
                return index == self.indexOf(elem);
            });
			plans_array_tech.sort(SortByDate);
	 
            console.log('plans_array_tech',plans_array_tech)
			$("#supplierTime").empty();
			$("#supplierTime").append(timeTemplate(plans_array_tech))



            })
         }

    
       function SortByDate(x,y) {
          return ((x.endDate == y.endDate) ? 0 : ((x.endDate > y.endDate) ? 1 : -1 ));
        }

        function openNav()
		{	
             
			document.getElementById("appSidenav").style.marginRight = "0px";
		}
		
		function closeNav()
		{
			workingCapId=0;
			document.getElementById("appSidenav").style.marginRight = "-752px";
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
				$('#appSidenav').css('top','78px');
			}
		});

        function toggleMiniPanel(element){
			$(element).parent().parent().nextAll('.mini-details').slideToggle();
			$(element).toggleClass('fa-caret-right');
			$(element).toggleClass('fa-caret-down');
		};

        function setSuppliers(sup){
            let filteredSuppliers=sup.filter((obj, index, self) => {
                return self.findIndex(t => t.id === obj.id) === index;
                });


            const esgScoreCountsTemp = filteredSuppliers.reduce((acc, supplier) => {
                const score = supplier.esgScore;
                acc[score] = (acc[score] || 0) + 1;
                return acc;
            }, {});
        
            // Convert to the desired format
            const esgScoreCounts = Object.keys(esgScoreCountsTemp).map(score => ({
                score: parseInt(score),
                count: esgScoreCountsTemp[score]
            }));

            return {
                    filteredSuppliers:filteredSuppliers, 
                    esgScoreCounts: esgScoreCounts
                }
        }
       
    </xsl:template>
    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
        	<xsl:call-template name="RenderAPILinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>

        
    </xsl:template>
</xsl:stylesheet>
