<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



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


	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Supplier')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Product Catalogue by Vendor')"/>
	</xsl:variable>
	<xsl:variable name="techProdListByComponentCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Product Catalogue by Technology Component')]"/>
	<xsl:variable name="techProdListByCapCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Product Catalogue by Technology Capability')]"/>
	<xsl:variable name="techProdListAsTableCatalogue" select="eas:get_report_by_name('Core: Technology Product Cataloigue as Table')"/>
	<xsl:variable name="allTechSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeTechSuppliers" select="$allTechSuppliers"/>
					<!-- DOES NOT FILTER SUPPLIERS WITH TAXONOMY TERMS -->
					<xsl:with-param name="inScopeTechProds" select="$allTechProds[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeTechSuppliers" select="$allTechSuppliers"/>
					<xsl:with-param name="inScopeTechProds" select="$allTechProds"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="inScopeTechSuppliers"/>
		<xsl:param name="inScopeTechProds"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js?release=6.19"/>
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
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techProdListByCapCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Capability'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Vendor')"/>
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
								<p><xsl:value-of select="eas:i18n('Click on one of the Technology Products below to navigate to the required view')"/>.</p>
								<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:&#160;</div>
								<div class="AlphabetQuickJumpLinks hidden-xs">
									
									<!-- Build a list of the names of the elements to be sorted -->
									<xsl:variable name="anInFocusInstances" select="$inScopeTechSuppliers"></xsl:variable>
									
									<!-- Get the names of the in-focus instances -->
									<xsl:variable name="anIndexList" select="$anInFocusInstances/own_slot_value[slot_reference='name']/value"></xsl:variable>																		
									
									<!-- Generate the index based on the set of elements in the indexList -->																			
									<xsl:call-template name="eas:renderIndex">
										<xsl:with-param name="theIndexList" select="$anIndexList"></xsl:with-param>
										<xsl:with-param name="theInFocusInstances" select="$anInFocusInstances"></xsl:with-param>
										<xsl:with-param name="theInScopeTechProds" select="$inScopeTechProds"></xsl:with-param>
									</xsl:call-template>
									
									<a class="AlphabetLinks" href="#section_number">#</a>
								</div>

								<a id="section_number"/>

								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'0'"/>
									<xsl:with-param name="letterLow" select="'0'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'1'"/>
									<xsl:with-param name="letterLow" select="'1'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'2'"/>
									<xsl:with-param name="letterLow" select="'2'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'3'"/>
									<xsl:with-param name="letterLow" select="'3'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'4'"/>
									<xsl:with-param name="letterLow" select="'4'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'5'"/>
									<xsl:with-param name="letterLow" select="'5'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'6'"/>
									<xsl:with-param name="letterLow" select="'6'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'7'"/>
									<xsl:with-param name="letterLow" select="'7'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'8'"/>
									<xsl:with-param name="letterLow" select="'8'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>


								<xsl:call-template name="Index">
									<xsl:with-param name="letterCap" select="'9'"/>
									<xsl:with-param name="letterLow" select="'9'"/>
									<xsl:with-param name="inScopeSuppliers" select="$inScopeTechSuppliers"/>
									<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
								</xsl:call-template>

							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Index">
		<xsl:param name="inScopeSuppliers"/>
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="letterCap"/>
		<xsl:param name="letterLow"/>
		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="$letterCap"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_</xsl:text>
		<xsl:value-of select="$letterCap"/>
		<xsl:text disable-output-escaping="yes">"&gt;&lt;/a&gt;</xsl:text>

		<!-- TECH COMPS START HERE -->
		<xsl:variable name="vendorList" select="$inScopeSuppliers[((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
		<xsl:choose>
			<xsl:when test="count($vendorList) > 0">
				<xsl:apply-templates select="$vendorList" mode="Technology_Suppliers">
					<xsl:with-param name="compLetterCap" select="$letterCap"/>
					<xsl:with-param name="compLetterLow" select="$letterLow"/>
					<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
				<div class="jumpToTopLink">
					<a href="#top" class="topLink">
						<xsl:value-of select="eas:i18n('Back to Top')"/>
					</a>
				</div>
				<div class="clear"/>
				<hr/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="orphanProds" select="$inScopeTechProds[(not(count(own_slot_value[slot_reference = 'supplier_technology_product']/value) > 0)) and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
				<xsl:if test="count($orphanProds) > 0">
					<h3>
						<xsl:value-of select="eas:i18n('No Product Vendor Defined')"/>
					</h3>
					<div class="tech_products">
						<ul>
							<xsl:apply-templates select="$orphanProds" mode="TechnologyProduct">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="count($vendorList) = 0">
			<xsl:apply-templates select="$vendorList" mode="Technology_Suppliers">
				<xsl:with-param name="inScopeTechProds" select="$inScopeTechProds"/>
				<xsl:with-param name="compLetterCap" select="$letterCap"/>
				<xsl:with-param name="compLetterLow" select="$letterLow"/>
				<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>
			<div class="jumpToTopLink">
				<a href="#top" class="topLink">
					<xsl:value-of select="eas:i18n('Back to Top')"/>
				</a>
			</div>
			<div class="clear"/>
			<hr/>
		</xsl:if>

		<!-- TECH COMPS END HERE -->

	</xsl:template>

	<xsl:template match="node()" mode="Technology_Suppliers">
		<xsl:param name="inScopeTechProds"/>
		<xsl:param name="compLetterCap"/>
		<xsl:param name="compLetterLow"/>

		<xsl:variable name="currentSupplier" select="current()"/>


		<h3>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$currentSupplier"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</h3>
		<div class="catalogItems">
			<ul>
				<xsl:apply-templates select="$inScopeTechProds[(own_slot_value[slot_reference = 'supplier_technology_product']/value = $currentSupplier/name)]" mode="TechnologyProduct">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>

	</xsl:template>


	<!-- Render the Technology Provider Name from a Technology Provider node -->
	<xsl:template match="node()" mode="TechnologyProduct">

		<xsl:variable name="techProdName">
			<xsl:value-of select="translate(own_slot_value[slot_reference = 'product_label']/value, '::', ' ')"/>
		</xsl:variable>

		<xsl:choose>
			<!-- If the product label is defined properly -->
			<xsl:when test="string-length($techProdName) > 0">
				<li>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="targetMenu" select="$targetMenu"/>
						<xsl:with-param name="targetReport" select="$targetReport"/>
						<xsl:with-param name="displayString" select="$techProdName"/>
					</xsl:call-template>
				</li>
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
				<xsl:with-param name="inScopeSuppliers" select="$theInFocusInstances"/>
				<xsl:with-param name="inScopeTechProds" select="$theInScopeTechProds"></xsl:with-param>
			</xsl:call-template>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
