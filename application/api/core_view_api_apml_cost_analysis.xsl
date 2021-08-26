<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../application/core_al_app_cost_revenue_functions.xsl"/>
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

	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $allApps/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[name = $inScopeCostComponents/own_slot_value[slot_reference = 'cc_cost_component_type']/value]"/>
	<xsl:variable name="inScopeApps" select="$allApps[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_for_elements']/value]"/>
    
    
	<xsl:variable name="appDifferentiationLevelTax" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Differentiation Level')]"/>
	<xsl:variable name="appDifferentiationLevels" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appDifferentiationLevelTax/name]"/>

	 <xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
     <xsl:variable name="appPayers" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Paying Organisation')]"/>
	<xsl:variable name="appPayerTypes" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appPayers/name]"/>
 <xsl:variable name="appPurpose" select="/node()/simple_instance[type = 'Application_Purpose']"/>
<xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role']"/>
    <xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allPhysProc2AppProRoles" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	
	<xsl:variable name="appUserOrgRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
	
	
	<xsl:variable name="relevantGroupActorStakeholders" select="$allActor2Roles[(name = $allApps/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserOrgRole/name)]"/>
	<xsl:variable name="relevantGroupActorAppUsers" select="$allGroupActors[name = $relevantGroupActorStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $allAppProviderRoles/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
	<xsl:variable name="relevantActor2Roles" select="$allActor2Roles[(name = $relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
	<xsl:variable name="relevantPhysProcActors" select="$allGroupActors[(name = $relevantActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value) or (name = $relevantPhysProcs/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value)]"/>
    
    <xsl:variable name="site" select="/node()/simple_instance[type = 'Site'][name = $allGroupActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
    <xsl:variable name="location" select="/node()/simple_instance[type = ('Geographic_Region')][name = $site/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	
<xsl:variable name="seriesColourPaallette" select="('#4196D9', '#9B53B3', '#EEC62A', '#E37F2C', '#1FA185', '#EDC92A', '#E53B6A', '#2BC331')"/>
	<xsl:variable name="costTypeSeriesColours" select="$seriesColourPaallette[position() &lt;= count($inScopeCostTypes)]"/>
	<xsl:variable name="appDifferentiationSeriesColours" select="$seriesColourPaallette[position() &lt;= count($appDifferentiationLevels)]"/>
