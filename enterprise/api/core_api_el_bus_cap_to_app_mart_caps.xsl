<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="param1"/> 
<xsl:key name="BusCapsKey" match="/node()/simple_instance[type = 'Business_Capability']" use="name"/>
<xsl:key name="allbusCaps_key" match="/node()/simple_instance[(type = 'Business_Capability')]" use="type"/>
<xsl:key name="allApps_key" match="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]" use="type"/>
<xsl:key name="allChildCap2ParentCapRelsKey" match="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']" use="type"/>
<xsl:key name="a2rKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="type"></xsl:key>
<xsl:variable name="allBusCaps" select="key('allbusCaps_key', 'Business_Capability')"></xsl:variable>
<xsl:key name="allbusCapsName_key" match="$allBusCaps" use="name"/>
<xsl:variable name="busClass" select="/node()/class[name = ('Business_Capability')]" />
<xsl:variable name="busSlots" select="/node()/slot[name = $busClass/template_slot]" />
<xsl:variable name="parentEnumClass" select="/node()/class[superclass = 'Enumeration']" />
<xsl:variable name="subEnumClass" select="/node()/class[superclass = $parentEnumClass/name]" />
<xsl:variable name="enumClass" select="$parentEnumClass union $subEnumClass" />
<xsl:variable name="targetSlots" select="$busSlots/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value[2]"/>
<xsl:variable name="allBusSlots" select="$busSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=$enumClass/name]"/> 
<xsl:variable name="allEnumClass" select="$enumClass[name=$targetSlots]"/> 
<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"></xsl:variable>
<xsl:variable name="rootBusCap" select="key('allbusCapsName_key', $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value)"></xsl:variable>
<xsl:variable name="L0BusCaps" select="key('allbusCapsName_key',$rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value)"></xsl:variable>
<xsl:variable name="allAppProviders" select="key('allApps_key', ('Application_Provider', 'Composite_Application_Provider'))"></xsl:variable>
<xsl:variable name="allChildCap2ParentCapRels" select="key('allChildCap2ParentCapRelsKey', 'BUSCAP_TO_PARENTBUSCAP_RELATION')"/>
<xsl:variable name="a2r" select="key('a2rKey', 'ACTOR_TO_ROLE_RELATION')"></xsl:variable>
<xsl:key name="a2rName" match="$a2r" use="name"></xsl:key>
<xsl:variable name="countries" select="/node()/simple_instance[type='Geographic_Region']"/>
<xsl:variable name="allSites" select="/node()/simple_instance[(type = 'Site')]"/>
<xsl:variable name="productConcepts" select="/node()/simple_instance[type='Product_Concept']"/>
<xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &gt; -1) or not(own_slot_value[slot_reference='enumeration_sequence_number']/value)]"/>
 <xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>

 <xsl:key name="allbusProcs_key" match="/node()/simple_instance[(type = 'Business_Process')]" use="own_slot_value[slot_reference = 'realises_business_capability']/value"/>
 <xsl:key name="allPhysProcs_key" match="/node()/simple_instance[(type = 'Physical_Process')]" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
<xsl:variable name="relevantBusProcs" select="key('allbusProcs_key', $allBusCaps/name)"></xsl:variable>
<xsl:key name="taxTerm" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/>
<xsl:key name="taxonomy" match="/node()/simple_instance[type = 'Taxonomy']" use="own_slot_value[slot_reference = 'taxonomy_terms']/value"/>
<xsl:variable name="relevantPhysProcs" select="key('allPhysProcs_key', $relevantBusProcs/name)"></xsl:variable>
<xsl:key name="physActKey" match="$a2r" use="own_slot_value[slot_reference = 'performs_physical_processes']/value"/>
<xsl:variable name="thisrelevantPhysProcsActorsIndirect" select="key('a2rName', $relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"></xsl:variable>
<xsl:key name="perfMeasureKey" match="/node()/simple_instance[supertype = 'Performance_Measure']" use="own_slot_value[slot_reference = 'pm_performance_value']/value"/>
<xsl:key name="servQualKey" match="/node()/simple_instance[supertype = 'Service_Quality_Value']" use="own_slot_value[slot_reference = 'usage_of_service_quality']/value"/>

