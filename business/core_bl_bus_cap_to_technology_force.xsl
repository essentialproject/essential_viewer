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
			</head>
<body>
<script src="https://d3js.org/d3.v3.min.js"></script>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Capability to Application Deployments: <xsl:value-of select="$thisBusCap/own_slot_value[slot_reference='name']/value"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
						<i class="fa fa-circle" style="color:#848ced"/> Business Capability 	
                        <i class="fa fa-circle" style="color:#a2a2aa"/> Business Process 	
                        <i class="fa fa-circle" style="color:#40d040"/> Application Services 
                        <i class="fa fa-circle" style="color:#fac769"/> Application 
                        <i class="fa fa-circle" style="color:#e27878"/> Application Deployments
						<div class="simple-scroller">
							<div id="model"/>
							<script>
                                var links = [<xsl:apply-templates select="$thisBusCap" mode="buscaps"/>
                                  
                                ];

                                var nodes = {};
                                nodeToType = {};

                                // Compute the distinct nodes from the links.
                                links.forEach(function(link) {
                                  link.source = nodes[link.source] || (nodes[link.source] = {name: link.source});
                                  link.target = nodes[link.target] || (nodes[link.target] = {name: link.target});
                                  nodeToType[link.target.name] = link.col;
                              
                                });

                                var width = 1400,
                                    height = 500;

                                var force = d3.layout.force()
                                    .nodes(d3.values(nodes))
                                    .links(links)
                                    .size([width, height])
                                    .linkDistance(60)
                          //       .charge(-400)
                                .charge(function(d, i) { return i==0 ? -1000 : -500; })
                                    .on("tick", tick)
                                    .start();

                                var svg = d3.select("#model").append("svg")
                                    .attr("width", width)
                                    .attr("height", height);

                                var link = svg.selectAll(".link")
                                    .data(force.links())
                                    .enter().append("line")
                                    .attr("class", "link");

                                var node = svg.selectAll(".node")
                                    .data(force.nodes())
                                  .enter().append("g")
                                    .attr("class", "node")
                                    .on("mouseover", mouseover)
                                    .on("mouseout", mouseout)
                                    .call(force.drag);

                                node.append("circle")
                                    .attr("r", 8)
                                    .style("fill", function(d) { console.log(); return nodeToType[d.name]; });
                                    
                                node.append("text")
                                    .attr("x", 14)
                                    .attr("dy", ".35em")
                                    .text(function(d) { return d.name; });
                                
  
                                function tick() {
                                  link
                                      .attr("x1", function(d) { return d.source.x; })
                                      .attr("y1", function(d) { return d.source.y; })
                                      .attr("x2", function(d) { return d.target.x; })
                                      .attr("y2", function(d) { return d.target.y; });

                                  node
                                      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
                                }

                                function mouseover() {
                                  d3.select(this).select("circle").transition()
                                      .duration(750)
                                      .attr("r", 16);
                                }

                                function mouseout() {
                                  d3.select(this).select("circle").transition()
                                      .duration(750)
                                      .attr("r", 8);
                                }
                                
                                              
                                </script></div>
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
         <xsl:variable name="thisbuscaps" select="$allBusCaps[own_slot_value[slot_reference='supports_business_capabilities']/value=$this/name]"/>    
        
            <xsl:apply-templates select="$thisbuscaps" mode="caps">
                <xsl:with-param name="capability" select="$this/own_slot_value[slot_reference='name']/value"/>
            </xsl:apply-templates>
        <xsl:if test="count(own_slot_value[slot_reference='contained_business_capabilities']/value)=0">
             <xsl:apply-templates select="$relatedBusProcesses" mode="busprocesses"/>
        </xsl:if>
        <xsl:apply-templates select="$thisbuscaps" mode="buscaps"/>
    </xsl:template>
    
    <xsl:template match="node()" mode="busprocesses">
        <xsl:variable name="this" select="current()"/>
         <xsl:variable name="thisappserv" select="$relatedAppservtoPro[own_slot_value[slot_reference='appsvc_to_bus_to_busproc']/value=$this/name]"/>    
         <xsl:variable name="thisphysical" select="$relatedPhysBusProcesses[own_slot_value[slot_reference='implements_business_process']/value=$this/name]"/> 
            {source: "<xsl:value-of select="$thisBusCap/own_slot_value[slot_reference='name']/value"/>", target: "<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", type: "Supporting Process", col:"#a2a2aa"},
             <xsl:apply-templates select="$thisappserv" mode="appservices"/>
   
                <xsl:apply-templates select="$thisphysical" mode="physprocesses">
                         <xsl:with-param name="process" select="$this/own_slot_value[slot_reference='name']/value"/>
                </xsl:apply-templates>

    </xsl:template>
    
     <xsl:template match="node()" mode="physprocesses">
        <xsl:param name="process"/>
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
         </xsl:apply-templates>
         
    </xsl:template>
    
     <xsl:template match="node()" mode="appservices">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisParent" select="$relatedBusProcesses[own_slot_value[slot_reference='bp_supported_by_app_svc']/value=$this/name]"/>
        <xsl:variable name="thisTarget" select="$relatedAppserv[name=$this/own_slot_value[slot_reference='appsvc_to_bus_from_appsvc']/value]"/>

         
        <!-- <xsl:variable name="thisApplication" select="current()"/> -->
            {source: "<xsl:value-of select="$thisParent/own_slot_value[slot_reference='name']/value"/>", target: "<xsl:value-of select="$thisTarget/own_slot_value[slot_reference='name']/value"/>", type: "Service", col:"#40d040"},
        <xsl:apply-templates select="$thisTarget" mode="apps"/>
    </xsl:template>
    
    
     <xsl:template match="node()" mode="apps">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisTarget" select="$relatedAppPro[name=$this/own_slot_value[slot_reference='provided_by_application_provider']/value]"/>
        <xsl:variable name="thisTargetviaRole" select="$relatedAppProviaRole[name=$this/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
         
         
        <!-- pass service as parameter iterate roles, iterate apps--> 
         
         <xsl:apply-templates select="$thisTargetviaRole" mode="approles">
         <xsl:with-param name="service" select="$this/own_slot_value[slot_reference='name']/value"/>       
         </xsl:apply-templates>
         
    </xsl:template>
    
    <xsl:template match="node()" mode="caps">
    <xsl:param name="capability" />
     {source: "<xsl:value-of select="$capability"/>", target: "<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>", type: "Supporting Caps", col:"#848ced"},     
    </xsl:template>
    
    <xsl:template match="node()" mode="approles">
        <xsl:param name="service" />
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisTarget" select="$relatedAppPro[name=$this/own_slot_value[slot_reference='role_for_application_provider']/value]"/>

            {source: "<xsl:value-of select="$service"/>", target: "<xsl:value-of select="$thisTarget/own_slot_value[slot_reference='name']/value"/>", type: "App", col:"#fac769"},
         <xsl:apply-templates select="$thisTarget" mode="appdeployments"/>
    </xsl:template>
    
    
    <xsl:template match="node()" mode="appsforphysical">
        <xsl:param name="process" />
        <xsl:variable name="this" select="current()"/>


     {source: "<xsl:value-of select="$process"/>", target: "<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", type: "AppsviaProc", col:"#fac769"},
           <xsl:apply-templates select="$this" mode="appdeployments"/>
    </xsl:template>
    
    <xsl:template match="node()" mode="appdeployments">   
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisTarget" select="$relatedAppDeployment[own_slot_value[slot_reference='application_provider_deployed']/value=$this/name]"/>

        <xsl:if test="$thisTarget">
         <xsl:apply-templates select="$thisTarget" mode="appdeploymentsrender">
         <xsl:with-param name="apps" select="$this/own_slot_value[slot_reference='name']/value"/>
         </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
    
     <xsl:template match="node()" mode="appdeploymentsrender">
        <xsl:param name="apps" />  
        <xsl:variable name="this" select="current()"/>

            {source: "<xsl:value-of select="$apps"/>", target: "<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", type: "App", col:"#e27878"},
 
    </xsl:template>   

</xsl:stylesheet>
