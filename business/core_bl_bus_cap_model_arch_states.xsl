<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../business/core_bl_bus_cap_model_include.xsl"/>
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Product_Type', 'Group_Actor', 'Project', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- 15.06.2018 JP  Created	 -->


	<!-- START VIEW SPECIFIC VARIABLES -->

	<xsl:variable name="allProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="allEnterpriseStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan']"/>

	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCapabilityConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Root Business Capability')]"/>
	<xsl:variable name="rootBusCapability" select="$allBusinessCaps[name = $rootBusCapabilityConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="rootBusCapName" select="$rootBusCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="topLevelBusCapabilities" select="$allBusinessCaps[own_slot_value[slot_reference = 'supports_business_capabilities']/value = $rootBusCapability/name]"/>
	<xsl:variable name="parentCap" select="$allBusinessCaps[name = $rootBusCapability/own_slot_value[slot_reference = 'supports_business_capabilities']/value]"/>
    <xsl:variable name="busObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>

	<xsl:variable name="allBusCapRoles" select="/node()/simple_instance[type = 'Business_Capability_Role']"/>
	<xsl:variable name="capFrontPositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Front']"/>
	<xsl:variable name="capBackPositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Back']"/>
	<xsl:variable name="capManagePositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Manage']"/>


	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="topLevelFrontBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capFrontPositon/name)]"/>
	<xsl:variable name="topLevelBackBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capBackPositon/name)]"/>
	<xsl:variable name="topLevelManageBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capManagePositon/name)]"/>
    
	<xsl:variable name="allArchStates" select="/node()/simple_instance[own_slot_value[slot_reference = 'arch_state_business_conceptual']/value = $allBusinessCaps/name]"/>

	<xsl:variable name="DEBUG" select="''"/>

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
				<title>Business Capability Model</title>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<link type="text/css" rel="stylesheet" href="ext/apml/custom.css"/>
				<script src="js/jquery-migrate-1.4.1.min.js" type="text/javascript"/>
				<!--JQuery plugin to support tooltips-->
	 			<script src="js/jquery.tools.min.js" type="text/javascript"/>
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
					var bcmTemplate;
					
					
					// the JSON objects for the Business Capability Model (BCM)
				  	var bcmData = {
				  		name: '<xsl:value-of select="$rootBusCapName"/>',
						showRoadmap: <xsl:choose><xsl:when test="count($allArchStates) > 0">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>,
						archStates: [
				  			<xsl:if test="count($allArchStates) > 0">
				  				{
				  					id: 'All',
				  					name: 'All'
				  				},
				  				<xsl:apply-templates mode="RenderArchStateData" select="$allArchStates">
				  					<xsl:sort select="own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
				  				</xsl:apply-templates>
				  			</xsl:if>
						],
				  		manage: [
				  			<xsl:apply-templates mode="RenderBCMData" select="$topLevelManageBusCapRelss">
								<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)" data-type="number"/>
							</xsl:apply-templates>
				  		],
				  		front: [
				  			<xsl:apply-templates mode="RenderBCMData" select="$topLevelFrontBusCapRelss">
								<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)" data-type="number"/>
							</xsl:apply-templates>
				  		],
				  		back: [
				  			<xsl:apply-templates mode="RenderBCMData" select="$topLevelBackBusCapRelss">
								<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)" data-type="number"/>
							</xsl:apply-templates>
				  		],
				  	
				  	};
				  	
					
					<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
					function filterBusCap(busCap, archStateID) {
						if(busCap.archStates.indexOf(archStateID) > -1) {
							$('#' + busCap.id).show(1000);
						} else {
							$('#' + busCap.id).hide(1000);
						}
						
						var childBusCaps = busCap.childBusCaps;
						for( var i = 0; i &lt; childBusCaps.length; i++ ){
							filterBusCap(childBusCaps[i], archStateID);
						}
					}
					
					function filterAllBusCaps(archStateID) {
						for( var i = 0; i &lt; bcmData.manage.length; i++ ){
							filterBusCap(bcmData.manage[i], archStateID);
						};
						
						for( var j = 0; j &lt; bcmData.front.length; j++ ){
							filterBusCap(bcmData.front[j], archStateID);
						};
						
						for( var k = 0; k &lt; bcmData.back.length; k++ ){
							filterBusCap(bcmData.back[k], archStateID);
						};
					}
					
					function showBusCap(busCap) {
						$('#' + busCap.id).show(1000);
						var childBusCaps = busCap.childBusCaps;
						for( var i = 0; i &lt; childBusCaps.length; i++ ){
							showBusCap(childBusCaps[i]);
						}
					}
					
					function showAllBusCaps() {
						for( var i = 0; i &lt; bcmData.manage.length; i++ ){
							showBusCap(bcmData.manage[i]);
						};
						
						for( var j = 0; j &lt; bcmData.front.length; j++ ){
							showBusCap(bcmData.front[j]);
						};
						
						for( var k = 0; k &lt; bcmData.back.length; k++ ){
							showBusCap(bcmData.back[k]);
						};
					}
					
					function drawBCM() {
						$("#bcmModel").html(bcmTemplate(bcmData));
						
						var greatestWidth = 0;   // Stores the greatest width
						
						$(".threeColModel_wideColumnContainerCaps").each(function() {    // Select the elements you're comparing
					
							var theWidth = $(this).width();   // Grab the current width
							
							if( theWidth > greatestWidth) {   // If theWidth > the greatestWidth so far,
								greatestWidth = theWidth;     //    set greatestWidth to theWidth
							}
						});
							
						$(".threeColModel_LogoSection").width(greatestWidth-20);     // Update the elements you were comparing
					
						greatestWidth = 0;
						
						$("#coreBusServices").each(function() {    // Select the elements you're comparing
						
							var theWidth = $(this).width();   // Grab the current width
							
							if( theWidth > greatestWidth) {   // If theWidth > the greatestWidth so far,
								greatestWidth = theWidth;     //    set greatestWidth to theWidth
							}
						});
						
						$(".threeColModel_wideRow").width(greatestWidth);     // Update the elements you were comparing
						$(".threeColModel_scrollable").width(greatestWidth+370);     // Update the elements you were comparing
						
						$(".threeColModel_Object").vAlign();
						$(".buttonLabel").vAlign();
						$(".threeColModel_ObjectAlt").vAlign();				
						$(".threeColModel_ObjectDouble").vAlign();
						$(".threeColModel_dynamicKeyTitle").vAlign();
						$(".threeColModel_dynamicKeyObject").vAlign();
						$(".threeColModel_valueChainObjectDouble").vAlign();
					}
										
					$('document').ready(function(){
						
						<!-- SET UP THE BCM MODEL -->
						Handlebars.registerHelper('bcmDivider', function(index, options) {
						    var fnTrue = options.fn, 
						        fnFalse = options.inverse;
						
						    return (index > 0) &amp;&amp; (index % 6 == 0) ? fnTrue(this) : fnFalse(this);
						});						
						
						Handlebars.registerHelper('doubleWidth', function(length, options) {
						    var fnTrue = options.fn, 
						        fnFalse = options.inverse;
						
						    return length > 5 ? fnTrue(this) : fnFalse(this);
						});		

						
						//initialise the BCM model
						var bcmFragment   = $("#bcm-template").html();
						bcmTemplate = Handlebars.compile(bcmFragment);
						
						if(bcmData.showRoadmap) {
							//INITIALISE THE ARCH STATE DROP DOWN LIST
							$('#archStateList').select2({theme: "bootstrap"});
						
							var archStateFragment = $("#arch-state-template").html();
							var archStateTemplate = Handlebars.compile(archStateFragment);
							$("#archStateList").html(archStateTemplate(bcmData));
							
							$('#archStateList').on('change', function (evt) {
							  var thisArchStateID = $(this).select2("val");
							  if(thisArchStateID != 'All') {
							  	filterAllBusCaps(thisArchStateID);
							  } else {
							  	showAllBusCaps();
							  }				
							});
						}
						
						drawBCM();
						
						
					});
					
					
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
					    border-radius: 3px;
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
					    border-radius: 0 0 5px 5px;
					}
					
					.threeColModel_wideRow{
					    border: 1px solid #aaa;
					    border-radius: 3px;
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
					    line-height: 1.2em;
					    box-sizing: content-box;
                    box-shadow: 2px 2px 1px #d3d3d3;
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
					}
					
					.threeColModel_LogoSection{
					    border-radius: 5px 5px 0px 0px;
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
					    width: 200px;
					    height: 50px;
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
					    width: 120px;
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
					
					.backColour18{
					    background-color: #c6bd9a;  
					}
					
					.backColour19{
					    background-color: #e6e0bf;
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
					  //  display: none;
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
					    z-index: 10;
					}
					
					.cornerTriangleBlue{
					    background-image: url(images/cornerTriangleBlue.png);
					}
					
					.cornerTriangleRed{
					    background-image: url(images/cornerTriangleRed.png);
					}
					
					.cornerTriangleGreen{
					    background-image: url(images/cornerTriangleGreen.png);
					}
					
					.cornerTriangleLightGreen{
					    background-image: url(images/cornerTriangleLightGreen.png);
					}
                    
                    .cornerTriangleGrey{
					    background-image: url(images/cornerTriangleGrey.png);
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
					}</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Business Capability Model</span>
								</h1>
								<xsl:value-of select="$DEBUG"/>
							</div>
						</div>

						<!--Setup Description Section-->
						<xsl:call-template name="gdpBusCapModelInclude"/>
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="simple-scroller">
									<div class="pull-left">
										<div class="threeColModel_LogoSection bg-primary">
											<div class="verticalSpacer_10px clear"/>
											<div class="fontBlack large text-white"><xsl:value-of select="$rootBusCapName"/> Business Capabilities</div>
											<xsl:if test="count($allArchStates) > 0">
												<div class="verticalSpacer_10px clear"/>
												<label>
													<span>Architecture State Selection</span>
												</label>
												<select id="archStateList" class="form-control" style="width:50%"/>						
											</xsl:if>
											<div class="verticalSpacer_10px clear"/>
										</div>
										<div class="clear"/>
										<div id="bcmModel" class="threeColModel_wideColumnContainerCaps pull-left"/>					
									</div>
								</div>
							</div>
						</div>
						<div class="verticalSpacer_10px"/>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                <script>
                    $(".chooseObj").change(function(index) {
                        var thisObj = $('.chooseObj').val();
                        $('.threeColModel_valueChainObject').css('background-color', '#c6bd9a');
                        $('.threeColModel_ObjectBackgroundColour').css('background-color', '#e6e0bf');
                    for (i = 0; i &lt; objectives.length; i++) {
                        if (objectives[i].id === thisObj) {
                             
                            for (j = 0; j &lt; objectives[i].caps.length; j++) {
                                var box = objectives[i].caps[j].capability
                               console.log(box);
                            var div = document.getElementById(box);

                                $("." + box).css("background-color", "#e29bd0");
                            }
                        }
                        
                    
                        }
                    });
             <!--             for (i = 0; i &lt; thisObj.caps.length; i++) {
                                          
                        var id = objectives[i]['id'];
                            console.log(id);
                                                   };
                                                       });//end 
                                         
                                                   
                        if( +statusbox == 1 )
                        {
                          $('tr#status td:nth-child('+ slotbox +')' ).css('background-color', 'green');
                         } else {
                          $('tr#status td:nth-child('+ slotbox +')' ).css('background-color', 'red');
                         }
                        if( +codebox == 1 )
                        {
                          $('tr#code td:nth-child('+ slotbox +')' ).css('background-color', 'green');
                         } else {
                          $('tr#code td:nth-child('+ slotbox +')' ).css('background-color', 'red');
                         }
        -->
                               
                </script>
			</body>
		</html>
	</xsl:template>
	
	
	<!-- ARCHITECTURE STATE DATA TEMPLATES -->
	<xsl:template mode="RenderArchStateData" match="node()">
		<xsl:variable name="archStateStartDate" select="eas:getXSLDateFromString(own_slot_value[slot_reference = 'start_date_iso_8601']/value)"/>
		<xsl:variable name="archStateEndDate"  select="eas:getXSLDateFromString(own_slot_value[slot_reference = 'end_date_iso_8601']/value)"/>
		<xsl:variable name="archStateName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template><xsl:text disable-output-escaping="yes"> &#91;</xsl:text><xsl:value-of select="$archStateStartDate"/> - <xsl:value-of select="$archStateEndDate"/><xsl:text disable-output-escaping="yes">&#93;</xsl:text>
		</xsl:variable>

		{
			id: '<xsl:value-of select="translate(current()/name, '.', '_')"/>',
			name: '<xsl:value-of select="$archStateName"/>'
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	<!-- FUNCTION TO CONVERT AN ISO 8601 DATE STRING INTO AN XSL DATE SIMPLE TYPE -->
	<xsl:function name="eas:getXSLDateFromString">
		<xsl:param name="dateString"/>
		
		<xsl:choose>
			<!-- test that the date string is of the correct length -->
			<xsl:when test="string-length($dateString) = 10">
				<!-- extract the individual year, month and day values -->
				<xsl:variable name="year" select="substring($dateString, 1, 4)"/>
				<xsl:variable name="month" select="substring($dateString, 6, 2)"/>
				<xsl:variable name="day" select="substring($dateString, 9, 2)"/>
				
				<!-- return an xsl date simple type for the given date string -->
				<xsl:variable name="theDate" select="functx:date($year, $month, $day)"/>
				<xsl:call-template name="AbbrevFormatDate">
					<xsl:with-param name="theDate" select="$theDate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- if the date string is not of the corretc length, return the current date as an xsl date simple type -->
				<xsl:value-of select="'*'"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<!-- BUSINESS CAPABILITY MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderBCMData" match="node()">
		<xsl:variable name="thisBusCap" select="$allBusinessCaps[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
		<xsl:variable name="busCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="busCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisBusCap"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="busCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$thisBusCap"/>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childBusCaps" select="$allChildCap2ParentCapRels[own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value  = $thisBusCap/name]"/>
		<xsl:variable name="archStates" select="$allArchStates[own_slot_value[slot_reference = 'arch_state_business_conceptual']/value = $thisBusCap/name]"/>
		{
			id: "<xsl:value-of select="translate($thisBusCap/name, '.', '_')"/>",
			name: "<xsl:value-of select="$busCapName"/>",
			link: "<xsl:value-of select="$busCapLink"/>",
			description: "<xsl:value-of select="eas:renderJSText($busCapDescription)"/>",
			childBusCaps: [
				<xsl:apply-templates select="$childBusCaps" mode="RenderBCMData">
					<xsl:sort select="number(own_slot_value[slot_reference = 'business_capability_index']/value)"/>
				</xsl:apply-templates>
			],
			visible: true,
			archStates: [<xsl:apply-templates mode="RenderInstanceIdJSON" select="$archStates"/>]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template mode="RenderInstanceIdJSON" match="node()">
		'<xsl:value-of select="translate(current()/name, '.', '_')"/>'<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	
	<xsl:template name="gdpBusCapModelInclude">
		<script id="arch-state-template" type="text/x-handlebars-template">
			{{#archStates}}
				<option>
					<xsl:attribute name="value"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
					{{name}}
				</option>
			{{/archStates}}
		</script>
		
		<script id="bcm-template" type="text/x-handlebars-template">
					<div class="clear"/>
					{{#manage}}
						<div class="threeColModel_wideRowCaps">
							<div class="threeColModel_sectionTitle fontBlack">
								<span class="text-primary">{{{link}}}</span>
							</div>
							{{#childBusCaps}}
								{{#if visible}}
									<div class="threeColModel_ObjectContainer">    
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div>
											<xsl:attribute name="class">threeColModel_ObjectBackgroundColour backColour19 {{id}}</xsl:attribute>
										</div>
										<div class="threeColModel_Object small">{{{link}}}</div>
							        </div>
								{{/if}}
							{{/childBusCaps}}
						</div>
						<div class="threeColModel_wideRowCapsDivider"/>
					{{/manage}}
					{{#front}}
						<div class="threeColModel_wideRowCaps">
							<div class="threeColModel_sectionTitle fontBlack" id="coreBusServices">
								<div class="threeColModel_sectionTitle fontBlack">
									{{{link}}}
								</div>
				            </div>
				        	{{#childBusCaps}}
								<div>
									<xsl:attribute name="class">{{#doubleWidth childBusCaps.length}}threeColModel_valueChainColumnContainerDouble pull-left{{else}}threeColModel_valueChainColumnContainer pull-left{{/doubleWidth}}</xsl:attribute>
									<div>
										<xsl:attribute name="class">{{#doubleWidth childBusCaps.length}}threeColModel_valueChainObjectDouble small backColour18{{else}}threeColModel_valueChainObject small backColour18{{/doubleWidth}}</xsl:attribute>
										<span class="text-primary">{{{link}}}</span>
									</div>
									{{#childBusCaps}}
										{{#if visible}}
											<div class="threeColModel_ObjectContainer">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
												<div>
													<xsl:attribute name="class">threeColModel_ObjectBackgroundColour backColour19 {{id}}</xsl:attribute>
												</div>
												<div class="threeColModel_Object small">{{{link}}}</div>
									        </div>
										{{/if}}
									{{/childBusCaps}}
								</div>
								{{#bcmDivider @index}}
									<div class="col-xs-12" id="break"/>
								{{/bcmDivider}}
							{{/childBusCaps}}
						</div>
						<div class="threeColModel_wideRowCapsDivider"/>
					{{/front}}
					{{#back}}
						<div class="threeColModel_wideRowCaps">
							<div class="threeColModel_sectionTitle fontBlack">
								{{{link}}}
							</div>
							{{#childBusCaps}}
								{{#if visible}}
									<div class="threeColModel_ObjectContainer">   
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div>
											<xsl:attribute name="class">threeColModel_ObjectBackgroundColour backColour19 {{id}}</xsl:attribute>
										</div>
										<div class="threeColModel_Object small">{{{link}}}</div>
							        </div>
								{{/if}}
							{{/childBusCaps}}
						</div>
						{{#unless @last}}
							<div class="threeColModel_wideRowCapsDivider"/>
						{{/unless}}
					{{/back}}
		</script>
	</xsl:template>

    
</xsl:stylesheet>
