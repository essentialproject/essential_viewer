<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" use-character-maps="c-1replace"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function', 'Application_Function_Implementation', 'Enterprise_Strategic_Plan', 'Information_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="currentApp" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="allEnums" select="/node()/simple_instance[supertype = 'Enumeration']"/>

	<xsl:variable name="allAppPurpose" select="$allEnums[type = 'Application_Purpose']"/>
	<xsl:variable name="allAppFamilies" select="/node()/simple_instance[type = 'Application_Family']"/>
	<xsl:variable name="allLifecycleStatus" select="$allEnums[type = 'Lifecycle_Status']"/>
	<xsl:variable name="allAppSvcs" select="/node()/simple_instance[type = 'Application_Service' or supertype = 'Application_Service']"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type = 'Application_Provider_Role' and own_slot_value[slot_reference = 'role_for_application_provider']/value = $param1]"/>

	<xsl:variable name="allAppPros" select="/node()/simple_instance[type = 'Application_Provider' or supertype = 'Application_Provider']"/>
	<xsl:variable name="allContainedApps" select="$allAppPros[name = $currentApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>

	<xsl:variable name="allAppFuncs" select="/node()/simple_instance[type = 'Application_Function']"/>
	<xsl:variable name="allAppFuncImpls" select="/node()/simple_instance[type = 'Application_Function_Implementation']"/>
	<xsl:variable name="appAFIs" select="$allAppFuncImpls[name = $currentApp/own_slot_value[slot_reference = 'provides_application_function_implementations']/value]"/>
	<xsl:variable name="appFuncs" select="$allAppFuncs[name = $appAFIs/own_slot_value[slot_reference = 'implements_application_function']/value]"/>
	<xsl:variable name="allSoftwareComps" select="/node()/simple_instance[type = 'Software_Component']"/>
	<xsl:variable name="appSW" select="$allSoftwareComps[name = $appAFIs/own_slot_value[slot_reference = 'inverse_of_delivers_app_func_impl']/value]"/>

	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $currentApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

	<xsl:variable name="allPhysicalProcs" select="/node()/simple_instance[supertype = 'Physical_Process_Type']"/>
	<xsl:variable name="allPhysicalProcRels" select="/node()/simple_instance[name = $allAppProRoles/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value]"/>
	<xsl:variable name="supportedProcs" select="$allPhysicalProcs[name = $allPhysicalProcRels/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
	<xsl:variable name="supportedLogProcs" select="/node()/simple_instance[name = $supportedProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="supportedBus" select="/node()/simple_instance[name = $supportedProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="supoprtedProcActors" select="/node()/simple_instance[name = $supportedBus/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>

	<xsl:variable name="allStrategicPlans" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $param1]"/>

	<xsl:variable name="allDelModels" select="$allEnums[type = 'Application_Delivery_Model']"/>

	<xsl:variable name="allIssues" select="/node()/simple_instance[(type = 'Issue') and (own_slot_value[slot_reference = 'related_application_elements']/value = $param1)]"/>

	<xsl:variable name="allRegCompRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'regulated_component_to_element']/value = $param1]"/>
	<xsl:variable name="allRegulations" select="/node()/simple_instance[type = 'Regulation']"/>
	<xsl:variable name="relevantRegs" select="$allRegulations[name = $allRegCompRels/own_slot_value[slot_reference = 'regulated_component_regulation']/value]"/>
	<xsl:variable name="allRegBodies" select="/node()/simple_instance[name = $relevantRegs/own_slot_value[slot_reference = 'regulation_regulatory_body']/value]"/>

	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'application_provider_deployed']/value = $param1]"/>

	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="allTechBuilds" select="/node()/simple_instance[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
	<xsl:variable name="allTechBuildArchs" select="/node()/simple_instance[name = $allTechBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
	<xsl:variable name="allTechProRoles" select="/node()/simple_instance[supertype = 'Technology_Provider_Role']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component' or supertype = 'Technology_Composite']"/>
	<xsl:variable name="allTechProvs" select="/node()/simple_instance[supertype = 'Technology_Provider']"/>
	<xsl:variable name="allTechProvRoleUsages" select="/node()/simple_instance[(name = $allTechBuildArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value) and (type = 'Technology_Provider_Usage')]"/>
	<xsl:variable name="allTechProdArchRelations" select="/node()/simple_instance[(type = ':TPU-TO-TPU-RELATION') and (name = $allTechBuildArchs/own_slot_value[slot_reference = 'contained_provider_architecture_relations']/value)]"/>

	<xsl:variable name="appTechProvRoles" select="$allTechProRoles[name = $allTechProvRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
	<xsl:variable name="appTechProvs" select="$allTechProvs[name = $appTechProvRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="appTechComps" select="$allTechComps[name = $appTechProvRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>

	<xsl:variable name="allExternalRefs" select="/node()/simple_instance[name = $currentApp/own_slot_value[slot_reference = 'external_reference_links']/value]"/>

	<xsl:variable name="allInfoRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $param1]"/>
	<xsl:variable name="allDatabases" select="$allInfoRels[own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true']"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[name = $allDatabases/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
	<xsl:variable name="allDBTech" select="$allTechProRoles[name = $allInfoReps/own_slot_value[slot_reference = 'representation_technology']/value]"/>
	<xsl:variable name="allInfoRepStakeholders" select="/node()/simple_instance[$allInfoReps/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allDBActors" select="/node()/simple_instance[name = $allInfoRepStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allDBRoles" select="/node()/simple_instance[name = $allInfoRepStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>


	<xsl:variable name="anyReports" select="/node()/simple_instance[(type = 'Report')]"/>
	<xsl:variable name="appDependencyView" select="$anyReports[own_slot_value[slot_reference = 'name']/value = 'Core: Application Information Dependency Model']"/>
	<xsl:variable name="appDeploymentView" select="$anyReports[own_slot_value[slot_reference = 'name']/value = 'Core: Application Deployment Summary']"/>
	<xsl:variable name="stratPlanSummary" select="$anyReports[own_slot_value[slot_reference = 'name']/value = 'Core: Strategic Plan Summary']"/>

	<xsl:variable name="appNoOfUsers" select="$currentApp/own_slot_value[slot_reference = 'ap_max_number_of_users']/value"/>
    <xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $currentApp/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
    <xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>

	<xsl:variable name="objectWidth" select="240"/>
	<xsl:variable name="objectHeight" select="100"/>
	<xsl:variable name="objectTextWidth" select="160"/>
	<xsl:variable name="objectTextHeight" select="100"/>
	<xsl:variable name="objectSubBlockWidth" select="35"/>
	<xsl:variable name="objectSubBlockHeight" select="23"/>
	<xsl:variable name="objectSubBlockXPos" select="0"/>
	<xsl:variable name="objectSubBlockYPos" select="77"/>
	<xsl:variable name="objectStrokeWidth" select="1"/>

	<xsl:variable name="noStatusColour">Grey</xsl:variable>
	<xsl:variable name="noStatusStyle">backColourGrey</xsl:variable>
	<xsl:variable name="objectColour">hsla(220, 70%, 95%, 1)</xsl:variable>
	<xsl:variable name="objectTextColour">Black</xsl:variable>
	<xsl:variable name="objectOutlineColour">Black</xsl:variable>

	<xsl:variable name="techProdSummaryReport" select="eas:get_report_by_name('Core: Technology Product Summary')"/>

	<!-- End VIEW SPECIFIC SETUP VARIABES -->

	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
				<title>
					<xsl:value-of select="eas:i18n('Application Provider Summary')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>
				<script src="js/lodash/index.js"/>
				<script src="js/backbone/backbone.js"/>
				<script src="js/graphlib/graphlib.core.js"/>
				<script src="js/dagre/dagre.core.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/jquery-ui.js" async="" type="text/javascript"/>
				<script src="js/jointjs/ga.js" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.js"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Application Provider Summary')"/>
									</span>
									<span>&#160;</span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('for')"/>
									</span>
									<span>&#160;</span>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
										<xsl:with-param name="anchorClass" select="'text-primary'"/>
									</xsl:call-template>
									<!--<span class="text-primary">
										<xsl:value-of select="eas:i18n($currentApp/own_slot_value[slot_reference = 'name']/value)"/>
									</span>-->
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Description')"/>
								</h2>
							</div>
							<div class="content-section">
								<p>
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Purpose Section-->
						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-info-circle icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Application Purpose')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="appPurpose" select="$allAppPurpose[name = $currentApp/own_slot_value[slot_reference = 'application_provider_purpose']/value]"/>
								<xsl:choose>
									<xsl:when test="count($appPurpose) = 0">
										<span>-</span>
									</xsl:when>
									<xsl:when test="count($appPurpose) = 1">
										<p>
											<xsl:value-of select="$appPurpose/own_slot_value[slot_reference = 'enumeration_value']/value"/>
										</p>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$appPurpose">
												<li>
													<xsl:value-of select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Family Section-->
						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Application Family')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="appType" select="$allAppFamilies[name = $currentApp/own_slot_value[slot_reference = 'type_of_application']/value]"/>
								<xsl:choose>
									<xsl:when test="count($appType) = 0">
										<span>-</span>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<xsl:value-of select="$appType/own_slot_value[slot_reference = 'name']/value"/>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<div class="clearfix"/>

						<!--Setup Lifecycle Section-->
						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-clock-o icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Lifecycle')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="appLifecycle" select="$allLifecycleStatus[name = $currentApp/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]"/>
								<xsl:choose>
									<xsl:when test="count($appLifecycle) = 0">
										<span>-</span>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<xsl:value-of select="$appLifecycle/own_slot_value[slot_reference = 'enumeration_value']/value"/>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Supplier Section-->
						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-building-o icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Supplier')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="supplier" select="$allSuppliers[name = $currentApp/own_slot_value[slot_reference = 'ap_supplier']/value]"/>
								<xsl:choose>
									<xsl:when test="count($supplier) = 0">
										<span>-</span>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$supplier"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<div class="clearfix"/>

						<!--Setup the Codebase section-->

						<div class="col-xs-12 col-md-6">
							<div class="sectionIcon">
								<i class="fa fa-code icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Codebase</h2>
							<xsl:variable name="codebase" select="/node()/simple_instance[name = $currentApp/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
							<div class="content-section">
								<p>
									<xsl:if test="count($codebase) = 0">
										<span>-</span>
									</xsl:if>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$codebase"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup ServiceDelivery Section-->
						<div class="col-xs-12 col-md-6">
							<div class="sectionIcon">
								<i class="fa fa-truck icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Delivery Model')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="aDelModel" select="$allDelModels[name = $currentApp/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
								<p>
									<xsl:if test="count($aDelModel) = 0">
										<span>-</span>
									</xsl:if>
									<xsl:value-of select="$aDelModel/own_slot_value[slot_reference = 'enumeration_value']/value"/>
								</p>
							</div>
							<hr/>
						</div>

						<div class="clearfix"/>

						<!--Setup the Application Services section-->

						<div class="col-xs-6">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Services')"/>
							</h2>
							<xsl:variable name="appProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = $currentApp/name]"/>
							<xsl:variable name="services" select="/node()/simple_instance[name = $appProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
							<xsl:if test="count($services) = 0">-</xsl:if>
							<div class="content-section">
								<ul>
									<xsl:for-each select="$services">
										<xsl:variable name="asName" select="own_slot_value[slot_reference = 'name']/value"/>
										<li>
											<xsl:call-template name="GenericInstanceLink">
												<xsl:with-param name="instance" select="current()"/>
												<xsl:with-param name="theViewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</div>
							<hr/>
						</div>
                        <!-- Application Costs  -->
       
                                
                                <xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($inScopeCostComponents, 0)"/>
                                
                        <div class="col-xs-6">
							<div class="sectionIcon">
								<i class="fa fa-pie-chart icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Cost')"/>
							</h2>
							<div class="content-section">
                                <xsl:choose><xsl:when test="$costTypeTotal=0"> -</xsl:when><xsl:otherwise><xsl:value-of select="$currency"/>  <xsl:value-of select="format-number($costTypeTotal, '###,###,###')"/></xsl:otherwise></xsl:choose>
                             
							</div>
							<hr/>
						</div>      
						<!--Setup the Contained Application Providers section-->
						<xsl:if test="count($allContainedApps) &gt; 0">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
								</div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Contained Application Providers')"/>
								</h2>
								<div class="content-section">
									<script>
									$(document).ready(function(){
										// Setup - add a text input to each footer cell
									    $('#dt_containedApps tfoot th').each( function () {
									        var title = $(this).text();
									        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
									    } );
										
										var table = $('#dt_containedApps').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										paging: false,
										info: false,
										sort: true,
										responsive: true,
										columns: [
										    { "width": "30%" },
										    { "width": "70%" }										    
										  ],
										dom: 'Bfrtip',
									    buttons: [
								            'copyHtml5', 
								            'excelHtml5',
								            'csvHtml5',
								            'pdfHtml5',
								            'print'
								        ]
										});
										
										
										// Apply the search
									    table.columns().every( function () {
									        var that = this;
									 
									        $( 'input', this.footer() ).on( 'keyup change', function () {
									            if ( that.search() !== this.value ) {
									                that
									                    .search( this.value )
									                    .draw();
									            }
									        } );
									    } );
									    
									    table.columns.adjust();
									    
									    $(window).resize( function () {
									        table.columns.adjust();
									    });
									});
								</script>
									<table class="table table-striped table-bordered" id="dt_containedApps">
										<thead>
											<tr>
												<th>
													<xsl:value-of select="eas:i18n('Contained Application Provider')"/>
												</th>
												<th>
													<xsl:value-of select="eas:i18n('Description')"/>
												</th>
											</tr>
										</thead>
										<tbody>
											<xsl:for-each select="$allContainedApps">
												<xsl:variable name="aDesc" select="$allContainedApps[name = current()/own_slot_value[slot_reference = 'description']/value]"/>
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
										<tfoot>
											<tr>
												<th>
													<xsl:value-of select="eas:i18n('Application Provider')"/>
												</th>
												<th>
													<xsl:value-of select="eas:i18n('Description')"/>
												</th>
											</tr>
										</tfoot>
									</table>
								</div>
								<hr/>
							</div>
						</xsl:if>

						<!--Setup Functions Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-connections icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Implemented Functions')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($appAFIs) &gt; 0">
										<script>
									$(document).ready(function(){
										// Setup - add a text input to each footer cell
									    $('#dt_functions tfoot th').each( function () {
									        var title = $(this).text();
									        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
									    } );
										
										var table = $('#dt_functions').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										paging: false,
										info: false,
										sort: true,
										responsive: true,
										columns: [
										    { "width": "30%" },
										    { "width": "20%" },
										    { "width": "20%" },
										    { "width": "30%" }
										  ],
										dom: 'Bfrtip',
									    buttons: [
								            'copyHtml5', 
								            'excelHtml5',
								            'csvHtml5',
								            'pdfHtml5',
								            'print'
								        ]
										});
										
										
										// Apply the search
									    table.columns().every( function () {
									        var that = this;
									 
									        $( 'input', this.footer() ).on( 'keyup change', function () {
									            if ( that.search() !== this.value ) {
									                that
									                    .search( this.value )
									                    .draw();
									            }
									        } );
									    } );
									    
									    table.columns.adjust();
									    
									    $(window).resize( function () {
									        table.columns.adjust();
									    });
									});
								</script>
										<table class="table table-striped table-bordered" id="dt_functions">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Application Service')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Function Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technical Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Supporting Software Component')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$appAFIs">
													<xsl:variable name="aFunc" select="$appFuncs[name = current()/own_slot_value[slot_reference = 'implements_application_function']/value]"/>
													<xsl:variable name="aSvc" select="$allAppSvcs[own_slot_value[slot_reference = 'provides_application_functions']/value = $aFunc/name]"/>
													<xsl:variable name="aSoftwareComp" select="$appSW[name = current()/own_slot_value[slot_reference = 'inverse_of_delivers_app_func_impl']/value]"/>
													<tr>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aSvc"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aFunc"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="displayString" select="own_slot_value[slot_reference = 'app_func_impl_name']/value"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aSoftwareComp"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
													</tr>
												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Application Service')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Function Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technical Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Supporting Software Component')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>

						<!--Setup Stakeholders Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Roles and People')"/>
								</h2>
								<xsl:if test="string-length($appNoOfUsers) > 0">
									<p>The <xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$currentApp"/></xsl:call-template> application has up to <strong><xsl:value-of select="$appNoOfUsers"/></strong> users.</p>
								</xsl:if>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allStakeholders) &gt; 0">
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_stakeholders tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_stakeholders').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "30%" },
											    { "width": "30%" },
											    { "width": "40%" }
											  ],
											dom: 'Bfrtip',
										    buttons: [
									            'copyHtml5', 
									            'excelHtml5',
									            'csvHtml5',
									            'pdfHtml5',
									            'print'
									        ]
											});
											
											
											// Apply the search
										    table.columns().every( function () {
										        var that = this;
										 
										        $( 'input', this.footer() ).on( 'keyup change', function () {
										            if ( that.search() !== this.value ) {
										                that
										                    .search( this.value )
										                    .draw();
										            }
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
										        table.columns.adjust();
										    });
										});
									</script>
										<table class="table table-striped table-bordered" id="dt_stakeholders">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													<th class="cellWidth-40pc">
														<xsl:value-of select="eas:i18n('Email')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$allStakeholders">
													<xsl:variable name="actor" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
													<xsl:variable name="role" select="$allRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
													<xsl:variable name="email" select="$actor/own_slot_value[slot_reference = 'email']/value"/>
													<tr>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$role"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$actor"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:value-of select="$email"/>
														</td>
													</tr>
												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Person or Organisation')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Email')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>

						<!--Setup PhysProcesses Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-valuechain icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Supported Physical Processes')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allPhysicalProcRels) &gt; 0">
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_supportedprocesses tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_supportedprocesses').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "40%" },
											    { "width": "15%" },
											    { "width": "15%" },
											    { "width": "15%" },
											    { "width": "15%" }
											  ],
											dom: 'Bfrtip',
										    buttons: [
									            'copyHtml5', 
									            'excelHtml5',
									            'csvHtml5',
									            'pdfHtml5',
									            'print'
									        ]
											});
											
											
											// Apply the search
										    table.columns().every( function () {
										        var that = this;
										 
										        $( 'input', this.footer() ).on( 'keyup change', function () {
										            if ( that.search() !== this.value ) {
										                that
										                    .search( this.value )
										                    .draw();
										            }
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
									        	table.columns.adjust();
										    });
										});
									</script>
										<table id="dt_supportedprocesses" class="table table-striped table-bordered">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Supported Processes')"/>
													</th>
                                                    <th>
														<xsl:value-of select="eas:i18n('Application Service Used')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Business Units Supported')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('User Locations')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$allPhysicalProcRels">
													<xsl:variable name="aPhysProc" select="$supportedProcs[name = current()/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
													<xsl:variable name="aLogProc" select="$supportedLogProcs[name = $aPhysProc/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
                                                    <xsl:variable name="aServiceRel" select="$allAppProRoles[name = current()/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
                                                    <xsl:variable name="aService" select="$allAppSvcs[name = $aServiceRel/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
                                                   
													<xsl:variable name="aUnitRole" select="$supportedBus[name = $aPhysProc/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
													<xsl:variable name="aUnit" select="$supoprtedProcActors[name = $aUnitRole/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
													<xsl:variable name="aLocationList" select="$allSites[name = $aPhysProc/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
													<xsl:variable name="aCriticality" select="$allEnums[name = current()/own_slot_value[slot_reference = 'app_to_process_business_criticality']/value]"/>
													<tr>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aLogProc"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
                                                        <td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aService"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aUnit"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:value-of select="$aCriticality/own_slot_value[slot_reference = 'enumeration_value']/value"/>
														</td>
														<td>
															<xsl:choose>
																<xsl:when test="count($aLocationList) = 0">-</xsl:when>
																<xsl:otherwise>
																	<ul>
																		<xsl:for-each select="$aLocationList">
																			<li>
																				<xsl:call-template name="RenderInstanceLink">
																					<xsl:with-param name="theSubjectInstance" select="current()"/>
																					<xsl:with-param name="theXML" select="$reposXML"/>
																					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																				</xsl:call-template>
																			</li>
																		</xsl:for-each>
																	</ul>
																</xsl:otherwise>
															</xsl:choose>

														</td>
													</tr>

												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Supported Processes')"/>
													</th>
                                                    <th>
														<xsl:value-of select="eas:i18n('Application Service Used')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Business Units Supported')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('User Locations')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>


						<!-- Setup the related issues table -->
						<xsl:call-template name="RenderIssuesTable">
							<xsl:with-param name="relatedElement" select="$currentApp"/>
						</xsl:call-template>


						<!--Setup AppDependencies Section-->
						<!--<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Application Dependencies')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="linkText" select="$appDependencyView/own_slot_value[slot_reference = 'report_history_label']/value"/>
								<xsl:variable name="reportFilename" select="$appDependencyView/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
								<xsl:variable name="linkURL">
									<xsl:call-template name="RenderLinkText">
										<xsl:with-param name="theXSL" select="$reportFilename"/>
										<xsl:with-param name="theXML">
											<xsl:value-of select="$reposXML"/>
										</xsl:with-param>
										<xsl:with-param name="theInstanceID" select="$param1"/>
										<xsl:with-param name="theHistoryLabel" select="escape-html-uri($linkText)"/>
									</xsl:call-template>
								</xsl:variable>
								<p>
									<a>
										<xsl:attribute name="href" select="$linkURL"/>
										<xsl:value-of select="eas:i18n('Click here')"/>
									</a>
									<xsl:text> </xsl:text>
									<xsl:value-of select="eas:i18n('to view the Application Dependencies for')"/>
									<strong>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
									</strong>
								</p>
							</div>
							<hr/>
						</div>-->

						<!--Setup DBDependencies Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-database icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Database Dependencies')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allDatabases) &gt; 0">
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_database tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_database').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "30%" },
											    { "width": "30%" },
											    { "width": "40%" }
											  ],
											dom: 'Bfrtip',
										    buttons: [
									            'copyHtml5', 
									            'excelHtml5',
									            'csvHtml5',
									            'pdfHtml5',
									            'print'
									        ]
											});
											
											
											// Apply the search
										    table.columns().every( function () {
										        var that = this;
										 
										        $( 'input', this.footer() ).on( 'keyup change', function () {
										            if ( that.search() !== this.value ) {
										                that
										                    .search( this.value )
										                    .draw();
										            }
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
									        	table.columns.adjust();
									    	});
										});
									</script>
										<table class="table table-striped table-bordered" id="dt_database">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Database Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technology Platform')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Stakeholders')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$allDatabases">
													<xsl:variable name="aDB" select="$allInfoReps[name = current()/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
													<xsl:variable name="aDBTech" select="$allDBTech[name = $aDB/own_slot_value[slot_reference = 'representation_technology']/value]"/>
													<xsl:variable name="aTechProv" select="$allTechProvs[name = $aDBTech/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
													<xsl:variable name="aStakeholderList" select="$allInfoRepStakeholders[name = $aDB/own_slot_value[slot_reference = 'stakeholders']/value]"/>
													<tr>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aDB"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$aTechProv"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:choose>
																<xsl:when test="count($aStakeholderList) = 0">-</xsl:when>
																<xsl:otherwise>
																	<ul>
																		<xsl:for-each select="$aStakeholderList">
																			<xsl:variable name="actor" select="$allDBActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
																			<xsl:variable name="role" select="$allDBRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
																			<li>
																				<xsl:call-template name="RenderInstanceLink">
																					<xsl:with-param name="theSubjectInstance" select="$actor"/>
																					<xsl:with-param name="theXML" select="$reposXML"/>
																					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																				</xsl:call-template>
																				<xsl:text> (</xsl:text>
																				<xsl:call-template name="RenderInstanceLink">
																					<xsl:with-param name="theSubjectInstance" select="$role"/>
																					<xsl:with-param name="theXML" select="$reposXML"/>
																					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																				</xsl:call-template>
																				<xsl:text>)</xsl:text>
																			</li>
																		</xsl:for-each>
																	</ul>
																</xsl:otherwise>
															</xsl:choose>
														</td>
													</tr>
												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Database Name')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technology Platform')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Stakeholders')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>

						<!--Setup StratPlans Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Strategic Plans')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:apply-templates select="$currentApp" mode="StrategicPlansForElement"/>
							</div>
							<hr/>
						</div>




						<!--Setup Issues Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-warning icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Issues')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allIssues) &gt; 0">
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_issues tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_issues').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "30%" },
											    { "width": "30%" },
											    { "width": "40%" }
											  ],
											dom: 'Bfrtip',
										    buttons: [
									            'copyHtml5', 
									            'excelHtml5',
									            'csvHtml5',
									            'pdfHtml5',
									            'print'
									        ]
											});
											
											
											// Apply the search
										    table.columns().every( function () {
										        var that = this;
										 
										        $( 'input', this.footer() ).on( 'keyup change', function () {
										            if ( that.search() !== this.value ) {
										                that
										                    .search( this.value )
										                    .draw();
										            }
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
										        table.columns.adjust();
										    });
										});
									</script>
										<table class="table table-striped table-bordered" id="dt_issues">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Issue')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Business Priority')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$allIssues">
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
														<td>
															<xsl:value-of select="own_slot_value[slot_reference = 'issue_priority']/value"/>
														</td>
													</tr>
												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Issue')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Business Priority')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>

						<!--Setup Regulations Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check-circle icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Applicable Regulations')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($relevantRegs) &gt; 0">
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_regulations tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_regulations').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "30%" },
											    { "width": "40%" },
											    { "width": "30%" }
											  ],
											dom: 'Bfrtip',
										    buttons: [
									            'copyHtml5', 
									            'excelHtml5',
									            'csvHtml5',
									            'pdfHtml5',
									            'print'
									        ]
											});
											
											
											// Apply the search
										    table.columns().every( function () {
										        var that = this;
										 
										        $( 'input', this.footer() ).on( 'keyup change', function () {
										            if ( that.search() !== this.value ) {
										                that
										                    .search( this.value )
										                    .draw();
										            }
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
										        table.columns.adjust();
										    });
										});
									</script>
										<table class="table table-striped table-bordered" id="dt_regulations">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Regulation')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Regulatory Body')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$relevantRegs">
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
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$allRegBodies[name = current()/own_slot_value[slot_reference = 'regulation_regulatory_body']/value]"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
															</xsl:call-template>
														</td>
													</tr>
												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Regulation')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Regulatory Body')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>


						<!--Setup SupportingTechBuilds Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Supporting Technology Builds')"/>
								</h2>
							</div>

							<div class="content-section">
								<script>
									// Create a custom element.
									// ------------------------
									joint.shapes.custom = {};
									joint.shapes.custom.Cluster = joint.shapes.basic.Rect.extend({
										markup: '<g class="rotatable"><g class="scalable"><rect/></g><a><text/></a></g>',
									    defaults: joint.util.deepSupplement({
									        type: 'custom.Cluster',
									        attrs: {
									            rect: { fill: '#E67E22', stroke: '#D35400', 'stroke-width': 5 },
									            text: { 
									            	fill: 'white',
									            	'ref-x': .5,
						                        	'ref-y': .4
									            }
									        }
									    }, joint.shapes.basic.Rect.prototype.defaults)
									});
									
									
									function wrapClusterName(nameText) {
										return joint.util.breakText(nameText, {
										    width: <xsl:value-of select="$objectTextWidth"/>,
										    height: <xsl:value-of select="$objectTextHeight"/>
										});
									}
									
									function wrapElementName(nameText) {
										return joint.util.breakText(nameText, {
										    width: 80,
										    height: 80
										});
									}
								</script>
								<!-- Nav tabs -->
								<ul class="nav nav-tabs" role="tablist">
									<xsl:for-each select="$allAppDeployments">
										<xsl:variable name="appDepIndex" select="position()"/>
										<xsl:variable name="currentAppDep" select="current()"/>
										<xsl:variable name="thisDepRole" select="$allEnums[name = $currentAppDep/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
										<xsl:variable name="appDepID">
											<xsl:value-of select="concat('appDep', index-of($allAppDeployments, $currentAppDep))"/>
										</xsl:variable>
										<li role="presentation">
											<xsl:if test="$appDepIndex = 1">
												<xsl:attribute name="class">active</xsl:attribute>
											</xsl:if>
											<a role="tab" data-toggle="tab">
												<xsl:attribute name="href" select="concat('#', $appDepID)"/>
												<xsl:attribute name="aria-controls" select="$appDepID"/>
												<xsl:value-of select="$thisDepRole/own_slot_value[slot_reference = 'enumeration_value']/value"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>

								<!-- Tab panes -->
								<div class="tab-content">
									<xsl:for-each select="$allAppDeployments">
										<xsl:variable name="appDepIndex" select="position()"/>
										<xsl:variable name="currentAppDep" select="current()"/>
										<xsl:variable name="thisDepRole" select="$allEnums[name = $currentAppDep/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
										<xsl:variable name="appDepID">
											<xsl:value-of select="concat('appDep', index-of($allAppDeployments, $currentAppDep))"/>
										</xsl:variable>
										<xsl:variable name="techProdBuild" select="$allTechProvs[name = $currentAppDep/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
										<xsl:variable name="techProvArch" select="$allTechBuildArchs[name = $techProdBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>

										<div role="tabpanel" class="tab-pane active">

											<!--<xsl:choose>
												<xsl:when test="$appDepIndex = 1">
													<xsl:attribute name="class">tab-pane active</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">tab-pane</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>-->
											<xsl:attribute name="id" select="$appDepID"/>
											<xsl:if test="$appDepIndex &gt; 1">
												<script>
													$(this).removeClass('active');
												</script>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="count($techProvArch) > 0">
													<xsl:variable name="apDepModelID" select="concat($appDepID, 'Model')"/>
													<div class="simple-scroller" style="overflow: scroll;">
														<div>
															<xsl:attribute name="id" select="$apDepModelID"/>
														</div>
													</div>
													<xsl:call-template name="modelScript">
														<xsl:with-param name="targetID" select="$apDepModelID"/>
														<xsl:with-param name="techProdBuildArch" select="$techProvArch"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<div class="verticalSpacer_10px"/>
													<p>
														<em>
															<xsl:value-of select="eas:i18n('No Technology Platform Architecture Defined')"/>
														</em>
													</p>
												</xsl:otherwise>
											</xsl:choose>
										</div>
									</xsl:for-each>
								</div>
							</div>
							<hr/>
						</div>


						<!--Setup SupportingTech Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-gears icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Supporting Technology')"/>
								</h2>
							</div>
							<xsl:variable name="anEnvironment" select="$allEnums[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
							<xsl:variable name="aTechBuild" select="$allTechBuilds[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
							<xsl:variable name="aTechBuildArch" select="$allTechBuildArchs[name = $aTechBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
							<xsl:variable name="aTechProUsageList" select="$allTechProvRoleUsages[name = $aTechBuildArch/own_slot_value[slot_reference = 'contained_architecture_components']/value]"/>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($aTechProUsageList) &gt; 0">
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_supportingtech tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_supportingtech').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "20%" },
											    { "width": "20%" },
											    { "width": "30%" },
											    { "width": "30%" }
											  ],
											dom: 'Bfrtip',
										    buttons: [
									            'copyHtml5', 
									            'excelHtml5',
									            'csvHtml5',
									            'pdfHtml5',
									            'print'
									        ]
											});
											
											
											// Apply the search
										    table.columns().every( function () {
										        var that = this;
										 
										        $( 'input', this.footer() ).on( 'keyup change', function () {
										            if ( that.search() !== this.value ) {
										                that
										                    .search( this.value )
										                    .draw();
										            }
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
										        table.columns.adjust();
										    });
										});
									</script>
										<table class="table table-striped table-bordered" id="dt_supportingtech">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Environment')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technology Component')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Component Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technology Products')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$allAppDeployments">
													<xsl:variable name="anEnvironment" select="$allEnums[name = current()/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
													<xsl:variable name="aTechBuild" select="$allTechBuilds[name = current()/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
													<xsl:variable name="aTechBuildArch" select="$allTechBuildArchs[name = $aTechBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
													<xsl:variable name="aTechProUsageList" select="$allTechProvRoleUsages[name = $aTechBuildArch/own_slot_value[slot_reference = 'contained_architecture_components']/value]"/>
													<xsl:for-each select="$aTechProUsageList">
														<xsl:variable name="aTechProRole" select="$appTechProvRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
														<xsl:variable name="aTechProd" select="$appTechProvs[name = $aTechProRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
														<xsl:variable name="aTechComp" select="$appTechComps[name = $aTechProRole/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
														<tr>
															<td>
																<xsl:value-of select="$anEnvironment/own_slot_value[slot_reference = 'enumeration_value']/value"/>
															</td>
															<td>
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="$aTechComp"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																</xsl:call-template>
															</td>
															<td>
																<xsl:call-template name="RenderMultiLangInstanceDescription">
																	<xsl:with-param name="theSubjectInstance" select="$aTechComp"/>
																</xsl:call-template>
															</td>
															<td>
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="$aTechProd"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																</xsl:call-template>
															</td>
														</tr>
													</xsl:for-each>

												</xsl:for-each>

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Environment')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technology Component')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Component Description')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Technology Products')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<span>-</span>
										</p>
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>


						<!--Setup AppDeployment Section-->
						<!--<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-globe icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Application Deployment')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="linkText" select="$appDeploymentView/own_slot_value[slot_reference = 'report_history_label']/value"/>
								<xsl:variable name="reportFilename" select="$appDeploymentView/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
								<xsl:variable name="linkURL">
									<xsl:call-template name="RenderLinkText">
										<xsl:with-param name="theXSL" select="$reportFilename"/>
										<xsl:with-param name="theXML">
											<xsl:value-of select="$reposXML"/>
										</xsl:with-param>
										<xsl:with-param name="theInstanceID" select="$param1"/>
										<xsl:with-param name="theHistoryLabel" select="escape-html-uri($linkText)"/>
									</xsl:call-template>
								</xsl:variable>
								<p>
									<a>
										<xsl:attribute name="href" select="$linkURL"/>
										<xsl:value-of select="eas:i18n('Click here')"/>
									</a>
									<xsl:text> </xsl:text>
									<xsl:value-of select="eas:i18n('to view the Application Deployment Summary for')"/>
									<xsl:text> </xsl:text>
									<strong>
										<xsl:value-of select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
									</strong>
								</p>
							</div>
							<hr/>
						</div>-->


						<!--Setup SupportingDocs Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
								</h2>
							</div>
							<div class="content-section">
								<!--<xsl:apply-templates select="$currentApp" mode="ReportExternalDocRef">
									<xsl:with-param name="emptyMessage">-</xsl:with-param>
								</xsl:apply-templates>-->
								<xsl:call-template name="RenderExternalDocRefList">
									<xsl:with-param name="extDocRefs" select="$allExternalRefs"/>
									<xsl:with-param name="emptyMessage">-</xsl:with-param>
								</xsl:call-template>

							</div>
							<hr/>
						</div>


						<!--Setup Closing Tags-->

					</div>
				</div>
				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
                    $(document).ready(function(){
                        var windowHeight = $(window).height();
						var windowWidth = $(window).width();
                        $('.simple-scroller').scrollLeft(windowWidth/2);
                    });
                </script>
				<!--<script>
					$('#myTabs a').click(function (e) {
					  e.preventDefault()
					  $(this).tab('show')
					})
				</script>-->
			</body>
		</html>
	</xsl:template>

	<xsl:template name="modelScript">
		<xsl:param name="targetID"/>
		<xsl:param name="techProdBuildArch" select="()"/>

		<xsl:variable name="techProdRoleUsages" select="$allTechProvRoleUsages[(name = $techProdBuildArch/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
		<xsl:variable name="techProdRoles" select="$allTechProRoles[name = $techProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="techProdArchRelations" select="$allTechProdArchRelations[(name = $techProdBuildArch/own_slot_value[slot_reference = 'contained_provider_architecture_relations']/value)]"/>

		<xsl:variable name="sourceTechProdRoleUsages" select="$techProdRoleUsages[name = $techProdArchRelations/own_slot_value[slot_reference = ':FROM']/value]"/>

		<xsl:if test="count($techProdRoles) > 0">
			<script>
					
					var <xsl:value-of select="$targetID"/>graph = new joint.dia.Graph;
					
					var windowWidth = $(window).width()*2;
					var windowHeight = $(window).height()*2;
					
					var <xsl:value-of select="$targetID"/>paper = new joint.dia.Paper({
						el: $('#<xsl:value-of select="$targetID"/>'),
				        width: $('#<xsl:value-of select="$targetID"/>').width(),
				        height: <xsl:value-of select="($objectHeight + 30) * count($techProdRoleUsages)"/>,
				        gridSize: 1,
				        model: <xsl:value-of select="$targetID"/>graph
				    });
				    
				    <xsl:value-of select="$targetID"/>paper.setOrigin(30,30);
					
					
					<xsl:apply-templates mode="RenderTPRUNameVariable" select="$techProdRoleUsages"/>
					
					var <xsl:value-of select="$targetID"/>clusters = {
						<xsl:apply-templates mode="RenderTPRUDefinition" select="$techProdRoleUsages"/>			
					};
					
					_.each(<xsl:value-of select="$targetID"/>clusters, function(c) { <xsl:value-of select="$targetID"/>graph.addCell(c); });
		
		
					var <xsl:value-of select="$targetID"/>relations = [
					<xsl:apply-templates mode="RenderTechProdRelation" select="$sourceTechProdRoleUsages">
						<xsl:with-param name="modelID" select="$targetID"/>
					</xsl:apply-templates>
					];
					
					_.each(<xsl:value-of select="$targetID"/>relations, function(r) { <xsl:value-of select="$targetID"/>graph.addCell(r); });
					
					
					joint.layout.DirectedGraph.layout(<xsl:value-of select="$targetID"/>graph, { setLinkVertices: false, rankDir: "TB", nodeSep: 100, edgeSep: 100 });
					
					
					<!--<xsl:apply-templates mode="RenderTPRLifecycleStatus" select="$techProdRoles"/>-->
					
					
					// paper.scale(0.9, 0.9);
					// paper.scaleContentToFit();
		    
					
				</script>
		</xsl:if>
	</xsl:template>


	<xsl:function as="xs:string" name="eas:get_techprodrole_name">
		<xsl:param name="tpr"/>

		<xsl:variable name="techProd" select="$allTechProvs[name = $tpr/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techComp" select="$allTechComps[name = $tpr/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:variable name="techProdSupplier" select="$allSuppliers[name = $techProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:value-of select="concat($techProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $techProd/own_slot_value[slot_reference = 'name']/value, ' as ', $techComp/own_slot_value[slot_reference = 'name']/value)"/>

	</xsl:function>

	<xsl:template mode="RenderTPRUNameVariable" match="node()">
		<xsl:variable name="nodeType" select="'Cluster'"/>
		<xsl:variable name="index" select="index-of($allTechProvRoleUsages, current())"/>
		<xsl:variable name="nameVariable" select="concat(lower-case($nodeType), $index, 'Name')"/>
		<xsl:variable name="nodeNamingFunction" select="concat('wrap', $nodeType, 'Name')"/>
		<xsl:variable name="techProdRole" select="$allTechProRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="nodeNameString" select="eas:get_techprodrole_name($techProdRole)"/> var <xsl:value-of select="$nameVariable"/> = <xsl:value-of select="$nodeNamingFunction"/>('<xsl:value-of select="$nodeNameString"/><xsl:text>');
		</xsl:text>
	</xsl:template>




	<xsl:template mode="RenderTPRUDefinition" match="node()">
		<xsl:variable name="index" select="index-of($allTechProvRoleUsages, current())"/>
		<xsl:variable name="nameVariable" select="concat('cluster', $index, 'Name')"/>
		<xsl:variable name="nodeListName" select="concat('cluster', $index)"/>
		<xsl:variable name="techProdRole" select="$allTechProRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="techProd" select="$allTechProvs[name = $techProdRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techProdSummaryLinkHref">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theInstanceID" select="$techProd/name"/>
				<xsl:with-param name="theXSL" select="$techProdSummaryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$nodeListName"/>: new joint.shapes.custom.Cluster({ position: { x: 100, y: 20 }, size: { width: <xsl:value-of select="$objectWidth"/>, height: <xsl:value-of select="$objectHeight"/> }, attrs: { rect: { 'stroke-width': <xsl:value-of select="$objectStrokeWidth"/>, fill: '<xsl:value-of select="$objectColour"/>', stroke: '<xsl:value-of select="$objectOutlineColour"/>'<!--, rx: 5, ry: 5--> }, a: { 'xlink:href': '<xsl:value-of select="$techProdSummaryLinkHref"/>', cursor: 'pointer' }, text: { text: <xsl:value-of select="$nameVariable"/>, fill: '<xsl:value-of select="$objectTextColour"/>', 'font-weight': 'bold' }} })<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>



	<xsl:template mode="RenderTechProdRelation" match="node()">
		<xsl:param name="modelID"/>
		<xsl:variable name="currentTechProdRoleUsage" select="current()"/>
		<xsl:variable name="currentTechProdRole" select="$allTechProRoles[name = $currentTechProdRoleUsage/own_slot_value[slot_reference = 'provider_as_role']/value]"/>

		<xsl:variable name="index" select="index-of($allTechProvRoleUsages, $currentTechProdRoleUsage)"/>
		<xsl:variable name="sourceListName" select="concat('cluster', $index)"/>

		<xsl:variable name="relevantRelations" select="$allTechProdArchRelations[own_slot_value[slot_reference = ':FROM']/value = $currentTechProdRoleUsage/name]"/>
		<xsl:variable name="targetTechProdRoleUsages" select="($allTechProvRoleUsages except $currentTechProdRoleUsage)[name = $relevantRelations/own_slot_value[slot_reference = ':TO']/value]"/>


		<xsl:for-each select="$targetTechProdRoleUsages">
			<xsl:variable name="targetIndex" select="index-of($allTechProvRoleUsages, current())"/>
			<xsl:variable name="targetListName" select="concat('cluster', $targetIndex)"/> new joint.dia.Link({ source: { id: <xsl:value-of select="$modelID"/>clusters.<xsl:value-of select="$sourceListName"/>.id }, target: { id: <xsl:value-of select="$modelID"/>clusters.<xsl:value-of select="$targetListName"/>.id }, attrs: { '.marker-target': { d: 'M 10 0 L 0 5 L 10 10 z' }, '.connection': {'stroke-width': 2 }, '.link-tools': { display : 'none'}, '.marker-arrowheads': { display: 'none' },'.connection-wrap': { display: 'none' }, }})<xsl:if test="not(position() = last())"><xsl:text>,
			</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:if test="(not(position() = last())) and (count($targetTechProdRoleUsages) > 0)">
			<xsl:text>,
		</xsl:text>
		</xsl:if>

	</xsl:template>


	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:get_js_name_for_data_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="lowerCaseName" select="lower-case($dataObjectName)"/>
		<xsl:variable name="noOpenBrackets" select="translate($lowerCaseName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:value-of select="translate($noCloseBrackets, ' ', '')"/>

	</xsl:function>

	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:no_specials_js_name_for_data_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="noOpenBrackets" select="translate($dataObjectName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:value-of select="$noCloseBrackets"/>

	</xsl:function>
  <xsl:function as="xs:float" name="eas:get_cost_components_total">
        <xsl:param name="costComponents"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="count($costComponents) > 0">
                <xsl:variable name="nextCost" select="$costComponents[1]"/>
                <xsl:variable name="newCostComponents" select="remove($costComponents, 1)"/>
                <xsl:variable name="costAmount" select="$nextCost/own_slot_value[slot_reference='cc_cost_amount']/value"/>
                <xsl:choose>
                    <xsl:when test="$costAmount > 0">
                        <xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total + number($costAmount))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
