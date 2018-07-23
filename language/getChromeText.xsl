<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

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
        Transform to rip the static text (chrome) from View Templates into the language XML document.
    -->
	<!-- 24.08.2012    JWC    1st coding-->
	<xsl:template match="xsl:stylesheet">
		<xsl:apply-templates select="//xsl:value-of" mode="getChrome"/>

	</xsl:template>

	<xsl:template mode="getChrome" match="node()">
		<xsl:choose>
			<xsl:when test="contains(current()/@select, 'eas:i18n(&quot;')">
				<!-- We have a string parameter in double quotes -->
				<xsl:variable name="aValue" select="current()/@select"/>
				<xsl:variable name="aDoubleQuote">"</xsl:variable>
				<xsl:variable name="aPrefix" select="substring-after($aValue, $aDoubleQuote)"/>
				<xsl:variable name="aChromeText" select="substring-before($aPrefix, concat($aDoubleQuote, ')'))"/>

				<message>
					<name>
						<xsl:value-of select="$aChromeText"/>
					</name>
					<value/>
				</message>

			</xsl:when>
			<xsl:when test="contains(current()/@select, &quot;eas:i18n(&apos;&quot;)">
				<xsl:variable name="aValue" select="current()/@select"/>
				<xsl:variable name="aSingleQuote">'</xsl:variable>
				<xsl:variable name="aPrefix" select="substring-after($aValue, $aSingleQuote)"/>
				<xsl:variable name="aChromeText" select="substring-before($aPrefix, concat($aSingleQuote, ')'))"/>

				<message>
					<name>
						<xsl:value-of select="$aChromeText"/>
					</name>
					<value/>
				</message>
			</xsl:when>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
