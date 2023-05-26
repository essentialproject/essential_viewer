<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<xsl:variable name="perfCategory" select="/node()/simple_instance[type='Performance_Measure_Category']"/> 
	<xsl:variable name="serviceQualities" select="/node()/simple_instance[supertype = 'Service_Quality'][name=$perfCategory/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
	<xsl:variable  name="perfMeasuresforPC" select="/node()/simple_instance[supertype='Performance_Measure'][own_slot_value[slot_reference='pm_category']/value]"/> 
	<xsl:variable name="sqvs" select="/node()/simple_instance[supertype='Service_Quality_Value'][name=$perfMeasuresforPC/own_slot_value[slot_reference='pm_performance_value']/value]"/> 
	<xsl:variable name="serviceQualityValues" select="/node()/simple_instance[supertype = 'Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value=$serviceQualities/name]"></xsl:variable>
	<xsl:key name="perfMeasureskey" match="/node()/simple_instance[supertype='Performance_Measure']" use="own_slot_value[slot_reference='pm_performance_value']/value"/> 
	
	<!--<xsl:variable name="perfMeasures" select="/node()/simple_instance[supertype='Performance_Measure'][name=$allAppProviders/own_slot_value[slot_reference='performance_measures']/value]"/> 
	<xsl:variable name="appProcessPerfMeasures" select="/node()/simple_instance[supertype='Performance_Measure'][name=$allPhysProcesses/own_slot_value[slot_reference='performance_measures']/value]"/> 
	
	<xsl:key name="perfMeasureskey" match="/node()/simple_instance[supertype='Performance_Measure']" use="own_slot_value[slot_reference='pm_measured_element']/value"/> 
	
	<xsl:variable name="serviceQualities" select="/node()/simple_instance[supertype = 'Service_Quality'][name=$perfCategory/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>

	<xsl:key name="serviceQualityValueskey" match="/node()/simple_instance[supertype = 'Service_Quality_Value']" use="own_slot_value[slot_reference = 'usage_of_service_quality']/value"/>
	-->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
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
				<title>Performance Measurement Checker</title> 
				<style>
				  .quadrant {
					fill: none;
					stroke: #aaa;
				  }
				  
				  .bubble {
					fill: steelblue;
					stroke: white;
					stroke-width: 2px;
				  }
				</style>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Performance Measurement Checker')"/></span>
								</h1>
							</div>
						</div>

						<div class="col-xs-12">
							<div id="infoBox"/>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
			
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
			<script id="infoTemplate" type="text/x-handlebars-template">		
				<h2 class="strong">Modelling Pattern</h2>
				<div class="bottom-10">
					<span class="label label-default" style="margin-right: 2px;">Performance Category</span>
					<span class="label label-info"><xsl:value-of select="count($perfCategory)"/></span>
					<i class="fa fa-caret-right left-10 right-10"></i>
					<span class="label label-default" style="margin-right: 2px;">Service Quality</span>
					<span class="label label-info"><xsl:value-of select="count($serviceQualities)"/></span>
					<i class="fa fa-caret-right left-10 right-10" style="margin-right: 2px;"></i>
					<span class="label label-default" style="margin-right: 2px;">Service Quality Value</span>
					<span class="label label-info"><xsl:value-of select="count($serviceQualityValues)"/></span>
					<span class="left-10">Service qualities will show below if mapped</span>
				</div>
				<div class="bottom-10">
					<span class="label label-default">Element</span>
					<i class="fa fa-caret-right left-10 right-10"></i>
					<span class="label label-default">Performance Measure</span>
					<i class="fa fa-caret-right left-10 right-10"></i>
					<span class="label label-default">Service Quality Value</span>
				</div>
				
				{{#each this}}
				<hr/>
				<h2 class="strong">Category:{{this.name}}</h2>
				<span class="strong right-5">Mapped to Classes?</span>
				{{#ifEquals this.mappedClasses 0}}<span class="label label-danger">No</span>{{else}}<span class="label label-success">Yes</span>{{/ifEquals}}
				<em class="left-10">check these are the classes for which the measure category applies, e.g. Application Provider/Composite Application Provider (slot <small><b>pmc_measures_ea_classes slot</b></small>) </em>
				{{#ifEquals this.mappedClasses 0}}
				<div class="top-5"><i class="fa fa-exclamation-triangle text-danger"></i>You need to select the classes for which the category applies, use the 'Pmc Measures Ea Classes' slot to assign classes</div>
				{{/ifEquals}}
				
				{{#if this.serviceQualities}}
				<p class="top-10">For each quality, number of elements mapped and whether the values for each quality are configured correctly - value slot (text) and score slot (numeric, typically out of 5)?</p>
				<p><strong>Qualities</strong> with number of elements mapped to that category via the quality</p>
					
				{{#each this.serviceQualities}}
				<div class="top-30">
					<div class="impact">Service Quality: </div>
					<span class="label label-default" style="margin-right: 2px;">{{this.name}}</span>
					<span class="label label-info">{{this.perfMeasuresElements.length}}</span>
				</div>
				<div class="top-5">	 
					<div class="impact">Service Quality Values: </div>
					
					{{#each this.values}}
					<span class="right-30">
						<span class="label label-default" style="margin-right: 2px;">{{this.name}}</span>
						<span class="label label-info right-5">{{this.linkedPms}}</span>
						<span class="small">Score:</span>
						{{#ifEquals this.score ''}}
							<i class="fa fa-times text-danger"></i>
						{{else}}
							<i class="fa fa-check text-success"></i>
						{{/ifEquals}}
						<span class="small">Value:</span>
						{{#ifEquals this.value ''}}
							<i class="fa fa-times text-danger"></i>
						{{else}}
							<i class="fa fa-check text-success"></i>
						{{/ifEquals}}
					</span>
					{{/each}}
				</div>
				{{/each}}
				{{else}}
					<div>
						<i class="fa fa-exclamation-triangle text-danger right-5"></i>
						<span>You need to map your service qualities to the category. Select the category and map the service qualities for that category.</span>
					</div>
				{{/if}}
				{{/each}}
			</script>
			<script>
			let pmc=[<xsl:apply-templates select="$perfCategory" mode="pcs"/>]
			let svc=[<xsl:apply-templates select="$serviceQualities" mode="svQuals"/>]
console.log('PMC', pmc)
console.log('svc', svc)
				$(document).ready(function(){
					infoFragment = $("#infoTemplate").html();
					infoTemplate = Handlebars.compile(infoFragment);

					Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});
					
					$('#infoBox').html(infoTemplate(pmc))
				})
			</script>

		</html>
	</xsl:template>

<xsl:template match="node()" mode="pcs">
	<xsl:variable name="thisserviceQualities" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
	<xsl:variable name="thisperfMeasuresforPC" select="$perfMeasuresforPC[own_slot_value[slot_reference = 'pm_category']/value=current()/name]"></xsl:variable> 
	{
	"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
	"serviceQualities":[<xsl:apply-templates select="$thisserviceQualities" mode="svQuals"/>],
	"perfMeasures":[<xsl:apply-templates select="$thisperfMeasuresforPC" mode="pmVals"/>],
	"mappedClasses":<xsl:value-of select="count(current()/own_slot_value[slot_reference = 'pmc_measures_ea_classes']/value)"/>
	}<xsl:if test="position()!=last()">,</xsl:if>
	 
</xsl:template>
<xsl:template match="node()" mode="svQuals">
	<xsl:variable name="thisserviceQualityValues" select="$serviceQualityValues[own_slot_value[slot_reference = 'usage_of_service_quality']/value=current()/name]"></xsl:variable>
	<xsl:variable name="thisPerfMeasure" select="key('perfMeasureskey',$thisserviceQualityValues/name)"/>
	{ 
	"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
	"values":[<xsl:apply-templates select="$thisserviceQualityValues" mode="sqValScore"><xsl:with-param name="pms" select="$thisPerfMeasure"/></xsl:apply-templates>],
	"perfMeasuresElements":[<xsl:for-each select="$thisPerfMeasure">"<xsl:value-of select="current()/own_slot_value[slot_reference='pm_measured_element']/value"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="pmVals">
	<xsl:variable name="thissqvs" select="$sqvs[name=current()/own_slot_value[slot_reference='pm_performance_value']/value]"/> 
	{
	"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
	"thissqvs": [<xsl:apply-templates select="$thissqvs" mode="svQuals"/>]
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="sqValScore">
	<xsl:param name="pms"/>
<xsl:variable name="linkedPMs" select="$pms[own_slot_value[slot_reference='pm_performance_value']/value=current()/name]"/>
 	{
	"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", 
	"score":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"/>",
	"value":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/>",
	"linkedPms":<xsl:value-of select="count($linkedPMs/name)"/>
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
