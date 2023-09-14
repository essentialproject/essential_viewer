<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
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

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	 <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BCM List']"/>
    <xsl:variable name="anAPIReportARM" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Capability Model']"/>
    <xsl:variable name="anAPIReportTRM" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Capability Model']"/>
    <xsl:variable name="anAPIReportAppStakeholders" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Stakeholders IDs']"/>
    <xsl:variable name="anAPIReportTechStakeholders" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Stakeholder IDs']"/> 
	<xsl:variable name="anAPIReportAppPie" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get App Pie Data']"/>
	<xsl:variable name="anAPIReportTechPie" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get Tech Pie Data']"/>
    <xsl:variable name="anAPIReportAllApps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application List']"/>
    <xsl:variable name="anAPIReportAllTechProducts" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Product List']"/>
    <xsl:variable name="anAPIReportAllAppCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Application Capability L1']"/>
    <xsl:variable name="anAPIReportAllTechCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get All Tech Capability Info']"/>
     <xsl:variable name="anAPIReportAllBusinessUnits" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get Business Units']"/>
     <xsl:variable name="anAPIReportAllTPRs" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get All Tech Product Roles']"/>
	 <xsl:variable name="anAPIReportAllBusCapDetails" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: IT Asset Dashboard Get All Business Capabilities']"/>
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
	
	
	<!-- ROADMAP VARIABLES 	-->
	<!--<xsl:variable name="allRoadmapInstances" select="$allApps union $allTechProds"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/> -->
	<xsl:variable name="isRoadmapEnabled" select="false()"/>
    <!-- END ROADMAP VARIABLES -->
    
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
        <xsl:variable name="apiPathAllApps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllApps"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAllTechProds">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllTechProducts"/>
            </xsl:call-template>
        </xsl:variable>        
         <xsl:variable name="apiPathAllAppCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAllAppCaps"/>
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
		
		<xsl:variable name="apiPathAllAppPie">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportAppPie"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAllTechPie">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportTechPie"/>
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
				<script async="true" src="js/es6-shim/0.9.2/es6-shim.js" type="text/javascript"/>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"/>
				<script src="{$geoMapPath}" type="text/javascript"/>
				<script language="javascript" type="text/javascript" src="js/jqplot/jquery.jqplot.min.js"/>
				<script src="js/chartjs/Chart.min.js"/>
				<script src="js/chartjs/chartjs-plugin-labels.min.js"/> 
				<xsl:call-template name="dataTablesLibrary"/>
				<!--<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>-->
				
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
						cursor: pointer;
					}
					
					.map{
						width: 100%;
						height: 250px;
					}
					
					.popover{
						max-width: 800px;
					}
				</style>
				
				<xsl:call-template name="refModelStyles"/>
				
				<!--Pie Chart Styles-->
				<style>
					.fa-info-circle {
						cursor: pointer;
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
					}</style>
				<!--Ends-->
                
                
				
			</head>
			<body>
				
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>-->
				<!--<div id="ess-roadmap-content-container">
					<!-\- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -\->
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
					<div class="clearfix"></div>
				</div>-->

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
						<xsl:call-template name="RenderDataSetAPIWarning"/>
					<xsl:call-template name="RenderDashboardBusUnitFilter"/>
						<xsl:call-template name="scopeMap"/>
						<!--<xsl:call-template name="investmentProfilePie"/>-->
						<xsl:call-template name="busSection"/>
						<xsl:call-template name="appSection"/>
						<xsl:call-template name="techSection"/>	
						<script type="text/javascript">
					
				        <xsl:call-template name="RenderViewerAPIJSFunction">
                            <xsl:with-param name="viewerAPIPath" select="$apiPath"/>
                            <xsl:with-param name="viewerAPIPathAPM" select="$apiPathAPM"/>
                            <xsl:with-param name="viewerAPIPathTRM" select="$apiPathTRM"/>
                            <xsl:with-param name="viewerAPIPathAppStakeholders" select="$apiPathAppStakeholders"/>
                            <xsl:with-param name="viewerAPIPathTechStakeholders" select="$apiPathTechStakeholders"/>
                            <xsl:with-param name="viewerAPIPathAllApps" select="$apiPathAllApps"/>
                            <xsl:with-param name="viewerAPIPathAllTechProds" select="$apiPathAllTechProds"/>
                            <xsl:with-param name="viewerAPIPathAllAppCaps" select="$apiPathAllAppCaps"/>
                            <xsl:with-param name="viewerAPIPathAllTechCaps" select="$apiPathAllTechCaps"/>
							<xsl:with-param name="viewerAPIPathAllBusUnits" select="$apiPathAllBusUnits"/>
							<xsl:with-param name="viewerAPIPathAllTPRs" select="$apiPathAllTPRs"/>
							<xsl:with-param name="viewerAPIPathAllBusCapDetails" select="$apiPathAllBusCapDetails"/>
							<xsl:with-param name="viewerAPIPathAllAppPie" select="$apiPathAllAppPie"/>
							<xsl:with-param name="viewerAPIPathAllTechPie" select="$apiPathAllTechPie"/>
                             
                        </xsl:call-template>
                      
							var appCodebasePie, appDeliveryModelPie, techProdStatusPie, techProdDeliveryPie, bcmDetailTemplate, appDetailTemplate, techDetailLocalTemplate, ragOverlayLegend, noOverlayBCMLegend, noOverlayARMLegend, noOverlayTRMLegend, stakeH, stakeHT,appCapDetails,tprs,techCapDetails, selectedBusUnits, appStakeholders,appPieData;
							var defaultPieColour = 'white';
                            
                        <!--
                            var appStakeholders =[<xsl:apply-templates select="$allApps" mode="RenderAppStakeholderJSONList"/>];
                        
							var techStakeholders =[<xsl:apply-templates select="$allTechProds" mode="RenderAppStakeholderJSONList"/>];
                            -->
							// the list of JSON objects representing the code base types for applications
						  	var appCodebases = [<xsl:apply-templates select="$allAppCodebases" mode="RenderEnumerationJSONList"/>];
							
							// the list of JSON objects representing the delivery models for applications
						  	var appDeliveryModels = [<xsl:apply-templates select="$allAppDeliveryModels" mode="RenderEnumerationJSONList"/>];
							
							// the list of JSON objects representing the delivery models for technology products
						  	var techDeliveryModels = [<xsl:apply-templates select="$allTechProdDeliveryTypes" mode="RenderEnumerationJSONList"/>];
							
							// the list of JSON objects representing the environments
						  	var lifecycleStatii = [
								<xsl:apply-templates select="$allLifecycleStatii" mode="getSimpleJSONList"/>					
							];
							
							var techCapsToShow=[];	
							var busCapstoShow=[];
							var appCapstoShow=[];
							var appPieDatatoShow=[];
							var techPieDatatoShow=[];
						  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
												
							<xsl:call-template name="RenderJavascriptScopingFunctions"/>
							
							<xsl:call-template name="RenderGeographicMapJSFunctions"/>
								
							<!-- START PAGE DRAWING FUNCTIONS -->
							

			//Function to set values for a pie chart based on properties that contain a specific value

			//function to get the segment colour in a pie chart
			function getPieColour(segmentColour) {
			    if (segmentColour == null) {
			        return defaultPieColour;
			    }
			    if (segmentColour.startsWith('hsl')) {
			        return defaultPieColour;
			    }
			    return segmentColour;
			}

			function setBusUnits() {
			    //INITIALISE THE SCOPING DROP DOWN LIST
			    $('#busUnitList').select2({
			        placeholder: "All",
			        allowClear: true
			    });

			    //INITIALISE THE PAGE WIDE SCOPING VARIABLES					
			    allBusUnitIDs = getObjectIds(businessUnits.businessUnits, 'id');
			    selectedBusUnitIDs = [];
			    selectedBusUnits = []; 

			    $('#busUnitList').on('change', function(evt) {
			        var thisBusUnitIDs = $(this).select2("val");
			        
			        if (thisBusUnitIDs != null) {
			            setCurrentBusUnits(thisBusUnitIDs);
						setCurrentApps(thisBusUnitIDs)	
						setCurrentTech(thisBusUnitIDs);
						setPieCharts(thisBusUnitIDs);	
						//console.log(thisBusUnitIDs);	
			        } else {
			            selectedBusUnitIDs = [];
			            selectedBusUnits = [];
			        }
			      
			        //console.log("Select BUs: " + selectedBusUnitIDs);
					 setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');	
					$('#busOverlayNone').prop('checked', true); 
					$('#appOverlayNone').prop('checked', true); 
					$('#techOverlayNone').prop('checked', true); 		
			    });

			    var busUnitSelectFragment = $("#bus-unit-select-template").html();
			    var busUnitSelectTemplate = Handlebars.compile(busUnitSelectFragment);
			    $("#busUnitList").html(busUnitSelectTemplate(businessUnits));
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
					
	function setCurrentTech(users){	
	<!-- filter tech by users  -->						
	filteredTech=[];		
	if(users.length&gt;0){		
							
		techCapDetails.technology_capabilities.forEach(function(d){
				d.techComponents.forEach(function(e){
						users.forEach(function(usr){	
						var userIn=e.usersList.filter(function(f){
								return f==usr;
								});
						if(userIn.length&gt;0){
								filteredTech.push(d);	
								}	
							});
							})			
					});
		let uniqueTech = [...new Set(filteredTech)];						
 		techCapstoShow=[];					
		techCapstoShow.push({'technology_capabilities':uniqueTech})
		techCapstoShow=techCapstoShow[0]				
		 formatTechCapModel(techCapstoShow)					
							
			}else{
 
			techCapstoShow=techCapDetails;			
		 	formatTechCapModel(techCapDetails)
							
			};
		};
	function setCurrentApps(users){
<!-- set models based on users -->					 
	filteredAppList=[]	
	<!-- if selected BU find apps then filter caps by app services-->						
	if(users.length&gt;0){						
			appStakeholders.appStakeholders.forEach(function(d){
				users.forEach(function(usr){		
					var thisUsr= d.stakeholderIDs.filter(function(e){			 
							return e ==usr
							});
						
					if(thisUsr.length&gt;0){filteredAppList.push(d.id)}		
						});
					});				
	 				
			let uniqueApps = [...new Set(filteredAppList)];					
		busCapstoShow=[];	
		appCapstoShow=[];	
						
		var count=0;
		var appcount=0;	
		var techCount=0;					
		busCapDetails.forEach(function(d){
		thisServices=[];		
			if(d.appServices.length &gt;1){			
				d.appServices.forEach(function(e){
						e.apps.forEach(function(f){
								var match=uniqueApps.filter(function(g){
						return g==f;
									});
					 
								if(match.length &gt;0){
									thisServices.push(e)
									count++;
									};
							});	
					});	
				};
	 	let uniquServices = [...new Set(thisServices)];	
		busCapstoShow.push({"busCapId":d.busCapId,"appServices":uniquServices})							
			});	
							
		appCapDetails.forEach(function(d){
		thisServices=[];		
						
				d.application_services.forEach(function(e){
						e.apps.forEach(function(f){
								var match=uniqueApps.filter(function(g){
						return g==f;
									});
					 
								if(match.length &gt;0){
									thisServices.push(e)
									appcount++;
									};
							});	
					});	
	 	let uniquServices = [...new Set(thisServices)];	
		appCapstoShow.push({"id":d.id,"application_services":uniquServices})				
							
			});					
							
		 
			formatBusCapModel(busCapstoShow) 		                
			formatAppCapModel(appCapstoShow)
				
		}
		else{ 
			formatBusCapModel(busCapDetails) 
			formatAppCapModel(appCapDetails)					
				}
							};
						
var busCapStyle = 'busRefModel-blob bg-darkblue-80';
var appCapStyle = 'appRefModel-blob bg-darkblue-80';								
var techCapStyle = 'techRefModel-blob bg-darkblue-80';							
var noBusCapStyle = 'busRefModel-blob bg-lightgrey';
var noAppCapStyle = 'appRefModel-blob bg-lightgrey';
var noTechCapStyle = 'techRefModel-blob bg-lightgrey';
							
function formatBusCapModel(list) {
	$('.busRefModel-blob').removeClass();
    $('.busRefModel-blob').addClass(noBusCapStyle)
    $('.busCapTableRow').empty();
    list.forEach(function(d) {

        if (d.appServices.length &gt; 0) {
            $('[easid="' + d.busCapId + '"]').addClass(busCapStyle);
            var appSvcDetailList = {};
            appSvcDetailList["busCapApps"] = [];

            d.appServices.forEach(function(e) {
                anAppSvcDetail = {};
                anAppSvcDetail["link"] = e.link;
                anAppSvcDetail["description"] = e.description;
                anAppSvcDetail["count"] = e.apps.length;


                appSvcDetailList.busCapApps.push(anAppSvcDetail);
            });

            var detailTableBodyId = '#' + d.busCapId + '_app_rows';

            $(detailTableBodyId).html(bcmDetailTemplate(appSvcDetailList));

        } else {
            $('[easid="' + d.busCapId + '"]').addClass(noBusCapStyle)
        };
    })
};


function formatAppCapModel(list) {
 
    <!--set all blobs to no colour-->
	$('.appRefModel-blob').removeClass();
    $('.appRefModel-blob').addClass(noAppCapStyle); <!--clear tables-->
    $('.appCapTableRow').empty();
   
    list.forEach(function(d) {
 
        if (d.appServices.length &gt; 0) {
            $('[easid="' + d.id + '"]').addClass(appCapStyle);
                            
 

            var appSvcDetailList = {};
            appSvcDetailList["appCapApps"] = [];
            var anAppSvcDetail;
            d.appServices.forEach(function(e) {
                anAppSvcDetail = {};
                anAppSvcDetail["link"] = e.link;
                anAppSvcDetail["description"] = e.description;
                anAppSvcDetail["count"] = e.apps.length;


                appSvcDetailList.appCapApps.push(anAppSvcDetail);
            });
            var detailTableBodyId = '#' + d.id + '_app_rows';

            $(detailTableBodyId).html(appDetailTemplate(appSvcDetailList.appCapApps))
        } else {
            $('[easid="' + d.id + '"]').addClass(noAppCapStyle)
        };

    })
};

function formatTechCapModel(list) {

    <!--set all blobs to no colour-->
	$('.techRefModel-blob').removeClass().addClass('techRefModel-blob');
    $('.techRefModel-blob').addClass(noTechCapStyle); <!--clear tables-->
    $('.techCapTableRow').empty();
 
    list.technology_capabilities.forEach(function(d) {
		let popupId = d.id + '_info';
        if (d.techComponents.length &gt; 0) {      
            var capDetailList = {};
            capDetailList["techCapProds"] = [];
            var capDetail;
            let tprScore = 0;
            d.techComponents.forEach(function(e) {
            	tprScore = tprScore + e.tprs;
                capDetail = {};
                capDetail["link"] = e.link;
                capDetail["count"] = e.tprs;
                capDetailList.techCapProds.push(capDetail);
            });
            
            if(tprScore > 0) {
            	$('[easid="' + d.id + '"]').addClass(techCapStyle);          
	            var detailTableBodyId = '#' + d.id + '_techprod_rows';
	            	
	            //console.log(capDetailList);
	            //console.log(techDetailLocalTemplate(capDetailList.techCapProds))
	
	            $(detailTableBodyId).html(techDetailLocalTemplate(capDetailList));
            } else {            	
            	$('.refModel-blob-info[easid="' + popupId + '"]').addClass('hiddenDiv');
            }
        } else {
           $('[easid="' + d.id + '"]').addClass(noTechCapStyle)
           $('.refModel-blob-info[easid="' + popupId + '"]').addClass('hiddenDiv');
        };

    })
};


function duplicateBusCapModel(list) {

    list.forEach(function(d) {
        //$('[easid="' + d.busCapId + '"]').removeClass();
        if (d.appServices.length &gt; 0) {
            var thisStyle = getDuplicationStyle(d.appServices.length, 'busRefModel-blob')
            $('[easid="' + d.busCapId + '"]').attr('class', thisStyle);
        } else {
            $('[easid="' + d.busCapId + '"]').attr('class', 'busRefModel-blob bg-green-120');
        };
    });
};

function duplicateAppCapModel(list) {
    list.forEach(function(d) {

        if (d.appServices.length &gt; 0) {
            var score = 0;
            d.appServices.forEach(function(e) {
                score = score + e.apps.length;
                if (e.apps.length &gt; 4) {
                    score = score + 100
                }
            });
            
            if(score > 0) {
	            score = score / d.appServices.length;
	            var thisStyle = getDuplicationStyle(score, 'appRefModel-blob')
	            $('[easid="' + d.id + '"]').attr('class', thisStyle);
            } else {
            	$('[easid="' + d.id + '"]').attr('class', 'appRefModel-blob bg-lightgrey');
            }
        } else {
            $('[easid="' + d.id + '"]').attr('class', 'appRefModel-blob bg-lightgrey');
        };
    });
};

function duplicateTechCapModel(list) {
 	console.log('Tech Prods');
 	console.log(list);
    list.technology_capabilities.forEach(function(d) {
 
        if (d.techComponents.length &gt; 0) {
            var score = 0;
            d.techComponents.forEach(function(e) {
                score = score + e.tprs;
                if (e.tprs &gt; 4) {
                    score = score + 100
                }
            });
			
			if(score > 0) {
	            score = score / d.techComponents.length;
	            var thisStyle = getDuplicationStyle(score, 'techRefModel-blob')
	
	            $('[easid="' + d.id + '"]').attr('class', thisStyle);
            } else {
            	$('[easid="' + d.id + '"]').attr('class', 'techRefModel-blob bg-lightgrey');
            }
        } else {
            $('[easid="' + d.id + '"]').attr('class', 'techRefModel-blob bg-lightgrey');
        };
    });
	 
};
							
function formatAppPieCharts(pieVals){
						
	var ctxCodebase=$('#appCodebasePie');				
							
			appCodebases=pieVals.codebases;
			codebaseData=[];
			codebaseLabels=[];	
			codebaseColours=[];		
					 
				appCodebases.forEach(function(d){
					codebaseData.push(d.piecount)
					codebaseLabels.push(d.name)	
					codebaseColours.push(d.colour)		
							})
		 					
			data = {
				datasets: [{
				backgroundColor: codebaseColours,
					data: codebaseData
				}],

				// These labels appear in the legend and in the tooltips when hovering different arcs
				labels: codebaseLabels
			};
	 		
			var codebaseChart = new Chart(ctxCodebase, {
				type: 'pie',
				data: data,
				plugins: {
							labels: {
								render: 'percentage',
								precision: 2
							}
						}

			});	 
	
		var ctxDelivery=$('#appDeliveryPie');				
						
			appdelivery=pieVals.delivery;
			deliveryData=[];
			deliveryLabels=[];	
			deliveryColours=[];					
				appdelivery.forEach(function(d){
					deliveryData.push(d.piecount)
					deliveryLabels.push(d.name)	
					deliveryColours.push(d.colour)		
							})				
			data = {
				datasets: [{
				backgroundColor: deliveryColours,
					data: deliveryData
				}],

				// These labels appear in the legend and in the tooltips when hovering different arcs
				labels: deliveryLabels
			};
	 		
			var deliveryChart = new Chart(ctxDelivery, {
				type: 'pie',
				data: data,
				plugins: {
							labels: {
								render: 'percentage',
								precision: 2
							}
						}
			});	 							
		};

function formatTechPieCharts(pieVals) {
 
    var ctxTechRelease = $('#techReleasePie');

    techRelease = pieVals.release;
    releaseData = [];
    releaseLabels = [];
    releaseColours = [];
    techRelease.forEach(function(d) {
        releaseData.push(d.piecount)
        releaseLabels.push(d.name)
        releaseColours.push(d.colour)
    })
    data = {
        datasets: [{
            backgroundColor: releaseColours,
            data: releaseData
        }],

        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: releaseLabels
    };

    var releaseChart = new Chart(ctxTechRelease, {
        type: 'pie',
        data: data,
        plugins: {
            labels: {
                render: 'percentage',
                precision: 2
            }
        }

    });
 
    var ctxTechDelivery = $('#techDeliveryPie');

    techdelivery = pieVals.delivery;
    deliveryData = [];
    deliveryLabels = [];
    deliveryColours = [];
    techdelivery.forEach(function(d) {
        deliveryData.push(d.piecount)
        deliveryLabels.push(d.name)
        deliveryColours.push(d.colour)
    })
    data = {
        datasets: [{
            backgroundColor: deliveryColours,
            data: deliveryData
        }],

        // These labels appear in the legend and in the tooltips when hovering different arcs
        labels: deliveryLabels
    };

    var deliveryChart = new Chart(ctxTechDelivery, {
        type: 'pie',
        data: data,
        plugins: {
            labels: {
                render: 'percentage',
                precision: 2
            }
        }
    });
};		
							
function setPieCharts(users) {

    if (users.length &gt; 0) {
        appPieDatatoShow.codebases.forEach(function(d) {
            codeApps = [];
            d.orgsUsage.forEach(function(e) {
                users.forEach(function(usr) {
                    var orgUsing = e.orgs.filter(function(f) {

                        return f.id == usr
                    });

                    if (orgUsing.length &gt; 0) {
                        ;
                        codeApps.push(e);
                    }
                });
            });

            let uniqueAppPie = [...new Set(codeApps)];
            d['piecount'] = (uniqueAppPie.length);

        });

        appPieDatatoShow.delivery.forEach(function(d) {
            deliveryApps = [];
            d.orgsUsage.forEach(function(e) {
                users.forEach(function(usr) {
                    var orgUsing = e.orgs.filter(function(f) {

                        return f.id == usr
                    });

                    if (orgUsing.length &gt; 0) {
                        ;
                        deliveryApps.push(e);
                    }
                });
            });

            let uniqueAppPie = [...new Set(deliveryApps)];
            d['piecount'] = (uniqueAppPie.length);
        });
        formatAppPieCharts(appPieDatatoShow)

        techPieDatatoShow.delivery.forEach(function(d) {
            deliveryTech = [];
            d.orgsUsage.forEach(function(e) {
                users.forEach(function(usr) {
                    var orgUsing = e.orgs.filter(function(f) {

                        return f.id == usr
                    });

                    if (orgUsing.length &gt; 0) {
                        ;
                        deliveryTech.push(e);
                    }
                });
            });

            let uniqueTechPie = [...new Set(deliveryTech)];
            d['piecount'] = (uniqueTechPie.length);
        });

        techPieDatatoShow.release.forEach(function(d) {
            releaseTech = [];
            d.orgsUsage.forEach(function(e) {
                users.forEach(function(usr) {
                    var orgUsing = e.orgs.filter(function(f) {

                        return f.id == usr
                    });

                    if (orgUsing.length &gt; 0) {
                        releaseTech.push(e);
                    }
                });
            });

            let uniqueTechPie = [...new Set(releaseTech)];
            d['piecount'] = (uniqueTechPie.length);
        });
        formatTechPieCharts(techPieDatatoShow)
    } else {

        appPieData.codebases.forEach(function(d) {
            d.piecount = d.count;
        });
        appPieData.delivery.forEach(function(d) {
            d.piecount = d.count;
        });
        techPieData.release.forEach(function(d) {
            d.piecount = d.count;
        });
        techPieData.delivery.forEach(function(d) {
            d.piecount = d.count;
        });
        formatAppPieCharts(appPieData)
        formatTechPieCharts(techPieData)
    };

};

function setCurrentBusUnits(busUnitIdList) {
	selectedBusUnitIDs = busUnitIdList;
	selectedBusUnits = getObjectsByIds(businessUnits.businessUnits, "id", selectedBusUnitIDs);
			
	}		



function initDashboardFilters() {
	promise_loadViewerAPIData(viewAPIDataAllBusUnits)
    .then(function(response) {		
		businessUnits = response;
        
        setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');	
	    setBusUnits();
    })
    .catch(function(error) {
        //display an error somewhere on the page   
    });
}


function initBusLayerDashboard() {
	Promise.all([
        promise_loadViewerAPIData(viewAPIData),
        promise_loadViewerAPIData(viewAPIDataAllBusCapDetails)						
    ])
    .then(function(responses) {

        viewAPIData = responses[0];	  //Bus Cap Hierarchy			
        busCapDetails = responses[1].business_capabilities;
        $("#bcm").html(bcmTemplate(viewAPIData.bcm[0])).promise().done(function(){
        
            busCapstoShow = busCapDetails;
            formatBusCapModel(busCapstoShow);
            
            $('#busOverlayDup').click(function() {                  
                duplicateBusCapModel(busCapstoShow);
            });
            
            $('#busOverlayNone').click(function() {	
                formatBusCapModel(busCapstoShow);
            });
        });
    })
    .catch(function(error) {
        //display an error somewhere on the page   
    });
}


function initAppLayerDashboard() {
	Promise.all([
        promise_loadViewerAPIData(viewAPIDataAppStakeholders),
        promise_loadViewerAPIData(viewAPIDataAPM),
        promise_loadViewerAPIData(viewAPIDataAllAppCaps),
        promise_loadViewerAPIData(viewAPIDataAllAppPie)
    ])
    .then(function(responses) {

        appStakeholders = responses[0];
        viewAPIDataAPM = responses[1];
        appCapDetails = responses[2].application_capabilities;
        appPieData=responses[3];                      
        $("#appRefModelContainer").html(armTemplate(viewAPIDataAPM.arm[0])).promise().done(function(){
       
            appCapstoShow = appCapDetails;;
            appPieDatatoShow = appPieData;  
                     formatAppCapModel(appCapstoShow);
            formatAppPieCharts(appPieData);
            
            $('#appOverlayDup').click(function() {                   
                duplicateAppCapModel(appCapstoShow);
            });
            
            $('#appOverlayNone').click(function() {	
                formatAppCapModel(appCapstoShow);
            });
        });
    })
    .catch(function(error) {
        //display an error somewhere on the page   
    });
}


function initTechLayerDashboard() {
	Promise.all([
		promise_loadViewerAPIData(viewAPIDataTRM),
        promise_loadViewerAPIData(viewAPIDataAllTechCaps),				
		promise_loadViewerAPIData(viewAPIDataAllTechPie)
    ])
    .then(function(responses) {       
        viewAPIDataTRM = responses[0];
        techCapDetails = responses[1];			    
		techPieData=responses[2];
        
        $("#techRefModelContainer").html(trmTemplate(viewAPIDataTRM.trm[0])).promise().done(function(){
            
            techCapstoShow = techCapDetails;				
			techPieDatatoShow = techPieData                      
            formatTechCapModel(techCapstoShow)							
 			formatTechPieCharts(techPieData);
            
            $('#techOverlayDup').click(function() {
                duplicateTechCapModel(techCapstoShow);
            });
            
            $('#techOverlayNone').click(function() {	
                formatTechCapModel(techCapstoShow);
            });			
        });
    })
    .then(function() {
        $('.fa-info-circle').click(function() {
            $('[role="tooltip"]').remove();
            return false;
        });
        
        $('.fa-info-circle').popover({
            container: 'body',
            html: true,
            sanitize: false,
            trigger: 'click',
            content: function() {
                return $(this).next().html();
            }
        });
    })
    .catch(function(error) {    	
        //display an error somewhere on the page   
    });
}

var bcmTemplate;
							
$(document).ready(function() {

            var bcmFragment = $("#bcm-template").html();
            bcmTemplate = Handlebars.compile(bcmFragment);

            var bcmDetailFragment = $("#bcm-buscap-popup-template").html();
            bcmDetailTemplate = Handlebars.compile(bcmDetailFragment);

            var techDetailLocalFragment = $("#trm-techcap-popup-template").html();
            techDetailLocalTemplate = Handlebars.compile(techDetailLocalFragment);

            var armFragment = $("#arm-template").html();
            armTemplate = Handlebars.compile(armFragment);

            var appDetailFragment = $("#arm-appcap2-popup-template").html();
            appDetailTemplate = Handlebars.compile(appDetailFragment);

            var trmFragment = $("#trm-template").html();
            trmTemplate = Handlebars.compile(trmFragment);
            
            initDashboardFilters();
            initBusLayerDashboard();
            initAppLayerDashboard();
            initTechLayerDashboard();

            <!--Promise.all([
                promise_loadViewerAPIData(viewAPIData),
                promise_loadViewerAPIData(viewAPIDataAllBusUnits),
                promise_loadViewerAPIData(viewAPIDataAllBusCapDetails),
                
                promise_loadViewerAPIData(viewAPIDataAppStakeholders),
                promise_loadViewerAPIData(viewAPIDataAPM),
                promise_loadViewerAPIData(viewAPIDataAllAppCaps),
                promise_loadViewerAPIData(viewAPIDataAllAppPie),
                
                promise_loadViewerAPIData(viewAPIDataTRM),
                promise_loadViewerAPIData(viewAPIDataAllTechCaps),				
				promise_loadViewerAPIData(viewAPIDataAllTechPie)										

            ])
            .then(function(responses) {

                viewAPIData = responses[0];	  //Bus Cap Hierarchy			
				businessUnits = responses[1];
                busCapDetails = responses[2].business_capabilities;
                $("#bcm").html(bcmTemplate(viewAPIData.bcm[0])).promise().done(function(){
                
                	busCapstoShow = busCapDetails;
                	formatBusCapModel(busCapstoShow);
                	
                	$('#busOverlayDup').click(function() {                  
	                    duplicateBusCapModel(busCapstoShow);
	                });
	                
	                $('#busOverlayNone').click(function() {	
	                    formatBusCapModel(busCapstoShow);
	                });
	                
	                setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');	

	                //Initial Overlay
	                setBusUnits();
                });
                
                appStakeholders = responses[3];
                viewAPIDataAPM = responses[4];
                appCapDetails = responses[5].application_capabilities;
                appPieData=responses[6];
                $("#appRefModelContainer").html(armTemplate(viewAPIDataAPM.arm[0])).promise().done(function(){
                
                	appCapstoShow = appCapDetails;;
	                appPieDatatoShow = appPieData;
	                formatAppCapModel(appCapstoShow);
	                formatAppPieCharts(appPieData);
	                
	                $('#appOverlayDup').click(function() {                   
	                    duplicateAppCapModel(appCapstoShow);
	                });
	                
	                $('#appOverlayNone').click(function() {	
	                    formatAppCapModel(appCapstoShow);
	                });
                });
                
                
                viewAPIDataTRM = responses[7];
                techCapDetails = responses[8];			    
				techPieData=responses[9];
                
                $("#techRefModelContainer").html(trmTemplate(viewAPIDataTRM.trm[0])).promise().done(function(){
                	
                	techCapstoShow = techCapDetails;				
					techPieDatatoShow = techPieData                      
	                formatTechCapModel(techCapstoShow)							
	 				formatTechPieCharts(techPieData);
                	
                	$('#techOverlayDup').click(function() {
	                    duplicateTechCapModel(techCapstoShow);
	                });
	                
	                $('#techOverlayNone').click(function() {	
	                    formatTechCapModel(techCapstoShow);
	                });			
                });
                
                //$(detailTableBodyId).html(techDetailTemplate(techCompDetailList));	

                
 
                
				// filters					
               
				<!-\-$('.fa-info-circle').click(function() {
					console.log('Clicked on icon');
                    $('[role="tooltip"]').remove();
                    return false;
                });
                
                $('.fa-info-circle').popover({
                    container: 'body',
                    html: true,
                    sanitize: false,
                    trigger: 'click',
                    content: function() {
                        return $(this).next().html();
                    }
                });-\->


            })
            .then(function() {
            	$('.fa-info-circle').click(function() {
                    $('[role="tooltip"]').remove();
                    return false;
                });
                
                $('.fa-info-circle').popover({
                    container: 'body',
                    html: true,
                    sanitize: false,
                    trigger: 'click',
                    content: function() {
                        return $(this).next().html();
                    }
                });
            })
            .catch(function(error) {
                //display an error somewhere on the page   
            });-->
			                      
 <!--
			                        $('.matchHeight2').matchHeight();
			                        $('.matchHeightTRM').matchHeight();




			    
							
	function setTechCapabilityOverlayNew() {
			var thisTechCapBlobId, thisTechCapId, thisTechCap;
			
			var techOverlay = $('input:radio[name=techOverlay]:checked').val();
			if(techOverlay =='none') {
				//show the basic overlay legend
				$("#trmLegend").html(noOverlayTRMLegend);
			} else {
				//show rag overlay legend
				$("#trmLegend").html(ragOverlayLegend);
			}
			
			$('.techRefModel-blob').each(function() {
				thisTechCapBlobId = $(this).attr('id');
				thisTechCapId = thisTechCapBlobId.substring(0, (thisTechCapBlobId.length - 5));
				thisTechCap = getObjectById(techCapDetails, "id", thisTechCapId);

				refreshTRMDetailPopupNew(thisTechCap);
			});
		
		}
		
--> 
							
					
		});	
							
								  	
						</script>

						

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
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
				<div class="row">
					<div class="col-xs-6 bottom-15" id="bcmLegend">
						<div class="keyTitle">Legend:</div>
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide bg-brightgreen-120"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide bg-darkgrey"/>
						<div class="keyLabel">Undefined</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayNone" value="none" checked="checked" />Application Support</label>
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayDup" value="duplication" />Duplication</label>
						
						</div>
					</div>
					<xsl:call-template name="busCapModelInclude"/>
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
		<xsl:call-template name="appRefModelInclude"/>
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Application Perspective</h2>
				<div class="row">
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
						<div class="keySampleWide bg-brightgreen-120"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide bg-darkgrey"/>
						<div class="keyLabel">Undefined</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayNone" value="none" checked="checked" />Footprint</label>
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayDup" value="duplication" />Duplication</label>
							<!--<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>-->
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
		<xsl:call-template name="techRefModelInclude"/>
		<script>
			$(document).ready(function() {
			 	$('.matchHeight1').matchHeight();
			});
		</script>
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Technology Perspective</h2>
				<div class="row">
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
						<div class="keySampleWide bg-darkgrey"/>
						<div class="keyLabel">Undefined</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayNone" value="none" checked="checked" />Footprint</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayDup" value="duplication"/>Duplication</label>
						<!--	<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status"/>Legacy Risk</label>-->
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
        <xsl:param name="viewerAPIPath"/>
        <xsl:param name="viewerAPIPathAPM"/>
        <xsl:param name="viewerAPIPathTRM"/>
        <xsl:param name="viewerAPIPathAppStakeholders"/>
        <xsl:param name="viewerAPIPathTechStakeholders"/>
        <xsl:param name="viewerAPIPathAllApps"/>
        <xsl:param name="viewerAPIPathAllTechProds"/>
        <xsl:param name="viewerAPIPathAllAppCaps"/>
        <xsl:param name="viewerAPIPathAllTechCaps"/>
        <xsl:param name="viewerAPIPathAllBusUnits"/>
		<xsl:param name="viewerAPIPathAllTPRs"/>
		<xsl:param name="viewerAPIPathAllBusCapDetails"/>
		<xsl:param name="viewerAPIPathAllAppPie"/>
		<xsl:param name="viewerAPIPathAllTechPie"/>
		
		
		
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
        var viewAPIDataAPM = '<xsl:value-of select="$viewerAPIPathAPM"/>';
        var viewAPIDataTRM = '<xsl:value-of select="$viewerAPIPathTRM"/>';
        var viewAPIDataAppStakeholders = '<xsl:value-of select="$viewerAPIPathAppStakeholders"/>';
        var viewAPIDataTechStakeholders = '<xsl:value-of select="$viewerAPIPathTechStakeholders"/>';
        var viewAPIDataAllApps = '<xsl:value-of select="$viewerAPIPathAllApps"/>';
        var viewAPIDataTechProds = '<xsl:value-of select="$viewerAPIPathAllTechProds"/>';
        var viewAPIDataAllAppCaps =  '<xsl:value-of select="$viewerAPIPathAllAppCaps"/>';
        var viewAPIDataAllTechCaps =  '<xsl:value-of select="$viewerAPIPathAllTechCaps"/>';
        var viewAPIDataAllBusUnits =  '<xsl:value-of select="$viewerAPIPathAllBusUnits"/>';
		var viewAPIDataAllTPRs =  '<xsl:value-of select="$viewerAPIPathAllTPRs"/>';
		var viewAPIDataAllBusCapDetails =  '<xsl:value-of select="$viewerAPIPathAllBusCapDetails"/>';
		var viewAPIDataAllAppPie =  '<xsl:value-of select="$viewerAPIPathAllAppPie"/>';
		var viewAPIDataAllTechPie =  '<xsl:value-of select="$viewerAPIPathAllTechPie"/>';
		
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
        
        
        
        
        $('document').ready(function () {
        
      <!--      //OPTON 1: Call the API request function multiple times (once for each required API Report), then render the view based on the returned data
            Promise.all([
                promise_loadViewerAPIData(apiUrl1),
                promise_loadViewerAPIData(apiUrl2)
            ])
            .then(function(responses) {
                //after the data is retrieved, set the global variable for the dataset and render the view elements from the returned JSON data (e.g. via handlebars templates)
                viewAPIData = responses[0];
                //render the view elements from the first API Report
                anotherAPIData = responses[1];
                //render the view elements from the second API Report
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
            
          -->
        
           
            
    /*    $('#click').click(function(){
        
        promise_loadViewerAPIData(viewAPIDataDM)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                viewAPIData2 = response1;
                 //DO HTML stuff
              

            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
        }
       
        ); */
        
        
        });
        
    </xsl:template>
</xsl:stylesheet>
