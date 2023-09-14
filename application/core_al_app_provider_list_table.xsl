<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	 <xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS --> 

    <xsl:param name="viewScopeTermIds"/>
    <xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/> 

	<!-- END GENERIC CATALOGUE PARAMETERS -->
    <xsl:variable name="repYN"><xsl:choose><xsl:when test="$targetReportId"><xsl:value-of select="$targetReportId"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>

	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="apis" select="/node()/simple_instance[type='Application_Provider_Interface']"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Application_Provider', 'Composite_Application_Provider','Business_Capability')"/>

	<!-- START GENERIC LINK VARIABLES -->
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
	<xsl:variable name="appData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
    <xsl:variable name="appSvcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"></xsl:variable>
	<xsl:variable name="appMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>
   
    <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable> 
        <xsl:variable name="apiAppsSvc">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appSvcData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable> 
		<xsl:variable name="apiAppsMart">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appMartData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable> 
		
        
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
                <title><xsl:value-of select="eas:i18n('Application Catalogue Table')"/></title>
              	<!--script to support smooth scroll back to top of page-->
			 
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<style>
					.CharacterContainer {
                            text-align: center;
                            font-size: 1.1em;
                            line-height: 1.5em;
                            background-color: #dfdfdf;
                            color: white;
                            cursor: pointer; 
                            display:inline-block
                            }
                    .CharacterElement {
                                margin: 10px;
                                display:inline-block;
                                cursor: pointer; 
                            }
                            
                    .Inactive {
                                color: grey;
                                cursor: default;
                            }
                    .Active {
                                font-size: 1.2em;
                                font-weight:bold;
                                color:#000;
                                cursor: default;
                            } 
					.list {padding-left:10px}  
					.filtParent{
						position:absolute;
						top:-15px;
						right:10px;
					}   
					.appTypes li{
						display: inline;
					}
                    .caps {
                        padding:3px;
                        border-left: 3pt solid #3fceb9;
                        font-size:1.1em;
                        border-bottom: 2pt solid #ffffff;
                    }            
                    table.table-bordered.dataTable tbody th,
                    table.table-bordered.dataTable tbody td {
                    	word-break: break-word;
					}  
					.filtParent{
						position:absolute;
						top:-15px;
						right:10px;
					}  
					.filtBtn{
						position:relative;
						border:1pt solid #d3d3d3;
						border-radius:5px;
						padding:1px;
						margin:2px;
						min-width:90px;
						text-align:center;
						background-color:#fff;
						display:inline-block;
					}
					.btnOn{
						background-color:#d3d3d3;
					}       
				</style>
			 	  
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				 	 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Catalogue')"/></span>
								</h1>
							</div>
                        </div>
						<div class="col-xs-12 ">
							<div class="pull-right filtParent">
								
							<ul class="appTypes" style="z-index:10">Include:
								<li ><input type="checkbox" id="appBtn" name="appBtn" value="apps" class="btnOn" checked="true"></input>
								<label for="apps"> Applications</label>  </li>
								<li><input type="checkbox" id="moduleBtn" name="moduleBtn" value="modules" class="btnOn" checked="true"/>
								<label for="modules"> Modules</label>  </li>
								<li><input type="checkbox" id="apiBtn" name="apiBtn" value="apis"/>
								<label for="apis"> APIs</label> </li>
							</ul>
						 
							</div>
						</div>
						<div class="clearfix bottom-10"/>	
                        <div class="col-xs-12"> 
                                <table class="table table-striped table-condensed top-10 small dataTable" role="grid" aria-describedby="ebfw-editor-selection-table_info" style="width: 100%;" id="dt_Capabilities">
                                        <thead>
                                            <tr>
												<th>

												</th>
                                                <th>
                                                    <xsl:value-of select="eas:i18n('Application')"/>
                                                </th>
                                                <th>
                                                    <xsl:value-of select="eas:i18n('Description')"/>
                                                </th>
                                             	<th>
                                                    <xsl:value-of select="eas:i18n('Services')"/>
                                                </th>
                                                <th>
                                                    <xsl:value-of select="eas:i18n('Status')"/>
												</th>
												<th>
													<xsl:value-of select="eas:i18n('Family')"/>
												</th>
												<th>
														<xsl:value-of select="eas:i18n('Supplier')"/>
												</th>
											 
                                            </tr>
                                        </thead>
                                        <tfoot>
                                            <tr>
												<th>
														 
												</th>
                                                <th>
                                                    <xsl:value-of select="eas:i18n('Application')"/>
                                                </th>
                                                <th>
                                                    <xsl:value-of select="eas:i18n('Description')"/>
                                                </th>
                                               <th>
                                                    <xsl:value-of select="eas:i18n('Services')"/>
                                                </th>
                                                <th>
                                                    <xsl:value-of select="eas:i18n('Status')"/>
												</th>
												<th>
													<xsl:value-of select="eas:i18n('Family')"/>
												</th>
												<th>
														<xsl:value-of select="eas:i18n('Supplier')"/>
												</th> 
                                            </tr>
                                        </tfoot>
                                        <tbody>
                                            
                                        </tbody>
                                    </table>
                        </div>
                    </div>
                </div>
						
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

				<!-- caps template -->
		
            </body>
            
            <script id="life-template" type="text/x-handlebars-template">
               <button class="btn btn-sm"><xsl:attribute name="style">color:{{this.colourText}};background-color:{{this.colour}}</xsl:attribute>{{this.shortname}}</button>
            </script>
            <script id="list-template" type="text/x-handlebars-template">
                {{#each this.caps}} 
                        <div class="col-xs-4">
                            <div class="caps bottom-5">
                                <i class="fa fa-caret-right"> </i> {{#essRenderInstanceLink this 'Application_Provider'}}{{/essRenderInstanceLink}} 
                            </div>
                        </div>  
                 {{/each}}    
            </script>
            <script id="name-template" type="text/x-handlebars-template">
                {{#essRenderInstanceLink this 'Application_Provider'}}{{/essRenderInstanceLink}}       
		  </script>
		  <script id="select-template" type="text/x-handlebars-template">
			{{#essRenderInstanceLinkSelect this 'Application_Provider'}}{{/essRenderInstanceLinkSelect}}       
	  	  </script>
		  
          <script id="service-name" type="text/x-handlebars-template"> 
            <ul>
            {{#each this.services}}
            <li>  {{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</li>
            {{/each}}
            </ul>
		</script>    
		<script id="family-name" type="text/x-handlebars-template"> 
            <ul> 
			{{#each this.family}}	
            <li>  {{this.name}}</li>
            {{/each}}
            </ul>
        </script>   
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
                    <xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
                    <xsl:with-param name="viewerAPIPathAppsSvc" select="$apiAppsSvc"></xsl:with-param> 
                    <xsl:with-param name="viewerAPIPathAppsMart" select="$apiAppsMart"></xsl:with-param>
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPathApps"></xsl:param> 
		<xsl:param name="viewerAPIPathAppsSvc"></xsl:param> 
		<xsl:param name="viewerAPIPathAppsMart"></xsl:param> 
		
		//a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataSvc = '<xsl:value-of select="$viewerAPIPathAppsSvc"/>';
		var viewAPIDataMart = '<xsl:value-of select="$viewerAPIPathAppsMart"/>';
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		var promise_loadViewerAPIData = function (apiDataSetURL) {
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
		 

		var dynamicAppFilterDefs=[];	 
		var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
		var catalogueTable
		$('document').ready(function () {
			listFragment = $("#list-template").html();
            listTemplate = Handlebars.compile(listFragment);
            
            nameFragment = $("#name-template").html();
            nameTemplate = Handlebars.compile(nameFragment);
            
            lifeFragment = $("#life-template").html();
            lifeTemplate = Handlebars.compile(lifeFragment);

			const essLinkLanguage = '<xsl:value-of select="$i18n"/>';

			function essGetMenuName(instance) { 
		        let menuName = null;
		        if ((instance != null) &amp;&amp;
		            (instance.meta != null) &amp;&amp;
		            (instance.meta.classes != null)) {
		            menuName = instance.meta.menuId;
		        } else if (instance.classes != null) {
		            menuName = instance.meta.classes;
				}
			 
		        return menuName;
			}
			
			
			Handlebars.registerHelper('essRenderInstanceLinkSelect', function (instance,type) {

				let targetReport = "<xsl:value-of select="$repYN"/>";
		 
				if (targetReport.length &gt; 1) {
			 
					if (instance != null) {
						let linkMenuName = essGetMenuName(instance);
						let instanceLink = instance.name;
					 
						if (linkMenuName != null) {
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
							let linkClass = 'context-menu-' + linkMenuName;
							let linkId = instance.id + 'Link';
							let linkURL = reportURL;
							instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15"> ' + linkClass + '" href="' + linkHref + '" id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select1</button>'
			
						} else if (instanceLink != null) {
							let linkURL = reportURL;
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
							let linkClass = 'context-menu-' + linkMenuName;

							let linkId = instance.id + 'Link';
						//	instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';
							instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15" onclick="location.href=&quot;' + linkHref + '&quot;" id="' + linkId+'"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'
			
							
		
							return instanceLink;
						} else {
							return '';
						}
					}
				} else {
		 
					let thisMeta = meta.filter((d) => {
		                return d.classes.includes(type)
					});
 
				 
		            instance['meta'] = thisMeta[0]
		            let linkMenuName = essGetMenuName(instance);
		            let instanceLink = instance.name;
		            if (linkMenuName != null) {
		                let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		                let linkClass = 'context-menu-' + linkMenuName;
		                let linkId = instance.id + 'Link';
		                let linkURL = reportURL; 
						instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15 ' + linkClass + '" href="' + linkHref + '"  id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'
			
		                return instanceLink;
		            }
				}
            });

			Handlebars.registerHelper('essRenderInstanceLink', function (instance,type) {

				let targetReport = "<xsl:value-of select="$repYN"/>";
		 
				if (targetReport.length &gt; 1) {
			 
					if (instance != null) {
						let linkMenuName = essGetMenuName(instance);
						let instanceLink = instance.name;
					 
						if (linkMenuName != null) {
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
							let linkClass = 'context-menu-' + linkMenuName;
							let linkId = instance.id + 'Link';
							let linkURL = reportURL;
							instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';
						} else if (instanceLink != null) {
							let linkURL = reportURL;
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
							let linkClass = 'context-menu-' + linkMenuName;

							let linkId = instance.id + 'Link';
							instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';

							return instanceLink;
						} else {
							return '';
						}
					}
				} else {
		 
					let thisMeta = meta.filter((d) => {
		                return d.classes.includes(type)
					});
 
				 
		            instance['meta'] = thisMeta[0]
		            let linkMenuName = essGetMenuName(instance);
		            let instanceLink = instance.name;
		            if (linkMenuName != null) {
		                let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		                let linkClass = 'context-menu-' + linkMenuName;
		                let linkId = instance.id + 'Link';
		                let linkURL = reportURL;
		                instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';
				 
		                return instanceLink;
		            }
				}
            });
            
            Handlebars.registerHelper('essRenderInstanceLinkMenuOnly', function (instance, type) {

		        let thisMeta = meta.filter((d) => {
		            return d.classes.includes(type)
		        });
		        instance['meta'] = thisMeta[0]
		        let linkMenuName = essGetMenuName(instance);
		        let instanceLink = instance.name;
		        if (linkMenuName != null) {
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		            let linkClass = 'context-menu-' + linkMenuName;
		            let linkId = instance.id + 'Link';
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';

		            return instanceLink;
		        }
            });
            let allAppArr = [];
            let workingArr = []; 
            let svcArr=[];
            let lifecycleArr=[]; 
			Promise.all([
                promise_loadViewerAPIData(viewAPIData),
				promise_loadViewerAPIData(viewAPIDataSvc), 
				promise_loadViewerAPIData(viewAPIDataMart)
			]).then(function (responses) {
				meta = responses[0].meta;
				filters=responses[0].filters;
                workingArr = responses[0].applications;  
				lifecycleArr = responses[0].lifecycles ;
				workingArr = [...workingArr, ...responses[0].apis];
				martApps=responses[2].applications;
				responses[2]=[]; 
				workingArr.forEach((d)=>{ 
					if(d.containedApp){
						d.valueClass="Application_Provider";
					}
					let martMatch=martApps.find((e)=>{
						return d.id==e.id;
					})

					d['family']=martMatch.family;
					d['supplier']=martMatch.supplier;
				})
				dynamicAppFilterDefs=filters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
                svcArr=responses[1]; 
				workingArr.forEach((d) => {
					  
					d['meta'] = meta.filter((d) => {
						return d.classes.includes('Business_Process')
					})
                });
				allAppArr = JSON.parse(JSON.stringify(workingArr))
				 
                roadmapCaps = [];
                
				//setCatalogueTable(); 
				workingArr=allAppArr.filter((d)=>{
					return (d.valueClass == ('Composite_Application_Provider')) ||
					d.valueClass == ('Application_Provider')
				})
console.log('responses[0].filters',responses[0].filters)
				essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS'], responses[0].filters,true);

		$('#appBtn').off().on('click', function(){
			if($('#appBtn').hasClass('btnOn')){
			 
				$('#appBtn').removeClass('btnOn')
			}
			else{
			 
				$('#appBtn').addClass('btnOn')
			}
			setList()
		});
		$('#moduleBtn').off().on('click', function(){
			if($('#moduleBtn').hasClass('btnOn')){
				 
				$('#moduleBtn').removeClass('btnOn')
			}
			else{
			 
				$('#moduleBtn').addClass('btnOn')
			}
			setList()
		})	
		$('#apiBtn').off().on('click', function(){
			if($('#apiBtn').hasClass('btnOn')){
				 
				$('#apiBtn').removeClass('btnOn')
			}
			else{
			 
				$('#apiBtn').addClass('btnOn')
			}
			setList()
		})	
		
	function setList(){
		let wa=[];
		workingArr=allAppArr
		if($('#appBtn').hasClass('btnOn')){
			 
			workingArr=allAppArr.filter((d)=>{
				return (d.valueClass == ('Composite_Application_Provider')) ||
				d.valueClass == ('Application_Provider') ||
				d.valueClass == ('Application_Provider_Interface')
			})
		}
		else{ 
			workingArr=allAppArr.filter((d)=>{
				return !(d.valueClass ==('Composite_Application_Provider'))||
				d.valueClass == ('Application_Provider') ||
				d.valueClass == ('Application_Provider_Interface');
			})
		} 
		
		if($('#moduleBtn').hasClass('btnOn')){
			workingArr=workingArr.filter((d)=>{
				return (d.valueClass == ('Application_Provider'))||
				d.valueClass == ('Composite_Application_Provider') ||
				d.valueClass == ('Application_Provider_Interface');
			})
		}
		else{ 
			workingArr=workingArr.filter((d)=>{
				return !(d.valueClass == ('Application_Provider'))||
				d.valueClass == ('Composite_Application_Provider') ||
				d.valueClass == ('Application_Provider_Interface');
			});
		}
		
		if($('#apiBtn').hasClass('btnOn')){  
			workingArr=workingArr.filter((d)=>{
				return (d.valueClass == ('Application_Provider_Interface'))||
				d.valueClass == ('Composite_Application_Provider') ||
				d.valueClass == ('Application_Provider')
			})
		}
		else{ 
			workingArr=workingArr.filter((d)=>{
				return !(d.valueClass==('Application_Provider_Interface'))||
				d.valueClass == ('Composite_Application_Provider') ||
				d.valueClass == ('Application_Provider');
			});
		}
		 
		redrawView();

	}		 
			}).catch(function (error) {
				//display an error somewhere on the page
            });

var tblData;

            function renderCatalogueTableData(scopedData) {
			 
		        var serviceFragment = $("#service-name").html();
				var serviceTemplate = Handlebars.compile(serviceFragment);

				var familyFragment = $("#family-name").html();
				var familyTemplate = Handlebars.compile(familyFragment);
				  
				var selectFragment = $("#select-template").html();
				var selectTemplate = Handlebars.compile(selectFragment);
		
		        let inscopeApps = [];
                inscopeApps['apps'] = scopedData.apps
                 
		        //Note: The list of applications is based on the "inScopeApplications" variable which ony contains apps visible within the current roadmap time frame
		        for (var i = 0; inscopeApps.apps.length > i; i += 1) {
			
                let appInf = svcArr.applications_to_services.find((d)=>{
                    return inscopeApps.apps[i].id == d.id
                });
                
		            app = inscopeApps.apps[i];
       
                let appLife= lifecycleArr.find((d)=>{ 
                    return d.id == app.lifecycle;
                });
                
if(appLife){}else{appLife={"shortname":"Not Set","color":"#d3d3d3", "colourText":"#000000"}}
		          
		            //get the current App
                    appNameHTML = nameTemplate(inscopeApps.apps[i]); 
				 
		            //Apply handlebars template
                    let appSvcHTML = serviceTemplate(appInf);
					let appLifeHTML = lifeTemplate(appLife); 
					let appFamilyHTML= familyTemplate(app);
					selectHTML=selectTemplate(inscopeApps.apps[i]);  
					
					tblData.push({"select":selectHTML,"name":appNameHTML,"desc":app.description, "services": appSvcHTML ,"status":appLifeHTML,"family":appFamilyHTML,"supplier":app.supplier})
                      
		        }

		        return tblData;
		    }

            function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }
		
			var redrawView = function () {
				
				let scopedAppList = [];
				workingArr.forEach((d) => {
					scopedAppList.push(d)
				});
 
				let toShow = []; 
				  
                let workingAppsList = []; 
                let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
				let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
				let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');

				essResetRMChanges();
				let typeInfo = {
					"className": "Application_Provider",
					"label": 'Application',
					"icon": 'fa-desktop'
				}
				let scopedApps = essScopeResources(scopedAppList, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo);

				let showApps = scopedApps.resources; 
				let viewArray = {}; 
				viewArray['type'] = "<xsl:value-of select="$repYN"/>";
				viewArray['apps'] = showApps;
				$('#list').html(listTemplate(viewArray));
				setCatalogueTable(viewArray) 
			 
                $('#dt_Capabilities tfoot th').each(function () {
		            var title = $(this).text();
		            $(this).html('&lt;input type="text" placeholder="Search ' + title + '" /&gt;');
		        });

		        catalogueTable = $('#dt_Capabilities').DataTable({
		            paging: false,
		            deferRender: true,
		            scrollY: 350,
		            scrollCollapse: true,
		            info: true,
					sort: true,
					destroy : true,
		            responsive: false,
					"data":tblData,
					"stateSave": true,
                    "columns":[
						{
                            "data" : "select",
                            "width": "2%" 
						},
		                {
                            "data" :  "name",
                            "width": "15%"
		                },
		                {
							"data" : "desc",
							"width": "25%" 
						},
						{	"data":"services",
							"width": "20%",
							"visible": false
						},
						{	"data":"status",
							"width": "20%", 
							"visible": false					
						},
						{	"data":"family",
							"width": "15%" 					
						},
						{	"data":"supplier",
							"width": "10%", 
							"visible": false					
						}
						],
                        "columnDefs": [ {
							"targets": 0,
							"orderable": false
							} ],
						order: [[ 1, 'asc' ]],		
		            dom: 'Bfrtip',
					buttons: [ 
						'colvis',
		                'copyHtml5',
		                'excelHtml5',
		                'csvHtml5',
		                'pdfHtml5',
		                'print'
		            ]
		        });


		        // Apply the search
		        catalogueTable.columns().every(function () {
		            var that = this;

		            $('input', this.footer()).on('keyup change', function () {
		                if (that.search() !== this.value) {
		                    that
		                        .search(this.value)
		                        .draw();
		                }
		            });
		        });

		        catalogueTable.columns.adjust();

		        $(window).resize(function () {
		            catalogueTable.columns.adjust();
		        });
            
			}
		});

		function redrawView() { 
			essRefreshScopingValues()
		}




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
	<xsl:template match="node()" mode="apiInfo">
			{
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
			"name": "<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="isForJSONAPI" select="true()"/>
					 <xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>",
			"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription">
						<xsl:with-param name="isForJSONAPI" select="true()"/>
					 <xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>",
			"codebaseID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
			"deliveryID":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
			"lifecycle":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value)"/>"
			}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> </xsl:template>

</xsl:stylesheet>
