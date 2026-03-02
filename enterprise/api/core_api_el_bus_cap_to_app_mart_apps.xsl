<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:include href="../../common/core_utilities.xsl"/>
<xsl:include href="../../common/core_js_functions.xsl"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:param name="param1"/> 

<!-- Global Keys for performance -->
<xsl:key name="instancesByType" match="simple_instance" use="type"/>
<xsl:key name="instanceByName" match="simple_instance" use="name"/>
<xsl:key name="classByName" match="class" use="name"/>
<xsl:key name="slotsByType" match="slot" use="own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value"/>
<xsl:key name="geoByLocation" match="simple_instance[type='Geographic_Region']" use="own_slot_value[slot_reference='gr_locations']/value"/>

<xsl:variable name="KB" select="/node()"/>

<xsl:variable name="appClass" select="$KB/class[name='Application_Provider' or name='Application_Provider_Type' or name='Composite_Application_Provider']" />
<xsl:variable name="appSlots" select="$KB/slot[name = $appClass/template_slot]" /> 
<xsl:variable name="parentEnumClass" select="$KB/class[superclass = 'Enumeration']" />
<xsl:variable name="subEnumClass" select="$KB/class[superclass = $parentEnumClass/name]" />
<xsl:variable name="enumClass" select="$parentEnumClass union $subEnumClass" />
<xsl:variable name="targetSlots" select="$appSlots/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value[2]"/>
<xsl:variable name="allAppSlotsBoo" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value='Boolean']"/> 
<xsl:variable name="allAppSlots" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=$enumClass/name]"/> 
<xsl:variable name="allEnumClass" select="$enumClass[name=$targetSlots]"/> 

<xsl:variable name="allAppProviders" select="key('instancesByType', ('Application_Provider', 'Composite_Application_Provider'), $KB)" />
<xsl:variable name="allAPIs" select="key('instancesByType', 'Application_Provider_Interface', $KB)" />
<xsl:variable name="allLifecycleStatus" select="key('instancesByType', 'Lifecycle_Status', $KB)"/>
<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &gt; -1) or not(own_slot_value[slot_reference='enumeration_sequence_number']/value)]"/>
<xsl:variable name="allElementStyles" select="key('instancesByType', 'Element_Style', $KB)"/>
<xsl:key name="allElementStyles" match="simple_instance[type = 'Element_Style']" use="name"/>

<xsl:variable name="relevantBusProcs" select="key('instancesByType', 'Business_Process', $KB)" />
<xsl:key name="physProcsKey" match="simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
<xsl:variable name="relevantPhysProcs" select="key('physProcsKey', $relevantBusProcs/name, $KB)"></xsl:variable>

<xsl:key name="relevantPhysProc2AppProRolesKey" match="simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/> 
<xsl:variable name="relevantPhysProc2AppProRoles" select="key('relevantPhysProc2AppProRolesKey', $relevantPhysProcs/name, $KB)"></xsl:variable>

<xsl:key name="aprProcessKey" match="simple_instance[type='Application_Provider_Role']" use="own_slot_value[slot_reference = 'app_pro_support_phys_proc']/value"/> 
<xsl:key name="compositeServices" match="simple_instance[type='Composite_Application_Service']" use="type"/>

<xsl:variable name="requirementStatus" select="key('instancesByType', 'Requirement_Status', $KB)"></xsl:variable>
<xsl:key name="actorsKey" match="simple_instance[type='Group_Actor']" use="type" />
<xsl:key name="actorNameKey" match="simple_instance[type='Group_Actor']" use="name" />
<xsl:variable name="actors" select="key('instancesByType', 'Group_Actor', $KB)" />  

<xsl:key name="allSitesKey" match="simple_instance[type='Site']" use="type" />
<xsl:key name="allSitesNameKey" match="simple_instance[type='Site']" use="name" />
<xsl:variable name="allSites" select="key('instancesByType', 'Site', $KB)" /> 

<xsl:variable name="appTypesEnums" select="key('instancesByType', 'Application_Purpose', $KB)"/>

