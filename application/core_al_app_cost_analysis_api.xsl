<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:import href="../application/core_al_app_cost_revenue_functions.xsl"/>
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
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<!-- VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="allAppsIncContained" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
    <xsl:variable name="allApps" select="$allAppsIncContained[not(name=$allAppsIncContained/own_slot_value[slot_reference='contained_application_providers']/value)]"/>
  
	<xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
 
    <xsl:variable name="site" select="/node()/simple_instance[type = 'Site']"/> 
    <xsl:variable name="location" select="/node()/simple_instance[type = ('Geographic_Region')][name = $site/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>

	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($allApps)"/>
	<xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	
	<xsl:variable name="isAuthzForCostClasses" select="eas:isUserAuthZClasses(('Cost', 'Cost_Component'))"/>
 
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: APM Costs']"/>
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
		<html>
			<head>
				<script src="js/es6-shim/0.9.2/es6-shim.js" type="text/javascript"/>
				<xsl:call-template name="commonHeadContent"/>
       <!--         <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template> -->
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Cost Analysis</title>
				<script language="javascript" type="text/javascript" src="js/excanvas.js"/>
				<script language="javascript" type="text/javascript" src="js/jqplot/jquery.jqplot.min.js"/>
				<link rel="stylesheet" type="text/css" href="js/jqplot/jquery.jqplot.css"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.pieRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.barRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.categoryAxisRenderer.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.pointLabels.min.js"/>
				<script type="text/javascript" src="js/jqplot/plugins/jqplot.enhancedLegendRenderer.min.js"/>
                <link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<style>
					.pieChartContainer{
					    width: 50%;
					    height: 300px;
					    float: left;
					    box-sizing: border-box;
					}
					
					.pieChart{
					    width: 100%;
					    height: 100%;
					}
					
					.pieChart > table{
					    width: 40%;
					    
					}
					
					.jqplot-table-legend{
					    width: 200px;
					    max-width: 200px;
					    padding: 10px;
					}
					
					table.jqplot-table-legend, table.jqplot-cursor-legend {
						border: none;
					}
					
					.jqplot-table-legend-swatch{
					    width: 16px;
					}
					
					.jqplot-table-legend-label{
					    width: auto;
					    padding: 10px;
					    margin-top: 10px;
					}
					
					.jqplot-data-label{
					    font-size: 16px;
					}
					
					.jqplot-table-legend-label{
					    font-size: 12px;
					}</style>
				
				<!-- ***REQUIRED*** ADD THE JS LIBRARIES IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- ***REQUIRED*** ADD THE ROADMAP WIDGET FLOATING DIV -->
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
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
<<<<<<< Updated upstream
									<span class="text-darkgrey">Application Cost Analysis</span> - <span class="text-primary" id="app-cost-total"></span>
								</h1>                                       
							</div>
							<div id="page-spinner">
								<div class="eas-logo-spinner">
									<div class="spin-icon" style="width: 60px; height: 60px;">
										<div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
										<div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
										<div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
									</div>						
									<!--<div class="spin-text">Loading...</div>-->
								</div>
								<p class="spin-text text-center xlarge top-10" style="float: none;">Loading...</p>
							</div>
=======
									<span class="text-darkgrey">Application Cost Dashboard</span> - <span class="text-primary" id="app-cost-total"></span>
								</h1>
                                    
                            <div class="eas-logo-spinner top-20" style="margin: auto">
                                    <!--<div style="padding-left:95%;"><i class="fa fa-refresh fa-spin fa-3x fa-fw"></i> <div class="spin-text">Loading...</div></div>-->
                                    <div class="spin-icon">
                                    <div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
                                    <div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
                                    <div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
                                    </div> 
                                    
                                    </div>        
                                    </div>                               
							</div>            
