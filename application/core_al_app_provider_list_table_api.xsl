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
	<xsl:variable name="linkClasses" select="('Business_Process', 'Application_Provider', 'Composite_Application_Provider','Business_Capability')"/>

	<!-- START GENERIC LINK VARIABLES -->
 	<!-- END GENERIC LINK VARIABLES -->
 
	 <xsl:variable name="applicationsRoadmap">0</xsl:variable>

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
	<xsl:variable name="allRoadmapInstances" select="$applicationsRoadmap"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>	
	 
	<xsl:variable name="appData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
    <xsl:variable name="appSvcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"></xsl:variable>

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
        
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Catalogue by Name')"/></span>
								</h1>
							</div>
                        </div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
                        <div class="col-xs-12">
 
                                <table class="table table-striped table-bordered" id="dt_Capabilities">
                                        <thead>
                                            <tr>
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
                                            </tr>
                                        </thead>
                                        <tfoot>
                                            <tr>
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
          <script id="service-name" type="text/x-handlebars-template">
            <!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
            <ul>
            {{#each this.services}}
            <li>  {{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</li>
            {{/each}}
            </ul>
        </script>    
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
                    <xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
                    <xsl:with-param name="viewerAPIPathAppsSvc" select="$apiAppsSvc"></xsl:with-param> 
                    
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPathApps"></xsl:param> 
        <xsl:param name="viewerAPIPathAppsSvc"></xsl:param> 
		//a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathApps"/>';
        var viewAPIDataSvc = '<xsl:value-of select="$viewerAPIPathAppsSvc"/>';
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
		 

		 
		var roadmapCaps = [ <xsl:apply-templates select="$applicationsRoadmap" mode="roadmapCaps"/>];
		var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';

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
			Handlebars.registerHelper('essRenderInstanceLink', function (instance,type) {

				let targetReport = "<xsl:value-of select="$repYN"/>";
		 
				if (targetReport.length &gt; 1) {
			 
					if (instance != null) {
						let linkMenuName = essGetMenuName(instance);
						let instanceLink = instance.name;
						console.log('linkMenuName',linkMenuName)
						console.log('instanceLink',instanceLink)
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

					console.log('meta',meta)
				 
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
            
            let workingArr = []; 
            let svcArr=[];
            let lifecycleArr=[]; 
			Promise.all([
                promise_loadViewerAPIData(viewAPIData),
                promise_loadViewerAPIData(viewAPIDataSvc) 
			]).then(function (responses) {
				meta = responses[0].meta;
                workingArr = responses[0].applications;  
                lifecycleArr = responses[0].lifecycles ;  
                svcArr=responses[1]; 
				workingArr.forEach((d) => {
					 
					//required for roadmap
					var thisRoadmap = roadmapCaps.filter((rm) => {
						return d.id == rm.id;
					});

					if (thisRoadmap[0]) {
						d['roadmap'] = thisRoadmap[0].roadmap;
					} else {
						d['roadmap'] = [];
					}
					
					d['meta'] = meta.filter((d) => {
						return d.classes.includes('Business_Process')
					})
                });
                
                roadmapCaps = [];
                

                // Setup - add a text input to each footer cell
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
		            responsive: false,
		            columns: [
		                {
		                    "width": "20%"
		                },
		                {
		                    "width": "40%"
                        },
                        {
		                    "width": "20%",
		                    "type": "html",
		                },
		                {
		                    "width": "20%",
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

				essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS']);

			 
			}).catch(function (error) {
				//display an error somewhere on the page
            });

            function renderCatalogueTableData(scopedData) {
		        var serviceFragment = $("#service-name").html();
		        var serviceTemplate = Handlebars.compile(serviceFragment);
 
		        let inscopeApps = [];
		        inscopeApps['apps'] = scopedData.apps
		        var dataTableSet = [];
		        var dataTableRow; 
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
		           // inscopeApps.apps[i]['type'] = scopedData.type;
		            dataTableRow = [];
		            //get the current App
                    appNameHTML = nameTemplate(inscopeApps.apps[i]); 
                   
		            //Apply handlebars template
                    appLinkHTML = serviceTemplate(appInf);
                    appLifeHTML = lifeTemplate(appLife); 
                    

		            dataTableRow.push(appNameHTML);
		            dataTableRow.push(app.description);  
		            dataTableRow.push(appLinkHTML);
                    dataTableRow.push(appLifeHTML);
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
				let scopedRMProcs = [];
				workingArr.forEach((d) => {
					scopedRMProcs.push(d)
				});
				let toShow = []; 
				// *** REQUIRED *** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS
				if (roadmapEnabled) {
					//update the roadmap status of the caps passed as an array of arrays
					rmSetElementListRoadmapStatus([scopedRMProcs]);

					// *** OPTIONAL *** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME
					//filter caps to those in scope for the roadmap start and end date
					toShow = rmGetVisibleElements(scopedRMProcs);
				} else {
					toShow = workingArr;
				}

                let workingAppsList = []; 
                let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
				let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
				let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');

				let scopedApps = essScopeResources(toShow, [appOrgScopingDef, geoScopingDef, visibilityDef]);

				let showApps = scopedApps.resources; 
				let viewArray = {};

				viewArray['type'] = "<xsl:value-of select="$repYN"/>";
				viewArray['apps'] = showApps;
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
	<xsl:template match="node()" mode="roadmapCaps">
			{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> </xsl:template>
</xsl:stylesheet>
