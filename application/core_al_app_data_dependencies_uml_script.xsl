<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:functx="http://www.functx.com" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">

	<xsl:import href="../common/core_utilities.xsl"/>

	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>

	<!--
		* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	<!-- 20.08.2010 JP	Created -->
	<!-- 13.05.2011 JWC	Introduced infodataviews.css -->
	<!--01.09.2011 NJW Updated to Support Viewer v3-->

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4"/>-->

	<!-- xSize = an optional width of the resulting model in pixels -->
	<xsl:param name="xSize"/>

	<!-- ySize = an optional height of the resulting model in pixels -->
	<xsl:param name="ySize"/>

	<xsl:variable name="allAppProviders" select="/node()/simple_instance[((type = 'Application_Provider') or (type = 'Composite_Application_Provider'))]"/>
	<xsl:variable name="allAppPro2InfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $allAppProviders/name]"/>
	<xsl:variable name="allAppPro2Info2DataReps" select="/node()/simple_instance[name = $allAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[(type = 'Data_Object')]"/>
	<xsl:variable name="allDataReps" select="/node()/simple_instance[(type = 'Data_Representation')]"/>
	<!--<xsl:variable name="allDataObjects" select="/node()/simple_instance[(type='Data_Object') and (name=$allAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value)]"/>-->
	<xsl:variable name="manualDataEntryMethod" select="/node()/simple_instance[(type = 'Data_Acquisition_Method') and (own_slot_value[slot_reference = 'name']/value = 'Manual Data Entry')]"/>

	<!--<xsl:variable name="selectedAppProvider" select="$allAppProviders[name=$param1]"/>
	<xsl:variable name="selectedAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value = $selectedAppProvider/name]"/>
	<xsl:variable name="selectedAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[name=$selectedAppPro2InfoReps/own_slot_value[slot_reference='operated_data_reps']/value]"/>
	<xsl:variable name="selectedSourceAppPro2InfoReps" select="$allAppPro2InfoReps[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference='app_datarep_inforep_source']/value]"/>
	<xsl:variable name="selectedSourceApps" select="$allAppProviders[name = $selectedSourceAppPro2InfoReps/own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value]"/>
	<xsl:variable name="inScopeApps" select="$selectedAppProvider union $selectedSourceApps"/>-->

	<xsl:variable name="selectedAppProvider" select="$allAppProviders[name = $param1]"/>
	<xsl:variable name="selectedAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $selectedAppProvider/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
	<xsl:variable name="selectedAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[name = $selectedAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
	<xsl:variable name="selectedDataReps" select="$allDataReps[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
	<xsl:variable name="selectedRepDataObjects" select="$allDataObjects[name = $selectedDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value]"/>
	<xsl:variable name="actualSelectedDataObjects" select="$allDataObjects[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>
	<xsl:variable name="inScopeDataObjects" select="$selectedRepDataObjects union actualSelectedDataObjects"/>
	<xsl:variable name="selectedSourceAppPro2InfoReps" select="$allAppPro2InfoReps[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"/>
	<xsl:variable name="selectedSourceApps" select="$allAppProviders[name = $selectedSourceAppPro2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
	<xsl:variable name="inScopeApps" select="$selectedAppProvider union $selectedSourceApps"/>


	<xsl:variable name="invalidCharsFrom" select="('[(]', '[)]', ' ', '/')"/>
	<xsl:variable name="invalidCharsTo" select="('', '', '')"/>


	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="count($selectedAppPro2Info2DataReps) > 0">
				@startuml
				
				<xsl:apply-templates mode="RenderApplication" select="$selectedAppProvider"/>
				<xsl:apply-templates mode="RenderSourceApplication" select="$selectedSourceApps"/>
				
				<xsl:apply-templates mode="RenderDataLinksForApp" select="$selectedAppProvider"/>
				
				hide empty members&#10;
				<xsl:apply-templates mode="RenderAppDataObjectFormatting" select="$selectedAppProvider"/>
				<xsl:apply-templates mode="RenderSourceAppDataObjectFormatting" select="$selectedSourceApps"/>
				
				skinparam svek true
				skinparam classBackgroundColor #ffffff
				skinparam classBorderColor #666666
				skinparam classArrowColor #666666
				skinparam classFontColor #333333 
				skinparam classFontSize 11 
				skinparam classFontName Arial
				skinparam circledCharacterFontColor #ffffff
				skinparam packageBorderColor #666666
				skinparam packageFontName arial
				skinparam packageFontStyle bold
				skinparam packageFontSize 13
				skinparam packageStyle rect
				
				
				<xsl:if test="string-length($xSize) > 0 and string-length($ySize) > 0">
					scale <xsl:value-of select="$xSize"/>*<xsl:value-of select="$ySize"/>
				</xsl:if>
				
				@enduml
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderEmptyUMLModel">
					<xsl:with-param name="message" select="'No Application Dependencies Defined'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>	


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderApplication">
		<xsl:variable name="thisApp" select="current()"/>
		<!--<xsl:variable name="appName" select="own_slot_value[slot_reference='name']/value"/>-->
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $thisApp/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value)]"/>
		<xsl:variable name="currentDataReps" select="$allDataReps[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<!--<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference='app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference='app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		--> package "<xsl:value-of select="$packageName"/>" { 
		<xsl:apply-templates mode="RenderDataObject" select="$currentDataObjects">
			<xsl:with-param name="appName" select="$packageName"/>
		</xsl:apply-templates>
		<!--<xsl:apply-templates mode="RenderSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates>--> }&#10;&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderSourceApplication">
		<xsl:variable name="thisApp" select="current()"/>
		<!--<xsl:variable name="appName" select="own_slot_value[slot_reference='name']/value"/>-->
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<!--<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value =$thisApp/name)]"/>
		-->
		<xsl:variable name="myApp2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $thisApp/name]"/>
		<xsl:variable name="myTargetApp2Info2DataReps" select="$selectedAppPro2Info2DataReps[own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $myApp2InfoReps/name]"/>
		<xsl:variable name="myDefinedDataReps" select="$allDataReps[name = $myTargetApp2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $myTargetApp2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $myDefinedDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<!--<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value =$thisApp/name) and (own_slot_value[slot_reference='app_pro_persists_info_rep']/value ='true')]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference='operated_data_reps']/value)]"/>
		<xsl:variable name="currentDataReps" select="$allDataReps[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		-->
		<!--<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference='implemented_data_object']/value)]"/>
		-->
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<!--<xsl:variable name="sourceAppPro2Info2DataReps" select="$selectedAppPro2Info2DataReps[(own_slot_value[slot_reference='app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference='app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		--> package "<xsl:value-of select="$packageName"/>" { 
		<xsl:apply-templates mode="RenderDataObject" select="$currentDataObjects">
			<xsl:with-param name="appName" select="$packageName"/>
		</xsl:apply-templates>
		<!--<xsl:apply-templates mode="RenderSourcedDataObject" select="$myTargetApp2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates>--> }&#10;&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderApplicationOLD">
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = current()/name]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[name = $currentAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/> package "<xsl:value-of select="$packageName"/>" { <xsl:apply-templates mode="RenderDataObject" select="$currentDataObjects">
			<xsl:with-param name="appName" select="$packageName"/>
		</xsl:apply-templates>
		<xsl:apply-templates mode="RenderSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates> }&#10;&#10; </xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render the data dependencies for a given Application -->
	<xsl:template match="node()" mode="RenderDataLinksForApp">
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = current()/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value)]"/>
		<xsl:variable name="currentDataReps" select="$allDataReps[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<!--<xsl:variable name="currentDataObjects" select="$allDataObjects[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value]"/>
		-->
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name)]"/> &#10; <xsl:apply-templates mode="RenderDataSource" select="$currentAppPro2Info2DataReps">
			<xsl:with-param name="targetAppName" select="$packageName"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- 11.08.2011 JP -->
	<!-- Render a Data Object as a UML Class -->
	<xsl:template match="node()" mode="RenderDataObject">
		<xsl:param name="appName"/>
		<xsl:variable name="dataObjectName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="fullObjectName" select="concat($appName, $dataObjectName)"/>

		<xsl:variable name="strippedObjectName" select="eas:stripSpecialChars($fullObjectName)"/>
		<!--<xsl:variable name="strippedObjectName" select="translate($fullObjectName, ' ', '')"/>-->

		<xsl:call-template name="DeclareDataObject">
			<xsl:with-param name="fullName" select="$strippedObjectName"/>
			<xsl:with-param name="displayName" select="$dataObjectName"/>
		</xsl:call-template>

		<!--class <xsl:value-of select="$strippedObjectName"/> as "<xsl:value-of select="$dataObjectName"/>"&#10;-->
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a Data Object as a UML Class where the given application is a data source, but the data is not explicitly captrued as being managed by the application -->
	<xsl:template match="node()" mode="RenderSourcedDataObject">
		<xsl:param name="appName"/>
		<xsl:param name="currentDataObjects"/>
		<xsl:variable name="dataObject" select="$allDataObjects[name = current()/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>

		<xsl:if test="not(functx:is-node-in-sequence($dataObject, $currentDataObjects))">
			<xsl:variable name="dataObjectName" select="$dataObject/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="fullSourceObjectName" select="concat($appName, $dataObjectName)"/>
			<xsl:variable name="strippedSourceObjectName" select="eas:stripSpecialChars($fullSourceObjectName)"/>
			<!--<xsl:variable name="strippedSourceObjectName" select="functx:replace-multi($fullSourceObjectName, $invalidCharsFrom,$invalidCharsTo)"/>-->
			<!--<xsl:variable name="strippedSourceObjectName" select="translate($fullSourceObjectName, ' ', '')"/>-->

			<xsl:call-template name="DeclareDataObject">
				<xsl:with-param name="fullName" select="$strippedSourceObjectName"/>
				<xsl:with-param name="displayName" select="$dataObjectName"/>
			</xsl:call-template>
			<!--class <xsl:value-of select="$strippedSourceObjectName"/> as "<xsl:value-of select="$dataObjectName"/>"&#10;-->
		</xsl:if>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an AppPro2InfoRep2DataRep source application as a UML Association -->
	<xsl:template match="node()" mode="RenderDataSource">
		<xsl:param name="targetAppName"/>

		<xsl:variable name="currentDataSource" select="current()"/>

		<xsl:variable name="currentDataReps" select="$allDataReps[name = current()/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>


		<xsl:variable name="dataObject" select="$allDataObjects[(name = $currentDataSource/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<xsl:for-each select="$dataObject">
			<xsl:variable name="dataObjectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="fullTargetObjectName" select="concat($targetAppName, $dataObjectName)"/>
			<xsl:variable name="strippedTargetObjectName" select="eas:stripSpecialChars($fullTargetObjectName)"/>
			<!--<xsl:variable name="strippedTargetObjectName" select="translate($fullTargetObjectName, ' ', '')"/>-->

			<xsl:variable name="sourceApp2InfoRep" select="$allAppPro2InfoReps[name = $currentDataSource/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"/>
			<xsl:if test="count($sourceApp2InfoRep) > 0">
				<xsl:for-each select="$sourceApp2InfoRep">
					<xsl:variable name="sourceApp" select="$allAppProviders[name = current()/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
					<xsl:variable name="sourceAppName" select="$sourceApp/own_slot_value[slot_reference = 'name']/value"/>
					<xsl:variable name="fullSourceObjectName" select="concat($sourceAppName, $dataObjectName)"/>
					<xsl:variable name="strippedSourceObjectName" select="eas:stripSpecialChars($fullSourceObjectName)"/>
					<!--<xsl:variable name="strippedSourceObjectName" select="translate($fullSourceObjectName, ' ', '')"/>-->

					<xsl:call-template name="AssociateDataObjects">
						<xsl:with-param name="sourceDataName" select="$strippedSourceObjectName"/>
						<xsl:with-param name="targetDataName" select="$strippedTargetObjectName"/>
					</xsl:call-template>
				</xsl:for-each>

				<!--&#10;"<xsl:value-of select="$strippedTargetObjectName"/>" -> <xsl:value-of select="$strippedSourceObjectName"/><xsl:text>&#10;</xsl:text>-->
			</xsl:if>
		</xsl:for-each>


	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the formatting for all Data Objects being displayed -->
	<xsl:template match="node()" mode="RenderAppDataObjectFormatting">
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = current()/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value)]"/>
		<xsl:variable name="currentDataReps" select="$allDataReps[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		<xsl:apply-templates mode="RenderDataObjectFormat" select="$currentAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
		</xsl:apply-templates>&#10;&#10; <!--<xsl:apply-templates mode="FormatSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates>-->
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the formatting for all Data Objects being displayed -->
	<xsl:template match="node()" mode="RenderSourceAppDataObjectFormatting">
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="myApp2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = current()/name]"/>
		<xsl:variable name="myTargetApp2Info2DataReps" select="$selectedAppPro2Info2DataReps[own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $myApp2InfoReps/name]"/>
		<xsl:variable name="myDefinedDataReps" select="$allDataReps[name = $myTargetApp2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $myTargetApp2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $myDefinedDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>

		<!--<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value =current()/name]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference='operated_data_reps']/value) and (own_slot_value[slot_reference='app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value]"/>
		-->
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->

		<xsl:variable name="myAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $myApp2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value)]"/>
		<xsl:variable name="relevantDataReps" select="$allDataReps[(name = $myAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value) and (own_slot_value[slot_reference = 'implemented_data_object']/value = $currentDataObjects/name)]"/>
		<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value = $relevantDataReps/name) or (own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $currentDataObjects/name)]"/>


		<xsl:choose>
			<xsl:when test="count($sourceAppPro2Info2DataReps) > 0">
				<xsl:apply-templates mode="RenderDataObjectFormat" select="$sourceAppPro2Info2DataReps">
					<xsl:with-param name="appName" select="$packageName"/>
				</xsl:apply-templates>&#10;&#10; </xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$currentDataObjects">
					<xsl:variable name="dataObjectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
					<xsl:variable name="fullObjectName" select="concat($packageName, $dataObjectName)"/>
					<xsl:variable name="strippedObjectName" select="eas:stripSpecialChars($fullObjectName)"/>
					<xsl:call-template name="RenderUnknownDataObject">
						<xsl:with-param name="dataName" select="$strippedObjectName"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>


		<xsl:apply-templates mode="FormatSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render the formatting for all Data Objects being displayed -->
	<xsl:template match="node()" mode="RenderAllDataObjectFormatting">
		<xsl:variable name="packageName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = current()/name]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value) and (own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		<xsl:apply-templates mode="RenderDataObjectFormat" select="$currentAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
		</xsl:apply-templates>&#10;&#10; <xsl:apply-templates mode="FormatSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Format a Data Object where the given application is a data source, but the data is not explicitly captrued as being managed by the application -->
	<xsl:template match="node()" mode="FormatSourcedDataObject">
		<xsl:param name="appName"/>
		<xsl:param name="currentDataObjects"/>

		<xsl:variable name="currentDataRel" select="current()"/>

		<xsl:variable name="relevantDataReps" select="$allDataReps[(name = current()/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value)]"/>
		<xsl:variable name="dataObject" select="$allDataObjects[(name = current()/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $relevantDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>

		<xsl:for-each select="$dataObject">
			<xsl:if test="not(functx:is-node-in-sequence(current(), $currentDataObjects))">
				<xsl:variable name="dataObjectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="fullSourceObjectName" select="concat($appName, $dataObjectName)"/>
				<xsl:variable name="strippedSourceObjectName" select="eas:stripSpecialChars($fullSourceObjectName)"/>
				<!--<xsl:variable name="strippedSourceObjectName" select="translate($fullSourceObjectName, ' ', '')"/>-->


				<xsl:call-template name="RenderUnknownDataObject">
					<xsl:with-param name="dataName" select="$strippedSourceObjectName"/>
				</xsl:call-template>

			</xsl:if>
		</xsl:for-each>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the format for a Data Object -->
	<xsl:template match="node()" mode="RenderDataObjectFormat">
		<xsl:param name="appName"/>
		<xsl:variable name="currentDataRel" select="current()"/>
		<xsl:variable name="currentDataRep" select="$allDataReps[name = $currentDataRel/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="currentDataObject" select="$allDataObjects[(name = $currentDataRel/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $currentDataRep/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>

		<xsl:for-each select="$currentDataObject">
			<xsl:variable name="dataObjectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="fullObjectName" select="concat($appName, $dataObjectName)"/>
			<xsl:variable name="strippedObjectName" select="eas:stripSpecialChars($fullObjectName)"/>
			<!--<xsl:variable name="strippedObjectName" select="translate($fullObjectName, ' ', '')"/>-->

			<xsl:choose>
				<xsl:when test="$currentDataRel/own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value = $manualDataEntryMethod/name">
					<xsl:call-template name="RenderManualDataObject">
						<xsl:with-param name="dataName" select="$strippedObjectName"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="RenderAutomatedDataObject">
						<xsl:with-param name="dataName" select="$strippedObjectName"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>


	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the format for a Data Object that is entered manually-->
	<xsl:template name="RenderManualDataObject">
		<xsl:param name="dataName"/>
		<xsl:value-of select="$dataName"/> &lt;&lt; (M,red) >>&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the format for a Data Object that is sourced in an automated manner-->
	<xsl:template name="RenderAutomatedDataObject">
		<xsl:param name="dataName"/>
		<xsl:value-of select="$dataName"/> &lt;&lt; (A,#e7c23d) >>&#10; </xsl:template>

	<!-- 11.08.2011 JP -->
	<!-- Render the format for a Data Object that is sourced in an automated manner-->
	<xsl:template name="RenderUnknownDataObject">
		<xsl:param name="dataName"/>
		<xsl:value-of select="$dataName"/> &lt;&lt; (U,grey) >>&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Declare a Data Object within a package (Application)-->
	<xsl:template name="DeclareDataObject">
		<xsl:param name="fullName"/>
		<xsl:param name="displayName"/> class <xsl:value-of select="$fullName"/> as "<xsl:value-of select="$displayName"/>"&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Associate two Data Object within or across Packages-->
	<xsl:template name="AssociateDataObjects">
		<xsl:param name="sourceDataName"/>
		<xsl:param name="targetDataName"/> &#10;"<xsl:value-of select="$targetDataName"/>"<xsl:text> -> </xsl:text><xsl:value-of select="$sourceDataName"/><xsl:text>&#10;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
