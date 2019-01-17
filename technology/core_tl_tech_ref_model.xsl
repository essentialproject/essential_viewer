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


	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>

	
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComps/name]"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[name = $allTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	
	<!--<xsl:variable name="techProdDeliveryTaxonomy" select="/node()/simple_instance[(type='Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Technology Product Delivery Types')]"/>-->
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[name = $allTechProds/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
	
	<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
	<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
	
	<xsl:variable name="allBusinessUnits" select="/node()/simple_instance[name = $techOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allBusinessUnitOffices" select="/node()/simple_instance[name = $allBusinessUnits/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeGeoRegions" select="/node()/simple_instance[name = $allBusinessUnitOffices/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeLocations" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
	<xsl:variable name="allBusinessUnitLocationCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_locations']/value = $allBusinessUnitOfficeLocations/name]"/>
	<xsl:variable name="allBusinessUnitOfficeCountries" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
	<xsl:variable name="allBusinessUnitCountries" select="$allBusinessUnitLocationCountries union $allBusinessUnitOfficeCountries"/>
	
	
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	
	
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
				<title>Technology Reference Model</title>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<script type="text/javascript" src="js/handlebars-v4.0.8.js"/>

				<xsl:call-template name="refModelLegendInclude"/>
				
				<script type="text/javascript">
					
					var techDetailTemplate, ragOverlayLegend, noOverlayTRMLegend;
					
					
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
				  	
				  	
				  	// the list of JSON objects representing the technology products in use across the enterprise
				  	var techProducts = {
						techProducts: [     <xsl:apply-templates select="$allTechProds" mode="getTechProducts"/>
				    	]
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

				  	
					// the JSON objects for the Technology Components and Products that implement Technology Capabilities
				  	var techCapDetails = [
				  		<xsl:apply-templates select="$allTechCaps" mode="TechCapDetails"/>
				  	];
				  				  	
				  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>	
					
					<xsl:call-template name="RenderJavascriptScopingFunctions"/>
	
					<!-- START PAGE DRAWING FUNCTIONS -->
					//function to set the current list of Business Units based on a given list of Ids
					function setCurrentTechRefModelBusUnits(busUnitIdList) {
						selectedBusUnitIDs = busUnitIdList;
						selectedBusUnits = getObjectsByIds(businessUnits.businessUnits, "id", selectedBusUnitIDs);

						setTRMCurrentTechProds();
					}
					
					//function to set the current list of Technology Products
					function setTRMCurrentTechProds() {
						if(selectedBusUnitIDs.length > 0) {
							var techProdArrays = [];
							var currentBU;
							for (i = 0; selectedBusUnits.length > i; i += 1) {
								currentBU = selectedBusUnits[i];
								techProdArrays.push(currentBU.techProds);
							}
							
							selectedTechProdIDs = getUniqueArrayVals(techProdArrays);
							selectedTechProds = getObjectsByIds(techProducts.techProducts, "id", selectedTechProdIDs);
							// console.log("Selected Tech Prod Count: " + selectedTechProds.length);
						} else {
							selectedTechProdIDs = getObjectIds(techProducts.techProducts, "id");
							selectedTechProds = techProducts.techProducts;
						}
					}
					
					
					//function to draw the relevant dashboard components based on the currently selected Data Objects
					function drawDashboard() {
						
						//Update the TRM Model
						setTechCapabilityOverlay();

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
						setTRMCurrentTechProds();
									
						$('#busUnitList').on('change', function (evt) {
						  var thisBusUnitIDs = $(this).select2("val");
						  if(thisBusUnitIDs != null) {
						  	setCurrentTechRefModelBusUnits(thisBusUnitIDs);
						  } else {
						  	selectedBusUnitIDs = [];
						  	selectedBusUnits = [];
						  	setTRMCurrentTechProds();
						  }
						  drawDashboard();
						  //console.log("Select BUs: " + selectedBusUnitIDs);					
						});
						
						
						
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
						legendLabels["inScope"] = 'Technology Products in Use';
						noOverlayTRMLegend = legendTemplate(legendLabels);	
						
						<!-- SET UP THE TRM MODEL -->
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
					
					.popover{
						max-width: 800px;
					}
				</style>
				
				<xsl:call-template name="refModelStyles"/>
				
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
									<span class="text-darkgrey">Technology Reference Model</span>
								</h1>
							</div>
						</div>
						<xsl:call-template name="RenderDashboardBusUnitFilter"/>
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



	<xsl:template name="techSection">
		<xsl:call-template name="techRefModelInclude"/>
		<script>
			$(document).ready(function() {
			 	$('.matchHeight1').matchHeight();
			});
		</script>
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Reference Model</h2>
				<div class="row">
					<!-- REFERTENCE MODEL LEGEND SECTION -->
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
						</div>
					</div>
					<!-- REFERENCE MODEL CONTAINER -->
					<div class="simple-scroller" id="techRefModelContainer"/>					
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getBusinessUnits">
		<xsl:variable name="thisBusinessUnitOffice" select="$allBusinessUnitOffices[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="thisBusinessUnitOfficeGeoRegions" select="$allBusinessUnitOfficeGeoRegions[name = $thisBusinessUnitOffice/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisBusinessUnitOfficeLocations" select="$thisBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
		<xsl:variable name="thisBusinessUnitLocationCountries" select="$allBusinessUnitLocationCountries[own_slot_value[slot_reference = 'gr_locations']/value = $thisBusinessUnitOfficeLocations/name]"/>
		<xsl:variable name="thisBusinessUnitOfficeCountries" select="$thisBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
		
		<xsl:variable name="thisBusinessUnitCountry" select="$thisBusinessUnitLocationCountries union $thisBusinessUnitOfficeCountries"/>

		<xsl:variable name="thisTechProdOrgUser2Roles" select="$techOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="thisTechProdss" select="$allTechProds[own_slot_value[slot_reference = 'stakeholders']/value = $thisTechProdOrgUser2Roles/name]"/>
		
		
		
		{
			id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
			name: "<xsl:value-of select="own_slot_value[slot_reference='name']/value"/>",
			description: "<xsl:value-of select="own_slot_value[slot_reference='description']/value"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			country: "<xsl:value-of select="$thisBusinessUnitCountry/own_slot_value[slot_reference='gr_region_identifier']/value"/>",
			techProds: [<xsl:for-each select="$thisTechProdss">"<xsl:value-of select="translate(current()/name, '.', '_')"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="getTechProducts">
		<xsl:variable name="thisTechOrgUser2Roles" select="$techOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thsTechUsers" select="$allBusinessUnits[name = $thisTechOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="theLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value]"/>
		<xsl:variable name="theDeliveryModel" select="$allTechProdDeliveryTypes[name = current()/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
		<xsl:variable name="theStatusScore" select="$theLifecycleStatus/own_slot_value[slot_reference = 'enumeration_score']/value">
			
		</xsl:variable>

		{
			id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
			name: "<xsl:value-of select="own_slot_value[slot_reference='name']/value"/>",
			description: "<xsl:value-of select="eas:renderJSText(own_slot_value[slot_reference='description']/value)"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			status: "<xsl:value-of select="$theLifecycleStatus/name"/>",
			statusScore: <xsl:choose><xsl:when test="$theStatusScore > 0"><xsl:value-of select="$theStatusScore"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
			delivery: "<xsl:value-of select="$theDeliveryModel/name"/>",
			techOrgUsers: [<xsl:for-each select="$thsTechUsers">"<xsl:value-of select="translate(current()/name, '.', '_')"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	

	
	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="techDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techDomainDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="$allTechCaps[name = current()/own_slot_value[slot_reference = 'contains_technology_capabilities']/value]"/>
		
		{
		id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
		name: "<xsl:value-of select="$techDomainName"/>",
		description: "<xsl:value-of select="eas:renderJSText($techDomainDescription)"/>",
		link: "<xsl:value-of select="$techDomainLink"/>",
		childTechCaps: [
		<xsl:apply-templates select="$childTechCaps" mode="RenderChildTechCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildTechCaps">
		<xsl:variable name="techCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCapDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
			name: "<xsl:value-of select="$techCapName"/>",
			link: "<xsl:value-of select="$techCapLink"/>",
			description: "<xsl:value-of select="eas:renderJSText($techCapDescription)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="TechCapDetails">
		<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
			techComponents: [	
				<xsl:apply-templates select="$techComponents" mode="RenderTechComponents"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderTechComponents">
		<xsl:variable name="techCompName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCompDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCompLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
		<xsl:variable name="thisTechProds" select="$allTechProds[name = $thisTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		
		{
		id: "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
		name: "<xsl:value-of select="$techCompName"/>",
		link: "<xsl:value-of select="$techCompLink"/>",
		description: "<xsl:value-of select="eas:renderJSText($techCompDescription)"/>",
		techProds: [<xsl:for-each select="$thisTechProds">"<xsl:value-of select="translate(current()/name, '.', '_')"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>

</xsl:stylesheet>
