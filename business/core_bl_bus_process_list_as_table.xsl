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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->



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
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Capability','Business_Process_Family')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START CATALOGUE SPECIFIC VARIABLES -->
	<xsl:variable name="busProcListByName" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Business Process Catalogue by Name')]"/>
	<xsl:variable name="busProcListByServiceCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Business Process Catalogue by Business Service')]"/>
	<xsl:variable name="busProcListByDomain" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Business Process Catalogue by Business Domain')]"/>
    <xsl:variable name="businessProcessFamily" select="/node()/simple_instance[type = 'Business_Process_Family']"/>
	<xsl:variable name="businessProcess" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="realisesCaps" select="/node()/simple_instance[name = $businessProcess/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

	<!-- END CATALOGUE SPECIFIC VARIABLES -->


	<xsl:template match="knowledge_base">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Process Catalogue - Table View')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInstances"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<!--<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>-->
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
								<xsl:if test="not($targetReport/own_slot_value[slot_reference = 'name']/value = 'Core: Business Process Family Summary')">
									<div class="altViewName">
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
										<span class="text-darkgrey">
											<xsl:call-template name="RenderCatalogueLink">
												<xsl:with-param name="theCatalogue" select="$busProcListByName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="targetReport" select="$targetReport"/>
												<xsl:with-param name="targetMenu" select="$targetMenu"/>
												<xsl:with-param name="displayString" select="eas:i18n('Name')"/>
											</xsl:call-template>
										</span>
										<span class="text-darkgrey"> | </span>
										<span class="text-darkgrey">
											<xsl:call-template name="RenderCatalogueLink">
												<xsl:with-param name="theCatalogue" select="$busProcListByDomain"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="targetReport" select="$targetReport"/>
												<xsl:with-param name="targetMenu" select="$targetMenu"/>
												<xsl:with-param name="displayString" select="eas:i18n('Business Domain')"/>
											</xsl:call-template>
										</span>
										<span class="text-darkgrey"> | </span>
										<span class="text-darkgrey">
											<xsl:call-template name="RenderCatalogueLink">
												<xsl:with-param name="theCatalogue" select="$busProcListByServiceCatalogue"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="targetReport" select="$targetReport"/>
												<xsl:with-param name="targetMenu" select="$targetMenu"/>
												<xsl:with-param name="displayString" select="eas:i18n('Business Service')"/>
											</xsl:call-template>
										</span>
										<span class="text-darkgrey"> | </span>
										<span class="text-primary">
											<xsl:value-of select="eas:i18n('Table')"/>
										</span>
									</div>
								</xsl:if>
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
									<p><xsl:value-of select="eas:i18n('Select a Business Process or Business Capability to navigate to the required view')"/>.</p>
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
								    $('#dt_Processes tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_Processes').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "29%" },{ "width": "10%" },
									    { "width": "30%" },
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


		<table class="table table-striped table-bordered" id="dt_Processes">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Process')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Process Family')"/>
					</th>
                    <th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Realises Business Capabilities')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Process')"/>
					</th>
                    <th>
						<xsl:value-of select="eas:i18n('Process Family')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Realises Business Capabilities')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:choose>
					<xsl:when test="string-length($viewScopeTermIds) > 0">
						<xsl:apply-templates mode="processRow" select="$businessProcess[own_slot_value[slot_reference = 'element_classified_by']/value]">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="processRow" select="$businessProcess">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

			</tbody>
		</table>

	</xsl:template>

	<xsl:template match="node()" mode="processRow">
		<xsl:variable name="processDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<!--<xsl:variable name="programmeProjects" select="$allProgProjects[name=current()/own_slot_value[slot_reference='projects_for_programme']/value]"/>-->
		<xsl:variable name="busCaps" select="$realisesCaps[name = current()/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisfamily" select="$businessProcessFamily[own_slot_value[slot_reference='bpf_contained_business_process_types']/value=$this/name]"/>

		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="not($targetReport/own_slot_value[slot_reference = 'name']/value = 'Core: Business Process Family Summary')">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="targetMenu" select="$targetMenu"/>
							<xsl:with-param name="targetReport" select="$targetReport"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
            <td>
            	<xsl:choose>
            		<xsl:when test="$targetReport/own_slot_value[slot_reference = 'name']/value = 'Core: Business Process Family Summary'">
            			<xsl:call-template name="RenderInstanceLink">
            				<xsl:with-param name="theSubjectInstance" select="$thisfamily"/>
            				<xsl:with-param name="theXML" select="$reposXML"/>
            				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
            				<xsl:with-param name="targetMenu" select="$targetMenu"/>
            				<xsl:with-param name="targetReport" select="$targetReport"/>
            			</xsl:call-template>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:call-template name="RenderInstanceLink">
            				<xsl:with-param name="theSubjectInstance" select="$thisfamily"/>
            				<xsl:with-param name="theXML" select="$reposXML"/>
            			</xsl:call-template>
            		</xsl:otherwise>
            	</xsl:choose>
            </td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$busCaps">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>


	</xsl:template>

</xsl:stylesheet>
