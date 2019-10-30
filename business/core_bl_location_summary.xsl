<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../business/core_bl_utilities.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
    <xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process','Group_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="allGeoLocation" select="/node()/simple_instance[type='Geographic_Location'][name=$param1]"/>
     <xsl:variable name="allSites" select="/node()/simple_instance[type='Site'][own_slot_value[slot_reference = 'site_geographic_location']/value=$allGeoLocation/name]"/>
    <xsl:variable name="allPhysProcesses" select="/node()/simple_instance[type='Physical_Process'][own_slot_value[slot_reference = 'process_performed_at_sites']/value=$allSites/name]"/>
    <xsl:variable name="allBusProcesses" select="/node()/simple_instance[type='Business_Process'][own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value=$allPhysProcesses/name]"/>
    <xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $allPhysProcesses/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[name = $inScopeCostComponents/own_slot_value[slot_reference = 'cc_cost_component_type']/value]"/>
    <xsl:variable name="defaultCurrencyConstant" select="eas:get_instance_by_name(/node()/simple_instance, 'Report_Constant', 'Default Currency')"/>
	<xsl:variable name="defaultCurrency" select="eas:get_instance_slot_values(/node()/simple_instance, $defaultCurrencyConstant, 'report_constant_ea_elements')"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
    <xsl:variable name="orgs" select="/node()/simple_instance[type='Group_Actor'][own_slot_value[slot_reference='actor_based_at_site']/value=$allSites/name]"/>
    <xsl:variable name="individuals" select="/node()/simple_instance[type='Individual_Actor'][own_slot_value[slot_reference='is_member_of_actor']/value=$orgs/name]"/>  

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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:call-template name="dataTablesLibrary"/>
				<title>Location Summary</title>
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
									<span class="text-primary"><xsl:value-of select="eas:i18n('Location Summary for ')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n($allGeoLocation/own_slot_value[slot_reference='name']/value)"/></span>
								</h1>
							</div>
                            
                       
						</div>
                        
                        <div class="col-xs-4">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Teams at this Location</h2>
							<div class="content-section">
                                <table id="dt_teams" class="table table-striped table-bordered">
								<thead>
									<th>Team </th>
                                   
                                </thead>
                                <tbody>
                                    <xsl:apply-templates select="$orgs" mode="Teams">
										<xsl:sort select="current()/own_slot_value[slot_reference = 'name']/value" order="ascending"/>
									</xsl:apply-templates>
                                </tbody>
                                </table>    
                            </div>
                            <br/>
                        </div>

						<!--Setup Description Section-->
						<div class="col-xs-8">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Business Processes Performed at this Location</h2>
							<div class="content-section">
								
							<table id="dt_processes" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Process')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
                                        </th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Process')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
                                        </th>
									</tr>
								</tfoot>
								<tbody>
									<xsl:apply-templates select="$allBusProcesses" mode="Catalogue">
										<xsl:sort select="current()/own_slot_value[slot_reference = 'name']/value" order="ascending"/>
									</xsl:apply-templates>
								</tbody>
							</table>
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
                <script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_processes tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_processes').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "20%" },
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
								 $('#dt_teams tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_teams').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
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
			</body>
		</html>
	</xsl:template>

    
    <xsl:template match="node()" mode="Catalogue">
		<xsl:variable name="procDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
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
				<xsl:choose>
					<xsl:when test="count($procDesc) = 0">
						<em>-</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
    
<xsl:template match="node()" mode="Teams">
		<xsl:variable name="teamMembers" select="$individuals[own_slot_value[slot_reference='is_member_of_actor']/value=current()/name]"/>
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
		
		</tr>
	</xsl:template>    

</xsl:stylesheet>
