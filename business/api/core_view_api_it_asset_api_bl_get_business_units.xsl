<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
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
	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
	<xsl:variable name="techOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User')]"/>
	<xsl:variable name="techOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $techOrgUserRole/name]"/>
	<xsl:variable name="allBusinessUnits" select="/node()/simple_instance[name = ($appOrgUser2Roles, $techOrgUser2Roles)/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allBusinessUnitOffices" select="/node()/simple_instance[name = $allBusinessUnits/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeGeoRegions" select="/node()/simple_instance[name = $allBusinessUnitOffices/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="allBusinessUnitOfficeLocations" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
	<xsl:variable name="allBusinessUnitLocationCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_locations']/value = $allBusinessUnitOfficeLocations/name]"/>
	<xsl:variable name="allBusinessUnitOfficeCountries" select="$allBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
	<xsl:variable name="allBusinessUnitCountries" select="$allBusinessUnitLocationCountries union $allBusinessUnitOfficeCountries"/>
    
	<xsl:template match="knowledge_base">
				{
                   "businessUnits": [<xsl:apply-templates select="$allBusinessUnits" mode="getBusinessUnits"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"></xsl:sort></xsl:apply-templates>]
						  	}
	</xsl:template>
	
	<xsl:template match="node()" mode="getBusinessUnits">
		<xsl:variable name="thisBusinessUnitOffice" select="$allBusinessUnitOffices[name = current()/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="thisBusinessUnitOfficeGeoRegions" select="$allBusinessUnitOfficeGeoRegions[name = $thisBusinessUnitOffice/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisBusinessUnitOfficeLocations" select="$thisBusinessUnitOfficeGeoRegions[type='Geographic_Location']"/>
		<xsl:variable name="thisBusinessUnitLocationCountries" select="$allBusinessUnitLocationCountries[own_slot_value[slot_reference = 'gr_locations']/value = $thisBusinessUnitOfficeLocations/name]"/>
		<xsl:variable name="thisBusinessUnitOfficeCountries" select="$thisBusinessUnitOfficeGeoRegions[type='Geographic_Region']"/>
		
		<xsl:variable name="thisBusinessUnitCountry" select="$thisBusinessUnitLocationCountries union $thisBusinessUnitOfficeCountries"/>
		<xsl:variable name="thisAppOrgUser2Roles" select="$appOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
		<xsl:variable name="thisApps2" select="$thisAppOrgUser2Roles/name"/>
		<xsl:variable name="thisTechProdOrgUser2Roles" select="$techOrgUser2Roles[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
 
        <xsl:variable name="thisTechProdss2" select="$thisTechProdOrgUser2Roles/name"/>

        <xsl:variable name="thisBusinessUnitName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusinessUnitDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>			
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="$thisBusinessUnitName"/>",
			"description": "<xsl:value-of select="$thisBusinessUnitDescription"/>",
    	 	"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			"country": [<xsl:for-each select="$thisBusinessUnitCountry">"<xsl:value-of select="current()/own_slot_value[slot_reference='gr_region_identifier']/value"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
            "apps2": [<xsl:for-each select="$thisApps2">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],
            "techProds2": [<xsl:for-each select="$thisTechProdss2">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
      
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	

</xsl:stylesheet>
