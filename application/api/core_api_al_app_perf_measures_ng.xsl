<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities_NG.xsl"/>
<xsl:include href="../../common/core_js_functions_NG.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>

<xsl:param name="allAppsApi"/>
<xsl:param name="allCompAppsApi"/>
<xsl:param name="allAppProRolesApi"/>
<xsl:param name="Performance_Measure_CategoryApi"/>
<xsl:param name="APP_PRO_TO_PHYS_BUS_RELATIONApi"/>
<xsl:param name="BusPerformance_MeasureApi"/>
<xsl:param name="AppPerformance_MeasureApi"/>
<xsl:param name="TechPerformance_MeasureApi"/>
<xsl:param name="InfoPerformance_MeasureApi"/>
<xsl:param name="BusService_QualityApi"/>
<xsl:param name="AppService_QualityApi"/>
<xsl:param name="TechService_QualityApi"/>
<xsl:param name="InfoService_QualityApi"/>
<xsl:param name="BusService_Quality_ValueApi"/>
<xsl:param name="AppService_Quality_ValueApi"/>
<xsl:param name="TechService_Quality_ValueApi"/>
<xsl:param name="InfoService_Quality_ValueApi"/>
<xsl:param name="allStyleApi"/>

<eas:apiRequests>
		{
			"apiRequestSet": [
				{"variable": "allAppsApi", "query": "/instances/type/Application_Provider"},
				{"variable": "allCompAppsApi", "query": "/instances/type/Composite_Application_Provider"},
				{"variable": "allAppProRolesApi", "query": "/instances/type/Application_Provider_Role"},
				{"variable": "APP_PRO_TO_PHYS_BUS_RELATIONApi", "query": "/instances/type/APP_PRO_TO_PHYS_BUS_RELATION"},
				{"variable": "Performance_Measure_CategoryApi", "query": "/instances/type/Performance_Measure_Category"},
				{"variable": "BusPerformance_MeasureApi", "query": "/instances/type/Business_Performance_Measure"},
				{"variable": "AppPerformance_MeasureApi", "query": "/instances/type/Application_Performance_Measure"},
				{"variable": "TechPerformance_MeasureApi", "query": "/instances/type/Technology_Performance_Measure"},
				{"variable": "InfoPerformance_MeasureApi", "query": "/instances/type/Information_Performance_Measure"},
				{"variable": "BusService_QualityApi", "query": "/instances/type/Business_Service_Quality"},
				{"variable": "AppService_QualityApi", "query": "/instances/type/Application_Service_Quality"},
				{"variable": "TechService_QualityApi", "query": "/instances/type/Technology_Service_Quality"},
				{"variable": "InfoService_QualityApi", "query": "/instances/type/Information_Service_Quality"},
				{"variable": "BusService_Quality_ValueApi", "query": "/instances/type/Business_Service_Quality_Value"},
				{"variable": "AppService_Quality_ValueApi", "query": "/instances/type/Application_Service_Quality_Value"},
				{"variable": "TechService_Quality_ValueApi", "query": "/instances/type/Technology_Service_Quality_Value"},
				{"variable": "InfoService_Quality_ValueApi", "query": "/instances/type/Information_Service_Quality_Value"},
				{"variable": "allStyleApi", "query": "/instances/type/Element_Style"} 
			]
		}
</eas:apiRequests>
			
<xsl:variable name="allAppProviders" select="$allAppsApi//simple_instance union $allCompAppsApi//simple_instance"/>
<xsl:variable name="appAPRs" select="$allAppProRolesApi//simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = $allAppProviders/name]"/>
<xsl:key name="appAPRskey" match="$allAppProRolesApi//simple_instance" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
<xsl:variable name="physProcessesDirect" select="$APP_PRO_TO_PHYS_BUS_RELATIONApi//simple_instance[own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value=$allAppProviders/name]"/>
<xsl:key name="physProcessesDirectkey" match="$APP_PRO_TO_PHYS_BUS_RELATIONApi//simple_instance" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/> 

