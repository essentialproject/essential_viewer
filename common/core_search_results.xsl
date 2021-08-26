<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan xs functx eas" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="SearchQuery"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value"/>

	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="searchClassWhiteListConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Viewer Search Class Inclusion List')]"/>
	<xsl:variable name="searchClassWhiteList" select="$searchClassWhiteListConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value"/>
	<xsl:variable name="searchClassBlackListConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Viewer Search Class Exclusion List')]"/>
	<xsl:variable name="searchClassBlackList" select="$searchClassBlackListConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value"/>


	<xsl:variable name="currentSearch" select="replace(replace($SearchQuery, '[^\c]', ' '), ':', '')"/>
	<xsl:variable name="allInstances" select="//node()/simple_instance"/>
	<xsl:variable name="allValues" select="eas:getAllValues($allInstances)"/>
	<xsl:variable name="matchingInstances" select="$allValues[matches(., $currentSearch, 'i')]/../.."/>
	<!-- <xsl:variable name="matchingClasses" select="$matchingInstances/type"/> -->

	<!-- Get extended search matches -->
	<xsl:variable name="allSWComponentValues" select="//node()/simple_instance[type = 'Software_Component']/*/value"/>
	<xsl:variable name="matchingSWComps" select="$allSWComponentValues[matches(., $currentSearch, 'i')]/../.."/>
	<xsl:variable name="extendedAFIs" select="/node()/simple_instance[own_slot_value[slot_reference = 'inverse_of_delivers_app_func_impl']/value = $matchingSWComps/name]"/>

	<!-- Define the extended terms - union additional matches in the select statement -->
	<xsl:variable name="extendedSearchResults" select="$extendedAFIs except $matchingInstances"/>

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
	<!-- 10.04.2014 NW / JWC	First version of search view -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Search Results</title>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_results tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '<input type="text" placeholder="Search '+title+'"/>' );
					    } );
						
						var table = $('#dt_results').DataTable({
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
				<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_extendedResults tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '<input type="text" placeholder="Search '+title+'"/>' );
					    } );
						
						var table2 = $('#dt_extendedResults').DataTable({
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
					    table2.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    table2.columns.adjust();
					    
					    $(window).resize( function () {
					        table2.columns.adjust();
					    });
					});
				</script>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 class="text-primary">
								<span class="text-primary"><xsl:value-of select="eas:i18n('Search results for')"/>: </span>
								<span class="text-black" style="text-transform: capitalize;">
									<xsl:value-of select="$currentSearch"/>
								</span>
							</h1>
							<table class="table table-striped table-bordered" id="dt_results">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Name')"/>
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
											<xsl:value-of select="eas:i18n('Name')"/>
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
									<xsl:apply-templates mode="searchResultsRow" select="$matchingInstances"/>
								</tbody>
							</table>

							<xsl:if test="count($extendedSearchResults) > 0">
								<div class="verticalSpacer_10px"/>
								<hr/>
								<h1 class="text-primary">Additional Results</h1>
								<p>The results below show object where the term is not directly relevant to the object but may be present in an additional relationship (e.g. the software component of a function implementation).</p>
								<table class="table table-striped table-bordered" id="dt_extendedResults">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Name')"/>
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
												<xsl:value-of select="eas:i18n('Name')"/>
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
										<xsl:apply-templates mode="searchExtendedResultsRow" select="$extendedSearchResults"/>
									</tbody>
								</table>

							</xsl:if>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="searchResultsRow">
		<tr>
			<td style="max-width:300px;overflow:hidden;">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="currentDescription" select="own_slot_value[slot_reference = 'description']/value"/>
				<xsl:choose>
					<xsl:when test="count($currentDescription) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:variable name="currentType" select="type"/>
				<xsl:value-of select="eas:i18n(translate($currentType, '_', ' '))"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="node()" mode="searchExtendedResultsRow">
		<tr>
			<td style="max-width:300px;overflow:hidden;">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="currentDescription" select="own_slot_value[slot_reference = 'description']/value"/>
				<xsl:choose>
					<xsl:when test="count($currentDescription) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:variable name="currentType" select="type"/>
				<xsl:value-of select="eas:i18n(translate($currentType, '_', ' '))"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:function name="eas:getAllValues" as="node()*">
		<xsl:param name="inScopeInstances"/>
		<xsl:choose>
			<xsl:when test="$searchClassWhiteList">
				<xsl:sequence select="$inScopeInstances[type = $searchClassWhiteList]/*/value"/>
			</xsl:when>
			<xsl:when test="$searchClassBlackList">
				<xsl:sequence select="$inScopeInstances[(type = $linkClasses) and not(type = $searchClassBlackList)]/*/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$inScopeInstances[type = $linkClasses]/*/value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
