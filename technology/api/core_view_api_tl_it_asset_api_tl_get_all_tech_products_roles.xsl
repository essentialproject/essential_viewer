<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
    <xsl:include href="../../common/core_roadmap_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
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
 	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
	 <xsl:key name="allTechProdRoles" match="/node()/simple_instance[supertype = 'Technology_Provider_Role']" use="own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
	<xsl:variable name="allTechProdRoles" select="key('allTechProdRoles', $allTechComps/name)"/>
	<xsl:template match="knowledge_base">
        {"tprs":[<xsl:apply-templates select="$allTechProdRoles" mode="RenderTPRJSONList"/>]}
	</xsl:template>
	  <xsl:template match="node()" mode="RenderTPRJSONList">
         { "id":"<xsl:value-of select="current()/name"/>", "techProdid":"<xsl:value-of select="current()/own_slot_value[slot_reference='role_for_technology_provider']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
    </xsl:template>

</xsl:stylesheet>
