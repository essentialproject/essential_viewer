<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../../common/core_utilities.xsl"/>
	<xsl:include href="../../common/core_js_functions.xsl"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:param name="param1"/> 
  <xsl:variable name="apps" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]"/>
  <xsl:variable name="dataSubjects" select="/node()/simple_instance[type='Data_Subject']"/>
  <xsl:variable name="dataObjects" select="/node()/simple_instance[type='Data_Object']"/>
  <xsl:variable name="dataRepresentations" select="/node()/simple_instance[type='Data_Representation']"/>
  <xsl:variable name="infoRepresentations" select="/node()/simple_instance[type='Information_Representation']"/>

  <xsl:variable name="dataAppProInfoReps" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION']"/>
  <xsl:variable name="infoRepresentationCategory" select="/node()/simple_instance[type='Information_Representation_Category']"/>

  <xsl:variable name="aptitdrelation" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_TO_DATAREP_RELATION']"/>
  <xsl:variable name="allInfoDomains" select="/node()/simple_instance[type = 'Information_Domain']"/>
  <xsl:variable name="allInfoConcepts" select="/node()/simple_instance[type = 'Information_Concept']"/>
  <xsl:variable name="allInfoViews" select="/node()/simple_instance[type = 'Information_View']"/>
  <xsl:key name="allInfoViewsKey" match="$allInfoViews" use="own_slot_value[slot_reference = 'refinement_of_information_concept']/value"/>
  <xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][name=$allInfoViews/own_slot_value[slot_reference='stakeholders']/value]"/>
  <xsl:key name="actor" match="/node()/simple_instance[type = ('Individual_Actor','Group_Actor')]" use="own_slot_value[slot_reference='actor_plays_role']/value"/>
  <xsl:key name="role" match="/node()/simple_instance[type = ('Individual_Business_Role','Group_Business_Role')]" use="own_slot_value[slot_reference='bus_role_played_by_actor']/value"/>	
  
  <xsl:variable name="aptitdDataObjects" select="/node()/simple_instance[supertype='Data_Object_Type'][own_slot_value[slot_reference='app_pro_use_of_data_rep']/value=$aptitdrelation/name]"/>
