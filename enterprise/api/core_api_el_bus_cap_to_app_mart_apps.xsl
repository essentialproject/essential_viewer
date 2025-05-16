<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="param1"/> 
<!--<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"></xsl:variable>
<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"></xsl:variable>
<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"></xsl:variable>
<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"></xsl:variable>-->
<xsl:variable name="appClass" select="/node()/class[name = ('Application_Provider','Application_Provider_Type','Composite_Application_Provider')]" />
<xsl:variable name="appSlots" select="/node()/slot[name = $appClass/template_slot]" /> 
<xsl:variable name="parentEnumClass" select="/node()/class[superclass = 'Enumeration']" />
<xsl:variable name="subEnumClass" select="/node()/class[superclass = $parentEnumClass/name]" />
<xsl:variable name="enumClass" select="$parentEnumClass union $subEnumClass" />
<xsl:variable name="targetSlots" select="$appSlots/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value[2]"/>
<xsl:variable name="allAppSlotsBoo" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value='Boolean']"/> 
<xsl:variable name="allAppSlots" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=$enumClass/name]"/> 
<xsl:variable name="allEnumClass" select="$enumClass[name=$targetSlots]"/> 

<xsl:key name="directAppKey" match="simple_instance[type=('Application_Provider','Composite_Application_Provider')]" use="type" />
<xsl:variable name="allAppProviders" select="key('directAppKey', ('Composite_Application_Provider','Application_Provider'))" />
<xsl:key name="appAppProvidersKey" match="$allAppProviders" use="name"/>
<xsl:variable name="allAPIs" select="/node()/simple_instance[(type = 'Application_Provider_Interface')]"></xsl:variable>
 
<xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &gt; -1) or not(own_slot_value[slot_reference='enumeration_sequence_number']/value)]"/>
<xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>
<xsl:key name="allElementStyles" match="/node()/simple_instance[type = 'Element_Style']" use="name"/>
<xsl:key name="relevantBusProcsKey" match="simple_instance[type=('Business_Process')]" use="type" />
<xsl:variable name="relevantBusProcs" select="key('relevantBusProcsKey', ('Business_Process'))" />
 
<xsl:key name="physProcsKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
<xsl:variable name="relevantPhysProcs" select="key('physProcsKey', $relevantBusProcs/name)"></xsl:variable>
<!-- 
<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"></xsl:variable>
-->
<xsl:key name="relevantPhysProc2AppProRolesKey" match="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/> 
<!--<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"></xsl:variable>-->
<xsl:variable name="relevantPhysProc2AppProRoles" select="key('relevantPhysProc2AppProRolesKey', $relevantPhysProcs/name)"></xsl:variable>
<xsl:key name="aprProcessKey" match="/node()/simple_instance[type='Application_Provider_Role']" use="own_slot_value[slot_reference = 'app_pro_support_phys_proc']/value"/> 
<xsl:key name="compositeServices" match="/node()/simple_instance[type='Composite_Application_Service']" use="type"/>
 
<xsl:variable name="requirementStatus" select="/node()/simple_instance[type = 'Requirement_Status']"></xsl:variable>
<xsl:key name="actorsKey" match="simple_instance[type=('Group_Actor')]" use="type" />
<xsl:key name="actorNameKey" match="simple_instance[type=('Group_Actor')]" use="name" />
<xsl:variable name="actors" select="key('actorsKey', ('Group_Actor'))" />  
<xsl:key name="allSitesKey" match="simple_instance[type=('Site')]" use="type" />
<xsl:key name="allSitesNameKey" match="simple_instance[type=('Site')]" use="name" />
<xsl:variable name="allSites" select="key('allSitesKey', ('Site'))" /> 
<xsl:variable name="appTypesEnums" select="/node()/simple_instance[type='Application_Purpose']"/>
<xsl:variable name="relevantAppTypes" select="$appTypesEnums[name = $allAppProviders/own_slot_value[slot_reference = 'application_provider_purpose']/value]"></xsl:variable>

<xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"></xsl:variable>
<xsl:variable name="unitOfMeasures" select="/node()/simple_instance[type = 'Unit_Of_Measure']"></xsl:variable>
<xsl:variable name="criticalityStatus" select="/node()/simple_instance[type = 'Business_Criticality']"></xsl:variable>
<xsl:key name="a2rKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="type"/>
<xsl:variable name="a2r" select="key('a2rKey', 'ACTOR_TO_ROLE_RELATION')"></xsl:variable>
<xsl:key name="processActorKey" match="/node()/simple_instance[supertype = 'Actor']" use="own_slot_value[slot_reference='performs_physical_processes']/value"/>
<xsl:key name="processRoleKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference='performs_physical_processes']/value"/>
<xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"></xsl:variable>
<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"></xsl:variable>
<xsl:variable name="manualDataEntry" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/> 
<xsl:key name="allAppStaticUsages" match="/node()/simple_instance[type = 'Static_Application_Provider_Usage']" use="type"/>
<xsl:variable name="allAppStaticUsages" select="key('allAppStaticUsages', 'Static_Application_Provider_Usage')"/>
<xsl:key name="allAppStaticUsagesNameKey" match="key('allAppStaticUsages', 'Static_Application_Provider_Usage')" use="name"/>
 
<!--$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value
<xsl:variable name="allContained" select="$allAppProviders[name=$allAppProviders/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>-->
<xsl:variable name="allContained" select="key('appAppProvidersKey', $allAppProviders/own_slot_value[slot_reference = 'contained_application_providers']/value)"/>

<xsl:key name="static_usage_key" match="$allAppStaticUsages" use="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
<xsl:key name="family_key" match="/node()/simple_instance[type='Application_Family']" use="own_slot_value[slot_reference = 'groups_applications']/value"/>

<!--<xsl:variable name="allInboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':FROM']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
<xsl:variable name="allOutboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':TO']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>-->
<xsl:variable name="allGeosRegions" select="/node()/simple_instance[type='Geographic_Region']"/>
<xsl:variable name="allGeoLocs" select="/node()/simple_instance[type='Geographic_Location']"/> 
<xsl:variable name="allGeo" select="$allGeosRegions union $allGeoLocs"/> 
<xsl:key name="allGeo" match="/node()/simple_instance[type=('Geographic_Region','Geographic_Location')]" use="name"/> 
 <xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Application_Capability','Application_Service','Application_Provider','Composite_Application_Provider','Group_Actor','Business_Process','Physical_Process')]"></xsl:variable>
 <!-- rationalisation view -->

