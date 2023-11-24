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
	<xsl:variable name="linkClasses" select="('Group_Actor', 'Individual_Actor', 'Product_Type', 'Product', 'Business_Function', 'Site')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- SET THE VARIABLES THAT ARE REQUIRED REPEATEDLY THROUGHOUT -->
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Group_Actor') or (type = 'Individual_Actor')]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
	<xsl:variable name="allProducts" select="/node()/simple_instance[type = 'Product']"/>
	<xsl:variable name="allProductTypes" select="/node()/simple_instance[type = 'Product_Type']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allLocations" select="/node()/simple_instance[type = 'Geographic_Region']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="processManagerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Process Manager')]"/>
	<xsl:variable name="processManagerStakeholders" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processManagerRole/name]"/>
	<xsl:variable name="maxDepth" select="6"/>

	<xsl:variable name="rootOrgID">
		<xsl:choose>
			<xsl:when test="string-length($param1) > 0">
				<xsl:value-of select="$param1"/>
			</xsl:when>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root_Organisation') and (own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name)]"/>
				<xsl:value-of select="/node()/simple_instance[name = $rootOrgConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/name"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Root_Organisation')]"/>
				<xsl:value-of select="/node()/simple_instance[name = $rootOrgConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="parentActor" select="/node()/simple_instance[name = $rootOrgID]"/>
	<xsl:variable name="relevantActors" select="$allActors"/>
	<xsl:variable name="parentActorName" select="$parentActor/own_slot_value[slot_reference = 'name']/value"/>

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
	<!-- Display a list of business processes scoped by a given taxonomy term (param1) that allows the user to select one for impact analysis purposes -->
	<!-- 12.03.2011	JP	First coding -->
	<!--19.09.11 NW Updated to support Viewer 3.0-->


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('Organisation Structure Model')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeActors" select="$relevantActors[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="inScopeActors" select="$relevantActors"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Organisation Structure Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeActors"/>

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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
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
				<script language="javascript" type="text/javascript" src="js/jit-yc.js?release=6.19"/>
				<script language="javascript" type="text/javascript" src="js/org_tree.js?release=6.19"/>
				<!--<script language="javascript" type="text/javascript" src="js/excanvas.js?release=6.19" />-->
				<xsl:text disable-output-escaping="yes">&lt;!--[if IE]&gt;&lt;script language="javascript" type="text/javascript" src="js/excanvas.js?release=6.19"&gt;&lt;/script&gt;&lt;![endif]--&gt;</xsl:text>
				<script type="text/javascript">
					<xsl:text>function tree(){
						//initialise the data
						var json=</xsl:text><xsl:call-template name="PrintActorTreeDataNamed"><xsl:with-param name="parentNode" select="$parentActor"/><xsl:with-param name="inScopeActors" select="$inScopeActors"/><xsl:with-param name="level" select="1"/></xsl:call-template><xsl:text>; //end data</xsl:text>
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
						levelDistance: 50,
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
							if (node.selected) {
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
							}
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
										<span class="text-darkgrey">
											<xsl:value-of select="$pageLabel"/>
										</span>
									</h1>
								</div>
							</div>
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


						<!--Setup Organisation Service Catalogue Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Organisation Service Catalogue')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('The following table lists the Business Services that are produced by the organisation units within the')"/>&#160; <xsl:value-of select="$parentActorName"/>&#160; <xsl:value-of select="eas:i18n('organisation')"/>.</p>
							<xsl:call-template name="OrganisationCatalogue">
								<!--<xsl:with-param name="inScopeOrgs" select="$inScopeActors" />-->
								<xsl:with-param name="inScopeOrgs" select="eas:get_org_descendants($parentActor, $inScopeActors, 0)"/>
							</xsl:call-template>
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

		<xsl:if test="$level &lt; 5">
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
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
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

				let seen = {};
				let tbl = document.getElementById('dt_orgs');
				let rows = tbl.getElementsByTagName('tr');

				for (let i = rows.length - 1; i > 0; i--) {
					console.log()
					let cell = rows[i].getElementsByTagName('td')[0];
				 
					if (cell) {
						let content = cell.textContent || cell.innerText;
						if (seen[content]) {
							tbl.deleteRow(i);
						} else {
							seen[content] = true;
						}
					}
				}
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
			<xsl:for-each-group select="$inScopeOrgs[type = 'Group_Actor']" group-by="own_slot_value[slot_reference = 'name']/value">
			<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
			<xsl:apply-templates select="current-group()" mode="PrintOrganisationRows"/>
			</xsl:for-each-group>
		<!-- 
				<xsl:apply-templates select="$inScopeOrgs[type = 'Group_Actor']" mode="PrintOrganisationRows">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
					-->
			</tbody>
		</table>
	</xsl:template>


	<!-- OLD TEMPLATE TO PRINT OUT ONE OR MORE ROWS FOR A GIVEN ORGANISATION, INCLUDING THE NUMBER OF PRODUCTS (OR SERVICES) THAT THE ORGANISATION PRODUCES -->
	<xsl:template match="node()" mode="PrintOrganisationRows">
		<xsl:variable name="orgName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentOrg" select="current()"/>

		<xsl:variable name="actor2Roles" select="$allActor2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="physProcs" select="$allPhysProcs[own_slot_value[slot_reference = 'process_performed_by_actor_role']/value = $actor2Roles/name]"/>
		<xsl:variable name="products" select="$allProducts[own_slot_value[slot_reference = 'product_implemented_by_process']/value = $physProcs/name]"/>

		<xsl:choose>
			<xsl:when test="count($products) = 0">
				<!-- Print out the name of the Organisation -->
				<tr>
					<td>
						<strong>
							<!--<xsl:value-of select="$orgName" />-->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentOrg"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</strong>
					</td>

					<!-- Print out a blank space as there is no product-->
					<td>
						<xsl:text>-</xsl:text>
					</td>

					<!-- Print out a blank space as there is no product owner-->
					<td>
						<xsl:text>-</xsl:text>
					</td>

					<!-- Print out the name of the location where the organisation is based -->
					<xsl:variable name="actorSite" select="$allSites[name = $currentOrg/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>

					<xsl:choose>
						<xsl:when test="count($actorSite) = 0">
							<td>
								<p>
									<xsl:text>-</xsl:text>
								</p>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<ul>
									<xsl:for-each select="$actorSite">
										<xsl:variable name="actorSiteName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
										<xsl:variable name="siteLocation" select="$allLocations[name = current()/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
										<xsl:variable name="siteLabel">
											<xsl:choose>
												<xsl:when test="count($siteLocation) > 0">
													<xsl:variable name="siteLocationName" select="$siteLocation/own_slot_value[slot_reference = 'name']/value"/>
													<xsl:value-of select="concat($actorSiteName, ' (', $siteLocationName, ')')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$actorSiteName"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<li>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$actorSite"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="displayString" select="$siteLabel"/>
											</xsl:call-template>
										</li>
									</xsl:for-each>
									<!--<xsl:value-of select="$actorSiteName" /> (<xsl:value-of select="$siteLocationName" />)-->
								</ul>
							</td>
						</xsl:otherwise>
					</xsl:choose>

				</tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$products">
					<tr>
						<!-- Print out the name of the Organisation -->
						<td>
							<strong>
								<!--<xsl:value-of select="$orgName" />-->
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$currentOrg"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</strong>
						</td>

						<xsl:variable name="productType" select="$allProductTypes[own_slot_value[slot_reference = 'product_type_instances']/value = current()/name]"/>
						<!-- Print out the name of the Product Type produced by the organisation-->
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
							<xsl:if test="count($productType) > 0">(<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$productType"/>
								</xsl:call-template>)</xsl:if>
							<!--<ul>
								<xsl:apply-templates mode="PrintProductType" select="$productTypes">
									<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</ul>-->
						</td>

						<xsl:variable name="physProc" select="$physProcs[name = current()/own_slot_value[slot_reference = 'product_implemented_by_process']/value]"/>

						<xsl:variable name="physProcManagerActor2Role" select="$processManagerStakeholders[name = $physProc/own_slot_value[slot_reference = 'stakeholders']/value]"/>
						<xsl:variable name="physProcManagerFromRole" select="$allActors[name = $physProcManagerActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
						<xsl:variable name="physProcManagerDEPRECATED" select="$allActors[name = $physProc/own_slot_value[slot_reference = 'process_manager']/value]"/>
						<xsl:variable name="physProcManager" select="$physProcManagerFromRole union $physProcManagerDEPRECATED"/>
						<!--<xsl:variable name="physProcManagerName" select="$physProcManager/own_slot_value[slot_reference = 'name']/value"/>-->
						<xsl:variable name="sites" select="$allSites[name = $physProc/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>

						<!-- Print out the name of the actor that manages the process that produces the product -->
						<td>
							<!--<xsl:value-of select="$physProcManagerName" />-->
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$physProcManager"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>

						<xsl:choose>
							<!-- If there is no site associated with the physical process, print out the location of the base site for the manager of the process -->
							<xsl:when test="count($sites) = 0">
								<xsl:variable name="actorSite" select="$allSites[name = $currentOrg/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
								<xsl:variable name="actorSiteName" select="$actorSite/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="siteLocation" select="$allLocations[name = $actorSite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
								<xsl:variable name="siteLocationName" select="$siteLocation/own_slot_value[slot_reference = 'name']/value"/>
								<!-- Print out the name of the location where the actor is based -->
								<td>
									<ul>
										<li>
											<!--<xsl:value-of select="$actorSiteName" /> (<xsl:value-of select="$siteLocationName" />)-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$actorSite"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<!--<xsl:with-param name="displayString" select="concat($actorSiteName, ' (', $siteLocationName, ')')"/>-->
											</xsl:call-template>
											<xsl:if test="count($siteLocation) > 0"> (<xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$siteLocation"/></xsl:call-template>)</xsl:if>
										</li>
									</ul>
								</td>
							</xsl:when>

							<!-- If there is only one site associated with the physical process, print out the location of the this site -->
							<xsl:when test="count($sites) = 1">
								<xsl:variable name="actorSite" select="$allSites[name = $currentOrg/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
								<xsl:variable name="siteLocation" select="$allLocations[name = $sites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
								<xsl:variable name="actorSiteName" select="$sites/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="siteLocationName" select="$siteLocation/own_slot_value[slot_reference = 'name']/value"/>
								<!-- Print out the name of the location where the actor is based -->
								<td>
									<ul>
										<li>
											<!--<xsl:value-of select="$actorSiteName" /> (<xsl:value-of select="$siteLocationName" />)-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$actorSite"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<!--<xsl:with-param name="displayString" select="concat($actorSiteName, ' (', $siteLocationName, ')')"/>-->
											</xsl:call-template>
											<xsl:if test="count($siteLocation) > 0"> (<xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$siteLocation"/></xsl:call-template>)</xsl:if>
										</li>
									</ul>
								</td>
							</xsl:when>

							<!-- If there is more that one site associated with the physical process, print out the associated locations as a list -->
							<xsl:when test="count($sites) > 1">
								<td>
									<ul>
										<xsl:for-each select="$sites">
											<xsl:variable name="actorSite" select="$allSites[name = $currentOrg/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
											<xsl:variable name="siteLocation" select="$allLocations[name = current()/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
											<xsl:variable name="actorSiteName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
											<xsl:variable name="siteLocationName" select="$siteLocation/own_slot_value[slot_reference = 'name']/value"/>
											<li>
												<!--<xsl:value-of select="$actorSiteName" /> (<xsl:value-of select="$siteLocationName" />)-->
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$actorSite"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													<!--<xsl:with-param name="displayString" select="concat($actorSiteName, ' (', $siteLocationName, ')')"/>-->
												</xsl:call-template>
												<xsl:if test="count($siteLocation) > 0"> (<xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$siteLocation"/></xsl:call-template>)</xsl:if>
											</li>
										</xsl:for-each>
									</ul>
								</td>
							</xsl:when>
						</xsl:choose>

					</tr>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>

	<!--<xsl:template match="node()" mode="PrintProductType">
		<xsl:variable name="productTypeName" select="own_slot_value[slot_reference = 'name']/value"/>
		<!-\- Print out the name of the Product Type -\->
		<li>
			<!-\-<a id="{$productTypeName}" class="context-menu-prodType menu-1">
				<xsl:call-template name="RenderLinkHref">
					<xsl:with-param name="theInstanceID">
						<xsl:value-of select="current()/name" />
					</xsl:with-param>
					<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
					<!-\-<xsl:with-param name="theParam4" select="$param4" />-\->
					<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
					<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
				</xsl:call-template>
				<xsl:value-of select="$productTypeName" />
			</a>-\->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>-->


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
