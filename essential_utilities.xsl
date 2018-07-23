<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="common/core_doctype.xsl"/>
	<xsl:include href="common/core_common_head_content.xsl"/>
	<xsl:include href="common/core_header.xsl"/>
	<xsl:include href="common/core_footer.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>

	<!-- param4 = the taxonomy term that will be used to scope the organisation model -->
	<xsl:param name="param4"/>

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
	<!-- 05.06.2013 JWC Added the eas namespace for the i18n framework -->
	<!-- 05.06.2013 JWC Added the Spreadsheet downloads -->

	<xsl:variable name="allReports" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'report_is_enabled']/value = 'true')]"/>
	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>
	<xsl:variable name="intArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Integration Extract Views']"/>
	<xsl:variable name="aSpreadsheetList" select="/node()/simple_instance[type = 'Spreadsheet_Specification']"/>
	<xsl:variable name="allSpreadsheetSpec" select="$aSpreadsheetList[own_slot_value[slot_reference = 'ss_enabled']/value = 'true']"/>

	<xsl:variable name="eaArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Enterprise Architecture Views')]"/>
	<xsl:variable name="busArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Business Architecture Views')]"/>
	<xsl:variable name="infArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Information Architecture Views')]"/>
	<xsl:variable name="appArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Application Architecture Views')]"/>
	<xsl:variable name="techArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Technology Architecture Views')]"/>
	<xsl:variable name="supportViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Support Views')]"/>

	<xsl:variable name="countEASpreadsheet" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name)]"/>
	<xsl:variable name="countBusSpreadsheet" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name)]"/>
	<xsl:variable name="countInfSpreadsheet" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name)]"/>
	<xsl:variable name="countAppSpreadsheet" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name)]"/>
	<xsl:variable name="countTechSpreadsheet" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name)]"/>
	<xsl:variable name="countSupportSpreadsheet" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $supportViewsTaxonomyTerm/name)]"/>
	<xsl:variable name="unClassifedSpreadsheets" select="$allSpreadsheetSpec except ($countEASpreadsheet union $countBusSpreadsheet union $countAppSpreadsheet union $countInfSpreadsheet union $countTechSpreadsheet union $countSupportSpreadsheet)"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>Essential Utilities</title>
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
									<span class="text-darkgrey">Essential Utilities</span>
								</h1>
							</div>
						</div>

						<!--Setup Integration Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-exchange icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Integration Extracts</h2>
							<div class="content-section">
								<p>Computer-readable extracts providing lists of specific objects stored in the architecture repository.</p>
								<div class="row">
									<xsl:apply-templates mode="Integrations" select="$allReports[(own_slot_value[slot_reference = 'element_classified_by']/value = $intArchViewsTaxonomyTerm/name)]"/>
								</div>
							</div>
							<hr/>
						</div>




						<!--Setup Description Section-->

						<xsl:if test="count($aSpreadsheetList) > 0">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>
								<h2 class="text-primary">Spreadsheet Data Capture Template Catalogue</h2>
								<div class="content-section">
									<xsl:choose>
										<xsl:when test="count($allSpreadsheetSpec) > 0">
											<p>The following table lists template spreadsheets that are available for download (in Excel 2004 XML format), which can be used for capturing and importing content into Essential Architecture Manager.</p>
											<div class="verticalSpacer_10px"/>
											<h3>Enterprise</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Enterprise"/>
											<div class="verticalSpacer_20px"/>
											<h3>Business</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Business"/>
											<div class="verticalSpacer_20px"/>
											<h3>Information</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Information"/>
											<div class="verticalSpacer_20px"/>
											<h3>Application</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Application"/>
											<div class="verticalSpacer_20px"/>
											<h3>Technology</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Technology"/>
											<div class="verticalSpacer_20px"/>
											<h3>Support</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Support"/>

											<div class="verticalSpacer_20px"/>
											<h3>Unclassified</h3>
											<div class="verticalSpacer_10px"/>
											<xsl:call-template name="Unclassified"/>
										</xsl:when>
										<xsl:otherwise>
											<em>No spreadsheet templates defined</em>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</div>
						</xsl:if>
					</div>
					<!-- ADD THE PAGE FOOTER -->
					<xsl:call-template name="Footer"/>

					<script>
				$(document).ready(function() {							
					// initialize tooltip
					$(".viewElement").tooltip({
					
					   // tweak the position
					   offset: [-10, -140],
					   
					   predelay: '500',
					   
					   relative: 'true',
					   
					   position: 'bottom',
					   
					   opacity: '0.9',
					
					   // use the "fade" effect
					   effect: 'fade'
					
					// add dynamic plugin with optional configuration for bottom edge
					}).dynamic({ bottom: { direction: 'down', bounce: true } });
				});
				</script>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template mode="Integrations" match="node()">
		<xsl:variable name="reportLabelName" select="own_slot_value[slot_reference = 'report_label']/value"/>
		<xsl:variable name="reportFilename" select="own_slot_value[slot_reference = 'report_xsl_filename']/value"/>

		<a class="noUL text-black" download="extract.txt">
			<xsl:call-template name="RenderLinkHref">
				<xsl:with-param name="theXSL" select="$reportFilename"/>
				<xsl:with-param name="theInstanceID" select="$param1"/>
				<xsl:with-param name="theHistoryLabel" select="concat($reportLabelName, ' - ', $param1)"/>
				<xsl:with-param name="theParam4" select="$param4"/>

				<!-- pass the id of the taxonomy term used for scoping as parameter 4-->
			</xsl:call-template>

			<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
				<p class="fontSemi larger">
					<xsl:value-of select="own_slot_value[slot_reference = 'report_label']/value"/>
				</p>
				<p>
					<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
					</xsl:call-template>
				</p>
			</div>


		</a>




	</xsl:template>

	<xsl:template name="Enterprise">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($countEASpreadsheet) = 0">
				<p>
					<em>No spreadsheets classified for this layer</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name)]">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Business">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($countBusSpreadsheet) = 0">
				<p>
					<em>No spreadsheets classified for this layer</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name)]">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Information">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($countInfSpreadsheet) = 0">
				<p>
					<em>No spreadsheets classified for this layer</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name)]">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Application">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($countAppSpreadsheet) = 0">
				<p>
					<em>No spreadsheets classified for this layer</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name)]">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Technology">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($countTechSpreadsheet) = 0">
				<p>
					<em>No spreadsheets classified for this layer</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name)]">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Support">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($countSupportSpreadsheet) = 0">
				<p>
					<em>No spreadsheets classified for this layer</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$allSpreadsheetSpec[(own_slot_value[slot_reference = 'element_classified_by']/value = $supportViewsTaxonomyTerm/name)]">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Unclassified">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:choose>
			<xsl:when test="count($unClassifedSpreadsheets) = 0">
				<p>
					<em>No unclassified spreadsheets available</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-35pc text-primary impact">Template Name</th>
							<th class="cellWidth-45pc text-primary impact">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Populated</th>
							<th class="cellWidth-10pc text-primary impact alignCentre">Empty</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="SpreadsheetTemplate" select="$unClassifedSpreadsheets">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="doPopulate" select="$doPopulate"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="SpreadsheetTemplate">
		<xsl:param name="doPopulate">false</xsl:param>
		<xsl:variable name="ssName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="ssDescription" select="own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="ssFilename" select="own_slot_value[slot_reference = 'ss_filename']/value"/>
		<tr>
			<td>
				<strong>
					<xsl:value-of select="$ssName"/>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($ssDescription) = 0">-</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$ssDescription"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<a class="noUL">
					<xsl:call-template name="RenderLinkHref">
						<xsl:with-param name="theXSL" select="'integration/int_excel_import_generation.xsl'"/>
						<xsl:with-param name="theInstanceID" select="current()/name"/>
						<xsl:with-param name="theUserParams" select="'populateSS=true'"/>
						<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
						<xsl:with-param name="theHistoryLabel">Spreadsheet Template Download - <xsl:value-of select="$ssName"/></xsl:with-param>
						<xsl:with-param name="theContentType" select="'application/ms-excel'"/>
						<xsl:with-param name="theFilename" select="$ssFilename"/>
					</xsl:call-template>
					<!--<img src="images/GreenArrow.png" alt="Populated"/>-->
					<div class="basicButton backColour9 text-white small">Download</div>
				</a>

			</td>
			<td>
				<a class="noUL">
					<xsl:call-template name="RenderLinkHref">
						<xsl:with-param name="theXSL" select="'integration/int_excel_import_generation.xsl'"/>
						<xsl:with-param name="theInstanceID" select="current()/name"/>
						<xsl:with-param name="theUserParams" select="'populateSS=false'"/>
						<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
						<xsl:with-param name="theHistoryLabel">Spreadsheet Template Download - <xsl:value-of select="$ssName"/></xsl:with-param>
						<xsl:with-param name="theContentType" select="'application/ms-excel'"/>
						<xsl:with-param name="theFilename" select="$ssFilename"/>
					</xsl:call-template>
					<!--<img src="images/RedArrow.png" alt="Empty"/>-->
					<div class="basicButton backColour10 text-white small">Download</div>
				</a>
			</td>
		</tr>

	</xsl:template>


</xsl:stylesheet>
