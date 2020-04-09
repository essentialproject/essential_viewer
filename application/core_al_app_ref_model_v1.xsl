<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:functx="http://www.functx.com" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:output indent="yes" method="html" omit-xml-declaration="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->


	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Capability', 'Application_Service', 'Application_Provider', 'Group_Actor')"/>

	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="highProjectThreshold" select="3"/>
	<xsl:variable name="medProjectThreshold" select="1"/>
	<xsl:variable name="lowProjectThreshold" select="0"/>

	<xsl:variable name="highFootprintStyle" select="'bg-pink-60'"/>
	<xsl:variable name="mediumFootprintStyle" select="'bg-orange-60'"/>
	<xsl:variable name="lowFootprintStyle" select="'bg-brightgreen-60'"/>
	<xsl:variable name="noFootprintStyle" select="'bg-lightgrey'"/>

	<xsl:variable name="lowUserCountStyle" select="'gradLevelAlt1'"/>
	<xsl:variable name="lowmedUserCountStyle" select="'gradLevelAlt2'"/>
	<xsl:variable name="medUserCountStyle" select="'gradLevelAlt3'"/>
	<xsl:variable name="medhighUserCountStyle" select="'gradLevelAlt4'"/>
	<xsl:variable name="highUserCountStyle" select="'gradLevelAlt5'"/>


	<xsl:variable name="appCategoryTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = ('Application Capability Category', 'Reference Model Layout'))]"/>
	<xsl:variable name="allTaxTerms" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appCategoryTaxonomy/name)]"/>

	<xsl:variable name="sharedAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = ('Shared', 'Left'))]"/>
	<xsl:variable name="coreAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = ('Core', 'Middle'))]"/>
	<xsl:variable name="manageAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = ('Management', 'Right'))]"/>
	<xsl:variable name="foundationAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = ('Foundation', 'Middle'))]"/>
	<xsl:variable name="enablingAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = ('Enabling', 'Bottom'))]"/>

	<!--<xsl:variable name="customCodeBase" select="/node()/simple_instance[(type='Codebase_Status') and (own_slot_value[slot_reference='name']/value = 'Custom')]"/>
	<xsl:variable name="vendorCodeBase" select="/node()/simple_instance[(type='Codebase_Status') and (own_slot_value[slot_reference='name']/value = 'Vendor')]"/>-->


	<xsl:variable name="allAppCaps" select="/node()/simple_instance[(type = 'Application_Capability')]"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $allAppCaps/name]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $allAppServices/name]"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[name = $allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allAppFamiliess" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'type_of_application']/value]"/>
	<xsl:variable name="allActor2Role" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>


	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>

	<!--All Actors who use Apps-->
	<xsl:variable name="allAppUserOrgs" select="/node()/simple_instance[name = $appOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

	<xsl:variable name="DEBUG" select="''"/>

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
				<title>Application Current State Model</title>
				<script>
					function setEqualHeight1(columns)  
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
					setEqualHeight1($(".appRef_WideColCap_Half"));
					});
				</script>
				<script>
					function setEqualHeight2(columns)  
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
					setEqualHeight2($(".appRef_WideColCap_Third"));
					});
				</script>
				<script>
					function setEqualHeight3(columns)  
					{  
					var tallestcolumn = 0;  
					columns.each(  
					function()  
					{  
					currentHeight = $(".appRef_WideColContainer").height()-50;  
					if(currentHeight > tallestcolumn)  
					{  
					tallestcolumn  = currentHeight;  
					}  
					}  
					);  
					columns.height(tallestcolumn);  
					}  
					$(document).ready(function() {  
					setEqualHeight3($(".appRef_NarrowColCap"));
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					$(".appRef_AppContainer").vAlign();
					$(".threeColModel_Object").vAlign();
					$(".threeColModel_NumberHeatmap").vAlign();
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					$(".heatmapContainer").hide();
					$(".userKey").hide();
					$(".userCountToggle").click(function(){
					$(".heatmapContainer").slideToggle();
					$(".userKey").slideToggle();
					});
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					$(".threeColModel_NumberHeatmap").hide();
					$(".instanceKey").hide();
					$(".heatmapToggle").click(function(){
					
					$(".threeColModel_ObjectBackgroundColour").toggle();
					$(".threeColModel_NumberHeatmap").toggle();
					$(".instanceKey").slideToggle();
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
						<div>
							<div class="col-xs-12 col-sm-6">
								<div class="page-header">
									<h1 id="viewName">
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">Application Reference Model</span>
										<xsl:value-of select="$DEBUG"/>
									</h1>
								</div>
							</div>
						</div>
						<!--Setup Model Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Model</h2>
							</div>
							<div class="content-section">
								<p>The Application Reference Model provides a high level overview of the key application building blocks that support the execution of business processes across the enterprise.</p>
								<div class="verticalSpacer_5px"/>
							</div>
							<xsl:call-template name="appRefModel"/>
							<hr/>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
				<div class="clear"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template name="appRefModel">
		<div class="appRef_container">
			<!--Left-->

			<xsl:apply-templates mode="RenderSharedAppCap" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $sharedAppCapType/name)]">
				<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
			</xsl:apply-templates>


			<!--Middle-->
			<div class="appRef_WideColContainer col-xs-6">
				<xsl:variable name="coreAppCaps" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $coreAppCapType/name)]"/>
				<xsl:apply-templates mode="RenderFoundationAppCap" select="$coreAppCaps">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>

				<xsl:variable name="foundationAppCaps" select="($allAppCaps except $coreAppCaps)[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $foundationAppCapType/name)]"/>
				<xsl:choose>
					<xsl:when test="count($foundationAppCaps) &gt; 0">
						<div class="verticalSpacer_20px"/>
						<xsl:apply-templates mode="RenderFoundationAppCap" select="$foundationAppCaps">
							<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>



				<xsl:variable name="enablingAppCaps" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $enablingAppCapType/name)]"/>
				<xsl:choose>
					<xsl:when test="count($enablingAppCaps) &gt; 0">
						<div class="verticalSpacer_20px"/>
						<xsl:apply-templates mode="RenderEnablingAppCap" select="$enablingAppCaps">
							<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>

			</div>
			<!--Right-->
			<xsl:apply-templates mode="RenderManagementAppCap" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $manageAppCapType/name)]">
				<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>






	<xsl:template match="node()" mode="RenderSharedAppCap">
		<div class="appRef_NarrowColContainer col-xs-3">
			<div class="appRef_NarrowColCap bg-darkblue-100">
				<div class="appRef_CapTitle fontBlack xlarge text-white">
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass">text-white</xsl:with-param>
					</xsl:call-template>
				</div>
				<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>

				<xsl:apply-templates mode="RenderSharedLevel2AppCaps" select="$subAppCaps"> </xsl:apply-templates>

			</div>
			<xsl:if test="not(position() = last())">
				<div class="horizSpacer_20px pull-left"/>
			</xsl:if>
			<div class="horizSpacer_20px pull-left"/>
		</div>

	</xsl:template>



	<xsl:template match="node()" mode="RenderSharedLevel2AppCaps">
		<xsl:variable name="currentAppSvc" select="current()"/>
		<div class="appRef_NarrowColSubCap">
			<div class="appRef_CapTitle fontBlack large">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:with-param name="relevantAppSvc" select="$currentAppSvc"/>
			</xsl:apply-templates>

		</div>
	</xsl:template>




	<xsl:template match="node()" mode="RenderFoundationAppCap">
		<div class="appRef_WideColCap bg-darkblue-100">
			<div class="appRef_CapTitle fontBlack xlarge text-white">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">text-white</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>

			<xsl:apply-templates mode="RenderFoundationLevel2AppCaps" select="$subAppCaps"> </xsl:apply-templates>
		</div>
		<xsl:if test="not(position() = last())">
			<div class="verticalSpacer_20px"/>
		</xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="RenderFoundationLevel2AppCaps">
		<div class="appRef_WideColSubCap_Third">
			<div class="appRef_CapTitle fontBlack large">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>

		</div>
	</xsl:template>


	<xsl:template match="node()" mode="RenderManagementAppCap">
		<div class="appRef_NarrowColContainer col-xs-3">
			<div class="appRef_NarrowColCap bg-darkblue-100">
				<div class="appRef_CapTitle fontBlack xlarge text-white">
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass">text-white</xsl:with-param>
					</xsl:call-template>
				</div>

				<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>

				<xsl:apply-templates mode="RenderManagementLevel2AppCaps" select="$subAppCaps"> </xsl:apply-templates>
			</div>
		</div>
		<xsl:if test="not(position() = last())">
			<div class="horizSpacer_20px pull-left"/>
		</xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="RenderManagementLevel2AppCaps">
		<div class="appRef_NarrowColSubCap">
			<div class="appRef_CapTitle fontBlack large">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>

		</div>
	</xsl:template>


	<xsl:template match="node()" mode="RenderEnablingAppCap">
		<div class="appRef_WideColCap_Third bg-aqua-20">
			<div class="appRef_CapTitle fontBlack xlarge text-white">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">text-white</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
			<xsl:apply-templates mode="RenderEnablingLevel2AppCaps" select="$subAppCaps"> </xsl:apply-templates>

		</div>
	</xsl:template>


	<xsl:template match="node()" mode="RenderEnablingLevel2AppCaps">
		<div class="appRef_WideColSubCap_Third">
			<div class="appRef_CapTitle fontBlack large">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="RenderApplicationServices">

		<xsl:variable name="relevantAppSvc" select="current()"/>


		<div class="threeColModel_ObjectContainer">
			<div class="threeColModel_ObjectBackgroundColour bg-darkblue-20"/>
			<div class="threeColModel_Object small">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>
			<div class="verticalSpacer_5px backColour7"/>
		</div>
	</xsl:template>


</xsl:stylesheet>
