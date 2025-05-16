<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = ('Supplier')][own_slot_value[slot_reference='performance_measures']/value]"/>
<xsl:variable name="allProjects" select="/node()/simple_instance[type = ('Project')][own_slot_value[slot_reference='performance_measures']/value]"/>
<xsl:variable name="allTypes" select="$allProjects union $allSuppliers"/>
<xsl:variable name="perfCategory" select="/node()/simple_instance[type='Performance_Measure_Category'][own_slot_value[slot_reference='pmc_measures_ea_classes']/value=('Project', 'Supplier')]"/> 
<xsl:variable name="perfMeasuresSupplier" select="/node()/simple_instance[supertype='Performance_Measure'][name=$allSuppliers/own_slot_value[slot_reference='performance_measures']/value]"/> 
<xsl:variable name="perfMeasuresProject" select="/node()/simple_instance[supertype='Performance_Measure'][name=$allProjects/own_slot_value[slot_reference='performance_measures']/value]"/> 

<xsl:key name="perfMeasureskey" match="/node()/simple_instance[supertype='Performance_Measure']" use="own_slot_value[slot_reference='pm_measured_element']/value"/> 

<xsl:variable name="serviceQualities" select="/node()/simple_instance[supertype = 'Service_Quality'][name=$perfCategory/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
<xsl:variable name="serviceQualityValues" select="/node()/simple_instance[supertype = 'Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value=$serviceQualities/name]"></xsl:variable>
<xsl:key name="serviceQualityValues" match="/node()/simple_instance[supertype = 'Service_Quality_Value']" use="name"/>
<xsl:key name="serviceQualityValueskey" match="/node()/simple_instance[supertype = 'Service_Quality_Value']" use="own_slot_value[slot_reference = 'usage_of_service_quality']/value"/>
<xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>

<!--
	* Copyright © 2008-2019 Enterprise Architecture Solutions Limited.
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
<!-- 03.09.2019 JP  Created	 -->
 
<xsl:template match="knowledge_base">{"projects":[<xsl:apply-templates select="$allProjects" mode="focus">
		<xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"suppliers":[<xsl:apply-templates select="$allSuppliers" mode="focus">
		<xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"perfCategory":[<xsl:apply-templates select="$perfCategory" mode="perf"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>],
	"serviceQualities":[<xsl:apply-templates select="$serviceQualities" mode="sqs"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>]}
</xsl:template>

<xsl:template match="node()" mode="focus">
 	<xsl:variable name="thisperfMeasures" select="key('perfMeasureskey',current()/name)"/>
    <xsl:variable name="thisServQualityValues" select="key('serviceQualityValues', $thisperfMeasures/own_slot_value[slot_reference='pm_performance_value']/value)"/> 
    <xsl:variable name="thisperfCategory" select="$perfCategory[own_slot_value[slot_reference='pmc_measures_ea_classes']/value=current()/type]"/> 
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'instance': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
		"perfMeasures":[<xsl:apply-templates select="$thisperfMeasures" mode="performanceMeasures"/>]
		}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="sqs">
 
				<xsl:variable name="thisserviceQualityValues" select="key('serviceQualityValueskey',current()/name)"/> 
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'shortName': string(translate(translate(current()/own_slot_value[slot_reference = 'short_name']/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
				"sqvs":[<xsl:apply-templates select="$thisserviceQualityValues" mode="sqvalues"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>]
			}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="perf">
				<xsl:variable name="thisServiceQualities" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
				"classes":[<xsl:for-each select="current()/own_slot_value[slot_reference='pmc_measures_ea_classes']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
				"qualities":[<xsl:for-each select="$thisServiceQualities">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="sqvalues">
			<xsl:variable name="thisStyle" select="$allElementStyles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
				"score": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>","value": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>",
				"elementColour": "<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>",
				"elementBackgroundColour": "<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>"
				}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		 
		</xsl:template>
		<xsl:template match="node()" mode="performanceCat">
		<xsl:variable name="thisInstserviceQualities" select="/node()/simple_instance[supertype = 'Service_Quality'][name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
		
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"serviceQuals":[<xsl:for-each select="$thisInstserviceQualities">
			
			{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>


		<xsl:template match="node()" mode="performanceMeasures">
			<xsl:variable name="thisServQualityValues" select="$serviceQualityValues[name=current()/own_slot_value[slot_reference='pm_performance_value']/value]"/> 
			<xsl:variable name="thisperfCategory" select="$perfCategory[name=current()/own_slot_value[slot_reference='pm_category']/value]"/> 
			{"categoryid": "<xsl:value-of select="$thisperfCategory/name"/>", 
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
			"date":"<xsl:value-of select="current()/own_slot_value[slot_reference='pm_measure_date_iso_8601']/value"/>",
			"createdDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='system_creation_datetime_iso8601']/value"/>",
			"serviceQuals":[<xsl:for-each select="$thisServQualityValues">
				<xsl:variable name="thisServiceQuality" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"></xsl:variable>
				<xsl:variable name="perfQual" select="$perfCategory[own_slot_value[slot_reference = 'pmc_service_qualities']/value=$thisServiceQuality/name]"></xsl:variable>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'serviceName': string(translate(translate($thisServiceQuality/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
				"serviceId":"<xsl:value-of select="eas:getSafeJSString($thisServiceQuality/name)"/>",
				"score": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>",
				"value": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>",
				"categoryId":[<xsl:for-each select="$perfQual">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
				"categoryName":[<xsl:for-each select="$perfQual">"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
</xsl:stylesheet>
		   