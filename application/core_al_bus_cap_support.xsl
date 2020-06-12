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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Product_Type', 'Group_Actor', 'Project', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<!-- START VIEW SPECIFIC VARIABLES -->

	<xsl:variable name="allProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="allEnterpriseStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan']"/>

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

	

	<!-- Variables for supporting Apps -->
	<xsl:variable name="scopingApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusinessCaps/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"/>
	<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
    <xsl:variable name="processToAppRel" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']"/>
    <xsl:variable name="directProcessToAppRel" select="$processToAppRel[name=$relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
    <xsl:variable name="directProcessToApp" select="$scopingApps[name=$directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="relevantApps" select="$scopingApps[name= $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
    <xsl:variable name="relevantApps2" select="$scopingApps[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

	<xsl:variable name="allCodebaseStatii" select="/node()/simple_instance[(type = 'Codebase_Status')]"/>


	<xsl:variable name="coreCapsMaxDepth" select="5"/>

	<xsl:variable name="highAppThreshold" select="9"/>
	<xsl:variable name="medAppThreshold" select="4"/>
	<xsl:variable name="lowAppThreshold" select="0"/>
	<xsl:variable name="highFootprintStyle" select="'sch_claret_100'"/>
	<xsl:variable name="medFootprintStyle" select="'sch_claret_60'"/>
	<xsl:variable name="lowFootprintStyle" select="'sch_claret_20'"/>
	<xsl:variable name="noFootprintStyle" select="'bg-white'"/>

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
				<title>Business Application Footprint</title>
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
						$(".buttonLabel").vAlign();
						$(".threeColModel_ObjectAlt").vAlign();
						// $(".threeColModel_NumberHeatmap").vAlign();					
						$(".threeColModel_ObjectDouble").vAlign();
						$(".threeColModel_valueChainObject").vAlign();
						$(".threeColModel_dynamicKeyTitle").vAlign();
						$(".threeColModel_dynamicKeyObject").vAlign();
						$(".threeColModel_valueChainObjectDouble").vAlign();
					});
                </script>
				<script type="text/javascript">
					$('document').ready(function(){
						$(".threeColModel_NumberHeatmap").hide();
						$(".numberPos").hide();
						$(".piKeyContainer").hide();
						$(".overlayToggle").click(function(){
							$(".threeColModel_ObjectBackgroundColour").toggle();
							$(".threeColModel_NumberHeatmap").toggle();
							$(".numberPos").toggle();
							$(".piKeyContainer").slideToggle();
						});
					});
				</script>
				<script>
					$(document).ready(function(){
						// window.onunload = $(".ess-tooltip").hide();
						$('.numberPos').click(function() {
							$('[role="tooltip"]').remove();
							return false;
						});
						$('.numberPos').popover({
							container: 'body',
							html: true,
							sanitize: false,
							trigger: 'click',
							content: function(){
								return $(this).next().html();
							}
						});
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
						max-height: 40px;
						overflow: hidden;
					    margin-bottom: 5px;
					    text-align: center;
					    background: url(images/value_chain_arrow_end.png) no-repeat right center;
					    position: relative;
					    box-sizing: content-box;
                         line-height: 1.1em;
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
					    position: relative;
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
					    line-height: 1.0em;
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
					    background-color: #ffcd01;
					}
					
					.backColour19{
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
					
					<!--.ess-tooltip{
					    background-color: #fff;
					    border: 2px solid #eee;
					    padding: 5px;
					    min-width: 350px;
					    display: none;
					    border-radius: 3px;
					    box-shadow: 0px 3px 5px #ccc;
					    z-index: 5000;
					    text-align: left;
					}-->
					

					
					
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
					.popover,.tooltip {
						max-width: none;
					}
					.tooth-active {
						bottom: 26px;
					}
				</style>
            
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
									<span class="text-darkgrey">Business Application Footprint</span>
								</h1>
								<xsl:value-of select="$DEBUG"/>
							</div>
						</div>

						<!--Setup Description Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
								</div>
								<div>
									<h2 class="text-primary">Model</h2>                         
								</div>
								<div class="content-section">
									<p>The Business Application Footprint provides a strategic overview of the scale of applications supporting the business capabilities of the enterprise.</p>
								</div>
								<div class="verticalSpacer_5px"/>
								<div class="content-section">
									<div class="smallButton bg-primary text-white fontBlack pull-left overlayToggle" style="width:250px">Show/Hide Application Footprint</div>
									<div class="horizSpacer_10px pull-left"/>
									<xsl:call-template name="overlayLegend"/>
									<div class="verticalSpacer_10px"/>
									<div class="simple-scroller">
										<xsl:call-template name="anchorModel"/>
									</div>

								</div>
							</div>
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
				<xsl:apply-templates mode="PrintTopLevelFrontCap" select="$topLevelFrontBusCapRelss"/>
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
				<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
			</xsl:call-template>
			<xsl:variable name="childCaps" select="$allBusinessCaps[name = $thisManageBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
			<xsl:apply-templates mode="PrintGrandChildFrontCap" select="$childCaps">
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
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
				<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>


	<xsl:template match="node()" mode="PrintTopLevelFrontCap">
		<xsl:variable name="thisFrontBusCap" select="$allBusinessCaps[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
		<div class="threeColModel_wideRowCaps">
			<div class="threeColModel_sectionTitle fontBlack " id="coreBusServices">
				<!--<xsl:value-of select="$thisFrontBusCap/own_slot_value[slot_reference = 'name']/value"/>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisFrontBusCap"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="divClass">threeColModel_sectionTitle fontBlack </xsl:with-param>
					<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
				</xsl:call-template>
			</div>
			<xsl:variable name="childCaps" select="$allBusinessCaps[name = $thisFrontBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
			<xsl:apply-templates mode="PrintChildFrontCap" select="$childCaps">
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
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
				<xsl:when test="count($childCaps) > $coreCapsMaxDepth">threeColModel_valueChainObjectDouble small backColour18</xsl:when>
				<xsl:otherwise>threeColModel_valueChainObject small backColour18</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="{$containerDivStyle}">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="$chevronDivStyle"/>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates mode="PrintGrandChildFrontCap" select="$childCaps">
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>


	<xsl:template match="node()" mode="PrintGrandChildFrontCap">
		<xsl:variable name="currentBusCap" select="current()"/>
		<xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), ())"/>
		<div class="threeColModel_ObjectContainer">
			<xsl:variable name="thisBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
			<xsl:variable name="thisPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisBusProcs/name]"/>
            <xsl:variable name="thisdirectProcessToAppRel" select="$directProcessToAppRel[name=$thisPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
            
			<xsl:variable name="thisPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisPhysProcs/name]"/>
			<xsl:variable name="thisAppProRoles" select="$relevantAppProRoles[name = $thisPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
            
            <xsl:variable name="directProcessToApp" select="$scopingApps[name=$thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
			<xsl:variable name="thisApps" select="$scopingApps[name = $thisAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value] union $directProcessToApp"/>
			<xsl:variable name="thisAppCount" select="count($thisApps)"/>

			<xsl:variable name="footprintStyle">
				<xsl:choose>
					<xsl:when test="$thisAppCount > $highAppThreshold">
						<xsl:value-of select="$highFootprintStyle"/>
					</xsl:when>
					<xsl:when test="$thisAppCount > $medAppThreshold">
						<xsl:value-of select="$medFootprintStyle"/>
					</xsl:when>
					<xsl:when test="$thisAppCount > $lowAppThreshold">
						<xsl:value-of select="$lowFootprintStyle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$noFootprintStyle"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="overlayStyle" select="concat('threeColModel_NumberHeatmap  alignCentre ', $footprintStyle)"/>
			<div class="threeColModel_ObjectBackgroundColour backColour19"/>
			<div>
				<xsl:attribute name="class" select="$overlayStyle"/>
			</div>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$currentBusCap"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass">threeColModel_Object small </xsl:with-param>
				<xsl:with-param name="anchorClass">text-black</xsl:with-param>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="$thisAppCount > 0">
					<div class="numberPos">
						<span><xsl:value-of select="$thisAppCount"/></span>
					</div>
					<div class="popover" style="z-index:10000;">
						<xsl:call-template name="busCapAppList">
							<xsl:with-param name="inScopeApps" select="$thisApps"/>
						</xsl:call-template>
					</div>
				</xsl:when>
				<!--<xsl:otherwise>
					<div class="ess-tooltip" style="width:120px;">
						<em>No applications mapped</em>
					</div>
				</xsl:otherwise>-->
			</xsl:choose>
			<!--<div class="infoLink"><i class="fa fa-info-circle"/></div>-->
			

		</div>
	</xsl:template>


	<xsl:template name="overlayLegend">



		<div class="piKeyContainer">
			<div class="clear"/>
			<div class="verticalSpacer_10px"/>
			<div id="keyContainer">
				<div class="keyLabel uppercase" style="width:125px;">App Footprint:</div>
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
				<div class="keySampleLabel"># = Number of Applications Impacting this Capability</div>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="busCapAppList">
		<xsl:param name="inScopeApps" select="$scopingApps"/>
		<xsl:if test="count($inScopeApps) > 0">
			<div style="width: 350px;">
				<p class="fontBlack large">Applications</p>
				<div class="verticalSpacer_5px"/>
				<ul>
					<xsl:for-each select="$inScopeApps">
						<xsl:variable name="currentApp" select="current()"/>
						<xsl:variable name="appCodebase" select="$allCodebaseStatii[name = $currentApp/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template><xsl:text> (</xsl:text><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$appCodebase"/></xsl:call-template>)
						</li>
					</xsl:for-each>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>


	<!-- Find all the sub capabilities of the specified parent capability -->
	<xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildListA" select="$allBusinessCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aChildListB" select="$allBusinessCaps[name = $theParentCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
				<xsl:variable name="aChildList" select="$aChildListA union $aChildListB"/>
			
				<xsl:variable name="aNewList" select="$aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


</xsl:stylesheet>