<!-- bus model data -->
<xsl:key name="BusModels" match="/node()/simple_instance[type='Business_Model']" use="name"/>
<xsl:key name="BusModelsType" match="/node()/simple_instance[type='Business_Model']" use="type"/>
<xsl:variable name="appRepImpls" select="/node()/simple_instance[type='Application_Reference_Implementation']"/>
<xsl:key name="appRepImpls" match="/node()/simple_instance[type='Application_Reference_Implementation']" use="type"/>
<xsl:variable name="BusProcessesRefUsage" select="/node()/simple_instance[type='Business_Process_Reference_Usage']"/>
<xsl:variable name="BusModelUsage" select="/node()/simple_instance[type='Business_Model_Business_Usage']"/>
<xsl:variable name="busRefArch" select="/node()/simple_instance[type='Business_Reference_Architecture']"/>  
<xsl:key name="BPKey" match="$relevantBusProcs" use="name"/>
<xsl:key name="BRAKey" match="$busRefArch" use="own_slot_value[slot_reference='business_reference_architecture_elements']/value"/> 

<xsl:variable name="groupActors" select="/node()/simple_instance[type='Group_Actor']"/>

<xsl:key name="busRefKey" match="$busRefArch" use="name"/>
<xsl:variable name="BusModelArch" select="/node()/simple_instance[type='Business_Model_Architecture']"/>
<xsl:key name="BusModArch" match="$BusModelArch" use="own_slot_value[slot_reference='architecture_of_business_model']/value"/>
<xsl:key name="BusModelArchname" match="$BusModelArch" use="name"/>
<xsl:variable name="ARITs" select="/node()/simple_instance[type=':ARIT-TO-ARIT-REFERENCE-RELATION']"/>

<xsl:variable name="BRAMap" select="/node()/simple_instance[type=':BMC-BRAU-DEPENDS_ON-ARIU']"/>
<xsl:variable name="BRUsages" select="/node()/simple_instance[type='Business_Reference_Architecture_Config_Usage']"/>
<xsl:variable name="ARUsages" select="/node()/simple_instance[type='Application_Reference_Implementation_Config_Usage']"/>
<xsl:variable name="BusModelConfigurations" select="/node()/simple_instance[type='Business_Model_Configuration']"/>
<xsl:key name="aritARI" match="key('appRepImpls', 'Application_Reference_Implementation')" use="own_slot_value[slot_reference='application_reference_implementation_dependencies']/value"/>
<xsl:key name="aritARIName" match="key('appRepImpls', 'Application_Reference_Implementation')" use="name"/>
<xsl:key name="aritARITypes" match="/node()/simple_instance[supertype='Application_Reference_Implementation_Type']" use="name"/>

<!-- configurations -->
<xsl:key name="BRACUTypes" match="$BRUsages" use="name"/>
<xsl:variable name="BMCA" select="/node()/simple_instance[type='Business_Model_Configuration_Architecture']"/>
<xsl:key name="BRAC" match="$BMCA" use="own_slot_value[slot_reference='bmc_architecture_elements']/value"/>
<xsl:key name="BRACname" match="$BMCA" use="name"/>

<xsl:key name="ARICUTypes" match="/node()/simple_instance[type='Application_Reference_Implementation_Config_Usage']" use="name"/>
<xsl:key name="ARIC" match="/node()/simple_instance[type='Business_Reference_Architecture_Configuration']" use="own_slot_value[slot_reference='bmc_architecture_elements']/value"/>
<xsl:key name="aritARIAPRs" match="/node()/simple_instance[type = 'Application_Provider_Role']" use="name"/>
<xsl:key name="aritAPRs" match="/node()/simple_instance[type = 'Application_Provider_Role']" use="type"/>
<!--
<xsl:variable name="thisrelevantPhysProcsActorsIndirect" select="$a2r[name=$relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"></xsl:variable>
<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
<xsl:variable name="processToAppRel" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"></xsl:variable>
<xsl:variable name="directProcessToAppRel" select="$processToAppRel[name = $relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
<xsl:variable name="directProcessToApp" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="relevantApps" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="relevantAppsviaAPR" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
<xsl:variable name="appsWithCaps" select="$relevantApps union $relevantAppsviaAPR"/>-->
<xsl:variable name="allDiffLevels" select="/node()/simple_instance[type = 'Business_Differentiation_Level'][name = $allBusCaps/own_slot_value[slot_reference = 'business_differentiation_level']/value]"/>
 
