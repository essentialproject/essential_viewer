<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	
	<xsl:variable name="issues" select="/node()/simple_instance[type='Issue']"/>
	<xsl:variable name="issue_cats" select="/node()/simple_instance[type='Issue_Category']"/>
	<xsl:variable name="orgsScope" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')][name=$issues/own_slot_value[slot_reference='sr_org_scope']/value]"/>
	<xsl:variable name="orgsSource" select="/node()/simple_instance[type=('Group_Actor','Individual_Actor')][name=$issues/own_slot_value[slot_reference='issue_source']/value]"/>
	<xsl:variable name="orgs" select="$orgsScope union $orgsSource"/>
	<xsl:variable name="status" select="/node()/simple_instance[type='Requirement_Status']"/>
    <xsl:variable name="stratReq" select="/node()/simple_instance[type='Strategic_Requirement_Type']"/>
	<xsl:variable name="geoScoping" select="/node()/simple_instance[type='Geographic_Region']"/>

	
	


    <xsl:variable name="synonyms" select="/node()/simple_instance[type='Synonym']"/>
    <xsl:key name="synonyms" match="/node()/simple_instance[type='Synonym']" use="name"/>

	<xsl:key name="actor2RoleKey" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="name"/>
    

	<xsl:variable name="issueCats" select="/node()/simple_instance[type='Issue_Category']"/>
    <xsl:key name="issueCats" match="/node()/simple_instance[type='Issue_Category']" use="name"/>


    <xsl:variable name="extRefls" select="/node()/simple_instance[type='External_Reference_Link']"/>
    <xsl:key name="extRefls" match="/node()/simple_instance[type='External_Reference_Link']" use="name"/>
	


	<!-- start styling -->
	<xsl:variable name="RequirementStatus" select="/node()/simple_instance[type='Requirement_Status']"/>
	<xsl:variable name="srLifecycle" select="/node()/simple_instance[type='Strategic_Requirement_Lifecycle_Status']"/>
	<xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"></xsl:variable>
	<xsl:variable name="eleStyles" select="/node()/simple_instance[type = 'Element_Style'][name=$RequirementStatus/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	<xsl:key name="eleStyles" match="/node()/simple_instance[type = 'Element_Style']" use="name"/>
	<!-- end styling-->

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
	 
	<xsl:template match="knowledge_base">
		{
		"issues":[<xsl:apply-templates select="$issues" mode="issues"></xsl:apply-templates>], 
		"issue_categories":[<xsl:apply-templates select="$issue_cats" mode="issue_cats"></xsl:apply-templates>],
		"requirement_status_list":[<xsl:apply-templates select="$RequirementStatus" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
		"sr_lifecycle_status_list":[<xsl:apply-templates select="$srLifecycle" mode="lifes"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"></xsl:sort></xsl:apply-templates>],
		"version":"621"
		}
	</xsl:template>

<xsl:template match="node()" mode="issue_cats">
<xsl:variable name="syns" select="key('synonyms', current()/own_slot_value[slot_reference='synonyms']/value)"/>
<!-- start JSON structure -->
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
	'enumeration_value': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')'))  
}" />
<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"sequence_number":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>",
	"synonyms":[<xsl:for-each select="$syns">{<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
	}" />
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
<!-- end JSON structure -->
</xsl:template>

<xsl:template match="node()" mode="issues">

    <xsl:variable name="thisOrgs" select="$orgsScope[name=current()/own_slot_value[slot_reference='sr_org_scope']/value]"/>
	<xsl:variable name="thisSource" select="$orgsSource[name=current()/own_slot_value[slot_reference='issue_source']/value]"/>
	<xsl:variable name="reqStatus" select="$status[name=current()/own_slot_value[slot_reference='requirement_status']/value]"/>	 
    <!-- new elements slot--> <xsl:variable name="allimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='sr_requirement_for_elements']/value]"/> 
	<!-- start support for deprecated slots -->
	<xsl:variable name="busimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_business_elements']/value]"/>	
	<xsl:variable name="appimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_application_elements']/value]"/>	
	<xsl:variable name="techimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_technology_elements']/value]"/>	
	<xsl:variable name="infoimpacting" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='related_information_elements']/value]"/>	
	<xsl:variable name="impacting" select="$allimpacting union $busimpacting union $appimpacting union $techimpacting union $infoimpacting"/>
	<!-- end support for deprecated slots -->	
    <xsl:variable name="thisStakeholders" select="key('actor2RoleKey', current()/own_slot_value[slot_reference='stakeholders']/value)"/>
	<xsl:variable name="issCats" select="key('issueCats', current()/own_slot_value[slot_reference='issue_categories']/value)"/>
    <xsl:variable name="allRootCauses" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference='sr_root_causes']/value]"/> 
    <xsl:variable name="stratReqType" select="$stratReq[name=current()/own_slot_value[slot_reference='sr_type']/value]"/>
	<xsl:variable name="geoScopes" select="$geoScoping[name=current()/own_slot_value[slot_reference='sr_geo_scope']/value]"/> <!-- used for Scoping Framework -->

  <xsl:variable name="extRefs" select="key('extRefls', current()/own_slot_value[slot_reference='external_reference_links']/value)"/>
	
	
