<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<!--<xsl:include href="../information/menus/core_info_concept_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

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

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Concept')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- GET THE TAXONOMY TERMS TO BE USED FOR LAYERING BUSINESS DOMAINS -->
	<xsl:variable name="infoRefModelReport" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'report_label']/value = 'Information Reference Model')]"/>
	<xsl:variable name="reportConstant" select="/node()/simple_instance[name = $infoRefModelReport/own_slot_value[slot_reference = 'rp_report_constants']/value]"/>
	<xsl:variable name="layeringTaxonomy" select="/node()/simple_instance[name = $reportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="layeringTerms" select="/node()/simple_instance[name = $layeringTaxonomy/own_slot_value[slot_reference = 'taxonomy_terms']/value]"/>

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allBusDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>
	<xsl:variable name="allInfoDomains" select="/node()/simple_instance[type = 'Information_Domain']"/>
	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeDomains" select="$allBusDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeConcepts" select="$allInfoConcepts[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeDomains" select="$allBusDomains"/>
					<xsl:with-param name="inScopeConcepts" select="$allInfoConcepts"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Information Reference Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeDomains"/>
		<xsl:param name="inScopeConcepts"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderInfoConceptPopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">
											<xsl:value-of select="$pageLabel"/>
										</span>
									</h1>
								</div>
							</div>
						</div>

						<!--Setup Matrix Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Information Reference Model')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('The following diagram describes the different types of information that are in use across')"/>&#160;<xsl:value-of select="$orgName"/></p>
							<xsl:choose>
								<xsl:when test="count($allInfoDomains) > 0">
									<xsl:call-template name="infoReferenceModel">
										<xsl:with-param name="infoConcepts" select="$inScopeConcepts"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="referenceModel">
										<xsl:with-param name="busDomains" select="$inScopeDomains"/>
										<xsl:with-param name="infoConcepts" select="$inScopeConcepts"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>							
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
	
	<xsl:template name="infoReferenceModel">
		<xsl:param name="infoConcepts"/>
		<script type="text/javascript">
				$('document').ready(function(){
					 $(".gridModel_layerTitleContainerLabel").vAlign();
					 $(".gridModel_object").vAlign();
					 $(".gridModel_objectInactive").vAlign();
				});
		</script>
		<xsl:for-each select="$allInfoDomains">
			<xsl:sort select="own_slot_value[slot_reference = 'sequence_number']/value"/>
			<xsl:variable name="thisInfoDomain" select="current()"/>
			<xsl:variable name="infoDomainLabel">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$thisInfoDomain"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="relevantInfoConcepts" select="$infoConcepts[own_slot_value[slot_reference = 'info_concept_info_domain']/value = $thisInfoDomain/name]"/>
			<xsl:choose>
				<xsl:when test="(position() = 1)">
					<xsl:call-template name="PrintFirstBusinessDomain">
						<xsl:with-param name="busDomainLabel" select="$infoDomainLabel"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="(position() &gt; 1)">
					<xsl:call-template name="PrintOtherBusinessDomain">
						<xsl:with-param name="busDomainLabel" select="$infoDomainLabel"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<div class="gridModel_layerContentContainer backColour11 col-xs-12">
				<xsl:apply-templates mode="PrintInfoConcept" select="$relevantInfoConcepts">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</div>
			<div class="verticalSpacer_10px"/>
		</xsl:for-each>
	</xsl:template>




	<xsl:template name="referenceModel">
		<xsl:param name="busDomains"/>
		<xsl:param name="infoConcepts"/>
		<script type="text/javascript">
				$('document').ready(function(){
					 $(".gridModel_layerTitleContainerLabel").vAlign();
					 $(".gridModel_object").vAlign();
					 $(".gridModel_objectInactive").vAlign();
				});
		</script>
		<xsl:variable name="mappedBusDomains" select="$busDomains[name = $layeringTerms/own_slot_value[slot_reference = 'classifies_elements']/value]"/>
		<xsl:variable name="unmappedBusDomains" select="$busDomains except $mappedBusDomains"/>
		<xsl:for-each select="$mappedBusDomains">
			<xsl:sort select="$layeringTerms[name = current()/own_slot_value[slot_reference = 'element_classified_by']/value][1]/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
			<xsl:variable name="busDomainLabel" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="relevantInfoConcepts" select="$infoConcepts[own_slot_value[slot_reference = 'belongs_to_business_domain_information']/value = current()/name]"/>
			<xsl:choose>
				<xsl:when test="(position() = 1)">
					<xsl:call-template name="PrintFirstBusinessDomain">
						<xsl:with-param name="busDomainLabel" select="$busDomainLabel"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="(position() &gt; 1)">
					<xsl:call-template name="PrintOtherBusinessDomain">
						<xsl:with-param name="busDomainLabel" select="$busDomainLabel"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<div class="gridModel_layerContentContainer backColour11 col-xs-12">
				<xsl:apply-templates mode="PrintInfoConcept" select="$relevantInfoConcepts">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</div>
			<div class="verticalSpacer_10px"/>
		</xsl:for-each>
		<xsl:for-each select="$unmappedBusDomains">
			<xsl:variable name="busDomainLabel" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="relevantInfoConcepts" select="$infoConcepts[own_slot_value[slot_reference = 'belongs_to_business_domain_information']/value = current()/name]"/>
			<xsl:call-template name="PrintOtherBusinessDomain">
				<xsl:with-param name="busDomainLabel" select="$busDomainLabel"/>
			</xsl:call-template>
			<div class="gridModel_layerContentContainer backColour11 col-xs-12">
				<xsl:apply-templates mode="PrintInfoConcept" select="$relevantInfoConcepts">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</div>
			<div class="verticalSpacer_10px"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="PrintFirstBusinessDomain">
		<xsl:param name="busDomainLabel"/>
		<div class="gridModel_layerTitleContainerFullWidth_Rounded backColour11">
			<h3 class="text-white">
				<xsl:value-of select="$busDomainLabel"/>
			</h3>
		</div>
	</xsl:template>

	<xsl:template name="PrintOtherBusinessDomain">
		<xsl:param name="busDomainLabel"/>
		<div class="gridModel_layerTitleContainerFullWidth backColour11">
			<h3 class="text-white">
				<xsl:value-of select="$busDomainLabel"/>
			</h3>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="PrintInfoConcept">
		<xsl:variable name="infoConceptName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<div class="gridModel_objectContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="'gridModel_object bg-white small'"/>
			</xsl:call-template>
		</div>
	</xsl:template>




</xsl:stylesheet>
