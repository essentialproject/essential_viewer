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
	<xsl:variable name="linkClasses" select="('Business_Process', 'Product_Type')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="allBusProcesses" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allBusServices" select="/node()/simple_instance[own_slot_value[slot_reference = 'product_type_produced_by_process']/value = $allBusProcesses/name]"/>

	<xsl:variable name="busProcListByName" select="eas:get_report_by_name('Core: Business Process Catalogue by Name')"/>
	<xsl:variable name="busProcListAsTable" select="eas:get_report_by_name('Core: Business Process Catalogue as Table')"/>
	<xsl:variable name="busProcListByDomain" select="eas:get_report_by_name('Core: Business Process Catalogue by Business Domain')"/>
	
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($allBusServices, $allBusProcesses)"/>
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
					<xsl:value-of select="eas:i18n('Business Process Catalogue')"/>
				</title>
				<script src="js/es6-shim/0.9.2/es6-shim.js" type="text/javascript"/>
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
										<xsl:value-of select="eas:i18n('Business Process Catalogue by Business Service')"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$busProcListByName"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="'Name'"/>
									</xsl:call-template>
									<span class="text-darkgrey"> | </span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$busProcListByDomain"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="'Business Domain'"/>
									</xsl:call-template>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Business Service')"/>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$busProcListAsTable"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Table'"/>
										</xsl:call-template>
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


							<p><xsl:value-of select="eas:i18n('Please select a Business Service or Business Process to navigate to the required view')"/>.</p>
							<script type="text/javascript">
	
								<!-- START VIEW SPECIFIC JAVASCRIPT VARIABLES -->
								//global catalogu specific variables
								var catalogueTable;
								var busProcListTemplate, busSvcNameTemplate;
								
								// the list of JSON objects representing the Suppliers in use across the enterprise
							  	var busServices = {
										busServices: [<xsl:apply-templates select="$allBusServices" mode="RenderBusServiceJSON"/>
							    	]
							  	};				  	
								
								// the list of JSON objects representing the busProcesses in use across the enterprise
							  	var busProcesses = {
										busProcesses: [<xsl:apply-templates select="$allBusProcesses" mode="RenderBusProcessJSON"/>
							    	]
							  	};
							  	
							  	//the list of busProcesses for the current scope
							  	var inScopeBusServices = {
							  		busServices: busServices.busServices
							  	}

							  	
							  	//the list of busProcesses for the current scope
							  	var inScopeBusProcesses = {
							  		busProcesses: busProcesses.busProcesses
							  	}
							  	<!-- END VIEW SPECIFIC JAVASCRIPT VARIABLES -->
							  	
							  	
							  	//function to create the data structure needed to render table rows
								function renderBusProcessTableData() {
									var dataTableSet = [];
									var dataTableRow;

									//Note: The list of bus services is based on the "inScopeBusServices" variable which ony contains apps visible within the current roadmap time frame
									for (var i = 0; inScopeBusServices.busServices.length > i; i += 1) {
										dataTableRow = [];
										//get the current Bus Service
										var aBusSvc = inScopeBusServices.busServices[i];
										//Apply handlebars template
										var busSvcLinkHTML = busSvcNameTemplate(aBusSvc);
										
										//get the current list of bus processes that deliver the bus service
										var busProcList = getObjectsByIds(inScopeBusProcesses.busProcesses, 'id', aBusSvc.processes);
										var busProcListJSON = {
											busProcesses: busProcList
										}							
										//Apply handlebars template
										var busProcListHTML = busProcListTemplate(busProcListJSON);
										
										
										dataTableRow.push(busSvcLinkHTML);
										dataTableRow.push(aBusSvc.description);
										dataTableRow.push(busProcListHTML);
										
										dataTableSet.push(dataTableRow);
									}
									
									return dataTableSet;
								}
								
								
								//funtion to set contents of the catalogue table
								function setBusProcessTable() {					
									var tableData = renderBusProcessTableData();								
									catalogueTable.clear();
									catalogueTable.rows.add(tableData);
			    					catalogueTable.draw();
								}
								
							  	
							  	<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
							  	//function to redraw the view based on the current scope
								function redrawView() {
									//console.log('Redrawing View');
									
									<!-- ***REQUIRED*** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS -->
									if(roadmapEnabled) {
										//update the roadmap status of the busProcesses and application provider roles passed as an array of arrays
										rmSetElementListRoadmapStatus([busProcesses.busProcesses, busServices.busServices]);
										
										<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
										//filter busProcesses to those in scope for the roadmap start and end date
										inScopeBusServices.busServices = rmGetVisibleElements(busServices.busServices);
										//inScopeBusProcesses.busProcesses = rmGetVisibleElements(busProcesses.busProcesses);
									} else {
										inScopeBusServices.busServices = busServices.busServices;
									}	
									
									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setBusProcessTable();
									
																						
								}
								
								
								$(document).ready(function(){
								
									//START COMPILE HANDLEBARS TEMPLATES
									
									//Set up the html templates for technology products, components and capabilities
									var busProcListFragment   = $("#bus-process-bullets").html();
									busProcListTemplate = Handlebars.compile(busProcListFragment);
									
									var busSvcNameFragment   = $("#bus-service-name").html();
									busSvcNameTemplate = Handlebars.compile(busSvcNameFragment);
									
									//END COMPILE HANDLEBAR TEMPLATES

								
									//START INITIALISE UP THE CATALOGUE TABLE
									// Setup - add a text input to each footer cell
								    $('#dt_busProcs tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									catalogueTable = $('#dt_busProcs').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "30%" },
									    { "width": "40%" },
									    { "width": "30%", "type": "html"}
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
								    registerRoadmapDatatable(catalogueTable);
								    
								    //END INITIALISE UP THE CATALOGUE TABLE
								    
								    //DRAW THE VIEW
								    redrawView();
								});
							</script>
							<!-- START TEST DIVS -->
							<div id="testStyling1"/>
							<div id="testStyling2"/>
							<!-- END TEST DIVS -->
							<table id="dt_busProcs" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Business Service')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Producing Business Processes')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Business Service')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Producing Business Processes')"/>
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
				
				<!-- Handlebars template to render a list of busienss processes -->
				<script id="bus-process-bullets" type="text/x-handlebars-template">
					<ul>
						{{#busProcesses}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
						{{/busProcesses}}
					</ul>
				</script>
				
				<!-- Handlebars template to render an individual business service as text-->
				<script id="bus-service-name" type="text/x-handlebars-template">
					<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
					<strong><xsl:call-template name="RenderHandlebarsRoadmapSpan"/></strong>
				</script>
				<!-- END HANDLEBARS TEMPLATES -->
				
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- START TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->
	<xsl:template match="node()" mode="RenderBusProcessJSON">
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="theTargetReport" select="$targetReport"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderBusServiceJSON">
		
		<xsl:variable name="thisBusProcs" select="$allBusProcesses[name = current()/own_slot_value[slot_reference = 'product_type_produced_by_process']/value]"/>
		
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			processes: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusProcs"/>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<!-- END TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->

</xsl:stylesheet>
