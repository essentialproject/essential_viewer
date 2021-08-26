<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_js_functions.xsl"/>
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
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
<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<!--<xsl:variable name="allBusProcs" select="/node()/simple_instance[type='Business_Process']" />
	<xsl:variable name="allApps" select="/node()/simple_instance[(type='Application_Provider') or (type='Composite_Application_Provider')]" />
	<xsl:variable name="allAppServices" select="/node()/simple_instance[(type='Application_Service') or (type='Composite_Application_Service')]"/>
	<xsl:variable name="allAppRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
	<xsl:variable name="allBusProc2AppSvcs" select="/node()/simple_instance[type='APP_SVC_TO_BUS_RELATION']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type='Individual_Actor']" />
	<xsl:variable name="allIndividualRoles" select="/node()/simple_instance[type='Individual_Business_Role']" />
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type='Group_Actor']" />
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type='Group_Business_Role']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type='Physical_Process']" />
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']" />-->

	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type='Application_Provider') or (type='Composite_Application_Provider')]" />
	<xsl:variable name="currentBusCap" select="$allBusinessCaps[name = $param1]"/>
	<xsl:variable name="currentBusCapName"><xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$currentBusCap"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template></xsl:variable>
	
	<xsl:variable name="subBusCaps" select="$allBusinessCaps[name = $currentBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>


	<xsl:variable name="relevantBusCaps" select="$currentBusCap union $subBusCaps"/>
	<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
	<xsl:variable name="currentBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentBusCap/name]"/>
	<xsl:variable name="relevantBusProc2AppSvcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantAppSvcs" select="/node()/simple_instance[name = $relevantBusProc2AppSvcs/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
	<xsl:variable name="relevantAppRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $relevantAppSvcs/name]"/>
	<xsl:variable name="relevantAppsIndirect" select="/node()/simple_instance[name = $relevantAppRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

	<xsl:variable name="physProcsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="physProcs2AppsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
	<xsl:variable name="appRolesForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	
	   <xsl:variable name="processToAppRel" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value=$allAppProviders/name]"/>
    <xsl:variable name="directProcessToAppRel" select="$processToAppRel[name=$physProcsForCap/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
    <xsl:variable name="directProcessToApp" select="$allAppProviders[name=$directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="relevantAppsDirect" select="$allAppProviders[name= $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>

	<xsl:variable name="relevantApps" select="$relevantAppsIndirect union $relevantAppsDirect"/>
	
	<xsl:variable name="appsForRolesCap" select="/node()/simple_instance[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="appsForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $relevantApps"/>


	
	<xsl:variable name="lifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status'][own_slot_value[slot_reference='enumeration_sequence_number']/value]"/>
	<xsl:variable name="deliveryModel" select="/node()/simple_instance[type = 'Codebase_Status']"/>
     <xsl:variable name="styles" select="/node()/simple_instance[type='Element_Style']"/>
    <!-- ROADMAP VARIABLES -->
	<xsl:variable name="allRoadmapInstances" select="$allAppsForCap"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>
    <!-- END ROADMAP VARIABLES -->
    
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

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
               <script src="js/d3/d3.v5.9.7.min.js"></script>
               <script src="js/generic-radar/radar.js"></script>

				<title>Application Strategic Radar</title>
                <xsl:call-template name="dataTablesLibrary"/>
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Strategic Radar')"/> for </span>
									<span class="text-primary"><xsl:value-of select="$currentBusCapName"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
                            <strong class="right-5">Apps to Show:</strong>
                            <select id="switch">
                                <option id="All">Show All</option>
                                <option id="Does">Do Support</option>
                                <option id="Could">Could Support</option>
                            </select>
							<div class="clearfix"></div>
							<xsl:if test="not($lifecycleStatus)"><p><br/>Missing Data: Please Set Enumeration Sequence Numbers for Lifecycles</p></xsl:if> 
							<svg id="radar"></svg>

							<script>
							    var entriesForRadar=[ <xsl:apply-templates select="$allAppsForCap" mode="apps"></xsl:apply-templates>  ]
  
								function callRadar(myRadar){    
								radar_visualization({
								  svg_id: "radar",
								  width: 1400,
								  height: 950,
								  colors: {
								   
								    grid: "#bbb",
								    inactive: "#ddd"
								  },
								  title: "Applications",
								  quadrants: [
								    { name: "Ignore" },
								    { name: "Ignore" },
								    { name: "Ignore" },
								    { name: "Ignore" }
								  ],
								  rings: [
								     <xsl:apply-templates select="$lifecycleStatus" mode="life">
								        <xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/>
								     </xsl:apply-templates>
								     { name: "Not Set", color: "#93c47d" }
								
								  ],
								  print_layout: true,
								  // zoomed_quadrant: 0,
								  //ENTRIES
								  entries: myRadar
								  //ENTRIES
								});
								    };
								    
								    callRadar(entriesForRadar)
								    
								$('#switch').change(function(){
								    var appState = $(this).children(":selected").attr("id");
								       console.log(appState);
								    if(appState !=='All'){
								        var toShow = entriesForRadar.filter(function(d){
								
								            return d.couldDoes===appState;
								            });
								        }
								    else{
								    toShow=entriesForRadar;
								    }
								$('#radar').empty();
								   console.log(toShow);
								    callRadar(toShow);
								    })    
								</script>
								<hr/>
							</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
    <xsl:template match="node()" mode="apps">
		<xsl:variable name="this" select="current()"/>
        <xsl:variable name="ThisApp">
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value"/>
		</xsl:variable>
        <xsl:variable name="ThisAppProRole" select="$relevantAppRoles[name=current()/own_slot_value[slot_reference = 'provides_application_services']/value]"/>

        <xsl:variable name="ThisAppProRolePhysical" select="$ThisAppProRole/own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/>
		
        <xsl:variable name="lifeValue"><xsl:value-of select="$lifecycleStatus[name = $ThisApp]/own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:variable>
      {
        quadrant: <xsl:value-of select="position() mod 4"/>,
        ring: <xsl:choose><xsl:when test="$lifeValue=''"><xsl:value-of select="count($lifecycleStatus)-1"/></xsl:when><xsl:otherwise><xsl:value-of select="$lifeValue"/></xsl:otherwise></xsl:choose>,
        label: "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
        active: false,
        link: "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
        moved: 0,
        couldDoes: "<xsl:choose><xsl:when test="$ThisAppProRolePhysical">Does</xsl:when><xsl:otherwise>Could</xsl:otherwise></xsl:choose>"
      }<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>
	
	<xsl:template match="node()" mode="life">
	    <xsl:variable name="style" select="$styles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
	    <xsl:if test="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value">
	      {name: "<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>", color: "<xsl:choose><xsl:when test="$style/own_slot_value[slot_reference='element_style_colour']/value"><xsl:value-of select="$style/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#54efcb</xsl:otherwise></xsl:choose>", textColour:"<xsl:choose><xsl:when test="$style/own_slot_value[slot_reference='element_style_text_colour']/value"><xsl:value-of select="$style/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#5c5c5c</xsl:otherwise></xsl:choose>" },</xsl:if>
	    </xsl:template>
	</xsl:stylesheet>
