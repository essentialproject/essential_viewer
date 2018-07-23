<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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


	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Principle', 'Information_Principle', 'Application_Principle', 'Technology_Principle')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allBusPrinciples" select="/node()/simple_instance[type = 'Business_Principle']"/>
	<xsl:variable name="allAppPrinciples" select="/node()/simple_instance[type = 'Application_Architecture_Principle']"/>
	<xsl:variable name="allInfoPrinciples" select="/node()/simple_instance[type = 'Information_Architecture_Principle']"/>
	<xsl:variable name="allTechPrinciples" select="/node()/simple_instance[type = 'Technology_Architecture_Principle']"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('EA Principles')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('EA Principles')"/>
		</xsl:param>

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/showhidediv.js" type="text/javascript"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<style>
					.principleTable > td,
					.principleTable > th{
						vertical-align: top;
					}</style>
			</head>
			<body>
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

						<!--Setup Business Principles Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Principles')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following Business Principles guide and govern changes to the business architecture')"/>.</p>
								<xsl:choose>
									<xsl:when test="string-length($viewScopeTermIds) > 0">
										<xsl:variable name="busPrinciples" select="$allBusPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
										<xsl:apply-templates select="$busPrinciples" mode="BusinessPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="$allBusPrinciples" mode="BusinessPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>




						<!--Setup Information Principles Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-database icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Information Principles')"/>
							</h2>

							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following Information Principles guide and govern changes to the information and data architecture')"/>. </p>
								<xsl:choose>
									<xsl:when test="string-length($viewScopeTermIds) > 0">
										<xsl:variable name="infoPrinciples" select="$allInfoPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
										<xsl:apply-templates select="$infoPrinciples" mode="InformationPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="$allInfoPrinciples" mode="InformationPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Application Principles Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Principles')"/>
							</h2>

							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following Application Principles guide and govern changes to the application architecture')"/>. </p>
								<xsl:choose>
									<xsl:when test="string-length($viewScopeTermIds) > 0">
										<xsl:variable name="appPrinciples" select="$allAppPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
										<xsl:apply-templates select="$appPrinciples" mode="ApplicationPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="$allAppPrinciples" mode="ApplicationPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Technology Principles Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-server icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Technology Principles')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following Technology Principles guide and govern changes to the technology architecture')"/>. </p>
								<xsl:choose>
									<xsl:when test="string-length($viewScopeTermIds) > 0">
										<xsl:variable name="techPrinciples" select="$allTechPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
										<xsl:apply-templates select="$techPrinciples" mode="TechnologyPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="$allTechPrinciples" mode="TechnologyPrinciple">
											<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Start Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="node()" mode="BusinessPrinciple">
		<!--<xsl:variable name="BusRationale" select="own_slot_value[slot_reference='business_principle_rationale']/value" />-->

		<xsl:variable name="multiLangRationale">
			<xsl:call-template name="RenderMultiLanguageRationale">
				<xsl:with-param name="aPrinciple" select="current()"/>
				<xsl:with-param name="defaultSlotName" select="'business_principle_rationale'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'business_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'bus_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'bus_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'bus_principle_tech_implications']/value"/>

		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<br/>
				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'business_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'business_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'bus_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'bus_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'bus_principle_tech_implications'"/>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="InformationPrinciple">
		<xsl:variable name="InfRationale" select="own_slot_value[slot_reference = 'information_principle_rationale']/value"/>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'inf_principle_bus_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'inf_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'inf_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'inf_principle_tech_implications']/value"/>

		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<br/>
				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'information_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'inf_principle_bus_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'inf_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'inf_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'inf_principle_tech_implications'"/>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="ApplicationPrinciple">
		<xsl:variable name="AppRationale" select="own_slot_value[slot_reference = 'application_principle_rationale']/value"/>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'app_principle_bus_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'app_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'app_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'app_principle_tech_implications']/value"/>

		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'application_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'app_principle_bus_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'app_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'app_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'app_principle_tech_implications'"/>
				</xsl:call-template>

			</div>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="TechnologyPrinciple">
		<xsl:variable name="TechRationale" select="own_slot_value[slot_reference = 'technology_principle_rationale']/value"/>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'tech_principle_bus_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'tech_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'tech_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'tech_principle_tech_implications']/value"/>

		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<br/>

				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'technology_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'tech_principle_bus_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'tech_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'tech_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'tech_principle_tech_implications'"/>
				</xsl:call-template>

			</div>
		</div>
	</xsl:template>

	<!-- GENERIC TEMPLATE TO PRINT OUT A BULLETED BUS/INFO/APP/TECH IMPLICATION -->
	<xsl:template match="node()" mode="Implications">
		<li>
			<xsl:value-of select="current()"/>
		</li>
	</xsl:template>

	<!-- GENERIC TEMPLATE TO PRINT OUT A BULLETED BUS/INFO/APP/TECH IMPLICATION -->
	<xsl:template name="RenderMultiLangImplications">
		<xsl:param name="aPrinciple"/>
		<xsl:param name="defaultImplicationSlot"/>
		<xsl:param name="translationImplicationSlot"/>

		<xsl:choose>
			<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
				<xsl:apply-templates select="$aPrinciple/own_slot_value[slot_reference = $defaultImplicationSlot]/value" mode="Implications"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="instanceSynonyms" select="$utilitiesAllSynonyms[(name = $aPrinciple/own_slot_value[slot_reference = $translationImplicationSlot]/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
				<xsl:choose>
					<xsl:when test="count($instanceSynonyms) > 0">
						<xsl:apply-templates select="$instanceSynonyms/own_slot_value[slot_reference = 'name']/value" mode="Implications"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$aPrinciple/own_slot_value[slot_reference = $defaultImplicationSlot]/value" mode="Implications"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<!-- GENECRIC TEMPLATE TO PRINT OUT THE BUS/INFO/APP/TECH IMPLICATIONS FOR A PRINCPLE -->
	<xsl:template name="PrincipleImplications">
		<xsl:param name="aPrinciple"/>
		<xsl:param name="RationaleSlot"/>
		<xsl:param name="BusImplicationSlot"/>
		<xsl:param name="InfoImplicationSlot"/>
		<xsl:param name="AppImplicationSlot"/>
		<xsl:param name="TechImplicationSlot"/>
		<table class="noBorders principleTable">
			<tbody>
				<tr>
					<th class="cellWidth-15pc vAlignTop"><xsl:value-of select="eas:i18n('Rationale')"/>:</th>
					<td class="cellWidth-70pc">
						<xsl:choose>
							<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $RationaleSlot]/value) = 0">
								<em>-</em>
							</xsl:when>
							<xsl:otherwise>
								<ul>
									<li>
										<xsl:call-template name="RenderMultiLanguageRationale">
											<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
											<xsl:with-param name="defaultSlotName" select="$RationaleSlot"/>
										</xsl:call-template>
									</li>
								</ul>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $BusImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for the Business')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$BusImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_bus_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$BusImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $AppImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for Applications')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$AppImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_app_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$AppImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $InfoImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for Information')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$InfoImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_inf_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$InfoImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $TechImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for Technology')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$TechImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_tech_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$TechImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="RenderMultiLanguageRationale">
		<xsl:param name="aPrinciple"/>
		<xsl:param name="defaultSlotName"/>

		<xsl:choose>
			<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
				<xsl:value-of select="$aPrinciple/own_slot_value[slot_reference = $defaultSlotName]/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="instanceSynonym" select="$utilitiesAllSynonyms[(name = $aPrinciple/own_slot_value[slot_reference = 'principle_rationale_synonyms']/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
				<xsl:choose>
					<xsl:when test="count($instanceSynonym) > 0">
						<xsl:value-of select="$instanceSynonym/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$aPrinciple/own_slot_value[slot_reference = $defaultSlotName]/value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
