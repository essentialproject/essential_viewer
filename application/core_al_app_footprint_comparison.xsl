<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Capability', 'Application_Service', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
	

	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>

	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')]"/>
	<xsl:variable name="allAppCodebases" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
	<xsl:variable name="allAppDeliveryModels" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_application_provider']/value = $allApps/name]"/>
	
	<xsl:variable name="allAppCaps" select="/node()/simple_instance[type = 'Application_Capability']"/>
	
	<xsl:variable name="allAppServices" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="L0AppCaps" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $refLayers/name]"/>
	<xsl:variable name="L1AppCaps" select="$allAppCaps[name = $L0AppCaps/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
	

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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Footprint Comparison</title>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				
				<xsl:call-template name="refModelLegendInclude"/>
				<xsl:call-template name="appRefModelComparisonInclude"/>
				
				<script type="text/javascript">
					
					var leftAppId, rightAppId, bothAppIds, leftApp, rightApp, bothApps, appDetailTemplate, noOverlayARMLegend;
						  	
				  	// the list of JSON objects representing the applications in use across the enterprise
				  	var applications = {
						applications: [<xsl:apply-templates select="$allApps" mode="getApplications"><xsl:sort select="own_slot_value[slot_reference = 'name']/value"></xsl:sort></xsl:apply-templates>
				    	]
				  	};

					
					// the JSON objects for the Application Reference Model (ARM)
				  	var armData = {
				  		left: [
				  			<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderAppCaps"/>
				  		],
				  		middle: [
				  			<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderAppCaps"/>
				  		],
				  		right: [
				  			<xsl:apply-templates select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderAppCaps"/>
				  		],
				  	
				  	};
					
					
				  	
				  	// the JSON objects for the Application Services and Applications that implement Application Capabilities
				  	var appCapDetails = [
				  		<xsl:apply-templates select="$L1AppCaps" mode="AppCapDetails"/>
				  	];
  	
				  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
			
					<!-- START PAGE DRAWING FUNCTIONS -->
					//funtion to set the ARM overlay
					function setAppCapComparisonOverlay() {
						var thisAppCapBlobId, thisAppCapId, thisAppCap;
						
						<!--var appOverlay = $('input:radio[name=appOverlay]:checked').val();
						if(appOverlay =='none') {
							//show basic overlay legend
							$("#armLegend").html(noOverlayARMLegend);
						} else {
							//show rag overlay legend
							$("#armLegend").html(ragOverlayLegend);
						}-->
						
						$('.appRefModel-blob').each(function() {
							thisAppCapBlobId = $(this).attr('id');
							thisAppCapId = thisAppCapBlobId.substring(0, (thisAppCapBlobId.length - 5));
							thisAppCap = getObjectById(appCapDetails, "id", thisAppCapId);
							//console.log('AppCapId: ' + thisAppCapId);
							refreshARMComparisonDetailPopup(thisAppCap);
						});
					
					}
					
					//function to refresh the table of supporting Applications Services associated with a given application capability
					function refreshARMComparisonDetailPopup(theAppCap) {
						var appServices = theAppCap.appServices;
						var anAppSvcDetail, appSvcAppIDList, anAppSvc, appCapBlobId, appCapStyle, thisAppCount, appCapAnchor;
						var appCount = 0;
						var appSvcDetailList = {};
						var leftAppImpl = false;
						var rightAppImpl = false;
						var thisLeftAppImpl, thisRightAppImpl;
						appSvcDetailList["appCapApps"] = [];
						
						var appCapBlobId = '#' + theAppCap.id + '_blob';
						var infoButtonId = '#' + theAppCap.id + '_info';
						var appCapAnchor = $(appCapBlobId).children().first().children().first();
						
											
						for( var i = 0; i &lt; appServices.length; i++ ){
							anAppSvc = appServices[i];
							appSvcAppIDList = anAppSvc.apps;
							
							
							var relevantAppIds = getArrayIntersect([appSvcAppIDList, bothAppIds]);
							var relevantApps = getObjectsByIds(bothApps, "id", relevantAppIds);
							thisAppCount = relevantApps.length;
							appCount = appCount + thisAppCount;
							
							if(relevantAppIds.includes(leftAppId)) {
								leftAppImpl = true;
								thisLeftAppImpl = true;
							} else {
								thisLeftAppImpl = false;
							}
							
							if(relevantAppIds.includes(rightAppId)) {
								rightAppImpl = true;
								thisRightAppImpl = true;
							} else {
								thisRightAppImpl = false;
							}
							
							if(thisAppCount > 0) {
								//console.log('Setting Apps for: ' + appCapBlobId + ', count = ' + thisAppCount);
								anAppSvcDetail = {};
								anAppSvcDetail["link"] = anAppSvc.link;
								anAppSvcDetail["description"] = anAppSvc.description;
								anAppSvcDetail["leftAppImpl"] = thisLeftAppImpl;
								anAppSvcDetail["rightAppImpl"] = thisRightAppImpl;
								
								appSvcDetailList.appCapApps.push(anAppSvcDetail);
							} 

						}
						

						var appCapStyle;
						appCapAnchor.removeClass();
						if(appCount > 0) {
							if(leftAppImpl &amp;&amp; rightAppImpl) {
								appCapStyle = 'appRefModel-blob bothAppColour';
							} else if(leftAppImpl) {
								appCapStyle = 'appRefModel-blob leftAppColour';
							} else if(rightAppImpl) {
								appCapStyle = 'appRefModel-blob rightAppColour';
							}
							
							appCapAnchor.attr("class", "text-white context-menu-appCapGenMenu");
							$(appCapBlobId).attr("class", appCapStyle);
							$(infoButtonId).attr("class", "refModel-blob-info");
							
							var detailTableBodyId = '#' + theAppCap.id + '_app_rows';
							$(detailTableBodyId).html(appDetailTemplate(appSvcDetailList));
						} else {
							appCapStyle = 'appRefModel-blob noAppColour';
							appCapAnchor.attr("class", "text-midgrey context-menu-appCapGenMenu");
							$(appCapBlobId).attr("class", appCapStyle);
							$(infoButtonId).attr("class", "refModel-blob-info hiddenDiv");
						}
						
					}
		
					
					//function to draw the relevant dashboard components based on the currently selected Data Objects
					function drawDashboard() {
						
						//Update the ARM Model
						setAppCapComparisonOverlay();					

					}
						
					
					$(document).ready(function(){	
					
						<!--$('h2').click(function(){
							$(this).next().slideToggle();
						});-->
						
						var appSelectFragment   = $("#app-select-template").html();
						var appSelectTemplate = Handlebars.compile(appSelectFragment);
						$("#leftAppList").html(appSelectTemplate(applications));
						$("#rightAppList").html(appSelectTemplate(applications));
						
						//INITIALISE THE APP DROP DOWN LISTS
						$('#leftAppList').select2({
							placeholder: "Select an Application",
							theme: "bootstrap"
						});

						$('#rightAppList').select2({
							placeholder: "Select an Application",
							theme: "bootstrap"
						});
						
						$('#leftAppList').on('change', function (evt) {
						  leftAppId = $(this).select2("val");
						  leftApp = getObjectById(applications.applications, "id", leftAppId);
						  $("th.leftAppHeading" ).html(leftApp.link);
						  if((leftAppId != null) &amp;&amp; (rightAppId != null)) {
						  	bothAppIds = [leftAppId, rightAppId];
						  	bothApps = [leftApp, rightApp];
						  	drawDashboard();
						  }
						});
						
						$('#rightAppList').on('change', function (evt) {
						  rightAppId = $(this).select2("val");
						  rightApp = getObjectById(applications.applications, "id", rightAppId);
						  $("th.rightAppHeading" ).html(rightApp.link);
						  if((leftAppId != null) &amp;&amp; (rightAppId != null)) {
						  	bothAppIds = [leftAppId, rightAppId];
						  	bothApps = [leftApp, rightApp];
						  	drawDashboard();
						  }
						});
						
						
						
						<!-- SET UP THE APP REF MODEL LEGEND -->
						<!--var legendFragment = $("#no-overlay-legend-template").html();
						var legendTemplate = Handlebars.compile(legendFragment);
						var legendLabels = {};
						legendLabels["inScope"] = 'Applications in Use';
						noOverlayARMLegend = legendTemplate(legendLabels);-->
											
					
						//initialise the ARM model
						var armFragment   = $("#arm-template").html();
						var armTemplate = Handlebars.compile(armFragment);
						$("#appRefModelContainer").html(armTemplate(armData));
						
						var appDetailFragment = $("#arm-appcap-comparison-popup-template").html();
						appDetailTemplate = Handlebars.compile(appDetailFragment);
						
						//drawDashboard();
					});
								  	
				</script>
				<xsl:call-template name="refModelStyles"/>
				<style>
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}
					
					h2:hover{
						cursor: pointer;
					}
					
					.popover{
						max-width: 800px;
					}
					
					.leftAppColour{
						background-color: #24A5F4;
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
						}
						
					.rightAppColour{
						background-color: #1FC1B4;
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.bothAppColour{
						background-color: #7438A4;
						color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					
					.noAppColour{
						background-color: #fff;
						-webkit-transition: all 0.5s ease;
						-moz-transition: all 0.5s ease;
						-o-transition: all 0.5s ease;
						-ms-transition: all 0.5s ease;
						transition: all 0.5s ease;
					}
					.appRefModel-blob a {
						color: #999;
					}
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Application Footprint Comparison</span>
								</h1>
							</div>
						</div>


						<!--<xsl:call-template name="RenderDashboardBusUnitFilter"/>-->
						<xsl:call-template name="appSection"/>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
						
						$('.fa-info-circle').click(function() {
							$('[role="tooltip"]').remove();
							return false;
						});
						$('.fa-info-circle').popover({
							container: 'body',
							html: true,
							trigger: 'click',
							placement: 'auto',
							content: function(){
								return $(this).next().html();
							}
						});
						
					});
				</script>
			</body>
		</html>
	</xsl:template>
	
	

	<xsl:template name="appSection">
		<script id="app-select-template" type="text/x-handlebars-template">
			<option/>
			{{#applications}}
		  		<option class="bg-brightred-20">
		  			<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
		  			{{name}}
		  		</option>
			{{/applications}}
		</script>
		<xsl:call-template name="appRefModelInclude"/>
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary"><xsl:value-of select="eas:i18n('Application Capability Footprint')"/></h2>
				<div class="row">
					<script>
						$(document).ready(function() {
						 	$('.matchHeight1').matchHeight();
						});
					</script>
					<div class="col-xs-6 col-lg-6">
						<label>
							<span>Application 1</span>
						</label>
						<select id="leftAppList" class="form-control" style="width:100%"/>	
						<div class="leftAppColour" style="width:100%">&#160;</div>
					</div>
					<div class="col-xs-6 col-lg-6">
						<label>
							<span>Application 2</span>
						</label>
						<select id="rightAppList" class="form-control" style="width:100%"/>	
						<div class="rightAppColour" style="width:100%">&#160;</div>
					</div>
					<div class="col-xs-12">
						<div class="bothAppColour top-10" style="width:100%; text-align:center;"><strong><xsl:value-of select="eas:i18n('Both')"/></strong></div>
						<hr/>
					</div>
					<!--<div class="col-xs-6 bottom-15" id="armLegend">
						<div class="keyTitle">Legend:</div>
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide bg-brightgreen-120"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide bg-darkgrey"/>
						<div class="keyLabel">Undefined</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayNone" value="none" checked="checked" onchange="setAppCapabilityOverlay()"/>None</label>
							<label class="radio-inline"><input type="radio" name="appOverlay" id="appOverlayDup" value="duplication" onchange="setAppCapabilityOverlay()"/>Duplication</label>
							<!-\-<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayStatus" value="status" onchange="setTechCapabilityOverlay()"/>Legacy Risk</label>-\->
						</div>
					</div>-->
					<div class="simple-scroller" id="appRefModelContainer">
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	
	
	
	
	
	
	<!-- APPLICATION REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderAppCaps" match="node()">
		<xsl:variable name="appCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="appCapDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="appCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-darkgrey</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"></xsl:variable>
		
		{
		id: "<xsl:value-of select="current()/name"/>",
		name: "<xsl:value-of select="$appCapName"/>",
		description: "<xsl:value-of select="eas:renderJSText($appCapDescription)"/>",
		link: "<xsl:value-of select="$appCapLink"/>",
		childAppCaps: [
			<xsl:apply-templates select="$childAppCaps" mode="RenderChildAppCaps"/>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildAppCaps">
		<xsl:variable name="appCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="appCapDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="appCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-darkgrey</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		{
		id: "<xsl:value-of select="current()/name"/>",
		name: "<xsl:value-of select="$appCapName"/>",
		link: "<xsl:value-of select="$appCapLink"/>",
		description: "<xsl:value-of select="eas:renderJSText($appCapDescription)"/>"
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="AppCapDetails">
		<xsl:variable name="appServices" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
		
		{
			id: "<xsl:value-of select="current()/name"/>",
			appServices: [	
				<xsl:apply-templates select="$appServices" mode="RenderAppServices"/>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderAppServices">
		<xsl:variable name="appServiceName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="appSvcDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="appServiceLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = current()/name]"/>
		<xsl:variable name="thisApps" select="$allApps[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		
		{
		id: "<xsl:value-of select="current()/name"/>",
		name: "<xsl:value-of select="$appServiceName"/>",
		link: "<xsl:value-of select="$appServiceLink"/>",
		description: "<xsl:value-of select="eas:renderJSText($appSvcDescription)"/>",
		apps: [<xsl:for-each select="$thisApps">"<xsl:value-of select="current()/name"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="getApplications">
		<xsl:variable name="thisAppCodebase" select="$allAppCodebases[name = current()/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
		<xsl:variable name="thisAppDeliveryModel" select="$allAppDeliveryModels[name = current()/own_slot_value[slot_reference = 'ap_delivery_model']/value]"/>

		
		{
		id: "<xsl:value-of select="name"/>",
		name: "<xsl:value-of select="own_slot_value[slot_reference='name']/value"/>",
		description: "<xsl:value-of select="eas:renderJSText(own_slot_value[slot_reference='description']/value)"/>",
		link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		codebase: "<xsl:value-of select="$thisAppCodebase/name"/>",
		delivery: "<xsl:value-of select="$thisAppDeliveryModel/name"/>"
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	

</xsl:stylesheet>
