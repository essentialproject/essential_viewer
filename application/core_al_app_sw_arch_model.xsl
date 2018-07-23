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
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Composite_Application_Provider')"/>
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


	<!-- Get the Technology Product Roles defined for the production deployment of the application -->
	<xsl:variable name="appSoftwareArch" select="/node()/simple_instance[name = $appProvNode/own_slot_value[slot_reference = 'has_software_architecture']/value]"/>
	<xsl:variable name="appSWArchUsages" select="/node()/simple_instance[(name = $appSoftwareArch/own_slot_value[slot_reference = 'logical_software_arch_elements']/value)]"/>
	<xsl:variable name="appSWCompUsages" select="$appSWArchUsages[type = 'Software_Component_Usage']"/>
	<xsl:variable name="appSWComps" select="/node()/simple_instance[name = $appSWCompUsages/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
	<xsl:variable name="appInfoRepUsages" select="$appSWArchUsages[type = 'Software_Information_Representation_Usage']"/>
	<xsl:variable name="appInfoReps" select="/node()/simple_instance[name = $appInfoRepUsages/own_slot_value[slot_reference = 'software_usage_of_info_rep']/value]"/>
	<xsl:variable name="allAppSWComps" select="$appSWComps union $appInfoReps"/>
	
	<xsl:variable name="appSWArchRelations" select="/node()/simple_instance[(name = $appSoftwareArch/own_slot_value[slot_reference = 'sw_arch_relations']/value)]"/>
	<xsl:variable name="appSWCompArchRelations" select="$appSWArchRelations[(type = ':SCU-TO-SCU-RELATION')]"/>
	<xsl:variable name="sourceAppSWCompUsages" select="$appSWCompUsages[name = $appSWCompArchRelations/own_slot_value[slot_reference = ':FROM']/value]"/>
	<xsl:variable name="appSWComp2InfoRepArchRelations" select="$appSWArchRelations[(type = 'SCU-TO-SIRU-RELATION')]"/>
	<xsl:variable name="sourceAppSWComp2InfoRepUsages" select="$appSWCompUsages[name = $appSWComp2InfoRepArchRelations/own_slot_value[slot_reference = ':FROM']/value]"/>


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

	<xsl:variable name="objectWidth" select="200"/>
	<xsl:variable name="objectHeight" select="70"/>
	<xsl:variable name="objectTextWidth" select="120"/>
	<xsl:variable name="objectTextHeight" select="60"/>
	<xsl:variable name="objectStrokeWidth" select="1"/>

	<xsl:variable name="objectColour">hsl(220, 2%, 81%)</xsl:variable>
	<xsl:variable name="infoRepColour">hsl(344, 39%, 70%)</xsl:variable>
	<xsl:variable name="objectTextColour">Black</xsl:variable>
	<xsl:variable name="objectOutlineColour">Black</xsl:variable>


	<xsl:variable name="pageTitle" select="'Application Software Architecture for '"/>



	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
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
				<script src="js/jointjs/lodash.min.js"/>
				<script src="js/jointjs/backbone-min.js"/>
				<script src="js/jointjs/joint.min.js"/>
				<script src="js/jquery-ui.js" async="" type="text/javascript"/>
				<script src="js/jointjs/ga.js" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.min.js"/>
				<script src="js/jquery.tools.min.js" type="text/javascript"/>
				<style type="text/css">
					.Rect{
						pointer-events: none;
					}
                     .shadow { -webkit-filter: drop-shadow( -5px -5px 5px #000 );
                    filter: drop-shadow( -5px -5px 5px #000 ) }   
					
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
								</xsl:call-template><xsl:value-of select="$DEBUG"/>
							</h1>
						</div>

						<!--Setup Software Architecture Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Logical Model</h2>
							<div class="verticalSpacer_5px"/>
							<xsl:call-template name="legend"/>
							<div class="verticalSpacer_10px"/>
							<xsl:choose>
								<xsl:when test="count($appSWComps) > 0">
									<div class="simple-scroller" style="overflow: scroll;">
										<div id="mainPageDiv"/>
									</div>
									<xsl:call-template name="modelScript">
										<xsl:with-param name="targetID">mainPageDiv</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<em>
										<xsl:value-of select="eas:i18n('No Software Architecture Defined')"/>
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
		<xsl:if test="count($appSWComps) > 0">
			<script>
					
					var graph = new joint.dia.Graph;
					
					var windowWidth = $(window).width()*2;
					var windowHeight = $(window).height()*2;
					
					var paper = new joint.dia.Paper({
						el: $('#<xsl:value-of select="$targetID"/>'),
				        width: $('#<xsl:value-of select="$targetID"/>').width(),
				        height: <xsl:value-of select="($objectHeight + 30) * count($allAppSWComps)"/>+100,
				        gridSize: 1,
				        model: graph
				    });
				    
				    
				    paper.setOrigin(30,30);
					
					// Create a custom element.
					// ------------------------
					joint.shapes.custom = {};
					joint.shapes.custom.Cluster = joint.shapes.basic.Rect.extend({
						markup: '<g class="rotatable"><g class="scalable"><rect/></g><text/></g>',
					    defaults: joint.util.deepSupplement({
					        type: 'custom.Cluster',
					        attrs: {
					            rect: { rx: "5", ry: "5", fill: '#E67E22', stroke: '#D35400', 'stroke-width': 3 },
					            text: { 
					            	fill: 'white',
					            	'ref-x': .5,
		                        	'ref-y': .4
					            },
                                image: {}
					        }
					    }, joint.shapes.basic.Rect.prototype.defaults)
					});
					
					joint.shapes.custom.InfoRep = joint.shapes.basic.Rect.extend({
						markup: '<g class="rotatable"><g class="scalable"><circle/></g><text/></g>',
					    defaults: joint.util.deepSupplement({
					        type: 'custom.InfoRep',
					        attrs: {
                                rect: { rx: "5", ry: "5", fill: '#E67E22', stroke: '#D35400', 'stroke-width': 3 },
					           <!-- circle: {fill: '#E67E22', stroke: '#D35400', 'stroke-width': 3 },-->
					            text: { 
					            	fill: 'white',
					            	'ref-x': .5,
		                        	'ref-y': .4
					            }
					        }
					    }, joint.shapes.basic.Rect.prototype.defaults)
					});
                
                joint.shapes.basic.DecoratedRect = joint.shapes.basic.Generic.extend({

                    markup: '<g class="rotatable"><g class="scalable shadow"><rect/></g><image/><text/></g>',

                    defaults: joint.util.deepSupplement({

                        type: 'basic.DecoratedRect',
                        size: { width: 100, height: 60 },
                        attrs: {
                            'rect': { fill: '#bdcaff', stroke: '#575656', width: 100, height: 60,  rx: "4", ry: "4", "box-shadow": "6px 4px 10px 10px #888888"},
                            'text': { 'font-size': 16, text: '', 'ref-x': .5, 'ref-y': .5, ref: 'rect', 'y-alignment': 'middle', 'x-alignment': 'middle', fill: 'black' },
                            'image': { 'ref-x': 5, 'ref-y': 5, ref: 'rect', width: 30, height: 30 }
                        }

                    }, joint.shapes.basic.Generic.prototype.defaults)
                });
                
                joint.shapes.basic.DecoratedRectInfoRep = joint.shapes.basic.Generic.extend({

                    markup: '<g class="rotatable"><g class="scalable shadow"><rect/></g><image/><text/></g>',

                    defaults: joint.util.deepSupplement({

                        type: 'basic.DecoratedRectInfoRep',
                        size: { width: 100, height: 60 },
                        attrs: {
                            'rect': { fill: '#f4f4f4', stroke: '#575656', width: 100, height: 60,  rx: "4", ry: "4", "box-shadow": "6px 4px 10px 10px #888888"},
                            'text': { 'font-size': 16, text: '', 'ref-x': .5, 'ref-y': .5, ref: 'rect', 'y-alignment': 'middle', 'x-alignment': 'middle', fill: 'black' },
                            'image': { 'ref-x': 5, 'ref-y': 5, ref: 'rect', width: 30, height: 30 }
                        }

                    }, joint.shapes.basic.Generic.prototype.defaults)
                });
					
					
					function wrapClusterName(nameText) {
						return joint.util.breakText(nameText, {
						    width: <xsl:value-of select="$objectTextWidth"/>,
						    height: <xsl:value-of select="$objectTextHeight"/>
						});
					}
					
					
					<xsl:apply-templates mode="RenderSWCompNameVariable" select="$allAppSWComps"/>
					
					var clusters = {
						<xsl:apply-templates mode="RenderSWCompDefinition" select="$appSWComps"/>
						<xsl:if test="(count($appSWComps) > 0) and (count($appInfoReps) > 0)">, </xsl:if><xsl:apply-templates mode="RenderSWCompDefinition" select="$appInfoReps"/>
					};
					
					_.each(clusters, function(c) { graph.addCell(c); });
		
		
					var relations = [
					<xsl:apply-templates mode="RenderSWCompRelation" select="$sourceAppSWCompUsages"/>
					<xsl:if test="(count($sourceAppSWCompUsages) > 0) and (count($sourceAppSWComp2InfoRepUsages) > 0)">, </xsl:if><xsl:apply-templates mode="RenderSWComp2InfoRepRelation" select="$sourceAppSWComp2InfoRepUsages"/>
					];
					
					_.each(relations, function(r) { graph.addCell(r); });
					
					
					joint.layout.DirectedGraph.layout(graph, { setLinkVertices: false, rankDir: "TB", nodeSep: 100, edgeSep: 100 });
					
					
					<!--<xsl:apply-templates mode="RenderTPRLifecycleStatus" select="$techProdRoles"/>-->
					
					
					// paper.scale(0.9, 0.9);
					// paper.scaleContentToFit();
		    
					
				</script>
		</xsl:if>
	</xsl:template>



	<xsl:template mode="RenderSWCompNameVariable" match="node()">
		<xsl:variable name="nodeType" select="'Cluster'"/>
		<xsl:variable name="index" select="index-of($allAppSWComps, current())"/>
		<xsl:variable name="nameVariable" select="concat(lower-case($nodeType), $index, 'Name')"/>
		<xsl:variable name="nodeNamingFunction" select="concat('wrap', $nodeType, 'Name')"/>
		<xsl:variable name="nodeNameString" select="current()/own_slot_value[slot_reference = 'name']/value"/> var <xsl:value-of select="$nameVariable"/> = <xsl:value-of select="$nodeNamingFunction"/>('<xsl:value-of select="$nodeNameString"/><xsl:text>');
		</xsl:text>
	</xsl:template>




	<xsl:template mode="RenderSWCompDefinition" match="node()">
		<xsl:variable name="index" select="index-of($allAppSWComps, current())"/>
		<xsl:variable name="nameVariable" select="concat('cluster', $index, 'Name')"/>
		<xsl:variable name="nodeListName" select="concat('cluster', $index)"/>
		
		<xsl:choose>
			<xsl:when test="current()/name = $appInfoReps/name">
                <xsl:value-of select="$nodeListName"/>: new joint.shapes.basic.DecoratedRect({
                    position: { x: 100, y: 20 },
                    size: { width: <xsl:value-of select="$objectWidth"/>, height: <xsl:value-of select="$objectHeight"/>  },
                    attrs: { 
                        text: { text: <xsl:value-of select="$nameVariable"/> },
                        image: { 'xlink:href': 'images/icon_repository.png' },
                        fill: { fill:'#e3e3e3'}
                    }
                })
  

            </xsl:when>
			<xsl:otherwise>                <xsl:value-of select="$nodeListName"/>: new joint.shapes.basic.DecoratedRectInfoRep({
                    position: { x: 100, y: 20 },
                    size: { width: <xsl:value-of select="$objectWidth"/>, height: <xsl:value-of select="$objectHeight"/>  },
                    attrs: { 
                        text: { text: <xsl:value-of select="$nameVariable"/> },
                        fill: { fill:'#d3ede5'},
                        image: { 'xlink:href': 'images/icon_cogs.png' }
                    }
                })
            </xsl:otherwise>
		</xsl:choose><xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>



	<xsl:template mode="RenderSWCompRelation" match="node()">
		<xsl:variable name="currentSWCompUsage" select="current()"/>
		<xsl:variable name="currentSWComp" select="$appSWComps[name = $currentSWCompUsage/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>

		<xsl:variable name="index" select="index-of($allAppSWComps, $currentSWComp)"/>
		<xsl:variable name="sourceListName" select="concat('cluster', $index)"/>

		<xsl:variable name="relevantRelations" select="$appSWCompArchRelations[own_slot_value[slot_reference = ':FROM']/value = $currentSWCompUsage/name]"/>
		<xsl:variable name="targetSWCompUsages" select="($appSWArchUsages except $currentSWCompUsage)[name = $relevantRelations/own_slot_value[slot_reference = ':TO']/value]"/>


		<xsl:for-each select="$targetSWCompUsages">
			<xsl:variable name="targetSWComp" select="$appSWComps[name = current()/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
			<xsl:variable name="targetIndex" select="index-of($allAppSWComps, $targetSWComp)"/>
			<xsl:variable name="targetListName" select="concat('cluster', $targetIndex)"/> new joint.dia.Link({ source: { id: clusters.<xsl:value-of select="$sourceListName"/>.id }, target: { id: clusters.<xsl:value-of select="$targetListName"/>.id }, attrs: { '.marker-target': { d: 'M 10 0 L 0 5 L 10 10 z' }, '.connection': {'stroke-width': 2 }, '.link-tools': { display : 'none'}, '.marker-arrowheads': { display: 'none' },'.connection-wrap': { display: 'none' }, }})<xsl:if test="not(position() = last())"><xsl:text>,
			</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:if test="(not(position() = last())) and (count($targetSWCompUsages) > 0)">
			<xsl:text>,
		</xsl:text>
		</xsl:if>

	</xsl:template>
	
	<xsl:template mode="RenderSWComp2InfoRepRelation" match="node()">
		<xsl:variable name="currentSWCompUsage" select="current()"/>
		<xsl:variable name="currentSWComp" select="$appSWComps[name = $currentSWCompUsage/own_slot_value[slot_reference = 'usage_of_software_component']/value]"/>
		
		<xsl:variable name="index" select="index-of($allAppSWComps, $currentSWComp)"/>
		<xsl:variable name="sourceListName" select="concat('cluster', $index)"/>
		
		<xsl:variable name="relevantRelations" select="$appSWComp2InfoRepArchRelations[own_slot_value[slot_reference = ':FROM']/value = $currentSWCompUsage/name]"/>
		<xsl:variable name="targetInfoRepUsages" select="$appInfoRepUsages[name = $relevantRelations/own_slot_value[slot_reference = ':TO']/value]"/>
		
		
		<xsl:for-each select="$targetInfoRepUsages">
			<xsl:variable name="targetInfoRep" select="$appInfoReps[name = current()/own_slot_value[slot_reference = 'software_usage_of_info_rep']/value]"/>
			<xsl:variable name="targetIndex" select="index-of($allAppSWComps, $targetInfoRep)"/>
			<xsl:variable name="targetListName" select="concat('cluster', $targetIndex)"/> new joint.dia.Link({ source: { id: clusters.<xsl:value-of select="$sourceListName"/>.id }, target: { id: clusters.<xsl:value-of select="$targetListName"/>.id }, attrs: { '.marker-target': { d: 'M 10 0 L 0 5 L 10 10 z' }, '.connection': {'stroke-width': 2 }, '.link-tools': { display : 'none'}, '.marker-arrowheads': { display: 'none' },'.connection-wrap': { display: 'none' }, }})<xsl:if test="not(position() = last())"><xsl:text>,
			</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:if test="(not(position() = last())) and (count($targetInfoRepUsages) > 0)">
			<xsl:text>,
		</xsl:text>
		</xsl:if>
		
	</xsl:template>



	<!--<xsl:function as="xs:string" name="eas:get_techcomp_name">
		<xsl:param name="tpr"/>

		<xsl:variable name="techProd" select="$techProds[name = $tpr/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techComp" select="$techComps[name = $tpr/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:variable name="techLProdSupplier" select="$techLProdSuppliers[name = $techProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:value-of select="concat($techLProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $techProd/own_slot_value[slot_reference = 'name']/value, ' as ', $techComp/own_slot_value[slot_reference = 'name']/value)"/>

	</xsl:function>-->


	<xsl:template name="legend">
		<div class="keyContainer">
			<div class="keySampleLabel">Software Architecture Legend: </div>
			<div class="keySampleLabel"><img src="images/icon_cogs.png" height="20" width="20"/>Software Component</div>

			<div class="keySampleLabel"><img src="images/icon_repository.png" height="20" width="20"/> Data Store</div>
		</div>
	</xsl:template>



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





</xsl:stylesheet>
