<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:include href="../common/core_uml_model_links.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param2 = the path of the dynamically generated UML model -->
	<xsl:param name="param2"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

	<xsl:param name="imageFilename"/>
	<xsl:param name="imageMapPath"/>

	<xsl:variable name="modelSubject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="modelSubjectName" select="$modelSubject/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="pageTitle">
		<xsl:value-of select="eas:i18n('Technology Distribution Model')"/>
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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageTitle"/>
				</title>
				<script type="text/javascript" src="js/jquery.zoomable.js?release=6.19"/>
			</head>
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference = 'description']/value"/>

				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-primary">
											<xsl:value-of select="$pageTitle"/>
										</span>
									</h1>
								</div>
							</div>
						</div>


						<!--Setup UML Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Model')"/>
							</h2>

							<div class="content-section">
								<xsl:if test="count($modelSubject) = 1">
									<!--script to support vertical alignment within named divs - requires jquery and verticalalign plugin-->
									<script type="text/javascript">
											$('document').ready(function(){
											$(".umlCircleBadge").vAlign();
											$(".umlCircleBadgeDescription").vAlign();
											$(".umlKeyTitle").vAlign();
											});
										</script>
									<div class="uml_key_container">
										<!--comment out from here to hide key - leave container in place -->
										<!--<span class="umlKeyTitle fontBlack small">Key:</span>
												<div class="umlCircleBadge backColour8 text-white">I</div>									
												<span class="umlCircleBadgeDescription small">Internal</span>									
												<div class="umlCircleBadge backColour9  text-white">E</div>										
												<span class="umlCircleBadgeDescription small">External</span>-->
										<!--comment out to here to hide key - leave container in place -->
									</div>


									<!--script required to zoom and drag images whilst scaling image maps-->
									<script type="text/javascript">
											$('document').ready(function(){
											$('.umlImage').zoomable();
											});
										</script>
									<div class="row">
										<div class="col-xs-12">
											<div class="umlZoomContainer pull-right">
												<input type="button" value="Zoom In" onclick="$('#image').zoomable('zoomIn')" title="Zoom in"/>
												<input type="button" value="Zoom Out" onclick="$('#image').zoomable('zoomOut')" title="Zoom out"/>
												<input type="button" value="Reset" onclick="$('#image').zoomable('reset')"/>
											</div>
										</div>
										<div class="col-xs-12">
											<div class="umlModelViewport">
												<img class="umlImage" width="100%" src="{$imageFilename}" usemap="#unix" id="image" alt="UML Model"/>

												<xsl:variable name="imageMapFile" select="concat('../', $imageMapPath)"/>
												<!--<xsl:if test="unparsed-text-available($imageMapFile)">
													<xsl:value-of select="unparsed-text($imageMapFile)" disable-output-escaping="yes"/>
												</xsl:if>-->
											</div>
										</div>
									</div>
								</xsl:if>

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

</xsl:stylesheet>
