<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:user="http://www.enterprise-architecture.org/essential/vieweruserdata"
    xmlns:view="http://www.enterprise-architecture.org/essential/viewerclassification"    
    xpath-default-namespace="http://www.enterprise-architecture.org/essential/viewerclassification"
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
    <!-- View to evaulate user clearance to access the specified View template -->
    <!-- 22.01.2015	JWC First implementation	 -->
    <!-- 27.03.2018 JWC Updated to include test with default classification -->
    <!-- 13.04.2018 JWC Tweaked the parameters to testAuthZ() for default classification as union -->
    <!-- 16.04.2018 JWC Revised query to ensure 18 security scenarios are handled correctly -->
    <!-- 02.08.2018 JWC Re-worked security algorithm with respect to default classifications, as was too strict -->
    <!-- 07.08.2018 JWC Completed detailed testing in OxygenXML -->
    
    <xsl:output method="text"/>
    
    <!-- XML document holding the user data -->
    <xsl:param name="userData"></xsl:param>
    <!-- Simple string holding the name of the selected template -->
    <xsl:param name="viewTemplate"></xsl:param>
    <!-- Which type of clearance are we looking for? -->
    <xsl:param name="classificationType">read</xsl:param>
    <!-- Which repository are we validating against -->
    <xsl:param name="repositoryID"></xsl:param>
    
    <xsl:template match="viewclassification">
        
        <!-- get the classifications for the selected View template of the selected type-->
        <xsl:variable name="viewClassifications" select="//view[template=$viewTemplate]/viewClassification/classification[@type=$classificationType]"></xsl:variable>
        
        <!-- get the set of classifications that are defined and are relevant to the selected View template -->
        <xsl:variable name="classificationDefs" select="classificationGroups/classification[group=$viewClassifications/group]"></xsl:variable>
        
        <!-- Get the default classification for all elements, if defined -->
        <xsl:variable name="defaultClassification" select="defaultClassification/readClassification"></xsl:variable>
        <xsl:variable name="defaultClassificationGroup" select="$defaultClassification/classification/group"></xsl:variable>        
        <xsl:variable name="allClassificationsInGroup" select="classificationGroups/classification[group=$defaultClassification/group] union $classificationDefs"></xsl:variable>
        
        <!-- get the user clearance levels -->        
        <!--<xsl:variable name="userDoc" select="parse-xml($userData)"></xsl:variable>-->
        <xsl:variable name="userDoc" select="$userData"/>        
        <xsl:variable name="userGroupClearance" select="$userDoc//user:clearance[@type=$classificationType and user:repository=$repositoryID]"></xsl:variable>
        
        <xsl:choose>
            
            <!-- Test for explicit classification of the View Template -->
            <xsl:when test="count($viewClassifications) > 0">
                
                <xsl:variable name="authResult">
                    <xsl:apply-templates mode="testAuthZ" select="$viewClassifications">
                        <xsl:with-param name="classificationDefs" select="$classificationDefs"></xsl:with-param>
                        <xsl:with-param name="userGroupClearance" select="$userGroupClearance"></xsl:with-param> 
                        <xsl:with-param name="allClassificationsForGroup" select="$allClassificationsInGroup"></xsl:with-param>
                    </xsl:apply-templates>
                </xsl:variable>
                                                                
                <xsl:choose>
                    <xsl:when test="contains($authResult, 'ACCESS DENIED')">
                        <xsl:text>ACCESS DENIED</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>AUTHORISED</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            
            <!-- Test the default classification if the view is not classified explicitly -->
            <xsl:when test="count($defaultClassification) > 0">
                <xsl:variable name="defaultAuthResult">
                    <xsl:apply-templates mode="testAuthZ" select="$defaultClassification">
                        <xsl:with-param name="classificationDefs" select="$viewClassifications union $defaultClassification"></xsl:with-param>                        
                        <xsl:with-param name="userGroupClearance" select="$userGroupClearance"></xsl:with-param>
                        <xsl:with-param name="allClassificationsForGroup" select="$allClassificationsInGroup"></xsl:with-param>                        
                    </xsl:apply-templates>
                </xsl:variable>                
                <xsl:choose>
                    <xsl:when test="contains($defaultAuthResult, 'ACCESS DENIED')">
                        <xsl:text>ACCESS DENIED</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>AUTHORISED</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>                
                <!-- No relevant views classified, so authorised -->
                <xsl:text>AUTHORISED</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Test user authorisation for the specified classification group of the view -->
    <xsl:template mode="testAuthZ" match="node()">
        <xsl:param name="classificationDefs"></xsl:param>
        <xsl:param name="userGroupClearance"></xsl:param>
        <xsl:param name="allClassificationsForGroup"></xsl:param>
        
        <xsl:variable name="currentGroup" select="group"></xsl:variable>
        <xsl:variable name="userSelectedGroup" select="$userGroupClearance[user:group=$currentGroup]"/>
        <xsl:variable name="userLevelIndex" select="$allClassificationsForGroup[level=$userSelectedGroup/user:level]/index"></xsl:variable>
        <xsl:variable name="viewClassIndex" select="index"></xsl:variable>

        <xsl:choose>            
            <xsl:when test="number(max($userLevelIndex)) >= number(max($viewClassIndex))">
                <xsl:text>AUTHORISED </xsl:text>                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:text>ACCESS DENIED </xsl:text>                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>
