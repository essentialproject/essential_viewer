<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<!--<xsl:include href="../information/menus/core_data_subject_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
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
	<xsl:variable name="linkClasses" select="('Data_Subject', 'Data_Object', 'Data_Object_Attribute', 'Group_Actor', 'Individual_Actor', 'Application_Provider', 'Group_Business_Role', 'Individual_Business_Role', 'Business_Process', 'Composite_Application_Provider', 'Data_Representation', 'Data_Representation_Attribute')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentDataObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="dataObjectName" select="$currentDataObject/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="dataAttributes" select="/node()/simple_instance[name = $currentDataObject/own_slot_value[slot_reference = 'contained_data_attributes']/value]"/>
	<xsl:variable name="dataReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'implemented_data_object']/value = $currentDataObject/name]"/>
	<xsl:variable name="allDataRepAttr" select="/node()/simple_instance[type = 'Data_Representation_Attribute']"/>
	<xsl:variable name="app2InfoRep2DataReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value = $dataReps/name]"/>
	<xsl:variable name="containingInfoViews" select="/node()/simple_instance[own_slot_value[slot_reference = 'info_view_supporting_data_objects']/value = $currentDataObject/name]"/>
	<xsl:variable name="implementingInfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_information_views']/value = $containingInfoViews/name]"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = 'Application_Provider' or 'Composite_Application_Provider']"/>
	<xsl:variable name="allAppInforepRels" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
	<xsl:variable name="allPhysProc2Inforeps" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="relevantActor2Roles" select="/node()/simple_instance[name = $currentDataObject/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]"/>
	<xsl:variable name="dataStakeholderRoleType" select="/node()/simple_instance[(type = 'Business_Role_Type') and (own_slot_value[slot_reference = 'name']/value = 'Data Stakeholder')]"/>
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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Data Object Summary')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<script>
					$(function(){
						$('#impactedOrgs').columnize({columns: 2});		
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
				<!--<xsl:call-template name="RenderDataSubjectPopUpScript" />-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<xsl:variable name="dataObjectDesc" select="$currentDataObject/own_slot_value[slot_reference = 'description']/value"/>
				<xsl:variable name="parentSubject" select="/node()/simple_instance[name = $currentDataObject/own_slot_value[slot_reference = 'defined_by_data_subject']/value]"/>
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Data Object Summary for')"/>&#160; </span>
										<span class="text-primary">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
												<xsl:with-param name="theSubjectInstance" select="$currentDataObject"/>
											</xsl:call-template>
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
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:value-of select="$dataObjectDesc"/>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup Parent Data Subject Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Parent Data Subject')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:variable name="dsName" select="$parentSubject/own_slot_value[slot_reference = 'name']/value"/>
								<!--<a id="{$dsName}" class="context-menu-dataSubject menu-1">
										<xsl:call-template name="RenderLinkHref">
											<xsl:with-param name="theInstanceID" select="$parentSubject/name" />
											<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
											<xsl:with-param name="theParam4" select="$param4" />
											<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
											<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
										</xsl:call-template>
										<xsl:value-of select="$dsName" />
									</a>-->
								<ul>
									<xsl:for-each select="$parentSubject">
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</div>
							<hr/>
						</div>


						<!--Setup Data Attributes Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Data Attributes')"/>
							</h2>

							<div class="content-section">
								<xsl:call-template name="dataAttributes"/>
							</div>
							<hr/>
						</div>

						<!--Setup Data Reps Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Data Representations')"/>
							</h2>

							<div class="content-section">
								<xsl:call-template name="dataReps"/>
							</div>
							<hr/>
						</div>


						<!--Setup Stakeholders Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Stakeholders')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="stakeholders"/>
							</div>
							<hr/>
						</div>


						<!--Setup Source of the Truth Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Source of Truth')"/>
							</h2>

							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The source of truth for')"/>&#160;<strong><xsl:value-of select="$dataObjectName"/></strong>&#160; <xsl:value-of select="eas:i18n('data is')"/>&#160; <xsl:call-template name="sourceTruth"/>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup Organisations Impacted Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Organisations Impacted')"/>
							</h2>


							<div class="content-section">
								<xsl:call-template name="orgImpacted"/>
							</div>

							<hr/>
						</div>


						<!--Setup Processes Impacted Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Processes Impacted')"/>
							</h2>


							<div class="content-section">
								<xsl:call-template name="processesImpacted"/>
							</div>

							<hr/>
						</div>



						<!--Setup Systems Impacted Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Systems Impacted')"/>
							</h2>


							<div class="content-section">
								<xsl:call-template name="systemsImpacted"/>
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

	<!--Setup the Data Attributes Template-->
	<xsl:template name="dataAttributes">
		<xsl:choose>
			<xsl:when test="count($dataAttributes) > 0">
				<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_dataAttributes tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
						
						var table = $('#dt_dataAttributes').DataTable({
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
				<div>
					<table class="table table-striped table-bordered" id="dt_dataAttributes">
						<thead>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Attribute Name')"/>
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
									<xsl:value-of select="eas:i18n('Attribute Name')"/>
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
							<xsl:for-each select="$dataAttributes">
								<xsl:variable name="thisDataAtt" select="current()"/>
								<xsl:variable name="dataAttName" select="$thisDataAtt/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="dataAttDesc" select="$thisDataAtt/own_slot_value[slot_reference = 'description']/value"/>
								<xsl:variable name="dataType" select="/node()/simple_instance[name = $thisDataAtt/own_slot_value[slot_reference = 'type_for_data_attribute']/value]"/>
								<xsl:variable name="dataTypeName" select="$dataType/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="dataAttrLabel" select="$thisDataAtt/own_slot_value[slot_reference = 'data_attribute_label']/value"/>
								<tr>
									<td>
										<!--<xsl:value-of select="$dataAttName" />-->
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$thisDataAtt"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="displayString" select="$dataAttrLabel"/>
										</xsl:call-template>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="string-length($dataAttDesc) = 0"> - </xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$dataAttDesc"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="$dataType/type = 'Data_Object'">
												<!--<a>
													<xsl:attribute name="href">
														<xsl:text>report?XML=reportXML.xml&amp;XSL=information/data_object_summary.xsl&amp;PMA=</xsl:text>
														<xsl:value-of select="$dataType/name" />
														<xsl:text>&amp;LABEL=Data Object Summary - </xsl:text>
														<xsl:value-of select="$dataTypeName" />
													</xsl:attribute>
													<xsl:value-of select="$dataTypeName" />
												</a>-->
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$dataType"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$dataTypeName"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<em>
						<xsl:value-of select="eas:i18n('No Data Attributes Defined')"/>
					</em>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="dataReps">
		<xsl:choose>
			<xsl:when test="count($dataReps) > 0">
				<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_dataReps tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
						
						var table = $('#dt_dataReps').DataTable({
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
				<div>
					<table class="table table-striped table-bordered" id="dt_dataReps">
						<thead>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Data Representation')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Representation Attributes')"/>
								</th>
							</tr>
						</thead>
						<tfoot>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Data Representation')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Representation Attritbutes')"/>
								</th>
							</tr>
						</tfoot>
						<tbody>
							<xsl:for-each select="$dataReps">
								<xsl:variable name="this" select="current()"/>
								<xsl:variable name="dataRepName" select="$this/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="dataRepDesc" select="$this/own_slot_value[slot_reference = 'description']/value"/>
							
								<xsl:variable name="dataRepTechnical" select="./own_slot_value[slot_reference = 'dr_technical_name']/value"/>
								
								<xsl:variable name="dataRepLabel">
									<xsl:choose>
										<xsl:when test="string-length($dataRepTechnical) > 0">
											<xsl:value-of select="$dataRepTechnical"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$dataRepName"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="dataRepAttr" select="$allDataRepAttr[name = $this/own_slot_value[slot_reference = 'contained_data_representation_attributes']/value]"/>
								
								<tr>
									<td>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$this"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="displayString" select="$dataRepLabel"/>
										</xsl:call-template>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="string-length($dataRepDesc) = 0"> - </xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$dataRepDesc"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="count($dataRepAttr) = 0">
												<span>-</span>
											</xsl:when>
											<xsl:otherwise>
												<ul>
													<xsl:for-each select="$dataRepAttr">
														<xsl:variable name="thisDRAtt" select="current()"/>
														<xsl:variable name="dataRepAttrTechnical" select="$thisDRAtt/own_slot_value[slot_reference = 'dra_technical_name']/value"/>
														<li>
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="$thisDRAtt"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="displayString" select="$dataRepAttrTechnical"/>
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
					</table>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<em>
						<xsl:value-of select="eas:i18n('No Data Representations Defined')"/>
					</em>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--Setup the Source of the Truth Section-->
	<xsl:template name="sourceTruth">
		<xsl:variable name="sourceOfTruthApp" select="$allApps[name = $currentDataObject/own_slot_value[slot_reference = 'data_object_system_of_record']/value]"/>
		<xsl:variable name="sourceOfTruthAppName" select="$sourceOfTruthApp/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:choose>
			<xsl:when test="count($sourceOfTruthApp) > 0">
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=application/app_data_summary.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="$sourceOfTruthApp/name" />
						<xsl:text>&amp;LABEL=Application Data Summary - </xsl:text>
						<xsl:value-of select="$sourceOfTruthAppName" />
					</xsl:attribute>
					<xsl:value-of select="$sourceOfTruthApp/own_slot_value[slot_reference='name']/value" />
				</a>-->
				<xsl:for-each select="$sourceOfTruthApp">
					<xsl:variable name="this" select="current()"/>
					<xsl:if test="position() > 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$this"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise>
				<strong>
					<xsl:value-of select="eas:i18n('TO BE DEFINED')"/>
				</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--setup organisations impacted section-->
	<xsl:template name="orgImpacted">
		<!-- Get all information views that contain the current data object -->
		<xsl:variable name="infoViews" select="/node()/simple_instance[own_slot_value[slot_reference = 'info_view_supporting_data_objects']/value = $currentDataObject/name]"/>
		<!-- Now intersect these Information Views with the processes that use them -->
		<xsl:variable name="informationViewRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value = $infoViews/name]"/>
		<!-- now get the business processes for the business process to information object relations -->
		<xsl:variable name="busProcs" select="/node()/simple_instance[name = $informationViewRels/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
		<!-- Now get the physical process that implement the business processes -->
		<xsl:variable name="physProcs" select="/node()/simple_instance[name = $busProcs/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
		<!-- Now get the actor to role relations that perform the physical business processes -->
		<xsl:variable name="actorToRoles" select="/node()/simple_instance[name = $physProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<!-- Finally get the actors that are playing the roles -->
		<xsl:variable name="actors" select="/node()/simple_instance[name = $actorToRoles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:choose>
			<xsl:when test="count($actors) > 0">
				<div id="impactedOrgs">
					<ul>
						<xsl:for-each select="$actors">
							<xsl:variable name="this" select="current()"/>
							<li>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$this"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</li>
						</xsl:for-each>
					</ul>
				</div>
				<div class="clear"/>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Organisations Mapped')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Setup impacted processes section-->
	<xsl:template name="processesImpacted">
		<!-- Set the required variables -->
		<xsl:variable name="infoViewsForDataObj" select="/node()/simple_instance[own_slot_value[slot_reference = 'info_view_supporting_data_objects']/value = $param1]"/>
		<xsl:variable name="info2BusProcRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value = $infoViewsForDataObj/name]"/>
		<xsl:choose>
			<xsl:when test="count($info2BusProcRels) > 0">
				<table class="tableStyleCRUD table-header-background col-xs-12">
					<tbody>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('CREATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('READ')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="info2BusProcRelsCREATE" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_creates_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsCREATE" select="$allBusProcs[name = $info2BusProcRelsCREATE/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsCREATE">
										<xsl:variable name="this" select="current()"/>
										<li>
											<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$this"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="info2BusProcRelsREAD" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_reads_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsREAD" select="$allBusProcs[name = $info2BusProcRelsREAD/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsREAD">
										<xsl:variable name="this" select="current()"/>
										<li>
											<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$this"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
						<tr>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
						</tr>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('UPDATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('DELETE')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="info2BusProcRelsUPDATE" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_updates_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsUPDATE" select="$allBusProcs[name = $info2BusProcRelsUPDATE/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsUPDATE">
										<xsl:variable name="this" select="current()"/>
										<li>
											<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$this"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="info2BusProcRelsDELETE" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_deletes_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsDELETE" select="$allBusProcs[name = $info2BusProcRelsDELETE/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsDELETE">
										<xsl:variable name="this" select="current()"/>
										<li>
											<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$this"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="clear"/>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Business Processes Mapped')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--Setup Systems Impacted Section-->
	<xsl:template name="systemsImpacted">
		<!-- Set the variables needed for the system CRUD -->
		<xsl:variable name="app2InfoRep2DataRepsCREATE" select="$app2InfoRep2DataReps[own_slot_value[slot_reference = 'app_pro_creates_data_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsCREATE" select="$allAppInforepRels[(own_slot_value[slot_reference = 'operated_data_reps']/value = $app2InfoRep2DataRepsCREATE/name)]"/>
		<xsl:variable name="app2InfoRep2DataRepsREAD" select="$app2InfoRep2DataReps[own_slot_value[slot_reference = 'app_pro_reads_data_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsREAD" select="$allAppInforepRels[(own_slot_value[slot_reference = 'operated_data_reps']/value = $app2InfoRep2DataRepsREAD/name)]"/>
		<xsl:variable name="app2InfoRep2DataRepsUPDATE" select="$app2InfoRep2DataReps[own_slot_value[slot_reference = 'app_pro_updates_data_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsUPDATE" select="$allAppInforepRels[(own_slot_value[slot_reference = 'operated_data_reps']/value = $app2InfoRep2DataRepsUPDATE/name)]"/>
		<xsl:variable name="app2InfoRep2DataRepsDELETE" select="$app2InfoRep2DataReps[own_slot_value[slot_reference = 'app_pro_deletes_data_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsDELETE" select="$allAppInforepRels[(own_slot_value[slot_reference = 'operated_data_reps']/value = $app2InfoRep2DataRepsDELETE/name)]"/>
		<xsl:choose>
			<xsl:when test="count($app2InfoRep2DataReps) > 0">
				<table class="tableStyleCRUD table-header-background col-xs-12">
					<tbody>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('CREATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('READ')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="appsCREATE" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsCREATE/name]"/>
								<xsl:choose>
									<xsl:when test="count($appsCREATE) > 0">
										<ul>
											<xsl:apply-templates select="$appsCREATE" mode="App_Provider_CRUD_Entry">
												<xsl:sort order="ascending"/>
											</xsl:apply-templates>
										</ul>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="appsREAD" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsREAD/name]"/>
								<xsl:choose>
									<xsl:when test="count($appsREAD) > 0">
										<ul>
											<xsl:apply-templates select="$appsREAD" mode="App_Provider_CRUD_Entry">
												<xsl:sort order="ascending"/>
											</xsl:apply-templates>
										</ul>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
						</tr>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('UPDATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('DELETE')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="appsUPDATE" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsUPDATE/name]"/>
								<xsl:choose>
									<xsl:when test="count($appsUPDATE) > 0">
										<ul>
											<xsl:apply-templates select="$appsUPDATE" mode="App_Provider_CRUD_Entry">
												<xsl:sort order="ascending"/>
											</xsl:apply-templates>
										</ul>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="appsDELETE" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsDELETE/name]"/>
								<xsl:choose>
									<xsl:when test="count($appsDELETE) > 0">
										<ul>
											<xsl:apply-templates select="$appsDELETE" mode="App_Provider_CRUD_Entry">
												<xsl:sort order="ascending"/>
											</xsl:apply-templates>
										</ul>
									</xsl:when>
									<xsl:otherwise>&#160;</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="clear"/>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Applications Mapped')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="node()" mode="App_Provider_CRUD_Entry">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="appName" select="$this/own_slot_value[slot_reference = 'name']/value"/>
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>

	<xsl:template name="stakeholders">
		<xsl:if test="count($relevantActor2Roles) = 0">
			<p>
				<em><xsl:value-of select="eas:i18n('No stakeholders defined for the')"/>&#160; <strong><xsl:value-of select="$dataObjectName"/></strong>&#160;<xsl:value-of select="eas:i18n('Data Object')"/></em>
			</p>

		</xsl:if>
		<xsl:if test="count($relevantActor2Roles) > 0">
			<div>
				<p><xsl:value-of select="eas:i18n('Stakeholders for the ')"/>&#160;<strong><xsl:value-of select="$dataObjectName"/></strong>&#160;<xsl:value-of select="eas:i18n('Data Object')"/></p>
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Role')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Name')"/>
							</th>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Organisation')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="infoStakeholders" select="$relevantActor2Roles">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- Setup Info Stakeholders Content-->
	<xsl:template match="node()" mode="infoStakeholders">
		<xsl:variable name="actor" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="role" select="$allRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
		<xsl:variable name="roleName" select="$role/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="actorName" select="$actor/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="parentOrg" select="$allActors[name = $actor/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
		<xsl:variable name="parentOrgName" select="$parentOrg/own_slot_value[slot_reference = 'name']/value"/>
		<tr>
			<td>
				<!--<xsl:value-of select="$roleName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$role"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<!--<xsl:value-of select="$actorName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$actor"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<!--<xsl:value-of select="$parentOrgName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$parentOrg"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
