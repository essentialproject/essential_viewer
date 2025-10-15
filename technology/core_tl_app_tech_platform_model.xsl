<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

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
	<!-- 27.04.2017 JP Created as revised version of original view -->


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Technology_Component', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->



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
	<!-- 23.04.2015 JP	Created -->

	<xsl:variable name="appProvNode" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appProvName" select="$appProvNode/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="strategicLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'ProductionStrategic']"/>
	<xsl:variable name="strategicLifecycleStyle" select="eas:get_lifecycle_style($strategicLifecycleStatus)"/>
	<xsl:variable name="pilotLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Pilot']"/>
	<xsl:variable name="pilotLifecycleStyle" select="eas:get_lifecycle_style($pilotLifecycleStatus)"/>
	<xsl:variable name="underPlanningLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Under Planning']"/>
	<xsl:variable name="underPlanningLifecycleStyle" select="eas:get_lifecycle_style($underPlanningLifecycleStatus)"/>
	<xsl:variable name="prototypeLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Prototype']"/>
	<xsl:variable name="prototypeLifecycleStyle" select="eas:get_lifecycle_style($prototypeLifecycleStatus)"/>

	<xsl:variable name="alllifecycleStyles" select="/node()/simple_instance[name = $allLifecycleStatii/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>

	<!-- Get the Technology Product Roles defined for the production deployment of the application -->
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="appTechCompArch" select="/node()/simple_instance[name = $appProvNode/own_slot_value[slot_reference = 'implemented_with_technology']/value]"/>
	<xsl:variable name="appTechCompArchModel" select="/node()/simple_instance[name = $appTechCompArch/own_slot_value[slot_reference = 'technology_component_architecture']/value]"/>
	<xsl:variable name="appTechCompUsages" select="/node()/simple_instance[(type = 'Technology_Component_Usage') and (name = $appTechCompArchModel/own_slot_value[slot_reference = 'technology_component_usages']/value)]"/>
	<xsl:variable name="appTechComps" select="/node()/simple_instance[name = $appTechCompUsages/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
	<xsl:variable name="appTechCompArchRelations" select="/node()/simple_instance[(type = ':TCU-TO-TCU-RELATION') and (name = $appTechCompArchModel/own_slot_value[slot_reference = 'invoked_functions_relations']/value)]"/>
	<xsl:variable name="sourceAppTechCompUsages" select="$appTechCompUsages[name = $appTechCompArchRelations/own_slot_value[slot_reference = ':FROM']/value]"/>

	<!-- Get the Technology Product Roles defined for any Technology Product Builds that provide the Technology Composite supporting the app -->
	<xsl:variable name="appTechComp" select="/node()/simple_instance[name = $appProvNode/own_slot_value[slot_reference = 'implemented_with_technology']/value]"/>
	<xsl:variable name="appTechProdBuildRole" select="/node()/simple_instance[name = $appTechComp/own_slot_value[slot_reference = 'realised_by_technology_products']/value]"/>
	<xsl:variable name="appTechProdBuild" select="/node()/simple_instance[name = $appTechProdBuildRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="appTechProvArch" select="/node()/simple_instance[name = $appTechProdBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
	<xsl:variable name="appTechTPRUsages" select="/node()/simple_instance[(type = 'Technology_Provider_Usage') and (name = $appTechProvArch/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
	<xsl:variable name="appTechTPRs" select="$allTechProdRoles[name = $appTechTPRUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>

	<!-- Combine the Technology Product Roles supporting the production app deployment and that iplement the technology composite supporting it -->
	<!--<xsl:variable name="techProdRoleUsages" select="$appDepTPRUsages union $appTechTPRUsages"/>
	<xsl:variable name="techProdRoles" select="$appDepTPRs union $appTechTPRs"/>
	<xsl:variable name="techProds" select="$allTechProds[name = $techProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="techComps" select="/node()/simple_instance[name = $techProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
	<xsl:variable name="techLProdSuppliers" select="$allSuppliers[name = $techProds/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="techProdArchRelations" select="/node()/simple_instance[(type = ':TPU-TO-TPU-RELATION') and (name = $techProvArch/own_slot_value[slot_reference = 'contained_provider_architecture_relations']/value)]"/>

	<xsl:variable name="sourceTechProdRoleUsages" select="$techProdRoleUsages[name = $techProdArchRelations/own_slot_value[slot_reference = ':FROM']/value]"/>
-->

	<xsl:variable name="DEBUG" select="''"/>

	<xsl:variable name="modelSubjectName">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="modelSubjectDesc">
		<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="objectWidth" select="240"/>
	<xsl:variable name="objectHeight" select="100"/>
	<xsl:variable name="objectTextWidth" select="120"/>
	<xsl:variable name="objectTextHeight" select="100"/>
	<xsl:variable name="objectStrokeWidth" select="1"/>


	<xsl:variable name="noStatusColour">Grey</xsl:variable>
	<xsl:variable name="noStatusStyle">backColourGrey</xsl:variable>
	<xsl:variable name="objectColour">hsla(220, 70%, 95%, 1)</xsl:variable>
	<xsl:variable name="objectTextColour">Black</xsl:variable>
	<xsl:variable name="objectOutlineColour">Black</xsl:variable>


	<xsl:variable name="pageTitle" select="'Application Technology Platform Model for '"/>

	<xsl:variable name="techProdSummaryReport" select="eas:get_report_by_name('Core: Technology Product Summary')"/>
	<xsl:variable name="techCompSummaryReport" select="eas:get_report_by_name('Core: Technology Component Summary')"/>



	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="$pageTitle"/>
					<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
					</xsl:call-template>
				</title>
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>
				<script src="js/lodash/index.js"/>
				<script src="js/backbone/backbone.js"/>
				<script src="js/graphlib/graphlib.core.js"/>
				<script src="js/dagre/dagre.core.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/jointjs/ga.js" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.js"/>
				<script src="js/jquery.tools.min.js" type="text/javascript"/>
				<style type="text/css">
					.Rect{
						pointer-events: none;
					}
					
					.techProdCell{
					}</style>

			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<!--<xsl:variable name="modelSubjectDesc" select="$appProvNode/own_slot_value[slot_reference='description']/value" />-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey">
									<xsl:value-of select="$pageTitle"/>
								</span>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
									<xsl:with-param name="anchorClass" select="'text-primary'"/>
								</xsl:call-template>
							</h1>
						</div>

						<!--Setup Description Section-->
						<!--<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>
							<div class="content-section">
								<xsl:value-of select="$modelSubjectDesc"/>
							</div>
							<hr/>
						</div>-->

						<!--Setup Logical Architecture Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Logical Technology Architecture</h2>
							<!--<div class="verticalSpacer_5px"/>
							<xsl:call-template name="legend"/>-->
							<div class="verticalSpacer_10px"/>
							<xsl:choose>
								<xsl:when test="count($appTechComps) > 0">
									<div class="simple-scroller" style="overflow: scroll;">
										<div id="mainPageDiv"/>
									</div>
									<xsl:call-template name="modelScript">
										<xsl:with-param name="targetID">mainPageDiv</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<em>
										<xsl:value-of select="eas:i18n('No Technology Platform Architecture Defined')"/>
									</em>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>
						<!--Setup Closing Tags-->

						<!--Setup Logical Architecture Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-check-circle icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Technology Components</h2>
							<div class="verticalSpacer_5px"/>
							<xsl:choose>
								<xsl:when test="count($appTechComps) > 0">
									<!--<table class="table table-bordered table-striped ">
										<thead>
											<tr>
												<th class="cellWidth-40pc">Required Component</th>
												<th class="cellWidth-40pc">Description</th>
												<th class="cellWidth-60pc">Candidate Technology Products</th>
											</tr>
										</thead>
										<tbody>
											<xsl:apply-templates mode="RenderTechComponentTable" select="$techComps">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											</xsl:apply-templates>
										</tbody>
									</table>-->
									<xsl:apply-templates mode="RenderTechComponentTable" select="$appTechComps">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:otherwise>
									<em>
										<xsl:value-of select="eas:i18n('No Technology Components Defined')"/>
									</em>
								</xsl:otherwise>
							</xsl:choose>
							<hr/>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
                    $(document).ready(function(){
                        var windowHeight = $(window).height();
						var windowWidth = $(window).width();
                        $('.simple-scroller').scrollLeft(windowWidth/2);
                    });
                </script>

			</body>
		</html>
	</xsl:template>

	<xsl:template name="modelScript">
		<xsl:param name="targetID"/>
		<xsl:if test="count($appTechComps) > 0">
			<script>
					
					var graph = new joint.dia.Graph;
					
					var windowWidth = $(window).width()*2;
					var windowHeight = $(window).height()*2;
					
					var paper = new joint.dia.Paper({
						el: $('#<xsl:value-of select="$targetID"/>'),
				        width: $('#<xsl:value-of select="$targetID"/>').width(),
				        height: <xsl:value-of select="($objectHeight + 30) * count($appTechComps)"/>,
				        gridSize: 1,
				        model: graph
				    });
				    
				    
				    paper.setOrigin(30,30);
					
					// Create a custom element.
					// ------------------------
					joint.shapes.custom = {};
					joint.shapes.custom.Cluster = joint.shapes.basic.Rect.extend({
						markup: '<g class="rotatable"><g class="scalable"><rect/></g><a><text/></a></g>',
					    defaults: joint.util.deepSupplement({
					        type: 'custom.Cluster',
					        attrs: {
					            rect: { rx: "5", ry: "5", fill: '#E67E22', stroke: '#D35400', 'stroke-width': 5 },
					            text: { 
					            	fill: 'white',
					            	'ref-x': .5,
		                        	'ref-y': .4
					            }
					        }
					    }, joint.shapes.basic.Rect.prototype.defaults)
					});
					
					
					function wrapClusterName(nameText) {
						return joint.util.breakText(nameText, {
						    width: <xsl:value-of select="$objectTextWidth"/>,
						    height: <xsl:value-of select="$objectTextHeight"/>
						});
					}
					
					
					<xsl:apply-templates mode="RenderTechCompNameVariable" select="$appTechComps"/>
					
					var clusters = {
						<xsl:apply-templates mode="RenderTechCompDefinition" select="$appTechComps"/>			
					};
					
					_.each(clusters, function(c) { graph.addCell(c); });
		
		
					var relations = [
					<xsl:apply-templates mode="RenderTechCompRelation" select="$sourceAppTechCompUsages"/>
					];
					
					_.each(relations, function(r) { graph.addCell(r); });
					
					
					joint.layout.DirectedGraph.layout(graph, { setLinkVertices: false, rankDir: "TB", nodeSep: 100, edgeSep: 100 });
					
					
					<!--<xsl:apply-templates mode="RenderTPRLifecycleStatus" select="$techProdRoles"/>-->
					
					
					// paper.scale(0.9, 0.9);
					// paper.scaleContentToFit();
		    
					
				</script>
		</xsl:if>
	</xsl:template>



	<xsl:template mode="RenderTechCompNameVariable" match="node()">
		<xsl:variable name="nodeType" select="'Cluster'"/>
		<xsl:variable name="index" select="index-of($appTechComps, current())"/>
		<xsl:variable name="nameVariable" select="concat(lower-case($nodeType), $index, 'Name')"/>
		<xsl:variable name="nodeNamingFunction" select="concat('wrap', $nodeType, 'Name')"/>
		<xsl:variable name="nodeNameString" select="current()/own_slot_value[slot_reference = 'name']/value"/> var <xsl:value-of select="$nameVariable"/> = <xsl:value-of select="$nodeNamingFunction"/>('<xsl:value-of select="$nodeNameString"/><xsl:text>');
		</xsl:text>
	</xsl:template>




	<xsl:template mode="RenderTechCompDefinition" match="node()">
		<xsl:variable name="index" select="index-of($appTechComps, current())"/>
		<xsl:variable name="nameVariable" select="concat('cluster', $index, 'Name')"/>
		<xsl:variable name="nodeListName" select="concat('cluster', $index)"/>
		
		<xsl:variable name="techCompSummaryLinkHref">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theInstanceID" select="current()/name"/>
				<xsl:with-param name="theXSL" select="$techCompSummaryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$nodeListName"/>: new joint.shapes.custom.Cluster({ position: { x: 100, y: 20 }, size: { width: <xsl:value-of select="$objectWidth"/>, height: <xsl:value-of select="$objectHeight"/> }, attrs: {rect: {'stroke-width': <xsl:value-of select="$objectStrokeWidth"/>, fill: '<xsl:value-of select="$objectColour"/>', stroke: '<xsl:value-of select="$objectOutlineColour"/>'<!--, rx: 5, ry: 5--> }, a: { 'xlink:href': '<xsl:value-of select="$techCompSummaryLinkHref"/>', cursor: 'pointer' }, text: { text: <xsl:value-of select="$nameVariable"/>, fill: '<xsl:value-of select="$objectTextColour"/>', 'font-weight': 'bold', 'font-size': 18 }} })<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>



	<xsl:template mode="RenderTechCompRelation" match="node()">
		<xsl:variable name="currentTechCompeUsage" select="current()"/>
		<xsl:variable name="currentTechComp" select="$appTechComps[name = $currentTechCompeUsage/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>

		<xsl:variable name="index" select="index-of($appTechComps, $currentTechComp)"/>
		<xsl:variable name="sourceListName" select="concat('cluster', $index)"/>

		<xsl:variable name="relevantRelations" select="$appTechCompArchRelations[own_slot_value[slot_reference = ':FROM']/value = $currentTechCompeUsage/name]"/>
		<xsl:variable name="targetTechCompUsages" select="($appTechCompUsages except $currentTechCompeUsage)[name = $relevantRelations/own_slot_value[slot_reference = ':TO']/value]"/>


		<xsl:for-each select="$targetTechCompUsages">
			<xsl:variable name="targetTechComp" select="$appTechComps[name = current()/own_slot_value[slot_reference = 'usage_of_technology_component']/value]"/>
			<xsl:variable name="targetIndex" select="index-of($appTechComps, $targetTechComp)"/>
			<xsl:variable name="targetListName" select="concat('cluster', $targetIndex)"/> new joint.dia.Link({ source: { id: clusters.<xsl:value-of select="$sourceListName"/>.id }, target: { id: clusters.<xsl:value-of select="$targetListName"/>.id }, attrs: { '.marker-target': { d: 'M 10 0 L 0 5 L 10 10 z' }, '.connection': {'stroke-width': 2 }, '.link-tools': { display : 'none'}, '.marker-arrowheads': { display: 'none' },'.connection-wrap': { display: 'none' }, }})<xsl:if test="not(position() = last())"><xsl:text>,
			</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:if test="(not(position() = last())) and (count($targetTechCompUsages) > 0)">
			<xsl:text>,
		</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:function as="xs:string" name="eas:get_lifecycle_style">
		<xsl:param name="techProdRoleLifecycleStatus"/>

		<xsl:choose>
			<xsl:when test="count($techProdRoleLifecycleStatus) = 0">
				<xsl:value-of select="$noStatusStyle"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lifecycleStyle" select="$alllifecycleStyles[name = $techProdRoleLifecycleStatus[1]/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:choose>
					<xsl:when test="count($lifecycleStyle) = 0">
						<xsl:value-of select="$noStatusStyle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="styleClass" select="$lifecycleStyle[1]/own_slot_value[slot_reference = 'element_style_class']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($styleClass) = 0">
								<xsl:value-of select="$noStatusStyle"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$styleClass"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<!--<xsl:function as="xs:string" name="eas:get_techcomp_name">
		<xsl:param name="tpr"/>

		<xsl:variable name="techProd" select="$techProds[name = $tpr/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techComp" select="$techComps[name = $tpr/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:variable name="techLProdSupplier" select="$techLProdSuppliers[name = $techProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:value-of select="concat($techLProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $techProd/own_slot_value[slot_reference = 'name']/value, ' as ', $techComp/own_slot_value[slot_reference = 'name']/value)"/>

	</xsl:function>-->






	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:get_js_name_for_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="lowerCaseName" select="lower-case($dataObjectName)"/>
		<xsl:variable name="noOpenBrackets" select="translate($lowerCaseName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:value-of select="translate($noCloseBrackets, ' ', '')"/>

	</xsl:function>

	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:no_specials_js_name_for_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="noOpenBrackets" select="translate($dataObjectName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:value-of select="$noCloseBrackets"/>

	</xsl:function>

	<xsl:template mode="RenderTechComponentTable" match="node()">
		<xsl:variable name="thisTechComp" select="current()"/>
		<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>


		<h3>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$thisTechComp"/>
			</xsl:call-template>
		</h3>
		<span class=""><xsl:value-of select="$thisTechComp/own_slot_value[slot_reference = 'description']/value"/></span>
		
		<xsl:call-template name="RenderProductsForTechComp">
			<xsl:with-param name="techComp" select="$thisTechComp"/>
		</xsl:call-template>

	</xsl:template>


	<xsl:template name="RenderProductsForTechComp">
		<xsl:param name="techComp" select="()"/>

		<!-- Get the TPRs that have either strategic, pilot, under planning or prototype lifecycle status -->
		<xsl:variable name="strategicTRPs" select="$allTechProdRoles[(own_slot_value[slot_reference = 'implementing_technology_component']/value = $techComp/name) and (own_slot_value[slot_reference = 'strategic_lifecycle_status']/value = $strategicLifecycleStatus/name)]"/>
		<xsl:variable name="pilotTPRs" select="$allTechProdRoles[(own_slot_value[slot_reference = 'implementing_technology_component']/value = $techComp/name) and (own_slot_value[slot_reference = 'strategic_lifecycle_status']/value = $pilotLifecycleStatus/name)]"/>
		<xsl:variable name="underPlanningTPRs" select="$allTechProdRoles[(own_slot_value[slot_reference = 'implementing_technology_component']/value = $techComp/name) and (own_slot_value[slot_reference = 'strategic_lifecycle_status']/value = $underPlanningLifecycleStatus/name)]"/>
		<xsl:variable name="prototypeTPRs" select="$allTechProdRoles[(own_slot_value[slot_reference = 'implementing_technology_component']/value = $techComp/name) and (own_slot_value[slot_reference = 'strategic_lifecycle_status']/value = $prototypeLifecycleStatus/name)]"/>


		<div>
			<p class="fontBlack text-primary large">Candidate Technology Products</p>
			<style>
				.ulTight{
					margin-bottom: 0px;
				}</style>
			<table class="table table-bordered table-striped ">
				<thead>
					<tr>
						<th>
							<xsl:attribute name="class" select="concat('cellWidth-25pc', ' ', $strategicLifecycleStyle)"/>
							<xsl:value-of select="$strategicLifecycleStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</th>
						<th>
							<xsl:attribute name="class" select="concat('cellWidth-25pc', ' ', $pilotLifecycleStyle)"/>
							<xsl:value-of select="$pilotLifecycleStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</th>
						<th>
							<xsl:attribute name="class" select="concat('cellWidth-25pc', ' ', $underPlanningLifecycleStyle)"/>
							<xsl:value-of select="$underPlanningLifecycleStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</th>
						<th>
							<xsl:attribute name="class" select="concat('cellWidth-25pc', ' ', $prototypeLifecycleStyle)"/>
							<xsl:value-of select="$prototypeLifecycleStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<td>
						<xsl:choose>
							<xsl:when test="count($strategicTRPs) > 0">
								<ul>
									<xsl:for-each select="$strategicTRPs">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										<xsl:variable name="thisTechProd" select="$allTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
										<xsl:variable name="thisTechProdSupplier" select="$allSuppliers[name = $thisTechProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
										<xsl:variable name="thisTechProdName" select="concat($thisTechProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $thisTechProd/own_slot_value[slot_reference = 'name']/value)"/>
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
												<xsl:with-param name="displayString" select="$thisTechProdName"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('None')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="count($pilotTPRs) > 0">
								<ul>
									<xsl:for-each select="$pilotTPRs">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										<xsl:variable name="thisTechProd" select="$allTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
										<xsl:variable name="thisTechProdSupplier" select="$allSuppliers[name = $thisTechProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
										<xsl:variable name="thisTechProdName" select="concat($thisTechProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $thisTechProd/own_slot_value[slot_reference = 'name']/value)"/>
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
												<xsl:with-param name="displayString" select="$thisTechProdName"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('None')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="count($underPlanningTPRs) > 0">
								<ul>
									<xsl:for-each select="$underPlanningTPRs">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										<xsl:variable name="thisTechProd" select="$allTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
										<xsl:variable name="thisTechProdSupplier" select="$allSuppliers[name = $thisTechProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
										<xsl:variable name="thisTechProdName" select="concat($thisTechProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $thisTechProd/own_slot_value[slot_reference = 'name']/value)"/>
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
												<xsl:with-param name="displayString" select="$thisTechProdName"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('None')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="count($prototypeTPRs) > 0">
								<ul>
									<xsl:for-each select="$prototypeTPRs">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										<xsl:variable name="thisTechProd" select="$allTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
										<xsl:variable name="thisTechProdSupplier" select="$allSuppliers[name = $thisTechProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
										<xsl:variable name="thisTechProdName" select="concat($thisTechProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $thisTechProd/own_slot_value[slot_reference = 'name']/value)"/>
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
												<xsl:with-param name="displayString" select="$thisTechProdName"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('None')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tbody>
			</table>
		</div>
		<div class="verticalSpacer_20px"/>
	</xsl:template>




</xsl:stylesheet>
