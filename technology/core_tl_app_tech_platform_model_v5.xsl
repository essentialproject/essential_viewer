<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:include href="../common/core_uml_model_links.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param2 = the path of the dynamically generated UML model -->
	<xsl:param name="param2"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:param name="imageFilename"/>
	<xsl:param name="imageMapPath"/>

	<xsl:variable name="modelSubject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="modelSubjectName" select="$modelSubject/own_slot_value[slot_reference = 'name']/value"/>

	<!-- This section retrieves the root Technology Composite supporting the Application Provider -->
	<xsl:variable name="rootEnv" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'implemented_with_technology']/value]"/>
	<xsl:variable name="rootEnvArchitecture" select="/node()/simple_instance[name = $rootEnv/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="childEnvUsages" select="/node()/simple_instance[name = $rootEnvArchitecture/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>
	<xsl:variable name="childEnvDependencies" select="/node()/simple_instance[name = $rootEnvArchitecture/own_slot_value[slot_reference = 'invoked_functions_relations']/value]"/>

	<!-- These are the Technology Composites that make up the architecture of the Application's supporting technology platform -->
	<xsl:variable name="childEnvironments" select="/node()/simple_instance[name = $childEnvUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

	<!-- This section retrieves the Technology Components across the supporting technology platform -->
	<xsl:variable name="childEnvArchitectures" select="/node()/simple_instance[name = $childEnvironments/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="childEnvComponentUsages" select="/node()/simple_instance[name = $childEnvArchitectures/own_slot_value[slot_reference = 'technology_component_usages']/value]"/>

	<xsl:variable name="childEnvComponents" select="/node()/simple_instance[name = $childEnvComponentUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

	<xsl:variable name="genericPageLabel">
		<xsl:value-of select="eas:i18n('Technology Platform Model ')"/>
	</xsl:variable>
	<xsl:variable name="pageTitle" select="concat($genericPageLabel, ' - ', $modelSubjectName)"/>

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
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference = 'description']/value"/>

				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Platform Model for')"/>&#160;</span>
										<span class="text-primary">
											<xsl:value-of select="$modelSubjectName"/>
										</span>
									</h1>
								</div>
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
								<p>
									<xsl:value-of select="$modelSubjectDesc"/>
								</p>
							</div>
							<hr/>
						</div>



						<!--Setup UML Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Model')"/>
							</h2>
                            <xsl:choose>
                                <xsl:when test="not($rootEnv)">No Model Defined</xsl:when>
                                <xsl:otherwise>
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
							<div class="umlZoomContainer pull-right">
								<input type="button" value="Zoom In" onclick="$('#image').zoomable('zoomIn')" title="Zoom in"/>
								<input type="button" value="Zoom Out" onclick="$('#image').zoomable('zoomOut')" title="Zoom out"/>
								<input type="button" value="Reset" onclick="$('#image').zoomable('reset')"/>
							</div>
							<div class="clear"/>
							<div class="verticalSpacer_10px"/>
							<div class="umlModelViewport">
								<img class="umlImage" src="{$imageFilename}" usemap="#unix" id="image" alt="UML Model"/>

								<xsl:variable name="imageMapFile" select="concat('../', $imageMapPath)"/>
								<xsl:if test="unparsed-text-available($imageMapFile)">
									<xsl:value-of select="unparsed-text($imageMapFile)" disable-output-escaping="yes"/>
								</xsl:if>

							</div>
							
                                </xsl:otherwise>  
                            </xsl:choose>    
                            <hr/>
						</div>


						<!--Setup Technology Components Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-server icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Technology Components')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($childEnvComponents) > 0">

										<p><xsl:value-of select="eas:i18n('The following technology components are used to support the')"/>&#160; <strong><xsl:value-of select="$modelSubjectName"/>&#160; </strong>
											<xsl:value-of select="eas:i18n('application')"/>.</p>
										<div class="verticalSpacer_10px"/>
										<xsl:call-template name="TechnologyComponents"/>

									</xsl:when>
									<xsl:otherwise>
										<p>
											<em><xsl:value-of select="eas:i18n('No supporting technology components defined for the')"/>&#160; </em>
											<em><xsl:value-of select="$modelSubjectName"/>&#160; <xsl:value-of select="eas:i18n('application')"/>.</em>
										</p>
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


	<xsl:template name="TechnologyComponents">

		<table class="table table-bordered table-striped ">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Technology Component')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="TechnologyComponentRow" select="$childEnvComponents">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>


	<xsl:template mode="TechnologyComponentRow" match="node()">
		<xsl:variable name="currentComp" select="current()"/>
		<xsl:variable name="compName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="compDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$currentComp"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($compDesc) > 0">
						<xsl:value-of select="$compDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
