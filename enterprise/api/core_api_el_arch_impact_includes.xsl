<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
    <xsl:param name="param2"/>
	
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
	<xsl:key name="instances" match="/node()/simple_instance" use="name"/>
	<xsl:key name="instancesType" match="/node()/simple_instance" use="type"/>
	<xsl:variable name="impactBusEnvFactors" select="/node()/simple_instance[type = 'Business_Environment_Factor']"/>
	<xsl:variable name="impactBusEnvCorrelations" select="key('instances', $impactBusEnvFactors/own_slot_value[slot_reference = 'bus_env_factor_correlations']/value)"/>
	
	<xsl:variable name="impactBusOutcomeSQs" select="/node()/simple_instance[(type = 'Business_Service_Quality') and (own_slot_value[slot_reference = 'sq_for_classes']/value = 'Business_Capability')]"/>
	<xsl:variable name="impactCostTypes" select="key('instancesType', 'Cost_Component_Type')"/>
	<xsl:variable name="impactRevenueTypes" select="key('instancesType', 'Revenue_Component_Type')"/>
	
	<xsl:variable name="impactTechCapabilities" select="key('instancesType', 'Technology_Capability')"/>
	<xsl:key name="impactTechCapabilities" match="$impactTechCapabilities" use="name"/>
	
	<xsl:variable name="impactTechComponents" select="key('instancesType', 'Technology_Component')"/>
	<xsl:key name="impactTechComponents" match="$impactTechComponents" use="name"/>
	<xsl:variable name="impactTechProdRoles" select="key('instancesType', 'Technology_Product_Role')"/>
	<xsl:key name="impactTechProdRoles" match="$impactTechProdRoles" use="name"/>
	<xsl:key name="impactTechProdRolestc" match="$impactTechProdRoles" use="own_slot_value[slot_reference='implements_technology_components']/value"/> 

