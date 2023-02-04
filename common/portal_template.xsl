<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="anyReports" select="if ($eipMode) then /node()/simple_instance[type = ('Configured_Editor', 'Simple_Editor', 'Editor', 'Report')] else /node()/simple_instance[type = 'Report']"/>
	<xsl:key name="anyReports_key" match="$anyReports" use="own_slot_value[slot_reference = 'report_is_enabled']/value"/>
	<xsl:variable name="allReports" select="key('anyReports_key','true')"/>
	<xsl:variable name="qualifyingReports" select="$anyReports[name=$allReports/own_slot_value[slot_reference='report_qualifying_report']/value]"/>
	<xsl:variable name="anyReportParameters" select="/node()/simple_instance[name = $anyReports/own_slot_value[slot_reference = 'report_parameters']/value]"/>
	 
 

	<!--
	<xsl:variable name="allReports" select="$anyReports[own_slot_value[slot_reference = 'report_is_enabled']/value = 'true']"/>
	-->
	<xsl:key name="allPortals_key" match="/node()/simple_instance[type = 'Portal']" use="name"/>
	<xsl:key name="allPortalSections_key" match="/node()/simple_instance[type = 'Portal_Section']" use="own_slot_value[slot_reference = 'parent_portal']/value"/>
	<xsl:key name="allPortalPanels_key" match="/node()/simple_instance[type = 'Portal_Panel']" use="own_slot_value[slot_reference = 'panel_for_portal']/value"/>
	<xsl:key name="allPortalPanelSections_key" match="/node()/simple_instance[type = 'Portal_Panel_Section']" use="own_slot_value[slot_reference = 'portal_parent_panel']/value"/>
	<xsl:key name="allExtRefs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/>
	<xsl:key name="allReportToPortalSectionRelation_key" match="/node()/simple_instance[type = 'REPORT_TO_PORTAL_SECTION_RELATION']" use="own_slot_value[slot_reference = 'r2psr_portal_section']/value"/>
	<xsl:variable name="currentPortal" select="key('allPortals_key',$param1)"/> 
	<xsl:variable name="portalPanelSections" select="key('allPortalPanelSections_key',$currentPortal/name)"/>
<!--	<xsl:variable name="allPortals" select="/node()/simple_instance[type = 'Portal']"/>
	<xsl:variable name="allPortalSections" select="/node()/simple_instance[type = 'Portal_Section']"/>
	<xsl:variable name="allPortalPanels" select="/node()/simple_instance[type = 'Portal_Panel']"/>
	<xsl:variable name="allPortalPanelSections" select="/node()/simple_instance[type = 'Portal_Panel_Section']"/>-->
	<xsl:variable name="allExtRefs" select="/node()/simple_instance[type = 'External_Reference_Link']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type = 'Individual_Actor' or type = 'Group_Actor']"/>
	<xsl:variable name="allPortalPanelsActors" select="$allActors[name = $portalPanelSections/own_slot_value[slot_reference = 'portal_panel_actors']/value]"/>
	<xsl:variable name="allReportConstants" select="/node()/simple_instance[type = 'Report_Constant']"/>

	
	<!--<xsl:variable name="currentPortal" select="$allPortals[name = $param1]"/>-->
	<xsl:variable name="portalLabel">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$currentPortal"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="portalSections" select="key('allPortalSections_key',$currentPortal/name)"/>
	<!--<xsl:variable name="portalSections" select="$allPortalSections[own_slot_value[slot_reference = 'parent_portal']/value = $currentPortal/name]"/> -->
	<xsl:variable name="portalPanels" select="key('allPortalPanels_key',$currentPortal/name)"/>
