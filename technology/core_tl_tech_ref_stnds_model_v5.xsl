<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!--
		* Copyright © 2008-2016 Enterprise Architecture Solutions Limited.
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
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Component')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- GET THE TAXONOMY TERMS TO BE USED FOR LAYERING APPLICATION CAPABILITIES -->
	<xsl:variable name="reportConstants" select="/node()/simple_instance[type = 'Report_Constant']"/>
	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>

	<xsl:variable name="monitoringConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Monitoring Term']"/>
	<xsl:variable name="monitoringTerm" select="$allTaxonomyTerms[name = $monitoringConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="configConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Configuration Term']"/>
	<xsl:variable name="configTerm" select="$allTaxonomyTerms[name = $configConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="platformConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Platform Term']"/>
	<xsl:variable name="platformTerm" select="$allTaxonomyTerms[name = $platformConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="centralConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Central Capabilities']"/>
	<xsl:variable name="centralTerms" select="$allTaxonomyTerms[name = $centralConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allTechCapabilities" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="pageLabel" select="concat('Technology Reference Model (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="inScopeTechCaps" select="$allTechCapabilities"/>
					<xsl:with-param name="inScopeTechComps" select="$allTechComponents"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeTechCaps" select="$allTechCapabilities"/>
					<xsl:with-param name="inScopeTechComps" select="$allTechComponents"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Technology Reference Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeTechCaps"/>
		<xsl:param name="inScopeTechComps"/>
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
				<!--<xsl:call-template name="RenderTechComponentPopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
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
							</div>
						</div>


						<!--Setup Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Technology Reference Model')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following diagram describes the different types of technology components that are in use across')"/>&#160;<xsl:value-of select="$orgName"/></p>
								<div class="simple-scroller">
									<div class="row">
										<xsl:call-template name="referenceModel">
											<xsl:with-param name="techCaps" select="$inScopeTechCaps"/>
											<xsl:with-param name="techComps" select="$inScopeTechComps"/>
										</xsl:call-template>
									</div>
								</div>
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




	<xsl:template name="referenceModel">
		<xsl:param name="techCaps"/>
		<xsl:param name="techComps"/>
		<script type="text/javascript">
				$('document').ready(function(){
					 $(".gridModel_layerTitleContainerLabel").vAlign();
					 $(".gridModel_object").vAlign();
					 $(".gridModel_objectInactive").vAlign();
				});
		</script>
		<script>
			function equalHeight(group) {
			   tallest = 0;
			   group.each(function() {
			      thisHeight = $(this).height()+40;
			      if(thisHeight > tallest) {
			         tallest = thisHeight;
			      }
			   });
			   group.height(tallest);
			}
			
			$(document).ready(function() {
			   equalHeight($(".equalise"));
			});
		</script>
		<style>
			.techRefModel_LeftColContentContainer,.techRefModel_CentreColContentContainer,.techRefModel_RightColContentContainer {display: table;}
		</style>
		<xsl:if test="count($configTerm) > 0">
			<div class="col-xs-3">
				<div id="techRefModel_leftContainer" class="backColourBlue equalise">
					<xsl:variable name="configLabel" select="$configTerm/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
					<xsl:variable name="configCaps" select="$techCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $configTerm/name]"/>
					<xsl:variable name="configComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $configCaps/name]"/>
					<div class="techRefModel_LeftColTitle backColourBlue">
						<h3 class="text-white">
							<xsl:value-of select="$configLabel"/>
						</h3>
					</div>
					<div class="techRefModel_LeftColContentContainer backColourBlue">
						<xsl:apply-templates mode="PrintTechComp" select="$configComps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="count($centralTerms) > 0">
			<div class="col-xs-6">
				<div id="techRefModel_centreContainer" class="equalise">
					<xsl:for-each select="$centralTerms">
						<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
						<xsl:variable name="centralLabel" select="own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
						<xsl:variable name="centralCaps" select="$techCaps[own_slot_value[slot_reference = 'element_classified_by']/value = current()/name]"/>
						<xsl:variable name="centralComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $centralCaps/name]"/>
						<xsl:choose>
							<xsl:when test="count($centralComps) &gt; 0">
								<div class="techRefModel_CentreBox">
									<div class="techRefModel_CentreColTitle backColourBlue">
										<h3 class="text-white">
											<xsl:value-of select="$centralLabel"/>
										</h3>
									</div>
									<div class="techRefModel_CentreColContentContainer backColourBlue col-xs-6">
										<xsl:apply-templates mode="PrintTechComp" select="$centralComps">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</div>
								</div>
								<xsl:if test="position() != count($centralTerms)">
									<div class="verticalSpacer_20px"/>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="count($monitoringTerm) > 0">
			<div class="col-xs-3">
				<div id="techRefModel_rightContainer" class="backColourBlue equalise">
					<xsl:variable name="monitoringLabel" select="$monitoringTerm/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
					<xsl:variable name="monitoringCaps" select="$techCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $monitoringTerm/name]"/>
					<xsl:variable name="monitoringComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $monitoringCaps/name]"/>
					<div class="techRefModel_RightColTitle backColourBlue">
						<h3 class="text-white">
							<xsl:value-of select="$monitoringLabel"/>
						</h3>
					</div>
					<div class="techRefModel_RightColContentContainer backColourBlue">
						<xsl:apply-templates mode="PrintTechComp" select="$monitoringComps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="count($platformTerm) > 0">
			<div class="verticalSpacer_20px"/>
			<div class="col-xs-12">
				<div id="techRefModel_bottomContainer">
					<xsl:variable name="platformLabel" select="$platformTerm/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
					<xsl:variable name="platformCaps" select="$techCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $platformTerm/name]"/>
					<xsl:variable name="platformComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $platformCaps/name]"/>
					<div class="techRefModel_BottomColTitle backColourBlue col-xs-12">
						<h3 class="text-white">
							<xsl:value-of select="$platformLabel"/>
						</h3>
					</div>
					<div class="techRefModel_BottomColContentContainer backColourBlue col-xs-12">
						<xsl:apply-templates mode="PrintTechComp" select="$platformComps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="PrintTechComp">
		<xsl:variable name="techCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<div class="gridModel_objectContainer">
			<!--<a id="{$techCapName}" class="context-menu-techComponent menu-1">
				<xsl:call-template name="RenderLinkHref">
					<xsl:with-param name="theInstanceID">
						<xsl:value-of select="name" />
					</xsl:with-param>
					<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
					<xsl:with-param name="theParam4" select="$param4" />
					<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
					<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
				</xsl:call-template>
				<div class="gridModel_object bg-white">
					<xsl:value-of select="$techCapName" />
				</div>
			</a>-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="'gridModel_object greyButton1 bg-white small'"/>
			</xsl:call-template>
		</div>
	</xsl:template>



</xsl:stylesheet>
