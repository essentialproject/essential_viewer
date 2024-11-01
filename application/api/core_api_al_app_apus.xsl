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
	<!-- 03.09.2019 JP  Created	 -->
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[type=('Information_Representation')]"/>

	<xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="allAPUs" select="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
	<xsl:key name="allArchUsagesKey" match="/node()/simple_instance[type='Static_Application_Provider_Usage']" use="name"/>
	<xsl:key name="allSAKey" match="/node()/simple_instance[supertype='Application_Provider']" use="own_slot_value[slot_reference='ap_static_architecture']/value"/>
	<xsl:key name="allAppsforSAKey" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]" use="name"/>
	<xsl:key name="allAppProtoInfoKey" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION','APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]" use="name"/>
	<xsl:key name="allInfoRepKey" match="/node()/simple_instance[type=('Information_Representation')]" use="name"/>
	
    <xsl:variable name="allAppProtoInfo" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION'][name=$allAPUs/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
    <xsl:variable name="allInfo" select="/node()/simple_instance[type='Information_Representation'][name=$allAppProtoInfo/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>

     
	<xsl:template match="knowledge_base">
		{
			"apus": [<xsl:apply-templates select="$allAPUs" mode="allAPUs"/>]
        }
		
	</xsl:template>
	

	<xsl:template match="node()" mode="allAPUs">
		<xsl:variable name="thisFrom" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':FROM']/value)"/>
		<xsl:variable name="thisTo" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':TO']/value)"/>
		<xsl:variable name="fromApp" select="key('allAppsforSAKey', $thisFrom/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
		<xsl:variable name="toApp" select="key('allAppsforSAKey', $thisTo/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
		<xsl:variable name="edgeInfo" select="key('allAppProtoInfoKey', current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value)"/>
		<xsl:variable name="edgeInfoIndirect" select="key('allAppProtoInfoKey', $edgeInfo/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)"/>
		<xsl:variable name="allInfoEdges" select="$edgeInfo union $edgeInfoIndirect"/>
		<xsl:variable name="thisInfoReps" select="key('allInfoRepKey', $allInfoEdges/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value)"/>
		
	{
	"id":"<xsl:value-of select="current()/name"/>",
	<xsl:variable name="temp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = (':relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
	<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
	<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,

	"fromtype":"<xsl:value-of select="$fromApp/type"/>",
	"totype":"<xsl:value-of select="$toApp/type"/>",
	"edgeName":"<xsl:value-of select="$fromApp/name"/> to <xsl:value-of select="$toApp/name"/>",
	"fromAppId":"<xsl:value-of select="$fromApp/name"/>",
	"toAppId":"<xsl:value-of select="$toApp/name"/>",
	<xsl:variable name="ftemp" as="map(*)" select="map{'fromApp': string(translate(translate($fromApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
	<xsl:variable name="fresult" select="serialize($ftemp, map{'method':'json', 'indent':true()})"/>  
	<xsl:value-of select="substring-before(substring-after($fresult,'{'),'}')"></xsl:value-of>,
	<xsl:variable name="ttemp" as="map(*)" select="map{'toApp': string(translate(translate($toApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
	<xsl:variable name="tresult" select="serialize($ttemp, map{'method':'json', 'indent':true()})"/>  
	<xsl:value-of select="substring-before(substring-after($tresult,'{'),'}')"></xsl:value-of>,
	"info":[<xsl:for-each select="$thisInfoReps">
		{
			"id":"<xsl:value-of select="current()/name"/>",
			"type":"<xsl:value-of select="current()/type"/>",
			<xsl:variable name="infoTemp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
			<xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
			<xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>]
	}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
