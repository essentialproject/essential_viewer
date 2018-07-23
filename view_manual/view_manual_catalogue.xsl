<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>

	<!-- param4 = the taxonomy term that will be used to scope the organisation model -->
	<xsl:param name="param4"/>

	<xsl:variable name="anyReports" select="/node()/simple_instance[(type = 'Report')][string-length(own_slot_value[slot_reference='report_help_filename']/value)&gt;0]"/>
	<xsl:variable name="allReports" select="$anyReports[own_slot_value[slot_reference = 'report_is_enabled']/value = 'true']"/>
	<xsl:variable name="eaArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Enterprise Architecture Views')]"/>
	<xsl:variable name="busArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Business Architecture Views')]"/>
	<xsl:variable name="infArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Information Architecture Views')]"/>
	<xsl:variable name="appArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Application Architecture Views')]"/>
	<xsl:variable name="techArchViewsTaxonomyTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Technology Architecture Views')]"/>


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
	<!-- 18 Jan 2012 - NJW Created -->
	<!-- 26.01.2012	JWC Fixed the filter label -->
	<!-- 27.01.2012 JWC Hide links to Views that have no manual page -->


	<xsl:template match="pro:knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>View Manual Catalogue</title>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary">View Manual Catalogue</span>
								</h1>
								<div class="verticalSpacer_10px"/>
								<h3>Enterprise Views</h3>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="Enterprise"/>
								<div class="verticalSpacer_20px"/>
								<h3>Business Views</h3>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="Business"/>
								<div class="verticalSpacer_20px"/>
								<h3>Information Views</h3>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="Information"/>
								<div class="verticalSpacer_20px"/>
								<h3>Application Views</h3>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="Application"/>
								<div class="verticalSpacer_20px"/>
								<h3>Technology Views</h3>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="Technology"/>
							</div>

							<!--Setup Closing Tags-->
						</div>


					</div>
				</div>


				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="Enterprise">
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">View Name</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="viewDetails" select="$allReports[(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name)]"/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="Business">
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">View Name</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="viewDetails" select="$allReports[(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name)]"/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="Information">
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">View Name</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="viewDetails" select="$allReports[(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name)]"/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="Application">
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">View Name</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="viewDetails" select="$allReports[(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name)]"/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="Technology">
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">View Name</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="viewDetails" select="$allReports[(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name)]"/>
			</tbody>
		</table>
	</xsl:template>


	<xsl:template mode="viewDetails" match="node()">
		<xsl:variable name="reportLabelName" select="own_slot_value[slot_reference = 'report_label']/value"/>
		<xsl:variable name="reportHelpFilename" select="own_slot_value[slot_reference = 'report_help_filename']/value"/>
		<tr>
			<td>
				<xsl:choose>
					<!-- Only render a link if the view manual is defined -->
					<xsl:when test="string-length($reportHelpFilename) > 0">
						<a>
							<xsl:call-template name="RenderLinkHref">
								<xsl:with-param name="theXSL" select="$reportHelpFilename"/>
								<xsl:with-param name="theInstanceID" select="$param1"/>
								<xsl:with-param name="theHistoryLabel" select="concat($reportLabelName, ' - ', $param1)"/>
								<xsl:with-param name="theParam4" select="$param4"/>
								<!-- pass the id of the taxonomy term used for scoping as parameter 4-->
							</xsl:call-template>
							<xsl:value-of select="$reportLabelName"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<!-- Otherwise, just the name -->
						<xsl:value-of select="$reportLabelName"/>
					</xsl:otherwise>
				</xsl:choose>

			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>

	</xsl:template>



</xsl:stylesheet>
