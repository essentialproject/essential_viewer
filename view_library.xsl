<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="common/core_doctype.xsl"/>
	<xsl:include href="common/core_common_head_content.xsl"/>
	<xsl:include href="common/core_header.xsl"/>
	<xsl:include href="common/core_footer.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1" />
	<!-- param4 = the taxonomy term that will be used to scope the organisation model -->
	<!--<xsl:param name="param4" />-->

	<xsl:variable name="anyViews" select="/node()/simple_instance[type='Report']"/>
	<xsl:variable name="anyEditors" select="/node()/simple_instance[type=('Editor', 'Simple_Editor', 'Configured_Editor')]"/>
	<xsl:variable name="enabledViews" select="$anyViews[own_slot_value[slot_reference = 'report_is_enabled']/value = 'true']"/>
	<xsl:variable name="enabledEditors" select="$anyEditors[own_slot_value[slot_reference = 'report_is_enabled']/value = 'true']"/>
	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>
	<xsl:variable name="allReportConstants" select="/node()/simple_instance[type = 'Report_Constant']"/>
	<xsl:variable name="eaArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Enterprise Architecture Views']"/>
	<xsl:variable name="busArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Business Architecture Views']"/>
	<xsl:variable name="infArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Information Architecture Views']"/>
	<xsl:variable name="appArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Application Architecture Views']"/>
	<xsl:variable name="techArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Technology Architecture Views']"/>
	<xsl:variable name="supportArchViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Support Views']"/>
	<xsl:variable name="catalogueViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Catalogue Views']"/>
	<xsl:variable name="deprecatedViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Deprecated Views']"/>
	<xsl:variable name="portalViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Portal Views']"/>
	<xsl:variable name="dashboardViewsTaxonomyTerm" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = 'Dashboard Views']"/>

	<!-- Set the view filter taxonomies -->
	<xsl:variable name="viewFilterConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'View Filter Taxonomies')]"/>
	<xsl:variable name="viewFilterTaxonomies" select="/node()/simple_instance[name = $viewFilterConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="relevantTaxonomyTerms" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $viewFilterTaxonomies/name]"/>

	<!-- Set up any view scoping terms in accordance with the Home Page report constant -->
	<xsl:variable name="homeReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Home Page')]"/>
	<xsl:variable name="homeViewScopeTerms" select="$allTaxonomyTerms[name = $homeReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

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
	<!-- 01.02.2012 NJW  Created Initial Version	 -->
	<!-- 26.03.2018 JWC Added the missing security framework elements -->
	
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<title>View Library</title>
				<xsl:call-template name="commonHeadContent"/>
				<script>
					$(document).ready(function(){
						$('#myTab a').click(function (e) {
						  e.preventDefault();
						  $(this).tab('show');						  
						})
					});
				</script>
				<style>
					.viewElementContainer.inactive{opacity: 0.25;}
				</style>
				<script src="js/lightbox-master/ekko-lightbox.js" type="text/javascript"/>
				<link href="js/lightbox-master/ekko-lightbox.min.css" rel="stylesheet" type="text/css"/>
				<script type="text/javascript">
					$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
					    event.preventDefault();
					    $(this).ekkoLightbox({
					    	always_show_close: false,
					    	maxHeight: 900
					    });
					}); 
				</script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 class="text-primary">
									<xsl:value-of select="eas:i18n('View Library')"/>
								</h1>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12 col-md-9">


							<div role="tabpanel">
								<!-- Nav tabs -->
								<ul class="nav nav-tabs hidden-xs" role="tablist">
									<li role="presentation" class="active">
										<a href="#all" aria-controls="all" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('All')"/>
										</a>
									</li>
									<li role="presentation">
										<a href="#enterprise" aria-controls="enterprise" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Enterprise')"/>
										</a>
									</li>
									<li role="presentation">
										<a href="#business" aria-controls="business" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Business')"/>
										</a>
									</li>
									<li role="presentation">
										<a href="#information" aria-controls="information" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Information')"/>
										</a>
									</li>
									<li role="presentation">
										<a href="#application" aria-controls="application" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Application')"/>
										</a>
									</li>
									<li role="presentation">
										<a href="#technology" aria-controls="technology" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Technology')"/>
										</a>
									</li>
                                    <li role="presentation">
										<a href="#support" aria-controls="support" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Support')"/>
										</a>
									</li>
									<li role="presentation">
										<a href="#deprecated" aria-controls="deprecated" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Deprecated')"/>
										</a>
									</li>
									<!--<li role="presentation">
										<a href="#unclassified" aria-controls="unclassified" role="tab" data-toggle="tab">
											<xsl:value-of select="eas:i18n('Unclassified')"/>
										</a>
									</li>-->
								</ul>
								<div class="verticalSpacer_10px hidden-xs"/>
								<!-- Tab panes -->
								<div class="tab-content">
									<div role="tabpanel" class="tab-pane active" id="all">
										<h1 class="hubElementColor1">
											<xsl:value-of select="eas:i18n('Enterprise')"/>
										</h1>
										<div class="row">
											<xsl:apply-templates mode="Enterprise" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
										<div class="clear"/>
										<h1 class="hubElementColor2">
											<xsl:value-of select="eas:i18n('Business')"/>
										</h1>
										<div class="row">
											<xsl:apply-templates mode="Business" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
										<div class="clear"/>
										<h1 class="hubElementColor3">
											<xsl:value-of select="eas:i18n('Information')"/>
										</h1>
										<div class="row">
											<xsl:apply-templates mode="Information" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
										<div class="clear"/>
										<h1 class="hubElementColor4">
											<xsl:value-of select="eas:i18n('Application')"/>
										</h1>
										<div class="row">
											<xsl:apply-templates mode="Application" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
										<div class="clear"/>
										<h1 class="hubElementColor5">
											<xsl:value-of select="eas:i18n('Technology')"/>
										</h1>
										<div class="row">
											<xsl:apply-templates mode="Technology" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
                                        <div class="clear"/>
										<h1 class="hubElementColor6">
											<xsl:value-of select="eas:i18n('Support')"/>
										</h1>
                                        <div class="row">
                                        	<xsl:apply-templates mode="Support" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $supportArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
										<div class="clear"/>
										<h1 class="hubElementColor7">
											<xsl:value-of select="eas:i18n('Deprecated')"/>
										</h1>
										<div class="row">
											<xsl:apply-templates mode="Deprecated" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>
										<!--<div class="clear"/>
										<h1 class="hubElementColor7">
											<xsl:value-of select="eas:i18n('Unclassified')"/>
										</h1>
                                        <div class="row">
											<xsl:apply-templates mode="Unclassified" select="
												$allReports[
													not(own_slot_value[slot_reference = 'element_classified_by']/value = $supportArchViewsTaxonomyTerm/name)
													and not(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name)
													and not(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name)
													and not(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name)
													and not(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name)
													and not(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name)
													and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name)]">
													<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											</xsl:apply-templates>
										</div>-->
									</div>
									<div role="tabpanel" class="tab-pane" id="enterprise">
										<xsl:apply-templates mode="Enterprise" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<div role="tabpanel" class="tab-pane" id="business">
										<xsl:apply-templates mode="Business" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<div role="tabpanel" class="tab-pane" id="information">
										<xsl:apply-templates mode="Information" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<div role="tabpanel" class="tab-pane" id="application">
										<xsl:apply-templates mode="Application" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<div role="tabpanel" class="tab-pane" id="technology">
										<xsl:apply-templates mode="Technology" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<div role="tabpanel" class="tab-pane" id="support">
										<xsl:apply-templates mode="Support" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $supportArchViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name or own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<div role="tabpanel" class="tab-pane" id="deprecated">
										<xsl:apply-templates mode="Deprecated" select="$anyViews[(own_slot_value[slot_reference = 'element_classified_by']/value = $deprecatedViewsTaxonomyTerm/name) and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name)]">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>
									<!--<div role="tabpanel" class="tab-pane" id="unclassified">
										<xsl:apply-templates mode="Unclassified" select="
											$allReports[
												not(own_slot_value[slot_reference = 'element_classified_by']/value = $supportArchViewsTaxonomyTerm/name)
												and not(own_slot_value[slot_reference = 'element_classified_by']/value = $techArchViewsTaxonomyTerm/name)
												and not(own_slot_value[slot_reference = 'element_classified_by']/value = $appArchViewsTaxonomyTerm/name)
												and not(own_slot_value[slot_reference = 'element_classified_by']/value = $infArchViewsTaxonomyTerm/name)
												and not(own_slot_value[slot_reference = 'element_classified_by']/value = $busArchViewsTaxonomyTerm/name)
												and not(own_slot_value[slot_reference = 'element_classified_by']/value = $eaArchViewsTaxonomyTerm/name)
												and not(own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name)]">
												<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										</xsl:apply-templates>
									</div>-->                                  
								</div>
							</div>
							<!--Close Left Container-->
						</div>
						<!--Setup Right Hand Container-->
						<div class="col-xs-12 col-md-3">
							<div class=" bg-offwhite portalPanel">
							<xsl:variable name="catalogueViews" select="$enabledViews[own_slot_value[slot_reference = 'element_classified_by']/value = $catalogueViewsTaxonomyTerm/name]"/>
							<xsl:variable name="portalViews" select="$enabledViews[own_slot_value[slot_reference = 'element_classified_by']/value = $portalViewsTaxonomyTerm/name]"/>
							<xsl:variable name="dashboardViews" select="$enabledViews[own_slot_value[slot_reference = 'element_classified_by']/value = $dashboardViewsTaxonomyTerm/name]"/>
							<xsl:if test="count($catalogueViews) > 0">
								<h1 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogues')"/>
								</h1>
							</xsl:if>
							<xsl:if test="count($catalogueViews) > 0">
								<ul>
									<xsl:for-each select="$catalogueViews">
										<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
										<li class="fontSemi large">
											<xsl:call-template name="RenderCatalogueLink">
												<xsl:with-param name="theCatalogue" select="current()"/>
												<xsl:with-param name="viewScopeTerms" select="$homeViewScopeTerms"/>
												<xsl:with-param name="targetReport" select="()"/>
												<xsl:with-param name="targetMenu" select="()"/>
												<xsl:with-param name="anchorClass">text-darkgrey</xsl:with-param>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:if>
							</div>
						</div>
						<xsl:if test="$eipMode">
							<div class="col-xs-12 col-md-3 top-30">
								<div class="bg-offwhite portalPanel">
								<xsl:if test="count($enabledEditors) > 0">
									<h1 class="text-primary">
										<xsl:value-of select="eas:i18n('Editors')"/>
									</h1>
								</xsl:if>
								<xsl:if test="count($enabledEditors) > 0">
									<ul>
										<xsl:for-each select="$enabledEditors">
											<xsl:sort select="own_slot_value[slot_reference = 'report_label']/value"/>
											<xsl:if test="eas:isUserAuthZ(current())">
												<li class="fontSemi large">
													<a class="text-darkgrey" target="_blank">
														<xsl:attribute name="href">
															<xsl:call-template name="RenderEditorLinkHref">
																<xsl:with-param name="theEditor" select="current()"></xsl:with-param>
															</xsl:call-template>
														</xsl:attribute>
														<xsl:value-of select="current()/own_slot_value[slot_reference='report_label']/value"/>
													</a>
												</li>
											</xsl:if>
										</xsl:for-each>
									</ul>
								</xsl:if>
								</div>
							</div>
						</xsl:if>
						<!--Setup Closing Tags-->
					</div>
				</div>
				<div class="clear"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template mode="Enterprise" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor1'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="Business" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor2'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="Information" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor3'"/>
		</xsl:call-template>

	</xsl:template>

	<xsl:template mode="Application" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor4'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="Technology" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor5'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="Support" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor6'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template mode="Deprecated" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor7'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template mode="Unclassified" match="node()">
		<xsl:call-template name="PrintReportBox">
			<xsl:with-param name="aReport" select="current()"/>
			<xsl:with-param name="nameStyleSetting" select="' hubElementColor8'"/>
		</xsl:call-template>
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
		<xsl:variable name="qualifyingReport" select="$anyViews[name=$qualifyingReportId]"/>				
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
				<xsl:variable name="reportHistoryLabelName" select="$aReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
				<xsl:variable name="reportFilename" select="$aReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>

				<a class="noUL">
					<xsl:choose>
						<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
							<xsl:attribute name="href"></xsl:attribute>
							<xsl:attribute name="onclick">return false;</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="RenderLinkHref">
								<xsl:with-param name="theXSL" select="$reportFilename"/>
								<xsl:with-param name="theHistoryLabel" select="$reportHistoryLabelName"/>
								<xsl:with-param name="viewScopeTerms" select="$homeViewScopeTerms"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
						<div>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
										<xsl:value-of select="concat('inactive viewElementContainer ',$nameStyleSetting)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('viewElementContainer ',$nameStyleSetting)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
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
							<div class="viewElement-placeholder"/>
							<div class="report-element-preview">
								<span href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
									<i class="fa fa-search"/>
								</span>
							</div>
						</div>
					</div>
				</a>
			</xsl:when>
			
			<!-- Check that the user is authorised to access the qualifying report -->
			<xsl:when test="eas:isUserAuthZ($aReport) and eas:isUserAuthZ($qualifyingReport) and string-length($qualifyingReportId) > 0">
				<xsl:variable name="qualifyingReport" select="$anyViews[name = $qualifyingReportId]"/>
				<xsl:variable name="qualifyingReportHistoryLabelName" select="$qualifyingReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
				<xsl:variable name="qualifyingReportFilename" select="$qualifyingReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				<xsl:variable name="targetReportIdQueryString">
					<xsl:text>&amp;targetReportId=</xsl:text>
					<xsl:value-of select="$aReport/name"/>
				</xsl:variable>

				<a class="noUL">
					<xsl:choose>
						<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
							<xsl:attribute name="href"></xsl:attribute>
							<xsl:attribute name="onclick">return false;</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="RenderLinkHref">
								<xsl:with-param name="theXSL" select="$qualifyingReportFilename"/>
								<xsl:with-param name="theHistoryLabel" select="$qualifyingReportHistoryLabelName"/>
								<xsl:with-param name="viewScopeTerms" select="$homeViewScopeTerms"/>
								<xsl:with-param name="theUserParams" select="$targetReportIdQueryString"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
						<div>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
										<xsl:value-of select="concat('inactive viewElementContainer ',$nameStyleSetting)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('viewElementContainer ',$nameStyleSetting)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
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
							<div class="viewElement-placeholder"/>
							<div class="report-element-preview">
								<span href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
									<i class="fa fa-search"/>
								</span>
							</div>
						</div>
					</div>
				</a>

			</xsl:when>
			<xsl:otherwise>

				<!-- Check that user is authorised for the requested report -->
				<xsl:if test="eas:isUserAuthZ($aReport)">
					<xsl:choose>
						<xsl:when test="$aReport/type = 'Report'">
							<a class="noUL">
								<xsl:choose>
									<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
										<xsl:attribute name="href"></xsl:attribute>
										<xsl:attribute name="onclick">return false;</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="RenderLinkHref">
											<xsl:with-param name="theXSL" select="$reportFilename"/>
											<xsl:with-param name="theHistoryLabel" select="$reportHistoryLabelName"/>
											<xsl:with-param name="viewScopeTerms" select="$homeViewScopeTerms"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>

								<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
									<div>
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
													<xsl:value-of select="concat('inactive viewElementContainer ',$nameStyleSetting)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="concat('viewElementContainer ',$nameStyleSetting)"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
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
										<div class="viewElement-placeholder"/>
										<div class="report-element-preview">
											<span href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
												<i class="fa fa-search"/>
											</span>
										</div>
									</div>
								</div>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$eipMode">
								<xsl:variable name="thisEditorPath">
									<xsl:call-template name="RenderEditorLinkText">
										<xsl:with-param name="theEditor" select="$aReport"/>
									</xsl:call-template>
								</xsl:variable>
								<a class="noUL" target="_blank">
									<xsl:choose>
										<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
											<xsl:attribute name="href"></xsl:attribute>
											<xsl:attribute name="onclick">return false;</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="href" select="$thisEditorPath"/>
										</xsl:otherwise>
									</xsl:choose>
																
									<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
										<div>
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="$aReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'false'">
														<xsl:value-of select="concat('inactive viewElementContainer ',$nameStyleSetting)"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="concat('viewElementContainer ',$nameStyleSetting)"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
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
											<div class="viewElement-placeholder"/>
											<div class="report-element-preview">
												<span href="{$reportScreenshot}" data-toggle="lightbox" class="text-lightgrey">
													<i class="fa fa-search"/>
												</span>
											</div>
										</div>
									</div>
								</a>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>



	</xsl:template>

</xsl:stylesheet>
