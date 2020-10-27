<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:param name="param1"/>

	<xsl:variable name="maxDepth" select="20"/>
	
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']" />
	<xsl:variable name="allIndivActors" select="/node()/simple_instance[type = 'Individual_Actor']" />
	<xsl:variable name="allJobs" select="/node()/simple_instance[type = 'Job_Position']" />
	<xsl:variable name="allActor2Jobs" select="/node()/simple_instance[type = 'ACTOR_TO_JOB_RELATION']" />
	<xsl:variable name="allReportingLines" select="/node()/simple_instance[type = 'ACTOR_REPORTSTO_ACTOR_RELATION']"/>
	<xsl:variable name="allReportingIndivActors" select="$allIndivActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $allGroupActors/name]" />
	<xsl:variable name="allReportingActor2Jobs" select="$allActor2Jobs[own_slot_value[slot_reference = 'actor_to_job_from_actor']/value = $allReportingIndivActors/name]" />
	<xsl:variable name="allReportingJobs" select="$allJobs[name = $allReportingActor2Jobs/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]" />
	
	
	<xsl:variable name="allHeadofDeps" select="($allIndivActors, $allJobs)[name = $allGroupActors/own_slot_value[slot_reference = 'group_lead_individual_actor']/value]"/>
		
	<!--<xsl:variable name="headofDepRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Head of Department')]" />
	<xsl:variable name="allHeadofDep2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $headofDepRole/name]"/>
	<xsl:variable name="allHeadofDeps" select="$allReportingIndivActors[name = $allHeadofDep2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>-->
	
	<xsl:variable name="directReportingStrength" select="/node()/simple_instance[(type = 'Actor_Reporting_Line_Strength') and (own_slot_value[slot_reference = 'name']/value = 'Direct')]" />
	<xsl:variable name="allDirectReportingRels" select="$allReportingLines[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_strength']/value = $directReportingStrength/name)]"/>
	
	<xsl:variable name="topLevelOrgID">
		<xsl:choose>
			<xsl:when test="string-length($param1) > 0">
				<xsl:value-of select="$param1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Org Model - Root Organisation')]" />
				<xsl:value-of select="$rootOrgConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="topLevelOrg" select="$allGroupActors[name = $topLevelOrgID]" />
	
	
	
	
	<!-- END VIEW SPECIFIC VARIABLES -->
	

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
	<!-- 23.11.2018 JP  Created	 -->

	<xsl:variable name="blue">#337ab7</xsl:variable>
	<xsl:variable name="green">#5cb85c</xsl:variable>
