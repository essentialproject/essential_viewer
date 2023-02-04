<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	
	<xsl:variable name="businessDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>
    <xsl:variable name="businessCapabilities" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="businessCapabilitiesRole" select="/node()/simple_instance[type = 'Business_Capability_Role']"/>
	<xsl:variable name="parentCapabilities" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION'][own_slot_value[slot_reference='buscap_to_parent_parent_buscap']/value=$businessCapabilities/name]"/>
	<xsl:variable name="bcInfoConcepts" select="/node()/simple_instance[type='Information_Concept'][name=$businessCapabilities/own_slot_value[slot_reference='business_capability_requires_information']/value]"/>

	<xsl:variable name="allReportConstants" select="/node()/simple_instance[type = 'Report_Constant']"/>
	<xsl:variable name="rootBusCapConstant" select="$allReportConstants[own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$businessCapabilities[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="countries" select="/node()/simple_instance[type='Geographic_Region']"/>
	<xsl:variable name="productConcepts" select="/node()/simple_instance[type='Product_Concept']"/>
	<xsl:key name="allDocs_key" match="/node()/simple_instance[type = 'External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/> 
	<xsl:key name="allTaxTerms_key" match="/node()/simple_instance[type = 'Taxonomy_Term']" use="own_slot_value[slot_reference = 'classifies_elements']/value"/> 
	 
	 
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
		{"businessCapabilities":[<xsl:apply-templates select="$businessCapabilities" mode="businessCapabilities"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		 "version":"614"}
	</xsl:template>

	<xsl:template match="node()" mode="businessCapabilities">
		<xsl:variable name="thisDocs" select="key('allDocs_key',current()/name)"/>
		<xsl:variable name="thisProductConcepts" select="$productConcepts[own_slot_value[slot_reference='product_concept_supported_by_capability']/value=current()/name]/name"/>
		<xsl:variable name="directCaps" select="$businessCapabilities[name=current()/own_slot_value[slot_reference='supports_business_capabilities']/value]"/>
		<xsl:variable name="indirectCapsRelation" select="$parentCapabilities[name=current()/own_slot_value[slot_reference='buscap_contextual_supports_buscap']/value]"/>
		<xsl:variable name="indirectCaps" select="$businessCapabilities[name=$indirectCapsRelation/own_slot_value[slot_reference='buscap_to_parent_parent_buscap']/value]"/>
		<xsl:variable name="caps" select="$indirectCaps union $directCaps"/> 
		<xsl:variable name="busDomain" select="$businessDomains[name=current()/own_slot_value[slot_reference='belongs_to_business_domain']/value] union $businessDomains[name=current()/own_slot_value[slot_reference='belongs_to_business_domains']/value]"/>
		<xsl:variable name="eaScopedGeoIds" select="$countries[name=current()/own_slot_value[slot_reference = 'ea_scope']/value]/name"/>
		<xsl:variable name="thisrelevantInfoConcepts" select="$bcInfoConcepts[name=current()/own_slot_value[slot_reference='business_capability_requires_information']/value]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
			 </xsl:call-template>",
		"infoConcepts":[<xsl:for-each select="$thisrelevantInfoConcepts">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
	</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param></xsl:call-template>",		 
		"domainIds":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='belongs_to_business_domain']/value)"/>"],	 
		"geoIds": [<xsl:for-each select="$eaScopedGeoIds">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
		"prodConIds": [<xsl:for-each select="$thisProductConcepts">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
		"parentBusinessCapability":[<xsl:for-each select="$caps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"positioninParent":"<xsl:value-of select="$businessCapabilitiesRole[name=$indirectCapsRelation/own_slot_value[slot_reference='buscap_to_parent_role']/value]/own_slot_value[slot_reference='name']/value"/>",
		"sequenceNumber":"<xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_index']/value"/>",
		"rootCapability":"<xsl:if test="$rootBusCap/name=current()/name"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template></xsl:if>",
		"businessDomain":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$busDomain"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"documents":[<xsl:for-each select="$thisDocs">
		<xsl:variable name="thisTaxonomyTerms" select="key('allTaxTerms_key',current()/name)"/>
		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/>
				 </xsl:call-template>",
		"documentLink":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'external_reference_url']/value"/>",
		"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'erl_date_iso_8601']/value"/>",
		"type":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'name']/value"/>",
		"index":"<xsl:value-of select="$thisTaxonomyTerms/own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>],   
		"level":"<xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_level']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
