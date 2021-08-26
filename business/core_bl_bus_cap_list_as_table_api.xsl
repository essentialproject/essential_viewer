<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
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
    <xsl:variable name="busCapabilitiesRoadmap">0</xsl:variable>
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
	<xsl:variable name="allRoadmapInstances" select="$busCapabilitiesRoadmap"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>	
	 
 
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
                <title><xsl:value-of select="eas:i18n('Business Capability Catalogue Table')"/></title>
                <script type="text/javascript" src="js/jquery.columnizer.js"/>
				<!--script to turn the app providers list into columns-->
				<script>				
					$(function(){					
						if (document.documentElement.clientWidth &gt; 767) {
							$('.catalogItems').columnize({columns: 2});
						}			
					});
				</script>
				<!--script to support smooth scroll back to top of page-->
				<script type="text/javascript">
					$(document).ready(function() {
					    $('a.topLink').click(function(){
					        $('html, body').animate({scrollTop:0}, 'slow');
					        return false;
					    });
					});
				</script>
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
				 	 <xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
				 
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				 	<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
				
					<div class="clearfix"></div>
				</div>
		 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Capability Catalogue by Name')"/></span>
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

		        busCapArr.forEach((d) => {
		            var thisCap = busCapInfo.businessCapabilities.filter((e) => {
		                return d.id == e.id;
		            }); <!--requiredfor roadmap-->
		            var thisRoadmap = roadmapCaps.filter((rm) => {
		                return d.id == rm.id;
		            });
                    if(thisRoadmap[0]){
                    d['roadmap'] = thisRoadmap[0].roadmap;
                    }else{
                        d['roadmap'] = [];
                    } <!--end required	for roadmap-->
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
		                    "width": "15%"
		                },
		                {
		                    "width": "15%"
		                },
		                {
		                    "width": "35%"
		                },
		                {
		                    "width": "35%",
		                    "type": "html",
		                }
		            ],
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

		        <!-- *** OPTIONAL *** Register the table as having roadmap aware contents-->
		            if (roadmapEnabled) {
		                registerRoadmapDatatable(catalogueTable);
		            }
		        //setCatalogueTable(); 
		        essInitViewScoping(redrawView);

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

		        let scopedRMCaps = [];
		        busCapArr.forEach((d) => {
		            scopedRMCaps.push(d)
		        });
		        let toShow = [];

		        <!-- *** REQUIRED *** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS-->
		            if (roadmapEnabled) {
		                //update the roadmap status of the caps passed as an array of arrays
		                rmSetElementListRoadmapStatus([scopedRMCaps]);

		                <!-- *** OPTIONAL *** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME-->
		                    //filter caps to those in scope for the roadmap start and end date
		                    toShow = rmGetVisibleElements(scopedRMCaps);
		            } else {
		                toShow = busCapArr;
		            }

		            <!-- VIEW SPECIFIC JS CALLS-->
		        //update the catalogue


		        let workingAppsList = [];
		        let capOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
		        let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
		        let prodConceptScopingDef = new ScopingProperty('prodConIds', 'Product_Concept');
		        let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');

		        let scopedCaps = essScopeResources(toShow, [capOrgScopingDef, geoScopingDef, prodConceptScopingDef, domainScopingDef]);

		        let showCaps = scopedCaps.resources;

		        showCaps.sort((a, b) => (a.name.toLowerCase() > b.name.toLowerCase()) ? 1 : ((b.name.toLowerCase() > a.name.toLowerCase()) ? -1 : 0))

		        caps = []
		        let viewArray = {};

		        viewArray['type'] = '<xsl:value-of select="$repYN"/>';
		        viewArray['caps'] = showCaps

		        setCatalogueTable(viewArray);

		    }
			removeEditorSpinner();
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
      {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,}<xsl:if test="not(position() = last())"><xsl:text>,
    </xsl:text></xsl:if> </xsl:template>

</xsl:stylesheet>