<xsl:key name="aptitd_key" match="$aptitdrelation" use="own_slot_value[slot_reference='apppro_to_inforep_to_datarep_to_datarep']/value"/>
<xsl:key name="aptitdinforep_key" match="$aptitdrelation" use="own_slot_value[slot_reference='apppro_to_inforep_to_datarep_from_appro_to_inforep']/value"/>
<xsl:key name="appproinfo_key" match="$dataAppProInfoReps" use="own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value"/>
<xsl:key name="ap2inforep_key" match="$dataAppProInfoReps" use="own_slot_value[slot_reference='operated_data_reps']/value"/>
<xsl:key name="appInfoRep_key" match="$infoRepresentations" use="own_slot_value[slot_reference='inforep_used_by_app_pro']/value"/>
<xsl:key name="app_key" match="$apps" use="own_slot_value[slot_reference='uses_information_representation']/value"/>
<xsl:key name="appsIRUsed_key" match="$apps" use="own_slot_value[slot_reference='uses_information_representation']/value"/>
  <xsl:variable name="infoViews" select="/node()/simple_instance[type='Information_View']"/>
  <xsl:key name="infoViews_key" match="$allInfoViews" use="own_slot_value[slot_reference = 'has_information_representations']/value"/>

  <xsl:key name="infoReps_key" match="$infoRepresentations" use="own_slot_value[slot_reference = 'implements_information_views']/value"/>
  <xsl:key name="infoRepsfordataRep_key" match="$infoRepresentations" use="own_slot_value[slot_reference = 'supporting_data_representations']/value"/>
 
  <xsl:key name="dataObjects" match="$dataObjects" use="own_slot_value[slot_reference = 'defined_by_data_subject']/value"/>
  <xsl:variable name="synonyms" select="/node()/simple_instance[type='Synonym']"/>
  <xsl:variable name="dataCategory" select="/node()/simple_instance[type='Data_Category']"/>
  <xsl:variable name="actors" select="/node()/simple_instance[type=('Group_Actor')]"/>
  <xsl:variable name="individual" select="/node()/simple_instance[type=('Individual_Actor')]"/>	
  <xsl:variable name="dataType" select="/node()/simple_instance[type=('Primitive_Data_Object')] union $dataObjects"/>	
  <xsl:variable name="allActors" select="$actors union $individual"/>	
  <xsl:variable name="classifications" select="/node()/simple_instance[type=('Security_Classification')]"/>
  <xsl:variable name="role" select="/node()/simple_instance[type=('Group_Business_Role','Individual_Business_Role')]"/>	
  <xsl:variable name="actor2Role" select="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]"/> 
  <xsl:key name="actors_key" match="/node()/simple_instance[type=('Individual_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
  <xsl:key name="roles_key" match="/node()/simple_instance[type='Individual_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
  <xsl:key name="grpactors_key" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>
  <xsl:key name="grproles_key" match="/node()/simple_instance[type='Group_Business_Role']" use="own_slot_value[slot_reference = 'bus_role_played_by_actor']/value"/>
  <xsl:key name="externalDoc_key" match="/node()/simple_instance[type='External_Reference_Link']" use="own_slot_value[slot_reference = 'referenced_ea_instance']/value"/>
  <xsl:key name="dataAttribute_key" match="/node()/simple_instance[type='Data_Object_Attribute']" use="own_slot_value[slot_reference = 'belongs_to_data_object']/value"/>
  <xsl:key name="dataRepDO_key" match="/node()/simple_instance[type=('Data_Representation')]" use="own_slot_value[slot_reference = 'implemented_data_object']/value"/>
  <xsl:key name="dataRepCRUDDO_key" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_TO_DATAREP_RELATION')]" use="own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value"/>
  <xsl:key name="dataReptoAPIDP_key" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_TO_DATAREP_RELATION')]" use="own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value"/>
  
 
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
		{
		"data_subjects":[<xsl:apply-templates select="$dataSubjects" mode="dataSubjects"></xsl:apply-templates>],
		"data_objects":[<xsl:apply-templates select="$dataObjects" mode="dataObjects"></xsl:apply-templates>],
		"data_representation":[<xsl:apply-templates select="$dataRepresentations" mode="dataRepresentations"></xsl:apply-templates>],
		"information_representation":[<xsl:apply-templates select="$infoRepresentations" mode="infoRepresentations"></xsl:apply-templates>],
		"information_views":[<xsl:apply-templates select="$allInfoViews" mode="infoViews"></xsl:apply-templates>],
		"information_concepts":[<xsl:apply-templates select="$allInfoConcepts" mode="infoConceptList"/>],
		"app_infoRep_Pairs":[<xsl:apply-templates select="$dataAppProInfoReps" mode="appPairs"></xsl:apply-templates>],
		"info_domains":[<xsl:apply-templates select="$allInfoDomains" mode="infDomains"></xsl:apply-templates>],
		"version":"615"
		}
	</xsl:template>

	 
 <xsl:template match="node()" mode="dataObjects">
	 <xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	 <xsl:variable name="parents" select="$dataSubjects[name=current()/own_slot_value[slot_reference='defined_by_data_subject']/value]"/>
	 <xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	 <xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>
     <xsl:variable name="dataAttribute" select="key('dataAttribute_key',current()/name)"/>
	 <xsl:variable name="sorApps" select="$apps[name=current()/own_slot_value[slot_reference='data_object_system_of_record']/value]"/>
	 <xsl:variable name="thisDataReps" select="key('dataRepDO_key', current()/name)"/>
	 <xsl:variable name="thisInfoRepDataReps" select="key('dataRepCRUDDO_key', current()/name)"/>
	 <xsl:variable name="thisInfoRepDataRepsDirect" select="key('infoRepsfordataRep_key', $thisDataReps/name)"/>
	 
	 <xsl:variable name="thisClassifications" select="$classifications[own_slot_value[slot_reference='sc_classified_information_resources']/value=current()/name]"/>
	 <xsl:variable name="thisInfoViews" select="$allInfoViews[own_slot_value[slot_reference='info_view_supporting_data_objects']/value=current()/name]"/>
	 <xsl:variable name="thisInfoReps" select="key('infoReps_key', $thisInfoViews/name)"/>
	 <xsl:variable name="thisDataRepsAPMapped" select="key('dataReptoAPIDP_key', $thisDataReps/name)"/>

	 <xsl:variable name="allDataRepsViaAITD" select="$thisInfoRepDataReps union $thisDataRepsAPMapped union $thisInfoRepDataRepsDirect"/>
	 <xsl:variable name="alldataapp2info" select="key('ap2inforep_key',$allDataRepsViaAITD/name)"/>
	 <xsl:variable name="alldataapp2inforeps" select="key('appInfoRep_key',$alldataapp2info/name)"/>
	 <xsl:variable name="allRelevantInfoReps" select="$thisInfoReps union $alldataapp2inforeps"/>

	 <xsl:variable name="thisInfoRepAppros" select="key('appproinfo_key', $allRelevantInfoReps/name)"/>
	 
     
    <!-- last two need to be org roles as the slots have been deprecated -->
	{  
	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	 "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	 "synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
 	 "category":"<xsl:value-of select="$dataCategory[name=current()/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value"/>",
	 "isAbstract":"<xsl:value-of select="current()/own_slot_value[slot_reference='data_object_is_abstract']/value"/>",
	 "orgOwner":"<xsl:value-of select="$actors[name=current()/own_slot_value[slot_reference='data_oject_organisation_owner']/value]/own_slot_value[slot_reference='name']/value"/>",
	 "indivOwner":"<xsl:value-of select="$individual[name=current()/own_slot_value[slot_reference='data_object_individual_owner']/value]/own_slot_value[slot_reference='name']/value"/>",
	 "dataAttributes":[<xsl:for-each select="$dataAttribute">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","type":"<xsl:value-of select="$dataType[name=current()/own_slot_value[slot_reference='type_for_data_attribute']/value]/own_slot_value[slot_reference='name']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "systemOfRecord":[<xsl:for-each select="$sorApps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "infoRepsToApps":[<xsl:for-each select="$thisInfoRepAppros"><xsl:variable name="apps" select="key('app_key',current()/name)"/>
	 <xsl:variable name="thisinfoRep" select="key('appInfoRep_key',current()/name)"/><xsl:variable name="thisdataReps" select="key('aptitdinforep_key',current()/name)"/><xsl:variable name="thiscat" select="$infoRepresentationCategory[name=$thisinfoRep/own_slot_value[slot_reference='inforep_category']/value]"/>{ "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","persisted":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_persists_info_rep']/value"/>", "datarepsimplemented":[<xsl:for-each select="$thisdataReps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","create":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_creates_data_rep']/value"/>","read":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_reads_data_rep']/value"/>", "update":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_updates_data_rep']/value"/>","delete":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_deletes_data_rep']/value"/>","dataRepid":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='apppro_to_inforep_to_datarep_to_datarep']/value)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], "appid":"<xsl:value-of select="eas:getSafeJSString($apps/name)"/>", "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$apps"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","idirep":"<xsl:value-of select="eas:getSafeJSString($thisinfoRep/name)"/>","category":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thiscat"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","create":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_creates_info_rep']/value"/>","read":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_reads_info_rep']/value"/>", "update":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_updates_info_rep']/value"/>","delete":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_deletes_info_rep']/value"/>", "nameirep":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisinfoRep"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "infoReps":[<xsl:for-each select="$thisInfoReps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "infoViews":[<xsl:for-each select="$thisInfoViews">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "dataReps":[<xsl:for-each select="$thisDataReps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "stakeholders":[<xsl:for-each select="$thisStakeholders">
			<xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
			<xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
			<xsl:variable name="thisgrpActors" select="key('grpactors_key',current()/name)"/>
			<xsl:variable name="thisgrpRoles" select="key('grproles_key',current()/name)"/>
			<xsl:variable name="allthisActors" select="$thisActors union $thisgrpActors"/>
			<xsl:variable name="allthisRoles" select="$thisRoles union $thisgrpRoles"/>
			{"type": "<xsl:value-of select="$allthisActors/type"/>",
			"actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$allthisActors"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",  
			"actorId":"<xsl:value-of select="eas:getSafeJSString($allthisActors/name)"/>",
			"roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$allthisRoles"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",  
			"roleId":"<xsl:value-of select="eas:getSafeJSString($allthisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>],
	"classifications":[<xsl:for-each select="$thisClassifications">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","shortName":"<xsl:value-of select="current()/own_slot_value[slot_reference='short_name']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"tables":[<xsl:for-each select="$thisInfoRepDataReps">
			<xsl:variable name="thisdataRep" select="$dataRepresentations[name=current()/own_slot_value[slot_reference='apppro_to_inforep_to_datarep_to_datarep']/value]"/>
			<xsl:variable name="app2info" select="key('ap2inforep_key',current()/name)"/>
			<xsl:variable name="apps" select="key('app_key',$app2info/name)"/>
				 {"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				 "dataRep":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisdataRep"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				 "create":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_creates_data_rep']/value"/>","read":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_reads_data_rep']/value"/>", "update":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_updates_data_rep']/value"/>","delete":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_deletes_data_rep']/value"/>",
				 "app2infoReps":[<xsl:for-each select="$app2info">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","infoRep":""}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
				 "apps":[<xsl:for-each select="$apps">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"externalDocs":[<xsl:for-each select="$docs">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"link":"<xsl:value-of select="current()/own_slot_value[slot_reference='external_reference_url']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "parents":[<xsl:for-each select="$parents">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
      
  </xsl:template>

  <xsl:template match="node()" mode="dataSubjects">
	<xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	<xsl:variable name="dos" select="key('dataObjects',current()/name)"/>
	<xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>
   <!-- last two need to be org roles as the slots have been deprecated -->
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"dataObjects":[<xsl:for-each select="$dos">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
	"category":"<xsl:value-of select="$dataCategory[name=current()/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value"/>",
	"orgOwner":"<xsl:value-of select="$actors[name=current()/own_slot_value[slot_reference='data_subject_organisation_owner']/value]/own_slot_value[slot_reference='name']/value"/>",
	"stakeholders":[<xsl:for-each select="$thisStakeholders">
			   <xsl:variable name="thisActors" select="key('actors_key',current()/name)"/>
			   <xsl:variable name="thisRoles" select="key('roles_key',current()/name)"/>
			   <xsl:variable name="thisgrpActors" select="key('grpactors_key',current()/name)"/>
			   <xsl:variable name="thisgrpRoles" select="key('grproles_key',current()/name)"/>
			   <xsl:variable name="allthisActors" select="$thisActors union $thisgrpActors"/>
			   <xsl:variable name="allthisRoles" select="$thisRoles union $thisgrpRoles"/>
			   {"type": "<xsl:value-of select="$allthisActors/type"/>",
			   "actorName":"<xsl:call-template name="RenderMultiLangInstanceName">
			   <xsl:with-param name="theSubjectInstance" select="$allthisActors"/>
			   <xsl:with-param name="isForJSONAPI" select="true()"/>
			   </xsl:call-template>",  
			   "actorId":"<xsl:value-of select="eas:getSafeJSString($allthisActors/name)"/>",
			   "roleName":"<xsl:call-template name="RenderMultiLangInstanceName">
			   <xsl:with-param name="theSubjectInstance" select="$allthisRoles"/>
			   <xsl:with-param name="isForJSONAPI" select="true()"/>
			   </xsl:call-template>",  
			   "roleId":"<xsl:value-of select="eas:getSafeJSString($allthisRoles/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
   </xsl:for-each>],
   "externalDocs":[<xsl:for-each select="$docs">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
   "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
   "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
   "link":"<xsl:value-of select="current()/own_slot_value[slot_reference='external_reference_url']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
   "indivOwner":"<xsl:value-of select="$individual[name=current()/own_slot_value[slot_reference='data_subject_individual_owner']/value]/own_slot_value[slot_reference='name']/value"/>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
 </xsl:template>	
 <xsl:template match="node()" mode="dataRepresentations">
	<xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	<xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="docs" select="key('externalDoc_key', current()/name)"/>
	<xsl:variable name="thisaptitd" select="key('aptitd_key', current()/name)"/>
	<xsl:variable name="thisap2infoRep" select="key('ap2inforep_key', $thisaptitd/name)"/>
	
	
   <!-- last two need to be org roles as the slots have been deprecated -->
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"tables":[<xsl:for-each select="$thisaptitd">
			<xsl:variable name="dataObjects" select="$dataObjects[own_slot_value[slot_reference='app_pro_use_of_data_rep']/value=current()/name]"/>
			{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","create":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_creates_data_rep']/value"/>","read":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_reads_data_rep']/value"/>", "update":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_updates_data_rep']/value"/>","delete":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_deletes_data_rep']/value"/>",
 			"dataObjects":[<xsl:for-each select="$thisaptitd">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if>
			 </xsl:for-each>]
			}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"apps":[<xsl:for-each select="$thisap2infoRep">
		<xsl:variable name="thisapps" select="key('appsIRUsed_key', current()/name)"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisapps"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString($thisapps/name)"/>","create":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_creates_info_rep']/value"/>","read":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_reads_info_rep']/value"/>", "update":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_updates_info_rep']/value"/>","delete":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_deletes_info_rep']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
	"technicalName":"<xsl:value-of select="current()/own_slot_value[slot_reference='dr_technical_name']/value"/>"} <xsl:if test="position()!=last()">,</xsl:if>
 </xsl:template>
 <xsl:template match="node()" mode="infoRepresentations">
	<xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	<xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>
	<xsl:variable name="thisInfoViews" select="key('infoViews_key',current()/name)"/>
	<xsl:variable name="thiscat" select="$infoRepresentationCategory[name=current()/own_slot_value[slot_reference='inforep_category']/value]"/>
   
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"category":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thiscat"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"infoViews":[<xsl:for-each select="$thisInfoViews">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "dataReps":[<xsl:for-each select="current()/own_slot_value[slot_reference='supporting_data_representations']/value">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
} <xsl:if test="position()!=last()">,</xsl:if>
 </xsl:template>
 <xsl:template match="node()" mode="infoViews2">
	<xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	<xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>
	<xsl:variable name="supporting_data_objects" select="own_slot_value[slot_reference='info_view_supporting_data_objects']/value"/>
   <!-- last two need to be org roles as the slots have been deprecated -->
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"dataObjects":[<xsl:for-each select="$supporting_data_objects">{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
 </xsl:template> 
 <xsl:template match="node()" mode="appPairs">
		<xsl:variable name="infoRep" select="key('appInfoRep_key', current()/name)"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"persisted":"<xsl:value-of select="current()/own_slot_value[slot_reference='app_pro_persists_info_rep']/value"/>",
		"infoRep":{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$infoRep"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>","id":"<xsl:value-of select="$infoRep/name"/>"},
		"appId":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value)"/>"}<xsl:if test="position()!=last()">,</xsl:if>
 </xsl:template>
 <xsl:template match="node()" mode="infoConceptList">
	<xsl:variable name="infoViews" select="key('allInfoViewsKey',current()/name)"/>
	 	
	{"id": "<xsl:value-of select="current()/name"/>",
		"className": "<xsl:value-of select="current()/type"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",	
		"infoViews":[<xsl:apply-templates select="$infoViews" mode="infoViews"/>]}<xsl:if test="not(position() = last())">,</xsl:if>

</xsl:template>
<xsl:template match="node()" mode="infoViews">
		<xsl:variable name="thisa2r" select="$a2r[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="instanceName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isForJSONAPI" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template></xsl:variable>
		<xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
		<xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>
		<xsl:variable name="supporting_data_objects" select="own_slot_value[slot_reference='info_view_supporting_data_objects']/value"/>
		{ 
		"id": "<xsl:value-of select="current()/name"/>",
		"className": "<xsl:value-of select="current()/type"/>",
		"name": "<xsl:choose><xsl:when test="$instanceName=''"><xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/></xsl:when><xsl:otherwise><xsl:value-of select="$instanceName"/></xsl:otherwise></xsl:choose>",
		"owner":[<xsl:for-each select="$thisa2r">
				<xsl:variable name="thisactor" select="key('actor',current()/name)"/> 
				<xsl:variable name="thisrole" select="key('role',current()/name)"/> 
			{"id": "<xsl:value-of select="current()/name"/>",
		"className": "<xsl:value-of select="current()/type"/>",
		"name": "<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisactor"/>
				<xsl:with-param name="isForJSONAPI" select="true()"/>
			</xsl:call-template>",
		"role": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$thisrole"/>
			<xsl:with-param name="isForJSONAPI" select="true()"/>
		</xsl:call-template>"
		}<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"dataObjects":[<xsl:for-each select="$supporting_data_objects">{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="infDomains">
	<xsl:variable name="syns" select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>
	<xsl:variable name="thisStakeholders" select="$actor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:variable name="docs" select="key('externalDoc_key',current()/name)"/>  
   <!-- last two need to be org roles as the slots have been deprecated -->
   {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
	"infoConcepts":[<xsl:for-each select="current()/own_slot_value[slot_reference='info_domain_contained_info_concepts']/value">{"id":"<xsl:value-of select="eas:getSafeJSString(.)"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	"synonyms":[<xsl:for-each select="$syns">{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>} <xsl:if test="position()!=last()">,</xsl:if>
 </xsl:template>
</xsl:stylesheet>