<xsl:variable name="appTypesEnums" select="/node()/simple_instance[type='Application_Purpose']"/>
<xsl:variable name="relevantAppTypes" select="$appTypesEnums[name = $allAppProviders/own_slot_value[slot_reference = 'application_provider_purpose']/value]"></xsl:variable>
<xsl:variable name="BusinessFit" select="/node()/simple_instance[type = 'Business_Service_Quality'][own_slot_value[slot_reference = 'name']/value = ('Business Fit')]"></xsl:variable>
<xsl:variable name="BFValues" select="key('servQualKey', $BusinessFit/name)"></xsl:variable>
<xsl:variable name="perfMeasures" select="key('perfMeasureKey', $BFValues/name)"></xsl:variable>
<xsl:variable name="ApplicationFit" select="/node()/simple_instance[type = 'Technology_Service_Quality'][own_slot_value[slot_reference = 'name']/value = ('Technical Fit')]"></xsl:variable>
<xsl:variable name="AFValues" select="key('servQualKey', $ApplicationFit/name)"></xsl:variable>
<xsl:variable name="appPerfMeasures" select="key('perfMeasureKey',  $AFValues/name)"></xsl:variable>
<xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"></xsl:variable>
<xsl:variable name="unitOfMeasures" select="/node()/simple_instance[type = 'Unit_Of_Measure']"></xsl:variable>
<xsl:variable name="criticalityStatus" select="/node()/simple_instance[type = 'Business_Criticality']"></xsl:variable>
<xsl:variable name="actors" select="/node()/simple_instance[type = ('Group_Actor', 'Individual_Actor')]"></xsl:variable>
<xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"></xsl:variable>
<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"></xsl:variable>
<xsl:variable name="manualDataEntry" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/> 
<xsl:key name="sitesKey" match="/node()/simple_instance[type = 'Site']" use="name"/> 

<xsl:variable name="allOrgUsers2RoleSites" select="key('sitesKey', $actors/own_slot_value[slot_reference = 'actor_based_at_site']/value)"/>	
<xsl:variable name="allOrgUsers2RoleSitesCountry" select="/node()/simple_instance[name = $allOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>	

<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Business_Domain','Composite_Application_Provider','Group_Actor','Business_Process','Physical_Process')]"></xsl:variable>

