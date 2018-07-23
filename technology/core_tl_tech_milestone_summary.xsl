<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>



	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

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
	<!--29.10.2011 NW Created New Milestone Summary View-->

	<!-- param1 = the id of the milestone to be summarised -->
	<xsl:param name="param1"/>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->

	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Driver', 'Business_Objective', 'Technology_Component', 'Business_Strategic_Plan', 'Information_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan', 'Technology_Composite', 'Technology_Product', 'Technology_Product_Build')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="milestone" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="archState" select="/node()/simple_instance[name = $milestone/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
	<xsl:variable name="parentRoadmapID" select="$milestone/own_slot_value[slot_reference = 'used_in_roadmap_model']/value"/>
	<xsl:variable name="relevantTransitions" select="/node()/simple_instance[(own_slot_value[slot_reference = ':contained_in_roadmap']/value = $parentRoadmapID) and (own_slot_value[slot_reference = ':TO']/value = $param1)]"/>
	<xsl:variable name="relevantStratPlans" select="/node()/simple_instance[(type = 'Application_Strategic_Plan') and (name = $relevantTransitions/own_slot_value[slot_reference = ':roadmap_strategic_plans']/value)]"/>
	<xsl:variable name="relevantObjectives" select="/node()/simple_instance[name = $relevantStratPlans/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value]"/>
	<xsl:variable name="relevantDrivers" select="/node()/simple_instance[name = $relevantObjectives/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
	<xsl:variable name="relevantServiceQualityValues" select="/node()/simple_instance[name = $relevantObjectives/own_slot_value[slot_reference = 'bo_measures']/value]"/>
	<xsl:variable name="relevantServiceQualities" select="/node()/simple_instance[name = $relevantServiceQualityValues/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
	<xsl:variable name="relevantTechComponents" select="/node()/simple_instance[(type = 'Technology_Component' or type = 'Technology_Composite') and (name = $archState/own_slot_value[slot_reference = 'arch_state_technology_logical']/value)]"/>
	<xsl:variable name="relevantTechProducts" select="/node()/simple_instance[(type = 'Technology_Product' or type = 'Technology_Product_Build') and (name = $archState/own_slot_value[slot_reference = 'arch_state_technology_logical']/value)]"/>

	<xsl:variable name="archStateName" select="$archState/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="archStateDescription" select="$archState/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="archTargetDate" select="/node()/simple_instance[name = $archState/own_slot_value[slot_reference = 'start_date']/value]"/>
	<xsl:variable name="displayTargetDate">
		<xsl:call-template name="FullFormatDate">
			<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($archTargetDate)"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[type = 'Planning_Action']"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:call-template name="BuildPage"> </xsl:call-template>
	</xsl:template>

	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Technology Milestone Summary')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
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

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="$pageLabel"/> - </span>
									<span class="text-primary">
										<xsl:value-of select="$archStateName"/>
									</span>
								</h1>
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
								<xsl:value-of select="$archStateDescription"/>
							</div>
							<hr/>
						</div>


						<!--Setup Time Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Target Date')"/>
							</h2>
							<div class="content-section">
								<xsl:value-of select="$displayTargetDate"/>
							</div>
							<hr/>
						</div>



						<!--Setup Drivers Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-truck icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Business Drivers')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="Drivers"/>
							</div>
							<hr/>
						</div>


						<!--Setup Objectives Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Objectives')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="Objectives"/>
							</div>
							<hr/>
						</div>


						<!--Setup Technology Components Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Technology Components')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="TechComponents"/>
							</div>
							<hr/>
						</div>


						<!--Setup Technology Products Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-wrench icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Impacted Technology Products/Builds')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="TechProducts"/>
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
								<!--<xsl:call-template name="extDocRef"></xsl:call-template>-->
								<xsl:apply-templates select="/node()/simple_instance[name = $param1]" mode="ReportExternalDocRef"/>
							</div>
							<hr/>
						</div>



						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="Drivers">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($relevantDrivers) > 0">
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Driver')"/>
							</th>
							<th class="cellWidth-55pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Strategic Plans')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$relevantDrivers">
							<xsl:variable name="currentDriver" select="current()"/>
							<xsl:variable name="driverName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="driverDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="driverStratPlans" select="$relevantStratPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $currentDriver/name]"/>
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentDriver"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$driverDesc"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($driverStratPlans) > 0">
											<xsl:variable name="currentPlan" select="$driverStratPlans[1]"/>
											<xsl:variable name="planAction" select="$allPlanningActions[name = $currentPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
											<xsl:variable name="planActionName" select="$planAction/own_slot_value[slot_reference = 'enumeration_value']/value"/>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="displayString" select="$planActionName"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('Keep')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('No Drivers defined for this milestone')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Objectives">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($relevantObjectives) > 0">
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Objective')"/>
							</th>
							<th class="cellWidth-35pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-30pc">
								<xsl:value-of select="eas:i18n('KPIs')"/>
							</th>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Strategic Plans')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$relevantObjectives">
							<xsl:variable name="currentObj" select="current()"/>
							<xsl:variable name="objName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="objDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="objStratPlans" select="$relevantStratPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $currentObj/name]"/>
							<xsl:variable name="measureValues" select="$relevantServiceQualityValues[name = $currentObj/own_slot_value[slot_reference = 'bo_measures']/value]"/>
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentObj"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$objDesc"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($measureValues) > 0">
											<ul>
												<xsl:for-each select="$measureValues">
													<xsl:variable name="measureType" select="$relevantServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
													<li><xsl:value-of select="$measureType/own_slot_value[slot_reference = 'name']/value"/> - <xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/></li>
												</xsl:for-each>
											</ul>
										</xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($objStratPlans) > 0">
											<xsl:variable name="currentPlan" select="$objStratPlans[1]"/>
											<xsl:variable name="planAction" select="$allPlanningActions[name = $currentPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
											<xsl:variable name="planActionName" select="$planAction/own_slot_value[slot_reference = 'enumeration_value']/value"/>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="displayString" select="$planActionName"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('Keep')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('No Objectives defined for this milestone')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="TechComponents">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($relevantTechComponents) > 0">
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Technology Component')"/>
							</th>
							<th class="cellWidth-55pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Strategic Plans')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$relevantTechComponents">
							<xsl:variable name="currentTechComp" select="current()"/>
							<xsl:variable name="techCompName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="techCompDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="techCompStratPlans" select="$relevantStratPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $currentTechComp/name]"/>
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentTechComp"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$techCompDesc"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($techCompStratPlans) > 0">
											<xsl:variable name="currentPlan" select="$techCompStratPlans[1]"/>
											<xsl:variable name="planAction" select="$allPlanningActions[name = $currentPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
											<xsl:variable name="planActionName" select="$planAction/own_slot_value[slot_reference = 'enumeration_value']/value"/>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="displayString" select="$planActionName"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('Keep')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('No Technology Components defined for this milestone')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="TechProducts">
		<!--I've put a simple xsl:choose in here but you''ll need to set the test properly-->
		<xsl:choose>
			<xsl:when test="count($relevantTechProducts) > 0">
				<table class="table table-bordered table-striped ">
					<thead>
						<tr>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Technology Product/Build')"/>
							</th>
							<th class="cellWidth-55pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Strategic Plans')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$relevantTechProducts">
							<xsl:variable name="currentTechProd" select="current()"/>
							<xsl:variable name="techProdName" select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="techProdDesc" select="own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="techProdStratPlans" select="$relevantStratPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $currentTechProd/name]"/>
							<tr>
								<td>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentTechProd"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="$techProdDesc"/>
								</td>
								<td>
									<xsl:choose>
										<xsl:when test="count($techProdStratPlans) > 0">
											<xsl:variable name="currentPlan" select="$techProdStratPlans[1]"/>
											<xsl:variable name="planAction" select="$allPlanningActions[name = $currentPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
											<xsl:variable name="planActionName" select="$planAction/own_slot_value[slot_reference = 'enumeration_value']/value"/>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentPlan"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="displayString" select="$planActionName"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('Keep')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('No Technology Products/Builds defined for this milestone')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
