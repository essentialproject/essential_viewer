<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/> 
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
    <xsl:key name="tech" match="/node()/simple_instance[type='Technology_Product']" use="own_slot_value[slot_reference='vendor_product_lifecycle_status']/value"/>
    <xsl:key name="techtpr" match="/node()/simple_instance[type='Technology_Product_Role']" use="own_slot_value[slot_reference='role_for_technology_provider']/value"/>
    <xsl:key name="techcomp" match="/node()/simple_instance[type='Technology_Component']" use="own_slot_value[slot_reference='realised_by_technology_products']/value"/>
  	<xsl:variable name="region" select="/node()/simple_instance[type='Geographic_Region']"/>
    <xsl:variable name="life" select="/node()/simple_instance[type='Vendor_Lifecycle_Status']"/>
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	 <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes to App Services']"/>
    <xsl:variable name="anAPIReportARM" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Capability Model']"/>
    <xsl:variable name="anAPIReportTRM" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Capability Model']"/>
    <xsl:variable name="anAPIReportAppStakeholders" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Stakeholders IDs']"/>
    <xsl:variable name="anAPIReportTechStakeholders" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Stakeholder IDs']"/> 
	<xsl:variable name="anAPIReportAppMart" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"/>
	<xsl:variable name="anAPIReportAC2Serv" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities 2 Services']"/>
    <xsl:variable name="anAPIReportAllBusCapsviaApp" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get All Business Capabilities']"/>
    <xsl:variable name="anAPIReportAllTechProducts" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Product List']"/>
    <xsl:variable name="anAPIReportAllTechPie" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get Tech Pie Data']"/>
    <xsl:variable name="anAPIReportAllTechCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get All Tech Capability Info']"/>
     <xsl:variable name="anAPIReportAllBusinessUnits" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get Business Units']"/>
     <xsl:variable name="anAPIReportAllTPRs" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get All Tech Product Roles']"/>
	 <xsl:variable name="anAPIReportAllBusCapDetails" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"/>
	 <xsl:variable name="anAPIReportAllApp2Servs" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"/>
	 <xsl:variable name="anAPIReportAllAppMart" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"/>
	 <xsl:variable name="anAPIReportPhysProcstoApps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
	 <xsl:variable name="anAPIReportInstance" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"/>

	<!-- END GENERIC LINK VARIABLES -->
   

	<!--<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')][0]"/>-->
	<xsl:variable name="allAppCodebases" select="/node()/simple_instance[type = 'Codebase_Status']"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>

	<!--<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product'][0]"/>-->

	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	
 	<xsl:variable name="techProdDeliveryTaxonomy" select="/node()/simple_instance[(type='Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Technology Product Delivery Types')]"/>
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/>
	
	<!-- Get default geographic map -->
	<xsl:variable name="geoMapReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Geographic Map')]"/>
	<xsl:variable name="geoMapInstance" select="/node()/simple_instance[name = $geoMapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="geoMapId">
		<xsl:choose>
			<xsl:when test="count($geoMapInstance) > 0"><xsl:value-of select="$geoMapInstance[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:when>
			<xsl:otherwise>world_mill</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="geoMapPath">
		<xsl:choose>
			<xsl:when test="count($geoMapInstance) > 0"><xsl:value-of select="$geoMapInstance[1]/own_slot_value[slot_reference = 'description']/value"/></xsl:when>
			<xsl:otherwise>js/jvectormap/jquery-jvectormap-world-mill.js</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Service', 'Technology_Capability', 'Technology_Component')"/>
    
    
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
		<xsl:call-template name="docType"/>
		<xsl:variable name="apiPathInstance">
            <xsl:call-template name="GetViewerDynamicAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportInstance"/>
            </xsl:call-template>
        </xsl:variable>
         <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAPM">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportARM"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathTRM">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportTRM"/>
            </xsl:call-template>
        </xsl:variable>
         <xsl:variable name="apiPathAppStakeholders">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAppStakeholders"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathTechStakeholders">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportTechStakeholders"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAllBusCapViaAppCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllBusCapsviaApp"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAllTechProds">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllTechProducts"/>
            </xsl:call-template>
        </xsl:variable>        
         <xsl:variable name="apiPathAllTechPie">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllTechPie"/>
            </xsl:call-template>
        </xsl:variable>
              <xsl:variable name="apiPathAllTechCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllTechCaps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAllBusUnits">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllBusinessUnits"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAllTPRs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllTPRs"/>
            </xsl:call-template>
        </xsl:variable>
		
		<xsl:variable name="apiPathAllBusCapDetails">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllBusCapDetails"/>
            </xsl:call-template>
        </xsl:variable>
		
		<xsl:variable name="apiPathAllApp2Servs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllApp2Servs"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAllAppMart">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllAppMart"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAllPhysProcstoApp">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportPhysProcstoApps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAppMart">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAppMart"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAllAC2Serv">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAC2Serv"/>
            </xsl:call-template>
        </xsl:variable>
        

		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
               
                <xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>IT Asset Dashboard</title>
				<script async="true" src="js/es6-shim/0.9.2/es6-shim.js?release=6.19" type="text/javascript"/>
				<link href="js/select2/css/select2.min.css?release=6.19" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js?release=6.19"/>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css?release=6.19" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js?release=6.19" type="text/javascript"/>
				<script src="{$geoMapPath}" type="text/javascript"/>
				<script language="javascript" type="text/javascript" src="js/jqplot/jquery.jqplot.min.js?release=6.19"/>
				<script src="js/chartjs/Chart.min.js?release=6.19"/>
				<script src="js/chartjs/chartjs-plugin-labels.min.js?release=6.19"/> 
				<xsl:call-template name="dataTablesLibrary"/>
				<script src="js/d3/d3.v5.9.7.min.js?release=6.19"/>
				
				<xsl:call-template name="RenderInitDataScopeMap">
					<xsl:with-param name="geoMap" select="$geoMapId"/>
				</xsl:call-template>
				<xsl:call-template name="refModelLegendInclude"/>
				
				
				<style>
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}
					
					h2:hover{
						 
					}
					
					.map{
						width: 100%;
						height: 250px;
					}
					
					.popover{
						max-width: 800px;
					}

					.sidenav{
						height: calc(100vh - 41px);
						width: 550px;
						position: fixed;
						z-index: 1;
						top: 41px;
						right: 0;
						background-color: #f6f6f6;
						overflow-x: hidden;
						transition: margin-right 0.5s;
						padding: 10px 10px 10px 10px;
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
						margin-right: -552px;
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
							padding-top: 45px;
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
					.smallTableFont{
						font-size:0.9em;
							}

					#itaPanel {
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
					.appsCircle, .appsCapCircle{
						font-size:1.1em;
						font-weight:bold;
					}

				</style>
				
				<xsl:call-template name="refModelStyles"/>
				
				<!--Pie Chart Styles-->
				<style>
					.fa-info-circle {
						cursor: pointer;
					}

					.fa-info-circle-colour {
						color:#d3d3d3;
					}
					
					.pieChartContainer{
						width: 100%;
						height: 300px;
						float: left;
						box-sizing: border-box;
					}
					
					.pieChart{
						width: 100%;
						height: 100%;
					}<!--
					.pieChart > table{
						width: 40%;
					}-->
					.jqplot-table-legend{
						width: 200px;
						max-width: 300px;
						padding: 10px !important;
					}
					
					table.jqplot-table-legend{
						border: 1px solid #aaa !important;
					}
					
					table.jqplot-table-legend,
					table.jqplot-cursor-legend{
						border: none;
					}
					
					.jqplot-table-legend-swatch{
						width: 16px;
					}
					
					.jqplot-table-legend-label{
						width: auto;
						padding: 10px;
						margin-top: 10px;
					}
					
					.jqplot-data-label{
						font-size: 16px;
					}
					
					.jqplot-table-legend-label{
						font-size: 12px;
					}
					.servicesUsedCircle, .componentsUsedCircle {
						width:15px;
						height:15px;
						border-radius:15px;
						position:absolute;
						left:2px;
						top:2px;
						background-color:white;
						color:black;
						border: 2px solid green;
						font-size:0.7em;
						font-weight:bold;
					}
					.appsUsedCircle, .techUsedCircle{
						width:15px;
						height:15px;
						border-radius:15px;
						position:absolute;
						left:2px;
						bottom:2px;
						background-color:white;
						color:black;
						border: 2px solid red;
						font-size:0.7em;
						font-weight:bold;
					}

					.card {background-color: #d9d7d7a6;
						border: 1px solid #000000;
						border-radius: 10px;
						box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
						display: inline-block;
						font-family: Arial, sans-serif;
						font-size: 0.7em;
						height: 140px;
						margin: 1px;
						padding: 1px;
						width: 88px;
						vertical-align:top;
					}
					.card-sm{
						height:78px;
					}
					.closeBus, .closeApp, .closeTech{
						    position: absolute;
							top: 10px;
							right: 25px;
					}

.card-header {
  background-color: #008dff;
  border-radius: 10px 10px 0 0;
  color: #ffffff;
  font-weight: bold;
  padding: 3px;
  text-align: center;
  min-height:35px;
}

.card-body {
  padding: 10px;
}

.card-title {
  font-size: 0.9em;
  font-weight: bold;
  margin-bottom: 10px;
  text-align: center;
  
}

.card-text {
  line-height: 1.5;
  text-align: justify;
}
.lifecycleCircle{
	width:12px;
	height:8px;
	border-radius:15px;
	position:absolute;
	right:2px;
	top:2px;
	background-color:white; 
	border: 1px solid #fff;
	font-size:0.7em;
	font-weight:bold;
	background-color: green;
}
.extendedSupport{
	background-color: #fc9003;
}
.eol{
	background-color: #fc036f;
}
.extendedSupporti{
	color: #fc9003;
}
.eoli{
	color: #fc036f;
}
.lifeBox{
	text-align:center;
	border-radius:4px;
	background-color:white;
	height:30px;
	color:#000;
}
					</style>
				<!--Ends-->
                
                
				
			</head>
			<body>
				
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
			 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">IT Asset Dashboard</span>
								</h1>
							</div>
						</div>
						<div id="appSidenav" class="sidenav">
							<a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()">
								<i class="fa fa-times"></i>
							</a>
							<div class="clearfix"/>
							<!--<div class="iconCubeHeader"><i class="fa fa-th-large right-5"></i>Capabilities</div>
							<div class="iconCubeHeader"><i class="fa fa-users right-5"></i>Users</div>
							<div class="iconCubeHeader"><i class="fa essicon-boxesdiagonal right-5"></i>Processes</div>
							<div class="iconCubeHeader"><i class="fa essicon-radialdots right-5"></i>Services</div>-->
							<div class="app-list-scroller top-5">

								<div id="listBox"></div>
							</div>
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						
						<div class="col-xs-6">
							<div class="dashboardPanel bg-offwhite match1">
								<h2 class="text-secondary">Scope</h2>
								<div class="row">
									<div class="col-xs-12">
									<!--
										<label>
											<span>Business Unit Selection</span>
										</label>
										<select id="busUnitList" class="form-control" multiple="multiple" style="width:100%"/>		
									-->
										<label>
											<span>Focus Capability Selection</span>
										</label>
										<select id="busCapList" class="form-control" style="width:100%"/>							
									</div>
								</div>
							</div>
						</div>
						<xsl:call-template name="scopeMap"/>
						<!--<xsl:call-template name="investmentProfilePie"/>-->
						<xsl:call-template name="busSection"/>
						<xsl:call-template name="appSection"/>
						<xsl:call-template name="techSection"/>	
						<script type="text/javascript">
					
				        <xsl:call-template name="RenderViewerAPIJSFunction">
						    <xsl:with-param name="viewerAPIPathSimple" select="$apiPathInstance"/>
                            <xsl:with-param name="viewerAPIPath" select="$apiPath"/>
                            <xsl:with-param name="viewerAPIPathAPM" select="$apiPathAPM"/>
                            <xsl:with-param name="viewerAPIPathTRM" select="$apiPathTRM"/>
                            <xsl:with-param name="viewerAPIPathAppStakeholders" select="$apiPathAppStakeholders"/>
                            <xsl:with-param name="viewerAPIPathTechStakeholders" select="$apiPathTechStakeholders"/>
                            <xsl:with-param name="viewerapiPathAllBusCapViaAppCaps" select="$apiPathAllBusCapViaAppCaps"/>
                            <xsl:with-param name="viewerAPIPathAllTechProds" select="$apiPathAllTechProds"/>
                            <xsl:with-param name="viewerAPIPathAllTechPie" select="$apiPathAllTechPie"/>
                            <xsl:with-param name="viewerAPIPathAllTechCaps" select="$apiPathAllTechCaps"/>
							<xsl:with-param name="viewerAPIPathAllBusUnits" select="$apiPathAllBusUnits"/>
							<xsl:with-param name="viewerAPIPathAllTPRs" select="$apiPathAllTPRs"/>
							<xsl:with-param name="viewerAPIPathAllBusCapDetails" select="$apiPathAllBusCapDetails"/>
							<xsl:with-param name="viewerAPIPathAppMart" select="$apiPathAppMart"/>
							<xsl:with-param name="viewerAPIPathAllAppMart" select="$apiPathAllAppMart"/>
							<xsl:with-param name="viewerAPIPathAllApp2Servs" select="$apiPathAllApp2Servs"/>
							<xsl:with-param name="viewerAPIPathAllAC2Serv" select="$apiPathAllAC2Serv"/>
							<xsl:with-param name="viewerAllPhysProcstoApp" select="$apiPathAllPhysProcstoApp"/>
							
							
                        </xsl:call-template>
                      
							var appCodebasePie, appDeliveryModelPie, techProdStatusPie, techProdDeliveryPie, bcmDetailTemplate, appDetailTemplate, techDetailLocalTemplate, ragOverlayLegend, noOverlayBCMLegend, noOverlayARMLegend, noOverlayTRMLegend, stakeH, stakeHT,appCapDetails,tprs,techCapDetails, selectedBusUnits, appStakeholders,appPieData;
							var defaultPieColour = 'white';
                            
                        <!--
                            var appStakeholders =[<xsl:apply-templates select="$allApps" mode="RenderAppStakeholderJSONList"/>];
                        
							var techStakeholders =[<xsl:apply-templates select="$allTechProds" mode="RenderAppStakeholderJSONList"/>];
                            -->
							
							// the list of JSON objects representing the delivery models for technology products
						  	var techDeliveryModels = [<xsl:apply-templates select="$allTechProdDeliveryTypes" mode="RenderEnumerationJSONList"/>];
							
							// the list of JSON objects representing the environments
						  	var lifecycleStatii = [
								<xsl:apply-templates select="$allLifecycleStatii" mode="getSimpleJSONList"/>					
							];
							
							var techAPRs=[];
												
							<xsl:call-template name="RenderJavascriptScopingFunctions"/>
							
							<xsl:call-template name="RenderGeographicMapJSFunctions"/>
								
							<!-- START PAGE DRAWING FUNCTIONS -->
			 function essGetScope(){
			 
				return essUserScope
			}

			function setLegend() {
			    var legendFragment = $("#rag-overlay-legend-template").html();
			    var legendTemplate = Handlebars.compile(legendFragment);
			    ragOverlayLegend = legendTemplate();

			    legendFragment = $("#no-overlay-legend-template").html();
			    legendTemplate = Handlebars.compile(legendFragment);
			    var legendLabels = {};
			    legendLabels["inScope"] = 'Has Supporting Applications';
			    noOverlayBCMLegend = legendTemplate(legendLabels);
			    legendLabels["inScope"] = 'Applications in Use';
			    noOverlayARMLegend = legendTemplate(legendLabels);
			    legendLabels["inScope"] = 'Technology Products in Use';
			    noOverlayTRMLegend = legendTemplate(legendLabels);
			}
					
	$('.closeBus').on('click', function(){
		$('.busRow').toggle()
		$(this).toggleClass('fa-chevron-circle-down fa-chevron-circle-up');
	})	

	$('.closeApp').on('click', function(){
		$('.appRow').toggle()
		$(this).toggleClass('fa-chevron-circle-down fa-chevron-circle-up');
	})	

	$('.closeTech').on('click', function(){
		$('.techRow').toggle()
		$(this).toggleClass('fa-chevron-circle-down fa-chevron-circle-up');
	})		
	


var bcmTemplate,businessUnits, serviceListTemplate,aprs, filterVals
var appCapList=[];
var lifeToComps=[<xsl:apply-templates select="$life" mode="techLife"/>];
var appfil=0
var busfil=0
var techfil=0;
var scopedCaps,scopedApps;
var techComponentsArray=[];		

function sortMap(ctryList){
 
 let mapObject= $('#mapScope').vectorMap('get', 'mapObject')
	 //setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');
 const mapColors = {};
 if(ctryList.length!=0){
 getCountriesForMap = ctryList
					.map((s) => {
						const businessUnit = businessUnits.businessUnits.find((f) => f.id === s);
						return businessUnit ? businessUnit.country : [];
					})
					.flat()
					.filter((value, index, self) => self.indexOf(value) === index);
				}
 else{
 	getCountriesForMap=allInscopeCountries
 }

 getCountriesForMap.forEach(country => {
	 mapColors[country] = 'hsla(200, 80%, 60%, 1)';
 });

 mapObject.reset();
 mapObject.series.regions[0].setValues(mapColors);
 
}
var allInscopeCountries=[]
var ac2serv;
$(document).ready(function() {
			$('.itaPanel').hide();
            var bcmFragment = $("#bcm-template").html();
            bcmTemplate = Handlebars.compile(bcmFragment);
 

            var techDetailLocalFragment = $("#trm-techcap-popup-template").html();
            techDetailLocalTemplate = Handlebars.compile(techDetailLocalFragment);

            var armFragment = $("#arm-template").html();
            armTemplate = Handlebars.compile(armFragment);

            var appDetailFragment = $("#arm-appcap2-popup-template").html();
            appDetailTemplate = Handlebars.compile(appDetailFragment);

            var trmFragment = $("#trm-template").html();
            trmTemplate = Handlebars.compile(trmFragment);

			var serviceListFragment = $("#service-template").html();
            serviceListTemplate = Handlebars.compile(serviceListFragment);
			
			var serviceListfromCapFragment = $("#serviceCap-template").html();
            serviceListfromCapTemplate = Handlebars.compile(serviceListfromCapFragment);

			var appFragment = $("#app-template").html();
            appTemplate = Handlebars.compile(appFragment);

			var appfromcapFragment = $("#appCap-template").html();
            appfromcapTemplate = Handlebars.compile(appfromcapFragment);

			var techFragment = $("#tech-template").html();
			techTemplate = Handlebars.compile(techFragment);

			var productFragment = $("#product-template").html();
            productTemplate = Handlebars.compile(productFragment);

			Handlebars.registerHelper('getTechComponents', function (arg1) {

				//set filtered component length
				return arg1.techComponents.length

			});

			Handlebars.registerHelper('getTechProducts', function (arg1) {
				return arg1.totProd
			});

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {

				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});

			
			Handlebars.registerHelper('getLifecycle', function (arg1) {
	 
				/*
				let lifeHTML=''
				let xs=arg1.find((d)=>{
					return d=='Extended Support'
				})

				let eol=arg1.find((d)=>{
					return d=='End of Life'
				})

				if(xs){
					lifeHTML=lifeHTML+'&lt;i class="fa fa-circle extendedSupporti">&lt;/i>'
				}
				if(eol){
					lifeHTML=lifeHTML+'&lt;i class="fa fa-circle eoli">&lt;/i>'
				}
			
				return lifeHTML;
				*/
			});

			Handlebars.registerHelper('getLifes', function (arg1) {
		
				let lifeHTML=''
				let xs=arg1.find((d)=>{
					return d=='Extended Support'
				})

				let eol=arg1.find((d)=>{
					return d=='End of Life'
				})

				if(xs){
					lifeHTML=lifeHTML+'&lt;i class="fa fa-circle extendedSupporti">&lt;/i>'
				}
				if(eol){
					lifeHTML=lifeHTML+'&lt;i class="fa fa-circle eoli">&lt;/i>'
				}
			
				return lifeHTML;
			});

			Handlebars.registerHelper('getServices', function (arg1) {
				 
				let mapped= scopedCaps.resources.find((d)=>{
					return d.id == this.id
				})
			
				let newList= mapped.serviceUsage?.filter((obj, index, self) =>	index === self.findIndex((t) => t.id === obj.id));
				return newList?.length
			});
			Handlebars.registerHelper('getAppsMappedtoServices', function (arg1) {
				 
				let mapped= scopedCaps.resources.find((d)=>{
					return d.id == this.id
				})
				let appList=[]; 
					if(mapped){
					mapped.serviceUsage?.forEach((m)=>{
						if(m.appDetails){
							appList=[...appList, ...m.appDetails]  
						}
					})
					if(appList){
						const filteredAppList = scopedApps.resources.filter((r) => appList.some((a) => a.id === r.id));
 
					 const uniqueAppsbyId = Array.from(new Set(filteredAppList.map(item => item.id)))
						.map(id => {
							return filteredAppList.find(item => item.id === id);
						});

						return uniqueAppsbyId.length;
					}else{
					 return 0;
					}
					 
				}else{
					return 0
				}
			});

			Handlebars.registerHelper('getACServices', function (arg1) {
				 
				 let mapped= appCapList.find((d)=>{
					 return d.id == this.id
				 })
			 
				 let newList= mapped.serviceUsage?.filter((obj, index, self) =>	index === self.findIndex((t) => t.id === obj.id));
				 return newList?.length
			 });
			 Handlebars.registerHelper('getACAppsMappedtoServices', function (arg1) {
				  
				 let mapped= appCapList.find((d)=>{
					 return d.id == this.id
				 })
				  
				 let appsUsed=0
				 let appList=[];
					 if(mapped){
					 mapped.serviceUsage?.forEach((m)=>{
						 if(m.appDetails){
							appList=[...appList, ...m.appDetails]  
						 }
 
					 })
					 
					 if(appList){
					const uniqueAppsbyId = Array.from(new Set(appList.map(item => item.id)))
						.map(id => {
							return appList.find(item => item.id === id);
						});
						
					 return uniqueAppsbyId.length;
					}else{
						return 0
					}
				 }else{
					 return 0
				 }
			 });

			Handlebars.registerHelper('getServiceColour', function (arg1) {
				let mapped= scopedCaps.resources.find((d)=>{
					return d.id == this.id
				})
				
				let newServiceIssues=[];
				mapped.serviceUsage?.forEach((d)=>{
					let appcount=0;
					d.appDetails?.forEach((ad)=>{
						let match=scopedApps.resources.find((app)=>{
							return app.id==ad.id
						})
						if(match){appcount=appcount+1}
					})
					newServiceIssues.push(appcount)
				})

				mapped.serviceIssues=newServiceIssues
				if(mapped.serviceIssues?.length&gt;0){ 
				const maxNumber = Math.max.apply(null, mapped.serviceIssues);
					 
				if(maxNumber &gt;5){return 'background-color:red; color:#fff'}
				else if(maxNumber &gt;2){return 'background-color:#c79e2e; color:#fff'}
				else{return 'background-color:#32a899; color:#fff'}
				 } else{
					return 'background-color:#d3d3d3; color:#fff'
				 }
				
			});

			Handlebars.registerHelper('getACServiceColour', function (arg1) {
				 
				let maxNumber=0;
				arg1.serviceUsage?.forEach((s)=>{
				
					const filteredAppList = scopedApps.resources.filter((r) => s.appDetails?.some((a) => a.id === r.id));

					if(filteredAppList.length&gt; maxNumber){
						maxNumber=filteredAppList.length;
					}
				})
				
				if(maxNumber &gt;5){return 'background-color:red; color:#fff'}
				else if(maxNumber &gt;3){return 'background-color:#c79e2e; color:#fff'}
				else if(maxNumber &gt;0){return 'background-color:#32a899; color:#fff'}
				else{
					return 'background-color:#d3d3d3; color:#fff'
				 }
				
			});

			Handlebars.registerHelper('getTechServiceColour', function (arg1) {
				
				maxNumber=arg1.maxProd;
				 if(maxNumber &gt;5){return 'background-color:red; color:#fff'}
				 else if(maxNumber &gt;3){return 'background-color:#c79e2e; color:#fff'}
				 else if(maxNumber &gt;0){return 'background-color:#32a899; color:#fff'}
				 else{
					 return 'background-color:#d3d3d3; color:#fff'
				  }
				 
			 });

	let buSelection="<xsl:value-of select="$param1"/>";

			Promise.all([
				promise_loadViewerAPIData(viewAPIDataAllBusUnits),
				promise_loadViewerAPIData(viewAPIDataTRM),
				promise_loadViewerAPIData(viewAPIDataAllTechCaps),				
				promise_loadViewerAPIData(viewAPIDataAllAC2Serv),
				promise_loadViewerAPIData(viewAPIDataAppStakeholders),
				promise_loadViewerAPIData(viewAPIDataAPM),
				promise_loadViewerAPIData(viewAPIDataAllTechPie),
				promise_loadViewerAPIData(viewAPIDataAllAppMart),
				promise_loadViewerAPIData(viewAPIData),
				promise_loadViewerAPIData(viewAPIDataAllBusCapDetails),
				promise_loadViewerAPIData(viewAPIDataAllBusCapViaAppCap),
				promise_loadViewerAPIData(viewAPIDataAllApp2Servs),
				promise_loadViewerAPIData(viewAPIPathAllAppMart),
				promise_loadViewerAPIData(viewAPIDataAllPhysProcstoApp),
				promise_loadViewerAPIData(viewAPIDataAllTPRs)
			]).then(function (responses)
			{
				businessUnits=responses[0];
				trm=responses[1];
				techCaps=responses[2];
				techPie=responses[6]; 
	
				$('#busUnitList').select2({
			        placeholder: "All",
			        allowClear: true
			    });
				 
				let busUnitSelectedList=[];
				const $busUnitList = $('#busUnitList');
				$busUnitList.off().on('change', function() {
			 
					let BUs=$('#busUnitList').val()
					
					//essRemoveFilter(thisValId)
					BUs.forEach((f) => {
						if (busUnitSelectedList.includes(f)) {
						} else {
							essAddFilter('Group_Actor', f);
						}
						busUnitSelectedList.push(f);
						});

						// Optimized code
						const newFilters = BUs.filter((f) => !busUnitSelectedList.includes(f));
						newFilters.forEach((f) => {
						essAddFilter('Group_Actor', f);
						});
						busUnitSelectedList = [...new Set(busUnitSelectedList)];
								
					let diffArray = busUnitSelectedList.filter(value => !BUs.includes(value));
					let sameArray = busUnitSelectedList.filter(value => BUs.includes(value));
				
					essRemoveFilter(diffArray);

					allCountriesForMap = sameArray
					.map((s) => {
						const businessUnit = businessUnits.businessUnits.find((f) => f.id === s);
						return businessUnit ? businessUnit.country : [];
					})
					.flat()
					.filter((value, index, self) => self.indexOf(value) === index);

					sortMap(allCountriesForMap)
	 
					//setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');	

					//redrawView();
				 
				})

				techCaps.technology_capabilities.forEach((e)=>{
					techComponentsArray=[...techComponentsArray,...e.techComponents];
				})

		

				busProcsToAS=responses[8]
				busCaps=responses[9]; 
				busCapsviaAC=responses[10]
				app2Servs=responses[11];
				appMart=responses[7]; 
				appMart.application_technology=[];
				appMart.application_functions=[];
				aprs=[];
				ac2serv=responses[3]
				arm=responses[5];
				busCapAppMart=responses[12]
	 
				alltprs=responses[14].tprs
		
				alltprs = alltprs.map(obj => {
					return { ...obj, tprid: obj.id };
				});
	
				filterVals=busCapAppMart.filters
                
				let allCountriesForMap=[];
				
				let businessUnitsMap = new Map(businessUnits.businessUnits.map(bu => [bu.id, bu]));
				busCaps.busCaptoAppDetails.forEach((e)=>{
					 
					e.orgUserIds.forEach((oi) => {
					let businessUnit = businessUnitsMap.get(oi);
					if (businessUnit) {
						allCountriesForMap.push(...businessUnit.country);
						allInscopeCountries.push(...businessUnit.country);
					}
				});
					allCountriesForMap = Array.from(new Set(allCountriesForMap));
					allInscopeCountries = Array.from(new Set(allInscopeCountries));
				})

				let workingcap=busCaps.busCaptoAppDetails.filter((d)=>{
					return d.isRoot=="true";
				})

				$('#busCapList').select2({
			        placeholder: "All",
			        allowClear: true
			    });
				$('#busCapList').append("&lt;option value='All'>All&lt;/option>");
				
				workingcap.forEach((d)=>{
					$('#busCapList').append("&lt;option value='"+d.id+"'>"+d.name+"&lt;/option>");
				})

				$('#busCapList').on('change', function(){
					let capId= $('#busCapList').val();
					//need to add code here to cope with org change
					redrawView();
				})
 
				appMart.applications= appMart.applications.map((d) => {
				const match = busCapAppMart.applications.find((e) => e.id === d.id);
				return match ? { ...d, ...match } : d;
				});

				responses[12]=[];
 
				capfilters=responses[9].filters;
				capfilters.sort((a, b) => (a.id > b.id) ? 1 : -1)
				dynamicCapFilterDefs=capfilters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
				appfilters=busCapAppMart.filters;
				appfilters.sort((a, b) => (a.id > b.id) ? 1 : -1)
				dynamicAppFilterDefs=appfilters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
	
				appMart.application_services.forEach((s)=>{
					aprs=[...aprs, ...s.APRs]
				})
				 
				processtoApp=responses[13];   
				let filters=[...capfilters,...appfilters]

				essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS'],filters, true);

				
if(buSelection!=''){
	//console.log('buSelection',buSelection)
	//console.log('mapped',mapped)
	//essAddFilter('Group_Actor', buSelection);
}
let currentSel=essGetScope()
				businessUnits.businessUnits.forEach((d)=>{
					let match=currentSel.find((f)=>{
						return d.id==f.id
					})
					
					if(match){
					$('#busUnitList').append("&lt;option value='"+d.id+"' selected='true'>"+d.name+"&lt;/option>");
					}else{
						$('#busUnitList').append("&lt;option value='"+d.id+"'>"+d.name+"&lt;/option>");	
					}
				})

				let allFilters=[];
			//essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], allFilters, true);
			})
			
		});	


		var redrawView = function () {

			let currentSel=essGetScope()
				let mapped=currentSel.filter((e)=>{
					return e.category=="Business Unit Hierarchy"
				})
				let getIds=[];
				mapped.forEach((e)=>{ getIds.push(e.id)})

				sortMap(getIds)
			 

			essResetRMChanges();

			let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
			let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
			let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
			let prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
			let busDomainDef = new ScopingProperty('domainIds', 'Business_Domain');
			let componentScopeOrgDef= new ScopingProperty('compId', 'Technology_Component');
			let tprScopeDef = new ScopingProperty('tprid', 'Technology_Product_Role');
			let techProdScopeDef=new ScopingProperty('techprodId', 'Technology_Product');

			scopedCaps = essScopeResources(busCaps.busCaptoAppDetails, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef].concat(dynamicCapFilterDefs), busCapTypeInfo);
 
			let scopedAprs = essScopeResources(aprs, [visibilityDef], appRoleTypeInfo);
		 
			scopedApps = essScopeResources(appMart.applications, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), appTypeInfo);
	 			
			let scopedTechCaps = essScopeResources(techCaps.technology_capabilities, [geoScopingDef, visibilityDef], techCapTypeInfo);
 
			let scopedComponents=essScopeResources(techComponentsArray, [geoScopingDef, componentScopeOrgDef], techCapTypeInfo);
		

		 	let scopedTPRs = essScopeResources(alltprs, [tprScopeDef], tprTypeInfo);

			let busCapHierarchyScoped=Array.from(busCaps.busCapHierarchy, item => ({...item}));
  
			busCapHierarchyScoped = busCapHierarchyScoped.filter(item => scopedCaps.resourceIds.includes(item.id));
			busCapHierarchyScoped.forEach((c)=>{
					c.childrenCaps = c.childrenCaps.filter(item => scopedCaps.resourceIds.includes(item.id));
			})

			let capId= $('#busCapList').val();
			 
			if(capId=='All'){
			}
			else{
				let bch = busCapHierarchyScoped.find(e => e.id === capId);
				let busCapHierarchyScopedFiltered = [bch];
				busCapHierarchyScoped = busCapHierarchyScopedFiltered;
			}
		  
			
			let workingBusCaps={"busCapHierarchy":busCapHierarchyScoped}

		//	console.log('workingBusCaps',workingBusCaps)
	
		let trmKeys = Object.keys(trm.trm[0]);
