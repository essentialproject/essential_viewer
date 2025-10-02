<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan xs functx eas ess" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!--
		* Copyright ©2020-2022 Enterprise Architecture Solutions Limited.
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
    <!-- 24.06.2020	JWC First implementation -->
    <!-- 04.03.2022 JWC Next Gen Viewer version of this transform -->
    
    <xsl:param name="aReferenceTypeApi"></xsl:param>
    <xsl:param name="allDataSetAPIsApi"></xsl:param>
    
    <eas:apiRequests>
        {
            "apiRequestSet": [
                {
                    "variable": "aReferenceTypeApi",
                    "query": "/instances/type/Report_Implementation_Type/slots?enumeration_value=reference"
                },
                {
                    "variable": "allDataSetAPIsApi",
                    "query": "/instances/type/Data_Set_API"
                }
            ]
        }
    </eas:apiRequests>
    
    <!--<xsl:variable name="aReferenceType" select="/node()/simple_instance[type='Report_Implementation_Type' and own_slot_value[slot_reference='enumeration_value']/value='reference']"></xsl:variable>-->
    <xsl:variable name="aReferenceType" select="$aReferenceTypeApi//simple_instance"></xsl:variable>
    <xsl:variable name="allDataSetAPIs" select="$allDataSetAPIsApi//simple_instance"></xsl:variable>
    
    <!--<xsl:variable name="aDataSetAPIList" select="/node()/simple_instance[type='Data_Set_API' and own_slot_value[slot_reference='report_implementation_type']/value=$aReferenceType/name and own_slot_value[slot_reference='is_data_set_api_precached']/value='true']"></xsl:variable>-->
    <xsl:variable name="aDataSetAPIList" select="$allDataSetAPIs[own_slot_value[slot_reference='report_implementation_type']/value=$aReferenceType/name and own_slot_value[slot_reference='is_data_set_api_precached']/value='true']"></xsl:variable>
    
    <xsl:template match="knowledge_base">
        {
        "preCacheReferences" : [<xsl:apply-templates select="$aDataSetAPIList" mode="RenderReference"></xsl:apply-templates>]
        }
    </xsl:template>
    
    <xsl:template mode="RenderReference" match="node()">
        <xsl:choose>
            <xsl:when test="own_slot_value[slot_reference='is_data_set_api_precached']/value='true'">
                "<xsl:value-of select="own_slot_value[slot_reference='report_xsl_filename']/value"></xsl:value-of>"
                <xsl:if test="position() &lt; count($aDataSetAPIList)">,
                </xsl:if>		
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>