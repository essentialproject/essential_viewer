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
	<xsl:key name="busCapskey" match="/node()/simple_instance[type = 'Business_Capability']" use="type"/>
	<xsl:key name="allElementskey" match="/node()/simple_instance[type = ('Business_Process', 'Application_Provider','Composite_Application_Provider','Technology_Product')]" use="name"/>
	<xsl:variable name="busCaps" select="key('busCapskey','Business_Capability')"/>
	<xsl:key name="busCapsContainedkey" match="/node()/simple_instance[type = 'Business_Capability']" use="own_slot_value[slot_reference = 'contained_business_capabilities']/value"/>
	<xsl:key name="busCapsProcesskey" match="/node()/simple_instance[type = 'Business_Capability']" use="own_slot_value[slot_reference = 'realised_by_business_processes']/value"/>
	<xsl:variable name="rootBusCaps" select="/node()/simple_instance[type = 'Report_Constant'][own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$busCaps[name = $rootBusCaps/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:key name="suppBusCapskey" match="$busCaps" use="own_slot_value[slot_reference = 'supports_business_capabilities']/value"/>
	<xsl:variable name="rootLevelBusCaps" select="key('suppBusCapskey', $rootBusCap/name)"/>
	<xsl:variable name="contractActor" select="/node()/simple_instance[type='Group_Business_Role'][own_slot_value[slot_reference = 'name']/value='Contract Organisation Owner']"/>
	
	<!--
	<xsl:variable name="rootLevelBusCaps" select="$busCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	-->
	<xsl:key name="supplierkey" match="/node()/simple_instance[type = 'Supplier']" use="type"/>
	<xsl:variable name="supplier" select="key('supplierkey','Supplier')"/> 
	<xsl:key name="allAppskey" match="/node()/simple_instance[type =('Application_Provider', 'Composite_Application_Provider')]" use="type"/>
	<xsl:variable name="allApplications" select="key('allAppskey',('Application_Provider', 'Composite_Application_Provider'))"/> 
	<!--<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product'][own_slot_value[slot_reference = 'supplier_technology_product']/value = $supplier/name]"/>-->
	<xsl:key name="allTechProdsKey" match="/node()/simple_instance[type = 'Technology_Product']" use="own_slot_value[slot_reference = 'supplier_technology_product']/value"/>
	<xsl:variable name="allTechProds" select="key('allTechProdsKey',$supplier/name)"/>
	<xsl:variable name="archivedStatus" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'SYS_CONTENT_ARCHIVED']"/>

	<xsl:variable name="allTPRs" select="/node()/simple_instance[type = 'Technology_Product_Role'][name = $allTechProds/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
	<xsl:key name="allTPRsKey" match="/node()/simple_instance[type = 'Technology_Product_Role']" use="own_slot_value[slot_reference = 'role_for_technology_provider']/value"/>
	<xsl:key name="allTPUKey" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference = 'provider_as_role']/value"/>
	<xsl:variable name="allTPU" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference = 'provider_as_role']/value = $allTPRs/name]"/>
	<xsl:key name="allTBAKey" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference = 'contained_architecture_components']/value"/>
	<xsl:variable name="allTBA" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference = 'contained_architecture_components']/value = $allTPU/name]"/>
	<xsl:key name="allTPBKey" match="/node()/simple_instance[type = 'Technology_Product_Build']" use="own_slot_value[slot_reference = 'technology_provider_architecture']/value"/>
	<xsl:variable name="allTPB" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference = 'technology_provider_architecture']/value = $allTBA/name]"/>
	<xsl:key name="allAppDepsKey" match="/node()/simple_instance[type = 'Application_Deployment']" use="own_slot_value[slot_reference = 'application_deployment_technical_arch']/value"/>
	<!--<xsl:variable name="allAppDeps" select="/node()/simple_instance[type = ('Application_Deployment')][own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $allTPB/name]"/>-->
	<xsl:variable name="allAppDeps" select="key('allAppDepsKey',$allTPB/name)"/>
	<xsl:key name="allTechAppsKey" match="$allApplications" use="own_slot_value[slot_reference = 'deployments_of_application_provider']/value"/>
	<!--<xsl:variable name="allTechApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $allAppDeps/name]"/>
	<xsl:variable name="allTechApps" select="key('allTechAppsKey',$allAppDeps/name)"/>-->
    <xsl:variable name="allApps" select="$allApplications"/>
	<xsl:key name="allTechProdsKey" match="/node()/simple_instance[type = 'Technology_Product']" use="own_slot_value[slot_reference = 'supplier_technology_product']/value"/>
	
	<xsl:key name="appSupplierKey" match="$allApplications" use="own_slot_value[slot_reference = 'ap_supplier']/value"/>
	
	<xsl:key name="allAPRKey" match="/node()/simple_instance[type = ('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'role_for_application_provider']/value"/> 
	<xsl:key name="allApptoProcsDirectKey" match="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value"/>
 
	<xsl:key name="allAPRstoProcsIndirectKey" match="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
	
	<xsl:key name="allAPRstoProcsKey" match="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>
	<xsl:key name="allAPRstoProcsIndirectKey" match="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value"/>

	<xsl:variable name="allPhysProcsBase" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:key name="allPhysProcsBaseKey" match="$allPhysProcsBase" use="type"/>
	<xsl:key name="allPhysProcsKey" match="$allPhysProcsBase" use="own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value"/>
	<xsl:variable name="allPhysProcs" select="key('allPhysProcsBaseKey',  'Physical_Process')"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = ('Business_Process')]"/>
	<xsl:key name="allBusProcsKey" match="$allBusProcs" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/> 
	<xsl:variable name="allOrg" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][name = $allPhysProcsBase/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:key name="allOrgKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference = 'performs_physical_process']/value"/>
	<xsl:key name="allOrgKeyname" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
	<xsl:key name="allA2RKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
	<xsl:variable name="allGAs" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:key name="allGroupActors" match="/node()/simple_instance[type = 'Group_Actor']" use="name"/>
	<xsl:key name="directOrgKey" match="$allGAs" use="own_slot_value[slot_reference = 'performs_physical_process']/value"/>
	<xsl:variable name="directOrg" select="$allGAs[name = $allPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/> 
	<xsl:key name="directOrgKeyName" match="$allGAs" use="name"/> 
	<xsl:key name="allActorsKey" match="$allGAs" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>

	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:key name="allObjectivesKey" match="/node()/simple_instance[type = 'Business_Objective']" use="own_slot_value[slot_reference = 'objective_supported_by_strategic_plan']/value"/>
	<xsl:key name="allStratPlansKey" match="/node()/simple_instance[type = 'Enterprise_Strategic_Plan']" use="own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value"/>
	<xsl:variable name="allStratPlans" select="key('allStratPlansKey', $allObjectives/name)"/>
	<xsl:key name="allPEKey" match="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']" use="type"/>
	<xsl:variable name="allPlannedElements" select="key('allPEKey', 'PLAN_TO_ELEMENT_RELATION')"/>
	<xsl:key name="allPlannedElementsKey" match="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_plan']/value"/>
	
	<xsl:variable name="allPlannedActions" select="/node()/simple_instance[type = 'Planning_Action'][name = $allPlannedElements/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>

	<!-- old way deprecated do not use, reatined for legacy -->
	<xsl:key name="supplierContractsKey" match="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION']" use="own_slot_value[slot_reference = 'obligation_component_to_element']/value"/>
	<xsl:key name="contractsKey" match="/node()/simple_instance[type = 'Compliance_Obligation']" use="own_slot_value[slot_reference = 'obligation_applies_to']/value"/>
	<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	 
	<xsl:key name="licencesKey" match="$alllicenses" use="own_slot_value[slot_reference = 'license_compliance_obligations']/value"/>
 
	<xsl:key name="contractsLicenceKey" match="/node()/simple_instance[type = 'Contract']" use="own_slot_value[slot_reference = 'contract_uses_license']/value"/>
 
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>
	<!-- end legacy -->
	<xsl:variable name="allContracts" select="/node()/simple_instance[(type='Contract')  and not(own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $archivedStatus/name)]"/>
	<xsl:key name="allContractsKey" match="/node()/simple_instance[(type='Contract')]" use="own_slot_value[slot_reference = 'contract_supplier']/value"/>
	<xsl:key name="allContractsforKey" match="/node()/simple_instance[(type='Contract')]" use="own_slot_value[slot_reference = 'contract_for']/value"/>

	<xsl:variable name="allContractSuppliers" select="$supplier[name = $allContracts/own_slot_value[slot_reference = 'contract_supplier']/value]"/>
	<xsl:variable name="allContractLinks" select="/node()/simple_instance[name = $allContracts/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
	<xsl:variable name="allContractToElementRels" select="/node()/simple_instance[name = $allContracts/own_slot_value[slot_reference = 'contract_for']/value]"/>
	<xsl:key name="ccr_Key" match="/node()/simple_instance[(type='CONTRACT_COMPONENT_RELATION')]" use="own_slot_value[slot_reference = 'contract_component_to_element']/value"/>
	<xsl:key name="ccrfromContract_Key" match="/node()/simple_instance[(type='CONTRACT_COMPONENT_RELATION')]" use="own_slot_value[slot_reference = 'contract_component_from_contract']/value"/>
	<xsl:variable name="allContractElements" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
	<xsl:variable name="allLicenses" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'ccr_license']/value]"/>
	<xsl:variable name="allRenewalModels" select="/node()/simple_instance[type='Contract_Renewal_Model']"/>
	<xsl:variable name="allContractTypes" select="/node()/simple_instance[type='Contract_Type']"/>
	<xsl:variable name="allUnitTypes" select="/node()/simple_instance[type='License_Model']"/>
	<xsl:key name="allContractsTypeKey" match="/node()/simple_instance[type = 'Contract']" use="type"/>
	<xsl:key name="allContractsCompTypeKey" match="/node()/simple_instance[type = 'CONTRACT_COMPONENT_RELATION']" use="type"/>
	<xsl:variable name="supplierRelStatii" select="/node()/simple_instance[type = 'Supplier_Relationship_Status']"/>
	<xsl:key name="allExternalLink_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/>
	<xsl:variable name="currencyRC" select="/node()/simple_instance[type='Report_Constant'][own_slot_value[slot_reference='name']/value='Default Currency']"/>
	<xsl:variable name="allCurrencies" select="/node()/simple_instance[type='Currency']"/>
	<xsl:variable name="currency" select="$allCurrencies[name=$currencyRC/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
	<xsl:key name="nameLookups" match="/node()/simple_instance[type = ('Business_Process','Composite_Application_Provider','Application_Provider', 'Technology_Product', 'Business_Capability', 'Supplier')]" use="name"/>
	<!--$allTechProds union $supplier union $allOrg union $directOrg union $allPlannedActions union $licenseType union $allLicenses union $busCaps-->
	<xsl:template match="knowledge_base">
		{
			"suppliers": [<xsl:apply-templates select="$supplier" mode="supplier"/>],
			"capabilities":[<xsl:apply-templates select="$rootLevelBusCaps" mode="busCaps"/>], 
			"contracts":[<xsl:apply-templates select="key('allContractsTypeKey','Contract')" mode="RenderContractJSON"/>],
			"contract_components":[<xsl:apply-templates select="key('allContractsCompTypeKey','CONTRACT_COMPONENT_RELATION')" mode="contractComp"/>],
			"enums":[<xsl:apply-templates select="$allRenewalModels union $allContractTypes union $allUnitTypes union $allCurrencies union $supplierRelStatii" mode="enums"/>],
			"plans":[<xsl:apply-templates select="$allStratPlans" mode="stratPlans"/>]      
		}
	</xsl:template>
	
		<xsl:template match="node()" mode="getProcesses">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisPhysProcs" select="key('allPhysProcsKey',$this/name)"/>
			<xsl:variable name="thisOrgs"
				select="key('allOrgKeyname', $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)" />
			<xsl:variable name="thisdirectOrg"
				select="key('directOrgKeyName', $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)" />
			<xsl:variable name="thisviaActors" select="key('allActorsKey',$thisOrgs/name)" />
			<xsl:variable name="thisIsActors" select="$thisviaActors | $thisdirectOrg" /> {"id":"
			<xsl:value-of select="eas:getSafeJSString(current()/name)" />","repoId":"<xsl:value-of select="current()/name" />",<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>", 
			"className":"<xsl:value-of select="current()/type"/>",
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
			"teams":[<xsl:apply-templates select="$thisIsActors" mode="Teams" />]}, </xsl:template>
		<xsl:template match="node()" mode="appList"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",		
		"repoId":"<xsl:value-of select="current()/name" />",		
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"className":"<xsl:value-of select="current()/type"/>"}, </xsl:template>
		<xsl:template match="node()" mode="Teams"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","repoId":"<xsl:value-of select="current()/name" />",		
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "teams":[]}, </xsl:template>
		<xsl:template match="node()" mode="busCaps">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="subCaps" select="key('suppBusCapskey', current()/name)"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"className":"<xsl:value-of select="current()/type"/>","subCaps":[ <xsl:apply-templates select="$subCaps" mode="subCaps"/>],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if> </xsl:template>
		<xsl:template match="node()" mode="subCaps">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="relatedCaps" select="key('suppBusCapskey', current()/name)"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","className":"<xsl:value-of select="current()/type"/>","repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"relatedCaps":[<xsl:apply-templates select="$relatedCaps" mode="relatedCaps"/>{}],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
		<xsl:template match="node()" mode="relatedCaps">
			<xsl:param name="num" select="1"/>
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="relatedCaps" select="key('suppBusCapskey', current()/name)"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"className":"<xsl:value-of select="current()/type"/>","last":"<xsl:value-of select="last()"/>", "pos":"<xsl:value-of select="position()"/>" ,"num":<xsl:value-of select="$num"/>}<xsl:if test="(position() = last())"><xsl:if test="$num=10">,</xsl:if></xsl:if><xsl:if test="position()!=last()">,</xsl:if><xsl:if test="$num &lt; 10"><xsl:choose><xsl:when test="position()!=last()"></xsl:when><xsl:otherwise>,</xsl:otherwise></xsl:choose><xsl:apply-templates select="$relatedCaps" mode="relatedCaps"><xsl:with-param name="num" select="$num + 1"/></xsl:apply-templates></xsl:if>
		</xsl:template>
	
		<xsl:template match="node()" mode="supplier">
			<xsl:variable name="this" select="current()"/>
			<xsl:variable name="supplierRelStatus" select="$supplierRelStatii[name = current()/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/> 
			<!--<xsl:variable name="thisTechProds" select="$allTechProds[own_slot_value[slot_reference = 'supplier_technology_product']/value = $this/name]"/>-->
			<xsl:variable name="thisTechProds" select="key('allTechProdsKey',$this/name)"/>
	<!--		<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'ap_supplier']/value = $this/name]"/> --> 
			<xsl:variable name="thisApps" select="key('appSupplierKey', $this/name)"/>
			<xsl:variable name="thisContracts" select="key('allContractsKey', $this/name)"/>
			
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
				'supplier_url': string(translate(translate(current()/own_slot_value[slot_reference = ('supplier_url')]/value,'}',')'),'{',')')),
				'supplierRelStatus': string(translate(translate($supplierRelStatus/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "technologies":[<xsl:apply-templates select="$thisTechProds" mode="supplierTech"/>], "apps":[<xsl:apply-templates select="$thisApps" mode="supplierApp"/>],
			"visId": ["<xsl:value-of select="current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value"/>"],
<!-- system_content_lifecycle_status -->
			"licences":[<xsl:apply-templates select="$thisApps" mode="productList"/>],
			"contracts":[<xsl:apply-templates select="$thisContracts" mode="RenderContractJSON"/>], 
			"techlicences":[<xsl:apply-templates select="$thisTechProds" mode="productList"/>],
			"className":"<xsl:value-of select="current()/type"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if> </xsl:template>
	
	
		<xsl:template match="node()" mode="supplierTech"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","repoId":"<xsl:value-of select="current()/name" />",		
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, "className":"<xsl:value-of select="current()/type"/>", "impacted":[<xsl:apply-templates select="$this" mode="TechCaps"/>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
	
		<xsl:template match="node()" mode="TechCaps"><xsl:variable name="this" select="current()"/>
		 <!-- not used currently
			<xsl:variable name="thisTPRs" select="key('allTPRsKey',$this)"/>
			<xsl:variable name="thisTPU" select="key('allTPUKey',$thisTPRs/name)"/>
			<xsl:variable name="thisTBA" select="key('allTBAKey',$thisTPU/name)"/>
			<xsl:variable name="thisTPB" select="key('allTPBKey',$thisTBA/name)"/>
			<xsl:variable name="thisAppDeps" select="key('allAppDepsKey',$thisTPB/name)"/>
			<xsl:variable name="thisTechApps" select="key('allTechAppsKey',$thisAppDeps/name)"/>
			<xsl:variable name="thisAPRs" select="key('allAPRKey',$thisTechApps/name)"/>	  
			<xsl:variable name="thisAPRstoProcs" select="key('allAPRstoProcsKey', $thisAPRs/name)"/> 
			<xsl:variable name="thisPhysProcs" select="key('allPhysProcsKey', $thisAPRstoProcs/name)"/>
			<xsl:variable name="thisBusProcs" select="key('allBusProcsKey', $thisPhysProcs/name)"/>
			<xsl:variable name="thisBusCaps" select="key('busCapsProcesskey', $thisBusProcs/name)"/> 
			
			{
			"apps":[<xsl:apply-templates select="$thisTechApps" mode="stdImpact"/>]}, {"processes":[<xsl:apply-templates select="$thisBusProcs" mode="stdImpact"/>]}, {"caps":[<xsl:apply-templates select="$thisBusCaps" mode="capImpact"><xsl:with-param name="thisBusProcs" select="$thisBusProcs"/></xsl:apply-templates>]},{"capAscendents":[<xsl:for-each select="$thisBusCaps"><xsl:apply-templates select="current()" mode="parentBusCaps"></xsl:apply-templates></xsl:for-each>""]}<xsl:if test="position()!=last()">,</xsl:if>
			--> </xsl:template>
	
	
		<xsl:template match="node()" mode="supplierApp">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisAPRs" select="key('allAPRKey',current()/name)"/>
			<xsl:variable name="thisApptoProcsDirect" select="key('allApptoProcsDirectKey', current()/name)"/>	
			<xsl:variable name="thisAPRstoProcsIndirect" select="key('allAPRstoProcsIndirectKey', $thisAPRs/name)"/>	
			<xsl:variable name="thisAPRstoProcs" select="$thisAPRstoProcsIndirect union $thisApptoProcsDirect" />
			<xsl:variable name="thisPhysProcs" select="key('allPhysProcsKey',$thisAPRstoProcs/name)"/>
	 		<xsl:variable name="thisBusProcs" select="key('allBusProcsKey',$thisPhysProcs/name)"/>
			<xsl:variable name="thisBusCaps" select="key('busCapsProcesskey',$thisBusProcs/name)" />
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",
			"className":"<xsl:value-of select="current()/type"/>",
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
			"repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'simplename': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"license":"tbc",
			"capAscendents":[<xsl:for-each select="$thisBusCaps"><xsl:apply-templates select="current()" mode="parentBusCaps"></xsl:apply-templates></xsl:for-each>""],
			"capabilitiesImpacted":[<xsl:apply-templates select="$thisBusCaps" mode="capImpact">
				<xsl:with-param name="thisBusProcs" select="$thisBusProcs" />
			</xsl:apply-templates>]}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
		<xsl:template match="node()" mode="parentBusCaps">
			<xsl:variable name="parent" select="key('busCapsContainedkey', current()/value)"/>
			<!--<xsl:variable name="parent" select="$busCaps[name=current()/own_slot_value[slot_reference='supports_business_capabilities']/value]"/>-->
			<xsl:for-each select="$parent">
					<!--<xsl:variable name="thisparent" select="$busCaps[name=current()/own_slot_value[slot_reference='supports_business_capabilities']/value]"/>-->
					<xsl:variable name="thisparent" select="key('busCapsContainedkey', current()/value)"/>
					"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					<xsl:if test="$thisparent"><xsl:apply-templates select="current()" mode="parentBusCaps"></xsl:apply-templates></xsl:if>
			</xsl:for-each>
			
		</xsl:template>
	
		<xsl:template match="node()" mode="stratPlans">
			<xsl:variable name="this" select="current()" />
			<xsl:variable name="thisStratPlans"	select="key('allObjectivesKey', $this/name)"/> 
			<!--<xsl:variable name="thisStratPlans"
				select="$allObjectives[name = $this/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value]" />
			<xsl:variable name="thisPlannedElements"
				select="$allPlannedElements[name = $this/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]" />-->
			<xsl:variable name="thisPlannedElements" select="key('allPlannedElementsKey', $this/name)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />",
			"repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"fromDate":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value" />",
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
			"repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'planned_action': string(translate(translate($thisPlannedActions/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>
	
		<xsl:template match="node()" mode="stdImpact"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"repoId":"<xsl:value-of select="current()/name" />",		
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'simplename': string(translate(translate($this/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'name': string(translate(translate($this/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,"className":"<xsl:value-of select="current()/type"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
	
		<xsl:template match="node()" mode="capImpact"><xsl:param name="thisBusProcs"/><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","repoId":"<xsl:value-of select="current()/name" />",		
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate($this/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"className":"<xsl:value-of select="current()/type"/>",
	"processes":[<xsl:apply-templates select="$thisBusProcs" mode="stdImpact"/>]}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
	
		<xsl:template match="node()" mode="productList">
			<xsl:variable name="this" select="current()"/><!--
			<xsl:variable name="thisSupplierContracts" select="$supplierContracts[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $this/name]"/>--> 
	
			<xsl:variable name="thisSupplierContracts" select="key('supplierContractsKey', $this/name)"/>
		<!--	<xsl:variable name="thisContracts" select="$contracts[name = $thisSupplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value]"/>-->
			<xsl:variable name="thisContracts" select="key('contractsKey', $thisSupplierContracts/name)"/>
					<!--<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>-->
					<xsl:variable name="thisLicenses" select="key('licencesKey', $thisContracts/name)"/>
					<xsl:variable name="thisActualContract" select="key('contractsLicenceKey', $thisLicenses/name)"/>
					<!--
					<xsl:variable name="thisActualContract" select="$actualContracts[own_slot_value[slot_reference = 'contract_uses_license']/value = $thisLicenses/name]"/>-->
					<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
					<xsl:variable name="endYear"><xsl:choose><xsl:when test="$thisLicenses"><xsl:value-of select="functx:add-months(xs:date(substring($thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $period)"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable> 
						{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						"repoId":"<xsl:value-of select="current()/name" />",		
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'productSimple': string(translate(translate($this/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
							'product': string(translate(translate($this/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
							'Contract': string(translate(translate($thisContracts/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
							'Licence': string(translate(translate($thisLicenses/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
							'licenseOnContract': string(translate(translate($thisActualContract/own_slot_value[slot_reference = 'contract_number_of_units']/value,'}',')'),'{',')'))
						}" />
						<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
						<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
					  <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
						"oid":"<xsl:value-of select="$this/name"/>",
						"LicenceType":"<xsl:value-of select="$licenseType[name = $thisLicenses/own_slot_value[slot_reference = 'license_type']/value]/own_slot_value[slot_reference = 'name']/value"/>",
						"dateISO":"<xsl:value-of select="$endYear"/>",
						"status":"contract"
					}<xsl:if test="position()!=last()">,</xsl:if>
					
		</xsl:template>
		<xsl:template match="node()" mode="techproductList">
			<xsl:param name="appCount"/>
			<xsl:variable name="this" select="current()"/><!--
			<xsl:variable name="thisSupplierContracts" select="$supplierContracts[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $this/name]"/>
			<xsl:variable name="thisContracts" select="$contracts[name = $thisSupplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value]"/>-->
			<xsl:variable name="thisSupplierContracts" select="key('supplierContractsKey', $this/name)"/>
			<xsl:variable name="thisContracts" select="key('contractsKey', $thisSupplierContracts/name)"/>
								<xsl:if test="$appCount &gt; 0">,</xsl:if> 
								<xsl:variable name="thisLicenses" select="key('licencesKey',  $thisContracts/name)"/><!--
									<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
								<xsl:variable name="thisActualContract" select="$actualContracts[own_slot_value[slot_reference = 'contract_uses_license']/value = $thisLicenses/name]"/>--> 
								<xsl:variable name="thisActualContract" select="key('contractsLicenceKey', $thisLicenses/name)"/>
								<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
								<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
								<xsl:variable name="endYear"><xsl:choose><xsl:when test="$thisLicenses"><xsl:value-of select="functx:add-months(xs:date(substring($thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $period)"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable> 
									  {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
									  "repoId":"<xsl:value-of select="current()/name" />",		
									<xsl:variable name="combinedMap" as="map(*)" select="map{
										'productSimple': string(translate(translate($this/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
										'Contract': string(translate(translate($thisContracts/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
										'Licence': string(translate(translate($thisLicenses/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
										'licenseOnContract': string(translate(translate($thisActualContract/own_slot_value[slot_reference = 'contract_number_of_units']/value,'}',')'),'{',')'))
									}" />
									<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
									<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
									  "product": "<xsl:call-template name="RenderInstanceLinkForJS">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="anchorClass">text-black</xsl:with-param>
									</xsl:call-template>",
									<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
									"oid":"<xsl:value-of select="$this/name"/>",
									"LicenceType":"<xsl:value-of select="$licenseType[name = $thisLicenses/own_slot_value[slot_reference = 'license_type']/value]/own_slot_value[slot_reference = 'name']/value"/>", 
									"dateISO":"<xsl:value-of select="$endYear"/>",
									"status":"contract"}  
		</xsl:template>
	<xsl:template match="node()" mode="contractList">
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"repoId":"<xsl:value-of select="current()/name" />",		
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
	}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="RenderContractJSON">
		<xsl:variable name="this" select="current()"/>
	 
		<!--
		<xsl:variable name="thisDocLinks" select="$allContractLinks[name = $this/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
		<xsl:variable name="thisContractRels" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_from_contract']/value = $this/name]"/>
		-->
		<xsl:variable name="thisDocLinks" select="key('allExternalLink_key',$this/name)"/>
		
		<xsl:variable name="thisSupplier" select="key('nameLookups',  $this/own_slot_value[slot_reference = 'contract_supplier']/value)"/>
		
		<xsl:variable name="thisContractRels" select="key('ccrfromContract_Key',$this/name)"/>
	 
		<xsl:variable name="currentRenewalModel" select="$allRenewalModels[name = ($this, $thisContractRels)/own_slot_value[slot_reference = ('contract_renewal_model', 'ccr_renewal_model')]/value]"/>
		
		<xsl:variable name="contractSigDate" select="$this/own_slot_value[slot_reference = 'contract_signature_date_ISO8601']/value"/>
		<xsl:variable name="contractRenewalDate" select="$this/own_slot_value[slot_reference = 'contract_end_date_ISO8601']/value"/>
		<xsl:variable name="contractCost" select="$this/own_slot_value[slot_reference = 'contract_total_annual_cost']/value"/>
		<xsl:variable name="contractType" select="$allContractTypes[name = $this/own_slot_value[slot_reference = 'contract_type']/value]"></xsl:variable>
		<xsl:variable name="supplierRelStatus" select="$supplierRelStatii[name = $thisSupplier/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
		<xsl:variable name="renewalNoticeDays">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalReviewDays">
			<xsl:choose>
				<xsl:when test="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value">
					<xsl:value-of select="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="thisBusProcs" select="key('nameLookups', $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>
		<xsl:variable name="thisApps" select="key('nameLookups',  $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>
		<xsl:variable name="thisTechProds" select="key('nameLookups',  $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>

		<xsl:variable name="thisApps" select="key('nameLookups',  $thisContractRels/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>
	<xsl:variable name="thisa2r" select="key('allA2RKey', current()/own_slot_value[slot_reference = 'stakeholders']/value)"/>
	<xsl:variable name="thisa2rFilter" select="$thisa2r[own_slot_value[slot_reference = 'act_to_role_to_role']/value=$contractActor/name]"/>
	<xsl:variable name="thisa2rActor" select="key('allActorsKey', $thisa2rFilter/name)"/>
	<xsl:variable name="thisContractType" select="$allContractTypes[name=current()/own_slot_value[slot_reference = ('contract_type')]/value]"/>
	<xsl:variable name="thisActor" select="key('allGroupActors', current()/own_slot_value[slot_reference = ('contract_customer')]/value)"/>
	
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"repoId":"<xsl:value-of select="current()/name" />",		
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'supplier_name': string(translate(translate($thisSupplier/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
			'signature_date': string(translate(translate(current()/own_slot_value[slot_reference = ('contract_signature_date_ISO8601')]/value,'}',')'),'{',')')),
			'contract_end_date': string(translate(translate(current()/own_slot_value[slot_reference = ('contract_end_date_ISO8601')]/value,'}',')'),'{',')')),
			'contract_customer': string(translate(translate($thisActor/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'contract_type': string(translate(translate($thisContractType/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'contract_ref': string(translate(translate(current()/own_slot_value[slot_reference = ('contract_ref')]/value,'}',')'),'{',')')),
			'owner': string(translate(translate($thisa2rActor/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		,"supplierId": "<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>"
		,"relStatusId": "<xsl:value-of select="eas:getSafeJSString($supplierRelStatus/name)"/>"
		,"startDate": <xsl:choose><xsl:when test="string-length($contractSigDate) > 0">"<xsl:value-of select="$contractSigDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalDate": <xsl:choose><xsl:when test="string-length($contractRenewalDate) > 0">"<xsl:value-of select="$contractRenewalDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalNoticeDays": <xsl:value-of select="$renewalNoticeDays"/>
		,"renewalReviewDays": <xsl:value-of select="$renewalReviewDays"/>
		,"renewalModel": <xsl:choose><xsl:when test="count($currentRenewalModel) > 0">"<xsl:value-of select="$currentRenewalModel[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		<xsl:choose><xsl:when test="$contractType">,"type": "<xsl:value-of select="$contractType/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when></xsl:choose>
		<xsl:choose><xsl:when test="$contractCost">,"cost": <xsl:value-of select="$contractCost"/></xsl:when></xsl:choose>
		<xsl:choose><xsl:when test="count($thisDocLinks) > 0">,"docLinks": [
			<xsl:for-each select="$thisDocLinks">
				<xsl:variable name="thisLink" select="current()"/>
				<xsl:variable name="thisLinkName" select="$thisLink/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="thisUrl" select="$thisLink/own_slot_value[slot_reference = 'external_reference_url']/value"/>
				{
				"label": "<xsl:value-of select="$thisLinkName"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'url': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
				}<xsl:if test="not(position() = last())">,
				</xsl:if>
			</xsl:for-each>
		]</xsl:when></xsl:choose>,
		"contractComps":[<xsl:apply-templates select="$thisContractRels" mode="RenderContractCompJSON"/>]	
		,"contractCompIds": [<xsl:for-each select="$thisContractRels/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"busProcIds": [<xsl:for-each select="$thisBusProcs/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"appIds": [<xsl:for-each select="$thisApps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"techProdIds": [<xsl:for-each select="$thisTechProds/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="RenderContractCompJSON">
		<xsl:variable name="this" select="current()"/>
	 
		<xsl:variable name="currentContract" select="key('allContractsforKey',$this/name)"/>
		<xsl:variable name="currentContractLinks" select="key('allExternalLink_key',$this/name)"/>
	
		<xsl:variable name="currentContractSupplier" select="key('nameLookups',  $currentContract/own_slot_value[slot_reference = 'contract_supplier']/value)"/>
		<xsl:variable name="supplierRelStatus" select="$supplierRelStatii[name = $currentContractSupplier/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
		
		<xsl:variable name="currentLicense" select="$allLicenses[name = $this/own_slot_value[slot_reference = 'ccr_license']/value]"/>
		<xsl:variable name="currentLicenseType" select="$licenseType[name = $currentLicense/own_slot_value[slot_reference = 'license_type']/value]"/>
		
		<xsl:variable name="currentRenewalModel" select="$allRenewalModels[name = ($this, $currentContract)/own_slot_value[slot_reference = ('ccr_renewal_model', 'contract_renewal_model')]/value]"/>
		<xsl:variable name="currentCurrencyInst" select="$allCurrencies[name = $this/own_slot_value[slot_reference = 'ccr_currency']/value]"/>
		
		<xsl:variable name="startDate">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$currentContract/own_slot_value[slot_reference = 'contract_signature_date_ISO8601']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalDate">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'contract_end_date_ISO8601']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalNoticeDays">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value"/>
				</xsl:when>
				<xsl:when test="$currentContract/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value">
					<xsl:value-of select="$currentContract/own_slot_value[slot_reference = 'contract_renewal_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="renewalReviewDays">
			<xsl:choose>
				<xsl:when test="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value">
					<xsl:value-of select="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currentContractedUnits">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_contracted_units']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>
				</xsl:when>
				<xsl:otherwise>null</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currentContractTotal">
			<xsl:choose>
				<xsl:when test="$this/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value">
					<xsl:value-of select="$this/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:variable name="currentCostPerUnit">
			<xsl:choose>
				<xsl:when test="$currentContractedUnits > 0 and $currentContractTotal > 0">
					<xsl:value-of select="$currentContractTotal div $currentContractedUnits"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>-->
		
		<xsl:variable name="thisBusProcs" select="key('nameLookups',  $this/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>
		<xsl:variable name="thisApps" select="key('nameLookups',  $this/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>
		<xsl:variable name="thisTechProds" select="key('nameLookups', $this/own_slot_value[slot_reference = 'contract_component_to_element']/value)"/>   
		  
		{
		"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		"repoid": "<xsl:value-of select="$this/name"/>"
		,"contractId": "<xsl:value-of select="eas:getSafeJSString($currentContract/name)"/>"
		,"docLinks": <xsl:choose><xsl:when test="count($currentContractLinks) > 0"> [
			<xsl:for-each select="$currentContractLinks">
				<xsl:variable name="thisLink" select="current()"/>
				<xsl:variable name="thisLinkName" select="$thisLink/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="thisUrl" select="$thisLink/own_slot_value[slot_reference = 'external_reference_url']/value"/>
				{
				"label": "<xsl:value-of select="$thisLinkName"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'url': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
				}<xsl:if test="not(position() = last())">,
				</xsl:if>
			</xsl:for-each>
			]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"supplierId": "<xsl:value-of select="eas:getSafeJSString($currentContractSupplier/name)"/>"
		,"startDate": <xsl:choose><xsl:when test="string-length($startDate) > 0">"<xsl:value-of select="$startDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalDate": <xsl:choose><xsl:when test="string-length($renewalDate) > 0">"<xsl:value-of select="$renewalDate"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"renewalNoticeDays": <xsl:value-of select="$renewalNoticeDays"/>
		,"renewalReviewDays": <xsl:value-of select="$renewalReviewDays"/>
		,"renewalModel": <xsl:choose><xsl:when test="count($currentRenewalModel) > 0">"<xsl:value-of select="$currentRenewalModel[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"licenseModel": <xsl:choose><xsl:when test="count($currentLicenseType) > 0">"<xsl:value-of select="$currentLicenseType/own_slot_value[slot_reference = 'enumeration_value']/value"/>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
		,"contractedUnits": <xsl:value-of select="$currentContractedUnits"/>
		,"cost": <xsl:choose><xsl:when test="$currentContractTotal"><xsl:value-of select="$currentContractTotal"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>
		,"currency": "<xsl:choose><xsl:when test="$currentCurrencyInst"><xsl:value-of select="$currentCurrencyInst/own_slot_value[slot_reference='currency_symbol']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$currency/own_slot_value[slot_reference='currency_symbol']/value"/></xsl:otherwise></xsl:choose>"
		,"busProcIds": [<xsl:for-each select="$thisBusProcs/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"appIds": [<xsl:for-each select="$thisApps/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]
		,"techProdIds": [<xsl:for-each select="$thisTechProds/name">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="contract">
		{"id": "<xsl:value-of select="current()/name"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="contractComp">
	<xsl:variable name="uom" select=" $allUnitTypes[name=current()/own_slot_value[slot_reference = ('ccr_contract_unit_of_measure')]/value]"/>
	<xsl:variable name="thisccy" select=" $allCurrencies[name=current()/own_slot_value[slot_reference = ('ccr_currency')]/value]"/>
	<xsl:variable name="thisren" select="$allRenewalModels[name=current()/own_slot_value[slot_reference = ('ccr_renewal_model')]/value]"/>
	<xsl:variable name="thiscont" select=" $allContracts[name=current()/own_slot_value[slot_reference = ('contract_component_from_contract')]/value]"/>
		{"id": "<xsl:value-of select="current()/name"/>",
		"debug":"<xsl:value-of select="current()/own_slot_value[slot_reference = ('ccr_currency')]/value"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'contract_component_from_contract': string(translate(translate($thiscont/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'ccr_renewal_model': string(translate(translate($thisren/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'ccr_contract_unit_of_measure': string(translate(translate($uom/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'ccr_contracted_units': string(translate(translate(current()/own_slot_value[slot_reference = ('ccr_contracted_units')]/value,'}',')'),'{',')')),
			'ccr_total_annual_cost': string(translate(translate(current()/own_slot_value[slot_reference = ('ccr_total_annual_cost')]/value,'}',')'),'{',')')),
			'ccr_currency': string(translate(translate($thisccy/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'ccr_renewal_notice_days': string(translate(translate(current()/own_slot_value[slot_reference = ('ccr_renewal_notice_days')]/value,'}',')'),'{',')')),
			'ccr_start_date_ISO8601': string(translate(translate(current()/own_slot_value[slot_reference = ('ccr_start_date_ISO8601')]/value,'}',')'),'{',')')),
			'ccr_end_date_ISO8601': string(translate(translate(current()/own_slot_value[slot_reference = ('ccr_end_date_ISO8601')]/value,'}',')'),'{',')')) 
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"busElements":[<xsl:for-each select="key('allElementskey', current()/own_slot_value[slot_reference = ('contract_component_to_element')]/value)[type='Business_Process']">	{"id": "<xsl:value-of select="current()/name"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>],
		"appElements":[<xsl:for-each select="key('allElementskey', current()/own_slot_value[slot_reference = ('contract_component_to_element')]/value)[type=('Application_Provider', 'Composite_Application_Provider')]">	{"id": "<xsl:value-of select="current()/name"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>],
		"techElements":[<xsl:for-each select="key('allElementskey', current()/own_slot_value[slot_reference = ('contract_component_to_element')]/value)[type='Technology_Product']">	{"id": "<xsl:value-of select="current()/name"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>], 
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="enums">
 	<xsl:variable name="backgroundColour" select="eas:get_element_style_colour(current())"/> 
	<xsl:variable name="textColour" select="eas:get_element_style_textcolour(current())"/> 
	<xsl:variable name="styleClass" select="eas:get_element_style_class(current())"/>  
		{"id": "<xsl:value-of select="current()/name"/>",
		"type": "<xsl:value-of select="current()/type"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
			'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
			'sequence_no': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_sequence_number')]/value,'}',')'),'{',')')),
			'backgroundColour': string(translate(translate($backgroundColour,'}',')'),'{',')')),
			'textColour': string(translate(translate($textColour,'}',')'),'{',')')),
			'styleClass': string(translate(translate($styleClass,'}',')'),'{',')')),
			'label':string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
			'enumeration_score':string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_score')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		<xsl:if test="current()/own_slot_value[slot_reference = ('csrs_contract_review_notice_days')]/value">,"notice_period":<xsl:value-of select="current()/own_slot_value[slot_reference = ('csrs_contract_review_notice_days')]/value"/></xsl:if>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
<!--,
			'background_colour': string(translate(translate($backgroundColour,'}',')'),'{',')')),
			'text_colour': string(translate(translate($textColour,'}',')'),'{',')')),
			'enum_value': string(translate(translate($styleClass,'}',')'),'{',')'))-->