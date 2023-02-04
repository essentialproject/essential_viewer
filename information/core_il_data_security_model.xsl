<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

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

	<!--<xsl:include href="../information/menus/core_data_subject_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Data_Subject', 'Business_Role', 'Info_Data_Management_Policy', 'Individual_Business_Role', 'Group_Business_Role')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Get all of the required types of instances in the repository -->
	<xsl:variable name="allDataSubjects" select="/node()/simple_instance[type = 'Data_Subject']"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[type = 'Data_Object']"/>
	<xsl:variable name="dataStakeholderRoleReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Data Stakeholder Role Type')]"/>
	<xsl:variable name="dataStakeholderRoleType" select="/node()/simple_instance[name = $dataStakeholderRoleReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="allBusinessRoles" select="/node()/simple_instance[type = 'Individual_Business_Role' or type = 'Group_Business_Role']"/>
	<xsl:variable name="dataStakeholderRoles" select="$allBusinessRoles[own_slot_value[slot_reference = 'is_business_role_type']/value = $dataStakeholderRoleType/name]"/>

	<xsl:variable name="allSecurityPolicies" select="/node()/simple_instance[type = 'Security_Policy']"/>
	<xsl:variable name="allSecurityClassifications" select="/node()/simple_instance[type = 'Security_Classification']"/>
	<xsl:variable name="allDataMgmtPolicies" select="/node()/simple_instance[type = 'Info_Data_Management_Policy']"/>

	<xsl:variable name="relevantBusinessRoles" select="$allBusinessRoles[not(own_slot_value[slot_reference = 'is_business_role_type']/value = $dataStakeholderRoleType/name) and ((name = $allDataMgmtPolicies/own_slot_value[slot_reference = 'dmp_responsible_roles']/value) or (name = $allSecurityPolicies/own_slot_value[slot_reference = 'sp_actor']/value))]"/>

	<xsl:variable name="allSecuredActions" select="/node()/simple_instance[type = 'Secured_Action']"/>
	<xsl:variable name="createAction" select="$allSecuredActions[own_slot_value[slot_reference = 'name']/value = 'Create']"/>
	<xsl:variable name="readAction" select="$allSecuredActions[own_slot_value[slot_reference = 'name']/value = 'Read']"/>
	<xsl:variable name="updateAction" select="$allSecuredActions[own_slot_value[slot_reference = 'name']/value = 'Update']"/>
	<xsl:variable name="deleteAction" select="$allSecuredActions[own_slot_value[slot_reference = 'name']/value = 'Delete']"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeDataSubjects" select="$allDataSubjects[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeDataObjects" select="$allDataObjects[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeBusinessRoles" select="$relevantBusinessRoles[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
					<xsl:with-param name="inScopeDMPolicies" select="$allDataMgmtPolicies[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeDataSubjects" select="$allDataSubjects"/>
					<xsl:with-param name="inScopeDataObjects" select="$allDataObjects"/>
					<xsl:with-param name="inScopeBusinessRoles" select="$relevantBusinessRoles"/>
					<xsl:with-param name="inScopeDMPolicies" select="$allDataMgmtPolicies"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Data Security Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeDataSubjects">
			<xsl:value-of select="$allDataSubjects"/>
		</xsl:param>
		<xsl:param name="inScopeDataObjects">
			<xsl:value-of select="$allDataObjects"/>
		</xsl:param>
		<xsl:param name="inScopeBusinessRoles">
			<xsl:value-of select="$relevantBusinessRoles"/>
		</xsl:param>
		<xsl:param name="inScopeDMPolicies">
			<xsl:value-of select="$allDataMgmtPolicies"/>
		</xsl:param>
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
					.bg-midgrey {
						background-color: #999!important;
						color: #fff;
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
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderDataSubjectPopUpScript" />-->

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
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Data-to-Role Matrix')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('The following matrix maps conceptual Data Subjects to the Business Roles in use across')"/>&#160; <xsl:value-of select="$orgName"/>
							</p>
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

							<!-- end -->
							<div>
								<script>
									$(document).ready(function(){								
										var table = $('#dt_dataObjects').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										scrollX: true,
										sScrollXInner: "<xsl:value-of select="140 + (140 * count($inScopeDataSubjects))"/>px", <!--we need to calculate this value using the formula 140 +(140 x number of data subjects)//-->
										paging: false,
										info: false,
										sort: false,
										filter: false,
										fixedColumns: true
										});
									});
								</script>

								<xsl:call-template name="Matrix">
									<xsl:with-param name="dataSubjects" select="$inScopeDataSubjects"/>
									<xsl:with-param name="dataObjects" select="$inScopeDataObjects"/>
									<xsl:with-param name="businessRoles" select="$inScopeBusinessRoles"/>
									<xsl:with-param name="dmPolicies" select="$inScopeDMPolicies"/>
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
		<xsl:param name="dataSubjects"/>
		<xsl:param name="dataObjects"/>
		<xsl:param name="businessRoles"/>
		<xsl:param name="dmPolicies"/>
		<!--Setup Matrix Section-->
		<table class="table table-bordered table-header-background" id="dt_dataObjects">
			<thead>
				<tr>
					<th class="tableStyleMatrixCorner cellWidth-140 vAlignMiddle">&#160;</th>
					<xsl:apply-templates mode="DataSubject" select="$dataSubjects">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					</xsl:apply-templates>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="BusinessRoleRow" select="$businessRoles">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:with-param name="dataSubjects" select="$dataSubjects"/>
					<xsl:with-param name="dataObjects" select="$dataObjects"/>
					<xsl:with-param name="dmPolicies" select="$dmPolicies"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>



	<xsl:template match="node()" mode="DataSubject">
		<xsl:variable name="dsName" select="own_slot_value[slot_reference = 'name']/value"/>
		<th class="cellWidth-140 vAlignMiddle">
			<!--<a id="{$dsName}" class="text-white context-menu-dataSubject menu-1">
				<xsl:call-template name="RenderLinkHref">
					<xsl:with-param name="theInstanceID" select="name" />
					<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
					<xsl:with-param name="theParam4" select="$param4" />
					<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
					<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
				</xsl:call-template>
				<xsl:value-of select="$dsName" />
			</a>-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="anchorClass" select="'text-white'"/>
			</xsl:call-template>
		</th>
	</xsl:template>

	<xsl:template match="node()" mode="BusinessRoleRow">
		<xsl:param name="dataSubjects"/>
		<xsl:param name="dataObjects"/>
		<xsl:param name="dmPolicies"/>
		<xsl:variable name="currentRole" select="current()"/>
		<xsl:variable name="brName" select="own_slot_value[slot_reference = 'name']/value"/>
		<tr>
			<td class="bg-midgrey text-white vAlignMiddle">

				<strong> <!--<xsl:value-of select="$brName" />-->
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>

			</td>
			<xsl:for-each select="$dataSubjects">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:call-template name="BusinessRole2DataCell">
					<xsl:with-param name="dataSubject" select="current()"/>
					<xsl:with-param name="businessRole" select="$currentRole"/>
					<xsl:with-param name="dmPolicies" select="$dmPolicies"/>
					<xsl:with-param name="dataObjectsForSubject" select="$dataObjects[own_slot_value[slot_reference = 'defined_by_data_subject']/value = current()/name]"/>
				</xsl:call-template>
			</xsl:for-each>
		</tr>
	</xsl:template>


	<xsl:template name="BusinessRole2DataCell">
		<xsl:param name="dataSubject"/>
		<xsl:param name="businessRole"/>
		<xsl:param name="dmPolicies"/>
		<xsl:param name="dataObjectsForSubject"/>

		<xsl:variable name="relevantSecurityPolicies" select="$allSecurityPolicies[(own_slot_value[slot_reference = 'sp_actor']/value = $businessRole/name) and (own_slot_value[slot_reference = 'sp_resources']/value = $dataObjectsForSubject/name)]"/>

		<!-- Determine the CRUD for the cell -->
		<xsl:variable name="roleCRUD">
			<xsl:choose>
				<xsl:when test="count($relevantSecurityPolicies[(own_slot_value[slot_reference = 'sp_action']/value = $createAction/name)]) > 0">
					<xsl:value-of select="'C'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count($relevantSecurityPolicies[(own_slot_value[slot_reference = 'sp_action']/value = $readAction/name)]) > 0">
					<xsl:value-of select="'R'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count($relevantSecurityPolicies[(own_slot_value[slot_reference = 'sp_action']/value = $updateAction/name)]) > 0">
					<xsl:value-of select="'U'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="count($relevantSecurityPolicies[(own_slot_value[slot_reference = 'sp_action']/value = $deleteAction/name)]) > 0">
					<xsl:value-of select="'D'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'-'"/>
				</xsl:otherwise>
			</xsl:choose>




			<!--	<xsl:if test="count($relevantSecurityPolicies[(own_slot_value[slot_reference='sp_action']/value = $createAction/name)]) > 0">
				<xsl:value-of select="'C'"/>
			</xsl:if>
			<xsl:if test="count($allSecurityPolicies[(own_slot_value[slot_reference='sp_action']/value = $readAction/name) and (own_slot_value[slot_reference='sp_actor']/value = $businessRole/name)  and (own_slot_value[slot_reference='sp_resources']/value = $dataObjectsForSubject/name)]) > 0">
				<xsl:value-of select="'R'"/>
			</xsl:if>
			<xsl:if test="count($allSecurityPolicies[(own_slot_value[slot_reference='sp_action']/value = $updateAction/name) and (own_slot_value[slot_reference='sp_actor']/value = $businessRole/name)  and (own_slot_value[slot_reference='sp_resources']/value = $dataObjectsForSubject/name)]) > 0">
				<xsl:value-of select="'U'"/>
			</xsl:if>
			<xsl:if test="count($allSecurityPolicies[(own_slot_value[slot_reference='sp_action']/value = $deleteAction/name) and (own_slot_value[slot_reference='sp_actor']/value = $businessRole/name)  and (own_slot_value[slot_reference='sp_resources']/value = $dataObjectsForSubject/name)]) > 0">
				<xsl:value-of select="'D'"/>
			</xsl:if>  -->
		</xsl:variable>
		<td class="vAlignTop">
			<p>
				<!--	  <xsl:value-of select="$roleCRUD"/> -->
				<xsl:choose>
					<xsl:when test="contains($roleCRUD, 'C')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:#D35400"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="contains($roleCRUD, 'R')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:#8E44AD"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="contains($roleCRUD, 'U')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:green"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<xsl:choose>
					<xsl:when test="contains($roleCRUD, 'D')">
						<i class="fa fa-square fa-lg" aria-hidden="true" style="color:#21618C"/>
					</xsl:when>
					<xsl:otherwise>
						<i class="fa fa-square-o fa-lg" aria-hidden="true" style="color:#eaeded"/>
					</xsl:otherwise>
				</xsl:choose>



			</p>
			<!--	<xsl:choose>
				<xsl:when test="string-length($roleCRUD) > 0">
					<p><xsl:value-of select="$roleCRUD"/></p>
				</xsl:when>
				<xsl:otherwise>
					<p>-</p>
				</xsl:otherwise>
			</xsl:choose>  -->

			<xsl:variable name="relevantDMPolicies" select="$dmPolicies[(own_slot_value[slot_reference = 'dmp_assigned_info_data_object']/value = $dataObjectsForSubject/name) and (own_slot_value[slot_reference = 'dmp_responsible_roles']/value = $businessRole/name)]"/>
			<xsl:variable name="stakeholderRoles" select="$dataStakeholderRoles[name = $relevantDMPolicies/own_slot_value[slot_reference = 'dmp_responsibility']/value]"/>
			<xsl:apply-templates mode="DataStakeholder" select="$stakeholderRoles">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>

			<!--	<xsl:choose>
				<xsl:when test="count($stakeholderRoles) = 0"><p>&#160;</p></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="DataStakeholder" select="$stakeholderRoles">
						<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>  -->
		</td>
	</xsl:template>


	<xsl:template match="node()" mode="DataStakeholder">
		<xsl:variable name="dsName" select="own_slot_value[slot_reference = 'name']/value"/>
		<p class="small text-primary">
			<!--<xsl:value-of select="$dsName" />-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</p>
	</xsl:template>



</xsl:stylesheet>
