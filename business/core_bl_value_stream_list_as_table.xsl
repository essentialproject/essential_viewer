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
	<xsl:variable name="linkClasses" select="('Value_Stream', 'Product_Type','Individual_Business_Role', 'Group_Business_Role', 'Business_Role_Type')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="allValueStreams" select="/node()/simple_instance[type = 'Value_Stream']"/>
	<xsl:variable name="allVSInitiators" select="/node()/simple_instance[name = $allValueStreams/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value]"/>
	<xsl:variable name="allProductTypes" select="/node()/simple_instance[name = $allValueStreams/own_slot_value[slot_reference = 'vs_product_types']/value]"/>

	
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($allValueStreams, $allProductTypes)"/>
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
					<xsl:value-of select="eas:i18n('Value Stream Catalogue')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				
				<!-- ***REQUIRED*** ADD THE JS LIBRARIES IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
				
				<xsl:call-template name="RenderCommonRoadmapJavscript">
					<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
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
										<xsl:value-of select="eas:i18n('Value Stream Catalogue as Table')"/>
									</span>
								</h1>
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


							<p><xsl:value-of select="eas:i18n('This table lists all the Value Streams allows search as well as copy to spreadsheet')"/>.</p>
							<script type="text/javascript">
	
								<!-- START VIEW SPECIFIC JAVASCRIPT VARIABLES -->
								//global catalogu specific variables
								var catalogueTable;
								var instanceListTemplate, vsNameTemplate;
								
								// the list of JSON objects representing the product types in scope
							  	var productTypes = {
										productTypes: [<xsl:apply-templates select="$allProductTypes" mode="RenderInstanceJSON"/>
							    	]
							  	};				  	
								
								// the list of JSON objects representing the value streams in use across the enterprise
							  	var valStreams = {
										valStreams: [<xsl:apply-templates select="$allValueStreams" mode="RenderValStreamJSON"/>
							    	]
							  	};
							  	
							  	// the list of JSON objects representing the business roles in scope
							  	var vsInitiators = {
										vsInitiators: [<xsl:apply-templates select="$allVSInitiators" mode="RenderInstanceJSON"/>
							    	]
							  	};
							  	
							  	//the list of products for the current scope
							  	var inScopeProdTypes = {
							  		productTypes: productTypes.productTypes
							  	}
							  	
							  	//the list of value streams for the current scope
							  	var inScopeValStreams = {
							  		valStreams: valStreams.valStreams
							  	}
							  	
							  	//the list of business roles for the current scope
							  	var inScopeVSInitiators = {
							  		vsInitiators: vsInitiators.vsInitiators
							  	}
							  	<!-- END VIEW SPECIFIC JAVASCRIPT VARIABLES -->
							  	
							  	
							  	//function to create the data structure needed to render table rows
								function renderValStreamTableData() {
									var dataTableSet = [];
									var dataTableRow;

									//Note: The list of valStreams is based on the "inScopeValStreams" variable which ony contains apps visible within the current roadmap time frame
									for (var i = 0; inScopeValStreams.valStreams.length > i; i += 1) {
										dataTableRow = [];
										//get the current Bus Proc
										var aValStream = inScopeValStreams.valStreams[i];
										//Apply handlebars template
										var valStreamLinkHTML = vsNameTemplate(aValStream);
										
										//get the list of initiatos of the value stream
										var prodTypeList = getObjectsByIds(inScopeProdTypes.productTypes, 'id', aValStream.products);
										var prodTypeListJSON = {
											instances: prodTypeList
										}							
										//Apply handlebars template
										var prodTypeListHTML = instanceListTemplate(prodTypeListJSON);
										
										//get the list of initiatos of the value stream
										var initiatorList = getObjectsByIds(inScopeVSInitiators.vsInitiators, 'id', aValStream.initiators);
										var initiatorListJSON = {
											instances: initiatorList
										}							
										//Apply handlebars template
										var initiatorListHTML = instanceListTemplate(initiatorListJSON);
										
										
										dataTableRow.push(valStreamLinkHTML);
										dataTableRow.push(aValStream.description);
										dataTableRow.push(prodTypeListHTML);
										dataTableRow.push(initiatorListHTML);
										
										dataTableSet.push(dataTableRow);
									}
									
									return dataTableSet;
								}
								
								
								//funtion to set contents of the catalogue table
								function setValStreamTable() {					
									var tableData = renderValStreamTableData();								
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
										//update the roadmap status of the value streams, products and initiators passed as an array of arrays
										rmSetElementListRoadmapStatus([valStreams.valStreams, productTypes.productTypes, vsInitiators.vsInitiators]);
										
										<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
										//filter value streams to those in scope for the roadmap start and end date
										inScopeValStreams.valStreams = rmGetVisibleElements(valStreams.valStreams);
									} else {
										inScopeValStreams.valStreams = valStreams.valStreams;
									}
									
									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setValStreamTable();
									
									<!--<!-\- START TEST DIV STYLING -\->
									var testApp1 = getObjectById(inScopeValStreams.valStreams, 'id', 'essential_baseline_v62_it_asset_dashboard_Class21110');
									refreshDOMRoadmapStyles('#testStyling1', vsNameTemplate, testApp1);

								    
								    var testApp2 = getObjectById(inScopeValStreams.valStreams, 'id', 'essential_baseline_v62_it_asset_dashboard_Class21092');
								    refreshDOMRoadmapStyles('#testStyling2', vsNameTemplate, testApp2);				    
								    <!-\- END TEST DIV STYLING -\->-->
																						
								}
								
								
								$(document).ready(function(){
								
									//START COMPILE HANDLEBARS TEMPLATES
									
									//Set up the html templates for technology products, components and capabilities
									var instanceListFragment   = $("#instance-bullets").html();
									instanceListTemplate = Handlebars.compile(instanceListFragment);
									
									var vsNameFragment   = $("#val-stream-name").html();
									vsNameTemplate = Handlebars.compile(vsNameFragment);
									
									//END COMPILE HANDLEBAR TEMPLATES

								
									//START INITIALISE UP THE CATALOGUE TABLE
									// Setup - add a text input to each footer cell
								    $('#dt_valStreams tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									catalogueTable = $('#dt_valStreams').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "25%" },
									    { "width": "35%" },
                                        { "width": "20%", "type": "html"},
									    { "width": "20%", "type": "html"}
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
							<table id="dt_valStreams" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Value Stream')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Products')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Initiators')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Value Stream')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Products')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Initiators')"/>
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
				
				<!-- Handlebars template to render a list of technology capabilities -->
				<script id="instance-bullets" type="text/x-handlebars-template">
					<ul>
						{{#instances}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
						{{/instances}}
					</ul>
				</script>
				
				<!-- Handlebars template to render an individual application as text-->
				<script id="val-stream-name" type="text/x-handlebars-template">
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
	<xsl:template match="node()" mode="RenderInstanceJSON">
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderValStreamJSON">
		
		<xsl:variable name="thisInitiators" select="$allVSInitiators[name = current()/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value]"/>
		<xsl:variable name="thisProductTypes" select="$allProductTypes[name = current()/own_slot_value[slot_reference = 'vs_product_types']/value]"/>
		
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="theTargetReport" select="$targetReport"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			products: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProductTypes"/>], 
			initiators: [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisInitiators"/>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<!-- END TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->

</xsl:stylesheet>
