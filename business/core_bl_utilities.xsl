<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
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
	<!-- 16.04.2008 JWC - A set of utility templates that can be used by many other templates -->
	<!-- 06.12.2010 JWC - Added the RenderLinkHref template to manage links -->
	<!-- 15.12.2010 JWC - Updated RenderInstanceName to support EA_Relation instances -->
	<!--                  Ensure that changes here are replicated in strategy_plan_utilities.xsl -->
	<!-- 15.05.2013 JWC - Added a new template for Bus Cap rendering using JSON -->

	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:import href="../common/core_header.xsl"/>

	<!-- Collect all available org units -->
	<xsl:variable name="busUtilitiesAllOrgs" select="/node()/simple_instance[(type = 'Group_Actor')]"/>
	<xsl:variable name="busUtilitiesAllIndividuals" select="/node()/simple_instance[(type = 'Individual_Actor')]"/>
	<xsl:variable name="busUtilitiesMaxDepth" select="10"/>


	<!-- Collect all available business capabilities -->
	<xsl:variable name="busUtilitiesAllBusinessCaps" select="/node()/simple_instance[(type = 'Business_Capability')]"/>

	<xsl:variable name="busUtilitiesAllBusCapRoles" select="/node()/simple_instance[type = 'Business_Capability_Role']"/>

	<xsl:variable name="busUtilitiesAllBusProcFlows" select="/node()/simple_instance[type = 'Business_Process_Flow']"/>
	<xsl:variable name="busUtilitiesAllBusProcsActivities" select="/node()/simple_instance[(type = 'Business_Process') or (type = 'Business_Activity')]"/>
	<xsl:variable name="busUtilitiesAllBusProcActivityUsages" select="/node()/simple_instance[(type = 'Business_Process_Usage') or (type = 'Business_Activity_Usage')]"/>

	<xsl:variable name="busUtilitiesCapFrontPositon" select="$busUtilitiesAllBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Front']"/>
	<xsl:variable name="busUtilitiesCapBackPositon" select="$busUtilitiesAllBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Back']"/>
	<xsl:variable name="busUtilitiesCapManagePositon" select="$busUtilitiesAllBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Manage']"/>

	<xsl:variable name="busUtilitiesAllChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="busUtilitiesAllBackBusCapRelss" select="$busUtilitiesAllChildCap2ParentCapRels[own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $busUtilitiesCapBackPositon/name]"/>
	<xsl:variable name="busUtilitiesAllManageBusCapRelss" select="$busUtilitiesAllChildCap2ParentCapRels[own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $busUtilitiesCapManagePositon/name]"/>

	<xsl:variable name="busUtilsRootBusReferenceModelReport" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Core: Business Reference Model']"/>
	<xsl:variable name="busUtilsDrillDownBusReferenceModelReport" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Core: Business Reference Model Drill Down']"/>
	<xsl:variable name="busUtilsBusCapSummaryReport" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = 'Core: Business Capability Summary']"/>


	<!-- Start variables related to skills -->
	<xsl:variable name="busUtilsSkills" select="/node()/simple_instance[(type = 'Skill')]"/>
	<xsl:variable name="busUtilsSkill2ActorRels" select="/node()/simple_instance[(type = 'ACTOR_TO_SKILL_RELATION')]"/>
	<xsl:variable name="busUtilsSkillLevels" select="/node()/simple_instance[(type = 'Skill_Level') and (name = $busUtilsSkill2ActorRels/own_slot_value[slot_reference = 'skill_level']/value)]"/>
	<xsl:variable name="busUtilsSkillQualifierTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Skill Qualifiers')]"/>
	<xsl:variable name="busUtilsSkillQualifierTerms" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $busUtilsSkillQualifierTaxonomy/name]"/>


	<xsl:variable name="utilitiesAllStyles" select="/node()/simple_instance[(type = 'Element_Style')]"/>


	<!-- FUNCTION TO DETERMINE WHETHER A GIVEN BUSINESS CAPABILITY HAS 2 FURTHER LEVELS OF BUSINESS CAPABILITY BENEATH IT -->
	<xsl:function name="eas:busCapHasGrandChildren" as="xs:boolean">
		<xsl:param name="theBusCap"/>

		<xsl:variable name="childBusCaps" select="$busUtilitiesAllBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theBusCap/name]"/>
		<xsl:variable name="grandChildBusCaps" select="$busUtilitiesAllBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $childBusCaps/name]"/>
		<xsl:value-of select="count($grandChildBusCaps) > 0"/>

	</xsl:function>


	<!-- FUNCTION TO DETERMINE WHETHER A GIVEN BUSINESS CAPABILITY HAS 2 FURTHER LEVELS OF BUSINESS CAPABILITY BENEATH IT -->
	<xsl:function name="eas:busCapHasMultiRoleChildren" as="xs:boolean">
		<xsl:param name="theBusCap"/>

		<xsl:variable name="childBusCaps" select="$busUtilitiesAllBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theBusCap/name]"/>
		<xsl:variable name="backOfficeCapRels" select="$busUtilitiesAllBackBusCapRelss[own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theBusCap/name]"/>

		<xsl:value-of select="count($backOfficeCapRels) > 0"/>

	</xsl:function>


	<xsl:template name="RenderBusCapDrillDownLink">
		<xsl:param name="theBusCap"/>
		<xsl:param name="viewScopeTerms"/>
		<xsl:param name="reposXML"/>
		<xsl:param name="divClass"/>
		<xsl:param name="anchorClass"/>

		<xsl:choose>
			<xsl:when test="count($busUtilitiesAllBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theBusCap/name]) = 0">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="targetReport" select="$busUtilsBusCapSummaryReport"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="eas:busCapHasMultiRoleChildren(current())">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="targetReport" select="$busUtilsRootBusReferenceModelReport"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="targetReport" select="$busUtilsDrillDownBusReferenceModelReport"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- JSON Variant that takes the name string as a param -->
	<xsl:template name="RenderBusCapDrillDownLinkJSON">
		<xsl:param name="theBusCap"/>
		<xsl:param name="viewScopeTerms"/>

		<xsl:param name="divClass"/>
		<xsl:param name="anchorClass"/>
		<xsl:param name="displayName"/>

		<xsl:choose>
			<xsl:when test="count($busUtilitiesAllBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $theBusCap/name]) = 0">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="targetReport" select="$busUtilsBusCapSummaryReport"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
					<xsl:with-param name="displayString" select="$displayName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="eas:busCapHasMultiRoleChildren(current())">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="targetReport" select="$busUtilsRootBusReferenceModelReport"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
					<xsl:with-param name="displayString" select="$displayName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$theBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="$divClass"/>
					<xsl:with-param name="targetReport" select="$busUtilsDrillDownBusReferenceModelReport"/>
					<xsl:with-param name="anchorClass" select="$anchorClass"/>
					<xsl:with-param name="displayString" select="$displayName"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="RenderBusCapHeritage">
		<xsl:param name="theBusCap"/>
		<xsl:param name="viewScopeTerms"/>
		<xsl:param name="reposXML"/>


		<xsl:variable name="parentBusCaps" select="$busUtilitiesAllBusinessCaps[name = $theBusCap/own_slot_value[slot_reference = 'supports_business_capabilities']/value]"/>
		<xsl:for-each select="$parentBusCaps">
			<xsl:call-template name="RenderBusCapHeritage">
				<xsl:with-param name="theBusCap" select="current()"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="reposXML" select="$reposXML"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:if test="count($parentBusCaps) > 0">
			<xsl:for-each select="$parentBusCaps">
				<xsl:call-template name="RenderBusCapDrillDownLink">
					<xsl:with-param name="theBusCap" select="current()"/>
					<xsl:with-param name="reposXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<xsl:if test="not(position() = last())"><xsl:text>, </xsl:text></xsl:if>
			</xsl:for-each> &#160;<img src="images/small_arrow_r2l.png" alt="arrow"/>&#160; </xsl:if>



	</xsl:template>


	<!-- FUNCTION THAT PROVIDES A LIST OF BUSINESS PROCESSES THAT EITHER DIRECTLY OR INDIRECTLY (AS PROCESS DESCENDANTS) SUPPORTS A GIVEN BUSINESS CAPABILITY -->
	<xsl:function name="eas:getAllProcessesForBusCap" as="node()*">
		<xsl:param name="theBusCap"/>

		<xsl:variable name="capBusProcs" select="$busUtilitiesAllBusProcsActivities[own_slot_value[slot_reference = 'realises_business_capability']/value = $theBusCap/name]"/>
		<xsl:copy-of select="eas:getAllDescendantsForProcesses($capBusProcs, ())"/>

	</xsl:function>


	<!-- FUNCTION THAT PROVIDES A LIST OF BUSINESS PROCESSES THAT ARE DESCENDANTS OF THE GIVEN BUSINESS PROCESSES -->
	<xsl:function name="eas:getAllDescendantsForProcesses" as="node()*">
		<xsl:param name="inScopeBusProcs"/>
		<xsl:param name="processesFound"/>
		<!-- <xsl:param name="currentDepth"/>-->


		<xsl:choose>
			<xsl:when test="(count($inScopeBusProcs) > 0)">
				<xsl:variable name="nextBusProc" select="$inScopeBusProcs[1]"/>
				<xsl:variable name="updatedBusProcs" select="$inScopeBusProcs except $nextBusProc"/>
				<xsl:variable name="updatedProcessesFound" select="$processesFound union $nextBusProc"/>

				<xsl:variable name="processFlow" select="$busUtilitiesAllBusProcFlows[name = $nextBusProc/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
				<xsl:variable name="processUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'used_in_process_flow']/value = $processFlow/name]"/>
				<xsl:variable name="subProcesses" select="$busUtilitiesAllBusProcsActivities[(name = $processUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $processUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

				<xsl:variable name="subProcessFlows" select="$busUtilitiesAllBusProcFlows[name = $subProcesses/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
				<xsl:variable name="subProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'used_in_process_flow']/value = $subProcessFlows/name]"/>
				<xsl:variable name="subSubProcesses" select="$busUtilitiesAllBusProcsActivities[(name = $subProcessUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $subProcessUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

				<xsl:variable name="subSubProcessFlows" select="$busUtilitiesAllBusProcFlows[name = $subSubProcesses/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
				<xsl:variable name="subSubProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'used_in_process_flow']/value = $subSubProcessFlows/name]"/>
				<xsl:variable name="subSubSubProcesses" select="$busUtilitiesAllBusProcsActivities[(name = $subSubProcessUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $subSubProcessUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

				<xsl:variable name="newProcessList" select="($updatedProcessesFound union $subProcesses union $subSubProcesses union $subSubSubProcesses)"/>
				<xsl:copy-of select="eas:getAllDescendantsForProcesses($updatedBusProcs, $newProcessList)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$processesFound"/>
			</xsl:otherwise>
		</xsl:choose>


		<!--<xsl:choose>            
            <xsl:when test="(count($inScopeBusProcs) > 0)">     
                <xsl:variable name="nextBusProc" select="$inScopeBusProcs[1]"/>
                <xsl:variable name="updatedBusProcs" select="$inScopeBusProcs except $nextBusProc"/>
                
                <xsl:choose> 
                    <xsl:when test="$nextBusProc/own_slot_value[slot_reference='name']/value = 'Create/update custody record'">         
                        <xsl:variable name="updatedProcessesFound" select="$processesFound union $nextBusProc"/>
                        <xsl:variable name="processFlow" select="$busUtilitiesAllBusProcFlows[name=$nextBusProc/own_slot_value[slot_reference='defining_business_process_flow']/value]"/>
                        <xsl:variable name="processUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference='used_in_process_flow']/value = $processFlow/name]"/>      
                        <xsl:variable name="subProcesses" select="$busUtilitiesAllBusProcsActivities[(name=$processUsages/own_slot_value[slot_reference='business_process_used']/value) or (name=$processUsages/own_slot_value[slot_reference='business_activity_used']/value)]"/>
                        
                        <xsl:variable name="subProcessFlows" select="$busUtilitiesAllBusProcFlows[name=$subProcesses/own_slot_value[slot_reference='defining_business_process_flow']/value]"/>
                        <xsl:variable name="subProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference='used_in_process_flow']/value = $subProcessFlows/name]"/>                
                        <xsl:variable name="subSubProcesses" select="$busUtilitiesAllBusProcsActivities[(name=$subProcessUsages/own_slot_value[slot_reference='business_process_used']/value) or (name=$subProcessUsages/own_slot_value[slot_reference='business_activity_used']/value)]"/>
                        
                        <xsl:variable name="subSubProcessFlows" select="$busUtilitiesAllBusProcFlows[name=$subSubProcesses/own_slot_value[slot_reference='defining_business_process_flow']/value]"/>
                        <xsl:variable name="subSubProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference='used_in_process_flow']/value = $subSubProcessFlows/name]"/>
                        <xsl:variable name="subSubSubProcesses" select="$busUtilitiesAllBusProcsActivities[(name=$subSubProcessUsages/own_slot_value[slot_reference='business_process_used']/value) or (name=$subSubProcessUsages/own_slot_value[slot_reference='business_activity_used']/value)]"/>
                        
                        
                        <xsl:variable name="newProcessList" select="($updatedBusProcs union $subProcesses) except $nextBusProc"/>
                        <xsl:copy-of select="($subProcesses union $inScopeBusProcs union $processesFound)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="eas:getAllDescendantsForProcesses($updatedBusProcs, $processesFound union $nextBusProc)"/>      
                    </xsl:otherwise>
                </xsl:choose>   
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$processesFound"/>
            </xsl:otherwise>
        </xsl:choose>-->


		<!--<xsl:choose>            
            <xsl:when test="(count($inScopeBusProcs) > 0) and ($currentDepth &lt;= 1)">     
                <xsl:variable name="nextBusProc" select="$inScopeBusProcs[1]"/>
                <xsl:variable name="updatedBusProcs" select="$inScopeBusProcs except $nextBusProc"/>
                <xsl:variable name="updatedProcessesFound" select="$processesFound union $nextBusProc"/>
                <xsl:variable name="processFlow" select="$busUtilitiesAllBusProcFlows[name=$nextBusProc/own_slot_value[slot_reference='defining_business_process_flow']/value]"/>
                <xsl:variable name="processUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference='used_in_process_flow']/value = $processFlow/name]"/>
                <xsl:variable name="subProcesses" select="$busUtilitiesAllBusProcsActivities[(name=$processUsages/own_slot_value[slot_reference='business_process_used']/value) or (name=$processUsages/own_slot_value[slot_reference='business_activity_used']/value)]"/>
                <xsl:variable name="subProcessDescendants" select="eas:getAllDescendantsForProcesses($subProcesses, $updatedProcessesFound, $currentDepth + 1)"/>
                
                <xsl:variable name="newProcessList" select="($updatedProcessesFound union $subProcessDescendants)"/>
                <xsl:copy-of select="eas:getAllDescendantsForProcesses($updatedBusProcs, $newProcessList, $currentDepth)"/>      
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$processesFound"/>
            </xsl:otherwise>
        </xsl:choose>-->
	</xsl:function>


	<!-- FUNCTION THAT PROVIDES A LIST OF BUSINESS PROCESSES THAT ARE DESCENDANTS OF THE GIVEN BUSINESS PROCESSES -->
	<xsl:function name="eas:getSupportCapForProcess" as="node()*">
		<xsl:param name="busProc"/>

		<xsl:variable name="busProcRealisedCaps" select="$busUtilitiesAllBusinessCaps[name = $busProc/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
		<xsl:choose>
			<xsl:when test="count($busProcRealisedCaps) > 0">
				<xsl:copy-of select="$busProcRealisedCaps"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="processUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'business_process_used']/value = $busProc/name]"/>
				<xsl:variable name="parentProcessFlows" select="$busUtilitiesAllBusProcFlows[(name = $processUsages/own_slot_value[slot_reference = 'used_in_process_flow']/value)]"/>
				<xsl:variable name="parentProcesses" select="$busUtilitiesAllBusProcsActivities[own_slot_value[slot_reference = 'defining_business_process_flow']/value = $parentProcessFlows/name]"/>
				<xsl:variable name="parentRealisedCaps" select="$busUtilitiesAllBusinessCaps[name = $parentProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

				<xsl:choose>
					<xsl:when test="count($parentRealisedCaps) > 0">
						<xsl:copy-of select="$parentRealisedCaps"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="parentProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'business_process_used']/value = $parentProcesses/name]"/>
						<xsl:variable name="grandParentProcessFlows" select="$busUtilitiesAllBusProcFlows[(name = $parentProcessUsages/own_slot_value[slot_reference = 'used_in_process_flow']/value)]"/>
						<xsl:variable name="grandParentProcesses" select="$busUtilitiesAllBusProcsActivities[own_slot_value[slot_reference = 'defining_business_process_flow']/value = $grandParentProcessFlows/name]"/>
						<xsl:variable name="grandParentRealisedCaps" select="$busUtilitiesAllBusinessCaps[name = $grandParentProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

						<xsl:choose>
							<xsl:when test="count($grandParentRealisedCaps) > 0">
								<xsl:copy-of select="$grandParentRealisedCaps"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="grandParentProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'business_process_used']/value = $grandParentProcesses/name]"/>
								<xsl:variable name="greatGrandParentProcessFlows" select="$busUtilitiesAllBusProcFlows[(name = $grandParentProcessUsages/own_slot_value[slot_reference = 'used_in_process_flow']/value)]"/>
								<xsl:variable name="greatGrandParentProcesses" select="$busUtilitiesAllBusProcsActivities[own_slot_value[slot_reference = 'defining_business_process_flow']/value = $greatGrandParentProcessFlows/name]"/>
								<xsl:variable name="greatGrandParentRealisedCaps" select="$busUtilitiesAllBusinessCaps[name = $greatGrandParentProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>

								<xsl:choose>
									<xsl:when test="count($greatGrandParentRealisedCaps) > 0">
										<xsl:copy-of select="$greatGrandParentRealisedCaps"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="greatGrandParentProcessUsages" select="$busUtilitiesAllBusProcActivityUsages[own_slot_value[slot_reference = 'business_process_used']/value = $greatGrandParentProcesses/name]"/>
										<xsl:variable name="greatGreatGrandParentProcessFlows" select="$busUtilitiesAllBusProcFlows[(name = $greatGrandParentProcessUsages/own_slot_value[slot_reference = 'used_in_process_flow']/value)]"/>
										<xsl:variable name="greatGreatGrandParentProcesses" select="$busUtilitiesAllBusProcsActivities[own_slot_value[slot_reference = 'defining_business_process_flow']/value = $greatGreatGrandParentProcessFlows/name]"/>
										<xsl:variable name="greatGreatGrandParentRealisedCaps" select="$busUtilitiesAllBusinessCaps[name = $greatGreatGrandParentProcesses/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>
										<xsl:copy-of select="$greatGreatGrandParentRealisedCaps"/>
									</xsl:otherwise>
								</xsl:choose>

							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<!-- FUNCTION TO RETRIEVE THE LIST OF CHILD ORGS OF A GIVEN ORG UNIT, INCLUDING THE GIVEN ORG UNIT -->
	<xsl:function name="eas:get_org_descendants" as="node()*">
		<xsl:param name="parentNodes"/>
		<xsl:param name="level"/>

		<xsl:copy-of select="$parentNodes"/>
		<xsl:if test="$level &lt; $busUtilitiesMaxDepth">
			<xsl:variable name="childOrgs" select="$busUtilitiesAllOrgs[name = $parentNodes/own_slot_value[slot_reference = 'contained_sub_actors']/value]" as="node()*"/>
			<xsl:for-each select="$childOrgs">
				<xsl:copy-of select="eas:get_org_descendants(current(), $level + 1)"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:function>

	<!-- TEMPLATE TO PRINT OUT A SKILLS MATRIC TEMPLATE -->
	<xsl:template name="RenderSkillsMatrixTable">
		<xsl:param name="inScopeElements" select="()"/>
		<xsl:param name="elementTypeDisplayString">Element</xsl:param>

		<script type="text/javascript">
			
			var asInitVals = new Array();
			
			$(document).ready(function() {				
			
			var oTable = $('#dt_matrix').dataTable( {
			"bPaginate": false,
			"sScrollY": "200px",
			"bScrollCollapse": true,
			"sPaginationType": "full_numbers",
			"bLengthChange": false,
			"bFilter": true,
			"bSort": false,
			"bInfo": false,
			"bAutoWidth": true,						
			"oLanguage": {
			"sSearch": "<strong><xsl:value-of select="eas:i18n('Search all columns')"/>:</strong>"
			}
			} );
			
			$("tfoot input").keyup( function () {
			/* Filter on the column (the index) of this element */
			oTable.fnFilter( this.value, $("tfoot input").index(this) );
			} );
			
			
			
			/*
			* Support functions to provide a little bit of 'user friendlyness' to the textboxes in 
			* the footer
			*/
			$("tfoot input").each( function (i) {
			asInitVals[i] = this.value;
			} );
			
			$("tfoot input").focus( function () {
			if ( this.className == "search_init" )
			{
			this.className = "";
			this.value = "";
			}
			} );
			
			$("tfoot input").blur( function (i) {
			if ( this.value == "" )
			{
			this.className = "search_init";
			this.value = asInitVals[$("tfoot input").index(this)];
			}
			} );
			
			} );	
		</script>
		<style type="text/css">
			div.dataTables_scrollBody{
				min-height: 150px;
			}</style>
		<style>
			.circleButton{
				cursor: pointer;
			}</style>
		<table class="alignCentre" id="dt_matrix">
			<thead>
				<tr>
					<th rowspan="2" class="cellWidth-160 text-primary vAlignBottom uppercase">
						<xsl:value-of select="$elementTypeDisplayString"/>
					</th>
					<xsl:for-each select="$busUtilsSkillQualifierTerms">
						<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
						<th colspan="2" class="alignCentre vAlignBottom text-primary uppercase small"><xsl:value-of select="current()/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/> Coverage</th>
					</xsl:for-each>

					<!--<th colspan="2" class="alignCentre vAlignBottom text-primary uppercase">Analyst Coverage</th>
                    <th colspan="2" class="alignCentre vAlignBottom text-primary uppercase">Development Coverage</th>
                    <th colspan="2" class="alignCentre vAlignBottom text-primary uppercase">Testing Coverage</th>					
                    <th colspan="2" class="alignCentre vAlignBottom text-primary uppercase">Support Coverage</th>-->
				</tr>
				<tr>
					<xsl:for-each select="$busUtilsSkillQualifierTerms">
						<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
						<xsl:for-each select="$busUtilsSkillLevels">
							<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
							<th class="cellWidth-40 alignCentre">
								<xsl:value-of select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
							</th>
						</xsl:for-each>
					</xsl:for-each>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="$inScopeElements" mode="RenderSkillsTableRow">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</tbody>
			<tfoot id="dt_supportingISCapsFooter">
				<tr>
					<th>
						<input type="text" name="search_name" value="Search Name" class="search_init"/>
					</th>
					<xsl:for-each select="$busUtilsSkillQualifierTerms">
						<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
						<xsl:for-each select="$busUtilsSkillLevels">
							<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
							<th>
								<input type="text" class="search_init">
									<xsl:attribute name="name" select="concat('name_', current()/own_slot_value[slot_reference = 'enumeration_value']/value)"/>
									<xsl:attribute name="value" select="concat('Search ', current()/own_slot_value[slot_reference = 'enumeration_value']/value)"/>
								</input>
							</th>
						</xsl:for-each>
					</xsl:for-each>
				</tr>
			</tfoot>
		</table>
	</xsl:template>


	<!-- TEMPLATE TO PRINT OUT A ROW FOR A SKILL -->
	<xsl:template match="node()" mode="RenderSkillsTableRow">
		<xsl:param name="reposXML">reportXML.xml</xsl:param>

		<xsl:variable name="relevantSkills" select="$busUtilsSkills[own_slot_value[slot_reference = 'skill_for_elements']/value = current()/name]"/>
		<xsl:variable name="relevantSkill2ActorRels" select="$busUtilsSkill2ActorRels[own_slot_value[slot_reference = 'to_skill_actor_relation']/value = $relevantSkills/name]"/>

		<tr>
			<td class="alignLeft">
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
					</xsl:call-template>
				</strong>
			</td>
			<xsl:for-each select="$busUtilsSkillQualifierTerms">
				<xsl:sort select="own_slot_value[slot_reference = 'taxonomy_term_index']/value"/>
				<xsl:variable name="currentSkillQualifier" select="current()"/>
				<xsl:variable name="qualifiedSkill2ActorRels" select="$relevantSkill2ActorRels[own_slot_value[slot_reference = 'element_classified_by']/value = $currentSkillQualifier/name]"/>


				<xsl:for-each select="$busUtilsSkillLevels">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
					<xsl:variable name="currentSkillLevel" select="current()"/>
					<xsl:variable name="qualifiedSkill2ActorRelsForLevel" select="$qualifiedSkill2ActorRels[own_slot_value[slot_reference = 'skill_level']/value = $currentSkillLevel/name]"/>
					<xsl:variable name="actorsForSkill" select="$busUtilitiesAllIndividuals[name = $qualifiedSkill2ActorRelsForLevel/own_slot_value[slot_reference = 'from_actor_skill_relation']/value]"/>

					<td>
						<xsl:variable name="circleColour">
							<xsl:choose>
								<xsl:when test="count($qualifiedSkill2ActorRelsForLevel) = 0">circleButton divCentre backColourRed</xsl:when>
								<xsl:when test="count($qualifiedSkill2ActorRelsForLevel) lt 3">circleButton divCentre backColourOrange</xsl:when>
								<xsl:otherwise>circleButton divCentre backColourGreen</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<div>
							<xsl:attribute name="class" select="$circleColour"/>
							<strong>
								<xsl:value-of select="count($qualifiedSkill2ActorRelsForLevel)"/>
							</strong>
						</div>
						<div class="tooltip">
							<p class="fontBlack text-primary">People</p>
							<xsl:choose>
								<xsl:when test="count($actorsForSkill) = 0">
									<p class="small">
										<em>No people at this level</em>
									</p>
								</xsl:when>
								<xsl:otherwise>
									<ul>
										<xsl:for-each select="$actorsForSkill">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											<li>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
												</xsl:call-template> (<xsl:value-of select="$currentSkillLevel/own_slot_value[slot_reference = 'enumeration_value']/value"/>) </li>
										</xsl:for-each>
									</ul>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</td>
				</xsl:for-each>
			</xsl:for-each>

		</tr>
	</xsl:template>


	<!-- FUNCTION TO RETRIEVE THE STYLE CLASS FOR A GIVEN INSTANCE -->
	<xsl:function name="eas:getElementStyleClass" as="xs:string">
		<xsl:param name="theInstance"/>

		<xsl:variable name="elementStyle" select="$utilitiesAllStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $theInstance/name]"/>
		<xsl:value-of select="$elementStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>

	</xsl:function>


</xsl:stylesheet>
