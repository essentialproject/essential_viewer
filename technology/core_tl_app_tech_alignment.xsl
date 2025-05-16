<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:functx="http://www.functx.com" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:user="http://www.enterprise-architecture.org/essential/vieweruserdata">
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param1 = the subject of the UML model -->
	<xsl:param name="param1"/>

	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!-- 24.08.2016 JP Created as revised version of original view -->


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Product', 'Technology_Component', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="allInfoReps" select="/node()/simple_instance[type=('Information_Representation')]"/>

	<xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="allAPUs" select="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
	<xsl:key name="allArchUsagesKey" match="/node()/simple_instance[type='Static_Application_Provider_Usage']" use="name"/>
	<xsl:key name="allSAKey" match="/node()/simple_instance[supertype='Application_Provider']" use="own_slot_value[slot_reference='ap_static_architecture']/value"/>
	<xsl:key name="allAppsforSAKey" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]" use="name"/>
	<xsl:key name="allAppProtoInfoKey" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION','APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]" use="name"/>
	<xsl:key name="allInfoRepKey" match="/node()/simple_instance[type=('Information_Representation')]" use="name"/>
	
    <xsl:variable name="allAppProtoInfo" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION'][name=$allAPUs/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
    <xsl:variable name="allInfo" select="/node()/simple_instance[type='Information_Representation'][name=$allAppProtoInfo/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>


	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!-- 23.04.2015 JP	Created -->

	<xsl:variable name="appProvNode" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appProvName" select="$appProvNode/own_slot_value[slot_reference = 'name']/value"/>

	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="strategicLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'ProductionStrategic']"/>
	<xsl:variable name="strategicLifecycleStyle" select="eas:get_lifecycle_style($strategicLifecycleStatus)"/>
	<xsl:variable name="pilotLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Pilot']"/>
	<xsl:variable name="pilotLifecycleStyle" select="eas:get_lifecycle_style($pilotLifecycleStatus)"/>
	<xsl:variable name="underPlanningLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Under Planning']"/>
	<xsl:variable name="underPlanningLifecycleStyle" select="eas:get_lifecycle_style($underPlanningLifecycleStatus)"/>
	<xsl:variable name="prototypeLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Prototype']"/>
	<xsl:variable name="prototypeLifecycleStyle" select="eas:get_lifecycle_style($prototypeLifecycleStatus)"/>

	<xsl:variable name="alllifecycleStyles" select="/node()/simple_instance[name = $allLifecycleStatii/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>


	<!-- Get the Technology Product Roles defined for the production deployment of the application -->
	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[
    type = 'Technology_Product_Role' and
    own_slot_value[slot_reference = 'role_for_technology_provider']/value != '' and 
    own_slot_value[slot_reference = 'implementing_technology_component']/value != ''
]"/>
<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="prodDeploymentRole" select="/node()/simple_instance[type = 'Deployment_Role' and (own_slot_value[slot_reference = 'name']/value = 'Production')]"/>
	<xsl:variable name="appProdDeployment" select="/node()/simple_instance[(own_slot_value[slot_reference = 'application_provider_deployed']/value = $appProvNode/name) and (own_slot_value[slot_reference = 'application_deployment_role']/value = $prodDeploymentRole/name)]"/>
	<xsl:variable name="techProdBuild" select="/node()/simple_instance[name = $appProdDeployment/own_slot_value[slot_reference = 'application_deployment_technical_arch']/value]"/>
	<xsl:variable name="techProvArch" select="/node()/simple_instance[name = $techProdBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
	<xsl:variable name="appDepTPRUsages" select="/node()/simple_instance[(type = 'Technology_Provider_Usage') and (name = $techProvArch/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
	<xsl:variable name="appDepTPRs" select="$allTechProdRoles[name = $techProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>

	<!-- Get the Technology Product Roles defined for any Technology Product Builds that provide the Technology Composite supporting the app -->
	<xsl:variable name="appTechComp" select="/node()/simple_instance[name = $appProvNode/own_slot_value[slot_reference = 'implemented_with_technology']/value]"/>
	<xsl:variable name="appTechProdBuildRole" select="/node()/simple_instance[name = $appTechComp/own_slot_value[slot_reference = 'realised_by_technology_products']/value]"/>
	<xsl:variable name="appTechProdBuild" select="/node()/simple_instance[name = $appTechProdBuildRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="appTechProvArch" select="/node()/simple_instance[name = $appTechProdBuild/own_slot_value[slot_reference = 'technology_provider_architecture']/value]"/>
	<xsl:variable name="appTechTPRUsages" select="/node()/simple_instance[(type = 'Technology_Provider_Usage') and (name = $appTechProvArch/own_slot_value[slot_reference = 'contained_architecture_components']/value)]"/>
	<xsl:variable name="appTechTPRs" select="$allTechProdRoles[name = $appTechTPRUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>

	<!-- Combine the Technology Product Roles supporting the production app deployment and that iplement the technology composite supporting it -->
	<xsl:variable name="techProdRoleUsages" select="$appDepTPRUsages union $appTechTPRUsages"/>
	<xsl:variable name="techProdRoles" select="$appDepTPRs union $appTechTPRs"/>
	<xsl:variable name="techProds" select="$allTechProds[name = $techProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	<xsl:variable name="techComps" select="/node()/simple_instance[name = $techProdRoles/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
	<xsl:variable name="techLProdSuppliers" select="$allSuppliers[name = $techProds/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
	<xsl:variable name="techProdArchRelations" select="/node()/simple_instance[(type = ':TPU-TO-TPU-RELATION') and (name = $techProvArch/own_slot_value[slot_reference = 'contained_provider_architecture_relations']/value)]"/>

	<xsl:variable name="sourceTechProdRoleUsages" select="$techProdRoleUsages[name = $techProdArchRelations/own_slot_value[slot_reference = ':FROM']/value]"/>
	<xsl:variable name="targetTechProdRoleUsages" select="$techProdRoleUsages[name = $techProdArchRelations/own_slot_value[slot_reference = ':TO']/value]"/>

	<xsl:variable name="nonDependentTechProdRoleUsages" select="$techProdRoleUsages[not(name = $targetTechProdRoleUsages/name)]"/>
	<xsl:variable name="nonDependentTechProdRoles" select="$techProdRoles[name = $nonDependentTechProdRoleUsages/own_slot_value[slot_reference = 'provider_as_role']/value]"/>

	<!-- Get variables for Technology Product Standards -->
	<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
	<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[name = $allTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
	<xsl:variable name="allStandardStyles" select="/node()/simple_instance[name = $allStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>

	<xsl:key name="tprProdKey" match="/node()/simple_instance[supertype='Technology_Provider']" use="own_slot_value[slot_reference = 'implements_technology_components']/value"/>
	<xsl:key name="tprCompKey" match="/node()/simple_instance[type='Technology_Component']" use="own_slot_value[slot_reference = 'realised_by_technology_products']/value"/>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"></xsl:variable>

	<xsl:variable name="modelSubjectName">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="modelSubjectDesc">
		<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="appObjectHeight" select="50"/>

	<xsl:variable name="objectWidth" select="240"/>
	<xsl:variable name="objectHeight" select="115"/>
	<xsl:variable name="objectTextWidth" select="160"/>
	<xsl:variable name="objectTextHeight" select="100"/>
	<xsl:variable name="objectStrokeWidth" select="1"/>
	<xsl:variable name="objectFont">'font-weight': 'bold'</xsl:variable>

	<xsl:variable name="objectSubBlockTitleHeight" select="15"/>
	<xsl:variable name="objectSubBlockTitleXPos" select="0"/>
	<xsl:variable name="objectSubBlockTitleYPos" select="77"/>
	<xsl:variable name="objectSubBlockTitleFont">'font-weight': 'bold', 'font-size': '0.8em', 'font-variant': 'small-caps'</xsl:variable>
	
	<xsl:variable name="objectSubBlockHeight" select="23"/>
	<xsl:variable name="objectSubBlockXPos" select="0"/>
	<xsl:variable name="objectSubBlockYPos" select="92"/>
	<xsl:variable name="objectSubBlockFont">'font-weight': 'bold', 'font-variant': 'small-caps', 'text-transform': 'capitalize'</xsl:variable>
	

	<xsl:variable name="noStatusColour">Grey</xsl:variable>
	<xsl:variable name="noStandardColour">hsla(0, 75%, 35%, 1)</xsl:variable>
	<xsl:variable name="noStatusStyle">backColourGrey</xsl:variable>
	<xsl:variable name="objectColour">hsla(220, 70%, 95%, 1)</xsl:variable>
	<xsl:variable name="objectTextColour">Black</xsl:variable>
	<xsl:variable name="objectOutlineColour">Black</xsl:variable>
	
	<xsl:variable name="appObjectColour">hsla(220, 70%, 15%, 1)</xsl:variable>
	<xsl:variable name="appObjectTextColour">White</xsl:variable>
	<xsl:variable name="appObjectOutlineColour">hsla(220, 70%, 85%, 1)</xsl:variable>
	<xsl:variable name="appObjectStrokeWidth" select="6"/>
	<xsl:variable name="appObjectFont">'font-weight': 'bold', 'font-size': '1.2em'</xsl:variable>


	<xsl:variable name="pageTitle" select="'Application Technology Strategy Alignment for '"/>

	<xsl:variable name="techProdSummaryReport" select="eas:get_report_by_name('Core: Technology Product Summary')"/>
	<xsl:variable name="isEIPMode">
 		<xsl:choose>
 			<xsl:when test="$eipMode = 'true'">true</xsl:when>
 			<xsl:otherwise>false</xsl:otherwise>
 		</xsl:choose>
 	</xsl:variable>



	<xsl:template match="knowledge_base">
		<xsl:variable name="appPath">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"/>
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
				<title>
					<xsl:value-of select="$pageTitle"/>
					<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
					</xsl:call-template>
				</title>
				<script type="text/javascript" src="js/bootstrap-datepicker/js/bootstrap-datepicker.min.js?release=6.19"/>
				<link rel="stylesheet" type="text/css" href="js/bootstrap-datepicker/css/bootstrap-datepicker.min.css?release=6.19"/>
				<script src="js/jquery-migrate-1.4.1.min.js?release=6.19"></script>
				<link rel="stylesheet" type="text/css" href="js/jointjs/joint.min.css?release=6.19"/>
				<script src="js/lodash/index.js?release=6.19"/>
				<script src="js/backbone/backbone.js?release=6.19"/>
				<script src="js/graphlib/graphlib.core.js?release=6.19"/>
				<script src="js/dagre/dagre.core.js?release=6.19"/>
				<script src="js/jointjs/joint.min.js?release=6.19"/>
				<script src="js/jointjs/ga.js?release=6.19" async="" type="text/javascript"/>
				<script src="js/jointjs/joint_002.js?release=6.19"/>
				<script src="js/jointjs/joint.layout.DirectedGraph.js?release=6.19"/>
				<script src="js/svg-pan-zoom/svg-pan-zoom.min.js?release=6.19"/>
				<script src="js/jquery.tools.min.js?release=6.19" type="text/javascript"/>
				<style type="text/css">
					.Rect{
						pointer-events: none;
					}
					
					.techProdCell:hover{
						cursor: pointer;
					
					}
					#planModal {
					z-index: 10000;}

					#genDSL{ 
					}
				</style>
				<script>
					$(document).ready(function() {													
					// initialize tooltip
					$(".techProdCell").tooltip({
					
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
				<style>
					.label-block {
						display: block;
						padding: 5px;
						font-size: 14px;
					}
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<!--<xsl:variable name="modelSubjectDesc" select="$appProvNode/own_slot_value[slot_reference='description']/value" />-->
			<div class="container-fluid">
  <div class="row">
    <div class="col-xs-12">
      <h1 id="viewName">
        <span class="text-primary">
          <xsl:value-of select="eas:i18n('View')"/>:
        </span>
        <span class="text-darkgrey">
          <xsl:value-of select="$pageTitle"/>
        </span>
        <xsl:call-template name="RenderInstanceLink">
          <xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
          <xsl:with-param name="anchorClass" select="'text-primary'"/>
        </xsl:call-template>
      </h1>
    </div>
  </div>

  <div class="row">
    <div class="col-xs-12">
      <div class="input-group pull-right">
        <button class="btn btn-default right-10" id="genDSL" aria-describedby="copyDesc">
          <i class="fa fa-copy right-5" aria-hidden="true"></i>
          <xsl:value-of select="eas:i18n('Copy DSL to Clipboard')"/>
        </button>
      </div>
      <div class="xsmall text-right top-5">
        <span id="ess-copy-success-message" class="sr-only" role="status" aria-live="polite">
          <i class="fa fa-check right-5" aria-hidden="true"></i>
          <xsl:value-of select="eas:i18n('Copied!')"/>
        </span>
      </div>
    </div>
  </div>

  <!-- Modal -->
  <div id="planModal" class="modal fade" role="dialog" aria-modal="true" aria-labelledby="modalTitle" aria-describedby="modalDesc">
    <div class="modal-dialog" role="document">
      <div class="modal-content">

        <div class="modal-header">
          <h2 id="modalTitle" class="modal-title strong text-primary">
            <i class="fa fa-tasks right-5" aria-hidden="true"></i>
            <xsl:value-of select="eas:i18n('Create Plan to Switch')"/>
          </h2>
        </div>

        <div class="modal-body" id="modalDesc">
          <div class="form-group">
            <label for="planName"><xsl:value-of select="eas:i18n('Plan Name')"/>:</label>
            <input class="form-control" id="planName" name="planName" autocomplete="off"/>
          </div>

          <div class="form-group">
            <label for="planDescription"><xsl:value-of select="eas:i18n('Plan Description')"/>:</label>
            <textarea class="form-control" rows="3" id="planDescription" name="planDescription"></textarea>
          </div>

          <div class="form-group">
            <label for="planStart"><xsl:value-of select="eas:i18n('Plan Start Date')"/>:</label>
            <input class="form-control" id="planStart" name="planStart" type="date"/>
          </div>

          <div class="form-group">
            <label for="planEnd"><xsl:value-of select="eas:i18n('Plan End Date')"/>:</label>
            <input class="form-control" id="planEnd" name="planEnd" type="date"/>
          </div>

          <div class="form-group">
            <label for="requestor"><xsl:value-of select="eas:i18n('Requestor')"/>:</label>
            <input class="form-control" id="requestor" name="requestor" autocomplete="off"/>
          </div>

          <div class="form-group">
            <label for="planID"><xsl:value-of select="eas:i18n('ID')"/>:</label>
            <input class="form-control" id="planID" name="planID" autocomplete="off"/>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-danger right-10" data-dismiss="modal">
            <xsl:value-of select="eas:i18n('Cancel')"/>
          </button>
          <button class="btn btn-success" id="save">
            <xsl:value-of select="eas:i18n('Create Plan')"/>
          </button>
          <span id="savefeedback" aria-live="polite" role="status"></span>
        </div>
      </div>
    </div>
  </div>

  <!-- Logical Technology Architecture Section -->
  <div class="col-xs-12">
    <div class="sectionIcon">
      <i class="fa essicon-boxesdiagonal icon-section icon-color" aria-hidden="true"></i>
    </div>
    <h2 class="text-primary">
      <xsl:value-of select="eas:i18n('Logical Technology Architecture')"/>
    </h2>
    <xsl:call-template name="legend"/>
    <xsl:choose>
      <xsl:when test="count($techProdRoles) > 0">
        <div class="simple-scroller" style="overflow: auto;">
          <div id="mainPageDiv"></div>
        </div>
        <xsl:call-template name="modelScript">
          <xsl:with-param name="targetID">mainPageDiv</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <p><em><xsl:value-of select="eas:i18n('No Technology Platform Architecture Defined')"/></em></p>
      </xsl:otherwise>
    </xsl:choose>
    <hr/>
  </div>

  <!-- Strategy Alignment Section -->
  <div class="col-xs-12">
    <div class="sectionIcon">
      <i class="fa fa-check-circle icon-section icon-color" aria-hidden="true"></i>
    </div>
    <h2 class="text-primary">
      <xsl:value-of select="eas:i18n('Strategy Alignment')"/>
    </h2>

    <xsl:choose>
      <xsl:when test="count($techProdRoles) > 0">
        <table class="table table-bordered table-striped tot">
          <thead>
            <tr>
              <th scope="col">&#160;</th>
              <th scope="col" class="cellWidth-30pc"><xsl:value-of select="eas:i18n('Required Component')"/></th>
              <th scope="col" class="cellWidth-30pc"><xsl:value-of select="eas:i18n('Products Used')"/></th>
              <th scope="col" class="alignCentre cellWidth-20pc"><xsl:value-of select="eas:i18n('Lifecycle Status')"/></th>
              <th scope="col" class="alignCentre cellWidth-20pc"><xsl:value-of select="eas:i18n('Standard Level')"/></th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates mode="RenderTechProdRoleTableRows" select="$techComps">
              <xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
            </xsl:apply-templates>
          </tbody>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <p><em><xsl:value-of select="eas:i18n('No Technology Products Defined')"/></em></p>
      </xsl:otherwise>
    </xsl:choose>
    <hr/>
  </div>
</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
                    $(document).ready(function(){
                        var windowHeight = $(window).height();
						var windowWidth = $(window).width();
                        $('.simple-scroller').scrollLeft(windowWidth/2);
                    });

					<xsl:call-template name="RenderViewerAPIJSFunction">
						<xsl:with-param name="viewerAPIPath" select="$appPath"/>  
						
					</xsl:call-template>
				</script>
				
			

			</body>
		</html>
	</xsl:template>

	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/>  
			//a global variable that holds the data returned by an Viewer API Report
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>'; 
            var selectedApp='<xsl:value-of select="$param1"/>';
			//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		   
		   var promise_loadViewerAPIData = function(apiDataSetURL) {
				return new Promise(function (resolve, reject) {
					if (apiDataSetURL != null) {
						var xmlhttp = new XMLHttpRequest(); 
						xmlhttp.onreadystatechange = function () {
							if (this.readyState == 4 &amp;&amp; this.status == 200) { 
								var viewerData = JSON.parse(this.responseText);
								resolve(viewerData);
								$('#ess-data-gen-alert').hide();
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
			Promise.all([
			promise_loadViewerAPIData(viewAPIData)
			]).then(function(responses) {

				let allApps = responses[0].application_technology_architecture;

				let match=allApps.find((a)=>{
					return a.id== selectedApp;
				})
 
			 	match.supportingTech=match.supportingTech.filter((e)=>{return e.environmentName=='Production'})
			
  
				// Function to generate Structurizr DSL
				// Data to generate DSL
 
				// Function to generate Structurizr DSL with valid identifiers
                function generateDSL(data) {
                    let dsl = `
                      workspace {
                        model {
                          softwareSystem = softwareSystem "${data.application}" {
                            description "${data.application} Application"
                    `;
                  
                    // Collect containers and relationships
                    const containers = new Map(); // Use Map to track unique containers by valid identifier
                    const relationships = [];
                    const processedIdentifiers = new Set();
                  
                    // Helper function to check if a container with the same name already exists
                    function containerWithNameExists(name) {
                      for (let container of containers.values()) {
                        if (container.name === name) {
                          return true;
                        }
                      }
                      return false;
                    }
                    let allTags=[]
                    // Generate valid identifiers for tech products and add containers and relationships
                    data.supportingTech.forEach((tech) => {
                      const fromIdentifier = generateValidIdentifier(tech.fromTechProduct);
                      const toIdentifier = generateValidIdentifier(tech.toTechProduct);
             
                      // Add identifiers to the set
                      processedIdentifiers.add(fromIdentifier);
                      processedIdentifiers.add(toIdentifier);

                      let thisTpr=tprs.find((e)=>{
                        return tech.tpr==e.id
                    })
                   
                    if(thisTpr){
                    allTags.push({ name: thisTpr.lifecycle || 'Unnamed',
                    productName: thisTpr.productName,
                    componentName: thisTpr.componentName,
                    colour: thisTpr.lifecycle_colour, textColour: thisTpr.lifecycle_text_colour})
                    }else{
                        thisTpr=""
                    }
                  
                      // Add containers if they don't already exist
                      if (!containerWithNameExists(tech.fromTechProduct)) {
                        containers.set(fromIdentifier, {
                          name: tech.fromTechProduct,
                          description: tech.fromTechComponent || tech.fromTechProduct,
                          tags: thisTpr.lifecycle ? thisTpr.lifecycle.replace(/\s/g, '_') : ''
                        });
                      }
                  
                      if (!containerWithNameExists(tech.toTechProduct)) {
                        containers.set(toIdentifier, {
                          name: tech.toTechProduct,
                          description: tech.toTechComponent || tech.toTechProduct,
                          tags: thisTpr.lifecycle ? thisTpr.lifecycle.replace(/\s/g, '_') : ''
                        });
                      }
                  
                      // Add relationships
                      relationships.push({
                        from: fromIdentifier,
                        to: toIdentifier,
                        description: `Sends requests from ${tech.fromTechComponent} to ${tech.toTechComponent}`,
                      });
                    });
                  
                    // Add main application container
                    const mainAppIdentifier = data.application.replace(/\./g, '_').replace(/\s/g, '_');
                    containers.set(mainAppIdentifier, {
                      name: data.application,
                      description: `${data.application} Application`,
                    });
                  
                    // Add containers for all tech products
                   
					// Inside the allTechProds forEach loop
					// Track identifiers of containers with "Contains" relationships
					const containsProcessed = new Set();

					// Inside the allTechProds forEach loop
					data.allTechProds.forEach((tech) => {
						let thisTpr = tprs.find((e) => tech.tpr == e.id);
						if (thisTpr) {
							allTags.push({
								name: thisTpr.lifecycle || 'Unnamed',
								productName: thisTpr.productName,
								componentName: thisTpr.componentName,
								colour: thisTpr.lifecycle_colour || '#d3d3d3',
								textColour: thisTpr.lifecycle_text_colour || '#000000',
							});
						}

						const identifier = generateValidIdentifier(tech.product);

						// Check if the product has already been processed
						if (!processedIdentifiers.has(identifier)) {
							// Add the container if it doesn't exist
							containers.set(identifier, {
								name: tech.product,
								description: tech.component || tech.product,
								tags: thisTpr &amp;&amp; thisTpr.lifecycle ? thisTpr.lifecycle.replace(/\s/g, '_') : '',
							});

							// Now add the identifier to processedIdentifiers
							processedIdentifiers.add(identifier);
						}

						// Check if a "Contains" relationship has already been established
						if (!containsProcessed.has(identifier)) {
							if(identifier){
								// Add a "Contains" relationship to the main application
								
								relationships.push({
									to: identifier,
									from: mainAppIdentifier,
									description: "Contains",
								});

								// Mark that this container has had a "Contains" relationship established
								containsProcessed.add(identifier);
							}
						}
					});
                
                    const uniqueTags = Array.from(
                        new Set(allTags.map(tag => tag.name))
                      ).map(id => allTags.find(tag => tag.name === id));
                  
                    // Add containers to DSL
                    containers.forEach((container, identifier) => {
                       if(container.name){
                        let thistags={}
                        thisTags=allTags.find((f)=>{
                            return f.productName==container.name  &amp;&amp; f.componentName==container.description;
                        })
                     
                        if (!thisTags) {
                            thisTags = { name: "Not Set" };
                        }
                      dsl += `
                          ${identifier} = container "${container.name}" {
                            description "${container.description || container.name}"
                            technology "${container.name}"
                            tags "${thisTags.name.replace(/ /g, '_')}"

                          }
                      `;
						}
                    });
                  
                    // Add relationships to DSL
                    relationships.forEach((relationship) => {
                      dsl += `
                          ${relationship.from} -> ${relationship.to} "${relationship.description}"
                      `;
                    });
                  
                  
                    // Close the DSL structure
                    dsl += `
                        }
                        `
                        // Add unique applications to the top level
                        uniqueApps.forEach((app) => {
                          if (app !== data.application) {
                            dsl += `
                              ${app.replace(/\./g, '_').replace(/\s/g, '_')} = softwareSystem "${app}" {
                                description "${app} Application"
                              }
                            `;
                          }
                        });
                      
                        // Define APU relationships if defined
                        (thisFromAPUs || []).forEach((ap) => {
                          dsl += `
                              ${ap.fromApp.replace(/\./g, '_').replace(/\s/g, '_')} -> ${ap.toApp.replace(/\./g, '_').replace(/\s/g, '_')} "Sends data to"
                          `;
                        });
                      
                        (thisToAPUs || []).forEach((ap) => {
                          dsl += `
                              ${ap.fromApp.replace(/\./g, '_').replace(/\s/g, '_')} -> ${ap.toApp.replace(/\./g, '_').replace(/\s/g, '_')} "Sends data to"
                          `;
                        });    

                        dsl += `
                        }
                      views {
                        systemContext softwareSystem {
                          include *
                          autolayout lr
                        }
                        container softwareSystem {
                          include *
                          autolayout lr
                        }
                        theme default
                        styles {
                          element "Container" {
                            background #438dd5
                            color #ffffff
                          }
                          `

                      uniqueTags.forEach((t)=>{
                            dsl += ` element ${t.name.replace(/ /g, '_')} {
                                background ${t.colour}
                                color ${t.textColour}
                              }
                              `
                        })

                     dsl += `
                        }
                        }
                      }
                    
                    `;

                   
                  
                    return dsl;
                  }
                  
				
				// Function to generate valid identifier by replacing invalid characters
				function generateValidIdentifier(name) {
				 
					if (name) {
						return name.toLowerCase().replace(/[.#\s]/g, '_');
					}
				}
				   
		$('#genDSL').on('click', function(){

				const dsl = generateDSL(match);
				const tempTextArea = document.createElement("textarea");
				tempTextArea.value = dsl;
				document.body.appendChild(tempTextArea);
				tempTextArea.select();
				document.execCommand("copy");
				document.body.removeChild(tempTextArea); 

				// Output the DSL
				$("#ess-copy-success-message").fadeIn('slow').animate({opacity: 1.0}, 1500).effect("pulsate", { times: 2 }, 800).fadeOut('slow');
		})


			})
	let tprs=[<xsl:apply-templates select="$allTechProdRoles" mode="tprs"/>];
	let appNm="<xsl:value-of select="$appProvName"/>";
    var apus=[<xsl:apply-templates select="$allAPUs" mode="allAPUs"/>];
 
    var thisFromAPUs=apus.filter((a)=>{
        return a.fromAppId == selectedApp
    })
    var thisToAPUs=apus.filter((a)=>{
        return a.toAppId == selectedApp
    })

    allThisAPU=[...thisFromAPUs,...thisToAPUs]
    // Extract unique app names using Set
    const uniqueApps = Array.from(
        new Set(
            allThisAPU
            .flatMap((item) => [item.fromApp, item.toApp])
        )
      );

// Log the result

		$(document).ready(function(){
			
		$(document).off().on('click', '.replaceBut',function(d){ 
			let targTrp= $(this).attr('easid')
			 
			 let thisTpr=$(this).parent().parent().parent().parent().parent().parent().parent().parent().next().next().attr('tprid') 

			 let currentTPR=tprs.find((e)=>{
				 return e.id==thisTpr
			 })
			 let targetTPR=tprs.find((e)=>{
				 return e.id==targTrp
			 })

			 let planName= appNm +" - Replace "+ currentTPR.componentName;

			 let planDesc= appNm +" - Replace "+currentTPR.productName+" with "+targetTPR.productName +" for "+ currentTPR.componentName;
			 $('#planName').val(planName);

			 $('#planDescription').val(planDesc);
			$('#planModal').modal('show'); 
			$( function() {
				$( "#planStart" ).datepicker();
			} );
			$( function() {
				$( "#planEnd" ).datepicker();
			} );

			$('#save').off().on('click',function(){ 
			 

				let planS=$('#planStart').val();
				let planE=$('#planEnd').val();
				let planStart=new Date(planS).toISOString();
				let planEnd=new Date(planE).toISOString() ;
				let planDescription = $( "#planDescription" ).val();
				let requestor=$("#requestor").val();
				let planIDval=$("#planID").val();

		let plan  = {"name": planName,
					"className": "Enterprise_Strategic_Plan",
					"description": planDescription,
					"system_is_published": false,
					"strategic_plan_valid_from_date_iso_8601":planStart.substring(0,10),
					"strategic_plan_valid_to_date_iso_8601":planEnd.substring(0,10),
					"strategic_plan_for_elements":  [{ 
								"name": "replace - "+ currentTPR.productName + ' as '+currentTPR.componentName ,
								"className": "PLAN_TO_ELEMENT_RELATION",
								"plan_to_element_change_action": { 
									"name": 'Replace',
									"className": "Planning_Action"
								},
								"plan_to_element_ea_element": {
									"id": currentTPR.id, 
									"className": "Technology_Provider_Role"
								}
								},
								{ 
								"name": "enhance - "+ targetTPR.productName + ' as '+targetTPR.componentName ,
								"className": "PLAN_TO_ELEMENT_RELATION",
								"plan_to_element_change_action": { 
									"name": 'Enhance',
									"className": "Planning_Action"
								},
								"plan_to_element_ea_element": {
									"id": targetTPR.id, 
									"className": "Technology_Provider_Role"
								}
								}]
						}
			 

		essPromise_createAPIElement('/essential-utility/v3',plan,'instances','Enterprise_Strategic_Plan')
			.then(function(response){

				let decision = {"name": appNm +" - Replace "+currentTPR.productName+" with "+targetTPR.productName,
					  "className": "Enterprise_Decision",
					"decision_result": {
						"className": "Decision_Result",
						"name": 'Proposed'},
					"description":"Replace "+currentTPR.productName+" with "+targetTPR.productName +" for "+targetTPR.componentName,	 
					"ea_notes": requestor,
					"governance_reference":'ap'+planIDval,
					"decision_elements":[{id: currentTPR.id, className: 'Technology_Provider_Role'},{id:  targetTPR.id, className:'Technology_Provider_Role'},{"id":response.id, "className":"Enterprise_Strategic_Plan" }]
					};
		
					
					essPromise_createAPIElement('/essential-utility/v3',decision,'instances','Decision')
					.then(function(response){
					  
						//delete planElements;
						//delete plan;

						$('#planModal').modal('hide');
					}); 
			});
		});
	});
<!--  end  --> 
});
</xsl:template>

	<xsl:template name="modelScript">
		<xsl:param name="targetID"/>
		<xsl:if test="count($techProdRoles) > 0">
			<script>
					
					var graph = new joint.dia.Graph;
					var pannedGraph;
					
					function resetZoom() {
						pannedGraph.reset();
					}
					
					var windowWidth = $(window).width()*2;
					var windowHeight = $(window).height()*2;
					
					var paper = new joint.dia.Paper({
						el: $('#<xsl:value-of select="$targetID"/>'),
				        width: $('#<xsl:value-of select="$targetID"/>').width(),
				        height: <xsl:value-of select="($objectHeight + 30) * count($techProdRoles)"/>,
				        gridSize: 1,
				        model: graph
				    });
				    
				    var modelSVG = paper.svg;
				    
				    
				    
				    paper.setOrigin(30,30);
					
					// Create a custom element.
					// ------------------------
					joint.shapes.custom = {};
					joint.shapes.custom.Cluster = joint.shapes.basic.Rect.extend({
						markup: '<g class="rotatable"><g class="scalable"><rect/></g><a><text/></a></g>',
					    defaults: joint.util.deepSupplement({
					        type: 'custom.Cluster',
					        attrs: {
					            rect: { fill: '#E67E22', stroke: '#D35400', 'stroke-width': 5 },
					            text: { 
					            	fill: 'white',
					            	'ref-x': .5,
		                        	'ref-y': .4
					            }
					        }
					    }, joint.shapes.basic.Rect.prototype.defaults)
					});
					
					
					function wrapClusterName(nameText) {
						return joint.util.breakText(nameText, {
						    width: <xsl:value-of select="$objectTextWidth"/>,
						    height: <xsl:value-of select="$objectTextHeight"/>
						});
					}
					
					function wrapElementName(nameText) {
						return joint.util.breakText(nameText, {
						    width: 80,
						    height: 80
						});
					}
					
					<xsl:call-template name="RenderAppNameVariable"/>
					<xsl:apply-templates mode="RenderTPRNameVariable" select="$techProdRoles"/>
					
					var clusters = {
						<xsl:apply-templates mode="RenderTPRDefinition" select="$techProdRoles"/>			
					};
					
					<xsl:call-template name="RenderAppDefinition"/>
					
					graph.addCell(app);
					_.each(clusters, function(c) { graph.addCell(c); });
					
		
		
					var relations = [
					<xsl:apply-templates mode="RenderAppRelation" select="$nonDependentTechProdRoleUsages"/>
					<xsl:apply-templates mode="RenderTechProdRelation" select="$sourceTechProdRoleUsages"/>
					];
					
					_.each(relations, function(r) { graph.addCell(r); });
					
					
					joint.layout.DirectedGraph.layout(graph, { setLinkVertices: false, rankDir: "TB", nodeSep: 100, edgeSep: 100 });
					
					
					<xsl:apply-templates mode="RenderTPRLifecycleStatus" select="$techProdRoles"/>
					<xsl:apply-templates mode="RenderTPRStandardComplianceStatus" select="$techProdRoles"/>
					
					pannedGraph = svgPanZoom(modelSVG, {controlIconsEnabled: true, panEnabled: false, mouseWheelZoomEnabled: false, minZoom: 0.1});
					
					// paper.scale(0.9, 0.9);
					// paper.scaleContentToFit();
		    
				</script>
		</xsl:if>
	</xsl:template>



	<xsl:template mode="RenderTPRNameVariable" match="node()">
		<xsl:variable name="nodeType" select="'Cluster'"/>
		<xsl:variable name="index" select="index-of($techProdRoles, current())"/>
		<xsl:variable name="nameVariable" select="concat(lower-case($nodeType), $index, 'Name')"/>
		<xsl:variable name="nodeNamingFunction" select="concat('wrap', $nodeType, 'Name')"/>
		<xsl:variable name="nodeNameString" select="eas:get_techprodrole_name(current())"/> var <xsl:value-of select="$nameVariable"/> = <xsl:value-of select="$nodeNamingFunction"/>('<xsl:value-of select="$nodeNameString"/><xsl:text>');
		</xsl:text>
	</xsl:template>
	
	<xsl:template name="RenderAppNameVariable">
		<xsl:variable name="nodeType" select="'Cluster'"/>
		<xsl:variable name="nameVariable" select="'appName'"/>
		<xsl:variable name="nodeNamingFunction" select="concat('wrap', $nodeType, 'Name')"/>
		<xsl:variable name="nodeNameString">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$appProvNode"/>
			</xsl:call-template>
		</xsl:variable>
		var <xsl:value-of select="$nameVariable"/> = <xsl:value-of select="$nodeNamingFunction"/>('<xsl:value-of select="$nodeNameString"/><xsl:text>');
		</xsl:text>
	</xsl:template>




	<xsl:template mode="RenderTPRDefinition" match="node()">
		<xsl:variable name="index" select="index-of($techProdRoles, current())"/>
		<xsl:variable name="nameVariable" select="concat('cluster', $index, 'Name')"/>
		<xsl:variable name="nodeListName" select="concat('cluster', $index)"/>
		<xsl:variable name="techProd" select="$techProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techProdSummaryLinkHref">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theInstanceID" select="$techProd/name"/>
				<xsl:with-param name="theXSL" select="$techProdSummaryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$nodeListName"/>: new joint.shapes.custom.Cluster({ position: { x: 100, y: 20 }, size: { width: <xsl:value-of select="$objectWidth"/>, height: <xsl:value-of select="$objectHeight"/> }, attrs: { rect: { 'stroke-width': <xsl:value-of select="$objectStrokeWidth"/>, fill: '<xsl:value-of select="$objectColour"/>', stroke: '<xsl:value-of select="$objectOutlineColour"/>'<!--, rx: 5, ry: 5--> }, a: { 'xlink:href': '<xsl:value-of select="$techProdSummaryLinkHref"/>', cursor: 'pointer' }, text: { text: <xsl:value-of select="$nameVariable"/>, fill: '<xsl:value-of select="$objectTextColour"/>', <xsl:value-of select="$objectFont"/> }} })<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template name="RenderAppDefinition">
		<xsl:variable name="nameVariable" select="'appName'"/>
		var app = new joint.shapes.custom.Cluster({ position: { x: 100, y: 20 }, size: { width: <xsl:value-of select="$objectWidth"/>, height: <xsl:value-of select="$appObjectHeight"/> }, attrs: { rect: { 'stroke-width': <xsl:value-of select="$appObjectStrokeWidth"/>, fill: '<xsl:value-of select="$appObjectColour"/>', stroke: '<xsl:value-of select="$appObjectOutlineColour"/>', rx: 5, ry: 5 }, a: { 'xlink:href': '#', cursor: 'pointer' }, text: { text: <xsl:value-of select="$nameVariable"/>, fill: '<xsl:value-of select="$appObjectTextColour"/>', <xsl:value-of select="$appObjectFont"/> }} });
	</xsl:template>



	<xsl:template mode="RenderTechProdRelation" match="node()">
		<xsl:variable name="currentTechProdRoleUsage" select="current()"/>
		<xsl:variable name="currentTechProdRole" select="$techProdRoles[name = $currentTechProdRoleUsage/own_slot_value[slot_reference = 'provider_as_role']/value]"/>

		<xsl:variable name="index" select="index-of($techProdRoles, $currentTechProdRole)"/>
		<xsl:variable name="sourceListName" select="concat('cluster', $index)"/>

		<xsl:variable name="relevantRelations" select="$techProdArchRelations[own_slot_value[slot_reference = ':FROM']/value = $currentTechProdRoleUsage/name]"/>
		<xsl:variable name="targetTechProdRoleUsages" select="($techProdRoleUsages except $currentTechProdRoleUsage)[name = $relevantRelations/own_slot_value[slot_reference = ':TO']/value]"/>


		<xsl:for-each select="$targetTechProdRoleUsages">
			<xsl:variable name="targetTechProdRole" select="$techProdRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
			
			<xsl:variable name="targetIndex" select="index-of($techProdRoles, $targetTechProdRole)"/>
			<xsl:variable name="targetListName" select="concat('cluster', $targetIndex)"/>
			new joint.dia.Link({ source: { id: clusters.<xsl:value-of select="$sourceListName"/>.id }, target: { id: clusters.<xsl:value-of select="$targetListName"/>.id }, attrs: { '.marker-target': { d: 'M 10 0 L 0 5 L 10 10 z' }, '.connection': {'stroke-width': 2 }, '.link-tools': { display : 'none'}, '.marker-arrowheads': { display: 'none' },'.connection-wrap': { display: 'none' }, }})<xsl:if test="not(position() = last())"><xsl:text>,
			</xsl:text></xsl:if>
		</xsl:for-each>
		<xsl:if test="(not(position() = last())) and (count($targetTechProdRoleUsages) > 0)">
			<xsl:text>,
		</xsl:text>
		</xsl:if>

	</xsl:template>
	
	<xsl:template mode="RenderAppRelation" match="node()">
		<xsl:variable name="targetTechProdRoleUsage" select="current()"/>
		<xsl:variable name="targetTechProdRole" select="$techProdRoles[name = $targetTechProdRoleUsage/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="targetIndex" select="index-of($techProdRoles, $targetTechProdRole)"/>
		<xsl:variable name="targetListName" select="concat('cluster', $targetIndex)"/>
		new joint.dia.Link({ source: { id: app.id }, target: { id: clusters.<xsl:value-of select="$targetListName"/>.id }, attrs: { '.marker-target': { d: 'M 10 0 L 0 5 L 10 10 z' }, '.connection': {'stroke-width': 2 }, '.link-tools': { display : 'none'}, '.marker-arrowheads': { display: 'none' },'.connection-wrap': { display: 'none' }, }})<xsl:if test="not(position() = last())"><xsl:text>,
			</xsl:text></xsl:if>
		<xsl:if test="(position() = last()) and (count($targetTechProdRoleUsages) > 0)">
			<xsl:text>,
		</xsl:text>
		</xsl:if>
		
	</xsl:template>



	<xsl:template mode="RenderTPRLifecycleStatus" match="node()">
		<xsl:variable name="index" select="index-of($techProdRoles, current())"/>
		<xsl:variable name="containingTPRName" select="concat('cluster', $index)"/>
		
		<xsl:variable name="thisLifecycleXPos" select="$objectSubBlockXPos"/>
		<xsl:variable name="thisLifecycleYPos" select="$objectSubBlockYPos"/>
		<xsl:variable name="thisLifecycleTitleXPos" select="$objectSubBlockTitleXPos"/>
		<xsl:variable name="thisLifecycleTitleYPos" select="$objectSubBlockTitleYPos"/>
		
		var <xsl:value-of select="$containingTPRName"/>LCTitleXpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').x + <xsl:value-of select="$thisLifecycleTitleXPos"/>;
		var <xsl:value-of select="$containingTPRName"/>LCTitleYpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').y + <xsl:value-of select="$thisLifecycleTitleYPos"/>;
		
		var <xsl:value-of select="$containingTPRName"/>LCXpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').x + <xsl:value-of select="$thisLifecycleXPos"/>;
		var <xsl:value-of select="$containingTPRName"/>LCYpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').y + <xsl:value-of select="$thisLifecycleYPos"/>;
		
		<xsl:variable name="nodeColour" select="eas:get_node_colour(current())"/>

		<xsl:variable name="nodeTextColour" select="eas:get_node_standard_text_colour(current())"/>
		<xsl:variable name="strokeColour" select="$objectOutlineColour"/>
		<xsl:variable name="techProdRoleLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
		<xsl:variable name="techProd" select="$allTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techProdLifecycleStatus" select="$allLifecycleStatii[name = $techProd/own_slot_value[slot_reference = 'technology_provider_lifecycle_status']/value]"/>
	
		
		<xsl:variable name="tprLifecycleStatusName">
			<xsl:choose>
				<xsl:when test="count($techProdRoleLifecycleStatus) > 0">
					<xsl:value-of select="$techProdRoleLifecycleStatus[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				</xsl:when>
				<xsl:when test="count($techProdLifecycleStatus) > 0">
					<xsl:value-of select="$techProdLifecycleStatus[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="eas:i18n('Undefined')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="nodetext" select="eas:get_element_style_textcolour($techProdRoleLifecycleStatus)"/> 
		<xsl:variable name="elementVarName" select="concat($containingTPRName, 'LifecycleStatus')"/>
		var <xsl:value-of select="$elementVarName"/>Title = new joint.shapes.basic.Rect({ position: { x: <xsl:value-of select="$containingTPRName"/>LCTitleXpos, y: <xsl:value-of select="$containingTPRName"/>LCTitleYpos }, size: { width: <xsl:value-of select="$objectWidth div 2"/>, height: <xsl:value-of select="$objectSubBlockTitleHeight"/> }, attrs: { rect: { stroke: '<xsl:value-of select="$strokeColour"/>', fill: 'white' }, text: { fill: 'black', text: '<xsl:value-of select="eas:i18n('Lifecycle Status')"/>', <xsl:value-of select="$objectSubBlockTitleFont"/>} } });
		clusters.<xsl:value-of select="$containingTPRName"/>.embed(<xsl:value-of select="$elementVarName"/>Title);
		var <xsl:value-of select="$elementVarName"/> = new joint.shapes.basic.Rect({ position: { x: <xsl:value-of select="$containingTPRName"/>LCXpos, y: <xsl:value-of select="$containingTPRName"/>LCYpos }, size: { width: <xsl:value-of select="$objectWidth div 2"/>, height: <xsl:value-of select="$objectSubBlockHeight"/> }, attrs: { rect: { stroke: '<xsl:value-of select="$strokeColour"/>', fill: '<xsl:value-of select="$nodeColour"/>' }, text: { fill: '<xsl:value-of select="$nodetext"/>', text: '<xsl:value-of select="$tprLifecycleStatusName"/>', <xsl:value-of select="$objectSubBlockFont"/> } } });
		clusters.<xsl:value-of select="$containingTPRName"/>.embed(<xsl:value-of select="$elementVarName"/>);
		graph.addCells([<xsl:value-of select="$elementVarName"/>, <xsl:value-of select="$elementVarName"/>Title]); <xsl:text>
						
		</xsl:text>
	</xsl:template>
	
	
	<xsl:template mode="RenderTPRStandardComplianceStatus" match="node()">
		<xsl:variable name="index" select="index-of($techProdRoles, current())"/>
		<xsl:variable name="containingTPRName" select="concat('cluster', $index)"/>
		
		<xsl:variable name="thisStandardXPos" select="$objectSubBlockTitleXPos + ($objectWidth div 2)"/>
		<xsl:variable name="thisStandardYPos" select="$objectSubBlockYPos"/>
		<xsl:variable name="thisStandardTitleXPos" select="$objectSubBlockTitleXPos + ($objectWidth div 2)"/>
		<xsl:variable name="thisStandardTitleYPos" select="$objectSubBlockTitleYPos"/>
		
		var <xsl:value-of select="$containingTPRName"/>StdTitleXpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').x + <xsl:value-of select="$thisStandardTitleXPos"/>;
		var <xsl:value-of select="$containingTPRName"/>StdTitleYpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').y + <xsl:value-of select="$thisStandardTitleYPos"/>;
		
		var <xsl:value-of select="$containingTPRName"/>StdXpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').x + <xsl:value-of select="$thisStandardXPos"/>;
		var <xsl:value-of select="$containingTPRName"/>StdYpos = clusters.<xsl:value-of select="$containingTPRName"/>.get('position').y + <xsl:value-of select="$thisStandardYPos"/>;
		
		<xsl:variable name="nodeColour" select="eas:get_node_standard_colour(current())"/> 
		<xsl:variable name="strokeColour" select="$objectOutlineColour"/>
		<xsl:variable name="techProdRoleStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = current()/name]"/>
		<xsl:variable name="techProdRoleStandardStrength" select="$allStandardStrengths[name = $techProdRoleStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>

		<xsl:variable name="nodetext" select="eas:get_element_style_textcolour($techProdRoleStandardStrength)"/> 
		<xsl:variable name="tprStandardName">
			<xsl:choose>
				<xsl:when test="count($techProdRoleStandardStrength) > 0">
					<xsl:value-of select="$techProdRoleStandardStrength[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="eas:i18n('Off Strategy')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="elementVarName" select="concat($containingTPRName, 'Standard')"/>
		var <xsl:value-of select="$elementVarName"/>Title = new joint.shapes.basic.Rect({ position: { x: <xsl:value-of select="$containingTPRName"/>StdTitleXpos, y: <xsl:value-of select="$containingTPRName"/>StdTitleYpos }, size: { width: <xsl:value-of select="$objectWidth div 2"/>, height: <xsl:value-of select="$objectSubBlockTitleHeight"/> }, attrs: { rect: { stroke: '<xsl:value-of select="$strokeColour"/>', fill: 'white' }, text: { fill: 'black', text: '<xsl:value-of select="eas:i18n('Standard Level')"/>', <xsl:value-of select="$objectSubBlockTitleFont"/>} } });
		clusters.<xsl:value-of select="$containingTPRName"/>.embed(<xsl:value-of select="$elementVarName"/>Title);
		var <xsl:value-of select="$elementVarName"/> = new joint.shapes.basic.Rect({ position: { x: <xsl:value-of select="$containingTPRName"/>StdXpos, y: <xsl:value-of select="$containingTPRName"/>StdYpos }, size: { width: <xsl:value-of select="$objectWidth div 2"/>, height: <xsl:value-of select="$objectSubBlockHeight"/> }, attrs: { rect: { stroke: '<xsl:value-of select="$strokeColour"/>', fill: '<xsl:value-of select="$nodeColour"/>' }, text: { fill: '<xsl:value-of select="$nodetext"/>', text: '<xsl:value-of select="$tprStandardName"/>', <xsl:value-of select="$objectSubBlockFont"/> } } });
		clusters.<xsl:value-of select="$containingTPRName"/>.embed(<xsl:value-of select="$elementVarName"/>);
		graph.addCells([<xsl:value-of select="$elementVarName"/>, <xsl:value-of select="$elementVarName"/>Title]); <xsl:text>
						
		</xsl:text>
	</xsl:template>



	<xsl:function as="xs:string" name="eas:get_node_colour">
		<xsl:param name="node"/>

		<xsl:variable name="techProdRoleLifecycleStatus" select="$allLifecycleStatii[name = $node/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
		<xsl:variable name="techProd" select="$allTechProds[name = $node/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techProdLifecycleStatus" select="$allLifecycleStatii[name = $techProd/own_slot_value[slot_reference = 'technology_provider_lifecycle_status']/value]"/>

		<xsl:choose>
			<xsl:when test="count($techProdRoleLifecycleStatus) > 0">
				<xsl:variable name="lifecycleStyle" select="$alllifecycleStyles[name = $techProdRoleLifecycleStatus[1]/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:choose>
					<xsl:when test="count($lifecycleStyle) = 0">
						<xsl:value-of select="$noStatusColour"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="styleColour" select="$lifecycleStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($styleColour) = 0">
								<xsl:value-of select="$noStatusColour"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$styleColour"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="count($techProdLifecycleStatus) > 0">
				<xsl:variable name="lifecycleStyle" select="$alllifecycleStyles[name = $techProdLifecycleStatus[1]/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:choose>
					<xsl:when test="count($lifecycleStyle) = 0">
						<xsl:value-of select="$noStatusColour"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="styleColour" select="$lifecycleStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($styleColour) = 0">
								<xsl:value-of select="$noStatusColour"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$styleColour"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$noStatusColour"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>
	
	
	<xsl:function as="xs:string" name="eas:get_node_standard_colour">
		<xsl:param name="node"/>
		
		
		<xsl:variable name="techProdRoleStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $node/name]"/>
		<xsl:variable name="techProdRoleStandardStrength" select="$allStandardStrengths[name = $techProdRoleStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
		
		<xsl:choose>
			<xsl:when test="count($techProdRoleStandard) > 0">
				<xsl:variable name="standardStyle" select="$allStandardStyles[name = $techProdRoleStandardStrength[1]/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:choose>
					<xsl:when test="count($standardStyle) = 0">
						<xsl:value-of select="$noStandardColour"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="styleColour" select="$standardStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($styleColour) = 0">
								<xsl:value-of select="$noStandardColour"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$styleColour"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$noStandardColour"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	<xsl:function as="xs:string" name="eas:get_node_standard_text_colour">
		<xsl:param name="node"/>
		
		
		<xsl:variable name="techProdRoleStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $node/name]"/>
		<xsl:variable name="techProdRoleStandardStrength" select="$allStandardStrengths[name = $techProdRoleStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
		
		<xsl:choose>
			<xsl:when test="count($techProdRoleStandard) > 0">
				<xsl:variable name="standardStyle" select="$allStandardStyles[name = $techProdRoleStandardStrength[1]/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:choose>
					<xsl:when test="count($standardStyle) = 0">
						<xsl:value-of select="$noStandardColour"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="styleColour" select="$standardStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($styleColour) = 0">
								<xsl:value-of select="$noStandardColour"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$styleColour"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$noStandardColour"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<xsl:function as="xs:string" name="eas:get_node_standard_label">
		<xsl:param name="node"/>
		
		
		<xsl:variable name="techProdRoleStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $node/name]"/>
		<xsl:variable name="techProdRoleStandardStrength" select="$allStandardStrengths[name = $techProdRoleStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
		
		<xsl:choose>
			<xsl:when test="count($techProdRoleStandardStrength) > 0">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$techProdRoleStandardStrength"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="eas:i18n('Off Strategy')"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>



	<xsl:function as="xs:string" name="eas:get_node_style">
		<xsl:param name="node"/>

		<xsl:variable name="techProdRoleLifecycleStatus" select="$allLifecycleStatii[name = $node/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
		<xsl:choose>
			<xsl:when test="count($techProdRoleLifecycleStatus) > 0">
				<xsl:value-of select="eas:get_element_style_class($techProdRoleLifecycleStatus)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="techProd" select="$allTechProds[name = $node/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
				<xsl:variable name="techProdLifecycleStatus" select="$allLifecycleStatii[name = $techProd/own_slot_value[slot_reference = 'technology_provider_lifecycle_status']/value]"/>
				<xsl:value-of select="eas:get_element_style_class($techProdLifecycleStatus)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<xsl:function as="xs:string" name="eas:get_node_lifecycle_label">
		<xsl:param name="node"/>
		
		<xsl:variable name="techProdRoleLifecycleStatus" select="$allLifecycleStatii[name = $node/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
		<xsl:choose>
			<xsl:when test="count($techProdRoleLifecycleStatus) > 0">
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$techProdRoleLifecycleStatus[1]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="techProd" select="$allTechProds[name = $node/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
				<xsl:variable name="techProdLifecycleStatus" select="$allLifecycleStatii[name = $techProd/own_slot_value[slot_reference = 'technology_provider_lifecycle_status']/value]"/>
				<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$techProdLifecycleStatus[1]"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>


	<xsl:function as="xs:string" name="eas:get_lifecycle_style">
		<xsl:param name="techProdRoleLifecycleStatus"/>

		<xsl:choose>
			<xsl:when test="count($techProdRoleLifecycleStatus) = 0">
				<xsl:value-of select="$noStatusStyle"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="lifecycleStyle" select="$alllifecycleStyles[name = $techProdRoleLifecycleStatus[1]/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:choose>
					<xsl:when test="count($lifecycleStyle) = 0">
						<xsl:value-of select="$noStatusStyle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="styleClass" select="$lifecycleStyle[1]/own_slot_value[slot_reference = 'element_style_class']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($styleClass) = 0">
								<xsl:value-of select="$noStatusStyle"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$styleClass"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


	<xsl:function as="xs:string" name="eas:get_techprodrole_name">
		<xsl:param name="tpr"/>

		<xsl:variable name="techProd" select="$techProds[name = $tpr/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="techComp" select="$techComps[name = $tpr/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
		<xsl:variable name="techLProdSupplier" select="$techLProdSuppliers[name = $techProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
		<xsl:value-of select="concat($techLProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $techProd/own_slot_value[slot_reference = 'name']/value, ' as ', $techComp/own_slot_value[slot_reference = 'name']/value)"/>

	</xsl:function>


	<xsl:template name="legend">
		<xsl:variable name="relevantLifecycleStatii" select="$allLifecycleStatii[name = $allTechProdRoles/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
		<div class="keyContainer">
			<div class="keySampleLabel"><xsl:value-of select="eas:i18n('Strategic Alignment Legend')"/></div>
			<xsl:for-each select="$allLifecycleStatii">
				<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
				<xsl:variable name="statusLabel" select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				<xsl:variable name="lifecycleStyle" select="$alllifecycleStyles[name = current()/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
				<xsl:variable name="statusColour">
					<xsl:choose>
						<xsl:when test="count($lifecycleStyle) = 0">
							<xsl:value-of select="$noStatusColour"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="styleColour" select="$lifecycleStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"/>
							<xsl:choose>
								<xsl:when test="string-length($styleColour) = 0">
									<xsl:value-of select="$noStatusColour"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$styleColour"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<div class="keySampleWide">
					<xsl:attribute name="style">background-color: <xsl:value-of select="$statusColour"/>;</xsl:attribute>
				</div>
				<div class="keySampleLabel">
					<xsl:value-of select="$statusLabel"/>
				</div>
			</xsl:for-each>
			<div class="keySampleWide">
				<xsl:attribute name="style">background-color: <xsl:value-of select="$noStatusColour"/>;</xsl:attribute>
			</div>
			<div class="keySampleLabel"><xsl:value-of select="eas:i18n('Undefined')"/></div>
		</div>
	</xsl:template>


	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:get_js_name_for_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="lowerCaseName" select="lower-case($dataObjectName)"/>
		<xsl:variable name="noOpenBrackets" select="translate($lowerCaseName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:value-of select="translate($noCloseBrackets, ' ', '')"/>

	</xsl:function>

	<!-- FUNCTION THAT RETURNS A LOWER CASE STRING WITHOUT ANY SPACES FOR A DATA OBJECT NAME -->
	<xsl:function as="xs:string" name="eas:no_specials_js_name_for_object">
		<xsl:param name="dataObjectName"/>

		<xsl:variable name="noOpenBrackets" select="translate($dataObjectName, '(', '')"/>
		<xsl:variable name="noCloseBrackets" select="translate($noOpenBrackets, ')', '')"/>
		<xsl:value-of select="$noCloseBrackets"/>

	</xsl:function>
	
	
	<xsl:template mode="RenderTechProdRoleTableRows" match="node()">
		<xsl:variable name="thisTechComp" select="current()"/>
		<xsl:variable name="thisTechProdRoles" select="$techProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
		
		<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
		<td class="text-center">
			<xsl:attribute name="rowspan" select="count($thisTechProdRoles)"/>
			<i>
				<xsl:attribute name="class" select="'fa fa-question-circle techProdCell'"/>
				<xsl:attribute name="techcompid" select="current()/name"/>
			</i>
			<xsl:call-template name="RenderStandardProductsForCompPopup">
				<xsl:with-param name="techComp" select="$thisTechComp"/>
			</xsl:call-template>
		</td>
		<td>
			<xsl:attribute name="rowspan" select="count($thisTechProdRoles)"/>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$thisTechComp"/>
			</xsl:call-template>
		</td>
		
		<xsl:for-each select="$thisTechProdRoles">
			<xsl:if test="not(position() = 1)">
				<xsl:text disable-output-escaping="yes">&lt;tr&gt;</xsl:text>
			</xsl:if>
			<xsl:variable name="thisTechProd" select="$techProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
			<xsl:variable name="thisTechProdSupplier" select="$techLProdSuppliers[name = $thisTechProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
			<xsl:variable name="thisTechProdName" select="concat($thisTechProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $thisTechProd/own_slot_value[slot_reference = 'name']/value)"/>
			
			<xsl:variable name="lifecycleLabel" select="eas:get_node_lifecycle_label(current())"/>
			<xsl:variable name="lifecycleStyle" select="eas:get_node_style(current())"/>

			<xsl:variable name="thisTechProdRoleLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
			<xsl:variable name="lifeNodeText" select="eas:get_element_style_textcolour($thisTechProdRoleLifecycleStatus)"/> 

			<xsl:variable name="lifeNodeStyle" select="eas:get_element_style_colour($thisTechProdRoleLifecycleStatus)"/> 
			
			<xsl:variable name="standardLabel" select="eas:get_node_standard_label(current())"/>
			<xsl:variable name="standardStyle" select="eas:get_node_standard_colour(current())"/>
			<xsl:variable name="thistechProdRoleStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = current()/name]"/>
		<xsl:variable name="techProdRoleStandardStrength" select="$allStandardStrengths[name = $thistechProdRoleStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
			<xsl:variable name="nodeText" select="eas:get_element_style_textcolour($techProdRoleStandardStrength)"/> 
			
			<td><xsl:attribute name="easid" select="$thisTechProd/name"/><xsl:attribute name="tprid" select="current()/name"/>
				<div>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
						<xsl:with-param name="displayString" select="$thisTechProdName"/>
					</xsl:call-template>
				</div>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($lifecycleLabel) > 0">
						<div class="label label-block impact {$lifecycleStyle}" style="background-color: {$lifeNodeStyle};color: {$lifeNodeText}">
							<xsl:value-of select="$lifecycleLabel"/> 
						</div>
					</xsl:when>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="string-length($standardLabel) > 0">
						<div style="background-color: {$standardStyle};color: {$nodeText}" class="label label-block impact">
							<xsl:value-of select="$standardLabel"/>
						</div>
					</xsl:when>
				</xsl:choose>
			</td>
			<xsl:text disable-output-escaping="yes">&lt;/tr&gt;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	
	
	
	<xsl:template name="RenderStandardProductsForCompPopup">
		<xsl:param name="techComp" select="()"/>
		
		<!-- Get the TPRs that have either strategic, pilot, under planning or prototype lifecycle status -->
		<xsl:variable name="techCompTPRs" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $techComp/name]"/>
		<xsl:variable name="techCompStandards" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $techCompTPRs/name]"/>
		
		
		<div class="ess-tooltip">
			<p class="fontBlack text-primary large"><xsl:value-of select="eas:i18n('Standard Technology Products')"/></p>
			<style>
				.ulTight{
					margin-bottom: 0px;
				}</style>
			<table class="table table-bordered table-striped toolt">
				<thead>
					<tr>
						<xsl:for-each select="$allStandardStrengths">
							<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
							<xsl:variable name="standardStyleClass" select="eas:get_element_style_class(current())"/>
							<th>
								<xsl:attribute name="class" select="concat('cellWidth-25pc', ' ', $standardStyleClass)"/>
								<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
							</th>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<tr>
						<xsl:for-each select="$allStandardStrengths">
							<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
							<xsl:variable name="standardsForStrength" select="$techCompStandards[own_slot_value[slot_reference = 'sm_standard_strength']/value = current()/name]"/>
							<xsl:variable name="standardTPRs" select="$techCompTPRs[name = $standardsForStrength/own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value]"/>
							<td>
								<xsl:choose>
									<xsl:when test="count($standardTPRs) > 0">
										<ul>
											<xsl:for-each select="$standardTPRs">
												<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
												<xsl:variable name="thisTechProd" select="$allTechProds[name = current()/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
												<xsl:variable name="thisTechProdSupplier" select="$techLProdSuppliers[name = $thisTechProd/own_slot_value[slot_reference = 'supplier_technology_product']/value]"/>
												<xsl:variable name="thisTechProdName" select="concat($thisTechProdSupplier/own_slot_value[slot_reference = 'name']/value, ' ', $thisTechProd/own_slot_value[slot_reference = 'name']/value)"/>
												<li>
													<xsl:call-template name="RenderInstanceLink">
														<xsl:with-param name="theSubjectInstance" select="$thisTechProd"/>
														<xsl:with-param name="displayString" select="$thisTechProdName"/>
													</xsl:call-template>
													<xsl:text> </xsl:text>
													<xsl:if test="$isEIPMode='true'">
														<button class="btn btn-xs replaceBut btn-warning" style="opacity: 1"><xsl:attribute name="easid" select="current()/name"/>Switch</button>
													</xsl:if>
												</li>
											</xsl:for-each>
										</ul>
									</xsl:when>
									<xsl:otherwise>
										<em>
											<xsl:value-of select="eas:i18n('None')"/>
										</em>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</xsl:for-each>
					</tr>
				</tbody>
			</table>
		</div>
		

		
	</xsl:template>

<xsl:template match="node()" mode="tprs">
	<xsl:variable name="thisProd" select="key('tprProdKey',current()/name)"/>
	<xsl:variable name="thisComp" select="key('tprCompKey',current()/name)"/>
    <xsl:variable name="thisTechProdRoleLifecycleStatus" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
    <xsl:variable name="lifeNodeText" select="eas:get_element_style_textcolour($thisTechProdRoleLifecycleStatus)"/> 

    <xsl:variable name="lifeNodeStyle" select="eas:get_element_style_colour($thisTechProdRoleLifecycleStatus)"/> 
{"id":"<xsl:value-of select="current()/name"/>",
"product":"<xsl:value-of select="$thisProd/name"/>",
"lifecycle_colour":"<xsl:value-of select="$lifeNodeStyle"/>",
"lifecycle_text_colour":"<xsl:value-of select="$lifeNodeText"/>",

"lifecycle":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisTechProdRoleLifecycleStatus"/></xsl:call-template>",
"productName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisProd"/></xsl:call-template>",
"component":"<xsl:value-of select="$thisComp/name"/>",
"componentName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$thisComp"/></xsl:call-template>",
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template name="GetViewerAPIPath">
			<xsl:param name="apiReport"></xsl:param>
	
			<xsl:variable name="dataSetPath">
				<xsl:call-template name="RenderAPILinkText">
					<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
	
			<xsl:value-of select="$dataSetPath"></xsl:value-of>
	
		</xsl:template>	

<xsl:template match="node()" mode="allAPUs">
            <xsl:variable name="thisFrom" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':FROM']/value)"/>
            <xsl:variable name="thisTo" select="key('allArchUsagesKey', current()/own_slot_value[slot_reference=':TO']/value)"/>
            <xsl:variable name="fromApp" select="key('allAppsforSAKey', $thisFrom/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
            <xsl:variable name="toApp" select="key('allAppsforSAKey', $thisTo/own_slot_value[slot_reference='static_usage_of_app_provider']/value)"/>
            <xsl:variable name="edgeInfo" select="key('allAppProtoInfoKey', current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value)"/>
            <xsl:variable name="edgeInfoIndirect" select="key('allAppProtoInfoKey', $edgeInfo/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value)"/>
            <xsl:variable name="allInfoEdges" select="$edgeInfo union $edgeInfoIndirect"/>
            <xsl:variable name="thisInfoReps" select="key('allInfoRepKey', $allInfoEdges/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value)"/>
            
        {
        "id":"<xsl:value-of select="current()/name"/>",
        <xsl:variable name="temp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = (':relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
        <xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
        <xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
    
        "fromtype":"<xsl:value-of select="$fromApp/type"/>",
        "totype":"<xsl:value-of select="$toApp/type"/>",
        "edgeName":"<xsl:value-of select="$fromApp/name"/> to <xsl:value-of select="$toApp/name"/>",
        "fromAppId":"<xsl:value-of select="$fromApp/name"/>",
        "toAppId":"<xsl:value-of select="$toApp/name"/>",
        <xsl:variable name="ftemp" as="map(*)" select="map{'fromApp': string(translate(translate($fromApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
        <xsl:variable name="fresult" select="serialize($ftemp, map{'method':'json', 'indent':true()})"/>  
        <xsl:value-of select="substring-before(substring-after($fresult,'{'),'}')"></xsl:value-of>,
        <xsl:variable name="ttemp" as="map(*)" select="map{'toApp': string(translate(translate($toApp/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
        <xsl:variable name="tresult" select="serialize($ttemp, map{'method':'json', 'indent':true()})"/>  
        <xsl:value-of select="substring-before(substring-after($tresult,'{'),'}')"></xsl:value-of>,
        "info":[<xsl:for-each select="$thisInfoReps">
            {
                "id":"<xsl:value-of select="current()/name"/>",
                "type":"<xsl:value-of select="current()/type"/>",
                <xsl:variable name="infoTemp" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))}"></xsl:variable>
                <xsl:variable name="infoResult" select="serialize($infoTemp, map{'method':'json', 'indent':true()})"/>  
                <xsl:value-of select="substring-before(substring-after($infoResult,'{'),'}')"></xsl:value-of>
            }<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>]
        }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
