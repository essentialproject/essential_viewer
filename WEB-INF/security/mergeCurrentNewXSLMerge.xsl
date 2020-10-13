<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xpath-default-namespace="http://protege.stanford.edu/xml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xalan="http://xml.apache.org/xslt" 
    xmlns:pro="http://protege.stanford.edu/xml" 
    xmlns:eas="http://www.enterprise-architecture.org/essential" 
    xmlns:functx="http://www.functx.com" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"
    exclude-result-prefixes="xsl xalan pro eas functx xs ess">
    
     <!--
		* Copyright © 2008-2020 Enterprise Architecture Solutions Limited.
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
	<!-- 
        Merge the current repository snapshot XML with a new, updated repository snapshot
        This approach uses XSL 3.0 xsl:merge on simple_instance tags
    -->
    <!-- 04.05.2020 JWC  Created	 -->

    <!-- <xsl:variable name="originalXML" select="document('originalXML.xml')"></xsl:variable> -->
    <xsl:param name="originalXML"/>
    <xsl:variable name="isPublishedSlot">system_is_published</xsl:variable>
        
    <xsl:template match="knowledge_base">
        <!-- Merge the 2 documents, updated (new) one is the current document -->
        <knowledge_base xmlns="http://protege.stanford.edu/xml"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://protege.stanford.edu/xml http://www.enterprise-architecture.org/xml/essentialreportxml.xsd">
            
            <xsl:copy-of select="timestamp"></xsl:copy-of>
            <xsl:copy-of select="repository"/>
            <xsl:copy-of select="user"/>
            <xsl:copy-of select="tenant"></xsl:copy-of>
            <xsl:copy-of select="class"></xsl:copy-of>
            <xsl:copy-of select="slot"></xsl:copy-of>
            <xsl:copy-of select="facet"></xsl:copy-of>
            
            <!-- Merge the current simple_instances with the updated simple_instances -->
            <xsl:choose>
                <!-- Only do the merge, if the is_published slot is there -->
                <xsl:when test="current()/simple_instance/own_slot_value[slot_reference=$isPublishedSlot]">
                        
                    <xsl:merge>
                        <xsl:merge-source name="updateDoc" select="current()/simple_instance" sort-before-merge="yes">
                            <xsl:merge-key select="name"></xsl:merge-key>
                        </xsl:merge-source>
                        
                        <xsl:merge-source name="currentDoc" select="$originalXML//simple_instance" sort-before-merge="yes">
                            <xsl:merge-key select="name"></xsl:merge-key>
                        </xsl:merge-source>

                        <xsl:merge-action>
                            <xsl:choose>
                                <xsl:when test="current-merge-group('updateDoc')/own_slot_value[slot_reference=$isPublishedSlot]/value = 'true'">
                                    <!-- Updated/new simple_instance is flagged for publish -->
                                    <xsl:copy-of select="current-merge-group('updateDoc')"/>
                                </xsl:when>
                                <xsl:when test="count(current-merge-group('currentDoc')) = 1">
                                    <!-- Instance with this ID exists in the current snapshot -->
                                    <xsl:copy-of select="current-merge-group('currentDoc')"/>
                                </xsl:when>
                                <xsl:otherwise>                            
                                    <!-- Leave the element out of the result -->
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:merge-action>
                    </xsl:merge>
            
                </xsl:when>
                <xsl:otherwise>
                    <!-- Use all of the instances from the updated XML -->
                    <xsl:copy-of select="simple_instance"/>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Make sure that the closing tag is on its own line -->
            <xsl:text>
                
            </xsl:text>
        </knowledge_base>
        
    </xsl:template>
    
    
</xsl:stylesheet>