<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:easlang="http://www.enterprise-architecture.org/essential/language" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:functx="http://www.functx.com" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output indent="yes" method="html" omit-xml-declaration="yes"/>

	<xsl:param name="param1"/>
	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!-- 04.12.2013	NJW	View UI design completed -->
	<!-- 11.12.2013 JWC	Added queries to the view -->
	<!-- 14.01.2014 JWC	Fixed the inbound direct dependencies 5-col model query for relationships -->
	<!-- 28.01.2014 JWC Revised direct inbound and outbound dependencies for 5-col model -->
	<!-- 03.02.2014	JWC Extended view to pick up Info Reps from Attribute-only data -->
	<!-- 27.02.2014	JWC Fixed bug where dependencies to App Pros (not Comp App Pros) were not shown on detailed view -->
	<!-- 02.02.2016 JWC / NW Move to v5 -->
	<!-- 19.02.2016 JWC Revised queries and performance enhancements -->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Representation', 'Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Get the Application Provider for param1 -->
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider', 'Application_Provider_Interface')]"/>
	<xsl:variable name="topApp" select="$allApps[name = $param1]"/>
	<xsl:variable name="subApps" select="$allApps[name = $topApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
	<xsl:variable name="subSubApps" select="$allApps[name = $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
	<xsl:variable name="currentApp" select="$topApp union $subApps union $subSubApps"/>
	<xsl:variable name="currentAppName" select="$topApp/own_slot_value[slot_reference = 'name']/value"/>

	<!-- Get all Data Sets needed to minimise having to traverse the whole document -->
	<xsl:variable name="allApp2InfoReps" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_RELATION']"/>
	<xsl:variable name="allAcquisitionMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="allInfoReps" select="/node()/simple_instance[type = 'Information_Representation']"/>
	<xsl:variable name="allInfoRepAtts" select="/node()/simple_instance[type = 'Information_Representation_Attribute']"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[type = 'Information_View']"/>
	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>
	<xsl:variable name="allAppDependencies" select="/node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']"/>
	<xsl:variable name="allAppDepInfoExchanged" select="/node()/simple_instance[type = 'APP_PRO_TO_INFOREP_EXCHANGE_RELATION']"/>
	<xsl:variable name="allAppUsages" select="/node()/simple_instance[type = 'Static_Application_Provider_Usage']"/>
	<xsl:variable name="allServiceQuals" select="/node()/simple_instance[supertype = 'Service_Quality' or type = 'Service_Quality']"/>
	<xsl:variable name="allServiceQualVals" select="/node()/simple_instance[type = 'Information_Service_Quality_Value']"/>
	<xsl:variable name="timelinessQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Timeliness')]"/>
	<xsl:variable name="granularityQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Granularity')]"/>
	<xsl:variable name="completenessQualityType" select="/node()/simple_instance[(type = 'Information_Service_Quality') and (own_slot_value[slot_reference = 'name']/value = 'Completeness')]"/>

	<xsl:variable name="allAppPurposes" select="/node()/simple_instance[type = 'Application_Purpose']"/>
	<xsl:variable name="integrationPurpose" select="$allAppPurposes[(own_slot_value[slot_reference = 'name']/value = 'Application Integration') or (own_slot_value[slot_reference = 'name']/value = 'Data Integration')]"/>
	<xsl:variable name="allDataAcquisitionMethods" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="manualDataAcquisition" select="$allDataAcquisitionMethods[own_slot_value[slot_reference = 'name']/value = 'Manual Data Entry']"/>

	<xsl:variable name="allDataAcquisitionStyles" select="/node()/simple_instance[name = $allDataAcquisitionMethods/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>

	<!-- Set the label for dependencies that have no defined information in the model -->
	<xsl:variable name="noInfoRendering">
		<xsl:value-of select="eas:i18n('Undefined Information')"/>
	</xsl:variable>

	<!-- Find all the direct dependencies to/from the in-focus application -->

	<xsl:variable name="currentAppUsages" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $currentApp/name]"/>
	<xsl:variable name="inboundDependencies" select="$allAppDependencies[(own_slot_value[slot_reference = ':FROM']/value = $currentAppUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $currentAppUsages/name)]"/>
	<xsl:variable name="inboundAppUsages" select="$allAppUsages[name = $inboundDependencies/own_slot_value[slot_reference = ':TO']/value]"/>
	<xsl:variable name="inboundApps" select="$allApps[name = $inboundAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>

	<xsl:variable name="inboundAppCount" select="count($inboundDependencies)"/>

	<xsl:variable name="outboundDependencies" select="$allAppDependencies[(own_slot_value[slot_reference = ':TO']/value = $currentAppUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $currentAppUsages/name)]"/>
	<xsl:variable name="outboundAppUsages" select="$allAppUsages[name = $outboundDependencies/own_slot_value[slot_reference = ':FROM']/value]"/>
	<xsl:variable name="outboundApps" select="$allApps[name = $outboundAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	<xsl:variable name="outboundAppCount" select="count($outboundDependencies)"/>

	<xsl:variable name="integrationSolutionCateogry">Integration Module</xsl:variable>
	<xsl:variable name="theIntegrationCategory" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = $integrationSolutionCateogry]"/>
	<xsl:variable name="allCompositeApps" select="/node()/simple_instance[type = 'Composite_Application_Provider']"/>

	<!-- Find the source systems at the end of integration components in the inbound dependencies -->
	<!-- Middleware / integration solution components must be classified by Application Provider Category = $integrationSolutionCateogry -->

	<!-- Update from use of Taxonomy term to use of the Application Purpose slot value -->
	<xsl:variable name="anInboundList" select="eas:findInboundMiddlewareDeps($inboundApps[own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name], 0)"/>
	<xsl:variable name="anOutboundList" select="eas:findOutboundMiddlewareDeps($outboundApps[own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name], 0)"/>

	<!-- Find the inbound middleware components -->
	<xsl:variable name="anInboundIntegrationList" select="eas:getIntegrationComponents($inboundApps)"/>
	<!-- Find the outbout middleware components -->
	<xsl:variable name="anOutboundIntegrationList" select="eas:getIntegrationComponents($outboundApps)"/>

	<!-- Find the direct inbound and outbound dependencies -->
	<xsl:variable name="aDirectInboundList" select="eas:findInboundDirectDeps($inboundApps) except eas:findManualInboundDirectDeps()"/>
	<xsl:variable name="aDirectOutboundList" select="eas:findOutboundDirectDeps($outboundApps) except eas:findManualOutboundDirectDeps()"/>

	<xsl:variable name="manualDataAccessCategory">Manual Data Access Module</xsl:variable>
	<xsl:variable name="theManualDataAccessCategory" select="$allTaxonomyTerms[own_slot_value[slot_reference = 'name']/value = $manualDataAccessCategory]"/>
	<xsl:variable name="allTransferAppDependencies" select="$allAppDependencies[not(own_slot_value[slot_reference = ':FROM']/value = own_slot_value[slot_reference = ':TO']/value)]"/>
	<xsl:variable name="aManualInboundList" select="eas:findManualInboundDirectDeps()"/>
	<xsl:variable name="aManualOutboundList" select="eas:findManualOutboundDirectDeps()"/>

	<xsl:variable name="DEBUG" select="''"/>

	<!-- Build the View -->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Application Dependencies for ')"/>
					<xsl:value-of select="$currentAppName"/>
				</title>
				<script type="text/javascript">
					$('document').ready(function(){
						$('.depModelObject').each(function(){
							var $div = $(this);
							// Set the div's height to its parent td's height
							$div.height($div.parent().height());
						});
						$('.middleware').each(function(){
							var $div = $(this);
							// Set the div's height to its parent td's height
							$div.height($div.parent().height());
						});
						$('.depModelObjectHub').each(function(){
							var $div = $(this);
							// Set the div's height to its parent td's height
							$div.height($div.parent().height()-20);
						});
					});
				</script>
				<!--<script type="text/javascript">
					$('document').ready(function(){
						$(".depModelArrowShort").vAlign();
						$(".depModelArrowLong").vAlign();
					});
				</script>-->
				<script type="text/javascript">
					$('document').ready(function(){	
					$('#autofiveCol').hide();
					$('#manfiveCol').hide();
					$('#fiveColHeader').hide();
					$('#detailButton').click(function(){
						$('#autofiveCol').toggle();
						$('#autothreeCol').toggle();
						$('#manfiveCol').toggle();
						$('#manthreeCol').toggle();
						$('#fiveColHeader').toggle();
						$('#threeColHeader').toggle();
						$('span',this).text(function(i,txt) {return txt === "Show Detailed Feeds" ? "Hide Detailed Feeds" : "Show Detailed Feeds";});
					});
					});
				</script>
				<script>
					$(document).ready(function(){
						$('[data-toggle="popover"]').popover({html: true});
						$('body').on('click', function (e) {
						    $('[data-toggle="popover"]').each(function () {
						        //the 'is' for buttons that trigger popups
						        //the 'has' for icons within a button that triggers a popup
						        if (!$(this).is(e.target) &amp;&amp; $(this).has(e.target).length === 0 &amp;&amp; $('.popover').has(e.target).length === 0) {
						            $(this).popover('hide');
						        }
						    });
						});
					});
				</script>

			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Application Dependency Model for ')"/>
										<span class="text-primary">
											<xsl:value-of select="$currentAppName"/>
										</span>
									</span>
								</h1>
							</div>
						</div>
						<!--Setup Automated Section-->
						<div id="sectionAutomated">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-gear icon-section icon-color"/>
								</div>
								<div class="smallButton bg-primary text-white fontBlack pull-right" id="detailButton" style="width:150px">
									<span>
										<xsl:value-of select="eas:i18n('Show Detailed Feeds')"/>
									</span>
								</div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Automated')"/>
								</h2>

								<!-- If there are no dependencies, say so -->
								<xsl:choose>

									<xsl:when test="($inboundAppCount = 0) and ($outboundAppCount = 0)">
										<div class="content-section">
											<em>
												<xsl:value-of select="eas:i18n('No Automated Dependencies captured for ')"/>
												<strong>
													<xsl:value-of select="$currentAppName"/>
												</strong>
											</em>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<div class="content-section">
											<p>
												<xsl:value-of select="eas:i18n('This view shows the automated dependencies for ')"/>
												<xsl:value-of select="$currentAppName"/>
											</p>
											<div class="verticalSpacer_15px"/>

											<xsl:call-template name="automated_threeColModel"/>
											<!--<xsl:call-template name="threeColOOTB"/>-->
											<xsl:call-template name="automated_fiveColModel"/>
											<!--<xsl:value-of select="count($inboundApps[own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name])"></xsl:value-of><br></br>
											<xsl:value-of select="count($anInboundList)"></xsl:value-of><br></br>
											<xsl:value-of select="count($anOutboundList)"></xsl:value-of>-->
										</div>
									</xsl:otherwise>
								</xsl:choose>
								<div class="clearfix"/>
								<hr/>
							</div>
						</div>

						<!--Setup Manual Section-->
						<xsl:if test="(count($aManualInboundList) + count($aManualOutboundList)) > 0">
							<div id="sectionManual">
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-wrench icon-section icon-color"/>
									</div>
									<div>
										<h2 class="text-primary">
											<xsl:value-of select="eas:i18n('Manual')"/>
										</h2>
									</div>
									<div class="content-section">
										<p>
											<xsl:value-of select="eas:i18n('This view shows the manual dependencies for ')"/>
											<xsl:value-of select="$currentAppName"/>
										</p>
										<div class="verticalSpacer_15px"/>
										<xsl:call-template name="manual_threeColModel"/>
										<xsl:call-template name="manual_fiveColModel"/>
									</div>
									<div class="clearfix"/>
									<hr/>
								</div>
							</div>
						</xsl:if>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
