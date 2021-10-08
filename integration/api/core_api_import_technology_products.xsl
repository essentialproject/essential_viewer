<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
  <xsl:variable name="techComponents" select="/node()/simple_instance[type='Technology_Component']"/>
  <xsl:variable name="techCapabilities" select="/node()/simple_instance[type='Technology_Capability']"/>
    <xsl:variable name="suppliers" select="/node()/simple_instance[type='Supplier']"/>  
  <xsl:variable name="techProducts" select="/node()/simple_instance[type='Technology_Product']"/> 
 <xsl:variable name="techProdFams" select="/node()/simple_instance[type='Technology_Product_Family']"/>
    <xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
   <xsl:variable name="techDeliveryModel" select="/node()/simple_instance[type='Technology_Delivery_Model']"/>
  <xsl:variable name="tprs" select="/node()/simple_instance[type = 'Technology_Product_Role']"/> 
  <xsl:variable name="techStandards" select="/node()/simple_instance[type='Technology_Provider_Standard_Specification']"/>
  <xsl:variable name="enumsStandards" select="/node()/simple_instance[type='Standard_Strength']"/>
  <xsl:variable name="supplier" select="/node()/simple_instance[type='Supplier']"/>	
 <xsl:variable name="techlifecycle" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	 
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
	 
	<xsl:template match="knowledge_base">
    {"technology_products":[<xsl:apply-templates select="$techProducts" mode="techProducts"></xsl:apply-templates>],
     "tprStandards":[<xsl:apply-templates select="$tprs" mode="techStds"></xsl:apply-templates>]}
	</xsl:template>


   <xsl:template mode="techProducts" match="node()">
    <xsl:variable name="thissupplier" select="$suppliers[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
    <xsl:variable name="thisfamily" select="$techProdFams[name=current()/own_slot_value[slot_reference='member_of_technology_product_families']/value]"/>
    <xsl:variable name="thisvendor" select="$techlifecycle[name=current()/own_slot_value[slot_reference='vendor_product_lifecycle_status']/value]"/>
	 <xsl:variable name="thissupplier" select="$supplier[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>   
    <xsl:variable name="thisdelivery" select="$techDeliveryModel[name=current()/own_slot_value[slot_reference='technology_provider_delivery_model']/value]"/>
    <xsl:variable name="thisusages" select="$tprs[name=current()/own_slot_value[slot_reference='implements_technology_components']/value]"/>
    
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
         "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		 "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
        </xsl:call-template>",
        "family":[<xsl:for-each select="$thisfamily">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
         "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	   "supplier":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thissupplier"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "vendor":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisvendor"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "delivery":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisdelivery"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "usages":[<xsl:for-each select="$thisusages">
        <xsl:variable name="componentsUsed" select="$techComponents[name=current()/own_slot_value[slot_reference='implementing_technology_component']/value]"/>{"id":"<xsl:value-of select="eas:getSafeJSString($componentsUsed/name)"/>","tprid":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
         "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$componentsUsed"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
        "compliance":"<xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=current()/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/>",
        "adoption":"<xsl:value-of select="$lifecycle[name=$thisusages[1]/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
        }<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template> 
  <xsl:template mode="techStds" match="node()">
      {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
      "compliance2":[<xsl:for-each select="$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=current()/name]">
      {"id":"<xsl:value-of select="eas:getSafeJSString($enumsStandards[name=current()/own_slot_value[slot_reference='sm_standard_strength']/value]/name)"/>",
      "name":"<xsl:value-of select="$enumsStandards[name=current()/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
      "geos":[<xsl:for-each select="current()/own_slot_value[slot_reference='sm_geographic_scope']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
      "orgs":[<xsl:for-each select="current()/own_slot_value[slot_reference='sm_organisational_scope']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
    }<xsl:if test="position()!=last()">,</xsl:if>
      </xsl:for-each>],
      "compliance":"<xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=current()/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/>",
        "adoption":{"id": "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='strategic_lifecycle_status']/value)"/>","name":"<xsl:value-of select="$lifecycle[name=current()/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>"}}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>      
</xsl:stylesheet>
