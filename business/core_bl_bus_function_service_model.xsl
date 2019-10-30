<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<!-- Sep 2011 Updated to support Essential Viewer version 3-->


	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<!--<xsl:include href="../application/menus/core_app_provider_menu.xsl" />
	<xsl:include href="../business/menus/core_product_type_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Product_Type', 'Application_Provider', 'Group_Actor', 'Individual_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allBusServices" select="/node()/simple_instance[type = 'Product_Type']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
	<xsl:variable name="allIndividualRoles" select="/node()/simple_instance[type = 'Individual_Business_Role']"/>
	<xsl:variable name="allApp2PhysProcs" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allAppProvRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<!--<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name=$viewScopeTerms/name]]" />
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference='name']/value" />
				<xsl:variable name="pageLabel" select="concat('Business Function/Service Model (', $orgScopeTermName, ')')" />
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel" />
					<xsl:with-param name="orgName" select="$orgScopeTermName" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage" />
			</xsl:otherwise>
		</xsl:choose>-->
		<xsl:call-template name="BuildPage"/>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Function/Service Model')"/>
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

				<xsl:call-template name="dataTablesLibrary"/>
				<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_services tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_services').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "25%" },
									    { "width": "25%" },
									    { "width": "25%" },
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
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>

				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderAppProviderPopUpScript" />
				<xsl:call-template name="RenderProductTypePopUpScript" />-->


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

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
											<xsl:value-of select="$pageLabel"/>
										</span>
									</h1>
								</div>
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
								<xsl:value-of select="eas:i18n('Business Function/Service Model')"/>
							</h2>
							<p><xsl:value-of select="eas:i18n('The following table lists the Business Functions/Services for')"/>&#160;<xsl:value-of select="$orgName"/></p>
							<xsl:call-template name="BusinessServiceCatalogue"/>

						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="BusinessServiceCatalogue">
		<table class="table table-striped table-bordered" id="dt_services">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Service')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Actor (Consumer)')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Actor (Provider)')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Supporting Applications')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Service')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Actor (Consumer)')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Actor (Provider)')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Supporting Applications')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:choose>
					<xsl:when test="string-length($viewScopeTermIds) > 0">
						<xsl:variable name="busServices" select="$allBusServices[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
						<xsl:apply-templates select="$busServices" mode="BusinessService">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$allBusServices" mode="BusinessService">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="node()" mode="BusinessService">
		<xsl:variable name="busSvcOrgConsumers" select="$allGroupRoles[name = current()/own_slot_value[slot_reference = 'product_type_target_audience']/value]"/>
		<xsl:variable name="busSvcIndividualConsumers" select="$allIndividualRoles[name = current()/own_slot_value[slot_reference = 'product_type_target_audience']/value]"/>
		<xsl:variable name="busSvcSupportingProcs" select="$allBusProcs[name = current()/own_slot_value[slot_reference = 'product_type_produced_by_process']/value]"/>
		<xsl:variable name="busSvcSupportingGroupRoles" select="$allGroupRoles[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
		<xsl:variable name="busSvcSupportingIndividualRoles" select="$allIndividualRoles[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
		<xsl:variable name="busSvcPhysProcs" select="$allPhysProcs[name = $busSvcSupportingProcs/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
		<xsl:variable name="busSvcApp2PhysProcs" select="$allApp2PhysProcs[name = $busSvcPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
		<xsl:variable name="busSvcAppProRoles" select="$allAppProvRoles[name = $busSvcApp2PhysProcs/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="busSvcAppPros" select="$allAppProviders[name = $busSvcAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<tr>
			<!-- Print out the name of the Business Service -->
			<td>
				<strong>
					<!--<xsl:variable name="bsName" select="current()/own_slot_value[slot_reference='name']/value" />
					<a id="{$bsName}" class="context-menu-prodType menu-1">
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theInstanceID">
								<xsl:value-of select="current()/name" />
							</xsl:with-param>
							<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
							<xsl:with-param name="theParam4" select="$param4" />
							<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
							<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
						</xsl:call-template>
						<xsl:value-of select="$bsName" />
					</a>-->
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>

			<!-- Print out the list of consuming Business Roles for the Business Service -->
			<td>
				<ul>
					<xsl:apply-templates select="$busSvcIndividualConsumers" mode="NameBulletList"/>
					<xsl:apply-templates select="$busSvcOrgConsumers" mode="NameBulletList"/>
				</ul>
			</td>

			<!-- Print out the list of Business Roles supporting the delivery of the Business Service -->
			<td>
				<ul>
					<xsl:apply-templates select="$busSvcSupportingIndividualRoles" mode="NameBulletList"/>
					<xsl:apply-templates select="$busSvcSupportingGroupRoles" mode="NameBulletList"/>
				</ul>
			</td>


			<!-- Print out the list of Application Providers that support the Business Service -->
			<td>
				<ul>
					<xsl:apply-templates select="$busSvcAppPros" mode="AppProviderBulletItem"/>
				</ul>
			</td>
		</tr>
	</xsl:template>


	<!-- GENERIC TEMPLATE TO PRINT OUT THE NAME OF AN ELEMENT AS A BULLETED LIST ITEM -->
	<xsl:template match="node()" mode="AppProviderBulletItem">
		<!--<xsl:variable name="appProName" select="own_slot_value[slot_reference='name']/value" />-->
		<li>
			<!--<a id="{$appProName}" class="context-menu-appProvider menu-1">
				<xsl:call-template name="RenderLinkHref">
					<xsl:with-param name="theInstanceID">
						<xsl:value-of select="name" />
					</xsl:with-param>
					<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
					<xsl:with-param name="theParam4" select="$param4" />
					<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
					<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
				</xsl:call-template>
				<xsl:value-of select="$appProName" />
			</a>-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
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

</xsl:stylesheet>
