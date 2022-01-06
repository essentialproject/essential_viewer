<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="param1"/> 
<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"></xsl:variable>
<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"></xsl:variable>
<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"></xsl:variable>
<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"></xsl:variable>
<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"></xsl:variable>
<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
<xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"></xsl:variable>
<xsl:variable name="countries" select="/node()/simple_instance[type='Geographic_Region']"/>
<xsl:variable name="productConcepts" select="/node()/simple_instance[type='Product_Concept']"/>
<xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &gt; -1) or not(own_slot_value[slot_reference='enumeration_sequence_number']/value)]"/>
 <xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>
<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusCaps/name]"></xsl:variable>
<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"></xsl:variable>
<xsl:variable name="thisrelevantPhysProcsActorsIndirect" select="$a2r[name=$relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"></xsl:variable>
<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
<xsl:variable name="processToAppRel" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"></xsl:variable>
<xsl:variable name="directProcessToAppRel" select="$processToAppRel[name = $relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
<xsl:variable name="directProcessToApp" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="relevantApps" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="relevantAppsviaAPR" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
<xsl:variable name="appsWithCaps" select="$relevantApps union $relevantAppsviaAPR"/>
<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
<xsl:variable name="allAppOrgUsers2Roles" select="/node()/simple_instance[(name = $appsWithCaps/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name)]"/>	
<xsl:variable name="appTypesEnums" select="/node()/simple_instance[type='Application_Purpose']"/>
<xsl:variable name="relevantAppTypes" select="$appTypesEnums[name = $allAppProviders/own_slot_value[slot_reference = 'application_provider_purpose']/value]"></xsl:variable>
<xsl:variable name="BusinessFit" select="/node()/simple_instance[type = 'Business_Service_Quality'][own_slot_value[slot_reference = 'name']/value = ('Business Fit')]"></xsl:variable>
<xsl:variable name="BFValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value = $BusinessFit/name]"></xsl:variable>
<xsl:variable name="perfMeasures" select="/node()/simple_instance[type = 'Business_Performance_Measure'][own_slot_value[slot_reference = 'pm_performance_value']/value = $BFValues/name]"></xsl:variable>
<xsl:variable name="ApplicationFit" select="/node()/simple_instance[type = 'Technology_Service_Quality'][own_slot_value[slot_reference = 'name']/value = ('Technical Fit')]"></xsl:variable>
<xsl:variable name="AFValues" select="/node()/simple_instance[type = 'Technology_Service_Quality_Value'][own_slot_value[slot_reference = 'usage_of_service_quality']/value = $ApplicationFit/name]"></xsl:variable>
<xsl:variable name="appPerfMeasures" select="/node()/simple_instance[type = 'Technology_Performance_Measure'][own_slot_value[slot_reference = 'pm_performance_value']/value = $AFValues/name]"></xsl:variable>
<xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"></xsl:variable>
<xsl:variable name="unitOfMeasures" select="/node()/simple_instance[type = 'Unit_Of_Measure']"></xsl:variable>
<xsl:variable name="criticalityStatus" select="/node()/simple_instance[type = 'Business_Criticality']"></xsl:variable>
<xsl:variable name="actors" select="/node()/simple_instance[type = ('Group_Actor', 'Individual_Actor')]"></xsl:variable>
<xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"></xsl:variable>
<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"></xsl:variable>
<xsl:variable name="manualDataEntry" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/> 
<xsl:variable name="allAppStaticUsages" select="/node()/simple_instance[type = 'Static_Application_Provider_Usage']"/>
<xsl:variable name="allInboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':FROM']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
<xsl:variable name="allOutboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':TO']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
 
<xsl:variable name="allOrgUsers2RoleSites" select="/node()/simple_instance[name = $actors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
<xsl:variable name="allOrgUsers2RoleSitesCountry" select="/node()/simple_instance[name = $allOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>	

<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Business_Domain','Composite_Application_Provider','Group_Actor','Business_Process','Physical_Process')]"></xsl:variable>

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
	 "busCapHierarchy":[<xsl:apply-templates select="$L0BusCaps" mode="busCapDetails"><xsl:with-param name="depth" select="0"/></xsl:apply-templates>],
 	 "busCaptoAppDetails":[<xsl:apply-templates select="$allBusCaps[count(own_slot_value[slot_reference = 'supports_business_capabilities']/value)&gt;0]" mode="busCapDetailsApps"> </xsl:apply-templates>],
	"rootCap":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$rootBusCap"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"physicalProcessToProcess":[<xsl:apply-templates select="$relevantPhysProcs" mode="processPairs"></xsl:apply-templates>],
	"version":"614"		
	 }
</xsl:template>

