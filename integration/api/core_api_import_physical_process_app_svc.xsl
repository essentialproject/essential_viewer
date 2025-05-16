<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	<xsl:variable name="physicalProcess" select="/node()/simple_instance[type=('Physical_Process')]"/> 
	<xsl:variable name="a2r" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')][name=$physicalProcess/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:key name="a2rKey" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="name"/>
	<xsl:variable name="orgviaa2r" select="/node()/simple_instance[type=('Group_Actor')][name=$a2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:key name="orgKey" match="/node()/simple_instance[type=('Group_Actor')]" use="name"/>
	<xsl:variable name="orgdirect" select="/node()/simple_instance[type=('Group_Actor')][name=$physicalProcess/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="orgs" select="$orgdirect union $orgviaa2r"/>
	<xsl:variable name="businessProcess" select="/node()/simple_instance[type=('Business_Process')][name=$physicalProcess/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="aprpbr" select="/node()/simple_instance[type=('APP_PRO_TO_PHYS_BUS_RELATION')][name=$physicalProcess/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
	<xsl:key name="aprKey" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="name"/>
	<xsl:variable name="apr" select="key('aprKey',$aprpbr/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value)"/>
	<xsl:variable name="AppsViaService" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$apr/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="AppsDirect" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$aprpbr/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:key name="appsKey" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]" use="name"/>
	<xsl:variable name="criticality" select="/node()/simple_instance[type=('Business_Criticality')]"/>
	<xsl:key name="style" match="/node()/simple_instance[type=('Element_Style')]" use="name"/>
	<xsl:key name="busProcess_key" match="/node()/simple_instance[type=('Business_Process')]" use="own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value"/>
	<xsl:key name="appbr_key" match="/node()/simple_instance[type=('APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value"/>
	<xsl:key name="apr_key" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/>
	<xsl:key name="app_key" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'app_pro_supports_phys_proc']/value"/>
	<xsl:key name="site_key" match="/node()/simple_instance[type=('Site')]" use="name"/>
	<xsl:key name="location_key" match="/node()/simple_instance[type=('Geographic_Location','Geographic_Region')]" use="name"/>
	<xsl:key name="geo_key" match="/node()/simple_instance[type=('GeoCode')]" use="name"/>
	
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
	<xsl:variable name="thisAppsViaService" select="key('appsKey', $thisapr/own_slot_value[slot_reference = 'role_for_application_provider']/value)"/>
	<xsl:variable name="thisa2r" select="key('a2rKey', current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
	<xsl:variable name="thisorgviaa2r" select="key('orgKey', $thisa2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)"/>
	<xsl:variable name="thisorgdirect" select="key('orgKey',current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value)"/>
	<xsl:variable name="thisorgs" select="$thisorgdirect union $thisorgviaa2r"/>	
	<xsl:variable name="thisCriticality" select="$criticality[name=$thisbpr/own_slot_value[slot_reference = 'bpt_business_criticality']/value]"/>
	<xsl:variable name="thissites" select="key('site_key', current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value)"/>	
	<xsl:variable name="thisCriticalityStyle" select="key('style', $thisCriticality/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	{  
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'processName': string(translate(translate($thisbpr/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'processCriticality': string(translate(translate($thisCriticality/own_slot_value[slot_reference = 'enumeration_value']/value, '}', ')'), '{', ')')),
			'org': string(translate(translate($thisorgs/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,   
		"criticalityStyle":{"colour": "<xsl:value-of select="$thisCriticalityStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>", "backgroundColour":"<xsl:value-of select="$thisCriticalityStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>"},	
		"orgid":"<xsl:value-of select="eas:getSafeJSString($thisorgs/name)"/>",
		"orgUserId":["<xsl:value-of select="eas:getSafeJSString($thisorgs/name)"/>"], 
		"processid":"<xsl:value-of select="eas:getSafeJSString($thisbpr/name)"/>",
		"appProcessCriticalities":[<xsl:for-each select="$thisaprpbr">
		<xsl:variable name="thisCriticality" select="$criticality[name=current()/own_slot_value[slot_reference = 'app_to_process_business_criticality']/value]"/>
	 	<xsl:variable name="thisCriticalityStyle" select="key('style', $thisCriticality/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	
	 		{
				"appid":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference=('apppro_to_physbus_from_appprorole')]/value"><xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value)"/></xsl:when><xsl:otherwise><xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference=('apppro_to_physbus_from_apppro')]/value)"/></xsl:otherwise></xsl:choose>",
				"appCriticality": "<xsl:value-of select="$thisCriticality/own_slot_value[slot_reference = 'enumeration_value']/value"/>",
				"criticalityStyle":{"colour": "<xsl:value-of select="$thisCriticalityStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>", 
				"backgroundColour":"<xsl:value-of select="$thisCriticalityStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/>"}
				} <xsl:if test="position()!=last()">,</xsl:if>

	 	</xsl:for-each>],
		"sites":[<xsl:for-each select="$thissites">
			<xsl:variable name="thisloc" select="key('location_key', current()/own_slot_value[slot_reference = 'site_geographic_location']/value)"/>	
			<xsl:variable name="thisgeo" select="key('geo_key', $thisloc/own_slot_value[slot_reference = ('gl_geocode','gr_region_centrepoint')]/value)"/>	
			{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'long': string(translate(translate($thisgeo/own_slot_value[slot_reference = 'geocode_longitude']/value, '}', ')'), '{', ')')),
				'lat': string(translate(translate($thisgeo/own_slot_value[slot_reference = 'geocode_latitude']/value, '}', ')'), '{', ')'))
				}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>		
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"appsviaservice":[<xsl:for-each select="$thisapr">
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"svcid":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='implementing_application_service']/value)"/>",
		<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
		"appid":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='role_for_application_provider']/value)"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"appsdirect":[<xsl:for-each select="$thisAppsDirect">
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
</xsl:stylesheet>
