<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_uml_model_links.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param2 = the path of the dynamically generated UML model -->
	<xsl:param name="param2"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Group_Actor', 'Individual_Actor', 'Individual_Business_Role', 'Information_View')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:param name="imageFilename"/>
	<xsl:param name="imageMapPath"/>

	<xsl:variable name="modelSubject" select="/node()/simple_instance[name = $param1]"/>
	<!--<xsl:variable name="modelSubjectName" select="$modelSubject/own_slot_value[slot_reference='name']/value" />-->
	<xsl:variable name="modelSubjectName">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$modelSubject"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="overallProcessFlow" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
	<xsl:variable name="processFlowRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_process_flow']/value = $overallProcessFlow/name]"/>

	<!-- get the list of process owners in scope -->
	<xsl:variable name="processOwnerRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Process Owner')]"/>
	<xsl:variable name="processOwnerActor2Roles" select="/node()/simple_instance[(name = $business_processes/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processOwnerRole/name)]"/>
	<xsl:variable name="processOwners" select="/node()/simple_instance[name = $processOwnerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

	<!-- get theinput and output services for the procedure -->
	<xsl:variable name="procedurePhysProc" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $modelSubject/name]"/>
	<xsl:variable name="inputServices" select="/node()/simple_instance[name = $procedurePhysProc/own_slot_value[slot_reference = 'phys_bp_consumes_products']/value]"/>
	<xsl:variable name="outputServices" select="/node()/simple_instance[own_slot_value[slot_reference = 'product_implemented_by_process']/value = $procedurePhysProc/name]"/>

	<!-- get the list of Business Process Usages in scope -->
	<xsl:variable name="allProcessUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name]"/>
	<xsl:variable name="processUsages" select="$allProcessUsages[(type = 'Business_Activity_Usage') or (type = 'Business_Process_Usage')]"/>
	<xsl:variable name="decisionUsages" select="$allProcessUsages[(type = 'Business_Process_Flow_Decision')]"/>

	<xsl:variable name="startUsage" select="$allProcessUsages[(type = 'Start_Process_Flow')]"/>
	<xsl:variable name="startRelations" select="$processFlowRelations[own_slot_value[slot_reference=':FROM']/value = $startUsage/name]"/>

	<!-- get the list of Business Processes in scope -->
	<xsl:variable name="business_processes" select="/node()/simple_instance[(name = $processUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $processUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<!-- get the list of Business Roles in scope -->
	<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name = $business_processes/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
	<xsl:variable name="decisionMakers" select="/node()/simple_instance[name = $decisionUsages/own_slot_value[slot_reference = 'bpfd_decision_makers']/value]"/>

	<xsl:variable name="allProcess2InfoRels" select="/node()/simple_instance[name = $modelSubject/own_slot_value[slot_reference = 'busproctype_uses_infoviews']/value]"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[name = $allProcess2InfoRels/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>

	<!-- get the list of Start Events in scope -->
	<xsl:variable name="startEventUsages" select="$allProcessUsages[type = 'Initiating_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="startEvents" select="/node()/simple_instance[name = $startEventUsages/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value]"/>
	<xsl:variable name="startEventRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':FROM']/value = $startEventUsages/name]"/>

	<!-- get the list of Goal Events in scope -->
	<xsl:variable name="goalEventUsages" select="$allProcessUsages[type = 'Raised_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="goalEvents" select="/node()/simple_instance[name = $goalEventUsages/own_slot_value[slot_reference = 'usage_of_business_event_in_process']/value]"/>

	<!-- get the start node -->
	<!--<xsl:variable name="startNode" select="/node()/simple_instance[(own_slot_value[slot_reference='used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'Start_Process_Flow')]"/>-->

	<!-- get the end node -->
	<xsl:variable name="endNode" select="/node()/simple_instance[(own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'End_Process_Flow')]"/>


	<!--<xsl:variable name="firstProcessRelation" select="$processFlowRelations[own_slot_value[slot_reference=':FROM']/value = $startEventUsages/name]"/>-->
	<xsl:variable name="firstProcessUsage" select="$processUsages[name = ($startEventRelations, $startRelations)/own_slot_value[slot_reference = ':TO']/value]"/>
	<xsl:variable name="firstBusProc" select="$business_processes[(name = $firstProcessUsage/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $firstProcessUsage/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<xsl:variable name="relationList" select="eas:generateRelationList($firstProcessUsage, $processFlowRelations, ())"/>
	<xsl:variable name="orderedStepIds" select="$relationList/own_slot_value[slot_reference = ':FROM']/value"/>
	<xsl:variable name="orderedProcessSteps" select="$allProcessUsages[name = $relationList/own_slot_value[slot_reference = ':FROM']/value]"/>

	<xsl:variable name="pageType">
		<xsl:value-of select="eas:i18n('Business Process Model')"/>
	</xsl:variable>
	<xsl:variable name="pageTitle" select="concat($pageType, ' - ', $modelSubjectName)"/>

	<xsl:variable name="DEBUG" select="''"/>

	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!--05.08.2016 NJW Updated to Support Viewer v5-->



	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<meta http-equiv="expires" content="-1" />
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageTitle"/>
				</title>
				<script src="js/jquery-migrate-1.4.1.min.js" type="text/javascript"/>
				<script type="text/javascript" src="js/jquery.zoomable.js"/>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<!--script to support vertical alignment within named divs - requires jquery and verticalalign plugin-->
				<script type="text/javascript">
					$('document').ready(function(){
						 $(".umlCircleBadge").vAlign();
						 $(".umlCircleBadgeDescription").vAlign();
						 $(".umlKeyTitle").vAlign();
					});
				</script>

				<!--script required to zoom and drag images whilst scaling image maps-->
				<script type="text/javascript">
					$('document').ready(function(){
						$('.umlImage').zoomable();
					});
				</script>
			</head>
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference = 'description']/value"/>


				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageTitle"/>
										<!--<xsl:value-of select="$DEBUG"/>-->
									</span>
								</h1>
							</div>
						</div>

						<!--Setup Definition Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-file-text-o icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Description')"/>
									</h2>
								</div>
								<div class="content-section">
									<xsl:value-of select="eas:i18n('The following table provides high level details for the')"/>&#160;<strong><xsl:value-of select="$modelSubjectName"/></strong>&#160;<xsl:value-of select="eas:i18n('process')"/>. <div class="verticalSpacer_10px"/>
									<xsl:call-template name="ProcessSummaryTable"/>
								</div>
							</div>
							<div class="sectionDividerHorizontal"/>
							<div class="clear"/>
						</div>

						<!--Setup UML Model Section-->
						<div id="sectionUMLModel">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Model')"/>
									</h2>
								</div>
								<div class="content-section">
                                    <xsl:choose>
                                        <xsl:when test="not($overallProcessFlow)">No Model Defined</xsl:when>
                                        <xsl:otherwise>

									<xsl:call-template name="legend"/>

									<div class="umlZoomContainer floatRight">
										<input type="button" onclick="$('#umlModel').zoomable('zoomIn')" title="Zoom in">
											<xsl:attribute name="value">
												<xsl:value-of select="eas:i18n('Zoom In')"/>
											</xsl:attribute>
										</input>
										<input type="button" onclick="$('#umlModel').zoomable('zoomOut')" title="Zoom out">
											<xsl:attribute name="value">
												<xsl:value-of select="eas:i18n('Zoom Out')"/>
											</xsl:attribute>
										</input>
										<input type="button" onclick="$('#umlModel').zoomable('reset')">
											<xsl:attribute name="value">
												<xsl:value-of select="eas:i18n('Reset')"/>
											</xsl:attribute>
										</input>
									</div>
									<div class="clear"/>
									<div class="verticalSpacer_10px"/>
									<div class="umlModelViewportMoE">
										<img class="umlImage" src="{$imageFilename}" usemap="#unix" id="umlModel" alt="UML Model"/>

										<xsl:variable name="imageMapFile" select="concat('../', $imageMapPath)"/>
										<xsl:if test="unparsed-text-available($imageMapFile)">
											<xsl:value-of select="unparsed-text($imageMapFile)" disable-output-escaping="yes"/>
										</xsl:if>

									</div>
                                        </xsl:otherwise>
                                    
                                    </xsl:choose>     
								</div>
							</div>
							<div class="sectionDividerHorizontal"/>
							<div class="clear"/>
						</div>

						<!--Setup Process Steps Section-->
						<div id="sectionSteps">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa essicon-valuechain  icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Process Steps')"/>
									</h2>
									<xsl:choose>
										<xsl:when test="count($allProcessUsages) > 0">
											<div class="content-section">
												<xsl:value-of select="eas:i18n('The following steps are defined for the')"/>&#160;<strong><xsl:value-of select="$modelSubjectName"/></strong>&#160;<xsl:value-of select="eas:i18n('process')"/>. <div class="verticalSpacer_10px"/>
												<xsl:call-template name="ProcessSteps"/>
											</div>
										</xsl:when>
										<xsl:otherwise>
											<em>
												<xsl:value-of select="eas:i18n('No steps defined for this process')"/>
											</em>
										</xsl:otherwise>
									</xsl:choose>
								</div>

							</div>
							<div class="sectionDividerHorizontal"/>
							<div class="clear"/>
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

	<xsl:template name="ProcessSummaryTable">
		<xsl:variable name="procDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$modelSubject"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="thisProcessOwnerActor2Role" select="/node()/simple_instance[(name = $modelSubject/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processOwnerRole/name)]"/>
		<xsl:variable name="thisProcessOwner" select="/node()/simple_instance[name = $thisProcessOwnerActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>


		<xsl:variable name="inputBusProc2Info" select="$allProcess2InfoRels[(own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value = $modelSubject/name) and (own_slot_value[slot_reference = 'busproctype_reads_infoview']/value = 'Yes')]"/>
		<xsl:variable name="inputInfo" select="$allInfoViews[name = $inputBusProc2Info/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>

		<xsl:variable name="outputBusProc2Info" select="$allProcess2InfoRels[(own_slot_value[slot_reference = 'busproctype_to_infoview_from_busproc']/value = $modelSubject/name) and (own_slot_value[slot_reference = 'busproctype_updates_infoview']/value = 'Yes')]"/>
		<xsl:variable name="outputInfo" select="$allInfoViews[name = $outputBusProc2Info/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>


		<xsl:variable name="procGuidingFactors" select="/node()/simple_instance[(name = $modelSubject/own_slot_value[slot_reference = 'commentary']/value)]"/>

		<xsl:variable name="procKPIs" select="/node()/simple_instance[(name = $modelSubject/own_slot_value[slot_reference = 'performance_indicators']/value)]"/>

		<table class="table table-bordered ">
			<tr>
				<th class="cellWidth-20pc">
					<xsl:value-of select="eas:i18n('Description')"/>
				</th>
				<td>
					<xsl:value-of select="$procDesc"/>
				</td>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="eas:i18n('Owner')"/>
				</th>
				<td>
					<xsl:choose>
						<xsl:when test="count($thisProcessOwner) > 0">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$thisProcessOwner"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<em>
								<xsl:value-of select="eas:i18n('No procedure owner defined')"/>
							</em>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<th>
					<xsl:value-of select="eas:i18n('Inputs')"/>
				</th>
				<td>
					<xsl:choose>
						<xsl:when test="count($inputInfo union $inputServices) > 0">
							<xsl:if test="count($inputInfo) > 0">
								<em>Information</em>
								<br/>
								<ul>
									<xsl:for-each select="$inputInfo">
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:if>
							<xsl:if test="count($inputServices) > 0">
								<em>Services</em>
								<br/>
								<ul>
									<xsl:for-each select="$inputServices">
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<em>
								<xsl:value-of select="eas:i18n('No inputs defined')"/>
							</em>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<th>
				<xsl:value-of select="eas:i18n('Outputs')"/>
			</th>
			<td>
				<xsl:choose>
					<xsl:when test="count($outputInfo union $outputServices) > 0">
						<xsl:if test="count($outputInfo) > 0">
							<em>Information</em>
							<br/>
							<ul>
								<xsl:for-each select="$outputInfo">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:if>
						<xsl:if test="count($outputServices) > 0">
							<em>Services</em>
							<br/>
							<ul>
								<xsl:for-each select="$outputServices">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<em>
							<xsl:value-of select="eas:i18n('No outputs defined')"/>
						</em>
					</xsl:otherwise>
				</xsl:choose>
				<!--<xsl:choose>
						<xsl:when test="count($outputInfo) > 0">
							<ul>
								<xsl:for-each select="$outputInfo">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()" />
											<xsl:with-param name="theXML" select="$reposXML" />
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:otherwise><em><xsl:value-of select="eas:i18n('No outputs defined')"/></em></xsl:otherwise>
					</xsl:choose>-->
			</td>
			<!--<tr>
				<th><xsl:value-of select="eas:i18n('Guiding Factors')"/></th>
				<td>
					<xsl:choose>
						<xsl:when test="count($procGuidingFactors) > 0">
							<ul>
								<xsl:for-each select="$procGuidingFactors">
									<li>
										<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:otherwise><em><xsl:value-of select="eas:i18n('No guiding factors defined')"/></em></xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>-->
			<tr>
				<th>
					<xsl:value-of select="eas:i18n('Starting Events')"/>
				</th>
				<td>
					<xsl:choose>
						<xsl:when test="count($startEvents) > 0">
							<ul>
								<xsl:for-each select="$startEvents">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="displayString" select="current()/own_slot_value[slot_reference = 'business_process_used']/value"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:otherwise>
							<em>
								<xsl:value-of select="eas:i18n('No start events defined')"/>
							</em>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="ProcessSteps">

		<table class="table table-bordered" id="dt_Cat">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('No')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Step')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Owner')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Next Step')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('No')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Step')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Owner')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Next Step')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<!--<xsl:apply-templates mode="ProcessStepRow" select="$relationList"/>	-->
				<xsl:call-template name="RenderProcessStepRow">
					<xsl:with-param name="inScopeRelations" select="$relationList"/>
					<xsl:with-param name="stepsFound" select="()"/>
				</xsl:call-template>
				<!--<xsl:for-each select="$orderedStepIds">
					<xsl:call-template name="ProcessStepRow">
						<xsl:with-param name="stepId" select="current()"/>
					</xsl:call-template>
				</xsl:for-each>-->
			</tbody>
		</table>
		<script>
			$(document).ready(function(){
				// Setup - add a text input to each footer cell
			    $('#dt_Cat tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
			    } );
				
				var table = $('#dt_Cat').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "5%" },
				    { "width": "30%" },
				    { "width": "35%" },
				    { "width": "20%" },
				    { "width": "10%" }
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
	</xsl:template>


	<xsl:template name="RenderProcessStepRow">
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="stepsFound"/>


		<xsl:if test="count($inScopeRelations) > 0">
			<xsl:variable name="thisRelation" select="$inScopeRelations[1]"/>
			<xsl:variable name="newInScopeRelationList" select="remove($inScopeRelations, 1)"/>

			<xsl:variable name="currentStep" select="$allProcessUsages[name = $thisRelation/own_slot_value[slot_reference = ':FROM']/value]"/>
			<xsl:choose>
				<xsl:when test="not($currentStep/name = $stepsFound/name)">
					<xsl:variable name="newStepsFound" select="insert-before($stepsFound, count($stepsFound) + 1, $currentStep)"/>

					<xsl:variable name="currentStepProcess" select="$business_processes[(name = $currentStep/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $currentStep/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
					<xsl:variable name="stepOwner" select="$defined_business_roles[name = $currentStepProcess/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
					<xsl:variable name="decisionMaker" select="$decisionMakers[name = $currentStep/own_slot_value[slot_reference = 'bpfd_decision_makers']/value]"/>
					<xsl:variable name="currentStepIndex" select="eas:getStepIndex($currentStep, 1, $relationList, ())"/>

					<xsl:variable name="nextStepRelations" select="$relationList[own_slot_value[slot_reference = ':FROM']/value = $currentStep/name]"/>

					<tr>
						<td>
							<xsl:value-of select="$currentStepIndex"/>
						</td>
						<td>
							<strong>
								<xsl:choose>
									<xsl:when test="count($currentStepProcess) > 0">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:when test="count($currentStep) > 0">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</strong>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="count($currentStepProcess) > 0">
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="count($currentStep) > 0">
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>-</xsl:otherwise>
							</xsl:choose>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="count($stepOwner) > 0">
									<ul>
										<xsl:for-each select="$stepOwner">
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
								<xsl:when test="count($decisionMaker) > 0">
									<ul>
										<xsl:for-each select="$decisionMaker">
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
						<td>
							<ul>
								<xsl:for-each select="$nextStepRelations">
									<xsl:sort select="own_slot_value[slot_reference = ':relation_label']/value"/>
									<xsl:variable name="currentRelation" select="current()"/>
									<xsl:variable name="nextStep" select="$allProcessUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
									<xsl:variable name="nextStepIndex" select="eas:getStepIndex($nextStep, 1, $relationList, ())"/>
									<!--<xsl:variable name="nextStepRelation" select="$relationList[own_slot_value[slot_reference=':TO']/value = current()/name]"/>-->
									<xsl:if test="$nextStepIndex > 0">
										<xsl:choose>
											<xsl:when test="$currentStep/type = 'Business_Process_Flow_Decision'">
												<xsl:variable name="decisionResponse">
													<xsl:choose>
														<xsl:when test="count($currentRelation/own_slot_value[slot_reference = ':relation_commentary']/value) > 0">
															<xsl:call-template name="RenderMultiLangCommentarySlot">
																<xsl:with-param name="theSubjectInstance" select="$currentRelation"/>
																<xsl:with-param name="slotName" select="':relation_commentary'"/>
															</xsl:call-template>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$currentRelation/own_slot_value[slot_reference = ':relation_label']/value"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<li><xsl:value-of select="$nextStepIndex"/>&#160;[<xsl:value-of select="$decisionResponse"/>]</li>
											</xsl:when>
											<xsl:otherwise>
												<li>
													<xsl:value-of select="$nextStepIndex"/>
												</li>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:for-each>
							</ul>
						</td>
					</tr>
					<xsl:call-template name="RenderProcessStepRow">
						<xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/>
						<xsl:with-param name="stepsFound" select="$newStepsFound"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderProcessStepRow">
						<xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/>
						<xsl:with-param name="stepsFound" select="$stepsFound"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

	</xsl:template>


	<xsl:template mode="ProcessStepRow" match="node()">
		<xsl:variable name="currentStep" select="$allProcessUsages[name = current()/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="nextStep" select="$allProcessUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="currentStepIndex" select="eas:getStepIndex($currentStep, 1, $relationList, ())"/>
		<!--<xsl:variable name="nextStepRelations" select="$relationList[own_slot_value[slot_reference=':FROM']/value = $nextStep/name]"/>-->


		<xsl:variable name="currentStepProcess" select="$business_processes[(name = $currentStep/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $currentStep/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
		<xsl:variable name="stepOwner" select="$defined_business_roles[name = $currentStepProcess/own_slot_value[slot_reference = 'business_process_owned_by_business_role']/value]"/>
		<xsl:variable name="decisionMaker" select="$decisionMakers[name = $currentStep/own_slot_value[slot_reference = 'bpfd_decision_makers']/value]"/>

		<xsl:variable name="relevantOwnerActor2Roles" select="$processOwnerActor2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="relevantOwners" select="/node()/simple_instance[name = $relevantOwnerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="stepDesc" select="$currentStepProcess/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<xsl:value-of select="$currentStepIndex"/>
			</td>
			<td>
				<strong>
					<xsl:choose>
						<xsl:when test="count($currentStepProcess) > 0">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="count($currentStep) > 0">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($currentStepProcess) > 0">
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$currentStepProcess"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="count($currentStep) > 0">
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($stepOwner) > 0">
						<ul>
							<xsl:for-each select="$stepOwner">
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
					<xsl:when test="count($decisionMaker) > 0">
						<ul>
							<xsl:for-each select="$decisionMaker">
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
			<td>
				<ul>
					<xsl:for-each select="$nextStep">
						<xsl:variable name="nextStepRelation" select="$relationList[own_slot_value[slot_reference = ':FROM']/value = current()/name]"/>
						<xsl:choose>
							<xsl:when test="count($nextStepRelation) > 0">
								<xsl:variable name="nextStepIndex" select="index-of($relationList, $nextStepRelation[1])"/>
								<li>
									<a>
										<xsl:attribute name="href">#<xsl:value-of select="$nextStepIndex"/></xsl:attribute>
										<xsl:value-of select="$nextStepIndex"/>
									</a>
								</li>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</ul>
			</td>
		</tr>
	</xsl:template>


	<!--<xsl:template mode="ProcessStepRow" match="node()">
		<xsl:variable name="currentStep" select="current()"/>
		<xsl:variable name="currentStepIndex" select="index-of($orderedProcessSteps, current())"/>
		<xsl:variable name="relevantOwnerActor2Roles" select="$processOwnerActor2Roles[name = current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="relevantOwners" select="/node()/simple_instance[name=$relevantOwnerActor2Roles/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
		<xsl:variable name="stepName" select="current()/own_slot_value[slot_reference='name']/value"/>
		<xsl:variable name="stepDesc" select="current()/own_slot_value[slot_reference='description']/value"/>
		<tr>
			<td>
				<a id="top">
					<xsl:attribute name="id">#<xsl:value-of select="$currentStepIndex"/></xsl:attribute>
					<xsl:value-of select="$currentStepIndex"/>
				</a>
			</td>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$currentStep" />
						<xsl:with-param name="theXML" select="$reposXML" />
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($stepDesc) > 0">
						<xsl:value-of select="$stepDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>		
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantOwners) > 0">
						<ul>
							<xsl:for-each select="$relevantOwners">
								<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()" />
										<xsl:with-param name="theXML" select="$reposXML" />
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms" />
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				-
			</td>
		</tr>
	</xsl:template>-->


	<xsl:template name="ProcessStepRow">
		<xsl:param name="stepId"/>

		<xsl:variable name="currentStep" select="$processUsages[name = $stepId]"/>
		<xsl:variable name="currentStepIndex" select="index-of($orderedStepIds, $stepId)"/>
		<xsl:variable name="relevantOwnerActor2Roles" select="$processOwnerActor2Roles[name = $currentStep/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="relevantOwners" select="$processOwners[name = $relevantOwnerActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="stepName" select="$currentStep/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="stepDesc" select="$currentStep/own_slot_value[slot_reference = 'description']/value"/>
		<tr>
			<td>
				<a id="top">
					<xsl:attribute name="id">#<xsl:value-of select="$currentStepIndex"/></xsl:attribute>
					<xsl:value-of select="$currentStepIndex"/>
				</a>
			</td>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$currentStep"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($stepDesc) > 0">
						<xsl:value-of select="$stepDesc"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($relevantOwners) > 0">
						<ul>
							<xsl:for-each select="$relevantOwners">
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
			<td> - </td>
		</tr>
	</xsl:template>



	<xsl:function name="eas:generateDecisionRelationList" as="node()*">
		<xsl:param name="decisions"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="relationsFound"/>

		<xsl:variable name="responseRelations" select="$inScopeRelations[own_slot_value[slot_reference = ':FROM']/value = $decisions/name]"/>
		<xsl:variable name="nextDecisionRelations" select="$responseRelations[(own_slot_value[slot_reference = ':TO']/value = $decisionUsages/name)]"/>
		<xsl:variable name="nextProcessUsages" select="$allProcessUsages[name = $responseRelations/own_slot_value[slot_reference = ':TO']/value]"/>

		<xsl:choose>
			<xsl:when test="count($nextDecisionRelations) > 0">
				<xsl:variable name="nextDecisions" select="$allProcessUsages[name = $nextDecisionRelations/own_slot_value[slot_reference = ':TO']/value]"/>
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $responseRelations"/>

				<xsl:variable name="childDecisionRelations" select="eas:generateDecisionRelationList($nextDecisions, $newInScopeRelations, ())"/>

				<xsl:variable name="otherProcUsages" select="$nextProcessUsages except $nextDecisions"/>
				<xsl:variable name="otherProcRelations" select="$responseRelations[own_slot_value[slot_reference = ':TO']/value = $otherProcUsages/name]"/>

				<xsl:variable name="allSubDecisionRelations" select="$otherProcRelations, $nextDecisionRelations, $childDecisionRelations"/>

				<xsl:choose>
					<xsl:when test="count($otherProcUsages) > 0">
						<xsl:sequence select="eas:generateRelationList($otherProcUsages, $newInScopeRelations except $allSubDecisionRelations, $allSubDecisionRelations)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$relationsFound, $allSubDecisionRelations"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($responseRelations) > 0">
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $responseRelations"/>

				<xsl:sequence select="eas:generateRelationList($nextProcessUsages, $newInScopeRelations, $responseRelations)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$relationsFound"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<xsl:function name="eas:generateRelationList" as="node()*">
		<xsl:param name="busProcUsage"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="relationsFound"/>


		<xsl:variable name="nextProcRelations" select="$inScopeRelations[(own_slot_value[slot_reference = ':FROM']/value = $busProcUsage/name)]"/>
		<xsl:variable name="nextProcessUsages" select="$allProcessUsages[(name = $nextProcRelations/own_slot_value[slot_reference = ':TO']/value)]"/>

		<xsl:variable name="nextDecisionRelations" select="$nextProcRelations[(own_slot_value[slot_reference = ':TO']/value = $decisionUsages/name)]"/>

		<xsl:choose>
			<xsl:when test="count($nextDecisionRelations) > 0">

				<xsl:variable name="decisionInScopeRelations" select="$inScopeRelations except $nextDecisionRelations"/>
				<xsl:variable name="nextDecisionUsages" select="$allProcessUsages[(name = $nextDecisionRelations/own_slot_value[slot_reference = ':TO']/value)]"/>

				<xsl:variable name="decisionRelationList" select="eas:generateDecisionRelationList($nextDecisionUsages, $decisionInScopeRelations, $nextDecisionRelations)"/>

				<xsl:variable name="otherProcUsages" select="$nextProcessUsages except $nextDecisionUsages"/>
				<xsl:variable name="otherProcRelations" select="$nextProcRelations[own_slot_value[slot_reference = ':TO']/value = $otherProcUsages/name]"/>

				<xsl:choose>
					<xsl:when test="count($otherProcUsages) > 0">
						<xsl:sequence select="eas:generateRelationList($otherProcUsages, $decisionInScopeRelations except $decisionRelationList, ($otherProcRelations, $nextDecisionRelations, $decisionRelationList))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$relationsFound, $nextDecisionRelations, $decisionRelationList"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($nextProcRelations) > 0">
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $nextProcRelations"/>

				<xsl:sequence select="eas:generateRelationList($nextProcessUsages, $newInScopeRelations, ($relationsFound, $nextProcRelations))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$relationsFound, $nextProcRelations"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<xsl:function name="eas:getStepIndex" as="xs:integer">
		<xsl:param name="step"/>
		<xsl:param name="currentIndex"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="stepsFound"/>

		<xsl:choose>
			<xsl:when test="count($inScopeRelations) > 0">
				<xsl:variable name="thisRelation" select="$inScopeRelations[1]"/>
				<xsl:variable name="newInScopeRelationList" select="remove($inScopeRelations, 1)"/>

				<xsl:variable name="currentStep" select="$allProcessUsages[name = $thisRelation/own_slot_value[slot_reference = ':FROM']/value]"/>
				<xsl:choose>
					<xsl:when test="$currentStep/name = $step/name">
						<xsl:value-of select="$currentIndex"/>
					</xsl:when>
					<xsl:when test="$currentStep/name = $stepsFound/name">
						<xsl:value-of select="eas:getStepIndex($step, $currentIndex, $newInScopeRelationList, $stepsFound)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="newStepsFound" select="insert-before($stepsFound, count($stepsFound) + 1, $currentStep)"/>
						<xsl:value-of select="eas:getStepIndex($step, $currentIndex + 1, $newInScopeRelationList, $newStepsFound)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<xsl:template name="legend">
		<div class="processLegend floatLeft">
			<div class="verticalSpacer_5px"/>
			<style>
				#legendTable {width:auto;}
				#legendTable td {padding: 0 30px 10px 0; }
			</style>
			<table id="legendTable">
				<tbody>
					<tr>
						<td rowspan="2" class="small vAlignTop">
							<strong><xsl:value-of select="eas:i18n('Legend')"/>:</strong>
						</td>
						<td>
							<div class="busProcessLegend"/>
						</td>
						<td>
							<div class="busProcessLegend backColour10"/>
						</td>
						<td>
							<img src="images/person-icon-grey.png" alt="person icon"/>
						</td>
					</tr>
					<tr class="small">
						<td>
							<strong><xsl:value-of select="eas:i18n('Process Step')"/></strong>
						</td>
						<td>
							<strong><xsl:value-of select="eas:i18n('Decision')"/></strong>
						</td>
						<td><strong><xsl:value-of select="eas:i18n('Owner')"/> (<xsl:value-of select="eas:i18n('Role')"/> / <xsl:value-of select="eas:i18n('Position')"/>)</strong></td>
					</tr>
				</tbody>
			</table>
		</div>
	</xsl:template>

</xsl:stylesheet>
