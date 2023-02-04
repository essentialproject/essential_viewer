<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

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
				<title>Dashboard Editor</title>
				<link rel="stylesheet" href="js/chartjs/Chart.css"/>
				<script src="js/chartjs/Chart.min.js"/>
				<link rel="stylesheet" type="text/css" href="js/pivot/pivot.css"/>
				<script type="text/javascript" src="js/plotly/plotly-basic-latest.min.js"/>
				<script type="text/javascript" src="js/pivot/pivot.js"/>
				<script type="text/javascript" src="js/plotly/plotly_renderers.js"/>
				<script src="js/pivot/nrecopivottableext.js"/>
				<link href="js/pivot/nrecopivottableext.css" rel="stylesheet"/>
				<!--<script type="text/javascript" src="enterprise/pivottable/easdata/dashboard_builder_api_catalogue.js"/>
				<script type="text/javascript" src="enterprise/pivottable/easdata/dashboard_builder_app_list.js"/>
				<script type="text/javascript" src="enterprise/pivottable/easdata/dashboard_builder_buscap_list.js"/>
				<script type="text/javascript" src="enterprise/pivottable/easdata/dashboard_builder_org_list.js"/>
				<script type="text/javascript" src="enterprise/pivottable/easdata/dashboard_builder_georegion_list.js"/>
				<script type="text/javascript" src="enterprise/pivottable/easdata/dashboard_builder_qualifier_list.js"/>-->
				<style>
					.dialog
					{
						display: none;
						margin-left: 25vw;
						width: 50vw;
						z-index: 999;
						top: 10vh;
						position: absolute;
						background-color: white;
						border: thin solid black;
						padding: 0.25em;
					}
					
					.fa-caret-right {
						cursor:pointer;
					}
					
					.newWidgetDialogOptions
					{
						display: none;
					}<!--
					.ess-table-scroller
					{
						width: calc(100vw - 30px);
						overflow-x: scroll;
					}-->
					#easContainer
					{
						font-size: 16px;
					}
					
					.pvtAxisContainer,
					.pvtVals
					{
						border: 1px solid #ccc;
						background: #fff;
					}
					
					.pvtVals
					{
						width: 200px;
						min-width: 200px;
					}
					
					.pvtTable
					{
						table-layout: fixed;
					}<!--
					/* we need fixed layout or table will overflow container */
					
					.pvtUi
					{
						table-layout: fixed;
					}
					
					/* styles for responsive pivot UI + bootstrap-like styles */
					
					.pivotHolder table.pvtUi
					{
						table-layout: fixed;
					}
					
					.pivotHolder select
					{
						visibility: hidden;
					}
					
					.pivotHolder select.form-control
					{
						visibility: visible;
					}
					
					.pivotHolder > table.pvtUi,
					.pivotHolder table.pvtTable
					{
						width: 100%;
						margin-bottom: 0px;
					}
					
					.pivotHolder > table.pvtUi > tbody > tr > td,
					.pivotHolder > table.pvtUi > tbody > tr > th
					{
						border: 1px solid #ddd;
					}
					
					.pivotHolder .pvtAxisContainer li span.pvtAttr
					{
						height: auto;
						white-space: nowrap;
					}
					
					.pivotHolder .pvtAxisContainer.pvtUnused,
					.pivotHolder .pvtAxisContainer.pvtCols
					{
						vertical-align: middle;
					}
					
					.pivotHolder > table.pvtUi > tbody > tr:first-child > td:first-child
					{
						width: 250px;
					}
					
					.pivotHolder td.pvtRendererArea
					{
						padding-bottom: 0px;
						padding-right: 0px;
						border-bottom-width: 0px !important;
						border-right-width: 0px !important;
					}
					
					.pivotHolder td.pvtVals br
					{
						display: none;
					}
					
					.pvtRendererArea > div
					{
						overflow: auto;
					}
					
					.pvtTableRendererHolder
					{
						max-height: 600px; /* limit table height if needed */
					}
					
					.js-plotly-plot,
					.plot-container,
					.svg-container
					{
						width: 100%;
					}
					
					/* CSS hacks to give the third column most of the horizontal space */
					
					.pvtUi td
					{
						width: 5vw;
					}
					
					.pvtUi td + td
					{
						width: 32vw;
					}
					
					.pvtUi td + td + td
					{
						width: auto;
					}-->
				
					/*Sidebar Starts*/
					
					#sidebar{
						transition: all 0.3s;
						min-width: 250px;
						max-width: 250px;
						overflow-y: auto;
						overflow-x: hidden;
						background-color: #f5f9fc;
					}
					
					#sidebar .sidebar-header{
						padding: 10px;
						position: relative;
					}
					
					#sidebar ul.components{
						padding: 20px 0;
						border-bottom: 1px solid #47748b;
					}
					
					#sidebar ul p{
						color: #fff;
						padding: 10px;
					}
					
					#sidebar ul li a{
						padding: 10px;
						font-size: 1.1em;
						display: block;
					}
					#sidebar ul li a:hover{
						color: #7386D5;
						background: #fff;
					}
					
					#sidebar ul li.active > a,
					a[aria-expanded = "true"]{
						color: #fff;
						background: #6d7fcc;
					}
					
					#sidebar.active{
						margin-left: -250px;
					}
					
					#sidebarHide{
						position: absolute;
						right: 5px;
						top: 5px;
						color: #fff;
					}
					
					#sidebarHide:hover{
						opacity: 0.75;
						cursor: pointer;
					}
					
					#sidebarShow{
						position: fixed;
						left: 0;
						top: 110px;
						padding: 0 2px 0 2px;
						border: 1px solid #fff;
						border-left: none;
						border-radius: 0 4px 4px 0;
						/*background-color: #354052;*/
						box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
						color: #fff;
						z-index: 1000;
						margin-left: 0;
						transition: all 0.3s;
					}
					
					#sidebarShow.active{
						margin-left: -250px;
					
					}
					
					/*SideBar Ends*/
				
					.ess-wrapper{
					display: flex;
					width: 100%;
					align-items: stretch;
					min-height: calc(100vh - 60px);
					}
					
					.ess-content {
					width:100%;
					}
					.vertical-scroller {
						width: 100%;
						max-height: 45vh;
						overflow-y: auto;
					}
				
					.selectedItemList li {
						width: 100%;
						padding: 5px 10px;
						border-radius: 4px;
						box-shadow: 0 2px 2px #ccc;
						margin: 0 0 10px 0;
						position: relative;
						font-size: 12px;
						display: flex;
						line-height: 1.1em;
						align-items: center;
						min-height: 30px;
					}
					.selectedItemList li > i {
						position: absolute;
						top: 5px;
						right: 5px;
					}
				</style>
				<script type="text/javascript" src="enterprise/pivottable/easDashboardEditorv1.js"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				
				<div class="ess-wrapper">
					<!-- Sidebar -->
					<nav id="sidebar">
						<div class="sidebar-header">
							
							<h3 class="text-primary">Select Pivot Table</h3>
							<div id="sidebarHide"><i class="fa fa-times text-primary"/></div>
							<form name="dash" id="dash">	
								<select id="selectedWidgetSelect" name="selectedWidget" class="form-control"/>
								<!--<input id="nameInput" type="text" name="name" value="" class="form-control top-15"/>-->
								<div class="btn-group btn-group-justified top-15">
									<a class="btn btn-default" id="editButton" data-toggle="modal" data-target="#editTableModal"><i class="fa fa-edit right-5"/>Edit</a>
									<a class="btn btn-default" id="copyButton"><i class="fa fa-copy right-5"/>Copy</a>
									<a class="btn btn-default" id="removeButton"><i class="fa fa-trash right-5"/>Delete</a>
									<!--<button class="btn btn-default" id="saveButton"><i class="fa fa-save right-5"/>Save</button>-->
								</div>
								<div class="btn-group btn-group-justified top-15">
									<a class="btn btn-default" id="importButton"><i class="fa fa-download right-5"/>Import</a>
									<input type="file" id="importFileInput" accept=".json, .JSON" style="display:none;"/>
									<a class="btn btn-default" id="exportButton"><i class="fa fa-upload right-5"/>Export</a>
								</div>
								<a class="btn btn-success btn-block top-15" id="newButton" data-toggle="modal" data-target="#newTableModal"><i class="fa fa-plus right-5"/>New Table</a>
							</form>							
						</div>
					</nav>
					
					<div id="sidebarShow" class="active bg-primary">
						<i class="fa fa-caret-right fa-sm"/>
					</div>
					
					<div class="ess-content">
						<!--ADD THE CONTENT-->
						<div class="container-fluid">
							<div class="row">
								<div class="col-xs-12">
									<div class="page-header">
										<h1>
											<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Dashboard Builder: ')"/></span>
											<span id="current-table-name" class="text-primary"></span>
										</h1>
										<p id="current-table-desc">&#160;</p>
									</div>
								</div>
		
								<!--Setup Description Section-->
								<div class="col-xs-12">
									<!-- Modal -->
									<div class="modal fade" id="newTableModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
										<div class="modal-dialog modal-lg" role="document">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"/></span></button>
													<h4 class="modal-title" id="myModalLabel"><i class="fa fa-table right-5"/><strong>New Pivot Table</strong></h4>
												</div>
												<div class="modal-body">
													<div id="newWidgetDialog">												
														<label>Table Name</label>
														<input id="newWidgetDialogName" class="form-control" type="text" name="name" value="" placeholder="Please enter a name for your table"/>
														<label class="top-10">Description</label>
														<textarea id="newWidgetDialogDesc" rows="2" class="form-control" type="text" name="description" value="" placeholder="Please enter a description for your table"/>
														<br/>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionsstatic">
															<form id="newWidgetDialogFormstatic"> Content: <textarea name="innerHTML">Static Content</textarea>
															</form>
														</div>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionslinegraph">
															<form id="newWidgetDialogFormlinegraph">
																<div>Title: <input type="text" name="title"/></div>
																<div>Filled: <input type="checkbox" name="fill"/></div>
															</form>
														</div>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionspiegraph">
															<form id="newWidgetDialogFormpiegraph">
																<div>Title: <input type="text" name="title"/></div>
															</form>
														</div>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionspivottable">
															<form id="newWidgetDialogFormpivottable"> </form>
														</div>
														<label>Data Sources</label>
														<div id="newWidgetDialogDataSourcesContainer"/>
														<button class="btn btn-default" onclick="newWidgetDialog.onAddAnotherDataSourceClick()"><i class="fa fa-plus-square right-5"/>Add Another Data Source</button>
														<!--<div class="row top-15">
															<div class="col-sm-8">
																<h3>Search Data Sources</h3>
																<table class="table" id="dataSourcesTable">
																	<thead>
																		<tr>
																			<th>Name</th>
																			<th>Description</th>
																			<th>&#160;</th>
																		</tr>
																	</thead>
																	<tbody>
																		<tr>
																			<td>Applications</td>
																			<td>Apps description</td>
																			<td><button class="btn btn-sm btn-primary">Select</button></td>
																		</tr>
																		<tr>
																			<td>Geographic Regions</td>
																			<td>Geographic Regions description</td>
																			<td><button class="btn btn-sm btn-primary">Select</button></td>
																		</tr>
																		<tr>
																			<td>Business Capabilities</td>
																			<td>Bus Caps description</td>
																			<td><button class="btn btn-sm btn-primary">Select</button></td>
																		</tr>
																	</tbody>
																</table>
															</div>
															<div class="col-sm-4">
																<h3>Selected Data Sources</h3>
																<div class="vertical-scroller">
																	<ul id="selected-org-list" class="list-unstyled selectedItemList top-15">
																		<li class="bg-lightblue-100"><div class="relevant-item" eas-id="1">Technology Nodes</div><i eas-id="" class="remove-item-btn fa fa-minus-circle"></i></li>
																		<li class="bg-lightblue-100"><div class="relevant-item" eas-id="2">Technology Producs</div><i eas-id="" class="remove-item-btn fa fa-minus-circle"></i></li>
																		<li class="bg-lightblue-100"><div class="relevant-item" eas-id="3">Business Processes</div><i eas-id="" class="remove-item-btn fa fa-minus-circle"></i></li>
																	</ul>
																</div>
															</div>
														</div>-->
														
													</div>
												</div>
												<div class="modal-footer">
													<p id="newWidgetDialogError" class="pull-left textColourRed">&#160;</p>
													<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
													<button type="button" class="btn btn-success"  onclick="newWidgetDialog.onAddClick()">Create New Table</button>
												</div>
											</div>
										</div>
									</div>
									
									<div class="modal fade" id="editTableModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
										<div class="modal-dialog modal-lg" role="document">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"/></span></button>
													<h4 class="modal-title" id="myModalLabel"><i class="fa fa-table right-5"/><strong>Update Pivot Table</strong></h4>
												</div>
												<div class="modal-body">
													<div id="updateWidgetDialog">												
														<label>Table Name</label>
														<input id="editWidgetDialogName" class="form-control" type="text" name="name" value="" placeholder="Please enter a name for your table"/>
														<label class="top-10">Description</label>
														<textarea id="editWidgetDialogDesc" rows="2" class="form-control" type="text" name="description" value="" placeholder="Please enter a description for your table"/>
														<br/>
														<!--<div class="newWidgetDialogOptions" id="newWidgetDialogOptionsstatic">
															<form id="newWidgetDialogFormstatic"> Content: <textarea name="innerHTML">Static Content</textarea>
															</form>
														</div>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionslinegraph">
															<form id="newWidgetDialogFormlinegraph">
																<div>Title: <input type="text" name="title"/></div>
																<div>Filled: <input type="checkbox" name="fill"/></div>
															</form>
														</div>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionspiegraph">
															<form id="newWidgetDialogFormpiegraph">
																<div>Title: <input type="text" name="title"/></div>
															</form>
														</div>
														<div class="newWidgetDialogOptions" id="newWidgetDialogOptionspivottable">
															<form id="newWidgetDialogFormpivottable"> </form>
														</div>
														<label>Data Sources</label>
														<div id="newWidgetDialogDataSourcesContainer"/>
														<button class="btn btn-default" onclick="newWidgetDialog.onAddAnotherDataSourceClick()"><i class="fa fa-plus-square right-5"/>Add Another Data Source</button>-->
														<!--<div class="row top-15">
															<div class="col-sm-8">
																<h3>Search Data Sources</h3>
																<table class="table" id="dataSourcesTable">
																	<thead>
																		<tr>
																			<th>Name</th>
																			<th>Description</th>
																			<th>&#160;</th>
																		</tr>
																	</thead>
																	<tbody>
																		<tr>
																			<td>Applications</td>
																			<td>Apps description</td>
																			<td><button class="btn btn-sm btn-primary">Select</button></td>
																		</tr>
																		<tr>
																			<td>Geographic Regions</td>
																			<td>Geographic Regions description</td>
																			<td><button class="btn btn-sm btn-primary">Select</button></td>
																		</tr>
																		<tr>
																			<td>Business Capabilities</td>
																			<td>Bus Caps description</td>
																			<td><button class="btn btn-sm btn-primary">Select</button></td>
																		</tr>
																	</tbody>
																</table>
															</div>
															<div class="col-sm-4">
																<h3>Selected Data Sources</h3>
																<div class="vertical-scroller">
																	<ul id="selected-org-list" class="list-unstyled selectedItemList top-15">
																		<li class="bg-lightblue-100"><div class="relevant-item" eas-id="1">Technology Nodes</div><i eas-id="" class="remove-item-btn fa fa-minus-circle"></i></li>
																		<li class="bg-lightblue-100"><div class="relevant-item" eas-id="2">Technology Producs</div><i eas-id="" class="remove-item-btn fa fa-minus-circle"></i></li>
																		<li class="bg-lightblue-100"><div class="relevant-item" eas-id="3">Business Processes</div><i eas-id="" class="remove-item-btn fa fa-minus-circle"></i></li>
																	</ul>
																</div>
															</div>
														</div>-->								
													</div>
												</div>
												<div class="modal-footer">
													<p id="editWidgetDialogError" class="pull-left textColourRed">&#160;</p>
													<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
													<button id="update-table-btn" type="button" class="btn btn-success">Update</button>
												</div>
											</div>
										</div>
									</div>
									
								</div>
								<div class="col-xs-12">
									<div class="ess-table-scroller">
										<div id="easContainer"/>
									</div>
								</div>
								<!--Setup Closing Tags-->
							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
