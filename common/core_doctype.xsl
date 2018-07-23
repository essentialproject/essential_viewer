<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="pro xalan xs functx eas ess" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

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

	<xsl:template match="node()" name="docType">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
	</xsl:template>

</xsl:stylesheet>
