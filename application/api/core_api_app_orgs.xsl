<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:import href="../../common/core_el_ref_model_include.xsl"/>
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
	
	<!-- Business Capabilities, Processes and Organisations -->
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"></xsl:variable>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type='Physical_Process']"></xsl:variable>
	<xsl:variable name="allAPRs" select="/node()/simple_instance[type='Application_Provider_Role']"></xsl:variable>   
	<!--<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $allPhysProcs/name]"></xsl:variable>
	<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>-->
    <xsl:variable name="processToAppRel" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"></xsl:variable>
    <xsl:variable name="processPerformed" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"></xsl:variable>
	<xsl:variable name="actors" select="/node()/simple_instance[type = 'Group_Actor']"></xsl:variable>
	<xsl:variable name="appOrgUsers" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference='name']/value=('Application Organisation User','Application User')]"></xsl:variable>
	 <xsl:variable name="actorsATRAppUsers" select="$processPerformed[own_slot_value[slot_reference='act_to_role_to_role']/value=$appOrgUsers/name]"></xsl:variable>
	<xsl:variable name="actorsforAppUsers" select="$actors[name=$actorsATRAppUsers/own_slot_value[slot_reference='act_to_role_from_actor']/value]"></xsl:variable>
	
<!--
	<xsl:variable name="directProcessToAppRel" select="$processToAppRel[name = $relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
	<xsl:variable name="directProcessToApp" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
	<xsl:variable name="relevantApps" select="$allAppProviders[name = $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
	<xsl:variable name="relevantApps2" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>-->


	<xsl:template match="knowledge_base">
		{
			"applicationOrgUsers": [<xsl:apply-templates select="$allAppProviders" mode="appOrgList"><xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/></xsl:apply-templates>]
		}
	</xsl:template> 

	<!-- Render a JSON object representing a an Application -->
	<xsl:template match="node()" mode="appOrgList">
  <xsl:variable name="processtoApp" select="$processToAppRel[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = current()/name]"></xsl:variable>
  <xsl:variable name="thisPhysicalProcessDirect" select="$allPhysProcs[name=$processtoApp/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"></xsl:variable>
 

  <xsl:variable name="thisAppAPR" select="$allAPRs[own_slot_value[slot_reference = 'role_for_application_provider']/value=current()/name]"></xsl:variable>
  <xsl:variable name="processtoAppviaAPR" select="$processToAppRel[name=$thisAppAPR/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value]"></xsl:variable> 
  <xsl:variable name="thisPhysicalProcessviaAPR" select="$allPhysProcs[name=$processtoAppviaAPR/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"></xsl:variable>


  <xsl:variable name="thisPhysicalProcess" select="$thisPhysicalProcessDirect union $thisPhysicalProcessviaAPR"></xsl:variable>
  <xsl:variable name="thisProcessPerformed" select="$processPerformed[name=$thisPhysicalProcess/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
  <xsl:variable name="thisActorsviaRole" select="$actors[name=$thisProcessPerformed/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"></xsl:variable>
  <xsl:variable name="thisActorsDirect" select="$actors[name=$thisPhysicalProcess/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"></xsl:variable>
 

 
  <xsl:variable name="thisactorsATRAppUsers" select="$actorsATRAppUsers[name=current()/own_slot_value[slot_reference='stakeholders']/value]"></xsl:variable>
  <xsl:variable name="thisactorsforAppUsers" select="$actors[name=$thisactorsATRAppUsers/own_slot_value[slot_reference='act_to_role_from_actor']/value]"></xsl:variable>

  <xsl:variable name="thisActors" select="$thisActorsviaRole union $thisActorsDirect union $thisactorsforAppUsers"></xsl:variable>
  
   <!-- 
        <xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisrelevantBusProcs/name]"></xsl:variable>
		<xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisrelevantPhysProcs/name]"></xsl:variable>
		<xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[name = $thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"></xsl:variable>
	
		<xsl:variable name="thisdirectProcessToAppRel" select="$directProcessToAppRel[name = $thisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"></xsl:variable>
		<xsl:variable name="thisdirectProcessToApp" select="$directProcessToApp[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
		<xsl:variable name="thisrelevantApps" select="$relevantApps[name = $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"></xsl:variable>
        <xsl:variable name="thisrelevantApps2" select="$relevantApps2[name = $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"></xsl:variable>
-->    
		 {
		 "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
          "name": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>",
		"organisations":[<xsl:for-each select="$thisActors">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
</xsl:stylesheet>