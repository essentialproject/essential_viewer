<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:include href="../common/core_handlebars_functions.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>
	<!-- START GENERIC PARAMETERS --> 

    <xsl:param name="viewScopeTermIds"/> 
 
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<!-- <xsl:variable name="apis" select="/node()/simple_instance[type='Application_Provider_Interface']"/> -->
	<xsl:variable name="linkClasses" select="('Issue','Group_Actor','Technology_Node','Technology_Product','Data_Representation','Information_Representation','Data_Object','Information_View','Composite_Application_Provider','Business_Process','Business_Capability')"/>

 	<!-- END GENERIC LINK VARIABLES -->
   
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
	<xsl:variable name="infoRepData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	<xsl:variable name="AppData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application List']"></xsl:variable>
    <xsl:variable name="orgData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"></xsl:variable>
	<xsl:variable name="issueData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Issues List']"></xsl:variable>

    <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiinfoRep">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$infoRepData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable> 
        
	<xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$AppData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable> 

		<xsl:variable name="apiOrgs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$orgData"></xsl:with-param>
			</xsl:call-template>
         </xsl:variable> 

		 	<xsl:variable name="apiIssues">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$issueData"></xsl:with-param>
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
                <title><xsl:value-of select="eas:i18n('Issues Catalogue Table')"/></title>
			 
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<style>
				   #beta-label {
                   vertical-align: top;
                   background-color: #555;
                   color: #fff;
                   padding: 2px 10px;
                   border-radius: 10px;
                   font-size: 10px;
                   text-transform: uppercase;
                   }
					.list {padding-left:10px}         
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Issues Catalogue')"/></span>
								</h1>
							</div>
                        </div>
						<div class="col-xs-12 ">
							<div class="pull-right filtParent">
							<!-- checkboxes-->
							</div>
						</div>
						<div class="clearfix bottom-10"/>	
                        <div class="col-xs-12"> 
                            <table class="table table-striped table-condensed top-10 small dataTable" role="grid" aria-describedby="ebfw-editor-selection-table_info" id="dt_Issues">
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

		
            </body>
          



<script id="impacts-template" type="text/x-handlebars-template"><ul>
{{#each this}} 
<i class="fa fa-square" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this this.className}}{{/essRenderInstanceLinkOnly}}<br/> 

{{/each}} </ul>
 </script>

 <script id="root-causes-template" type="text/x-handlebars-template"><ul>
{{#each this}} 
<i class="fa fa-bolt" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this this.className}}{{/essRenderInstanceLinkOnly}}<br/> 

{{/each}} </ul>
 </script>


