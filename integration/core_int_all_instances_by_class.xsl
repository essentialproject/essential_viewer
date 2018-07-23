<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:param name="selectedClassId"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="allClasses" select="/node()/class[type = ':ESSENTIAL-CLASS' and own_slot_value[slot_reference = ':ROLE']/value = 'Concrete']"/>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allClasses[name = $allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value]/name"/>
	<xsl:variable name="allSlots" select="/node()/slot"/>
	<xsl:variable name="selectedClass" select="/node()/class[name = $selectedClassId]"/>

	<!-- END GENERIC LINK VARIABLES -->




	<xsl:variable name="instanceListView"/>

	<xsl:variable name="basicQueryString">
		<xsl:call-template name="RenderLinkText">
			<!--<xsl:with-param name="theXSL" select="$instanceListView/own_slot_value[slot_reference='report_xsl_filename']/value"/>-->
			<xsl:with-param name="theXSL">integration/core_int_all_instances_by_class.xsl</xsl:with-param>
			<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="fullQueryString">
		<xsl:value-of select="$basicQueryString"/>
		<xsl:text>&amp;selectedClassId=</xsl:text>
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
				<title>All Instances by Class</title>
				<script>
		            $(document).ready(function(){
		            // bind change event to select
		            $('#classList').bind('change', function () {
		            var url = "<xsl:value-of select="$fullQueryString"/>" + $(this).val(); // get selected value
		            if (url) { // require a URL
		            window.location = url; // redirect
		            }
		            return false;
		            });
		            });
		        </script>
				<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_instances tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
						
						var table = $('#dt_instances').DataTable({
						paging: true,
						deferRender:    true,
			            scrollY:        350,
			            scrollCollapse: true,
			            scroller:       true,
						info: false,
						sort: true,
						responsive: false,
						columns: [
						    { "width": "30%" },
						    { "width": "30%" },
						    { "width": "40%" }
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
 
						$('#simpleMode').on( 'click', function () {
						    table.destroy();
						    $('#simpleMode').hide();
						    $('#advancedMode').show();
						} );
						$('#advancedMode').on( 'click', function () {
						    location.reload();
						    $('#advancedMode').hide();
						    $('#simpleMode').show();
						} );
						$('#advancedMode').hide();
					});
				</script>
				<xsl:call-template name="dataTablesLibrary"/>
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
									<span class="text-darkgrey">All Instances by Class</span>
								</h1>
							</div>
						</div>
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<h2 class="text-primary">Select a Class</h2>
							<button class="btn btn-primary pull-right" id="simpleMode">Simple Mode</button>
							<button class="btn btn-primary pull-right" id="advancedMode">Advanced Mode</button>
							<form>
								<select id="classList">
									<xsl:for-each select="$allClasses">
										<xsl:sort select="name"/>
										<option>
											<xsl:if test="current()/name = $selectedClassId">
												<xsl:attribute name="selected" select="'selected'"/>
											</xsl:if>
											<xsl:value-of select="current()/name"/>
										</option>
									</xsl:for-each>
								</select>
							</form>

							<br/>
							<table class="table table-bordered table-striped" id="dt_instances">
								<thead>
									<tr>
										<th>ID</th>
										<th>Name</th>
										<th>Description</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>ID</th>
										<th>Name</th>
										<th>Description</th>
									</tr>
								</tfoot>
								<tbody>
									<xsl:variable name="allInstances" select="/node()/simple_instance[type = $selectedClassId]"/>
									<xsl:apply-templates mode="renderInstanceList" select="$allInstances">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									</xsl:apply-templates>
								</tbody>
							</table>

						</div>



						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template mode="renderInstanceList" match="node()">
		<xsl:variable name="currentInstance" select="current()"/>
		<tr>
			<td>
				<xsl:value-of select="$currentInstance/name"/>
			</td>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
