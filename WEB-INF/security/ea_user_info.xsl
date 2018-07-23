<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pro="http://protege.stanford.edu/xml"
    xpath-default-namespace="http://protege.stanford.edu/xml"
    version="2.0">
    <!--
		* Copyright ©2015-2016 Enterprise Architecture Solutions Limited.
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
    <!-- View to extract the list of user clearance levesl from EA_User instances -->
    
    <!-- 23.01.2015	JWC First implementation	 -->
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Specify the selected user -->
    <xsl:param name="userID"></xsl:param>
    
    <!-- Get all the classification groups -->
    <xsl:variable name="users" select="/node()/simple_instance[type='EA_User']"></xsl:variable>
    
    <!-- Get all the security classifications -->
    <xsl:variable name="classifications" select="/node()/simple_instance[type='EA_Content_Classification']"></xsl:variable>
    
    <!-- Get all the classification groups -->
    <xsl:variable name="classificationGroups" select="/node()/simple_instance[type='EA_Content_Classification_Group']"></xsl:variable>
    
    <xsl:template match="knowledge_base">
        
        <!-- get the selected user -->
        <xsl:variable name="user" select="$users[own_slot_value[slot_reference='name']/value=$userID]"></xsl:variable>
        
        <!-- Render the user details -->
        <user xmlns="http://www.enterprise-architecture.org/essential/vieweruserdata"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.enterprise-architecture.org/essential/vieweruserdata vieweruserdata.xsd">
            
            <!-- Basic data -->
            <xsl:element name="firstname" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata"><xsl:value-of select="$user/own_slot_value[slot_reference='user_first_name']/value"></xsl:value-of></xsl:element>
            <xsl:element name="lastname" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata"><xsl:value-of select="$user/own_slot_value[slot_reference='user_last_name']/value"></xsl:value-of></xsl:element>
            <xsl:element name="email" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata"><xsl:value-of select="$user/own_slot_value[slot_reference='email']/value"></xsl:value-of></xsl:element>
            
            <xsl:variable name="readIDs" select="$user/own_slot_value[slot_reference='ea_security_clearance_read']/value"></xsl:variable>
            <xsl:variable name="editIDs" select="$user/own_slot_value[slot_reference='ea_security_clearance_edit']/value"></xsl:variable>
            
            <xsl:variable name="readClearance" select="$classifications[name=$readIDs]"></xsl:variable>
            <xsl:variable name="editClearance" select="$classifications[name=$editIDs]"></xsl:variable>
            
            <!-- User clearance level information -->
            <xsl:element name="clearanceList" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata">
                <xsl:apply-templates mode="clearance" select="$readClearance">
                    <xsl:with-param name="type">read</xsl:with-param>
                </xsl:apply-templates>
                <xsl:apply-templates mode="clearance" select="$editClearance">
                    <xsl:with-param name="type">edit</xsl:with-param>
                </xsl:apply-templates>    
            </xsl:element>
            
        </user>
        
    </xsl:template>
    
    <!-- Render each clearance items -->
    <xsl:template mode="clearance" match="node()">
        <xsl:param name="type"></xsl:param>
        
        <xsl:variable name="groupID" select="own_slot_value[slot_reference='contained_in_content_classification_group']/value"></xsl:variable>
        <xsl:variable name="group" select="$classificationGroups[name=$groupID]"></xsl:variable>
        
        <xsl:element name="clearance" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata">
            <xsl:choose>
                <xsl:when test="string-length($type) > 0">
                    <xsl:attribute name="type"><xsl:value-of select="$type"></xsl:value-of></xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:element name="group" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata"><xsl:value-of select="$group/own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
            <xsl:element name="level" namespace="http://www.enterprise-architecture.org/essential/vieweruserdata"><xsl:value-of select="own_slot_value[slot_reference='name']/value"></xsl:value-of></xsl:element>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>