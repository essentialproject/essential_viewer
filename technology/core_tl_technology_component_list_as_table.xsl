<?xml version="1.0" encoding="UTF-8"?>

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

    <xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = ('Vendor_Lifecycle_Status','Disposition_Lifecycle_Status','Lifecycle_Status')]"/>
    <xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style']"/>

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Component', 'Technology_Capability', 'Supplier', 'Technology_Product')"/>


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
				<xsl:call-template name="commonHeadContent"/>

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
				<title><xsl:value-of select="eas:i18n('Technology Component Catalogue Table')"/></title>
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
					.componentBox{
                        width:140px;
                        display:inline-block;
                        padding:2px;
                        border-radius: 5px 5px 0px 0px;
                        background-color:#efefef;
                        color:#000000;
                        border:1px solid #d3d3d3;
                        font-size:0.9em;
                    }
                    .statusBox{
                        width:140px; 
                        padding:2px;
                        border-radius:0px 0px 5px 5px;
                        background-color:#d3d3d3;
                        font-size:0.9em; 
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Component Catalogue Table')"/></span>
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
                           <table class="table table-striped table-condensed top-10 small dataTable" role="grid" aria-describedby="ebfw-editor-selection-table_info" id="dt_TechCompTable"> 
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
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>	

	             var tprStatusJSON = [<xsl:apply-templates select="$allLifecycleStatii" mode="tprStatus"/>];
			
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
            "Supplier"
        ],
        "menuId": "supplierGenMenu"
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
							console.log('responses', responses) 

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

		 					 supplierFragment = $("#supplier-template").html();
							 supplierTemplate = Handlebars.compile(supplierFragment);
							 
							 techProdStandardsFragment = $("#tech-prod-standards-template").html();
							 techProdStandardsTemplate = Handlebars.compile(techProdStandardsFragment);

                             tprStatusFragment = $("#life-template").html();
							 tprStatusTemplate = Handlebars.compile(tprStatusFragment);
	

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
				"width": "200px",
				"visible": true
			},
			{
				"data" : "desc",
				"title": "Description",
				"width": "400px",
				"visible": true 
			}, 
			{
				"data": "techcap",
				"title": "Technology Capability",
				"width": "200px",
				"visible": false
			},
			{
				"data": "productsupplier",
				"title": "Supplier",
				"width": "100px",
				"visible": true
			},
			{
				"data": "productname",
				"title": "Product Name",
				"width": "150px",
				"visible": true
			},
			{
				"data": "lifecyclestatus",
				"title": "Lifecycle Status",
				"width": "100px",
				"visible": true 
			}];
	
				colSettings.forEach((d)=>{
					$('#headerRow').append('<th>' + d.title + '</th>');
					$('#footerRow').append('<th>' + d.title + '</th>');
				})

				$('#dt_TechCompTable tfoot th').each(function () {
		            var title = $(this).text();
					var titleid=title.replace(/ /g, "_");
				 
		            $(this).html('&lt;input type="text" class="dynamic-filter" id="'+titleid+'" placeholder="Search ' + title + '" /&gt;');
		        });

