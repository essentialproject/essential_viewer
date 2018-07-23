<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:functx="http://www.functx.com" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org" xpath-default-namespace="http://protege.stanford.edu/xml">
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
	<xsl:param name="param4"/>

	<!-- xSize = an optional width of the resulting model in pixels -->
	<xsl:param name="xSize"/>

	<!-- ySize = an optional height of the resulting model in pixels -->
	<xsl:param name="ySize"/>



	<xsl:variable name="allAppProviders" select="/node()/simple_instance[((type = 'Application_Provider') or (type = 'Composite_Application_Provider')) and (own_slot_value[slot_reference = 'element_classified_by']/value = $param4)]"/>
	<xsl:variable name="allAppRoles" select="/node()/simple_instance[name = $allAppProviders/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
	<xsl:variable name="allPhysProc2Apps" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $allAppRoles/name]"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[name = $allPhysProc2Apps/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[name = $allPhysProcs/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>

	<xsl:variable name="allDeliveryModels" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>
	<xsl:variable name="onSiteDeliveryModel" select="$allDeliveryModels[own_slot_value[slot_reference = 'name']/value = 'OnSite']"/>

	<xsl:variable name="unknownLocationName" select="'Location Undefined'"/>
	<xsl:variable name="unknownLocationApps" select="$allAppProviders[eas:appHasLocation(.) = 'false']"/>
	<xsl:variable name="knownLocationApps" select="$allAppProviders[eas:appHasLocation(.) = 'true']"/>

	<xsl:variable name="allStaticAppArchs" select="/node()/simple_instance[name = $allAppProviders/own_slot_value[slot_reference = 'ap_static_architecture']/value]"/>
	<xsl:variable name="allDependentAppUsages" select="/node()/simple_instance[name = $allStaticAppArchs/own_slot_value[slot_reference = 'static_app_provider_architecture_elements']/value]"/>
	<xsl:variable name="allDependentRelations" select="/node()/simple_instance[name = $allStaticAppArchs/own_slot_value[slot_reference = 'uses_provider']/value]"/>



	<xsl:variable name="allAppPro2InfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $allAppProviders/name]"/>
	<xsl:variable name="allAppPro2Info2DataReps" select="/node()/simple_instance[name = $allAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[name = $allAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>
	<xsl:variable name="manualDataEntryMethod" select="/node()/simple_instance[(type = 'Data_Acquisition_Method') and (own_slot_value[slot_reference = 'name']/value = 'Manual Data Entry')]"/>

	<xsl:template match="knowledge_base">
		<xsl:choose>
			<xsl:when test="count($allAppProviders) > 0"> @startuml hide empty members <!--<xsl:call-template name="RenderUndefinedLocationApps"><xsl:with-param name="apps" select="$unknownLocationApps"></xsl:with-param></xsl:call-template>-->
				<xsl:apply-templates mode="RenderUndefinedLocationApplication" select="$unknownLocationApps"/>
				<xsl:apply-templates mode="RenderLocation" select="$allSites"/>
				<xsl:apply-templates mode="RenderCompositeApplication" select="$allAppProviders[(type = 'Composite_Application_Provider')]"/>
				<xsl:apply-templates mode="RenderLinksForApp" select="$knownLocationApps[(type = 'Application_Provider')]"/>
				<xsl:apply-templates mode="RenderLinksForUnknownLocationApp" select="$unknownLocationApps[(type = 'Application_Provider')]"/>
				<xsl:apply-templates mode="RenderAllAppsFormatting" select="$allSites"/>
				<xsl:for-each select="$allAppProviders[(type = 'Composite_Application_Provider')]">
					<xsl:variable name="compAppName" select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:variable name="containedApps" select="$allAppProviders[name = current()/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
					<xsl:apply-templates mode="RenderAppFormat" select="$containedApps">
						<xsl:with-param name="locationName" select="$compAppName"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<xsl:call-template name="RenderUndefinedLocationAppsFormatting"><xsl:with-param name="apps" select="$unknownLocationApps"/></xsl:call-template>
				<!--<xsl:apply-templates mode="RenderLinksForApp" select="$unknownLocationApps[(type='Application_Provider')]"/>-->
				<!--package "New York" {
					class "Supply Chain Management" &lt;&lt; (I,#f8a85c) >>
					class "Payroll" &lt;&lt; (I,#f8a85c) >>
					class "Financial Management" &lt;&lt; (E,#6593c8) >>
					class "Master Data Management" &lt;&lt; (I,#f8a85c) >>
					class "Strategic Planning" &lt;&lt; (E,#6593c8) >>
					}
					
					Package London	{
					class "CIPRO" &lt;&lt; (I,#f8a85c) >>
					class "Complex Warehouse Management" &lt;&lt; (E,#6593c8) >>
					class "SARS" &lt;&lt; (I,#f8a85c) >>
					package "Tokyo" #ffffff
					}
					
					package "Tokyo" #ffffff	{
					class "Apple" &lt;&lt; (E,#6593c8) >>
					}--> skinparam svek true skinparam packageStyle rect skinparam classBackgroundColor #ffffff skinparam classBorderColor #666666 skinparam classArrowColor #666666 skinparam classFontColor #333333 skinparam classFontSize 11 skinparam classFontName Arial skinparam circledCharacterFontColor #ffffff skinparam packageFontName "Arial Black" skinparam packageFontSize 14 skinparam packageFontColor #333333 skinparam packageBorderColor #666666 skinparam packageFontStyle normal skinparam packageBackgroundColor #a9c66f <!--url of CityHeadquartersLondonAdvantage is [[http://www.google.com]]--> @enduml </xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderEmptyUMLModel">
					<xsl:with-param name="message" select="'No Applications Defined'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderLocation">
		<xsl:variable name="locationName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="physProcsAtLocation" select="$allPhysProcs[own_slot_value[slot_reference = 'process_performed_at_sites']/value = current()/name]"/>
		<xsl:variable name="physProcs2AppRoles" select="$allPhysProc2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsAtLocation/name]"/>
		<xsl:variable name="appRoles" select="$allAppRoles[name = $physProcs2AppRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="apps" select="$allAppProviders[name = $appRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="dependentAppUsages" select="$allDependentAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $apps/name]"/>
		<!--<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value =current()/name]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[name = $currentAppPro2InfoReps/own_slot_value[slot_reference='operated_data_reps']/value]"/>
		<xsl:variable name="currentDataObjects" select="$allDataObjects[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value]"/>
		-->
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<!--<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[own_slot_value[slot_reference='app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name]"></xsl:variable>
		--> package "<xsl:value-of select="$locationName"/>" { <xsl:apply-templates mode="RenderApplication" select="$apps">
			<xsl:with-param name="locationName" select="$locationName"/>
		</xsl:apply-templates>
		<!--<xsl:apply-templates mode="RenderSourcedDataObject" select="$sourceAppPro2Info2DataReps">
				<xsl:with-param name="appName" select="$packageName"/>
				<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
			</xsl:apply-templates>--> }&#10;&#10; </xsl:template>


	<!-- Render the set of applications that have no site defined -->
	<xsl:template name="RenderUndefinedLocationApps">
		<xsl:param name="apps"/>

		<!--<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference='app_pro_to_inforep_from_app']/value =current()/name]"/>
			<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[name = $currentAppPro2InfoReps/own_slot_value[slot_reference='operated_data_reps']/value]"/>
			<xsl:variable name="currentDataObjects" select="$allDataObjects[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value]"/>
		-->
		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<!--<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[own_slot_value[slot_reference='app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name]"></xsl:variable>
		-->
		<xsl:apply-templates mode="RenderUnknownLocationApplication" select="$apps"/>

		<!--<xsl:apply-templates mode="RenderSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
			</xsl:apply-templates>-->

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Package -->
	<xsl:template match="node()" mode="RenderCompositeApplication">
		<xsl:variable name="appName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="containedApps" select="$allAppProviders[name = current()/own_slot_value[slot_reference = 'contained_application_providers']/value]"/> package "<xsl:value-of select="$appName"/>" #ffffff { <xsl:apply-templates mode="RenderApplication" select="$containedApps">
			<xsl:with-param name="locationName" select="$appName"/>
		</xsl:apply-templates>
		<!--<xsl:apply-templates mode="RenderSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
			</xsl:apply-templates>--> }&#10;&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Class -->
	<xsl:template match="node()" mode="RenderApplication">
		<xsl:param name="locationName"/>
		<xsl:variable name="appName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="fullAppName" select="concat($locationName, $appName)"/>
		<!--<xsl:variable name="strippedAppName" select="translate($fullAppName, ' ', '')"/>-->
		<xsl:variable name="strippedAppName" select="translate($fullAppName, translate($fullAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:choose>
			<xsl:when test="type = 'Application_Provider'">
				<xsl:call-template name="DeclareElementAsClass">
					<xsl:with-param name="fullName" select="$strippedAppName"/>
					<xsl:with-param name="displayName" select="$appName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="type = 'Composite_Application_Provider'">
				<xsl:call-template name="DeclareElementAsPackage">
					<xsl:with-param name="fullName" select="$strippedAppName"/>
					<xsl:with-param name="displayName" select="$appName"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render an Application as a UML Class -->
	<xsl:template match="node()" mode="RenderUndefinedLocationApplication">
		<xsl:param name="locationName"/>
		<xsl:variable name="appName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="strippedAppName" select="translate($appName, translate($appName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:choose>
			<xsl:when test="type = 'Application_Provider'">
				<xsl:call-template name="DeclareElementAsClass">
					<xsl:with-param name="fullName" select="$strippedAppName"/>
					<xsl:with-param name="displayName" select="$appName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="type = 'Composite_Application_Provider'">
				<xsl:call-template name="DeclareElementAsPackage">
					<xsl:with-param name="fullName" select="$strippedAppName"/>
					<xsl:with-param name="displayName" select="$appName"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a Data Object as a UML Class where the given application is a data source, but the data is not explicitly captrued as being managed by the application -->
	<xsl:template match="node()" mode="RenderSourcedApplication">
		<xsl:param name="locationName"/>
		<xsl:param name="currentApps"/>
		<!--<xsl:variable name="anApp" select="$allDataObjects[name=current()/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value]"/>
		
		<xsl:if test="not (functx:is-node-in-sequence($dataObject,$currentDataObjects))">
			<xsl:variable name="dataObjectName" select="$dataObject/own_slot_value[slot_reference='name']/value"/>
			<xsl:variable name="fullSourceObjectName" select="concat($appName, $dataObjectName)"/>
			<xsl:variable name="strippedSourceObjectName" select="translate($fullSourceObjectName, ' ', '')"/>
			
			<xsl:call-template name="DeclareDataObject">
				<xsl:with-param name="fullName" select="$strippedSourceObjectName"/>
				<xsl:with-param name="displayName" select="$dataObjectName"/>
			</xsl:call-template>
		</xsl:if>-->
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the formatting for all Data Objects being displayed -->
	<xsl:template match="node()" mode="RenderAllAppsFormatting">
		<xsl:variable name="locationName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="physProcsAtLocation" select="$allPhysProcs[own_slot_value[slot_reference = 'process_performed_at_sites']/value = current()/name]"/>
		<xsl:variable name="physProcs2AppRoles" select="$allPhysProc2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsAtLocation/name]"/>
		<xsl:variable name="appRoles" select="$allAppRoles[name = $physProcs2AppRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="apps" select="$allAppProviders[name = $appRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:apply-templates mode="RenderAppFormat" select="$apps[type = 'Application_Provider']">
			<xsl:with-param name="locationName" select="$locationName"/>
		</xsl:apply-templates>&#10;&#10; <!--<xsl:apply-templates mode="FormatSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
		</xsl:apply-templates>-->
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the formatting for all Data Objects being displayed -->
	<xsl:template name="RenderUndefinedLocationAppsFormatting">
		<xsl:param name="apps"/>
		<xsl:apply-templates mode="RenderAppFormat" select="$apps[type = 'Application_Provider']"> </xsl:apply-templates>&#10;&#10; <!--<xsl:apply-templates mode="FormatSourcedDataObject" select="$sourceAppPro2Info2DataReps">
			<xsl:with-param name="appName" select="$packageName"/>
			<xsl:with-param name="currentDataObjects" select="$currentDataObjects"/>
			</xsl:apply-templates>-->
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the format for an Application -->
	<xsl:template match="node()" mode="RenderAppFormat">
		<xsl:param name="locationName"/>

		<xsl:variable name="appDeliveryModel" select="$allDeliveryModels[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>

		<xsl:variable name="appName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="fullAppName" select="concat($locationName, $appName)"/>
		<xsl:variable name="strippedAppName" select="translate($fullAppName, translate($fullAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:choose>
			<xsl:when test="(count($appDeliveryModel) = 0) or ($appDeliveryModel/name = $onSiteDeliveryModel/name)">
				<xsl:call-template name="RenderInternalAppFormat">
					<xsl:with-param name="appName" select="$strippedAppName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderExternalAppFormat">
					<xsl:with-param name="appName" select="$strippedAppName"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render the format for an internally deployed application-->
	<xsl:template name="RenderInternalAppFormat">
		<xsl:param name="appName"/>
		<xsl:value-of select="$appName"/> &lt;&lt; (I,#f8a85c) >>&#10; </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the format for an externally deployed application-->
	<xsl:template name="RenderExternalAppFormat">
		<xsl:param name="appName"/>
		<xsl:value-of select="$appName"/> &lt;&lt; (E,#6593c8) >>&#10; </xsl:template>




	<!-- 11.08.2011 JP -->
	<!-- Declare an Element as a Class within a package -->
	<xsl:template name="DeclareElementAsClass">
		<xsl:param name="fullName"/>
		<xsl:param name="displayName"/> class <xsl:value-of select="$fullName"/> as "<xsl:value-of select="$displayName"/>" &#10; </xsl:template>

	<!-- 11.08.2011 JP -->
	<!-- Declare an Element as a Package within a package -->
	<xsl:template name="DeclareElementAsPackage">
		<xsl:param name="fullName"/>
		<xsl:param name="displayName"/> package "<xsl:value-of select="$displayName"/>" </xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render the application dependencies -->
	<xsl:template match="node()" mode="RenderLinksForApp">
		<xsl:variable name="appUsages" select="$allDependentAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = current()/name]"/>
		<xsl:variable name="appDependencyLinks" select="$allDependentRelations[own_slot_value[slot_reference = ':FROM']/value = $appUsages/name]"/>

		<xsl:variable name="currentApp" select="current()"/>

		<xsl:apply-templates mode="RenderAppDependency" select="$appDependencyLinks">
			<xsl:with-param name="sourceApp" select="$currentApp"/>
			<xsl:with-param name="sourceAppName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an application dependency - expects an :APU-TO-APU-STATIC-RELATION -->
	<xsl:template match="node()" mode="RenderAppDependency">
		<xsl:param name="sourceApp"/>
		<xsl:param name="sourceAppName"/>

		<xsl:variable name="dependentAppUsages" select="$allDependentAppUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="dependentApps" select="$allAppProviders[name = $dependentAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		<xsl:variable name="sourceAppSites" select="eas:getLocationsForApp($sourceApp)"/>
		<xsl:variable name="interfaceName" select="current()/own_slot_value[slot_reference = ':relation_label']/value"/>


		<xsl:for-each select="$sourceAppSites">
			<xsl:variable name="sourceLocationName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="fullSourceAppName" select="concat($sourceLocationName, $sourceAppName)"/>
			<xsl:variable name="strippedSourceAppName" select="translate($fullSourceAppName, translate($fullSourceAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

			<xsl:for-each select="$dependentApps[not(name = preceding-sibling::name)]">
				<xsl:variable name="dependentAppName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="dependentAppSites" select="eas:getLocationsForApp(current())"/>

				<xsl:choose>
					<xsl:when test="count($dependentAppSites) > 0">
						<xsl:for-each select="$dependentAppSites">
							<xsl:variable name="dependentLocationName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="fullDependentAppName" select="concat($dependentLocationName, $dependentAppName)"/>
							<xsl:variable name="strippedDependentAppName" select="translate($fullDependentAppName, translate($fullDependentAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

							<xsl:call-template name="AssociateApplications">
								<xsl:with-param name="sourceAppName" select="$strippedSourceAppName"/>
								<xsl:with-param name="targetAppName" select="$strippedDependentAppName"/>
								<xsl:with-param name="interfaceName" select="$interfaceName"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="dependentLocationName" select="$unknownLocationName"/>
						<xsl:variable name="fullDependentAppName" select="concat($dependentLocationName, $dependentAppName)"/>
						<xsl:variable name="strippedDependentAppName" select="translate($dependentAppName, translate($dependentAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

						<xsl:call-template name="AssociateApplications">
							<xsl:with-param name="sourceAppName" select="$strippedSourceAppName"/>
							<xsl:with-param name="targetAppName" select="$strippedDependentAppName"/>
							<xsl:with-param name="interfaceName" select="$interfaceName"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>

		</xsl:for-each>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render the application dependencies -->
	<xsl:template match="node()" mode="RenderLinksForUnknownLocationApp">
		<xsl:variable name="appUsages" select="$allDependentAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = current()/name]"/>
		<xsl:variable name="appDependencyLinks" select="$allDependentRelations[own_slot_value[slot_reference = ':FROM']/value = $appUsages/name]"/>

		<xsl:variable name="currentApp" select="current()"/>

		<xsl:apply-templates mode="RenderUnknownLocationAppDependency" select="$appDependencyLinks">
			<xsl:with-param name="sourceApp" select="$currentApp"/>
			<xsl:with-param name="sourceAppName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:apply-templates>

	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render an application dependency - expects an :APU-TO-APU-STATIC-RELATION -->
	<xsl:template match="node()" mode="RenderUnknownLocationAppDependency">
		<xsl:param name="sourceApp"/>
		<xsl:param name="sourceAppName"/>

		<xsl:variable name="dependentAppUsages" select="$allDependentAppUsages[name = current()/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="dependentApps" select="$allAppProviders[name = $dependentAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
		<xsl:variable name="interfaceName" select="current()/own_slot_value[slot_reference = ':relation_label']/value"/>

		<xsl:variable name="fullSourceAppName" select="concat($unknownLocationName, $sourceAppName)"/>
		<xsl:variable name="strippedSourceAppName" select="translate($sourceAppName, translate($sourceAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

		<xsl:for-each select="$dependentApps[not(name = preceding-sibling::name)]">
			<xsl:variable name="dependentAppName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="dependentAppSites" select="eas:getLocationsForApp(current())"/>

			<xsl:choose>
				<xsl:when test="count($dependentAppSites) > 0">
					<xsl:for-each select="$dependentAppSites">
						<xsl:variable name="dependentLocationName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="fullDependentAppName" select="concat($dependentLocationName, $dependentAppName)"/>
						<xsl:variable name="strippedDependentAppName" select="translate($fullDependentAppName, translate($fullDependentAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

						<xsl:call-template name="AssociateApplications">
							<xsl:with-param name="sourceAppName" select="$strippedSourceAppName"/>
							<xsl:with-param name="targetAppName" select="$strippedDependentAppName"/>
							<xsl:with-param name="interfaceName" select="$interfaceName"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="fullDependentAppName" select="concat($unknownLocationName, $dependentAppName)"/>
					<xsl:variable name="strippedDependentAppName" select="translate($dependentAppName, translate($dependentAppName, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>

					<xsl:call-template name="AssociateApplications">
						<xsl:with-param name="sourceAppName" select="$strippedSourceAppName"/>
						<xsl:with-param name="targetAppName" select="$strippedDependentAppName"/>
						<xsl:with-param name="interfaceName" select="$interfaceName"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Associate two Applications within or across Packages-->
	<xsl:template name="AssociateApplications">
		<xsl:param name="sourceAppName"/>
		<xsl:param name="targetAppName"/>
		<xsl:param name="interfaceName"/> &#10;"<xsl:value-of select="$sourceAppName"/>" --> <xsl:value-of select="$targetAppName"/><!--<xsl:if test="string-length($interfaceName) > 0"><xsl:text> : </xsl:text><xsl:value-of select="$interfaceName"></xsl:value-of></xsl:if>--><xsl:text>&#10;</xsl:text>
	</xsl:template>



	<xsl:function name="eas:appHasLocation">
		<xsl:param name="app"/>
		<xsl:variable name="appRoles" select="$allAppRoles[name = $app/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
		<xsl:variable name="appPhysProc2Apps" select="$allPhysProc2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $appRoles/name]"/>
		<xsl:variable name="appPhysProcs" select="$allPhysProcs[name = $appPhysProc2Apps/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="appSites" select="$allSites[name = $appPhysProcs/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
		<xsl:choose>
			<!--<xsl:when test="count($appRoles) = 0"><xsl:value-of select="'false'"/></xsl:when>
			<xsl:when test="count($appPhysProc2Apps) = 0"><xsl:value-of select="'false'"/></xsl:when>
			<xsl:when test="count($appPhysProcs) = 0"><xsl:value-of select="'false'"/></xsl:when>-->
			<xsl:when test="count($appSites) > 0">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<xsl:function name="eas:getLocationsForApp" as="node()*">
		<xsl:param name="app"/>
		<xsl:variable name="appRoles" select="$allAppRoles[name = $app/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
		<xsl:variable name="appPhysProc2Apps" select="$allPhysProc2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $appRoles/name]"/>
		<xsl:variable name="appPhysProcs" select="$allPhysProcs[name = $appPhysProc2Apps/own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value]"/>
		<xsl:variable name="appSites" select="$allSites[name = $appPhysProcs/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
		<xsl:copy-of select="$appSites"/>
	</xsl:function>

</xsl:stylesheet>
