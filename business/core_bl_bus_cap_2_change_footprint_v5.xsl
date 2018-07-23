<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:character-map name="pi-delimiters">
		<xsl:output-character character="§" string=">"/>
		<xsl:output-character character="¶" string="&lt;"/>
		<xsl:output-character character="€" string="&amp;quot;"/>
	</xsl:character-map>

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


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- param3 = a specific business driver to be mapped -->
	<xsl:param name="param3"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
	<xsl:variable name="pageLabel">Business Objective/Change Footprint</xsl:variable>
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="rootBusCapConstant" select="/node()/simple_instance[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root Business Capability']"/>

	<xsl:variable name="busCapability" select="$allBusinessCaps[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="busCapName" select="$busCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $busCapability/name]"/>


	<xsl:variable name="businessDrivers" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<!--<xsl:variable name="allBusinesObjectives" select="/node()/simple_instance[type='Business_Objective']"/>-->
	<xsl:variable name="inScopeProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = 'Application_Provider']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allBusImpactStrategicPlans" select="/node()/simple_instance[(type = 'Business_Strategic_Plan') or ((type = 'Enterprise_Strategic_Plan'))]"/>
	<xsl:variable name="allAppImpactStrategicPlans" select="/node()/simple_instance[(type = 'Application_Strategic_Plan') or ((type = 'Enterprise_Strategic_Plan'))]"/>

	<!--<xsl:variable name="allArchStates" select="/node()/simple_instance[type='Architecture_State']"/>-->

	<!-- SET THE THRESHOLDS FOR LOW, MEDIUM AND HIGH PROJECT ACTIVITY LEVELS-->
	<xsl:variable name="activityLowThreshold" select="3"/>
	<xsl:variable name="activityMedThreshold" select="6"/>


	<!-- SET THE THRESHOLDS FOR LOW, MEDIUM AND HIGH PROCESS IMPACT PERCENTAGES -->
	<xsl:variable name="impactLowThreshold" select="20"/>
	<xsl:variable name="impcatMedThreshold" select="40"/>
	<xsl:variable name="impcatHighThreshold" select="60"/>

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
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeBusCaps"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<!--script to support vertical alignment within named divs - requires jquery and verticalalign plugin-->
				<script type="text/javascript">
					$('document').ready(function(){
						 $(".compModelContent").vAlign();
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
				<script src="js/wz_tooltip_custom1.js" type="text/javascript"/>
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


						<!--Setup Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Projects to Business Objective Mapping')"/>
								</h2>
							</div>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following diagram describes the conceptual business capabilities in scope for')"/>
									<xsl:value-of select="$orgName"/>.</p>
								<div id="keyContainer">
									<div class="keyLabel"><xsl:value-of select="eas:i18n('Level of Project Activity')"/>:</div>
									<div class="pull-left">
										<div class="keySample gradLevel5"/>
										<div class="keySampleLabel">
											<xsl:value-of select="eas:i18n('High')"/>
										</div>
									</div>
									<div class="pull-left">
										<div class="keySample gradLevel3"/>
										<div class="keySampleLabel">
											<xsl:value-of select="eas:i18n('Medium')"/>
										</div>
									</div>
									<div class="pull-left">
										<div class="keySample gradLevel1"/>
										<div class="keySampleLabel">
											<xsl:value-of select="eas:i18n('Low')"/>
										</div>
									</div>
									<div class="pull-left">
										<div class="keySample"/>
										<div class="keySampleLabel">
											<xsl:value-of select="eas:i18n('None')"/>
										</div>
									</div>
									<!--<div class="horizSpacer_50px pull-left"/>-->
									<div class="pull-Left">
										<div class="keySample footprintHighlight"/>
										<div class="keySampleLabel">
											<xsl:value-of select="eas:i18n('Business Objective Footprint')"/>
										</div>
									</div>

									<div class="verticalSpacer_10px"/>
									<!--Setup Drop Down List-->
									<form method="post" name="filterForm">
										<label for="drivers"><xsl:value-of select="eas:i18n('Highlight Objective')"/>:</label>
										<select name="drivers" onchange="location.href=filterForm.drivers.options[selectedIndex].value">
											<option value="#">
												<xsl:value-of select="eas:i18n('Choose an Objective')"/>
											</option>
											<xsl:call-template name="RenderAllBusinessDriversListItem"/>
											<xsl:apply-templates mode="RenderBusinessDriverListItem" select="$businessDrivers">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											</xsl:apply-templates>
										</select>
									</form>

								</div>
								<div class="verticalSpacer_10px"/>
								<xsl:variable name="fullWidth" select="count($topLevelBusCapabilities) * 140"/>
								<xsl:variable name="widthStyle" select="concat('width:', $fullWidth, 'px;')"/>
								<div class="simple-scroller">
									<div>
										<xsl:attribute name="style" select="$widthStyle"/>

										<xsl:apply-templates mode="RenderBusinessCapabilityColumn" select="$inScopeBusCaps">
											<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
										</xsl:apply-templates>
									</div>
								</div>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
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
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>



	<!-- render a business capability cell -->
	<xsl:template match="node()" mode="RenderBusinessCapabilityCell">
		<xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(., ())"/>
		<xsl:variable name="outerDivStyle">
			<xsl:call-template name="OuterCellStyle">
				<xsl:with-param name="currentBusCap" select="$relevantBusCaps"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- render the inner div with the required impact and project activity levels represented -->
		<xsl:variable name="activityTotal">
			<xsl:call-template name="Calculate_Project_Activity">
				<xsl:with-param name="currentCap" select="$relevantBusCaps"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="impactedPercentage">
			<xsl:call-template name="Calculate_Percentage_Impact">
				<xsl:with-param name="currentCap" select="$relevantBusCaps"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$activityTotal = 0">
				<xsl:variable name="activityLevelClass" select="'compModelContent small gradLevel0 text-default'"/>
				<xsl:variable name="anchorClass" select="'text-default'"/>
				<xsl:call-template name="InnerCellStyle">
					<xsl:with-param name="impactedCapPercentage" select="$impactedPercentage"/>
					<xsl:with-param name="overallCellActivityClass" select="concat($activityLevelClass, ' ', $outerDivStyle)"/>
					<xsl:with-param name="currentCap" select="."/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($activityTotal &gt; 0) and ($activityTotal &lt;= $activityLowThreshold)">
				<xsl:variable name="activityLevelClass" select="'compModelContent small gradLevel1 text-default'"/>
				<xsl:variable name="anchorClass" select="'text-default'"/>
				<xsl:call-template name="InnerCellStyle">
					<xsl:with-param name="impactedCapPercentage" select="$impactedPercentage"/>
					<xsl:with-param name="overallCellActivityClass" select="concat($activityLevelClass, ' ', $outerDivStyle)"/>
					<xsl:with-param name="currentCap" select="."/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($activityTotal &gt; $activityLowThreshold) and ($activityTotal &lt;= $activityMedThreshold)">
				<xsl:variable name="activityLevelClass" select="'compModelContent small gradLevel3 text-white'"/>
				<xsl:variable name="anchorClass" select="'text-white'"/>
				<xsl:call-template name="InnerCellStyle">
					<xsl:with-param name="impactedCapPercentage" select="$impactedPercentage"/>
					<xsl:with-param name="overallCellActivityClass" select="concat($activityLevelClass, ' ', $outerDivStyle)"/>
					<xsl:with-param name="currentCap" select="."/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="activityLevelClass" select="'compModelContent small gradLevel5 text-white'"/>
				<xsl:variable name="anchorClass" select="'text-white'"/>
				<xsl:call-template name="InnerCellStyle">
					<xsl:with-param name="impactedCapPercentage" select="$impactedPercentage"/>
					<xsl:with-param name="overallCellActivityClass" select="concat($activityLevelClass, ' ', $outerDivStyle)"/>
					<xsl:with-param name="currentCap" select="."/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- render a list item for a Business Driver -->
	<xsl:template match="node()" mode="RenderBusinessDriverListItem">
		<xsl:variable name="formLink">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="'business/core_bl_bus_cap_2_change_footprint.xsl'"/>
				<xsl:with-param name="theHistoryLabel" select="$pageLabel"/>
				<xsl:with-param name="theParam3" select="./name"/>
			</xsl:call-template>
		</xsl:variable>
		<option>
			<xsl:attribute name="value" select="$formLink"/>
			<xsl:if test="./name = $param3">
				<xsl:attribute name="selected" select="'selected'"/>
			</xsl:if>
			<xsl:value-of select="./own_slot_value[slot_reference = 'name']/value"/>
		</option>
	</xsl:template>


	<!-- render the list item for all Business Drivers -->
	<xsl:template match="node()" name="RenderAllBusinessDriversListItem">
		<xsl:variable name="formLink">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="'business/core_bl_bus_cap_2_change_footprint.xsl'"/>
				<xsl:with-param name="theHistoryLabel" select="$pageLabel"/>
				<xsl:with-param name="theParam3" select="'ALL'"/>
			</xsl:call-template>
		</xsl:variable>
		<option>
			<xsl:attribute name="value" select="$formLink"/>
			<xsl:if test="$param3 = 'ALL'">
				<xsl:attribute name="selected" select="'selected'"/>
			</xsl:if>
			<xsl:value-of select="eas:i18n('All Objectives')"/>
		</option>
	</xsl:template>

	<!-- Calculate the level of project activity for a given Business Capability -->
	<xsl:template match="node()" name="Calculate_Project_Activity">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>

		<!-- identify the applications that impact the business capability -->
		<xsl:variable name="physProcsForCap" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $busProcsForCap/name]"/>
		<xsl:variable name="physProcs2AppsForCap" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
		<xsl:variable name="appsForCap" select="$allApps[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>


		<xsl:variable name="plansForBusProcs" select="$allBusImpactStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $busProcsForCap/name]"/>
		<xsl:variable name="plansForApps" select="$allAppImpactStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $busProcsForCap/name]"/>
		<xsl:variable name="impactingProjects" select="$inScopeProjects[own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value = ($plansForBusProcs union $plansForApps)/name]"/>

		<xsl:value-of select="count($impactingProjects)"/>
	</xsl:template>


	<!-- Calculate the percentage of processes impacted by projects for a given Business Capability -->
	<xsl:template match="node()" name="Calculate_Percentage_Impact">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>
		<xsl:variable name="plansForBusProcs" select="$allBusImpactStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $busProcsForCap/name]"/>
		<xsl:variable name="directlyImpactedProcs" select="$busProcsForCap[name = $plansForBusProcs/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>

		<!-- get all apps that are being changed by strategic plans -->
		<xsl:variable name="changedApps" select="$allApps[name = $allAppImpactStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>
		<!-- get all of the physical processes 2 app relations for the apps -->
		<xsl:variable name="physProc2AppRels" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $changedApps/name]"/>
		<!-- get all of the relevant physical processes for the physical procesess 2 apps -->
		<xsl:variable name="physProcs4App" select="$allPhysProcs[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $physProc2AppRels/name]"/>
		<!-- get all of the logical processes that are implemented by the physical processes and that also realise the current business capability -->
		<xsl:variable name="businessProcsFromApps" select="$busProcsForCap[name = $physProcs4App/own_slot_value[slot_reference = 'implements_business_process']/value]"/>

		<xsl:variable name="impactedProcs" select="($businessProcsFromApps | $directlyImpactedProcs)"/>
		<xsl:choose>
			<xsl:when test="(count($impactedProcs) > 0) and (count($busProcsForCap) > 0)">
				<xsl:value-of select="floor(count($impactedProcs) div count($busProcsForCap) * 100)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="OuterCellStyle" match="node()">
		<xsl:param name="currentBusCap"/>


		<xsl:choose>
			<xsl:when test="(exists($param3)) and ($param3 = 'ALL')">
				<xsl:choose>
					<xsl:when test="$currentBusCap/own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value = $businessDrivers/name">
						<xsl:text>footprintHighlight</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="(exists($param3)) and ($param3 != 'ALL')">
				<xsl:choose>
					<xsl:when test="$currentBusCap/own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value = $param3">
						<xsl:text>footprintHighlight</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- Work out the image to produce for impact in a Business Capability Cell -->
	<xsl:template match="node()" name="InnerCellStyle">
		<xsl:param name="impactedCapPercentage"/>
		<xsl:param name="overallCellActivityClass"/>
		<xsl:param name="currentCap"/>
		<xsl:param name="anchorClass"/>

		<xsl:choose>
			<xsl:when test="$impactedCapPercentage &lt;= $impactLowThreshold">
				<xsl:variable name="impCapLevelImage" select="'images/Trigger_Green.png'"/>
				<xsl:call-template name="Impact_Cell_Contents">
					<xsl:with-param name="impactedCapPercentage" select="$impactedCapPercentage"/>
					<xsl:with-param name="impactedCapImage" select="$impCapLevelImage"/>
					<xsl:with-param name="overallCellActivityClass" select="$overallCellActivityClass"/>
					<xsl:with-param name="currentCap" select="$currentCap"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($impactedCapPercentage &gt; $impactLowThreshold) and ($impactedCapPercentage &lt;= $impcatMedThreshold)">
				<xsl:variable name="impCapLevelImage" select="'images/Trigger_GreenAmber.png'"/>
				<xsl:call-template name="Impact_Cell_Contents">
					<xsl:with-param name="impactedCapPercentage" select="$impactedCapPercentage"/>
					<xsl:with-param name="impactedCapImage" select="$impCapLevelImage"/>
					<xsl:with-param name="overallCellActivityClass" select="$overallCellActivityClass"/>
					<xsl:with-param name="currentCap" select="$currentCap"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="impCapLevelImage" select="'images/Trigger_GreenAmberRed.png'"/>
				<xsl:call-template name="Impact_Cell_Contents">
					<xsl:with-param name="impactedCapPercentage" select="$impactedCapPercentage"/>
					<xsl:with-param name="impactedCapImage" select="$impCapLevelImage"/>
					<xsl:with-param name="overallCellActivityClass" select="$overallCellActivityClass"/>
					<xsl:with-param name="currentCap" select="$currentCap"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Produce the contents of an Impacted Cell -->
	<xsl:template match="node()" name="Impact_Cell_Contents">
		<xsl:param name="impactedCapPercentage"/>
		<xsl:param name="impactedCapImage"/>
		<xsl:param name="overallCellActivityClass"/>
		<xsl:param name="currentCap"/>
		<xsl:param name="anchorClass"/>
		<xsl:variable name="currentCapName" select="$currentCap/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:choose>
			<xsl:when test="$impactedCapPercentage > 0">
				<div class="compModelElementContainer" style="cursor: pointer;" onmouseout="UnTip()">
					<xsl:attribute name="onmouseover">
						<xsl:text disable-output-escaping="yes">Tip('&lt;table width="170px">&lt;tbody>&lt;tr>&lt;th class="ImpactSummaryPercent">% Processes Impacted&lt;/th>&lt;tr/>&lt;tr>&lt;td class="CompImpactLow">&lt;img src="</xsl:text>
						<xsl:value-of select="$impactedCapImage"/>
						<xsl:text>" style="vertical-align: middle;"/>&amp;nbsp;</xsl:text>
						<xsl:value-of select="$impactedCapPercentage"/>
						<xsl:text>%&lt;/td>&lt;/tr>&lt;/tbody>&lt;/table>')</xsl:text>
					</xsl:attribute>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="divClass" select="$overallCellActivityClass"/>
						<xsl:with-param name="anchorClass" select="$anchorClass"/>
					</xsl:call-template>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="compModelElementContainer">

					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="divClass" select="$overallCellActivityClass"/>
						<xsl:with-param name="anchorClass" select="$anchorClass"/>
					</xsl:call-template>
				</div>
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