// Initialize DataTable with dynamic columns
				table = $("#dt_TechCompTable").DataTable({
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
						 
					localStorage.setItem('DataTables_Tech_Comp_Tab' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {

					var data = JSON.parse(localStorage.getItem('DataTables_Tech_Comp_Tab' + settings.sInstance));

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
				var finalComponentList = [];
              
             function renderCatalogueTableData(scopedData) {
		
	
				
// Start Tech Product to Technology Component mapping

            
// 1. Perform the initial mapping for components found in products
const mappedTechComponents = scopedData.techprods.flatMap(product => {
  return product.comp.map(componentInstance => {
    const baseComponent = scopedData.techcomps.find(c => c.id === componentInstance.id);
    return {
      ...baseComponent,
      ...componentInstance,
      productName: product.name,
      productSupplier: product.supplier,
      productId: product.id,
      productSupplierDetail: {"id": product.supplierId, "name": product.supplier, "className": "Supplier"},
	  prodcondensed: {"id": product.id, "name": product.name, "className": "Technology_Product"},
      productLifecycleStatus: product.lifecycleStatus,
    };
  });
});

// 2. Identify which component IDs have already been mapped
const mappedComponentIds = new Set(mappedTechComponents.map(c => c.id));

// 3. Find and add components that were not mapped
const unmappedComponents = scopedData.techcomps.filter(
  component => !mappedComponentIds.has(component.id)
);

// 4. Combine the mapped and unmapped lists
finalComponentList = [...mappedTechComponents, ...unmappedComponents];


// Start strategic_lifecycle_status mapping

const statusMap = new Map(tprStatusJSON.map(status => [status.id, status]));
// Iterate over the finalComponentList to replace the status ID with the full object
finalComponentList.forEach(component => {
	
  if (component.strategic_lifecycle_status) {
    // Replace all periods with underscores to match the key format in statusMap
    const statusObject = statusMap.get(component.strategic_lifecycle_status.replace(/\./g, "_"));

    if (statusObject) {
      component.strategic_lifecycle_status = statusObject;
    }
  }
});


// End strategic_lifecycle_status mapping

//Start Technology Capability mapping

const techCapMap = new Map(TechCapabilitiesData.map(cap => [cap.name, cap]));
finalComponentList.forEach(component => {
      if (component.caps &amp;&amp; Array.isArray(component.caps)) {
        // Replace each capability name string with the matched object from the map.
        // If no match is found, it keeps the original name.
        component.caps = component.caps.map(capName => techCapMap.get(capName) || capName);
      }
});

//End Technology Capability mapping


// End Tech Product to Technology Component mapping



for (var i = 0; finalComponentList.length > i; i += 1) {

			
          
            <!-- start irs is required to declare core item class for smart link context menus -->
		            irs = finalComponentList[i];
				    irs['className']='Technology_Component';
           <!-- end irs is required to declare core item class for smart link context menus -->
			
			
		            //Apply handlebars template
                
				selectHTML=selectTemplate(finalComponentList[i]);
				selectNameHTML=selectNameTemplate(finalComponentList[i]);
   
               	techCapsHTML=techCapsTemplate(finalComponentList[i]);			    
                
				productsupplierHTML=supplierTemplate(finalComponentList[i].productSupplierDetail);
			
			techProdStandardsHTML=techProdStandardsTemplate(finalComponentList[i]);

			tprStatusHTML=tprStatusTemplate(finalComponentList[i]);


					tblData.push({"select":selectHTML,"name":selectNameHTML,"desc":finalComponentList[i].description,"techcap":techCapsHTML,"productsupplier":productsupplierHTML,"productname":techProdStandardsHTML,"lifecyclestatus":tprStatusHTML});
                      
		        }

				table.clear().rows.add(tblData).draw();
		    }

           function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }

             var redrawView = function () {
				
				let scopedTechCompList = [];
				TechComponentsData.forEach((d) => {
					scopedTechCompList.push(d)
				});
			
				let toShow = []; 
			 
                ////ScopingProperty(key property in response, class name in the model)
				let techOrgScopingDef = new ScopingProperty('techOrgUsers', 'Group_Actor');
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
			    let techCapScopingDef = new ScopingProperty('caps', 'Technology_Capability'); <!-- will not work due to Tech Cap not being part of scoping lists -->
				 
				essResetRMChanges();
				
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


	        let scopedTechComps = essScopeResources(scopedTechCompList, [techCapScopingDef].concat(dynamicAppFilterDefs), typeTechComp); 
	        let scopedTechProds = essScopeResources(TechProductsData, [techOrgScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeTechProd); 


				let viewArray = {}; 
				<!-- viewArray['type'] = "<xsl:value-of select="$repYN"/>"; -->
				viewArray['techprods'] = scopedTechProds.resources;
				viewArray['techcomps'] = scopedTechComps.resources;
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
  
<script id="tech-caps-template" type="text/x-handlebars-template">
{{#each this.caps}} 
<i class="fa fa-chevron-circle-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Technology_Capability'}}{{/essRenderInstanceLinkOnly}}    <br/> <!-- to use instance link, it needs to have name and id property -->

{{/each}}
 </script>			

 <script id="life-template" type="text/x-handlebars-template">
 {{#if this.strategic_lifecycle_status}}
               <button class="btn btn-sm"><xsl:attribute name="style">color:{{this.strategic_lifecycle_status.colourText}};background-color:{{this.strategic_lifecycle_status.colour}}</xsl:attribute>{{this.strategic_lifecycle_status.enumeration_value}}</button>
			   {{/if}}
            </script>


<script id="supplier-template" type="text/x-handlebars-template">
{{#if this.id}}
            {{#essRenderInstanceLinkOnly this 'Supplier'}}{{/essRenderInstanceLinkOnly}}     
			{{/if}}
		</script>

		<script id="tech-prod-standards-template" type="text/x-handlebars-template">
			{{#if this.productName}}
					<div class="componentBox"><xsl:text> </xsl:text>{{#essRenderInstanceLinkOnly this.prodcondensed 'Technology_Product'}}{{/essRenderInstanceLinkOnly}}     </div>  
                    <div class="statusBox"><xsl:attribute name="style">color:{{this.stdTextColour}};background-color:{{this.stdColour}}</xsl:attribute><xsl:text> </xsl:text>{{this.std}}</div><br/>
              {{/if}}   
			</script>

		</html>

	
	</xsl:template>
<xsl:template match="node()" mode="tprStatus">
		<xsl:variable name="thisStyle" select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]"/>
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
    <xsl:variable name="combinedMap" as="map(*)" select="map{
	   'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')), 
	   'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
     'enumeration_value': translate(translate(current()/own_slot_value[slot_reference = ('enumeration_value')]/value,'}',')'),'{',')'),
     'enumeration_sequence_number': translate(translate(current()/own_slot_value[slot_reference = ('enumeration_sequence_number')]/value,'}',')'),'{',')')
     
	 }" />
	 <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	 <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
    "shortname":"<xsl:value-of select="current()/own_slot_value[slot_reference='short_name']/value"/>",
    "colour":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:when><xsl:otherwise>#d3d3d3</xsl:otherwise></xsl:choose>",
		"colourText":"<xsl:choose><xsl:when test="$thisStyle[1]/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#ffffff</xsl:otherwise></xsl:choose>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	

</xsl:stylesheet>
