<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
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
				<title>Launchpad Plus Loaders</title>
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
				                    <span class="text-primary">
				                        <xsl:value-of select="eas:i18n('View')" />: </span>
				                    <span class="text-darkgrey">Launchpad Plus Loaders</span>
				                </h1>
                                <p style="font-size:12pt">
                                Populate the Launchpad foundation first and import your data before extracting these files.  These sheets pull the imported information into an Excel file, allowing you to capture additional data to populate other views.  <br/>Notes:<br/>
                                    <i class="fa fa-info-circle"></i> When you click the spreadsheet link it will download an XML file.  <b>Open this file with Excel.</b><br/>
                                    <i class="fa fa-info-circle"></i> Do not edit the purple sheets, they will not be imported. We recommend you don't edit the pink worksheets.   
                                </p>
				            </div>
						</div>
						<div class="col-xs-12">
								<h3><i class="fa fa-file"></i> Launchpad Pre-Complete</h3>
								<p style="font-size:12pt">A pre-completed spreadsheet based on data in a populated repository</p>
								<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/l4_launchpad_export.xsl&amp;CT=application/ms-excel&amp;FILE=l4_launchpad_export.xml&amp;cl=en-gb">
	
									<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Launchpad as Excel</div>
								</a><br/>
							   
						   <hr/> 
							   
							</div>
						<div class="col-xs-12">
			<h3>Launchpad Plus</h3>
			<table class="table table-striped">
				<thead>
					<tr>
						<th>Workbook</th>
						<th>Description</th>
						<th/>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><i class="fa fa-file"></i> Strategic Plans</td>
						<td> Importing/Exporting of strategic plans, you can also use this import just programmes and/or projects if you wish</td>
						<td>
							<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_strategic_plans_creation.xsl">
								<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Strategic Plans Export/Import</div>
							</a>
						</td>
					</tr>
					<tr>
					<td><i class="fa fa-file"></i> Application Dependency</td>
					<td>Importing/Exporting of bulk application dependencies</td>
					<td>	
						<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_app_dependencies.xsl">
						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Application Dependency Export/Import</div>
						</a>
					</td>
					</tr>
					<tr>
					<td><i class="fa fa-file"></i> Control Frameworks</td>
					<td>Bulk importing/exporting of frameworks such as NIST, ISO27001 and related assessments</td>
					<td>									
						<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_framework_manager.xsl">	
						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Framework Export/Import</div>
					</a>
					</td>
					</tr>
					<tr>
						<td><i class="fa fa-file"></i> Strategy Planner</td>
						<td>Importing/Exporting of customer journeys for use with the strategy planner</td>
						<td>
						<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_strategy_planner.xsl">
						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Strategy Planner Export/Import</div>
						</a>
						</td>
					</tr>
					<tr>
						<td><i class="fa fa-file"></i> Technology Reference</td>
						<td>Data to support the Strategic Technology Product Selector and technology reference models</td>
						<td>
						<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_technology_reference.xsl">
						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Technology Reference Export/Import</div>
						</a>
						</td>
					</tr>
					<tr>
						<td><i class="fa fa-file"></i> Technology Lifecycles</td>
						<td>Data to support Technology Product lifecycles, both internal and external</td>
						<td>
							<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_tech_lifecycles.xsl">

						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Technology Lifecycle Export/Import</div>
						</a>
						</td>
					</tr>
					<tr>
						<td><i class="fa fa-file"></i>  Supplier Contract Management</td>
						<td>This supports the import of supplier contracts for processes, applications and/or technology</td>
						<td>
							<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_suppliers.xsl">

						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Supplier Contract Export/Import</div>
						</a>
						</td>
					</tr>
					 
					<tr>
						<td><i class="fa fa-file"></i> Application KPIs</td>
						<td>This supports the import of KPis for applications using performance measures</td>
						<td>
							<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_perf_measures.xsl">

						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Application KPIs Export/Import</div>
						</a>
						</td>
					</tr>
				 
					<tr>
						<td><i class="fa fa-file"></i> Value Streams</td>
						<td>This supports the import of value streams</td>
						<td>
							<a class="noUL" href="report?XML=reportXML.xml&amp;XSL=integration/core_el_launchpadplus_value_streams.xsl">

						<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10">Go to Value Stream Export/Import</div>
						</a>
						</td>
					</tr>
				</tbody>
				</table>
				
			</div>
		</div>
	</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
