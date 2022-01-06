<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<!--<xsl:include href="../information/menus/core_info_concept_menu.xsl" />
	<xsl:include href="../information/menus/core_data_object_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>
	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Concept', 'Data_Object', 'Group_Actor', 'Individual_Actor', 'Business_Process', 'Business_Role', 'Application_Provider', 'Data_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>
	<xsl:variable name="currentInfoObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="viewAttributes" select="/node()/simple_instance[name = $currentInfoObject/own_slot_value[slot_reference = 'contained_view_attributes']/value]"/>
	<xsl:variable name="infoObjectName" select="$currentInfoObject/own_slot_value[slot_reference = 'view_label']/value"/>
	<xsl:variable name="implementingInfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_information_views']/value = $currentInfoObject/name]"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>
	<xsl:variable name="allAppInforepRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value = $implementingInfoReps/name]"/>
	<xsl:variable name="allPhysProc2Inforeps" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allDataCategories" select="/node()/simple_instance[type = 'Data_Category']"/>
	<xsl:variable name="relevantActor2Roles" select="/node()/simple_instance[name = $currentInfoObject/own_slot_value[slot_reference = ('information_view_stakeholders', 'stakeholders')]/value]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[(type = 'Group_Actor')]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]"/>
	<xsl:variable name="dataStakeholderRoleType" select="/node()/simple_instance[(type = 'Business_Role_Type') and (own_slot_value[slot_reference = 'name']/value = 'Data Stakeholder')]"/>
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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Information View Summary')"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<script>
					$(function(){
						$('#impactedOrgs').columnize({columns: 2});		
					});
				</script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderInfoConceptPopUpScript" />
				<xsl:call-template name="RenderDataObjectPopUpScript" />-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<xsl:variable name="infoObjectDesc" select="$currentInfoObject/own_slot_value[slot_reference = 'description']/value"/>
				<xsl:variable name="parentConcept" select="$allInfoConcepts[name = $currentInfoObject/own_slot_value[slot_reference = 'refinement_of_information_concept']/value]"/>

				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Information View Summary for')"/>&#160;</span>
										<span class="text-primary">
											<xsl:value-of select="$infoObjectName"/>
										</span>
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
									<xsl:value-of select="$infoObjectDesc"/>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup Parent Info Concept Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Parent Information Concept')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:variable name="parentConceptName" select="$parentConcept/own_slot_value[slot_reference = 'name']/value"/>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$parentConcept"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>
						
						<!--Setup Data Attributes Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>
							
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('View Attributes')"/>
							</h2>
							
							<div class="content-section">
								<xsl:call-template name="viewAttributes"/>
							</div>
							<hr/>
						</div>



						<!--Setup Data Objects Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-puzzle-piece icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Supporting Data Objects')"/>
								</h2>
							</div>

							<div class="content-section">
								<xsl:call-template name="dataObjects"/>
							</div>

							<hr/>
						</div>


						<!--Setup Organisations Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Organisations Using Information Object')"/>
							</h2>


							<div class="content-section">
								<xsl:call-template name="infoObjectsUsing"/>
							</div>

							<hr/>
						</div>


						<!--Setup Business Process Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-blocks icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Processes Using Information Object')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="busProcessUsing"/>
							</div>
							<hr/>
						</div>


						<!--Setup Stakeholders Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Stakeholders')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="stakeholders"/>
							</div>
							<hr/>
						</div>


						<!--Setup Systems Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-server icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Systems Using Information Object')"/>
								</h2>
							</div>
							<div class="content-section">
								<xsl:call-template name="systemUsing"/>
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
			</body>
		</html>
	</xsl:template>
	<!--Setup Data Objects Section-->
	<xsl:template name="dataObjects">
		<xsl:variable name="dataObjects" select="/node()/simple_instance[name = $currentInfoObject/own_slot_value[slot_reference = 'info_view_supporting_data_objects']/value]"/>
		<xsl:choose>
			<xsl:when test="count($dataObjects) > 0">
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Data Object')"/>
							</th>
							<th class="cellWWidth-50pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Data Category')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$dataObjects">
							<xsl:variable name="dataObjName" select="./own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="dataObjDesc" select="./own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="dataCategory" select="$allDataCategories[name = current()/own_slot_value[slot_reference = 'data_category']/value]"/>
							<xsl:variable name="dataCategoryName" select="$dataCategory/own_slot_value[slot_reference = 'name']/value"/>
							<tr>
								<td>
									<!--<a id="{$dataObjName}" class="context-menu-dataObject menu-1">
										<xsl:call-template name="RenderLinkHref">
											<xsl:with-param name="theInstanceID" select="name" />
											<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
											<xsl:with-param name="theParam4" select="$param4" />
										</xsl:call-template>
										<xsl:value-of select="$dataObjName" />
									</a>-->
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
									<!--<a>
										<xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=information/data_object_summary.xsl&amp;PMA=</xsl:text><xsl:value-of select="current()/name"/>
											<xsl:text>&amp;LABEL=Data Object Summary - </xsl:text><xsl:value-of select="$dataObjName"/>
										</xsl:attribute>
										<xsl:value-of select="$dataObjName"/>
									</a>-->
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="string-length($dataObjDesc) = 0"> - </xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$dataObjDesc"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:value-of select="$dataCategoryName"/>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Supporting Data Objects Defined')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="infoObjectsUsing">
		<!-- Now intersect these Information Views with the processes that use them -->
		<xsl:variable name="informationViewRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value = $currentInfoObject/name]"/>
		<!-- now get the business processes for the business process to information object relations -->
		<xsl:variable name="busProcs" select="/node()/simple_instance[name = $informationViewRels/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
		<!-- Now get the physical process that implement the business processes -->
		<xsl:variable name="physProcs" select="/node()/simple_instance[name = $busProcs/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
		<!-- Now get the actor to role relations that perform the physical business processes -->
		<xsl:variable name="actorToRoles" select="$allActor2Roles[name = $physProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<!-- Finally get the actors that are playing the roles -->
		<xsl:variable name="directActors" select="$allActors[name = $physProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="indirectActors" select="$allActors[name = $actorToRoles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="actors" select="$directActors union $indirectActors"/>
		<xsl:choose>
			<xsl:when test="count($actors) > 0">
				<ul>
					<xsl:for-each select="$actors">
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
					<xsl:value-of select="eas:i18n('No Organisations mapped for this objects')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="busProcessUsing">
		<!-- Set the required variables -->
		<xsl:variable name="info2BusProcRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value = $currentInfoObject/name]"/>
		<xsl:choose>
			<xsl:when test="count($info2BusProcRels) > 0">
				<table class="tableStyleCRUD table-header-background">
					<tbody>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('CREATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('READ')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="info2BusProcRelsCREATE" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_creates_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsCREATE" select="$allBusProcs[name = $info2BusProcRelsCREATE/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsCREATE">
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
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="info2BusProcRelsREAD" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_reads_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsREAD" select="$allBusProcs[name = $info2BusProcRelsREAD/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsREAD">
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
							</td>
						</tr>
						<tr>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
						</tr>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('UPDATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('DELETE')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="info2BusProcRelsUPDATE" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_updates_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsUPDATE" select="$allBusProcs[name = $info2BusProcRelsUPDATE/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsUPDATE">
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
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="info2BusProcRelsDELETE" select="$info2BusProcRels[own_slot_value[slot_reference = 'busproctype_deletes_infoview']/value = 'Yes']"/>
								<xsl:variable name="busProcsDELETE" select="$allBusProcs[name = $info2BusProcRelsDELETE/own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value]"/>
								<ul>
									<xsl:for-each select="$busProcsDELETE">
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
							</td>
						</tr>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Business Processes Mapped')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="stakeholders">
		<xsl:if test="count($relevantActor2Roles) = 0">
			<div>
				<em><xsl:value-of select="eas:i18n('No stakeholders defined for the')"/>&#160; <strong><xsl:value-of select="$infoObjectName"/></strong>&#160; <xsl:value-of select="eas:i18n('Information Object')"/></em>
			</div>
		</xsl:if>
		<xsl:if test="count($relevantActor2Roles) > 0">
			<div><xsl:value-of select="eas:i18n('Stakeholders for the')"/>&#160; <strong><xsl:value-of select="$infoObjectName"/></strong>&#160; <xsl:value-of select="eas:i18n('Information Object ')"/></div>
			<div class="verticalSpacer_10px"/>

			<div>
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Role')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Name')"/>
							</th>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('Organisation')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="infoStakeholders" select="$relevantActor2Roles">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE BUSINESS STAKEHOLDERS OF THIS INFORMATION VIEW-->
	<xsl:template match="node()" mode="infoStakeholders">
		<xsl:variable name="actor" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="role" select="$allRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
		<xsl:variable name="roleName" select="$role/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="actorName" select="$actor/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="parentOrg" select="$allActors[name = $actor/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
		<xsl:variable name="parentOrgName" select="$parentOrg/own_slot_value[slot_reference = 'name']/value"/>
		<tr>
			<td>
				<!--<xsl:value-of select="$roleName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$role"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<!--<xsl:value-of select="$actorName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$actor"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<!--<xsl:value-of select="$parentOrgName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$parentOrg"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>


	<xsl:template name="systemUsing">
		<!-- Set the variables needed for the system CRUD -->
		<xsl:variable name="appInforepRelsCREATE" select="$allAppInforepRels[own_slot_value[slot_reference = 'app_pro_creates_info_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsREAD" select="$allAppInforepRels[own_slot_value[slot_reference = 'app_pro_reads_info_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsUPDATE" select="$allAppInforepRels[own_slot_value[slot_reference = 'app_pro_updates_info_rep']/value = 'Yes']"/>
		<xsl:variable name="appInforepRelsDELETE" select="$allAppInforepRels[own_slot_value[slot_reference = 'app_pro_deletes_info_rep']/value = 'Yes']"/>
		<xsl:choose>
			<xsl:when test="count($allAppInforepRels) > 0">
				<table class="tableStyleCRUD table-header-background">
					<tbody>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('CREATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('READ')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="appsCREATE" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsCREATE/name]"/>
								<ul>
									<xsl:apply-templates select="$appsCREATE" mode="App_Provider_CRUD_Entry">
										<xsl:sort order="ascending"/>
									</xsl:apply-templates>
								</ul>
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="appsREAD" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsREAD/name]"/>
								<ul>
									<xsl:apply-templates select="$appsREAD" mode="App_Provider_CRUD_Entry">
										<xsl:sort order="ascending"/>
									</xsl:apply-templates>
								</ul>
							</td>
						</tr>
						<tr>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
							<td class="crudSpacerRow">&#160;</td>
						</tr>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('UPDATE')"/>
							</th>
							<td class="crudSpacerCol">&#160;</td>
							<th>
								<xsl:value-of select="eas:i18n('DELETE')"/>
							</th>
						</tr>
						<tr>
							<td>
								<xsl:variable name="appsUPDATE" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsUPDATE/name]"/>
								<ul>
									<xsl:apply-templates select="$appsUPDATE" mode="App_Provider_CRUD_Entry">
										<xsl:sort order="ascending"/>
									</xsl:apply-templates>
								</ul>
							</td>
							<td class="crudSpacerCol">&#160;</td>
							<td>
								<xsl:variable name="appsDELETE" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $appInforepRelsDELETE/name]"/>
								<ul>
									<xsl:apply-templates select="$appsDELETE" mode="App_Provider_CRUD_Entry">
										<xsl:sort order="ascending"/>
									</xsl:apply-templates>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Applications Mapped')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="node()" mode="App_Provider_CRUD_Entry">
		<xsl:variable name="appName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
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
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>
	
	<!--Setup the Data Attributes Template-->
	<xsl:template name="viewAttributes">
		<xsl:choose>
			<xsl:when test="count($viewAttributes) > 0">
				<script>
					$(document).ready(function(){
					// Setup - add a text input to each footer cell
					$('#dt_viewAttributes tfoot th').each( function () {
					var title = $(this).text();
					$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					} );
					
					var table = $('#dt_viewAttributes').DataTable({
					scrollY: "350px",
					scrollCollapse: true,
					paging: false,
					info: false,
					sort: true,
					responsive: true,
					columns: [
					{ "width": "40%" },
					{ "width": "60%" }
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
				<div>
					<table class="table table-striped table-bordered" id="dt_viewAttributes">
						<thead>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Attribute Name')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
							</tr>
						</thead>
						<tfoot>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Attribute Name')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Description')"/>
								</th>
							</tr>
						</tfoot>
						<tbody>
							<xsl:for-each select="$viewAttributes">
								<xsl:variable name="thisDataAtt" select="current()"/>
								<xsl:variable name="dataAttName" select="$thisDataAtt/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="dataAttDesc" select="$thisDataAtt/own_slot_value[slot_reference = 'description']/value"/>
								<tr>
									<td>
										<!--<xsl:value-of select="$dataAttName" />-->
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$thisDataAtt"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</td>
									<td>
										<xsl:choose>
											<xsl:when test="string-length($dataAttDesc) = 0"> - </xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$dataAttDesc"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<em>
						<xsl:value-of select="eas:i18n('No View Attributes Defined')"/>
					</em>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