<!-- start JSON structure -->

{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   <xsl:variable name="combinedMap" as="map(*)" select="map{
	'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
	'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
}" />
<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
	"sr_required_from_date_ISO8601":"<xsl:value-of select="current()/own_slot_value[slot_reference='sr_required_from_date_ISO8601']/value"/>",
	"sr_required_by_date_ISO8601":"<xsl:value-of select="current()/own_slot_value[slot_reference='sr_required_by_date_ISO8601']/value"/>",
	"sr_root_causes":[<xsl:for-each select="$allRootCauses">
            {	
                "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
                <xsl:variable name="combinedMap" as="map(*)" select="map{
                    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
                    'short_name': string(translate(translate(current()/own_slot_value[slot_reference = ('short_name')]/value,'}',')'),'{',')')),
                    'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
                }" />
                <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
                <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
            "className":"<xsl:value-of select="current()/type"/>"
            }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"sr_type":"<xsl:value-of select="$stratReqType/own_slot_value[slot_reference='name']/value"/>",
	"sr_geo_scope":[<xsl:for-each select="$geoScopes">"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
	"sr_lifecycle_status":"<xsl:value-of select="current()/own_slot_value[slot_reference='sr_lifecycle_status']/value"/>",
	"sr_life_id":["<xsl:value-of select="current()/own_slot_value[slot_reference='sr_lifecycle_status']/value"/>"],
    "system_last_modified_datetime_iso8601":"<xsl:value-of select="current()/own_slot_value[slot_reference='system_last_modified_datetime_iso8601']/value"/>",
	"valueClass": "<xsl:value-of select="current()/type"/>",
    "issue_source": "<xsl:value-of select="current()/own_slot_value[slot_reference='issue_source']/value"/>", 
    "requirement_status_id":"<xsl:choose><xsl:when test="string-length(current()/own_slot_value[slot_reference='requirement_status']/value) = 0">Not Set</xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='requirement_status']/value"/></xsl:otherwise></xsl:choose>",
	"orgScopes": [<xsl:for-each select="$thisOrgs">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
    "issue_priority":"<xsl:choose><xsl:when test="string-length(current()/own_slot_value[slot_reference='issue_priority']/value) = 0">Not Set</xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='issue_priority']/value"/></xsl:otherwise></xsl:choose>",
	"issue_categories":[<xsl:for-each select="$issCats">
            {	
                "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
                <xsl:variable name="combinedMap" as="map(*)" select="map{
                    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
                    'short_name': string(translate(translate(current()/own_slot_value[slot_reference = ('short_name')]/value,'}',')'),'{',')')),
					'enumeration_value': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
                    'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
                }" />
                <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
                <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
            "className":"<xsl:value-of select="current()/type"/>"
            }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    
	"external_reference_links":[<xsl:for-each select="$extRefs">
            {	
                "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
                <xsl:variable name="combinedMap" as="map(*)" select="map{
                    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
                    'short_name': string(translate(translate(current()/own_slot_value[slot_reference = ('short_name')]/value,'}',')'),'{',')')),
					'external_reference_url': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')')),
                    'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
                }" />
                <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
                <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
            "className":"<xsl:value-of select="current()/type"/>"
            }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"issue_impacts":[<xsl:for-each select="$impacting">
            {	
                "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
                <xsl:variable name="combinedMap" as="map(*)" select="map{
                    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
                    'short_name': string(translate(translate(current()/own_slot_value[slot_reference = ('short_name')]/value,'}',')'),'{',')')),
					'enumeration_value': string(translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')')),
                    'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value,'}',')'),'{',')'))
                }" />
                <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
                <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>, 
            "className":"<xsl:value-of select="current()/type"/>"
            }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
	"sA2R":[<xsl:for-each select="$thisStakeholders">"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]
	<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>


<!-- end JSON structure -->

</xsl:template>

		<xsl:template match="node()" mode="lifes">
		<!-- this doesn't work <xsl:variable name="thisStyle" select="key('eleStyles', current()[0]/own_slot_value[slot_reference='element_styling_classes']/value)"/> -->
		<xsl:variable name="thisStyle" select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","shortname":"<xsl:choose><xsl:when test="current()/own_slot_value[slot_reference = 'enumeration_value']/value"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></xsl:otherwise></xsl:choose>","colour":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		"colourText":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	

</xsl:stylesheet>
