<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	
    <xsl:variable name="businessProcesses" select="/node()/simple_instance[type = 'Business_Process']"/>
    <xsl:variable name="businessCapabilities" select="/node()/simple_instance[type = 'Business_Capability'][name=$businessProcesses/own_slot_value[slot_reference='realises_business_capability']/value]"/>
	<xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"></xsl:variable>
	<xsl:variable name="countries" select="/node()/simple_instance[type='Geographic_Region']"/>
	<xsl:variable name="productConcepts" select="/node()/simple_instance[type='Product_Concept']"/>
	<xsl:variable name="productType" select="/node()/simple_instance[type=('Product_Type','Composite_Product_Type')][own_slot_value[slot_reference='product_type_realises_concept']/value=$productConcepts/name]"/>
	<xsl:variable name="products" select="/node()/simple_instance[type=('Product','Composite_Product')]"/>
	
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $businessProcesses/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActorsIndirect" select="$a2r[name=$relevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
	<xsl:variable name="actors" select="/node()/simple_instance[type = ('Group_Actor', 'Individual_Actor')]"></xsl:variable>	 
	<xsl:variable name="allOrgUsers2RoleSites" select="/node()/simple_instance[name = $actors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
	<xsl:variable name="allOrgUsers2RoleSitesCountry" select="/node()/simple_instance[name = $allOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>	
	<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu'][own_slot_value[slot_reference='report_menu_class']/value=('Business_Capability','Composite_Application_Provider','Individual_Actor','Group_Actor','Business_Process','Physical_Process','Business_Process_Family')]"></xsl:variable>

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
		{"meta":[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>],
		 "businessProcesses":[<xsl:apply-templates select="$businessProcesses" mode="businessProcesses"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"614"}
	</xsl:template>

<xsl:template match="node()" mode="businessProcesses">
	<xsl:variable name="parentCaps" select="$businessCapabilities[name=current()/own_slot_value[slot_reference='realises_business_capability']/value]"/>
 	<xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = current()/name]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActors" select="$actors[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsa2r" select="$thisrelevantPhysProcsActorsIndirect[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
	<xsl:variable name="thisrelevantPhysProcsActorsIn" select="$actors[name=$thisrelevantPhysProcsa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"></xsl:variable>
	<xsl:variable name="allActors" select="$thisrelevantPhysProcsActors union $thisrelevantPhysProcsActorsIn"/>
	<xsl:variable name="eaScopedOrgUserIds" select="$actors[name=$allActors/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>
	<xsl:variable name="thisOrgUsers2RoleSites" select="$allOrgUsers2RoleSites[name = $allActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>	
	<xsl:variable name="thisOrgUsers2RoleSitesCountry" select="$thisOrgUsers2RoleSites/own_slot_value[slot_reference = 'site_geographic_location']/value"/>	
	<xsl:variable name="eaScopedGeoIds" select="$countries[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>
	<xsl:variable name="allGeos" select="$eaScopedGeoIds union $thisOrgUsers2RoleSitesCountry"/>
	<xsl:variable name="thisProducts" select="$products[own_slot_value[slot_reference='product_implemented_by_process']/value=$thisrelevantPhysProcs/name]"/>
	<xsl:variable name="thisproductType" select="$productType[name=$thisProducts/own_slot_value[slot_reference='instance_of_product_type']/value]"/>
	<xsl:variable name="thisProductConcepts" select="$thisproductType/own_slot_value[slot_reference='product_type_realises_concept']/value"/>
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="nametemp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
   <xsl:variable name="nameresult" select="serialize($nametemp, map{'method':'json', 'indent':true()})"/>  
   <xsl:value-of select="substring-before(substring-after($nameresult,'{'),'}')"></xsl:value-of>,
   <xsl:variable name="temp" as="map(*)" select="map{'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))}"></xsl:variable>
   <xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
   <xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
		"flow":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>",	    
		"actors":[<xsl:for-each select="$allActors">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"parentCaps":[<xsl:for-each select="$parentCaps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
 		"orgUserIds": [<xsl:for-each select="$allActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"prodConIds": [<xsl:for-each select="$thisProductConcepts">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],		
		"geoIds": [<xsl:for-each select="$allGeos">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
 	<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>	
	<xsl:template match="node()" mode="classMetaData"> 
			<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
			{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
		</xsl:template>	
</xsl:stylesheet>
