<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


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
	<!-- 30.09.2016 JP  Created	 -->



	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Representation', 'Application_Provider', 'Composite_Applicaton_Provider')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START CATALOGUE SPECIFIC VARIABLES -->
	<xsl:variable name="infoReps" select="/node()/simple_instance[type = 'Information_Representation']"/>
	<xsl:variable name="app2InfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value = $infoReps/name]"/>
	<xsl:variable name="managingApps" select="/node()/simple_instance[name = $app2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>

	<!-- END CATALOGUE SPECIFIC VARIABLES -->


	<xsl:template match="knowledge_base">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Information Representation Catalogue - Table View')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInstances"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
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
					<div class="row">
						<!--Setup Catalogue Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>

								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogue')"/>
								</h2>

								<div>
									<p><xsl:value-of select="eas:i18n('Select an Information Representation or Application to navigate to the required view')"/>.</p>
									<xsl:call-template name="Index"/>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Index">

		<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_Catalogue tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_Catalogue').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "25%" },
									    { "width": "35%" },
									    { "width": "40%" }
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


		<table class="table table-striped table-bordered" id="dt_Catalogue">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Information Representation')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Managed by Applications')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Information Representation')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Managed by Applications')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:choose>
					<xsl:when test="string-length($viewScopeTermIds) > 0">
						<xsl:apply-templates mode="catalogueRow" select="$infoReps[own_slot_value[slot_reference = 'element_classified_by']/value]">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="catalogueRow" select="$infoReps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

			</tbody>
		</table>

	</xsl:template>

	<xsl:template match="node()" mode="catalogueRow">
		<xsl:variable name="thisApp2InfoReps" select="$app2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value = current()/name]"/>

		<!--<xsl:variable name="programmeProjects" select="$allProgProjects[name=current()/own_slot_value[slot_reference='projects_for_programme']/value]"/>-->
		<xsl:variable name="busCaps" select="$managingApps[name = current()/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

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
			<td>
				<ul>
					<xsl:for-each select="$thisApp2InfoReps">
						<xsl:variable name="currentApp2InfoRep" select="current()"/>
						<xsl:variable name="thisManagingApp" select="$managingApps[name = current()/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
						<xsl:if test="count($thisManagingApp) > 0">
							<li>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$thisManagingApp"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
								<xsl:value-of select="eas:get_inforep_crud_for_app($currentApp2InfoRep)"/>
							</li>
						</xsl:if>
					</xsl:for-each>

				</ul>
			</td>
		</tr>
	</xsl:template>

	<xsl:function name="eas:get_inforep_crud_for_app">
		<xsl:param name="app2InfoRep"/>
		<xsl:text> (</xsl:text><xsl:value-of select="eas:get_crud_style('C', $app2InfoRep/own_slot_value[slot_reference = 'app_pro_creates_info_rep']/value)"/><xsl:value-of select="eas:get_crud_style('R', $app2InfoRep/own_slot_value[slot_reference = 'app_pro_reads_info_rep']/value)"/><xsl:value-of select="eas:get_crud_style('U', $app2InfoRep/own_slot_value[slot_reference = 'app_pro_updates_info_rep']/value)"/><xsl:value-of select="eas:get_crud_style('D', $app2InfoRep/own_slot_value[slot_reference = 'app_pro_deleted_info_rep']/value)"/>) </xsl:function>

	<xsl:function name="eas:get_crud_style">
		<xsl:param name="letter"/>
		<xsl:param name="crudValue"/>

		<xsl:choose>
			<xsl:when test="$crudValue = 'Yes'">
				<span class="textColourRed">
					<xsl:value-of select="$letter"/>
				</span>
			</xsl:when>
			<!--<xsl:otherwise>
				<span class="text-default"><xsl:value-of select="$letter"/></span>
			</xsl:otherwise>-->
		</xsl:choose>

	</xsl:function>

</xsl:stylesheet>
