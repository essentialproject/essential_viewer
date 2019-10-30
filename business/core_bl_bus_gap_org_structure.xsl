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


	<!--<xsl:include href="../information/menus/core_data_subject_menu.xsl"></xsl:include>-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Group_Business_Role', 'Individual_Business_Role', 'Group_Actor', 'Individual_Actor', 'ACTOR_TO_ROLE_RELATION')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->


	<!-- START Change Analysis SPECIFIC GLOBAL VARIABLES -->
	<!-- CHANGE THIS ROADMAP CONSTANT DEPENDING UPON THE LAYER OF THE ROADMAP MODEL DRIVING THIS SPECIFIC Change Analysis - SEE REPORT CONSTANT INSTANCES FOR VALID LIST-->
	<xsl:variable name="roadmapConstantName" select="'Business_Roadmap'"/>

	<!-- CHANGE THIS Change Analysis LABEL TO THE NAME OF THE Change Analysis -->
	<xsl:variable name="gapReportLabel">
		<xsl:value-of select="eas:i18n('Organisation Structure Change Analysis')"/>
	</xsl:variable>

	<!-- CHANGE THIS TEXT TO LIST THE TYPES OF ELEMENTS IN SCOPE FOR THE Change Analysis (USED IN DESCRIPTIONS) -->
	<xsl:variable name="gapReportElementDesc" select="'Business Roles and Organisations'"/>

	<!-- END Change Analysis SPECIFIC GLOBAL VARIABLES -->


	<!-- Get the pre-defined Planning Action instances -->
	<xsl:variable name="newPlanningAction" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Establish']"/>
	<xsl:variable name="removePlanningAction" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Switch_Off']"/>
	<xsl:variable name="enhancePlanningAction" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Enhance']"/>
	<xsl:variable name="decommissionPlanningAction" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Decommission']"/>
	<xsl:variable name="replacePlanningAction" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Replace']"/>


	<!-- START Change Analysis SPECIFIC TEMPLATES -->
	<!-- THE FOLLOWING TEMPLATES VARY DEPENDING UPON THE META-CLASSES OF THE Change Analysis ELEMENTS IN SCOPE -->
	<xsl:template name="PrintElementTypePrefix">
		<xsl:param name="elementType"/>
		<xsl:choose>
			<xsl:when test="$elementType = 'Group_Business_Role'">
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Organisation Role')"/>
				</span>
				<br/>
			</xsl:when>
			<xsl:when test="$elementType = 'Individual_Business_Role'">
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Business Role')"/>
				</span>
				<br/>
			</xsl:when>
			<xsl:when test="$elementType = 'Group_Actor'">
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Organisation')"/>
				</span>
				<br/>
			</xsl:when>
			<xsl:when test="$elementType = 'Individual_Actor'">
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Actor')"/>
				</span>
				<br/>
			</xsl:when>
			<xsl:when test="$elementType = 'ACTOR_TO_ROLE_RELATION'">
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Actor as Role')"/>
				</span>
				<br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="PrintElementTypeSuffix">
		<xsl:param name="elementType"/>
		<xsl:choose>
			<xsl:when test="$elementType = 'Group_Business_Role'">
				<br/>
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Organisation Role')"/>
				</span>
			</xsl:when>
			<xsl:when test="$elementType = 'Individual_Business_Role'">
				<br/>
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Business Role')"/>
				</span>
			</xsl:when>
			<xsl:when test="$elementType = 'Group_Actor'">
				<br/>
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Organisation')"/>
				</span>
			</xsl:when>
			<xsl:when test="$elementType = 'Individual_Actor'">
				<br/>
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Actor')"/>
				</span>
			</xsl:when>
			<xsl:when test="$elementType = 'ACTOR_TO_ROLE_RELATION'">
				<br/>
				<span class="small normal">
					<xsl:value-of select="eas:i18n('Actor as Role')"/>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- This template is used to allow alternative slots or even the names of related instances to be used as the label for elements in scope -->
	<xsl:template name="PrintElementDisplayLabel">
		<xsl:param name="theElement"/>
		<xsl:param name="elementType"/>
		<xsl:choose>
			<xsl:when test="$elementType = 'Group_Business_Role'">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theElement"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass" select="'text-white'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$elementType = 'Individual_Business_Role'">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theElement"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass" select="'text-white'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$elementType = 'Group_Actor'">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theElement"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass" select="'text-white'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$elementType = 'Individual_Actor'">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theElement"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass" select="'text-white'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$elementType = 'ACTOR_TO_ROLE_RELATION'">
				<xsl:value-of select="translate($theElement/own_slot_value[slot_reference = 'relation_name']/value, '::', ' ')"/>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theElement"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="anchorClass" select="'text-white'"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="translate($theElement/own_slot_value[slot_reference = 'relation_name']/value, '::', ' ')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- END Change Analysis SPECIFIC TEMPLATES -->


	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="roadmap" select="/node()/simple_instance[name = $param1]"/>
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="pageLabel" select="concat($gapReportLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="roadmap" select="$roadmap"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="roadmap" select="/node()/simple_instance[name = $param1]"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="roadmap" select="$roadmap"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="$gapReportLabel"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="roadmap"/>

		<!-- THESE STATEMENTS ARE GENERIC FOR ALL GAP REPORTS -->
		<xsl:variable name="roadmapElements" select="/node()/simple_instance[name = $roadmap/own_slot_value[slot_reference = 'contained_roadmap_model_elements']/value]"/>
		<xsl:variable name="roadmapMilestones" select="$roadmapElements[type = 'Roadmap_Milestone']"/>
		<xsl:variable name="roadmapStart" select="$roadmapElements[type = 'Roadmap_Start']"/>
		<xsl:variable name="architectureStates" select="/node()/simple_instance[name = $roadmapMilestones/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
		<xsl:variable name="roadmapRelations" select="/node()/simple_instance[name = $roadmap/own_slot_value[slot_reference = 'contained_roadmap_relations']/value]"/>
		<xsl:variable name="roadmapStartRelation" select="$roadmapRelations[type = ':roadmap-start-relation']"/>
		<xsl:variable name="roadmapTransitionRelations" select="$roadmapRelations[type = ':roadmap-transition-relation']"/>
		<xsl:variable name="roadmapStartMilestone" select="$roadmapMilestones[name = $roadmapStartRelation/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="startArchState" select="$architectureStates[name = $roadmapStartMilestone/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
		<xsl:variable name="roadmapTargetMilestone" select="$roadmapMilestones[(name != $roadmapTransitionRelations/own_slot_value[slot_reference = ':FROM']/value) and (name != $roadmapStartMilestone/name)]"/>
		<xsl:variable name="targetArchState" select="$architectureStates[name = $roadmapTargetMilestone/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>


		<!-- START Change Analysis SPECIFIC QUERIES -->
		<!-- THE FOLLOWING STATEMENTS VARY DEPENDING UPON THE META-CLASSES, LAYER AND ABSTRACTION OF THE Change Analysis ELEMENTS IN SCOPE -->
		<xsl:variable name="allGapElements" select="/node()/simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role') or (type = 'Group_Actor') or (type = 'Individual_Actor') or (type = 'ACTOR_TO_ROLE_RELATION')]"/>
		<xsl:variable name="strategicPlans" select="/node()/simple_instance[(type = 'Business_Strategic_Plan') and (name = $roadmapRelations/own_slot_value[slot_reference = ':roadmap_strategic_plans']/value)]"/>
		<xsl:variable name="currentStateElements" select="$allGapElements[name = $startArchState/own_slot_value[(slot_reference = 'arch_state_business_logical') or (slot_reference = 'arch_state_business_physical') or (slot_reference = 'arch_state_business_relations')]/value]"/>
		<xsl:variable name="targetStateElements" select="$allGapElements[name = $targetArchState/own_slot_value[(slot_reference = 'arch_state_business_logical') or (slot_reference = 'arch_state_business_physical') or (slot_reference = 'arch_state_business_relations')]/value]"/>
		<!-- END Change Analysis SPECIFIC QUERIES -->

		<!-- THIS STATEMENT IS GENERIC FOR ALL GAP REPORTS -->
		<xsl:variable name="gapElementsForPlans" select="$allGapElements[name = $strategicPlans/own_slot_value[slot_reference = 'strategic_plan_for_element']/value]"/>


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
					}</style>

				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderDataSubjectPopUpScript"/>-->

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

						<!--Setup Description Section-->
						<div id="sectionMatrix">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-table icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Change Analysis')"/>
									</h2>
									<div class="content-section"> </div>
									<p>
										<xsl:value-of select="eas:i18n('The table below provides a comparative analysis between')"/>&#160; <strong>
											<xsl:value-of select="eas:i18n('Target and Baseline')"/>&#160; <xsl:value-of select="$gapReportElementDesc"/>&#160; </strong>
										<xsl:value-of select="eas:i18n('by indicating what needs to change across')"/>&#160; <xsl:value-of select="$orgName"/>
									</p>

									<script>
									$(document).ready(function(){								
										var table = $('#dt_gap').DataTable({
										scrollY: "350px",
										scrollCollapse: true,
										scrollX: true,
										sScrollXInner: "<xsl:value-of select="180 + (180 * count($currentStateElements))"/>px",
										paging: false,
										info: false,
										sort: false,
										filter: false,
										fixedColumns: true
										});
									});
								</script>

									<xsl:call-template name="Matrix">
										<xsl:with-param name="currentStateElements" select="$currentStateElements"/>
										<xsl:with-param name="targetStateElements" select="$targetStateElements"/>
										<xsl:with-param name="strategicPlans" select="$strategicPlans"/>
									</xsl:call-template>


								</div>
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
		<xsl:param name="currentStateElements"/>
		<xsl:param name="targetStateElements"/>
		<xsl:param name="strategicPlans"/>

		<xsl:param name="dataSubjects"/>
		<xsl:param name="dataObjects"/>
		<xsl:param name="businessRoles"/>
		<xsl:param name="dmPolicies"/>
		<!--Setup Matrix Section-->

		<!--setup the key-->

		<div id="keyContainer">
			<div class="keyLabel"><xsl:value-of select="eas:i18n('Key')"/>:</div>
			<div class="keySample cellRAG_Red"/>
			<div class="keySampleLabel">
				<xsl:value-of select="eas:i18n('Removed')"/>
			</div>
			<div class="keySample cellRAG_Green"/>
			<div class="keySampleLabel">
				<xsl:value-of select="eas:i18n('New')"/>
			</div>
		</div>
		<div class="verticalSpacer_10px"/>
		<!--Scripts to set size of Y Axis and Vertcal Align Text in Axis Labels-->
		<!--Set the size-->
		<script>
			function setEqualHeight(columns)  
			 {  
			 var tallestcolumn = 0;  
			 columns.each(  
			 function()  
			 {  
			 currentHeight = $(this).height();  
			 if(currentHeight > tallestcolumn)  
			 {  
			 tallestcolumn  = currentHeight;  
			 }  
			 }  
			 );  
			 columns.height(tallestcolumn);  
			 }  
			$(document).ready(function() {  
			 setEqualHeight($(".yAxisLabelBar,.matrixContainer"));
			});
		</script>
		<!--Vertical Align-->
		<script type="text/javascript">
			$('document').ready(function(){
				 $(".xAxisLabelBar").vAlign();
				 $(".yAxisLabelBar").vAlign();
				 $(".matrixEnumIcon").vAlign();
			});
		</script>

		<!--setup the x axis label bar-->

		<div class="xAxisLabelBar bg-black text-white col-xs-11 col-xs-offset-1">
			<strong>
				<xsl:value-of select="eas:i18n('Baseline')"/>
			</strong>
		</div>
		<div class="yAxisLabelBar bg-black text-white col-xs-1">
			<div class="vertical-text">
				<strong>
					<xsl:value-of select="eas:i18n('Target')"/>
				</strong>
			</div>
		</div>
		<div class="matrixContainer no-padding col-xs-11">
			<!--setup the main matrix-->
			<table class="tableStyleMatrix table-header-background" id="dt_gap">
				<thead>
					<tr>
						<th class="tableStyleMatrixCorner cellWidth-180">&#160;</th>
						<xsl:for-each select="$currentStateElements">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="plansForElement" select="$strategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = current()/name]"/>
							<xsl:choose>
								<xsl:when test="count($plansForElement[own_slot_value[slot_reference = 'strategic_planning_action']/value = $removePlanningAction/name]) > 0">
									<th class="cellWidth-180 cellRAG_Red">
										<xsl:call-template name="PrintElementDisplayLabel">
											<xsl:with-param name="theElement" select="current()"/>
											<xsl:with-param name="elementType" select="current()/type"/>
										</xsl:call-template>
										<xsl:call-template name="PrintElementTypeSuffix">
											<xsl:with-param name="elementType" select="current()/type"/>
										</xsl:call-template>
									</th>
								</xsl:when>
								<xsl:otherwise>
									<th class="cellWidth-180">
										<xsl:call-template name="PrintElementDisplayLabel">
											<xsl:with-param name="theElement" select="current()"/>
											<xsl:with-param name="elementType" select="current()/type"/>
										</xsl:call-template>
										<xsl:call-template name="PrintElementTypeSuffix">
											<xsl:with-param name="elementType" select="current()/type"/>
										</xsl:call-template>
									</th>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="$targetStateElements">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="thisTargetElement" select="current()"/>
						<tr>
							<xsl:variable name="plansForTargetElement" select="$strategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $thisTargetElement/name]"/>
							<xsl:variable name="newPlansForTargetElement" select="$plansForTargetElement[own_slot_value[slot_reference = 'strategic_planning_action']/value = $newPlanningAction/name]"/>
							<xsl:variable name="replacePlansForTargetElement" select="$plansForTargetElement[own_slot_value[slot_reference = 'strategic_planning_action']/value = $replacePlanningAction/name]"/>

							<xsl:choose>
								<xsl:when test="count($newPlansForTargetElement) > 0">
									<td class="cellRAG_Green text-white vAlignMiddle">
										<xsl:call-template name="PrintElementTypePrefix">
											<xsl:with-param name="elementType" select="$thisTargetElement/type"/>
										</xsl:call-template>
										<strong>
											<xsl:call-template name="PrintElementDisplayLabel">
												<xsl:with-param name="theElement" select="$thisTargetElement"/>
												<xsl:with-param name="elementType" select="$thisTargetElement/type"/>
											</xsl:call-template>
										</strong>
										<br/>
									</td>
								</xsl:when>
								<xsl:otherwise>
									<td class="bg-midgrey text-white vAlignMiddle">
										<xsl:call-template name="PrintElementTypePrefix">
											<xsl:with-param name="elementType" select="$thisTargetElement/type"/>
										</xsl:call-template>
										<strong>
											<xsl:call-template name="PrintElementDisplayLabel">
												<xsl:with-param name="theElement" select="$thisTargetElement"/>
												<xsl:with-param name="elementType" select="$thisTargetElement/type"/>
											</xsl:call-template>
										</strong>
									</td>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:for-each select="$currentStateElements">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="thisCurrentElement" select="current()"/>
								<xsl:variable name="plansForCurrentElement" select="$strategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $thisCurrentElement/name]"/>
								<xsl:variable name="enhancePlansForCurrentElement" select="$plansForCurrentElement[own_slot_value[slot_reference = 'strategic_planning_action']/value = $enhancePlanningAction/name]"/>
								<xsl:variable name="decommissionPlansForCurrentElement" select="$plansForCurrentElement[own_slot_value[slot_reference = 'strategic_planning_action']/value = $decommissionPlanningAction/name]"/>
								<xsl:variable name="replacePlansForCurrentElement" select="$replacePlansForTargetElement[own_slot_value[slot_reference = 'supports_strategic_plan']/value = $decommissionPlansForCurrentElement/name]"/>

								<xsl:choose>
									<!-- Set to KEEP if the element is in both current and future state and there are no strategic plans defined -->
									<xsl:when test="($thisCurrentElement/name = $thisTargetElement/name) and (count($plansForCurrentElement) = 0)">
										<td>
											<div class="matrixEnumIcon EnumIcon_Tick backColour9 small text-white">
												<xsl:value-of select="eas:i18n('Keep')"/>
											</div>
										</td>
									</xsl:when>
									<!-- Set to ENHANCE if the element is in both current and future state and there is one or more strategic plans defined to enhance it -->
									<xsl:when test="($thisCurrentElement/name = $thisTargetElement/name) and (count($enhancePlansForCurrentElement) > 0)">
										<td>
											<div class="matrixEnumIcon EnumIcon_Plus backColour9 small text-white">
												<xsl:value-of select="eas:i18n('Enhance')"/>
											</div>
										</td>
									</xsl:when>
									<!-- Set to REPLACE if the corresponding Target Element has a replace plan that supports a decommission plan for this element -->
									<xsl:when test="(count($replacePlansForCurrentElement) > 0)">
										<td>
											<div class="matrixEnumIcon EnumIcon_HorizArrows backColour9 small text-white">
												<xsl:value-of select="eas:i18n('Replace')"/>
											</div>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td>&#160;</td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>







</xsl:stylesheet>
