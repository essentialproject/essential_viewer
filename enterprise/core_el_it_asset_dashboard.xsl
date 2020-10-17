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
    <xsl:variable name="anAPIReportTRM" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Technology Capability Model API']"/>
    <xsl:variable name="anAPIReportAppStakeholders" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Application Stakeholders API']"/>
    <xsl:variable name="anAPIReportTechStakeholders" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Technology Stakeholders API']"/>
    <xsl:variable name="anAPIReportAllApps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application List']"/>
    <xsl:variable name="anAPIReportAllTechProducts" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Product List API']"/>
    <xsl:variable name="anAPIReportAllAppCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Application Capability L1 API']"/>
    <xsl:variable name="anAPIReportAllTechCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Technology Capability L1 API']"/>
    
    
	<!-- END GENERIC LINK VARIABLES -->
   
	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
	

	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = ('Reference Model Layout','Application Capability Category'))]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
<!-- fallback to old values if app caps missing -->
	<xsl:variable name="leftRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = ('Management','Foundation')]"/>
	<xsl:variable name="rightRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Enabling']"/>
	<xsl:variable name="middleRefLayerOld" select="$refLayers[own_slot_value[slot_reference = 'name']/value = ('Shared','Core')]"/>
 
    
    
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')]"/>
	<xsl:variable name="allAppCodebases" select="/node()/simple_instance[type = 'Codebase_Status']"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
	
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
    <xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
		
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>

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
	
	<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
	<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
	
	<xsl:variable name="allBusinessUnits" select="/node()/simple_instance[name = ($appOrgUser2Roles, $techOrgUser2Roles)/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allBusinessUnitOffices" select="/node()/simple_instance[name = $allBusinessUnits/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeGeoRegions" select="/node()/simple_instance[name = $allBusinessUnitOffices/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeLocations" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
	<xsl:variable name="allBusinessUnitLocationCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_locations']/value = $allBusinessUnitOfficeLocations/name]"/>
	<xsl:variable name="allBusinessUnitOfficeCountries" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
	<xsl:variable name="allBusinessUnitCountries" select="$allBusinessUnitLocationCountries union $allBusinessUnitOfficeCountries"/>
	
	
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="L1BusCaps" select="$allBusCaps[name = $L0BusCaps/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	
	<!-- ROADMAP VARIABLES 	-->
	<xsl:variable name="allRoadmapInstances" select="$allApps union $allTechProds"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/> 
    <!-- END ROADMAP VARIABLES -->
    
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Service', 'Application_Provider', 'Technology_Capability', 'Technology_Component'), $rmLinkTypes"/>
    
    
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
				<link rel="stylesheet" type="text/css" href="js/jqplot/jquery.jqplot.css"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.pieRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.barRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.categoryAxisRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.pointLabels.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.enhancedLegendRenderer.min.js"/>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
				
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
				<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<!-- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -->
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
					<div class="clearfix"></div>
				</div>

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
                            
                        </xsl:call-template>
                      
							var appCodebasePie, appDeliveryModelPie, techProdStatusPie, techProdDeliveryPie, bcmDetailTemplate, appDetailTemplate, techDetailTemplate, ragOverlayLegend, noOverlayBCMLegend, noOverlayARMLegend, noOverlayTRMLegend, stakeH, stakeHT,appCapDetails;
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
							
							// the list of JSON objects representing the business units pf the enterprise
						  	var businessUnits = {
                            businessUnits: [<xsl:apply-templates select="$allBusinessUnits" mode="getBusinessUnits"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"></xsl:sort></xsl:apply-templates>
						    	]
						  	};
                   
                            var tprsToTechProducts = [
                                <xsl:apply-templates select="$allTechProdRoles" mode="RenderTPRJSONList"/>
                            ];
                            
                          
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
 					  	
						
						  	
						  	// the JSON objects for the Application Services and Applications that support Business Capabilities
                       
					  	var busCapDetails = [
						  		<xsl:apply-templates select="$L1BusCaps" mode="BusCapDetails"/>
						  	];
	 						  	
						  	// the JSON objects for the Application Services and Applications that implement Application Capabilities
                                
                       
						  	var appCapDetails = [
						  		<xsl:apply-templates select="$L1AppCaps" mode="AppCapDetails"/>
						  	];
                            var techCapDetails = [];
				 
							// the JSON objects for the Technology Components and Products that implement Technology Capabilities
						  	var techCapDetails = [
						  		<xsl:apply-templates select="$allTechCaps" mode="TechCapDetails"/>
						  	];
        	          
				  	
						  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
												
							<xsl:call-template name="RenderJavascriptScopingFunctions"/>
							
							<xsl:call-template name="RenderGeographicMapJSFunctions"/>
								
							<!-- START PAGE DRAWING FUNCTIONS -->
							//function to scope the relevant elements in acordance with the current roadmap period
			function scopeDashboardRoadmapElements() {
			    if (roadmapEnabled) {
			        rmSetElementListRoadmapStatus([applications.applications, techProducts.techProducts]);
			    }

			    setCurrentTechProds();
			    setCurrentApps();

			    if (roadmapEnabled) {
			        var appsForRM = rmGetVisibleElements(selectedApps);
			        selectedApps = appsForRM;

			        var techProdsForRM = rmGetVisibleElements(selectedTechProds);
			        selectedTechProds = techProdsForRM;
			    }

			    selectedAppIDs = getObjectListPropertyVals(selectedApps, "id");
			    selectedTechProdIDs = getObjectListPropertyVals(selectedTechProds, "id");
			}


			//function to draw the relevant dashboard components based on the currently selected Data Objects
			function redrawView() {

			    //Hide any elements that are out of scope for the selected roadmap period
			    scopeDashboardRoadmapElements();

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
			        //console.log("Count of " + propertyName + " for " + currentSegment.name + ": " + currentData[1]);
			    };

			    var unknownObjects = getObjectsMatchingVal(objectList, propertyName, '');
			    currentData = [];
			    currentData[0] = 'Unknown [' + unknownObjects.length + ']';
			    currentData[1] = unknownObjects.length;
			    pieData.push(currentData);

			    pieChart.series[0].data = pieData;
			    pieChart.replot();

			}

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

			function setBusUnit() {
			    //INITIALISE THE SCOPING DROP DOWN LIST
			    $('#busUnitList').select2({
			        placeholder: "All",
			        allowClear: true
			    });

			    //INITIALISE THE PAGE WIDE SCOPING VARIABLES					
			    allBusUnitIDs = getObjectIds(businessUnits.businessUnits, 'id');
			    selectedBusUnitIDs = [];
			    selectedBusUnits = []; <!--setCurrentApps();
			    setCurrentTechProds();
			    -->


			    <!--$.fn.select2.defaults.set("placeholder", "All");
			    $.fn.select2.defaults.set("allowClear", true);
			    $('#dataObjectList').select2({
			        placeholder: "All",
			        allowClear: true
			    });
			    -->

			    $('#busUnitList').on('change', function(evt) {
			        var thisBusUnitIDs = $(this).select2("val");
			        
			        if (thisBusUnitIDs != null) {
			            setCurrentBusUnits(thisBusUnitIDs);
			        } else {
			            selectedBusUnitIDs = [];
			            selectedBusUnits = []; <!--setCurrentApps();
			            setCurrentTechProds();
			            -->
			        }
			        redrawView();
			        //console.log("Select BUs: " + selectedBusUnitIDs);

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


			$(document).ready(function() {
                setBusUnit();                 
			    promise_loadViewerAPIData(viewAPIData)
			        .then(function(response1) {
                            
			            //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
			            viewAPIData = response1;
           
			            var bcmFragment = $("#bcm-template").html();
			            var bcmTemplate = Handlebars.compile(bcmFragment);
			            $("#bcm").html(bcmTemplate(viewAPIData.bcm[0]));
console.log('bcm');  
			        }).then(function() {
                             promise_loadViewerAPIData(viewAPIDataAllAppCaps).then(function(response9) {
                            <!-- *** app caps API -->
                            appCapDetails2=response9.application_capabilities;
                            
                                promise_loadViewerAPIData(viewAPIDataAllTechCaps).then(function(response10) {
                            <!-- *** tech caps API -->
                                techCapDetails2=response10.technology_capabilities; 
                            console.log('techCapDetails2');      console.log(techCapDetails2); 
                            })
                            
                             
                            }).then(function() {

			            setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), 'country', 'hsla(200, 80%, 60%, 1)');
  console.log('bus overlay');  
			            setBusCapabilityOverlay();
			        }).then(function() {
                            <!-- application and technology fetch if required -->
			            <!-- promise_loadViewerAPIData(viewAPIDataAllApps).then(function(response7) {
			                  
			                 var applications = response7.applications;
			              
			                
			                promise_loadViewerAPIData(viewAPIDataTechProds).then(function(response8) {
                                var techProducts = response8  
			                }) 

			            })-->

			           
			            promise_loadViewerAPIData(viewAPIDataAPM).then(function(response2) {
			                viewAPIDataAPM = response2;
			                //DO HTML stuff
   console.log('viewAPIDataAPM');   console.log(viewAPIDataAPM);
			                var armFragment = $("#arm-template").html();
			                var armTemplate = Handlebars.compile(armFragment);
			                $("#appRefModelContainer").html(armTemplate(viewAPIDataAPM.arm[0]));


			            }).then(function() {
                            console.log('adf');
			                var appDetailFragment = $("#arm-appcap-popup-template").html();
			                appDetailTemplate = Handlebars.compile(appDetailFragment);
			            }).then(function() {

    console.log('app overlay');
			                setAppCapabilityOverlay();;
			            }).then(function() {
			                $('.match1').matchHeight();


			            }).then(function() {


			                promise_loadViewerAPIData(viewAPIDataTRM).then(function(response3) {
			                        viewAPIDataTRM = response3;
			                        //DO HTML stuff

      console.log('viewAPIDataTRM');      console.log('viewAPIDataTRM'); 
			                        var trmFragment = $("#trm-template").html();
			                        var trmTemplate = Handlebars.compile(trmFragment);

			                        $("#techRefModelContainer").html(trmTemplate(viewAPIDataTRM.trm[0]));

			                    }).then(function() {

			                        promise_loadViewerAPIData(viewAPIDataAppStakeholders).then(function(response4) {

			                            var appStakeholders = response4;

			                            stakeH = appStakeholders.appStakeholders;
        console.log('appStakeholders');      console.log(appStakeholders); 
			                            promise_loadViewerAPIData(viewAPIDataTechStakeholders).then(function(response5) {
			                                var techStakeholders = response5;
			                                var stakeHT = techStakeholders.techStakeholders;
			                                            console.log('techStakeholders');      console.log(techStakeholders); 
			                                for (var i = 0; i &lt; businessUnits.businessUnits.length; i++) {
			                                    var appList = [];
			                                    var techList = [];
			                                    for (var j = 0; j &lt; businessUnits.businessUnits[i].apps2.length; j++) {

			                                        var focus = businessUnits.businessUnits[i].apps2[j];

			                                        var thisapp = stakeH.filter(function(d) {

			                                            var thisapp = d.stakeholders.filter(function(e) {
			                                                if (e === focus) {
			                                                    appList.push(d.id)
			                                                }
			                                            })
			                                        })
			                                    }

			                                    for (var j = 0; j &lt; businessUnits.businessUnits[i].techProds2.length; j++) {

			                                        var focusT = businessUnits.businessUnits[i].techProds2[j];

			                                        var thistech = stakeHT.filter(function(d) {
			                                            var thistech = d.stakeholders.filter(function(e) {
			                                                if (e === focusT) {
			                                                    techList.push(d.id)
			                                                }
			                                            })
			                                        })
			                                    }

			                                    let uniqueT = [...new Set(techList)];
			                                    businessUnits.businessUnits[i]['techProds'] = uniqueT;

			                                    let unique = [...new Set(appList)];
			                                    businessUnits.businessUnits[i]['apps'] = unique;

			                                }

			                            });

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
			                        });

			                        $('.matchHeight2').matchHeight();
			                        $('.matchHeightTRM').matchHeight();

			                        var techDetailFragment = $("#trm-techcap-popup-template").html();
			                        techDetailTemplate = Handlebars.compile(techDetailFragment);

			                    }).then(function() {
			                        
			                        setTechCapabilityOverlay();
			                    }).then(function() {


			                        redrawView();
			                    })
			                    .catch(function(error) {
			                        //display an error somewhere on the page   
			                    });
			            }).catch(function(error) {
			                //display an error somewhere on the page   
			            })
                            
                            $('h2').click(function() {
			                $(this).next().slideToggle();
			            });     
                                
                            }).then(function(appCapDetails) {
                            console.log('appcap');
                        var tprs = tprsToTechProducts; 
                          
						   for(var i=0; i &lt; techCapDetails.length;i++) {
                             for(var k=0; k &lt; techCapDetails[i].techComponents.length;k++) {
                             tprList=[];
                               for(var j=0; j &lt; techCapDetails[i].techComponents[k].tprs.length;j++) {  
                                var focusTPR = techCapDetails[i].techComponents[k].tprs[j]; 
                            
                                  var thistpr = tprs.filter(function(d){
                                                if(d.id === focusTPR){  tprList.push(d.prodId)}
                                    })  
                              }
    
                              let uniqueTPR = [...new Set(tprList)];
                               
                               techCapDetails[i].techComponents[k]['techProds']=uniqueTPR;	
                               }
                            }
   console.log('tprs');      
                            
			            var bcmDetailFragment = $("#bcm-buscap-popup-template").html();
			            bcmDetailTemplate = Handlebars.compile(bcmDetailFragment);

			        })
			        ;

			        });

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

			    <!--SET UP THE TRM MODEL-->
			    //Initialise the Tech Product Lifecycle Status Pie Chart
			    var lifecycleColours = [];
			    for (var i = 0; lifecycleStatii.length > i; i += 1) {
			        if (lifecycleStatii[i].colour) {
			            lifecycleColours.push(lifecycleStatii[i].colour)
			        } else {
			            lifecycleColours.push('#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6))
			        }
			    };
			    lifecycleColours.push('lightgray');

			    var statusTempData = [];
			    var statusEntry;
			    for (var i = 0; lifecycleStatii.length > i; i += 1) {
			        statusEntry = [];
			        statusEntry[0] = lifecycleStatii[i].name;

			        if (lifecycleStatii[i].colour != '') {

			            statusEntry[1] = getPieColour(lifecycleStatii[i].colour);
			        } else {

			            statusEntry[1] = '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);

			        }
			        statusTempData.push(statusEntry);
			    };
			    statusTempData.push(['Unknown', 'lightgray']);

			    //console.log('Status Colours: ' + statusTempData);

			    techProdStatusPie = jQuery.jqplot('techProdStatusPieChart', [statusTempData], {

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
			        if (techDeliveryModels[i].colour != '#fff') {

			            techDeliveryColours.push(techDeliveryModels[i].colour)
			        } else {

			            techDeliveryColours.push('#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6));
			        }

			    };
			    techDeliveryColours.push('lightgray');

			    var techDeliveryTempData = [];
			    var techDeliveryEntry;
			    for (var i = 0; techDeliveryModels.length > i; i += 1) {
			        techDeliveryEntry = [];
			        techDeliveryEntry[0] = techDeliveryModels[i].name;
			        techDeliveryEntry[1] = getPieColour(techDeliveryModels[i].colour);
			        techDeliveryTempData.push(techDeliveryEntry);
			    };
			    techDeliveryTempData.push(['Unknown', 'lightgray']);

			    //console.log('Delivery Colours: ' + statusTempData);

			    techProdDeliveryPie = jQuery.jqplot('techProdDeliveryPieChart', [techDeliveryTempData], {

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

			    setLegend();
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
			        codebaseEntry[1] = getPieColour(appCodebases[i].colour);
			        codebaseTempData.push(codebaseEntry);
			    };
			    codebaseTempData.push(['Unknown', 'lightgray']);


			    appCodebasePie = jQuery.jqplot('appCodebasePieChart', [codebaseTempData], {

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
			        appDeliveryEntry[1] = getPieColour(appDeliveryModels[i].colour);
			        appDeliveryTempData.push(appDeliveryEntry);
			    };
			    appDeliveryTempData.push(['Unknown', 'lightgray']);


			    appDeliveryModelPie = jQuery.jqplot('appDeliveryModelPieChart', [appDeliveryTempData], {

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


			    <!--redrawView();-->
			});
										  	
						</script>

						

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
						
					
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
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayNone" value="none" checked="checked" onchange="setBusCapabilityOverlay()"/>Application Support</label>
							<label class="radio-inline"><input type="radio" name="busOverlay" id="busOverlayDup" value="duplication" onchange="setBusCapabilityOverlay()"/>Duplication</label>
						
						</div>
					</div>
					<xsl:call-template name="busCapModelInclude"/>
					   <div class="col-xs-12" id="bcm">
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
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayNone" value="none" checked="checked" onchange="setAppCapabilityOverlay()"/>Footprint</label>
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayDup" value="duplication" onchange="setAppCapabilityOverlay()"/>Duplication</label>
							<!--<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>-->
						</div>
					</div>
					<div class="simple-scroller" id="appRefModelContainer">
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
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayNone" value="none" checked="checked" onchange="setTechCapabilityOverlay()"/>Footprint</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayDup" value="duplication" onchange="setTechCapabilityOverlay()"/>Duplication</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>
						</div>
					</div>
					<div class="simple-scroller" id="techRefModelContainer">
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
	<!--	<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'stakeholders']/value = $thisAppOrgUser2Roles/name]"/>-->
		<xsl:variable name="thisApps2" select="$thisAppOrgUser2Roles/name"/>
		<xsl:variable name="thisTechProdOrgUser2Roles" select="$techOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
	<!--	<xsl:variable name="thisTechProdss" select="$allTechProds[own_slot_value[slot_reference = 'stakeholders']/value = $thisTechProdOrgUser2Roles/name]"/>-->
        <xsl:variable name="thisTechProdss2" select="$thisTechProdOrgUser2Roles/name"/>

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
	<!--		apps: [<xsl:for-each select="$thisApps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],-->
            apps2: [<xsl:for-each select="$thisApps2">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
	<!--		techProds: [<xsl:for-each select="$thisTechProdss">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],-->
            techProds2: [<xsl:for-each select="$thisTechProdss2">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
      
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="getApplications">
		<xsl:variable name="thisAppCodebase" select="$allAppCodebases[name = current()/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
		<xsl:variable name="thisAppDeliveryModel" select="$allAppDeliveryModels[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
		<xsl:variable name="thisAppOrgUser2Roles" select="$appOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<!--	<xsl:variable name="thsAppUsers" select="$allBusinessUnits[name = $thisAppOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>-->
		<xsl:variable name="thsAppUsersIn" select="$thisAppOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
		
		
		{
			<!--id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisAppName"/>",
			description: "<xsl:value-of select="$thisAppDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",-->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			codebase: "<xsl:value-of select="translate($thisAppCodebase/name, '.', '_')"/>",
			delivery: "<xsl:value-of select="translate($thisAppDeliveryModel/name, '.', '_')"/>",
            appOrgUsers: [<xsl:for-each select="$thsAppUsersIn">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="getTechProducts">
		<xsl:variable name="thisTechOrgUser2Roles" select="$techOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thsTechUsers" select="$thisTechOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
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
			<!--id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisTechProdName"/>",
			description: "<xsl:value-of select="$thisTechProdDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",-->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			status: "<xsl:value-of select="translate($theLifecycleStatus/name, '.', '_')"/>",
			statusScore: <xsl:choose><xsl:when test="$theStatusScore > 0"><xsl:value-of select="$theStatusScore"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
			delivery: "<xsl:value-of select="translate($theDeliveryModel/name, '.', '_')"/>",
			techOrgUsers: [<xsl:for-each select="$thsTechUsers">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
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
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>
		
		{<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
		childAppCaps: [
			<xsl:apply-templates select="$childAppCaps" mode="RenderChildAppCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildAppCaps">

		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
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
		<xsl:variable name="thisAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = current()/name]"/>

		<xsl:variable name="thisAppsIn" select="$thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
        
		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
        apps: [<xsl:for-each select="$thisAppsIn">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
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
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
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

		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,

        tprs: [<xsl:for-each select="own_slot_value[slot_reference = 'realised_by_technology_products']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
      
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
    <xsl:template match="node()" mode="RenderAppStakeholderJSONList">
     { id:"<xsl:value-of select="current()/name"/>", stakeholders:[<xsl:for-each select="current()/own_slot_value[slot_reference='stakeholders']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
    </xsl:template>
     <xsl:template match="node()" mode="RenderTPRJSONList">
         { id:"<xsl:value-of select="current()/name"/>", prodId:"<xsl:value-of select="current()/own_slot_value[slot_reference='role_for_technology_provider']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
    </xsl:template>
  <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
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
