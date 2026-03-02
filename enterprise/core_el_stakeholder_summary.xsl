<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="param1"/>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value"/>

	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="currentActor" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentActorName" select="$currentActor/own_slot_value[slot_reference = 'name']/value"/>
	<!--<xsl:variable name="currentActorEmail" select="$currentActor/own_slot_value[slot_reference='email']/value" />-->
	<xsl:variable name="relevantActor2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $param1]"/>
	<xsl:variable name="stakeholderElements" select="/node()/simple_instance[own_slot_value[slot_reference = 'stakeholders']/value = $relevantActor2Roles/name]"/>
	<xsl:variable name="relevantRoles" select="/node()/simple_instance[name = $relevantActor2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="parentOrgs" select="/node()/simple_instance[name = $currentActor/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
	<!--<xsl:variable name="parentOrgName" select="$parentOrg/own_slot_value[slot_reference='name']/value" />-->
	<xsl:variable name="actorBaseSite" select="/node()/simple_instance[name = $currentActor/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="parentBaseSites" select="/node()/simple_instance[name = $parentOrgs/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allActor2Jobs" select="/node()/simple_instance[type = 'ACTOR_TO_JOB_RELATION']"/>
	<xsl:variable name="allJobs" select="/node()/simple_instance[type = 'Job_Position']"/>
	<xsl:variable name="allJobManagementLevels" select="/node()/simple_instance[type = 'Job_Position_Management_Level']"/>
	<xsl:variable name="relevantActor2Jobs" select="$allActor2Jobs[(own_slot_value[slot_reference = 'actor_to_job_from_actor']/value = $param1) or (name = $currentActor/own_slot_value[slot_reference = 'actor_has_jobs']/value)]"/>
	<xsl:variable name="relevantJobs" select="$allJobs[name = $relevantActor2Jobs/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]"/>
	<xsl:variable name="relevantJobManagementLevels" select="$allJobManagementLevels[name = $relevantJobs/own_slot_value[slot_reference = 'job_position_management_level']/value]"/>

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
				<title>
					<xsl:value-of select="eas:i18n('Stakeholder Summary')"/>
				</title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>
				<style type="text/css">
					.parent-superflex {
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					
					.superflex {
						border: 1px solid #ddd;
						padding: 10px;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						flex-grow: 1;
						flex-basis: 1;
					}
					
					.superflex > h3 {
						font-weight: 600;
					}
					
					.superflex > label {
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
					}
					
					.ess-string {
						background-color: #f6f6f6;
						padding: 5px;
						display: inline-block;
					}
					
					.superflex ul {
						padding-left: 18px;
					}
					
					@media print {
						#summary-content .tab-content > .tab-pane {
							display: block !important;
							visibility: visible !important;
						}
						
						#summary-content .no-print {
							display: none !important;
							visibility: hidden !important;
						}
						
						#summary-content .tab-pane {
							page-break-after: always;
						}
					}
					
					@media screen {
						#summary-content .print-only {
							display: none !important;
							visibility: hidden !important;
						}
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
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid" id="summary-content">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Stakeholder Summary for')"/>&#160; <span class="text-primary"><xsl:value-of select="$currentActorName"/></span></span>
									</h1>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
							<ul class="nav nav-tabs tabs-left">
								<li class="active">
									<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-user right-10"></i><xsl:value-of select="eas:i18n('Details')"/></a>
								</li>
								<li>
									<a href="#roles" data-toggle="tab"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Roles')"/></a>
								</li>
								<xsl:if test="count($relevantActor2Jobs) > 0">
									<li>
										<a href="#jobs" data-toggle="tab"><i class="fa fa-fw fa-briefcase right-10"></i><xsl:value-of select="eas:i18n('Jobs')"/></a>
									</li>
								</xsl:if>
							</ul>
						</div>

						<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
							<div class="tab-content">
								<div class="tab-pane active" id="details">
									<h2 class="print-only"><i class="fa fa-fw fa-user right-10"></i><xsl:value-of select="eas:i18n('Stakeholder Details')"/></h2>
									<div class="parent-superflex">
										<div class="superflex">
											<xsl:variable name="currentActorEmail" select="$currentActor/own_slot_value[slot_reference = 'email']/value"/>
											<h3 class="text-primary"><i class="fa fa-user right-10"></i><xsl:value-of select="eas:i18n('Contact Details')"/></h3>
											<label><xsl:value-of select="eas:i18n('Name')"/></label>
											<div class="ess-string">
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$currentActor"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</div>
											<div class="clearfix bottom-10"/>
											<label><xsl:value-of select="eas:i18n('Email')"/></label>
											<div>
												<xsl:choose>
													<xsl:when test="string-length($currentActorEmail) > 0">
														<a>
															<xsl:attribute name="href">
																<xsl:text>mailto:</xsl:text>
																<xsl:value-of select="$currentActorEmail"/>
															</xsl:attribute>
															<xsl:value-of select="$currentActorEmail"/>
														</a>
													</xsl:when>
													<xsl:otherwise>-</xsl:otherwise>
												</xsl:choose>
											</div>
										</div>
										<div class="superflex">
											<h3 class="text-primary"><i class="fa fa-sitemap right-10"></i><xsl:value-of select="eas:i18n('Organisational Context')"/></h3>
											<label><xsl:value-of select="eas:i18n('Member of Organisations')"/></label>
											<xsl:choose>
												<xsl:when test="count($parentOrgs) = 0">-</xsl:when>
												<xsl:otherwise>
													<ul>
														<xsl:for-each select="$parentOrgs">
															<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
											<div class="clearfix bottom-10"/>
											<label><xsl:value-of select="eas:i18n('Locations')"/></label>
											<xsl:choose>
												<xsl:when test="count($actorBaseSite) = 0">-</xsl:when>
												<xsl:otherwise>
													<ul>
														<xsl:for-each select="$actorBaseSite">
															<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
										</div>
									</div>
								</div>
								<div class="tab-pane" id="roles">
									<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Roles')"/></h2>
									<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Roles')"/></h3>
										<xsl:choose>
											<xsl:when test="count($relevantActor2Roles) > 0">
												<p><xsl:value-of select="eas:i18n('The following roles are defined for')"/>&#160; <strong><xsl:value-of select="$currentActorName"/></strong></p>
												<div class="verticalSpacer_10px"/>
												<xsl:call-template name="Actor2Roles"/>
											</xsl:when>
											<xsl:otherwise>
												<p>
													<em>
														<xsl:value-of select="eas:i18n('No business roles defined for')"/>&#160; <xsl:value-of select="$currentActorName"/>
													</em>
												</p>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</div>
								<xsl:if test="count($relevantActor2Jobs) > 0">
									<div class="tab-pane" id="jobs">
										<h2 class="print-only top-30"><i class="fa fa-fw fa-briefcase right-10"></i><xsl:value-of select="eas:i18n('Jobs')"/></h2>
										<div class="superflex">
											<h3 class="text-primary"><i class="fa fa-briefcase right-10"></i><xsl:value-of select="eas:i18n('Jobs')"/></h3>
											<p><xsl:value-of select="eas:i18n('The following jobs are defined for')"/>&#160; <strong><xsl:value-of select="$currentActorName"/></strong></p>
											<xsl:call-template name="Actor2Jobs"/>
										</div>
									</div>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="Organisations"> </xsl:template>


	<xsl:template name="Actor2Roles">

		<table class="table table-bordered table-striped ">
			<thead>
				<tr>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Role')"/>
					</th>
					<th class="cellWidth-40pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Responsibilities')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="Actor2RoleRow" select="$relevantActor2Roles">
					<xsl:sort select="own_slot_value[slot_reference = 'relation_name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="Actor2Jobs">
		<table class="table table-bordered table-striped ">
			<thead>
				<tr>
					<th class="cellWidth-60pc">
						<xsl:value-of select="eas:i18n('Job')"/>
					</th>
					<xsl:if test="count($relevantJobManagementLevels) > 0">
						<th class="cellWidth-40pc">
							<xsl:value-of select="eas:i18n('Management Level')"/>
						</th>
					</xsl:if>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="Actor2JobRow" select="$relevantActor2Jobs">
					<xsl:sort select="$allJobs[name = current()/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]/own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template mode="Actor2RoleRow" match="node()">

		<xsl:variable name="relevantRole" select="$relevantRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
		<xsl:variable name="relevantElements" select="$stakeholderElements[own_slot_value[slot_reference = 'stakeholders']/value = current()/name]"/>
		<xsl:variable name="roleDesc" select="$relevantRole/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantRole) > 0">
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$relevantRole"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
					</xsl:when>
					<xsl:otherwise>
						<em>Role undefined</em>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($roleDesc) > 0">
						<xsl:value-of select="$roleDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantElements) > 0">
						<ul>
							<xsl:for-each select="$relevantElements">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
									<span class="text-muted">&#160;(<xsl:value-of select="replace(type,'_',' ')"/>)</span>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template mode="Actor2JobRow" match="node()">
		<xsl:variable name="relevantJob" select="$relevantJobs[name = current()/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]"/>
		<xsl:variable name="jobTitle" select="current()/own_slot_value[slot_reference = 'actor_to_job_job_title']/value"/>
		<xsl:variable name="jobManagementLevel" select="$allJobManagementLevels[name = $relevantJob/own_slot_value[slot_reference = 'job_position_management_level']/value][1]"/>
		<xsl:variable name="jobManagementLevelName" select="$jobManagementLevel/own_slot_value[slot_reference = 'enumeration_value']/value"/>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantJob) > 0">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$relevantJob"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="displayString">
								<xsl:choose>
									<xsl:when test="string-length($jobTitle) > 0">
										<xsl:value-of select="$jobTitle"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$relevantJob/own_slot_value[slot_reference = 'name']/value"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<em><xsl:value-of select="eas:i18n('Job undefined')"/></em>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:if test="count($relevantJobManagementLevels) > 0">
				<td>
					<xsl:if test="count($jobManagementLevel) > 0">
						<xsl:choose>
							<xsl:when test="string-length($jobManagementLevelName) > 0">
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$jobManagementLevel"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									<xsl:with-param name="displayString" select="$jobManagementLevelName"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$jobManagementLevel"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>

	<!--<xsl:template name="Roles">
		
			<table class="table table-bordered table-striped ">
				<thead>
					<tr>
						<th class="cellWidth-30pc">Role</th>
						<th class="cellWidth-40pc"><xsl:value-of select="eas:i18n('Description')"/></th>
						<th class="cellWidth-40pc">Responsibility</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="$relevantRoles">
						<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
						<xsl:variable name="roleDesc" select="own_slot_value[slot_reference='description']/value"/>
						<tr>
							<td>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()" />
									<xsl:with-param name="theXML" select="$reposXML" />
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
								</xsl:call-template>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="string-length($roleDesc) > 0">
										<xsl:value-of select="$roleDesc"/>
									</xsl:when>
									<xsl:otherwise>-</xsl:otherwise>
								</xsl:choose>		
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
	</xsl:template>-->
</xsl:stylesheet>
