<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentDataObject" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="dataObjectName" select="$currentDataObject/own_slot_value[slot_reference = 'name']/value"/>


	<xsl:variable name="dataReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'implemented_data_object']/value = $currentDataObject/name]"/>
	<xsl:variable name="app2InfoRep2DataReps" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_to_datarep']/value = $dataReps/name]"/>
	<xsl:variable name="sourceApp2InfoReps" select="/node()/simple_instance[name = $app2InfoRep2DataReps/own_slot_value[slot_reference = 'app_datarep_inforep_source']/value]"/>


	<xsl:variable name="allApps" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="sysOfRecord" select="$allApps[name = $currentDataObject/own_slot_value[slot_reference = 'data_object_system_of_record']/value]"/>
	<xsl:variable name="allAcquisitionMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="manualEntryAcqMethod" select="$allAcquisitionMethods[own_slot_value[slot_reference = 'name']/value = 'Manual Data Entry']"/>
	<xsl:variable name="manualEntryApp2InfoRep2DataReps" select="$app2InfoRep2DataReps[(own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value = $manualEntryAcqMethod/name) and (count(own_slot_value[slot_reference = 'app_datarep_inforep_source']/value) = 0)]"/>

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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 12.06.2013 JWC	Extended to support composite applications -->
	<!-- 13.06.2013 JWC Tweaks to the rendering of the dependencies -->
	<!-- 14.06.2013 JWC Make the source apps aware of composites -->

	<xsl:variable name="DEBUG" select="''"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title><xsl:value-of select="eas:i18n('Data Provider Model for')"/>&#160;<xsl:value-of select="$dataObjectName"/></title>

				<script src="js/setequalheights.js?release=6.19" type="text/javascript"/>

				<script type="text/javascript">
					function divHeightOutbound() {
						// Loop through all the div.dependencyModel_Inbound on the page
						$('.dependencyModel_Outbound,.dependencyModel_Outbound_Empty').each(function(){
						    // Get their parent td's height
						    var tdHeight = [$(this).closest('td').height()];
						
						    // Set the div's height to their parent td's height
						    $(this).height(tdHeight);
						});
					}
					function divHeightInbound() {
						// Loop through all the div.dependencyModel_Inbound on the page
						$('.dependencyModel_Inbound,.dependencyModel_Inbound_Empty').each(function(){
						    // Get their parent td's height
						    var tdHeight = [$(this).closest('td').height()]-15;
						
						    // Set the div's height to their parent td's height
						    $(this).height(tdHeight);
						});
					}
					
					$(document).ready(function() {
						   divHeightOutbound();
						   divHeightInbound();
						});

				</script>

				<script>
					function setEqualHeight(columns)  
					 {  
					 var tallestcolumn = 0;  
					 columns.each(  
					 function()  
					 {  
					 currentHeight = $(this).height();  
					 if(currentHeight > tallestcolumn)  
					 {  
					 tallestcolumn  = currentHeight;  
					 }  
					 }  
					 );  
					 columns.height(tallestcolumn);  
					 }  
					$(document).ready(function() {  
					 setEqualHeight($("#dependencyModel_LeftContainer,#dependencyModel_RightContainer,.dependencyModel_Hub"));
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
						 $(".providerModelKeyLabel").vAlign();
						 $(".providerModelKeyContent").vAlign();
						 $(".dependencyModel_Outbound").vAlign();	
						 $(".dependencyModel_Inbound").vAlign();	
					});
				</script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Data Provider Model for')"/>&#160;</span>
								<span class="text-primary">
									<xsl:value-of select="$dataObjectName"/>
								</span>
							</h1>
						</div>

						<!--Setup Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Provider Model')"/>
							</h2>
							<xsl:choose>
								<xsl:when test="count($sourceApp2InfoReps union $manualEntryApp2InfoRep2DataReps) > 0">
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('Where is the Data Object')"/>&#160;<xsl:value-of select="$dataObjectName"/>&#160;<xsl:value-of select="eas:i18n('consumed and sourced')"/>?</p>
										<xsl:apply-templates select="$currentDataObject" mode="model"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('No data integrations defined for')"/>&#160;<em><xsl:value-of select="$dataObjectName"/></em></p>
									</div>
								</xsl:otherwise>
							</xsl:choose>
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

	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="model">

		<div class="keyLabel fontBlack text-primary small"><xsl:value-of select="eas:i18n('Legend')"/>:</div>
		<div class="keySample ragTextGreen"/>
		<div class="keySampleLabel fontBlack small text-darkgrey">
			<xsl:value-of select="eas:i18n('Designated System of Record')"/>
		</div>
		<div class="keySample backColourRed"/>
		<div class="keySampleLabel fontBlack small text-darkgrey">
			<xsl:value-of select="eas:i18n('Not System of Record')"/>
		</div>
		<div class="keySample ragTextYellow"/>
		<div class="keySampleLabel fontBlack small text-darkgrey">
			<xsl:value-of select="eas:i18n('System of Record Undefined')"/>
		</div>
		<div class="keySample backColour3"/>
		<div class="keySampleLabel fontBlack small text-darkgrey">
			<xsl:value-of select="eas:i18n('Destination')"/>
		</div>

		<table class="col-xs-12">
			<tbody>
				<!--setup the headers for the digram-->
				<tr>
					<td class="providerModelHeader col-xs-3">
						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Source')"/>
						</h3>
					</td>
					<td class="providerModelHeaderBlank col-xs-6">&#160;</td>
					<td class="providerModelHeader col-xs-3">
						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Destination')"/>
						</h3>
					</td>
				</tr>
			</tbody>
		</table>

		<table class="providerModel">
			<tbody>
				<xsl:for-each select="$sourceApp2InfoReps">
					<xsl:variable name="sourceApp" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = current()/name]"/>
					<xsl:variable name="sourceAppName" select="$sourceApp/own_slot_value[slot_reference = 'name']/value"/>
					<xsl:variable name="consumingApp2DataReps" select="$app2InfoRep2DataReps[own_slot_value[slot_reference = 'app_datarep_inforep_source']/value = current()/name]"/>
					<xsl:variable name="allConsumingApp2InfoReps" select="/node()/simple_instance[name = $consumingApp2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value]"/>
					<xsl:variable name="persistConsumingApp2InfoReps" select="$allConsumingApp2InfoReps[own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true']"/>
					<xsl:variable name="persistConsumingApps" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $persistConsumingApp2InfoReps/name]"/>
					<xsl:variable name="persistApp2DataReps" select="$consumingApp2DataReps[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value = $persistConsumingApp2InfoReps/name]"/>


					<xsl:for-each select="$persistConsumingApps">
						<xsl:variable name="consumingApp" select="current()"/>
						<xsl:variable name="currentConsumingApp2InfoReps" select="$persistConsumingApp2InfoReps[name = current()/own_slot_value[slot_reference = 'uses_information_representation']/value]"/>
						<xsl:variable name="currentConsumingApp2Info2DataReps" select="$persistApp2DataReps[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value = $currentConsumingApp2InfoReps/name]"/>
						<!-- hack to stop wrapping of tables -->
						<xsl:if test="position() = 1">
							<tr>
								<td colspan="3"/>
							</tr>
							<tr>
								<td colspan="3"/>
							</tr>
							<tr>
								<td colspan="3"/>
							</tr>
							<tr>
								<td colspan="3"/>
							</tr>
						</xsl:if>

						<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
						<xsl:if test="position() = 1">
							<td class="col-xs-3">
								<xsl:attribute name="rowspan">
									<xsl:value-of select="count($persistApp2DataReps)"/>
								</xsl:attribute>
								<xsl:variable name="divClassEntries">
									<xsl:choose>
										<xsl:when test="count($sysOfRecord) > 0">
											<xsl:choose>
												<xsl:when test="$sourceApp/name = $sysOfRecord/name">dependencyModel_Inbound backColourGreen text-white</xsl:when>
												<xsl:otherwise>dependencyModel_Inbound backColourRed text-white</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>dependencyModel_Inbound backColourYellow text-white</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<strong>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$sourceApp"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="divClass" select="$divClassEntries"/>
										<xsl:with-param name="anchorClass" select="'noUL'"/>
									</xsl:call-template>
								</strong>
							</td>
						</xsl:if>

						<xsl:for-each select="$currentConsumingApp2Info2DataReps">
							<xsl:variable name="currentApp2DDataRepoPos" select="position()"/>
							<xsl:variable name="acquisitionMethod" select="$allAcquisitionMethods[name = current()/own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value]"/>
							<xsl:variable name="acquisitionMethodName" select="$acquisitionMethod/own_slot_value[slot_reference = 'name']/value"/>

							<td class="col-xs-6">
								<div class="providerModelArrowL2R small">
									<em>
										<xsl:value-of select="$dataObjectName"/>
										<xsl:text> (</xsl:text>
										<xsl:value-of select="$acquisitionMethodName"/>
										<xsl:text>)</xsl:text>
									</em>
								</div>
							</td>

							<xsl:if test="$currentApp2DDataRepoPos = 1">
								<td class="col-xs-6">
									<xsl:attribute name="rowspan">
										<xsl:value-of select="count($currentConsumingApp2Info2DataReps)"/>
									</xsl:attribute>
									<strong>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$consumingApp"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="divClass" select="'dependencyModel_Inbound backColour3 text-white'"/>
											<xsl:with-param name="anchorClass" select="'noUL'"/>
										</xsl:call-template>
									</strong>
								</td>
							</xsl:if>
							<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:variable name="allConsumingApp2InfoReps" select="/node()/simple_instance[name = $manualEntryApp2InfoRep2DataReps/own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value]"/>
				<xsl:variable name="persistConsumingApp2InfoReps" select="$allConsumingApp2InfoReps[own_slot_value[slot_reference = 'app_pro_persists_info_rep']/value = 'true']"/>
				<xsl:variable name="persistConsumingApps" select="$allApps[own_slot_value[slot_reference = 'uses_information_representation']/value = $persistConsumingApp2InfoReps/name]"/>
				<xsl:variable name="persistApp2DataReps" select="$manualEntryApp2InfoRep2DataReps[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value = $persistConsumingApp2InfoReps/name]"/>


				<xsl:for-each select="$persistConsumingApps">
					<xsl:variable name="consumingApp" select="current()"/>
					<xsl:variable name="currentConsumingApp2InfoReps" select="$persistConsumingApp2InfoReps[name = current()/own_slot_value[slot_reference = 'uses_information_representation']/value]"/>
					<xsl:variable name="currentConsumingApp2Info2DataReps" select="$persistApp2DataReps[own_slot_value[slot_reference = 'apppro_to_inforep_to_datarep_from_appro_to_inforep']/value = $currentConsumingApp2InfoReps/name]"/>

					<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
					<xsl:if test="position() = 1">
						<td>
							<xsl:attribute name="rowspan">
								<xsl:value-of select="count($manualEntryApp2InfoRep2DataReps)"/>
							</xsl:attribute>
							<div class="dependencyModel_Inbound bg-darkgrey">
								<strong>
									<xsl:value-of select="eas:i18n('User')"/>
								</strong>
							</div>
						</td>
					</xsl:if>

					<xsl:for-each select="$currentConsumingApp2Info2DataReps">
						<xsl:variable name="currentApp2DDataRepoPos" select="position()"/>
						<xsl:variable name="acquisitionMethod" select="$allAcquisitionMethods[name = current()/own_slot_value[slot_reference = 'app_pro_data_acquisition_method']/value]"/>
						<xsl:variable name="acquisitionMethodName" select="$acquisitionMethod/own_slot_value[slot_reference = 'name']/value"/>

						<td>
							<div class="providerModelArrowL2R small">
								<em>
									<xsl:value-of select="$dataObjectName"/>
									<xsl:text> (</xsl:text>
									<xsl:value-of select="$acquisitionMethodName"/>
									<xsl:text>)</xsl:text>
								</em>
							</div>
						</td>

						<xsl:if test="$currentApp2DDataRepoPos = 1">
							<td>
								<xsl:attribute name="rowspan">
									<xsl:value-of select="count($currentConsumingApp2Info2DataReps)"/>
								</xsl:attribute>
								<strong>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$consumingApp"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										<xsl:with-param name="divClass" select="'dependencyModel_Inbound backColour3 text-white'"/>
										<xsl:with-param name="anchorClass" select="'noUL'"/>
									</xsl:call-template>
								</strong>
							</td>
						</xsl:if>
						<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
					</xsl:for-each>

				</xsl:for-each>
			</tbody>
		</table>
		<!--Data Object Provider Model Ends-->
	</xsl:template>
</xsl:stylesheet>