>>>>>>> Stashed changes
						</div>
                        <div class="clearfix"/>
						<div id="main-cost-section" class="col-xs-12 hiddenDiv">
							<div class="pieChartContainer">
								<h2 class="text-primary">Cost By Type</h2>
								<div class="pieChart" id="costTypePieChart"/>
							</div>
							<div class="pieChartContainer">
								<h2 class="text-primary">Cost by Differentiation Level</h2>
								<div class="pieChart" id="diffLevelPieChart"/>
							</div>
							<xsl:call-template name="applicationTable"/>
						</div>
						
						<div id="access-denied-section" class="col-xs-12 hiddenDiv">
							<div>
								<p>You do not have permission to access cost information</p>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                <script>
             <xsl:call-template name="RenderViewerAPIJSFunction">
                <xsl:with-param name="viewerAPIPath" select="$apiPath"/>
            </xsl:call-template>
            </script>
	
				<!-- Handlebars template to render an individual application as text-->
				<script id="app-link" type="text/x-handlebars-template">
					<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
					  <xsl:call-template name="RenderHandlebarsRoadmapSpan"/>  
				</script>
			</body>
		</html>
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
 

	<xsl:template name="applicationTable">
		<!--<script>
			$(document).ready(function(){
				// Setup - add a text input to each footer cell
			    $('#dt_apps tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
			    } );
				
				var table = $('#dt_apps').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
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
		</script>-->
		<div class="verticalSpacer_30px"/>

		<table id="dt_apps" class="table table-striped table-bordered">
			<thead>
				<tr>
					<!--<th>Application</th>
					<th>Description</th>
					<xsl:for-each select="$inScopeCostTypes">
						<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence']/value"/>
						<th>
							<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
						</th>
					</xsl:for-each>
					<th>Total</th>
					<th>Differentiation Level</th>-->
				</tr>
			</thead>
		 
			<tbody>
				<!--<xsl:apply-templates mode="RenderApplicationCostRow" select="$inScopeApps"/>-->
			</tbody>
		</table>
	</xsl:template>
	

 <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/>
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';//INSTANCE_ID sent via param1
    
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
       
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();  
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {

                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
				 
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
       
          
 
					var catalogueTable, appLinkTemplate;
					
					var currencySymbol = '<xsl:value-of select="$defaultCurrencySymbol"/>';
					<!--
					var diffLevels = [
						<xsl:apply-templates mode="RenderEnumerationJSONList" select="$appDifferentiationLevels"/>
					];
					
					var diffLevelColours = [
						<xsl:for-each select="$appDifferentiationSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
					];
					
					var costTypes = [
						<xsl:apply-templates mode="RenderEnumerationJSONList" select="$inScopeCostTypes"/>
					];
					
					var costTypeColours = [
						<xsl:for-each select="$costTypeSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
					];
          -->
                  var applications 
                  var inScopeApplications 
					
				<!--	var applications = [
						<xsl:apply-templates mode="RenderApplicationJSON" select="$inScopeApps"/>
					];
                    console.log(applications)
					//the list of applications for the current scope
				  	var inScopeApplications = {
				  		applications: applications
				  	}
				-->
					
					//function to get the total costs of the in scope processes
					function setOverallAppCosts() {
						appCostTotal = inScopeApplications.applications.map(function(anApp) {
							var anAmount = anApp['totalCost'];
							if(anAmount != null) {
								return Math.round(parseInt(anAmount));
							} else {
								return 0;
							}
				        })
				        .reduce(sumCosts, 0);
				        $('#app-cost-total').text(currencySymbol + formatNumber(appCostTotal));				        			
					}
					
					
					//function to initialise the total costs for applications
					function setAppCostTotal(anApp) {
 
						costTotal = 0;
						var costAmount;
						for (i = 0; i &lt; costTypes.length; i++) {
							costType = costTypes[i];
        var thisCost=0
     var total=anApp[costType.id].costs.forEach(function(d){
               thisCost=thisCost+parseInt(d.amount);
     }); 
							costAmount = thisCost 
                    //anApp[costType.id].amount;
							if(costAmount != null) {
								costTotal += parseInt(costAmount);
							}
						}
						anApp['totalCost'] = costTotal;
						return anApp;
					}
					
					//function to draw a pie chart
					function drawPieChart(containerId, pieData, pieColours) {
      
						var data = pieData;
						var plot1 = jQuery.jqplot (containerId,[data], {
							
							seriesColors: pieColours,
							legend: {
								renderer: jQuery.jqplot.EnhancedLegendRenderer,
								show: true,
								location: 'e',
								rendererOptions: {
								   fontSize: "0.65em",
								   textColor: 'red'
								}
							},
							grid: {
								drawGridLines: false,
								shadow: false,
								background: '#fff',
								borderColor: '#999999',
								borderWidth: 0
							},
							seriesDefaults: {
								// Make this a pie chart.
								renderer: jQuery.jqplot.PieRenderer,
								rendererOptions: {
									// Put data labels on the pie slices.
									// By default, labels show the percentage of the slice.
									showDataLabels: true,
									padding: 5,
									dataLabels: 'percent'
								}
							}
						});
					}
					
					const sumCosts = function(costTotal, costAmount) {
						return costTotal + costAmount
					};
					
					//function to draw the Cost Type pie chart
					function getCostTypeTotal(thisCostType) {
					
						costTypeTotal = inScopeApplications.applications.map(function(anApp) {
							var anAmount = anApp[thisCostType.id].amount;
							if(anAmount != null) {
								return Math.round(parseInt(anAmount));
							} else {
								return 0;
							}
				        })
				        .reduce(sumCosts, 0);
				        
				        var costTypeLabel = thisCostType.name + " - " + currencySymbol + formatNumber(costTypeTotal);
				        var costTypeEntry = [costTypeLabel, costTypeTotal];
				        
				        //console.log(thisCostType.name + ': ' + costTypeTotal);
				        return costTypeEntry;				
					}
					
					
					
					//function to draw the Cost Type pie chart
					function getDiffLevelTotal(thisDiffLevel) {
						var appsForDiffLevel = inScopeApplications.applications.filter(function(anApp) {return (anApp.differentiation != null) &amp;&amp; (anApp.differentiation.id == thisDiffLevel.id)});
						var diffLevelTotal = appsForDiffLevel.map(function(anApp) {
							var anAmount = anApp['totalCost'];
							if(anAmount != null) {
								return Math.round(parseInt(anAmount));
							} else {
								return 0;
							}
				        })
				        .reduce(sumCosts, 0);
				        
				        var diffLevelLabel = thisDiffLevel.name + " - " + currencySymbol + formatNumber(diffLevelTotal);
				        var diffLevelEntry = [diffLevelLabel, diffLevelTotal];
				        
				        //console.log(thisDiffLevel.name + ': ' + diffLevelTotal);
				        return diffLevelEntry;				
					}
					
					
					//function to draw the Cost Type pie chart
					function drawCostTypePieChart() {
						costTypePieData = costTypes.map(function(aCostType) { 
							return getCostTypeTotal(aCostType);
				         });
						
						 //console.log(costTypePieData);
						
						 drawPieChart('costTypePieChart', costTypePieData, costTypeColours)
					}
					
					
					//function to draw the Diff Level pie chart
					function drawDiffLevelPieChart() {
						diffLevelPieData = diffLevels.map(function(aDiffLevel){ 
							return getDiffLevelTotal(aDiffLevel);
				         });
						
						 //console.log(diffLevelPieData);
						
						 drawPieChart('diffLevelPieChart', diffLevelPieData, diffLevelColours)
					}
					
					
					//funtion to set contents of the Application catalogue table
					function drawApplicationsTable() {		
 
						if(catalogueTable == null) {
							initAppsTable();
						} else {
							catalogueTable.clear();
							catalogueTable.rows.add(inScopeApplications.applications);
	    					catalogueTable.draw();
	    				}
					}
					
					
					//function to initialise the applications table
					function initAppsTable() {
					
					    
					    var appColumns = [];
					    var nameColumn = {
					    	"title": "Application Name",
					    	"data" : "name",
					    	"width": "15%",
					    	"render": function( d, type, row, meta ){
					    		if(row != null) {   
				                	return appLinkTemplate(row);
				               	} else {
				               		return '';
				               	}
				            }
					    };
					    appColumns.push(nameColumn);
					    
					    var descColumn = {
					    	"title": "Description",
					    	"data" : "description",
					    	"width": "15%"
					    };
					    appColumns.push(descColumn);
					    
					    var costColumn;
					    var costColWidth, costColWidthStr;
					    if(costTypes.length > 0) {
					    	costColWidth = 60 / costTypes.length;
					    	costColWidthStr = '"' + Math.round(costColWidth) + '%"';
					    }
					    for (i = 0; i &lt; costTypes.length; i++) {
							costType = costTypes[i];
                            var thisCost=costType.id;
      
     
 
					    	costColumn = {
					    		"title": costType.name,
					    		"data": costType.id,
					    		"width": costColWidthStr,
						    	"render": function(d){
						    		if(d != null) {
     var thisLineCost=0
     var total=d.costs.forEach(function(e){
 
               thisLineCost=thisLineCost+parseInt(e.amount);
     }); 
				return currencySymbol + formatNumber(thisLineCost);
					               	}
					            }
					    	}
					    	appColumns.push(costColumn);
					    }
					    
					    var totalColumn = {
					    	"title": "Total Annual Cost",
					    	"data" : "totalCost",
					    	"width": "10%",
					    	"render": function(d){
						    		if(d != null) {
					                	return currencySymbol + formatNumber(Math.round(d));
					               	}
					            }
					    };
					    appColumns.push(totalColumn);
					    
					    <!--var diffLevelColumn = {
					    	"title": "Differentiation Level",
					    	"data" : "differentiation",
					    	"width": "10%",
					    	"render": function(row, d){
						    		if(row != null &amp;&amp; row['differentiation'] != null) {
					                	return row['differentiation'].name;
					               	}
					            }
					    };
					    appColumns.push(diffLevelColumn);-->
					    //START INITIALISE UP THE CATALOGUE TABLE
						// Setup - add a text input to each footer cell
					   
					    //console.log(appColumns);
						
						catalogueTable = $('#dt_apps').DataTable({
							paging: false,
							deferRender:    true,
				            scrollY:        350,
				            <!--scrollX:        true,
				            fixedColumns:   true,-->
				            scrollCollapse: true,
							info: true,
							sort: true,
							data: applications,
							responsive: false,
							dom: 'Bfrtip',
							columns: appColumns,
						    buttons: [
					            'copyHtml5', 
					            'excelHtml5',
					            'csvHtml5',
					            'pdfHtml5',
					            'print'
					        ]
						});
						
						
     
						// Apply the search
					    catalogueTable.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
     
      		    
					    catalogueTable.columns.adjust();
					    
					    $(window).resize( function () {
					        catalogueTable.columns.adjust();
					    });
					    
					    <xsl:if test="$isRoadmapEnabled">
						    <!-- ***OPTIONAL*** Register the table as having roadmap aware contents -->
						    registerRoadmapDatatable(catalogueTable);
					    </xsl:if>
					    
					    //END INITIALISE UP THE CATALOGUE TABLE
					}
					
					
					<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
				  	//function to redraw the view based on the current scope
					function redrawView() {
						<!--<xsl:if test="$isRoadmapEnabled">
							 console.log('Redrawing View');
							 
							//update the roadmap status of the applications and application provider roles passed as an array of arrays
                             
							rmSetElementListRoadmapStatus([applications]);
							
							 	//filter applications to those in scope for the roadmap start and end date
							inScopeApplications.applications = rmGetVisibleElements(applications);
						</xsl:if>-->
					
						setOverallAppCosts();				
						drawCostTypePieChart();
						drawDiffLevelPieChart();
						
						//redraw the applications table
						drawApplicationsTable();
					}
					
			    
          
        var diffLevels, diffLevelColours, costTypes, costTypeColours 
        
        var eipMode = <xsl:value-of select="$eipMode"/>;
        var canAccessCostClasses = <xsl:value-of select="$isAuthzForCostClasses"/>;
        
        $('document').ready(function () {
     
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
 		if(!eipMode || canAccessCostClasses) {
        
         promise_loadViewerAPIData(viewAPIData)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
             //  console.log('data') 
               console.log(JSON.stringify(response1))
               applications = response1.apps
                diffLevels =  response1.diffLevels
				diffLevelColours =  response1.diffLevelColours
				costTypes  = response1.costTypes
				costTypeColours = response1.costTypeColours
 
  
					//the list of applications for the current scope
				  	 inScopeApplications = {
				  		applications: applications
				  	}
   
          
				        appLinkFragment   = $("#app-link").html();
						appLinkTemplate = Handlebars.compile(appLinkFragment);
						
						
						applications.map(function(anApp) { 
							setAppCostTotal(anApp);
				            return anApp;
				         });		
				         $('#main-cost-section').removeClass('hiddenDiv');
				         
					         
					    //DRAW THE VIEW
					    redrawView();
        				$('#page-spinner').hide();
                  
                               
           
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });         
            
        } else {
        	$('#access-denied-section').removeClass('hiddenDiv')   
        	$('.eas-logo-spinner').hide();
        }
        

   
        
    });
        
    </xsl:template>

</xsl:stylesheet>
