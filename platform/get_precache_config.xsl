<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:eas="http://www.enterprise-architecture.org/essential" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="http://www.enterprise-architecture.org/essential/precache">

	<xsl:include href="../common/core_utilities.xsl"/>

	<!--
        * Copyright (c)2014 Enterprise Architecture Solutions ltd.
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
	<!-- 12.03.2014 JWC First concept for rendering the pre-cache from repository content -->

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" media-type="text/xml" include-content-type="yes"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="param1"/>

	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="reposXML"/>
	<xsl:param name="theURLPrefix"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>

	<!-- Variables -->
	<!-- List of all report cache configurations -->
	<xsl:variable name="allPreCacheConfigs" select="/node()/simple_instance[type = 'Report_Cache_Configuration']"/>
	<xsl:variable name="allReportLanguages" select="/node()/simple_instance[type = 'Report_Language']"/>
	<xsl:variable name="allEnabledLanguages" select="$allReportLanguages[own_slot_value[slot_reference = 'rl_is_enabled']/value = 'true']"/>
	<xsl:variable name="relevantLanguages" select="/node()/simple_instance[name = $allEnabledLanguages/own_slot_value[slot_reference = 'rl_language']/value]"/>
	<xsl:variable name="allCachedReports" select="/node()/simple_instance[name = $allPreCacheConfigs/own_slot_value[slot_reference = 'cache_report']/value]"/>

	<xsl:template match="knowledge_base">
		<xsl:processing-instruction name="xml-stylesheet">type="text/xml" href="cacheconfightml.xsl"</xsl:processing-instruction>

		<precache xmlns="http://www.enterprise-architecture.org/essential/precache" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.enterprise-architecture.org/essential/precache essential_precache.xsd">

			<!-- Iterate through the allCachedReports, creating a 'url' tag for each in each language -->
			<xsl:apply-templates select="$allCachedReports" mode="RenderCacheLinks"/>

			<!--<url>
                    <uri>http://localhost:8080/essential_viewer_dev</uri>
                    <i18n>en-gb</i18n>
                </url>
                
                <url>
                    <uri>http://localhost:8080/essential_viewer_dev/report?cl=es</uri>
                    <i18n>es</i18n>
                </url>
                
                <!-\- Basic Auth login test -\->
                <url>
                    <uri>http://localhost:8080/essential_viewer_2.0/</uri>
                    <i18n>en-gb</i18n>
                </url>
                
                <!-\- MoE with form login -\->
                <url>
                    <uri>http://localhost:8080/moe_dashboard_portal</uri>
                    <i18n>en-gb</i18n>
                </url>
                
                <url>
                    <uri>http://localhost:8080/moe_dashboard_portal/report?cl=ar-sa</uri>
                    <i18n>ar-sa</i18n>
                </url>-->
		</precache>


	</xsl:template>

	<!-- For a given report instance build the "url" tags -->
	<xsl:template match="node()" mode="RenderCacheLinks">
		<xsl:variable name="theReport" select="current()"/>
		<xsl:variable name="aCacheConfig" select="$allPreCacheConfigs[name = $theReport/own_slot_value[slot_reference = 'report_cache_configuration']/value]"/>

		<!-- Get the class name for specified instances -->
		<xsl:variable name="aReportClass" select="$aCacheConfig/own_slot_value[slot_reference = 'cache_instance_type']/value"/>

		<!-- Get the set of specified instances -->
		<xsl:variable name="specifiedInstances" select="/node()/simple_instance[name = $aCacheConfig/own_slot_value[slot_reference = 'cache_report_instances']/value]"/>
		<xsl:variable name="regHistoryText" select="$theReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
		<xsl:variable name="reportFilename" select="$theReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		<xsl:choose>
			<xsl:when test="count($specifiedInstances) > 0">
				<!-- Apply template to render for each instance -->
				<xsl:apply-templates select="$specifiedInstances" mode="RenderURLForInstance">
					<xsl:with-param name="relevantLanguages" select="$relevantLanguages"/>
					<xsl:with-param name="theXSL" select="$reportFilename"/>
					<xsl:with-param name="theHistory" select="$regHistoryText"/>
				</xsl:apply-templates>
			</xsl:when>

			<xsl:when test="string-length($aReportClass) > 0">
				<!-- Apply template to render for all instances of the class -->
				<xsl:apply-templates select="/node()/simple_instance[type = $aReportClass]" mode="RenderURLForInstance">
					<xsl:with-param name="relevantLanguages" select="$relevantLanguages"/>
					<xsl:with-param name="theXSL" select="$reportFilename"/>
					<xsl:with-param name="theHistory" select="$regHistoryText"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- Apply template to render simple link based on the report setup -->


				<xsl:for-each select="$relevantLanguages">
					<xsl:variable name="ani18n" select="own_slot_value[slot_reference = 'name']/value"/>
					<url>
						<uri>
							<xsl:value-of select="$theURLPrefix"/>
							<xsl:call-template name="RenderCacheLinkText">
								<xsl:with-param name="theXSL" select="$reportFilename"/>
								<xsl:with-param name="theXML">
									<xsl:value-of select="$reposXML"/>
								</xsl:with-param>
								<xsl:with-param name="theHistoryLabel" select="escape-html-uri($regHistoryText)"/>
								<xsl:with-param name="theLanguageCode" select="$ani18n"/>
							</xsl:call-template>
						</uri>
						<i18n>
							<xsl:value-of select="$ani18n"/>
						</i18n>
					</url>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- Render the URL for the link for the specified instance for all languages -->
	<xsl:template match="node()" mode="RenderURLForInstance">
		<xsl:param name="relevantLanguages"/>
		<xsl:param name="theHistory"/>
		<xsl:param name="theXSL"/>
		<xsl:variable name="anInstance" select="current()"/>

		<xsl:for-each select="$relevantLanguages">
			<xsl:variable name="ani18n" select="own_slot_value[slot_reference = 'name']/value"/>
			<url>
				<uri>
					<xsl:value-of select="$theURLPrefix"/>
					<xsl:call-template name="RenderCacheLinkText">
						<xsl:with-param name="theInstanceID" select="$anInstance/name"/>
						<xsl:with-param name="theXSL" select="$theXSL"/>
						<xsl:with-param name="theHistoryLabel" select="$theHistory"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="theLanguageCode" select="$ani18n"/>
					</xsl:call-template>
				</uri>
				<i18n>
					<xsl:value-of select="$ani18n"/>
				</i18n>
			</url>
		</xsl:for-each>

	</xsl:template>

	<xsl:template name="RenderCacheLinkText">
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="theXSL"/>
		<xsl:param name="theInstanceID"/>
		<xsl:param name="theHistoryLabel"/>
		<xsl:param name="theParam2"/>
		<xsl:param name="theParam3"/>
		<xsl:param name="theParam4"/>
		<xsl:param name="theContentType"/>
		<xsl:param name="theFilename"/>
		<xsl:param name="theUserParams"/>
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="theLanguageCode"/>

		<xsl:variable name="instanceName" select="/node()/simple_instance[name = $theInstanceID]/own_slot_value[slot_reference = 'name']/value"/>

		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:text>report?XML=</xsl:text>
		<xsl:value-of select="$theXML"/>
		<xsl:text>&amp;PAGEXSL=</xsl:text>
		<xsl:if test="string-length($theInstanceID) > 0">
			<xsl:text>&amp;PMA=</xsl:text>
			<xsl:value-of select="$theInstanceID"/>
		</xsl:if>
		<xsl:text>&amp;XSL=</xsl:text>
		<xsl:value-of select="$theXSL"/>
		<xsl:if test="string-length($theHistoryLabel) > 0">
			<xsl:text>&amp;LABEL=</xsl:text>
			<xsl:value-of select="encode-for-uri(concat($theHistoryLabel, ' ', $instanceName))"/>
		</xsl:if>
		<xsl:if test="string-length($theParam2) > 0">
			<xsl:text>&amp;PMA2=</xsl:text>
			<xsl:value-of select="$theParam2"/>
		</xsl:if>
		<xsl:if test="string-length($theParam3) > 0">
			<xsl:text>&amp;PMA3=</xsl:text>
			<xsl:value-of select="$theParam3"/>
		</xsl:if>
		<xsl:if test="string-length($theParam4) > 0">
			<xsl:text>&amp;PMA4=</xsl:text>
			<xsl:value-of select="$theParam4"/>
		</xsl:if>
		<xsl:if test="(string-length($theContentType) > 0) and (string-length($theFilename) > 0)">
			<xsl:text>&amp;CT=</xsl:text>
			<xsl:value-of select="$theContentType"/>
			<xsl:text>&amp;FILE=</xsl:text>
			<xsl:value-of select="$theFilename"/>
		</xsl:if>
		<xsl:if test="string-length($theUserParams) > 0">
			<xsl:text>&amp;</xsl:text>
			<xsl:value-of select="$theUserParams"/>
		</xsl:if>
		<xsl:if test="count($viewScopeTerms) > 0">
			<xsl:text>&amp;viewScopeTermIds=</xsl:text>
			<xsl:value-of select="eas:queryStringForInstanceIds($viewScopeTerms, '')"/>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="count($theLanguageCode) > 0">
				<xsl:value-of select="concat('&amp;cl=', $theLanguageCode)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('&amp;cl=', $i18n)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



</xsl:stylesheet>
