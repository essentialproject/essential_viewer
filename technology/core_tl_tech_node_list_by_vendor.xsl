<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



	<xsl:output method="html"/>

	<!--<xsl:param name="param1" />
	<xsl:variable name="TechnologyProvider" select="/node()/simple_instance[name=$param1]" />-->

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
	<!-- 27.07.2018	JWC i18N version of catalogue -->
	

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Technology_Node', 'Supplier')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Node Catalogue by Vendor')"/>
	</xsl:variable>
	<xsl:variable name="techNodeListByNameCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Name')]"/>
	<xsl:variable name="techNodeListByVendorCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Vendor')]"/>
	<xsl:variable name="techNodeListByProductCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Product')]"/>
	<xsl:variable name="techNodeListAsTable" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue as Table')]"/>
	<xsl:variable name="allTechNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
	<xsl:variable name="allTechProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>

	<xsl:template match="knowledge_base">
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
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Name'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<!--<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
									</span>-->
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Vendor')"/>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByProductCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Product'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListAsTable"/>
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

					</div>
					<div class="row">
						<div class="col-xs-12">
							<!--Setup Catalogue Section-->
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>
							<p>
								<xsl:value-of select="eas:i18n('Click on one of the Physical Nodes below to view its detailed specification')"/>
							</p>
							<xsl:variable name="allSuppliersForNodes" select="$allSuppliers[name=$allTechNodes/own_slot_value[slot_reference='tn_supplier']/value]"></xsl:variable>
							<xsl:variable name="allTechProdForNodes" select="$allTechProducts[name=$allTechNodes/own_slot_value[slot_reference='deployment_of']/value]"></xsl:variable>
							<xsl:variable name="allSuppliersForTechProdNodes" select="$allSuppliers[name=$allTechProdForNodes/own_slot_value[slot_reference='supplier_technology_product']/value]"></xsl:variable>
							<xsl:variable name="allInScopeSuppliers" select="$allSuppliersForNodes union $allSuppliersForTechProdNodes"></xsl:variable>
							<div class="AlphabetQuickJumpLabel hidden-xs"><xsl:value-of select="eas:i18n('Go to')"/>:&#160;</div>
							<div class="AlphabetQuickJumpLinks hidden-xs">
																
								<!-- Build a list of the names of the elements to be sorted -->
								<xsl:variable name="anInFocusInstances" select="$allInScopeSuppliers"></xsl:variable>
								
								<!-- Get the names of the in-focus instances -->
								<xsl:variable name="anIndexList" select="$anInFocusInstances/own_slot_value[slot_reference='name']/value"></xsl:variable>																		
								
								<!-- Generate the index based on the set of elements in the indexList -->																			
								<xsl:call-template name="eas:renderIndex">
									<xsl:with-param name="theIndexList" select="$anIndexList"></xsl:with-param>
									<xsl:with-param name="theInFocusInstances" select="$anInFocusInstances"></xsl:with-param>
								</xsl:call-template>
								
								<a class="AlphabetLinks" href="#section_number">#</a>
								<a class="AlphabetLinks" href="#section_other">
									<xsl:value-of select="eas:i18n('Other')"/>
								</a>
							</div>
							<div class="clear"/>

							<a id="section_number"/>

							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'0'"/>
								<xsl:with-param name="letterLow" select="'0'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'1'"/>
								<xsl:with-param name="letterLow" select="'1'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'2'"/>
								<xsl:with-param name="letterLow" select="'2'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'3'"/>
								<xsl:with-param name="letterLow" select="'3'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'4'"/>
								<xsl:with-param name="letterLow" select="'4'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'5'"/>
								<xsl:with-param name="letterLow" select="'5'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'6'"/>
								<xsl:with-param name="letterLow" select="'6'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'7'"/>
								<xsl:with-param name="letterLow" select="'7'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'8'"/>
								<xsl:with-param name="letterLow" select="'8'"/>
							</xsl:call-template>


							<xsl:call-template name="Index">
								<xsl:with-param name="letterCap" select="'9'"/>
								<xsl:with-param name="letterLow" select="'9'"/>
							</xsl:call-template>

							<xsl:call-template name="Orphans"/>

						</div>
						<div class="clear"/>

					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Index">
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

		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="node_list" select="$allTechNodes[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				<xsl:variable name="product_list" select="$allTechProducts[name = $node_list/own_slot_value[slot_reference = 'deployment_of']/value]"/>
				<xsl:variable name="vendor_list" select="$allSuppliers[name = $product_list/own_slot_value[slot_reference = 'supplier_technology_product']/value and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
				<xsl:variable name="node_vendors" select="$allSuppliers[name = $node_list/own_slot_value[slot_reference = 'tn_supplier']/value and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"></xsl:variable>
				<xsl:variable name="vendors" select="$vendor_list union $node_vendors"></xsl:variable>
				<xsl:apply-templates select="$vendors" mode="Vendor">
					<xsl:with-param name="node_list" select="$node_list"/>
					<xsl:with-param name="product_list" select="$product_list"/>
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="product_list" select="$allTechProducts[name = $allTechNodes/own_slot_value[slot_reference = 'deployment_of']/value]"/>
				<xsl:variable name="vendor_list" select="$allSuppliers[name = $product_list/own_slot_value[slot_reference = 'supplier_technology_product']/value and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"/>
				<xsl:variable name="node_vendors" select="$allSuppliers[name = $allTechNodes/own_slot_value[slot_reference = 'tn_supplier']/value and ((starts-with(own_slot_value[slot_reference = 'name']/value, $letterCap)) or (starts-with(own_slot_value[slot_reference = 'name']/value, $letterLow)))]"></xsl:variable>
				<xsl:variable name="vendors" select="$vendor_list union $node_vendors"></xsl:variable>				
				<xsl:apply-templates select="$vendors" mode="Vendor">
					<xsl:with-param name="node_list" select="$allTechNodes"/>
					<xsl:with-param name="product_list" select="$product_list"/>
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>


		<div class="jumpToTopLink">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>

	<xsl:template name="Orphans">
		<div class="alphabetSectionHeader">
			<h2 class="text-primary">
				<xsl:value-of select="eas:i18n('Other')"/>
			</h2>
		</div>
		<xsl:text disable-output-escaping="yes">&lt;a id="section_other"&gt;&lt;/a&gt;</xsl:text>

		<!--<xsl:variable name="node_list" select="/node()/simple_instance[type='Technology_Node' and own_slot_value[slot_reference='deployment_of']/value=$param1]" />
		<xsl:variable name="product_list" select="/node()/simple_instance[name=$node_list/own_slot_value[slot_reference='deployment_of']/value]" />-->

		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="NoVendorList" select="$allTechNodes[(not(own_slot_value[slot_reference = 'deployment_of']/value)) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]"/>
				<!-- 13.11.2008 JWC Added node count -->
				<h3>
					<xsl:value-of select="eas:i18n('Unknown Vendor')"/>
					<span> (<xsl:value-of select="count($NoVendorList)"/>)</span>
				</h3>
				<!-- PHYSICAL NODES START HERE -->
				<div class="tech_nodes">
					<ul>
						<xsl:apply-templates select="$NoVendorList" mode="PhysicalNode">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="NoVendorList" select="$allTechNodes[not(own_slot_value[slot_reference = 'deployment_of']/value)]"/>
				<!-- 13.11.2008 JWC Added node count -->
				<h3>
					<xsl:value-of select="eas:i18n('Unknown Vendor')"/>
					<span> (<xsl:value-of select="count($NoVendorList)"/>)</span>
				</h3>
				<!-- PHYSICAL NODES START HERE -->
				<div class="tech_nodes">
					<ul>
						<xsl:apply-templates select="$NoVendorList" mode="PhysicalNode">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</ul>
				</div>
			</xsl:otherwise>
		</xsl:choose>

		<div class="jumpToTopLink">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>

	<xsl:template match="node()" mode="Vendor">
		<xsl:param name="node_list"/>
		<xsl:param name="product_list"/>
		<!-- 13.11.2008 JWC Add node count for each vendor -->
		<xsl:variable name="vendorNodesTech" select="$node_list[own_slot_value[slot_reference = 'deployment_of']/value = $product_list[own_slot_value[slot_reference = 'supplier_technology_product']/value = current()/name]]"/>
		<xsl:variable name="vendorNodes" select="$vendorNodesTech union $node_list[own_slot_value[slot_reference='tn_supplier']/value = current()/name]"></xsl:variable>		
		<h3>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<!--<xsl:with-param name="targetMenu" select="$targetMenu"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>-->
			</xsl:call-template>
			<span class="text">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="count($vendorNodes)"/>
				<xsl:text>)</xsl:text>
			</span>
		</h3>
		<!-- PHYSICAL NODES START HERE	-->
		<div class="catalogItems">
			<ul>
				<xsl:apply-templates select="$vendorNodes" mode="PhysicalNode">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</ul>
		</div>
		<!-- PHYSICAL NODES END HERE -->
	</xsl:template>

	<xsl:template match="node()" mode="PhysicalNode">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="targetMenu" select="$targetMenu"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>
			</xsl:call-template>
		</li>
	</xsl:template>
	
	<!-- Render alphabetic catalogues -->
	<!-- Render the index keys, as a set of hyperlinks to sections of the catalogue that have instances
		Ordered alphabetically -->
	<xsl:template name="eas:renderIndex">
		<xsl:param name="theIndexList"></xsl:param>
		<xsl:param name="theInFocusInstances"></xsl:param>
		
		<!-- Generate the index based on the set of elements in the indexList -->																		
		<xsl:variable name="anIndexKeys" select="eas:getFirstCharacter($theIndexList)"></xsl:variable>									
		<xsl:call-template name="eas:renderIndexSections">
			<xsl:with-param name="theIndexOfNames" select="$anIndexKeys"></xsl:with-param>
		</xsl:call-template>
		
		<a class="AlphabetLinks" href="#section_number">#</a>
		<a class="AlphabetLinks" href="#section_other">
			<xsl:value-of select="eas:i18n('Other')"/>
		</a>
		
		<!-- Render each section of the index -->
		<xsl:for-each select="$anIndexKeys">
			<xsl:call-template name="Index">
				<xsl:with-param name="letterCap" select="upper-case(current())"/>
				<xsl:with-param name="letterLow" select="lower-case(current())"/>				
			</xsl:call-template>
			
		</xsl:for-each>
		
	</xsl:template>
	

</xsl:stylesheet>
