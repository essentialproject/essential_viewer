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
	<xsl:key name="appsTypekey" match="node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]" use="type"/>

    <xsl:variable name="apps" select="key('appsTypekey', ('Application_Provider', 'Composite_Application_Provider'))"/>
	<xsl:key name="appsNamekey" match="$apps" use="name"/>
	<xsl:key name="appskey" match="$apps" use="own_slot_value[slot_reference='provides_application_services']/value"/>
    <xsl:key name="approlesKey" match="node()/simple_instance[type = 'Application_Provider_Role']" use="own_slot_value[slot_reference = 'implementing_application_service']/value"/>
	<xsl:key name="approlesbyappKey" match="node()/simple_instance[type = 'Application_Provider_Role']" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/> 
	
	<xsl:key name="appservicesTypeKey" match="node()/simple_instance[type = 'Application_Service']" use="type"/>
	<xsl:variable name="appservices" select="key('appservicesTypeKey', 'Application_Service')"/>
	<xsl:key name="appservicesKey" match="$appservices" use="own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/> 
    <xsl:variable name="codebaseStatus" select="node()/simple_instance[type = 'Codebase_Status']"/>
	
	<xsl:key name="appsproPhysBusTypeKey" match="node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="type"/>
	<xsl:variable name="appsproPhysBus" select="key('appsproPhysBusTypeKey', 'APP_PRO_TO_PHYS_BUS_RELATION')"/>
	<xsl:key name="approlesPPKey" match="$appsproPhysBus" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
	
	<xsl:key name="physical_ProcessTypeKey" match="node()/simple_instance[type = 'Physical_Process']" use="type"/> 

     <xsl:variable name="physProcesses" select="key('physical_ProcessTypeKey', 'Physical_Process')"/>  
	 <xsl:key name="physicalProcessesToAPRKey" match="$physProcesses" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
 
	 <xsl:key name="physProcessesAppKey" match="$physProcesses" use="own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value"/>
    <xsl:variable name="busProcesses" select="node()/simple_instance[type = 'Business_Process']"/>  
	<xsl:key name="busProcessesKey" match="$busProcesses" use="own_slot_value[slot_reference='implemented_by_physical_business_processes']/value"/>
 
	<xsl:key name="busCapTypeKey" match="node()/simple_instance[type = 'Business_Capability']" use="type"/> 

	<xsl:variable name="busCaps" select="key('busCapTypeKey', 'Business_Capability')"/>  

	<xsl:key name="inScopeBusCapsKey" match="$busCaps" use="own_slot_value[slot_reference='realised_by_business_processes']/value"/> 
	<xsl:key name="busCapsClassKey" match="$busCaps" use="own_slot_value[slot_reference='element_classified_by']/value"/>  
    
	 <xsl:key name="inScopeCostsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	 <xsl:variable name="inScopeCosts" select="key('inScopeCostsKey',$apps/name)"/>
 
	<xsl:key name="inScopeCostComponentsKey" match="/node()/simple_instance[supertype='Cost_Component']" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>

    <xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>
    <xsl:variable name="manualDataEntry" select="/node()/simple_instance[type='Data_Acquisition_Method'][own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/>
    <xsl:variable name="busDifferentiationLevelTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Business Differentiation Level')]"/>
	<xsl:key name="busDiffTaxKey" match="/node()/simple_instance[supertype='Taxonomy_Term']" use="own_slot_value[slot_reference = 'term_in_taxonomy']/value"/>
	<xsl:variable name="busDifferentiationLevels" select="key('busDiffTaxKey',$busDifferentiationLevelTaxonomy/name)"/>
	<xsl:variable name="differentiatingLevel" select="$busDifferentiationLevels[own_slot_value[slot_reference = 'name']/value = 'Differentiator']"/>
	<xsl:variable name="isAuthzForCostClasses" select="eas:isUserAuthZClasses(('Cost', 'Cost_Component'))"/><xsl:variable name="isAuthzForCostInstances" select="eas:isUserAuthZInstances($inScopeCosts)"/>
	<xsl:variable name="fteRate" select="node()/simple_instance[type = 'Report_Constant'][own_slot_value[slot_reference='name']/value='Default FTE Rate']"/>

	<xsl:template match="knowledge_base">
		{
			"applications": [<xsl:apply-templates select="$apps" mode="getAppJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"services":[<xsl:apply-templates select="$appservices" mode="getServJSON"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"codebase":[<xsl:apply-templates select="$codebaseStatus" mode="selectJSON"><xsl:sort select="own_slot_value[slot_reference='enumeration_value']/value" order="ascending"/></xsl:apply-templates>],
			"currency":"<xsl:value-of select="$currency"/>"
        }
		
	</xsl:template>
	
	<xsl:template match="node()" mode="getAppJSON">
	<xsl:variable name="codeBase" select="current()/own_slot_value[slot_reference = 'ap_codebase_status']/value"/>
	<xsl:variable name="lifecycle" select="current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value"/>
	<!--<xsl:variable name="aprsForApp" select="$approles[name = current()/own_slot_value[slot_reference = 'provides_application_services']/value]"/>-->
	<!--<xsl:variable name="aprsForApp" select="key('approlesKey', current()/name)"/> -->
	<xsl:variable name="aprsforapp" select="key('approlesbyappKey',current()/name)"/>
	<!--<xsl:variable name="totalProcesses" select="$physicalProcesses[name=$aprsforapp/own_slot_value[slot_reference='app_pro_role_supports_phys_proc']/value]"/> -->
	<xsl:variable name="totalProcesses" select="key('approlesPPKey',$aprsforapp/name)"/> 
	
    <!--<xsl:variable name="thisappCosts" select="$inScopeCosts[own_slot_value[slot_reference = 'cost_for_elements']/value = current()/name]"/>-->
	
	<xsl:variable name="thisappCosts" select="key('inScopeCostsKey',current()/name)"/>
	<!--<xsl:variable name="directProcessToAppRelation" select="$physicalProcesses[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value=current()/name]"></xsl:variable>-->
	<xsl:variable name="directProcessToAppRelation" select="key('physicalProcessesToAPRKey',current()/name)"></xsl:variable>
	
	<!--
		<xsl:variable name="directProcessToAppProcess" select="$physProcesses[own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$directProcessToAppRelation/name]"></xsl:variable>
		<xsl:variable name="thisPhysProcessesAPR" select="$physProcesses[own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$totalProcesses/name]"/> 
	-->
	<xsl:variable name="directProcessToAppProcess" select="key('physProcessesAppKey',$directProcessToAppRelation/name)"></xsl:variable>
	<xsl:variable name="thisPhysProcessesAPR" select="key('physProcessesAppKey',$totalProcesses/name)"></xsl:variable>
		
		<xsl:variable name="thisPhysProcesses" select="$thisPhysProcessesAPR union $directProcessToAppProcess"/> 
<!--
        <xsl:variable name="inScopeCostComponents" select="$inScopeCostComponents[name = $thisappCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>-->
		<xsl:variable name="inScopeCostComponents" select="key('inScopeCostComponentsKey',$thisappCosts/name)"/>
		
        <xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($inScopeCostComponents, 0)"/>

	 	 <xsl:variable name="appLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable> 
    <!-- Get the business value score -->
    <!--    <xsl:variable name="thisBusProcs2" select="$busProcesses[name = $thisPhysProcesses/own_slot_value[slot_reference = 'implements_business_process']/value]"/>-->
		<xsl:variable name="thisBusProcs" select="key('busProcessesKey',$thisPhysProcesses/name)"/>  
	<!--	<xsl:variable name="thisBusCaps" select="$inScopeBusCaps[name = $thisBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>-->
		<xsl:variable name="thisBusCaps" select="key('inScopeBusCapsKey',$thisBusProcs/name)"/>
		
	<!--	<xsl:variable name="differentiatingBusCaps" select="$thisBusCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $differentiatingLevel/name]"/>-->
		<xsl:variable name="differentiatingBusCaps" select="key('busCapsClassKey',$differentiatingLevel/name)"/>
		
		<xsl:variable name="appBusValueScore" select="eas:get_business_value_score(count($differentiatingBusCaps))"/>
		<xsl:variable name="appBusValueValue" select="count($differentiatingBusCaps)"/>    
  
        {
 
"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"services":[<xsl:apply-templates select="$aprsforapp" mode="getAppJSONservices"/>],
"aprs":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'provides_application_services']/value">{"id":"<xsl:value-of select="."/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
"overlappingApplications":[<xsl:apply-templates select="$aprsforapp" mode="getAppOverlapServices"><xsl:with-param name="focusapp" select="current()"/></xsl:apply-templates>],
"processList":[<xsl:for-each select="$thisBusProcs">{<xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
}" />
<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>], 
"processesSupporting":"<xsl:value-of select="count($thisPhysProcesses)"/>"
  <xsl:choose><xsl:when test="not($isAuthzForCostClasses) or not($isAuthzForCostInstances)"></xsl:when><xsl:otherwise>,"cost":"<xsl:value-of select="$costTypeTotal"/>"</xsl:otherwise></xsl:choose>
  ,"capsCount":"<xsl:value-of select="count($thisBusCaps)-$appBusValueValue"/>",
  "capsScore":"<xsl:value-of select="$appBusValueScore"/>",
  "capsValue":"<xsl:value-of select="$appBusValueValue"/>",
 
  <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
}<xsl:if test="not(position() = last())">,</xsl:if></xsl:template>

    <xsl:template match="node()" mode="getAppJSONservices">
		<xsl:variable name="this" select="eas:getSafeJSString(current()/name)"/>
	<!--	<xsl:variable name="thisserv" select="$appservices[own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $this]"/> -->
		<xsl:variable name="thisserv" select="key('appservicesKey',$this)"/>
     <!--   <xsl:variable name="thisPhysProcessesRel" select="$physicalProcesses[own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value=$this]"/> -->
		<xsl:variable name="thisPhysProcessesRel" select="key('physicalProcessesToAPRKey',$this)"/>
		
	<!--	<xsl:variable name="thisPhysProcesses" select="$physProcesses[own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value=$thisPhysProcessesRel/name]"/>-->
		<xsl:variable name="thisPhysProcesses" select="key('physProcessesAppKey',$thisPhysProcessesRel/name)"/>
		<!--
        <xsl:variable name="thisBusProcesses" select="$busProcesses[name=$thisPhysProcesses/own_slot_value[slot_reference='implements_business_process']/value]"/>-->
		<xsl:variable name="thisBusProcesses" select="key('busProcessesKey',$thisPhysProcesses/name)"/>
		
 		{"serviceId":"<xsl:value-of select="eas:getSafeJSString($thisserv/name)"/>",
		 <xsl:variable name="combinedMap" as="map(*)" select="map{
            'service': string(translate(translate($thisserv/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "processes":[<xsl:apply-templates select="$thisBusProcesses" mode="getAppJSONprocesses"/>]}<xsl:if test="not(position() = last())">,</xsl:if>
		 
	</xsl:template>
	
	<xsl:template match="node()" mode="getAppOverlapServices">
		<xsl:param name="focusapp"/>
		<xsl:variable name="this" select="eas:getSafeJSString(current()/name)"/>
		<!--<xsl:variable name="thisserv" select="$appservices[own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $this]"/>-->
		<xsl:variable name="thisserv" select="key('appservicesKey',$this)"/>
	<!--	<xsl:variable name="thisaprs" select="$approles[name=$thisserv/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value]"/> -->
		<xsl:variable name="thisaprs" select="key('approlesKey', $thisserv/name)"/>
	 <xsl:variable name="appsMapped" select="key('appskey',$thisaprs/name )"/> 
		{ 
		"id":"<xsl:value-of select="eas:getSafeJSString($thisserv/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate($thisserv/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"apps":[
        <xsl:for-each select="$thisaprs/own_slot_value[slot_reference = 'role_for_application_provider']/value">{
			"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
        <!--
		<xsl:for-each select="$appsMapped">
			{
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())">,</xsl:if>
	
		</xsl:for-each>-->
		]}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

    <xsl:template match="node()" mode="getAppJSONprocesses">
		<xsl:variable name="this" select="current()"/>{"process":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'service': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="getServJSON"><xsl:variable name="thisaprs" select="key('approlesKey', current()/name)"/> {"serviceId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
		'service': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "applications":[<xsl:apply-templates select="$thisaprs" mode="getServJSONapps"/>]}<xsl:if test="not(position() = last())">,</xsl:if> </xsl:template>
	
    <xsl:template match="node()" mode="getServJSONapps">
		<xsl:variable name="this" select="eas:getSafeJSString(current()/name)"/> 
		<xsl:variable name="thisapp" select="key('appskey',$this )"/> 
		{ "id":"<xsl:value-of select="eas:getSafeJSString($thisapp/name)"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
 
	
	<xsl:template match="node()" mode="codebase_select">
		<xsl:variable name="this" select="translate(current()/own_slot_value[slot_reference='enumeration_value']/value,' ','')"/>
        <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
		<option id="{$this}" name="{$this}" value="{$thisid}" onchange="updateCards()">			
			<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>
        </option>
	</xsl:template>
	
    <xsl:function as="xs:float" name="eas:get_cost_components_total">
        <xsl:param name="costComponents"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="count($costComponents) > 0">
                <xsl:variable name="nextCost" select="$costComponents[1]"/>
                <xsl:variable name="newCostComponents" select="remove($costComponents, 1)"/>
                <xsl:variable name="costAmount" select="$nextCost/own_slot_value[slot_reference='cc_cost_amount']/value"/>
                <xsl:choose>
                    <xsl:when test="$costAmount > 0">
                        <xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total + number($costAmount))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
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
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template><!--,
			"enumeration":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value">"-->}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
</xsl:stylesheet>
