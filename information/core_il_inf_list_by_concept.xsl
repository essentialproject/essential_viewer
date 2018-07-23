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

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Concept', 'Information_View', 'Information_Representation')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START SPECIFIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>
	<xsl:variable name="allInfoObjects" select="/node()/simple_instance[type = 'Information_View']"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[type = 'Information_Representation']"/>
	<xsl:variable name="infoListByDomainCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Information Catalogue by Business Domain')]"/>
	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Information Catalogue by Concept')"/>
	</xsl:variable>
	<!-- END SPECIFIC CATALOGUE SETUP VARIABES -->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/showhidediv.js" type="text/javascript"/>
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
						<div class="clear"/>
						<div class="col-xs-12">
							<div class="altViewName">
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
								<span class="text-primary">
									<xsl:value-of select="eas:i18n('Concept')"/>
								</span>
								<span class="text-darkgrey"> | </span>
								<span class="text-darkgrey">
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theCatalogue" select="$infoListByDomainCatalogue"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="'Business Domain'"/>
									</xsl:call-template>
								</span>
							</div>
						</div>

						<!--Setup Catalogue Section-->
					</div>
					<div class="row">
						<div id="sectionCatalogue">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Catalogue')"/>
									</h2>
								</div>
								<p><xsl:value-of select="eas:i18n('Please click on an Information Concept, View or Representation below to navigate to the required view')"/>.</p>
								<div class="content-section">
									<xsl:choose>
										<xsl:when test="string-length($viewScopeTermIds) > 0">
											<xsl:apply-templates mode="Information_Concept" select="$allInfoConcepts[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]">
												<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
											</xsl:apply-templates>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates mode="Information_Concept" select="$allInfoConcepts">
												<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
											</xsl:apply-templates>
										</xsl:otherwise>
									</xsl:choose>

									<!--<xsl:apply-templates select="/node()/simple_instance[type='Information_Concept']" mode="Information_Concept">
										<xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value" />
									</xsl:apply-templates>-->

								</div>
							</div>
							<div class="clear"/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="Information_Concept">


		<div class="largeThinRoundedBox">
			<div>
				<h3>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<!--<xsl:with-param name="targetMenu" select="$targetMenu"/>
						<xsl:with-param name="targetReport" select="$targetReport"/>-->
					</xsl:call-template>
					<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				</h3>
			</div>
			<div>
				<p>
					<xsl:value-of select="own_slot_value[slot_reference = 'description']/value"/>
				</p>
			</div>
			<div class="verticalSpacer_5px"/>
			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Show/Hide Information Views &amp; Representations')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<div class="verticalSpacer_10px"/>
				<xsl:call-template name="infoViewandRepTable"/>
			</div>
		</div>

	</xsl:template>


	<xsl:template name="infoViewandRepTable">
		<xsl:variable name="informationViews" select="own_slot_value[slot_reference = 'has_information_views']/value"/>
		<xsl:variable name="infoViewCount" select="count($informationViews)"/>
		<xsl:choose>
			<xsl:when test="$infoViewCount > 0">
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-50pc">
								<xsl:value-of select="eas:i18n('Information View')"/>
							</th>
							<th class="cellWidth-50pc">
								<xsl:value-of select="eas:i18n('Information Representations')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:choose>
							<xsl:when test="string-length($viewScopeTermIds) > 0">
								<xsl:apply-templates mode="Information_View" select="$allInfoObjects[(name = $informationViews) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates mode="Information_View" select="$allInfoObjects[name = $informationViews]">
									<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Information Views defined for This Information Concept')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>

	<xsl:template match="node()" mode="Information_View">
		<xsl:variable name="informationRepresentations" select="own_slot_value[slot_reference = 'has_information_representations']/value"/>
		<tr>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="targetMenu" select="$targetMenu"/>
						<xsl:with-param name="targetReport" select="$targetReport"/>
						<xsl:with-param name="displaySlot" select="'view_label'"/>
					</xsl:call-template>
				</strong>
				<br/>
				<xsl:value-of select="own_slot_value[slot_reference = 'description']/value"/>
			</td>

			<td>
				<ul>
					<xsl:choose>
						<xsl:when test="string-length($viewScopeTermIds) > 0">
							<xsl:apply-templates mode="Information_Representation" select="$allInfoReps[(name = $informationRepresentations) and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates mode="Information_Representation" select="$allInfoReps[name = $informationRepresentations]">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</td>
		</tr>
		<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
	</xsl:template>

	<!-- Render the Information Representation and provide links to detailed information -->
	<!-- Currently, deployments link to same report as Representation -->
	<xsl:template match="node()" mode="Information_Representation">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<!--				<xsl:with-param name="targetMenu" select="$targetMenu"/>
				<xsl:with-param name="targetReport" select="$targetReport"/>-->
			</xsl:call-template>
			<!--<a>
				<xsl:attribute name="href">
					<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoRep.xsl&amp;PMA=</xsl:text>
					<xsl:value-of select="name" />
					<xsl:text>&amp;LABEL=Information Representation - </xsl:text>
					<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
				</xsl:attribute>
				<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
			</a>-->


			<!--<xsl:variable name="information_stores" select="own_slot_value[slot_reference='implemented_with_information_stores']/value" />
			<xsl:variable name="count" select="count($information_stores)" />

			<xsl:if test="$count &gt; 0">
				<xsl:text>&#160;</xsl:text>
				<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoRep.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="name" />
						<xsl:text>&amp;LABEL=Information Representation - </xsl:text>
						<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
					</xsl:attribute>(<xsl:value-of select="$count" /> deployments) </a>
			</xsl:if>-->
		</li>
	</xsl:template>


</xsl:stylesheet>