for (const k of trmKeys) {
  const trmKeyData = trm.trm[0][k];
  for (const d of trmKeyData) {
    const childTechCaps = d.childTechCaps || [];
    for (const c of childTechCaps) {
      const match = scopedTechCaps.resources.find((e) => e.id === c.id);
      const comps = [];
      const techComponents = match?.techComponents || [];
      for (const m of techComponents) {
        const compMatch = scopedComponents.resources.find((r) => m.id === r.id);
 
        if (compMatch) {
			let idLookup = {};
			let thistpr = compMatch?.tprIds
			.map(e => scopedTPRs.resources.find(f => f.id === e.id))
			.filter(match => {
				if (match) {
				idLookup[match.id] = match;
				return true;
				}
				return false;
			});

			compMatch['scopedTpr'] = { resources: thistpr };
			comps.push(compMatch);
        }
      }
      c['techComponents'] = comps;
      c['maxProd'] = Math.max(...c.techComponents.map(({ tprs }) => parseInt(tprs)));
      c['totProd'] = c.techComponents.reduce((acc, { tprs }) => acc + parseInt(tprs), 0);
	 
    }
  }
}


 			<!-- bus caps --> 
			  
			scopedCaps.resources.forEach((d)=>{
 
					let match=busCapsviaAC.business_capabilities.find((e)=>{
						return e.busCapId == d.id;
					})
					if(match){
					d['servicesViaAC']=match.appServices
					
					const appMartMap = new Map(scopedApps.resources.map((app) => [app.id, app]));
					const aprsMap = new Map(aprs.map((apr) => [apr.id, apr]));

					d.servicesViaAC.forEach((e) => {
						e.appDetails.forEach((a) => {
							const match = aprsMap.get(a.id);
							if (match) {
							const appNm = appMartMap.get(match.appId);
							if (appNm) {
								a.appname = appNm.name;
								a.appid=appNm.id;
							}
							}
						}); 
						 
					
					});
	
					}
					else{
						d['servicesViaAC']=[];
					}

					d['serviceViaPhysProcess']=[];
					d.allProcesses.forEach((e) => {
  const match = busProcsToAS.process_to_service.find((p) => e.id == p.id);

  if (match) {
    d['servicesViaProcess'] = match.services;
    const serviceIds = d['servicesViaProcess'].map((service) => service.id);

    const filteredAppsforServices = app2Servs.applications_to_services.filter((d) =>
      scopedApps.resourceIds.includes(d.id)
    );

    const filteredApps = filteredAppsforServices.filter((app) => {
      const appServiceIds = app.services.map((service) => service.id);
      const commonServiceIds = appServiceIds.filter((id) => serviceIds.includes(id));

      if (commonServiceIds.length > 0) {
        const appDetails = { ...app };

        commonServiceIds.forEach((serviceId) => {
          const service = d['servicesViaProcess'].find((s) => s.id === serviceId);

          if (service &amp;&amp; !service.appDetails?.some((details) => details.id === appDetails.id)) {
            if (!service.appDetails) {
              service.appDetails = [];
            }
            service.appDetails.push(appDetails);
          }
        });

        return true;
      }

      return false;
    });

    d['couldAppsViaProcess'] = filteredApps;
  }

  const physProcessIndex = processtoApp.process_to_apps.findIndex((p) => e.id == p.processid);

  if (physProcessIndex !== -1) {
    const physProcess = processtoApp.process_to_apps[physProcessIndex];

    physProcess.appsviaservice.forEach((f) => {
      const match = appMart.application_services.find((d) => d.id == f.svcid);

      if (match) {
        f['svcname'] = match.name;
        const appmatch = scopedApps.resources.find((d) => d.id == f.appid);

        if (appmatch) {
			
          f['appname'] = appmatch.name;
          f['appid'] = appmatch.id;
          f['aprid'] = appmatch.id;
        }
      }
    });

    d.serviceViaPhysProcess.push(...physProcess.appsviaservice);
  }
});



					const outputArray = d.serviceViaPhysProcess.map(item => ({
						id: item.svcid,
						name: item.svcname,
						appDetails: [{ id: item.appid, name: item.name, appname:item.appname , aprid: item.aprid, used: true}]
					  }));
					  d['serviceViaPhysProcess']=outputArray
 
					let mergedArray = [];
					  if(d.servicesViaProcess){
							d.servicesViaProcess.forEach((s)=>{
								 
								s.appDetails?.forEach((a)=>{ 
									let match= a.services?.find((as)=>{
										return as.id==s.id;
									}) 
									if(match){ 
										a['aprid']=match.apr;
									}
								})
							})
				 
					}
					if (d.servicesViaProcess) {
					mergedArray = [...mergedArray, ...d.servicesViaProcess];
					}
					
					if (d.servicesViaAC) {
				
						mergedArray = [...mergedArray, ...d.servicesViaAC];
						}
					
						
					if (d.serviceViaPhysProcess) {
						mergedArray = [...mergedArray, ...d.serviceViaPhysProcess];
					}
					
					const mergedData = {};

					mergedArray.forEach(item => {
					if (!mergedData[item.id]) {
						mergedData[item.id] = { ...item };
					} else {

						if (mergedData[item.id]) {
							if (!Array.isArray(mergedData[item.id].appDetails)) {
								// Initialize appDetails as an empty array if it's not an array
								mergedData[item.id].appDetails = [];
							}
						
							if (Array.isArray(item.appDetails)) {
								// Only proceed if item.appDetails is an array
								mergedData[item.id].appDetails = [
									...mergedData[item.id].appDetails, 
									...item.appDetails
								];
								mergedData[item.id].appDetails = mergeApps(mergedData[item.id].appDetails);
							} else {
								// item.appDetails is not an array so null, ignore
							}
						}
					}
					
						
					});
				 
 						
				 
					 mergedArray = Object.values(mergedData);
					  let ServIssues=[];
					mergedArray.forEach((d)=>{
						d['serviceIssues']=[];
						if(d.appDetails){
						const groupedArray = Object.values(d.appDetails.reduce((acc, obj) => {
							if (!acc[obj.id]) {
								acc[obj.id] = obj;
							} else {
								acc[obj.id] = {
									...acc[obj.id],
									...obj
								};
							}
							return acc;
						}, {}));

						d.appDetails=groupedArray;
						
							if(d.appDetails?.length &gt;3){
								d.serviceIssues.push(d.appDetails.length)
								ServIssues.push(d.appDetails.length)
							 
							}else if(d.appDetails?.length &gt;0){
								d.serviceIssues.push(d.appDetails.length)
								ServIssues.push(d.appDetails.length)
							 
							}
						}
					})

					d['serviceIssues']=ServIssues;
					d['serviceUsage']=mergedArray; 
					d.serviceUsage?.forEach((e)=>{
						let appmatch=appMart.application_services?.find((d)=>{
							return d.id == e.id
						})
						e['description']=appmatch?.description;
					})
					
				})
		
				$("#bcm").html(bcmTemplate(workingBusCaps)).promise().done(function(){
					if(busfil==0){
						$('.busCircleInfo').hide()
					}
					$('#busOverlayDup').off().on('click', function(){
						
						if ($('.busCircleInfo').is(':hidden')) {
							$('.busCircleInfo').show()
							busfil=1
						  } else {
							$('.busCircleInfo').hide()
							busfil=0
						  } 
					})
					$('.busCapInfo').on('click', function(){
					 
						let mapped= scopedCaps.resources.find((d)=>{
							return d.id == $(this).attr('easid')
						})

						mapped.serviceUsage?.forEach((s) => {
							// Filter scopedApps.resources using a Set for faster lookup
							const filteredAppSet = new Set(s.appDetails?.map((a) => a.id));
							const filteredAppList = scopedApps.resources.filter((r) => filteredAppSet.has(r.id));
						  
							// Use map instead of forEach to create a new array with 'used' property
							const filteredAppsWithUsed = filteredAppList.map((f) => {
							  const match = s.appDetails.find((g) => f.id === g.id);
							  return { ...f, used: match.used };
							});
						  
							s.appDetailsfiltered = filteredAppsWithUsed;
						  
							// Use Set for faster lookup
							const serviceAppSet = new Set(appMart.application_services.find((r) => r.id === s.id).APRs.map((e) => e.appId));
							
							// Use filter instead of forEach to create a new array
							const allServApps = scopedApps.resources.filter((f) => serviceAppSet.has(f.id));
						  
							s.allServicsApps = allServApps;
						  });

					$('#listBox').html(serviceListTemplate(mapped))
						openNav(); 
						addAppSlideUp(mapped, 'bus')
						
					
					})
				})
 
 arm.arm[0].left.forEach((s)=>{
	getApps(s)
	
	s.childAppCaps.forEach((sub)=>{
		getApps(sub)
	})
 })	

 arm.arm[0].middle.forEach((s)=>{
	getApps(s)
	s.childAppCaps.forEach((sub)=>{
		getApps(sub)
	})
 })	

 arm.arm[0].right.forEach((s)=>{
	getApps(s)
	s.childAppCaps.forEach((sub)=>{
		getApps(sub)
	})	
 })	

 let codebase = d3.nest()
  .key(function(d) { return d.ap_codebase_status; })
  .entries(scopedApps.resources);
 
 const matchFilter = filterVals.find((f) => f.id === 'Codebase_Status');

 codebaseLabels=[]
 codebaseValues=[]
 codebaseColours=[]