<script>
$( document ).ready(function() {
	$(document).on("click", ".saveApps", function(){
		var appLists = $(this).attr('appLists');
		var carriedApps=appLists.split(',');
		var apps={};
		apps['Composite_Application_Provider']=carriedApps;
		sessionStorage.setItem("context", JSON.stringify(apps));
	});
});	
				</script>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="threeColHeaders">
		<div class="pull-left col-xs-12" id="threeColHeader">
			<div class="row">
				<div class="col-xs-5">
					<table class="tableWidth-100pc">
						<tbody>
							<!--setup the headers for the digram-->
							<tr>
								<th class="col-xs-6">&#160;</th>
								<th class="col-xs-6 alignCentre">
									<h3 class="text-primary">
										<xsl:value-of select="eas:i18n('Inbound')"/>
									</h3>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="col-xs-2"/>
				<div class="col-xs-5">
					<table class="tableWidth-100pc">
						<tbody>
							<!--setup the headers for the digram-->
							<tr>
								<th class="col-xs-6 alignCentre">
									<h3 class="text-primary">
										<xsl:value-of select="eas:i18n('Outbound')"/>
									</h3>
								</th>
								<th class="col-xs-6">&#160;</th>
							</tr>
						</tbody>
					</table>
				</div>

			</div>
		</div>
	</xsl:template>

	<xsl:template name="fiveColHeaders">

		<div class="pull-left col-xs-12" id="fiveColHeader">
			<div class="row">
				<div class="col-xs-5">
					<table class="tableWidth-100pc">
						<tbody>
							<!--setup the headers for the digram-->
							<tr>
								<th class="col-xs-3">&#160;</th>
								<th class="col-xs-3">&#160;</th>
								<th class="col-xs-3 alignCentre">
									<h3 class="text-primary">
										<xsl:value-of select="eas:i18n('Inbound')"/>
									</h3>
								</th>
								<th class="col-xs-3">&#160;</th>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="col-xs-2"/>
				<div class="col-xs-5">
					<table class="tableWidth-100pc">
						<tbody>
							<!--setup the headers for the digram-->
							<tr>
								<th class="col-xs-3">&#160;</th>
								<th class="col-xs-3 alignCentre">
									<h3 class="text-primary">
										<xsl:value-of select="eas:i18n('Outbound')"/>
									</h3>
								</th>
								<th class="col-xs-3">&#160;</th>
								<th class="col-xs-3">&#160;</th>
							</tr>
						</tbody>
					</table>
				</div>

			</div>
		</div>
	</xsl:template>

	<xsl:template name="automated_threeColModel">
		<xsl:call-template name="threeColHeaders"/>
		<div class="depModelContainer pull-left" style="width:100%;" id="autothreeCol">
			<div class="pull-left col-xs-5" id="LeftSide">
				<div class="row">
					<table class="depModelTable">
						<tbody>
							<!-- Middleware dependencies -->
							<!--<xsl:for-each select="$anInboundList">-->
							<xsl:variable name="emptySequence" as="node()*">
								<xsl:sequence select="()"></xsl:sequence>
							</xsl:variable>
							<xsl:for-each-group select="eas:getCompAppList($anInboundList, $emptySequence)" group-by="name">
								<xsl:variable name="boxName" select="current-group()[1]"/>
								<tr>
									<td class="col-xs-6">
										<div class="depModelObject bg-aqua-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$boxName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
									<td class="col-xs-6">
										<div class="feed depModelArrowShort small">
											<xsl:value-of select="eas:i18n('middleware feed')"/>
										</div>
									</td>
								</tr>
							</xsl:for-each-group>

							<!-- Direct dependencies -->
							<!--<xsl:for-each select="$aDirectInboundList">-->
							<xsl:variable name="emptySequence" as="node()*">
								<xsl:sequence select="()"></xsl:sequence>
							</xsl:variable>
							<xsl:for-each-group select="eas:getCompAppList($aDirectInboundList, $emptySequence)" group-by="name">
								<!--<xsl:variable name="boxDirectName" select="eas:getCompApp(current())"/>-->
								<xsl:variable name="boxDirectName" select="current-group()[1]"/>
								<tr>
									<td class="col-xs-6">
										<div class="depModelObject bg-aqua-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$boxDirectName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
									<td class="col-xs-6">
										<div class="feed depModelArrowShort small">
											<xsl:value-of select="eas:i18n('direct feed')"/>
										</div>
									</td>
								</tr>
							</xsl:for-each-group>
						</tbody>
					</table>
				</div>
			</div>

			<div class="depModelObjectHub bg-lightblue-100 fontBlack small text-white pull-left col-xs-2">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$topApp"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'text-white'"/>
					<xsl:with-param name="anchorClass" select="'noUL'"/>
				</xsl:call-template>
				 <div style="display:inline-block">
					 <i class="fa fa-exchange" style="color:white;cursor:pointer" alt="Rationalisation View" onclick="location.href='report?XML=reportXML.xml&amp;XSL=application/core_al_app_rationalisation_analysis_simple.xsl&amp;PMA=bcm'"><xsl:attribute name="appLists"><xsl:value-of select="$topApp/name"/></xsl:attribute></i> </div>
			</div>

			<div class="pull-left col-xs-5" id="RightSide">
				<div class="row">
					<table class="depModelTable">
						<tbody>
							<!-- Middleware dependencies -->
							<xsl:variable name="emptySequence" as="node()*">
								<xsl:sequence select="()"></xsl:sequence>
							</xsl:variable>
							<xsl:for-each-group select="eas:getCompAppList($anOutboundList, $emptySequence)" group-by="name">
								<xsl:variable name="boxName" select="current-group()[1]"/>
								<tr>
									<td class="col-xs-6">
										<div class="feed depModelArrowShort small">
											<xsl:value-of select="eas:i18n('middleware feed')"/>
										</div>
									</td>
									<td class="col-xs-6">
										<div class="depModelObject bg-darkblue-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$boxName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
								</tr>
							</xsl:for-each-group>

							<!-- Direct dependencies -->
							<xsl:for-each-group select="eas:getCompAppList($aDirectOutboundList, $emptySequence)" group-by="name">
								<!--<xsl:variable name="boxDirectName" select="eas:getCompApp(current())"/>-->
								<xsl:variable name="boxDirectName" select="current-group()[1]"/>
								<tr>
									<td class="col-xs-6">
										<div class="feed depModelArrowShort small">
											<xsl:value-of select="eas:i18n('direct feed')"/>
										</div>
									</td>
									<td class="col-xs-6">
										<div class="depModelObject bg-darkblue-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$boxDirectName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>

								</tr>
							</xsl:for-each-group>

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="manual_threeColModel">

		<div class="depModelContainer pull-left" style="width:100%;" id="manthreeCol">
			<xsl:call-template name="threeColHeaders"/>
			<div class="pull-left col-xs-5" id="3ColMan-LeftSide">
				<div class="row">
					<table class="depModelTable">
						<tbody>
							<!-- Manual inbound dependencies -->
							<xsl:for-each select="$aManualInboundList">
								<tr>
									<td class="col-xs-6">
										<div class="depModelObject bg-aqua-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
									<td class="col-xs-6">
										<div class="feed depModelArrowShort small">
											<xsl:value-of select="eas:i18n('manual input')"/>
										</div>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</div>

			<div class="depModelObjectHub bg-lightblue-100 fontBlack small text-white pull-left col-xs-2">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$topApp"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'text-white'"/>
					<xsl:with-param name="anchorClass" select="'noUL'"/>
				</xsl:call-template>
			</div>

			<div class="pull-left col-xs-5" id="3ColMan-RightSide">
				<div class="row">
					<table class="depModelTable">
						<tbody>
							<!-- Manual outbound dependencies -->
							<xsl:for-each select="$aManualOutboundList">
								<tr>
									<td class="col-xs-6">
										<div class="feed depModelArrowShort small">
											<xsl:value-of select="eas:i18n('manual extract')"/>
										</div>
									</td>
									<td class="col-xs-6">
										<div class="depModelObject bg-darkblue-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="automated_fiveColModel">

		<!-- Find all the integration top-level applications for inbound side -->
		<xsl:variable name="emptySequenceIn" as="node()*">
			<xsl:sequence select="()"></xsl:sequence>
		</xsl:variable>
		<xsl:variable name="emptySequenceOut" as="node()*">
			<xsl:sequence select="()"></xsl:sequence>
		</xsl:variable>
		<xsl:variable name="emptySequenceCompList" as="node()*">
			<xsl:sequence select="()"></xsl:sequence>
		</xsl:variable>
		<xsl:variable name="anInboundIntBox" select="eas:getCompAppList($anInboundIntegrationList, $emptySequenceIn)"/>
		<xsl:variable name="anOutboundIntBox" select="eas:getCompAppList($anOutboundIntegrationList, $emptySequenceOut)"/>
		<xsl:variable name="aDirectInboundCompAppList" select="eas:getCompAppList($aDirectInboundList, $emptySequenceCompList)"/>
		<xsl:variable name="aFromUsageList" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $inboundApps/name]"/>
		<xsl:variable name="allFromDependencies" select="$allAppDependencies[own_slot_value[slot_reference = ':FROM']/value = $aFromUsageList/name]"/>

		<!-- Find relevant top-level outbound integrations from the focus application-->
		<xsl:variable name="emptySequence" as="node()*">
			<xsl:sequence select="()"></xsl:sequence>
		</xsl:variable>
		<xsl:variable name="aDirectOutboundCompAppList" select="eas:getCompAppList($aDirectOutboundList, $emptySequence)"/>
		<xsl:variable name="aToUsageList" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $outboundApps/name]"/>
		<xsl:variable name="allToDependencies" select="$allAppDependencies[own_slot_value[slot_reference = ':TO']/value = $aToUsageList/name]"/>

		<div class="depModelContainer pull-left" style="width:100%;" id="autofiveCol">
			<xsl:call-template name="fiveColHeaders"/>
			<div class="pull-left col-xs-5" id="5ColAuto-LeftSide">
				<div class="row">
					<!-- Inbound Table, only take the 1st of each top-level name for the integration solution -->
					<xsl:for-each-group select="$anInboundIntBox" group-by="name">
						<xsl:variable name="anIntegrationBox" select="current-group()[1]"/>
						<table class="depModelTable tableWidth-100%">
							<tbody>
								<!-- Middleware dependencies -->
								<!-- Find inbound dependencies for in-focus middleware platform -->
								<!-- Get the interfaces within the in-focus middleware -->
								<xsl:variable name="anInterfaceSet" select="$inboundApps[name = $anIntegrationBox/own_slot_value[slot_reference = 'contained_application_providers']/value] union $anInboundIntBox"/>
								<xsl:variable name="anInterfaceSetUsages" select="$aFromUsageList[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $anInterfaceSet/name]"/>
								<xsl:variable name="anInboundAppDepSet" select="$allFromDependencies[own_slot_value[slot_reference = ':FROM']/value = $anInterfaceSetUsages/name]"/>
								<xsl:variable name="anInboundAppUsageSet" select="$allAppUsages[name = $anInboundAppDepSet/own_slot_value[slot_reference = ':TO']/value]"/>
								<xsl:variable name="anInboundAppSet" select="$anInboundList[name = $anInboundAppUsageSet/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
								<xsl:variable name="anInboundToMWFeedSet" select="eas:getRelevantDependencies($currentApp, $anInterfaceSet)"/>

								<xsl:for-each-group select="$anInboundAppSet" group-by="name">
									<xsl:variable name="aSourceApp" select="current-group()[1]"/>
									<xsl:variable name="boxName" select="eas:getCompApp($aSourceApp)"/>
									<xsl:variable name="aSourceAppSet" select="eas:getSubApps($aSourceApp)"/>
									<xsl:variable name="aFromUsageList" select="$anInboundAppUsageSet[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $aSourceApp/name]"/>
									<xsl:variable name="anInFeedSet" select="$anInboundAppDepSet[own_slot_value[slot_reference = ':TO']/value = $aFromUsageList/name]"/>

									<tr>
										<td class="col-xs-3">
											<div class="depModelObject bg-aqua-100 fontBlack small text-white clear appID_sourceA">
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$boxName"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													<xsl:with-param name="divClass" select="'text-white'"/>
													<xsl:with-param name="anchorClass" select="'noUL'"/>
												</xsl:call-template>
											</div>

										</td>
										<td class="col-xs-3">
											<!-- Feed Information from source systems -->
											<xsl:for-each select="$anInFeedSet">
												<xsl:variable name="anApu2Apu" select="current()"/>
												<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
												<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

												<xsl:choose>
													<xsl:when test="count($anInfoReps) > 0">
														<xsl:for-each select="$anInfoReps">
															<div class="feed depModelArrowShort small">
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="current()"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																	<xsl:with-param name="anchorClass" select="'small'"/>
																</xsl:call-template>
																<!-- Link to details about the information passed -->
																<xsl:call-template name="popupInfoButton">
																	<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
																</xsl:call-template>
															</div>
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<div class="feed depModelArrowShort small">
															<span class="small">
																<em>
																	<xsl:value-of select="$noInfoRendering"/>
																</em>
															</span>
														</div>
													</xsl:otherwise>
												</xsl:choose>

											</xsl:for-each>
										</td>

										<xsl:if test="position() = 1">
											<td class="col-xs-3">
												<!-- Render the middleware module(s) -->
												<xsl:attribute name="rowspan" select="count($anInboundAppSet)"/>
												<div class="middleware bg-lightgrey fontBlack small text-white">
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="$anIntegrationBox"/>
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														<xsl:with-param name="divClass" select="'text-white'"/>
														<xsl:with-param name="anchorClass" select="'noUL'"/>
													</xsl:call-template>
												</div>
											</td>

											<td class="col-xs-3">
												<!-- Render the feed from the middleware to the focus application -->
												<xsl:attribute name="rowspan" select="count($anInboundAppSet)"/>

												<xsl:for-each select="$anInboundToMWFeedSet">
													<xsl:variable name="anApu2Apu" select="current()"/>
													<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
													<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

													<xsl:choose>
														<xsl:when test="count($anInfoReps) > 0">

															<xsl:for-each select="$anInfoReps">
																<div class="feed depModelArrowShort small">
																	<xsl:call-template name="RenderInstanceLink">
																		<xsl:with-param name="theSubjectInstance" select="current()"/>
																		<xsl:with-param name="theXML" select="$reposXML"/>
																		<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																		<xsl:with-param name="anchorClass" select="'small'"/>
																	</xsl:call-template>
																	<!-- Link to details about the information passed -->
																	<xsl:call-template name="popupInfoButton">
																		<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
																	</xsl:call-template>
																</div>
															</xsl:for-each>
														</xsl:when>
														<xsl:otherwise>
															<div class="feed depModelArrowShort small">
																<span class="small">
																	<em>
																		<xsl:value-of select="$noInfoRendering"/>
																	</em>
																</span>
															</div>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</td>
										</xsl:if>
									</tr>
								</xsl:for-each-group>


							</tbody>
						</table>
					</xsl:for-each-group>

					<table class="depModelTable">
						<tbody>
							<!-- Direct dependencies -->
							<!--<xsl:for-each select="$aDirectInboundList">-->
							<xsl:for-each-group select="$aDirectInboundCompAppList" group-by="name">
								<xsl:variable name="aSourceApp" select="current-group()[1]"/>
								<xsl:variable name="boxDirectName" select="$aSourceApp"/>
								<xsl:variable name="aDirectRels" select="eas:getRelevantDependencies($currentApp, eas:getSubApps($aSourceApp))"/>
								<tr>
									<td class="col-xs-3">
										<div class="depModelObject bg-aqua-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$boxDirectName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>

									<td colspan="3" class="col-xs-9">
										<xsl:apply-templates mode="RenderDependencyDetail" select="$aDirectRels"/>
										<!--<xsl:for-each select="$aDirectRels">
											<xsl:variable name="anApu2Apu" select="current()"/>
											<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
											<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

											<xsl:choose>
												<xsl:when test="count($anInfoReps) > 0">
													<xsl:for-each select="$anInfoReps">
														<div class="feed depModelArrowLong small">
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="anchorClass" select="'small'"/>
															</xsl:call-template>
															<xsl:call-template name="popupInfoButton">
																<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
															</xsl:call-template>
														</div>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<div class="feed depModelArrowShort small">
														<span class="small">
															<em>
																<xsl:value-of select="$noInfoRendering"/>
															</em>
														</span>
													</div>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>-->
									</td>
								</tr>
							</xsl:for-each-group>

						</tbody>
					</table>
				</div>
			</div>

			<!-- Render the in-focus application -->
			<div class="depModelObjectHub bg-lightblue-100 fontBlack small text-white pull-left col-xs-2">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$topApp"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'text-white'"/>
					<xsl:with-param name="anchorClass" select="'noUL'"/>
				</xsl:call-template>
			</div>


			<div class="pull-left col-xs-5" id="5ColAuto-RightSide">
				<div class="row">
					<!-- Outbound table -->
					<!-- Outbound Table, only take the 1st of each top-level name for the integration solution -->
					<xsl:for-each-group select="$anOutboundIntBox" group-by="name">
						<xsl:variable name="anIntegrationBox" select="current-group()[1]"/>

						<table class="depModelTable">
							<tbody>
								<!-- Middleware dependencies -->
								<xsl:variable name="anInterfaceSet" select="$outboundApps[name = $anIntegrationBox/own_slot_value[slot_reference = 'contained_application_providers']/value] union $anIntegrationBox"/>
								<xsl:variable name="anInterfaceSetUsages" select="$aToUsageList[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $anInterfaceSet/name]"/>
								<xsl:variable name="anOutboundAppDepSet" select="$allToDependencies[own_slot_value[slot_reference = ':TO']/value = $anInterfaceSetUsages/name]"/>
								<xsl:variable name="anOutboundAppUsageSet" select="$allAppUsages[name = $anOutboundAppDepSet/own_slot_value[slot_reference = ':FROM']/value]"/>
								<xsl:variable name="anOutboundAppSet" select="$anOutboundList[name = $anOutboundAppUsageSet/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
								<xsl:variable name="anOutboundToMWFeedSet" select="eas:getRelevantDependencies($anInterfaceSet, $currentApp)"/>

								<xsl:for-each-group select="$anOutboundAppSet" group-by="name">
									<xsl:variable name="aTargetApp" select="current-group()[1]"/>
									<xsl:variable name="boxName" select="eas:getCompApp($aTargetApp)"/>
									<xsl:variable name="aTargetAppSet" select="eas:getSubApps($aTargetApp)"/>
									<xsl:variable name="aToUsageList" select="$anOutboundAppUsageSet[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $aTargetAppSet/name]"/>
									<xsl:variable name="anOutFeedSet" select="$anOutboundAppDepSet[own_slot_value[slot_reference = ':FROM']/value = $aToUsageList/name]"/>

									<tr>
										<!-- Feed Information to target systems -->
										<xsl:if test="position() = 1">
											<td class="col-xs-3">
												<!-- Render the feed from the middleware to the focus application -->
												<xsl:attribute name="rowspan" select="count($anOutboundAppSet)"/>

												<xsl:for-each select="$anOutboundToMWFeedSet">
													<xsl:variable name="anApu2Apu" select="current()"/>
													<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
													<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

													<xsl:choose>
														<xsl:when test="count($anInfoReps) > 0">
															<xsl:for-each select="$anInfoReps">
																<div class="feed depModelArrowShort small">
																	<xsl:call-template name="RenderInstanceLink">
																		<xsl:with-param name="theSubjectInstance" select="current()"/>
																		<xsl:with-param name="theXML" select="$reposXML"/>
																		<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																		<xsl:with-param name="anchorClass" select="'small'"/>
																	</xsl:call-template>
																	<xsl:call-template name="popupInfoButton">
																		<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
																	</xsl:call-template>
																</div>
															</xsl:for-each>
														</xsl:when>
														<xsl:otherwise>
															<div class="feed depModelArrowShort small">
																<span class="small">
																	<em>
																		<xsl:value-of select="$noInfoRendering"/>
																	</em>
																</span>
															</div>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</td>
											<td class="col-xs-3">
												<!-- Render the middleware module(s) -->
												<xsl:attribute name="rowspan" select="count($anOutboundAppSet)"/>
												<div class="middleware bg-lightgrey fontBlack small text-white">
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="$anIntegrationBox"/>
														<xsl:with-param name="theXML" select="$reposXML"/>
														<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														<xsl:with-param name="divClass" select="'text-white'"/>
														<xsl:with-param name="anchorClass" select="'noUL'"/>
													</xsl:call-template>

												</div>
											</td>
										</xsl:if>

										<td class="col-xs-3">
											<xsl:for-each select="$anOutFeedSet">
												<xsl:variable name="anApu2Apu" select="current()"/>
												<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
												<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

												<xsl:choose>
													<xsl:when test="count($anInfoReps) > 0">
														<xsl:for-each select="$anInfoReps">
															<div class="feed depModelArrowShort small">
																<xsl:call-template name="RenderInstanceLink">
																	<xsl:with-param name="theSubjectInstance" select="current()"/>
																	<xsl:with-param name="theXML" select="$reposXML"/>
																	<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																	<xsl:with-param name="anchorClass" select="'small'"/>
																</xsl:call-template>
																<xsl:call-template name="popupInfoButton">
																	<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
																</xsl:call-template>
															</div>
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<div class="feed depModelArrowShort small">
															<xsl:value-of select="$noInfoRendering"/>
														</div>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:for-each>
										</td>
										<td class="col-xs-3">
											<div class="depModelObject bg-darkblue-100 fontBlack small text-white clear">
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="$boxName"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
													<xsl:with-param name="divClass" select="'text-white'"/>
													<xsl:with-param name="anchorClass" select="'noUL'"/>
												</xsl:call-template>

											</div>
										</td>
									</tr>
								</xsl:for-each-group>
							</tbody>
						</table>
					</xsl:for-each-group>
					<!-- Direct Outbound dependencies -->
					<table class="depModelTable">
						<tbody>
							<!-- Direct dependencies -->
							<xsl:for-each-group select="$aDirectOutboundCompAppList" group-by="name">
								<xsl:variable name="aTargetApp" select="current-group()[1]"/>
								<xsl:variable name="boxDirectName" select="$aTargetApp"/>
								<xsl:variable name="aDirectRels" select="eas:getRelevantDependencies(eas:getSubApps($aTargetApp), $currentApp)"/>
								<tr>
									<td colspan="3" class="col-xs-9">
										<xsl:apply-templates mode="RenderDependencyDetail" select="$aDirectRels"/>
										<!--<xsl:for-each select="$aDirectRels">
											<xsl:variable name="anApu2Apu" select="current()"/>
											<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
											<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

											<xsl:choose>
												<xsl:when test="count($anInfoReps) > 0">
													<xsl:for-each select="$anInfoReps">
														<div class="feed depModelArrowLong small">
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="anchorClass" select="'small'"/>
															</xsl:call-template>
															<xsl:call-template name="popupInfoButton">
																<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
															</xsl:call-template>
														</div>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<div class="feed depModelArrowShort small">
														<span class="small">
															<em>
																<xsl:value-of select="$noInfoRendering"/>
															</em>
														</span>
													</div>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>-->
									</td>
									<td class="col-xs-3">
										<div class="depModelObject bg-darkblue-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$aTargetApp"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
								</tr>
							</xsl:for-each-group>
						</tbody>
					</table>
				</div>
			</div>
		</div>


	</xsl:template>


	<xsl:template name="manual_fiveColModel">

		<!-- Find all the integration top-level applications for inbound side -->
		<xsl:variable name="anInboundIntBox" select="$aManualInboundList"/>
		<xsl:variable name="anOutboundIntBox" select="$aManualOutboundList"/>

		<div class="depModelContainer pull-left" style="width:100%;" id="manfiveCol">
			<xsl:call-template name="fiveColHeaders"/>
			<div class="pull-left col-xs-5" id="5ColMan-LeftSide">
				<div class="row">
					<table class="depModelTable">
						<tbody>
							<!-- Direct dependencies -->
							<!--<xsl:for-each select="$aDirectInboundList">-->
							<xsl:for-each-group select="$aManualInboundList" group-by="name">
								<xsl:variable name="aSourceApp" select="current-group()[1]"/>
								<xsl:variable name="boxDirectName" select="$aSourceApp"/>
								<xsl:variable name="aDirectRels" select="eas:getRelevantDependencies($currentApp, eas:getSubApps($aSourceApp))"/>
								<tr>
									<td class="col-xs-3">
										<div class="depModelObject bg-aqua-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$boxDirectName"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>

									<td colspan="3" class="col-xs-9">
										<xsl:for-each select="$aDirectRels">
											<xsl:variable name="anApu2Apu" select="current()"/>
											<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
											<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

											<xsl:choose>
												<xsl:when test="count($anInfoReps) > 0">
													<xsl:for-each select="$anInfoReps">
														<div class="feed depModelArrowLong small">
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="anchorClass" select="'small'"/>
															</xsl:call-template>
															<xsl:call-template name="popupInfoButton">
																<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
															</xsl:call-template>
														</div>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<div class="feed depModelArrowShort small">
														<span class="small">
															<em>
																<xsl:value-of select="$noInfoRendering"/>
															</em>
														</span>
													</div>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</td>
								</tr>
							</xsl:for-each-group>

						</tbody>
					</table>
				</div>
			</div>

			<!-- Render the in-focus application -->
			<div class="depModelObjectHub bg-lightblue-100 fontBlack small text-white pull-left col-xs-2">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$topApp"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass" select="'text-white'"/>
					<xsl:with-param name="anchorClass" select="'noUL'"/>
				</xsl:call-template>
			</div>


			<div class="pull-left col-xs-5" id="5ColMan-RightSide">
				<div class="row">
					<!-- Outbound table -->
					<!-- Outbound Table, only take the 1st of each top-level name for the integration solution -->
					<!-- Manual Outbound dependencies -->
					<table class="depModelTable">
						<tbody>
							<!-- Direct dependencies -->
							<xsl:for-each-group select="$aManualOutboundList" group-by="name">
								<xsl:variable name="aTargetApp" select="current-group()[1]"/>
								<xsl:variable name="boxDirectName" select="$aTargetApp"/>
								<xsl:variable name="aDirectRels" select="eas:getRelevantDependencies(eas:getSubApps($aTargetApp), $currentApp)"/>
								<tr>
									<td colspan="3" class="col-xs-9">
										<xsl:for-each select="$aDirectRels">
											<xsl:variable name="anApu2Apu" select="current()"/>
											<xsl:variable name="anApp2InfoRep" select="$allApp2InfoReps[name = current()/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
											<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>

											<xsl:choose>
												<xsl:when test="count($anInfoReps) > 0">
													<xsl:for-each select="$anInfoReps">
														<div class="feed depModelArrowLong small">
															<xsl:call-template name="RenderInstanceLink">
																<xsl:with-param name="theSubjectInstance" select="current()"/>
																<xsl:with-param name="theXML" select="$reposXML"/>
																<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
																<xsl:with-param name="anchorClass" select="'small'"/>
															</xsl:call-template>
															<xsl:call-template name="popupInfoButton">
																<xsl:with-param name="theAppDepRel" select="$anApu2Apu"/>
															</xsl:call-template>
														</div>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<div class="feed depModelArrowShort small">
														<span class="small">
															<em>
																<xsl:value-of select="$noInfoRendering"/>
															</em>
														</span>
													</div>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</td>
									<td class="col-xs-3">
										<div class="depModelObject bg-darkblue-100 fontBlack small text-white clear appID_sourceA">
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$aTargetApp"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												<xsl:with-param name="divClass" select="'text-white'"/>
												<xsl:with-param name="anchorClass" select="'noUL'"/>
											</xsl:call-template>
										</div>
									</td>
								</tr>
							</xsl:for-each-group>
						</tbody>
					</table>
				</div>
			</div>


		</div>


	</xsl:template>

	<xsl:template name="popupInfoButton">
		<xsl:param name="theAppDepRel"/>
		<span>&#160;&#160; <i class="fa fa fa-info-circle text-midgrey" data-toggle="popover">
				<!--<xsl:attribute name="title" select="current()/own_slot_value[slot_reference = 'name']/value"/>-->
				<xsl:attribute name="data-content">
					<xsl:call-template name="popoverContent">
						<xsl:with-param name="appDepRelation" select="$theAppDepRel"/>
					</xsl:call-template>
				</xsl:attribute>
			</i>
		</span>
	</xsl:template>

	<xsl:template name="popoverContent">
		<xsl:param name="appDepRelation"/>
		<!--<xsl:variable name="inboundAcquisitionMethod" select="$allAcquisitionMethods[name = $appDepRelation/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value]"/>-->
		<xsl:variable name="currency" select="$allServiceQualVals[(name = $appDepRelation/own_slot_value[slot_reference = ('apu_to_apu_relation_inforep_service_quals', 'atire_service_quals')]/value) and (own_slot_value[slot_reference = 'usage_of_service_quality']/value = $timelinessQualityType/name)]"/>
		<xsl:variable name="anSqvList" select="$allServiceQualVals[(name = $appDepRelation/own_slot_value[slot_reference = ('apu_to_apu_relation_inforep_service_quals', 'atire_service_quals')]/value)]"/>
		<xsl:for-each select="$anSqvList">
			<xsl:variable name="aServQual" select="$allServiceQuals[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
			<xsl:if test="$aServQual/name != $timelinessQualityType/name">
				<xsl:text>&lt;strong&gt;</xsl:text>
				<!-- Use i18n template -->
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$aServQual"/>
				</xsl:call-template>:&#160; <xsl:text>&lt;/strong&gt;</xsl:text>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>
				<xsl:text>&lt;br/&gt;</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>&lt;strong&gt;</xsl:text>
		<xsl:value-of select="eas:i18n('Frequency')"/>:&#160; <xsl:text>&lt;/strong&gt;</xsl:text>
		<xsl:choose>
			<xsl:when test="count($currency) > 0">
				<xsl:value-of select="$currency/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>
				<!--<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$currency"/>
				</xsl:call-template>-->
			</xsl:when>
			<xsl:otherwise>&#160;-</xsl:otherwise>
		</xsl:choose>
		<!--<xsl:text>&lt;br/&gt;</xsl:text>
		<xsl:text>&lt;strong&gt;</xsl:text>
		<xsl:value-of select="eas:i18n('Method')"/>:&#160; <xsl:text>&lt;/strong&gt;</xsl:text>
		<xsl:choose>
			<xsl:when test="count($inboundAcquisitionMethod) > 0">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$inboundAcquisitionMethod"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;em&gt;</xsl:text>
				<xsl:value-of select="eas:i18n('Unknown')"/>
				<xsl:text>&lt;/em&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	
	
	<xsl:template mode="RenderDependencyDetail" match="node()">
		<xsl:variable name="anApu2Apu" select="current()"/>
		<xsl:variable name="directApp2InfoReps" select="$allApp2InfoReps[name = $anApu2Apu/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
		<xsl:variable name="thisInfoRepExchanges" select="$allAppDepInfoExchanged[name = $anApu2Apu/own_slot_value[slot_reference = 'apu_to_apu_relation_inforeps']/value]"/>
		<xsl:variable name="indirectApp2InfoReps" select="$allApp2InfoReps[name = $thisInfoRepExchanges/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
		<xsl:variable name="anApp2InfoRep" select="$directApp2InfoReps union $indirectApp2InfoReps"/>
		<xsl:variable name="anInfoReps" select="eas:getInfoRepsFromRelation($anApp2InfoRep)"/>
		<xsl:variable name="directInfoReps" select="$anInfoReps[not(name = $indirectApp2InfoReps/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value)]"/>
		<xsl:variable name="anAcqnMethod" select="$allAcquisitionMethods[name = $anApu2Apu/own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value]"/>
		<xsl:variable name="thisDataAcquisitionStyles" select="$allDataAcquisitionStyles[name = $anAcqnMethod/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
		<xsl:variable name="anAcquStyleClass">
			<xsl:choose>
				<xsl:when test="count($thisDataAcquisitionStyles) > 0"><xsl:text>acq-badge badge </xsl:text><xsl:value-of select="$thisDataAcquisitionStyles[1]/own_slot_value[slot_reference = 'element_style_class']/value"/></xsl:when>
				<xsl:otherwise>acq-badge badge bg-darkblue</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="count($anInfoReps) > 0">
				<xsl:apply-templates mode="RenderInfoRepArrow" select="$directInfoReps">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:with-param name="anAcqnMethod" select="$anAcqnMethod"/>
					<xsl:with-param name="anAcqStyle" select="$anAcquStyleClass"/>
					<xsl:with-param name="anAppRel" select="$anApu2Apu"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="RenderInfoRepExchangeArrow" select="$thisInfoRepExchanges">
					<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
					<xsl:with-param name="inScopeInfoReps" select="$anInfoReps"/>
					<xsl:with-param name="inScopeApp2InfoReps" select="$indirectApp2InfoReps"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<div class="feed depModelArrowShort small">
					<span class="small">
						<em>
							<xsl:value-of select="$noInfoRendering"/>
						</em>
					</span>
				</div>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	
	
	<xsl:template mode="RenderInfoRepExchangeArrow" match="node()">
		<xsl:param name="inScopeApp2InfoReps"/>
		<xsl:param name="inScopeInfoReps"/>
		
		<xsl:variable name="thisExchange" select="current()"/>
		<xsl:variable name="thisApp2InfoRep" select="$inScopeApp2InfoReps[name = $thisExchange/own_slot_value[slot_reference = 'atire_app_pro_to_inforep']/value]"/>
		<xsl:variable name="thisInfoRep" select="$inScopeInfoReps[name = $thisApp2InfoRep/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
		<xsl:variable name="anAcqnMethod" select="$allAcquisitionMethods[name = $thisExchange/own_slot_value[slot_reference = 'atire_acquisition_method']/value]"/>
		<xsl:variable name="thisDataAcquisitionStyles" select="$allDataAcquisitionStyles[name = $anAcqnMethod/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
		<xsl:variable name="anAcquStyleClass">
			<xsl:choose>
				<xsl:when test="count($thisDataAcquisitionStyles) > 0"><xsl:text>acq-badge badge </xsl:text><xsl:value-of select="$thisDataAcquisitionStyles[1]/own_slot_value[slot_reference = 'element_style_class']/value"/></xsl:when>
				<xsl:otherwise>acq-badge badge bg-darkblue</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div class="feed depModelArrowLong small">
			<div>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisInfoRep"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass" select="'small'"/>
				</xsl:call-template>
				<xsl:call-template name="popupInfoButton">
					<xsl:with-param name="theAppDepRel" select="$thisExchange"/>
				</xsl:call-template>
				<!--<xsl:if test="count($thisStdInfoViews) > 0">
					<xsl:call-template name="popupCanonicalInfoButton">
						<xsl:with-param name="theStdViews" select="$thisStdInfoViews"/>
					</xsl:call-template>		
				</xsl:if>-->														
			</div>
			<xsl:if test="count($anAcqnMethod) > 0">
				<div class="{$anAcquStyleClass}"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$anAcqnMethod"/></xsl:call-template></div>
			</xsl:if>			
		</div>
	</xsl:template>
	
	
	<xsl:template mode="RenderInfoRepArrow" match="node()">
		<xsl:param name="anAcqnMethod"/>
		<xsl:param name="anAcqStyle"/>
		<xsl:param name="anAppRel"/>
		
		
		<div class="feed depModelArrowLong small">
			<div>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass" select="'small'"/>
				</xsl:call-template>
				<xsl:call-template name="popupInfoButton">
					<xsl:with-param name="theAppDepRel" select="$anAppRel"/>
				</xsl:call-template>													
			</div>
			<!--EXAMPLE BADGE CODE-->
			<!--Must add an additional div surrounding the instance link and info/icon-->
			<xsl:if test="count($anAcqnMethod) > 0">
				<div class="{$anAcqStyle}"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$anAcqnMethod"/></xsl:call-template></div>
			</xsl:if>
			<!--END EXAMPLE CODE-->					
		</div>
	</xsl:template>
	
	

	<xsl:function name="eas:findInboundMiddlewareDeps" as="node()*">
		<xsl:param name="theInboundApp"/>
		<xsl:param name="depthCount"/>

		<!-- If the inbound app is an integration category app -->
		<xsl:choose>
			<xsl:when test="$theInboundApp/own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name">
				<!-- Recurse to find the source apps -->
				<xsl:variable name="anIntSolUsages" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $theInboundApp/name]"/>
				<xsl:variable name="anAppDeps" select="$allAppDependencies[(own_slot_value[slot_reference = ':FROM']/value = $anIntSolUsages/name) and not(own_slot_value[slot_reference = ':TO']/value = $anIntSolUsages/name)]"/>
				<xsl:variable name="anIntSolSourceAppUsageList" select="$allAppUsages[name = $anAppDeps/own_slot_value[slot_reference = ':TO']/value]"/>
				<xsl:variable name="anIntSolSourceAppList" select="$allApps[(name = $anIntSolSourceAppUsageList/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value) and not(own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name)]"/>
				<xsl:sequence select="eas:findInboundMiddlewareDeps($anIntSolSourceAppList, ($depthCount + 1))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$depthCount > 0">
					<xsl:sequence select="$theInboundApp"/>
				</xsl:if>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<xsl:function name="eas:findOutboundMiddlewareDeps" as="node()*">
		<xsl:param name="theOutboundApp"/>
		<xsl:param name="depthCount"/>

		<!-- If the outbound app is an integration category app -->
		<xsl:choose>
			<xsl:when test="$theOutboundApp/own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name">
				<!-- Recurse to find the source apps -->
				<xsl:variable name="anIntSolUsages" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $theOutboundApp/name]"/>
				<xsl:variable name="anAppDeps" select="$allAppDependencies[(own_slot_value[slot_reference = ':TO']/value = $anIntSolUsages/name) and not(own_slot_value[slot_reference = ':FROM']/value = $anIntSolUsages/name)]"/>
				<xsl:variable name="anIntSolTargetAppUsageList" select="$allAppUsages[name = $anAppDeps/own_slot_value[slot_reference = ':FROM']/value]"/>
				<xsl:variable name="anIntSolTargetAppList" select="$allApps[name = $anIntSolTargetAppUsageList/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value and not(own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name)]"/>
				<xsl:sequence select="eas:findOutboundMiddlewareDeps($anIntSolTargetAppList, ($depthCount + 1))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$depthCount > 0">
					<xsl:sequence select="$theOutboundApp"/>
				</xsl:if>

			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<!-- Get the direct inbound dependencies (no middleware) -->
	<xsl:function name="eas:findInboundDirectDeps" as="node()*">
		<xsl:param name="theInboundApp"/>

		<!-- If the inbound app is not an integration category app -->
		<xsl:sequence select="$theInboundApp[not(own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name)]"/>

	</xsl:function>

	<!-- Get the direct outbound dependencies (no middleware) -->
	<xsl:function name="eas:findOutboundDirectDeps" as="node()*">
		<xsl:param name="theOutboundApp"/>

		<!-- If the outbound app is not an integration category app -->
		<xsl:sequence select="$theOutboundApp[not(own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name)]"/>

	</xsl:function>


	<!-- Get the direct manual inbound dependencies (no middleware) -->
	<xsl:function name="eas:findManualInboundDirectDeps" as="node()*">
		<!-- Provide all inbound apps that are classified as Manual Data Access -->
		<!-- Get the from Usage-->
		<xsl:variable name="manualSourceAppDeps" select="$inboundDependencies[own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataAcquisition/name]"/>
		<xsl:variable name="manualInboundAppUsages" select="$inboundAppUsages[(name = $manualSourceAppDeps/own_slot_value[slot_reference = ':TO']/value)]"/>
		<xsl:sequence select="$inboundApps[name = $manualInboundAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	</xsl:function>

	<!-- Get the direct manual outbound dependencies (no middleware) -->
	<xsl:function name="eas:findManualOutboundDirectDeps" as="node()*">
		<!-- Provide all inbound apps that are classified as Manual Data Access -->
		<!-- Get the from Usage-->
		<xsl:variable name="manualTargetAppDeps" select="$outboundDependencies[own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataAcquisition/name]"/>
		<xsl:variable name="manualOutboundAppUsages" select="$outboundAppUsages[(name = $manualTargetAppDeps/own_slot_value[slot_reference = ':FROM']/value)]"/>
		<xsl:sequence select="$outboundApps[name = $manualOutboundAppUsages/own_slot_value[slot_reference = 'static_usage_of_app_provider']/value]"/>
	</xsl:function>

	<!-- Get the correct name for the module. If App Pro is part of Comp App Pro, return Comp App Pro -->
	<xsl:function name="eas:getCompApp" as="node()*">
		<xsl:param name="theAppModule"/>

		<xsl:variable name="aCompApp" select="$allCompositeApps[own_slot_value[slot_reference = 'contained_application_providers']/value = $theAppModule/name]"/>
		<xsl:choose>
			<xsl:when test="count($aCompApp) > 0">
				<xsl:sequence select="eas:getCompApp($aCompApp)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$theAppModule"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Apply getCompApp across a list and get a list -->
	<xsl:function name="eas:getCompAppList" as="node()*">
		<xsl:param name="theAppList" as="node()*"/>
		<xsl:param name="theCompList" as="node()*"/>

		<xsl:choose>
			<xsl:when test="count($theAppList) > 0">
				<xsl:variable name="anApp" select="$theAppList[1]"/>
				<xsl:variable name="aCompApp" select="eas:getCompApp($anApp)"/>
				<xsl:variable name="aToDoAppList" select="$theAppList except $anApp"/>
				<xsl:sequence select="eas:getCompAppList($aToDoAppList, $theCompList union $aCompApp)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$theCompList"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<!-- Render either middleware feed or direct feed depending on nature of the dependency -->
	<xsl:function name="eas:getInboundFeedLabel" as="xs:string">
		<xsl:param name="theFeedDependency"/>

		<xsl:variable name="aSourceApp" select="$allApps[name = $theFeedDependency/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:choose>
			<xsl:when test="$aSourceApp/own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name">
				<!--<xsl:when test="$middleWareHub/own_slot_value[slot_reference='contained_application_providers']/value = $aSourceApp/name">-->
				<xsl:value-of select="eas:i18n('middleware feed')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('direct feed')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Render either middleware feed or direct feed depending on nature of the dependency -->
	<xsl:function name="eas:getOutboundFeedLabel" as="xs:string">
		<xsl:param name="theFeedDependency"/>

		<xsl:variable name="aTargetApp" select="$allApps[name = $theFeedDependency/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:choose>
			<xsl:when test="$aTargetApp/own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name">
				<!--<xsl:when test="$middleWareHub/own_slot_value[slot_reference='contained_application_providers']/value = $aTargetApp/name">-->
				<xsl:value-of select="eas:i18n('middleware feed')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('direct feed')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="eas:getRelevantDependencies" as="node()*">
		<xsl:param name="theFromApp"/>
		<xsl:param name="theToApp"/>

		<xsl:variable name="aFromUsageList" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $theFromApp/name]"/>
		<xsl:variable name="aToUsageList" select="$allAppUsages[own_slot_value[slot_reference = 'static_usage_of_app_provider']/value = $theToApp/name]"/>
		<xsl:sequence select="$allAppDependencies[(own_slot_value[slot_reference = ':FROM']/value = $aFromUsageList/name) and (own_slot_value[slot_reference = ':TO']/value = $aToUsageList/name)]"/>

	</xsl:function>

	<xsl:function name="eas:getIntegrationComponents" as="node()*">
		<xsl:param name="theComponentList"/>

		<xsl:sequence select="$theComponentList[own_slot_value[slot_reference = 'application_provider_purpose']/value = $integrationPurpose/name]"/>

	</xsl:function>

	<!-- Find the sub applications of the specified application 
		 to get the aggregate of the composite and all its sub applications -->
	<xsl:function name="eas:getSubApps" as="node()*">
		<xsl:param name="theCompApp"/>

		<!-- Get the set of sub applications -->
		<xsl:variable name="aSubApp" select="$allApps[name = $theCompApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>

		<!-- If there are no subcomponents, just return the supplied application -->
		<!-- Otherwise, add the current app to the list and recurse to find sub-sub... applications -->
		<xsl:choose>
			<xsl:when test="count($aSubApp) = 0">
				<xsl:sequence select="$theCompApp"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$theCompApp union eas:getSubApps($aSubApp)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Find Info Reps for the relationship to Info Reps and Info Rep Attributes -->
	<xsl:function name="eas:getInfoRepsFromRelation" as="node()*">
		<xsl:param name="theRelationshipList"/>

		<xsl:variable name="anInfoRepList" select="$allInfoReps[name = $theRelationshipList/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>
		<xsl:variable name="anInfoRepAttList" select="$allInfoRepAtts[name = $theRelationshipList/own_slot_value[slot_reference = 'app_pro_to_inforep_to_inforep']/value]"/>

		<xsl:variable name="aParentInfoRepList" select="$allInfoReps[own_slot_value[slot_reference = 'contained_information_representation_attributes']/value = $anInfoRepAttList/name]"/>
		<xsl:sequence select="$anInfoRepList union $aParentInfoRepList"/>
	</xsl:function>
</xsl:stylesheet>
