<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
 
 <xsl:variable name="dataSubjects" select="/node()/simple_instance[type='Data_Subject']"/>
  <xsl:variable name="dataObjects" select="/node()/simple_instance[type='Data_Object']"/>

  <xsl:variable name="synonyms" select="/node()/simple_instance[type='Synonym']"/>
  <xsl:variable name="dataCategory" select="/node()/simple_instance[type='Data_Category']"/>
  <xsl:variable name="actors" select="/node()/simple_instance[type=('Group_Actor')]"/>
  <xsl:variable name="individual" select="/node()/simple_instance[type=('Individual_Actor')]"/>	
  <xsl:variable name="dataType" select="/node()/simple_instance[type=('Primitive_Data_Object')] union $dataObjects"/>	
  <xsl:variable name="allActors" select="$actors union $individual"/>	
  <xsl:variable name="role" select="/node()/simple_instance[type=('Group_Business_Role','Individual_Business_Role')]"/>	
  <xsl:variable name="actor2Role" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]"/> 
  <xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
  <xsl:key name="roles_key" match="/node()/simple_instance[type='Individual_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
  <xsl:key name="grpactors_key" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
  <xsl:key name="grproles_key" match="/node()/simple_instance[type='Group_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
  <xsl:key name="externalDoc_key" match="/node()/simple_instance[type='External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/>
  <xsl:key name="dataAttribute_key" match="/node()/simple_instance[type='Data_Object_Attribute']" use="own_slot_value[slot_reference = 'belongs_to_data_object']/value"/>
  
<!--  <xsl:variable name="actors" select="/node()/simple_instance[type=('Group_Actor')]"/>
  <xsl:variable name="individual" select="/node()/simple_instance[type=('Individual_Actor')]"/>	
	
  <xsl:variable name="allActors" select="$actors union $individual"/>	
  <xsl:variable name="role" select="/node()/simple_instance[type=('Group_Business_Role','Individual_Business_Role')]"/>	
  <xsl:variable name="actor" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')][own_slot_value[slot_reference = 'act_to_role_from_actor']/value=$allActors/name]"/>  -->
	 
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
		{"data_objects":[<xsl:apply-templates select="$dataObjects" mode="dataObjects"></xsl:apply-templates>],"version":"614"}
	</xsl:template>

	 
 <xsl:template match="node()" mode="dataObjects">
	 <xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	 <xsl:variable name="parents" select="$dataSubjects[name=current()/own_slot_value[slot_reference='defined_by_data_subject']/value]"/>
	 <xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	 <xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>
	 <xsl:variable name="dataAttribute" select="key('dataAttribute_key',current()/name)"/>
    <!-- last two need to be org roles as the slots have been deprecated -->
    {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
		'category': string(translate(translate($dataCategory[name=current()/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value, '}', ')'), '{', ')')),
		'isAbstract': string(translate(translate(current()/own_slot_value[slot_reference = ('data_object_is_abstract')]/value, '}', ')'), '{', ')')),
		'orgOwner': string(translate(translate($actors[name=current()/own_slot_value[slot_reference='data_oject_organisation_owner']/value]/own_slot_value[slot_reference='name']/value, '}', ')'), '{', ')')),
		'indivOwner': string(translate(translate($individual[name=current()/own_slot_value[slot_reference='data_object_individual_owner']/value]/own_slot_value[slot_reference='name']/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
	 "synonyms":[<xsl:for-each select="$syns">{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "dataAttributes":[<xsl:for-each select="$dataAttribute">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 <xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('data_attribute_label')]/value, '}', ')'), '{', ')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value, '}', ')'), '{', ')')),
		'type': string(translate(translate($dataType[name=current()/own_slot_value[slot_reference='type_for_data_attribute']/value]/own_slot_value[slot_reference='name']/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "stakeholders":[<xsl:for-each select="$thisStakeholders">
			<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
			<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
			<xsl:variable name="thisgrpActors" select="key('grpactors_key',current()/name)"/>
			<xsl:variable name="thisgrpRoles" select="key('grproles_key',current()/name)"/>
			<xsl:variable name="allthisActors" select="$thisActors union $thisgrpActors"/>
			<xsl:variable name="allthisRoles" select="$thisRoles union $thisgrpRoles"/>
			{"type": "<xsl:value-of select="$allthisActors/type"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{ 
					'actorName': string(translate(translate($allthisActors/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
					'roleName': string(translate(translate($allthisRoles/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
				  }"></xsl:variable>
				  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
				  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,
                "actorId":"<xsl:value-of select="eas:getSafeJSString($allthisActors/name)"/>",
                "roleId":"<xsl:value-of select="eas:getSafeJSString($allthisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>],
	"externalDocs":[<xsl:for-each select="$docs">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')')),
		'link': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "parents":[<xsl:for-each select="$parents">{<xsl:variable name="combinedMap" as="map(*)" select="map{ 
		'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
	  }"></xsl:variable>
	  <xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
	  <xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>,<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
      
  </xsl:template>
	
</xsl:stylesheet>
