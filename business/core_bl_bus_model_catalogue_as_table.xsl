<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!--
		* Copyright © 2008-2020 Enterprise Architecture Solutions Limited.
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
	<!-- 22.05.2020 DK  First coding	 -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Model', 'Business_Domain')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="allBusModels" select="/node()/simple_instance[type = 'Business_Model']"/>

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Business Model Catalogue')"/>
	</xsl:variable>
	<xsl:variable name="allBusModelCount" select="count($allBusModels)"/>

	<xsl:variable name="allBusDomains" select="/node()/simple_instance[name = $allBusModels/own_slot_value[slot_reference = 'bm_business_domain']/value]"/>
	<xsl:variable name="allInitiatives" select="/node()/simple_instance[own_slot_value[slot_reference = 'initiative_business_models']/value = $allBusModels/name]"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
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
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>
							<p>
								<xsl:value-of select="eas:i18n('Select a Business Model to navigate to the required view')"/>
							</p>
							<xsl:call-template name="Index"/>
						</div>
						<!--Setup Closing Tags-->
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
			    $('#dt_busModel tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
			    } );
				
				var table = $('#dt_busModel').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "25%" },
				    { "width": "35%" },
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

		<table class="table table-striped table-bordered" id="dt_busModel">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Model')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Domain')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Initiatives')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Business Model')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Domain')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Initiatives')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:apply-templates mode="tableRow" select="$allBusModels">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>

	</xsl:template>

	<xsl:template match="node()" mode="tableRow">
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="thisBusDomain" select="$allBusDomains[name = $this/own_slot_value[slot_reference = 'bm_business_domain']/value]"/>
		<xsl:variable name="thisInitiatives" select="$allInitiatives[own_slot_value[slot_reference = 'initiative_business_models']/value = $this/name]"/>
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
					<xsl:when test="count($thisBusDomain) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="count($targetReport) > 0">
								<xsl:call-template name="RenderMultiLangInstanceName">
									<xsl:with-param name="theSubjectInstance" select="$thisBusDomain"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="theSubjectInstance" select="$thisBusDomain"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>						
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($thisInitiatives) = 0">
						<span>-</span>
					</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:choose>
								<xsl:when test="count($targetReport) > 0">
									<xsl:for-each select="$thisInitiatives">
										<li>
											<xsl:call-template name="RenderMultiLangInstanceName">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>									
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$thisInitiatives">
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>								
								</xsl:otherwise>
							</xsl:choose>	
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>



</xsl:stylesheet>
