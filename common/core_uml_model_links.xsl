<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com">
	<!--
        * Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	<!-- 15.08.2011 JP - A set of templates used for producing UML-based diagrams -->
	<!-- 18.01.2012 JWC - Updated to operate with the revised Essential Viewer Engine -->



	<!-- Render the code to produce the HREF attribute of a hyperlink 
        theXML is the name of the XML file to process, by default, reportXML.xml
        theXSL is the name of the transform to create the PlantUML script for redering the diagram
        thePageXSL is the name of the transform to execute to display the resulting model
        theXSize is the optional width of the generated diagram in pixels
        theYSize is the optional height of the generated diagram in pixels
        theInstanceID is the name of the instance that is is the key for the view
        theHistoryLabel is the content to be shown in the history drop-down
        theParam2 is an optional parameter to supply to any view
        theParam3 is an optional parameter to supply to any view
        theParam4 is an optional parameter to supply to any view
        theContentType [optional] is a MIME content type, e.g. application/ms-excel for downloading the view
        theFilename [optional but required if theContentType is used] is the name of the file render the selected 
        content type into. Must be supplied if theContentType is specified.
    -->
	<xsl:template name="RenderUMLLinkHref" match="node()">
		<xsl:param name="theXML">reportXML.xml</xsl:param>
		<xsl:param name="theXSL"/>
		<xsl:param name="thePageXSL"/>
		<xsl:param name="theXSize"/>
		<xsl:param name="theYSize"/>
		<xsl:param name="theInstanceID"/>
		<xsl:param name="theHistoryLabel"/>
		<xsl:param name="theParam2"/>
		<xsl:param name="theParam3"/>
		<xsl:param name="theParam4"/>
		<xsl:param name="theContentType"/>
		<xsl:param name="theFilename"/>
		<xsl:param name="theUserParams"/>

		<!-- using the specified parameters, build the HREF attribute for the link -->
		<xsl:attribute name="href">
			<xsl:text>uml_model.jsp?XML=</xsl:text>
			<xsl:value-of select="$theXML"/>
			<xsl:text>&amp;PMA=</xsl:text>
			<xsl:value-of select="$theInstanceID"/>

			<xsl:if test="string-length($theXSL) > 0">
				<xsl:text>&amp;XSL=</xsl:text>
				<xsl:value-of select="$theXSL"/>
			</xsl:if>
			<xsl:if test="string-length($thePageXSL) > 0">
				<xsl:text>&amp;PAGEXSL=</xsl:text>
				<xsl:value-of select="$thePageXSL"/>
			</xsl:if>
			<xsl:if test="string-length($theXSize) > 0">
				<xsl:text>&amp;XSIZE=</xsl:text>
				<xsl:value-of select="$theXSize"/>
			</xsl:if>
			<xsl:if test="string-length($theYSize) > 0">
				<xsl:text>&amp;YSIZE=</xsl:text>
				<xsl:value-of select="$theYSize"/>
			</xsl:if>

			<xsl:if test="string-length($theHistoryLabel) > 0">
				<xsl:text>&amp;LABEL=</xsl:text>
				<xsl:value-of select="$theHistoryLabel"/>
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

		</xsl:attribute>
	</xsl:template>


</xsl:stylesheet>
