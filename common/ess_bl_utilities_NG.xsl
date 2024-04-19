<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml">
	<xsl:import href="../common/core_utilities.xsl"/>


	<xsl:param name="busUtilitiesAllOrgsXML"/>
	<xsl:param name="busUtilitiesAllIndividualsXML"/>
	<xsl:param name="busUtilitiesAllBusinessCapsXML"/>
	<xsl:param name="busUtilitiesAllBusCapRolesXML"/>
	<xsl:param name="busUtilitiesAllBusProcFlowsXML"/>
	<xsl:param name="busUtilitiesAllBusProcsActivitiesXML"/>
	<xsl:param name="busUtilitiesAllBusProcActivityUsagesXML"/>
	<xsl:param name="busUtilitiesAllChildCap2ParentCapRelsXML"/>
	<eas:apiRequests>
		{
			"apiRequestSet": [
				<!-- Get single instance with ID matching the "theSubjectID" parameter-->
				{"variable": "busUtilitiesAllOrgsXML", "query": "/instances/type/Group_Actor"},
				{"variable": "busUtilitiesAllIndividualsXML", "query": "/instances/type/Individual_Actor"},
				{"variable": "busUtilitiesAllBusinessCapsXML", "query": "/instances/type/Business_Capability"},
				{"variable": "busUtilitiesAllBusCapRolesXML", "query": "/instances/type/Business_Capability_Role"},
				{"variable": "busUtilitiesAllBusProcFlowsXML", "query": "/instances/type/Business_Process_Flow"},
				{"variable": "busUtilitiesAllBusProcsActivitiesXML", "query": "/instances/multiple_types?type=Business_Process&amp;type=Business_Activity"},
				{"variable": "busUtilitiesAllBusProcActivityUsagesXML", "query": "/instances/multiple_types?type=Business_Process_Usage&amp;type=Business_Activity_Usage"},
				{"variable": "busUtilitiesAllChildCap2ParentCapRelsXML", "query": "/instances/type/BUSCAP_TO_PARENTBUSCAP_RELATION"}
			]
		}
	</eas:apiRequests>
	<xsl:variable name="busUtilitiesAllOrgs" select="$busUtilitiesAllOrgsXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllIndividuals" select="$busUtilitiesAllIndividualsXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllBusinessCaps" select="$busUtilitiesAllBusinessCapsXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllBusCapRoles" select="$busUtilitiesAllBusCapRolesXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllBusProcFlows" select="$busUtilitiesAllBusProcFlowsXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllBusProcsActivities" select="$busUtilitiesAllBusProcsActivitiesXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllBusProcActivityUsages" select="$busUtilitiesAllBusProcActivityUsagesXML//simple_instance"/>
	<xsl:variable name="busUtilitiesAllChildCap2ParentCapRels" select="$busUtilitiesAllChildCap2ParentCapRelsXML//simple_instance"/>

	<!-- Collect all available org units -->
	<!-- <xsl:variable name="busUtilitiesAllOrgs" select="/node()/simple_instance[(type = 'Group_Actor')]"/>
	<xsl:variable name="busUtilitiesAllIndividuals" select="/node()/simple_instance[(type = 'Individual_Actor')]"/> -->
	<xsl:variable name="busUtilitiesMaxDepth" select="10"/>


	<!-- Collect all available business capabilities -->
	<!-- <xsl:variable name="busUtilitiesAllBusinessCaps" select="/node()/simple_instance[(type = 'Business_Capability')]"/>
	<xsl:variable name="busUtilitiesAllBusCapRoles" select="/node()/simple_instance[type = 'Business_Capability_Role']"/>

	<xsl:variable name="busUtilitiesAllBusProcFlows" select="/node()/simple_instance[type = 'Business_Process_Flow']"/>
	<xsl:variable name="busUtilitiesAllBusProcsActivities" select="/node()/simple_instance[(type = 'Business_Process') or (type = 'Business_Activity')]"/>
	<xsl:variable name="busUtilitiesAllBusProcActivityUsages" select="/node()/simple_instance[(type = 'Business_Process_Usage') or (type = 'Business_Activity_Usage')]"/> -->

	<xsl:variable name="busUtilitiesCapFrontPositon" select="$busUtilitiesAllBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Front']"/>
	<xsl:variable name="busUtilitiesCapBackPositon" select="$busUtilitiesAllBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Back']"/>
	<xsl:variable name="busUtilitiesCapManagePositon" select="$busUtilitiesAllBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Manage']"/>

	<!-- <xsl:variable name="busUtilitiesAllChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/> -->
	<xsl:variable name="busUtilitiesAllBackBusCapRelss" select="$busUtilitiesAllChildCap2ParentCapRels[own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $busUtilitiesCapBackPositon/name]"/>
	<xsl:variable name="busUtilitiesAllManageBusCapRelss" select="$busUtilitiesAllChildCap2ParentCapRels[own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $busUtilitiesCapManagePositon/name]"/>

	<xsl:variable name="busUtilsRootBusReferenceModelReport" select="$utilitiesAllReports[own_slot_value[slot_reference = 'name']/value = 'ESS: Business Reference Model']"/>
	<xsl:variable name="busUtilsDrillDownBusReferenceModelReport" select="$utilitiesAllReports[own_slot_value[slot_reference = 'name']/value = 'ESS: Business Reference Model Drill Down']"/>
	<xsl:variable name="busUtilsBusCapSummaryReport" select="$utilitiesAllReports[own_slot_value[slot_reference = 'name']/value = 'ESS: Business Capability Summary']"/>

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



	<!-- FUNCTION TO RETRIEVE THE STYLE CLASS FOR A GIVEN INSTANCE -->
	<xsl:function name="eas:getElementStyleClass" as="xs:string">
		<xsl:param name="theInstance"/>

		<xsl:variable name="elementStyle" select="$utilitiesAllElementStyles[own_slot_value[slot_reference = 'style_for_elements']/value = $theInstance/name]"/>
		<xsl:value-of select="$elementStyle/own_slot_value[slot_reference = 'element_style_class']/value"/>

	</xsl:function>


</xsl:stylesheet>
