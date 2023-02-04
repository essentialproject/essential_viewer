<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>

	<xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"/>  
    <xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>  
	<xsl:variable name="techdelivery" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/> 
    <xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
    <xsl:variable name="techlifecycle" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	<xsl:variable name="stdStrengths" select="/node()/simple_instance[type = 'Standard_Strength']"/>
	<xsl:variable name="allStatus" select="$codebase union $delivery union $lifecycle union $techlifecycle union $stdStrengths"/>
 	<xsl:variable name="language" select="/node()/simple_instance[type = 'Language']"/>  
	 <xsl:variable name="synonym" select="/node()/simple_instance[type = 'Synonym'][name=$allStatus/own_slot_value[slot_reference='synonyms']/value]"/>  
	 <xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style'][own_slot_value[slot_reference='style_for_elements']/value=$allStatus/name]"/>  
	<xsl:variable name="acquisition" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
	<xsl:variable name="environment" select="/node()/simple_instance[type = 'Deployment_Role']"/>
		<!-- END GENERIC LINK VARIABLES -->
 	<xsl:variable name="apiPathBusinessCapsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"/>
	<xsl:variable name="apiPathBusinessDomainsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Domains']"/>
	<xsl:variable name="apiPathBusinessProcessRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"/>
	<xsl:variable name="apiPathBusinessProcessFamilyRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Process Families']"/>
	<xsl:variable name="apiPathSitesRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Sites']"/>
	<xsl:variable name="apiPathOrgsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Orgs with Sites']"/>
	<xsl:variable name="apiPathAppCapsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities']"/>
	<xsl:variable name="apiPathAppSvcsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Services']"/>
	<xsl:variable name="apiPathAppCap2SvcsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities 2 Services']"/>
	<xsl:variable name="apiPathAppsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications']"/>
	<xsl:variable name="apiPathApps2SvcsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"/>
	<xsl:variable name="apiPathApps2orgsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Orgs']"/>
	<xsl:variable name="apiPathBPtoAppsSvcRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes to App Services']"/>
	<xsl:variable name="apiPathPPtoAppsViaSvcRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
	<xsl:variable name="apiPathPPtoAppsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps']"/>
	<xsl:variable name="apiPathInfoRepRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Information Representations']"/>
    <xsl:variable name="apiPathNodesRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Nodes']"/>
	<xsl:variable name="apiPathApptoServerRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application to Server']"/>
    <xsl:variable name="apiPathTechDomainsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Domains']"/>
	<xsl:variable name="apiPathTechCapReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Capabilities']"/>   
    <xsl:variable name="apiPathTechCompReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Components']"/>   
    <xsl:variable name="apiPathTechSupplierReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Suppliers']"/>   
	<xsl:variable name="apiPathTechProdReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Products']"/>   
  	<xsl:variable name="apiPathTechProdFamilyReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Product Families']"/>   
     <xsl:variable name="apiPathTechProdOrgReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Product Organisation Users']"/>   
	<xsl:variable name="apiPathDataSubjectReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Subjects']"/>   
	<xsl:variable name="apiPathDataObjectReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects']"/>   
	<xsl:variable name="apiPathDataObjectInheritReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects Inheritance']"/> 
	<xsl:variable name="apiPathDataObjectAttributesReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects Attributes']"/> 
	<xsl:variable name="apiPathDataAppDependencyReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Dependency']"/> 	
	<xsl:variable name="apiPathDataApptoTechReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"/> 	
	
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

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		
        <xsl:variable name="apiPathNodes">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathNodesRep"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathApptoServer">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathApptoServerRep"/>
            </xsl:call-template>
        </xsl:variable>
    	<xsl:variable name="apiPathTechDomains">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechDomainsRep"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathTechCap">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechCapReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathBusinessCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBusinessCapsRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathBusinessDomains">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBusinessDomainsRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathBusinessProcesses">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBusinessProcessRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathBusinessProcessFamilies">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBusinessProcessFamilyRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathSites">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathSitesRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathOrgs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathOrgsRep"/>
            </xsl:call-template>
        </xsl:variable>		
		<xsl:variable name="apiPathAppCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathAppCapsRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAppSvcs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathAppSvcsRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathAppCap2Svcs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathAppCap2SvcsRep"/>
            </xsl:call-template>
        </xsl:variable>		
		<xsl:variable name="apiPathApps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathAppsRep"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathApp2Svcs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathApps2SvcsRep"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathApp2orgs">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathApps2orgsRep"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathBPtoAppsSvc">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBPtoAppsSvcRep"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathPPtoAppsViaSvc">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathPPtoAppsViaSvcRep"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathPPtoApps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathPPtoAppsRep"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathInfoRep">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathInfoRepRep"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathTechComp">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechCompReps"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathTechSupplier">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechSupplierReps"/>
            </xsl:call-template>
        </xsl:variable>	
		<xsl:variable name="apiPathTechProd">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechProdReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathTechProdFamily">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechProdFamilyReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathTechProdOrg">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathTechProdOrgReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathDataSubject">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathDataSubjectReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathDataObject">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathDataObjectReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathDataObjectInherit">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathDataObjectInheritReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathDataObjectAttributes">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathDataObjectAttributesReps"/>
            </xsl:call-template>
        </xsl:variable>
	<xsl:variable name="apiPathDataAppDependency">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathDataAppDependencyReps"/>
            </xsl:call-template>
        </xsl:variable>
		<xsl:variable name="apiPathDataApptoTech">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathDataApptoTechReps"/>
            </xsl:call-template>
        </xsl:variable> 
		  
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/> 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Launchpad Exporter</title> 
				<script src="js/FileSaver.min.js"/>
				<style>
				.minText {font-size:0.8em;
						  vertical-align: top;
							}
				.stepsHead {font-size:0.9em;
						  	horizontal-align: center;
							background-color:#393939;
							color:#fff}	
				.playBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					border-radius: 4px;
					width: 100%;
					margin-bottom: 10px;
					position: relative;
				}
				.notesBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					width:60%;
					border-radius: 4px; 
				}
				.playTitle{
					font-weight: 700;
					font-size: 110%;
				}
				.playDescription{
					font-size: 90%;
				}
				.playDocs {
					position: absolute;
					top: 5px;
					right: 5px;
				}
				.playSteps{
					display: none;
            }
           
				.playSteps > ul {
					<!--columns: 2;-->
				}

            .additional {
               color: #32a8a8;
            }
            .additionalShow {
               color: #32a8a8;
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
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Launchpad Export</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
						<div class="col-md-6  ">
							<div class="keyTitle">Legend:</div>
							<div class="pull-left right-15"><i class="fa fa-circle right-5"/>Data not fetched</div>
							<div class="pull-left"><i class="fa fa-circle right-5" style="color:green"/>Data Available</div><br/>
						</div>
						<div class="col-md-6  ">
							<button id="genExcel" class="btn btn-sm btn-success pull-right">Generate Launchpad File</button>
						</div>
						<div class="col-md-12 bottom-15">
							<div class=" notesBlob">
                        <p>
								Check a box to load a sheet, to load the sheets that a view needs or to select elements in playbook to load the sheets for that play.<br/>  
                        <b>Note</b>: the data will load dynamically when a box is checked and the circle will go green once the data is loaded.  <br/>
                        <i class="fa fa-cloud-download additionalShow"></i> Indicates a sheet that will be required for drop downs to work in other selected sheets.
                        </p>
							</div>
						</div>
						<div class="clearfix"/>
						<div class="col-md-4">
							
							<h3 class="text-primary">Worksheets</h3>
							<ul class="list-unstyled">
								<li><i class="fa fa-circle right-5" id="bc"/><input type="checkbox" id="busCapsWorksheetCheck" easid="4" name="busCapsWorksheetCheck" value="false"/>Business Capabilities <i class="fa fa-cloud-download additional" id="busCapsi"></i></li>
								<li><i class="fa fa-circle right-5" id="bd"/><input type="checkbox" id="busDomWorksheetCheck" easid="2" name="busDomWorksheetCheck" value="false"/>Business Domains <i class="fa fa-cloud-download additional" id="busDomi"></i></li>
								<li><i class="fa fa-circle right-5" id="bp"/><input type="checkbox" id="busProcsWorksheetCheck" easid="5" name="busProcsWorksheet" value="false"/>Business Processes  <i class="fa fa-cloud-download additional" id="busProcsi"></i></li>
								<li><i class="fa fa-circle right-5" id="bpf"/><input type="checkbox" id="busProcsFamilyWorksheetCheck" easid="7" name="busProcsFamilyWorksheetCheck" value="false"/>Business Process Families</li>
								<li><i class="fa fa-circle right-5" id="st"/><input type="checkbox" id="sitesCheck" easid="7" name="sitesCheck" value="false"/>Sites  <i class="fa fa-cloud-download additional" id="sitesi"></i></li>
								<li><i class="fa fa-circle right-5" id="or"/><input type="checkbox" id="orgsCheck" easid="7" name="orgsCheck" value="false"/>Organisations  <i class="fa fa-cloud-download additional" id="orgsi"></i></li>
								<li><i class="fa fa-circle right-5" id="ors"/><input type="checkbox" id="orgs2sitesCheck" easid="7" name="orgs2sitesCheck" value="false"/>Orgs to Sites </li>
								<li><i class="fa fa-circle right-5" id="ac"/><input type="checkbox" id="appCapsCheck" easid="7" name="appCapsCheck" value="false"/>Application Capabilities  <i class="fa fa-cloud-download additional" id="appCapsi"></i></li>
								<li><i class="fa fa-circle right-5" id="as"/><input type="checkbox" id="appSvcsCheck" easid="7" name="appSvcsCheck" value="false"/>Application Services  <i class="fa fa-cloud-download additional" id="appSvcsi"></i></li>
								<li><i class="fa fa-circle right-5" id="ac2s"/><input type="checkbox" id="appCaps2SvcsCheck" easid="7" name="appCaps2SvcsCheck" value="false"/>Application Caps 2 Services</li>
								<li><i class="fa fa-circle right-5" id="aps"/><input type="checkbox" id="appsCheck" easid="7" name="appsCheck" value="false"/>Applications  <i class="fa fa-cloud-download additional" id="appsi"></i></li>
								<li><i class="fa fa-circle right-5" id="aps2sv"/><input type="checkbox" id="apps2svcsCheck" easid="7" name="apps2svcsCheck" value="false"/>Applications to Service <i class="fa fa-cloud-download additional" id="apps2svcsi"></i></li>
								<li><i class="fa fa-circle right-5" id="aps2or"/><input type="checkbox" id="apps2orgsCheck" easid="7" name="apps2orgsCheck" value="false"/>Applications to Orgs</li>
								<li><i class="fa fa-circle right-5" id="bp2srvs"/><input type="checkbox" id="busProc2SvcsCheck" easid="7" name="appsCheck" value="false"/>Bus Processes to App Services</li>
								<li><i class="fa fa-circle right-5" id="phyp2appsv"/><input type="checkbox" id="physProc2AppVsCheck" easid="7" name="physProc2AppVsCheck" value="false"/>Physical Process to Apps via Services</li>
								<li><i class="fa fa-circle right-5" id="phyp2appdirect"/><input type="checkbox" id="physProc2AppCheck" easid="7" name="physProc2AppCheck" value="false"/>Physical Process to Apps</li>
								<li><i class="fa fa-circle right-5" id="infex"/><input type="checkbox" id="infoExchangedCheck" easid="7" name="infoExchangedCheck" value="false"/>Information Exchanged  <i class="fa fa-cloud-download additional" id="infoXi"></i>
                        </li>
								<li><i class="fa fa-circle right-5" id="nodes"/><input type="checkbox" id="nodesCheck" easid="7" name="nodesCheck" value="false"/>Servers  <i class="fa fa-cloud-download additional" id="nodesi"></i></li>
								<li><i class="fa fa-circle right-5" id="ap2servs"/><input type="checkbox" id="apps2serverCheck" easid="7" name="apps2serverCheck" value="false"/>Application to Server</li>
								<li><i class="fa fa-circle right-5" id="tds"/><input type="checkbox" id="techDomsCheck" easid="7" name="techDomsCheck" value="false"/>Technology Domains  <i class="fa fa-cloud-download additional" id="techDomsi"></i></li>
								<li><i class="fa fa-circle right-5" id="tcaps"/><input type="checkbox" id="techCapsCheck" easid="7" name="techCapsCheck" value="false"/>Technology Capabilities  <i class="fa fa-cloud-download additional" id="techCapsi"></i></li>
								<li><i class="fa fa-circle right-5" id="tcomps"/><input type="checkbox" id="techCompsCheck" easid="7" name="techCompsCheck" value="false"/>Technology Components  <i class="fa fa-cloud-download additional" id="techCompsi"></i></li>
								<li><i class="fa fa-circle right-5" id="tsups"/><input type="checkbox" id="techSuppliersCheck" easid="7" name="techSuppliersCheck" value="false"/>Technology Suppliers  <i class="fa fa-cloud-download additional" id="techSuppi"></i></li>
								<li><i class="fa fa-circle right-5" id="tprods"/><input type="checkbox" id="techProductsCheck" easid="7" name="techProductsCheck" value="false"/>Technology Products  <i class="fa fa-cloud-download additional" id="techProdsi"></i></li>
								<li><i class="fa fa-circle right-5" id="tprodfams"/><input type="checkbox" id="techProductFamiliesCheck" easid="7" name="techProductFamiliesCheck" value="false"/>Technology Product Families <i class="fa fa-cloud-download additional" id="techFami"></i></li>
								<li><i class="fa fa-circle right-5" id="tprodors"/><input type="checkbox" id="techProducttoOrgsCheck" easid="7" name="techProducttoOrgsCheck" value="false"/>Technology Products to Orgs</li>
								<li><i class="fa fa-circle right-5" id="dsubjs"/><input type="checkbox" id="dataSubjectCheck" easid="7" name="dataSubjectCheck" value="false"/>Data Subjects  <i class="fa fa-cloud-download additional" id="dataSubjsi"></i></li>
								<li><i class="fa fa-circle right-5" id="dObjs"/><input type="checkbox" id="dataObjectCheck" easid="7" name="dataObjectCheck" value="false"/>Data Objects  <i class="fa fa-cloud-download additional" id="dataObjsi"></i></li>
								<li><i class="fa fa-circle right-5" id="dObjins"/><input type="checkbox" id="dataObjectInheritCheck" easid="7" name="dataObjectInheritCheck" value="false"/>Data Object Inheritance</li>
								<li><i class="fa fa-circle right-5" id="dObjAts"/><input type="checkbox" id="dataObjectAttributeCheck" easid="7" name="dataObjectAttributeCheck" value="false"/>Data Object Attributes</li>
								<li><i class="fa fa-circle right-5" id="appDps"/><input type="checkbox" id="appDependencyCheck" easid="7" name="appDependencyCheck" value="false"/>Application Dependencies</li>
								<li><i class="fa fa-circle right-5" id="apptechs"/><input type="checkbox" id="apptotechCheck" easid="7" name="apptotechCheck" value="false"/>App to Technology Products</li>
							</ul>
							<div id="testarea"/>
						</div>
						<div class="col-md-4">
							<h3 class="text-primary">Foundation Views</h3>
							<ul class="list-unstyled">
								<li><input type="checkbox" id="itasi"/>IT Asset Dashboard</li>
								<li><input type="checkbox" id="armi"/>Application Reference Model </li>
								<li><input type="checkbox" id="acsi"/>Application Capability Summary </li>
								<li><input type="checkbox" id="asumi"/>Application Summary </li>
								<li><input type="checkbox" id="afoot"/>Application Footprint Comparison </li>
								<li><input type="checkbox" id="adci"/>Application Deployment Summary</li> 
								<li><input type="checkbox" id="adai"/>Application Diversity Analysis </li>
								<li><input type="checkbox" id="ari"/>Application Radar</li>
								<li><input type="checkbox" id="adepsi"/>Application Dependency</li>
								<li><input type="checkbox" id="appcat"/>Application Catalogue</li>
								<li><input type="checkbox" id="arai"/>Application Rationalisation Analysis</li> 
								<li><input type="checkbox" id="bcmi"/>Business Capability Model</li>
								<li><input type="checkbox" id="bcsi"/>Business Capability Summary </li>
								<li><input type="checkbox" id="bctti"/>Business Capability to Technology Tree</li> 
								<li><input type="checkbox" id="bctfi"/>Business Capability to Technology Force</li> 
								<li><input type="checkbox" id="bditi"/>Business Domain IT Analysis </li>
								<li><input type="checkbox" id="bdpai"/>Business Domain Process Analysis</li>
								<li><input type="checkbox" id="busProcSumm"/>Business Process Summary</li>
								<li><input type="checkbox" id="bpfsi"/>Business Process Family Summary</li> 
								<li><input type="checkbox" id="appStratTech"/>Application Technology Strategy Alignment</li>
								<li><input type="checkbox" id="tcsi"/>Technology Component Summary </li>
								<li><input type="checkbox" id="tpsi"/>Technology Product Summary</li> 
								<li><input type="checkbox" id="tnsi"/>Technology Node Summary </li>
								<li><input type="checkbox" id="techcat"/>Technology Catalogue</li> 
								<li><input type="checkbox" id="techRef"/>Technology Reference Model</li> 
								<li><input type="checkbox" id="dci"/>Data Catalogue</li> 
								<li><input type="checkbox" id="domi"/>Data Object Model</li> 
								<li><input type="checkbox" id="dssi"/>Data Subject Summary</li> 
								<li><input type="checkbox" id="dosi"/>Data Object Summary</li>
							</ul>
						</div>
						<div class="col-md-4">
							<!--		<table>
									<thead><tr class="stepsHead" align="center"><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td></tr></thead>
									<tbody>
										<tr colspan="6"><h3 class="text-primary">Playbook</h3>
								 		Play 1 <input type="checkbox" id="play1"></input>
											<i class="fa fa-question inf"></i> </tr>
										<tr  class="minText" >
										<td width="16%">
										- Applications<br/>
										- Application Services<br/>
										- Organisations<br/>
										- App Services to Apps<br/>
										- Applications to Org Users<br/>
											<b>Optional:</b><br/>
										- Sites<br/>
										- Organisation to Sites 
										</td>
										<td width="16%">
										- Application Capabilities<br/>
										- App Services to App Capabilities<br/>
										- Sites<br/>
										- Organisation to Sites 
										</td>
										<td width="16%">
										- Business Domains<br/>
										- Business Capabilities
										</td>
										<td width="16%"> 
										- Business Process<br/>
										- Business Process Family<br/>
										- Business Process to App Services<br/>
										- Physical Process to App</td>
										<td width="16%">
										- None
										</td>
										<td width="16%">
										- Information Exchanged<br/>
										- Application Dependencies<br/>
										</td></tr>
									</tbody>
									
								</table> -->
							<h3 class="text-primary">Playbook</h3>
							<div class="bottom-15 pull-left">
								<div class="keyTitle">Legend:</div>
								<div class="pull-left right-30"><i class="fa fa-book right-5"/>Link to Playbook Website</div>
								<div class="pull-left"><i class="fa fa-caret-right right-5"/>Expand to view steps</div>
							</div>
							<div class="clearfix"/>
							<div class="playBlob">
								<div class="playTitle">Play 1</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Anchor on Applications, Bring in Business Elements</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_1.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play11"/>Step 1</li>
										<li><input type="checkbox" id="play12"/>Step 2</li>
										<li><input type="checkbox" id="play13"/>Step 3</li>
										<li><input type="checkbox" id="play14"/>Step 4</li>
										<li class="text-muted"><input type="checkbox" id="play15" disabled="disabled"/>Step 5 - Not currently in Launchpad, use Editors in Cloud/Docker</li>
										<li><input type="checkbox" id="play16"/>Step 6</li>	
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 2</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Anchor on applications, link to technology, bring in business elements</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_2.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play21"/>Step 1</li>
										<li><input type="checkbox" id="play22"/>Step 2</li>
										<li><input type="checkbox" id="play23"/>Step 3</li>
										<li><input type="checkbox" id="play24"/>Step 4</li>
										<li><input type="checkbox" id="play25"/>Step 5</li>
										<li><input type="checkbox" id="play26"/>Step 6</li>	
										<li><input type="checkbox" id="play27"/>Step 7</li>	
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 3</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Build simple governance, anchored around applications then technology</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_3.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play31"/>Step 1</li>
										<li class="text-muted"><input type="checkbox" id="play32" disabled="disabled"/>Step 2 - Not currently in Launchpad</li>
										<li class="text-muted"><input type="checkbox" id="play33" disabled="disabled"/>Step 3 - Not currently in Launchpad</li>
										<li><input type="checkbox" id="play34"/>Step 4</li>
										<li><input type="checkbox" id="play35"/>Step 5</li>
										<li><input type="checkbox" id="play36"/>Step 6</li>	
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 4</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Anchor on technology and build the architecture out from there</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_4.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play41"/>Step 1</li>
										<li><input type="checkbox" id="play42"/>Step 2</li>
										<li><input type="checkbox" id="play43"/>Step 3</li>
										<li><input type="checkbox" id="play44"/>Step 4</li>
										<li><input type="checkbox" id="play45"/>Step 5</li>
										<li><input type="checkbox" id="play46"/>Step 6</li>	
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 5</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Get Data In Shape</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_5.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play51"/>Step 1</li>
										<li class="text-muted"><input type="checkbox" id="play52" disabled="disabled"/>Step 2 - Not currently in Launchpad</li>
										<li><input type="checkbox" id="play53"/>Step 3</li>
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 6</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Bring in standards for technology, anchored around applications</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_6.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play61"/>Step 1</li>
										<li><input type="checkbox" id="play62"/>Step 2</li>
										<li><input type="checkbox" id="play63"/>Step 3</li>
										<li><input type="checkbox" id="play64"/>Step 4</li>
										<li><input type="checkbox" id="play65"/>Step 5</li>
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 7</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Map applications to projects for impact analysis</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_7.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play71"/>Step 1</li>
										<li class="text-muted"><input type="checkbox" id="play72" disabled="disabled"/>Step 2 - Use Launchpad Plus</li>
										<li class="text-muted"><input type="checkbox" id="play73" disabled="disabled"/>Step 3 - Use Launchpad Plus</li>
									</ul>
								</div>
							</div>
							<div class="playBlob">
								<div class="playTitle">Play 8</div>
								<div class="playDescription"><i class="fa fa-caret-right edit right-5"/>Create your roadmaps</div>
								<div class="playDocs"><a href="https://enterprise-architecture.org/ea_play_8.php" target="_blank"><i class="fa fa-book"/></a></div>
								<div class="playSteps">
									<ul class="list-unstyled">
										<li><input type="checkbox" id="play81"/>Step 1</li>
										<li><input type="checkbox" id="play82"/>Step 2</li>
										<li><input type="checkbox" id="play83"/>Step 3</li>
										<li><input type="checkbox" id="play84"/>Step 4</li>
										<li class="text-muted"><input type="checkbox" id="play85" disabled="disabled"/>Step 5 - Use Launchpad Plus</li>
										<li class="text-muted"><input type="checkbox" id="play86" disabled="disabled"/>Step 6 - Use Launchpad Plus</li>
									</ul>
								</div>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
<script>
	

	
	function setBox(tick,list){
 
		if (tick == false) {
				playUnselect(list)
				}
				 else {
				playSelect(list)
			}
	
	}
	
	$("#play11").on("change", function(){
	var thisList=['appcat']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play12").on("change", function(){
	var thisList=['armi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play13").on("change", function(){
	var thisList=['bcmi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play14").on("change", function(){
	var thisList=['bdpai']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play16").on("change", function(){
	var thisList=['adepsi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play21").on("change", function(){
	var thisList=['appcat']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play22").on("change", function(){
	var thisList=['armi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	$("#play23").on("change", function(){
	var thisList=['techRef']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play24").on("change", function(){
	var thisList=['techcat']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	$("#play25").on("change", function(){
	var thisList=['appcat'] //app tech prod
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play26").on("change", function(){
	var thisList=['bcmi']  //app tech strategy
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	$("#play27").on("change", function(){
	var thisList=['busProcSumm']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play31").on("change", function(){
	var thisList=['asumi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	
	$("#play35").on("change", function(){
	var thisList=['techRef']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play36").on("change", function(){
	var thisList=['tpsi']
		playSelect(thisList)
	});
	
	$("#play42").on("change", function(){
	var thisList=['techRef']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play41").on("change", function(){
	var thisList=['tpsi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
	$("#play43").on("change", function(){
	var thisList=['asumi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play44").on("change", function(){
	var thisList=['tnsi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
		
	$("#play45").on("change", function(){
	var thisList=['bcmi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
 
		
	$("#play46").on("change", function(){
	var thisList=['busProcSumm']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
 	$("#play51").on("change", function(){
	var thisList=['dosi','dssi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
	$("#play53").on("change", function(){
	var thisList=['asumi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
 
	$("#play62").on("change", function(){
	var thisList=['techRef']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
 
	});
	
	$("#play63").on("change", function(){
	var thisList=['tpsi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
 
	$("#play61").on("change", function(){
	var thisList=['asumi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
	$("#play65").on("change", function(){
	var thisList=['tpsi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
	$("#play65").on("change", function(){
	var thisList=['appStratTech']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
 
	
 
	$("#play71").on("change", function(){
	var thisList=['asumi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
	$("#play81").on("change", function(){
	var thisList=['asumi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	$("#play82").on("change", function(){
	var thisList=['tpsi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	$("#play83").on("change", function(){
	var thisList=['bcmi']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	$("#play84").on("change", function(){
	var thisList=['busProcSumm']
	var boxState = $(this).prop("checked");
	setBox(boxState,thisList)
	});
	
	function playSelect(list){
	list.forEach(function(d){
		$('#'+d).prop('checked', true )
			$('#'+d).trigger("change");
		})
	}
	
	function playUnselect(list){
	list.forEach(function(d){
		$('#'+d).prop('checked', false )
			$('#'+d).trigger("change");
		})
	}
		 	 	      
					                      
	var sheets=[{'name':'busCap','count':0, 'sheet':'busCapsWorksheetCheck'},
	{'name':'busDomain','count':0, 'sheet':'busDomWorksheetCheck'},
	{'name':'busProcess','count':0, 'sheet':'busProcsWorksheetCheck'},
	{'name':'busProcessf','count':0, 'sheet':'busProcsFamilyWorksheetCheck'},
	{'name':'site','count':0, 'sheet':'sitesCheck'}, 
	{'name':'org','count':0, 'sheet':'orgsCheck'},
	{'name':'org2site','count':0, 'sheet':'orgs2sitesCheck'},
	{'name':'appCapability','count':0, 'sheet':'appCapsCheck'},
	{'name':'appService','count':0, 'sheet':'appSvcsCheck'},
	{'name':'appCapability2service','count':0, 'sheet':'appCaps2SvcsCheck'},
	{'name':'app','count':0, 'sheet':'appsCheck'}, 
	{'name':'app2service','count':0, 'sheet':'apps2svcsCheck'},
	{'name':'app2org','count':0, 'sheet':'apps2orgsCheck'},
	{'name':'busProcess2appService','count':0, 'sheet':'busProc2SvcsCheck'},
	{'name':'pp2appService','count':0, 'sheet':'physProc2AppVsCheck'}, 
	{'name':'physicalprocess2app','count':0, 'sheet':'physProc2AppCheck'},
	{'name':'infoExchange','count':0, 'sheet':'infoExchangedCheck'},
	{'name':'serv','count':0, 'sheet':'nodesCheck'},
	{'name':'app2server','count':0, 'sheet':'apps2serverCheck'},  
	{'name':'techDoms','count':0, 'sheet':'techDomsCheck'},
	{'name':'techCaps','count':0, 'sheet':'techCapsCheck'},
	{'name':'techComp','count':0, 'sheet':'techCompsCheck'},
	{'name':'techSuppliers','count':0, 'sheet':'techSuppliersCheck'},
	{'name':'techProducts','count':0, 'sheet':'techProductsCheck'},
	{'name':'techProductsFamily','count':0, 'sheet':'techProductFamiliesCheck'},
	{'name':'techProductsOrg','count':0, 'sheet':'techProducttoOrgsCheck'},
	{'name':'dataSubject','count':0, 'sheet':'dataSubjectCheck'},
	{'name':'dataObject','count':0, 'sheet':'dataObjectCheck'},
	{'name':'dataObjecti','count':0, 'sheet':'dataObjectInheritCheck'},
	{'name':'dataObjecta','count':0, 'sheet':'dataObjectAttributeCheck'},
	{'name':'appDependency','count':0, 'sheet':'appDependencyCheck'},
	{'name':'app2techProducts','count':0, 'sheet':'apptotechCheck'}]

	
function setCounts(tick,list){
	if (tick == false) {
				reduceNumbers(list)
				}
				 else {
				increaseNumbers(list)
			}
	}	
	
	
$("#techcat").on("change", function()
	{var arr=['techComp','techProducts','techSuppliers'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
	setSheets()
	})	
	
	$("#techRef").on("change", function()
	{var arr=['techDoms', 'techCaps','techComp','techProducts','techProductsOrg','org'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	
	
	
	$("#appStratTech").on("change", function()
	{var arr=['app','techCaps', 'techProducts','techSuppliers','techComp','app2techProducts'];	
		var boxState = $(this).prop("checked");
	
		setCounts(boxState,arr);
		setSheets()
		})
	
	$("#busProcSumm").on("change", function()
	{var arr=['site','org','org2site','app','appService','app2service','act2role','act2site','busProcess','busProcess2appService','physicalprocess2app','pp2appService'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	
$("#appcat").on("change", function()
	{var arr=['app', 'appService','app2service','org','org2site','app2org','appCapability','appCapability2service','site'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})
	
$("#stpsi").on("change", function()
	{var arr=['app', 'techComp','techProducts','app2techProducts','techSuppliers', 'techDoms', 'techCaps',  'techProductsFamily', 'techProductsOrg'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})

	
	$("#arai").on("change", function()
	{var arr=['app','app2service','appService'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})
	
	$("#dosi").on("change", function()
	{var arr=['dataObjecta', 'dataObject'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})
		 
	$("#domi").on("change", function()
	{var arr=['dataObjecta', 'dataObject', 'dataObjecti'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})
	
	$("#dci").on("change", function()
	{var arr=['dataSubject', 'dataObject'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})
		
	 $("#dssi").on("change", function()
	{var arr=['dataSubject', 'dataObject'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	
	
	$("#adepsi").on("change", function()
	{var arr=['app', 'appDependency','infoExchange'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	
	$("#atsai").on("change", function()
	 {var arr=['app', 'techCaps', 'techComp','techProducts','app2techProducts','techSuppliers'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	
	$("#bpfsi").on("change", function()
		{var arr=['busCap','busProcess','busDomain', 'appService','busProcess2appService', 'app', 'app2service', 'physicalprocess2app','app2org', 'pp2appService',  'site','org','org2site','busProcessf'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
		
	$("#bdpai").on("change", function()
		{var arr=['busCap','busDomain', 'busProcess','appService','busProcess2appService', 'app', 'app2service', 'physicalprocess2app','techCaps', 'pp2appService','techComp','techProducts','app2techProducts','techSuppliers','serv','app2server'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})

	$("#tpsi").on("change", function()
		{var arr=['techComp','techCaps', 'techProducts','app2techProducts','techSuppliers','techProductsFamily','app'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	

	$("#tnsi").on("change", function()
		{var arr=['site','org','org2site','app','serv','app2server'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
	
	
	$("#tcsi").on("change", function()
	{var arr=['techCaps', 'techComp','techProducts'];	
	var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
		setSheets()
		})


$("#ahci").on("change", function()
	{var arr=['site','org','org2site','app','serv','app2server'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		})
		
$("#ari").on("change", function()
	{var arr=['busCap','busProcess','appService','busProcess2appService', 'app', 'app2service', 'physicalprocess2app', 'pp2appService'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		}) 
	
	
$("#adai").on("change", function()
	{var arr=['appCapability','appService','appCapability2service','app','app2service','serv', 'app2server', 'techCaps', 'techComp', 'techProducts', 'techSuppliers',  'app2techProducts'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		}) 
	
$("#adci").on("change", function()
	{var arr=['site','org','org2site','app','serv','app2server'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		}) 


	$("#bditi").on("change", function()
	{var arr=['busCap','busProcess','busDomain','appService','appCapability','appCapability2service','app','app2service','serv','busProcess2appService','app2server','app2techProducts','pp2appService','physicalprocess2app','techSuppliers','techCaps', 'techComp','techProducts'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		}) 	


	$("#asumi").on("change", function()
	{var arr=['busProcess','appService','app','app2service','serv','busProcess2appService','app2server','app2techProducts','techSuppliers','techCaps', 'techComp','techProducts','org','app2org','pp2appService','physicalprocess2app','techProductsOrg','techProductsFamily'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		}) 	
		
	$("#armi").on("change", function()
	{var arr=['appService','appCapability2service','app','app2service','appCapability'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()
		}) 

		$("#acsi").on("change", function()
		{var arr=['appService','appCapability2service','appCapability'];	
			var boxState = $(this).prop("checked");
		setCounts(boxState,arr);	
		setSheets()
		}) 
	
	$("#afoot").on("change", function()
		{var arr=['busCap','busProcess','appService','appCapability2service','app','app2service','busProcess2appService','appCapability','physicalprocess2app','pp2appService'];	
			var boxState = $(this).prop("checked");
			setCounts(boxState,arr);
		setSheets()
		}) 
			  			 
		         		   		 	  
$("#bctfi").on("change", function()
	{var arr=['busDomain','busCap','busProcess','appService','appCapability2service','app','app2service','busProcess2appService','serv','serv','pp2appService','physicalprocess2app','app2server'];	
			var boxState = $(this).prop("checked");
			setCounts(boxState,arr);
		setSheets()
		})
		 
	$("#bctti").on("change", function()
		{var arr=['busDomain','busCap','busProcess','appService','appCapability2service','app','app2service','app2server','pp2appService','busProcess2appService','serv','busProcess2appService','physicalprocess2app'];	
			var boxState = $(this).prop("checked");
			setCounts(boxState,arr);
		setSheets()
		})
		
	$("#bcsi").on("change", function()
		{var arr=['busDomain','busCap','busProcess','appService','appCapability2service','app','app2service','pp2appService','physicalprocess2app','busProcess2appService'];	
			var boxState = $(this).prop("checked");
	setCounts(boxState,arr);
	setSheets()
	})
	
	$("#itasi").on("change", function()
		{var arr=['busDomain','busCap','busProcess','org','org2site','appCapability','appService','app2service','app','appCapability2service','app2org','busProcess2appService','techDoms','techCaps','techComp','techProducts','techProductsOrg'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets()

		})

	
function reduceNumbers(focussheet){
			focussheet.forEach(function(v){
					sheets.forEach(function(d){
						if(d.name==v){
							if(d.count&gt;0){
							d.count=d.count-1;
							}
						}
					});
			  	})
	}	

function increaseNumbers(focussheet){
			focussheet.forEach(function(v){
					sheets.forEach(function(d){
						if(d.name==v){
							d.count=d.count+1;
						}
					});
			  	})
	}
	
function setSheets(){
	sheets.forEach(function(d){
		sheetName=d.sheet;
		if(d.count &gt;0){
			$('#'+sheetName).prop('checked', true )
			$('#'+sheetName).trigger("change");
			}
		else{
			$('#'+sheetName).prop('checked', false )
			$('#'+sheetName).trigger("change");
			}
		})
	}	
	
	$("#bcmi").on("change", function()
	{var arr=['busDomain','busCap'];	
		var boxState = $(this).prop("checked");
		setCounts(boxState,arr);
		setSheets();
	})
	
		
</script>				
<script>


	var worksheetList=[];
 	var ExcelArray=[];		
	
	statusSet={"codebase":[<xsl:apply-templates select="$codebase" mode="status"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		   "delivery":[<xsl:apply-templates select="$delivery" mode="status"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		   "techdelivery":[<xsl:apply-templates select="$techdelivery" mode="status"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		   "lifecycle":[<xsl:apply-templates select="$lifecycle" mode="status"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>], 
		   "techlifecycle":[<xsl:apply-templates select="$techlifecycle" mode="status"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		   "standard_strength":[<xsl:apply-templates select="$stdStrengths" mode="standard"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
		   "acquisition":[<xsl:apply-templates select="$acquisition" mode="acquisition"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>],
			"environment":[<xsl:apply-templates select="$environment" mode="acquisition"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>]}	
<!--	var platforms={"platforms":[<xsl:apply-templates select="$platform" mode="platform"/>]};				
	var managedService={"managedService":[<xsl:apply-templates select="$managedService" mode="managedService"/>]}; -->
		 
    $('document').ready(function () {
      $('.additional').hide();
	 	$('.edit').click(function(){
		$(this).parent().parent().find('.playSteps').slideToggle();
		$(this).toggleClass('fa-caret-right');
		$(this).toggleClass('fa-caret-down');
  });
 
	 
	var testcaptableFragment   = $("#table-name").html();
		testcaptableTemplate = Handlebars.compile(testcaptableFragment);
	
	var sitetableFragment   = $("#sites-name").html();
		sitetableTemplate = Handlebars.compile(sitetableFragment);
	
	var buscaptableFragment   = $("#captable-name").html();
		buscaptableTemplate = Handlebars.compile(buscaptableFragment);
	
	var busdomtableFragment   = $("#domtable-name").html();
		busdomtableTemplate = Handlebars.compile(busdomtableFragment);		
	
	var busprocesstableFragment   = $("#processtable-name").html();
		busprocesstableTemplate = Handlebars.compile(busprocesstableFragment);	
	
	var busprocessfamilytableFragment   = $("#processfamilytable-name").html();
		busprocessfamilytableTemplate = Handlebars.compile(busprocessfamilytableFragment);
	
	var orgtableFragment   = $("#orgs-name").html();
		orgtableTemplate = Handlebars.compile(orgtableFragment);

		
	var orgsitetableFragment   = $("#orgsite-name").html();
		orgsitetableTemplate = Handlebars.compile(orgsitetableFragment);
	
	var appCaptableFragment   = $("#appcap-name").html();
		appCaptableTemplate = Handlebars.compile(appCaptableFragment);
	
	var appSvctableFragment   = $("#appsvc-name").html();
		appSvctableTemplate = Handlebars.compile(appSvctableFragment);
	
	var appCap2SvctableFragment   = $("#appcapsvc-name").html();
		appCap2SvctableTemplate = Handlebars.compile(appCap2SvctableFragment);
	
	var appstableFragment   = $("#apps-name").html();
		appstableTemplate = Handlebars.compile(appstableFragment);
	
	var app2svcstableFragment   = $("#app2svc-name").html();
		apps2svcstableTemplate = Handlebars.compile(app2svcstableFragment);
	
	var app2orgstableFragment   = $("#app2org-name").html();
		apps2orgtableTemplate = Handlebars.compile(app2orgstableFragment);

	var pp2apptableFragment   = $("#pp2app-name").html();
		pp2apptableTemplate = Handlebars.compile(pp2apptableFragment);

	var pp2appviasvctableFragment   = $("#pp2appviasvc-name").html();
		pp2appviasvctableTemplate = Handlebars.compile(pp2appviasvctableFragment);

	var bp2appsvctableFragment   = $("#bp2appsvc-name").html();
		bp2appsvctableTemplate = Handlebars.compile(bp2appsvctableFragment);	
   
	var infoReptableFragment   = $("#inforeps-name").html();
		infoReptableTemplate = Handlebars.compile(infoReptableFragment);	
   
	var serverstableFragment   = $("#servers-name").html();
		serverstableTemplate = Handlebars.compile(serverstableFragment);		
	
 	var app2servertableFragment   = $("#app2server-name").html();
		app2servertableTemplate = Handlebars.compile(app2servertableFragment);	

	var techdomstableFragment   = $("#techdoms-name").html();
		techdomstableTemplate = Handlebars.compile(techdomstableFragment);	
    
	var techcapstableFragment   = $("#techcaps-name").html();
		techcapstableTemplate = Handlebars.compile(techcapstableFragment);	

    var techcompstableFragment   = $("#techcomps-name").html();
		techcompstableTemplate = Handlebars.compile(techcompstableFragment);	
    
    var techproductstableFragment   = $("#techprods-name").html();
		techproductstableTemplate = Handlebars.compile(techproductstableFragment);   
 
    var techsuppliertableFragment   = $("#techsuppliers-name").html();
		techsuppliertableTemplate = Handlebars.compile(techsuppliertableFragment);   
	
	var techproductfamilytableFragment   = $("#techprodfamily-name").html();
		techproductfamilytableTemplate = Handlebars.compile(techproductfamilytableFragment);  
	
	var techproductorgtableFragment   = $("#techprodorg-name").html();
		techproductorgtableTemplate = Handlebars.compile(techproductorgtableFragment); 
	
	var dataSubjecttableFragment   = $("#datasubject-name").html();
		dataSubjecttableTemplate = Handlebars.compile(dataSubjecttableFragment); 
	
	var dataObjecttableFragment   = $("#dataobject-name").html();
		dataObjecttableTemplate = Handlebars.compile(dataObjecttableFragment); 
	
	var dataObjectinheritFragment   = $("#dataobjectinherit-name").html();
		dataObjectinheritTemplate = Handlebars.compile(dataObjectinheritFragment); 	

	var dataObjectattributeFragment   = $("#dataobjectattribute-name").html();
		dataObjectattributeTemplate = Handlebars.compile(dataObjectattributeFragment); 	
	
	var appDependencyFragment   = $("#appdependency-name").html();
		appDependencyTemplate = Handlebars.compile(appDependencyFragment); 
	
	var appToTechFragment   = $("#apptotechprod-name").html();
		appToTechTemplate = Handlebars.compile(appToTechFragment); 

	var statusFragment   = $("#statuspages-name").html();
		statusTemplate = Handlebars.compile(statusFragment); 	

    Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) { 
    return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
    });
    
	Handlebars.registerHelper('greaterThan', function (v1, v2, options) {
	'use strict';
	   if (v1>v2) {
		 return options.fn(this);
	  }
	  return options.inverse(this);
	});
	
	$('#genExcel').click(function(){
	var xmlhead, xmlfoot;
	getXML('integration/launchpad_head.xml').then(function(response){
		xmlhead=response;	

		}).then(function(response){ 
 
		var LaunchpadJSON=[];
		ExcelArray=[];
	var worksheetText='';
	
	data = worksheetList.filter((obj, pos, arr) => {
            return arr.map(mapObj =>
                  mapObj.id).indexOf(obj.id) == pos;
            });
          //console.log(data);
	
	
	
	
	data.sort(function(a, b) { 
	  return a.id - b.id 
	});
	data.forEach(function(d){
	//console.log(d);
		worksheetText=worksheetText+d.name;
	})
//console.log(statusSet)
	//dataObjectinheritTemplate(dataObjectInheritance.data_object_inherit)
	ExcelString=xmlhead+statusTemplate(statusSet)+worksheetText+'&lt;/Workbook>';
	//ExcelString=xmlhead+worksheetText+'&lt;/Workbook>';
		ExcelArray.push(ExcelString)
 
	var blob = new Blob([ExcelArray[0]], {type: "text/xml"});
	saveAs(blob, "launchpad_export.xml");
	
 ////console.log(ExcelArray[0])
	  		});
		});
	});
	
var getXML = function promise_getExcelXML(excelXML_URL) {
    return new Promise(
    function (resolve, reject) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 &amp;&amp; this.status == 200) {
                ////console.log(prefixString);
                resolve(this.responseText);
            }
        };
        xmlhttp.onerror = function () {
            reject(false);
        };
        xmlhttp.open("GET", excelXML_URL, true);
        xmlhttp.send();
    });
};
</script>
<script  id="statuspages-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Application Codebases">
	 <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Application Codebases</Data></Cell>
   </Row>	 
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
	<Cell ss:StyleID="s1131"><Data ss:Type="String">Label</Data></Cell>   
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	{{#each this.codebase}}
	   {{#if this.synonyms}}
	 	{{#each this.synonyms}}    
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.label}}</Data></Cell>   
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.translation}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.language}}</Data></Cell>
   </Row>
	  {{/each}}	
 		{{else}}
	  <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.label}}</Data></Cell>  	  
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
   </Row>
	  {{/if}}
	  {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions> 
 </Worksheet>
 <Worksheet ss:Name="Application Delivery Models">
<Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Application Delivery Models</Data></Cell>
   </Row>	 
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
	<Cell ss:StyleID="s1131"><Data ss:Type="String">Label</Data></Cell>   
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	{{#each this.delivery}}
	   {{#if this.synonyms}}
	 	{{#each this.synonyms}}    
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.label}}</Data></Cell>   
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.translation}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.language}}</Data></Cell>
   </Row>
	  {{/each}}	
 		{{else}}
	  <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.label}}</Data></Cell>  	  
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
   </Row>
	  {{/if}}
	  {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions> 
 </Worksheet>
 <Worksheet ss:Name="Technology Delivery Models">
<Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Technology Delivery Models</Data></Cell>
   </Row>	 
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
	<Cell ss:StyleID="s1131"><Data ss:Type="String">Label</Data></Cell>   
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	{{#each this.techdelivery}}
	   {{#if this.synonyms}}
	 	{{#each this.synonyms}}    
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.label}}</Data></Cell>   
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.translation}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.language}}</Data></Cell>
   </Row>
	  {{/each}}	
 		{{else}}
	  <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.label}}</Data></Cell>  	  
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
   </Row>
	  {{/if}}
	  {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions> 
 </Worksheet>
 <Worksheet ss:Name="Tech Vendor Release Statii">
<Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Technology Vendor Release Statii</Data></Cell>
   </Row>	 
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
	<Cell ss:StyleID="s1131"><Data ss:Type="String">Label</Data></Cell>   
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	{{#each this.techlifecycle}}
	   {{#if this.synonyms}}
	 	{{#each this.synonyms}}    
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.label}}</Data></Cell>   
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.translation}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.language}}</Data></Cell>
   </Row>
	  {{/each}}	
 		{{else}}
	  <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.label}}</Data></Cell>  	  
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
   </Row>
	  {{/if}}
	  {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions> 
 </Worksheet>
 <Worksheet ss:Name="Standards Compliance Levels">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Standards Compliance Levels'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="11" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Standards Compliance Levels</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
{{#each this.standard_strength}}	
	 {{#if this.synonyms}}
	 	{{#each this.synonyms}}    
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.description}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.score}}</Data></Cell>
	<Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.translation}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.language}}</Data></Cell>
   </Row>
	{{/each}}
	  {{else}}
	   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.description}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.score}}</Data></Cell>
	<Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
   </Row>
	 {{/if}}
	  {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>4</TopRowVisible>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>	
 <Worksheet ss:Name="Lifecycle Status">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Lifecycle Status</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
	<Cell ss:StyleID="s1131"><Data ss:Type="String">Label</Data></Cell>   
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	{{#each this.lifecycle}}
	   {{#if this.synonyms}}
	 	{{#each this.synonyms}}    
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.label}}</Data></Cell>   
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{../this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{../this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.translation}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String">{{this.language}}</Data></Cell>
   </Row>
	  {{/each}}	
	  {{else}}
	  <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.description}}</Data></Cell>
	<Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.label}}</Data></Cell>  	  
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.seqNo}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.colour}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">{{this.class}}</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">{{this.score}}</Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
   </Row>
	  {{/if}}
	  {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
<Worksheet ss:Name="References">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">References</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:Height="12">
    <Cell ss:Index="2" ss:StyleID="s1110"><Data ss:Type="String">Boolean</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">Acquisition</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>   
    <Cell ss:StyleID="s1110"><Data ss:Type="String">  </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	 <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">True</Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>      
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>     
	  </Row>
	 <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">False</Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>      
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>     
	  </Row>  
	{{#each this.acquisition}}
	
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String">{{this.label}}</Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>      
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>     
	  </Row>
	  {{/each}}	
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
	<Visible>SheetHidden</Visible>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R24C11</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>
<Worksheet ss:Name="Environment">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="231"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>	  
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">References</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Environment</Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String">  </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
	{{#each this.environment}}
	
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">{{this.label}}</Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>      
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
    <Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>   
	<Cell ss:StyleID="s1056"><Data ss:Type="String"></Data></Cell>     
	  </Row>
	  {{/each}}	
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R24C11</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>
<Worksheet ss:Name="Countries">
  <Table ss:ExpandedColumnCount="2" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Row ss:Index="7" ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Countries</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Afghanistan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Albania</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Algeria</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Angola</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Antarctica</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Antigua and Barbuda</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Argentina</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Armenia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Australia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Austria</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Azerbaijan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Bahamas</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Bangladesh</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Barbados</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Belarus</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Belgium</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Belize</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Benin</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Bhutan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Bolivia</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Bosnia and Herzegovina</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Botswana</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Brazil</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Brunei Darussalam</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Bulgaria</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Burkina Faso</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Burma</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Burundi</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Cambodia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Cameroon</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Canada</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Cape Verde</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Central African Republic</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Chad</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Chile</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">China</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Colombia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Comoros</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Congo</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Costa Rica</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Cote d'Ivoire</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Croatia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Cuba</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Cyprus</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Czech Republic</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Democratic Republic of the Congo</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Denmark</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Djibouti</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Dominica</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Dominican Republic</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Ecuador</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Egypt</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">El Salvador</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Equatorial Guinea</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Eritrea</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Estonia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Ethiopia</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Falkland Islands</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Fiji</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Finland</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">France</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">French Guiana</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Gabon</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Gambia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Georgia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Germany</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Ghana</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Greece</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Grenada</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Guadeloupe</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Guatemala</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Guinea-Bissau</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Guyana</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Haiti</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Honduras</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Hungary</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Iceland</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">India</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Indonesia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Iran</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Iraq</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Ireland</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Israel</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Italy</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Jamaica</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Japan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Jordan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Kazakhstan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Kenya</Data></Cell>
   </Row>
   <Row ss:Height="68">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Korea, Democratic People's Republic of</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Korea, Republic of</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Kuwait</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Kyrgyzstan</Data></Cell>
   </Row>
   <Row ss:Height="68">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Lao People's Democratic Republic</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Latvia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Lebanon</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Lesotho</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Liberia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Libya</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Lithuania</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Luxembourg</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Macedonia</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Madagascar</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Malawi</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Malaysia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Mali</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Martinique</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Mauritania</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Mauritius</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Mexico</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Mongolia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Morocco</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Mozambique</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Namibia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Nepal</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Netherlands</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">New Caledonia</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">New Zealand</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Nicaragua</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Nigeria</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Norway</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Oman</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Pakistan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Palau</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Panama</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Papua New Guinea</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Paraguay</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Peru</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Philippines</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Poland</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Portugal</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Puerto Rico</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Qatar</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Republic of Moldova</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Reunion</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Romania</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Russia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Rwanda</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Sao Tome and Principe</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Saudi Arabia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Senegal</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Serbia</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Sierra Leone</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Singapore</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Slovakia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Slovenia</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Solomon Islands</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Somalia</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">South Africa</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Spain</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Sri Lanka</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">St. Kitts and Nevis</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">St. Lucia</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">St. Vincent and the Grenadines</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Sudan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Suriname</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Swaziland</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Sweden</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Switzerland</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Syria</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Taiwan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Tajikistan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Thailand</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Timor-Leste</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Togo</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Trinidad and Tobago</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Tunisia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Turkey</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Turkmenistan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Uganda</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Ukraine</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">United Arab Emirates</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">United Kingdom</Data></Cell>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">United Republic of Tanzania</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">United States</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Uruguay</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Uzbekistan</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Vanuatu</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Venezuela</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Vietnam</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">West Bank</Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Western Sahara</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Yemen</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Zambia</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1056"><Data ss:Type="String">Zimbabwe</Data></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
	  <Visible>SheetHidden</Visible>
   <TabColorIndex>54</TabColorIndex>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>6</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>	
</script>				
<script id="apptotechprod-name" type="text/x-handlebars-template">
	 <Worksheet ss:Name="App to Tech Products">
      <Table ss:ExpandedColumnCount="13"
             x:FullColumns="1"
             x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="179"/>
         <Column ss:AutoFitWidth="0" ss:Width="146"/>
         <Column ss:AutoFitWidth="0" ss:Width="207"/>
         <Column ss:AutoFitWidth="0" ss:Width="197"/>
         <Column ss:AutoFitWidth="0" ss:Width="177"/>
         <Column ss:AutoFitWidth="0" ss:Width="181"/>
         <Column ss:AutoFitWidth="0" ss:Width="139" ss:Span="2"/>
         <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="156"/>
         <Column ss:AutoFitWidth="0" ss:Width="139"/>
         <Column ss:AutoFitWidth="0" ss:Width="143"/>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1086"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1266"/>
            <Cell ss:MergeAcross="2" ss:StyleID="s1299">
               <Data ss:Type="String">Application Technology Architecture</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1126">
               <Data ss:Type="String">Defines the technology architecture supporting applications in terms of Technology Products, the components that they implement and the dependencies between them</Data>
            </Cell>
            <Cell ss:StyleID="s1126"/>
            <Cell ss:StyleID="s1126"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1086"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1086"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1087">
               <Data ss:Type="String">Application</Data>
            </Cell>
            <Cell ss:StyleID="s1088">
               <Data ss:Type="String">Environment</Data>
            </Cell>
            <Cell ss:StyleID="s1089">
               <Data ss:Type="String">From Technology Product</Data>
            </Cell>
            <Cell ss:StyleID="s1089">
               <Data ss:Type="String">From Technology Component</Data>
            </Cell>
            <Cell ss:StyleID="s1089">
               <Data ss:Type="String">To Technology Product</Data>
            </Cell>
            <Cell ss:StyleID="s1089">
               <Data ss:Type="String">To Technology Component</Data>
            </Cell>
            <Cell ss:StyleID="s1195">
               <Data ss:Type="String">Check Application</Data>
            </Cell>
            <Cell ss:StyleID="s1195">
               <Data ss:Type="String">Check Environment</Data>
            </Cell>
            <Cell ss:StyleID="s1195">
               <Data ss:Type="String">Check From Tech Product</Data>
            </Cell>
            <Cell ss:StyleID="s1195">
               <Data ss:Type="String">Check From Tech Component</Data>
            </Cell>
            <Cell ss:StyleID="s1195">
               <Data ss:Type="String">Check To Tech Product</Data>
            </Cell>
            <Cell ss:StyleID="s1195">
               <Data ss:Type="String">Check To Tech Component</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="7">
            <Cell ss:Index="2">
               <Data ss:Type="String">.</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">.</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">.</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">.</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">.</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">.</Data>
            </Cell>
         </Row>
		 {{#each this}}
		  	{{#if this.supportingTech}}
               {{#each this.supportingTech}}
                  {{#if @last}}
                  {{else}}
         <Row ss:Height="17">
			 <Cell ss:Index="2" ss:StyleID="s1090"><Data ss:Type="String">{{../this.application}}</Data></Cell>
			 <Cell ss:StyleID="s1091"><Data ss:Type="String">{{this.environment}}</Data></Cell>
			 <Cell ss:StyleID="s1063"><Data ss:Type="String">{{this.fromTechProduct}}</Data></Cell>
			 <Cell ss:StyleID="s1063"><Data ss:Type="String">{{this.fromTechComponent}}</Data></Cell>
			 <Cell ss:StyleID="s1063"><Data ss:Type="String">{{this.toTechProduct}}</Data></Cell>
			 <Cell ss:StyleID="s1063"><Data ss:Type="String">{{this.toTechComponent}}</Data></Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&#34;Application must be already defined in Applications sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Environment!C[-7],1,0)),&quot;Environment must be already defined in Environment sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&#34;Technology Product must be already defined in Technology Products sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&#34;Technology Product must be already defined in Technology Products sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
         {{/if}}
		  {{/each}}
	  {{/if}}
	{{/each}}
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>6</ActiveRow>
               <ActiveCol>7</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R35C3</Range>
         <Type>List</Type>
         <Value>Valid_Environments</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R3500C2</Range>
         <Type>List</Type>
         <Value>'Applications'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R3500C4,R8C6:R3500C6</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Technology Products'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R3500C5,R8C7:R3500C7</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Technology Components'!R8C3:R5000C3</Value>
      </DataValidation>
	   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R3500C3</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Environment'!R8C2:R5000C2</Value>
      </DataValidation>	 
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R35C13</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
</script> 				
<script id="appdependency-name" type="text/x-handlebars-template">	
  <Worksheet ss:Name="Application Dependencies">
      <Table ss:ExpandedColumnCount="10"
             x:FullColumns="1"
             x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="21"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="230"/>
         <Column ss:AutoFitWidth="0" ss:Width="163"/>
         <Column ss:AutoFitWidth="0" ss:Width="196"/>
         <Column ss:AutoFitWidth="0" ss:Width="135"/>
         <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="159"/>
         <Column ss:AutoFitWidth="0" ss:Width="104"/>
         <Column ss:AutoFitWidth="0" ss:Width="93"/>
         <Row>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1269">
               <Data ss:Type="String">Application Dependencies</Data>
            </Cell>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234">
               <Data ss:Type="String">Captures the information dependencies between applications; where information passes between applications and the method for passing the information</Data>
            </Cell>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
         </Row>
         <Row ss:Height="17">
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:Index="8">
               <Data ss:Type="String">Checks</Data>
            </Cell>
         </Row>
         <Row ss:Height="20">
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1241">
               <Data ss:Type="String">Source Application</Data>
            </Cell>
            <Cell ss:StyleID="s1242">
               <Data ss:Type="String">Target Application</Data>
            </Cell>
            <Cell ss:StyleID="s1242">
               <Data ss:Type="String">Information Exchanged</Data>
            </Cell>
            <Cell ss:StyleID="s1241">
               <Data ss:Type="String">Acquisition Method</Data>
            </Cell>
            <Cell ss:StyleID="s1243">
               <Data ss:Type="String">Frequency</Data>
            </Cell>
            <Cell ss:Index="8" ss:StyleID="s1167">
               <Data ss:Type="String">Source Check</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Target Check</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Info Exchanged</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8">
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1240"/>
            <Cell ss:StyleID="s1235"/>
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1143"/>
            <Cell ss:Index="8" ss:StyleID="s1247"/>
            <Cell ss:StyleID="s1247"/>
            <Cell ss:StyleID="s1247"/>
         </Row>
		  {{#each this}}
		  	{{#if this.info}}
		  		{{#each this.info}}
         <Row ss:Height="17">
			  <Cell ss:StyleID="s1234"/>
			 <Cell ss:StyleID="s1234"><Data ss:Type="String">{{../this.source}}</Data></Cell>
			 <Cell ss:StyleID="s1215"><Data ss:Type="String">{{../this.target}}</Data></Cell>
            <Cell ss:StyleID="s1215"><Data ss:Type="String">{{this.name}}</Data></Cell>
			 
            <Cell ss:StyleID="s1143"><Data ss:Type="String">{{../this.acquisition}}</Data></Cell>
			 <Cell ss:StyleID="s1236"><Data ss:Type="String">{{../this.frequency.0.name}}</Data></Cell>
            <Cell ss:StyleID="s1063"/>
			 
            <Cell ss:Index="8"
                  ss:StyleID="s1248" ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1248"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-6],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1248"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Information Exchanged'!C[-7],1,0)),&quot;Information must be already defined in Information Exchanged sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  		{{/each}}
		  	{{else}}
		       <Row ss:Height="17">
				       <Cell ss:StyleID="s1234"/>
				   <Cell ss:StyleID="s1234"><Data ss:Type="String">{{this.source}}</Data></Cell>
				   <Cell ss:StyleID="s1215"><Data ss:Type="String">{{this.target}}</Data></Cell>
            <Cell ss:StyleID="s1215"></Cell>
				   <Cell ss:StyleID="s1143"><Data ss:Type="String">{{this.acquisition}}</Data></Cell>
				   <Cell ss:StyleID="s1236"><Data ss:Type="String">{{this.frequency.0.name}}</Data></Cell>
				   
            <Cell ss:StyleID="s1063"/>
            
            <Cell ss:Index="8"
                  ss:StyleID="s1248" ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1248"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-6],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1248"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Information Exchanged'!C[-7],1,0)),&quot;Information must be already defined in Information Exchanged sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  	{{/if}}
		  {{/each}}
         <Row ss:Height="17">
            <Cell ss:StyleID="s1234"/>
            <Cell ss:StyleID="s1215"/>
            <Cell ss:StyleID="s1215"/>
            <Cell ss:StyleID="s1236"/>
            <Cell ss:StyleID="s1143"/>
            <Cell ss:StyleID="s1063"/>
             
            <Cell ss:Index="8"
                  ss:StyleID="s1248" ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1248"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-6],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1248"
                  ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Information Exchanged'!C[-7],1,0)),&quot;Information must be already defined in Information Exchanged sheet&quot;,&quot;OK&quot;)),&quot;&quot;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  
      
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>4</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R10000C2,R8C3:R100000C3</Range>
         <Type>List</Type>
         <Value>'Applications'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R18C5</Range>
         <Type>List</Type>
         <Value>Valid_Data_acquisition_Methods</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R10000C4</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Information Exchanged'!R8C3:R1000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R7C6:R4000C6</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>"Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time"</Value>
      </DataValidation>
	  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	   <Range>R8C5:R4000C5</Range>
	   <Type>List</Type>
	   <Value>References!R10C3:R22C3</Value>
	  </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C8:R6C9</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R19C10</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C10</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C10:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>				
</script>				
<script id="dataobjectattribute-name" type="text/x-handlebars-template">
  <Worksheet ss:Name="Data Object Attributes">
      <Table ss:ExpandedColumnCount="17"
             x:FullColumns="1"
             x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="18"/>
         <Column ss:AutoFitWidth="0" ss:Width="57"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="218" ss:Span="2"/>
         <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="200" ss:Span="1"/>
         <Column ss:Index="9"
                 ss:StyleID="s1057"
                 ss:AutoFitWidth="0"
                 ss:Width="143"/>
         <Column ss:AutoFitWidth="0" ss:Width="112"/>
         <Column ss:Index="12" ss:AutoFitWidth="0" ss:Width="123"/>
         <Column ss:AutoFitWidth="0" ss:Width="115"/>
         <Column ss:AutoFitWidth="0" ss:Width="181"/>
         <Column ss:Index="16" ss:Hidden="1" ss:AutoFitWidth="0" ss:Span="1"/>
         <Row ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="35">
            <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1271">
               <Data ss:Type="String">Data Attributes</Data>
            </Cell>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1302">
               <Data ss:Type="String">Captures the data object Attributes used within the organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="17">
            <Cell ss:Index="8" ss:MergeAcross="1" ss:StyleID="s1305">
               <Data ss:Type="String">One of these per row, not both in one row</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="21">
            <Cell ss:Index="4" ss:MergeAcross="6" ss:StyleID="s1303">
               <Data ss:Type="String">Data Attribute Details</Data>
            </Cell>
            <Cell ss:Index="12" ss:StyleID="s1263">
               <Data ss:Type="String">Checks</Data>
            </Cell>
            <Cell ss:StyleID="s1263"/>
            <Cell ss:StyleID="s1263"/>
         </Row>
         <Row ss:Height="20" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1245">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Data Object Name</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Attribute Name</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Attribute Description</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Synonym 1</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Synonym 2</Data>
            </Cell>
            <Cell ss:StyleID="s1257">
               <Data ss:Type="String">Data Type (Object)</Data>
            </Cell>
            <Cell ss:StyleID="s1258">
               <Data ss:Type="String">Data Type (Primitive)</Data>
            </Cell>
            <Cell ss:StyleID="s1245">
               <Data ss:Type="String">Cardinality</Data>
            </Cell>
            <Cell ss:Index="12" ss:StyleID="s1262">
               <Data ss:Type="String">Data Object Check</Data>
            </Cell>
            <Cell ss:StyleID="s1262">
               <Data ss:Type="String">Data Type Check</Data>
            </Cell>
            <Cell ss:StyleID="s1262">
               <Data ss:Type="String">Column Check</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6"/>
		 {{#each this}}
		  	{{#each this.attributes}}
		  		{{#if this.synonyms}}
		  			{{#each this.synonyms}}
					 <Row ss:AutoFitHeight="0" ss:Height="15">
						<Cell ss:Index="2" ss:StyleID="s1063">
							<Data ss:Type="String">{{../this.id}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{../../this.name}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
							<Data ss:Type="String">{{../this.name}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{../this.description}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{this.name}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String"></Data>
						</Cell>
						<Cell ss:StyleID="s1251">
							<Data ss:Type="String">{{../this.typeObject}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   	<Data ss:Type="String">{{../this.typePrimitive}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{../this.cardinality}}</Data>
						</Cell>
						<Cell ss:Index="12"
							  ss:StyleID="s1259"
							  ss:Formula="=IF(RC[-9]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-9],'Data Objects'!C[-9],1,0)),&#34;Data Object must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
						   <Data ss:Type="String"/>
						</Cell>
						<Cell ss:StyleID="s1259"
							  ss:Formula="=IF(RC[-5]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-5],'Data Objects'!C[-10],1,0)),&#34;Data Type must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
						   <Data ss:Type="String"/>
						</Cell>
						<Cell ss:Formula="=IF(COUNTIF(RC[2]:RC[3], &#34;0&#34;)=0,&#34;You can only have 1 value across the two columns&#34;,&#34;&#34;)">
						   <Data ss:Type="String"/>
						</Cell>
						<Cell ss:Index="16" ss:Formula="=#REF!">
						   <Data ss:Type="Number">0</Data>
						</Cell>
						<Cell ss:Formula="=#REF!">
						   <Data ss:Type="Number">0</Data>
						</Cell>
					 </Row>
		  			{{/each}}
		  		{{else}}
		  	 	<Row ss:AutoFitHeight="0" ss:Height="15">
						<Cell ss:Index="2" ss:StyleID="s1063">
							<Data ss:Type="String">{{this.id}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{../this.name}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
							<Data ss:Type="String">{{this.name}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{this.description}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String"></Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String"></Data>
						</Cell>
						<Cell ss:StyleID="s1251">
							<Data ss:Type="String">{{this.typeObject}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   	<Data ss:Type="String">{{this.typePrimitive}}</Data>
						</Cell>
						<Cell ss:StyleID="s1251">
						   <Data ss:Type="String">{{this.cardinality}}</Data>
						</Cell>
						<Cell ss:Index="12"
							  ss:StyleID="s1259"
							  ss:Formula="=IF(RC[-9]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-9],'Data Objects'!C[-9],1,0)),&#34;Data Object must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
						   <Data ss:Type="String"/>
						</Cell>
						<Cell ss:StyleID="s1259"
							  ss:Formula="=IF(RC[-5]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-5],'Data Objects'!C[-10],1,0)),&#34;Data Type must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
						   <Data ss:Type="String"/>
						</Cell>
						<Cell ss:Formula="=IF(COUNTIF(RC[2]:RC[3], &#34;0&#34;)=0,&#34;You can only have 1 value across the two columns&#34;,&#34;&#34;)">
						   <Data ss:Type="String"/>
						</Cell>
						<Cell ss:Index="16" ss:Formula="=#REF!">
						   <Data ss:Type="Number">0</Data>
						</Cell>
						<Cell ss:Formula="=#REF!">
						   <Data ss:Type="Number">0</Data>
						</Cell>
					 </Row>
		  		{{/if}}
     		{{/each}}
		  {{/each}}
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>2</ActiveCol>
               <RangeSelection>R8C3:R9C4</RangeSelection>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R5000C8,R8C3:R5000C3</Range>
         <Type>List</Type>
         <Value>'Data Objects'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C10:R1066C10</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>"Multiple, One, One To Many, Single, Zero to One, Zero to Many"</Value>
      </DataValidation>
	  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	   <Range>R8C9:R1066C9</Range>
	   <Type>List</Type>
	   <CellRangeList/>
	   <Value>&quot;Boolean, Date, Decimal, Integer, Text&quot;</Value>
	  </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C12:R1066C13</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
</script> 
<script id="dataobjectinherit-name" type="text/x-handlebars-template">
   <Worksheet ss:Name="Data Object Inheritance">
      <Table ss:ExpandedColumnCount="7"
             x:FullColumns="1"
             x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="18"/>
         <Column ss:AutoFitWidth="0" ss:Width="241"/>
         <Column ss:AutoFitWidth="0" ss:Width="290"/>
         <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="123"/>
         <Column ss:AutoFitWidth="0" ss:Width="138"/>
         <Column ss:AutoFitWidth="0" ss:Width="66"/>
         <Row ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="35">
            <Cell ss:Index="2" ss:StyleID="s1271">
               <Data ss:Type="String">Data Object Inheritance</Data>
            </Cell>
            <Cell ss:StyleID="s1271"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1302"/>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="5" ss:StyleID="s1261">
               <Data ss:Type="String">Checks</Data>
            </Cell>
            <Cell ss:StyleID="s1261"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="36">
            <Cell ss:Index="2" ss:StyleID="s1246">
               <Data ss:Type="String">Parent Data Object</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Child Data Object</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s1260">
               <Data ss:Type="String">Parent Data Object</Data>
            </Cell>
            <Cell ss:StyleID="s1260">
               <Data ss:Type="String">Child Data Object</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6"/>
		 {{#each this}}
		  {{#if this.children}}
		  	{{#each this.children}}
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:StyleID="s1251">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1251">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:Index="5"
                  ss:StyleID="s1259"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],'Data Objects'!C[-2],1,0)),&#34;Data Object must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1259"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],'Data Objects'!C[-3],1,0)),&#34;Data Object must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{/each}}
		  {{/if}}
    	{{/each}}
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R3700C3</Range>
         <Type>List</Type>
         <Value>'Data Objects'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R37C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
</script> 				
<script id="dataobject-name" type="text/x-handlebars-template">
   <Worksheet ss:Name="Data Objects">
      <Table ss:ExpandedColumnCount="15"
             x:FullColumns="1"
             x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="18"/>
         <Column ss:AutoFitWidth="0" ss:Width="57"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="218" ss:Span="1"/>
         <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="200"/>
         <Column ss:AutoFitWidth="0" ss:Width="218"/>
         <Column ss:AutoFitWidth="0" ss:Width="200" ss:Span="1"/>
         <Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="170"/>
         <Row ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="35">
            <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1271">
               <Data ss:Type="String">Data Objects</Data>
            </Cell>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1302">
               <Data ss:Type="String">Captures the data objects used within the organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:Index="11" ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="36" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1245">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1256">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Synonym 1</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Synonym 2</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Parent Data Subject</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Data Category</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Is Abstract</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="11" ss:StyleID="s1044"/>
            <Cell ss:StyleID="s1148"/>
         </Row>
       	{{#each this}}
		  {{#if this.synonyms}}
		  	{{#each this.synonyms}}
		    <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.category}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.isAbstract}}</Data>
            </Cell>
         	</Row>
		    {{/each}}
		   {{/if}}
		 {{/each}}
		 {{#each this}}  
		  	{{#if this.parents}}
		  		{{#each this.parents}}
				 <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
				<Cell ss:Index="2" ss:StyleID="s1172">
				   <Data ss:Type="String">{{../this.id}}</Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String">{{../this.name}}</Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String">{{../this.description}}</Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String"></Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String"></Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String">{{this.name}}</Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String">{{../this.category}}</Data>
				</Cell>
				<Cell ss:StyleID="s1172">
				   <Data ss:Type="String">{{../this.isAbstract}}</Data>
				</Cell>
				</Row>
		  		{{/each}}
		  	{{else}}
		  	   <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.category}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.isAbstract}}</Data>
            </Cell>
         	</Row>
		  	{{/if}}
		 
		{{/each}}  
       
        
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>7</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
	  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C9:R107C9</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>"True, False"</Value>
      </DataValidation> 
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	   <Range>R8C8:R10700C8</Range>
	   <Type>List</Type>
	   <CellRangeList/>
	   <Value>&quot;Conditional Master Data, Master Data, Reference Data, Transactional Data&quot;</Value>
	  </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C10:R10700C10</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Organisations'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R10700C7</Range>
         <Type>List</Type>
         <Value>'Data Subjects'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C14:R8C15</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
</script> 					
<script id="datasubject-name" type="text/x-handlebars-template">
   <Worksheet ss:Name="Data Subjects">
      <Table ss:ExpandedColumnCount="9"
             x:FullColumns="1"
             x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="18"/>
         <Column ss:AutoFitWidth="0" ss:Width="57"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="218" ss:Span="1"/>
         <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="200"/>
         <Column ss:AutoFitWidth="0" ss:Width="108"/>
         <Column ss:AutoFitWidth="0" ss:Width="139"/>
         <Column ss:AutoFitWidth="0" ss:Width="133"/>
         <Row ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="35">
            <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1271">
               <Data ss:Type="String">Data Subjects</Data>
            </Cell>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
            <Cell ss:StyleID="s18"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1302">
               <Data ss:Type="String">Captures the data subjects used within the organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:StyleID="s1250"/>
            <Cell ss:Index="9" ss:StyleID="s1250"/>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1245">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1256">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Synonym 1</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Synonym 2</Data>
            </Cell>
            <Cell ss:StyleID="s1245">
               <Data ss:Type="String">Data Category</Data>
            </Cell>
            <Cell ss:StyleID="s1245">
               <Data ss:Type="String">Organisation Owner</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Individual Owner</Data>
            </Cell>
         </Row>
	{{#each this}}
		  {{#if this.synonyms}}
		  	{{#each this.synonyms}}
		    <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.category}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.orgOwner}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.indivOwner}}</Data>
            </Cell>
         	</Row>
		  {{/each}}
		  {{else}}
		  	<Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.category}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.orgOwner}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.indivOwner}}</Data>
            </Cell>
         	</Row>
		  {{/if}}
		{{/each}}
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TopRowVisible>6</TopRowVisible>
         <LeftColumnVisible>1</LeftColumnVisible>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>8</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R1088C7</Range>
         <Type>List</Type>
         <Value>Valid_Data_Categories</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R1088C8</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Organisations'!R8C3:R5000C3</Value>
      </DataValidation>
   </Worksheet>
</script> 				
<script id="app2server-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Application 2 Server">
      <Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="217"/>
         <Column ss:AutoFitWidth="0" ss:Width="236"/>
         <Column ss:AutoFitWidth="0" ss:Width="242"/>
         <Column ss:AutoFitWidth="0" ss:Width="202"/>
         <Column ss:AutoFitWidth="0" ss:Width="226"/>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1086"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="29">
            <Cell ss:StyleID="s1266"/>
            <Cell ss:MergeAcross="2" ss:StyleID="s1299">
               <Data ss:Type="String">Application to Server</Data>
            </Cell>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:MergeAcross="2" ss:StyleID="s1300">
               <Data ss:Type="String">Maps the applications to the servers that they are hosted on, with the environment</Data>
            </Cell>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1086"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1086"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1087">
               <Data ss:Type="String">App</Data>
            </Cell>
            <Cell ss:StyleID="s1088">
               <Data ss:Type="String">Server</Data>
            </Cell>
            <Cell ss:StyleID="s1089">
               <Data ss:Type="String">Environment</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Application Checker</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Server Checker</Data>
            </Cell>
            <Cell ss:StyleID="s1266"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="7">
            <Cell ss:StyleID="s1266"/>
            <Cell ss:StyleID="s1266">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1086">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1266">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1266">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1266">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1266"/>
         </Row>
          
          {{#each this}}
                {{#if this.deployment}}
                {{#each this.deployment}}
           <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
                <Cell ss:StyleID="s1172"> <Data ss:Type="String">{{../this.server}}</Data></Cell>
               <Cell ss:StyleID="s1172"> <Data ss:Type="String">{{this.name}}</Data></Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],Applications!C[-2],1,0)),&#34;Application must be already defined in Applications sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],Servers!C[-3],1,0)),&#34;Server must be already defined in Servers sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1266"/>
         </Row>
            {{/each}}
            {{else}}
          <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
                <Cell ss:StyleID="s1172">{this.server}}</Cell>
               <Cell ss:StyleID="s1091">{name}}</Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],Applications!C[-2],1,0)),&#34;Application must be already defined in Applications sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],Servers!C[-3],1,0)),&#34;Server must be already defined in Servers sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1266"/>
         </Row>
          {{/if}}
          {{/each}}
     </Table>
       <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveCol>6</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R2001C3</Range>
         <Type>List</Type>
         <Value>Servers</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R2100C4</Range>
         <Type>List</Type>
         <Value>'Environment'!R8C2:R40C2</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R10000C2</Range>
         <Type>List</Type>
         <Value>'Applications'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R10000C3</Range>
         <Type>List</Type>
         <Value>'Servers'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C5:R6C6</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C5:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R4000C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>   
    </Worksheet>
</script> 
<script id="techdoms-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Technology Domains">
      <Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="73"/>
         <Column ss:AutoFitWidth="0" ss:Width="237"/>
         <Column ss:AutoFitWidth="0" ss:Width="367"/>
         <Column ss:AutoFitWidth="0" ss:Width="156"/>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1111">
               <Data ss:Type="String">Technology Domains</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String">Used to capture a list of Technology Domains</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="19">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1225">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1225">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1225">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1225">
               <Data ss:Type="String">Position</Data>
            </Cell>
         </Row>
         <Row ss:Height="8">
            <Cell ss:Index="2" ss:StyleID="s1063"/>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String"/>
               <NamedCell ss:Name="Technology_Domains"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
        {{#each this}}
         <Row ss:Height="34">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.name}}</Data>
               <NamedCell ss:Name="Technology_Domains"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
                <Data ss:Type="String">{{this.ReferenceModelLayer}}</Data>
            </Cell>
         </Row>
          {{/each}}
       <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>5</ActiveRow>
               <ActiveCol>4</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R82C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>Reference_Model_Layers</Value>
      </DataValidation>     
     </Table>
    </Worksheet>
          </script>
<script id="techcaps-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Technology Capabilities">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1110"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="251"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="349"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="243"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="220"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Technology Capabilities</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Used to capture a list of Technology Capabilities</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="19">
            <Cell ss:Index="2" ss:StyleID="s1151">
               <Data ss:Type="String">Ref</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Capability Name</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Parent Technology Domain</Data>
            </Cell>
            <Cell ss:StyleID="s1186">
               <Data ss:Type="String">Check Domain</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="5">
            <Cell ss:Index="6" ss:StyleID="s1162"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Domains'!C[-3],1,0)),&#34;Technology Domain must be already defined in Technology Domains sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
          {{#each this}}
         <Row ss:Height="34">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{this.id}}</Data>
               <NamedCell ss:Name="Technology_Capabilities"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.domain}}</Data>
               <NamedCell ss:Name="Technology_Domains"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Domains'!C[-3],1,0)),&#34;Technology Domain must be already defined in Technology Domains sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
         </Row>
          {{/each}}
     </Table>
         <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>5</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R3900C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Technology Domains'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R3900C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
          
          
</script>
<script id="techsuppliers-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Technology Suppliers">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1110"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="251"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="349"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="243"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="220"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Technology Suppliers</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Used to capture a list of Technology Suppliers</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="19">
            <Cell ss:Index="2" ss:StyleID="s1151">
               <Data ss:Type="String">Ref</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Supplier Name</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell >
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="5">
            <Cell ss:Index="6">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
          {{#each this}}
         <Row ss:Height="34">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{this.id}}</Data> 
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell >
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell  >
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
          {{/each}}
     </Table>
         <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>5</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
   </Worksheet>
          
          
</script>                
<script id="techprodorg-name" type="text/x-handlebars-template">
    <Worksheet ss:Name="Tech Prods to User Orgs">
      <Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="208" ss:Span="1"/>
         <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="153"/>
         <Column ss:AutoFitWidth="0" ss:Width="264"/>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1111">
               <Data ss:Type="String">Technology Product to User Organisations</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String">Maps Technology Products to the Organisations that use them.</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="19">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Technology Product</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String">Product Check</Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String">Organisation Check</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="4"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Products'!C[-1],1,0)),&#34;Technology Product must be already defined in Technology Products sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		 {{#each this}}
		  {{#if this.org}}
		   {{#each this.org}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Products'!C[-1],1,0)),&#34;Technology Product must be already defined in Technology Products sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		    {{/each}}
		   {{/if}}
		  {{/each}}
       
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <TopRowBottomPane>3</TopRowBottomPane>
         <ActivePane>2</ActivePane>
   <!--      <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>1</ActiveCol>
            </Pane>
         </Panes> -->
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R2280C2</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Technology Products'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R2280C3</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Organisations'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R2280C5</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>      
</script>           			
<script id="techprodfamily-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Technology Product Families">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1110"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="251"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="349"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="243"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="220"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Technology Product Families</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Used to capture a list of Technology Product Families that group separate versions of a Technology Product into a family for that Product. e.g. Oracle WebLogic to group WebLogic 7.0, WebLogic 8.0, WebLogic 9.0</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="19">
            <Cell ss:Index="2" ss:StyleID="s1151">
               <Data ss:Type="String">Ref</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Product Family Name</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell >
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="5">
            <Cell ss:Index="6">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
          {{#each this}}
         <Row ss:Height="34">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{this.id}}</Data> 
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell >
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell  >
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
          {{/each}}
     </Table>
         <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>5</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
   </Worksheet>
          
          
</script>           		
<script id="techprods-name" type="text/x-handlebars-template">
  <Worksheet ss:Name="Technology Products">
      <Names>
         <NamedRange ss:Name="_FilterDatabase"
                     ss:RefersTo="='Technology Products'!R7C1:R753C19"
                     ss:Hidden="1"/>
      </Names>
      <Table ss:ExpandedColumnCount="39"
             x:FullColumns="1"
             x:FullRows="1"
             ss:StyleID="s1110"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="19"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="70"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="236"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="148"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="127"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="154"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="164"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="83"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="122"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="150"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="0"/>
         <Column ss:AutoFitWidth="0" ss:Width="0" ss:Span="1"/>
         <Column ss:Index="15"
                 ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="0"/>
         <Column ss:AutoFitWidth="0" ss:Width="0" ss:Span="1"/>
         <Column ss:Index="18"
                 ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="0"/>
         <Column ss:AutoFitWidth="0" ss:Width="0" ss:Span="1"/>
         <Column ss:Index="21"
                 ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="144"
                 ss:Span="2"/>
         <Column ss:Index="24"
                 ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="127"/>
         <Column ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="129"
                 ss:Span="1"/>
         <Column ss:Index="27"
                 ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="93"
                 ss:Span="3"/>
         <Column ss:Index="31"
                 ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="119"/>
         <Column ss:StyleID="s1110"
                 ss:AutoFitWidth="0"
                 ss:Width="104"
                 ss:Span="3"/>
         <Column ss:Index="36"
                 ss:StyleID="s1110"
                 ss:Hidden="1"
                 ss:AutoFitWidth="0"
                 ss:Span="2"/>
         <Row>
            <Cell ss:Index="13" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="16" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="19" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Technology Products</Data>
            </Cell>
            <Cell ss:Index="13" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="16" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="19" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Details the Technology Products</Data>
            </Cell>
            <Cell ss:Index="13" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="16" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="19" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="5" ss:StyleID="s1203">
               <Data ss:Type="String">Error Status</Data>
            </Cell>
            <Cell ss:StyleID="s1112" ss:Formula="=SUM(C[33])">
               <Data ss:Type="Number">0</Data>
            </Cell>
            <Cell ss:Index="13" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="16" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="19" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="13" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="16" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:Index="19" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="51">
            <Cell ss:Index="2" ss:StyleID="s1113">
               <Data ss:Type="String">Ref</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Supplier</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Product Family</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Vendor Release Status</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Delivery Model</Data>
            </Cell>
            <Cell ss:StyleID="s1113">
               <Data ss:Type="String">Usage</Data>
            </Cell>
            <Cell ss:StyleID="s1201">
               <Data ss:Type="String">Usage Compliance Level</Data>
            </Cell>
            <Cell ss:StyleID="s1201">
               <Data ss:Type="String">Usage Adoption Status</Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String">Product Family Check</Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String">Vendor Release check</Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String">Delivery Model Check</Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String">Usage 1 Check</Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String">Compliance 1 Check</Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String">Adoption 1</Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">Checks</Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell>
               <Data ss:Type="String">Issues</Data>
            </Cell>
         </Row>
         <Row ss:Height="51">
            <Cell ss:Index="2" ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1194">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell>
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
          {{#each this}}
          {{#if this.usages}}
              {{#each this.usages}}
               <Row>
            <Cell ss:Index="2" ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.supplier}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
                <Data ss:Type="String">{{#each ../this.family}}{{#ifEquals @index 0}}{{this.name}}{{/ifEquals}}{{/each}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.vendor}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.delivery}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.compliance}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
             <Data ss:Type="String">{{this.adoption}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Product Families'!C[-18],1,0)),&#34;Technology Product Family must be already defined in Technology Product Families sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,IF(COUNTIF(Tech_Vendor_Release_Statii,RC[-15]),&#34;OK&#34;,&#34;Type MUST match the values in Launchpad.  To change these speak to us&#34;),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,IF(COUNTIF(Tech_Delivery_Models,RC[-15]),&#34;OK&#34;,&#34;Type MUST match the values in Launchpad.  To change these speak to us&#34;),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Components'!C[-21],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-13]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-13],'Technology Components'!C[-22],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-11]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-11],'Technology Components'!C[-23],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-9]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-9],'Technology Components'!C[-24],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-18]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-18],'Standards Compliance Levels'!C[-25],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-16]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-16],'Standards Compliance Levels'!C[-26],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-14]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-14],'Standards Compliance Levels'!C[-27],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-12]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-12],'Standards Compliance Levels'!C[-28],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-21]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-21],'Technology Adoption Statii'!C[-29],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">Adoption Level must be already defined in Technology Adoption Statii sheet</Data>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-19]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-19],'Technology Adoption Statii'!C[-30],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-17]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-17],'Technology Adoption Statii'!C[-31],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Adoption Statii'!C[-32],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-15]:RC[-1], &#34;OK&#34;)">
               <Data ss:Type="Number">0</Data>
            </Cell>
            <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-16]:RC[-2], &#34;&#34;)">
               <Data ss:Type="Number">14</Data>
            </Cell>
            <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-17]:RC[-3],&#34;&lt;&gt;''&#34;)">
               <Data ss:Type="Number">15</Data>
            </Cell>
            <Cell ss:StyleID="s1200"/>
         </Row>
               {{/each}}
          {{else}}
            <Row>
            <Cell ss:Index="2" ss:StyleID="s1112">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.vendor}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
                <Data ss:Type="String">{{#each ../this.family}}{{#ifEquals @index 0}}{{this.name}}{{/ifEquals}}{{/each}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.vendor}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String">{{this.delivery}}</Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
             <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1112">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Product Families'!C[-18],1,0)),&#34;Technology Product Family must be already defined in Technology Product Families sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,IF(COUNTIF(Tech_Vendor_Release_Statii,RC[-15]),&#34;OK&#34;,&#34;Type MUST match the values in Launchpad.  To change these speak to us&#34;),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,IF(COUNTIF(Tech_Delivery_Models,RC[-15]),&#34;OK&#34;,&#34;Type MUST match the values in Launchpad.  To change these speak to us&#34;),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Components'!C[-21],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-13]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-13],'Technology Components'!C[-22],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-11]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-11],'Technology Components'!C[-23],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-9]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-9],'Technology Components'!C[-24],1,0)),&#34;Technology Component must be already defined in Technology Components sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-18]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-18],'Standards Compliance Levels'!C[-25],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-16]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-16],'Standards Compliance Levels'!C[-26],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-14]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-14],'Standards Compliance Levels'!C[-27],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-12]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-12],'Standards Compliance Levels'!C[-28],1,0)),&#34;Compliance Level must be already defined in Standards Compliance Levels sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-21]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-21],'Technology Adoption Statii'!C[-29],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">Adoption Level must be already defined in Technology Adoption Statii sheet</Data>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-19]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-19],'Technology Adoption Statii'!C[-30],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-17]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-17],'Technology Adoption Statii'!C[-31],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200"
                  ss:Formula="=IF(RC[-15]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Adoption Statii'!C[-32],1,0)),&#34;Adoption Level must be already defined in Technology Adoption Statii sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-15]:RC[-1], &#34;OK&#34;)">
               <Data ss:Type="Number">0</Data>
            </Cell>
            <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-16]:RC[-2], &#34;&#34;)">
               <Data ss:Type="Number">14</Data>
            </Cell>
            <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-17]:RC[-3],&#34;&lt;&gt;''&#34;)">
               <Data ss:Type="Number">15</Data>
            </Cell>
            <Cell ss:StyleID="s1200"/>
         </Row>
          {{/if}}
          {{/each}}
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>17</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
     
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C19:R487C20,R8C13:R487C14,R8C10:R487C11,R8C16:R753C17</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>Usage_Lifecycle_Statii</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C9:R487C9</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Technology Components'!R8C3:R2900C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R753C7</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>Tech_Vendor_Release_Statii</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R753C8</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>Tech_Delivery_Models</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R753C4</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>Technology_Product_Suppliers</Value>
      </DataValidation>
       <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C10:R5000C10</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>'Standards Compliance Levels'!R8C3:R29C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C11:R5000C11</Range>
   <Type>List</Type>
   <Value>'Lifecycle Status'!R8C3:R43C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C6:R2000C6</Range>
   <Type>List</Type>
   <Value>'Technology Product Families'!R8C3:R14C3</Value>
  </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C39:R753C39</Range>
         <Condition>
            <Qualifier>Greater</Qualifier>
            <Value1>0</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R4C6</Range>
         <Condition>
            <Qualifier>Equal</Qualifier>
            <Value1>0</Value1>
            <Format Style="color:#C4D79B;background:#C4D79B"/>
         </Condition>
         <Condition>
            <Qualifier>Greater</Qualifier>
            <Value1>0</Value1>
            <Format Style="color:#E6B8B7;background:#E6B8B7"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>                
                </script>                
<script id="techcomps-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Technology Components">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1110"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="251"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="349"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="243"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="220"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Technology Components</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Used to capture a list of Technology Components</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="19">
            <Cell ss:Index="2" ss:StyleID="s1151">
               <Data ss:Type="String">Ref</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Component Name</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Parent Technology Capability</Data>
            </Cell>
            <Cell ss:StyleID="s1186">
               <Data ss:Type="String">Check Capability</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="5">
            <Cell ss:Index="6" ss:StyleID="s1162"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Capabilities'!C[-3],1,0)),&#34;Technology Capability must be already defined in Technology Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
        {{#each this}}
          {{#if this.caps}}
            {{#each this.caps}}
         <Row ss:Height="34">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{../this.id}}</Data>
               <NamedCell ss:Name="Technology_Components"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this}}</Data>
               <NamedCell ss:Name="Technology_Capabilities"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Capabilities'!C[-3],1,0)),&#34;Technology Capability must be already defined in Technology Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
         </Row>
          {{/each}}
          {{else}}
          <Row ss:Height="34">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{this.id}}</Data>
               <NamedCell ss:Name="Technology_Components"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String"></Data>
               <NamedCell ss:Name="Technology_Capabilities"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Capabilities'!C[-3],1,0)),&#34;Technology Capability must be already defined in Technology Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
         </Row>
          
          {{/if}}
          {{/each}}
     </Table>
         <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>5</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R3900C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Technology Components'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R3900C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
          
          
</script>               
<script id="inforeps-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Information Exchanged">
      <Table ss:ExpandedColumnCount="8" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="69"/>
         <Column ss:AutoFitWidth="0" ss:Width="218"/>
         <Column ss:AutoFitWidth="0" ss:Width="377"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1298">
               <Data ss:Type="String">Information Exchanged</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1056">
               <Data ss:Type="String">Used to capture the Information exchanged between applications</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1244">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1245">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1246">
               <Data ss:Type="String">Description</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="2" ss:StyleID="s1143"/>
            <Cell ss:StyleID="s1063"/>
            <Cell ss:StyleID="s1144"/>
         </Row>
		  {{#each this}}
         <Row ss:Height="17" ss:StyleID="s1032">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
         </Row>
		  {{/each}}
		 </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>13</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
   </Worksheet>  
		  </script>						
<script id="servers-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Servers">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="37"/>
         <Column ss:AutoFitWidth="0" ss:Width="70"/>
         <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="200"/>
         <Column ss:AutoFitWidth="0" ss:Width="200" ss:Span="1"/>
         <Row ss:Index="2" ss:AutoFitHeight="0" ss:Height="25">
            <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1289">
               <Data ss:Type="String">Servers</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1056">
               <Data ss:Type="String">Captures the list of physical technology nodes deployed across the enterprise, and the IP address if available</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:StyleID="s1141">
               <Data ss:Type="String">ID</Data>
                
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Hosted In</Data>
                
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">IP Address</Data>
                
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6"/>
      {{#each this}}
         {{#if this.ipAddresses}}
         {{#each this.ipAddresses}}
            <Row ss:AutoFitHeight="0" ss:Height="15">
               <Cell ss:Index="2" ss:StyleID="s1095">
                  <Data ss:Type="String">{{../this.id}}</Data>
               </Cell>
               <Cell ss:StyleID="s1095">
                  <Data ss:Type="String">{{../this.name}}</Data>
                  <NamedCell ss:Name="Servers"/>
               </Cell>
               <Cell ss:StyleID="s1095">
                  <Data ss:Type="String">{{../this.hostedIn}}</Data>
               </Cell>  
               <Cell ss:StyleID="s1095">
                  <Data ss:Type="String">{{this}}</Data>
               </Cell>
            </Row>
         {{/each}}
         {{else}}
         <Row ss:AutoFitHeight="0" ss:Height="15">
               <Cell ss:Index="2" ss:StyleID="s1095">
                  <Data ss:Type="String">{{this.id}}</Data>
               </Cell>
               <Cell ss:StyleID="s1095">
                  <Data ss:Type="String">{{this.name}}</Data>
                  <NamedCell ss:Name="Servers"/>
               </Cell>
               <Cell ss:StyleID="s1095">
                  <Data ss:Type="String">{{this.hostedIn}}</Data>
               </Cell>  
               <Cell ss:StyleID="s1095">
                  <Data ss:Type="String">{{this.ipAddress}}</Data>
               </Cell>
            </Row>
         {{/if}}
		  {{/each}}
	 </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>3</ActiveCol>
               <RangeSelection>R8C4:R178C4</RangeSelection>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R178C4</Range>
         <Type>List</Type>
         <Value>'Sites'!R8C3:R5000C3</Value>
      </DataValidation>
   </Worksheet>	  
</script>
<script id="bp2appsvc-name" type="text/x-handlebars-template">
   <Worksheet ss:Name="Business Process 2 App Services">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="269"/>
         <Column ss:AutoFitWidth="0" ss:Width="262"/>
         <Column ss:AutoFitWidth="0" ss:Width="216"/>
         <Column ss:AutoFitWidth="0" ss:Width="277"/>
         <Column ss:AutoFitWidth="0" ss:Width="253"/>
      <Row>
            <Cell ss:Index="2" ss:StyleID="s1045"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="23">
            <Cell ss:Index="2" ss:StyleID="s1269">
               <Data ss:Type="String">Business Process to Required Application Service</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1045">
               <Data ss:Type="String">Maps the business processes to the application services they require</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1045"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1045"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1141">
               <Data ss:Type="String">Business Process</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Application Service</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Criticality of Application Service</Data>
            </Cell>
            <Cell ss:StyleID="s1180">
               <Data ss:Type="String">Check Business Process</Data>
            </Cell>
            <Cell ss:StyleID="s1180">
               <Data ss:Type="String">Check Application Services</Data>
            </Cell>
         </Row>
		    <Row ss:AutoFitHeight="0" ss:Height="17">
			   <Cell ss:Index="2" ss:StyleID="s1181"/>
            	<Cell ss:StyleID="s1181"/>
				<Cell ss:StyleID="s1181"/>
				<Cell ss:StyleID="s1181"/>
            	<Cell ss:StyleID="s1178"/>
		  </Row> 
		 {{#each this}}
		  	 {{#if this.services}}
		  	 {{#each this.services}}
		   <Row ss:AutoFitHeight="0" ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1095">
				<Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1095">
               <Data ss:Type="String">{{this.name}}</Data>
               <NamedCell ss:Name="Servers"/>
            </Cell>
            <Cell ss:StyleID="s1095">
				<Data ss:Type="String">{{this.criticality}}</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s1177"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&#34;Business Process must be already defined in Business Processes sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1178"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],'Application Services'!C[-3],1,0)),&#34;Application Service must be already defined in Application Services sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		 {{/each}}
		  {{/if}}
		  {{/each}}
 </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <HorizontalResolution>-4</HorizontalResolution>
            <VerticalResolution>-4</VerticalResolution>
         </Print>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>1</SplitHorizontal>
         <TopRowBottomPane>1</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>3</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
       
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R4500C3</Range>
         <Type>List</Type>
         <Value>'Application Services'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R4500C4</Range>
         <Type>List</Type>
         <Value>&quot;High,Medium,Low&quot;</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R4500C2</Range>
         <Type>List</Type>
         <Value>'Business Processes'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C6</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R4500C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>		  
</script>	
<script id="pp2appviasvc-name" type="text/x-handlebars-template">
<Worksheet ss:Name="Physical Proc 2 App and Service">
      <Names>
            <NamedRange ss:Name="AppProRole" ss:RefersTo="='App Service 2 Apps'!R8C8:R2000C8"/>
      </Names>
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="179"/>
         <Column ss:AutoFitWidth="0" ss:Width="199"/>
         <Column ss:AutoFitWidth="0" ss:Width="297"/>
         <Column ss:AutoFitWidth="0" ss:Width="230"/>
         <Column ss:AutoFitWidth="0" ss:Width="194"/>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Physical Process to App Pro Role</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110">
               <Data ss:Type="String">Maps the Process to the Organisations that perform them, the applications used and what the application is used for (service)</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1182">
               <Data ss:Type="String">Business Process</Data>
            </Cell>
            <Cell ss:StyleID="s1182">
               <Data ss:Type="String">Performing Organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1182">
               <Data ss:Type="String">Application and Service Used</Data>
            </Cell>
            <Cell ss:StyleID="s1188">
               <Data ss:Type="String">Process Check</Data>
            </Cell>
            <Cell ss:StyleID="s1189">
               <Data ss:Type="String">Organisation Check</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8">
            <Cell ss:Index="2" ss:StyleID="s1183">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1184">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1184">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1190">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1190">
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
		{{#each this}}
		  {{#if this.appsviaservice}}
		  	{{#each this.appsviaservice}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.processName}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.org}}</Data>
            </Cell>
            <Cell ss:StyleID="s1185">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&#34;Business Process must be already defined in Business Processes sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>	
		   		{{/each}}
		  	{{/if}}
		  {{/each}}
	</Table>
	  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>3</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R3000C2</Range>
         <Type>List</Type>
         <Value>'Business Processes'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R3000C3</Range>
         <Type>List</Type>
         <Value>'Organisations'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
            <Range>R8C4:R3000C4</Range>
            <Type>List</Type>
            <Value>'App Service 2 Apps'!R8C8:R5000C8</Value>
         </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R174C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>	
<script id="pp2app-name" type="text/x-handlebars-template">
	<Worksheet ss:Name="Physical Proc 2 App">
      <Table ss:ExpandedColumnCount="6" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="179"/>
         <Column ss:AutoFitWidth="0" ss:Width="199"/>
         <Column ss:AutoFitWidth="0" ss:Width="297"/>
         <Column ss:AutoFitWidth="0" ss:Width="230"/>
         <Column ss:AutoFitWidth="0" ss:Width="194"/>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Physical Process to App</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110">
               <Data ss:Type="String">Maps the Process to the Organisations that perform them and the applications used.  NOTE only use this sheet if you don't know the services the apps are providing</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1182">
               <Data ss:Type="String">Business Process</Data>
            </Cell>
            <Cell ss:StyleID="s1182">
               <Data ss:Type="String">Performing Organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1182">
               <Data ss:Type="String">Application Used</Data>
            </Cell>
            <Cell ss:StyleID="s1188">
               <Data ss:Type="String">Process Check</Data>
            </Cell>
            <Cell ss:StyleID="s1189">
               <Data ss:Type="String">Organisation Check</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8">
            <Cell ss:Index="2" ss:StyleID="s1183">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1184">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1184">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1190">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1190">
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
		{{#each this}}
		  {{#if this.appsdirect}}
		  	{{#each this.appsdirect}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.processName}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.org}}</Data>
            </Cell>
            <Cell ss:StyleID="s1185">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&#34;Business Process must be already defined in Business Processes sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>	
		   		{{/each}}
		  	{{/if}}
		  {{/each}}
	</Table>
	  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>3</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R174C4</Range>
         <Type>List</Type>
         <Value>'Applications'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R3000C2</Range>
         <Type>List</Type>
         <Value>'Business Processes'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R3000C3</Range>
         <Type>List</Type>
         <Value>'Organisations'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R174C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet></script>					
<script id="app2org-name" type="text/x-handlebars-template">
	 <Worksheet ss:Name="Application to User Orgs">
      <Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="208" ss:Span="1"/>
         <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="109"/>
         <Column ss:AutoFitWidth="0" ss:Width="145"/>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1111">
               <Data ss:Type="String">Application to User Organisations</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String">Maps the Applications to the Organisations that use them.</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="19">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Application</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Check Applications</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Check Organisations</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="2" ss:StyleID="s1181"/>
            <Cell ss:StyleID="s1181"/>
            <Cell ss:StyleID="s1178"/>
            <Cell ss:StyleID="s1178"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
      {{#each this}}
		  {{#if this.actors}}
		  	{{#each this.actors}}
		  <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&#34;Application must be already defined in Applications sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  	{{/each}}
		  {{/if}}
		{{/each}}
  
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R10000C2</Range>
         <Type>List</Type>
         <Value>'Applications'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R10000C3</Range>
         <Type>List</Type>
         <Value>'Organisations'!R8C3:R5000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C4:R6C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C4:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R207C5</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet> 
</script>					
<script id="app2svc-name" type="text/x-handlebars-template">
<Worksheet ss:Name="App Service 2 Apps">
      <Table ss:ExpandedColumnCount="8" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1045"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="35"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="240"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="212"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="154" ss:Span="1"/>
         <Row ss:Index="2" ss:Height="24">
            <Cell ss:Index="2" ss:StyleID="s1069">
               <Data ss:Type="String">Application Service to Applications</Data>
            </Cell>
            <Cell ss:StyleID="s1069"/>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Maps the Applications to the Services they can provide</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1145">
               <Data ss:Type="String">Application</Data>
            </Cell>
            <Cell ss:StyleID="s1146">
               <Data ss:Type="String">Application Service</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Check Applications</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Check Application Services</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8">
            <Cell ss:Index="2" ss:StyleID="s1170"/>
            <Cell ss:StyleID="s1171"/>
            <Cell ss:StyleID="s1177">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1177">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		{{#each this}}
		  {{#if this.services}}
		  	{{#each this.services}}
         <Row ss:Height="17" ss:StyleID="s1032">
            <Cell ss:Index="2" ss:StyleID="s1172">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1172">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&#34;Application must be already defined in Applications sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&#34;Application Service must be already defined in Application Services sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Index="8" ss:Formula="=CONCATENATE(RC[-6],&quot; as &quot;,RC[-5])"><Data
               ss:Type="String">{{../this.name}} as {{this.name}}</Data></Cell>
         </Row>
		  {{/each}}
		  {{/if}}
		  {{/each}}
 </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>68</ActiveRow>
               <ActiveCol>1</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R10000C2</Range>
         <Type>List</Type>
         <Value>'Applications'!R8C3:R5000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R10000C3</Range>
         <Type>List</Type>
         <Value>'Application Services'!R8C3:R4000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C4:R6C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C4:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R162C5</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>		  
</script>			
<script id="apps-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Applications">
      <Names>
         <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=Applications!R6C2:R45C5" ss:Hidden="1"/>
         <NamedRange ss:Name="Print_Area" ss:RefersTo="=Applications!R6C2:R45C4"/>
      </Names>
      <Table ss:ExpandedColumnCount="10" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1045"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="15">
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="36"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="50"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="184"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="267"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="129"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="158"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="114"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="126" ss:Span="2"/>
         <Row ss:AutoFitHeight="0">
            <Cell ss:Index="3" ss:StyleID="s1065"/>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="35">
            <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1269">
               <Data ss:Type="String">Applications</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0">
            <Cell ss:Index="2" ss:MergeAcross="4">
               <Data ss:Type="String">Captures information about the Applications used within the organisation</Data>
            </Cell>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0">
            <Cell ss:Index="3"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1037">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Type</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Lifecycle Status</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Delivery Model</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Type Check</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Lifecycle Check</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Delivery Model Check</Data>
            </Cell>
         </Row>
      <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="5" ss:StyleID="s1176">
               
            </Cell>
            <Cell ss:Index="8" ss:StyleID="s1176"/>
            <Cell ss:StyleID="s1176"/>
            <Cell ss:StyleID="s1176"
                  ss:Formula="=IF(RC[-3]&lt;&gt;&#34;&#34;,IF(COUNTIF(App_Delivery_Models,RC[-3]),&#34;OK&#34;,&#34;Delivery Model MUST match the values in Launchpad.  To change these speak to us&#34;),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{#each this}}
         <Row ss:AutoFitHeight="0" ss:StyleID="s1065">
            <Cell ss:Index="2" ss:StyleID="s1176">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1176">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1176">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1176">
               <Data ss:Type="String">{{this.codebase_name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1176">
               <Data ss:Type="String">{{this.lifecycle_name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1176">
               <Data ss:Type="String">{{this.delivery_name}}</Data>
            </Cell>
                <Cell ss:StyleID="s1176"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Application Codebases'!C[-5],1,0)),&quot;Application Codebase must be already defined in Application Codebase sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1176"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Lifecycle Status'!R8C5:R[33]C[-4],1,0)),&quot;Lifecycle Status must be already defined in Lifecycle Status sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1176"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Application Delivery Models'!C[-7],1,0)),&quot;Delivery Model must be already defined in Application Delivery Modelsheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
         </Row>
      {{/each}} 
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <Unsynced/>
         <FitToPage/>
         <Print>
            <FitHeight>0</FitHeight>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <Scale>43</Scale>
            <HorizontalResolution>-4</HorizontalResolution>
            <VerticalResolution>-4</VerticalResolution>
         </Print>
         <TabColorIndex>31</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveCol>1</ActiveCol>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>2</ActiveCol>
               <RangeSelection>R8C3:R9C3</RangeSelection>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
       <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   		<Range>R8C7:R4005C7</Range>
		   <Type>List</Type>
		   <Value>'Application Delivery Models'!R8C3:R23C3</Value>
  		</DataValidation>
	  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	   <Range>R8C6:R4005C6</Range>
	   <Type>List</Type>
	   <Value>'Lifecycle Status'!R8C3:R38C3</Value>
	  </DataValidation>
	  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	   <Range>R8C5:R4005C5</Range>
	   <Type>List</Type>
	   <Value>'Application Codebases'!R8C4:R22C4</Value>
	  </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2,R6C4,R6C6</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3,R6C5,R6C7</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C8:R6C10</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C8:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R2000C10</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>
</script>						
<script id="appcapsvc-name" type="text/x-handlebars-template">
   <Worksheet ss:Name="App Service 2 App Capabilities">	
 <Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1045"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="218"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="253"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="192"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="219"/>
         <Row ss:Index="2" ss:Height="26">
            <Cell ss:Index="2" ss:StyleID="s1106">
               <Data ss:Type="String">Application Capability to Application Service</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Capture the mapping of the Application Services to the Application Capability they support</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1169">
               <Data ss:Type="String">Application Capability</Data>
            </Cell>
            <Cell ss:StyleID="s1037">
               <Data ss:Type="String">Application Service</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">App Capability Check</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Application Service Check</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8" ss:StyleID="s1032">
            <Cell ss:Index="2" ss:StyleID="s1226"/>
            <Cell ss:StyleID="s1177"/>
            <Cell ss:StyleID="s1227"/>
            <Cell ss:StyleID="s1227"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&#34;Application Service must be already defined in Application Services sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
 {{#each this}}
	 {{#if this.services}}
 			{{#each this.services}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1176">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1176">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],'Application Capabilities'!C[-1],1,0)),&#34;Application Capability must be already defined in Application Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&#34;Application Service must be already defined in Application Services sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
	 {{/each}}
	
	 {{else}}
	 {{/if}}
	 {{/each}}
	 	
	</Table>
	<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>18</ActiveRow>
               <ActiveCol>6</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R4000C2</Range>
         <Type>List</Type>
         <Value>'Application Capabilities'!R8C3:R1000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R4000C3</Range>
         <Type>List</Type>
         <Value>'Application Services'!R8C3:R4000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C4:R6C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C4:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R97C4</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R97C5</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>					
<script id="appsvc-name" type="text/x-handlebars-template">
<Worksheet ss:Name="Application Services">
      <Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1045"
             ss:DefaultColumnWidth="448"
             ss:DefaultRowHeight="16">
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="24"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="47"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="200"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="285"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="403"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="155"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="140"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1269">
               <Data ss:Type="String">Application Services</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:MergeAcross="2">
               <Data ss:Type="String">Capture the Application Services required to support the business</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1145">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1146">
               <Data ss:Type="String">Description </Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">App Service Check</Data>
            </Cell>
         </Row>
     
		  <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String"> </Data>
               <NamedCell ss:Name="Valid_App_Services"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String"> </Data>
            </Cell>
             <Cell ss:StyleID="s1063">
               <Data ss:Type="String"> </Data>
            </Cell>
         </Row>
		 {{#each this}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1063">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.name}}</Data>
               <NamedCell ss:Name="Valid_App_Services"/>
            </Cell>
            <Cell ss:StyleID="s1063">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-2],1,0)),&#34;OK&#34;,&#34;These Services look like your applications, try and break them down into what the applications does at a high level, 2-6 per application is about right&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{/each}}
	</Table>
	    <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <HorizontalResolution>-4</HorizontalResolution>
            <VerticalResolution>-4</VerticalResolution>
         </Print>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2,R6C4</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R151C5</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>			
<script id="appcap-name" type="text/x-handlebars-template">
	<Worksheet ss:Name="Application Capabilities">
      <Table ss:ExpandedColumnCount="12" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1045"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="18"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="49"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="209"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="326"/>
         <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="145"/>
         <Column ss:StyleID="s1032" ss:AutoFitWidth="0" ss:Width="179"/>
         <Column ss:StyleID="s1032" ss:AutoFitWidth="0" ss:Width="189"/>
         <Column ss:StyleID="s1032" ss:AutoFitWidth="0" ss:Width="194"/>
         <Column ss:AutoFitWidth="0" ss:Width="156"/>
         <Column ss:StyleID="s1165" ss:AutoFitWidth="0" ss:Width="169"/>
         <Column ss:StyleID="s1166" ss:AutoFitWidth="0" ss:Width="169" ss:Span="1"/>
         <Row>
            <Cell ss:Index="9" ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1269">
               <Data ss:Type="String">Application Capabilities</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s1032"/>
            <Cell ss:StyleID="s1045"/>
            <Cell ss:Index="9" ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1166"/>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Captures the Application Capabilities required to support the buisness and the category to manage the structure of the view</Data>
            </Cell>
            <Cell ss:Index="5" ss:StyleID="s1103"/>
            <Cell ss:Index="9" ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:Index="5" ss:StyleID="s1104"/>
            <Cell ss:Index="9" ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="68">
            <Cell ss:Index="5" ss:StyleID="s1272">
               <Data ss:Type="String">Management - Left
Shared - Right
Core - Middle
Enabling - Bottom middle</Data>
            </Cell>
            <Cell ss:Index="9" ss:StyleID="s1249">
               <Data ss:Type="String">Do not use top or bottom</Data>
            </Cell>
         </Row>
         <Row ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1141">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Description </Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">App Cap Category</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Business Domain</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Parent App Capability</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Suported Bus Capability</Data>
            </Cell>
            <Cell ss:StyleID="s1164">
               <Data ss:Type="String">Reference Model Layer</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Business Domain Checker</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Parent App Capability Checker</Data>
            </Cell>
            <Cell ss:StyleID="s1167">
               <Data ss:Type="String">Suported Bus Capability Checker</Data>
            </Cell>
         </Row>
		
         <Row ss:AutoFitHeight="0" ss:Height="9">
            <Cell ss:Index="2" ss:StyleID="s1034">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1034">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1034">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1034">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1034">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1034">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1034">
               <Data ss:Type="String">.</Data>
            </Cell>
            <Cell ss:Index="10" ss:StyleID="s1168"/>
            <Cell ss:StyleID="s1168"/>
            <Cell ss:StyleID="s1168"/>
         </Row>
		  {{#each this}}
		    {{#if this.SupportedBusCapability}}
			{{#each this.SupportedBusCapability}}
		    <Row ss:Height="17">
           <Cell ss:Index="2" ss:StyleID="s1034">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1025">
               <Data ss:Type="String">{{../this.name}}</Data>
               <NamedCell ss:Name="Valid_App_Caps"/>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../this.appCapCategory}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
                <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../ReferenceModelLayer}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Domains'!C[-7],1,0)),&#34;Business Domain must be already defined in Business Domains sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Application Capabilities'!C[-8],1,0)),&#34;Application Capability must be already defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&#34;Business Capability must be already defined in the Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
			{{/each}}
		  	{{/if}}
	  {{#if this.businessDomain}}
			{{#each this.businessDomain}}
		  <Row ss:Height="17">
           <Cell ss:Index="2" ss:StyleID="s1034">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1025">
               <Data ss:Type="String">{{../this.name}}</Data>
               <NamedCell ss:Name="Valid_App_Caps"/>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../this.appCapCategory}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
                <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../ReferenceModelLayer}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Domains'!C[-7],1,0)),&#34;Business Domain must be already defined in Business Domains sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Application Capabilities'!C[-8],1,0)),&#34;Application Capability must be already defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&#34;Business Capability must be already defined in the Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  	{{/each}}
		  {{/if}}
	  		{{#if this.ParentAppCapability}}
			{{#each this.ParentAppCapability}}
		  <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1034">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1025">
               <Data ss:Type="String">{{../this.name}}</Data>
               <NamedCell ss:Name="Valid_App_Caps"/>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../this.appCapCategory}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
                <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{../ReferenceModelLayer}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Domains'!C[-7],1,0)),&#34;Business Domain must be already defined in Business Domains sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Application Capabilities'!C[-8],1,0)),&#34;Application Capability must be already defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&#34;Business Capability must be already defined in the Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{/each}}
		  {{/if}}
		  {{/each}}
		  {{#each this}}
		{{#unless this.ParentAppCapability}}
		  {{#unless this.SupportedBusCapability}}
		   {{#unless this.businessDomain}}
		    
		  <Row ss:Height="17">
           <Cell ss:Index="2" ss:StyleID="s1034">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1025">
               <Data ss:Type="String">{{this.name}}</Data>
               <NamedCell ss:Name="Valid_App_Caps"/>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{this.appCapCategory}}</Data>
            </Cell>
            <Cell ss:StyleID="s1105">
                <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1105">
               <Data ss:Type="String">{{this.ReferenceModelLayer}}</Data>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Domains'!C[-7],1,0)),&#34;Business Domain must be already defined in Business Domains sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Application Capabilities'!C[-8],1,0)),&#34;Application Capability must be already defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&#34;Business Capability must be already defined in the Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  
		  		{{/unless}}
		  	{{/unless}}
		  {{/unless}}{{/each}}
		 
	 
		</Table>
		      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TabColorIndex>31</TabColorIndex>
         <Selected/>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <SplitVertical>3</SplitVertical>
         <LeftColumnRightPane>3</LeftColumnRightPane>
         <ActivePane>0</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>1</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>6</ActiveRow>
            </Pane>
            <Pane>
               <Number>0</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>4</ActiveCol>
               <RangeSelection>R8C5:R139C5</RangeSelection>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R1000C6</Range>
         <Type>List</Type>
         <Value>'Business Domains'!R8C3:R1000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R1000C7</Range>
         <Type>List</Type>
         <Value>'Application Capabilities'!R8C3:R1000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R1000C8</Range>
         <Type>List</Type>
         <Value>'Business Capabilities'!R8C3:R1000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C9:R139C9</Range>
         <Type>List</Type>
         <UseBlank/>
         <CellRangeList/>
         <Value>"Left, Right, Middle"</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R139C5</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>"Core, Management, Shared, Enabling"</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3,R6C5,R6C7</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2,R6C4,R6C6,R6C8</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)+COUNTIF(R6C8:R6C8, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C11:R6C11, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C10,R6C12</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C10:R6C10, RC)+COUNTIF(R6C12:R6C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C10:R139C10</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C11:R139C12</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>				
<script id="orgsite-name" type="text/x-handlebars-template">
	<Worksheet ss:Name="Organisation to Sites">
	     <Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="208" ss:Span="1"/>
         <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="180"/>
         <Column ss:AutoFitWidth="0" ss:Width="237"/>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1111">
               <Data ss:Type="String">Organisation to Sites</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110">
               <Data ss:Type="String">Map which organisations use which sites</Data>
            </Cell>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1110"/>
         </Row>
         <Row ss:Height="19">
            <Cell ss:StyleID="s1110"/>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Site</Data>
            </Cell>
            <Cell ss:StyleID="s1159">
               <Data ss:Type="String">Organisation Checker</Data>
            </Cell>
            <Cell ss:StyleID="s1159">
               <Data ss:Type="String">Site Checker</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="4"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-1],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Sites!C[-2],1,0)),&#34;Site must be already defined in Sites sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		{{#each this}}
			 {{#if this.site}}
			 	{{#each this.site}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1112">
               <Data ss:Type="String">{{../this.name}}</Data>
               <NamedCell ss:Name="Organisations"/>
            </Cell>
            <Cell ss:StyleID="s1040">
               <Data ss:Type="String">{{this.name}}</Data>
               <NamedCell ss:Name="Sites"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-1],1,0)),&#34;Organisation must be already defined in Organisations sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
            <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Sites!C[-2],1,0)),&#34;Site must be already defined in Sites sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
			 {{/each}}
			{{/if}}
		{{/each}}
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <TabColorIndex>49</TabColorIndex>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveCol>3</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R790C2</Range>
         <Type>List</Type>
         <Value>'Organisations'!R8C3:R790C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R800C3</Range>
         <Type>List</Type>
         <Value>'Sites'!R8C3:R500C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C4:R59C5</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>
<script id="orgs-name" type="text/x-handlebars-template">
<Worksheet ss:Name="Organisations">	
	<Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1110"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="189"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="293"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="179"/>
         <Column ss:StyleID="s1117" ss:AutoFitWidth="0" ss:Width="75"/>
         <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="164"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:StyleID="s1111">
               <Data ss:Type="String">Organisations</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2">
               <Data ss:Type="String">Capture the organisations and hierarchy/structure</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="19">
            <Cell ss:Index="2" ss:StyleID="s1151">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1151">
               <Data ss:Type="String">Parent Organisation</Data>
            </Cell>
            <Cell ss:StyleID="s1152">
               <Data ss:Type="String">External?</Data>
            </Cell>
            <Cell ss:StyleID="s1159">
               <Data ss:Type="String">Parent Organisation Check</Data>
            </Cell>
         </Row>
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1142">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String"></Data>
				 <NamedCell ss:Name="Organisations"/>
            </Cell>
            <Cell ss:StyleID="s1142">
				<Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String"></Data>
            </Cell>
		  	<Cell ss:StyleID="s1142">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String"></Data>
            </Cell>
         </Row>
		{{#each this}}
			{{#if this.parents}}
				{{#each this.parents}}
	  <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1142">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{../this.name}}</Data>
				 <NamedCell ss:Name="Organisations"/>
            </Cell>
            <Cell ss:StyleID="s1142">
				<Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
		  	<Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{../this.external}}</Data>
            </Cell>
		  <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&#34;Organisation must be already defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		{{/each}}
		{{else}}
		<Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1142">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
				<Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String"></Data>
            </Cell>
		  	<Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{this.external}}</Data>
            </Cell> 
		  <Cell ss:StyleID="s1191"
                  ss:Formula="=IF(RC[-2]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&#34;Organisation must be already defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		
		{{/if}}
		{{/each}}
      </Table>
	 <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <Unsynced/>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <HorizontalResolution>-4</HorizontalResolution>
            <VerticalResolution>-4</VerticalResolution>
         </Print>
         <TopRowVisible>3</TopRowVisible>
         <Panes>
            <Pane>
               <Number>3</Number>
               <ActiveRow>26</ActiveRow>
               <ActiveCol>9</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
	   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R1079C6</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>Valid_True_or_False</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R1079C5</Range>
         <Type>List</Type>
         <Value>'Organisations'!R8C3:R790C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R1079C7</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>				
<script id="table-name" type="text/x-handlebars-template">
	{{#each this}}
		
			
			-{{this.name}}[{{#if this.parents}}{{this.parents.length}} - {{#each this.parents}}{{this.name}}:{{/each}}{{/if}}]<br/>
							
	{{/each}}
				</script>	
<script id="sites-name" type="text/x-handlebars-template">
<Worksheet ss:Name="Sites">	
	<Table ss:ExpandedColumnCount="5" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="65"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="31"/>
         <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="41"/>
         <Column ss:AutoFitWidth="0" ss:Width="205"/>
         <Column ss:AutoFitWidth="0" ss:Width="203"/>
         <Column ss:AutoFitWidth="0" ss:Width="140"/>
         <Row ss:Index="2" ss:AutoFitHeight="0" ss:Height="25">
            <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1111">
               <Data ss:Type="String">Sites</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1056">
               <Data ss:Type="String">Used to capture a list of Sites, including the country in which the Site exists</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="15">
            <Cell ss:Index="2" ss:StyleID="s1141">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Country</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="2" ss:StyleID="s1101"/>
            <Cell ss:StyleID="s1036"/>
            <Cell ss:StyleID="s1036"/>
            <Cell ss:StyleID="s1036"/>
         </Row>
		{{#each this}}
	  <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1142">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
				<Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1142">
               <Data ss:Type="String">{{this.countries.0.name}}</Data>
            </Cell>
         </Row>
		{{/each}}
      </Table>
	<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>2</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
	 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R300C5</Range>
         <Type>List</Type>
         <Value>'Countries'!R8C2:R300C2</Value>
      </DataValidation>
	</Worksheet>
</script>
<script id="processfamilytable-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Business Process Family">
      <Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
		 <Column ss:AutoFitWidth="0" ss:Width="33"/>
       <Column ss:Index="3" ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="172"/>
         <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="294"/>
          <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="198"/>
      <Row>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1111">
               <Data ss:Type="String">Business Process Families</Data>
            </Cell>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
         </Row>
         <Row>
           <Cell ss:Index="2" ss:StyleID="s1057" ss:MergeAcross="5">
               <Data ss:Type="String">Used to group Business Processes into their Family  groupings</Data>
            </Cell>
            
         </Row>
         <Row>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
         </Row>
         <Row>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
         </Row>
         <Row ss:Height="19">
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Ref</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Business Process Family</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Contained Business Processes</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Business Process Check</Data>
            </Cell>
			 
         </Row>
		   <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
				<Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1199"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Business Processes'!C[-3],1,0)),&#34;Business Process must be already defined in Business Process sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row> 
		   {{#each this}}
		  {{#if this.containedProcesses}}
			{{#each this.containedProcesses}}
           
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
				<Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1199"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Business Processes'!C[-3],1,0)),&#34;Business Process must be already defined in Business Process sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row> 
   
		  {{/each}}
		 
		  {{else}}
		 <Row ss:AutoFitHeight="0" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <NamedCell ss:Name="Valid_Bus_Doms"/>
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Business Processes'!C[-3],1,0)),&#34;Business Process must be already defined in Business Process sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{/if}}
     	{{/each}}  
      </Table>
    <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
        
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R27C5</Range>
         <Type>List</Type>
         <Value>'Business Processes'!R8C3:R400C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3,R6C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2,R6C4</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R27C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
 
   </Worksheet>				
				
				
</script>					
<script id="processtable-name" type="text/x-handlebars-template">
	 <Worksheet ss:Name="Business Processes">
	<Table ss:ExpandedColumnCount="12" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="33"/>
         <Column ss:Index="3" ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="172"/>
         <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="294"/>
         <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="198" ss:Span="3"/>
         <Column ss:Index="9" ss:AutoFitWidth="0" ss:Width="147" ss:Span="3"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2"  ss:StyleID="s1289" ss:MergeAcross="5">
               <Data ss:Type="String">Business Processes</Data>
            </Cell>
			   
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1057" ss:MergeAcross="5">
               <Data ss:Type="String">Captures the Business processes and their relationship to the business capabilities.</Data>
            </Cell>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
         </Row>
         <Row>
            <Cell ss:Index="2" ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
            <Cell ss:StyleID="s1289"/>
         </Row>
         <Row ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1141">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Parent Capability 1</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Parent Capability 2</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Parent Capability 3</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Parent Capability 4</Data>
            </Cell>
            <Cell ss:StyleID="s1057">
               <Data ss:Type="String">Check Parent Capability 1</Data>
            </Cell>
            <Cell ss:StyleID="s1057">
               <Data ss:Type="String">Check Parent Capability 2</Data>
            </Cell>
            <Cell ss:StyleID="s1057">
               <Data ss:Type="String">Check Parent Capability 3</Data>
            </Cell>
            <Cell ss:StyleID="s1057">
               <Data ss:Type="String">Check Parent Capability 4</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
            <Cell ss:Index="2" ss:StyleID="s1160">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
               <NamedCell ss:Name="Valid_Business_Processes"/>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
             <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
             <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
             <Cell ss:StyleID="s1229">
               <Data ss:Type="String"> </Data>
            </Cell>
         </Row>
		{{#each this}}
			{{#if this.parentCaps}}
				{{#each this.parentCaps}}
		    <Row ss:AutoFitHeight="0" ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.name}}</Data>
               <NamedCell ss:Name="Valid_Business_Processes"/>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-6],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-7],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-8],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
         </Row>
				{{/each}}
		
		{{else}}
		 <Row ss:AutoFitHeight="0" ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{this.name}}</Data>
               <NamedCell ss:Name="Valid_Business_Processes"/>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"> </Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-6],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-7],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-8],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-4]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&#34;Parent Capability must be already defined Business Capabilities sheet&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
         </Row>
		{{/if}}
		{{/each}}
			
	</Table>
	   <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <HorizontalResolution>-4</HorizontalResolution>
            <VerticalResolution>-4</VerticalResolution>
         </Print>
         
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R1000C5,R8C6:R1000C6,R8C7:R1000C7,R8C8:R1000C8</Range>
         <Type>List</Type>
         <Value>'Business Capabilities'!R8C3:R1000C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C9:R314C12</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
	</Worksheet>
</script>					
<script id="domtable-name" type="text/x-handlebars-template">
 <Worksheet ss:Name="Business Domains">
      <Table ss:ExpandedColumnCount="7" x:FullColumns="1" x:FullRows="1"
             ss:DefaultColumnWidth="66"
             ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="44" ss:Span="1"/>
         <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="155"/>
         <Column ss:AutoFitWidth="0" ss:Width="337"/>
         <Column ss:AutoFitWidth="0" ss:Width="166"/>
         <Column ss:AutoFitWidth="0" ss:Width="170"/>
         <Row ss:Index="2" ss:Height="29">
            <Cell ss:Index="2" ss:MergeAcross="5" ss:StyleID="s1289">
               <Data ss:Type="String">Business Domains</Data>
            </Cell>
         </Row>
       <Row>
            <Cell ss:Index="2" ss:MergeAcross="5" ss:StyleID="s1056">
               <Data ss:Type="String">Used to capture the Business Domains in scope</Data>
            </Cell>
         </Row>
         <Row ss:Index="6" ss:Height="20">
            <Cell ss:Index="2" ss:StyleID="s1056">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1056">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1056">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1056">
               <Data ss:Type="String">Parent Business Domain</Data>
            </Cell>
            <Cell ss:StyleID="s1056">
               <Data ss:Type="String">Check Parent Domain</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8">
            <Cell ss:Index="2" ss:StyleID="s1050"/>
            <Cell ss:StyleID="s1050"/>
            <Cell ss:StyleID="s1050"/>
            <Cell ss:StyleID="s1050"/>
            <Cell ss:StyleID="s1050"/>
         </Row>
		 {{#each this}}
		  {{#if this.parentDomain}}
			{{#each this.parentDomain}}
         <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <NamedCell ss:Name="Valid_Bus_Doms"/>
               <Data ss:Type="String">{{../this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{../this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Business Domains'!C[-3],1,0)),&#34;Parent must be defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{/each}}
		 
		  {{else}}
		  <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1050">
               <Data ss:Type="String">{{this.id}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <NamedCell ss:Name="Valid_Bus_Doms"/>
               <Data ss:Type="String">{{this.name}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String">{{this.description}}</Data>
            </Cell>
            <Cell ss:StyleID="s1050">
               <Data ss:Type="String"></Data>
            </Cell>
            <Cell ss:StyleID="s1057"
                  ss:Formula="=IF(RC[-1]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-1],'Business Domains'!C[-3],1,0)),&#34;Parent must be defined in column C&#34;,&#34;OK&#34;)),&#34;&#34;)">
               <Data ss:Type="String"/>
            </Cell>
         </Row>
		  {{/if}}
     	{{/each}} 
      </Table>
      <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>6</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveRow>7</ActiveRow>
               <ActiveCol>4</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R2007C5</Range>
         <Type>List</Type>
         <Value>'Business Domains'!R8C3:R400C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3,R6000C5</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2,R6C4</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R27C6</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
   </Worksheet>				
				
				
</script>					
<script id="captable-name" type="text/x-handlebars-template">
<Worksheet ss:Name="Business Capabilities">	
	<Table ss:ExpandedColumnCount="12" x:FullColumns="1" x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
         <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="35"/>
         <Column ss:Index="3" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="188"/>
         <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="291"/>
         <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="125" ss:Span="1"/>
         <Column ss:Index="7" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="130"/>
         <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="172"/>
         <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="122"/>
         <Column ss:Index="11" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="226"/>
         <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="240"/>
         <Row ss:Height="20">
            <Cell ss:Index="8" ss:StyleID="s1155">
               <Data ss:Type="String">Checks</Data>
            </Cell>
            <Cell ss:StyleID="s1156"/>
         </Row>
         <Row ss:Height="29">
            <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1292">
               <Data ss:Type="String">Business Capabilities</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="21">
            <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1057">
               <Data ss:Type="String">Used to capture the business capabilities of your organisation.  Some columns are also required to set up the view layout</Data>
            </Cell>
            <Cell ss:Index="8" ss:StyleID="s1157">
               <Data ss:Type="String">Root Capability</Data>
            </Cell>
            <Cell ss:MergeAcross="2" ss:StyleID="s1057"
                  ss:Formula="=IF((COUNTA(C[-1])&gt;6),&#34;ERROR: Only one root node should be defined&#34;,&#34;OK&#34;)">
               <Data ss:Type="String">OK</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="102">
            <Cell ss:Index="8">
               <Data ss:Type="String">Position in Parent</Data>
            </Cell>
            <Cell ss:MergeAcross="2" ss:StyleID="s1057"
                  ss:Formula="=IF((COUNTA(C[-3]))&gt;((COUNTA(C[-6])*0.2)),&#34;You only need to define position in parent for the top level capabilities against the root capability, just check these are OK&#34;,&#34;OK&#34;)">
               <Data ss:Type="String">You only need to define position in parent for the top level capabilities against the root capability, just check these are OK</Data>
            </Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="15"/>
         <Row ss:AutoFitHeight="0" ss:Height="37">
            <Cell ss:Index="2" ss:StyleID="s1141">
               <Data ss:Type="String">ID</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Description</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Parent Business Capability</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Position in Parent</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Sequence Number</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Root Capability</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Business Domain</Data>
            </Cell>
            <Cell ss:StyleID="s1141">
               <Data ss:Type="String">Level</Data>
            </Cell>
            <Cell ss:StyleID="s1159">
               <Data ss:Type="String">Parent Capability Check</Data>
            </Cell>
            <Cell ss:StyleID="s1159">
               <Data ss:Type="String">Business Domain Check</Data>
            </Cell>
         </Row>
         <Row ss:Height="20" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
	<Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
	{{#each this}}
	{{#if this.parentBusinessCapability}}
			{{#each this.parentBusinessCapability}}
	<Row ss:Height="20" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.name}}</Data><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.description}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.positioninParent}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.sequenceNumber}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.rootCapability}}</Data></Cell>
	<Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.businessDomain}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{../this.level}}</Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
		 {{/each}}
		{{else}}
		 
		<Row ss:Height="20" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.name}}</Data><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.description}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.parentBusinessCapability}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.positioninParent}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.sequenceNumber}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.rootCapability}}</Data></Cell>
	<Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.businessDomain}}</Data></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">{{this.level}}</Data></Cell>
{{#if this.rootCapability}}
    <Cell ss:StyleID="s1050"><Data
      ss:Type="String">Root Set</Data></Cell>
    <Cell ss:StyleID="s1050"><Data
      ss:Type="String">Root Set</Data></Cell>
	{{else}}
	<Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
	{{/if}}		
   </Row>
		 	
		{{/if}}				
{{/each}}
		  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <Print>
            <ValidPrinterInfo/>
            <PaperSizeIndex>9</PaperSizeIndex>
            <VerticalResolution>0</VerticalResolution>
         </Print>
         <LeftColumnVisible>1</LeftColumnVisible>
         <FreezePanes/>
         <FrozenNoSplit/>
         <SplitHorizontal>6</SplitHorizontal>
         <TopRowBottomPane>7</TopRowBottomPane>
         <ActivePane>2</ActivePane>
         <Panes>
            <Pane>
               <Number>3</Number>
            </Pane>
            <Pane>
               <Number>2</Number>
               <ActiveCol>4</ActiveCol>
            </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
      </WorksheetOptions>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C5:R1000C5,R8C8:R1000C8</Range>
         <Type>List</Type>
         <Value>'Business Capabilities'!R8C3:R1000C3</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R127C6</Range>
         <Type>List</Type>
         <Value>&quot;Front, Manage, Back&quot;</Value>
      </DataValidation>
      <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C9:R1270C9</Range>
         <Type>List</Type>
         <Value>'Business Domains'!R8C3:R300C3</Value>
      </DataValidation>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C3,R6C10,R6C5,R6C7</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C10:R6C10, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C2,R6C4,R6C6,R6C8:R6C9</Range>
         <Condition>
            <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)+COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R7C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R7C3:R7C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R127C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R127C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
         <Condition>
            <Value1>AND(COUNTIF(R127C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R127C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R127C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R127C3</Range>
         <Condition>
            <Value1>AND(COUNTIF(R8C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>
      <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C11:R127C12</Range>
         <Condition>
            <Value1>ISERROR(SEARCH("OK",RC))</Value1>
            <Format Style="color:#9C0006;background:#FFC7CE"/>
         </Condition>
      </ConditionalFormatting>	
	</Worksheet>	
</script>		
</body>
<script>
 <xsl:call-template name="RenderViewerAPIJSFunction">
        <xsl:with-param name="viewerAPIPath" select="$apiPathBusinessCaps"/>
	 	<xsl:with-param name="viewerAPIPathBD" select="$apiPathBusinessDomains"/>
	 	<xsl:with-param name="viewerAPIPathBP" select="$apiPathBusinessProcesses"/>
	 	<xsl:with-param name="viewerAPIPathBPF" select="$apiPathBusinessProcessFamilies"/>
	 	<xsl:with-param name="viewerAPIPathSites" select="$apiPathSites"/>
	 	<xsl:with-param name="viewerAPIPathOrgs" select="$apiPathOrgs"/>
	 	<xsl:with-param name="viewerAPIPathAppCaps" select="$apiPathAppCaps"/>
	 	<xsl:with-param name="viewerAPIPathAppSvcs" select="$apiPathAppSvcs"/>
	 	<xsl:with-param name="viewerAPIPathAppCap2Svcs" select="$apiPathAppCap2Svcs"/>
	 	<xsl:with-param name="viewerAPIPathApps" select="$apiPathApps"/>
	 	<xsl:with-param name="viewerAPIPathApp2Svcs" select="$apiPathApp2Svcs"/>
	 	<xsl:with-param name="viewerAPIPathApp2orgs" select="$apiPathApp2orgs"/>
	 	<xsl:with-param name="viewerAPIPathBPtoAppsSvc" select="$apiPathBPtoAppsSvc"/>
	 	<xsl:with-param name="viewerAPIPathPPtoAppsViaSvc" select="$apiPathPPtoAppsViaSvc"/>
	 	<xsl:with-param name="viewerAPIPathPPtoApps" select="$apiPathPPtoApps"/>
	 	<xsl:with-param name="viewerAPIPathInfoRep" select="$apiPathInfoRep"/>
        <xsl:with-param name="viewerAPIPathTechCap" select="$apiPathTechCap"/>
	 	<xsl:with-param name="viewerAPIPathTechDomains" select="$apiPathTechDomains"/>
	 	<xsl:with-param name="viewerAPIPathApptoServer" select="$apiPathApptoServer"/>
	 	<xsl:with-param name="viewerAPIPathNodes" select="$apiPathNodes"/>
        <xsl:with-param name="viewerAPIPathTechComp" select="$apiPathTechComp"/>
	 	<xsl:with-param name="viewerAPIPathTechSupplier" select="$apiPathTechSupplier"/>
	 	<xsl:with-param name="viewerAPIPathTechProd" select="$apiPathTechProd"/> 
	 	<xsl:with-param name="viewerAPIPathTechProdOrg" select="$apiPathTechProdOrg"/> 
	 	<xsl:with-param name="viewerAPIPathTechProdFamily" select="$apiPathTechProdFamily"/> 
	 	<xsl:with-param name="viewerAPIPathDataSubject" select="$apiPathDataSubject"/> 
	 	<xsl:with-param name="viewerAPIPathDataObject" select="$apiPathDataObject"/> 
	 	<xsl:with-param name="viewerAPIPathDataObjectAttributes" select="$apiPathDataObjectAttributes"/> 
	 	<xsl:with-param name="viewerAPIPathDataObjectInherit" select="$apiPathDataObjectInherit"/> 
	 	<xsl:with-param name="viewerAPIPathAppDependency" select="$apiPathDataAppDependency"/>  
	 	<xsl:with-param name="viewerAPIPathApptoTech" select="$apiPathDataApptoTech"/> 
	   
 </xsl:call-template>
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
        <xsl:param name="viewerAPIPath"/>
		<xsl:param name="viewerAPIPathBD"/>
		<xsl:param name="viewerAPIPathBP"/> 
		<xsl:param name="viewerAPIPathBPF"/>
		<xsl:param name="viewerAPIPathSites"/>
		<xsl:param name="viewerAPIPathOrgs"/> 
		<xsl:param name="viewerAPIPathAppCaps"/> 
		<xsl:param name="viewerAPIPathAppSvcs"/> 
		<xsl:param name="viewerAPIPathAppCap2Svcs"/>  
		<xsl:param name="viewerAPIPathApps"/> 
		<xsl:param name="viewerAPIPathApp2Svcs"/> 
		<xsl:param name="viewerAPIPathApp2orgs"/> 
		<xsl:param name="viewerAPIPathBPtoAppsSvc"/> 
		<xsl:param name="viewerAPIPathPPtoAppsViaSvc"/> 
		<xsl:param name="viewerAPIPathPPtoApps"/>
        <xsl:param name="viewerAPIPathInfoRep"/>
        <xsl:param name="viewerAPIPathTechCap"/>
	 	<xsl:param name="viewerAPIPathTechDomains"/>
	 	<xsl:param name="viewerAPIPathApptoServer"/>
	 	<xsl:param name="viewerAPIPathNodes"/>
        <xsl:param name="viewerAPIPathTechComp"/>
	 	<xsl:param name="viewerAPIPathTechSupplier"/>
	 	<xsl:param name="viewerAPIPathTechProd"/>
		<xsl:param name="viewerAPIPathTechProdOrg"/>
	 	<xsl:param name="viewerAPIPathTechProdFamily"/>
		<xsl:param name="viewerAPIPathDataObject"/>
	 	<xsl:param name="viewerAPIPathDataSubject"/> 
		<xsl:param name="viewerAPIPathDataObjectInherit"/> 
		<xsl:param name="viewerAPIPathDataObjectAttributes"/> 
		<xsl:param name="viewerAPIPathAppDependency"/> 
		 <xsl:param name="viewerAPIPathApptoTech"/>
		 
		
  
        //a global variable that holds the data returned by an Viewer API Report
		var viewCheck = 'report?XML=reportXML.xml&amp;XSL=&amp;cl=en-gb'; 
        var viewAPIDataBusCaps = '<xsl:value-of select="$viewerAPIPath"/>';
  		var viewAPIDataBusDoms = '<xsl:value-of select="$viewerAPIPathBD"/>';
		var viewAPIDataBusProcs = '<xsl:value-of select="$viewerAPIPathBP"/>'; 
		var viewAPIDataBusProcFams = '<xsl:value-of select="$viewerAPIPathBPF"/>'; 
		var viewAPIDataSites = '<xsl:value-of select="$viewerAPIPathSites"/>'; 	
		var viewAPIDataOrgs = '<xsl:value-of select="$viewerAPIPathOrgs"/>'; 	
		var viewAPIDataAppCaps ='<xsl:value-of select="$viewerAPIPathAppCaps"/>';
		var viewAPIDataAppSvcs ='<xsl:value-of select="$viewerAPIPathAppSvcs"/>'; 
		var viewAPIDataAppCap2Svcs ='<xsl:value-of select="$viewerAPIPathAppCap2Svcs"/>';
		var viewAPIDataApps ='<xsl:value-of select="$viewerAPIPathApps"/>';  
		var viewAPIDataApps2Svcs ='<xsl:value-of select="$viewerAPIPathApp2Svcs"/>'; 
		var viewAPIDataApps2orgs ='<xsl:value-of select="$viewerAPIPathApp2orgs"/>'; 
		var viewAPIDataBPtoAppsSvc ='<xsl:value-of select="$viewerAPIPathBPtoAppsSvc"/>'; 
		var viewAPIDataPPtoAppsViaSvc ='<xsl:value-of select="$viewerAPIPathPPtoAppsViaSvc"/>'; 
		var viewAPIDataPPtoApps ='<xsl:value-of select="$viewerAPIPathPPtoApps"/>'; 
		var viewAPIDataInfoRep ='<xsl:value-of select="$viewerAPIPathInfoRep"/>'; 
		var viewAPIDataTechCap ='<xsl:value-of select="$viewerAPIPathTechCap"/>'; 
		var viewAPIDataTechDomains ='<xsl:value-of select="$viewerAPIPathTechDomains"/>'; 
		var viewAPIDataApptoServer ='<xsl:value-of select="$viewerAPIPathApptoServer"/>'; 
		var viewAPIDataNodes ='<xsl:value-of select="$viewerAPIPathNodes"/>';          
        var viewAPIDataTechComp ='<xsl:value-of select="$viewerAPIPathTechComp"/>';   
        var viewAPIDataTechSupplier ='<xsl:value-of select="$viewerAPIPathTechSupplier"/>';   
        var viewAPIDataTechProd ='<xsl:value-of select="$viewerAPIPathTechProd"/>';
		var viewAPIDataTechProdOrg ='<xsl:value-of select="$viewerAPIPathTechProdOrg"/>';
		var viewAPIDataDataSubject ='<xsl:value-of select="$viewerAPIPathDataSubject"/>';
		var viewAPIDataDataObject ='<xsl:value-of select="$viewerAPIPathDataObject"/>'; 
		var viewAPIDataDataObjectInherit ='<xsl:value-of select="$viewerAPIPathDataObjectInherit"/>'; 
		var viewAPIDataDataObjectAttribute ='<xsl:value-of select="$viewerAPIPathDataObjectAttributes"/>'; 
		var viewAPIDataTechProdFamily = '<xsl:value-of select="$viewerAPIPathTechProdFamily"/>' 
		var viewAPIDataAppDependency ='<xsl:value-of select="$viewerAPIPathAppDependency"/>'  
		var viewAPIPathApptoTech ='<xsl:value-of select="$viewerAPIPathApptoTech"/>'    
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            <!--$('#ess-data-gen-alert').hide();-->
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
        var applicationTechArch={};
	var applicationDependencies={};
	var dataObjectAttributes={};
	var dataObjectInheritance={};
	var dataObjects={};
	var dataSubjects={};
	var techProductOrg={};
	var techProductFamilies={};
    var techProducts={};
    var techSuppliers={};
    var techCaps={};
	var techComponents={};
	var nodes={};
    var techDomains={};
    var app2server={};
	var infoReps={}
	var processtoapps={} 
	var processtoservice={}
	var app2org={}
	var app2svcs={} 
	var apps={};
 	var appService={};
	var appCap2Service={};
	var appCaps={};
	var orgs={};
	var sites={};
	var businessProcessFamilies={};
	var businessCapabilities = {};
	var businessDomains = {};
	var businessProcesses = {}; 
        
        
  $('document').ready(function () {
     
$('#busCapsWorksheetCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 4;
		})
      worksheetList = workingWL;
      $('#busDomi').hide(); 
   } else {
      $('#busDomi').show(); 
      if ($.isEmptyObject(businessCapabilities)) {    
      
		 if(viewAPIDataBusCaps==viewCheck){
			 businessCapabilities = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":2,"name":buscaptableTemplate(businessCapabilities)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataBusCaps)
				.then(function(response1) {
		 		$('#bc').css('color','#0aa20a')
					businessCapabilities = response1;
					worksheetList.push({
						"id": 4,
						"name": buscaptableTemplate(businessCapabilities.businessCapabilities)
					});
				}).catch(function(error) {
					alert('Error - check you have the Core API: Import Business Capabilities Data API set up')
				});
		 }
		} else {
			worksheetList.push({
				"id": 4,
				"name": buscaptableTemplate(businessCapabilities.businessCapabilities)
			})
		}
	}
		 
})
	
$('#busDomWorksheetCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 2;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(businessDomains)) {
		if(viewAPIDataBusDoms==viewCheck){
			 businessDomains = [{'description': '', 'name': '', parentDomain: [], subDomain: []}];
		 
		  worksheetList.push({"id":4,"name":busdomtableTemplate(businessDomains)});
			 }else
		 {  
		 
			 return promise_loadViewerAPIData(viewAPIDataBusDoms)
            .then(function(response1) {
		 		$('#bd').css('color','#0aa20a') 
		 
		 	 
           		businessDomains =response1;
 
		 	businessDomains.businessDomains.forEach(function(d){
				d.subDomain.forEach(function(sd){

				 var subdomain=businessDomains.businessDomains.forEach(function(e){
						var pd=e['parentDomain'];
						if(e.name==sd.name){pd.push({"name":d.name})}

						});
					});
				});
	
		 worksheetList.push({"id":2,"name":busdomtableTemplate(businessDomains.businessDomains)});		 
            }).catch (function (error) {
		 	 	alert('Error - check you have the Core API: Import Business Domains Data API set up')
            })
		 ////console.log('businessDomains');	////console.log(businessDomains)
			 }		
		} else {
			worksheetList.push({
				"id": 2,
				"name": busdomtableTemplate(businessDomains.businessDomains)
			})
		}
	}
////console.log(worksheetList)		 
})		 
		 
   
$('#busProcsWorksheetCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 5;
		})
      worksheetList = workingWL;
      $('#busCapsi').hide();       
   } else {
      $('#busCapsi').show();       
      if ($.isEmptyObject(businessProcesses)) {
      
		 if(viewAPIDataBusProcs==viewCheck){
			 businessProcesses = [{'description': '', 'name': '', parentDomain: [], subDomain: []}];
		 
		  worksheetList.push({"id":5,"name":busprocesstableTemplate(businessProcesses)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataBusProcs)
            .then(function(response1) {
		 		$('#bp').css('color','#0aa20a')  
           		businessProcesses =response1;
		 		////console.log('businessProcesses');
		 		////console.log(businessProcesses)
		 	 worksheetList.push({"id":5,"name": busprocesstableTemplate(businessProcesses.businessProcesses)});		
		
            }).catch (function (error) {
		 		alert('Error - check you have the Core API: Import Business Processes Data API set up')
            })
		 }
		} else {
			worksheetList.push({
				"id": 5,
				"name": busprocesstableTemplate(businessProcesses.businessProcesses)
			})
		}
	}
//console.log(worksheetList)		 
}); 

$('#busProcsFamilyWorksheetCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 7;
		})
      worksheetList = workingWL;
      $('#busProcsi').hide();    
   } else {
      $('#busProcsi').show(); 
      if ($.isEmptyObject(businessProcessFamilies)) {
         
		  if(viewAPIDataBusProcFams==viewCheck){
			 businessProcessFamilies = [{'description': '', 'name': '', parentDomain: [], subDomain: []}];
		 
		  worksheetList.push({"id":7,"name":busprocessfamilytableTemplate(businessProcessFamilies)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataBusProcFams)
            .then(function(response1) {
		 		$('#bpf').css('color','#0aa20a')  
           		businessProcessFamilies =response1;
		 		//console.log('businessProcessFamilies');
		 		//console.log(businessProcessFamilies)
		 	 worksheetList.push({"id":7,"name": busprocessfamilytableTemplate(businessProcessFamilies.businessProcessFamilies)});		
            }).catch (function (error) {
		 		alert('Error - check you have the Core API: Import Business Process Families Data API set up')
            });
		 }
		} else {
			worksheetList.push({
				"id": 7,
				"name": busprocessfamilytableTemplate(businessProcessFamilies.businessProcessFamilies)
			})
		}
	}
//console.log(worksheetList)		 
})		 	 

		 
$('#sitesCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 1;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(sites)) {
		   if(viewAPIDataSites==viewCheck){
			 site = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":1,"name":sitetableTemplate(site)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataSites)
					.then(function(response1) {
		 			$('#st').css('color','#0aa20a') 
						sites =response1;
						//console.log('sites');
						//console.log(sites)
					 worksheetList.push({"id":1,"name": sitetableTemplate(sites.sites)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Sites Data API set up')
					}); 
		 }
		} else {
			worksheetList.push({
				"id": 1,
				"name": sitetableTemplate(sites.sites)
			})
		}
	}
//console.log(worksheetList)		 
})		 
		 

$('#orgsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 10;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(orgs)) {
		   if(viewAPIDataOrgs==viewCheck){
			 orgs = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":10,"name":orgtableTemplate(orgs)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataOrgs)
					.then(function(response1) {
		 				$('#or').css('color','#0aa20a')  
						orgs =response1;
						//console.log('orgs');
						//console.log(orgs)
					 worksheetList.push({"id":10,"name": orgtableTemplate(orgs.organisations)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Org Data API set up')
					}); 
		 }
		} else {
			worksheetList.push({
				"id": 10,
				"name": orgtableTemplate(orgs.organisations)
			})
		}
	}
//console.log(worksheetList)		 
})			
		 
$('#orgs2sitesCheck').on("change", function() {
   var boxState = $(this).prop("checked");


	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 12;
		})
      worksheetList = workingWL;
      $('#sitesi').hide(); 
      $('#orgsi').hide() ;
   } else {
      $('#sitesi').show();
      $('#orgsi').show();
		if ($.isEmptyObject(orgs)) {
		 if(viewAPIDataOrgs==viewCheck){
			 orgs = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":12,"name":orgsitetableTemplate(orgs)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataOrgs)
					.then(function(response1) {
		 				$('#ors').css('color','#0aa20a')  
						orgs =response1;
						//console.log('orgs');
						//console.log(orgs)
		 $('#ors').css('color','#0aa20a')  
					 worksheetList.push({"id":12,"name": orgsitetableTemplate(orgs.organisations)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Org Data API set up')
					});
		 }
		} else {
		  $('#ors').css('color','#0aa20a')
			worksheetList.push({
				"id": 12,
				"name": orgsitetableTemplate(orgs.organisations)
			})
		}
	}
//console.log(worksheetList)		 
})		
	
$('#appCapsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 15;
		})
      worksheetList = workingWL;
      $('#busCapsi').hide();
   } else {
      $('#busCapsi').show();   
      if ($.isEmptyObject(appCaps)) {
		  if(viewAPIDataAppCaps==viewCheck){
			 appcap = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":15,"name":appCaptableTemplate(appcap)});
			 }
		 else
		 {
		 if(viewAPIDataAppCaps==viewCheck){
			 appcap = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":15,"name":appCaptableTemplate(appcap)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataAppCaps)
					.then(function(response1) {
		 				$('#ac').css('color','#0aa20a')   
						appCaps =response1;
						//console.log('appCaps');
						//console.log(appCaps)
					 worksheetList.push({"id":15,"name": appCaptableTemplate(appCaps.application_capabilities)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import App Caps Data API set up')
					});  
		 }
		 }
		} else {
			worksheetList.push({
				"id": 15,
				"name": appCaptableTemplate(appCaps.application_capabilities)
			})
		}
	}
//console.log(worksheetList)		 
})				 
 
$('#appSvcsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 16;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(appService)) {
		 if(viewAPIDataAppSvcs==viewCheck){
			 appService = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":16,"name":appSvctableTemplate(appService)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataAppSvcs)
					.then(function(response1) {
		 				$('#as').css('color','#0aa20a')  
						appService =response1;
						//console.log('appService');
						//console.log(appService)
					 worksheetList.push({"id":16,"name": appSvctableTemplate(appService.application_services)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import App Service Data API set up')
					}); 
		 }
		} else {
			worksheetList.push({
				"id": 16,
				"name": appSvctableTemplate(appService.application_services)
			})
		}
	}
//console.log(worksheetList)		 
});
		 
$('#appCaps2SvcsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 18;
		})
		worksheetList = workingWL;
      $('#appSvcsi').hide(); 
      $('#appCapsi').hide(); 
	} else {
      $('#appSvcsi').show(); 
      $('#appCapsi').show(); 
		if ($.isEmptyObject(appCap2Service)) {
		 if(viewAPIDataAppCap2Svcs==viewCheck){
			 appCap2Service = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":18,"name":appCap2SvctableTemplate(appCap2Service)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataAppCap2Svcs)
					.then(function(response1) {
		 			$('#ac2s').css('color','#0aa20a')  
						appCap2Service =response1;
						//console.log('appCap2Service');
						//console.log(appCap2Service);
					 worksheetList.push({"id":18,"name": appCap2SvctableTemplate(appCap2Service.application_capabilities_services)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import App Service Data API set up')
					});
		 }
		} else {
			worksheetList.push({
				"id": 18,
				"name": appCap2SvctableTemplate(appCap2Service.application_capabilities_services)
			})
		}
	}
//console.log(worksheetList)		 
})
		 
$('#appsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 20;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(apps)) {
		 if(viewAPIDataApps==viewCheck){
			 apps = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":20,"name":appstableTemplate(apps)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataApps)
					.then(function(response1) {
		 				$('#aps').css('color','#0aa20a')  
                  apps =response1; 
                  apps.applications=apps.applications.filter((d)=>{
                     return d.class=='Composite_Application_Provider';
                  }) 
						 console.log('apps');
						 console.log(apps); 
					 worksheetList.push({"id":20,"name": appstableTemplate(apps.applications)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Appplication API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 20,
				"name": appstableTemplate(apps.applications)
			})
		}
	}
//console.log(worksheetList)		 
})		 
 
$('#apps2svcsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 23;
		})
		worksheetList = workingWL;
      $('#appSvcsi').hide(); 
      $('#appsi').hide(); 
	} else {
      $('#appSvcsi').show(); 
      $('#appsi').show(); 
		if ($.isEmptyObject(app2svcs)) {
		  if(viewAPIDataApps2Svcs==viewCheck){
			 app2svcs = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":23,"name":apps2svcstableTemplate(app2svcs)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataApps2Svcs)
					.then(function(response1) {
		 				$('#aps2sv').css('color','#0aa20a')   
						app2svcs =response1;
						//console.log('apps2svc');
						//console.log(app2svcs);
					 worksheetList.push({"id":23,"name": apps2svcstableTemplate(app2svcs.applications_to_services)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import App Service Data API set up')
					});
		 }
		} else {
			worksheetList.push({
				"id": 23,
				"name": apps2svcstableTemplate(app2svcs.applications_to_services)
			})
		}
	}
//console.log(worksheetList)		 
})		 
   	 

$('#apps2orgsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 25;
		})
		worksheetList = workingWL;
      $('#orgsi').hide(); 
      $('#appsi').hide(); 
	} else {
      $('#orgsi').show(); 
      $('#appsi').show(); 
		if ($.isEmptyObject(app2org)) {
		 if(viewAPIDataApps2orgs==viewCheck){
			 app2org = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":25,"name":apps2orgtableTemplate(app2org)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataApps2orgs)
					.then(function(response1) {
					 $('#aps2or').css('color','#0aa20a')  
						app2org =response1; 
						//console.log(app2org);
					 worksheetList.push({"id":25,"name": apps2orgtableTemplate(app2org.applications_to_orgs)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import App to Organisation Data API set up')
					}); 
		 }
		} else {
			worksheetList.push({
				"id": 25,
				"name": apps2orgtableTemplate(app2org.applications_to_orgs)
			})
		}
	}
//console.log(worksheetList)		 
})			
		  
		
		       	
$('#busProc2SvcsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 27;
		})
		worksheetList = workingWL;
      $('#busProcsi').hide(); 
      $('#appsi').hide(); 
	} else {
      $('#busProcsi').show(); 
      $('#appsi').show(); 
		if ($.isEmptyObject(processtoservice)) {
		 if(viewAPIDataBPtoAppsSvc==viewCheck){
			 processtoservice = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":27,"name":bp2appsvctableTemplate(processtoservice)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataBPtoAppsSvc)
					.then(function(response1) {
		 				$('#bp2srvs').css('color','#0aa20a') 
						processtoservice =response1; 
						//console.log('processtoservice');
		 				//console.log(processtoservice);
					 worksheetList.push({"id":27,"name": bp2appsvctableTemplate(processtoservice.process_to_service)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Business Process to App via Service Data API set up')
					});    
		 }
		} else {
			worksheetList.push({
				"id": 27,
				"name": bp2appsvctableTemplate(processtoservice.process_to_service)
			})
		}
	}
//console.log(worksheetList)		 
})		
		 
$('#physProc2AppVsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 30;
		})
		worksheetList = workingWL;
      $('#busProcsi').hide(); 
      $('#orgsi').hide(); 
      $('#apps2svcsi').hide();
	} else {
      $('#busProcsi').show(); 
      $('#orgsi').show(); 
      $('#apps2svcsi').show();
		if ($.isEmptyObject(processtoapps)) {
		 if(viewAPIDataBPtoAppsSvc==viewCheck){
			 processtoapps = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":30,"name":pp2appviasvctableTemplate(processtoapps)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataPPtoAppsViaSvc)
					.then(function(response1) {
		 				$('#phyp2appsv').css('color','#0aa20a')   
						processtoapps =response1; 
						//console.log(processtoapps);  
					 worksheetList.push({"id":30,"name": pp2appviasvctableTemplate(processtoapps.process_to_apps)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Physical Process to App via Service Data API set up')
					});   
		 }
		} else {
			worksheetList.push({
				"id": 30,
				"name": pp2appviasvctableTemplate(processtoapps.process_to_apps)
			})
		}
	}
//console.log(worksheetList)		 
})		 
		

$('#physProc2AppCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 32;
		})
		worksheetList = workingWL;
      $('#busProcsi').hide(); 
      $('#orgsi').hide(); 
      $('#appsi').hide();
	} else {
      $('#busProcsi').show(); 
      $('#orgsi').show(); 
		if ($.isEmptyObject(processtoapps)) {
		 if(viewAPIDataPPtoAppsViaSvc==viewCheck){
			 processtoapps = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":32,"name":pp2apptableTemplate(processtoapps)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataPPtoAppsViaSvc)
					.then(function(response1) {
		 				$('#phyp2appdirect').css('color','#0aa20a')  
						processtoapps =response1;
						//console.log('processtoapps');
						//console.log(processtoapps);
					 worksheetList.push({"id":32,"name": pp2apptableTemplate(processtoapps.process_to_apps)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Physical Process to App Data API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 32,
				"name": pp2apptableTemplate(processtoapps.process_to_apps)
			})
		}
	}
//console.log(worksheetList)		 
})	
		 
$('#infoExchangedCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 33;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(infoReps)) {
		  if(viewAPIDataInfoRep==viewCheck){
			 infoReps = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":33,"name":infoReptableTemplate(infoReps)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataInfoRep)
					.then(function(response1) {
		 				$('#infex').css('color','#0aa20a')   
						infoReps =response1;
						//console.log('infoReps');
						//console.log(infoReps);
					 worksheetList.push({"id":33,"name": infoReptableTemplate(infoReps.infoReps)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Physical Process to App Data API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 33,
				"name": infoReptableTemplate(infoReps.infoReps)
			})
		}
	}
//console.log(worksheetList)		 
})	
		 
$('#techCapsCheck').on("change", function() {
		 
	//console.log('techcaps')	 
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 45;
		})
		worksheetList = workingWL;
      $('#techDomsi').hide(); 
       
	} else {
      $('#techDomsi').show(); 
		if ($.isEmptyObject(techCaps)) {
		 if(viewAPIDataTechCap==viewCheck){
			 techCaps = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":45,"name":techcapstableTemplate(techCaps)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataTechCap)
					.then(function(response1) {
		 				$('#tcaps').css('color','#0aa20a')  
						techCaps =response1;
						//console.log('techCaps');
						//console.log(techCaps);
					 worksheetList.push({"id":45,"name": techcapstableTemplate(techCaps.technology_capabilities)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Technology Capability Data API set up')
					});   
		 }
		} else {
			worksheetList.push({
				"id": 45,
				"name": techcapstableTemplate(techCaps.technology_capabilities)
			})
		}
	}
//console.log(worksheetList)		 
})			 
		   
              
$('#nodesCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 36;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(nodes)) {
		 if(viewAPIDataTechCap==viewCheck){
			 nodes = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":36,"name":serverstableTemplate(nodes)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataNodes)
					.then(function(response1) {
		 				$('#nodes').css('color','#0aa20a')  
						nodes =response1;
						//console.log('nodes');
						//console.log(nodes);
					 worksheetList.push({"id":36,"name": serverstableTemplate(nodes.nodes)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Nodes Data API set up')
					});     
		 }
		} else {
			worksheetList.push({
				"id": 36,
				"name": serverstableTemplate(nodes.nodes)
			})
		}
	}
//console.log(worksheetList)		 
})	
		 	 
$('#apps2serverCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 37;
		})
		worksheetList = workingWL;
      $('#appsi').hide(); 
      $('#nodesi').hide(); 
	} else {
      $('#appsi').show(); 
      $('#nodesi').show(); 
		if ($.isEmptyObject(app2server)) {
		  if(viewAPIDataApptoServer==viewCheck){
			 app2server = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":37,"name":app2servertableTemplate(app2server)});
			 }
		 else
		 {
			return promise_loadViewerAPIData(viewAPIDataApptoServer)
					.then(function(response1) {
		 				$('#ap2servs').css('color','#0aa20a') 
						app2server =response1;
						//console.log('app2server');
						//console.log(app2server);
					 worksheetList.push({"id":37,"name": app2servertableTemplate(app2server.app2server)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Application to Server API set up')
					});   
		 }
		} else {
			worksheetList.push({
				"id": 37,
				"name": app2servertableTemplate(app2server.app2server)
			})
		}
	}
//console.log(worksheetList)		 
})			  
		
$('#techDomsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 38;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(techDomains)) {
		 if(viewAPIDataTechDomains==viewCheck){
			 techDomains = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":38,"name":techdomstableTemplate(techDomains)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataTechDomains)
					.then(function(response1) {
		 				$('#tds').css('color','#0aa20a') 
						techDomains =response1;
						//console.log('techDomains');
						//console.log(techDomains);
					 worksheetList.push({"id":38,"name": techdomstableTemplate(techDomains.technology_domains)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Technology Domains API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 38,
				"name": techdomstableTemplate(techDomains.technology_domains)
			})
		}
	}
//console.log(worksheetList)		 
})			 

$('#techCompsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 40;
		})
		worksheetList = workingWL;
      $('#techCapsi').hide();  
	} else {
      $('#techCapsi').show(); 
		if ($.isEmptyObject(techComponents)) {
		 if(viewAPIDataTechComp==viewCheck){
			 techComponents = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":40,"name":techcompstableTemplate(techComponents)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataTechComp)
					.then(function(response1) {
		 				$('#tcomps').css('color','#0aa20a')   
						techComponents =response1;
						//console.log('techComponents');
						//console.log(techComponents);
					 worksheetList.push({"id":40,"name": techcompstableTemplate(techComponents.technology_components)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Technology Components API set up')
					}); 
		 }
		} else {
			worksheetList.push({
				"id": 40,
				"name": techcompstableTemplate(techComponents.technology_components)
			})
		}
	}
//console.log(worksheetList)		 
})	
		 			 
$('#techSuppliersCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 43;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(techSuppliers)) { 
		 if(viewAPIDataTechSupplier==viewCheck){
			 techSuppliers = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":43,"name":techsuppliertableTemplate(techSuppliers)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataTechSupplier)
					.then(function(response1) {
		 				$('#tsups').css('color','#0aa20a')  
						techSuppliers =response1;
						//console.log('techSuppliers');
						//console.log(techSuppliers);
					 worksheetList.push({"id":43,"name": techsuppliertableTemplate(techSuppliers.technology_suppliers)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Technology Domains API set up')
					});      
		 }
		} else {
			worksheetList.push({
				"id": 43,
				"name": techsuppliertableTemplate(techSuppliers.technology_suppliers)
			})
		}
	}
//console.log(worksheetList)		 
}) 
		 
		 
  
$('#techProductsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 47;
		})
		worksheetList = workingWL;
      $('#techSuppi').hide();  
      $('#techFami').hide();  
      $('#techCompsi').hide();  
	} else {
      $('#techSuppi').show();  
      $('#techFami').show();  
      $('#techCompsi').show();  
		if ($.isEmptyObject(techProducts)) {
		  if(viewAPIDataTechProd==viewCheck){
			 techProducts = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":47,"name":techproductstableTemplate(techProducts)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataTechProd)
					.then(function(response1) {
		 				$('#tprods').css('color','#0aa20a')  
						techProducts =response1;
						//console.log('techProducts');
						//console.log(techProducts);
					 worksheetList.push({"id":47,"name": techproductstableTemplate(techProducts.technology_products)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Technology Domains API set up')
					});     
		 }
		} else {
			worksheetList.push({
				"id": 47,
				"name": techproductstableTemplate(techProducts.technology_products)
			})
		}
	}
//console.log(worksheetList)		 
}) 		 
		  
	
$('#techProductFamiliesCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 46;
		})
		worksheetList = workingWL;
	} else {
		if ($.isEmptyObject(techProductFamilies)) {
		  if(viewAPIDataTechProdFamily==viewCheck){
			 techProductFamilies = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":46,"name":techproductfamilytableTemplate(techProductFamilies)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataTechProdFamily)
					.then(function(response1) {
		 				$('#tprodfams').css('color','#0aa20a')  
						techProductFamilies =response1;
						//console.log('techProductFamilies');
						//console.log(techProductFamilies);
					 worksheetList.push({"id":46,"name": techproductfamilytableTemplate(techProductFamilies.technology_product_family)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Technology Product Family API set up')
					});    
		 }
		} else {
			worksheetList.push({
				"id": 46,
				"name": techproductfamilytableTemplate(techProductFamilies.technology_product_family)
			})
		}
	}
//console.log(worksheetList)		 
})		   
		 
$('#techProducttoOrgsCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 50;
		})
		worksheetList = workingWL;
      $('#techProdsi').hide();  
      $('#orgsi').hide();  
	} else {
      $('#techProdsi').show();  
      $('#orgsi').show(); 
		if ($.isEmptyObject(techProductOrg)) {
		 if(viewAPIDataTechProdOrg==viewCheck){
			 techProductOrg = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":50,"name":techproductorgtableTemplate(techProductOrg)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataTechProdOrg)
					.then(function(response1) {
		 				$('#tprodors').css('color','#0aa20a')  
						techProductOrg =response1;
						//console.log('techProductOrg');
						//console.log(techProductOrg);
					 worksheetList.push({"id":50,"name": techproductorgtableTemplate(techProductOrg.technology_product_orgs)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Tech Product Organisation API set up')
					});   
		 }
		} else {
			worksheetList.push({
				"id": 50,
				"name": techproductstableTemplate(techProducts.technology_products)
			})
		}
	}
//console.log(worksheetList)		 
})
	 
$('#dataSubjectCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 55;
		})
		worksheetList = workingWL;
     
	} else {
		if ($.isEmptyObject(dataSubjects)) {
		  if(viewAPIDataDataSubject==viewCheck){
			 dataSubjects = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":55,"name":dataSubjecttableTemplate(dataSubjects)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataDataSubject)
					.then(function(response1) {
		 				$('#dsubjs').css('color','#0aa20a')  
						dataSubjects =response1;
						//console.log('dataSubject');
						//console.log(dataSubjects);
					 worksheetList.push({"id":55,"name": dataSubjecttableTemplate(dataSubjects.data_subjects)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Data Subject API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 55,
				"name": dataSubjecttableTemplate(dataSubjects.data_subjects)
			})
		}
	}
//console.log(worksheetList)		 
})		   

$('#dataObjectCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 56;
		})
		worksheetList = workingWL;
      $('#dataSubjsi').hide();   
	} else {
      $('#dataSubjsi').show();   
		if ($.isEmptyObject(dataObjects)) {
		 if(viewAPIDataDataObject==viewCheck){
			 dataObjects = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":55,"name":dataObjecttableTemplate(dataObjects)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataDataObject)
					.then(function(response1) {
		 				$('#dObjs').css('color','#0aa20a')    
						dataObjects =response1;
						//console.log('dataOject');
						//console.log(dataObjects);
					 worksheetList.push({"id":56,"name": dataObjecttableTemplate(dataObjects.data_objects)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Data Object API set up')
					});   
		 }
		} else {
			worksheetList.push({
				"id": 56,
				"name": dataObjecttableTemplate(dataObjects.data_objects)
			})
		}
	}
//console.log(worksheetList)		 
})
		 
		 
$('#dataObjectInheritCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 60;
		})
		worksheetList = workingWL;
      $('#dataObjsi').hide();   
	} else {
      $('#dataObjsi').show();   
		if ($.isEmptyObject(dataObjectInheritance)) {
		 if(viewAPIDataDataObject==viewCheck){
			 dataObjectInheritance = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":60,"name":dataObjectinheritTemplate(dataObjectInheritance)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataDataObjectInherit)
					.then(function(response1) {
		 				$('#dObjins').css('color','#0aa20a')  
						dataObjectInheritance =response1;
						//console.log('dataObjectInheritance');
						//console.log(dataObjectInheritance);
					 worksheetList.push({"id":60,"name": dataObjectinheritTemplate(dataObjectInheritance.data_object_inherit)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Data Object API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 60,
				"name": dataObjectinheritTemplate(dataObjectInheritance.data_object_inherit)
			})
		}
	}
//console.log(worksheetList)		 
})
 
$('#dataObjectAttributeCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 65;
		})
		worksheetList = workingWL;
      $('#dataObjsi').hide();  
	} else {
      $('#dataObjsi').show();  
		if ($.isEmptyObject(dataObjectAttributes)) {
		 if(viewAPIDataDataObjectAttribute==viewCheck){
			 dataObjectAttributes = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":65,"name":dataObjectattributeTemplate(dataObjectAttributes)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataDataObjectAttribute)
					.then(function(response1) {
		 				$('#dObjAts').css('color','#0aa20a')  
						dataObjectAttributes =response1;
						//console.log('dataObjectAttributes');
						//console.log(dataObjectAttributes);
					 worksheetList.push({"id":65,"name": dataObjectattributeTemplate(dataObjectAttributes.data_object_attributes)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Data Object API set up')
					}); 
		 }
		} else {
			worksheetList.push({
				"id": 65,
				"name": dataObjectattributeTemplate(dataObjectAttributes.data_object_attributes)
			})
		}
	}
//console.log(worksheetList)		 
})
		   	 
		 
  
$('#appDependencyCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 70;
		})
		worksheetList = workingWL;
      $('#appsi').hide();  
      $('#infoXi').hide();  
	} else {
      $('#appsi').show();  
      $('#infoXi').show();  
		if ($.isEmptyObject(applicationDependencies)) {
		 if(viewAPIDataAppDependency==viewCheck){
			 applicationDependencies = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":70,"name":appDependencyTemplate(applicationDependencies)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIDataAppDependency)
					.then(function(response1) {
		 				$('#appDps').css('color','#0aa20a')   
						applicationDependencies =response1;
						//console.log('applicationDependencies');
						//console.log(applicationDependencies);
					 worksheetList.push({"id":70,"name": appDependencyTemplate(applicationDependencies.application_dependencies)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Application Dependency API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 70,
				"name": appDependencyTemplate(applicationDependencies.application_dependencies)
			})
		}
	}
//console.log(worksheetList)		 
})

$('#apptotechCheck').on("change", function() {
	var boxState = $(this).prop("checked");
	if (boxState == false) {
		var workingWL = worksheetList.filter(function(d) {
			return d.id != 75;
		})
		worksheetList = workingWL;
      $('#appsi').hide();  
      $('#techProdsi').hide();  
      $('#techCompsi').hide();  

	} else {
      $('#appsi').show();  
      $('#techProdsi').show();  
      $('#techCompsi').show(); 
		if ($.isEmptyObject(applicationTechArch)) {
		 if(viewAPIPathApptoTech==viewCheck){
			 applicationTechArch = [{'description': '', 'name': ''}];
		     worksheetList.push({"id":75,"name":appToTechTemplate(applicationTechArch)});
			 }
		 else
		 {
			 return promise_loadViewerAPIData(viewAPIPathApptoTech)
					.then(function(response1) {
		 				$('#apptechs').css('color','#0aa20a')   
						applicationTechArch =response1;
						//console.log('applicationTechArch');
						//console.log(applicationTechArch);
					 worksheetList.push({"id":75,"name": appToTechTemplate(applicationTechArch.application_technology_architecture)});	
					}).catch (function (error) {
						alert('Error - check you have the Core API: Import Application to Technology API set up')
					});  
		 }
		} else {
			worksheetList.push({
				"id": 75,
				"name": appToTechTemplate(applicationTechArch.application_technology_architecture)
			})
		}
	}
//console.log(worksheetList)		 
})		 
		 		 		 
});
        
    </xsl:template>

	 
 <xsl:template match="node()" mode="status">
<xsl:variable name="thislanguage" select="$language"/>  
	 <xsl:variable name="thissynonym" select="$synonym[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>  
	 <xsl:variable name="thisstyle" select="$style[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/> 	 
{"id":"<xsl:value-of select="current()/name"/>",
 "name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
"label":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",
"colour":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",
"seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
"score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>",
"synonyms":[<xsl:for-each select="$thissynonym">
	 <xsl:variable name="thislanguage" select="$language[name=current()/own_slot_value[slot_reference='synonym_language']/value]"/>  
	{"name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
	 "translation":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
	"language":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thislanguage"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>
 <xsl:template match="node()" mode="standard">
	<xsl:variable name="thislanguage" select="$language"/>  
	 <xsl:variable name="thissynonym" select="$synonym[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>  
	 <xsl:variable name="thisstyle" select="$style[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/>  
{"id":"<xsl:value-of select="current()/name"/>",
 "name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
 "label":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",	 
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"colour":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",	 
"class":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_class']/value"/>",
"seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
"score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>",
"synonyms":[<xsl:for-each select="$thissynonym">
	 <xsl:variable name="thislanguage" select="$language[name=current()/own_slot_value[slot_reference='synonym_language']/value]"/>  
	{"name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
	"translationName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
	"translationDesc":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
	"language":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thislanguage"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>	
<xsl:template match="node()" mode="acquisition">
{"id":"<xsl:value-of select="current()/name"/>",
 "name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
 "label":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",	 
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
"score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>	
	
	
</xsl:stylesheet>  
