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
	<xsl:variable name="linkClasses" select="('Data_Representation', 'Data_Object', 'Data_Subject', 'Group_Actor', 'Individual_Actor', 'Data_Object_Attribute', 'Physical_Data_Object', 'Information_Store')"/>
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

	<xsl:variable name="currentDataRep" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[type = 'Data_Object']"/>
	<xsl:variable name="allDataSubjects" select="/node()/simple_instance[type = 'Data_Subject']"/>
	<xsl:variable name="allDataRepAttributes" select="/node()/simple_instance[type = 'Data_Representation_Attribute']"/>
	<xsl:variable name="allDataObjAttributes" select="/node()/simple_instance[type = 'Data_Object_Attribute']"/>
	<xsl:variable name="allPhysicalDataObjects" select="/node()/simple_instance[type = 'Physical_Data_Object']"/>
	<xsl:variable name="allInfoStores" select="/node()/simple_instance[type = 'Information_Store']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="implDataObjects" select="$allDataObjects[name = $currentDataRep/own_slot_value[slot_reference = 'implemented_data_object']/value]"/>
	<xsl:variable name="containedDataRepAttr" select="$allDataRepAttributes[name = $currentDataRep/own_slot_value[slot_reference = 'contained_data_representation_attributes']/value]"/>
	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $currentDataRep/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="implementedPhysicalDataObjects" select="$allPhysicalDataObjects[own_slot_value[slot_reference = 'implements_data_representation']/value = $currentDataRep/name]"/>

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
				<title>Data Representation Summary</title>
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
									<span class="text-darkgrey">Data Representation Summary for </span>
									<span class="text-primary">
										<xsl:value-of select="$currentDataRep/own_slot_value[slot_reference = 'name']/value"/>
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
										<xsl:with-param name="theSubjectInstance" select="$currentDataRep"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Technical Name Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-pencil-square-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Technical Name</h2>
							<div class="content-section">
								<xsl:variable name="dataRepTechName" select="$currentDataRep/own_slot_value[slot_reference = 'dr_technical_name']/value"/>
								<p>
									<xsl:if test="string-length($dataRepTechName) = 0">
										<span>-</span>
									</xsl:if>
									<xsl:value-of select="$dataRepTechName"/>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Implemented Data Objects Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Implemented Data Objects</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($implDataObjects) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<table class="table table-striped table-bordered" id="dt_dataObjs">
											<thead>
												<tr>
													<th>Data Object</th>
													<th>Description</th>
													<th>Parent Subject</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>Data Object</th>
													<th>Description</th>
													<th>Parent Subject</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:apply-templates mode="implDataObjectRow" select="$implDataObjects"/>
											</tbody>
										</table>
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_dataObjs tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_dataObjs').DataTable({
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
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup Data Attributes Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Data Representation Attributes</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($containedDataRepAttr) = 0">
										<p>-</p>
									</xsl:when>
									<xsl:otherwise>
										<table class="table table-striped table-bordered" id="dt_dataAttr">
											<thead>
												<tr>
													<th>Attribute</th>
													<th>Description</th>
													<th>Technical Name</th>
													<th>Implemented Data Object Attribute</th>
													<th>Parent Data Object</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>Attribute</th>
													<th>Description</th>
													<th>Technical Name</th>
													<th>Implemented Data Object Attribute</th>
													<th>Parent Data Object</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:apply-templates mode="dataAttrRow" select="$containedDataRepAttr"/>
											</tbody>
										</table>
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_dataAttr tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_dataAttr').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "20%" },
											    { "width": "20%" },
											    { "width": "20%" },
											    { "width": "20%" },
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
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
										        table.columns.adjust();
										    });
										});
									</script>
									</xsl:otherwise>
								</xsl:choose>


							</div>
							<hr/>
						</div>

						<!--Setup Physical Data Objects Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Physical Data Objects</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($implementedPhysicalDataObjects) = 0">
										<span>-</span>
									</xsl:when>
									<xsl:otherwise>
										<table class="table table-striped table-bordered" id="dt_physDataObjects">
											<thead>
												<tr>
													<th>Physical Data Object</th>
													<th>Description</th>
													<th>Information Store</th>
													<th>Organisational Scope</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>Physical Data Object</th>
													<th>Description</th>
													<th>Information Store</th>
													<th>Organisational Scope</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:apply-templates mode="physDataObjRow" select="$implementedPhysicalDataObjects"/>
											</tbody>
										</table>
										<script>
										$(document).ready(function(){
											// Setup - add a text input to each footer cell
										    $('#dt_physDataObjects tfoot th').each( function () {
										        var title = $(this).text();
										        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
										    } );
											
											var table = $('#dt_physDataObjects').DataTable({
											scrollY: "350px",
											scrollCollapse: true,
											paging: false,
											info: false,
											sort: true,
											responsive: true,
											columns: [
											    { "width": "20%" },
											    { "width": "20%" },
											    { "width": "20%" },
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
										        } );
										    } );
										    
										    table.columns.adjust();
										    
										    $(window).resize( function () {
										        table.columns.adjust();
										    });
										});
									</script>
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

	<xsl:template mode="implDataObjectRow" match="node()">
		<xsl:variable name="parentSubjects" select="$allDataSubjects[name = current()/own_slot_value[slot_reference = 'defined_by_data_subject']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="count($parentSubjects) = 0">
					<span>-</span>
				</xsl:if>
				<ul>
					<xsl:for-each select="$parentSubjects">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="dataAttrRow" match="node()">
		<xsl:variable name="implDataObjcAttr" select="$allDataObjAttributes[name = current()/own_slot_value[slot_reference = 'implemented_data_object_attribute']/value]"/>
		<xsl:variable name="implDataObjectAttrParent" select="$allDataObjects[name = $implDataObjcAttr/own_slot_value[slot_reference = 'belongs_to_data_object']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'dra_technical_name']/value"/>
			</td>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="$implDataObjcAttr"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="$implDataObjectAttrParent"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="physDataObjRow" match="node()">
		<xsl:variable name="infoStore" select="$allInfoStores[name = current()/own_slot_value[slot_reference = 'contained_in_information_store']/value]"/>
		<xsl:variable name="orgScope" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'physical_data_org_scope']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="current()"/>
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
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="theSubjectInstance" select="$infoStore"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($orgScope) = 0">
						<span>-</span>
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


			</td>
		</tr>


	</xsl:template>

</xsl:stylesheet>
