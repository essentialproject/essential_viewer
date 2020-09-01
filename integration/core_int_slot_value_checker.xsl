<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	
	<xsl:variable name="slotCheckAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Slot Value Checker']"/>
	<xsl:variable name="slotCheckAPIUrl">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$slotCheckAPIReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="cachedSlotCheckFileName" select="translate($slotCheckAPIReport/own_slot_value[slot_reference='report_xsl_filename']/value,'/','.')"/>
	<xsl:variable name="cachedSlotCheckFilePath">platform/tmp/reportApiCache/<xsl:value-of select="$cachedSlotCheckFileName"/></xsl:variable>
	<xsl:variable name="fileIsCached" select="$slotCheckAPIReport/own_slot_value[slot_reference='is_data_set_api_precached']/value = 'true'"/>
 
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/> 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Essential Slot Value Checker</title>
			<xsl:call-template name="dataTablesLibrary"/>	
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Essential Slot Value Checker</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div id="slotViewSpinner" class="spinner alignCentre hiddenDiv">
							<p id="spinnerMessage1" class="xlarge textLight">Loading slot check data.</p>
							<p id="spinnerMessage2" class="xlarge textLight">This may take a few minutes...</p>
							<i class="fa fa-refresh fa-spin fa-3x fa-fw"/>
						</div>
						<div id="noCacheMessage" class="alignCentre hiddenDiv">
							<p class="xlarge textLight">The slot value data is not yet available in the cache.</p>
							<p class="xlarge textLight">Please try refreshing this page in a few minutes</p>
						</div>
						<div id="slotCheckContainer" class="col-xs-12 hiddenDiv">
 							<table id="dt_instance" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Class')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Instance')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('slot')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Allowed Types')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Current Value')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Current Type')"/>
										</th>
										
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Class')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Instance')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('slot')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Allowed Type')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Current Value')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Current Type')"/>
										</th>
										
									</tr>
								</tfoot>
								<tbody/>								
							</table>
						</div>

					
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		<script>
			var promise_loadViewerAPIData = function(apiDataSetURL) {
	            return new Promise(function (resolve, reject) {
	                if (apiDataSetURL != null) {
	                    var xmlhttp = new XMLHttpRequest(); 
	                    xmlhttp.onreadystatechange = function () {
	                        if (this.readyState == 4 &amp;&amp; this.status == 200) { 
	                            var viewerData = JSON.parse(this.responseText);
	                            resolve(viewerData);
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
			
			
			
			var data = {};
			
			var tableData=[];
						
			function refreshTableData() {		
				data.classes.forEach(function(d){
						var inst, slot, allowedType, currentVal, currentType
						
						if(d.problemInstances != null) {
							d.problemInstances.forEach(function(e){
								if(e.problemSlots != null) {
									e.problemSlots.forEach(function(f){
										f.problemValues.forEach(function(g){
											tableData.push({"class":d.class,"instance":e.name,"slot":f.slotName,"allowedType":f.allowedClasses,"currentValue":g.name, "currentType":g.class})
										});
									});	
								}
							});
						}
				});
				//console.log('Table Data:');
				console.log(tableData);
			}
			
			function drawSlotsTable() {
				
				$('#dt_instance tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="Search '+title+'"&gt;' );
			    } );
			
				var slotTable = $('#dt_instance').DataTable({
			          pageLength: 20,
			          scrollY: "350px",
			          paging: true,
			          deferRender: true,
			          scrollCollapse: true,
					  data: tableData,
			          info: false,
			          sort: true,
			          //responsive: true,
			          columns: [ { 
			          				"data" : "class",
			          				"width": "15%"
			          			 },
								 { 
								 	"data" : "instance",
								 	"width": "25%",
								 	"render": function( d, type, row, meta ) {
						                if(d == null || d.length == 0) {
						                	return 'INSTANCE NAME UNDEFINED';
						                } else {
						                	return d;
						                }
						            }
							 	},
			            		{
			            			"data" : "slot",
			            			"width": "15%"
		            			},
								{
									"data" : "allowedType",
									"type": "html",
									"width": "15",
									"render": function( d, type, row, meta ) {
						                if(d != null) {
						                	let typeString = '&lt;ul&gt;';
						                	d.forEach(function(typeLabel) {
						                		typeString = typeString + '&lt;li&gt;' + typeLabel + '&lt;/li&gt;'
						                	});
						                	typeString = typeString + '&lt;/ul&gt;'
						                	return typeString;
						                } else {
						                	return '-';
						                }
						            }
								},
								{ 
									"data" : "currentValue",
									"width": "15%"
								},
								{ 
									"data" : "currentType",
									"width": "15%"
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
			    slotTable.columns().every( function () {
			        var that = this;
			 
			        $( 'input', this.footer() ).on( 'keyup change', function () {
			            if ( that.search() !== this.value ) {
			                that
			                    .search( this.value )
			                    .draw();
			            }
			        });
			    } );
			    
			    slotTable.columns.adjust();
			    
			    $(window).resize( function () {
			        slotTable.columns.adjust();
			    });
			}
			
			
			function loadSlotValues() {
				let dataURL = '<xsl:value-of select="$slotCheckAPIUrl"/>';
					promise_loadViewerAPIData(dataURL)
					.then(function(response) {
						//console.log('Retrieved data');
						data = response;
						$('#slotCheckContainer').removeClass('hiddenDiv');
						refreshTableData();
						drawSlotsTable();
						$('#slotViewSpinner').addClass('hiddenDiv');
					});	
			}
			
			var checkTimer;
			var dataIsCached = <xsl:value-of select="$fileIsCached"/>;
			
			function fileCheckTimer() {
			  	$.ajax({ 
			        url: '<xsl:value-of select="$cachedSlotCheckFilePath"/>',
			        type:'HEAD',
			        error: function() {
			       		//spinner and message
			        },
			        success: function() {
			        	clearInterval(checkTimer);
			     		loadSlotValues();
			        }
			    });
			}
						
				//console.log(tableData)		
						
			  	$('document').ready(function() {
			  		 if(dataIsCached) {
			  		 	$.ajax({ 
					        url: '<xsl:value-of select="$cachedSlotCheckFilePath"/>',
					        type:'HEAD',
					        error: function() {
					       		//spinner and message
					       		$('#slotViewSpinner').addClass('hiddenDiv');
					       		$('#noCacheMessage').removeClass('hiddenDiv');
					        },
					        success: function() {
					        	clearInterval(checkTimer);
					     		loadSlotValues();
					        }
					    });
			  		 	//checkTimer = setInterval(fileCheckTimer, 1000);	
			  		 } else {
			  		 	$('#slotViewSpinner').removeClass('hiddenDiv');
			  		 	loadSlotValues();
			  		 }
				});			
		 
		</script>	
			
		</html>
	</xsl:template>

</xsl:stylesheet>
