<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
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
	<!-- 03.12.2018 JP  Created	 -->

	
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	
	<!-- Business Capabilities, Processes and Organisations -->
	<!--<xsl:variable name="allBusCapabilities" select="/node()/simple_instance[type = 'Business_Capability']"/>-->
	<xsl:variable name="focusInstance" select="/node()/simple_instance[name = $param1]"/>
<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
    <xsl:variable name="scopingApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
    <xsl:variable name="relevantBusProcs" select="/node()/simple_instance[type = ('Business_Process')][own_slot_value[slot_reference = 'realises_business_capability']/value = $param1]"/>
	<xsl:variable name="relevantBusProcs2" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusinessCaps/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
    <xsl:variable name="relevantPhysProcsIncSub" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs2/name]"/>
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"/>
	<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="relevantPhysProc2AppProRolesIncSub" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcsIncSub/name]"/>
	<xsl:variable name="relevantAppProRolesIncSub" select="/node()/simple_instance[name = $relevantPhysProc2AppProRolesIncSub/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
    <xsl:variable name="relevantApps" select="$scopingApps[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
    <!-- get sub cap data -->
    <xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps($focusInstance, ())"/>
    <xsl:variable name="thisBusProcsIncSub" select="$relevantBusProcs2[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
    <xsl:variable name="thisPhysProcsIncSub" select="$relevantPhysProcsIncSub[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusProcsIncSub/name]"/>
    <xsl:variable name="thisPhysProc2AppProRolesIncSub" select="$relevantPhysProc2AppProRolesIncSub[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysProcsIncSub/name]"/>
    <xsl:variable name="thisAppProRolesIncSub" select="$relevantAppProRolesIncSub[name = $thisPhysProc2AppProRolesIncSub/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
    <xsl:variable name="thisApps" select="$scopingApps[name = $thisAppProRolesIncSub/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
    <xsl:variable name="appUser" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference='name']/value = ('Application User','Application Organisation User')]"/>
    <xsl:variable name="a2rAll" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][name = $thisApps/own_slot_value[slot_reference = 'stakeholders']/value]"/>
    <xsl:variable name="a2r" select="$a2rAll[own_slot_value[slot_reference = 'act_to_role_to_role']/value=$appUser/name]"/>
    <xsl:variable name="org" select="/node()/simple_instance[type = 'Group_Actor'][name = $a2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
    <xsl:variable name="busCapDiffLevelTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Business Differentiation Level')]"/>
	<xsl:variable name="busCapDiffLevels" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $busCapDiffLevelTaxonomy/name]"/>
    
	<xsl:variable name="allDeliveryModels" select="/node()/simple_instance[(type = 'Application_Delivery_Model')]"/>
	<xsl:variable name="allCodebaseStatus" select="/node()/simple_instance[type = 'Codebase_Status']"/>
    <xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[(type = 'Lifecycle_Status')]"/>
	<xsl:variable name="allRoadmapInstances" select="$thisApps union $allBusinessCaps union $org"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
	

	<xsl:template match="knowledge_base">
		<xsl:call-template name="getModalJSON"/>
	</xsl:template>


	<!-- Template to return all read only data for the view -->
	<xsl:template name="getModalJSON">
		{
			"focusInstance": <xsl:apply-templates mode="RenderSummary" select="$focusInstance"/>
		}
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderSummary">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		{
		<xsl:call-template name="RenderRoadmapJSONPropertiesDataAPI"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="$thisDesc"/>",
        "appsDirect":[<xsl:apply-templates select="$relevantApps" mode="apps"/>],
        "appsIncSubCapApps":[<xsl:apply-templates select="$thisApps" mode="apps"/>],
        "diffLevel":"<xsl:value-of select="$busCapDiffLevels[name = current()/own_slot_value[slot_reference = 'element_classified_by']/value]/own_slot_value[slot_reference = 'name']/value"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
<xsl:template match="node()" mode="apps">
    <xsl:variable name="thisa2r" select="$a2r[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
    <xsl:variable name="thisOrg" select="$org[name = $thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
    <xsl:variable name="codebaseID" select="current()/own_slot_value[slot_reference='ap_codebase_status']/value"/>
    <xsl:variable name="codebase" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]"/>
    {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
    "codebaseID":"<xsl:value-of select="current()/own_slot_value[slot_reference='ap_codebase_status']/value"/>",
    "codebase":"<xsl:value-of select="$codebase/own_slot_value[slot_reference='name']/value"/>",
    "deliveryModel":"<xsl:value-of select="$allDeliveryModels[name=current()/own_slot_value[slot_reference='ap_delivery_model']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
    "lifecycleStatus":"<xsl:value-of select="$allLifecycleStatus[name=current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
    "orgs":[<xsl:apply-templates select="$thisOrg" mode="orgs"/>]}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
    <xsl:template match="node()" mode="orgs">
    {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>  
	
		<xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusinessCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aDirectChildList" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theParentCap/name]"/>
				<xsl:variable name="aNewList" select="$aDirectChildList union $aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- END UTILITY TEMPLATES AND FUNCTIONS -->

</xsl:stylesheet>