<xsl:variable name="impactTechProducts" select="key('instancesType', 'Technology_Product')"/>
	<xsl:variable name="impactTPRUsages" select="key('instancesType', 'Technology_Provider_Usage')"/>
	<xsl:key name="impactTPRUsages" match="$impactTPRUsages" use="name"/>
	<xsl:variable name="impactTechBuildArchs" select="key('instancesType', 'Technology_Build_Architecture')"/>
	<xsl:variable name="impactTechProd2TechProdRels" select="key('instancesType', ':TPU-TO-TPU-RELATION')"/>
	<xsl:variable name="impactTechBuilds" select="key('instancesType', 'Technology_Product_Build')"/>
	
	<xsl:variable name="impactInfoViews" select="/node()/simple_instance[type='Information_View']"/>
	<xsl:variable name="impactBusCap2InfoViewRels" select="/node()/simple_instance[type='BUSCAP_TO_INFOVIEW_RELATION']"/>
	<xsl:variable name="impactInfoConcepts" select="/node()/simple_instance[type='Information_Concept']"/>
	<xsl:key name="impactInfoConcepts" match="$impactInfoConcepts" use="name"/>
	<xsl:variable name="impactAppProviders" select="key('instancesType', ('Composite_Application_Provider', 'Application_Provider'))"/>
	<xsl:key name="impactAppProviders" match="$impactAppProviders" use="name"/>
	<xsl:key name="impactAppProvidersTech" match="$impactAppProviders" use="own_slot_value[slot_reference='deployments_of_application_provider']/value "/>
	<xsl:key name="impactAppProvidersTechImp" match="$impactAppProviders" use="own_slot_value[slot_reference='implemented_with_technology']/value "/> 

	<xsl:variable name="impactApplicationProRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
	<xsl:key name="impactApplicationProRoles" match="/node()/simple_instance[type='Application_Provider_Role']" use="name"/>
	<xsl:variable name="impactAppDeployments" select="/node()/simple_instance[type='Application_Deployment']"/>
	<xsl:variable name="impactApplicatonServices" select="key('instancesType','Application_Service')"/>
	<xsl:key name="impactApplicatonServices" match="$impactApplicatonServices" use="name"/>
	
	<xsl:variable name="impactApSvc2BusProcRels" select="key('instancesType','APP_SVC_TO_BUS_RELATION')"/>
	<xsl:key name="impactApSvc2BusProcRels" match="$impactApSvc2BusProcRels" use="name"/>
	
	<xsl:variable name="impactApplicationCapabilities" select="key('instancesType','Application_Capability')"/>
	<xsl:key name="impactApplicationCapabilities" match="$impactApplicationCapabilities" use="name"/>
	
	<xsl:variable name="impactApptoPhysProcesses" select="key('instancesType','APP_PRO_TO_PHYS_BUS_RELATION')"/>
	<xsl:variable name="impactAppUsages" select="key('instancesType','Static_Application_Provider_Usage')"/>
	<xsl:key name="impactAppUsages" match="$impactAppUsages" use="name"/>

	<xsl:key name="impactAppUsagesStatic" match="$impactAppUsages" use="own_slot_value[slot_reference='static_usage_of_app_provider']/value"/>
	
	<xsl:variable name="impactApp2AppRels" select="/key('instancesType',':APU-TO-APU-STATIC-RELATION')"/>
	
	<xsl:variable name="impactTechCompUsages" select="/node()/simple_instance[type='Technology_Component_Usage']"/>
	<xsl:key name="impactTechCompArchs" match="/node()/simple_instance[type='Technology_Component_Architecture']" use="name"/>
	<xsl:key name="impactTechComposites" match="/node()/simple_instance[type='Technology_Composite']"  use="name"/>	
	
	
	<xsl:variable name="impactPhysProcesses" select="/node()/simple_instance[type='Physical_Process']"/>
	<xsl:key name="impactPhysProcesses" match="$impactPhysProcesses" use="name"/>
	
	<xsl:variable name="impactOrgs" select="/node()/simple_instance[type='Group_Actor']"/>
	<xsl:key name="impactOrgs" match="$impactOrgs" use="name"/>

	<xsl:variable name="impactBusProcesses" select="key('instancesType', 'Business_Process')"/>
	<xsl:key name="impactBusProcesses" match="$impactBusProcesses" use="name"/>
	
	
	<!-- Eco system impacts -->
	<xsl:variable name="impactActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="impactExternalRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'role_is_external']/value = 'true')]"/>
	
	<xsl:variable name="impactChannelTypes" select="/node()/simple_instance[type = 'Channel_Type']"/>
	<xsl:variable name="impactChannels" select="/node()/simple_instance[type = 'Channel']"/>
	<xsl:variable name="impactBrands" select="/node()/simple_instance[type = 'Brand']"/>
	<!--<xsl:variable name="impactProdConcepts" select="/node()/simple_instance[type = 'Product_Concept']"/>-->
	<xsl:variable name="impactProdTypes" select="/node()/simple_instance[type = ('Product_Type', 'Composite_Product_Type')]"/>
	<xsl:variable name="impactInternalProductTypes" select="$impactProdTypes[own_slot_value[slot_reference = 'product_type_external_facing']/value = 'Yes']"/>
	<xsl:variable name="impactExternalProductTypes" select="$impactProdTypes except $impactInternalProductTypes"/>
	
	
	<!-- exclude root and level 1 capabilities from impacts -->
	<xsl:variable name="allBusinessCapabilities" select="key('instancesType', 'Business_Capability')"/>
	<xsl:key name="allBusinessCapabilities" match="$allBusinessCapabilities" use="name"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="key('allBusinessCapabilities', $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value)"/>
	<xsl:variable name="L0BusCaps" select="key('allBusinessCapabilities', $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value)"/>
	<xsl:variable name="impactBusinessCapabilities" select="$allBusinessCapabilities except ($rootBusCap, $L0BusCaps)"/>
	<xsl:key name="impactBusinessCapabilities" match="$impactBusinessCapabilities" use="name"/>
	
	
	
	<!-- ***********************
	IMPACT JSON RENDERERS
	****************************** -->
	
	<xsl:template mode="BusEnvFactorImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="parentCatId" select="$this/own_slot_value[slot_reference = 'bef_category']/value"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"categoryId": "<xsl:value-of select="$parentCatId"/>",
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>	
	
	
	<xsl:template mode="BusCapImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisinScopeBusCapAncestors" select="eas:get_object_descendants($this, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisinScopeBusCapDescendants" select="eas:get_object_descendants($this, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisinScopeBusCapRelatives" select="$thisinScopeBusCapAncestors union $thisinScopeBusCapDescendants"/>
		
		"<xsl:value-of select="$this/name"/>": { 
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisinScopeBusCapRelatives)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="BusProcImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- get conceptual scopeIds -->
		<xsl:variable name="thisBusCaps" select="key('impactBusinessCapabilities', $this/own_slot_value[slot_reference='realises_business_capability']/value)"/>
		<xsl:variable name="thisinScopeBusCapAncestors" select="eas:get_object_descendants($thisBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisinScopeBusCapDescendants" select="eas:get_object_descendants($thisBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisinScopeBusCapRelatives" select="$thisinScopeBusCapAncestors union $thisinScopeBusCapDescendants"/>
		
		<!-- get direct impacts -->
		
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisinScopeBusCapRelatives)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="ChannelTypeImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="BrandImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="ProdTypeImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="isCustomerFacing">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference='product_type_external_facing']/value = 'Yes'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"isCustomerFacing": <xsl:value-of select="$isCustomerFacing"/>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RoleImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	
	<xsl:template mode="AppCapImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisinScopeAppCapAncestors" select="eas:get_object_descendants($this, $impactApplicationCapabilities, 0, 5, 'contained_in_application_capability')"/>
		<xsl:variable name="thisinScopeAppCapDescendants" select="eas:get_object_descendants($this, $impactApplicationCapabilities, 0, 5, 'contained_app_capabilities')"/>
		<xsl:variable name="thisinScopeAppCapRelatives" select="$thisinScopeAppCapAncestors union $thisinScopeAppCapDescendants"/>
		
		<!-- direct impacts -->
		<xsl:variable name="thisAppSvcs" select="$impactApplicatonServices[own_slot_value[slot_reference='realises_application_capabilities']/value = $thisinScopeAppCapRelatives/name]"/>
		<xsl:variable name="thisInScopeAPRs" select="key('impactApplicationProRoles', $thisAppSvcs/own_slot_value[slot_reference='provides_application_services']/value)"/>
		<xsl:variable name="thisInScopeApps" select="key('impactAppProviders', $thisInScopeAPRs/own_slot_value[slot_reference='role_for_application_provider']/value)"/>
		<xsl:variable name="thisDirectApp2PhysProcRels" select="$impactApptoPhysProcesses[own_slot_value[slot_reference=('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($thisInScopeApps, $thisInScopeAPRs)/name]"/>
		<xsl:variable name="thisDirectPhysProcs" select="key('impactPhysProcesses',$thisDirectApp2PhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value)"/>
		<xsl:variable name="thisDirectOrgs" select="key('impactOrgs', $thisDirectPhysProcs/own_slot_value[slot_reference='process_performed_by_actor_role']/value)"/>
		<xsl:variable name="thisDirectBusProcs" select="key('impactBusProcesses', $thisDirectPhysProcs/own_slot_value[slot_reference='implements_business_process']/value)"/>
		<xsl:variable name="thisInScopeBusCaps" select="key('impactBusinessCapabilities', $thisDirectBusProcs/own_slot_value[slot_reference='realises_business_capability']/value)"/>
		
		<xsl:variable name="thisDirectBusCaps" select="key('impactBusinessCapabilities',$thisinScopeAppCapRelatives/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value)"/>
		<xsl:variable name="thisDirecBusCapAncestors" select="eas:get_object_descendants(($thisDirectBusCaps, $thisInScopeBusCaps), $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants(($thisDirectBusCaps, $thisInScopeBusCaps), $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirecBusCapAncestors union $thisDirectBusCapDescendants"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="$thisinScopeAppCapRelatives"/>],
		"directImpacts": [
		<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Business_Capability</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectBusCapRelatives"/></xsl:call-template>,
		<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Group_Actor</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectOrgs"/></xsl:call-template>
		]	
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="AppServiceImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisInScopeAppCaps" select="key('impactApplicationCapabilities',$this/own_slot_value[slot_reference='realises_application_capabilities']/value)"/>
		<xsl:variable name="thisinScopeAppCapAncestors" select="eas:get_object_descendants($thisInScopeAppCaps, $impactApplicationCapabilities, 0, 5, 'contained_in_application_capability')"/>
		<xsl:variable name="thisinScopeAppCapDescendants" select="eas:get_object_descendants($thisInScopeAppCaps, $impactApplicationCapabilities, 0, 5, 'contained_app_capabilities')"/>
		<xsl:variable name="thisinScopeAppCapRelatives" select="$thisinScopeAppCapAncestors union $thisinScopeAppCapDescendants"/>
		
		<!-- direct impacts -->
		<xsl:variable name="thisDirectBusProcRels" select="key('impactApSvc2BusProcRels', $this/own_slot_value[slot_reference='supports_business_process_appsvc']/value)"/>
		<xsl:variable name="thisDirectBusProcs" select="key('impactBusProcesses',$thisDirectBusProcRels/own_slot_value[slot_reference='appsvc_to_bus_to_busproc']/value)"/>
		
		<xsl:variable name="thisDirectBusCaps" select="key('impactBusinessCapabilities', $thisDirectBusProcs/own_slot_value[slot_reference='realises_business_capability']/value)"/>
		<xsl:variable name="thisDirectBusCapAncestors" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirectBusCapAncestors union $thisDirectBusCapDescendants"/>
		
		<!-- indirect impacts -->
		<!--<xsl:variable name="thisInDirectBusCaps" select="$impactBusinessCapabilities[name = $thisinScopeAppCapRelatives/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value]"/>
		<xsl:variable name="thisInDirecBusCapAncestors" select="eas:get_object_descendants($thisInDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisInDirectBusCapDescendants" select="eas:get_object_descendants($thisInDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisInDirectBusCapRelatives" select="$thisInDirecBusCapAncestors union $thisInDirectBusCapDescendants"/>-->
		<!-- NOTE: RECURSION OF BUS PROCS THAT CONTAIN THIS BUS PROC 
			ADD BUS CAPS OF THESE BUS PROCS		
		-->
		
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisinScopeAppCapRelatives)"/>],
		"directImpacts": [
		<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Business_Capability</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectBusCapRelatives"/></xsl:call-template>,
		<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Business_Process</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectBusProcs"/></xsl:call-template>
		]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="AppImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- conceptual scopeIds -->
		<xsl:variable name="thisInScopeAPRs" select="key('impactApplicationProRoles',  $this/own_slot_value[slot_reference='provides_application_services']/value)"/>
		<xsl:variable name="thisInScopeAppSvcs" select="key('impactApplicatonServices',  $thisInScopeAPRs/own_slot_value[slot_reference='implementing_application_service']/value)"/>
		<xsl:variable name="thisInScopAppCaps" select="key('impactApplicationCapabilities', $thisInScopeAppSvcs/own_slot_value[slot_reference='realises_application_capabilities']/value)"/>
		<xsl:variable name="thisinScopeAppCapAncestors" select="eas:get_object_descendants($thisInScopAppCaps, $impactApplicationCapabilities, 0, 5, 'contained_in_application_capability')"/>
		<xsl:variable name="thisinScopeAppCapDescendants" select="eas:get_object_descendants($thisInScopAppCaps, $impactApplicationCapabilities, 0, 5, 'contained_app_capabilities')"/>
		<xsl:variable name="thisinScopeAppCapRelatives" select="$thisinScopeAppCapAncestors union $thisinScopeAppCapDescendants"/>
		
		<!-- direct business impacts -->
		<xsl:variable name="thisDirectApp2PhysProcRels" select="$impactApptoPhysProcesses[own_slot_value[slot_reference=('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($this, $thisInScopeAPRs)/name]"/>
		<xsl:variable name="thisDirectPhysProcs" select="key('impactPhysProcesses',$thisDirectApp2PhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value)"/>
		<xsl:variable name="thisDirectOrgs" select="key('impactOrgs', $thisDirectPhysProcs/own_slot_value[slot_reference='process_performed_by_actor_role']/value)"/>
		<xsl:variable name="thisDirectBusProcs" select="key('impactBusProcesses',$thisDirectPhysProcs/own_slot_value[slot_reference='implements_business_process']/value)"/>
		<xsl:variable name="thisDirectBusCaps" select="key('impactBusinessCapabilities', $thisDirectBusProcs/own_slot_value[slot_reference='realises_business_capability']/value)"/>
		<xsl:variable name="thisDirectBusCapAncestors" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirectBusCapAncestors union $thisDirectBusCapDescendants"/>
		
		<!-- direct app impacts -->
		<xsl:variable name="thisAppUsages" select="key('impactAppUsagesStatic', $this/name)"/>
		<xsl:variable name="thisDirecAppDepRels" select="$impactApp2AppRels[own_slot_value[slot_reference=':TO']/value = $thisAppUsages/name]"/>
		<xsl:variable name="thisDirectAppUsages" select="key('impactAppUsages', $thisDirecAppDepRels/own_slot_value[slot_reference=':FROM']/value)"/>
		<xsl:variable name="thisDirectApps" select="key('impactAppProviders',  $thisDirectAppUsages/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
		<xsl:variable name="thisDirectAPRs" select="key('impactApplicationProRoles',  $thisDirectApps/own_slot_value[slot_reference='provides_application_services']/value)"/>
		<xsl:variable name="thisDirectAppSvcs" select="key('impactApplicatonServices',  $thisDirectAPRs/own_slot_value[slot_reference='implementing_application_service']/value)"/>
		<xsl:variable name="thisDirectAppCaps" select="key('impactApplicationCapabilities', $thisDirectAppSvcs/own_slot_value[slot_reference='realises_application_capabilities']/value)"/>
		<xsl:variable name="thisDirectAppCapAncestors" select="eas:get_object_descendants($thisDirectAppCaps, $impactApplicationCapabilities, 0, 5, 'contained_in_application_capability')"/>
		<xsl:variable name="thisDirectAppCapDescendants" select="eas:get_object_descendants($thisDirectAppCaps, $impactApplicationCapabilities, 0, 5, 'contained_app_capabilities')"/>
		<xsl:variable name="thisDirectAppCapRelatives" select="$thisDirectAppCapAncestors union $thisDirectAppCapDescendants"/>
		
		<!-- indirect impacts -->
		<!--<xsl:variable name="thisInDirectBusCaps" select="$impactBusinessCapabilities[name = $thisInScopAppCaps/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value]"/>
		<xsl:variable name="thisInDirecBusCapAncestors" select="eas:get_object_descendants($thisInDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisInDirectBusCapDescendants" select="eas:get_object_descendants($thisInDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisInDirectBusCapRelatives" select="$thisInDirecBusCapAncestors union $thisInDirectBusCapDescendants"/>-->
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisinScopeAppCapRelatives)"/>],
		"directImpacts": [
			<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Business_Capability</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectBusCapRelatives"/></xsl:call-template>
			<!--<xsl:apply-templates mode="ImpactIdListJSON" select="($thisDirectBusCapRelatives, $thisDirectBusProcs, $thisDirectOrgs, $thisDirectApps, $thisDirectAppCapRelatives)"/>]-->
			]
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="InfoConceptImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisDirectBusCaps" select="$impactBusinessCapabilities[own_slot_value[slot_reference='business_capability_requires_information']/value = $this/name]"/>
		<xsl:variable name="thisDirecBusCapAncestors" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirecBusCapAncestors union $thisDirectBusCapDescendants"/>
		
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="$this"/>],
		"directImpacts": [
		<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Business_Capability</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectBusCapRelatives"/></xsl:call-template>
		<!--<xsl:apply-templates mode="ImpactIdListJSON" select="$thisDirectBusCapRelatives"/>-->
		]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="InfoViewImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Scope -->
		<xsl:variable name="thisInfoConcepts" select="key('impactInfoConcepts', $this/own_slot_value[slot_reference='refinement_of_information_concept']/value)"/>
		
		<!-- Direct Impacts -->
		<xsl:variable name="thisBusCap2InfoViewRels" select="$impactBusCap2InfoViewRels[own_slot_value[slot_reference='buscap_to_infoview_to_infoview']/value = $this/name]"/>		
		<xsl:variable name="thisDirectBusCaps" select="key('impactBusinessCapabilities', $thisBusCap2InfoViewRels/own_slot_value[slot_reference='buscap_to_infoview_from_buscap']/value)"/>
		<xsl:variable name="thisDirectBusCapAncestors" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirectBusCapAncestors union $thisDirectBusCapDescendants"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisInfoConcepts)"/>],
		"directImpacts": [
			<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Business_Capability</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectBusCapRelatives"/></xsl:call-template>
			<!--<xsl:apply-templates mode="ImpactIdListJSON" select="($thisDirectBusCapRelatives)"/>-->
		]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="TechCapImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisinScopeTechCapAncestors" select="eas:get_object_descendants($this, $impactTechCapabilities, 0, 5, 'contained_in_technology_capabilities')"/>
		<xsl:variable name="thisinScopeTechCapDescendants" select="eas:get_object_descendants($this, $impactTechCapabilities, 0, 5, 'contained_technology_capabilities')"/>
		<xsl:variable name="thisinScopeTechCapRelatives" select="$thisinScopeTechCapAncestors union $thisinScopeTechCapDescendants"/>
		
		<!-- direct impacts -->
		<xsl:variable name="thisTechComps" select="$impactTechComponents[own_slot_value[slot_reference='realisation_of_technology_capability']/value = $thisinScopeTechCapRelatives/name]"/>
		<xsl:variable name="thisTPRs" select="key('impactTechProdRolestc', $thisTechComps/name)"/>
		<xsl:variable name="thisDirectTPRUsages" select="$impactTPRUsages[own_slot_value[slot_reference='provider_as_role']/value = $thisTPRs/name]"/>
		<xsl:variable name="thisDirectTechBuildArchs" select="key('impactTPRUsages',  $thisDirectTPRUsages/own_slot_value[slot_reference='used_in_technology_provider_architecture']/value)"/>
		<xsl:variable name="thisDirectTechBuilds" select="key('impactTPRUsages', $thisDirectTechBuildArchs/own_slot_value[slot_reference='describes_technology_provider']/value)"/>
		<xsl:variable name="thisDirectAppDeployments" select="$impactAppDeployments[own_slot_value[slot_reference='application_deployment_technical_arch']/value = $thisDirectTechBuilds/name]"/>
		<xsl:variable name="thisDirectApps" select="key('impactAppProvidersTech', $thisDirectAppDeployments/name)"/>
		<xsl:variable name="thisInScopeAPRs" select="key('impactApplicationProRoles', $thisDirectApps/own_slot_value[slot_reference='provides_application_services']/value)"/>
		<xsl:variable name="thisInScopeAppSvcs" select="key('impactApplicatonServices',  $thisInScopeAPRs/own_slot_value[slot_reference='implementing_application_service']/value)"/>
		<xsl:variable name="thisInScopAppCaps" select="key('impactApplicationCapabilities', $thisInScopeAppSvcs/own_slot_value[slot_reference='realises_application_capabilities']/value)"/>
		
		<xsl:variable name="thisDirectAppCaps" select="$impactApplicationCapabilities[own_slot_value[slot_reference='app_cap_supporting_tech_caps']/value = $thisinScopeTechCapRelatives/name]"/>
		<xsl:variable name="thisDirectAppCapAncestors" select="eas:get_object_descendants(($thisDirectAppCaps, $thisInScopAppCaps), $impactApplicationCapabilities, 0, 5, 'contained_in_application_capability')"/>
		<xsl:variable name="thisDirectAppCapDescendants" select="eas:get_object_descendants(($thisDirectAppCaps, $thisInScopAppCaps), $impactApplicationCapabilities, 0, 5, 'contained_app_capabilities')"/>
		<xsl:variable name="thisDirectAppCapRelatives" select="$thisDirectAppCapAncestors union $thisDirectAppCapDescendants"/>
		
		<!-- indirect impacts -->
		<!--<xsl:variable name="thisInDirectBusCaps" select="$impactBusinessCapabilities[name = $thisDirectAppCapRelatives/own_slot_value[slot_reference='app_cap_supports_bus_cap']/value]"/>
		<xsl:variable name="thisInDirecBusCapAncestors" select="eas:get_object_descendants($thisInDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisInDirectBusCapDescendants" select="eas:get_object_descendants($thisInDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisInDirectBusCapRelatives" select="$thisInDirecBusCapAncestors union $thisInDirectBusCapDescendants"/>-->
		
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="$thisinScopeTechCapRelatives"/>],
		"directImpacts": [
			<xsl:call-template name="RenderDirecImpactListJSON"><xsl:with-param name="impactClass">Application_Capability</xsl:with-param><xsl:with-param name="impactedElements" select="$thisDirectAppCapRelatives"/></xsl:call-template>
			<!--<xsl:apply-templates mode="ImpactIdListJSON" select="$thisDirectAppCapRelatives"/>-->
		]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="TechCompImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Scope/direct impact tech caps -->
		<xsl:variable name="thisInScopeTechCaps" select="key('impactTechCapabilities', $this/own_slot_value[slot_reference='realisation_of_technology_capability']/value)"/>	
		<xsl:variable name="thisinScopeTechCapAncestors" select="eas:get_object_descendants($thisInScopeTechCaps, $impactTechCapabilities, 0, 5, 'contained_in_technology_capabilities')"/>
		<xsl:variable name="thisinScopeTechCapDescendants" select="eas:get_object_descendants($thisInScopeTechCaps, $impactTechCapabilities, 0, 5, 'contained_technology_capabilities')"/>
		<xsl:variable name="thisinScopeTechCapRelatives" select="$thisinScopeTechCapAncestors union $thisinScopeTechCapDescendants"/>
		
		<!-- direct apps -->
		<xsl:variable name="thisDirectTechCompUsages" select="$impactTechCompUsages[own_slot_value[slot_reference='usage_of_technology_component']/value = $this/name]"/>
		<xsl:variable name="thisDirectTechCompArchs" select="key('impactTechCompArchs', $thisDirectTechCompUsages/own_slot_value[slot_reference='inverse_of_technology_component_usages']/value)"/>
		<xsl:variable name="thisDirectTechComposites" select="key('impactTechComposites', $thisDirectTechCompArchs/own_slot_value[slot_reference='describes_technology_composite']/value)"/>
		<xsl:variable name="thisDirectApps" select="key('impactAppProvidersTechImp',$thisDirectTechComposites/name)"></xsl:variable>
		
		
		<!-- indirect bus procs/capabilities -->
		<!--<xsl:variable name="thisInScopeAPRs" select="$impactApplicationProRoles[name = $thisDirectApps/own_slot_value[slot_reference='provides_application_services']/value]"/>
		<xsl:variable name="thisDirectApp2PhysProcRels" select="$impactApptoPhysProcesses[own_slot_value[slot_reference=('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($thisDirectApps, $thisInScopeAPRs)/name]"/>
		<xsl:variable name="thisDirectPhysProcs" select="$impactPhysProcesses[name = $thisDirectApp2PhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="thisDirectOrgs" select="$impactOrgs[name = $thisDirectPhysProcs/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisDirectBusProcs" select="$impactBusProcesses[name = $thisDirectPhysProcs/own_slot_value[slot_reference='implements_business_process']/value]"/>
		<xsl:variable name="thisDirectBusCaps" select="$impactBusinessCapabilities[name = $thisDirectBusProcs/own_slot_value[slot_reference='realises_business_capability']/value]"/>
		<xsl:variable name="thisDirectBusCapAncestors" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirectBusCapAncestors union $thisDirectBusCapDescendants"/>-->
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisinScopeTechCapRelatives)"/>],
		"directImpacts": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisDirectApps)"/>]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="TechProdImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- scoping tech caps -->
		<xsl:variable name="thisScopeTPRs" select="key('impactTechProdRoles', $this/own_slot_value[slot_reference='implements_technology_components']/value)"/>
		<xsl:variable name="thisScopeTechComps" select="key('impactTechComponents', $thisScopeTPRs/own_slot_value[slot_reference='implementing_technology_component']/value)"/>
		<xsl:variable name="thisScopeTechCaps" select="key('impactTechCapabilities', $thisScopeTechComps/own_slot_value[slot_reference='realisation_of_technology_capability']/value)"/>
		<xsl:variable name="thisinScopeTechCapAncestors" select="eas:get_object_descendants($thisScopeTechCaps, $impactTechCapabilities, 0, 5, 'contained_in_technology_capabilities')"/>
		<xsl:variable name="thisinScopeTechCapDescendants" select="eas:get_object_descendants($thisScopeTechCaps, $impactTechCapabilities, 0, 5, 'contained_technology_capabilities')"/>
		<xsl:variable name="thisinScopeTechCapRelatives" select="$thisinScopeTechCapAncestors union $thisinScopeTechCapDescendants"/>
		
		<!-- direct apps ??tech prods - DEFERRED?? -->
		<xsl:variable name="thisDirectTPRUsages" select="$impactTPRUsages[own_slot_value[slot_reference='provider_as_role']/value = $thisScopeTPRs/name]"/>
		<xsl:variable name="thisDirectTechBuildArchs" select="key('impactTPRUsages', $thisDirectTPRUsages/own_slot_value[slot_reference='used_in_technology_provider_architecture']/value)"/>
		<xsl:variable name="thisDirectTechBuilds" select="key('impactTPRUsages', $thisDirectTechBuildArchs/own_slot_value[slot_reference='describes_technology_provider']/value)"/>
		<xsl:variable name="thisDirectAppDeployments" select="$impactAppDeployments[own_slot_value[slot_reference='application_deployment_technical_arch']/value = $thisDirectTechBuilds/name]"/>
		<xsl:variable name="thisDirectApps" select="key('impactAppProvidersTech', $thisDirectAppDeployments/name)"/>
		
		<!-- indirect bus procs/caps -->
		<!--<xsl:variable name="thisInScopeAPRs" select="$impactApplicationProRoles[name = $thisDirectApps/own_slot_value[slot_reference='provides_application_services']/value]"/>
		<xsl:variable name="thisDirectApp2PhysProcRels" select="$impactApptoPhysProcesses[own_slot_value[slot_reference=('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($thisDirectApps, $thisInScopeAPRs)/name]"/>
		<xsl:variable name="thisDirectPhysProcs" select="$impactPhysProcesses[name = $thisDirectApp2PhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="thisDirectOrgs" select="$impactOrgs[name = $thisDirectPhysProcs/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisDirectBusProcs" select="$impactBusProcesses[name = $thisDirectPhysProcs/own_slot_value[slot_reference='implements_business_process']/value]"/>
		<xsl:variable name="thisDirectBusCaps" select="$impactBusinessCapabilities[name = $thisDirectBusProcs/own_slot_value[slot_reference='realises_business_capability']/value]"/>
		<xsl:variable name="thisDirectBusCapAncestors" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'supports_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapDescendants" select="eas:get_object_descendants($thisDirectBusCaps, $impactBusinessCapabilities, 0, 5, 'contained_business_capabilities')"/>
		<xsl:variable name="thisDirectBusCapRelatives" select="$thisDirectBusCapAncestors union $thisDirectBusCapDescendants"/>-->
		
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisinScopeTechCapRelatives)"/>],
		"directImpacts": [<xsl:apply-templates mode="ImpactIdListJSON" select="($thisDirectApps)"/>]
		}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="CostTypeImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RevenueTypeImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="BusOutcomeImpactJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>": {
		<xsl:call-template name="RenderImpactIdNameJSON"><xsl:with-param name="this" select="$this"/></xsl:call-template>,
		"scopeIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="($this)"/>],
		"directImpacts": []	
		}<xsl:if test="not(position() = last())">,</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="ImpactIdListJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		"<xsl:value-of select="$this/name"/>"<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	<xsl:template name="RenderImpactIdNameJSON">
		<xsl:param name="this"/>
		
		"id": "<xsl:value-of select="$this/name"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"meta": {
			"anchorClass": "<xsl:value-of select="$this/type"/>"
		}
	</xsl:template>
	
	<xsl:template name="RenderDirecImpactListJSON">
		<xsl:param name="impactedElements"/>
		<xsl:param name="impactClass"/>
		
		{
		"impactIds": [<xsl:apply-templates mode="ImpactIdListJSON" select="$impactedElements"/>],
		"meta": {
		"anchorClass": "<xsl:value-of select="$impactClass"/>"
		}
		}
	</xsl:template>
	
	
	<xsl:template match="node()" mode="InstanceSimpleJSON">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		 
		
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'link': string(translate(translate($thisLink,'}',')'),'{',')')),
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"type": "<xsl:value-of select="$this/type"/>" 
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
		
</xsl:stylesheet>
