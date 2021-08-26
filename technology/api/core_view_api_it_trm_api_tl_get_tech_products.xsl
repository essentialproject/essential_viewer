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
	<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
	<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/>
		<!-- ROADMAP VARIABLES 	-->
	<xsl:variable name="allRoadmapInstances" select="$allTechProds"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/> 
	
	<xsl:template match="knowledge_base">
       {
		"techProducts": [<xsl:apply-templates select="$allTechProds" mode="getTechProducts"/>]
		  	}
	</xsl:template>
	<xsl:template match="node()" mode="getTechProducts">
	<xsl:variable name="thisTechOrgUser2Roles" select="$techOrgUser2Roles[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="thsTechUsers" select="$thisTechOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>
		<xsl:variable name="theLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'vendor_product_lifecycle_status']/value]"/>
		<xsl:variable name="theDeliveryModel" select="$allTechProdDeliveryTypes[name = current()/own_slot_value[slot_reference = 'technology_provider_delivery_model']/value]"/>
		<xsl:variable name="theStatusScore" select="$theLifecycleStatus/own_slot_value[slot_reference = 'enumeration_score']/value"/>
		<xsl:variable name="thisTechProdName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisTechProdDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>	
		

		{
			<!--id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$thisTechProdName"/>",
			description: "<xsl:value-of select="$thisTechProdDescription"/>",
			link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",-->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
			"status": "<xsl:value-of select="translate($theLifecycleStatus/name, '.', '_')"/>",
			"statusScore": <xsl:choose><xsl:when test="$theStatusScore > 0"><xsl:value-of select="$theStatusScore"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>,
			"delivery": "<xsl:value-of select="translate($theDeliveryModel/name, '.', '_')"/>",
			"techOrgUsers": [<xsl:for-each select="$thsTechUsers">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		} <xsl:if test="not(position()=last())">,
	</xsl:if>
	</xsl:template>

</xsl:stylesheet>
