<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:import href="core_al_app_cost_revenue_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider', 'Application_Service')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="app" select="/node()/simple_instance[name = $param1]"/>

	<xsl:variable name="appProRoles" select="eas:get_instance_slot_values(/node()/simple_instance, $app, 'provides_application_services')"/>
	<xsl:variable name="appServices" select="eas:get_instance_slot_values(/node()/simple_instance, $appProRoles, 'implementing_application_service')"/>

	<xsl:variable name="appDifferentiationLevelTax" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Differentiation Level')]"/>
	<xsl:variable name="appDifferentiationLevel" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appDifferentiationLevelTax/name) and (name = $app/own_slot_value[slot_reference = 'element_classified_by']/value)]"/>

	<xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $app/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[name = $inScopeCostComponents/own_slot_value[slot_reference = 'cc_cost_component_type']/value]"/>

	<xsl:variable name="totalAppCost" select="eas:get_cost_components_total($inScopeCostComponents, 0)"/>
	<xsl:variable name="totalAsString" select="eas:format_large_number($totalAppCost)"/>

	<xsl:variable name="seriesColourPaallette" select="('#4196D9', '#9B53B3', '#EEC62A', '#E37F2C', '#1FA185', '#EDC92A', '#E53B6A', '#2BC331')"/>
	<xsl:variable name="costTypeSeriesColours" select="$seriesColourPaallette[position() &lt;= count($inScopeCostTypes)]"/>

	<xsl:variable name="defaultCurrencyConstant" select="eas:get_instance_by_name(/node()/simple_instance, 'Report_Constant', 'Default Currency')"/>
	<xsl:variable name="defaultCurrency" select="eas:get_instance_slot_values(/node()/simple_instance, $defaultCurrencyConstant, 'report_constant_ea_elements')"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>

	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->


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
				<title>Application Cost Summary for <xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$app"/></xsl:call-template></title>
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
					
					.jqplot-table-legend{
					    width: 200px;
					    max-width: 200px;
					    padding: 10px;
					}
					
					table.jqplot-table-legend,
					table.jqplot-cursor-legend{
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
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Application Cost Summary for </span>
									<span class="text-primary">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$app"/>
											<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
										</xsl:call-template>
									</span>
								</h1>
							</div>
						</div>


						<!--Setup Description Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Description</h2>

							<div class="content-section">
								<p>
									<xsl:variable name="appDesc" select="$app/own_slot_value[slot_reference = 'description']/value"/>
									<xsl:choose>
										<xsl:when test="string-length($appDesc) = 0">
											<span>-</span>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="RenderMultiLangInstanceDescription">
												<xsl:with-param name="theSubjectInstance" select="$app"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>

								</p>
							</div>
							<hr/>
						</div>

						<!--Setup App Type Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-bar-chart icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Differentiation Level</h2>

							<div class="content-section">
								<p>
									<xsl:choose>
										<xsl:when test="count($appDifferentiationLevel) = 0">
											<span>-</span>
										</xsl:when>
										<xsl:otherwise>
											<strong>
												<xsl:call-template name="RenderMultiLangInstanceName">
													<xsl:with-param name="theSubjectInstance" select="$appDifferentiationLevel"/>
												</xsl:call-template>
											</strong>
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</div>
							<hr/>
						</div>

						<!--Setup App Services Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Application Services</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($appServices) = 0">
										<span>-</span>
									</xsl:when>
									<xsl:otherwise>
										<ul>
											<xsl:for-each select="$appServices">
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="current()"/>
													</xsl:call-template>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup Costs Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-table icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Costs</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="$totalAppCost = 0">
										<span>-</span>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="pieChart1"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<div class="clear"/>
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

	<xsl:template name="pieChart1">
		<script type="text/javascript">
			$(document).ready(function () {
				<!--
            var data =[[ 'Maintenance [£128K]', 1289029],[ 'Server [£92k]', 912000],[ 'Storage [£61K]', 611000],[ 'People [£54k]', 543000]];//-->
				var data =[<xsl:apply-templates mode="RenderCostTypesForPie" select="$inScopeCostTypes"/>];
				var plot1 = jQuery.jqplot ('pieChart1',[data], {
					
					<!--
            seriesColors:[ "#4196D9", "#9B53B3", "#EEC62A", "#E37F2C"],//-->
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
			<div class="pieChart" id="pieChart1"/>
		</div>
		<div class="totalContainer">
			<div class="fontBlack subtitle text-primary">Total Cost</div>
			<div class="fontBlack subtitle textColour2">
				<xsl:value-of select="$defaultCurrencySymbol"/>
				<xsl:value-of select="$totalAsString"/>
			</div>
		</div>
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


</xsl:stylesheet>
