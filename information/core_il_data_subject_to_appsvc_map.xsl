<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xpath-default-namespace="http://protege.stanford.edu/xml" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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

	<!-- July 2011 Updated to support Essential Viewer version 3-->

	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the data subject whose related Data Objects are being mapped to applications -->
	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Data_Object', 'Application_Service')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Get all of the required types of instances in the repository -->
	<xsl:variable name="currentDataSubject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentDataSubjectName" select="$currentDataSubject/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[own_slot_value[slot_reference = 'defined_by_data_subject']/value = $param1]"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allAppPro2InfoReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
	<xsl:variable name="allAppPro2InfoReps2DataRep" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_TO_DATAREP_RELATION']"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeDataObjects" select="$allDataObjects[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel"><xsl:value-of select="eas:i18n('Data Subject-to-Application Service Model for')"/>&#160; <xsl:value-of select="$currentDataSubjectName"/></xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeDataObjects" select="$allDataObjects"/>
		<xsl:param name="inScopeAppProRoles" select="$allAppProRoles"/>

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<style type="text/css">
					table.dataTable{
						margin-top: 0px !important;
					}
					.bg-midgrey{
						background-color: #999!important;
					}
				</style>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
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

						<!--Setup Matrix Section-->
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Data-to-Application Service Matrix')"/>
								</h2>
							</div>
							<div>
								<p><xsl:value-of select="eas:i18n('The following matrix maps logical Data Objects of')"/>&#160; <strong><xsl:value-of select="$currentDataSubjectName"/></strong>&#160;<xsl:value-of select="eas:i18n(' to the Application Services in use across')"/>&#160; <xsl:value-of select="$orgName"/></p>
								<p>
									<!-- Legend -->
									<div class="keyContainer row" id="lifecycleLegend">
										<div class="col-xs-2">
											<div class="keyLabel text-primary"><xsl:value-of select="eas:i18n('Legend')"/>:</div>
										</div>
										<div class="verticalSpacer_5px"/>
										<div class="col-xs-10">

											<div class="pull-left">
												<div class="keySampleWide">
													<xsl:attribute name="style" select="concat('background-color:', '#D35400')"/>
												</div>
												<div class="keySampleLabel"> Create </div>
												<div class="keySampleWide">
													<xsl:attribute name="style" select="concat('background-color:', '#8E44AD')"/>
												</div>
												<div class="keySampleLabel"> Read </div>
												<div class="keySampleWide">
													<xsl:attribute name="style" select="concat('background-color:', 'green')"/>
												</div>
												<div class="keySampleLabel"> Update </div>
												<div class="keySampleWide">
													<xsl:attribute name="style" select="concat('background-color:', '#21618C')"/>
												</div>
												<div class="keySampleLabel"> Delete </div>
											</div>

										</div>
									</div>

								</p>


							</div>
							<div class="clear"/>
							<br/>
							<div>
								<script>
									$(document).ready(function(){								
										var table = $('#dt_dataObjects').DataTable({
										scrollY: $(window).innerHeight()-400,
										scrollCollapse: true,
										scrollX: true,
										sScrollXInner: "<xsl:value-of select="140 + (140 * count($inScopeDataObjects))"/>px", <!--we need to calculate this value using the formula 140 +(140 x number of data subjects)//-->
										paging: false,
										info: false,
										sort: false,
										filter: false,
										fixedColumns: true
										});
									});
								</script>
								<xsl:call-template name="Matrix">
									<xsl:with-param name="dataObjects" select="$inScopeDataObjects"/>
									<xsl:with-param name="appProRoles" select="$inScopeAppProRoles"/>
								</xsl:call-template>

							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>



	<xsl:template name="Matrix">
		<xsl:param name="dataObjects"/>
		<xsl:param name="appProRoles"/>

		<!--Setup Matrix Section-->
		<table class="table table-bordered dataTable table-header-background" id="dt_dataObjects">
			<thead>

				<tr>
					<th>&#160;</th>
					<xsl:apply-templates mode="DataObject" select="$dataObjects">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="ApplicationServiceRow" select="$allAppServices[name = $appProRoles/own_slot_value[slot_reference = 'implementing_application_service']/value]">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:with-param name="dataObjects" select="$dataObjects"/>
					<xsl:with-param name="appProRoles" select="$appProRoles"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>


	<xsl:template match="node()" mode="DataObject">
		<xsl:variable name="doName" select="own_slot_value[slot_reference = 'name']/value"/>
		<th>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="anchorClass" select="'text-white underline'"/>
			</xsl:call-template>
		</th>
	</xsl:template>

	<xsl:template match="node()" mode="ApplicationServiceRow">
		<xsl:param name="dataObjects"/>
		<xsl:param name="appProRoles"/>
		<xsl:variable name="currentAppSvc" select="current()"/>
		<xsl:variable name="asName" select="own_slot_value[slot_reference = 'name']/value"/>

		<tr>
			<td class="bg-midgrey">
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass" select="'text-white underline'"/>
					</xsl:call-template>
				</strong>
			</td>
			<xsl:for-each select="$dataObjects">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:call-template name="ApplicationService2DataCell">
					<xsl:with-param name="appService" select="$currentAppSvc"/>
					<xsl:with-param name="appProRoles" select="$appProRoles"/>
					<xsl:with-param name="dataObject" select="current()"/>
				</xsl:call-template>
			</xsl:for-each>
		</tr>
	</xsl:template>


	<xsl:template name="ApplicationService2DataCell">
		<xsl:param name="appService"/>
		<xsl:param name="dataObject"/>
		<xsl:param name="appProRoles"/>


		<xsl:variable name="relevantAppProRoles" select="$appProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $appService/name]"/>
		<xsl:variable name="relevantAppProviders" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="relevantAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $relevantAppProviders/name]"/>
		<xsl:variable name="relevantAppPro2InfoRep2DataRep" select="$allAppPro2InfoReps2DataRep[(own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value = $relevantAppPro2InfoReps/name) and (own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $dataObject/name)]"/>

		<!-- Determine the CRUD for the cell -->
		<xsl:variable name="appCRUD">
			<xsl:choose>
				<xsl:when test="count($relevantAppPro2InfoRep2DataRep[own_slot_value[slot_reference = 'app_pro_creates_data_rep']/value = 'Yes']) > 0">
					<xsl:value-of select="'C'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count($relevantAppPro2InfoRep2DataRep[own_slot_value[slot_reference = 'app_pro_reads_data_rep']/value = 'Yes']) > 0">
					<xsl:value-of select="'R'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count($relevantAppPro2InfoRep2DataRep[own_slot_value[slot_reference = 'app_pro_updates_data_rep']/value = 'Yes']) > 0">
					<xsl:value-of select="'U'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count($relevantAppPro2InfoRep2DataRep[own_slot_value[slot_reference = 'app_pro_deletes_data_rep']/value = 'Yes']) > 0">
					<xsl:value-of select="'D'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:variable>
		<td>
			<p>
				<!--		<xsl:value-of select="$appCRUD"/>  -->

				<xsl:choose>
					<xsl:when test="contains($appCRUD, 'C')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:#D35400"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="contains($appCRUD, 'R')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:#8E44AD"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="contains($appCRUD, 'U')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:green"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="contains($appCRUD, 'D')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:#21618C"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>




			</p>
		</td>
	</xsl:template>

</xsl:stylesheet>
