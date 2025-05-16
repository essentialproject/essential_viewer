<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:pro="http://protege.stanford.edu/xml"
	xmlns:eas="http://www.enterprise-architecture.org/essential"
	xmlns:functx="http://www.functx.com"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">
	<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/ods_spreadsheet_files/excelTemplate.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider_Interface', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function', 'Application_Function_Implementation', 'Enterprise_Strategic_Plan', 'Information_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- START VIEW SPECIFIC SETUP VARIABES -->

    <xsl:variable name="appRepImpls" select="/node()/simple_instance[type='Application_Reference_Implementation']"/>
    <xsl:variable name="appProRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
    <xsl:variable name="BusDomains" select="/node()/simple_instance[type='Business_Domain']"/>
	<xsl:variable name="BusModels" select="/node()/simple_instance[type='Business_Model']"/>
	<xsl:variable name="BusCaps" select="/node()/simple_instance[type='Business_Capability'][count(own_slot_value[slot_reference='contained_business_capabilities']/value)=0]"/>
    <xsl:key name="BusCapsKey" match="$BusCaps" use="name"/>
	<xsl:variable name="BusProcesses" select="/node()/simple_instance[type='Business_Process']"/>
    <xsl:variable name="BusProcessesRefUsage" select="/node()/simple_instance[type='Business_Process_Reference_Usage']"/>
    <xsl:variable name="BusModelUsage" select="/node()/simple_instance[type='Business_Model_Business_Usage']"/>
    <xsl:variable name="busRefArch" select="/node()/simple_instance[type='Business_Reference_Architecture']"/>  
    <xsl:key name="BPKey" match="$BusProcesses" use="name"/>
    <xsl:key name="BRAKey" match="$busRefArch" use="own_slot_value[slot_reference='business_reference_architecture_elements']/value"/> 
   
    <xsl:variable name="groupActors" select="/node()/simple_instance[type='Group_Actor']"/>
   
    <xsl:key name="busRefKey" match="$busRefArch" use="name"/>

	<xsl:variable name="BusModelArch" select="/node()/simple_instance[type='Business_Model_Architecture']"/>
	<xsl:key name="BusModArch" match="$BusModelArch" use="own_slot_value[slot_reference='architecture_of_business_model']/value"/>
    <xsl:key name="BusModelArchname" match="$BusModelArch" use="name"/>
    <xsl:variable name="ARITs" select="/node()/simple_instance[type=':ARIT-TO-ARIT-REFERENCE-RELATION']"/>

    <xsl:variable name="BRAMap" select="/node()/simple_instance[type=':BMC-BRAU-DEPENDS_ON-ARIU']"/>
    <xsl:variable name="BRUsages" select="/node()/simple_instance[type='Business_Reference_Architecture_Config_Usage']"/>
  

    <xsl:variable name="ARUsages" select="/node()/simple_instance[type='Application_Reference_Implementation_Config_Usage']"/>
    <xsl:variable name="BusModelConfigurations" select="/node()/simple_instance[type='Business_Model_Configuration']"/>
    <xsl:key name="aritARI" match="$appRepImpls" use="own_slot_value[slot_reference='application_reference_implementation_dependencies']/value"/>

    <xsl:key name="aritARIName" match="$appRepImpls" use="name"/>
    
    
    <xsl:key name="aritARITypes" match="/node()/simple_instance[supertype='Application_Reference_Implementation_Type']" use="name"/>

    <!-- configurations -->
    <xsl:key name="BRACUTypes" match="$BRUsages" use="name"/>
    <xsl:variable name="BMCA" select="/node()/simple_instance[type='Business_Model_Configuration_Architecture']"/>
    <xsl:key name="BRAC" match="$BMCA" use="own_slot_value[slot_reference='bmc_architecture_elements']/value"/>
    <xsl:key name="BRACname" match="$BMCA" use="name"/>

    
    <xsl:key name="ARICUTypes" match="/node()/simple_instance[type='Application_Reference_Implementation_Config_Usage']" use="name"/>
    <xsl:key name="ARIC" match="/node()/simple_instance[type='Business_Reference_Architecture_Configuration']" use="own_slot_value[slot_reference='bmc_architecture_elements']/value"/>



    <xsl:key name="aritARIAPRs" match="$appProRoles" use="name"/>
 
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: App KPIs'][own_slot_value[slot_reference='report_xsl_filename']/value!=''][1]"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
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
		<xsl:variable name="apiBCM">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiApp">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiProcess">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$processData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Launchpad Performance Measures Manager')"/>
				</title>

				<script src="js/d3/d3.v5.9.7.min.js"></script>
				<script src="js/FileSaver.min.js"></script>
				<script src="js/jszip/jszip.min.js"></script>
				
				<style type="text/css">
 	
				</style>

			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<!--ADD THE CONTENT-->
                <span id="mainPanel"/>
                
				<div id="editor-spinner" class="hidden">
					<div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;">
						<div class="spin-icon" style="width: 60px; height: 60px;">
							<div class="sq sq1"/>
							<div class="sq sq2"/>
							<div class="sq sq3"/>
							<div class="sq sq4"/>
							<div class="sq sq5"/>
							<div class="sq sq6"/>
							<div class="sq sq7"/>
							<div class="sq sq8"/>
							<div class="sq sq9"/>
						</div>
					</div>
                    <div id="editor-spinner-text" class="text-center xlarge strong spin-text2"/>
                    
				</div>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Launchpad Export - Solution Builder</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-4">
							<p> 
			 
                		<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10" id="getExcel">Download Solution Builder as Excel</div> <br/>
                                
                        <p>For import Spec please contact EAS</p>
					
                        <a class="noUL" href="integration/plus/Business_Models_Import_Spec.zip" download="Business_Models_Import_Spec.zip">

                		<div class="downloadBtn btn btn-default bg-secondary text-white small bottom-10">Download Solution Builder Import Specification</div>
						</a><br/>
                        	<!-- 
						<br/>								   
						TO DO<a href="integration/plus/LaunchpadPlus-Essential_Application_KPIs.pdf" download="LaunchpadPlus-Essential_Application_KPIs.pdf"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
                        -->
                </p>   
						</div>
            <div class="col-md-8">
                <p>
                    This exporter provides the data for the Business Solution Builder<br/>
                    <i class="fa fa-info-circle" style="color:red"></i><xsl:text> </xsl:text> This exports an ods file, <b>save as xslx</b> before re-importing.
                </p>
                <p>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <td>Sheet</td>
                            <td>Description</td>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>App Ref Impls Models</td>
                            <td>A list of Applications Reference Implementation Models. These are logical Application Architecture blueprints describing an 'implementation' design of Applications that together provide the functionality defined in one or more Application Reference Architectures</td>
                        </tr>  
                        <tr>
                            <td>Business Models</td>
                            <td>A list of Business Models, these are needed for proposals.  These are things that create, deliver and capture business value for the enterprise</td>
                        </tr> 
                        <tr>
                            <td>Business Model Configs</td>
                            <td>Business Model Configuration and otrgainsations impacted, these will be used for defining coarse grained business, information, application and technology building blocks</td>
                        </tr> 
                        <tr>
                            <td>Business Model to Leaf Business Caps</td>
                            <td>You need to associate Business Models with leaf, i.e. lowest level business capabilities</td>
                        </tr> 
                        <tr>
                            <td>Business Model Configs 2 Ref Archs</td>
                            <td>Links the Business models to the business reference and application reference implementations</td>
                        </tr> 
                        <tr>
                            <td>Business Reference Archs</td>
                            <td>A list Business Reference Architectures and organisations they impact</td>
                        </tr> 
                        <tr>
                            <td>App Reference Impls</td>
                            <td>A list Application Reference Implementations and organisations they impact</td>
                        </tr> 
                        <tr>
                            <td>Bus Ref Arch 2 Process</td>
                            <td>Mapping </td>
                        </tr> 
                        <tr>
                            <td>Organisations</td>
                            <td>List of organisations</td>
                        </tr> 
                       
                        <tr>
                            <td>Business Domains</td>
                            <td>List of business domains </td>
                        </tr> 
                        <tr>
                            <td>Business Capabilities</td>
                            <td>List of business capabilities </td>
                        </tr> 
                        <tr>
                            <td>Business Processes</td>
                            <td>List of business processes </td>
                        </tr> 
                        <tr>
                            <td>App Provider Roles</td>
                            <td>list of application provider roles</td>
                        </tr> 
                         
                        </tbody>
                    </table>
                </p>
                </div>
						<!--Setup Closing Tags-->
					</div>
                </div>
        
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
		
			<script>
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathApp" select="$apiApp"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathProcess" select="$apiProcess"></xsl:with-param>
				</xsl:call-template>
			</script>
  <!-- Excel handlebars template -->
 <xsl:call-template name="excelHandlebars"/>
