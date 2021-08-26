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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="thisBusCap" select="/node()/simple_instance[name=$param1]"/>
    <xsl:variable name="allBusCaps" select="/node()/simple_instance[type='Business_Capability']"/>
    <xsl:variable name="relatedBusProcesses" select="/node()/simple_instance[type='Business_Process'][own_slot_value[slot_reference='realises_business_capability']/value=$thisBusCap/name]"/>
    <xsl:variable name="relatedAppservtoPro" select="/node()/simple_instance[type='APP_SVC_TO_BUS_RELATION'][own_slot_value[slot_reference='appsvc_to_bus_to_busproc']/value=$relatedBusProcesses/name]"/>
    <xsl:variable name="relatedAppserv" select="/node()/simple_instance[type='Application_Service'][own_slot_value[slot_reference='supports_business_process_appsvc']/value=$relatedAppservtoPro/name]"/>
    <xsl:variable name="relatedAppPro" select="/node()/simple_instance[((type = 'Application_Provider') or (type = 'Composite_Application_Provider'))]"/>
    <xsl:variable name="relatedAppProviaRole" select="/node()/simple_instance[type='Application_Provider_Role'][name=$relatedAppserv/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
    <xsl:variable name="relatedAppDeployment" select="/node()/simple_instance[type='Application_Deployment']"/>
    
    <xsl:variable name="relatedPhysBusProcesses" select="/node()/simple_instance[type='Physical_Process'][own_slot_value[slot_reference='implements_business_process']/value=$relatedBusProcesses/name]"/>
    <xsl:variable name="relatedAppProtoBus" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value=$relatedPhysBusProcesses/name]"/>
	<!--
		* Copyright © 2008-2020 Enterprise Architecture Solutions Limited.
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
	<!-- view based on https://bl.ocks.org/mapio/53fed7d84cd1812d6a6639ed7aa83868 
        Released under the GNU General Public License, version 3. -->
    


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
				<title>Business Capability to Technology (Force)</title>
                    <style>
                    .link { fill: none; stroke: #666; stroke-width: 1.5px; } 
                    .node circle { stroke: #fff; stroke-width: 1.5px; } 
                     text { font: 10px sans-serif; pointer-events: none; }

                    </style>
				<script src="js/d3/d3.v5.7.0.min.js"/>
			</head>
			<body>
	

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Capability to Application Deployments for </span>
									<span class="text-primary"><xsl:value-of select="$thisBusCap/own_slot_value[slot_reference='name']/value"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
						<span class="right-15"><i class="fa fa-circle right-5" style="color:#848ced"/>Business Capability</span> 	
                        <span class="right-15"><i class="fa fa-circle right-5" style="color:#a2a2aa"/>Business Process </span>	
                        <span class="right-15"><i class="fa fa-circle right-5" style="color:#40d040"/>Application Services</span>
                        <span class="right-15"><i class="fa fa-circle right-5" style="color:#fac769"/>Application</span>
                        <span class="right-15"><i class="fa fa-circle right-5" style="color:#e27878"/>Application Deployments</span>
						<div class="simple-scroller">
							<svg id="model" height="100%" width="100%"/>
						</div>
                                              
				        

                        <script>
                        var width = screen.width;
                        var height = 600;
                        var color = d3.scaleOrdinal(d3.schemeCategory10);
                           var links = [<xsl:apply-templates select="$thisBusCap" mode="buscaps"/>];
                           var nodeArray=[];
                           var nodeList=links.forEach(function(d){
                            var thisNew={};
                            var thisNewTarget={};
                            thisNew["id"]=d.source;
                            thisNew["group"]=d.value;
                            thisNew["colour"]=d.col;
                            thisNew["type"]=d.type;
                            thisNew["class"]=d.class;
                            thisNewTarget["id"]=d.target;
                            thisNewTarget["group"]=d.value;
                            thisNewTarget["type"]=d.type;
                            thisNewTarget["class"]=d.targetclass;
                            nodeArray.push(thisNew);
                            nodeArray.push(thisNewTarget);
                            })    

                            <!-- get unique values -->   
                            temp = {}
                                for (var i = 0; i &lt; nodeArray.length; i++) {    
                                    temp[nodeArray[i].id] = nodeArray[i];
                                }

                                nodeArray = [];   
                                for (var o in temp) {
                                    nodeArray.push(temp[o]);

                                }

                            graph={
                            "nodes":nodeArray,
                            "links":links
                            }

                        console.log(graph);    

                        var label = {
                            'nodes': [],
                            'links': []
                        };

                        graph.nodes.forEach(function(d, i) {
                            label.nodes.push({node: d});
                            label.nodes.push({node: d});
                            label.links.push({
                                source: i * 2,
                                target: i * 2 + 1
                            });
                        });

                        var labelLayout = d3.forceSimulation(label.nodes)
                            .force("charge", d3.forceManyBody().strength(-50))
                            .force("link", d3.forceLink(label.links).distance(0).strength(2));

                        var graphLayout = d3.forceSimulation(graph.nodes)
                            .force("charge", d3.forceManyBody().strength(-3000))
                            .force("center", d3.forceCenter(width / 2, height / 2))
                            .force("x", d3.forceX(width / 2).strength(1))
                            .force("y", d3.forceY(height / 2).strength(1))
                            .force("link", d3.forceLink(graph.links).id(function(d) {return d.id; }).distance(50).strength(1))
                            .on("tick", ticked);

                        var adjlist = [];

                        graph.links.forEach(function(d) {
                            adjlist[d.source.index + "-" + d.target.index] = true;
                            adjlist[d.target.index + "-" + d.source.index] = true;
                        });

                        function neigh(a, b) {
                            return a == b || adjlist[a + "-" + b];
                        }


                        var svg = d3.selectAll("#model").attr("width", width).attr("height", height);
                        var container = svg.append("g");

                        svg.call(
                            d3.zoom()
                                .scaleExtent([.1, 4])
                                .on("zoom", function() { container.attr("transform", d3.event.transform); })
                        );

                        var link = container.append("g").attr("class", "links")
                            .selectAll("line")
                            .data(graph.links)
                            .enter()
                            .append("line")
                            .attr("stroke", "#aaa")
                            .attr("stroke-width", "1px");

                        var node = container.append("g").attr("class", "nodes")
                            .selectAll("g")
                            .data(graph.nodes)
                            .enter()
                            .append("circle")
                            .attr("r", 5)
                            .attr("fill", function(d) {
                                    if(d.class==='Business_Capability'){return '#848ced';}
                                    else if(d.class==='Business_Process'){return '#a2a2aa';}
                                    else if(d.class==='AppsviaProc'){return '#fac769';}
                                    else if(d.class==='Application_Service'){return '#40d040'}
                                    else if(d.class==='Composite_Application_Provider'){return '#fac769'}
                                    else if(d.class==='Application_Provider'){return '#fac769'}
                                    else if(d.class==='Application_Deployment'){return '#e27878'}

                            })

                        node.on("mouseover", focus).on("mouseout", unfocus);

                        node.call(
                            d3.drag()
                                .on("start", dragstarted)
                                .on("drag", dragged)
                                .on("end", dragended)
                        );

                        var labelNode = container.append("g").attr("class", "labelNodes")
                            .selectAll("text")
                            .data(label.nodes)
                            .enter()
                            .append("text")
                            .text(function(d, i) { return i % 2 == 0 ? "" : d.node.id.replace(/_/g, " "); })
                            .style("fill", "#555")
                            .style("font-family", "Source Sans Pro")
                            .style("font-size", 12)
                            .style("pointer-events", "none"); // to prevent mouseover/drag capture

                        node.on("mouseover", focus).on("mouseout", unfocus);

                        function ticked() {

                            node.call(updateNode);
                            link.call(updateLink);

                            labelLayout.alphaTarget(0.3).restart();
                            labelNode.each(function(d, i) {
                                if(i % 2 == 0) {
                                    d.x = d.node.x;
                                    d.y = d.node.y;
                                } else {
                                    var b = this.getBBox();;

                                    var diffX = d.x - d.node.x;
                                    var diffY = d.y - d.node.y;

                                    var dist = Math.sqrt(diffX * diffX + diffY * diffY);

                                    var shiftX = b.width * (diffX - dist) / (dist * 2);
                                    shiftX = Math.max(-b.width, Math.min(0, shiftX));
                                    var shiftY = 16;
                                    this.setAttribute("transform", "translate(" + shiftX + "," + shiftY + ")");
                                }
                            });
                            labelNode.call(updateNode);

                        }

                        function fixna(x) {
                            if (isFinite(x)) return x;
                            return 0;
                        }

                        function focus(d) {
                            var index = d3.select(d3.event.target).datum().index;
                            node.style("opacity", function(o) {
                                return neigh(index, o.index) ? 1 : 0.1;
                            });
                            labelNode.attr("display", function(o) {
                              return neigh(index, o.node.index) ? "block": "none";
                            });
                            link.style("opacity", function(o) {
                                return o.source.index == index || o.target.index == index ? 1 : 0.1;
                            });
                        }

                        function unfocus() {
                           labelNode.attr("display", "block");
                           node.style("opacity", 1);
                           link.style("opacity", 1);
                        }

                        function updateLink(link) {
                            link.attr("x1", function(d) { return fixna(d.source.x); })
                                .attr("y1", function(d) { return fixna(d.source.y); })
                                .attr("x2", function(d) { return fixna(d.target.x); })
                                .attr("y2", function(d) { return fixna(d.target.y); });
                        }

                        function updateNode(node) {
                            node.attr("transform", function(d) {
                                return "translate(" + fixna(d.x) + "," + fixna(d.y) + ")";
                            });
                        }

                        function dragstarted(d) {
                            d3.event.sourceEvent.stopPropagation();
                            if (!d3.event.active) graphLayout.alphaTarget(0.3).restart();
                            d.fx = d.x;
                            d.fy = d.y;
                        }

                        function dragged(d) {
                            d.fx = d3.event.x;
                            d.fy = d3.event.y;
                        }

                        function dragended(d) {
                            if (!d3.event.active) graphLayout.alphaTarget(0);
                            d.fx = null;
                            d.fy = null;
                        }

                        ; // d3.json
                        </script>
                            
						</div>



						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
    
    <xsl:template match="node()" mode="buscaps">
    <xsl:param name="thiscap"></xsl:param>
    <xsl:if test="not($thiscap = current()/name)">    
        <xsl:variable name="this" select="current()"/>
         <xsl:variable name="thisbuscaps" select="$allBusCaps[own_slot_value[slot_reference='supports_business_capabilities']/value=$this/name]"/>    
        
            <xsl:apply-templates select="$thisbuscaps" mode="caps">
                <xsl:with-param name="capability" select="$this/own_slot_value[slot_reference='name']/value"/>
                <xsl:with-param name="thistype" select="$this/type"/>
            </xsl:apply-templates>
        <xsl:if test="count(own_slot_value[slot_reference='contained_business_capabilities']/value)=0">
            <xsl:apply-templates select="$relatedBusProcesses" mode="busprocesses">
             <xsl:with-param name="thistype" select="$this/type"/>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:apply-templates select="$thisbuscaps" mode="buscaps">
            <xsl:with-param name="thiscap" select="current()/name"/>
            <xsl:with-param name="thistype" select="$this/type"/>
        </xsl:apply-templates>
    </xsl:if>    
    </xsl:template>
    
    <xsl:template match="node()" mode="busprocesses">
        <xsl:param name="thiscap"></xsl:param>
        <xsl:param name="thistype"></xsl:param>
        <xsl:variable name="this" select="current()"/>
         <xsl:variable name="thisappserv" select="$relatedAppservtoPro[own_slot_value[slot_reference='appsvc_to_bus_to_busproc']/value=$this/name]"/>    
         <xsl:variable name="thisphysical" select="$relatedPhysBusProcesses[own_slot_value[slot_reference='implements_business_process']/value=$this/name]"/> 
            {source: "<xsl:value-of select="eas:getSafeJSString($thisBusCap/own_slot_value[slot_reference='name']/value)"/>", target: "<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='name']/value)"/>", type: "Supporting Process", "class":"<xsl:value-of select="$thistype"/>", "targetclass": "<xsl:value-of select="current()/type"/>",col:"#a2a2aa", "value":1},
        <xsl:apply-templates select="$thisappserv" mode="appservices">
         <xsl:with-param name="thistype" select="$this/type"/>
        </xsl:apply-templates>
   
                <xsl:apply-templates select="$thisphysical" mode="physprocesses">
                         <xsl:with-param name="process" select="$this/own_slot_value[slot_reference='name']/value"/>
                         <xsl:with-param name="thistype" select="$this/type"/>
                </xsl:apply-templates>

    </xsl:template>
    
     <xsl:template match="node()" mode="physprocesses">
        <xsl:param name="process"/>
        <xsl:param name="thistype"></xsl:param>
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisParent" select="$relatedBusProcesses[name=$this/own_slot_value[slot_reference='implements_business_process']/value]"/>
        <xsl:variable name="physProcs2AppsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $this/name]"/>
        <xsl:variable name="appRolesForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
        <xsl:variable name="appsForRolesCap" select="/node()/simple_instance[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/> 
  <!--      <xsl:variable name="appsForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
        <xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $relatedAppPro"/>     
-->
        <!-- <xsl:variable name="thisApplication" select="current()"/>
            {source: "<xsl:value-of select="$process"/>", target: "<xsl:value-of select="$appsForRolesCap/own_slot_value[slot_reference='name']/value"/>", type: "AppsviaProc"}, -->
         
         <xsl:apply-templates select="$appsForRolesCap" mode="appsforphysical">
             <xsl:with-param name="process" select="$process"/>
             <xsl:with-param name="thistype" select="$thistype"/>
            
         </xsl:apply-templates>
         
    </xsl:template>
    
     <xsl:template match="node()" mode="appservices">
          <xsl:param name="thistype"></xsl:param>
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisParent" select="$relatedBusProcesses[own_slot_value[slot_reference='bp_supported_by_app_svc']/value=$this/name]"/>
        <xsl:variable name="thisTarget" select="$relatedAppserv[name=$this/own_slot_value[slot_reference='appsvc_to_bus_from_appsvc']/value]"/>

         
        <!-- <xsl:variable name="thisApplication" select="current()"/> -->
            {source: "<xsl:value-of select="eas:getSafeJSString($thisParent/own_slot_value[slot_reference='name']/value)"/>", target: "<xsl:value-of select="eas:getSafeJSString($thisTarget/own_slot_value[slot_reference='name']/value)"/>", type: "Service", "class":"<xsl:value-of select="$thistype"/>", "targetclass": "<xsl:value-of select="current()/type"/>", col:"#40d040", "value":2},
         <xsl:apply-templates select="$thisTarget" mode="apps">
              <xsl:with-param name="thistype" select="$this/type"/>
         </xsl:apply-templates>
    </xsl:template>
    
    
     <xsl:template match="node()" mode="apps">
         <xsl:param name="thistype"></xsl:param>
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisTarget" select="$relatedAppPro[name=$this/own_slot_value[slot_reference='provided_by_application_provider']/value]"/>
        <xsl:variable name="thisTargetviaRole" select="$relatedAppProviaRole[name=$this/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
         
         
        <!-- pass service as parameter iterate roles, iterate apps--> 
         
         <xsl:apply-templates select="$thisTargetviaRole" mode="approles">
         <xsl:with-param name="service" select="$this/own_slot_value[slot_reference='name']/value"/> 
             <xsl:with-param name="thistype" select="$this/type"/>
         </xsl:apply-templates>
         
    </xsl:template>
    
    <xsl:template match="node()" mode="caps">
        <xsl:param name="thistype"></xsl:param>
    <xsl:param name="capability" />
     {source: "<xsl:value-of select="eas:getSafeJSString($capability)"/>", target: "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='name']/value)"/>", type: "Supporting Caps", "class":"<xsl:value-of select="$thistype"/>", "targetclass": "<xsl:value-of select="current()/type"/>", col:"#848ced", "value":3},     
    </xsl:template>
    
    <xsl:template match="node()" mode="approles">
        <xsl:param name="thistype"></xsl:param>
        <xsl:param name="service" />
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisTarget" select="$relatedAppPro[name=$this/own_slot_value[slot_reference='role_for_application_provider']/value]"/>

            {source: "<xsl:value-of select="eas:getSafeJSString($service)"/>", target: "<xsl:value-of select="eas:getSafeJSString($thisTarget/own_slot_value[slot_reference='name']/value)"/>", type: "App", "class":"<xsl:value-of select="$thistype"/>", "targetclass": "<xsl:value-of select="current()/type"/>", col:"#fac769", "value":4},
        <xsl:apply-templates select="$thisTarget" mode="appdeployments"> <xsl:with-param name="thistype" select="$this/type"/></xsl:apply-templates>
    </xsl:template>
    
    
    <xsl:template match="node()" mode="appsforphysical">
        <xsl:param name="thistype"></xsl:param>
        <xsl:param name="process" />
        <xsl:variable name="this" select="current()"/>


     {source: "<xsl:value-of select="eas:getSafeJSString($process)"/>", target: "<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='name']/value)"/>", "class":"<xsl:value-of select="$thistype"/>", "targetclass": "<xsl:value-of select="current()/type"/>", type: "AppsviaProc", col:"#fac769", "value":5},
        <xsl:apply-templates select="$this" mode="appdeployments"><xsl:with-param name="thistype" select="$thistype"/></xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="node()" mode="appdeployments">  
          <xsl:param name="thistype"></xsl:param>
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisTarget" select="$relatedAppDeployment[own_slot_value[slot_reference='application_provider_deployed']/value=$this/name]"/>

        <xsl:if test="$thisTarget">
         <xsl:apply-templates select="$thisTarget" mode="appdeploymentsrender">
         <xsl:with-param name="apps" select="$this/own_slot_value[slot_reference='name']/value"/>
             <xsl:with-param name="thistype" select="$this/type"/>
         </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
     <xsl:template match="node()" mode="appdeploymentsrender">
        <xsl:param name="thistype"></xsl:param>
        <xsl:param name="apps" />  
        <xsl:variable name="this" select="current()"/>

            {source: "<xsl:value-of select="eas:getSafeJSString($apps)"/>", target: "<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='name']/value)"/>", "class":"<xsl:value-of select="$thistype"/>", "targetclass": "<xsl:value-of select="current()/type"/>", type: "AppD", col:"#e27878", "value":6},
 
    </xsl:template>   

</xsl:stylesheet>
