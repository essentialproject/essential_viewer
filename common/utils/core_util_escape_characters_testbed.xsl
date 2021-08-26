<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_doctype.xsl"/>
	<xsl:include href="../../common/core_common_head_content.xsl"/>
	<xsl:include href="../../common/core_header.xsl"/>
	<xsl:include href="../../common/core_footer.xsl"/>
	<xsl:include href="../../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	<xsl:variable name="allInstances" select="/node()/simple_instance[type = $linkClasses]"/>
	
	<xsl:variable name="testReportAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Application List']"/>
	<xsl:variable name="testAPIDataPath">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$testReportAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>

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
				<title>Escape Characters Test</title>
				<style>
					td {white-space:pre-wrap;}
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<script id="table-row-template" type="text/x-handlebars-template">
					{{#each this}}
						<tr>
							<td>{{name}}</td>
							<td>{{{ink}}}</td>
							<td>{{description}}</td>
						</tr>
					{{/each}}
				</script>
				
				
				<script>
					var apiDataPath = '<xsl:value-of select="$testAPIDataPath"/>';
					
					var promise_loadViewerAPIData = function(apiDataSetURL) {
						return new Promise(function (resolve, reject) {
							if (apiDataSetURL != null) {
							var xmlhttp = new XMLHttpRequest();
							xmlhttp.onreadystatechange = function () {
							if (this.readyState == 4 &amp;&amp; this.status == 200) {
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
					
					
					var jsonInHtmlData = [
						<xsl:apply-templates select="$allInstances" mode="JSONInHTML"/>
					];
					
					var jsonFromAPIData = [];
					
					
					function drawJSONTable(tableName, tableData) {
						
						$('#' + tableName + ' tfoot th').each( function () {
							let title = $(this).text();
							$(this).html( '<input type="text" placeholder="Search '+title+'"></input>' );
						} );
							
						//create the table
						let thisTable = $('#' + tableName).DataTable({
							scrollY: "35vh",
							scrollCollapse: false,
							paging: false,
							info: false,
							sort: true,
							responsive: false,
							data: tableData,
							rowId: 'id',
							columns: [	
								{
									"data" : "name",
									"width": "30%",
									"render": function(d) {
										if(d != null){              
											return d;
										} else {
											return "-";
										}
									}
								},
								{
									"data" : "link",
									"width": "30%",
									"render": function(d) {
										if(d != null){              
											return d;
										} else {
											return "-";
										}
									}
								},
								{
									"data" : "description",
									"width": "40%",
									"render": function(d) {
										if(d != null){              
											return d;
										} else {
											return "-";
										}
									}
								}
							],
							"order": [[0, 'asc']],
							dom: 'frtip'
						});
							
							
							
						// Apply the search
						thisTable.columns().every( function () {
							var that = this;
							
							$( 'input', this.footer() ).on( 'keyup change', function () {
							if ( that.search() !== this.value ) {
							that
							.search( this.value )
							.draw();
							}
							});
						} );
							
						thisTable.columns.adjust();
							
						$(window).resize( function () {
							thisTable.columns.adjust();
						});
					}
					
					function directTextDataTable(){
						// Setup - add a text input to each footer cell
						$('#dt_directText tfoot th').each( function () {
							var title = $(this).text();
							$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
						} );
						
						let table = $('#dt_directText').DataTable({
							scrollY: "350px",
							scrollCollapse: true,
							paging: false,
							info: false,
							sort: true,
							responsive: true,
							columns: [
							{ "width": "30%" },
							{ "width": "30%", "type": "html" },
							{ "width": "40%" }
							],
							dom: 'Bfrtip',
							buttons: [
								'copyHtml5', 
								'excelHtml5',
								'csvHtml5',
								'pdfHtml5', 'print'
							]
						});
					
					
						// Apply the search
						table.columns().every( function () {
						var that = this;
						
						$( 'input', this.footer() ).on( 'keyup change', function () {
							if ( that.search() !== this.value ) {
							that
							.search( this.value )
							.draw();
							}
							} );
						} );
						
						table.columns.adjust();
						
						$(window).resize( function () {
							table.columns.adjust();
						});
					
					}
					
					$(document).ready(function(){
					
						var hbFragment = $("#table-row-template").html();
						let hbTemplate = Handlebars.compile(hbFragment);
					
						drawJSONTable('dt_jsonInHTML', jsonInHtmlData);
						
						
						promise_loadViewerAPIData(apiDataPath)
						.then(function(response) {
							jsonFromAPIData = response.applications;
							drawJSONTable('dt_jsonFromAPI', jsonFromAPIData);
						});
					
						directTextDataTable();
						
					});
				</script>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Escape Characters Test</span>
								</h1>
							</div>
						
						
						<!-- Nav tabs -->
						<ul class="nav nav-tabs" role="tablist" id="pageTabs">
							<li role="presentation" class="active"><a href="#tabTextInHTML" aria-controls="textInHtml" role="tab" data-toggle="tab">Text In HTML</a></li>
							<li role="presentation"><a href="#tabJSONInHTML" aria-controls="jsonInHtml" role="tab" data-toggle="tab">JSON In HTML</a></li>
							<li role="presentation"><a href="#tabJSONFromAPI" aria-controls="jsonFromAPI" role="tab" data-toggle="tab">JSON From API</a></li>
						</ul>
						
						<div class="tab-content">
							<!--Text in HTML Tab-->
							<div role="tabpanel" class="tab-pane active" id="tabTextInHTML">
								<div class="top-15 clearfix"/>
								<table id="dt_directText" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Link')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$allInstances" mode="TextInHTML"/>										
									</tbody>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Link')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</tfoot>
								</table>
								<div class="clearfix bottom-30"/>
							</div>
							<!--JSON In HTML Tab-->
							<div role="tabpanel" class="tab-pane active" id="tabJSONInHTML">
								<div class="top-15 clearfix"/>
								<table id="dt_jsonInHTML" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Link')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<!--<xsl:apply-templates select="$allInstances" mode="TextInHTML"/>	-->									
									</tbody>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Link')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</tfoot>
								</table>
								<div class="clearfix bottom-30"/>
							</div>
							<!--JSON From API Tab-->
							<div role="tabpanel" class="tab-pane active" id="tabJSONFromAPI">
								<div class="top-15 clearfix"/>
								<table id="dt_jsonFromAPI" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Link')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<!--<xsl:apply-templates select="$allInstances" mode="TextInHTML"/>	-->									
									</tbody>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Link')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</tfoot>
								</table>
								<div class="clearfix bottom-30"/>
							</div>
						</div>

						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="TextInHTML">
		<xsl:variable name="this" select="current()"/>

		<tr>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="JSONInHTML">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:value-of select="$thisName"/>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"description": "<xsl:value-of select="$thisDesc"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
