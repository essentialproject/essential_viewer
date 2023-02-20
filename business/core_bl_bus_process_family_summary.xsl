<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html"/>
	<xsl:param name="param1"/>
	<xsl:variable name="currentProcessFamily" select="/node()/simple_instance[name = $param1]"/>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Role', 'Business_Capability', 'Group_Actor', 'Individual_Actor', 'Site', 'Composite_Application_Provider', 'Application_Provider', 'Information_Concept', 'Information_View', 'Business_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<!-- Required View-specific instance -->
	<xsl:variable name="bpf" select="/node()/simple_instance[type = 'Business_Process_Family'][name = $param1]"/>
	<xsl:variable name="relevantProcessesOld" select="/node()/simple_instance[type = 'Business_Process'][name = $bpf/own_slot_value[slot_reference = 'bpf_contained_business_process_types']/value]"/>
	<xsl:variable name="relevantProcessesNew" select="/node()/simple_instance[type = 'Business_Process'][name = $bpf/own_slot_value[slot_reference = 'bpf_contains_busproctypes']/value]"/>
	<xsl:variable name="relevantProcesses" select="$relevantProcessesOld union $relevantProcessesNew"/>
	
	<xsl:variable name="relevantBusCaps" select="/node()/simple_instance[type = 'Business_Capability'][name = $relevantProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="processManagerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Process Manager')]"/>
	<xsl:variable name="standardisation_level" select="/node()/simple_instance[name = $relevantProcesses/own_slot_value[slot_reference = 'standardisation_level']/value]"/>
	<xsl:variable name="phys_process_list" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allPhysProcessActorRelations" select="/node()/simple_instance[name = $phys_process_list/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="allPhysProcessDirecActors" select="$allPhysProcessActorRelations[type = 'Group_Actor']"/>
	<xsl:variable name="allPhysProcessActorsViaRoles" select="/node()/simple_instance[name = $allPhysProcessActorRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allPhysProcessActors" select="$allPhysProcessDirecActors union $allPhysProcessActorsViaRoles"/>
	<xsl:variable name="allPhysProcessSites" select="$allSites[name = $phys_process_list/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
	<xsl:variable name="allPhysProcActorSites" select="$allSites[name = $allPhysProcessActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allPhysProcAppRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcAppProRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcApp2Roles" select="/node()/simple_instance[name = $allPhysProcAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="allPhysProcSupportingApps" select="$allApps[name = $allPhysProcApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allPhysProcApp2InfoRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcApp2Infos" select="/node()/simple_instance[name = $allPhysProcApp2InfoRelations/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value]"/>
	<xsl:variable name="allPhysProcSupportingInfoApps" select="$allApps[name = $allPhysProcApp2Infos/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
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
	<!-- 08 Jun 2018 JM created -->
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Business Process Family Summary')"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<script>
					function toggleAll() {
						if ($('#btnAll').hasClass('fa-toggle-on')) {
							$('#btnAll').removeClass('fa-toggle-on').addClass('fa-toggle-off');
							$('.tbn').removeClass('fa-toggle-on tbn').addClass('fa-toggle-off tbn')
							$('.physProc').hide();
						} else {
							$('#btnAll').removeClass('fa-toggle-off').addClass('fa-toggle-on');
							$('.tbn').removeClass('fa-toggle-off tbn').addClass('fa-toggle-on tbn')
							$('.physProc').show();
						}
					}
					
					
					function toggleProcess(process) {
						
						if ($('#btn' + process).hasClass('fa-toggle-on tbn')) {
							$('#btn' + process).removeClass('fa-toggle-on tbn').addClass('fa-toggle-off tbn');
							$('#' + process).hide();
						} else {
							$('#btn' + process).removeClass('fa-toggle-off tbn').addClass('fa-toggle-on tbn');
							$('#' + process).show();
						}
					}
                </script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$bpf" mode="Page_Content"/>
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
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process Family Summary for')"/>&#160;</span>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$bpf"/>
								<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
							</xsl:call-template>
						</h1>
					</div>		
				</div>
				<!--Setup the Definition section-->
				<div class="col-xs-6">
					<div class="sectionIcon">
						<i class="fa fa-list-ul icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Description')"/>
					</h2>
					<div class="content-section">
						<p>
							<xsl:if test="string-length($bpf/own_slot_value[slot_reference = 'description']/value) = 0">
								<span>-</span>
							</xsl:if>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="$bpf"/>
							</xsl:call-template>
						</p>
					</div>
				</div>
				<div class="col-xs-6">
					<div class="sectionIcon">
						<i class="fa essicon-blocks icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supported Business Capabilities')"/>
					</h2>
					<div class="content-section">
						<ul>
							<xsl:apply-templates select="$relevantBusCaps" mode="busCap">
								<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
					</div>
				</div>
				<div class="col-xs-12">
					<hr/>
				</div>
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-sitemap icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Contained Business Processes')"/>
					</h2>
					<div class="clearfix"></div>
					<div class="btn btn-default bottom-15 top-5" onClick="toggleAll()">
						<strong>Show/Hide All Physical Processes:</strong>
						<i id="btnAll" class="fa fa-toggle-off left-5" />
					</div>
					<table id="dt_process" class="table">
						<thead>
							<tr>
								<th>Business Process</th>
								<th>Standardisation</th>
								<th class="text-center">Physical Processes</th>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates select="$relevantProcesses" mode="ProcessTable">
								<xsl:sort select="own_slot_name[slot_reference = 'name']/value" order="ascending"/>
							</xsl:apply-templates>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="node()" mode="ProcessTable">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisid" select="current()/name"/>
		<xsl:variable name="thisLevel" select="$this/own_slot_value[slot_reference = 'standardisation_level']/value"/>
		<xsl:variable name="thisPhyProcesses" select="$phys_process_list[name = $this/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
		<tr class="bg-offwhite large">
			<td>
				<i class="fa essicon-boxesdiagonal icon-color right-5"/>
				<strong><xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template></strong>
				<xsl:if test="current()/own_slot_value[slot_reference = 'business_process_id']/value">
					<xsl:text> </xsl:text>(ID:<xsl:value-of select="current()/own_slot_value[slot_reference = 'business_process_id']/value"/>)
				</xsl:if>
				<br/>
				<div class="xsmall text-darkgrey"><i id="btn{$thisid}" class="fa fa-toggle-off tbn right-" onclick="toggleProcess(&quot;{$thisid}&quot;)" /><span>Show/Hide Physical Processes</span></div>
			</td>
			<td>
				<xsl:value-of select="$standardisation_level[name = $thisLevel]/own_slot_value[slot_reference = 'name']/value"/>
			</td>
			<td class="xlarge text-center">
				<strong>
					<xsl:value-of select="count($thisPhyProcesses)"/>
				</strong>
			</td>
		</tr>
		<tr id="{$thisid}" class="physProc hiddenDiv">
			<td colspan="3">
				<xsl:choose>
					<xsl:when test="count($thisPhyProcesses) &gt; 0">
						<table class="table table-bordered top-15 bottom-15 small">
							<thead>
								<tr class="bg-lightblue-100">
									<th class="cellWidth-30pc">Performed By</th>
									<th class="cellWidth-30pc">Site</th>
									<th class="cellWidth-40pc">Applications Used</th>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select="$thisPhyProcesses" mode="Physical_Process">
									<xsl:sort select="own_slot_name[slot_reference = 'name']/value" order="ascending"/>
								</xsl:apply-templates>
							</tbody>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<p class="top-30 bottom-30">No physical processes defined</p>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!--Other Templates called by the main body-->
	<!-- TEMPLATE TO CREATE THE DETAILS FOR PHYSICAL PROCESSES THAT IMPLEMENT THE LOGICAL PROCESS -->
	<xsl:template match="node()" mode="Physical_Process">
		<xsl:variable name="processActorRelation" select="$allPhysProcessActorRelations[name = current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="processActorsViaRole" select="$allPhysProcessActors[name = $processActorRelation/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="processDirectActors" select="$processActorRelation[type = 'Group_Actor']"/>
		<xsl:variable name="processActor" select="$processActorsViaRole union $processDirectActors"/>
		<xsl:variable name="processSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
		<xsl:variable name="actorSites" select="$allSites[name = $processActor/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="supportingAppRelations" select="$allPhysProcAppRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = current()/name]"/>
		<xsl:variable name="supportingApps" select="$allApps[name = $supportingAppRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="supportingAppProRelations" select="$allPhysProcAppProRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = current()/name]"/>
		<xsl:variable name="supportingApp2Roles" select="$allPhysProcApp2Roles[name = $supportingAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="supportingAppRoleApps" select="$allApps[name = $supportingApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="supportingApp2InfoRelations" select="$allPhysProcApp2InfoRelations[own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value = current()/name]"/>
		<xsl:variable name="supportingApp2Infos" select="$allPhysProcApp2Infos[name = $supportingApp2InfoRelations/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value]"/>
		<xsl:variable name="supportingInfoApps" select="$allPhysProcSupportingInfoApps[name = $supportingApp2Infos/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
		<xsl:variable name="allSupportingApps" select="$supportingApps union $supportingAppRoleApps union $supportingInfoApps"/>
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
				<xsl:for-each select="$allSupportingApps">
					<li>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="node()" mode="busCap">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>
</xsl:stylesheet>
