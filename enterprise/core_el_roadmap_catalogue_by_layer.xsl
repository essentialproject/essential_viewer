<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<!--<xsl:param name="param1" />-->

	<!-- param4 = the taxonomy term that will be used to scope the organisation model -->
	<!--<xsl:param name="param4" />-->

	<!--<xsl:variable name="allReports" select="/node()/simple_instance[type='Report']" />-->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->

	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Roadmap_Model', 'Roadmap')"/>
	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Roadmap Catalogue by Layer')"/>
	</xsl:variable>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="roadmapListByNameCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Roadmap Catalogue by Name')]"/>
	<xsl:variable name="allInstances" select="/node()/simple_instance[type = ('Roadmap_Model', 'Roadmap')]"/>
	<xsl:variable name="layerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Enterprise Architecture Layers')]"/>
	<xsl:variable name="layerTaxonomyTerms" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $layerTaxonomy/name]"/>
	<xsl:variable name="eaArchViewsTaxonomyTerm" select="$layerTaxonomyTerms[(own_slot_value[slot_reference = 'name']/value = 'Cross-Domain Architecture Layer')]"/>
	<xsl:variable name="busArchViewsTaxonomyTerm" select="$layerTaxonomyTerms[(own_slot_value[slot_reference = 'name']/value = 'Business Architecture Layer')]"/>
	<xsl:variable name="infArchViewsTaxonomyTerm" select="$layerTaxonomyTerms[(own_slot_value[slot_reference = 'name']/value = 'Information Architecture Layer')]"/>
	<xsl:variable name="appArchViewsTaxonomyTerm" select="$layerTaxonomyTerms[(own_slot_value[slot_reference = 'name']/value = 'Application Architecture Layer')]"/>
	<xsl:variable name="techArchViewsTaxonomyTerm" select="$layerTaxonomyTerms[(own_slot_value[slot_reference = 'name']/value = 'Technology Architecture Layer')]"/>


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
	<!-- 07.02.2019 JP  Updated to support new Roadmap class	 -->


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeInstances" select="$allInstances[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeInstances" select="$allInstances"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="inScopeInstances"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$roadmapListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Name'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Architecture Layer')"/>
									</span>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12">
							<!--Setup Description Section-->
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('Click on a Roadmap Model name to navigate to the required view')"/>.<div class="verticalSpacer_10px"/>
									<h3><xsl:value-of select="eas:i18n('Enterprise')"/></h3>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="Enterprise"><xsl:with-param name="layerInstances" select="$inScopeInstances"/></xsl:call-template>
									<div class="verticalSpacer_20px"/>
									<h3><xsl:value-of select="eas:i18n('Business')"/></h3>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="Business"><xsl:with-param name="layerInstances" select="$inScopeInstances"/></xsl:call-template>
									<div class="verticalSpacer_20px"/>
									<h3><xsl:value-of select="eas:i18n('Information')"/></h3>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="Information"><xsl:with-param name="layerInstances" select="$inScopeInstances"/></xsl:call-template>
									<div class="verticalSpacer_20px"/>
									<h3><xsl:value-of select="eas:i18n('Application')"/></h3>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="Application"><xsl:with-param name="layerInstances" select="$inScopeInstances"/></xsl:call-template>
									<div class="verticalSpacer_20px"/>
									<h3><xsl:value-of select="eas:i18n('Technology')"/></h3>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="Technology"><xsl:with-param name="layerInstances" select="$inScopeInstances"/></xsl:call-template>
									<div class="verticalSpacer_40px"/>
									<h3><xsl:value-of select="eas:i18n('Layer Undefined')"/></h3>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="UndefinedLayer"><xsl:with-param name="layerInstances" select="$inScopeInstances"/></xsl:call-template>
								</p>
							</div>
						</div>
					</div>
				</div>

				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="Enterprise">
		<xsl:param name="layerInstances" select="()"/>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Roadmap Model Name')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="layerRoadmaps" select="$layerInstances[(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name)]"/>
				<xsl:choose>
					<xsl:when test="count($layerRoadmaps) = 0">
						<tr>
							<td colspan="2">
								<em>
									<xsl:value-of select="eas:i18n('No Roadmaps defined')"/>
								</em>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="RenderRoadmap" select="$layerRoadmaps"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="Business">
		<xsl:param name="layerInstances" select="()"/>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Roadmap Model Name')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="layerRoadmaps" select="$layerInstances[(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name)]"/>
				<xsl:choose>
					<xsl:when test="count($layerRoadmaps) = 0">
						<tr>
							<td colspan="2">
								<em>
									<xsl:value-of select="eas:i18n('No Roadmaps defined')"/>
								</em>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="RenderRoadmap" select="$layerRoadmaps"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="Information">
		<xsl:param name="layerInstances" select="()"/>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Roadmap Model Name')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="layerRoadmaps" select="$layerInstances[(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name)]"/>
				<xsl:choose>
					<xsl:when test="count($layerRoadmaps) = 0">
						<tr>
							<td colspan="2">
								<em>
									<xsl:value-of select="eas:i18n('No Roadmaps defined')"/>
								</em>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="RenderRoadmap" select="$layerRoadmaps"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="Application">
		<xsl:param name="layerInstances" select="()"/>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Roadmap Model Name')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="layerRoadmaps" select="$layerInstances[(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name)]"/>
				<xsl:choose>
					<xsl:when test="count($layerRoadmaps) = 0">
						<tr>
							<td colspan="2">
								<em>
									<xsl:value-of select="eas:i18n('No Roadmaps defined')"/>
								</em>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="RenderRoadmap" select="$layerRoadmaps"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="Technology">
		<xsl:param name="layerInstances" select="()"/>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Roadmap Model Name')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="layerRoadmaps" select="$layerInstances[(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name)]"/>
				<xsl:choose>
					<xsl:when test="count($layerRoadmaps) = 0">
						<tr>
							<td colspan="2">
								<em>
									<xsl:value-of select="eas:i18n('No Roadmaps defined')"/>
								</em>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="RenderRoadmap" select="$layerRoadmaps"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>


	<xsl:template name="UndefinedLayer">
		<xsl:param name="layerInstances" select="()"/>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Roadmap Model Name')"/>
					</th>
					<th class="cellWidth-70pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:variable name="layerRoadmaps" select="$layerInstances[not(own_slot_value[slot_reference = 'element_classified_by']/value = $layerTaxonomyTerms/name)]"/>
				<xsl:choose>
					<xsl:when test="count($layerRoadmaps) = 0">
						<tr>
							<td colspan="2">
								<em>
									<xsl:value-of select="eas:i18n('No Roadmaps defined')"/>
								</em>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="RenderRoadmap" select="$layerRoadmaps"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>


	<xsl:template mode="RenderRoadmap" match="node()">
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>

	</xsl:template>



</xsl:stylesheet>
