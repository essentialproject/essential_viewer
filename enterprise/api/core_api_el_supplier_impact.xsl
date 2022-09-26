<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
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
	<!-- 03.09.2019 JP  Created	 template-->
	<xsl:variable name="busCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCaps" select="/node()/simple_instance[type = 'Report_Constant'][own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$busCaps[name = $rootBusCaps/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="rootLevelBusCaps" select="$busCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="supplier" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product'][own_slot_value[slot_reference = 'supplier_technology_product']/value = $supplier/name]"/>
	<xsl:variable name="allTPRs" select="/node()/simple_instance[type = 'Technology_Product_Role'][name = $allTechProds/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
	<xsl:key name="allTPRsKey" match="/node()/simple_instance[type = 'Technology_Product_Role']" use="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
	<xsl:key name="allTPUKey" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference = 'provider_as_role']/value"/>
	<xsl:variable name="allTPU" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference = 'provider_as_role']/value = $allTPRs/name]"/>
	<xsl:key name="allTBAKey" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference = 'contained_architecture_components']/value"/>
	<xsl:variable name="allTBA" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference = 'contained_architecture_components']/value = $allTPU/name]"/>
	<xsl:key name="allTPBKey" match="/node()/simple_instance[type = 'Technology_Product_Build']" use="own_slot_value[slot_reference = 'technology_provider_architecture']/value"/>
	<xsl:variable name="allTPB" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference = 'technology_provider_architecture']/value = $allTBA/name]"/>
	<xsl:key name="allAppDepsKey" match="/node()/simple_instance[type = 'Application_Deployment']" use="own_slot_value[slot_reference = 'application_deployment_technical_arch']/value"/>
	<xsl:variable name="allAppDeps" select="/node()/simple_instance[type = ('Application_Deployment')][own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $allTPB/name]"/>
	<xsl:key name="allTechAppsKey" match="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'deployments_of_application_provider']/value"/>
	<xsl:variable name="allTechApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $allAppDeps/name]"/>
    <xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'ap_supplier']/value = $supplier/name] union $allTechApps"/>
	
	<xsl:key name="allAPRKey" match="/node()/simple_instance[type = ('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/>
	<xsl:variable name="allAPRs" select="/node()/simple_instance[type = 'Application_Provider_Role'][own_slot_value[slot_reference = 'role_for_application_provider']/value = $allApps/name]"/>
	<xsl:key name="allApptoProcsDirectKey" match="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/>
	<xsl:variable name="allApptoProcsDirect" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $allApps/name]"/>
	<xsl:key name="allAPRstoProcsIndirectKey" match="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
	<xsl:variable name="allAPRstoProcsIndirect" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $allAPRs/name]"/>
	<xsl:variable name="allAPRstoProcs" select="$allAPRstoProcsIndirect union $allApptoProcsDirect"/>
	<xsl:key name="allAPRstoProcsIndirectKey" match="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
	<xsl:key name="allPhysProcsBaseKey" match="/node()/simple_instance[type = ('Physical_Process')]" use="own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value"/>
	<xsl:variable name="allPhysProcsBase" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:key name="allPhysProcsKey" match="/node()/simple_instance[type = ('Physical_Process')]" use="own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value"/>
	<xsl:variable name="allPhysProcs" select="$allPhysProcsBase[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $allAPRstoProcs/name]"/>
	<xsl:key name="allBusProcsKey" match="/node()/simple_instance[type = ('Business_Process')]" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process'][own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value = $allPhysProcs/name]"/>
	<xsl:variable name="allOrg" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][name = $allPhysProcsBase/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="directOrg" select="/node()/simple_instance[type = 'Group_Actor'][name = $allPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="allviaActors" select="/node()/simple_instance[type = 'Group_Actor'][own_slot_value[slot_reference = 'actor_plays_role']/value = $allOrg/name]"/>

	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="allStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value = $allObjectives/name]"/>
	<xsl:variable name="allPlannedElements" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][name = $allStratPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>
	<xsl:variable name="allPlannedActions" select="/node()/simple_instance[type = 'Planning_Action'][name = $allPlannedElements/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>

	<xsl:variable name="supplierContracts" select="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION'][own_slot_value[slot_reference = 'obligation_component_to_element']/value = $allTechProds/name or own_slot_value[slot_reference = 'obligation_component_to_element']/value = $allApps/name]"/>
	<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	<xsl:variable name="contracts" select="/node()/simple_instance[type = 'Compliance_Obligation'][name = $supplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value][own_slot_value[slot_reference = 'compliance_obligation_licenses']/value = $alllicenses/name]"/>
	<xsl:variable name="licenses" select="/node()/simple_instance[type = 'License'][name = $contracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
	<xsl:variable name="actualContracts" select="/node()/simple_instance[type = 'Contract'][own_slot_value[slot_reference = 'contract_uses_license']/value = $licenses/name]"/>
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>


	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="geoLocation" select="/node()/simple_instance[type = 'Geographic_Location'][name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="geoCode" select="/node()/simple_instance[type = 'GeoCode'][name = $geoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>

	<xsl:template match="knowledge_base">
		{
			"suppliers": [<xsl:apply-templates select="$supplier" mode="supplier"/>],
			"capabilities":[<xsl:apply-templates select="$rootLevelBusCaps" mode="busCaps"/>],
			"plans":[<xsl:apply-templates select="$allStratPlans" mode="stratPlans"/>]      
		}
	</xsl:template>

		<xsl:template match="node()" mode="getProcesses">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisPhysProcs" select="key('allPhysProcsKey',$this/name)"/>
			<xsl:variable name="thisPhysProcs2"
				select="$allPhysProcsBase[name = $this/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]" />
			<xsl:variable name="thisOrgs"
				select="$allOrg[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]" />
			<xsl:variable name="thisdirectOrg"
				select="$directOrg[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]" />
			<xsl:variable name="thisviaActors"
				select="$allviaActors[own_slot_value[slot_reference = 'actor_plays_role']/value = $thisOrgs/name]" />
			<xsl:variable name="thisIsActors" select="$thisviaActors | $thisdirectOrg" /> {"id":"
			<xsl:value-of select="eas:getSafeJSString(current()/name)" />","name":"<xsl:call-template
				name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this" />
				<xsl:with-param name="isRenderAsJSString" select="true()" />
			</xsl:call-template>", "teams":[<xsl:apply-templates select="$thisIsActors" mode="Teams" />]}, </xsl:template>
		<xsl:template match="node()" mode="appList"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",							"name":"<xsl:call-template
				name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()" />
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>"}, </xsl:template>
		<xsl:template match="node()" mode="Teams"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "teams":[]}, </xsl:template>
		<xsl:template match="node()" mode="busCaps">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="subCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","subCaps":[ <xsl:apply-templates select="$subCaps" mode="subCaps"/>]}<xsl:if test="position()!=last()">,</xsl:if> </xsl:template>
		<xsl:template match="node()" mode="subCaps">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="relatedCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","relatedCaps":[<xsl:apply-templates select="$relatedCaps" mode="relatedCaps"/>{}]}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
		<xsl:template match="node()" mode="relatedCaps">
			<xsl:param name="num" select="1"/>
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="relatedCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","num":<xsl:value-of select="$num"/>}<xsl:if test="position()!=last()">,</xsl:if><xsl:if test="$num &lt; 10"><xsl:choose><xsl:when test="position()!=last()"></xsl:when><xsl:otherwise>,</xsl:otherwise></xsl:choose><xsl:apply-templates select="$relatedCaps" mode="relatedCaps"><xsl:with-param name="num" select="$num + 1"/></xsl:apply-templates></xsl:if>
		</xsl:template>
	
		<xsl:template match="node()" mode="supplier">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="thisTechProds" select="$allTechProds[own_slot_value[slot_reference = 'supplier_technology_product']/value = $this/name]"/>
			<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'ap_supplier']/value = $this/name]"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "technologies":[<xsl:apply-templates select="$thisTechProds" mode="supplierTech"/>], "apps":[<xsl:apply-templates select="$thisApps" mode="supplierApp"/>],
			"licences":[<xsl:apply-templates select="$thisApps" mode="productList"/>],
			"techlicences":[<xsl:apply-templates select="$thisTechProds" mode="productList"/>]
			}<xsl:if test="position()!=last()">,</xsl:if> </xsl:template>
	
	
		<xsl:template match="node()" mode="supplierTech"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>","impacted":[<xsl:apply-templates select="$this" mode="TechCaps"/>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
	
		<xsl:template match="node()" mode="TechCaps"><xsl:variable name="this" select="current()"/>
			<xsl:variable name="thisTPRs2" select="$allTPRs[name = $this/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
			<xsl:variable name="thisTPRs" select="key('allTPRsKey',$this)"/>
			<xsl:variable name="thisTPU" select="key('allTPUKey',$thisTPRs)"/>
			<xsl:variable name="thisTBA" select="key('allTBAKey',$thisTPU)"/>
			<xsl:variable name="thisTPB" select="key('allTPBKey',$thisTBA)"/>
			<xsl:variable name="thisAppDeps" select="key('allAppDepsKey',$thisTPB)"/>
			<xsl:variable name="thisTechApps" select="key('allTechAppsKey',$thisAppDeps)"/>
			<xsl:variable name="thisAPRs" select="key('allAPRKey',$thisTechApps)"/>	 
			<xsl:variable name="thisAPRstoProcs" select="$allAPRstoProcs[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $thisAPRs/name]"/>
			
			<xsl:variable name="thisPhysProcs" select="key('allPhysProcsBaseKey', $thisAPRstoProcs/name)"/>
			<xsl:variable name="thisBusProcs" select="key('allBusProcsKey', $thisPhysProcs/name)"/>
			<xsl:variable name="thisBusCaps" select="$busCaps[name = $thisBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/> {"apps":[<xsl:apply-templates select="$thisTechApps" mode="stdImpact"/>]}, {"processes":[<xsl:apply-templates select="$thisBusProcs" mode="stdImpact"/>]}, {"caps":[<xsl:apply-templates select="$thisBusCaps" mode="capImpact"><xsl:with-param name="thisBusProcs" select="$thisBusProcs"/></xsl:apply-templates>]},{"capAscendents":[<xsl:for-each select="$thisBusCaps"><xsl:apply-templates select="current()" mode="parentBusCaps"></xsl:apply-templates></xsl:for-each>""]}<xsl:if test="position()!=last()">,</xsl:if> </xsl:template>
	
	
		<xsl:template match="node()" mode="supplierApp">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisAPRs" select="key('allAPRKey',current()/name)"/>
 
			<xsl:variable name="thisApptoProcsDirect" select="key('allApptoProcsDirectKey', current()/name)"/>	
			<xsl:variable name="thisAPRstoProcsIndirect" select="key('allAPRstoProcsIndirectKey', $thisAPRs/name)"/>	
 
			<xsl:variable name="thisAPRstoProcs" select="$thisAPRstoProcsIndirect union $thisApptoProcsDirect" />
			<xsl:variable name="thisPhysProcs" select="key('allPhysProcsBaseKey',$thisAPRstoProcs/name)"/>
	 
				<xsl:variable name="thisBusProcs" select="key('allBusProcsKey',$thisPhysProcs/name)"/>
		 
			<xsl:variable name="thisBusCaps"
				select="$busCaps[name = $thisBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]" />
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",
			"simplename":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this" />
				<xsl:with-param name="isRenderAsJSString" select="true()" />
			</xsl:call-template>",
			"name":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()" />
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>",
			"license":"tbc",
			"capAscendents":[<xsl:for-each select="$thisBusCaps"><xsl:apply-templates select="current()" mode="parentBusCaps"></xsl:apply-templates></xsl:for-each>""],
			"capabilitiesImpacted":[<xsl:apply-templates select="$thisBusCaps" mode="capImpact">
				<xsl:with-param name="thisBusProcs" select="$thisBusProcs" />
			</xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="parentBusCaps">
			<xsl:variable name="parent" select="$busCaps[name=current()/own_slot_value[slot_reference='supports_business_capabilities']/value]"/>
			<xsl:for-each select="$parent">
					<xsl:variable name="thisparent" select="$busCaps[name=current()/own_slot_value[slot_reference='supports_business_capabilities']/value]"/>
					"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					<xsl:if test="$thisparent"><xsl:apply-templates select="current()" mode="parentBusCaps"></xsl:apply-templates></xsl:if>
			</xsl:for-each>
			
		</xsl:template>
	
		<xsl:template match="node()" mode="stratPlans">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisStratPlans"
				select="$allObjectives[name = $this/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value]" />
			<xsl:variable name="thisPlannedElements"
				select="$allPlannedElements[name = $this/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]" />
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",
			"name":"<xsl:call-template
				name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this" />
				<xsl:with-param name="isRenderAsJSString" select="true()" />
			</xsl:call-template>", "fromDate":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value" />",
			"endDate":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value" />",
			"impacts":[<xsl:apply-templates select="$thisPlannedElements" mode="planImpact" />], 
			"objectives":[<xsl:apply-templates select="$thisStratPlans" mode="stdImpact" />] }<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
	
		<xsl:template match="node()" mode="planImpact">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisPlannedActions"
				select="$allPlannedActions[name = $this/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]" />
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",
			"impacted_element":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value" />",
			"planned_action":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisPlannedActions" />
				<xsl:with-param name="isRenderAsJSString" select="true()" />
			</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
	
		<xsl:template match="node()" mode="stdImpact"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","simplename":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
	
		<xsl:template match="node()" mode="capImpact"><xsl:param name="thisBusProcs"/><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>","processes":[<xsl:apply-templates select="$thisBusProcs" mode="stdImpact"/>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
	
		<xsl:template match="node()" mode="productList">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="thisSupplierContracts" select="$supplierContracts[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $this/name]"/>
			<xsl:variable name="thisContracts" select="$contracts[name = $thisSupplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value]"/>
		 
					<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
					<xsl:variable name="thisActualContract" select="$actualContracts[own_slot_value[slot_reference = 'contract_uses_license']/value = $thisLicenses/name]"/>
					<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
					<xsl:variable name="endYear"><xsl:choose><xsl:when test="$thisLicenses"><xsl:value-of select="functx:add-months(xs:date(substring($thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $period)"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable> 
						{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						  "productSimple":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
						  "product": "<xsl:call-template name="RenderInstanceLinkForJS">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="anchorClass">text-black</xsl:with-param>
						</xsl:call-template>",
						"oid":"<xsl:value-of select="$this/name"/>",
						"Contract":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisContracts"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
						"Licence":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisLicenses"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
						"LicenceType":"<xsl:value-of select="$licenseType[name = $thisLicenses/own_slot_value[slot_reference = 'license_type']/value]/own_slot_value[slot_reference = 'name']/value"/>",
						"licenseOnContract":"<xsl:value-of select="$thisActualContract/own_slot_value[slot_reference = 'contract_number_of_units']/value"/>", 
						"dateISO":"<xsl:value-of select="$endYear"/>",
						"status":"contract"}<xsl:if test="position()!=last()">,</xsl:if>
				 
		</xsl:template>
		<xsl:template match="node()" mode="techproductList">
			<xsl:param name="appCount"/>
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="thisSupplierContracts" select="$supplierContracts[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $this/name]"/>
			<xsl:variable name="thisContracts" select="$contracts[name = $thisSupplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value]"/>
					 
								<xsl:if test="$appCount &gt; 0">,</xsl:if>
								<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
								<xsl:variable name="thisActualContract" select="$actualContracts[own_slot_value[slot_reference = 'contract_uses_license']/value = $thisLicenses/name]"/>
								<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
								<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
								<xsl:variable name="endYear"><xsl:choose><xsl:when test="$thisLicenses"><xsl:value-of select="functx:add-months(xs:date(substring($thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $period)"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable> 
									  {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
									  "productSimple":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
									  "product": "<xsl:call-template name="RenderInstanceLinkForJS">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="anchorClass">text-black</xsl:with-param>
									</xsl:call-template>",
									"oid":"<xsl:value-of select="$this/name"/>",
									"Contract":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisContracts"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
									"Licence":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisLicenses"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
									"LicenceType":"<xsl:value-of select="$licenseType[name = $thisLicenses/own_slot_value[slot_reference = 'license_type']/value]/own_slot_value[slot_reference = 'name']/value"/>",
									"licenseOnContract":"<xsl:value-of select="$thisActualContract/own_slot_value[slot_reference = 'contract_number_of_units']/value"/>", 
									"dateISO":"<xsl:value-of select="$endYear"/>",
									"status":"contract"}  
		</xsl:template>
</xsl:stylesheet>
