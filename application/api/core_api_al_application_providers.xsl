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
	
	
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
    <xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[type = 'Application_Provider_Role'][own_slot_value[slot_reference='role_for_application_provider']/value=$allAppProviders/name]"/>
    <xsl:variable name="allAppServices" select="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')][own_slot_value[slot_reference='provided_by_application_provider_roles']/value=$allAppProviderRoles/name]"/>
    <xsl:variable name="allAppCodebases" select="/node()/simple_instance[type = 'Codebase_Status']"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>
    <xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
    <xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
     <xsl:variable name="allActorsIndirect" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')][name=$appOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
    <xsl:variable name="allActorsDirect" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')][name=$appOrgUserRole/own_slot_value[slot_reference = 'stakeholders']/value]"/>
    <xsl:variable name="allActors" select="$allActorsDirect union $allActorsIndirect"/>
    <xsl:variable name="allRoadmapInstances" select="$allAppProviders"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    
	<xsl:template match="knowledge_base">
		{
			"applications": [
				<xsl:apply-templates mode="RenderApplications" select="$allAppProviders">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			]   
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderApplications" match="node()">
		<xsl:variable name="thisAppCodebase" select="$allAppCodebases[name = current()/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
		<xsl:variable name="thisAppDeliveryModel" select="$allAppDeliveryModels[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
		<xsl:variable name="thisAppOrgUser2Roles" select="$appOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
        <xsl:variable name="thisAppProviderRoles" select="$allAppProviderRoles[own_slot_value[slot_reference='role_for_application_provider']/value=current()/name]"/>
        <xsl:variable name="thisAppServices" select="$allAppServices[own_slot_value[slot_reference='provided_by_application_provider_roles']/value=$thisAppProviderRoles/name]"/>
	<!--	<xsl:variable name="thsAppUsers" select="$allBusinessUnits[name = $thisAppOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>-->
		<xsl:variable name="thsAppUsersIn" select="$thisAppOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
        <xsl:variable name="thisallActors" select="$allActors[name=$thisAppOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

		
		{
			<!--id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisAppName"/>",
			description: "<xsl:value-of select="$thisAppDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",-->
			<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"codebase": "<xsl:value-of select="eas:getSafeJSString($thisAppCodebase/name)"/>",
			"delivery": "<xsl:value-of select="eas:getSafeJSString($thisAppDeliveryModel/name)"/>",
            "service":[<xsl:for-each select="$thisAppProviderRoles"><xsl:variable name="thisSvc" select="$thisAppServices[own_slot_value[slot_reference='provided_by_application_provider_roles']/value=current()/name]"/>{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisSvc"/></xsl:call-template>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
            "appOrgUsers": [<xsl:for-each select="$thsAppUsersIn"><xsl:variable name="thisActors" select="$thisallActors[name=current()]"/>{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>","name":"<xsl:value-of select="$thisActors/own_slot_value[slot_reference = 'name']/value"/>","link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisActors"/></xsl:call-template>"}<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