</html>
</xsl:template>

<xsl:template name="RenderViewerAPIJSFunction">
<xsl:param name="viewerAPIPath"></xsl:param>
<xsl:param name="viewerAPIPathApp"></xsl:param>
<xsl:param name="viewerAPIPathProcess"></xsl:param>
		var viewAPIKPIData = '<xsl:value-of select="$viewerAPIPath"/>';	
		var viewAPIDataApp = '<xsl:value-of select="$viewerAPIPathApp"/>';	
		var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>';		

      var data;
			var promise_loadViewerAPIData = function (apiDataSetURL)
			{
				return new Promise(function (resolve, reject)
				{
					if (apiDataSetURL != null)
					{
						var xmlhttp = new XMLHttpRequest();
						xmlhttp.onreadystatechange = function ()
						{
							if (this.readyState == 4 &amp;&amp; this.status == 200)
							{
								
								var viewerData = JSON.parse(this.responseText);
								resolve(viewerData);
							}
						};
						xmlhttp.onerror = function ()
						{
							reject(false);
						};
						
						xmlhttp.open("GET", apiDataSetURL, true);
						xmlhttp.send();
					} else
					{
						reject(false);
					}
				});
		}; 
		 
			 function showEditorSpinner(message) {
				$('#editor-spinner-text').text(message);                            
				$('#editor-spinner').removeClass('hidden');                         
			};
	
			function removeEditorSpinner() {
				$('#editor-spinner').addClass('hidden');
				$('#editor-spinner-text').text('');
			};
	
			var apiProds;	

			showEditorSpinner('Fetching Data...'); 
 
	 
			var excelSheet=[];
		 	$('document').ready(function (){
                 <!-- Excel handlebars functions -->
                <xsl:call-template name="excelHandlebarsJS"/>

		 Promise.all([
				 promise_loadViewerAPIData(viewAPIKPIData),
				 promise_loadViewerAPIData(viewAPIDataApp),
				 promise_loadViewerAPIData(viewAPIDataProcess)
				]).then(function (responses){  
                    removeEditorSpinner()
                    data={
                        "businessModels":[<xsl:apply-templates select="$BusModels" mode="busMods"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "businessModelConfigurations":[<xsl:apply-templates select="$BusModelConfigurations" mode="busModConfigs"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "busCaps":[<xsl:apply-templates select="$BusCaps" mode="idName"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "busProcess":[<xsl:apply-templates select="$BusProcesses" mode="idName"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "orgs":[<xsl:apply-templates select="$groupActors" mode="idName"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "domains":[<xsl:apply-templates select="$BusDomains" mode="idName"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "aprs":[<xsl:apply-templates select="$appProRoles" mode="idName"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "aris":[<xsl:apply-templates select="$appRepImpls" mode="ariSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "bras":[<xsl:apply-templates select="$busRefArch" mode="ariSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "arits":[<xsl:apply-templates select="$ARITs" mode="aritSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "busRefConf":[<xsl:apply-templates select="$BRAMap" mode="brcSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "busModelProcess":[<xsl:apply-templates select="$BusModelUsage" mode="busProArchSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>],
                        "ref2Process":[<xsl:apply-templates select="$BusProcessesRefUsage" mode="busProtoArchSheet"><xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>]
                        }
                    console.log('data',data)
                    if(data.arits.length==0){data.arits.push({row:8,"name":"","from":"","to":""})};
                    if(data.businessModels.length==0){
                        data.businessModels.push({row:8,"id":"","name":"","description":"","domain":""})
                    };
                 
                    if(data.businessModelConfigurations.length==0){
                        console.log('bus mod conf 0')
                        data.businessModelConfigurations.push({row:8,"id":"","model":"","label":"","desc":"","org1":"","org2":"","org3":"","org4":"","org5":"","org6":"","name":'=CONCATENATE(C8," - ", D8)'})
                    };
 
                   if(data.busModelProcess.length==0){
                        data.busModelProcess.push({row:8,"model":"","leafBC":""})
                    };
                    if(data.busRefConf.length==0){ 
                        data.busRefConf.push({row:8,"model":"","fromBRA":"","fromARI":""})
                    };
                 
                    if(data.bras.length==0){
                        data.bras.push({row:8,"id":"","name":"","description":"","org1":"","org2":"","org3":"","org4":"","org5":"","org6":""})
                    };
                    if(data.aris.length==0){
                        data.aris.push({row:8,"id":"","name":"","description":"","org1":"","org2":"","org3":"","org4":"","org5":"","org6":""})
                    };
                    if(data.ref2Process.length==0){
                        data.ref2Process.push({row:8,"refArch":"","process":""})
                    };
                    if(data.orgs.length==0){
                        data.orgs.push({row:8,"id":"","name":""})
                    };
                    if(data.domains.length==0){
                        data.domains.push({row:8,"id":"","name":""})
                    };
                    if(data.busCaps.length==0){
                        data.busCaps.push({row:8,"id":"","name":""})
                    };
                    
                    if(data.busProcess.length==0){
                        data.busProcess.push({row:8,"id":"","name":""})
                    };
                    
                    if(data.aprs.length==0){
                        data.aprs.push({row:8,"id":"","name":""})
                     };
               
                       
                    // Function to increment row numbers in a CONCATENATE formula
                    function incrementConcatenateFormula(formula, increment) {
                        return formula.replace(/\d+/g, match => parseInt(match, 10) + increment);
                    }

                    // Function to create an object with keys from the template, incrementing row numbers in 'CONCATENATE' properties
                    function createObjectFromTemplate(template, increment) {
                        let newObject = {};
                        Object.keys(template).forEach(key => {
                            // Check if the property value is a string and starts with '=CONCATENATE'
                            if (typeof template[key] === 'string' &amp;&amp; template[key].startsWith('=CONCATENATE')) {
                                newObject[key] = incrementConcatenateFormula(template[key], increment);
                            } else {
                                newObject[key] = ""; // Empty string for other properties
                            }
                        });
                        return newObject;
                    }

                    // Function to add new objects to each array in the data object, with incremented row numbers in formulas
                    function addRowsToEachDataset(data, numRowsToAdd) {
                       
                        Object.keys(data).forEach(key => {
                          
                            if (Array.isArray(data[key]) &amp;&amp; data[key].length > 0) {
                                
                                let template = data[key][0];
                                let lastRowIndex = data[key].length;
                                for (let i = 1; i &lt;= numRowsToAdd; i++) {
                                    data[key].push(createObjectFromTemplate(template, lastRowIndex + i - 1));
                                }
                            }
                        });
                    }

                    // Call the function to modify the 'data' object
                    addRowsToEachDataset(data, 100);

                  //  console.log('app',responses[0])
                    let appData=[];
                    responses[1].applications.forEach((d,i)=>{
                        appData.push({"row":i+8,"id":d.id,"name":d.name})
                    })
                    let allMeasures=[];
                    responses[0].applications.forEach((d)=>{
                        d.perfMeasures.forEach((e)=>{
                            e.serviceQuals?.forEach((f)=>{
                                allMeasures.push({"id":d.id, "name":d.app, "category": f.categoryName , "service":f.serviceName, "quality": f.value, "date": e.date, "type": f.type})
                            })
                        })
                    })
              
                    var byType = d3.nest()
                    .key(function(d) { return d.type; })
                    .entries(allMeasures);

                    
                    var sQbyType = d3.nest()
                    .key(function(d) { return d.type; })
                    .entries(responses[0].serviceQualities);

                
 
                   
                  
                    

                      excelSheet.push({
                        "id": 1, // Using ID from the sheet
                        "name": "Business Models",
                        "worksheetNameNice": "Business Models",
                        "worksheetName": "Business_Models",
                        "description": "Sheet for Business Models",
                        "heading": [
                          {"col": "A", "name": "ID",  "data":"id"}, 
                          {"col": "B", "name": "Name",  "data":"name"},
                          {"col": "C", "name": "Description",  "data":"description"}, 
                          {"col": "D", "name": "Business Domain",  "data":"domain"}
                        ],
                        "lookups": [
                            {"column": "D", "columnNum": "4", "lookUpSheet": "Business Domains", "lookupCol": "C", "val": "domainName"}
                        ], 
                        "data":  data.businessModels // [{"row":"8","id":"ari1","name":"APR1","description":"APR2","domain":"APR2"}]
                      });

                   

                      excelSheet.push({
                        "id": 2, // Using ID from the sheet
                        "name": "Business Model Configs",
                        "worksheetNameNice": "Business Model Configs",
                        "worksheetName": "Business_Model_Configs",
                        "description": "Sheet for Business Model Configurations",
                        "heading": [
                          {"col": "B", "name": "ID", "data":"id"}, 
                          {"col": "C", "name": "Business Model", "data":"model"},
                          {"col": "D", "name": "Config Label", "data":"label"},
                          {"col": "E", "name": "Description", "data":"desc"},
                          {"col": "F", "name": "Org Scope 1", "data":"org1"}, 
                          {"col": "G", "name": "Org Scope 2", "data":"org2"}, 
                          {"col": "H", "name": "Org Scope 3", "data":"org3"},
                          {"col": "I", "name": "Org Scope 4", "data":"org4"},
                          {"col": "J", "name": "Org Scope 5", "data":"org5"},
                          {"col": "K", "name": "Org Scope 6", "data":"org6"},  
                          {"col": "L", "name": "Full Name", "data":"name"}
                          // Add other headers if needed
                        ],
                        "lookups": [  {"column": "B", "columnNum": "2", "lookUpSheet": "Business Models", "lookupCol": "C", "val": "bmName"}, {"column": "F", "columnNum": "5", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org1Name"}, {"column": "G", "columnNum": "6", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org2Name"}, {"column": "H", "columnNum": "7", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org3Name"}, {"column": "I", "columnNum": "8", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org4Name"}, {"column": "J", "columnNum": "9", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org5Name"}, {"column": "K", "columnNum": "10", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org6Name"}
                        ],
                        "data": data.businessModelConfigurations 
                      });


                      excelSheet.push({
                        "id": 3, // Using ID from the sheet
                        "name": "Business Model to Leaf Bus Caps",
                        "worksheetNameNice": "Business Model to Leaf Bus Caps",
                        "worksheetName": "Business_Model_to_Leaf_Bus_Caps",
                        "description": "Mapping of Business Models to Leaf Business Capabilities",
                        "heading": [
                          {"col": "A", "name": "Business Model", "data":"model"}, 
                          {"col": "B", "name": "Leaf Business Capability", "data":"leafBC"} 
                       
                        ],
                        "lookups": [ {"column": "B", "columnNum": "1", "lookUpSheet": "Business Models", "lookupCol": "C", "val": "bmConfig"}, {"column": "C", "columnNum": "2", "lookUpSheet": "Business Capabilities", "lookupCol": "C", "val": "busCaps"}
                        ],
                        "data": data.busModelProcess
                      });
                  

                    excelSheet.push({
                            "id": 4, // Assuming ID is unique and provided
                            "name": "Business Reference Architectures",
                            "worksheetNameNice": "Bus Reference Archs",
                            "worksheetName": "Bus_Reference_Archs",
                            "description": "Details of Business Reference Architectures",
                            "heading": [
                                {"col": "B", "name": "ID", "data":"id"}, 
                                {"col": "C", "name": "Name", "data":"name"}, 
                                {"col": "D", "name": "Description", "data":"description"},
                                {"col": "E", "name": "Org Scope 1", "data":"org1"}, 
                                {"col": "F", "name": "Org Scope 2", "data":"org2"}, 
                                {"col": "G", "name": "Org Scope 3", "data":"org3"},
                                {"col": "H", "name": "Org Scope 4", "data":"org4"},
                                {"col": "I", "name": "Org Scope 5", "data":"org5"},
                                {"col": "J", "name": "Org Scope 6", "data":"org6"}  
                            ],
                            "lookups": [ {"column": "E", "columnNum": "4", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org6Name2"},{"column": "F", "columnNum": "5", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org1Name2"}, {"column": "G", "columnNum": "6", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org2Name2"}, {"column": "H", "columnNum": "7", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org3Name2"}, {"column": "I", "columnNum": "8", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org4Name2"}, {"column": "J", "columnNum": "9", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org5Name2"}
                            ],
                            "data": data.bras
                          })           
                        
                

                     excelSheet.push({
                        "id": 5, // Assuming ID is unique and provided
                        "name": "Application Reference Implementations",
                        "worksheetNameNice": "App Reference Impls",
                        "worksheetName": "App_Reference_Impls",
                        "description": "Details of Application Reference Implementations",
                        "heading": [
                          {"col": "B", "name": "ID", "data":"id"}, 
                          {"col": "C", "name": "Name", "data":"name"}, 
                          {"col": "D", "name": "Description", "data":"description"},
                          {"col": "E", "name": "Org Scope 1", "data":"org1"}, 
                          {"col": "F", "name": "Org Scope 2", "data":"org2"}, 
                          {"col": "G", "name": "Org Scope 3", "data":"org3"},
                          {"col": "H", "name": "Org Scope 4", "data":"org4"},
                          {"col": "I", "name": "Org Scope 5", "data":"org5"},
                          {"col": "J", "name": "Org Scope 6", "data":"org6"}  
                          // Include other columns as needed
                        ],
                        "lookups": [
                        {"column": "E", "columnNum": "4", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org6Name3"},{"column": "F", "columnNum": "5", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org1Name3"}, {"column": "G", "columnNum": "6", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org2Name3"}, {"column": "H", "columnNum": "7", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org3Name3"}, {"column": "I", "columnNum": "8", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org4Name3"}, {"column": "J", "columnNum": "9", "lookUpSheet": "Organisations", "lookupCol": "C", "val": "org5Name3"}
                        ],
                        "data": data.aris
                      })

                      excelSheet.push({
                        "id": 6, // Unique ID, assuming the first data row has ID 1
                        "name": "App Ref Impls Models",
                        "worksheetNameNice": "App Ref Impls Models",
                        "worksheetName": "App_Ref_Impls_Models",
                        "description": "List of application reference implementations and provider roles...",
                        "heading": [
                          {"col": "B", "name": "Application Reference Implementation",  "data":"name"}, 
                          {"col": "C", "name": "From Application Provider Role",  "data":"from"},
                          {"col": "D", "name": "To Application Provider Roles",  "data":"to"}
                        ],
                        "lookups": [
                            {"column": "A", "columnNum": "1", "lookUpSheet": "App Reference Impls", "lookupCol": "C", "val": "appRefList"},
                            {"column": "B", "columnNum": "2", "lookUpSheet": "App Provider Roles", "lookupCol": "C", "val": "APRList"},
                            {"column": "C", "columnNum": "3", "lookUpSheet": "App Provider Roles", "lookupCol": "C", "val": "APRList1"}
                        ],
                        "data": data.arits
                      });


                      excelSheet.push({
                        "id": 7, // Assuming ID is unique and provided
                        "name": "Business Reference Architectures to Process",
                        "worksheetNameNice": "Bus Ref Arch 2 Process",
                        "worksheetName": "Bus_Ref_Arch_2_Process",
                        "description": "Map the Business Reference Architectures to their in scope Business Processes",
                        "heading": [
                          {"col": "B", "name": "Reference Architecture", "data":"refArch"}, 
                          {"col": "C", "name": "Business Process", "data":"process"}
                        ],
                        "lookups": [ {"column": "B", "columnNum": "1", "lookUpSheet": "Bus Reference Archs", "lookupCol": "C", "val": "bra1lookup"}, {"column": "C", "columnNum": "2", "lookUpSheet": "Business Processes", "lookupCol": "C", "val": "busProcs"} 
                        ],
                        "data": data.ref2Process //fix
                      })


                      excelSheet.push({
                        "id": 8,
                        "name": "Business Model Configurations to Reference Architectures",
                        "worksheetNameNice": "Bus Model Config 2 Ref Archs",
                        "worksheetName": "Bus_Model_Config_2_Ref_Archs",
                        "description": "Mapping of Business Model Configurations to Reference Architectures",
                        "heading": [
                        {"col": "A", "name": "Business Model Config", "data":"model"}, 
                        {"col": "B", "name": "From Business Reference Architecture", "data":"fromBRA"},
                        {"col": "C", "name": "From Application Reference Impls", "data":"fromARI"}
                        ],
                        "lookups": [ {"column": "B", "columnNum": "1", "lookUpSheet": "Business Model Configs", "lookupCol": "L", "val": "bmName1"}, {"column": "C", "columnNum": "2", "lookUpSheet": "Bus Reference Archs", "lookupCol": "C", "val": "busRefs"}, {"column": "C", "columnNum": "3", "lookUpSheet": "App Reference Impls", "lookupCol": "C", "val": "appRefs"}
                        ],
                        "data": data.busRefConf
                    });    


                     
                      excelSheet.push({
                        "id": 9, // Assuming ID is unique and provided
                        "name": "Organisations",
                        "worksheetNameNice": "Organisations",
                        "worksheetName": "Organisations",
                        "description": "Details of Organisationss",
                        "heading": [
                          {"col": "A", "name": "ID", "data":"id"}, 
                          {"col": "B", "name": "Name", "data":"name"}
                          // Include other columns as needed
                        ],
                        "data": data.orgs
                      })

                 

                      excelSheet.push({
                        "id": 10, // Assuming ID is unique and provided
                        "name": "Business Domains",
                        "worksheetNameNice": "Business Domains",
                        "worksheetName": "Business_Domains",
                        "description": "Details of Business Domains",
                        "heading": [
                          {"col": "A", "name": "ID", "data":"id"}, 
                          {"col": "B", "name": "Name", "data":"name"}
                          // Include other columns as needed
                        ],
                        "data": data.domains
                      })


                      excelSheet.push({
                        "id": 11, // Assuming ID is unique and provided
                        "name": "Business Capabilities",
                        "worksheetNameNice": "Business Capabilities",
                        "worksheetName": "Business_Capabilities",
                        "description": "Details of leaf Business Capabilities",
                        "heading": [
                          {"col": "A", "name": "ID", "data":"id"}, 
                          {"col": "B", "name": "Name", "data":"capname"}
                          // Include other columns as needed
                        ],
                        "data": data.busCaps
                      })

  

                      excelSheet.push({
                        "id": 12, // Assuming ID is unique and provided
                        "name": "Business Processes",
                        "worksheetNameNice": "Business Processes",
                        "worksheetName": "Business_Processes",
                        "description": "Details of Business Processes",
                        "heading": [
                          {"col": "A", "name": "ID", "data":"id"}, 
                          {"col": "B", "name": "Name", "data":"name"}
                          // Include other columns as needed
                        ],
                        "data": data.busProcess
                      })

                      excelSheet.push({
                        "id": 13, // Assuming ID is unique and provided
                        "name": "APRs",
                        "worksheetNameNice": "App Provider Roles",
                        "worksheetName": "App_Provider_Roles",
                        "description": "Details of Application Provider Roles",
                        "heading": [
                          
                          {"col": "A", "name": "id", "data":"id"},
                          {"col": "B", "name": "APR Name", "data":"name"}
                          // Include other columns as needed
                        ],
                        "data": data.aprs
                      })
     //create Excel
     
     $('#getExcel').off().on('click',function(){
             
            let excelFile;
            <!-- if lookups then set to true -->
            excelFile={"sheets":excelSheet, "lookups": "true"};

            <xsl:call-template name="RenderOfficetUtilityFunctions"/>
            setExcel(excelFile, "Solution_Builder_Export")
         })
    }); 
}); 
 
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

<xsl:template match="node()" mode="busMods">
    <xsl:variable name="thisBusDomain" select="$BusDomains[name=current()/own_slot_value[slot_reference='bm_business_domain']/value]"/>
	{   "row":"<xsl:value-of select="position()+7"/>",
	    "id":"<xsl:value-of select="current()/name"/>",
	    "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        "domain":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBusDomain"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"
	 }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="idName">
    {   "row":"<xsl:value-of select="position()+7"/>",
	    "id":"<xsl:value-of select="current()/name"/>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="idNameDesc">
    {   "row":"<xsl:value-of select="position()+7"/>",
	    "id":"<xsl:value-of select="current()/name"/>", 
        <xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
            'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="busModConfigs">
    <xsl:variable name="thisActors" select="$groupActors[name=current()/own_slot_value[slot_reference='bmc_org_scope']/value]"/>
    <xsl:variable name="thisBM" select="$BusModels[name=current()/own_slot_value[slot_reference='bmc_for_business_model']/value]"/>
	{   "row":"<xsl:value-of select="position()+7"/>",
	    "id":"<xsl:value-of select="current()/name"/>",
	    "model":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBM"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        "label":"<xsl:value-of select="current()/own_slot_value[slot_reference='bmc_label']/value"/>",
        "desc":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org1": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[1]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",   
        "org2": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[2]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org3": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[3]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org4": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[4]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org5": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[5]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org6": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[6]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        "name":'=CONCATENATE(C<xsl:value-of select="position()+7"/>, " - ", D<xsl:value-of select="position()+7"/>)'
	 }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="ariSheet">
    <xsl:variable name="thisActors" select="$groupActors[name=current()/own_slot_value[slot_reference='sm_organisational_scope']/value]"/>
  
	{   "row":"<xsl:value-of select="position()+7"/>",
	    "id":"<xsl:value-of select="current()/name"/>",
	    "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org1": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[1]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",   
        "org2": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[2]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org3": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[3]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org4": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[4]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org5": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[5]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
        "org6": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisActors[6]"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"
	 }<xsl:if test="position()!=last()">,</xsl:if>

</xsl:template>
<xsl:template match="node()" mode="aritSheet">
    <xsl:variable name="thisari" select="key('aritARI', current()/name)"/>
    <xsl:variable name="usagesFrom" select="key('aritARITypes', current()/own_slot_value[slot_reference=':FROM']/value)"/>
    <xsl:variable name="aprFrom" select="key('aritARIAPRs', $usagesFrom/own_slot_value[slot_reference='apru_usage_of_application_provider']/value)"/>
 
    <xsl:variable name="usagesTo" select="key('aritARITypes', current()/own_slot_value[slot_reference=':TO']/value)"/>
    <xsl:variable name="aprTo" select="key('aritARIAPRs',$usagesTo/own_slot_value[slot_reference='apru_usage_of_application_provider']/value)"/>
{
    "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisari"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
    "from":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$aprFrom"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",  
    "to":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$aprTo"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>" 
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="brcSheet">
     
    <!--<xsl:variable name="thisari" select="key('aritARI', current()/name)"/>-->
    <xsl:variable name="usagesFrom" select="key('BRACUTypes', current()/own_slot_value[slot_reference=':FROM']/value)"/>
    <xsl:variable name="bracFrom" select="key('busRefKey', $usagesFrom/own_slot_value[slot_reference='bracu_usage_of_business_reference_architecture']/value)"/>
    <xsl:variable name="usagesTo" select="key('ARICUTypes', current()/own_slot_value[slot_reference=':TO']/value)"/>
    <xsl:variable name="ariTo" select="key('aritARIName', $usagesTo/own_slot_value[slot_reference='aricu_usage_of_application_reference_implementation']/value)"/>
    <xsl:variable name="thisbrac" select="key('BRACname', current()/own_slot_value[slot_reference='bmc_relation_in_business_model_config_architecture']/value)"/>
    <xsl:variable name="thisbrconfig" select="$BusModelConfigurations[name=$thisbrac/own_slot_value[slot_reference='architecture_of_business_model_configuration']/value]"/>
    <xsl:variable name="thisBM" select="$BusModels[name=$thisbrconfig/own_slot_value[slot_reference='bmc_for_business_model']/value]"/>
 <!--
       <xsl:variable name="aprTo" select="key('aritARIAPRs',$usagesTo/own_slot_value[slot_reference='apru_usage_of_application_provider']/value)"/>
 
       bracu_usage_of_business_reference_architecture  busRefArch
       aritARIName
 -->
{ 
    "row":"<xsl:value-of select="position()+7"/>",
    "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBM"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template><xsl:text> </xsl:text><xsl:call-template name="RenderMultiLangInstanceSlot"><xsl:with-param name="theSubjectInstance" select="$thisbrconfig"/><xsl:with-param name="displaySlot" select="'bmc_label'"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
    "from":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$bracFrom"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
    "to":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$ariTo"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="busProArchSheet">
    
    <xsl:variable name="thisBusCap" select="key('BusCapsKey', current()/own_slot_value[slot_reference='bmbu_used_business_capability']/value)"/>
    <xsl:variable name="thisBusModelArch" select="key('BusModelArchname',current()/own_slot_value[slot_reference='used_in_business_model_architecture']/value)"/>
    <xsl:variable name="thisBusModels" select="$BusModels[name=$thisBusModelArch/own_slot_value[slot_reference='architecture_of_business_model']/value]"/>
    
    { 
        "row":"<xsl:value-of select="position()+7"/>",
        "model":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBusModels"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        <xsl:variable name="combinedMap" as="map(*)" select="map{
			'leafBC': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
		}" />
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="busProtoArchSheet">
    <xsl:variable name="thisProc" select="key('BPKey', current()/own_slot_value[slot_reference='bpru_usage_of_business_process']/value)"></xsl:variable>
    <xsl:variable name="thisBRA" select="key('busRefKey', current()/own_slot_value[slot_reference='bramt_used_in_business_reference_architecture']/value)"></xsl:variable>
    { 
        "row":"<xsl:value-of select="position()+7"/>", 
        "refArch":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisBRA"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
        "process":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisProc"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

 
</xsl:stylesheet>
