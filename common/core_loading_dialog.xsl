<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">

	<!--
		* Copyright (c)2008 Enterprise Architecture Solutions ltd.
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
	<!-- 04.11.2008 JWC Migration to report servlet -->
	<!-- 06.11.2008	JWC Fixed page history for link from logo image -->
	<!-- 28.11.2008	JWC	Updated search URL to production Sharepoint server -->
	<!-- 28.01.2009 JWC	Migrate to use of divs for header -->
	<xsl:template match="node()" name="loading_dialog">
		<xsl:param name="messageText">This page highly complex and may take a few moments...</xsl:param>
		<div class="loadingContainer">
			<div class="loadingBox">
				<h1>Page Loading - Please Wait</h1>
				<p>
					<xsl:value-of select="$messageText"/>
				</p>
				<img src="images/loading_1.gif" alt="Page Loading Image"/>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
