<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:include href="../common/core_uml_model_links.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<xsl:param name="param1"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- param2 = the path of the dynamically generated UML model -->
	<xsl:param name="param2"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<xsl:param name="imageFilename"/>
	<xsl:param name="imageMapPath"/>

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider', 'Data_Object')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="modelSubject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="modelSubjectName" select="$modelSubject/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="allAppProviders" select="/node()/simple_instance[((type = 'Application_Provider') or (type = 'Composite_Application_Provider'))]"/>
	<xsl:variable name="allAppPro2InfoReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $allAppProviders/name]"/>
	<xsl:variable name="allAppPro2Info2DataReps" select="/node()/simple_instance[name = $allAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
	<xsl:variable name="allDataObjects" select="/node()/simple_instance[(type = 'Data_Object')]"/>
	<xsl:variable name="allDataReps" select="/node()/simple_instance[(type = 'Data_Representation')]"/>
	<xsl:variable name="allAcquisitonMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>

	<!--<xsl:variable name="selectedAppProvider" select="$allAppProviders[name=$param1]"/>-->
	<xsl:variable name="selectedAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $modelSubject/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
	<xsl:variable name="selectedAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[name = $selectedAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
	<xsl:variable name="selectedDataReps" select="$allDataReps[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
	<xsl:variable name="selectedRepDataObjects" select="$allDataObjects[name = $selectedDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value]"/>
	<xsl:variable name="actualSelectedDataObjects" select="$allDataObjects[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>
	<xsl:variable name="inScopeDataObjects" select="$selectedRepDataObjects union actualSelectedDataObjects"/>
	<xsl:variable name="selectedSourceAppPro2InfoReps" select="$allAppPro2InfoReps[name = $selectedAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"/>
	<xsl:variable name="selectedSourceApps" select="$allAppProviders[name = $selectedSourceAppPro2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
	<xsl:variable name="inScopeApps" select="$modelSubject union $selectedSourceApps"/>

	<xsl:variable name="pageTitle" select="concat(' - ', $modelSubjectName)"/>

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


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Application Data Dependencies')"/>
					<xsl:value-of select="$pageTitle"/>
				</title>
				<script type="text/javascript" src="js/jquery.zoomable.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>


				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<xsl:variable name="modelSubjectDesc" select="$modelSubject/own_slot_value[slot_reference = 'description']/value"/>

				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Application Data Dependencies')"/>
										<xsl:value-of select="$pageTitle"/>
									</span>
								</h1>
							</div>
						</div>


						<!--Setup UML Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Model')"/>
							</h2>
							<div id="keyContainer">
								<div class="keyLabel"><xsl:value-of select="eas:i18n('Key')"/>:</div>
								<div class="keySample cellRAG_Red"/>
								<div class="keySampleLabel">
									<xsl:value-of select="eas:i18n('Manual')"/>
								</div>
								<div class="keySample cellRAG_Yellow"/>
								<div class="keySampleLabel">
									<xsl:value-of select="eas:i18n('Automated')"/>
								</div>
								<div class="keySample cellRAG_Grey"/>
								<div class="keySampleLabel">
									<xsl:value-of select="eas:i18n('Unknown')"/>
								</div>
							</div>


							<!--script to support vertical alignment within named divs - requires jquery and verticalalign plugin-->
							<script type="text/javascript">
										$('document').ready(function(){
											 $(".umlCircleBadge").vAlign();
											 $(".umlCircleBadgeDescription").vAlign();
											 $(".umlKeyTitle").vAlign();
										});
									</script>

							<div class="uml_key_container"/>

							<!--script required to zoom and drag images whilst scaling image maps-->
							<script type="text/javascript">
										$('document').ready(function(){
											$('.umlImage').zoomable();
										});
									</script>
							<div class="umlZoomContainer pull-right">
								<input type="button" value="Zoom In" onclick="$('#image').zoomable('zoomIn')" title="Zoom in"/>
								<input type="button" value="Zoom Out" onclick="$('#image').zoomable('zoomOut')" title="Zoom out"/>
								<input type="button" value="Reset" onclick="$('#image').zoomable('reset')"/>
							</div>
							<div class="clear"/>
							<div class="verticalSpacer_10px"/>
							<div class="umlModelViewport">
								<img class="umlImage" src="{$imageFilename}" usemap="#unix" id="image" alt="UML Model"/>

								<xsl:variable name="imageMapFile" select="concat('../', $imageMapPath)"/>
								<xsl:if test="unparsed-text-available($imageMapFile)">
									<xsl:value-of select="unparsed-text($imageMapFile)" disable-output-escaping="yes"/>
								</xsl:if>
							</div>

							<hr/>
						</div>


						<!--Setup Description Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Applications')"/>
							</h2>

							<xsl:apply-templates mode="RenderApplicationTable" select="$modelSubject">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
							<xsl:apply-templates mode="RenderSourceApplicationTable" select="$selectedSourceApps except $modelSubject">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
							<hr/>
						</div>


						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<!-- Render a table containing the types of data being managed by a given application -->
	<xsl:template match="node()" mode="RenderApplicationTable">
		<xsl:variable name="thisApp" select="current()"/>
		<!--<xsl:variable name="appName" select="own_slot_value[slot_reference='name']/value"/>-->
		<!--<xsl:variable name="packageName" select="own_slot_value[slot_reference='name']/value"/>-->
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $thisApp/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>
		<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference = 'operated_data_reps']/value)]"/>
		<xsl:variable name="currentDataReps" select="$allDataReps[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>




		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<!--<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference='app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference='app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		-->
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<xsl:choose>
			<xsl:when test="count($currentDataObjects) = 0">
				<div class="content-section">
					<p>
						<em><xsl:value-of select="eas:i18n('No data elements managed by')"/>&#160;<xsl:value-of select="$modelSubjectName"/></em>
					</p>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<p><xsl:value-of select="eas:i18n('The following tables provides details of the data elements managed by')"/>&#160;<xsl:value-of select="$modelSubjectName"/>&#160;<xsl:value-of select="eas:i18n('as well as the applications from where this data is sourced.')"/></p>
				<h3>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$thisApp"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass" select="'text-secondary'"/>
					</xsl:call-template>

				</h3>
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th class="cellWidth-15pc">
								<xsl:value-of select="eas:i18n('Data Object')"/>
							</th>
							<th class="cellWidth-40pc">
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
							<th class="cellWidth-20pc">
								<xsl:value-of select="eas:i18n('Source')"/>
							</th>
							<th class="cellWidth-25pc">
								<xsl:value-of select="eas:i18n('Input Method')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates mode="RenderDataRow" select="$currentDataObjects">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:with-param name="thisApp2InfoRep" select="$currentAppPro2InfoReps"/>
						</xsl:apply-templates>
					</tbody>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- Render a table containing the types of data being managed by a given application -->
	<xsl:template match="node()" mode="RenderSourceApplicationTable">
		<!--<xsl:param name="targetApp2Info2DataReps"/>-->

		<xsl:variable name="thisApp" select="current()"/>
		<!--<xsl:variable name="appName" select="own_slot_value[slot_reference='name']/value"/>-->
		<!--<xsl:variable name="packageName" select="own_slot_value[slot_reference='name']/value"/>-->
		<xsl:variable name="currentAppPro2InfoReps" select="$allAppPro2InfoReps[(own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $thisApp/name) and (own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true')]"/>

		<xsl:variable name="myApp2InfoReps" select="$allAppPro2InfoReps[own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value = $thisApp/name]"/>
		<xsl:variable name="myTargetApp2Info2DataReps" select="$selectedAppPro2Info2DataReps[own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = $myApp2InfoReps/name]"/>
		<xsl:variable name="myDefinedDataReps" select="$allDataReps[name = $myTargetApp2Info2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>


		<!--<xsl:variable name="currentAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(name = $currentAppPro2InfoReps/own_slot_value[slot_reference='operated_data_reps']/value)]"/>
		<xsl:variable name="currentDataReps" select="$allDataReps[name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		-->



		<!-- Get all AppPro2InfoRep2DataReps where the current Application is the source -->
		<!--<xsl:variable name="sourceAppPro2Info2DataReps" select="$allAppPro2Info2DataReps[(own_slot_value[slot_reference='app_datarep_inforep_source']/value = $currentAppPro2InfoReps/name) and (own_slot_value[slot_reference='app_pro_use_of_data_rep']/value = $allDataObjects/name)]"/>
		-->
		<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $myTargetApp2Info2DataReps/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value) or (name = $myDefinedDataReps/own_slot_value[slot_reference = 'implemented_data_object']/value)]"/>
		<!--<xsl:variable name="currentDataObjects" select="$allDataObjects[(name = $currentAppPro2Info2DataReps/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value) or (name = $currentDataReps/own_slot_value[slot_reference='implemented_data_object']/value)]"/>
		-->

		<h3>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$thisApp"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="anchorClass" select="'text-secondary'"/>
			</xsl:call-template>

		</h3>
		<table class="table table-bordered table-striped">
			<thead>
				<tr>
					<th class="cellWidth-15pc">
						<xsl:value-of select="eas:i18n('Data Object')"/>
					</th>
					<th class="cellWidth-40pc">
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Source')"/>
					</th>
					<th class="cellWidth-25pc">
						<xsl:value-of select="eas:i18n('Input Method')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="RenderDataRow" select="$currentDataObjects">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:with-param name="thisApp2InfoRep" select="$currentAppPro2InfoReps"/>
				</xsl:apply-templates>
			</tbody>
		</table>
		<br/>
	</xsl:template>



	<!-- Render a row of data being managed by a given application (for DataObjects)-->
	<xsl:template match="node()" mode="RenderDataRow">
		<xsl:param name="thisApp2InfoRep"/>

		<xsl:variable name="thisDataObject" select="current()"/>
		<xsl:variable name="thisAppPro2InfoRep2DataReps" select="$allAppPro2Info2DataReps[name = $thisApp2InfoRep/own_slot_value[slot_reference = 'operated_data_reps']/value]"/>
		<xsl:variable name="usedAppPro2InfoRep2DataReps" select="thisAppPro2InfoRep2DataReps[own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value = $thisDataObject/name]"/>
		<xsl:variable name="thisDataReps" select="$allDataReps[name = $thisAppPro2InfoRep2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="relevantDataReps" select="$thisDataReps[own_slot_value[slot_reference = 'implemented_data_object']/value = $thisDataObject/name]"/>
		<xsl:variable name="definedAppPro2InfoRep2DataReps" select="$thisAppPro2InfoRep2DataReps[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value = $relevantDataReps/name]"/>
		<xsl:variable name="inScopeAppPro2InfoRep2DataReps" select="$definedAppPro2InfoRep2DataReps union $usedAppPro2InfoRep2DataReps"/>

		<!--<xsl:variable name="thisDataReps" select="$allDataReps[name = $thisAppPro2InfoRep2DataReps/own_slot_value[slot_reference='apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="repDataObject" select="$allDataObjects[name=$dataRep/own_slot_value[slot_reference='implemented_data_object']/value]"/>
		<xsl:variable name="actualDataObject" select="$allDataObjects[name=current()/own_slot_value[slot_reference='app_pro_use_of_data_rep']/value]"/>-->
		<xsl:variable name="acquisitionMethods" select="$allAcquisitonMethods[name = $inScopeAppPro2InfoRep2DataReps/own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value]"/>
		<xsl:variable name="sourceApp2InfoReps" select="$allAppPro2InfoReps[name = $inScopeAppPro2InfoRep2DataReps/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"/>
		<xsl:variable name="sourceApps" select="$allAppProviders[name = $sourceApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>

		<!--<xsl:variable name="dataName" select="$dataObject/own_slot_value[slot_reference='name']/value"/>-->
		<xsl:call-template name="RenderOnlyDataRow">
			<xsl:with-param name="sourceApps" select="$sourceApps"/>
			<xsl:with-param name="acquisitionMethods" select="$acquisitionMethods"/>
			<xsl:with-param name="dataObject" select="$thisDataObject"/>
		</xsl:call-template>

	</xsl:template>


	<!-- Render a row of data for which the given application is a source (for AppPro2InfoRep2DataRep)-->
	<xsl:template name="RenderOnlyDataRow">
		<xsl:param name="dataObject"/>
		<xsl:param name="sourceApps"/>
		<xsl:param name="acquisitionMethods"/>

		<xsl:variable name="dataDesc" select="$dataObject/own_slot_value[slot_reference = 'description']/value"/>

		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$dataObject"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<!--<a>
					<xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=information/data_object_summary.xsl&amp;PMA=</xsl:text><xsl:value-of select="$dataObject/name"/>
					<xsl:text>&amp;LABEL=Data Object Summary - </xsl:text><xsl:value-of select="$dataName"/>
					</xsl:attribute>
					<xsl:value-of select="$dataName"/>
					</a>-->
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($dataDesc) > 0">
						<!--<xsl:value-of select="$dataDesc"/>-->
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$dataObject"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($sourceApps) > 0">
						<ul>
							<xsl:for-each select="$sourceApps">
								<xsl:sort select="/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="sourceAppName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($acquisitionMethods) > 0">
						<ul>
							<xsl:for-each select="$acquisitionMethods">
								<xsl:sort select="/own_slot_value[slot_reference = 'name']/value"/>
								<li>
									<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

	</xsl:template>


	<!-- Render a row of data being managed by a given application (for AppPro2InfoRep2DataRep)-->
	<xsl:template match="node()" mode="RenderDataRowOLD">
		<xsl:variable name="dataRep" select="$allDataReps[name = current()/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value]"/>
		<xsl:variable name="repDataObject" select="$allDataObjects[name = $dataRep/own_slot_value[slot_reference = 'implemented_data_object']/value]"/>
		<xsl:variable name="actualDataObject" select="$allDataObjects[name = current()/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>
		<xsl:variable name="acquisitionMethod" select="$allAcquisitonMethods[name = current()/own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value]"/>
		<xsl:variable name="sourceApp2InfoRep" select="$allAppPro2InfoReps[name = current()/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"/>
		<xsl:variable name="sourceApp" select="$allAppProviders[name = $sourceApp2InfoRep/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>

		<!--<xsl:variable name="dataName" select="$dataObject/own_slot_value[slot_reference='name']/value"/>-->
		<!--<xsl:choose>
			<xsl:when test="count($actualDataObject) > 0">
				<xsl:call-template name="RenderOnlyDataRow">
					<xsl:with-param name="sourceApp" select="$sourceApp"/>
					<xsl:with-param name="acquisitionMethod" select="$acquisitionMethod"/>
					<xsl:with-param name="dataObject" select="$actualDataObject"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="RenderOnlyDataRow">
					<xsl:with-param name="sourceApp" select="$sourceApp"/>
					<xsl:with-param name="acquisitionMethod" select="$acquisitionMethod"/>
					<xsl:with-param name="dataObject" select="$repDataObject"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>-->

	</xsl:template>


	<!-- Render a row of data for which the given application is a source (for AppPro2InfoRep2DataRep)-->
	<xsl:template name="RenderOnlyDataRowOLD">
		<xsl:param name="dataObject"/>
		<xsl:param name="sourceApp"/>
		<xsl:param name="acquisitionMethod"/>

		<xsl:variable name="dataDesc" select="$dataObject/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="acquisitionMethodName" select="$acquisitionMethod/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="sourceAppName" select="$sourceApp/own_slot_value[slot_reference = 'name']/value"/>

		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$dataObject"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
				<!--<a>
					<xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=information/data_object_summary.xsl&amp;PMA=</xsl:text><xsl:value-of select="$dataObject/name"/>
					<xsl:text>&amp;LABEL=Data Object Summary - </xsl:text><xsl:value-of select="$dataName"/>
					</xsl:attribute>
					<xsl:value-of select="$dataName"/>
					</a>-->
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($dataDesc) > 0">
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$dataObject"/>
						</xsl:call-template>

					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($sourceAppName) > 0">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$sourceApp"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($acquisitionMethodName) > 0">
						<xsl:value-of select="$acquisitionMethodName"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

	</xsl:template>


	<!-- Render a row of data for which the given application is a source (for AppPro2InfoRep2DataRep)-->
	<xsl:template match="node()" mode="RenderSourcedDataRow">
		<xsl:param name="knownDataObjects"/>
		<xsl:variable name="dataObject" select="$allDataObjects[name = current()/own_slot_value[slot_reference = 'app_pro_use_of_data_rep']/value]"/>

		<xsl:if test="not(functx:is-node-in-sequence($dataObject, $knownDataObjects))">
			<!--<xsl:variable name="dataName" select="$dataObject/own_slot_value[slot_reference='name']/value"/>-->
			<xsl:variable name="dataDesc" select="$dataObject/own_slot_value[slot_reference = 'description']/value"/>

			<tr>
				<td>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$dataObject"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
					<!--<a>
						<xsl:attribute name="href"><xsl:text>report?XML=reportXML.xml&amp;XSL=information/data_object_summary.xsl&amp;PMA=</xsl:text><xsl:value-of select="$dataObject/name"/>
							<xsl:text>&amp;LABEL=Data Object Summary - </xsl:text><xsl:value-of select="$dataName"/>
						</xsl:attribute>
						<xsl:value-of select="$dataName"/>
					</a>-->
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="string-length($dataDesc) > 0">
							<!--<xsl:value-of select="$dataDesc"/>-->
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="$dataObject"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>-</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:text>-</xsl:text>
				</td>
				<td>
					<xsl:value-of select="eas:i18n('Unknown')"/>
				</td>
			</tr>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
