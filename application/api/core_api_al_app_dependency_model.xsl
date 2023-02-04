<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
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
	<!-- 25.07.2019 JP  Created	 -->

	
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')]"/>
	<xsl:variable name="allBusApps" select="$allApps[type = ('Application_Provider', 'Composite_Application_Provider',  'Application_Provider_Interface')]"/>
	<xsl:variable name="allInterfaces" select="$allApps[type = 'Application_Provider_Interface']"/>
	<xsl:variable name="topApp" select="$allApps[name = $param1]"/>
	<xsl:variable name="subApps" select="$allApps[name = $topApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
	<xsl:variable name="subSubApps" select="$allApps[name = $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
<!-- original	<xsl:variable name="currentApp" select="$topApp union $subApps union $subSubApps"/> -->
	<xsl:variable name="currentApp" select="$topApp"/>
	
	<!-- Get all Data Sets needed to minimise having to traverse the whole document -->
	<xsl:variable name="allApp2InfoReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
	<xsl:variable name="allAcquisitionMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[type = 'Information_Representation']"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[type = 'Information_View']"/>
	<xsl:variable name="allDataObjs" select="/node()/simple_instance[type = 'Data_Object']"/>
	<xsl:variable name="allAppDependencies" select="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']"/>
	<xsl:variable name="allAppDepInfoExchanged" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_EXCHANGE_RELATION']"/>
	<xsl:variable name="allAppDeps" select="$allApp2InfoReps union $allAppDepInfoExchanged"/>
	<xsl:key name="appDepKey" match="$allAppDeps" use="own_slot_value[slot_reference = 'used_in_app_dependencies']/value"/>
	<xsl:key name="apexKey" match="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_EXCHANGE_RELATION']" use="own_slot_value[slot_reference = 'used_in_app_dependencies']/value"/>
	<xsl:key name="apinfKey" match="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']" use="own_slot_value[slot_reference = 'used_in_app_dependencies']/value"/>
	<xsl:variable name="allAppUsages" select="/node()/simple_instance[type = 'Static_Application_Provider_Usage']"/>
	<xsl:variable name="allServiceQuals" select="/node()/simple_instance[supertype = 'Service_Quality' or type = 'Service_Quality']"/>
	<xsl:variable name="allServiceQualVals" select="/node()/simple_instance[type = 'Information_Service_Quality_Value']"/>
	<xsl:variable name="timelinessQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Timeliness')]"/>
	<xsl:variable name="granularityQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Granularity')]"/>
	<xsl:variable name="completenessQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Completeness')]"/>
	<xsl:variable name="allDataAcquisitionMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="allDataAcquisitionStyles" select="/node()/simple_instance[name = $allDataAcquisitionMethods/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	
	<xsl:key name="usageKey" match="$allAppUsages" use="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
	<xsl:key name="fromKey" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':FROM']/value"/>
	<xsl:key name="toKey" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':TO']/value"/>

	
	<xsl:variable name="currentAppUsages" select="key('usageKey', $currentApp/name)"/> 
	<xsl:variable name="inboundDependenciespre" select="key('fromKey',$currentAppUsages/name)"/>

	<xsl:variable name="inboundDependencies" select="$inboundDependenciespre[not(own_slot_value[slot_reference = ':TO']/value = $currentAppUsages/name)]"/>
	<xsl:key name="inboundDependenciesKey" match="$inboundDependencies" use="own_slot_value[slot_reference = ':TO']/value"/>

	<!--
	<xsl:variable name="currentAppUsages" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $currentApp/name]"/>


	<xsl:variable name="inboundDependencies" select="$allAppDependencies[(own_slot_value[slot_reference = ':FROM']/value = $currentAppUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $currentAppUsages/name)]"/>-->
	<xsl:variable name="allInboundAppUsages" select="$allAppUsages[name = $inboundDependencies/own_slot_value[slot_reference = ':TO']/value]"/>

	<xsl:key name="inboundkey" match="$allInboundAppUsages" use="own_slot_value[slot_reference = 'static_usage_of_app_provider']/value"/>
	<xsl:variable name="inboundInterfaceUsages" select="key('inboundkey', $allInterfaces/name)"/>
