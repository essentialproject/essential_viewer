<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/> 
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider','Issue','Group_Actor','Business_Objective_Type','Application_Objective_Type','Technology_Objective_Type','Information_Objective_Type')"/>
 
	<!-- END GENERIC LINK VARIABLES -->
	
	<xsl:variable name="issues" select="/node()/simple_instance[type='Issue']"/>
	<xsl:variable name="risks" select="/node()/simple_instance[type='Risk']"/>
	<xsl:variable name="orgsScope" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')][name=$issues/own_slot_value[slot_reference='sr_org_scope']/value]"/>
	<xsl:variable name="orgsSource" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')][name=$issues/own_slot_value[slot_reference='issue_source']/value]"/>
	<xsl:variable name="orgs" select="$orgsScope union $orgsSource"/>
	<xsl:variable name="status" select="/node()/simple_instance[type='Requirement_Status']"/>

	<xsl:variable name="objectives" select="/node()/simple_instance[supertype=('Business_Objective_Type','Application_Objective_Type','Technology_Objective_Type','Information_Objective_Type')]"/>
	<xsl:variable name="riskCategory" select="/node()/simple_instance[type='Risk_Category']"/>
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
				<title>Issue Register</title>
				<style>
					.scrollableCell{
						overflow-y:scroll; 
						max-height:70px;
					}
					.classType{
						font-size: 0.7em;
					}
					.numberHolderIssue{
						font-size:24pt;
						font-weight: bold;
					}
					.numberHolderRisk{
						font-size:24pt;
						font-weight: bold;
					}
					.numberHolder{
						display: inline-block;
						padding:3px;
						margin:3px;
						width: 100px;
						font-size:1.4em;
						border-radius: 5px;
						border:1px solid #d3d3d3;
						text-align: center;
						vertical-align: middle;

					}
				</style>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Risk &amp; Issue Register')"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
								<ul class="nav nav-tabs">
										<li class="active"><a data-toggle="tab" href="#home"><xsl:value-of select="eas:i18n('Home')"/></a></li>
										<li><a data-toggle="tab" href="#issues"><xsl:value-of select="eas:i18n('Issues')"/></a></li>
										<li><a data-toggle="tab" href="#risks"><xsl:value-of select="eas:i18n('Risks')"/></a></li> 
									  </ul>
									
								<div class="tab-content">
								<div id="home" class="tab-pane fade in active"> 
									<p><xsl:value-of select="eas:i18n('Risk and Issues captured for the organisation')"/></p>
									<div class="numberHolder">Risks
											<div class="numberHolderRisk">0</div>
									</div>
									<div class="numberHolder">Issues
											<div class="numberHolderIssue">0</div>
									</div>
								</div>
								<div id="risks" class="tab-pane fade">
									<h3><xsl:value-of select="eas:i18n('Risks')"/></h3> 
									<table class="table table-striped" id="riskTable">
											<thead>
											<tr>
												<th><xsl:value-of select="eas:i18n('Risk')"/></th>
												<th><xsl:value-of select="eas:i18n('Description')"/></th>
												<th><xsl:value-of select="eas:i18n('Category')"/></th>
												<th><xsl:value-of select="eas:i18n('Mitigation')"/></th>
												<th><xsl:value-of select="eas:i18n('Last Modified')"/></th> 
												<th><xsl:value-of select="eas:i18n('Impacting')"/></th>
												<th><xsl:value-of select="eas:i18n('Objectives')"/></th>
											</tr>
											</thead>
											
											<tbody>
												<xsl:apply-templates select="$risks" mode="risks">
												</xsl:apply-templates>
											</tbody>
											<tfoot>
												<tr>
													<th><xsl:value-of select="eas:i18n('Risk')"/></th>
													<th><xsl:value-of select="eas:i18n('Description')"/></th>
													<th><xsl:value-of select="eas:i18n('Category')"/></th>
													<th><xsl:value-of select="eas:i18n('Mitigation')"/></th>
													<th><xsl:value-of select="eas:i18n('Last Modified')"/></th> 
													<th><xsl:value-of select="eas:i18n('Impacting')"/></th>
													<th><xsl:value-of select="eas:i18n('Objectives')"/></th>
												</tr>
											</tfoot>
									</table>	
								</div>
								<div id="issues" class="tab-pane fade">
									<h3><xsl:value-of select="eas:i18n('Issues')"/></h3>
									<table class="table table-striped" id="issueTable">
											<thead>
											<tr>
												<th><xsl:value-of select="eas:i18n('Issue')"/></th>
												<th><xsl:value-of select="eas:i18n('Org Scope')"/></th>
												<th><xsl:value-of select="eas:i18n('Issue Source')"/></th>
												<th><xsl:value-of select="eas:i18n('Status')"/></th>
												<th><xsl:value-of select="eas:i18n('Priority')"/></th>
												<th><xsl:value-of select="eas:i18n('Last Modified')"/></th>
												<th><xsl:value-of select="eas:i18n('Impacting')"/></th>
											</tr>
											</thead>
											
											<tbody>
												<xsl:apply-templates select="$issues" mode="issues">
			
												</xsl:apply-templates>
											</tbody>
											<tfoot>
												<tr>
													<th><xsl:value-of select="eas:i18n('Issue')"/></th>
													<th><xsl:value-of select="eas:i18n('Org Scope')"/></th>
													<th><xsl:value-of select="eas:i18n('Issue Source')"/></th>
													<th><xsl:value-of select="eas:i18n('Status')"/></th>
													<th><xsl:value-of select="eas:i18n('Priority')"/></th>
													<th><xsl:value-of select="eas:i18n('Last Modified')"/></th>
													<th><xsl:value-of select="eas:i18n('Impacting')"/></th>
												</tr>
											</tfoot>
									</table>			
								</div>
								 
								</div> 
						
						</div>

					
						<!--Setup Closing Tags-->
					</div>
				</div>
							<script>

								var risks=<xsl:value-of select="count($risks)"/>;
								var issues=<xsl:value-of select="count($issues)"/>;
								if(issues);{
								$('.numberHolderIssue').text(issues);
								}
								if(risks);{
								$('.numberHolderRisk').text(risks);
								}
								
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#issueTable tfoot th').each( function () {
										var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#issueTable').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "20%" },								
									    { "width": "15%" },
										{ "width": "15%" },
									    { "width": "7%" },
									    { "width": "7%" },
									    { "width": "7%" },
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
									$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){$($.fn.dataTable.tables(true)).DataTable().columns.adjust();});
								
									$('#riskTable tfoot th').each( function () {
								        var title2 = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title2+'" /&gt;' );
								    } );
									
									var tableRisk = $('#riskTable').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "20%" },								
									    { "width": "15%" },
										{ "width": "7%" },
									    { "width": "7%" },
									    { "width": "7%" },
									    { "width": "15%" },
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
								    tableRisk.columns().every( function () {
								        var that2 = this;
								 
								        $( 'input', this.footer() ).on( 'keyup change', function () {
								            if ( that2.search() !== this.value ) {
								                that2
								                    .search( this.value )
								                    .draw();
								            }
								        } );
								    } );
								    
								    tableRisk.columns.adjust();
								    
								    $(window).resize( function () {
								        tableRisk.columns.adjust();
									});
								
				
									$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){$($.fn.dataTable.tables(true)).DataTable().columns.adjust();});


								});
							</script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="node()" mode="issues">
	<xsl:variable name="thisOrgs" select="$orgsScope[name=current()/own_slot_value[slot_reference='sr_org_scope']/value]"/>
	<xsl:variable name="thisSource" select="$orgsSource[name=current()/own_slot_value[slot_reference='issue_source']/value]"/>
	<xsl:variable name="reqStatus" select="$status[name=current()/own_slot_value[slot_reference='requirement_status']/value]"/>	 
	<xsl:variable name="allimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='sr_requirement_for_elements']/value]"/>
	<!-- support for deprecated slots -->
	<xsl:variable name="busimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_business_elements']/value]"/>	
	<xsl:variable name="appimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_application_elements']/value]"/>	
	<xsl:variable name="techimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_technology_elements']/value]"/>	
	<xsl:variable name="infoimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_information_elements']/value]"/>	
	<xsl:variable name="impacting" select="$allimpacting union $busimpacting union $appimpacting union $techimpacting union $infoimpacting"/>		
	<tr>
		<td><xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template></td>
		<td>
			<div class="scrollableCell">
				<ul><xsl:for-each select="$thisOrgs"><li><xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template></li></xsl:for-each></ul>
			</div>
		</td>
		<td><xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisSource"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template></td>
		<td><xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$reqStatus"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template></td>
		<td>
			<xsl:choose>
			<xsl:when test="current()/own_slot_value[slot_reference='issue_priority']/value='High'"><div class="btn btn-block backColourRed impact">High</div></xsl:when>
			<xsl:when test="current()/own_slot_value[slot_reference='issue_priority']/value='Medium'"><div class="btn btn-block backColourOrange impact">Medium</div></xsl:when>
			<xsl:when test="current()/own_slot_value[slot_reference='issue_priority']/value='Low'"><div class="btn btn-block backColourGreen impact">Low</div></xsl:when><xsl:otherwise><div class="btn btn-block bg-lightgrey impact"><i class="fa fa-warning text-white right-5"/>Not Set</div></xsl:otherwise>	
			</xsl:choose></td><xsl:variable name="dateTime" select="current()/own_slot_value[slot_reference='system_last_modified_datetime_iso8601']/value"></xsl:variable>
		<td><xsl:choose><xsl:when test="contains($dateTime,'T')"><xsl:value-of select="substring-before($dateTime,'T')"/></xsl:when><xsl:otherwise><xsl:value-of select="$dateTime"/></xsl:otherwise></xsl:choose></td>
		<td>
			<div class="scrollableCell">
				<ul>
					<xsl:for-each select="$impacting">
						<li><xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template></li>
					</xsl:for-each>
				</ul>
			</div>
		</td>
	</tr>
	</xsl:template>
	<xsl:template match="node()" mode="risks">
	<xsl:variable name="thisOrgs" select="$orgsScope[name=current()/own_slot_value[slot_reference='sr_org_scope']/value]"/>
	<xsl:variable name="riskMitigation" select="current()/own_slot_value[slot_reference='risk_mitigation_comment']/value"/>
	<xsl:variable name="thisriskCategory" select="$riskCategory[name=current()/own_slot_value[slot_reference='risk_category']/value]"/>	 
	<!-- support for deprecated slots -->
	<xsl:variable name="busimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='risk_related_business']/value]"/>	
	<xsl:variable name="appimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='risk_related_application']/value]"/>	
	<xsl:variable name="techimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='risk_related_technology']/value]"/>	
	<xsl:variable name="infoimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='risk_related_information']/value]"/>	
	<xsl:variable name="supportimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='risk_related_support']/value]"/>		
	<xsl:variable name="controlimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='risk_related_control']/value]"/>	
	<xsl:variable name="thisobjectives" select="$objectives[name=current()/own_slot_value[slot_reference='risk_impacted_objectives']/value]"/>	

	<xsl:variable name="impacting" select="$supportimpacting union $controlimpacting union $busimpacting union $appimpacting union $techimpacting union $infoimpacting"/>		
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
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</td>
		<td>
				<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="$thisriskCategory"/>
						<xsl:with-param name="isRenderAsJSString" select="true()"/>
					</xsl:call-template>
		</td>
		<td>
			<xsl:value-of select="$riskMitigation"/>
		</td>	
	  <xsl:variable name="dateTime" select="current()/own_slot_value[slot_reference='system_last_modified_datetime_iso8601']/value"></xsl:variable>
			<td><xsl:choose><xsl:when test="contains($dateTime,'T')"><xsl:value-of select="substring-before($dateTime,'T')"/></xsl:when><xsl:otherwise><xsl:value-of select="$dateTime"/></xsl:otherwise></xsl:choose></td> 
		<td>
			<div class="scrollableCell">
				<ul>
					<xsl:for-each select="$impacting">
						<li><xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					<span class="classType"> (<xsl:value-of select="translate(current()/type, '_',' ')"/>)</span>
					</li>
					</xsl:for-each>
				</ul>
			</div>
		</td>
		<td>
			<div class="scrollableCell">
				<ul>
					<xsl:for-each select="$thisobjectives">
						<li><xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="targetMenu" select="$targetMenu"/>
								<xsl:with-param name="targetReport" select="$targetReport"/>
							</xsl:call-template></li>
					</xsl:for-each>
				</ul>
			</div>
		</td>
	</tr>
	</xsl:template>
</xsl:stylesheet>
