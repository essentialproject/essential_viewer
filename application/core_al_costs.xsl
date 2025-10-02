<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    
	<xsl:import href="../common/core_js_functions.xsl"/>  
 
	<!-- START GENERIC PARAMETERS -->

	<!-- END GENERIC PARAMETERS -->
	<xsl:key name="applicationProviders" match="/node()/simple_instance[type=('Composite_Application_Provider','Application_Provider','Application_Provider_Interface')]" use="type"/>
	<xsl:key name="inScopeCost" match="/node()/simple_instance[type='Cost']" use="type"/>
	<xsl:key name="inScopeCostsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	<xsl:key name="inScopeCostComponentKey" match="/node()/simple_instance[type=('Adhoc_Cost_Component','Annual_Cost_Component','Monthly_Cost_Component','Quarterly_Cost_Component')]" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>
	<xsl:variable name="costType" select="/node()/simple_instance[(type = 'Cost_Component_Type')]"/>
	<xsl:variable name="appcurrencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="appcurrency" select="/node()/simple_instance[(type = 'Currency')][name=$appcurrencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
   <xsl:variable name="costCategory" select="/node()/simple_instance[(type = 'Cost_Category')]"/>
   <xsl:key name="costForCat_key" match="/node()/simple_instance[type=('Cost')]" use="own_slot_value[slot_reference = 'cost_components']/value"/>
   <xsl:variable name="allappCurrency" select="/node()/simple_instance[(type = 'Currency')]"/>
   <xsl:variable name="isAuthzForCostClasses" select="eas:isUserAuthZClasses(('Cost', 'Cost_Component'))"/>
   <xsl:variable name="inScopeCostInstances" select="/node()/simple_instance[(type = 'Cost')]"/>
   <xsl:variable name="isAuthzForCostInstances" select="eas:isUserAuthZInstances($inScopeCostInstances)"/>
         
	<!--
		* Copyright © 2008-2025 Enterprise Architecture Solutions Limited.
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
  
	<xsl:template name="applicationCostData">
		 
			let costData = [
				<xsl:apply-templates select="key('applicationProviders', ('Composite_Application_Provider','Application_Provider','Application_Provider_Interface'))" mode="appCostData"/>
			];

	 
	
	</xsl:template>
	<xsl:template match="node()" mode="appCostData">
		<xsl:variable name="inScopeCosts" select="key('inScopeCostsKey',current()/name)"/>
		<xsl:variable name="inScopeCostComponents" select="key('inScopeCostComponentKey',$inScopeCosts/name)"/>

		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
				
				}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
			<xsl:choose>
			<xsl:when test="not($isAuthzForCostClasses) or not($isAuthzForCostInstances)"></xsl:when> 
			<xsl:otherwise> 
			,"costs":[<xsl:for-each select="$inScopeCostComponents"> 
				<xsl:if test="$isAuthzForCostClasses">
				<xsl:variable name="parentCost" select="key('costForCat_key',current()/name)"/>
				<xsl:variable name="costCat" select="$costCategory[name=$parentCost/own_slot_value[slot_reference='cost_category']/value]"/>
				<!-- based on parent -->
				<xsl:variable name="thisCostCurrency" select="$allappCurrency[name=$parentCost/own_slot_value[slot_reference='cost_currency']/value]"/>
				<!-- directly mapped -->
				<xsl:variable name="thisCurrency" select="$allappCurrency[name=current()/own_slot_value[slot_reference='cc_cost_currency']/value]"/>
						{
							"id":"<xsl:value-of select="current()/name"/>",
							"name":"<xsl:value-of select="$costType[name=current()/own_slot_value[slot_reference='cc_cost_component_type']/value]/own_slot_value[slot_reference='name']/value"/>", 
						<xsl:variable name="temp" as="map(*)" select="map{'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))}"></xsl:variable>
						<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
						<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
						"cost":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_amount']/value"/>",
						"costType":"<xsl:value-of select="current()/type"/>",
						"ccy_code":"<xsl:choose><xsl:when test="$thisCostCurrency"><xsl:value-of select="$thisCostCurrency/own_slot_value[slot_reference='currency_code']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$currency/own_slot_value[slot_reference='currency_code']/value"/></xsl:otherwise></xsl:choose>",
						"currency":"<xsl:choose><xsl:when test="$thisCostCurrency"><xsl:value-of select="$thisCostCurrency/own_slot_value[slot_reference='currency_symbol']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/></xsl:otherwise></xsl:choose>",
						"this_currency":"<xsl:value-of select="$thisCurrency/own_slot_value[slot_reference='currency_symbol']/value"/>",
						"this_currency_code":"<xsl:value-of select="$thisCurrency/own_slot_value[slot_reference='currency_code']/value"/>",
						<xsl:if test="$costCat"> 
						"costCategory":"<xsl:value-of select="$costCat/own_slot_value[slot_reference='enumeration_value']/value"/>",
						</xsl:if>
						"fromDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_start_date_iso_8601']/value"/>",
						"toDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_end_date_iso_8601']/value"/>",
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position()=last())">,</xsl:if>   
					</xsl:if>        
					</xsl:for-each>]
					</xsl:otherwise>
			</xsl:choose>
		}<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>


</xsl:stylesheet>
