<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:functx="http://www.functx.com" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output indent="yes" method="html" omit-xml-declaration="yes"/>


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

	<!-- param1 = the business service that is being summarised -->
	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'" />
		<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')" />-->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Composite_Application_Provider', 'Business_Process', 'Business_Activity', 'Individual_Actor', 'Group_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Get all of the required types of instances in the repository -->
	<!--<xsl:variable name="currentBusSvc" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentBusSvcName" select="$currentBusSvc/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentBusSvcDescription">
		<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="$currentBusSvc"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="allBusConsumers" select="/node()/simple_instance[name = $currentBusSvc/own_slot_value[slot_reference = 'product_type_target_audience']/value]"/>
	<xsl:variable name="busSvcSupportingProcs" select="/node()/simple_instance[name = $currentBusSvc/own_slot_value[slot_reference = 'product_type_produced_by_process']/value]"/>
	<xsl:variable name="busSvcSupportingGroupRoles" select="/node()/simple_instance[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
	<xsl:variable name="busSvcSupportingIndividualRoles" select="/node()/simple_instance[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
	<xsl:variable name="busSvcPhysProcs" select="/node()/simple_instance[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
	<xsl:variable name="busSvcActor2Roles" select="/node()/simple_instance[name = $busSvcPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="busSvcActors" select="/node()/simple_instance[name = $busSvcActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="busSvcApp2PhysProcs" select="/node()/simple_instance[name = $busSvcPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
	<xsl:variable name="busSvcAppProRoles" select="/node()/simple_instance[name = $busSvcApp2PhysProcs/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="busSvcAppPros" select="/node()/simple_instance[name = $busSvcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>


-->
	<!-- Get all of the required types of instances in the repository -->
	<!-- NOTE: Queries accounts for composite and individual product types/products -->
	<xsl:variable name="allBusServices" select="/node()/simple_instance[type = ('Product_Type','Composite_Product_Type')]"/>
	<xsl:variable name="allBusServiceInstances" select="/node()/simple_instance[type = ('Product','Composite_Product')]"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[supertype = 'Physical_Process_Type']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[supertype = 'Business_Process_Type']"/>
	
	
	
	<xsl:variable name="currentBusSvc" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentBusSvcName" select="$currentBusSvc/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentBusSvcDescription">
		<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="$currentBusSvc"/>
		</xsl:call-template>
	</xsl:variable>
	
	<!-- NOTE: Define all Business Services in scope, including sub product-types -->
	<xsl:variable name="currentBusSvcSubServices" select="$allBusServices[name = $currentBusSvc/own_slot_value[slot_reference = 'contained_product_types']/value]"/>
	<xsl:variable name="allCurrentBusSvcs" select="$currentBusSvc union $currentBusSvcSubServices"/>
	
	<!-- NOTE: Update filters to include sub-product types and sub-products -->
	<xsl:variable name="allBusConsumers" select="/node()/simple_instance[name = $allCurrentBusSvcs/own_slot_value[slot_reference = 'product_type_target_audience']/value]"/>
	<!-- FINE GRAINED FILTER FOR PHYSICAL PROCESSES AND APPS-->
	<xsl:variable name="fineGrainedBusSvcInstances" select="$allBusServiceInstances[name = $allCurrentBusSvcs/own_slot_value[slot_reference = 'product_type_instances']/value]"/>
	<xsl:variable name="busSvcPhysProcs" select="$allPhysProcs[name = $fineGrainedBusSvcInstances/own_slot_value[slot_reference = 'product_implemented_by_process']/value]"/>
	<!-- End My Filter -->
	<!-- Adaptation due to My Filter 
	<xsl:variable name="busSvcSupportingProcs" select="/node()/simple_instance[name = $currentBusSvc/own_slot_value[slot_reference = 'product_type_produced_by_process']/value]"/>
-->
	<xsl:variable name="fineGrainedBusSvcSupportingProcs" select="$allBusProcs[name = $busSvcPhysProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="busSvcSupportingGroupRoles" select="/node()/simple_instance[name = $fineGrainedBusSvcSupportingProcs/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
	<xsl:variable name="busSvcSupportingIndividualRoles" select="/node()/simple_instance[name = $fineGrainedBusSvcSupportingProcs/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
	
	<!-- Get the coarse grained supporting business processes -->
	<xsl:variable name="coarseGrainedBusSvcSupportingProcs" select="$allBusProcs[name = $allCurrentBusSvcs/own_slot_value[slot_reference = 'product_type_produced_by_process']/value]"/>
	
	<!-- MAIN CHANGE: Define the complete set of fine-grained and coarse grained supporting business processes -->
	<xsl:variable name="allBusSvcSupportingProcs" select="$fineGrainedBusSvcSupportingProcs union $coarseGrainedBusSvcSupportingProcs"/>
	
	<!-- Adaptation due to My Filter 
	<xsl:variable name="busSvcPhysProcs" select="/node()/simple_instance[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
-->
	<xsl:variable name="busSvcActor2Roles" select="/node()/simple_instance[name = $busSvcPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="busSvcActors" select="/node()/simple_instance[name = $busSvcActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="busSvcApp2PhysProcs" select="/node()/simple_instance[name = $busSvcPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
	<xsl:variable name="busSvcAppProRoles" select="/node()/simple_instance[name = $busSvcApp2PhysProcs/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="busSvcAppPros" select="/node()/simple_instance[name = $busSvcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>


	<!-- COARSE GRAINED FILTER FOR ADITIONAL APPS-->
	<!-- Get the logical processes that support the business service -->
	
	<!-- Get the phytsical processes that implement the logical processes -->
	
	<!-- Get the apps that support the physical processes -->
	
	<!--  -->

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('Business Service Summary')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Service Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="$pageLabel"/> - </span>
									<span class="text-primary">
										<xsl:value-of select="$currentBusSvcName"/>
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
										<xsl:when test="string-length($currentBusSvcDescription) = 0">
											<em>
												<xsl:value-of select="eas:i18n('No description captured for this Business Service')"/>
											</em>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$currentBusSvcDescription"/>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>



						<!--Setup Service Consumers Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Service Consumers')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allBusConsumers) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No consumers captured for this Business Service')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$allBusConsumers">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
							</div>
							<hr/>
						</div>



						<!--Setup Process Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Processes')"/>
							</h2>
							<xsl:choose>
								<xsl:when test="count($allBusSvcSupportingProcs) = 0">
									<div class="content-section">
										<em>
											<xsl:value-of select="eas:i18n('No business processes captured for this business service')"/>
										</em>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('The following table lists the business processes supporting the')"/>&#160; <strong><xsl:value-of select="$currentBusSvcName"/></strong> &#160;<xsl:value-of select="eas:i18n('business service')"/></p>
										<br/>
										<table class="table-header-background table table-bordered table-striped">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Business Process')"/>
													</th>
													<th class="cellWidth-40pc">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Performed By')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="BusProcesses" select="$allBusSvcSupportingProcs">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>



						<!--Setup Apps Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Applications')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($busSvcAppPros) = 0">
										<em>
											<xsl:value-of select="eas:i18n('No supporting applications captured for this Business Service')"/>
										</em>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$busSvcAppPros">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
								<xsl:apply-templates mode="ReportExternalDocRef" select="$currentBusSvc"/>
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


	<xsl:template match="node()" mode="BusProcesses">
		<xsl:variable name="procName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="procDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="physProcs" select="$busSvcPhysProcs[name = current()/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
		<xsl:variable name="actor2Roles" select="$busSvcActor2Roles[name = $physProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="actors" select="$busSvcActors[name = $actor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="$procDesc"/>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$actors">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>

			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
