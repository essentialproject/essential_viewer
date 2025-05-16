<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	 <xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS --> 

    <xsl:param name="viewScopeTermIds"/>
 
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="apis" select="/node()/simple_instance[type='Application_Provider_Interface']"/>
	<xsl:variable name="linkClasses" select="('Project', 'Programme','Roadmap','Supplier', 'Application_Provider', 'Composite_Application_Provider','Business_Capability', 'Application_Service')"/>
	<xsl:key name="overallCurrencyDefault" match="/node()/simple_instance[type='Report_Constant']" use="own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="overallCurrencyDefault" select="key('overallCurrencyDefault', 'Default Currency')"/>
    <!-- RMIT-->
    <xsl:key name="instances" match="/node()/simple_instance[supertype='EA_Class']" use="name"/>
	<xsl:variable name="roadmap" select="/node()/simple_instance[type=('Roadmap')]"/>
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
	<xsl:variable name="projData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"></xsl:variable>
    <xsl:variable name="appSvcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"></xsl:variable>
	<xsl:variable name="appMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>
	<xsl:variable name="orgData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"></xsl:variable>

    <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiProj">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$projData"></xsl:with-param>
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
                <title><xsl:value-of select="eas:i18n('Project Catalogue')"/></title>
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
					#scopeSelect{
						display:none;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Project Catalogue')"/></span>
								</h1>
							</div>
                        </div> 
						<div class="clearfix bottom-10"/>	
                        <div class="col-xs-12"> 
						<span id="scopeBox">
							<xsl:value-of select="eas:i18n('Scope')"/>: <select id="scopeSelect" multiple="true"><option></option></select>
						</span>
                            <table class="table table-striped table-condensed top-10 small dataTable" style="min-width:99%" role="grid" aria-describedby="ebfw-editor-selection-table_info" id="dt_Project">
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
                                <i class="fa fa-caret-right"> </i> {{#essRenderInstanceLink this 'Application_Provider'}}{{/essRenderInstanceLink}} 
                            </div>
                        </div>  
                 {{/each}}    
            </script>
            <script id="name-template" type="text/x-handlebars-template">
				{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}    
		  </script>
		  <script id="select-template" type="text/x-handlebars-template">
			{{#essRenderInstanceLinkSelect this 'Application_Provider'}}{{/essRenderInstanceLinkSelect}}       
	  	  </script>
        <script id="stakeholder-template" type="text/x-handlebars-template">
        {{#each this.stakeholders}}
            <i class="fa fa-user" style="color:orange"></i><span style="font-size:0.8em"><xsl:text> </xsl:text>{{this.actorName}} - {{this.roleName}}<br/>
        </span>{{/each}}
        </script> 
        <script id="roadmap-template" type="text/x-handlebars-template">
        {{#each this.roadmaps}}
            <span class="label label-default">{{this.name}}</span>
        {{/each}}
        </script>    
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
                    <xsl:with-param name="viewerAPIPathProj" select="$apiProj"></xsl:with-param> 
                    <xsl:with-param name="viewerAPIPathAppsSvc" select="$apiAppsSvc"></xsl:with-param> 
                    <xsl:with-param name="viewerAPIPathAppsMart" select="$apiAppsMart"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathOrgs" select="$apiOrgs"></xsl:with-param>  
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPathProj"></xsl:param> 
		<xsl:param name="viewerAPIPathAppsSvc"></xsl:param> 
		<xsl:param name="viewerAPIPathAppsMart"></xsl:param> 
		<xsl:param name="viewerAPIPathOrgs"></xsl:param>
		//a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathProj"/>';
		var viewAPIDataSvc = '<xsl:value-of select="$viewerAPIPathAppsSvc"/>';
		var viewAPIDataMart = '<xsl:value-of select="$viewerAPIPathAppsMart"/>';
		var viewAPIDataOrgs = '<xsl:value-of select="$viewerAPIPathOrgs"/>';  
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data

		<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>

	    var roadmapScopes = [<xsl:apply-templates select="$roadmap" mode="roadmaps"/>];
 
 
const allScopes = roadmapScopes.flatMap(entry => Array.isArray(entry.scope) ? entry.scope : []);
 
const uniqueScopesMap = new Map();
allScopes.forEach(scope => {
  if (scope &amp;&amp; !uniqueScopesMap.has(scope.id)) {
    uniqueScopesMap.set(scope.id, scope);
  }
});
const uniqueScopes = Array.from(uniqueScopesMap.values());
 
const groupedByType = uniqueScopes.reduce((acc, scope) => {
  if (!scope.type) return acc; // skip if type is missing
  if (!acc[scope.type]) {
    acc[scope.type] = [];
  }
  acc[scope.type].push({
    id: scope.id,
    name: scope.name
  });
  return acc;
}, {});
$('#scopeBox').hide();
if (Object.keys(groupedByType).length !== 0) {
  $('#scopeBox').show();
}

const select2Data = Object.entries(groupedByType).map(([type, items]) => ({
  text: type,
  children: items.map(item => ({
    id: item.id,
    text: item.name
  }))
}));

// Initialise Select2
$('#scopeSelect').select2({
  data: select2Data,
  placeholder: "Select a scope...",
  width: '240px'
});

		var rmdata;

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

		var table, ccy,projMap;
		var dynamicAppFilterDefs=[];	 
		var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
		var catalogueTable, styleMap
	    var rcCcyId= "<xsl:value-of select="$overallCurrencyDefault/own_slot_value[slot_reference='report_constant_ea_elements']/value"/>";
        var currentLang="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>";
            if (!currentLang || currentLang === '') {
                currentLang = 'en-GB';
            }
        <!-- cost functions -->
        function consolidateCosts(projects, currencyData) {
                // Find the default currency data
                defaultCurrency = currencyData.find(currency => currency.default === "true");
            
                if(!defaultCurrency){defaultCurrency = currencyData.find(currency => currency.id === rcCcyId);}

                const defaultCurrencyCode = defaultCurrency.code || 'GBP'; // Set the default currency
                    currencyFormatter = new Intl.NumberFormat(currentLang, {
                        style: 'currency',
                        currency: defaultCurrencyCode,
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 0
                    });
            
                if (!defaultCurrency) {
                    console.error("Default currency not found");
                    return;
                }

                const consolidated = {
                    total: 0,
                    showTotal: '',
                    byYear: {},
                    excludingAdhoc: 0,
                    byCategory: {},
                    byMonthExcludingAdhoc: {}
                };

                // Function to convert amount to default currency
            function convertToDefaultCurrency(amount, ccy) {
                    const currency = currencyData.find(currency => currency.id === ccy);
                    if (!currency) {
                        console.warn(`Currency with id ${ccy} not found, using original amount`);
                        return amount;  // If currency is not found, return the original amount (no conversion)
                    }
                    const exchangeRate = parseFloat(currency.exchangeRate);
                    if (!exchangeRate || isNaN(exchangeRate)) {
                        console.warn(`No exchange rate for currency ${currency.name}, using original amount`);
                        return amount;  // If exchange rate is missing or invalid, return the original amount (no conversion)
                    }
                    return amount * exchangeRate;  // Convert to default currency
                }

                projects.forEach(project => {
                    const { recurrence, category, amount, startDate, endDate, ccy } = project;

                    // Convert the amount to the default currency
                    const convertedAmount = convertToDefaultCurrency(amount, ccy);

                    // Total cost across all projects
                    consolidated.total += convertedAmount;

                    // Total cost by year
                    const startYear = new Date(startDate).getFullYear();
                    const endYear = new Date(endDate).getFullYear();
                    
                    // Add amount for the years between start and end
                    for (let year = startYear; year &lt;= endYear; year++) {
                        if (!consolidated.byYear[year]) {
                            consolidated.byYear[year] = 0;
                        }
                        consolidated.byYear[year] += convertedAmount;
                    }

                    // Exclude ad hoc costs
                    if (recurrence !== "Adhoc_Cost_Component") {
                        consolidated.excludingAdhoc += convertedAmount;
                    }

                    // Breakdown by category
                    if (category) {
                        if (!consolidated.byCategory[category]) {
                            consolidated.byCategory[category] = 0;
                        }
                        consolidated.byCategory[category] += convertedAmount;
                    }

                    // Month by month excluding ad hoc costs
                    if (recurrence !== "Adhoc_Cost_Component") {
                        const start = new Date(startDate);
                        const end = new Date(endDate);

                        let currentDate = new Date(start);
                        while (currentDate &lt;= end) {
                            const monthKey = `${currentDate.getFullYear()}-${(currentDate.getMonth() + 1).toString().padStart(2, '0')}`;
                            
                            if (!consolidated.byMonthExcludingAdhoc[monthKey]) {
                                consolidated.byMonthExcludingAdhoc[monthKey] = 0;
                            }
                            consolidated.byMonthExcludingAdhoc[monthKey] += convertedAmount;

                            // Move to next month
                            currentDate.setMonth(currentDate.getMonth() + 1);
                        }
                    }
                });

                // Format the total as a currency value
                consolidated.showTotal = new Intl.NumberFormat('en-US', {
                    style: 'currency',
                    currency: defaultCurrency.code,
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                }).format(consolidated.total);

                return consolidated;
            }

		$('document').ready(function () {
			listFragment = $("#list-template").html();
            listTemplate = Handlebars.compile(listFragment);
            
            nameFragment = $("#name-template").html();
            nameTemplate = Handlebars.compile(nameFragment);
            
            lifeFragment = $("#life-template").html();
            lifeTemplate = Handlebars.compile(lifeFragment);

			enumFragment = $("#enum-template").html();
			enumTemplate = Handlebars.compile(enumFragment);

	    	var roadmapFragment = $("#roadmap-template").html();
			roadmapTemplate = Handlebars.compile(roadmapFragment);

			Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				return (arg1.toLowerCase() == arg2.toLowerCase()) ? options.fn(this) : options.inverse(this);
			}); 
             

            let workingArr = []; 
			var colSettings=[]; 
			Promise.all([ promise_loadViewerAPIData(viewAPIData)]).then(function (responses) {
              	let roadmapsData= responses[0].roadmaps;
				let plansData= responses[0].allPlans;
                workingArr = responses[0].allProject;  
                ccy=responses[0].currencyData; 
                projMap = workingArr.reduce((map, project) => {
                    map[project.id] = project; // Use the project ID as the key
                    return map;
                }, {}); 
                styleMap = responses[0].styles.reduce((map, style) => {
                    map[style.id] = {"colour":style.colour, "textColour":style.textColour}
                    return map;
                }, {});

				const roadmapMap = new Map();
						// Build a map of planId → roadmapIds
						roadmapsData.forEach(roadmap => {
							(roadmap.strategicPlans || []).forEach(planId => {
								if (!roadmapMap.has(planId)) {
								roadmapMap.set(planId, []);
								}
								roadmapMap.get(planId).push(roadmap.id);
							});
						});

						const fromPlans = plansData.flatMap(plan =>
							(plan.projects || []).map(project => ({
								planId: plan.id,
								roadmapIds: roadmapMap.get(plan.id) || [],
								changeActivityId: project.id
							}))
							);

						// Step 3: Generate from projects → strategicPlans
						const fromProjects = workingArr.flatMap(project =>
							(project.strategicPlans || []).map(plan => ({
								planId: plan.id,
								roadmapIds: roadmapMap.get(plan.id) || [],
								changeActivityId: project.id
							}))
							);


						// Build the final merged array
						rmdata =[...fromPlans, ...fromProjects];
		
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
				"width": "300px",
				"visible": true 
			},
			{	"data":"stakeholders",
				"width": "200px", 
				"visible": true,
				"title": "Stakeholders"					
			},
			{	"data":"lifecycle",
				"width": "100px", 
				"visible": true,
				"title": "Lifecycle"					
			},
			{	"data":"approval",
				"width": "100px", 
				"visible": true,
				"title": "Approval Status"					
			},
			{	"data":"totalcost",
				"width": "100px", 
				"visible": true,
				"title": "Total Cost"					
			},
			{	"data":"roadmap",
				"width": "100px", 
				"visible": true,
				"title": "Roadmaps"			
            }		
			];


				workingArr.forEach((d)=>{ 
					d['select']=d.id;
					let actorsNRoles=[];
					d.valueClass=d.className;
		
				})
		 
				colSettings.forEach((d)=>{
					$('#headerRow').append('<th>' + d.title + '</th>');
					$('#footerRow').append('<th>' + d.title + '</th>');
				})

				$('#dt_Project tfoot th').each(function () {
		            var title = $(this).text();
					var titleid=title.replace(/ /g, "_");
				 
		            $(this).html('&lt;input type="text" class="dynamic-filter form-control input-sm" style="width:100%" id="'+titleid+'" placeholder="Search ' + title + '" /&gt;');
		        });
			
				// Initialize DataTable with dynamic columns
				table = $("#dt_Project").DataTable({
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
			//	"data": workingArr,
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
						 
					localStorage.setItem('DataTables_App_Pro' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {

					var data = JSON.parse(localStorage.getItem('DataTables_App_Pro' + settings.sInstance));

					if (data) {
						// Restore the state of each dynamic search input
						$.each(data.dynamicSearch, function(inputId, value) {
							$('#' + inputId).val(value);
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

				$('#dt_Project').DataTable().columns.adjust().draw();
                 
				essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS'], "",true);

 
			}).catch(function (error) {
				//display an error somewhere on the page
            });

            var tblData;

            function renderCatalogueTableData(scopedData) {
		 
				var selectFragment = $("#select-template").html();
				var selectTemplate = Handlebars.compile(selectFragment);
 
				var stakeholderFragment = $("#stakeholder-template").html();
				var stakeholderTemplate = Handlebars.compile(stakeholderFragment);
 
		        let inscopeProj = [];
                inscopeProj['projects'] = scopedData.projects
	
		    		for (var i = 0; inscopeProj.projects.length > i; i += 1) {

 
                     inscopeProj.projects[i]['consolidatedCosts']=consolidateCosts(inscopeProj.projects[i].costs, ccy);
                 
			
                    let nameHTML=nameTemplate(inscopeProj.projects[i])
					let projLife=styleMap[inscopeProj.projects[i].lifecycleStatusID]
                    let projApproval=styleMap[inscopeProj.projects[i].approvalId];
 
                    if(projLife){
                        lifeHTML=lifeTemplate({"shortname":inscopeProj.projects[i].lifecycleStatus, "colour":projLife.colour || "blue", "colourText": projLife.textColour || "#ffffff"})
                    }else{
                        lifeHTML="Not Set"
                    }

                    if(projApproval){
                        approvalHTML=lifeTemplate({"shortname":inscopeProj.projects[i].approvalStatus, "colour":projApproval.colour || "blue", "colourText": projApproval.textColour || "#ffffff"})
                    }else{
                        approvalHTML="Not Set"
                    }
                    
		            //Apply handlebars template
					selectHTML=selectTemplate(inscopeProj.projects[i]);
				 	
					stakeholderHTML=stakeholderTemplate(inscopeProj.projects[i])
				
					tblData.push({"select":selectHTML,
                        "name":nameHTML,
                        "desc":inscopeProj.projects[i].description, 
                        "stakeholders": stakeholderHTML, 
                        "lifecycle": lifeHTML, 
                        "approval": approvalHTML,
                        "totalcost": inscopeProj.projects[i].consolidatedCosts.showTotal,
                        "roadmap": roadmapTemplate(inscopeProj.projects[i])})
                      
		        }

				table.clear().rows.add(tblData).draw();
		    }

            function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }
		
			var redrawView = function () {
				console.log('redraw')

  			// Create a mapping of roadmap ID to name from rpp.roadmaps
		const roadmapMap = essRMApiData.rpp.roadmaps.reduce((map, roadmap) => {
			map[roadmap.id] = roadmap.name; // Map the id to its name
			return map;
		}, {});

		const roadmapScopesMap = roadmapScopes.reduce((map, roadmap) => {
			map[roadmap.id] = roadmap.scope; // Map the id to its name
			return map;
		}, {});
 
 
	// Now, update the `roadmapIds` in the projects
		rmdata.forEach(item => {
		const matchingProject = projMap[item.changeActivityId]; // Lookup project by `changeActivityId`
		
		if (matchingProject) {
			// If roadmapIds is an array, update with both ID and name for each roadmap
			if (Array.isArray(item.roadmapIds)) {
				matchingProject.roadmaps = item.roadmapIds.map(roadmapId => {

					return { id: roadmapId, name: roadmapMap[roadmapId] || '', scope:  roadmapScopesMap[roadmapId] }; // Use the name from the map
				});

				const consolidatedScopes = [];

				// Loop through the roadmapIds and gather scopes
				item.roadmapIds.forEach(roadmapId => {
					// Get the corresponding roadmap's scope
					const roadmapScopes = roadmapScopesMap[roadmapId] || [];
					
					// Add scope items to the consolidatedScopes, avoiding duplicates
					roadmapScopes.forEach(scopeItem => {
						if (!consolidatedScopes.some(existingScope => existingScope.id === scopeItem.id)) {
							consolidatedScopes.push({
								id: scopeItem.id,
								name: scopeItem.name
							});
						}
					});
					
				});
				matchingProject.scopes = consolidatedScopes;
			} else {
					// If roadmapIds is a single ID (not an array), handle it here
					matchingProject.roadmaps = [{ id: item.roadmapIds, name: roadmapMap[item.roadmapIds] || 'Unknown', className: "Roadmap" }];
					const roadmapScopes = roadmapScopesMap[item.roadmapIds] || [];
					const consolidatedScopes = [];

					roadmapScopes.forEach(scopeItem => {
						if (!consolidatedScopes.some(existingScope => existingScope.id === scopeItem.id)) {
							consolidatedScopes.push({
								id: scopeItem.id,
								name: scopeItem.name
							});
						}
					});

					// Assign the consolidated scopes to the `scopes` property in the project
					matchingProject.scopes = consolidatedScopes;
				}
		}
	});
				let scopedProjectList = [];
				workingArr.forEach((d) => {
					scopedProjectList.push(d)
				});
			
				let toShow = []; 
			  
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
				let scopedProjects = essScopeResources(scopedProjectList, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo);

				let showProjects = scopedProjects.resources; 
				let viewArray = {};  
				const selectedIds = $('#scopeSelect').val();
				if(selectedIds.length > 0){
					showProjects= showProjects.filter(project => {
						// If any of the project's scope ids are in selectedIds, filter it out
						return project.scopes.some(scope => selectedIds.includes(scope.id));
					});
				}
				viewArray['projects'] = showProjects;
				
				$('#list').html(listTemplate(viewArray));
				setCatalogueTable(viewArray) 

			}
		});

		$('#scopeSelect').off().on('change', function(){
			redrawView()
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
<xsl:template match="node()" mode="roadmaps">
		<xsl:variable name="scope" select="key('instances', current()/own_slot_value[slot_reference='ea_scope']/value)"/>
		{
		 "id": "<xsl:value-of select="current()/name"/>", 
		 "scope":[<xsl:for-each select="$scope">
		 	{
				 "id": "<xsl:value-of select="current()/name"/>",
				 "type": "<xsl:value-of select="current()/type"/>",
				<xsl:variable name="combinedMap" as="map(*)" select="map{ 
				'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value, '}', ')'), '{', ')'))
			}"></xsl:variable>
			<xsl:variable name="result" select="serialize($combinedMap, map{'method':'json', 'indent':true()})"/>
			<xsl:value-of select="substring-before(substring-after($result, '{'), '}')"/>
			}<xsl:if test="position()!=last()">,</xsl:if>
		 </xsl:for-each>]
		}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
