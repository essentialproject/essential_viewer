<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


	<xsl:output method="html"/>

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
	<!-- 11.05.2018 JP  Created	 -->



	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Capability', 'Business_Domain')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START CATALOGUE SPECIFIC VARIABLES -->
	<xsl:variable name="busCapListByName" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Business Capability Catalogue by Name')]"/>

	<xsl:variable name="businessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="businessProcesses" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $businessCaps/name]"/>
	<xsl:variable name="businessDomains" select="/node()/simple_instance[name = $businessCaps/own_slot_value[slot_reference = 'belongs_to_business_domain']/value]"/>

	<!-- END CATALOGUE SPECIFIC VARIABLES -->


	<xsl:template match="knowledge_base">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Capability Catalogue - Table View')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInstances"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<!--<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>-->
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$busCapListByName"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="eas:i18n('Name')"/>
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
						<!--Setup Catalogue Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>

								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogue')"/>
								</h2>

								<div>
									<p><xsl:value-of select="eas:i18n('Select a Business Capability, Business Process or Business Domain to navigate to the required view')"/>.</p>
									<xsl:call-template name="Index"/>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Index">

		<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_Processes tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_Processes').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "20%" },
									    { "width": "25%" },
									    { "width": "30%" },
									    { "width": "25%" }
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
								});
							</script>


		<table class="table table-striped table-bordered" id="dt_Processes">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Domain')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Capability')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Realising Business Processes')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Domain')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Capability')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Realising Business Processes')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:apply-templates mode="busCapRoe" select="$businessCaps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>

	</xsl:template>

	<xsl:template match="node()" mode="busCapRoe">
		<xsl:variable name="thisBusCap" select="current()"/>
		<xsl:variable name="thisBusinessProcesses" select="$businessProcesses[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCap/name]"/>
		<xsl:variable name="thisBusinessDomain" select="$businessDomains[name = $thisBusCap/own_slot_value[slot_reference = 'belongs_to_business_domain']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisBusinessDomain"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$thisBusCap"/>
				</xsl:call-template>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$thisBusinessProcesses">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>


	</xsl:template>

</xsl:stylesheet>