<script id="status-template" type="text/x-handlebars-template">
{{#if this.shortname}}
<button class="btn btn-sm"><xsl:attribute name="style">color:{{this.colourText}};background-color:{{this.colour}}</xsl:attribute>{{this.shortname}}</button>
{{else}}
<button class="btn btn-sm"><xsl:attribute name="style">color:#ffffff;background-color:#d3d3d3</xsl:attribute>Not Set</button>
{{/if}}
		 </script>	

<script id="single-org-template" type="text/x-handlebars-template">
{{#essRenderInstanceLinkOnly this 'Group_Actor'}}{{/essRenderInstanceLinkOnly}}

 </script>



<script id="ext-refs-template" type="text/x-handlebars-template"><ol>
{{#each this}} 
 <li><a><xsl:attribute name="href">{{this.external_reference_url}}</xsl:attribute><xsl:attribute name="title">{{this.description}}</xsl:attribute>{{this.name}}</a></li>
{{/each}} </ol>
 </script>

<script id="org-template" type="text/x-handlebars-template"><ul>
{{#each this}} 
<i class="fa fa-arrow-circle-o-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Group_Actor'}}{{/essRenderInstanceLinkOnly}}<br/> 

{{/each}} </ul>
 </script>

 <script id="select-template" type="text/x-handlebars-template">
			{{#essRenderInstanceLinkSelect this}}{{/essRenderInstanceLinkSelect}}  
</script>
 <script id="select-name-template" type="text/x-handlebars-template">
			{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}  
</script>
<script id="stakeholder-template" type="text/x-handlebars-template">
				{{#each this}}
					<i class="fa fa-circle fa-sm"></i><small><xsl:text> </xsl:text>{{this.actor}} as {{this.role}}</small><br/>
				{{/each}}      
			</script>

         <script id="apps-template" type="text/x-handlebars-template">
			{{#each this}}
			{{#each this.apps}}
			{{#if this.SHOW}}
			{{#essRenderInstanceLinkOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkOnly}}<br/>
			 <br/><br/>
	{{/if}}
			{{/each}}
			{{/each}} 
</script>
           
	 
		  
         
		
			<script>			
			<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
				<xsl:call-template name="RenderViewerAPIJSFunction">
                    <xsl:with-param name="viewerAPIPathInfoReps" select="$apiinfoRep"></xsl:with-param> 
                   <xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
				   <xsl:with-param name="viewerAPIPathOrgs" select="$apiOrgs"></xsl:with-param>  
				   <xsl:with-param name="viewerAPIPathIssues" select="$apiIssues"></xsl:with-param>
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	 <xsl:template name="RenderViewerAPIJSFunction"> 

	

        <xsl:param name="viewerAPIPathInfoReps"></xsl:param> 
		<xsl:param name="viewerAPIPathApps"></xsl:param> 
		<xsl:param name="viewerAPIPathOrgs"></xsl:param>
		<xsl:param name="viewerAPIPathIssues"></xsl:param>
	

		//a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathInfoReps"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataOrgs = '<xsl:value-of select="$viewerAPIPathOrgs"/>';  
		var viewAPIDataIssues = '<xsl:value-of select="$viewerAPIPathIssues"/>';  
		
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
var meta = [
    {
        "classes": [
            "Issue"
        ],
        "menuId": "issueGenMenu"
    },
    {
        "classes": [
            "Business_Process"
        ],
        "menuId": "busProcessGenMenu"
    },
    {
        "classes": [
            "Business_Capability"
        ],
        "menuId": "busCapGenMenu"
    },
    {
        "classes": [
            "Composite_Application_Provider"
        ],
        "menuId": "appProviderGenMenu"
    },
	 {
        "classes": [
            "Group_Actor"
        ],
        "menuId": "grpActorGenMenu"
    },
	 {
        "classes": [
            "Data_Object"
        ],
        "menuId": "dataObjGenMenu"
    },
	 {
        "classes": [
            "Information_View"
        ],
        "menuId": "infoViewGenMenu"
    },
	 {
        "classes": [
            "Information_Representation"
        ],
        "menuId": "infoRepGenMenu"
    },
	{
        "classes": [
            "Data_Representation"
        ],
        "menuId": "dataRepGenMenu"
    },
	{
        "classes": [
            "Technology_Product"
        ],
        "menuId": "techProdGenMenu"
    },
	{
        "classes": [
            "Technology_Node"
        ],
        "menuId": "techNodeGenMenu"
    }
]
		var table
		var dynamicAppFilterDefs=[];	 
		var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
		var catalogueTable
		$('document').ready(function () {
			//$('#edit-scope-btn').hide();

		
       
	   	    impactsFragment = $("#impacts-template").html();
			impactsTemplate = Handlebars.compile(impactsFragment);
            
			rootCausesFragment = $("#root-causes-template").html();
			rootCausesTemplate = Handlebars.compile(rootCausesFragment);
			
            orglistFragment = $("#org-template").html();
            orglistTemplate = Handlebars.compile(orglistFragment);
            

			singleorgFragment = $("#single-org-template").html();
            singleorgTemplate = Handlebars.compile(singleorgFragment);


            var selectFragment = $("#select-template").html();
			var selectTemplate = Handlebars.compile(selectFragment);

			var selectNameFragment = $("#select-name-template").html();
			var selectNameTemplate = Handlebars.compile(selectNameFragment);

			var appsNameFragment = $("#apps-template").html();
			var appsNameTemplate = Handlebars.compile(appsNameFragment);	

			var StatusFragment = $("#status-template").html();
			var StatusTemplate = Handlebars.compile(StatusFragment);	

			var extRefLinksFragment = $("#ext-refs-template").html();
			var extRefLinksTemplate = Handlebars.compile(extRefLinksFragment);	           
          
            let workingArr = []; 
			var colSettings=[];
			Promise.all([
				promise_loadViewerAPIData(viewAPIDataOrgs),
				promise_loadViewerAPIData(viewAPIDataIssues)
				 

			]).then(function (responses) {
				orgsRolesList = responses[0].a2rs;
				OrgsList = responses[0].orgData;
				workingArr = responses[1].issues;
				issueCats = responses[1].issue_categories;
				requirementStatusStyling = responses[1].requirement_status_list;
				srLifecycleStatusStyling = responses[1].sr_lifecycle_status_list;
		
        


//Start stakeholder mapping

workingArr.forEach((d) => {
        d['select'] = d.id;
        let actorsNRoles = [];
        d.valueClass = d.className;
        d.sA2R?.forEach((f) => {
            let thisA2r = orgsRolesList.find((r) => {
                return r.id == f;
            })

            if (thisA2r) {
                actorsNRoles.push(thisA2r)
            }
        }); 
		
		d['stakeholders'] = actorsNRoles
});
		//console.log('workingArr',workingArr);

//End stakeholder mapping
			
			
//Start Org/Group Actor mapping

workingArr.forEach((iss) => {
    const sourceId = iss.issue_source; // Expecting this to be an ID string from the API

    if (<xsl:text disable-output-escaping="yes"> <![CDATA[ sourceId && OrgsList ]]> </xsl:text>) {
        const orgMatch = OrgsList.find(org => org.id === sourceId);
        if (orgMatch) {
            // Replace the ID string with the full organization object
            // The singleorgTemplate expects an object for essRenderInstanceLinkOnly
            iss.issue_source = orgMatch;
        } else {
            // Source ID was present, but no match in OrgsList
            // Create a placeholder object for the template
            iss.issue_source = {
                id: null, // No valid ID for linking
                name: `Unknown Source (ID: ${sourceId})`
                // className: 'Group_Actor' // The template provides 'Group_Actor'
            };
        }
    } else if (sourceId) {
        // Source ID exists, but OrgsList is not available or not loaded
        iss.issue_source = {
            id: null,
            name: `Source: ${sourceId} (Org data unavailable)`
        };
    } else {}
});

//End Org/Group Actor mapping

//Start Org Scope mapping
workingArr.forEach((iss) => {
    const scopeIds = iss.orgScopes; // Expecting this to be an array of ID strings from the API

    if (<xsl:text disable-output-escaping="yes"><![CDATA[Array.isArray(scopeIds) && OrgsList]]></xsl:text>) {
        iss.orgScopes = scopeIds.map(scopeId => {
            const orgMatch = OrgsList.find(org => org.id === scopeId);
            if (orgMatch) {
                // Return the full organization object
                return orgMatch;
            } else {
                // Scope ID was present, but no match in OrgsList
                // Create a placeholder object
                return {
                    id: null, // No valid ID for linking
                    name: `Unknown Org Scope (ID: ${scopeId})`
                };
            }
        });
    } else if (Array.isArray(scopeIds)) {
        // Scope IDs exist, but OrgsList is not available or not loaded
        iss.orgScopes = scopeIds.map(scopeId => ({
            id: null,
            name: `Org Scope: ${scopeId} (Org data unavailable)`
        }));
    } else {
        // orgScopes is not an array or is null/undefined, ensure it's an empty array for the template
        iss.orgScopes = [];
    }
});
//End Org Scope mapping

	


//Start requirement status mapping

workingArr.forEach((issu) => {



   let search = requirementStatusStyling.find((s) => {
                return s.id == issu.requirement_status_id;
            })
            if (search) {
			 issu.requirement_status_id = search;

            }

});


//end requirement status mapping

//Start SR Lifecycle status mapping
workingArr.forEach((issu) => {
    let search = srLifecycleStatusStyling.find((s) => {
        return s.id == issu.sr_lifecycle_status;
    });
    if (search) {
        issu.sr_lifecycle_status = search;
    }
});
//end SR Lifecycle status mapping


				 colSettings=[
		//	{
		//		"data" : "select",
		//		"title": "Select",
		//		"width": "50px",
		//		"visible": true 
		//	},
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
				"data" : "org-scope",
				"title": "Sr Org Scope",
				"width": "200px",
				"visible": false
			},
			{
				"data": "issue-source",
				"title": "Issue Source",
				"width": "150px",
				"visible": false
			},
			{
				"data": "requirement-status",
				"title": "Requirement Status",
				"width": "100px",
				"visible": false
			},
			{
				"data": "priority",
				"title": "Priority",
				"width": "100px",
				"visible": false
			},
			{
				"data": "last-modified",
				"title": "Last Modified",
				"width": "100px",
				"visible": false 
			},
			{
				"data": "impacting",
				"title": "Impacting",
				"width": "300px",
				"visible": true 
			},
			{
				"data": "stakeholders",
				"title": "Stakeholders",
				"width": "300px",
				"visible": false 
			},
			{
				"data": "ext-ref-links",
				"title": "External Reference Links",
				"width": "200px",
				"visible": true 
			},
            {
				"data": "sr_required_from_date_ISO8601",
				"title": "Sr Required From Date ISO8601",
				"width": "100px",
				"visible": false
			},
			{
				"data": "sr_required_by_date_ISO8601",
				"title": "Sr Required By Date ISO8601",
				"width": "100px",
				"visible": false
			},
			{
				"data": "sr_lifecycle_status",
				"title": "Sr Lifeycle Status",
				"width": "100px",
				"visible": true
			},
			{
				"data": "sr_type",
				"title": "Sr Type",
				"width": "100px",
				"visible": false
			},
			{
				"data": "sr_root_causes",
				"title": "Sr Root Causes",
				"width": "300px",
				"visible": false
			}
			];

			
		 
				colSettings.forEach((d)=>{
					$('#headerRow').append('<th>' + d.title + '</th>');
					$('#footerRow').append('<th>' + d.title + '</th>');
				})

				$('#dt_Issues tfoot th').each(function () {
		            var title = $(this).text();
					var titleid=title.replace(/ /g, "_");
				 
		            $(this).html('&lt;input type="text" class="dynamic-filter" id="'+titleid+'" placeholder="Search ' + title + '" /&gt;');
		        });
			
				// Initialize DataTable with dynamic columns
				table = $("#dt_Issues").DataTable({
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
						 
					localStorage.setItem('DataTables_Issues_Cat' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {

					var data = JSON.parse(localStorage.getItem('DataTables_Issues_Cat' + settings.sInstance));

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

				
                

                 hardClasses=[	{"class":"SYS_CONTENT_APPROVAL_STATUS", "slot":"system_content_lifecycle_status"},
						{"class":"ACTOR_TO_ROLE_RELATION", "slot":"act_to_role_to_role"},
						{"class":"Strategic_Requirement_Lifecycle_Status", "slot":"sr_life_id"}]

          
				    //	hardClasses = hardClasses.filter(item => 
					//		!filterExcludes.some(exclude => item.slot.includes(exclude))
					//	);

					let classesToShow = hardClasses.map(item => item.class);
					

				essInitViewScoping(redrawView, classesToShow,responses[0].filters,true);

		

			
		
			 
			}).catch(function (error) {
				//display an error somewhere on the page
            });

var tblData;

            function renderCatalogueTableData(scopedData) {
		
		function formatISODateToFriendly(isoString) {
					if (!isoString || isoString === "null") { // Handle cases where the date might be null or "null" string
						return "Not Set";
					}
					const date = new Date(isoString);
					// You can customize the options for toLocaleDateString as needed
					return date.toLocaleDateString(undefined, { year: 'numeric', month: 'long', day: 'numeric' });
				}

		        let inscopeIssues = [];
                inscopeIssues['issues'] = scopedData.issues
	
	            var stakeholderFragment = $("#stakeholder-template").html();
				var stakeholderTemplate = Handlebars.compile(stakeholderFragment);


				for (var i = 0; inscopeIssues.issues.length > i; i += 1) {

			
           
            
		            irs = inscopeIssues.issues[i];
				    irs['className']='Issue'

					
			
		            //Apply handlebars template
                
				selectHTML=selectTemplate(inscopeIssues.issues[i]);
				selectNameHTML=selectNameTemplate(inscopeIssues.issues[i]);
   
                OrgNameHTML=orglistTemplate(inscopeIssues.issues[i].orgScopes);
                OrgSourceNameHTML=singleorgTemplate(inscopeIssues.issues[i].issue_source);
			

					stakeholderHTML=stakeholderTemplate(inscopeIssues.issues[i].stakeholders)

					impactsHTML=impactsTemplate(inscopeIssues.issues[i].issue_impacts);

					rootCausesHTML=rootCausesTemplate(inscopeIssues.issues[i].sr_root_causes);

					reqStatusHTML=StatusTemplate(inscopeIssues.issues[i].requirement_status_id);

					SrLifecycleStatusHTML=StatusTemplate(inscopeIssues.issues[i].sr_lifecycle_status);

					extRefLinksHTML=extRefLinksTemplate(inscopeIssues.issues[i].external_reference_links);
				    
					let friendlyLastModified = formatISODateToFriendly(inscopeIssues.issues[i].system_last_modified_datetime_iso8601);



					tblData.push({"select":"selectHTML","name":selectNameHTML,"desc":inscopeIssues.issues[i].description, "stakeholders":stakeholderHTML, "org-scope":OrgNameHTML,"issue-source":OrgSourceNameHTML,"requirement-status":reqStatusHTML,"priority": inscopeIssues?.issues?.[i]?.sr_priority ?? inscopeIssues?.issues?.[i]?.issue_priority,"last-modified":friendlyLastModified,"impacting":impactsHTML,"ext-ref-links":extRefLinksHTML,"sr_required_from_date_ISO8601":inscopeIssues.issues[i].sr_required_from_date_ISO8601,"sr_required_by_date_ISO8601":inscopeIssues.issues[i].sr_required_by_date_ISO8601,"sr_lifecycle_status":SrLifecycleStatusHTML,"sr_type":inscopeIssues.issues[i].sr_type,"sr_root_causes":rootCausesHTML});
                      
		        }

				table.clear().rows.add(tblData).draw();
		    }

            function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }
		
			var redrawView = function () {
				
				let scopedIssuesList = [];
				workingArr.forEach((d) => {
					scopedIssuesList.push(d)
				});
			
				let toShow = []; 
			 
                //ScopingProperty(key property in response, class name in the model)
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
				let a2rDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION');  
				let srlife = new ScopingProperty('sr_life_id', 'Strategic_Requirement_Lifecycle_Status');  

				essResetRMChanges();
				
				let typeIssue = {
					"className": "Issue",
					"label": 'Issue',
					"icon": 'fa-tag'
				}
		
	let scopedIssues = essScopeResources(scopedIssuesList, [srlife, a2rDef, visibilityDef].concat(dynamicAppFilterDefs), typeIssue); //Get scoped scopedIssues
	
				let viewArray = {}; 
				viewArray['type'] = "<xsl:value-of select="$repYN"/>";
				viewArray['issues'] = scopedIssues.resources;
				setCatalogueTable(viewArray);

		

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