<xsl:variable name="physProcessesIndirect" select="$APP_PRO_TO_PHYS_BUS_RELATIONApi//simple_instance[own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value=$appAPRs/name]"/>
<xsl:key name="physProcessesIndirectkey" match="$APP_PRO_TO_PHYS_BUS_RELATIONApi//simple_instance" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/> 
<xsl:variable name="allPhysProcesses" select="$physProcessesDirect union $physProcessesIndirect"/>
<xsl:variable name="allperfMeasures" select="$BusPerformance_MeasureApi//simple_instance union $AppPerformance_MeasureApi//simple_instance union $TechPerformance_MeasureApi//simple_instance union $InfoPerformance_MeasureApi//simple_instance"/>
<xsl:variable name="allServicQualities" select="$BusService_QualityApi//simple_instance union $AppService_QualityApi//simple_instance union $TechService_QualityApi//simple_instance union $InfoService_QualityApi//simple_instance"/>
<xsl:variable name="allServicQualityValues" select="$BusService_Quality_ValueApi//simple_instance union $AppService_Quality_ValueApi//simple_instance union $TechService_Quality_ValueApi//simple_instance union $InfoService_Quality_ValueApi//simple_instance"/>

<xsl:variable name="perfCategory" select="$Performance_Measure_CategoryApi//simple_instance[own_slot_value[slot_reference='pmc_measures_ea_classes']/value=$allAppProviders/type]"/> 
<xsl:variable name="perfMeasures" select="$allperfMeasures[name=$allAppProviders/own_slot_value[slot_reference='performance_measures']/value]"/> 
<xsl:variable name="appProcessPerfMeasures" select="$allperfMeasures[name=$allPhysProcesses/own_slot_value[slot_reference='performance_measures']/value]"/> 

<xsl:key name="perfMeasureskey" match="$allperfMeasures" use="own_slot_value[slot_reference='pm_measured_element']/value"/> 

<xsl:variable name="serviceQualities" select="$allServicQualities[name=$perfCategory/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
<xsl:variable name="serviceQualityValues" select="$allServicQualityValues[own_slot_value[slot_reference = 'usage_of_service_quality']/value=$serviceQualities/name]"></xsl:variable>
<xsl:key name="serviceQualityValueskey" match="$allServicQualityValues" use="own_slot_value[slot_reference = 'usage_of_service_quality']/value"/>
<xsl:variable name="allElementStyles" select="$allStyleApi//simple_instance"/>
<!--
<xsl:variable name="BusinessFit" select="/node()/simple_instance[type = 'Business_Service_Quality'][own_slot_value[slot_reference = 'name']/value = ('Business Fit')]"></xsl:variable>
<xsl:variable name="BFValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value = $BusinessFit/name]"></xsl:variable>
<xsl:variable name="perfMeasures" select="/node()/simple_instance[type = 'Business_Performance_Measure'][own_slot_value[slot_reference = 'pm_performance_value']/value = $BFValues/name]"></xsl:variable>

<xsl:variable name="ApplicationFit" select="/node()/simple_instance[type = 'Technology_Service_Quality'][own_slot_value[slot_reference = 'name']/value = ('Technical Fit')]"></xsl:variable>
<xsl:variable name="AFValues" select="/node()/simple_instance[type = 'Technology_Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value = $ApplicationFit/name]"></xsl:variable>
<xsl:variable name="appPerfMeasures" select="/node()/simple_instance[type = 'Technology_Performance_Measure'][own_slot_value[slot_reference = 'pm_performance_value']/value = $AFValues/name]"></xsl:variable>
<xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"></xsl:variable>
-->
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
 
