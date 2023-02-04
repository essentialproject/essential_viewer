<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/>
    	<xsl:param name="param2"/>
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
	
	
	<xsl:variable name="thisInstance" select="/node()/simple_instance[name = $param1]"/>
	<xsl:template match="knowledge_base">
		{
			"instance": [
				<xsl:apply-templates mode="RenderSlots" select="$thisInstance/own_slot_value">
					
				</xsl:apply-templates>]}
	</xsl:template>
	
	
	<xsl:template mode="RenderSlots" match="node()">
			<xsl:variable name="temp" as="map(*)" select="map{'id': string(current()), 'name': string(current()/own_slot_value[slot_reference = ('name', 'relation_name')]/value)}"></xsl:variable>
			<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/> 
			<xsl:variable name="sltType" select="value[1]/@value_type"/>
		{
        "type": "<xsl:value-of select="../type"/>",
        "slotType": "<xsl:value-of select="$sltType"/>",
		"name": "<xsl:value-of select="slot_reference"/>", 
        "values": [<xsl:for-each select="value"><xsl:variable name="theSubject" select="."/>"<xsl:choose><xsl:when test="eas:isUserAuthZ($theSubject)"><xsl:value-of select="eas:getSafeJSString(translate($theSubject,'&quot;',''))" disable-output-escaping="yes"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
        "name_values": [<xsl:for-each select="value">
        <xsl:variable name="this" select="/node()/simple_instance[name = current()]/supertype"/>    
		{"superclass":[<xsl:for-each select="/node()/simple_instance[name=current()]/supertype">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"slotType":"<xsl:value-of select="$sltType"/>",
		"type":"<xsl:value-of select="../slot_reference"/>",
		
		<xsl:variable name="thisNode" select="/node()/simple_instance[name = current()]"/>
       <xsl:choose><xsl:when test="eas:isUserAuthZ($thisNode)">  
			"id": "<xsl:value-of select="$thisNode/name"/>",
				<xsl:variable name="temp" as="map(*)" select="map{'name': string(translate(translate($thisNode/own_slot_value[slot_reference = ('name', 'relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
				<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
				<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose> ,
		"ttype":"<xsl:value-of select="/node()/simple_instance[name=current()]/type"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
       </xsl:for-each>]
        }<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>




	<xsl:template mode="RenderSlotsOriginal" match="node()">
 
		{
        "type": "<xsl:value-of select="../type"/>",
        "slotType": "<xsl:value-of select="value[1]/@value_type"/>",
		"name": "<xsl:value-of select="slot_reference"/>",
        "values": [<xsl:for-each select="value"><xsl:variable name="theSubject" select="."/>"<xsl:choose><xsl:when test="eas:isUserAuthZ($theSubject)"><xsl:value-of select="eas:getSafeJSString(translate($theSubject,'&quot;',''))" disable-output-escaping="yes"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
        "name_values": [<xsl:for-each select="value">
        <xsl:variable name="this" select="/node()/simple_instance[name = current()]/supertype"/>    
        <xsl:choose><xsl:when test="$this='EA_Relation'"> {"id":"<xsl:value-of select="eas:renderJSText(current())"/>","name":"<xsl:value-of select="eas:renderJSText(translate(/node()/simple_instance[name = current()]/own_slot_value[slot_reference='relation_name']/value,'&quot;',''))"/>","type":"<xsl:value-of select="/node()/simple_instance[name=current()]/type"/>"<xsl:choose><xsl:when test="current()/@value_type='simple_instance'">,"slotType":"<xsl:value-of select="current()/@value_type"/>","superclass":[<xsl:for-each select="/node()/simple_instance[name=current()]/supertype">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]</xsl:when><xsl:otherwise>,"slotType":"<xsl:value-of select="current()"/>"</xsl:otherwise></xsl:choose>,"superclass":[<xsl:for-each select="/node()/simple_instance[name=current()]/supertype">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if></xsl:when><xsl:otherwise> {"id":"<xsl:value-of select="eas:renderJSText(current())"/>",<xsl:if test="current()/@value_type='simple_instance'">"slotType":"<xsl:value-of select="current()/@value_type"/>","superclass":[<xsl:for-each select="/node()/simple_instance[name=current()]/supertype">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],</xsl:if>
            <xsl:choose><xsl:when test="not(/node()/simple_instance[name=current()]/type)">"name":"<xsl:choose><xsl:when test="eas:isUserAuthZ(current())"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>",
        "type":"<xsl:value-of select="../slot_reference"/>"</xsl:when><xsl:otherwise>
            <xsl:variable name="thisNode" select="/node()/simple_instance[name = current()]"/>
        "name":"<xsl:choose><xsl:when test="eas:isUserAuthZ($thisNode)"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisNode"/><xsl:with-param name="isRenderAsJSString" select="true()"/> </xsl:call-template></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose>",
        "type":"<xsl:value-of select="/node()/simple_instance[name=current()]/type"/>","superclass":[<xsl:for-each select="/node()/simple_instance[name=current()]/supertype">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]</xsl:otherwise></xsl:choose> }<xsl:if test="not(position() = last())">,</xsl:if></xsl:otherwise></xsl:choose>
       </xsl:for-each>]
        }<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
