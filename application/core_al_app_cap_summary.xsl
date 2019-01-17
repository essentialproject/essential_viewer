<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<!--<xsl:include href="../application/menus/core_app_service_menu.xsl" />-->

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
	<!-- param1 = the application capability that is being summarised -->
	<xsl:param name="param1"/>
	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Domain', 'Application_Service')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Get all of the required types of instances in the repository -->
	<xsl:variable name="currentAppCap" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentAppCapName" select="$currentAppCap/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentAppCapDescription" select="$currentAppCap/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="currentBusDomain" select="/node()/simple_instance[name = $currentAppCap/own_slot_value[slot_reference = 'mapped_to_business_domain']/value]"/>
	<xsl:variable name="currentBusDomainName" select="$currentBusDomain/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $currentAppCap/name]"/>
	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="pageLabel">
					<xsl:value-of select="'Application Capability Summary'"/>
				</xsl:variable>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="inScopeAppServices" select="$allAppServices[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeAppServices" select="$allAppServices"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Application Capability Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeAppServices">
			<xsl:value-of select="$allAppServices"/>
		</xsl:param>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
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
				<!--<xsl:call-template name="RenderAppServicePopUpScript" />-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="$pageLabel"/> - </span>
									<span class="text-primary">
										<xsl:value-of select="$currentAppCapName"/>
									</span>
								</h1>
							</div>
						</div>


						<!--Setup Description Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>
							<div class="content-section">
								<p>
									<xsl:choose>
										<xsl:when test="string-length($currentAppCapDescription) = 0">
											<em>
												<xsl:value-of select="eas:i18n('No description captured for this Application Capability')"/>
											</em>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:value-of select="$currentAppCapDescription"/>-->
											<xsl:call-template name="RenderMultiLangInstanceDescription">
												<xsl:with-param name="theSubjectInstance" select="$currentAppCap"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup Bus Domain Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Domain')"/>
							</h2>
							<div class="content-section">
								<p>
									<xsl:choose>
										<xsl:when test="count($currentBusDomainName) = 0">
											<em>
												<xsl:value-of select="eas:i18n('No Business Domain captured for this Application Capability')"/>
											</em>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:value-of select="$currentBusDomainName" />-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentBusDomain"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>



						<!--Setup App Services Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Services')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($inScopeAppServices) = 0">
										<p>
											<em>
												<xsl:value-of select="eas:i18n('No Application Services have been captured for this Application Capability')"/>
											</em>
										</p>
									</xsl:when>
									<xsl:otherwise>

										<p>
											<xsl:value-of select="eas:i18n('The Application Services supporting this capability')"/>
										</p>
										<table class="table-header-background table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Application Service')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="AppService" select="$inScopeAppServices">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>

									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup the Supporting Documentation section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
							</h2>
							<div class="content-section">
								<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>
							</div>
							<hr/>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>

	</xsl:template>
	<xsl:template match="node()" mode="AppService">
		<xsl:variable name="asName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="asDesc" select="own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<!--<a id="{$asName}" class="context-menu-appService menu-1">
					<xsl:call-template name="RenderLinkHref">
						<xsl:with-param name="theInstanceID" select="name" />
						<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
						<xsl:with-param name="theParam4" select="$param4" />
						<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
						<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
					</xsl:call-template>
					<xsl:value-of select="$asName" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<!--<xsl:value-of select="$asDesc"/>-->
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
