<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
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
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->

	<xsl:character-map name="pi-delimiters">
		<xsl:output-character character="§" string=">"/>
		<xsl:output-character character="¶" string="&lt;"/>
		<xsl:output-character character="€" string="&amp;quot;"/>
	</xsl:character-map>

	<xsl:output use-character-maps="pi-delimiters"/>

	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<!--<xsl:include href="../business/menus/core_product_type_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the id of the root (group) actor -->
	<!--<xsl:param name="param1"/>-->

	<!-- param4 = the taxonomy term that will be used to scope the organisation model -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<!--	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'" />
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')" />-->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Group_Actor', 'Individual_Actor', 'Individual_Business_Role', 'Group_Business_Role', 'Site', 'Business_Process', 'Business_Activity', 'Business_Task')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- SET THE VARIABLES THAT ARE REQUIRED REPEATEDLY THROUGHOUT -->
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]"/>
	<xsl:variable name="allIndActors" select="$allActors[type = 'Individual_Actor']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="baseSites" select="$allSites[name = $currentActor/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
	<xsl:variable name="allActor2RoleRelations" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allA2RForActor" select="$allActor2RoleRelations[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $currentActor/name]"/>
	<xsl:variable name="allRolesForActor" select="$allRoles[name = $allA2RForActor/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

	<xsl:variable name="maxDepth" select="6"/>

	<xsl:variable name="currentActor" select="$allActors[name = $param1]"/>
	<xsl:variable name="orgName" select="$currentActor/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="rootOrgID" select="$allActors[own_slot_value[slot_reference = 'contained_sub_actors']/value = $currentActor/name]/name"/>

	<xsl:variable name="parentActor" select="$allActors[name = $rootOrgID]"/>
	<xsl:variable name="inScopeActors" select="eas:get_org_descendants($parentActor, $allActors, 0)"/>
	<xsl:variable name="parentActorName" select="$parentActor/own_slot_value[slot_reference = 'name']/value"/>
    
    <xsl:variable name="actor2role" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference='act_to_role_from_actor']/value=$param1]"/>
 <!-- <xsl:variable name="physicalProcess" select="/node()/simple_instance[type = 'Physical_Process'][(own_slot_value[slot_reference='process_performed_by_actor_role']/value=$param1)  or (own_slot_value[slot_reference='process_performed_by_actor_role']/value=$actor2role/name)]"/> -->
    <xsl:variable name="physicalProcess" select="/node()/simple_instance[type = 'Physical_Process'][own_slot_value[slot_reference='process_performed_by_actor_role']/value=$actor2role/name]"/>
    <xsl:variable name="businessProcess" select="/node()/simple_instance[type = 'Business_Process']"/>
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
	<!-- 30.09.2016 JP Updated to add graphical hierarchy -->



	<xsl:template match="knowledge_base">

		<xsl:call-template name="docType"/>
		<!-- CODE USED IF CLICK THROUGH IS REQUIRED FROM THE ORG MODEL -->
		<!--<xsl:variable name="orgImpactUrl">
			<xsl:text disable-output-escaping="yes">report?XML=reportXML.xml&amp;XSL=business/org_impact_assessment.xsl&amp;LABEL=Organisation Impact Analysis&amp;PMA2=</xsl:text>
			<xsl:value-of select="$rootOrgID" />
			<xsl:text disable-output-escaping="yes">&amp;PMA3=</xsl:text>
			<xsl:value-of select="$param4" />
			<xsl:text disable-output-escaping="yes">&amp;PMA=</xsl:text>
			</xsl:variable>-->
		<xsl:variable name="orgImpactUrl" select="'#'"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title> Organisation Summary - <xsl:value-of select="$currentActor/own_slot_value[slot_reference = 'name']/value"/>
				</title>

				<!--CSS and JS links to Support InfoVis SpaceTree-->
				<style>
					.text{
						margin: 7px;
					}
					
					#inner-details{
						font-size: 0.8em;
						list-style: none;
						margin: 7px;
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
						filter: alpha(opacity=90)
					
					;
						font-size: 10px;
						font-family: Helvetica, Arial, sans-serif;
						padding: 7px;
					}</style>
				<script language="javascript" type="text/javascript" src="js/jit-yc.js"/>
				<script language="javascript" type="text/javascript" src="js/org_tree.js"/>
				<!--<script language="javascript" type="text/javascript" src="js/excanvas.js" />-->
				<xsl:text disable-output-escaping="yes">&lt;!--[if IE]&gt;&lt;script language="javascript" type="text/javascript" src="js/excanvas.js"&gt;&lt;/script&gt;&lt;![endif]--&gt;</xsl:text>
				<script type="text/javascript">
					<xsl:text>function tree(){
						//initialise the data
						var json=</xsl:text><xsl:call-template name="PrintOrgChart"><xsl:with-param name="rootNode" select="$parentActor"/><xsl:with-param name="parentNode" select="$currentActor"/><xsl:with-param name="inScopeActors" select="$inScopeActors"/><xsl:with-param name="level" select="1"/></xsl:call-template><xsl:text>; //end data</xsl:text>
					<xsl:text disable-output-escaping="yes">
						//init OrgTree
						//Create a new ST instance
						var st = new $jit.ST({
						//id of viz container element
						injectInto: 'infovis',
						//set duration for the animation
						duration: 500,
						//set animation transition type
						transition: $jit.Trans.Quart.easeInOut,
						//set distance between node and its children
						levelDistance: 30,
						levelsToShow: 6,
						//Set Default Orientation
						orientation: 'top',
						offsetX: 0,
						offsetY: 120,
						//enable panning
						Navigation: {
						enable:true,
						panning:true
						},
						//set node and edge styles
						//set overridable=true for styling individual
						//nodes or edges
						Node: {
						height: 80,
						width: 80,
						type: 'rectangle',
						color: '#eeeeee', // When switching between nodes this highlights the previous node temporarily. This is the default style if overrideable - below - is set to false
						overridable: true
						},
						
						Edge: {
						type: 'bezier',
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
						st.onClick(node.id);						
							};
							//set label styles
							var style = label.style;
							style.width = 80 + 'px';
							style.height = 80 + 'px';            
							style.cursor = 'pointer';
							style.color = '#333';
							style.fontSize = '0.8em';
							style.textAlign= 'center';
							style.paddingTop = '5px';
							},
							
							//This method is called right before plotting
							//a node. It's useful for changing an individual node
							//style properties before plotting it.
							//The data properties prefixed with a dollar
							//sign will override the global node style properties.
							onBeforePlotNode: function(node){
							//add some color to the nodes in the path between the
							//root node and the selected node.
							if (node.id == "</xsl:text><xsl:value-of select="$param1"/><xsl:text>") {
								node.data.$color = "#f2b035"; // Colour for current org
							}
							<!--if (node.selected) {
							node.data.$color = "#f2b035"; // Colour for root and selected nodes
							}
							else {
								delete node.data.$color;
								//if the node belongs to the last plotted level
									if(!node.anySubnode("exist")) {
									//count children number
									var count = 0;
									node.eachSubnode(function(n) { count++; });
									//assign a node color based on
									//how many children it has
									//node.data.$color = ['#eee', '#bbb', '#bbb', '#bbb', '#bbb', '#bbb', '#bbb' ][count];     // By setting all to fixed colour this removes intensity. first one as Pale Grey highlights no children               
								}
							}-->
							},
							
							//This method is called right before plotting
							//an edge. It's useful for changing an individual edge
							//style properties before plotting it.
							//Edge data proprties prefixed with a dollar sign will
							//override the Edge global style properties.
							onBeforePlotLine: function(adj){
							if (adj.nodeFrom.selected &amp;&amp; adj.nodeTo.selected) {
							adj.data.$color = "#666666"; // Dark Grey to trace the path of chosen nodes
							adj.data.$lineWidth = 3;
							}
							else {
							delete adj.data.$color;
							delete adj.data.$lineWidth;
							}
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

							
							}
						</xsl:text>
				</script>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body onload="tree();">
                
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderProductTypePopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">Organisation Summary for </span>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentActor"/>
											<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
										</xsl:call-template>
									</h1>
								</div>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Description</h2>
							<div class="content-section">
								<p>
									<xsl:if test="count($currentActor/own_slot_value[slot_reference = 'description']/value) = 0">
										<span>-</span>
									</xsl:if>
									<xsl:call-template name="RenderMultiLangInstanceDescription">
										<xsl:with-param name="theSubjectInstance" select="$currentActor"/>
									</xsl:call-template>
								</p>
							</div>
							<hr/>
						</div>


						<!--Setup Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-sitemap icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Organisation Hierarchy')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('The following diagram shows the organisational hierarchy for the')"/>&#160;<xsl:value-of select="$parentActorName"/>&#160; <xsl:value-of select="eas:i18n('as the root organisation')"/>.</p>
							<div class="content-section">
								<xsl:call-template name="infoVis"/>
							</div>
							<hr/>
						</div>


						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-building-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Primary Base Sites</h2>
							<div class="content-section">
								<p>
									<xsl:if test="count($baseSites) = 0">
										<span>-</span>
									</xsl:if>
									<ul>
										<xsl:for-each select="$baseSites">
											<li>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</li>
										</xsl:for-each>
									</ul>

								</p>
							</div>
							<hr/>
						</div>
                        <div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Processes Performed</h2>
							<div class="content-section">
								<table class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>Process</th>
											<th>Description</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$physicalProcess" mode="addProcesses"/>
									</tbody>
                                     
                                </table>
							</div>
							<hr/>
                        </div>
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Organisation Roles</h2>
							<div class="content-section">
								<p>
									<!--<xsl:if test="count($baseSites) = 0">
										<span>-</span>
									</xsl:if>-->
									<ul>
										<xsl:for-each select="$allRolesForActor">
											<li>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</li>
										</xsl:for-each>
									</ul>

								</p>
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



	<!-- TEMPLATE TO DRAW THE ORGANISATION AS A HIERARCHICAL TREE STRUCTURE (USING INVIVIS JAVASCRIPT LIBRARY)-->
	<xsl:template name="infoVis">
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
		<input type="hidden" id="s-normal" name="selection" checked="checked" value="normal"/>
		<input type="hidden" id="r-top" name="orientation" checked="checked" value="top"/>
		<div id="log"/>
	</xsl:template>


	<!-- TEMPLATE TO PRINT OUT THE JSON DATA FOR A GIVEN ACTOR AND ITS SUB-ACTORS -->
	<xsl:template name="PrintOrgChart">
		<xsl:param name="rootNode"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeActors"/>
		<xsl:param name="level"/>

		<xsl:choose>
			<xsl:when test="count($rootNode) > 0">
				<xsl:variable name="rootName" select="$rootNode/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:text>{id: "ROOT",name: "</xsl:text>
				<xsl:value-of select="$rootName"/>
				<xsl:text>",data:{}, children:[</xsl:text>
				<xsl:call-template name="PrintActorTreeDataNamed">
					<xsl:with-param name="parentNode" select="$parentNode"/>
					<xsl:with-param name="inScopeActors" select="$inScopeActors"/>
					<xsl:with-param name="level" select="$level"/>
				</xsl:call-template>
				<xsl:text>]}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="PrintActorTreeDataNamed">
					<xsl:with-param name="parentNode" select="$parentNode"/>
					<xsl:with-param name="inScopeActors" select="$inScopeActors"/>
					<xsl:with-param name="level" select="$level"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>





	<!-- TEMPLATE TO PRINT OUT THE JSON DATA FOR A GIVEN ACTOR AND ITS SUB-ACTORS -->
	<xsl:template name="PrintActorTreeDataNamed">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeActors"/>
		<xsl:param name="level"/>

		<xsl:variable name="parentName" select="$parentNode/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:text>{id: "</xsl:text>
		<xsl:value-of select="$parentNode/name"/>
		<xsl:text>",name: "</xsl:text>
		<xsl:value-of select="$parentName"/>
		<xsl:text>",data:{}, children:[</xsl:text>

		<xsl:if test="$level &lt; $maxDepth">
			<xsl:variable name="childActors" select="$inScopeActors[name = $parentNode/own_slot_value[slot_reference = 'contained_sub_actors']/value]" as="node()*"/>
			<xsl:for-each select="$childActors">
				<xsl:call-template name="PrintActorTreeDataNamed">
					<xsl:with-param name="parentNode" select="current()"/>
					<xsl:with-param name="inScopeActors" select="$inScopeActors"/>
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test="position() != count($childActors)">
						<xsl:text>, </xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
		<xsl:text>]}</xsl:text>
	</xsl:template>


	<!-- TEMPLATE TO PRINT OUT A TABLE LISTING THE ORGANISATIONS IN SCOPE,  THE PRODUCTS (OR SERVICES) THAT THEY PRODUCE AND THEIR LOCATIONS -->
	<xsl:template name="OrganisationCatalogue">
		<xsl:param name="inScopeOrgs"/>

		<script>
			$(document).ready(function(){
				// Setup - add a text input to each footer cell
			    $('#dt_orgs tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
			    } );
				
				var table = $('#dt_orgs').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "25%" },
				    { "width": "25%" },
				    { "width": "25%" },
				    { "width": "25%" }
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
			    
			    $(window).resize( function () {
			        table.columns.adjust();
			    });
			});
		</script>

		<table class="table table-striped table-bordered" id="dt_orgs">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Organisation Unit')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Product/Service')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Service Owner')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Locations')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Organisation Unit')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Product/Service')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Service Owner')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Locations')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:apply-templates select="$inScopeOrgs[type = 'Group_Actor']" mode="PrintOrganisationRows">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>

    <xsl:template match="node()" mode="addProcesses">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisBusProc" select="$businessProcess[name=$this/own_slot_value[slot_reference='implements_business_process']/value]"/>
       <tr>
       		<td>
           		<!--<xsl:value-of select="$thisBusProc/own_slot_value[slot_reference='name']/value"/>-->
       			<xsl:call-template name="RenderInstanceLink">
       				<xsl:with-param name="theSubjectInstance" select="$thisBusProc"/>
       				<xsl:with-param name="theXML" select="$reposXML"/>
       				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
       			</xsl:call-template>
       		</td>
       	<td>
       		<xsl:call-template name="RenderMultiLangInstanceDescription">
       			<xsl:with-param name="theSubjectInstance" select="$thisBusProc"></xsl:with-param>
       		</xsl:call-template>
       	</td>
       </tr> 
    
    </xsl:template>




	<!-- FUNCTION TO RETRIEVE THE LIST OF CHILD ORGS FOR A GIVEN ORG, INCLUDING THE GIVEN ORG ITSELF -->
	<xsl:function name="eas:get_org_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeOrgs"/>
		<xsl:param name="level"/>

		<xsl:copy-of select="$parentNode"/>
		<xsl:if test="$level &lt; $maxDepth">
			<xsl:variable name="childOrgs" select="$inScopeOrgs[name = $parentNode/own_slot_value[slot_reference = 'contained_sub_actors']/value]" as="node()*"/>
			<xsl:for-each select="$childOrgs">
				<xsl:copy-of select="eas:get_org_descendants(current(), $inScopeOrgs, $level + 1)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>


</xsl:stylesheet>
