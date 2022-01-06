<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->
<xsl:stylesheet version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:functx="http://www.functx.com" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
<xsl:import href="../common/core_js_functions.xsl"/>
<xsl:import href="../common/core_el_ref_model_include.xsl"/>
<xsl:include href="../common/core_roadmap_functions.xsl"/>
<xsl:include href="../common/core_doctype.xsl"/>
<xsl:include href="../common/core_common_head_content.xsl"/>
<xsl:include href="../common/core_header.xsl"/>
<xsl:include href="../common/core_footer.xsl"/>
<xsl:include href="../common/datatables_includes.xsl"/>
<xsl:include href="../common/core_external_doc_ref.xsl"/>
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


	<xsl:variable name="appCategoryTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Application Capability Category')]"/>
	<xsl:variable name="allTaxTerms" select="/node()/simple_instance[(own_slot_value[slot_reference = 'term_in_taxonomy']/value = $appCategoryTaxonomy/name)]"/>

	<xsl:variable name="sharedAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = 'Shared')]"/>
	<xsl:variable name="coreAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = 'Core')]"/>
	<xsl:variable name="manageAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = 'Management')]"/>
	<xsl:variable name="foundationAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = 'Foundation')]"/>
	<xsl:variable name="enablingAppCapType" select="$allTaxTerms[(own_slot_value[slot_reference = 'name']/value = 'Enabling')]"/>

	<!--<xsl:variable name="customCodeBase" select="/node()/simple_instance[(type='Codebase_Status') and (own_slot_value[slot_reference='name']/value = 'Custom')]"/>
	<xsl:variable name="vendorCodeBase" select="/node()/simple_instance[(type='Codebase_Status') and (own_slot_value[slot_reference='name']/value = 'Vendor')]"/>-->


	<xsl:variable name="allAppCaps" select="/node()/simple_instance[(type = 'Application_Capability')]"/>
	<xsl:variable name="allAppServices" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $allAppCaps/name]"/>
	<xsl:variable name="allAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $allAppServices/name]"/>
	<xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="allLifecycleStatustoShow" select="$allLifecycleStatus[(own_slot_value[slot_reference='enumeration_sequence_number']/value &gt; -1) or not(own_slot_value[slot_reference='enumeration_sequence_number']/value)]"/>
	<xsl:variable name="allAppsPreFilter" select="/node()/simple_instance[name = $allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allApps" select="$allAppsPreFilter[own_slot_value[slot_reference='lifecycle_status_application_provider']/value=$allLifecycleStatustoShow/name]"></xsl:variable>
	
	<xsl:variable name="allAppFamiliess" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'type_of_application']/value]"/>
	<xsl:variable name="allActor2Role" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="elementStyle" select="/node()/simple_instance[type = 'Element_Style']"/>
	<xsl:variable name="allAppStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $allAppProRoles/name]"/>
	

	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>

	<!--All Actors who use Apps-->
	<xsl:variable name="allAppUserOrgs" select="/node()/simple_instance[name = $appOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	 
	<xsl:variable name="businessCapsAppsMart" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"/>
	<xsl:variable name="businessAppsMart" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"/>


	<xsl:variable name="allRoadmapInstances" select="$allApps"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>	
 

	<xsl:template match="knowledge_base">
			<xsl:variable name="apiPathBusinessCapsAppsMart">
					<xsl:call-template name="GetViewerAPIPath">
						<xsl:with-param name="apiReport" select="$businessCapsAppsMart"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="apiPathBusinessAppsMart">
					<xsl:call-template name="GetViewerAPIPath">
						<xsl:with-param name="apiReport" select="$businessAppsMart"/>
					</xsl:call-template>
				</xsl:variable>
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
				<script src="js/jquery-migrate-1.4.1.min.js" type="text/javascript"/>
				<script src="js/jquery.tools.min.js" type="text/javascript"/>
				<style>
					.appRef_container{
					    padding-bottom: 20px;
					    float: left;
					    box-sizing: content-box;
					}
					
					.appRef_NarrowColContainer{
					    float: left;
					}
					
					.appRef_NarrowColCap{
					    width: 100%;
					    min-height: 100px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    padding: 10px 10px 10px 10px;
					    float: left;
					    position: relative;
					}
					
					.appRef_NarrowColSubCap{
					    min-height: 50px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    background-color: #fff;
					    padding: 10px 0 0 10px;
					    margin: 0 10px 10px 0;
					    float: left;
					    clear: both;
					    position: relative;
					    width: 100%;
					}
					
					.appRef_WideColContainer{
					    float: left;
					}
					
					.appRef_WideColCap{
					    width: 100%;
					    min-height: 100px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    padding: 10px 10px 0 10px;
					    float: left;
					    clear: both;
					    position: relative;
					}
					
					.appRef_WideColCap_Half{
					    width: 100%;
					    min-height: 100px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    padding: 10px 0 0 10px;
					    float: left;
					    margin: 0 20px 10px 0;
					    position: relative;
					}
					
					.appRef_WideColCap_Third{
					    width: 100%;
					    min-height: 100px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    padding: 10px 0 0 10px;
					    float: left;
					    margin: 0 20px 10px 0;
					    position: relative;
					}
					
					.appRef_WideColSubCap_Full{
					    width: 100%;
					    min-height: 80px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    background-color: #fff;
					    padding: 10px 0 0 10px;
					    margin: 0 10px 10px 0;
					    float: left;
					    position: relative;
					}
					
					.appRef_WideColSubCap_Half{
					    width: 100%;
					    min-height: 80px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    background-color: #fff;
					    padding: 10px 0 0 10px;
					    float: left;
					    margin: 0 10px 10px 0;
					    position: relative;
					}
					
					.appRef_WideColSubCap_Third{
					    width: 100%;
					    min-height: 80px;
					    border-radius: 10px;
					    border: 1px solid #aaa;
					    background-color: #fff;
					    padding: 10px 0 0 10px;
					    float: left;
					    margin: 0 10px 10px 0;
					    position: relative;
					}
					
					.appRef_WideColCap_ThirdsContainer{
					    float: left;
					    padding: 10px 0 0px 10px;
					    float: left;
					    border-radius: 10px;
					    margin: 0 20px 0px 0;
					    position: relative;
					}
					
					.appRef_AppContainer{
					    width: 100%;
					    height: 40px;
					    float: left;
					    padding: 5px;
					    border: 1px solid #aaa;
					    text-align: center;
					    margin: 0 5px 5px 0;
					    display: flex;
					    align-items: center;
					    justify-content: center;
					}
					
					.appRef_CapTitle{
					    margin-bottom: 8px;
					}
					
					.threeColModel_ObjectContainer{
					    width: 122px;
					    float: left;
					    margin: 0 5px 5px 0;
					    box-sizing: content-box;
					    line-height: 1.1em;
					}
					
					.threeColModel_NumberHeatmap,
					.threeColModel_NumberHeatmapAlt{
					    position: absolute;
					    width: 122px;
					    height: 52px;
					    max-height: 52px;
					    font-size: 36px;
					    z-index: 0;
					    box-sizing: content-box;
					    display: flex;
					    align-items: center;
					    justify-content: center;
					}
					
					.threeColModel_NumberHeatmap{
					    opacity: 0.6;
					}
					
					.noOpacity{
					    opacity: 1.0;
					}
					
					.threeColModel_ObjectBackgroundColour{
					    position: absolute;
					    width: 122px;
					    height: 52px;
					    max-height: 52px;
					    font-size: 36px;
					    z-index: 0;
					    opacity: 1.0;
					    box-sizing: content-box;
					}
					
					.threeColModel_Object{
					    position: relative;
					    width: 110px;
					    height: 40px;
					    max-height: 40px;
					    overflow: hidden;
					    border: 1px solid #ccc;
					    padding: 5px;
					    float: left;
					    text-align: center;
					    opacity: 1.0;
					    box-sizing: content-box;
					    line-height: 1.1em;
					    display: flex;
					    align-items: center;
					    justify-content: center;
					}
					
					.threeColModel_ObjectDouble{
					    width: 220px;
					    height: 40px;
					    max-height: 40px;
					    overflow: hidden;
					    border: 1px solid #ccc;
					    padding: 5px;
					    margin: 0 5px 5px 0;
					    float: left;
					    text-align: center;
					    box-sizing: content-box;
					}
					
					.threeColModel_ObjectAlt{
					    width: 180px;
					    height: 20px;
					    max-height: 20px;
					    overflow: hidden;
					    border: 1px solid #ccc;
					    padding: 5px;
					    margin: 0 20px 5px 0;
					    float: left;
					    text-align: center;
					    border-radius: 5px;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.ess-tooltip{
					    background-color: #fff;
					    border: 2px solid #eee;
					    padding: 5px;
					    min-width: 30px;
					    display: none;
					    border-radius: 3px;
					    box-shadow: 0px 3px 5px #ccc;
					    z-index: 5000;
					    text-align: left;
					}
					
					.circleButton{
					    box-sizing: content-box;
					    font-size: 11px;
						border-radius:12px;
						width:16px;
						height:16px;
						padding:2px;
						text-align:center;
						text-align:center;
						border:2px solid #fff;
						position:relative;
						-moz-box-shadow:0px 2px 3px #ccc;
						-webkit-box-shadow:0px 2px 3px #ccc;
						box-shadow:0px 2px 3px #ccc;
						left:3px;
						position:relative; /*required to enable PIE to function*/
						clear:both;
					}
					
					.circleButtonSmall{
					    border-radius: 10px;
					    /*width:20px;*/
					    height: 20px;
					    padding: 4px;
					    text-align: center;
					    border: 2px solid #fff;
					    position: relative;
					    -moz-box-shadow: 0px 2px 3px #ccc;
					    -webkit-box-shadow: 0px 2px 3px #ccc;
					    box-shadow: 0px 2px 3px #ccc;
					    left: 3px;
					    position: relative;
					    clear: both;
					    line-height: 0.8em;
					}
					.buttonLabel{
						height:20px;
						float:left;
						margin-left:10px;
						position:relative;
						top:2px;
						margin-bottom:10px;
					}
					
					.buttonLabelSmall{
					    height: 16px;
					    float: left;
					    margin-left: 10px;
					    position: relative;
					    margin-bottom: 10px;
					    top: 4px;
					}

					.numberPos {
						position: absolute;
						bottom: 1px;
						right: 1px;
						color: #333;
						font-size: 10px;
						text-align: right;
						font-weight: bold;
						background-color: #fff;
						padding: 0px 5px;
						border-radius: 10px;
						border: 1px solid #ddd;
						transition: bottom 0.4s;
					}
					.numberPos:hover {cursor: pointer;}

					.sidenav {
					height: 100%;
					width: 0;
					position: fixed;
					z-index: 1;
					top: 0;
					right: 0;
					background-color: rgba(138, 138, 138, 0.961);
					overflow-x: hidden;
					transition: 0.5s;
					padding-top: 60px;
					}

					.appInfoButton{
							position:relative;
							right: -20px;
					}

					.containList{
						border:1pt solid #d3d3d3;
						border-radius:4px;
						margin:3px;
						padding:3px;
						background-color: #fff;
					}

					.sidenav a:hover {
					color: #f1f1f1;
					}

					.sidenav .closebtn {
					color:red;
					top:-2px;
					font-size:1.1em;
					 
					}

					.closebtnBox{
					position: relative;
					top: -40px;
					padding-bottom:2px;
					padding-left:4px;
					width:20px;
					height:20px; 
					border-radius:3px;
					margin-left: 5px;
					background-color:#fff;
					}

					.stakeholders{
						font-size:0.8em
					}
					.scrollable {
						width: 100%;
						max-height: 30px;
						margin: 0;
						padding: 0;
						overflow: auto;
					}
					@media screen and (max-height: 450px) {
					.sidenav {padding-top: 15px;} 
					}
					.innerNav {padding:8px}
					.appName{ font-size:10pt;
							text-align:left}
					.blkText {font-color:#000 !important}		
				</style>
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>

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
				<script>
					$(document).ready(function() {													
					// initialize tooltip
					$(".threeColModel_ObjectContainer").tooltip({
					
					// tweak the position
					offset: [-20, -30],							   
					predelay: '400',
					delay: '500',
					relative: 'true',							   
					position: 'bottom',	
					opacity: '0.9',							
					// use the "fade" effect
					effect: 'fade'
					
					// add dynamic plugin with optional configuration for bottom edge
					}).dynamic({ bottom: { direction: 'down', bounce: true } });
					
					});
				</script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"/>
				<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
				
					<div class="clearfix"></div>
				</div>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12 col-sm-6">
								<div class="page-header">
									<h1 id="viewName">
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Current State Model')"/></span>
										 
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
								<h2 class="text-primary"><xsl:value-of select="eas:i18n('Model')"/></h2>
							</div>
							<div id="appSidenav" class="sidenav">
								<div class="innerNav">
									
									<div id="appsList"/>
								</div>	
							</div>
							<div class="content-section">
								
								<p><xsl:value-of select="eas:i18n('The Application Current State Model provides a high level overview of the key application building blocks that support the execution of business processes across the enterprise')"/>.</p>
								<div class="verticalSpacer_5px"/>
								<!--<div class="smallButton backColour2 text-white fontBlack pull-right" id="fullScreenButton" style="width:130px">View Full Screen</div>
									<div class="horizSpacer_10px pull-right"/>-->
								<!--<div class="smallButton backColour1 text-white fontBlack pull-right userCountToggle" style="width:200px">Show/Hide User Count</div>
									<div class="horizSpacer_10px pull-right"/>-->
								<!--<div class="smallButton bg-primary text-white fontBlack pull-right heatmapToggle" style="width:200px"><xsl:value-of select="eas:i18n('Show/Hide Application Count')"/></div> -->
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="instanceKey"/>
								<xsl:call-template name="userKey"/>
								<div class="verticalSpacer_10px"/>
							</div> 

							<div class="appRef_container" id="armContainer"/>
							<div class="appRef_container" id="armContainer2">	
							</div>
							<hr/>
						</div>
						<!--Setup Closing Tags-->
					</div>
					

				</div>
				<div class="clear"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
			<script> 
				<xsl:call-template name="RenderViewerAPIJSFunction">
				<xsl:with-param name="viewerAPIPathCapsMart" select="$apiPathBusinessCapsAppsMart"/>
				<xsl:with-param name="viewerAPIPathAppsMart" select="$apiPathBusinessAppsMart"/>
				</xsl:call-template>
			</script>
			<script id="armApps-template" type="text/x-handlebars-template">
				<div class="containList">
				<h3>Application.</h3>
				<div class="closebtnBox pull-right ">
						<a href="javascript:void(0)" class=" closebtn"><i class="fa fa-times" style="color:red"></i></a>
				</div>
				<div class="pull-right bottom-10">
				<button class="btn btn-active btn-success appInfoButton"><xsl:attribute name="appLists">{{this.carried}}
				</xsl:attribute>View in Rationalisation</button></div>
				<h4>Standards</h4>
				<table class="table table-header-background table-striped table-bordered table-condensed">
				<tr>
				<th>Application</th>
				<th>Standard for</th>
				<th>Lifecycle Status</th>
				<th>Users</th>
				</tr>
				{{#if this.sShow}}
				{{#each this.sShow}}
				<tr>
				<td class="appName"> {{{this.link}}}  </td>
				<td>{{#each this.orgs}}
				{{this.name}}<br/>
				{{/each}}</td>
				 
				{{#if this.aprlifecycleStatus}}
				<td><xsl:attribute name="style">background-color:{{this.AprlifecycleColour}};color:{{this.AprlifecycleColourText}}</xsl:attribute>
					{{this.aprlifecycleStatus}}
					</td>
				{{else}}
				<td><xsl:attribute name="style">background-color:{{this.lifecycleColour}};color:{{this.lifecycleColourText}}</xsl:attribute>
					{{this.lifecycleStatus}}
					</td>
				{{/if}} 
				<td>
					<div class="scrollable stakeholders">
						{{#each this.stakeholders}}
							- {{this.name}}<br/>
						{{/each}}
					</div>
				</td>
				</tr>
				{{/each}}
				{{else}}
					<tr><td colspan="4">None defined</td></tr>
				{{/if}}
				</table>
				<h4>No Standards Defined</h4>
				<table class="table table-header-background table-striped table-bordered table-condensed">
				<tr>
				<th>Application</th> 
				<th>Lifecycle Status</th>
				<th>Users</th>
				</tr>
				{{#if this.nsShow}}
				{{#each this.nsShow}}
				<tr>
				<td>{{{this.link}}}</td>
				{{#if this.aprlifecycleStatus}}
				<td><xsl:attribute name="style">background-color:{{this.AprlifecycleColour}};color:{{this.AprlifecycleColourText}}</xsl:attribute>
					{{this.aprlifecycleStatus}}
					</td>
				{{else}}
				<td><xsl:attribute name="style">background-color:{{this.lifecycleColour}};color:{{this.lifecycleColourText}}</xsl:attribute>
					{{this.lifecycleStatus}}
					</td>
				{{/if}} 
				<td>
					<div class="scrollable stakeholders">
						{{#each this.stakeholders}}
							- {{this.name}}<br/>
						{{/each}}
					</div>
				</td>
				</tr>
				{{/each}}
				{{else}}
					<tr><td colspan="4">None defined</td></tr>
				{{/if}}
				</table>
			</div>
			</script>
			<script id="arm-template" type="text/x-handlebars-template">
				<div class="appRef_NarrowColContainer col-xs-3">
					{{#each this.shared}}
						<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
							<div class="appRef_CapTitle fontBlack xlarge text-white">{{{this.link}}}</div>
							{{> partialTemplate}}			 

						</div>		
					{{/each}}
				</div>	
				<div class="appRef_WideColContainer col-xs-6">
					{{#each this.foundation}}
						<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
							<div class="appRef_CapTitle fontBlack xlarge text-white">{{{this.link}}}</div>
							{{> partialTemplate}}		
						</div>		
					{{/each}}
				</div>
				<div class="appRef_NarrowColContainer col-xs-3">
					{{#each this.management}}
						<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
							<div class="appRef_CapTitle fontBlack xlarge text-white">{{{this.link}}}</div>
							{{> partialTemplate}}		
						</div>		
					{{/each}}
				</div>
		  </script>		
		  <script id="arm-partial-template" type="text/x-handlebars-template">
				{{#each this.subCaps}} 
						<div class="appRef_NarrowColSubCap">
								<div class="appRef_CapTitle fontBlack large">
									{{{this.link}}}
								</div>
								{{#each this.services}}
								<div class="threeColModel_ObjectContainer">
									<div class="threeColModel_ObjectBackgroundColour bg-darkblue-20"/>
									<div>
									</div>
									<div class="threeColModel_Object small">
									<span class="fontBlack text-default context-menu-appSvcGenMenu">{{{this.link}}}</span>
										<div class="numberPos"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="capid">{{this.capid}}</xsl:attribute>
											<span>{{#add this.nsShow.length this.sShow.length}}{{/add}}</span>
										</div>
									</div>
									<div class="verticalSpacer_5px backColour7"/>
								</div>
								{{/each}}
							</div> 
				{{/each}}
		</script>	
		<script id="arm2-template" type="text/x-handlebars-template">
				<div class="appRef_NarrowColContainer col-xs-3">
					{{#each this.Left}}
						<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
							<div class="appRef_CapTitle fontBlack xlarge text-white">{{this.name}}</div>
							{{> arpartialTemplate}}			 

						</div>		
					{{/each}}
				</div>	
				<div class="appRef_WideColContainer col-xs-6">
					{{#each this.Middle}}
						<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
							<div class="appRef_CapTitle fontBlack xlarge text-white">{{this.name}}</div>
							{{> arpartialTemplate}}		
						</div>		
					{{/each}}
				</div>
				<div class="appRef_NarrowColContainer col-xs-3">
					{{#each this.Right}}
						<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
							<div class="appRef_CapTitle fontBlack xlarge text-white">{{this.name}}</div>
							{{> arpartialTemplate}}		
						</div>		
					{{/each}}
				</div>
		  </script>	
		  <script id="armodel-partial-template" type="text/x-handlebars-template">
				{{#each this.subCaps}} 
						<div class="appRef_NarrowColSubCap">
								<div class="appRef_CapTitle fontBlack large blkText" style="color:black">
										{{this.name}}
								</div>
								{{#each this.newSupportingServices}}
								<div class="threeColModel_ObjectContainer">
									<div class="threeColModel_ObjectBackgroundColour bg-darkblue-20"/>
									<div>
									</div>
									<div class="threeColModel_Object small">
									<span class="fontBlack text-default context-menu-appSvcGenMenu">{{this.name}}</span>
										<div class="numberPos"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="capid">{{this.capid}}</xsl:attribute>
											<span>{{this.APRs.length}}</span>
										</div>
									</div>
									<div class="verticalSpacer_5px backColour7"/>
								</div>
								{{/each}}
							</div> 
				{{/each}}
		</script>	
<script>
	
	var armJSON = {"shared":[<xsl:apply-templates mode="RenderSharedAppCapJSON" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $sharedAppCapType/name)]">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>],
				"foundation":[<xsl:apply-templates mode="RenderSharedAppCapJSON" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $coreAppCapType/name)]">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>],
				"management":[<xsl:apply-templates mode="RenderSharedAppCapJSON" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $manageAppCapType/name)]">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>]};

				let rdMapApp=[<xsl:apply-templates select="$allRoadmapInstances" mode="roadmapApps"/>];
console.log(armJSON)
var servicesList=[];
var allAppsList=[];
let workingArr=[];
let workingArrayApps=[];
let workingAppCaps=[];
let filtered={};
var allPropertyNames;
				$(document).ready(function() {
					var armFragment = $("#arm-template").html();
					armTemplate = Handlebars.compile(armFragment);

					var armodelFragment = $("#arm2-template").html();
					armodelTemplate = Handlebars.compile(armodelFragment);
					
					
					var armAppsFragment = $("#armApps-template").html();
					armAppsTemplate = Handlebars.compile(armAppsFragment);

					templateFragment = $("#arm-partial-template").html();
					partialTemplate = Handlebars.compile(templateFragment);

					artemplateFragment = $("#armodel-partial-template").html();
					arpartialTemplate = Handlebars.compile(artemplateFragment);
					
					Handlebars.registerPartial('partialTemplate', partialTemplate);	
					Handlebars.registerPartial('arpartialTemplate', arpartialTemplate);	

					Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
					});

					Handlebars.registerHelper('add', function(arg1, arg2, options) {

   						 return (arg1 + arg2);
						});
				 console.log(rdMapApp)
				allPropertyNames = Object.keys(armJSON);
				
				for(i=0;i&lt;allPropertyNames.length;i++){
					armJSON[allPropertyNames[i]].forEach(function(d){
						d.subCaps.forEach(function(e){
							e.services.forEach(function(f){
								servicesList.push(f)	
							});
						});
					});		
				}
 
servicesList.forEach((svc)=>{
	svc.nonstandard.forEach((app)=>{
		allAppsList.push(app)
	});
	svc.standards.forEach((app)=>{
		allAppsList.push(app)
	});
});

allAppsList=uniq_fast(allAppsList)
allAppsList.forEach((d)=>{
	let thisApp=rdMapApp.filter((e)=>{
		return d.id==e.id;
	})
	d['roadmap']=thisApp[0].roadmap;
})


Promise.all([
			promise_loadViewerAPIData(viewAPIDataBusCapsApps),
			promise_loadViewerAPIData(viewAPIDataApps)
			]).then(function (responses)
			{
				workingArrayApps = responses[0].applications;
				workingAppCaps=responses[1]

				console.log('workingArray');
				console.log(workingArrayApps);
				console.log(workingAppCaps)

				
				setHierarchy(workingAppCaps.application_capabilities, workingAppCaps.application_capabilities)
				console.log(filtered)
				createJSON(filtered, workingAppCaps.application_capabilities, workingAppCaps.application_services, workingArrayApps)

				

		workingArr = allAppsList;
		console.log(workingArr)
		essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS']);
		});		
});	

function setHierarchy (arr, filteredArr){

	group = arr.reduce((r, a) => {
 
		r[a.ReferenceModelLayer] = [...r[a.ReferenceModelLayer] || [], a];
		return r;
		}, {});
		allowed=[""];
		filtered = Object.keys(group)
			.filter(key => !allowed.includes(key))
			.reduce((obj, key) => {
				obj[key] = group[key];
				return obj;
			}, {});

		console.log('filtered');
		console.log(filtered);

		let keys = Object.keys(filtered);
		keys.forEach((d)=>{
			filtered[d].forEach((e)=>{
			let result = e.childrenCaps.filter(o1 => filteredArr.some(o2 => o1.id === o2.id));
			console.log('result')	
			e['subCaps']=result;
			result.forEach((f)=>{	
				let thisArrayofKids=[];
				getKids(f,thisArrayofKids) 
				f['allSubCaps']=thisArrayofKids;
				});
			});

		console.log('new filtt')	
		console.log(filtered)
		});

}
  
function uniq_fast(a) {
    var seen = {};
    var out = [];
    var len = a.length;
    var j = 0;
    for(var i = 0; i &lt; len; i++) {
         var item = a[i].id;
         var itemParent=a[i];    
         if(seen[item] !== 1) {
               seen[item] = 1;
               out[j++] = itemParent;
         }
    }
    return out;
}  

	var redrawView=function() {

		let scopedRMData = [];
				workingArr.forEach((d) => {
					scopedRMData.push(d)
				});
				let toShow = [];

				// *** REQUIRED *** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS
				if (roadmapEnabled) {
					//update the roadmap status of the caps passed as an array of arrays
					rmSetElementListRoadmapStatus([scopedRMData]);

					// *** OPTIONAL *** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME
					//filter caps to those in scope for the roadmap start and end date
					toShow = rmGetVisibleElements(scopedRMData);
				} else {
					toShow = workingArr;
				}
		console.log(toShow);

		let appOrgScopingDef = new ScopingProperty('stakeholderIDs', 'Group_Actor'); 
		let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
		let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');

		let scopedApps = essScopeResources(toShow, [appOrgScopingDef, geoScopingDef, visibilityDef]);

	 
		let filteredAppIdList=[]; 
		filteredAppIdList = filteredAppIdList.concat(scopedApps.resourceIds);
 
		//set Apps for filter
console.log('armJSON')
console.log(armJSON)
		for(i=0;i&lt;allPropertyNames.length;i++){
					armJSON[allPropertyNames[i]].forEach((d)=>{
						d.subCaps.forEach((e)=>{
							
							e.services.forEach((f)=>{
								let nsShow=[];
								let sShow=[];
								filteredAppIdList.forEach((fil)=>{
									let thisApp=f.nonstandard.find((app)=>{
										return app.id==fil;
									});
								 
									if(thisApp){nsShow.push(thisApp)}

									let thisStdApp=f.standards.find((app)=>{
										return app.id==fil;
									});
								 
									if(thisStdApp){sShow.push(thisStdApp)}
								})
								f['nsShow']=nsShow;
								f['sShow']=sShow;
							});
						});
					});		
				}
				console.log('workingAppCaps');
			console.log(workingAppCaps.length);
			if(workingAppCaps!= 0){
			let scopedCaps = essScopeResources(workingAppCaps.application_capabilities, [visibilityDef]);setHierarchy(workingAppCaps.application_capabilities, scopedCaps.resources);
		 
			let scopedSvcs = essScopeResources(workingAppCaps.application_services, [visibilityDef]);
		 
			let scopedApps2 = essScopeResources(workingArrayApps, [appOrgScopingDef, geoScopingDef, visibilityDef]);
		
		let group={};
	 	createJSON(filtered, scopedCaps.resources, scopedSvcs.resources, scopedApps2.resources)
		
			}
		//show only apps in scoped

	//	$('#armContainer').html(armTemplate(armJSON))

		$('.numberPos').on('click',function(){
						let thisId=$(this).attr('easid');
 						let focusList= servicesList.filter(function(d){
							 return d.id == thisId;
						 });
						 let carriedList='';
						 focusList[0].nonstandard.forEach(function(d){
							carriedList=carriedList+d.id+','
						 });
						 focusList[0].standards.forEach(function(d){
							carriedList=carriedList+d.id+','
						 });
						 focusList[0]['carried']=carriedList;

						 $('#appsList').html(armAppsTemplate(focusList[0]))
						 
						  $('#appSidenav').css('width','500px');
						  $('.closebtn').on('click', function(){

							$('#appSidenav').css('width','0px');
							});

							$('.closebtnBox').on('click', function(){
								$('#appSidenav').css('width','0px');
							});
					})

		}

		function redrawView() {
			essRefreshScopingValues()
		}


$(document).on("click", ".appInfoButton", function(){
	var appLists = $(this).attr('appLists');
	console.log(appLists)
	var carriedApps=appLists.split(',');
	var apps={};
	apps['Composite_Application_Provider']=carriedApps.slice(0, -1);
	console.log(carriedApps.slice(0, -1))
	sessionStorage.setItem("context", JSON.stringify(apps));

	location.href='report?XML=reportXML.xml&amp;XSL=application/core_al_app_rationalisation_analysis_simple.xsl&amp;PMA=bcm'

});

</script>

		</html>
	</xsl:template>

	<xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
    </xsl:template>	

<xsl:template name="RenderViewerAPIJSFunction">
	<xsl:param name="viewerAPIPathCapsMart"/>
	<xsl:param name="viewerAPIPathAppsMart"/>

	var viewAPIDataBusCapsApps = '<xsl:value-of select="$viewerAPIPathCapsMart"/>';
	var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathAppsMart"/>';
	  
	var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200)
						{
							
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
						}
					};
					xmlhttp.onerror = function ()
					{
						reject(false);
					};
					
					xmlhttp.open("GET", apiDataSetURL, true);
					xmlhttp.send();
				} else
				{
					reject(false);
				}
			});
		};
	
	
		$('document').ready(function (){
		});
<!-- ########## END DOCUMENT READY ############ -->

function createJSON(appCaps, capList, svcs, apps){
	console.log('CREATE JSON')
	console.log(appCaps)
	console.log(capList)
	console.log(svcs)
	console.log(apps)

	var keys = Object.keys(appCaps);
	keys.forEach((d)=>{ 
		appCaps[d].forEach((e)=>{ 
			let thisAppServices=[];
			e.supportingServices.forEach((svc)=>{
				thisAppServices.push(svc);
			});
			e.childrenCaps.forEach((subs)=>{
				if(subs.allSubCaps){
				subs.allSubCaps.forEach((cap)=>{
					let thisCap=capList.find((subcap)=>{	 
						return subcap.id == cap.id;
					});  
					console.log(thisCap)
					if(thisCap){
						thisCap.supportingServices.forEach((sps)=>{
							thisAppServices.push(sps);
							})
					}
					});
				}
			
			let svcMap=[];
			console.log(thisAppServices)
			thisAppServices.forEach((sv)=>{
				let thisSvs=svcs.find((thisSvc)=>{	 
						return thisSvc.id == sv;
					}); 
				let appsForSvc=[];
				if(thisSvs){	
					thisSvs.APRs.forEach((apr)=>{ 
						let thisApp=apps.find((app)=>{
							return app.id == apr.appId;
						}); 
						apr['app']=thisApp;
					});	
				}

				svcMap.push(thisSvs);	
			});

			subs['newSupportingServices']=svcMap;
		}) 
		});
	
	});	
	console.log('appCaps')
		console.log(appCaps)

		$('#armContainer2').html(armodelTemplate(appCaps))		
}

//find children for apps caps
function getKids(array, list){
	array.childrenCaps.forEach((f)=>{
		getKids(f,list);
				list.push({"id":f.id})
				return list
				});
		
}
		 
</xsl:template>




	<xsl:template name="instanceKey">
		<style>
			.halfOpacity{
			    opacity: 0.8;
		</style>
		<div class="piKeyContainer instanceKey">
			<div class="clear"/>
			<div class="verticalSpacer_10px"/>
			<div id="keyContainer">
				<div class="keyLabel uppercase" style="width:150px;"><xsl:value-of select="eas:i18n('Duplication Heatmap')"/>:</div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide halfOpacity ', $highFootprintStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('More than 2 Apps')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide halfOpacity ', $mediumFootprintStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('2 Apps')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide halfOpacity ', $lowFootprintStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('1 App')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide halfOpacity ', $noFootprintStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('No Apps')"/></div>
				<div class="horizSpacer_30px pull-left"/>
				<div class="keySampleLabel"># = <xsl:value-of select="eas:i18n('Number of Applications for this Service')"/></div>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="userKey">
		<div class="piKeyContainer userKey" id="userKey">
			<div class="clear"/>
			<div class="verticalSpacer_10px"/>
			<div id="keyContainer">
				<div class="keyLabel uppercase" style="width:125px;"><xsl:value-of select="eas:i18n('User Count')"/>:</div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $lowUserCountStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('Low')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $lowmedUserCountStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('Low-Medium')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $medUserCountStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('Medium')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $medhighUserCountStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('Medium-High')"/></div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $highUserCountStyle)"/>
				</div>
				<div class="keySampleLabel"><xsl:value-of select="eas:i18n('High')"/></div>
			</div>
		</div>
	</xsl:template>


<xsl:template match="node()" mode="RenderSharedAppCapJSON">
		<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",	
		"subCaps":[<xsl:apply-templates mode="RenderSharedLevel2AppCapsJSON" select="$subAppCaps">
				</xsl:apply-templates>]
		}<xsl:if test="not(position() = last())">,</xsl:if> 
	</xsl:template>
	<xsl:template match="node()" mode="RenderSharedLevel2AppCapsJSON">
		<xsl:variable name="currentAppSvc" select="current()"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>",
			"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
			"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			"services":[<xsl:apply-templates mode="RenderApplicationServicesJSON" select="$appSvsForAppCap"><xsl:with-param name="capId" select="eas:getSafeJSString(current()/name)"/>
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:with-param name="relevantAppSvc" select="$currentAppSvc"/>
			</xsl:apply-templates>]}
		 <xsl:if test="not(position() = last())">,</xsl:if> 
	</xsl:template>
<xsl:template match="node()" mode="RenderApplicationServicesJSON">
<xsl:param name="capId"/>
<xsl:variable name="relevantAppSvc" select="current()"/>
<xsl:variable name="relevantAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $relevantAppSvc/name]"/>
<xsl:variable name="relevantApps" select="$allApps[(name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)]"/>
<xsl:variable name="currentAppStandards" select="$allAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $relevantAppProRoles/name]"/>
<xsl:variable name="standardAppProRoles" select="$relevantAppProRoles[name = $currentAppStandards/own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value]"/>
<xsl:variable name="standardApps" select="$relevantApps[name = $standardAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"capid":"<xsl:value-of select="$capId"/>",		
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
		"standards":[<xsl:for-each select="$standardApps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="currentApp" select="current()"/>
							<xsl:variable name="appProRoles4CurrentAppService" select="$relevantAppSvc/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
							<xsl:variable name="appProRoleforCurrentApp" select="$standardAppProRoles[(name = $appProRoles4CurrentAppService) and (own_slot_value[slot_reference = 'role_for_application_provider']/value = $currentApp/name)]"/>
							
							<xsl:variable name="standardForCurrentApp" select="$currentAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $appProRoleforCurrentApp/name]"/>
							<xsl:variable name="thisAppStandardOrg" select="$allGroupActors[name = $standardForCurrentApp/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>
							
							<xsl:variable name="thisAPRLifecycleStatus" select="$allLifecycleStatii[name = $appProRoleforCurrentApp/own_slot_value[slot_reference='apr_lifecycle_status']/value]"/>
							<xsl:variable name="thisAppLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>
							<xsl:variable name="lifecycleClass" select="eas:get_element_style_class($thisAPRLifecycleStatus)"/>
							<xsl:variable name="stakeholders4currentAppProRole" select="$allActor2Role[name = $appProRoleforCurrentApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
							<xsl:variable name="appOrgUsers4App" select="$stakeholders4currentAppProRole[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
							<xsl:variable name="relevantActors" select="$allGroupActors[name = $appOrgUsers4App/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
							<xsl:variable name="appStakeholder" select="$allActor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
							<xsl:variable name="thisActorsA2R" select="$allGroupActors[name = $appStakeholder/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
							
							<xsl:variable name="thisAPRLifecycleStatusStyle" select="$elementStyle[name=$thisAPRLifecycleStatus/own_slot_value[slot_reference='element_styling_classes']/value]"/>	
							<xsl:variable name="thisAppLifecycleStatusStyle" select="$elementStyle[name=$thisAppLifecycleStatus/own_slot_value[slot_reference='element_styling_classes']/value]"/>
							{
							"name":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>",
							"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
							"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
							"orgs":[<xsl:for-each select="$thisAppStandardOrg">
								{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>"}<xsl:if test="not(position() = last())">,</xsl:if> </xsl:for-each>],
								"lifecycleStatus":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="$thisAppLifecycleStatus"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>",
								"aprlifecycleStatus":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="$thisAPRLifecycleStatus"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>",
								"lifecycleColour":"<xsl:value-of select="$thisAppLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",
								"lifecycleColourText":"<xsl:value-of select="$thisAppLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
								"AprlifecycleColour":"<xsl:value-of select="$thisAPRLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",
								"AprlifecycleColourText":"<xsl:value-of select="$thisAPRLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
								"stakeholdersA2R":[<xsl:for-each select="$appStakeholder">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"
									<xsl:if test="not(position() = last())">,</xsl:if> 
										</xsl:for-each>],
								"stakeholderIDs":[<xsl:for-each select="$thisActorsA2R">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>],		
								"stakeholders":[<xsl:for-each select="$relevantActors">
								{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>"}<xsl:if test="not(position() = last())">,</xsl:if> 
										</xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if> 	
						</xsl:for-each>],
		"nonstandard":[<xsl:for-each select="$relevantApps except $standardApps">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="currentApp" select="current()"/>
							<xsl:variable name="appProRoles4CurrentAppService" select="$relevantAppSvc/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
							<xsl:variable name="appProRoleforCurrentApp" select="$allAppProRoles[(name = $appProRoles4CurrentAppService) and (own_slot_value[slot_reference = 'role_for_application_provider']/value = $currentApp/name)]"/>
							<xsl:variable name="thisAPRLifecycleStatus" select="$allLifecycleStatii[name = $appProRoleforCurrentApp/own_slot_value[slot_reference='apr_lifecycle_status']/value]"/>
							<xsl:variable name="thisAppLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>	
							<xsl:variable name="appStakeholder" select="$allActor2Role[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
							<xsl:variable name="stakeholders4currentAppProRole" select="$allActor2Role[name = $appProRoleforCurrentApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
							<xsl:variable name="thisActorsA2R" select="$allGroupActors[name = $appStakeholder/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
									<xsl:variable name="appOrgUsers4App" select="$stakeholders4currentAppProRole[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
									<xsl:variable name="relevantActors" select="$allGroupActors[name = $appOrgUsers4App/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>	
									<xsl:variable name="thisAPRLifecycleStatusStyle" select="$elementStyle[name=$thisAPRLifecycleStatus/own_slot_value[slot_reference='element_styling_classes']/value]"/>	
									<xsl:variable name="thisAppLifecycleStatusStyle" select="$elementStyle[name=$thisAppLifecycleStatus/own_slot_value[slot_reference='element_styling_classes']/value]"/>
								{ 
									"name":"<xsl:call-template name="RenderMultiLangInstanceName">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="isRenderAsJSString" select="true()"/>
											</xsl:call-template>",
									"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
									"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",		
									"lifecycleStatus":"<xsl:call-template name="RenderMultiLangInstanceName">
												<xsl:with-param name="theSubjectInstance" select="$thisAppLifecycleStatus"/>
												<xsl:with-param name="isRenderAsJSString" select="true()"/>
											</xsl:call-template>",
									"aprlifecycleStatus":"<xsl:call-template name="RenderMultiLangInstanceName">
										<xsl:with-param name="theSubjectInstance" select="$thisAPRLifecycleStatus"/>
										<xsl:with-param name="isRenderAsJSString" select="true()"/>
									</xsl:call-template>",
								"lifecycleColour":"<xsl:value-of select="$thisAppLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",
								"lifecycleColourText":"<xsl:value-of select="$thisAppLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
								"AprlifecycleColour":"<xsl:value-of select="$thisAPRLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",
								"AprlifecycleColourText":"<xsl:value-of select="$thisAPRLifecycleStatusStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
								"stakeholdersA2R":[<xsl:for-each select="$appStakeholder">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if> 
											</xsl:for-each>],
								"stakeholders":[<xsl:for-each select="$relevantActors">
									{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="isRenderAsJSString" select="true()"/>
										</xsl:call-template>"}<xsl:if test="not(position() = last())">,</xsl:if> 
											</xsl:for-each>],
								"stakeholderIDs":[<xsl:for-each select="$thisActorsA2R">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position() = last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if>
							</xsl:for-each>]}<xsl:if test="not(position() = last())">,</xsl:if> 

</xsl:template>
<xsl:template match="node()" mode="roadmapApps">
			{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> </xsl:template>

</xsl:stylesheet>



