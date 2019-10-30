<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



	<xsl:output method="html"/>
	<xsl:variable name="hideEmpty">false</xsl:variable>

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

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->

	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Supplier', 'Technology_Node')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START CATALOGUE SPECIFIC VARIABLES -->
	<xsl:variable name="techNodeListByNameCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Name')]"/>
	<xsl:variable name="techNodeListByVendorCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Vendor')]"/>
	<xsl:variable name="techNodeListByProductCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Product')]"/>
	<xsl:variable name="techNodeListAsTable" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue as Table')]"/>
	<xsl:variable name="allTechNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
	<xsl:variable name="allTechProducts" select="/node()/simple_instance[name = $allTechNodes/own_slot_value[slot_reference = 'deployment_of']/value]"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[name = $allTechProducts/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Node Catalogue by Product')"/>
	</xsl:variable>
	<!-- END CATALOGUE SPECIFIC VARIABLES -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
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
											<xsl:with-param name="theCatalogue" select="$techNodeListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Name'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByVendorCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Product')"/>
									</span>
									<!--<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByProductCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Product'"/>
										</xsl:call-template>
									</span>-->
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
							<!--Setup Description Section-->
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>
							<p><xsl:value-of select="eas:i18n('Please select a Technology Node to navigate to the required view')"/>.</p>
							<xsl:call-template name="Index"/>
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
		<table class="table table-bordered">
			<thead>
				<tr>
					<th class="cellWidth-25pc text-primary impact">
						<xsl:value-of select="eas:i18n('Supplier')"/>
					</th>
					<th class="cellWidth-35pc text-primary impact">
						<xsl:value-of select="eas:i18n('Product')"/>
					</th>
					<th class="cellWidth-40pc text-primary impact">
						<xsl:value-of select="eas:i18n('Physical Node')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="$allSuppliers" mode="Supplier">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
				<!--<xsl:choose>
					<xsl:when test="string-length($viewScopeTermIds) > 0">
						<xsl:apply-templates select="$allSuppliers[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" mode="Supplier">		
							<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$allSuppliers" mode="Supplier">		
							<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>-->

			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="node()" mode="Supplier">
		<xsl:variable name="currentSupplier" select="current()"/>
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="children" select="$allTechProducts[(own_slot_value[slot_reference = 'supplier_technology_product']/value = $currentSupplier/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]"/>
				<xsl:variable name="childrenSize" select="count($children)"/>

				<tr>
					<td class="cellColour7">
						<xsl:if test="$childrenSize > 0">
							<xsl:attribute name="rowspan">
								<xsl:value-of select="$childrenSize"/>
							</xsl:attribute>
						</xsl:if>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
						<br/>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
					<xsl:choose>
						<xsl:when test="$childrenSize = 0">
							<td>-</td>
							<td>-</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="$children" mode="Technology_Product">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td class="noBorders" colspan="3">&#160;</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="children" select="$allTechProducts[own_slot_value[slot_reference = 'supplier_technology_product']/value = $currentSupplier/name]"/>
				<xsl:variable name="childrenSize" select="count($children)"/>

				<tr>
					<td class="cellColour7">
						<xsl:if test="$childrenSize > 0">
							<xsl:attribute name="rowspan">
								<xsl:value-of select="$childrenSize"/>
							</xsl:attribute>
						</xsl:if>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
						<br/>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
					<xsl:choose>
						<xsl:when test="$childrenSize = 0">
							<td>-</td>
							<td>-</td>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="$children" mode="Technology_Product">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<td class="noBorders" colspan="3">&#160;</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>


	<xsl:template match="node()" mode="Technology_Product">
		<xsl:variable name="currentProduct" select="current()"/>
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="techNodes" select="$allTechNodes[(own_slot_value[slot_reference = 'deployment_of']/value = $currentProduct/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]"/>
				<xsl:call-template name="RenderCapabilityRow">
					<xsl:with-param name="techNodes" select="$techNodes"/>
					<xsl:with-param name="prodIndex" select="position()"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="techNodes" select="$allTechNodes[own_slot_value[slot_reference = 'deployment_of']/value = $currentProduct/name]"/>
				<xsl:call-template name="RenderCapabilityRow">
					<xsl:with-param name="techNodes" select="$techNodes"/>
					<xsl:with-param name="prodIndex" select="position()"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<xsl:template name="RenderCapabilityRow">
		<xsl:param name="techNodes"/>
		<xsl:param name="prodIndex"/>
		<xsl:variable name="techNodeListSize" select="count($techNodes)"/>
		<xsl:choose>
			<xsl:when test="$prodIndex = 1">
				<xsl:choose>
					<xsl:when test="$techNodeListSize > 0">
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<ul>
								<xsl:apply-templates select="$techNodes" mode="Technology_Node">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</ul>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>-</td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$techNodeListSize > 0">
						<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<ul>
								<xsl:apply-templates select="$techNodes" mode="Technology_Node">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</ul>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>-</td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="node()" mode="Technology_Node">
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

</xsl:stylesheet>
