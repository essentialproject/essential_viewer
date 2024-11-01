<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Group_Actor', 'Individual_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="pageTitle" select="eas:i18n('Organisation and Reporting Structure')"/>
	
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']" />
	<xsl:variable name="allIndivActors" select="/node()/simple_instance[(type = 'Individual_Actor') and (own_slot_value[slot_reference = 'is_member_of_actor']/value = $allGroupActors/name)]" />
	<xsl:variable name="allActor2Jobs" select="/node()/simple_instance[own_slot_value[slot_reference = 'actor_to_job_from_actor']/value = $allIndivActors/name]" />
	<xsl:variable name="allJobs" select="/node()/simple_instance[name = $allActor2Jobs/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]" />
	
	<xsl:variable name="headofDepRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Head of Department')]" />
	<xsl:variable name="allHeadofDep2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $headofDepRole/name]"/>
	<xsl:variable name="allHeadofDeps" select="$allIndivActors[name = $allHeadofDep2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	
	<xsl:variable name="directReportingStrength" select="/node()/simple_instance[(type = 'Actor_Reporting_Line_Strength') and (own_slot_value[slot_reference = 'name']/value = 'Direct')]" />
	<xsl:variable name="allDirectReportingRels" select="/node()/simple_instance[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_strength']/value = $directReportingStrength/name) and (own_slot_value[slot_reference = ('indvact_reportsto_indvact_from_actor', 'indvact_reportsto_indvact_to_actor')]/value = $allIndivActors/name)]"/>
	
	<xsl:variable name="topLevelOrgID">
		<xsl:choose>
			<xsl:when test="string-length($param1) > 0">
				<xsl:value-of select="$param1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Org Model - Root Organisation')]" />
				<xsl:value-of select="$rootOrgConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="topLevelOrg" select="$allGroupActors[name = $topLevelOrgID]" />
	
	<xsl:variable name="maxDepth" select="12"/>
	
	
	<!-- END VIEW SPECIFIC VARIABLES -->
	

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
	<!-- 23.11.2018 JP  Created	 -->


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
				<title><xsl:value-of select="$pageTitle"/></title>
				
				<!-- Handlebars javascript library -->
				<script type="text/javascript" src="js/handlebars-v4.0.8.js"/>
				
				
				<!-- printing libraries -->
				<script type="text/javascript" src="user/js/saveSvgAsPng.js"/>
				
				<!-- d3 javascript library -->
				<script type="text/javascript" src="js/d3/d3.min.js"/>
				
				<style>
					/*
					 * Styles of the components of the tree
					 */
					#tree-container {
						position: relative;
						display: block;
						left: 0px;
						width: 100%;
					}
					
					.svgContainer {
						display: block;
					    margin: auto;
					    /*border: 1px dotted red; */
					}
					
					.node {
						cursor: pointer;
					}
					
					
					.node-rect-closed {
						stroke-width: 2px;
						stroke: rgb(0,0,0);
					}
					
					.link {
						fill: none;
						stroke: lightsteelblue;
						stroke-width: 2px;
					}
					
					.linkselected {
						fill: none;
						stroke: tomato;
						stroke-width: 2px;
					}
					
					.arrow {
						fill: lightsteelblue;
						stroke-width: 1px;
					}
					
					.arrowselected {
						fill: tomato;
						stroke-width: 2px;
					}
					
					.link text {
						font: 9px sans-serif;
						fill: #CC0000;
					}
					
					.wordwrap {
						white-space: pre-wrap; /* CSS3 */
						white-space: -moz-pre-wrap; /* Firefox */
						white-space: -pre-wrap; /* Opera &lt;7 */
						white-space: -o-pre-wrap; /* Opera 7 */
						word-wrap: break-word; /* IE */
					}
					
					.node-text {
						font: 10px sans-serif;
						color: white;
					}
					
					
					.tooltip-text-container {
					    height: 100%;
						width: 100%;
					}
					
					.tooltip-text {
						visibility: hidden;
						font: 7px sans-serif;
						color: white;
						display: block;
					 	padding: 5px;
					}
					
					.tooltip-box {
						background: rgba(0, 0, 0, 0.7);
						visibility: hidden;
						position: absolute;
						border-style: solid;
					    border-width: 1px;
					    border-color: black;
					    border-top-right-radius: 0.5em;
					}
					
					p {
						display: inline;
					}
					
					.textcolored {
						color: orange;
					}
					
					a.exchangeName {
						color: orange;
					}
					
					.node-rect {

					}
					
					.node-title {
						width: 100%;
						height: 30px;
						margin: 0px 0px 0px 0px;
					}
					
					.node-body-icon {
						width: 30%;
						height: 65px;
						float: left;
						color: #fff;
						font-family: FontAwesome;
						font-size: 3em;
						margin: 0px 0px 0px 0px;
						padding-left: 5px;
						padding-top: 0px;
						vertical-align: top;
					}
					
					.node-body {
						width: 70%;
						height: 65px;
						float: left;
						margin: 0px 0px 0px 0px;
					}
					
					.node-body-content {
						width: 100%;
						height: 40px;
						margin: 0px 0px 0px 0px;
						float: right;
					}
					
					.node-body-footer {
						width: 100%;
						height: 10px;
						margin: 0px 0px 0px 0px;
						float: right;
						text-align: right;
						font-size: 1em;
						padding-right: 3px;
					}
					
					.node-title-text {
						font-size: 14px;
						line-height: 1.1em;
						font-weight: bold;
						color: white;
					}
					
					.node-body-heading {
						font-size: 12px;
						font-weight: bold;
						color: white;
						margin-top: 10px;
					}
					
					.node-body-text {
						font-size: 10px;
						color: white;
						margin-top: 1px;
					}
					
					.node-title-text a {
						color: white;
					}
					
					.node-body-text a {
						color: white;
					}
					
					.legend-icon {
						width: 25px;
						height: 25px;
					}
					
					.png-icon {
						font-size: 1.5em;
					}
					
				</style>
			</head>
			<body>
				<!-- ADD VIEW SPECIFIC JAVASCRIPT -->
				<!-- Handlebars template to render an organisation node -->
				<script id="org-node-template" type="text/x-handlebars-template">
					<div class="node-rect wordwrap">
						<xsl:attribute name="style">{{nodeStyle}}</xsl:attribute>
						<div class="node-title node-title-text">
							<span class="node-title-text">{{{treeNode.treelink}}}</span>
						</div>
						<div class="node-body-icon">
							<i class="fa fa-building"/>
						</div>
						<div class="node-body">
							<div class="node-body-content">
								<div class="node-body-heading">Head of Department</div>
								<div class="node-body-text">{{#if treeNode.headOfDep}}{{{treeNode.headOfDep.treelink}}}{{else}}<em>Undefined</em>{{/if}}</div>
							</div>
						</div>
					</div>
				</script>
				
				<!-- Handlebars template to render an organisation node -->
				<script id="indiv-node-template" type="text/x-handlebars-template">
					<div class="node-rect wordwrap">
						<xsl:attribute name="style">{{nodeStyle}}</xsl:attribute>
						<div class="node-title node-title-text">
							<span class="node-title-text">{{{treeNode.treelink}}}</span>
						</div>
						<div class="node-body-icon">
							<span><i class="fa fa-user"/></span>
						</div>
						<div class="node-body">
							<div class="node-body-content">
								<div class="node-body-heading">Organisation</div>
								<div class="node-body-text">{{#if treeNode.parentOrg}}{{{treeNode.parentOrg.treelink}}}{{else}}<em>Undefined</em>{{/if}}</div>
							</div>
						</div>
					</div>
				</script>
				
				<script>
					var orgNodeTemplate, indivNodeTemplate;
					
					var blue = '#337ab7',
						green = '#5cb85c',
						yellow = '#f0ad4e',
						blueText = '#4ab1eb',
						purple = '#9467bd';
					
					var margin = {
						top : 0,
						right : 0,
						bottom : 100,
						left : 0
					 },
					 // Height and width are redefined later in function of the size of the tree
					// (after that the data are loaded)
					width = 5000 - margin.right - margin.left,
					height = 1000 - margin.top - margin.bottom;
					
					"use strict";
					
					var treeData = {
						"tree": <xsl:apply-templates mode="RenderOrg" select="$topLevelOrg"><xsl:with-param name="isRoot" select="true()"/></xsl:apply-templates>
					};
					
					<!--var treeData = {
						"tree" : {
							"nodeName" : "NODE NAME 1",
							"name" : "NODE NAME 1",
							"type" : "org",
							"mode": "closed",
							"code" : "N1",
							"color": yellow,
							"label" : "Node name 1",
							"version" : "v1.0",
							"link" : {
									"name" : "Link NODE NAME 1",
									"nodeName" : "NODE NAME 1",
									"direction" : "ASYN"
								},
							"children" : null,
							"hasReports": true,
							"reports" : [{
											"nodeName" : "Individual 1.1",
											"name" : "Individual 1.1",
											"type" : "indiv",
											"mode": "closed",
											"color": blue,
											"code" : "I1.1",
											"label" : "Individual 1.1",
											"version" : "v2.0",
											"link" : {
													"name" : "Link NODE NAME 1 to Individual 1.1",
													"nodeName" : "Individual 1.1",
													"direction" : "SYNC"
												},
											"children" : null,
											"subOrgs" : null
										}, 
										{
											"nodeName" : "Individual 1.2",
											"name" : "Individual 1.2",
											"type" : "indiv",
											"mode": "closed",
											"color": blue,
											"code" : "I1.2",
											"label" : "Individual 1.2",
											"version" : "v3.0",
											"link" : {
													"name" : "Link NODE NAME 1 to Individual 1.2",
													"nodeName" : "Individual 1.2",
													"direction" : "SYNC"
											},
											"children" : null,
											"hasReports": true,
											"reports" : [
												{
													"nodeName" : "Individual 1.2.1",
													"name" : "Individual 1.2.1",
													"type" : "indiv",
													"mode": "closed",
													"color": blue,
													"code" : "I1.1",
													"label" : "Individual 1.2.1",
													"version" : "v2.0",
													"link" : {
															"name" : "",
															"nodeName" : "",
															"direction" : "SYNC"
														},
													"children" : null,
													"subOrgs" : null
												}
											],
											"subOrgs" : null
										}
							],
							"hasSubOrgs": true,
							"subOrgs" : [{
									"nodeName" : "NODE NAME 2.1",
									"name" : "NODE NAME 2.1",
									"type" : "org",
									"mode": "closed",
									"color": green,
									"code" : "N2.1",
									"label" : "Node name 2.1",
									"version" : "v1.0",
									"link" : {
											"name" : "Link node 1 to 2.1",
											"nodeName" : "NODE NAME 2.1",
											"direction" : "SYNC"
										},
									"children" : null,
									"hasReports": true,
									"reports": [
										{
											"nodeName" : "Individual 2.1",
											"name" : "Individual 2.1",
											"type" : "indiv",
											"mode": "closed",
											"color": blue,
											"code" : "I1.1",
											"label" : "Individual 2.1",
											"version" : "v2.0",
											"link" : {
													"name" : "Link NODE NAME 1 to Individual 1.1",
													"nodeName" : "Individual 1.1",
													"direction" : "SYNC"
												},
											"children" : null,
											"subOrgs" : null
										}, 
										{
											"nodeName" : "Individual 2.2",
											"name" : "Individual 2.2",
											"type" : "indiv",
											"mode": "closed",
											"color": blue,
											"code" : "I2.2",
											"label" : "Individual 2.2",
											"version" : "v3.0",
											"link" : {
													"name" : "Link NODE NAME 1 to Individual 1.2",
													"nodeName" : "Individual 1.2",
													"direction" : "SYNC"
												},
											"children" : null,
											"subOrgs" : null
										}
									],
									"hasSubOrgs": true,
									"subOrgs" : [{
											"nodeName" : "NODE NAME 3.1",
											"name" : "NODE NAME 3.1",
											"type" : "org",
											"mode": "closed",
											"color": green,
											"code" : "N3.1",
											"label" : "Node name 3.1",
											"version" : "v1.0",
											"link" : {
													"name" : "Link node 2.1 to 3.1",
													"nodeName" : "NODE NAME 3.1",
													"direction" : "SYNC"
												},
											"children" : null,
											"subOrgs" : null
										}, {
											"nodeName" : "NODE NAME 3.2",
											"name" : "NODE NAME 3.2",
											"type" : "org",
											"mode": "closed",
											"color": green,
											"code" : "N3.2",
											"label" : "Node name 3.2",
											"version" : "v1.0",
											"link" : {
													"name" : "Link node 2.1 to 3.2",
													"nodeName" : "NODE NAME 3.1",
													"direction" : "SYNC"
												},
											"children" : null,
											"subOrgs" : null
										}
									]
								}, {
									"nodeName" : "NODE NAME 2.2",
									"name" : "NODE NAME 2.2",
									"type" : "org",
									"mode": "closed",
									"color": green,
									"code" : "N2.2",
									"label" : "Node name 2.2",
									"version" : "v1.0",
									"link" : {
											"name" : "Link node 1 to 2.2",
											"nodeName" : "NODE NAME 2.2",
											"direction" : "SYNC"
										},
									"children" : null,
									"subOrgs" : null
								}, {
									"nodeName" : "NODE NAME 2.3",
									"name" : "NODE NAME 2.3",
									"type" : "org",
									"mode": "closed",
									"color": green,
									"code" : "N2.3",
									"label" : "Node name 2.3",
									"version" : "v1.0",
									"link" : {
											"name" : "Link node 1 to 2.3",
											"nodeName" : "NODE NAME 2.3",
											"direction" : "SYNC"
										},
									"children" : null,
									"hasSubOrgs": true,
									"subOrgs" : [{
											"nodeName" : "NODE NAME 3.3",
											"name" : "NODE NAME 3.3",
											"type" : "org",
											"mode": "closed",
											"color": green,
											"code" : "N3.3",
											"label" : "Node name 3.3",
											"version" : "v1.0",
											"link" : {
													"name" : "Link node 2.3 to 3.3",
													"nodeName" : "NODE NAME 3.3",
													"direction" : "SYNC"
												},
											"children" : null,
											"hasSubOrgs": true,
											"subOrgs" : [{
													"nodeName" : "NODE NAME 4.1",
													"name" : "NODE NAME 4.1",
													"type" : "org",
													"mode": "closed",
													"color": green,
													"code" : "N4.1",
													"label" : "Node name 4.1",
													"version" : "v1.0",
													"link" : {
															"name" : "Link node 3.3 to 4.1",
															"nodeName" : "NODE NAME 4.1",
															"direction" : "SYNC"
														},
													"children" : null
												}
											]
										}, {
											"nodeName" : "NODE NAME 3.4",
											"name" : "NODE NAME 3.4",
											"type" : "org",
											"mode": "closed",
											"color": green,
											"code" : "N3.4",
											"label" : "Node name 3.4",
											"version" : "v1.0",
											"link" : {
													"name" : "Link node 2.3 to 3.4",
													"nodeName" : "NODE NAME 3.4",
													"direction" : "SYNC"
												},
											"children" : null,
											"hasSubOrgs": true,
											"subOrgs" : [{
													"nodeName" : "NODE NAME 4.2",
													"name" : "NODE NAME 4.2",
													"type" : "org",
													"mode": "closed",
													"color": green,
													"code" : "N4.2",
													"label" : "Node name 4.2",
													"version" : "v1.0",
													"link" : {
															"name" : "Link node 3.4 to 4.2",
															"nodeName" : "NODE NAME 4.1",
															"direction" : "SYNC"
														},
													"children" : null,
													"subOrgs" : null
												}
											]
										}
									]
								}
							]
						}
					}-->
					
					
					var baseSvg;
					
					var rectNode = { width : 200, height : 100, textMargin : 5 },
							tooltip = { width : 150, height : 40, textMargin : 5 };
					
					$(document).ready(function(){
						var orgNodeFragment   = $("#org-node-template").html();
						orgNodeTemplate = Handlebars.compile(orgNodeFragment);
						
						var indivNodeFragment   = $("#indiv-node-template").html();
						indivNodeTemplate = Handlebars.compile(indivNodeFragment);
						
						<!--$('#printStructureBtn').click(function (evt) {
							console.log('Clicked on Print Button');
							var innerContents = document.getElementById('tree-container').innerHtml;
							window.print(innerContents);
						});-->
						
						$("#printStructureBtn").on("click", function() {
						  	printSVG();
						});
						
						treeBoxes(treeData.tree);
					});
					
					
					function printSVG() {
						var currentTreeDepth = 0;
						var currentTreeWidth = breadthFirstTraversal(tree.nodes(root), function() {
							currentTreeDepth++;
						});
						
						var currentHeight = currentTreeWidth * (rectNode.height + 20) + tooltip.height + 20 - margin.right - margin.left;
						var currentWidth = currentTreeDepth * (rectNode.width * 1.5) + tooltip.width / 2 - margin.top - margin.bottom;
						console.log('Tree Height: ' + currentHeight + ', Tree Width: ' + currentWidth);
					
						var scaleFactor = 1;
						if(currentTreeWidth > 5) {
							scaleFactor = 0.5;
						};
						
						var customFonts = [
						  {
						    "text": "@font-face { font-family: FontAwesome; src: url(\"fonts/fontawesome-webfont.eot?#iefix&amp;v=4.7.0\") format(\"embedded-opentype\"), url(\"fonts/fontawesome-webfont.woff2?v=4.7.0\") format(\"woff2\"), url(\"fonts/fontawesome-webfont.woff?v=4.7.0\") format(\"woff\"), url(\"fonts/fontawesome-webfont.ttf?v=4.7.0\") format(\"truetype\"), url(\"fonts/fontawesome-webfont.svg?v=4.7.0#fontawesomeregular\") format(\"svg\"); font-weight: normal; font-style: normal; }",
						    "format": "application/vnd.ms-fontobject",
						    "url": "fonts/fontawesome-webfont.eot?#iefix&amp;v=4.7.0"
						  }
						];
						
						var printOptions = {
							left: -100,
							top: 0,
							height: currentHeight * 1.2,
							width: currentWidth + 100,
							scale: scaleFactor,
							fonts: customFonts
						};
						saveSvgAsPng(baseSvg.node(), "<xsl:value-of select="$topLevelOrg/own_slot_value[slot_reference = 'name']/value"/>.png", printOptions);
					}
					
					
					
					<!--function printSVG() {
						
						var theSvg = document.getElementById("baseSvg");
					
						//get svg source.
						var serializer = new XMLSerializer();
						var source = serializer.serializeToString(theSvg);
						
						//add name spaces.
						if(!source.match(/^&lt;svg[^>]+xmlns="http\:\/\/www\.w3\.org\/2000\/svg"/)){
						    source = source.replace(/^&lt;svg/, '&lt;svg xmlns="http://www.w3.org/2000/svg"');
						}
						if(!source.match(/^&lt;svg[^>]+"http\:\/\/www\.w3\.org\/1999\/xlink"/)){
						    source = source.replace(/^&lt;svg/, '&lt;svg xmlns:xlink="http://www.w3.org/1999/xlink"');
						}
						
						//add xml declaration
						source = '&lt;?xml version="1.0" standalone="no"?>\r\n' + source;
						
						//convert svg source to URI data scheme.
						var url = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(source);
						
						var link = document.createElement("a");
			            link.href = url;
			            link.style = "visibility:hidden";
			            link.download = "<xsl:value-of select="$topLevelOrg/own_slot_value[slot_reference = 'report_constant_ea_elements']/value"/>.xml";
			
			            document.body.appendChild(link);
			            link.click();
			            document.body.removeChild(link);
						
						//set url value to a element's href attribute.
						document.getElementById("link").href = url;
					}-->
					
					var tree, root;
					
					// Breadth-first traversal of the tree
					// func function is processed on every node of a same level
					// return the max level
					  function breadthFirstTraversal(tree, func)
					  {
						  var max = 0;
						  if (tree &amp;&amp; tree.length > 0)
						  {
							  var currentDepth = tree[0].depth;
							  var fifo = [];
							  var currentLevel = [];
					
							  fifo.push(tree[0]);
							  while (fifo.length > 0) {
								  var node = fifo.shift();
								  if (node.depth > currentDepth) {
									  func(currentLevel);
									  currentDepth++;
									  max = Math.max(max, currentLevel.length);
									  currentLevel = [];
								  }
								  currentLevel.push(node);
								  if (node.children) {
									  for (var j = 0; j &lt; node.children.length; j++) {
										  fifo.push(node.children[j]);
									  }
								  }
						  	}
							func(currentLevel);
							console.log('Max Width: ' + Math.max(max, currentLevel.length));
							return Math.max(max, currentLevel.length);
						}
						return 0;
					  }
					
					function treeBoxes(jsonData)
					{		
						var i = 0,
							duration = 750;
							
						var nodeStyle = 'width: ' + (rectNode.width - rectNode.textMargin * 2) + 'px; height: ' + (rectNode.height - rectNode.textMargin * 2) + 'px;';
						
						var mousedown; // Use to save temporarily 'mousedown.zoom' value
						var mouseWheel,
							mouseWheelName,
							isKeydownZoom = false;
						
						var svgGroup,
							nodeGroup, // If nodes are not grouped together, after a click the svg node will be set after his corresponding tooltip and will hide it
							nodeGroupTooltip,
							linkGroup,
							linkGroupToolTip,
							defs;	
					
						drawTree(jsonData);
					
						function drawTree(jsonData)
						{
							tree = d3.layout.tree().size([ height, width ]);
							root = jsonData;
							root.fixed = true;
							
							// Dynamically set the height of the main svg container
							// breadthFirstTraversal returns the max number of node on a same level
							// and colors the nodes
							var maxDepth = 0;
							var maxTreeWidth = breadthFirstTraversal(tree.nodes(root), function(currentLevel) {
								maxDepth++;
							});
							//height = maxTreeWidth * (rectNode.height + 20) + tooltip.height + 20 - margin.right - margin.left;
							width = maxDepth * (rectNode.width * 1.5) + tooltip.width / 2 - margin.top - margin.bottom;
						
							tree = d3.layout.tree().size([ height, width ]);
							root.x0 = height / 2;
							root.y0 = 0;
						
							baseSvg = d3.select('#tree-container').append('svg')
						    //.attr('width', width + margin.right + margin.left)
						    .attr('id', 'baseSvg')
						    .attr('width', 3000)
							.attr('height', 6000)
							.attr('class', 'svgContainer')
							.call(d3.behavior.zoom()
							      //.scaleExtent([0.5, 1.5]) // Limit the zoom scale
							      .on('zoom', zoomAndDrag));
						
							// Mouse wheel is desactivated, else after a first drag of the tree, wheel event drags the tree (instead of scrolling the window)
							getMouseWheelEvent();
							d3.select('#tree-container').select('svg').on(mouseWheelName, null);
							d3.select('#tree-container').select('svg').on('dblclick.zoom', null);
							
							svgGroup = baseSvg.append('g')
							.attr('class','drawarea')
							.append('g')
							.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');
						
							// SVG elements under nodeGroupTooltip could be associated with nodeGroup,
							// same for linkGroupToolTip and linkGroup,
							// but this separation allows to manage the order on which elements are drew
							// and so tooltips are always on top.
							nodeGroup = svgGroup.append('g')
										.attr('id', 'nodes');
							linkGroup = svgGroup.append('g')
										.attr('id', 'links');
							linkGroupToolTip = svgGroup.append('g')
								   				.attr('id', 'linksTooltips');
							nodeGroupTooltip = svgGroup.append('g')
								   				.attr('id', 'nodesTooltips');
							
							defs = baseSvg.append('defs');
							initArrowDef();
							initDropShadow();
							
							update(root);
						}
					
						function update(source)
						{
							// Compute the new tree layout
							var nodes = tree.nodes(root).reverse(),
								links = tree.links(nodes);
						
							// Check if two nodes are in collision on the ordinates axe and move them
							breadthFirstTraversal(tree.nodes(root), collision);
							// Normalize for fixed-depth
							nodes.forEach(function(d) {
								d.y = d.depth * (rectNode.width * 1.5);
							});
						
						// 1) ******************* Update the nodes *******************
							var node = nodeGroup.selectAll('g.node').data(nodes, function(d) {
								return d.id || (d.id = ++i);
							});
							var nodesTooltip = nodeGroupTooltip.selectAll('g').data(nodes, function(d) {
								return d.id || (d.id = ++i);
							});
						
							// Enter any new nodes at the parent's previous position
							// We use "insert" rather than "append", so when a new child node is added (after a click)
							// it is added at the top of the group, so it is drawed first
							// else the nodes tooltips are drawed before their children nodes and they
							// hide them
							
							var timeout = null;
							var nodeEnter = node.enter().insert('g', 'g.node')
								.attr('class', 'node')
								.attr('transform', function(d) {
								  return 'translate(' + source.y0 + ',' + source.x0 + ')';
								 });
								  
							var nodeEnterTooltip = nodesTooltip.enter().append('g')
								.attr('transform', function(d) {
									  return 'translate(' + source.y0 + ',' + source.x0 + ')';
								});
						
							nodeEnterGroup = nodeEnter.append('g');
								
							nodeEnterGroup
								.append('rect')
									.attr('rx', 6)
									.attr('ry', 6)
									.attr('width', rectNode.width)
									.attr('height', rectNode.height)
									.attr('class', 'node-rect')
									.attr('fill', function (d) { return d.color; })
									.attr('filter', 'url(#drop-shadow)');
									
						
							nodeEnter.append('foreignObject')
							.attr('x', rectNode.textMargin)
							.attr('y', rectNode.textMargin)
							.attr('width', function() {
										return (rectNode.width - rectNode.textMargin * 2) &lt; 0 ? 0
												: (rectNode.width - rectNode.textMargin * 2)
									})
							.attr('height', function() {
										return (rectNode.height - rectNode.textMargin * 2) &lt; 0 ? 0
												: (rectNode.height - rectNode.textMargin * 2)
									})
							.append('xhtml').html(function(d) {
									if(d.type == 'org') {
										var nodeDetails = {
											treeNode: d,
											nodeStyle: nodeStyle
										};
										return orgNodeTemplate(nodeDetails);
									} else if(d.type == 'indiv') {
										var nodeDetails = {
											treeNode: d,
											nodeStyle: nodeStyle
										};
										return indivNodeTemplate(nodeDetails);
									}			
							 });
							 
							 
							 nodeEnter
								.append('image')
									.attr('x', rectNode.width - 55)
									.attr('y', rectNode.height - 26)
									.attr('width', 25)
									.attr('height', 25)
									.attr('xlink:href',  function(d) {
										if(d.hasSubOrgs) {
											return 'user/images/hierarchy-white-icon.png';
										} else {
										 	return ""
										}
									})
									.on('click', function(d) {
										if(d.hasSubOrgs) {
											click(d);
										}
									});
									
							nodeEnter
								.append('image')
									.attr('x', rectNode.width - 25)
									.attr('y', rectNode.height - 26)
									.attr('width', 25)
									.attr('height', 25)
									.attr('xlink:href',  function(d) {
										if(d.hasReports) {
											return 'user/images/poeple-white-icon.png';
										} else {
										 	return ""
										}
									})
									.on('click', function(d) {
										if(d.hasReports) {
											doubleClick(d);
										}
									});

					
							// Transition nodes to their new position.
							var nodeUpdate = node.transition().duration(duration)
							.attr('transform', function(d) { return 'translate(' + d.y + ',' + d.x + ')'; });
					
							nodeUpdate.select('rect')
							.attr('class', function(d) { return (d.mode == 'closed') &amp;&amp; (d.hasSubOrgs || d.hasReports) ? 'node-rect-closed' : 'node-rect'; });
					
							nodeUpdate.select('text').style('fill-opacity', 1);
					
							// Transition exiting nodes to the parent's new position
							var nodeExit = node.exit().transition().duration(duration)
								.attr('transform', function(d) { return 'translate(' + source.y + ',' + source.x + ')'; })
								.remove();
					
							nodeExit.select('text').style('fill-opacity', 1e-6);
					
					
						// 2) ******************* Update the links *******************
							var link = linkGroup.selectAll('path').data(links, function(d) {
								return d.target.id;
							});

							function linkMarkerStart(direction, isSelected) {
								if (direction == 'SYNC')
								{
									return isSelected ? 'url(#start-arrow-selected)' : 'url(#start-arrow)';
								}
								return '';
							}
					
							function linkType(link) {
								if (link.direction == 'SYNC')
									return "Synchronous [\u2194]";
								else
								{
									if (link.direction == 'ASYN')
										return "Asynchronous [\u2192]";
								}
								return '???';
							}
							
							d3.selection.prototype.moveToFront = function() {
								  return this.each(function(){
									    this.parentNode.appendChild(this);
									  });
								};
					
							// Enter any new links at the parent's previous position.
								// Enter any new links at the parent's previous position.
								var linkenter = link.enter().insert('path', 'g')
								.attr('class', 'link')
								.attr('id', function(d) { return 'linkID' + d.target.id; })
								.attr('d', function(d) { return diagonal(d); })
								.attr('marker-end', 'url(#end-arrow)')
								.attr('marker-start', function(d) { return linkMarkerStart(d.target.link.direction, false);});
					
					
							// Transition links to their new position.
							var linkUpdate = link.transition().duration(duration)
											 	 .attr('d', function(d) { return diagonal(d); });
						
							// Transition exiting nodes to the parent's new position.
							link.exit().transition()
							.remove();
							

						
							// Stash the old positions for transition.
							nodes.forEach(function(d) {
								d.x0 = d.x;
								d.y0 = d.y;
							});
						}
						
						// Zoom functionnality is desactivated (user can use browser Ctrl + mouse wheel shortcut)
						function zoomAndDrag() {
						    //var scale = d3.event.scale,
						    var scale = 1,
						        translation = d3.event.translate,
						        tbound = -height * scale,
						        bbound = height * scale,
						        lbound = (-width + margin.right) * scale,
						        rbound = (width - margin.left) * scale;
						    // limit translation to thresholds
						    translation = [
						        Math.max(Math.min(translation[0], rbound), lbound),
						        Math.max(Math.min(translation[1], bbound), tbound)
						    ];
						    d3.select('.drawarea')
						        .attr('transform', 'translate(' + translation + ')' +
						              ' scale(' + scale + ')');
						}
						
						// Toggle children on click.
						function click(d) {
							if(d.type == 'org') {
								console.log('clicked on ' + d.name);
								switch(d.mode) {
								    case 'closed':
								        if (d.subOrgs) {
								        	d.children = d.subOrgs;
								        	d.mode = 'org';
									    	update(d);						
								        };
								        break;
								    case 'org':
								        d.children = null;
								        d.mode = 'closed';
								        update(d);								   
								        break;
								    case 'report':
								    	if (d.subOrgs) {
									    	d.children = null;
									        update(d);
									        setTimeout(function() {
											    d.children = d.subOrgs;
											    d.mode = 'org';
											    update(d);											    
											}, 
											1000); 
									    }
									    break;
								}
							}
							/* if (d.subOrgs) {
								if (d.children) {
									//d._children = d.children;
									d.children = null;
									update(d);
								    setTimeout(function() {
									    d.children = d.subOrgs;
									    update(d);
									}, 
									1000); 
								} else {
									d.children = d.subOrgs;
									update(d);
									//d._children = null;
								}
							} else {
								d.children = null;
								update(d);
							} */
						}
						
						
						// Toggle children on double click.
						function doubleClick(d) {
							if(d.type == 'org') {
								console.log('double clicked on ' + d.name);
								switch(d.mode) {
								    case 'closed':
								        if (d.reports) {
								        	d.children = d.reports;
								        	d.mode = 'report';
									    	update(d);
								        };
								        break;
								    case 'org':
								        if (d.reports) {
									    	d.children = null;
									        update(d);
									        setTimeout(function() {
											    d.children = d.reports;
											    d.mode = 'report';
											    update(d);
											}, 
											1000); 
									    };
									    break;
								    case 'report':
								    	d.children = null;
								    	d.mode = 'closed';
									    update(d);
									    break;
								}
							} else if(d.type == 'indiv') {
								switch(d.mode) {
								    case 'closed':
								        if (d.reports) {
								        	d.children = d.reports;
								        	d.mode = 'report';
									    	update(d);
								        };
								        break;
								    case 'report':
								    	d.children = null;
								    	d.mode = 'closed';
									    update(d);
									    break;
								}
							}
							
							function closedNodeHasChildren(d) {
								return (d.mode == 'closed') &amp;&amp; (d.hasSubOrgs || d.hasReports);
							}
						
						
							/* if (d.reports) {
								if (d.children) {
									click(d);
									setTimeout(function() {
									    d.children = d.reports;
									    update(d);
									}, 
									1000);
								} else {
									d.children = d.reports;
									update(d);
								}
							} */
						}
						
						
						
						// x = ordoninates and y = abscissas
						function collision(siblings) {
						  var minPadding = 5;
						  if (siblings) {
							  for (var i = 0; i &lt; siblings.length - 1; i++)
							  {
								  if (siblings[i + 1].x - (siblings[i].x + rectNode.height) &lt; minPadding)
									  siblings[i + 1].x = siblings[i].x + rectNode.height + minPadding;
							  }
						  }
						}
						
						function removeMouseEvents() {
							// Drag and zoom behaviors are temporarily disabled, so tooltip text can be selected
							//mousedown = d3.select('#tree-container').select('svg').on('mousedown.zoom');
							//d3.select('#tree-container').select('svg').on("mousedown.zoom", null);
						}
						
						function reactivateMouseEvents() {
							// Reactivate the drag and zoom behaviors
							d3.select('#tree-container').select('svg').on('mousedown.zoom', mousedown);
						}
						
						// Name of the event depends of the browser
						function getMouseWheelEvent() {
							if (d3.select('#tree-container').select('svg').on('wheel.zoom'))
							{
								mouseWheelName = 'wheel.zoom';
								return d3.select('#tree-container').select('svg').on('wheel.zoom');
							}
							if (d3.select('#tree-container').select('svg').on('mousewheel.zoom') != null)
							{
								mouseWheelName = 'mousewheel.zoom';
								return d3.select('#tree-container').select('svg').on('mousewheel.zoom');
							}
							if (d3.select('#tree-container').select('svg').on('DOMMouseScroll.zoom'))
							{
								mouseWheelName = 'DOMMouseScroll.zoom';
								return d3.select('#tree-container').select('svg').on('DOMMouseScroll.zoom');
							}
						}
						
						function diagonal(d) {
							var p0 = {
								x : d.source.x + rectNode.height / 2,
								y : (d.source.y + rectNode.width)
							}, p3 = {
								x : d.target.x + rectNode.height / 2,
								y : d.target.y  - 12 // -12, so the end arrows are just before the rect node
							}, m = (p0.y + p3.y) / 2, p = [ p0, {
								x : p0.x,
								y : m
							}, {
								x : p3.x,
								y : m
							}, p3 ];
							p = p.map(function(d) {
								return [ d.y, d.x ];
							});
							return 'M' + p[0] + 'C' + p[1] + ' ' + p[2] + ' ' + p[3];
						}
						
						function initDropShadow() {
							var filter = defs.append("filter")
							    .attr("id", "drop-shadow")
							    .attr("color-interpolation-filters", "sRGB");
							
							filter.append("feOffset")
							.attr("result", "offOut")
							.attr("in", "SourceGraphic")
						    .attr("dx", 0)
						    .attr("dy", 0);
						
							filter.append("feGaussianBlur")
							    .attr("stdDeviation", 2);
						
							filter.append("feOffset")
							    .attr("dx", 2)
							    .attr("dy", 2)
							    .attr("result", "shadow");
						
							filter.append("feComposite")
						    .attr("in", 'offOut')
						    .attr("in2", 'shadow')
						    .attr("operator", "over");
						}
						
						function initArrowDef() {
							// Build the arrows definitions
							// End arrow
							defs.append('marker')
							.attr('id', 'end-arrow')
							.attr('viewBox', '0 -5 10 10')
							.attr('refX', 0)
							.attr('refY', 0)
							.attr('markerWidth', 6)
							.attr('markerHeight', 6)
							.attr('orient', 'auto')
							.attr('class', 'arrow')
							.append('path')
							.attr('d', 'M0,-5L10,0L0,5');
							
							// End arrow selected
							defs.append('marker')
							.attr('id', 'end-arrow-selected')
							.attr('viewBox', '0 -5 10 10')
							.attr('refX', 0)
							.attr('refY', 0)
							.attr('markerWidth', 6)
							.attr('markerHeight', 6)
							.attr('orient', 'auto')
							.attr('class', 'arrowselected')
							.append('path')
							.attr('d', 'M0,-5L10,0L0,5');
						
							// Start arrow
							defs.append('marker')
							.attr('id', 'start-arrow')
							.attr('viewBox', '0 -5 10 10')
							.attr('refX', 0)
							.attr('refY', 0)
							.attr('markerWidth', 6)
							.attr('markerHeight', 6)
							.attr('orient', 'auto')
							.attr('class', 'arrow')
							.append('path')
							.attr('d', 'M10,-5L0,0L10,5');
							
							// Start arrow selected
							defs.append('marker')
							.attr('id', 'start-arrow-selected')
							.attr('viewBox', '0 -5 10 10')
							.attr('refX', 0)
							.attr('refY', 0)
							.attr('markerWidth', 6)
							.attr('markerHeight', 6)
							.attr('orient', 'auto')
							.attr('class', 'arrowselected')
							.append('path')
							.attr('d', 'M10,-5L0,0L10,5');
						}
					}
					
				</script>
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="$pageTitle"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<button type="button" class="btn btn-primary pull-right" id="printStructureBtn"><i class="png-icon fa fa-image right-10"/>Save as PNG</button>
							<h2 class="text-primary"><xsl:value-of select="eas:i18n('Organisation Structure')"/></h2>
							<div class="content-section">
								<p class="small pull-left">
									<span class="right-30"><strong>Legend:</strong></span>
									<img class="legend-icon right-10" src="user/images/hierarchy-black-icon.png"/>Click to open/close Organisation Structure<img class="left-30 legend-icon right-10" src="user/images/people-black-icon.png"/>Click to open/close Reporting Structure
								</p>
								<div class="pull-right">
									
								</div>
								<div id="tree-container"/>
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
	
	
	<xsl:template mode="RenderOrg" match="node()">
		<xsl:param name="isRoot" select="false()"/>
		<xsl:param name="thisDepth" select="0"/>
		
		<xsl:if test="$thisDepth &lt; $maxDepth">
			<xsl:variable name="thisOrg" select="current()"/>
			<xsl:variable name="thisOrgId" select="$thisOrg/name"/>
			
			<!-- Get all individuals that are members of the org -->
			<xsl:variable name="orgIndivActors" select="$allIndivActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $thisOrg/name]"/>
			
			
			<xsl:variable name="orgHeadofDeps" select="$allHeadofDeps[name = $orgIndivActors/name]"/>
			<xsl:variable name="orgHeadofDepsCount" select="count($orgHeadofDeps)"/>
			
			<xsl:variable name="orgDirectReportRels" select="$allDirectReportingRels[own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $orgHeadofDeps/name]"/>
			<xsl:variable name="orgDirectReports" select="$allIndivActors[name = $orgDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
			
			<!-- Get all org members that do are not defined as reporting to any other individual -->
			<xsl:variable name="noReportOrgIndivActors" select="$orgIndivActors[not(name = $allDirectReportingRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value)]"/>
			
			<!-- Set all direct reports to the direct reports to the Head of Deprtment and those that are not defined as reporting to any other individual -->
			<xsl:variable name="allOrgDirectReports" select="($orgDirectReports union $noReportOrgIndivActors) except $orgHeadofDeps"/>
			
			<xsl:variable name="orgSubOrgs" select="$allGroupActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $thisOrg/name]"/>
			
			{
				"nodeName" : "<xsl:value-of select="$thisOrgId"/>",
				"name" : "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisOrg"/></xsl:call-template>",
				"treelink" : "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisOrg"/></xsl:call-template>",
				"type" : "org",
				"mode": "closed",
				"color": <xsl:choose><xsl:when test="$isRoot">purple</xsl:when><xsl:otherwise>green</xsl:otherwise></xsl:choose>,
				<xsl:choose>
					<xsl:when test="$orgHeadofDepsCount > 0">
						"headOfDep" : {
							"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$orgHeadofDeps[1]"/></xsl:call-template>",
							"treelink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$orgHeadofDeps[1]"/></xsl:call-template>",
						},
					</xsl:when>
					<xsl:otherwise>
						"headOfDep" : null,
					</xsl:otherwise>
				</xsl:choose>
				"link" : {
					"name" : "",
					"nodeName" : "",
					"direction" : "SYNC"
				},
				"children" : [],
				"hasReports": <xsl:choose><xsl:when test="count($allOrgDirectReports) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
				"reports": <xsl:choose><xsl:when test="count($allOrgDirectReports) > 0">[
					<xsl:apply-templates mode="RenderIndividual" select="$allOrgDirectReports"><xsl:with-param name="contextId" select="$thisOrgId"/><xsl:with-param name="thisDepth" select="$thisDepth + 1"/></xsl:apply-templates>
				]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
				"hasSubOrgs": <xsl:choose><xsl:when test="count($orgSubOrgs) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
				"subOrgs" : <xsl:choose><xsl:when test="count($orgSubOrgs) > 0">[
					<xsl:apply-templates mode="RenderOrg" select="$orgSubOrgs"><xsl:with-param name="thisDepth" select="$thisDepth + 1"/></xsl:apply-templates>
				]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
			}<xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RenderIndividual" match="node()">
		<xsl:param name="contextId"/>
		<xsl:param name="thisDepth" select="0"/>
		
		<xsl:if test="$thisDepth &lt; $maxDepth">
			<xsl:variable name="thisIndiv" select="current()"/>
			<xsl:variable name="thisIndivId" select="$thisIndiv/name"/>
			
			<xsl:variable name="thisIndivOrg" select="$allGroupActors[name = $thisIndiv/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
			
			<xsl:variable name="thisIndiv2Jobs" select="$allActor2Jobs[own_slot_value[slot_reference = 'actor_to_job_from_actor']/value = $thisIndiv/name]" />
			<xsl:variable name="thisIndivJobs" select="$allJobs[name = $thisIndiv2Jobs/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]" />
			
			<xsl:variable name="indivDirectReportRels" select="$allDirectReportingRels[own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $thisIndiv/name]"/>
			<xsl:variable name="indivDirectReports" select="$allIndivActors[name = $indivDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
			
			{
				"nodeName" : "<xsl:value-of select="$contextId"/><xsl:value-of select="$thisIndivId"/>",
				"name" : "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisIndiv"/></xsl:call-template>",
				"treelink" : "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisIndiv"/></xsl:call-template>",
				"type" : "indiv",
				"mode": "closed",
				"color": blue,
				<xsl:choose>
					<xsl:when test="count($thisIndivOrg) > 0">
						"parentOrg" : {
						"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisIndivOrg[1]"/></xsl:call-template>",
						"treelink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisIndivOrg[1]"/></xsl:call-template>",
						},
					</xsl:when>
					<xsl:otherwise>
						"parentOrg" : null,
					</xsl:otherwise>
				</xsl:choose>
				"jobTitle": <xsl:choose><xsl:when test="count($thisIndivJobs) > 0">"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisIndivJobs[1]"/></xsl:call-template>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
				"link" : {
					"name" : "",
					"nodeName" : "",
					"direction" : "SYNC"
				},
				"children" : [],
				"hasReports": <xsl:choose><xsl:when test="count($indivDirectReports) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
				"reports": <xsl:choose><xsl:when test="count($indivDirectReports) > 0">[
					<xsl:apply-templates mode="RenderIndividual" select="$indivDirectReports"><xsl:with-param name="contextId" select="$contextId"/><xsl:with-param name="thisDepth" select="$thisDepth + 1"/></xsl:apply-templates>
				]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
			}<xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:if>
		
	</xsl:template>

</xsl:stylesheet>
