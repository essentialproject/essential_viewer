<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
  <xsl:variable name="techClass" select="/node()/class[name = ('Technology_Provider','Technology_Product')]" />
<xsl:variable name="techSlots" select="/node()/slot[name = $techClass/template_slot]" /> 
<xsl:variable name="parentEnumClass" select="/node()/class[superclass = 'Enumeration']" />
<xsl:variable name="subEnumClass" select="/node()/class[superclass = $parentEnumClass/name]" />
<xsl:variable name="enumClass" select="$parentEnumClass union $subEnumClass" />
<xsl:variable name="targetSlots" select="$techSlots/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value[2]"/>
<xsl:variable name="alltechSlotsBoo" select="$techSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value='Boolean']"/> 
<xsl:variable name="alltechSlots" select="$techSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=$enumClass/name]"/> 
<xsl:variable name="allEnumClass" select="$enumClass[name=$targetSlots]"/> 

  <xsl:variable name="techComponents" select="/node()/simple_instance[type='Technology_Component']"/>
  <xsl:variable name="techCapabilities" select="/node()/simple_instance[type='Technology_Capability']"/>
    <xsl:variable name="suppliers" select="/node()/simple_instance[type='Supplier']"/>  
  <xsl:variable name="techProducts" select="/node()/simple_instance[type='Technology_Product']"/> 
 <xsl:variable name="techProdFams" select="/node()/simple_instance[type='Technology_Product_Family']"/>
 <xsl:key name="techProdFamsKey" match="/node()/simple_instance[type='Technology_Product_Family']" use="own_slot_value[slot_reference='groups_technology_products']/value"/>
    <xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
   <xsl:variable name="techDeliveryModel" select="/node()/simple_instance[type='Technology_Delivery_Model']"/>
  <xsl:variable name="tprs" select="/node()/simple_instance[type = 'Technology_Product_Role']"/> 
  <xsl:key name="tprsKey" match="/node()/simple_instance[type = 'Technology_Product_Role']" use="own_slot_value[slot_reference='role_for_technology_provider']/value"/> 
  <xsl:variable name="techStandards" select="/node()/simple_instance[type='Technology_Provider_Standard_Specification']"/>
  <xsl:variable name="enumsStandards" select="/node()/simple_instance[type='Standard_Strength']"/> 
 <xsl:variable name="techlifecycle" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
 <xsl:key name="techCompKey" match="$techComponents" use="own_slot_value[slot_reference='realised_by_technology_products']/value"/>
 <xsl:key name="techStandardsKey" match="/node()/simple_instance[type='Technology_Provider_Standard_Specification']" use="own_slot_value[slot_reference='tps_standard_tech_provider_role']/value"/>
 <xsl:key name="techProductStandardsKey" match="/node()/simple_instance[type='Technology_Provider_Standard_Specification']" use="own_slot_value[slot_reference='tpr_has_standard_specs']/value"/> 
 <xsl:key name="actor2RoleKey" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="name"/> 
 <xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
 <xsl:key name="roles_key" match="/node()/simple_instance[type='Individual_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
 <xsl:key name="grpactors_key" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
 <xsl:key name="grproles_key" match="/node()/simple_instance[type='Group_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
 <!-- costs -->
 <xsl:key name="inScopeCostsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
 <xsl:key name="inScopeCostComponentKey" match="/node()/simple_instance[type=('Adhoc_Cost_Component','Annual_Cost_Component','Monthly_Cost_Component','Quarterly_Cost_Component')]" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>
 <xsl:variable name="costType" select="/node()/simple_instance[(type = 'Cost_Component_Type')]"/>
 <xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
 <xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
  <xsl:variable name="costCategory" select="/node()/simple_instance[(type = 'Cost_Category')]"/>
  <xsl:key name="costForCat_key" match="/node()/simple_instance[type=('Cost')]" use="own_slot_value[slot_reference = 'cost_components']/value"/>
  <xsl:variable name="allCurrency" select="/node()/simple_instance[(type = 'Currency')]"/>
  <xsl:key name="allDocs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
  <xsl:key name="allTaxTerms_key" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
  <xsl:key name="allFunctions_key" match="/node()/simple_instance[type = 'Technology_Function']" use="name"/> 
  <xsl:key name="tech_prod_usage" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference='provider_as_role']/value"/>  
  <xsl:key name="tech_build" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="name"/> 
  <xsl:key name="tpaRelation" match="/node()/simple_instance[supertype = ':TPA-RELATION']" use="name"/> 
  <xsl:key name="tech_prod_usagename" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="name"/> 
  <xsl:key name="tech_instance" match="/node()/simple_instance[supertype = 'Technology_Instance']" use="name"/> 
  <xsl:key name="store_instance" match="/node()/simple_instance[type = 'Information_Store_Instance']" use="name"/> 
  <xsl:key name="info_store" match="/node()/simple_instance[type = 'Information_Store']" use="name"/> 
  <xsl:key name="info_rep" match="/node()/simple_instance[type = 'Information_Representation']" use="name"/>  
  <xsl:key name="tech_node" match="/node()/simple_instance[type = 'Technology_Node']" use="name"/> 
  <xsl:variable name="deployments" select="/node()/simple_instance[(type = 'Deployment_Status')]"/>
  <xsl:variable name="techfucntype" select="/node()/simple_instance[(type = 'Technology_Function_Type')]"/> 
  <xsl:key name="a2rname_key" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
  <xsl:key name="actorNameKey" match="simple_instance[type=('Group_Actor')]" use="name" />
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
     "tprStandards":[<xsl:apply-templates select="$tprs" mode="techStds"></xsl:apply-templates>],
     "ccy":[<xsl:apply-templates mode="renderCurrencies" select="$allCurrency">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>],
      "filters":[<xsl:apply-templates select="$allEnumClass" mode="createFilterJSON"></xsl:apply-templates><xsl:if test="$alltechSlotsBoo">,<xsl:apply-templates select="$alltechSlotsBoo" mode="createBooleanFilterJSON"></xsl:apply-templates></xsl:if>],"version":"620"}
	</xsl:template>


   <xsl:template mode="techProducts" match="node()">
   <xsl:variable name="thisProduct" select="current()"/>
    <xsl:variable name="thissupplier" select="$suppliers[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
   <!-- <xsl:variable name="thisfamily2" select="$techProdFams[name=current()/own_slot_value[slot_reference='member_of_technology_product_families']/value]"/>-->
    <xsl:variable name="thisfamily" select="key('techProdFamsKey', current()/name)"/>
    <xsl:variable name="thisStakeholders" select="key('actor2RoleKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>     
    <xsl:variable name="thislifecycle" select="$techlifecycle[name=current()/own_slot_value[slot_reference='vendor_product_lifecycle_status']/value]"/>   
    <xsl:variable name="thisdelivery" select="$techDeliveryModel[name=current()/own_slot_value[slot_reference='technology_provider_delivery_model']/value]"/>
   <!-- <xsl:variable name="thisusages2" select="$tprs[name=current()/own_slot_value[slot_reference='implements_technology_components']/value]"/>-->
    <xsl:variable name="thisusages" select="key('tprsKey',current()/name)"/>
    <xsl:variable name="inScopeCosts" select="key('inScopeCostsKey',current()/name)"/>
		<xsl:variable name="inScopeCostComponents" select="key('inScopeCostComponentKey',$inScopeCosts/name)"/>
		<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
    <xsl:variable name="thisFunctions" select="key('allFunctions_key', current()/own_slot_value[slot_reference = 'technology_product_functions_offered']/value)"/>
    <xsl:variable name="thisInstances" select="key('tech_instance', current()/own_slot_value[slot_reference = 'technology_provider_instances']/value)"/>
   <xsl:variable name="thisOrgUsers2Roles" select="key('a2rname_key',current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
    <xsl:variable name="thisOrgUserIds" select="key('actorNameKey', $thisOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
    <xsl:variable name="eaScopedOrgUserIds" select="key('actorNameKey', current()/own_slot_value[slot_reference = 'ea_scope']/value)"/>
    <xsl:variable name="allOrgUserIds" select="distinct-values($eaScopedOrgUserIds/name union $thisOrgUserIds/name)"/> 

		{
      <xsl:variable name="combinedMap" as="map(*)" select="map{
				'id': string(translate(translate(current()/name, '}', ')'), '{', ')')),
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
        'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
        'supplier': string(translate(translate($thissupplier/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
        'vendor': string(translate(translate($thissupplier/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
        'lifecycle': string(translate(translate($thislifecycle/own_slot_value[slot_reference = ('enumeration_value')]/value, '}', ')'), '{', ')')),
        'delivery': string(translate(translate($thisdelivery/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
        'technology_provider_version': string(translate(translate(current()/own_slot_value[slot_reference = ('technology_provider_version')]/value, '}', ')'), '{', ')'))
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<!-- Extract and Output the Values -->
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
      "visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
      "orgUserIds": [<xsl:for-each select="$allOrgUserIds">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
      "costs":[<xsl:for-each select="$inScopeCostComponents"> 
				<xsl:variable name="parentCost" select="key('costForCat_key',current()/name)"/>
				<xsl:variable name="costCat" select="$costCategory[name=$parentCost/own_slot_value[slot_reference='cost_category']/value]"/>
				<xsl:variable name="thisCostCurrency" select="$allCurrency[name=current()/own_slot_value[slot_reference='cc_cost_currency']/value]"/>
        <xsl:variable name="parentCostCurrency" select="$allCurrency[name=$parentCost/own_slot_value[slot_reference='cost_currency']/value]"/><!-- USE component currrency if exists then parent cost currency or default currency-->
						{"name":"<xsl:value-of select="$costType[name=current()/own_slot_value[slot_reference='cc_cost_component_type']/value]/own_slot_value[slot_reference='name']/value"/>", 
            "id": "<xsl:value-of select="current()/name"/>",
						<xsl:variable name="temp" as="map(*)" select="map{'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))}"></xsl:variable>
						<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
						<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
						"cost":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_amount']/value"/>",
						"costType":"<xsl:value-of select="current()/type"/>",
						"ccy_code":"<xsl:choose><xsl:when test="$parentCostCurrency"><xsl:value-of select="$thisCostCurrency/own_slot_value[slot_reference='currency_code']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$currency/own_slot_value[slot_reference='currency_code']/value"/></xsl:otherwise></xsl:choose>",
            "component_currency":"<xsl:value-of select="$thisCostCurrency/own_slot_value[slot_reference='currency_symbol']/value"/>",
            "component_currency_code":"<xsl:choose><xsl:when test="$thisCostCurrency"><xsl:value-of select="$thisCostCurrency/own_slot_value[slot_reference='currency_code']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$currency/own_slot_value[slot_reference='currency_code']/value"/></xsl:otherwise></xsl:choose>",
						"currency":"<xsl:choose><xsl:when test="$parentCostCurrency"><xsl:value-of select="$parentCostCurrency/own_slot_value[slot_reference='currency_symbol']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/></xsl:otherwise></xsl:choose>",
						<xsl:if test="$costCat"> 
						"costCategory":"<xsl:value-of select="$costCat/own_slot_value[slot_reference='enumeration_value']/value"/>",
						</xsl:if>
						"fromDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_start_date_iso_8601']/value"/>",
						"toDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_end_date_iso_8601']/value"/>",
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position()=last())">,</xsl:if>           
					</xsl:for-each>],
        "family":[<xsl:for-each select="$thisfamily">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
          'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
        }"></xsl:variable>
        <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
        <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
        "functions":[<xsl:for-each select="$thisFunctions">
        <xsl:variable name="funcType" select="$techfucntype[name=current()/own_slot_value[slot_reference = ('realisation_of_function_type')]/value]"/>  
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
          'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
          'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
          'functiontype': string(translate(translate($funcType/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
          
        }"></xsl:variable>
        <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
        <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
      "instances":[<xsl:for-each select="$thisInstances">
          <xsl:variable name="runtime" select="$deployments[name=current()/own_slot_value[slot_reference = ('technology_instance_deployment_status')]/value]"/>
          <xsl:variable name="node" select="key('tech_node', current()/own_slot_value[slot_reference = ('technology_instance_deployed_on_node')]/value)"/>
          <xsl:variable name="infoStoreInstances" select="key('store_instance', current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value)"/>
          {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
          <xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
            'runtime_status': string(translate(translate($runtime/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
            'node': string(translate(translate($node/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
          }"></xsl:variable>
          <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
          <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
          "infoStores":[<xsl:for-each select="$infoStoreInstances">
            <xsl:variable name="runtime" select="$deployments[name=current()/own_slot_value[slot_reference = ('technology_instance_deployment_status')]/value]"/>  
            <xsl:variable name="infoStore" select="key('info_store', current()/own_slot_value[slot_reference = ('instance_of_information_store')]/value)"/>
            <xsl:variable name="infoRep" select="key('info_rep', $infoStore/own_slot_value[slot_reference = ('deployment_of_information_representation')]/value)"/>
            {
            <xsl:variable name="combinedMap" as="map(*)" select="map{
              'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
              'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
              'runtime_status': string(translate(translate($runtime/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
              'store': string(translate(translate($infoStore/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
            }"></xsl:variable>
            <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
            <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
            "infoRep":{<xsl:variable name="combinedinfoRepMap" as="map(*)" select="map{
              'name': string(translate(translate($infoRep/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
              'description': string(translate(translate($infoRep/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
              'id': string(translate(translate($infoRep/name, '}', ')'), '{', ')')),
              'className': 'Information_Representation'
            }"></xsl:variable>
            <xsl:variable name="inforesult" select="serialize($combinedinfoRepMap, map{'method':'json', 'indent':true()})"/>
            <xsl:value-of select="substring-before(substring-after($inforesult, '{'), '}')"/>},
            <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template> 
            }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
            <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template> 
        }<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>],
        "usages":[<xsl:for-each select="$thisusages">
          <xsl:variable name="complianceStd" select="key('techStandardsKey',current()/name)"/>
          <xsl:variable name="componentsUsed" select="key('techCompKey', current()/name)"/>
          <xsl:variable name="tpu" select="key('tech_prod_usage', current()/name)"/>
          <xsl:variable name="thistechbuild" select="key('tech_build', $tpu/own_slot_value[slot_reference='used_in_technology_provider_architecture']/value)"/>
          {"id":"<xsl:value-of select="eas:getSafeJSString($componentsUsed/name)"/>",
          "tprid":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
          "techArchitectures":[<xsl:for-each select="$thistechbuild">
            <xsl:variable name="tpa" select="key('tpaRelation', current()/own_slot_value[slot_reference='contained_provider_architecture_relations']/value)"/>
           
            {"prodUsages":[<xsl:for-each select="$tpa">
              <xsl:variable name="from" select="key('tech_prod_usagename', current()/own_slot_value[slot_reference=':FROM']/value)"/>
              <xsl:variable name="to" select="key('tech_prod_usagename', current()/own_slot_value[slot_reference=':TO']/value)"/>
             {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
              <xsl:variable name="combinedMap" as="map(*)" select="map{ 
                'fromname': string(translate(translate($from/own_slot_value[slot_reference = ('technology_architecture_display_label')]/value, '}', ')'), '{', ')')),
                'toname': string(translate(translate($to/own_slot_value[slot_reference = ('technology_architecture_display_label')]/value, '}', ')'), '{', ')'))
              }"></xsl:variable>
              <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
              <!-- Extract and Output the Values -->
              <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>}<xsl:if test="position()!=last()">,</xsl:if>
              </xsl:for-each>],
                "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
              <xsl:variable name="combinedMap" as="map(*)" select="map{ 
                'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
              }"></xsl:variable>
              <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
              <!-- Extract and Output the Values -->
              <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
              <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template> }<xsl:if test="position()!=last()">,</xsl:if>
          </xsl:for-each>],
        <xsl:variable name="combinedMap" as="map(*)" select="map{ 
          'name': string(translate(translate($componentsUsed/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
        }"></xsl:variable>
        <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
        <!-- Extract and Output the Values -->
        <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>, 
         <xsl:variable name="complianceStd" select="key('techStandardsKey',current()/name)"/>
    <xsl:variable name="thisenumsStandards" select="key('techProductStandardsKey', $complianceStd/name)"/>
        "stdid":"<xsl:value-of select="$complianceStd/name"/>",
        "compliance":"<xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=current()/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/>",
        "adoption":"<xsl:value-of select="$lifecycle[name=$thisusages[1]/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    "documents":[<xsl:for-each select="$thisDocs">
			<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
			{"id":"<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'documentLink': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
			"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
			"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
			"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>",
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>],		
        "stakeholders":[
					<xsl:for-each select="$thisStakeholders">
						{
						<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
						<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
						<xsl:variable name="thisgrpActors" select="key('grpactors_key',current()/name)"/>
						<xsl:variable name="thisgrpRoles" select="key('grproles_key',current()/name)"/>
						<xsl:variable name="allthisActors" select="$thisActors union $thisgrpActors"/>
						<xsl:variable name="allthisRoles" select="$thisRoles union $thisgrpRoles"/>
						"type": "<xsl:value-of select="$allthisActors/type"/>",
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'actor': string(translate(translate($allthisActors/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
							'role': string(translate(translate($allthisRoles/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
							}"/>
							<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
							<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
						"actorId":"<xsl:value-of select="$allthisActors/name"/>",  
						"roleId":"<xsl:value-of select="$allthisRoles/name"/>"
						}
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					],
           <xsl:for-each select="$alltechSlots"><xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="current()/name"/>":[<xsl:for-each select="$thisProduct/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>,	 
		<xsl:if test="$alltechSlotsBoo">
			<xsl:for-each select="$alltechSlotsBoo">
				<xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="current()/name"/>":[
				<xsl:choose>
					<xsl:when test="$thisProduct/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="$thisProduct/own_slot_value[slot_reference=$slt]/value"/>"
					</xsl:when>
					<xsl:otherwise>"none"</xsl:otherwise>
				</xsl:choose>
				]<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>,
		</xsl:if><xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
        }<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template> 
  <xsl:template mode="techStds" match="node()">
    <xsl:variable name="complianceStd" select="key('techStandardsKey',current()/name)"/>
      {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
      "compliance2":[<xsl:for-each select="$complianceStd">
      {"id":"<xsl:value-of select="eas:getSafeJSString($enumsStandards[name=current()/own_slot_value[slot_reference='sm_standard_strength']/value]/name)"/>",
      "name":"<xsl:value-of select="$enumsStandards[name=current()/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
      "geos":[<xsl:for-each select="current()/own_slot_value[slot_reference='sm_geographic_scope']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
      "orgs":[<xsl:for-each select="current()/own_slot_value[slot_reference='sm_organisational_scope']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
    }<xsl:if test="position()!=last()">,</xsl:if>
      </xsl:for-each>],
      "compliance":"<xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=current()/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/>",
        "adoption":{"id": "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='strategic_lifecycle_status']/value)"/>","name":"<xsl:value-of select="$lifecycle[name=current()/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>"}}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>      
  <xsl:template mode="renderCurrencies" match="node()">                           
	   {   "id": "<xsl:value-of select="current()/name"/>",
	   <xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"default":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_is_default']/value"/>",
			"exchangeRate":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_exchange_rate']/value"/>"	   
				   
		} <xsl:if test="not(position()=last())">,</xsl:if>
</xsl:template>
<xsl:template mode="createFilterJSON" match="node()">	
		<xsl:variable name="thisSlot" select="$techSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
		<xsl:variable name="releventEnums" select="/node()/simple_instance[type = current()/name]"/> 
		{"id": "<xsl:value-of select="current()/name"/>",
		"name": "<xsl:value-of select="translate(current()/name, '_',' ')"/>",
		"valueClass": "<xsl:value-of select="current()/name"/>",
		"description": "",
		"slotName":"<xsl:value-of select="$thisSlot/name"/>",
		"isGroup": false,
		"icon": "fa-circle",
		"color":"#93592f",
		"values": [
		<xsl:for-each select="$releventEnums"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'enum_name': string(translate(translate(current()/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
			'sequence': string(translate(translate(current()/own_slot_value[slot_reference = 'enumeration_sequence_number']/value, '}', ')'), '{', ')'))
            }"/>
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
       <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		 "backgroundColor":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
		"colour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]
		<!--,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>-->
	}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:template>	
		<xsl:template mode="createBooleanFilterJSON" match="node()">	
				<xsl:variable name="thisSlot" select="$techSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
				<xsl:variable name="releventEnums" select="/node()/simple_instance[type = current()/name]"/> 
				{"id": "<xsl:value-of select="current()/name"/>",
				"name": "<xsl:value-of select="translate(current()/name, '_',' ')"/>",
				"valueClass": "<xsl:value-of select="current()/name"/>",
				"description": "",
				"slotName":"<xsl:value-of select="current()/name"/>",
				"isGroup": false,
				"icon": "fa-circle",
				"color":"#93592f",
				"values": [{"id":"none", "name":"Not Set"},{"id":"true", "name":"True"},{"id":"false", "name":"False"} ]}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>			


</xsl:stylesheet>
