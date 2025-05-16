<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 

	<xsl:key name="allTaxonomyTypeKey" match="simple_instance[type=('Taxonomy')]" use="type" />
	<xsl:variable name="allTaxonomy" select="key('allTaxonomyTypeKey', ('Taxonomy'))" /> 
    <xsl:variable name="taxonomy" select="$allTaxonomy[own_slot_value[slot_reference='name']/value=('Reference Model Layout')]"/> 
    <xsl:variable name="taxonomyCat" select="$allTaxonomy[own_slot_value[slot_reference='name']/value=('Application Capability Category')]"/> 
	<xsl:key name="taxonomyKey" match="/node()/simple_instance[type='Taxonomy_Term']" use="own_slot_value[slot_reference='term_in_taxonomy']/value"/>
 	<xsl:variable name="taxonomyTerm" select="key('taxonomyKey',$taxonomy/name)"/> 
    <xsl:variable name="taxonomyTermCat" select="key('taxonomyKey',$taxonomyCat/name)"/> 
	<xsl:key name="appCapKey" match="/node()/simple_instance[type='Application_Capability']" use="type"/>
	<xsl:variable name="appCaps" select="key('appCapKey','Application_Capability')"/> 
	<xsl:variable name="topappCaps" select="$appCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value)]"/> 
	<xsl:key name="afiImplKey" match="/node()/simple_instance[type='Application_Function_Implementation']" use="type"/>
	<xsl:variable name="afiImpl" select="key('afiImplKey','Application_Function_Implementation')"/> 
	<xsl:key name="busCapsTypeKey" match="simple_instance[type=('Business_Capability')]" use="type" />
	<xsl:variable name="busCaps" select="key('busCapsTypeKey', ('Business_Capability'))" />
	
	<xsl:key name="businessProcessesKey" match="simple_instance[type=('Business_Process')]" use="type" />
	<xsl:variable name="businessProcesses" select="key('businessProcessesKey', ('Business_Process'))" />
	<xsl:key name="busprocessKey" match="/node()/simple_instance[supertype=('Business_Process_Type')]" use="name"/>

	<xsl:key name="busDomainsTypeKey" match="simple_instance[type=('Business_Domain')]" use="type" />
	<xsl:variable name="busDomains" select="key('busDomainsTypeKey', ('Business_Domain'))" />

	<xsl:key name="domainKey" match="$busDomains" use="name"/>

	<xsl:key name="suppliersTypeKey" match="simple_instance[type=('Supplier')]" use="type" />
	<xsl:variable name="suppliers" select="key('suppliersTypeKey', ('Supplier'))" />
   
	<xsl:variable name="appFamily" select="/node()/simple_instance[type='Application_Family']"/> 
	<xsl:variable name="applicationFunctions" select="/node()/simple_instance[type='Application_Function']"/> 
	<xsl:key name="applicationServicesKey" match="/node()/simple_instance[type=('Application_Service','Composite_Application_Service')]" use="type"/>
	<xsl:variable name="applicationServices" select="key('applicationServicesKey',('Application_Service','Composite_Application_Service'))"/>	
	
	<xsl:key name="directAppKey" match="simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]" use="type" />
	<xsl:variable name="applicationProviders" select="key('directAppKey', ('Composite_Application_Provider','Application_Provider','Application_Provider_Interface'))" />

	<xsl:key name="applicationProviderRolesTypeKey" match="simple_instance[type=('Application_Provider_Role')]" use="type" />
	<xsl:variable name="applicationProviderRoles" select="key('applicationProviderRolesTypeKey', ('Application_Provider_Role'))" />

	<xsl:key name="allAppSvcToProcessTypeKey" match="simple_instance[type=('APP_SVC_TO_BUS_RELATION')]" use="type" />
	<xsl:variable name="allAppSvcToProcess" select="key('allAppSvcToProcessTypeKey', ('APP_SVC_TO_BUS_RELATION'))" />
    
	<xsl:key name="aallAppStandardsSlotKey" match="simple_instance[type=('Application_Provider_Standard_Specification')]" use="own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value" />

    <xsl:variable name="allAppStandards" select="key('aallAppStandardsSlotKey', $applicationProviderRoles/name)"/>
	<xsl:key name="allAppFunctionImps" match="/node()/simple_instance[type='Application_Function_Implementation']" use="own_slot_value[slot_reference = 'application_function_implementation_provided_by']/value"/>
	<xsl:key name="allAppStandardsKey" match="/node()/simple_instance[type='Application_Provider_Standard_Specification']" use="own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value"/>
	<xsl:variable name="standardStrength" select="/node()/simple_instance[type='Standard_Strength']"/>
	<xsl:key name="allstandardsNameKey" match="$standardStrength" use="name"/>
	<xsl:variable name="grpAct" select="/node()/simple_instance[type='Group_Actor']"/> 
	<xsl:key name="allGroupActorsKey" match="$grpAct" use="type"/>	
	<xsl:key name="allSuppliers" match="$suppliers" use="name"/>	
	<xsl:variable name="allGroupActors" select="key('allGroupActorsKey','Group_Actor')"/>	
 
	<xsl:key name="allAppInstances" match="/node()/simple_instance[type='Application_Software_Instance']" use="own_slot_value[slot_reference = 'instance_of_application_deployment']/value"/>	
	<xsl:key name="allAppNodes" match="/node()/simple_instance[type='Technology_Node']" use="own_slot_value[slot_reference = 'contained_technology_instances']/value"/>	
	<xsl:key name="siteNames" match="/node()/simple_instance[type='Site']" use="name"/>

	<xsl:key name="allGroupActorsNameKey" match="$grpAct" use="name"/>	 
	<xsl:variable name="production" select="/node()/simple_instance[type='Deployment_Role'][own_slot_value[slot_reference = 'name']/value = 'Production']"/>	
	<!--<xsl:variable name="deploymentRole" select="/node()/simple_instance[type='Deployment_Role']"/>	-->
	<xsl:key name="aDRKey" match="/node()/simple_instance[type='Deployment_Role']" use="type"/>
	<xsl:key name="aDRNameKey" match="/node()/simple_instance[type='Deployment_Role']" use="name"/>
	<xsl:variable name="deploymentRole" select="key('aDRKey','Deployment_Role')"/>	

	<xsl:key name="allAppDeploymentsTypeKey" match="simple_instance[type=('Application_Deployment')]" use="type" />
	<xsl:key name="allTechProvidersTypeKey" match="simple_instance[type=('Technology_Product','Technology_Product_Build')]" use="type" />
	<xsl:variable name="allAppDeployments" select="key('allAppDeploymentsTypeKey', 'Application_Deployment')"/>
	<xsl:variable name="allTechProviders" select="key('allTechProvidersTypeKey',('Technology_Product','Technology_Product_Build'))"/>

	<xsl:key name="aTBKey" match="$allTechProviders" use="type"/> 
	<xsl:key name="aTBNameKey" match="$allTechProviders" use="name"/>
	<xsl:variable name="allTechBuilds" select="key('aTBKey',('Technology_Provider', 'Technology_Product','Technology_Product_Build'))"/>
	 
	<xsl:key name="allTechProRoleskey" match="/node()/simple_instance[supertype = 'Technology_Provider_Role']" use="name"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component' or supertype = 'Technology_Component']"/>
	<xsl:variable name="allTechProvs" select="/node()/simple_instance[supertype = 'Technology_Provider']"/>

	<xsl:key name="inScopeCostsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	<xsl:key name="inScopeCostComponentKey" match="/node()/simple_instance[type=('Adhoc_Cost_Component','Annual_Cost_Component','Monthly_Cost_Component','Quarterly_Cost_Component')]" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>
	<xsl:variable name="costType" select="/node()/simple_instance[(type = 'Cost_Component_Type')]"/>
	<xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
   <xsl:variable name="costCategory" select="/node()/simple_instance[(type = 'Cost_Category')]"/>
   <xsl:key name="allDocs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
   <xsl:key name="allTaxTerms_key" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
   <xsl:variable name="allCurrency" select="/node()/simple_instance[(type = 'Currency')]"/>
   <xsl:key name="geoKey" match="/node()/simple_instance[type=('Geographic_Location', 'Geographic_Region')]" use="name"/>
   <xsl:variable name="allInfoReps" select="/node()/simple_instance[type=('Information_Representation')]"/>
   <xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
   <xsl:variable name="allAPUs" select="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
   <xsl:key name="allArchUsagesKey" match="/node()/simple_instance[type='Static_Application_Provider_Usage']" use="name"/>
   <xsl:key name="allSAKey" match="/node()/simple_instance[supertype='Application_Provider']" use="own_slot_value[slot_reference='ap_static_architecture']/value"/>
   <xsl:key name="allAppsforSAKey" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]" use="name"/>
   <xsl:key name="allAppProtoInfoKey" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION','APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]" use="name"/>
   <xsl:key name="allInfoRepKey" match="/node()/simple_instance[type=('Information_Representation')]" use="name"/>
   
   <xsl:variable name="allAppProtoInfo" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION'][name=$allAPUs/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
   <xsl:variable name="allInfo" select="/node()/simple_instance[type='Information_Representation'][name=$allAppProtoInfo/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
   <xsl:key name="synonyms" match="/node()/simple_instance[type=('Synonym')]" use="name"/>
	<xsl:variable name="acqType" select="/node()/simple_instance[type='Data_Acquisition_Method']"/>
  	<xsl:key name="sqv" match="simple_instance[supertype=('Service_Quality_Value')]" use="name" />
    
 
	
	<!--
		<xsl:variable name="allAppDeployments" select="/node()/simple_instance[own_slot_value[slot_reference = 'application_provider_deployed']/value = $applicationProviders/name][own_slot_value[slot_reference = 'application_deployment_role']/value = $production/name]"/>
	<xsl:variable name="allTechBuilds" select="/node()/simple_instance[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
		<xsl:variable name="allTechBuildArchs" select="/node()/simple_instance[name = $allTechBuilds/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>		
		<xsl:variable name="allTechProvRoleUsages" select="/node()/simple_instance[(name = $allTechBuildArchs/own_slot_value[slot_reference = 'contained_architecture_components']/value) and (type = 'Technology_Provider_Usage')]"/>
		<xsl:variable name="appTechProvRoles" select="$allTechProRoles[name = $allTechProvRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="allTechProdArchRelations" select="/node()/simple_instance[(type = ':TPU-TO-TPU-RELATION') and (name = $allTechBuildArchs/own_slot_value[slot_reference = 'contained_provider_architecture_relations']/value)]"/>

		<xsl:variable name="appTechProvs" select="$allTechProvs[name = $appTechProvRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="appTechComps" select="$allTechComps[name = $appTechProvRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>-->
	<xsl:variable name="eleStyles" select="/node()/simple_instance[type = 'Element_Style'][name=$standardStrength/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	<xsl:key name="eleStyles" match="/node()/simple_instance[type = 'Element_Style']" use="name"/>
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
	<xsl:key name="techcomp_key" match="$allTechComps" use="own_slot_value[slot_reference = 'realised_by_technology_products']/value"/>
	<xsl:key name="appdeployment_key" match="$allAppDeployments" use="own_slot_value[slot_reference = 'application_provider_deployed']/value"/>
	<xsl:key name="techprod_key" match="$allTechProvs" use="own_slot_value[slot_reference = 'implements_technology_components']/value"/>
	<xsl:key name="tprole_key" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value"/>
	<xsl:key name="tp_key" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference = 'describes_technology_provider']/value"/>
	<xsl:key name="appDep_key" match="$allAppDeployments" use="own_slot_value[slot_reference = 'application_provider_deployed']/value"/>
	<xsl:key name="busCapMap_key" match="$busCaps" use="own_slot_value[slot_reference = 'bus_cap_supporting_app_caps']/value"/>
	<xsl:key name="appCapChild_key" match="$appCaps" use="own_slot_value[slot_reference = 'contained_in_application_capability']/value"/>	
	<xsl:key name="appCapParent_key" match="$appCaps" use="own_slot_value[slot_reference = 'contained_app_capabilities']/value"/>
	<xsl:key name="appSvc_key" match="$applicationServices" use="own_slot_value[slot_reference = 'realises_application_capabilities']/value"/>
	<xsl:key name="apr_key" match="$applicationProviderRoles" use="own_slot_value[slot_reference = 'implementing_application_service']/value"/>
	<xsl:key name="asbr_key" match="$allAppSvcToProcess" use="own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value"/>
	<xsl:key name="busProc_key" match="$businessProcesses" use="own_slot_value[slot_reference = 'bp_supported_by_app_svc']/value"/>
	<xsl:key name="costForCat_key" match="/node()/simple_instance[type=('Cost')]" use="own_slot_value[slot_reference = 'cost_components']/value"/>
	<xsl:template match="knowledge_base">
		{ 
			"capability_hierarchy":[<xsl:apply-templates select="$topappCaps" mode="appCapsHierachy"><xsl:with-param name="depth" select="0"/><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],     
			"application_capabilities":[<xsl:apply-templates select="$appCaps" mode="appCaps"><xsl:with-param name="depth" select="0"/><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"application_services":[<xsl:apply-templates select="$applicationServices" mode="appSvcs"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"application_functions":[<xsl:apply-templates select="$applicationFunctions" mode="appFuncs"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"application_technology":[<xsl:apply-templates select="$applicationProviders" mode="appTech"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"applications":[<xsl:apply-templates select="$applicationProviders" mode="appData"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"app_function_implementations":[<xsl:apply-templates select="$afiImpl" mode="afiData"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"stdStyles":[<xsl:apply-templates select="$eleStyles" mode="styles"/>], 
			"ccy":[<xsl:apply-templates mode="renderCurrencies" select="$allCurrency">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>],
			"apus": [<xsl:apply-templates select="$allAPUs" mode="allAPUs"/>]
		}<!-- note this app info here is additonal to that in the integration ans the bus cap app mart-->
	</xsl:template>
	
	<xsl:template match="node()" mode="appCaps">
	 <xsl:param name="depth"/>
	 <xsl:variable name="childAppCaps" select="$appCaps[name=current()/own_slot_value[slot_reference='contained_app_capabilities']/value]"/>
	 <!--<xsl:variable name="parentAppCaps" select="$appCaps[name=current()/own_slot_value[slot_reference='contained_in_application_capability']/value]"/> -->
	 <xsl:variable name="businessDomainsIds" select="current()/own_slot_value[slot_reference='mapped_to_business_domain']/value union current()/own_slot_value[slot_reference='mapped_to_business_domains']/value"/>
	 <xsl:variable name="businessDomains" select="key('domainKey', $businessDomainsIds)"/>
	 
	 <xsl:variable name="refLayer" select="$taxonomyTerm[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/> 
	 
		<xsl:variable name="categoryLayer" select="$taxonomyTermCat[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>	 
		<!--	<xsl:variable name="thisApplicationServices" select="$applicationServices[own_slot_value[slot_reference='realises_application_capabilities']/value=current()/name]"/>	-->
	<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
	<xsl:variable name="parentAppCaps" select="key('appCapParent_key',current()/name)"/>  
	<xsl:variable name="supportedBusCaps" select="key('busCapMap_key',current()/name)"/>  
	<xsl:variable name="thisApplicationServices" select="key('appSvc_key',current()/name)"/> 												
	  {
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
				'appCapCategory': string(translate(translate($categoryLayer[1]/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
			"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
			"sequence_number":"<xsl:value-of select="current()/own_slot_value[slot_reference='sequence_number']/value"/>",
			"domainIds":[<xsl:for-each select="$businessDomains"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
			"businessDomain":[<xsl:for-each select="$businessDomains">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"ParentAppCapability":[<xsl:for-each select="$parentAppCaps">
				{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'ReferenceModelLayer': string(translate(translate($refLayer[1]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"SupportedBusCapability":[<xsl:for-each select="$supportedBusCaps">
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					<xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					}" />
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/> }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],	
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>, 
			"supportingServices":[<xsl:for-each select="$thisApplicationServices">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"documents":[<xsl:for-each select="$thisDocs">
			<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
			{"id":"<xsl:value-of select="current()/name"/>",
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
				'documentLink': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')'))
			}" />
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
			"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
			"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
			"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>",
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>]		
		}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>	
				
		<xsl:template match="node()" mode="appCapsHierachy">
				<xsl:param name="depth"/>
				<xsl:variable name="businessDomainsIds" select="current()/own_slot_value[slot_reference='mapped_to_business_domain']/value union current()/own_slot_value[slot_reference='mapped_to_business_domains']/value"/>
			 
			<!--	<xsl:variable name="businessDomains" select="$busDomains[name=current()/own_slot_value[slot_reference='mapped_to_business_domain']/value]"/>-->
			   <xsl:variable name="refLayer" select="$taxonomyTerm[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>
			   <xsl:variable name="categoryLayer" select="$taxonomyTermCat[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>	 
			<!--   <xsl:variable name="thisApplicationServices" select="$applicationServices[own_slot_value[slot_reference='realises_application_capabilities']/value=current()/name]"/>	-->

			   <xsl:variable name="thisApplicationServices" select="key('appSvc_key',current()/name)"/> 
				<xsl:variable name="childAppCaps" select="key('appCapChild_key',current()/name)"/>  
					{
					   "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					   "level":"<xsl:value-of select="$depth"/>",
					   <xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
						'appCapCategory': string(translate(translate($categoryLayer[1]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					}" />
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
					   "visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
					   "domainIds":[<xsl:for-each select="$businessDomainsIds"> {"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
					   "sequence_number":"<xsl:value-of select="current()/own_slot_value[slot_reference='sequence_number']/value"/>",
					   "businessDomain":[<xsl:for-each select="$businessDomainsIds">{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
					   "childrenCaps": [<xsl:if test="$depth &lt; 5"><xsl:apply-templates select="$childAppCaps" mode="appCapsHierachy"><xsl:with-param name="depth" select="$depth +1"/></xsl:apply-templates></xsl:if>],
					   "supportingServices":[<xsl:for-each select="$thisApplicationServices">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
					   <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>	
				   }<xsl:if test="position()!=last()">,</xsl:if>
				   </xsl:template>	
				

	<xsl:template match="node()" mode="appSvcs">
			<xsl:variable name="thisApplicationProviderRoles" select="key('apr_key',current()/name)"/> 
			<xsl:variable name="thisAllAppSvcToProcess" select="key('asbr_key',current()/name)"/> 
			<xsl:variable name="thisbusProc" select="key('busProc_key',$thisAllAppSvcToProcess/name)"/>   
			{ 
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
					'sequence_number': string(translate(translate(current()/own_slot_value[slot_reference = 'sequence_number']/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
				"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
				"APRs":[<xsl:for-each select="$thisApplicationProviderRoles">
						<!--<xsl:variable name="standardForCurrentApp" select="$allAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = current()/name]"/>-->
						<xsl:variable name="standardForCurrentApp" select="key('allAppStandardsKey', current()/name)"/>
							{
						"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
						"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						"lifecycle":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apr_lifecycle_status']/value)"/>",
						"appId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='role_for_application_provider']/value)"/>",
						"stds":[<xsl:for-each select="$standardForCurrentApp">
								<xsl:variable name="usage" select="key('busprocessKey', current()/own_slot_value[slot_reference='aps_standard_usage']/value)"/>
								<xsl:variable name="geoScope" select="key('geoKey', current()/own_slot_value[slot_reference='sm_geographic_scope']/value)"/>
								<!--<xsl:variable name="thisAppStandardOrg" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>
								<xsl:variable name="thisAppStrength" select="$standardStrength[name = current()/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
							-->
								<xsl:variable name="thisAppStandardOrg" select="key('allGroupActorsNameKey',current()/own_slot_value[slot_reference = 'sm_organisational_scope']/value)"/>
								
								<xsl:variable name="thisAppStrength" select="key('allstandardsNameKey',current()/own_slot_value[slot_reference = 'sm_standard_strength']/value)"/>
								{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
								 "strId":"<xsl:value-of select="eas:getSafeJSString($thisAppStrength[1]/own_slot_value[slot_reference='element_styling_classes']/value)"/>",
								 "str":"<xsl:value-of select="$thisAppStrength/own_slot_value[slot_reference='enumeration_value']/value"/>", 
								 <xsl:variable name="combinedMap" as="map(*)" select="map{
									'org': string(translate(translate($thisAppStandardOrg[1]/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
								}" />
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
								"usage":[<xsl:for-each select="$usage">{
									"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
									<xsl:variable name="combinedMap" as="map(*)" select="map{
										'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
									}" />
									<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
									<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
									"type":"<xsl:value-of select="current()/type"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
								"geo":[<xsl:for-each select="$geoScope">{
									"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
									<xsl:variable name="combinedMap" as="map(*)" select="map{
										'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
									}" />
									<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
									<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
									"type":"<xsl:value-of select="current()/type"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
								"orgs":[<xsl:for-each select="$thisAppStandardOrg">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
								<xsl:variable name="combinedMap" as="map(*)" select="map{
									'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
								}" />
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}
								<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if> </xsl:for-each>],
						"physProc":[<xsl:for-each select="current()/own_slot_value[slot_reference='app_pro_role_supports_phys_proc']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]			
								}<xsl:if test="not(position() = last())">,</xsl:if> </xsl:for-each>],
				"busProc":[<xsl:for-each select="$thisbusProc">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				"functions":[<xsl:for-each select="current()/own_slot_value[slot_reference='provides_application_functions']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],			
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="appFuncs"> 
			{ 
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="appTech">
			<xsl:variable name="environment" select="key('appDep_key',current()/name)"/>   
		<!--	<xsl:variable name="environment" select="$allAppDeployments[own_slot_value[slot_reference = 'application_provider_deployed']/value=current()/name]"/>-->
			
		
		{ 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		"environments":[<xsl:for-each select="$environment">
			<xsl:variable name="aTechBuild" select="key('aTBNameKey', current()/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value)"/>
			
			<xsl:variable name="aTechBuildArch" select="key('tp_key',$aTechBuild/name)"/>   
		<!--<xsl:variable name="aTechBuild" select="$allTechBuilds[name = current()/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
				<xsl:variable name="aTechBuildArch" select="$allTechBuildArchs[name = $aTechBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>-->
		<xsl:variable name="aTechProUsageList" select="key('tprole_key',$aTechBuildArch/name)"/>  
				<xsl:variable name="thisdeploymentRole" select="key('aDRNameKey', current()/own_slot_value[slot_reference='application_deployment_role']/value)"/> 
				<xsl:variable name="thisInstance" select="key('allAppInstances', current()/name)"/>
				<xsl:variable name="thisNodes" select="key('allAppNodes', $thisInstance/name)"/>
				<xsl:variable name="thisdeploymentRole" select="$deploymentRole[name=current()/own_slot_value[slot_reference='application_deployment_role']/value]"/>
				<xsl:variable name="thisStyle" select="key('eleStyles', $thisdeploymentRole/own_slot_value[slot_reference='element_styling_classes']/value)"/>
			
				{
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'role': string(translate(translate($thisdeploymentRole/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'colour': string(translate(translate($thisStyle/own_slot_value[slot_reference = ('element_style_text_colour')]/value,'}',')'),'{',')')),
					'backgroundColour': string(translate(translate($thisStyle/own_slot_value[slot_reference = ('element_style_colour')]/value,'}',')'),'{',')'))
		
					}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
				"products":[<xsl:for-each select="$aTechProUsageList">
						<!--<xsl:variable name="aTechProRole" select="$allTechProRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>-->
						<xsl:variable name="aTechProRole" select="key('allTechProRoleskey',current()/own_slot_value[slot_reference = 'provider_as_role']/value)"/>
						
						<xsl:variable name="aTechProd" select="key('techprod_key',$aTechProRole/name)"/>   
					<!--	<xsl:variable name="aTechProd" select="$appTechProvs[name = $aTechProRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>-->
						<xsl:variable name="aTechComp" select="key('techcomp_key',$aTechProRole/name)"/>  
					<!--	<xsl:variable name="aTechComp" select="$appTechComps[name = $aTechProRole/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>-->
						{"tpr":"<xsl:value-of select="eas:getSafeJSString($aTechProRole/name)"/>",
						"prod":"<xsl:value-of select="eas:getSafeJSString($aTechProd/name)"/>",
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'prodname': string(translate(translate($aTechProd/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
							'compname': string(translate(translate($aTechComp/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
						}" />
						<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
						<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
						"comp":"<xsl:value-of select="eas:getSafeJSString($aTechComp/name)"/>",
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>	
						}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>],
				"nodes":[<xsl:for-each select="$thisNodes">
						<xsl:variable name="thisSite" select="key('siteNames', current()/own_slot_value[slot_reference='technology_deployment_located_at']/value)"/>
						{
						"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
							'site': string(translate(translate($thisSite/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
						}" />
						<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
						<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
						"siteId":"<xsl:value-of select="eas:getSafeJSString($thisSite/name)"/>",
						"siteGeoId":"<xsl:value-of select="eas:getSafeJSString($thisSite/own_slot_value[slot_reference='site_geographic_location']/value)"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>	}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>		
				}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="appData">
		<!--<xsl:variable name="thisSupplier" select="$suppliers[name=current()/own_slot_value[slot_reference='ap_supplier']/value]"/> -->
		<xsl:variable name="thisAppFamily" select="$appFamily[name=current()/own_slot_value[slot_reference='type_of_application']/value]"/>
		<xsl:variable name="thisSupplier" select="key('allSuppliers', current()/own_slot_value[slot_reference='ap_supplier']/value)"/>
		<xsl:variable name="inScopeCosts" select="key('inScopeCostsKey',current()/name)"/>
		<xsl:variable name="inScopeCostComponents" select="key('inScopeCostComponentKey',$inScopeCosts/name)"/>
		<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
		<xsl:variable name="afis" select="key('allAppFunctionImps',current()/name)"/>
		<xsl:variable name="thissynonyms" select="key('synonyms',current()/own_slot_value[slot_reference='synonyms']/value)"/>
			{  
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'short_name': string(translate(translate(current()/own_slot_value[slot_reference = ('short_name')]/value,'}',')'),'{',')')),
					'ea_reference': string(translate(translate(current()/own_slot_value[slot_reference = ('ea_reference')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"type":"<xsl:value-of select="current()/type"/>",
				"afis":[<xsl:for-each select="$afis">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "funcId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='implements_application_function']/value)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				"synonyms":[<xsl:for-each select="$thissynonyms">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", <xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')) 
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
				"documents":[<xsl:for-each select="$thisDocs">
				<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
				{"id":"<xsl:value-of select="current()/name"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
					'documentLink': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
				"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
				"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
				"supplier":{"id":"<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate($thisSupplier/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>},
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
				"maxUsers":"<xsl:value-of select="current()/own_slot_value[slot_reference='ap_max_number_of_users']/value"/>",
				"family":[<xsl:for-each select="$thisAppFamily">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
				}" />
				<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
				<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if>
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
<xsl:template match="node()" mode="afiData">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
		'afiname': string(translate(translate(current()/own_slot_value[slot_reference = ('app_func_impl_name')]/value,'}',')'),'{',')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"appId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference = 'application_function_implementation_provided_by']/value)"/>",
	"afuncId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference = 'implements_application_function']/value)"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
</xsl:template>	


	<xsl:template match="node()" mode="styles">
			<xsl:variable name="thisStyle" select="key('eleStyles', current()[0]/own_slot_value[slot_reference='element_styling_classes']/value)"/>
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","shortname":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'enumeration_value']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></xsl:otherwise></xsl:choose>","colour":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
			"colourText":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
		</xsl:template>	

		<xsl:function as="xs:float" name="eas:get_cost_components_total">
				<xsl:param name="costComponents"/>
				<xsl:param name="total"/>
				
				<xsl:choose>
					<xsl:when test="count($costComponents) > 0">
						<xsl:variable name="nextCost" select="$costComponents[1]"/>
						<xsl:variable name="newCostComponents" select="remove($costComponents, 1)"/>
						<xsl:variable name="costAmount" select="$nextCost/own_slot_value[slot_reference='cc_cost_amount']/value"/>
						<xsl:choose>
							<xsl:when test="$costAmount > 0">
								<xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total + number($costAmount))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
				</xsl:choose>
			</xsl:function>

			<xsl:template match="node()" mode="allAPUs">
				<xsl:variable name="thisFrom" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':FROM']/value)"/>
				<xsl:variable name="thisTo" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':TO']/value)"/>
				<xsl:variable name="fromApp" select="key('allAppsforSAKey', $thisFrom/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
				<xsl:variable name="toApp" select="key('allAppsforSAKey', $thisTo/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
				<xsl:variable name="edgeInfo" select="key('allAppProtoInfoKey', current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value)"/>
				<xsl:variable name="edgeInfoIndirect" select="key('allAppProtoInfoKey', $edgeInfo/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)"/> 
				<xsl:variable name="allInfoEdges" select="$edgeInfo union $edgeInfoIndirect"/>
				<xsl:variable name="thisInfoReps" select="key('allInfoRepKey', $allInfoEdges/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value)"/>
				
			{
			"id":"<xsl:value-of select="current()/name"/>",
			<xsl:variable name="temp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = (':relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
			<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
		
			"fromtype":"<xsl:value-of select="$fromApp/type"/>",
			"totype":"<xsl:value-of select="$toApp/type"/>",
			"edgeName":"<xsl:value-of select="$fromApp/name"/> to <xsl:value-of select="$toApp/name"/>",
			"fromAppId":"<xsl:value-of select="$fromApp/name"/>",
			"toAppId":"<xsl:value-of select="$toApp/name"/>",
			<xsl:variable name="ftemp" as="map(*)" select="map{'fromApp': string(translate(translate($fromApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
			<xsl:variable name="fresult" select="serialize($ftemp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($fresult,'{'),'}')"></xsl:value-of>,
			<xsl:variable name="ttemp" as="map(*)" select="map{'toApp': string(translate(translate($toApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
			<xsl:variable name="tresult" select="serialize($ttemp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($tresult,'{'),'}')"></xsl:value-of>,
			"infoData":[<xsl:for-each select="$edgeInfo">
				<xsl:variable name="this" select="current()"/>
				<xsl:variable name="acquisition" select="$acqType[name=current()/own_slot_value[slot_reference='atire_acquisition_method']/value]"/>
				<xsl:variable name="frequency" select="key('sqv', current()/own_slot_value[slot_reference='atire_service_quals']/value)"/>
				<xsl:variable name="thisedgeInfoIndirect" select="key('allAppProtoInfoKey', current()/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)"/>
				<xsl:variable name="thisInfoRepsEx" select="key('allInfoRepKey', $thisedgeInfoIndirect/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value)"/> 
		 
				{  
					"id":"<xsl:value-of select="current()/name"/>",
					"type":"<xsl:value-of select="current()/type"/>",
					<xsl:variable name="infoTemp" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
					'acquisition':string(translate(translate($acquisition/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					}"></xsl:variable>
					<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
					<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>,
					"frequency":[<xsl:for-each select="$frequency">{"id":"<xsl:value-of select="current()/name"/>",
					<xsl:variable name="infoTemp" as="map(*)" select="map{
					'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
					}"></xsl:variable>
					<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
					<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>
					}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
					"infoReps":[<xsl:for-each select="key('allAppProtoInfoKey', current()/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)">{"id":"<xsl:value-of select="current()//own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
				}<xsl:if test="position()!=last()">,</xsl:if> 
			</xsl:for-each>],
			"info":[<xsl:for-each select="$thisInfoReps">
				{
					"id":"<xsl:value-of select="current()/name"/>",
					"type":"<xsl:value-of select="current()/type"/>",
					<xsl:variable name="infoTemp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
					<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
					<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>
				}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:template>
	</xsl:stylesheet>
	