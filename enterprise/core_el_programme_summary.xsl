<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
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
	<!-- param1 = the id of the project that is being summarised -->
	<xsl:param name="param1"/>

	<!-- param2 = the parent business capability for the BCM -->
	<xsl:param name="param2"/>

	<!-- param3 = the taxonomy term used to scope the view -->
	<xsl:param name="param3"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<!--<xsl:variable name="linkClasses" select="('Business_Role', 'Group_Actor', 'Individual_Actor', 'Programme', 'Project', 'Business_Process', 'Application_Provider', 'Composite_Application_Provider')"/>-->
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root Business Capability']"/>

	<xsl:variable name="busCapability" select="$allBusinessCaps[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="busCapName" select="$busCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $busCapability/name]"/>

	<!-- SET THE VARIABLES THAT ARE REQUIRED REPEATEDLY THROUGHOUT -->
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider', 'Application_Provider_Interface')]"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[(type = 'Application_Service') or (type = 'Composite_Application_Service')]"/>
	<xsl:variable name="allAppRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
	<xsl:variable name="allBusProc2AppSvcs" select="/node()/simple_instance[type = 'APP_SVC_TO_BUS_RELATION']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allIndividualRoles" select="/node()/simple_instance[type = 'Individual_Business_Role']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	
	<xsl:variable name="impactActions" select="/node()/simple_instance[type = 'Planning_Action']"/>
	<xsl:variable name="allImpactActionStyles" select="/node()/simple_instance[name = $impactActions/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	<xsl:variable name="relevantProjects" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_programme']/value = $param1]"/>
	<!--<xsl:variable name="topLevelBusCapabilities" select="/node()/simple_instance[own_slot_value[slot_reference='supports_business_capabilities']/value=$param2]"/>-->


	<xsl:variable name="projectManagerRole" select="$allIndividualRoles[own_slot_value[slot_reference = 'name']/value = 'Project Manager']"/>

	<xsl:variable name="programme" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="programmeName" select="$programme/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="programmeDesc" select="$programme/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="programmeStakeholders" select="$allActor2Roles[name = $programme/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="programmeActors" select="$allIndividualActors[name = $programmeStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="programmeRoles" select="$allIndividualRoles[name = $programmeStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

	<xsl:variable name="projects" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_programme']/value = $programme/name]"/>

	<xsl:variable name="allStratPlanToElementRelations" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][name = $projects/own_slot_value[slot_reference = 'ca_planned_changes']/value]"/>

	<xsl:variable name="projectStakeholders" select="$allActor2Roles[name = $projects/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="projectActors" select="$allIndividualActors[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="projectRoles" select="$allIndividualRoles[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="projectCount" select="count($projects)"/>

	<xsl:variable name="relevantStrategicPlans" select="/node()/simple_instance[name = $projects/own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value]"/>


	<xsl:variable name="relevantDirectStrategicPlans" select="/node()/simple_instance[name = $projects/own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value]"/>
	<xsl:variable name="directStrategicPlanImpactedElements" select="/node()/simple_instance[not((type = 'PLAN_TO_ELEMENT_RELATION')) and (name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>

	<xsl:variable name="projectDeprectatedStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>
	<xsl:variable name="impactedElementViaDeprectedStrategicPlansRels" select="/node()/simple_instance[name = $projectDeprectatedStrategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>

	<xsl:variable name="projectStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $relevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value)]"/>
	<xsl:variable name="impactedElementViaStrategicPlansRels" select="/node()/simple_instance[name = $projectStrategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>

	<xsl:variable name="projectPlan2ElementRels" select="$allStratPlanToElementRelations[name = $projects/own_slot_value[slot_reference = 'ca_planned_changes']/value]"/>
	<xsl:variable name="directImpactedElements" select="/node()/simple_instance[name = $projectPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
	<xsl:variable name="directImpactedStrategicPlans" select="/node()/simple_instance[name = $projectPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>

	<xsl:variable name="projectImpactedElements" select="$impactedElementViaDeprectedStrategicPlansRels union $impactedElementViaStrategicPlansRels union $directStrategicPlanImpactedElements union $directImpactedElements"/>
	<xsl:variable name="allRelevantStrategicPlans" select="$relevantDirectStrategicPlans union $directImpactedStrategicPlans"/>

	<!-- Define the meta-class to label mappings across the architecture layers -->
	<xsl:variable name="businessLayerClasses" select="('Business_Objective', 'Business_Driver', 'Business_Capability', 'Business_Process', 'Business_Activity', 'Individual_Business_Role', 'Group_Business_Role', 'Product_Type', 'Product', 'Channel', 'Group_Actor', 'Site', 'Physical_Process', 'Physical_Activity')"/>
	<xsl:variable name="businessLayerLabels" select="(eas:i18n('Business Objective'), eas:i18n('Business Driver'), eas:i18n('Business Capability'), eas:i18n('Business Process'), eas:i18n('Business Activity'), eas:i18n('Individual Role'), eas:i18n('Organisation Role'), eas:i18n('Service Type'), eas:i18n('Service'), eas:i18n('Communication Channel'), eas:i18n('Organisation'), eas:i18n('Location'), eas:i18n('Implemented Process'), eas:i18n('Implemented Activity'))"/>

	<xsl:variable name="infoLayerClasses" select="('Information_View', 'Data_Subject', 'Data_Object', 'Data_Representation', 'Security_Policy', 'Information_Store')"/>
	<xsl:variable name="infoLayerLabels" select="(eas:i18n('Information Object'), eas:i18n('Data Subject'), eas:i18n('Data Object'), eas:i18n('Data Representation'), eas:i18n('Security Policy'), eas:i18n('Information/Data Store'))"/>

	<xsl:variable name="appLayerClasses" select="('Application_Service', 'Application_Provider_Interface', 'Composite_Application_Provider', 'Application_Provider', 'Application_Function', 'Application_Deployment')"/>
	<xsl:variable name="appLayerLabels" select="(eas:i18n('Application Service'), eas:i18n('Application Interface'), eas:i18n('Application'), eas:i18n('Application'), eas:i18n('Application Function'), eas:i18n('Application Deployment'))"/>

	<xsl:variable name="techLayerClasses" select="('Technology_Capability', 'Technology_Component', 'Technology_Product', 'Technology_Product_Build', 'Infrastructure_Software_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Hardware_Instance', 'Technology_Node')"/>
	<xsl:variable name="techLayerLabels" select="(eas:i18n('Technology Capability'), eas:i18n('Technology Component'), eas:i18n('Technology Product'), eas:i18n('Technology Build'), eas:i18n('Infrastructure Software Instance'), eas:i18n('Application Software Instance'), eas:i18n('Information/Data Store Instance'), eas:i18n('Hardware Instance'), eas:i18n('Technology Node'))"/>

	<!-- Set up the requierd link classes -->
	<xsl:variable name="linkClasses" select="($busCapability union $projects union $projectImpactedElements union $allRelevantStrategicPlans union $projectActors union $programme)/type"/>

	<xsl:variable name="footPrintClass" select="'gradLevel4  text-white'"/>
	<xsl:variable name="noImpactClass" select="''"/>

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Programme Overview for')"/>
		<xsl:value-of select="$programmeName"/>
	</xsl:variable>

	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$topLevelBusCapabilities[own_slot_value[slot_reference = 'elements_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeBusCaps" select="$topLevelBusCapabilities"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Programme Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeBusCaps"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:call-template name="dataTablesLibrary"/>
			</head>

			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->

				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Programme Summary for')"/>&#160;<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$programme"/>
											<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
										</xsl:call-template></span>
								</h1>
							</div>
						</div>


						<!--Setup Description Section-->
					</div>
					<div class="row"> 
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>

							<div class="content-section">
								<p>
									<xsl:value-of select="$programmeDesc"/>
								</p>
							</div>
							<hr/>
						</div>



						<!--Setup Roles and People Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary"><xsl:value-of select="eas:i18n('Roles')"/> &amp; <xsl:value-of select="eas:i18n('People')"/></h2>


							<div class="content-section">
								<xsl:call-template name="Roles"/>
							</div>
							<hr/>
						</div>



						<!--Setup Business Footprint Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-paw icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Business Footprint')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following diagram highlights the conceptual business capabilities impacted by this programme')"/>.</p>
								<xsl:variable name="fullWidth" select="count($topLevelBusCapabilities) * 140"/>
								<xsl:variable name="widthStyle" select="concat('width:', $fullWidth, 'px;')"/>
								<div class="simple-scroller">
									<div>
										<xsl:attribute name="style" select="$widthStyle"/>
										<xsl:apply-templates mode="RenderBusinessCapabilityColumn" select="$inScopeBusCaps">
											<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
										</xsl:apply-templates>
									</div>
								</div>
							</div>
							<hr/>
						</div>



						<!--Setup Supporting Projects Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Projects')"/>
							</h2>
							<div class="content-section">
								<xsl:apply-templates mode="RenderProjectSection" select="$relevantProjects"/>
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
				<script type="text/javascript">
					$('document').ready(function(){
						 $(".compModelContent").vAlign();
						 $('.hideOnLoad').hide();
					});
				</script>
				<script src="js/showhidediv.js?release=6.19" type="text/javascript"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<!-- render a column of business capabilities -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityColumn">

		<div class="compModelColumn">
			<div class="compModelElementContainer">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'compModelContent backColour3 text-white small impact tabTop'"/>
					<xsl:with-param name="anchorClass" select="'text-white small'"/>
				</xsl:call-template>
			</div>
			<xsl:variable name="supportingBusCaps" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderBusinessCapabilityCell" select="$supportingBusCaps">
				<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>



	<!-- render a business capability cell -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityCell">
		<xsl:variable name="busCapChildren" select="eas:findAllSubCaps(current(), ())"/>
		<xsl:variable name="activityTotal">
			<xsl:call-template name="Calculate_Project_Activity">
				<xsl:with-param name="currentCap" select="$busCapChildren"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="divClass">
			<xsl:choose>
				<xsl:when test="$activityTotal = 0">
					<xsl:value-of select="concat('compModelContent small text-darkgrey', $noImpactClass)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('compModelContent small ', $footPrintClass)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="anchorClass">
			<xsl:choose>
				<xsl:when test="$activityTotal = 0">
					<xsl:value-of select="'text-darkgrey'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'text-white'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<div class="compModelElementContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="$divClass"/>
				<xsl:with-param name="anchorClass" select="$anchorClass"/>
			</xsl:call-template>
		</div>
	</xsl:template>



	<xsl:template name="Roles">
		<xsl:choose>
			<xsl:when test="count($programmeStakeholders) = 0">
				<p>
					<em>
						<xsl:value-of select="eas:i18n('No stakeholders defined for this programme')"/>
					</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Role')"/>
							</th>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Person')"/>
							</th>
							<!-- <th class="cellWidth-20pc">Location</th> -->
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Email')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$programmeStakeholders">
							<xsl:variable name="progActor" select="$programmeActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
							<xsl:variable name="actorName" select="$progActor/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="progRole" select="$programmeRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
							<xsl:variable name="roleName" select="$progRole/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="actorEmail" select="$progActor/own_slot_value[slot_reference = 'email']/value"/>
							<tr>
								<td>
									<strong>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$progRole"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</strong>
								</td>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$progActor"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:if test="string-length($actorEmail) > 0">
										<xsl:variable name="mailToString" select="concat('mailto:', $actorEmail, '?Subject=Re: ', $programmeName)"/>
										<a>
											<xsl:attribute name="href" select="$mailToString"/>
											<xsl:value-of select="$actorEmail"/>
										</a>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>

					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- render a Project section -->
	<xsl:template match="node()" mode="RenderProjectSection">
		<xsl:variable name="project" select="current()"/>
		<xsl:variable name="projectManager2Role" select="$allActor2Roles[(own_slot_value[slot_reference = 'act_to_role_to_role']/value = $projectManagerRole/name) and (name = current()/own_slot_value[slot_reference = 'stakeholders']/value)]"/>
		<xsl:variable name="projectManager" select="$allIndividualActors[name = $projectManager2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="processTableId" select="concat('ProcTable', current()/name)"/>
		<xsl:variable name="appTableId" select="concat('AppTable', current()/name)"/>
		<div class="ProgrammeContainer">
			<h3 class="ProgrammeComponentTitle"><xsl:value-of select="eas:i18n('Project')"/>: <xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h3>
			<div class="verticalSpacer_5px"/>
			<table>
				<tbody>
					<tr>
						<td class="cellWidth-20pc">
							<strong><xsl:value-of select="eas:i18n('Description')"/>:</strong>
						</td>
						<td class="cellWidth-80pc">
							<xsl:variable name="projectDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
							<xsl:choose>
								<xsl:when test="exists($projectDescription)">
									<xsl:value-of select="$projectDescription"/>
								</xsl:when>
								<xsl:otherwise>&#160;</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td>
							<strong><xsl:value-of select="eas:i18n('Project Manager')"/>:</strong>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="count($projectManager) > 0">
									<xsl:for-each select="$projectManager">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
										<xsl:if test="not(position() = last())">, </xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>&#160;</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="verticalSpacer_5px"/>
			<div class="ShowHideDivTrigger ShowHideDivOpen" onclick="table.fnAdjustColumnSizing()">
				<a class="ShowHideDivLink small" href="#">
					<xsl:value-of select="eas:i18n('Show/Hide Impacted Elements')"/>
				</a>
			</div>
			<div class="-hiddenDiv hideOnLoad">
				<div class="verticalSpacer_10px"/>
				<xsl:variable name="thisImpactedProjectToElements" select="$allStratPlanToElementRelations[name = current()/own_slot_value[slot_reference = 'ca_planned_changes']/value]"/>
				<xsl:variable name="thisImpactedElements" select="$directImpactedElements[name = $thisImpactedProjectToElements/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
				 

				<xsl:variable name="thisRelevantDirectStrategicPlans" select="$relevantDirectStrategicPlans[name = $project/own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value]"/>
				<xsl:variable name="thisDirectStrategicPlanImpactedElements" select="$directStrategicPlanImpactedElements[not((type = 'PLAN_TO_ELEMENT_RELATION')) and (name = $thisRelevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>

				<xsl:variable name="thisProjectDeprectatedStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $thisRelevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value)]"/>
				<xsl:variable name="thisImpactedElementViaDeprectedStrategicPlansRels" select="$impactedElementViaDeprectedStrategicPlansRels[name = $thisProjectDeprectatedStrategicPlanRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
				
				<xsl:variable name="thisProjectStrategicPlanRelations" select="$allStratPlanToElementRelations[(name = $thisRelevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value)]"/>
				<xsl:variable name="thisProjectStrategicPlanRelationsProj" select="$thisProjectStrategicPlanRelations[name=$project/own_slot_value[slot_reference = 'ca_planned_changes']/value]"/>

				<xsl:variable name="thisImpactedElementViaStrategicPlansRels" select="$impactedElementViaStrategicPlansRels[name = $thisProjectStrategicPlanRelationsProj/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
 

				<xsl:variable name="thisProjectPlan2ElementRels" select="$allStratPlanToElementRelations[name = $project/own_slot_value[slot_reference = 'ca_planned_changes']/value]"/>
				<xsl:variable name="thisDirectImpactedElements" select="$directImpactedElements[name = $thisProjectPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
				<xsl:variable name="thisDirectImpactedStrategicPlans" select="$directImpactedStrategicPlans[name = $thisProjectPlan2ElementRels/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
 

			<!-- <xsl:variable name="thisProjectImpactedElements" select="$thisImpactedElementViaDeprectedStrategicPlansRels union $thisImpactedElementViaStrategicPlansRels union $thisDirectStrategicPlanImpactedElements union $thisDirectImpactedElements"/> -->
			 <xsl:variable name="thisProjectImpactedElements" select="$thisDirectImpactedElements"/> 

				<!--<xsl:variable name="projectStrategicPlans" select="$relevantStrategicPlans[name = current()/own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value]"/>
				<xsl:variable name="impactedProcesses" select="$allBusProcs[name = $projectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>-->

				<xsl:variable name="busLayerElements" select="$thisImpactedElements[type = $businessLayerClasses]"/>
				<xsl:variable name="infoDataLayerElements" select="$thisImpactedElements[type = $infoLayerClasses]"/>
				<xsl:variable name="appLayerElements" select="$thisImpactedElements[type = $appLayerClasses]"/>
				<xsl:variable name="techLayerElements" select="$thisImpactedElements[type = $techLayerClasses]"/>
		
				<xsl:choose>
					<xsl:when test="count(($busLayerElements, $infoDataLayerElements, $appLayerElements, $techLayerElements)) > 0">

						<!-- Render the Business Elements Table -->
						<xsl:variable name="busLayerTableId" select="concat('busTable', index-of($projects, $project))"/>
						<xsl:call-template name="ImpactedElements">
							<xsl:with-param name="elementTableId" select="$busLayerTableId"/>
							<xsl:with-param name="layerElements" select="$busLayerElements"/>
							<xsl:with-param name="layerClasses" select="$businessLayerClasses"/>
							<xsl:with-param name="layerLabels" select="$businessLayerLabels"/>
							<xsl:with-param name="layerType">Business</xsl:with-param>
						<!--	<xsl:with-param name="layerProjectDeprectatedStrategicPlanRelations" select="$thisProjectDeprectatedStrategicPlanRelations"/>-->
							<xsl:with-param name="layerProjectPlan2ElementRels" select="$thisImpactedProjectToElements"/>
						<!--	<xsl:with-param name="layerProjectStrategicPlanRelations" select="$thisProjectStrategicPlanRelations"/>
							<xsl:with-param name="layerRelevantDirectStrategicPlans" select="$thisRelevantDirectStrategicPlans"/> -->
						</xsl:call-template>

						<!-- Render the Info/Data Elements Table -->
						<xsl:variable name="infoLayerTableId" select="concat('infoDataTable', index-of($projects, $project))"/>
						<xsl:call-template name="ImpactedElements">
							<xsl:with-param name="elementTableId" select="$infoLayerTableId"/>
							<xsl:with-param name="layerElements" select="$infoDataLayerElements"/>
							<xsl:with-param name="layerClasses" select="$infoLayerClasses"/>
							<xsl:with-param name="layerLabels" select="$infoLayerLabels"/>
							<xsl:with-param name="layerType">Information/Data</xsl:with-param>
							<!--	<xsl:with-param name="layerProjectDeprectatedStrategicPlanRelations" select="$thisProjectDeprectatedStrategicPlanRelations"/>-->
							<xsl:with-param name="layerProjectPlan2ElementRels" select="$thisImpactedProjectToElements"/>
						<!--	<xsl:with-param name="layerProjectStrategicPlanRelations" select="$thisProjectStrategicPlanRelations"/>
							<xsl:with-param name="layerRelevantDirectStrategicPlans" select="$thisRelevantDirectStrategicPlans"/> -->
						</xsl:call-template>

						<!-- Render the Application Elements Table -->
						<xsl:variable name="appLayerTableId" select="concat('appTable', index-of($projects, $project))"/>
						<xsl:call-template name="ImpactedElements">
							<xsl:with-param name="elementTableId" select="$appLayerTableId"/>
							<xsl:with-param name="layerElements" select="$appLayerElements"/>
							<xsl:with-param name="layerClasses" select="$appLayerClasses"/>
							<xsl:with-param name="layerLabels" select="$appLayerLabels"/>
							<xsl:with-param name="layerType">Application</xsl:with-param>
							<!--	<xsl:with-param name="layerProjectDeprectatedStrategicPlanRelations" select="$thisProjectDeprectatedStrategicPlanRelations"/>-->
							<xsl:with-param name="layerProjectPlan2ElementRels" select="$thisImpactedProjectToElements"/>
						<!--	<xsl:with-param name="layerProjectStrategicPlanRelations" select="$thisProjectStrategicPlanRelations"/>
							<xsl:with-param name="layerRelevantDirectStrategicPlans" select="$thisRelevantDirectStrategicPlans"/> -->
						</xsl:call-template>

						<!-- Render the Technology Elements Table -->
						<xsl:variable name="techLayerTableId" select="concat('techTable', index-of($projects, $project))"/>
						<xsl:call-template name="ImpactedElements">
							<xsl:with-param name="elementTableId" select="$techLayerTableId"/>
							<xsl:with-param name="layerElements" select="$techLayerElements"/>
							<xsl:with-param name="layerClasses" select="$techLayerClasses"/>
							<xsl:with-param name="layerLabels" select="$techLayerLabels"/>
							<xsl:with-param name="layerType">Technology</xsl:with-param>
							<!--	<xsl:with-param name="layerProjectDeprectatedStrategicPlanRelations" select="$thisProjectDeprectatedStrategicPlanRelations"/>-->
							<xsl:with-param name="layerProjectPlan2ElementRels" select="$thisImpactedProjectToElements"/>
						<!--	<xsl:with-param name="layerProjectStrategicPlanRelations" select="$thisProjectStrategicPlanRelations"/>
							<xsl:with-param name="layerRelevantDirectStrategicPlans" select="$thisRelevantDirectStrategicPlans"/> -->
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<em>
							<xsl:value-of select="eas:i18n('No elements impacted by')"/>
							<xsl:text>&#160;</xsl:text>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$project"/>
							</xsl:call-template>
						</em>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="ImpactedElements">
		<xsl:param name="elementTableId"/>
		<xsl:param name="layerRelevantDirectStrategicPlans" select="()"/>
		<xsl:param name="layerProjectStrategicPlanRelations" select="()"/>
		<xsl:param name="layerProjectDeprectatedStrategicPlanRelations" select="()"/>
		<xsl:param name="layerProjectPlan2ElementRels" select="()"/>
		<xsl:param name="layerElements" select="()"/>
		<xsl:param name="layerClasses">()</xsl:param>
		<xsl:param name="layerLabels">()</xsl:param>
		<xsl:param name="layerType"/>


		<xsl:if test="count($layerElements) > 0">
			<xsl:variable name="allDirectPlanLayerElements" select="$layerElements[name = $layerRelevantDirectStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>
			<div class="verticalSpacer_10px floatLeft"/>
			<script>
					$(document).ready(function(){
						
						var table = $('#<xsl:value-of select="$elementTableId"/>').DataTable({
						scrollY: "350px",
						scrollCollapse: true,
						paging: false,
						info: false,
						sort: true,
						responsive: true,
						columns: [
						    { "width": "20%" },
						    { "width": "25%" },
						    { "width": "40%" },
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
					});
				</script>
			<table class="table table-bordered table-striped" id="{$elementTableId}">
				<caption class="fontBlack alignLeft text-white uppercase backColour3">&#160;&#160;<xsl:value-of select="$layerType"/>&#160;Elements</caption>
				<thead>
					<tr>
						<th>
							<xsl:value-of select="eas:i18n('Type')"/>
						</th>
						<th>
							<xsl:value-of select="eas:i18n($layerType)"/>&#160;<xsl:value-of select="eas:i18n('Element')"/>
						</th>
						<th>
							<xsl:value-of select="eas:i18n('Description')"/>
						</th>
						<th>
							<xsl:value-of select="eas:i18n('Impact')"/>
						</th>
					</tr>
				</thead>
				<tbody>
					

					<xsl:variable name="thisAllDirectStrategicPlanRels" select="$layerProjectPlan2ElementRels[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $layerElements/name]"/>
				 
					<xsl:call-template name="RenderPlan2ElementsRelations">
						<xsl:with-param name="relations" select="$thisAllDirectStrategicPlanRels"/>
						<xsl:with-param name="usedRelations" select="()"/>
						<xsl:with-param name="layerElements" select="$layerElements"/>
						<xsl:with-param name="layerClasses" select="$layerClasses"/>
						<xsl:with-param name="layerLabels" select="$layerLabels"/>
					</xsl:call-template>

				</tbody>
			</table>
		</xsl:if>

	</xsl:template>


	<xsl:template name="RenderPlan2ElementsRelations">
		<xsl:param name="relations" select="()"/>
		<xsl:param name="usedRelations" select="()"/>
		<xsl:param name="layerElements" select="()"/>
		<xsl:param name="layerClasses" select="()"/>
		<xsl:param name="layerLabels" select="()"/>

		<xsl:if test="count($relations) > 0">
			<xsl:variable name="nextRelation" select="$relations[1]"/>
			<xsl:if test="not(($nextRelation/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $usedRelations/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value) and ($nextRelation/own_slot_value[slot_reference = 'plan_to_element_change_action']/value = $usedRelations/own_slot_value[slot_reference = 'plan_to_element_change_action']/value))">
				<xsl:variable name="relatedElement" select="$layerElements[name = $nextRelation/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value]"/>
				<xsl:variable name="relatedImpact" select="$impactActions[name = $nextRelation/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>
				<xsl:call-template name="RenderElementImpactRow">
					<xsl:with-param name="element" select="$relatedElement"/>
					<xsl:with-param name="elementImpact" select="$relatedImpact"/>
					<xsl:with-param name="layerClasses" select="$layerClasses"/>
					<xsl:with-param name="layerLabels" select="$layerLabels"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="RenderPlan2ElementsRelations">
				<xsl:with-param name="relations" select="$relations except $nextRelation"/>
				<xsl:with-param name="usedRelations" select="$usedRelations union $nextRelation"/>
				<xsl:with-param name="layerElements" select="$layerElements"/>
				<xsl:with-param name="layerClasses" select="$layerClasses"/>
				<xsl:with-param name="layerLabels" select="$layerLabels"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="RenderElementImpactRow">
		<xsl:param name="element"/>
		<xsl:param name="elementImpact"/>
		<xsl:param name="layerClasses"/>
		<xsl:param name="layerLabels"/>

		<xsl:variable name="elementName" select="$element/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="elementRelationName" select="$element/own_slot_value[slot_reference = 'relation_name']/value"/>
		<xsl:variable name="elementDesc" select="$element/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="elementTypeIndex" select="index-of($layerClasses, $element/type)"/>
		<xsl:variable name="elementTypeLabel" select="$layerLabels[$elementTypeIndex]"/>
		<xsl:choose>
			<xsl:when test="string-length($elementName) > 0">
				<tr>
					<td>
						<xsl:value-of select="$elementTypeLabel"/>
					</td>
					<td>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$element"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
					</td>
					<td>
						<xsl:variable name="Qt">'</xsl:variable>
						<xsl:value-of select="translate($elementDesc,$Qt,'`')"/> 
					</td>
					<td class="impact">
						<xsl:for-each select="$elementImpact">
							<xsl:variable name="elementImpactLabel" select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
							<xsl:variable name="elementImpactColour" select="eas:get_element_style_colour(current())"/>
							<p style="color:{$elementImpactColour}">
								<xsl:value-of select="$elementImpactLabel"/>
							</p>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="string-length($elementRelationName) > 0">
				<tr>
					<td>
						<xsl:value-of select="$elementTypeLabel"/>
					</td>
					<td>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$element"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="displayString" select="$elementRelationName"/>
							</xsl:call-template>
						</strong>
					</td>
					<td>
						<xsl:value-of select="$elementDesc"/>
					</td>
					<td class="impact">
						<xsl:for-each select="$elementImpact">
							<xsl:variable name="elementImpactColour" select="eas:get_element_style_colour(current())"/>
							<p style="color:{$elementImpactColour}">
								<xsl:call-template name="RenderMultiLangInstanceName">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
								</xsl:call-template>
							</p>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<!-- render a Business Process table row  -->
	<xsl:template match="node()" mode="RenderProcessRow">
		<xsl:variable name="currentPhysProcs" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = current()/name]"/>
		<xsl:variable name="currentActor2Roles" select="$allActor2Roles[name = $currentPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="currentGroupActors" select="$allGroupActors[name = $currentActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="exists($currentGroupActors)">
						<ul>
							<xsl:for-each select="$currentGroupActors">
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
					<xsl:otherwise>&#160;</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>


	<!-- render a Application table row  -->
	<xsl:template match="node()" mode="RenderApplicationRow">
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<!-- <td>&#160;</td> -->
		</tr>
	</xsl:template>

	<xsl:template match="node()" name="Calculate_Project_Activity">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>
		<xsl:variable name="orgRolesForCap" select="$allGroupRoles[name = $busProcsForCap/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>
		<xsl:variable name="org2RolesForCap" select="$allActor2Roles[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $orgRolesForCap/name]"/>
		<xsl:variable name="orgsForCap" select="$allGroupActors[name = $org2RolesForCap/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>


		<xsl:variable name="appSvc2BusProcsForCap" select="$allBusProc2AppSvcs[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $busProcsForCap/name]"/>
		<xsl:variable name="appSvcsForCap" select="$allAppServices[name = $appSvc2BusProcsForCap/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
		<xsl:variable name="appRolesForSvcsCap" select="$allAppRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $appSvcsForCap/name]"/>
		<xsl:variable name="appsForSvcsCap" select="$allApps[name = $appRolesForSvcsCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		<!-- identify the applications that impact the business capability -->
		<xsl:variable name="physProcsForCap" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $busProcsForCap/name]"/>
		<xsl:variable name="physProcs2AppsForCap" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
		<xsl:variable name="appRolesForCap" select="$allAppRoles[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="appsForRolesCap" select="$allApps[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="appsForCap" select="$allApps[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $appsForSvcsCap"/>

		<xsl:variable name="plansForBusCap" select="$projectImpactedElements[name = $currentCap/name]"/>
		<xsl:variable name="plansforBusProcs" select="$projectImpactedElements[name = $busProcsForCap/name]"/>
		<xsl:variable name="plansforApps" select="$projectImpactedElements[name = $allAppsForCap/name]"/>
		<xsl:variable name="plansforOrgs" select="$projectImpactedElements[name = $orgsForCap/name]"/>

		<xsl:value-of select="count($plansForBusCap union $plansforApps union $plansforBusProcs union $plansforOrgs)"/>
	</xsl:template>


	<!-- Calculate the percentage of processes impacted by projects for a given Business Capability -->
	<xsl:template match="node()" name="Calculate_Percentage_Impact">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>
		<!-- get all affected apps from the relevant architecure states -->
		<xsl:variable name="impactedApps" select="$allApps[name = $projectImpactedElements/name]"/>
		<!-- get all of the physical processes 2 app relations for the apps -->
		<xsl:variable name="physProc2AppRels" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $impactedApps/name]"/>
		<!-- get all of the physical processes for the physical procesess 2 apps -->
		<xsl:variable name="physProcs4App" select="$allPhysProcs[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $physProc2AppRels/name]"/>
		<!-- get all of the logical processes that are implemented by the physical processes and that also realise the current business capability -->
		<xsl:variable name="businessProcsFromApps" select="$busProcsForCap[name = $physProcs4App/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="directlyImpactedProcs" select="$busProcsForCap[name = $projectImpactedElements/name]"/>

		<xsl:variable name="impactedProcs" select="($businessProcsFromApps union $directlyImpactedProcs)"/>
		<xsl:choose>
			<xsl:when test="(count($impactedProcs) > 0) and (count($busProcsForCap) > 0)">
				<xsl:value-of select="floor(count($impactedProcs) div count($busProcsForCap) * 100)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- Find all the sub capabilities of the specified parent capability -->
	<xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusinessCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aDirectChildList" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theParentCap/name]"/>
				<xsl:variable name="aNewList" select="$aDirectChildList union $aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
