<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Information_Representation', 'Information_Representation_Attribute', 'Data_Representation', 'Data_Representation_Attribute', 'Business_Process', 'Business_Activity', 'Physical_Process', 'Physical_Activity')"/>
	<!-- END GENERIC LINK VARIABLES -->

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

	<xsl:variable name="allAFIs" select="/node()/simple_instance[type = 'Application_Function_Implementation']"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[type = 'Application_Provider' or 'Composite_Application_Provider']"/>
	<xsl:variable name="allAppFunctions" select="/node()/simple_instance[type = 'Application_Function']"/>
	<xsl:variable name="allSoftwareComponents" select="/node()/simple_instance[type = 'Software_Component']"/>
	<xsl:variable name="allAppProToInfoReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
	<xsl:variable name="allInfoRepTypes" select="/node()/simple_instance[type = 'Information_Representation' or 'Information_Representation_Attribute']"/>
	<xsl:variable name="allDataRepTypes" select="/node()/simple_instance[type = 'Data_Representation' or 'Data_Representation_Attribute']"/>
	<xsl:variable name="allAFIDataMappingRelation" select="/node()/simple_instance[type = 'AFI_DATA_MAPPING_RELATION']"/>
	<xsl:variable name="allBusinessProcesses" select="/node()/simple_instance[type = 'Business_Process' or 'Business_Activity']"/>
	<xsl:variable name="allPhysProcesses" select="/node()/simple_instance[type = 'Physical_Process' or 'Physical_Activity']"/>
	<xsl:variable name="allAppFuncImplToBusRelation" select="/node()/simple_instance[type = 'APP_FUNIMPL_TO_BUS_RELATION']"/>

	<xsl:variable name="currentAFI" select="$allAFIs[name = $param1]"/>
	<xsl:variable name="currentAFIName" select="$currentAFI/own_slot_value[slot_reference = 'app_func_impl_name']/value"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<title>
					<xsl:value-of select="eas:i18n('Function Implementation Summary')"/>
				</title>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
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
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span id="viewName">
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Function Implementation Summary')"/>:&#160; <span class="text-primary"><xsl:value-of select="$currentAFIName"/></span></span>
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
								<xsl:if test="string-length($currentAFI/own_slot_value[slot_reference = 'description']/value) = 0">
									<span>-</span>
								</xsl:if>
								<xsl:call-template name="RenderMultiLangInstanceDescription">
									<xsl:with-param name="theSubjectInstance" select="$currentAFI"/>
								</xsl:call-template>
							</div>
							<hr/>
						</div>

						<!--Setup Provided By Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-desktop icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Provided By Application</h2>
							<div class="content-section">
								<p>
									<xsl:variable name="afiAppProvider" select="$allAppProviders[name = $currentAFI/own_slot_value[slot_reference = 'application_function_implementation_provided_by']/value]"/>
									<xsl:choose>
										<xsl:when test="count($afiAppProvider) = 0">
											<span>-</span>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$afiAppProvider"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>




						<!--Setup Implementation Of Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Implementation of Application Function</h2>
							<div class="content-section">
								<xsl:variable name="afiAppFunction" select="$allAppFunctions[name = $currentAFI/own_slot_value[slot_reference = 'implements_application_function']/value]"/>
								<p>
									<xsl:choose>
										<xsl:when test="count($afiAppFunction) = 0">
											<span>-</span>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$afiAppFunction"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>




						<!--Setup Software Component Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-wrench icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Delivered by Software Component</h2>
							<div class="content-section">
								<xsl:variable name="afiSoftwareComp" select="$allSoftwareComponents[name = $currentAFI/own_slot_value[slot_reference = 'inverse_of_delivers_app_func_impl']/value]"/>
								<p>
									<xsl:choose>
										<xsl:when test="count($afiSoftwareComp) = 0">
											<span>-</span>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$afiSoftwareComp"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>




						<!--Setup Support Bus Process Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Supports Business Processes</h2>
							<div class="content-section">
								<xsl:call-template name="supportedProcesess"/>
							</div>
							<hr/>
						</div>




						<!--Setup Auto Bus Process Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Automates Business Processes</h2>
							<div class="content-section">
								<xsl:call-template name="automatedProcesess"/>
							</div>
							<hr/>
						</div>




						<!--Setup Information Used Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-files-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Information Used</h2>
							<div class="content-section">
								<xsl:variable name="afiInformation" select="$allAppProToInfoReps[name = $currentAFI/own_slot_value[slot_reference = 'uses_information_representation']/value]"/>
								<xsl:choose>
									<xsl:when test="count($afiInformation) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<script>
											$(document).ready(function(){
												// Setup - add a text input to each footer cell
											    $('#dt_info tfoot th').each( function () {
											        var title = $(this).text();
											        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
											    } );
												
												var table = $('#dt_info').DataTable({
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
										<table class="table table-striped table-bordered" id="dt_info">
											<thead>
												<tr>
													<th>Name</th>
													<th>Description</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:apply-templates mode="afiInformationRow" select="$afiInformation"/>
											</tbody>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>




						<!--Setup Data Mappings Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-exchange icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Data Mappings</h2>
							<div class="content-section">
								<xsl:variable name="afiDataMapping" select="$allAFIDataMappingRelation[name = $currentAFI/own_slot_value[slot_reference = 'afi_maps_info_data']/value]"/>
								<xsl:choose>
									<xsl:when test="count($afiDataMapping) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<table class="table table-striped table-bordered">
											<thead>
												<tr>
													<th class="cellWidth-45pc">Source</th>
													<th class="cellWidth-5pc">&#160;</th>
													<th class="cellWidth-50pc">Target</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates mode="afiDataMappingRow" select="$afiDataMapping"/>
											</tbody>
										</table>
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

	<xsl:template mode="afiInformationRow" match="node()">
		<xsl:variable name="afiInformation" select="$allInfoRepTypes[name = current()/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
		<xsl:variable name="afiInformationDescription" select="$afiInformation/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="$afiInformation"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($afiInformationDescription) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$afiInformationDescription"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="afiDataMappingRow" match="node()">
		<xsl:variable name="afiSource" select="$allDataRepTypes[name = current()/own_slot_value[slot_reference = 'afi_data_map_source']/value]"/>
		<xsl:variable name="afiTarget" select="$allInfoRepTypes[name = current()/own_slot_value[slot_reference = 'afi_data_map_target']/value]"/>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="count($afiSource) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$afiSource">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theSubjectInstance" select="$afiSource"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<img src="images/GreenArrow.png"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($afiTarget) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$afiTarget">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theSubjectInstance" select="$afiTarget"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="supportedProcesess">
		<xsl:variable name="afiAppFuncImplToBusRelation" select="$allAppFuncImplToBusRelation[name = $currentAFI/own_slot_value[slot_reference = 'supports_business_process_appfunimpl']/value]"/>


		<xsl:choose>
			<xsl:when test="count($afiAppFuncImplToBusRelation) = 0">
				<p>-</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="tableWidth-100pc">
					<thead>
						<tr>
							<th class="cellWidth-30pc">Name</th>
							<th class="cellWidth-70pc">Description</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$afiAppFuncImplToBusRelation">
							<xsl:variable name="relevantPhysProcess" select="$allPhysProcesses[name = current()/own_slot_value[slot_reference = 'appfunimpl_to_physbus_to_busproc']/value]"/>
							<xsl:variable name="afiPhysProcSupportBusProcess" select="$relevantPhysProcess/own_slot_value[slot_reference = 'implements_business_process']/value"/>
							<xsl:variable name="afiPhysProcSupportBusActivity" select="$relevantPhysProcess/own_slot_value[slot_reference = 'instance_of_business_activity']/value"/>
							<xsl:variable name="afiPhysProcSupportBusProcTypes" select="$allBusinessProcesses[name = $afiPhysProcSupportBusProcess or name = $afiPhysProcSupportBusActivity]"/>
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$afiPhysProcSupportBusProcTypes"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$afiPhysProcSupportBusProcTypes/own_slot_value[slot_reference = 'description']/value"/>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="automatedProcesess">
		<xsl:variable name="afiPhysProcAuto" select="$allPhysProcesses[name = $currentAFI/own_slot_value[slot_reference = 'inverse_of_physical_process_automated_by']/value]"/>

		<xsl:choose>
			<xsl:when test="count($afiPhysProcAuto) = 0">
				<p>-</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="tableWidth-100pc">
					<thead>
						<tr>
							<th class="cellWidth-30pc">Name</th>
							<th class="cellWidth-70pc">Description</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$afiPhysProcAuto">
							<xsl:variable name="afiPhysProcAutoBusProcess" select="current()/own_slot_value[slot_reference = 'implements_business_process']/value"/>
							<xsl:variable name="afiPhysProcAutoBusActivity" select="current()/own_slot_value[slot_reference = 'instance_of_business_activity']/value"/>
							<xsl:variable name="afiPhysProcAutoBusProcTypes" select="$allBusinessProcesses[name = $afiPhysProcAutoBusActivity or name = $afiPhysProcAutoBusProcess]"/>
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$afiPhysProcAutoBusProcTypes"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$afiPhysProcAutoBusProcTypes/own_slot_value[slot_reference = 'description']/value"/>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
