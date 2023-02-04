<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="physicalProcess" select="/node()/simple_instance[type=('Physical_Process')]"/> 
	<xsl:variable name="a2r" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')][name=$physicalProcess/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="orgviaa2r" select="/node()/simple_instance[type=('Group_Actor')][name=$a2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="orgdirect" select="/node()/simple_instance[type=('Group_Actor')][name=$physicalProcess/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="orgs" select="$orgdirect union $orgviaa2r"/>
	<xsl:variable name="businessProcess" select="/node()/simple_instance[type=('Business_Process')][name=$physicalProcess/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="aprpbr" select="/node()/simple_instance[type=('APP_PRO_TO_PHYS_BUS_RELATION')][name=$physicalProcess/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
	<xsl:variable name="apr" select="/node()/simple_instance[type=('Application_Provider_Role')][name=$aprpbr/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="AppsViaService" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$apr/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="AppsDirect" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$aprpbr/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	 
	<xsl:key name="busProcess_key" match="/node()/simple_instance[type=('Business_Process')]" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/>
	<xsl:key name="appbr_key" match="/node()/simple_instance[type=('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/>
	<xsl:key name="apr_key" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/>
	<xsl:key name="app_key" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'app_pro_supports_phys_proc']/value"/>
	
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
		{"process_to_apps":[<xsl:apply-templates select="$physicalProcess" mode="process2Apps"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],"version":"6141"}
	</xsl:template>

	<xsl:template match="node()" mode="process2Apps">
	<!-- <xsl:variable name="thisbpr" select="$businessProcess[name=current()/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
		<xsl:variable name="thisaprpbr" select="$aprpbr[name=current()/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
		<xsl:variable name="thisapr" select="$apr[name=$thisaprpbr/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisAppsDirect" select="$AppsDirect[name=$thisaprpbr/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	 -->
	<xsl:variable name="thisbpr" select="key('busProcess_key',current()/name)"/>
	<xsl:variable name="thisorg" select="$orgs[name=current()/own_slot_value[slot_reference = 'implements_business_process']/value]"/> 	
	<xsl:variable name="thisaprpbr" select="key('appbr_key',current()/name)"/>
	<xsl:variable name="thisapr" select="key('apr_key',$thisaprpbr/name)"/>
	<xsl:variable name="thisAppsDirect" select="key('app_key',$thisaprpbr/name)"/>	
	
	<xsl:variable name="thisAppsViaService" select="$AppsViaService[name=$thisapr/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		
	<xsl:variable name="thisa2r" select="$a2r[name=current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="thisorgviaa2r" select="$orgviaa2r[name=$thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="thisorgdirect" select="$orgdirect[name=current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="thisorgs" select="$thisorgdirect union $thisorgviaa2r"/>	

	{  
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"processName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisbpr"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"org":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisorgs"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"orgid":"<xsl:value-of select="eas:getSafeJSString($thisorgs/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"processid":"<xsl:value-of select="eas:getSafeJSString($thisbpr/name)"/>",
		"appsviaservice":[<xsl:for-each select="$thisapr">
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","svcid":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='implementing_application_service']/value)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","appid":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='role_for_application_provider']/value)"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"appsdirect":[<xsl:for-each select="$thisAppsDirect">
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
</xsl:stylesheet>
