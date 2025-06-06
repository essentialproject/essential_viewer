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
	<xsl:variable name="linkClasses" select="('Technology_Product','Supplier')"/>

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
	<xsl:variable name="techData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Products and Suppliers']"></xsl:variable>
    <xsl:variable name="orgData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"></xsl:variable>

 
    <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiTechProds">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$techData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable> 
        <xsl:variable name="apiOrgs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$orgData"></xsl:with-param>
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
                <title><xsl:value-of select="eas:i18n('Technology Product Catalogue Table')"/></title>
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
                    .dataTable th,
                    .dataTable td {
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
                    .lifecycleBox{
                        width:80px;
                        height:60px;
                        display:inline-block;
                        border-radius: 0px 4px 40px 0px;
                        padding:2px;
                        margin-bottom:2px;
                        vertical-align:top;
                    }
                    .componentBox{
                        width:100px;
                        display:inline-block;
                        padding:2px;
                        border-radius: 5px 5px 0px 0px;
                        background-color:#efefef;
                        color:#000000;
                        border:1px solid #d3d3d3;
                        font-size:0.9em;
                    }
                    .statusBox{
                        width:100px; 
                        padding:2px;
                        border-radius:0px 0px 5px 5px;
                        background-color:#d3d3d3;
                        font-size:0.9em; 
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Product Catalogue')"/></span>
								</h1>
							</div>
                        </div>
 
						<div class="clearfix bottom-10"/>	
                        <div class="col-xs-12"> 
                            <table class="table table-striped table-condensed top-10 small dataTable" role="grid" aria-describedby="ebfw-editor-selection-table_info" id="dt_Capabilities">
								<thead>
									<tr id="headerRow">
										<!-- Headers will be appended here -->
									</tr>
								</thead>
								<tfoot>
									<tr id="footerRow">
										<!-- Footers will be appended here -->
									</tr>
								</tfoot>
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
			<script id="enum-template" type="text/x-handlebars-template">
				{{#if this.enum_name}}
				<button class="btn btn-sm"><xsl:attribute name="style">color:{{this.colour}};background-color:{{this.backgroundColor}}</xsl:attribute>{{this.enum_name}}</button>
				{{else}}
					{{#if this.name}}
						{{#ifEquals this.name 'true'}}
							<i class="fa fa-check-circle" style="color:green;font-size:1.2em"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Yes')"/>
						{{else}}
							{{#ifEquals this.name 'false'}}
								<i class="fa fa-times-circle" style="color:#51b9d9;font-size:1.2em"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('No')"/>
							{{else}}
								{{#if this.name}}
									{{this.name}}							
								{{/if}}
							{{/ifEquals}}
						{{/ifEquals}}
						{{else}}
							Not Set
					{{/if}}
				{{/if}}
			 </script>
			
            <script id="list-template" type="text/x-handlebars-template">
                {{#each this.caps}} 
                        <div class="col-xs-4">
                            <div class="caps bottom-5">
                                <i class="fa fa-caret-right"> </i> {{#essRenderInstanceLink this 'Technology_Product'}}{{/essRenderInstanceLink}} 
                            </div>
                        </div>  
                 {{/each}}    
            </script>
            <script id="name-template" type="text/x-handlebars-template">
                {{#essRenderInstanceLink this 'Technology_Product'}}{{/essRenderInstanceLink}}       
		  </script>
		  <script id="select-template" type="text/x-handlebars-template">
			{{#essRenderInstanceLinkSelect this 'Technology_Product'}}{{/essRenderInstanceLinkSelect}}       
	  	  </script>
         
            <script id="vendorLifecycle-template" type="text/x-handlebars-template">
				{{#each this.vendor_lifecycle}}
					<div class="lifecycleBox"><xsl:attribute name="style">color:{{this.statusColour}};background-color:{{this.statusBgColour}}</xsl:attribute><small><xsl:text> </xsl:text>{{this.status}}<br/>{{this.formattedStartDate}}</small></div>
				{{/each}}      
			</script>
            <script id="compstandards-template" type="text/x-handlebars-template">
				{{#each this.comp}}
					<div class="componentBox"><xsl:text> </xsl:text>{{this.name}}</div>  
                    <div class="statusBox"><xsl:attribute name="style">color:{{this.stdTextColour}};background-color:{{this.stdColour}}</xsl:attribute><xsl:text> </xsl:text>{{this.std}}</div><br/>
                {{/each}}      
			</script>
			<script id="stakeholder-template" type="text/x-handlebars-template">
				{{#each this}}
					<i class="fa fa-circle fa-sm"></i><small><xsl:text> </xsl:text>{{this.actor}} as {{this.role}}</small><br/>
				{{/each}}      
		</script>
		<script id="supplier-template" type="text/x-handlebars-template">
            {{#essRenderInstanceLink this 'Supplier'}}{{/essRenderInstanceLink}}     
		</script>
		  
		<script id="family-name" type="text/x-handlebars-template"> 
            <ul> 
			{{#each this}}	
            <li>  {{this.name}}</li>
            {{/each}}
            </ul>
        </script>   
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
                    <xsl:with-param name="viewerAPIPathapiTechProds" select="$apiTechProds"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathOrgs" select="$apiOrgs"></xsl:with-param>  
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPathapiTechProds"></xsl:param>  
		<xsl:param name="viewerAPIPathOrgs"></xsl:param>
		//a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathapiTechProds"/>'; 
		var viewAPIDataOrgs = '<xsl:value-of select="$viewerAPIPathOrgs"/>';  
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

		function getSlot(sltnm, id){
			let slot=filters.find((e)=>{
				return e.slotName==sltnm
			}) 
			let res=slot?.values.find((r)=>{
				return r.id==id;
			})
		 
			return res || "";
		}

		var table
		var dynamicFilterDefs=[];	 
		var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
		var catalogueTable
		$('document').ready(function () {
			listFragment = $("#list-template").html();
            listTemplate = Handlebars.compile(listFragment);
            
            nameFragment = $("#name-template").html();
            nameTemplate = Handlebars.compile(nameFragment);
            
            lifeFragment = $("#life-template").html();
            lifeTemplate = Handlebars.compile(lifeFragment);

			enumFragment = $("#enum-template").html();
			enumTemplate = Handlebars.compile(enumFragment);

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
                
                if (instance) {
					let thisMeta = meta.filter((d) => {
		                return d.classes.includes(type)
					}); 
				 
		            instance['meta'] = thisMeta[0] || [];
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
                }
            });

			Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				//console.log(arg1)
				//console.log(arg2)
				return (arg1.toLowerCase() == arg2.toLowerCase()) ? options.fn(this) : options.inverse(this);
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
            let allTechProdArr = [];
            let workingArr = []; 
            let svcArr=[];
            let lifecycleArr=[]; 
			var colSettings=[];
			Promise.all([
                promise_loadViewerAPIData(viewAPIData),
				promise_loadViewerAPIData(viewAPIDataOrgs)
			]).then(function (responses) { 
				filters=responses[0].filters; 
                vendorLifecycleStatus=filters.filter((e)=>{return e.id == 'Vendor_Lifecycle_Status'})
 
                const lifecycleStatusMap = new Map();
		 
                vendorLifecycleStatus[0]?.values?.forEach(value => {
                    lifecycleStatusMap.set(value.id, {
                        name: value.name,
                        enum_name: value.enum_name,
                        sequence: value.sequence,
                        backgroundColor: value.backgroundColor,
                        colour: value.colour
                    });
                });
		 
                meta=responses[0].meta;
                workingArr = responses[0].technology_products; 
				workingArr = workingArr.sort((a, b) => a.name.localeCompare(b.name)); 
				
                orgsRolesList=responses[1].a2rs;
			 
				slotNames = filters.map(obj => ({
					"id": obj.slotName,
					"name": obj.name
				}));
			 
				 colSettings=[
			{
				"data" : "select",
				"title": "Select",
				"width": "50px",
				"visible": true 
			},
			{
				"data" :  "name",
				"title": "Name",
				"width": "200px",
				"visible": true
			},
			{
				"data" : "desc",
				"title": "Description",
				"width": "400px",
				"visible": true 
			},
			{	"data":"supplier",
				"title":"Supplier",
				"width": "200px", 
				"visible": true					
			},
			{	"data":"stakeholders",
				"width": "200px", 
				"visible": false,
				"title": "Stakeholders"					
			},
			{	"data":"ea_reference",
				"width": "50px", 
				"visible": false,
				"title": "EA Ref"					
			},
            {
                "data":"standards",
              "width": "50px", 
               "visible": false,
               "title": "Components"					
             },
			 {
                "data":"family",
              	"width": "100px", 
               "visible": true,
               "title": "Families"					
             }
           
			
			];

			slotNames.forEach((d)=>{
				if(d.name!='Product Family'){
					colSettings.push({	"data":d.id,
						"title":d.name,
						"width": "200px", 
						"visible": false					
					})
				}
			})

            colSettings.push({
                "data":"lifecycle",
				"width": "350px", 
				"visible": false,
				"title": "Vendor Lifecycle"		

            })
		
		    const today = new Date();
            let currentLocale="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>" 
			if (!currentLocale || currentLocale === '') {
				currentLocale = 'en-GB';
			}
				workingArr.forEach((d)=>{ 
                
                    d.vendor_lifecycle?.sort((a, b) => a.order - b.order);
                
                    // Find the current status
                    let current = null;
                    d.vendor_lifecycle?.forEach(item => {
                        let match = lifecycleStatusMap.get(item.statusId);
						 
						if(match){
							item['statusColour']=match.colour
							item['statusBgColour']=match.backgroundColor
							const startDate = new Date(item.start_date);
								if (startDate &lt;= today &amp;&amp; (!current || startDate > new Date(current.start_date))) {
									current = item;
								}
                       	 	item['formattedStartDate']=formatDateforLocale(item.start_date,currentLocale)
						}
                    });

                    // Mark the current status
                    if (current) {
                        current['current'] = "Current";
                   
                        if(current.statusId !== d.vendor_product_lifecycle_status){
                            d.vendor_product_lifecycle_status=current.statusId;

                        }

                    }

                    if(d.supplier){
                        d['supplierDetail']={"id":d.supplierId, "name":d.supplier, "className":"Supplier"}
                    }
					d['select']=d.id;
					let actorsNRoles=[];
					d.valueClass=d.className;
                 
					d.orgUserIds?.forEach((f)=>{ 
                    
						let thisA2r = orgsRolesList.find((r)=>{
							return r.id==f;
						})
                       
                      
						if(thisA2r){
							actorsNRoles.push(thisA2r)
							} 
					})

					d['stakeholders']=actorsNRoles 
               
					slotNames.forEach((s)=>{
						
					 if(d[s.id]){
						d[s.id]=getSlot(s.id,d[s.id])
					 }else{
						d[s.id]="-";
					 }
					})
				})
          
				colSettings.forEach((d)=>{
					$('#headerRow').append('<th>' + d.title + '</th>');
					$('#footerRow').append('<th>' + d.title + '</th>');
				})
         
				$('#dt_Capabilities tfoot th').each(function () {
		            var title = $(this).text();
					var titleid=title.replace(/ /g, "_");
				 
		            $(this).html('&lt;input type="text" class="dynamic-filter" id="'+titleid+'" placeholder="Search ' + title + '" /&gt;');
		        });
	 
				// Initialize DataTable with dynamic columns
			 table = $("#dt_Capabilities").DataTable({
				"paging": false,
				"deferRender": true,
				"scrollY": 350,
        		"scrollX": true,
				"scrollCollapse": true,
				"info": true,
				"sort": true,
				"destroy" : true,
				"responsive": false,
				"stateSave": true, 
				"columns": colSettings,
				"dom": 'Bfrtip',
				"buttons": [ 
					'colvis',
					'copyHtml5',
					'excelHtml5',
					'csvHtml5',
					'pdfHtml5',
					'print'
				],
				stateSaveCallback: function(settings, data) {
		 
					data.dynamicSearch = {};
					 
					if ($('.dynamic-filter').length > 0) {
					
						
						$('.dynamic-filter').each(function() {
						 
							var inputId = $(this)[0].id; // Ensure all elements have an ID
							 
							if (inputId) { // Check if ID is not undefined
								data.dynamicSearch[inputId] = $(this)[0].value;
							}
						});
				 
					}
						// Save the state object to local storage
			 
					localStorage.setItem('DataTables_Tech_Prod' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {
		 
					var data = JSON.parse(localStorage.getItem('DataTables_Tech_Prod' + settings.sInstance));
				
					if (data) { 
						// Restore the state of each dynamic search input
						$.each(data.dynamicSearch, function(inputId, value) {
							 
							var element = $('#' + inputId);
							if (element.length > 0) {
								element.val(value);
							} else {
								console.warn('Element with ID ' + inputId + ' not found.');
							}
						}); 
					}
					 
					return data; 
				},});
       
				table.columns().every(function () {
		            var that = this;

		            $('input', this.footer()).on('keyup change', function () {
		                if (that.search() !== this.value) {
		                    that
		                        .search(this.value)
		                        .draw();
		                }
		            });
		        });

				dynamicFilterDefs=filters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
                 
				workingArr.forEach((d) => {
                   
					d['meta'] = meta.filter((d) => {
						return d.classes.includes('Technology_Product')
					})
                });
				allTechProdArr = JSON.parse(JSON.stringify(workingArr))
         
                roadmapCaps = [];
                 

				essInitViewScoping(redrawView, ['Group_Actor', 'SYS_CONTENT_APPROVAL_STATUS'], responses[0].filters,true);

  
 	 
			}).catch(function (error) {
				//display an error somewhere on the page
            });

var tblData;

            function renderCatalogueTableData(scopedData) {
		 
				  
				var selectFragment = $("#select-template").html();
				var selectTemplate = Handlebars.compile(selectFragment);

				var supplierFragment = $("#supplier-template").html();
				var supplierTemplate = Handlebars.compile(supplierFragment);
			 
				var stakeholderFragment = $("#stakeholder-template").html();
				var stakeholderTemplate = Handlebars.compile(stakeholderFragment);
            
                var vendorLifecycleFragment = $("#vendorLifecycle-template").html();
				var vendorLifecycleTemplate = Handlebars.compile(vendorLifecycleFragment);
             
                var compFragment = $("#compstandards-template").html();
				var compTemplate = Handlebars.compile(compFragment);

				var familyFragment = $('#family-name').html();
				var familyTemplate = Handlebars.compile(familyFragment)

		        let inscopeTechProd = [];
                inscopeTechProd['techProd'] = scopedData.technology_products
	 
				for (var i = 0; inscopeTechProd.techProd.length > i; i += 1) { 
		 
                    tppNameHTML = nameTemplate(inscopeTechProd.techProd[i]); 

					//get slot data
					let additionalData = {}; 
					slotNames.forEach(key => {  
						additionalData[key.id] = enumTemplate(inscopeTechProd.techProd[i][key.id]) || "";
 
					});
		  
		            //Apply handlebars template
                   
				   
					selectHTML=selectTemplate(inscopeTechProd.techProd[i]);
					supplierHTML=supplierTemplate(inscopeTechProd.techProd[i].supplierDetail)   
					let ea_reference =  inscopeTechProd.techProd[i].ea_reference || " ";
					stakeholderHTML=stakeholderTemplate(inscopeTechProd.techProd[i].stakeholders)
                    let vendorLifecycleTemplateHTML=vendorLifecycleTemplate(inscopeTechProd.techProd[i]);
                    let stdHTML=compTemplate(inscopeTechProd.techProd[i])
					let familyHTML=familyTemplate(inscopeTechProd.techProd[i].member_of_technology_product_families);
 
					tblData.push({"select":selectHTML,"name":tppNameHTML,"desc":inscopeTechProd.techProd[i].description,"status":"","supplier":supplierHTML, "stakeholders":stakeholderHTML, "ea_reference":ea_reference,"standards":stdHTML,"lifecycle":vendorLifecycleTemplateHTML, "family":familyHTML, ...additionalData})
                     
		        }

				table.clear().rows.add(tblData).draw();
		    }

            function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }
		
			var redrawView = function () {
                essResetRMChanges();
				let scopedTechProdList = [];
				workingArr.forEach((d) => {
					scopedTechProdList.push(d)
				});
			
				let toShow = []; 
			 
                let workingtechProdList = []; 
                let techOrgScopingDef = new ScopingProperty('techOrgUsers', 'Group_Actor');
				//let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
				//let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');
 
				let typeInfo = {
					"className": "Technology_Product",
					"label": 'Technology Product',
					"icon": 'fa-tasks'
				}
				let scopedTech = essScopeResources(scopedTechProdList, [techOrgScopingDef, visibilityDef].concat(dynamicFilterDefs), typeInfo);
 
				let showtechProd = scopedTech.resources; 
				let viewArray = {}; 
				viewArray['type'] = "<xsl:value-of select="$repYN"/>";
				viewArray['technology_products'] = showtechProd;
             
				$('#list').html(listTemplate(viewArray));
                
				setCatalogueTable(viewArray) 

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

</xsl:stylesheet>
