<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:pro="http://protege.stanford.edu/xml"
	xmlns:eas="http://www.enterprise-architecture.org/essential"
	xmlns:functx="http://www.functx.com">
	<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Service', 'Application_Provider_Interface', 'Application_Provider', 'Business_Process', 'Application_Strategic_Plan', 'Site', 'Group_Actor', 'Technology_Component', 'Technology_Product', 'Infrastructure_Software_Instance', 'Hardware_Instance', 'Application_Software_Instance', 'Information_Store_Instance', 'Technology_Node', 'Individual_Actor', 'Application_Function', 'Application_Function_Implementation', 'Enterprise_Strategic_Plan', 'Information_Representation')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"/>
    <xsl:variable name="anAPIReportCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"/>
    <xsl:variable name="anAPIAppCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"/>
 

	<!-- START VIEW SPECIFIC SETUP VARIABES -->
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
        
        PPTX - powerpoint generation

Copyright (c) 2015-Present Brent Ely
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, 
publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 
	-->
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<xsl:template match="knowledge_base">
        <xsl:call-template name="docType"></xsl:call-template>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportCaps"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathAppCaps">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIAppCaps"/>
            </xsl:call-template>
        </xsl:variable>
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
					<xsl:value-of select="eas:i18n('PowerPoint Manager')"/>
				</title>
                <style>
                .clicked{
                    background-color:#d3d3d3;
                }
                td {
                    padding:3px;
                }
                .generate{
                    border-top:1pt solid #d3d3d3;
                }
                </style>
                <script src="js/pptxgenjs/dist/pptxgen.bundle.js"></script>
                <script src="js/d3/d3.v5.9.7.min.js"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
                <div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('PowerPoint Manager')"></xsl:value-of>  </span>
								 
								</h1>
							</div>
						</div>
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
                <div class="col-xs-8">
                <table class="table table-striped">
                        <thead>
                            <tr>
                                <th width="300px"><xsl:value-of select="eas:i18n('Slide')"/></th>
                                <th width="100px"><xsl:value-of select="eas:i18n('Add to Export')"/></th>
                            </tr>
                        </thead>
                        <tbody>    
                        <tr>
                            <td><xsl:value-of select="eas:i18n('Business Capability Model to level 2')"/></td>
                            <td>
                                <button id="capabilityModel" class="btn btn-default btn-sm"><i class="fa fa-plus right-5"/><xsl:value-of select="eas:i18n('Add')"/></button> 
                            </td>
                        </tr>
                        <tr>
                            <td><xsl:value-of select="eas:i18n('Business Capability Model to level 2 with Application counts')"/></td>
                            <td>
                                <button id="capabilityModelApps" class="btn btn-default btn-sm"><i class="fa fa-plus right-5"/><xsl:value-of select="eas:i18n('Add')"/></button> 
                            </td>
                        </tr>
                        <tr>
                            <td><xsl:value-of select="eas:i18n('Application Capability Model to level 2')"/></td>
                            <td>
                                <button id="appCapabilityModel" class="btn btn-default btn-sm"><i class="fa fa-plus right-5"/><xsl:value-of select="eas:i18n('Add')"/></button> 
                            </td>
                        </tr>
                        <tr>
                            <td><xsl:value-of select="eas:i18n('Application Capability Model to level 2 with Application Services')"/></td>
                            <td>
                                <button id="appCapabilityModelwithServices" class="btn btn-default btn-sm"><i class="fa fa-plus right-5"/><xsl:value-of select="eas:i18n('Add')"/></button> 
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th class="generate">&#160;</th>
                            <th class="generate">
                                <button id="generate" class="btn btn-success btn-sm btn-block"><i class="fa fa-cogs right-5"/><xsl:value-of select="eas:i18n('Generate PowerPoint')"/></button>
                            </th>
                        </tr>
                    </tfoot>
                    </table>
                </div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
			<script>
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
                        <xsl:with-param name="viewerAPIPath" select="$apiPath"/>  
                        <xsl:with-param name="viewerAPIPathCaps" select="$apiPathCaps"/>  
                        <xsl:with-param name="viewerAPIPathAppCaps" select="$apiPathAppCaps"/>  
				</xsl:call-template>
			</script>
</html>
</xsl:template>

