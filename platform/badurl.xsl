<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html"/>

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
	<!-- 08.06.2010 JWC	Create a redirect page that is presented when a bad URL is requested -->
	<!-- 10.11.2011	JWC	Re-styled for EV3 -->


	<xsl:template match="pro:knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Essential Viewer')"/>
				</title>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:call-template name="Page_Content"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<!--ADD THE CONTENT-->
	<xsl:template match="node()" name="Page_Content">
		<!-- Get the name of the application provider -->
		<div class="container-fluid">
			<div class="row">
				<div>
					<div class="col-xs-12">
						<div class="page-header">
							<h1>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Essential Viewer')"/></span>&#160; <span class="text-primary"><xsl:value-of select="eas:i18n('Error Report')"/></span>
							</h1>
						</div>
					</div>
				</div>

				<!-- Setup the main error report message -->
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-info-circle icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Unrecognised URL requested')"/>
					</h2>

					<div class="content-section">
						<p><xsl:value-of select="eas:i18n('You have requested a URL that could not be found in Essential Viewer. Please update any bookmarks that might have brought you here and follow this link to the')"/>&#160;<a>
								<xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=home.xsl&amp;PMA=</xsl:text><xsl:text>&amp;LABEL=Home</xsl:text>
								</xsl:attribute>&#160;<xsl:value-of select="eas:i18n('Essential Viewer Homepage ')"/></a></p>
					</div>
					<hr/>
				</div>

				<!--Sections end-->
			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>
