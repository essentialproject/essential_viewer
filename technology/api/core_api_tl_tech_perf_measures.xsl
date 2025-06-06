<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &lt; 0)]"/>
<xsl:key name="allTechProducts" match="/node()/simple_instance[type = ('Technology_Product')]" use="type"/>
<xsl:variable name="allTechProducts" select="key('allTechProducts', 'Technology_Product')"/>
 
<xsl:key name="allTechProductRole" match="/node()/simple_instance[type = ('Technology_Product_Role')]" use="type"/>
<xsl:variable name="allTechProductRole" select="key('allTechProductRole', 'Technology_Product_Role')[not(own_slot_value[slot_reference='strategic_lifecycle_status']/value=$allLifecycleStatustoShow/name)]"/>
<!--
<xsl:variable name="allTechProductRole" select="/node()/simple_instance[type = ('Technology_Product_Role')][not(own_slot_value[slot_reference='strategic_lifecycle_status']/value=$allLifecycleStatustoShow/name)]"/> 
-->
<xsl:variable name="allTechProds" select="$allTechProducts union $allTechProductRole"/>
 
<xsl:variable name="perfCategory" select="/node()/simple_instance[type='Performance_Measure_Category'][own_slot_value[slot_reference='pmc_measures_ea_classes']/value=('Technology_Product', 'Technology_Product_Role')]"/> 
<xsl:key name="perfMeasureKey" match="/node()/simple_instance[supertype='Performance_Measure']" use="name"/>
<xsl:variable name="perfMeasures" select="key('perfMeasureKey', $allTechProds/own_slot_value[slot_reference='performance_measures']/value)"/> 

<xsl:key name="perfMeasureskey" match="/node()/simple_instance[supertype='Performance_Measure']" use="own_slot_value[slot_reference='pm_measured_element']/value"/> 

<xsl:key name="sqKey" match="/node()/simple_instance[supertype='Service_Quality']" use="name"/>
<xsl:variable name="serviceQualities" select="key('sqKey', $perfCategory/own_slot_value[slot_reference = 'pmc_service_qualities']/value)"></xsl:variable>
 
<xsl:variable name="serviceQualityValues" select="/node()/simple_instance[supertype = 'Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value=$serviceQualities/name]"></xsl:variable>
<xsl:key name="serviceQualityValueskey" match="/node()/simple_instance[supertype = 'Service_Quality_Value']" use="own_slot_value[slot_reference = 'usage_of_service_quality']/value"/>
<xsl:key name="serviceQualityValues" match="/node()/simple_instance[supertype = 'Service_Quality_Value']" use="name"/>
<xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>

<xsl:key name="allClasses" match="/node()/class[type = ':ESSENTIAL-CLASS']" use="name"/>
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
<!-- All logical and physical processes on one level -->
 
