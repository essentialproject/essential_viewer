<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html"/>
	<!-- param1 provides the Id of the Application for which information and data details are being provided -->
	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_View', 'Information_Concept', 'Group_Actor', 'Data_Object', 'Application_Provider', 'Information_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Get the Application Provider for param1 -->
	<xsl:variable name="allApps" select="/node()/simple_instance[type = 'Application_Provider' or 'Composite_Application_Provider']"/>
	<xsl:variable name="currentApp" select="$allApps[name = $param1]"/>
	<xsl:variable name="currentAppName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
	<!-- Get all Data Sets needed to minimise having to traverse the whole document -->
	<xsl:variable name="allApp2InfoReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
	<xsl:variable name="allApp2Info2DataReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_TO_DATAREP_RELATION']"/>
	<xsl:variable name="allAcquisitionMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[type = 'Information_Representation']"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[type = 'Information_View']"/>
	<xsl:variable name="allInfoStores" select="/node()/simple_instance[type = 'Information_Store']"/>
	<xsl:variable name="allDataReps" select="/node()/simple_instance[type = 'Data_Representation']"/>
	<xsl:variable name="allDataObjs" select="/node()/simple_instance[type = 'Data_Object']"/>
	<xsl:variable name="allPhysData" select="/node()/simple_instance[type = 'Physical_Data_Object']"/>
	<xsl:variable name="allServiceQuals" select="/node()/simple_instance[type = 'Information_Service_Quality_Value']"/>
	<xsl:variable name="allOrgs" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="timelinessQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Timeliness')]"/>
	<xsl:variable name="granularityQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Granularity')]"/>
	<xsl:variable name="completenessQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Completeness')]"/>
  
	<xsl:variable name="allApp2PhysProcs" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>

	<xsl:variable name="appInfoDataDepsReport" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Application Information Dependency Model')]"/>




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
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Information/Data Summary')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Information/Data Summary for Application')"/>: <span class="text-primary"><xsl:value-of select="$currentAppName"/></span></span>
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
									<!--<xsl:value-of select="$currentApp/own_slot_value[slot_reference='description']/value"/>-->
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup Info Provided Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Information Provided')"/>
							</h2>
							<div class="content-section">
								<xsl:variable name="app2InfoReps" select="/node()/simple_instance[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $currentApp/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'false') and ((own_slot_value[slot_reference = 'app_pro_creates_info_rep']/value = 'Yes') or (own_slot_value[slot_reference = 'app_pro_updates_info_rep']/value = 'Yes'))]"/>
								<xsl:choose>
									<xsl:when test="count($app2InfoReps) > 0">
										<p> A summary of the Information provided/managed by <xsl:value-of select="$currentAppName"/></p>
										<div>
											<script>
												$(document).ready(function(){
													// Setup - add a text input to each footer cell
												    $('#dt_infoProvided tfoot th').each( function () {
												        var title = $(this).text();
												        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
												    } );
													
													var table = $('#dt_infoProvided').DataTable({
													scrollY: "350px",
													scrollCollapse: true,
													scrollX: true,
													paging: false,
													info: false,
													sort: true,
													responsive: true,
													columns: [
													    { "width": "20%" },
													    { "width": "30%" },
													    <!-- { "width": "260px" }, -->
													    { "width": "7%" },
													    { "width": "6%" },
													    { "width": "15%" },
													    { "width": "7%" },
													    { "width": "15%" }
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
											<table id="dt_infoProvided" class="table table-striped table-bordered">
												<thead>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Information Provided')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Information Type (View)')"/>
														</th>
														<!-- <th>
															<xsl:value-of select="eas:i18n('Description')"/>
														</th> -->
														<th>
															<xsl:value-of select="eas:i18n('Currency')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Granularity')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Organisational Scope')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('CRUD')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Used By')"/>
														</th>
													</tr>
												</thead>
												<tfoot>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Information Provided')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Information Type (View)')"/>
														</th>
														<!-- <th>
															<xsl:value-of select="eas:i18n('Description')"/>
														</th> -->
														<th>
															<xsl:value-of select="eas:i18n('Currency')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Granularity')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Organisational Scope')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('CRUD')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Used By')"/>
														</th>
													</tr>
												</tfoot>
												<tbody>
													<xsl:apply-templates mode="Info_Details" select="$app2InfoReps"/>
												</tbody>
											</table>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div>
											<em>
												<xsl:value-of select="eas:i18n('No Information Provided captured for this Application')"/>
											</em>
										</div>
										<div class="clear"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Section Data Managed Starts-->
						<!-- Get the relations to logical and physical information that is persisted -->
						<xsl:variable name="persistedApp2InfoReps" select="$allApp2InfoReps[(name = $currentApp/own_slot_value[slot_reference = 'uses_information_representation']/value) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
						<xsl:variable name="persistedInfoStores" select="$allInfoStores[own_slot_value[slot_reference = 'deployment_of_information_representation']/value = $persistedApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
						<xsl:variable name="persistedDataObjs" select="$allPhysData[name = $persistedInfoStores/own_slot_value[slot_reference = 'contained_physical_data_entities']/value]"/>

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-database icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Data Managed')"/>
							</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($persistedDataObjs) > 0">
										<p>
											<xsl:value-of select="eas:i18n('A summary of the data managed by')"/>
											<xsl:value-of select="$currentAppName"/>
										</p>
										<div>
											<script>
												$(document).ready(function(){
													// Setup - add a text input to each footer cell
												    $('#dt_dataManaged tfoot th').each( function () {
												        var title = $(this).text();
												        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
												    } );
													
													var table2 = $('#dt_dataManaged').DataTable({
													scrollY: "350px",
													scrollCollapse: true,
													scrollX: true,
													paging: false,
													info: false,
													sort: true,
													responsive: true,
													columns: [
													    { "width": "50px" },
													    { "width": "50px" },
													    { "width": "160px" },
													    { "width": "50px" },
													    { "width": "50", "visible": true},
													    { "width": "50", "visible": true },
													    { "width": "50", "visible": true },
													    { "width": "50px" },
													    { "width": "100px" },
													    { "width": "100px" }
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
												    
												    table.columns.adjust();
												    
												    $(window).resize( function () {
										       			table.columns.adjust();
										    		});
												    
												});
											</script>
											<table id="dt_dataManaged" class="dataTable table table-bordered table-striped">
												<thead>
													<tr>
														<th>
															<xsl:value-of select="eas:i18n('Data Object')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Local Name')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Description')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Currency')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Completeness')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Granularity')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Organisational Scope')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('CRUD')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Sourced from Applications')"/>
														</th>
														<th>
															<xsl:value-of select="eas:i18n('Acquisition Method')"/>
														</th>
													</tr>
												</thead>
												<tbody>
													<xsl:apply-templates mode="Data_Details" select="$persistedDataObjs">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/>
													</xsl:apply-templates>
												</tbody>
											</table>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div>
											<em>
												<xsl:value-of select="eas:i18n('No Data Managed captured for this Application')"/>
											</em>
										</div>
										<div class="clear"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup App Dependencies Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Dependencies')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="displayString" select="'Click here'"/>
										<xsl:with-param name="targetReport" select="$appInfoDataDepsReport"/>
									</xsl:call-template>
									<span>&#160;</span>
									<xsl:value-of select="eas:i18n('to see the inbound and outbound information flows for')"/>
									<span>&#160;</span>
									<xsl:value-of select="$currentAppName"/>
								</p>
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

						<!--Sections End-->
						<!--Closing Divs start-->
					</div>
				</div>
				<div class="clear"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE DETAILS FOR INFORMATION MANAGED BY THE APPLICATION -->
	<xsl:template match="node()" mode="Info_Details">
		<xsl:variable name="infoRep" select="$allInfoReps[name = current()/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
		<xsl:variable name="infoRepName" select="$infoRep/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="infoRepDesc" select="$infoRep/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="infoObj" select="$allInfoViews[name = $infoRep/own_slot_value[slot_reference = 'implements_information_views']/value]"/>
		<xsl:variable name="infoObjName" select="$infoObj/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="infoObjDesc" select="$infoObj/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="infoStore" select="$allInfoStores[name = $infoRep/own_slot_value[slot_reference = 'implemented_with_information_stores']/value]"/>
		<xsl:variable name="currency" select="$allServiceQuals[(name = $infoStore/own_slot_value[slot_reference = 'information_store_qualities']/value) and (own_slot_value[slot_reference = 'usage_of_service_quality']/value = $timelinessQualityType/name)]"/>
		<xsl:variable name="granularity" select="$allServiceQuals[(name = $infoStore/own_slot_value[slot_reference = 'information_store_qualities']/value) and (own_slot_value[slot_reference = 'usage_of_service_quality']/value = $granularityQualityType/name)]"/>
		<xsl:variable name="orgScope" select="$allOrgs[name = $infoStore/own_slot_value[slot_reference = 'information_store_org_scope']/value]"/>
		<xsl:variable name="orgScopeName" select="$orgScope/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="app2PhysProcs" select="$allApp2PhysProcs[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $param1]"/>
		<xsl:variable name="physProcs" select="$allPhysProcs[name = $app2PhysProcs/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="actor2Roles" select="$allActor2Roles[name = $physProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="appOrgs" select="$allOrgs[name = $actor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<tr>
			<td>
				<!--<xsl:value-of select="$infoRepName"/>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$infoRep"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/info_object_summary.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="$infoObj/name" />
						<xsl:text>&amp;LABEL=Information Object Summary - </xsl:text>
						<xsl:value-of select="$infoObjName" />
					</xsl:attribute>
					<xsl:value-of select="$infoObjName" />
				</a>-->
				<ul>
					<xsl:for-each select="$infoObj">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
							<xsl:variable name="infoDesc">
								<xsl:call-template name="RenderMultiLangInstanceDescription">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:if test="string-length($infoDesc) > 0">&#160;-&#160;<xsl:value-of select="$infoDesc"/></xsl:if>
						</li>
					</xsl:for-each>
				</ul>
			</td>
			<!-- <td>
				<xsl:value-of select="$infoObjDesc"/>
			</td> -->
			<td>
				<xsl:choose>
					<xsl:when test="count($currency) > 0">
						<xsl:value-of select="$currency/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($granularity) > 0">
						<xsl:value-of select="$granularity/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($orgScope) > 0">
						<!--<xsl:value-of select="$orgScopeName" />-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$orgScope"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<ul>
					<xsl:if test="current()/own_slot_value[slot_reference = 'app_pro_creates_info_rep']/value = 'Yes'">
						<li><strong>C</strong>reates</li>
					</xsl:if>
					<xsl:if test="current()/own_slot_value[slot_reference = 'app_pro_reads_info_rep']/value = 'Yes'">
						<li><strong>R</strong>eads</li>
					</xsl:if>
					<xsl:if test="current()/own_slot_value[slot_reference = 'app_pro_updates_info_rep']/value = 'Yes'">
						<li><strong>U</strong>pdates</li>
					</xsl:if>
					<xsl:if test="current()/own_slot_value[slot_reference = 'app_pro_deletes_info_rep']/value = 'Yes'">
						<li><strong>D</strong>eletes</li>
					</xsl:if>
				</ul>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($appOrgs) > 0">
						<ul>
							<xsl:for-each select="$appOrgs">
								<li>
									<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<em>
							<xsl:value-of select="eas:i18n('No Organisations Captured')"/>
						</em>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!-- Template to create the details for data that is managed by the application -->
		<xsl:template match="node()" mode="Data_Details">
		<xsl:variable name="dataRep" select="$allDataReps[name = current()/own_slot_value[slot_reference = 'implements_data_representation']/value]"></xsl:variable>
		<xsl:variable name="dataRepName" select="$dataRep/own_slot_value[slot_reference = 'name']/value"></xsl:variable>
		<xsl:variable name="dataRepDesc" select="$dataRep/own_slot_value[slot_reference = 'description']/value"></xsl:variable>
		<xsl:variable name="app2Info2DataRep" select="$allApp2Info2DataReps[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value = $dataRep/name]"></xsl:variable>
		<xsl:variable name="dataObj" select="$allDataObjs[name = $dataRep/own_slot_value[slot_reference = 'implemented_data_object']/value]"></xsl:variable>
		<xsl:variable name="dataObjName" select="$dataObj/own_slot_value[slot_reference = 'name']/value"></xsl:variable>
		<xsl:variable name="dataObjDesc" select="$dataObj/own_slot_value[slot_reference = 'description']/value"></xsl:variable>
		<xsl:variable name="dataAcquisitonMethod" select="$allAcquisitionMethods[name = $app2Info2DataRep/own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value]"></xsl:variable>
		<xsl:variable name="dataSourceApp2InfoReps" select="$allApp2InfoReps[name = $app2Info2DataRep/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"></xsl:variable>
		<xsl:variable name="sourceApps" select="$allApps[name = $dataSourceApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"></xsl:variable>
		<xsl:variable name="currency" select="$allServiceQuals[(name = current()/own_slot_value[slot_reference = 'physical_data_qualities']/value) and (own_slot_value[slot_reference = 'usage_of_service_quality']/value = $timelinessQualityType/name)]"></xsl:variable>
		<xsl:variable name="granularity" select="$allServiceQuals[(name = current()/own_slot_value[slot_reference = 'physical_data_qualities']/value) and (own_slot_value[slot_reference = 'usage_of_service_quality']/value = $granularityQualityType/name)]"></xsl:variable>
		<xsl:variable name="completeness" select="$allServiceQuals[(name = current()/own_slot_value[slot_reference = 'physical_data_qualities']/value) and (own_slot_value[slot_reference = 'usage_of_service_quality']/value = $completenessQualityType/name)]"></xsl:variable>
		<xsl:variable name="orgScope" select="$allOrgs[name = current()/own_slot_value[slot_reference = 'physical_data_org_scope']/value]"></xsl:variable>
        <xsl:variable name="phyName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
        <xsl:variable name="displayName" select="substring-before(substring-before(substring-after($phyName,'&#40;'),'-'),'&#41;')"/>
        
        <xsl:variable name="displayNamewithScope" select="substring-before(substring-after($phyName,'&#40;'),'-')"/>
        <tr>
			<td>
				<strong>
					<!--<xsl:value-of select="$dataRepName" />-->
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$dataRep"></xsl:with-param>
						<xsl:with-param name="theXML" select="$reposXML"></xsl:with-param>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"></xsl:with-param>
					</xsl:call-template>
				</strong>
			</td>
            <td>  <xsl:value-of select="$displayName"/>
                <xsl:if test="$displayName=''"><xsl:value-of select="$displayNamewithScope"/></xsl:if> 
                <xsl:if test="contains($displayName,'&#40;')">&#41;</xsl:if>
                <!--:;
				<ul>
					<xsl:for-each select="$dataObj">
    
                        <xsl:value-of select="name"/>:
              
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
								<xsl:with-param name="theXML" select="$reposXML"></xsl:with-param>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"></xsl:with-param>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
-->
			</td>    
			<td>
				<xsl:choose>
					<xsl:when test="string-length($dataRepDesc) > 0">
						<xsl:value-of select="$dataRepDesc"></xsl:value-of>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$dataObjDesc"></xsl:value-of>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($currency) > 0">
						<xsl:value-of select="$currency/own_slot_value[slot_reference = 'service_quality_value_value']/value"></xsl:value-of>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($completeness) > 0">
						<xsl:value-of select="$completeness/own_slot_value[slot_reference = 'service_quality_value_value']/value"></xsl:value-of>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($granularity) > 0">
						<xsl:value-of select="$granularity/own_slot_value[slot_reference = 'service_quality_value_value']/value"></xsl:value-of>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($orgScope) > 0">
						<ul>
							<xsl:for-each select="$orgScope">
								<li>
									<xsl:value-of select="$orgScope/own_slot_value[slot_reference = 'name']/value"></xsl:value-of>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<ul>
					<xsl:if test="$app2Info2DataRep/own_slot_value[slot_reference = 'app_pro_creates_data_rep']/value = 'Yes'">
						<li>
							<xsl:value-of select="eas:i18n('Creates')"></xsl:value-of>
						</li>
					</xsl:if>
					<xsl:if test="$app2Info2DataRep/own_slot_value[slot_reference = 'app_pro_reads_data_rep']/value = 'Yes'">
						<li>
							<xsl:value-of select="eas:i18n('Reads')"></xsl:value-of>
						</li>
					</xsl:if>
					<xsl:if test="$app2Info2DataRep/own_slot_value[slot_reference = 'app_pro_updates_data_rep']/value = 'Yes'">
						<li>
							<xsl:value-of select="eas:i18n('Updates')"></xsl:value-of>
						</li>
					</xsl:if>
					<xsl:if test="$app2Info2DataRep/own_slot_value[slot_reference = 'app_pro_deletes_data_rep']/value = 'Yes'">
						<li>
							<xsl:value-of select="eas:i18n('Deletes')"></xsl:value-of>
						</li>
					</xsl:if>
				</ul>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($sourceApps) > 0">
						<ul>
							<xsl:for-each select="$sourceApps">
								<xsl:variable name="appName" select="current()/own_slot_value[slot_reference = 'name']/value"></xsl:variable>
								<li>
									<!--<a>
										<xsl:attribute name="href">
											<xsl:text>report?XML=reportXML.xml&amp;XSL=application/app_data_summary.xsl&amp;PMA=</xsl:text>
											<xsl:value-of select="current()/name" />
											<xsl:text>&amp;LABEL=Application Data Summary - </xsl:text>
											<xsl:value-of select="$appName" />
										</xsl:attribute>
										<xsl:value-of select="$appName" />
									</a>-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
										<xsl:with-param name="theXML" select="$reposXML"></xsl:with-param>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"></xsl:with-param>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<em>
							<xsl:value-of select="eas:i18n('No Source Applications Captured')"></xsl:value-of>
						</em>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($dataAcquisitonMethod) > 0">
						<xsl:value-of select="$dataAcquisitonMethod/own_slot_value[slot_reference = 'name']/value"></xsl:value-of>
					</xsl:when>
					<xsl:otherwise>&#160;-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
    <xsl:template match="node()" mode="counts">
     o<xsl:value-of select="position()"/><xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/><br/>
    </xsl:template>
</xsl:stylesheet>
