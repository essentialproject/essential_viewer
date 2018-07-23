<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../business/core_bl_utilities.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Application_Service')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>

	<xsl:variable name="appListByAppFamilyCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Provider Catalogue by Application Family')]"/>
	<xsl:variable name="appListByName" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Provider Catalogue by Name')]"/>
	<xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
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
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Application Catalogue')"/>
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
										<xsl:value-of select="eas:i18n('Application Catalogue as Table')"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$appListByName"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="eas:i18n('Name')"/>
									</xsl:call-template>
									<span class="text-darkgrey"> | </span>
									<xsl:call-template name="RenderCatalogueLink">
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="theCatalogue" select="$appListByAppFamilyCatalogue"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="targetReport" select="$targetReport"/>
										<xsl:with-param name="targetMenu" select="$targetMenu"/>
										<xsl:with-param name="displayString" select="eas:i18n('Application Family')"/>
									</xsl:call-template>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Table')"/>
									</span>
								</div>
							</div>
						</div>

						<!--Setup table Section-->
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>


							<p><xsl:value-of select="eas:i18n('This table lists all the Applications in use and allows search as well as copy to spreadsheet')"/>.</p>
							<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_apps tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_apps').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "20%" },
									    { "width": "40%" },
                                        { "width": "25%" },
									    { "width": "15%" }
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
							<table id="dt_apps" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Application')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Services Provided')"/>
										</th>
    									<th>
											<xsl:value-of select="eas:i18n('Status')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Application')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Services Provided')"/>
										</th>
    									<th>
											<xsl:value-of select="eas:i18n('Status')"/>
										</th>
                                    </tr>
								</tfoot>
								<tbody>
									<xsl:apply-templates select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]" mode="Catalogue">
										<xsl:sort select="current()/own_slot_value[slot_reference = 'name']/value" order="ascending"/>
									</xsl:apply-templates>
								</tbody>
							</table>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="Catalogue">
		<xsl:variable name="appDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
        <xsl:variable name="appStatus">
			<xsl:value-of select="own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>
		</xsl:variable>
		<xsl:variable name="thisAppProvRoles" select="$allAppProviderRoles[name = current()/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
		<xsl:variable name="thisAppServices" select="$allAppServices[name = $thisAppProvRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]"/>
  
        <tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template>
			</td>
			<td>
		 
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
 
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($thisAppServices) = 0">
						
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$thisAppServices">
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
			</td>
            <xsl:variable name="thisLife"><xsl:value-of select="$lifecycle[name=$appStatus]/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:variable>
            <xsl:variable name="colour">
                <xsl:choose>
                    <xsl:when test="$thisLife='Production'">#79b571</xsl:when>
                    <xsl:when test="$thisLife='Off Strategy'">#ef8e8e</xsl:when>
                    <xsl:when test="$thisLife='Pilot'">#cce8c8</xsl:when>
                    <xsl:when test="$thisLife='Prototype'">#aec7e3</xsl:when>
                    <xsl:when test="$thisLife='Sunset'">#f5e6a5</xsl:when>
                    <xsl:when test="$thisLife='Retired'">darkgrey</xsl:when>
                    <xsl:otherwise>#ffffff</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <td style="background-color:{$colour}">
				<xsl:choose>
					<xsl:when test="$appStatus = ''">
						 
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$thisLife"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
        
	</xsl:template>

</xsl:stylesheet>
