<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:pro="http://protege.stanford.edu/xml"
    xmlns:user="http://www.enterprise-architecture.org/essential/vieweruserdata"
    xmlns:view="http://www.enterprise-architecture.org/essential/viewerclassification"
    xmlns:eas="http://www.enterprise-architecture.org/essential"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:functx="http://www.functx.com" 
    xpath-default-namespace="http://protege.stanford.edu/xml" 
    version="2.0">
    
    <!--
		* Copyright ©2015-2019 Enterprise Architecture Solutions Limited.
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
    <!-- XSL query library for security implementation in Viewer -->
    <!-- 28.01.2015	JWC First implementation	 -->
    <!-- 27.03.2018 JWC Implement support for default classifications -->
    <!-- 17.04.2018 JWC Remove test for default classification as will have already been performed at View level -->
    <!-- 16.04.2018 JWC Revised query to ensure 18 security scenarios are handled correctly -->
    <!-- 02.08.2018 JWC Re-worked security algorithm with respect to default classifications, as was too strict -->
    <!-- 07.08.2018 JWC Completed detailed testing in OxygenXML -->
    <!-- 18.02.2019 JWC Added capability to secure instances by Class and test Class-level authZ -->
    <!-- 24.06.2019 JWC New functions to test for authZ across set of instances or a set of classes -->
    
    <!-- XML document holding the user data = empty node-set by default -->
    <xsl:param name="userData" select="/.."></xsl:param>
    
    <!-- Simple string holding the name of the selected template = empty node-set by default -->
    <xsl:param name="classificationConfig" select="/.."></xsl:param>
    
    <!-- Which type of clearance are we looking for? -->
    <xsl:param name="classificationType">read</xsl:param>
    
    <!-- Which repository are we validating against? -->
    <xsl:param name="repositoryID"></xsl:param>
    
    <!-- Define the redacted instance replacement string -->
    <xsl:variable name="theRedactedString">[CLASSIFIED]</xsl:variable>
    
    <!-- Get relevant user clearances -->
    <!--<xsl:variable name="userClearance" select="parse-xml($userData)"></xsl:variable>-->
    <xsl:variable name="userClearance" select="$userData"></xsl:variable>
    <xsl:variable name="userGroupClearance" select="$userClearance//user:clearance[@type=$classificationType and user:repository=$repositoryID]"></xsl:variable>
    
    <!--<xsl:variable name="classConfig" select="parse-xml($classificationConfig)"></xsl:variable>-->
    <xsl:variable name="classConfig" select="$classificationConfig"></xsl:variable>
    
    <!-- Get all the classification groups -->
    <xsl:variable name="classificationGroups" select="/node()/simple_instance[type='EA_Content_Classification_Group']"></xsl:variable>
    
    <!-- Get all the security classifications -->
    <xsl:variable name="classifications" select="/node()/simple_instance[type='EA_Content_Classification']"></xsl:variable>
    
    <!-- Get the default classification for all elements, if defined -->
    <xsl:variable name="defaultClassificationClass" select="/node()/class[name='EA_Default_Classification']"></xsl:variable>
    
    <!-- Get all the class definitions -->
    <xsl:variable name="theClassSet" select="/node()/class"></xsl:variable>
    
    <!-- Test harness -->
    <!--<xsl:template match="knowledge_base">
        <!-\-<xsl:variable name="testSubject" select="/node()/simple_instance[name='essential_baseline_v3.0.4_Class181']"></xsl:variable>-\->
        <xsl:variable name="testSubject" select="/node()/simple_instance[name='essential_baseline_v62_Class0']"></xsl:variable>        
        <!-\-<xsl:variable name="testSubject" select="/node()/class[name='Composite_Application_Provider']"></xsl:variable>-\->
        <xsl:variable name="aReportSet" select="/node()/simple_instance[type='Report']"></xsl:variable>
        
        <!-\-<xsl:for-each select="$aReportSet">
            <xsl:value-of select="eas:renderSecuredElement(current())"/>
            <xsl:text>
                
            </xsl:text>
        </xsl:for-each>-\->
        
        <xsl:choose>
            <xsl:when test="eas:isUserAuthZ($testSubject)">
                AUTHORISED        
            </xsl:when>
            <xsl:otherwise>
                NOT AUTHORISED
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>-->
    <!-- End of test harness -->
    
    <!-- function to test whether user can access specified instance -->
    <xsl:function name="eas:isUserAuthZ" as="xs:boolean">
        <xsl:param name="theInstance"></xsl:param>
        
        <xsl:choose>
            <!-- Only apply security if the user data has been set by the secure Viewer Engine implementations -->
            <xsl:when test="count($userClearance) > 0">
                <!-- Get the classifications for theInstance -->
                <xsl:variable name="readIDs" select="$theInstance/own_slot_value[slot_reference='system_security_read_classification']/value"></xsl:variable>        
                <xsl:variable name="readClearance" select="$classifications[name=$readIDs]"></xsl:variable>
                
                <!-- Get the name of the class to which this instance belongs, as long as the instance is not a Class -->                
                <xsl:variable name="instanceClassName">
                    <xsl:choose>
                        <xsl:when test="$theInstance[supertype=':CLASS']">
                            <xsl:value-of select="$theInstance/null-type"></xsl:value-of>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$theInstance/type"></xsl:value-of>
                        </xsl:otherwise>                        
                    </xsl:choose>
                    
                </xsl:variable>
                
                <!-- Find the default read classification instance -->
                <xsl:variable name="defaultClassification" select="$classifications[name=$defaultClassificationClass/own_slot_value[slot_reference='system_security_read_classification']/value]"></xsl:variable>
                
                <xsl:choose>
                    <!-- Test for explicit classification of the requested instance -->
                    <xsl:when test="count($readClearance) > 0">                
                        <!-- Get the groups associated with those -->
                        <!-- get the set of classifications that are defined and are relevant to the selected View template -->
                        <xsl:variable name="aClearanceGroupList" select="$classificationGroups[name=$readClearance/own_slot_value[slot_reference='contained_in_content_classification_group']/value]"></xsl:variable>
                        <xsl:variable name="classificationDefs" select="$classConfig//view:classificationGroups/view:classification[view:group=$aClearanceGroupList/own_slot_value[slot_reference='name']/value]"></xsl:variable>
                        <xsl:variable name="authResult">
                            <xsl:apply-templates mode="testAuthZ" select="$readClearance">
                                <xsl:with-param name="classificationDefs" select="$classificationDefs"></xsl:with-param>
                                <xsl:with-param name="userGroupClearance" select="$userGroupClearance"></xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:variable>
                                                
                        <xsl:choose>
                            <xsl:when test="contains($authResult, 'ACCESS DENIED')">
                                <xsl:value-of select="false()"></xsl:value-of>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="true()"></xsl:value-of>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    
                    <!-- Test for explicit classification of the requested instance's Class -->
                    <xsl:when test="string-length($instanceClassName) > 0">
                        <xsl:variable name="anInstanceClass" select="$theClassSet[name=$instanceClassName]"></xsl:variable>
                        <xsl:value-of select="eas:isUserAuthZ($anInstanceClass)"></xsl:value-of>
                    </xsl:when>
                    
                    <!-- Test the default classification if the view is not classified explicitly -->
                    <xsl:when test="count($defaultClassification) > 0">                
                        <!-- Find the details of the default classification in the security config element -->
                        <xsl:variable name="defaultClassificationDefs" select="$classConfig//view:defaultClassification/view:readClassification"></xsl:variable>                                        
                        <xsl:variable name="defaultAuthResult">
                            <xsl:apply-templates mode="testAuthZ" select="$defaultClassification">
                                <xsl:with-param name="classificationDefs" select="$defaultClassificationDefs"></xsl:with-param>
                                <xsl:with-param name="userGroupClearance" select="$userGroupClearance"></xsl:with-param>
                            </xsl:apply-templates>
                            <!--<xsl:text>AUTHORISED </xsl:text>-->
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($defaultAuthResult, 'ACCESS DENIED')">
                                <xsl:value-of select="false()"></xsl:value-of>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="true()"></xsl:value-of>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <!-- Not classified, so user can access -->
                        <xsl:value-of select="true()"></xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>            
            
            <xsl:otherwise>
                <!-- Security is not activated - so authZ the user -->
                <xsl:value-of select="true()"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    <!-- Test user authorisation against the classification instance to which this template is applied-->
    <xsl:template mode="testAuthZ" match="node()">
        <xsl:param name="classificationDefs"></xsl:param>
        <xsl:param name="userGroupClearance"></xsl:param>
        
        <xsl:variable name="groupID" select="own_slot_value[slot_reference='contained_in_content_classification_group']/value"></xsl:variable>
        <xsl:variable name="aCurrentGroup" select="$classificationGroups[name=$groupID]"></xsl:variable>
        <xsl:variable name="currentGroup" select="$aCurrentGroup/own_slot_value[slot_reference='name']/value"></xsl:variable>        
        <xsl:variable name="userSelectedGroup" select="$userGroupClearance[user:group=$currentGroup]"/>
        <xsl:variable name="userLevelIndex" select="$classificationDefs[view:level=$userSelectedGroup/user:level]/view:index"></xsl:variable>
        <xsl:variable name="viewClassIndex" select="own_slot_value[slot_reference='security_classification_index']/value"></xsl:variable>
               
        <xsl:choose>
            <xsl:when test="number(max($userLevelIndex)) >= number(max($viewClassIndex))">
                <xsl:text>AUTHORISED </xsl:text>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>ACCESS DENIED </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Function to render the name of an instance but applying security clearance levels -->
    <xsl:function name="eas:renderSecuredElement" as="xs:string">
        <xsl:param name="theInstance"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="eas:isUserAuthZ($theInstance)">
                <xsl:value-of select="$theInstance/own_slot_value[slot_reference='name']/value"/>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$theRedactedString"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Test that the user is authorized to access any of the specified instances 
        Instances are provided as a sequence -->
    <xsl:function name="eas:isUserAuthZInstances" as="xs:boolean">
        <xsl:param name="theInstanceList"/>
        
        <xsl:variable name="notAuthZResultList" select="$theInstanceList[not(eas:isUserAuthZ(.))]"/>
        <xsl:value-of select="count($notAuthZResultList) = 0"/>

    </xsl:function>
    
    
    <!-- Test that the user is authorized to access any of the specified classes
        Classes are specified by name in a sequence -->
    <xsl:function name="eas:isUserAuthZClasses" as="xs:boolean">
        <xsl:param name="theClassList"/>
        
        <xsl:variable name="relevantClassSet" select="$theClassSet[name = $theClassList]"/>
        <xsl:variable name="notAuthZResultList" select="$relevantClassSet[not(eas:isUserAuthZ(.))]"/>
        <xsl:value-of select="count($notAuthZResultList) = 0"/>
                  
    </xsl:function>
    
</xsl:stylesheet>
