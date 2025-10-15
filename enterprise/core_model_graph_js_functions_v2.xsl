<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>
	
	
	<xsl:template name="RenderModelGraphStyle">
		<style type="text/css">
			
			.graphSeparator {
			  margin: 3px;
			  padding: 3px;
			  height: 2px;
			 }
			
			.svgContainer {
				display: block;
			    margin: auto;
			}
			
			.links line {
			  stroke: #999;
			  stroke-opacity: 0.6;
			}
			
			.node-rect {
				width: 100%;
				text-align: center;
			}
			
			.wordwrap {
				white-space: pre-wrap; /* CSS3 */
				white-space: -moz-pre-wrap; /* Firefox */
				white-space: -pre-wrap; /* Opera &lt;7 */
				white-space: -o-pre-wrap; /* Opera 7 */
				word-wrap: break-word; /* IE */
			}
			
			.node-type {
				font-size: 10px;
				text-transform: uppercase;
				color: white;
				text-align: center;
				width: 100%;
			}
			
			.node-link {
				width: 20px;
				height: 20px;
				stroke-width: 1.5px;
			}
			
			.node-name a {
				margin-top: 4px;
				font-size: 13px;
				color: white;
				text-align: center;
				width: 100%;
			}
			
			.graph-model-button {
				margin-top: 10px;
				width: 90%;
				text-align: center;
			}
			
			.selected {
			  fill: red;
			}
			
			.hovered {
				opacity: 0.7;
			}
			
			.impact-graph-node:hover {
				cursor: pointer;
			}
			
			.edgePath path.path {
				stroke: #333;
				fill: none;
				stroke-width: 1.5px;
			}
		</style>
	</xsl:template>

	<xsl:template name="RenderModelGraphJS">
		<script id="graph-model-element-template" type="text/x-handlebars-template">
			{{#if type.isLink}}
				<div class="node-link">
					<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
					<xsl:attribute name="style">background-color:{{type.colour}};</xsl:attribute>
				</div>
			{{else}}
				<div class="node-rect">
					<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
					<xsl:attribute name="style">background-color:{{type.colour}};</xsl:attribute>
					<span class="node-type wordwrap uppercase">{{type.label}}</span>
					<hr class="graphSeparator"/>
					<span class="node-name wordwrap"><b>{{{link}}}</b></span>
					<button class="graphButton" data-toggle="modal">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						<xsl:attribute name="eas-elements">{{type.list}}</xsl:attribute>
						<xsl:attribute name="class">alignLeft graph-model-button btn btn-xs modal_action_button {{#if hasPlan}}btn-primary{{else}}btn-default{{/if}}</xsl:attribute>
						{{#if hasPlan}}{{planningAction.name}}{{else}}{{type.defaultButton}}{{/if}}					
					</button>
				</div>
			{{/if}}
		</script>
		
		<!--<script src="js/d3/d3.v5.7.0.min.js"/>-->
		<script type="text/javascript" src="js/d3/d3.v5.9.7.min.js"/>
		<script type="text/javascript" src="js/dagre/dagre-d3.min.js"/>
		
		<script>
			var data = {
			   "nodes":[],
			   "relations": [],
			   "links": [],
			   "linkRefs": []
			}
			
			//funtions to update the graph model for a given physical process
			function addAppProRoleModelData(anAppProRole) {
				var anAppService, anApp, linkRef, aLink;
			
				if(data.relations.indexOf(anAppProRole) &lt; 0) {
					populateAppProRoleObjects(anAppProRole);
					
					if((anAppProRole.serviceId.length + anAppProRole.appId.length) > 0) {
						data.relations.push(anAppProRole);
						
						//add the app service node
						anAppService = anAppProRole.service;
						if(anAppService != null) {
							if(data.nodes.indexOf(anAppService) &lt; 0) {
								data.nodes.push(anAppService);
							}
							
							//add the app pro role to app service link
							linkRef = anAppProRole.id + anAppService.id;
							if(data.linkRefs.indexOf(linkRef) &lt; 0) {
								data.linkRefs.push(linkRef);
								aLink = {
										source: anAppProRole.id,
										target: anAppService.id
								};
								data.links.push(aLink);
							}
						}
						
						
						//add the app  node
						anApp = anAppProRole.application;
						if(anApp != null) {
							if(data.nodes.indexOf(anApp) &lt; 0) {
								data.nodes.push(anApp);
							}
							
							//add the app pro role to app link
							linkRef = anAppProRole.id + anApp.id;
							if(data.linkRefs.indexOf(linkRef) &lt; 0) {
								data.linkRefs.push(linkRef);
								aLink = {
										source: anAppProRole.id,
										target: anApp.id
								};
								data.links.push(aLink);
							}
						}	
					}
				}
			}
			
			
			
			//funtions to update the graph model for a given physical process
			function addPhysProcModelData(aPhysProc) {
			
				var aBusProcess, theBusCaps, aBusCap, anOrg, theAppProRoles, anAppProRole, theApps, anApp, linkRef, aLink;
			
				if(data.relations.indexOf(aPhysProc) &lt; 0) {
					populatePhysProcObjects(aPhysProc);
				
					if((aPhysProc.busProcessId.length + aPhysProc.orgId.length) > 0) {
						//add the physical process
						data.relations.push(aPhysProc);
						
						aBusProcess = aPhysProc.busProcess;
						if(aBusProcess != null) {
						
							//add a business process node
							if(data.nodes.indexOf(aBusProcess) &lt; 0) {					
								data.nodes.push(aBusProcess);
								
								populateBusProcessLists(aBusProcess);
								theBusCaps = aBusProcess.busCaps;
								for (var i = 0; theBusCaps.length > i; i += 1) {
									aBusCap = theBusCaps[i];
									
									if(data.nodes.indexOf(aBusCap) &lt; 0) {
										data.nodes.push(aBusCap);
									}
									
									//add the bus cap to busproc link
									linkRef = aBusCap.id + aBusProcess.id;
									if(data.linkRefs.indexOf(linkRef) &lt; 0) {
										data.linkRefs.push(linkRef);
										aLink = {
											source: aBusCap.id,
											target: aBusProcess.id
										};
										data.links.push(aLink);
									}
								}
							}
							
							//add the phys proc to bus proc link
							linkRef = aBusProcess.id + aPhysProc.id;
							if(data.linkRefs.indexOf(linkRef) &lt; 0) {
								data.linkRefs.push(linkRef);
								aLink = {
										source: aPhysProc.id,
										target: aBusProcess.id
								};
								data.links.push(aLink);
							}
						}
						
						//add the org node
						anOrg = aPhysProc.org;
						if(anOrg != null) {
							if(data.nodes.indexOf(anOrg) &lt; 0) {
								data.nodes.push(anOrg);
							}
							
							//add the phys proc to org link
							linkRef = anOrg.id + aPhysProc.id;
							if(data.linkRefs.indexOf(linkRef) &lt; 0) {
								data.linkRefs.push(linkRef);
								aLink = {
										source: aPhysProc.id,
										target: anOrg.id
								};
								data.links.push(aLink);
							}														
						}
						
						//add supporting app pro roles
						theAppProRoles = aPhysProc.appProRoles;
						for (var j = 0; theAppProRoles.length > j; j += 1) {
							anAppProRole = theAppProRoles[j];
							addAppProRoleModelData(anAppProRole);
							
							//add the phys proc to app pro role link
							linkRef = anAppProRole.id + aPhysProc.id;
							if(data.linkRefs.indexOf(linkRef) &lt; 0) {
								data.linkRefs.push(linkRef);
								aLink = {
										source: aPhysProc.id,
										target: anAppProRole.id
								};
								data.links.push(aLink);
							}
						}
						
						//add supporting apps
						theApps = aPhysProc.applications;
						for (var j = 0; theApps.length > j; j += 1) {
							anApp = theApps[j];
							
							if(data.nodes.indexOf(anApp) &lt; 0) {
								data.nodes.push(anApp);
							}
							
							//add the phys proc to app link
							linkRef = anApp.id + aPhysProc.id;
							if(data.linkRefs.indexOf(linkRef) &lt; 0) {
								data.linkRefs.push(linkRef);
								aLink = {
										source: aPhysProc.id,
										target: anApp.id
								};
								data.links.push(aLink);
							}
						}
					}				
				}
				
			}
			
			
			function updateGraphModelData() {
				//reset the graph data
				data = {
				   "nodes":[],
				   "relations": [],
				   "links": [],
				   "linkRefs": []
				}
				
				var inScopeBusProcIds = getObjectIds(dynamicUserData.currentPlanningActions.busProcesses, "id")
				var busProcPhysProcs = getObjectsByIds(viewData.physProcesses, "busProcessId", inScopeBusProcIds);
				
				var inScopeOrgIds = getObjectIds(dynamicUserData.currentPlanningActions.organisations, "id")
				var orgPhysProcs = getObjectsByIds(viewData.physProcesses, "orgId", inScopeOrgIds);
				
				var aPhysProc;
				var allPhysProcs = busProcPhysProcs.concat(orgPhysProcs).unique();
				for (var i = 0; allPhysProcs.length > i; i += 1) {
					aPhysProc = allPhysProcs[i];
					addPhysProcModelData(aPhysProc);
				}
				
				var appSvcIds = getObjectIds(dynamicUserData.currentPlanningActions.appServices, "id")
				var appSvcAPRs = getObjectsByIds(viewData.appProviderRoles, "serviceId", appSvcIds);
				
				var appIds = getObjectIds(dynamicUserData.currentPlanningActions.applications, "id")
				var appAPRs = getObjectsByIds(viewData.appProviderRoles, "appId", appIds);
				
				var anAppProRole;
				var allAppProRoles = appSvcAPRs.concat(appAPRs).unique();
				for (var j = 0; allAppProRoles.length > j; j += 1) {
					anAppProRole = allAppProRoles[j];
					addAppProRoleModelData(anAppProRole);
				}
			
			}
			
			var elementTypes = {
				"busCap": {
					"list": "busCaps",
					"colour": 'black',
					"label": 'Business Capability',
					"defaultButton": "View",
					"isLink": false,
					"essClass": 'Business_Capability'
				},
				"busProcess": {
					"list": "busProcesses",
					"colour": '#5cb85c',
					"label": 'Business Process',
					"defaultButton": "No Change",
					"isLink": false,
					"essClass": 'Business_Process'
				},
				"physProcess": {
					"list": "physProcesses",
					"colour": '#5cb85c',
					"label": 'Physical Process',
					"defaultButton": "No Change",
					"isLink": true,
					"essClass": 'Physical_Process'
				},
				"organisation": {
					"list": "organisations",
					"colour": '#9467bd',
					"label": 'Organisation',
					"defaultButton": "No Change",
					"isLink": false,
					"essClass": 'Group_Actor'
				},
				"appService": {
					"list": "appServices",
					"colour": '#4ab1eb',
					"label": 'Application Service',
					"defaultButton": "No Change",
					"isLink": false,
					"essClass": 'Application_Service'
				},
				"appProRole": {
					"list": "appProviderRoles",
					"colour": '#4ab1eb',
					"label": 'Application Function',
					"defaultButton": "No Change",
					"isLink": true,
					"essClass": 'Application_Provider_Role'
				},
				"application": {
					"list": "applications",
					"colour": '#337ab7',
					"label": 'Application',
					"defaultButton": "No Change",
					"isLink": false,
					"essClass": 'Composite_Application_Provider'
				}
			}
			
			
			var data = {
			   "nodes":[  
			      {  
			         "name":"Abc",
			         "id":"1",
			         "type": elementTypes.application,
			         "hasPlan":true,
			         "planningAction": {"name": "Replace"},
			         "selected": false
			      },
			      {  
			         "name":"Aaa",
			         "id":"2",
			         "type": elementTypes.busProcess,
			         "hasPlan":true,
			         "planningAction": {"name": "Enhance"},
			         "selected": false
			      },
			      {  
			         "name":"JTY",
			         "id":"3",
			         "type": elementTypes.organisation,
			         "hasPlan":true,
			         "planningAction": {"name": "Outsource"},
			         "selected": false
			      },
			      {  
			         "name":"MMM",
			         "id":"5",
			         "type": elementTypes.application,
			         "hasPlan":true,
			         "planningAction": {"name": "Outsource"},
			         "selected": false
			      },
			      {  
			         "name":"KLI",
			         "id":"6",
			         "type": elementTypes.busProcess,
			         "hasPlan":false,
			         "planningAction": {"name": "Enhance"},
			         "selected": false
			      },
			      {  
			         "name":"Tasqu",
			         "id":"8",
			         "type": elementTypes.organisation,
			         "hasPlan":true,
			         "planningAction": {"name": "Reduce"},
			         "selected": false
			      },
			      {  
			         "name":"Mii",
			         "id":"9",
			         "type": elementTypes.application,
			         "hasPlan":true,
			         "planningAction": {"name": "Outsource"},
			         "selected": false
			      },
			      {  
			         "name":"YrA",
			         "id":"11",
			         "type": elementTypes.busProcess,
			         "hasPlan":true,
			         "planningAction": {"name": "Standardise"},
			         "selected": false
			      },
			      {  
			         "name":"Tarb",
			         "id":"10",
			         "type": elementTypes.application,
			         "hasPlan":true,
			         "planningAction": {"name": "Outsource"},
			         "selected": false
			      }
			   ],
			   "relations":[
			      {  
			         "name":"TTT",
			         "id":"4",
			         "type": elementTypes.appProRole,
			         "hasPlan":false,
			         "planningAction": {"name": "Standardise"},
			         "selected": false
			      },
			      {  
			         "name":"OTP",
			         "id":"7",
			         "type": elementTypes.physProcess,
			         "hasPlan":true,
			         "planningAction": {"name": "Remove"},
			         "selected": false
			      }
			   ],
			   "links":[  
			      {  
			         "source":"2",
			         "target":"1"
			      },
			      {  
			         "source":"3",
			         "target":"1"
			      },
			      {  
			         "source":"4",
			         "target":"1"
			      },
			      {  
			         "source":"5",
			         "target":"1"
			      },
			      {  
			         "source":"6",
			         "target":"1"
			      },
			      {  
			         "source":"7",
			         "target":"2"
			      },
			      {  
			         "source":"8",
			         "target":"3"
			      },
			      {  
			         "source":"9",
			         "target":"4"
			      },
			      {  
			         "source":"11",
			         "target":"5"
			      },
			      {  
			         "source":"10",
			         "target":"11"
			      }
			   ]
			};
			
			var gmElementPlanTemplate, gmGraphSearchTemplate;
			
			var svg, g, nodes, node, relations, relation, link, simulation, link_force, charge_force, center_force, zoom_handler;
			
			var rectWidth = 240;
			var rectHeight = 95;
			var circleRadius = 30;
			var textMargin = 5;
			var minDistance = Math.sqrt(rectWidth*rectWidth + rectHeight*rectHeight);
			
			var allNodes;
			
			function refreshGraphModel() {
				if(svg != null) {
					svg.selectAll("*").remove();
					drawModelGraph();
					updateStrategicPlanElementsTable();
				}
			}
				
			function clearGraphModel() {
				if(svg != null) {
					svg.selectAll("*").remove();
				}
			}
			
			function drawModelGraph() {
				drawStrategicPlanElementsTable();
			
				updateGraphModelData();
				
				renderModelGraph();
				
				$('.graph-model-button').on('click', function (evt) {
				
					var elementId = $(this).attr('eas-id');
					var elementList = $(this).attr('eas-elements');
					var element = getObjectById(viewData[elementList], "id", elementId);
					
					nextModalElement = element;

					$('#' + nextModalElement.editorId).modal('show');			
					
				});
			}
			
			function renderModelGraph() {
			
				if(gmElementPlanTemplate == null) {
					var gmElementPlanFragment = $("#graph-model-element-template").html();
					gmElementPlanTemplate = Handlebars.compile(gmElementPlanFragment);
				}
				
				//collate the list of elements to be displayed in  the graph
				allNodes = data.nodes.concat(data.relations);
				
				//console.log('ALL NODES');
				//console.log(allNodes);
				
				var g = new dagreD3.graphlib.Graph().setGraph({
					//nodesep: 70,
					//ranksep: 50,
					//rankdir: "RL",
					//marginx: 20,
					//marginy: 20
				});
				
				allNodes.forEach(function(impactNode) {
					g.setNode(impactNode.id, {
						labelType: "html",
						label: gmElementPlanTemplate(impactNode),
						rx: 10,
						ry: 10,
						padding: 2,
						margin: 3,
						style: "stroke-width: 1px;",
						class: "impact-graph-node"
					});
				});
				
				data.links.forEach(function(link) {
					g.setEdge(link.source, link.target, { 
						style: "stroke: black; stroke-width: 2px; stroke-dasharray: 5, 5;",
						curve: d3.curveBasis
					});
				});
				
				// Create the renderer
				let render = new dagreD3.render();
				
				// Set up an SVG group so that we can translate the final graph.
				svg = d3.select("#stratPlanningGraph"),
				inner = svg.append("g");
				
				// Set up zoom support
				let zoom = d3.zoom()
					.on("zoom", function() {
						inner.attr("transform", d3.event.transform);
					});
				svg.call(zoom);
				
				// Run the renderer. This is what draws the final graph.
				render(inner, g);
				
				inner
				.selectAll(".impact-graph-node")
				.on("click", function(id) {
					let d = allNodes.find(function(aNode) {
						return aNode.id == id;
					});
					if(d &amp;&amp; d.hasPlan &amp;&amp; !(d.inRoadmap)) {
						if(d.selected) {
							d3.select(this).select("rect").classed("selected", false);
						} else {
							d3.select(this).select("rect").classed("selected", true);
						}
						addStratPlanElement(d);
					}			
				});
			
				// Center the graph
				var initialScale = 1;
				svg.call(zoom.transform, d3.zoomIdentity.translate((svg.attr("width") - g.graph().width * initialScale) / 2, 20).scale(initialScale));
				
				svg.attr('height', 600);
			
			}
			
		</script>
		
	</xsl:template>
	
	
	<xsl:template name="RenderModelGraphSVG">
		<!-- Handlebars template for the list of graph elements to search -->
		<script id="graph-model-search-template" type="text/x-handlebars-template">
			<option/>
			{{#each elements}}
				<option>
					<xsl:attribute name="value">{{id}}</xsl:attribute>
					{{name}}
				</option>
			{{/each}}
		</script>
		<!--<div class="pull-left">
			<span class="right-15"><strong><xsl:value-of select="eas:i18n('Search:')"/></strong></span>
			<select id="graphModelSearch" style="width:300px;" class="select2"/>
		</div>-->
		<!--<div class="pull-right">
			<!-\-<div class="pull-left">
				<span class="right-15"><strong><xsl:value-of select="eas:i18n('Hide Unchanged Elements:')"/></strong></span>
				<input class="" type="checkbox"/>
			</div>-\->
			<div class="btn-group pull-left left-15">
				<button id="resetZoom" class="btn btn-sm btn-default"><xsl:value-of select="eas:i18n('Reset Zoom')"/></button>	
				<!-\-<button class="btn btn-sm btn-default"><i class="fa fa-minus"/></button>
				<button class="btn btn-sm btn-default"><i class="fa fa-plus"/></button>-\->
			</div>
		</div>-->
		<svg id="stratPlanningGraph" class="top-15" width="2000" height="1500"></svg>
	</xsl:template>
	
	
	
</xsl:stylesheet>