<!--	<xsl:variable name="portalPanels" select="$allPortalPanels[name = $currentPortal/own_slot_value[slot_reference = 'portal_panels']/value]"/>
-->
	<xsl:variable name="viewerPrimaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'primary_header_colour_viewer']/value"/>
	<xsl:variable name="viewerSecondaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'secondary_header_colour_viewer']/value"/>

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
	<!-- Dec 2015 Updated to support Essential Viewer version 5-->
	<!-- 26.03.2018 JWC Added the missing security framework elements --> 

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$portalLabel"/>
				</title>
				<script src="js/lightbox-master/ekko-lightbox.min.js"/>
				<link href="js/lightbox-master/ekko-lightbox.min.css" rel="stylesheet" type="text/css"/>
				<script type="text/javascript">
					$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
					    event.preventDefault();
					    $(this).ekkoLightbox({always_show_close: false});
					}); 
				</script>
				<style type="text/css">
					.viewElementContainer {
						border-color: <xsl:value-of select="$viewerPrimaryHeader"/>
					}
					
					.editorElementContainer {
						border-color: <xsl:value-of select="$viewerSecondaryHeader"/>
					}
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<div class="jumbotron">
					<xsl:attribute name="style" select="concat('background-image: url(', $currentPortal/own_slot_value[slot_reference = 'portal_image_path']/value), ');background-size:100%;'"/>
					<div class="container-fluid">
						<div class="row">
							<div class="col-xs-12 col-sm-9 col-md-9 bg-white" style="opacity:0.75">
								<h1>
									<xsl:value-of select="$portalLabel"/>
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
						<div class="col-xs-12 col-sm-9">
							<xsl:apply-templates mode="portalSections" select="$portalSections">
								<xsl:sort select="number(current()/own_slot_value[slot_reference = 'portal_section_sequence']/value)"/>
							</xsl:apply-templates>
						</div>
						<xsl:apply-templates mode="portalPanels" select="$portalPanels">
							<xsl:sort select="number(current()/own_slot_value[slot_reference = 'portal_panel_sequence']/value)"/>
						</xsl:apply-templates>
					</div>
				</div>


				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template mode="portalSections" match="node()"> 
		<xsl:variable name="allR2PSRForSection" select="key('allReportToPortalSectionRelation_key',current()/name)"/>
	<!--	<xsl:variable name="allReportToPortalSectionRelation" select="/node()/simple_instance[type = 'REPORT_TO_PORTAL_SECTION_RELATION']"/>
		<xsl:variable name="allR2PSRForSection" select="$allReportToPortalSectionRelation[own_slot_value[slot_reference = 'r2psr_portal_section']/value = current()/name]"/> -->
		<xsl:variable name="reportsForSection" select="$allReports[name = $allR2PSRForSection/own_slot_value[slot_reference = 'r2psr_report']/value]"/>
		<xsl:if test="count($reportsForSection) > 0">
			<h1 class="text-primary">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</h1>
			<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'description']/value) &gt; 0">
				<p class="large text-secondary">
					<strong>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</strong>
				</p>
			</xsl:if>
			<div class="row">
				<xsl:apply-templates select="$allR2PSRForSection" mode="sectionReports">
					<xsl:sort select="number(current()/own_slot_value[slot_reference = 'report_to_portal_section_index']/value)"/>
				</xsl:apply-templates>				
				<!--All R2PSRForSection: <xsl:value-of select="$allR2PSRForSection/own_slot_value[slot_reference='relation_name']/value"></xsl:value-of>-->
				<div class="col-xs-12 ">
					<hr/>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="sectionReports" match="node()">
		<xsl:variable name="aCurNode" select="current()"></xsl:variable>
		<xsl:variable name="currentReport" select="$allReports[name = $aCurNode/own_slot_value[slot_reference = 'r2psr_report']/value]"/>
		<!--<xsl:value-of select="$currentReport/own_slot_value[slot_reference='name']/value"></xsl:value-of>-->		
		<xsl:if test="eas:isUserAuthZ($currentReport) and $currentReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'true'">
			<xsl:call-template name="PrintReportBox">
				<xsl:with-param name="aReport" select="$currentReport"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="portalPanels" match="node()">
		<xsl:variable name="portalPanelSections" select="key('allPortalPanelSections_key',current()/name)"/>
		<!--	
		<xsl:variable name="portalPanelSections" select="$allPortalPanelSections[name = current()/own_slot_value[slot_reference = 'portal_panel_sections']/value]"/>-->
		<xsl:variable name="panelReports" select="$allReports[name = current()/own_slot_value[slot_reference = 'reports_for_portal_panel']/value]"/>
		<div class="col-xs-12 col-sm-3">
			<div class="bg-offwhite portalPanel">
				<h1 class="text-primary">
					<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
					</xsl:call-template>
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
						<!-- Only render if user is authorised -->
						<xsl:if test="eas:isUserAuthZ(current())">
							<xsl:choose>
								<xsl:when test="($eipMode) and (current()/type = ('Editor', 'Simple_Editor'))">
									<xsl:variable name="theEditorId" select="current()/name"/>
									<xsl:variable name="theEditorLabel" select="current()/own_slot_value[slot_reference = 'report_label']/value"/>
									<xsl:variable name="theEditorParameterInsts" select="$anyReportParameters[name = current()/own_slot_value[slot_reference = 'report_parameters']/value]"/>
									<xsl:variable name="theEditorParamString">
										<xsl:apply-templates mode="RenderMenuItemParameters" select="$theEditorParameterInsts"/>
									</xsl:variable>
									<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;PMA=&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/><xsl:value-of select="$theEditorParamString"/></xsl:variable>
									<li class="fontSemi large">
										<a class="text-darkgrey" href="{$theEditorLinkHref}" target="_blank">
											<xsl:value-of select="$theEditorLabel"/>
										</a>
									</li>
								</xsl:when>
								<xsl:when test="($eipMode) and (current()/type = 'Configured_Editor')">
									<xsl:variable name="theEditorLabel" select="current()/own_slot_value[slot_reference = 'report_label']/value"/>
									<li class="fontSemi large">
										<a class="text-darkgrey" target="_blank">
											<xsl:attribute name="href">
												<xsl:call-template name="RenderEditorLinkHref">
													<xsl:with-param name="theEditor" select="current()"></xsl:with-param>
												</xsl:call-template>
											</xsl:attribute>
											<xsl:value-of select="$theEditorLabel"/>
										</a>
									</li>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="qualifyingReportId" select="current()/own_slot_value[slot_reference = 'report_qualifying_report']/value"/> 
									<xsl:variable name="qualifyingReport" select="$qualifyingReports[name = $qualifyingReportId]"/>
									<xsl:variable name="qualifyingReportHistoryLabelName" select="$qualifyingReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
									<xsl:variable name="qualifyingReportFilename" select="$qualifyingReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
									<xsl:variable name="targetReportIdQueryString">
										<xsl:text>&amp;targetReportId=</xsl:text>
										<xsl:value-of select="current()/name"/>
									</xsl:variable>
									<li class="fontSemi large">
										<xsl:choose>
											<xsl:when test="string-length($qualifyingReportId) > 0">
												<a class="text-darkgrey">
													<xsl:call-template name="RenderLinkHref">
														<xsl:with-param name="theXSL" select="$qualifyingReportFilename"/>
														<xsl:with-param name="theHistoryLabel" select="$qualifyingReportHistoryLabelName"/>
														<xsl:with-param name="theUserParams" select="$targetReportIdQueryString"/>
													</xsl:call-template>
													<xsl:call-template name="RenderMultiLangInstanceName">
														<xsl:with-param name="theSubjectInstance" select="current()"/>
													</xsl:call-template>
												</a>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="RenderCatalogueLink">
													<xsl:with-param name="theCatalogue" select="current()"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													<xsl:with-param name="targetReport" select="()"/>
													<xsl:with-param name="targetMenu" select="()"/>
													<xsl:with-param name="anchorClass">text-darkgrey</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</li>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:if>
					</xsl:for-each>
				</ul>
				<xsl:apply-templates mode="portalPanelSections" select="$portalPanelSections">
					<xsl:sort select="number(current()/own_slot_value[slot_reference = 'portal_panel_section_sequence']/value)"/>
				</xsl:apply-templates>
				<br/>
			</div>
		</div>
		<div class="col-xs-12 col-sm-3"> &#160; </div>
	</xsl:template>

	<xsl:template mode="portalPanelSections" match="node()">
		<xsl:variable name="sectionReports" select="$allReports[name = current()/own_slot_value[slot_reference = 'portal_panel_section_reports']/value]"/>
	<!--	<xsl:variable name="sectionExtRefs" select="$allExtRefs[name = current()/own_slot_value[slot_reference = 'external_reference_links']/value]"/> -->
		<xsl:variable name="sectionExtRefs" select="key('allExtRefs_key',current()/name)"/>
		<xsl:variable name="sectionActors" select="$allPortalPanelsActors[name = current()/own_slot_value[slot_reference = 'portal_panel_actors']/value]"/>
		<h2>
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</h2>
		<ul>
			<xsl:for-each select="$sectionReports">
				<xsl:sort select="/own_slot_value[slot_reference = 'report_label']/value"/>
				<xsl:if test="eas:isUserAuthZ(current())">
					<xsl:variable name="qualifyingReportId" select="current()/own_slot_value[slot_reference = 'report_qualifying_report']/value"/>
					<xsl:variable name="qualifyingReport" select="$qualifyingReports[name = $qualifyingReportId]"/>
					<xsl:variable name="qualifyingReportHistoryLabelName" select="$qualifyingReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
					<xsl:variable name="qualifyingReportFilename" select="$qualifyingReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
					<xsl:variable name="targetReportIdQueryString">
						<xsl:text>&amp;targetReportId=</xsl:text>
						<xsl:value-of select="current()/name"/>
					</xsl:variable>
					<li class="fontSemi large">
						<xsl:choose>
							<xsl:when test="string-length($qualifyingReportId) > 0">
								<a class="text-darkgrey">
									<xsl:call-template name="RenderLinkHref">
										<xsl:with-param name="theXSL" select="$qualifyingReportFilename"/>
										<xsl:with-param name="theHistoryLabel" select="$qualifyingReportHistoryLabelName"/>
										<xsl:with-param name="theUserParams" select="$targetReportIdQueryString"/>
									</xsl:call-template>
									<xsl:value-of select="current()/own_slot_value[slot_reference = 'report_label']/value"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="RenderCatalogueLink">
									<xsl:with-param name="theCatalogue" select="current()"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									<xsl:with-param name="targetReport" select="()"/>
									<xsl:with-param name="targetMenu" select="()"/>
									<xsl:with-param name="anchorClass">text-darkgrey</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:if>
			</xsl:for-each>
		</ul>
		<ul>
			<xsl:for-each select="$sectionActors">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<li class="fontSemi large">
					<xsl:choose>
						<xsl:when test="string-length(current()/own_slot_value[slot_reference = 'email']/value) > 0">
							<a target="_blank" class="text-darkgrey">
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
				<xsl:sort select="/own_slot_value[slot_reference = 'name']/value"/>
				<li class="fontSemi large">
					<a target="_blank" class="text-darkgrey">
						<xsl:attribute name="href" select="current()/own_slot_value[slot_reference = 'external_reference_url']/value"/>
						<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<br/>
	</xsl:template>

	<xsl:template name="PrintReportBox">
		<xsl:param name="aReport"/>
		<xsl:param name="nameStyleSetting"/>
		<xsl:param name="descStyleSetting"/>

		<xsl:variable name="reportLabelName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$aReport"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="reportDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$aReport"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="qualifyingReportId" select="$aReport/own_slot_value[slot_reference = 'report_qualifying_report']/value"/>
		<xsl:variable name="qualifyingReport" select="$qualifyingReports[name=$qualifyingReportId]"/>		
		<xsl:variable name="reportConstant" select="$allReportConstants[name = $aReport/own_slot_value[slot_reference = 'rp_report_constants']/value]"/>
		<xsl:variable name="reportHistoryLabelName" select="$aReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
		<xsl:variable name="reportFilename" select="$aReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		<xsl:variable name="reportScreenshot">
			<xsl:choose>
				<xsl:when test="string-length($aReport/own_slot_value[slot_reference = 'report_screenshot_filename']/value) &gt; 0">
					<xsl:value-of select="$aReport/own_slot_value[slot_reference = 'report_screenshot_filename']/value"/>
				</xsl:when>
				<xsl:otherwise>images/screenshots/placeholder.png</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
        

		<xsl:choose>
			<!-- Go straight to the report if the report constant value is set -->
			<!-- But only if the user is authorised -->
			<xsl:when test="eas:isUserAuthZ($aReport) and count($reportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value) > 0">
				<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
					<div class="viewElementContainer {$nameStyleSetting}">
						<a class="noUL">
							<xsl:choose>
								<xsl:when test="($eipMode) and (current()/type = ('Editor', 'Simple_Editor'))">
									<xsl:variable name="theEditorId" select="current()/name"/>
									<xsl:variable name="theEditorLabel" select="current()/own_slot_value[slot_reference = 'report_label']/value"/>
									<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;PMA=&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/></xsl:variable>
									<xsl:attribute name="href" select="$theEditorLinkHref"/>
								</xsl:when>
								<xsl:when test="($eipMode) and (current()/type = 'Configured_Editor')">
									<xsl:attribute name="href">
										<xsl:call-template name="RenderEditorLinkHref">
											<xsl:with-param name="theEditor" select="current()"></xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="RenderLinkHref">
										<xsl:with-param name="theXSL" select="$reportFilename"/>
										<xsl:with-param name="theHistoryLabel" select="$reportHistoryLabelName"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							<div class=" viewElement">
								<div class="viewElementName fontBold large">
									<xsl:value-of select="$reportLabelName"/>
								</div>
								<div class="viewElementDescription text-darkgrey">
									<xsl:value-of select="$reportDescription"/>
								</div>

								<div class="viewElementImage hidden-xs">
									<!--<xsl:attribute name="style" select="concat('background-image:url(',$reportScreenshot,')')"/>-->
									<img src="{$reportScreenshot}" alt="screenshot" class="img-responsive">
                                        <xsl:attribute name="id" select="translate($reportLabelName,' ','')"></xsl:attribute>
                                    </img>    
								</div>
							</div>
						</a>
						<div class="viewElement-placeholder"/>
						<div class="report-element-preview">
							<a href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
								<i class="fa fa-search"/>
							</a>
						</div>
					</div>
				</div>
			</xsl:when>

			<!-- Check that the user is authorised to access the qualifying report -->
			<xsl:when test="eas:isUserAuthZ($aReport) and eas:isUserAuthZ($qualifyingReport) and string-length($qualifyingReportId) > 0">				
				<xsl:variable name="qualifyingReportHistoryLabelName" select="$qualifyingReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
				<xsl:variable name="qualifyingReportFilename" select="$qualifyingReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				<xsl:variable name="targetReportIdQueryString">
					<xsl:text>&amp;targetReportId=</xsl:text>
					<xsl:value-of select="$aReport/name"/>
				</xsl:variable>



				<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
					<div class="viewElementContainer {$nameStyleSetting}">
						<a class="noUL">
							<xsl:choose>
								<xsl:when test="($eipMode) and ($aReport/type = ('Editor', 'Simple_Editor'))">
									<xsl:variable name="theEditorId" select="$aReport/name"/>
									<xsl:variable name="theEditorLabel" select="$aReport/own_slot_value[slot_reference = 'report_label']/value"/>
									<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;PMA=&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/></xsl:variable>
									<xsl:attribute name="href" select="$theEditorLinkHref"/>
								</xsl:when>
								<xsl:when test="($eipMode) and ($aReport/type = 'Configured_Editor')">
									<xsl:attribute name="href">
										<xsl:call-template name="RenderEditorLinkHref">
											<xsl:with-param name="theEditor" select="$aReport"></xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="RenderLinkHref">
										<xsl:with-param name="theXSL" select="$qualifyingReportFilename"/>
										<xsl:with-param name="theHistoryLabel" select="$qualifyingReportHistoryLabelName"/>
										<xsl:with-param name="theUserParams" select="$targetReportIdQueryString"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							<div class=" viewElement">

								<div class="viewElementName fontBold large">
									<xsl:value-of select="$reportLabelName"/>
								</div>
								<div class="viewElementDescription text-darkgrey">
									<xsl:value-of select="$reportDescription"/>
								</div>

								<div class="viewElementImage hidden-xs">
									<!--<xsl:attribute name="style" select="concat('background-image:url(',$reportScreenshot,')')"/>-->
									<img src="{$reportScreenshot}" alt="screenshot" class="img-responsive">
                                        <xsl:attribute name="id" select="translate($reportLabelName,' ','')"></xsl:attribute>
                                    </img>    
								</div>
							</div>
						</a>
						<div class="viewElement-placeholder"/>
						<div class="report-element-preview">
							<a href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
								<i class="fa fa-search"/>
							</a>
						</div>
					</div>
				</div>

			</xsl:when>
			<xsl:otherwise>

				<!-- Check that user is authorised for the requested report -->
				<xsl:if test="eas:isUserAuthZ($aReport)">
					<xsl:choose>
						<xsl:when test="($eipMode) and ($aReport/type = ('Editor', 'Simple_Editor', 'Configured_Editor'))">
							<xsl:variable name="thisEditorPath">
								<xsl:call-template name="RenderEditorLinkHref">
									<xsl:with-param name="theEditor" select="$aReport"></xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
								<div class="editorElementContainer {$nameStyleSetting}">
									<a class="noUL" target="_blank">
										<xsl:attribute name="href" select="$thisEditorPath"/>
										<div class=" viewElement">										
											<div class="viewElementName fontBold large">
												<xsl:value-of select="$reportLabelName"/>
											</div>
											<div class="viewElementDescription text-darkgrey">
												<xsl:value-of select="$reportDescription"/>
											</div>											
											<div class="viewElementImage hidden-xs">
												<!--<xsl:attribute name="style" select="concat('background-image:url(',$reportScreenshot,')')"/>-->
												<img src="{$reportScreenshot}" alt="screenshot" class="img-responsive">
													<xsl:attribute name="id" select="translate($reportLabelName,' ','')"></xsl:attribute>
												</img>    
											</div>
										</div>
									</a>
									<div class="viewElement-placeholder"/>
									<div class="report-element-preview">
										<a href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
											<i class="fa fa-search"/>
										</a>
									</div>
								</div>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
								<div class="viewElementContainer {$nameStyleSetting}">
									<a class="noUL">
										<xsl:call-template name="RenderLinkHref">
											<xsl:with-param name="theXSL" select="$reportFilename"/>
											<xsl:with-param name="theHistoryLabel" select="$reportHistoryLabelName"/>
										</xsl:call-template>
										<div class=" viewElement">											
											<div class="viewElementName fontBold large">
												<xsl:value-of select="$reportLabelName"/>
											</div>
											<div class="viewElementDescription text-darkgrey">
												<xsl:value-of select="$reportDescription"/>
											</div>											
											<div class="viewElementImage hidden-xs">
												<!--<xsl:attribute name="style" select="concat('background-image:url(',$reportScreenshot,')')"/>-->
												<img src="{$reportScreenshot}" alt="screenshot" class="img-responsive">
													<xsl:attribute name="id" select="translate($reportLabelName,' ','')"></xsl:attribute>
												</img>    
											</div>
										</div>
									</a>
									<div class="viewElement-placeholder"/>
									<div class="report-element-preview">
										<a href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
											<i class="fa fa-search"/>
										</a>
									</div>
								</div>
							</div>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>



	</xsl:template>

</xsl:stylesheet>
