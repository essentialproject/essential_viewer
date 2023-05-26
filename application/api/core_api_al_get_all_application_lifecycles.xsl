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
	<xsl:key name="lifecyclesKey" match="/node()/simple_instance[type=('Vendor_Lifecycle_Status','Lifecycle_Status')]" use="type"/>
    <xsl:variable name="lifecycles" select="key('lifecyclesKey',('Vendor_Lifecycle_Status','Lifecycle_Status'))"/>
    <xsl:key name="productsKey" match="/node()/simple_instance[type=('Technology_Product')]" use="type"/>
    <xsl:variable name="products" select="key('productsKey','Technology_Product')"/>
	<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>
	<xsl:variable name="allproducts" select="$products union $apps"/>
     <xsl:key name="productLifecyclesKey" match="/node()/simple_instance[type=('Lifecycle_Model','Vendor_Lifecycle_Model')]" use="own_slot_value[slot_reference='lifecycle_model_subject']/value"/>
    <xsl:key name="lifecycleStatusUsagesKey" match="/node()/simple_instance[type=('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage')]" use="own_slot_value[slot_reference='used_in_lifecycle_model']/value"/>
    <xsl:key name="allSupplier" match="/node()/simple_instance[type = 'Supplier']" use="name"/>   
     <xsl:key name="allTechstdsKey" match="node()/simple_instance[type='Technology_Provider_Standard_Specification']" use="own_slot_value[slot_reference='tps_standard_tech_provider_role']/value"/> 
    <xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type='Technology_Product_Role']"/>
  
	<xsl:key name="techProdRoleswithStdKey" match="$allTechProdRoles" use="own_slot_value[slot_reference='role_for_technology_provider']/value"/>
	<xsl:key name="techProdRolestoStdKey" match="$allTechProdRoles" use="own_slot_value[slot_reference='	tpr_has_standard_specs']/value"/>
 
    <xsl:key name="techCompwithStdKey" match="/node()/simple_instance[type='Technology_Component']" use="own_slot_value[slot_reference='realised_by_technology_products']/value"/>

 

    <xsl:key name="allTechProvUsageKey" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference='provider_as_role']/value"/>
    <xsl:key name="allTechBuildArchKey" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference='contained_architecture_components']/value"/>
    <xsl:key name="prodDeploymentRoleKey" match="/node()/simple_instance[type = 'Technology_Product_Build']" use="own_slot_value[slot_reference='technology_provider_architecture']/value"/>
    <xsl:key name="appDeploymentKey" match="/node()/simple_instance[type = 'Application_Deployment']" use="own_slot_value[slot_reference='application_deployment_technical_arch']/value"/>
	<xsl:key name="appDeployedKey" match="$apps" use="own_slot_value[slot_reference='deployments_of_application_provider']/value"/>
 
   
    
    <xsl:variable name="stdValue" select="/node()/simple_instance[type = 'Standard_Strength']"/>
     <!--  tech for app  -->

	<xsl:variable name="elementStyle" select="/node()/simple_instance[type = ('Element_Style')]"/>
	
	<xsl:template match="knowledge_base">
        {
		 	"application_lifecycles": [<xsl:apply-templates select="$apps" mode="getApplicationProducts"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
		</xsl:apply-templates>],
			"lifecycleJSON":[<xsl:apply-templates select="$lifecycles" mode="Lifecycles"><xsl:sort order="ascending" select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/></xsl:apply-templates>]
	 	}	
	</xsl:template>
    <xsl:template match="node()" mode="getApplicationProducts">
            <xsl:variable name="this" select="current()"/>
            <xsl:variable name="thisproductLifecycles" select="key('productLifecyclesKey', current()/name)"/> 
            <xsl:variable name="thislifecycleStatusUsages" select="key('lifecycleStatusUsagesKey', $thisproductLifecycles/name)"/>
            
           {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                        <xsl:with-param name="theSubjectInstance" select="current()"/>
                        <xsl:with-param name="isForJSONAPI" select="true()"/>
                    </xsl:call-template>", 
            "id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
            "supplierId":"<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='supplier_technology_product']/value)"/>", 
            "allDates":[<xsl:apply-templates select="$thislifecycleStatusUsages" mode="getLifecycleUsages"></xsl:apply-templates>],
            "dates":[] 
        }<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:template>
<xsl:template match="node()" mode="appJSONforProduct">
      <!--  <xsl:variable name="thisProductsRole" select="$allTechProdRoles[own_slot_value[slot_reference='role_for_technology_provider']/value=current()/name]"/>
        <xsl:variable name="thisTechRolesUsage" select="$allTechProvUsage[own_slot_value[slot_reference='provider_as_role']/value=$thisProductsRole/name]"/>
        <xsl:variable name="thistechBuildArch" select="$allTechBuildArch[own_slot_value[slot_reference='contained_architecture_components']/value=$thisTechRolesUsage/name]"/>
        <xsl:variable name="thisprodDeploymentRole" select="$prodDeploymentRole[own_slot_value[slot_reference='technology_provider_architecture']/value=$thistechBuildArch/name]"/>
        <xsl:variable name="thisappDeployment" select="$appDeployment[own_slot_value[slot_reference='application_deployment_technical_arch']/value=$thisprodDeploymentRole/name]"/>
        <xsl:variable name="thisApps" select="$apps[name=$thisappDeployment/own_slot_value[slot_reference='application_provider_deployed']/value]"/>-->
        <xsl:variable name="thisProductsRole" select="key('techProdRoleswithStdKey',current()/name)"/>
		<xsl:variable name="thisTechRolesUsage" select="key('allTechProvUsageKey',$thisProductsRole/name)"/>
		<xsl:variable name="thistechBuildArch" select="key('allTechBuildArchKey',$thisTechRolesUsage/name)"/>
		<xsl:variable name="thisprodDeploymentRole" select="key('prodDeploymentRoleKey',$thistechBuildArch/name)"/>
		<xsl:variable name="thisappDeployment" select="key('appDeploymentKey',$thisprodDeploymentRole/name)"/>
		<xsl:variable name="thisApps" select="key('appDeployedKey',$thisappDeployment/name)"/>
        <xsl:for-each select="$thisApps">
        {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
            </xsl:call-template>",
        "className":"Application_Provider",    
        "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position()=last())">,</xsl:if> 
        </xsl:for-each>   
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
        <xsl:with-param name="isForJSONAPI" select="true()"/>
	</xsl:call-template>","type":"<xsl:value-of select="current()/type"/>","seq":<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise></xsl:choose>,
	"backgroundColour":"<xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>","colour":"<xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