<xsl:template name="RenderViewerAPIJSFunction">	
        <xsl:param name="viewerAPIPath"/> 
        <xsl:param name="viewerAPIPathCaps"/>
        <xsl:param name="viewerAPIPathAppCaps"/>  
        //a global variable that holds the data returned by an Viewer API Report, one for each report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';  
        var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
        var viewAPIDataAppCaps = '<xsl:value-of select="$viewerAPIPathAppCaps"/>'; 
	 
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
	
			 
		
            $('document').ready(function (){	
                
                Promise.all([
                promise_loadViewerAPIData(viewAPIData),
                promise_loadViewerAPIData(viewAPIDataCaps),
                promise_loadViewerAPIData(viewAPIDataAppCaps) 
                ]).then(function(responses) {
                let capabilities=responses[1];
                let appArray=responses[0];
                let appCapArray=responses[2];
                let codebase=appArray.codebase;
				let delivery=appArray.delivery;
                let lifecycles=appArray.lifecycles;
                let filters=responses[0].filters;
	 			console.log('appCappArray',appCapArray)
				 appArray.applications.forEach((d)=>{

					let thisCode=codebase.find((e)=>{
						return e.id == d.codebaseID
					});
		
					if(d.codebaseID.length&gt;0){
					d['codebase']=thisCode.shortname;
					d['codebaseColor']=thisCode.colour;
					d['codebaseText']=thisCode.colourText;
					}
					else
					{
						d['codebase']="Not Set";
						d['codebaseColor']="#d3d3d3";
						d['codebaseText']="#000";
					}
				
				
					let thisLife=lifecycles.find((e)=>{
						return e.id == d.lifecycle;
					})
					
					if(d.lifecycle.length != 0){
						d['lifecycle']=thisLife?.shortname;
						d['lifecycleColor']=thisLife?.colour;
						d['lifecycleText']=thisLife?.colourText;
					}
					else
					{
						d['lifecycle']="Not Set";
						d['lifecycleColor']="#d3d3d3";
						d['lifecycleText']="#000";
					}

					let thisDelivery=delivery.find((e)=>{
						return e.id == d.deliveryID;
					});
					if(d.deliveryID.length&gt;0){
						d['delivery']=thisDelivery.shortname;
						d['deliveryColor']=thisDelivery.colour;
						d['deliveryText']=thisDelivery.colourText;
						}
						else
						{
							d['delivery']="Not Set";
							d['deliveryColor']="#d3d3d3";
							d['deliveryText']="#000";
						}	
					
				 	 });
        
                 var byCodebase = d3.nest()
                    .key(function(d) { return d.lifecycle; })
                    .entries(appArray.applications);
 
                      let codebaseLabels=[];
                      let codebaseValues=[];

                      byCodebase.forEach((e)=>{
                        codebaseLabels.push(e.key)
                        codebaseValues.push(e.values.length)
                      })

                      var byDelivery = d3.nest()
                    .key(function(d) { return d.delivery; })
                    .entries(appArray.applications);
 

                      let deliveryLabels=[];
                      let deliveryValues=[];

                      byDelivery.forEach((e)=>{
                        deliveryLabels.push(e.key)
                        deliveryValues.push(e.values.length)
                      })      

                // 1. Create a new Presentation
                let pres = new PptxGenJS();

                // 2. Add a Slide
               
            
                let dataChartCodebase = [
                {
                    name: "Codebase Status",
                    labels: codebaseLabels,
                    values: codebaseValues,
                },
                ];

                let dataChartDelivery = [
                {
                    name: "Delivery Status",
                    labels: deliveryLabels,
                    values: deliveryValues,
                },
                ];

                $('#appDelivery').on('click', function(){
                $(this).removeClass('btn-primary');
                let slide = pres.addSlide();
                slide.addChart(pres.ChartType.pie, dataChartCodebase, { 
                    x: 0.2,
                    y: 0.2,
                    w: "44%",
                    h: "90%",
                    name: "Apps by Codebase",
                    chartArea: { fill: { color: "F1F1F1" } },
                    chartColors: ['#00838F', '#F3E5F5', '#BA68C8', '#8E24AA', '#B2DFDB', 
		                            '#80DEEA', '#5DADE2', '#00838F', '#16A085', '#1F618D'],
                    //
                    legendPos: "l",
                    legendFontFace: "Courier New",
                    showLegend: true,
                    //
                    showLeaderLines: true,
                    showPercent: false,
                    showValue: true,
                    dataLabelColor: "000000",                        
                    showTitle: true,    
		            title: "By Codebase",
                    dataLabelFontSize: 12,
                    dataLabelPosition: "bestFit", // 'bestFit' | 'outEnd' | 'inEnd' | 'ctr' 
                    }) 
  
                    slide.addChart(pres.ChartType.pie, dataChartDelivery, { 
                    x: 5,
                    y: 0.2,
                    w: "44%",
                    h: "90%",
                    name: "Apps by Delivery Model",
                    chartArea: { fill: { color: "F1F1F1" } },
                    chartColors: ['#00838F', '#F3E5F5', '#BA68C8', '#8E24AA', '#B2DFDB', 
		                            '#80DEEA', '#5DADE2', '#00838F', '#16A085', '#1F618D'],
                    //
                    legendPos: "l",
                    legendFontFace: "Courier New",
                    showLegend: true,
                    //
                    showLeaderLines: true,
                    showPercent: false,
                    showValue: true,                     
                    showTitle: true,  
		            title: "By Delivery Model",
                    dataLabelColor: "000000",
                    dataLabelFontSize: 12,
                    dataLabelPosition: "bestFit", // 'bestFit' | 'outEnd' | 'inEnd' | 'ctr' 
                    })
                 })

                $('#capabilityModelApps').on('click', function(){
                    $(this).removeClass('btn-default');
                    $(this).addClass('btn-success');
                    $(this).html('<i class="fa fa-check right-5"/><xsl:value-of select="eas:i18n('Added')"/>');
                    setCapModel('apps')
                })
                   
                $('#capabilityModel').on('click', function(){
                    $(this).removeClass('btn-default');
                    $(this).addClass('btn-success');
                    $(this).html('<i class="fa fa-check right-5"/><xsl:value-of select="eas:i18n('Added')"/>');
                    setCapModel('none')
                });   
                
                $('#appCapabilityModel').on('click', function(){
                    $(this).removeClass('btn-default');
                    $(this).addClass('btn-success');
                    $(this).html('<i class="fa fa-check right-5"/><xsl:value-of select="eas:i18n('Added')"/>');
                    setAppCapModel('none')
                });    
                       
                 
                $('#appCapabilityModelwithServices').on('click', function(){
                    $(this).removeClass('btn-default');
                    $(this).addClass('btn-success');
                    $(this).html('<i class="fa fa-check right-5"/><xsl:value-of select="eas:i18n('Added')"/>');
                    setAppCapModel('services')
                });     
                        

<!-- application capability model-->
function setAppCapModel(modelType){
    let slide = pres.addSlide();
   
   var overallHeight=1; 
   let list=[];
   appCapArray.capability_hierarchy.forEach((c)=>{
      
       list.push([{text: c.name, "main":true, options: { colspan: 6, fill: { color: "6DDBDE" }, bold:true } }])

       const chunkSize = 6; 
           for (let i = 0; i &lt; c.childrenCaps.length; i += chunkSize) {
               const chunk = c.childrenCaps.slice(i, i + chunkSize);
          
               let arrayLine=[] 
               chunk.forEach((e)=>{ 

                   if(e.name){
                    if(modelType =='none'){
                        arrayLine.push({text: e.name, options: { fontSize: 7, fontFace: "Arial", color: "000000", breakLine: true}})
                       }
                       else{

                        let thisServices=[];
                        e.supportingServices.forEach((g)=>{
                            let thisCapServices=appCapArray.application_services.find((f)=>{
                                return g==f.id;
                            });
                            thisServices.push(thisCapServices)
                        })
 
                        let arrTextObjects = [
                            { text: e.name, options: { fontSize: 7, fontFace: "Arial", color: "000000", valign: "top", breakLine: true}}
                        ]; 
                        if(thisServices){
                            thisServices.forEach((s)=>{
                                arrTextObjects.push( { text: '- ' + s.name, options: { fontSize: 6, fontFace: "Arial", color: "000000", breakLine: true,  valign: "top"} } )
                            })
                            console.log('arrTextObjects',arrTextObjects)
                        }
                        arrayLine.push({text: arrTextObjects})
                       }
                        
                   }else{
                   arrayLine.push({"name":""})
                   }
               })
          console.log('arrayLine',arrayLine)
               list.push(arrayLine)
               // do whatever
           }
           console.log('list',list)
   })

   list.forEach((e)=>{ 
       if(e[0].main == true){ 
       }else{
          if(e.length&lt;6){
           let missing=6-e.length;

           for(i=0;i&lt;missing; i++){
               e.push({"name":""})
           }
       } 
       }
   }) 


  let tabOpts1 = {
               x: 0.1,
               y: 0.1,
               w: "98%",
               h: 2,
               rowH: 0.05,
               fill: { color: "C3F1F3" },
               color: "3D3D3D",
               fontSize: 8,
               fontFace: "arial",
               border: { pt: 2, color: "ffffff" },
               align: "left",
               valign: "top"
           };
        
           // NOTE: Follow HTML conventions for colspan/rowspan cells - cells spanned are left out of arrays - see above
           // The table above has 6 columns, but each of the 3 rows has 4-5 elements as colspan/rowspan replacing the missing ones
           // (e.g.: there are 5 elements in the first row, and 6 in the second)
           slide.addTable(list, tabOpts1);
}


<!-- business capability model --> 
function setCapModel(modelType){
    let slide = pres.addSlide();
   
   var overallHeight=1; 
   let list=[];
   capabilities.busCapHierarchy.forEach((c)=>{
       let thisCapApps=capabilities.busCaptoAppDetails.find((f)=>{
           return c.id==f.id;
       })
if(modelType =='none'){
    list.push([{text: c.name, "main":true, options: { colspan: 6, fill: { color: "6DDBDE" }, bold:true } }])
}
else{
      list.push([{text: c.name + " ("+thisCapApps.apps.length+")", "main":true, options: { colspan: 6, fill: { color: "6DDBDE" }, bold:true } }])
}
       const chunkSize = 6; 
           for (let i = 0; i &lt; c.childrenCaps.length; i += chunkSize) {
               const chunk = c.childrenCaps.slice(i, i + chunkSize);
          
               let arrayLine=[] 
               chunk.forEach((e)=>{ 
                   if(e.name){
                       let thisCapApps=capabilities.busCaptoAppDetails.find((f)=>{
                           return e.id==f.id;
                       })
                       if(modelType =='none'){
                        arrayLine.push({text: [
                       { text: e.name, options: { fontSize: 7, fontFace: "Arial", color: "000000", breakLine: true, fill:{ color : "6DDBDE"} } }]})
                       }
                       else{
                   arrayLine.push({text: [
                       { text: e.name + " ("+thisCapApps.apps.length+")", options: { fontSize: 7, fontFace: "Arial", color: "000000", breakLine: true, fill:{ color : "6DDBDE"} } }]})
                   }
                   }else{
                   arrayLine.push({"name":""})
                   }
               })
          
               list.push(arrayLine)
               // do whatever
           }
     
   })

   list.forEach((e)=>{ 
       if(e[0].main == true){ 
       }else{
          if(e.length&lt;6){
           let missing=6-e.length;

           for(i=0;i&lt;missing; i++){
               e.push({"name":""})
           }
       } 
       }
   }) 


  let tabOpts1 = {
               x: 0.1,
               y: 0.1,
               w: "98%",
               h: 2,
               rowH: 0.05,
               fill: { color: "C3F1F3" },
               color: "3D3D3D",
               fontSize: 8,
               fontFace: "arial",
               border: { pt: 2, color: "ffffff" },
               align: "left",
               valign: "middle",
           };
        
           // NOTE: Follow HTML conventions for colspan/rowspan cells - cells spanned are left out of arrays - see above
           // The table above has 6 columns, but each of the 3 rows has 4-5 elements as colspan/rowspan replacing the missing ones
           // (e.g.: there are 5 elements in the first row, and 6 in the second)
           slide.addTable(list, tabOpts1);
}

                // 4. Save the Presentation
               $('#generate').on('click', function(){
                    pres.writeFile({ fileName: "Essential Presentation.pptx" });
                })
                
            })
        })
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
</xsl:stylesheet>
