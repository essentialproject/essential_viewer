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
<!---->
	<!-- START GENERIC PARAMETERS --> 

    <xsl:param name="viewScopeTermIds"/> 
 
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="apis" select="/node()/simple_instance[type='Application_Provider_Interface']"/>
	<xsl:variable name="linkClasses" select="('Information_Representation','Information_View','Data_Representation','Composite_Application_Provider')"/>

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
	<xsl:variable name="infoRepData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"></xsl:variable>
	<xsl:variable name="AppData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application List']"></xsl:variable>
    <xsl:variable name="orgData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Group Actors']"></xsl:variable>



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
                <title><xsl:value-of select="eas:i18n('Information Representation Catalogue Table')"/></title>
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
                            font-size: 0.5em;
                            line-height: 1.0em;                          
							background-color: #dfdfdf;
                            color: white;
                            cursor: pointer; 
                            display:inline-block
                            }
					.datacrud{
					    display: inline-block;
					}
					.ess-crud{
						display: inline-block;
						border: 1pt solid #d3d3d3;
						border-radius: 4px;
						font-size: 16px;
						font-weight: 700;
						background-color: #fff;
						margin-right: 5px;
						padding: 2px 5px;
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
					.styleiv{
						min-height:30px;
						width:150px;
						background-color:red;
						color:white;
						border:2px solid #d3d3d3;
						border-radius:6px;
						display:inline-block;
						padding:2px;
						margin-right:3px;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Information Representation Catalogue')"/></span>
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
		
 <script id="ivname-template" type="text/x-handlebars-template"><ul>
{{#each this.infoViews}} 
<i class="fa fa-arrow-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Information_View'}}{{/essRenderInstanceLinkOnly}}<br/> 


{{/each}} </ul>
 </script>

<script id="drname-template" type="text/x-handlebars-template"><ul>
{{#each this.dataReps}} 
<i class="fa fa-arrow-circle-o-right" aria-hidden="true"></i> {{#essRenderInstanceLinkOnly this 'Data_Representation'}}{{/essRenderInstanceLinkOnly}}<br/> 

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
			{{#if this.HIDE}}
			{{#essRenderInstanceLinkOnly this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkOnly}}<br/>
			<div class="datacrud">
            <div class="ess-crud">C {{#CRUDVal this.create}}{{/CRUDVal}}</div>
            <div class="ess-crud">R {{#CRUDVal this.read}}{{/CRUDVal}}</div>
            <div class="ess-crud">U {{#CRUDVal this.update}}{{/CRUDVal}}</div>
            <div class="ess-crud">D {{#CRUDVal this.delete}}{{/CRUDVal}}</div>
            </div> <br/><br/>
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
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	 <xsl:template name="RenderViewerAPIJSFunction"> 

	

        <xsl:param name="viewerAPIPathInfoReps"></xsl:param> 
		<xsl:param name="viewerAPIPathApps"></xsl:param> 
		<xsl:param name="viewerAPIPathOrgs"></xsl:param>
	
		//a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathInfoReps"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
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
var meta = [
    {
        "classes": [
            "Information_Representation"
        ],
        "menuId": "infoRepGenMenu"
    },
    {
        "classes": [
            "Information_View"
        ],
        "menuId": "infoViewGenMenu"
    },
    {
        "classes": [
            "Data_Representation"
        ],
        "menuId": "dataRepGenMenu"
    },
    {
        "classes": [
            "Composite_Application_Provider"
        ],
        "menuId": "appProviderGenMenu"
    }

	
]
		var table
		var dynamicAppFilterDefs=[];	 
		var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
		var catalogueTable
		$('document').ready(function () {
		


			ivlistFragment = $("#ivname-template").html();
            ivlistTemplate = Handlebars.compile(ivlistFragment);

			drlistFragment = $("#drname-template").html();
            drlistTemplate = Handlebars.compile(drlistFragment);

            var selectFragment = $("#select-template").html();
			var selectTemplate = Handlebars.compile(selectFragment);

			var selectNameFragment = $("#select-name-template").html();
			var selectNameTemplate = Handlebars.compile(selectNameFragment);

			var appsNameFragment = $("#apps-template").html();
			var appsNameTemplate = Handlebars.compile(appsNameFragment);	

        
           

			enumFragment = $("#enum-template").html();
			enumTemplate = Handlebars.compile(enumFragment);

			



			Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				//console.log(arg1)
				//console.log(arg2)
				return (arg1.toLowerCase() == arg2.toLowerCase()) ? options.fn(this) : options.inverse(this);
			}); 
            
            
				Handlebars.registerHelper('CRUDVal', function(arg1) {
					if(arg1=='Yes'){
						return '<div class="ess-circle"><i class="fa fa-check-circle-o" style="color:#2dc660;font-size:12pt"></i></div>'
					}else
					if(arg1=='No'){
						return '<div class="ess-circle"><i class="fa fa-times-circle-o" style="color:#c62d2d;;font-size:12pt"></i></div>'
					}else{
						return '<div class="ess-circle"><i class="fa fa-question-circle" style="color:#ffc45f;font-size:12pt"></i></div>'
					}
				});
          
            let workingArr = []; 
            let lifecycleArr=[]; 
			var colSettings=[];
			Promise.all([
                promise_loadViewerAPIData(viewAPIData),
				 promise_loadViewerAPIData(viewAPIDataApps),
				 promise_loadViewerAPIData(viewAPIDataOrgs)

			]).then(function (responses) {
				//meta = responses[0].meta; 
				//console.log('api',responses);
				workingArr = responses[0].information_representation;
				workingArrIV = responses[0].information_views;
				workingArrDR = responses[0].data_representation;
				//Get Apps list
				workingArrApps = responses[1].applications;
				orgsRolesList = responses[2].a2rs;
				// filters=responses[0].filters;
        

 const appMap = new Map();
        if ( <xsl:text disable-output-escaping="yes">
<![CDATA[
workingArrApps && Array.isArray(workingArrApps)
 
]]> </xsl:text>) {
            workingArrApps.forEach(app => {
                if (<xsl:text disable-output-escaping="yes">
<![CDATA[
app && app.id
 
]]> </xsl:text>) { // Basic check for valid app object and id
                   appMap.set(app.id, app);
                }
            });
           
        } 



			//Start Compile Information view
			//Iterate our working view
			 // First, create a Map for quick lookup
const ivfMap = new Map();
workingArrIV.forEach(ivf => {
    ivfMap.set(ivf.id, ivf);
});

// Now, iterate over workingArr and its infoViews
//For each of the info views against an instance - iterate those
// Then identify via ID any matches in the working ArrIV array


workingArr.forEach(ir => {
    ir.infoViews.forEach(iv => {
        const match = ivfMap.get(iv.id);
        if (match) {
            Object.assign(iv, match); // Merge match back into iv
        }
       // console.log('iv with match', iv);
    });

});

 // First, create a Map for quick lookup
const drMap = new Map();
workingArrDR.forEach(drm => {
    drMap.set(drm.id, drm);
});

workingArr.forEach(ir2 =>
{
ir2.dataReps.forEach(dr =>
{
	const match2 = drMap.get(dr.id);
	if(match2) {
		Object.assign(dr, match2); // Merge match back into dr
	}
	//console.log('dr with match2',dr)
}
)
}
)
//End compile information view

//Start Application mapping

//console.log('workingArr',workingArr);




 workingArr.forEach((it1) => {
 if(it1.dataReps.length > 0)
 {
	//console.log('dataReps',it1.dataReps);
    it1.dataReps.forEach((it2)=>
	{
		
		if(it2.apps.length > 0)	
			{
				
				
				it2.apps.forEach((it3)=>
				{
				
                const matchapp = appMap.get(it3.id);
	            if(matchapp) {
	         	Object.assign(it3, matchapp); // Merge match back
	            }
	            //console.log('it3 with matchapp',it3)



				})
				//
				
			}
			//
	})
	//
	
//
 }
//
})





//End Application mapping

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
				"data" : "implements-information-views",
				"title": "Implements Information Views",
				"width": "200px",
				"visible": true 
			},
			{
				"data": "supporting-data-representations",
				"title": "Supporting Data Representations",
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
				"data": "apps",
				"title": "Used by Applications",
				"width": "300px",
				"visible": true 
			}
			];

			
		 
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
						 
					localStorage.setItem('DataTables_Info_Rep' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {

					var data = JSON.parse(localStorage.getItem('DataTables_Info_Rep' + settings.sInstance));

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

				
                
			
                 hardClasses=[{"class":"Group_Actor", "slot":"stakeholders"},
						{"class":"SYS_CONTENT_APPROVAL_STATUS", "slot":"system_content_quality_status"},
						{"class":"ACTOR_TO_ROLE_RELATION", "slot":"act_to_role_to_role"}]

          
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
		

		        let inscopeInfoReps = [];
                inscopeInfoReps['inforeps'] = scopedData.inforeps 
	
                var stakeholderFragment = $("#stakeholder-template").html();
				var stakeholderTemplate = Handlebars.compile(stakeholderFragment);

 //console.log('inscopeInfoReps',inscopeInfoReps)
				for (var i = 0; inscopeInfoReps.inforeps.length > i; i += 1) {

			
           
            
		            irs = inscopeInfoReps.inforeps[i];
				    irs['className']='Information_Representation'

					
			
		            //Apply handlebars template
                
				selectHTML=selectTemplate(inscopeInfoReps.inforeps[i]);
				selectNameHTML=selectNameTemplate(inscopeInfoReps.inforeps[i]);

				appNameTemp=appsNameTemplate(inscopeInfoReps.inforeps[i].dataReps);

				let ivHTML=ivlistTemplate(inscopeInfoReps.inforeps[i]);

				let drHTML=drlistTemplate(inscopeInfoReps.inforeps[i]);
					
					stakeholderHTML=stakeholderTemplate(inscopeInfoReps.inforeps[i].stakeholders)
				
					tblData.push({"select":selectHTML,"name":selectNameHTML,"desc":inscopeInfoReps.inforeps[i].description, "stakeholders":stakeholderHTML,"implements-information-views":ivHTML,"supporting-data-representations":drHTML,"apps":appNameTemp})
                      
		        }

				table.clear().rows.add(tblData).draw();
		    }

            function setCatalogueTable(scopedData) {
                tblData=[];
		       renderCatalogueTableData(scopedData); 
		    }
		
			var redrawView = function () {
				
				let scopedInfoRepList = [];
				//console.log('workingArr', workingArr);
				workingArr.forEach((d) => {
					scopedInfoRepList.push(d)
				});
			
				let toShow = []; 
			 
////ScopingProperty(key property in response, class name in the model)

				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
				let a2rDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION');   


				essResetRMChanges();
				
				let typeInfo = {
					"className": "Information_Representation",
					"label": 'Information Representation',
					"icon": 'fa-tag'
				}

				let typeApp = {
			    className: "Application_Provider",
		    	label: "Application",
		     	icon: "fa-desktop"
		         };
		
	let scopedInfoReps = essScopeResources(scopedInfoRepList, [a2rDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo); //Get scoped Info reps
	let scopedApps = essScopeResources(workingArrApps, [a2rDef, visibilityDef].concat(dynamicAppFilterDefs), typeApp); //Get scoped Apps
    //console.log('scopedInfoRepList', scopedInfoRepList);



     // Convert scopedApps.resourceIds to a Set for faster lookups
		const scopedAppIdsSet = new Set(scopedApps.resourceIds);

				let showInfoReps = scopedInfoReps.resources; 



// Filter the 'apps' within each data representation of 'showInfoReps'
				showInfoReps.forEach((ir) => { // ir is an information_representation
					if (<xsl:text disable-output-escaping="yes"> <![CDATA[ ir.dataReps && Array.isArray(ir.dataReps) ]]> </xsl:text>) {
						ir.dataReps.forEach((dr) => { // dr is a data_representation
							
							dr.apps.forEach((app) => { // app is an app
					
								//dr.apps = dr.apps.filter(app => scopedAppIdsSet.has(app.id)); //this does not work
						    if (scopedAppIdsSet.has(app.id)) {  app['HIDE'] = true; } //potentially tempory method with help of Handlebars?
								else{app['HIDE'] = false;}

						   });

						});
					}
				});


				//console.log('showInfoReps', showInfoReps);
				//console.log('>>scopedApps', scopedApps);
				//console.log('>>scopedInfoReps', scopedInfoReps);
				let viewArray = {}; 
				viewArray['type'] = "<xsl:value-of select="$repYN"/>";
				viewArray['inforeps'] = showInfoReps;
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
