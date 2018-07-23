<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<!--<xsl:include href="../application/menus/core_app_service_menu.xsl" />-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

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


	<!-- param1 = the id of the Application Service that is being described -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Business_Role')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="currentAppService" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="currentAppServiceName" select="$currentAppService/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="relevenatAppSvc2Procs" select="/node()/simple_instance[own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value = $param1]"/>
	<xsl:variable name="relevantProcesses" select="/node()/simple_instance[name = $relevenatAppSvc2Procs/own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value]"/>
	<xsl:variable name="relevantRoles" select="/node()/simple_instance[name = $relevantProcesses/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>

	<xsl:variable name="genericPageLabel">
		<xsl:value-of select="eas:i18n('Application Service Stakeholder Model')"/>
	</xsl:variable>
	<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $currentAppServiceName, ')')"/>


	<!-- set up the colours for the boxes -->
	<xsl:variable name="appSvcColour" select="' bg-aqua-100'"/>
	<xsl:variable name="roleColour" select="' bg-darkblue-100'"/>
	<xsl:variable name="textColour" select="' text-white'"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderAppServicePopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">
											<xsl:value-of select="eas:i18n('Application Service Stakeholder Model for')"/>&#160;<span class="text-primary">
												<xsl:value-of select="$currentAppServiceName"/>
											</span>
										</span>
									</h1>
								</div>
							</div>
						</div>

						<!--Setup Model Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Stakeholder Model')"/>
							</h2>

							<p><xsl:value-of select="eas:i18n('The following diagram lists the different logical business roles that interact with the')"/>&#160;<strong><xsl:value-of select="$currentAppServiceName"/></strong>&#160;<xsl:value-of select="eas:i18n('Application Service')"/>.</p>

							<div class="content-section">
								<xsl:call-template name="Model"/>
							</div>

							<hr/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>


				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script type="text/javascript">
				function divHeight() {
					// Loop through all the div.dependencyModel_Inbound on the page
					$('.dependencyModel_Inbound,.dependencyModel_Outbound,.dependencyModel_Hub').each(function(){
					    // Get their parent td's height
					    var tdHeight = $(this).closest('td').height();
					
					    // Set the div's height to their parent td's height
					    $(this).height(tdHeight);
					});
				}
				
				$(document).ready(function() {
					   divHeight();
					});

				</script>
				<script>
					function setEqualHeight(columns)  
					 {  
					 var tallestcolumn = 0;  
					 columns.each(  
					 function()  
					 {  
					 currentHeight = $(this).height()-25;  
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

			</body>
		</html>
	</xsl:template>

	<xsl:template name="Model">
		<xsl:choose>
			<xsl:when test="count($relevantRoles) = 0">
				<em><xsl:value-of select="eas:i18n('There are no Business Roles captured for the')"/>&#160;<strong><xsl:value-of select="$currentAppServiceName"/></strong>&#160;<xsl:value-of select="eas:i18n('Application Service')"/>.</em>
			</xsl:when>
			<xsl:otherwise>
				<div id="dependencyModel_KeyContainer">
					<div class="dependencyModel_KeyLabel small">
						<strong>Key:</strong>
					</div>
					<div>
						<xsl:attribute name="class">
							<xsl:value-of select="concat('dependencyModel_KeySample', $roleColour)"/>
						</xsl:attribute>
					</div>
					<div class="dependencyModel_KeyLabel small">
						<xsl:value-of select="eas:i18n('Business Role')"/>
					</div>
					<div>
						<xsl:attribute name="class">
							<xsl:value-of select="concat('dependencyModel_KeySample', $appSvcColour)"/>
						</xsl:attribute>
					</div>
					<div class="dependencyModel_KeyLabel small">
						<xsl:value-of select="eas:i18n('Application Service')"/>
					</div>
				</div>
				<table>
					<tbody>
						<!--setup the headers for the digram-->
						<tr>
							<td class="alignCentre vAlignMiddle col-xs-4">
								<h3 class="text-default">
									<xsl:value-of select="eas:i18n('Business Role')"/>
								</h3>
							</td>
							<td class="col-xs-4">&#160;</td>
							<td class="col-xs-4 alignCentre vAlignMiddle">
								<h3 class="text-default">
									<xsl:value-of select="eas:i18n('Application Service')"/>
								</h3>
							</td>
						</tr>
					</tbody>
				</table>
				<div id="dependencyModel_LeftContainer" class="pull-left col-xs-8">
					<div class="row">
						<table class="dependencyModel_Table alignCentre">
							<tbody>
								<xsl:apply-templates mode="Business_Role" select="$relevantRoles">
									<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
								</xsl:apply-templates>
							</tbody>
						</table>
					</div>
				</div>

				<div id="dependencyModel_RightContainer" class="pull-left col-xs-4">
					<xsl:variable name="appSvcFormat" select="concat('dependencyModel_Hub fontBlack', $appSvcColour, $textColour)"/>
					<div class="row">
						<table class="dependencyModel_Table">
							<tbody>
								<tr>
									<td class="col-xs-4">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentAppService"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="divClass" select="$appSvcFormat"/>
										</xsl:call-template>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="node()" mode="Business_Role">
		<xsl:variable name="roleFormat" select="concat('dependencyModel_Inbound fontBlack', $roleColour, $textColour)"/>
		<xsl:variable name="roleName" select="own_slot_value[slot_reference = 'name']/value"/>
		<tr>
			<td class="col-xs-4">
				<div>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="divClass" select="$roleFormat"/>
					</xsl:call-template>
				</div>
			</td>
			<td class="dependencyModel_OutboundArrow col-xs-4">&#160;</td>
		</tr>
	</xsl:template>



</xsl:stylesheet>
