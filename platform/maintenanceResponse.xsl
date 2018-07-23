<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html"/>

	<xsl:param name="theMessage"/>
	<xsl:param name="theRealPath"/>

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
	<!-- View to render the response from the Essential Viewer Maintenance Service -->
	<!-- 15.11.2011	JWC First implementation	 -->



	<xsl:template match="ess:errorsourcedoc">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Essential Viewer - Maintenance Service')"/>
				</title>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="current()" mode="Page_Content"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<!--ADD THE CONTENT-->
	<xsl:template match="node()" mode="Page_Content">
		<!-- Get the name of the application provider -->
		<xsl:variable name="viewerVersion" select="ess:viewerversion"/>
		<xsl:variable name="sourceApp" select="ess:sourceapp"/>

		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<xsl:value-of select="eas:i18n('Essential Viewer Maintenance Service')"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="$viewerVersion"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="eas:i18n('Response Report')"/>
						</h1>
					</div>
				</div>

				<!-- Setup the main error report message -->
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-check icon-section icon-color"/>
					</div>

					<h2>
						<xsl:value-of select="eas:i18n('Maintenance Service')"/>
					</h2>

					<div class="content-section">
						<h4>
							<xsl:value-of select="eas:i18n('Response from Maintenance Service:')"/>
						</h4>
						<p class="text-primary">
							<xsl:value-of select="eas:i18n($theMessage)"/>
						</p>
						<xsl:if test="string-length($theRealPath) > 0">
							<p><xsl:value-of select="eas:i18n('See the web application logs for more information')"/>.</p>
							<p><xsl:value-of select="eas:i18n('Attempting to read cache configuration file in the directory')"/>: <xsl:value-of select="$theRealPath"/></p>
						</xsl:if>
					</div>
					<hr/>
				</div>

				<!--Setup About This View Section-->
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-info-circle icon-section icon-color"/>
					</div>
					<h2>
						<xsl:value-of select="$sourceApp"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="eas:i18n('Platform Information')"/>
					</h2>
					<div class="content-section">
						<p><xsl:value-of select="eas:i18n('Version')"/>: <xsl:text> </xsl:text><xsl:value-of select="$viewerVersion"/></p>
					</div>
					<hr/>
				</div>
				<!--Sections end-->
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
