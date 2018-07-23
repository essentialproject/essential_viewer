<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pro="http://protege.stanford.edu/xml"
    xpath-default-namespace="http://protege.stanford.edu/xml"
    version="2.0">
    
    <!--
		* Copyright ©2015-2018 Enterprise Architecture Solutions Limited.
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
    <!-- View to extract the list of valid Security Classifications and the classifications
         of the View Templates (instances of Report class) 
    -->
    <!-- 23.01.2015	JWC First implementation	 -->
    <!-- 26.03.2018 JWC Extended to support default classification -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Get all the classification groups -->
    <xsl:variable name="classificationGroups" select="/node()/simple_instance[type='EA_Content_Classification_Group']"></xsl:variable>
    
    <!-- Get all the security classifications -->
    <xsl:variable name="classifications" select="/node()/simple_instance[type='EA_Content_Classification']"></xsl:variable>
    
    <!-- Get the default security classifications -->
    <xsl:variable name="defaultClassifications" select="/node()/class[name='EA_Default_Classification']"></xsl:variable>
    
    
    <!-- Get all the View specifications -->
    <xsl:variable name="viewDefinitions" select="/node()/simple_instance[type='Report']"></xsl:variable>
    
    <xsl:template match="knowledge_base">
        
        <!-- Render the classifications list and view template classifications as XML -->
        <viewclassification xmlns="http://www.enterprise-architecture.org/essential/viewerclassification"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.enterprise-architecture.org/essential/viewerclassification viewerclassification.xsd">
            
            <!-- Render any default classifications -->
            <xsl:apply-templates mode="defaultClassifications" select="$defaultClassifications">
            </xsl:apply-templates>
            
                        
            <!-- Render each Classification Group -->
            <xsl:element name="classificationGroups" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">         
                <xsl:apply-templates mode="classifications" select="$classifications">
                </xsl:apply-templates>
            </xsl:element>
            
            <!-- Render each View Template -->
            <xsl:element name="views" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
                <xsl:apply-templates mode="views" select="$viewDefinitions"></xsl:apply-templates>
            </xsl:element>
            
        </viewclassification>
    </xsl:template>
    
    <!-- Render the default classifications -->
    <xsl:template mode="defaultClassifications" match="node()">
        <xsl:param name="type"></xsl:param>
        
        <!-- Find the read classification instance -->
        <xsl:variable name="aReadClassification" select="$classifications[name=current()/own_slot_value[slot_reference='system_security_read_classification']/value]"></xsl:variable>
        
        <!-- Find the edit classification instance -->
        <xsl:variable name="anEditClassification" select="$classifications[name=current()/own_slot_value[slot_reference='system_security_edit_classification']/value]"></xsl:variable>
        
        <xsl:choose>
            <!-- Only render if the default classification has been set -->
            <xsl:when test="(count($aReadClassification) > 0) or (count($anEditClassification) > 0)">
                <xsl:element name="defaultClassification" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
                    <xsl:if test="count($aReadClassification) > 0">
                        <xsl:variable name="aReadGroupID" select="$aReadClassification/own_slot_value[slot_reference='contained_in_content_classification_group']/value"></xsl:variable>
                        <xsl:variable name="aReadGroup" select="$classificationGroups[name=$aReadGroupID]"></xsl:variable>
                        
                        <xsl:element name="readClassification" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
                            <xsl:attribute name="type">read</xsl:attribute>
                            <xsl:element name="group" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$aReadGroup/own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
                            <xsl:element name="level" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$aReadClassification/own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
                            <xsl:element name="index" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$aReadClassification/own_slot_value[slot_reference='security_classification_index']/value"></xsl:value-of></xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="count($anEditClassification) > 0">
                        <xsl:variable name="anEditGroupID" select="$anEditClassification/own_slot_value[slot_reference='contained_in_content_classification_group']/value"></xsl:variable>
                        <xsl:variable name="anEditGroup" select="$classificationGroups[name=$anEditGroupID]"></xsl:variable>
                        
                        <xsl:element name="editClassification" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
                            <xsl:attribute name="type">edit</xsl:attribute>
                            <xsl:element name="group" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$anEditGroup/own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
                            <xsl:element name="level" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$anEditClassification/own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
                            <xsl:element name="index" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$anEditClassification/own_slot_value[slot_reference='security_classification_index']/value"></xsl:value-of></xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:when>
        </xsl:choose>        
    </xsl:template>
    
    <!-- Render each classification group -->
    <xsl:template mode="classifications" match="node()">
        <xsl:param name="type"></xsl:param>
        
        <xsl:variable name="groupID" select="own_slot_value[slot_reference='contained_in_content_classification_group']/value"></xsl:variable>
        <xsl:variable name="group" select="$classificationGroups[name=$groupID]"></xsl:variable>
        
        <xsl:element name="classification" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
            <xsl:choose>
                <xsl:when test="string-length($type) > 0">
                    <xsl:attribute name="type"><xsl:value-of select="$type"></xsl:value-of></xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:element name="group" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="$group/own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
            <xsl:element name="level" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
            <xsl:element name="index" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="own_slot_value[slot_reference='security_classification_index']/value"></xsl:value-of></xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Render each view template security -->
    <xsl:template mode="views" match="node()">
        <xsl:variable name="readIDs" select="own_slot_value[slot_reference='system_security_read_classification']/value"></xsl:variable>
        <xsl:variable name="editIDs" select="own_slot_value[slot_reference='system_security_edit_classification']/value"></xsl:variable>
        
        <xsl:variable name="readClearance" select="$classifications[name=$readIDs]"></xsl:variable>
        <xsl:variable name="editClearance" select="$classifications[name=$editIDs]"></xsl:variable>
        
        <xsl:if test="(count($readClearance) > 0) or (count($editClearance) > 0)">
            <xsl:element name="view" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
                <xsl:element name="template" namespace="http://www.enterprise-architecture.org/essential/viewerclassification"><xsl:value-of select="own_slot_value[slot_reference='report_xsl_filename']/value"></xsl:value-of></xsl:element>
                <xsl:element name="viewClassification" namespace="http://www.enterprise-architecture.org/essential/viewerclassification">
                    <!-- Define read type classifications -->
                    <xsl:apply-templates mode="classifications" select="$readClearance">                    
                        <xsl:with-param name="type">read</xsl:with-param>
                    </xsl:apply-templates>
                    
                    <!-- Define the edit type classifications -->
                    <xsl:apply-templates mode="classifications" select="$editClearance">                    
                        <xsl:with-param name="type">edit</xsl:with-param>
                    </xsl:apply-templates>
                    
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>