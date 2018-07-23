<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes" />
	
	<xsl:param name="theURLPrefix"/>
	<xsl:param name="theURLFullPath"/>
	<xsl:param name="theCurrentURL"/>
	
	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	
	<!-- xSize = an optional width of the resulting model in pixels -->
	<xsl:param name="xSize"/>
	
	<!-- ySize = an optional height of the resulting model in pixels -->
	<xsl:param name="ySize"/>
	

	<!-- set up the common variables -->
	<xsl:variable name="overallBusinessProcess" select="/node()/simple_instance[name=$param1]"/>
	<xsl:variable name="overallProcessFlow" select="/node()/simple_instance[name=$overallBusinessProcess/own_slot_value[slot_reference='defining_business_process_flow']/value]"/>
	<xsl:variable name="processFlowRelations" select="/node()/simple_instance[own_slot_value[slot_reference='contained_in_process_flow']/value = $overallProcessFlow/name]"/>
	<xsl:variable name="wrapLength" select="4"/>
	
	<!-- get the list of Business Process Usages in scope -->
	<xsl:variable name="allProcessUsages" select="/node()/simple_instance[own_slot_value[slot_reference='used_in_process_flow']/value = $overallProcessFlow/name]"/>
	<xsl:variable name="processUsages" select="$allProcessUsages[(type = 'Business_Activity_Usage') or (type = 'Business_Process_Usage')]"/>
	<xsl:variable name="decisionUsages" select="$allProcessUsages[(type = 'Business_Process_Flow_Decision')]"/>
	
	<xsl:variable name="startUsage" select="$allProcessUsages[(type = 'Start_Process_Flow')]"/>
	<xsl:variable name="startRelations" select="$processFlowRelations[own_slot_value[slot_reference=':FROM']/value = $startUsage/name]"/>
	
	<!-- get the list of Business Processes in scope -->
	<xsl:variable name="business_processes" select="/node()/simple_instance[(name=$processUsages/own_slot_value[slot_reference='business_process_used']/value) or (name=$processUsages/own_slot_value[slot_reference='business_activity_used']/value)]"/>
	
	<!-- get the list of Business Roles in scope -->
	<xsl:variable name="defined_business_roles" select="/node()/simple_instance[name=$business_processes/own_slot_value[slot_reference='business_process_owned_by_business_role']/value]"/>
	<xsl:variable name="decisionMakers" select="/node()/simple_instance[name=$decisionUsages/own_slot_value[slot_reference='bpfd_decision_makers']/value]"/>
	
	
	
	<!-- get the list of Start Events in scope -->
	<xsl:variable name="startEventUsages" select="$allProcessUsages[type = 'Initiating_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="startEvents" select="/node()/simple_instance[name = $startEventUsages/own_slot_value[slot_reference='usage_of_business_event_in_process']/value]"/>
	<xsl:variable name="startEventRelations" select="$processFlowRelations[own_slot_value[slot_reference=':FROM']/value = $startEventUsages/name]"/>
	
	<!-- get the list of Goal Events in scope -->
	<xsl:variable name="goalEventUsages" select="$allProcessUsages[type = 'Raised_Business_Event_Usage_In_Process']"/>
	<xsl:variable name="goalEvents" select="/node()/simple_instance[name = $goalEventUsages/own_slot_value[slot_reference='usage_of_business_event_in_process']/value]"/>
	
	<!-- get the end node -->
	<xsl:variable name="endNode" select="/node()/simple_instance[(own_slot_value[slot_reference='used_in_process_flow']/value = $overallProcessFlow/name) and (type = 'End_Process_Flow')]"/>
	
	
	<xsl:variable name="firstProcessUsage" select="$processUsages[(name= ($startEventRelations, $startRelations)/own_slot_value[slot_reference=':TO']/value)]"/>
	<xsl:variable name="firstBusProc" select="$business_processes[(name=$firstProcessUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$firstProcessUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>

	
	<xsl:variable name="endProcessRelation" select="$processFlowRelations[own_slot_value[slot_reference=':TO']/value = $goalEventUsages/name]"/>
	<xsl:variable name="relationList" select="eas:generateRelationList($firstProcessUsage, $processFlowRelations[not(name = $startEventRelations/name)], ())"/>
	
	<xsl:variable name="peopleIconList" select="('person-icon-darkblue.png','person-icon-green.png','person-icon-lightblue.png','person-icon-pink.png','person-icon-purple.png','person-icon-red.png','person-icon-yellow.png','person-icon-brown.png')"/>
	<xsl:variable name="undefinedPeopleIcon" select="'person-icon-empty.png'"/>
	<xsl:variable name="peopleColourList" select="('#313CA3','#417505','#4A90E2','#E09CA4','#824DB1','#D0021B','#F5A623','#8B572A')"/>
	
	<xsl:variable name="urlWithoutHTTP" select="substring-after($theURLFullPath,'//')"/>
 	<xsl:variable name="urlAfterDomain" select="substring-after($urlWithoutHTTP,'/')"/>
 	<xsl:variable name="webAppName" select="substring-before($urlAfterDomain,'/')"/>
	<xsl:variable name="cleanURI" select="replace(resolve-uri(''),'%20',' ')"></xsl:variable>
	<xsl:variable name="currentFilePath" select="substring-after(substring-before($cleanURI,$webAppName),'file:')"></xsl:variable>
	
	<xsl:variable name="DEBUG" select="''"/>
	
	<xsl:template match="knowledge_base">
		
		<xsl:choose>
			<xsl:when test="count($firstProcessUsage) > 0">
				@startuml
				skinparam svek true
				skinparam activityBackgroundColor #ffffff
				skinparam activityBackgroundColor&lt;&lt; question >> #a9c66f
				skinparam activityBorderColor #666666
				skinparam activityArrowColor #666666
				skinparam activityFontColor #333333 
				skinparam activityFontSize 12
				skinparam activityFontName Arial
				skinparam noteFontName Arial
				skinparam noteFontSize 12
				skinparam noteBackgroundColor #6593c8
				skinparam noteBackgroundColor&lt;&lt; start >> #6593c8
				skinparam noteBorderColor #eeeeee
				skinparam noteFontColor #ffffff
				
				<xsl:for-each select="$firstProcessUsage">
					<xsl:variable name="thisBusProc" select="$business_processes[(name=current()/own_slot_value[slot_reference='business_process_used']/value) or (name=current()/own_slot_value[slot_reference='business_activity_used']/value)]"/>
					(*) -down-> <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$thisBusProc"/></xsl:call-template><xsl:text disable-output-escaping="yes">&#13;</xsl:text>
					<xsl:variable name="thisStartEventRelations" select="$startEventRelations[own_slot_value[slot_reference=':TO']/value = current()/name]"/>
					<xsl:if test="count($thisStartEventRelations) > 0">
						<xsl:for-each select="$thisStartEventRelations">
							<xsl:text disable-output-escaping="yes">&#13;</xsl:text><xsl:call-template name="RenderStartEvent"><xsl:with-param name="eventRelation" select="current()"/></xsl:call-template>
						</xsl:for-each>
					</xsl:if><xsl:text>
										
									</xsl:text>
				</xsl:for-each>
				
				<xsl:call-template name="NewRenderRelationList"><xsl:with-param name="inScopeRelations" select="$relationList"/><xsl:with-param name="usedRelations" select="()"/></xsl:call-template>

				@enduml
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderEmptyUMLModel">
					<xsl:with-param name="message"><xsl:value-of select="eas:i18n('No Flow Defined for this Process')"/><xsl:value-of select="$DEBUG"/></xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>	
	
	
	<xsl:function name="eas:generateDecisionRelationList" as="node()*">
		<xsl:param name="decisions"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="relationsFound"/>
		
		<xsl:variable name="responseRelations" select="$inScopeRelations[own_slot_value[slot_reference=':FROM']/value = $decisions/name]"/>
		<xsl:variable name="nextDecisionRelations" select="$responseRelations[(own_slot_value[slot_reference=':TO']/value = $decisionUsages/name)]"/>
		<xsl:variable name="nextProcessUsages" select="$allProcessUsages[name= $responseRelations/own_slot_value[slot_reference=':TO']/value]"/>
		
		<xsl:choose>
			<xsl:when test="count($nextDecisionRelations) > 0">
				<xsl:variable name="nextDecisions" select="$allProcessUsages[name = $nextDecisionRelations/own_slot_value[slot_reference=':TO']/value]"/>
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $responseRelations"/>
				
				<xsl:variable name="childDecisionRelations" select="eas:generateDecisionRelationList($nextDecisions, $newInScopeRelations, ())"/>
				
				<xsl:variable name="otherProcUsages" select="$nextProcessUsages except $nextDecisions"/>
				<xsl:variable name="otherProcRelations" select="$responseRelations[own_slot_value[slot_reference=':TO']/value = $otherProcUsages/name]"/>
				
				<xsl:variable name="allSubDecisionRelations" select="$otherProcRelations , $nextDecisionRelations, $childDecisionRelations"/>
				
				<xsl:choose>
					<xsl:when test="count($otherProcUsages) > 0">
						<xsl:sequence select="eas:generateRelationList($otherProcUsages, $newInScopeRelations except $allSubDecisionRelations, $allSubDecisionRelations)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$relationsFound, $allSubDecisionRelations"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($responseRelations) > 0">
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $responseRelations"/>	
				
				<xsl:sequence select="eas:generateRelationList($nextProcessUsages, $newInScopeRelations, $responseRelations)"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$relationsFound"/>
			</xsl:otherwise>
		</xsl:choose>	
		
	</xsl:function>
	
	
	<xsl:function name="eas:generateRelationList" as="node()*">
		<xsl:param name="busProcUsage"/>
		<xsl:param name="inScopeRelations"/>
		<xsl:param name="relationsFound"/>
		
		
		<xsl:variable name="nextProcRelations" select="$inScopeRelations[(own_slot_value[slot_reference=':FROM']/value = $busProcUsage/name)]"/>				
		<xsl:variable name="nextProcessUsages" select="$allProcessUsages[(name= $nextProcRelations/own_slot_value[slot_reference=':TO']/value)]"/>
		
		<xsl:variable name="nextDecisionRelations" select="$nextProcRelations[(own_slot_value[slot_reference=':TO']/value = $decisionUsages/name)]"/>
		
		<xsl:choose>
			<xsl:when test="count($nextDecisionRelations) > 0">
						
				<xsl:variable name="decisionInScopeRelations" select="$inScopeRelations except $nextDecisionRelations"/>					
				<xsl:variable name="nextDecisionUsages" select="$allProcessUsages[(name= $nextDecisionRelations/own_slot_value[slot_reference=':TO']/value)]"/>
				
				<xsl:variable name="decisionRelationList" select="eas:generateDecisionRelationList($nextDecisionUsages, $decisionInScopeRelations, $nextDecisionRelations)"/>	
				
				<xsl:variable name="otherProcUsages" select="$nextProcessUsages except $nextDecisionUsages"/>
				<xsl:variable name="otherProcRelations" select="$nextProcRelations[own_slot_value[slot_reference=':TO']/value = $otherProcUsages/name]"/>
				
				<xsl:choose>
					<xsl:when test="count($otherProcUsages) > 0">
						<xsl:sequence select="eas:generateRelationList($otherProcUsages, $decisionInScopeRelations except $decisionRelationList, ($otherProcRelations, $nextDecisionRelations , $decisionRelationList))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$relationsFound, $nextDecisionRelations , $decisionRelationList"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($nextProcRelations) > 0">
				<xsl:variable name="newInScopeRelations" select="$inScopeRelations except $nextProcRelations"/>	
				
				<xsl:sequence select="eas:generateRelationList($nextProcessUsages, $newInScopeRelations, ($relationsFound , $nextProcRelations))"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$relationsFound, $nextProcRelations"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	
	<xsl:template name="NewRenderRelationList">
		<xsl:param name="usedRelations" select="()"/>
		<xsl:param name="inScopeRelations"/>
		
		<xsl:if test="count($inScopeRelations) > 0">
			<xsl:variable name="thisRelation" select="$inScopeRelations[1]"/>
			<xsl:variable name="newInScopeRelationList" select="remove($inScopeRelations, 1)"/>
			<xsl:variable name="newUsedRelationList" select="insert-before($usedRelations, count($usedRelations) + 1, $thisRelation)"/>
			
			<xsl:variable name="busProcUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':FROM']/value]"/>
			<xsl:variable name="thisBusProc" select="$business_processes[(name=$busProcUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$busProcUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
			<xsl:variable name="thisBusProcStrippedName"><xsl:call-template name="RenderStrippedName"><xsl:with-param name="name" select="$thisBusProc/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:variable>
			
			<xsl:variable name="nextProcessUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':TO']/value]"/>
			<xsl:variable name="nextBusProc" select="$business_processes[(name=$nextProcessUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$nextProcessUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
			
			<xsl:choose>
				
				<xsl:when test="$busProcUsage/type = 'Business_Process_Flow_Decision'">
					<xsl:variable name="decisionStrippedName"><xsl:call-template name="RenderStrippedName"><xsl:with-param name="name" select="$busProcUsage/own_slot_value[slot_reference='business_process_arch_display_label']/value"/></xsl:call-template></xsl:variable>
					
					
					<!-- Print out the decision instance -->
					<xsl:if test="$busProcUsage/name = $usedRelations/own_slot_value[slot_reference=':FROM']/value">
						<xsl:text>else</xsl:text>
					</xsl:if>
					
					<xsl:variable name="decisionResponse">
						<xsl:choose>
							<xsl:when test="count($thisRelation/own_slot_value[slot_reference=':relation_commentary']/value) > 0">
								<xsl:call-template name="RenderMultiLangCommentarySlot">
									<xsl:with-param name="theSubjectInstance" select="$thisRelation"/>
									<xsl:with-param name="slotName" select="':relation_commentary'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$thisRelation/own_slot_value[slot_reference=':relation_label']/value"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$nextProcessUsage/type = 'Business_Process_Flow_Decision'">		
							--> [<xsl:value-of select="$decisionResponse"/>] <xsl:call-template name="RenderDecision"><xsl:with-param name="decision" select="$nextProcessUsage"/></xsl:call-template><xsl:text>			
									</xsl:text>
							<xsl:if test="count($newInScopeRelationList[own_slot_value[slot_reference=':FROM']/value = $nextProcessUsage/name]) > 0">
								<xsl:text>			
									if " " then
									</xsl:text>
							</xsl:if>
	
							<xsl:call-template name="NewRenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							--> [<xsl:value-of select="$decisionResponse"/>] <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/></xsl:call-template><xsl:text>						
									</xsl:text>
							<!-- Print out any goal events for the next process -->
							<xsl:variable name="thisGoalEventRelations" select="$processFlowRelations[(own_slot_value[slot_reference=':FROM']/value = $nextProcessUsage/name) and (own_slot_value[slot_reference=':TO']/value = $goalEventUsages/name)]"/>
							<xsl:if test="count($thisGoalEventRelations) > 0">
								<xsl:text disable-output-escaping="yes">&#13;</xsl:text><xsl:call-template name="RenderGoalEvent"><xsl:with-param name="eventRelation" select="$thisGoalEventRelations[1]"/></xsl:call-template>
							</xsl:if><xsl:text>							
									</xsl:text>
							<xsl:call-template name="NewRenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<!--<xsl:call-template name="RenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="nextProcessUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':TO']/value]"/>
					
					<xsl:choose>
						<xsl:when test="$nextProcessUsage/type = 'Business_Process_Flow_Decision'">
							<xsl:text>						
									</xsl:text>"<xsl:value-of select="$thisBusProcStrippedName"/>" --><xsl:call-template name="RenderDecision"><xsl:with-param name="decision" select="$nextProcessUsage"/></xsl:call-template><xsl:text>			
									if " " then
									</xsl:text>
						</xsl:when>	
						<xsl:when test="$thisRelation/name = $endProcessRelation/name">
							<!-- IGNORE END RELATIONS -->
							<!---\-> [<xsl:value-of select="$decisionResponse"/>] (*)-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="count($nextBusProc) > 0">
								<xsl:text>						
										</xsl:text>"<xsl:value-of select="$thisBusProcStrippedName"/>" --><xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/></xsl:call-template><xsl:text>			
										</xsl:text>
								<!-- Print out any goal events for the next process -->
								<xsl:variable name="thisGoalEventRelations" select="$processFlowRelations[(own_slot_value[slot_reference=':FROM']/value = $nextProcessUsage/name) and (own_slot_value[slot_reference=':TO']/value = $goalEventUsages/name)]"/>
								<xsl:if test="count($thisGoalEventRelations) > 0">
									<xsl:text disable-output-escaping="yes">&#13;</xsl:text><xsl:call-template name="RenderGoalEvent"><xsl:with-param name="eventRelation" select="$thisGoalEventRelations[1]"/></xsl:call-template><xsl:text>					
										</xsl:text>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>	
					<xsl:call-template name="NewRenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>		
	</xsl:template>
	
	
	
	
	
	<xsl:template name="RenderRelationList">
		<xsl:param name="usedRelations" select="()"/>
		<xsl:param name="inScopeRelations"/>
		
		<xsl:if test="count($inScopeRelations) > 0">
			<xsl:variable name="thisRelation" select="$inScopeRelations[1]"/>
			<xsl:variable name="newInScopeRelationList" select="remove($inScopeRelations, 1)"/>
			<xsl:variable name="newUsedRelationList" select="insert-before($usedRelations, count($usedRelations) + 1, $thisRelation)"/>
			
			<xsl:choose>
				<xsl:when test="not($thisRelation/name = $usedRelations/name)">
					<xsl:variable name="busProcUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':FROM']/value]"/>
					<xsl:variable name="thisBusProc" select="$business_processes[(name=$busProcUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$busProcUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
					<xsl:variable name="thisBusProcStrippedName"><xsl:call-template name="RenderStrippedName"><xsl:with-param name="name" select="$thisBusProc/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:variable>
					
					<xsl:variable name="nextProcessUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':TO']/value]"/>
					<xsl:variable name="nextBusProc" select="$business_processes[(name=$nextProcessUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$nextProcessUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
					
					<xsl:choose>
						<!-- Create parallel activities if there is more than one next step starting with the given usage -->
						
						<xsl:when test="$busProcUsage/type = 'Business_Process_Flow_Decision'">
							
							<!-- Print out the decision instance -->
							<xsl:choose>
								<xsl:when test="not($busProcUsage/name = $usedRelations/own_slot_value[slot_reference=':FROM']/value)">
									<!--<xsl:text>if "</xsl:text><xsl:value-of select="$busProcUsage/own_slot_value[slot_reference='business_process_arch_display_label']/value"/><xsl:text>" then</xsl:text>-->
									<xsl:text>if " " then</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>
									else</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:variable name="decisionResponse" select="$thisRelation/own_slot_value[slot_reference=':relation_label']/value"/>
							<xsl:variable name="nextProcessUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':TO']/value]"/>
							<xsl:choose>
								<xsl:when test="$nextProcessUsage/type = 'Business_Process_Flow_Decision'">
									--> [<xsl:value-of select="$decisionResponse"/>] <xsl:text>if "</xsl:text><xsl:value-of select="$nextProcessUsage/own_slot_value[slot_reference='business_process_arch_display_label']/value"/><xsl:text>" then</xsl:text>
									<xsl:call-template name="RenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="nextBusProc" select="$business_processes[(name=$nextProcessUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$nextProcessUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
								--> [<xsl:value-of select="$decisionResponse"/>] <xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/></xsl:call-template><xsl:text>						
									</xsl:text>
									<!-- Print out any goal events for the next process -->
									<xsl:variable name="thisGoalEventRelations" select="$processFlowRelations[(own_slot_value[slot_reference=':FROM']/value = $nextProcessUsage/name) and (own_slot_value[slot_reference=':TO']/value = $goalEventUsages/name)]"/>
									<xsl:if test="count($thisGoalEventRelations) > 0">
										<xsl:text disable-output-escaping="yes">&#13;</xsl:text><xsl:call-template name="RenderGoalEvent"><xsl:with-param name="eventRelation" select="$thisGoalEventRelations[1]"/></xsl:call-template>
									</xsl:if><xsl:text>							
									</xsl:text>
									<xsl:call-template name="RenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							<!--<xsl:call-template name="RenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="nextProcessUsage" select="$allProcessUsages[name= $thisRelation/own_slot_value[slot_reference=':TO']/value]"/>
							<xsl:variable name="nextBusProc" select="$business_processes[(name=$nextProcessUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$nextProcessUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
							<xsl:variable name="nextBusProcStrippedName"><xsl:call-template name="RenderStrippedName"><xsl:with-param name="name" select="$nextBusProc/own_slot_value[slot_reference='name']/value"></xsl:with-param></xsl:call-template></xsl:variable>

							<xsl:choose>
								<xsl:when test="$thisRelation/name = $endProcessRelation/name">
									<!-- IGNORE END RELATIONS -->
									<!---\-> [<xsl:value-of select="$decisionResponse"/>] (*)-->
								</xsl:when>
								<xsl:when test="not($nextProcessUsage/type = 'Business_Process_Flow_Decision')">
									<xsl:text>						
									</xsl:text>"<xsl:value-of select="$thisBusProcStrippedName"/>" --><xsl:call-template name="RenderBusinessProcess"><xsl:with-param name="busProc" select="$nextBusProc"/></xsl:call-template><xsl:text>						
									</xsl:text>
									<!-- Print out any goal events for the next process -->
									<xsl:variable name="thisGoalEventRelations" select="$processFlowRelations[(own_slot_value[slot_reference=':FROM']/value = $nextProcessUsage/name) and (own_slot_value[slot_reference=':TO']/value = $goalEventUsages/name)]"/>
									<xsl:if test="count($thisGoalEventRelations) > 0">
										<xsl:text disable-output-escaping="yes">&#13;</xsl:text><xsl:call-template name="RenderGoalEvent"><xsl:with-param name="eventRelation" select="$thisGoalEventRelations[1]"/></xsl:call-template><xsl:text>					
									</xsl:text>
									</xsl:if>
								</xsl:when>
							</xsl:choose>	
							<xsl:call-template name="RenderRelationList"><xsl:with-param name="inScopeRelations" select="$newInScopeRelationList"/><xsl:with-param name="usedRelations" select="$newUsedRelationList"/></xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:if>		
	</xsl:template>
	

	
	<xsl:template mode="RenderEndRelation" match="node()">
		<xsl:variable name="busProcUsage" select="$processUsages[name= current()/own_slot_value[slot_reference=':FROM']/value]"/>
		<xsl:variable name="thisBusProc" select="$business_processes[(name=$busProcUsage/own_slot_value[slot_reference='business_process_used']/value) or (name=$busProcUsage/own_slot_value[slot_reference='business_activity_used']/value)]"/>
		<xsl:variable name="thisBusProcStrippedName"><xsl:call-template name="RenderStrippedName"><xsl:with-param name="name" select="$thisBusProc/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:variable>
		
		"<xsl:value-of select="$thisBusProcStrippedName"/>" --> (*)
	</xsl:template>
	
	
	<xsl:template name="RenderBusinessProcess"><xsl:param name="busProc"/><xsl:variable name="busProcDisplayName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$busProc"/></xsl:call-template></xsl:variable><xsl:variable name="busProcName" select="$busProc/own_slot_value[slot_reference='name']/value"/><xsl:variable name="strippedBusProcName" select="translate($busProcName[1], translate($busProcName[1],'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',''),'')"/>	<xsl:variable name="busRoles" select="$defined_business_roles[name=$busProc/own_slot_value[slot_reference='business_process_owned_by_business_role']/value]"/>"&lt;img:<xsl:call-template name="RenderIconPath"><xsl:with-param name="businessRole" select="$busRoles[1]"/></xsl:call-template>&gt;&#160;<xsl:value-of select="eas:renderWrappedString($busProcDisplayName, $wrapLength)"/><xsl:choose><xsl:when test="count($busRoles)>0"><xsl:apply-templates mode="RenderBusinessRole" select="$busRoles"/></xsl:when><xsl:otherwise>\n &lt;size:10&gt;&lt;color:#aaaaaa&gt;&lt;i&gt;No Role Defined&lt;/i&gt;&lt;/color&gt;&lt;/size&gt;</xsl:otherwise></xsl:choose>" as <xsl:value-of select="$strippedBusProcName"/></xsl:template>
	
	<xsl:template name="RenderDecision"><xsl:param name="decision"/><xsl:variable name="decisionDisplayName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$decision"/></xsl:call-template></xsl:variable><xsl:variable name="decisionName" select="$decision/own_slot_value[slot_reference='business_process_arch_display_label']/value"/><xsl:variable name="strippedDecisionName" select="translate($decisionName, translate($decisionName,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',''),'')"/>	<xsl:variable name="busRoles" select="$decisionMakers[name=$decision/own_slot_value[slot_reference='bpfd_decision_makers']/value]"/>"<xsl:value-of select="eas:renderWrappedString($decisionDisplayName, $wrapLength)"/><xsl:choose><xsl:when test="count($busRoles)>0"><xsl:apply-templates mode="RenderBusinessRole" select="$busRoles"/></xsl:when><xsl:otherwise>\n &lt;size:10&gt;&lt;color:#ffffff&gt;&lt;i&gt;No Role Defined&lt;/i&gt;&lt;/color&gt;&lt;/size&gt;</xsl:otherwise></xsl:choose>" as <xsl:value-of select="$strippedDecisionName"/> &lt;&lt; question >></xsl:template>
	
	
	<xsl:template name="RenderStartEvent">
		<xsl:param name="eventRelation"/>
		<xsl:variable name="startEventUsage" select="$startEventUsages[name = $eventRelation/own_slot_value[slot_reference=':FROM']/value]"/>
		<xsl:variable name="event" select="$startEvents[name = $startEventUsage/own_slot_value[slot_reference='usage_of_business_event_in_process']/value]"/>
		<xsl:variable name="eventName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$event"/></xsl:call-template></xsl:variable>
		<xsl:variable name="eventDisplayName" select="eas:renderHTMLWrappedString($eventName, $wrapLength)"/>

		<xsl:text disable-output-escaping="yes">
			note left&#13;&lt;b&gt;&lt;font size="14"></xsl:text><xsl:value-of select="eas:i18n('Start Event')"/><!--<xsl:value-of select="eas:i18n('Start Event')"/>--><xsl:text  disable-output-escaping="yes">&lt;/font>&lt;/b&gt;&#13;</xsl:text><xsl:value-of select="$eventDisplayName"/>
		<xsl:text disable-output-escaping="yes">&#13;end note</xsl:text>
	</xsl:template>
	
	
	<xsl:template name="RenderGoalEvent">
		<xsl:param name="eventRelation"/>
		<xsl:variable name="goalEventUsage" select="$goalEventUsages[name = $eventRelation/own_slot_value[slot_reference=':TO']/value]"/>
		<xsl:variable name="event" select="$goalEvents[name = $goalEventUsage/own_slot_value[slot_reference='usage_of_business_event_in_process']/value]"/>
		<xsl:variable name="eventName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$event"/></xsl:call-template></xsl:variable>
		<xsl:variable name="eventDisplayName" select="eas:renderHTMLWrappedString($eventName, $wrapLength)"/>
		
		<xsl:text disable-output-escaping="yes">
			note right&#13;&lt;b&gt;&lt;font size="14"></xsl:text><xsl:value-of select="eas:i18n('Goal Event')"/><!--<xsl:value-of select="eas:i18n('Goal Event')"/>--><xsl:text  disable-output-escaping="yes">&lt;/font>&lt;/b&gt;&#13;</xsl:text><xsl:value-of disable-output-escaping="yes" select="$eventDisplayName"/>
		<xsl:text disable-output-escaping="yes">&#13;end note</xsl:text>
	</xsl:template>
	
	<xsl:template mode="RenderBusinessRole" match="node()"><xsl:variable name="roleName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>\n&lt;size:10>&lt;color:<xsl:call-template name="RenderRoleColour"><xsl:with-param name="businessRole" select="current()"/></xsl:call-template>&gt;&lt;b><xsl:value-of select="$roleName"/>&lt;/b>&lt;/color>&lt;/size></xsl:template>
	
	
	<xsl:template mode="RenderDecisionMaker" match="node()"><xsl:variable name="roleName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>\n&lt;size:10>&lt;color:<xsl:call-template name="RenderRoleColour"><xsl:with-param name="businessRole" select="current()"/></xsl:call-template>&gt;&lt;b><xsl:value-of select="$roleName"/>&lt;/b>&lt;/color>&lt;/size></xsl:template>
	
	
	<xsl:template name="RenderStrippedName">
		<xsl:param name="name"/>
		<xsl:value-of select="translate($name, translate($name,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',''),'')"/>	
	</xsl:template>
	
	<xsl:function name="eas:renderWrappedString" as="xs:string">
		<xsl:param name="string"/>
		<xsl:param name="wordsPerLine"/>
		
		<xsl:variable name="stringAsTokens" select="tokenize($string, ' ')"/>
		<xsl:variable name="stringCount" select="count($stringAsTokens)"/>
		<xsl:variable name="wrappedString">
			<xsl:for-each select="$stringAsTokens">
				<xsl:value-of select="current()"/>
				<xsl:choose>
					<xsl:when test="((position() mod $wordsPerLine) = 0) and (not(position() = last()))"><xsl:text disable-output-escaping="yes">\n</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text disable-output-escaping="yes"> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="$wrappedString"/>
	</xsl:function>
	
	
	<xsl:function name="eas:renderHTMLWrappedString" as="xs:string">
		<xsl:param name="string"/>
		<xsl:param name="wordsPerLine"/>
		
		<xsl:variable name="stringAsTokens" select="tokenize($string, ' ')"/>
		<xsl:variable name="stringCount" select="count($stringAsTokens)"/>
		<xsl:variable name="wrappedString">
			<xsl:for-each select="$stringAsTokens">
				<xsl:value-of select="current()"/>
				<xsl:choose>
					<xsl:when test="((position() mod $wordsPerLine) = 0) and (not(position() = last()))"><xsl:text disable-output-escaping="yes">&#13;</xsl:text></xsl:when>
					<xsl:otherwise><xsl:text disable-output-escaping="yes"> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="$wrappedString"/>
	</xsl:function>

	
	<xsl:template mode="DebugRelationList" match="node()">
		<xsl:variable name="fromUsage" select="$allProcessUsages[name = current()/own_slot_value[slot_reference=':FROM']/value]"/>
		<xsl:variable name="toUsage" select="$allProcessUsages[name = current()/own_slot_value[slot_reference=':TO']/value]"/>
		<xsl:variable name="relationLabel" select="current()/own_slot_value[slot_reference=':relation_label']/value"/>
		<xsl:value-of select="$fromUsage/own_slot_value[slot_reference='business_process_arch_display_label']/value"/><xsl:text> -</xsl:text><xsl:value-of select="$relationLabel"/><xsl:text>- </xsl:text><xsl:value-of select="$toUsage/own_slot_value[slot_reference='business_process_arch_display_label']/value"/><xsl:text>
			
		</xsl:text>
	</xsl:template>

	
	<xsl:template name="RenderIconPath">
		<xsl:param name="businessRole"/>
		
		<xsl:choose>
			<xsl:when test="count($businessRole) > 0">
				<xsl:variable name="iconIndex" select="index-of($defined_business_roles, $businessRole)"/>
				<xsl:variable name="iconFileName" select="$peopleIconList[$iconIndex]"/>
				<xsl:value-of select="concat($currentFilePath, $webAppName, '/images/', $iconFileName)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($currentFilePath,$webAppName,'/images/', $undefinedPeopleIcon)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="RenderRoleColour">
		<xsl:param name="businessRole"/>
		
		<xsl:variable name="colourIndex" select="index-of($defined_business_roles, $businessRole)"/>
		<xsl:variable name="colour" select="$peopleColourList[$colourIndex]"/>
		<xsl:value-of select="$colour"/>
	</xsl:template>

	
</xsl:stylesheet>