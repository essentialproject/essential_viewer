<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
	
    <xsl:variable name="technodes" select="/node()/simple_instance[type = 'Technology_Node']"/> 
    <xsl:variable name="appswinstance" select="/node()/simple_instance[type = 'Application_Software_Instance'][own_slot_value[slot_reference='technology_instance_deployed_on_node']/value=$technodes/name]"/> 

    <xsl:variable name="appsdeployment" select="/node()/simple_instance[type = 'Application_Deployment'][own_slot_value[slot_reference='application_deployment_technology_instance']/value=$appswinstance/name]"/> 
    <xsl:variable name="deploymentRole" select="node()/simple_instance[type = 'Deployment_Role']"/>
    <xsl:variable name="applications" select="/node()/simple_instance[type = ('Composite_Application_Provider', 'Application_Provider')]"/>  
 
	<xsl:key name="applications" match="/node()/simple_instance[type = ('Composite_Application_Provider')]" use="own_slot_value[slot_reference='deployments_of_application_provider']/value"/>
	<xsl:key name="appswinstance" match="/node()/simple_instance[type = 'Application_Software_Instance']" use="own_slot_value[slot_reference='technology_instance_deployed_on_node']/value"/>
	<xsl:key name="appsdeployment" match="/node()/simple_instance[type = 'Application_Deployment']" use="own_slot_value[slot_reference='application_deployment_technology_instance']/value"/>
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
		{"app2server":[<xsl:apply-templates select="$technodes" mode="app2Serv"></xsl:apply-templates>{}]}
	</xsl:template>

	
 <xsl:template match="node()" mode="app2Serv"> 
    <xsl:variable name="thisappswinstance" select="key('appswinstance', current()/name)"/> 
    <xsl:variable name="thisappsdeployment" select="key('appsdeployment', $thisappswinstance/name)"/> 
    <xsl:variable name="thisapps" select="key('applications', $thisappsdeployment/name)"/> 
    
    <xsl:apply-templates select="$thisapps" mode="app2ServRow">
      <xsl:with-param name="srv" select="current()"/>
      <xsl:with-param name="appdep" select="$thisappsdeployment"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="node()" mode="app2ServRow"> 
    <xsl:param name="srv"></xsl:param>
    <xsl:param name="appdep"></xsl:param>
      
    <xsl:variable name="thisdeploymentRole" select="$deploymentRole[name=$appdep/own_slot_value[slot_reference='application_deployment_role']/value]"/> 
      {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	  <xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
		'server': string(translate(translate($srv/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
		}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
      "deployment":[<xsl:for-each select="$thisdeploymentRole">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",<xsl:variable name="combinedMap" as="map(*)" select="map{
		'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
		}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		},
   
  </xsl:template> 
		
</xsl:stylesheet>