<xsl:variable name="regulationLink" select="/node()/simple_instance[type='REGULATED_COMPONENT_RELATION']"/> 
<xsl:key name="regulationLink_key" match="/node()/simple_instance[type='REGULATED_COMPONENT_RELATION']" use="own_slot_value[slot_reference = 'regulated_component_to_element']/value"/>
<xsl:variable name="regulation" select="/node()/simple_instance[type='Regulation']"/>   
<xsl:key name="regulation_key" match="/node()/simple_instance[type = 'Regulation']" use="name"/>
<xsl:key name="issue_key" match="/node()/simple_instance[type = 'Issue']" use="own_slot_value[slot_reference = 'related_application_elements']/value"/>
<xsl:key name="issue_keynew" match="/node()/simple_instance[type = 'Issue']" use="own_slot_value[slot_reference = 'sr_requirement_for_elements']/value"/>
<xsl:key name="BusCapsKey" match="/node()/simple_instance[type = 'Business_Capability']" use="name"/>

 <xsl:variable name="reportPath" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
 <xsl:variable name="reportPathInterface" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Information Dependency Model v2']"/>
 <xsl:key name="a2r_key" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
 <xsl:key name="a2rname_key" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
 <xsl:key name="physProcessActor_key" match="/node()/simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'process_performed_by_actor_role']/value"/>
 <xsl:key name="fromapu_key" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':FROM']/value"/>
 <xsl:key name="toapu_key" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':TO']/value"/>

 <xsl:variable name="allInboundStaticAppRels2" select="key('fromapu_key', $allAppStaticUsages/name)"/>
 <xsl:variable name="allOutboundStaticAppRels2" select="key('toapu_key', $allAppStaticUsages/name)"/>


 <xsl:variable name="allInboundStaticAppRels" select="$allInboundStaticAppRels2[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/> 
 <xsl:variable name="allOutboundStaticAppRels" select="$allOutboundStaticAppRels2[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/> 

 <xsl:key name="apr_key" match="/node()/simple_instance[type = 'Application_Provider_Role']" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
 <xsl:key name="aprBusRel_key" match="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
 <xsl:key name="appBusRelDirect_key" match="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/>
 <xsl:key name="physicalProcess_key" match="/node()/simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value"/>
 <xsl:key name="services_key" match="/node()/simple_instance[type = 'Application_Service']" use="own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
 <xsl:key name="subApps_key" match="/node()/simple_instance[type = 'Composite_Application_Provider']" use="own_slot_value[slot_reference = 'contained_application_providers']/value"/>

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
	"reports":[{"name":"appRat", "link":"<xsl:value-of select="$reportPath/own_slot_value[slot_reference='report_xsl_filename']/value"/>"},{"name":"appInterface", "link":"<xsl:value-of select="$reportPathInterface/own_slot_value[slot_reference='report_xsl_filename']/value"/>"}],
	"applications":[<xsl:apply-templates select="$allAppProviders" mode="applications"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"compositeServices":[<xsl:apply-templates select="key('compositeServices', 'Composite_Application_Service')" mode="compositeServices"></xsl:apply-templates>],
	"apis":[<xsl:apply-templates select="$allAPIs" mode="applications"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"lifecycles":[<xsl:apply-templates select="$allLifecycleStatus" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"codebase":[<xsl:apply-templates select="$codebase" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"delivery":[<xsl:apply-templates select="$delivery" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"filters":[<xsl:apply-templates select="$allEnumClass" mode="createFilterJSON"></xsl:apply-templates><xsl:if test="$allAppSlotsBoo">,<xsl:apply-templates select="$allAppSlotsBoo" mode="createBooleanFilterJSON"></xsl:apply-templates></xsl:if>],
	"version":"6152"
	}

</xsl:template>

<xsl:template match="node()" mode="applications">
<xsl:variable name="thisApp" select="current()"/>
<xsl:variable name="appLifecycle" select="$allLifecycleStatus[name = current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]"/>
<xsl:variable name="thisStyle" select="key('allElementStyles', $appLifecycle/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>  
<xsl:variable name="appDelivery" select="$delivery[name=current()/own_slot_value[slot_reference='ap_delivery_model']/value]"/>
<xsl:variable name="thisDepStyle" select="key('allElementStyles', $appDelivery/own_slot_value[slot_reference = 'element_styling_classes']/value)"/> <xsl:variable name="thisCodebase" select="$codebase[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]"/>
<xsl:variable name="thisCodebaseStyle" select="key('allElementStyles', $thisCodebase/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>  
<xsl:variable name="thisAppOrgUsers2Roles" select="key('a2rname_key',current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
<xsl:variable name="thiseveryAppOrgUsers2Roles" select="key('a2rname_key', current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
<xsl:variable name="thisOrgUserIds" select="key('actorNameKey', $thisAppOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
<xsl:variable name="eaScopedOrgUserIds" select="key('actorNameKey', current()/own_slot_value[slot_reference = 'ea_scope']/value)"/>

<xsl:variable name="thisAppTypes" select="$relevantAppTypes[name = current()/own_slot_value[slot_reference = 'application_provider_purpose']/value]"></xsl:variable>
<xsl:variable name="thisSitesUsed" select="key('allSitesNameKey', current()/own_slot_value[slot_reference = 'ap_site_access']/value)"/>

<xsl:variable name="subApps" select="key('appAppProvidersKey', current()/own_slot_value[slot_reference = 'contained_application_providers']/value)"/>
<xsl:variable name="subSubApps" select="key('appAppProvidersKey',$subApps/own_slot_value[slot_reference = 'contained_application_providers']/value)"/>
<xsl:variable name="allCurrentApps" select="current() union $subApps union $subSubApps"/>
<xsl:variable name="appStaticUsages" select="key('static_usage_key', $allCurrentApps/name)"/>

<xsl:variable name="appInboundStaticAppRelsall" select="key('fromapu_key', $appStaticUsages/name)"/>
<xsl:variable name="appInboundStaticAppRels" select="$appInboundStaticAppRelsall[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
<xsl:variable name="appOutboundStaticAppRelsall" select="key('toapu_key', $appStaticUsages/name)"/>
<xsl:variable name="appOutboundStaticAppRels" select="$appOutboundStaticAppRelsall[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
<xsl:variable name="appInboundStaticAppUsages" select="key('allAppStaticUsagesNameKey', $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value)"/>
<xsl:variable name="appInboundStaticApps" select="key('appAppProvidersKey', $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value)"/>
<xsl:variable name="appOutboundStaticAppUsages" select="key('allAppStaticUsagesNameKey', $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value)"/>
<xsl:variable name="appOutboundStaticApps" select="key('appAppProvidersKey', $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value)"/>
<xsl:variable name="stakeApp" select="key('appStakeholder_key',current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
<xsl:variable name="aprKey" select="key('apr_key',current()/name)"/>
<xsl:variable name="aprBusRelkey" select="key('aprBusRel_key',$aprKey/name)"/>
<xsl:variable name="appBusRelDirectkey" select="key('appBusRelDirect_key',current()/name)"/>
<xsl:variable name="allProcessedLinkedToApps" select="$aprBusRelkey union $appBusRelDirectkey"/>
<xsl:variable name="physicalProcesskey" select="key('physicalProcess_key',$allProcessedLinkedToApps/name)"/>
<xsl:variable name="thisrelevantActorsIndirect" select="key('processRoleKey',$physicalProcesskey/name)"></xsl:variable>
<xsl:variable name="thisrelevantActorsDirect" select="key('processActorKey',$physicalProcesskey/name)"></xsl:variable>
<xsl:variable name="thisrelevantActorsforA2R" select="key('actorNameKey', $thisrelevantActorsIndirect/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"></xsl:variable>
<xsl:variable name="allPhysicalProcessActors" select="$thisrelevantActorsforA2R union $thisrelevantActorsDirect"/>

<xsl:variable name="processSites" select="key('allSitesNameKey', $physicalProcesskey/own_slot_value[slot_reference = 'process_performed_at_sites']/value)"/>
<xsl:variable name="allOrgUserIds" select="distinct-values($eaScopedOrgUserIds/name union $thisOrgUserIds/name union $allPhysicalProcessActors/name)"/> 
<xsl:variable name="allOrgUsers" select="$eaScopedOrgUserIds union $thisOrgUserIds union $allPhysicalProcessActors"/>  
<xsl:variable name="OrgUsers2Sites" select="key('allSitesNameKey',  $allOrgUsers/own_slot_value[slot_reference = 'actor_based_at_site']/value)"/>
<xsl:variable name="thisSites" select="$thisSitesUsed union $OrgUsers2Sites union $processSites"/>	
<xsl:variable name="eaScopedGeoIds" select="$allGeo[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]"/> 
<xsl:variable name="siteGeos" select="$allGeo[name=$thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
<xsl:variable name="siteGeosviaLoc" select="$allGeo[own_slot_value[slot_reference = 'gr_locations']/value=$siteGeos/name]"/>
<xsl:variable name="siteCountries" select="$siteGeos[type='Geographic_Region'] union $siteGeosviaLoc union $eaScopedGeoIds"/>
<xsl:variable name="appFamilies" select="key('family_key', current()/name)"/>
<xsl:variable name="thisRegLink" select="key('regulationLink_key', current()/name)"/>
<xsl:variable name="thisRegs" select="key('regulation_key', $thisRegLink/own_slot_value[slot_reference = 'regulated_component_regulation']/value)"/>
<xsl:variable name="thisOldIssues" select="key('issue_key', current()/name)"/>
<xsl:variable name="thisNewIssues" select="key('issue_keynew', current()/name)"/>
<xsl:variable name="thisIssues" select="$thisNewIssues union $thisOldIssues"/>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"class":"<xsl:value-of select="current()/type"/>",
		"className":"<xsl:value-of select="current()/type"/>",
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
		"children":[<xsl:for-each select="current()/own_slot_value[slot_reference='contained_application_providers']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"family":[<xsl:for-each select="$appFamilies">
            {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		    <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
                }"/>
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
           <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"regulations":[<xsl:for-each select="$thisRegs">
            {	
                "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
                <xsl:variable name="combinedMap" as="map(*)" select="map{
                    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
                    'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
                }" />
                <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
                  <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
            "className":"<xsl:value-of select="current()/type"/>"
            }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"issues":[<xsl:for-each select="$thisIssues">
			<xsl:variable name="thisrequirementStatus" select="$requirementStatus[name=current()/own_slot_value[slot_reference='requirement_status']/value]"/>	
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
            <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
                'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
            }" />
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
            <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
        "className":"<xsl:value-of select="current()/type"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
            'status': string(translate(translate($thisrequirementStatus/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
            }"/>
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
       <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> 
		 }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"inI":"<xsl:value-of select="count($appInboundStaticApps)"/>",
		"inDataCount":[<xsl:for-each select="$appInboundStaticAppRels/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"inIList":[<xsl:for-each select="$appInboundStaticApps">{
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
            }"/>
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		
       <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"outI":"<xsl:value-of select="count($appOutboundStaticApps)"/>",  
		<xsl:if test="$allContained[name=current()/name]">"containedApp":"Y",</xsl:if> 
		<xsl:if test="own_slot_value[slot_reference='parent_application_provider']/value">"containedApp":"Y",</xsl:if>
		"valueClass": "<xsl:value-of select="current()/type"/>",
		"dispositionId":"<xsl:value-of select="own_slot_value[slot_reference='ap_disposition_lifecycle_status']/value"/>",
		"outIList":[<xsl:for-each select="$appOutboundStaticApps">{ <xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
            }"/>
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
       <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>  , "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],	
		"outDataCount":[<xsl:for-each select="$appOutboundStaticAppRels/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], 
		"criticality":"<xsl:value-of select="$criticalityStatus[name=current()/own_slot_value[slot_reference='ap_business_criticality']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"type":"<xsl:if test="$thisAppTypes"><xsl:choose><xsl:when test="count($thisAppTypes) &gt; 1"><xsl:for-each select="$thisAppTypes"><xsl:choose><xsl:when test="contains(current()/own_slot_value[slot_reference = 'enumeration_value']/value,'Business')"><xsl:value-of select="$thisAppTypes[contains(own_slot_value[slot_reference = 'enumeration_value']/value,'Business')]/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:when></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise><xsl:value-of select="$thisAppTypes[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/></xsl:otherwise></xsl:choose></xsl:if>",
		"typeid":"<xsl:choose><xsl:when test="count($thisAppTypes) &gt; 1"><xsl:for-each select="$thisAppTypes">
		<xsl:choose><xsl:when test="contains(current()/own_slot_value[slot_reference = 'enumeration_value']/value,'Business')"><xsl:value-of select="eas:getSafeJSString($thisAppTypes[contains(own_slot_value[slot_reference = 'enumeration_value']/value,'Business')]/name)"/></xsl:when></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise><xsl:value-of select="eas:getSafeJSString($thisAppTypes[1]/name)"/></xsl:otherwise></xsl:choose>",
		"orgUserIds": [<xsl:for-each select="$allOrgUserIds">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"geoIds": [<xsl:for-each select="$siteCountries">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"siteIds":[<xsl:for-each select="$thisSites">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"codebaseID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
		"deliveryID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
		"sA2R":[<xsl:for-each select="$thiseveryAppOrgUsers2Roles">"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"ms_managed_app_elements":[<xsl:for-each select="current()/own_slot_value[slot_reference='ms_managed_app_elements']/value">"<xsl:value-of select="."></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], 
		
		"lifecycle":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value)"/>",
		"physP":[<xsl:for-each select="$physicalProcesskey">"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		<!-- extended services to include name and apr, was previously just id, renamed old Id to allServicesIdOnly -->
		"allServicesIdOnly":[<xsl:for-each select="current()/own_slot_value[slot_reference='provides_application_services']/value">
		 { 
		 "id": "<xsl:value-of select="eas:getSafeJSString(.)"></xsl:value-of>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		 <xsl:variable name="aprs" select="key('apr_key',current()/name)"/>
		 "allServices":[<xsl:for-each select="$aprs"><xsl:variable name="thisserviceskey" select="key('services_key',current()/name)"/>
		 { 
		 "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>",
		 "lifecycleId": "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apr_lifecycle_status']/value)"></xsl:value-of>",
		 "serviceId": "<xsl:value-of select="eas:getSafeJSString($thisserviceskey/name)"></xsl:value-of>",
		 "className":"<xsl:value-of select="current()/type"/>",
         <xsl:variable name="combinedMap" as="map(*)" select="map{
            'serviceName': string(translate(translate($thisserviceskey/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
            }"/> <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
       	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> , 
		"capabilities":[<xsl:for-each select="$thisserviceskey/own_slot_value[slot_reference='realises_application_capabilities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$thisserviceskey"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		 <xsl:for-each select="$allAppSlots"><xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="current()/name"/>":[<xsl:for-each select="$thisApp/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>,	 
		<xsl:if test="$allAppSlotsBoo">
			<xsl:for-each select="$allAppSlotsBoo">
				<xsl:variable name="slt" select="current()/name"/>"<xsl:value-of select="current()/name"/>":[
				<xsl:choose>
					<xsl:when test="$thisApp/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="$thisApp/own_slot_value[slot_reference=$slt]/value"/>"
					</xsl:when>
					<xsl:otherwise>"none"</xsl:otherwise>
				</xsl:choose>
				]<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>,
		</xsl:if>
		 <!--services supporting processes -->
		"services":[<xsl:for-each select="$aprKey[name=$aprBusRelkey/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]">
			<xsl:variable name="serviceskey" select="key('services_key',current()/name)"/>
			{"id": "<xsl:value-of select="eas:getSafeJSString($serviceskey/name)"></xsl:value-of>",  
            <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate($serviceskey/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
                }"/>
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
           <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$serviceskey"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
	</xsl:template>

<xsl:template match="node()" mode="fitValues">
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
        <xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
            }"/>
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
       <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"shortname":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/>",
		"colour":"<xsl:value-of select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]/own_slot_value[slot_reference='element_style_colour']/value"/>",
		"value":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"></xsl:value-of>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	
   
	<xsl:template match="node()" mode="criticalityOptions">
	<option><xsl:attribute name="value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"></xsl:value-of></xsl:attribute><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></option>
	
	</xsl:template>
	<xsl:template match="node()" mode="actorOptions">
	<option><xsl:attribute name="value"><xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of></xsl:attribute><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></option>
	</xsl:template>
	<xsl:template match="node()" mode="lifes">
		<xsl:variable name="thisStyle" select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","shortname":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'enumeration_value']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></xsl:otherwise></xsl:choose>","colour":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		"colourText":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	
	<xsl:template match="node()" mode="checks">
		<xsl:variable name="thisname" select="current()/own_slot_value[slot_reference='name']/value"/>
		<input type="checkbox" class="appScope"><xsl:attribute name="id"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>
			<xsl:choose><xsl:when test="contains($thisname,'Business')"><xsl:attribute name="checked"></xsl:attribute></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose> 
		</input><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>
  		 
	</xsl:template>	

 
	<xsl:function name="eas:get_inbound_int_count" as="xs:integer">
			<xsl:param name="app"/>
		<!--	<xsl:variable name="appStaticUsages" select="key('static_usage_key', $app/name)"/>
			 <xsl:variable name="appInboundStaticAppRels" select="key('toapu_key', $appStaticUsages/name)"/>-->
	 		<!-- <xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>  -->
			 <xsl:variable name="appStaticUsages" select="key('static_usage_key', own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name)"/>
			 <!--
	 		<xsl:variable name="appInboundStaticAppRels" select="$allInboundStaticAppRels[(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name)]"/>-->
			 <xsl:variable name="appInboundStaticAppRels">
				<xsl:for-each select="key('fromapu_key', $appStaticUsages/name)">
				  <xsl:if test="not(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name)">
					<xsl:copy-of select="."/>
				  </xsl:if>
				</xsl:for-each>
			  </xsl:variable>
			  
			 
		<!--	<xsl:variable name="appInboundStaticAppUsages" select="$allAppStaticUsages[name = $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value]"/>-->
			<xsl:variable name="appInboundStaticAppUsages" select="key('allAppStaticUsagesNameKey', $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value)"/>
			
			<!--
			<xsl:variable name="appInboundStaticApps" select="$allAppProviders[name = $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>-->
			<xsl:variable name="appInboundStaticApps" select="key('appAppProvidersKey', $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value)"/>
			<xsl:variable name="inboundRelCount" select="count($appInboundStaticApps)"/>
	
			<xsl:value-of select="$inboundRelCount"/>
	
		</xsl:function>
	
		<xsl:function name="eas:get_outbound_int_count" as="xs:integer">
			<xsl:param name="app"/>
	<!--
			<xsl:variable name="appStaticUsages" select="$allAppStaticUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $app/name]"/>-->
			<xsl:variable name="appStaticUsages" select="key('static_usage_key', $app/name)"/>
		<!--	<xsl:variable name="appOutboundStaticAppRels" select="$allOutboundStaticAppRels[(own_slot_value[slot_reference = ':TO']/value = $appStaticUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name)]"/>-->
			<xsl:variable name="appOutboundStaticAppRels">
				<xsl:for-each select="key('toapu_key', $appStaticUsages/name)">
				  <xsl:if test="not(own_slot_value[slot_reference = ':FROM']/value = $appStaticUsages/name)">
					<xsl:copy-of select="."/>
				  </xsl:if>
				</xsl:for-each>
			  </xsl:variable>
			<!--<xsl:variable name="appStaticUsages" select="key('static_usage_key', $app/name)"/>
			<xsl:variable name="appOutboundStaticAppRels" select="key('fromapu_key', $appStaticUsages/name)"/>-->
			<xsl:variable name="appOutboundStaticAppUsages" select="key('allAppStaticUsagesNameKey', $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value)"/>
<!--			<xsl:variable name="appOutboundStaticApps" select="$allAppProviders[name = $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>-->
			<xsl:variable name="appOutboundStaticApps" select="key('appAppProvidersKey', $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value)"/>
			
			<xsl:variable name="outboundRelCount" select="count($appOutboundStaticApps)"/>
	
			<xsl:value-of select="$outboundRelCount"/>
	
		</xsl:function>	
		
		<xsl:template match="node()" mode="classMetaData"> 
				<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
				{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>

		<xsl:template mode="createFilterJSON" match="node()">	
		<xsl:variable name="thisSlot" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
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
				<xsl:variable name="thisSlot" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
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
<xsl:template match="node()" mode="compositeServices">
	{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
        }"/>
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
   <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
	"containedService":[<xsl:for-each select="current()/own_slot_value[slot_reference='composed_of_application_services']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

</xsl:stylesheet>
