<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../business/core_bl_utilities.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" use-character-maps="c-1replace"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>

	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Node', 'Application_Provider', 'Geographic_Region')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	 
	
	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Node Catalogue')"/>
	</xsl:variable>

	<xsl:variable name="techNodeListByNameCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Name')]"/>
	<xsl:variable name="techNodeListByVendorCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Vendor')]"/>
	<xsl:variable name="techNodeListByProductCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Product')]"/>
	<xsl:variable name="techNodeListAsTable" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue as Table')]"/>
  
	<xsl:variable name="anAPIReportParam" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Get Tech Nodes']"/>
	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
 <xsl:variable name="apiPathParam">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportParam"/>
	</xsl:call-template>
</xsl:variable>	
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
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
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
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>

								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Name'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByVendorCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByProductCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Product'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Table')"/>
									</span>
									<!--<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListAsTable"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Table'"/>
										</xsl:call-template>
									</span>-->
								</div>
<xsl:call-template name="RenderDataSetAPIWarning"/>
							</div>
							
							<!--Setup the Catalogue section-->
							<div class="row">
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-list-ul icon-section icon-color"/>
									</div>
									<h2>
										<xsl:value-of select="eas:i18n('Catalogue')"/>
									</h2>
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('The table below shows a catalogue of all the Technology Nodes that have been captured')"/>.</p>
									 	<table id="dt_server" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Node')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('IP Address')"/>
										</th>
										
										<th>
											<xsl:value-of select="eas:i18n('Deployed Apps')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Host Description')"/>
										</th>
    									<th>
											<xsl:value-of select="eas:i18n('Host Location')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Node')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('IP Address')"/>
										</th>
										
										<th>
											<xsl:value-of select="eas:i18n('Deployed Apps')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Host Description')"/>
										</th>
    									<th>
											<xsl:value-of select="eas:i18n('Host Location')"/>
										</th>
                                    </tr>
								</tfoot>
								<tbody/>								
							</table>
			 	 
									</div>
								</div>
							</div>


						</div>
					</div>
				</div>


	<script>
var nodes, appListTemplate;	
var inScopeNodes		
			$(document).ready(function(){
			
	
			});
		</script>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
	 <script>
            <xsl:call-template name="RenderViewerAPIJSFunction">
                <xsl:with-param name="viewerAPIPath" select="$apiPathParam"/>
            </xsl:call-template>
                
</script>		
	<script id="app-list-bullets" type="text/x-handlebars-template">
						{{#each this.apps}}
							- {{{this.link}}} ({{#each this.deployment}}{{this.deploy}} {{/each}})<br/>
						{{/each}}
	</script>			
		</html>
	</xsl:template>


	   <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/>
        <!--<xsl:param name="viewerAPIPathParam"/>-->
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
      
    var nodetable;
  
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
       
        
        
        
        $('document').ready(function () {
		    var appListFragment   = $("#app-list-bullets").html();
		    appListTemplate = Handlebars.compile(appListFragment);
    <!--    
       //OPTON 1: Call the API request function multiple times (once for each required API Report), then render the view based on the returned data
            Promise.all([
                promise_loadViewerAPIData(viewAPIData),
                promise_loadViewerAPIData(viewAPIDataParam)
            ])
            .then(function(responses) {
                //after the data is retrieved, set the global variable for the dataset and render the view elements from the returned JSON data (e.g. via handlebars templates)
                let viewAPIData = responses[0];
                //render the view elements from the first API Report
                let anotherAPIData = responses[1];
                //render the view elements from the second API Report
		
		    console.log(viewAPIData);
		console.log(anotherAPIData);
		
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
            
    -->
        //OPTON 2: Indivisual or Chained multiple promises so that you can retrieve API Report data and update view elements incrementally
 
      <!--  
         promise_loadViewerAPIData(viewAPIData)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                
               console.log(response1)
           
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
-->
	<!--	
		 promise_loadViewerAPIData(viewAPIDataParam)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                
               //DO HTML stuff
           
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
     -->       
    promise_loadViewerAPIData(viewAPIData)
	.then(function(response) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                
				nodes=response;   
           		inScopeNodes={"technology_nodes":nodes.technology_nodes};
         console.log('nodes');    console.log(nodes)
				// Setup - add a text input to each footer cell
		   
			    $('#dt_server tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
			    } );
					 
				nodetable = $('#dt_server').DataTable({
				scrollY: "350px",
		   		paging: true,					
		   		deferRender:    true,
				scrollCollapse: true,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "25%" },
				    { "width": "10%" },
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
					console.log('2');
				
				// Apply the search
			    nodetable.columns().every( function () {
			        var that = this;
			 
			        $( 'input', this.footer() ).on( 'keyup change', function () {
			            if ( that.search() !== this.value ) {
			                that
			                    .search( this.value )
			                    .draw();
			            }
			        } );
			    } );
			    
			    nodetable.columns.adjust();
			     
			    $(window).resize( function () {
			        nodetable.columns.adjust();
			    });
		 
		   <!--
					if(roadmapEnabled) {
								    	registerRoadmapDatatable(table);
								    }
				-->
			console.log('Redrawing View');;	
		   redrawView();
			  })
            .catch (function (error) {
                //display an error somewhere on the page   
            });	
		
		
function redrawView() {
									<!-- ***REQUIRED*** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS -->
									<!-- if(roadmapEnabled) {
										//update the roadmap status of the applications and application provider roles passed as an array of arrays
										rmSetElementListRoadmapStatus([nodes.technology_nodes]);
										
										 ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME  
										//filter applications to those in scope for the roadmap start and end date
										nodes.technology_nodes = rmGetVisibleElements(servers.technology_nodes);
									} else {
										inScopeNodes.technology_nodes = nodes.technology_nodes;
									}
-->
									inScopeNodes.technology_nodes = nodes.technology_nodes;
		   				console.log('inScopeNodes');		console.log(inScopeNodes)
									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setServerTable();
																						
								}		
function setServerTable() {					
									var tableData = renderServerTableData();								console.log(tableData)
									nodetable.clear();
									nodetable.rows.add(tableData);
			    					nodetable.draw();
								}
							  	//function to create the data structure needed to render table rows
function renderServerTableData() {
									var dataTableSet = [];
									var dataTableRow=[];
		 
									//Note: The list of nodes is based on the "inScopeNodes" variable which ony contains nodes visible within the current roadmap time frame
									for (var i = 0; inScopeNodes.technology_nodes.length > i; i += 1) {
		  
										dataTableRow = [];
										//get the current App
										aSrv = inScopeNodes.technology_nodes[i];
 										appListHTML = appListTemplate(aSrv);
										dataTableRow.push(aSrv.link);
		   								dataTableRow.push(aSrv.ip);
		   								dataTableRow.push(appListHTML);
										dataTableRow.push(aSrv.description);
										dataTableRow.push(aSrv.country);
		   
										dataTableSet.push(dataTableRow);
									}
				
									return dataTableSet;
								}	   
        
        
        });
        
    </xsl:template>
<xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderAPILinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
        
    </xsl:template>
    
</xsl:stylesheet>