<!--
	<xsl:variable name="defaultCurrencyConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Currency')]"/>
	<xsl:variable name="defaultCurrency" select="/node()/simple_instance[name = $defaultCurrencyConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
   
    
    
    <xsl:variable name="site" select="/node()/simple_instance[type = 'Site'][name = $allGroupActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
    <xsl:variable name="location" select="/node()/simple_instance[type = ('Geographic_Region')][name = $site/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
    -->
	<xsl:template match="knowledge_base">
		{
			"apps": [
				<xsl:apply-templates mode="RenderApplicationJSON" select="$inScopeApps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			],
            "diffLevels": [
						<xsl:apply-templates mode="RenderViewEnumerationJSONList" select="$appDifferentiationLevels"/>
					] ,
            "diffLevelColours":[
						<xsl:for-each select="$appDifferentiationSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
					],
          "costTypes" :[
						<xsl:apply-templates mode="RenderViewEnumerationJSONList" select="$inScopeCostTypes"/>
					],
        "costTypeColours": [
						<xsl:for-each select="$costTypeSeriesColours"><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text><xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
					],
         "diffPieData":[<xsl:apply-templates mode="RenderCostDiffLevelsForPie" select="$appDifferentiationLevels"/>],
         "typePiedata":[<xsl:apply-templates mode="RenderCostTypesForPie" select="$inScopeCostTypes"/>]

		}
	</xsl:template>
	
<xsl:template match="node()" mode="RenderApplicationJSON">
<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="appDiffLevel" select="$appDifferentiationLevels[name = $this/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		
		<xsl:variable name="appCosts" select="$inScopeCosts[own_slot_value[slot_reference = 'cost_for_elements']/value = $this/name]"/>
		<xsl:variable name="appCostComponents" select="$inScopeCostComponents[name = $appCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
    
           <xsl:variable name="appGroupActorStakeholders" select="$allActor2Roles[(name = $this/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserOrgRole/name)]"/>
		<xsl:variable name="appGroupActorAppUsers" select="$allGroupActors[name = $appGroupActorStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		
		<xsl:variable name="appProvRoles" select="$allAppProviderRoles[name = $this/own_slot_value[slot_reference='provides_application_services']/value]"/>
		<xsl:variable name="appPhysProc2AppProRoles" select="$allPhysProc2AppProRoles[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $appProvRoles/name]"/>
		<xsl:variable name="appPhysProcs" select="$allPhysProcs[name = $appPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="appPhysProcActor2Roles" select="$allActor2Roles[(name = $appPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)]"/>
		<xsl:variable name="appPhysProcGroupActors" select="$allGroupActors[name = $appPhysProcActor2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		
		<xsl:variable name="appUsers" select="$appGroupActorAppUsers union $appPhysProcGroupActors"/>
        
        	
        <xsl:variable name="thissite" select="$site[name = $appUsers/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
        <xsl:variable name="thislocation" select="$location[name = $thissite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		    
    {"id": "<xsl:value-of select="current()/name"/>",
		"name": "<xsl:value-of select="eas:validJSONString(current()/own_slot_value[slot_reference='name']/value)"/>",
        "description": "<xsl:value-of select="eas:validJSONString(current()/own_slot_value[slot_reference='description']/value)"/>",
        "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
        "differentiation": <xsl:choose><xsl:when test="$appDiffLevel/name"><xsl:apply-templates mode="RenderViewEnumerationJSONList" select="$appDiffLevel"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,<xsl:apply-templates mode="RenderApplicationCostsJSON" select="$inScopeCostTypes"><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence']/value"/><xsl:with-param name="thisCostComps" select="$appCostComponents"/></xsl:apply-templates>,"countries":[<xsl:for-each select="$thislocation">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
		,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$this"/></xsl:call-template>
	}<xsl:if test="not(position()=last())">,</xsl:if>
    
</xsl:template>    
	<xsl:template match="node()" mode="RenderApplicationCostsJSON">
		<xsl:param name="thisCostComps" select="()"/>
		
		<xsl:variable name="thisCostType" select="current()"/>
		
		<xsl:variable name="thisCostTypeId" select="eas:getSafeJSString($thisCostType/name)"/>
		
		<xsl:variable name="thisCostTypeName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisCostType"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="costsForType" select="$thisCostComps[own_slot_value[slot_reference = 'cc_cost_component_type']/value = $thisCostType/name]"/>
		
		<xsl:variable name="costsTotal" select="sum($costsForType/own_slot_value[slot_reference = 'cc_cost_amount']/value)"/>
		<xsl:variable name="costTypeAmount">
			<xsl:choose>
				<xsl:when test="$costsTotal > 0"><xsl:value-of select="$costsTotal"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		"<xsl:value-of select="$thisCostTypeId"/>":{"amount":<xsl:choose><xsl:when test="$costTypeAmount=0">0</xsl:when><xsl:otherwise><xsl:value-of select="format-number($costTypeAmount,'#.##')"/></xsl:otherwise></xsl:choose>,
        "costs":[<xsl:for-each select="$costsForType"><xsl:variable name="cost" select="current()/own_slot_value[slot_reference = 'cc_cost_amount']/value"/>{"type":"<xsl:value-of select="current()/type"/>","amount":<xsl:choose><xsl:when test="current()/type='Annual_Cost_Component'"><xsl:value-of select="$cost"/></xsl:when><xsl:when test="current()/type='Quarterly_Cost_Component'"><xsl:value-of select="$cost*4"/></xsl:when><xsl:when test="current()/type='Monthly_Cost_Component'"><xsl:value-of select="$cost*12"/></xsl:when><xsl:otherwise><xsl:value-of select="$cost"/></xsl:otherwise></xsl:choose>}<xsl:if test="not(position()=last())">,
		</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,
		</xsl:if>		
		<!--'<xsl:value-of select="$thisCostTypeId"/>': {
			'costTypeId': '<xsl:value-of select="$thisCostTypeId"/>',
			'costTypeName': '<xsl:value-of select="$thisCostTypeName"/>',
			'amount': <xsl:value-of select="$costTypeAmount"/>	
		}<xsl:if test="not(position()=last())">,
		</xsl:if>-->
	</xsl:template>
 <xsl:template mode="RenderViewEnumerationJSONList" match="node()">
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="colour" select="eas:get_element_style_colour(current())"/>
		
		{
		"id": "<xsl:value-of select="translate(current()/name, '.', '_')"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"colour": "<xsl:choose><xsl:when test="string-length($colour) &gt; 0"><xsl:value-of select="$colour"/></xsl:when><xsl:otherwise>#fff</xsl:otherwise></xsl:choose>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
 
 <xsl:template mode="RenderCostTypesForPie" match="node()">
		<xsl:variable name="currentCostType" select="current()"/>
		<xsl:variable name="costTypeLabel" select="eas:get_string_slot_values($currentCostType, 'enumeration_value')"/>
		<xsl:variable name="costCompsForCostType" select="eas:get_instances_with_instance_slot_value($inScopeCostComponents, 'cc_cost_component_type', $currentCostType)"/>
		<xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($costCompsForCostType, 0)"/>

		<xsl:variable name="totalAsString" select="eas:format_large_number($costTypeTotal)"/>

		<xsl:variable name="costTypeString">
			<xsl:text>["</xsl:text>
			<xsl:value-of select="$costTypeLabel"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="$defaultCurrencySymbol"/>
			<xsl:value-of select="$totalAsString"/>
			<xsl:text>]", </xsl:text>
			<xsl:value-of select="$costTypeTotal"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:value-of select="$costTypeString"/>
		<xsl:if test="not(position() = last())">,</xsl:if>

	</xsl:template>
 

	<xsl:template mode="RenderCostDiffLevelsForPie" match="node()">
		<xsl:variable name="currentDiffLevel" select="current()"/>
		<xsl:variable name="diffLevelLabel" select="eas:get_string_slot_values($currentDiffLevel, 'name')"/>
		<xsl:variable name="appsForDiffLevel" select="eas:get_instances_with_instance_slot_value($inScopeApps, 'element_classified_by', $currentDiffLevel)"/>
		<xsl:variable name="appCostsForDiffLevel" select="eas:get_instances_with_instance_slot_value($inScopeCosts, 'cost_for_elements', $appsForDiffLevel)"/>
		<xsl:variable name="appCostCompsForDiffLevel" select="eas:get_instances_with_instance_slot_value($inScopeCostComponents, 'cc_cost_component_of_cost', $appCostsForDiffLevel)"/>

		<xsl:variable name="diffLevelTotal" select="eas:get_cost_components_total($appCostCompsForDiffLevel, 0)"/>
		<xsl:variable name="totalAsString" select="eas:format_large_number($diffLevelTotal)"/>

		<xsl:variable name="diffLevelString">
			<xsl:text>["</xsl:text>
			<xsl:value-of select="$diffLevelLabel"/>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="$defaultCurrencySymbol"/>
			<xsl:value-of select="$totalAsString"/>
			<xsl:text>]", </xsl:text>
			<xsl:value-of select="$diffLevelTotal"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:value-of select="$diffLevelString"/>
		<xsl:if test="not(position() = last())">,</xsl:if>

	</xsl:template>

</xsl:stylesheet>

