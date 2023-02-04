<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
<xsl:import href="../common/core_strategic_plans.xsl"/>
<xsl:import href="../common/core_utilities.xsl"/>
<xsl:include href="../common/core_doctype.xsl"/>
<xsl:include href="../common/core_common_head_content.xsl"/>
<xsl:include href="../common/core_header.xsl"/>
<xsl:include href="../common/core_footer.xsl"/>
<xsl:include href="../common/core_external_doc_ref.xsl"/>
<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Business_Process', 'Application_Provider', 'Site', 'Group_Actor', 'Technology_Component')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"/>
	<xsl:variable name="physProcAppsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
  
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<!-- START VIEW SPECIFIC SETUP VARIABES -->
	<xsl:variable name="products" select="/node()/simple_instance[type='Product']"/>
	<xsl:variable name="productType" select="/node()/simple_instance[type='Product_Type']"/>
	
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
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiPath">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$anAPIReport"/>
				</xsl:call-template>
			</xsl:variable>
		<xsl:variable name="appPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ppPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$physProcAppsData"/>
			</xsl:call-template>
		</xsl:variable>		
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="eas:i18n('Summary')"/></title>
				<link href="js/bootstrap-vertical-tabs/bootstrap.vertical-tabs.min.css" type="text/css" rel="stylesheet"></link>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"></link>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"></script>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js" type="text/javascript"></script>

				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css"/>

				<style type="text/css">
				.thead input {
					width: 100%;
					}
					.ess-blob{
						margin: 0 15px 15px 0;
						border: 1px solid #ccc;
						height: 40px;
						width: 140px;
						border-radius: 4px;
						display: table;
						position: relative;
						text-align: center;
						float: left;
					}

					.orgName{
						font-size:2.4em;
						padding-top:30px;
						text-align:center;
					}

					.ess-blobLabel{
						display: table-cell;
						vertical-align: middle;
						line-height: 1.1em;
						font-size: 90%;
					}
					
					.infoButton > a{
						position: absolute;
						bottom: 0px;
						right: 3px;
						color: #aaa;
						font-size: 90%;
					}
					
					.dataTables_filter label{
						display: inline-block!important;
					}
					
					#summary-content label{
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
					}
					
					#summary-content h3{
						font-weight: 600;
					}
					
					.ess-tag{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						font-size: 90%;
					}
					
					.map{
						width: 100%;
						height: 400px;
						min-width: 450px;
						min-height: 400px;
					}
					
					.dashboardPanel{
						padding: 10px 15px;
						border: 1px solid #ddd;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						width: 100%;
					}
					
					.parent-superflex{
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					
					.superflex{
						border: 1px solid #ddd;
						padding: 10px;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						flex-grow: 1;
						flex-basis: 1;
					}
					
					.ess-list-tags{
						padding: 0;
					}
					
					.ess-string{
						background-color: #f6f6f6;
						padding: 5px;
						display: inline-block;
					}
					
					.ess-doc-link{
						padding: 3px 8px;
						border: 1px solid #6dadda;
						border-radius: 4px;
						margin-right: 10px;
						margin-bottom: 10px;
						display: inline-block;
						font-weight: 700;
						background-color: #fff;
						font-size: 85%;
					}
					
					.ess-doc-link:hover{
						opacity: 0.65;
					}
					
					.ess-list-tags li{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						background-color: #eee;
						font-size: 85%;
					}
					
					.ess-mini-badge {
						display: inline-block!important;
						padding: 2px 5px;
						border-radius: 4px;
					}
					
					@media (min-width : 1220px) and (max-width : 1720px){
						.ess-column-split > div{
							width: 450px;
							float: left;
						}
					}
					
					
					.bdr-left-blue{
						border-left: 2pt solid #5b7dff !important;
					}
					
					.bdr-left-indigo{
						border-left: 2pt solid #6610f2 !important;
					}
					
					.bdr-left-purple{
						border-left: 2pt solid #6f42c1 !important;
					}
					
					.bdr-left-pink{
						border-left: 2pt solid #a180da !important;
					}
					
					.bdr-left-red{
						border-left: 2pt solid #f44455 !important;
					}
					
					.bdr-left-orange{
						border-left: 2pt solid #fd7e14 !important;
					}
					
					.bdr-left-yellow{
						border-left: 2pt solid #fcc100 !important;
					}
					
					.bdr-left-green{
						border-left: 2pt solid #5fc27e !important;
					}
					
					.bdr-left-teal{
						border-left: 2pt solid #20c997 !important;
					}
					
					.bdr-left-cyan{
						border-left: 2pt solid #47bac1 !important;
					}
					
					@media print {
						#summary-content .tab-content > .tab-pane {
						    display: block !important;
						    visibility: visible !important;
						}
						
						#summary-content .no-print {
						    display: none !important;
						    visibility: hidden !important;
						}
						
						#summary-content .tab-pane {
							page-break-after: always;
						}
					}
					
					@media screen {						
						#summary-content .print-only {
						    display: none !important;
						    visibility: hidden !important;
						}
					}
					.stat{
						border:1pt solid #d3d3d3;
						border-radius:4px;
						margin:5px;
						padding:3px;
					}
					.lbl-large{    
						font-size: 200%;
						border-radius: 5px;
						margin-right: 10%;
						margin-left: 10%;
						text-align: center;
						/* display: inline-block; */
						/* width: 60px; */
						box-shadow: 2px 2px 2px #d3d3d3;
					}
					.lbl-big{
						font-size: 150%;
					}
					.roleBlob{
						background-color: rgb(68, 182, 179)
					}
				</style>
				<script>
					
					function initDataStoredMap(){
						$('#mapDataStored-parent').append('<div id="mapDataStored" class="map"></div>');
						mapDataStored = $('#mapDataStored').vectorMap(
							{
								map: 'world_mill',
                                zoomOnScroll: false,
								backgroundColor: 'transparent',
								hoverOpacity: 0.7,
								hoverColor: false,
								regionStyle: {
								    initial: {
									    fill: '#ccc',
									    "fill-opacity": 1,
									    stroke: 'none',
									    "stroke-width": 0,
									    "stroke-opacity": 1
								    }
							    },
							    markerStyle: {
							    	initial: {
								        fill: 'yellow',
								        stroke: 'black',
							        }
							    },
							    series: {
								    regions: [{
								    	values: {'US':'hsla(220, 70%, 40%, 1)', 'FR': 'hsla(220, 70%, 40%, 1)'},
								    	attribute: 'fill'
								    }]
								},
							}
						);
					}
					
					function initSupportMap(){
						$('#mapSupport-parent').append('<div id="mapSupport" class="map"></div>');
						mapSupport = $('#mapSupport').vectorMap(
							{
								map: 'world_mill',
                                zoomOnScroll: false,
								backgroundColor: 'transparent',
								hoverOpacity: 0.7,
								hoverColor: false,
								regionStyle: {
								    initial: {
									    fill: '#ccc',
									    "fill-opacity": 1,
									    stroke: 'none',
									    "stroke-width": 0,
									    "stroke-opacity": 1
								    }
							    },
							    markerStyle: {
							    	initial: {
								        fill: 'yellow',
								        stroke: 'black',
							        }
							    },
							    series: {
								    regions: [{
								    	values: {'IN':'hsla(320, 75%, 50%, 1)', 'GB': 'hsla(320, 75%, 50%, 1)'},
								    	attribute: 'fill'
								    }]
								}
							}
						);
					}
					
				

					
					$(document).ready(function(){
						
						
						$('a[href="#residency"]').on('shown.bs.tab', function (e) {
							initDataStoredMap();
							initSupportMap();
						});
						$('a[href="#residency"]').on('hidden.bs.tab', function (e) {
							mapDataStored.remove();
							mapSupport.remove();
						});
					});
				</script>
				<script src='https://d3js.org/d3.v5.min.js'></script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>

				<!--ADD THE CONTENT-->
			<span id="mainPanel"/>
			
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
				<script>
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
					<xsl:with-param name="viewerAPIPathApp" select="$appPath"/>
					<xsl:with-param name="viewerAPIPathPP" select="$ppPath"/>
				</xsl:call-template>
				</script>


				<script id="rendered-js">
  	  
			  function Chart() {
			<!--	Org chart Copyright 2021 David Bumbeishvili  see https://bl.ocks.org/bumbeishvili/09a03b81ae788d2d14f750afe59eb7de
			Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

			The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

			THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
			-->
				  // Exposed variables
				  var attrs = {
					  id: 'ID' + Math.floor(Math.random() * 1000000), // Id for event handlings
					  svgWidth: 800, 
					  svgHeight: 600,
					  marginTop: 0,
					  marginBottom: 0,
					  marginRight: 0,
					  marginLeft: 0,
					  container: '.chart-container',
					  defaultTextFill: '#2C3E50',
					  nodeTextFill:'white',
					  defaultFont: 'Helvetica',
					  backgroundColor: '#fafafa',
					  data: null,
					  depth: 180,
					  duration: 600,
					  strokeWidth: 3,
					  dropShadowId: null,
					  initialZoom:1,
					  onNodeClick:d=>d
				  };
				 
				  //InnerFunctions which will update visuals
				  var updateData;
			  
				  //Main chart object
				  var main = function() {
					  //Drawing containers
					  
					  var container = d3.select('.chart-container');

					  var containerRect = container.node().getBoundingClientRect();
					  if (containerRect.width > 0) attrs.svgWidth = containerRect.width;
			  
					  setDropShadowId(attrs);
			  
					  //Calculated properties
					  var calc = {
						  id: null,
						  chartTopMargin: null,
						  chartLeftMargin: null,
						  chartWidth: null,
						  chartHeight: null
					  };
					  calc.id = 'ID' + Math.floor(Math.random() * 1000000); // id for event handlings
					  calc.chartLeftMargin = attrs.marginLeft;
					  calc.chartTopMargin = attrs.marginTop;
					  calc.chartWidth = attrs.svgWidth - attrs.marginRight - calc.chartLeftMargin;
					  calc.chartHeight = attrs.svgHeight - attrs.marginBottom - calc.chartTopMargin;
					  calc.nodeMaxWidth = d3.max(attrs.data, d => d.width);
					  calc.nodeMaxHeight = d3.max(attrs.data, d => d.height);
			  
					  attrs.depth = calc.nodeMaxHeight + 100;
			  
					  calc.centerX = calc.chartWidth / 2;
			  
					  //********************  LAYOUTS  ***********************
					  const layouts = {
						  treemap: null
					  }
			  
					  layouts.treemap = d3.tree().size([calc.chartWidth, calc.chartHeight])
						  .nodeSize([calc.nodeMaxWidth + 100, calc.nodeMaxHeight + attrs.depth])
			  
					  // ******************* BEHAVIORS . **********************
					  const behaviors = {
						  zoom: null
					  }
			  
					  behaviors.zoom = d3.zoom().on("zoom", zoomed)
					
					  
						
			  
					  //****************** ROOT node work ************************
					  const root = d3.stratify()
						  .id(function(d) {
							  return d.nodeId;
						  })
						  .parentId(function(d) {
							  return d.parentNodeId;
						  })
						  (attrs.data)
			  
					  root.x0 = 0;
					  root.y0 = 0;
					
					  const allNodes = layouts.treemap(root).descendants()
					  
					  allNodes.forEach(d=>{
						Object.assign(d.data,{
						  directSubordinates:d.children?d.children.length:0,
						  totalSubordinates:d.descendants().length-1
						})
					  })
					
					  root.children.forEach(collapse);
					  root.children.forEach(expandSomeNodes);
					
			  
			  
					  //Add svg
					  var svg = container
						  .patternify({
							  tag: 'svg',
							  selector: 'svg-chart-container'
						  })
						  .attr('width', attrs.svgWidth)
						  .attr('height', attrs.svgHeight)
						  .attr('font-family', attrs.defaultFont)
						  .call(behaviors.zoom)
						  .attr('cursor', 'move')
						  .style('background-color', attrs.backgroundColor)
			  
					  //Add container g element
					  var chart = svg
						  .patternify({
							  tag: 'g',
							  selector: 'chart'
						  })
						  .attr('transform', 'translate(' + calc.chartLeftMargin + ',' + calc.chartTopMargin + ')');
			  
					  var centerG = chart.patternify({
							  tag: 'g',
							  selector: 'center-group'
						  })
						  .attr('transform', `translate(${calc.centerX},${calc.nodeMaxHeight/2}) scale(${attrs.initialZoom})`)
					  
					  if(attrs.lastTransform)
						{
						  behaviors.zoom
							.scaleBy(chart,attrs.lastTransform.k)
							.translateTo(chart,attrs.lastTransform.x,attrs.lastTransform.y)
						}
			  
					  const defs = svg.patternify({
						  tag: 'defs',
						  selector: 'image-defs'
					  });
			  
					  const filterDefs = svg.patternify({
						  tag: 'defs',
						  selector: 'filter-defs'
					  });
			  
					 var filter = filterDefs.patternify({tag:'filter',selector:'shadow-filter-element'})
					  .attr('id', attrs.dropShadowId)
					  .attr('y',`${-50}%`)
					  .attr('x',`${-50}%`)
					  .attr('height', `${200}%`)
					  .attr('width',`${200}%`)
			  
				   filter.patternify({tag:'feGaussianBlur',selector:'feGaussianBlur-element'})
					 .attr('in', 'SourceAlpha')
					 .attr('stdDeviation', 3.1)
					 .attr('result', 'blur');
			  
				   filter.patternify({tag:'feOffset',selector:'feOffset-element'})
					 .attr('in', 'blur')
					 .attr('result', 'offsetBlur')
					 .attr("dx", 4.28)
					 .attr("dy", 4.48)
					 .attr("x", 8)
					 .attr("y", 8)
			  
					filter.patternify({tag:'feFlood',selector:'feFlood-element'})
					  .attr("in", "offsetBlur")
					  .attr("flood-color",'black')
					  .attr("flood-opacity", 0.3)
					  .attr("result", "offsetColor");
			  
					filter.patternify({tag:'feComposite',selector:'feComposite-element'})
					  .attr("in", "offsetColor")
					  .attr("in2", "offsetBlur")
					  .attr("operator", "in")
					  .attr("result", "offsetBlur");
			  
					var feMerge = filter.patternify({tag:'feMerge',selector:'feMerge-element'})
			  
					feMerge.patternify({tag:'feMergeNode',selector:'feMergeNode-blur'})
					  .attr('in', 'offsetBlur')
				  
					feMerge.patternify({tag:'feMergeNode',selector:'feMergeNode-graphic'})
					  .attr('in', 'SourceGraphic')
			  
			  
					  // Display tree contenrs
					  update(root)
			  
					  // Smoothly handle data updating
					  updateData = function() {};
			  
					  //#########################################  UTIL FUNCS ##################################
					  function setDropShadowId(d) {
						  if (d.dropShadowId) return;
			  
						  let id = d.id + "-drop-shadow";
						  //@ts-ignore
						  if (typeof DOM != 'undefined') {
						  //@ts-ignore
							  id = DOM.uid(d.id).id;
						  }
						  Object.assign(d, {
							  dropShadowId: id
						  })
					  }
			  
					  function rgbaObjToColor(d) {
						  return `rgba(${d.red},${d.green},${d.blue},${d.alpha})`
					  }
			  
					  // Zoom handler func
					  function zoomed() {
						  var transform = d3.event.transform;
						  attrs.lastTransform = transform;
						  chart.attr('transform', transform);
					  }
			  
					  // Toggle children on click.
					  function click(d) {
						  if (d.children) {
							  d._children = d.children;
							  d.children = null;
						  } else {
							  d.children = d._children;
							  d._children = null;
						  }
						  update(d);
					  }
			  
					  function diagonal(s, t) {
						  const x = s.x;
						  const y = s.y;
						  const ex = t.x;
						  const ey = t.y;
			  
						  let xrvs = ex - x&lt;0 ? -1 : 1;
						  let yrvs = ey - y&lt;0 ? -1 : 1;
			  
						  let rdef = 35;
						  let r = Math.abs(ex - x) / 2&lt;rdef ? Math.abs(ex - x) / 2 : rdef;
			  
						  r = Math.abs(ey - y) / 2&lt;r ? Math.abs(ey - y) / 2 : r;
			  
						  let h = Math.abs(ey - y) / 2 - r;
						  let w = Math.abs(ex - x) - r * 2;
						  //w=0;
						  const path = `
						  M ${x} ${y}
						  L ${x} ${y+h*yrvs}
						  C  ${x} ${y+h*yrvs+r*yrvs} ${x} ${y+h*yrvs+r*yrvs} ${x+r*xrvs} ${y+h*yrvs+r*yrvs}
						  L ${x+w*xrvs+r*xrvs} ${y+h*yrvs+r*yrvs}
						  C ${ex}  ${y+h*yrvs+r*yrvs} ${ex}  ${y+h*yrvs+r*yrvs} ${ex} ${ey-h*yrvs}
						  L ${ex} ${ey}
			   `
						  return path;
					  }
			  
					  function collapse(d) {
						  if (d.children) {
							  d._children = d.children;
							  d._children.forEach(collapse);
							  d.children = null;
						  }
					  }
					
					function expandSomeNodes(d){
					   if(d.data.expanded){
			  
							let parent = d.parent;
							while(parent){
			  
							  if(parent._children){
			  
								parent.children = parent._children;
			  
								//parent._children=null;
							  }
							  parent = parent.parent;
							}
						}
						if(d._children){
						  d._children.forEach(expandSomeNodes);
						}
						
					}
			  
			  
					  function update(source) {
						  //  Assigns the x and y position for the nodes
			  
						  const treeData = layouts.treemap(root);
			  
						  // Get tree nodes and links
						  const nodes = treeData.descendants().map(d => {
							  if (d.width) return d;
			  
							  let imageWidth = 100;
							  let imageHeight = 100;
							  let imageBorderColor = 'steelblue';
							  let imageBorderWidth = 0;
							  let imageRx = 0;
							  let imageCenterTopDistance = 0;
							  let imageCenterLeftDistance = 0;
							  let borderColor = 'steelblue';
							  let backgroundColor = 'steelblue';
							  let width = d.data.width;
							  let height = d.data.height;
							  let dropShadowId = `none`
							  if(d.data.nodeImage &amp;&amp; d.data.nodeImage.shadow){
								  dropShadowId = `url(#${attrs.dropShadowId})`
							  }
							  if (d.data.nodeImage &amp;&amp; d.data.nodeImage.width) {
								  imageWidth = d.data.nodeImage.width
							  };
							  if (d.data.nodeImage &amp;&amp; d.data.nodeImage.height) {
								  imageHeight = d.data.nodeImage.height
							  };
							  if (d.data.nodeImage &amp;&amp; d.data.nodeImage.borderColor) {
								  imageBorderColor = rgbaObjToColor(d.data.nodeImage.borderColor)
							  };
							  if (d.data.nodeImage &amp;&amp; d.data.nodeImage.borderWidth) {
								  imageBorderWidth = d.data.nodeImage.borderWidth
							  };
							  if (d.data.nodeImage &amp;&amp; d.data.nodeImage.centerTopDistance) {
								  imageCenterTopDistance = d.data.nodeImage.centerTopDistance
							  };
							  if (d.data.nodeImage &amp;&amp; d.data.nodeImage.centerLeftDistance) {
								  imageCenterLeftDistance = d.data.nodeImage.centerLeftDistance
							  };
							  if (d.data.borderColor) {
								  borderColor = rgbaObjToColor(d.data.borderColor);
							  }
							  if (d.data.backgroundColor) {
								  backgroundColor = rgbaObjToColor(d.data.backgroundColor);
							  }
							  if (d.data.nodeImage &amp;&amp;
								  d.data.nodeImage.cornerShape.toLowerCase() == "circle") {
								  imageRx = Math.max(imageWidth, imageHeight);
							  }
							  if (d.data.nodeImage &amp;&amp;
								  d.data.nodeImage.cornerShape.toLowerCase() == "rounded") {
								  imageRx = Math.min(imageWidth, imageHeight) / 6;
							  }
							  return Object.assign(d, {
								  imageWidth,
								  imageHeight,
								  imageBorderColor,
								  imageBorderWidth,
								  borderColor,
								  backgroundColor,
								  imageRx,
								  width,
								  height,
								  imageCenterTopDistance,
								  imageCenterLeftDistance,
								  dropShadowId
							  });
						  });
			  
						  const links = treeData.descendants().slice(1);
			  
						  // Set constant depth for each nodes
						  nodes.forEach(d => d.y = d.depth * attrs.depth);
						  // ------------------- FILTERS ---------------------
			  
						  const patternsSelection = defs.selectAll('.pattern')
							  .data(nodes, d => d.id);
			  
						  const patternEnterSelection = patternsSelection.enter().append('pattern')
			  
						  const patterns = patternEnterSelection
							  .merge(patternsSelection)
							  .attr('class', 'pattern')
							  .attr('height', 1)
							  .attr('width', 1)
							  .attr('id', d => d.id)
			  
						  const patternImages = patterns.patternify({
								  tag: 'image',
								  selector: 'pattern-image',
								  data: d => [d]
							  })
							  .attr('x', 0)
							  .attr('y', 0)
							  .attr('height', d => d.imageWidth)
							  .attr('width', d => d.imageHeight)
							  .attr('xlink:href', d => d.data.nodeImage.url)
							  .attr('viewbox', d => `0 0 ${d.imageWidth*2} ${d.imageHeight}`)
							  .attr('preserveAspectRatio', 'xMidYMin slice')
			  
						  patternsSelection.exit().transition().duration(attrs.duration).remove();
			  
						  // --------------------------  LINKS ----------------------
			  
						  // Update the links...
						  var linkSelection = centerG.selectAll('path.link')
							  .data(links, function(d) {
								  return d.id;
							  });
			  
						  // Enter any new links at the parent's previous position.
						  var linkEnter = linkSelection.enter()
							  .insert('path', "g")
							  .attr("class", "link")
							  .attr('d', function(d) {
								  var o = {
									  x: source.x0,
									  y: source.y0
								  }
								  return diagonal(o, o)
							  });
			  
						  // UPDATE
						  var linkUpdate = linkEnter.merge(linkSelection)
			  
						  // Styling links
						  linkUpdate
							  .attr("fill", "none")
							  .attr("stroke-width", d => d.data.connectorLineWidth || 2)
							  .attr('stroke', d => {
								  if (d.data.connectorLineColor) {
									  return rgbaObjToColor(d.data.connectorLineColor);
								  }
								  return 'green';
							  })
							  .attr('stroke-dasharray', d => {
								  if (d.data.dashArray) {
									  return d.data.dashArray;
								  }
								  return '';
							  })
			  
						  // Transition back to the parent element position
						  linkUpdate.transition()
							  .duration(attrs.duration)
							  .attr('d', function(d) {
								  return diagonal(d, d.parent)
							  });
			  
						  // Remove any exiting links
						  var linkExit = linkSelection.exit().transition()
							  .duration(attrs.duration)
							  .attr('d', function(d) {
								  var o = {
									  x: source.x,
									  y: source.y
								  }
								  return diagonal(o, o)
							  })
							  .remove();
			  
			  
						  // --------------------------  NODES ----------------------
						  // Updating nodes
						  const nodesSelection = centerG.selectAll('g.node')
							  .data(nodes, d => d.id)
			  
						  // Enter any new nodes at the parent's previous position.
						  var nodeEnter = nodesSelection.enter().append('g')
							  .attr('class', 'node')
							  .attr("transform", function(d) {
								  return "translate(" + source.x0 + "," + source.y0 + ")";
							  })
							  .attr('cursor', 'pointer')
							  .on('click', function(d){
								 if([...d3.event.srcElement.classList].
									 includes('node-button-circle')){
								   return;
								 }
								 attrs.onNodeClick(d.data.nodeId);
							  })
			  
						  // Add rectangle for the nodes 
						  nodeEnter
							  .patternify({
								  tag: 'rect',
								  selector: 'node-rect',
								  data: d => [d]
							  })
							  .attr('width', 1e-6)
							  .attr('height', 1e-6)
							  .style("fill", function(d) {
								  return d._children ? "lightsteelblue" : "#fff";
							  })
						
						  // Add foreignObject element
						  const fo = nodeEnter
							  .patternify({
								  tag: 'foreignObject',
								  selector: 'node-foreign-object',
								  data: d => [d]
							  })
							  .attr('width', d=> d.width)
							  .attr('height',d=> d.height)
							  .attr('x', d=> -d.width/2)
							  .attr('y', d=> -d.height/2 )
			  
						  // Add foreign object 
						  fo.patternify({
								  tag: 'xhtml:div',
								  selector: 'node-foreign-object-div',
								  data: d => [d]
							  })
							  .style('width', d=> d.width + 'px')
							  .style('height',d=> d.height + 'px')
							  .style('color', 'white')
							  .html(d=>d.data.template)
			  
					 /*  nodeEnter
							  .patternify({
								  tag: 'image',
								  selector: 'node-icon-image',
								  data: d => [d]
							  })
							  .attr('width', d=>  d.data.nodeIcon.size)
							  .attr('height', d=>  d.data.nodeIcon.size)
							  .attr("xlink:href",d=>d.data.nodeIcon.icon)
							  .attr('x',d=>-d.width/2+5)
							  .attr('y',d=> d.height/2 - d.data.nodeIcon.size-5)
						*/
						 nodeEnter
							  .patternify({
								  tag: 'text',
								  selector: 'node-icon-text-total',
								  data: d => [d]
							  })
							  .text('test')
							  .attr('x',d=>-d.width/2+10 )
							  .attr('y',d=> d.height/2 - d.data.nodeIcon.size-5)
							  //.attr('text-anchor','middle')
							  .text(d=>d.data.totalSubordinates + ' Subordinates')
							  .attr('fill',attrs.nodeTextFill)
							  .attr('font-weight','bold')
							  .attr('font-size','12pt')
						
						 nodeEnter
							  .patternify({
								  tag: 'text',
								  selector: 'node-icon-text-direct',
								  data: d => [d]
							  })
							  .text('test')
							  .attr('x',d=>-d.width/2+10)
							  .attr('y',d=> d.height/2 - 10)
							  .text(d=>d.data.directSubordinates +' Direct ')
							  .attr('fill',attrs.nodeTextFill)
							  .attr('font-weight','bold')
							  .attr('font-size','12pt')
			  
						
						  // Node images
						  const nodeImageGroups = nodeEnter.patternify({
							  tag: 'g',
							  selector: 'node-image-group',
							  data: d => [d]
						  })
			  
						  // Node image rectangle 
						  nodeImageGroups
							  .patternify({
								  tag: 'rect',
								  selector: 'node-image-rect',
								  data: d => [d]
							  })
			  
						  // Node button circle group
						  const nodeButtonGroups = nodeEnter
							  .patternify({
								  tag: 'g',
								  selector: 'node-button-g',
								  data: d => [d]
							  })
							  .on('click', click)
			  
						  // Add button circle 
						  nodeButtonGroups
							  .patternify({
								  tag: 'circle',
								  selector: 'node-button-circle',
								  data: d => [d]
							  })
			  
						  // Add button text 
						  nodeButtonGroups
							  .patternify({
								  tag: 'text',
								  selector: 'node-button-text',
								  data: d => [d]
							  })
							  .attr('pointer-events','none')
			  
			  
			  
						  // Node update styles
						  var nodeUpdate = nodeEnter.merge(nodesSelection)
							  .style('font', '12px sans-serif')
			  
						  // Transition to the proper position for the node
						  nodeUpdate.transition()
							  .attr('opacity', 0)
							  .duration(attrs.duration)
							  .attr("transform", function(d) {
								  return "translate(" + d.x + "," + d.y + ")";
							  })
							  .attr('opacity', 1)
			  
						  // Move images to desired positions
						  nodeUpdate.selectAll('.node-image-group')
							  .attr('transform', d => {
								  let x = -d.imageWidth / 2 - d.width / 2;
								  let y = -d.imageHeight / 2 - d.height / 2;
								  return `translate(${x},${y})`
							  })
			  
			  
						  nodeUpdate.select('.node-image-rect')
							  .attr('fill', d => `url(#${d.id})`)
							  .attr('width', d => d.imageWidth)
							  .attr('height', d => d.imageHeight)
							  .attr('stroke', d => d.imageBorderColor)
							  .attr('stroke-width', d => d.imageBorderWidth)
							  .attr('rx', d => d.imageRx)
							  .attr('y', d => d.imageCenterTopDistance)
							  .attr('x', d => d.imageCenterLeftDistance)
							  .attr('filter',d=> d.dropShadowId)
			  
						  // Update  node attributes and style
						  nodeUpdate.select('.node-rect')
							  .attr('width', d => d.data.width)
							  .attr('height', d => d.data.height)
							  .attr('x', d => -d.data.width / 2)
							  .attr('y', d => -d.data.height / 2)
							  .attr('rx', d => d.data.borderRadius || 0)
							  .attr('stroke-width', d => d.data.borderWidth || attrs.strokeWidth)
							  .attr('cursor', 'pointer')
							  .attr('stroke', d => d.borderColor)
							  .style("fill", d => d.backgroundColor)
			  
			  
			  
			  
						  // Move node button group to the desired position
						  nodeUpdate.select('.node-button-g')
							  .attr('transform', d => {
								  return `translate(0,${d.data.height/2})`
							  })
							  .attr('opacity', d => {
								  if (d.children || d._children) {
									  return 1;
								  }
								  return 0;
							  })
			  
						  // Restyle node button circle
						  nodeUpdate.select('.node-button-circle')
							  .attr('r', 16)
							  .attr('stroke-width', d => d.data.borderWidth || attrs.strokeWidth)
							  .attr('fill', attrs.backgroundColor)
							  .attr('stroke', d => d.borderColor)
			  
						  // Restyle texts
						  nodeUpdate.select('.node-button-text')
							  .attr('text-anchor', 'middle')
							  .attr('alignment-baseline', 'middle')
							  .attr('fill', attrs.defaultTextFill)
							  .attr('font-size', d => {
								  if (d.children) return 40;
								  return 26;
							  })
							  .text(d => {
								  if (d.children) return '-';
								  return '+';
							  })
			  
						  // Remove any exiting nodes
			  
			  
			  
						  var nodeExitTransition = nodesSelection.exit()
							  .attr('opacity', 1)
							  .transition()
							  .duration(attrs.duration)
							  .attr("transform", function(d) {
								  return "translate(" + source.x + "," + source.y + ")";
							  })
							  .on('end', function() {
								  d3.select(this).remove();
							  })
							  .attr('opacity', 0)
			  
			  
						  // On exit reduce the node rects size to 0
						  nodeExitTransition.selectAll('.node-rect')
							  .attr('width', 10)
							  .attr('height', 10)
							  .attr('x', 0)
							  .attr('y', 0);
			  
						  // On exit reduce the node image rects size to 0
						  nodeExitTransition.selectAll('.node-image-rect')
							  .attr('width', 10)
							  .attr('height', 10)
							  .attr('x', d => d.width / 2)
							  .attr('y', d => d.height / 2)
			  
						  // Store the old positions for transition.
						  nodes.forEach(function(d) {
							  d.x0 = d.x;
							  d.y0 = d.y;
						  });
			  
			  
						  // debugger;
					  }
			  
					  d3.select(window).on('resize.' + attrs.id, function() {
						  var containerRect = container.node().getBoundingClientRect();
						  //	if (containerRect.width > 0) attrs.svgWidth = containerRect.width;
						  //	main();
					  });
				  };
			  
				  //----------- PROTOTYPE FUNCTIONS  ----------------------
				  d3.selection.prototype.patternify = function(params) {
					  var container = this;
					  var selector = params.selector;
					  var elementTag = params.tag;
					  var data = params.data || [selector];
			  
					  // Pattern in action
					  var selection = container.selectAll('.' + selector).data(data, (d, i) => {
						  if (typeof d === 'object') {
							  if (d.id) {
								  return d.id;
							  }
						  }
						  return i;
					  });
					  selection.exit().remove();
					  selection = selection.enter().append(elementTag).merge(selection);
					  selection.attr('class', selector);
					  return selection;
				  };
			  
				  //Dynamic keys functions
				  Object.keys(attrs).forEach((key) => {
					  // Attach variables to main function
					  //@ts-ignore
					  main[key] = function(_) {
						  var string = `attrs['${key}'] = _`;
						  if (!arguments.length) {
							  return eval(` attrs['${key}'];`);
						  }
						  eval(string);
						  return main;
					  };
					  return main;
				  });
			  
				  //Set attrs as property
				  //@ts-ignore
				  main['attrs'] = attrs;
			  
				  //Exposed update functions
				  //@ts-ignore
				  main['data'] = function(value) {
					  if (!arguments.length) return attrs.data;
					  attrs.data = value;
					  if (typeof updateData === 'function') {
						  updateData();
					  }
					  return main;
				  };
			  
				  // Run  visual
				  //@ts-ignore
				  main['render'] = function() {
					  main();
					  return main;
				  };
			  
				  return main;
			  }
				  </script>				
			</body>
			<script>
                    $(document).ready(function(){
                        var windowHeight = $(window).height();
						var windowWidth = $(window).width();
                        $('.simple-scroller').scrollLeft(windowWidth/2);
                    });
                </script>
	<script id="panel-template" type="text/x-handlebars-template">

		<div class="container-fluid" id="summary-content">
			<div class="row">
				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Summary for')"/> </span><xsl:text> </xsl:text>
							<span class="text-primary">{{this.name}}</span>
						</h1>
					</div>
				</div>
			</div>
			<!--Setup Vertical Tabs-->
			<div class="row">
				<div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
					<!-- required for floating -->
					<!-- Nav tabs -->
					<ul class="nav nav-tabs tabs-left">
						<li class="active">
							<a href="#details" data-toggle="tab"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Organisation Details')"/></a>
						</li>
						<li>
							<a href="#hierarchy" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('Organisation Hierarchy')"/></a>
						</li>
						{{#if this.allBusProcs}}
						<li>
							<a href="#processes" data-toggle="tab"><i class="fa fa-fw fa-random right-10"></i><xsl:value-of select="eas:i18n('Processes')"/></a>
						</li>
						{{/if}}
						{{#if this.allAppsUsed}}
						<li>
							<a href="#applications" class="appTab" data-toggle="tab"><i class="fa fa-fw fa-desktop right-10"></i><xsl:value-of select="eas:i18n('Application Usage')"/></a>
						</li>
						{{/if}}
						{{#if this.documents}}
						<li>
							<a href="#documents" class="appTab" data-toggle="tab"><i class="fa fa-fw fa-file-text-o right-10"></i><xsl:value-of select="eas:i18n('Documents')"/></a>
						</li>
						{{/if}}
					<!-- 	<li>
							<a href="#projects" data-toggle="tab"><i class="fa fa-fw fa-calendar-check-o right-10"></i><xsl:value-of select="eas:i18n('Plans and Projects')"/></a>
						</li>-->
					</ul>
				</div>

				<div class="col-xs-12 col-sm-8 col-md-9 col-lg-10">
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active" id="details">
							<h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('Organisation Details')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-users right-10"></i><xsl:value-of select="eas:i18n('Organisation')"/></h3>
									<label><xsl:value-of select="eas:i18n('Organisation Name')"/></label>
									<div class="ess-string">{{this.name}}</div>
									<div class="clearfix bottom-10"></div>
									<label><xsl:value-of select="eas:i18n('Description')"/></label>
									<div class="ess-string">{{{this.description}}}</div>
									<div class="clearfix bottom-10"></div>
									<label><xsl:value-of select="eas:i18n('Parent Organisation(s)')"/></label>
									<ul class="ess-list-tags">
									{{#each this.parents}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
									<label><xsl:value-of select="eas:i18n('Direct Child Organisation(s)')"/></label>
									<ul class="ess-list-tags">
									{{#each this.childrenOrgs}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-bar-chart right-10"></i><xsl:value-of select="eas:i18n('Key Information')"/></h3>
									<label><xsl:value-of select="eas:i18n('Processes')"/> </label>
									<div class="bottom-10">
										<div class="keyCount lbl-large bg-orange-100">{{this.allBusProcs.length}}</div>
									 
									<label><xsl:value-of select="eas:i18n('Applications Used')"/><xsl:text> </xsl:text><small>(<xsl:value-of select="eas:i18n('excl. Parents')"/>)</small></label>
									 
									<div class="keyCount lbl-large bg-brightgreen-100">{{this.allAppsUsed.length}}</div>	 							
									</div>
									
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Primary Locations')"/></h3>
									<label><xsl:value-of select="eas:i18n('Sites')"/></label>
									<ul class="ess-list-tags">
										{{#each this.allSites}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
									
								</div>
								<div class="col-xs-12"/>
								{{#if this.orgProductTypes}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Products/Services Supported')"/></h3>
									
									<ul class="ess-list-tags"> 
										{{#each this.orgProductTypes}}
											<li class="roleBlob" style="background-color: rgb(179, 197, 208)">{{this}}</li> 
										{{/each}}
									</ul> 
									<div class="clearfix bottom-10"></div>
								</div>
								{{/if}}
								{{#if this.orgEmployees}}
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('People &amp; Roles')"/></h3>
									 
									<table class="table table-striped table-bordered" id="dt_stakeholders">
											<thead>
												<tr>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Person')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
												 
												</tr>
											</thead>
											<tbody>
											{{#each this.orgEmployees}}
											<tr>
												<td class="cellWidth-30pc">
														<i class="fa fa-user text-success right-5"></i>	{{this.name}}
												</td>
												<td class="cellWidth-30pc">
													<ul class="ess-list-tags">
														{{#each this.roles}}
														{{#ifEquals this.name 'Application Organisation User'}}
															<i class="fa fa-user text-success right-5"></i> <xsl:value-of select="eas:i18n('Application User')"/>
														{{else}}
															<li class="roleBlob" style="background-color: rgb(96, 217, 214)">{{this.name}}</li>
														{{/ifEquals}} 
														{{/each}} 
														</ul>
													
												</td>
												 
											</tr>		
											{{/each}}
											</tbody>
											<tfoot>
												<tr>
													<th class="cellWidth-30pc">
															<xsl:value-of select="eas:i18n('Person')"/>
													</th>
													<th class="cellWidth-30pc">
														<xsl:value-of select="eas:i18n('Role')"/>
													</th>
												</tr>
											</tfoot>
										</table>

									<div class="clearfix bottom-10"></div>
									
								</div>
								{{/if}}
								{{#if this.orgRoles}}
								<div class="superflex">
										<h3 class="text-primary"><i class="fa fa-list-alt right-10"></i><xsl:value-of select="eas:i18n('Organisation Roles')"/></h3>
										<ul class="ess-list-tags">
											{{#each this.orgRoles}}
												<li class="roleBlob" style="background-color: rgb(96, 217, 144)">{{this.name}}</li>
											{{/each}}
										</ul>
									 
	
										<div class="clearfix bottom-10"></div>
										
								</div>
								{{/if}}
							</div>
						</div>
						<div class="tab-pane" id="hierarchy">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-tag right-10"></i><xsl:value-of select="eas:i18n('Hierarchy')"/></h2>
						 		<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i><xsl:value-of select="eas:i18n('Organisation Hierarchy')"/></h3><span id="hierarchyInfo"><label class="label label-warning">No hierarchy defined for this organisation</label></span>
									<div class="bottom-10">
										<div class="chart-container" style=" padding-top:10px; width:100%; height:1800px "> </div>
									</div>

								</div>  
							 
						</div>
						<div class="tab-pane" id="processes">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-globe right-10"></i>Business Processes</h2>
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Business Processes</h3>
									<div class="ess-blobWrapper">
									 {{#each this.allBusProcs}}
										<div class="ess-blob bdr-left-orange" id="someid">
											<div class="ess-blobLabel">
												 {{{essRenderInstanceMenuLink this}}} 
											</div>
											<div class="infoButton" id="someid_info">
												<a tabindex="0" class="popover-trigger">
													<i class="fa fa-info-circle"></i>
												</a>
												<div class="popover">
													<div class="strong">{{this.name}}</div>
													<div class="small text-muted">{{this.description}}</div>
													<ul class="ess-list-tags">
														<li style="background-color: rgb(163, 214, 194)">{{this.criticality}}</li>
													</ul> 
												</div>
											</div>
										</div>
									{{/each}}	
									</div>
								</div>
							</div>
						
			 			<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-table right-10"></i>Process Implementations</h3>
									Application Mapping Key: <label class="label   ess-mini-badge" style="background-color: rgb(170, 194, 213);color:#000">Direct to Process</label><xsl:text> </xsl:text><label class="label  ess-mini-badge" style="background-color:rgb(210, 169, 190);color:#000">Via Application Service</label>
									<div class="bottom-10">
										<table id="dt_supportedprocesses" class="table table-striped table-bordered" >
											<thead>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Process')"/>
													</th>
                                                    <th>
														<xsl:value-of select="eas:i18n('Organisation Performing')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Product')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Applications Used')"/>
													</th>
												</tr>
											</thead>
											<tbody>
												 {{#each this.physicalProcesses}}
													<tr>
														<td>
															{{this.processName}}
														</td>
                                                        <td>
															<ul class="ess-list-tags"> 
																	<li class="roleBlob" style="background-color: rgb(132, 213, 237)">{{this.org}}</li> 
															</ul> 
															
														</td>
														<td>
															<ul class="ess-list-tags">
																{{#each this.product}}
																	<li class="roleBlob" style="background-color: rgb(213, 203, 170)">{{this}}</li>
																{{/each}} 
															</ul> 
														</td>
														<td>
															{{#if this.criticality}}
															<ul class="ess-list-tags">
																<li style="background-color: rgb(163, 214, 194)">{{this.criticality}}</li>
															</ul> 
															{{/if}}
														</td>
														<td>
															<ul class="ess-list-tags">
															{{#each this.appsdirect}}
																<li class="roleBlob" style="background-color: rgb(170, 194, 213)">{{this.appName}}</li>
															{{/each}} 
															{{#each this.appsviaservice}}
																<li class="roleBlob" style="background-color: rgb(210, 169, 190)">{{this.appName}}</li>
															{{/each}} 
															</ul>
														</td>
													</tr>

												{{/each}}

											</tbody>
											<tfoot>
												<tr>
													<th>
														<xsl:value-of select="eas:i18n('Process')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Organisation Performing')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Product')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Criticality')"/>
													</th>
													<th>
														<xsl:value-of select="eas:i18n('Applications Used')"/>
													</th>
												</tr>
											</tfoot>
										</table>
									</div>

								</div>  
						</div>
						<div class="tab-pane" id="applications">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-users right-10"></i>Usage</h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i>Supporting Apps</h3>
									Applications used by this organisation or its children organisations. <br/>
									Key: <label class="label label-info ess-mini-badge">Via Process</label><xsl:text> </xsl:text><label class="label label-warning ess-mini-badge">Via App Org User</label><label class="label ess-mini-badge" style="background-color: #b07fdd;">Via Child Org</label>
									<label class="label ess-mini-badge" style="background-color: #646068;">Via Parent</label>
									<div class="clearfix top-15"/>
									<table class="table table-striped table-bordered" id="dt_apptable">
											<thead>
												<tr>
													<th width="150px">
														<xsl:value-of select="eas:i18n('Name')"/>
													</th>
													<th width="800px">
														<xsl:value-of select="eas:i18n('Description')"/>
													</th>
													 
												</tr>
											</thead>
											<tbody>
						
											</tbody>
											<tfoot>
													<tr>
															<th>
																<xsl:value-of select="eas:i18n('Name')"/>
															</th>
															<th>
																<xsl:value-of select="eas:i18n('Description')"/>
															</th>
															 
														</tr>
											</tfoot>
										</table>
									<div class="clearfix bottom-10"></div>
								</div>
						</div>
						</div>
						<div class="tab-pane" id="projects">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-lock right-10"></i><xsl:value-of select="eas:i18n('Plans and Projects')"/></h2>
							<div class="parent-superflex">
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-building right-10"></i><xsl:value-of select="eas:i18n('Strategic Plans')"/></h3>
									<label><xsl:value-of select="eas:i18n('No. of Strategic Plans')"/></label>
									<div class="bottom-15">
										<span class="label label-info lbl-big">5</span>
									</div>
									<label><xsl:value-of select="eas:i18n('Strategic Plans List')"/></label>
								
									<ul class="ess-list-tags">
										<li>Public</li>
										<li>Public</li>
										<li>Public</li>
										<li>Public</li>
									</ul>
									 
								</div>
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-check-circle-o right-10"></i><xsl:value-of select="eas:i18n('Projects')"/></h3>
									<label><xsl:value-of select="eas:i18n('No. of Projects')"/></label>
									<div class="bottom-15">
										<span class="label label-primary lbl-big">5</span>
									</div>
									<ul class="ess-list-tags">
										<li>Proj 1</li>
									</ul>
									 
								</div>
								
								 
							</div>
						</div>
						
						<div class="tab-pane" id="documents">
							<h2 class="print-only top-30"><i class="fa fa-fw fa-file-text-o right-10"></i>Documents</h2>
							<div class="parent-superflex">
								  
								<div class="superflex">
									<h3 class="text-primary"><i class="fa fa-file-text-o right-10"></i>Documents</h3>
									{{#each this.documents}}  
										  {{#each this.values}} 
											{{#ifEquals @index 0}}
												{{#if this.type}}
													<h3>{{this.type}}</h3>
												{{else}}
													<h3>General</h3>
												{{/if}}
											{{/ifEquals}}
											<i class="fa fa-caret-right"></i> {{this.name}}: <a><xsl:attribute name="href">{{this.documentLink}}</xsl:attribute><i class="fa fa-link"></i></a><br/>
										{{/each}} 
									{{/each}}
								</div>
							</div>
						
						</div>
					</div>
				</div>
			</div>

			<!--Setup Closing Tag-->
		</div>

	</script>	
	<script id="appline-template" type="text/x-handlebars-template">
		<span><xsl:attribute name="id">{{this.id}}</xsl:attribute>{{{essRenderInstanceMenuLink this}}}<br/>
			{{#if this.proc}}{{#ifEquals this.proc 'Indirect'}}<label class="label ess-mini-badge" style="background-color: #b07fdd;">{{this.proc}}</label>{{else}}<label class="label label-info ess-mini-badge">{{this.proc}}</label>{{/ifEquals}}{{/if}}
			{{#if this.org}}{{#ifEquals this.org 'Parent'}}<label class="label ess-mini-badge" style="background-color: #646068;">{{this.org}}</label>{{else}}<label class="label label-warning ess-mini-badge">{{this.org}}</label>{{/ifEquals}}{{/if}}
		</span>
	</script>
	<script id="roles-template" type="text/x-handlebars-template"></script>
	<script id="jsonOrg-template" type="text/x-handlebars-template">
		<div class="orgName">{{this.name}}</div>
	</script>
	<script id="apps-template" type="text/x-handlebars-template"></script>
	<script id="processes-template" type="text/x-handlebars-template"></script>
	<script id="sites-template" type="text/x-handlebars-template"></script>
	<script id="appsnippet-template" type="text/x-handlebars-template"></script>
<script>;	   
  <xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template>
 let products=[<xsl:apply-templates select="$products" mode="products"/>];
  
	$(document).ready(function ()
	{
		// compile any handlebars templates
		var panelFragment = $("#panel-template").html();
		panelTemplate = Handlebars.compile(panelFragment);
 
		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
	 
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});
 
		let panelSet = new Promise(function(myResolve, myReject) {	 
			$('#mainPanel').html(panelTemplate())
			myResolve(); // when successful
			myReject();  // when error
			});
   
				});
		
		let procTable
		let processSet = new Promise(function(myResolve, myReject) {	 
			 
						
						procTable = $('#dt_supportedprocesses').DataTable({
						scrollY: "350px",
						scrollCollapse: true,
						paging: true,
						info: false,
						pageLength: 5,
						sort: true,
						responsive: true,
						columns: [
							{ "width": "40%" },
							{ "width": "15%" },
							{ "width": "15%" }  
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
						procTable.columns().every( function () {
							var thatp = this;
						
							$( '.procIn', this.footer() ).on( 'keyup change', function () {
								if ( thatp.search() !== this.value ) {
									that
										.search( this.value )
										.draw();
								}
							} );
						} );


					
						
					
						
					 
			myResolve(); // when successful
			myReject();  // when error
			});
		
			processSet.then(function(response) {  
						procTable.columns.adjust();
						
						$(window).resize( function () {
							procTable.columns.adjust();
						});
						procTable.columns.adjust().draw();
						 

			})
		 
</script>
		</html>
	</xsl:template>     
	
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/> 
			<xsl:param name="viewerAPIPathApp"/>
			<xsl:param name="viewerAPIPathPP"/>
			//a global variable that holds the data returned by an Viewer API Report
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
			var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApp"/>';
			var viewAPIDataPP = '<xsl:value-of select="$viewerAPIPathPP"/>';
			//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		   
		   var promise_loadViewerAPIData = function(apiDataSetURL) {
				return new Promise(function (resolve, reject) {
					if (apiDataSetURL != null) {
						var xmlhttp = new XMLHttpRequest(); 
						xmlhttp.onreadystatechange = function () {
							if (this.readyState == 4 &amp;&amp; this.status == 200) { 
								var viewerData = JSON.parse(this.responseText);
								resolve(viewerData);
								$('#ess-data-gen-alert').hide();
							}
						};
						xmlhttp.onerror = function () {
							reject(false);
						};
						xmlhttp.open("GET", apiDataSetURL, true);
						xmlhttp.send();
					} else {
						reject(false);
					}
				});
			};
		   
	  var orgData=[];
	  var appsData=[];
	 
	  var focusID="<xsl:value-of select='eas:getSafeJSString($param1)'/>";
	  var rolesFragment, appsnippetTemplate, appsnippetFragment, appsFragment, processesFragment, sitesFragment, rolesTemplate, appsTemplate, processesTemplate,sitesTemplate ;
	
			$('document').ready(function () {
				
				$('.selectOrgBox').select2();
	
				rolesFragment = $("#roles-template").html();
				rolesTemplate = Handlebars.compile(rolesFragment);
				
				appsFragment = $("#apps-template").html();
				appsTemplate = Handlebars.compile(appsFragment);
	
				processesFragment = $("#processes-template").html();
				processesTemplate = Handlebars.compile(processesFragment);

				jsonFragment = $("#jsonOrg-template").html();
				jsonTemplate = Handlebars.compile(jsonFragment); 
	
				sitesFragment = $("#sites-template").html();
				sitesTemplate = Handlebars.compile(sitesFragment);
					   
				appsnippetFragment = $("#appsnippet-template").html();
				appsnippetTemplate = Handlebars.compile(appsnippetFragment);
				
				var appFragment = $("#appline-template").html();
				appTemplate = Handlebars.compile(appFragment);

				Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
					return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
				}); 
				Handlebars.registerHelper('rowType', function(arg1) {
					if (arg1 % 2 == 0){
						return 'even';
					} 
					else{
						return 'odd1';
					}
				}); 
			   
				$('.bottomDiv').hide();
	
	//get data
	Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataPP)
			]).then(function(responses) {
				let orgRoles=[];		
				   orgData=responses[0].orgData; 
				   if(responses[0].orgRoles){
				   	orgRoles=responses[0].orgRoles;
				   }
				   appData=responses[1];
				   physProc=responses[2];  
				  let orgProductTypes=[];
				 
				   products.forEach((prod)=>{
				 
					   prod.processes.forEach((e)=>{
						
							let thisMatch=physProc.process_to_apps.filter((p)=>{
								return p.id == e;
							});

							if(thisMatch){
								if(thisMatch['product']){
								thisMatch['product'].push(prod.name);
							
								}
								else
								{
								thisMatch['product']=[prod.name];	
								} 
							 
							}
						 
					   })
					   
				   })
  
				   modelData=[]
				   orgData.forEach((d)=>{
 
					 if(orgRoles.length&gt;0){
						let thisRoles=orgRoles.find((or)=>{
							return or.id==d.id;
						});
						if(thisRoles){
							d['orgRoles']=thisRoles.roles;
						};
					 };

					let parent=[];
					let childrenOrgs=[];
					d.parentOrgs.forEach((e)=>{
						let thisParent=orgData.find((f)=>{
							return f.id == e
						}); 
						if(thisParent){
						parent.push({"name":thisParent.name,"id":thisParent.id})	
						}
					})
					d['parents']=parent; 
					if(d.childOrgs){
						d.childOrgs.forEach((e)=>{ 
							let thisChild=orgData.find((f)=>{
								return f.id == e
							});  
							childrenOrgs.push({"name":thisChild.name,"id":thisChild.id})	
						})
					}
					d['childrenOrgs']=childrenOrgs;
			 
					   let allAppsUsed=[];
					   let allBusProcs=[];
					   let allSubOrgs=[];
					   let allSites=[];
					   let allAppsUsedParent=[];
					   let allBusProcsParent=[];
					   let allParentOrgs=[];
					   let allSitesParent=[];
					   d.applicationsUsedbyOrgUser.forEach((e)=>{
						 allAppsUsed.push(e)
					   })
					   d.applicationsUsedbyProcess.forEach((e)=>{
						allAppsUsed.push(e)
					  });
				 	 
					  d.businessProcess.forEach((e)=>{
						  e['className']='Business_Process';
						allBusProcs.push(e)
					  }); 
			 	
					  if(d.site){
						d.site.forEach((e)=>{
							allSites.push(e)
						});
						}
					 if(d.parentOrgs.length&gt;0){
						d.parentOrgs.forEach((e)=>{
						 	
							let thisOrg=orgData.find((f)=>{
								return f.id == e
							});
						 
							allParentOrgs.push({"id":thisOrg.id, "name":thisOrg.name}) 
							 
							getParents(thisOrg, allAppsUsedParent, allBusProcsParent, allParentOrgs, allSitesParent)
							  
						   });
						  
						 } 

						if(d.childOrgs.length&gt;0){

					   d.childOrgs.forEach((e)=>{
					 
						let thisOrg=orgData.find((f)=>{
							return f.id == e
						});
					 
						allSubOrgs.push({"id":thisOrg.id, "name":thisOrg.name}) 
				 
						getChildren(thisOrg, allAppsUsed, allBusProcs, allSubOrgs, allSites)
						  
					   })
					   
					}
					

					   allAppsUsed=allAppsUsed.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allAppsUsedParent=allAppsUsedParent.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allBusProcs=allBusProcs.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allSubOrgs=allSubOrgs.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   allSites=allSites.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
					   let appList=[]; 
					   let parentappList=[]; 
					   allAppsUsedParent = allAppsUsedParent.filter(x => !allAppsUsed.includes(x));   
					   allAppsUsed.forEach((ap)=>{ 
						   let thisApp=appData.applications.find((e)=>{
							   return e.id == ap.id;
						   })
						   appList.push(thisApp)
					   });
 
					   allAppsUsedParent.forEach((ap)=>{ 
						let thisApp=appData.applications.find((e)=>{
							return e.id == ap.id;
						})
						parentappList.push(thisApp)
						})
	 
					   d['allAppsUsedParent']=parentappList;
					   d['allAppsUsed']=appList;
					   d['allBusProcs']=allBusProcs;
					   d['allChildren']=allSubOrgs;
					   d['allSites']=allSites;
						 //  $('.selectOrgBox').append('&lt;option value='+d.id+' >'+d.name+'&lt;option>');
					
					});
					
			 
				//	$('.selectOrgBox').val(focusID);  
				//	$('.selectOrgBox').trigger('change');
					
					let toShow = orgData.find((e)=>{
					return e.id == focusID;
					})
				 	
 
	 	 			getThisHierarchy(toShow, null, modelData )
					  
					  let appProcMap=[];
					  orgProductTypes=[]; 
					  toShow.allBusProcs.forEach((e)=>{ 
						let thisProcess=physProc.process_to_apps.filter((f)=>{
							return e.id == f.processid;
						});


						if(thisProcess){
							thisProcess.forEach((pr)=>{
							pr['criticality']=e.criticality;
							appProcMap.push(pr)
							if(thisProcess.product){
							orgProductTypes=[...orgProductTypes, ...pr.product];
							}
							})
						}
 
	appProcMap = appProcMap.filter((ap)=>{
		return toShow.id == ap.orgid;
	});
 
	
						orgProductTypes=orgProductTypes.filter((elem, index, self) => self.findIndex( (t) => {return (t === elem)}) === index)
					 
						toShow['orgProductTypes']=orgProductTypes
					  }); 
					//  console.log('toShow',toShow) 
					let parentProcs = appProcMap.filter((e)=>{
						  return e.orgid ==  toShow.id;
					  });
				 
					  let childProcs=[];
					  toShow.allChildren.forEach((e)=>{
						let thisProcs  = appProcMap.filter((f)=>{
							return f.orgid ==  e.id;
						})
						if(thisProcs){
							thisProcs.forEach((p)=>{
								thisProcs['criticality']=e.criticality;
							})
					 
						childProcs=[...childProcs, ...thisProcs]
						}
					})
	    
						
					toShow['physicalProcesses']=[...parentProcs, ...childProcs, ...appProcMap]
					toShow.physicalProcesses=toShow.physicalProcesses.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
	 
					
					toShow.physicalProcesses.sort((a,b) => (a.processName > b.processName) ? 1 : ((b.processName > a.processName) ? -1 : 0))
					toShow.physicalProcesses.forEach((pp)=>{
						pp.appsdirect.forEach((app)=>{ 
							app['appName']=app.name; 
						});
						pp.appsviaservice.forEach((app)=>{ 
							let thisApp=appData.applications.find((fa)=>{
								return fa.id ==app.appid;
							});
							if(thisApp){
								app['appName']=thisApp.name;
							}
						});
					});
			 var docSort = d3.nest()
			 	.key(function(d) { return d.index; })
			 	.entries(toShow.documents);
			  toShow.documents=docSort;


			 console.log('to',toShow)
			 drawView(toShow, modelData);
  
				})
				.catch (function (error) {
					//display an error somewhere on the page   
				});
	  
			});

function getThisHierarchy(node, chartParent, modelData){


	if(chartParent==null){
	 
			let thisParent=orgData.find((f)=>{
				return f.id == node.parentOrgs[0]
			}); 
		//	console.log('thisParent',thisParent) 
			if(thisParent){	
				let thisNode = {
					"nodeId": thisParent.id,
					"parentNodeId": null,
					"width": 342,
					"height": 146,
					"borderWidth": 1,
					"borderRadius": 5,
					"borderColor": {
						"red": 15,
						"green": 140,
						"blue": 121,
						"alpha": 1
					},
					"backgroundColor": {
						"red": 51,
						"green": 182,
						"blue": 208,
						"alpha": 1
					},
					"nodeImage": {
						"url": "images/icon_target.png",
						"width": 50,
						"height": 50,
						"centerTopDistance": 0,
						"centerLeftDistance": 0,
						"cornerShape": "SQUARE",
						"shadow": false,
						"borderWidth": 0,
						"borderColor": {
							"red": 19,
							"green": 123,
							"blue": 128,
							"alpha": 1
						}
					},
					"nodeIcon": {
						"icon": "images/icon_person.png",
						"size": 30
					},
					"template": jsonTemplate(thisParent),
					"connectorLineColor":{
						"red":220,
						"green":189,
						"blue":207,
						"alpha":1},
						"connectorLineWidth":5,
						"dashArray":"",
						"expanded":false,
						"directSubordinates":4,
						"totalSubordinates":1515}
				
						modelData.push(thisNode)
						chartParent=thisParent.id
			}
		}

   let thisNode = {
	"nodeId": node.id,
	"parentNodeId": chartParent,
	"width": 342,
	"height": 146,
	"borderWidth": 1,
	"borderRadius": 5,
	"borderColor": {
		"red": 15,
		"green": 140,
		"blue": 121,
		"alpha": 1
	},
	"backgroundColor": {
		"red": 51,
		"green": 182,
		"blue": 208,
		"alpha": 1
	},
	"nodeImage": {
		"url": "images/icon_target.png",
		"width": 50,
		"height": 50,
		"centerTopDistance": 0,
		"centerLeftDistance": 0,
		"cornerShape": "SQUARE",
		"shadow": false,
		"borderWidth": 0,
		"borderColor": {
			"red": 19,
			"green": 123,
			"blue": 128,
			"alpha": 1
		}
	},
	"nodeIcon": {
		"icon": "images/icon_person.png",
		"size": 30
	},
	"template": jsonTemplate(node),
	"connectorLineColor":{
		"red":220,
		"green":189,
		"blue":207,
		"alpha":1},
		"connectorLineWidth":5,
		"dashArray":"",
		"expanded":false,
		"directSubordinates":4,
		"totalSubordinates":1515}
 
		modelData.push(thisNode)

		node.childOrgs.forEach((e)=>{
			let thisChild=orgData.find((f)=>{
				return f.id == e
			}); 
			 
			getThisHierarchy(thisChild, node.id, modelData)
		})

}			

function getChildren(arr, allApp, allBus, allOrgs, allSites){ 
	if(arr.applicationsUsedbyOrgUser){
		arr.applicationsUsedbyOrgUser.forEach((f)=>{
			allApp.push(f)
	  }) 
	   }
	   if(arr.applicationsUsedbyProcess){
		arr.applicationsUsedbyProcess.forEach((f)=>{
			allApp.push(f)
	  })
	   } 
	   if(arr.businessProcess){
		arr.businessProcess.forEach((e)=>{
		allBus.push(e)
	  });
	} 
	if(arr.site.length&gt;0){
		arr.site.forEach((e)=>{
			allSites.push(e)
		  });
	}
	if(arr.childOrgs){ 
		arr.childOrgs.forEach((e1)=>{  
			let thisOrg=orgData.find((f)=>{
				return f.id == e1
			}); 
			allOrgs.push({"id":thisOrg.id, "name":thisOrg.name})
			getChildren(thisOrg, allApp, allBus, allOrgs, allSites)
		})
	}
	
}	

function getParents(arr, allApp, allBus, allOrgs, allSites){ 
 
 
	if(arr.applicationsUsedbyOrgUser){
		arr.applicationsUsedbyOrgUser.forEach((f)=>{
			allApp.push(f)
	  }) 
	   }
	   if(arr.applicationsUsedbyProcess){
		arr.applicationsUsedbyProcess.forEach((f)=>{
			allApp.push(f)
	  })
	   } 
	   if(arr.businessProcess){
		arr.businessProcess.forEach((e)=>{
		allBus.push(e)
	  });
	} 
	if(arr.site.length&gt;0){
		arr.site.forEach((e)=>{
			allSites.push(e)
		  });
	}
	if(arr.childOrgs){ 
		arr.parentOrgs.forEach((e1)=>{  
			let thisOrg=orgData.find((f)=>{
				return f.id == e1
			}); 
			allOrgs.push({"id":thisOrg.id, "name":thisOrg.name})
		 
			getParents(thisOrg, allApp, allBus, allOrgs, allSites)
		})
	}
 
}			
			
function drawView(orgToShowData, modelData){  
	$('#mainPanel').html(panelTemplate(orgToShowData))
	 
	initPopoverTrigger();
	initTable(orgToShowData);
	Chart()
	.container('.chart-container')
	.data(modelData)
	.svgWidth(window.innerWidth)
	.svgHeight(window.innerHeight)
	.initialZoom(0.6)
	.onNodeClick(d=> console.log(d+' node clicked'))
	.render()
	$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ $($.fn.dataTable.tables(true)).DataTable() .columns.adjust(); });
	if(modelData.length &gt;1){
		$('#hierarchyInfo').hide()
	}
}
 
function initTable(dt){
	$('#dt_supportedprocesses tfoot th').each( function () {
				 
		var protitle = $(this).text(); 
		$(this).html( '&lt;input class="procIn" type="text" placeholder="Search '+protitle+'" /&gt;' );
	
	});

	$('#dt_stakeholders tfoot th').each( function () {
		var title = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
	} );
									
		var table = $('#dt_stakeholders').DataTable({
		scrollY: "350px",
		scrollCollapse: true,
		paging: false,
		info: false,
		sort: true,
		responsive: true,
		columns: [
			{ "width": "30%" },
			{ "width": "30%" } 
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
 
	let apps=[];
	dt.allAppsUsed.forEach((d)=>{
	
	let thisorg=dt.applicationsUsedbyOrgUser.find((e)=>{
		return e.id==d.id
	})
	if(thisorg){thisorg='App Org User'}else{thisorg=''}
	let thisproc=dt.applicationsUsedbyProcess.find((e)=>{
		return e.id==d.id
	})
	if(thisproc){thisproc='Process'}else{thisproc=''}
	if(thisproc =='' &amp;&amp; thisorg==''){thisproc='Indirect'}
	apps.push({"id":d.id,"name":d.name,"description":d.description,"org":thisorg,"proc":thisproc, "parent":""})
	let appHTML=appTemplate({"id":d.id,"name":d.name,"description":d.description,"org":thisorg,"proc":thisproc, "className":"Application_Provider"})
 
	d['appHTML']=appHTML;

}); 
dt.allAppsUsedParent.forEach((d)=>{
	apps.push({"id":d.id,"name":d.name,"description":d.description,"org":"Parent","proc":"", "parent":"Parent"})
	let appHTML=appTemplate({"id":d.id,"name":d.name,"description":d.description,"org":"Parent","proc":"", "parent":"Parent","className":"Application_Provider"})
	d['appHTML']=appHTML;
})
 
 dt.allAppsUsedParent.forEach((e)=>{
	dt.allAppsUsed.push(e)
 });
 
	$('#dt_apptable tfoot th').each( function () {
		var techtitle = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+techtitle+'" /&gt;' );
	});
	var apptable = $('#dt_apptable').DataTable({
		scrollY: "350px",
		scrollCollapse: true,
		paging: false,
		info: false,
		sort: true, 
		data: dt.allAppsUsed,
		responsive: true,
		columns: [
			{ data: "appHTML", width: "250px" },
			{ data: "description", width: "800px" }
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
		apptable.columns().every( function () {
			var that = this;
	 
			$( 'input', this.footer() ).on( 'keyup change', function () {
				if ( that.search() !== this.value ) {
					that
						.search( this.value )
						.draw();
				}
			} );
		} );
  		
}

function initPopoverTrigger()
{ 
	$('.popover-trigger').popover(
	{
		container: 'body',
		html: true,
		trigger: 'focus',
		placement: 'auto',
		content: function ()
		{
			return $(this).next().html();
		}
	});
};
 	
		</xsl:template>
		<xsl:template name="GetViewerAPIPath">
			<xsl:param name="apiReport"></xsl:param>
	
			<xsl:variable name="dataSetPath">
				<xsl:call-template name="RenderAPILinkText">
					<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
	
			<xsl:value-of select="$dataSetPath"></xsl:value-of>
	
		</xsl:template>	
		
<xsl:template match="node()" mode="products">
		<xsl:variable name="thisProductType" select="$productType[name=current()/own_slot_value[slot_reference='instance_of_product_type']/value]"></xsl:variable>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"productType":[<xsl:for-each select="$thisProductType">{
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],	
		"processes":[<xsl:for-each select="own_slot_value[slot_reference='product_implemented_by_process']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>		
<xsl:template name="RenderJSMenuLinkFunctionsTEMP">
		<xsl:param name="linkClasses" select="()"/>
		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
		var esslinkMenuNames = {
			<xsl:call-template name="RenderClassMenuDictTEMP">
				<xsl:with-param name="menuClasses" select="$linkClasses"/>
			</xsl:call-template>
		}
     
		function essGetMenuName(instance) {  
			let menuName = null;
			if(instance.meta?.anchorClass) {
				menuName = esslinkMenuNames[instance.meta.anchorClass];
			} else if(instance.className) {
				menuName = esslinkMenuNames[instance.className];
			}
			return menuName;
		}
		
		Handlebars.registerHelper('essRenderInstanceMenuLink', function(instance){ 
			if(instance != null) {
                let linkMenuName = essGetMenuName(instance); 
				let instanceLink = instance.name;    
				if(linkMenuName) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
                } 
				return instanceLink;
			} else {
				return '';
			}
		});
    </xsl:template>
    <xsl:template name="RenderClassMenuDictTEMP">
		<xsl:param name="menuClasses" select="()"/>
		<xsl:for-each select="$menuClasses">
			<xsl:variable name="this" select="."/>
			<xsl:variable name="thisMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
			"<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
</xsl:stylesheet>
