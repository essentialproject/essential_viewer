<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Domain', 'Technology_Capability', 'Technology_Function_Type', 'Technology_Component', 'Technology_Principle', 'Application_Function_Implementation', 'Individual_Actor', 'Group_Actor', 'Technology_Architecture_Principle')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentTechCap" select="/node()/simple_instance[name = $param1]"/>

	<xsl:variable name="allTechFunctionTypes" select="/node()/simple_instance[type = 'Technology_Function_Type']"/>
	<xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>
	<xsl:variable name="allTechPrinciples" select="/node()/simple_instance[type = 'Technology_Architecture_Principle']"/>
	<xsl:variable name="allAppFuncImpl" select="/node()/simple_instance[type = 'Application_Function_Implementation']"/>
	<xsl:variable name="allAppFunctoTechCap" select="/node()/simple_instance[type = 'APP_FUNCIMPL_TO_TECH_CAP_RELATION']"/>

	<xsl:variable name="parentDomain" select="/node()/simple_instance[name = $currentTechCap/own_slot_value[slot_reference = 'belongs_to_technology_domain']/value]"/>
	<xsl:variable name="containedTechCaps" select="/node()/simple_instance[name = $currentTechCap/own_slot_value[slot_reference = 'contained_technology_capabilities']/value]"/>
	<xsl:variable name="functionTypes" select="$allTechFunctionTypes[name = $currentTechCap/own_slot_value[slot_reference = 'technology_capability_function_types_offered']/value]"/>
	<xsl:variable name="realisedTechComps" select="$allTechComponents[name = $currentTechCap/own_slot_value[slot_reference = 'realised_by_technology_components']/value]"/>
	<xsl:variable name="relevantTechPrinciples" select="$allTechPrinciples[name = $currentTechCap/own_slot_value[slot_reference = 'relevant_technology_principles']/value]"/>
	<xsl:variable name="relevantTechObjs" select="$allTechPrinciples[name = $currentTechCap/own_slot_value[slot_reference = 'capability_relevant_to_technology_objectives']/value]"/>
	<xsl:variable name="appFuncImplRelations" select="$allAppFunctoTechCap[name = $currentTechCap/own_slot_value[slot_reference = 'tech_cap_supports_appfunimpl']/value]"/>

	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $currentTechCap/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

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
					<xsl:value-of select="eas:i18n('Technology Capability Summary')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
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
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Technology Capability Summary for')"/>&#160;</span>
									<span class="text-primary">
										<xsl:value-of select="$currentTechCap/own_slot_value[slot_reference = 'name']/value"/>
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
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentTechCap"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Tech Domain Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-info-circle icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Belongs to Technology Domain')"/>
							</h2>
							<div class="content-section">
								<p>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$parentDomain"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Contained Tech Caps Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Contains Technology Capabilities')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($containedTechCaps) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$containedTechCaps">
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

						<!--Setup Function Types Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Function Types Offered')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($functionTypes) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<script>
									$(document).ready(function(){
										// Setup - add a text input to each footer cell
									    $('#dt_techfunc tfoot th').each( function () {
									        var title = $(this).text();
									        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
									    } );
										
										var table = $('#dt_techfunc').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										paging: false,
										info: false,
										sort: true,
										responsive: true,
										columns: [
										    { "width": "30%" },
										    { "width": "70%" }										  ],
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
										<table class="table table-striped table-bordered" id="dt_techfunc">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Technology Function Type')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Technology Function Type')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:for-each select="$functionTypes">
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
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>


						<!--Setup Technology Components Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Realised by Technology Components')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($realisedTechComps) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<script>
									$(document).ready(function(){
										// Setup - add a text input to each footer cell
									    $('#dt_techcomps tfoot th').each( function () {
									        var title = $(this).text();
									        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
									    } );
										
										var table = $('#dt_techcomps').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										paging: false,
										info: false,
										sort: true,
										responsive: true,
										columns: [
										    { "width": "30%" },
										    { "width": "70%" }										  ],
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
										<table class="table table-striped table-bordered" id="dt_techcomps">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Technology Component')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Technology Component')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:for-each select="$realisedTechComps">
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
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>

						<!--Setup Tech Principles Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check-circle icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Relevant Technology Principles')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($relevantTechPrinciples) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<script>
									$(document).ready(function(){
										// Setup - add a text input to each footer cell
									    $('#dt_techprinciples tfoot th').each( function () {
									        var title = $(this).text();
									        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
									    } );
										
										var table = $('#dt_techprinciples').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										paging: false,
										info: false,
										sort: true,
										responsive: true,
										columns: [
										    { "width": "30%" },
										    { "width": "70%" }										  ],
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
										<table class="table table-striped table-bordered" id="dt_techprinciples">
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Technology Principle')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Technology Principle')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:for-each select="$relevantTechPrinciples">
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
									</xsl:otherwise>
								</xsl:choose>

							</div>
							<hr/>
						</div>

						<!--Setup App Function Implementation Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-connections icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supports Application Function Implementation')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($appFuncImplRelations) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$appFuncImplRelations">
												<li>
													<xsl:variable name="currentAppFuncImpl" select="$allAppFuncImpl[name = current()/own_slot_value[slot_reference = 'app_fun_impl_to_tech_FROM_app']/value]"/>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="$currentAppFuncImpl"/>
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

						<!--Setup Stakeholders Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Roles and People')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($allStakeholders) &gt; 0">
										<script>
											$(document).ready(function(){
												// Setup - add a text input to each footer cell
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
													<th>
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
													<th>
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

</xsl:stylesheet>
