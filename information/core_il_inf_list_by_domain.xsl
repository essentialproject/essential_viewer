<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>



	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Domain', 'Information_Concept', 'Information_View')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="allBusDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>
	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>
	<xsl:variable name="allInfoObjects" select="/node()/simple_instance[type = 'Information_View']"/>
	<xsl:variable name="busOpsDomain" select="$allBusDomains[count(own_slot_value[slot_reference = 'contained_business_domains']/value) > 0]"/>
	<xsl:variable name="subDomains" select="$allBusDomains[name = $busOpsDomain/own_slot_value[slot_reference = 'contained_business_domains']/value]"/>
	<xsl:variable name="parentBusDomains" select="$allBusDomains[not($subDomains/own_slot_value[slot_reference = 'contained_business_domains']/value)]"/>
	<xsl:variable name="infoListByConceptCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Information Catalogue by Information Concept')]"/>



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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>
	<xsl:param name="pageLabel" select="'Information Catalogue by Domain'"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/showhidediv.js" type="text/javascript"/>
				<script type="text/javascript" src="js/sitemapstyler.js"/>
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
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Information Catalogue by Business Domain')"/>
									</span>
								</h1>
							</div>
						</div>


						<div class="col-xs-12">
							<div class="altViewName">
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
								<span class="text-darkgrey">
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theCatalogue" select="$infoListByConceptCatalogue"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="'Concept'"/>
									</xsl:call-template>
								</span>
								<span class="text-darkgrey"> | </span>
								<span class="text-primary">
									<xsl:value-of select="eas:i18n('Business Domain')"/>
								</span>
							</div>
						</div>

						<!--Setup Catalogue Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogue')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('Please click on an Information Concept or Information View below to navigate to the required view')"/>.</p>
							<hr/>
							<div class="content-section">
								<h2 class="text-secondary">
									<xsl:value-of select="eas:i18n('Choose a Domain')"/>
								</h2>
								<div>
									<ul id="sitemap">
										<xsl:choose>
											<xsl:when test="string-length($viewScopeTermIds) > 0">
												<xsl:apply-templates mode="Level1_Business_Domain" select="$parentBusDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]">
													<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates mode="Level1_Business_Domain" select="$parentBusDomains">
													<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</xsl:otherwise>
										</xsl:choose>
									</ul>
								</div>
							</div>
							<hr/>
							<div class="content-section">
								<!--Main Catalog Starts-->
								<xsl:choose>
									<xsl:when test="string-length($viewScopeTermIds) > 0">
										<xsl:apply-templates mode="Business_Domain" select="$allBusDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates mode="Business_Domain" select="$allBusDomains">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<!-- Template to generate the index of level 1 Business Domains -->
	<xsl:template match="node()" mode="Level1_Business_Domain">
		<xsl:variable name="containingDomains" select="$allBusDomains[own_slot_value[slot_reference = 'contained_business_domains']/value = current()/name]"/>
		<xsl:if test="count($containingDomains) = 0">
			<xsl:variable name="SubDomains" select="$subDomains[name = current()/own_slot_value[slot_reference = 'contained_business_domains']/value]"/>
			<xsl:variable name="levellDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<li>
				<a class="text-default">
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="$levellDomainName"/>
					</xsl:attribute>
					<xsl:value-of select="$levellDomainName"/>
				</a>
				<xsl:choose>
					<xsl:when test="count($SubDomains) > 0">
						<ul>
							<xsl:apply-templates mode="Sub_Business_Domain" select="$SubDomains">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</xsl:when>
				</xsl:choose>
			</li>
		</xsl:if>
	</xsl:template>

	<!-- Template to generate the index of Sub Business Domains -->
	<xsl:template match="simple_instance" mode="Sub_Business_Domain">
		<xsl:variable name="SubDomains" select="$allBusDomains[name = current()/own_slot_value[slot_reference = 'contained_business_domains']/value]"/>
		<xsl:variable name="levellDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="SubDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<li>
			<a class="text-default">
				<xsl:attribute name="href">
					<xsl:text>#</xsl:text>
					<xsl:value-of select="$SubDomainName"/>
				</xsl:attribute>
				<xsl:value-of select="$SubDomainName"/>
			</a>
			<xsl:choose>
				<xsl:when test="count($SubDomains) > 0">
					<ul>
						<xsl:apply-templates mode="Sub_Business_Domain" select="$SubDomains">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</ul>
				</xsl:when>
			</xsl:choose>
		</li>
	</xsl:template>

	<!-- Template to generate the Information associated with a Business Domain -->
	<xsl:template match="simple_instance" mode="Business_Domain">
		<xsl:variable name="busDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<div class="text-secondary">
			<h2 class="text-primary">
				<a class="text-secondary">
					<xsl:attribute name="name">
						<xsl:value-of select="$busDomainName"/>
					</xsl:attribute>
					<xsl:value-of select="$busDomainName"/>
				</a>
			</h2>
		</div>
		<xsl:variable name="infoConcepts" select="$allInfoConcepts[own_slot_value[slot_reference = 'belongs_to_business_domain_information']/value = current()/name]"/>
		<xsl:choose>
			<xsl:when test="count($infoConcepts) > 0">
				<xsl:apply-templates mode="Information_Concept" select="$infoConcepts">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em class="small">
					<xsl:value-of select="eas:i18n('No Information Concepts defined for this Domain')"/>
				</em>
				<div class="verticalSpacer_10px"/>
			</xsl:otherwise>
		</xsl:choose>

		<div class="small">
			<a href="#top" class="topLink">
				<xsl:value-of select="eas:i18n('Back to Top')"/>
			</a>
		</div>
		<div class="clear"/>
		<hr/>
	</xsl:template>

	<!-- Template to generate the index for an Information Concept -->
	<xsl:template match="simple_instance" mode="Information_Concept">
		<xsl:variable name="infoObjects" select="$allInfoObjects[own_slot_value[slot_reference = 'refinement_of_information_concept']/value = current()/name]"/>

		<div class="largeThinRoundedBox_FullWidth">
			<h3 class="textColour3">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!--<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>-->
				</xsl:call-template>
				<!--<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" />-->
			</h3>
			<p>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</p>

			<!-- Don't bother printing the table of Information Objects if there are none -->
			<xsl:if test="count($infoObjects) > 0">
				<div class="ShowHideDivTrigger ShowHideDivOpen">
					<a class="ShowHideDivLink small text-darkgrey" href="#">
						<xsl:value-of select="eas:i18n('Show/Hide Information Objects')"/>
					</a>
				</div>
				<div class="hiddenDiv">
					<div class="verticalSpacer_10px"/>
					<table class="table table-bordered table-striped">
						<thead>
							<tr>
								<th class="cellWidth-30pc">
									<xsl:value-of select="eas:i18n('Information Object')"/>
								</th>
								<th class="cellWidth-70pc">
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates mode="Information_Object" select="$infoObjects">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</tbody>
					</table>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<!-- Template to generate the details for an Information Object -->
	<xsl:template match="simple_instance" mode="Information_Object">
		<tr class="SectionTableHeaderRow">
			<xsl:variable name="infoObjectName" select="current()/own_slot_value[slot_reference = 'view_label']/value"/>
			<tr>
				<td class="strong">
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="targetMenu" select="$targetMenu"/>
						<xsl:with-param name="targetReport" select="$targetReport"/>
						<xsl:with-param name="displaySlot" select="'view_label'"/>
					</xsl:call-template>
					<!--<a id="{$infoObjectName}" class="context-menu-infoView menu-1">
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theInstanceID" select="name" />
							<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
							<xsl:with-param name="theParam4" select="$param4" />
						</xsl:call-template>
						<xsl:value-of select="$infoObjectName" />
					</a>-->
					<!--<a>
						<xsl:attribute name="href">
							<xsl:text>report?XML=reportXML.xml&amp;XSL=information/info_object_summary.xsl&amp;PMA=</xsl:text>
							<xsl:value-of select="current()/name"/>
							<xsl:text>&amp;LABEL=Information Object Summary - </xsl:text>
							<xsl:value-of select="$infoObjectName"/>
						</xsl:attribute>
						<xsl:value-of select="$infoObjectName"/>
					</a>-->
				</td>
				<td>
					<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
					</xsl:call-template>
				</td>
			</tr>
		</tr>
	</xsl:template>



</xsl:stylesheet>
