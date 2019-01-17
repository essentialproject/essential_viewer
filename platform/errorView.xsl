<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html"/>

	<xsl:param name="theMessage"/>
	<xsl:param name="theFriendlyMessage"/>
	<!--<xsl:param name="theStackTrace"/>-->
	<xsl:param name="theTransformerError"/>


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
	<!-- 08.11.2011	JWC First implementation	 -->
	<!-- 11.11.2011	JWC Added theFriendlyMessage parameter -->
	<!-- 04.07.2018	JWC Commented out the detailed stack trace -->


	<xsl:template match="ess:errorsourcedoc">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Essential Viewer - Error')"/>
				</title>
				<script type="text/javascript">
				   $(document).ready(function(){
				   		$("#sectionTrace").hide();
					      $("#stackTrace").click(function(){
					        if ($("#stackTrace").is(":checked"))
					        {
					            $("#sectionTrace").show("slow");
					        }
					        else
					        {      
					            $("#sectionTrace").hide("slow");
					        }
					      });
					});
				</script>
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
		<!--start script to control the show hide of individual sections - requires jquery-->

		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1 class="text-primary">Oops!</h1>
					</div>
					<div class="sectionIcon">
						<i class="fa fa-warning icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Essential Viewer Error')"/>
					</h2>
					<div class="content-section">
						<p><xsl:value-of select="eas:i18n('Oops!')"/>&#160; <xsl:value-of select="$theFriendlyMessage"/>
						</p>
						<p>
							<xsl:value-of select="$theMessage"/>
						</p>
						<p>
							<xsl:choose>
								<xsl:when test="contains($theTransformerError, 'Server returned HTTP response code: 403')">
									<xsl:value-of select="eas:i18n('Essential Viewer Error: Access to the requested view is denied')"/>.<span>&#160;</span>
									<xsl:value-of select="eas:i18n('Please contact the Essential Project Team to gain access to this view')"/>.<span>&#160;</span>
									<a href="http://www.enterprise-architecture.org/contact.php"><xsl:value-of select="eas:i18n('Contact us')"/></a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$theTransformerError"/>
								</xsl:otherwise>
							</xsl:choose>
						</p>
						<h5><xsl:value-of select="eas:i18n('Enable the Detailed Error Message filter to view more information about this error')"/>. </h5>
						<p>
							<xsl:value-of select="eas:i18n('For more information about how to resolve this error, visit')"/>&#160; <a>
								<xsl:attribute name="href">http://www.enterprise-architecture.org/reporting-tutorials/199-essential-viewer-errors</xsl:attribute><xsl:value-of select="eas:i18n('Essential Viewer Error Messages articles')"/>. </a>
						</p>
						<!--<form>
							<label for="stackTrace">
								<xsl:value-of select="eas:i18n('Show Detailed Error Message')"/>
								<span>:&#160;</span>
							</label>
							<input type="checkbox" id="stackTrace"/>
						</form>-->
					</div>
					<hr/>
				</div>


				<!--Setup About This View Section-->
				<!--<div id="sectionTrace">
					<div class="col-xs-12">
						<div class="sectionIcon">
							<i class="fa fa-gears icon-section icon-color"/>
						</div>

						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Detailed Error Messages')"/>
						</h2>

						<div class="content-section">
							<p>
								<pre><xsl:value-of select="$theStackTrace"/></pre>
							</p>
						</div>
						<hr/>
					</div>
				</div>
				-->
				<div id="sectionEngineDetails">
					<div class="col-xs-12">
						<div class="sectionIcon">
							<i class="fa fa-info-circle icon-section icon-color"/>
						</div>
						<div class="content-section">
							<h4><xsl:value-of select="$sourceApp"/>&#160;<xsl:value-of select="eas:i18n('Platform Information')"/></h4>
							<p><xsl:value-of select="eas:i18n('Version')"/>: <xsl:value-of select="$viewerVersion"/></p>
						</div>
						<hr/>
					</div>
				</div>

			</div>
		</div>

	</xsl:template>

</xsl:stylesheet>
