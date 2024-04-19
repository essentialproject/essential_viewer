<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
 
 	<xsl:variable name="applicationArchitecture" select="/node()/simple_instance[type=('Static_Application_Provider_Architecture')][count(own_slot_value[slot_reference=':TO']/value)&gt;0 and count(own_slot_value[slot_reference=':FROM']/value)&gt;0]"/>

	<xsl:variable name="apus" select="/node()/simple_instance[type=('Static_Application_Provider_Usage')]"/>
	<xsl:variable name="applications" select="/node()/simple_instance[type=('Application_Provider', 'Composite_Application_Provider')][name=$apus/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
	<xsl:variable name="dataAquisition" select="/node()/simple_instance[type=('Data_Acquisition_Method')]"/>
	<xsl:variable name="infoReps" select="/node()/simple_instance[type=('Information_Representation')]"/>
	<xsl:variable name="apptoInfoReps" select="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION')]"/>
	<xsl:variable name="infoServiceQuality" select="/node()/simple_instance[type=('Information_Service_Quality_Value')]"/>
	<xsl:variable name="APUrelations" select="/node()/simple_instance[type=(':APU-TO-APU-STATIC-RELATION')]"/>
	<xsl:variable name="appInformationEx" select="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]"/>	
 	 
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
		{"application_dependencies":[<xsl:apply-templates select="$APUrelations" mode="appDependencies"></xsl:apply-templates>]}
	</xsl:template>

	 
 	 
 <xsl:template match="node()" mode="appDependencies">
	 <xsl:variable name="thisInfo" select="$appInformationEx[name=current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
	 
	 
	 <xsl:variable name="frequency" select="$infoServiceQuality[name=$thisInfo/own_slot_value[slot_reference='atire_service_quals']/value]"/>
	 
	 <xsl:variable name="source" select="$apus[name=current()/own_slot_value[slot_reference=':TO']/value]"/>
	 <xsl:variable name="target" select="$apus[name=current()/own_slot_value[slot_reference=':FROM']/value]"/>
	 <xsl:variable name="sourceApp" select="$applications[name=$source/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
	 <xsl:variable name="targetApp" select="$applications[name=$target/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
	<xsl:variable name="acquire" select="$dataAquisition[name=$thisInfo/own_slot_value[slot_reference='atire_acquisition_method']/value]"/>
    {"source":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$sourceApp"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"target":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$targetApp"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"sourceType":"<xsl:value-of select="$sourceApp/type"/>",
	"targetType":"<xsl:value-of select="$targetApp/type"/>",
	"info":[<xsl:if test="$sourceApp"><xsl:if test="$targetApp"><xsl:for-each select="$thisInfo"><xsl:variable name="thisAppInfoRep" select="$apptoInfoReps[name=current()/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value]"/>
	<xsl:variable name="thisInfoRep" select="$infoReps[name=$thisAppInfoRep/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/> 	 
	 {
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisInfoRep"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"
	,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each></xsl:if></xsl:if>],
	"frequency":[<xsl:for-each select="$frequency">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"acquisition":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$acquire[1]"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>
	
</xsl:stylesheet>
