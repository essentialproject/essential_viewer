<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:map="http://www.w3.org/2005/xpath-functions/map">
    
	<xsl:import href="../common/core_js_functions.xsl"/>  


	<!-- START GENERIC PARAMETERS -->

	<!-- END GENERIC PARAMETERS -->
	 <xsl:key name="appSecurityProfile" match="/node()/simple_instance[type='Application_Provider_Security_Profile']" use="type"/>
	 <xsl:key name="appSecurityEnumerations" match="/node()/simple_instance[supertype=('Enumeration')]" use="name"/>
	 <xsl:key name="appStyles" match="/node()/simple_instance[type=('Element_Style')]" use="name"/>
	   <xsl:variable name="isAuthzForClasses" select="eas:isUserAuthZClasses(('Security_Profile','Application_Provider_Security_Profile'))"/> 
  	<xsl:variable name="isAuthzForInstances" select="eas:isUserAuthZInstances(key('appSecurityProfile', 'Application_Provider_Security_Profile'))"/>
   
	
	 <!--
		* Copyright © 2008-2025 Enterprise Architecture Solutions Limited.
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
  
	<xsl:template name="ciaData">
		 
			let securityProfile = [
				<xsl:apply-templates select="key('appSecurityProfile', 'Application_Provider_Security_Profile')" mode="securityData"/>
			];

	 
	
	</xsl:template>
	<xsl:template match="node()" mode="securityData">
	<xsl:variable name="spar" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_availability_rating']/value)"/>
	<xsl:variable name="spcr" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_confidentiality_rating']/value)"/>
	<xsl:variable name="spir" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_integrity_rating']/value)"/>
	<xsl:variable name="spari" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_availability_risk_impact']/value)"/>
	<xsl:variable name="spcri" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_confidentiality_risk_impact']/value)"/>
	<xsl:variable name="spiri" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_integrity_risk_impact']/value)"/>
	<xsl:variable name="rbac" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_rbac_usage']/value)"/>
	<xsl:variable name="mfa" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_mfa_usage']/value)"/>
	<xsl:variable name="sso" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_sso_usage']/value)"/>
	<xsl:variable name="authentication" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_authentication_methods']/value)"/>
	
	
	<xsl:variable name="frequency" select="key('appSecurityEnumerations', current()/own_slot_value[slot_reference = 'sec_profile_user_access_review_frequency']/value)"/>
	<xsl:variable name="appStyle" select="key('appStyles', $spar/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="spcrStyle" select="key('appStyles', $spcr/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="spirStyle" select="key('appStyles', $spir/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="spariStyle" select="key('appStyles', $spari/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="spcriStyle" select="key('appStyles', $spcri/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="spiriStyle" select="key('appStyles', $spiri/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="rbacStyle" select="key('appStyles', $rbac/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="mfaStyle" select="key('appStyles', $mfa/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="ssoStyle" select="key('appStyles', $sso/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>
	<xsl:variable name="frequencyStyle" select="key('appStyles', $frequency/own_slot_value[slot_reference = 'element_styling_classes']/value)"/>

	
		{<xsl:choose>
			<xsl:when test="not($isAuthzForClasses) or not($isAuthzForInstances)"></xsl:when> 
			<xsl:otherwise> 
	
			"id": "<xsl:value-of select="current()/name"></xsl:value-of>", 
			"sec_profile_of_element": "<xsl:value-of select="current()/own_slot_value[slot_reference='sec_profile_of_element']/value"></xsl:value-of>", 
			<xsl:variable name="combinedMap" as="map(*)" select="map{
				'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_availability_rating': string(translate(translate($spar/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				
				'sec_profile_confidentiality_rating': string(translate(translate($spcr/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_integrity_rating': string(translate(translate($spir/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_availability_risk_impact': string(translate(translate($spari/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_confidentiality_risk_impact': string(translate(translate($spcri/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_integrity_risk_impact': string(translate(translate($spiri/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_rbac_usage': string(translate(translate($rbac/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_is_internal_facing': string(translate(translate(current()/own_slot_value[slot_reference = 'sec_profile_is_internal_facing']/value, '}', ')'), '{', ')')),
				'sec_profile_is_external_facing': string(translate(translate(current()/own_slot_value[slot_reference = 'sec_profile_is_external_facing']/value, '}', ')'), '{', ')')),
				'sec_profile_mfa_usage': string(translate(translate($mfa/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_sso_usage': string(translate(translate($sso/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_user_access_review_frequency': string(translate(translate($frequency/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
				'sec_profile_is_data_encrypted_at_rest': string(translate(translate(current()/own_slot_value[slot_reference = 'sec_profile_is_data_encrypted_at_rest']/value, '}', ')'), '{', ')'))
				}"/>
			<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
			<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
			"authentication_methods": [<xsl:for-each select="$authentication">
				{
					"id": "<xsl:value-of select="current()/name"></xsl:value-of>", 
					<xsl:variable name="combinedMap" as="map(*)" select="map{
						'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
						}"/>
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
				}<xsl:if test="position() != last()">,</xsl:if>
			</xsl:for-each>],
			"sec_profile_availability_rating_style": {"backgroundColour":"<xsl:value-of select="$appStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$appStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_confidentiality_rating_style": {"backgroundColour":"<xsl:value-of select="$spcrStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$spcrStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_integrity_rating_style": {"backgroundColour":"<xsl:value-of select="$spirStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$spirStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_availability_risk_impact_style": {"backgroundColour":"<xsl:value-of select="$spariStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$spariStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_confidentiality_risk_impact_style": {"backgroundColour":"<xsl:value-of select="$spcriStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$spcriStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_integrity_risk_impact_style": {"backgroundColour":"<xsl:value-of select="$spiriStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$spiriStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_rbac_usage_style": {"backgroundColour":"<xsl:value-of select="$rbacStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$rbacStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_mfa_usage_style": {"backgroundColour":"<xsl:value-of select="$mfaStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$mfaStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_sso_usage_style": {"backgroundColour":"<xsl:value-of select="$ssoStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$ssoStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"},
			"sec_profile_user_access_review_frequency_style": {"backgroundColour":"<xsl:value-of select="$frequencyStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>","colour":"<xsl:value-of select="$frequencyStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>"}
			</xsl:otherwise>
		</xsl:choose>
		
			}

		<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>


</xsl:stylesheet>
