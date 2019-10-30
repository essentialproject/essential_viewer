<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<!--	<xsl:include href="../information/menus/core_info_view_menu.xsl" />
	<xsl:include href="../information/menus/core_data_subject_menu.xsl" />-->

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

	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<!--<xsl:variable name="allBusProcs" select="/node()/simple_instance[type='Business_Process']" />
	<xsl:variable name="allApps" select="/node()/simple_instance[(type='Application_Provider') or (type='Composite_Application_Provider')]" />
	<xsl:variable name="allAppServices" select="/node()/simple_instance[(type='Application_Service') or (type='Composite_Application_Service')]"/>
	<xsl:variable name="allAppRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
	<xsl:variable name="allBusProc2AppSvcs" select="/node()/simple_instance[type='APP_SVC_TO_BUS_RELATION']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type='Individual_Actor']" />
	<xsl:variable name="allIndividualRoles" select="/node()/simple_instance[type='Individual_Business_Role']" />
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type='Group_Actor']" />
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type='Group_Business_Role']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type='Physical_Process']" />
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']" />-->

	<xsl:variable name="currentBusCap" select="$allBusinessCaps[name = $param1]"/>
	<xsl:variable name="currentBusCapName" select="$currentBusCap/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentBusCapDescription" select="$currentBusCap/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[name = $currentBusCap/own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value]"/>
	<xsl:variable name="busDomain" select="/node()/simple_instance[name = $currentBusCap/own_slot_value[slot_reference = 'belongs_to_business_domain']/value]"/>
	<xsl:variable name="parentCap" select="$allBusinessCaps[name = $currentBusCap/own_slot_value[slot_reference = 'supports_business_capabilities']/value]"/>
	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[name = $currentBusCap/own_slot_value[slot_reference = 'business_capability_requires_information']/value]"/>
	<xsl:variable name="subBusCaps" select="eas:get_object_descendants($currentBusCap, $allBusinessCaps, 0, 6, 'supports_business_capabilities')"/>


	<xsl:variable name="relevantBusCaps" select="$currentBusCap union $subBusCaps"/>
	<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
	<xsl:variable name="currentBusProcs" select="$relevantBusProcs"/>
	<xsl:variable name="relevantBusProc2AppSvcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantAppSvcs" select="/node()/simple_instance[name = $relevantBusProc2AppSvcs/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
	<xsl:variable name="relevantAppRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $relevantAppSvcs/name]"/>
	<xsl:variable name="relevantApps" select="/node()/simple_instance[name = $relevantAppRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

	<xsl:variable name="physProcsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="physProcs2AppsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
	<xsl:variable name="appRolesForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="appsForRolesCap" select="/node()/simple_instance[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="appsForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $relevantApps"/>


	<xsl:variable name="relevantServiceQualityValues" select="/node()/simple_instance[name = $allBusObjectives/own_slot_value[slot_reference = 'bo_measures']/value]"/>
	<xsl:variable name="relevantServiceQualities" select="/node()/simple_instance[name = $relevantServiceQualityValues/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>

	<xsl:variable name="allDates" select="/node()/simple_instance[(type = 'Year') or (type = 'Quarter') or (type = 'Gregorian')]"/>

	<xsl:variable name="allArchStates" select="/node()/simple_instance[type = 'Architecture_State']"/>
	<xsl:variable name="allProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="archStatesforBusProcs" select="$allArchStates[own_slot_value[slot_reference = 'arch_state_business_logical']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="archStatesforApps" select="$allArchStates[own_slot_value[slot_reference = 'arch_state_application_logical']/value = $allAppsForCap/name]"/>
	<xsl:variable name="relevantArchitectureStates" select="($archStatesforApps | $archStatesforBusProcs)"/>
	<xsl:variable name="archStateProjects" select="$allProjects[own_slot_value[slot_reference = 'project_start_state']/value = $relevantArchitectureStates/name]"/>

	<xsl:variable name="planToElementRelsForBusCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = ($currentBusCap, $relevantBusProcs, $allAppsForCap)/name]"/>
	<xsl:variable name="directProjectsForBusCap" select="$allProjects[name = $planToElementRelsForBusCap/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
	<xsl:variable name="stratPlansForBusCap" select="/node()/simple_instance[name = $planToElementRelsForBusCap/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
	<xsl:variable name="deprecatedStratPlansForBusCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = ($currentBusCap, $relevantBusProcs, $allAppsForCap)/name]"/>
	<xsl:variable name="projectsSupportingStratPlans" select="$allProjects[name = ($stratPlansForBusCap, $deprecatedStratPlansForBusCap)/own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value]"/>
	<xsl:variable name="relevantProjects" select="$directProjectsForBusCap union $archStateProjects union $projectsSupportingStratPlans"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<!--<xsl:with-param name="inScopeInfoViews" select="$allInfoViews[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" />
					<xsl:with-param name="inScopeDataSubjects" select="$allDataSubjects[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" />-->
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<!--<xsl:with-param name="inScopeInfoViews" select="$allInfoViews"/>
					<xsl:with-param name="inScopeDataSubjects" select="$allInfoViews"/>-->
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Capability Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInfoViews"/>
		<xsl:param name="inScopeDataSubjects"/>


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
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentBusCap"/>
										<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
									</xsl:call-template>
								</h1>
							</div>
						</div>


						<!--Setup Description Section-->
					</div>
					<div class="row">

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="string-length($currentBusCapDescription) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No definition captured for this Business Capability')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="RenderMultiLangInstanceDescription">
											<xsl:with-param name="theSubjectInstance" select="$currentBusCap"></xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>

						</div>



						<!--Setup Domain Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Domain')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($busDomain) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No business domain captured')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$busDomain"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup Parent Capability Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Parent Business Capability')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($parentCap) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No parent capability captured')"/>
										</em>
									</xsl:when>
                                    
									<xsl:when test="count($parentCap) &gt; 1">
									 <xsl:apply-templates select="$parentCap" mode="renderBusParentCap"/>    
                                    <!--    
                                        <ul>
											<xsl:for-each select="$parentCap">
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="$parentCap"/>
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													</xsl:call-template>
												</li>
											</xsl:for-each>
										</ul>
-->


									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$parentCap"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup Parent Capability Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Capability Model')"/>
							</h2>

							<xsl:choose>

								<xsl:when test="count($subBusCaps) &gt; 0">


									<div class="content-section">
										<p>The following provides a view of the sub-capabilities of <strong><xsl:value-of select="$currentBusCapName"/></strong></p>
										<xsl:variable name="busCapability" select="$allBusinessCaps[name = $currentBusCap/name]"/>
										<xsl:variable name="busCapName" select="$busCapability/own_slot_value[slot_reference = 'name']/value"/>
										<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $busCapability/name]"/>
										<xsl:variable name="fullWidth" select="count($topLevelBusCapabilities) * 140"/>
										<xsl:variable name="widthStyle" select="concat('width:', $fullWidth, 'px;')"/>
										<div class="simple-scroller">
											<div>
												<xsl:attribute name="style" select="$widthStyle"/>

												<xsl:apply-templates mode="RenderBusinessCapabilityColumn" select="$topLevelBusCapabilities">
													<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
												</xsl:apply-templates>
											</div>
										</div>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="content-section">
										<p>
											<em>No Sub-Capabilities defined</em>
										</p>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>


						<!--Setup Supporting Processes Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Processes')"/>
							</h2>

							<div class="content-section">
								<!--<p><xsl:value-of select="eas:i18n('The following Business Capabilities and Process support the')"/>&#160; <xsl:value-of select="$currentBusCapName"/>&#160; <xsl:value-of select="eas:i18n('Business Capability')"/></p>
