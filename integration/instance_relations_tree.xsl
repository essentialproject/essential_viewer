<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:param name="param2"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="focusNode" select="/node()/simple_instance[name = $param2]"/>

	<xsl:variable name="classNodesbyName" select="/node()/simple_instance[type = $param1]"/>
	<xsl:variable name="classNodes" select="/node()/class[type = ':ESSENTIAL-CLASS'][not(contains(name, ':'))][own_slot_value[slot_reference=':ROLE']/value = 'Concrete']"/>
	<xsl:variable name="basicQueryString">
		<xsl:call-template name="RenderLinkText">
			<xsl:with-param name="theXSL" select="'integration/instance_relations_tree.xsl'"/>
			<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<!--
		* Copyright © 2008-2016 Enterprise Architecture Solutions Limited.
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
	<!-- May 2011 Updated to support Essential Viewer version 3-->
	<!-- 05.03.2017 NJW Updated to support Essential Viewer version 6-->


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
				<title>Instance Relations Tree</title>
				<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.1/d3.min.js"/>
				<style>
					.node{
						cursor: pointer;
					}
					
					.node circle{
						fill: #fff;
						stroke: steelblue;
						stroke-width: 1.5px;
					}
					
					.node text{
						font: 10px sans-serif;
					}
					
					.link{
						fill: none;
						stroke: #ccc;
						stroke-width: 1.5px;
					}</style>
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
									<span class="text-darkgrey">Instance Tree</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Tree')"/>
							</h2>
							<br/>
							<div class="content-section">
								<div class="row">
									<div class="col-xs-4">
										<p>
											<strong>Select a Class</strong>
										</p>
										<select id="cat" onchange="location=this.value">
											<option>Class</option>
											<xsl:apply-templates select="$classNodes" mode="options">
												<xsl:sort select="name" order="ascending"/>
											</xsl:apply-templates>
										</select>
									</div>
									<div class="col-xs-4">
										<p>
											<strong>Select an Instance</strong>
										</p>
										<select id="obj" onchange="location=this.value">
											<option>Instance</option>
											<xsl:apply-templates select="$classNodesbyName" mode="optionsObjects">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/>
											</xsl:apply-templates>
										</select>
									</div>
								</div>

								<div class="col-xs-12">
									<div id="model" style="padding-top:10px"/>
									<script>
                                var pubs =
   
                                 {"name":"<xsl:value-of select="$focusNode/own_slot_value[slot_reference = 'name']/value"/>","children":[                            
                           <xsl:apply-templates select="$focusNode/own_slot_value" mode="nodes"/>]};
                                
                             
     <![CDATA[                  var diameter = 1000;

                                var margin = {top: 0, right: 0, bottom: 0, left: 0},
                                    width = 1000,
                                    height = diameter;

                                var i = 0,
                                    duration = 350,
                                    root;

                                var tree = d3.layout.tree()
                                    .size([360, diameter / 2 - 80])
                                    .separation(function(a, b) { return (a.parent == b.parent ? 1 : 10) / a.depth; });

                                var diagonal = d3.svg.diagonal.radial()
                                    .projection(function(d) { return [d.y, d.x / 180 * Math.PI]; });
    
                                var svg = d3.select("#model").append("svg")
                                    .attr("width", width )
                                    .attr("height", height )
                                  .append("g")
                                    .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");


                                root = pubs;
                                root.x0 = height / 2;
                                root.y0 = 0;

                                //root.children.forEach(collapse); // start with all children collapsed
                                update(root);

                                d3.select(self.frameElement).style("height", "1000px");

                                function update(source) {

                                  // Compute the new tree layout.
                                  var nodes = tree.nodes(root),
                                      links = tree.links(nodes);

                                  // Normalize for fixed-depth.
                                  nodes.forEach(function(d) { d.y = d.depth * 200; });

                                  // Update the nodes…
                                  var node = svg.selectAll("g.node")
                                      .data(nodes, function(d) { return d.id || (d.id = ++i); });

                                  // Enter any new nodes at the parent's previous position.
                                  var nodeEnter = node.enter().append("g")
                                      .attr("class", "node")
                                      //.attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })
                                      .on("click", click);

                                  nodeEnter.append("circle")
                                      .attr("r", 1e-6)
                                      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

                               nodeEnter.append("text")
                                      .attr("x", 10)
                                      .attr("y", 4)
                                      .attr("dy", ".35em")
                                      .attr("text-anchor", "start")
                                      .attr("transform", function(d) { return d.x < 180 ? "translate(0)" : "rotate(-180)translate(-" + (d.name.length * 8.5)  + ")"; })
                                      .text(function(d) { return d.name; })
                                      .style("fill",function(d){return d.fill});

                                  // Transition nodes to their new position.
                                  var nodeUpdate = node.transition()
                                      .duration(duration)
                                      .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })

                                  nodeUpdate.select("circle")
                                      .attr("r", 4.5)
                                      .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

                                  nodeUpdate.select("text")
                                      .style("fill-opacity", 1)
                                      .attr("transform", function(d) { return d.x < 180 ? "translate(0)" : "rotate(180)translate(-" + (d.name.length + 50)  + ")"; });

                                  // TODO: appropriate transform
                                  var nodeExit = node.exit().transition()
                                      .duration(duration)
                                      //.attr("transform", function(d) { return "diagonal(" + source.y + "," + source.x + ")"; })
                                      .remove();

                                  nodeExit.select("circle")
                                      .attr("r", 1e-6);

                                  nodeExit.select("text")
                                      .style("fill-opacity", 1e-6);

                                  // Update the links…
                                  var link = svg.selectAll("path.link")
                                      .data(links, function(d) { return d.target.id; });

                                  // Enter any new links at the parent's previous position.
                                  link.enter().insert("path", "g")
                                      .attr("class", "link")
                                      .attr("d", function(d) {
                                        var o = {x: source.x0, y: source.y0};
                                        return diagonal({source: o, target: o});
                                      });

                                  // Transition links to their new position.
                                  link.transition()
                                      .duration(duration)
                                      .attr("d", diagonal);

                                  // Transition exiting nodes to the parent's new position.
                                  link.exit().transition()
                                      .duration(duration)
                                      .attr("d", function(d) {
                                        var o = {x: source.x, y: source.y};
                                        return diagonal({source: o, target: o});
                                      })
                                      .remove();

                                  // Stash the old positions for transition.
                                  nodes.forEach(function(d) {
                                    d.x0 = d.x;
                                    d.y0 = d.y;
                                  });
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

                                // Collapse nodes
                                function collapse(d) {
                                  if (d.children) {
                                      d._children = d.children;
                                      d._children.forEach(collapse);
                                      d.children = null;
                                    }
                                }    
]]>
                                </script>
								</div>

							</div>
						</div>


					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>



	<xsl:template mode="nodes" match="node()">
		<xsl:if test="not(current()/slot_reference = 'name')">
			<xsl:if test="not(current()/slot_reference = 'description')">
				<xsl:if test="not(current()/slot_reference = 'external_repository_instance_reference')">{"name": "<xsl:value-of select="substring(current()/slot_reference, 1, 30)"/>..","children":[<xsl:apply-templates select="current()/value" mode="subnodes"/>]}<xsl:if test="not(position() = last())">,</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="subnodes" match="node()">
		<xsl:variable name="allSubNodes" select="/node()/simple_instance[name = current()]"/>
		<xsl:variable name="instanceName">
			<xsl:for-each select="$allSubNodes">
				<xsl:choose>
				<xsl:when test="current()/supertype='EA_Relation'">
					<xsl:value-of select="own_slot_value[slot_reference = 'relation_name']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="this" select="$allSubNodes/$instanceName"/>
		{"name":"<xsl:choose><xsl:when test="not($this)">...<xsl:value-of select="substring-after(current(), 'Class')"/></xsl:when><xsl:otherwise><xsl:value-of select="$this"/></xsl:otherwise></xsl:choose>","fill": "#c41e3a"}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>



	<xsl:template mode="textnodes" match="node()">
		<xsl:value-of select="current()/slot_reference"/>:<xsl:apply-templates select="current()/value" mode="subnodes"/><br/>
	</xsl:template>

	<xsl:template mode="textsubnodes" match="node()">
		<xsl:variable name="this" select="/node()/simple_instance[name = current()]/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="thisBlank" select="current()"/>

		<xsl:choose>
			<xsl:when test="not($this)">
				<xsl:value-of select="substring-after($thisBlank, 'Class')"/> [ID Only]<xsl:value-of select="current()"/>
			</xsl:when>
			<xsl:otherwise>o<xsl:value-of select="$this"/>
			</xsl:otherwise>
		</xsl:choose>
		<br/>

	</xsl:template>

	<xsl:template mode="options" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="allurlID"><xsl:value-of select="concat($basicQueryString, '&amp;PMA=')"/><xsl:value-of select="$this/name"/>&amp;PMA2=</xsl:variable>
		<option value="{$allurlID}">
			<xsl:if test="$this/name = $param1">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$this/name"/>
		</option>

	</xsl:template>

	<xsl:template mode="optionsObjects" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="allurlID">
			<xsl:value-of select="concat($basicQueryString, '&amp;PMA=')"/>
			<xsl:value-of select="concat($param1,'&amp;PMA2=')"/>
			<xsl:value-of select="$this/name"/>
		</xsl:variable>
		<option value="{$allurlID}">
			<xsl:if test="$this/name = $param2">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>
		</option>

	</xsl:template>

</xsl:stylesheet>
