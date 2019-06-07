<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<!--<xsl:include href="../technology/menus/core_tech_product_menu.xsl" />-->

	<xsl:output method="html"/>

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
	<!-- 30.07.2018	JWC i18N version of catalogue -->

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->


	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Technology_Component', 'Technology_Capability')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Product Catalogue by Capability')"/>
	</xsl:variable>
	<xsl:variable name="techProdListByVendorCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Product Catalogue by Vendor')]"/>
	<xsl:variable name="techProdListByComponentCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Product Catalogue by Technology Component')]"/>
	<xsl:variable name="techProdListAsTableCatalogue" select="eas:get_report_by_name('Core: Technology Product Cataloigue as Table')"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeTechComps" select="$allTechComps[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeTechProds" select="$allTechProds[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeTechComps" select="$allTechComps"/>
					<xsl:with-param name="inScopeTechProds" select="$allTechProds"/>
					<xsl:with-param name="inScopeTechProdRoles" select="$allTechProdRoles"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="inScopeTechComps"/>
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="inScopeTechProdRoles"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<!--script to turn the app providers list into columns-->
				<script>				
					$(function(){					
						if (document.documentElement.clientWidth &gt; 767) {
							$('.catalogItems').columnize({columns: 2});
						}			
					});
				</script>
				<!--script to support smooth scroll back to top of page-->
				<script type="text/javascript">
					$(document).ready(function() {
					    $('a.topLink').click(function(){
					        $('html, body').animate({scrollTop:0}, 'slow');
					        return false;
					    });
					});
				</script>
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
									<span class="text-primary">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByComponentCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Component'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Capability')"/>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByVendorCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListAsTableCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Table'"/>
										</xsl:call-template>
									</span>
								</div>
							</div>
						</div>

						<!--Setup Description Section-->
					</div>
					<div class="row">
						<div id="sectionCatalogue">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>

								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogue')"/>
								</h2>

								<p><xsl:value-of select="eas:i18n('Click on one of the Technology Components or Technology Products below to navigate to the required view')"/>.</p>

								<div id="keyContainer">
									<div class="keyLabel"><xsl:value-of select="eas:i18n('Strategy Alignment')"/>:</div>
									<div class="keySample cellRAG_Green"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('On Strategy')"/>
									</div>
									<div class="keySample cellRAG_Red"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Off Strategy')"/>
									</div>
									<div class="keySample bg-white"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Unknown (Waiver Required)')"/>
									</div>

								</div>
								<div class="verticalSpacer_10px"/>
								<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:&#160;</div>
								<div class="AlphabetQuickJumpLinks hidden-xs">
									
									<!-- Build a list of the names of the elements to be sorted -->
									<xsl:variable name="anInFocusInstances" select="$inScopeTechComps"></xsl:variable>
									
									<!-- Get the names of the in-focus instances -->
									<xsl:variable name="anIndexList" select="$anInFocusInstances/own_slot_value[slot_reference='name']/value"></xsl:variable>																		
									
									<!-- Generate the index based on the set of elements in the indexList -->																			
									<xsl:call-template name="eas:renderIndex">
										<xsl:with-param name="theIndexList" select="$anIndexList"></xsl:with-param>
										<xsl:with-param name="theInFocusInstances" select="$anInFocusInstances"></xsl:with-param>
										<xsl:with-param name="theInScopeTechProds" select="$inScopeTechProds"></xsl:with-param>
										<xsl:with-param name="theInScopeTechProdRoles" select="$inScopeTechProdRoles"></xsl:with-param>
									</xsl:call-template>
									
									<a class="AlphabetLinks" href="#section_number">#</a>
								</div>
								<div class="clear"/>

								<a id="section_number"/>

								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'0'"/>
									<xsl:with-param name="letterLow" select="'0'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'1'"/>
									<xsl:with-param name="letterLow" select="'1'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'2'"/>
									<xsl:with-param name="letterLow" select="'2'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'3'"/>
									<xsl:with-param name="letterLow" select="'3'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'4'"/>
									<xsl:with-param name="letterLow" select="'4'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'5'"/>
									<xsl:with-param name="letterLow" select="'5'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'6'"/>
									<xsl:with-param name="letterLow" select="'6'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'7'"/>
									<xsl:with-param name="letterLow" select="'7'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'8'"/>
									<xsl:with-param name="letterLow" select="'8'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'9'"/>
									<xsl:with-param name="letterLow" select="'9'"/>
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>

								<xsl:call-template name="Orphans">
									<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
									<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
								</xsl:call-template>


							</div>
							<div class="clear"/>
						</div>
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>



	<xsl:template name="Index">
		<xsl:param name="letterCap"/>
		<xsl:param name="letterLow"/>
		<xsl:param name="inScopeTechComps"/>
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="inScopeTechProdRoles"/>

		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="$letterCap"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_</xsl:text>
		<xsl:value-of select="$letterCap"/>
		<xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

		<!-- TECH Capabilities START HERE -->
		<xsl:variable name="capList" select="$allTechCaps[((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
		<xsl:apply-templates select="$capList" mode="CapIndex">
			<xsl:with-param name="compLetterCap" select="$letterCap"/>
			<xsl:with-param name="compLetterLow" select="$letterLow"/>
			<xsl:with-param name="inScopeTechComps" select="$inScopeTechComps"/>
			<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
			<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
			<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates>
		<div class="clear"/>
		<div class="jumpToTopLink">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
		<!-- TECH Caps END HERE -->
	</xsl:template>

	<xsl:template name="Orphans">
		<xsl:param name="inScopeTechComps"/>
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="inScopeTechProdRoles"/>

		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="eas:i18n('Others')"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_orphans"&gt;&lt;/a&gt;</xsl:text>

		<h3>
			<xsl:value-of select="eas:i18n('No Technology Capability Defined')"/>
		</h3>
		<xsl:variable name="orphanComps" select="$inScopeTechComps[not(count(own_slot_value[slot_reference = 'realisation_of_technology_capability']) > 0)]"/>
		<xsl:apply-templates select="$orphanComps" mode="TechnologyComponents">
			<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
			<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
			<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
		</xsl:apply-templates>

		<h3>
			<xsl:value-of select="eas:i18n('No Technology Component defined')"/>
		</h3>
		<div class="tech_products">
			<ul>
				<xsl:apply-templates select="$inScopeTechProds[(not(count(own_slot_value[slot_reference = 'implements_technology_components']/value) > 0))]" mode="TechnologyProduct">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>
		<div class="clear"/>
		<div class="jumpToTopLink">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>



	<xsl:template mode="CapIndex" match="node()">
		<xsl:param name="inScopeTechComps"/>
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="inScopeTechProdRoles"/>

		<div class="LRC_Header">
			<h3 class="text-white">
				<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
			</h3>
		</div>
		<div class="largeRoundedContainer">
			<div class="LRC_topLeft"/>
			<div class="LRC_middle"/>
			<div class="LRC_topRight"/>
			<!-- TECH COMPS START HERE -->
			<xsl:variable name="compList" select="/node()/simple_instance[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>
			<xsl:choose>
				<xsl:when test="count($compList) > 0">
					<xsl:apply-templates select="$compList" mode="TechnologyComponents">
						<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
						<xsl:with-param name="inScopeTechProdRoles" select="$inScopeTechProdRoles"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<em>
							<xsl:value-of select="eas:i18n('No Components Defined')"/>
						</em>
					</p>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
			<div class="LRC_bottomLeft"/>
			<div class="LRC_middle"/>
			<div class="LRC_bottomRight"/>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="TechnologyComponents">
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="inScopeTechProdRoles"/>
		<xsl:variable name="thisone">
			<xsl:value-of select="name"/>
		</xsl:variable>

		<h5>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</h5>
		<div class="catalogItems">
			<ul>
				<xsl:apply-templates select="$inScopeTechProdRoles[(own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisone)]" mode="TechnologyProductRoles">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>

	<!-- Use any common rendering templates for Tech Prod Roles -->
	<xsl:template match="node()" mode="TechnologyProductRoles">
		<xsl:param name="inScopeTechProds"/>
		<xsl:variable name="productRole" select="current()"/>
		<xsl:apply-templates select="$inScopeTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]" mode="TechnologyProduct">
			<xsl:with-param name="lifecycleStatusId" select="current()/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value"/>
		</xsl:apply-templates>
	</xsl:template>


	<!-- Render the Technology Provider Name from a Technology Provider node -->
	<xsl:template match="node()" mode="TechnologyProduct">
		<xsl:param name="lifecycleStatusId">usage undefined</xsl:param>
		<xsl:variable name="lifecycle_status" select="$allLifecycleStatii[name = $lifecycleStatusId]"/>
		<xsl:variable name="prodLifecycleId" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'ProductionStrategic']/name"/>
		<xsl:variable name="offStratLifecycleId" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'OffStrategy']/name"/>


		<xsl:variable name="techProdName">
			<xsl:value-of select="translate(own_slot_value[slot_reference = 'product_label']/value, '::', ' ')"/>
		</xsl:variable>

		<xsl:choose>

			<!-- If the product label is defined properly -->
			<xsl:when test="string-length($techProdName) > 0">
				<!-- Set the background colour depending upon the lifecycle status of the product role -->
				<xsl:choose>
					<xsl:when test="compare($lifecycle_status[1]/name, $prodLifecycleId) = 0">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="targetMenu" select="$targetMenu"/>
								<xsl:with-param name="targetReport" select="$targetReport"/>
								<xsl:with-param name="displayString" select="$techProdName"/>
								<xsl:with-param name="anchorClass" select="'ragTextGreen'"/>
							</xsl:call-template>
						</li>
					</xsl:when>
					<xsl:when test="compare($lifecycle_status/name, $offStratLifecycleId) = 0">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="targetMenu" select="$targetMenu"/>
								<xsl:with-param name="targetReport" select="$targetReport"/>
								<xsl:with-param name="displayString" select="$techProdName"/>
								<xsl:with-param name="anchorClass" select="'backColourRed'"/>
							</xsl:call-template>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="targetMenu" select="$targetMenu"/>
								<xsl:with-param name="targetReport" select="$targetReport"/>
								<xsl:with-param name="displayString" select="$techProdName"/>
								<!--<xsl:with-param name="anchorClass" select="'backColourRed'"/>-->
								<xsl:with-param name="anchorClass" select="'text-default'"/>
							</xsl:call-template>
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>

			<!-- Otherwise, just use the 'name' slot -->
			<xsl:otherwise>
				<li>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="targetMenu" select="$targetMenu"/>
						<xsl:with-param name="targetReport" select="$targetReport"/>
					</xsl:call-template>
				</li>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>
	
	<!-- Render alphabetic catalogues -->
	<!-- Render the index keys, as a set of hyperlinks to sections of the catalogue that have instances
		Ordered alphabetically -->
	<xsl:template name="eas:renderIndex">
		<xsl:param name="theIndexList"></xsl:param>
		<xsl:param name="theInFocusInstances"></xsl:param>
		<xsl:param name="theInScopeTechProds"></xsl:param>
		<xsl:param name="theInScopeTechProdRoles"></xsl:param>
		
		<!-- Generate the index based on the set of elements in the indexList -->																		
		<xsl:variable name="anIndexKeys" select="eas:getFirstCharacter($theIndexList)"></xsl:variable>									
		<xsl:call-template name="eas:renderIndexSections">
			<xsl:with-param name="theIndexOfNames" select="$anIndexKeys"></xsl:with-param>
		</xsl:call-template>
		
		<a class="AlphabetLinks" href="#section_number">#</a>
		
		<!-- Render each section of the index -->
		<xsl:for-each select="$anIndexKeys">
			<xsl:call-template name="Index">
				<xsl:with-param name="letterCap" select="upper-case(current())"/>
				<xsl:with-param name="letterLow" select="lower-case(current())"/>
				<xsl:with-param name="inScopeTechComps" select="$theInFocusInstances"/>
				<xsl:with-param name="inScopeTechProds" select="$theInScopeTechProds"></xsl:with-param>
				<xsl:with-param name="inScopeTechProdRoles" select="$theInScopeTechProdRoles"></xsl:with-param>
			</xsl:call-template>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