codebase.forEach((e) => {
  const match = matchFilter.values.find((f) => e.key === f.id);
  if (match) {
    e.name = match.name;
	e.backgroundColor = match.backgroundColor;
	e.colour = match.colour;
  }
  if(e.key=='undefined'|| e.key == ''){e['name']='Not Set'}
  
  if(e.backgroundColor==''){
	e.backgroundColor = getRandomColor();
	}
	if(!e.backgroundColor){
	e.backgroundColor = getRandomColor();
	}	
 codebaseLabels.push(e.name+' ('+e.values.length+')')
 codebaseValues.push(e.values.length)
 codebaseColours.push(e.backgroundColor)
});


 
	var ctx = document.getElementById('appCodebasePie').getContext('2d');
	var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: codebaseLabels,
        datasets: [{
            data: codebaseValues,
            backgroundColor: codebaseColours
        }]
    },
    options: {
        legend: {
            position: 'bottom',
			labels: {
                fontSize: 10 
            }
        }
    }
});
<!-- delivery -->

let delivery = d3.nest()
  .key(function(d) { return d.ap_delivery_model; })
  .entries(scopedApps.resources);

 const matchFilterDel = filterVals.find((f) => f.id === 'Application_Delivery_Model');

 deliveryLabels=[]
 deliveryValues=[]
 deliveryColours=[]
