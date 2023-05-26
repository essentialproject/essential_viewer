<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<xsl:variable name="linkClasses" select="('Data_Representation', 'Data_Object', 'Data_Subject', 'Information_Store', 'Group_Actor', 'Individual_Actor')"/>
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

	<xsl:variable name="currentPhysDataObj" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[type = 'Data_Object']"/>
	<xsl:variable name="allDataSubjects" select="/node()/simple_instance[type = 'Data_Subject']"/>
	<xsl:variable name="allDataReps" select="/node()/simple_instance[type = 'Data_Representation']"/>
	<xsl:variable name="allInfoStores" select="/node()/simple_instance[type = 'Information_Store']"/>
	<xsl:variable name="implementsDataRep" select="$allDataReps[name = $currentPhysDataObj/own_slot_value[slot_reference = 'implements_data_representation']/value]"/>
	<xsl:variable name="containedInInfoStore" select="$allInfoStores[name = $currentPhysDataObj/own_slot_value[slot_reference = 'contained_in_information_store']/value]"/>
	<xsl:variable name="allServiceQualities" select="/node()/simple_instance[type = 'Information_Service_Quality' or type = 'Service_Quality']"/>
	<xsl:variable name="allServiceQualityValues" select="/node()/simple_instance[type = 'Information_Service_Quality_Value']"/>
	<xsl:variable name="dataQualitiesForPDO" select="$allServiceQualityValues[name = $currentPhysDataObj/own_slot_value[slot_reference = 'physical_data_qualities']/value]"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="orgScope" select="$allGroupActors[name = $currentPhysDataObj/own_slot_value[slot_reference = 'physical_data_org_scope']/value]"/>
	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $currentPhysDataObj/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

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
				<title>Physical Data Object Summary for <xsl:value-of select="$currentPhysDataObj/own_slot_value[slot_reference = 'name']/value"/></title>
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
									<span class="text-darkgrey">Physical Data Object Summary for </span>
									<span class="text-primary">
										<xsl:value-of select="$currentPhysDataObj/own_slot_value[slot_reference = 'name']/value"/>
									</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Description</h2>
							<div class="content-section">
								<p>
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentPhysDataObj"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>



						<!--Setup Data Representation Section-->
						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Implements Data Representation</h2>
							<div class="content-section">
								<p>
									<xsl:if test="count($implementsDataRep) = 0">
										<span>-</span>
									</xsl:if>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theSubjectInstance" select="$implementsDataRep"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Information Store Section-->
						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-database icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Contained in Information Store</h2>
							<div class="content-section">
								<p>
									<xsl:if test="count($containedInInfoStore) = 0">
										<span>-</span>
									</xsl:if>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theSubjectInstance" select="$containedInInfoStore"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Data Qualities Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check-circle-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Data Qualities</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($dataQualitiesForPDO) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<table class="table table-striped table-bordered">
											<thead>
												<tr>
													<th>Type</th>
													<th>Value</th>
													<th>Priority</th>
												</tr>
											</thead>
											<tbody>
												<xsl:apply-templates select="$dataQualitiesForPDO" mode="dataQualitiesRow"/>
											</tbody>
										</table>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup the Org Scope section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Organisational Scope')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($orgScope) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$orgScope">
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="theSubjectInstance" select="current()"/>
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

	<xsl:template mode="dataQualitiesRow" match="node()">
		<xsl:variable name="serviceQualityType" select="$allServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
		<tr>
			<td>
				<xsl:value-of select="$serviceQualityType/own_slot_value[slot_reference = 'name']/value"/>
			</td>
			<td>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>
			</td>
			<td>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_priority']/value"/>
			</td>
		</tr>

	</xsl:template>

</xsl:stylesheet>
