<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<!--<xsl:include href="../information/menus/core_info_view_menu.xsl" />
	<xsl:include href="../information/menus/core_data_subject_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="currentDomainInst" select="/node()/simple_instance[type = 'Business_Domain'][name=$param1]"/>
	 
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="mappedCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'belongs_to_business_domain']/value = $currentDomainInst/name]"/>
	<xsl:variable name="allMappedCapabilitiesPre" select="eas:get_object_descendants($mappedCapabilities, $allBusinessCaps, 0, 5, 'supports_business_capabilities')"/>

	<xsl:variable name="allMappedCapabilitiesUnique" select="distinct-values($allMappedCapabilitiesPre/name)"/>
	<xsl:variable name="allMappedCapabilities" select="$allBusinessCaps[name=$allMappedCapabilitiesUnique]"/>
	<xsl:variable name="inScopeBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allMappedCapabilities/name]"/>

	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process'][name=$inScopeBusProcs/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
	<xsl:variable name="allPhysProc2AppProRoles" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value=$allPhysProcs/name]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type = 'Application_Provider_Role'][name=$allPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>

	<xsl:variable name="allAppProvidersDirect" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')][name=$allPhysProcs/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allAppProvidersViaAPR" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')][name=$allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allAppProviders" select="$allAppProvidersViaAPR union $allAppProvidersDirect"/>
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


	<!-- param1 = the information concept that is being summarised -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Project', 'Business_Capability', 'Business_Process', 'Business_Domain', 'Application_Provider', 'Information_Concept', 'Business_Objective')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- Get all of the required types of instances in the repository -->
 
	<xsl:template match="knowledge_base">
			<xsl:call-template name="docType"/>
			<html>
				<head>
					<xsl:call-template name="commonHeadContent"/> 
					<xsl:for-each select="$linkClasses">
						<xsl:call-template name="RenderInstanceLinkJavascript">
							<xsl:with-param name="instanceClassName" select="current()"/>
							<xsl:with-param name="targetMenu" select="()"/>
						</xsl:call-template>
					</xsl:for-each>
					<title>Business Domain Summary</title>
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
										<span class="text-primary"><xsl:value-of select="eas:i18n('Business Domain Summary')"/></span> - <span class="text-darkgrey"><xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentDomainInst"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template> </span>
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
											<xsl:call-template name="RenderMultiLangInstanceDescription">
												<xsl:with-param name="theSubjectInstance" select="$currentDomainInst"/>
											</xsl:call-template>
										</p>
									</div>
									<hr/>
								</div>
 
							<!--Setup Caps Section-->
							<div class="col-xs-12">
						 
									<div class="sectionIcon">
										<i class="fa essicon-blocks icon-section icon-color"/>
									</div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Capabilities')"/>
									</h2>
									<div class="content-section">
											<table class="table table-striped table-bordered">
													<thead>
														<tr>
															<th class="cellWidth-30pc">
																<xsl:value-of select="eas:i18n('Business Capability Name')"/>
															</th>
															<th class="cellWidth-70pc">
																<xsl:value-of select="eas:i18n('Business Capability Description')"/>
															</th>
															 
														</tr>
													</thead>
													<tbody>
														<xsl:apply-templates select="$allMappedCapabilities" mode="mappedCaps">
															
														</xsl:apply-templates>
													</tbody>
												</table>
									</div>
									<hr/>
								</div>	
						
							<div class="col-xs-12">
						
									<div class="sectionIcon">
										<i class="fa essicon-valuechain icon-section icon-color"/>
									</div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Processes')"/>
									</h2>
									<div class="content-section">
											<table class="table table-striped table-bordered">
													<thead>
														<tr>
															<th class="cellWidth-30pc">
																<xsl:value-of select="eas:i18n('Business Process Name')"/>
															</th>
															<th class="cellWidth-70pc">
																<xsl:value-of select="eas:i18n('Business Process Description')"/>
															</th>
																
														</tr>
													</thead>
													<tbody>
														<xsl:apply-templates select="$inScopeBusProcs" mode="mappedCaps">
															
														</xsl:apply-templates>
													</tbody>
												</table>
									</div>
									<hr/>
								</div>	
							
							<div class="col-xs-12">
					
									<div class="sectionIcon">
										<i class="fa essicon-valuechain icon-section icon-color"/>
									</div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Applications')"/>
									</h2>
									<div class="content-section">
											<table class="table table-striped table-bordered">
													<thead>
														<tr>
															<th class="cellWidth-30pc">
																<xsl:value-of select="eas:i18n('Application Name')"/>
															</th>
															<th class="cellWidth-70pc">
																<xsl:value-of select="eas:i18n('Application Description')"/>
															</th>
																
														</tr>
													</thead>
													<tbody>
														<xsl:apply-templates select="$allAppProviders" mode="mappedCaps">
															
														</xsl:apply-templates>
													</tbody>
												</table>
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

		<xsl:template match="node()" mode="mappedCaps">
				<tr>
						<td class="cellWidth-30pc"> 
							
								<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
									</xsl:call-template>
								 
						</td>
						<td class="cellWidth-70pc">
								<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>
						</td>
						 
					</tr>

		</xsl:template>
	<!--
<xsl:template match="node()" mode="processModel">
	<xsl:variable name="thissubBusinessProcesses" select="$allBusProcs[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>
	 
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
 "flow":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>",
 "link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",	
 "subProcess":[<xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"/>]}<xsl:if test="position()!=last()">,</xsl:if>	
</xsl:template>

<xsl:template match="node()" mode="subProcesses">
	<xsl:variable name="thissubBusinessProcesses" select="$allBusProcs[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"flow":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",	
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
<xsl:if test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">"flow":"yes",</xsl:if>	
 "subProcess":[<xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"/>]}<xsl:if test="position()!=last()">,</xsl:if>	
	
</xsl:template>	
-->
</xsl:stylesheet>
