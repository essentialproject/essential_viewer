<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.enterprise-architecture.org/essential/language" xmlns="http://www.enterprise-architecture.org/essential/language" version="2.0">
	<xsl:output indent="yes"/>

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
        Transform to remove leading and trailing spaces from messages/name and messages/value.
    -->
	<!-- 15.03.2017    JWC    1st coding-->

	<!-- Match all message blocks and process each name and value -->
	<xsl:template match="message">
		<xsl:variable name="name" select="name"/>
		<xsl:variable name="value" select="value"/>
		<message>
			<name>
				<xsl:value-of select="normalize-space($name)"/>
			</name>
			<value>
				<xsl:value-of select="normalize-space($value)"/>
			</value>
		</message>
	</xsl:template>

	<!-- Copy the rest of the XML document straight-through -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
