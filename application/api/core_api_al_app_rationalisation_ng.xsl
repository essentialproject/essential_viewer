<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:import href="../../common/core_el_ref_model_include.xsl"/>
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
    <xsl:param name="Composite_Application_ProviderApi"/>
    <xsl:param name="Application_ProviderApi"/>
    <xsl:param name="Application_Provider_RoleApi"/>
    <xsl:param name="Application_ServiceApi"/>
    <xsl:param name="Lifecycle_StatusApi"/>
    <xsl:param name="Static_Application_Provider_UsageApi"/>
    <xsl:param name="Static_Application_Provider_ArchitectureApi"/>
    <xsl:param name="APU-TO-APU-STATIC-RELATIONApi"/>
    <xsl:param name="Codebase_StatusApi"/>
    <xsl:param name="APP_PRO_TO_PHYS_BUS_RELATIONApi"/>
    <xsl:param name="Physical_ProcessApi"/>
    <xsl:param name="Business_ProcessApi"/>
    <xsl:param name="Business_CapabilityApi"/>
    <xsl:param name="CostApi"/>
    <xsl:param name="Cost_ComponentApi"/>
    <xsl:param name="Report_ConstantApi"/>
    <xsl:param name="CurrencyApi"/>
    <xsl:param name="TaxonomyApi"/>
    <xsl:param name="Taxonomy_TermApi"/>

	<eas:apiRequests>
			{"apiRequestSet": [
            {"variable":"Composite_Application_ProviderApi", "query":"/instances/Composite_Application_Provider"},
            {"variable":"Application_ProviderApi", "query":"/instances/Application_Provider"},
            {"variable":"Application_Provider_RoleApi", "query":"/instances/Application_Provider_Role"},
            {"variable":"Application_ServiceApi", "query":"/instances/Application_Service"},
            {"variable":"Lifecycle_StatusApi", "query":"/instances/Lifecycle_Status"},
            {"variable":"Static_Application_Provider_UsageApi", "query":"/instances/Static_Application_Provider_Usage"},
            {"variable":"Static_Application_Provider_ArchitectureApi", "query":"/instances/Static_Application_Provider_Architecture"},
            {"variable":"APU-TO-APU-STATIC-RELATIONApi", "query":"/instances/:APU-TO-APU-STATIC-RELATION"},
            {"variable":"Codebase_StatusApi", "query":"/instances/Codebase_Status"},
            {"variable":"APP_PRO_TO_PHYS_BUS_RELATIONApi", "query":"/instances/APP_PRO_TO_PHYS_BUS_RELATION"},
            {"variable":"Physical_ProcessApi", "query":"/instances/Physical_Process"},
            {"variable":"Business_ProcessApi", "query":"/instances/Business_Process"},
            {"variable":"Business_CapabilityApi", "query":"/instances/Business_Capability"},
            {"variable":"CostApi", "query":"/instances/Cost"},
            {"variable":"Cost_ComponentApi", "query":"/instances/Cost_Component"},
            {"variable":"Report_ConstantApi", "query":"/instances/Report_Constant"},
            {"variable":"CurrencyApi", "query":"/instances/Currency"},
            {"variable":"TaxonomyApi", "query":"/instances/Taxonomy"},
            {"variable":"Taxonomy_TermApi", "query":"/instances/Taxonomy_Term"}
            ]
            }
    </eas:apiRequests>
    
    <xsl:variable name="apps" select="$Composite_Application_ProviderApi//simple_instance union $Application_ProviderApi//simple_instance"/>
    <xsl:variable name="approles" select="$Application_Provider_RoleApi//simple_instance[name=$apps/own_slot_value[slot_reference='provides_application_services']/value]"/>
    
	<xsl:variable name="appservices" select="$Application_ServiceApi//simple_instance"/>
	<xsl:variable name="lifecycleStatus" select="$Lifecycle_StatusApi//simple_instance"/>  
	<xsl:variable name="appInterface" select="$APU-TO-APU-STATIC-RELATIONApi//simple_instance"/>
    <xsl:variable name="codebaseStatus" select="$Codebase_StatusApi//simple_instance"/>
    <xsl:variable name="physicalProcesses" select="$APP_PRO_TO_PHYS_BUS_RELATIONApi//simple_instance"/>  
     <xsl:variable name="physProcesses" select="$Physical_ProcessApi//simple_instance"/>  
    <xsl:variable name="busProcesses" select="$Business_ProcessApi//simple_instance"/>  
    <xsl:variable name="inScopeBusCaps" select="$Business_CapabilityApi//simple_instance[name=$busProcesses/own_slot_value[slot_reference='realises_business_capability']/value]"/> 
    
    <xsl:variable name="inScopeCosts" select="$CostApi//simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $apps/name]"/>
	<xsl:variable name="inScopeCostComponents" select="$Cost_ComponentApi//simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
    <xsl:variable name="currencyType" select="$Report_ConstantApi//simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="$CurrencyApi//simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>
    <xsl:variable name="manualDataEntry" select="$appInterface[own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/>
    <xsl:variable name="allAppStaticUsages" select="$Static_Application_Provider_UsageApi//simple_instance"/>
    <xsl:key name="static_usage_key" match="$allAppStaticUsages" use="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
 
	<!--<xsl:variable name="allInboundStaticAppRels" select="$APU-TO-APU-STATIC-RELATIONApi//simple_instance[(own_slot_value[slot_reference = ':FROM']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
	<xsl:variable name="allOutboundStaticAppRels" select="$APU-TO-APU-STATIC-RELATIONApi//simple_instance[(own_slot_value[slot_reference = ':TO']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
    -->
    <xsl:variable name="busDifferentiationLevelTaxonomy" select="$TaxonomyApi//simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Business Differentiation Level')]"/>
	<xsl:variable name="busDifferentiationLevels" select="$Taxonomy_TermApi//simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $busDifferentiationLevelTaxonomy/name]"/>
	<xsl:variable name="differentiatingLevel" select="$busDifferentiationLevels[own_slot_value[slot_reference = 'name']/value = 'Differentiator']"/>
    <xsl:variable name="isAuthzForCostClasses" select="eas:isUserAuthZClasses(('Cost', 'Cost_Component'))"/><xsl:variable name="isAuthzForCostInstances" select="eas:isUserAuthZInstances($inScopeCosts)"/>
	
	<xsl:key name="services_key" match="/node()/simple_instance[type=('Application_Service')]" use="own_slot_value[slot_reference = 'provides_application_services']/value"/>
    
    <xsl:key name="fromapu_key" match="$appInterface" use="own_slot_value[slot_reference = ':FROM']/value"/>
    <xsl:key name="toapu_key" match="$appInterface" use="own_slot_value[slot_reference = ':TO']/value"/>
    <xsl:variable name="allInboundStaticAppRels2" select="key('fromapu_key', $allAppStaticUsages/name)"/>
    <xsl:variable name="allOutboundStaticAppRels2" select="key('toapu_key', $allAppStaticUsages/name)"/>
    <xsl:variable name="allInboundStaticAppRels" select="$allInboundStaticAppRels2[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/> 
    <xsl:variable name="allOutboundStaticAppRels" select="$allOutboundStaticAppRels2[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/> 
   
	
    
	<xsl:template match="knowledge_base">
        {
			 "applications": [<xsl:apply-templates select="$apps[position()&lt;100]" mode="getAppJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		 	"services":[<xsl:apply-templates select="$appservices" mode="getServJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
             "codebase":[<xsl:apply-templates select="$codebaseStatus" mode="selectJSON"><xsl:sort select="own_slot_value[slot_reference='enumeration_value']/value" order="ascending"/></xsl:apply-templates>],
        
           
            "currency":"<xsl:value-of select="$currency"/>"
        }
		
	</xsl:template>
	
	<xsl:template match="node()" mode="getAppJSON"><xsl:variable name="codeBase" select="current()/own_slot_value[slot_reference = 'ap_codebase_status']/value"/><xsl:variable name="lifecycle" select="current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value"/><xsl:variable name="aprsForApp" select="$approles[name = current()/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
	<xsl:variable name="topApp" select="current()"/>
		<xsl:variable name="subApps" select="$apps[name = $topApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
		<xsl:variable name="subSubApps" select="$apps[name = $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
		<xsl:variable name="allCurrentApps" select="$topApp union $subApps union $subSubApps"/>

        
        <xsl:variable name="appStaticUsages" select="key('static_usage_key', current()/name)"/>

        <xsl:variable name="appInboundStaticAppRels2" select="key('fromapu_key', $appStaticUsages/name)"/>
        <xsl:variable name="appOutboundStaticAppRels2" select="key('toapu_key', $appStaticUsages/name)"/>
        <xsl:variable name="appInboundStaticAppRels" select="$appInboundStaticAppRels2[not(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/> 
        <xsl:variable name="appOutboundStaticAppRels" select="$appOutboundStaticAppRels2[not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/> 
        <xsl:variable name="appInboundDepCount" select="count($appInboundStaticAppRels)"/>
        <xsl:variable name="appOutboundDepCount" select="count($appOutboundStaticAppRels)"/>

		<xsl:variable name="appIntegrationComplexityScore" select="eas:get_integration_complexity_score($appInboundDepCount, $appOutboundDepCount)"/>
		<xsl:variable name="appIntegrationComplexityValue" select="$appInboundDepCount + $appOutboundDepCount"/>
 		<xsl:variable name="thiscodebase" select="$codebaseStatus[name=$codeBase]"/>
		{ 
		"children":[<xsl:for-each select="$allCurrentApps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"inboundIntegrations":"<xsl:value-of select="$appInboundDepCount"/>",
		"outboundIntegrations":"<xsl:value-of select="$appOutboundDepCount"/>",
		"totalIntegrations":"<xsl:value-of select="$appInboundDepCount+$appOutboundDepCount"/>",
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())">,</xsl:if></xsl:template>

    <xsl:template match="node()" mode="getAppJSONservices">
		<xsl:variable name="this" select="eas:getSafeJSString(current()/name)"/>services_key
		<xsl:variable name="thisserv" select="key('services_key',current()/name)"/>  
		<!--<xsl:variable name="thisserv" select="$appservices[own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $this]"/> -->
		<xsl:if test="$thisserv/own_slot_value[slot_reference = 'name']/value"> {"serviceId":"<xsl:value-of select="eas:getSafeJSString($thisserv/name)"/>","service":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","service":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$thisserv"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		  </xsl:call-template>"}<xsl:if test="not(position() = last())">,</xsl:if>
		</xsl:if>
	</xsl:template>

<xsl:template match="node()" mode="getServJSON"> {"serviceId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","service":"<xsl:call-template name="RenderMultiLangInstanceName">
  <xsl:with-param name="theSubjectInstance" select="current()"/>
  <xsl:with-param name="isForJSONAPI" select="true()"/>
</xsl:call-template>" , 
 "applications":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if> </xsl:template>
	
    <xsl:template match="node()" mode="getServJSONapps">
		<xsl:variable name="this" select="eas:getSafeJSString(current()/name)"/>
		<xsl:variable name="thisapp" select="$apps[own_slot_value[slot_reference = 'provides_application_services']/value = $this]"/>{"application":"<xsl:call-template name="RenderMultiLangInstanceName">
  <xsl:with-param name="theSubjectInstance" select="$thisapp"/>
  <xsl:with-param name="isForJSONAPI" select="true()"/>
</xsl:call-template><xsl:if test="not($thisapp)">Unknown</xsl:if>","id":"<xsl:value-of select="eas:getSafeJSString($thisapp/name)"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
 
	
	<xsl:template match="node()" mode="codebase_select">
		<xsl:variable name="this" select="translate(current()/own_slot_value[slot_reference='enumeration_value']/value,' ','')"/>
        <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
		<option id="{$this}" name="{$this}" value="{$thisid}" onchange="updateCards()">			
			<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>
        </option>
	</xsl:template>
	
    
    <xsl:template match="node()" mode="getOptions">
         <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
        <xsl:variable name="this"><xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template></xsl:variable>
        <option name="{$thisid}" value="{$thisid}"><xsl:value-of select="$this"/></option>
    
    </xsl:template>
     <xsl:template match="node()" mode="getServOptions">
         <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
        <xsl:variable name="this"><xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template></xsl:variable>
        <option name="{$thisid}" value="{$this}"><xsl:value-of select="$this"/></option>
    
    </xsl:template>
        
    	<xsl:function name="eas:get_inbound_int_count" as="xs:integer">
        <xsl:param name="app"/>
        <xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>
	    <xsl:variable name="appInboundStaticAppRels" select="$allInboundStaticAppRels[(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name)]"/>
    	<xsl:variable name="appInboundStaticAppUsages" select="$allAppStaticUsages[name = $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="appInboundStaticApps" select="$apps[name = $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		<xsl:variable name="inboundRelCount" select="count($appInboundStaticApps)"/>

		<xsl:value-of select="$inboundRelCount"/>

	</xsl:function>

	<xsl:function name="eas:get_outbound_int_count" as="xs:integer">
        <xsl:param name="app"/>
        <xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>
	   <xsl:variable name="appOutboundStaticAppRels" select="$allOutboundStaticAppRels[(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name)]"/>
 
        <xsl:variable name="appOutboundStaticAppUsages" select="$allAppStaticUsages[name = $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value]"/>
       	<xsl:variable name="appOutboundStaticApps" select="$apps[name = $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		<xsl:variable name="outboundRelCount" select="count($appOutboundStaticApps)"/>

		<xsl:value-of select="$outboundRelCount"/>

	</xsl:function>

	<xsl:function name="eas:get_integration_complexity_score" as="xs:integer">
		<xsl:param name="inboundRelCount"/>
		<xsl:param name="outboundRelCount"/>

		<xsl:variable name="totalRelCount" select="$inboundRelCount + $outboundRelCount"/>

		<xsl:variable name="appIntComplexityScore">
			<xsl:choose>
				<xsl:when test="$totalRelCount >= 10">10</xsl:when>
				<xsl:when test="$totalRelCount >= 6">7</xsl:when>
				<xsl:when test="$totalRelCount >= 3">5</xsl:when>
				<xsl:when test="$totalRelCount >= 1">3</xsl:when>
				<xsl:when test="$totalRelCount = 0">1</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="number($appIntComplexityScore)"/>

	</xsl:function>
    
    <xsl:function name="eas:get_business_value_score" as="xs:integer">
		<xsl:param name="differentiatingBusCapCount"/>

		<xsl:variable name="busValueScore">
			<xsl:choose>
				<xsl:when test="$differentiatingBusCapCount >= 3">10</xsl:when>
				<xsl:when test="$differentiatingBusCapCount = 2">7</xsl:when>
				<xsl:when test="$differentiatingBusCapCount = 1">4</xsl:when>
				<xsl:when test="$differentiatingBusCapCount = 0">1</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="number($busValueScore)"/>

	</xsl:function> 

	<xsl:template match="node()" mode="selectJSON">
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>"<!--,
			"enumeration":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value">"-->,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
</xsl:stylesheet>
