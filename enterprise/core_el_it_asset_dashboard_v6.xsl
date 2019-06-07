<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Service', 'Application_Provider', 'Technology_Capability', 'Technology_Component')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
	

	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>

	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')]"/>
	<xsl:variable name="allAppCodebases" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = $allApps/name]"/>
	
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
	
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[name = $allTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	
	<!--<xsl:variable name="techProdDeliveryTaxonomy" select="/node()/simple_instance[(type='Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Technology Product Delivery Types')]"/>-->
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[name = $allTechProds/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
	
	<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
	<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
	
	<xsl:variable name="allBusinessUnits" select="/node()/simple_instance[name = ($appOrgUser2Roles, $techOrgUser2Roles)/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allBusinessUnitOffices" select="/node()/simple_instance[name = $allBusinessUnits/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeGeoRegions" select="/node()/simple_instance[name = $allBusinessUnitOffices/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeLocations" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
	<xsl:variable name="allBusinessUnitLocationCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_locations']/value = $allBusinessUnitOfficeLocations/name]"/>
	<xsl:variable name="allBusinessUnitOfficeCountries" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
	<xsl:variable name="allBusinessUnitCountries" select="$allBusinessUnitLocationCountries union $allBusinessUnitOfficeCountries"/>
	
	
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="L1BusCaps" select="$allBusCaps[name = $L0BusCaps/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	
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
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>IT Asset Dashboard</title>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"/>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js" type="text/javascript"/>
				<script language="javascript" type="text/javascript" src="js/jqplot/jquery.jqplot.min.js"/>
				<link rel="stylesheet" type="text/css" href="js/jqplot/jquery.jqplot.css"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.pieRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.barRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.categoryAxisRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.pointLabels.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.enhancedLegendRenderer.min.js"/>
				<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				
				<xsl:call-template name="RenderInitDataScopeMap"/>
				<xsl:call-template name="refModelLegendInclude"/>
				
				<script type="text/javascript">
					
					var appCodebasePie, appDeliveryModelPie, techProdStatusPie, techProdDeliveryPie, bcmDetailTemplate, appDetailTemplate, techDetailTemplate, ragOverlayLegend, noOverlayBCMLegend, noOverlayARMLegend, noOverlayTRMLegend;
					
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
					
					// the list of JSON objects representing the business units pf the enterprise
				  	var businessUnits = {
							businessUnits: [<xsl:apply-templates select="$allBusinessUnits" mode="getBusinessUnits"/>
				    	]
				  	};
				  	
				  	// the list of JSON objects representing the applications in use across the enterprise
				  	var applications = {
						applications: [<xsl:apply-templates select="$allApps" mode="getApplications"/>
				    	]
				  	};
				  	
				  	// the list of JSON objects representing the technology products in use across the enterprise
				  	var techProducts = {
						techProducts: [     <xsl:apply-templates select="$allTechProds" mode="getTechProducts"/>
				    	]
				  	};
				  	
				  	// the JSON objects for the Business Capability Model (BCM)
				  	var bcmData = <xsl:call-template name="RenderBCMData"/>;
					
					// the JSON objects for the Application Reference Model (ARM)
				  	var armData = {
				  		left: [
				  			<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderAppCaps"/>
				  		],
				  		middle: [
				  			<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderAppCaps"/>
				  		],
				  		right: [
				  			<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderAppCaps"/>
				  		],
				  	
				  	};
					
					// the JSON objects for the Technology Reference Model (TRM)
				  	var trmData = {
				  		top: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		left: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		middle: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		right: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderTechDomains"/>
				  		],
				  		bottom: [
				  			<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name]" mode="RenderTechDomains"/>
				  		]
				  	};
				  	
				  	
				  	// the JSON objects for the Application Services and Applications that support Business Capabilities
				  	var busCapDetails = [
				  		<xsl:apply-templates select="$L1BusCaps" mode="BusCapDetails"/>
				  	];
				  	
				  	// the JSON objects for the Application Services and Applications that implement Application Capabilities
				  	var appCapDetails = [
				  		<xsl:apply-templates select="$L1AppCaps" mode="AppCapDetails"/>
				  	];
				  	
				  	
					// the JSON objects for the Technology Components and Products that implement Technology Capabilities
				  	var techCapDetails = [
				  		<xsl:apply-templates select="$allTechCaps" mode="TechCapDetails"/>
				  	];
				  	
				  	
				  	
				  	
				  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
										
					<xsl:call-template name="RenderJavascriptScopingFunctions"/>
					
					<xsl:call-template name="RenderGeographicMapJSFunctions"/>
					
					
					
					
					<!-- START PAGE DRAWING FUNCTIONS -->
					//function to draw the relevant dashboard components based on the currently selected Data Objects
					function drawDashboard() {
						
						//Update the Geographic Scope map
						setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');

						//Update the BCM Model
						setBusCapabilityOverlay();
						
						//Update the ARM Model
						setAppCapabilityOverlay();
						
						//Set the Application Codebase pie chart values
						setPieChartValues(appCodebasePie, appCodebases, selectedApps, "codebase");
						
						//Set the Application Delivery Model pie chart values
						setPieChartValues(appDeliveryModelPie, appDeliveryModels, selectedApps, "delivery");
						
						//Update the TRM Model
						setTechCapabilityOverlay();
						
						//Set the Technology Lifecycle Status pie chart values
						setPieChartValues(techProdStatusPie, lifecycleStatii, selectedTechProds, "status");
						
						//Set the Technology Delivery Model pie chart values
						setPieChartValues(techProdDeliveryPie, techDeliveryModels, selectedTechProds, "delivery");

					}
					
					
					//Function to set values for a pie chart based on properties that contain a specific value
					function setPieChartValues(pieChart, segments, objectList, propertyName) {
						var pieData = [];
						var currentSegment;
						var objectsForSegment;
						var currentData;
						
						for (var i = 0; segments.length > i; i += 1) {
							currentData = [];
							currentSegment = segments[i];
							objectsForSegment = getObjectsMatchingVal(objectList, propertyName, currentSegment.id);
							currentData[0] = currentSegment.name + ' [' + objectsForSegment.length + ']';
							currentData[1] = objectsForSegment.length;
							pieData.push(currentData);
							console.log("Count of " + propertyName + " for " + currentSegment.name + ": " + currentData[1]);
						};
						
						var unknownObjects = getObjectsMatchingVal(objectList, propertyName, '');
						currentData = [];
						currentData[0] = 'Unknown [' + unknownObjects.length + ']';
						currentData[1] = unknownObjects.length;
						pieData.push(currentData);

						pieChart.series[0].data = pieData;
						pieChart.replot();					
					}
					
					
					
					$(document).ready(function(){	
					
						$('h2').click(function(){
							$(this).next().slideToggle();
						});
						
						//INITIALISE THE SCOPING DROP DOWN LIST
						$('#busUnitList').select2({
							placeholder: "All",
							allowClear: true
						});
						
						//INITIALISE THE PAGE WIDE SCOPING VARIABLES					
						allBusUnitIDs = getObjectIds(businessUnits.businessUnits, 'id');
						selectedBusUnitIDs = [];
						selectedBusUnits = [];
						setCurrentApps();
						setCurrentTechProds();
						
						
						<!--$.fn.select2.defaults.set("placeholder", "All");
						$.fn.select2.defaults.set("allowClear", true);
						$('#dataObjectList').select2({
							placeholder: "All",
							allowClear: true
						});-->
						
						$('#busUnitList').on('change', function (evt) {
						  var thisBusUnitIDs = $(this).select2("val");
						  console.log("Select BUs: " + selectedBusUnitIDs);
						  
						  if(thisBusUnitIDs != null) {
						  	setCurrentBusUnits(thisBusUnitIDs);
						  } else {
						  	selectedBusUnitIDs = [];
						  	selectedBusUnits = [];
						  	setCurrentApps();
						  	setCurrentTechProds();
						  }
						  drawDashboard();
						  //console.log("Select BUs: " + selectedBusUnitIDs);
					
						});
						
						<!--
						//Initialise the Codebase Pie Chart
						var appCodeBaseColours = [];
						for (var i = 0; codebases.length > i; i += 1) {
							appCodeBaseColours.push(codebases[i].colour)
						};
						
						var appCodeBaseTempData = [];
						var appCodeBaseEntry;
						for (var i = 0; codebases.length > i; i += 1) {
							appCodeBaseEntry = [];
							appCodeBaseEntry[0] = codebases[i].name;
							appCodeBaseEntry[1] = codebases[i].colour;
							appCodeBaseTempData.push(appCodeBaseEntry);
						};
						
						appCodebasePie = jQuery.jqplot ('pieChart2',[appCodeBaseTempData], {
							
							seriesColors: appCodeBaseColours,
							legend: {
								renderer: jQuery.jqplot.EnhancedLegendRenderer,
								show: true,
								location: 'e',
								rendererOptions: {
								   fontSize: "0.65em",
								   textColor: 'red'
								 }
							},
							grid: {
								drawGridLines: false,
								shadow: false,
								background: 'transparent',
								borderColor: '#999999',
								borderWidth: 0
							},
							seriesDefaults: {
								// Make this a pie chart.
								renderer: jQuery.jqplot.PieRenderer,
								rendererOptions: {
									// Put data labels on the pie slices.
									// By default, labels show the percentage of the slice.
									showDataLabels: true,
									padding: 5,
									dataLabels: 'percent'
								}
							}
						});
						-->
						
						var busUnitSelectFragment   = $("#bus-unit-select-template").html();
						var busUnitSelectTemplate = Handlebars.compile(busUnitSelectFragment);
						$("#busUnitList").html(busUnitSelectTemplate(businessUnits));
						
						
						<!-- SET UP THE REF MODEL LEGENDS -->
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
						
						
						<!-- SET UP THE BCM MODEL -->
						//initialise the BCM model
						var bcmFragment   = $("#bcm-template").html();
						var bcmTemplate = Handlebars.compile(bcmFragment);
						$("#bcm").html(bcmTemplate(bcmData));
						
						var bcmDetailFragment = $("#bcm-buscap-popup-template").html();
						bcmDetailTemplate = Handlebars.compile(bcmDetailFragment);
						
						<!-- SET UP THE ARM MODEL -->
						//Initialise the App Codebase Pie Chart
						var codebaseColours = [];
						for (var i = 0; appCodebases.length > i; i += 1) {
							codebaseColours.push(appCodebases[i].colour)
						};
						codebaseColours.push('lightgray');
						
						var codebaseTempData = [];
						var codebaseEntry;
						for (var i = 0; appCodebases.length > i; i += 1) {
							codebaseEntry = [];
							codebaseEntry[0] = appCodebases[i].name;
							codebaseEntry[1] = appCodebases[i].colour;
							codebaseTempData.push(codebaseEntry);
						};
						codebaseTempData.push(['Unknown', 'lightgray']);

						
						appCodebasePie = jQuery.jqplot ('appCodebasePieChart',[codebaseTempData], {
							
							seriesColors: codebaseColours,
							legend: {
								renderer: jQuery.jqplot.EnhancedLegendRenderer,
								show: true,
								location: 'e',
								rendererOptions: {
								   fontSize: "0.65em",
								   textColor: 'red'
								 }
							},
							grid: {
								drawGridLines: false,
								shadow: false,
								background: 'transparent',
								borderColor: '#999999',
								borderWidth: 0
							},
							seriesDefaults: {
								// Make this a pie chart.
								renderer: jQuery.jqplot.PieRenderer,
								rendererOptions: {
									// Put data labels on the pie slices.
									// By default, labels show the percentage of the slice.
									showDataLabels: true,
									padding: 5,
									dataLabels: 'percent'
								}
							}
						});
						
						
						//Initialise the App Delivery Model Pie Chart
						var appDeliveryColours = [];
						for (var i = 0; appDeliveryModels.length > i; i += 1) {
							appDeliveryColours.push(appDeliveryModels[i].colour)
						};
						appDeliveryColours.push('lightgray');
						
						var appDeliveryTempData = [];
						var appDeliveryEntry;
						for (var i = 0; appDeliveryModels.length > i; i += 1) {
							appDeliveryEntry = [];
							appDeliveryEntry[0] = appDeliveryModels[i].name;
							appDeliveryEntry[1] = appDeliveryModels[i].colour;
							appDeliveryTempData.push(appDeliveryEntry);
						};
						appDeliveryTempData.push(['Unknown', 'lightgray']);

						
						appDeliveryModelPie = jQuery.jqplot ('appDeliveryModelPieChart',[appDeliveryTempData], {
							
							seriesColors: appDeliveryColours,
							legend: {
								renderer: jQuery.jqplot.EnhancedLegendRenderer,
								show: true,
								location: 'e',
								rendererOptions: {
								   fontSize: "0.65em",
								   textColor: 'red'
								 }
							},
							grid: {
								drawGridLines: false,
								shadow: false,
								background: 'transparent',
								borderColor: '#999999',
								borderWidth: 0
							},
							seriesDefaults: {
								// Make this a pie chart.
								renderer: jQuery.jqplot.PieRenderer,
								rendererOptions: {
									// Put data labels on the pie slices.
									// By default, labels show the percentage of the slice.
									showDataLabels: true,
									padding: 5,
									dataLabels: 'percent'
								}
							}
						});
					
					
						//initialise the ARM model
						var armFragment   = $("#arm-template").html();
						var armTemplate = Handlebars.compile(armFragment);
						$("#appRefModelContainer").html(armTemplate(armData));
						
						var appDetailFragment = $("#arm-appcap-popup-template").html();
						appDetailTemplate = Handlebars.compile(appDetailFragment);
						
						
						
						
						<!-- SET UP THE TRM MODEL -->
						//Initialise the Tech Product Lifecycle Status Pie Chart
						var lifecycleColours = [];
						for (var i = 0; lifecycleStatii.length > i; i += 1) {
							lifecycleColours.push(lifecycleStatii[i].colour)
						};
						lifecycleColours.push('lightgray');
						
						var statusTempData = [];
						var statusEntry;
						for (var i = 0; lifecycleStatii.length > i; i += 1) {
							statusEntry = [];
							statusEntry[0] = lifecycleStatii[i].name;
							statusEntry[1] = lifecycleStatii[i].colour;
							statusTempData.push(statusEntry);
						};
						statusTempData.push(['Unknown', 'lightgray']);
						
						//console.log('Status Colours: ' + statusTempData);
						
						techProdStatusPie = jQuery.jqplot ('techProdStatusPieChart',[statusTempData], {
							
							seriesColors: lifecycleColours,
							legend: {
								renderer: jQuery.jqplot.EnhancedLegendRenderer,
								show: true,
								location: 'e',
								rendererOptions: {
								   fontSize: "0.65em",
								   textColor: 'red'
								 }
							},
							grid: {
								drawGridLines: false,
								shadow: false,
								background: 'transparent',
								borderColor: '#999999',
								borderWidth: 0
							},
							seriesDefaults: {
								// Make this a pie chart.
								renderer: jQuery.jqplot.PieRenderer,
								rendererOptions: {
									// Put data labels on the pie slices.
									// By default, labels show the percentage of the slice.
									showDataLabels: true,
									padding: 5,
									dataLabels: 'percent'
								}
							}
						});
						
						
						//Initialise the Tech Product Delivery Model Pie Chart
						var techDeliveryColours = [];
						for (var i = 0; techDeliveryModels.length > i; i += 1) {
							techDeliveryColours.push(techDeliveryModels[i].colour)
						};
						techDeliveryColours.push('lightgray');
						
						var techDeliveryTempData = [];
						var techDeliveryEntry;
						for (var i = 0; techDeliveryModels.length > i; i += 1) {
							techDeliveryEntry = [];
							techDeliveryEntry[0] = techDeliveryModels[i].name;
							techDeliveryEntry[1] = techDeliveryModels[i].colour;
							techDeliveryTempData.push(techDeliveryEntry);
						};
						techDeliveryTempData.push(['Unknown', 'lightgray']);
						
						//console.log('Delivery Colours: ' + statusTempData);
						
						techProdDeliveryPie = jQuery.jqplot ('techProdDeliveryPieChart',[techDeliveryTempData], {
							
							seriesColors: techDeliveryColours,
							legend: {
								renderer: jQuery.jqplot.EnhancedLegendRenderer,
								show: true,
								location: 'e',
								rendererOptions: {
								   fontSize: "0.65em",
								   textColor: 'red'
								 }
							},
							grid: {
								drawGridLines: false,
								shadow: false,
								background: 'transparent',
								borderColor: '#999999',
								borderWidth: 0
							},
							seriesDefaults: {
								// Make this a pie chart.
								renderer: jQuery.jqplot.PieRenderer,
								rendererOptions: {
									// Put data labels on the pie slices.
									// By default, labels show the percentage of the slice.
									showDataLabels: true,
									padding: 5,
									dataLabels: 'percent'
								}
							}
						});
						
						
						//initialise the TRM model
						var trmFragment   = $("#trm-template").html();
						var trmTemplate = Handlebars.compile(trmFragment);
						$("#techRefModelContainer").html(trmTemplate(trmData));
						$('.matchHeight2').matchHeight();
			 			$('.matchHeightTRM').matchHeight();
			 			
			 			var techDetailFragment = $("#trm-techcap-popup-template").html();
						techDetailTemplate = Handlebars.compile(techDetailFragment);
						
						drawDashboard();
					});
								  	
				</script>
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


						<xsl:call-template name="RenderDashboardBusUnitFilter"/>
						<xsl:call-template name="scopeMap"/>
						<!--<xsl:call-template name="investmentProfilePie"/>-->
						<xsl:call-template name="busSection"/>
						<xsl:call-template name="appSection"/>
						<xsl:call-template name="techSection"/>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
						
						$('.fa-info-circle').click(function() {
							$('[role="tooltip"]').remove();
							return false;
						});
						$('.fa-info-circle').popover({
							container: 'body',
							html: true,
							trigger: 'click',
							content: function(){
								return $(this).next().html();
							}
						});
						
					});
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
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayNone" value="none" checked="checked" onchange="setBusCapabilityOverlay()"/>None</label>
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayDup" value="duplication" onchange="setBusCapabilityOverlay()"/>Duplication</label>
							<!--<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>-->
						</div>
					</div>
					<xsl:call-template name="busCapModelInclude"/>
					<div class="col-xs-12" id="bcm">
						<!--<h3><xsl:value-of select="$rootBusCap/own_slot_value[slot_reference = 'name']/value"/> Capabilities</h3>
						<xsl:for-each select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]">
							<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
							<xsl:variable name="subCaps" select="$allBusCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
							<div class="row">
								<div class="col-xs-12">
									<div class="refModel-l0-outer bg-darkblue-40">
										<div class="refModel-l0-title fontBlack large">
											<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
										</div>
										<xsl:for-each select="$subCaps">
											<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
											<a href="#" class="text-default">
												<div class="refModel-blob">
													<div class="refModel-blob-title">
														<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
													</div>
													<div class="refModel-blob-info">
														<i class="fa fa-info-circle text-darkgrey"/>
														<div class="hiddenDiv">Popover Content Here</div>
													</div>
												</div>
											</a>

										</xsl:for-each>
										<div class="clearfix"/>
									</div>
									<xsl:if test="position() != last()">
										<div class="clearfix bottom-10"/>
									</xsl:if>
								</div>
							</div>
						</xsl:for-each>-->
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
						<div class="pieChartContainer">
							<div class="pieChart" id="appCodebasePieChart"/>
						</div>
					</div>
					<div class="col-xs-6 col-lg-6">
						<h3 class="text-primary">Delivery Model</h3>
						<div class="pieChartContainer">
							<div class="pieChart" id="appDeliveryModelPieChart"/>
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
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayNone" value="none" checked="checked" onchange="setAppCapabilityOverlay()"/>None</label>
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayDup" value="duplication" onchange="setAppCapabilityOverlay()"/>Duplication</label>
							<!--<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>-->
						</div>
					</div>
					<div class="simple-scroller" id="appRefModelContainer">
						<!--<div class="col-xs-4 col-md-3 col-lg-2" id="refLeftCol">
							<xsl:for-each select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]">
								<xsl:variable name="subAppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'contained_in_application_capability']/value = current()/name]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-aqua-40 matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$subAppCaps">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<div class="col-xs-4 col-md-6 col-lg-8 matchHeight1" id="refCenterCol">
							<xsl:for-each select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]">
								<xsl:variable name="subAppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'contained_in_application_capability']/value = current()/name]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-aqua-40">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$subAppCaps">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
										<xsl:if test="position() != last()">
											<div class="clearfix bottom-10"/>
										</xsl:if>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<div class="col-xs-4 col-md-3 col-lg-2" id="refRightCol">
							<xsl:for-each select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]">
								<xsl:variable name="subAppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'contained_in_application_capability']/value = current()/name]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-aqua-40 matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$subAppCaps">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							</xsl:for-each>
						</div>-->
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
						<!--<script type="text/javascript">
							$(document).ready(function () {
								var data =[['General Release', 701500],['Beta', 6.483E6],['Extended Support', 961297],['Out of Support', 2.2965E6]];
								var plot1 = jQuery.jqplot ('pieChart3',[data], {
					
					
									seriesColors:["#4196D9","#9B53B3","#EEC62A","#E37F2C","#1FA185"],
									legend: {
										renderer: jQuery.jqplot.EnhancedLegendRenderer,
										show: true,
										location: 'e',
										rendererOptions: {
										   fontSize: "0.65em",
										   textColor: 'white'
										 }
									},
									grid: {
										drawGridLines: false,
										shadow: false,
										background: 'transparent',
										borderColor: '#999999',
										borderWidth: 0
									},
									seriesDefaults: {
										// Make this a pie chart.
										renderer: jQuery.jqplot.PieRenderer,
										rendererOptions: {
											// Put data labels on the pie slices.
											// By default, labels show the percentage of the slice.
											showDataLabels: true,
											padding: 5,
											dataLabels: 'percent'
										}
									}
								});
							});
						</script>-->
						
						
						<h3 class="text-primary">Product Release Status</h3>
						<div class="pieChartContainer">
							<div class="pieChart" id="techProdStatusPieChart"/>
						</div>
					</div>
					<div class="col-xs-6 col-lg-6">
						<h3 class="text-primary">Delivery Model</h3>
						<div class="pieChartContainer">
							<div class="pieChart" id="techProdDeliveryPieChart"/>
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
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayNone" value="none" checked="checked" onchange="setTechCapabilityOverlay()"/>None</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayDup" value="duplication" onchange="setTechCapabilityOverlay()"/>Duplication</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>
						</div>
					</div>
					<div class="simple-scroller" id="techRefModelContainer">
						<!--<!-\-Top-\->
						<div class="col-xs-12">
							<xsl:for-each select="$allTechDomains[position() = 7]">
								<xsl:variable name="capsForDomain" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-lightblue-40 matchHeight2">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$capsForDomain">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
									</div>
								</div>
								<div class="clearfix bottom-10"/>
							</xsl:for-each>
						</div>
						<!-\-Ends-\->
						<!-\-Left-\->
						<div class="col-xs-4 col-md-3 col-lg-2">
							<xsl:for-each select="$allTechDomains[position() = 6]">
								<xsl:variable name="capsForDomain" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-lightblue-40 matchHeight2">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$capsForDomain">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<!-\-ends-\->
						<!-\-Center-\->
						<div class="col-xs-4 col-md-6 col-lg-8 matchHeight2">
							<xsl:for-each select="$allTechDomains[position() &lt; 6]">
								<xsl:variable name="capsForDomain" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-lightblue-40">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$capsForDomain">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
										<xsl:if test="position() != last()">
											<div class="clearfix bottom-10"/>
										</xsl:if>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<!-\-ends-\->
						<!-\-Right-\->
						<div class="col-xs-4 col-md-3 col-lg-2">
							<xsl:for-each select="$allTechDomains[position() = 8]">
								<xsl:variable name="capsForDomain" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-lightblue-40 matchHeight2">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$capsForDomain">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<!-\-ends-\->
						<!-\-Bottom-\->
						<div class="col-xs-12">
							<div class="clearfix bottom-10"/>
							<xsl:for-each select="$allTechDomains[position() = 9]">
								<xsl:variable name="capsForDomain" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer bg-lightblue-40 matchHeight2">
											<div class="refModel-l0-title fontBlack large">
												<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
											</div>
											<xsl:for-each select="$capsForDomain">
												<a href="#" class="text-default">
													<div class="refModel-blob">
														<div class="refModel-blob-title">
															<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
														</div>
														<div class="refModel-blob-info">
															<i class="fa fa-info-circle text-darkgrey"/>
															<div class="hiddenDiv">Popover Content Here</div>
														</div>
													</div>
												</a>
											</xsl:for-each>
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<!-\-Ends-\->-->
					</div>
				</div>
			</div>
		</div>
		<script>
			$(document).ready(function() {
			 	
			});
		</script>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getBusinessUnits">
		<xsl:variable name="thisBusinessUnitOffice" select="$allBusinessUnitOffices[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="thisBusinessUnitOfficeGeoRegions" select="$allBusinessUnitOfficeGeoRegions[name = $thisBusinessUnitOffice/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisBusinessUnitOfficeLocations" select="$thisBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
		<xsl:variable name="thisBusinessUnitLocationCountries" select="$allBusinessUnitLocationCountries[own_slot_value[slot_reference = 'gr_locations']/value = $thisBusinessUnitOfficeLocations/name]"/>
		<xsl:variable name="thisBusinessUnitOfficeCountries" select="$thisBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
		
		<xsl:variable name="thisBusinessUnitCountry" select="$thisBusinessUnitLocationCountries union $thisBusinessUnitOfficeCountries"/>
		<xsl:variable name="thisAppOrgUser2Roles" select="$appOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'stakeholders']/value = $thisAppOrgUser2Roles/name]"/>
		
		<xsl:variable name="thisTechProdOrgUser2Roles" select="$techOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="thisTechProdss" select="$allTechProds[own_slot_value[slot_reference = 'stakeholders']/value = $thisTechProdOrgUser2Roles/name]"/>
		<xsl:variable name="thisBusinessUnitName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusinessUnitDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>	
		
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisBusinessUnitName"/>",
			description: "<xsl:value-of select="$thisBusinessUnitDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			<!--country: "<xsl:value-of select="$thisBusinessUnitCountry/own_slot_value[slot_reference='gr_region_identifier']/value"/>",-->
			country: [<xsl:for-each select="$thisBusinessUnitCountry">"<xsl:value-of select="current()/own_slot_value[slot_reference='gr_region_identifier']/value"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
			apps: [<xsl:for-each select="$thisApps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
			techProds: [<xsl:for-each select="$thisTechProdss">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="getApplications">
		<xsl:variable name="thisAppCodebase" select="$allAppCodebases[name = current()/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
		<xsl:variable name="thisAppDeliveryModel" select="$allAppDeliveryModels[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
		<xsl:variable name="thisAppOrgUser2Roles" select="$appOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thsAppUsers" select="$allBusinessUnits[name = $thisAppOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisAppName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisAppDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>	
		
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisAppName"/>",
			description: "<xsl:value-of select="$thisAppDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			codebase: "<xsl:value-of select="translate($thisAppCodebase/name, '.', '_')"/>",
			delivery: "<xsl:value-of select="translate($thisAppDeliveryModel/name, '.', '_')"/>",
			appOrgUsers: [<xsl:for-each select="$thsAppUsers">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="getTechProducts">
		<xsl:variable name="thisTechOrgUser2Roles" select="$techOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thsTechUsers" select="$allBusinessUnits[name = $thisTechOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="theLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value]"/>
		<xsl:variable name="theDeliveryModel" select="$allTechProdDeliveryTypes[name = current()/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
		<xsl:variable name="theStatusScore" select="$theLifecycleStatus/own_slot_value[slot_reference = 'enumeration_score']/value"/>
		<xsl:variable name="thisTechProdName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisTechProdDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>	
		

		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisTechProdName"/>",
			description: "<xsl:value-of select="$thisTechProdDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			status: "<xsl:value-of select="translate($theLifecycleStatus/name, '.', '_')"/>",
			statusScore: <xsl:choose><xsl:when test="$theStatusScore > 0"><xsl:value-of select="$theStatusScore"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
			delivery: "<xsl:value-of select="translate($theDeliveryModel/name, '.', '_')"/>",
			techOrgUsers: [<xsl:for-each select="$thsTechUsers">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- BUSINESS CAPABILITY MODEL DATA TEMPLATES -->
	<xsl:template name="RenderBCMData">
		<xsl:variable name="rootBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$rootBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		<!--<xsl:variable name="L0Caps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"></xsl:variable>-->
		
		{
		l0BusCapId: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		l0BusCapName: "<xsl:value-of select="$rootBusCapName"/>",
		l0BusCapLink: "<xsl:value-of select="$rootBusCapLink"/>",
		l0BusCapDescription: "<xsl:value-of select="eas:renderJSText($rootBusCapDescription)"/>",
		l1BusCaps: [
		<xsl:apply-templates select="$L0BusCaps" mode="l0_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates>
		]
		}
		
	</xsl:template>
	
	<xsl:template match="node()" mode="l0_caps">
		<xsl:variable name="currentBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="currentBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="currentBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="L1Caps" select="$allBusCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		
		{
		busCapId: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		busCapName: "<xsl:value-of select="$currentBusCapName"/>",
		busCapDescription: "<xsl:value-of select="$currentBusCapDescription"/>",
		busCapLink: "<xsl:value-of select="$currentBusCapLink"/>",
		l2BusCaps: [	
		<xsl:apply-templates select="$L1Caps" mode="l1_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="l1_caps">
		<xsl:variable name="currentBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="currentBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="currentBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<!--<xsl:variable name="appCaps" select="$allAppCaps[own_slot_value[slot_reference = 'app_cap_supports_bus_cap']/value = current()/name]"/>
		<xsl:variable name="appServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $appCaps/name]"/>-->
		
		{
			busCapId: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			busCapName: "<xsl:value-of select="$currentBusCapName"/>",
			busCapLink: "<xsl:value-of select="$currentBusCapLink"/>",
			busCapDescription: "<xsl:value-of select="$currentBusCapDescription"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="BusCapDetails">
		<xsl:variable name="busCapDescendants" select="eas:get_object_descendants(current(), $allBusCaps, 0, 4, 'supports_business_capabilities')"/>
		<xsl:variable name="appCaps" select="$allAppCaps[own_slot_value[slot_reference = 'app_cap_supports_bus_cap']/value = $busCapDescendants/name]"/>
		<xsl:variable name="appServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $appCaps/name]"/>
		
		{
			busCapId: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			appServices: [	
				<xsl:apply-templates select="$appServices" mode="RenderAppServices"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<!-- APPLICATION REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderAppCaps" match="node()">
		<xsl:variable name="appCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$appCapName"/>",
		description: "<xsl:value-of select="$appCapDescription"/>",
		link: "<xsl:value-of select="$appCapLink"/>",
		childAppCaps: [
			<xsl:apply-templates select="$childAppCaps" mode="RenderChildAppCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildAppCaps">
		<xsl:variable name="appCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$appCapName"/>",
		link: "<xsl:value-of select="$appCapLink"/>",
		description: "<xsl:value-of select="$appCapDescription"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="AppCapDetails">
		<xsl:variable name="appServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			appServices: [	
				<xsl:apply-templates select="$appServices" mode="RenderAppServices"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderAppServices">
		<xsl:variable name="appServiceName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appSvcDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="appServiceLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = current()/name]"/>
		<xsl:variable name="thisApps" select="$allApps[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$appServiceName"/>",
		link: "<xsl:value-of select="$appServiceLink"/>",
		description: "<xsl:value-of select="$appSvcDescription"/>",
		apps: [<xsl:for-each select="$thisApps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="techDomainName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$techDomainName"/>",
		description: "<xsl:value-of select="$techDomainDescription"/>",
		link: "<xsl:value-of select="$techDomainLink"/>",
		childTechCaps: [
		<xsl:apply-templates select="$childTechCaps" mode="RenderChildTechCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildTechCaps">
		<xsl:variable name="techCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$techCapName"/>",
			link: "<xsl:value-of select="$techCapLink"/>",
			description: "<xsl:value-of select="$techCapDescription"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="TechCapDetails">
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			techComponents: [	
				<xsl:apply-templates select="$techComponents" mode="RenderTechComponents"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderTechComponents">
		<xsl:variable name="techCompName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techCompDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techCompLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
		<xsl:variable name="thisTechProds" select="$allTechProds[name = $thisTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$techCompName"/>",
		link: "<xsl:value-of select="$techCompLink"/>",
		description: "<xsl:value-of select="$techCompDescription"/>",
		techProds: [<xsl:for-each select="$thisTechProds">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>

</xsl:stylesheet>
