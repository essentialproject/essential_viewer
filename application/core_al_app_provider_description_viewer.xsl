<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Application_Service', 'Composite_Application_Provider', 'Supplier', 'Group_Actor', 'Individual_Actor', 'Business_Process', 'Site')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- VIEW SPECIFIC SETUP VARIABLES -->
	<!-- Retrieve the current Application_Provider instance by the param1 ID -->
	<xsl:variable name="currentApp" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>

	<!-- Enumerations -->
	<xsl:variable name="allEnums" select="/node()/simple_instance[supertype = 'Enumeration']"/>

	<!-- Application Purpose -->
	<xsl:variable name="allAppPurpose" select="$allEnums[type = 'Application_Purpose']"/>

	<!-- Application Family -->
	<xsl:variable name="allAppFamilies" select="/node()/simple_instance[type = 'Application_Family']"/>
	<xsl:variable name="appType" select="$allAppFamilies[name = $currentApp/own_slot_value[slot_reference = 'type_of_application']/value]"/>

	<!-- Lifecycle Status -->
	<xsl:variable name="allLifecycleStatus" select="$allEnums[type = 'Lifecycle_Status']"/>

	<!-- Delivery Model -->
	<xsl:variable name="allDelModels" select="$allEnums[type = 'Application_Delivery_Model']"/>

	<!-- Supplier -->
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>

	<!-- Application Services via Application Provider Roles -->
	<xsl:variable name="allAppSvcs" select="/node()/simple_instance[type = 'Application_Service' or supertype = 'Application_Service']"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type = 'Application_Provider_Role' and own_slot_value[slot_reference = 'role_for_application_provider']/value = $param1]"/>

	<!-- Stakeholders -->
	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $currentApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

	<!-- Contained Application Providers (for Composite) -->
	<xsl:variable name="allAppPros" select="/node()/simple_instance[type = 'Application_Provider' or supertype = 'Application_Provider']"/>
	<xsl:variable name="allContainedApps" select="$allAppPros[name = $currentApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>

	<!-- Supported Business Processes -->
	<xsl:variable name="allPhysicalProcs" select="/node()/simple_instance[supertype = 'Physical_Process_Type']"/>
	<xsl:variable name="allPhysicalProcRelsIndirect" select="/node()/simple_instance[name = $allAppProRoles/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value]"/>
	<xsl:variable name="allPhysicalProcRelsDirect" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value=$currentApp/name]"/>
	<xsl:variable name="allPhysicalProcRels" select="$allPhysicalProcRelsDirect union $allPhysicalProcRelsIndirect"/>
	<xsl:variable name="supportedProcs" select="$allPhysicalProcs[name = $allPhysicalProcRels/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
	<xsl:variable name="supportedLogProcs" select="/node()/simple_instance[name = $supportedProcs/own_slot_value[slot_reference = 'implements_business_process']/value]"/>

	<!-- External References -->
	<xsl:variable name="allExternalRefs" select="/node()/simple_instance[name = $currentApp/own_slot_value[slot_reference = 'external_reference_links']/value]"/>

	<!-- Number of users -->
	<xsl:variable name="appNoOfUsers" select="$currentApp/own_slot_value[slot_reference = 'ap_max_number_of_users']/value"/>

	<!-- END VIEW SPECIFIC SETUP VARIABLES -->

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

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Application Description Viewer')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<style>
					.app-detail-card {
						background-color: #fff;
						border: 1px solid #e0e0e0;
						border-radius: 4px;
						padding: 20px;
						margin-bottom: 20px;
					}
					.app-detail-card h3 {
						margin-top: 0;
						color: #333;
					}
					.detail-label {
						font-weight: bold;
						color: #555;
						min-width: 160px;
						display: inline-block;
					}
					.detail-row {
						padding: 8px 0;
						border-bottom: 1px solid #f0f0f0;
					}
					.detail-row:last-child {
						border-bottom: none;
					}
					.app-description-block {
						background-color: #f9f9f9;
						border-left: 4px solid #337ab7;
						padding: 15px 20px;
						margin: 15px 0;
						font-size: 1.1em;
						line-height: 1.6;
					}
					.badge-info {
						background-color: #337ab7;
						color: #fff;
						padding: 3px 8px;
						border-radius: 3px;
						font-size: 0.85em;
					}
					.badge-lifecycle {
						padding: 4px 10px;
						border-radius: 3px;
						font-size: 0.9em;
						font-weight: bold;
					}
				</style>
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
										<xsl:value-of select="eas:i18n('Application Description')"/>
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
								</h1>
							</div>
						</div>

						<!--===== DESCRIPTION SECTION =====-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Description')"/>
								</h2>
							</div>
							<div class="content-section">
								<div class="app-description-block">
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
									</xsl:call-template>
								</div>
							</div>
							<hr/>
						</div>

						<!--===== KEY DETAILS SECTION =====-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-info-circle icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Key Details')"/>
								</h2>
							</div>
							<div class="content-section">
								<div class="app-detail-card">
									<!-- Purpose -->
									<div class="detail-row">
										<span class="detail-label"><xsl:value-of select="eas:i18n('Purpose')"/>:</span>
										<xsl:variable name="appPurpose" select="$allAppPurpose[name = $currentApp/own_slot_value[slot_reference = 'application_provider_purpose']/value]"/>
										<xsl:choose>
											<xsl:when test="count($appPurpose) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each select="$appPurpose">
													<xsl:if test="position() &gt; 1">, </xsl:if>
													<xsl:value-of select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
												</xsl:for-each>
											</xsl:otherwise>
										</xsl:choose>
									</div>

									<!-- Application Family -->
									<div class="detail-row">
										<span class="detail-label"><xsl:value-of select="eas:i18n('Application Family')"/>:</span>
										<xsl:choose>
											<xsl:when test="count($appType) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each select="$appType">
													<xsl:if test="position() &gt; 1">, </xsl:if>
													<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
												</xsl:for-each>
											</xsl:otherwise>
										</xsl:choose>
									</div>

									<!-- Lifecycle Status -->
									<div class="detail-row">
										<span class="detail-label"><xsl:value-of select="eas:i18n('Lifecycle Status')"/>:</span>
										<xsl:variable name="appLifecycle" select="$allLifecycleStatus[name = $currentApp/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]"/>
										<xsl:choose>
											<xsl:when test="count($appLifecycle) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<span class="badge-lifecycle">
													<xsl:value-of select="$appLifecycle/own_slot_value[slot_reference = 'enumeration_value']/value"/>
												</span>
											</xsl:otherwise>
										</xsl:choose>
									</div>

									<!-- Delivery Model -->
									<div class="detail-row">
										<span class="detail-label"><xsl:value-of select="eas:i18n('Delivery Model')"/>:</span>
										<xsl:variable name="aDelModel" select="$allDelModels[name = $currentApp/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
										<xsl:choose>
											<xsl:when test="count($aDelModel) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$aDelModel/own_slot_value[slot_reference = 'enumeration_value']/value"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>

									<!-- Supplier -->
									<div class="detail-row">
										<span class="detail-label"><xsl:value-of select="eas:i18n('Supplier')"/>:</span>
										<xsl:variable name="supplier" select="$allSuppliers[name = $currentApp/own_slot_value[slot_reference = 'ap_supplier']/value]"/>
										<xsl:choose>
											<xsl:when test="count($supplier) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$supplier"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</div>

									<!-- Number of Users -->
									<div class="detail-row">
										<span class="detail-label"><xsl:value-of select="eas:i18n('Max Number of Users')"/>:</span>
										<xsl:choose>
											<xsl:when test="string-length($appNoOfUsers) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$appNoOfUsers"/>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</div>
							</div>
							<hr/>
						</div>

						<!--===== APPLICATION SERVICES SECTION =====-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Services')"/>
							</h2>
							<div class="content-section">
								<xsl:variable name="services" select="$allAppSvcs[name = $allAppProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
								<xsl:choose>
									<xsl:when test="count($services) = 0">
										<p><span>-</span></p>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$services">
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

						<!--===== SUPPORTED BUSINESS PROCESSES SECTION =====-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-valuechain icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supported Business Processes')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($supportedLogProcs) = 0">
										<p><span>-</span></p>
									</xsl:when>
									<xsl:otherwise>
										<script>
											$(document).ready(function(){
												$('#dt_busProcs tfoot th').each( function () {
													var title = $(this).text();
													$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
												} );

												var table = $('#dt_busProcs').DataTable({
													scrollY: "350px",
													scrollCollapse: true,
													paging: false,
													info: false,
													sort: true,
													responsive: true,
													columns: [
														{ "width": "40%" },
														{ "width": "60%" }
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

												table.columns().every( function () {
													var that = this;
													$( 'input', this.footer() ).on( 'keyup change', function () {
														if ( that.search() !== this.value ) {
															that.search( this.value ).draw();
														}
													} );
												} );
												table.columns.adjust();
												$(window).resize( function () {
													table.columns.adjust();
												});
											});
										</script>
										<table class="table table-striped table-bordered" id="dt_busProcs">
											<thead>
												<tr>
													<th><xsl:value-of select="eas:i18n('Business Process')"/></th>
													<th><xsl:value-of select="eas:i18n('Description')"/></th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="$supportedLogProcs">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
													<th><xsl:value-of select="eas:i18n('Business Process')"/></th>
													<th><xsl:value-of select="eas:i18n('Description')"/></th>
												</tr>
											</tfoot>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--===== CONTAINED APPLICATIONS SECTION (for Composite) =====-->
						<xsl:if test="count($allContainedApps) &gt; 0">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
								</div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Contained Applications')"/>
								</h2>
								<div class="content-section">
									<script>
										$(document).ready(function(){
											$('#dt_containedApps tfoot th').each( function () {
												var title = $(this).text();
												$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
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

											table.columns().every( function () {
												var that = this;
												$( 'input', this.footer() ).on( 'keyup change', function () {
													if ( that.search() !== this.value ) {
														that.search( this.value ).draw();
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
												<th><xsl:value-of select="eas:i18n('Application')"/></th>
												<th><xsl:value-of select="eas:i18n('Description')"/></th>
											</tr>
										</thead>
										<tbody>
											<xsl:for-each select="$allContainedApps">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
												<th><xsl:value-of select="eas:i18n('Application')"/></th>
												<th><xsl:value-of select="eas:i18n('Description')"/></th>
											</tr>
										</tfoot>
									</table>
								</div>
								<hr/>
							</div>
						</xsl:if>

						<!--===== STAKEHOLDERS SECTION =====-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Stakeholders')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allStakeholders) = 0">
										<p><span>-</span></p>
									</xsl:when>
									<xsl:otherwise>
										<script>
											$(document).ready(function(){
												$('#dt_stakeholders tfoot th').each( function () {
													var title = $(this).text();
													$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
												} );

												var table = $('#dt_stakeholders').DataTable({
													scrollY: "350px",
													scrollCollapse: true,
													paging: false,
													info: false,
													sort: true,
													responsive: true,
													columns: [
														{ "width": "40%" },
														{ "width": "40%" },
														{ "width": "20%" }
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

												table.columns().every( function () {
													var that = this;
													$( 'input', this.footer() ).on( 'keyup change', function () {
														if ( that.search() !== this.value ) {
															that.search( this.value ).draw();
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
													<th><xsl:value-of select="eas:i18n('Role')"/></th>
													<th><xsl:value-of select="eas:i18n('Person or Organisation')"/></th>
													<th><xsl:value-of select="eas:i18n('Email')"/></th>
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
													<th><xsl:value-of select="eas:i18n('Role')"/></th>
													<th><xsl:value-of select="eas:i18n('Person or Organisation')"/></th>
													<th><xsl:value-of select="eas:i18n('Email')"/></th>
												</tr>
											</tfoot>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--===== EXTERNAL REFERENCES SECTION =====-->
						<xsl:if test="count($allExternalRefs) &gt; 0">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-external-link icon-section icon-color"/>
								</div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('External References')"/>
								</h2>
								<div class="content-section">
									<xsl:call-template name="RenderExternalDocRefList">
										<xsl:with-param name="extDocRefs" select="$allExternalRefs"/>
									</xsl:call-template>
								</div>
								<hr/>
							</div>
						</xsl:if>

					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
