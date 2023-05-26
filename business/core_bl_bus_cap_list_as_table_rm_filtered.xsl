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
	<xsl:variable name="linkClasses" select="('Business_Domain','Business_Capability', 'Application_Provider','Business_Process')"/>

	<!-- START GENERIC LINK VARIABLES -->
 	<!-- END GENERIC LINK VARIABLES -->
 
    <!-- interim roadmap fix -->
    <xsl:variable name="busCapabilitiesRoadmap" select="/node()/simple_instance[type='Business_Capability']"/>
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
 
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="capsSimpleData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
    <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiBCM">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiCaps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsSimpleData"></xsl:with-param>
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
                <title><xsl:value-of select="eas:i18n('Business Capability Catalogue by Name')"/></title>
               
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

                    .caps {
                        padding:3px;
                        border-left: 3pt solid #3fceb9;
                        font-size:1.1em;
                        border-bottom: 2pt solid #ffffff;
                    }            
					.eas-logo-spinner {
						display: flex;
						justify-content: center;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Capability Catalogue Table')"/></span>
								</h1>
							</div>
                        </div> 
                        <div class="col-xs-12">
								<div id="editor-spinner" class="hidden">
										<div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;">
											<div class="spin-icon" style="width: 60px; height: 60px;">
												<div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
												<div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
												<div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
											</div>                      
										</div>
										<div id="editor-spinner-text" class="text-center xlarge strong spin-text2"/>
									</div>
                            <table class="table table-striped table-bordered" id="dt_Processes">
			<thead>
				<tr>
					<th>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Domain')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Capability')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Realising Business Processes')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Domain')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Business Capability')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Realising Business Processes')"/>
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

            <script id="name-template" type="text/x-handlebars-template">
                  {{#essRenderInstanceLink this 'Business_Capability'}}{{/essRenderInstanceLink}}       
			</script>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
						<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
						<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param> 
				</xsl:call-template>   
            </script>
            <script id="process-name" type="text/x-handlebars-template">
					<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
					<ul>
                    {{#each this.processes}}
                    <li>  {{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</li>
                    {{/each}}
                    </ul>
                </script>
                <script id="domain-name" type="text/x-handlebars-template"> 
                     
                      {{#essRenderInstanceLinkMenuOnly this.domain 'Business_Domain'}}{{this.domain}}{{/essRenderInstanceLinkMenuOnly}}<br/>
                   
                    
				</script>    
				<script id="select-template" type="text/x-handlebars-template">
					{{#essRenderInstanceLinkSelect this 'Business_Capability'}}{{/essRenderInstanceLinkSelect}}       
			  </script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param> 
		<xsl:param name="viewerAPIPathCaps"></xsl:param>
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>';
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
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
<!-- interim fix for roadmaps -->        
var roadmapCaps=[<xsl:apply-templates select="$busCapabilitiesRoadmap" mode="roadmapCaps"/>];
<!-- end fix for roadmaps -->  
var reportURL='<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
function showEditorSpinner(message) {
	$('#editor-spinner-text').text(message);                            
	$('#editor-spinner').removeClass('hidden');                         
};

function removeEditorSpinner() {
	$('#editor-spinner').addClass('hidden');
	$('#editor-spinner-text').text('');
};

showEditorSpinner('Fetching Data...');
		$('document').ready(function () {
		    let catalogueTable;

			var selectFragment = $("#select-template").html();
			var selectTemplate = Handlebars.compile(selectFragment);

		    domainFragment = $("#domain-name").html();
		    domainTemplate = Handlebars.compile(domainFragment);

			nameFragment = $("#name-template").html();
		    nameTemplate = Handlebars.compile(nameFragment);
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
		    Handlebars.registerHelper('essRenderInstanceLink', function (instance, type) {

		        let targetReport = "<xsl:value-of select="$repYN"/>";
		        let linkMenuName = essGetMenuName(instance);
		        if (targetReport.length &gt; 1) {
		            let linkURL = reportURL;
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
		            let linkId = instance.id + 'Link';
		            instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';

		            return instanceLink;
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

		    let busCapArr = [];
		    Promise.all([
		        promise_loadViewerAPIData(viewAPIData),
		        promise_loadViewerAPIData(viewAPIDataCaps)
		    ]).then(function (responses) {
		        meta = responses[0].meta;
		        busCapArr = responses[0].busCaptoAppDetails;
		        busCapInfo = responses[1]
		        responses[0]['busCapHierarchy'] = [];
				responses[0]['physicalProcessToProcess'] = [];
 
				let missingCaps = busCapInfo.businessCapabilities.filter(({ id: id1 }) => !busCapArr.some(({ id: id2 }) => id2 === id1));
  
				missingCaps.forEach((d)=>{
					busCapArr.push({"id":d.id,"name":d.name, "description":d.description, "domainIds": d.domainIds, "geoIds": d.geoIds, "visId":d.visId})
				});

		        busCapArr.forEach((d) => {
		            var thisCap = busCapInfo.businessCapabilities.filter((e) => {
		                return d.id == e.id;
					});
					
		            d['desc'] = thisCap[0].description;
		            d['domain'] = {
		                'name': thisCap[0].businessDomain,
		                'id': d.domainIds[0]
		            };
		            d['meta'] = meta.filter((d) => {
		                return d.classes.includes('Business_Capability')
		            })
		        });

		        roadmapCaps = [];


		        // Setup - add a text input to each footer cell
		        $('#dt_Processes tfoot th').each(function () {
		            var title = $(this).text();
		            $(this).html('&lt;input type="text" placeholder="Search ' + title + '" /&gt;');
		        });

		        catalogueTable = $('#dt_Processes').DataTable({
		            paging: false,
		            deferRender: true,
		            scrollY: 350,
		            scrollCollapse: true,
		            info: true,
		            sort: true,
		            responsive: false,
		            columns: [{
						"width": "2%"
						},
						{
		                    "width": "15%"
		                },
		                {
		                    "width": "15%"
		                },
		                {
		                    "width": "30%"
		                },
		                {
		                    "width": "35%",
		                    "type": "html",
		                }
					],
					"columnDefs": [ {
						"targets": 0,
						"orderable": false
						} ],
					
					order: [[ 2, 'asc' ]],	
		            dom: 'Bfrtip',
		            buttons: [
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

		        //setCatalogueTable(); 
		        essInitViewScoping(redrawView, ['Group_Actor', 'Business_Domain', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept'], true);

		    });

		    function renderCatalogueTableData(scopedData) {
		        var processFragment = $("#process-name").html();
		        var processTemplate = Handlebars.compile(processFragment);

		        let inscopeBusCaps = [];
		        inscopeBusCaps['capabilities'] = scopedData.caps
		        var dataTableSet = [];
		        var dataTableRow;

		        //Note: The list of applications is based on the "inScopeApplications" variable which ony contains apps visible within the current roadmap time frame
		        for (var i = 0; inscopeBusCaps.capabilities.length > i; i += 1) {

		            inscopeBusCaps.capabilities[i]['type'] = scopedData.type;
		            dataTableRow = [];
		            //get the current App
		            aCap = inscopeBusCaps.capabilities[i];
		            capNameHTML = nameTemplate(inscopeBusCaps.capabilities[i]);
		            //Apply handlebars template
		            capLinkHTML = processTemplate(inscopeBusCaps.capabilities[i]);
		            domLinkHTML = domainTemplate(inscopeBusCaps.capabilities[i]);

					selectHTML=selectTemplate(inscopeBusCaps.capabilities[i]);  
					dataTableRow.push(selectHTML);
		            dataTableRow.push(domLinkHTML);
		            dataTableRow.push(capNameHTML);
		            dataTableRow.push(aCap.desc);  
		            dataTableRow.push(capLinkHTML);

		            dataTableSet.push(dataTableRow);
		        }

		        return dataTableSet;
		    }

		    function setCatalogueTable(scopedData) {
		        var tableData = renderCatalogueTableData(scopedData);
		        catalogueTable.clear();
		        catalogueTable.rows.add(tableData);
		        catalogueTable.draw();
		    }

		    var redrawView = function () {
				essResetRMChanges();
				typeInfo = {
					"className": "Business_Capability",
					"label": 'Business Capability',
					"icon": 'fa-landmark'
				}

		        let scopedRMCaps = [];
		        busCapArr.forEach((d) => {
		            scopedRMCaps.push(d)
		        });
		        let toShow = busCapArr;

		            <!-- VIEW SPECIFIC JS CALLS-->
		        //update the catalogue
		        let workingAppsList = [];
		        let capOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
		        let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
		        let prodConceptScopingDef = new ScopingProperty('prodConIds', 'Product_Concept');
				let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');

		        let scopedCaps = essScopeResources(toShow, [capOrgScopingDef, geoScopingDef, prodConceptScopingDef, domainScopingDef, visibilityDef], typeInfo);

		        let showCaps = scopedCaps.resources;

		        showCaps.sort((a, b) => (a.name.toLowerCase() > b.name.toLowerCase()) ? 1 : ((b.name.toLowerCase() > a.name.toLowerCase()) ? -1 : 0))

		        caps = []
		        let viewArray = {};

		        viewArray['type'] = '<xsl:value-of select="$repYN"/>';
		        viewArray['caps'] = showCaps

		        setCatalogueTable(viewArray);

		    }
			removeEditorSpinner()

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
							instanceLink = '<button eas-id="store_70_Class20133" class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15"> ' + linkClass + '" href="' + linkHref + '" id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select1</button>'

						} else if (instanceLink != null) {
							let linkURL = reportURL;
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
							let linkClass = 'context-menu-' + linkMenuName;

							let linkId = instance.id + 'Link';
						//	instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';
							instanceLink = '<button eas-id="store_70_Class20133" class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15" onclick="location.href=&quot;' + linkHref + '&quot;" id="' + linkId+'"><i class="text-success fa fa-check-circle right-5"></i>Select2</button>'

							

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
						instanceLink = '<button eas-id="store_70_Class20133" class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15 ' + linkClass + '" href="' + linkHref + '"  id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'

						return instanceLink;
					}
				}
				})
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
    
   <xsl:template match="node()" mode="roadmapCaps">
		<xsl:variable name="this" select="current()"/>

		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$this"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDescription"><xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template></xsl:variable>

      {
		"id": "<xsl:value-of select="$this/name"/>",
		"name": "<xsl:value-of select="$thisName"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"description": "<xsl:value-of select="$thisDescription"/>"
	  }<xsl:if test="not(position() = last())"><xsl:text>,
    </xsl:text></xsl:if> </xsl:template>

</xsl:stylesheet>
