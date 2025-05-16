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
	<!-- 03.09.2019 JP  Created	 -->
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allCountries" select="/node()/simple_instance[(name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value) and (count(own_slot_value[slot_reference = 'gr_region_identifier']/value) > 0)]"/>
	<xsl:variable name="allLocations" select="/node()/simple_instance[type = 'Geographic_Location' and (name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
	<xsl:variable name="allSiteLocs" select="$allCountries union $allLocations"/>
	<xsl:variable name="allLocCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_contained_regions']/value = $allLocations]"/>

	<xsl:variable name="allTechnologyNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
	<xsl:variable name="allAppInstances" select="/node()/simple_instance[type = 'Application_Software_Instance']"/>
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[type = 'Application_Deployment']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="allDeploymentRoles" select="/node()/simple_instance[type = 'Deployment_Role']"/> 

	<xsl:variable name="techNodeSites" select="$allSites[name = $allTechnologyNodes/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountries" select="$allSiteLocs[name = $techNodeSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>

	<xsl:variable name="ipAddressAttribute" select="/node()/simple_instance[(type = 'Attribute') and (own_slot_value[slot_reference = 'name']/value = 'IP Address')]"/>
  
    <xsl:variable name="allAttributes" select="/node()/simple_instance[type = 'Attribute']" />
    <xsl:variable name="allAttributeValues" select="/node()/simple_instance[type = 'Attribute_Value']" />
    <xsl:variable name="allDeploymentStatus" select="/node()/simple_instance[type = 'Deployment_Status']" />
    <xsl:variable name="allTechnologyNodeTypes" select="/node()/simple_instance[type = 'Technology_Node_Type']" />
    <xsl:variable name="allTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product']" />  
     
    <xsl:key name="a2rKey" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
    <xsl:key name="actor2RoleKey" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="name"/> 
    <xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
    <xsl:key name="roles_key" match="/node()/simple_instance[type='Individual_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
    <xsl:key name="grpactors_key" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
    <xsl:key name="grproles_key" match="/node()/simple_instance[type='Group_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
    
	<xsl:template match="knowledge_base">
        {"technology_nodes": [
						   		<xsl:apply-templates select="$allTechnologyNodes" mode="allTechnologyNodes"/>  
						  	]
		}
	</xsl:template>
	
	<xsl:template match="node()" mode="allTechnologyNodes">
	<xsl:variable name="thisAppInstances" select="$allAppInstances[own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name]"/>
	<xsl:variable name="thisAppDeployments" select="$allAppDeployments[own_slot_value[slot_reference = 'application_deployment_technology_instance']/value = $thisAppInstances/name]"/>
	<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $thisAppDeployments/name]"/>
	<xsl:variable name="techNodeSite" select="$allSites[name = current()/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountry" select="$allSiteLocs[name = $techNodeSite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="currentTechNodeIPAddress" select="$allAttributeValues[(name = current()/own_slot_value[slot_reference = 'technology_node_attributes']/value) and (own_slot_value[slot_reference = 'attribute_value_of']/value = $ipAddressAttribute/name)]"/>
	<xsl:variable name="thisStakeholders" select="key('actor2RoleKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>     
	<xsl:variable name="currentTechNodeAttributesValue" select="$allAttributeValues[(name = current()/own_slot_value[slot_reference = 'technology_node_attributes']/value)]"/>
   
	{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		<xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
        }" />
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
          <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
		  "ip":"<xsl:value-of select="$currentTechNodeIPAddress/own_slot_value[slot_reference = 'attribute_value']/value"/>",
					"apps":[<xsl:for-each select="$thisApps">
									<xsl:variable name="appDeployments" select="$thisAppDeployments[name = current()/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
									{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>",
									"link":"<xsl:call-template name="RenderInstanceLinkForJS">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									</xsl:call-template>",
									"deployment":[<xsl:if test="count($appDeployments) > 0"><xsl:for-each select="$appDeployments">{"deploy":"<xsl:variable name="depRole" select="$allDeploymentRoles[name = current()/own_slot_value[slot_reference = 'application_deployment_role']/value]"/><xsl:value-of select="$depRole/own_slot_value[slot_reference = 'name']/value"/>"}<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>]</xsl:if>}<xsl:if test="not(position() = last())">, </xsl:if>
								</xsl:for-each>],
					"country":"<xsl:call-template name="RenderMultiLangInstanceName">
								<xsl:with-param name="theSubjectInstance" select="$techNodeCountry"/>
								</xsl:call-template>",
					"attributes": [
					<xsl:for-each select="current()/own_slot_value[slot_reference = 'technology_node_attributes']/value">
						<xsl:variable name="currentTechNodeAttributeValueOf" select="$currentTechNodeAttributesValue[name = current()]/own_slot_value[slot_reference = 'attribute_value_of']/value"/>
						{
						"id": "<xsl:value-of select="current()" />",
						"key": "<xsl:value-of select="$allAttributes[(name = $currentTechNodeAttributeValueOf)]/own_slot_value[slot_reference = 'name']/value" />",
						"attribute_value_of": "<xsl:value-of select="$allAttributes[(name = $currentTechNodeAttributeValueOf)]/own_slot_value[slot_reference = 'name']/value" />",
						"attribute_value": "<xsl:value-of select="$currentTechNodeAttributesValue[name = current()]/own_slot_value[slot_reference = 'attribute_value']/value" />",
						"attribute_value_unit": "<xsl:value-of select="$allAttributes[(name = $currentTechNodeAttributeValueOf)]/own_slot_value[slot_reference = 'attribute_value_unit']/value" />"
						}
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					],
					<xsl:variable name="thisDeploymentStatus" select="current()/own_slot_value[slot_reference = 'technology_node_deployment_status']"/>
					<xsl:if test="$thisDeploymentStatus">
						"deployment_status": {
						"id": "<xsl:value-of select="$thisDeploymentStatus/value" />",
						"className": "Deployment_Status",
						"name": "<xsl:value-of select="$allDeploymentStatus[name = $thisDeploymentStatus/value]/own_slot_value[slot_reference = 'name']/value" />"
						},
					</xsl:if>
					"technology_node_type": {
					"id": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'technology_node_type']/value" />",
					"className": "Technology_Node_Type",
					"name": "<xsl:value-of select="$allTechnologyNodeTypes[name = current()/own_slot_value[slot_reference = 'technology_node_type']/value]/own_slot_value[slot_reference = 'name']/value" />"
					},
					<xsl:variable name="thisDeploymentOf" select="current()/own_slot_value[slot_reference = 'deployment_of']"/>
					<xsl:if test="$thisDeploymentOf">
						"deployment_of": {
						"id": "<xsl:value-of select="$thisDeploymentOf/value" />",
						"className": "<xsl:value-of select="$allTechnologyProducts[name = $thisDeploymentOf/value]/type" />",
						"name": "<xsl:value-of select="$allTechnologyProducts[name = $thisDeploymentOf/value]/own_slot_value[slot_reference = 'name']/value" />"
						},
					</xsl:if>
					<xsl:variable name="techInstances" select="/node()/simple_instance[supertype='Technology_Instance'][name=current()/own_slot_value[slot_reference='contained_technology_instances']/value]"/>
					"instances": [
					<xsl:for-each select="$techInstances">
						<xsl:variable name="thisAppDeployment" select="$allAppDeployments[name=current()/own_slot_value[slot_reference='instance_of_application_deployment']/value]"/>
						<xsl:variable name="thisInfraInstance" select="$allTechnologyProducts[name=current()/own_slot_value[slot_reference='technology_instance_of']/value]"/>
						<xsl:if test="$thisAppDeployment">
							<xsl:variable name="thisApp" select="$allApps[name=$thisAppDeployment/own_slot_value[slot_reference='application_provider_deployed']/value]" />
							{
							"id": "<xsl:value-of select="current()/name" />",
							"className": "<xsl:value-of select="current()/type" />",
							"app": {
							"id": "<xsl:value-of select="$thisApp/name" />",
							"name": "<xsl:value-of select="$thisApp/own_slot_value[slot_reference='name']/value" />",
							"className": "<xsl:value-of select="$thisApp/type" />",
							"deployment": {
							"id": "<xsl:value-of select="$thisAppDeployment/name" />",
							"name": "<xsl:value-of select="$thisAppDeployment/own_slot_value[slot_reference='name']/value" />",
							"className": "<xsl:value-of select="$thisAppDeployment/type" />"
							}
							}
							
							}
						</xsl:if>
						<xsl:if test="$thisInfraInstance">
							{
							"id": "<xsl:value-of select="current()/name" />",
							"className": "<xsl:value-of select="current()/type" />",
							"tech": {
							"id": "<xsl:value-of select="$thisInfraInstance/name" />",
							"name": "<xsl:value-of select="$thisInfraInstance/own_slot_value[slot_reference='name']/value" />",
							"className": "<xsl:value-of select="$thisInfraInstance/type" />"
							}
							}
						</xsl:if>
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
						"actor":"<xsl:value-of select="$allthisActors/own_slot_value[slot_reference = 'name']/value"/>",  
						"actorId":"<xsl:value-of select="$allthisActors/name"/>",
						"role":"<xsl:value-of select="$allthisRoles/own_slot_value[slot_reference = 'name']/value"/>",  
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
						"name": "<xsl:value-of select="$thisNode/own_slot_value[slot_reference='name']/value" />",
						"techType": "<xsl:value-of select="$allTechnologyNodeTypes[name = $thisNode/own_slot_value[slot_reference = 'technology_node_type']/value]/own_slot_value[slot_reference = 'name']/value" />",
						"className": "<xsl:value-of select="$thisNode/type" />"
						}
						<xsl:if test="position()!=last()">,</xsl:if>
					</xsl:for-each>
					]
																
							}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

</xsl:stylesheet>
