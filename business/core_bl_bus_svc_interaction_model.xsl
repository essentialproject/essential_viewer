<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>

	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<!--<xsl:include href="../information/menus/core_info_view_menu.xsl" />
	<xsl:include href="../business/menus/core_product_type_menu.xsl" />-->

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
	<!-- 19 Sep 11 New Provider Model Template for Viewer 3.0 -->

	<!-- param1 = the id of the Business Service (Product Type) that is being described -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_View', 'Product_Type')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allBusServices" select="/node()/simple_instance[type = 'Product_Type']"/>
	<xsl:variable name="allBusServiceUsages" select="/node()/simple_instance[type = 'Static_Product_Type_Usage']"/>
	<xsl:variable name="allInfoViews" select="/node()/simple_instance[type = 'Information_View']"/>
	<xsl:variable name="allProductDependencies" select="/node()/simple_instance[type = ':PTU-DEPENDS_ON-PTU']"/>

	<!-- SET THE VARIABLES ASSOCIATED WITH THE GIVEN BUSINESS SERVICES -->
	<xsl:variable name="currentBusinessService" select="$allBusServices[name = $param1]"/>
	<xsl:variable name="currentBusinessServiceUsages" select="$allBusServiceUsages[own_slot_value[slot_reference = 'static_usage_of_product_type']/value = $param1]"/>
	<xsl:variable name="currentBusinessServiceName" select="$currentBusinessService/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="outputBusinessServiceDependencies" select="$allProductDependencies[own_slot_value[slot_reference = ':FROM']/value = $currentBusinessServiceUsages/name]"/>
	<xsl:variable name="outputBusinessServiceUsages" select="$allBusServiceUsages[name = $outputBusinessServiceDependencies/own_slot_value[slot_reference = ':TO']/value]"/>
	<xsl:variable name="outputBusinessServices" select="$allBusServices[name = $outputBusinessServiceUsages/own_slot_value[slot_reference = 'static_usage_of_product_type']/value]"/>
	<xsl:variable name="outputInformationViews" select="$allInfoViews[name = $outputBusinessServiceDependencies/own_slot_value[slot_reference = ':ptu_to_ptu_info_views']/value]"/>

	<xsl:variable name="inputBusinessServiceDependencies" select="$allProductDependencies[own_slot_value[slot_reference = ':TO']/value = $currentBusinessServiceUsages/name]"/>
	<xsl:variable name="inputBusinessServiceUsages" select="$allBusServiceUsages[name = $inputBusinessServiceDependencies/own_slot_value[slot_reference = ':FROM']/value]"/>
	<xsl:variable name="inputBusinessServices" select="$allBusServices[name = $inputBusinessServiceUsages/own_slot_value[slot_reference = 'static_usage_of_product_type']/value]"/>
	<xsl:variable name="inputInformationViews" select="$allInfoViews[name = $inputBusinessServiceDependencies/own_slot_value[slot_reference = ':ptu_to_ptu_info_views']/value]"/>


	<!-- set up the colours for the boxes -->
	<xsl:variable name="internalSvcColour" select="' bg-aqua-100'"/>
	<xsl:variable name="externalSvcColour" select="' bg-darkblue-100'"/>
	<xsl:variable name="textColour" select="' text-white'"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('Business Information Model')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Service Interaction Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<style type="text/css">
					.sectionModel{
						min-height: 450px;
					}</style>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body>
				<!-- ADD SCRIPTS FOR CONTEXT POP-UP MENUS -->
				<!--<xsl:call-template name="RenderInfoViewPopUpScript" />
				<xsl:call-template name="RenderProductTypePopUpScript" />-->

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<div class="page-header">
									<h1>
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey">
											<xsl:value-of select="$pageLabel"/>
										</span>
									</h1>
								</div>
							</div>
						</div>

						<!--Setup Description Section-->
						<div id="sectionModel">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-table icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="$currentBusinessServiceName"/>
									</h2>
								</div>
								<p><xsl:value-of select="eas:i18n('The following diagram describes the information assets that are consumed and produced by the')"/>&#160;<strong><xsl:value-of select="$currentBusinessServiceName"/></strong> &#160;<xsl:value-of select="eas:i18n('Business Function/Service')"/>
								</p>
								<xsl:call-template name="BusinessInformationModel"/>
							</div>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>

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
					
					function divHeightHub() {
						// Loop through all the div.dependencyModel_Inbound on the page
						$('.dependencyModel_Hub').each(function(){
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
						   divHeightHub();
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
					 tallestcolumn  = currentHeight-15;  
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
						 $(".dependencyModel_Hub").vAlign();	
					});
				</script>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="BusinessInformationModel">
		<xsl:choose>
			<xsl:when test="(count($inputBusinessServices) = 0) and (count($outputBusinessServices) = 0)">
				<div>
					<em><xsl:value-of select="eas:i18n('No Information Dependencies Mapped for')"/>&#160; <strong><xsl:value-of select="$currentBusinessServiceName"/></strong></em>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="PrintBusinessServiceDependencies"/>
			</xsl:otherwise>
		</xsl:choose>



	</xsl:template>


	<xsl:template name="PrintBusinessServiceDependencies">
		<div id="dependencyModel_KeyContainer">
			<div class="dependencyModel_KeyLabel small">
				<strong><xsl:value-of select="eas:i18n('Legend')"/>:</strong>
			</div>
			<div>
				<xsl:attribute name="class">
					<xsl:value-of select="concat('dependencyModel_KeySample', $internalSvcColour)"/>
				</xsl:attribute>
			</div>
			<div class="dependencyModel_KeyLabel small">
				<xsl:value-of select="eas:i18n('Internal Facing')"/>
			</div>
			<div>
				<xsl:attribute name="class">
					<xsl:value-of select="concat('dependencyModel_KeySample', $externalSvcColour)"/>
				</xsl:attribute>
			</div>
			<div class="dependencyModel_KeyLabel small">
				<xsl:value-of select="eas:i18n('External Facing')"/>
			</div>
		</div>
		<table class="col-xs-12">
			<tbody>
				<!--setup the headers for the digram-->
				<tr>
					<td class="dependencyModel_HeaderBlank col-xs-2">&#160;</td>
					<td class="dependencyModel_HeaderInOutBound col-xs-3">
						<h3 class="text-default">
							<xsl:value-of select="eas:i18n('Inbound')"/>
						</h3>
					</td>
					<td class="dependencyModel_HeaderBlank col-xs-2">&#160;</td>
					<td class="dependencyModel_HeaderInOutBound col-xs-3">
						<h3 class="text-default">
							<xsl:value-of select="eas:i18n('Outbound')"/>
						</h3>
					</td>
					<td class="dependencyModel_HeaderBlank col-xs-2">&#160;</td>
				</tr>
			</tbody>
		</table>


		<div id="dependencyModel_LeftContainer" class="col-xs-5">
			<div class="row">
				<table class="dependencyModel_Table tableWidth-100pc">
					<tbody>
						<xsl:choose>
							<xsl:when test="count($inputBusinessServices) = 0">
								<tr>
									<td class="col-xs-4">
										<div class="dependencyModel_InboundEmpty">&#160;</div>
									</td>
									<td class="dependencyModel_EmptyArrow small col-xs-8">
										<p>
											<em><xsl:value-of select="eas:i18n('No Inbound Business Services Mapped for')"/>&#160; <strong><xsl:value-of select="$currentBusinessServiceName"/></strong></em>
										</p>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<!--setup the inbound services of the diagram-->
								<xsl:apply-templates mode="InputBusinessService" select="$inputBusinessServices"/>
							</xsl:otherwise>
						</xsl:choose>
					</tbody>
				</table>
			</div>
		</div>

		<div id="dependencyModel_CentreContainer" class="col-xs-2">
			<div class="row">
				<table class="dependencyModel_Table tableWidth-100pc">
					<tbody>
						<tr>
							<td class="col-xs-12">
								<xsl:choose>
									<xsl:when test="$currentBusinessService/own_slot_value[slot_reference = 'product_type_sourced_externally']/value = 'true'">
										<xsl:variable name="hubColour" select="concat('dependencyModel_Hub', $externalSvcColour, $textColour)"/>
										<div>
											<xsl:attribute name="class" select="$hubColour"/>
											<xsl:value-of select="$currentBusinessServiceName"/>
										</div>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="hubColour" select="concat('dependencyModel_Hub fontBlack', $internalSvcColour, $textColour)"/>
										<div>
											<xsl:attribute name="class" select="$hubColour"/>
											<!--<xsl:value-of select="$currentBusinessServiceName"/>-->
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="$currentBusinessService"/>
												<xsl:with-param name="anchorClass" select="'text-white'"></xsl:with-param>
											</xsl:call-template>
										</div>
									</xsl:otherwise>
								</xsl:choose>


							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>

		<div id="dependencyModel_RightContainer" class="col-xs-5">
			<div class="row">
				<table class="dependencyModel_Table tableWidth-100pc">
					<tbody>
						<xsl:choose>
							<xsl:when test="count($outputBusinessServices) = 0">
								<tr>
									<td class="dependencyModel_EmptyArrow small col-xs-8">
										<p>
											<em><xsl:value-of select="eas:i18n('No Outbound Business Services Mapped for')"/>&#160; <strong><xsl:value-of select="$currentBusinessServiceName"/></strong></em>
										</p>
									</td>
									<td>
										<div class="dependencyModel_OutboundEmpty col-xs-4">&#160;</div>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<!--setup the outbound services of the diagram-->
								<xsl:apply-templates mode="OutputBusinessService" select="$outputBusinessServices"/>
							</xsl:otherwise>
						</xsl:choose>
					</tbody>
				</table>
			</div>
		</div>



	</xsl:template>

	<xsl:template match="node()" mode="InputBusinessService">
		<xsl:variable name="currentBusServiceUsages" select="$inputBusinessServiceUsages[own_slot_value[slot_reference = 'static_usage_of_product_type']/value = current()/name]"/>
		<xsl:variable name="businessServiceName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="businessServiceIsExternal" select="current()/own_slot_value[slot_reference = 'product_type_sourced_externally']/value"/>
		<xsl:variable name="businessService" select="current()"/>

		<xsl:for-each select="$currentBusServiceUsages">
			<xsl:variable name="currentDependencies" select="$inputBusinessServiceDependencies[own_slot_value[slot_reference = ':FROM']/value = current()/name]"/>
			<xsl:variable name="infoPassed" select="$inputInformationViews[name = $currentDependencies/own_slot_value[slot_reference = ':ptu_to_ptu_info_views']/value]"/>

			<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
			<xsl:if test="position() = 1">
				<xsl:call-template name="PrintOutboundServiceBox">
					<xsl:with-param name="infoCount" select="count($infoPassed)"/>
					<xsl:with-param name="isExternal" select="$businessServiceIsExternal"/>
					<xsl:with-param name="service" select="$businessService"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="count($infoPassed) = 0">
					<td class="dependencyModel_InboundArrow small col-xs-8"/>
					<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$infoPassed">
						<xsl:if test="position() != 1">
							<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
						</xsl:if>
						<td class="dependencyModel_InboundArrow small col-xs-8">
							<strong><xsl:value-of select="eas:i18n('Information')"/>:</strong>
							<xsl:variable name="infoName" select="current()/own_slot_value[slot_reference = 'view_label']/value"/>
							<br/>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
							<!--<a id="{$infoName}" class="context-menu-infoView menu-1">
								<xsl:call-template name="RenderLinkHref">
									<xsl:with-param name="theInstanceID" select="name" />
									<xsl:with-param name="theParam4" select="$param4" />
									<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
								</xsl:call-template>
								<xsl:value-of select="$infoName" />
							</a>-->
						</td>
					</xsl:for-each>
					<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="node()" mode="OutputBusinessService">
		<xsl:variable name="currentBusServiceUsages" select="$outputBusinessServiceUsages[own_slot_value[slot_reference = 'static_usage_of_product_type']/value = current()/name]"/>
		<xsl:variable name="businessService" select="current()"/>
		<xsl:variable name="businessServiceIsExternal" select="current()/own_slot_value[slot_reference = 'product_type_sourced_externally']/value"/>

		<xsl:for-each select="$currentBusServiceUsages">
			<xsl:variable name="currentDependencies" select="$outputBusinessServiceDependencies[own_slot_value[slot_reference = ':TO']/value = current()/name]"/>
			<xsl:variable name="infoPassed" select="$outputInformationViews[name = $currentDependencies/own_slot_value[slot_reference = ':ptu_to_ptu_info_views']/value]"/>

			<xsl:choose>
				<xsl:when test="count($infoPassed) = 0">
					<tr>
						<td class="dependencyModel_OutboundArrow small col-xs-8"/>
						<xsl:call-template name="PrintOutboundServiceBox">
							<xsl:with-param name="infoCount" select="1"/>
							<xsl:with-param name="isExternal" select="$businessServiceIsExternal"/>
							<xsl:with-param name="service" select="$businessService"/>
						</xsl:call-template>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$infoPassed">
						<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
						<td class="dependencyModel_OutboundArrow small col-xs-8">
							<strong><xsl:value-of select="eas:i18n('Information')"/>:</strong>
							<xsl:variable name="infoName" select="current()/own_slot_value[slot_reference = 'view_label']/value"/>
							<br/>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
							<!--<a id="{$infoName}" class="context-menu-infoView menu-1">
								<xsl:call-template name="RenderLinkHref">
									<xsl:with-param name="theInstanceID" select="name" />
									<xsl:with-param name="theParam4" select="$param4" />
									<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
								</xsl:call-template>
								<xsl:value-of select="$infoName" />
							</a>-->
						</td>
						<xsl:if test="position() = 1">
							<xsl:call-template name="PrintOutboundServiceBox">
								<xsl:with-param name="infoCount" select="count($infoPassed)"/>
								<xsl:with-param name="isExternal" select="$businessServiceIsExternal"/>
								<xsl:with-param name="service" select="$businessService"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:for-each>
	</xsl:template>


	<xsl:template name="PrintInboundServiceBox">
		<xsl:param name="infoCount"/>
		<xsl:param name="service"/>
		<xsl:param name="isExternal"/>

		<!-- Get the name of the service -->
		<xsl:variable name="serviceName" select="$service/own_slot_value[slot_reference = 'name']/value"/>

		<td class="col-xs-4">
			<xsl:attribute name="rowspan" select="$infoCount"/>
			<xsl:choose>
				<xsl:when test="$isExternal = 'true'">
					<xsl:variable name="boxColour" select="concat('dependencyModel_Inbound fontBlack', $externalSvcColour, $textColour)"/>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$service"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass" select="'noUL'"/>
						<xsl:with-param name="divClass" select="$boxColour"/>
						<xsl:with-param name="displayString" select="$serviceName"/>
					</xsl:call-template>
					<!--<a id="{$serviceName}" class="context-menu-prodType menu-1">
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theInstanceID">
								<xsl:value-of select="$service/name" />
							</xsl:with-param>
							<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
							<xsl:with-param name="theParam4" select="$param4" />
							<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
							<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour" />
							<xsl:value-of select="$serviceName" />
						</div>
					</a>-->
					<!--	<a>
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theXSL" select="'business/core_bl_bus_inf_model.xsl'"/>
							<xsl:with-param name="theInstanceID" select="$service/name"/>
							<xsl:with-param name="theParam4" select="$param4"/> 
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour"/>
							<xsl:value-of select="$serviceName"/>
						</div>
					</a>  -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="boxColour" select="concat('dependencyModel_Inbound fontBlack', $internalSvcColour, $textColour)"/>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$service"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass" select="'noUL'"/>
						<xsl:with-param name="divClass" select="$boxColour"/>
						<xsl:with-param name="displayString" select="$serviceName"/>
					</xsl:call-template>
					<!--<a id="{$serviceName}" class="context-menu-prodType menu-1">
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theInstanceID">
								<xsl:value-of select="$service/name" />
							</xsl:with-param>
							<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
							<xsl:with-param name="theParam4" select="$param4" />
							<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
							<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour" />
							<xsl:value-of select="$serviceName" />
						</div>
					</a>-->
					<!--	<a>
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theXSL" select="'business/core_bl_bus_inf_model.xsl'"/>
							<xsl:with-param name="theInstanceID" select="$service/name"/>
							<xsl:with-param name="theParam4" select="$param4"/> 
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour"/>
							<xsl:value-of select="$serviceName"/>
						</div>
					</a>  -->
				</xsl:otherwise>
			</xsl:choose>
		</td>

	</xsl:template>

	<xsl:template name="PrintOutboundServiceBox">
		<xsl:param name="infoCount"/>
		<xsl:param name="service"/>
		<xsl:param name="isExternal"/>

		<!-- Get the name of the service -->
		<xsl:variable name="serviceName" select="$service/own_slot_value[slot_reference = 'name']/value"/>
		<td class="col-xs-4">
			<xsl:attribute name="rowspan" select="$infoCount"/>
			<xsl:choose>
				<xsl:when test="$isExternal = 'true'">
					<xsl:variable name="boxColour" select="concat('dependencyModel_Outbound fontBlack', $externalSvcColour, $textColour)"/>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$service"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass" select="'noUL'"/>
						<xsl:with-param name="divClass" select="$boxColour"/>
						<xsl:with-param name="displayString" select="$serviceName"/>
					</xsl:call-template>
					<!--<a id="{$serviceName}" class="context-menu-prodType menu-1">
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theInstanceID">
								<xsl:value-of select="$service/name" />
							</xsl:with-param>
							<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
							<xsl:with-param name="theParam4" select="$param4" />
							<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
							<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour" />
							<xsl:value-of select="$serviceName" />
						</div>
					</a>-->
					<!--		<a>
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theXSL" select="'business/core_bl_bus_inf_model.xsl'"/>
							<xsl:with-param name="theInstanceID" select="$service/name"/>
							<xsl:with-param name="theParam4" select="$param4"/> 
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour"/>
							<xsl:value-of select="$serviceName"/>	
						</div>
					</a>  -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="boxColour" select="concat('dependencyModel_Outbound fontBlack', $internalSvcColour, $textColour)"/>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$service"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass" select="'noUL'"/>
						<xsl:with-param name="divClass" select="$boxColour"/>
						<xsl:with-param name="displayString" select="$serviceName"/>
					</xsl:call-template>
					<!--<a id="{$serviceName}" class="context-menu-prodType menu-1">
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theInstanceID">
								<xsl:value-of select="$service/name" />
							</xsl:with-param>
							<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
							<xsl:with-param name="theParam4" select="$param4" />
							<!-\- pass the id of the taxonomy term used for scoping as parameter 4-\->
							<!-\- <xsl:with-param name="theUserParams">tax=Organisation&amp;syn=Fred</xsl:with-param> -\->
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour" />
							<xsl:value-of select="$serviceName" />
						</div>
					</a>-->
					<!--	<a>
						<xsl:call-template name="RenderLinkHref">
							<xsl:with-param name="theXSL" select="'business/core_bl_bus_inf_model.xsl'"/>
							<xsl:with-param name="theInstanceID" select="$service/name"/>
							<xsl:with-param name="theParam4" select="$param4"/> 
						</xsl:call-template>
						<div>
							<xsl:attribute name="class" select="$boxColour"/>
							<xsl:value-of select="$serviceName"/>
						</div>
					</a>  -->
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>


</xsl:stylesheet>
