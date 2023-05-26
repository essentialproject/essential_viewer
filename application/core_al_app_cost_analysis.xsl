<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:import href="../application/core_al_app_cost_revenue_functions.xsl"/> 
	 <xsl:include href="../common/core_doctype.xsl"/>
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

    <xsl:param name="targetReportId"/>
	<!-- END GENERIC PARAMETERS -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<!-- VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $allApps/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[name = $inScopeCostComponents/own_slot_value[slot_reference = 'cc_cost_component_type']/value]"/>
	<xsl:variable name="inScopeApps" select="$allApps[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_for_elements']/value]"/>
    
    
	<xsl:variable name="appDifferentiationLevelTax" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Differentiation Level')]"/>
	<xsl:variable name="appDifferentiationLevels" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appDifferentiationLevelTax/name]"/>

	 <xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
     <xsl:variable name="appPayers" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Paying Organisation')]"/>
	<xsl:variable name="appPayerTypes" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appPayers/name]"/>
    <xsl:variable name="appPurpose" select="/node()/simple_instance[type = 'Application_Purpose']"/>
    <xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
    <xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allPhysProc2AppProRoles" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	
	<xsl:variable name="appUserOrgRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
	
	
	<xsl:variable name="relevantGroupActorStakeholders" select="$allActor2Roles[(name = $allApps/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserOrgRole/name)]"/>
	<xsl:variable name="relevantGroupActorAppUsers" select="$allGroupActors[name = $relevantGroupActorStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $allAppProviderRoles/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
	<xsl:variable name="relevantActor2Roles" select="$allActor2Roles[(name = $relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
	<xsl:variable name="relevantPhysProcActors" select="$allGroupActors[(name = $relevantActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value) or (name = $relevantPhysProcs/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value)]"/>
    
    <xsl:variable name="site" select="/node()/simple_instance[type = 'Site'][name = $allGroupActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
    <xsl:variable name="location" select="/node()/simple_instance[type = ('Geographic_Region')][name = $site/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	
    <xsl:variable name="seriesColourPaallette" select="('#4196D9', '#9B53B3', '#EEC62A', '#E37F2C', '#1FA185', '#EDC92A', '#E53B6A', '#2BC331')"/>
	<xsl:variable name="costTypeSeriesColours" select="$seriesColourPaallette[position() &lt;= count($inScopeCostTypes)]"/>
	<xsl:variable name="appDifferentiationSeriesColours" select="$seriesColourPaallette[position() &lt;= count($appDifferentiationLevels)]"/>

	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
 	
	<xsl:variable name="isAuthzForCostClasses" select="eas:isUserAuthZClasses(('Cost', 'Cost_Component'))"/>
 	<xsl:variable name="isEIPMode">
 		<xsl:choose>
 			<xsl:when test="$eipMode = 'true'">true</xsl:when>
 			<xsl:otherwise>false</xsl:otherwise>
 		</xsl:choose>
 	</xsl:variable>
 
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: APM Costs']"/>
	<xsl:variable name="anAPIReportApps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathApps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportApps"/>
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
				 
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/> 
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
			 	<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
 
									<span class="text-darkgrey">Application Cost Analysis</span> - <span class="text-primary" id="app-cost-total"></span>
								</h1>                                       
							</div>
							
  
                                    
                                
 
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
							<div class="clearfix"/>
							<hr/>
							<div class="pull-right">
							<button class="btn btn-primary tops" easid="10">Show Top 10</button>
							<xsl:text> </xsl:text>
							<button class="btn btn-primary tops" easid="20">Show Top 20</button>
							<xsl:text> </xsl:text>
							<button class="btn btn-primary tops" easid="all">Show All</button>
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
				<xsl:with-param name="viewerAPIPathApps" select="$apiPathApps"/>
            </xsl:call-template>
            </script>
			<script id="app-link" type="text/x-handlebars-template">
				<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
				{{#essRenderInstanceLinkSelect this 'Application_Provider'}}{{/essRenderInstanceLinkSelect}}       
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
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
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
		<div class="verticalSpacer_5px"/>

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
		<xsl:param name="viewerAPIPathApps"/>
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';//INSTANCE_ID sent via param1
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
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
            var applications 
            var inScopeApplications 
			var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';		
			applications=[
				<xsl:apply-templates mode="RenderApplicationJSON" select="$inScopeApps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			];
            diffLevels=[
						<xsl:apply-templates mode="RenderViewEnumerationJSONList" select="$appDifferentiationLevels"/>
					];
            diffLevelColours=[
						<xsl:for-each select="$appDifferentiationSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
					]
            costTypes =[
						<xsl:apply-templates mode="RenderViewEnumerationJSONList" select="$inScopeCostTypes"/>
					];
            costTypeColours= [
						<xsl:for-each select="$costTypeSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
					];
         diffPieData=[<xsl:apply-templates mode="RenderCostDiffLevelsForPie" select="$appDifferentiationLevels"/>],
         typePiedata=[<xsl:apply-templates mode="RenderCostTypesForPie" select="$inScopeCostTypes"/>]

		
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
						 
				        $('#app-cost-total').text(currencySymbol +  (appCostTotal.toLocaleString('en-US')));				        			
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
				        
				        var costTypeLabel = thisCostType.name + " - " + currencySymbol + (costTypeTotal.toLocaleString('en-US'));
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
				        
				        var diffLevelLabel = thisDiffLevel.name + " - " + currencySymbol + (diffLevelTotal.toLocaleString('en-US'));
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
	//function to calculate the columns required for the app table
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
				return currencySymbol + (thisLineCost.toLocaleString('en-US'));
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
					                	return currencySymbol + (Math.round(d).toLocaleString('en-US'));
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
					   
					    
					    //END INITIALISE UP THE CATALOGUE TABLE
					}
					

					
					
					<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
				  	//function to redraw the view based on the current scope
					function redrawView(appsList) { 

						inScopeApplications.applications=applications; 
						if(appsList===undefined){
						appsList=inScopeApplications.applications}
  
						let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
						let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
						let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
		 
		 				essResetRMChanges();
						let typeInfo = {
							"className": "Application_Provider",
							"label": 'Application',
							"icon": 'fa-desktop'
						}
						let scopedApps = essScopeResources(appsList, [visibilityDef, appOrgScopingDef,geoScopingDef], typeInfo);
		
						 <!--
						 <xsl:if test="$isRoadmapEnabled"> 
							 
							//update the roadmap status of the applications and application provider roles passed as an array of arrays
                             
							rmSetElementListRoadmapStatus([applications]);
							
							 	//filter applications to those in scope for the roadmap start and end date
							inScopeApplications.applications = rmGetVisibleElements(applications);			 

						let inScopeAppsList=[];
						if(appsList){
							appsList.forEach((app)=>{
								let thisApp=inScopeApplications.applications.filter((a)=>{
										return a.id==app.id;
								});
								if(thisApp.length&gt;0){
									inScopeAppsList.push(thisApp[0]);
								}
							});
							inScopeApplications.applications = inScopeAppsList;
						}else{
						}
						</xsl:if> -->
						inScopeApplications.applications = scopedApps.resources;
						let rmVal = $('#rmEnabledCheckbox').is(":checked");
					 	if( rmVal == false){
							console.log('no tick'); 
						}
						 
					 
					 
						setOverallAppCosts();				
						drawCostTypePieChart();
						drawDiffLevelPieChart();
						
						//redraw the applications table
						drawApplicationsTable();
					}
					
			    
          
        var diffLevels, diffLevelColours, costTypes, costTypeColours 
        
        var eipMode = <xsl:value-of select="$isEIPMode"/>;
        var canAccessCostClasses = <xsl:value-of select="$isAuthzForCostClasses"/>;
        
        $('document').ready(function () {
		 
			Promise.all([
                promise_loadViewerAPIData(viewAPIDataApps)
			]).then(function (responses) { 
	 
				applications.forEach((a)=>{
					let match=responses[0].applications.find((aa)=>{
						return aa.id==a.id;
					})
					
  
					a = Object.assign(a,match)
					   
				})
 		if(!eipMode || canAccessCostClasses) {

 
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
				   		      
					        let filters=responses[0].filters; 
					    //DRAW THE VIEW
						essInitViewScoping(redrawView, ['Group_Actor',  'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS'],filters,true);

					  //  redrawView(inScopeApplications.applications);
        				$('#page-spinner').hide();
                  
                               
           
                
            
        } else {
        	$('#access-denied-section').removeClass('hiddenDiv')   
        	$('.eas-logo-spinner').hide();
        }

		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';

			function essGetMenuName(instance) { 
		        let menuName = null;
		        if ((instance != null) &amp;&amp;
		            (instance.meta != null) &amp;&amp;
		            (instance.meta.classes != null)) {
		            menuName = instance.meta.menuId;
		        } else if (instance.classes != null) {
		            menuName = instance.meta.classes;
				}
			 
		        return menuName;
			}
        
		Handlebars.registerHelper('essRenderInstanceLinkSelect', function (instance,type) {

			let meta=[ 
				{"classes":["Application_Provider","Composite_Application_Provider"], "menuId":"appProviderGenMenu"},
			];

				let thisMeta = meta.filter((d) => {
					return d.classes.includes(type)
				});

				instance['meta'] = thisMeta[0]
				let linkMenuName = essGetMenuName(instance);
				let instanceLink = instance.name;
				if (linkMenuName != null) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					let linkURL = reportURL; 
					instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15 ' + linkClass + '" href="' + linkHref + '"  id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'+instance.name;
		
					return instanceLink;
				} 
		});



   $('.tops').on('click',function(){
	    inScopeApplications = {
	 		applications: applications
	 		  	}

	  let counter=$(this).attr('easid');
	  	if(counter=='all'){counter=applications.length}

		let apps=inScopeApplications.applications;
		apps.sort((a, b) => parseInt(b.totalCost) > parseInt(a.totalCost) &amp;&amp; 1 || -1)
		 
		let newApps=[];
			for(let i=0; i &lt; counter; i++){
				newApps.push(apps[i])
			}

	   inScopeApplications = {
	 		applications: newApps
	 		  	}
				   			  	 
	
	redrawView(newApps);


   		})
	});
	   
});
        
    </xsl:template>
	
<xsl:template match="node()" mode="RenderApplicationJSON">
<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="appDiffLevel" select="$appDifferentiationLevels[name = $this/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		
		<xsl:variable name="appCosts" select="$inScopeCosts[own_slot_value[slot_reference = 'cost_for_elements']/value = $this/name]"/>
		<xsl:variable name="appCostComponents" select="$inScopeCostComponents[name = $appCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
    
           <xsl:variable name="appGroupActorStakeholders" select="$allActor2Roles[(name = $this/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserOrgRole/name)]"/>
		<xsl:variable name="appGroupActorAppUsers" select="$allGroupActors[name = $appGroupActorStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		
		<xsl:variable name="appProvRoles" select="$allAppProviderRoles[name = $this/own_slot_value[slot_reference='provides_application_services']/value]"/>
		<xsl:variable name="appPhysProc2AppProRoles" select="$allPhysProc2AppProRoles[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $appProvRoles/name]"/>
		<xsl:variable name="appPhysProcs" select="$allPhysProcs[name = $appPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="appPhysProcActor2Roles" select="$allActor2Roles[(name = $appPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
		<xsl:variable name="appPhysProcGroupActors" select="$allGroupActors[name = $appPhysProcActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		
		<xsl:variable name="appUsers" select="$appGroupActorAppUsers union $appPhysProcGroupActors"/>
        
        	
        <xsl:variable name="thissite" select="$site[name = $appUsers/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
        <xsl:variable name="thislocation" select="$location[name = $thissite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		    
    {
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		"name": "<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="isForJSONAPI" select="false()"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
		 <xsl:with-param name="theSubjectInstance" select="current()"/>
	</xsl:call-template>",

	"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
	"description": "<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		 <xsl:with-param name="theSubjectInstance" select="current()"/>
	</xsl:call-template>",
         "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
        "differentiation": <xsl:choose><xsl:when test="$appDiffLevel/name"><xsl:apply-templates mode="RenderViewEnumerationJSONList" select="$appDiffLevel"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,<xsl:apply-templates mode="RenderApplicationCostsJSON" select="$inScopeCostTypes"><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence']/value"/><xsl:with-param name="thisCostComps" select="$appCostComponents"/></xsl:apply-templates>,"countries":[<xsl:for-each select="$thislocation">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$this"/></xsl:call-template>
	}<xsl:if test="not(position()=last())">,</xsl:if>
    
</xsl:template>    
	<xsl:template match="node()" mode="RenderApplicationCostsJSON">
		<xsl:param name="thisCostComps" select="()"/>
		
		<xsl:variable name="thisCostType" select="current()"/>
		
		<xsl:variable name="thisCostTypeId" select="eas:getSafeJSString($thisCostType/name)"/>
		
		<xsl:variable name="thisCostTypeName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisCostType"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="costsForType" select="$thisCostComps[own_slot_value[slot_reference = 'cc_cost_component_type']/value = $thisCostType/name]"/>
		
		<xsl:variable name="costsTotal" select="sum($costsForType/own_slot_value[slot_reference = 'cc_cost_amount']/value)"/>
		<xsl:variable name="costTypeAmount">
			<xsl:choose>
				<xsl:when test="$costsTotal > 0"><xsl:value-of select="$costsTotal"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		"<xsl:value-of select="$thisCostTypeId"/>":{"amount":<xsl:choose><xsl:when test="$costTypeAmount=0">0</xsl:when><xsl:otherwise><xsl:value-of select="format-number($costTypeAmount,'#.##')"/></xsl:otherwise></xsl:choose>,
        "costs":[<xsl:for-each select="$costsForType"><xsl:variable name="cost" select="current()/own_slot_value[slot_reference = 'cc_cost_amount']/value"/>{"type":"<xsl:value-of select="current()/type"/>","amount":<xsl:choose><xsl:when test="current()/type='Annual_Cost_Component'"><xsl:value-of select="$cost"/></xsl:when><xsl:when test="current()/type='Quarterly_Cost_Component'"><xsl:value-of select="$cost*4"/></xsl:when><xsl:when test="current()/type='Monthly_Cost_Component'"><xsl:value-of select="$cost*12"/></xsl:when><xsl:otherwise><xsl:value-of select="$cost"/></xsl:otherwise></xsl:choose>}<xsl:if test="not(position()=last())">,
		</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,
		</xsl:if>		
		<!--'<xsl:value-of select="$thisCostTypeId"/>': {
			'costTypeId': '<xsl:value-of select="$thisCostTypeId"/>',
			'costTypeName': '<xsl:value-of select="$thisCostTypeName"/>',
			'amount': <xsl:value-of select="$costTypeAmount"/>	
		}<xsl:if test="not(position()=last())">,
		</xsl:if>-->
	</xsl:template>
 <xsl:template mode="RenderViewEnumerationJSONList" match="node()">
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="colour" select="eas:get_element_style_colour(current())"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
			"name": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="isForJSONAPI" select="false()"/>
			 <xsl:with-param name="theSubjectInstance" select="current()"/>
		</xsl:call-template>",
		"colour": "<xsl:choose><xsl:when test="string-length($colour) &gt; 0"><xsl:value-of select="$colour"/></xsl:when><xsl:otherwise>#fff</xsl:otherwise></xsl:choose>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
 
 <xsl:template mode="RenderCostTypesForPie" match="node()">
		<xsl:variable name="currentCostType" select="current()"/>
		<xsl:variable name="costTypeLabel" select="eas:get_string_slot_values($currentCostType, 'enumeration_value')"/>
		<xsl:variable name="costCompsForCostType" select="eas:get_instances_with_instance_slot_value($inScopeCostComponents, 'cc_cost_component_type', $currentCostType)"/>
		<xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($costCompsForCostType, 0)"/>

		<xsl:variable name="totalAsString" select="eas:format_large_number($costTypeTotal)"/>

		<xsl:variable name="costTypeString">
			<xsl:text>["</xsl:text>
			<xsl:value-of select="$costTypeLabel"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="$defaultCurrencySymbol"/>
			<xsl:value-of select="$totalAsString"/>
			<xsl:text>]", </xsl:text>
			<xsl:value-of select="$costTypeTotal"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:value-of select="$costTypeString"/>
		<xsl:if test="not(position() = last())">,</xsl:if>

	</xsl:template>
 

	<xsl:template mode="RenderCostDiffLevelsForPie" match="node()">
		<xsl:variable name="currentDiffLevel" select="current()"/>
		<xsl:variable name="diffLevelLabel" select="eas:get_string_slot_values($currentDiffLevel, 'name')"/>
		<xsl:variable name="appsForDiffLevel" select="eas:get_instances_with_instance_slot_value($inScopeApps, 'element_classified_by', $currentDiffLevel)"/>
		<xsl:variable name="appCostsForDiffLevel" select="eas:get_instances_with_instance_slot_value($inScopeCosts, 'cost_for_elements', $appsForDiffLevel)"/>
		<xsl:variable name="appCostCompsForDiffLevel" select="eas:get_instances_with_instance_slot_value($inScopeCostComponents, 'cc_cost_component_of_cost', $appCostsForDiffLevel)"/>

		<xsl:variable name="diffLevelTotal" select="eas:get_cost_components_total($appCostCompsForDiffLevel, 0)"/>
		<xsl:variable name="totalAsString" select="eas:format_large_number($diffLevelTotal)"/>

		<xsl:variable name="diffLevelString">
			<xsl:text>["</xsl:text>
			<xsl:value-of select="$diffLevelLabel"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="$defaultCurrencySymbol"/>
			<xsl:value-of select="$totalAsString"/>
			<xsl:text>]", </xsl:text>
			<xsl:value-of select="$diffLevelTotal"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:value-of select="$diffLevelString"/>
		<xsl:if test="not(position() = last())">,</xsl:if>

	</xsl:template>
</xsl:stylesheet>
