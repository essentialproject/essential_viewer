<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:functx="http://www.functx.com" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="core_bl_utilities.xsl"/>
	<xsl:output indent="yes" method="html" omit-xml-declaration="yes"/>
	<xsl:param name="param1"/>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Individual_Actor', 'Site', 'Individual_Business_Role', 'Group_Business_Role')"/>
	<!-- END GENERIC LINK VARIABLES -->
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
	<!-- 04.06.2013 JWC Fixed the rendering of reporting hierarchies when the hierarchy is undefined. Also added constraint for primary roles only -->

	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[(type = 'Individual_Actor')]"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[(type = 'Group_Actor')]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allActor2Actors" select="/node()/simple_instance[type = 'ACTOR_REPORTSTO_ACTOR_RELATION']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="rootOrg" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="rootOrgName" select="$rootOrg/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="rootOrgAndDescendants" select="eas:get_org_descendants($rootOrg, 0)"/>
	<xsl:variable name="actorsForOrg" select="$allIndividualActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $rootOrgAndDescendants/name]"/>
	<xsl:variable name="actorsForTopOrg" select="$allIndividualActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $rootOrg/name]"/>
	<xsl:variable name="actorsWithoutOrg" select="$allIndividualActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = ($allGroupActors except $rootOrgAndDescendants)/name]"/>
	<xsl:variable name="actorsOutsideOrg" select="$allIndividualActors except $actorsForOrg"/>
	<xsl:variable name="actor2ActorRels" select="$allActor2Actors[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value = $actorsForOrg/name) and (own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $actorsForOrg/name)]"/>

	<!-- NOTE: NEED TO ONLY INCLUDE DIRECT REPORTING LINES -->
	<xsl:variable name="directReportingType" select="/node()/simple_instance[(type = 'Actor_Reporting_Line_Strength') and (own_slot_value[slot_reference = 'name']/value = 'Direct')]"/>
	<!--<xsl:variable name="directActor2ActorRels" select="$actor2ActorRels[(own_slot_value[slot_reference='indvact_reportsto_indvact_strength']/value = $directReportingType/name)]"/>-->

	<xsl:variable name="rootActor2ActorRel" select="$allActor2Actors[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value = $actorsForOrg/name) and (own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $actorsOutsideOrg/name)]"/>
	<xsl:variable name="rootActor" select="$actorsForTopOrg[(name = $rootActor2ActorRel/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value)]"/>

	<xsl:variable name="DEBUG" select="''"/>
	<!-- NOTE: NEED TO ADD QUERY SPECIFYING THAT THE RELATION SHOULD BE PRIMARY-->
	<xsl:variable name="actorPrimary2Roles" select="$allActor2Roles[(own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $actorsForOrg/name) and (own_slot_value[slot_reference = 'act_to_role_is_primary']/value = 'true')]"/>
	<xsl:variable name="actorPrimaryRoles" select="/node()/simple_instance[name = $actorPrimary2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="maxDepth" select="8"/>

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
	<!--<xsl:variable name="isCapabilityTypesTaxonomy" select="/node()/simple_instance[(type='Taxonomy') and (own_slot_value[slot_reference='name']/value = 'IS Capability Types')]"/>
	<xsl:variable name="capabilityTypeTerms" select="/node()/simple_instance[own_slot_value[slot_reference='term_in_taxonomy']/value= $isCapabilityTypesTaxonomy/name]"/>

	<xsl:variable name="inScopeISCapabilities" select="/node()/simple_instance[type='Application_Capability']"/>
	<xsl:variable name="topLevelISCapabilities" select="$inScopeISCapabilities[own_slot_value[slot_reference='application_capability_level']/value='1']"/>-->
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
				<title>Team Reporting Hierarchy - <xsl:value-of select="$rootOrgName"/></title>
				<xsl:call-template name="dataTablesLibrary"/>
				<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_actors tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
								    } );
									
									var table = $('#dt_actors').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "20%" },
									    { "width": "30%" },
									    { "width": "30%" },
									    { "width": "20%" }
									  ],
									dom: 'Bfrtip',
								    buttons: [
							            'copyHtml5', 
							            'excelHtml5',
							            'csvHtml5',
							            'pdfHtml5', 'print'
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
								    
								    $(window).resize( function () {
									    table.columns.adjust();
									});
								});
							</script>

				<script language="javascript" src="js/jit-yc.js" type="text/javascript"/>
				<script language="javascript" src="js/org_tree.js" type="text/javascript"/>
				<xsl:text disable-output-escaping="yes">&lt;!--[if IE]&gt;&lt;script language="javascript" type="text/javascript" src="js/excanvas.js"&gt;&lt;/script&gt;&lt;![endif]--&gt;</xsl:text>
				<style>
					.text{
						margin: 7px;
					}
					
					#inner-details{
						font-size: 0.8em;
						list-style: none;
						margin: 7px;
					}
					
					.node{
						line-height: 1.1em;
						box-sizing: content-box;
					}
					
					#infovis{
						position: relative;
						width: 100%;
						height: 600px;
						overflow: hidden;
						margin: 0 auto;
					}
					/*TOOLTIPS*/
					
					.tip{
						color: #111;
						width: 139px;
						background-color: white;
						border: 1px solid #ccc;
						-moz-box-shadow: #555 2px 2px 8px;
						-webkit-box-shadow: #555 2px 2px 8px;
						-o-box-shadow: #555 2px 2px 8px;
						box-shadow: #555 2px 2px 8px;
						opacity: 0.9;
						font-size: 10px;
						padding: 7px;
					}</style>
				<xsl:variable name="indivActorSummaryReport" select="eas:get_report_by_name('Core: Stakeholder Summary')"/>
				<xsl:variable name="treeDrillDownUrl">
					<xsl:text disable-output-escaping="yes">report?XML=reportXML.xml&amp;XSL=</xsl:text>
					<xsl:value-of select="$indivActorSummaryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
					<xsl:text disable-output-escaping="yes">&amp;PMA=</xsl:text>
				</xsl:variable>
				<script type="text/javascript">
					<xsl:choose>
						<xsl:when test="count($rootActor) = 0">
							<xsl:text>function tree(){
							//initialise the data
							var json={}; //end data</xsl:text>
						</xsl:when>
						<xsl:when test="count($rootActor) > 1">
							<xsl:variable name="trimmedRootActor" select="$rootActor[not(name = $actor2ActorRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value)]"/>
							<xsl:text>function tree(){
							//initialise the data
							var json=</xsl:text><xsl:call-template name="PrintActorTreeDataNamed"><xsl:with-param name="parentNode" select="$trimmedRootActor"/></xsl:call-template><xsl:text>; //end data</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>function tree(){
							//initialise the data
							var json=</xsl:text><xsl:call-template name="PrintActorTreeDataNamed"><xsl:with-param name="parentNode" select="$rootActor"/></xsl:call-template><xsl:text>; //end data</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text disable-output-escaping="yes">
						<!--{
						id: "1",
				        name: "Bob Smith&lt;br/&gt;(Head Of Enterprise Architecture)",
				        data: {},
				        children: [
				        	{id: "1.1",name: "Angie Ducas&lt;br/&gt;(Senior Architect)",data: {}},
				        	{id: "1.2",name: "Chew Hui Ting&lt;br/&gt;(Senior Architect)",data: {}},
				        	{id: "1.3",name: "Gene Sall&lt;br/&gt;(Senior Architect)",data: {},children:
				        		[
				        		{id: "1.3.1",name: "Sally Sykes&lt;br/&gt;(Project Manager)",data: {}}
				        		]
				        	},
				        	{id: "1.4",name: "John Jones&lt;br/&gt;(Junior Architect)",data: {}}
				        ]
				        };-->
						//init OrgTree
						//Create a new ST instance
						var st = new $jit.ST({
						//id of viz container element
						injectInto: 'infovis',
						//set duration for the animation
						//set duration for the animation
						duration: 350,
						//Set Default Orientation
						orientation: 'top',
						//set animation transition type
						transition: $jit.Trans.Quart.easeInOut,
						//set distance between node and its children
						levelDistance: 50,
						levelsToShow: 6,
						offsetX: 0,
						offsetY: 120,
						//enable panning
						Navigation: {
							enable: true,
							panning: true
						},
						//set node and edge styles
						//set overridable=true for styling individual
						//nodes or edges
						Node: {
						height: 70,
						width: 130,
						type: 'rectangle',
						color: '#9c8ac5', // When switching between nodes this highlights the previous node temporarily. This is the default style if overrideable - below - is set to false
						overridable: true
						},
						
						Edge: {
						type: 'bezier',
						color: '#666',
						overridable: true
						},
						
						//	onBeforeCompute: function(node){
						//	Log.write("loading " + node.name);
						//	},
						
						//	onAfterCompute: function(){
						//	Log.write("done");
						//	},
						
						//This method is called on DOM label creation.
						//Use this method to add event handlers and styles to
						//your node.
						onCreateLabel: function(label, node){
						label.id = node.id;            
						label.innerHTML = node.name;
						label.onclick = function(){
						if(normal.checked) {
						st.onClick(node.id);
						} else {
						if((node.data.nodeType == "Actor") || (node.data.nodeType == "ExternalActor")) {
						viewUrl = "</xsl:text><xsl:value-of disable-output-escaping="yes" select="$treeDrillDownUrl"/><xsl:text disable-output-escaping="yes">" + node.data.nodeId;
							window.location=viewUrl; ;}
							}
							};
							//set the text colour of the node depending on its type
						var objType = node.data.nodeType;
						
						//set label styles
						var style = label.style;
						style.width = 120 + 'px';
						style.height = 50 + 'px';
						style.cursor = 'pointer';
						style.color = '#ffffff';
						style.fontSize = '0.9em';
						style.textAlign= 'center';
						style.paddingTop = '5px';
						style.paddingLeft = '5px';
						style.paddingRight = '5px';
						if (objType === "isCapRoot") {
							style.color = '#fff';
						}
						if (objType === "isCapType") {
							style.color = '#fff';
						}
						if (objType === "isCap") {
							style.color = '#fff';
						}
							},
							
							//This method is called right before plotting
							//a node. It's useful for changing an individual node
							//style properties before plotting it.
							//The data properties prefixed with a dollar
							//sign will override the global node style properties.
							onBeforePlotNode: function (node) {
						//add some color to the nodes in the path between the
						//root node and the selected node.
						
								//set the colour of the node depending on its type
								var objType = node.data.nodeType;
								
								if (objType === "ExternalActor") {
									node.data.$color = "#830051"; // Colour for the root of the tree
								}
								
								if (node.selected) {
									// Colour for root and selected nodes
								} else {
									
									//if the node belongs to the last plotted level
								}
							},
							
							//This method is called right before plotting
							//an edge. It's useful for changing an individual edge
							//style properties before plotting it.
							//Edge data proprties prefixed with a dollar sign will
							//override the Edge global style properties.
							onBeforePlotLine: function(adj){
								var nodeToType = adj.nodeTo.data.reportingLineType;
								var nodeFromType = adj.nodeFrom.data.reportingLineType;
								
								if (nodeToType == "Direct") {
									adj.data.$color = "#624e9c"; // colour for direct reporting lines
									adj.data.$lineWidth = 1;
								}
								else {
									adj.data.$color = "#e7b600"; // colour for indirect reporting lines
									adj.data.$lineWidth = 1;
								}
							<!--if (adj.nodeFrom.selected &amp;&amp; adj.nodeTo.selected) {
								adj.data.$color = "grey"; // colour to trace the path of chosen nodes
								adj.data.$lineWidth = 3;
							}
							else {
								var nodeToType = adj.nodeTo.data.nodeType;
								var nodeFromType = adj.nodeFrom.data.nodeType;
								
								if (nodeToType == "ExternalActor") {
								adj.data.$color = "red"; // colour to trace the path of chosen nodes
								adj.data.$lineWidth = 5;
								}
								else {
								delete adj.data.$color;
								delete adj.data.$lineWidth;
								}
							}-->
							}
							});
							//load json data
							st.loadJSON(json);
							//compute node positions and layout
							st.compute();
							//optional: make a translation of the tree
							st.geom.translate(new $jit.Complex(-200, 0), "current");
							//emulate a click on the root node.
							st.onClick(st.root);
							//end
							
							//Add event handlers to switch spacetree orientation.
							var top = $jit.id('r-top'),
							left = $jit.id('r-left'),
							normal = $jit.id('s-normal');
							
							
							function changeHandler() {
								if (this.checked) {
									top.disabled = left.disabled = true;
									st.switchPosition(this.value, "animate", {
										onComplete: function () {
											top.disabled = left.disabled = false;
										}
									});
								}
							};
				
							top.onchange = left.onchange = changeHandler;
							
							//end
							
							}
						</xsl:text>
				</script>
			</head>
			<body onload="tree();">
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary">View: <xsl:value-of select="$DEBUG"/></span>
									<span class="text-darkgrey">Team Reporting Hierarchy - <span class="text-primary"><xsl:value-of select="$rootOrgName"/></span></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Reporting Hierarchy</h2>
							<div class="content-section">
								<p>This view shows the reporting lines for the people in the <strong><xsl:value-of select="$rootOrgName"/></strong> team.</p>
								<br/>
								<div class="pull-left">
									<div class="pull-left">
										<strong>Tree Orientation:&#160;&#160;</strong>
									</div>
									<div class="pull-left">
										<form style="*margin-top: -2px;">
											<label for="r-top">Top </label>
											<input checked="checked" id="r-top" name="orientation" type="radio" value="top"/>
											<span>&#160;&#160;&#160;</span>
											<label for="r-left">Left </label>
											<input id="r-left" name="orientation" type="radio" value="left"/>
										</form>
									</div>
									<div class="horizSpacer_70px pull-left"/>
									<div class="pull-left ">
										<strong>Click to:&#160;&#160;</strong>
									</div>
									<div class="pull-left">
										<form style="*margin-top: -2px;">
											<label for="r-top">Navigate </label>
											<input checked="checked" id="s-normal" name="selection" type="radio" value="normal"/>
											<span>&#160;&#160;&#160;</span>
											<label for="r-left">Drill Down </label>
											<input id="s-root" name="selection" type="radio" value="root"/>
										</form>
									</div>
									<div class="verticalSpacer_10px"/>
									<div class="pull-left">
										<div id="keyContainer">
											<div class="keyLabel"><xsl:value-of select="eas:i18n('Legend')"/>:</div>
											<div class="keySample" style="background-color:#9c8ac5;"/>
											<div class="keySampleLabel">
												<xsl:value-of select="eas:i18n('Internal')"/>
											</div>
											<div class="keySample" style="background-color:#830051;"/>
											<div class="keySampleLabel">
												<xsl:value-of select="eas:i18n('External')"/>
											</div>
											<div class="horizSpacer_50px pull-left"/>

											<div style="height:2px;width:30px;background-color:#624e9c; position:relative; top: 5px; margin-right: 10px;" class="pull-left"/>
											<div class="keySampleLabel">
												<xsl:value-of select="eas:i18n('Direct Reports')"/>
											</div>
											<div style="height:2px;width:30px;background-color:#e7b600;  position:relative; top: 5px; margin-right: 10px;" class="pull-left"/>
											<div class="keySampleLabel">
												<xsl:value-of select="eas:i18n('Indirect Reports')"/>
											</div>
										</div>
									</div>
								</div>
								<xsl:choose>
									<xsl:when test="not($rootActor)">
										<p>No reporting hierarchy defined for <strong><xsl:value-of select="$rootOrgName"/></strong>.</p>
									</xsl:when>
									<xsl:otherwise>
										<script>
										$(document).ready(function(){
											$( ".simple-scroller" ).scrollLeft( 1200 );
										});
									</script>
										<div class="simple-scroller">
											<div class="infovis-outer">
												<div id="infovis"/>
											</div>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup IS Caps Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Catalogue</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($actorsForOrg) > 0">
										<p>The following table lists the people in the <strong><xsl:value-of select="$rootOrgName"/></strong> team and any teams contained within it.</p>
										<br/>
										<table class="table table-striped table-bordered" id="dt_actors">
											<thead>
												<tr>
													<th>Name</th>
													<th>Email</th>
													<th>Primary Role</th>
													<th>Primary Site</th>
												</tr>
											</thead>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Email</th>
													<th>Primary Role</th>
													<th>Primary Site</th>
												</tr>
											</tfoot>
											<tbody>
												<xsl:apply-templates mode="RenderTeamMemberRow" select="$actorsForOrg">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												</xsl:apply-templates>
											</tbody>
										</table>
									</xsl:when>
									<xsl:otherwise>
										<p>
											<em>No individuals captured as members of the <xsl:value-of select="$rootOrgName"/> team</em>
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
				<div class="clear"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<!-- TEMPLATE TO PRINT OUT THE JSON DATA FOR A GIVEN IS CAPABILITIES AND ITS SUB-CAPABILITIES -->
	<xsl:template match="node()" name="PrintActorTreeDataNamed">
		<xsl:param name="grandParentNode" select="()"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="level" select="1"/>

		<xsl:choose>
			<xsl:when test="not($parentNode)">{}</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="parentOrg" select="$allGroupActors[name = $parentNode/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
				<xsl:variable name="nodeType">
					<xsl:choose>
						<xsl:when test="$parentNode/own_slot_value[slot_reference = 'external_to_enterprise']/value = 'true'">nodeType: "ExternalActor"</xsl:when>
						<xsl:otherwise>nodeType: "Actor"</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="parentNodeRel" select="$actor2ActorRels[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value = $parentNode/name) and (own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $grandParentNode/name)]"/>
				<xsl:variable name="reportingLineType">
					<xsl:choose>
						<xsl:when test="$parentNodeRel/own_slot_value[slot_reference = 'indvact_reportsto_indvact_strength']/value = $directReportingType/name">reportingLineType: "Direct"</xsl:when>
						<xsl:otherwise>reportingLineType: "Indirect"</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="nodeId">nodeId: "<xsl:value-of select="$parentNode/name"/>"</xsl:variable>
				<xsl:variable name="actor2PrimaryRole" select="$actorPrimary2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $parentNode/name]"/>
				<xsl:variable name="actorPrimaryRole" select="$actorPrimaryRoles[name = $actor2PrimaryRole/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
				<xsl:variable name="parentName"><xsl:value-of select="$parentNode/own_slot_value[slot_reference = 'name']/value"/><xsl:text>&lt;br/&gt;(</xsl:text><xsl:value-of select="$actorPrimaryRole/own_slot_value[slot_reference = 'name']/value"/>)</xsl:variable>
				<xsl:text>{id: "</xsl:text>
				<xsl:value-of select="concat($parentNode/name, '_', $grandParentNode/name)"/>
				<xsl:text>",name: "</xsl:text>
				<xsl:value-of select="$parentName"/>
				<xsl:text>", data:{</xsl:text>
				<xsl:value-of select="$nodeType"/>, <xsl:value-of select="$reportingLineType"/>, <xsl:value-of select="$nodeId"/>
				<xsl:text>}, children:[</xsl:text>
				<xsl:variable name="childActorReportRels" select="$actor2ActorRels[own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $parentNode/name]"/>
				<xsl:variable name="childActors" select="$actorsForOrg[name = $childActorReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
				<xsl:if test="$level &lt; $maxDepth">
					<xsl:for-each select="$childActors">
						<xsl:call-template name="PrintActorTreeDataNamed">
							<xsl:with-param name="grandParentNode" select="$parentNode"/>
							<xsl:with-param name="parentNode" select="current()"/>
							<xsl:with-param name="level" select="$level + 1"/>
						</xsl:call-template>
						<xsl:choose>
							<xsl:when test="position() = count($childActors)"/>
							<xsl:otherwise>
								<xsl:text>, </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>]}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- TEMPLATE TO PRINT OUT A ROW FOR AN IS CAPABILITY -->
	<xsl:template match="node()" mode="RenderTeamMemberRow">
		<xsl:variable name="memberEmail" select="current()/own_slot_value[slot_reference = 'email']/value"/>
		<xsl:variable name="memberBaseSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="actor2PrimaryRole" select="$actorPrimary2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="actorPrimaryRole" select="$actorPrimaryRoles[name = $actor2PrimaryRole/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
		<tr>
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($memberEmail) > 0">
						<a>
							<xsl:attribute name="href" select="concat('mailto:', $memberEmail)"/>
						</a>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>

			</td>
			<td>
				<!--add primary role queries-->
				<xsl:choose>
					<xsl:when test="count($actorPrimaryRole) > 1">
						<ul>
							<xsl:for-each select="$actorPrimaryRole">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:when test="count($actorPrimaryRole) > 0">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$actorPrimaryRole"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise> - </xsl:otherwise>
				</xsl:choose>


			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($memberBaseSites) = 0">-</xsl:when>
					<xsl:otherwise>
						<ul>
							<xsl:for-each select="$memberBaseSites">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
