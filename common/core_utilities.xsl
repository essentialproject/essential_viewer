<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="pro xalan xs functx eas fn easlang" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
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
	<!-- 16.04.2008 JWC - A set of utility templates that can be used by many other templates -->
	<!-- 06.12.2010 JWC - Added the RenderLinkHref template to manage links -->
	<!-- 15.12.2010 JWC - Updated RenderInstanceName to support EA_Relation instances -->
	<!--                  Ensure that changes here are replicated in strategy_plan_utilities.xsl -->
	<!-- 15.07.2013 JWC - Account for \n characters in renderJSText() -->
	<!-- 29.01.2015 JWC - Added the security features -->
	<!-- 03.04.2017	JWC	- Added the geographic region search for containing regions -->
	<!-- 15.06.2018	JMK	- added a isRenderAsJSString parameter to some templates -->
	<!-- 26.07.2018 JWC	- Added functions to render alphabetic catalogues -->
	<!-- 02.04.2019	JWC - Improved rendering of labels in URLs -->

	<!-- Render the name of an Instance, given its instance id.
    This is the EAS_Class name slot without any special transform -->
	<xsl:import href="../WEB-INF/security/viewer_security.xsl"/>
	<xsl:include href="functx-1.0-doc-2007-01.xsl"/>
	<xsl:include href="core_menu.xsl"/>
	<!-- Bring in the character maps -->
	<xsl:include href="core_char_map.xsl"/>

	<!--Setup Language Related Variables-->
	<xsl:param name="i18n">en-gb</xsl:param>
	<xsl:variable name="langFile">../language/<xsl:value-of select="$i18n"/>.xml</xsl:variable>
	<xsl:variable name="flagFile">
		<xsl:choose>
			<xsl:when test="string-length($i18n) = 0">language/flags/en-gb.png</xsl:when>
			<xsl:otherwise>language/flags/<xsl:value-of select="$i18n"/>.png</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="languageFile" select="document($langFile)"/>
	<xsl:variable name="defaultLanguageReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Language')]"/>
	<xsl:variable name="enabledReportLanguages" select="/node()/simple_instance[own_slot_value[slot_reference = 'rl_is_enabled']/value = 'true']"/>
	<xsl:variable name="enabledLanguages" select="/node()/simple_instance[name = $enabledReportLanguages/own_slot_value[slot_reference = 'rl_language']/value]"/>
	<xsl:variable name="currentLanguage" select="$enabledLanguages[own_slot_value[slot_reference = 'name']/value = $i18n]"/>
	<xsl:variable name="defaultLanguage" select="$enabledLanguages[name = $defaultLanguageReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>


	<!-- Collect all available popup menus -->
	<xsl:variable name="utilitiesAllMenus" select="/node()/simple_instance[(type = 'Report_Menu')]"/>

	<!-- Collect all available popup menus -->
	<xsl:variable name="utilitiesAllReportTypes" select="/node()/simple_instance[(type = 'Report_Implementation_Type')]"/>

	<!-- Collect all available reports -->
	<xsl:variable name="utilitiesAllReports" select="/node()/simple_instance[type = 'Report']"/>
	
	<!-- Collect all available reports -->
	<xsl:variable name="utilitiesAllPDFConfigs" select="/node()/simple_instance[type = 'Report_PDF_Configuration']"/>
	
	<!-- Collect all available editors -->
	<xsl:variable name="utilitiesAllEditors" select="/node()/simple_instance[type = ('Editor', 'Simple_Editor', 'Configured_Editor')]"/>
	
	<!-- Collect all available editor sections -->
	<xsl:variable name="utilitiesAllEditorSections" select="/node()/simple_instance[type = 'Editor_Section']"/>
	
	<!-- Collect all available data set APIs -->
	<xsl:variable name="utilitiesAllDataSetAPIs" select="/node()/simple_instance[type = 'Data_Set_API']"/>

	<!-- Collect all available taxonomy terms -->
	<xsl:variable name="utilitiesAllTaxonomyTerms" select="/node()/simple_instance[(type = 'Taxonomy_Term')]"/>

	<!-- Define the characters to be used to delimit scoping term parameters -->
	<xsl:variable name="instanceIdDelim" select="'::'"/>

	<!-- Collect all available synonyms -->
	<xsl:variable name="utilitiesAllSynonyms" select="/node()/simple_instance[(type = 'Synonym')]"/>

	<!-- Collect all available commentaries -->
	<xsl:variable name="utilitiesAllCommentaries" select="/node()/simple_instance[(type = ('Commentary', 'Label'))]"/>

	<!-- Collect all available element style instances -->
	<xsl:variable name="utilitiesAllElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>

	<xsl:template match="node()" mode="RenderInstanceName">
		<xsl:variable name="theInstanceID" select="current()"/>
		<xsl:variable name="anInstance" select="/node()/simple_instance[name = $theInstanceID]"/>
		<xsl:if test="position() > 1">
			<br/>
		</xsl:if>
		<xsl:value-of select="$anInstance/own_slot_value[slot_reference = 'name' or slot_reference = 'relation_name']/value"/>
	</xsl:template>

	<!-- Render a Taxonomy Term for an Objective, given its instance ID -->
	<xsl:template match="node()" mode="RenderObjectiveTaxonomyTerm">
		<xsl:variable name="theInstanceID" select="current()"/>
		<xsl:variable name="aTerm" select="/node()/simple_instance[name = $theInstanceID]"/>
		<xsl:value-of select="$aTerm/own_slot_value[slot_reference = 'name']/value"/>
	</xsl:template>

	<!-- Render the code to produce the HREF attribute of a hyperlink 
        theXML is the name of the XML file to process, by default, reportXML.xml
        theXSL is the name of the transform to execute to build the view
        theInstanceID is the name of the instance that is is the key for the view
        theHistoryLabel is the content to be shown in the history drop-down
        theParam2 is an optional parameter to supply to any view
        theParam3 is an optional parameter to supply to any view
        theParam4 is an optional parameter to supply to any view
        theContentType [optional] is a MIME content type, e.g. application/ms-excel for downloading the view
        theFilename [optional but required if theContentType is used] is the name of the file render the selected 
        content type into. Must be supplied if theContentType is specified.
    -->
	<xsl:template name="RenderLinkHref" match="node()">
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="theXSL"/>
		<xsl:param name="theInstanceID"/>
		<xsl:param name="theHistoryLabel"/>
		<xsl:param name="theParam2"/>
		<xsl:param name="theParam3"/>
		<xsl:param name="theParam4"/>
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="theContentType"/>
		<xsl:param name="theFilename"/>
		<xsl:param name="theUserParams"/>

		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:attribute name="href">
			<xsl:text>report?XML=</xsl:text>
			<xsl:value-of select="$theXML"/>

			<xsl:if test="string-length($theInstanceID) > 0">
				<xsl:text>&amp;PMA=</xsl:text>
				<xsl:value-of select="$theInstanceID"/>
			</xsl:if>

			<xsl:if test="string-length($theXSL) > 0">
				<xsl:text>&amp;XSL=</xsl:text>
				<xsl:value-of select="$theXSL"/>
			</xsl:if>
			<xsl:if test="string-length($theHistoryLabel) > 0">
				<xsl:text>&amp;LABEL=</xsl:text>
				<xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
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

			<xsl:value-of select="concat('&amp;cl=', $i18n)"/>

		</xsl:attribute>
	</xsl:template>


	<xsl:template name="CommonRenderLinkHref" match="node()">
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="thePageXSL"/>
		<xsl:param name="theXSL"/>
		<xsl:param name="theInstanceID"/>
		<xsl:param name="theHistoryLabel"/>
		<xsl:param name="theParam2"/>
		<xsl:param name="theParam3"/>
		<xsl:param name="theParam4"/>
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="theContentType"/>
		<xsl:param name="theFilename"/>
		<xsl:param name="theUserParams"/>
		<xsl:param name="reportType"/>

		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:attribute name="href">

			<xsl:choose>
				<xsl:when test="$reportType = 'uml'">
					<xsl:text>uml_model.jsp?XML=</xsl:text>
					<xsl:value-of select="$theXML"/>
					<xsl:text>&amp;PAGEXSL=</xsl:text>
					<xsl:value-of select="$thePageXSL"/>
				</xsl:when>
				<xsl:when test="$reportType = 'html'">
					<xsl:text>report?XML=</xsl:text>
					<xsl:value-of select="$theXML"/>
					<xsl:text>&amp;PAGEXSL=</xsl:text>
					<xsl:value-of select="$thePageXSL"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>?XML=</xsl:text>
					<xsl:value-of select="$theXML"/>
				</xsl:otherwise>
			</xsl:choose>

			<!--<xsl:if test="$reportType = 'uml'">
				<xsl:text>&amp;PAGEXSL=</xsl:text>
				<xsl:value-of select="$thePageXSL"/>
			</xsl:if>-->

			<xsl:if test="count($theInstanceID) > 0">
				<xsl:text>&amp;PMA=</xsl:text>
				<xsl:value-of select="$theInstanceID"/>
			</xsl:if>

			<xsl:if test="string-length($theXSL) > 0">
				<xsl:text>&amp;XSL=</xsl:text>
				<xsl:value-of select="$theXSL"/>
			</xsl:if>
			<xsl:if test="string-length($theHistoryLabel) > 0">
				<xsl:text>&amp;LABEL=</xsl:text>
				<xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
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

			<xsl:value-of select="concat('&amp;cl=', $i18n)"/>

		</xsl:attribute>
	</xsl:template>


	<xsl:template name="CommonRenderLinkHrefText">
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="thePageXSL"/>
		<xsl:param name="theXSL"/>
		<xsl:param name="theInstanceID"/>
		<xsl:param name="theHistoryLabel"/>
		<xsl:param name="theParam2"/>
		<xsl:param name="theParam3"/>
		<xsl:param name="theParam4"/>
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="theContentType"/>
		<xsl:param name="theFilename"/>
		<xsl:param name="theUserParams"/>
		<xsl:param name="reportType"/>

		<!-- using the specified parameters, build the HREF attribute for the link -->

		<xsl:choose>
			<xsl:when test="$reportType = 'uml'">
				<xsl:text>uml_model.jsp?XML=</xsl:text>
				<xsl:value-of select="$theXML"/>
				<xsl:text>&amp;PAGEXSL=</xsl:text>
				<xsl:value-of select="$thePageXSL"/>
			</xsl:when>
			<xsl:when test="$reportType = 'html'">
				<xsl:text>report?XML=</xsl:text>
				<xsl:value-of select="$theXML"/>
				<xsl:text>&amp;PAGEXSL=</xsl:text>
				<xsl:value-of select="$thePageXSL"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>?XML=</xsl:text>
				<xsl:value-of select="$theXML"/>
			</xsl:otherwise>
		</xsl:choose>

		<!--<xsl:if test="$reportType = 'uml'">
			<xsl:text>&amp;PAGEXSL=</xsl:text>
			<xsl:value-of select="$thePageXSL"/>
		</xsl:if>-->

		<xsl:if test="string-length($theInstanceID) > 0">
			<xsl:text>&amp;PMA=</xsl:text>
			<xsl:value-of select="$theInstanceID"/>
		</xsl:if>

		<xsl:if test="string-length($theXSL) > 0">
			<xsl:text>&amp;XSL=</xsl:text>
			<xsl:value-of select="$theXSL"/>
		</xsl:if>
		<xsl:if test="string-length($theHistoryLabel) > 0">
			<xsl:text>&amp;LABEL=</xsl:text>
			<xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
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

		<xsl:value-of select="concat('&amp;cl=', $i18n)"/>
	</xsl:template>


	<xsl:template name="RenderLinkText">
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

		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:text>report?XML=</xsl:text>
		<xsl:value-of select="$theXML"/>
		<xsl:text>&amp;XSL=</xsl:text>
		<xsl:value-of select="$theXSL"/>

		<xsl:if test="string-length($theInstanceID) > 0">
			<xsl:text>&amp;PMA=</xsl:text>
			<xsl:value-of select="$theInstanceID"/>
		</xsl:if>

		<xsl:if test="string-length($theHistoryLabel) > 0">
			<xsl:text>&amp;LABEL=</xsl:text>
			<xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
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

		<xsl:value-of select="concat('&amp;cl=', $i18n)"/>
	</xsl:template>



	<xsl:template name="RenderFullLinkText">
		<xsl:param name="theURLPrefix"/>
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="theXSL"/>
		<xsl:param name="theInstanceID"/>
		<xsl:param name="theHistoryLabel"/>
		<xsl:param name="theParam2"/>
		<xsl:param name="theParam3"/>
		<xsl:param name="theParam4"/>
		<xsl:param name="theContentType"/>
		<xsl:param name="theFilename"/>
		<xsl:param name="viewScopeTerms" select="()"/>

		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:value-of select="$theURLPrefix"/>
		<xsl:text>report?XML=</xsl:text>
		<xsl:value-of select="$theXML"/>
		<xsl:text>&amp;XSL=</xsl:text>
		<xsl:value-of select="$theXSL"/>

		<xsl:if test="string-length($theInstanceID) > 0">
			<xsl:text>&amp;PMA=</xsl:text>
			<xsl:value-of select="$theInstanceID"/>
		</xsl:if>

		<xsl:if test="string-length($theHistoryLabel) > 0">
			<xsl:text>&amp;LABEL=</xsl:text>
			<xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
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
		<xsl:if test="count($viewScopeTerms) > 0">
			<xsl:text>&amp;viewScopeTermIds=</xsl:text>
			<xsl:value-of select="eas:queryStringForInstanceIds($viewScopeTerms, '')"/>
		</xsl:if>

		<xsl:value-of select="concat('&amp;cl=', $i18n)"/>
	</xsl:template>
	
	
	<!-- Render a link to an Report API instance -->
	<xsl:template name="RenderAPILinkText">
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
		
		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:text>reportApi?XML=</xsl:text>
		<xsl:value-of select="$theXML"/>
		<xsl:text>&amp;XSL=</xsl:text>
		<xsl:value-of select="$theXSL"/>
		
		<xsl:if test="string-length($theInstanceID) > 0">
			<xsl:text>&amp;PMA=</xsl:text>
			<xsl:value-of select="$theInstanceID"/>
		</xsl:if>
		
		<xsl:if test="string-length($theHistoryLabel) > 0">
			<xsl:text>&amp;LABEL=</xsl:text>
			<xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
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
		
		<xsl:value-of select="concat('&amp;cl=', $i18n)"/>
	</xsl:template>



	<!-- FUNCTION TO RETRIEVE A SPECIFIC MENU THAT HAS A SHORT NAME MATCHING THE GIVEN PARAMETER
        menuShortName is the unique short name given to a specific menu
    -->
	<xsl:function name="eas:get_menu_by_shortname" as="node()*">
		<xsl:param name="menuShortName"/>

		<!--<xsl:copy-of select="$utilitiesAllMenus[own_slot_value[slot_reference='report_menu_short_name']/value = $menuShortName]"/>    -->
		<xsl:sequence select="$utilitiesAllMenus[own_slot_value[slot_reference = 'report_menu_short_name']/value = $menuShortName]"/>

	</xsl:function>


	<!-- FUNCTION TO RETRIEVE A SPECIFIC REPORT THAT HAS A NAME MATCHING THE GIVEN PARAMETER
        reportName is the unique name given to a specific report
    -->
	<xsl:function name="eas:get_report_by_name" as="node()*">
		<xsl:param name="reportName"/>

		<xsl:sequence select="$utilitiesAllReports[own_slot_value[slot_reference = 'name']/value = $reportName]"/>

	</xsl:function>



	<!-- Render the javascript code to produce either a link, popup menu or plain text for a given instance 
        instanceClassName the name of the meta-class of the instances for which menus are to be displayed
        targetMenu is an optional parameter that allows a specific popup menu to be used
    -->
	<xsl:template name="RenderInstanceLinkJavascript">
		<xsl:param name="instanceClassName"/>
		<xsl:param name="targetMenu"/>
		<xsl:param name="newWindow" select="false()"/>


		<!-- Get the default menu for the class of the instance, if one exists -->
		<xsl:variable name="defaultMenus" select="$utilitiesAllMenus[(own_slot_value[slot_reference = 'report_menu_class']/value = $instanceClassName) and (own_slot_value[slot_reference = 'report_menu_is_default']/value = 'true')]"/>

		<!-- Render the appropriate link based on the given parameters -->
		<xsl:choose>
			<!-- If a target menu has been provided, create the appropriate javscript -->
			<xsl:when test="count($targetMenu) > 0">

				<!-- Check user is cleared for Menu -->
				<xsl:if test="eas:isUserAuthZ($targetMenu)">
					<xsl:call-template name="RenderPopUpJavascript">
						<xsl:with-param name="thisMenu" select="$targetMenu"/>
						<xsl:with-param name="newWindow" select="$newWindow"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<!-- If no target menu has been provided and a default menu exists for the class, create the appropriate javascript for the default menus -->
			<xsl:when test="count($defaultMenus) > 0">
				<xsl:for-each select="$defaultMenus">

					<!-- Check user is cleared for Menu -->
					<xsl:if test="eas:isUserAuthZ(current())">
						<xsl:call-template name="RenderPopUpJavascript">
							<xsl:with-param name="thisMenu" select="current()"/>
							<xsl:with-param name="newWindow" select="$newWindow"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>

	</xsl:template>
	
	
	<xsl:template name="RenderEditorInstanceLinkJavascript">
		<xsl:param name="instanceClassName"/>
		<xsl:param name="targetMenu"/>
		<xsl:param name="newWindow" select="false()"/>
		
		
		<!-- Get the default menu for the class of the instance, if one exists -->
		<xsl:variable name="defaultMenus" select="$utilitiesAllMenus[(own_slot_value[slot_reference = 'report_menu_class']/value = $instanceClassName) and (own_slot_value[slot_reference = 'report_menu_is_default']/value = 'true')]"/>
		
		<!-- Render the appropriate link based on the given parameters -->
		<xsl:choose>
			<!-- If a target menu has been provided, create the appropriate javscript -->
			<xsl:when test="count($targetMenu) > 0">
				
				<!-- Check user is cleared for Menu -->
				<xsl:if test="eas:isUserAuthZ($targetMenu)">
					<xsl:call-template name="RenderEditorPopUpJavascript">
						<xsl:with-param name="thisMenu" select="$targetMenu"/>
						<xsl:with-param name="newWindow" select="$newWindow"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<!-- If no target menu has been provided and a default menu exists for the class, create the appropriate javascript for the default menus -->
			<xsl:when test="count($defaultMenus) > 0">
				<xsl:for-each select="$defaultMenus">
					
					<!-- Check user is cleared for Menu -->
					<xsl:if test="eas:isUserAuthZ(current())">
						<xsl:call-template name="RenderEditorPopUpJavascript">
							<xsl:with-param name="thisMenu" select="current()"/>
							<xsl:with-param name="newWindow" select="$newWindow"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>


	<!-- Render the code to produce either a link, popup menu or plain text for a given instance 
        theCatalogue, the only mandatory parameter and is the report instance for which a link is to be rendered
        theXML is the name of the XML file to process, by default, reportXML.xml
        userParams are any user-defined parameters to be passed to the next page
        viewScopeTerms are optional Taxonomy_Term instances that should be used to scope the next page
        targetMenu is an optional parameter that allows a specific popup menu to be used
        targetReport is an optional parameter that allows a specific report to be the target of the link
        display String is an optional parameter that allows a fixed string to be displayed as the link text
        divClass is an optional parameter that indicates that the text for the link should be contained within a DIV tag with the given class.
    -->
	<xsl:template name="RenderCatalogueLink">
		<xsl:param name="theCatalogue"/>
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="userParams"/>
		<xsl:param name="viewScopeTerms"/>
		<xsl:param name="targetMenu"/>
		<xsl:param name="targetReport"/>
		<xsl:param name="displayString"/>
		<xsl:param name="divClass"/>
		<xsl:param name="anchorClass"/>

		<!-- First perform user clearance check -->
		<xsl:if test="eas:isUserAuthZ($targetReport)">

			<xsl:variable name="linkText">
				<xsl:choose>
					<xsl:when test="string-length($displayString) > 0">
						<xsl:value-of select="$displayString"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="eas:i18n($theCatalogue/own_slot_value[slot_reference = 'report_label']/value)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="reportFilename" select="$theCatalogue/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			<xsl:variable name="reportHistoryLabel" select="$theCatalogue/own_slot_value[slot_reference = 'report_history_label']/value"/>
			<xsl:variable name="targetReportId" select="$targetReport/name"/>
			<xsl:variable name="catalogueTypeId" select="$theCatalogue/own_slot_value[slot_reference = 'report_implementation_type']/value"/>

			<xsl:variable name="reportType">
				<xsl:choose>
					<xsl:when test="string-length($catalogueTypeId) > 0">
						<xsl:variable name="reportTypeEnum" select="$utilitiesAllReportTypes[name = $catalogueTypeId]"/>
						<xsl:value-of select="$reportTypeEnum/own_slot_value[slot_reference = 'enumeration_value']/value"/>
					</xsl:when>
					<xsl:otherwise>html</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="targetMenuShortName" select="$targetMenu/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
			<xsl:variable name="allUserParams">
				<xsl:text>&amp;targetReportId=</xsl:text>
				<xsl:value-of select="$targetReportId"/>
				<xsl:text>&amp;targetMenuShortName=</xsl:text>
				<xsl:value-of select="$targetMenuShortName"/>
			</xsl:variable>
			<a class="{$anchorClass}">
				<xsl:call-template name="CommonRenderLinkHref">
					<xsl:with-param name="theXSL" select="$reportFilename"/>
					<xsl:with-param name="theXML" select="$theXML"/>
					<xsl:with-param name="theHistoryLabel" select="$reportHistoryLabel"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="theUserParams" select="$allUserParams"/>
					<xsl:with-param name="reportType" select="$reportType"/>
				</xsl:call-template>
				<xsl:call-template name="RenderInstanceLinkText">
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="instanceName" select="$linkText"/>
				</xsl:call-template>
			</a>
		</xsl:if>
		<!-- Do not render anything if not cleared -->

	</xsl:template>


	<!-- Render the code to produce either a link, popup menu or plain text for a given instance 
        theSubjectInstance, the only mandatory parameter and is the instance for which a link is to be rendered
        theXML is the name of the XML file to process, by default, reportXML.xml
        userParams are any user-defined parameters to be passed to the next page
        viewScopeTerms are optional Taxonomy_Term instances that should be used to scope the next page
        targetMenu is an optional parameter that allows a specific popup menu to be used
        targetReport is an optional parameter that allows a specific report to be the target of the link
        displaySlot is an optional parameter that allows a specific slot to be displayed as the link text
        display String is an optional parameter that allows a fixed string to be displayed as the link text
        divClass is an optional parameter that indicates that the text for the link should be contained within a DIV tag with the given class.
    -->
	<xsl:template name="RenderInstanceLink">
		<xsl:param name="theSubjectInstance" select="()"/>
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="userParams"/>
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="targetMenu" select="()"/>
		<xsl:param name="targetReport" select="()"/>
		<xsl:param name="displaySlot"/>
		<xsl:param name="displayString"/>
		<xsl:param name="divClass"/>
		<xsl:param name="divStyle"/>
		<xsl:param name="divId"/>
		<xsl:param name="anchorClass"/>
		<xsl:param name="isRenderAsJSString" as="xs:boolean" select="false()"/>
		<xsl:param name="isForJSONAPI" select="false()"/>

		
		<!-- Create the elements of the query string for a potential link -->
		<!--<xsl:variable name="generalQueryString">
            <xsl:call-template name="ConstructPopUpQueryString">
                <xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
                <xsl:with-param name="theInstance" select="$theSubjectInstance"/>
            </xsl:call-template>
        </xsl:variable>    
        <xsl:variable name="fullQueryString" select="concat($userParams, $generalQueryString)"/>-->

		<!-- First perform user clearance check -->
		<xsl:choose>
			<xsl:when test="eas:isUserAuthZ($theSubjectInstance)">
				<!-- Get the name of the instance that has been passed -->
				<xsl:variable name="instanceId" select="$theSubjectInstance/name"/>

				<xsl:variable name="instanceName">
					<xsl:choose>
						<xsl:when test="string-length($displayString) > 0">
							<xsl:value-of select="$displayString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="RenderMultiLangInstanceName">
								<xsl:with-param name="theSubjectInstance" select="$theSubjectInstance"/>
							</xsl:call-template>
							<!--<xsl:value-of select="$theSubjectInstance/own_slot_value[slot_reference=$displaySlot]/value" />-->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!--<xsl:variable name="defaultMenu" select="$utilitiesAllMenus[(own_slot_value[slot_reference='report_menu_class']/value = $theSubjectInstance/type) and (own_slot_value[slot_reference='report_menu_is_default']/value ='true')]" />-->

				<xsl:variable name="defaultMenu" select="eas:get_default_menu_for_instance($theSubjectInstance)"/>
				<xsl:variable name="instanceNameAnchor">
					<xsl:choose>
						<xsl:when test="$isForJSONAPI">
							<xsl:value-of select="eas:renderJSAPIText($instanceName)"/>
						</xsl:when>
						<xsl:when test="$isRenderAsJSString">
							<xsl:value-of select="eas:renderJSText($instanceName)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$instanceName"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Render the appropriate link based on the given parameters -->
				<xsl:choose>
					<!-- If a target report has been provided, just create a normal link to the specific report -->
					<xsl:when test="(count($targetReport) > 0)">
						<xsl:variable name="targetReportTypeId" select="$targetReport/own_slot_value[slot_reference = 'report_implementation_type']/value"/>
						<xsl:variable name="reportTypeEnum" select="$utilitiesAllReportTypes[name = $targetReportTypeId]"/>

						<xsl:variable name="reportType">
							<xsl:choose>
								<xsl:when test="count($reportTypeEnum) > 0">
									<xsl:value-of select="$reportTypeEnum/own_slot_value[slot_reference = 'enumeration_value']/value"/>
								</xsl:when>
								<xsl:otherwise>html</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="reportXSLPath" select="$targetReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
						<xsl:variable name="reportHistoryLabel" select="$targetReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
						<xsl:variable name="pageXSL" select="$targetReport/own_slot_value[slot_reference = 'report_context_xsl_filename']/value"/>
						<a>
							<xsl:if test="string-length($anchorClass) > 0">
								<xsl:attribute name="class" select="$anchorClass"/>
							</xsl:if>
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theInstanceID" select="$theSubjectInstance/name"/>
								<xsl:with-param name="theXML" select="$theXML"/>
								<xsl:with-param name="theXSL" select="$reportXSLPath"/>
								<xsl:with-param name="reportType" select="$reportType"/>
								<xsl:with-param name="thePageXSL" select="$pageXSL"/>
								<xsl:with-param name="theHistoryLabel" select="concat($reportHistoryLabel, ' ', $instanceName)"/>
								<xsl:with-param name="theUserParams" select="$userParams"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
							<xsl:call-template name="RenderInstanceLinkText">
								<xsl:with-param name="divClass" select="$divClass"/>
								<xsl:with-param name="divStyle" select="$divStyle"/>
								<xsl:with-param name="divId" select="$divId"/>
								<xsl:with-param name="instanceName" select="$instanceName"/>
								<xsl:with-param name="isRenderAsJSString" select="$isRenderAsJSString"/>
							</xsl:call-template>
						</a>
					</xsl:when>
					<!-- If a target menu has been provided, create the appropriate popup link -->
					<xsl:when test="count($targetMenu) > 0">
						<xsl:variable name="menuShortName" select="$targetMenu/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
						<!-- Define the class for the anchor -->
						<xsl:variable name="linkClass" select="concat($anchorClass, ' ', 'context-menu-', $menuShortName)"/>

						<a id="{$instanceNameAnchor}" class="{$linkClass}">
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theInstanceID" select="$theSubjectInstance/name"/>
								<xsl:with-param name="theXML" select="$theXML"/>
								<xsl:with-param name="theUserParams" select="$userParams"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
							<xsl:call-template name="RenderInstanceLinkText">
								<xsl:with-param name="divClass" select="$divClass"/>
								<xsl:with-param name="divStyle" select="$divStyle"/>
								<xsl:with-param name="divId" select="$divId"/>
								<xsl:with-param name="instanceName" select="$instanceName"/>
								<xsl:with-param name="isRenderAsJSString" select="$isRenderAsJSString"/>
							</xsl:call-template>
						</a>
					</xsl:when>
					<!-- If no target menu has been provided and a default menu exists for the class of the instance, creatae an appropriate popup link -->
					<xsl:when test="count($defaultMenu) > 0">
						<xsl:variable name="menuShortName" select="$defaultMenu/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
						<!-- Define the class for the anchor -->
						<xsl:variable name="linkClass" select="concat($anchorClass, ' ', 'context-menu-', $menuShortName)"/>

						<a id="{$instanceNameAnchor}" class="{$linkClass}">
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theInstanceID" select="$theSubjectInstance/name"/>
								<xsl:with-param name="theXML" select="$theXML"/>
								<xsl:with-param name="theUserParams" select="$userParams"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
							<xsl:call-template name="RenderInstanceLinkText">
								<xsl:with-param name="divClass" select="$divClass"/>
								<xsl:with-param name="divStyle" select="$divStyle"/>
								<xsl:with-param name="divId" select="$divId"/>
								<xsl:with-param name="instanceName" select="$instanceName"/>
								<xsl:with-param name="isRenderAsJSString" select="$isRenderAsJSString"/>
							</xsl:call-template>
							<!--<xsl:value-of select="$viewScopeTerms[1]/own_slot_value[slot_reference='name']/value"/>-->
						</a>
					</xsl:when>
					<!-- If no menu is found, then just display the name of the instance without an anchor -->
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLinkText">
							<xsl:with-param name="divClass" select="$divClass"/>
							<xsl:with-param name="divStyle" select="$divStyle"/>
							<xsl:with-param name="divId" select="$divId"/>
							<xsl:with-param name="instanceName" select="$instanceName"/>
							<xsl:with-param name="isRenderAsJSString" select="$isRenderAsJSString"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<!-- Redact the instance name - user not cleared -->
				<xsl:value-of select="eas:i18n($theRedactedString)"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>






	<!-- Render the code to produce either a link, popup menu or plain text for a given instance 
        theSubjectInstance, the only mandatory parameter and is the instance for which a link is to be rendered
        theXML is the name of the XML file to process, by default, reportXML.xml
        userParams are any user-defined parameters to be passed to the next page
        viewScopeTerms are optional Taxonomy_Term instances that should be used to scope the next page
        targetMenu is an optional parameter that allows a specific popup menu to be used
        targetReport is an optional parameter that allows a specific report to be the target of the link
        displaySlot is an optional parameter that allows a specific slot to be displayed as the link text
        display String is an optional parameter that allows a fixed string to be displayed as the link text
        divClass is an optional parameter that indicates that the text for the link should be contained within a DIV tag with the given class.
    -->
	<xsl:template name="RenderInstanceLinkForJS">
		<xsl:param name="theSubjectInstance" select="()"/>
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="userParams"/>
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="targetMenu" select="()"/>
		<xsl:param name="targetReport" select="()"/>
		<xsl:param name="displaySlot">name</xsl:param>
		<xsl:param name="displayString"/>
		<xsl:param name="divClass"/>
		<xsl:param name="anchorClass"/>
		<xsl:param name="isForJSONAPI" select="false()"/>


		<!-- First perform user clearance check -->
		<xsl:choose>
			<xsl:when test="eas:isUserAuthZ($theSubjectInstance)">

				<!-- Get the name of the instance that has been passed -->
				<xsl:variable name="instanceId" select="$theSubjectInstance/name"/>
				<xsl:variable name="quoteString"><xsl:text disable-output-escaping="no">&apos;</xsl:text></xsl:variable>
				<xsl:variable name="doubleQuoteString"><xsl:text disable-output-escaping="no">&quot;</xsl:text></xsl:variable>

				<xsl:variable name="instanceName">
					<xsl:choose>
						<xsl:when test="string-length($displayString) > 0">
							<xsl:value-of select="$displayString"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="RenderMultiLangInstanceName">
								<xsl:with-param name="theSubjectInstance" select="$theSubjectInstance"/>
							</xsl:call-template>
							<!--<xsl:value-of select="$theSubjectInstance/own_slot_value[slot_reference=$displaySlot]/value" />-->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!--<xsl:variable name="escapedInstanceName" select="translate($instanceName, $quoteString, '')"/>-->				
				<xsl:variable name="escapedInstanceName">
					<xsl:choose>
						<xsl:when test="$isForJSONAPI">
							<xsl:value-of select="eas:renderJSAPIText($instanceName)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="eas:renderJSText($instanceName)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="defaultMenu" select="$utilitiesAllMenus[(own_slot_value[slot_reference = 'report_menu_class']/value = $theSubjectInstance/type) and (own_slot_value[slot_reference = 'report_menu_is_default']/value = 'true')]"/>


				<!-- Render the appropriate link based on the given parameters -->
				<xsl:choose>
					<!-- If a target report has been provided, just create a normal link to the specific report -->
					<xsl:when test="(count($targetReport) > 0)">
						<xsl:variable name="targetReportTypeId" select="$targetReport/own_slot_value[slot_reference = 'report_implementation_type']/value"/>
						<xsl:variable name="reportTypeEnum" select="$utilitiesAllReportTypes[name = $targetReportTypeId]"/>

						<xsl:variable name="reportType">
							<xsl:choose>
								<xsl:when test="count($reportTypeEnum) > 0">
									<xsl:value-of select="$reportTypeEnum/own_slot_value[slot_reference = 'enumeration_value']/value"/>
								</xsl:when>
								<xsl:otherwise>html</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="reportXSLPath" select="$targetReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
						<xsl:variable name="reportHistoryLabel" select="$targetReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
						<xsl:variable name="pageXSL" select="$targetReport/own_slot_value[slot_reference = 'report_context_xsl_filename']/value"/>

						<xsl:variable name="anchorClass">
							<xsl:choose>
								<xsl:when test="string-length($anchorClass) > 0">
									<xsl:value-of select="$anchorClass"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="linkText">
							<xsl:call-template name="CommonRenderLinkHrefText">
								<xsl:with-param name="theInstanceID" select="$theSubjectInstance/name"/>
								<xsl:with-param name="theXML" select="$theXML"/>
								<xsl:with-param name="theXSL" select="$reportXSLPath"/>
								<xsl:with-param name="reportType" select="$reportType"/>
								<xsl:with-param name="thePageXSL" select="$pageXSL"/>
								<xsl:with-param name="theHistoryLabel" select="concat($reportHistoryLabel, ' ', $instanceName)"/>
								<xsl:with-param name="theUserParams" select="$userParams"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:variable>


						<xsl:text>&lt;a href = \&quot;</xsl:text>
						<xsl:value-of select="$linkText"/>
						<xsl:text>\&quot; class = \&quot;</xsl:text>
						<xsl:value-of select="$anchorClass"/>
						<xsl:text>\&quot; id =\&quot;</xsl:text>
						<xsl:value-of select="$instanceId"/>
						<xsl:text>Link\&quot; &gt;</xsl:text>
						<xsl:call-template name="RenderInstanceLinkText">
							<xsl:with-param name="instanceName" select="$escapedInstanceName"/>
						</xsl:call-template>
						<xsl:text>&lt;/a&gt;</xsl:text>
					</xsl:when>
					<!-- If a target menu has been provided, create the appropriate popup link -->
					<xsl:when test="count($targetMenu) > 0">
						<xsl:variable name="menuShortName" select="$targetMenu/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
						<!-- Define the class for the anchor -->
						<xsl:variable name="linkClass" select="concat($anchorClass, ' ', 'context-menu-', $menuShortName)"/>

						<xsl:variable name="linkText">
							<xsl:call-template name="CommonRenderLinkHrefText">
								<xsl:with-param name="theInstanceID" select="$theSubjectInstance/name"/>
								<xsl:with-param name="theXML" select="$theXML"/>
								<xsl:with-param name="theUserParams" select="$userParams"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:variable>


						<xsl:text>&lt;a href = \&quot;</xsl:text>
						<xsl:value-of select="$linkText"/>
						<xsl:text>\&quot; class = \&quot;</xsl:text>
						<xsl:value-of select="$linkClass"/>
						<xsl:text>\&quot; id =\&quot;</xsl:text>
						<xsl:value-of select="$instanceId"/>
						<xsl:text>Link\&quot; &gt;</xsl:text>
						<xsl:call-template name="RenderInstanceLinkText">
							<xsl:with-param name="instanceName" select="$escapedInstanceName"/>
						</xsl:call-template>
						<xsl:text>&lt;/a&gt;</xsl:text>
					</xsl:when>
					<!-- If no target menu has been provided and a default menu exists for the class of the instance, creatae an appropriate popup link -->
					<xsl:when test="count($defaultMenu) > 0">
						<xsl:variable name="menuShortName" select="$defaultMenu/own_slot_value[slot_reference = 'report_menu_short_name']/value"/>
						<!-- Define the class for the anchor -->
						<xsl:variable name="linkClass" select="concat($anchorClass, ' ', 'context-menu-', $menuShortName)"/>

						<xsl:variable name="linkText">
							<xsl:call-template name="CommonRenderLinkHrefText">
								<xsl:with-param name="theInstanceID" select="$theSubjectInstance/name"/>
								<xsl:with-param name="theXML" select="$theXML"/>
								<xsl:with-param name="theUserParams" select="$userParams"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:variable>


						<xsl:text>&lt;a href = \&quot;</xsl:text>
						<xsl:value-of select="$linkText"/>
						<xsl:text>\&quot; class = \&quot;</xsl:text>
						<xsl:value-of select="$linkClass"/>
						<xsl:text>\&quot; id =\&quot;</xsl:text>
						<xsl:value-of select="$instanceId"/>
						<xsl:text>Link\&quot; &gt;</xsl:text>
						<xsl:call-template name="RenderInstanceLinkText">
							<xsl:with-param name="instanceName" select="$escapedInstanceName"/>
						</xsl:call-template>
						<xsl:text>&lt;/a&gt;</xsl:text>
					</xsl:when>
					<!-- If no menu is found, then just display the name of the instance without an anchor -->
					<xsl:otherwise>
						<xsl:call-template name="RenderInstanceLinkText">
							<xsl:with-param name="instanceName" select="$escapedInstanceName"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- Redact the instance name - user not cleared -->
				<xsl:value-of select="eas:i18n($theRedactedString)"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<xsl:template name="GenericInstanceLink">
		<xsl:param name="instance"/>
		<xsl:param name="theViewScopeTerms"/>

		<xsl:call-template name="RenderInstanceLink">
			<xsl:with-param name="theSubjectInstance" select="$instance"/>
			<xsl:with-param name="targetMenu" select="()"/>
			<xsl:with-param name="targetReport" select="()"/>
			<xsl:with-param name="viewScopeTerms" select="$theViewScopeTerms"/>
		</xsl:call-template>
	</xsl:template>


	<!-- 
        Generic template to render the description of an instance, taking into account the 
        language settings chosen by the user
    -->
	<xsl:template name="RenderMultiLangInstanceSlot">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="displaySlot"/>

		<!-- First perform user clearance check -->
		<xsl:choose>
			<xsl:when test="eas:isUserAuthZ($theSubjectInstance)">

				<xsl:value-of>
					<xsl:choose>
						<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
							<xsl:value-of select="$theSubjectInstance/own_slot_value[slot_reference = $displaySlot]/value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="instanceSynonym" select="$utilitiesAllSynonyms[(name = $theSubjectInstance/own_slot_value[slot_reference = 'synonyms']/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
							<xsl:choose>
								<xsl:when test="count($instanceSynonym) > 0">
									<xsl:value-of select="$instanceSynonym[1]/own_slot_value[slot_reference = $displaySlot]/value"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$theSubjectInstance/own_slot_value[slot_reference = $displaySlot]/value"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:value-of>

			</xsl:when>
			<xsl:otherwise>
				<!-- Redact the instance name - user not cleared -->
				<xsl:value-of select="eas:i18n($theRedactedString)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- 
        Generic template to render the description of an instance, taking into account the 
        language settings chosen by the user
    -->
	<xsl:template name="RenderMultiLangCommentarySlot">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="slotName"/>
		
		<xsl:choose>
			<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
				<xsl:value-of select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]/own_slot_value[slot_reference = 'name']/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="thisComment" select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]"/>
				<xsl:variable name="instanceSynonym" select="$utilitiesAllSynonyms[(name = $thisComment/own_slot_value[slot_reference = 'synonyms']/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
				<xsl:choose>
					<xsl:when test="count($instanceSynonym) > 0">
						<xsl:value-of select="$instanceSynonym[1]/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:function name="eas:getMultiLangCommentarySlot">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="slotName"/>
		
		<xsl:choose>
			<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
				<xsl:value-of select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]/own_slot_value[slot_reference = 'name']/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="thisComment" select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]"/>
				<xsl:variable name="instanceSynonym" select="$utilitiesAllSynonyms[(name = $thisComment/own_slot_value[slot_reference = 'synonyms']/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
				<xsl:choose>
					<xsl:when test="count($instanceSynonym) > 0">
						<xsl:value-of select="$instanceSynonym[1]/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<xsl:template name="RenderMultiLangCommentarySlotList">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="slotName"/>

		<ul>
			<xsl:for-each select="$utilitiesAllCommentaries[name = $theSubjectInstance/own_slot_value[slot_reference = $slotName]/value]">
				<xsl:choose>
					<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
						<li>
							<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="thisComment" select="current()"/>
						<xsl:variable name="instanceSynonym" select="$utilitiesAllSynonyms[(name = $thisComment/own_slot_value[slot_reference = 'synonyms']/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
						<xsl:choose>
							<xsl:when test="count($instanceSynonym) > 0">
								<li>
									<xsl:value-of select="$instanceSynonym[1]/own_slot_value[slot_reference = 'name']/value"/>
								</li>
							</xsl:when>
							<xsl:otherwise>
								<li>
									<xsl:value-of select="$thisComment/own_slot_value[slot_reference = 'name']/value"/>
								</li>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</ul>
	</xsl:template>


	<!-- 
        Generic template to render the description of an instance, taking into account the 
        language settings chosen by the user
    -->
	<xsl:template name="RenderMultiLangInstanceName">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="isRenderAsJSString" select="false()"/>
		<xsl:param name="isForJSONAPI" select="false()"/>
		
		<xsl:variable name="synForInstance" select="$utilitiesAllSynonyms[name = $theSubjectInstance/own_slot_value[slot_reference = 'synonyms']/value]"/>
		<xsl:variable name="instanceSynonym" select="$synForInstance[own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name]"/>
		<!-- First perform user clearance check -->
		<xsl:choose>
			<xsl:when test="eas:isUserAuthZ($theSubjectInstance)">
				<xsl:variable name="slotName">
					<xsl:call-template name="GetDisplaySlotForClass">
						<xsl:with-param name="theClass" select="$theSubjectInstance/type"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of>
					<xsl:choose>
						<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
							<xsl:variable name="thisName" select="$theSubjectInstance/own_slot_value[slot_reference = $slotName]/value"/>
							<xsl:choose>
								<xsl:when test="$isForJSONAPI">
									<xsl:value-of select="eas:renderJSAPIText($thisName)"/>
								</xsl:when>
								<xsl:when test="$isRenderAsJSString">
									<xsl:value-of select="eas:renderJSText($thisName)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$thisName"/>
								</xsl:otherwise>
							</xsl:choose>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="nameVal">						
								<xsl:choose>
									<xsl:when test="count($instanceSynonym) > 0">
										<xsl:value-of select="$instanceSynonym[1]/own_slot_value[slot_reference = 'name']/value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$theSubjectInstance/own_slot_value[slot_reference = $slotName]/value"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$isForJSONAPI">
									<xsl:value-of select="eas:renderJSAPIText($nameVal)"/>
								</xsl:when>
								<xsl:when test="$isRenderAsJSString">
									<xsl:value-of select="eas:renderJSText($nameVal)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$nameVal"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:value-of>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n($theRedactedString)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- 
        Generic template to render the description of an instance, taking into account the 
        language settings chosen by the user
    -->
	<xsl:template name="RenderMultiLangInstanceDescription">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="isRenderAsJSString" as="xs:boolean" select="false()"/>
		<xsl:param name="isForJSONAPI" as="xs:boolean" select="false()"/>
		
		<xsl:variable name="synForInstance" select="$utilitiesAllSynonyms[name = $theSubjectInstance/own_slot_value[slot_reference = 'synonyms']/value]"/>
		<xsl:variable name="instanceSynonym" select="$synForInstance[own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name]"/>
	

		<!-- First perform user clearance check -->
		<xsl:variable name="unprotectedText">
			<xsl:choose>
				<xsl:when test="eas:isUserAuthZ($theSubjectInstance)">
					<xsl:choose>
						<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
							<xsl:variable name="theInstance" select="replace($theSubjectInstance/own_slot_value[slot_reference = ('description', 'relation_description')]/value, '&#xA;', '&lt;br/&gt;')"/>
							<xsl:variable name="theInstance" select="replace($theInstance, '&#9;', '&#160;&#160;&#160;&#160;')"/>
							<xsl:value-of select="$theInstance" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count($instanceSynonym) > 0">
									<!--NW cascading replace-->
									<xsl:variable name="theInstance" select="replace($instanceSynonym[1]/own_slot_value[slot_reference = ('description', 'relation_description')]/value, '&#xA;', '&lt;br/&gt;')"/>
									<xsl:variable name="theInstance" select="replace($theInstance, '&#9;', '&#160;&#160;&#160;&#160;')"/>
									<xsl:value-of select="$theInstance" disable-output-escaping="yes"/>
									<!--<xsl:value-of select="replace($instanceSynonym[1]/own_slot_value[slot_reference = ('description', 'relation_description')]/value, '&#xA;', '&lt;br/&gt;')" disable-output-escaping="yes"/>-->
								</xsl:when>
								<xsl:otherwise>
									<!--NW cascading replace-->
									<xsl:variable name="theInstance" select="replace($theSubjectInstance/own_slot_value[slot_reference = ('description', 'relation_description')]/value, '&#xA;', '&lt;br/&gt;')"/>
									<xsl:variable name="theInstance" select="replace($theInstance, '&#9;', '&#160;&#160;&#160;&#160;')"/>
									<xsl:value-of select="$theInstance" disable-output-escaping="yes"/>
									<!--<xsl:value-of select="replace($theSubjectInstance/own_slot_value[slot_reference = ('description', 'relation_description')]/value, '&#xA;', '&lt;br/&gt;')" disable-output-escaping="yes"/>-->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eas:i18n($theRedactedString)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
        <xsl:choose>
        	<xsl:when test="$isForJSONAPI">
        		<xsl:value-of select="eas:renderJSAPIText($unprotectedText)"/>
        	</xsl:when>
			<xsl:when test="$isRenderAsJSString">
				<xsl:value-of select="eas:renderJSText($unprotectedText)"/>
			</xsl:when>
            <xsl:otherwise><xsl:value-of select="$unprotectedText" disable-output-escaping="yes"></xsl:value-of></xsl:otherwise>
        </xsl:choose>
		<!--<xsl:value-of select="if ($isRenderAsJSString) then eas:renderJSText($unprotectedText) else $unprotectedText" disable-output-escaping="yes"/>-->
		<!--<xsl:value-of select="if ($isRenderAsJSString) then eas:validJSONString($unprotectedText) else $unprotectedText" disable-output-escaping="yes"/>-->
		
	</xsl:template>
	
	
	<xsl:template name="RenderMultiLangInstanceDescriptionForJSON">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="isRenderAsJSString" as="xs:boolean" select="false()"/>
		
		
		<xsl:variable name="synForInstance" select="$utilitiesAllSynonyms[name = $theSubjectInstance/own_slot_value[slot_reference = 'synonyms']/value]"/>
		<xsl:variable name="instanceSynonym" select="$synForInstance[own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name]"/>
		
		<!-- First perform user clearance check -->
		<xsl:variable name="unprotectedText">
			<xsl:choose>
				<xsl:when test="eas:isUserAuthZ($theSubjectInstance)">
					<xsl:choose>
						<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
							<xsl:value-of select="replace(normalize-space($theSubjectInstance/own_slot_value[slot_reference = ('description', 'relation_description')]/value), '&#xA;', '&lt;br/&gt;')" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count($instanceSynonym) > 0">
									
									<xsl:value-of select="replace(normalize-space($instanceSynonym[1]/own_slot_value[slot_reference = ('description', 'relation_description')]/value), '&#xA;', '&lt;br/&gt;')" disable-output-escaping="yes"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="replace(normalize-space($theSubjectInstance/own_slot_value[slot_reference = ('description', 'relation_description')]/value), '&#xA;', '&lt;br/&gt;')" disable-output-escaping="yes"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eas:i18n($theRedactedString)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:value-of select="if ($isRenderAsJSString) then eas:renderJSText($unprotectedText) else $unprotectedText" disable-output-escaping="yes"/>-->
		<!--<xsl:value-of select="if ($isRenderAsJSString) then eas:validJSONString($unprotectedText) else $unprotectedText" disable-output-escaping="yes"/>-->
		<xsl:value-of select="$unprotectedText" disable-output-escaping="yes"></xsl:value-of>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE QUERY STRING FOR DRILLING DOWN TO A REPORT -->
	<xsl:template name="ConstructPopUpQueryString">
		<xsl:param name="viewScopeTerms" select="()"/>
		<xsl:param name="theInstance"/>

		<xsl:variable name="viewScopeQueryString" select="eas:queryStringForInstanceIds($viewScopeTerms, '')"/>

		<xsl:text>&amp;PMA=</xsl:text>
		<xsl:value-of select="$theInstance/name"/>
		<xsl:text>&amp;viewScopeTerms=</xsl:text>
		<xsl:value-of select="$viewScopeQueryString"/>
	</xsl:template>


	<!-- TEMPLATE TO CREATE THE QUERY STRING FOR DRILLING DOWN TO AN APPLICATION -->
	<xsl:template name="RenderInstanceLinkText">
		<xsl:param name="instanceName"/>
		<xsl:param name="divClass"/>
		<xsl:param name="divStyle"/>
		<xsl:param name="divId"/>
		<xsl:param name="isRenderAsJSString" as="xs:boolean" select="false()"/>
		
		<xsl:variable name="renderedInstanceName" select="$instanceName"/>

		<xsl:choose>
			<xsl:when test="string-length($divClass) > 0">
				<div>
					<xsl:attribute name="class" select="$divClass"/>
					<xsl:attribute name="style" select="$divStyle"/>
					<xsl:attribute name="id" select="$divId"/>
					<xsl:value-of select="$renderedInstanceName"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$renderedInstanceName"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<!-- GENERIC TEMPLATE TO PRINT OUT A DATE -->
	<xsl:template name="Date">
		<xsl:param name="aDate"/>
		<xsl:variable name="year" select="$aDate/own_slot_value[slot_reference = 'time_year']/value"/>
		<xsl:choose>
			<xsl:when test="$aDate/type = 'Year'">
				<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:when test="$aDate/type = 'Quarter'">
				<xsl:value-of select="$year"/>
				<xsl:text>&#32;(</xsl:text>
				<xsl:value-of select="$aDate/own_slot_value[slot_reference = 'time_quarter']/value"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
			<xsl:when test="$aDate/type = 'Gregorian'">
				<xsl:value-of select="$year"/>
				<xsl:text>&#32;(</xsl:text>
				<xsl:value-of select="$aDate/own_slot_value[slot_reference = 'time_day']/value"/>
				<xsl:text>&#32;</xsl:text>
				<xsl:value-of select="$aDate/own_slot_value[slot_reference = 'time_month']/value"/>
				<xsl:text>)</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- GENERIC TEMPLATE TO PRINT OUT THE NAME OF AN ELEMENT AS A BULLETED LIST ITEM -->
	<xsl:template match="node()" mode="NameBulletItem">
		<li>
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
		</li>
	</xsl:template>


	<!-- TEMPLATE TO CREATE AN EMPTY UML DIAGRAM -->
	<!-- <xsl:template name="RenderEmptyUMLModel">
        <xsl:param name="message" /> @startuml hide empty members hide circle class noData as "<xsl:value-of select="$message" />" skinparam svek false skinparam packageStyle rect skinparam classBackgroundColor #ffffff skinparam classBorderColor #ffffff skinparam classFontColor #333333 skinparam classFontSize 11 skinparam classFontName Arial @enduml </xsl:template>
   -->
	<xsl:template name="RenderEmptyUMLModel">
		<xsl:param name="message"/> @startuml hide empty members hide circle class noData as "<xsl:value-of select="$message"/>" skinparam svek true skinparam shadowing false skinparam packageStyle rect skinparam classBackgroundColor #ffffff skinparam classBorderColor #ffffff skinparam classFontColor #333333 skinparam classFontSize 14 skinparam classFontName Arial @enduml </xsl:template>



	<!-- FUNCTION TO RETRIEVE THE LIST OF CHILD ACTORS FOR A GIVEN ACTOR, INCLUDING THE GIVEN ACTOR -->
	<xsl:function name="eas:get_actor_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeOrgs"/>

		<xsl:copy-of select="$parentNode"/>
		<xsl:variable name="childOrgs" select="$inScopeOrgs[name = $parentNode/own_slot_value[slot_reference = 'contained_sub_actors']/value]" as="node()*"/>
		<xsl:for-each select="$childOrgs">
			<xsl:copy-of select="eas:get_actor_descendants(current(), $inScopeOrgs)"/>
		</xsl:for-each>
	</xsl:function>


	<!-- FUNCTION TO RETRIEVE THE LIST OF CHILD ROLES FOR A GIVEN ROLE, INCLUDING THE GIVEN ROLE -->
	<xsl:function name="eas:get_role_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeRoles"/>

		<xsl:copy-of select="$parentNode"/>
		<xsl:variable name="childRoles" select="$inScopeRoles[own_slot_value[slot_reference = 'contained_sub_actors']/value = $parentNode/name]" as="node()*"/>
		<xsl:for-each select="$childRoles">
			<xsl:copy-of select="eas:get_role_descendants(current(), $inScopeRoles)"/>
		</xsl:for-each>
	</xsl:function>


	<!-- FUNCTION TO CONVERT AN ESSENTIAL PROJECT TIME INSTANCE TO AN XSLT DATE -->
	<xsl:function name="eas:get_date_for_essential_time" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Year'">
				<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'name']/value, '1', '1')"/>
			</xsl:when>
			<xsl:when test="$aTime/type = 'Quarter'">
				<xsl:variable name="timeQuarter" select="$aTime/own_slot_value[slot_reference = 'time_quarter']/value"/>
				<xsl:choose>
					<xsl:when test="$timeQuarter = 'Q1'">
						<xsl:variable name="month" select="'3'"/>
						<xsl:variable name="day" select="'31'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q2'">
						<xsl:variable name="month" select="'6'"/>
						<xsl:variable name="day" select="'30'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q3'">
						<xsl:variable name="month" select="'9'"/>
						<xsl:variable name="day" select="'30'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q4'">
						<xsl:variable name="month" select="'12'"/>
						<xsl:variable name="day" select="'31'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="current-date()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$aTime/type = 'Gregorian'">
				<xsl:variable name="year" select="$aTime/own_slot_value[slot_reference = 'time_year']/value"/>
				<xsl:variable name="month" select="$aTime/own_slot_value[slot_reference = 'time_month']/value"/>
				<xsl:variable name="day" select="$aTime/own_slot_value[slot_reference = 'time_day']/value"/>
				<xsl:value-of select="functx:date($year, $month, $day)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<!-- FUNCTION TO CONVERT AN ESSENTIAL START DATE TO AN XSLT DATE -->
	<xsl:function name="eas:get_start_date_for_essential_time" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Year'">
				<xsl:value-of select="eas:get_essential_year_start($aTime)"/>
			</xsl:when>
			<xsl:when test="$aTime/type = 'Quarter'">
				<xsl:value-of select="eas:get_essential_quarter_start($aTime)"/>
			</xsl:when>
			<xsl:when test="$aTime/type = 'Gregorian'">
				<xsl:variable name="year" select="$aTime/own_slot_value[slot_reference = 'time_year']/value"/>
				<xsl:variable name="month" select="$aTime/own_slot_value[slot_reference = 'time_month']/value"/>
				<xsl:variable name="day" select="$aTime/own_slot_value[slot_reference = 'time_day']/value"/>
				<xsl:value-of select="functx:date($year, $month, $day)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<!-- FUNCTION TO CONVERT AN ESSENTIAL END DATE TO AN XSLT DATE -->
	<xsl:function name="eas:get_end_date_for_essential_time" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Year'">
				<xsl:value-of select="eas:get_essential_year_end($aTime)"/>
			</xsl:when>
			<xsl:when test="$aTime/type = 'Quarter'">
				<xsl:value-of select="eas:get_essential_quarter_end($aTime)"/>
			</xsl:when>
			<xsl:when test="$aTime/type = 'Gregorian'">
				<xsl:variable name="year" select="$aTime/own_slot_value[slot_reference = 'time_year']/value"/>
				<xsl:variable name="month" select="$aTime/own_slot_value[slot_reference = 'time_month']/value"/>
				<xsl:variable name="day" select="$aTime/own_slot_value[slot_reference = 'time_day']/value"/>
				<xsl:value-of select="functx:date($year, $month, $day)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<!-- FUNCTION TO PROVIDE THE START DATE FOR A YEAR -->
	<xsl:function name="eas:get_essential_year_start" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Year'">
				<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, '1', '1')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- FUNCTION TO PROVIDE THE END DATE FOR A YEAR -->
	<xsl:function name="eas:get_essential_year_end" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Year'">
				<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, '12', '31')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<!-- FUNCTION TO PROVIDE THE END DATE FOR A QUARTER -->
	<xsl:function name="eas:get_essential_quarter_end" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Quarter'">
				<xsl:variable name="timeQuarter" select="$aTime/own_slot_value[slot_reference = 'time_quarter']/value"/>
				<xsl:choose>
					<xsl:when test="$timeQuarter = 'Q1'">
						<xsl:variable name="month" select="'3'"/>
						<xsl:variable name="day" select="'31'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q2'">
						<xsl:variable name="month" select="'6'"/>
						<xsl:variable name="day" select="'30'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q3'">
						<xsl:variable name="month" select="'9'"/>
						<xsl:variable name="day" select="'30'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q4'">
						<xsl:variable name="month" select="'12'"/>
						<xsl:variable name="day" select="'31'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="current-date()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- FUNCTION TO PROVIDE THE START DATE FOR A QUARTER -->
	<xsl:function name="eas:get_essential_quarter_start" as="xs:date">
		<xsl:param name="aTime"/>

		<xsl:choose>
			<xsl:when test="$aTime/type = 'Quarter'">
				<xsl:variable name="timeQuarter" select="$aTime/own_slot_value[slot_reference = 'time_quarter']/value"/>
				<xsl:choose>
					<xsl:when test="$timeQuarter = 'Q1'">
						<xsl:variable name="month" select="'1'"/>
						<xsl:variable name="day" select="'1'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q2'">
						<xsl:variable name="month" select="'4'"/>
						<xsl:variable name="day" select="'1'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q3'">
						<xsl:variable name="month" select="'7'"/>
						<xsl:variable name="day" select="'1'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:when test="$timeQuarter = 'Q4'">
						<xsl:variable name="month" select="'10'"/>
						<xsl:variable name="day" select="'1'"/>
						<xsl:value-of select="functx:date($aTime/own_slot_value[slot_reference = 'time_year']/value, $month, $day)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="current-date()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="current-date()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<!-- FUNCTION TO RETRIEVE THE CURRENT ARCHITECTURE STATE FOR A GIVEN ROADMAP -->
	<xsl:function name="eas:get_current_architecture_state" as="node()*">
		<xsl:param name="aRoadmap"/>
		<xsl:param name="allMilestones"/>
		<xsl:param name="allArchitectureStates"/>
		<xsl:param name="allDates"/>

		<xsl:variable name="roadmapMilestones" select="$allMilestones[own_slot_value[slot_reference = 'used_in_roadmap_model']/value = $aRoadmap/name]"/>
		<xsl:variable name="roadmapArchStates" select="$allArchitectureStates[name = $roadmapMilestones/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>

		<xsl:variable name="currentDate" select="current-date()"/>
		<xsl:for-each select="$roadmapArchStates">
			<xsl:variable name="startDate" select="eas:get_start_date_for_essential_time($allDates[name = current()/own_slot_value[slot_reference = 'start_date']/value])"/>
			<xsl:variable name="endDate" select="eas:get_end_date_for_essential_time($allDates[name = current()/own_slot_value[slot_reference = 'end_date']/value])"/>
			<xsl:if test="($startDate &lt; $currentDate) and ($endDate >= $currentDate)">
				<xsl:copy-of select="current()"/>
			</xsl:if>
		</xsl:for-each>

	</xsl:function>


	<!-- RECURSIVE TEMPLATE TO RETRIEVE THE A LIST ARCHITECTURE STATES IN SEQUENCE FOR A GIVEN ROADMAP -->
	<xsl:template name="GetRoadmapArchitectureStatesSequence" as="node()*">
		<xsl:param name="currentNode"/>
		<xsl:param name="relevantMilestones"/>
		<xsl:param name="relevantArchitectureStates"/>
		<xsl:param name="relevantRoadmapRelations"/>
		<xsl:param name="archStateList"/>

		<xsl:variable name="currentRoadmapRelation" select="$relevantRoadmapRelations[own_slot_value[slot_reference = ':FROM']/value = $currentNode]"/>
		<xsl:variable name="nextNode" select="$relevantMilestones[name = $currentRoadmapRelation/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:choose>
			<xsl:when test="($nextNode/type = 'Roadmap_Milestone') and (count($relevantRoadmapRelations) > 0)">
				<xsl:variable name="nextArchState" select="$relevantArchitectureStates[name = $nextNode/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
				<xsl:variable name="updatedArchStateList" select="$archStateList union $nextArchState"/>
				<xsl:variable name="updatedRelationList" select="$relevantRoadmapRelations except $currentRoadmapRelation"/>
				<xsl:call-template name="GetRoadmapArchitectureStatesSequence">
					<xsl:with-param name="archStateList" select="$updatedArchStateList"/>
					<xsl:with-param name="relevantArchitectureStates" select="$relevantArchitectureStates"/>
					<xsl:with-param name="relevantRoadmapRelations" select="$updatedRelationList"/>
					<xsl:with-param name="relevantMilestones" select="$relevantMilestones"/>
					<xsl:with-param name="currentNode" select="$nextNode"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$archStateList"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- RECURSIVE FUNCTION TO RETRIEVE THE A LIST ARCHITECTURE STATES IN SEQUENCE FOR A GIVEN ROADMAP -->
	<xsl:function name="eas:get_roadmap_arch_states_sequence" as="node()*">
		<xsl:param name="currentNode"/>
		<xsl:param name="relevantMilestones"/>
		<xsl:param name="relevantArchitectureStates"/>
		<xsl:param name="relevantRoadmapRelations"/>
		<xsl:param name="archStateList"/>

		<xsl:variable name="currentRoadmapRelation" select="$relevantRoadmapRelations[own_slot_value[slot_reference = ':FROM']/value = $currentNode/name]"/>
		<xsl:variable name="nextNode" select="$relevantMilestones[name = $currentRoadmapRelation/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:choose>
			<xsl:when test="($nextNode/type = 'Roadmap_Milestone') and (count($relevantRoadmapRelations) > 0)">
				<xsl:variable name="updatedRelationList" select="$relevantRoadmapRelations except $currentRoadmapRelation"/>
				<xsl:choose>
					<xsl:when test="$nextNode/type = 'Roadmap_Milestone'">
						<xsl:variable name="nextArchState" select="$relevantArchitectureStates[name = $nextNode/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
						<xsl:variable name="updatedArchStateList" select="insert-before($archStateList, 0, $nextArchState)"/>
						<xsl:copy-of select="eas:get_roadmap_arch_states_sequence($nextNode, $relevantMilestones, $relevantArchitectureStates, $updatedRelationList, $updatedArchStateList)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="eas:get_roadmap_arch_states_sequence($nextNode, $relevantMilestones, $relevantArchitectureStates, $updatedRelationList, $archStateList)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="reverse($archStateList)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>



	<!-- SIMPLE FUNCTION TO RETURN THE FULL FORMAT FOR A DATE -->
	<xsl:template name="FullFormatDate">
		<xsl:param name="theDate" as="xs:date"/>
		<xsl:variable name="drFormattedDate" select="format-date($theDate, '[D1o] [MNn], [Y]')"/>
		<xsl:value-of select="$drFormattedDate"/>
	</xsl:template>


	<!-- SIMPLE FUNCTION TO RETURN A DATE FORMATTED FOR JAVASCRIPT -->
	<xsl:template name="JSFormatDate">
		<xsl:param name="theDate" as="xs:date"/>
		<xsl:variable name="drFormattedDate" select="format-date($theDate, '[Y1]-[M01]-[D01]')"/>
		<xsl:value-of select="$drFormattedDate"/>
	</xsl:template>

	<!-- SIMPLE FUNCTION TO RETURN AN ABBREVIATED FORMAT FOR A DATE -->
	<xsl:template name="AbbrevFormatDate">
		<xsl:param name="theDate" as="xs:date"/>
		<xsl:variable name="drFormattedDate" select="format-date($theDate, '[D1] [MNn,3-3] [Y]')"/>
		<xsl:value-of select="$drFormattedDate"/>
	</xsl:template>


	<!-- SIMPLE FUNCTION TO STRIP SPECIAL CHARACTERS FROM A GIVEN STRING -->
	<xsl:function name="eas:stripSpecialChars" as="xs:string">
		<xsl:param name="originalString"/>
		<xsl:value-of select="replace($originalString, '[^a-zA-Z0-9]', '')"/>
	</xsl:function>


	<!-- FUNCTION TO CREATE A SINGLE STRING CONTAINING TAXONOMY TERM IDS BE TO PASSED AS PART OF A QUERY STRING  -->
	<xsl:function name="eas:queryStringForScopeTerms" as="xs:string">
		<xsl:param name="scopingTerms"/>

		<xsl:choose>
			<xsl:when test="count($scopingTerms) > 0">
				<xsl:for-each select="$scopingTerms">
					<xsl:variable name="termId" select="current()/name"/>
					<xsl:value-of select="$termId"/>
					<xsl:if test="not(index = count($scopingTerms))">
						<xsl:value-of select="$instanceIdDelim"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<!-- FUNCTION TO CREATE A SINGLE STRING CONTAINING INSTANCE IDS BE TO PASSED AS PART OF A QUERY STRING  -->
	<xsl:function name="eas:queryStringForInstanceIds" as="xs:string">
		<xsl:param name="instances"/>
		<xsl:param name="queryString"/>

		<xsl:variable name="instancesSize" select="count($instances)"/>
		<xsl:choose>
			<xsl:when test="$instancesSize > 0">
				<xsl:variable name="nextInstance" select="$instances[1]"/>
				<xsl:variable name="instanceId" select="$nextInstance/name"/>
				<xsl:variable name="newQueryString" select="concat($queryString, $instanceId)"/>
				<xsl:choose>
					<xsl:when test="$instancesSize > 1">
						<xsl:value-of select="eas:queryStringForInstanceIds($instances except $nextInstance, concat($newQueryString, $instanceIdDelim))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$newQueryString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$queryString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>




	<!-- FUNCTION TO RETRIEVE A SET OF TAXONOMY TERMS FROM A GIVEN QUERY STRING -->
	<xsl:function name="eas:get_scoping_terms_from_string" as="node()*">
		<xsl:param name="scopingTermString"/>

		<xsl:variable name="termIds" select="tokenize($scopingTermString, $instanceIdDelim)"/>
		<xsl:for-each select="$termIds">
			<xsl:copy-of select="$utilitiesAllTaxonomyTerms[name = current()]"/>
		</xsl:for-each>

	</xsl:function>

	<!-- FUNCTION TO RETRIEVE THE APPROPROATE MENU FOR A GIVEN INSTANCE -->
	<xsl:function name="eas:get_default_menu_for_instance" as="node()*">
		<xsl:param name="instance"/>

		<xsl:variable name="defaultMenu" select="$utilitiesAllMenus[(own_slot_value[slot_reference = 'report_menu_class']/value = $instance/type) and (own_slot_value[slot_reference = 'report_menu_is_default']/value = 'true')]"/>
		<xsl:variable name="instanceTaxTerms" select="$utilitiesAllTaxonomyTerms[name = $instance/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		<xsl:choose>
			<xsl:when test="count($defaultMenu) = 1">
				<xsl:variable name="menuTerms" select="$utilitiesAllTaxonomyTerms[name = $defaultMenu/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
				<xsl:choose>
					<xsl:when test="count($menuTerms) > 0">
						<xsl:variable name="instanceTerms" select="$utilitiesAllTaxonomyTerms[name = $instance/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
						<xsl:choose>
							<xsl:when test="count($menuTerms intersect $instanceTerms) > 0">
								<xsl:copy-of select="$defaultMenu[1]"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$defaultMenu[1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($defaultMenu) > 1">
				<xsl:choose>
					<xsl:when test="count($utilitiesAllTaxonomyTerms[name = $defaultMenu/own_slot_value[slot_reference = 'element_classified_by']/value]) > 0">
						<xsl:for-each select="$defaultMenu">
							<xsl:variable name="menuTerms" select="$utilitiesAllTaxonomyTerms[name = current()/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
							<xsl:choose>
								<xsl:when test="count($menuTerms intersect $instanceTaxTerms) > 0">
									<xsl:copy-of select="current()"/>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$defaultMenu[1]"/>
					</xsl:otherwise>
				</xsl:choose>




				<!--<xsl:variable name="filteredMenu" select="$defaultMenu[count(own_slot_value[slot_reference='element_classified_by']/value intersect $instance/own_slot_value[slot_reference='element_classified_by']/value) > 0]"/>
                <xsl:choose>
                    <xsl:when test="count($filteredMenu) = 1">
                        <xsl:copy-of select="$filteredMenu" />
                    </xsl:when>
                    <xsl:otherwise><xsl:copy-of select="$defaultMenu[1]"/></xsl:otherwise>
                </xsl:choose>      -->
			</xsl:when>
		</xsl:choose>
	</xsl:function>

	<!--    <!-\- FUNCTION TO PERFORM i18n on the specified static text -\->
    <xsl:function name="eas:i18n" as="xs:string">
        <xsl:param name="theText"/>

        <xsl:choose>
            <xsl:when test="not($languageFile//easlang:language)">
                <xsl:value-of select="$theText"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="aTranslation" select="$languageFile//easlang:message[easlang:name=$theText]/easlang:value"/>

                <!-\-<xsl:choose>
                    <xsl:when test="not(string($aTranslation))">
                        <xsl:value-of select="$theText"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$aTranslation"/>
                    </xsl:otherwise>
                </xsl:choose>-\->
                
                <xsl:choose>
                    <xsl:when test="count($aTranslation) > 1">
                        <xsl:value-of select="$aTranslation[1]"></xsl:value-of>
                    </xsl:when>
                    <xsl:when test="not(string($aTranslation))">
                        <xsl:value-of select="$theText"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$aTranslation"/>
                    </xsl:otherwise>
                </xsl:choose>
                
                
                
            </xsl:otherwise>
        </xsl:choose>
       </xsl:function>
-->
	<!-- FUNCTION TO PERFORM i18n on the specified static text -->
	<xsl:function name="eas:i18n" as="xs:string">
		<xsl:param name="theText"/>

		<xsl:choose>
			<xsl:when test="not($languageFile//easlang:language)">
				<xsl:value-of select="$theText"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="aTranslation" select="$languageFile//easlang:message[easlang:name = $theText]/easlang:value"/>

				<xsl:choose>
					<xsl:when test="count($aTranslation) > 1">
						<xsl:variable name="firstTrans" select="$aTranslation[1]"/>
						<xsl:value-of select="eas:renderTranslation($firstTrans, $theText)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="eas:renderTranslation($aTranslation, $theText)"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<!-- FUNCTION TO RENDER THE TEXT FOR A TRANSLATION OR THE NAME KEY IF TRANSLATION IS EMPTY -->
	<xsl:function name="eas:renderTranslation" as="xs:string">
		<xsl:param name="theTranslation"/>
		<xsl:param name="theText"/>
		<xsl:choose>
			<xsl:when test="not(string($theTranslation))">
				<xsl:value-of select="$theText"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$theTranslation"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>



	<!-- FUNCTION TO RENDER TEXT FOR JAVASCRIPT WITH ESCAPED QUOTES -->
	<xsl:function name="eas:renderJSText" as="xs:string">
		<xsl:param name="theText"/>
		<xsl:variable name="apos">'</xsl:variable>
		<xsl:variable name="quote">"</xsl:variable>
		<xsl:variable name="openBracket">Y</xsl:variable>
		<xsl:variable name="closeBracket">Y</xsl:variable>
		<xsl:variable name="escapeApos">\\'</xsl:variable>
		<xsl:variable name="escapeQuote">\\"</xsl:variable>
		<xsl:variable name="escapeOpenBracket">M</xsl:variable>
		<xsl:variable name="escapeCloseBracket">N</xsl:variable>

		<xsl:variable name="ecsapeBackslashes" select="replace($theText, '\\','')"/>
		<!--<xsl:variable name="anAposEscapedText" select="replace($ecsapeBackslashes, $apos, $escapeApos)"/>-->
		<xsl:variable name="anQuoteAndAposEscapedText" select="replace($ecsapeBackslashes, $quote, $escapeQuote)"/>
		<!-- <xsl:variable name="escapeBrackets" select="replace($anQuoteAndAposEscapedText, '(\(|\))', '\\$1')"/> -->
		<!--<xsl:variable name="escapeAmpersand" select="replace($anQuoteAndAposEscapedText, '&amp;', 'and')"/>-->
		<xsl:variable name="escapeSpace" select="replace($anQuoteAndAposEscapedText, '&#160;', ' ')"/>
		<xsl:variable name="escapeNewline" select="replace($escapeSpace, '\n|&#xA;', '\\n')"/>	
		<xsl:variable name="escapeCarriageReturn" select="replace($escapeNewline, '\r|&#13;|&#xD;', '\\r')"/>
		<xsl:variable name="escapeTab" select="replace($escapeCarriageReturn, '&#9;|\t', '&#160;&#160;&#160;&#160;')"/>

		<!-- Escape newlines with <br/> -->
		<xsl:value-of select="$escapeTab"/>

	</xsl:function>
	
	
	
	<!-- FUNCTION TO RENDER TEXT FOR JAVASCRIPT WITH ESCAPED QUOTES -->
	<xsl:function name="eas:renderJSAPIText" as="xs:string">
		<xsl:param name="theText"/>
		
		<xsl:variable name="ecsapeBackslash" select="replace($theText, '\\','\\\\')"/>
		<!--<xsl:variable name="ecsapeBackslashP" select="replace($theText, '\\p','\\\\p')"/>-->
		<xsl:variable name="escapeCR" select="replace($ecsapeBackslash, '\r|&#13;|&#xD;', '\\r')"/>
		<xsl:variable name="escapeQuoteAndApos">
			<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$escapeCR"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="escapeTab" select="replace($escapeQuoteAndApos, '&#9;|\t', '&#160;&#160;&#160;&#160;')"/>
		
		
		<!-- Escape newlines with <br/> -->
		<xsl:value-of select="$escapeTab"/>
		
	</xsl:function>
	
	<xsl:template name="escapeQuote">
		<xsl:param name="pText" select="."/>
		
		<xsl:if test="string-length($pText) >0">
			<xsl:value-of select=
				"substring-before(concat($pText, '&quot;'), '&quot;')"/>
			
			<xsl:if test="contains($pText, '&quot;')">
				<xsl:text>\"</xsl:text>
				
				<xsl:call-template name="escapeQuote">
					<xsl:with-param name="pText" select=
						"substring-after($pText, '&quot;')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="GetDisplaySlotForClass">
		<xsl:param name="theClass"/>

		<xsl:choose>
			<xsl:when test="$theClass = 'Information_View'">view_label</xsl:when>
			<xsl:when test="$theClass = 'Lifecycle_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Project_Lifecycle_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Codebase_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Deployment_Role'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Project_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Standardisation_Level'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Business_Criticality'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Deployment_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Planning_Action'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Planning_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Application_Purpose'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Application_Delivery_Model'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Project_Lifecycle_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Project_Approval_Status'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Requirement_Impact'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Secured_Action'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Report'">report_label</xsl:when>
			<xsl:when test="$theClass = 'Editor'">report_label</xsl:when>
			<xsl:when test="$theClass = 'Simple_Editor'">report_label</xsl:when>
			<xsl:when test="$theClass = 'Taxonomy_Term'">taxonomy_term_label</xsl:when>
			<xsl:when test="$theClass = 'Taxonomy'">taxonomy_display_label</xsl:when>
			<xsl:when test="$theClass = 'Issue_Category'">enumeration_value</xsl:when>
			<xsl:when test="$theClass = 'Business_Process_Flow_Decision'">business_process_arch_display_label</xsl:when>
			<xsl:when test="$theClass = 'Data_Representation'">dr_technical_name</xsl:when>
			<xsl:when test="$theClass = 'Data_Representation_Attribute'">dra_technical_name</xsl:when>
			<xsl:when test="$theClass = 'Data_Object_Attribute'">data_attribute_label</xsl:when>
			<xsl:when test="$theClass = 'Portal'">portal_label</xsl:when>
			<xsl:when test="$theClass = 'Portal_Section'">portal_section_label</xsl:when>
			<xsl:when test="$theClass = 'Portal_Panel'">portal_panel_label</xsl:when>
			<xsl:when test="$theClass = 'Portal_Panel_Section'">portal_panel_section_label</xsl:when>
			<xsl:otherwise>name</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="PrintDropdownScript">
		<xsl:param name="dropDownName"/>
		<xsl:param name="queryStringPrefix"/>
		<xsl:param name="dropDownList"/>
		<xsl:param name="selectedItemId"/>
		<xsl:param name="formWidth"/>
		<xsl:param name="addAll">'false'</xsl:param>
        <xsl:param name="addInitItem"/>
		<xsl:param name="reverse"/>
		<xsl:param name="orderSlot">name</xsl:param>
		<xsl:param name="noneSelectTitle"/>
		<xsl:param name="formClass" select="$formWidth"/>
		<xsl:param name="selectStyle"/>
		<script>
            $(document).ready(function(){
            // bind change event to select
            $('#<xsl:value-of select="$dropDownName"/>').bind('change', function () {
            var url = "<xsl:value-of select="$queryStringPrefix"/>" + $(this).val(); // get selected value
            if (url) { // require a URL
            window.location = url; // redirect
            }
            return false;
            });
            });
        </script>
		<form class="{$formClass}">
			<xsl:choose>
				<xsl:when test="count($dropDownList) > 0">
					<select class="{$formWidth}">
						<xsl:attribute name="id" select="$dropDownName"/>
						<xsl:attribute name="style" select="$selectStyle"/>
						<xsl:if test="string-length($noneSelectTitle) > 0">
							<option value="">
								<xsl:value-of select="$noneSelectTitle"/>
							</option>
						</xsl:if>
						<xsl:if test="$addAll = 'true'">
							<option value="">
								<xsl:if test="string-length($selectedItemId) = 0">
									<xsl:attribute name="selected" select="'selected'"/>
								</xsl:if>
								<xsl:value-of select="eas:i18n('All')"/>
							</option>
						</xsl:if>
                        <xsl:if test="(string-length($addInitItem) > 0) and (string-length($selectedItemId) = 0)">
                            <option value ="">
                                <xsl:attribute name="selected" select="'selected'"/>
                                <xsl:value-of select="$addInitItem"/>
                            </option>
                        </xsl:if>
						<xsl:choose>
							<xsl:when test="string-length($reverse) > 0">
								<xsl:for-each select="$dropDownList">
									<xsl:sort order="descending" select="own_slot_value[slot_reference = $orderSlot]/value"/>
									<option>
										<xsl:attribute name="value" select="current()/name"/>
										<xsl:if test="current()/name = $selectedItemId">
											<xsl:attribute name="selected" select="'selected'"/>
										</xsl:if>
										<xsl:call-template name="RenderMultiLangInstanceName">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
										</xsl:call-template>
									</option>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$dropDownList">
									<xsl:sort select="own_slot_value[slot_reference = $orderSlot]/value"/>
									<option>
										<xsl:attribute name="value" select="current()/name"/>
										<xsl:if test="current()/name = $selectedItemId">
											<xsl:attribute name="selected" select="'selected'"/>
										</xsl:if>
										<xsl:call-template name="RenderMultiLangInstanceName">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
										</xsl:call-template>
									</option>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>

						<!--<xsl:for-each select="$dropDownList">   
                            <xsl:sort select="own_slot_value[slot_reference='name']/value"/>
                            <option>
                                <xsl:attribute name="value" select="current()/name"/>
                                <xsl:if test="current()/name = $selectedItemId">
                                    <xsl:attribute name="selected" select="'selected'"/>
                                </xsl:if>
                                <xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
                            </option>
                        </xsl:for-each>-->
					</select>
				</xsl:when>
				<xsl:otherwise>
					<select class="{$formWidth}" disabled="disabled">
						<xsl:attribute name="id" select="$dropDownName"/>
					</select>
				</xsl:otherwise>
			</xsl:choose>

		</form>
	</xsl:template>


	<xsl:template name="PrintCheckboxScript">
		<xsl:param name="checkboxName"/>
		<xsl:param name="queryString"/>
		<xsl:param name="checkboxLabel"/>
		<xsl:param name="isSelected"/>
		<xsl:param name="formWidth"/>
		<script>
            $(document).ready(function(){
            // bind change event to select
            $('#<xsl:value-of select="$checkboxName"/>').bind('change', function () {
            var url = "<xsl:value-of select="$queryString"/>"; // get selected value
        	$("#checkboxLoading").show();       	
            if (url) { // require a URL
            window.location = url; // redirect
            }
            return false;
            });
            });
        </script>
		<form class="{$formWidth}">
			<input type="checkbox">
				<xsl:attribute name="id" select="$checkboxName"/>
				<xsl:attribute name="name" select="$checkboxName"/>
				<xsl:if test="string-length($isSelected) = 0">
					<xsl:attribute name="checked" select="'checked'"/>
				</xsl:if>
				<label>
					<xsl:attribute name="for" select="$checkboxName"/>
					<xsl:value-of select="$checkboxLabel"/>
				</label>
			</input>
		</form>
		<div id="checkboxLoading" class="hidden">
			<p class="fontBlack xlarge">Refreshing Page. Please Wait...</p>
		</div>
	</xsl:template>


	<xsl:template name="RenderElementListAsBullets">
		<xsl:param name="elements"/>
		<xsl:param name="reposXML">reportXML.xml</xsl:param>
		<xsl:param name="emptyMessage">No comments captured</xsl:param>

		<xsl:choose>
			<xsl:when test="count($elements) = 0">
				<p>
					<em>
						<xsl:value-of select="$emptyMessage"/>
					</em>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:for-each select="$elements">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="()"/>
							</xsl:call-template>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- FUNCTION TO RETRIEVE THE LIST OF CHILD OBJECTS FOR A GIVEN OBJECT, INCLUDING THE GIVEN OBJECT ITSELF -->
	<xsl:function name="eas:get_object_descendants" as="node()*">
		<xsl:param name="parentNode"/>
		<xsl:param name="inScopeOrgs"/>
		<xsl:param name="level"/>
		<xsl:param name="maxDepth"/>
		<xsl:param name="slotName"/>

		<xsl:sequence select="$parentNode"/>
		<xsl:if test="$level &lt; $maxDepth">
			<xsl:variable name="childOrgs" select="$inScopeOrgs[own_slot_value[slot_reference = $slotName]/value = $parentNode/name]" as="node()*"/>

			<xsl:for-each select="$childOrgs">
				<xsl:sequence select="eas:get_object_descendants(current(), ($inScopeOrgs), $level + 1, $maxDepth, $slotName)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>

	<xsl:template name="RenderFormattedText">
		<xsl:param name="theSubjectInstance"/>
		<xsl:param name="textSlot"/>
		<xsl:value-of select="replace($theSubjectInstance/own_slot_value[slot_reference = $textSlot]/value, '&#xA;', '&lt;br/&gt;')" disable-output-escaping="yes"/>
	</xsl:template>


	<!-- START SLOT ACCESS FUNCTIONS -->

	<!-- Function that returns one or more strings associated with the given slot of a given instance -->
	<xsl:function name="eas:get_string_slot_values" as="xs:string*">
		<xsl:param name="instance"/>
		<xsl:param name="slotName"/>

		<xsl:value-of select="$instance/own_slot_value[slot_reference = $slotName]/value"/>
	</xsl:function>


	<!-- Function that returns one or more strings associated with the given slot of a given instance -->
	<xsl:function name="eas:get_integer_slot_values" as="xs:integer*">
		<xsl:param name="instance"/>
		<xsl:param name="slotName"/>

		<xsl:value-of select="number($instance/own_slot_value[slot_reference = $slotName]/value)"/>
	</xsl:function>


	<!-- Function that returns one or more strings associated with the given slot of a given instance -->
	<xsl:function name="eas:get_float_slot_values" as="xs:float*">
		<xsl:param name="instance"/>
		<xsl:param name="slotName"/>

		<xsl:value-of select="number($instance/own_slot_value[slot_reference = $slotName]/value)"/>
	</xsl:function>

	<!-- Function that returns the list of instances associated with the given slot of a given instance -->
	<xsl:function name="eas:get_instance_slot_values" as="node()*">
		<xsl:param name="inScopeInstances"/>
		<xsl:param name="instance"/>
		<xsl:param name="slotName"/>

		<xsl:sequence select="$inScopeInstances[name = $instance/own_slot_value[slot_reference = $slotName]/value]"/>
	</xsl:function>


	<!-- Function that returns the list of instances whose values for the given slot is the given instance -->
	<xsl:function name="eas:get_instances_with_instance_slot_value" as="node()*">
		<xsl:param name="inScopeInstances"/>
		<xsl:param name="slotName"/>
		<xsl:param name="slotValueInstance"/>

		<xsl:sequence select="$inScopeInstances[own_slot_value[slot_reference = $slotName]/value = $slotValueInstance/name]"/>
	</xsl:function>


	<!-- Function that returns the list of instances whose values for the given slot of is the given string -->
	<xsl:function name="eas:get_instances_with_string_slot_value" as="node()*">
		<xsl:param name="inScopeInstances"/>
		<xsl:param name="slotName"/>
		<xsl:param name="slotValueString"/>

		<xsl:sequence select="$inScopeInstances[own_slot_value[slot_reference = $slotName]/value = $slotValueString]"/>
	</xsl:function>


	<!-- Function that returns an instance based on its type and name-->
	<xsl:function name="eas:get_instance_by_name" as="node()*">
		<xsl:param name="inScopeInstances"/>
		<xsl:param name="type"/>
		<xsl:param name="name"/>

		<xsl:sequence select="$inScopeInstances[(type = $type) and (own_slot_value[slot_reference = 'name']/value = $name)]"/>
	</xsl:function>


	<!-- Function that returns the list of instances of a given class -->
	<xsl:function name="eas:get_instances_for_class" as="node()*">
		<xsl:param name="inScopeInstances"/>
		<xsl:param name="class"/>

		<xsl:sequence select="$inScopeInstances[type = $class]"/>
	</xsl:function>

	<!-- END SLOT ACCESS FUNCTIONS -->


	<!-- START NUMBER FORMATTING FUNCTIONS -->

	<!-- Function that formats larger numbers using the "k" or "M" abbreviations -->
	<xsl:function name="eas:format_large_number" as="xs:string">
		<xsl:param name="number"/>

		<xsl:choose>
			<xsl:when test="$number > 1000000000">
				<xsl:value-of select="format-number($number, '###,###,###,###')"/>
			</xsl:when>
			<xsl:when test="$number > 1000000">
				<xsl:value-of select="format-number($number, '###,###,###')"/>
			</xsl:when>
			<xsl:when test="$number >= 1000">
				<xsl:value-of select="format-number($number, '###,###')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$number"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<!-- END NUMBER FORMATTING FUNCTIONS -->



	<!-- START ELEMENT STYLE FUNCTIONS -->
	<!-- Get the css class associated with an element -->
	<xsl:function name="eas:get_element_style_instance" as="node()*">
		<xsl:param name="element"/>
		
		<xsl:variable name="elementStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $element/name]"/>
		<xsl:choose>
			<xsl:when test="count($elementStyle) > 0">
				<xsl:sequence select="$elementStyle[1]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="()"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Get the css class associated with an element -->
	<xsl:function name="eas:get_element_style_class" as="xs:string">
		<xsl:param name="element"/>
		
		<xsl:variable name="elementStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $element/name]"/>
		<xsl:choose>
			<xsl:when test="count($elementStyle) > 0">
				<xsl:value-of select="$elementStyle[1]/own_slot_value[slot_reference = 'element_style_class']/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<!-- Get the background colour associated with an element -->
	<xsl:function name="eas:get_element_style_colour" as="xs:string">
		<xsl:param name="element"/>
		
		<xsl:variable name="elementStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $element/name]"/>
		<xsl:choose>
			<xsl:when test="count($elementStyle) > 0">
				<xsl:value-of select="$elementStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Get the text colour associated with an element -->
	<xsl:function name="eas:get_element_style_textcolour" as="xs:string">
		<xsl:param name="element"/>
		
		<xsl:variable name="elementStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $element/name]"/>
		<xsl:choose>
			<xsl:when test="count($elementStyle) > 0">
				<xsl:value-of select="$elementStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<!-- Get the path to the icon associated with an element -->
	<xsl:function name="eas:get_element_style_icon" as="xs:string">
		<xsl:param name="element"/>
		
		<xsl:variable name="elementStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $element/name]"/>
		<xsl:choose>
			<xsl:when test="count($elementStyle) > 0">
				<xsl:value-of select="$elementStyle[1]/own_slot_value[slot_reference = 'element_style_icon']/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	<!-- END ELEMENT STYLE FUNCTIONS -->

	<!-- Function to return the Geographic Region that has a Region Identifier Value set
		If the region does not have one look to its containing region.
		If theGeoNode represents a specific location, search the region in which the location is contained
	-->
	<xsl:function name="eas:getRegionForLocation" as="node()*">
		<xsl:param name="theGeoNode"></xsl:param>
		<xsl:param name="theParentRegions"></xsl:param>
		<xsl:param name="theCountryList"></xsl:param>
	
		<xsl:choose>
			<!-- If there is no GeoNode here, return empty -->
			<xsl:when test="empty($theGeoNode)">
				<xsl:sequence select="()"></xsl:sequence>
			</xsl:when>
			
			<!-- If we've got a region code, return it -->
			<xsl:when test="$theGeoNode/name = $theCountryList/name">
				<xsl:sequence select="$theGeoNode"></xsl:sequence>
			</xsl:when>
			
			<!-- else, search up the stack -->
			<xsl:otherwise>
				<xsl:variable name="regionContainingLocation" select="$theParentRegions[own_slot_value[slot_reference = 'gr_locations']/value = $theGeoNode/name]"></xsl:variable>
				<xsl:variable name="regionContainingRegion" select="$theParentRegions[own_slot_value[slot_reference = 'gr_contained_regions']/value = $theGeoNode/name]"></xsl:variable>
				<xsl:variable name="containingRegions" select="$regionContainingLocation union $regionContainingRegion"></xsl:variable>
				<xsl:sequence select="eas:getRegionForLocation($containingRegions, $theParentRegions, $theCountryList)"></xsl:sequence>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<!-- Render alphabetic catalogues -->
	<!-- Render the index keys, as a set of hyperlinks to sections of the catalogue that have instances
		Ordered alphabetically -->
	
	
	<xsl:template name="eas:renderIndexSections">
		<xsl:param name="theIndexOfNames"></xsl:param>
		
		<!-- Generate the index based on the set of elements in the indexList -->		
		<xsl:for-each select="$theIndexOfNames">			
			<xsl:variable name="anHref" select="concat('#section_', upper-case(current()))"></xsl:variable>
			<a class="AlphabetLinks">
				<xsl:attribute name="href" select="$anHref"></xsl:attribute>
				<xsl:value-of select="eas:i18n(upper-case(current()))"/>
			</a>
		</xsl:for-each>
		
	</xsl:template>
	
	<!-- Find the first character of the set of items that are passed in as Strings -->
	<xsl:function name="eas:getFirstCharacter">
		<xsl:param name="theItemNames"></xsl:param>
		
		<xsl:for-each-group select="$theItemNames" group-by="upper-case(substring(current(), 1, 1))">
			<xsl:sort select="upper-case(substring(current()[1], 1, 1))" lang="{$i18n}"></xsl:sort>
			<xsl:sequence select="substring(current()[1], 1, 1)"></xsl:sequence>
		</xsl:for-each-group>
		
	</xsl:function>
	
	<!-- End of alphabetic catalogue rendering -->
	
	<!-- Ensure that JSON Strings are rendered correctly -->
	<xsl:function name="eas:validJSONString">
		<xsl:param name="theString"/>		
		<xsl:variable name="aQuote">"</xsl:variable>
		<xsl:variable name="anEscapedQuote">\\"</xsl:variable>
		<xsl:value-of select="translate(replace(normalize-space($theString), $aQuote, $anEscapedQuote), '&#xA;&#xD;', '')"/>
	</xsl:function>
	
	
	<!-- ********************************************
	EDITOR FUNCTIONS
	**************************************************-->
	
	<xsl:template name="RenderEditorLinkText">
		<xsl:param name="theEditor"/>
		<xsl:param name="theInstanceId"/>
		
		<xsl:variable name="theEditorId" select="$theEditor/name"/>
		<xsl:variable name="theEditorLabel" select="$theEditor/own_slot_value[slot_reference = 'report_label']/value"/>
		<xsl:variable name="editorXSL">
			<xsl:choose>
				<xsl:when test="$theEditor/type = 'Configured_Editor'">ess_configured_editor.xsl</xsl:when>
				<xsl:otherwise>ess_editor.xsl</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;cl=en-gb&amp;XSL=<xsl:value-of select="$editorXSL"/>&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/><xsl:if test="string-length($theInstanceId) > 0">&amp;PMA=<xsl:value-of select="$theInstanceId"/></xsl:if></xsl:variable>
		<xsl:value-of select="$theEditorLinkHref"/>
	</xsl:template>
	
	<!-- template to render a panel containing a list of links to Editors relevenat to the View with the given xsl path -->
	<xsl:template name="RenderReportEditorsPanel">
		<xsl:param name="theReportPath"/>
		<xsl:param name="theInstanceId"/>
		
		<xsl:variable name="theReport" select="$utilitiesAllReports[own_slot_value[slot_reference = 'report_xsl_filename']/value = $theReportPath]"/>
		<xsl:if test="count($theReport) > 0">
			<xsl:variable name="theReportEEditorSections" select="$utilitiesAllEditorSections[name = $theReport[1]/own_slot_value[slot_reference = 'report_related_editor_sections']/value]"/>
			<xsl:if test="$theReportEEditorSections">
				<style type="text/css">		
					.view-editors-container {
						position: relative;
					}
					.view-editors-panel {
						height: auto;
						min-width: 400px;
						position:absolute;
						z-index:1000;
						border: 1px solid grey;
						right: 0;
						top:0;
					}
					
					.view-editors-header {
						padding: 3px 0 3px 10px;
					}
					
					.view-editors-contents {
						padding: 3px 0 3px 10px;
					}
					
					.view-editor-entry {
						
					}
					
					.view-editor-entry-icon {
					
					}
					
					.view-editor-entry-label {
					
					}
				</style>
				<div class="row view-editors-container">
					<div class="view-editors-panel">
						<a href="#view-editors-list" data-toggle="collapse"><div class="view-editors-header fontSemi bg-darkblue-100">Editors</div></a>
						<div id="view-editors-list" class="view-editors-contents collapse">
							<xsl:apply-templates mode="RenderReportEditorLink" select="$theReportEEditorSections"/>
						</div>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- template to render a list of links to the given Editor Sections -->
	<xsl:template mode="RenderReportEditorLink" match="node()">
		<xsl:param name="theInstanceId"/>
		
		<xsl:variable name="theEditorSection" select="current()"/>
		<xsl:variable name="theEditorSectionAnchorId" select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_anchor_id']/value"/>
		<xsl:variable name="theEditorSectionIsDefault" select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_is_default']/value = 'true'"/>
		<xsl:variable name="theEditor" select="$utilitiesAllEditors[name = $theEditorSection/own_slot_value[slot_reference = 'editor_section_parent']/value]"/>
		<xsl:variable name="theEditorId" select="$theEditor/name"/>
		<xsl:variable name="theEditorLabel" select="$theEditor/own_slot_value[slot_reference = 'report_label']/value"/>
		
		<xsl:variable name="theEditorLinkLabel">
			<xsl:choose>
				<xsl:when test="$theEditorSectionIsDefault">
					<xsl:value-of select="$theEditorLabel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$theEditorLabel"/><xsl:text> - </xsl:text><xsl:value-of select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_label']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="editorXSL">
			<xsl:choose>
				<xsl:when test="$theEditor/type = 'Configured_Editor'">ess_configured_editor.xsl</xsl:when>
				<xsl:otherwise>ess_editor.xsl</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;PMA=<xsl:value-of select="$theInstanceId"/>&amp;cl=en-gb&amp;XSL=<xsl:value-of select="$editorXSL"/>&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/>&amp;SECTION=<xsl:value-of select="$theEditorSectionAnchorId"/></xsl:variable>
		<div class="view-editor-entry">
			<a href="{$theEditorLinkHref}" target="_blank">
				<i class="view-editor-entry-icon fa fa-pencil right-10"/><span class="view-editor-entry-label"><xsl:value-of select="$theEditorLinkLabel"/></span>
			</a>
		</div>
	</xsl:template>
	
	<!-- template to render a link to the given Editor section, optionally passing the given instance id -->
	<xsl:template name="RenderEditorLink">
		<xsl:param name="theEditorSection"/>
		<xsl:param name="theInstanceId"/>
		
		<xsl:variable name="theEditorSectionAnchorId" select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_anchor_id']/value"/>
		<xsl:variable name="theEditorSectionIsDefault" select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_is_default']/value = 'true'"/>
		<xsl:variable name="theEditor" select="$utilitiesAllEditors[name = $theEditorSection/own_slot_value[slot_reference = 'editor_section_parent']/value]"/>
		<xsl:variable name="theEditorId" select="$theEditor/name"/>
		<xsl:variable name="theEditorLabel" select="$theEditor/own_slot_value[slot_reference = 'report_label']/value"/>
		
		<xsl:variable name="theEditorLinkLabel">
			<xsl:choose>
				<xsl:when test="$theEditorSectionIsDefault">
					<xsl:value-of select="$theEditorLabel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$theEditorLabel"/><xsl:text> - </xsl:text><xsl:value-of select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_label']/value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="editorXSL">
			<xsl:choose>
				<xsl:when test="$theEditor/type = 'Configured_Editor'">ess_configured_editor.xsl</xsl:when>
				<xsl:otherwise>ess_editor.xsl</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;PMA=<xsl:value-of select="$theInstanceId"/>&amp;cl=en-gb&amp;XSL=<xsl:value-of select="$editorXSL"/>&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/>&amp;SECTION=<xsl:value-of select="$theEditorSectionAnchorId"/></xsl:variable>
		<div class="view-editor-entry">
			<a href="{$theEditorLinkHref}" target="_blank">
				<i class="view-editor-entry-icon fa fa-pencil right-10"/><span class="view-editor-entry-label"><xsl:value-of select="$theEditorLinkLabel"/></span>
			</a>
		</div>
	</xsl:template>
	
	<!-- template to render a link to the given Editor section, optionally passing the given instance id -->
	<xsl:template name="RenderEditorLinkHref">
		<xsl:param name="theEditor"/>
		<xsl:param name="theInstanceId"/>
		
		<xsl:variable name="theEditorSection" select="$allTargetEditorSections[(name = $theEditor/own_slot_value[slot_reference = 'editor_sections']/value) and (own_slot_value[slot_reference = 'editor_section_is_default']/value = 'true')]"/>
		<xsl:variable name="theEditorSectionAnchorId" select="$theEditorSection/own_slot_value[slot_reference = 'editor_section_anchor_id']/value"/>
		<xsl:variable name="theEditorId" select="$theEditor/name"/>
		<xsl:variable name="theEditorLabel" select="$theEditor/own_slot_value[slot_reference = 'report_label']/value"/>		
		
		<xsl:variable name="theEditorLinkHref">report?XML=reportXML.xml&amp;PMA=<xsl:value-of select="$theInstanceId"/>&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=<xsl:value-of select="$theEditorLabel"/>&amp;EDITOR=<xsl:value-of select="$theEditorId"/>&amp;SECTION=<xsl:value-of select="$theEditorSectionAnchorId"/></xsl:variable>
		<xsl:value-of select="$theEditorLinkHref"/>
	</xsl:template>
	
	<!-- function to retrieve a specific Editor Section with the given name -->
	<xsl:function name="eas:get_editor_section_by_name" as="node()">
		<xsl:param name="editorSectionName"/>
		<xsl:sequence select="$utilitiesAllEditorSections[own_slot_value[slot_reference = 'name']/value = $editorSectionName]"/>
	</xsl:function>
	
	<!-- function to test if a given version number is greater than, or equal to a second verson number -->
	<xsl:function name="eas:compareVersionNumbers" as="xs:boolean">
		<xsl:param name="currentVersionNum"/>
		<xsl:param name="testVersionNum"/>
		
		<xsl:variable name="currVersionTokens" select="tokenize($currentVersionNum, '\.')"/>
		<xsl:variable name="testVersionTokens" select="tokenize($testVersionNum, '\.')"/>
		
		<xsl:variable name="compareList">
			<xsl:for-each select="$currVersionTokens">
				<xsl:variable name="tokenIndex" select="position()"/>
				<xsl:variable name="thisToken" select="."/>
				<xsl:variable name="testToken" select="$testVersionTokens[$tokenIndex]"/>
				<xsl:sequence select="number($thisToken) >= number($testToken)"/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:value-of select="not(contains($compareList, 'false'))"/>
		
	</xsl:function>
	
	<!-- function to test if a given version number is greater than, or equal to a second verson number -->
	<!--<xsl:function name="eas:testCompareVersionNumbers" as="xs:boolean">
		<xsl:param name="currentVersionNum"/>
		<xsl:param name="testVersionNum"/>
		
		<xsl:variable name="currVersionTokens" select="tokenize($currentVersionNum, '\.')"/>
		<xsl:variable name="testVersionTokens" select="tokenize($testVersionNum, '\.')"/>
		
		<xsl:for-each select="$currVersionTokens">
			<xsl:variable name="tokenIndex" select="position()"/>
			<xsl:variable name="thisToken" select="."/>
			<xsl:variable name="testToken" select="$testVersionTokens[$tokenIndex]"/>
			<xsl:value-of select="number($thisToken) >= number($testToken)"/>
		</xsl:for-each>
		
	</xsl:function>-->
	
	<xsl:template name="RenderDataSetAPIWarning">
		<div class="col-xs-12 bottom-30" id="ess-data-gen-alert">
			<div class="alert"><i class="fa fa-refresh fa-spin fa-fw right-5"/><strong><xsl:value-of select="eas:i18n('Data generation for this View is not complete. Please try later.')"/></strong></div>
		</div>
	</xsl:template>

</xsl:stylesheet>
