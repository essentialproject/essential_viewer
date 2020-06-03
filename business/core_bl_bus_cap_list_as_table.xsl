<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


	<xsl:output method="html"/>

	<!--
		* Copyright © 2008-2018 Enterprise Architecture Solutions Limited.
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
	<!-- 11.05.2018 JP  Created	 -->



	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Capability', 'Business_Domain')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<!-- START CATALOGUE SPECIFIC VARIABLES -->
	<xsl:variable name="busCapListByName" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Business Capability Catalogue by Name')]"/>

	<xsl:variable name="businessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="businessProcesses" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $businessCaps/name]"/>
	<xsl:variable name="businessDomains" select="/node()/simple_instance[type='Business_Domain']"/>
	<xsl:variable name="allRoadmapInstances" select="($businessCaps, $businessProcesses)"/>
	<xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>

	<!-- END CATALOGUE SPECIFIC VARIABLES -->


	<xsl:template match="knowledge_base">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Capability Catalogue - Table View')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInstances"/>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<!--<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>-->
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
                <xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
                 <script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
                <xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
                <div id="ess-roadmap-content-container">
					<!-- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -->
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
					<div class="clearfix"></div>
				</div>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$busCapListByName"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="eas:i18n('Name')"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Table')"/>
									</span>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<!--Setup Catalogue Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-list-ul icon-section icon-color"/>
								</div>

								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Catalogue')"/>
								</h2>

								<div>
									<p><xsl:value-of select="eas:i18n('Select a Business Capability, Business Process or Business Domain to navigate to the required view')"/>.</p>
									<xsl:call-template name="Index"/>
								</div>
							</div>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                <script id="process-name" type="text/x-handlebars-template">
					<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
					<ul>
                    {{#each this.processes}}
                        <li>{{{this.link}}}</li>
                    {{/each}}
                    </ul>
				</script>
				 
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Index">

		<script>
            var catalogueTable;
            var busCaps = {
							'capabilities': [<xsl:apply-templates select="$businessCaps" mode="getBusCaps"/>]
							  	};
        
            var busProcs=[<xsl:apply-templates select="$businessProcesses" mode="getProcesses"/>];
            var busDoms=[<xsl:apply-templates select="$businessDomains" mode="getBusDomains"/>]
           
            busCaps.capabilities.forEach(function(d){
            var proc=[];
            var dom=[];
                     d.processes.forEach(function(e){
                             busProcs.forEach(function(f){
                                if(e==f.id){proc.push(f)};
                            })
                        })
                    var dom=busDoms.find(function(e){
                                return e.id==d.domain;
                            })
            if(dom){
            d['domain']=dom.link;    
            }else
            {d['domain']='Not Set'}
            
             if(proc){
            d['processes']=proc;    
            }else
            {d['processes']='Not Set'}
          
            });
            var inscopeBusCaps= {
							'capabilities': [<xsl:apply-templates select="$businessCaps" mode="getBusCaps"/>]
							  	};
            inscopeBusCaps.capabilities.forEach(function(d){
            var proc=[];
            var dom=[];
                     d.processes.forEach(function(e){
                             busProcs.forEach(function(f){
                                if(e==f.id){proc.push(f)};
                            })
                        })
                    var dom=busDoms.find(function(e){
                                return e.id==d.domain;
                            })
           if(dom){
            d['domain']=dom.link;    
            }else
            {d['domain']='Not Set'}
            
             if(proc){
            d['processes']=proc;    
            }else
            {d['processes']='Not Set'}
            
            
            });
            var processTemplate;
            
            
            $(document).ready(function(){
                       
            
                        // Setup - add a text input to each footer cell
                        $('#dt_Processes tfoot th').each( function () {
                            var title = $(this).text();
                            $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
                        } );

                        catalogueTable = $('#dt_Processes').DataTable({
                        paging: false,
                        deferRender:    true,
                        scrollY:        350,
                        scrollCollapse: true,
                        info: true,
                        sort: true,
                        responsive: false,
                        columns: [
                            { "width": "15%" },
                            { "width": "15%" },
                            { "width": "35%" },
                            { "width": "35%", "type": "html",}
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
                        catalogueTable.columns().every( function () {
                            var that = this;

                            $( 'input', this.footer() ).on( 'keyup change', function () {
                                if ( that.search() !== this.value ) {
                                    that
                                        .search( this.value )
                                        .draw();
                                }
                            } );
                        } );

                        catalogueTable.columns.adjust();

                        $(window).resize( function () {
                            catalogueTable.columns.adjust();
                        });

                        <!-- ***OPTIONAL*** Register the table as having roadmap aware contents -->
                        if(roadmapEnabled) {
                            registerRoadmapDatatable(catalogueTable);
                        }
               setCatalogueTable();
           
                    });
            
           function redrawView() {
									//console.log('Redrawing View');
									
									<!-- ***REQUIRED*** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS -->
									if(roadmapEnabled) {
										//update the roadmap status of the caps passed as an array of arrays
										rmSetElementListRoadmapStatus([busCaps.capabilities]);
										
										<!-- ***OPTIONAL*** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME -->
										//filter caps to those in scope for the roadmap start and end date
										inscopeBusCaps.capabilities = rmGetVisibleElements(busCaps.capabilities);
									} else {
										inscopeBusCaps.capabilities = busCaps.capabilities;
									}
									       
									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setCatalogueTable();  
                        }
            
           function renderCatalogueTableData() {
                    var processFragment   = $("#process-name").html();
				    var processTemplate = Handlebars.compile(processFragment);
				
        
									var dataTableSet = [];
									var dataTableRow;

									//Note: The list of applications is based on the "inScopeApplications" variable which ony contains apps visible within the current roadmap time frame
									for (var i = 0; inscopeBusCaps.capabilities.length > i; i += 1) {
										dataTableRow = [];
										//get the current App
										aCap = inscopeBusCaps.capabilities[i];
										
										//Apply handlebars template
										capLinkHTML = processTemplate(inscopeBusCaps.capabilities[i]);
										<!--
										//get the current list of app services provided by the app based on the full list of app provider roles
										appServiceList = getObjectsByIds(appProviderRoles.appProviderRoles, 'id', anApp.services);
										appServiceListJSON = {
											appServices: appServiceList
										}
										
										//Apply handlebars template
										appServiceListHTML = appServiceListTemplate(appServiceListJSON);-->
						 
										dataTableRow.push(aCap.domain);
										dataTableRow.push(aCap.link);
										dataTableRow.push(aCap.description);<!-- appServiceListHTML -->
										dataTableRow.push(capLinkHTML);
										
										dataTableSet.push(dataTableRow);
									}
									
									return dataTableSet;
								}
            
           
								
         
             function setCatalogueTable() {					
									var tableData = renderCatalogueTableData();	
  
               catalogueTable = $('#dt_Processes').DataTable();;
									catalogueTable.clear();
									catalogueTable.rows.add(tableData);
			    					catalogueTable.draw();
            
    
								}
							</script>


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

	</xsl:template>

	
<xsl:template match="node()" mode="getBusCaps">
<xsl:variable name="thisBusinessProcesses" select="current()/own_slot_value[slot_reference='realised_by_business_processes']/value"/>
		<xsl:variable name="thisBusinessDomain" select="$businessDomains[name = current()/own_slot_value[slot_reference = 'belongs_to_business_domain']/value]"/>
		
		{
			<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
			<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
            "link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
            	<xsl:with-param name="targetReport" select="$targetReport"/>
			</xsl:call-template>",
            "processes": [<xsl:for-each select="$thisBusinessProcesses">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
			 "domain": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'belongs_to_business_domain']/value"/>"
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>    
	
<xsl:template match="node()" mode="getProcesses">
		<xsl:variable name="this" select="current()"/>
		{
			"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			<xsl:choose>
				<xsl:when test="$targetReport">
					"link":"<xsl:call-template name="RenderMultiLangInstanceName">
						<xsl:with-param name="theSubjectInstance" select="$this"/>
						<xsl:with-param name="isRenderAsJSString" select="true()"/>
					</xsl:call-template>"
				</xsl:when>
				<xsl:otherwise>
					"link":"<xsl:call-template name="RenderInstanceLinkForJS">
						<xsl:with-param name="theSubjectInstance" select="$this"/>
					</xsl:call-template>"
				</xsl:otherwise>
			</xsl:choose>
	
   
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>        
	
<xsl:template match="node()" mode="getBusDomains">
	<xsl:variable name="this" select="current()"/>
		{
		"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
		<xsl:choose>
			<xsl:when test="$targetReport">
				"link":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>"
			</xsl:when>
			<xsl:otherwise>
				"link":"<xsl:call-template name="RenderInstanceLinkForJS">
					<xsl:with-param name="theSubjectInstance" select="$this"/>
				</xsl:call-template>"
			</xsl:otherwise>
		</xsl:choose>
   
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
