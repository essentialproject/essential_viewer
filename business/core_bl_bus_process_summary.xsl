<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


	<xsl:output method="html"/>
	<xsl:param name="param1"/>
	<xsl:variable name="currentProcess" select="/node()/simple_instance[name = $param1]"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Role', 'Business_Capability', 'Group_Actor', 'Individual_Actor', 'Site', 'Application_Provider', 'Information_Concept', 'Information_View', 'Business_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Required View-specific instance -->
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="processManagerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Process Manager')]"/>

	<xsl:variable name="standardisation_level" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'standardisation_level']/value]"/>
	<xsl:variable name="phys_process_list" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
	<xsl:variable name="allPhysProcessActorRelations" select="/node()/simple_instance[name = $phys_process_list/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="allPhysProcessActors" select="/node()/simple_instance[name = $allPhysProcessActorRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allPhysProcessSites" select="$allSites[name = $phys_process_list/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
	<xsl:variable name="allPhysProcActorSites" select="$allSites[name = $allPhysProcessActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allPhysProcAppRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcAppProRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcApp2Roles" select="/node()/simple_instance[name = $allPhysProcAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>


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
	<!-- 15.06.2016 JP 	Refactored to improve performance. -->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Business Process Summary')"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentProcess" mode="Page_Content"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="Page_Content">
		<!-- Get the name of the business process -->
		<xsl:variable name="processName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<div class="container-fluid">
			<div class="row">

				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process Summary for')"/>&#160;</span>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentProcess"/>
								<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
							</xsl:call-template>
						</h1>
					</div>
				</div>

				<!--Setup the Definition section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-list-ul icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Description')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:if test="string-length($currentProcess/own_slot_value[slot_reference = 'description']/value) = 0">
								<span>-</span>
							</xsl:if>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="$currentProcess"/>
							</xsl:call-template>
						</p>
					</div>
					<hr/>
				</div>


				<!--Setup the Standardisation section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-check icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Standardisation Level')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:if test="not(string($standardisation_level))">
								<em>
									<xsl:value-of select="eas:i18n('Standardisation level not defined for this process')"/>
								</em>
							</xsl:if>
							<xsl:value-of select="$standardisation_level/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</p>
					</div>
					<hr/>
				</div>


				<!--Setup the Performed by Roles section-->
				<xsl:variable name="rolesPerformed" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-user icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Performed by Roles')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:if test="not(count($rolesPerformed) > 0)">
								<em>
									<xsl:value-of select="eas:i18n('No roles defined for this process')"/>
								</em>
							</xsl:if>
							<ul class="noMarginBottom">
								<xsl:for-each select="$rolesPerformed">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</p>
					</div>
					<hr/>
				</div>


				<!--Setup the Realised Business Capabilities section-->
				<xsl:variable name="bus_cap" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa essicon-blocks icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Realised Business Capabilities')"/>
					</h2>



					<div class="content-section">
						<xsl:if test="count($bus_cap) = 0">
							<em>
								<xsl:value-of select="eas:i18n('No business capabilities defined for this process')"/>
							</em>
						</xsl:if>
						<ul class="noMarginBottom">
							<xsl:for-each select="$bus_cap">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</div>

					<hr/>
				</div>



				<!--Setup the Strategic Plans section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Strategic Planning')"/>
					</h2>


					<div class="content-section">
						<xsl:apply-templates select="$currentProcess/name" mode="StrategicPlansForElement"/>
					</div>

					<hr/>
				</div>



				<!--Setup the Implementing Processes section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-users icon-section icon-color"/>
					</div>
					<div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Implementing Processes')"/>
						</h2>
					</div>
					<div class="content-section">

						<xsl:choose>
							<xsl:when test="not(count($phys_process_list) > 0)">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No Physical Processes Defined')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>

								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="cellWidth-25pc">
												<xsl:value-of select="eas:i18n('Process Performed by')"/>
											</th>
											<th class="cellWidth-20pc">
												<xsl:value-of select="eas:i18n('Performed at Sites')"/>
											</th>
											<th class="cellWidth-20pc">
												<xsl:value-of select="eas:i18n('Process Manager')"/>
											</th>
											<th class="cellWidth-35pc">
												<xsl:value-of select="eas:i18n('Supporting Applications')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$phys_process_list" mode="Physical_Process"> </xsl:apply-templates>
									</tbody>
								</table>

							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>


				<!--Setup the Supporting Information section-->
				<xsl:variable name="read_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_reads_information']/value]"/>
				<xsl:variable name="created_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_creates_information']/value]"/>
				<xsl:variable name="updated_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_updates_information']/value]"/>
				<xsl:variable name="deleted_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_deletes_information']/value]"/>
				<xsl:variable name="anInfoRelList" select="own_slot_value[slot_reference = 'busproctype_uses_infoviews']/value"/>
				<xsl:variable name="aReadRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_reads_infoview']/value = 'Yes']"/>
				<xsl:variable name="aCreateRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_creates_infoview']/value = 'Yes']"/>
				<xsl:variable name="anUpdateRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_updates_infoview']/value = 'Yes']"/>
				<xsl:variable name="aDeleteRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_deletes_infoview']/value = 'Yes']"/>
				<xsl:variable name="anInfoRead" select="/node()/simple_instance[name = $aReadRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<xsl:variable name="anInfoCreated" select="/node()/simple_instance[name = $aCreateRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<xsl:variable name="anInfoUpdated" select="/node()/simple_instance[name = $anUpdateRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<xsl:variable name="anInfoDeleted" select="/node()/simple_instance[name = $aDeleteRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<script>
								$(document).ready(function(){									
									$('#dt_infoUsed,#dt_infoCreated,#dt_infoUpdated,#dt_infoDeleted').DataTable({
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									filter: false,
									columns: [
									    { "width": "20%" },
									    { "width": "40%" },
									    { "width": "40%" }
									  ]
									});
									
									$(window).resize( function () {
									        table.columns.adjust();
									    });

								});
							</script>

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-files-o icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Information')"/>
					</h2>

					<div class="content-section">
						<p><xsl:value-of select="eas:i18n('A summary of the information interactions for the')"/>&#160;<span class="text-primary"><xsl:value-of select="$processName"/></span>&#160;<xsl:value-of select="eas:i18n(' process')"/></p>

						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Used')"/>
						</h3>
						<xsl:if test="not(count($read_info_views) > 0) and not(count($anInfoRead) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($read_info_views) > 0) or (count($anInfoRead) > 0)">
							<table id="dt_infoUsed" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$read_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoRead" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>
						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Created')"/>
						</h3>
						<xsl:if test="not(count($created_info_views) > 0) and not(count($anInfoCreated) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($created_info_views) > 0) or (count($anInfoCreated) > 0)">
							<table id="dt_infoCreated" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$created_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoCreated" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>
						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Updated')"/>
						</h3>
						<xsl:if test="not(count($updated_info_views) > 0) and not(count($anInfoUpdated) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($updated_info_views) > 0) or (count($anInfoUpdated) > 0)">
							<table id="dt_infoUpdated" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$updated_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoUpdated" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>

						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Deleted')"/>
						</h3>
						<xsl:if test="not(count($deleted_info_views) > 0) and not(count($anInfoDeleted) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($deleted_info_views) > 0) or (count($anInfoDeleted) > 0)">
							<table id="dt_infoDeleted" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$deleted_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoDeleted" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup the defining process flow section-->

				<!--<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-sitemap icon-section icon-color"/>
					</div>
					<div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Defining Process Flow')"/>
						</h2>
					</div>
					<div class="content-section">
						<xsl:variable name="processFlowArch" select="own_slot_value[slot_reference='defining_business_process_flow']/value"/>
						<xsl:choose>
							<xsl:when test="count($processFlowArch) > 0">
								<p><xsl:value-of select="eas:i18n('The following diagram shows the process flow that describes the design of the')"/>&#160;<span class="text-primary"><xsl:value-of select="$processName"/></span> process </p>
								<div>
									<xsl:apply-templates select="/node()/simple_instance[name=$processFlowArch]" mode="RenderArchitectureImage"/>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div><xsl:value-of select="eas:i18n('No process flow defined for the')"/>&#160; <span class="text-primary"><xsl:value-of select="$processName"/></span>&#160; <xsl:value-of select="eas:i18n('process')"/>. </div>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>-->


				<!--Setup the Supporting Documentation section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-file-text-o icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
					</h2>

					<div class="content-section">
						<xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
						<xsl:call-template name="RenderExternalDocRefList">
							<xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/>
						</xsl:call-template>
						<!--<xsl:apply-templates select="/node()/simple_instance[name = $param1]" mode="ReportExternalDocRef"/>-->
					</div>

					<hr/>
				</div>

			</div>
		</div>
	</xsl:template>
	<!--Other Templates called by the main body-->
	<!-- TEMPLATE TO CREATE THE DETAILS FOR PHYSICAL PROCESSES THAT IMPLEMENT THE LOGICAL PROCESS -->
	<xsl:template match="node()" mode="Physical_Process">
		<xsl:variable name="processActorRelation" select="$allPhysProcessActorRelations[name = current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="processActor" select="$allPhysProcessActors[name = $processActorRelation/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="processSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
		<xsl:variable name="actorSites" select="$allSites[name = $processActor/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="processManagerActor2Role" select="$allActor2Roles[(name = current()/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processManagerRole/name)]"/>
		<xsl:variable name="processManager" select="$allIndividualActors[name = $processManagerActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="supportingAppRelations" select="$allPhysProcAppRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = current()/name]"/>
		<xsl:variable name="supportingApps" select="$allApps[name = $supportingAppRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="supportingAppProRelations" select="$allPhysProcAppProRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = current()/name]"/>
		<xsl:variable name="supportingApp2Roles" select="$allPhysProcApp2Roles[name = $supportingAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="supportingAppRoleApps" select="$allApps[name = $supportingApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$processActor"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($processSites) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$processSites">
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
					<xsl:when test="count($actorSites) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$actorSites">
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
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="not(string($processManager))">-</xsl:if>
				<!--<xsl:value-of select="$processManager/own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$processManager"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($supportingAppRoleApps) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$supportingAppRoleApps">
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
					<xsl:when test="count($supportingApps) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$supportingApps">
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
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING INFORMATION VIEW -->
	<xsl:template match="node()" mode="Info_View">
		<tr>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoCapViewRep.xsl&amp;</xsl:text>
						<xsl:text>&amp;LABEL=Information Model Catalogue - </xsl:text>
						<xsl:value-of select="translate(own_slot_value[slot_reference='name']/value, '::', ' ')" />
					</xsl:attribute>
					<xsl:value-of select="translate(own_slot_value[slot_reference='name']/value, '::', ' ')" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(string(own_slot_value[slot_reference = 'description']/value))">-</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<xsl:variable name="infoConcept" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value]"/>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoCapViewRep.xsl&amp;</xsl:text>
						<xsl:text>&amp;LABEL=Information Model Catalogue - </xsl:text>
						<xsl:value-of select="$infoConcept/own_slot_value[slot_reference='name']/value" />
					</xsl:attribute>
					<xsl:value-of select="$infoConcept/own_slot_value[slot_reference='name']/value" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$infoConcept"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING STRATEGIC PLAN  -->
	<!-- Given a reference (instance ID) to an element, find all its plans and render each -->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>
		<xsl:variable name="aStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement]"/>
		<!-- Test to see if any plans are defined yet -->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-- Show active plans first -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anActivePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-- Then the future -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $aFuturePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-- Then the old -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anOldPlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No strategic plans defined for this element')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Render the details of a particular strategic plan in a small table -->
	<!-- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -->
	<xsl:template match="node()" mode="StrategicPlanDetailsTable">
		<xsl:param name="theStatus"/>
		<xsl:variable name="aStatusID" select="current()/own_slot_value[slot_reference = 'strategic_plan_status']/value"/>
		<xsl:if test="$aStatusID = $theStatus">
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th>
							<xsl:value-of select="eas:i18n('Plan')"/>
						</th>
						<th>
							<xsl:value-of select="eas:i18n('Description')"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<strong>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									<xsl:with-param name="displayString" select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
								</xsl:call-template>
							</strong>
						</td>
						<td>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
