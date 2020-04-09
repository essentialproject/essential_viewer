<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->
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
	<xsl:variable name="allApps" select="/node()/simple_instance[name = $allAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allAppFamiliess" select="/node()/simple_instance[name = $allApps/own_slot_value[slot_reference = 'type_of_application']/value]"/>
	<xsl:variable name="allActor2Role" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>

	<xsl:variable name="allAppStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $allAppProRoles/name]"/>
	

	<xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User'))]"/>
	<xsl:variable name="appOrgUser2Roles" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>

	<!--All Actors who use Apps-->
	<xsl:variable name="allAppUserOrgs" select="/node()/simple_instance[name = $appOrgUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

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
				<title>Application Current State Model</title>
				<script src="js/jquery-migrate-1.4.1.min.js" type="text/javascript"/>
				<script src="js/jquery.tools.min.js" type="text/javascript"/>
				<link href="ext/shared/custom.css" type="text/css" rel="stylesheet" />
				<!--<script>
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
				</script>-->

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
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div>
							<div class="col-xs-12 col-sm-6">
								<div class="page-header">
									<h1 id="viewName">
										<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
										<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Current State Model')"/></span>
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
								<h2 class="text-primary"><xsl:value-of select="eas:i18n('Model')"/></h2>
							</div>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The Application Current State Model provides a high level overview of the key application building blocks that support the execution of business processes across the enterprise')"/>.</p>
								<div class="verticalSpacer_5px"/>
								<!--<div class="smallButton backColour2 text-white fontBlack pull-right" id="fullScreenButton" style="width:130px">View Full Screen</div>
									<div class="horizSpacer_10px pull-right"/>-->
								<!--<div class="smallButton backColour1 text-white fontBlack pull-right userCountToggle" style="width:200px">Show/Hide User Count</div>
									<div class="horizSpacer_10px pull-right"/>-->
								<div class="smallButton bg-primary text-white fontBlack pull-right heatmapToggle" style="width:200px"><xsl:value-of select="eas:i18n('Show/Hide Application Count')"/></div>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="instanceKey"/>
								<xsl:call-template name="userKey"/>
								<div class="verticalSpacer_10px"/>
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
			<div class="appRef_NarrowColContainer col-xs-3">
				<xsl:apply-templates mode="RenderSharedAppCap" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $sharedAppCapType/name)]">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>
			</div>

			<!--Middle-->
			<div class="appRef_WideColContainer col-xs-6">
				<xsl:apply-templates mode="RenderFoundationAppCap" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $coreAppCapType/name)]">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>

				<xsl:variable name="foundationAppCaps" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $foundationAppCapType/name)]"/>
				<xsl:choose>
					<xsl:when test="count($foundationAppCaps) &gt; 0">
						<div class="verticalSpacer_20px"/>
						<xsl:apply-templates mode="RenderFoundationAppCap" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $foundationAppCapType/name]">
							<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>
				
				
				
				<xsl:variable name="enablingAppCaps" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $enablingAppCapType/name)]"/>
				<xsl:choose>
					<xsl:when test="count($enablingAppCaps) &gt; 0">
						<div class="verticalSpacer_20px"/>
						<xsl:apply-templates mode="RenderEnablingAppCap" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $enablingAppCapType/name]">
							<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
						</xsl:apply-templates>
					</xsl:when>
				</xsl:choose>

				<!--<xsl:variable name="enablingAppCaps" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $enablingAppCapType/name)]"/>
				<xsl:choose>
					<xsl:when test="count($enablingAppCaps) &gt; 0">
						<div class="verticalSpacer_20px"/>
						<div class="appRef_WideColCap_ThirdsContainer bg-pink-20">
							<div class="appRef_CapTitle fontBlack xlarge text-white">
								<xsl:value-of select="$enablingAppCapType/own_slot_value[slot_reference = 'taxonomy_term_label']/value"/>
							</div>
							<div class="verticalSpacer_5px"/>
							<xsl:apply-templates mode="RenderEnablingAppCap" select="$allAppCaps[own_slot_value[slot_reference = 'element_classified_by']/value = $enablingAppCapType/name]">
								<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
							</xsl:apply-templates>
						</div>
					</xsl:when>
				</xsl:choose>-->
			</div>
			<!--Right-->
			<div class="appRef_NarrowColContainer col-xs-3">
				<xsl:apply-templates mode="RenderManagementAppCap" select="$allAppCaps[not(own_slot_value[slot_reference = 'contained_in_application_capability']/value) and (own_slot_value[slot_reference = 'element_classified_by']/value = $manageAppCapType/name)]">
					<xsl:sort select="own_slot_value[slot_reference = 'application_capability_index']/value"/>
				</xsl:apply-templates>
			</div>
		</div>
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



	<xsl:template match="node()" mode="RenderSharedAppCap">
		
			<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
				<div class="appRef_CapTitle fontBlack xlarge text-white">
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<xsl:with-param name="anchorClass">text-white</xsl:with-param>
					</xsl:call-template>
				</div>
				<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>

				<xsl:apply-templates mode="RenderSharedLevel2AppCaps" select="$subAppCaps">
					<!--<xsl:sort select="own_slot_value[slot_reference='application_service_index']/value"/>-->
				</xsl:apply-templates>

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
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				<xsl:with-param name="relevantAppSvc" select="$currentAppSvc"/>
			</xsl:apply-templates>

		</div>
		<!--<xsl:if test="not(position() = last())">
			<div class="verticalSpacer_20px"/>
		</xsl:if>-->
	</xsl:template>

	<!--<xsl:template match="node()" mode="RenderCoreAppCap">
		<div class="appRef_WideColCap_Half backColour13">
			<div class="appRef_CapTitle fontBlack xlarge text-white">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!-\-<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-\->
					<xsl:with-param name="anchorClass">text-white</xsl:with-param>
				</xsl:call-template>
			</div>
			<xsl:variable name="appCapServices" select="$allAppServices[own_slot_value[slot_reference='realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderCoreAppSvc" select="$appCapServices">
				<xsl:sort select="own_slot_value[slot_reference='application_service_index']/value"/>
			</xsl:apply-templates>
		
		</div>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="RenderCoreAppSvc">
		
		<div class="appRef_WideColSubCap_Half">
			<div class="appRef_CapTitle fontBlack large">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!-\-<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-\->
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>
			
			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference='realises_application_capabilities']/value = current()/name]"></xsl:variable>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference='name']/value"/>
			</xsl:apply-templates>
			
		</div>
	</xsl:template>
	-->


	<xsl:template match="node()" mode="RenderFoundationAppCap">
		<div class="appRef_WideColCap bg-darkblue-100">
			<div class="appRef_CapTitle fontBlack xlarge text-white">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
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
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>

		</div>
		<!--		<xsl:if test="not(position() = last())">
			<div class="verticalSpacer_20px"/>
		</xsl:if>-->
	</xsl:template>


	<xsl:template match="node()" mode="RenderManagementAppCap">
		
			<div class="appRef_NarrowColCap bg-darkblue-100 bottom-15">
				<div class="appRef_CapTitle fontBlack xlarge text-white">
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
						<xsl:with-param name="anchorClass">text-white</xsl:with-param>
					</xsl:call-template>
				</div>

				<xsl:variable name="subAppCaps" select="$allAppCaps[name = current()/own_slot_value[slot_reference = 'contained_app_capabilities']/value]"/>

				<xsl:apply-templates mode="RenderManagementLevel2AppCaps" select="$subAppCaps"> </xsl:apply-templates>
			</div>
		
	</xsl:template>


	<xsl:template match="node()" mode="RenderManagementLevel2AppCaps">
		<div class="appRef_NarrowColSubCap">
			<div class="appRef_CapTitle fontBlack large">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:variable name="appSvsForAppCap" select="$allAppServices[own_slot_value[slot_reference = 'realises_application_capabilities']/value = current()/name]"/>
			<xsl:apply-templates mode="RenderApplicationServices" select="$appSvsForAppCap">
				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
			</xsl:apply-templates>

		</div>
		<!--<xsl:if test="not(position() = last())">
			<div class="verticalSpacer_20px"/>
		</xsl:if>-->
	</xsl:template>


	<xsl:template match="node()" mode="RenderEnablingAppCap">
		<div class="appRef_WideColCap_Third bg-aqua-20">
			<div class="appRef_CapTitle fontBlack xlarge text-white">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
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
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
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

		<xsl:variable name="relevantAppProRoles" select="$allAppProRoles[own_slot_value[slot_reference = 'implementing_application_service']/value = $relevantAppSvc/name]"/>
		<xsl:variable name="relevantApps" select="$allApps[(name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value)]"/>
		<!--<xsl:variable name="relevantAppOwners" select="$allAppOwners[name = $relevantApps/own_slot_value[slot_reference='ap_business_owner']/value]"/>
		-->
		
		<xsl:variable name="currentAppStandards" select="$allAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $relevantAppProRoles/name]"/>
		<xsl:variable name="standardAppProRoles" select="$relevantAppProRoles[name = $currentAppStandards/own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value]"/>
		<xsl:variable name="standardApps" select="$relevantApps[name = $standardAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

		<xsl:variable name="appBoxColour">
			<xsl:choose>
				<xsl:when test="count($relevantApps) > 2">threeColModel_NumberHeatmap fontBlack text-white alignCentre bg-pink-60</xsl:when>
				<xsl:when test="count($relevantApps) > 1">threeColModel_NumberHeatmap fontBlack text-white alignCentre bg-orange-60</xsl:when>
				<xsl:when test="count($relevantApps) = 1">threeColModel_NumberHeatmap fontBlack text-white alignCentre bg-brightgreen-60</xsl:when>
				<xsl:otherwise>threeColModel_NumberHeatmap fontBlack text-white alignCentre bg-lightgrey</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="threeColModel_ObjectContainer">
			<div class="threeColModel_ObjectBackgroundColour bg-darkblue-20"/>
			<div>
				<xsl:attribute name="class" select="$appBoxColour"/>
				<xsl:value-of select="count($relevantApps)"/>
			</div>
			<div class="threeColModel_Object small">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<!--<xsl:with-param name="divClass">threeColModel_Object small backColour19</xsl:with-param>-->
					<xsl:with-param name="anchorClass">fontBlack text-default</xsl:with-param>
				</xsl:call-template>
			</div>
			<div class="heatmapContainer backColour7">
				<div class="heatmapElement heatmapDivider gradLevelAlt0" style="width:19px"/>
				<div class="heatmapElement heatmapDivider gradLevelAlt1" style="width:19px"/>
				<div class="heatmapElement heatmapDivider gradLevelAlt2" style="width:19px"/>
				<div class="heatmapElement heatmapDivider gradLevelAlt3" style="width:19px"/>
				<div class="heatmapElement heatmapDivider gradLevelAlt4" style="width:19px"/>
				<div class="heatmapElement gradLevelAlt5" style="width:20px"/>
			</div>
			<div class="verticalSpacer_5px backColour7"/>
		</div>
		<div class="ess-tooltip">
			<xsl:choose>
				<xsl:when test="count($relevantApps) > 0">
					<div>
						<div class="fontBlack text-primary uppercase large pull-left"><xsl:value-of select="eas:i18n('Applications')"/></div>
						<div class="pull-right">
							<div class="keySampleWide bg-darkgreen-20"/>
							<div class="keySampleLabel text-default"><xsl:value-of select="eas:i18n('Standard Application')"/></div>
						</div>
						<div class="clearfix" style="margin-bottom: 5px;"></div>
						<style>
							.ulTight{
							    margin-bottom: 0px;
							}</style>
						<table style="width:600px;" class="table table-header-background table-striped table-bordered table-condensed">
							<thead>
								<tr>
									<th class="cellWidth-20pc"><xsl:value-of select="eas:i18n('Application')"/></th>
									<th class="cellWidth-30pc"><xsl:value-of select="eas:i18n('Standard for Orgs')"/></th>
									<th class="cellWidth-20pc"><xsl:value-of select="eas:i18n('Status')"/></th>
									<th class="cellWidth-30pc"><xsl:value-of select="eas:i18n('Used By')"/></th>
								</tr>
							</thead>

							<tbody>
								<xsl:for-each select="$standardApps">
									<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									<xsl:variable name="currentApp" select="current()"/>
									<xsl:variable name="appProRoles4CurrentAppService" select="$relevantAppSvc/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
									<xsl:variable name="appProRoleforCurrentApp" select="$standardAppProRoles[(name = $appProRoles4CurrentAppService) and (own_slot_value[slot_reference = 'role_for_application_provider']/value = $currentApp/name)]"/>
									
									<xsl:variable name="standardForCurrentApp" select="$currentAppStandards[own_slot_value[slot_reference = 'aps_standard_app_provider_role']/value = $appProRoleforCurrentApp/name]"/>
									<xsl:variable name="thisAppStandardOrg" select="$allGroupActors[name = $standardForCurrentApp/own_slot_value[slot_reference = 'sm_organisational_scope']/value]"/>
									
									<xsl:variable name="thisAPRLifecycleStatus" select="$allLifecycleStatii[name = $appProRoleforCurrentApp/own_slot_value[slot_reference='apr_lifecycle_status']/value]"/>
									<xsl:variable name="thisAppLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>
									
									
									<tr>
										<td class="bg-darkgreen-20">
											<strong>
												<xsl:call-template name="RenderInstanceLink">
													<xsl:with-param name="theSubjectInstance" select="current()"/>
													<xsl:with-param name="theXML" select="$reposXML"/>
													<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
												</xsl:call-template>
											</strong>
										</td>
										<td class="bg-darkgreen-20">
											<ul>
												<xsl:for-each select="$thisAppStandardOrg">
													<li>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="current()"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
														</xsl:call-template>
													</li>
												</xsl:for-each>
											</ul>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="count($thisAPRLifecycleStatus) > 0">
													<xsl:variable name="lifecycleClass" select="eas:get_element_style_class($thisAPRLifecycleStatus)"/>
													<xsl:attribute name="class" select="$lifecycleClass"/>
													<xsl:call-template name="RenderMultiLangInstanceName">
														<xsl:with-param name="theSubjectInstance" select="$thisAPRLifecycleStatus"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="count($thisAppLifecycleStatus) > 0">
													<xsl:variable name="lifecycleClass" select="eas:get_element_style_class($thisAppLifecycleStatus)"/>
													<xsl:attribute name="class" select="$lifecycleClass"/>
													<xsl:call-template name="RenderMultiLangInstanceName">
														<xsl:with-param name="theSubjectInstance" select="$thisAppLifecycleStatus"/>
													</xsl:call-template>
												</xsl:when>
											</xsl:choose>
										</td>
										<td>
											<xsl:variable name="stakeholders4currentAppProRole" select="$allActor2Role[name = $appProRoleforCurrentApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
											<xsl:variable name="appOrgUsers4App" select="$stakeholders4currentAppProRole[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
											<xsl:variable name="relevantActors" select="$allGroupActors[name = $appOrgUsers4App/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
											<ul class="ulTight">
												<xsl:for-each select="$relevantActors">
													<li>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="current()"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
														</xsl:call-template>
													</li>
												</xsl:for-each>
											</ul>
										</td>
									</tr>
								</xsl:for-each>
								<xsl:for-each select="$relevantApps except $standardApps">
									<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
									<xsl:variable name="currentApp" select="current()"/>
									<xsl:variable name="appProRoles4CurrentAppService" select="$relevantAppSvc/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value"/>
									<xsl:variable name="appProRoleforCurrentApp" select="$allAppProRoles[(name = $appProRoles4CurrentAppService) and (own_slot_value[slot_reference = 'role_for_application_provider']/value = $currentApp/name)]"/>
									<xsl:variable name="thisAPRLifecycleStatus" select="$allLifecycleStatii[name = $appProRoleforCurrentApp/own_slot_value[slot_reference='apr_lifecycle_status']/value]"/>
									<xsl:variable name="thisAppLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>								
									
									<tr>
										<td>
											<xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
										</td>
										<td>-</td>
										<td>
											<xsl:choose>
												<xsl:when test="count($thisAPRLifecycleStatus) > 0">
													<xsl:variable name="lifecycleClass" select="eas:get_element_style_class($thisAPRLifecycleStatus)"/>
														<xsl:attribute name="class" select="$lifecycleClass"/>
														<xsl:call-template name="RenderMultiLangInstanceName">
															<xsl:with-param name="theSubjectInstance" select="$thisAPRLifecycleStatus"/>
														</xsl:call-template>
												</xsl:when>
												<xsl:when test="count($thisAppLifecycleStatus) > 0">
													<xsl:variable name="lifecycleClass" select="eas:get_element_style_class($thisAppLifecycleStatus)"/>
													<xsl:attribute name="class" select="$lifecycleClass"/>
													<xsl:call-template name="RenderMultiLangInstanceName">
														<xsl:with-param name="theSubjectInstance" select="$thisAppLifecycleStatus"/>
													</xsl:call-template>
												</xsl:when>
											</xsl:choose>
										</td>
										<td>
											<xsl:variable name="stakeholders4currentAppProRole" select="$allActor2Role[name = $appProRoleforCurrentApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
											<xsl:variable name="appOrgUsers4App" select="$stakeholders4currentAppProRole[own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name]"/>
											<xsl:variable name="relevantActors" select="$allGroupActors[name = $appOrgUsers4App/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
											<ul class="ulTight">
												<xsl:for-each select="$relevantActors">
													<li>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="current()"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
														</xsl:call-template>
													</li>
												</xsl:for-each>
											</ul>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div>
						<strong>
							<em><xsl:value-of select="eas:i18n('No Applications Captured')"/></em>
						</strong>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>


</xsl:stylesheet>