<xsl:variable name="style" select="$allElementStyles"></xsl:variable>
<xsl:variable name="unitOfMeasures" select="key('instancesByType', 'Unit_Of_Measure', $KB)"></xsl:variable>
<xsl:variable name="criticalityStatus" select="key('instancesByType', 'Business_Criticality', $KB)"></xsl:variable>

<xsl:key name="a2rKey" match="simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="type"/>
<xsl:variable name="a2r" select="key('a2rKey', 'ACTOR_TO_ROLE_RELATION', $KB)"></xsl:variable>

<xsl:key name="processActorKey" match="simple_instance[supertype = 'Actor']" use="own_slot_value[slot_reference='performs_physical_processes']/value"/>
<xsl:key name="processRoleKey" match="simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference='performs_physical_processes']/value"/>

<xsl:variable name="delivery" select="key('instancesByType', 'Application_Delivery_Model', $KB)"></xsl:variable>
<xsl:variable name="codebase" select="key('instancesByType', 'Codebase_Status', $KB)"></xsl:variable>
<xsl:variable name="manualDataEntry" select="key('instanceByName', 'Manual Data Entry', $KB)"/> 

<xsl:key name="allAppStaticUsagesKey" match="simple_instance[type = 'Static_Application_Provider_Usage']" use="type"/>
<xsl:variable name="allAppStaticUsages" select="key('allAppStaticUsagesKey', 'Static_Application_Provider_Usage', $KB)"/>
<xsl:key name="allAppStaticUsagesNameKey" match="simple_instance[type='Static_Application_Provider_Usage']" use="name"/>

<xsl:variable name="allContained" select="key('instanceByName', $allAppProviders/own_slot_value[slot_reference = 'contained_application_providers']/value, $KB)"/>
<xsl:key name="static_usage_key" match="simple_instance[type='Static_Application_Provider_Usage']" use="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
<xsl:key name="family_key" match="simple_instance[type='Application_Family']" use="own_slot_value[slot_reference = 'groups_applications']/value"/>
<xsl:key name="familyKeyByType" match="simple_instance[type='Application_Family']" use="type"/>
 
<xsl:key name="static_usage_key" match="$allAppStaticUsages" use="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
<xsl:key name="family_key" match="/node()/simple_instance[type='Application_Family']" use="own_slot_value[slot_reference = 'groups_applications']/value"/>
<xsl:key name="family_keyType" match="/node()/simple_instance[type='Application_Family']" use="type"/>

<xsl:variable name="allGeosRegions" select="key('instancesByType', 'Geographic_Region', $KB)"/>
<xsl:variable name="allGeoLocs" select="key('instancesByType', 'Geographic_Location', $KB)"/> 
<!--<xsl:variable name="allInboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':FROM']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
<xsl:variable name="allOutboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':TO']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>-->
 
<xsl:variable name="allGeo" select="$allGeosRegions union $allGeoLocs"/> 
<xsl:key name="allGeo" match="simple_instance[type=('Geographic_Region','Geographic_Location')]" use="name"/> 

<xsl:variable name="reportMenu" select="key('instancesByType', 'Report_Menu', $KB)[own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Application_Capability','Application_Service','Application_Provider','Composite_Application_Provider','Group_Actor','Business_Process','Physical_Process')]"></xsl:variable>

<xsl:variable name="regulationLink" select="key('instancesByType', 'REGULATED_COMPONENT_RELATION', $KB)"/> 
<xsl:key name="regulationLink_key" match="simple_instance[type='REGULATED_COMPONENT_RELATION']" use="own_slot_value[slot_reference = 'regulated_component_to_element']/value"/>
<xsl:variable name="regulation" select="key('instancesByType', 'Regulation', $KB)"/>   
<xsl:key name="regulation_key" match="simple_instance[type = 'Regulation']" use="name"/>
<xsl:key name="issue_key" match="simple_instance[type = 'Issue']" use="own_slot_value[slot_reference = 'related_application_elements']/value"/>
<xsl:key name="issue_keynew" match="simple_instance[type = 'Issue']" use="own_slot_value[slot_reference = 'sr_requirement_for_elements']/value"/>
<xsl:key name="BusCapsKey" match="simple_instance[type = 'Business_Capability']" use="name"/>