<xsl:template match="knowledge_base">{"applications":[<xsl:apply-templates select="$allAppProviders" mode="applications">
		<xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"perfCategory":[<xsl:apply-templates select="$perfCategory" mode="perf"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>],
	"serviceQualities":[<xsl:apply-templates select="$serviceQualities" mode="sqs"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>]}
</xsl:template>

<xsl:template match="node()" mode="applications">
	 
		<xsl:variable name="thisAppAPRs" select="key('appAPRskey', current()/name)"/>
		<xsl:variable name="thisphysProcessesDirect" select="key('physProcessesDirectkey', current()/name)"/>
		<xsl:variable name="thisphysProcessesIndirect" select="key('physProcessesIndirectkey', $thisAppAPRs/name)"/>
		<!--
		<xsl:variable name="thisphysProcessesDirect" select="$physProcessesDirect[own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value=current()/name]"/>
		<xsl:variable name="thisphysProcessesIndirect" select="$physProcessesIndirect[own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value=$thisAppAPRs/name]"/>-->
		<xsl:variable name="allthisPhysProcesses" select="$thisphysProcessesDirect union $thisphysProcessesIndirect"/> 
	<!--	<xsl:variable name="thisperfMeasures" select="$perfMeasures[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/> -->
		<xsl:variable name="thisperfMeasures" select="key('perfMeasureskey',current()/name)"/>
		<xsl:variable name="thisServQualityValues" select="$serviceQualityValues[name=$thisperfMeasures/own_slot_value[slot_reference='pm_performance_value']/value]"/> 
		
		<xsl:variable name="processesWithScores" select="$allthisPhysProcesses[count(own_slot_value[slot_reference='performance_measures']/value)&gt;0]"/>
		
		<xsl:variable name="thisperfCategory" select="$perfCategory[own_slot_value[slot_reference='pmc_measures_ea_classes']/value=current()/type]"/> 
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"app": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"perfMeasures":[<xsl:apply-templates select="$thisperfMeasures" mode="performanceMeasures"/>]
		<!--
		"scores":[<xsl:for-each select="$thisServQualityValues"><xsl:variable name="thisServiceQuality" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"></xsl:variable>
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","score": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>","value": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>","type":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value)"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"processes":[<xsl:for-each select="$processesWithScores">
		<xsl:variable name="thisprocMeasures" select="$appProcessPerfMeasures[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/> 
		<xsl:variable name="thisProcessServQualityValues" select="$serviceQualityValues[name=$thisprocMeasures/own_slot_value[slot_reference='pm_performance_value']/value]"/> 
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value)"/>",
		"scores":[<xsl:for-each select="$thisProcessServQualityValues">
			<xsl:variable name="thisServiceQuality" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"></xsl:variable>
			{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","score": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>","value": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>","type":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value)"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>-->}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="sqs">
			<!--	<xsl:variable name="thisserviceQualityValues" select="$serviceQualityValues[own_slot_value[slot_reference = 'usage_of_service_quality']/value=current()/name]"></xsl:variable>
			-->
				<xsl:variable name="thisserviceQualityValues" select="key('serviceQualityValueskey',current()/name)"/> 
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"shortName":"<xsl:value-of select="current()/own_slot_value[slot_reference='short_name']/value"/>",
				"sqvs":[<xsl:apply-templates select="$thisserviceQualityValues" mode="sqvalues"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>]
			}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="perf">
				<xsl:variable name="thisServiceQualities" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"qualities":[<xsl:for-each select="$thisServiceQualities">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="sqvalues">
			<xsl:variable name="thisStyle" select="$allElementStyles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"score": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>","value": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>",
				"elementColour": "<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>",
				"elementBackgroundColour": "<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>"
				}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		 
		</xsl:template>
		<xsl:template match="node()" mode="performanceCat">
		<xsl:variable name="thisAppserviceQualities" select="/node()/simple_instance[supertype = 'Service_Quality'][name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
		
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"serviceQuals":[<xsl:for-each select="$thisAppserviceQualities">
			
			{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>


		<xsl:template match="node()" mode="performanceMeasures">
			<xsl:variable name="thisServQualityValues" select="$serviceQualityValues[name=current()/own_slot_value[slot_reference='pm_performance_value']/value]"/> 
			<xsl:variable name="thisperfCategory" select="$perfCategory[name=current()/own_slot_value[slot_reference='pm_category']/value]"/> 
			{"categoryid": "<xsl:value-of select="$thisperfCategory/name"/>", 
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<!--"category":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisperfCategory"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",-->
			"date":"<xsl:value-of select="current()/own_slot_value[slot_reference='system_last_modified_datetime_iso8601']/value"/>",
			"serviceQuals":[<xsl:for-each select="$thisServQualityValues">
				<xsl:variable name="thisServiceQuality" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"></xsl:variable>
				<xsl:variable name="perfQual" select="$perfCategory[own_slot_value[slot_reference = 'pmc_service_qualities']/value=$thisServiceQuality/name]"></xsl:variable>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<!--	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",-->
				"serviceName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisServiceQuality"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"serviceId":"<xsl:value-of select="eas:getSafeJSString($thisServiceQuality/name)"/>",
				"score": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>",
				"value": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>",
				"categoryId":"<xsl:value-of select="eas:getSafeJSString($perfQual/name)"/>",
				"categoryName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$perfQual"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
			</xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
			</xsl:template>
		
		   </xsl:stylesheet>
		   