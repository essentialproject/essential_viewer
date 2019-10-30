<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
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
	<!-- 03.12.2018 JP  Created	 -->
	<xsl:param name="essuser"/>
	
	
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	
	<xsl:variable name="essAllContentStatii" select="/node()/simple_instance[(type = 'SYS_CONTENT_APPROVAL_STATUS')]"/>
	<xsl:variable name="essProposedStatus" select="$essAllContentStatii[(own_slot_value[slot_reference = 'name']/value = 'SYS CONTENT PROPOSED')]"/>
	<xsl:variable name="allContentForApproval" select="/node()/simple_instance[own_slot_value[slot_reference = 'system_content_lifecycle_status']/value = $essProposedStatus/name]"/>
	<xsl:variable name="userContentForApproval" select="$allContentForApproval[own_slot_value[slot_reference = 'system_author_id']/value = $essuser]"/>

	<xsl:variable name="allIndivActors" select="/node()/simple_instance[(type = 'Individual_Actor')]"/>
	<xsl:variable name="sysApprovalRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'SYS_CONTENT_APPROVER')]"/>
	<xsl:variable name="sysUser" select="$allIndivActors[own_slot_value[slot_reference = 'email']/value = $essuser]"/>
	<xsl:variable name="sysUserAsApprover" select="/node()/simple_instance[(own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $sysUser/name) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $sysApprovalRole/name)]"/>
	<xsl:variable name="sysUserIsApprover" select="count($sysUserAsApprover) > 0"/>

	<xsl:template match="knowledge_base">
		{
			"approvalCount": <xsl:choose><xsl:when test="$sysUserIsApprover"><xsl:value-of select="count($allContentForApproval)"/></xsl:when><xsl:otherwise><xsl:value-of select="count($userContentForApproval)"/></xsl:otherwise></xsl:choose>,
			"approvalContentIds": [<xsl:if test="$sysUserIsApprover"><xsl:apply-templates mode="RenderElementIDListForJs" select="$allContentForApproval"/></xsl:if>]
			<!--"contentForApproval": [<xsl:if test="$sysUserIsApprover"><xsl:apply-templates mode="RenderApprovalsDetail" select="$allContentForApproval"/></xsl:if>]-->
		}
	</xsl:template>


	<xsl:template mode="RenderApprovalsDetail" match="node()">
		<xsl:variable name="thisContentStatus" select="$essAllContentStatii[name = current()/own_slot_value[slot_reference = 'system_content_lifecycle_status']/value]"/>
		
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisAuthor" select="$allIndivActors[own_slot_value[slot_reference = 'email']/value = current()/own_slot_value[slot_reference = 'system_author_id']/value]"/>
		
		{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
			"link": "<xsl:value-of select="$thisLink"/>",
			"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
			"meta": {
				<xsl:if test="count($thisAuthor) > 0">
					"createdBy": {
						"id": "<xsl:value-of select="$thisAuthor/own_slot_value[slot_reference = 'email']/value"/>",
						"name": "<xsl:value-of select="$thisAuthor/own_slot_value[slot_reference = 'name']/value"/>"
					},
				</xsl:if>
				"visibility": {
					"id": "vis1",
					"name": "SYS PUBLIC CONTENT",
					"label": "Everyone"
				},
				"requiresApproval": <xsl:choose><xsl:when test="$thisContentStatus/name = $essProposedStatus/name">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
				"createdOn": "2019-07-26T09:54:33+0000",
				"lastModifiedOn": "2019-07-18T19:55:00+0000"
			}
			
		}
	</xsl:template>
	
</xsl:stylesheet>