<xsl:key name="busProcessKey" match="/node()/simple_instance[type=('Business_Process')]" use="own_slot_value[slot_reference = 'realises_business_capability']/value"/>
<xsl:key name="physProcessKey" match="/node()/simple_instance[type=('Physical_Process')]" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
<xsl:key name="physProcesstoAppKey" match="/node()/simple_instance[type=('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/>
<xsl:key name="directApptoProcessKey" match="$allAppProviders" use="own_slot_value[slot_reference = 'app_pro_supports_phys_proc']/value"/>
<xsl:key name="indirectApptoProcessAPRAppsKey" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/>
<xsl:key name="indirectApptoServiceKey" match="$allAppProviders" use="own_slot_value[slot_reference = 'provides_application_services']/value"/>
<xsl:key name="busCapKey" match="$allBusCaps" use="own_slot_value[slot_reference = 'contained_business_capabilities']/value"/>
<xsl:variable name="allGeosRegions" select="/node()/simple_instance[type='Geographic_Region']"/>
<xsl:variable name="allGeoLocs" select="/node()/simple_instance[type='Geographic_Location']"/> 
<xsl:variable name="allGeo" select="$allGeosRegions union $allGeoLocs"/> 
<xsl:variable name="infoConcepts" select="/node()/simple_instance[type='Information_Concept'][name=$allBusCaps/own_slot_value[slot_reference = 'business_capability_requires_information']/value]"/> 
<xsl:variable name="rootActors" select="$actors[own_slot_value[slot_reference='is_root']/value='true']"/> 
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
	 "busCapHierarchy":[<xsl:apply-templates select="$L0BusCaps" mode="busCapDetails"><xsl:with-param name="depth" select="0"/><xsl:sort select="own_slot_value[slot_reference='business_capability_index']/value" order="ascending"/></xsl:apply-templates>],
 	 "busCaptoAppDetails":[<xsl:apply-templates select="$allBusCaps" mode="busCapDetailsApps"><xsl:sort select="own_slot_value[slot_reference='business_capability_index']/value" order="ascending"/> </xsl:apply-templates>],
 
	"rootCap":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$rootBusCap"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"physicalProcessToProcess":[<xsl:apply-templates select="$relevantPhysProcs" mode="processPairs"></xsl:apply-templates>],
	"filters":[<xsl:apply-templates select="$allEnumClass" mode="createFilterJSON"></xsl:apply-templates>],
	"rootOrgs":[<xsl:for-each select="$rootActors">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
	</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
	"bus_model_management":{
		"businessModels":[<xsl:apply-templates select="key('BusModelsType', 'Business_Model')" mode="busMods"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"businessModelConfigurations":[<xsl:apply-templates select="$BusModelConfigurations" mode="busModConfigs"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"aris":[<xsl:apply-templates select="key('appRepImpls', 'Application_Reference_Implementation')" mode="ariSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"bras":[<xsl:apply-templates select="$busRefArch" mode="ariSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"arits":[<xsl:apply-templates select="$ARITs" mode="aritSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"busRefConf":[<xsl:apply-templates select="$BRAMap" mode="brcSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"busModelProcess":[<xsl:apply-templates select="$BusModelUsage" mode="busProArchSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"ref2Process":[<xsl:apply-templates select="$BusProcessesRefUsage" mode="busProtoArchSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
		"application_provider_roles": [<xsl:apply-templates select="key('aritAPRs', 'Application_Provider_Role')" mode="aprs"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>]	
	},
	"version":"620"		
	 }
</xsl:template>

<xsl:template mode="busCapDetails" match="node()">
	<xsl:param name="depth"/>
	<xsl:variable name="thisCap" select="current()"/>
	<xsl:variable name="subCaps" select="$allBusCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"></xsl:variable>
	<xsl:variable name="thisDescendents" select="eas:get_object_descendants(current(), $allBusCaps, 1, 6, 'supports_business_capabilities')"/>
	<xsl:variable name="thisDiffLevels" select="$allDiffLevels[name = $thisDescendents/own_slot_value[slot_reference = 'business_differentiation_level']/value]"/>
	
	<!--
<xsl:variable name="thisrelevantBusProcs" select="key('busProcessKey',current()/name)"/>
<xsl:variable name="thisrelevantPhysProcs" select="key('physProcessKey',$thisrelevantBusProcs/name)"/> 
<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="key('physProcesstoAppKey',$thisrelevantPhysProcs/name)"/> 
<xsl:variable name="thisrelevantAppProRoles" select="key('indirectApptoProcessAPRAppsKey',$thisrelevantPhysProc2AppProRoles/name)"/> 
<xsl:variable name="thisprocessToAppRel" select="key('indirectApptoServiceKey',$thisrelevantAppProRoles/name)"/> 
<xsl:variable name="thisdirectProcessToAppRel" select="key('directApptoProcessKey',$thisrelevantPhysProc2AppProRoles/name)"/> 
	<xsl:variable name="thisrelevantBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = current()/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisrelevantBusProcs/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisrelevantPhysProcs/name]"></xsl:variable>
	<xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[name = $thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
	<xsl:variable name="thisprocessToAppRel" select="$processToAppRel[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $allAppProviders/name]"></xsl:variable>
	<xsl:variable name="thisdirectProcessToAppRel" select="$directProcessToAppRel[name = $thisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
	<xsl:variable name="thisdirectProcessToApp" select="$directProcessToApp[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantApps" select="$relevantApps[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantAppsviaAPR" select="$relevantAppsviaAPR[name = $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
	<xsl:variable name="thisappsWithCapsfromAPR" select="$thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value union $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"></xsl:variable>  -->
{
"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
</xsl:call-template>",
"className":"<xsl:value-of select="current()/type"/>",
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
</xsl:call-template>",
"position":"<xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_index']/value"/>",
"order":"<xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_index']/value"/>",
"diffLevelIds":[
		<xsl:for-each select="$thisDiffLevels">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
	],
<xsl:for-each select="$allBusSlots"><xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="current()/name"/>":[<xsl:for-each select="$thisCap/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>,
"level":"<xsl:value-of select="$depth"/>","childrenCaps": [<xsl:if test="$depth &lt; 5"><xsl:apply-templates select="$subCaps" mode="busCapDetails"><xsl:with-param name="depth" select="$depth +1"/><xsl:sort order="ascending" select="own_slot_value[slot_reference='business_capability_index']/value"/></xsl:apply-templates></xsl:if>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template> 

<xsl:template match="node()" mode="busCapDetailsApps">
<xsl:variable name="thisCap" select="current()"/>
<xsl:variable name="relevantBusCaps" select="eas:get_cap_descendants(current(), $allBusCaps, 0, 10, 'supports_business_capabilities')"/>
<xsl:variable name="directBusProcs" select="key('busProcessKey',current()/name)"/>
<xsl:variable name="thisrelevantBusProcs" select="key('busProcessKey',$relevantBusCaps/name)"/>
<xsl:variable name="thisrelevantPhysProcs" select="key('physProcessKey',$thisrelevantBusProcs/name)"/> 
<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="key('physProcesstoAppKey',$thisrelevantPhysProcs/name)"/> 
<xsl:variable name="thisrelevantAppProRoles" select="key('indirectApptoProcessAPRAppsKey',$thisrelevantPhysProc2AppProRoles/name)"/> 
<!-- indirect Apps -->
<xsl:variable name="thisprocessToAppRel" select="key('indirectApptoServiceKey',$thisrelevantAppProRoles/name)"/> 
<!-- direct Apps -->
<xsl:variable name="thisdirectProcessToAppRel" select="key('directApptoProcessKey',$thisrelevantPhysProc2AppProRoles/name)"/> 
<xsl:variable name="thisappsWithCapsfromAPR" select="$thisprocessToAppRel union $thisdirectProcessToAppRel"/>
<!-- just for this cap -->
<xsl:variable name="thisonlyrelevantBusProcs" select="key('busProcessKey',current()/name)"/>
<xsl:variable name="thisonlyrelevantPhysProcs" select="key('physProcessKey',$thisonlyrelevantBusProcs/name)"/> 
<xsl:variable name="thisonlyrelevantPhysProc2AppProRoles" select="key('physProcesstoAppKey',$thisonlyrelevantPhysProcs/name)"/> 
<xsl:variable name="thisonlyrelevantAppProRoles" select="key('indirectApptoProcessAPRAppsKey',$thisonlyrelevantPhysProc2AppProRoles/name)"/> 
<!-- indirect Apps -->
<xsl:variable name="thisonlyprocessToAppRel" select="key('indirectApptoServiceKey',$thisonlyrelevantAppProRoles/name)"/> 
<!-- direct Apps -->
<xsl:variable name="thisonlydirectProcessToAppRel" select="key('directApptoProcessKey',$thisonlyrelevantPhysProc2AppProRoles/name)"/> 
<xsl:variable name="thisonlyappsWithCapsfromAPR" select="$thisonlyprocessToAppRel union $thisonlydirectProcessToAppRel"/>
<xsl:variable name="thisinfoConcepts" select="$infoConcepts[name=current()/own_slot_value[slot_reference = 'business_capability_requires_information']/value]"/> 

<!--	<xsl:variable name="directBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = current()/name]"></xsl:variable>
<xsl:variable name="thisrelevantBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisrelevantBusProcs/name]"></xsl:variable>
<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisrelevantPhysProcs/name]"></xsl:variable>
<xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[name = $thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
<xsl:variable name="thisprocessToAppRel" select="$processToAppRel[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $allAppProviders/name]"></xsl:variable>-->
<!--		<xsl:variable name="thisdirectProcessToAppRel" select="$directProcessToAppRel[name = $thisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
<xsl:variable name="thisdirectProcessToApp" select="$directProcessToApp[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="thisrelevantApps" select="$relevantApps[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
<xsl:variable name="thisrelevantAppsviaAPR" select="$relevantAppsviaAPR[name = $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
<xsl:variable name="thisappsWithCapsfromAPR" select="$thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value union $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value"></xsl:variable>  -->
<xsl:variable name="thisrelevantPhysProcsActors" select="$actors[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable><!--
<xsl:variable name="thisrelevantPhysProcsa2r" select="$thisrelevantPhysProcsActorsIndirect[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>-->
<xsl:variable name="thisrelevantPhysProcsa2r" select="key('physActKey',$thisrelevantPhysProcs/name)"></xsl:variable>

<xsl:variable name="thisrelevantPhysProcsActorsIn" select="$actors[name=$thisrelevantPhysProcsa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"></xsl:variable>
<xsl:variable name="allActors" select="$thisrelevantPhysProcsActors union $thisrelevantPhysProcsActorsIn"/>
<xsl:variable name="eaScopedOrgUserIds" select="$actors[name=$allActors/own_slot_value[slot_reference = 'ea_scope']/value]"/>
<xsl:variable name="eaScopedCapOrgUserIds" select="$actors[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]"/>
<xsl:variable name="thisOrgUsers2RoleSites" select="$allOrgUsers2RoleSites[name = $allActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	

<xsl:variable name="processSites" select="$allSites[name = $thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
<xsl:variable name="thisSites" select="$thisOrgUsers2RoleSites union $processSites"/>
<xsl:variable name="eaScopedGeoIds" select="$allGeo[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]"/>
<xsl:variable name="siteGeos" select="$allGeo[name=$thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/> 
<xsl:variable name="allGeos" select="$eaScopedGeoIds union $siteGeos"/>
<xsl:variable name="siteGeosviaLoc" select="$allGeo[own_slot_value[slot_reference = 'gr_locations']/value=$allGeos/name]"/>
<xsl:variable name="siteCountries" select="$siteGeos[type='Geographic_Region'] union $siteGeosviaLoc"/>
<xsl:variable name="thisProductConcepts" select="$productConcepts[own_slot_value[slot_reference='product_concept_supported_by_capability']/value=current()/name]/name"/>
<xsl:variable name="taxTerms" select="key('taxTerm', current()/name)"/>
{
"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param></xsl:call-template>",
"className":"<xsl:value-of select="current()/type"/>",
"index":"<xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_index']/value"/>",
"isRoot":"<xsl:value-of select="current()/own_slot_value[slot_reference='is_root']/value"/>",
<xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
}" />
<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<!-- note these are all processes for this capability and its children -->
"allProcesses":[<xsl:for-each select="$thisrelevantBusProcs">
<xsl:variable name="criticality" select="$criticalityStatus[name=current()/own_slot_value[slot_reference = ('bpt_business_criticality')]/value]"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'criticality': string(translate(translate($criticality/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')'))
}" />
<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
  "criticalityId":"<xsl:value-of select="eas:getSafeJSString($criticality/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<!-- note these are direct processes for this capability only, not children.  make directBusProcs thisrelevantBusProcs to change -->
"infoConcepts":[<xsl:for-each select="$thisinfoConcepts"> 
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
"processes":[<xsl:for-each select="$directBusProcs">
<xsl:variable name="thisProcessrelevantPhysProcs" select="key('physProcessKey', current()/name)"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
}" />
<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<!-- note these are all processes for this capability only, including children -->
"physP":[<xsl:for-each select="$thisProcessrelevantPhysProcs">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
"physP":[<xsl:for-each select="$thisrelevantPhysProcs">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
"classifications":[<xsl:for-each select="$taxTerms"><xsl:variable name="thisTax" select="key('taxonomy', current()/name)"/>{"id":"<xsl:value-of select="current()/name"/>",
<xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'taxonomy': string(translate(translate($thisTax/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
}" />
  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
"orgUserIds": [<xsl:for-each select="$allActors union $eaScopedOrgUserIds union $eaScopedCapOrgUserIds">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
"domainIds":[<xsl:for-each select="distinct-values(current()/own_slot_value[slot_reference='belongs_to_business_domain']/value union current()/own_slot_value[slot_reference='belongs_to_business_domains']/value)">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
"prodConIds": [<xsl:for-each select="$thisProductConcepts">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
"geoIds": [<xsl:for-each select="$siteCountries">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
<xsl:for-each select="$allBusSlots"><xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="current()/name"/>":[<xsl:for-each select="$thisCap/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>,	
"thisapps":[<xsl:for-each select="$thisonlyappsWithCapsfromAPR">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
"apps":[<xsl:for-each select="$thisappsWithCapsfromAPR">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
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
<xsl:function name="eas:get_cap_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeOrgs"/>
		<xsl:param name="level"/>
		<xsl:param name="maxDepth"/>
		<xsl:param name="slotName"/>
		<xsl:sequence select="$parentNode"/>
		<xsl:if test="$level &lt; $maxDepth">
		 <xsl:variable name="childOrgs" select="$inScopeOrgs[own_slot_value[slot_reference = $slotName]/value = $parentNode/name]" as="node()*"/> 
			<xsl:for-each select="$childOrgs">
				<xsl:sequence select="eas:get_object_descendants(current(), ($inScopeOrgs), $level + 1, $maxDepth, $slotName)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>

	<xsl:template mode="createFilterJSON" match="node()">	
		<xsl:variable name="thisSlot" select="$busSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
		<xsl:variable name="releventEnums" select="/node()/simple_instance[type = current()/name]"/> 
		{"id": "<xsl:value-of select="current()/name"/>",
		"name": "<xsl:value-of select="translate(current()/name, '_',' ')"/>",
		"valueClass": "<xsl:value-of select="current()/name"/>",
		"description": "",
		"slotName":"<xsl:value-of select="$thisSlot/name"/>",
		"isGroup": false,
		"icon": "fa-circle",
		"color":"hsla(25, 52%, 38%, 1)",
		"values": [
		<xsl:for-each select="$releventEnums"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", <xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'enum_name': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"sequence":"<xsl:value-of select="own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
		"backgroundColor":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
		"colour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
		<!-- bus model info -->

<xsl:template match="node()" mode="busModConfigs">
    <xsl:variable name="thisActors" select="$groupActors[name=current()/own_slot_value[slot_reference='bmc_org_scope']/value]"/>
    <xsl:variable name="thisBM" select="key('BusModels', current()/own_slot_value[slot_reference='bmc_for_business_model']/value)"/>
	<!--
    <xsl:variable name="thisBM" select="$BusModels[name=current()/own_slot_value[slot_reference='bmc_for_business_model']/value]"/>-->
	{  
	    "id":"<xsl:value-of select="current()/name"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
			'model': string(translate(translate($thisBM/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'label': string(translate(translate(current()/own_slot_value[slot_reference = ('bmc_label')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
            'org1':string(translate(translate($thisActors[1]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'org2':string(translate(translate($thisActors[2]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'org3':string(translate(translate($thisActors[3]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'org4':string(translate(translate($thisActors[4]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'org5':string(translate(translate($thisActors[5]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'org6':string(translate(translate($thisActors[6]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> 
	 }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="ariSheet">
    <xsl:variable name="thisActors" select="$groupActors[name=current()/own_slot_value[slot_reference='sm_organisational_scope']/value]"/>
  
	{  
	    "id":"<xsl:value-of select="current()/name"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
			'org1': string(translate(translate($thisActors[1]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'org2': string(translate(translate($thisActors[2]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'org3': string(translate(translate($thisActors[3]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'org4': string(translate(translate($thisActors[4]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'org5': string(translate(translate($thisActors[5]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'org6': string(translate(translate($thisActors[6]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
	 }<xsl:if test="position()!=last()">,</xsl:if>

</xsl:template>
<xsl:template match="node()" mode="aritSheet">
    <xsl:variable name="thisari" select="key('aritARI', current()/name)"/>
    <xsl:variable name="usagesFrom" select="key('aritARITypes', current()/own_slot_value[slot_reference=':FROM']/value)"/>
    <xsl:variable name="aprFrom" select="key('aritARIAPRs', $usagesFrom/own_slot_value[slot_reference='apru_usage_of_application_provider']/value)"/>
 
    <xsl:variable name="usagesTo" select="key('aritARITypes', current()/own_slot_value[slot_reference=':TO']/value)"/>
    <xsl:variable name="aprTo" select="key('aritARIAPRs',$usagesTo/own_slot_value[slot_reference='apru_usage_of_application_provider']/value)"/>
{
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate($thisari/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'from': string(translate(translate($aprFrom/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'to': string(translate(translate($aprTo/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="brcSheet">
     
    <!--<xsl:variable name="thisari" select="key('aritARI', current()/name)"/>-->
    <xsl:variable name="usagesFrom" select="key('BRACUTypes', current()/own_slot_value[slot_reference=':FROM']/value)"/>
    <xsl:variable name="bracFrom" select="key('busRefKey', $usagesFrom/own_slot_value[slot_reference='bracu_usage_of_business_reference_architecture']/value)"/>
    <xsl:variable name="usagesTo" select="key('ARICUTypes', current()/own_slot_value[slot_reference=':TO']/value)"/>
    <xsl:variable name="ariTo" select="key('aritARIName', $usagesTo/own_slot_value[slot_reference='aricu_usage_of_application_reference_implementation']/value)"/>
    <xsl:variable name="thisbrac" select="key('BRACname', current()/own_slot_value[slot_reference='bmc_relation_in_business_model_config_architecture']/value)"/>
    <xsl:variable name="thisbrconfig" select="$BusModelConfigurations[name=$thisbrac/own_slot_value[slot_reference='architecture_of_business_model_configuration']/value]"/>

    <xsl:variable name="thisBM" select="key('BusModels', $thisbrconfig/own_slot_value[slot_reference='bmc_for_business_model']/value)"/>
 <!--
  <xsl:variable name="thisBM" select="$BusModels[name=$thisbrconfig/own_slot_value[slot_reference='bmc_for_business_model']/value]"/>
 <xsl:variable name="aprTo" select="key('aritARIAPRs',$usagesTo/own_slot_value[slot_reference='apru_usage_of_application_provider']/value)"/>
 
       bracu_usage_of_business_reference_architecture  busRefArch
       aritARIName
 -->
{ 
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate($thisBM/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'from': string(translate(translate($bracFrom/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'to': string(translate(translate($ariTo/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="busProArchSheet">
    
    <xsl:variable name="thisBusCap" select="key('BusCapsKey', current()/own_slot_value[slot_reference='bmbu_used_business_capability']/value)"/>
    <xsl:variable name="thisBusModelArch" select="key('BusModelArchname',current()/own_slot_value[slot_reference='used_in_business_model_architecture']/value)"/>
	
	<xsl:variable name="thisBusModels" select="key('BusModels', $thisBusModelArch/own_slot_value[slot_reference='architecture_of_business_model']/value)"/>
	<!--
    <xsl:variable name="thisBusModels" select="$BusModels[name=$thisBusModelArch/own_slot_value[slot_reference='architecture_of_business_model']/value]"/>-->
    
    {  
         <xsl:variable name="combinedMap" as="map(*)" select="map{
			'model': string(translate(translate($thisBusModels/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'leafBC': string(translate(translate($thisBusCap/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="busProtoArchSheet">
    <xsl:variable name="thisProc" select="key('BPKey', current()/own_slot_value[slot_reference='bpru_usage_of_business_process']/value)"></xsl:variable>
    <xsl:variable name="thisBRA" select="key('busRefKey', current()/own_slot_value[slot_reference='bramt_used_in_business_reference_architecture']/value)"></xsl:variable>
    { 
        <xsl:variable name="combinedMap" as="map(*)" select="map{
			'refArch': string(translate(translate($thisBRA/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'process': string(translate(translate($thisProc/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
   }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="busMods">
    <!--<xsl:variable name="thisBusDomain" select="$BusDomains[name=current()/own_slot_value[slot_reference='bm_business_domain']/value]"/>-->
	{ 
	    "id":"<xsl:value-of select="current()/name"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'domain': string(translate(translate(current()/own_slot_value[slot_reference = ('bm_business_domain')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		<!--     "domain":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBusDomain"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"-->
	 }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="aprs">
	{"id":"<xsl:value-of select="current()/name"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"role":"<xsl:value-of select="current()/own_slot_value[slot_reference = ('implementing_application_service')]/value"/>",
	"application":"<xsl:value-of select="current()/own_slot_value[slot_reference = ('role_for_application_provider')]/value"/>"
	<!--     "domain":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBusDomain"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"-->
 }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
