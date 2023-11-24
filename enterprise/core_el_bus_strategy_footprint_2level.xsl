<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->
<xsl:stylesheet version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:functx="http://www.functx.com" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml">
	<xsl:import href="../common/ess_bl_utilities.xsl"/>
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Product_Type', 'Group_Actor', 'Project','Business_Objective','Business_Goal')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- View-specific parameters -->
	<xsl:param name="isClosedProjects">false</xsl:param>

	<!-- end of view-specific parameters -->

	<!-- START VIEW SPECIFIC VARIABLES -->

	<!--<xsl:variable name="busRegionTaxTerm" select="/node()/simple_instance[(type='Taxonomy_Term') and (own_slot_value[slot_reference='name']/value = 'Business Region')]"/>
	<xsl:variable name="allRegions" select="/node()/simple_instance[(type='Geographic_Region') and (own_slot_value[slot_reference='element_classified_by']/value = $busRegionTaxTerm/name)]"/>

	<xsl:variable name="allOrgs" select="/node()/simple_instance[type='Group_Actor']"/>
	<xsl:variable name="rootOrgConstant" select="/node()/simple_instance[(type='Report_Constant') and (own_slot_value[slot_reference='name']/value='Org Model - Root Organisation')]"/>
	<xsl:variable name="rootOrg" select="$allOrgs[name=$rootOrgConstant/own_slot_value[slot_reference='report_constant_ea_elements']/value]"/>
	<xsl:variable name="topLevelChildOrgs" select="$allOrgs[name = $rootOrg/own_slot_value[slot_reference='contained_sub_actors']/value]"/>



	<xsl:variable name="allChannels" select="/node()/simple_instance[type='Channel']"/>
	<xsl:variable name="allProductTypes" select="/node()/simple_instance[type='Product_Type']"/>-->
	<!-- Define the Project Status settings that exclude Projects from this View -->

	<xsl:variable name="aCurrentYear" select="current-date()"/>
	<xsl:variable name="aCurrentYearElement" select="year-from-date($aCurrentYear)"/>

	<!-- Get all the Time instances in the current year -->
	<xsl:variable name="allTimes" select="/node()/simple_instance[type = 'Year' or type = 'Quarter' or type = 'Gregorian']"/>
	<xsl:variable name="aTimeScope" select="$allTimes[own_slot_value[slot_reference = 'time_year']/value >= $aCurrentYearElement]"/>

	<xsl:variable name="anExcludeStatus" select="/node()/simple_instance[type = 'Project_Lifecycle_Status' and own_slot_value[slot_reference = 'name']/value = 'Closed']"/>
	<xsl:variable name="allAllProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="noClosedProjects" select="$allAllProjects[not(own_slot_value[slot_reference = 'project_lifecycle_status']/value = $anExcludeStatus/name)]"/>
	<xsl:variable name="allProjects" select="eas:getProjectsInScope($isClosedProjects)"/>

	<xsl:variable name="allStratPlans" select="/node()/simple_instance[type = ('Enterprise_Strategic_Plan', 'Business_Strategic_Plan', 'Application_Strategic_Plan', 'Information_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan')]"/>
	<xsl:variable name="allStratPlanForElements" select="/node()/simple_instance[name = $allStratPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>

	<xsl:variable name="thisReport" select="eas:get_report_by_name('EXT-Shared: Business Strategy Footprint - 2 Level')"/>
	<xsl:variable name="basicQueryString">
		<xsl:call-template name="RenderLinkText">
			<xsl:with-param name="theXSL">enterprise/core_el_bus_strategy_footprint_2level.xsl</xsl:with-param>
			<xsl:with-param name="theXML" select="$reposXML"/>
		</xsl:call-template>
	</xsl:variable>


	<!--<xsl:variable name="allOrgRoleTypes" select="/node()/simple_instance[type='Business_Role_Type']"/>
	<xsl:variable name="allOrgRoles" select="/node()/simple_instance[type='Group_Business_Role']"/>

	<xsl:variable name="supplierRoleType" select="$allOrgRoleTypes[own_slot_value[slot_reference='name']/value = 'Suppliers']"/>
	<xsl:variable name="customerRoleType" select="$allOrgRoleTypes[own_slot_value[slot_reference='name']/value = 'Customers']"/>
	<xsl:variable name="intermediaryRoleType" select="$allOrgRoleTypes[own_slot_value[slot_reference='name']/value = 'Intermediaries']"/>
	<xsl:variable name="audienceRoleType" select="$allOrgRoleTypes[own_slot_value[slot_reference='name']/value = 'Audiences']"/>
	<xsl:variable name="externalInfluencersRoleType" select="$allOrgRoleTypes[own_slot_value[slot_reference='name']/value = 'External Influencers']"/>
	<xsl:variable name="partnerRoleType" select="$allOrgRoleTypes[own_slot_value[slot_reference='name']/value = 'Partners']"/>

	<xsl:variable name="allSuppliers" select="$allOrgRoles[own_slot_value[slot_reference='is_business_role_type']/value = $supplierRoleType/name]"/>
	<xsl:variable name="allCustomers" select="$allOrgRoles[own_slot_value[slot_reference='is_business_role_type']/value = $customerRoleType/name]"/>
	<xsl:variable name="allIntermediaries" select="$allOrgRoles[own_slot_value[slot_reference='is_business_role_type']/value = $intermediaryRoleType/name]"/>
	<xsl:variable name="allAudiences" select="$allOrgRoles[own_slot_value[slot_reference='is_business_role_type']/value = $audienceRoleType/name]"/>
	<xsl:variable name="allPartners" select="$allOrgRoles[own_slot_value[slot_reference='is_business_role_type']/value = $partnerRoleType/name]"/>
	<xsl:variable name="allExtInfluencers" select="$allOrgRoles[own_slot_value[slot_reference='is_business_role_type']/value = $externalInfluencersRoleType/name]"/>