<xsl:variable name="reportPath" select="key('instancesByType', 'Report', $KB)[own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
<xsl:variable name="reportPathInterface" select="key('instancesByType', 'Report', $KB)[own_slot_value[slot_reference='name']/value='Core: Application Information Dependency Model v2']"/>

<xsl:key name="a2r_key" match="simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
<xsl:key name="a2rname_key" match="simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
<xsl:key name="physProcessActor_key" match="simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'process_performed_by_actor_role']/value"/>
<xsl:key name="fromapu_key" match="simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':FROM']/value"/>
<xsl:key name="toapu_key" match="simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':TO']/value"/>

<xsl:variable name="manualDataEntryName" select="$manualDataEntry/name"/>

<xsl:key name="apr_key" match="simple_instance[type = 'Application_Provider_Role']" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
<xsl:key name="aprBusRel_key" match="simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
<xsl:key name="appBusRelDirect_key" match="simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/>
<xsl:key name="physicalProcess_key" match="simple_instance[type = 'Physical_Process']" use="own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value"/>
<xsl:key name="services_key" match="simple_instance[type = 'Application_Service']" use="own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
<xsl:key name="subApps_key" match="simple_instance[type = 'Composite_Application_Provider']" use="own_slot_value[slot_reference = 'contained_application_providers']/value"/>

