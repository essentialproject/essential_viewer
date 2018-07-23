<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<!-- 10.06.2008    JWC    Export of Application Providers in XML form -->
	<!-- 05.11.2008    JWC    Upgraded to the new servlet reporting engine -->
	<!-- 11.11.2008    JWC    Derived the CSV output format Application Name, Description per line-->
	<!-- 05.01.2017 NJW Updated to support Essential Viewer version 5-->
	
	<xsl:output method="text"></xsl:output>

	<!-- Grab all the Application_Providers -->
	<xsl:template match="knowledge_base">
		<xsl:text>Application, Description</xsl:text>
		<xsl:text>&#xa;</xsl:text>
		<xsl:apply-templates select="/node()/simple_instance[type = 'Application_Provider']" mode="ApplicationProvider">
			<xsl:sort case-order="lower-first" order="ascending" select="own_slot_value[slot_reference = 'name']/value"></xsl:sort>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Render an Application_Provider instance -->
	<xsl:template match="node()" mode="ApplicationProvider">
		<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"></xsl:value-of>
		<xsl:text>, "</xsl:text>
		<xsl:value-of select="replace(own_slot_value[slot_reference = 'description']/value, '&#xa;', '')"></xsl:value-of>
		<xsl:text>"&#xa;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
