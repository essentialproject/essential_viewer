<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
    <xsl:include href="../common/core_api_fetcher.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Capability', 'Enterprise_Strategic_Plan')"/>
	
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<xsl:template match="knowledge_base">
	
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
               
				<title>API Test</title>

			</head>
			<body>
				
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Strategic Plans as Table')"/></span>
								</h1>
							</div>
						</div>  
						<div class="col-xs-12"> 
							<table class="table table-striped table-bordered" id="dt_StratPlans">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Start Date')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('End Date')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Start Date')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('End Date')"/>
										</th>
									</tr>
								</tfoot>
							</table>
						</div>
						

						

						<!--Setup Closing Tags-->
					</div>
				</div> 
				<script id="select-template" type="text/x-handlebars-template">
					{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}       
					</script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                <script type="text/javascript">
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>	
					<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
                    <!-- make sure you include "../common/core_api_fetcher.xsl" at the top of the page -->
					<!-- define your variables-->
					let appListApi, busCapAppMartApps, techKpiAPI;
					var selectTemplate 

                        $(document).ready(function() {

							var selectFragment = $("#select-template").html();
							selectTemplate = Handlebars.compile(selectFragment);
						
							 
							<!-- define the list of apis to call based on their data label-->
                            apiList=['appListApi','busCapAppMartApps','techKpiAPI'];

                            async function executeFetchAndRender() {
                                try {
                            let responses = await fetchAndRenderData(apiList);
							<!-- assign the responses to your variables, keep the order consistent with the apiList order -->
                            ({ appListApi, busCapAppMartApps, techKpiAPI } = responses);

							<!-- add logic here -->
                            console.log('appListApi',appListApi );
                                }
                                catch (error) {
                                    // Handle any errors that occur during the fetch operations
                                    console.error('Error fetching data:', error);
                                }
                            }
                            executeFetchAndRender()
							essInitViewScoping	(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], "", true);
			
                        });   
                            
						var redrawView=function(){
  
							essResetRMChanges();
						console.log('redraw')	
						console.log('essRMApiData')
						console.log(essRMApiData.rpp.strategicPlans)
						essRMApiData.rpp.strategicPlans.forEach((s)=>{
							s['className']='Enterprise_Strategic_Plan';
							selectHTML=selectTemplate(s);
							s['link']=selectHTML;
						})

						colSettings=[
						
						{
							"data" :  "link",
							"title": "Name",
							"visible": true
						},
						{
							"data" : "description",
							"title": "Description",
							"visible": true 
						},
						{	"data":"startDate",
							"title": "Start Date",
							"visible": true
						},
						{	"data":"endDate",
							"title": "End Date",
							"visible": true 					
						}
						]


				$('#dt_StratPlans tfoot th').each(function () {
		            var title = $(this).text();
					var titleid=title.replace(/ /g, "_");
				 
		            $(this).html('&lt;input type="text" class="dynamic-filter" id="'+titleid+'" placeholder="Search ' + title + '" /&gt;');
		        });
			
				// Initialize DataTable with dynamic columns
				table = $("#dt_StratPlans").DataTable({
				"paging": false,
				"deferRender": true,
				"scrollY": 350,
				"scrollCollapse": true,
				"info": true,
				"sort": true,
				"destroy" : true,
				"responsive": false,
				"stateSave": true,
			 	"data": essRMApiData.rpp.strategicPlans,
				"columns": colSettings,
				"dom": 'Bfrtip',
				"buttons": [ 
					'colvis',
					'copyHtml5',
					'excelHtml5',
					'csvHtml5',
					'print'
				],
				stateSaveCallback: function(settings, data) {
					data.dynamicSearch = {};
					 
					if ($('.dynamic-filter').length > 0) {
						console.log('exists')
						
						$('.dynamic-filter').each(function() {
						 
							var inputId = $(this)[0].id; // Ensure all elements have an ID
							 
							if (inputId) { // Check if ID is not undefined
								data.dynamicSearch[inputId] = $(this)[0].value;
							}
						});
						console.log('dynamicSearch', data.dynamicSearch);
					}
						// Save the state object to local storage
						console.log('dta', data);
					localStorage.setItem('DataTables_StratPlans' + settings.sInstance, JSON.stringify(data))
				},
				stateLoadCallback: function(settings) {

					var data = JSON.parse(localStorage.getItem('DataTables_StratPlans' + settings.sInstance));

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
						 
						}
                </script>
			
			</body>
            
		</html>
	</xsl:template>


</xsl:stylesheet>