-->
	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapabilityConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Root Business Capability')]"/>
	<xsl:variable name="rootBusCapability" select="$allBusinessCaps[name = $rootBusCapabilityConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="rootBusCapName" select="$rootBusCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $rootBusCapability/name]"/>
	<xsl:variable name="parentCap" select="$allBusinessCaps[name = $rootBusCapability/own_slot_value[slot_reference = 'supports_business_capabilities']/value]"/>

	<xsl:variable name="allBusCapRoles" select="/node()/simple_instance[type = 'Business_Capability_Role']"/>
	<xsl:variable name="capFrontPositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Front']"/>
	<xsl:variable name="capBackPositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Back']"/>
	<xsl:variable name="capManagePositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Manage']"/>


	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="topLevelFrontBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capFrontPositon/name)]"/>
	<xsl:variable name="topLevelBackBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capBackPositon/name)]"/>
	<xsl:variable name="topLevelManageBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capManagePositon/name)]"/>

	<xsl:variable name="stratGoalTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>
	<xsl:variable name="objectiveTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="stratGoals" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $stratGoalTaxTerm/name]"/>
	<xsl:variable name="stratObjectives" select="$allObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $objectiveTaxTerm/name]"/>

	<xsl:variable name="coreCapsMaxDepth" select="5"/>

	<xsl:variable name="highProjectThreshold" select="9"/>
	<xsl:variable name="medProjectThreshold" select="4"/>
	<xsl:variable name="lowProjectThreshold" select="0"/>
	<xsl:variable name="highFootprintStyle" select="'sch_claret_100'"/>
	<xsl:variable name="medFootprintStyle" select="'sch_claret_60'"/>
	<xsl:variable name="lowFootprintStyle" select="'sch_claret_20'"/>
	<xsl:variable name="noFootprintStyle" select="'bg-white'"/>
	
	<xsl:variable name="stratGoalColours" select="('bg-pink-100','bg-purple-100','bg-darkblue-100','bg-lightblue-100','bg-aqua-100','bg-darkgreen-100','bg-brightgreen-100','bg-orange-100','bg-brightred-100','bg-darkred-100')"/>

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
				<title>Business Strategy Footprint</title>
				<script src="js/jquery-migrate-1.4.1.min.js?release=6.19" type="text/javascript"/>
				<!--JQuery plugin to support tooltips-->
				<script src="js/jquery.tools.min.js?release=6.19" type="text/javascript"/>
				<script src="js/jquery.columnizer.js?release=6.19" type="text/javascript"/>	
				<link href="ext/shared/custom.css?release=6.19" rel="stylesheet" type="text/css"/>
				<!--script to turn a list into columns-->
				<!--<script>
					$(function(){
					$('.projects').columnize({columns: 2});
					});
				</script>-->

				<script type="text/javascript">
					$('document').ready(function(){
					var greatestWidth = 0;   // Stores the greatest width
					
					$("#coreBusServices").each(function() {    // Select the elements you're comparing
					
					var theWidth = $(this).width();   // Grab the current width
					
					if( theWidth > greatestWidth) {   // If theWidth > the greatestWidth so far,
					greatestWidth = theWidth;     //    set greatestWidth to theWidth
					}
					});
					
					$(".threeColModel_wideRow").width(greatestWidth);     // Update the elements you were comparing
					$(".threeColModel_scrollable").width(greatestWidth+370);     // Update the elements you were comparing
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					var greatestWidth = 0;   // Stores the greatest width
					
					$(".threeColModel_wideColumnContainerCaps").each(function() {    // Select the elements you're comparing
					
					var theWidth = $(this).width();   // Grab the current width
					
					if( theWidth > greatestWidth) {   // If theWidth > the greatestWidth so far,
					greatestWidth = theWidth;     //    set greatestWidth to theWidth
					}
					});
					
					$(".threeColModel_LogoSection").width(greatestWidth-20);     // Update the elements you were comparing
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					$(".threeColModel_Object").vAlign();
					$(".circleButton").vAlign();
					$(".buttonLabel").vAlign();
					$(".threeColModel_ObjectAlt").vAlign();
					$(".threeColModel_NumberHeatmap").vAlign();					
					$(".threeColModel_ObjectDouble").vAlign();
					$(".threeColModel_valueChainObject").vAlign();
					$(".threeColModel_dynamicKeyTitle").vAlign();
					$(".threeColModel_dynamicKeyObject").vAlign();
					$(".threeColModel_valueChainObjectDouble").vAlign();
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					$(".heatmapContainer").hide();
					$(".dynamicKey").hide();
					$(".heatmapToggle").click(function(){
					$(".heatmapContainer").slideToggle();
					$(".dynamicKey").slideToggle();
					});
					});
				</script>
				<script type="text/javascript">
					$('document').ready(function(){
					$(".threeColModel_NumberHeatmap").hide();
					$(".piKeyContainer").hide();
					$(".projectList").hide();
					$(".projectToggle").click(function(){
					
					$(".threeColModel_ObjectBackgroundColour").toggle();
					$(".threeColModel_NumberHeatmap").toggle();
					$(".piKeyContainer").slideToggle();
					$(".projectList").toggle();
					});
					});
				</script>
				<script>
					$(document).ready(function() {							
						// initialize tooltip
						$(".heatmapElement").tooltip({
						
						   // tweak the position
						   offset: [-10, 0],							   
						   predelay: '400',
						   relative: 'true',							   
						   position: 'bottom',							   
						   opacity: '0.9',							
						   // use the "fade" effect
						   effect: 'fade'
						
						// add dynamic plugin with optional configuration for bottom edge
						}).dynamic({ bottom: { direction: 'down', bounce: true } });
																		
					}); 
					
					$(document).ready(function() {							
						// initialize tooltip
						$(".threeColModel_dynamicKeyObject").tooltip({
						
						   // tweak the position
						   offset: [-20, -40],							   
						   predelay: '400',
						   relative: 'true',							   
						   position: 'bottom',							   
						   opacity: '0.9',							
						   // use the "fade" effect
						   effect: 'fade'
						
						// add dynamic plugin with optional configuration for bottom edge
						}).dynamic({ bottom: { direction: 'down', bounce: true } });
																		
					}); 
					

					$(document).ready(function() {							
					// initialize tooltip
					$(".threeColModel_Object").tooltip({
					
					// tweak the position
					offset: [-20, -30],							   
					predelay: '400',
					relative: 'true',							   
					position: 'bottom',							   
					opacity: '0.9',							
					// use the "fade" effect
					effect: 'fade'
					
					// add dynamic plugin with optional configuration for bottom edge
					}).dynamic({ bottom: { direction: 'down', bounce: true } });
					
					});
				</script>

				<script>
					$(function(){
					// bind change event to select
					$('.level_select').bind('change', function () {
					var url = $(this).val(); // get selected value
					if (url) { // require a URL
					window.location = url; // redirect
					}
					return false;
					});
					});
				</script>
				<script language="JavaScript">
					window.onunload = $(".tooltip").hide();
				</script>
				<style type="text/css">
					.threeColModel_modelContainer *{
					    box-sizing: content-box;
					}
					
					.threeColModel_modelContainer{
					    position: relative;
					}
					
					.threeColModel_topSectionContainer{
					    clear: both;
					    position: relative;
					}
					
					.threeColModel_BottomSectionContainer{
					    clear: both;
					    position: relative;
					}
					
					.threeColModel_narrowColumnContainer{
					    margin: 0 20px 20px 0;
					    width: 142px;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_narrowColumn{
					    width: 122px;
					    border: 1px solid #aaa;
					    border-radius: 10px;
					    padding: 10px;
					    margin-bottom: 20px;
					    box-sizing: content-box;
					}
					
					.threeColModel_narrowColumnBlank{
					    width: 122px;
					    border: 1px solid white;
					    padding: 10px;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_wideColumnContainer{
					    margin-right: 20px;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_wideColumnContainerCaps{
					    margin-right: 20px;
					    position: relative;
					    border-left: 1px solid #aaa;
					    border-right: 1px solid #aaa;
					    border-bottom: 1px solid #aaa;
					    border-radius: 0 0 20px 20px;
					}
					
					.threeColModel_wideRow{
					    border: 1px solid #aaa;
					    border-radius: 10px;
					    padding: 10px;
					    float: left;
					    margin: 0 0 20px 0;
					    clear: both;
					}
					
					.threeColModel_wideRowCaps{
					    padding: 10px;
					    float: left;
					    clear: both;
					}
					
					.threeColModel_wideRowCapsDivider{
					    width: 100%;
					    height: 2px;
					    border-bottom: 2px solid #aaa;
					    float: left;
					    box-sizing: content-box;
					}
					
					.threeColModel_sectionTitle{
					    margin-bottom: 5px;
					    position: relative;
					}
					
					.threeColModel_valueChainColumnContainer{
					    margin-right: 5px;
					    float: left;
					    width: 142px;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_valueChainObject{
					    width: 115px;
					    padding: 5px 20px 5px 5px;
					    height: 40px;
					    margin-bottom: 5px;
					    text-align: center;
					    background: url(images/value_chain_arrow_end.png) no-repeat right center;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_valueChainColumnContainerDouble{
					    margin-right: 5px;
					    float: left;
					    width: 274px;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_valueChainObjectDouble{
					    width: 248px;
					    padding: 5px 20px 5px 5px;
					    height: 40px;
					    margin-bottom: 5px;
					    text-align: center;
					    background: url(images/value_chain_arrow_end.png) no-repeat right center;
					    position: relative;
					    box-sizing: content-box;
					}
					
					.threeColModel_ObjectContainer{
					    width: 122px;
					    float: left;
					    margin: 0 5px 5px 0;
					    box-sizing: content-box;
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
					    box-sizing: content-box;
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
					    line-height: 1.1em;
					    text-align: center;
					    box-sizing: content-box;
					}
					
					.capModel_ObjectContainer{
					    border: 1px solid #666;
					    float: left;
					    margin: 0 10px 10px 0;
					    box-sizing: content-box;
					}
					
					.capModel_Object{
					    position: relative;
					    width: 90px;
					    height: 40px;
					    max-height: 40px;
					    overflow: hidden;
					    padding: 5px;
					    float: left;
					    text-align: center;
					    opacity: 1.0;
					    box-sizing: content-box;
					}
					
					.capModel_Object,
					.threeColModel_Object:hover,
					.threeColModel_valueChainObject:hover,
					.threeColModel_valueChainObjectDouble:hover{
					    opacity: 0.75;
					    cursor: pointer;
					    box-sizing: content-box;
					}
					
					.busCapOverlays_Score{
					    width: 34px;
					    padding: 5px 2px;
					    height: 40px;
					    max-height: 40px;
					    line-height: 40px;
					    overflow: hidden;
					    text-align: center;
					    box-sizing: content-box;
					}
					
					.threeColModel_HeaderObjectContainer{
					    width: 122px;
					    float: left;
					    margin: 0 15px 5px 0;
					    box-sizing: content-box;
					}
					
					.threeColModel_HeaderObject{
					    position: relative;
					    width: 110px;
					    height: 40px;
					    max-height: 40px;
					    overflow: hidden;
					    margin-bottom: 5px;
					    border: 1px solid #ccc;
					    padding: 5px;
					    float: left;
					    text-align: center;
					    opacity: 1.0;
					    box-sizing: content-box;
					    line-height: 1.1em;
					}
					
					.threeColModel_LogoSection{
					    border-radius: 20px 20px 0px 0px;
					    padding: 10px;
					    float: left;
					    border-left: 1px solid #aaa;
					    border-right: 1px solid #aaa;
					    border-top: 1px solid #aaa;
					    box-sizing: content-box;
					}
					
					.threeColModel_dynamicKeyTitle{
					    float: left;
					    padding: 3px;
					    margin-right: 5px;
					    height: 20px;
					    box-sizing: content-box;
					}
					
					.threeColModel_dynamicKeyContainer{
					    float: left;
					    margin-right: 5px;
					}
					
					.threeColModel_dynamicKeyObject{
					    padding: 5px;
					    text-align: center;
					    border: 1px solid #ccc;
                        font-size:9pt;
					    width: 110px;
					    min-height: 80px;
					}
					
					.threeColModel_dynamicKeyObject:hover{
					    background-color: #aaa;
					    color: #fff;
					    cursor: pointer;
					}
					
					.threeColModel_dynamicKeyDescription{
					    width: 300px;
					    padding: 5px;
					    border: 1px solid #ccc;
					    position: absolute;
					    z-index: 9999;
					    margin-top: -1px;
					}
					
					.heatmapContainer{
					    width: 122px;
					    height: 10px;
					    margin-top: 0px;
					    float: left;
					    text-align: center;
					    border-left: 1px solid #ccc;
					    border-right: 1px solid #ccc;
					    border-bottom: 1px solid #ccc;
					}
					
					.heatmapElement{
					    position: relative;
					    height: 10px;
					    z-index: 1;
					    float: left;
					}
					
					.heatmapDivider{
					    border-right: 1px solid #ccc;
					}
					
					.bg-primary8{
					    background-color: #ffcd01;
					}
					
					.bg-primary9{
					    background-color: #feef9c;
					}
					
					.backColour20{
					    background-color: #0098dc;
					}
					
					.sch_textColour_claret{
					    color: #7a1d41;
					}
					
					.sch_claret_100{
					    background-color: #7a1d41;
					    color: #fff;
					}
					
					.sch_claret_80{
					    background-color: #954a67;
					    color: #fff;
					}
					
					.sch_claret_60{
					    background-color: #af778d;
					    color: #fff;
					}
					
					.sch_claret_40{
					    background-color: #caa5b3;
					    color: #fff;
					}
					
					.sch_claret_20{
					    background-color: #e4d2d9;
					    color: #fff;
					}
					
					.width250px{
					    width: 250px;
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
					
					.capCornerHighlight{
					    background-repeat: no-repeat;
					    background-position: 106px 0%;
					    width: 100%;
					    height: 30px;
					    position: absolute;
					    z-index: 2000;
					}
					
					.cornerTriangleBlue{
					    background-image: url(ext/apml/cornerTriangleBlue.png);
					}
					
					.cornerTriangleRed{
					    background-image: url(ext/apml/cornerTriangleRed.png);
					}
					
					.cornerTriangleGreen{
					    background-image: url(ext/apml/cornerTriangleGreen.png);
					}
					
					.cornerTriangleLightGreen{
					    background-image: url(ext/apml/cornerTriangleLightGreen.png);
					}
					
					.heatmapKey{
					    width: 16px;
					    height: 16px;
					    margin-right: 10px;
					    float: left;
					    border: 1px solid #ccc;
					    background-repeat: no-repeat;
					    background-position: 100% 0%;
					}
					
					.heatmapKeyLabel{
					    float: left;
					    margin-right: 30px;
					    font-weight: bold;
					}
					
					.piKeyContainer .keySampleWide{
					    opacity: 0.5;
					}
					.keySampleWide{
			    		opacity: 0.5;
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
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey">Business Strategy Footprint</span>
							</h1>
						</div>

						<!--Setup Description Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-truck icon-section icon-color"/>
								</div>
								<h2 class="text-primary">Model</h2>
								<div class="content-section">
									<p>The Business Strategy Footprint provides a strategic overview of the business.</p>
								</div>
								<div class="content-section">
									<div class="smallButton bg-primary text-white fontBlack pull-left heatmapToggle" style="width:200px">Show/Hide Strategy Heatmap</div>
									<div class="horizSpacer_10px pull-left"/>
									<div class="smallButton bg-primary text-white fontBlack pull-left projectToggle" style="width:200px">Show/Hide Project Impact</div>
									<div class="verticalSpacer_5px"/>
									<xsl:call-template name="levelSelectForm"/>
									<div class="verticalSpacer_10px"/>
									<xsl:call-template name="dynamicKey"/>
									<xsl:call-template name="projectImpactKey"/>
									<div class="verticalSpacer_10px"/>
									<div class="row">
										<div class="col-xs-12 col-sm-12 col-md-9">
											<xsl:call-template name="anchorModel"/>
										</div>
										<div class="col-xs-12 col-sm-12 col-md-3">
											<xsl:call-template name="fullProjectList"/>
										</div>
									</div>
								</div>
							</div>
						</div>


						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="anchorModel">


		<div class="pull-left">
			<div class="threeColModel_LogoSection bg-primary">
				<div class="verticalSpacer_10px clear"/>
				<div class="fontBlack large text-white"><xsl:value-of select="$rootBusCapName"/> Business Capabilities</div>

				<div class="verticalSpacer_10px clear"/>
			</div>
			<div class="clear"/>
			<div class="threeColModel_wideColumnContainerCaps pull-left">

				<div class="clear"/>
				<xsl:apply-templates mode="PrintTopLevelManageCap" select="$topLevelManageBusCapRelss"/>
				<div class="threeColModel_wideRowCapsDivider"/>
				<!--<xsl:apply-templates mode="PrintTopLevelFrontCap" select="$topLevelFrontBusCapRelss"/>-->
				<xsl:apply-templates mode="PrintTopLevelManageCap" select="$topLevelFrontBusCapRelss"/>
				<div class="threeColModel_wideRowCapsDivider"/>
				<xsl:apply-templates mode="PrintTopLevelManageCap" select="$topLevelBackBusCapRelss"/>

			</div>
		</div>
		<div class="verticalSpacer_10px"/>

	</xsl:template>


	<xsl:template match="node()" mode="PrintTopLevelManageCap">
		<xsl:variable name="thisManageBusCap" select="$allBusinessCaps[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
		<div class="threeColModel_wideRowCaps">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$thisManageBusCap"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass">threeColModel_sectionTitle fontBlack </xsl:with-param>
				<xsl:with-param name="anchorClass">text-default</xsl:with-param>
			</xsl:call-template>
			<xsl:variable name="childCaps" select="$allBusinessCaps[name = $thisManageBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
			<xsl:apply-templates mode="PrintGrandChildFrontCap" select="$childCaps">
				<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
			</xsl:apply-templates>
		</div>
		<xsl:if test="not(position() = last())">
			<div class="threeColModel_wideRowCapsDivider"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="PrintChildManageCap">
		<div class="threeColModel_ObjectContainer">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass">threeColModel_Object small bg-primary9</xsl:with-param>
				<xsl:with-param name="anchorClass">text-default</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="heatmap">
				<xsl:with-param name="thisBusCap" select="current()"/>
			</xsl:call-template>
		</div>
	</xsl:template>


	<xsl:template match="node()" mode="PrintTopLevelFrontCap">
		<xsl:variable name="thisFrontBusCap" select="$allBusinessCaps[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
		<div class="threeColModel_wideRowCaps">
			<div class="threeColModel_sectionTitle fontBlack " id="coreBusServices">
				<xsl:value-of select="$thisFrontBusCap/own_slot_value[slot_reference = 'name']/value"/>
			</div>
			<xsl:variable name="childCaps" select="$allBusinessCaps[name = $thisFrontBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
			<xsl:apply-templates mode="PrintChildFrontCap" select="$childCaps">
				<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
			</xsl:apply-templates>
		</div>
		<div class="threeColModel_wideRowCapsDivider"/>
	</xsl:template>

	<xsl:template match="node()" mode="PrintChildFrontCap">
		<xsl:variable name="childCaps" select="$allBusinessCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		<xsl:variable name="containerDivStyle">
			<xsl:choose>
				<xsl:when test="count($childCaps) > $coreCapsMaxDepth">threeColModel_valueChainColumnContainerDouble pull-left</xsl:when>
				<xsl:otherwise>threeColModel_valueChainColumnContainer pull-left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="chevronDivStyle">
			<xsl:choose>
				<xsl:when test="count($childCaps) > $coreCapsMaxDepth">threeColModel_valueChainObjectDouble small bg-primary8</xsl:when>
				<xsl:otherwise>threeColModel_valueChainObject small bg-primary8</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="{$containerDivStyle}">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="$chevronDivStyle"/>
				<xsl:with-param name="anchorClass">text-default</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates mode="PrintGrandChildFrontCap" select="$childCaps">
				<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>


	<xsl:template match="node()" mode="PrintGrandChildFrontCap">
		<xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), (), 0)"/>
		<div class="threeColModel_ObjectContainer">
			<xsl:variable name="planRelationsForBusCap" select="$allStratPlanForElements[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $relevantBusCaps/name]"/>
			<xsl:variable name="detailedPlansForBusCap" select="$allStratPlans[own_slot_value[slot_reference = 'strategic_plan_for_elements']/value = $planRelationsForBusCap/name]"/>
			<xsl:variable name="directPlansForBusCap" select="$allStratPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $relevantBusCaps/name]"/>	
			<xsl:variable name="plansForBusCap" select="$detailedPlansForBusCap union $directPlansForBusCap"/>
			<xsl:variable name="projectsForBusCap" select="$allProjects[name = $plansForBusCap/own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value]"/>
			<xsl:variable name="plansProjectCount" select="count($projectsForBusCap)"/>
			<xsl:variable name="footprintStyle">
				<xsl:choose>
					<xsl:when test="$plansProjectCount > $highProjectThreshold">
						<xsl:value-of select="$highFootprintStyle"/>
					</xsl:when>
					<xsl:when test="$plansProjectCount > $medProjectThreshold">
						<xsl:value-of select="$medFootprintStyle"/>
					</xsl:when>
					<xsl:when test="$plansProjectCount > $lowProjectThreshold">
						<xsl:value-of select="$lowFootprintStyle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$noFootprintStyle"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="overlayStyle" select="concat('threeColModel_NumberHeatmap fontBlack text-white alignCentre ', $footprintStyle)"/>
			<div class="threeColModel_ObjectBackgroundColour bg-primary9"/>
			<div>
				<xsl:attribute name="class" select="$overlayStyle"/>
				<xsl:value-of select="$plansProjectCount"/>
			</div>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass">threeColModel_Object small </xsl:with-param>
				<xsl:with-param name="anchorClass">text-default</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="count($projectsForBusCap) > 0">
					<div class="ess-tooltip" style="z-index:10000;">
						<xsl:call-template name="busCapProjectList">
							<xsl:with-param name="inScopeProjects" select="$projectsForBusCap"/>
						</xsl:call-template>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="ess-tooltip" style="width:120px;">
						<em>No projects mapped</em>
					</div>
				</xsl:otherwise>
			</xsl:choose>


			<xsl:call-template name="heatmap">
				<xsl:with-param name="thisBusCap" select="current()"/>
			</xsl:call-template>
		</div>
	</xsl:template>


	<xsl:template name="heatmap">
		<xsl:param name="thisBusCap"/>

		<xsl:variable name="busCap" select="eas:findAllSubCaps($thisBusCap, (), 0)"/>
		<xsl:variable name="blobWidth">
			<xsl:choose>
				<xsl:when test="count($stratGoals)=0">
					<xsl:value-of select="112"/>
				</xsl:when>
				<xsl:when test="count($stratGoals)=4">
					<xsl:value-of select="round((112 div count($stratGoals)))-1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round((112 div count($stratGoals)))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="blobWidthLast">
			<xsl:choose>
				<xsl:when test="count($stratGoals)=0">
					<xsl:value-of select="112"/>
				</xsl:when>
				<xsl:when test="count($stratGoals) = 4">
					<xsl:value-of select="round(112 div count($stratGoals))-1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round(112 div count($stratGoals))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--<xsl:variable name="blobWidth" select="round((122 div count($stratGoals))-1)"/>
		<xsl:variable name="blobWidthLast" select="round(122 div count($stratGoals)-1)"/>-->
		<xsl:variable name="blobWidthStyle" select="concat('width:', string($blobWidth), 'px')"/>
		<xsl:variable name="blobWidthStyleLast" select="concat('width:', string($blobWidthLast), 'px')"/>
		<xsl:variable name="objsForCap" select="$stratObjectives[own_slot_value[slot_reference = 'supporting_business_capabilities']/value = $busCap/name]"/>
		<xsl:variable name="stratGoalsForCap" select="$stratGoals[own_slot_value[slot_reference = 'objective_supported_by_objective']/value = $objsForCap/name]"/>
		<div class="heatmapContainer bg-white">
			<xsl:for-each select="$stratGoals">
				<xsl:variable name="stratGoalStyleClass" select="eas:get_strategic_goal_colour(current())"/>
				<xsl:variable name="blobClass">
					<xsl:choose>
						<xsl:when test="current()/name = $stratGoalsForCap/name">
							<xsl:value-of select="concat('heatmapDivider ', 'heatmapElement ', $stratGoalStyleClass)"/>
						</xsl:when>
						<xsl:otherwise>heatmapElement heatmapDivider</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="blobClassLast">
					<xsl:choose>
						<xsl:when test="current()/name = $stratGoalsForCap/name">
							<xsl:value-of select="concat('heatmapElement ', $stratGoalStyleClass)"/>
						</xsl:when>
						<xsl:otherwise>heatmapElement</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="not(position() = last())">
						<div style="{$blobWidthStyle}">
							<xsl:attribute name="class" select="$blobClass">&#32;</xsl:attribute>
						</div>
					</xsl:when>
					<xsl:when test="position() = last()">
						<div style="{$blobWidthStyleLast}">
							<xsl:attribute name="class" select="$blobClassLast">&#32;</xsl:attribute>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div style="{$blobWidthStyleLast}">
							<xsl:attribute name="class" select="$blobClass">&#32;</xsl:attribute>
						</div>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="busCapObjsForStratGoal" select="$objsForCap[name = current()/own_slot_value[slot_reference = 'objective_supported_by_objective']/value]"/>
				<xsl:choose>
					<xsl:when test="count($busCapObjsForStratGoal) > 0">
						<div class="ess-tooltip width250px">
							<h4>Strategic Objectives</h4>
							<ul>
								<xsl:for-each select="$busCapObjsForStratGoal">
									<li>
										<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
									</li>
								</xsl:for-each>
							</ul>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="ess-tooltip width250px">
							<em>No objectives mapped</em>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
		<div class="verticalSpacer_5px bg-white"/>
	</xsl:template>



	<xsl:template name="dynamicKey">
		<script type="text/javascript">
			$('document').ready(function(){
				$(".threeColModel_dynamicKeyDescription").hide();
				$(".threeColModel_dynamicKeyObject").click(function(){
					$(".threeColModel_dynamicKeyDescription").hide()
					$(this).next(".threeColModel_dynamicKeyDescription").slideToggle();
				});
				$(".descClose").click(function(){
					$(".threeColModel_dynamicKeyDescription").hide()
				});
			});
		</script>
		<style>
			.descClose:hover{
			    cursor: pointer;
			}</style>
		<div class="dynamicKey">
			<div class="threeColModel_dynamicKeyTitle small" style="width:120px;">
				<strong>
					<span class="uppercase">Strategic Goals:</span>
				</strong>
			</div>
			<xsl:for-each select="$stratGoals">
				<xsl:variable name="objsForGoal" select="$stratObjectives[name = current()/own_slot_value[slot_reference = 'objective_supported_by_objective']/value]"/>
				<div class="threeColModel_dynamicKeyContainer">
					<xsl:variable name="goalStyleClass" select="eas:get_strategic_goal_colour(current())"/>
					<xsl:variable name="fullStyle">
						<xsl:choose>
							<xsl:when test="string-length($goalStyleClass) > 0">
								<xsl:value-of select="concat('threeColModel_dynamicKeyObject fontBlack small ', $goalStyleClass)"/>
							</xsl:when>
							<xsl:otherwise>threeColModel_dynamicKeyObject bg-primary6 fontBlack small</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<div class="{$fullStyle}">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="anchorClass">text-white</xsl:with-param>
						</xsl:call-template>
					</div>
					<!--<div class="threeColModel_dynamicKeyDescription bg-white text-default">-->
					<div class="ess-tooltip">
						<ul>
							<xsl:for-each select="$objsForGoal">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</div>
				</div>
			</xsl:for-each>
		</div>

	</xsl:template>

	<xsl:template name="projectImpactKey">

		<div class="piKeyContainer">
			<div class="clear"/>
			<div class="verticalSpacer_10px"/>
			<div id="keyContainer">
				<div class="keyLabel uppercase" style="width:150px;">Project Footprint:</div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $highFootprintStyle)"/>
				</div>
				<div class="keySampleLabel">High</div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $medFootprintStyle)"/>
				</div>
				<div class="keySampleLabel">Medium</div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $lowFootprintStyle)"/>
				</div>
				<div class="keySampleLabel">Low</div>
				<div>
					<xsl:attribute name="class" select="concat('keySampleWide ', $noFootprintStyle)"/>
				</div>
				<div class="keySampleLabel">None</div>
				<div class="horizSpacer_30px pull-left"/>
				<div class="keySampleLabel"># = Number of Projects Impacting this Capability</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="fullProjectList">
		<!--<div class="horizSpacer_20px pull-left"/>-->
		<xsl:if test="count($allProjects) > 0">
			<div class="pull-left projectList">
				<h2 class="sch_textColour_claret">Projects</h2>
				<div class="verticalSpacer_5px"/>
				<div class="projects">
					<xsl:for-each select="$allProjects">
						<xsl:variable name="currentProj" select="current()"/>
						<div class="pull-left clear">

							<!-- Fade out the closed projects and resize number if greater than 99 -->
							<xsl:variable name="aStyleString">circleButton <xsl:value-of select="eas:getButtonColour($currentProj)"/> text-white pull-left <xsl:value-of select="eas:getButtonFontSize(position(), '')"/></xsl:variable>
							<div>
								<xsl:attribute name="class" select="$aStyleString"/>
								<xsl:value-of select="position()"/>
							</div>
							<div class="buttonLabel pull-left" style="width:200px;">
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$currentProj"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									<xsl:with-param name="anchorClass">small text-default</xsl:with-param>
								</xsl:call-template>
							</div>
						</div>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template name="busCapProjectList">
		<xsl:param name="inScopeProjects" select="$allProjects"/>
		<!--<div class="horizSpacer_20px pull-left"/>-->
		<xsl:if test="count($inScopeProjects) > 0">
			<h2 class="sch_textColour_claret fontBlack">Projects</h2>
			<div class="verticalSpacer_5px"/>
			<xsl:for-each select="$inScopeProjects">
				<xsl:variable name="currentProj" select="current()"/>
				<div class="clearfix" style="width:250px;">

					<!-- Fade out the closed projects and resize number if greater than 99 -->
					<xsl:variable name="aStyleString">circleButtonSmall <xsl:value-of select="eas:getButtonColour($currentProj)"/> text-white pull-left <xsl:value-of select="eas:getButtonFontSize(index-of($allProjects, $currentProj), 'small')"/></xsl:variable>
					<div>
						<xsl:attribute name="class" select="$aStyleString"/>
						<xsl:value-of select="index-of($allProjects, $currentProj)"/>
					</div>
					<div class="buttonLabelSmall small" style="width:200px;">
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$currentProj"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="anchorClass">text-default</xsl:with-param>
						</xsl:call-template>
					</div>
				</div>
			</xsl:for-each>

		</xsl:if>
	</xsl:template>

	<!-- Find all the sub capabilities of the specified parent capability -->
	<xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"></xsl:param>
		<xsl:param name="theChildCaps"></xsl:param>
		<xsl:param name="theDepth"/>
		
		<xsl:choose>
			<xsl:when test="(count($theParentCap) > 0) and ($coreCapsMaxDepth >= $theDepth)">		
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference='buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusinessCaps[name=$childRels/own_slot_value[slot_reference='buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aDirectChildList" select="$allBusinessCaps[own_slot_value[slot_reference='supports_business_capabilities']/value = $theParentCap/name]"/>
				<xsl:variable name="aNewList" select="$aDirectChildList union $aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:sequence select="eas:findAllSubCaps($aNewList, $aNewChildren, $theDepth + 1)"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:template name="levelSelectForm">
		<div class="pull-left">
			<div class="verticalSpacer_10px"/>
			<div class="pull-left">
					<strong>Levels to Show:&#160;&#160;&#160;</strong>
			</div>
			<div class="pull-left">
				<form class="width60px" id="levelSelect">
					<select class="level_select">
						<option selected="selected">
							<xsl:attribute name="value">
								<xsl:call-template name="RenderLinkText">
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="theXSL">enterprise/core_el_bus_strategy_footprint_2level.xsl</xsl:with-param>
									<xsl:with-param name="theHistoryLabel">Business Strategy Footprint - 2 Level</xsl:with-param>
									<xsl:with-param name="theUserParams">isClosedProjects=<xsl:value-of select="$isClosedProjects"/></xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>2</option>
						<option>
							<xsl:attribute name="value">
								<xsl:call-template name="RenderLinkText">
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="theXSL">enterprise/core_el_bus_strategy_footprint_3level.xsl</xsl:with-param>
									<xsl:with-param name="theHistoryLabel">Business Strategy Footprint - 3 Level</xsl:with-param>
									<xsl:with-param name="theUserParams">isClosedProjects=<xsl:value-of select="$isClosedProjects"/></xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>3</option>
					</select>
				</form>
			</div>
			<div class="pull-left horizSpacer_30px"/>
			<div class="pull-left">
				<xsl:variable name="checkBoxAction">
					<xsl:choose>
						<xsl:when test="$isClosedProjects = 'true'"/>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="closedProjectFilter">
					<xsl:choose>
						<xsl:when test="string-length($checkBoxAction) = 0">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:call-template name="PrintCheckboxScript">
					<xsl:with-param name="queryString" select="concat($basicQueryString,'&amp;isClosedProjects=', $closedProjectFilter)"/>
					<xsl:with-param name="checkboxName" select="'closedProjectCheckbox'"/>
					<xsl:with-param name="checkboxLabel" select="'Include Projects Closed in Current Year'"/>
					<xsl:with-param name="isSelected" select="$checkBoxAction"/>
					<xsl:with-param name="formWidth" select="'200px'"/>
				</xsl:call-template>
			</div>

		</div>
	</xsl:template>

	<!-- function to get the set of projects in scope -->
	<xsl:function name="eas:getProjectsInScope">
		<xsl:param name="isShowClosedProjects"/>

		<xsl:choose>
			<xsl:when test="$isShowClosedProjects = 'false'">
				<xsl:sequence select="$noClosedProjects"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="aClosedProjects" select="$allAllProjects[own_slot_value[slot_reference = 'project_lifecycle_status']/value = $anExcludeStatus/name]"/>
				<xsl:variable name="aThisYearsClosed" select="$aClosedProjects[own_slot_value[slot_reference = 'ca_forecast_end_date']/value = $aTimeScope/name]"/>
				<xsl:variable name="anUndefinedCloseYear" select="$aClosedProjects[count(own_slot_value[slot_reference = 'ca_forecast_end_date']) = 0]"/>
				<xsl:sequence select="$noClosedProjects union $aThisYearsClosed union $anUndefinedCloseYear"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- Find the font size that should be used to render the number in the buttons
	on the legend -->
	<xsl:function name="eas:getButtonFontSize">
		<xsl:param name="theNumber"/>
		<xsl:param name="theButtonSize"/>
		<xsl:choose>
			<xsl:when test="$theButtonSize = 'small'">
				<xsl:choose>
					<xsl:when test="$theNumber > 99">xxxsmall</xsl:when>
					<xsl:otherwise>small</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$theNumber > 99">xxsmall</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- find the colour rendering the button based on whether the project is open or closed -->
	<xsl:function name="eas:getButtonColour">
		<xsl:param name="theProject"/>
		<xsl:choose>
			<xsl:when test="$theProject/own_slot_value[slot_reference = 'project_lifecycle_status']/value = $anExcludeStatus/name">sch_claret_40</xsl:when>
			<xsl:otherwise>sch_claret_100</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Get the colour associated with the given strategic goal -->
	<xsl:function name="eas:get_strategic_goal_colour">
		<xsl:param name="stratGoal"/>
		
		<xsl:variable name="goalIndex" select="index-of($stratGoals, $stratGoal)"/>
		<xsl:value-of select="$stratGoalColours[$goalIndex]"/>
		
	</xsl:function>

</xsl:stylesheet>
