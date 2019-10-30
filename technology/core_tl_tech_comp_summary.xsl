<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

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

	<!-- param1 = the technology component that is being summarised -->
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
	<xsl:variable name="linkClasses" select="('Technology_Function', 'Technology_Capability', 'Technology_Product', 'Supplier')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- Get all of the required types of instances in the repository -->
	<xsl:variable name="currentTechComp" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentTechCompName" select="$currentTechComp/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentTechCompDescription" select="$currentTechComp/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[name = $currentTechComp/own_slot_value[slot_reference = 'realisation_of_technology_capability']/value]"/>
	<xsl:variable name="allTechFuncs" select="/node()/simple_instance[name = $currentTechComp/own_slot_value[slot_reference = 'technology_component_functions_offered']/value]"/>
	<xsl:variable name="allTechProductRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_technology_component']/value = $currentTechComp/name]"/>
	<xsl:variable name="allTechProducts" select="/node()/simple_instance[name = $allTechProductRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[name = $allTechProducts/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>



	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="pageLabel">
					<xsl:value-of select="'Technology Component Summary'"/>
				</xsl:variable>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="inScopeTechProducts" select="$allTechProducts[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeTechProducts" select="$allTechProducts"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Technology Component Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeTechProducts">
			<xsl:value-of select="$allTechProducts"/>
		</xsl:param>

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
				<!--<xsl:call-template name="RenderTechCapabilityPopUpScript" />
				<xsl:call-template name="RenderTechProductPopUpScript" />-->


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
										<xsl:value-of select="$currentTechCompName"/>
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
								<xsl:choose>
									<xsl:when test="string-length($currentTechCompDescription) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$currentTechCompDescription"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Technology Capabilities Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Realised Technology Capabilities')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allTechCaps) = 0">

										<p>
											<em>
												<xsl:value-of select="eas:i18n('No Technology Capabilities have been mapped to this Technology Component')"/>
											</em>
										</p>

									</xsl:when>
									<xsl:otherwise>

										<p><xsl:value-of select="eas:i18n('The Technology Capabilities that realise the')"/>&#160; <strong><xsl:value-of select="$currentTechCompName"/></strong>&#160; <xsl:value-of select="eas:i18n('Technology Component')"/></p>
										<table class="table-header-background table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Technology Capability')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="TechCapability" select="$allTechCaps">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>

									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Technology Functions Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-gears icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Technology Functions')"/>
							</h2>
							<xsl:choose>
								<xsl:when test="count($allTechFuncs) = 0">
									<div class="content-section">
										<p>
											<em>
												<xsl:value-of select="eas:i18n('No Technology Functions have been defined for this Technology Component')"/>
											</em>
										</p>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('The Technology Functions provided by the')"/>&#160; <xsl:value-of select="$currentTechCompName"/>&#160;<xsl:value-of select="eas:i18n(' Technology Component')"/></p>
										<table class="table-header-background table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Technology Function')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="TechFunction" select="$allTechFuncs">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>


						<!--Setup Technology Products Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-wrench icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Technology Products')"/>
							</h2>

							<xsl:choose>
								<xsl:when test="count($inScopeTechProducts) = 0">
									<div class="content-section">
										<p>
											<em>
												<xsl:value-of select="eas:i18n('No Technology Products have been mapped to this Technology Component')"/>
											</em>
										</p>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('The Technology Products that implement the')"/>&#160; <xsl:value-of select="$currentTechCompName"/>&#160;<xsl:value-of select="eas:i18n(' Technology Component ')"/></p>

										<table class="table-header-background table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-25pc">
														<xsl:value-of select="eas:i18n('Product Vendor')"/>
													</th>
													<th class="cellWidth-25pc">
														<xsl:value-of select="eas:i18n('Product Name')"/>
													</th>
													<th class="cellWidth-50pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="TechProduct" select="$inScopeTechProducts">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</div>
								</xsl:otherwise>
							</xsl:choose>
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

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="node()" mode="TechCapability">
		<xsl:variable name="tcName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="tcDesc" select="own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<!--<strong>
					<xsl:value-of select="$tcName" />
				</strong>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<!--<a id ="{$tcName}" class="context-menu-techCapability menu-1">
					<xsl:call-template name="RenderLinkHref">
						<xsl:with-param name="theInstanceID" select="name"/>
						<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
						<xsl:with-param name="theParam4" select="$param4"/>                             
					</xsl:call-template>
					<xsl:value-of select="$tcName"/>
				</a>-->
			</td>
			<td>
				<xsl:value-of select="$tcDesc"/>
			</td>
		</tr>
	</xsl:template>



	<xsl:template match="node()" mode="TechFunction">
		<xsl:variable name="tfName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="tfDesc" select="own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<!--<xsl:value-of select="$tfName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="$tfDesc"/>
			</td>
		</tr>
	</xsl:template>


	<xsl:template match="node()" mode="TechProduct">
		<xsl:variable name="tpName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="tpDesc" select="own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="tpSupplier" select="$allSuppliers[name = current()/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:variable name="tpSupplierName" select="$tpSupplier/own_slot_value[slot_reference = 'name']/value"/>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="count($tpSupplier) = 0">
						<em>
							<xsl:value-of select="eas:i18n('Unknown Supplier')"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:value-of select="$tpSupplierName" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$tpSupplier"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<!--<a id="{$tpName}" class="context-menu-techProduct menu-1">
					<xsl:call-template name="RenderLinkHref">
						<xsl:with-param name="theInstanceID" select="name" />
						<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
						<xsl:with-param name="theParam4" select="$param4" />
						<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
						<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
					</xsl:call-template>
					<xsl:value-of select="$tpName" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="$tpDesc"/>
			</td>
		</tr>
	</xsl:template>



</xsl:stylesheet>
