<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content_NG.xsl"/>
	<xsl:include href="../common/core_header_NG.xsl"/>
	<xsl:include href="../common/core_footer_NG.xsl"/>
	<xsl:include href="../common/core_external_repos_ref_NG.xsl"/>
	<xsl:include href="../common/core_external_doc_ref_NG.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

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


	<!-- param1 = the Report Constant tha dictates the type of documents to be listed -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

	<xsl:param name="reportConstantXML"/>
	<xsl:param name="allDocRefsXML"/>
	<xsl:param name="allDatesXML"/>
	<xsl:param name="orgScopeTermXML"/>
	<eas:apiRequests>
		{
			"apiRequestSet": [
				<!-- Get single instance with ID matching the "theSubjectID" parameter-->
				{"variable": "reportConstantXML", "query": "/instances/id/{param1}"},
				{"variable": "orgScopeTermXML", "query": "/instances/id/{param4}"},
				{"variable": "allDocRefsXML", "query": "/instances/type/External_Reference_Link"},
				{"variable": "allDatesXML", "query": "/instances/supertype/Date/slots"}
			]
		}
	</eas:apiRequests>
	<xsl:variable name="reportConstant" select="$reportConstantXML//simple_instance"/>
	<xsl:variable name="repoDocRefs" select="$allDocRefsXML//simple_instance"/>
	<xsl:variable name="repoDates" select="$allDatesXML//simple_instance"/>
	<xsl:variable name="orgScopeTerm" select="$orgScopeTermXML//simple_instance"/>	

	<!-- Get all of the required types of instances in the repository -->
	<!-- <xsl:variable name="reportConstant" select="/node()/simple_instance[name = $param1]"/> -->
	<xsl:variable name="reportConstantName" select="$reportConstant/own_slot_value[slot_reference = 'report_constant_short_name']/value"/>
	<xsl:variable name="reportConstantDesc" select="$reportConstant/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="allDocRefs" select="$repoDocRefs[name = $reportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="allDates" select="$repoDates[name = $allDocRefs/own_slot_value[slot_reference = 'erl_date']/value]"/>
	<!-- <xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $param4]"/> -->

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($param4) > 0">
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="pageLabel">
					<xsl:value-of select="concat($reportConstantName, ' (', $orgScopeTermName, ')')"/>
				</xsl:variable>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="inScopeDocRefs" select="$allDocRefs[own_slot_value[slot_reference = 'element_classified_by']/value = $param4]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="$reportConstantName"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeDocRefs">
			<xsl:value-of select="$allDocRefs"/>
		</xsl:param>

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
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
									<span class="text-primary"><xsl:value-of select="eas:i18n('Document')"/>:&#160; </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
							</div>
						</div>


						<!--Setup Description Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="string-length($reportConstantDesc) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No description captured for this type of document')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$reportConstantDesc"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Documents Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Document List')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($inScopeDocRefs) = 0">
										<p>
											<em><xsl:value-of select="eas:i18n('No')"/>&#160; <xsl:value-of select="$reportConstantName"/>&#160; <xsl:value-of select="eas:i18n('documents have been published')"/></em>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<xsl:value-of select="eas:i18n('The following documents are available to view')"/>
											<br/>
										</p>
										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-25pc">
														<xsl:value-of select="eas:i18n('Document Name')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Notes')"/>
													</th>
													<th class="cellWidth-15pc">
														<xsl:value-of select="eas:i18n('Author')"/>
													</th>
													<th class="cellWidth-15pc">
														<xsl:value-of select="eas:i18n('Email')"/>
													</th>
													<th class="cellWidth-15pc">
														<xsl:value-of select="eas:i18n('Published Date')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="DocReference" select="$inScopeDocRefs">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>

									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="node()" mode="DocReference">
		<xsl:variable name="drName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="drNotes" select="own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="drAuthor" select="own_slot_value[slot_reference = 'erl_source_name']/value"/>
		<xsl:variable name="drEmail" select="own_slot_value[slot_reference = 'erl_source_email']/value"/>
		<xsl:variable name="drURL" select="own_slot_value[slot_reference = 'external_reference_url']/value"/>
		<xsl:variable name="drDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'erl_date']/value]"/>

		<tr>
			<td>
				<a href="{$drURL}">
					<xsl:value-of select="$drName"/>
				</a>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($drNotes) = 0">
						<em>-</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$drNotes"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($drAuthor) = 0">
						<em>
							<xsl:value-of select="eas:i18n('Author not defined')"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$drAuthor"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($drEmail) = 0">
						<em>
							<xsl:value-of select="eas:i18n('No email address provided')"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="concat('mailto:', $drEmail)"/>
							</xsl:attribute> Link </a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($drDate) = 0">
						<em>
							<xsl:value-of select="eas:i18n('Published date not defined')"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="drDateAsXSLDate" select="eas:get_start_date_for_essential_time($drDate)"/>
						<xsl:call-template name="FullFormatDate">
							<xsl:with-param name="theDate" select="$drDateAsXSLDate"/>
						</xsl:call-template>
						<!--		<xsl:variable name="drFormattedDate" select="format-date($drDateAsXSLDate, '[D1o] [MNn], [Y]')"/>
						<xsl:value-of select="$drFormattedDate"/>  -->
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
