<?xml version="1.0" encoding="UTF-8"?>
<!-- REQUIRED 
Report Menu "Technology Domain Generic Menu" to be enabled (techDomainGenMenu)

-->
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/core_api_fetcher.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/> <!-- needed for the RenderHandlebarsUtilityFunctions to be called-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->


	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Component','Technology_Domain', 'Technology_Capability', 'Supplier', 'Technology_Product')"/>


	<!--
		* Copyright © 2008-2025 Enterprise Architecture Solutions Limited.
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
	
		<html lang="en">
			<head>
				<xsl:call-template name="commonHeadContent">
          <xsl:with-param name="requiresDataTables" select="false()"/>
        </xsl:call-template>

			    <!-- Start Required for smart links -->
				<xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				 <!-- End Required for smart links -->


				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<meta charset="UTF-8" />
				<title><xsl:value-of select="eas:i18n('Technology Capability Catalogue Table')"/></title>
				<!-- ANY LINKS TO JAVASCRIPT LIBRARIES-->
				<style>
					.list {padding-left:10px}  
					.filtParent{
						position:absolute;
						top:-15px;
						right:10px;
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
				
				</style>
			 	  
			</head>

			<body role="document" aria-labelledby="main-heading">
				
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template> 
				
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="main-heading">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Capability Catalogue Table')"/></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12" role="main">
							<div class="pull-right filtParent">
							<!-- checkboxes-->
							</div>
						</div>
                        
						<!-- start table -->
                        <div class="clearfix bottom-10"/>	
                        <div class="col-xs-12"> 
                           <table class="table table-striped table-condensed top-10 small dataTable" role="grid" aria-describedby="ebfw-editor-selection-table_info" id="dt_TechCapTable"> 
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
						<!-- end table -->

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                <script type="text/javascript">
<xsl:call-template name="RenderHandlebarsUtilityFunctions"/> <!-- required to be called for predefined Handlebars functions to work -->
<!-- DATATABLES JAVASCRIPT LIBRARY-->
       
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>	

	            
			
var meta = [
	{
        "classes": [
            "Technology_Product"
        ],
        "menuId": "techProdGenMenu"
    },
	{
        "classes": [
            "Technology_Component"
        ],
        "menuId": "techCompGenMenu"
    },
	{
        "classes": [
            "Technology_Capability"
        ],
        "menuId": "techCapGenMenu"
    },
	{
        "classes": [
            "Technology_Domain"
        ],
        "menuId": "techDomainGenMenu"
	}
 
]


					var table;
		            var dynamicAppFilterDefs=[];
		            var catalogueTable;
		 
               
                        $(document).ready(function() {
						
							<!-- DEFINE APIS -->
                            apiList=['techProdSvc','ImpTechCompApi','ImpTechCapApi'];

                            async function executeFetchAndRender() {
                                try {
                            let responses = await fetchAndRenderData(apiList);
							
                            ({  techProdSvc,ImpTechCompApi,ImpTechCapApi } = responses);
							<!-- This will put the output of the APIS in the console -->
							//console.log('responses', responses) 

                             TechComponentsData = responses.ImpTechCompApi.technology_components;
							 TechProductsData = responses.techProdSvc.technology_products;
							 TechCapabilitiesData = responses.ImpTechCapApi.technology_capabilities;
							
                             <!-- these are not vars as previously used -->
							 selectFragment = $("#select-template").html(); 
			                 selectTemplate = Handlebars.compile(selectFragment);

			                 selectNameFragment = $("#select-name-template").html();
			                 selectNameTemplate = Handlebars.compile(selectNameFragment);
							
							

							 techCapsFragment = $("#tech-caps-template").html();
							 techCapsTemplate = Handlebars.compile(techCapsFragment);
  
                             techDomainFragment = $("#tech-domain-template").html();
							 techDomainTemplate = Handlebars.compile(techDomainFragment);
		 			
	                         techCompsFragment = $("#tech-comps-template").html();
							 techCompsTemplate = Handlebars.compile(techCompsFragment);

							 techProdsFragment = $("#tech-prods-template").html();
							 techProdsTemplate = Handlebars.compile(techProdsFragment);
							

							 Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				//console.log(arg1)
				//console.log(arg2)
				return (arg1.toLowerCase() == arg2.toLowerCase()) ? options.fn(this) : options.inverse(this);
			}); 

            





			let workingArr = []; 
			var colSettings=[];


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
				"width": "100px",
				"visible": true
			},
			{
				"data" : "desc",
				"title": "Description",
				"width": "400px",
				"visible": true 
			},
			{
				"data": "techdomain",
				"title": "Technology Domain",
				"width": "100px",
				"visible": true
			},
			{
				"data": "techcomp",
				"title": "Technology Components",
				"width": "200px",
				"visible": true
			},
			{
				"data": "productname",
				"title": "Technology Products",
				"width": "150px",
				"visible": false
			}];
	
				colSettings.forEach((d)=>{
					$('#headerRow').append('<th>' + d.title + '</th>');
					$('#footerRow').append('<th>' + d.title + '</th>');
				})

				$('#dt_TechCapTable tfoot th').each(function () {
		            var title = $(this).text();
					var titleid=title.replace(/ /g, "_");
				 
		            $(this).html('&lt;input type="text" class="dynamic-filter" id="'+titleid+'" placeholder="Search ' + title + '" /&gt;');
		        });

// Initialize DataTable with dynamic columns
				table = $("#dt_TechCapTable").DataTable({
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
						 
					localStorage.setItem('DataTables_Tech_Cap_Tab' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {

					var data = JSON.parse(localStorage.getItem('DataTables_Tech_Cap_Tab' + settings.sInstance));

					if (data) {
						// Restore the state of each dynamic search input
						$.each(data.dynamicSearch, function(inputId, value) {
							$('#' + inputId).val(value);
						});
					}
				
					return data;
				},
				//start default filter
				"initComplete": function(settings, json) {
					var tableApi = this.api();
					var defaultsApplied = false;

					// Define your default search terms here.
					// The key should be the exact column title as defined in colSettings.
					var defaultSearches = {
						//"Name": "Beta", // Example: Default search for 'Name' column to "Beta"
						//"Status": "Active", // Example: Default search for 'Status' column to "Active"
						// Add more defaults: "Column Title From colSettings": "Default Search Term"
						//"Impacting": "Test", 
					};

					tableApi.columns().every(function() {
						var column = this;
						var colIdx = column.index();
						// Ensure colSettings is accessible and colSettings[colIdx] is valid
						var columnTitle = colSettings[colIdx].title;
						var inputId = columnTitle.replace(/ /g, "_"); // Matches ID creation logic
						var $input = $('#' + inputId);

						if ($input.length &amp; defaultSearches.hasOwnProperty(columnTitle)) {
							if ($input.val() === '') { // Only apply if input is empty (no saved state for this filter)
								var defaultSearchTerm = defaultSearches[columnTitle];
								$input.val(defaultSearchTerm);
								column.search(defaultSearchTerm, false, true); // Apply search to the column
								defaultsApplied = true;
							}
						}
					});

					if (defaultsApplied) {
						tableApi.draw(); // Redraw the table if any defaults were set
					}
					//end default filter
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


<!-- start init scoping-->


hardClasses=[	{"class":"SYS_CONTENT_APPROVAL_STATUS", "slot":"system_content_lifecycle_status"},
						{"class":"Group_Actor", "slot":"stakeholders"},
						{"class":"Technology_Capability", "slot":"realisation_of_technology_capability"}]; <!-- will not work due to Tech Cap not being part of scoping lists -->

          
				    //	hardClasses = hardClasses.filter(item => 
					//		!filterExcludes.some(exclude => item.slot.includes(exclude))
					//	);

					let classesToShow = hardClasses.map(item => item.class);

				essInitViewScoping(redrawView, classesToShow,"",true);


<!-- end init scoping-->


                                }
                                catch (error) {
                                    // Handle any errors that occur during the fetch operations
                                    console.error('Error fetching data:', error);
                                }
                            }
                            executeFetchAndRender();



                        });   




                var tblData;
				
              
             function renderCatalogueTableData(scopedData) {
		
<!-- start create new techDomain detail object -->

scopedData.techcaps.forEach((cap) => {
	cap.domainDetail = {"id": cap.domainId, "name": cap.domain, "className": "Technology_Domain"};
});

<!-- end create new techDomain detail object -->

<!-- start tech cap to Tech component mapping -->

    scopedData.techcaps.forEach(techCap => {
        // Initialize a new property to store the matched components.
        // This ensures every capability object has the 'tech_components' property.
        techCap.tech_components = [];

        // Iterate over each technology component to find matches.
        scopedData.techcomps.forEach(techComp => {
			
            // Check if the component has a 'caps' property and it's an array.
            if (techComp.caps &amp;&amp; Array.isArray(techComp.caps)) {
			
                // Check if the component's 'caps' array includes the current capability's name.
                if (techComp.caps.includes(techCap.name)) {
				
                    // If a match is found, push the entire component object into the
                    // 'tech_components' array of the current capability.
                    techCap.tech_components.push(techComp);
                }
            }
        });
    });

<!-- end tech cap to Tech component mapping -->

<!-- start tech cap to tech product mapping -->

scopedData.techcaps.forEach(techCap => {
        // Initialize a new property to store the matched prods.
        // This ensures every capability object has the 'tech_prods' property.
        techCap.tech_products = [];

        // Iterate over each technology product to find matches.
        scopedData.techprods.forEach(techProds => {
			
            // Check if the product has a 'caps' property and it's an array.
            if (techProds.caps &amp;&amp; Array.isArray(techProds.caps)) {
		
                // Check if the products 'caps' array includes the current capability's name.
                if (techProds.caps.some(cap => cap.name === techCap.name)) {
    // If a match is found, push the entire product object into the
    // 'tech_products' array of the current tech capability.
    techCap.tech_products.push(techProds);
}
            }
        });
    });

<!-- end tech cap to tech product mapping -->

		
for (var i = 0; scopedData.techcaps.length > i; i += 1) {

			
        
            <!-- start irs is required to declare core item class for smart link context menus -->
		            irs = scopedData.techcaps[i];
				    irs['className']='Technology_Capability';
           <!-- end irs is required to declare core item class for smart link context menus -->
			
			
		            //Apply handlebars template
                
				selectHTML=selectTemplate(scopedData.techcaps[i]);
				selectNameHTML=selectNameTemplate(scopedData.techcaps[i]);
   
               	techDomainHTML=techDomainTemplate(scopedData.techcaps[i].domainDetail);	   
                techCompsHTML=techCompsTemplate(scopedData.techcaps[i]);

				techProdsHTML=techProdsTemplate(scopedData.techcaps[i]);

					tblData.push({"select":selectHTML,"name":selectNameHTML,"desc":scopedData.techcaps[i].description,"techdomain":techDomainHTML,"techcomp":techCompsHTML,"productname":techProdsHTML});
                      
		        }

				table.clear().rows.add(tblData).draw();
		    }

           function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }

             var redrawView = function () {
				
				let scopedTechCapList = [];
				let scopedTechCompList = [];
				
				TechCapabilitiesData.forEach((d) => {
					scopedTechCapList.push(d)
				});
			
				TechComponentsData.forEach((d) => {
					scopedTechCompList.push(d)
				});
				
				let toShow = []; 
			 
                ////ScopingProperty(key property in response, class name in the model)
				let techOrgScopingDef = new ScopingProperty('techOrgUsers', 'Group_Actor');
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
			    let techCapScopingDef = new ScopingProperty('caps', 'Technology_Capability'); <!-- will not work due to Tech Cap not being part of scoping lists -->
				 
				essResetRMChanges();
				

				let typeTechCap = {
					"className": "Technology_Capability",
					"label": 'Technology Capability',
					"icon": 'fa-tasks'
				}
				let typeTechComp = {
					"className": "Technology_Component",
					"label": 'Technology Component',
					"icon": 'fa-tasks'
				}
		        let typeTechProd = {
					"className": "Technology_Product",
					"label": 'Technology Product',
					"icon": 'fa-tasks'
				}



            let scopedTechCaps = essScopeResources(scopedTechCapList, [techCapScopingDef].concat(dynamicAppFilterDefs), typeTechCap);
	        let scopedTechComps = essScopeResources(scopedTechCompList, [techCapScopingDef].concat(dynamicAppFilterDefs), typeTechComp); 
	        let scopedTechProds = essScopeResources(TechProductsData, [techOrgScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeTechProd); 


				let viewArray = {}; 
				<!-- viewArray['type'] = "<xsl:value-of select="$repYN"/>"; -->
				viewArray['techcaps'] = TechCapabilitiesData;
				viewArray['techcomps'] = scopedTechComps.resources;
				viewArray['techprods'] = scopedTechProds.resources;
				
				setCatalogueTable(viewArray);

		

			}

       function redrawView() { essRefreshScopingValues() }

                                                                     
                </script>
			

			
			</body>
        
	

<script id="select-template" type="text/x-handlebars-template">
			{{#essRenderInstanceLinkSelect this}}{{/essRenderInstanceLinkSelect}}  
</script>
 <script id="select-name-template" type="text/x-handlebars-template">
			{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}  
</script>
 
<script id="tech-comps-template" type="text/x-handlebars-template">
{{#each this.tech_components}} 
<i class="fa fa-chevron-circle-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Technology_Component'}}{{/essRenderInstanceLinkOnly}}    <br/> 

{{/each}}
 </script>		

<script id="tech-caps-template" type="text/x-handlebars-template">
{{#each this.caps}} 
<i class="fa fa-chevron-circle-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Technology_Capability'}}{{/essRenderInstanceLinkOnly}}    <br/> 

{{/each}}
 </script>	

<script id="tech-prods-template" type="text/x-handlebars-template">
{{#each this.tech_products}} 
<i class="fa fa-chevron-circle-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Technology_Product'}}{{/essRenderInstanceLinkOnly}}    <br/> 

{{/each}}
 </script>	

 <script id="tech-domain-template" type="text/x-handlebars-template">
{{#if this.id}}
            {{#essRenderInstanceLinkOnly this 'Technology_Domain'}}{{/essRenderInstanceLinkOnly}}     
			{{/if}}
		</script>


		
 <link href="js/DataTables/2.1.8/datatables.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="js/DataTables/2.1.8/datatables.min.js"></script>
		</html>

	
	</xsl:template>


</xsl:stylesheet>
