<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
 
    <xsl:variable name="taxonomy" select="/node()/simple_instance[type='Taxonomy'][own_slot_value[slot_reference='name']/value=('Reference Model Layout')]"/> 
    <xsl:variable name="taxonomyCat" select="/node()/simple_instance[type='Taxonomy'][own_slot_value[slot_reference='name']/value=('Application Capability Category')]"/> 
 	<xsl:variable name="taxonomyTerm" select="/node()/simple_instance[type='Taxonomy_Term'][name=$taxonomy/own_slot_value[slot_reference='taxonomy_terms']/value]"/> 
    <xsl:variable name="taxonomyTermCat" select="/node()/simple_instance[type='Taxonomy_Term'][name=$taxonomyCat/own_slot_value[slot_reference='taxonomy_terms']/value]"/> 
	<xsl:variable name="appCaps" select="/node()/simple_instance[type='Application_Capability']"/> 
	<xsl:variable name="topappCaps" select="$appCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value)]"/> 
	
    <xsl:variable name="busCaps" select="/node()/simple_instance[type='Business_Capability']"/> 
    <xsl:variable name="busDomains" select="/node()/simple_instance[type='Business_Domain']"/> 
	<xsl:variable name="suppliers" select="/node()/simple_instance[type='Supplier']"/> 
	<xsl:variable name="appFamily" select="/node()/simple_instance[type='Application_Family']"/> 
	<xsl:variable name="applicationFunctions" select="/node()/simple_instance[type='Application_Function']"/> 
    <xsl:variable name="applicationServices" select="/node()/simple_instance[type='Application_Service']"/> 
    <xsl:variable name="applicationProviders" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]"/>
    <xsl:variable name="applicationProviderRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
    <xsl:variable name="allAppSvcToProcess" select="/node()/simple_instance[type='APP_SVC_TO_BUS_RELATION']"/>
    <xsl:variable name="allAppStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $applicationProviderRoles/name]"/>
	<xsl:variable name="standardStrength" select="/node()/simple_instance[type='Standard_Strength']"/>

	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>	
	<xsl:variable name="production" select="/node()/simple_instance[type='Deployment_Role'][own_slot_value[slot_reference = 'name']/value = 'Production']"/>	
	<xsl:variable name="deploymentRole" select="/node()/simple_instance[type='Deployment_Role']"/>	
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[type='Application_Deployment']"/>
	<xsl:variable name="allTechBuilds" select="/node()/simple_instance[name = $allAppDeployments/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>

	<xsl:variable name="allTechProRoles" select="/node()/simple_instance[supertype = 'Technology_Provider_Role']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component' or supertype = 'Technology_Component']"/>
	<xsl:variable name="allTechProvs" select="/node()/simple_instance[supertype = 'Technology_Provider']"/>

	<xsl:key name="inScopeCostsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
	<xsl:key name="inScopeCostComponentKey" match="/node()/simple_instance[type=('Adhoc_Cost_Component','Annual_Cost_Component','Monthly_Cost_Component','Quarterly_Cost_Component')]" use="own_slot_value[slot_reference = 'cc_cost_component_of_cost']/value"/>
	<xsl:variable name="costType" select="/node()/simple_instance[(type = 'Cost_Component_Type')]"/>
	<xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>
   <xsl:variable name="costCategory" select="/node()/simple_instance[(type = 'Cost_Category')]"/>
   <xsl:key name="allDocs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
   <xsl:key name="allTaxTerms_key" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
	
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
	<xsl:key name="appdeployment_key" match="/node()/simple_instance[type = 'Application_Deployment']" use="own_slot_value[slot_reference = 'application_provider_deployed']/value"/>
	<xsl:key name="techprod_key" match="$allTechProvs" use="own_slot_value[slot_reference = 'implements_technology_components']/value"/>
	<xsl:key name="tprole_key" match="/node()/simple_instance[type = 'Technology_Provider_Usage']" use="own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value"/>
	<xsl:key name="tp_key" match="/node()/simple_instance[type = 'Technology_Build_Architecture']" use="own_slot_value[slot_reference = 'describes_technology_provider']/value"/>
	<xsl:key name="appDep_key" match="$allAppDeployments" use="own_slot_value[slot_reference = 'application_provider_deployed']/value"/>
	<xsl:key name="busCapMap_key" match="/node()/simple_instance[type=('Business_Capability')]" use="own_slot_value[slot_reference = 'bus_cap_supporting_app_caps']/value"/>
	<xsl:key name="appCapChild_key" match="/node()/simple_instance[type=('Application_Capability')]" use="own_slot_value[slot_reference = 'contained_in_application_capability']/value"/>	
	<xsl:key name="appCapParent_key" match="/node()/simple_instance[type=('Application_Capability')]" use="own_slot_value[slot_reference = 'contained_app_capabilities']/value"/>
	<xsl:key name="appSvc_key" match="/node()/simple_instance[type=('Application_Service')]" use="own_slot_value[slot_reference = 'realises_application_capabilities']/value"/>
	<xsl:key name="apr_key" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'implementing_application_service']/value"/>
	<xsl:key name="asbr_key" match="/node()/simple_instance[type=('APP_SVC_TO_BUS_RELATION')]" use="own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value"/>
	<xsl:key name="busProc_key" match="/node()/simple_instance[type=('Business_Process')]" use="own_slot_value[slot_reference = 'bp_supported_by_app_svc']/value"/>
	<xsl:key name="costForCat_key" match="/node()/simple_instance[type=('Cost')]" use="own_slot_value[slot_reference = 'cost_components']/value"/>
	<xsl:template match="knowledge_base">
		{ 
			"capability_hierarchy":[<xsl:apply-templates select="$topappCaps" mode="appCapsHierachy"><xsl:with-param name="depth" select="0"/><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],     
			"application_capabilities":[<xsl:apply-templates select="$appCaps" mode="appCaps"><xsl:with-param name="depth" select="0"/><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"application_services":[<xsl:apply-templates select="$applicationServices" mode="appSvcs"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"application_functions":[<xsl:apply-templates select="$applicationFunctions" mode="appFuncs"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"application_technology":[<xsl:apply-templates select="$applicationProviders" mode="appTech"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"applications":[<xsl:apply-templates select="$applicationProviders" mode="appData"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"stdStyles":[<xsl:apply-templates select="$eleStyles" mode="styles"/>]
		}<!-- note this app info here is additonal to that in the integration ans the bus cap app mart-->
	</xsl:template>
	
	<xsl:template match="node()" mode="appCaps">
	 <xsl:param name="depth"/>
	 <xsl:variable name="childAppCaps" select="$appCaps[name=current()/own_slot_value[slot_reference='contained_app_capabilities']/value]"/>
	 <!--<xsl:variable name="parentAppCaps" select="$appCaps[name=current()/own_slot_value[slot_reference='contained_in_application_capability']/value]"/> -->
	 <xsl:variable name="businessDomainsOld" select="$busDomains[name=current()/own_slot_value[slot_reference='mapped_to_business_domain']/value]"/>
	 <xsl:variable name="businessDomainsNew" select="$busDomains[name=current()/own_slot_value[slot_reference='mapped_to_business_domains']/value]"/>
	 <xsl:variable name="businessDomains" select="$businessDomainsOld union $businessDomainsNew"/>
	 <xsl:variable name="refLayer" select="$taxonomyTerm[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>
	<xsl:variable name="categoryLayer" select="$taxonomyTermCat[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>	 
	<!--<xsl:variable name="thisApplicationServices" select="$applicationServices[own_slot_value[slot_reference='realises_application_capabilities']/value=current()/name]"/>	-->
	<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
	<xsl:variable name="parentAppCaps" select="key('appCapParent_key',current()/name)"/>  
	<xsl:variable name="supportedBusCaps" select="key('busCapMap_key',current()/name)"/>  
	<xsl:variable name="thisApplicationServices" select="key('appSvc_key',current()/name)"/> 												
	 	{ 
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
				 </xsl:call-template>",
			"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
			"domainIds":[<xsl:for-each select="$businessDomains"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"appCapCategory":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$categoryLayer"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			"businessDomain":[<xsl:for-each select="$businessDomains">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"ParentAppCapability":[<xsl:for-each select="$parentAppCaps">
				{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"SupportedBusCapability":[<xsl:for-each select="$supportedBusCaps">
					{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],	
			"ReferenceModelLayer":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$refLayer"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>, 
			"supportingServices":[<xsl:for-each select="$thisApplicationServices">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
			"documents":[<xsl:for-each select="$thisDocs">
			<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
			{"id":"<xsl:value-of select="current()/name"/>",
			"name":"<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
			"documentLink":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'external_reference_url']/value"/>",
			"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
			"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
			"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
			</xsl:for-each>]		
		}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:template>	
				
		<xsl:template match="node()" mode="appCapsHierachy">
				<xsl:param name="depth"/>
 
				<xsl:variable name="businessDomains" select="$busDomains[name=current()/own_slot_value[slot_reference='mapped_to_business_domain']/value]"/>
			   <xsl:variable name="refLayer" select="$taxonomyTerm[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>
			   <xsl:variable name="categoryLayer" select="$taxonomyTermCat[name=current()/own_slot_value[slot_reference='element_classified_by']/value]"/>	 
			<!--   <xsl:variable name="thisApplicationServices" select="$applicationServices[own_slot_value[slot_reference='realises_application_capabilities']/value=current()/name]"/>	-->

			   <xsl:variable name="thisApplicationServices" select="key('appSvc_key',current()/name)"/> 
				<xsl:variable name="childAppCaps" select="key('appCapChild_key',current()/name)"/>  
					{
					   "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
					   "level":"<xsl:value-of select="$depth"/>",
					   "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
					   "visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
					   "domainIds":[<xsl:for-each select="$businessDomains"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
					   "appCapCategory":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$categoryLayer"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
					   "businessDomain":[<xsl:for-each select="$businessDomains">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
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
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
				"APRs":[<xsl:for-each select="$thisApplicationProviderRoles">
						<xsl:variable name="standardForCurrentApp" select="$allAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = current()/name]"/>
							{
						"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
						"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						"lifecycle":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apr_lifecycle_status']/value)"/>",
						"appId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='role_for_application_provider']/value)"/>",
						"stds":[<xsl:for-each select="$standardForCurrentApp">
								<xsl:variable name="thisAppStandardOrg" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>
								<xsl:variable name="thisAppStrength" select="$standardStrength[name = current()/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
								{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
								 "strId":"<xsl:value-of select="eas:getSafeJSString($thisAppStrength[1]/own_slot_value[slot_reference='element_styling_classes']/value)"/>",
								 "str":"<xsl:value-of select="$thisAppStrength/own_slot_value[slot_reference='enumeration_value']/value"/>",
								 "org":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="$thisAppStandardOrg"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>"}<xsl:if test="not(position() = last())">,</xsl:if> </xsl:for-each>],
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
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
			}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="appTech">
			<xsl:variable name="environment" select="key('appDep_key',current()/name)"/>   
		<!--	<xsl:variable name="environment" select="$allAppDeployments[own_slot_value[slot_reference = 'application_provider_deployed']/value=current()/name]"/>-->
			<xsl:variable name="aTechBuild" select="$allTechBuilds[name = $environment/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
			<xsl:variable name="aTechBuildArch" select="key('tp_key',$aTechBuild/name)"/>   
		<!--	<xsl:variable name="aTechBuildArch" select="$allTechBuildArchs[name = $aTechBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>-->
		<xsl:variable name="aTechProUsageList" select="key('tprole_key',$aTechBuildArch/name)"/>  
		
		{ 
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"environments":[<xsl:for-each select="$environment">
				
				<xsl:variable name="thisdeploymentRole" select="$deploymentRole[name=current()/own_slot_value[slot_reference='application_deployment_role']/value]"/> 
				{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisdeploymentRole"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"products":[<xsl:for-each select="$aTechProUsageList">
						<xsl:variable name="aTechProRole" select="$allTechProRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
						<xsl:variable name="aTechProd" select="key('techprod_key',$aTechProRole/name)"/>   
					<!--	<xsl:variable name="aTechProd" select="$appTechProvs[name = $aTechProRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>-->
						<xsl:variable name="aTechComp" select="key('techcomp_key',$aTechProRole/name)"/>  
					<!--	<xsl:variable name="aTechComp" select="$appTechComps[name = $aTechProRole/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>-->
						{"tpr":"<xsl:value-of select="eas:getSafeJSString($aTechProRole/name)"/>",
						"prod":"<xsl:value-of select="eas:getSafeJSString($aTechProd/name)"/>",
						"prodname":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$aTechProd"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
						"comp":"<xsl:value-of select="eas:getSafeJSString($aTechComp/name)"/>",
						"compname":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$aTechComp"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>	
						}<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>]
				}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="appData">
		<xsl:variable name="thisSupplier" select="$suppliers[name=current()/own_slot_value[slot_reference='ap_supplier']/value]"/>
		<xsl:variable name="thisAppFamily" select="$appFamily[name=current()/own_slot_value[slot_reference='type_of_application']/value]"/>
		<xsl:variable name="inScopeCosts" select="key('inScopeCostsKey',current()/name)"/>
		<xsl:variable name="inScopeCostComponents" select="key('inScopeCostComponentKey',$inScopeCosts/name)"/>
		<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
			{  
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"type":"<xsl:value-of select="current()/type"/>",
				"documents":[<xsl:for-each select="$thisDocs">
				<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
				{"id":"<xsl:value-of select="current()/name"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isForJSONAPI" select="true()"/>
				</xsl:call-template>",
				"documentLink":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'external_reference_url']/value"/>",
				"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
				"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
				"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>],
				"supplier":{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisSupplier"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"},
				"costs":[<xsl:for-each select="$inScopeCostComponents"> 
				<xsl:variable name="parentCost" select="key('costForCat_key',current()/name)"/>
				<xsl:variable name="costCat" select="$costCategory[name=$parentCost/own_slot_value[slot_reference='cost_category']/value]"/>
						{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:value-of select="$costType[name=current()/own_slot_value[slot_reference='cc_cost_component_type']/value]/own_slot_value[slot_reference='name']/value"/>",
						"cost":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_amount']/value"/>",
						"costType":"<xsl:value-of select="current()/type"/>",
						<xsl:if test="$costCat"> 
						"costCategory":"<xsl:value-of select="$costCat/own_slot_value[slot_reference='enumeration_value']/value"/>",
						</xsl:if>
						"fromDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_start_date_iso_8601']/value"/>",
						"toDate":"<xsl:value-of select="current()/own_slot_value[slot_reference='cc_cost_end_date_iso_8601']/value"/>",
						"currency":"<xsl:value-of select="$currency"/>",
						<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="not(position()=last())">,</xsl:if>           
					</xsl:for-each>],
				"maxUsers":"<xsl:value-of select="current()/own_slot_value[slot_reference='ap_max_number_of_users']/value"/>",
				"family":[<xsl:for-each select="$thisAppFamily">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
	<xsl:template match="node()" mode="styles">
			<xsl:variable name="thisStyle" select="$eleStyles[name=current()[0]/own_slot_value[slot_reference='element_styling_classes']/value]"/>
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
	</xsl:stylesheet>
	