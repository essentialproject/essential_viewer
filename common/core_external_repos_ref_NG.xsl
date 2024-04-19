<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="core_utilities_NG.xsl"/>
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
	<!-- Receive an instance node and report any external repository references
    that are defined against it in a table -->
	<!-- 04.11.2008	JWC	Added to new report servlet -->
	
	
	<xsl:param name="allExtRepoExternalRefsXML"/>
	<xsl:param name="allExtRepoExternalReposXML"/>
	
	<eas:apiRequests>
		
		{
		"apiRequestSet": [
			{
			"variable": "allExtRepoExternalRefsXML",
			"query": "/instances/type/External_Instance_Reference"
			},
			{
			"variable": "allExtRepoExternalReposXML",
			"query": "/instances/type/External_Repository"
			}
		]
		}
		
	</eas:apiRequests>
	<xsl:variable name="allExtRepoExternalRefs" select="$allExtRepoExternalRefsXML//simple_instance"/>
	<xsl:variable name="allExtRepoExternalRepos" select="$allExtRepoExternalReposXML//simple_instance"/>

	
	<xsl:template match="node()" mode="ReportExternalReposRef">
		<!-- Create a new table styled via css, to report any external references -->
		<xsl:variable name="anExternalRefList" select="own_slot_value[slot_reference = 'external_repository_instance_reference']/value"/>
		<xsl:choose>
			<xsl:when test="count($anExternalRefList) > 0">
				<p><xsl:value-of select="eas:i18n('Details of this element are integrated with other repositories as follows')"/>:</p>
				<table>
					<thead>
						<tr>
							<th class="cellWidth-50pc">
								<xsl:value-of select="eas:i18n('External Repository')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('External Repository ID')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Last Updated')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="$anExternalRefList">
							<xsl:variable name="anInstName" select="."/>
							<xsl:variable name="anExternalRef" select="$allExtRepoExternalRefs[name = $anInstName]"/>
							<xsl:variable name="anExternalReposInst" select="$anExternalRef/own_slot_value[slot_reference = 'external_repository_reference']/value"/>
							<xsl:variable name="anExternalReposName" select="$allExtRepoExternalRepos[name = $anExternalReposInst]/own_slot_value[slot_reference = 'name']/value"/>
							<tr>
								<td>
									<xsl:value-of select="translate($anExternalReposName, '_', ' ')"/>
								</td>
								<td>
									<xsl:value-of select="$anExternalRef/own_slot_value[slot_reference = 'external_instance_reference']/value"/>
								</td>
								<td>
									<xsl:value-of select="$anExternalRef/own_slot_value[slot_reference = 'external_update_date']/value"/>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:when>
			<xsl:when test="count($anExternalRefList) = 0">
				<span>
					<em>
						<xsl:value-of select="eas:i18n('No external references for this object')"/>
					</em>
				</span>
			</xsl:when>


		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
