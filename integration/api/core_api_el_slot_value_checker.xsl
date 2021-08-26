<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:param name="param1"/>
	
	
	<xsl:variable name="allClasses" select="/node()/class[(type=':ESSENTIAL-CLASS') and (own_slot_value[slot_reference=':ROLE']/value='Concrete') and not(name = 'External_Instance_Reference')]"/>
	<xsl:variable name="allSlots" select="/node()/slot[(type=':ESSENTIAL-SLOT') and not(name = 'external_repository_instance_reference')]"/>
	<xsl:variable name="allInstances" select="/node()/simple_instance[type = $allClasses/name]"/>
	
	
 	
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
	

	<xsl:template match="knowledge_base">
		{
			"classes": [<xsl:apply-templates mode="RenderClassDetails" select="$allClasses"><xsl:sort select="name"/></xsl:apply-templates>]
		}
	</xsl:template>
	
	
	<xsl:template mode="RenderClassDetails" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisInstances" select="$allInstances[type = $this/name]"/>
		<xsl:variable name="thisFacetDefs" select="$this/template_facet_value[facet_reference=':VALUE-TYPE']"/>

		{
			"class": "<xsl:value-of select="$this/(name)"/>",
			<!--"facetInfo": "<xsl:value-of select="$thisFacetDefs/value[@value_type = 'class']"/>",-->
			"problemInstances": [<xsl:apply-templates mode="RenderClassInstances" select="$thisInstances"><xsl:with-param name="facetDefs" select="$thisFacetDefs"/></xsl:apply-templates>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="RenderClassInstances" match="node()">
		<xsl:param name="facetDefs"/>
		
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisPos" select="position()"/>
		<xsl:variable name="lastPos" select="last()"/>
		
		
		<!-- Get the populated instance slots -->
		<xsl:variable name="thisInstanceSlots" select="$this/own_slot_value[value = $allInstances/name]"/>
		
		<!-- Get the instances that populate the instance slots -->
		<xsl:variable name="thisSlotInstanceVals" select="$allInstances[name = $thisInstanceSlots/value]"/>
		
		<!-- Get the slot definitions for the populated slots -->
		<xsl:variable name="thisSlotDefs" select="$allSlots[name = $thisInstanceSlots/slot_reference]"/>
		<xsl:variable name="thisFacetDefs" select="$facetDefs[slot_reference = $thisInstanceSlots/slot_reference]"/>

		<!--<xsl:variable name="problemSlots">
			<xsl:for-each select="$thisInstanceSlots">
				<xsl:variable name="thisSlot" select="current()"/>
				<xsl:variable name="thisSlotDef" select="$thisSlotDefs[name = $thisSlot/slot_reference]"/>
				<xsl:variable name="thisSlotVals" select="$thisSlotInstanceVals[name = $thisSlot/value]"/>
				<xsl:variable name="slotProblemInstances" select="eas:getProblemInstances($thisSlot, $thisSlotDef, $thisSlotVals)"/>
				<xsl:choose>
					<xsl:when test="count($slotProblemInstances) > 0">
						<xsl:sequence select="$thisSlot"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>-->
		
		<xsl:variable name="problemSlots" select="eas:getProblemInstances($thisInstanceSlots, $thisSlotDefs, $thisFacetDefs, $thisSlotInstanceVals)"/>
		
		<xsl:choose>
			<xsl:when test="count($problemSlots) > 0">
				{
				"id": "<xsl:value-of select="$this/name"/>",			
				"name": "<xsl:value-of select="$this/own_slot_value[slot_reference=('name', 'relation_name', ':relation_name')]/value"/>",
				"problemSlots": [<xsl:apply-templates mode="RenderProblemSlot" select="$problemSlots"><xsl:with-param name="facetDefs" select="$facetDefs"></xsl:with-param><xsl:with-param name="allInstanceVals" select="$thisSlotInstanceVals"/><xsl:with-param name="allSlotDefs" select="$thisSlotDefs"/></xsl:apply-templates>]				
				}
			</xsl:when>
			<xsl:otherwise>{}</xsl:otherwise>
		</xsl:choose><xsl:if test="not($thisPos = $lastPos)">,
		</xsl:if>
		
		<!--<xsl:if test="count($problemSlots) > 0">				
			{
				"id": "<xsl:value-of select="$this/name"/>",			
				"name": "<xsl:value-of select="$this/own_slot_value[slot_reference=('name', 'relation_name', ':relation_name')]/value"/>",
				"problemSlots": [<xsl:apply-templates mode="RenderProblemSlot" select="$problemSlots"><xsl:with-param name="facetDefs" select="$facetDefs"></xsl:with-param><xsl:with-param name="allInstanceVals" select="$thisSlotInstanceVals"/><xsl:with-param name="allSlotDefs" select="$thisSlotDefs"/></xsl:apply-templates>]				
			}</xsl:if><xsl:if test="(count($problemSlots) > 0) and not($thisPos = $lastPos)">,
			</xsl:if>-->
	</xsl:template>
	
	
	<xsl:template mode="RenderProblemSlot" match="node()">
		<xsl:param name="allInstanceVals"/>
		<xsl:param name="allSlotDefs"/>
		<xsl:param name="facetDefs"/>
		
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="slotDef" select="$allSlotDefs[name = $this/slot_reference]"/>	
		<xsl:variable name="facetDef" select="$facetDefs[slot_reference = $this/slot_reference]"/>
		
		<xsl:variable name="slotInstances" select="$allInstanceVals[name = $this/value]"/>
		<xsl:variable name="allowedTypes" select="$slotDef/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value"/>
		<xsl:variable name="allowedFacetTypes" select="$facetDef/value[@value_type = 'class']"/>
				
		{
			"slotName": "<xsl:value-of select="$this/slot_reference"/>",			
			"allowedClasses": [<xsl:choose><xsl:when test="count($allowedFacetTypes) > 0"><xsl:for-each select="$allowedFacetTypes">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],</xsl:when><xsl:otherwise><xsl:for-each select="$allowedTypes[not(. = 'Instance')]">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],</xsl:otherwise></xsl:choose>				
			"problemValues": [<xsl:apply-templates mode="RenderInstanceSlotVal" select="$slotInstances"><xsl:sort select="type"/></xsl:apply-templates>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RenderInstanceSlotVal" match="node()">
		<xsl:variable name="this" select="current()"/>		
		
		{
			"id": "<xsl:value-of select="$this/name"/>",
			"name": "<xsl:value-of select="$this/own_slot_value[slot_reference=('name', 'relation_name', ':relation_name')]/value"/>",
			"class": "<xsl:value-of select="$this/type"/>"
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	
	<xsl:function name="eas:getProblemInstances" as="node()*">
		<xsl:param name="thisInstanceSlots"/>
		<xsl:param name="thisSlotDefs"/>
		<xsl:param name="thisFacetDefs"/>
		<xsl:param name="thisSlotInstanceVals"/>
		
		<xsl:for-each select="$thisInstanceSlots">
			<xsl:variable name="thisSlot" select="current()"/>
			<xsl:variable name="thisSlotDef" select="$thisSlotDefs[name = $thisSlot/slot_reference]"/>
			<xsl:variable name="thisFacetDef" select="$thisFacetDefs[slot_reference = $thisSlot/slot_reference]"/>
			<xsl:variable name="thisSlotVals" select="$thisSlotInstanceVals[name = $thisSlot/value]"/>
			<xsl:variable name="slotProblemInstances" select="eas:checkProblemInstances($thisSlot, $thisSlotDef, $thisFacetDef, $thisSlotVals)"/>
			<!--<xsl:variable name="slotProblemInstances" select="$thisSlotVals"/>-->
			<xsl:choose>
				<xsl:when test="count($slotProblemInstances) > 0">
					<xsl:sequence select="$thisSlot"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>		
	</xsl:function>
	
	<xsl:function name="eas:checkProblemInstances" as="node()*">
		<xsl:param name="slot"/>
		<xsl:param name="slotDef"/>
		<xsl:param name="facetDef"/>
		<xsl:param name="slotValInstances"/>
		
		<xsl:variable name="slotInstances" select="$slotValInstances[name = $slot/value]"/>
		<xsl:variable name="allowedType" select="$slotDef/own_slot_value[slot_reference=':SLOT-VALUE-TYPE']/value"/>
		<xsl:variable name="allowedFacetTypes" select="$facetDef/value[@value_type = 'class']"/>

		<xsl:choose>
			<xsl:when test="count($allowedFacetTypes) > 0">
				<xsl:sequence select="$slotInstances[not((type, supertype) = $allowedFacetTypes)]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$slotInstances[not((type, supertype) = $allowedType)]"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<!--<xsl:sequence select="$slotInstances"/>-->
		
	</xsl:function>
		
</xsl:stylesheet>
