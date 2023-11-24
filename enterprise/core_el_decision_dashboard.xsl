<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value"></xsl:variable>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="decision" select="/node()/simple_instance[supertype = 'Decision']"></xsl:variable>
	<xsl:variable name="status" select="/node()/simple_instance[type = 'Decision_Result']"></xsl:variable>

	<xsl:variable name="elementStyle" select="/node()/simple_instance[type = 'Element_Style']"></xsl:variable>
	
	<xsl:variable name="allComments" select="/node()/simple_instance[type='Commentary']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type='Individual_Actor' or type='Group_Actor']"/>
	<!--
		* Copyright © 2008-2016 Enterprise Architecture Solutions Limited.
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
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:call-template name="RenderModalReportContent">
					<xsl:with-param name="essModalClassNames" select="$linkClasses"></xsl:with-param>
				</xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Decision Dashboard')"/></title>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey">Decision Dashboard</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"></i>
							</div>
							<h2 class="text-primary"><xsl:value-of select="eas:i18n('Decisions')"/></h2>
							<div class="clearfix top-15"></div>
							<table class="table table-striped decisionTable" id="decisionTable">
								<thead>
									<tr>
										<th><xsl:value-of select="eas:i18n('ID')"/></th>
										<th><xsl:value-of select="eas:i18n('Name')"/></th>
										<th><xsl:value-of select="eas:i18n('Description')"/></th>
										<th><xsl:value-of select="eas:i18n('Date')"/></th>
										<th><xsl:value-of select="eas:i18n('Status')"/></th>
										<th>&#160;</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$decision" mode="decisions"></xsl:apply-templates>
								</tbody>
								<tfoot>
									<tr>
										<th><xsl:value-of select="eas:i18n('ID')"/></th>
										<th><xsl:value-of select="eas:i18n('Name')"/></th>
										<th><xsl:value-of select="eas:i18n('Description')"/></th>
										<th><xsl:value-of select="eas:i18n('Date')"/></th>
										<th><xsl:value-of select="eas:i18n('Status')"/></th>
										<th>&#160;</th>
									</tr>
								</tfoot>
							</table>

						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>
				<script>
                        $('document').ready(function () {
                             
                             // Setup - add a text input to each footer cell
							$('#decisionTable tfoot th:not(:last-child)').each( function () {
								var title = $(this).text();
								$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
							} );
							
							var table = $('#decisionTable').DataTable({
							paging: false,
							deferRender:    true,
							scrollY:        350,
							scrollCollapse: true,
							info: true,
							sort: true,
							responsive: false,
							columns: [
								{ "width": "15%" },
								{ "width": "20%" },
								{ "width": "35%" },
								{ "width": "10%" },
								{ "width": "10%" },
								{ "width": "10%","orderable": false }
							  ],
							dom: 'Bfrtip',
							buttons: [
								'copyHtml5', 
								'excelHtml5',
								'csvHtml5',
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

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="node()" mode="decisions">
		<!-- <xsl:variable name="comment" select="$commentary[name=current()/own_slot_value[slot_reference='name']/value]"/>-->
		<xsl:variable name="thisstatus" select="$status[name = current()/own_slot_value[slot_reference = 'decision_result']/value]"></xsl:variable>
		<xsl:variable name="thiselementStyle" select="$elementStyle[name = $thisstatus/own_slot_value[slot_reference = 'element_styling_classes']/value]"></xsl:variable>
		<tr>
			<td>
				<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'governance_reference']/value) = 0">-</xsl:if>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'governance_reference']/value"></xsl:value-of>
			</td>
			<td>
				<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'name']/value) = 0">-</xsl:if>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"></xsl:value-of>
			</td>
			<td>
				<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'description']/value"></xsl:value-of>
			</td>
			<td>
				<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'decision_date_iso_8601']/value) = 0">-</xsl:if>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'decision_date_iso_8601']/value"></xsl:value-of>
			</td>
			<td>
				<xsl:if test="string-length($thisstatus/own_slot_value[slot_reference = 'enumeration_value']/value) = 0">-</xsl:if>
				<span class="label small bg-darkgrey">
					<xsl:attribute name="style">background-color:<xsl:value-of select="$thiselementStyle/own_slot_value[slot_reference = 'element_style_colour']/value"></xsl:value-of>;color:<xsl:value-of select="$thiselementStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"></xsl:value-of></xsl:attribute>
					<xsl:value-of select="$thisstatus/own_slot_value[slot_reference = 'enumeration_value']/value"></xsl:value-of>
				</span>
			</td>
			<td>
				<button class="btn btn-sm btn-default" data-toggle="modal">
					<xsl:attribute name="data-target" select="concat('#modal-',current()/name)"></xsl:attribute>
					<i class="fa fa-info-circle right-5"></i><xsl:value-of select="eas:i18n('Additional Info')"/></button>
					<div class="modal fade" tabindex="-1" role="dialog">
						<xsl:attribute name="id" select="concat('modal-',current()/name)"></xsl:attribute>
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-label="Close">
										<span aria-hidden="true"><i class="fa fa-times"/></span>
									</button>
									<h4 class="modal-title"><strong class="right-5"><xsl:value-of select="eas:i18n('Decision')"/></strong><xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"></xsl:value-of></h4>
								</div>
								<div class="modal-body">
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<p>
										<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
										<xsl:value-of select="current()/own_slot_value[slot_reference = 'description']/value"></xsl:value-of>
									</p>
									<label><xsl:value-of select="eas:i18n('Decision Date')"/></label>
									<p>
										<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'decision_date_iso_8601']/value) = 0">-</xsl:if>
										<xsl:value-of select="current()/own_slot_value[slot_reference = 'decision_date_iso_8601']/value"></xsl:value-of></p>
									<label><xsl:value-of select="eas:i18n('Reference')"/></label>
									<p>
										<xsl:if test="string-length(current()/own_slot_value[slot_reference = 'governance_reference']/value) = 0">-</xsl:if>
										<xsl:value-of select="current()/own_slot_value[slot_reference = 'governance_reference']/value"></xsl:value-of>
									</p>
									<label><xsl:value-of select="eas:i18n('Decision Made By')"/></label>
									<p>
										<xsl:variable name="decisionActor" select="$allActors[name = current()/own_slot_value[slot_reference='decision_made_by_actor']/value]"/>
										<xsl:variable name="decisionActorEmail" select="$decisionActor/own_slot_value[slot_reference='email']/value"/>
										<xsl:if test="string-length($decisionActor) = 0">-</xsl:if>
										<xsl:value-of select="$decisionActor/own_slot_value[slot_reference='name']/value"/>&#160;
										<xsl:if test="string-length($decisionActorEmail) != 0">
											(<a>
												<xsl:attribute name="href">mailto:<xsl:value-of select="$decisionActorEmail"/></xsl:attribute>
												<xsl:value-of select="$decisionActorEmail"/>
											</a>)
										</xsl:if>
									</p>
									<label><xsl:value-of select="eas:i18n('Elements in Scope')"/></label>
									<xsl:if test="count(current()/own_slot_value[slot_reference = 'decision_elements']/value) = 0"><p>-</p></xsl:if>
									<ul>
										<xsl:variable name="decisionElements" select="current()/own_slot_value[slot_reference='decision_elements']/value"/>
										<xsl:for-each select="$decisionElements">
											<xsl:variable name="anElement" select="/node()/simple_instance[name = current()]"/>
											<li>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$anElement"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>											
											</li>
										</xsl:for-each>
									</ul>
									<label><xsl:value-of select="eas:i18n('Comments')"/></label>
									<xsl:if test="count(current()/own_slot_value[slot_reference = 'decision_comments']/value) = 0"><p>-</p></xsl:if>
									<ul class="fa-ul">
									<xsl:for-each select="current()/own_slot_value[slot_reference='decision_comments']/value">
										<xsl:sort select="$allComments[name=current()]/own_slot_value[slot_reference='comment_seq_number']/value"/>
										<xsl:variable name="aComment" select="$allComments[name=current()]"/>
										<li><i class="fa fa-li fa-comment-o"/><xsl:value-of select="$aComment/own_slot_value[slot_reference='name']/value"/></li>
									</xsl:for-each>
									</ul>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-default" data-dismiss="modal"><xsl:value-of select="eas:i18n('Close')"/></button>
								</div>
							</div>
							<!-- /.modal-content -->
						</div>
						<!-- /.modal-dialog -->
					</div>
					<!-- /.modal -->
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
