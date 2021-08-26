<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../business/core_bl_utilities.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Supplier', 'Technology_Product', 'Technology_Component', 'Technology_Capability')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="allTechProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allTechSuppliers" select="/node()/simple_instance[name = $allTechProducts/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[(own_slot_value[slot_reference = 'role_for_technology_provider']/value = $allTechProducts/name) and (own_slot_value[slot_reference = 'implementing_technology_component']/value = $allTechComponents/name)]"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	
	<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
	<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[name = $allTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
	<xsl:variable name="allStandardStyles" select="/node()/simple_instance[name = $allStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	
	<xsl:variable name="offStrategyStyle">backColourRed</xsl:variable>

	<xsl:variable name="techProdListByVendorCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Vendor')"/>
	<xsl:variable name="techProdListByCapCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Technology Capability')"/>
	<xsl:variable name="techProdListByNameCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Technology Component')"/>
	
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($allTechProducts, $allTechProdRoles)"/>
	<xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	
	<!--
		* Copyright © 2008-2018 Enterprise Architecture Solutions Limited.
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
	<!-- 28.07.2018 JP Updated to support Roadmap capabilities -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
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
				<title>
					<xsl:value-of select="eas:i18n('Technology Product Catalogue')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				
				<!-- ***REQUIRED*** ADD THE JS LIBRARIES IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>

			</head>
			<body>
				
						
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- ***REQUIRED*** ADD THE ROADMAP WIDGET FLOATING DIV -->
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
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Technology Product Catalogue as Table')"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Component'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByCapCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Capability'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByVendorCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Table')"/>
									</span>
								</div>
							</div>
						</div>
					</div>
					

					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>


							<p><xsl:value-of select="eas:i18n('This table lists all the Technology Products in use and allows search as well as copy to spreadsheet')"/>.</p>
							<script type="text/javascript">
	
								<!-- START VIEW SPECIFIC JAVASCRIPT VARIABLES -->
								//global catalogu specific variables
								var catalogueTable;
								var techCapListTemplate, techCompListTemplate, techProdNameTemplate;
								
								// the list of JSON objects representing the Suppliers in use across the enterprise
							  	var techSuppliers = {
										techSuppliers: [<xsl:apply-templates select="$allTechSuppliers" mode="RenderTechSupplierJSON"/>
							    	]
							  	};
							  	
							  	
							  	// the list of JSON objects representing the technology capabilities in use across the enterprise
							  	var techCapabilities = {
										techCapabilities: [<xsl:apply-templates select="$allTechCaps" mode="RenderTechCapJSON"/>
							    	]
							  	};
								
								// the list of JSON objects representing the techProducts in use across the enterprise
							  	var techProducts = {
										techProducts: [<xsl:apply-templates select="$allTechProducts" mode="RenderTechProdJSON"/>
							    	]
							  	};
							  	
							  	// the list of JSON objects representing the techProducts in use across the enterprise
							  	var techProductRoles = {
										techProductRoles: [<xsl:apply-templates select="$allTechProdRoles" mode="RenderTechProdRoleJSON"/>
							    	]
							  	};
							  	
							  	//the list of techProducts for the current scope
							  	var inScopeTechProducts = {
							  		techProducts: techProducts.techProducts
							  	}
							  	<!-- END VIEW SPECIFIC JAVASCRIPT VARIABLES -->
							  	
							  	
							  	//function to create the data structure needed to render table rows
								function renderTechProductsTableData() {
									var dataTableSet = [];
									var dataTableRow;

									//Note: The list of techProducts is based on the "inScopeTechProducts" variable which ony contains apps visible within the current roadmap time frame
									for (var i = 0; inScopeTechProducts.techProducts.length > i; i += 1) {
										dataTableRow = [];
										//get the current Tech Prod
										var aTechProd = inScopeTechProducts.techProducts[i];
										//Apply handlebars template
										var techProdLinkHTML = techProdNameTemplate(aTechProd);
										
										//get the supplier
										var aSupplier = getObjectById(techSuppliers.techSuppliers, 'id', aTechProd.supplierId);
										var aSupplierLink = '';
										if(aSupplier != null) {
											aSupplierLink = aSupplier.link;
										}
										
										//get the current list of app services provided by the app based on the full list of app provider roles
										var techCompList = getObjectsByIds(techProductRoles.techProductRoles, 'id', aTechProd.components);
										var techCompListJSON = {
											techComponents: techCompList
										}							
										//Apply handlebars template
										var techCompListHTML = techCompListTemplate(techCompListJSON);
										
										//Add the tech capabilities
										var techCapIdLists = [];
										var techCapIds;
										techCompList.forEach(function (aTechComp) {
											techCapIds = aTechComp.techCaps;
											if(techCapIds.length > 0) {
												techCapIdLists.push(techCapIds);
											}
										});
										var uniqueTechCapIds = getUniqueArrayVals(techCapIdLists);
										var techCapList = getObjectsByIds(techCapabilities.techCapabilities, 'id', uniqueTechCapIds);
										var techCapListJSON = {
											techCapabilities: techCapList
										}
										//Apply handlebars template
										var techCapListHTML = techCapListTemplate(techCapListJSON);
										
										dataTableRow.push(aSupplierLink);
										dataTableRow.push(techProdLinkHTML);
										dataTableRow.push(techCompListHTML);
										dataTableRow.push(techCapListHTML);
										
										dataTableSet.push(dataTableRow);
									}
									
									return dataTableSet;
								}
								
								
								//funtion to set contents of the Application catalogue table
								function setTechProductsTable() {					
									var tableData = renderTechProductsTableData();								
									catalogueTable.clear();
									catalogueTable.rows.add(tableData);
			    					catalogueTable.draw();
								}
								
							  	
							  	<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
							  	//function to redraw the view based on the current scope
								function redrawView() {
									//console.log('Redrawing View');
									
									if(roadmapEnabled) {
									<!-- ***REQUIRED*** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS -->
										//update the roadmap status of the techProducts and application provider roles passed as an array of arrays
										rmSetElementListRoadmapStatus([techProducts.techProducts, techProductRoles.techProductRoles]);
										
										<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
										//filter techProducts to those in scope for the roadmap start and end date
										inScopeTechProducts.techProducts = rmGetVisibleElements(techProducts.techProducts);
									} else {
										inScopeTechProducts.techProducts = techProducts.techProducts;
									}
									
									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setTechProductsTable();
									
									<!--<!-\- START TEST DIV STYLING -\->
									var testApp1 = getObjectById(inScopeTechProducts.techProducts, 'id', 'essential_baseline_v62_it_asset_dashboard_Class21110');
									refreshDOMRoadmapStyles('#testStyling1', techProdNameTemplate, testApp1);

								    
								    var testApp2 = getObjectById(inScopeTechProducts.techProducts, 'id', 'essential_baseline_v62_it_asset_dashboard_Class21092');
								    refreshDOMRoadmapStyles('#testStyling2', techProdNameTemplate, testApp2);				    
								    <!-\- END TEST DIV STYLING -\->-->
																						
								}
								
								
								$(document).ready(function(){
								
									//START COMPILE HANDLEBARS TEMPLATES
									
									//Set up the html templates for technology products, components and capabilities
									var techCapListFragment   = $("#tech-capability-bullets").html();
									techCapListTemplate = Handlebars.compile(techCapListFragment);
									
									var techCompListFragment   = $("#tech-component-bullets").html();
									techCompListTemplate = Handlebars.compile(techCompListFragment);
									
									var techProdNameFragment   = $("#tech-product-name").html();
									techProdNameTemplate = Handlebars.compile(techProdNameFragment);
									
									//END COMPILE HANDLEBAR TEMPLATES

								
									//START INITIALISE UP THE CATALOGUE TABLE
									// Setup - add a text input to each footer cell
								    $('#dt_techProds tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									catalogueTable = $('#dt_techProds').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "20%" },
									    { "width": "30%" },
                                        { "width": "25%", "type": "html"},
									    { "width": "25%", "type": "html"}
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
								    catalogueTable.columns().every( function () {
								        var that = this;
								 
								        $( 'input', this.footer() ).on( 'keyup change', function () {
								            if ( that.search() !== this.value ) {
								                that
								                    .search( this.value )
								                    .draw();
								            }
								        } );
								    } );
								     
								    catalogueTable.columns.adjust();
								    
								    $(window).resize( function () {
								        catalogueTable.columns.adjust();
								    });
								    
								    <!-- ***OPTIONAL*** Register the table as having roadmap aware contents -->
								    if(roadmapEnabled) {
								    	registerRoadmapDatatable(catalogueTable);
								    }
								    
								    //END INITIALISE UP THE CATALOGUE TABLE
								    
								    //DRAW THE VIEW
								    redrawView();
								});
							</script>
							<!-- START TEST DIVS -->
							<div id="testStyling1"/>
							<div id="testStyling2"/>
							<!-- END TEST DIVS -->
							<table id="dt_techProds" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Supplier')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Product')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Implemented Components')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Realised Capabilities')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Supplier')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Product')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Implemented Components')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Realised Capabilities')"/>
										</th>
                                    </tr>
								</tfoot>
								<tbody/>								
							</table>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- START HANDLEBARS TEMPLATES -->
				<!-- Handlebars template to render a list of technology components -->
				<script id="tech-component-bullets" type="text/x-handlebars-template">
					<ul>
						{{#techComponents}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<li>
								<xsl:call-template name="RenderHandlebarsRoadmapSpan"/>
								{{#if standard}}{{{standard}}}{{/if}}
							</li>
						{{/techComponents}}
					</ul>
				</script>
				
				<!-- Handlebars template to render a list of technology capabilities -->
				<script id="tech-capability-bullets" type="text/x-handlebars-template">
					<ul>
						{{#techCapabilities}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
						{{/techCapabilities}}
					</ul>
				</script>
				
				<!-- Handlebars template to render an individual application as text-->
				<script id="tech-product-name" type="text/x-handlebars-template">
					<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
					<xsl:call-template name="RenderHandlebarsRoadmapSpan"/>
				</script>
				<!-- END HANDLEBARS TEMPLATES -->
				
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- START TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->
	<xsl:template match="node()" mode="RenderTechSupplierJSON">
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<!-- START TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->
	<xsl:template match="node()" mode="RenderTechCapJSON">
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderTechProdJSON">
		
		<xsl:variable name="thisSupplier" select="$allTechSuppliers[name = current()/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'role_for_technology_provider']/value = current()/name]"/>
		
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="theTargetReport" select="$targetReport"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			supplierId: '<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>', 
			components: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisTechProdRoles"/>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderTechProdRoleJSON">
		<xsl:variable name="thisTechProd" select="$allTechProducts[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="thisTechComp" select="$allTechComponents[name = current()/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>	
		<xsl:variable name="thisTechCaps" select="$allTechCaps[name = $thisTechComp/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value]"/>
		
		<xsl:variable name="allThisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisTechComp/name]"/>
		<xsl:variable name="allThisTechProdStandards" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allThisTechProdRoles/name]"/>
		
		<xsl:variable name="thisTechProdStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = current()/name]"/>
		
		<xsl:variable name="standardHTML">
			<xsl:choose>
				<xsl:when test="count($thisTechProdStandard) > 0">
					<xsl:variable name="thisStandardStrength" select="$allStandardStrengths[name = $thisTechProdStandard[1]/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
					<xsl:variable name="thisStandardStyle" select="$allStandardStyles[name = $thisStandardStrength/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
					<xsl:variable name="thisStandardStyleIcon" select="$thisStandardStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>
					<xsl:variable name="thisStandardStyleClass" select="$thisStandardStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>
					<xsl:variable name="thisStandardStyleColour" select="$thisStandardStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>

					<xsl:variable name="thisStandardStyleTextColour" select="$thisStandardStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>
					<xsl:choose>
						<xsl:when test="$thisStandardStyleClass">
							<button>
									<xsl:attribute name="class">btn btn-small standardBadge left-5 <xsl:value-of select="$thisStandardStyleClass"/></xsl:attribute>
									<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisStandardStrength"></xsl:with-param></xsl:call-template>
							</button>
						</xsl:when>
						<xsl:otherwise>
							<button class="btn btn-small">
								<xsl:attribute name="style">background-color:<xsl:value-of select="$thisStandardStyleColour"/>;color:<xsl:value-of select="$thisStandardStyleTextColour"/></xsl:attribute><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisStandardStrength"></xsl:with-param></xsl:call-template></button>
							<!--
							<div class="standardBadge left-5"><xsl:attribute name="style">background-color:<xsl:value-of select="$thisStandardStyleColour"/>;color:<xsl:value-of select="$thisStandardStyleTextColour"/></xsl:attribute><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisStandardStrength"></xsl:with-param></xsl:call-template></div>
							-->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
						<button>
								<xsl:attribute name="class">btn btn-small standardBadge left-5 <xsl:value-of select="$offStrategyStyle"/></xsl:attribute><xsl:value-of select="eas:i18n('Off Strategy')"></xsl:value-of>
							</button>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="$thisTechComp"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			techProdId: '<xsl:value-of select="eas:getSafeJSString($thisTechProd[1]/name)"/>',
			techCompId: '<xsl:value-of select="eas:getSafeJSString($thisTechComp[1]/name)"/>',
			<xsl:if test="count($allThisTechProdStandards) > 0">standard: '<xsl:copy-of select="$standardHTML"/>',</xsl:if>
			techCaps: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisTechCaps"/>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	<!-- END TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->

</xsl:stylesheet>
