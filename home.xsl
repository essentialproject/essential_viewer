<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="common/core_doctype.xsl"/>
	<xsl:include href="common/core_common_head_content.xsl"/>
	<xsl:include href="common/core_header.xsl"/>
	<xsl:include href="common/core_footer.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" encoding="UTF-8" include-content-type="no"/>

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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 02.08.2018 JWC Added security AuthZ check for the rendering of the View Library -->


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="param1"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allPortals" select="/node()/simple_instance[type = 'Portal']"/>
	<xsl:variable name="allEnabledPortals" select="$allPortals[own_slot_value[slot_reference = 'portal_is_enabled']/value = 'true']"/>
	<xsl:variable name="allPortalSections" select="/node()/simple_instance[type = 'Portal_Section']"/>
	<xsl:variable name="allPortalPanels" select="/node()/simple_instance[type = 'Portal_Panel']"/>
	<xsl:variable name="allPortalPanelSections" select="/node()/simple_instance[type = 'Portal_Panel_Section']"/>
	<xsl:variable name="allExtRefs" select="/node()/simple_instance[type = 'External_Reference_Link']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type = 'Individual_Actor' or type = 'Group_Actor']"/>
	<xsl:variable name="allReports" select="/node()/simple_instance[type = 'Report']"/>
	<xsl:variable name="currentPortal" select="$allPortals[own_slot_value[slot_reference = 'name']/value = 'Essential Viewer Master Portal']"/>
	<xsl:variable name="portalLabel" select="$currentPortal/own_slot_value[slot_reference = 'portal_label']/value"/>
	<xsl:variable name="portalSections" select="$allPortalSections[own_slot_value[slot_reference = 'parent_portal']/value = $currentPortal/name]"/>
	<xsl:variable name="portalPanels" select="$allPortalPanels[name = $currentPortal/own_slot_value[slot_reference = 'portal_panels']/value]"/>
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>Essential Viewer - Home</title>
				<script>
					$(document).ready(function() {  
					 	$('.caption').matchHeight();
					});
				</script>
				<style type="text/css">
					.jumbotron{
						background: bottom center;
						border-bottom: 1px solid #ddd;
					}</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<div class="jumbotron bg-primary">
					<xsl:attribute name="style" select="concat('background-image: url(', $currentPortal/own_slot_value[slot_reference = 'portal_image_path']/value), ');'"/>
					<div class="container-fluid">
						<div class="row">
							<div class="col-xs-12 col-sm-9 col-md-9 bg-white" style="opacity:0.75">
								<h1>
									<xsl:value-of select="$currentPortal/own_slot_value[slot_reference = 'portal_label']/value"/>
								</h1>
								<p>
									<xsl:value-of select="$currentPortal/own_slot_value[slot_reference = 'portal_intro_text']/value"/>
								</p>
							</div>
						</div>
					</div>
				</div>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12 col-sm-8">
							<div class="row">
								<xsl:apply-templates mode="portals" select="$allPortals">
									<xsl:sort select="current()/own_slot_value[slot_reference = 'portal_sequence']/value"/>
								</xsl:apply-templates>
							</div>
							<div class="row">
								<xsl:call-template name="viewLibrary"/>
							</div>
						</div>
						<xsl:apply-templates mode="portalPanels" select="$portalPanels">
							<xsl:sort select="current()/own_slot_value[slot_reference = 'portal_panel_sequence']/value"/>
						</xsl:apply-templates>
					</div>
				</div>


				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template mode="portals" match="node()">		
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="portalXSL" select="own_slot_value[slot_reference = 'portal_xsl_filename']/value"/>
		<xsl:variable name="portalHistoryLabel" select="own_slot_value[slot_reference = 'report_history_label']/value"/>
		<xsl:if test="eas:isUserAuthZ($this) and ($this/own_slot_value[slot_reference = 'portal_is_enabled']/value = 'true')">
			<div>
				<xsl:attribute name="class">
					<xsl:choose>
						<!--If it's the first then full width-->
						<xsl:when test="count($allEnabledPortals) = 1">col-xs-12</xsl:when>
						<!--If it's an odd number and last then full width-->
						<xsl:when test="(count($allEnabledPortals) mod 2) = 1 and (position() = last())">col-xs-12</xsl:when>
						<!--If it's an even number then half width-->
						<xsl:when test="(count($allEnabledPortals) mod 2) != 1">col-xs-12 col-xs-6</xsl:when>
						<!--If it's an odd number but not last then half width-->
						<xsl:otherwise>col-xs-12 col-xs-6</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<div class="thumbnail">
					<div style="height: 100px; max-height:100px; overflow: hidden;">
						<a>
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="theXSL" select="$portalXSL"/>
								<xsl:with-param name="theInstanceID" select="current()/name"/>
								<xsl:with-param name="theHistoryLabel" select="$portalHistoryLabel"/>
							</xsl:call-template>
							<img alt="portal image">
								<xsl:attribute name="src" select="current()/own_slot_value[slot_reference = 'portal_image_path']/value"/>
							</img>
						</a>
					</div>
					<div class="caption">
						<h2>
							<a class="text-default">
								<xsl:call-template name="CommonRenderLinkHref">
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="theXSL" select="$portalXSL"/>
									<xsl:with-param name="theInstanceID" select="current()/name"/>
									<xsl:with-param name="theHistoryLabel" select="$portalHistoryLabel"/>
								</xsl:call-template>
								<span>
									<xsl:value-of select="current()/own_slot_value[slot_reference = 'portal_label']/value"/>
								</span>
							</a>
						</h2>
						<p>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</p>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="viewLibrary">
		<xsl:variable name="allReports" select="/node()/simple_instance[type = 'Report']"/>
		<xsl:variable name="viewLibraryReport" select="$allReports[own_slot_value[slot_reference = 'name']/value = 'Core: View Library']"/>
		<xsl:variable name="viewLibraryLabel" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_label']/value"/>
		<xsl:variable name="viewLibraryDesc" select="$viewLibraryReport/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="viewLibraryXSL" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		<xsl:variable name="viewLibraryHistoryLabel" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
		<xsl:if test="eas:isUserAuthZ($viewLibraryReport) and $viewLibraryReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'true'">
			<div class="col-xs-12">
				<div class="thumbnail">
					<div style="height: 100px; max-height:100px; overflow: hidden;">
						<a>
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="theXSL" select="$viewLibraryXSL"/>
								<xsl:with-param name="theHistoryLabel" select="$viewLibraryHistoryLabel"/>
							</xsl:call-template>
							<img alt="screenshot">
								<xsl:attribute name="src" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_screenshot_filename']/value"/>
							</img>
						</a>
					</div>
					<div class="caption">
						<h2>
							<a class="text-default">
								<xsl:call-template name="CommonRenderLinkHref">
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="theXSL" select="$viewLibraryXSL"/>
									<xsl:with-param name="theHistoryLabel" select="$viewLibraryHistoryLabel"/>
								</xsl:call-template>
								<span>
									<xsl:value-of select="$viewLibraryLabel"/>
								</span>
							</a>
						</h2>
						<p>
							<xsl:value-of select="$viewLibraryDesc"/>
						</p>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="portalPanels" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:if test="eas:isUserAuthZ($this)">
			<xsl:variable name="portalPanelSections" select="$allPortalPanelSections[name = current()/own_slot_value[slot_reference = 'portal_panel_sections']/value]"/>
			<xsl:variable name="panelReports" select="$allReports[name = current()/own_slot_value[slot_reference = 'reports_for_portal_panel']/value]"/>
			<div class="col-xs-12 col-sm-4 bg-offwhite">
				<h1 class="text-primary">
					<xsl:value-of select="current()/own_slot_value[slot_reference = 'portal_panel_label']/value"/>
				</h1>
				<p>
					<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
					</xsl:call-template>
				</p>
				<div class="verticalSpacer_5px"/>
				<ul>
					<xsl:for-each select="$panelReports">
						<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
						<li>
							<!--<xsl:value-of select="current()/own_slot_value[slot_reference='report_label']/value"/>-->
							<xsl:call-template name="RenderCatalogueLink">
								<xsl:with-param name="theCatalogue" select="current()"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="targetReport" select="()"/>
								<xsl:with-param name="targetMenu" select="()"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
				<xsl:apply-templates mode="portalPanelSections" select="$portalPanelSections"/>
				<br/>
			</div>
			<div class="col-xs-12 col-sm-4"> &#160; </div>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="portalPanelSections" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:if test="eas:isUserAuthZ($this)">
			<xsl:variable name="sectionReports" select="$allReports[name = current()/own_slot_value[slot_reference = 'portal_panel_section_reports']/value]"/>
			<xsl:variable name="sectionExtRefs" select="$allExtRefs[name = current()/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
			<xsl:variable name="sectionActors" select="$allActors[name = current()/own_slot_value[slot_reference = 'portal_panel_actors']/value]"/>
			<h2>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'portal_panel_section_label']/value"/>
			</h2>
			<ul>
				<xsl:for-each select="$sectionReports">
					<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
					<li>
						<a>
							<xsl:value-of select="current()/own_slot_value[slot_reference = 'report_label']/value"/>
						</a>
					</li>
				</xsl:for-each>
			</ul>
			<ul>
				<xsl:for-each select="$sectionActors">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<li>
						<xsl:choose>
							<xsl:when test="string-length(current()/own_slot_value[slot_reference = 'email']/value) > 0">
								<a target="_blank">
									<xsl:attribute name="href" select="concat('mailto:', current()/own_slot_value[slot_reference = 'email']/value)"/>
									<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
			<ul>
				<xsl:for-each select="$sectionExtRefs">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<li>
						<a target="_blank">
							<xsl:attribute name="href" select="current()/own_slot_value[slot_reference = 'external_reference_url']/value"/>
							<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
						</a>
					</li>
				</xsl:for-each>
			</ul>
			<br/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
