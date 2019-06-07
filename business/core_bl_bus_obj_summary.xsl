<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">

	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>


	<xsl:output method="html"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'" />
		<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')" />-->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Objective', 'Group_Actor', 'Individual_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="currentObj" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="objName" select="$currentObj/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="objDesc" select="$currentObj/own_slot_value[slot_reference = 'description']/value"/>

	<xsl:variable name="busObjSupportedGoals" select="/node()/simple_instance[name = $currentObj/own_slot_value[slot_reference = 'objective_supports_objective']/value]"/>
	<xsl:variable name="busObjDrivers" select="/node()/simple_instance[name = $currentObj/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
	<xsl:variable name="busObjMeasureValues" select="/node()/simple_instance[name = $currentObj/own_slot_value[slot_reference = 'bo_measures']/value]"/>
	<xsl:variable name="busObjMeasures" select="/node()/simple_instance[name = $busObjMeasureValues/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>

	<xsl:variable name="busObjOrgOwners" select="/node()/simple_instance[name = $currentObj/own_slot_value[slot_reference = 'bo_owners']/value]"/>
	<xsl:variable name="busObjIndividualOwners" select="/node()/simple_instance[name = $currentObj/own_slot_value[slot_reference = 'bo_owners']/value]"/>
	
	<xsl:variable name="targetISODate" select="$currentObj/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>
	<xsl:variable name="targetEssDateId" select="$currentObj/own_slot_value[slot_reference = 'bo_target_date']/value"/>
	<xsl:variable name="jsTargetDate">
		<xsl:choose>
			<xsl:when test="string-length($targetISODate) > 0">
				<xsl:value-of select="xs:date($targetISODate)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="objTargetDate" select="/node()/simple_instance[name = $targetEssDateId]"/>
				<xsl:value-of select="eas:get_end_date_for_essential_time($objTargetDate)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="displayTargetDate">
		<xsl:choose>
			<xsl:when test="count($targetISODate) + count($targetEssDateId) > 0">
				<xsl:call-template name="FullFormatDate">
					<xsl:with-param name="theDate" select="$jsTargetDate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="allBusinessServiceQualities" select="/node()/simple_instance[type = 'Business_Service_Quality']"/>

	<!--<xsl:variable name="goalObjectiveType" select="/node()/simple_instance[(type='Taxonomy_Term') and (own_slot_value[slot_reference='name']/value = 'Strategic Goal')]"/>-->

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


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title><xsl:value-of select="eas:i18n('Business Objective Summary')"/>&#160;-&#160;<xsl:value-of select="$objName"/></title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentObj" mode="Page_Content"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<!--ADD THE CONTENT-->
	<xsl:template match="node()" mode="Page_Content">

		<div class="container-fluid">
			<div class="row">

				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Objective Summary for')"/>&#160; </span>
							<span class="text-primary">
								<xsl:value-of select="$objName"/>
							</span>
						</h1>
					</div>
				</div>

				<!--Setup the Definition section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-list-ul icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Description')"/>
					</h2>
					<p>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="$currentObj"/>
						</xsl:call-template>
					</p>
					<hr/>
				</div>



				<!--Setup Target Date Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Target Date')"/>
					</h2>
					<p>
						<xsl:choose>
							<xsl:when test="string-length($displayTargetDate) > 0">
								<xsl:value-of select="$displayTargetDate"/>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('No target date captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</p>
					<hr/>
				</div>



				<!--Setup Strategic Goal Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-star icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Strategic Goal</h2>
					<div>
						<xsl:choose>
							<xsl:when test="count($busObjSupportedGoals) > 0">
								<ul>
									<xsl:for-each select="$busObjSupportedGoals">
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
								<em>
									<xsl:value-of select="eas:i18n('No supported strategic goals captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>




				<!--Setup Business Drivers Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-gears icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Business Drivers')"/>
					</h2>
					<div>
						<xsl:choose>
							<xsl:when test="count($busObjDrivers) > 0">
								<ul>
									<xsl:for-each select="$busObjDrivers">
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
								<em>
									<xsl:value-of select="eas:i18n('No business drivers captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>





				<!--Setup Business Owner Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-user icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Business Owner')"/>
					</h2>
					<div>
						<xsl:variable name="allObjOwners" select="$busObjIndividualOwners union $busObjOrgOwners"/>
						<xsl:choose>
							<xsl:when test="count($allObjOwners) > 0">
								<ul>
									<xsl:for-each select="$allObjOwners">
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
								<em>
									<xsl:value-of select="eas:i18n('No business owner captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>




				<!--Setup the KPI Measures section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-check icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('KPI Measures')"/>
					</h2>
					<div>
						<xsl:choose>
							<xsl:when test="count($busObjMeasures) > 0">
								<ul>
									<xsl:for-each select="$busObjMeasures">
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
								<em>
									<xsl:value-of select="eas:i18n('No KPI measures captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>



				<!--Setup the Supporting Documentation section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-file-text-o icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
					</h2>
					<div>
						<xsl:apply-templates select="$currentObj" mode="ReportExternalDocRef"/>
					</div>
					<hr/>
				</div>


				<!--Sections end-->
			</div>
		</div>

	</xsl:template>


	<!-- TEMPLATE TO PRINT OUT THE LIST OF SERVICE QUALITY VALUES FOR AN OBJECTIVE AS A BULLETED LIST ITEM -->
	<xsl:template match="node()" mode="Measure">
		<xsl:variable name="serviceQuality" select="$allBusinessServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>

		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$serviceQuality"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>


</xsl:stylesheet>