<xsl:template match="knowledge_base">{
	"meta":[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>],
	"reports":[{"name":"appRat", "link":"<xsl:value-of select="$reportPath/own_slot_value[slot_reference='report_xsl_filename']/value"/>"},{"name":"appInterface", "link":"<xsl:value-of select="$reportPathInterface/own_slot_value[slot_reference='report_xsl_filename']/value"/>"}],
	"applications":[<xsl:apply-templates select="$allAppProviders" mode="applications"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"compositeServices":[<xsl:apply-templates select="key('compositeServices', 'Composite_Application_Service', $KB)" mode="compositeServices"></xsl:apply-templates>],
	"apis":[<xsl:apply-templates select="$allAPIs" mode="applications"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
	"lifecycles":[<xsl:apply-templates select="$allLifecycleStatus" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"codebase":[<xsl:apply-templates select="$codebase" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"delivery":[<xsl:apply-templates select="$delivery" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
	"filters":[
		<xsl:apply-templates select="$allEnumClass" mode="createFilterJSON"></xsl:apply-templates>
		<xsl:if test="exists($allEnumClass) and (exists($allAppSlotsBoo) or key('instancesByType', 'Application_Family', $KB))">,</xsl:if>
		<xsl:apply-templates select="$allAppSlotsBoo" mode="createBooleanFilterJSON"></xsl:apply-templates>
		<xsl:if test="exists($allAppSlotsBoo) and key('instancesByType', 'Application_Family', $KB)">,</xsl:if>
		<xsl:apply-templates select="key('instancesByType', 'Application_Family', $KB)[1]" mode="createAppFamilyFilterJSON"></xsl:apply-templates>
	],
	"version":"6152"
	}

</xsl:template>

<xsl:template match="simple_instance" mode="applications">
    <xsl:variable name="thisApp" select="."/>
    <xsl:variable name="thisAppName" select="$thisApp/name"/>
    
    <xsl:variable name="appLifecycle" select="key('instanceByName', $thisApp/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value, $KB)"/>
    <xsl:variable name="appDelivery" select="key('instanceByName', $thisApp/own_slot_value[slot_reference='ap_delivery_model']/value, $KB)"/>
    <xsl:variable name="thisCodebase" select="key('instanceByName', $thisApp/own_slot_value[slot_reference='ap_codebase_status']/value, $KB)"/>
    
    <xsl:variable name="thisAppOrgUsers2Roles" select="key('a2rname_key', $thisApp/own_slot_value[slot_reference = 'stakeholders']/value, $KB)"/>
    <xsl:variable name="thisOrgUserIds" select="key('actorNameKey', $thisAppOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value, $KB)"/>
    <xsl:variable name="eaScopedOrgUserIds" select="key('actorNameKey', $thisApp/own_slot_value[slot_reference = 'ea_scope']/value, $KB)"/>

    <xsl:variable name="thisAppTypes" select="key('instanceByName', $thisApp/own_slot_value[slot_reference = 'application_provider_purpose']/value, $KB)[type='Application_Purpose']"/>
    <xsl:variable name="thisSitesUsed" select="key('allSitesNameKey', $thisApp/own_slot_value[slot_reference = 'ap_site_access']/value, $KB)"/>

    <xsl:variable name="subApps" select="key('instanceByName', $thisApp/own_slot_value[slot_reference = 'contained_application_providers']/value, $KB)"/>
    <xsl:variable name="subSubApps" select="key('instanceByName', $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value, $KB)"/>
    <xsl:variable name="allCurrentApps" select="$thisApp union $subApps union $subSubApps"/>
    <xsl:variable name="appStaticUsages" select="key('static_usage_key', $allCurrentApps/name, $KB)"/>

    <xsl:variable name="appInboundStaticAppRels" select="key('fromapu_key', $appStaticUsages/name, $KB)[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntryName)]"/>
    <xsl:variable name="appOutboundStaticAppRels" select="key('toapu_key', $appStaticUsages/name, $KB)[not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntryName)]"/>
    
    <xsl:variable name="appInboundStaticAppUsages" select="key('allAppStaticUsagesNameKey', $appInboundStaticAppRels/own_slot_value[slot_reference = ':TO']/value, $KB)"/>
    <xsl:variable name="appInboundStaticApps" select="key('instanceByName', $appInboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value, $KB)[type=('Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')]"/>
    
    <xsl:variable name="appOutboundStaticAppUsages" select="key('allAppStaticUsagesNameKey', $appOutboundStaticAppRels/own_slot_value[slot_reference = ':FROM']/value, $KB)"/>
    <xsl:variable name="appOutboundStaticApps" select="key('instanceByName', $appOutboundStaticAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value, $KB)[type=('Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')]"/>

    <xsl:variable name="aprKey" select="key('apr_key', $thisAppName, $KB)"/>
    <xsl:variable name="allProcessedLinkedToApps" select="key('aprBusRel_key', $aprKey/name, $KB) union key('appBusRelDirect_key', $thisAppName, $KB)"/>
    <xsl:variable name="physicalProcesskey" select="key('physicalProcess_key', $allProcessedLinkedToApps/name, $KB)"/>
    
    <xsl:variable name="thisrelevantActorsIndirect" select="key('processRoleKey', $physicalProcesskey/name, $KB)"/>
    <xsl:variable name="thisrelevantActorsDirect" select="key('processActorKey', $physicalProcesskey/name, $KB)"/>
    <xsl:variable name="thisrelevantActorsforA2R" select="key('actorNameKey', $thisrelevantActorsIndirect/own_slot_value[slot_reference = 'act_to_role_from_actor']/value, $KB)"/>
    <xsl:variable name="allPhysicalProcessActors" select="$thisrelevantActorsforA2R union $thisrelevantActorsDirect"/>

    <xsl:variable name="processSites" select="key('allSitesNameKey', $physicalProcesskey/own_slot_value[slot_reference = 'process_performed_at_sites']/value, $KB)"/>
    <xsl:variable name="allOrgUsers" select="$eaScopedOrgUserIds union $thisOrgUserIds union $allPhysicalProcessActors"/>  
    <xsl:variable name="OrgUsers2Sites" select="key('allSitesNameKey',  $allOrgUsers/own_slot_value[slot_reference = 'actor_based_at_site']/value, $KB)"/>
    <xsl:variable name="thisSites" select="$thisSitesUsed union $OrgUsers2Sites union $processSites"/>	
    
    <xsl:variable name="eaScopedGeoIds" select="key('allGeo', $thisApp/own_slot_value[slot_reference = 'ea_scope']/value, $KB)"/> 
    <xsl:variable name="siteGeos" select="key('allGeo', $thisSites/own_slot_value[slot_reference = 'site_geographic_location']/value, $KB)"/>
    <xsl:variable name="siteGeosviaLoc" select="key('geoByLocation', $siteGeos/name, $KB)"/>
    <xsl:variable name="siteCountries" select="$siteGeos[type='Geographic_Region'] union $siteGeosviaLoc union $eaScopedGeoIds"/>
    
    <xsl:variable name="appFamilies" select="key('family_key', $thisAppName, $KB)"/>
    <xsl:variable name="thisRegLink" select="key('regulationLink_key', $thisAppName, $KB)"/>
    <xsl:variable name="thisRegs" select="key('regulation_key', $thisRegLink/own_slot_value[slot_reference = 'regulated_component_regulation']/value, $KB)"/>
    <xsl:variable name="thisIssues" select="key('issue_key', $thisAppName, $KB) union key('issue_keynew', $thisAppName, $KB)"/>
    
    {
    "id": "<xsl:value-of select="eas:getSafeJSString($thisAppName)"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate($thisApp/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
        'description': string(translate(translate($thisApp[1]/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
    }" />
    <xsl:value-of select="substring-before(substring-after(serialize($combinedMap, map{'method':'json'}),'{'),'}')"/>, 
    "class":"<xsl:value-of select="$thisApp/type"/>",
    "className":"<xsl:value-of select="$thisApp/type"/>",
    "visId":["<xsl:value-of select="eas:getSafeJSString($thisApp/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
    "children":[<xsl:for-each select="$thisApp/own_slot_value[slot_reference='contained_application_providers']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "type_of_application":[<xsl:for-each select="$appFamilies">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "family":[<xsl:for-each select="$appFamilies">
        {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
        <xsl:variable name="fMap" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
        <xsl:value-of select="substring-before(substring-after(serialize($fMap, map{'method': 'json'}),'{'),'}')"/> }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    "regulations":[<xsl:for-each select="$thisRegs">
        {	
            "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
            <xsl:variable name="rMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
                'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
            }" />
            <xsl:value-of select="substring-before(substring-after(serialize($rMap, map{'method':'json'}),'{'),'}')"/>, 
        "className":"<xsl:value-of select="current()/type"/>"
        }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    "issues":[<xsl:for-each select="$thisIssues">
        <xsl:variable name="thisrequirementStatus" select="key('instanceByName', current()/own_slot_value[slot_reference='requirement_status']/value, $KB)"/>	
        {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
        <xsl:variable name="iMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:value-of select="substring-before(substring-after(serialize($iMap, map{'method':'json'}),'{'),'}')"/>, 
        "className":"<xsl:value-of select="current()/type"/>",
        <xsl:variable name="sMap" as="map(*)" select="map{'status': string(translate(translate($thisrequirementStatus/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
        <xsl:value-of select="substring-before(substring-after(serialize($sMap, map{'method': 'json'}),'{'),'}')"/> 
         }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    "inI":"<xsl:value-of select="count($appInboundStaticApps)"/>",
    "inDataCount":[<xsl:for-each select="$appInboundStaticAppRels/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "inIList":[<xsl:for-each select="$appInboundStaticApps">{
        "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="inMap" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
        <xsl:value-of select="substring-before(substring-after(serialize($inMap, map{'method': 'json'}),'{'),'}')"/>}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
    "outI":"<xsl:value-of select="count($appOutboundStaticApps)"/>",  
    <xsl:if test="$allContained[name=$thisAppName]">"containedApp":"Y",</xsl:if> 
    <xsl:if test="$thisApp/own_slot_value[slot_reference='parent_application_provider']/value">"containedApp":"Y",</xsl:if>
    "valueClass": "<xsl:value-of select="$thisApp/type"/>",
    "dispositionId":"<xsl:value-of select="$thisApp/own_slot_value[slot_reference='ap_disposition_lifecycle_status']/value"/>",
    "outIList":[<xsl:for-each select="$appOutboundStaticApps">{ 
        <xsl:variable name="outMap" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
        <xsl:value-of select="substring-before(substring-after(serialize($outMap, map{'method': 'json'}),'{'),'}')"/>, "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],	
    "outDataCount":[<xsl:for-each select="$appOutboundStaticAppRels/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], 
    "criticality":"<xsl:value-of select="key('instanceByName', $thisApp/own_slot_value[slot_reference='ap_business_criticality']/value, $KB)/own_slot_value[slot_reference='enumeration_value']/value"/>",
    <xsl:if test="$thisAppTypes">
    "type":"<xsl:value-of select="$thisAppTypes[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>",
    "typeid":"<xsl:value-of select="eas:getSafeJSString($thisAppTypes[1]/name)"/>",
    </xsl:if>
    "orgUserIds": [<xsl:for-each select="distinct-values($allOrgUsers/name)">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "geoIds": [<xsl:for-each select="$siteCountries">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "siteIds":[<xsl:for-each select="$thisSites">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "codebaseID":"<xsl:value-of select="eas:getSafeJSString($thisApp/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
    "deliveryID":"<xsl:value-of select="eas:getSafeJSString($thisApp/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
    "sA2R":[<xsl:for-each select="$thisAppOrgUsers2Roles">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "al_managed_by_services":[<xsl:for-each select="$thisApp/own_slot_value[slot_reference='al_managed_by_services']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], 
    "lifecycle":"<xsl:value-of select="eas:getSafeJSString($thisApp/own_slot_value[slot_reference='lifecycle_status_application_provider']/value)"/>",
    "physP":[<xsl:for-each select="$physicalProcesskey">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "allServicesIdOnly":[<xsl:for-each select="$thisApp/own_slot_value[slot_reference='provides_application_services']/value">
     { "id": "<xsl:value-of select="eas:getSafeJSString(.)"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="key('instanceByName', ., $KB)"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
     "allServices":[<xsl:for-each select="$aprKey">
         <xsl:variable name="thisserviceskey" select="key('services_key', current()/name, $KB)"/>
         { 
         "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
         "lifecycleId": "<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apr_lifecycle_status']/value)"/>",
         "serviceId": "<xsl:value-of select="eas:getSafeJSString($thisserviceskey/name)"/>",
         "className":"<xsl:value-of select="current()/type"/>",
         <xsl:variable name="svcMap" as="map(*)" select="map{'serviceName': string(translate(translate($thisserviceskey/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
         <xsl:value-of select="substring-before(substring-after(serialize($svcMap, map{'method': 'json'}),'{'),'}')"/> , 
        "capabilities":[<xsl:for-each select="$thisserviceskey/own_slot_value[slot_reference='realises_application_capabilities']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
        <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$thisserviceskey"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    
    <xsl:for-each select="$allAppSlots">
        <xsl:variable name="slt" select="current()/name"/>
        "<xsl:value-of select="$slt"/>":[<xsl:for-each select="$thisApp/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>,	 
    <xsl:if test="$allAppSlotsBoo">
        <xsl:for-each select="$allAppSlotsBoo">
            <xsl:variable name="slt" select="current()/name"/>
            "<xsl:value-of select="$slt"/>":[
            <xsl:choose>
                <xsl:when test="$thisApp/own_slot_value[slot_reference=$slt]/value">"<xsl:value-of select="$thisApp/own_slot_value[slot_reference=$slt]/value"/>"</xsl:when>
                <xsl:otherwise>"none"</xsl:otherwise>
            </xsl:choose>
            ]<xsl:if test="position()!=last()">,</xsl:if> 
        </xsl:for-each>,
    </xsl:if>
    "services":[<xsl:for-each select="$aprKey[name=$allProcessedLinkedToApps/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]">
        <xsl:variable name="serviceskey" select="key('services_key', current()/name, $KB)"/>
        {"id": "<xsl:value-of select="eas:getSafeJSString($serviceskey/name)"/>",  
        <xsl:variable name="sMap2" as="map(*)" select="map{'name': string(translate(translate($serviceskey/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
        <xsl:value-of select="substring-before(substring-after(serialize($sMap2, map{'method': 'json'}),'{'),'}')"/>,
        <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$serviceskey"/></xsl:call-template>}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$thisApp"/></xsl:call-template>
    }<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="simple_instance" mode="fitValues">
    {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
    <xsl:variable name="vMap" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
    <xsl:value-of select="substring-before(substring-after(serialize($vMap, map{'method': 'json'}),'{'),'}')"/>, 
    "shortname":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/>",
    "colour":"<xsl:value-of select="key('allElementStyles', current()[1]/own_slot_value[slot_reference='element_styling_classes']/value, $KB)/own_slot_value[slot_reference='element_style_colour']/value"/>",
    "value":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
</xsl:template>	

<xsl:template match="simple_instance" mode="lifes">
    <xsl:variable name="thisStyle" select="key('allElementStyles', current()[1]/own_slot_value[slot_reference='element_styling_classes']/value, $KB)"/>
    {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
    "shortname":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'enumeration_value']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></xsl:otherwise></xsl:choose>",
    "colour":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
    "colourText":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
</xsl:template>	

<xsl:template match="simple_instance" mode="classMetaData"> 
    <xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
    {"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template mode="createFilterJSON" match="class">	
    <xsl:variable name="thisSlot" select="$appSlots[own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value=current()/name]"/> 
    <xsl:variable name="releventEnums" select="key('instancesByType', current()/name, $KB)"/> 
    {"id": "<xsl:value-of select="current()/name"/>",
    "name": "<xsl:value-of select="translate(current()/name, '_',' ')"/>",
    "valueClass": "<xsl:value-of select="current()/name"/>",
    "description": "",
    "slotName":"<xsl:value-of select="$thisSlot[1]/name"/>",
    "isGroup": false,
    "icon": "fa-circle",
    "color":"#93592f",
    "values": [
    <xsl:for-each select="$releventEnums">
        <xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/>
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="enMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
            'enum_name': string(translate(translate(current()/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
            'sequence': string(translate(translate(current()/own_slot_value[slot_reference = 'enumeration_sequence_number']/value, '}', ')'), '{', ')')),
            'class': string(current()/type)
        }"/>
        <xsl:value-of select="substring-before(substring-after(serialize($enMap, map{'method': 'json'}),'{'),'}')"/>, 
         "backgroundColor":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
        "colour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>"}
        <xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>]
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>	

<xsl:template mode="createBooleanFilterJSON" match="slot">	
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

<xsl:template match="simple_instance" mode="compositeServices">
    {"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
    <xsl:variable name="csMap" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
    <xsl:value-of select="substring-before(substring-after(serialize($csMap, map{'method': 'json'}),'{'),'}')"/>, 
    "containedService":[<xsl:for-each select="current()/own_slot_value[slot_reference='composed_of_application_services']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template mode="createAppFamilyFilterJSON" match="simple_instance">	
    {"id": "<xsl:value-of select="current()/name"/>",
    "name": "Application Family",
    "valueClass": "<xsl:value-of select="current()/type"/>",
    "description": "Application family to which an application belongs",
    "slotName":"type_of_application",
    "isGroup": false,
    "icon": "fa-site",
    "color":"#93592f",
    "values": [
    <xsl:for-each select="key('familyKeyByType', 'Application_Family')">
        <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
        {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        <xsl:variable name="famMap" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))}"/>
        <xsl:value-of select="substring-before(substring-after(serialize($famMap, map{'method': 'json'}),'{'),'}')"/>,
        <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
        }<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>]
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

</xsl:stylesheet>
