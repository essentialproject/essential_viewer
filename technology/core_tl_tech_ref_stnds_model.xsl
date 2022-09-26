<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


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
	<xsl:variable name="linkClasses" select="('Technology_Component', 'Technology_Capability', 'Technology_Domain')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- GET THE TAXONOMY TERMS TO BE USED FOR LAYERING APPLICATION CAPABILITIES -->
	<xsl:variable name="reportConstants" select="/node()/simple_instance[type = 'Report_Constant']"/>
	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>

	<xsl:variable name="monitoringConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Monitoring Term']"/>
	<xsl:variable name="monitoringTerm" select="$allTaxonomyTerms[(name = $monitoringConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value) or (own_slot_value[slot_reference = 'name']/value = 'Right')]"/>

	<xsl:variable name="configConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Configuration Term']"/>
	<xsl:variable name="configTerm" select="$allTaxonomyTerms[(name = $configConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value) or (own_slot_value[slot_reference = 'name']/value = 'Left')]"/>

	<xsl:variable name="platformConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Platform Term']"/>
	<xsl:variable name="platformTerm" select="$allTaxonomyTerms[(name = $platformConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value) or (own_slot_value[slot_reference = 'name']/value = 'Bottom')]"/>

	<xsl:variable name="centralConstant" select="$reportConstants[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Central Capabilities']"/>
	<xsl:variable name="centralTerms" select="$allTaxonomyTerms[(name = $centralConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value) or (own_slot_value[slot_reference = 'name']/value = ('Top', 'Middle'))]"/>

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	<xsl:variable name="allTechCapabilities" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>

	<xsl:variable name="maxDepth" select="4"/>

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
											<xsl:with-param name="techDomains" select="$allTechDomains"/>
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
		<xsl:param name="techDomains"/>
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
			      thisHeight = $(this).height();
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
		<div class="col-xs-3">
			<div id="techRefModel_leftContainer" class="backColourBlue equalise">
				<xsl:variable name="configDomains" select="$techDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $configTerm/name]"/>
				<xsl:for-each select="$configDomains">
					<xsl:variable name="domainLabel"><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>
					<xsl:variable name="domainCaps" select="$techCaps[own_slot_value[slot_reference = 'belongs_to_technology_domain']/value = current()/name]"/>
					<xsl:variable name="allDomainCaps" select="eas:get_techcap_descendants($domainCaps, $techCaps, 1)"/>
					<xsl:variable name="domainComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $allDomainCaps/name]"/>
					<xsl:choose>
						<xsl:when test="count($domainComps) &gt; 0">
							<div class="techRefModel_CentreBox">
								<div class="techRefModel_LeftColTitle backColourBlue">
									<h3 class="text-white">
										<!--<xsl:value-of select="$centralLabel"/>-->
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="anchorClass" select="'text-white'"/>
										</xsl:call-template>
									</h3>
								</div>
								<div class="techRefModel_LeftColContentContainer backColourBlue col-xs-6">
									<xsl:apply-templates mode="PrintTechComp" select="$domainComps">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									</xsl:apply-templates>
								</div>
							</div>						
							<xsl:if test="position() != last()">
								<div class="verticalSpacer_20px bg-white"/>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</div>
		</div>
		<div class="col-xs-6">
			<div id="techRefModel_centreContainer" class="equalise">
				<xsl:for-each select="$centralTerms">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:variable name="centralDomains" select="$techDomains[own_slot_value[slot_reference = 'element_classified_by']/value = current()/name]"/>
					<xsl:for-each select="$centralDomains">
						<xsl:variable name="centralLabel"><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>
						<xsl:variable name="centralCaps" select="$techCaps[own_slot_value[slot_reference = 'belongs_to_technology_domain']/value = current()/name]"/>
						<xsl:variable name="allCentralCaps" select="eas:get_techcap_descendants($centralCaps, $techCaps, 1)"/>
						<xsl:variable name="centralComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $allCentralCaps/name]"/>
						<xsl:choose>
							<xsl:when test="count($centralComps) &gt; 0">
								<div class="techRefModel_CentreBox">
									<div class="techRefModel_CentreColTitle backColourBlue">
										<h3 class="text-white">
											<!--<xsl:value-of select="$centralLabel"/>-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="anchorClass" select="'text-white'"/>
											</xsl:call-template>
										</h3>
									</div>
									<div class="techRefModel_CentreColContentContainer backColourBlue col-xs-6">
										<xsl:apply-templates mode="PrintTechComp" select="$centralComps">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</div>
								</div>
							</xsl:when>
						</xsl:choose>
						<div class="verticalSpacer_20px"/>
					</xsl:for-each>
				</xsl:for-each>
			</div>
		</div>
		<div class="col-xs-3">
			<div id="techRefModel_rightContainer" class="backColourBlue equalise">
				<xsl:variable name="monitoringDomains" select="$techDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $monitoringTerm/name]"/>
				<xsl:for-each select="$monitoringDomains">
					<xsl:variable name="domainLabel"><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>
					<xsl:variable name="domainCaps" select="$techCaps[own_slot_value[slot_reference = 'belongs_to_technology_domain']/value = current()/name]"/>
					<xsl:variable name="allDomainCaps" select="eas:get_techcap_descendants($domainCaps, $techCaps, 1)"/>
					<xsl:variable name="domainComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $allDomainCaps/name]"/>
					<xsl:choose>
						<xsl:when test="count($domainComps) &gt; 0">
							<div class="techRefModel_CentreBox">
								<div class="techRefModel_RightColTitle backColourBlue">
									<h3 class="text-white">
										<!--<xsl:value-of select="$centralLabel"/>-->
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="anchorClass" select="'text-white'"/>
										</xsl:call-template>
									</h3>
								</div>
								<div class="techRefModel_RightColContentContainer backColourBlue col-xs-6">
									<xsl:apply-templates mode="PrintTechComp" select="$domainComps">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									</xsl:apply-templates>
								</div>
							</div>
							<xsl:if test="position() != last()">
								<div class="verticalSpacer_20px bg-white"/>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</div>
		</div>
		<div class="verticalSpacer_20px"/>
		<div class="col-xs-12">
			<div id="techRefModel_bottomContainer">
				<xsl:variable name="platformDomains" select="$techDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $platformTerm/name]"/>
				<xsl:for-each select="$platformDomains">
					<xsl:variable name="domainLabel"><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>
					<xsl:variable name="domainCaps" select="$techCaps[own_slot_value[slot_reference = 'belongs_to_technology_domain']/value = current()/name]"/>
					<xsl:variable name="allDomainCaps" select="eas:get_techcap_descendants($domainCaps, $techCaps, 1)"/>
					<xsl:variable name="domainComps" select="$techComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $allDomainCaps/name]"/>
					<xsl:choose>
						<xsl:when test="count($domainComps) &gt; 0">
							<div class="techRefModel_CentreBox">
								<div class="techRefModel_BottomColTitle backColourBlue">
									<h3 class="text-white">
										<!--<xsl:value-of select="$centralLabel"/>-->
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="anchorClass" select="'text-white'"/>
										</xsl:call-template>
									</h3>
								</div>
								<div class="techRefModel_BottomColContentContainer backColourBlue col-xs-6">
									<xsl:apply-templates mode="PrintTechComp" select="$domainComps">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									</xsl:apply-templates>
								</div>
							</div>
						</xsl:when>
					</xsl:choose>
					<div class="verticalSpacer_20px bg-white"/>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>


	<xsl:template match="node()" mode="PrintTechComp">
		<xsl:variable name="techCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<div class="gridModel_objectContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="'gridModel_object greyButton1 bg-white small'"/>
			</xsl:call-template>
		</div>
	</xsl:template>


	<!-- FUNCTION TO RETRIEVE THE LIST OF CHILD ORGS FOR A GIVEN ORG, INCLUDING THE GIVEN ORG ITSELF -->
	<xsl:function name="eas:get_techcap_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeTechCaps"/>
		<xsl:param name="level"/>

		<xsl:sequence select="$parentNode"/>
		<xsl:if test="$level &lt; $maxDepth">
			<xsl:variable name="childTechCaps" select="$inScopeTechCaps[name = $parentNode/own_slot_value[slot_reference = 'contained_technology_capabilities']/value]" as="node()*"/>
			<xsl:for-each select="$childTechCaps">
				<xsl:sequence select="eas:get_techcap_descendants(current(), $inScopeTechCaps, $level + 1)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>


</xsl:stylesheet>
