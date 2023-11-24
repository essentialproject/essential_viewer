<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Business_Process', 'Application_Provider', 'Composite_Application_Provider', 'Technology_Product', 'Technology_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="busCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="rootBusCaps" select="/node()/simple_instance[type = 'Report_Constant'][own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$busCaps[name = $rootBusCaps/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>

	<xsl:variable name="rootLevelBusCaps" select="$busCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="supplier" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product'][own_slot_value[slot_reference = 'supplier_technology_product']/value = $supplier/name]"/>
	<xsl:variable name="allTPRs" select="/node()/simple_instance[type = 'Technology_Product_Role'][name = $allTechProds/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
	<xsl:variable name="allTPU" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference = 'provider_as_role']/value = $allTPRs/name]"/>
	<xsl:variable name="allTBA" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference = 'contained_architecture_components']/value = $allTPU/name]"/>

	<xsl:variable name="allTPB" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference = 'technology_provider_architecture']/value = $allTBA/name]"/>

	<xsl:variable name="allAppDeps" select="/node()/simple_instance[type = ('Application_Deployment')][own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $allTPB/name]"/>
	<xsl:variable name="allTechApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $allAppDeps/name]"/>
    <xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'ap_supplier']/value = $supplier/name] union $allTechApps"/>
 
	<xsl:variable name="allAPRs" select="/node()/simple_instance[type = 'Application_Provider_Role'][own_slot_value[slot_reference = 'role_for_application_provider']/value = $allApps/name]"/>
	<xsl:variable name="allApptoProcsDirect" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $allApps/name]"/>
	<xsl:variable name="allAPRstoProcsIndirect" select="/node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $allAPRs/name]"/>
	<xsl:variable name="allAPRstoProcs" select="$allAPRstoProcsIndirect union $allApptoProcsDirect"/>
	
	<xsl:variable name="allPhysProcsBase" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="allPhysProcs" select="$allPhysProcsBase[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $allAPRstoProcs/name]"/>
	<xsl:variable name="allBusProcs" select="/node()/simple_instance[type = 'Business_Process'][own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value = $allPhysProcs/name]"/>
	<xsl:variable name="allOrg" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][name = $allPhysProcsBase/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="directOrg" select="/node()/simple_instance[type = 'Group_Actor'][name = $allPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="allviaActors" select="/node()/simple_instance[type = 'Group_Actor'][own_slot_value[slot_reference = 'actor_plays_role']/value = $allOrg/name]"/>

	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="allStratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value = $allObjectives/name]"/>
	<xsl:variable name="allPlannedElements" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][name = $allStratPlans/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>
	<xsl:variable name="allPlannedActions" select="/node()/simple_instance[type = 'Planning_Action'][name = $allPlannedElements/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>

	<xsl:variable name="supplierContracts" select="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION'][own_slot_value[slot_reference = 'obligation_component_to_element']/value = $allTechProds/name or own_slot_value[slot_reference = 'obligation_component_to_element']/value = $allApps/name]"/>
	<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	<xsl:variable name="contracts" select="/node()/simple_instance[type = 'Compliance_Obligation'][name = $supplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value][own_slot_value[slot_reference = 'compliance_obligation_licenses']/value = $alllicenses/name]"/>
	<xsl:variable name="licenses" select="/node()/simple_instance[type = 'License'][name = $contracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
	<xsl:variable name="actualContracts" select="/node()/simple_instance[type = 'Contract'][own_slot_value[slot_reference = 'contract_uses_license']/value = $licenses/name]"/>
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>


	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="geoLocation" select="/node()/simple_instance[type = 'Geographic_Location'][name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	<xsl:variable name="geoCode" select="/node()/simple_instance[type = 'GeoCode'][name = $geoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Supplier Impact']"/>

    
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
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<script type="text/javascript" src="js/d3/d3.v2.min.js?release=6.19"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Supplier Map</title>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css?release=6.19" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js?release=6.19" type="text/javascript"/>
				<script src="js/jvectormap/jquery-jvectormap-world-mill.js?release=6.19" type="text/javascript"/>

				<style>
					.tile-stats{
						transition: all 300ms ease-in-out;
						border-radius: 10px 10px 10px 10px;
						border: 1pt solid #d3d3d3;
					}
					
					.tile-stats .icon{
						width: 60px;
						height: 60px;
						color: #e5bebe;
						position: absolute;
						right: 30px;
						top: 10px;
						z-index: 1;
						opacity: 0.75;
					}
					
					.tile-stats .icon i{
						font-size: 60px;
					}
					
					.tile-stats .count{
						font-size: 30px;
						font-weight: bold;
						line-height: 1.65857
					}
					
					.tile-stats .count,
					.tile-stats h3,
					.tile-stats p{
						position: relative;
						margin: 0;
						margin-left: 10px;
						z-index: 5;
						padding: 0
					}
					
					.tile-stats h3{
						color: #BAB8B8
					}
					
					.tile-stats p{
						margin-top: 5px;
						font-size: 12px
					}
					
					.card{
						width: 150px; /* Set width of cards */
						border: 1px solid #d3d3d3; /* Set up Border */
						border-radius: 1px; /* Slightly Curve edges */
						overflow: hidden; /* Fixes the corners */
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis */
						margin: 3px;
						box-shadow: 3px 3px 3px #d3d3d3;
					}
					
					.card-process{
						text-align: center;
						font-size: 12px;
						font-weight: 600;
						border-bottom: 1px solid #d3d3d3;
						background-color: #d0d6d6;
						color: #2f2a2a;
						padding: 5px 10px;
						height: 30pt;
					}
					
					.card-header{
						color: #ffffff;
						text-align: center;
						font-size: 11px;
						font-weight: 600;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
					
						border-bottom: 1px solid #aea9f0;
						background-color: #6c6d6d;
						padding: 5px 10px;
					}
					
					.card-main{
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis to Vertical */
						justify-content: center; /* Group Children in Center */
						align-items: center; /* Group Children in Center (+axis) */
						padding: 5px 0; /* Add padding to the top/bottom */
					}
					
					.card-tech{
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis to Vertical */
						justify-content: center; /* Group Children in Center */
						align-items: center; /* Group Children in Center (+axis) */
						padding: 5px 0;
						font-size: 8pt;
						background-color: #d9bebe; /* Add padding to the top/bottom */
					}
					
					.card-score-main{
						display: flex; /* Children use Flexbox */
						flex-direction: column; /* Rotate Axis to Vertical */
						justify-content: center; /* Group Children in Center */
						align-items: center; /* Group Children in Center (+axis) */
						padding: 15px 0; /* Add padding to the top/bottom */
						background-color: #e8e8e8;
					}
					
					.main-description{
						color: #080707;
						font-size: 10px;
						text-align: left;
						padding-left: 5px;
						height: 10px;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
					}
					
					.tech-description{
						font-size: 8pt;
						text-align: center;
					}
					
					
					rect{
						fill: #00ffd0;
					}
					
					text{
						font-weight: 300;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
						font-size: 10px;
						font-weight: bold;
					}
					
					.node rect{
						stroke: #999;
						fill: #fff;
						stroke-width: 1px;
					}
					
					.edgePath path{
						stroke: #333;
						stroke-width: 1px;
					}
					
					.processes{
						font-size: 8pt;
					}
					
					.h3text{
						font-size: 1.5 vw
					}
					
					.normaltext{
						font-size: 1.2 vw
					}
					
					.fas{
						font-size: 1.0 vw
					}
					
					.capBox{
						margin: 3px;
						horizontal-align: center;
						vertical-align: center;
						border-radius: 4px;
						font-size: 8pt;
						float: left;
						padding: 5px 5px 0 5px;
						border: 1pt solid #ccc;
						width: 100%;
						}
					
					.refModel-blob,
					.busRefModel-blob,
					.appRefModel-blob,
					.techRefModel-blob{
						display: flex;
						align-items: center;
						justify-content: center;
						width: 120px;
						max-width: 120px;
						height: 50px;
						padding: 3px;
						max-height: 50px;
						overflow: hidden;
						border: 1px solid #aaa;
						border-radius: 4px;
						float: left;
						margin-right: 10px;
						margin-bottom: 10px;
						text-align: center;
						font-size: 12px;
						position: relative;
					}
					
					.refModel-blob-title{
						line-height: 1em;
					}
					
					.refModel-l0-title{
						margin-bottom: 5px;
						line-height: 1.1em;
					}
					
					.appList{
						background-color: #666;
						color: #fff;
						width: 100%;
						border: 1pt solid #d3d3d3;
						padding: 5px;
						margin-top: 10px;
					}
					
					.appList > i {
						margin-right: 5px;
					}
					
					.appList > span > a {
						color: #fff;
					}
					
					.appCapList{
						background-color: #ffffff;
						border-bottom: 1pt solid #d3d3d3;
						padding: 3px 6px;
						color: #333;
						margin-top: 5px;
					}
					
					.appCapList i.fa-sitemap,.appCapList i.fa-server {
						margin-right: 5px;
					}
					.appCapList i.fa-info-circle {
						margin-left: 5px;
					}
					.appListBg{
						background-color: #ffffff;
						border-bottom: 1pt solid #d3d3d3;
                        padding-left: 10px}

                    .appListtech{
                        background-color: #fff;
                        color:#000;
                        padding-left: 5px;
                        padding-top: 2px;
                        border-bottom: 1pt solid #d3d3d3;}
					
					.suppName{
						padding: 5px 10px;
					}
					
					.planBody,
					planHead{
						float: left;
					}
					
					.planHead{
						width: 75%;
						font-size: 12pt;
						font-weight: bold
					}
					
					.planName{
						font-size: 11pt;
						font-weight: normal;
						padding-left: 10px
					}
					
					.planImpact{
						background-color: #eaeaea;
						font-size: 11pt;
						font-weight: nomal
					}
					
					.planDate{
						float: right;
						background-color: #f0f0f0;
						border: 1pt solid #d3d3d3;
						padding: 3px
					}
					#supplierDiv,#supplierDiv2{
						overflow-y:scroll;
						max-height:calc(100vh - 250px);
						font-size: 90%;
					}
				</style>
				<script>
                        var suppTemplate;
                        var capTemplate;
                        $(document).ready(function() {
                            var suppFragment = $("#supplier-template").html();
                            suppTemplate = Handlebars.compile(suppFragment);
                    
                            var capFragment = $("#capability-template").html();
                            capTemplate = Handlebars.compile(capFragment);
                      
                            var timeFragment = $("#time-template").html();
                            timeTemplate = Handlebars.compile(timeFragment);
                            
                            $('#pickSuppliers').select2({theme: "bootstrap"});
                        });
                </script>
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
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Supplier Impact')"/>
									</span>
								</h1>
							</div>
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
					
						<div class="col-xs-9">
							<div class="pull-left">
								<span class="right-10"><strong>Supplier Filter</strong>:</span>
								<select id="pickSuppliers" class="select2">
									<option name="All">Choose</option>
									<xsl:apply-templates select="$supplier" mode="supplierOptions">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/>
									</xsl:apply-templates>
								</select>
							</div>
						</div>
						
										
						<div class="col-xs-3">
							<div class="pull-right">
								<div id="supplierName" class="suppName bg-darkgrey text-white alignCentre"/>
								<div class="key small" style="display:none">
									<span class="right-10 strong">Key:</span>
									<i class="fa fa-sitemap right-5"/><span class="right-10">Capability</span>
									<i class="fa fa-desktop right-5"/><span class="right-10">Application</span>
									<i class="fa fa-server right-5"/><span class="right-10">Technology</span>
								</div>
							</div>
						</div>
						<div class="col-xs-12 top-15">
							<div class="clearfix"/>
							<ul class="nav nav-tabs">
								<li class="active">
									<a data-toggle="tab" href="#cap">Capability Overview</a>
								</li>
								<li>
									<a data-toggle="tab" href="#plans">Planning Overview</a>
								</li>
							</ul>

							<div class="tab-content">
								<div id="cap" class="tab-pane fade in active">
									<div class="row">
										<div class="col-xs-9">
											<div class="top-15" id="capabilitiesDiv"/>
										</div>
										<div class="col-xs-3">
											<div id="supplierDiv"/>
										</div>
									</div>
								</div>
								<div id="plans" class="tab-pane fade">
									<h4 class="top-15">Plans impacting elements of the business supported by the supplier</h4>
									<hr/>
									<div class="row">
										<div class="col-xs-9">
											<div id="supplierTime"/>
										</div>
										<div class="col-xs-3">
											<div id="supplierDiv2"/>
										</div>
									</div>
								</div>

							</div>
						</div>
						<!-- Modal -->
						<div class="modal fade" id="modalN" tabindex="-1" role="dialog" aria-labelledby="modalN" aria-hidden="true">
							<div class="modal-dialog" role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h3>Deployed to this Node</h3>
									</div>
									<div class="modal-body">
										<svg id="svgs" width="100%" height="300"/>
									</div>
									<div class="modal-footer">
										<b>
											<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
										</b>
									</div>
								</div>
							</div>
                        </div>
                        <script>
                        <xsl:call-template name="RenderViewerAPIJSFunction">
                            <xsl:with-param name="viewerAPIPath" select="$apiPath"/>
                        </xsl:call-template>
                </script>
					</div>
				</div>
				<!-- modal -->
				<xsl:call-template name="supHandlebarsTemplate"/>
				<xsl:call-template name="capHandlebarsTemplate"/>
				<xsl:call-template name="timeHandlebarsTemplate"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="timeHandlebarsTemplate">
		<script id="time-template" type="text/x-handlebars-template">
    {{#each this}}
      
        <div class="planHead" style="margin:5px;padding:3px;border-left:3px solid #cc1919;border-radius:3px;min-height:70px;box-shadow:5px 5px 5px #d3d3d3;padding-bottom:15px:"><span style="color:gray">Plan: </span>{{this.name}}<br/>
            <div class="planName planBody"> {{this.impactType}} {{{this.impactName}}} <i> uses </i>   <b>{{{this.app}}}</b></div>
            
            <div class="planDate planBody">
            {{#if actionRqdA}}<button class="btn btn-success">{{this.actionRqdA}}</button> <button class="btn btn-danger">{{this.actionRqdC}}</button>{{/if}} <xsl:text> </xsl:text><button class="btn btn-info">{{this.impactAction}}</button></div>
            </div>
        <div class="clearfix"/>
{{/each}}
    </script>
	</xsl:template>

	<xsl:template name="supHandlebarsTemplate">
		<script id="supplier-template" type="text/x-handlebars-template">
         
            {{#each apps}}
                <div><xsl:attribute name="class">appList elementName</xsl:attribute><xsl:attribute name="data-easid">{{this.id}}</xsl:attribute> <i class="fa fa-desktop"/>  <span style="font-size:1.1em ">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
                    
                {{#each capabilitiesImpacted}}
                    <div><xsl:attribute name="class">appCapList cap{{this.id}}</xsl:attribute><i class="fa fa-sitemap"/> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                        <i class="fa fa-info-circle impAppsTrigger" data-toggle="popover" data-placement="bottom"/>
                        <div class="hidden popupTitle">
                          <span class="fontBlack uppercase">
                                <xsl:value-of select="eas:i18n('Processes Impacting')"/>
                            </span>
                        </div>
                        <div class="hidden popupContent">
                            {{#each processes}}
                                <i class="fa fa-circle-o"/> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}<br/>
                            {{/each}}
                        </div>
                    
                    </div> 
                {{/each}}</div>
            {{/each}}
            
          
            {{#each technologies}}
            <div class="appList elementName"><xsl:attribute name="data-easid">{{this.id}}</xsl:attribute> <i class="fa fa-server"/> <span style="font-size:1.1em">{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</span>
            {{#each impacted}}
                
                 {{#each caps}}
                    <div><xsl:attribute name="class">appCapList cap{{this.id}}</xsl:attribute><i class="fa fa-sitemap"/> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                        <i class="fa fa-info-circle impAppsTrigger" data-toggle="popover" data-placement="bottom"/>
                        <div class="hidden popupTitle">
                          <span class="fontBlack uppercase">
                                <xsl:value-of select="eas:i18n('Processes Impacting')"/>
                            </span>
                        </div>
                        <div class="hidden popupContent">
                            {{#each processes}}
                                <i class="fa fa-circle-o"/> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}<br/>
                            {{/each}}
                        </div>
                    
                    </div> 
                    {{/each}}
                {{/each}}
             {{#each impacted}}    
                {{#each apps}}
                <div><xsl:attribute name="class">appListtech</xsl:attribute><i class="fa fa-desktop"/>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</div> 
                {{/each}}    
                
            {{/each}}    
            </div>
            {{/each}}
              
        </script>
	</xsl:template>


	<xsl:template name="capHandlebarsTemplate">
		<script id="capability-template" type="text/x-handlebars-template">
            <div><xsl:attribute name="class">col-xs-12 capBox</xsl:attribute><div class="refModel-l0-title fontBlack large">{{name}}</div>
                    <div class="clearfix"/>
                     {{#each this.subCaps}}
                        <div>
                            <xsl:attribute name="class">busRefModel-blob bg-darkblue-40 {{this.id}}</xsl:attribute>
                            <div class="refModel-blob-title">{{this.name}}</div>
                        </div>
                     {{/each}}
                </div>
             <div class="clearfix"/>
        </script>
	</xsl:template>

	<xsl:template match="node()" mode="getMarkers">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisgeoLocation" select="$geoLocation[name = $this/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
		<xsl:variable name="thisgeoCode" select="$geoCode[name = $thisgeoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
		<xsl:variable name="lat" select="$thisgeoCode/own_slot_value[slot_reference = 'geocode_latitude']/value"/>
		<xsl:variable name="long" select="$thisgeoCode/own_slot_value[slot_reference = 'geocode_longitude']/value"/>
		<xsl:if test="$lat"> {latLng: [<xsl:value-of select="$lat"/>,<xsl:value-of select="$long"/>], name: '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisgeoLocation"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>', style: {fill: '#faa053'}, id:'<xsl:value-of select="$thisgeoLocation/own_slot_value[slot_reference = 'gl_identifier']/value"/>'},</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="getApps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisApps" select="$allApps"/>
		<xsl:apply-templates select="$thisApps" mode="appList"/>
	</xsl:template>
	<xsl:template match="node()" mode="getNodes">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = current()/name]"/>
		<xsl:variable name="thisAPRs" select="$allAPRs[own_slot_value[slot_reference = 'role_for_application_provider']/value = $thisApps/name]"/>
		
		<xsl:variable name="thisApptoProcsDirect" select="$allApptoProcsDirect[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = $thisApps/name]"/>
 
	 
		<xsl:variable name="thisAPRstoProcsIndirect" select="$allAPRstoProcsIndirect[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $thisAPRs/name]"/>
		<xsl:variable name="thisAPRstoProcs" select="$thisAPRstoProcsIndirect union $thisApptoProcsDirect"/>
		
		<xsl:variable name="thisPhysProcs" select="$allPhysProcs[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $thisAPRstoProcs/name]"/>
		<xsl:variable name="thisBusProcs" select="$allBusProcs[own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value = $thisPhysProcs/name]"/>
		<xsl:apply-templates select="$thisBusProcs" mode="getProcesses"/>
	</xsl:template>
	<xsl:template match="node()" mode="getProcesses">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisPhysProcs" select="$allPhysProcsBase[name = $this/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
		<xsl:variable name="thisOrgs" select="$allOrg[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisdirectOrg" select="$directOrg[name = $thisPhysProcs/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisviaActors" select="$allviaActors[own_slot_value[slot_reference = 'actor_plays_role']/value = $thisOrgs/name]"/>
		<xsl:variable name="thisIsActors" select="$thisviaActors | $thisdirectOrg"/> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "teams":[ <xsl:apply-templates select="$thisIsActors" mode="Teams"/>]}, </xsl:template>
	<xsl:template match="node()" mode="appList"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="anchorClass">text-black</xsl:with-param>
		</xsl:call-template>"}, </xsl:template>
	<xsl:template match="node()" mode="Teams"> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "teams":[]}, </xsl:template>
	<xsl:template match="node()" mode="options">
		<xsl:variable name="this" select="current()"/>
		<option value="{$this/name}">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</option>
	</xsl:template>
	<xsl:template match="node()" mode="supplierOptions">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
		<option id="{$thisid}"><xsl:attribute name="value"><xsl:value-of select="current()/name"/></xsl:attribute>
			<xsl:attribute name="data-easid">
				<xsl:value-of select="eas:getSafeJSString(current()/name)"/>
			</xsl:attribute>
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>
		</option>a
	</xsl:template>
	<xsl:template match="node()" mode="busCaps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="subCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","subCaps":[ <xsl:apply-templates select="$subCaps" mode="subCaps"/>]}, </xsl:template>
	<xsl:template match="node()" mode="subCaps">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="relatedCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","relatedCaps":[ <xsl:apply-templates select="$relatedCaps" mode="relatedCaps"/>] }, </xsl:template>
	<xsl:template match="node()" mode="relatedCaps">
		<xsl:param name="num" select="1"/>
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="relatedCaps" select="$busCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","num":<xsl:value-of select="$num"/>}, <xsl:if test="$num &lt; 10"><xsl:apply-templates select="$relatedCaps" mode="relatedCaps"><xsl:with-param name="num" select="$num + 1"/></xsl:apply-templates></xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="supplier">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisTechProds" select="$allTechProds[own_slot_value[slot_reference = 'supplier_technology_product']/value = $this/name]"/>
		<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'ap_supplier']/value = $this/name]"/> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "technologies":[<xsl:apply-templates select="$thisTechProds" mode="supplierTech"/>], "apps":[<xsl:apply-templates select="$thisApps" mode="supplierApp"/>],"licences":[<xsl:if test="$thisApps"><xsl:apply-templates select="$thisApps" mode="productList"/></xsl:if><xsl:if test="$thisTechProds"><xsl:apply-templates select="$thisTechProds" mode="productList"/></xsl:if>]}, </xsl:template>


	<xsl:template match="node()" mode="supplierTech"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="anchorClass">text-black</xsl:with-param>
		</xsl:call-template>","impacted":[<xsl:apply-templates select="$this" mode="TechCaps"/>]},</xsl:template>

	<xsl:template match="node()" mode="TechCaps"><xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisTPRs" select="$allTPRs[name = $this/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
		<xsl:variable name="thisTPU" select="$allTPU[own_slot_value[slot_reference = 'provider_as_role']/value = $thisTPRs/name]"/>
		<xsl:variable name="thisTBA" select="$allTBA[own_slot_value[slot_reference = 'contained_architecture_components']/value = $thisTPU/name]"/>
		<xsl:variable name="thisTPB" select="$allTPB[own_slot_value[slot_reference = 'technology_provider_architecture']/value = $thisTBA/name]"/>
		<xsl:variable name="thisAppDeps" select="$allAppDeps[own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $thisTPB/name]"/>
		<xsl:variable name="thisTechApps" select="$allTechApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $thisAppDeps/name]"/>
		<xsl:variable name="thisAPRs" select="$allAPRs[own_slot_value[slot_reference = 'role_for_application_provider']/value = $thisTechApps/name]"/>
		<xsl:variable name="thisAPRstoProcs" select="$allAPRstoProcs[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $thisAPRs/name]"/>
		<xsl:variable name="thisPhysProcs" select="$allPhysProcsBase[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $thisAPRstoProcs/name]"/>
		<xsl:variable name="thisBusProcs" select="$allBusProcs[own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisBusCaps" select="$busCaps[name = $thisBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/> {"apps":[<xsl:apply-templates select="$thisTechApps" mode="stdImpact"/>]}, {"processes":[<xsl:apply-templates select="$thisBusProcs" mode="stdImpact"/>]}, {"caps":[<xsl:apply-templates select="$thisBusCaps" mode="capImpact"><xsl:with-param name="thisBusProcs" select="$thisBusProcs"/></xsl:apply-templates>]}, </xsl:template>


	<xsl:template match="node()" mode="supplierApp"><xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisAPRs" select="$allAPRs[own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name]"/>
		<xsl:variable name="thisApptoProcsDirect" select="$allApptoProcsDirect[own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value = current()/name]"/>
 
	 
		<xsl:variable name="thisAPRstoProcsIndirect" select="$allAPRstoProcsIndirect[own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value = $thisAPRs/name]"/>
		<xsl:variable name="thisAPRstoProcs" select="$thisAPRstoProcsIndirect union $thisApptoProcsDirect"/>
		
		 
		<xsl:variable name="thisPhysProcs" select="$allPhysProcsBase[own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value = $thisAPRstoProcs/name]"/>
		<xsl:variable name="thisBusProcs" select="$allBusProcs[own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value = $thisPhysProcs/name]"/>
		<xsl:variable name="thisBusCaps" select="$busCaps[name = $thisBusProcs/own_slot_value[slot_reference = 'realises_business_capability']/value]"/>{"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","simplename":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="anchorClass">text-black</xsl:with-param>
		</xsl:call-template>","license":"tbc","capabilitiesImpacted":[<xsl:apply-templates select="$thisBusCaps" mode="capImpact"><xsl:with-param name="thisBusProcs" select="$thisBusProcs"/></xsl:apply-templates>],
		"debugD":"<xsl:value-of select="$thisApptoProcsDirect/own_slot_value[slot_reference = 'relation_name']/value"/>",
		"debugI":"<xsl:value-of select="$thisAPRstoProcsIndirect/own_slot_value[slot_reference = 'relation_name']/value"/>" },</xsl:template>

	<xsl:template match="node()" mode="stratPlans"><xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisStratPlans" select="$allObjectives[name = $this/own_slot_value[slot_reference = 'strategic_plan_supports_objective']/value]"/>
		<xsl:variable name="thisPlannedElements" select="$allPlannedElements[name = $this/own_slot_value[slot_reference = 'strategic_plan_for_elements']/value]"/>{"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "fromDate":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>", "endDate":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>", "impacts":[<xsl:apply-templates select="$thisPlannedElements" mode="planImpact"/>], "objectives":[<xsl:apply-templates select="$thisStratPlans" mode="stdImpact"/>] }, </xsl:template>

	<xsl:template match="node()" mode="planImpact"><xsl:variable name="this" select="current()"/><xsl:variable name="thisPlannedActions" select="$allPlannedActions[name = $this/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"/>{"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","impacted_element":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value"/>","planned_action":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisPlannedActions"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"},</xsl:template>

	<xsl:template match="node()" mode="stdImpact"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","simplename":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="anchorClass">text-black</xsl:with-param>
		</xsl:call-template>"},</xsl:template>

	<xsl:template match="node()" mode="capImpact"><xsl:param name="thisBusProcs"/><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","name":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="anchorClass">text-black</xsl:with-param>
		</xsl:call-template>","processes":[<xsl:apply-templates select="$thisBusProcs" mode="stdImpact"/>]},</xsl:template>

	<xsl:template match="node()" mode="productList">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisSupplierContracts" select="$supplierContracts[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $this/name]"/>
		<xsl:variable name="thisContracts" select="$contracts[name = $thisSupplierContracts/own_slot_value[slot_reference = 'obligation_component_from_obligation']/value]"/>
		<xsl:choose>
			<xsl:when test="$thisContracts">
				<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
				<xsl:variable name="thisActualContract" select="$actualContracts[own_slot_value[slot_reference = 'contract_uses_license']/value = $thisLicenses/name]"/>
				<xsl:variable name="period" select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/>
				<xsl:variable name="endYear" select="functx:add-months(xs:date(substring($thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $period)"/>
				<!--<xsl:variable name="remaining" select="days-from-duration(xs:duration($endYear - current-date()))"/>
    <xsl:variable name="Year" select="year-from-date(xs:date($endYear))"/> 
    <xsl:variable name="Month" select="month-from-date(xs:date($endYear))"/> 
    <xsl:variable name="Day" select="day-from-date(xs:date($endYear))"/> -->
				<xsl:if test="$thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value"> {"id":"<xsl:value-of select="translate($this/name, '.', '')"/>","productSimple":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","product": "<xsl:call-template name="RenderInstanceLinkForJS">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="anchorClass">text-black</xsl:with-param>
					</xsl:call-template>","oid":"<xsl:value-of select="$this/name"/>","debug":"<xsl:value-of select="$this/name"/>", "Contract":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisContracts"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","Licence":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisLicenses"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","LicenceType":"<xsl:value-of select="$licenseType[name = $thisLicenses/own_slot_value[slot_reference = 'license_type']/value]/own_slot_value[slot_reference = 'name']/value"/>","licenseOnContract":"<xsl:value-of select="$thisActualContract/own_slot_value[slot_reference = 'contract_number_of_units']/value"/>",<!--"YearsOnContract":"<xsl:value-of select="($thisLicenses/own_slot_value[slot_reference='license_months_to_renewal']/value)div 12"/>","licenseCostContract":"<xsl:value-of select="format-number($thisActualContract/own_slot_value[slot_reference='contract_deal_cost']/value, '##,###,###')"/>","licenseUnitPriceContract":"<xsl:value-of select="format-number($thisActualContract/own_slot_value[slot_reference='contract_unit_cost']/value, '##,###,###')"/>","month":"<xsl:value-of select="$Month"/>","year":"<xsl:value-of select="$Year"/>","EndDate":"<xsl:value-of select="$Day"/>/<xsl:value-of select="$Month"/>/<xsl:value-of select="$Year"/>","remaining":<xsl:value-of select="$remaining"/>,"rembgColor":
    "<xsl:choose><xsl:when test="$remaining &lt; 0">red</xsl:when>
    <xsl:when test="$remaining > 0 and $remaining &lt; 180">#f4c96a</xsl:when>
    <xsl:otherwise>#98d193</xsl:otherwise></xsl:choose>"-->"debug2":"", "dateISO":"<xsl:value-of select="$endYear"/>"}, </xsl:if>
			</xsl:when>
		</xsl:choose>
    </xsl:template>
    
    <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/>
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
//console.log(apiDataSetURL);    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
//console.log(this.responseText);  
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                        }
                    };
                    xmlhttp.onerror = function () {
                        reject(false);
                    };
                    xmlhttp.open("GET", apiDataSetURL, true);
                    xmlhttp.send();
                } else {
                    reject(false);
                }
            });
        };

        $(document).ready(function() {
        promise_loadViewerAPIData(viewAPIData)
            .then(function(response) {		
                let data = response;
				$('#ess-data-gen-alert').hide();
                var focusSupplier=[];
    supplierJSON=data.suppliers;
    capabilityJSON=data.capabilities;
    plansJSON=data.plans;       
	
      capabilityJSON.forEach(function(d){
        d['boxHeight']=((Math.floor(d.subCaps.length / 7)+1) * 55)+20;
      })
      
	//console.log(capabilityJSON);
 
      capabilityJSON.forEach(function(d){
      
        $("#capabilitiesDiv").append(capTemplate(d));
        })
      
      $('#pickSuppliers').change(function(){
       $("#supplierDiv").empty();$("#supplierName").empty();
       $("#supplierDiv2").empty();$("#supplierName").empty();
      $('.key').show();
        clearHighlight();
        $('.busRefModel-blob').css('background-color','#f8f8f8')
        let supid=$('#pickSuppliers').find(':selected').data('easid');
        var thisSupplier=supplierJSON.filter(function(d){
    
                return d.id==supid;
            })
          //  console.log(supid)
          //  console.log(supplierJSON)
           // console.log(thisSupplier)
//console.log(thisSupplier);	
        $("#supplierName").append(thisSupplier[0].name)
        $("#supplierDiv").append(suppTemplate(thisSupplier[0]));
        $("#supplierDiv2").append(suppTemplate(thisSupplier[0]));


        $('.elementName').on('mouseover',function(){
            let focus=$(this).data('easid');

 
        })
        focusSupplier=thisSupplier[0];
            thisSupplier[0].apps.forEach(function(d){
                 d.capabilitiesImpacted.forEach(function(e){  
                        capabilityJSON.forEach(function(c1){
                                 c1.subCaps.forEach(function(c2){
                                    if(c2.id===e.id){$('.'+c2.id).css('background-color','#00c4ff');
                                        }
                                     c2.relatedCaps.forEach(function(c3){
                                        if(c3.id===e.id){$('.'+c2.id).css('background-color','#00c4ff');
                                                    }
                                                })
                                            })
                                        })
                                    })
                            })

                thisSupplier[0].technologies.forEach(function(d){
        
                 d.impacted.forEach(function(im){  
     
 
      if(im.caps){   im.caps.forEach(function(e,i){ 
                        capabilityJSON.forEach(function(c1){
                                 c1.subCaps.forEach(function(c2){
                                    if(c2.id===e.id){$('.'+c2.id).css('background-color','#00c4ff');
                                        }
                                     c2.relatedCaps.forEach(function(c3){
                                        if(c3.id===e.id){$('.'+c2.id).css('background-color','#00c4ff');
                                                    }
                                                })
                                            })
                                        })
                                    })    
                                  }
                                })
                            })
      <!-- ADDS INDICATOR TO LEFT THAT THE CAPABILITY IS IMPACTED BY AN APP  -->
      $('.appList').mouseout(function(){
        $('.busRefModel-blob').css({'border-bottom':'1pt solid #aaa','box-shadow': 'none'}).fadeTo(1000, 1);
      })
                    $('.appList').mouseover(function(){
                    var focusCap = $(this).data('easid');
                    var thisApp=thisSupplier[0].apps.filter(function(d){
                            return d.id===focusCap
                        });

let tech=$(this).data('easid')
        if(!(thisApp[0])){
                       let pickedTech=thisSupplier[0].technologies.filter(function(d){
                           return d.id==tech;
                       })      ;
                       pickedTech[0].impacted.forEach(function(i){
                        if(i.capAscendents){
                            let thisO=Object.keys(i);
                            i[thisO].forEach((e)=>{;
                                $("."+e).css({'border-bottom':'3pt solid green','box-shadow': '5px 5px 5px #ccc'})
                            })
                        }
                    })
                }
        


      if( thisApp[0]){
		 
                    thisApp[0].capAscendents?.forEach(function(e){ 
						if(e!=''){
                     	   $("."+e).css({'border-bottom':'3pt solid green','box-shadow': '5px 5px 5px #ccc'})
						}
                    })
                        }
                    })
                    
     <!-- CLEARS INDICATOR  --> 
      
      
                    $('.appCapList').mouseover(function(){ 
                        clearHighlight();  
                    });
      
                    $('[data-toggle="popover"]').popover(
                        {
                            container: 'body',
                            html: true,
                            trigger: 'click',
                            title: function ()
                            {
                                return $(this).next('.popupTitle').html();
                            },
                            content: function ()
                            {
                                return $(this).next().next('.popupContent').html();
                            }
                        });
					
						$(document).on('click', function(e) {
							// Check if the click is outside the popover
							if (!$(e.target).closest('.popover').length &amp;&amp; !$(e.target).is('[data-toggle="popover"]')) {
								$('[data-toggle="popover"]').popover('hide');
							}
						});	
      
                    sortSupplierPlans(thisSupplier);
      
                     })
     let selected="<xsl:value-of select="$param1"/>";
		 
		if(selected!=''){
			$('#pickSuppliers').val(selected).trigger('change');

		}
      
      function clearHighlight(){
                        $('.busRefModel-blob').css({'border-bottom':'1pt solid #aaa','box-shadow': '0px 0px 0px #000000','perspective': '0px'});    
      } 
      
     function sortSupplierPlans(supplierInfo){
       $("#supplierTime").empty();
        var plans=[];
        supplierInfo[0].apps.forEach(function(d){
           
        plansJSON.forEach(function(e){
                e.impacts.forEach(function(ef){
      
                if(ef.impacted_element===d.id){e['impactName']=d.name;e['impactId']=d.id;e['impactType']='';e['impactAction']=ef.planned_action;plans.push(e)}

            d.capabilitiesImpacted.forEach(function(c){
                if(c.id===ef.impacted_element){e['impactName']=c.name;e['impactId']=c.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The capability'; plans.push(e)}
            
            c.processes.forEach(function(p){
                if(p.id===ef.impacted_element){e['impactName']=p.name;e['impactId']=p.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The process';plans.push(e)}
                        });
                    });
                });
           });  
        });
      

        supplierInfo[0].technologies.forEach(function(d){
            plansJSON.forEach(function(e){
                e.impacts.forEach(function(ef){
      
                if(ef.impacted_element===d.id){e['impactName']='The organisation ';e['app']=d.name;e['impactId']=d.id;e['impactType']='';e['impactAction']=ef.planned_action;plans.push(e)}
                d.impacted.forEach(function(i){
                    if(i.apps){
                          i.apps.forEach(function(a1){
                          if(a1.id===ef.impacted_element){e['impactName']=a1.name;e['impactId']=a1.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The application';plans.push(e)}  
                          })  
                        }
                    if(i.processes){
                          i.processes.forEach(function(a1){
                          if(a1.id===ef.impacted_element){e['impactName']=a1.name;e['impactId']=a1.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The process';plans.push(e)}  
                          })  
                        }
                    if(i.caps){
                          i.caps.forEach(function(a1){
                          if(a1.id===ef.impacted_element){e['impactName']=a1.name;e['impactId']=a1.id;e['impactAction']=ef.planned_action;e['app']=d.name;e['impactType']='The capability';plans.push(e)}  
                          })  
                        } 
      
                      })
                
            });
           });

            });
     
       supplierInfo[0].licences.forEach(function(d){
        var supLicencePlans=[]; 
          supLicencePlans['name']='Licence Renewal of '+d.productSimple +' due '+ d.dateISO;
          supLicencePlans['impactName']='The organisation ';
          supLicencePlans['impactId']=d.id;
          supLicencePlans['impactAction']='Renewal';
          supLicencePlans['app']=d.product;
          supLicencePlans['impactType']='';
          supLicencePlans['endDate']=d.dateISO
          supLicencePlans['actionRqdA']='Renew';
          supLicencePlans['actionRqdC']='Cancel';
            plans.push(supLicencePlans) 
      })
      supplierInfo[0].techlicences.forEach(function(d){
        var supLicencePlans=[]; 
          supLicencePlans['name']='Licence Renewal of '+d.productSimple +' due '+ d.dateISO;
          supLicencePlans['impactName']='The organisation ';
          supLicencePlans['impactId']=d.id;
          supLicencePlans['impactAction']='Renewal';
          supLicencePlans['app']=d.product;
          supLicencePlans['impactType']='';
          supLicencePlans['endDate']=d.dateISO
          supLicencePlans['actionRqdA']='Renew';
          supLicencePlans['actionRqdC']='Cancel';
            plans.push(supLicencePlans) 
      })
        
        //console.log(plans)
        let plans_array_tech = plans.filter(function(elem, index, self) {
                return index == self.indexOf(elem);
            });
        plans_array_tech.sort(SortByDate);
        $("#supplierTime").append(timeTemplate(plans_array_tech))
        };
      
        });

		
         })
           

       function SortByDate(x,y) {
          return ((x.endDate == y.endDate) ? 0 : ((x.endDate > y.endDate) ? 1 : -1 ));
        }



    </xsl:template>
    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
        	<xsl:call-template name="RenderAPILinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>

        
    </xsl:template>
</xsl:stylesheet>
