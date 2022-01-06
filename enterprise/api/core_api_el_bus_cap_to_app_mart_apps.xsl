<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="param1"/> 
<!--<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"></xsl:variable>
<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"></xsl:variable>
<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"></xsl:variable>
<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"></xsl:variable>-->
<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"></xsl:variable>
 
<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
<xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &gt; -1) or not(own_slot_value[slot_reference='enumeration_sequence_number']/value)]"/>
 <xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>
<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[type='Business_Process']"></xsl:variable>
<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"></xsl:variable>
<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"></xsl:variable>
<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
<xsl:variable name="processToAppRel" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"></xsl:variable>
<xsl:variable name="directProcessToAppRel" select="$processToAppRel[name = $relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
<xsl:variable name="directProcessToApp" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="relevantApps" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="relevantAppsviaAPR" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
<xsl:variable name="appsWithCaps" select="$relevantApps union $relevantAppsviaAPR"/>
<xsl:variable name="services" select="/node()/simple_instance[type='Application_Service'][name=$relevantAppProRoles/own_slot_value[slot_reference='implementing_application_service']/value]"/>
<xsl:variable name="actors" select="/node()/simple_instance[type = 'Group_Actor']"></xsl:variable>
 
<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
<xsl:variable name="everyAppOrgUsers2Roles" select="/node()/simple_instance[(name = $appsWithCaps/own_slot_value[slot_reference = 'stakeholders']/value)]"/>
<xsl:variable name="allAppOrgUsers2Roles" select="/node()/simple_instance[(name = $appsWithCaps/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name)]"/>	
<xsl:variable name="allAppActors" select="$actors[name=$allAppOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

<xsl:variable name="allAppOrgUsers2RoleSites" select="/node()/simple_instance[name = $allAppActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
<xsl:variable name="allAppOrgUsers2RoleSitesCountry" select="/node()/simple_instance[name = $allAppOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>	
<xsl:variable name="countries" select="/node()/simple_instance[type='Geographic_Region']"/>
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
<xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"></xsl:variable>

<xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"></xsl:variable>
<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"></xsl:variable>
<xsl:variable name="manualDataEntry" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/> 
<xsl:variable name="allAppStaticUsages" select="/node()/simple_instance[type = 'Static_Application_Provider_Usage']"/>
<xsl:variable name="allInboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':FROM']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
<xsl:variable name="allOutboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':TO']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>

 <xsl:variable name="relevantPhysProcsActorsIndirect" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION' and name=$processToAppRel/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
 <xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Application_Capability','Application_Service','Application_Provider','Composite_Application_Provider','Group_Actor','Business_Process','Physical_Process')]"></xsl:variable>
 <!-- rationalisation view -->
 <xsl:variable name="reportPath" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
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
 
