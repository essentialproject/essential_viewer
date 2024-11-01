<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
	<xsl:param name="viewScopeTermIds"/>
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
    <xsl:key name="allElements" match="node()/simple_instance[supertype='EA_Class']" use="name"/> 
    <xsl:key name="allPrinciplesKey" match="/node()/simple_instance[type = ('Business_Principle', 'Application_Architecture_Principle', 'Information_Architecture_Principle', 'Technology_Architecture_Principle', 'Security_Principle')]" use="type"/>
	<xsl:variable name="allPrinciples" select="key('allPrinciplesKey', ('Business_Principle', 'Application_Architecture_Principle', 'Information_Architecture_Principle', 'Technology_Architecture_Principle', 'Security_Principle'))"></xsl:variable>

    <xsl:key name="allPrinciplesAssessments" match="/node()/simple_instance[type = ('Business_Principle_Compliance_Assessment', 'Application_Principle_Compliance_Assessment', 'Information_Principle_Compliance_Assessment', 'Technology_Principle_Compliance_Assessment', 'Security_Principle_Compliance_Assessment')]" use="type"/>
	<xsl:variable name="allDirectPrinciplesAssessments" select="key('allPrinciplesAssessments', ('Business_Principle_Compliance_Assessment', 'Application_Principle_Compliance_Assessment', 'Information_Principle_Compliance_Assessment', 'Technology_Principle_Compliance_Assessment',  'Security_Principle_Compliance_Assessment'))"></xsl:variable>

    <xsl:key name="allAssessKey" match="$allDirectPrinciplesAssessments" use="own_slot_value[slot_reference = 'pca_principle_assessed']/value"/>
	<xsl:variable name="levels" select="/node()/simple_instance[type = 'Principle_Compliance_Level']" />
	<xsl:template match="knowledge_base">
		{
			"principles":[<xsl:apply-templates select="$allPrinciples" mode="principleRatings">
                    <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value" />
                </xsl:apply-templates>],
            "levels":[<xsl:apply-templates select="$levels" mode="style">
                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value" />
            </xsl:apply-templates>]    
		}
	</xsl:template>
    <xsl:template match="node()" mode="principleRatings">
		<xsl:variable name="thisDirectPrinciplesAssessments" select="key('allAssessKey', current()/name)" />
	    {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        "className":"<xsl:value-of select="current()/type"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
            'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')')),
            'principle_rationale': string(translate(translate(current()/own_slot_value[slot_reference = ('business_principle_rationale', 'application_principle_rationale','technology_principle_rationale','information_principle_rationale','security_principle_rationale')]/value,'}',')'),'{',')')),
            'information_implications':string-join(current()/own_slot_value[slot_reference = ('bus_principle_inf_implications','app_principle_inf_implications','inf_principle_inf_implications','tech_principle_inf_implications')]/value, ' | '),
            'technology_implications':string-join(current()/own_slot_value[slot_reference = ('bus_principle_tech_implications','app_principle_tech_implications','inf_principle_tech_implications','tech_principle_tech_implications')]/value, ' | '),
            'business_implications':string-join(current()/own_slot_value[slot_reference = ('app_principle_bus_implications','inf_principle_bus_implications','tech_principle_bus_implications')]/value, ' | '),
            'application_implications':string-join(current()/own_slot_value[slot_reference = ('bus_principle_app_implications','app_principle_app_implications','inf_principle_app_implications','tech_principle_app_implications')]/value, ' | ')
        }"/>
        <!-- business_implications -->
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
        <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
		"scores":[<xsl:apply-templates select="$thisDirectPrinciplesAssessments" mode="assessments" />],
        <xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="assessments">
		<xsl:variable name="thisassess" select="key('allElements', current()/own_slot_value[slot_reference='pca_element_assessed']/value)" />
        <xsl:variable name="thislevel" select="$levels[name=current()/own_slot_value[slot_reference='pca_compliance_assessment_value']/value]" />
		{ 
        "id":"<xsl:value-of select="eas:getSafeJSString($thisassess/name)"/>",
        "id2":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
        "thislevel":"<xsl:value-of select="eas:getSafeJSString($thislevel/name)"/>",
        "className":"<xsl:value-of select="$thisassess/type"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
            'assessment': string(translate(translate($thisassess/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
            'score': string(translate(translate($thislevel/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')')),
            'style': string(translate(translate($thislevel/name,'}',')'),'{',')')),
            'value': string(translate(translate($thislevel/own_slot_value[slot_reference = 'enumeration_value']/value,'}',')'),'{',')')) 
        }"/> 
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
        <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="$thisassess"/></xsl:call-template>
        } <xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
    <xsl:template match="node()" mode="style">
        {
            "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
            <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value,'}',')'),'{',')'))
            }"/> 
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
            <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')" />,
            "backgroundColour":"<xsl:value-of select="eas:get_element_style_colour(current())"/>",
            "colour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>"
        } <xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>

</xsl:stylesheet>
