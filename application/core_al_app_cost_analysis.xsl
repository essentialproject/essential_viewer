<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:import href="core_al_app_cost_revenue_functions.xsl"/>
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
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $allApps/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[name = $inScopeCostComponents/own_slot_value[slot_reference = 'cc_cost_component_type']/value]"/>
	<xsl:variable name="inScopeApps" select="$allApps[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_for_elements']/value]"/>

	<xsl:variable name="appDifferentiationLevelTax" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Differentiation Level')]"/>
	<xsl:variable name="appDifferentiationLevels" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appDifferentiationLevelTax/name]"/>


	<xsl:variable name="seriesColourPaallette" select="('#4196D9', '#9B53B3', '#EEC62A', '#E37F2C', '#1FA185', '#EDC92A', '#E53B6A', '#2BC331')"/>
	<xsl:variable name="costTypeSeriesColours" select="$seriesColourPaallette[position() &lt;= count($inScopeCostTypes)]"/>
	<xsl:variable name="appDifferentiationSeriesColours" select="$seriesColourPaallette[position() &lt;= count($appDifferentiationLevels)]"/>

	<xsl:variable name="defaultCurrencyConstant" select="eas:get_instance_by_name(/node()/simple_instance, 'Report_Constant', 'Default Currency')"/>
	<xsl:variable name="defaultCurrency" select="eas:get_instance_slot_values(/node()/simple_instance, $defaultCurrencyConstant, 'report_constant_ea_elements')"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
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
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Application Cost Analysis</span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<xsl:call-template name="pieChart1"/>
							<xsl:call-template name="pieChart2"/>
							<xsl:call-template name="applicationTable"/>

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

	<xsl:template name="pieChart1">
		<script type="text/javascript">
			$(document).ready(function () {
				<!--
            var data =[[ 'Maintenance [£928K]', 928029],[ 'Server [£732k]', 732000],[ 'Storage [£681K]', 681000],[ 'People [£534k]', 543000]];//-->
				var data =[<xsl:apply-templates mode="RenderCostTypesForPie" select="$inScopeCostTypes"/>];
				var plot1 = jQuery.jqplot ('pieChart1',[data], {
					
					<!--
            seriesColors:[ "#4196D9", "#9B53B3", "#EEC62A", "#E37F2C", "#1FA185"],//-->
					seriesColors:[<xsl:for-each select="$costTypeSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
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
			});
		</script>

		<div class="pieChartContainer">
			<h2 class="text-primary">Cost By Type</h2>
			<div class="pieChart" id="pieChart1"/>
		</div>
	</xsl:template>

	<xsl:template name="pieChart2">
		<script type="text/javascript">
			$(document).ready(function () {
				<!--
            var data =[[ 'System of Innovation [£980K]', 980000],[ 'System of Differentiation [£720K]', 720000],[ 'System of Record [£1.2m]', 1200000]];//-->
				var data =[<xsl:apply-templates mode="RenderCostDiffLevelsForPie" select="$appDifferentiationLevels"/>];
				var plot1 = jQuery.jqplot ('pieChart2',[data], {
					
					<!--
            seriesColors:[ "#4196D9", "#9B53B3", "#EEC62A"],//-->
					seriesColors:[<xsl:for-each select="$appDifferentiationSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
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
			});
		</script>
		<div class="pieChartContainer">
			<h2 class="text-primary">Cost by Differentiation Level</h2>
			<div class="pieChart" id="pieChart2"/>
		</div>
	</xsl:template>

	<xsl:template name="applicationTable">
		<script>
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
		</script>
		<div class="verticalSpacer_30px"/>

		<table id="dt_apps" class="table table-striped table-bordered">
			<thead>
				<tr>
					<th>Application</th>
					<th>Description</th>
					<xsl:for-each select="$inScopeCostTypes">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						<th>
							<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
						</th>
					</xsl:for-each>
					<th>Total</th>
					<th>Differentiation Level</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th class="cellWidth-10pc">Application</th>
					<th class="cellWidth-15pc">Description</th>
					<xsl:for-each select="$inScopeCostTypes">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						<th>
							<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
						</th>
					</xsl:for-each>
					<th class="cellWidth-10pc">Total</th>
					<th class="cellWidth-15pc">Differentiation Level</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:apply-templates mode="RenderApplicationCostRow" select="$inScopeApps"/>
			</tbody>
		</table>
	</xsl:template>



	<xsl:template mode="RenderCostTypesForPie" match="node()">
		<xsl:variable name="currentCostType" select="current()"/>
		<xsl:variable name="costTypeLabel" select="eas:get_string_slot_values($currentCostType, 'enumeration_value')"/>
		<xsl:variable name="costCompsForCostType" select="eas:get_instances_with_instance_slot_value($inScopeCostComponents, 'cc_cost_component_type', $currentCostType)"/>
		<xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($costCompsForCostType, 0)"/>

		<xsl:variable name="totalAsString" select="eas:format_large_number($costTypeTotal)"/>

		<xsl:variable name="costTypeString">
			<xsl:text>['</xsl:text>
			<xsl:value-of select="$costTypeLabel"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="$defaultCurrencySymbol"/>
			<xsl:value-of select="$totalAsString"/>
			<xsl:text>]', </xsl:text>
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
			<xsl:text>['</xsl:text>
			<xsl:value-of select="$diffLevelLabel"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="$defaultCurrencySymbol"/>
			<xsl:value-of select="$totalAsString"/>
			<xsl:text>]', </xsl:text>
			<xsl:value-of select="$diffLevelTotal"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:value-of select="$diffLevelString"/>
		<xsl:if test="not(position() = last())">,</xsl:if>

	</xsl:template>

	<xsl:template mode="RenderApplicationCostRow" match="node()">
		<xsl:variable name="app" select="current()"/>
		<xsl:variable name="appCost" select="eas:get_instances_with_instance_slot_value($inScopeCosts, 'cost_for_elements', $app)"/>
		<xsl:variable name="appCostComponents" select="eas:get_instance_slot_values($inScopeCostComponents, $appCost, 'cost_components')"/>
		<xsl:variable name="appDiffLevel" select="eas:get_instance_slot_values($appDifferentiationLevels, $app, 'element_classified_by')"/>
		<xsl:variable name="totalAppCost" select="eas:get_cost_components_total($appCostComponents, 0)"/>

		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$app"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$app"/>
				</xsl:call-template>
			</td>
			<xsl:for-each select="$inScopeCostTypes">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="currentCostType" select="current()"/>
				<xsl:variable name="costCompsForCostType" select="eas:get_instances_with_instance_slot_value($appCostComponents, 'cc_cost_component_type', $currentCostType)"/>
				<xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($costCompsForCostType, 0)"/>
				<xsl:choose>
					<xsl:when test="$costTypeTotal > 0">
						<td>
							<xsl:value-of select="$defaultCurrencySymbol"/>
							<xsl:value-of select="eas:format_large_number($costTypeTotal)"/>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td>-</td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<!--<td>$64,326</td>
			<td>$12,987</td>
			<td>$29,982</td>
			<td>$18,920</td>
			<td>$126,920</td>-->
			<td>
				<xsl:choose>
					<xsl:when test="$totalAppCost > 0">
						<xsl:value-of select="$defaultCurrencySymbol"/>
						<xsl:value-of select="eas:format_large_number($totalAppCost)"/>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="eas:get_string_slot_values($appDiffLevel, 'name')"/>
				<!--<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$appDiffLevel"/>
				</xsl:call-template>-->
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
