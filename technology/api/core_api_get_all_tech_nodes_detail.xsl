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
	<xsl:variable name="allAttributeValues" select="/node()/simple_instance[type = 'Attribute_Value']"/>

	<xsl:variable name="techNodeSites" select="$allSites[name = $allTechnologyNodes/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountries" select="$allSiteLocs[name = $techNodeSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>

	<xsl:variable name="ipAddressAttribute" select="/node()/simple_instance[(type = 'Attribute') and (own_slot_value[slot_reference = 'name']/value = 'IP Address')]"/>
	<xsl:variable name="allRoadmapInstances" select="($allTechnologyNodes)"/>
	<xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
 
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
		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
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
									</xsl:call-template>"
							}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

</xsl:stylesheet>
