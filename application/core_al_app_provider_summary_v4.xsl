<?xml version="1.0" encoding="UTF-8"?>
	
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<!--<xsl:include href="../common/core_external_repos_ref.xsl" />-->

	<!--<xsl:include href="../application/menus/core_app_service_menu.xsl" />-->

	<xsl:output method="html"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC SETUP VARIABES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<!-- END GENERIC SETUP VARIABES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function_Implementation')"/>
	<xsl:variable name="currentApp" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="soft_component_usages" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_logical_software_arch']/value = $currentApp/own_slot_value[slot_reference = 'has_software_architecture']/value]"/>
	<xsl:variable name="soft_components" select="/node()/simple_instance[name = $soft_component_usages/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
	<xsl:variable name="required_tech_caps" select="/node()/simple_instance[name = $currentApp/own_slot_value[slot_reference = 'required_technology_capabilities']/value]"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allLogicalBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allIndivActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allActors" select="$allIndivActors union $allGroupActors"/>
	<xsl:variable name="allDeploymentRoles" select="/node()/simple_instance[type = 'Deployment_Role']"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]"/>
	<xsl:variable name="appUserRole" select="$allRoles[own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User')]"/>
	<xsl:variable name="thisAppStakeholder2Roles" select="$allActor2Roles[(name = $currentApp/own_slot_value[slot_reference = 'stakeholders']/value) and not(own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserRole/name)]"/>
	<xsl:variable name="thisStakeholders" select="$allGroupActors[name = $thisAppStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

	<!-- END VIEW SPECIFIC SETUP VARIABES -->

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->



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
	<!-- 15.03.2013 JWC Re-rendered the Software Component -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Application Provider Summary')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<!--script to turn the app providers list into columns-->
				<script>
						$(function(){
							$('#appInboundData').columnize({columns: 2});
							$('#appOutboundData').columnize({columns: 2});
							$('#appInterfaces').columnize({columns: 2});		
						});
				</script>


			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentApp" mode="Page_Content"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<!--ADD THE CONTENT-->
	<xsl:template match="node()" mode="Page_Content">
		<!-- Get the name of the application provider -->
		<xsl:variable name="appName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>

		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
							<span class="text-darkgrey">
								<xsl:value-of select="eas:i18n('Application Provider Summary for')"/>&#160;</span>
							<span class="text-primary">
								<xsl:value-of select="$appName"/>
							</span>
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
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</p>
					</div>
					<hr/>
				</div>

				<!--Setup Application Purpose Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-info-circle icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Application Purpose</h2>
					<div class="content-section">
						<p>
							<xsl:variable name="appPurpose" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'application_provider_purpose']/value]"/>
							<xsl:if test="not(count($appPurpose) > 0)">
								<em>Not Defined</em>
							</xsl:if>
							<xsl:value-of select="$appPurpose/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</p>
					</div>
					<hr/>
				</div>



				<!--Setup Application Type Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-table icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Application Family</h2>
					<div class="content-section">
						<p>
							<xsl:variable name="appType" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'type_of_application']/value]"/>
							<xsl:if test="not(count($appType) > 0)">
								<em>Not Defined</em>
							</xsl:if>
							<xsl:value-of select="$appType/own_slot_value[slot_reference = 'name']/value"/>
						</p>
					</div>
					<hr/>
				</div>


				<!--Setup Delivery Model Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-truck icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Delivery Model</h2>
					<div class="content-section">
						<xsl:variable name="delModel" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
						<xsl:if test="not(count($delModel) > 0)">
							<p>
								<em>Not Defined</em>
							</p>
						</xsl:if>
						<xsl:value-of select="$delModel/own_slot_value[slot_reference = 'name']/value"/>
					</div>
					<hr/>
				</div>





				<!--Setup the Supplier section-->
				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-building-o icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Supplier</h2>
					<xsl:variable name="supplier" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'ap_supplier']/value]"/>
					<div class="content-section">
						<p>
							<xsl:if test="not(count($supplier) > 0)">
								<em>Not Defined</em>
							</xsl:if>
							<!--<xsl:value-of select="$supplier/own_slot_value[slot_reference='name']/value" />-->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$supplier"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</p>
					</div>
					<hr/>
				</div>


				<!--Setup the Application Services section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa essicon-radialdots icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Application Services</h2>
					<xsl:variable name="appProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name]"/>
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




				<!--Setup the Codebase section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-code icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Codebase</h2>
					<xsl:variable name="codebase" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
					<div class="content-section">
						<p>
							<xsl:if test="not(count($codebase) > 0)">
								<em>Not Defined</em>
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

				<!--Setup the Business Dependencies section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-users icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Business Dependencies</h2>
					<div class="content-section">
						<p>
							<strong>Business Owner: </strong>
							<xsl:if test="not(count(current()/own_slot_value[slot_reference = 'ap_business_owner']/value) > 0)">
								<em>Not Defined</em>
							</xsl:if>
							<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'ap_business_owner']/value]" mode="Actor"/>
						</p>

						<!-- Get the names of the logical and conceptual processes that the application is supporting 
								Step 1: Call a template passing the BUS_TO_PHYS_PROCESS_RELATION instances associated with the app.
								For each relation, get the physical process, then get the logical process associated with it -->
						<xsl:variable name="appProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name]"/>
						<xsl:variable name="supported_process_list" select="/node()/simple_instance[name = $appProRoles/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value]"/>

						<xsl:choose>
							<xsl:when test="count($supported_process_list) = 0">
								<p>
									<strong>Supported Processes: </strong>
									<em>No supported processes defined.</em>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_SupportedProcesses tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_SupportedProcesses').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "35%" },
									    { "width": "25%" },
									    { "width": "15%" },
									    { "width": "25%" }
									  ],
									dom: 'Bfrtip',
								    buttons: [
							            'copyHtml5', 
							            'excelHtml5',
							            'csvHtml5',
							            'pdfHtml5', 'print'
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
								<table id="dt_SupportedProcesses" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>Supported Processes</th>
											<th>Business Units Supported</th>
											<th>Criticality</th>
											<th>User Locations</th>
										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>Supported Processes</th>
											<th>Business Units Supported</th>
											<th>Criticality</th>
											<th>User Locations</th>
										</tr>
									</tfoot>
									<xsl:apply-templates select="$supported_process_list" mode="Supported_Process"/>
								</table>
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

					<h2 class="text-primary">Stakeholders</h2>

					<div class="content-section">
						<xsl:choose>
							<xsl:when test="count($thisAppStakeholder2Roles) > 0">
								<p><xsl:value-of select="eas:i18n('The table below lists the stakeholders for the')"/>
									<xsl:text> </xsl:text><strong><xsl:value-of select="$appName"/></strong>
									<xsl:text> </xsl:text><xsl:value-of select="eas:i18n('application')"/>.</p>
								<br/>
								<xsl:call-template name="StakeholderTableView"/>
							</xsl:when>
							<xsl:otherwise> - </xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>


				<!--Setup the Strategic Plans section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Strategic Plans</h2>
					<div class="content-section">
						<xsl:apply-templates select="$currentApp/name" mode="StrategicPlansForElement"/>
					</div>
					<hr/>
				</div>




				<!--Setup the Software Architecture Summary section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-gears icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Software Architecture Summary</h2>
					<div class="content-section">
						<xsl:variable name="softwareArch" select="own_slot_value[slot_reference = 'has_software_architecture']/value"/>
						<!-- Software Architecture Image -->
						<xsl:apply-templates select="/node()/simple_instance[name = $softwareArch]" mode="RenderArchitectureImage"/>

						<xsl:choose>
							<xsl:when test="count(own_slot_value[slot_reference = 'has_software_architecture']/value) = 0">
								<p>
									<em>No Software Components Defined for this Application</em>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_supportingSoftware tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table2 = $('#dt_supportingSoftware').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "30%" },
									    { "width": "50%" },
									    { "width": "20%" }
									  ],
									dom: 'Bfrtip',
								    buttons: [
							            'copyHtml5', 
							            'excelHtml5',
							            'csvHtml5',
							            'pdfHtml5', 'print'
							        ]
									});
									
									
									// Apply the search
								    table2.columns().every( function () {
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
								<div class="verticalSpacer_20px"/>
								<p>The following tables describe the high level software components that comprise the <span class="text-primary"><strong><xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></strong></span> module.</p>
								<div class="verticalSpacer_10px"/>
								<table id="dt_supportingSoftware" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Component')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Type')"/>
											</th>
										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Component')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Type')"/>
											</th>
										</tr>
									</tfoot>
									<tbody>
										<!-- Get the set of software components in the architecture -->
										<xsl:for-each select="$soft_components">
											<tr>
												<td>
													<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
												</td>
												<td>
													<xsl:call-template name="RenderMultiLangInstanceDescription">
														<xsl:with-param name="theSubjectInstance" select="current()"/>
													</xsl:call-template>
												</td>
												<td>
													<xsl:value-of select="own_slot_value[slot_reference = 'software_architecture_layer']/value"/>
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



				<!--Setup the Logical Technology Builds section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-sitemap icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Logical Technology Builds</h2>
					<div class="content-section">
						<p>The following sections describe the various logical technology platform configurations for the <span class="text-primary"><strong><xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></strong></span> module.</p>
						<!-- Section to add the set of Logical Technology Builds for the Application Provider -->
						<xsl:variable name="tech_composite_id" select="own_slot_value[slot_reference = 'implemented_with_technology']/value"/>
						<xsl:apply-templates select="/node()/simple_instance[(type = 'Technology_Product_Build_Role') and (own_slot_value[slot_reference = 'implementing_technology_component']/value = $tech_composite_id)]" mode="Logical_Technology_Build_Role"> </xsl:apply-templates>
					</div>
					<hr/>
				</div>




				<!--Setup the Physical Platforms section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-floppy-o icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Physical Technology Platforms</h2>
					<div class="content-section">
						<p> The following tables describe the physical technology platform environments that have been implemented for the <span class="text-primary"><strong><xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></strong></span> module.</p>
						<!-- Get the set of software component usages for the application provider -->
						<!-- <xsl:variable name="soft_component_usages" select="/node()/simple_instance[own_slot_value[slot_reference='contained_in_logical_software_arch']/value=current()/own_slot_value[slot_reference='has_software_architecture']/value]"></xsl:variable> -->
						<!-- DEBUG <xsl:text>SOFTWARE COMPONENT USAGES COUNT: </xsl:text><xsl:value-of select="count($soft_component_usages)"/> -->
						<!-- Get the application deployments that contain the software components of the application provider -->
						<!-- <xsl:variable name="app_deployments" select="/node()/simple_instance[own_slot_value[slot_reference='deployment_of_software_components']/value=$soft_component_usages/own_slot_value[slot_reference='usage_of_software_component']/value]"></xsl:variable> -->
						<!-- 13.11.2008 JWC Find Application deployments via Software components OR by the direct slot from Application Provider -->
						<xsl:variable name="app_deployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'deployment_of_software_components']/value = $soft_component_usages/name or own_slot_value[slot_reference = 'application_provider_deployed']/value = $param1]"/>
						<!-- DEBUG <xsl:text>APPLICATION DEPLOYMENTS COUNT: </xsl:text><xsl:value-of select="count($app_deployments)"/> -->
						<xsl:for-each select="$app_deployments">
							<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value" order="ascending"/>
							<h3>Environment: <span class="light"><xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'application_deployment_role']/value]/own_slot_value[slot_reference = 'enumeration_value']/value"/></span></h3>
							<br/>
							<!-- DEBUG <br/><xsl:text>APP_DEPLOYMENT: </xsl:text><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/> -->
							<!-- get the technology product architecture for the application deployment -->
							<xsl:variable name="app_tech_arch" select="/node()/simple_instance[own_slot_value[slot_reference = 'describes_technology_provider']/value = current()/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
							<!-- get the product  usages for the tech_prod_architecture -->
							<xsl:variable name="tech_prod_usages" select="/node()/simple_instance[name = $app_tech_arch/own_slot_value[slot_reference = 'contained_architecture_components']/value]"/>
							<!-- get the technology instances and nodes that correspond to the set of prod_usages -->
							<xsl:variable name="tech_instances" select="/node()/simple_instance[name = $tech_prod_usages/own_slot_value[slot_reference = 'deployed_technology_instances']/value]"/>
							<!-- 04.04.2008 JWC - Report the set of Application Instances, too -->
							<xsl:variable name="appInstancesInst" select="own_slot_value[slot_reference = 'application_deployment_technology_instance']/value"/>
							<xsl:variable name="appInstances" select="/node()/simple_instance[name = $appInstancesInst]"/>
							<!-- 13.11.2008 JWC - Include Application instances in select of relevent technology nodes -->
							<!-- 
											<xsl:variable name="tech_nodes" select="/node()/simple_instance[name=$tech_instances/own_slot_value[slot_reference='technology_instance_deployed_on_node']/value]"></xsl:variable>
										-->
							<xsl:variable name="tech_nodes" select="/node()/simple_instance[(name = $tech_instances/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value) or (name = $appInstances/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value)]"/>
							<!-- create the HTML table rows and cells for each physical node -->
							<xsl:choose>
								<xsl:when test="count($tech_nodes) = 0">
									<p>
										<em>Environment Not Defined</em>
									</p>
								</xsl:when>
								<xsl:otherwise>
									<div class="simple-scroller">
										<table id="dt_PhysicalTechnologyPlatforms" class="table table-bordered table-striped">
											<thead>
												<tr>
													<th>Physical Node</th>
													<th>Node Technology</th>
													<th>Location</th>
													<th>Instance Name</th>
													<th>Technology Product</th>
													<th>Used As</th>
												</tr>
											</thead>
											<tbody>
												<!-- 21.04.2008 JWC - Sort the physical nodes by their node technology uncomment xsl:sort 
													and include node name in the sort key -->
												<xsl:for-each select="$tech_nodes">
													<xsl:sort select="own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value"/>
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
													<!-- DEBUG <br/><xsl:text>TECH_ NODE: </xsl:text><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/> -->
													<xsl:variable name="node_technology" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'deployment_of']/value]"/>
													<xsl:variable name="node_location" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
													<xsl:variable name="instances_for_node" select="$tech_instances[(own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name) and (own_slot_value[slot_reference = 'technology_instance_of']/value != current()/own_slot_value[slot_reference = 'deployment_of']/value)]"/>
													<!-- 04.04.2008 JWC Add another instance for the application deployment -->
													<!-- Find all Application Instances on this node -->
													<xsl:variable name="deployedApps" select="$appInstances[own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name]"/>
													<xsl:variable name="total_node_instances" select="count($instances_for_node) + count($deployedApps)"/>
													<!-- start an HTML table row -->
													<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
													<!-- add the node name table cell -->
													<td>
														<!-- set the rowspan equal to the number of instances on the node -->
														<xsl:if test="$total_node_instances > 0">
															<xsl:attribute name="rowspan">
																<xsl:value-of select="$total_node_instances"/>
															</xsl:attribute>
														</xsl:if>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="current()"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template>
													</td>
													<!-- add the node technology table cell -->
													<td>
														<xsl:if test="$total_node_instances > 0">
															<xsl:attribute name="rowspan">
																<xsl:value-of select="$total_node_instances"/>
															</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="translate($node_technology/own_slot_value[slot_reference = 'product_label']/value, '::', ' ')"/>
													</td>
													<!-- add the node location table cell -->
													<td>
														<xsl:if test="$total_node_instances > 0">
															<xsl:attribute name="rowspan">
																<xsl:value-of select="$total_node_instances"/>
															</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="$node_location/own_slot_value[slot_reference = 'name']/value"/>
													</td>
													<!-- 04.04.2008 JWC - Add the Application Software Instances -->
													<xsl:for-each select="$deployedApps">
														<!-- add a start row HTML tag if this is not the first technology  instance for the node -->
														<xsl:if test="not(position() = 1)">
															<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
														</xsl:if>
														<xsl:variable name="appDeployTechInst" select="own_slot_value[slot_reference = 'technology_instance_of']/value"/>
														<xsl:variable name="appDeployTech" select="/node()/simple_instance[name = $appDeployTechInst]"/>
														<xsl:variable name="appGivenName" select="own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
														<xsl:variable name="appName">
															<xsl:choose>
																<xsl:when test="string-length($appGivenName) > 0">
																	<xsl:value-of select="$appGivenName"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<td>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="displayString" select="$appName"/>
															</xsl:call-template>
														</td>
														<td>
															<xsl:choose>
																<xsl:when test="count($appDeployTech) > 0">
																	<ul>
																		<xsl:apply-templates select="$appDeployTech" mode="RenderDepTechProduct"/>
																		<!-- <xsl:value-of select="translate($appDeployTech/own_slot_value[slot_reference='product_label']/value, '::', ' ')"/> -->
																	</ul>
																</xsl:when>
																<xsl:otherwise>
																	<p>-</p>
																</xsl:otherwise>
															</xsl:choose>
														</td>
														<!-- Get the deployment status of this technology instance of Application Software -->
														<xsl:variable name="appTechDepStatusInst" select="own_slot_value[slot_reference = 'technology_instance_deployment_status']/value"/>
														<xsl:variable name="deployStat" select="/node()/simple_instance[name = $appTechDepStatusInst]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
														<td><xsl:value-of select="$deployStat"/> Application deployment</td>
														<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
													</xsl:for-each>
													<!-- DEBUG <br/><xsl:text>TOTAL INSTANCES: </xsl:text><xsl:value-of select="count($instances_for_node)"/> -->
													<xsl:if test="count($instances_for_node) &gt; 0">
														<xsl:for-each select="$instances_for_node">
															<xsl:sort select="own_slot_value[slot_reference = 'technology_instance_of']/value"/>
															<xsl:variable name="instance_given_name" select="current()/own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
															<xsl:variable name="instance_name" select="current()/own_slot_value[slot_reference = 'name']/value"/>
															<xsl:variable name="instance_prod_role" select="/node()/simple_instance[name = $tech_prod_usages[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
															<xsl:variable name="tech_product" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
															<xsl:variable name="tech_component" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
															<!-- add a start row HTML tag if this is not the first technology  instance for the node -->
															<xsl:if test="not(position() = 1)">
																<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
															</xsl:if>
															<!-- add the cell for the technology instance name -->
															<xsl:variable name="techInstGivenName" select="own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
															<xsl:variable name="techInstName">
																<xsl:choose>
																	<xsl:when test="string-length($techInstGivenName) > 0">
																		<xsl:value-of select="$techInstGivenName"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:variable>
															<td>
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="current()"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																	<xsl:with-param name="displayString" select="$techInstName"/>
																</xsl:call-template>
															</td>
															<!-- add the cell for the technology product of the technology instance -->
															<td>
																<ul>
																	<xsl:apply-templates select="$tech_product" mode="RenderDepTechProduct"/>
																	<!-- <xsl:value-of select="translate($tech_product/own_slot_value[slot_reference='product_label']/value, '::', ' ')"/> -->
																</ul>
															</td>
															<!-- add the cell for the technology component role that the technology instance is playing  -->
															<td>
																<xsl:value-of select="$tech_component/own_slot_value[slot_reference = 'name']/value"/>
															</td>
															<!-- add the HTML table end row tag -->
															<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
															<!-- DEBUG	<xsl:text>     TECH_ PROD: </xsl:text><xsl:value-of select="$tech_product/own_slot_value[slot_reference='name']/value"/>
															<xsl:text>     TECH_ COMP: </xsl:text><xsl:value-of select="$tech_component/own_slot_value[slot_reference='name']/value"/> -->
														</xsl:for-each>

														<!-- 15.04.2008 JWC Where there are no instances_for_node, check for hardware instances of self, e.g. appliances -->
														<xsl:if test="count($instances_for_node) = 0">
															<xsl:variable name="hwInstances_for_node" select="$tech_instances[(own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name)]"/>
															<xsl:variable name="hwinstance_given_name" select="$hwInstances_for_node/own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
															<xsl:variable name="hwinstance_name" select="$hwInstances_for_node/own_slot_value[slot_reference = 'name']/value"/>
															<xsl:variable name="hwinstance_prod_role" select="/node()/simple_instance[name = $tech_prod_usages[name = $hwInstances_for_node/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
															<xsl:variable name="hwtech_product" select="/node()/simple_instance[name = $hwinstance_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
															<xsl:variable name="hwtech_component" select="/node()/simple_instance[name = $hwinstance_prod_role/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
															<xsl:variable name="hwInstGivenName" select="own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
															<xsl:variable name="hwInstName">
																<xsl:choose>
																	<xsl:when test="string-length($hwInstGivenName) > 0">
																		<xsl:value-of select="$hwInstGivenName"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:variable>
															<!-- add the cell for the technology instance name -->
															<td>
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="current()"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																	<xsl:with-param name="displayString" select="$hwInstName"/>
																</xsl:call-template>
															</td>
															<!-- add the cell for the technology product of the technology instance -->
															<td>
																<ul>
																	<xsl:apply-templates select="$hwtech_product" mode="RenderDepTechProduct"/>
																	<!-- <xsl:value-of select="translate($hwtech_product/own_slot_value[slot_reference='product_label']/value, '::', ' ')"/> -->
																</ul>
															</td>
															<!-- add the cell for the technology component role that the technology instance is playing  -->
															<td>
																<xsl:value-of select="$hwtech_component/own_slot_value[slot_reference = 'name']/value"/>
															</td>
															<!-- add the HTML table end row tag -->
															<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
														</xsl:if>
													</xsl:if>
													<!-- 15.04.2008 JWC - end of special-case code for hardware-only nodes -->
												</xsl:for-each>
											</tbody>
										</table>
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
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


				<!--Sections end-->
			</div>
		</div>

	</xsl:template>

	<!-- TEMPLATE TO CREATE THE SUPPORTED PROCESSES (uses APP_PRO_TO_PHYS_BUS_RELATION nodes)-->
	<!-- 17.04.2008 JWC - Reworked the rendering of this as Applications with many supported processes
	produced an over-busy display -->
	<!-- 06.11.2008	JWC	- Updated to reflect the refactoring of the EA_Relation classes -->
	<xsl:template match="node()" mode="Supported_Process">
		<xsl:variable name="currentApp2PhysProcRel" select="current()"/>
		<xsl:variable name="physProcess" select="$allPhysProcs[name = $currentApp2PhysProcRel/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="logicalProc" select="$allLogicalBusProcs[name = $physProcess/own_slot_value[slot_reference = 'implements_business_process']/value]"/>

		<xsl:variable name="physicalProcessId">
			<xsl:value-of select="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/>
		</xsl:variable>
		<xsl:variable name="logicalProcessId">
			<xsl:value-of select="/node()/simple_instance[name = $physicalProcessId]/own_slot_value[slot_reference = 'implements_business_process']/value"/>
		</xsl:variable>

		<tr>
			<!-- Process -->

			<xsl:choose>
				<xsl:when test="not(count($logicalProc) > 0)">
					<td>-</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$logicalProc"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
						<!--<a>
							<xsl:value-of select="$logBPname" />
						</a>-->
					</td>

				</xsl:otherwise>
			</xsl:choose>


			<!-- Business Unit -->
			<td>
				<xsl:apply-templates select="$physProcess" mode="Actors_to_Roles_from_PhysicalProc"> </xsl:apply-templates>
			</td>

			<!-- Criticality -->
			<td>
				<xsl:if test="not(count($currentApp2PhysProcRel/own_slot_value[slot_reference = 'app_to_process_business_criticality']/value) > 0)">-</xsl:if>
				<xsl:value-of select="/node()/simple_instance[name = $currentApp2PhysProcRel/own_slot_value[slot_reference = 'app_to_process_business_criticality']/value]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
			</td>

			<!-- Location -->
			<td>
				<xsl:apply-templates select="$physProcess" mode="Sites_from_PhysicalProc"> </xsl:apply-templates>
			</td>
		</tr>
	</xsl:template>



	<!-- TEMPLATE TO EXTRACT AN ACTOR_TO_ROLE_RELATIONS FROM A PHYSICAL PROCESS -->
	<xsl:template match="node()" mode="Actors_to_Roles_from_PhysicalProc">
		<xsl:if test="not(count(own_slot_value[slot_reference = 'process_performed_by_actor_role']/value) > 0)">-</xsl:if>
		<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]" mode="Actor_To_Role_Relation"> </xsl:apply-templates>
	</xsl:template>



	<!-- TEMPLATE TO EXTRACT SITES FROM A PHYSICAL PROCESS -->
	<xsl:template match="node()" mode="Sites_from_PhysicalProc">
		<xsl:choose>
			<xsl:when test="count(own_slot_value[slot_reference = 'process_performed_at_sites']/value) > 0">
				<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value]" mode="Site"> </xsl:apply-templates>
			</xsl:when>
			<xsl:when test="count(current()/own_slot_value[slot_reference = 'implements_business_process']/value) > 0">
				<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'implements_business_process']/value]" mode="SiteCategory_from_LogicalProc"> </xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- TEMPLATE TO EXTRACT SITE CATEGORIES FROM A LOGICAL PROCESS -->
	<xsl:template match="node()" mode="SiteCategory_from_LogicalProc">
		<xsl:if test="not(count(own_slot_value[slot_reference = 'process_performed_at_site_categories']/value) > 0)">-</xsl:if>
		<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'process_performed_at_site_categories']/value]" mode="Site"> </xsl:apply-templates>
	</xsl:template>



	<!-- TEMPLATE TO CREATE THE LIST OF ACTORS -->
	<xsl:template match="node()" mode="Actor">
		<xsl:if test="position() != 1">
			<br/>
		</xsl:if>
		<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
		</xsl:call-template>
	</xsl:template>



	<!-- TEMPLATE TO CREATE THE LIST OF SITES -->
	<xsl:template match="node()" mode="Site">
		<xsl:if test="position() != 1">
			<br/>
		</xsl:if>
		<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
		</xsl:call-template>
	</xsl:template>



	<!-- TEMPLATE TO CREATE AN ACTOR FROM AN ACTOR_TO_ROLE_RELATION -->
	<xsl:template match="node()" mode="Actor_To_Role_Relation">
		<xsl:if test="position() != 1">
			<br/>
		</xsl:if>
		<!-- 06.11.2008	JWC replaced the 'FROM' slot with the refactored act_to_role_from_actor slot -->
		<!--<xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference='act_to_role_from_actor']/value]/own_slot_value[slot_reference='name']/value" />-->
		<xsl:variable name="thisActor" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="$thisActor"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
		</xsl:call-template>
	</xsl:template>



	<!-- TEMPLATE TO CREATE THE DETAILS FOR A DEPENDANT INFORMATION REPRESENTATION -->
	<!-- 21.04.2008	JWC - Updated to include link to Information Representation report -->
	<xsl:template match="node()" mode="Info_Representation">
		<xsl:if test="position() != 1">
			<tr>
				<td>&#160;</td>
			</tr>
		</xsl:if>
		<tbody>
			<tr>
				<th class="cellWidth-20pc">Logical Datastore Name</th>
				<td class="cellWidth-80pc">
					<!-- 21.04.2008 JWC - Link to information representation report -->
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<th>Technology Platform</th>
				<xsl:variable name="info_tech_prod_role" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'representation_technology']/value]"/>
				<td>
					<xsl:if test="not(count($info_tech_prod_role) > 0)">-</xsl:if>
					<xsl:value-of select="translate(/node()/simple_instance[name = $info_tech_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]/own_slot_value[slot_reference = 'product_label']/value, '::', ' ')"/>
				</td>
			</tr>
			<tr>
				<th>IT Contact</th>
				<xsl:variable name="rep_it_contact" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'representation_it_contact']/value]"/>
				<td>
					<xsl:if test="not(count($rep_it_contact) > 0)">-</xsl:if>
					<xsl:value-of select="$rep_it_contact/own_slot_value[slot_reference = 'name']/value"/>
				</td>
			</tr>
		</tbody>
	</xsl:template>

	<xsl:template name="StakeholderTableView">
		<table class="table table-striped table-bordered" id="dt_stakeholders">
			<thead>
				<tr>
					<th class="cellWidth-20pc">Role</th>
					<th class="cellWidth-20pc">Name</th>
					<th class="cellWidth-60pc">Email</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$thisAppStakeholder2Roles">
					<xsl:sort select="own_slot_value[slot_reference = 'relation_name']/value"/>
					<xsl:variable name="stakeholderRole" select="$allRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
					<xsl:variable name="stakeholder" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
					<xsl:variable name="stakeholderEmail" select="$stakeholder/own_slot_value[slot_reference = 'email']/value"/>
					<tr>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$stakeholderRole"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$stakeholder"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<a href="mailto:{$stakeholderEmail}">
								<xsl:value-of select="$stakeholderEmail"/>
							</a>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>


	<!-- TEMPLATE TO CREATE APPLCIATIONS THAT THIS APPLICATION RECEIVES DATA FROM -->
	<xsl:template match="node()" mode="Inbound_Applications">
		<!-- DEBUG 
			DEPENDANT APP: <xsl:value-of select="name"/> -->
		<!-- Get the ID of the Dependant App Provider -->
		<xsl:variable name="inboundAppId">
			<xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = ':TO']/value]/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
		</xsl:variable>
		<!-- DEBUG 
					INBOUND APP ID: <xsl:value-of select="$inboundAppId"/> -->

		<!-- Test whether the business owner of the inbound application is external -->
		<!-- Get the ID of the owner Dependant App Provider -->
		<xsl:variable name="appOwnerId">
			<xsl:value-of select="/node()/simple_instance[name = $inboundAppId]/own_slot_value[slot_reference = 'ap_business_owner']/value"/>
		</xsl:variable>
		<!-- DEBUG 
					 APP OWNER ID: <xsl:value-of select="$appOwnerId"/>		-->

		<!-- Print the Application Name if it's owner is internal -->
		<xsl:variable name="appOwner" select="/node()/simple_instance[name = $appOwnerId]"/>
		<xsl:choose>
			<xsl:when test="not($appOwner/own_slot_value[slot_reference = 'actor_external_to_enterprise']/value = 'true')">
				<li>
					<xsl:variable name="app" select="/node()/simple_instance[name = $inboundAppId]"/>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$app"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</li>
			</xsl:when>
			<!--	<xsl:otherwise>-</xsl:otherwise> -->
		</xsl:choose>
	</xsl:template>



	<!-- TEMPLATE TO CREATE APPLICATIONS THAT THIS APPLICATION SENDS DATA TO -->
	<xsl:template match="node()" mode="Outbound_Applications">



		<!-- Get the ID of the Outbound App Provider -->
		<xsl:variable name="outboundAppId">
			<xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = ':FROM']/value]/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
		</xsl:variable>
		<!-- DEBUG 
					OUTBOUND APP ID: <xsl:value-of select="$outboundAppId"/>  -->

		<!-- No need to test whether the business owner of the outbound application is external -->
		<xsl:variable name="app" select="/node()/simple_instance[name = $outboundAppId]"/>
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$app"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
			<!--<a>
				
				<xsl:attribute name="href">
					<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
					<xsl:value-of select="$app/name" />
					<xsl:text>&amp;LABEL=Application Module Definition - </xsl:text>
					<xsl:value-of select="/node()/simple_instance[name = $outboundAppId]/own_slot_value[slot_reference='name']/value" />
				</xsl:attribute>
				<xsl:value-of select="/node()/simple_instance[name = $outboundAppId]/own_slot_value[slot_reference='name']/value" />
			</a>-->
		</li>
	</xsl:template>



	<!-- TEMPLATE TO CREATE EXTERNAL ORGANISATIONS THAT THIS APPLICATION INTERACTS WITH-->
	<xsl:template match="node()" mode="External_Orgs">
		<!-- DEBUG 
			DEPENDANT APP: <xsl:value-of select="name"/> -->
		<!-- Get the ID of the Dependant App Provider -->
		<xsl:variable name="inboundAppId">
			<xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = ':TO']/value]/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
		</xsl:variable>
		<!-- DEBUG 
					INBOUND APP ID: <xsl:value-of select="$inboundAppId"/> -->

		<!-- Test whether the business owner of the inbound application is external -->
		<!-- Get the ID of the owner Dependant App Provider -->
		<xsl:variable name="appOwnerId">
			<xsl:value-of select="/node()/simple_instance[name = $inboundAppId]/own_slot_value[slot_reference = 'ap_business_owner']/value"/>
		</xsl:variable>
		<!-- DEBUG 
					 APP OWNER ID: <xsl:value-of select="$appOwnerId"/>		-->

		<!-- Print the name of the owner if it isinternal -->
		<xsl:choose>
			<xsl:when test="/node()/simple_instance[name = $appOwnerId]/own_slot_value[slot_reference = 'actor_external_to_enterprise']/value = 'true'">
				<li>
					<!--<xsl:value-of select="/node()/simple_instance[name = $appOwnerId]/own_slot_value[slot_reference='name']/value" />-->
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$appOwnerId"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</li>
			</xsl:when>
			<xsl:otherwise>&#160;</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- TEMPLATE TO CREATE STRATEGIC PLAN SECTION-->
	<xsl:template match="node()" mode="Strategic_Plan">
		<table>
			<tr>
				<th>Plan:<br/><span class="smallandlight">(Decommission / Switch Off / Replace / Absorb)</span></th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'strategic_planning_action']/value) > 0)">-</xsl:if>
					<xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'strategic_planning_action']/value]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				</td>
			</tr>
			<tr>
				<th>Planning Comments:</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'comments']/value) > 0)">-</xsl:if>
					<xsl:value-of select="own_slot_value[slot_reference = 'comments']/value"/>
				</td>
			</tr>
			<tr>
				<th>Planned Retirement Date:</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'planned_retirement_date']/value) > 0)">-</xsl:if>
					<xsl:value-of select="own_slot_value[slot_reference = 'planned_retirement_date']/value"/>
				</td>
			</tr>
			<tr>
				<th>Actual Retirement Date</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'actual_retirement_date']/value) > 0)">-</xsl:if>
					<xsl:value-of select="own_slot_value[slot_reference = 'actual_retirement_date']/value"/>
				</td>
			</tr>
		</table>
	</xsl:template>



	<!-- TEMPLATE TO CREATE SERVICE DELIVERY SECTION-->
	<xsl:template match="node()" mode="Service_Delivery">
		<table width="100%">
			<tr>
				<th>Contract Owner:</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'contract_owner']/value) > 0)">-</xsl:if>
					<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'contract_owner']/value]" mode="Actor_To_Role_Relation"/>
				</td>
			</tr>
			<tr>
				<th>Fixed Price Deal in Place:</th>
				<td>
					<xsl:choose>
						<xsl:when test="own_slot_value[slot_reference = 'is_fixed_price_deal']/value = 'true'">&#160;<img src="images/tick_1.gif" width="13" height="13"/></xsl:when>
						<xsl:otherwise>&#160;<img src="images/cross_1.gif" width="13" height="13"/></xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<th>Service Delivery Managers:</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'service_delivery_managers']/value) > 0)">-</xsl:if>
					<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'service_delivery_managers']/value]" mode="Actor"/>
				</td>
			</tr>
			<tr>
				<th>System Managers:</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'internal_managers']/value) > 0)">-</xsl:if>
					<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'internal_managers']/value]" mode="Actor"/>
				</td>
			</tr>
			<tr>
				<th>Service Definition Document:</th>
				<td>
					<xsl:if test="not(count(own_slot_value[slot_reference = 'service_definition_document_ref']/value) > 0)">-</xsl:if>
					<xsl:value-of select="own_slot_value[slot_reference = 'service_definition_document_ref']/value"/>
				</td>
			</tr>
			<tr>
				<th>Business Continuity Plan in Place:</th>
				<td>
					<xsl:choose>
						<xsl:when test="own_slot_value[slot_reference = 'is_business_continuity_plan_in_place']/value = 'true'">&#160;<img src="images/tick_1.gif" width="13" height="13"/></xsl:when>
						<xsl:otherwise>&#160;<img src="images/cross_1.gif" width="13" height="13"/></xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:template>


	<!-- TEMPLATE TO CREATE THE DETAILS OF A LOGICAL TECHNOLOGY BUILDS THAT FULFIL A LOGICAL TECHNOLOGY BUILD ROLE-->
	<xsl:template match="node()" mode="Logical_Technology_Build_Role">
		<xsl:variable name="role_id" select="name"/>

		<xsl:apply-templates select="/node()/simple_instance[(type = 'Technology_Product_Build') and (own_slot_value[slot_reference = 'implements_technology_components']/value = $role_id)]" mode="Logical_Technology_Build"> </xsl:apply-templates>
	</xsl:template>


	<!-- TEMPLATE TO CREATE THE DETAILS OF A LOGICAL TECHNOLOGY BUILD-->
	<xsl:template match="node()" mode="Logical_Technology_Build">
		<!-- Tweaked to include Build Architecture image -->
		<h3>Logical Build Name: <span class="light"><xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></span></h3>
		<xsl:variable name="tech_prod_arch" select="/node()/simple_instance[name = (current()/own_slot_value[slot_reference = 'technology_provider_architecture']/value)]"/>
		<!-- Add the Image for the Technology Build -->
		<xsl:apply-templates select="$tech_prod_arch" mode="RenderArchitectureImage"/>

		<div class="verticalSpacer_20px"/>
		<!-- Table for the details -->
		<script>
				$(document).ready(function(){
					// Setup - add a text input to each footer cell
				    $('#dt_LogicalTechnologyBuild tfoot th').each( function () {
				        var title = $(this).text();
				        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
				    } );
					
					var table3 = $('#dt_LogicalTechnologyBuild').DataTable({
					scrollY: "350px",
					scrollCollapse: true,
					paging: false,
					info: false,
					sort: true,
					responsive: true,
					columns: [
					    { "width": "30%" },
					    { "width": "50%" },
					    { "width": "20%" }
					  ],
					dom: 'Bfrtip',
				    buttons: [
			            'copyHtml5', 
			            'excelHtml5',
			            'csvHtml5',
			            'pdfHtml5', 'print'
			        ]
					});
					
					
					// Apply the search
				    table3.columns().every( function () {
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

		<table id="dt_LogicalTechnologyBuild" class="table table-striped table-bordered">


			<xsl:choose>
				<xsl:when test="count($tech_prod_arch) = 0">
					<tr>
						<td colspan="3">No Logical Architecture Defined</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<thead>
						<tr>
							<th>Technology Capability</th>
							<th>Technology Component</th>
							<th>Technology Product</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<th>Technology Capability</th>
							<th>Technology Component</th>
							<th>Technology Product</th>
						</tr>
					</tfoot>
					<xsl:variable name="tech_prod_role_usages" select="/node()/simple_instance[name = ($tech_prod_arch/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
					<xsl:variable name="tech_prod_roles" select="/node()/simple_instance[name = ($tech_prod_role_usages/own_slot_value[slot_reference = 'provider_as_role']/value)]"/>

					<tbody>
						<xsl:for-each select="$required_tech_caps">
							<xsl:variable name="cap_name" select="current()/name"/>
							<xsl:variable name="all_comps" select="/node()/simple_instance[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = $cap_name]"/>
							<xsl:variable name="roles_for_cap" select="$tech_prod_roles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $all_comps/name]"/>
							<xsl:variable name="comps_for_cap" select="$all_comps[name = $roles_for_cap/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>

							<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
							<td>
								<xsl:if test="count($roles_for_cap) > 0">
									<xsl:attribute name="rowspan">
										<xsl:value-of select="count($roles_for_cap)"/>
									</xsl:attribute>
								</xsl:if>
								<!--<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" />-->
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</td>

							<xsl:choose>
								<xsl:when test="count($roles_for_cap) = 0">
									<td>
										<em>No Components Defined</em>
									</td>
								</xsl:when>

								<xsl:otherwise>
									<xsl:for-each select="$comps_for_cap">

										<xsl:variable name="prodroles_for_comp" select="$roles_for_cap[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
										<xsl:if test="not(position() = 1)">
											<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
										</xsl:if>
										<td>
											<xsl:if test="count($prodroles_for_comp) > 0">
												<xsl:attribute name="rowspan">
													<xsl:value-of select="count($prodroles_for_comp)"/>
												</xsl:attribute>
											</xsl:if>
											<!--<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" />-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</td>
										<td>
											<xsl:for-each select="$prodroles_for_comp">
												<xsl:variable name="prod" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>

												<xsl:if test="not(position() = 1)">
													<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="count($prod) = 0">

														<em>No Products Defined</em>

													</xsl:when>
													<xsl:otherwise>
														<ul>
															<xsl:apply-templates select="$prod" mode="RenderDepTechProduct"/>
															<!-- <xsl:value-of select="translate($prod/own_slot_value[slot_reference='product_label']/value, '::', ' ')"/> -->
														</ul>
													</xsl:otherwise>
												</xsl:choose>

												<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>

											</xsl:for-each>
										</td>
									</xsl:for-each>


								</xsl:otherwise>
							</xsl:choose>
							<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>

						</xsl:for-each>
					</tbody>
				</xsl:otherwise>
			</xsl:choose>
		</table>

	</xsl:template>

	<!-- 19.11.2008 JWC Render a Technology Product with a link. Takes a Technology Product node -->
	<xsl:template match="node()" mode="RenderDepTechProduct">
		<!-- Add hyperlink to product report -->
		<!-- 19.11.2008 JWC Add link to definition -->
		<xsl:variable name="techProdName" select="translate(own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
		<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_prod_def.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="name"/>
			<xsl:text>&amp;LABEL=Technology Product - </xsl:text>
			<xsl:value-of select="$techProdName"/>
		</xsl:variable>

		<!--<a>
			<xsl:attribute name="href" select="$xurl" />
			<xsl:value-of select="$techProdName" />
		</a>-->
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>


</xsl:stylesheet>
