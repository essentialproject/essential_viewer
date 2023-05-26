<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<!--<xsl:include href="../application/menus/core_app_provider_menu.xsl" />-->

	<xsl:output method="html"/>


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
	<!-- 05.11.2008 JWC	Upgraded to XSL v2 and added Label to link requests -->
	<!-- 06.11.2008	JWC	Modified to support refactored EA_Relation classes -->
	<!-- 25.11.2009	JWC	Added the Static Application Service Architecture image -->
	<!-- 05.04.2010 JWC	Added panel to show how a composite service is composed -->
	<!-- 25.10.2016 JP	Highlighted standard Applicatons for the App Service in the Implementing Applications ection -->
	<!-- 12.02.2019	JP  Updated to use cpmmon Strategic Plans template-->


	<!-- param1 = the application service that is being summarised -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Function', 'Business_Process', 'Application_Provider', 'Application_Strategic_Plan', 'Enterprise_Strategic_Plan', 'Group_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentService" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="function_list" select="/node()/simple_instance[name = $currentService/own_slot_value[slot_reference = 'provides_application_functions']/value]"/>
	<xsl:variable name="appSvcName" select="$currentService/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $currentService/name]"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[name = $allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allAppFuncImpls" select="/node()/simple_instance[name = $allAppProviders/own_slot_value[slot_reference = 'provides_application_function_implementations']/value]"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[(type = 'Business_Process') or (type = 'Business_Activity')]"/>
	<xsl:variable name="allAppSvc2BusProcs" select="/node()/simple_instance[name = $currentService/own_slot_value[slot_reference = 'supports_business_process_appsvc']/value]"/>

	<xsl:variable name="allAppStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $allAppProRoles/name]"/>
	<xsl:variable name="standardAppProRoles" select="$allAppProRoles[name = $allAppStandards/own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value]"/>
	<xsl:variable name="standardApps" select="$allAppProviders[name = $standardAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allAppStandardOrgs" select="/node()/simple_instance[name = $allAppStandards/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="pageLabel">
					<xsl:value-of select="concat('Application Service Summary for ', $appSvcName)"/>
				</xsl:variable>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="inScopeAppProviders" select="$allAppProviders[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms]"/>
					<xsl:with-param name="inScopeBusProcs" select="$allBusProcs[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeAppProviders" select="$allAppProviders"/>
					<xsl:with-param name="inScopeBusProcs" select="$allBusProcs"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Application Service Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeAppProviders">
			<xsl:value-of select="$allAppProviders"/>
		</xsl:param>
		<xsl:param name="inScopeBusProcs">
			<xsl:value-of select="$allBusProcs"/>
		</xsl:param>

			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<script>
					$(document).ready(function(){
						$('[data-toggle="popover"]').popover(
						{
							container: 'body',
							html: true,
							trigger: 'click',
							title: function ()
							{
								return $(this).parent().next('.popupTitle').html();
							},
							content: function ()
							{
								return $(this).parent().next().next('.popupContent').html();
							}
						});
					});
				</script>
				<style>
					.bg-darkgreen-20 {
						background-color: hsla(130, 50%, 90%, 1)!important;
						color: hsla(130, 50%, 15%, 1);
					}
				</style>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderAppProviderPopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:call-template name="Page_Body">
					<xsl:with-param name="orgName" select="$orgName"/>
					<xsl:with-param name="inScopeAppProviders" select="$inScopeAppProviders"/>
					<xsl:with-param name="inScopeBusProcs" select="$inScopeBusProcs"/>
				</xsl:call-template>
				<!-- PAGE BODY ENDS HERE -->
				<xsl:call-template name="Footer"/>
			</body>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template name="Page_Body">
		<xsl:param name="orgName"/>
		<xsl:param name="inScopeAppProviders"/>
		<xsl:param name="inScopeBusProcs"/>

		<xsl:variable name="inScopeAppSvc2BusProcs" select="$allAppSvc2BusProcs[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $inScopeBusProcs/name]"/>

		<!-- Get the name of the application service -->
		<xsl:variable name="serviceName">
			<xsl:value-of select="$currentService/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>

		<div class="container-fluid">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Service Summary for')"/>&#160;</span>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentService"/>
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
						<xsl:value-of select="eas:i18n('Definition')"/>
					</h2>
					<div class="content-section">
						<p>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="$currentService"/>
							</xsl:call-template>
						</p>
					</div>
					<hr/>
				</div>

				<!--Setup the Functions Provided section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-connections icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Functions Provided')"/>
					</h2>

					<div class="content-section">

						<xsl:choose>
							<xsl:when test="count($function_list) = 0">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No Functions Defined')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<table class="table table-striped table-bordered">

									<thead>
										<tr>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Functions Name')"/>
											</th>
											<th class="cellWidth-70pc">
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="$function_list">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											<tr>
												<td>
													<strong>
														<!--<xsl:value-of select="translate(own_slot_value[slot_reference='name']/value, '::', ' ')" />-->
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
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>



				<!--Setup the Business Processes section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supported Business Processes')"/>
					</h2>

					<div class="content-section">
						<xsl:choose>
							<xsl:when test="count($inScopeAppSvc2BusProcs) = 0">
								<p>
									<em>No Supported Processes</em>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<table class="table table-striped table-bordered">
									<thead>
										<tr>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Business Process Name')"/>
											</th>
											<th class="cellWidth-40pc">
												<xsl:value-of select="eas:i18n('Business Process Description')"/>
											</th>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Service Criticality to Process')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$inScopeAppSvc2BusProcs" mode="Supported_Process">
											
										</xsl:apply-templates>
									</tbody>
								</table>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>





				<!--Setup the Application Providers section - OLDER STYLE VERSION-->

				<!--<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-tablet icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Implemented Applications')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:value-of select="eas:i18n('The following tables describe the applications that are being used to implement the functions of this service')"/>
						</p>
						<xsl:choose>
							<xsl:when test="count($inScopeAppProviders) = 0">
								<p>
									<xsl:value-of select="eas:i18n('No Applications Defined')"/>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<script>
									$(document).ready(function(){
										// Setup - add a text input to each footer cell
									    $('#dt_apps tfoot th').each( function () {
									        var title = $(this).text();
									        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
									    } );
										
										var table = $('#dt_apps').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										paging: false,
										info: false,
										sort: true,
										responsive: true,
										columns: [
										    { "width": "20%" },
										    { "width": "30%" },
										    { "width": "20%" },
										    { "width": "10%" },
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
									    table.columns().every( function () {
									        var that = this;
									 
									        $( 'input', this.footer() ).on( 'keyup change', function () {
									            if ( that.search() !== this.value ) {
									                that
									                    .search( this.value )
									                    .draw();
									            }
									        });
									    });
									    
									    table.columns.adjust();
									    
									    $(window).resize( function () {
									        table.columns.adjust();
									    });
									});
								</script>
								<table class="table table-bordered table-striped" id="dt_apps">
									<!-\- Create the implementing Applications Section -\->
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Application Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Service Functions')"/>
											</th>
											<th><xsl:value-of select="eas:i18n('Implemented')"/>?</th>
											<th>
												<xsl:value-of select="eas:i18n('Application Function Name')"/>
											</th>
										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Application Name')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Service Functions')"/>
											</th>
											<th><xsl:value-of select="eas:i18n('Implemented')"/>?</th>
											<th>
												<xsl:value-of select="eas:i18n('Application Function Name')"/>
											</th>
										</tr>
									</tfoot>
									<tbody>
										<xsl:variable name="impl_app_list" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'provided_by_application_provider']/value]"/>

										<xsl:apply-templates select="$inScopeAppProviders" mode="Implementing_Application"/>
									</tbody>
								</table>
							</xsl:otherwise>
						</xsl:choose>

					</div>
					<hr/>
				</div>-->

				<!--Setup the Application Providers section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-tablet icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Implemented Applications')"/>
					</h2>

					<div class="content-section">
						<xsl:choose>
							<xsl:when test="count($allAppProviders) = 0">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No implemented applications captured')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>
								<p>
									<xsl:value-of select="eas:i18n('The following tables describe the applications that are being used to implement the functions of this service')"/>
								</p>
								<div class="pull-left">
									<div class="keySampleWide bg-darkgreen-20"/>
									<div class="keySampleLabel text-default">
										<xsl:value-of select="eas:i18n('Standard Application')"/>
									</div>
								</div>
								<div class="clearfix" style="margin-bottom: 5px;"/>
								<script>
									$(document).ready(function(){								
										var table = $('#dt_dataObjects').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										scrollX: true,
										paging: false,
										info: false,
										sort: false,
										filter: false,
										autowidth: true,
										fixedColumns: true,
										columns: [
											{ "width": "160px" },
											<xsl:choose>
												<xsl:when test="count($function_list) = 0">
													{ "width": "200px" }
												</xsl:when>
												<xsl:otherwise>
											<xsl:for-each select="$function_list">
												{ "width": "120px" }
												<xsl:if test="position() != last()">,</xsl:if>
											</xsl:for-each>
												</xsl:otherwise>
											</xsl:choose>
										]
										});
									});
								</script>
								<script>
									function setEqualHeight(columns)  
									 {  
									 var tallestcolumn = 0;  
									 columns.each(  
									 function()  
									 {  
									 currentHeight = $(this).height();  
									 if(currentHeight > tallestcolumn)  
									 {  
									 tallestcolumn  = currentHeight;  
									 }  
									 }  
									 );  
									 columns.height(tallestcolumn);  
									 }  
									$(document).ready(function() {  
									 setEqualHeight($(".yAxisLabelBar,.matrixContainer"));
									});
								</script>
								<!--Vertical Align-->
								<script type="text/javascript">
									$('document').ready(function(){
										 $(".xAxisLabelBar").vAlign();
										 $(".yAxisLabelBar").vAlign();
										 $(".matrixEnumIcon").vAlign();
									});
								</script>
								<div class="xAxisLabelBar bg-darkgrey text-white col-xs-11 col-xs-offset-1">
									<strong>
										<xsl:value-of select="eas:i18n('Application Functions')"/>
									</strong>
								</div>
								<div class="yAxisLabelBar bg-darkgrey text-white col-xs-1">
									<div class="vertical-text">
										<strong>
											<xsl:value-of select="eas:i18n('Applications')"/>
										</strong>
									</div>
								</div>
								<div class="matrixContainer no-padding col-xs-11">
									<table class="tableStyleMatrix table table-bordered table-header-background" id="dt_dataObjects">
										<thead>
											<tr>
												<xsl:choose>
													<xsl:when test="count($function_list) = 0">
														<th class="bg-white cellWidth-160">&#160;</th>
														<th class="cellWidth-120">
															<p class="alignLeft">
																<em>
																	<xsl:value-of select="eas:i18n('No functions defined')"/>
																</em>
															</p>
														</th>
													</xsl:when>
													<xsl:otherwise>
														<th class="bg-white cellWidth-160">&#160;</th>
														<xsl:for-each select="$function_list">
															<th class="cellWidth-120" style="line-height: 1.1em;">
																<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
															</th>
														</xsl:for-each>
													</xsl:otherwise>
												</xsl:choose>
											</tr>
										</thead>
										<tbody>
											<xsl:for-each select="$standardApps">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												<xsl:variable name="appFuncImpls" select="$allAppFuncImpls[name = current()/own_slot_value[slot_reference = 'provides_application_function_implementations']/value]"/>
												<xsl:variable name="appProRoleforCurrentApp" select="$standardAppProRoles[(own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name)]"/>
												<xsl:variable name="standardForCurrentApp" select="$allAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $appProRoleforCurrentApp/name]"/>
												<xsl:variable name="thisAppStandardOrgs" select="$allAppStandardOrgs[name = $standardForCurrentApp/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>

												<tr>
													<td style="text-align:left;padding-left: 5px;" class="bg-darkgreen-20">

														<div style="width:140px;" class="pull-left">
															<strong>
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="current()"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																</xsl:call-template>
															</strong>
														</div>
														<div style="width:20px;margin-top:4px;text-align:right;" class="pull-left">
															<i class="fa fa-info-circle impAppsTrigger" data-toggle="popover"/>
														</div>
														<div class="hidden popupTitle">
															<span class="fontBlack uppercase">
																<xsl:value-of select="eas:i18n('Standard for Organisations')"/>
															</span>
														</div>
														<div class="hidden popupContent">
															<xsl:call-template name="RenderStandardAppPopup">
																<xsl:with-param name="orgScope" select="$thisAppStandardOrgs"/>
															</xsl:call-template>
														</div>

													</td>
													<xsl:choose>
														<xsl:when test="count($function_list) = 0">
															<td>&#160;</td>
														</xsl:when>
														<xsl:otherwise>
															<xsl:for-each select="$function_list">
																<td>
																	<xsl:choose>
																		<xsl:when test="current()/name = $appFuncImpls/own_slot_value[slot_reference = 'implements_application_function']/value">
																			<xsl:attribute name="class">image_greenTick</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>&#160; </td>
															</xsl:for-each>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>

											<xsl:for-each select="$allAppProviders except $standardApps">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												<xsl:variable name="appFuncImpls" select="$allAppFuncImpls[name = current()/own_slot_value[slot_reference = 'provides_application_function_implementations']/value]"/>
												<tr>
													<td style="text-align:left;padding-left: 5px;" class="bg-white">
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="current()"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template>
													</td>
													<xsl:choose>
														<xsl:when test="count($function_list) = 0">
															<td>&#160;</td>
														</xsl:when>
														<xsl:otherwise>
															<xsl:for-each select="$function_list">
																<td>
																	<xsl:choose>
																		<xsl:when test="current()/name = $appFuncImpls/own_slot_value[slot_reference = 'implements_application_function']/value">
																			<xsl:attribute name="class">image_greenTick</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>&#160; </td>
															</xsl:for-each>
														</xsl:otherwise>
													</xsl:choose>
												</tr>
											</xsl:for-each>
										</tbody>
									</table>
								</div>

							</xsl:otherwise>
						</xsl:choose>

					</div>
					<div class="clear"/>
					<hr/>
				</div>

				<!-- Setup the related issues table -->
				<xsl:call-template name="RenderIssuesTable">
					<xsl:with-param name="relatedElement" select="$currentService"/>
				</xsl:call-template>


				<!--Setup the Strategic Planning section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Strategic Planning')"/>
					</h2>

					<div class="content-section">
						<xsl:apply-templates select="$currentService" mode="StrategicPlansForElement"/>
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

			</div>
		</div>

		<!--end-->
	</xsl:template>


	<!--Start Supporting Templates-->

	<!-- TEMPLATE TO CREATE THE SUPPORTED PROCESSES (uses :APP_SVC_TO_BUS_RELATION nodes)-->
	<xsl:template match="node()" mode="Supported_Process">

		<!-- 06.11.2008	JWC	Replace the TO slot with the refactored appsvc_to_bus_to_busproc slot -->
		<xsl:variable name="logicalProcess" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value]"> </xsl:variable>
		<tr>
			<td>
				<!--<xsl:value-of select="$logicalProcess/own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$logicalProcess"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count($logicalProcess/own_slot_value[slot_reference = 'name']/value) > 0)">-</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$logicalProcess"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count(current()/own_slot_value[slot_reference = 'app_to_process_business_criticality']/value) > 0)">-</xsl:if>
				<xsl:value-of select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'app_to_process_business_criticality']/value]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
			</td>
		</tr>

	</xsl:template>

	<!-- TEMPLATE TO CREATE THE  DETAILS OF AN IMPLEMENTING APPLICATION -->
	<xsl:template match="node()" mode="Implementing_Application">
		<xsl:variable name="app_func_impls" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'provides_application_function_implementations']/value]"/>
		<xsl:variable name="func_list_size" select="count($function_list)"/>
		<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
		<td>
			<xsl:if test="$func_list_size > 0">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="$func_list_size"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:variable name="appProName" select="own_slot_value[slot_reference = 'name']/value"/>
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
		</td>
		<td>
			<xsl:if test="$func_list_size > 0">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="$func_list_size"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(count(own_slot_value[slot_reference = 'description']/value) > 0)">-</xsl:if>
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</td>
		<xsl:if test="not(count($function_list) > 0)">
			<td>-</td>
			<td>-</td>
			<td>-</td>
			<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
		</xsl:if>
		<xsl:for-each select="$function_list">
			<xsl:if test="position() != 1">
				<xsl:text disable-output-escaping="yes">&#60;tr&#62;</xsl:text>
			</xsl:if>
			<td>
				<em>
					<xsl:value-of select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
				</em>
			</td>
			<xsl:variable name="func_impl" select="$app_func_impls[own_slot_value[slot_reference = 'implements_application_function']/value = current()/name]"/>
			<xsl:choose>
				<xsl:when test="count($func_impl) > 0">
					<!--<td class="image_greenTick">&#160;</td>-->
					<td>Yes</td>
					<td>
						<ul>
							<xsl:for-each select="$func_impl">
								<li>
									<!--<xsl:value-of select="translate(current()/own_slot_value[slot_reference='app_func_impl_name']/value, '::', '  ')" />-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="displayString" select="translate(current()/own_slot_value[slot_reference = 'app_func_impl_name']/value, '::', '  ')"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<!--<td class="image_redCross">&#160;</td>-->
					<td>No</td>
					<td>-</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text disable-output-escaping="yes">&#60;&#47;tr&#62;</xsl:text>
		</xsl:for-each>
	</xsl:template>


	<!-- TEMPLATE TO CREATE SERVICE DELIVERY SECTION-->
	<xsl:template match="node()" mode="Service_Delivery">
		<table class="table table-bordered table-striped">
			<tbody>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Contract Owner')"/>
					</th>
					<td>
						<xsl:if test="not(count(own_slot_value[slot_reference = 'contract_owner']/value) > 0)">-</xsl:if>
						<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'contract_owner']/value]" mode="Actor_To_Role_Relation"/>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-10pc"><xsl:value-of select="eas:i18n('Fixed Price Deal in Place')"/>?</th>
					<xsl:choose>
						<xsl:when test="own_slot_value[slot_reference = 'is_fixed_price_deal']/value = 'true'">
							<td class="image_greenTick">&#160;</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="image_redCross">&#160;</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Service Delivery Managers')"/>
					</th>
					<td>
						<xsl:if test="not(count(own_slot_value[slot_reference = 'service_delivery_managers']/value) > 0)">-</xsl:if>
						<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'service_delivery_managers']/value]" mode="Actor"> </xsl:apply-templates>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('System Managers')"/>
					</th>
					<td>
						<xsl:if test="not(count(own_slot_value[slot_reference = 'internal_managers']/value) > 0)">-</xsl:if>
						<xsl:apply-templates select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'internal_managers']/value]" mode="Actor"> </xsl:apply-templates>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Service Definition Document')"/>
					</th>
					<td>
						<xsl:if test="not(count(own_slot_value[slot_reference = 'service_definition_document_ref']/value) > 0)">-</xsl:if>
						<xsl:value-of select="own_slot_value[slot_reference = 'service_definition_document_ref']/value"/>
					</td>
				</tr>
				<tr>
					<th class="cellWidth-10pc"><xsl:value-of select="eas:i18n('Business Continuity Plan in Place')"/>?</th>
					<xsl:choose>
						<xsl:when test="own_slot_value[slot_reference = 'is_business_continuity_plan_in_place']/value = 'true'">
							<td class="image_greenTick">&#160;</td>
						</xsl:when>
						<xsl:otherwise>
							<td class="image_redCross">&#160;</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</tbody>
		</table>
	</xsl:template>

	<!-- 05.04.2010 JWC -->
	<!-- Render a set of links to the sub Services that make up a Composite Service -->
	<xsl:template match="node()" mode="RenderCompositeSubServices">
		<xsl:param name="anInst" select="name"/>
		<xsl:param name="aSvcName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="xurl">
			<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_service_def.xsl&amp;PMA=</xsl:text>
			<xsl:value-of select="$anInst"/>
			<xsl:text>&amp;LABEL=Application Service - </xsl:text>
			<xsl:value-of select="$aSvcName"/>
		</xsl:variable>
		<tr>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$xurl" />
					</xsl:attribute>
					<span style="font-size: 8pt;font-weight:bold">
						<xsl:value-of select="$aSvcName" />
					</span>
				</a>-->
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
	</xsl:template>

	<!--<!-\- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING STRATEGIC PLAN  -\->
	<!-\- Given a reference (instance ID) to an element, find all its plans and render each -\->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>

		<xsl:variable name="aDirectStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement]"/>

		<xsl:variable name="aStrategicPlanRelSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $anElement]"/>
		<xsl:variable name="aStragegicPlanViaRelSet" select="/node()/simple_instance[name = $aStrategicPlanRelSet/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>

		<xsl:variable name="aStrategicPlanSet" select="$aDirectStrategicPlanSet union $aStragegicPlanViaRelSet"/>
		<!-\- Test to see if any plans are defined yet -\->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-\- Show active plans first -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anActivePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then the future -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $aFuturePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then the old -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anOldPlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then any without a status -\->
				<xsl:apply-templates select="$aStrategicPlanSet[count(own_slot_value[slot_reference = 'strategic_plan_status']/value) = 0]" mode="StrategicPlanDetailsTable"/>

			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No strategic plans defined for this element')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-\- Render the details of a particular strategic plan in a small table -\->
	<!-\- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -\->
	<xsl:template match="node()" mode="StrategicPlanDetailsTable">
		<xsl:param name="theStatus" select="()"/>

		<table class="table table-bordered table-striped">
			<tbody>
				<tr>
					<th class="cellWidth-35pc">
						<xsl:value-of select="eas:i18n('Plan')"/>
					</th>
					<th class="cellWidth-45">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Status')"/>
					</th>
				</tr>
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
					<td>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$theStatus"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>

	</xsl:template>-->

	<!-- Render Popup  Containing the list of Orgs that scope an application standard -->
	<xsl:template name="RenderStandardAppPopup">
		<xsl:param name="orgScope"/>
		<ul>
			<xsl:for-each select="$orgScope">
				<li>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
					</xsl:call-template>
				</li>
			</xsl:for-each>
		</ul>

	</xsl:template>

</xsl:stylesheet>
