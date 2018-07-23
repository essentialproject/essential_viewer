<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:functx="http://www.functx.com" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org" xpath-default-namespace="http://protege.stanford.edu/xml">

	<xsl:import href="../common/core_utilities.xsl"/>


	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>

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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->

	<!-- param1 = the subject of the UML model (a Physical Process) -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4"/>-->

	<!-- xSize = an optional width of the resulting model in pixels -->
	<xsl:param name="xSize"/>

	<!-- ySize = an optional height of the resulting model in pixels -->
	<xsl:param name="ySize"/>


	<!-- set up the common variables -->
	<xsl:variable name="allApps" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="overallPhysBusinessProcess" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="containedProcessSteps" select="/node()/simple_instance[name = $overallPhysBusinessProcess/own_slot_value[slot_reference = 'contained_physical_sub_processes']/value]"/>
	<xsl:variable name="containedProcessActor2Roles" select="/node()/simple_instance[name = $containedProcessSteps/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="containedActivityActor2Roles" select="/node()/simple_instance[name = $containedProcessSteps/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value]"/>
	<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name = $containedProcessActor2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="defined_activity_roles" select="/node()/simple_instance[name = $containedActivityActor2Roles/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
	<xsl:variable name="containedProcessAutoFuncs" select="/node()/simple_instance[name = $containedProcessSteps/own_slot_value[slot_reference = 'physical_process_automated_by']/value]"/>

	<xsl:variable name="overallBusinessProcess" select="/node()/simple_instance[name = $overallPhysBusinessProcess/own_slot_value[slot_reference = 'implements_business_process']/value]"/>
	<xsl:variable name="overallProcessFlow" select="/node()/simple_instance[name = $overallBusinessProcess/own_slot_value[slot_reference = 'defining_business_process_flow']/value]"/>
	<xsl:variable name="processFlowRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'contained_in_process_flow']/value = $overallProcessFlow/name]"/>

	<!-- get the list of Business Process Usages in scope -->
	<xsl:variable name="processUsages" select="/node()/simple_instance[own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name]"/>

	<!-- get the list of Business Processes in scope -->
	<xsl:variable name="business_processes" select="/node()/simple_instance[(name = $processUsages/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $processUsages/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>

	<!-- get the list of Business Roles in scope -->
	<!--<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name=$business_processes/own_slot_value[slot_reference='business_process_performed_by_business_role']/value]"/>-->

	<!-- get the start node -->
	<xsl:variable name="startNode" select="/node()/simple_instance[(own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'Start_Process_Flow')]"/>

	<!-- get the end node -->
	<xsl:variable name="endNode" select="/node()/simple_instance[(own_slot_value[slot_reference = 'used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'End_Process_Flow')]"/>

	<xsl:variable name="firstProcessRelation" select="$processFlowRelations[own_slot_value[slot_reference = ':FROM']/value = $startNode/name]"/>
	<xsl:variable name="firstProcessUsage" select="$processUsages[name = $firstProcessRelation/own_slot_value[slot_reference = ':TO']/value]"/>
	<xsl:variable name="firstBusProc" select="$business_processes[(name = $firstProcessUsage/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $firstProcessUsage/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
	<xsl:variable name="firstPhysProcSlot">
		<xsl:choose>
			<xsl:when test="$firstBusProc/type = 'Business_Process'">implements_business_process</xsl:when>
			<xsl:when test="$firstBusProc/type = 'Business_Activity'">instance_of_business_activity</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="firstPhysProc" select="$containedProcessSteps[own_slot_value[slot_reference = $firstPhysProcSlot]/value = $firstBusProc/name]"/>
	<xsl:variable name="firstProcIsAutomated">
		<xsl:choose>
			<xsl:when test="count($firstPhysProc/own_slot_value[slot_reference = 'physical_process_automated_by']/value) > 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="firstProcActor">
		<xsl:call-template name="PhysicalProcessActor">
			<xsl:with-param name="physProc" select="$firstPhysProc"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="endProcessRelation" select="$processFlowRelations[own_slot_value[slot_reference = ':TO']/value = $endNode/name]"/>

	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="count($firstProcessUsage) > 0"> @startuml skinparam svek true skinparam activityBackgroundColor #ffffff skinparam activityBorderColor #666666 skinparam activityArrowColor #666666 skinparam activityFontColor #333333 skinparam activityFontSize 12 skinparam activityFontName Arial skinparam activityBackgroundColor&lt;&lt;automated>> #e4e1cc skinparam activityBackgroundColor&lt;&lt;manual>> #ffffff (*) -down-> <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$firstBusProc"/><xsl:with-param name="isAutomated" select="$firstProcIsAutomated"/><xsl:with-param name="roleName" select="$firstProcActor"/></xsl:call-template>
				<xsl:call-template name="RenderNextStep"><xsl:with-param name="busProcUsage" select="$firstProcessUsage"/></xsl:call-template> @enduml </xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderEmptyUMLModel">
					<xsl:with-param name="message" select="'No Business Process Flow Defined'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<xsl:template name="RenderNextStep">
		<xsl:param name="busProcUsage"/>
		<!--<xsl:param name="inScopeRelations"/>
		<xsl:param name="usedRelations"/>-->

		<xsl:variable name="nextProcRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':FROM']/value = $busProcUsage/name]"/>
		<xsl:variable name="thisBusProc" select="$business_processes[(name = $busProcUsage/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $busProcUsage/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
		<xsl:variable name="thisBusProcStrippedName">
			<xsl:call-template name="RenderStrippedName">
				<xsl:with-param name="name" select="$thisBusProc/own_slot_value[slot_reference = 'name']/value"/>
			</xsl:call-template>
		</xsl:variable>

		<!--<xsl:variable name="physProcSlot">
			<xsl:choose>
				<xsl:when test="$thisBusProc/type = 'Business_Process'">implements_business_process</xsl:when>
				<xsl:when test="$thisBusProc/type = 'Business_Activity'">instance_of_business_activity</xsl:when>
			</xsl:choose>			
		</xsl:variable>		
		<xsl:variable name="thisPhysProc" select="$containedProcessSteps[own_slot_value[slot_reference=$physProcSlot]/value = $thisBusProc/name]"/>
		<xsl:variable name="isAutomated">
			<xsl:choose>
				<xsl:when test="count($thisPhysProc/own_slot_value[slot_reference='physical_process_automated_by']/value) > 0">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		
		<xsl:variable name="thisProcActor">
			<xsl:call-template name="PhysicalProcessActor"><xsl:with-param name="physProc" select="$thisPhysProc"/></xsl:call-template>
		</xsl:variable>-->

		<xsl:choose>
			<!-- Create parallel activities if there is more than one next step starting with the given usage -->
			<xsl:when test="count($nextProcRelations) > 1">
				<!-- Create the link between the given usage and a parralel bar with a unique name (based on the previous process usage -->
				<xsl:variable name="startConcurrentBarName" select="concat($thisBusProcStrippedName, 'StartBar')"/> "<xsl:value-of select="$thisBusProcStrippedName"/>" --> ===<xsl:value-of select="$startConcurrentBarName"/>=== <!-- For each parallel relation, create a link between the parallel bar and the process on the other end -->
				<xsl:for-each select="$nextProcRelations">
					<xsl:variable name="nextRelation" select="current()"/>
					<xsl:choose>
						<xsl:when test="current()/name = $endProcessRelation/name"> ===<xsl:value-of select="$startConcurrentBarName"/>=== --> (*) </xsl:when>
						<xsl:otherwise>
							<xsl:variable name="nextProcessUsage" select="$processUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
							<xsl:variable name="nextBusProc" select="$business_processes[(name = $nextProcessUsage/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $nextProcessUsage/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
							<xsl:variable name="nextPhysProcSlot">
								<xsl:choose>
									<xsl:when test="$nextBusProc/type = 'Business_Process'">implements_business_process</xsl:when>
									<xsl:when test="$nextBusProc/type = 'Business_Activity'">instance_of_business_activity</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="nextPhysProc" select="$containedProcessSteps[own_slot_value[slot_reference = $nextPhysProcSlot]/value = $nextBusProc/name]"/>
							<xsl:variable name="nextIsAutomated">
								<xsl:choose>
									<xsl:when test="count($nextPhysProc/own_slot_value[slot_reference = 'physical_process_automated_by']/value) > 0">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="nextProcActor">
								<xsl:call-template name="PhysicalProcessActor"><xsl:with-param name="physProc" select="$nextPhysProc"/></xsl:call-template>
							</xsl:variable> ===<xsl:value-of select="$startConcurrentBarName"/>=== --> <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/><xsl:with-param name="isAutomated" select="$nextIsAutomated"/><xsl:with-param name="roleName" select="$nextProcActor"/></xsl:call-template>
							<xsl:call-template name="RenderNextStep"><xsl:with-param name="busProcUsage" select="$nextProcessUsage"/></xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="count($nextProcRelations) = 1">
				<xsl:variable name="nextProcessUsage" select="$processUsages[name = $nextProcRelations/own_slot_value[slot_reference = ':TO']/value]"/>
				<xsl:variable name="nextBusProc" select="$business_processes[(name = $nextProcessUsage/own_slot_value[slot_reference = 'business_process_used']/value) or (name = $nextProcessUsage/own_slot_value[slot_reference = 'business_activity_used']/value)]"/>
				<xsl:variable name="nextBusProcStrippedName">
					<xsl:call-template name="RenderStrippedName">
						<xsl:with-param name="name" select="$nextBusProc/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="nextProcessFlowRelations" select="$processFlowRelations[own_slot_value[slot_reference = ':TO']/value = $nextProcessUsage/name]"/>
				<xsl:variable name="nextPhysProcSlot">
					<xsl:choose>
						<xsl:when test="$nextBusProc/type = 'Business_Process'">implements_business_process</xsl:when>
						<xsl:when test="$nextBusProc/type = 'Business_Activity'">instance_of_business_activity</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="nextPhysProc" select="$containedProcessSteps[own_slot_value[slot_reference = $nextPhysProcSlot]/value = $nextBusProc/name]"/>
				<xsl:variable name="nextIsAutomated">
					<xsl:choose>
						<xsl:when test="count($nextPhysProc/own_slot_value[slot_reference = 'physical_process_automated_by']/value) > 0">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="nextProcActor">
					<xsl:call-template name="PhysicalProcessActor">
						<xsl:with-param name="physProc" select="$nextPhysProc"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<!-- Close parallel activities for this step if there is one or more other relations going to the next step -->
					<xsl:when test="count($nextProcessFlowRelations) > 1">
						<xsl:variable name="endConcurrentBarName" select="concat($nextBusProcStrippedName, 'EndBar')"/> "<xsl:value-of select="$thisBusProcStrippedName"/>" --> ===<xsl:value-of select="$endConcurrentBarName"/>=== <xsl:if test="position() = 1">
							<xsl:choose>
								<xsl:when test="$nextProcRelations/name = $endProcessRelation/name"> ===<xsl:value-of select="$endConcurrentBarName"/>=== --> (*) </xsl:when>
								<xsl:otherwise> ===<xsl:value-of select="$endConcurrentBarName"/>=== --> <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/><xsl:with-param name="isAutomated" select="$nextIsAutomated"/><xsl:with-param name="roleName" select="$nextProcActor"/></xsl:call-template>
									<xsl:call-template name="RenderNextStep"><xsl:with-param name="busProcUsage" select="$nextProcessUsage"/></xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:when>
					<xsl:when test="count($nextProcessFlowRelations) = 1">
						<xsl:choose>
							<xsl:when test="$nextProcRelations/name = $endProcessRelation/name"> "<xsl:value-of select="$thisBusProcStrippedName"/>" --> (*) </xsl:when>
							<xsl:otherwise> "<xsl:value-of select="$thisBusProcStrippedName"/>" --> <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/><xsl:with-param name="isAutomated" select="$nextIsAutomated"/><xsl:with-param name="roleName" select="$nextProcActor"/></xsl:call-template>
								<xsl:call-template name="RenderNextStep"><xsl:with-param name="busProcUsage" select="$nextProcessUsage"/></xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>

	</xsl:template>




	<!--<xsl:template name="RenderBusinessProcess"><xsl:param name="roleName"/><xsl:param name="isAutomated"/><xsl:param name="busProc"/><xsl:variable name="busProcName" select="$busProc/own_slot_value[slot_reference='name']/value"/><xsl:variable name="strippedBusProcName" select="translate($busProcName, translate($busProcName,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',''),'')"/>	<xsl:variable name="busRoles" select="$defined_business_roles[name=$busProc/own_slot_value[slot_reference='business_process_performed_by_business_role']/value]"/>"<xsl:value-of select="$busProcName"/><xsl:call-template name="RenderBusinessRole"><xsl:with-param name="roleName"></xsl:with-param></xsl:call-template>" as <xsl:value-of select="$strippedBusProcName"/><xsl:if test="$isAutomated='true'"><xsl:text>&lt;&lt;automated>></xsl:text></xsl:if></xsl:template>-->

	<xsl:template name="RenderBusinessProcess"><xsl:param name="roleName"/><xsl:param name="isAutomated"/><xsl:param name="busProc"/><xsl:variable name="busProcName" select="$busProc/own_slot_value[slot_reference = 'name']/value"/><xsl:variable name="strippedBusProcName" select="translate($busProcName, translate($busProcName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/> "<xsl:value-of select="$busProcName"/><xsl:call-template name="RenderBusinessRole"><xsl:with-param name="roleName" select="$roleName"/></xsl:call-template>" as <xsl:value-of select="$strippedBusProcName"/><xsl:if test="$isAutomated = 'true'"><xsl:text>&lt;&lt;automated>></xsl:text></xsl:if></xsl:template>


	<!--<xsl:template mode="RenderBusinessRole" match="node()"><xsl:variable name="roleName" select="own_slot_value[slot_reference='name']/value"/>\n&lt;size:10>&lt;color:#6593c8>&lt;b><xsl:value-of select="$roleName"/>&lt;/b>&lt;/color>&lt;/size></xsl:template>-->

	<xsl:template name="RenderBusinessRole"><xsl:param name="roleName"/>\n&lt;size:10>&lt;color:#6593c8>&lt;b><xsl:value-of select="$roleName"/>&lt;/b>&lt;/color>&lt;/size></xsl:template>

	<xsl:template name="RenderStrippedName">
		<xsl:param name="name"/>
		<xsl:value-of select="translate($name, translate($name, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>
	</xsl:template>

	<xsl:template name="PhysicalProcessActor">
		<xsl:param name="physProc"/>

		<xsl:variable name="automatingFunction" select="$containedProcessAutoFuncs[name = $physProc/own_slot_value[slot_reference = 'physical_process_automated_by']/value]"/>
		<xsl:choose>
			<xsl:when test="count($automatingFunction) > 0">
				<xsl:variable name="automatingApp" select="$allApps[own_slot_value[slot_reference = 'provides_application_function_implementations']/value = $automatingFunction[1]/name]"/>
				<xsl:variable name="parentApp" select="$allApps[own_slot_value[slot_reference = 'contained_application_providers']/value = $automatingApp/name]"/>
				<xsl:choose>
					<xsl:when test="count($parentApp) > 0">
						<xsl:value-of select="$parentApp/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$automatingApp/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$physProc/type = 'Physical_Process'">
						<xsl:variable name="procActor2Role" select="$containedProcessActor2Roles[name = $physProc/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
						<xsl:variable name="procRole" select="$defined_business_roles[name = $procActor2Role/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
						<xsl:value-of select="$procRole/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:when test="$physProc/type = 'Physical_Activity'">
						<xsl:variable name="activityActor2Role" select="$containedActivityActor2Roles[name = $physProc/own_slot_value[slot_reference = 'activity_performed_by_actor_role']/value]"/>
						<xsl:variable name="activityRole" select="$defined_activity_roles[name = $activityActor2Role/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
						<xsl:value-of select="$activityRole/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>




</xsl:stylesheet>
