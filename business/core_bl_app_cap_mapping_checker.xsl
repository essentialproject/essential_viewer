<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

    <xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
    
    <xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="L1BusCaps" select="$allBusCaps[name = $L0BusCaps/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
    <xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
    <xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusCaps/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"/>
	<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
    <xsl:variable name="processToAppRel" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value=$allAppProviders/name]"/>
    <xsl:variable name="directProcessToAppRel" select="$processToAppRel[name=$relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
    <xsl:variable name="directProcessToApp" select="$allAppProviders[name=$directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="relevantApps" select="$allAppProviders[name= $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
    <xsl:variable name="relevantApps2" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
    <xsl:variable name="appsWithCaps" select="$relevantApps union $relevantApps2"/>
    <xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
     <xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>
    <xsl:variable name="BusinessFit" select="/node()/simple_instance[type = 'Business_Service_Quality'][own_slot_value[slot_reference='name']/value=('Business Fit')]"/>
    <xsl:variable name="BFValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value'][own_slot_value[slot_reference='usage_of_service_quality']/value=$BusinessFit/name]"/>
    <xsl:variable name="perfMeasures" select="/node()/simple_instance[type = 'Business_Performance_Measure'][own_slot_value[slot_reference='pm_performance_value']/value=$BFValues/name]"/>
    
    <xsl:variable name="ApplicationFit" select="/node()/simple_instance[type = 'Technology_Service_Quality'][own_slot_value[slot_reference='name']/value=('Technical Fit')]"/>
    <xsl:variable name="AFValues" select="/node()/simple_instance[type = 'Technology_Service_Quality_Value'][own_slot_value[slot_reference='usage_of_service_quality']/value=$ApplicationFit/name]"/>
    <xsl:variable name="appPerfMeasures" select="/node()/simple_instance[type = 'Technology_Performance_Measure'][own_slot_value[slot_reference='pm_performance_value']/value=$AFValues/name]"/>
    <xsl:variable name="unitOfMeasures" select="/node()/simple_instance[type = 'Unit_Of_Measure']"/>
    <xsl:variable name="planningAction" select="/node()/simple_instance[type = 'Planning_Action'][own_slot_value[slot_reference='enumeration_value']/value='Establish']"/>
    <xsl:variable name="plannedChanges" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][own_slot_value[slot_reference='plan_to_element_ea_element']/value=$allAppProviders/name][own_slot_value[slot_reference='plan_to_element_change_action']/value=$planningAction/name]"/>
    <xsl:variable name="stratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][own_slot_value[slot_reference='strategic_plan_for_elements']/value=$plannedChanges/name]"/>
    
    <xsl:variable name="allVals" select="$BFValues union $AFValues"/>
    <xsl:variable name="colourElements" select="/node()/simple_instance[type = 'Element_Style'][name=$allVals/own_slot_value[slot_reference='element_styling_classes']/value]"/>
    
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
				<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Business Capability - Application Fit - Checker</title>
               
                <style>
                .cap{border:1pt solid #d3d3d3; 
                    height:auto;
                    border-radius:4px;
                    margin-bottom: 15px;
                    padding: 10px;
                    }
                .subCap{
                    min-height:100px;
                    height:auto;
                    margin:2px;}
                .app{
                	border:1pt solid #d3d3d3;
                    border-bottom:0pt solid #d3d3d3;
                    background-color:#fff;
                    min-height:42px;
                    font-weight: 700;
                    width: 100%;
                    padding: 3px;
                    border-radius:4px 4px 0px 0px;
                    text-align:center;
                    box-shadow: 4px 0px 4px -2px #d3d3d3;
                    }
                .outerCap{
                    background-color:#f5f5f5;
                    border-bottom:1pt solid #d3d3d3;
                    border-radius:4px;
                    padding: 5px;
                    width: 100%;
                    margin-bottom: 10px;
                    }
                .appLife{
                	width: 100%;
                    background-color:#d3d3d3;
                    max-height:16px;
                    border-radius: 0px 0px 4px 4px;
                    text-align:center;
                    border:1pt solid #d3d3d3;
                    border-top:1pt solid #fff;
                    box-shadow: 0px 2px 5px -2px hsla(0, 0%, 0%, 0.25);
                    font-size: 8pt;
                    }
                a, a:hover, a:focus, a:active {
      text-decoration: none;
      color: inherit;
 }
                </style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
         		<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<!--Setup Description Section-->
					<div class="col-xs-12">
	Applications: <span class="badge"><xsl:value-of select="count($allAppProviders)"/></span><br/>
    All Business Capabilities: <span class="badge"><xsl:value-of select="count($allBusCaps)"/></span><br/>
	Root Business Capability Report Constant Set: <span class="badge"><xsl:value-of select="count($busCapReportConstant)"/></span><br/>
	L0 Business Capabilities: <span class="badge"><xsl:value-of select="count($L0BusCaps)"/></span><br/>
	L1 Business Capabilities: <span class="badge"><xsl:value-of select="count($L1BusCaps)"/></span><br/>
    Business Processes tied to Capabilities: <span class="badge"><xsl:value-of select="count($relevantBusProcs)"/></span><br/>
	Physical Processes tied to Business Processes: <span class="badge"><xsl:value-of select="count($relevantPhysProcs)"/></span><br/>
	<b>Option 1</b><br/>
	Physical Processes tied Apps via App Provider Role <span class="badge"><xsl:value-of select="count($relevantAppProRoles)"/></span>
	
		<br/><b>and/or</b><br/>
		<b>Option 2</b><br/>					
    Physical Processes tied Apps directly: <span class="badge"><xsl:value-of select="count($directProcessToAppRel)"/></span><br/>
						<br/>
    Apps In Scope Directly: <span class="badge"><xsl:value-of select="count($relevantApps)"/></span><br/>
    Apps In Scope Indirectly: <span class="badge"><xsl:value-of select="count($relevantApps2)"/></span><br/>
    All Apps In Scope: <span class="badge"><xsl:value-of select="count($appsWithCaps)"/></span><br/>
    Lifecycle_Status: <span class="badge"><xsl:value-of select="count($allLifecycleStatus)"/></span><br/> 
    
    
	Business_Service_Quality with name set to 'Business Fit': <span class="badge"><xsl:value-of select="count($BusinessFit)"/></span><br/> 
    Business_Service_Quality_Values against the Business Service Quality: <span class="badge"><xsl:value-of select="count($BFValues)"/></span><br/> 
    Business_Performance_Measure for Business_Service_Quality_Values set: <span class="badge"><xsl:value-of select="count($perfMeasures)"/></span><br/>
    
    Technology_Service_Quality with name set to 'Technical Fit': <span class="badge"><xsl:value-of select="count($ApplicationFit)"/></span><br/> 
    Technology_Service_Quality_Values against the Technology_Service_Quality: <span class="badge"><xsl:value-of select="count($AFValues)"/></span><br/> 
    Technology_Performance_Measure for Technology_Service_Quality_Values set: <span class="badge"><xsl:value-of select="count($appPerfMeasures)"/></span><br/> 
	 
    Element_Style Colours set: <span class="badge"><xsl:value-of select="count($colourElements)"/></span><br/> 
    			
					</div>

						<!--Setup Closing Tags-->
					</div>
				</div> 
			</body>
		</html>
	</xsl:template> 
    
</xsl:stylesheet>
