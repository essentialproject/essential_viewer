<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	
    <xsl:variable name="businessProcesses" select="/node()/simple_instance[type = 'Business_Process']"/>

	<xsl:key name="businessCapabilities" match="/node()/simple_instance[type = 'Business_Capability']" use="name"/> 
    <xsl:variable name="businessCapabilities" select="key('businessCapabilities', $businessProcesses/own_slot_value[slot_reference='realises_business_capability']/value)"/>
	<xsl:key name="a2r" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/> 
 
	<xsl:key name="roles" match="/node()/simple_instance[supertype = 'Business_Role']" use="name"/> 
	
	<xsl:key name="infoViewsRelation" match="/node()/simple_instance[type = 'BUSPROCTYPE_TO_INFOVIEW_RELATION']" use="name"/> 
	<xsl:key name="infoConcepts" match="/node()/simple_instance[type = 'Information_Concept']" use="name"/> 
	<xsl:key name="infoViews" match="/node()/simple_instance[supertype = 'Information_View_Type']" use="name"/> 
	<xsl:key name="physProcess" match="/node()/simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/> 
	<xsl:key name="countries" match="/node()/simple_instance[type = 'Geographic_Region']" use="name"/> 
	<xsl:variable name="countries" select="/node()/simple_instance[type='Geographic_Region']"/>
	<xsl:variable name="productConcepts" select="/node()/simple_instance[type='Product_Concept']"/>
	<xsl:key name="productType" match="/node()/simple_instance[type = ('Product_Type','Composite_Product_Type')]" use="own_slot_value[slot_reference='product_type_realises_concept']/value"/> 
	<xsl:key name="productTypeName" match="/node()/simple_instance[type = ('Product_Type','Composite_Product_Type')]" use="name"/> 
	<xsl:variable name="productType" select="key('productType', $productConcepts/name)"/>
	<xsl:variable name="products" select="/node()/simple_instance[type=('Product','Composite_Product')]"/>


	<xsl:key name="inScopeCostsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	<xsl:key name="inScopeCostComponentKey" match="/node()/simple_instance[type=('Adhoc_Cost_Component','Annual_Cost_Component','Monthly_Cost_Component','Quarterly_Cost_Component')]" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>
	<xsl:variable name="costType" select="/node()/simple_instance[(type = 'Cost_Component_Type')]"/>
	<xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
   <xsl:variable name="costCategory" select="/node()/simple_instance[(type = 'Cost_Category')]"/>
  	<xsl:key name="costForCat_key" match="/node()/simple_instance[type=('Cost')]" use="own_slot_value[slot_reference = 'cost_components']/value"/>
	
	<xsl:variable name="allCurrency" select="/node()/simple_instance[(type = 'Currency')]"/>
	<xsl:variable name="relevantPhysProcs" select="key('physProcess', $businessProcesses/name)"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActorsIndirect" select="key('a2r', $relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"></xsl:variable>
	<xsl:variable name="actors" select="/node()/simple_instance[type = ('Group_Actor', 'Individual_Actor')]"></xsl:variable>	
	<xsl:key name="actors" match="/node()/simple_instance[type =('Group_Actor', 'Individual_Actor')]" use="name"/>  
	<xsl:variable name="allOrgUsers2RoleSites" select="/node()/simple_instance[type='Site'][name = $actors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
	<xsl:variable name="allOrgUsers2RoleSitesCountry" select="/node()/simple_instance[name = $allOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>	
	<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Composite_Application_Provider','Individual_Actor','Group_Actor','Business_Process','Physical_Process','Business_Process_Family')]"></xsl:variable>
	<xsl:variable name="standardisation" select="/node()/simple_instance[type = 'Standardisation_Level']"></xsl:variable>

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
		{"meta":[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>],
		 "businessProcesses":[<xsl:apply-templates select="$businessProcesses" mode="businessProcesses"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		 "ccy":[<xsl:apply-templates mode="renderCurrencies" select="$allCurrency">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
 		 </xsl:apply-templates>],"version":"620"}
	</xsl:template>

<xsl:template match="node()" mode="businessProcesses">
	<xsl:variable name="parentCaps" select="$businessCapabilities[name=current()/own_slot_value[slot_reference='realises_business_capability']/value]"/>
 	<xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = current()/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActors" select="key('actors', $thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsa2r" select="$thisrelevantPhysProcsActorsIndirect[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActorsIn" select="key('actors', $thisrelevantPhysProcsa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"></xsl:variable>
	<xsl:variable name="allActors" select="$thisrelevantPhysProcsActors union $thisrelevantPhysProcsActorsIn"/>
	<xsl:variable name="eaScopedOrgUserIds" select="key('actors', $allActors/own_slot_value[slot_reference = 'ea_scope']/value)/name"/>
	<xsl:variable name="thisOrgUsers2RoleSites" select="$allOrgUsers2RoleSites[name = $allActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
	<xsl:variable name="thisOrgUsers2RoleSitesCountry" select="$thisOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value"/>	
	<xsl:variable name="eaScopedGeoIds" select="key('countries', current()/own_slot_value[slot_reference = 'ea_scope']/value)/name"/>
	<xsl:variable name="allGeos" select="$eaScopedGeoIds union $thisOrgUsers2RoleSitesCountry"/>
	<xsl:variable name="thisProducts" select="$products[own_slot_value[slot_reference='product_implemented_by_process']/value=$thisrelevantPhysProcs/name]"/>
	<xsl:variable name="thisproductType" select="key('productTypeName', $thisProducts/own_slot_value[slot_reference='instance_of_product_type']/value)"/>
	<xsl:variable name="thisProductConcepts" select="$thisproductType/own_slot_value[slot_reference='product_type_realises_concept']/value"/>
	<xsl:variable name="thisStandardisation" select="$standardisation[name=current()/own_slot_value[slot_reference='standardisation_level']/value]"/>
	<xsl:variable name="performedbyRole" select="key('roles', current()/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value)"/>
	<xsl:variable name="thisInfoViewsRel" select="key('infoViewsRelation', current()/own_slot_value[slot_reference = 'busproctype_uses_infoviews']/value)"/>
	<xsl:variable name="thisInfoViews" select="key('infoViews', $thisInfoViewsRel/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value)"/>
 	<xsl:variable name="inScopeCosts" select="key('inScopeCostsKey',current()/name)"/>
	<xsl:variable name="inScopeCostComponents" select="key('inScopeCostComponentKey',$inScopeCosts/name)"/>
	<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
	
   {
	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
	'standardisation': string(translate(translate($thisStandardisation/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')) 
	
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"bus_process_type_creates_information":[<xsl:for-each select="key('infoViews', current()/own_slot_value[slot_reference = 'bus_process_type_creates_information']/value)">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"infoConcepts":[<xsl:for-each select="key('infoConcepts', current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value)">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]} <xsl:if test="position()!=last()">,</xsl:if> 
	</xsl:for-each>],
	"bus_process_type_reads_information":[<xsl:for-each select="key('infoViews', current()/own_slot_value[slot_reference = 'bus_process_type_reads_information']/value)">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"infoConcepts":[<xsl:for-each select="key('infoConcepts', current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value)">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]} <xsl:if test="position()!=last()">,</xsl:if> 
	</xsl:for-each>],
	"bus_process_type_updates_information":[<xsl:for-each select="key('infoViews', current()/own_slot_value[slot_reference = 'bus_process_type_updates_information']/value)">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"infoConcepts":[<xsl:for-each select="key('infoConcepts', current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value)">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]} <xsl:if test="position()!=last()">,</xsl:if> 
	</xsl:for-each>],
	"bus_process_type_deletes_information":[<xsl:for-each select="key('infoViews', current()/own_slot_value[slot_reference = 'bus_process_type_deletes_information']/value)">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"infoConcepts":[<xsl:for-each select="key('infoConcepts', current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value)">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]} <xsl:if test="position()!=last()">,</xsl:if> 
	</xsl:for-each>],
	"busproctype_relation":[<xsl:for-each select="$thisInfoViewsRel">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"create":"<xsl:value-of select="current()/own_slot_value[slot_reference='busproctype_creates_infoview']/value"/>",
	"read":"<xsl:value-of select="current()/own_slot_value[slot_reference='busproctype_reads_infoview']/value"/>",
	"update":"<xsl:value-of select="current()/own_slot_value[slot_reference='busproctype_updates_infoview']/value"/>",
	"delete":"<xsl:value-of select="current()/own_slot_value[slot_reference='busproctype_deletes_infoview']/value"/>",
	"infoRep":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='busproctype_to_infoview_to_infoview']/value)"/>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>],
	"busproctype_uses_infoviews":[<xsl:for-each select="$thisInfoViews">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"infoConcepts":[<xsl:for-each select="key('infoConcepts', current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value)">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]} <xsl:if test="position()!=last()">,</xsl:if> 
		</xsl:for-each>],
	"performedbyRole":[<xsl:for-each select="$performedbyRole">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))  
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>} <xsl:if test="position()!=last()">,</xsl:if> 
		</xsl:for-each>],
		"bp_sub_business_processes":[<xsl:for-each select="current()/own_slot_value[slot_reference='bp_sub_business_processes']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"realises_business_capability":[<xsl:for-each select="current()/own_slot_value[slot_reference='realises_business_capability']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"flow":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>",	    
		"actors":[<xsl:for-each select="$allActors">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"parentCaps":[<xsl:for-each select="$parentCaps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"debug":"<xsl:value-of select="$inScopeCostComponents/name"/>",
		"costs":[<xsl:for-each select="$inScopeCostComponents"> 
				<xsl:variable name="parentCost" select="key('costForCat_key',current()/name)"/>
				<xsl:variable name="costCat" select="$costCategory[name=$parentCost/own_slot_value[slot_reference='cost_category']/value]"/>
				<!-- based on parent -->
				<xsl:variable name="thisCostCurrency" select="$allCurrency[name=$parentCost/own_slot_value[slot_reference='cost_currency']/value]"/>
				<!-- directly mapped -->
				<xsl:variable name="thisCurrency" select="$allCurrency[name=current()/own_slot_value[slot_reference='cc_cost_currency']/value]"/>
						{"name":"<xsl:value-of select="$costType[name=current()/own_slot_value[slot_reference='cc_cost_component_type']/value]/own_slot_value[slot_reference='name']/value"/>", 
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
					</xsl:for-each>],		
 		"orgUserIds": [<xsl:for-each select="$allActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"prodConIds": [<xsl:for-each select="$thisProductConcepts">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],		
		"geoIds": [<xsl:for-each select="$allGeos">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
 	<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
<xsl:template match="node()" mode="classMetaData"> 
	<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
	{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>	
<xsl:template mode="renderCurrencies" match="node()">                           
	   {   "id": "<xsl:value-of select="current()/name"/>",
	   <xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"default":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_is_default']/value"/>",
			"exchangeRate":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_exchange_rate']/value"/>",
			"ccySymbol":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_symbol']/value"/>"	,
			"ccyCode":"<xsl:value-of select="current()/own_slot_value[slot_reference='currency_code']/value"/>"		   
				   
		} <xsl:if test="not(position()=last())">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
