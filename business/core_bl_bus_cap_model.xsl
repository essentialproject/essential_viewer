<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
    <xsl:variable name="busObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>

	<xsl:variable name="allBusCapRoles" select="/node()/simple_instance[type = 'Business_Capability_Role']"/>
	<xsl:variable name="capFrontPositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Front']"/>
	<xsl:variable name="capBackPositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Back']"/>
	<xsl:variable name="capManagePositon" select="$allBusCapRoles[own_slot_value[slot_reference = 'name']/value = 'Manage']"/>


	<xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
	<xsl:variable name="topLevelFrontBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capFrontPositon/name)]"/>
	<xsl:variable name="topLevelBackBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capBackPositon/name)]"/>
	<xsl:variable name="topLevelManageBusCapRelss" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $rootBusCapability/name) and (own_slot_value[slot_reference = 'buscap_to_parent_role']/value = $capManagePositon/name)]"/>
    
    
    	<xsl:variable name="inScopeProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = 'Application_Provider']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>
	<xsl:variable name="allBusImpactStrategicPlans" select="/node()/simple_instance[(type = 'Business_Strategic_Plan') or ((type = 'Enterprise_Strategic_Plan'))]"/>
	<xsl:variable name="allAppImpactStrategicPlans" select="/node()/simple_instance[(type = 'Application_Strategic_Plan') or ((type = 'Enterprise_Strategic_Plan'))]"/>



	<xsl:variable name="coreCapsMaxDepth" select="5"/>

	<xsl:variable name="DEBUG" select="''"/>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Business Capability Model</title>
				<link type="text/css" rel="stylesheet" href="ext/apml/custom.css"/>
				<script src="ext/apml/jquery-migrate-1.2.1.min.js" type="text/javascript"/>
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
					$('document').ready(function(){
						$(".threeColModel_Object").vAlign();
						$(".buttonLabel").vAlign();
						$(".threeColModel_ObjectAlt").vAlign();
//						$(".threeColModel_NumberHeatmap").vAlign();					
						$(".threeColModel_ObjectDouble").vAlign();
						//$(".threeColModel_valueChainObject").vAlign();
						$(".threeColModel_dynamicKeyTitle").vAlign();
						$(".threeColModel_dynamicKeyObject").vAlign();
						$(".threeColModel_valueChainObjectDouble").vAlign();
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
						<div id="sectionDescription">
							<div class="col-xs-12">
								  
									<div class="simple-scroller">
										<xsl:call-template name="anchorModel"/>
									</div>

								</div>
							</div>
						


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
				<xsl:apply-templates mode="PrintTopLevelManageCap" select="$topLevelManageBusCapRelss">
					<xsl:sort select="$topLevelBusCapabilities[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]/own_slot_value[slot_reference = 'business_capability_index']/value" data-type="number"/>
				</xsl:apply-templates>
				<div class="threeColModel_wideRowCapsDivider"/>
				<xsl:apply-templates mode="PrintTopLevelFrontCap" select="$topLevelFrontBusCapRelss">
					<xsl:sort select="$topLevelBusCapabilities[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]/own_slot_value[slot_reference = 'business_capability_index']/value" data-type="number"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="PrintTopLevelManageCap" select="$topLevelBackBusCapRelss">
					<xsl:sort select="$topLevelBusCapabilities[name = current()/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]/own_slot_value[slot_reference = 'business_capability_index']/value" data-type="number"/>
				</xsl:apply-templates>
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
				<xsl:with-param name="anchorClass">text-primary  <xsl:value-of select="name"/></xsl:with-param>
			</xsl:call-template>
			<xsl:variable name="childCaps" select="$allBusinessCaps[name = $thisManageBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
			<xsl:apply-templates mode="PrintGrandChildFrontCap" select="$childCaps">
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value" data-type="number"/>
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
				<xsl:with-param name="divClass">threeColModel_Object small backColour19 <xsl:value-of select="name"/></xsl:with-param>
				<xsl:with-param name="anchorClass">text-black  <xsl:value-of select="name"/></xsl:with-param>
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
					<xsl:with-param name="anchorClass">text-primary  <xsl:value-of select="name"/></xsl:with-param>
				</xsl:call-template>

            </div>
        
			<xsl:variable name="childCaps" select="$allBusinessCaps[name = $thisFrontBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
			<xsl:apply-templates mode="PrintChildFrontCap" select="$childCaps">
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value" data-type="number"/>
			</xsl:apply-templates>
		</div>
		<div class="threeColModel_wideRowCapsDivider"/>

	</xsl:template>

<xsl:template match="node()" mode="PrintChildFrontCap">
    
		<xsl:variable name="childCaps" select="$allBusinessCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		<xsl:variable name="containerDivStyle">
			<xsl:choose>
				<xsl:when test="count($childCaps) > $coreCapsMaxDepth">threeColModel_valueChainColumnContainerDouble pull-left </xsl:when>
				<xsl:otherwise>threeColModel_valueChainColumnContainer pull-left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="chevronDivStyle">
			<xsl:choose>
				<xsl:when test="count($childCaps) > $coreCapsMaxDepth">threeColModel_valueChainObjectDouble small backColour18 <xsl:value-of select="name"/></xsl:when>
				<xsl:otherwise>threeColModel_valueChainObject small backColour18 <xsl:value-of select="name"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="{$containerDivStyle}">
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass" select="$chevronDivStyle"/>
				<xsl:with-param name="anchorClass">text-black  <xsl:value-of select="name"/></xsl:with-param>
			</xsl:call-template>
         
			<xsl:apply-templates mode="PrintGrandChildFrontCap" select="$childCaps">
				<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value" data-type="number"/>
			</xsl:apply-templates>

		</div>
    <xsl:if test="position() mod 6 = 0"><div class="col-xs-12" id="break"/></xsl:if>

	</xsl:template>


	<xsl:template match="node()" mode="PrintGrandChildFrontCap">
		<xsl:variable name="currentBusCap" select="current()"/>
		<xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), ())"/>
        <xsl:variable name="thisID" select="$currentBusCap/name"/>

		<div class="threeColModel_ObjectContainer">
          
            <xsl:variable name="overlayStyle"> <xsl:value-of select="concat('threeColModel_NumberHeatmap fontBlack text-white alignCentre ', 'blue ')"/> <xsl:value-of select="name"/></xsl:variable>
			<div class="threeColModel_ObjectBackgroundColour backColour19 {$thisID}"/>
			<div>
				<xsl:attribute name="class" select="$overlayStyle"/>
	
			</div>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$currentBusCap"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				<xsl:with-param name="divClass">threeColModel_Object small </xsl:with-param>
				<xsl:with-param name="anchorClass">text-black <xsl:value-of select="name"/></xsl:with-param>
			</xsl:call-template>
  

        </div>
	</xsl:template>
    
    <xsl:template name="cornerHightlight">
		<xsl:param name="thisBusCap"/>
        <xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), ())"/>
        <xsl:variable name="activityTotal">
			<xsl:call-template name="Calculate_Project_Activity">
				<xsl:with-param name="currentCap" select="$relevantBusCaps"/>
			</xsl:call-template>
		</xsl:variable>
		
	</xsl:template>
    
    



 	<xsl:template match="node()" mode="getCaps">
	   <xsl:sequence select="name"></xsl:sequence><xsl:text> </xsl:text>
        <xsl:apply-templates select="$allBusinessCaps[name=current()/own_slot_value[slot_reference='contained_business_capabilities']/value]" mode="getCaps"/>
	</xsl:template>   


	<xsl:template name="triangleLegend">
		<div class="triangleLegend">
			<div class="clear"/>
			<div class="verticalSpacer_10px"/>
		</div>
	</xsl:template>
    
    <xsl:template match="node()" mode="objectives">
		{"id":"<xsl:value-of select="name"/>", "name":"<xsl:value-of select="own_slot_value[slot_reference='name']/value"/>" ,"caps": [<xsl:apply-templates select="$allBusinessCaps[own_slot_value[slot_reference='business_objectives_for_business_capability']/value=current()/name]" mode="objectivesDetail"/>]}<xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
    <xsl:template match="node()" mode="objectivesDetail">
		{"capability":"<xsl:value-of select="name"/>" , "capabilityName":"<xsl:value-of select="own_slot_value[slot_reference='name']/value"/>" },
        <xsl:if test="own_slot_value[slot_reference='supports_business_capabilities']/value">
        {"capability":"<xsl:value-of select="own_slot_value[slot_reference='supports_business_capabilities']/value"/>" , "capabilityName":"Parent" },
        </xsl:if>
 	</xsl:template>
	<xsl:template match="node()" mode="options">
        <xsl:variable name="this" select="name"/>
        <xsl:variable name="countLink" select="count(own_slot_value[slot_reference='supporting_business_capabilities']/value)"/>
		<option value="{$this}"><xsl:value-of select="own_slot_value[slot_reference='name']/value"/> (<xsl:value-of select="$countLink"/>) </option>
	</xsl:template>
	<!-- Find all the sub capabilities of the specified parent capability -->
	<xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildList" select="$allBusinessCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aNewList" select="$aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
<!-- Calculate the level of project activity for a given Business Capability -->
	<xsl:template match="node()" name="Calculate_Project_Activity">
		<xsl:param name="currentCap"/>
		<xsl:variable name="busProcsForCap" select="$allBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentCap/name]"/>

		<!-- identify the applications that impact the business capability -->
		<xsl:variable name="physProcsForCap" select="$allPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $busProcsForCap/name]"/>
		<xsl:variable name="physProcs2AppsForCap" select="$allPhysProcs2Apps[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
		<xsl:variable name="appsForCap" select="$allApps[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>


		<xsl:variable name="plansForBusProcs" select="$allBusImpactStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $busProcsForCap/name]"/>
		<xsl:variable name="plansForApps" select="$allAppImpactStrategicPlans[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $busProcsForCap/name]"/>
		<xsl:variable name="impactingProjects" select="$inScopeProjects[own_slot_value[slot_reference = 'ca_strategic_plans_supported']/value = ($plansForBusProcs union $plansForApps)/name]"/>

		<xsl:value-of select="count($impactingProjects)"/>
	</xsl:template>
    
    
</xsl:stylesheet>
