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
	<xsl:variable name="linkClasses" select="('Business_Driver', 'Business_Objective', 'Business_Process', 'Individual_Business_Role', 'Group_Business_Role', 'Group_Actor', 'Product_Type', 'Site', 'Data_Object', 'Information_View', 'Application_Provider', 'Application_Service', 'Technology_Component', 'Business_Strategic_Plan', 'Information_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan', 'Technology_Composite', 'Technology_Product', 'Technology_Product_Build', 'Project', 'Business_Objective', 'Information_Architecture_Objective', 'Application_Architecture_Objectives', 'Technology_Architecture_Objectives', 'Programme', 'Site')"/>

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
				<title>
					<xsl:value-of select="eas:i18n('Stakeholder Summary')"/>
				</title>
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
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Stakeholder Summary for')"/>&#160; <span class="text-primary"><xsl:value-of select="$currentActorName"/></span></span>
									</h1>
								</div>
							</div>
						</div>

						<!--Setup Contact Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Contact Details')"/>
							</h2>
							<div class="content-section">
								<p>
									<strong><xsl:value-of select="eas:i18n('Email')"/>:&#160;&#160;</strong>
									<xsl:variable name="currentActorEmail">
										<xsl:value-of select="$currentActor/own_slot_value[slot_reference = 'email']/value"/>
									</xsl:variable>
									<a>
										<xsl:attribute name="href">
											<xsl:text>mailto:</xsl:text>
											<xsl:value-of select="$currentActorEmail"/>
										</xsl:attribute>
										<xsl:value-of select="$currentActorEmail"/>
									</a>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup Organisations Section-->

						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Member of Organisations')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($parentOrgs) = 0"/>
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

							</div>
							<hr class="visible-xs-block"/>
						</div>


						<!--Setup Locations Section-->

						<div class="col-xs-12 col-sm-6">
							<div class="sectionIcon">
								<i class="fa fa-globe icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Locations')"/>
							</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($actorBaseSite) = 0">
										<p>-</p>
									</xsl:when>
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
							<!--only show hr on xs size-->
							<hr class="visible-xs-block"/>
						</div>

						<!--add after two half width sections. hide on xs size-->
						<div class="col-xs-12 hidden-xs">
							<hr/>
						</div>


						<!--Setup Roles Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Roles')"/>
							</h2>
							<div class="content-section">
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
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
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
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
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