-->
								<!--<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Business Capability')"/>
											</th>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Business Processes')"/>
											</th>
											<th class="cellWidth-40pc">
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$relevantBusCaps" mode="RenderCapabilityRow">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										</xsl:apply-templates>
									</tbody>
								</table>-->

								<xsl:choose>
									<xsl:when test="count($currentBusProcs) = 0">
										<p>
											<em>No Sub-Processes for this capability</em>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p>The following Business Processes implement the <strong><xsl:value-of select="$currentBusCapName"/></strong> Business Capability</p>
										<br/>
										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-40pc">Process Name</th>
													<th class="cellWidth-60pc">Description</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$currentBusProcs">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
													<tr>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderMultiLangInstanceDescription">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
															</xsl:call-template>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
									</xsl:otherwise>
								</xsl:choose>


							</div>
							<hr/>
						</div>


						<!--Setup Supporting Info Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-files-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Information')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allInfoConcepts) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No Information Concepts captured')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<p><xsl:value-of select="eas:i18n('The following Information Concepts support the')"/>&#160; <xsl:value-of select="$currentBusCapName"/>&#160; <xsl:value-of select="eas:i18n('Business Capability')"/></p>

										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Information Concept')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates select="$allInfoConcepts" mode="RenderInfoRow">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>




						<!--Setup Supporting Apps Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Applications')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allAppsForCap) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No Applications captured')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<p><xsl:value-of select="eas:i18n('The following Applications support the')"/>&#160; <xsl:value-of select="$currentBusCapName"/>&#160; <xsl:value-of select="eas:i18n('Business Capability')"/></p>

										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Application')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates select="$allAppsForCap" mode="RenderAppRow">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>




						<!--Setup Supporting Objectives Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Related Business Objectives')"/>
							</h2>

							<div class="content-section">
								<xsl:call-template name="Objectives"/>
							</div>
							<hr/>
						</div>




						<!--Setup Related Projects Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Related Projects')"/>
							</h2>

							<div class="content-section">
								<xsl:call-template name="Projects"/>
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



						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<!-- render a Business Process table row  -->
	<xsl:template match="node()" mode="RenderCapabilityRow">
		<xsl:variable name="thisBusCap" select="current()"/>
		<xsl:variable name="capBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCap/name]"/>

		<xsl:text disable-output-escaping="yes">&lt;tr></xsl:text>
		<td>
			<xsl:attribute name="rowspan" select="max((1, count($capBusProcs)))"/>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</td>
		<xsl:choose>
			<xsl:when test="count($capBusProcs) > 0">
				<xsl:for-each select="$capBusProcs">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<td>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
					<td>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
					<xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<td colspan="2">
					<em>
						<xsl:value-of select="eas:i18n('No Business Processes mapped')"/>
					</em>
				</td>
				<xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- render an Information Concept table row  -->
	<xsl:template match="node()" mode="RenderInfoRow">
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<!-- render an Application Provider table row  -->
	<xsl:template match="node()" mode="RenderAppRow">
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>


	<xsl:template match="node()" mode="NameBulletList">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>

	<xsl:template name="Objectives">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($allBusObjectives) > 0">
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Objective')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('KPIs')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Motivating Drivers')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$allBusObjectives">
							<xsl:variable name="currentObj" select="current()"/>
							<xsl:variable name="objectiveName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="objectiveDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="relatedDrivers" select="$allDrivers[name = current()/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
							<xsl:variable name="measureValues" select="$relevantServiceQualityValues[name = $currentObj/own_slot_value[slot_reference = 'bo_measures']/value]"/>
							<tr>
								<td>
									<!--<xsl:value-of select="$objectiveName" />-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$objectiveDesc"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($measureValues) > 0">
											<ul>
												<xsl:for-each select="$measureValues">
													<xsl:variable name="measureType" select="$relevantServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
													<li><xsl:value-of select="$measureType/own_slot_value[slot_reference = 'name']/value"/> - <xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></li>
												</xsl:for-each>
											</ul>
										</xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<ul>
										<xsl:for-each select="$relatedDrivers">
											<li>
												<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
											</li>
										</xsl:for-each>
									</ul>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>No related Objectives defined</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="Projects">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($relevantProjects) > 0">
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Project')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Start Date')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('End Date')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$relevantProjects">
							<xsl:variable name="projectName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="projectDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="projectStartDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
							<xsl:variable name="displayProjStartDate">
								<xsl:call-template name="FullFormatDate">
									<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($projectStartDate)"/>
								</xsl:call-template>
							</xsl:variable>

							<xsl:variable name="projectEndDate" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
							<xsl:variable name="displayProjEndDate">
								<xsl:call-template name="FullFormatDate">
									<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($projectEndDate)"/>
								</xsl:call-template>
							</xsl:variable>
							<tr>
								<td>
									<!--<xsl:value-of select="$projectName" />-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$projectDesc"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($projectStartDate) > 0">
											<xsl:value-of select="$displayProjStartDate"/>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('undefined')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($projectEndDate) > 0">
											<xsl:value-of select="$displayProjEndDate"/>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('undefined')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No related Projects defined')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- render a column of business capabilities -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityColumn">

		<div class="compModelColumn">
			<div class="compModelElementContainer" >
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'compModelContent backColour19 text-black small impact tabTop'"/>
					<xsl:with-param name="anchorClass" select="'text-white small'"/>
				</xsl:call-template>
			</div>
			<xsl:variable name="supportingBusCaps" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = current()/name]"/>
			<xsl:choose>
				<xsl:when test="count($supportingBusCaps) &gt; 0">
					<xsl:apply-templates mode="RenderBusinessCapabilityCell" select="$supportingBusCaps">
						<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<div class="compModelElementContainer">
						<div class="compModelContent small">
							<em>No sub-capabilities defined</em>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>


		</div>
	</xsl:template>



	<!-- render a business capability cell -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityCell">
		<div class="compModelElementContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="'compModelContent small'"/>
			</xsl:call-template>
		</div>
	</xsl:template>
    <xsl:template match="node()" mode="renderBusParentCap">
        <xsl:variable name="this" select="current()"/>
    <li>
        <xsl:call-template name="RenderInstanceLink">
		<xsl:with-param name="theSubjectInstance" select="$this"/>
		<xsl:with-param name="theXML" select="$reposXML"/>
		<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
		</xsl:call-template>
    </li>
    </xsl:template>


</xsl:stylesheet>
