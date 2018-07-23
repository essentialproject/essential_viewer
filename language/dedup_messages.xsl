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
        De-duplication transform to remove duplicate message definitions. Messages with duplicate
        name values are removed to leave a single message per name.
    -->
	<!-- 26.09.2012    JWC    1st coding-->
	<!-- 26.10.2012    JWC    Extended to sort messages by name and identify non-empty duplicates -->

	<!-- Find and remove duplicate messages, identified by the name tag -->
	<xsl:template match="strings">
		<strings>
			<xsl:for-each-group select="message" group-by="name">
				<xsl:sort case-order="upper-first" select="name" order="ascending"/>
				<xsl:sort case-order="upper-first" select="value" order="descending"/>
				<xsl:variable name="aMsgList" select="current-group()"/>
				<xsl:copy-of select="current()[1]"/>
				<xsl:choose>
					<xsl:when test="count(current-group()) > 1">
						<!-- Apply a template to render all of the array of duplicates -->
						<xsl:apply-templates select="$aMsgList" mode="duplicateValues"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each-group>
		</strings>
	</xsl:template>

	<!-- Copy the rest of the XML document straight-through -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Ignore, the first element -->
	<!-- Otherwise, notify of duplicate and add suffixes to the keys (name tag) of messages with duplicate keys that have values -->
	<xsl:template match="node()" mode="duplicateValues">
		<!-- Ignore the 1st node passed in here -->
		<xsl:if test="position() > 1">
			<xsl:choose>
				<xsl:when test="string-length(value) > 0">
					<!-- Ignore cases with no translation - value tag -->
					<xsl:element name="message">
						<xsl:text>&#xa;</xsl:text>
						<xsl:comment>Duplicate key with value found. Message remains with suffix added to name tag (key)</xsl:comment>
						<xsl:text>&#xa;</xsl:text>
						<xsl:element name="name"><xsl:value-of select="name"/>_<xsl:value-of select="position()"/></xsl:element>
						<xsl:element name="value">
							<xsl:value-of select="value"/>
						</xsl:element>
					</xsl:element>
					<xsl:text>&#xa;</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
