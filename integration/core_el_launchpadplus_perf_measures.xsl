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
	<xsl:variable name="classes" select="/node()/class"/>
	<xsl:variable name="perfCategory" select="/node()/simple_instance[type='Performance_Measure_Category']"/>
	<xsl:variable name="perfCategorySQs" select="/node()/simple_instance[supertype='Service_Quality'][name=$perfCategory/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"/>

	<!-- pmc_measures_ea_classes 
	
	-->
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: App KPIs']"></xsl:variable>
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
									<span class="text-darkgrey">Launchpad Export - Application Performance Measures</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-4">
							<p> 
			 
                		<div class="downloadBtn btn btn-default bg-primary text-white small bottom-10" id="getExcel">Download Application Performance Measures as Excel</div> <br/>
   
						<a class="noUL" href="https://enterprise-architecture.org/downloads_area/performance_measure_categories_setup_IMPORTSPEC.zip" download="performance_measure_categories_setup_IMPORTSPEC.zip">

                		<div class="downloadBtn btn btn-default bg-secondary text-white small bottom-10">Download Application Performance Measures Import Specification</div>
						</a><br/> 

                </p>   
						</div>
            <div class="col-md-8">
                <p>
                    The application performance measures workbook creates performance categories and measure against which to measure applications. <br/>
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
                            <td>REF Applications</td>
                            <td>A list of applications, we recommend you don't add data to these here but update the repository or use Launchpad to add this data</td>
                        </tr>  
                        <tr>
                            <td>XXXX_Performance_Measures</td>
                            <td>Measures that map a category and a service quality value, there are different performance measure types so one sheet for each.</td>
                        </tr> 
                        <tr>
                            <td>XXXX_Service_Quals</td>
                            <td>Service qualities which you want to measure the application against, again one for each layer, e.g. Timelines.</td>
                        </tr> 
                        <tr>
                            <td>XXXX_Service_Qual_Values</td>
                            <td>The allowable values for each service quality, e.g. values such as poor, good, excellent. Note the scores, these are important to capture as they are used to calculate overall scores and are numeric.</td>
                        </tr> 
                        <tr>
                            <td>Perf Measure Categories</td>
                            <td>Categories for your measures, assign the <b>performance measure class</b> type the measure is applicable for in column G</td>
                        </tr> 
                        <tr>
                            <td>Perf Measure Cat 2 Class</td>
                            <td>Set the classes which this category applies to - unlike the above, this can be any class</td>
                        </tr> 
                        <tr>
                            <td>Perf Measure Cat 2 SQ Map</td>
                            <td>Define the service qualities in scope of this category</td>
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
 
			var perfCategory=[<xsl:apply-templates select="$perfCategory" mode="perfCategory"/>];
 
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
                        "id":1,
                        "name":"REF Applications",
                        "worksheetNameNice":"REF Applications",
                        "worksheetName":"REF_Applications",
                        "description":"List of applications for reference",
                        "heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"NAME"}],
                        "data":appData
                    });
                 
                    let appBusData=[];
                    let busKey=byType.find((d)=>{
                        return d.key=='Business_Service_Quality_Value';
                    })
                    
                    busKey?.values.forEach((d,i,array)=>{
						appBusData.push({"row":i+7,"Application":d.name,"Measure Category":d.category,"Business Service Quality Value":d.service + ' - '+d.quality,"Measure Date (YYYY-MM-DD)":d.date})
						if (i === array.length - 1){
							let start=i+7+1
							for(j=start;j&lt;start+100;j++){
							appBusData.push({"row":j,"Application":"","Measure Category":"","Business Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
							}
						}
					})
					if (!busKey){
						let start=8
						for(j=start;j&lt;start+100;j++){
							appBusData.push({"row":j,"Application":"","Measure Category":"","Business Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
						}
					}
                      
                    excelSheet.push({
                        "id":2,
                        "name":"Business Performance Measures",
                        "worksheetNameNice":"Business Performance Measures",
                        "worksheetName":"Business_Performance_Measures",
                        "description":"List of application business measures",
                        "heading":[{"col":"B", "name":"Application"}, {"col":"C", "name":"Measure Category"},
						{"col":"D", "name":"Business Service Quality Value"}, {"col":"E", "name":"Measure Date (YYYY-MM-DD)"}],
						"lookups":[{"column":"B","columnNum":"1", "lookUpSheet":"REF Applications", "lookupCol":"C", "val":"appList"},
								   {"column":"C","columnNum":"2", "lookUpSheet":"Perf Measure Categories", "lookupCol":"C", "val":"PMCList"},
								   {"column":"D","columnNum":"3", "lookUpSheet":"Business Service Qual Values", "lookupCol":"M", "val":"BSQVList"}],
				
						"data":appBusData 
					})
					<!-- 
						"lookups":[{"column":"B","columnNum":"2", "lookUpSheet":"REF_Applications", "lookupCol":"C", "val":"appList"}]
					-->

                    let appInfoData=[];
                    let infoKey=byType.find((d)=>{
                        return d.key=='Information_Service_Quality_Value';
                    })
                    
                    infoKey?.values.forEach((d,i, array)=>{
						appInfoData.push({"row":i+7,"Application":d.name,"Measure Category":d.category,"Information Service Quality Value":d.service + ' - '+d.quality,"Measure Date (YYYY-MM-DD)":d.date})
						if (i === array.length - 1){
							let start=i+7+1
							for(j=start;j&lt;start+100;j++){
								appInfoData.push({"row":j,"Application":"","Measure Category":"","Information Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
							}
						}
					})

					if (!infoKey){
						let start=8
						for(j=start;j&lt;start+100;j++){
							appInfoData.push({"row":j,"Application":"","Measure Category":"","Information Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
						}
					}
                      
                    excelSheet.push({
                        "id":3,
                        "name":"Info Performance Measures",
                        "worksheetNameNice":"Info Performance Measures",
                        "worksheetName":"Info_Measures_Performance Measures",
                        "description":"List of applications information measures",
                        "heading":[{"col":"B", "name":"Application"}, {"col":"C", "name":"Measure Category"},
						{"col":"D", "name":"Information Service Quality Value"}, {"col":"E", "name":"Measure Date (YYYY-MM-DD)"}],
						"lookups":[{"column":"B","columnNum":"1", "lookUpSheet":"REF Applications", "lookupCol":"C", "val":"appList2"},
								   {"column":"C","columnNum":"2", "lookUpSheet":"Perf Measure Categories", "lookupCol":"C", "val":"PMCList2"},
								   {"column":"D","columnNum":"3", "lookUpSheet":"Information Service Qual Values", "lookupCol":"M", "val":"ISQVList"}],
                        "data":appInfoData
                    })

                    let appHealthData=[];
                    let healthKey=byType.find((d)=>{
                        return d.key=='Application_Service_Quality_Value';
                    })
                    
                    healthKey?.values.forEach((d,i,array)=>{
						appHealthData.push({"row":i+7,"Application":d.name,"Measure Category":d.category,"Application Service Quality Value":d.service + ' - '+d.quality,"Measure Date (YYYY-MM-DD)":d.date})
						if (i === array.length - 1){
							let start=i+7+1
							for(j=start;j&lt;start+100;j++){
								appHealthData.push({"row":j,"Application":"","Measure Category":"","Application Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
							}
						}
					})
					
					if (!healthKey){
						let start=8
						for(j=start;j&lt;start+100;j++){
							appHealthData.push({"row":j,"Application":"","Measure Category":"","Application Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
						}
					}
                      
                    excelSheet.push({
                        "id":4,
                        "name":"App Performance Measures",
                        "worksheetNameNice":"App Performance Measures",
                        "worksheetName":"App_Performance_Measures",
                        "description":"List of application measures",
                        "heading":[{"col":"B", "name":"Application"}, {"col":"C", "name":"Measure Category"},
						{"col":"D", "name":"Application Service Quality Value"}, {"col":"E", "name":"Measure Date (YYYY-MM-DD)"}],
						"lookups":[{"column":"B","columnNum":"1", "lookUpSheet":"REF Applications", "lookupCol":"C", "val":"appList3"},
								   {"column":"C","columnNum":"2", "lookUpSheet":"Perf Measure Categories", "lookupCol":"C", "val":"PMCList3"},
								   {"column":"D","columnNum":"3", "lookUpSheet":"Application Service Qual Values", "lookupCol":"M", "val":"ASQVList"}],
                        "data":appHealthData
                    });

                    let appTechData=[];
                    let techKey=byType.find((d)=>{
                        return d.key=='Technology_Service_Quality_Value';
                    })
                    
                    techKey?.values.forEach((d,i, array)=>{
						appTechData.push({"row":i+7,"Application":d.name,"Measure Category":d.category,"Technology Service Quality Value":d.service + ' - '+d.quality,"Measure Date (YYYY-MM-DD)":d.date})
						if (i === array.length - 1){
							let start=i+7+1
							for(j=start;j&lt;start+100;j++){
								appTechData.push({"row":j,"Application":"","Measure Category":"","Technology Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
							}
						}
					})
					if (!techKey){
						let start=8
						for(j=start;j&lt;start+100;j++){
							appTechData.push({"row":j,"Application":"","Measure Category":"","Technology Service Quality Value":"","Measure Date (YYYY-MM-DD)":""})
						}
					}
                      
                    excelSheet.push({
                        "id":4,
                        "name":"Technology Performance Measures",
                        "worksheetNameNice":"Technology Performance Measures",
                        "worksheetName":"Technology_Performance_Measures",
                        "description":"List of application measures",
                        "heading":[{"col":"B", "name":"Application"}, {"col":"C", "name":"Measure Category"},
						{"col":"D", "name":"Technology Service Quality Value"}, {"col":"E", "name":"Measure Date (YYYY-MM-DD)"}],
						"lookups":[{"column":"B","columnNum":"1", "lookUpSheet":"REF Applications", "lookupCol":"C", "val":"appList4"},
								   {"column":"C","columnNum":"2", "lookUpSheet":"Perf Measure Categories", "lookupCol":"C", "val":"PMCList4"},
								   {"column":"D","columnNum":"3", "lookUpSheet":"Technology Service Qual Values", "lookupCol":"M", "val":"TSQVList"}],
                        "data":appTechData
                    })

<!-- service quality sheets-->
                let busServiceData=[];
                    let busSQKey=sQbyType.find((d)=>{
                        return d.key=='Business_Service_Quality';
                    })
                    
                    busSQKey?.values.forEach((d,i)=>{
                        busServiceData.push({"row":i+7,"ID":d.id,"Full Name":d.name,"Label":d.shortName,"Description":d.description,"Sequence No":d.serviceIndex,"Weighting":d.serviceWeighting,"Name Translation":"","Description Translation":"","Language":""})
                    })
                     
                    excelSheet.push({
                        "id":5,
                        "name":"Business Service Quals",
                        "worksheetNameNice":"Business Service Quals",
                        "worksheetName":"Business_Service_Quals",
                        "description":"List of business service qualities.  Note language will not pre-populate",
                        "heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Full Name"},
                        {"col":"D", "name":"Label"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Weighting"}, {"col":"H", "name":"Name Translation"}, {"col":"I", "name":"Description Translation"}, {"col":"J", "name":"Language"}],
                        "data":busServiceData
                    })
                    let bsqvs=[];

                    busSQKey?.values.forEach((e)=>{
                         e.sqvs?.forEach((f)=>{
                             f['sq']=e.name;
                          bsqvs.push(f)
                        })
                    })
                    let busSQKeyData=[];

                    bsqvs.forEach((d,i)=>{
                        busSQKeyData.push({"row":i+7,"ID":d.id,"Service Quality":d.sq, "Value":d.value,"Description":d.description,"Sequence No":d.index,"Colour":d.elementBackgroundColour, "Style Class":"", "Score":d.score, "Name Translation":"","Description Translation":"","Language":"", "Mapper": d.sq +' - '+d.value})
                    })
                    excelSheet.push({
                        "id":6,
                        "name":"Business Service Qual Values",
                        "worksheetNameNice":"Business Service Qual Values",
                        "worksheetName":"Business_Service_Qual_Values",
                        "description":"List of business service quality values.  Note language will not pre-populate",
                        "heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Service Quality"},
                        {"col":"D", "name":"Value"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Colour"}, {"col":"H", "name":"Style Class"}, {"col":"I", "name":"Score"},{"col":"J", "name":"Name Translation"}, {"col":"K", "name":"Description Translation"}, {"col":"L", "name":"Language"}, {"col":"M", "name":"Mapper"}],
                        "data":busSQKeyData
					})
					
<!-- info sheets -->
					let infoServiceData=[];
                    let infoSQKey=sQbyType.find((d)=>{
                        return d.key=='Information_Service_Quality';
                    })
                    
                    infoSQKey?.values.forEach((d,i)=>{
                        infoServiceData.push({"row":i+7,"ID":d.id,"Full Name":d.name,"Label":d.shortName,"Description":d.description,"Sequence No":d.serviceIndex,"Weighting":d.serviceWeighting,"Name Translation":"","Description Translation":"","Language":""})
                    })
                     
                    excelSheet.push({
                        "id":5,
                        "name":"Information Service Quals",
                        "worksheetNameNice":"Information Service Quals",
                        "worksheetName":"Information_Service_Quals",
                        "description":"List of information service qualities.  Note language will not pre-populate",
                        "heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Full Name"},
                        {"col":"D", "name":"Label"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Weighting"}, {"col":"H", "name":"Name Translation"}, {"col":"I", "name":"Description Translation"}, {"col":"J", "name":"Language"}],
                        "data":infoServiceData
                    })
                    let isqvs=[];

                    infoSQKey?.values.forEach((e)=>{
                         e.sqvs?.forEach((f)=>{
                             f['sq']=e.name;
							 isqvs.push(f)
                        })
                    })
                    let infoSQKeyData=[];

                    isqvs.forEach((d,i)=>{
                        infoSQKeyData.push({"row":i+7,"ID":d.id,"Service Quality":d.sq, "Value":d.value,"Description":d.description,"Sequence No":d.index,"Colour":d.elementBackgroundColour, "Style Class":"", "Score":d.score, "Name Translation":"","Description Translation":"","Language":"", "Mapper": d.sq +' - '+d.value})
                    })
                    excelSheet.push({
                        "id":6,
                        "name":"Information Service Qual Values",
                        "worksheetNameNice":"Information Service Qual Values",
                        "worksheetName":"Information_Service_Qual_Values",
                        "description":"List of information service quality values.  Note language will not pre-populate",
                        "heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Service Quality"},
                        {"col":"D", "name":"Value"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Colour"}, {"col":"H", "name":"Style Class"}, {"col":"I", "name":"Score"},{"col":"J", "name":"Name Translation"}, {"col":"K", "name":"Description Translation"}, {"col":"L", "name":"Language"}, {"col":"M", "name":"Mapper"}],
                        "data":infoSQKeyData
                    })					

<!-- app sheets -->
let appServiceData=[];
let appSQKey=sQbyType.find((d)=>{
	return d.key=='Application_Service_Quality';
})

appSQKey?.values.forEach((d,i)=>{
	appServiceData.push({"row":i+7,"ID":d.id,"Full Name":d.name,"Label":d.shortName,"Description":d.description,"Sequence No":d.serviceIndex,"Weighting":d.serviceWeighting,"Name Translation":"","Description Translation":"","Language":""})
})
 
excelSheet.push({
	"id":5,
	"name":"Application Service Quals",
	"worksheetNameNice":"Application Service Quals",
	"worksheetName":"Application_Service_Quals",
	"description":"List of application service qualities.  Note language will not pre-populate",
	"heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Full Name"},
	{"col":"D", "name":"Label"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Weighting"}, {"col":"H", "name":"Name Translation"}, {"col":"I", "name":"Description Translation"}, {"col":"J", "name":"Language"}],
	"data":appServiceData
})
let asqvs=[];

appSQKey?.values.forEach((e)=>{
	 e.sqvs?.forEach((f)=>{
		 f['sq']=e.name;
		 asqvs.push(f)
	})
})
let appSQKeyData=[];

asqvs.forEach((d,i)=>{
	appSQKeyData.push({"row":i+7,"ID":d.id,"Service Quality":d.sq, "Value":d.value,"Description":d.description,"Sequence No":d.index,"Colour":d.elementBackgroundColour, "Style Class":"", "Score":d.score, "Name Translation":"","Description Translation":"","Language":"", "Mapper": d.sq +' - '+d.value})
})
excelSheet.push({
	"id":6,
	"name":"Application Service Qual Values",
	"worksheetNameNice":"Application Service Qual Values",
	"worksheetName":"Application_Service_Qual_Values",
	"description":"List of application service quality values.  Note language will not pre-populate",
	"heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Service Quality"},
	{"col":"D", "name":"Value"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Colour"}, {"col":"H", "name":"Style Class"}, {"col":"I", "name":"Score"},{"col":"J", "name":"Name Translation"}, {"col":"K", "name":"Description Translation"}, {"col":"L", "name":"Language"}, {"col":"M", "name":"Mapper"}],
	"data":appSQKeyData
})					

<!-- tech sheets -->
let techServiceData=[];
let techSQKey=sQbyType.find((d)=>{
	return d.key=='Technology_Service_Quality';
})

techSQKey?.values.forEach((d,i)=>{
	techServiceData.push({"row":i+7,"ID":d.id,"Full Name":d.name,"Label":d.shortName,"Description":d.description,"Sequence No":d.serviceIndex,"Weighting":d.serviceWeighting,"Name Translation":"","Description Translation":"","Language":""})
})
 
excelSheet.push({
	"id":7,
	"name":"Technology Service Quals",
	"worksheetNameNice":"Technology Service Quals",
	"worksheetName":"Technology_Service_Quals",
	"description":"List of technology service qualities.  Note language will not pre-populate",
	"heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Full Name"},
	{"col":"D", "name":"Label"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Weighting"}, {"col":"H", "name":"Name Translation"}, {"col":"I", "name":"Description Translation"}, {"col":"J", "name":"Language"}],
	"data":techServiceData
})
let tsqvs=[];

techSQKey?.values.forEach((e)=>{
	 e.sqvs?.forEach((f)=>{
		 f['sq']=e.name;
		 tsqvs.push(f)
	})
})
let techSQKeyData=[];

tsqvs.forEach((d,i)=>{
	techSQKeyData.push({"row":i+7,"ID":d.id,"Service Quality":d.sq, "Value":d.value,"Description":d.description,"Sequence No":d.index,"Colour":d.elementBackgroundColour, "Style Class":"", "Score":d.score, "Name Translation":"","Description Translation":"","Language":"","Mapper": d.sq +' - '+d.value})
})
excelSheet.push({
	"id":8,
	"name":"Technology Service Qual Values",
	"worksheetNameNice":"Technology Service Qual Values",
	"worksheetName":"Technology_Service_Qual_Values",
	"description":"List of technology service quality values.  Note language will not pre-populate",
	"heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Service Quality"},
	{"col":"D", "name":"Value"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Colour"}, {"col":"H", "name":"Style Class"}, {"col":"I", "name":"Score"},{"col":"J", "name":"Name Translation"}, {"col":"K", "name":"Description Translation"}, {"col":"L", "name":"Language"}, {"col":"M", "name":"Mapper"}],
	"data":techSQKeyData
})
<!-- perf categories-->
let pmcData=[]
perfCategory.forEach((d,i)=>{ 
		pmcData.push({"row":i+7,"ID":d.id,"Full Name":d.name,"Label":d.shortName,"Description":d.description,"Sequence No":d.seqNo,"Performance Measure Class":d.enumClass,"Name Translation":"","Description Translation":"","Language":""}) 
})

excelSheet.push({
	"id":9,
	"name":"Perf Measure Categories",
	"worksheetNameNice":"Perf Measure Categories",
	"worksheetName":"Perf_Measure_Categories",
	"description":"List of performance measure categories",
	"heading":[{"col":"B", "name":"ID"}, {"col":"C", "name":"Full Name"},
	{"col":"D", "name":"Label"}, {"col":"E", "name":"Description"}, {"col":"F", "name":"Sequence No"}, {"col":"G", "name":"Performance Measure Class"}, {"col":"H", "name":"Name Translation"}, {"col":"I", "name":"Description Translation"}, {"col":"J", "name":"Language"}],
	"data":pmcData
});

let pmcCData=[]
perfCategory.forEach((d,i, array)=>{ 
	d.classes.forEach((e)=>{
		pmcCData.push({"row":i+7,"Performance Measure Category":d.name,"Meta-Class":e.id}) 
		if (i === array.length - 1){
			let start=i+7+1
			for(j=start;j&lt;start+100;j++){
				pmcCData.push({"row":j,"Performance Measure Category":"","Meta-Class":""})
			}
		}
	})
})

excelSheet.push({
	"id":10,
	"name":"Perf Measure Cat 2 Class",
	"worksheetNameNice":"Perf Measure Cat 2 Class",
	"worksheetName":"Perf_Measure_Cat_2_Class",
	"description":"Performance measure categories to classes they support. NOTE: Add Meta Class manually, these are the classes that the performance category applies to.",
	"heading":[{"col":"B", "name":"Performance Measure Category"}, {"col":"C", "name":"Meta-Class"}],
	"lookups":[{"column":"B","columnNum":"1", "lookUpSheet":"Perf Measure Categories", "lookupCol":"C", "val":"allPMCs"}],
	"data":pmcCData
});


let pmcSQData=[]
perfCategory.forEach((d,i, array)=>{
	if(d.sqs){ 
	d.sqs.forEach((e)=>{
		if(e.type=='Business_Service_Quality'){
			pmcSQData.push({"row":i+7,"Performance Measure Category":d.name,"Business Service Quality":e.name, "Technology Service Quality":"","Information Service Quality":"","Application Service Quality":""}) 
		}else if(e.type=='Technology_Service_Quality'){
			pmcSQData.push({"row":i+7,"Performance Measure Category":d.name,"Business Service Quality":"", "Technology Service Quality":e.name,"Information Service Quality":"","Application Service Quality":""}) 
		}else if(e.type=='Information_Service_Quality'){
			pmcSQData.push({"row":i+7,"Performance Measure Category":d.name,"Business Service Quality":"", "Technology Service Quality":"","Information Service Quality":e.name,"Application Service Quality":""}) 
		}else if(e.type=='Application_Service_Quality'){
			pmcSQData.push({"row":i+7,"Performance Measure Category":d.name,"Business Service Quality":"", "Technology Service Quality":"","Information Service Quality":"","Application Service Quality":e.name}) 
		}
	})
	}
	if (i === array.length - 1){
		let start=i+7+1
		for(j=start;j&lt;start+100;j++){
			pmcSQData.push({"row":j,"Performance Measure Category":"","Business Service Quality":"", "Technology Service Quality":"","Information Service Quality":"","Application Service Quality":""})
		}
	}
	 
})

excelSheet.push({
	"id":11,
	"name":"Perf Measure Cat 2 SQ Map",
	"worksheetNameNice":"Perf Measure Cat 2 SQ Map",
	"worksheetName":"Perf_Measure_Cat_2_SQ_Map",
	"description":"Performance measure categories to service qualities they support.  ONE PER ROW ONLY",
	"heading":[{"col":"B", "name":"Performance Measure Category"}, {"col":"C", "name":"Business Service Quality"}, {"col":"D", "name":"Technology Service Quality"}, {"col":"E", "name":"Information Service Quality"}, {"col":"F", "name":"Application Service Quality"}],
	"lookups":[{"column":"B","columnNum":"1", "lookUpSheet":"Perf Measure Categories", "lookupCol":"C", "val":"allPMCs"},
				{"column":"C","columnNum":"2", "lookUpSheet":"Business Service Quals", "lookupCol":"C", "val":"allBSQs"},
				{"column":"D","columnNum":"3", "lookUpSheet":"Technology Service Quals", "lookupCol":"C", "val":"allTSQs"},
				{"column":"E","columnNum":"4", "lookUpSheet":"Information Service Quals", "lookupCol":"C", "val":"allISQs"},
				{"column":"F","columnNum":"5", "lookUpSheet":"Application Service Quals", "lookupCol":"C", "val":"allASQs"}
	],
	"data":pmcSQData
});

		        }); 
 <!-- Excel structure
set a row, and then the data dor each column

for lookups specify the column and col number to hold the lookup, the lookup sheet and it's lookup Column , give the lookup a name
Column is column in this sheet, columnNum is column number (starting from first populated column) in this sheet
lookupsheet is the source sheet
lookupcol is column in the source sheet
val is unique name for lookup, even if repeating give a different name

"lookups":[{"column":"B","columnNum":"2", "lookUpSheet":"John_ID", "lookupCol":"B", "val":"prod1"}]
-->
		$('#getExcel').off().on('click',function(){
             
			let excelFile;
			<!-- if lookups then set to true -->
			excelFile={"sheets":excelSheet, "lookups": "true"};
           // console.log('ex',excelFile)
		<!--	 excelFile={"sheets":[{
				"id":1,
				"name":"NIST ID Import",
				"worksheetNameNice":"NIST ID",
				"worksheetName":"NIST_ID",
				"description":"Maps NIST IDs to products in Essential",
				"heading":[{"col":"A", "name":""}, {"col":"B", "name":"ID"}, {"col":"C", "name":"NAME"}, {"col":"D", "name":"NISTID"}, {"col":"E", "name":"NISTID2"}, {"col":"E", "name":"NISTID3"}],
				"data":[{"row":"8","id":"id1","name":"Product A","nistid":"Nist1","nistid1":"Nist2A1","nistid2":"Nist2A2"},
				{"row":"9","id":"id2","name":"Product b","nistid":"Nist2A","nistid1":"Nist2A3","nistid2":"Nist2A4"},
				{"row":"10","id":"id3","name":"Product c","nistid":"Nist3B","nistid1":"Nist2A5","nistid2":"Nist2A6"},
				{"row":"11","id":"id4","name":"Product d","nistid":"Nist4","nistid1":"Nist2A7","nistid2":"Nist2A8"}],
				"lookups":[{"column":"B","columnNum":"2", "lookUpSheet":"John_ID", "lookupCol":"B", "val":"prod1"},{"column":"C","columnNum":"3","lookUpSheet":"JOE_ID", "lookupCol":"C", "val":"niid"}]
			 } ,
			{
				"id":2,
				"name":"John ID Import",
				"worksheetNameNice":"John ID",
				"worksheetName":"John_ID", 
				"description":"Maps NIST IDs to products in Essential",
				"heading":[{"col":"A", "name":"ID"}, {"col":"B", "name":"fff"}, {"col":"C", "name":"ggg"}],
				"data":[{"row":"8","id":"id1","name":"Product A","nistid":"Nist1"},{"row":"9","id":"id2","name":"Product b","nistid":"Nist2"},{"row":"10","id":"id3","name":"Product c","nistid":"Nist3"},{"row":"11","id":"id4","name":"Product d","nistid":"Nist4"}],
				"lookups":[{"column":"C","columnNum":"3", "lookUpSheet":"NIST_ID", "lookupCol":"A", "val":"idlu"}]
			},
			{
				"id":3,
				"name":"JOE ID Import",
				"worksheetNameNice":"JOE ID", 
				"worksheetName":"JOE_ID",
				"description":"Maps NIST IDs to products in Essential",
				"heading":[{"col":"A", "name":"ID", "data":"id"}, {"col":"B", "name":"NAME", "name"}, {"col":"C", "name":"NISTID"}, ],
				"data":[{"row":"8","id":"id1","name":"Product A","nistid":"Nist1"},{"row":"9","id":"id2","name":"Product b","nistid":"Nist2"},{"row":"10","id":"id3","name":"Product c","nistid":"Nist3"},{"row":"11","id":"id4","name":"Product d","nistid":"Nist4"}]
			 }]}-->
			 <xsl:call-template name="RenderOfficetUtilityFunctions"/>
			setExcel(excelFile, "Launchpad_Perf_Measures")
		})
    })

<!-- 
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
 
function setExcel(excelFile){ 
 

 
let worksheetsVar=[];
excelFile.sheets.forEach((s)=>{
	worksheetsVar.push(s.worksheetName)
})

console.log('excelTemplate',excelTemplate(excelFile));
let contentXML, stylesXML, metaXML, manifestXML, mimetypeXML;
getXML('user/content.xml').then(function(response){ 
	contentXML=response; 
}).then(function(response){   

	getXML('user/styles.xml').then(function(response){ 
	stylesXML=response; 
}).then(function(response){  

	getXML('user/meta.xml').then(function(response){ 
	metaXML=response; 
}).then(function(response){  

	getXML('user/manifest.xml').then(function(response){ 
		manifestXML=response; 
}).then(function(response){  

	getXML('user/mimetype').then(function(response){ 
		mimetypeXML=response; 
}).then(function(response){  
let meta='&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?>&lt;office:document-meta xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" office:version="1.3">&lt;office:meta>&lt;meta:generator>MicrosoftOffice/16.0 MicrosoftExcel/CalculationVersion-10911&lt;/meta:generator>&lt;dc:creator>Microsoft Office User&lt;/dc:creator>&lt;meta:creation-date>2022-09-17T13:59:29Z&lt;/meta:creation-date>&lt;dc:date>2022-09-19T09:26:31Z&lt;/dc:date>&lt;/office:meta>&lt;/office:document-meta>';
let contentHead='&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?>&lt;office:document-content xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">&lt;office:font-face-decls>&lt;style:font-face style:name="Calibri" svg:font-family="Calibri"/>&lt;/office:font-face-decls>&lt;office:automatic-styles>&lt;style:style style:name="ce1" style:family="table-cell" style:parent-style-name="Default" style:data-style-name="N0"/>&lt;style:style style:name="ce2" style:family="table-cell" style:data-style-name="N0">&lt;style:table-cell-properties style:vertical-align="automatic" fo:background-color="transparent"/>&lt;/style:style>&lt;style:style style:name="co1" style:family="table-column">&lt;style:table-column-properties fo:break-before="auto" style:column-width="3.91583333333333cm"/>&lt;/style:style>&lt;style:style style:name="co2" style:family="table-column">&lt;style:table-column-properties fo:break-before="auto" style:column-width="4.97416666666667cm"/>&lt;/style:style>&lt;style:style style:name="co3" style:family="table-column">&lt;style:table-column-properties fo:break-before="auto" style:column-width="1.71979166666667cm"/>&lt;/style:style>&lt;style:style style:name="ro1" style:family="table-row">&lt;style:table-row-properties style:row-height="16pt" style:use-optimal-row-height="true" fo:break-before="auto"/>&lt;/style:style>&lt;style:style style:name="ta1" style:family="table" style:master-page-name="mp1">&lt;style:table-properties table:display="true" style:writing-mode="lr-tb"/>&lt;/style:style>&lt;/office:automatic-styles>&lt;office:body>&lt;office:spreadsheet>';
          
let contentBody=excelTemplate(excelFile);
let contentFoot='&lt;/office:spreadsheet>&lt;/office:body>&lt;/office:document-content>';

let content= contentHead+contentBody+contentFoot;


console.log('content',content)
var zip = new JSZip();



zip.file("content.xml", content)
zip.folder("META-INF").file("manifest.xml", manifestXML)
zip.file("mimetype", mimetypeXML)
zip.file("meta.xml", metaXML)
zip.file("styles.xml", stylesXML)
var zipConfig = {
			type: 'blob',
			mimeType: 'application/vnd.oasis.opendocument.spreadsheet'
		};

 
zip.generateAsync(zipConfig)
	.then(function (blob) {
    saveAs(blob, "testODS.ods");
});
console.log('zip',zip) 
})
})
})
}) 
})
}; -->
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
<xsl:template match="node()" mode="perfCategory">
<xsl:variable name="thisperfCategorySQs" select="$perfCategorySQs[name=current()/own_slot_value[slot_reference = 'pmc_service_qualities']/value]"/>
<xsl:variable name="thispmc" select="$classes[name=current()/own_slot_value[slot_reference = 'pmc_measures_ea_classes']/value]"/>
<xsl:variable name="thispmcClass" select="$classes[name=current()/own_slot_value[slot_reference = 'enumeration_value_for_classes']/value]"/>
	{"id":"<xsl:value-of select="current()/name"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
	 "type": "<xsl:value-of select="current()/type"/>",
	 "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isForJSONAPI" select="false()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
	 "classes":[<xsl:for-each select="$thispmc">{"id":"<xsl:value-of select="current()/name"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
	 "enumClass":"<xsl:value-of select="$thispmcClass/own_slot_value[slot_reference='name']/value"/>",
	 "seqNo":"<xsl:value-of select="$thispmcClass/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>",
	 "shortName":"<xsl:value-of select="$thispmcClass/own_slot_value[slot_reference='short_name']/value"/>",
	 "sqs":[<xsl:for-each select="$thisperfCategorySQs">{"id":"<xsl:value-of select="current()/name"/>",
	 "type": "<xsl:value-of select="current()/type"/>",
	 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
	}<xsl:if test="position()!=last()">,</xsl:if>
		
</xsl:template>
</xsl:stylesheet>
