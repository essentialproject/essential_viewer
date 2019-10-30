<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_View', 'Information_Concept', 'Technology_Node', 'Hardware_Instance', 'Infrastructure_Software_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Application_Provider', 'Composite_Application_Provider', 'Application_Software_Instance', 'Information_Store_Instance', 'Physical_Process', 'Individual_Actor', 'Group_Actor', 'Information_Representation_Attribute', 'Business_Process', 'Business_Activity')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentRepresentation" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="information_stores" select="$currentRepresentation/own_slot_value[slot_reference = 'implemented_with_information_stores']/value"/>
	<xsl:variable name="anInfoStoreList" select="/node()/simple_instance[name = $information_stores]"/>
	<xsl:variable name="count" select="count($information_stores)"/>

	<!-- START VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allIndivActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="currentReport" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentReportName" select="$currentReport/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = 'Application_Provider' or type = 'Composite_Application_Provider']"/>

	<!-- Get the physical process that produces this report -->
	<xsl:variable name="currentApp2InfoReps" select="/node()/simple_instance[(own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value = $currentReport/name)]"/>
	<xsl:variable name="currentApp2InfoRep2PhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value = $currentApp2InfoReps/name]"/>
	<xsl:variable name="producingPhysProcs" select="/node()/simple_instance[name = $currentApp2InfoRep2PhysProcs/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value]"/>
	<xsl:variable name="supportedApps" select="$allApps[name = $currentApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>

	<!-- Get the individual that is the business owner of the report -->
	<xsl:variable name="infoBusOwnerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Information Business Owner')]"/>
	<xsl:variable name="reportBusOwnerActor2Role" select="$allActor2Roles[(name = $currentReport/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $infoBusOwnerRole/name)]"/>
	<xsl:variable name="reportBusOwnerActor" select="$allIndivActors[name = $reportBusOwnerActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

	<!-- Get the security policies associated with the report that will provide the stakeholders and security access description -->
	<xsl:variable name="reportSecPolicies" select="/node()/simple_instance[own_slot_value[slot_reference = 'sp_resources']/value = $currentReport/name]"/>
	<xsl:variable name="reportBusStakeholdersSec" select="$allIndivActors[name = $reportSecPolicies/own_slot_value[slot_reference = 'sp_actor']/value]"/>
	<xsl:variable name="directStakeholderRoleRels" select="$allActor2Roles[name = $currentReport/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="directStakeholders" select="$allGroupActors[name = $directStakeholderRoleRels/own_slot_value[slot_reference = 'act_to_role_from_actor']/value] union $allIndivActors[name = $directStakeholderRoleRels/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="reportBusStakeholders" select="($reportBusStakeholdersSec union $directStakeholders) except $reportBusOwnerActor"/>
	<xsl:variable name="secAccessDescs" select="$reportSecPolicies/own_slot_value[slot_reference = 'description']/value"/>

	<!-- Get the triggering events by accessing the logical process flow of the physical process that produces the report -->
	<xsl:variable name="producingLogicalProcs" select="/node()/simple_instance[name = $producingPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="logicalActivs" select="/node()/simple_instance[name = $producingPhysProcs/own_slot_value[slot_reference = 'instance_of_business_activity']/value]"/>
	<xsl:variable name="supportedProcs" select="$producingLogicalProcs union $logicalActivs"/>
	<xsl:variable name="producingProcessFlows" select="/node()/simple_instance[name = $producingLogicalProcs/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
	<xsl:variable name="producingProcessUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'used_in_process_flow']/value = $producingProcessFlows/name]"/>
	<xsl:variable name="reportTriggerEventUsages" select="$producingProcessUsages[type = 'Initiating_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="reportTriggerEvents" select="/node()/simple_instance[name = $reportTriggerEventUsages/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value]"/>


	<!-- Get the technical format of the report -->
	<xsl:variable name="reportTechnicalFormatRole" select="/node()/simple_instance[name = $currentReport/own_slot_value[slot_reference = 'representation_technology']/value]"/>
	<xsl:variable name="reportTechnicalFormat" select="/node()/simple_instance[name = $reportTechnicalFormatRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>

	<!-- Get the delivery method for the report -->
	<xsl:variable name="reportDeliveryMethods" select="$currentApp2InfoRep2PhysProcs/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_info_delivery']/value"/>

	<!-- Get the report attributes contained in the report -->
	<xsl:variable name="reportObjects" select="/node()/simple_instance[name = $currentReport/own_slot_value[slot_reference = 'contained_information_representation_attributes']/value]"/>

	<!-- END VIEW SPECIFIC VARIABLES -->


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
	<!-- 19.06.2013	JWC	Completed view, removing the dummy data -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Information Representation Summary')"/>
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
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">
											<xsl:value-of select="eas:i18n('Information Representation Summary for ')"/>
										</span>
										<span class="text-primary">
											<xsl:value-of select="$currentRepresentation/own_slot_value[slot_reference = 'name']/value"/>
										</span>
									</h1>
								</div>
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
								<xsl:variable name="description" select="$currentRepresentation/own_slot_value[slot_reference = 'description']/value"/>
								<xsl:if test="not(count($description) > 0)">-</xsl:if>
								<xsl:value-of select="$description"/>
							</div>
							<hr/>
						</div>



						<!--Setup Info Views Represented Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-files-o icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Information Views &#38; Concepts')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:apply-templates select="$currentRepresentation" mode="ViewAndConcept"/>
							</div>
							<hr/>
						</div>



						<!--Setup Info Rep Deployments Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-database icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Information Representation Deployments')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($anInfoStoreList) > 0">
										<xsl:apply-templates select="$anInfoStoreList" mode="Information_Stores"/>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<em>
												<xsl:value-of select="eas:i18n('No defined deployments for this Information Representation')"/>
											</em>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Supported Processes Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supported Processes')"/>
							</h2>
							<div class="content-section">
								<!-- Only if there are some supported processes -->
								<xsl:choose>
									<xsl:when test="count($supportedProcs) > 0">
										<p>
											<xsl:value-of select="eas:i18n('The following processes are supported by this Information Representation')"/>
										</p>
										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Process')"/>
													</th>
													<th class="cellWidth-50pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$supportedProcs">
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
												</xsl:for-each>
											</tbody>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No supported processes defined for this Information Representation')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Supported Apps Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supported Applications')"/>
							</h2>
							<!-- Only if there are some supported processes -->
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($supportedApps) > 0">
										<p>
											<xsl:value-of select="eas:i18n('The following applications are supported by this Information Representation')"/>
										</p>
										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Application')"/>
													</th>
													<th class="cellWidth-50pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$supportedApps">
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
												</xsl:for-each>

											</tbody>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No supported applications defined for this Information Representation')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Business Owner Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Owner')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($reportBusOwnerActor) > 0">
										<ul>
											<xsl:for-each select="$reportBusOwnerActor">
												<xsl:variable name="currentActor" select="current()"/>
												<xsl:variable name="ownerOrg" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="$currentActor"/>
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													</xsl:call-template>
													<xsl:if test="count($ownerOrg) > 0">&#160;- &#160;<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="$ownerOrg"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template></xsl:if>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<em><xsl:value-of select="eas:i18n('No business owner has been captured for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Business Stakeholders Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Stakeholders')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:choose>
										<xsl:when test="count($reportBusStakeholders) > 0">
											<ul>
												<xsl:for-each select="$reportBusStakeholders">
													<xsl:variable name="currentActor" select="current()"/>
													<xsl:variable name="actorOrg" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
													<li>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="$currentActor"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template>
														<xsl:if test="count($actorOrg) > 0">&#160;- &#160;<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$actorOrg"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template></xsl:if>
													</li>
												</xsl:for-each>
											</ul>
										</xsl:when>
										<xsl:otherwise>
											<em><xsl:value-of select="eas:i18n('No business stakeholders have been captured for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>



						<!--Setup Security Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-lock icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Security')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($secAccessDescs) = 1">
										<p>
											<xsl:value-of select="$secAccessDescs"/>
										</p>
									</xsl:when>
									<xsl:when test="count($secAccessDescs) = 1">
										<p><xsl:value-of select="eas:i18n('The following access control policies are in place for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong>:</p>
										<ul>
											<xsl:for-each select="$secAccessDescs">
												<li>
													<xsl:value-of select="current()"/>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<em><xsl:value-of select="eas:i18n('No security information has been captured for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Frequency Section-->

						<div class="col-xs-12 col-md-6">
							<div class="sectionIcon">
								<i class="fa fa-clock-o icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Timing/Frequency')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($reportTriggerEvents) > 1">
										<p><strong><xsl:value-of select="$currentReportName"/></strong>&#160; <xsl:value-of select="eas:i18n('is created based on the following schedules:')"/></p>
										<ul>
											<xsl:for-each select="$reportTriggerEvents">
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="current()"/>
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													</xsl:call-template> - <xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:when test="count($reportTriggerEvents) = 1">
										<p><xsl:value-of select="$reportTriggerEvents/own_slot_value[slot_reference = 'name']/value"/> - <xsl:value-of select="$reportTriggerEvents/own_slot_value[slot_reference = 'description']/value"/></p>
									</xsl:when>
									<xsl:otherwise>
										<em><xsl:value-of select="eas:i18n('No timing/frequency information has been captured for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Output Format Section-->

						<div class="col-xs-12 col-md-6">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Output Format')"/>
							</h2>


							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($reportTechnicalFormat) = 1">
										<p>
											<xsl:value-of select="$reportTechnicalFormat/own_slot_value[slot_reference = 'name']/value"/>
										</p>
									</xsl:when>
									<xsl:when test="count($reportTechnicalFormat) > 1">
										<p><strong><xsl:value-of select="$currentReportName"/></strong>&#160;<xsl:value-of select="eas:i18n('is provided in the following formats:')"/></p>
										<ul>
											<xsl:for-each select="$reportTechnicalFormat">
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="current()"/>
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													</xsl:call-template>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<em><xsl:value-of select="eas:i18n('The output format has not been captured for the')"/>&#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Delivery Method Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-truck icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Delivery Method')"/>
							</h2>


							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($reportDeliveryMethods) = 1">
										<p>
											<xsl:value-of select="$reportDeliveryMethods"/>
										</p>
									</xsl:when>
									<xsl:when test="count($reportDeliveryMethods) > 1">
										<p><strong><xsl:value-of select="$currentReportName"/></strong> &#160;<xsl:value-of select="eas:i18n('is delivered using the following methods:')"/></p>
										<ul>
											<xsl:for-each select="$reportDeliveryMethods">
												<li>
													<xsl:value-of select="current()"/>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<em><xsl:value-of select="eas:i18n('No delivery methods have been captured for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Attributes Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Representation Attributes')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($reportObjects) > 0">
										<p><xsl:value-of select="eas:i18n('The following report data objects are contained within the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></p>
										<table class="table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$reportObjects">
													<xsl:sort select="own_slot_value[slot_reference = 'representation_label']/value"/>
													<tr>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="displayString" select="own_slot_value[slot_reference = 'representation_label']/value"/>
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
									</xsl:when>
									<xsl:otherwise>
										<em><xsl:value-of select="eas:i18n('No report data objects have been captured for the')"/> &#160;<strong><xsl:value-of select="$currentReportName"/></strong></em>
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


						<!--Setup Closing Tags-->
					</div>
				</div>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="node()" mode="ViewAndConcept">
		<xsl:variable name="views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'implements_information_views']/value]"/>

		<xsl:choose>
			<xsl:when test="count($views) > 0">
				<table>
					<thead>
						<tr>
							<th class="cellWidth-50pc">
								<xsl:value-of select="eas:i18n('Information Views Represented')"/>
							</th>
							<th class="cellWidth-50pc">
								<xsl:value-of select="eas:i18n('Infomation Concept of View')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each-group select="$views" group-by="name">
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<!--<xsl:apply-templates select="own_slot_value[slot_reference='refinement_of_information_concept']/value" mode="RenderInstanceName" />-->
									<xsl:variable name="concepts" select="current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value"/>
									<xsl:variable name="allConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>
									<xsl:variable name="relevantConcepts" select="$allConcepts[name = $concepts]"/>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$relevantConcepts"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:for-each-group>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('No Information Views defined for this representation')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="Information_Stores">
		<xsl:variable name="environment_id" select="own_slot_value[slot_reference = 'information_store_deployment_role']/value"/>
		<xsl:variable name="environment" select="/node()/simple_instance[name = $environment_id]"/>
		<xsl:variable name="instance_ids" select="own_slot_value[slot_reference = 'deployed_information_store_instances']/value"/>
		<xsl:choose>
			<xsl:when test="count($instance_ids) > 0">
				<h3><xsl:value-of select="$environment/own_slot_value[slot_reference = 'name']/value"/>&#160;<xsl:value-of select="eas:i18n('environment:')"/></h3>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Name')"/>
							</th>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Status')"/>
							</th>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Deployed to')"/>
							</th>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Dependencies')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="/node()/simple_instance[name = $instance_ids]" mode="Information_Store_Instance"/>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No defined deployments for this Information Representation')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="Information_Store_Instance">
		<xsl:variable name="deploy_status_id" select="own_slot_value[slot_reference = 'technology_instance_deployment_status']/value"/>
		<xsl:variable name="deploy_status" select="/node()/simple_instance[name = $deploy_status_id]"/>
		<xsl:variable name="deployed_to_id" select="own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value"/>
		<xsl:variable name="deployed_to" select="/node()/simple_instance[name = $deployed_to_id]"/>
		<xsl:variable name="deployedNodeName" select="$deployed_to/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="dependency_id" select="own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value"/>

		<tr>
			<td>
				<!--<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="$deploy_status/own_slot_value[slot_reference = 'name']/value"/>
			</td>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_phys_node_def.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="$deployed_to_id" />
						<xsl:text>&amp;LABEL=Physical Node Definition - </xsl:text>
						<xsl:value-of select="$deployedNodeName" />
					</xsl:attribute>
					<xsl:value-of select="$deployedNodeName" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$deployed_to"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<ul>
					<xsl:apply-templates select="/node()/simple_instance[name = $dependency_id]" mode="dependencies"/>
				</ul>
			</td>
		</tr>

	</xsl:template>

	<xsl:template match="node()" mode="dependencies">
		<xsl:variable name="anInstanceName" select="own_slot_value[slot_reference = 'name']/value"/>
		<li>
			<!--<a>
				<xsl:attribute name="href">
					<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
					<xsl:value-of select="name" />
					<xsl:text>&amp;LABEL=Technology Instance Definition - </xsl:text>
					<xsl:value-of select="$anInstanceName" />
				</xsl:attribute>
				<xsl:value-of select="$anInstanceName" />
			</a>-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>

</xsl:stylesheet>
