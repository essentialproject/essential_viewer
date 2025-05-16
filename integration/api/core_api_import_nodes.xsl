<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:key name="nodes" match="/node()/simple_instance[type=('Technology_Node')]" use="type"/>
	<xsl:variable name="nodes" select="key('nodes', 'Technology_Node')"/>
	<xsl:variable name="attribute" select="/node()/simple_instance[type=('Attribute')][own_slot_value[slot_reference='name']/value='IP Address']"/> 
	<xsl:variable name="criticality" select="/node()/simple_instance[type=('Business_Criticality')]"/> 
	<xsl:variable name="attributeValue" select="/node()/simple_instance[type=('Attribute_Value')][name=$nodes/own_slot_value[slot_reference='technology_node_attributes']/value][own_slot_value[slot_reference='attribute_value_of']/value=$attribute/name]"/>
	<xsl:variable name="site" select="/node()/simple_instance[type=('Site')][name=$nodes/own_slot_value[slot_reference='technology_deployment_located_at']/value]"/> 
	<xsl:key name="attributeValueKey" match="/node()/simple_instance[type=('Attribute_Value')][own_slot_value[slot_reference='attribute_value_of']/value=$attribute/name]" use="name"/>
	<xsl:key name="siteKey" match="/node()/simple_instance[type=('Site')]" use="name"/>
	<xsl:key name="infoStoreKey" match="/node()/simple_instance[type=('Information_Store')]" use="name"/>
	<xsl:key name="inforep" match="/node()/simple_instance[type=('Information_Representation')]" use="name"/>
	
	<xsl:key name="countriesLocations" match="/node()/simple_instance[type = ('Geographic_Region','Geographic_Location')]" use="name"/>
	<xsl:key name="geoCodes" match="/node()/simple_instance[type = ('GeoCode')]" use="name"/>
	<!-- new  -->
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allCountries" select="/node()/simple_instance[(name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value) and (count(own_slot_value[slot_reference = 'gr_region_identifier']/value) > 0)]"/>
	<xsl:variable name="allLocations" select="/node()/simple_instance[type = 'Geographic_Location' and (name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
	<xsl:variable name="allSiteLocs" select="$allCountries union $allLocations"/>
	<xsl:variable name="allLocCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_contained_regions']/value = $allLocations]"/>

	<xsl:variable name="allTechnologyNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
	<xsl:variable name="allAppInstances" select="/node()/simple_instance[type = 'Application_Software_Instance']"/>
	<xsl:key name="allAppInstances" match="/node()/simple_instance[type = 'Application_Software_Instance']" use="own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value"/>
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[type = 'Application_Deployment']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:key name="allApps" match="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]" use="name"/> 
	<xsl:variable name="allDeploymentRoles" select="/node()/simple_instance[type = 'Deployment_Role']"/> 
	<xsl:key name="allSoftwareComponentUsages" match="/node()/simple_instance[(type = 'Software_Component_Usage')]" use="name"/>
	<xsl:key name="allSoftwareComponent" match="/node()/simple_instance[(type = 'Software_Component')]" use="name"/>
	<xsl:key name="allSoftwareArchs" match="/node()/simple_instance[(type = 'Logical_Software_Architecture')]" use="name"/>
	<xsl:variable name="techNodeSites" select="$allSites[name = $allTechnologyNodes/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountries" select="$allSiteLocs[name = $techNodeSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>

	<xsl:variable name="ipAddressAttribute" select="/node()/simple_instance[(type = 'Attribute') and (own_slot_value[slot_reference = 'name']/value = 'IP Address')]"/>

	<xsl:key name="techTPR" match="/node()/simple_instance[supertype='Technology_Provider_Role']" use="name"/> 
  
    <xsl:key name="allAttributes" match="/node()/simple_instance[type = 'Attribute']" use="name" />
    <xsl:variable name="allAttributeValues" select="/node()/simple_instance[type = 'Attribute_Value']" />

    <xsl:variable name="allStyles" select="/node()/simple_instance[type = 'Element_Style']" />
    <xsl:variable name="allDeploymentStatus" select="/node()/simple_instance[type = 'Deployment_Status']" />
    <xsl:variable name="allTechnologyNodeTypes" select="/node()/simple_instance[type = 'Technology_Node_Type']" /> 
	
    <xsl:key name="allTechnologyProducts" match="/node()/simple_instance[type = 'Technology_Product']" use="name"/> 

    <xsl:key name="allTechnologyComponents" match="/node()/simple_instance[type = 'Technology_Component']" use="name"/> 
    <xsl:key name="allTechnologyInstances" match="/node()/simple_instance[supertype = 'Technology_Instance']" use="name"/> 
     
    <xsl:key name="a2rKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
    <xsl:key name="actor2RoleKey" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="name"/> 
    <xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
    <xsl:key name="roles_key" match="/node()/simple_instance[type='Individual_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
    <xsl:key name="grpactors_key" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
    <xsl:key name="grproles_key" match="/node()/simple_instance[type='Group_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
	<xsl:key name="techNodeToTechNode_key" match="/node()/simple_instance[type='TECH_NODE_TO_TECH_NODE_CONNECTION']" use="name"/>
    
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
		{"nodes":[<xsl:apply-templates select="$nodes" mode="nodes"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"appSoftwareMap": [<xsl:apply-templates select="$allApps" mode="swMap"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"styles":[<xsl:apply-templates select="$allDeploymentStatus union $allDeploymentRoles union $criticality" mode="styles"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		"version":"621"}
	</xsl:template>
	
<xsl:template match="node()" mode="swMap">
	<xsl:variable name="thissca" select="key('allSoftwareArchs', current()/own_slot_value[slot_reference='has_software_architecture']/value)"/>
	<xsl:variable name="thisscu" select="key('allSoftwareComponentUsages', $thissca/own_slot_value[slot_reference='logical_software_arch_elements']/value)"/>
	
	{
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"software_usages":[<xsl:for-each select="$thisscu">
			{
			"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" /><xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>	

<xsl:template match="node()" mode="nodes">
	<!--<xsl:variable name="thisattributeValue" select="$attributeValue[name=current()/own_slot_value[slot_reference='technology_node_attributes']/value]"/>-->
	<xsl:variable name="thisattributeValue" select="key('attributeValueKey', current()/own_slot_value[slot_reference='technology_node_attributes']/value)"/>
	<!--<xsl:variable name="thissite" select="$site[name=current()/own_slot_value[slot_reference='technology_deployment_located_at']/value]"/> 
	-->
	<xsl:variable name="thissite" select="key('siteKey', current()/own_slot_value[slot_reference='technology_deployment_located_at']/value)"/>
	<xsl:variable name="thisLocation" select="key('countriesLocations', $thissite/own_slot_value[slot_reference='site_geographic_location']/value)"/>
	<xsl:variable name="thisGeo" select="key('geoCodes', $thisLocation/own_slot_value[slot_reference=('gl_geocode','gr_region_centrepoint')]/value)"/>
	
	<xsl:variable name="thisAppInstances" select="key('allAppInstances', current()/name)"/>
	<xsl:variable name="thisAppDeployments" select="$allAppDeployments[own_slot_value[slot_reference = 'application_deployment_technology_instance']/value = $thisAppInstances/name]"/>
	<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $thisAppDeployments/name]"/>
	<xsl:variable name="techNodeSite" select="$allSites[name = current()/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountry" select="$allSiteLocs[name = $techNodeSite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="currentTechNodeIPAddress" select="$allAttributeValues[(name = current()/own_slot_value[slot_reference = 'technology_node_attributes']/value) and (own_slot_value[slot_reference = 'attribute_value_of']/value = $ipAddressAttribute/name)]"/>
	<xsl:variable name="thisStakeholders" select="key('actor2RoleKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>     
	<xsl:variable name="currentTechNodeAttributesValue" select="$allAttributeValues[(name = current()/own_slot_value[slot_reference = 'technology_node_attributes']/value)]"/>
	<xsl:variable name="currentTechStackTPRs" select="key('techTPR', current()/own_slot_value[slot_reference='technology_node_platform_stack']/value)"/>
	<xsl:variable name="thiscriticality" select="$criticality[name= current()/own_slot_value[slot_reference='tn_business_criticality']/value]"/>

	{
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"className":"<xsl:value-of select="current()/type"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'hostedIn': string(translate(translate($thissite/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'criticality': string(translate(translate($thiscriticality/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
			'criticalityId': string(translate(translate($thiscriticality/name, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"hostInfo": {"id":"<xsl:value-of select="eas:getSafeJSString($thissite/name)"/>", "name": "<xsl:value-of select="$thissite/own_slot_value[slot_reference = 'name']/value"/>", "className": "Site"},	
		"hostedInid":"<xsl:value-of select="eas:getSafeJSString($thissite/name)"/>",
		"hostedLocation":"<xsl:value-of select="eas:getSafeJSString($thissite/own_slot_value[slot_reference='site_geographic_location']/value)"/>",
		"ipAddress":"<xsl:value-of select="$thisattributeValue/own_slot_value[slot_reference='attribute_value']/value"/>",
		"ipAddresses":[<xsl:for-each select="$thisattributeValue/own_slot_value[slot_reference='attribute_value']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"lon":"<xsl:value-of select="$thisGeo/own_slot_value[slot_reference = 'geocode_longitude']/value"/>",
		"lat":"<xsl:value-of select="$thisGeo/own_slot_value[slot_reference = 'geocode_latitude']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>,
		"inboundConnections":[<xsl:for-each select="key('techNodeToTechNode_key', current()/own_slot_value[slot_reference='technology_node_inbound_connections']/value)">"<xsl:value-of select="current()/own_slot_value[slot_reference='tech_node_to_tech_node_from_tech_node']/value"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"outboundConnections":[<xsl:for-each select="key('techNodeToTechNode_key', current()/own_slot_value[slot_reference='technology_node_outbound_connections']/value)">"<xsl:value-of select="current()/own_slot_value[slot_reference='tech_node_to_tech_node_to_tech_node']/value"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"techStack":[<xsl:for-each select="$currentTechStackTPRs">
					<xsl:variable name="currentTechStackTP" select="key('allTechnologyProducts', current()/own_slot_value[slot_reference='role_for_technology_provider']/value)"/>
					<xsl:variable name="currentTechStackTC" select="key('allTechnologyComponents', current()/own_slot_value[slot_reference='implementing_technology_component']/value)"/>
					{"idTP":"<xsl:value-of select="eas:getSafeJSString($currentTechStackTP/name)"/>",
					"idTC":"<xsl:value-of select="eas:getSafeJSString($currentTechStackTC/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
					'technology_product': string(translate(translate($currentTechStackTP/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
					'technology_component': string(translate(translate($currentTechStackTC/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
					}"/>
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
				}
		<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>],
		"attributes": [
					<xsl:for-each select="current()/own_slot_value[slot_reference = 'technology_node_attributes']/value">
						<xsl:variable name="currentTechNodeAttributeValueOf" select="$currentTechNodeAttributesValue[name = current()]/own_slot_value[slot_reference = 'attribute_value_of']/value"/>
						{
						"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
						"key": "<xsl:value-of select="key('allAttributes', $currentTechNodeAttributeValueOf)/own_slot_value[slot_reference = 'name']/value" />",
						"attribute_value_of": "<xsl:value-of select="key('allAttributes',$currentTechNodeAttributeValueOf)/own_slot_value[slot_reference = 'name']/value" />",
						"attribute_value": "<xsl:value-of select="$currentTechNodeAttributesValue[name = current()]/own_slot_value[slot_reference = 'attribute_value']/value" />",
						"attribute_value_unit": "<xsl:value-of select="key('allAttributes', $currentTechNodeAttributeValueOf)/own_slot_value[slot_reference = 'attribute_value_unit']/value" />"
						}
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					],
					 <xsl:variable name="thisDeploymentStatus" select="$allDeploymentStatus[name=current()/own_slot_value[slot_reference = 'technology_node_deployment_status']/value]"/>
			
					<xsl:if test="$thisDeploymentStatus">
						"deployment_status": {
						"id":"<xsl:value-of select="eas:getSafeJSString($thisDeploymentStatus/name)"/>", 
						"className": "Deployment_Status",
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'name': string(translate(translate($thisDeploymentStatus/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
							}"/>
							<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
							<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>},
					</xsl:if>
					"technology_node_type": {
					"id": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'technology_node_type']/value" />",
					"className": "Technology_Node_Type",
					"name": "<xsl:value-of select="$allTechnologyNodeTypes[name = current()/own_slot_value[slot_reference = 'technology_node_type']/value]/own_slot_value[slot_reference = 'name']/value" />",
					"icon": "<xsl:value-of select="$allTechnologyNodeTypes[name = current()/own_slot_value[slot_reference = 'technology_node_type']/value]/own_slot_value[slot_reference = 'enumeration_icon']/value" />"
					},
					<xsl:variable name="thisDeploymentOf" select="current()/own_slot_value[slot_reference = 'deployment_of']"/>
					<xsl:if test="$thisDeploymentOf">
						"deployment_of": {
						"id": "<xsl:value-of select="$thisDeploymentOf/value" />",
						"className": "<xsl:value-of select="key('allTechnologyProducts', $thisDeploymentOf/value)/type" />",
						"name": "<xsl:value-of select="key('allTechnologyProducts', $thisDeploymentOf/value)/own_slot_value[slot_reference = 'name']/value" />"
						},
					</xsl:if>
					<xsl:variable name="techInstances" select="key('allTechnologyInstances',current()/own_slot_value[slot_reference='contained_technology_instances']/value)"/>
					"instances": [
					<xsl:for-each select="$techInstances">
						<xsl:variable name="thisAppDeployment" select="$allAppDeployments[name=current()/own_slot_value[slot_reference='instance_of_application_deployment']/value]"/>
						<xsl:variable name="thisInfraInstance" select="key('allTechnologyProducts', current()/own_slot_value[slot_reference='technology_instance_of']/value)"/>
						<xsl:variable name="thisRuntimeStatus" select="$allDeploymentStatus[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
						
							{
							"id": "<xsl:value-of select="current()/name" />",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'given_name': string(translate(translate(current()/own_slot_value[slot_reference = 'technology_instance_given_name']/value, '}', ')'), '{', ')')),
								'runtime_status': string(translate(translate($thisRuntimeStatus/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
								'runtime_status_id': string(translate(translate($thisRuntimeStatus/name, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
							"className": "<xsl:value-of select="current()/type" />",
							"instance_software_dependencies":[<xsl:for-each select="key('allTechnologyInstances', current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value)[type='Infrastructure_Software_Instance']">
								<xsl:variable name="techProd" select="key('allTechnologyProducts', current()/own_slot_value[slot_reference = 'technology_instance_of']/value)"/>
								<!-- runtime instance and technology -->
								{"id": "<xsl:value-of select="current()/name" />",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'given_name': string(translate(translate(current()/own_slot_value[slot_reference = 'technology_instance_given_name']/value, '}', ')'), '{', ')')),
								'technology_product':string(translate(translate($techProd/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
								 
								}<xsl:if test="position()!=last()">,</xsl:if> 
							</xsl:for-each>]
							<xsl:if test="current()/own_slot_value[slot_reference='instance_of_information_store']/value">
								<xsl:variable name="infoStore" select="key('infoStoreKey', current()/own_slot_value[slot_reference='instance_of_information_store']/value)"/>
								<xsl:variable name="inforep" select="key('inforep', $infoStore/own_slot_value[slot_reference = 'deployment_of_information_representation']/value)"/>
								<xsl:variable name="thisinfoStoreDeployment" select="$allDeploymentRoles[name=$infoStore/own_slot_value[slot_reference='information_store_deployment_role']/value]"/>
							,"instance_of_information_store":{
								"id": "<xsl:value-of select="$infoStore/name" />",
								"className": "<xsl:value-of select="$infoStore/type" />",
								"infoRepid": "<xsl:value-of select="$inforep/name" />",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate($infoStore/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'inforep': string(translate(translate($inforep/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'role': string(translate(translate($thisinfoStoreDeployment/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
								'roleid': string(translate(translate($thisinfoStoreDeployment/name, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}
							</xsl:if>
							<xsl:if test="$thisAppDeployment">
							<xsl:variable name="thisApp" select="key('allApps', $thisAppDeployment/own_slot_value[slot_reference='application_provider_deployed']/value)" />
							<xsl:variable name="thisSWComponents" select="key('allSoftwareComponentUsages', $thisAppDeployment/own_slot_value[slot_reference='deployment_of_software_components']/value)" />
							<xsl:variable name="thisSWArchs" select="key('allSoftwareArchs', $thisSWComponents/own_slot_value[slot_reference='contained_in_logical_software_arch']/value)" />
							
							
							,
							"app": {
							"id": "<xsl:value-of select="$thisApp/name" />", 
							"software_architectures":[<xsl:for-each select="$thisSWArchs[own_slot_value[slot_reference='software_architecture_of_app_provider']/value = $thisApp/name]">
								{
								"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" /><xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
							}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate($thisApp/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
							"className": "<xsl:value-of select="$thisApp/type" />",
							"deployment": {
							"id": "<xsl:value-of select="$thisAppDeployment/name" />", 
							<xsl:variable name="thisAppDeploymentRole" select="$allDeploymentRoles[name=$thisAppDeployment/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate($thisAppDeployment/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
								'role': string(translate(translate($thisAppDeploymentRole/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
								'roleid': string(translate(translate($thisAppDeploymentRole/name, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
							"className": "<xsl:value-of select="$thisAppDeployment/type" />"
							}
							}
							</xsl:if>
						<xsl:if test="$thisInfraInstance">  
							,"tech": {
							"id": "<xsl:value-of select="$thisInfraInstance/name" />",
							<xsl:variable name="combinedMap" as="map(*)" select="map{
								'name': string(translate(translate($thisInfraInstance/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
								}"/>
								<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
								<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
							"deployment": {
								"id": "<xsl:value-of select="$thisAppDeployment/name" />",
								<xsl:variable name="thisAppDeploymentRole" select="$allDeploymentRoles[name=$thisAppDeployment/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
								<xsl:variable name="combinedMap" as="map(*)" select="map{
									'name': string(translate(translate($thisAppDeployment/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
									'role': string(translate(translate($thisAppDeploymentRole/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
									'roleid': string(translate(translate($thisAppDeploymentRole/name, '}', ')'), '{', ')'))
									}"/>
									<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
									<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
									"className": "<xsl:value-of select="$thisAppDeployment/type" />"
							},
							"className": "<xsl:value-of select="$thisInfraInstance/type" />"
							
							}
						</xsl:if>
							}
					
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					],
					"stakeholders":[
					<xsl:for-each select="$thisStakeholders">
						{
						<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
						<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
						<xsl:variable name="thisgrpActors" select="key('grpactors_key',current()/name)"/>
						<xsl:variable name="thisgrpRoles" select="key('grproles_key',current()/name)"/>
						<xsl:variable name="allthisActors" select="$thisActors union $thisgrpActors"/>
						<xsl:variable name="allthisRoles" select="$thisRoles union $thisgrpRoles"/>
						"type": "<xsl:value-of select="$allthisActors/type"/>",
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'actor': string(translate(translate($allthisActors/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
							'role': string(translate(translate($allthisRoles/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
							}"/>
							<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
							<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
						"actorId":"<xsl:value-of select="$allthisActors/name"/>",  
						"roleId":"<xsl:value-of select="$allthisRoles/name"/>"
						}
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					],
					"parentNodes": [
					<xsl:variable name="parentNodes" select="current()/own_slot_value[slot_reference='inverse_of_contained_technology_nodes']/value"/>
					<xsl:for-each select="$parentNodes">
						<xsl:variable name="thisNode" select="$allTechnologyNodes[name=current()]"/>
						{
						"id": "<xsl:value-of select="$thisNode/name" />",
						<xsl:variable name="combinedMap" as="map(*)" select="map{
							'name': string(translate(translate($thisNode/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
							}"/>
							<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
							<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,  
						"techType": "<xsl:value-of select="$allTechnologyNodeTypes[name = $thisNode/own_slot_value[slot_reference = 'technology_node_type']/value]/own_slot_value[slot_reference = 'name']/value" />",
						"className": "<xsl:value-of select="$thisNode/type" />"
						}
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					]
																
				}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
<xsl:template match="node()" mode="styles">
	<xsl:variable name="thisStyle" select="$allStyles[name=current()/own_slot_value[slot_reference = 'element_styling_classes']/value][1]"/>
	{
		"id": "<xsl:value-of select="current()/name" />",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'backgroundColour': string(translate(translate($thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value, '}', ')'), '{', ')')),
			'textColour': string(translate(translate($thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value, '}', ')'), '{', ')')),
			'icon': string(translate(translate($thisStyle/own_slot_value[slot_reference = 'element_style_icon']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
	}<xsl:if test="not(position() = last())">, </xsl:if>
</xsl:template>
</xsl:stylesheet>
