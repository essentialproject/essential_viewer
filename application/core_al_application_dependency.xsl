<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
    
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider','Information_Representation','Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
		<xsl:variable name="allApp2InfoReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
    <xsl:variable name="allApplications" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]"/>
    <xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="allAPUs" select="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
    <xsl:variable name="allAppProtoInfoDirect" select="$allApp2InfoReps[name=$allAPUs/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
	
	<xsl:variable name="allAppDepInfoExchanged" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_EXCHANGE_RELATION']"/>
    <xsl:variable name="allInfo" select="/node()/simple_instance[type='Information_Representation'][name=$allAppProtoInfo/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
 
	<xsl:variable name="allInfoRepExchanges" select="$allAppDepInfoExchanged[name = $allAPUs/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
	
	<xsl:variable name="allAppProtoInfoIndirect" select="$allApp2InfoReps[name = $allInfoRepExchanges/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
   <xsl:variable name="allAppProtoInfo" select="$allAppProtoInfoDirect union $allAppProtoInfoIndirect"/>
   <xsl:variable name="allData_Acquisition_Method" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	
   <xsl:variable name="allRoadmapInstances" select="($allApplications,$allAppProtoInfo)"/>
   <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
   <!--<xsl:variable name="indirectApp2InfoReps" select="$allAppProtoInfo[name = $allInfoRepExchanges/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
	<xsl:variable name="directInfoReps" select="$allInfo[not(name = $indirectApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value)]"/> -->
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
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <script src="js/d3/d3.v5.9.7.min.js"/>
                <script src="js/dagre/dagre.min.js"></script>
                <script src="js/dagre/dagre-d3.min.js"></script>
                
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
						<xsl:value-of select="eas:i18n('Application Dependencies')"/>
				</title>
				  
				<xsl:call-template name="dataTablesLibrary"/>
				
				<!-- ***REQUIRED*** ADD THE JS LIBRARIES IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>	
				<style> 
                .clusters rect {
                          fill: #00ffd0;
                          stroke: #999;
                          stroke-width: 1.5px;
                        }

                        text {
                          font-weight: 300;
                          font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
                          font-size: 10px;
                        }

                        .node rect {
                          stroke: #999;
                          fill: #fff;
                          stroke-width: 1.5px;
                        }

                        .edgePath path {
                          stroke: #333;
                          stroke-width: 1.5px;
                        }
                		.int-block{
                			float: left;
                			padding:5px;
                			width:240px;
                			border:1pt solid #ccc;
                			border-left: 4px solid;
                			background-color:#fff;
                			margin:0px 5px 5px 0;
                			box-shadow: 1px 1px 2px rgba(0,0,0,0.25);
                			position: relative;
                		}
                		.int-block > i {
                			position: absolute;
                			bottom: 5px;
                			right: 5px
                		}
                </style>
                 
           
                 <script>
                        var nodeTemplate;
                        var removed;
                       
                        $(document).ready(function() {
							$('#appName').select2();
                            var nodeFragment = $("#node-template").html();
                            nodeTemplate = Handlebars.compile(nodeFragment);
                            
					 		var ifaceListFragment = $("#iface-list-template").html();
							ifaceListTemplate = Handlebars.compile(ifaceListFragment);
							
					 		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
							return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
						});

						
						});
						
		function redrawView() {
					console.log('Redrawing View');
					let newFocus=[];
					<!-- ***REQUIRED*** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS -->
					if(roadmapEnabled) {
						//update the roadmap status of the applications and application provider roles passed as an array of arrays
						rmSetElementListRoadmapStatus([depList]);
						
						<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
						//filter applications to those in scope for the roadmap start and end date
						inScopeApplications = rmGetVisibleElements(depList);

						inScopeApplications.forEach(function(d){
							let setApp=inscopeDepList.filter(function(e){
									return e.id == d.id;
							});	 
							d=setApp[0];
						});

                        svg.selectAll("rect").style('fill','white')
						
                        depList.forEach(function(e){
                            var inScope=inScopeApplications.filter(function(d){
                                return d.id==e.id;
                            });
                            console.log(inScope)
                            if(inScope.length&gt;0){
                                e['show']=true;
                            }else
                            {
                                e['show']=false;
                            }
                        })
						 removed=depList.filter(function(d){
                                return d.show==false
                            });
					//	console.log('newFocus'); console.log(newFocus)
					workingList=depList;
					} else {
						inScopeApplications = depList;  
                        removed=[];
					workingList=depList;
					}

					
					//console.log(inScopeApplications)
				 console.log('depList')
                 console.log(depList)
					<!-- VIEW SPECIFIC JS CALLS -->
					//update the catalogue
					//setApplicationsTable();
					let selectedfocusApp=$('#appName').val();
				//	console.log('selectedfocusApp');	console.log(selectedfocusApp)
				//	console.log('newFocus'); console.log(workingList)
					getDependencies(selectedfocusApp, workingList)
				}  	 
                </script>
                
         
                
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:if test="$isRoadmapEnabled">
						<xsl:call-template name="RenderRoadmapWidgetButton"/>
					</xsl:if>
					<div id="ess-roadmap-content-container">
						<!-- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -->
						<xsl:call-template name="RenderCommonRoadmapJavscript">
							<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
							<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
						</xsl:call-template>
						<div class="clearfix"></div>
					</div>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Dependency')"/></span>
								</h1>
                             
							</div>
						</div>
						<div class="col-xs-12">
							<select id="appName">
                            	<option name="selectOne">Choose an Application</option>
								<xsl:apply-templates select="$allApplications" mode="appOptions"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>
							</select> 
						 	<button class="btn btn-default btn-sm left-15" id="refresh"><i class="fa fa-refresh right-5"></i>Reset Image</button>
						</div>
						<div class="col-xs-12 top-15">
							<svg id="svg-canvas" width="900" height="400"></svg>
						</div>
 
						<!--Setup Closing Tags-->
					</div>
				</div>
				
				<div id="relations" class="modal fade" role="dialog">
					<div class="modal-dialog modal-lg">
				
					<!-- Modal content-->
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title"><strong>Interfaces</strong></h4>
						</div>
						<div class="modal-body">
					 		<div id="iface"></div>
							<div class="clearfix"/>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>	
			<script id="iface-list-template" type="text/x-handlebars-template">
				{{#if this.0.data}}	
				<p class="large"><strong>Application: </strong>{{this.0.appName}}</p>
				{{#if this.0.parent}}
				<p class="large"><strong>Parent Application: </strong>{{this.0.parent}}</p>
				{{/if}}
					{{#each this.0.data}}
						<div class="int-block"> 
							<i class="fa fa-file-text-o right-5"></i>{{{this.link}}}
							{{#if type}}
							<div class="text-muted small">({{type}})</div>
							{{/if}}
						</div>	 
					{{/each}}
					{{else}}
						<span>None defined</span> 
				{{/if}}
			</script>				
			<script>
			    var g; 
				var linkages=[];
				var windowWidth = $(window).innerWidth();
				var windowHeight = $(window).innerHeight();
				var svgWidth= windowWidth - 45;
				var svgHeight = windowHeight - 200;
				$('#svg-canvas').innerWidth(svgWidth);
				$('#svg-canvas').innerHeight(svgHeight);
				let width = svgWidth;
				let height = svgHeight;
			    depList=[<xsl:apply-templates select="$allApplications" mode="getApps"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates> ];    
				inscopeDepList=[<xsl:apply-templates select="$allApplications" mode="getApps"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates> ]; 
			 
				console.log('depList');
				console.log(depList);
			
				var workingList=depList;	
			
				$('#appName').on('change', function(){
					getDependencies(this.value, workingList)
				});
				
				$('#refresh').on('click', function(){
					getDependencies($('#appName').val(), workingList)
				});
				
				var svg;
				var nodeArray=[];
				var edgeArray=[];
				var parentArray=[];
				var g;
				var focusApp;
				function getDependencies(app, list){
				
					nodeArray=[];
					edgeArray=[];
					parentArray=[];
				
					list.forEach(function(d){
					var filtered = d.From.filter(function (el) {
				  		return el != null;
					});
				 
					d['From']=filtered;
					var filtered2 = d.To.filter(function (el) {
				  		return el != null;
					});
					d['To']=filtered2;
				 
				});	
				//get app
				 	focusApp=list.filter(function(d){
					return d.ApplicationID==app
				});
				
				// set-up nodes
				 
				setNodes(focusApp)
				   g = new dagreD3.graphlib.Graph({compound:true})
				  .setGraph({})
				  .setDefaultEdgeLabel(function() { return {}; });
				
				//console.log(focusApp[0])
				
				let otherContainers=nodeArray.filter(function(d){
					return d.parent !=focusApp[0].ApplicationName;
				});
				let otherContainersNotNull=otherContainers.filter(function(d){
					return d.parent !="";
				});
				
				let newContainers=[];
				otherContainersNotNull.forEach(function(d){
					//console.log(d)
					//may not need this nodeArray push
				
					//nodeArray.push({"id":d.parentId, "name":d.parent})
					newContainers.push({'name':d.parent,'id':d.parentId});
				});
				
				
				//console.log('nodeArray')
				//console.log(nodeArray)
				nodeArray.forEach(function(d){
					newContainers.forEach(function(e){
						if(e.id == d.id){
							d.parentId=e.id;
							d.parent=e.name;
						}
					});
				});
				////console.log('newContainers')
				//console.log(newContainers)
				
				let checkFocus=newContainers.filter(function(f){
					return f.id ==focusApp[0].parentID;
				})
				
				
				
				
				let uniqueNodes = uniq_fast(nodeArray);
				 
				// console.log(uniqueNodes);
				
				uniqueNodes.forEach(function(d){  
					g.setNode(d.id, {labelType: "html", label: '<div style="width: auto; height: auto;">'+d.link+'</div>', class:d.id });
				 
				});
				
				let uniquenewContainers = uniq_fast(newContainers);
				
				// push unique vals as containers, then loop the above array to add parents
				 
				uniquenewContainers.forEach(function(d){	
					g.setNode('Grp'+d.id, 
				{class: 'composite' + 'Grp'+d.id, label: d.name,  clusterLabelPos: 'top', style: 'fill: #bbc1c9', labelStyle: 'font-weight:bold; font-size:1.1em'});
				})	
				
				let nodesWithParent=otherContainers.filter(function(d){
					return d.parentId &amp;&amp; d.parentId !='';
				});
				
				setEdges(focusApp)
				
				//set contained, need to create a parent group too
				if(focusApp[0].Contained.length &gt;0){
					setContainer(focusApp)
				}
				 
				//console.log('nodesWithParent')
				//console.log(nodesWithParent)
				 
				nodesWithParent.forEach(function(d){
					//console.log('I am '+d.name+'('+d.id+')' + ' my parent is: '+'Grp'+d.parent+'('+d.parentId+')')
					g.setParent(d.id, 'Grp'+d.parentId);
				});
				
				
				if(checkFocus.length&gt;0){
					if(focusApp[0].Contained.length&gt;0){
					g.setParent('Grp' +focusApp[0].id, 'Grp'+checkFocus[0].id);
					g.setParent(focusApp[0].id, 'Grp'+focusApp[0].id);
					}
				}
				 
				//console.log(g.nodes());
				//console.log(g.edges());
				g.nodes().forEach(function(v) {
				
				
				  var node = g.node(v);
				 // console.log(node)
				  // Round the corners of the nodes
				  node.rx = node.ry = 5; 
				});
				// Create the renderer
				var render = new dagreD3.render();
				
				// Set up an SVG group so that we can translate the final graph.
				// Set up an SVG group so that we can translate the final graph.
				 svg = d3.select("svg");
					
				svg.selectAll(".clusters").remove();
				svg.selectAll(".nodes").remove();
				svg.selectAll(".edgePaths").remove();
				svg.selectAll(".edgeLabels").remove();
				
				svgGroup = svg.append("g");
				 
				svg.attr("width", width);
				
				// Run the renderer. This is what draws the final graph.
				var inner = svg.select("g");
				var zoom = d3.zoom().on("zoom", function() {
					inner.attr("transform", d3.event.transform);
				});
				svg.call(zoom);
				
				render(inner, g);
				
				// Center the graph
				//var xCenterOffset = (svg.attr("width") - g.graph().width) / 2;
				//svgGroup.attr("transform", "translate(" + xCenterOffset + ", 20)");
				svg.attr("height", g.graph().height + 40);	
				// Center the graph
				
				var padding = 20,
				  bBox = inner.node().getBBox(),
				  hRatio = height / (bBox.height + padding),
				  wRatio = width / (bBox.width + padding);
				 
				  if(g.graph().width > width){
				  widthSize = width/g.graph().width;
				  }
				  else{
					widthSize=1;
				  }
				 
				
				var initialScale = widthSize;
				svg.call(zoom.transform, d3.zoomIdentity.translate(widthSize,height).scale(1)); 
				svg.call(zoom.transform, d3.zoomIdentity.translate((svg.attr("width") - g.graph().width * initialScale) / 2, 20).scale(initialScale));
				
				bBox.width = width;
				bBox.height = height;
				g.graph().width = width;
				 
				if(removed){
					removed.forEach(function(d){
						svg.selectAll("."+d.id).selectAll("rect").style('fill','#f2f2f2')
						svg.selectAll("."+d.id).selectAll("rect").style('stroke','#d3d3d3')
						svg.selectAll("."+d.id).selectAll("path").style('stroke','#e6e6e6')
						svg.selectAll("#"+d.id+"Link").style('color','#bfbfbf')
					})
				}
				
				svg.selectAll("g.edgeLabel").on("click", function(id) {
					let focusUsing = $(this).children().children().children().children().attr('focusid');
					let appUsing = $(this).children().children().children().children().attr('easid');
					
					let typeUsing = $(this).children().children().children().children().attr('easType');
				
					modalApp=depList.filter(function(d){
						return d.ApplicationID==focusUsing;
					});
				
					let modalData=modalApp[0][typeUsing].filter(function(d){
							return d.appid == appUsing;
					});
					 	//console.log(modalData)
					$('#iface').html(ifaceListTemplate(modalData));
					$('#relations').modal('show')	
				});
				};
				
				// Create the input graph
				function uniq_fast(a) {
				    var seen = {};
				    var out = [];
				    var len = a.length;
				    var j = 0;
				    for(var i = 0; i &lt; len; i++) {
				         var item = a[i].id;
				         var itemParent=a[i];    
				         if(seen[item] !== 1) {
				               seen[item] = 1;
				               out[j++] = itemParent;
				         }
				    }
				    return out;
				}   
				
				function setNodes(appToDo){
				 //	console.log('appToDo');
				//	 console.log(appToDo);
					 if(appToDo.length &gt; 0){
					nodeArray.push({"id":appToDo[0].ApplicationID, "name":appToDo[0].ApplicationName, "parent":appToDo[0].parent,  "parentId":appToDo[0].parentID, "link":appToDo[0].link, "class":appToDo[0].ApplicationID})
					appToDo[0].From.forEach(function(app){
						nodeArray.push({"id":app.appid, "name":app.appName, "parent":app.parent, "parentId":app.parentID, "link":app.link, "class":app.appid})
						
					});
					appToDo[0].To.forEach(function(app){
						nodeArray.push({"id":app.appid, "name":app.appName, "parent":app.parent, "parentId":app.parentID, "link":app.link, "class":app.appid})
					});
					appToDo[0].Contained.forEach(function(app){
						nodeArray.push({"id":app.subId, "name":app.subName, "parent":app.parent, "parentId":app.parentID, "link":app.link, "class":app.subId})
					});
					if(appToDo[0].Contained.length &gt;0){
						appToDo[0].Contained.forEach(function(e){ 
							let newfocusApp=workingList.filter(function(sub){
								return sub.ApplicationID==e.subId
							});
						//	console.log('contained')
						//	console.log(newfocusApp)
							setNodes(newfocusApp);
						})
						}
					}
				}
				
				function setEdges(appToDo){
					//console.log('appToDoEdge');
				 //console.log(appToDo);
					// get edges for to and from nodes
					if(appToDo.length &gt; 0){
					appToDo[0].From.forEach(function(app){
						let fromHTML='';
						let fromlabel='';
				
						if(app.data){
							if(app.data.length &gt; 0){
							fromHTML='&lt;a easType="From" easId="'+app.appid+'" focusid="'+ appToDo[0].ApplicationID+'" style="text-decoration:none;color:white;font-weight:bold">'+app.data.length+'&lt;/a>';
							fromlabel="background-color:black;padding:3px;border-radius:10px; font-weight: normal;text-decoration:none;font-family:Helvetica Neue;color:#ffffff";	
							}
							else
							{
								fromHTML='';
								fromlabel="background-color:none";
							}
						}
						else
						{
							fromHTML='';
							fromlabel="background-color:none";
						}
				
						
						g.setEdge(app.appid, appToDo[0].ApplicationID, 
						{curve: d3.curveBasis, labelType: "html", label: fromHTML, 
						labelStyle: fromlabel, class: app.appid + ' ' +  appToDo[0].ApplicationID});
					});
				
					appToDo[0].To.forEach(function(app){
						let toHTML='';
						let tolabel='';
						if(app.data){ 
							if(app.data.length &gt; 0){
								toHTML='&lt;a easType="To" easId="'+app.appid+'" focusid="'+ appToDo[0].ApplicationID+'" style="text-decoration:none;color:white;font-weight:bold">'+app.data.length+'&lt;/a>';
								tolabel="background-color:black;padding:3px;border-radius:10px; font-weight: normal;text-decoration:none;font-family:Helvetica Neue;color:#ffffff";	
							}
							else
							{
								toHTML='';
								tolabel="background-color:none"
							}
						}	else
							{
								toHTML='';
								tolabel="background-color:none"
							}
						g.setEdge(appToDo[0].ApplicationID, app.appid,  
						{curve: d3.curveBasis, labelType: "html", label: toHTML,
						labelStyle: tolabel, class: app.appid + ' ' +  appToDo[0].ApplicationID});
					});
				
					if(appToDo[0].Contained.length &gt;0){
						appToDo[0].Contained.forEach(function(e){ 
							let newfocusApp=depList.filter(function(sub){
								return sub.ApplicationID==e.subId
							});
							setEdges(newfocusApp);
						
						})
					}
					}
				};
				
				function setContainer(appToDo){
					//console.log('I am '+appToDo[0].ApplicationName+'('+appToDo[0].ApplicationID+')' + ' my parent is: '+'Grp'+appToDo[0].ApplicationName+'('+appToDo[0].ApplicationID+')')
					g.setParent(appToDo[0].ApplicationID, 'Grp'+appToDo[0].ApplicationID);
				 
					appToDo[0].Contained.forEach(function(app){
				 	g.setNode('Grp'+appToDo[0].ApplicationID, {class: 'composite ' + 'Grp'+appToDo[0].ApplicationID, label: appToDo[0].ApplicationName,  clusterLabelPos: 'top', style: 'fill: #bbc1c9', labelStyle: 'font-weight:bold; font-size:1.1em'});
					g.setParent(app.subId, 'Grp'+appToDo[0].ApplicationID);
				 
					//console.log('I am '+app.subName+'('+app.subId+')' + ' my parent is: '+'Grp'+appToDo[0].ApplicationName +'('+appToDo[0].ApplicationID+')')
				 
					});
					if(appToDo[0].Contained.length &gt;0){
						appToDo[0].Contained.forEach(function(e){ 
							let newfocusApp=depList.filter(function(sub){
								return sub.ApplicationID==e.subId
							});
						 
							//set contained, need to create a parent group too
							if(newfocusApp.length &gt;0){
								if(newfocusApp[0].Contained.length &gt;0){
									//console.log('new parents')
									//console.log(newfocusApp[0].ApplicationID+":"+newfocusApp[0].ApplicationName+" - "+newfocusApp[0].ApplicationName+":"+'Grp'+newfocusApp[0].ApplicationID)
									let inScope=workingList.filter(function(d){
										return d.id==newfocusApp[0].ApplicationID;		
									})
									console.log('inScope');console.log(inScope)
									g.setParent('Grp' +newfocusApp[0].ApplicationID, 'Grp'+appToDo[0].ApplicationID);
									setContainer(newfocusApp)
				
								} 
							}
						})
					}
				};
					
				function removeDups(arr){
				 
				const result = [];
				const map = new Map();
				for (const item of arr) {
				    if(!map.has(item.link)){
				        map.set(item.link, true);    // set any value to Map
				        result.push({
				            link: item.link
				        });
				    }
				}
				return result.length;
						}	
				
			</script>            
            	<xsl:call-template name="nodeHandlebarsTemplate"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
    
<xsl:template name="nodeHandlebarsTemplate">
		<script id="node-template" type="text/x-handlebars-template">
              <div class="card" style='float:left'>
                  <div class="card-header">{{this.node}}</div>
                            <div class="card-main">
                                <div class="main-description"><xsl:attribute name="onclick">getChart('{{this.node}}',{{this.containedInstance}});</xsl:attribute><span class="badge badge-info" style="background-color:#7b8dc9">{{this.containedInstance}}</span></div>
                            </div>
                            <div class="card-tech">
                                <div class="tech-description">{{this.node_technology}}</div>
                            </div>
                        </div>

        </script>
	</xsl:template>    
    <xsl:template match="node()" mode="getApps">
    <xsl:variable name="usages" select="$allArchUsages[own_slot_value[slot_reference='static_usage_of_app_provider']/value=current()/name]"/>    
    <xsl:variable name="subApps" select="$allApplications[name=current()/own_slot_value[slot_reference='contained_application_providers']/value]"/>   
        <xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=current()/name]"/>
	 {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
	 <xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
		 "ApplicationName": "<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="current()"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
	</xsl:call-template>",
		"ApplicationID": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>","From":[<xsl:apply-templates select="$usages" mode="getFromUsages"/>],"To":[<xsl:apply-templates select="$usages" mode="getToUsages"/>],
	"parent":"<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="$parent"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
	</xsl:call-template>", "parentID":"<xsl:value-of select="$parent/name"/>",
    "Contained":[<xsl:apply-templates select="$subApps" mode="getContainedApps"/>]},     
    </xsl:template>
     <xsl:template match="node()" mode="getToUsages">
         <xsl:variable name="TOs" select="$allAPUs[own_slot_value[slot_reference=':TO']/value=current()/name]"/>    
	  <!--Usage:<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/><br/>-->
	  <xsl:if test="$TOs">
		 <xsl:apply-templates select="$TOs" mode="gettoAPU"><xsl:with-param name="to" select="current()"/></xsl:apply-templates><xsl:if test="not(position()=last())">,</xsl:if>
		 </xsl:if>
    </xsl:template> 
    <xsl:template match="node()" mode="getFromUsages">
          <xsl:variable name="FROMs" select="$allAPUs[own_slot_value[slot_reference=':FROM']/value=current()/name]"/>    
        <xsl:apply-templates select="$FROMs" mode="getfromAPU"></xsl:apply-templates>
    </xsl:template> 
    
	<xsl:template match="node()" mode="gettoAPU">
	<xsl:param name="to"/>
        <xsl:variable name="ArchUsages" select="$allArchUsages[name=current()/own_slot_value[slot_reference=':FROM']/value]"/>
        <xsl:variable name="thisApplication" select="$allApplications[name=$ArchUsages/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
        <xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=$thisApplication/name]"/>
        <xsl:variable name="thisAppProtoInfo" select="$allAppProtoInfo[name=current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
	 
	<xsl:variable name="thisInfoRepExchanges" select="$allAppDepInfoExchanged[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
	<xsl:variable name="thisindirectApp2InfoReps" select="$allAppProtoInfo[name = $thisInfoRepExchanges/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
		
	<xsl:variable name="allthisInfo" select="$thisindirectApp2InfoReps union $thisAppProtoInfo"/>	
		
	<xsl:variable name="thisInfo" select="$allInfo[name=$thisindirectApp2InfoReps/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
        <xsl:if test="$thisApplication/name">
        { <xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
	 <xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="$thisApplication"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"appid":"<xsl:value-of select="eas:getSafeJSString($thisApplication/name)"/>",
			"appName":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$thisApplication"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/></xsl:call-template>", 
			"parent":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$parent"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>", 
			"parentID":"<xsl:value-of select="eas:getSafeJSString($parent/name)"/>", 
			"data":[<xsl:apply-templates select="$allthisInfo" mode="dataPassing"><xsl:with-param name="acquisitionType" select="current()/own_slot_value[slot_reference='apu_to_apu_relation_inforep_acquisition_method']/value"/></xsl:apply-templates>]},</xsl:if>
    </xsl:template> 
     <xsl:template match="node()" mode="getfromAPU">
         <xsl:variable name="ArchUsages" select="$allArchUsages[name=current()/own_slot_value[slot_reference=':TO']/value]"/>
         <xsl:variable name="thisApplication" select="$allApplications[name=$ArchUsages/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
          <xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=$thisApplication/name]"/>
         <xsl:variable name="thisAppProtoInfo" select="$allAppProtoInfo[name=current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
		 <xsl:variable name="thisInfoRepExchanges" select="$allAppDepInfoExchanged[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
	<xsl:variable name="thisindirectApp2InfoReps" select="$allAppProtoInfo[name = $thisInfoRepExchanges/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
		
	<xsl:variable name="allthisInfo" select="$thisindirectApp2InfoReps union $thisAppProtoInfo"/>	
		
	<xsl:variable name="thisInfo" select="$allInfo[name=$thisindirectApp2InfoReps/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
           <xsl:if test="$thisApplication/name">
               {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
	 <xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="$thisApplication"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			   "appid":"<xsl:value-of select="eas:getSafeJSString($thisApplication/name)"/>",
			   "appName":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$thisApplication"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>","link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/></xsl:call-template>", 
			"parent":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$parent"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",  "parentID":"<xsl:value-of select="eas:getSafeJSString($parent/name)"/>", "data":[<xsl:apply-templates select="$allthisInfo" mode="dataPassing"><xsl:with-param name="acquisitionType" select="current()/own_slot_value[slot_reference='apu_to_apu_relation_inforep_acquisition_method']/value"/></xsl:apply-templates>]},</xsl:if>
    </xsl:template> 
    <xsl:template match="node()" mode="dataPassing">
	<xsl:param name="acquisitionType"/>
     <xsl:variable name="thisInfo" select="$allInfo[name=current()/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
		{"name": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$thisInfo"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString($thisInfo/name)"/>",
		"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>",
		"type":"<xsl:value-of select="$allData_Acquisition_Method[name=$acquisitionType]/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"debugdata":"<xsl:value-of select="current()/name"/>"}, 
    </xsl:template>
    <xsl:template match="node()" mode="getContainedApps">
         <xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=current()/name]"/>
        {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
	 <xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"subId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","subName":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>", 
		"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"parent":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$parent"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>", "parentID":"<xsl:value-of select="eas:getSafeJSString($parent[1]/name)"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template> 
    <xsl:template match="node()" mode="appList">
        {"appName":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","appId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template> 
     <xsl:template match="node()" mode="appOptions">
         <xsl:variable name="ID" select="eas:getSafeJSString(current()/name)"/>
         <xsl:variable name="Name" select="current()/own_slot_value[slot_reference='name']/value"/>            
        <option name="{$Name}" value="{$ID}"><xsl:value-of select="$Name"/></option>
    </xsl:template> 
    
     <xsl:template match="node()" mode="getNodes">
         <xsl:variable name="this" select="current()"/>
            {"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","label":"<xsl:value-of select="$this/own_slot_value[slot_reference='technology_instance_given_name']/value"/>","length":"<xsl:value-of select="string-length($this/own_slot_value[slot_reference='technology_instance_given_name']/value)"/>","class":"<xsl:value-of select="type"/>"},
    </xsl:template> 
</xsl:stylesheet>
