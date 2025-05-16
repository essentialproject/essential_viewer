<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
 <xsl:key name="appArch" match="/node()/simple_instance[type=('Static_Application_Provider_Architecture')]" use="type"/>
 	<xsl:variable name="applicationArchitecture" select="key('appArch', 'Static_Application_Provider_Architecture')[count(own_slot_value[slot_reference=':TO']/value)&gt;0 and count(own_slot_value[slot_reference=':FROM']/value)&gt;0]"/>
	 <xsl:key name="apus" match="/node()/simple_instance[type=('Static_Application_Provider_Usage')]" use="name"/>
	<xsl:variable name="apus" select="/node()/simple_instance[type=('Static_Application_Provider_Usage')]"/>

	<xsl:key name="applicationsall" match="/node()/simple_instance[type=('Application_Provider', 'Composite_Application_Provider')]" use="name"/>
	<!--
	<xsl:key name="applications" match="key('applicationsall', $apus/own_slot_value[slot_reference='static_usage_of_app_provider']/value)" use="name"/>-->
		<xsl:variable name="dataAquisition" select="/node()/simple_instance[type=('Data_Acquisition_Method')]"/>
	<xsl:variable name="infoReps" select="/node()/simple_instance[type=('Information_Representation')]"/>
	<xsl:variable name="apptoInfoReps" select="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION')]"/>
	<xsl:key name="apptoInfoReps" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION')]" use="name"/>
	<xsl:key name="infoReps" match="/node()/simple_instance[type=('Information_Representation')]" use="name"/>
	<xsl:variable name="infoServiceQuality" select="/node()/simple_instance[type=('Information_Service_Quality_Value')]"/>
	<xsl:key name="infoServiceQuality" match="/node()/simple_instance[type=('Information_Service_Quality_Value')]" use="name"/>
	<xsl:variable name="APUrelations" select="/node()/simple_instance[type=(':APU-TO-APU-STATIC-RELATION')]"/>

	<xsl:key name="appInformationEx" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]" use="name"/>
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
	 <xsl:variable name="thisInfo" select="key('appInformationEx', current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value)"/>
	  
	 <xsl:variable name="frequency" select="key('infoServiceQuality', $thisInfo/own_slot_value[slot_reference='atire_service_quals']/value)"/>
	 
	 <xsl:variable name="source" select="key('apus', current()/own_slot_value[slot_reference=':TO']/value)"/>
	 <xsl:variable name="target" select="key('apus', current()/own_slot_value[slot_reference=':FROM']/value)"/>
	 <xsl:variable name="sourceApp" select="key('applicationsall', $source/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
	 <xsl:variable name="targetApp" select="key('applicationsall',$target/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
	<xsl:variable name="acquire" select="$dataAquisition[name=$thisInfo/own_slot_value[slot_reference='atire_acquisition_method']/value]"/>
    { <xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'source': string(translate(translate($sourceApp/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
		'target': string(translate(translate($targetApp/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
	"sourceType":"<xsl:value-of select="$sourceApp/type"/>",
	"targetType":"<xsl:value-of select="$targetApp/type"/>",
	"info":[<xsl:if test="$sourceApp"><xsl:if test="$targetApp"><xsl:for-each select="$thisInfo"><!--<xsl:variable name="thisAppInfoRep" select="$apptoInfoReps[name=current()/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value]"/>
		<xsl:variable name="thisInfoRep" select="$infoReps[name=$thisAppInfoRep/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/> 
		-->
	<xsl:variable name="thisAppInfoRep" select="key('apptoInfoReps', current()/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)"/>
	<xsl:variable name="thisInfoRep" select="key('infoReps', $thisAppInfoRep/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value)"/> 	 
	 {
		<xsl:variable name="combinedMap" as="map(*)" select="map{ 
			'name': string(translate(translate($thisInfoRep/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
		  }"></xsl:variable>
		  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
		  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>, 
	<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each></xsl:if></xsl:if>],
	"frequency":[<xsl:for-each select="$frequency">{<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	<xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'acquisition': string(translate(translate($acquire[1]/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,  
	  <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>
	
</xsl:stylesheet>
