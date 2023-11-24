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


	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<!--<xsl:include href="../business/menus/core_product_type_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="param1"></xsl:param>
	<!-- param1 = the id of the root (group) actor -->
	<!--<xsl:param name="param1"/>-->

	<!-- param4 = the taxonomy term that will be used to scope the organisation model -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<!--	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'" />
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')" />-->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Group_Actor', 'Individual_Actor', 'Individual_Business_Role', 'Group_Business_Role', 'Site', 'Business_Process', 'Business_Activity', 'Business_Task', 'Composite_Application_Provider','Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Org Summmary']"/>
    
    

	<!-- SET THE VARIABLES THAT ARE REQUIRED REPEATEDLY THROUGHOUT -->
	
	<!--
		* Copyright © 2008-2021 Enterprise Architecture Solutions Limited.
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

<xsl:template match="knowledge_base">
    <xsl:call-template name="docType"/>
    <xsl:variable name="apiPath">
        <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$anAPIReport"/>
        </xsl:call-template>
    </xsl:variable>
	<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title> Organisation Summary 
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
					}
					.odd1 {border-left:3pt solid red;
						background-color: #f9f9f9;}
                    .focusOrg{display:inline-block}
					.bottomDiv { 
							position: fixed;
							bottom: 0;
							right: 0;
							margin:30px;
							width:250px;
							height:250px;
							border-radius:4px;
							padding:5px;
							border:1pt solid rgb(208, 208, 208);
							background-color:rgb(235, 232, 232); 
							box-shadow: 5px 10px 8px #888888;
						} 
					
					.selectOrgBoxHolder{
						top:-30px;
						position:relative;
					}	

					.selectOrgBox{
						width:200px;
						font-size:10px; 
					}	
                  
                    </style>
				<script language="javascript" type="text/javascript" src="js/jit-yc.js?release=6.19"/>
				<script language="javascript" type="text/javascript" src="js/org_tree.js?release=6.19"/>
				<!--<script language="javascript" type="text/javascript" src="js/excanvas.js?release=6.19" />-->
				<xsl:text disable-output-escaping="yes">&lt;!--[if IE]&gt;&lt;script language="javascript" type="text/javascript" src="js/excanvas.js?release=6.19"&gt;&lt;/script&gt;&lt;![endif]--&gt;</xsl:text>
				<script type="text/javascript">
					<xsl:text>function tree(dataset, parentID){
    					//initialise the data
                        var json=dataset[0]
                          
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

							if(node.id=='ROOT')
							{
								$('.selectOrgBox').val(parentID);  }
							else
							{
								$('.selectOrgBox').val(node.id); 
								} 
						$('.selectOrgBox').trigger('change');
					 

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
            <body>
                
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
										<span class="text-darkgrey">Organisation Summary for </span><div class="focusOrg" id="focusOrg"/>
										
									</h1>
									<div class="pull-right selectOrgBoxHolder">
										<select class="selectOrgBox"></select>
									</div>
									
								</div>
							</div>
							<xsl:call-template name="RenderDataSetAPIWarning"/>
						</div>
 

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Description</h2>
							<div class="content-section">
								<p>
									<div id="description"></div>
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
							<p><xsl:value-of select="eas:i18n('The following diagram shows the organisational hierarchy for the')"/>&#160;<span id="rootName"></span>&#160; <xsl:value-of select="eas:i18n('as the root organisation')"/>.</p>
							<div class="content-section">
								<xsl:call-template name="infoVis"/>
							</div>
							<hr/>
						</div>


						<div class="col-xs-6">
							<div class="sectionIcon">
								<i class="fa fa-building-o icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Primary Base Sites</h2>
							<div class="content-section">
                                <table id="sites" class="table table-striped">
                                    <thead>
                                    <tr><th>Site</th></tr>
                                    </thead>
                                </table> 
							</div>
							<hr/>
                        </div>
                        <div class="col-xs-6">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Organisation Roles</h2>
							<div class="content-section">
                                 
                                <table id="roles" class="table table-striped">
                                    <thead>
                                    <tr><th>Role</th></tr>
                                    </thead>
                                </table> 
							 
							</div>
							<hr/>
						</div>
                        <div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Processes Performed</h2>
                            <div class="content-section">
                                <table id="processes" class="table table-striped">
                                    <thead>
                                    <tr><th>Process</th><th>Description</th></tr>
                                    </thead>
                                </table>
							</div>
							<hr/> 
                        </div>
						
					 
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-th-large icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Applications Used</h2>
                            <div class="content-section">
                                <table id="applications" class="table table-striped">
                                    <thead>
                                    <tr><th>Application</th><th>Description</th></tr>
                                    </thead>
                                </table> 
							</div>
							<hr/>
                        </div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="bottomDiv">X</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
<script>
<xsl:call-template name="RenderViewerAPIJSFunction">
    <xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
</xsl:call-template>
</script>
<script id="roles-template" type="text/x-handlebars-template">
    {{#if this}}
    <table id="roles" class="table table-striped">
      <tr><th>Role</th></tr>
                                   
        {{#each this}}
        <tr><td class="role"> {{{this.link}}} </td></tr>
        {{/each}} 
    </table>   
    {{else}}
        None Set
    {{/if}}
</script>   
<script id="apps-template" type="text/x-handlebars-template"> 
    {{#if this}} 
    <table id="applications" class="table table-striped"> 
        <tr><th width="20%">Applications Used</th><th>Description</th></tr>
        {{#each this}}
        <tr><td> {{{this.link}}} <i class="fa fa-circle appcircle"><xsl:attribute name="id">{{this.id}}</xsl:attribute></i></td><td>{{this.description}}</td></tr>
        {{/each}} 
    </table>  
    {{else}}
        None Set
    {{/if}}
</script>   
<script id="processes-template" type="text/x-handlebars-template">
    {{#if this}} 
        <table id="processes" class="table table-striped"> 
        <tr><th>Processes</th><th>Description</th></tr>
        {{#each this}}
        <tr><td> {{{this.link}}}</td><td>{{this.description}}</td></tr>
        {{/each}} 
    </table>  
    {{else}}
        None Set
    {{/if}}
</script>   
<script id="sites-template" type="text/x-handlebars-template">
    {{#if this}} 
    <table id="sites" class="table table-striped">
        <tr><th>Site</th></tr>
        {{#each this}}
        <tr><td> {{{this.link}}}</td></tr>
        {{/each}} 
    </table>
    {{else}}
        None Set
    {{/if}}
 
</script>   
<script id="appsnippet-template" type="text/x-handlebars-template">
	<h3>{{this.name}}</h3><br/>
	{{this.codebase}} 
</script> 

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

    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
         <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderAPILinkText">  <!-- change to RenderAPILinkTextTestingNoCache for local testing -->
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
        
    </xsl:template>

    <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/> 
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
       
 
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

            sitesFragment = $("#sites-template").html();
            sitesTemplate = Handlebars.compile(sitesFragment);
				   
			appsnippetFragment = $("#appsnippet-template").html();
			appsnippetTemplate = Handlebars.compile(appsnippetFragment);
			
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
         promise_loadViewerAPIData(viewAPIData)
            .then(function(response1) {
                    
               orgData=response1.orgData; 
       
			   orgData.forEach((d)=>{
			   		$('.selectOrgBox').append('&lt;option value='+d.id+' >'+d.name+'&lt;option>');
				});

				$('.selectOrgBox').val(focusID);  
				$('.selectOrgBox').trigger('change');

			   appsData=response1.appsList;
			   orgData.forEach(function(d){
				   d.applicationsUsed.forEach(function(dapp){
				 
						let app = appsData.filter(function(e){
							return e.id ==dapp.id;
						});
						dapp['description']=app[0].description;
						dapp['name']=app[0].name;
						dapp['link']=app[0].link;
						dapp['info']='&lt;i class="fa fa-circle appcircle" id="'+app[0].id+'">&lt;/i>';
			   		})
				})
	
				drawView();

            $('#roles').DataTable();
            $('#processes').DataTable();
            $('#sites').DataTable();
            $('#applications').DataTable();
            //fixes for datables
			 
			setColours();

			$('.selectOrgBox').on('change',function(){
				focusID=$('.selectOrgBox').val();
				$('#infovis').empty();

				$('#roles').DataTable().clear();
           		$('#processes').DataTable().clear();
            	$('#sites').DataTable().clear();
            	$('#applications').DataTable().clear(); 
				updateView();
			});

$('.paginate_button').on('click', function(){
	setColours();
});
$('.table').on( 'order.dt',  function () { 
	setColours();
  })

$('.dataTables_length').on('change', function(){
	 
	setColours();
});
$('.input-sm').on('keypress', function(){
 
	setColours();
});

<!-- future
$('#applications .sorting_1').on('mouseover',function(){
	let idStr=$(this).find('a').attr('id');
	let appId=idStr.substring(0, idStr.length-4);
	
	let focusApp = appsData.filter(function(d){
		return d.id==appId;
	})
console.log(appId);
console.log(focusApp)
$('.bottomDiv').show()
	$('.bottomDiv').html(appsnippetTemplate(focusApp[0]))
})
$('#applications .sorting_1').on('mouseout',function(){
	$('.bottomDiv').hide()
})
-->

            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
  
        });

function drawView(){
	let selectedOrg=orgData.filter((d)=>{
					return d.id==focusID
				});
 
selectedOrg[0]['physicalProcess']=selectedOrg[0].physicalProcess.filter((elem, index, self) => self.findIndex( (t) => {return (t.id === elem.id)}) === index)
               setOrg(selectedOrg[0]);
               setPanel(selectedOrg[0]);
}		


function updateView(){
	let selectedOrg=orgData.filter((d)=>{
					return d.id==focusID
				}); 
	 
               setOrg(selectedOrg[0]); 
			   updatePanel(selectedOrg[0]);
}	

function setColours(){
	<!--
	$('#roles').find('.even').find('td').css({'background-clip': 'padding-box',
						'border-radius': '8px 0px 0px 8px',
						'background-color': '#f9f9f9',
						'color': 'black',
						'border': '3px solid white',
						'border-left':'3pt solid red', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});
			$('#roles').find('.odd').find('td').css({'background-clip': 'padding-box',
						'border-radius':'8px 0px 0px 8px',
						'background-color': '#fff',
						'color': 'black',
						'border': '3px solid white',
						'border-left':'3pt solid red', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});

			$('#processes').find('.odd').find('.sorting_1').css({'background-clip': 'padding-box',
						'border-radius': '8px 0px 0px 8px',
						'background-color': '#f9f9f9',
						'color': 'black',
						'border': '3px solid white',
						'border-right':'0px',
						'border-left':'3pt solid #50c79d', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});
			$('#processes').find('.even').find('.sorting_1').css({'background-clip': 'padding-box',
						'border-radius': '8px 0px 0px 8px',
						'background-color': '#fff',
						'color': 'black',
						'border': '3px solid white',
						'border-right':'0px',
						'border-left':'3pt solid #50c79d', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});

			$('#applications').find('.even').find('td').css({'background-clip': 'padding-box',
						'border-radius': '8px 0px 0px 8px',
						'background-color': '#f9f9f9',
						'color': 'black',
						'border': '3px solid white',
						'border-left':'3pt solid #eba53d', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});
			$('#applications').find('.odd').find('td').css({'background-clip': 'padding-box',
						'border-radius':'8px 0px 0px 8px',
						'background-color': '#fff',
						'color': 'black',
						'border': '3px solid white',
						'border-left':'3pt solid #eba53d', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});
			
			$('#sites').find('.even').find('td').css({'background-clip': 'padding-box',
						'border-radius': '8px 0px 0px 8px',
						'background-color': '#f9f9f9',
						'color': 'black',
						'border': '3px solid white',
						'border-left':'3pt solid #bf93f5', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});
			$('#sites').find('.odd').find('td').css({'background-clip': 'padding-box',
						'border-radius':'8px 0px 0px 8px',
						'background-color': '#fff',
						'color': 'black',
						'border': '3px solid white',
						'border-left':'3pt solid #bf93f5', 'border-bottom':'1pt solid #fff',
						'border-top':'1pt solid #ddd'});			
-->
}

function setOrg(focus){ 
            
            $('#focusOrg').html(focus.name)
            $('#description').html(focus.description) 
			let parentOrg;
			orgData.forEach((d)=>{
				letParent=d.childOrgs.find((s)=>{
					return s == focus.id;
					})
				if(letParent){
					parentOrg=d.id
				}
				 	
			});
	 
            tree(focus.data[0].vis, parentOrg)
      }  






      function setPanel(focus){
 

let processReport = $("#processes");
let rolesReport = $("#roles");
let sitesReport = $("#sites");
let applicationsReport = $("#applications");

    processReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.physicalProcess,
        "columns" : [
            { "data" : "link" },
            { "data" : "description" }
        ] 
    });
    rolesReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.orgUsers,
        "columns" : [
            { "data" : "link" }
        ] 
    });
    sitesReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.site,
        "columns" : [
            { "data" : "link" } 
        ] 
    });
    applicationsReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.applicationsUsed,
        "columns" : [
			{ "data" : "link"},
			{"data":"description" }
        ] 
    });     

    }

	function updatePanel(focus){
 

let processReport = $("#processes");
let rolesReport = $("#roles");
let sitesReport = $("#sites");
let applicationsReport = $("#applications");
 

rolesReport.DataTable().destroy();
if(focus.orgUsers.length&gt;0){
	rolesReport.DataTable({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.orgUsers,
        "columns" : [
            { "data" : "link" }
        ] 
    });
}

processReport.DataTable().destroy();
if(focus.physicalProcess.length&gt;0){	
	processReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.physicalProcess,
        "columns" : [
            { "data" : "link" },
            { "data" : "description" }
        ] 
    });
}
	sitesReport.DataTable().destroy();
if(focus.site.length&gt;0){	
    sitesReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.site,
        "columns" : [
            { "data" : "link" } 
        ] 
    });
}

	applicationsReport.DataTable().destroy();
if(focus.applicationsUsed.length&gt;0){	
    applicationsReport.DataTable ({
		"dom": '&lt;"top"f>rt&lt;"bottom"ilp>&lt;"clear">',
        "data" : focus.applicationsUsed,
        "columns" : [
			{ "data" : "link" },
			{ "data" : "description" }
        ] 
    });     
}

    }

  
        
    </xsl:template>

</xsl:stylesheet>
