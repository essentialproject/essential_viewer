<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
	<xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_api_fetcher.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	
	
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	
	<!-- END GENERIC PARAMETERS -->
	
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider', 'Application_Provider_Interface', 'Technology_Product', 'Technology_Component')"/>
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
	
	<xsl:template match="knowledge_base">
		
		<html lang="en">
			<head>
				<xsl:call-template name="commonHeadContent">
					<xsl:with-param name="requiresDataTables" select="false()"/>
				</xsl:call-template>
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<meta charset="UTF-8" />
				<title><xsl:value-of select="eas:i18n('Application Interface Catalogue')"/></title>
				<!-- DATATABLES JAVASCRIPT LIBRARY-->
				<link href="js/DataTables/2.1.8/datatables.min.css" rel="stylesheet"/>
				<script type="text/javascript" src="js/DataTables/2.1.8/datatables.min.js"></script>
				<style>
					<!-- YOUR CSS -->
				</style>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body role="document" aria-labelledby="main-heading">
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- <xsl:call-template name="ViewUserScopingUI"></xsl:call-template> -->
				
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="main-heading">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Interface Catalogue')"/></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12" role="main">
							<!-- YOUR HTML-->
							<div class="table-responsive">
								<table id="dt_app_interfaces" class="table table-striped table-bordered table-hover" style="width:100%">
									<thead></thead>
									<tfoot id="dt_app_interfaces_footer">
										<th><xsl:value-of select="eas:i18n('Search Interface Name')"/></th>
										<th><xsl:value-of select="eas:i18n('Search Description')"/></th>
										<th><xsl:value-of select="eas:i18n('Search Source Applications')"/></th>
										<th><xsl:value-of select="eas:i18n('Search Target Applications')"/></th>
										<th><xsl:value-of select="eas:i18n('Search Implementing Technology')"/></th>
									</tfoot>
								</table>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
				
				<script type="text/x-handlebars-template" id="inst-link-template">
					<span>{{this.name}}{{#hbessRenderInstanceLinkMenu this 'Application_Provider_Interface'}}{{/hbessRenderInstanceLinkMenu}}</span>
				</script>
				
				<script type="text/x-handlebars-template" id="inst-link-list-template">
					<ul>
						{{#each this}}
						<li>
							<span>{{#hbessRenderInstanceLinkMenu this 'Composite_Application_Provider'}}{{/hbessRenderInstanceLinkMenu}}</span>
							<!-- {{#if infoExchanged}}<span class="text-muted">({{infoExchanged}})</span>{{/if}} -->
						</li>
						{{/each}}
					</ul>
				</script>
				
				<script type="text/x-handlebars-template" id="supp-tech-list-template">
					<ul>
						{{#each this}}
						<li>
							<span>{{#hbessRenderInstanceLinkMenu techProduct 'Technology_Product'}}{{/hbessRenderInstanceLinkMenu}}</span>
							{{#if techComponent}}<span class="text-muted">({{#hbessRenderInstanceLinkMenu techComponent 'Technology_Component'}}{{/hbessRenderInstanceLinkMenu}})</span>{{/if}}
						</li>
						{{/each}}
					</ul>
				</script>
				
				<script type="text/x-handlebars-template" id="table-footer-template">
					{{#each this}}	
					<th>
						<input type = "text"><xsl:attribute name="placeHolder">Search {{title}}</xsl:attribute></input>
					</th>
					{{/each}}
				</script>
				
				
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script type="text/javascript">
					<xsl:call-template name="RenderViewerAPIJSFunction"/>	
					
					<!-- DEFINE YOUR VARIABLES - If GPT doesn't provide then just replicate the apiList names-->
					let appMartAPI, infoMartAPI, ImpTechProdApi;
					let instLinkTemplate, instLinkListTemplate, suppTechListTemplate, tableFooterTemplate, catalogueTable;
					let appInterfaceCatalogue = [];
					let inScopeAppInterfaces = [];
					
					<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
					
					//funtion to set contents of the Application catalogue table
					function drawAppInterfaceTable() {		
					if(catalogueTable == null) {
					initAppInterfacesTable();
					} else {
					//let appTableColumns = getAppTableColumns();
					catalogueTable.clear();
					catalogueTable.rows.add(inScopeAppInterfaces);
					catalogueTable.draw();
					}
					}
					
					
					//function to calculate the column definitions required for the app table
					function getAppInterfaceTableColumnDefs() {
					
					let appInterfaceColumnDefs = [
					{
					"targets": 0,
					"title": "Interface Name",
					"data" : "id",
					"defaultContent": "",
					"width": "150px",
					"render": function( d, type, row, meta ){
					if(row != null) {
					return instLinkTemplate(row);
					}
					}
					},
					{
					"targets": 1,
					"title": "Description",
					"data" : "interface.description",
					"defaultContent": "",
					"width": "200px",
					"visible": true,
					"render": function( d, type, row, meta ){
					if(d) {
					return d;
					} else {
					return "-";
					}
					}
					},
					{
					"targets": 2,
					"title": "Source Applications",
					"data" : "sourceApps",
					"defaultContent": "",
					"width": "60px",
					"visible": true,
					"render": function( d, type, row, meta ){
					if(d?.length > 0) {
					return instLinkListTemplate(d);
					} else {
					return "-";
					}
					}
					},
					{
					"targets": 3,
					"title": "Target Applications",
					"data" : "targetApps",
					"defaultContent": "",
					"width": "60px",
					"visible": true,
					"render": function( d, type, row, meta ){
					if(d?.length > 0) {
					return instLinkListTemplate(d);
					} else {
					return "-";
					}
					}
					},
					{
					"targets": 4,
					"title": "Implementation Technology",
					"data" : "supportingTech",
					"defaultContent": "",
					"width": "60px",
					"visible": true,
					"render": function( d, type, row, meta ){
					if(d?.length > 0) {
					//console.log("Host Sites for " + row.name, d);
					return suppTechListTemplate(d);
					} else {
					return "-";
					}
					}
					}
					];
					//console.log('TABLE COLUMNS', appColumns);
					return appInterfaceColumnDefs;
					}
					
					
					//function to initialise the applications table
					function initAppInterfacesTable() {
					//START INITIALISE UP THE CATALOGUE TABLE
					
					let appInterfaceColumnDefs = getAppInterfaceTableColumnDefs();
					
					// Setup - add a text input to each footer cell
					//$('#dt_app_interfaces_footer').html(tableFooterTemplate(appInterfaceColumnDefs));
					
					$('#dt_app_interfaces tfoot th').each( function () {
					var title = $(this).text();
					$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
					} );
					
					catalogueTable = $('#dt_app_interfaces').DataTable({
					paging: false,
					autoWidth: false,
					deferRender: true,
					scrollY: 350,
					fixedColumns: true,
					scrollX: true,
					scrollCollapse: true,
					info: true,
					sort: true,
					data: inScopeAppInterfaces,
					defaultContent: '',
					stateSave: true,
					responsive: false,
					columnDefs: appInterfaceColumnDefs,
					language: {
					searchBuilder: {
					title: 'Filter:',
					condition: 'Condition',
					data: 'Select Column'
					}
					},
					layout: {
					topStart: {
					searchBuilder: {
					// config options here
					}
					},
					/* top: {
					search: {
					placeholder: 'Search'
					}
					}, */
					topEnd: {
					buttons: [
					'colvis',
					'copyHtml5',
					{
					extend: 'copyHtml5',
					exportOptions: {
					columns: ':visible'
					}
					},
					{
					extend: 'excelHtml5',
					exportOptions: {
					columns: ':visible'
					},
					},
					{
					extend: 'csvHtml5',
					exportOptions: {
					columns: ':visible'
					}
					}
					]
					}
					},
					/* buttons: [
					'colvis',
					'copyHtml5', 
					'excelHtml5',
					'csvHtml5'
					], */
					drawCallback: function (settings) {
					//do nothiong
					}
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
					});
					});
					
					//catalogueTable.columns.adjust();
					catalogueTable.columns.adjust().draw();
					
					$(window).resize( function () {
					catalogueTable.columns.adjust();
					});
					//END INITIALISE UP THE CATALOGUE TABLE
					}
					
					
					//function to redraw the view based on the current scope
					function redrawView() {
					essResetRMChanges();
					let appInterfaceypeInfo = {
					"className": "Application_Provider_Interface",
					"label": 'Application Interface',
					"icon": 'fa-exchange'
					}
					
					//let criticalityTierScopingDef = new ScopingProperty('criticalityTierIds', 'App_Business_Continuity_Criticality_Tier'); 
					//let hostingSitesScopingDef = new ScopingProperty('hostingSiteIds', 'Site');
					//let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
					//let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS'); 
					//let scopedAppInterfaces = essScopeResources(appInterfaceCatalogue, [criticalityTierScopingDef, hostingSitesScopingDef, drModelScopingDef, appIndivScopingDef], appInterfaceypeInfo);
					
					//inScopeAppInterfaces = scopedAppInterfaces.resources;
					
					inScopeAppInterfaces = appInterfaceCatalogue;
					//console.log('AFTER FILTER SCOPED APPS', inScopeAppInterfaces)
					
					//redraw the applications table
					drawAppInterfaceTable();
					}
					
					$(document).ready(function() {
					<!-- DEFINE APIS - the list of apis to call based on their data label GPT SHOULD PROVIDE-->
					const apiList = ['appMartAPI', 'infoMartAPI', 'ImpTechProdApi'];
					
					let hbFragment = $('#table-footer-template').html();
					tableFooterTemplate = Handlebars.compile(hbFragment);
					
					hbFragment = $('#inst-link-template').html();
					instLinkTemplate = Handlebars.compile(hbFragment);
					
					hbFragment = $('#inst-link-list-template').html();
					instLinkListTemplate = Handlebars.compile(hbFragment);
					
					hbFragment = $('#supp-tech-list-template').html();
					suppTechListTemplate = Handlebars.compile(hbFragment);
					
					async function executeFetchAndRender() {
					try {
					let responses = await fetchAndRenderData(apiList);
					<!--COPY FROM GPT, SHOULD MATCH THE ABOVE -->
					({ appMartAPI, infoMartAPI, ImpTechProdApi } = responses);
					
					const apus = appMartAPI.apus || [];
					const techMap = appMartAPI.application_technology || [];
					const infoMap = infoMartAPI.data_objects || [];
					const appInterfaces = appMartAPI.applications?.filter(app => app.type == 'Application_Provider_Interface') || [];
					
					appInterfaceCatalogue = appInterfaces.map(api => {
					const sourceApps = appMartAPI.apus.filter(apu => (apu.toAppId?.length > 0) &amp;&amp; (apu.fromAppId == api.id)).map(apu => {
					const sourceApp =  appMartAPI.applications?.find(app => app.id == apu.toAppId);
					return {
					"id": sourceApp.id,
					"name": sourceApp.name,
					"infoExchanged": apu.info
					}
					});
					const targetApps = appMartAPI.apus.filter(apu => (apu.fromAppId?.length > 0) &amp;&amp; (apu.toAppId == api.id)).map(apu => {
					const targetApp =  appMartAPI.applications?.find(app => app.id == apu.fromAppId);
					return {
					"id": targetApp.id,
					"name": targetApp.name,
					"infoExchanged": apu.info
					}
					});
					
					const techEntry = techMap.find(t => t.id === api.id);
					const environments = techEntry ? techEntry.environments || [] : [];
					
					const supportingTech = environments.flatMap(env =>
					(env.products || []).map(prod => ({
					"id": prod.tpr,
					"techProduct": {
					"id": prod.prod,
					"name": prod.prodname
					},
					"techComponent": {
					"id": prod.comp,
					"name": prod.compname
					}
					}))
					);
					
					return {
					"id": api.id,
					"name": api.name,
					"className": api.type,
					"ea_reference": api.ea_reference,
					"synonyms": api.synonyms || [],
					"supportingTech": supportingTech,
					"sourceApps": sourceApps,
					"targetApps": targetApps
					}
					});
					console.log('APP INTERFACE CATALOGUE', appInterfaceCatalogue);
					redrawView();
					}
					catch (error) {
					// Handle any errors that occur during the fetch operations
					console.error('Error fetching data:', error);
					}
					}
					executeFetchAndRender();
					});   
					
				</script>
				
			</body>
			
		</html>
	</xsl:template>
	
	
</xsl:stylesheet>