<!--	<xsl:variable name="yellow">#f0ad4e</xsl:variable>
	<xsl:variable name="blueText">#4ab1eb</xsl:variable>-->
	<xsl:variable name="purple">#9467bd</xsl:variable>


	<xsl:template match="knowledge_base">
		{
			"tree": <xsl:apply-templates mode="RenderOrg" select="$topLevelOrg"><xsl:with-param name="isRoot" select="true()"/></xsl:apply-templates>
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderOrg" match="node()">
		<xsl:param name="isRoot" select="false()"/>
		<xsl:param name="thisDepth" select="0"/>
		
		<xsl:if test="$thisDepth &lt; $maxDepth">
			<xsl:variable name="thisOrg" select="current()"/>
			<xsl:variable name="thisOrgId" select="$thisOrg/name"/>
			
			<!-- Get all individuals that are members of the org -->
			<xsl:variable name="orgIndivActors" select="$allReportingIndivActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $thisOrg/name]"/>
			
			
			<!--<xsl:variable name="orgHeadofDeps" select="$allHeadofDeps[name = $orgIndivActors/name]"/>-->
			<xsl:variable name="orgHeadofDeps" select="$allHeadofDeps[name = $thisOrg/own_slot_value[slot_reference = 'group_lead_individual_actor']/value]"/>
			<xsl:variable name="orgHeadofDepJobs" select="$allJobs[name = $orgHeadofDeps/name]"/>
			<xsl:variable name="orgDirecHeadofDepIndivs" select="$allIndivActors[name = $orgHeadofDeps/name]"/>
			<xsl:variable name="orgHeadOfDepJobRels" select="$allReportingActor2Jobs[own_slot_value[slot_reference = 'actor_to_job_to_job']/value = $orgHeadofDepJobs/name]" />
			<xsl:variable name="orgHeadOfDepIndivs" select="$orgIndivActors[name = $orgHeadOfDepJobRels/own_slot_value[slot_reference = 'actor_to_job_from_actor']/value]" />
			<xsl:variable name="allOrgHeadOfDepIndivs" select="($orgDirecHeadofDepIndivs, $orgHeadOfDepIndivs)"/>
			
			<xsl:variable name="orgHeadofDepsCount" select="count($orgHeadofDeps)"/>
						
			<xsl:variable name="orgDirectReportRels" select="$allDirectReportingRels[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = $orgHeadofDeps/name) and (own_slot_value[slot_reference = 'indvact_reportsto_indvact_in_org_context']/value = $thisOrg/name)]"/>
			
			<xsl:variable name="orgJobDirectReports" select="$allReportingJobs[name = $orgDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
			<xsl:variable name="orgIndivInJobDirectReportRels" select="$allReportingActor2Jobs[own_slot_value[slot_reference = 'actor_to_job_to_job']/value = $orgJobDirectReports/name]"/>
			<xsl:variable name="orgIndivInJobDirectReports" select="$allReportingIndivActors[name = $orgIndivInJobDirectReportRels/own_slot_value[slot_reference = 'actor_to_job_from_actor']/value]" />
			
			<xsl:variable name="orgDirectIndivReports" select="$allReportingIndivActors[name = $orgDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
			<xsl:variable name="orgDirectReports" select="($orgIndivInJobDirectReports, $orgDirectIndivReports)"/>
			<xsl:variable name="allOrgDirectReports" select="$orgJobDirectReports"/>
			
			<!-- Get all org members that do are not defined as reporting to any other individual -->
			<!--<xsl:variable name="noReportOrgIndivActors" select="($orgIndivActors, $orgJobDirectReports)[not(name = $allDirectReportingRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value)]"/>-->
			
			<!-- Set all direct reports to the direct reports to the Head of Deprtment and those that are not defined as reporting to any other individual -->
			<!--<xsl:variable name="allOrgDirectReports" select="($orgDirectReports union $noReportOrgIndivActors) except $allOrgHeadOfDepIndivs"/>-->
			
			<xsl:variable name="orgSubOrgs" select="$allGroupActors[own_slot_value[slot_reference = 'is_member_of_actor']/value = $thisOrg/name]"/>
			
			{
				"nodeName" : "<xsl:value-of select="$thisOrgId"/>",
				"name" : "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisOrg"/></xsl:call-template>",
				"treelink" : "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisOrg"/></xsl:call-template>",
				"type" : "org",
				"testCount": <xsl:value-of select="count($orgDirectReportRels)"/>,
				"mode": "closed",
				"color": <xsl:choose><xsl:when test="$isRoot">"<xsl:value-of select="$purple"/>"</xsl:when><xsl:otherwise>"<xsl:value-of select="$green"/>"</xsl:otherwise></xsl:choose>,
				<xsl:choose>
					<xsl:when test="$orgHeadofDepsCount > 0">
						"headOfDep" : {
							<xsl:if test="count($orgHeadofDepJobs) > 0 and count($orgDirecHeadofDepIndivs) = 0">
								"jobName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$orgHeadofDepJobs[1]"/></xsl:call-template>",
								"jobTreelink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$orgHeadofDepJobs[1]"/></xsl:call-template>",
							</xsl:if>							
							"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$allOrgHeadOfDepIndivs[1]"/></xsl:call-template>",
							"treelink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$allOrgHeadOfDepIndivs[1]"/></xsl:call-template>"
						},
					</xsl:when>
					<xsl:otherwise>
						"headOfDep" : null,
					</xsl:otherwise>
				</xsl:choose>
				"link" : {
					"name" : "",
					"nodeName" : "",
					"direction" : "SYNC"
				},
				"children" : [],
				"hasReports": <xsl:choose><xsl:when test="count($allOrgDirectReports) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
				"reports": <xsl:choose><xsl:when test="count($allOrgDirectReports) > 0">[
					<xsl:apply-templates mode="RenderIndividual" select="$allOrgHeadOfDepIndivs[1]"><xsl:with-param name="contextId" select="$thisOrgId"/><xsl:with-param name="thisDepth" select="$thisDepth + 1"/><xsl:with-param name="contextOrg" select="$thisOrg"/></xsl:apply-templates>
				]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
				"hasSubOrgs": <xsl:choose><xsl:when test="count($orgSubOrgs) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
				"subOrgs" : <xsl:choose><xsl:when test="count($orgSubOrgs) > 0">[
					<xsl:apply-templates mode="RenderOrg" select="$orgSubOrgs"><xsl:with-param name="thisDepth" select="$thisDepth + 1"/></xsl:apply-templates>
				]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
			}<xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RenderIndividual" match="node()">
		<xsl:param name="contextId"/>
		<xsl:param name="thisDepth" select="0"/>
		<xsl:param name="contextOrg"/>
		
		<xsl:if test="$thisDepth &lt; $maxDepth">
			<xsl:variable name="thisIndiv" select="current()"/>
			<xsl:variable name="thisIndivId" select="$thisIndiv/name"/>
			
			<xsl:variable name="thisIndivOrg" select="$allGroupActors[name = $thisIndiv/own_slot_value[slot_reference = 'is_member_of_actor']/value]"/>
			
			<xsl:variable name="thisIndiv2Jobs" select="$allReportingActor2Jobs[own_slot_value[slot_reference = 'actor_to_job_from_actor']/value = $thisIndiv/name]" />
			<xsl:variable name="thisIndivJobs" select="$allReportingJobs[name = $thisIndiv2Jobs/own_slot_value[slot_reference = 'actor_to_job_to_job']/value]" />
			
			<xsl:variable name="indivDirectReportRels" select="$allDirectReportingRels[(own_slot_value[slot_reference = 'indvact_reportsto_indvact_to_actor']/value = ($thisIndiv, $thisIndivJobs)/name) and (own_slot_value[slot_reference = 'indvact_reportsto_indvact_in_org_context']/value = $contextOrg/name)]"/>
			
			<xsl:variable name="indivJobDirectReports" select="$allReportingJobs[name = $indivDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
			<xsl:variable name="indivIndivInJobDirectReportRels" select="$allReportingActor2Jobs[own_slot_value[slot_reference = 'actor_to_job_to_job']/value = $indivJobDirectReports/name]"/>
			<xsl:variable name="indivIndivInJobDirectReports" select="$allReportingIndivActors[name = $indivIndivInJobDirectReportRels/own_slot_value[slot_reference = 'actor_to_job_from_actor']/value]" />
			
			<xsl:variable name="indivDirectIndivReports" select="$allReportingIndivActors[name = $indivDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>
			<xsl:variable name="indivDirectReports" select="($indivIndivInJobDirectReports, $indivDirectIndivReports)"/>
			
			
			
			<!--<xsl:variable name="indivDirectReports" select="$allReportingIndivActors[name = $indivDirectReportRels/own_slot_value[slot_reference = 'indvact_reportsto_indvact_from_actor']/value]"/>-->
			
			{
				"nodeName" : "<xsl:value-of select="$contextId"/><xsl:value-of select="$thisIndivId"/>",
				"name" : "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisIndiv"/></xsl:call-template>",
				"treelink" : "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisIndiv"/></xsl:call-template>",
				"type" : "indiv",
				"mode": "closed",
				"color": "<xsl:value-of select="$blue"/>",
				<xsl:choose>
					<xsl:when test="count($thisIndivOrg) > 0">
						"parentOrg" : {
						"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisIndivOrg[1]"/></xsl:call-template>",
						"treelink": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisIndivOrg[1]"/></xsl:call-template>"
						},
					</xsl:when>
					<xsl:otherwise>
						"parentOrg" : null,
					</xsl:otherwise>
				</xsl:choose>
				"jobTitle": <xsl:choose><xsl:when test="count($thisIndivJobs) > 0">"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisIndivJobs[1]"/></xsl:call-template>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
				"link" : {
					"name" : "",
					"nodeName" : "",
					"direction" : "SYNC"
				},
				"children" : [],
				"hasReports": <xsl:choose><xsl:when test="count($indivDirectReports) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
				"reports": <xsl:choose><xsl:when test="count($indivDirectReports) > 0">[
					<xsl:apply-templates mode="RenderIndividual" select="$indivDirectReports"><xsl:with-param name="contextId" select="$contextId"/><xsl:with-param name="thisDepth" select="$thisDepth + 1"/><xsl:with-param name="contextOrg" select="$contextOrg"/></xsl:apply-templates>
				]</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>
			}<xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:if>
		
	</xsl:template>

</xsl:stylesheet>
