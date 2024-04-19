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
	<xsl:variable name="linkClasses" select="('Application_Provider_Interface', 'Application_Service')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allAppProviders" select="/node()/simple_instance[type = 'Application_Provider_Interface']"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[(own_slot_value[slot_reference = 'role_for_application_provider']/value = $allAppProviders/name) and (own_slot_value[slot_reference = 'implementing_application_service']/value = $allAppServices/name)]"/>

	<xsl:variable name="appListByAppFamilyCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Provider Catalogue by Application Family')]"/>
	<xsl:variable name="appListByName" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Provider Catalogue by Name')]"/>
	<xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($allAppProviders, $allAppProviderRoles)"/>
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
					<xsl:value-of select="eas:i18n('Application Interface Catalogue')"/>
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
										<xsl:value-of select="eas:i18n('Application Interface Catalogue as Table')"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$appListByName"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="eas:i18n('Name')"/>
									</xsl:call-template>
									<span class="text-darkgrey"> | </span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$appListByAppFamilyCatalogue"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="eas:i18n('Application Family')"/>
									</xsl:call-template>
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


							<p><xsl:value-of select="eas:i18n('This table lists all the Application Interfaces in use and allows search as well as copy to spreadsheet')"/>.</p>
							<script type="text/javascript">
	
								<!-- START VIEW SPECIFIC JAVASCRIPT VARIABLES -->
								//global catalogu specific variables
								var catalogueTable;
								var appServiceListTemplate, appProviderNameTemplate;
								
								// the list of JSON objects representing the applications in use across the enterprise
							  	var applications = {
										'applications': [<xsl:apply-templates select="$allAppProviders" mode="getApplications"/>
							    	]
							  	};
							  	
							  	// the list of JSON objects representing the applications in use across the enterprise
							  	var appProviderRoles = {
										"appProviderRoles": [<xsl:apply-templates select="$allAppProviderRoles" mode="getAppProviderRoles"/>
							    	]
							  	};
							  	
							  	//the list of applications for the current scope
							  	var inScopeApplications = {
							  		"applications": applications.applications
							  	}
							  	<!-- END VIEW SPECIFIC JAVASCRIPT VARIABLES -->
							  	
							  	
							  	//function to create the data structure needed to render table rows
								function renderApplicationTableData() {
									var dataTableSet = [];
									var dataTableRow;

									//Note: The list of applications is based on the "inScopeApplications" variable which ony contains apps visible within the current roadmap time frame
									for (var i = 0; inScopeApplications.applications.length > i; i += 1) {
										dataTableRow = [];
										//get the current App
										anApp = inScopeApplications.applications[i];
										
										//Apply handlebars template
										appLinkHTML = appProviderNameTemplate(anApp);
										
										//get the current list of app services provided by the app based on the full list of app provider roles
										appServiceList = getObjectsByIds(appProviderRoles.appProviderRoles, 'id', anApp.services);
										appServiceListJSON = {
											appServices: appServiceList
										}
										
										//Apply handlebars template
										appServiceListHTML = appServiceListTemplate(appServiceListJSON);
										
										dataTableRow.push(appLinkHTML);
										dataTableRow.push(anApp.description);
										dataTableRow.push(appServiceListHTML);
										dataTableRow.push(anApp.status);
										
										dataTableSet.push(dataTableRow);
									}
									
									return dataTableSet;
								}
								
								
								//funtion to set contents of the Application catalogue table
								function setApplicationsTable() {					
									var tableData = renderApplicationTableData();								
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
										//update the roadmap status of the applications and application provider roles passed as an array of arrays
										rmSetElementListRoadmapStatus([applications.applications, appProviderRoles.appProviderRoles]);
										
										<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
										//filter applications to those in scope for the roadmap start and end date
										inScopeApplications.applications = rmGetVisibleElements(applications.applications);
									}
									
									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setApplicationsTable();
									
									<!--<!-\- START TEST DIV STYLING -\->
									var testApp1 = getObjectById(inScopeApplications.applications, 'id', 'essential_baseline_v62_it_asset_dashboard_Class21110');
									refreshDOMRoadmapStyles('#testStyling1', appProviderNameTemplate, testApp1);

								    
								    var testApp2 = getObjectById(inScopeApplications.applications, 'id', 'essential_baseline_v62_it_asset_dashboard_Class21092');
								    refreshDOMRoadmapStyles('#testStyling2', appProviderNameTemplate, testApp2);				    
								    <!-\- END TEST DIV STYLING -\->-->
																						
								}
								
								
								$(document).ready(function(){
								
									//START COMPILE HANDLEBARS TEMPLATES
									
									//Set up the html templates for application providers and app services
									var appServiceListFragment   = $("#app-service-bullets").html();
									appServiceListTemplate = Handlebars.compile(appServiceListFragment);
									
									var appProviderNameFragment   = $("#app-provider-name").html();
									appProviderNameTemplate = Handlebars.compile(appProviderNameFragment);
									
									//END COMPILE HANDLEBAR TEMPLATES

								
									//START INITIALISE UP THE CATALOGUE TABLE
									// Setup - add a text input to each footer cell
								    $('#dt_apps tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
								    } );
									
									catalogueTable = $('#dt_apps').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "20%" },
									    { "width": "40%" },
                                        { "width": "25%" },
									    { "width": "15%", "type": "html",}
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
							<table id="dt_apps" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Application Interface')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Services Provided')"/>
										</th>
    									<th>
											<xsl:value-of select="eas:i18n('Status')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Application Interface')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Services Provided')"/>
										</th>
    									<th>
											<xsl:value-of select="eas:i18n('Status')"/>
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
				<!-- Handlebars template to render a list of application services -->
				<script id="app-service-bullets" type="text/x-handlebars-template">
					<ul>
						{{#appServices}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<xsl:call-template name="RenderHandlebarsRoadmapBullet"/>
						{{/appServices}}
					</ul>
				</script>
				
				<!-- Handlebars template to render an individual application as text-->
				<script id="app-provider-name" type="text/x-handlebars-template">
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
	
	<xsl:template match="node()" mode="getApplications">

		<xsl:variable name="thisAppProRoles" select="$allAppProviderRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name]"/>
		
		<xsl:variable name="appStatus">
			<xsl:value-of select="own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>
		</xsl:variable>
		<xsl:variable name="thisLife" select="$lifecycle[name=$appStatus]"/>
		<xsl:variable name="colour" select="eas:getElementStyleClass($thisLife)"/>

		<xsl:variable name="statusHTML">
			<div class="label large text-center uppercase {$colour}">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$thisLife"/>
				</xsl:call-template>
			</div>
		</xsl:variable>
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="theTargetReport" select="$targetReport"/><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"status": "<xsl:copy-of select="eas:validJSONString($statusHTML)"/>",
			"services": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisAppProRoles"><xsl:sort select="own_slot_value[slot_reference = 'role_for_application_provider']/value"/></xsl:apply-templates>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="getAppProviderRoles">
		<xsl:variable name="thisAppProvider" select="$allAppProviders[name = current()/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="thisAppService" select="$allAppServices[name = current()/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>	
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="$thisAppService"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"appId": "<xsl:value-of select="eas:getSafeJSString($thisAppProvider/name)"/>",
			"appServiceId": "<xsl:value-of select="eas:getSafeJSString($thisAppService/name)"/>"
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	<!-- END TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->

</xsl:stylesheet>
