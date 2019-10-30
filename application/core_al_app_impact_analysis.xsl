<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

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
	<!-- 11.03.2013	JP	Updated to support Essential Viewer version 4 -->
	<!-- param1 = the id of the application for which impact is being assessed -->


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC SETUP VARIABES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<!-- END GENERIC SETUP VARIABES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Individual_Actor', 'Business_Process', 'Group_Actor')"/>
	<xsl:variable name="currentProvider" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentProviderName" select="$currentProvider/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="currentApp" select="/node()/simple_instance[name = $param1]"/>

	<xsl:variable name="allIndivActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allIndivRoles" select="/node()/simple_instance[type = 'Individual_Business_Role']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="itContactRole" select="$allIndivRoles[own_slot_value[slot_reference = 'name']/value = 'IT Contact']"/>
	<xsl:variable name="procManagerRole" select="$allIndivRoles[own_slot_value[slot_reference = 'name']/value = 'Process Manager']"/>

	<!-- Find all the usages of this provider -->
	<xsl:variable name="aProvUsageList" select="/node()/simple_instance[type = 'Static_Application_Provider_Usage' and own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $param1]"/>
	<!-- Cross-reference with all the APU-TO-APU relations -->
	<!-- Find all the APU-TO-APU instances where this provider is at the TO end -->
	<xsl:variable name="appProvRels" select="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION' and own_slot_value[slot_reference = ':TO']/value = $aProvUsageList/name]"/>

	<!-- Now get the list of dependent applications -->
	<xsl:variable name="aDepAppListUsages" select="/node()/simple_instance[name = $appProvRels/own_slot_value[slot_reference = ':FROM']/value]"/>
	<xsl:variable name="aDepAppList" select="/node()/simple_instance[name = $aDepAppListUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>


	<!-- 06.11.2008	JWC replaced from_earelation_elements with new slot: app_pro_supports_phys_proc -->
	<!-- 06.03.2013 JWC fixed to work with Application Provider Roles -->
	<xsl:variable name="anAppProRoleIDList" select="$currentApp/own_slot_value[slot_reference = 'provides_application_services']/value"/>
	<xsl:variable name="anAppProRoleList" select="/node()/simple_instance[name = $anAppProRoleIDList]"/>

	<!--<xsl:variable name="anAppToProcRelIDs" select="own_slot_value[slot_reference='app_pro_supports_phys_proc']/value" />-->
	<xsl:variable name="anAppToProcRelIDs" select="$anAppProRoleList/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/>
	<!-- end of 06.03.2013 JWC -->

	<xsl:variable name="anAppToProcRelList" select="/node()/simple_instance[name = $anAppToProcRelIDs]"/>

	<!-- Get the set of physical Processes that are supported -->
	<!-- 06.11.2008	JWC replaced TO slot with apppro_to_physbus_to_busproc -->
	<xsl:variable name="aPhysProcList" select="/node()/simple_instance[name = $anAppToProcRelList/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>

	<!-- END VIEW SPECIFIC SETUP VARIABES -->


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
				<title>Application Impact Analysis - <xsl:value-of select="$currentProviderName"/></title>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Impact Analysis')"/>&#160;<xsl:value-of select="eas:i18n('for')"/>&#160;</span>
									<span class="text-primary">
										<xsl:value-of select="$currentProviderName"/>
									</span>
								</h1>
							</div>
						</div>


						<xsl:variable name="appProvName">
							<xsl:value-of select="$currentProvider/own_slot_value[slot_reference = 'name']/value"/>
						</xsl:variable>

						<!--Setup IT Systems Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-server icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Impact')"/>
							</h2>

							<xsl:choose>
								<xsl:when test="count($aDepAppList) > 0">
									<p>
										<xsl:value-of select="eas:i18n('The following applications would be impacted by the removal of or changes to the')"/>&#160; <xsl:value-of select="$appProvName"/>&#160; <xsl:value-of select="eas:i18n('system')"/>
									</p>
									<div>
										<xsl:call-template name="ITSystemAnalysis"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<p>
										<em><xsl:value-of select="eas:i18n('No dependent applications captured')"/>.</em>
									</p>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>



						<!--Setup Business Impact Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Impact')"/>
							</h2>

							<xsl:choose>
								<xsl:when test="count($aPhysProcList) > 0">
									<p>
										<xsl:value-of select="eas:i18n('The following business processes and teams would be impacted by the removal of or changes to the')"/>&#160; <xsl:value-of select="$appProvName"/>&#160; <xsl:value-of select="eas:i18n('system')"/>
									</p>
									<div>
										<xsl:call-template name="businessImpact"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<p>
										<em><xsl:value-of select="eas:i18n('No dependent business processes/teams captured')"/>.</em>
									</p>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>


						<!--setup closing divs-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="ITSystemAnalysis">



		<table class="table-header-background table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-25pc">
						<xsl:value-of select="eas:i18n('Application')"/>
					</th>
					<th class="cellWidth-55pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('IT Contact')"/>
					</th>
				</tr>
			</thead>
			<!-- Find the static architecture of this application provider -->
			<xsl:variable name="aStaticArchInst">
				<xsl:value-of select="own_slot_value[slot_reference = 'ap_static_architecture']/value"/>
			</xsl:variable>
			<!--
						<xsl:apply-templates select="/node()/simple_instance[name=$aStaticArchInst]" 
						mode="appArch">
						</xsl:apply-templates>
					-->
			<xsl:apply-templates select="$currentProvider" mode="appUsageRelation"> </xsl:apply-templates>
		</table>

	</xsl:template>

	<xsl:template name="businessImpact">
		<table class="table-header-background table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-25pc">
						<xsl:value-of select="eas:i18n('Business Process')"/>
					</th>
					<th class="cellWidth-35pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Business Team')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Business Contact')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<!-- Select all the business processes supported -->
				<xsl:apply-templates select="$currentProvider" mode="processInstance"> </xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>

	<!-- Interrogate the static application architecture to get the
		application used in that architecture -->
	<xsl:template match="node()" mode="appArch">
		<!-- Process the set of architecture relations -->
		<xsl:apply-templates select="own_slot_value[slot_reference = 'uses_provider']/value" mode="appUsageRelation"> </xsl:apply-templates>
	</xsl:template>

	<!-- Inspect an application provider usage to get the application provider being used 
	-->
	<xsl:template match="node()" mode="appUsageRelation">
		<xsl:variable name="aProvider">
			<xsl:value-of select="name"/>
		</xsl:variable>


		<!-- Group them together and select unique instances to avoid duplicates -->
		<xsl:for-each-group select="$aDepAppList" group-by="own_slot_value[slot_reference = 'name']/value">
			<xsl:apply-templates select="current()[1]" mode="app"> </xsl:apply-templates>
		</xsl:for-each-group>

	</xsl:template>

	<!-- Get the application provider that is impacted from a Usage of it in
		an architecture -->
	<xsl:template match="node()" mode="APU-TO-APU">
		<xsl:variable name="anAppProviderUsageInst">
			<xsl:value-of select="own_slot_value[slot_reference = ':FROM']/value"/>
		</xsl:variable>
		<xsl:apply-templates select="/node()/simple_instance[name = $anAppProviderUsageInst]" mode="appProvUsageInst"/>
	</xsl:template>

	<!-- Find the Static Application Provider Usage -->
	<xsl:template match="node()" mode="appProvUsageInst">
		<xsl:variable name="anAppProviderInst" select="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
		<xsl:apply-templates select="/node()/simple_instance[name = $anAppProviderInst]" mode="app"> </xsl:apply-templates>
	</xsl:template>

	<!-- Get the details of this Application Provider -->
	<xsl:template match="node()" mode="app">
		<xsl:variable name="appInst">
			<xsl:value-of select="name"/>
		</xsl:variable>
		<xsl:variable name="ap_name">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:variable name="aDescription">
					<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string($aDescription)">
						<xsl:value-of select="$aDescription"/>
					</xsl:when>
					<xsl:otherwise>.</xsl:otherwise>
				</xsl:choose>

			</td>

			<td>
				<xsl:variable name="appITContact" select="$allActor2Roles[(name = current()/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $itContactRole/name)]"/>
				<xsl:variable name="appITContactActor" select="$allIndivActors[name = $appITContact/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
				<xsl:choose>
					<xsl:when test="count($appITContactActor) = 0">
						<em>No information</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$appITContactActor"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

	</xsl:template>

	<!-- Find the actual instance of  a Processes supported from the specified App Provider  -->
	<xsl:template match="node()" mode="processInstance">


		<!-- Process this for unique IDs and send for rendering -->
		<xsl:for-each-group select="$aPhysProcList" group-by="name">
			<xsl:apply-templates select="current()[1]" mode="processDetail"> </xsl:apply-templates>
		</xsl:for-each-group>

	</xsl:template>

	<!-- Process the list of Physical Processes supported by the
		app in question and detail them -->
	<xsl:template match="node()" mode="processDetail">
		<xsl:variable name="aLogProcID" select="own_slot_value[slot_reference = 'implements_business_process']/value"/>
		<xsl:variable name="aLogProc" select="/node()/simple_instance[name = $aLogProcID]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$aLogProc"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<!--<xsl:value-of select="$aLogProc/own_slot_value[slot_reference='name']/value" />-->
			</td>
			<td>
				<xsl:variable name="aPhysDesc">
					<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="aLogDesc">
					<!--<xsl:value-of select="$aLogProc/own_slot_value[slot_reference='description']/value"/>-->
					<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="theSubjectInstance" select="$aLogProc"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="string($aLogDesc) or string($aPhysDesc)">
						<xsl:value-of select="$aLogDesc"/>
						<xsl:choose>
							<xsl:when test="string($aPhysDesc)">
								<br/>
								<br/>
								<b><xsl:value-of select="eas:i18n('Physical Process Description')"/>:</b>
								<br/>
								<xsl:value-of select="$aPhysDesc"/>

							</xsl:when>
						</xsl:choose>


					</xsl:when>
					<xsl:otherwise>.</xsl:otherwise>
				</xsl:choose>
			</td>

			<td>
				<xsl:variable name="anActor">
					<xsl:value-of select="own_slot_value[slot_reference = 'process_performed_by_actor_role']/value"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="count($anActor) > 0">
						<xsl:apply-templates select="own_slot_value[slot_reference = 'process_performed_by_actor_role']/value" mode="role_to_actor"> </xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<em>
							<xsl:value-of select="eas:i18n('No information')"/>
						</em>
					</xsl:otherwise>
				</xsl:choose>
			</td>

			<td>
				<xsl:variable name="busContact" select="$allActor2Roles[(name = current()/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $procManagerRole/name)]"/>
				<xsl:variable name="busContactActor" select="$allIndivActors[name = $busContact/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
				<xsl:choose>
					<xsl:when test="count($busContactActor) = 0">
						<em>
							<xsl:value-of select="eas:i18n('No information')"/>
						</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$busContactActor"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<!--<xsl:variable name="aManager">
					<xsl:value-of select="own_slot_value[slot_reference='process_manager']/value" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string($aManager)">
						<!-\- <xsl:apply-templates select="$aManager" mode="actorInstance"> -\->
						<xsl:apply-templates select="/node()/simple_instance[name=$aManager]" mode="ActorDetails"> </xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<em>No information</em>
					</xsl:otherwise>
				</xsl:choose>-->
			</td>
		</tr>
	</xsl:template>

	<!-- Find the actual instance of the relationships -->
	<xsl:template match="node()" mode="role_to_actor">
		<xsl:variable name="anActorRole">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:apply-templates select="/node()/simple_instance[name = $anActorRole]" mode="Actor"> </xsl:apply-templates>
	</xsl:template>

	<!-- Find the Actor instance that will be impacted -->
	<xsl:template match="node()" mode="Actor">
		<!-- 06.11.2008	JWC replaced the 'FROM' slot with the refactored act_to_role_from_actor slot -->
		<xsl:variable name="anActorInstance">
			<xsl:value-of select="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
		</xsl:variable>
		<xsl:apply-templates select="/node()/simple_instance[name = $anActorInstance]" mode="ActorDetails"> </xsl:apply-templates>
	</xsl:template>

	<!-- Find the Actor instance node for the specified instance -->
	<xsl:template match="node()" mode="actorInstance">
		<xsl:variable name="anActorInstance">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:apply-templates select="/node()/simple_instance[name = $anActorInstance]" mode="ActorDetails"> </xsl:apply-templates>
	</xsl:template>

	<!-- Show the Actor details - the name -->
	<xsl:template match="node()" mode="ActorDetails">
		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="theXML" select="$reposXML"/>
			<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
		</xsl:call-template>
		<!--<xsl:variable name="anActorName">
			<xsl:value-of select="own_slot_value[slot_reference='name']/value" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string($anActorName)">
				<xsl:value-of select="$anActorName" />
			</xsl:when>
			<xsl:otherwise>.</xsl:otherwise>
		</xsl:choose>-->
		<br/>
	</xsl:template>




</xsl:stylesheet>
