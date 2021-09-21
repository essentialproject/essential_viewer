<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
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
	<xsl:variable name="lifecycles" select="/node()/simple_instance[type=('Vendor_Lifecycle_Status','Lifecycle_Status')]"/>
        
	<xsl:variable name="products" select="/node()/simple_instance[type='Technology_Product']"/>
	<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>
	<xsl:variable name="allproducts" select="$products union $apps"/>
    <xsl:variable name="productLifecycles" select="/node()/simple_instance[type=('Lifecycle_Model','Vendor_Lifecycle_Model')][own_slot_value[slot_reference='lifecycle_model_subject']/value=$allproducts/name]"/>
    <xsl:variable name="lifecycleStatusUsages" select="/node()/simple_instance[type=('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$productLifecycles/name]"/>
    <xsl:variable name="allSupplier" select="/node()/simple_instance[type = 'Supplier']"/>     
    <xsl:variable name="allTechstds" select="/node()/simple_instance[type = 'Technology_Provider_Standard_Specification']"/>
    <xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type='Technology_Product_Role']"/>
	<xsl:variable name="techProdRoleswithStd" select="$allTechProdRoles[name = $allTechstds/own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value]"/>
	<xsl:variable name="techCompwithStd" select="/node()/simple_instance[type='Technology_Component'][name = $techProdRoleswithStd/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
  
    <xsl:variable name="allTechProvUsage" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference='provider_as_role']/value=$allTechProdRoles/name]"/>
    <xsl:variable name="allTechBuildArch" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference='contained_architecture_components']/value=$allTechProvUsage/name]"/>
	<xsl:variable name="prodDeploymentRole" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference='technology_provider_architecture']/value=$allTechBuildArch/name]"/>
    <xsl:variable name="appDeployment" select="/node()/simple_instance[type = 'Application_Deployment'][own_slot_value[slot_reference='application_deployment_technical_arch']/value=$prodDeploymentRole/name]"/>
    <xsl:variable name="actors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="geos" select="/node()/simple_instance[supertype = 'Geography']"/>
   
    
    <xsl:variable name="stdValue" select="/node()/simple_instance[type = 'Standard_Strength']"/>
     <!--  tech for app  -->

	<xsl:variable name="elementStyle" select="/node()/simple_instance[type = ('Element_Style')]"/>
	
	<xsl:template match="knowledge_base">
        {
			"technology_lifecycles": [<xsl:apply-templates select="$products" mode="getProducts"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"lifecycleJSON":[<xsl:apply-templates select="$lifecycles" mode="Lifecycles"><xsl:sort order="ascending" select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/></xsl:apply-templates>],
			"standardsJSON":[<xsl:apply-templates select="$stdValue" mode="Lifecycles"><xsl:sort order="ascending" select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/></xsl:apply-templates>]

		}	
	</xsl:template>
	
	<xsl:template match="node()" mode="getProducts">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thisproductLifecycles" select="$productLifecycles[own_slot_value[slot_reference='lifecycle_model_subject']/value=current()/name]"/>
    <xsl:variable name="thislifecycleStatusUsages" select="$lifecycleStatusUsages[own_slot_value[slot_reference='used_in_lifecycle_model']/value=$thisproductLifecycles/name]"/>
    <xsl:variable name="thisSupplier" select="$allSupplier[name=$this/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
    <xsl:variable name="thisProdRoles" select="$techProdRoleswithStd[own_slot_value[slot_reference='role_for_technology_provider']/value=current()/name]"/>
    <xsl:variable name="thisStd" select="$allTechstds[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value=$thisProdRoles/name]"/>
	
   {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>", 
    "id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
    "supplier":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="$thisSupplier"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>", 
    "id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
    "supplierId":"<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='supplier_technology_product']/value)"/>", 
    "linkid":"<xsl:value-of select="$this/name"/>",
    "allDates":[<xsl:apply-templates select="$thislifecycleStatusUsages" mode="getLifecycleUsages"></xsl:apply-templates>],
    "dates":[],
	"applications":[<xsl:apply-templates select="current()" mode="appJSONforProduct"></xsl:apply-templates>],
	"standards":[<xsl:apply-templates select="$thisStd" mode="prodStandards"></xsl:apply-templates>]
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="appJSONforProduct">
        <xsl:variable name="thisProductsRole" select="$allTechProdRoles[own_slot_value[slot_reference='role_for_technology_provider']/value=current()/name]"/>
        <xsl:variable name="thisTechRolesUsage" select="$allTechProvUsage[own_slot_value[slot_reference='provider_as_role']/value=$thisProductsRole/name]"/>
        <xsl:variable name="thistechBuildArch" select="$allTechBuildArch[own_slot_value[slot_reference='contained_architecture_components']/value=$thisTechRolesUsage/name]"/>
        <xsl:variable name="thisprodDeploymentRole" select="$prodDeploymentRole[own_slot_value[slot_reference='technology_provider_architecture']/value=$thistechBuildArch/name]"/>
        <xsl:variable name="thisappDeployment" select="$appDeployment[own_slot_value[slot_reference='application_deployment_technical_arch']/value=$thisprodDeploymentRole/name]"/>
        <xsl:variable name="thisApps" select="$apps[name=$thisappDeployment/own_slot_value[slot_reference='application_provider_deployed']/value]"/>
        <xsl:for-each select="$thisApps">
        {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
        "className":"Application_Provider",    
        "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position()=last())">,</xsl:if> 
        </xsl:for-each>   
</xsl:template>
<xsl:template match="node()" mode="prodStandards">
	<xsl:variable name="thisStyle" select="$elementStyle[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
	<xsl:variable name="thisTPR" select="$techProdRoleswithStd[name=current()/own_slot_value[slot_reference='tps_standard_tech_provider_role']/value]"/>
	<xsl:variable name="thisComponent" select="$techCompwithStd[name = $thisTPR/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
	<xsl:variable name="thisStandard" select="$stdValue[name = current()/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
	<xsl:variable name="thisOrgs" select="$actors[name = current()/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>
	<xsl:variable name="thisGeos" select="$geos[name = current()/own_slot_value[slot_reference = 'sm_geographic_scope']/value]"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"componentName":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisComponent"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"standardStrength":"<xsl:value-of select="eas:getSafeJSString($thisStandard/name)"/>",
		"geoScope":[<xsl:for-each select="$thisGeos">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"orgScope":[<xsl:for-each select="$thisOrgs">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]	
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="getLifecycleUsages">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thisISODate" select="$this/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>   
    {"id":"<xsl:value-of select="eas:getSafeJSString($lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/name)"/>",
    "name":"<xsl:value-of select="$lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/>",
    "dateOf":"<xsl:value-of select="$thisISODate"/>",
    "thisid":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
    "type":"<xsl:value-of select="$lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/type"/>"}
  <xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="Lifecycles">
	<xsl:variable name="thisStyle" select="$elementStyle[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="current()"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
	</xsl:call-template>","type":"<xsl:value-of select="current()/type"/>","seq":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise></xsl:choose>,
	"backgroundColour":"<xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>","colour":"<xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