delivery.forEach((e) => {
  const match = matchFilterDel.values.find((f) => e.key === f.id);
  if (match) {
    e.name = match.name;
	e.backgroundColor = match.backgroundColor;
	e.colour = match.colour;
  }
  if(e.key=='undefined'|| e.key == ''){e['name']='Not Set'}
  
  if(e.backgroundColor==''){
	e.backgroundColor = getRandomColor();
	}
	if(!e.backgroundColor){
	e.backgroundColor = getRandomColor();
	}	
 deliveryLabels.push(e.name +' ('+e.values.length+')')
 deliveryValues.push(e.values.length)
 deliveryColours.push(e.backgroundColor)
});


 
	var ctx = document.getElementById('appDeliveryPie').getContext('2d');
	var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: deliveryLabels,
        datasets: [{
            data: deliveryValues,
            backgroundColor: deliveryColours
        }]
    },
    options: {
        legend: {
            position: 'bottom',
			labels: {
                fontSize: 10 
            }
        }
    }
});

function getRandomColor() {
  const letters = '0123456789ABCDEF';
  let color = '#';
  for (let i = 0; i &lt; 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}

function mergeApps(obj){
	const mergedData = obj.reduce((accumulator, current) => {
	const existing = accumulator.find((item) => item.id === current.id || item.appid === current.appid || item.aprid === current.id || item.id === current.aprid || item.id === current.appid  || item.appid === current.id );
	if (existing) {
		Object.assign(existing, current);
	} else {
		accumulator.push(current);
	}
	return accumulator;
	}, []);
	return mergedData
}


function addAppSlideUp(item, type){
	$('.appsCircle').on('click', function(){	
		let theId=$(this).attr('easid');
		let thechoice=$(this).attr('choice');
		let toShow = item.serviceUsage.find((e)=>{
			return e.id==theId;
		}) 

		toShow.appDetails=mergeApps(toShow.appDetails) 
		 
		$('#itaData').html(appTemplate(toShow))
		$('.itaPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
		$('.closePanelButton').on('click',function(){ 
			$('.itaPanel').hide();
		})
		if(type=='bus'){
			$('.appsvckey').show()
		}
		else{
			$('.appsvckey').hide()
		}
	})

	$('.appsCapCircle').on('click', function(){	
		let theId=$(this).attr('easid');
		let thechoice=$(this).attr('choice');
		let toShow = item.serviceUsage.find((e)=>{
			return e.id==theId;
		}) 

		toShow.appDetails=mergeApps(toShow.appDetails) 
		 
		$('#itaData').html(appfromcapTemplate(toShow))
		$('.itaPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
		$('.closePanelButton').on('click',function(){ 
			$('.itaPanel').hide();
		})
		if(type=='bus'){
			$('.appsvckey').show()
		}
		else{
			$('.appsvckey').hide()
		}
	})
	

}
 function getApps(svs){

	let servs=ac2serv.application_capabilities_services.find((e)=>{
		return svs.id==e.id
	})

	svs['serviceUsage']=servs?.services;
	svs.serviceUsage?.forEach((sv)=>{
		let svmatch=appMart.application_services.find((d)=>{
				return d.id == sv.id
			})
			sv['description']=svmatch.description;
	let appsWithService = app2Servs.applications_to_services.filter(app => {
			return app.services.some(service => {
				return service.id === sv.id;
			});
		});

	 
		appsWithService = appsWithService.filter((app) => {
			return scopedApps.resourceIds.some((resourceId) => {
			  return resourceId === app.id;
			});
		  });

	const uniqueApps = {};
	appsWithService.forEach(app => {
		if (!uniqueApps[app.appname]) {
			uniqueApps[app.appname] = app;
		} else if (app.used === "true") {
			uniqueApps[app.appname] = app;
		}
	});

	appsWithService = Object.values(uniqueApps);	
		sv['appDetails']=appsWithService
		return;
	})
	appCapList.push(svs)
 }

	$('#appRefModelContainer').html(armTemplate(arm))
	if(appfil==0){
		$('.appCircleInfo').hide()
	}
		$('#appOverlayDup').off().on('click', function(){
			
			if ($('.appCircleInfo').is(':hidden')) {
				$('.appCircleInfo').show()
				appfil=1
			  } else {
				$('.appCircleInfo').hide()
				appfil=0
			  }
			 
		})


	$('.appCapInfo').on('click', function(){
	<!-- add action here for app cap -->

		let mapped= appCapList.find((d)=>{
			return d.id == $(this).attr('easid')
		})

		mapped.serviceUsage?.forEach((s) => {
			 
			const filteredAppSet = new Set(s.appDetails?.map((a) => a.id));
			const filteredAppList = scopedApps.resources.filter((r) => filteredAppSet.has(r.id));
 
			const filteredAppsWithUsed = filteredAppList.map((f) => {
				const match = s.appDetails.find((g) => f.id === g.id);
				return { ...f, used: match.used };
			});
			
			s.appDetailsfiltered = filteredAppsWithUsed;
			 
			const serviceAppSet = new Set(appMart.application_services.find((r) => r.id === s.id).APRs.map((e) => e.appId));
			 
			const allServApps = scopedApps.resources.filter((f) => serviceAppSet.has(f.id));
			
			s.allServicsApps = allServApps;
			});

		
	$('#listBox').html(serviceListfromCapTemplate(mapped))
		openNav(); 
		addAppSlideUp(mapped, 'app')
		$('.appsvckey').css('display','none')
	})

	$('#techRefModelContainer').html(trmTemplate(trm.trm[0]))
	$('.techCircle').hide();
	if(techfil==0){
		$('.techCircleInfo').hide()
	}
		$('#techOverlayDup').off().on('click', function(){
			 
			if ($('.techCircleInfo').is(':hidden')) {
				$('.techCircleInfo').show()
				techfil=1;
			  } else {
				$('.techCircleInfo').hide()
				techfil=0;
			  }
		})

 	$(".lifecycleCircle").hide();
		$('#techOverlayStatus').on('click', function(){
				$(".lifecycleCircle").toggle();
			extendedSupport=lifeToComps.find((d)=>{
				return d.name=='Extended Support';
			});

			eol=lifeToComps.find((d)=>{
				return d.name=='End of Life';
			});
			<!-- set to xs first then set EOL -->

			extendedSupport.techCapabilities.forEach((e)=>{ 
				$('[easlifeid="'+e+'"]').addClass('extendedSupport'); 
					
			})
 
			eol.techCapabilities.forEach((e)=>{
				$('[easlifeid="'+e+'"]').addClass('eol'); 
			})


		})	
 
 techDeliveryLabels=[]
 techDeliveryValues=[]
 techDeliveryColours=[]
techPie.delivery.forEach((e) => {

 techDeliveryLabels.push(e.name+' ('+e.count+')')
 techDeliveryValues.push(e.count)
 techDeliveryColours.push(e.colour)
});


 
	var ctx = document.getElementById('techDeliveryPie').getContext('2d');
	var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: techDeliveryLabels,
        datasets: [{
            data: techDeliveryValues,
            backgroundColor: techDeliveryColours
        }]
    },
    options: {
        legend: {
            position: 'bottom',
			labels: {
                fontSize: 10 
            }
        }
    }
});
 
  
 techReleaseLabels=[]