<xsl:template match="knowledge_base">{
	"meta":[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>],
	"reports":[{"name":"appRat", "link":"<xsl:value-of select="$reportPath/own_slot_value[slot_reference='report_xsl_filename']/value"/>"}],
	"applications":[<xsl:apply-templates select="$allAppProviders" mode="applications"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"lifecycles":[<xsl:apply-templates select="$allLifecycleStatus" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"codebase":[<xsl:apply-templates select="$codebase" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"delivery":[<xsl:apply-templates select="$delivery" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"version":"614"
	}
</xsl:template>

<xsl:template match="node()" mode="applications">
<xsl:variable name="appLifecycle" select="$allLifecycleStatus[name = current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]"/>
<xsl:variable name="thisStyle" select="$allElementStyles[name=$appLifecycle/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>  
<xsl:variable name="appDelivery" select="$delivery[name=current()/own_slot_value[slot_reference='ap_delivery_model']/value]"/>
<xsl:variable name="thisDepStyle" select="$allElementStyles[name=$appDelivery/own_slot_value[slot_reference = 'element_styling_classes']/value]"/> <xsl:variable name="thisCodebase" select="$codebase[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]"/>
<xsl:variable name="thisCodebaseStyle" select="$allElementStyles[name=$thisCodebase/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>  
<xsl:variable name="thisAppOrgUsers2Roles" select="$allAppOrgUsers2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
<xsl:variable name="thiseveryAppOrgUsers2Roles" select="$a2r[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>


<xsl:variable name="thisOrgUserIds" select="$thisAppOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
<xsl:variable name="eaScopedOrgUserIds" select="$actors[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>

<xsl:variable name="thisAppTypes" select="$relevantAppTypes[name = current()/own_slot_value[slot_reference = 'application_provider_purpose']/value]"></xsl:variable>
<xsl:variable name="thisallAppActors" select="$actors[name=$thisAppOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

<xsl:variable name="thisAppOrgUsers2RoleSites" select="$allAppOrgUsers2RoleSites[name = $thisallAppActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
<xsl:variable name="thisAppOrgUsers2RoleSitesCountry" select="$allAppOrgUsers2RoleSitesCountry[name = $thisAppOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value]/name"/>	
<xsl:variable name="thisAppOrgUsers2RoleSitesCountryAOU" select="$allAppOrgUsers2RoleSitesCountry[name = $thiseveryAppOrgUsers2Roles/own_slot_value[slot_reference = 'site_geographic_location']/value]/name"/>	
<xsl:variable name="eaScopedGeoIds" select="$countries[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>
<xsl:variable name="allGeos" select="$eaScopedGeoIds union $thisAppOrgUsers2RoleSitesCountry union $thisAppOrgUsers2RoleSitesCountryAOU"/>

<!-- application process support -->
<xsl:variable name="thisAppAPRs" select="$relevantAppProRoles[own_slot_value[slot_reference = 'role_for_application_provider']/value=current()/name]"></xsl:variable>
<xsl:variable name="thisAppProRolestoPhys" select="$processToAppRel[name=$thisAppAPRs/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value]"></xsl:variable>
<xsl:variable name="thisApptoProc" select="$processToAppRel[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value=current()/name]"></xsl:variable>
<xsl:variable name="thisdirectProcessToAppRelation" select="$relevantPhysProcs[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value=$thisApptoProc/name]"></xsl:variable>
<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProcs[name=$thisAppProRolestoPhys/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"></xsl:variable>
<xsl:variable name="allRelevantPhysProcesses" select="$thisrelevantPhysProc2AppProRoles union $thisdirectProcessToAppRelation"/>  
<xsl:variable name="allRelevantPhysProcessesIDs" select="distinct-values($thisAppProRolestoPhys/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value union $thisApptoProc/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value)"/> 
<xsl:variable name="thisrelevantPhysProcsActorsDirect" select="$actors[name=$allRelevantPhysProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
<xsl:variable name="thisrelevantPhysProcsActorsIndirect" select="$a2r[name=$allRelevantPhysProcesses/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
<xsl:variable name="thisrelevantPhysProcsActors" select="$actors[name=$thisrelevantPhysProcsActorsIndirect/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"></xsl:variable>
<xsl:variable name="allProcessActors" select="$thisrelevantPhysProcsActors/name union $thisrelevantPhysProcsActorsDirect/name"/>
 
<xsl:variable name="allOrgUserIds" select="$eaScopedOrgUserIds union $thisOrgUserIds union $allProcessActors"/>
<xsl:variable name="subApps" select="$allAppProviders[name = current()/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
<xsl:variable name="subSubApps" select="$allAppProviders[name = $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
<xsl:variable name="allCurrentApps" select="current() union $subApps union $subSubApps"/>
<xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $allCurrentApps/name]"/>
<xsl:variable name="appInboundStaticAppRels" select="$allInboundStaticAppRels[(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name)]"/>
<xsl:variable name="appInboundStaticAppUsages" select="$allAppStaticUsages[name = $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value]"/>
<xsl:variable name="appInboundStaticApps" select="$allAppProviders[name = $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
<xsl:variable name="appOutboundStaticAppRels" select="$allOutboundStaticAppRels[(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name)]"/>
<xsl:variable name="appOutboundStaticAppUsages" select="$allAppStaticUsages[name = $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value]"/>
<xsl:variable name="appOutboundStaticApps" select="$allAppProviders[name = $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
<xsl:variable name="appInboundDepCount" select="eas:get_inbound_int_count($allCurrentApps)"/>
<xsl:variable name="appOutboundDepCount" select="eas:get_outbound_int_count($allCurrentApps)"/>
		{  
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		"name": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
			 <xsl:with-param name="theSubjectInstance" select="current()"/>
		</xsl:call-template>",
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			 <xsl:with-param name="theSubjectInstance" select="current()"/>
		</xsl:call-template>",
	<!--	"link": "<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="isForJSONAPI" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			</xsl:call-template>",  -->
	  	"inI":"<xsl:value-of select="$appInboundDepCount"/>",
		"inIList":[<xsl:for-each select="$appInboundStaticApps">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/>
		<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>", "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"outI":"<xsl:value-of select="$appOutboundDepCount"/>",
		"outIList":[<xsl:for-each select="$appOutboundStaticApps">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>", "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],	 
		"criticality":"<xsl:value-of select="$criticalityStatus[name=current()/own_slot_value[slot_reference='ap_business_criticality']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"type":"<xsl:if test="$thisAppTypes"><xsl:choose><xsl:when test="count($thisAppTypes) &gt; 1"><xsl:for-each select="$thisAppTypes"><xsl:choose><xsl:when test="contains(current()/own_slot_value[slot_reference = 'enumeration_value']/value,'Business')"><xsl:value-of select="$thisAppTypes[contains(own_slot_value[slot_reference = 'enumeration_value']/value,'Business')]/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:when></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise><xsl:value-of select="$thisAppTypes[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:otherwise></xsl:choose></xsl:if>",
		"typeid":"<xsl:choose><xsl:when test="count($thisAppTypes) &gt; 1"><xsl:for-each select="$thisAppTypes">
		<xsl:choose><xsl:when test="contains(current()/own_slot_value[slot_reference = 'enumeration_value']/value,'Business')"><xsl:value-of select="eas:getSafeJSString($thisAppTypes[contains(own_slot_value[slot_reference = 'enumeration_value']/value,'Business')]/name)"/></xsl:when></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise><xsl:value-of select="eas:getSafeJSString($thisAppTypes[1]/name)"/></xsl:otherwise></xsl:choose>",
		"orgUserIds": [<xsl:for-each select="$allOrgUserIds">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"geoIds": [<xsl:for-each select="$allGeos">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"codebaseID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
		"deliveryID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
		"sA2R":[<xsl:for-each select="$thiseveryAppOrgUsers2Roles">"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"lifecycle":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value)"/>",
		"physP":[<xsl:for-each select="$allRelevantPhysProcessesIDs">"<xsl:value-of select="eas:getSafeJSString(.)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"allServices":[<xsl:for-each select="current()/own_slot_value[slot_reference='provides_application_services']/value">
	 	{ "id": "<xsl:value-of select="eas:getSafeJSString(.)"></xsl:value-of>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		<!--services supporting processes -->
		"services":[<xsl:for-each select="$thisAppAPRs">
			<xsl:variable name="svc" select="$services[name=current()/own_slot_value[slot_reference='implementing_application_service']/value]"/>
			{"id": "<xsl:value-of select="eas:getSafeJSString($svc/name)"></xsl:value-of>","name": "<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
					 <xsl:with-param name="theSubjectInstance" select="$svc"/>
				</xsl:call-template>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
	</xsl:template>

<xsl:template match="node()" mode="fitValues">
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		"name": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>",
		"shortname":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/>",
		"colour":"<xsl:value-of select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]/own_slot_value[slot_reference='element_style_colour']/value"/>",
		"value":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"></xsl:value-of>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	
   
    <!--    <xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>
		<xsl:param name="depth"/>
		<xsl:variable name="newDepth" select="$depth + 1"/>
 
		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:if test="$newDepth &lt; 6">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildListA" select="$allBusCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aChildListB" select="$allBusCaps[name = $theParentCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
				<xsl:variable name="aChildList" select="$aChildListA union $aChildListB"/>
				<xsl:variable name="aNewList" select="$aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren, $newDepth)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
 
	</xsl:function>-->
	<xsl:template match="node()" mode="criticalityOptions">
	<option><xsl:attribute name="value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"></xsl:value-of></xsl:attribute><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></option>
	
	</xsl:template>
	<xsl:template match="node()" mode="actorOptions">
	<option><xsl:attribute name="value"><xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of></xsl:attribute><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></option>
	</xsl:template>
	<xsl:template match="node()" mode="lifes">
		<xsl:variable name="thisStyle" select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","shortname":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'enumeration_value']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></xsl:otherwise></xsl:choose>","colour":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		"colourText":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	
	<xsl:template match="node()" mode="checks">
		<xsl:variable name="thisname" select="current()/own_slot_value[slot_reference='name']/value"/>
		<input type="checkbox" class="appScope"><xsl:attribute name="id"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>
			<xsl:choose><xsl:when test="contains($thisname,'Business')"><xsl:attribute name="checked"></xsl:attribute></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose> 
		</input><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>
  		 
	</xsl:template>	

 
	<xsl:function name="eas:get_inbound_int_count" as="xs:integer">
			<xsl:param name="app"/>
	
			<xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>
			<xsl:variable name="appInboundStaticAppRels" select="$allInboundStaticAppRels[(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name)]"/>
			<xsl:variable name="appInboundStaticAppUsages" select="$allAppStaticUsages[name = $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value]"/>
			<xsl:variable name="appInboundStaticApps" select="$allAppProviders[name = $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
			<xsl:variable name="inboundRelCount" select="count($appInboundStaticApps)"/>
	
			<xsl:value-of select="$inboundRelCount"/>
	
		</xsl:function>
	
		<xsl:function name="eas:get_outbound_int_count" as="xs:integer">
			<xsl:param name="app"/>
	
			<xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>
			<xsl:variable name="appOutboundStaticAppRels" select="$allOutboundStaticAppRels[(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name)]"/>
			<xsl:variable name="appOutboundStaticAppUsages" select="$allAppStaticUsages[name = $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value]"/>
			<xsl:variable name="appOutboundStaticApps" select="$allAppProviders[name = $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
			<xsl:variable name="outboundRelCount" select="count($appOutboundStaticApps)"/>
	
			<xsl:value-of select="$outboundRelCount"/>
	
		</xsl:function>	
		<xsl:function name="eas:get_outbound_int_apps" as="xs:integer">
			<xsl:param name="app"/>
	
			<xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>
			<xsl:variable name="appOutboundStaticAppRels" select="$allOutboundStaticAppRels[(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name)]"/>
			<xsl:variable name="appOutboundStaticAppUsages" select="$allAppStaticUsages[name = $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value]"/>
			<xsl:variable name="appOutboundStaticApps" select="$allAppProviders[name = $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/> 
			<xsl:for-each select="$appOutboundStaticApps">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>", "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>
	
		</xsl:function>	
		<xsl:template match="node()" mode="classMetaData"> 
				<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
				{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>
</xsl:stylesheet>