<xsl:template mode="busCapDetails" match="node()">
		<xsl:param name="depth"/>
		<xsl:variable name="subCaps" select="$allBusCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"></xsl:variable>
		<xsl:variable name="thisrelevantBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = current()/name]"></xsl:variable>
		<xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisrelevantBusProcs/name]"></xsl:variable>
		<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisrelevantPhysProcs/name]"></xsl:variable>
		<xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[name = $thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
		<xsl:variable name="thisprocessToAppRel" select="$processToAppRel[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $allAppProviders/name]"></xsl:variable>
		<xsl:variable name="thisdirectProcessToAppRel" select="$directProcessToAppRel[name = $thisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
		<xsl:variable name="thisdirectProcessToApp" select="$directProcessToApp[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
		<xsl:variable name="thisrelevantApps" select="$relevantApps[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
		<xsl:variable name="thisrelevantAppsviaAPR" select="$relevantAppsviaAPR[name = $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
		<xsl:variable name="thisappsWithCapsfromAPR" select="$thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value union $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"></xsl:variable>    
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
	</xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
</xsl:call-template>","level":"<xsl:value-of select="$depth"/>","childrenCaps": [<xsl:if test="$depth &lt; 5"><xsl:apply-templates select="$subCaps" mode="busCapDetails"><xsl:with-param name="depth" select="$depth +1"/><xsl:sort order="ascending" select="own_slot_value[slot_reference='business_capability_index']/value"/></xsl:apply-templates></xsl:if>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template> 

<xsl:template match="node()" mode="busCapDetailsApps">
	<xsl:variable name="relevantBusCaps" select="eas:get_object_descendants(current(), $allBusCaps, 0, 10, 'supports_business_capabilities')"/>
	<xsl:variable name="directBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = current()/name]"></xsl:variable>
	<xsl:variable name="thisrelevantBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisrelevantBusProcs/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisrelevantPhysProcs/name]"></xsl:variable>
	<xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[name = $thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
	<xsl:variable name="thisprocessToAppRel" select="$processToAppRel[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $allAppProviders/name]"></xsl:variable>
	<xsl:variable name="thisdirectProcessToAppRel" select="$directProcessToAppRel[name = $thisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
	<xsl:variable name="thisdirectProcessToApp" select="$directProcessToApp[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantApps" select="$relevantApps[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantAppsviaAPR" select="$relevantAppsviaAPR[name = $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
	<xsl:variable name="thisappsWithCapsfromAPR" select="$thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value union $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"></xsl:variable>  
	<xsl:variable name="thisrelevantPhysProcsActors" select="$actors[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsa2r" select="$thisrelevantPhysProcsActorsIndirect[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActorsIn" select="$actors[name=$thisrelevantPhysProcsa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"></xsl:variable>
	<xsl:variable name="allActors" select="$thisrelevantPhysProcsActors union $thisrelevantPhysProcsActorsIn"/>
	<xsl:variable name="eaScopedOrgUserIds" select="$actors[name=$allActors/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>
	<xsl:variable name="thisOrgUsers2RoleSites" select="$allOrgUsers2RoleSites[name = $allActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
	<xsl:variable name="thisOrgUsers2RoleSitesCountry" select="$thisOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value"/>	
	<xsl:variable name="eaScopedGeoIds" select="$countries[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>
	<xsl:variable name="allGeos" select="$eaScopedGeoIds union $thisOrgUsers2RoleSitesCountry"/>
	<xsl:variable name="thisProductConcepts" select="$productConcepts[own_slot_value[slot_reference='product_concept_supported_by_capability']/value=current()/name]/name"/>
	{
	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param></xsl:call-template>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"processes":[<xsl:for-each select="$directBusProcs"><xsl:variable name="thisProcessrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = current()/name]"></xsl:variable>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"physP":[<xsl:for-each select="$thisProcessrelevantPhysProcs">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"physP":[<xsl:for-each select="$thisrelevantPhysProcs">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"orgUserIds": [<xsl:for-each select="$allActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
	"domainIds":[<xsl:for-each select="current()/own_slot_value[slot_reference='belongs_to_business_domain']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
	"prodConIds": [<xsl:for-each select="$thisProductConcepts">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
	"geoIds": [<xsl:for-each select="$allGeos">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
	"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
	"apps":[<xsl:for-each select="distinct-values($thisappsWithCapsfromAPR)">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template> 
<xsl:template match="node()" mode="processPairs">
	{"pPID":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "procID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='implements_business_process']/value)"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="node()" mode="classMetaData"> 
	<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
	{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>
<!--
	<xsl:template match="node()" mode="lifes">
		{"shortname":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>","colour":"<xsl:value-of select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]/own_slot_value[slot_reference='element_style_colour']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	
-->
</xsl:stylesheet>