<!--	<xsl:variable name="inboundInterfaceUsages" select="$allInboundAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $allInterfaces/name]"/> -->
	<xsl:variable name="inboundAppUsages"  select="$allInboundAppUsages except $inboundInterfaceUsages"/>

	<xsl:variable name="inboundApps" select="$allApps[name = $inboundAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	<xsl:variable name="inboundInterfaces" select="$allApps[name = $inboundInterfaceUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>

	<xsl:key name="fromInfaceKey" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':FROM']/value"/>

	<xsl:variable name="inboundInterfaceSourceDepspre" select="key('fromInfaceKey',$inboundInterfaceUsages/name)"/>
	<xsl:variable name="inboundInterfaceSourceDeps" select="$inboundInterfaceSourceDepspre[not(own_slot_value[slot_reference = ':TO']/value = $inboundInterfaceUsages/name)]"/>

	<xsl:key name="inboundInterfaceSourceDepsKey" match="$inboundInterfaceSourceDeps" use="own_slot_value[slot_reference = ':FROM']/value"/>


<!--	<xsl:variable name="inboundInterfaceSourceDeps" select="$allAppDependencies[(own_slot_value[slot_reference = ':FROM']/value = $inboundInterfaceUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $inboundInterfaceUsages/name)]"/> -->
	<xsl:variable name="inboundInterfaceSourceAppUsages" select="$allAppUsages[name = $inboundInterfaceSourceDeps/own_slot_value[slot_reference = ':TO']/value]"/>
	<xsl:variable name="inboundInterfaceSourceApps" select="$allBusApps[name = $inboundInterfaceSourceAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>

	<xsl:key name="outInfaceKey" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':TO']/value"/>

	<xsl:variable name="outboundDependenciespre" select="key('outInfaceKey',$currentAppUsages/name)"/>
	<xsl:variable name="outboundDependencies" select="$outboundDependenciespre"/>
	<xsl:key name="outboundDependenciesKey" match="$outboundDependencies" use="own_slot_value[slot_reference = ':FROM']/value"/>


	<!--<xsl:variable name="outboundDependencies" select="$allAppDependencies[(own_slot_value[slot_reference = ':TO']/value = $currentAppUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $currentAppUsages/name)]"/> -->
	<xsl:variable name="allOutboundAppUsages" select="$allAppUsages[name = $outboundDependencies/own_slot_value[slot_reference = ':FROM']/value]"/>

	<xsl:variable name="outboundInterfaceUsages" select="$allOutboundAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $allInterfaces/name]"/>
	<xsl:variable name="outboundAppUsages"  select="$allOutboundAppUsages except $outboundInterfaceUsages"/>
	
	<xsl:variable name="outboundInterfaces" select="$allApps[name = $outboundInterfaceUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	<xsl:variable name="outboundApps" select="$allApps[name = $outboundAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	
	<xsl:key name="outTargetInfaceKey" match="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference = ':TO']/value"/>

	<xsl:variable name="outboundInterfaceTargetDepspre" select="key('outTargetInfaceKey',$outboundInterfaceUsages/name)"/>
	<xsl:variable name="outboundInterfaceTargetDeps" select="$outboundInterfaceTargetDepspre[not(own_slot_value[slot_reference = ':TO']/value = $inboundInterfaceUsages/name)]"/>
<!--
	<xsl:variable name="outboundInterfaceTargetDeps" select="$allAppDependencies[(own_slot_value[slot_reference = ':TO']/value = $outboundInterfaceUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $inboundInterfaceUsages/name)]"/>  -->
	<xsl:variable name="outboundInterfaceTargetAppUsages" select="$allAppUsages[name = $outboundInterfaceTargetDeps/own_slot_value[slot_reference = ':FROM']/value]"/>
	<xsl:variable name="outboundInterfaceTargetApps" select="$allBusApps[name = $outboundInterfaceTargetAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	
 
	<xsl:template match="knowledge_base">
		<xsl:variable name="inDirect" select="key('inboundDependenciesKey',$inboundAppUsages/name)"/>
		<xsl:variable name="inApi" select="key('inboundDependenciesKey',$inboundInterfaceUsages/name)"/>
		<xsl:variable name="outDirect" select="key('outboundDependenciesKey',$outboundAppUsages/name)"/>
		<xsl:variable name="outApi" select="key('outboundDependenciesKey',$outboundInterfaceUsages/name)"/>
		{
			"id": "<xsl:value-of select="$topApp/name"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$topApp"/></xsl:call-template>",
			"lifecycleStatus":"<xsl:value-of select="$topApp/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>",
			"className": "<xsl:value-of select="$topApp/type"/>",
			"dependencies": {
				"receivesFrom": [
				<!--<xsl:apply-templates mode="RenderDirectInboundJSON" select="key('toKey', $inboundAppUsages/name)"/>-->
					<xsl:apply-templates mode="RenderDirectInboundJSON" select="$inDirect"/>
				],
				"sendsTo": [
				<!--<xsl:apply-templates mode="RenderDirectInboundJSON" select="key('fromKey', $outboundAppUsages/name)"/>-->
					<xsl:apply-templates mode="RenderDirectOutboundJSON" select="$outDirect"/> 
				],
				"fromInterfaces": [
				<!--<xsl:apply-templates mode="RenderDirectInboundJSON" select="key('toKey', $inboundInterfaceUsages/name)"/>-->
					<xsl:apply-templates mode="RenderInboundInterfaceJSON" select="$inApi"/>
				],
				"toInterfaces": [
				<!--<xsl:apply-templates mode="RenderDirectInboundJSON" select="key('fromKey', $outboundInterfaceUsages/name)"/>-->
				<xsl:apply-templates mode="RenderOutboundInterfaceJSON" select="$outApi"/>
				]
			},
			"allAcqMethods": [
				<xsl:apply-templates mode="RenderEnumJSON" select="$allAcquisitionMethods"/>
			],
			"allSVCQualVals": [
				<xsl:apply-templates mode="RenderServiceQualValJSON" select="$allServiceQualVals"/>
			]
		}
	</xsl:template>
	<xsl:template match="node()" mode="RenderDirectInboundJSONTest">  
			 
			<xsl:variable name="thisInboundAppUsage" select="$inboundDependencies[own_slot_value[slot_reference = ':TO']/value=current()/name]"/>
			<xsl:variable name="thisInboundApp" select="$inboundApps[name = current()/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		{"id": "<xsl:value-of select="current()/name"/>",
		"thisInboundAppUsage": "<xsl:value-of select="$thisInboundAppUsage/name"/>",
		"thisInboundApp": "<xsl:value-of select="$thisInboundApp/name"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
</xsl:template>
	
	<xsl:template match="node()" mode="RenderDirectInboundJSON">
		<xsl:variable name="thisDep" select="current()"/>
		
		<xsl:variable name="thisInboundAppUsage" select="$inboundAppUsages[name = $thisDep/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="thisInboundApp" select="$inboundApps[name = $thisInboundAppUsage/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		

		{
		"id": "<xsl:value-of select="$thisInboundApp/name"/>",
		"lifecycleStatus":["<xsl:value-of select="$thisInboundApp/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>"],
		"className": "<xsl:value-of select="$thisInboundApp/type"/>",
		<xsl:call-template name="RenderDepInfoJSON">
			<xsl:with-param name="thisDep" select="$thisDep"/>
			<xsl:with-param name="thisAcqMethodId" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"></xsl:with-param>
		</xsl:call-template>
		"usageId": "<xsl:value-of select="$thisInboundAppUsage/name"/>",
		"acqMethodId": "<xsl:value-of select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"/>",
		"svcQualValIds": [<xsl:for-each select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInboundApp"/></xsl:call-template>",
		"dependencyId": "<xsl:value-of select="$thisDep/name"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderInboundInterfaceSourceJSON">
		<xsl:variable name="thisDep" select="current()"/>
		
		<xsl:variable name="thisInboundInterfaceSourceAppUsage" select="$inboundInterfaceSourceAppUsages[name = $thisDep/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="thisInboundInterfaceSourceApp" select="$inboundInterfaceSourceApps[name = $thisInboundInterfaceSourceAppUsage/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		
		{
		"id": "<xsl:value-of select="$thisInboundInterfaceSourceApp/name"/>",
		"lifecycleStatus":["<xsl:value-of select="$thisInboundInterfaceSourceApp/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>"],
		"className": "<xsl:value-of select="$thisInboundInterfaceSourceApp/type"/>",
		<xsl:call-template name="RenderDepInfoJSON">
			<xsl:with-param name="thisDep" select="$thisDep"/>
			<xsl:with-param name="thisAcqMethodId" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"></xsl:with-param>
		</xsl:call-template>
		"usageId": "<xsl:value-of select="$thisInboundInterfaceSourceAppUsage/name"/>",
		"acqMethodId": "<xsl:value-of select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"/>",
		"svcQualValIds": [<xsl:for-each select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInboundInterfaceSourceApp"/></xsl:call-template>",
		"dependencyId": "<xsl:value-of select="$thisDep/name"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderInboundInterfaceJSON">
		<xsl:variable name="thisDep" select="current()"/>
		
		<xsl:variable name="thisInboundInterfaceUsage" select="$inboundInterfaceUsages[name = $thisDep/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="thisInboundInterface" select="$inboundInterfaces[name = $thisInboundInterfaceUsage/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		<xsl:variable name="thisInboundInterfaceSourceDepsA" select="$inboundInterfaceSourceDeps[own_slot_value[slot_reference = ':FROM']/value = $thisInboundInterfaceUsage/name]"/>
		<xsl:variable name="thisInboundInterfaceSourceDeps" select="key('inboundInterfaceSourceDepsKey',$thisInboundInterfaceUsage/name)"/>
		
		
		{
		"id": "<xsl:value-of select="$thisInboundInterface/name"/>",
		"lifecycleStatus":["<xsl:value-of select="$thisInboundInterface/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>"],
		"className": "<xsl:value-of select="$thisInboundInterface/type"/>",
		<xsl:call-template name="RenderDepInfoJSON">
			<xsl:with-param name="thisDep" select="$thisDep"/>
			<xsl:with-param name="thisAcqMethodId" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"></xsl:with-param>
		</xsl:call-template>
		"usageId": "<xsl:value-of select="$thisInboundInterfaceUsage/name"/>",
		"acqMethodId": "<xsl:value-of select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"/>",
		"svcQualValIds": [<xsl:for-each select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInboundInterface"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInboundInterface"/></xsl:call-template>",
		"dependencyId": "<xsl:value-of select="$thisDep/name"/>",
		"receivesFrom": [
			<xsl:apply-templates mode="RenderInboundInterfaceSourceJSON" select="$thisInboundInterfaceSourceDeps"/>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderDirectOutboundJSON">
		<xsl:variable name="thisDep" select="current()"/>
		
		<xsl:variable name="thisOutboundAppUsage" select="$outboundAppUsages[name = $thisDep/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="thisOutboundApp" select="$outboundApps[name = $thisOutboundAppUsage/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		
		{
		"id": "<xsl:value-of select="$thisOutboundApp/name"/>",
		"lifecycleStatus":["<xsl:value-of select="$thisOutboundApp/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>"],
		"className": "<xsl:value-of select="$thisOutboundApp/type"/>",
		<xsl:call-template name="RenderDepInfoJSON">
			<xsl:with-param name="thisDep" select="$thisDep"/>
			<xsl:with-param name="thisAcqMethodId" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"></xsl:with-param>
			<xsl:with-param name="thisSVCQualIds" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value"></xsl:with-param>
		</xsl:call-template>
		"usageId": "<xsl:value-of select="$thisOutboundAppUsage/name"/>",
		"acqMethodId": "<xsl:value-of select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"/>",
		"svcQualValIds": [<xsl:for-each select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisOutboundApp"/></xsl:call-template>",
		"dependencyId": "<xsl:value-of select="$thisDep/name"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderOutboundInterfaceTargetJSON">
		<xsl:variable name="thisDep" select="current()"/>
		
		<xsl:variable name="thisOutboundInterfaceTargetAppUsage" select="$outboundInterfaceTargetAppUsages[name = $thisDep/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="thisOutboundInterfaceTargetApp" select="$outboundInterfaceTargetApps[name = $thisOutboundInterfaceTargetAppUsage/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		
		{
		"id": "<xsl:value-of select="$thisOutboundInterfaceTargetApp/name"/>",
		"lifecycleStatus":["<xsl:value-of select="$thisOutboundInterfaceTargetApp/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>"],
		"className": "<xsl:value-of select="$thisOutboundInterfaceTargetApp/type"/>",
		<xsl:call-template name="RenderDepInfoJSON">
			<xsl:with-param name="thisDep" select="$thisDep"/>
			<xsl:with-param name="thisAcqMethodId" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"></xsl:with-param>
			<xsl:with-param name="thisSVCQualIds" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value"></xsl:with-param>
		</xsl:call-template>
		"usageId": "<xsl:value-of select="$thisOutboundInterfaceTargetAppUsage/name"/>",
		"acqMethodId": "<xsl:value-of select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"/>",
		"svcQualValIds": [<xsl:for-each select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisOutboundInterfaceTargetApp"/></xsl:call-template>",
		"dependencyId": "<xsl:value-of select="$thisDep/name"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderOutboundInterfaceJSON">
		<xsl:variable name="thisDep" select="current()"/>
		
		<xsl:variable name="thisOutboundInterfaceUsage" select="$outboundInterfaceUsages[name = $thisDep/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="thisOutboundInterface" select="$outboundInterfaces[name = $thisOutboundInterfaceUsage/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	<!--	<xsl:variable name="thisOutboundInterfaceTargetDeps" select="$outboundInterfaceTargetDeps[own_slot_value[slot_reference = ':TO']/value = $thisOutboundInterfaceUsage/name]"/>	-->
		<xsl:variable name="thisOutboundInterfaceTargetDeps" select="key('outTargetInfaceKey',$thisOutboundInterfaceUsage/name)"/>
		{
		"id": "<xsl:value-of select="$thisOutboundInterface/name"/>",
		"lifecycleStatus":["<xsl:value-of select="$thisOutboundInterface/own_slot_value[slot_reference='lifecycle_status_application_provider']/value"/>"],
		"className": "<xsl:value-of select="$thisOutboundInterface/type"/>",
		<xsl:call-template name="RenderDepInfoJSON">
			<xsl:with-param name="thisDep" select="$thisDep"/>
			<xsl:with-param name="thisAcqMethodId" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value"></xsl:with-param>
			<xsl:with-param name="thisSVCQualIds" select="$thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_service_quals']/value"></xsl:with-param>
		</xsl:call-template>
		"usageId": "<xsl:value-of select="$thisOutboundInterfaceUsage/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisOutboundInterface"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisOutboundInterface"/></xsl:call-template>",
		"dependencyId": "<xsl:value-of select="$thisDep/name"/>",
		"sendsTo": [
			<xsl:apply-templates mode="RenderOutboundInterfaceTargetJSON" select="$thisOutboundInterfaceTargetDeps"/>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>


	<xsl:template name="RenderDepInfoJSON">
		<xsl:param name="thisDep" select="()"/>
		<xsl:param name="thisAcqMethodId"/>
		<xsl:param name="thisSVCQualIds"/>
		
		<xsl:variable name="thisApp2InfoRepXs" select="key('apexKey',$thisDep/name)"/>
		<xsl:variable name="directApp2InfoRepsA" select="key('apinfKey',$thisDep/name)"/>
		
	<!--	<xsl:variable name="thisApp2InfoRepXs" select="$allAppDepInfoExchanged[name = $thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>-->
		<xsl:variable name="directApp2InfoReps2" select="$allApp2InfoReps[name = $thisDep/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>	
		<xsl:variable name="directApp2InfoReps" select="key('appDepKey', $thisDep/name)"/>
		
		<xsl:variable name="indirectApp2InfoReps" select="$allApp2InfoReps[name = $directApp2InfoReps/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
		<xsl:variable name="thisApp2InfoReps" select="$directApp2InfoReps"/>
		<xsl:variable name="thisInfoReps" select="/node()/simple_instance[name = $directApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/> 
		<xsl:variable name="thisInfoViews" select="$allInfoViews[name = $thisInfoReps/own_slot_value[slot_reference = 'implements_information_views']/value]"/>
		

		<xsl:variable name="infoViewCount" select="count($thisInfoViews)"/>
		<xsl:variable name="infoRepCount" select="count($thisInfoReps)"/>
		<xsl:variable name="hasInfo" select="($infoViewCount + $infoRepCount) > 0"/>
	
		"hasInfo": <xsl:choose><xsl:when test="$hasInfo">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
		<xsl:choose>
			<xsl:when test="$infoViewCount > 0">
				"infoViews": [
				<xsl:apply-templates mode="RenderInfoViewJSON" select="$thisInfoViews">
					<xsl:with-param name="thisAcqMethodId" select="$thisAcqMethodId"/>
					<xsl:with-param name="thisSVCQualIds" select="$thisSVCQualIds"/>
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
				],
			</xsl:when>
		</xsl:choose>
		"infoReps": [
		 
			<xsl:if test="count($thisApp2InfoRepXs) > 0">
				
				<xsl:apply-templates mode="RenderInfoRepXJSON" select="$thisApp2InfoRepXs">
					<xsl:with-param name="depAcqMethodId" select="$thisAcqMethodId"/>
					<xsl:with-param name="thisSVCQualIds" select="$thisSVCQualIds"/>
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
				
			</xsl:if>
			<xsl:if test="$infoRepCount > 0">
				<xsl:if test="count($thisApp2InfoRepXs) > 0">,</xsl:if>
				<xsl:apply-templates mode="RenderInfoRepJSON" select="$thisInfoReps">
					<xsl:with-param name="thisAcqMethodId" select="$thisAcqMethodId"/>
					<xsl:with-param name="thisSVCQualIds" select="$thisSVCQualIds"/>
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>	
			</xsl:if>
			],
			
	</xsl:template>

	<xsl:template match="node()" mode="RenderInfoViewJSON">
		<xsl:param name="thisAcqMethodId"/>
		<xsl:param name="thisSVCQualIds"/>
		<xsl:variable name="thisInfo" select="current()"/>
		<xsl:variable name="thisDataObjs" select="$allDataObjs[name = $thisInfo/own_slot_value[slot_reference = 'info_view_supporting_data_objects']/value]"/>
		<xsl:variable name="hasData" select="count($thisDataObjs) > 0"/>
		<xsl:variable name="instanceName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template></xsl:variable>

		{
		"id": "<xsl:value-of select="$thisInfo/name"/>",
		"className": "<xsl:value-of select="$thisInfo/type"/>",
		<!-- "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>", -->
		"name": "<xsl:choose><xsl:when test="$instanceName=''"><xsl:value-of select="$thisInfo/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$instanceName"/></xsl:otherwise></xsl:choose>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>",
		"acqMethodId": "<xsl:value-of select="$thisAcqMethodId"/>",
		"svcQualValIds": [<xsl:for-each select="$thisSVCQualIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"hasData": <xsl:choose><xsl:when test="$hasData">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
			"dataObjects": [
				<xsl:apply-templates mode="RenderDataObjJSON" select="$thisDataObjs">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			] 
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderInfoRepXJSON">
		<xsl:param name="depAcqMethodId"/>
		<xsl:param name="thisSVCQualIds"/>
		
		<xsl:variable name="this" select="current()"/>	
		
		<xsl:variable name="myAcqMethod" select="$this/own_slot_value[slot_reference = 'atire_acquisition_method']/value"/>
		<xsl:variable name="thisAcqMethodId">
			<xsl:choose>
				<xsl:when test="string-length($myAcqMethod) > 0">
					<xsl:value-of select="$myAcqMethod"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$depAcqMethodId"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="mySVCQualIds" select="$this/own_slot_value[slot_reference = 'atire_service_quals']/value"/>
		
		<xsl:variable name="thisApp2InfoRep" select="$allApp2InfoReps[name = $this/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
		<xsl:variable name="thisInfo" select="$allInfoReps[name = $thisApp2InfoRep/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
		<xsl:variable name="thisInfoReps" select="$allInfoReps[name = current()/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/> 
		<xsl:variable name="thisInfoViews" select="$allInfoViews[name = $thisInfo/own_slot_value[slot_reference = 'implements_information_views']/value]"/>
		{
		"id": "<xsl:value-of select="$thisInfo/name"/>",
		"className": "<xsl:value-of select="$thisInfo/type"/>",
		<!-- "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>", -->
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>",
		"acqMethodId": "<xsl:value-of select="$thisAcqMethodId"/>",
		<xsl:choose>
			<xsl:when test="count($mySVCQualIds) > 0">
				"svcQualValIds": [<xsl:for-each select="$mySVCQualIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
			</xsl:when>
			<xsl:otherwise>
				"svcQualValIds": [<xsl:for-each select="$thisSVCQualIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
			</xsl:otherwise>
		</xsl:choose>
		"hasData": false,
		"dataObjects": [
				<xsl:apply-templates mode="RenderInfoViewJSON" select="$thisInfoViews">
					<xsl:with-param name="thisAcqMethodId" select="$thisAcqMethodId"/>
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
				]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderInfoRepJSON">
		<xsl:param name="thisAcqMethodId"/>
		<xsl:param name="thisSVCQualIds"/>
		
		<xsl:variable name="thisInfo" select="current()"/>
		
		{
		"id": "<xsl:value-of select="$thisInfo/name"/>",
		"className": "<xsl:value-of select="$thisInfo/type"/>",
		"infRep":"Yes",
		<!-- "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>", -->
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>",
		"acqMethodId": "<xsl:value-of select="$thisAcqMethodId"/>",
		"svcQualValIds": [<xsl:for-each select="$thisSVCQualIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"hasData": false
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="RenderDataObjJSON">
		<xsl:variable name="thisDataObj" select="current()"/>
		
		{
		"id": "<xsl:value-of select="$thisDataObj/name"/>",
		"className": "<xsl:value-of select="$thisDataObj/type"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisDataObj"/></xsl:call-template>",
		"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisDataObj"/></xsl:call-template>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="RenderEnumJSON">
		<xsl:variable name="this" select="current()"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"label": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'enumeration_value']/value"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderServiceQualValJSON">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thsServiceQual" select="$allServiceQuals[name = $this/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
		
		{
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
		"valLabel": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>",
		"sqLabel": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thsServiceQual"/></xsl:call-template>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