<xsl:template match="knowledge_base">{"technology_product":[<xsl:apply-templates select="$allTechProds" mode="techProducts">
        <xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
    "technology_product_role":[<xsl:apply-templates select="$allTechProductRole" mode="techProductRoles">
		<xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"perfCategory":[<xsl:apply-templates select="$perfCategory" mode="perf"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>],
	"serviceQualities":[<xsl:apply-templates select="$serviceQualities" mode="sqs"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>]}
</xsl:template>

<xsl:template match="node()" mode="techProducts">
		<xsl:variable name="thisperfMeasures" select="key('perfMeasureskey',current()/name)"/> 
	 	<xsl:variable name="thisServQualityValues" select="key('serviceQualityValues', current()/own_slot_value[slot_reference='pm_performance_value']/value)"/>  
		<xsl:variable name="thisperfCategory" select="$perfCategory[own_slot_value[slot_reference='pmc_measures_ea_classes']/value=current()/type]"/> 
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", <xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
        <xsl:if test="current()/own_slot_value[slot_reference='implemented_by_physical_business_processes']/value">"physical":[<xsl:for-each select="current()/own_slot_value[slot_reference='implemented_by_physical_business_processes']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],</xsl:if>
		"perfMeasures":[<xsl:apply-templates select="$thisperfMeasures" mode="performanceMeasures"/>]
	    ,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
        </xsl:template>
    
<xsl:template match="node()" mode="techProductRoles">
		<xsl:variable name="thisperfMeasures" select="key('perfMeasureskey',current()/name)"/> 
	 	<xsl:variable name="thisServQualityValues" select="key('serviceQualityValues', current()/own_slot_value[slot_reference='pm_performance_value']/value)"/>  
		<xsl:variable name="thisperfCategory" select="$perfCategory[own_slot_value[slot_reference='pmc_measures_ea_classes']/value=current()/type]"/> 
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
        <xsl:if test="current()/own_slot_value[slot_reference='implemented_by_physical_business_processes']/value">"physical":[<xsl:for-each select="current()/own_slot_value[slot_reference='implemented_by_physical_business_processes']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],</xsl:if>
		"perfMeasures":[<xsl:apply-templates select="$thisperfMeasures" mode="performanceMeasures"/>]
	    ,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="sqs">
			<!--	<xsl:variable name="thisserviceQualityValues" select="$serviceQualityValues[own_slot_value[slot_reference = 'usage_of_service_quality']/value=current()/name]"></xsl:variable>
			-->
				<xsl:variable name="thisserviceQualityValues" select="key('serviceQualityValueskey',current()/name)"/> 
				<xsl:variable name="thisserviceQualityMax" select="key('serviceQualityValues', current()/own_slot_value[slot_reference = 'sq_maximum_value']/value)"></xsl:variable>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
					}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"type": "<xsl:value-of select="current()/type"/>",
				"shortName":"<xsl:value-of select="current()/own_slot_value[slot_reference='short_name']/value"/>",
				"maxScore":"<xsl:value-of select="$thisserviceQualityMax/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>",
				"serviceWeighting":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'sq_weighting']/value"/>",
				"serviceIndex":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'sq_index']/value"/>", 
				"sqvs":[<xsl:apply-templates select="$thisserviceQualityValues" mode="sqvalues"><xsl:sort select="own_slot_name[slot_reference='name']/value" order="ascending"/> </xsl:apply-templates>]
			}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="perf">
				<xsl:variable name="thisServiceQualities" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"></xsl:variable>
				<xsl:variable name="thisClasses" select="key('allClasses', current()/own_slot_value[slot_reference = ('enumeration_value_for_classes')]/value)"/>
				{
				"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"type": "<xsl:value-of select="current()/type"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'enumeration_value': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
					'enumeration_sequence_number': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_sequence_number')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"classes":[<xsl:for-each select="current()/own_slot_value[slot_reference='pmc_measures_ea_classes']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
				"enumeration_value_for_classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()"></xsl:if></xsl:for-each>],
				"qualities":[<xsl:for-each select="$thisServiceQualities">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="sqvalues">
			<xsl:variable name="thisStyle" select="$allElementStyles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
				{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"type": "<xsl:value-of select="current()/type"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
				'score': string(translate(translate(current()/own_slot_value[slot_reference = ('service_quality_value_score')]/value,'}',')'),'{',')')),
				'value': string(translate(translate(current()/own_slot_value[slot_reference = ('service_quality_value_value')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"index": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'sqv_index']/value"/>",
				"elementColour": "<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>",
				"elementBackgroundColour": "<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>"
				}<xsl:if test="not(position()!= last())"><xsl:text>,</xsl:text></xsl:if>
		 
		</xsl:template>
    <xsl:template match="node()" mode="performanceCat">
    <xsl:variable name="thisserviceQualities" select="key('sqKey', current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value)"></xsl:variable>
    
    {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
		}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"serviceQuals":[<xsl:for-each select="$thisserviceQualities">
        {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
			}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
    </xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
    </xsl:template>


	<xsl:template match="node()" mode="performanceMeasures">
			<xsl:variable name="thisServQualityValues" select="key('serviceQualityValues', current()/own_slot_value[slot_reference='pm_performance_value']/value)"/> 
			<xsl:variable name="thisperfCategory" select="$perfCategory[name=current()/own_slot_value[slot_reference='pm_category']/value]"/> 
			<xsl:choose>
				<xsl:when test="count($thisperfCategory)&gt;1">
					<xsl:for-each select="$thisperfCategory">
					{"categoryid": "<xsl:value-of select="current()/name"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					{"categoryid": "<xsl:value-of select="$thisperfCategory/name"/>", 
					"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					<!--"category":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisperfCategory"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",-->
					"date":"<xsl:value-of select="current()/own_slot_value[slot_reference='pm_measure_date_iso_8601']/value"/>",
					"createdDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='system_creation_datetime_iso8601']/value"/>",
					"serviceQuals":[<xsl:for-each select="$thisServQualityValues">
						<xsl:variable name="thisServiceQuality" select="$serviceQualities[name=current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"></xsl:variable>
						<xsl:variable name="perfQual" select="$perfCategory[own_slot_value[slot_reference = 'pmc_service_qualities']/value=$thisServiceQuality/name]"></xsl:variable>
						{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						"type": "<xsl:value-of select="current()/type"/>",
					<!--	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",-->
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
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>
 </xsl:stylesheet>
		   