techReleaseValues=[]
 techReleaseColours=[]

techPie.release.forEach((e) => {

 techReleaseLabels.push(e.name+' ('+e.count+')')
 techReleaseValues.push(e.count)
  techReleaseColours.push(e.colour)
});



	var ctx = document.getElementById('techReleasePie').getContext('2d');
	var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: techReleaseLabels,
        datasets: [{
            data: techReleaseValues,
            backgroundColor: techReleaseColours
        }]
    },
    options: {
        legend: {
            position: 'bottom',
			labels: {
                fontSize: 10 
            }
        }
    }
});


 
	$('.techInfo').on('click', function(){ 
		
		let thisSelected=$(this).attr('easid');

		let match = scopedTechCaps.resources.find((e)=>{
			return e.id == thisSelected
		}) 

const workingMatch = Object.assign({}, match);
let matchedComponents=[]
workingMatch.techComponents.forEach((e)=>{
 
	let match=scopedComponents.resourceIds.find((c)=>{
			return c==e.id
	}) 
	if(match){matchedComponents.push(e)}
})
 
workingMatch.techComponents=matchedComponents 

workingMatch.techComponents.forEach((e)=>{

	let thisscopedTPRs = essScopeResources(e.tprIds, [tprScopeDef], tprTypeInfo);
		if(thisscopedTPRs){ 
			e['scopedTpr']=thisscopedTPRs
			e.tprs=thisscopedTPRs.resources.length
		}
							
  e['life']=[];
  lifeToComps.forEach((l)=>{
  
    let lifeMatch=l.techComponents.find((f)=>{
      return f==e.id; // return a boolean value
    })
    if(lifeMatch){ 
      		e.life.push(l.name)
    }
  })
})

		$('#listBox').html(productTemplate(workingMatch))
		openNav(); 

		let techProdtoShow=[];

		let createArray=match.techComponents.forEach((t)=>{
			
			let viewAPISimpleData

			viewAPISimpleData=viewAPISimple+'&amp;PMA='+t.osid;
	 
			getData(viewAPISimpleData)
				.then(result => {
				
					let techProdRole=result.instance.find((f)=>{
						return f.name=='realised_by_technology_products';
					})

					if(techProdRole){
						techProdRole.value.forEach((tp)=>{

							let inScope=scopedTPRs.resourceIds.find((e)=>{
								return e==tp.id
							})
							if(inScope){
							let viewAPISimpleData2

						viewAPISimpleData2=viewAPISimple+'&amp;PMA='+tp.id
						
							getData(viewAPISimpleData2).then(result2 => {
							
								let techProd=result2.instance.find((f)=>{
									return f.name=='role_for_technology_provider';
								})
								let techProdStatus=result2.instance.find((f)=>{
									return f.name=='strategic_lifecycle_status';
								}) 

								let thisLife='';
								lifeToComps.find((e)=>{
								
									let match=e.techProducts.find((f)=>{
										if(techProd){
										return techProd.value.id==f
										}
									})
									 
									if(match){
										thisLife=e.name
									}
								})

								console.log('tp', techProd)
								techProdtoShow.push({"compId":t.id,"compName":t.name, "name":techProd.value[0].name, "id":techProd.value[0].id, "lifecycle":thisLife})
							 	$('[easid="' + t.id + '"]').children('.fa-info-circle').css('color','#d3d3d3');

							}).then(()=>{ 
								//$('#itaData').html('&lt;i class="fa fa-spinner fa-pulse fa-3x fa-fw">&lt;/i>')
							 
							 
								if(techProdtoShow){
									$('.techCircle').off().on('click', function(){
										let theId=$(this).attr('easid');

											let toShow = techProdtoShow.filter((e)=>{
												return e.compId==theId;
											}) ;
									
											$('#itaData').html(techTemplate(toShow))
											$('.itaPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
											$('.closePanelButton').on('click',function(){ 
												$('.itaPanel').hide();
											}) 
			
									})
								}
							})
							}
						})
					}
				 
				})
		})
		
	 
 
	//	addAppSlideUp(mapped, 'app') 
	})

}	

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

	function getLink(instance, type){		
		let meta=[
		{"classes":["Group_Actor"], "menuId":"grpActorGenMenu"},
		{"classes":["Business_Capability"], "menuId":"busCapGenMenu"},
		{"classes":["Application_Provider","Composite_Application_Provider"], "menuId":"appProviderGenMenu"},
		{"classes":["Application_Service"], "menuId":"appSvcGenMenu"},
		{"classes":["Business_Domain"], "menuId":"busDomainGenMenu"},
		{"classes":["Business_Process"], "menuId":"busProcessGenMenu"},
		{"classes":["Physical_Process"], "menuId":"physProcessGenMenu"}];

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
			instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="">' + instance.name + '</a>';

			return instanceLink;
		}
	};		
	
	const appTypeInfo = {
		"className": "Application_Provider",
		"label": 'Application',
		"icon": 'fa-desktop'
	}
	const techCapTypeInfo = {
		"className": "Technology_Capability",
		"label": 'Technology Capability',
		"icon": 'fa-server'
	}
	const tprTypeInfo = {
		"className": "Technology_Product_Role",
		"label": 'Technology Product Role',
		"icon": 'fa-server'
	}
	
	const appRoleTypeInfo = {
		"className": "Application_Provider_Role",
		"label": 'Application Role',
		"icon": 'fa-desktop'
	}
	const busCapTypeInfo = {
		"className": "Business_Capability",
		"label": 'Business Capability',
		"icon": 'fa-landmark'
	}


	function openNav()
		{	
			document.getElementById("appSidenav").style.marginRight = "0px";
		}
		
		function closeNav()
		{
			workingCapId=0;
			document.getElementById("appSidenav").style.marginRight = "-552px";
		}

	function getData(dta) {
  return new Promise(function(resolve, reject) {
    promise_loadViewerAPIData(dta)
      .then(function(response1) {
        // Set a global variable
        thisviewAPIData = response1;
        // Resolve the Promise with the response
        resolve(response1);
      })
      .catch(function(error) {
        console.error('Error occurred:', error);
        // Reject the Promise with the error
        reject(error);
      });
  });
}

  

	
						</script>

						

						<!--Setup Closing Tags-->
					</div>
				</div> 
				<script id="serviceCap-template" type="text/x-handlebars-template">
				 
					<table class="table table-striped table-condensed">
						<thead>
							<tr>
								<th>Service</th>
								<th>Description</th>
								<th>Apps</th> 
							</tr>
						</thead>
						<tbody class="smallTableFont">
					{{#each this.serviceUsage}}
						<tr>
							<td>{{this.name}}</td>
							<td>{{this.description}}</td>
							<td class="appsCapCircle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="choice">all</xsl:attribute>{{this.allServicsApps.length}} <i class="fa fa-info-circle fa-info-circle-colour"></i></td>
						</tr>
					{{/each}}
					</tbody>
				</table>
				</script> 
				<script id="service-template" type="text/x-handlebars-template">
				 
					<table class="table table-striped table-condensed">
						<thead>
							<tr>
								<th>Service</th>
								<th>Description</th>
								<th>This Capability</th>
								<th>All Apps</th>
							</tr>
						</thead>
						<tbody class="smallTableFont">
					{{#each this.serviceUsage}}
						<tr>
							<td>{{this.name}}</td>
							<td>{{this.description}}</td>
							<td class="appsCircle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="choice">cap</xsl:attribute>{{this.appDetailsfiltered.length}} <i class="fa fa-info-circle fa-info-circle-colour"></i></td>
							<td class="appsCircle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="choice">all</xsl:attribute>{{this.allServicsApps.length}} <i class="fa fa-info-circle fa-info-circle-colour"></i></td>
						</tr>
					{{/each}}
					</tbody>
				</table>
				</script> 
				<script id="product-template" type="text/x-handlebars-template">
				 
				 <table class="table table-striped table-condensed">
					 <thead>
						 <tr>
							 <th>Technology Type</th>
							 <th>Number of Products</th> 
						 </tr>
					 </thead>
					 <tbody class="smallTableFont">
				 {{#each this.techComponents}}
					 <tr>
						 <td>{{this.name}}</td>
						 <td class="techCircle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute>{{this.tprs}} <i class="fa fa-info-circle" style="color:#fff"></i>
						 {{#getLifes this.life}}{{/getLifes}}
						 </td>
					 </tr>
				 {{/each}}
				 </tbody>
			 </table>
			 </script> 
				<script id="bcm-template" type="text/x-handlebars-template">
					<h3>{{rootCap}} Capabilities</h3>
					{{#each busCapHierarchy}}					
						<div class="row">
							<div class="col-xs-12">
								<div class="refModel-l0-outer">
									<div class="refModel-l0-title fontBlack large">
										{{name}}
									</div>
									{{#each this.childrenCaps}} 
											<div class="busRefModel-blob"><xsl:attribute name="style">{{#getServiceColour this}}{{/getServiceColour}}</xsl:attribute>
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{this.id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{this.id}}</xsl:text></xsl:attribute>
												<div class="refModel-blob-title">
													{{this.name}}
													<div class="servicesUsedCircle busCircleInfo">{{#getServices this}}{{/getServices}}</div>
													<div class="appsUsedCircle busCircleInfo">{{#getAppsMappedtoServices this}}{{/getAppsMappedtoServices}}</div>
												</div>
												<div class="refModel-blob-info">
													<xsl:attribute name="eas">{{this.id}}</xsl:attribute>
													<i class="fa fa-info-circle text-white busCapInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
										
												</div>
											</div> 
									{{/each}}
									<div class="clearfix"/>
								</div>
								{{#unless @last}}
									<div class="clearfix bottom-10"/>
								{{/unless}}
							</div>
						</div>
					{{/each}}				
				</script>

				<script id="arm-template" type="text/x-handlebars-template">
			<div class="col-xs-4 col-md-3 col-lg-2" id="refLeftCol">
			 	{{#each this.arm.0.left}}
								<div class="row bottom-15">
									<div class="col-xs-12">
										<div class="refModel-l0-outer matchHeight1">
											<div class="refModel-l0-title fontBlack large">
											 {{this.name}}
											</div>
											{{#each childAppCaps}}
													<div class="appRefModel-blob"><xsl:attribute name="style">{{#getACServiceColour this}}{{/getACServiceColour}}</xsl:attribute>
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{this.name}}
															<div class="servicesUsedCircle appCircleInfo">{{#getACServices this}}{{/getACServices}}</div>
															<div class="appsUsedCircle appCircleInfo">{{#getACAppsMappedtoServices this}}{{/getACAppsMappedtoServices}}</div>
												
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-white appCapInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
														</div>
													</div>											
											{{/each}}
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							{{/each}}
						</div>
						<div class="col-xs-4 col-md-6 col-lg-8 matchHeight1" id="refCenterCol">
							{{#each this.arm.0.middle}}							
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
													<div class="appRefModel-blob"><xsl:attribute name="style">{{#getACServiceColour this}}{{/getACServiceColour}}</xsl:attribute>
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{this.name}}
															<div class="servicesUsedCircle appCircleInfo">{{#getACServices this}}{{/getACServices}}</div>
															<div class="appsUsedCircle appCircleInfo">{{#getACAppsMappedtoServices this}}{{/getACAppsMappedtoServices}}</div>
												
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-white appCapInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
														</div>
													</div>										
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
										{{#unless @last}}
											<div class="clearfix bottom-10"/>
										{{/unless}}
									</div>
								</div>
							{{/each}}
						</div>
						<div class="col-xs-4 col-md-3 col-lg-2" id="refRightCol">
							{{#each this.arm.0.right}}
								<div class="row bottom-15">
									<div class="col-xs-12">
										<div class="refModel-l0-outer matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
												<a href="#" class="text-default">
													<div class="appRefModel-blob"><xsl:attribute name="style">{{#getACServiceColour this}}{{/getACServiceColour}}</xsl:attribute>
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{this.name}}
															<div class="servicesUsedCircle appCircleInfo">{{#getACServices this}}{{/getACServices}}</div>
															<div class="appsUsedCircle appCircleInfo">{{#getACAppsMappedtoServices this}}{{/getACAppsMappedtoServices}}</div>
												
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-white appCapInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
														</div>
													</div>
												</a>
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							{{/each}}
						</div>
		</script>
		<script id="arm-appcap-popup-template" type="text/x-handlebars-template">
			{{#appCapApps}}			
				<tr>
					<td>{{{link}}}</td>
					<td>{{{description}}}</td>
					<td>{{count}}</td>
				</tr>
			{{/appCapApps}}
		</script> 

		<script id="trm-template" type="text/x-handlebars-template">
			<div class="col-xs-12">
				{{#each top}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{name}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob"><xsl:attribute name="style">{{#getTechServiceColour this}}{{/getTechServiceColour}}</xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{name}}
											<div class="componentsUsedCircle techCircleInfo">{{#getTechComponents this}}{{/getTechComponents}}</div>
											<div class="techUsedCircle techCircleInfo">{{#getTechProducts this}}{{/getTechProducts}}</div>
										</div>
										<div class="lifecycleCircle"><xsl:attribute name="easlifeid">{{this.id}}</xsl:attribute></div>
										<div class="refModel-blob-info">
											<i class="fa fa-info-circle text-white techInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
												
										</div>
									</div>								
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--Ends-->
			<!--Left-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each left}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{name}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob"><xsl:attribute name="style">{{#getTechServiceColour this}}{{/getTechServiceColour}}</xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{name}}
											<div class="componentsUsedCircle techCircleInfo">{{#getTechComponents this}}{{/getTechComponents}}</div>
											<div class="techUsedCircle techCircleInfo">{{#getTechProducts this}}{{/getTechProducts}}</div>
										</div>
										<div class="lifecycleCircle"><xsl:attribute name="easlifeid">{{this.id}}</xsl:attribute></div>
										<div class="refModel-blob-info">
											<i class="fa fa-info-circle text-white techInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
												
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--ends-->
			<!--Center-->
			<div class="col-xs-4 col-md-6 col-lg-8 matchHeightTRM">
				{{#each middle}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer">
								<div class="refModel-l0-title fontBlack large">
									{{name}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob"><xsl:attribute name="style">{{#getTechServiceColour this}}{{/getTechServiceColour}}</xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{name}}
											<div class="componentsUsedCircle techCircleInfo">{{#getTechComponents this}}{{/getTechComponents}}</div>
											<div class="techUsedCircle techCircleInfo">{{#getTechProducts this}}{{/getTechProducts}}</div>
										</div>
										<div class="lifecycleCircle"><xsl:attribute name="easlifeid">{{this.id}}</xsl:attribute></div>
										<div class="refModel-blob-info">
											<i class="fa fa-info-circle text-white techInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
												
										</div>
									</div>
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
							{{#unless @last}}
								<div class="clearfix bottom-10"/>
							{{/unless}}
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Right-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each right}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{name}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob"><xsl:attribute name="style">{{#getTechServiceColour this}}{{/getTechServiceColour}}</xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{name}}
										
										<div class="componentsUsedCircle techCircleInfo">{{#getTechComponents this}}{{/getTechComponents}}</div>
											<div class="techUsedCircle techCircleInfo">{{#getTechProducts this}}{{/getTechProducts}}</div>
										</div>
										<div class="lifecycleCircle"><xsl:attribute name="easlifeid">{{this.id}}</xsl:attribute></div>
										<div class="refModel-blob-info">
											<i class="fa fa-info-circle text-white techInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
									
												
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--ends-->
			<!--Bottom-->
			<div class="col-xs-12">
				<div class="clearfix bottom-10"/>
				{{#each bottom}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{name}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob"><xsl:attribute name="style">{{#getTechServiceColour this}}{{/getTechServiceColour}}</xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute><xsl:attribute name="easid"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{name}}
											<div class="componentsUsedCircle techCircleInfo">{{#getTechComponents this}}{{/getTechComponents}}</div>
											<div class="techUsedCircle techCircleInfo">{{#getTechProducts this}}{{/getTechProducts}}</div>
										</div>
										<div class="lifecycleCircle"><xsl:attribute name="easlifeid">{{this.id}}</xsl:attribute></div>
										<div class="refModel-blob-info">
											<i class="fa fa-info-circle text-white techInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
											
												
										</div>
									</div>							
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--Ends-->
		</script>
		

	
				<!-- ADD THE PAGE FOOTER -->
				<script id="tech-template" type="text/x-handlebars-template">
					<div class="row">
							<div class="col-sm-8">
							<!--	<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>-->
								 
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
								<h2>Technology Products</h2>
								<p>Technology Products supporting the selected component <b>{{this.compName}}</b></p><!--<div class="pull-right appsvckey">Key:<i class="fa fa-square" style="color:#008dff"></i> Used<xsl:text> </xsl:text><i class="fa fa-square" style="color:#238c8a"></i> Could be Used</div>-->
								{{#each this}}
										
										<div class="card">
										<div class="card-header"><xsl:attribute name="style">background-color:#238c8a</xsl:attribute>
												{{this.name}}
										</div>
										<div class="card-body">
											<h2 class="card-title">This product supports the technology component</h2>
											<div class="lifeBox">
											{{#if this.lifecycle}}{{this.lifecycle}}{{else}}Not Set{{/if}}
											</div>
										</div>
										</div>
								{{/each}}
							</div>
					</div>
				</script>
				<script id="app-template" type="text/x-handlebars-template">
					<div class="row">
							<div class="col-sm-8">
							<!--	<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>-->
								 
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
								<h2>Application Service Usage</h2>
								<p>Applications supporting the selected service <b>{{this.name}}</b></p><div class="pull-right appsvckey">Key:<i class="fa fa-square" style="color:#008dff"></i> Used<xsl:text> </xsl:text><i class="fa fa-square" style="color:#238c8a"></i> Could be Used</div>
								{{#each this.appDetailsfiltered}}
										
										<div class="card">
										<div class="card-header"><xsl:attribute name="style">{{#ifEquals this.used true}}{{else}}background-color:#238c8a{{/ifEquals}}</xsl:attribute>
											{{#if this.appname}}
												{{this.appname}}
											{{else}}
												{{this.name}}
											{{/if}}
											 
										</div>
										<div class="card-body">
											<h2 class="card-title">{{#ifEquals this.used true}}This application <b>is used</b> for this service{{else}}This application <b>could be used</b> for this service{{/ifEquals}}</h2>
										</div>
										</div>
								{{/each}}
							</div>
							<div class="col-sm-4">
								<h4>All applications Providing this service</h4>
							{{#each this.allServicsApps}}
										
										<div class="card card-sm">
										<div class="card-header"><xsl:attribute name="style">background-color:#8c2323</xsl:attribute>
											{{#if this.appName}}
												{{this.appname}}
											{{else}}
												{{this.name}}
											{{/if}}
											 
										</div>
									
										</div>
								{{/each}}
							</div>
					</div>
				</script>
				
				<script id="appCap-template" type="text/x-handlebars-template">
					<div class="row">
							<div class="col-sm-8">
							<!--	<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>-->
								 
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
								<h2>Application Service Usage</h2>
								<p>Applications supporting the selected service <b>{{this.name}}</b></p><div class="pull-right appsvckey">Key:<i class="fa fa-square" style="color:#008dff"></i> Used<xsl:text> </xsl:text><i class="fa fa-square" style="color:#238c8a"></i> Could be Used</div>
								{{#each this.allServicsApps}}
										
										<div class="card">
										<div class="card-header"><xsl:attribute name="style">{{#ifEquals this.used true}}{{else}}background-color:#238c8a{{/ifEquals}}</xsl:attribute>
											{{#if this.appname}}
												{{this.appname}}
											{{else}}
												{{this.name}}
											{{/if}}
											 
										</div>
										<div class="card-body">
											<h2 class="card-title">{{#ifEquals this.used true}}This application <b>is used</b>{{else}}This application <b>could be used</b>{{/ifEquals}}</h2>
										</div>
										</div>
								{{/each}}
							</div>
							<div class="col-sm-4">
							</div>
					</div>
				</script>
				<div class="itaPanel" id="itaPanel">
						<div id="itaData"></div>
				</div>
				<xsl:call-template name="Footer"/>
	<script id="arm-appcap2-popup-template" type="text/x-handlebars-template">
		 	{{#each this}}			
				<tr>
 					<td>{{{this.link}}}</td>
					<td>{{this.description}}</td>
					<td>{{this.count}}</td>
				</tr>
			{{/each}}
		</script>
	<script id="trm-techcap-popup-template" type="text/x-handlebars-template">
			{{#each techCapProds}}			
				<tr>
 					<td>{{{link}}}</td>
					<td>{{count}}</td>
				</tr>
			{{/each}}
		</script>				
			</body>
            
		</html>
	</xsl:template>


	<xsl:template name="scopeMap">
		<div class="col-xs-6">
			<div class="dashboardPanel bg-offwhite match1">
				<h2 class="text-secondary">Geographic Scope</h2>
				<div class="row">
					<div class="col-xs-12">
						<div class="map" id="mapScope"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>



	<xsl:template name="busSection">
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Business Perspective</h2>
				<div class=" pull-right"><i class="fa fa-chevron-circle-up closeBus"></i></div>
				<div class="row busRow">
					<div class="col-xs-6 bottom-15" id="bcmLegend">
						<div class="keyTitle">Legend:</div>
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide" style="background-color: #32a899;"/>
						<div class="keyLabel">Low</div>
						<xsl:text> </xsl:text>
						<span class="busCircle"><i class="fa fa-circle-o" style="color:green"></i><xsl:text> </xsl:text>#Services<xsl:text> </xsl:text>
						<i class="fa fa-circle-o" style="color:red"></i><xsl:text> </xsl:text>#Applications
						</span>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<!--<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayNone" value="none" checked="checked" />Application Support</label>-->
							<label class="radio-inline"><input type="checkbox" name="busOverlay" id="busOverlayDup" value="duplication"  />Service Numbers</label>
						
						</div>
					</div> 
					<div class="col-xs-12" id="bcm">
						<div class="alignCentre xlarge">
							<span><xsl:value-of select="eas:i18n('Loading Business View')"/>...</span><i class="fa fa-spinner fa-pulse fa-fw"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="appSection">
		 
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Application Perspective</h2>
				<div class=" pull-right"><i class="fa fa-chevron-circle-up closeApp"></i></div>
				<div class="row appRow">
					<script>
						$(document).ready(function() {
						 	$('.matchHeight1').matchHeight();
						});
					</script>
					<div class="col-xs-6 col-lg-6">
						<h3 class="text-primary">Code Base</h3>
						<div class="col-xs-2"></div>
						<div class="col-xs-7">
							<!--<div class="pieChart" id="appCodebasePieChart"/>-->
							<canvas id="appCodebasePie" width="200px" height="200px"></canvas>
						</div>
					</div>
					<div class="col-xs-6 col-lg-6">
						<h3 class="text-primary">Delivery Model</h3>
						<div class="col-xs-2"></div>
						<div class="col-xs-7">
							<!--<div class="pieChart" id="appCodebasePieChart"/>-->
							<canvas id="appDeliveryPie" width="200px" height="200px"></canvas>
						</div>
					</div>
					<div class="col-xs-12">
						<hr/>
					</div>
					<div class="col-xs-6 bottom-15" id="armLegend">
						<div class="keyTitle">Legend:</div>
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide" style="background-color: #32a899;"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide" style="background-color: #d3d3d3;"/>
						<div class="keyLabel">No Mapping</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="checkbox" name="appOverlay" id="appOverlayDup" value="duplication"  />Service Numbers</label>
							</div>
					</div>
					<div class="simple-scroller" id="appRefModelContainer">
						<div class="alignCentre xlarge">
							<span><xsl:value-of select="eas:i18n('Loading Application View')"/>...</span><i class="fa fa-spinner fa-pulse fa-fw"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="techSection"> 
		<script>
			$(document).ready(function() {
			 	$('.matchHeight1').matchHeight();
			});
		</script>
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Technology Perspective</h2>
				<div class=" pull-right"><i class="fa fa-chevron-circle-up closeTech"></i></div>
				<div class="row techRow">
					<div class="col-xs-6 col-lg-6">
						<h3 class="text-primary">Product Release Status</h3>
							<div class="col-xs-2"></div>
						<div class="col-xs-7">
							<!--<div class="pieChart" id="appCodebasePieChart"/>-->
							<canvas id="techReleasePie" width="200px" height="200px"></canvas>
						</div>
					</div>
					<div class="col-xs-6 col-lg-6">
						<h3 class="text-primary">Delivery Model</h3>
						<div class="col-xs-2"></div>
						<div class="col-xs-7">
							<!--<div class="pieChart" id="appCodebasePieChart"/>-->
							<canvas id="techDeliveryPie" width="200px" height="200px"></canvas>
						</div>
					</div>
					<div class="col-xs-12">
						<hr/>
					</div>
					<div class="col-xs-6 bottom-15" id="trmLegend">
						<div class="keyTitle">Legend:</div>
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide bg-brightgreen-120"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide" style="background-color: #d3d3d3;"/>
						<div class="keyLabel">No Mapping</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="checkbox" name="techOverlay" id="techOverlayDup" value="duplication"/>Show Numbers</label>
							<label class="radio-inline"><input type="checkbox" name="techLegacy" id="techOverlayStatus" value="status"/>Legacy Risk</label>
						</div>
					</div>
					<div class="simple-scroller" id="techRefModelContainer">
						<div class="alignCentre xlarge">
							<span><xsl:value-of select="eas:i18n('Loading Technology View')"/>...</span><i class="fa fa-spinner fa-pulse fa-fw"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</xsl:template>
	

	
    <xsl:template match="node()" mode="RenderAppStakeholderJSONList">
     { id:"<xsl:value-of select="current()/name"/>", stakeholders:[<xsl:for-each select="current()/own_slot_value[slot_reference='stakeholders']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
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
    
    <!-- This XSL template contains an example of the view-specific stuff -->
    <xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPathSimple"/>
        <xsl:param name="viewerAPIPath"/>
        <xsl:param name="viewerAPIPathAPM"/>
        <xsl:param name="viewerAPIPathTRM"/>
        <xsl:param name="viewerAPIPathAppStakeholders"/>
        <xsl:param name="viewerAPIPathTechStakeholders"/>
        <xsl:param name="viewerapiPathAllBusCapViaAppCaps"/>
        <xsl:param name="viewerAPIPathAllTechProds"/>
        <xsl:param name="viewerAPIPathAllTechPie"/>
        <xsl:param name="viewerAPIPathAllTechCaps"/>
        <xsl:param name="viewerAPIPathAllBusUnits"/>
		<xsl:param name="viewerAPIPathAllTPRs"/>
		<xsl:param name="viewerAPIPathAllBusCapDetails"/>
		<xsl:param name="viewerAPIPathAppMart"/>
		<xsl:param name="viewerAPIPathAllAppMart"/>
		<xsl:param name="viewerAPIPathAllAC2Serv"/>
		<xsl:param name="viewerAPIPathAllApp2Servs"/>
		<xsl:param name="viewerAllPhysProcstoApp"/>
		 
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
        var viewAPIDataAPM = '<xsl:value-of select="$viewerAPIPathAPM"/>';
        var viewAPIDataTRM = '<xsl:value-of select="$viewerAPIPathTRM"/>';
        var viewAPIDataAppStakeholders = '<xsl:value-of select="$viewerAPIPathAppStakeholders"/>';
        var viewAPIDataTechStakeholders = '<xsl:value-of select="$viewerAPIPathTechStakeholders"/>';
        var viewAPIDataAllBusCapViaAppCap = '<xsl:value-of select="$viewerapiPathAllBusCapViaAppCaps"/>';
        var viewAPIDataTechProds = '<xsl:value-of select="$viewerAPIPathAllTechProds"/>';
        var viewAPIDataAllTechPie =  '<xsl:value-of select="$viewerAPIPathAllTechPie"/>';
        var viewAPIDataAllTechCaps =  '<xsl:value-of select="$viewerAPIPathAllTechCaps"/>';
        var viewAPIDataAllBusUnits =  '<xsl:value-of select="$viewerAPIPathAllBusUnits"/>';
		var viewAPIDataAllTPRs =  '<xsl:value-of select="$viewerAPIPathAllTPRs"/>';
		var viewAPIDataAllBusCapDetails =  '<xsl:value-of select="$viewerAPIPathAllBusCapDetails"/>';
		var viewAPIDataAllAppMart =  '<xsl:value-of select="$viewerAPIPathAppMart"/>';
		var viewAPIDataAllAC2Serv =  '<xsl:value-of select="$viewerAPIPathAllAC2Serv"/>';
		var viewAPIDataAllApp2Servs =  '<xsl:value-of select="$viewerAPIPathAllApp2Servs"/>';
		var viewAPIPathAllAppMart='<xsl:value-of select="$viewerAPIPathAllAppMart"/>'; 
		var viewAPIDataAllPhysProcstoApp='<xsl:value-of select="$viewerAllPhysProcstoApp"/>'; 
		var viewAPISimple='<xsl:value-of select="$viewerAPIPathSimple"/>';
		
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
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

        
    </xsl:template>
	<xsl:template name="GetViewerDynamicAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$dataSetPath"/>
    </xsl:template>
	<xsl:template match="node()" mode="techLife">
 <xsl:variable name="thistech" select="key('tech', current()/name)"/>
 <xsl:variable name="thistechtpr" select="key('techtpr', $thistech/name)"/>
 <xsl:variable name="thistechcomp" select="key('techcomp', $thistechtpr/name)"/>
 
       {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
       "name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>",
	   "techProducts":[<xsl:apply-templates select="$thistech/name" mode="node"/>],
  	   "techComponents":[<xsl:apply-templates select="$thistechcomp/name" mode="node"/>],
       "techCapabilities":[<xsl:apply-templates select="$thistechcomp/own_slot_value[slot_reference='realisation_of_technology_capability']/value" mode="node"/>]}<xsl:if test="position()!last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="node">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!last()">,</xsl:if></xsl:template>

</xsl:stylesheet>
