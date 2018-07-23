<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<!--<xsl:include href="../common/core_strategic_plans.xsl" />-->
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:include href="../common/core_uml_model_links.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:character-map name="pi-delimiters">
		<xsl:output-character character="§" string=">"/>
		<xsl:output-character character="¶" string="&lt;"/>
		<xsl:output-character character="€" string="&amp;quot;"/>
	</xsl:character-map>

	<xsl:output use-character-maps="pi-delimiters"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param2 = the path of the dynamically generated UML model -->
	<xsl:param name="param2"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Representation', 'Business_Process', 'Business_Activity', 'Individual_Business_Role', 'Group_Business_Role', 'Business_Objective', 'Application_Provider', 'Business_Event', 'Time_Based_Business_Event')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:param name="imageFilename"/>
	<xsl:param name="imageMapPath"/>

	<xsl:variable name="allApps" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[(type = 'Information_Representation')]"/>
	<xsl:variable name="allAppPro2InfoReps" select="/node()/simple_instance[(type = 'APP_PRO_TO_INFOREP_RELATION')]"/>
	<xsl:variable name="allAppFuncImpls" select="/node()/simple_instance[(type = 'Application_Function_Implementation')]"/>
	<xsl:variable name="allDynamicAppArchs" select="/node()/simple_instance[type = 'Dynamic_Application_Provider_Architecture']"/>
	<xsl:variable name="allDynamicAppArchFuncUsages" select="/node()/simple_instance[type = 'Dynamic_Application_Function_Implementation_Usage']"/>
	<xsl:variable name="feedInfoRepType" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Data Feed')]"/>
	<xsl:variable name="allDataReps" select="/node()/simple_instance[type = 'Data_Representation']"/>
	<xsl:variable name="allFeeds" select="$allInfoReps[own_slot_value[slot_reference = 'element_classified_by']/value = $feedInfoRepType/name]"/>
	<xsl:variable name="allApp2InfoRep2DataReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_TO_DATAREP_RELATION']"/>

	<xsl:variable name="overallPhysBusinessProcess" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="containedProcessSteps" select="/node()/simple_instance[name = $overallPhysBusinessProcess/own_slot_value[slot_reference = 'contained_physical_sub_processes']/value]"/>
	<xsl:variable name="containedProcessActor2Roles" select="/node()/simple_instance[name = $containedProcessSteps/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="containedActivityActor2Roles" select="/node()/simple_instance[name = $containedProcessSteps/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value]"/>
	<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name = $containedProcessActor2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="defined_activity_roles" select="/node()/simple_instance[name = $containedActivityActor2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="containedProcessAutoFuncs" select="$allAppFuncImpls[name = $containedProcessSteps/own_slot_value[slot_reference = 'physical_process_automated_by']/value]"/>
	<xsl:variable name="containedApps" select="$allApps[own_slot_value[slot_reference = 'provides_application_function_implementations']/value = $containedProcessAutoFuncs/name]"/>
	<!--<xsl:variable name="containedParentApps" select="$allApps[own_slot_value[slot_reference='contained_application_providers']/value = $containedApps/name]"/>
	<xsl:variable name="reportCreatingApps" select="$containedApps union $containedParentApps"/>-->

	<!-- Get any reports that are created by the parent process or contained steps -->
	<xsl:variable name="allRelevantProcesses" select="$overallPhysBusinessProcess union $containedProcessSteps"/>
	<xsl:variable name="allRelevantProcs2App2InfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value = $allRelevantProcesses/name]"/>
	<xsl:variable name="allRelevantApp2InfoReps" select="$allAppPro2InfoReps[name = $allRelevantProcs2App2InfoReps/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value]"/>
	<xsl:variable name="allRelevantInfoReps" select="$allInfoReps[name = $allRelevantApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>


	<!-- Get the downstream supporting applications for the workflow -->
	<xsl:variable name="busAppType" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Business User Application')]"/>
	<xsl:variable name="outboundAppFunc2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $containedProcessAutoFuncs/name) and (own_slot_value[slot_reference = 'app_pro_creates_info_rep']/value = 'Yes')]"/>
	<xsl:variable name="outboundInfoReps" select="$allInfoReps[name = $outboundAppFunc2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
	<xsl:variable name="consumingAppFunc2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value = $outboundInfoReps/name) and (own_slot_value[slot_reference = 'app_pro_reads_info_rep']/value = 'Yes')]"/>
	<xsl:variable name="consumingAppFuncImpls" select="$allAppFuncImpls[name = $consumingAppFunc2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
	<xsl:variable name="consumingApps" select="$allApps[own_slot_value[slot_reference = 'provides_application_function_implementations']/value = $consumingAppFuncImpls/name]"/>
	<xsl:variable name="downstreamApps" select="($consumingApps union $containedApps)"/>
	<xsl:variable name="downstreamParentApps" select="($allApps[own_slot_value[slot_reference = 'contained_application_providers']/value = $downstreamApps/name]) union $downstreamApps"/>
	<xsl:variable name="downstreamGrandParentApps" select="($allApps[own_slot_value[slot_reference = 'contained_application_providers']/value = $downstreamParentApps/name]) union $downstreamParentApps"/>
	<xsl:variable name="supportingApps" select="$downstreamGrandParentApps[(own_slot_value[slot_reference = 'element_classified_by']/value = $busAppType/name) and (not(name = $allApps/own_slot_value[slot_reference = 'contained_application_providers']/value))]"/>


	<!-- Get the upstream applications for the workflow -->
	<xsl:variable name="allRelevantInfoAtts" select="/node()/simple_instance[name = $allRelevantInfoReps/own_slot_value[slot_reference = 'contained_information_representation_attributes']/value]"/>
	<xsl:variable name="childDataRepAtts" select="/node()/simple_instance[name = $allRelevantInfoAtts/own_slot_value[slot_reference = 'infrep_att_derived_from_datarep_atts']/value]"/>
	<xsl:variable name="childDatabases" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_data_representation_attributes']/value = $childDataRepAtts/name]"/>
	<xsl:variable name="dependentApps" select="eas:get_relevant_upstream_apps($childDatabases, ())"/>
	<xsl:variable name="upstreamApps" select="$dependentApps[not(name = $supportingApps/name)]"/>


	<xsl:variable name="modelSubject" select="/node()/simple_instance[name = $overallPhysBusinessProcess/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="modelSubjectName" select="$modelSubject/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="overallProcessFlow" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
	<xsl:variable name="processFlowRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_process_flow']/value = $overallProcessFlow/name]"/>

	<!-- get the list of Business Process Usages in scope -->
	<xsl:variable name="processUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name]"/>

	<!-- get the trigger events for the process -->
	<xsl:variable name="triggerEventUsages" select="$processUsages[type = 'Initiating_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="triggerEvents" select="/node()/simple_instance[name = $triggerEventUsages/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value]"/>

	<!-- get the list of Business Processes in scope -->
	<xsl:variable name="business_processes" select="/node()/simple_instance[(name = $processUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $processUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<!-- get the list of Business Roles in scope -->
	<!--<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name=$business_processes/own_slot_value[slot_reference='business_process_performed_by_business_role']/value]"/>
	-->

	<xsl:variable name="pageTitle" select="concat('Business Workflow for ', $modelSubjectName)"/>

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
	<!--01.09.2011 NJW Updated to Support Viewer v3-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageTitle"/>
				</title>
				<script type="text/javascript" src="js/jquery.zoomable.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference = 'description']/value"/>

				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"> Business Workflow for </span>
										<span class="text-primary">
											<xsl:value-of select="$modelSubjectName"/>
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
								<xsl:value-of select="eas:i18n('Objective')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:value-of select="$modelSubjectDesc"/>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup UML Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Process Flow')"/>
							</h2>

							<div class="content-section">


								<!--script to support vertical alignment within named divs - requires jquery and verticalalign plugin-->
								<script type="text/javascript">
										$('document').ready(function(){
											 $(".umlCircleBadge").vAlign();
											 $(".umlCircleBadgeDescription").vAlign();
											 $(".umlKeyTitle").vAlign();
										});
									</script>


								<div id="keyContainer">
									<div class="keyLabel"><xsl:value-of select="eas:i18n('Key')"/>:</div>
									<div class="keySample bg-white"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Manual Process')"/>
									</div>
									<div class="keySample backColour16"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Automated Process')"/>
									</div>
								</div>

								<!--script required to zoom and drag images whilst scaling image maps-->
								<script type="text/javascript">
										$('document').ready(function(){
											$('.umlImage').zoomable();
										});
									</script>
								<div class="umlZoomContainer pull-right">
									<input type="button" value="Zoom In" onclick="$('#image').zoomable('zoomIn')" title="Zoom in"/>
									<input type="button" value="Zoom Out" onclick="$('#image').zoomable('zoomOut')" title="Zoom out"/>
									<input type="button" value="Reset" onclick="$('#image').zoomable('reset')"/>
								</div>
								<div class="clear"/>
								<div class="verticalSpacer_10px"/>
								<div class="umlModelViewport">
									<img class="umlImage" src="{$imageFilename}" usemap="#unix" id="image" alt="UML Model"/>

									<xsl:variable name="imageMapFile" select="concat('../', $imageMapPath)"/>
									<xsl:if test="unparsed-text-available($imageMapFile)">
										<xsl:value-of select="unparsed-text($imageMapFile)" disable-output-escaping="yes"/>
									</xsl:if>

								</div>
							</div>
							<hr/>
						</div>


						<!--Setup Process Steps Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-valuechain icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Workflow Steps')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($business_processes) > 0">
										<p>
											<xsl:value-of select="eas:i18n('The following workflow steps are defined for the')"/>&#160; <strong><xsl:value-of select="$modelSubjectName"/></strong>&#160; <xsl:value-of select="eas:i18n('business workflow')"/>. <div class="verticalSpacer_10px"/>
											<xsl:call-template name="ProcessSteps"/>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<em><xsl:value-of select="eas:i18n('No workflow steps defined for the')"/>&#160; <xsl:value-of select="$modelSubjectName"/>&#160; <xsl:value-of select="eas:i18n('workflow')"/></em>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>

							<hr/>
						</div>


						<!--Setup Actors Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Primary Business Actors')"/>
							</h2>
							<div class="content-section">
								<xsl:variable name="primaryActors" select="$defined_activity_roles union $defined_business_roles"/>
								<xsl:choose>
									<xsl:when test="count($primaryActors) > 0">
										<ul>
											<xsl:for-each select="$primaryActors">
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
										<em>
											<xsl:value-of select="eas:i18n('No actors captured for this workflow')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Reports Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Reports Produced')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allRelevantInfoReps) > 0">
										<table class="table table-bordered table-striped ">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Report Name')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="ReportOutputRow" select="$allRelevantInfoReps">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No reports have been captured for this workflow')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Upstream Systems Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-arrow-up icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Upstream Systems')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($upstreamApps) > 0">
										<table class="table table-bordered table-striped ">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Application Name')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:call-template name="PrintUpstreamApps">
													<xsl:with-param name="apps" select="$upstreamApps"/>
													<xsl:with-param name="printedApps" select="()"/>
												</xsl:call-template>
											</tbody>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No supporting systems identified for this workflow')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Downstream Systems Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-arrow-down icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Downstream Systems')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($supportingApps) > 0">
										<table class="table table-bordered table-striped ">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Application Name')"/>
													</th>
													<th class="cellWidth-70pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="SupportingSystemRow" select="$supportingApps">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No downstream systems identified for this workflow')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Triggers Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-flag icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Triggers')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($triggerEvents) > 0">
										<ul>
											<xsl:for-each select="$triggerEvents">
												<li>
													<strong>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="current()"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template></strong> - <xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('No triggers captured for this workflow')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
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

	<xsl:template name="ProcessSteps">

		<table class="table table-bordered table-striped ">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Workflow Step')"/>
					</th>
					<th class="cellWidth-40pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Performing Roles/Automating System')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="ProcessStepRow" select="$business_processes">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>


	<xsl:template mode="ReportOutputRow" match="node()">

		<xsl:variable name="infoDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($infoDesc) > 0">
						<xsl:value-of select="$infoDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>


	<xsl:template mode="SupportingSystemRow" match="node()">

		<xsl:variable name="appDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($appDesc) > 0">
						<xsl:value-of select="$appDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>


	<xsl:template mode="ProcessStepRow" match="node()">
		<xsl:variable name="currentStep" select="current()"/>
		<xsl:variable name="physProcSlot">
			<xsl:choose>
				<xsl:when test="$currentStep/type = 'Business_Process'">implements_business_process</xsl:when>
				<xsl:when test="$currentStep/type = 'Business_Activity'">instance_of_business_activity</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="physProc" select="$containedProcessSteps[own_slot_value[slot_reference = $physProcSlot]/value = $currentStep/name]"/>

		<!--<xsl:variable name="relevantRoles" select="$defined_business_roles[name = current()/own_slot_value[slot_reference='business_process_performed_by_business_role']/value]"/>-->
		<xsl:variable name="stepName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="stepDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($stepDesc) > 0">
						<xsl:value-of select="$stepDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:variable name="physProcActorSlot">
					<xsl:choose>
						<xsl:when test="$currentStep/type = 'Business_Process'">process_performed_by_actor_role</xsl:when>
						<xsl:when test="$currentStep/type = 'Business_Activity'">activity_performed_by_actor_role</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="(count($physProc/own_slot_value[slot_reference = 'physical_process_automated_by']/value) = 0) and count($physProc/own_slot_value[slot_reference = $physProcActorSlot]/value) = 0">-</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="PhysicalProcessActor">
							<xsl:with-param name="physProc" select="$physProc"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="PhysicalProcessActor">
		<xsl:param name="physProc"/>

		<xsl:variable name="automatingFunction" select="$containedProcessAutoFuncs[name = $physProc/own_slot_value[slot_reference = 'physical_process_automated_by']/value]"/>
		<xsl:choose>
			<xsl:when test="count($automatingFunction) > 0">
				<xsl:variable name="automatingApp" select="$allApps[own_slot_value[slot_reference = 'provides_application_function_implementations']/value = $automatingFunction[1]/name]"/>
				<xsl:variable name="parentApp" select="$allApps[own_slot_value[slot_reference = 'contained_application_providers']/value = $automatingApp/name]"/>
				<xsl:choose>
					<xsl:when test="count($parentApp) > 0">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$parentApp"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$automatingApp"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$physProc/type = 'Physical_Process'">
						<xsl:variable name="procActor2Role" select="$containedProcessActor2Roles[name = $physProc/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
						<xsl:variable name="procRole" select="$defined_business_roles[name = $procActor2Role/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$procRole"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$physProc/type = 'Physical_Activity'">
						<xsl:variable name="activityActor2Role" select="$containedActivityActor2Roles[name = $physProc/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value]"/>
						<xsl:variable name="activityRole" select="$defined_activity_roles[name = $activityActor2Role/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$activityRole"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- FUNCTION TO RECURSIVELY RETRIEVE THE SET OF RELEVANT FEEDS (INFOREPS) -->
	<xsl:function name="eas:get_relevant_upstream_apps" as="node()*">
		<xsl:param name="sourceDatabases"/>
		<xsl:param name="foundApps"/>

		<xsl:for-each select="$sourceDatabases">
			<xsl:variable name="appFunc2InfoRep2DataReps" select="$allApp2InfoRep2DataReps[(own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value = current()/name) and (own_slot_value[slot_reference = 'app_pro_updates_data_rep']/value = 'Yes')]"/>
			<xsl:variable name="managingAppFunc2InfoRep" select="$allAppPro2InfoReps[name = $appFunc2InfoRep2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value]"/>
			<xsl:variable name="childAppFuncImpls" select="$allAppFuncImpls[name = $managingAppFunc2InfoRep/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>

			<xsl:for-each select="$childAppFuncImpls">
				<!--<xsl:variable name="newDatabases" select="eas:get_relevant_database_for_func(current(), $sourceDatabases)"/>
					<xsl:sequence select="$newDatabases[not(name = $sourceDatabases/name)]"/>-->
				<xsl:copy-of select="eas:get_relevant_upstream_apps_for_func(current(), $foundApps)"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:function>


	<!-- FUNCTION TO RECURSIVELY RETRIEVE A SET OF FEEDS ACCESSED BY A FUNCTION -->
	<xsl:function name="eas:get_relevant_upstream_apps_for_func" as="node()*">
		<xsl:param name="appFuncImpl"/>
		<xsl:param name="foundApps"/>

		<!-- Get any tables or feeds that are read by the function -->
		<xsl:variable name="managedAppFunc2InfoRep" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $appFuncImpl/name]"/>
		<xsl:variable name="managedFeeds" select="$allFeeds[name = $managedAppFunc2InfoRep/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
		<xsl:variable name="managedAppFunc2InfoRep2DataReps" select="$allApp2InfoRep2DataReps[(own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value = $managedAppFunc2InfoRep/name) and (own_slot_value[slot_reference = 'app_pro_reads_data_rep']/value = 'Yes')]"/>
		<xsl:variable name="relevantDataReps" select="$allDataReps[name = $managedAppFunc2InfoRep2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>

		<!-- Get any other functions that this function is dependent upon -->
		<xsl:variable name="parentFuncImplArch" select="$allDynamicAppArchs[name = $appFuncImpl/own_slot_value[slot_reference = 'application_function_impl_architecture']/value]"/>
		<xsl:variable name="parentFuncImplUsages" select="$allDynamicAppArchFuncUsages[own_slot_value[slot_reference = 'usage_of_application_function_implementation']/value = $appFuncImpl/name]"/>
		<xsl:variable name="dependentAppFuncImplUsages" select="$allDynamicAppArchFuncUsages[(name = $parentFuncImplArch/own_slot_value[slot_reference = 'app_funcImp_architecture_components']/value) and not(name = $parentFuncImplUsages/name)]"/>
		<xsl:variable name="dependentAppFuncImpls" select="$allAppFuncImpls[name = $dependentAppFuncImplUsages/own_slot_value[slot_reference = 'usage_of_application_function_implementation']/value]"/>

		<!-- Get the functons/applications that created the feeds -->
		<xsl:variable name="feedApp2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value = $managedFeeds/name) and (own_slot_value[slot_reference = 'app_pro_creates_info_rep']/value = 'Yes')]"/>
		<xsl:variable name="feedApps" select="$allApps[(name = $feedApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value)]"/>
		<!--<xsl:variable name="feedApps" select="$allApps[own_slot_value[slot_reference='provides_application_function_implementations']/value = $feedAppFuncImpls/name]"/>-->

		<xsl:variable name="newFoundApps" select="$feedApps[not(name = $foundApps/name)]"/>
		<xsl:copy-of select="$newFoundApps"/>

		<xsl:for-each select="$relevantDataReps">
			<xsl:copy-of select="eas:get_relevant_upstream_apps(current(), ($foundApps union $newFoundApps))"/>
		</xsl:for-each>
		<xsl:for-each select="$dependentAppFuncImpls">
			<xsl:copy-of select="eas:get_relevant_upstream_apps_for_func(current(), ($foundApps union $newFoundApps))"/>
		</xsl:for-each>
	</xsl:function>


	<!-- TEMPLATE TO RECURSIVELY PRINT TABLE ROWS FOR A LIST OF UPSTREAM APPS WITH POTENTIAL DUPLICATES -->
	<xsl:template name="PrintUpstreamApps" as="node()*">
		<xsl:param name="apps"/>
		<xsl:param name="printedApps"/>

		<xsl:choose>
			<xsl:when test="count($apps) > 0">
				<xsl:variable name="nextApp" select="$apps[1]"/>
				<xsl:if test="not($nextApp/name = $printedApps/name)">
					<tr>
						<td>
							<strong>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$nextApp"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</strong>
						</td>
						<td>
							<xsl:value-of select="$nextApp/own_slot_value[slot_reference = 'description']/value"/>
						</td>
					</tr>

				</xsl:if>
				<xsl:variable name="newAppList" select="$apps except $nextApp"/>
				<xsl:variable name="newPrintedApps" select="$printedApps union $nextApp"/>
				<xsl:call-template name="PrintUpstreamApps">
					<xsl:with-param name="apps" select="$newAppList"/>
					<xsl:with-param name="printedApps" select="$newPrintedApps"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
