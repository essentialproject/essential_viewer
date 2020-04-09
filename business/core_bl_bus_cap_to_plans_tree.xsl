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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Composite_Application_Provider','Business_Process','Application_Service','Project','Programme','Enterprise_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="thisBusCap" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="relatedBusProcesses" select="/node()/simple_instance[type = 'Business_Process'][own_slot_value[slot_reference = 'realises_business_capability']/value = $thisBusCap/name]"/>
	<xsl:variable name="relatedAppservtoPro" select="/node()/simple_instance[type = 'APP_SVC_TO_BUS_RELATION'][own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $relatedBusProcesses/name]"/>
	<xsl:variable name="relatedAppserv" select="/node()/simple_instance[type = 'Application_Service'][own_slot_value[slot_reference = 'supports_business_process_appsvc']/value = $relatedAppservtoPro/name]"/>
	<xsl:variable name="relatedAppPro" select="/node()/simple_instance[((type = 'Application_Provider') or (type = 'Composite_Application_Provider'))]"/>
	<xsl:variable name="relatedAppProviaRole" select="/node()/simple_instance[type = 'Application_Provider_Role'][name = $relatedAppserv/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value]"/>
	

	<xsl:variable name="relatedPhysBusProcesses" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference = 'implements_business_process']/value = $relatedBusProcesses/name]"/>
	<xsl:variable name="relatedAppProtoBus" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relatedPhysBusProcesses/name]"/>
    
    <xsl:variable name="planElements" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $relatedAppPro/name]"/>
    <xsl:variable name="planningAction" select="/node()/simple_instance[type = 'Planning_Action']"/>
    <xsl:variable name="relatedAppPlans" select="/node()/simple_instance[type = 'Project'][name=$planElements/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
    <xsl:variable name="relatedAppStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][name=$planElements/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
   
    
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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Business Capability to Applications to Plans</title>
				<style>
					.node circle{
						fill: #fff;
						stroke: steelblue;
						stroke-width: 3px;
					}
					
					.node text{
						font: 10px sans-serif;
					}
					
					.link{
						fill: none;
						stroke: #ccc;
						stroke-width: 2px;
					}</style>
				<script src="js/d3/d3_4-11/d3.min.js"/>
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
									<span class="text-darkgrey">Business Capability to Applications to Plans - </span>
									<span class="text-primary"><xsl:value-of select="$thisBusCap/own_slot_value[slot_reference = 'name']/value"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<i class="fa fa-circle" style="color:red"/> Business Capability <i class="fa fa-circle" style="color:#a2a2aa"/> Business Process <i class="fa fa-circle" style="color:green"/>  Application Service <i class="fa fa-circle" style="color:orange"/>  Application <i class="fa fa-circle" style="color:#e27878"/> Plans <i class="fa fa-circle" style="color:#78dae2"/> Project<br/><br/>
						
							<div class="simple-scroller">
								<div id="model"/>
								<script>
                                   
                                    
                                    
									var treeData =
									  { "name": "<xsl:value-of select="$thisBusCap/own_slot_value[slot_reference = 'name']/value"/>","colour":"red",
									    "children": [<xsl:apply-templates select="$thisBusCap" mode="buscaps"/>]};
									    
									console.log(treeData)
                                    
									// Set the dimensions and margins of the diagram
									var margin = {top: 20, right: 90, bottom: 30, left: 120},
									    width = 1200 - margin.left - margin.right,
									    height = (<xsl:value-of select="count($allBusCaps)"></xsl:value-of>*5) - margin.top - margin.bottom;
									
									// append the svg object to the body of the page
									// appends a 'group' element to 'svg'
									// moves the 'group' element to the top left margin
									var svg = d3.select("#model").append("svg")
									    .attr("width", width + margin.right + margin.left)
									    .attr("height", height + margin.top + margin.bottom)
									  .append("g")
									    .attr("transform", "translate("
									          + margin.left + "," + margin.top + ")");
									
									var i = 0,
									    duration = 750,
									    root;
									
									// declares a tree layout and assigns the size
									var treemap = d3.tree().size([height, width]);
									
									// Assigns parent, children, height, depth
									root = d3.hierarchy(treeData, function(d) { return d.children; });
									root.x0 = height / 2;
									root.y0 = 0;
									
									// Collapse after the second level
									root.children.forEach(collapse);
									
									update(root);
									
									// Collapse the node and all it's children
									function collapse(d) {
									  if(d.children) {
									    d._children = d.children
									    d._children.forEach(collapse)
									    d.children = null
									  }
									}
									
									function update(source) {
									
									  // Assigns the x and y position for the nodes
									  var treeData = treemap(root);
									
									  // Compute the new tree layout.
									  var nodes = treeData.descendants(),
									      links = treeData.descendants().slice(1);
									
									  // Normalize for fixed-depth.
									  nodes.forEach(function(d){ d.y = d.depth * 180});
									
									  // ****************** Nodes section ***************************
									
									  // Update the nodes...
									  var node = svg.selectAll('g.node')
									      .data(nodes, function(d) {return d.id || (d.id = ++i); });
									
									  // Enter any new modes at the parent's previous position.
									  var nodeEnter = node.enter().append('g')
									      .attr('class', 'node')
									      .attr("transform", function(d) {
									        return "translate(" + source.y0 + "," + source.x0 + ")";
									    })
									    .on('click', click);
									
									  // Add Circle for the nodes
									  nodeEnter.append('circle')
									      .attr('class', 'node')
									      .attr('r', 12)
									      .style("fill", function(d) {
									          return d._children ? "lightsteelblue" : "#fff";})
									      .style("stroke", function(d){
									        return d.data.colour; })    
									      ;
									    
								
									  // Add labels for the nodes
									  nodeEnter.append("foreignObject")
                                        .attr("y", "0")
                                        .attr("x",  function(d) {return (d.children || d._children ? -1 : 1)+20;})
                                        .attr('width', 410)
                                        .attr('height', 20)
                                        .append('xhtml').html(function(d) {return d.data.link; });
                                    
                                     nodeEnter
                                         .append('text')
									      .attr("dy", "-3")
									      .attr("x", function(d) {
									          return (d.children || d._children ? -1 : 1)+20;
									      })
									      .attr("text-anchor", function(d) {
									          return d.children || d._children ? "end" : "start";
									      })
                                         
									      .text(function(d) {
                                      
                                            if(d.data.change){ console.log(d);var str='('+d.data.change+')'; 
                                            
                                            return d.data.action + str}else {return d.data.action}})
									    ;
                                    
                         
									nodeEnter.append('text')
									       .attr("dy", "4")
									      .attr("x", function(d){if(d.data.children.length&gt;9){return -7}
                                              else if(d.data.children.length&gt;99){return -11}
                                              else{return -3}})
                                          .style("font-size","9pt")
                                          .style("fill","#fff")
									      .text(function(d) {if(d.data.children) {return d.data.children.length}else{return 0 }})
									      ;
									  // UPDATE
									  var nodeUpdate = nodeEnter.merge(node);
									
									  // Transition to the proper position for the node
									  nodeUpdate.transition()
									    .duration(duration)
									    .attr("transform", function(d) { 
									        return "translate(" + d.y + "," + d.x + ")";
									     });
									
									  // Update the node attributes and style
									  nodeUpdate.select('circle.node')
									    .attr('r', 12)
									    .style("fill", function(d) {
									        return d._children ? "#000000" : "#b0c9bc";
									    })
									    .attr('cursor', 'pointer');
									
									   // handle mouse events
									    function handleMouseOver(d, i) {  // Add interactivity
									           <!--  d3.select(this).attr("dy", -35)
									              d3.select(this).style("font-size","20px");
                                            -->
									          }
									
									      function handleMouseOut(d, i) {
									            d3.select(this).attr("dy", -15)
									            d3.select(this).style("font-size","10px");;
									          }
									    
									    
									  // Remove any exiting nodes
									  var nodeExit = node.exit().transition()
									      .duration(duration)
									      .attr("transform", function(d) {
									          return "translate(" + source.y + "," + source.x + ")";
									      })
									      .remove();
									
									  // On exit reduce the node circles size to 0
									  nodeExit.select('circle')
									    .attr('r', 6);
									
									  // On exit reduce the opacity of text labels
									  nodeExit.select('text')
									    .style('fill-opacity', 1e-6);
									    
									 
									  // ****************** links section ***************************
									
									  // Update the links...
									  var link = svg.selectAll('path.link')
									      .data(links, function(d) { return d.id; });
									
									  // Enter any new links at the parent's previous position.
									  var linkEnter = link.enter().insert('path', "g")
									      .attr("class", "link")
									      .attr('d', function(d){
									        var o = {x: source.x0, y: source.y0}
									        return diagonal(o, o)
									      });
									
									  // UPDATE
									  var linkUpdate = linkEnter.merge(link);
									
									  // Transition back to the parent element position
									  linkUpdate.transition()
									      .duration(duration)
									      .attr('d', function(d){ return diagonal(d, d.parent) });
									
									  // Remove any exiting links
									  var linkExit = link.exit().transition()
									      .duration(duration)
									      .attr('d', function(d) {
									        var o = {x: source.x, y: source.y}
									        return diagonal(o, o)
									      })
									      .remove();
									
									  // Store the old positions for transition.
									  nodes.forEach(function(d){
									    d.x0 = d.x;
									    d.y0 = d.y;
									  });
									
									  // Creates a curved (diagonal) path from parent to the child nodes
									  function diagonal(s, d) {
									
									    path = `M ${s.y} ${s.x}
									            C ${(s.y + d.y) / 2} ${s.x},
									              ${(s.y + d.y) / 2} ${d.x},
									              ${d.y} ${d.x}`
									
									    return path
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
									}

                            </script>
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

	<xsl:template match="node()" mode="buscaps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisbuscaps" select="$allBusCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $this/name]"/>
		<xsl:apply-templates select="$relatedBusProcesses[own_slot_value[slot_reference = 'realises_business_capability']/value = $this/name]" mode="busprocesses"/>


	</xsl:template>

	<xsl:template match="node()" mode="busprocesses">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisappserv" select="$relatedAppservtoPro[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $this/name]"/>
		<xsl:variable name="thisphysical" select="$relatedPhysBusProcesses[own_slot_value[slot_reference = 'implements_business_process']/value = $this/name]"/> {"name": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>","colour": "gray","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>", "children": [ <xsl:apply-templates select="$thisappserv" mode="appservices"/>
		<xsl:apply-templates select="$thisphysical" mode="physprocesses">
			<xsl:with-param name="process" select="$this/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates> ]}, </xsl:template>

	<xsl:template match="node()" mode="physprocesses">
		<xsl:param name="process"/>
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisParent" select="$relatedBusProcesses[name = $this/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="physProcs2AppsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $this/name]"/>
		<xsl:variable name="appRolesForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="appsForRolesCap" select="/node()/simple_instance[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<!--      <xsl:variable name="appsForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
        <xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $relatedAppPro"/>     
-->
		<!-- <xsl:variable name="thisApplication" select="current()"/>
            {source: "<xsl:value-of select="$process"/>", target: "<xsl:value-of select="$appsForRolesCap/own_slot_value[slot_reference='name']/value"/>", type: "AppsviaProc"}, -->

		

	</xsl:template>

	<xsl:template match="node()" mode="appservices">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisParent" select="$relatedBusProcesses[own_slot_value[slot_reference = 'bp_supported_by_app_svc']/value = $this/name]"/>
		<xsl:variable name="thisTarget" select="$relatedAppserv[name = $this/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/> {"name": "<xsl:value-of select="$thisTarget/own_slot_value[slot_reference = 'name']/value"/>","colour": "green","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$thisTarget"/>
			</xsl:call-template>", "children": [ <xsl:apply-templates select="$thisTarget" mode="apps"/> ]}, <!-- <xsl:variable name="thisApplication" select="current()"/> -->
	</xsl:template>


	<xsl:template match="node()" mode="apps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisTarget" select="$relatedAppPro[name = $this/own_slot_value[slot_reference = 'provided_by_application_provider']/value]"/>
		<xsl:variable name="thisTargetviaRole" select="$relatedAppProviaRole[name = $this/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value]"/>


		<!-- pass service as parameter iterate roles, iterate apps-->

		<xsl:apply-templates select="$thisTargetviaRole" mode="approles">
			<xsl:with-param name="service" select="$this/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates>

	</xsl:template>

	<xsl:template match="node()" mode="caps">
		<xsl:param name="capability"/> {"name": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>"} </xsl:template>

	<xsl:template match="node()" mode="approles">
		<xsl:param name="service"/>
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisTarget" select="$relatedAppPro[name = $this/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:if test="$thisTarget"> {"name": "<xsl:value-of select="$thisTarget/own_slot_value[slot_reference = 'name']/value"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$thisTarget"/>
			</xsl:call-template>","colour": "orange", "children": [ <xsl:apply-templates select="$thisTarget" mode="appplans"/> ]}, </xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="appsforphysical">
		<xsl:param name="process"/>
		<xsl:variable name="this" select="current()"/> {"name": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>","colour": "orange","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>", "children": [<!-- <xsl:apply-templates select="$this" mode="appplans"/>--> ]}, </xsl:template>


	<xsl:template match="node()" mode="appplans">
	   <xsl:variable name="thisplanElements" select="$planElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = current()/name]"/>
        
		<xsl:apply-templates select="$thisplanElements" mode="plans"/>
	</xsl:template>

    	<xsl:template match="node()" mode="plans">
        <xsl:variable name="thisrelatedAppPlans" select="$relatedAppPlans[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
         <xsl:variable name="thisrelatedAppStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][name=current()/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>    <xsl:choose><xsl:when test="$thisrelatedAppStratPlans">{"name": "<xsl:value-of select="$thisrelatedAppStratPlans/own_slot_value[slot_reference = 'name']/value"/>","colour": "#e27878","type":"strategic", "change":"<xsl:value-of select="$thisrelatedAppPlans/own_slot_value[slot_reference = 'name']/value"/>", "action":"<xsl:value-of select="$planningAction[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]/own_slot_value[slot_reference = 'name']/value"/>", "link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$thisrelatedAppStratPlans"/>
			</xsl:call-template>", "children": [<!-- <xsl:apply-templates select="$this" mode="appplans"/>--> ]}</xsl:when><xsl:otherwise>{"name": "<xsl:value-of select="$thisrelatedAppPlans/own_slot_value[slot_reference = 'name']/value"/>","colour": "#78dae2","type":"plan","action":"<xsl:value-of select="$planningAction[name=current()/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]/own_slot_value[slot_reference = 'name']/value"/>", "link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$thisrelatedAppPlans"/>
			</xsl:call-template>", "children": [<!-- <xsl:apply-templates select="$this" mode="appplans"/>--> ]}</xsl:otherwise></xsl:choose>, </xsl:template>

	<xsl:template match="node()" mode="nodeList"> {name: "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>", "type": "<xsl:value-of select="type"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

</xsl:stylesheet>
