<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

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
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Component', 'Technology_Capability', 'Supplier', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="techProdListByVendorCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Vendor')"/>
	<xsl:variable name="techProdListByCapCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Technology Capability')"/>
	<xsl:variable name="techProdListByNameCatalogue" select="eas:get_report_by_name('Core: Technology Product Catalogue by Technology Component')"/>


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

	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>

	<xsl:variable name="offStrategyStyle">backColourRed</xsl:variable>

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
				<title>
					<xsl:value-of select="eas:i18n('Technology Catalogue - Simple')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<style type="text/css">
					.standardBadge{ 	
						width: 90px; 
						height: 15px;
						font-size: x-small; 
						border: 1px solid #eee; 
						text-align: center; 
						border-radius: 10px; 
						-webkit-box-shadow: #666 2px 2px 0px 0px; 
						-moz-box-shadow: #666 2px 2px 0px 0px; 
						box-shadow: #aaa 2px 2px 0px 0px; 
						padding: 2px 5px;
					 }
					
					.legendIcon{
						font-size: 1.2em;
					}
				</style>
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
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>:&#160;</span>
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
							<div>
								<p>
									<xsl:value-of select="eas:i18n('This table lists all the Technology Products in use and allows download as CSV')"/>
								</p>
								<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_techProd tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_techProd').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "15%" },
									    { "width": "35%" },
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
								<!--<xsl:call-template name="legend"/>-->
								<table id="dt_techProd" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Supplier')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Product')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
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
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											
										</tr>
									</tfoot>
									<tbody>
										<xsl:apply-templates select="/node()/simple_instance[type = 'Technology_Product']" mode="Catalogue">
											<xsl:sort select="current()/own_slot_value[slot_reference = 'name']/value" order="ascending"/>
										</xsl:apply-templates>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="Catalogue">
        <xsl:variable name="supplier" select="$allSuppliers[name = current()/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$supplier"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/>
			</td>
		</tr>
	</xsl:template>
	
	
	<!--<xsl:template name="legend">
		<xsl:if test="count($allTechProdStandards) > 0">
			<div class="keyContainer">
				<div class="float-left keySampleLabel"><xsl:value-of select="eas:i18n('Standards Compliance Legend')"/>:</div>
				<xsl:for-each select="$allStandardStrengths">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
					<xsl:variable name="thisStandardStyle" select="$allStandardStyles[name = current()/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
					<xsl:variable name="thisStandardStyleIcon" select="$thisStandardStyle/own_slot_value[slot_reference = 'element_style_icon']/value"/>
					<xsl:variable name="thisStandardStyleClass" select="$thisStandardStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>
					
					<div class="float-left keySampleLabel {$thisStandardStyleClass}">
						<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
					</div>
					<div class="float-left"><i class="legendIcon {$thisStandardStyleClass} {$thisStandardStyleIcon}"/></div>
				</xsl:for-each>
				<div class="float-left keySampleLabel textColourRed"><xsl:value-of select="eas:i18n('Off Strategy')"></xsl:value-of></div>
				<div class="float-left"><i class="legendIcon {$offStrategyStyle}"/></div>
			</div>
		</xsl:if>
	</xsl:template>-->


</xsl:stylesheet>
