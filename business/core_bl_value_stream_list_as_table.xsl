<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	 <xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../business/core_bl_utilities.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Value_Stream', 'Product_Type','Individual_Business_Role', 'Group_Business_Role', 'Business_Role_Type')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="allValueStreams" select="/node()/simple_instance[type = 'Value_Stream']"/>
	<xsl:variable name="allVSInitiators" select="/node()/simple_instance[name = $allValueStreams/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value]"/>
	<xsl:variable name="allProductTypes" select="/node()/simple_instance[name = $allValueStreams/own_slot_value[slot_reference = 'vs_product_types']/value]"/>
	<xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][name=$allValueStreams/own_slot_value[slot_reference='stakeholders']/value]"/>
	<xsl:key name="actorKey" match="/node()/simple_instance[type = 'Group_Actor']" use="own_slot_value[slot_reference = 'actor_plays_role']/value "/>
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 28.07.2018 JP Updated to support Roadmap capabilities -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Value Stream Catalogue')"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				 
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
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Value Stream Catalogue as Table')"/>
									</span>
								</h1>
							</div>
						</div>
					</div>
					

					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>


							<p><xsl:value-of select="eas:i18n('This table lists all the Value Streams allows search as well as copy to spreadsheet')"/>.</p>
							<script type="text/javascript">
	
								<!-- START VIEW SPECIFIC JAVASCRIPT VARIABLES -->
								//global catalogue specific variables
								var catalogueTable;
								var instanceListTemplate, vsNameTemplate;
								
								// the list of JSON objects representing the product types in scope
							  	var productTypes = {
										productTypes: [<xsl:apply-templates select="$allProductTypes" mode="RenderInstanceJSON"/>
							    	]
							  	};				  	
								
								// the list of JSON objects representing the value streams in use across the enterprise
							  	var valStreams = {
										valStreams: [<xsl:apply-templates select="$allValueStreams" mode="RenderValStreamJSON"/>
							    	]
							  	};
							  	
							  	// the list of JSON objects representing the business roles in scope
							  	var vsInitiators = {
										vsInitiators: [<xsl:apply-templates select="$allVSInitiators" mode="RenderInstanceJSON"/>
							    	]
							  	};
							  	
							  	//the list of products for the current scope
							  	var inScopeProdTypes = {
							  		productTypes: productTypes.productTypes
							  	}
							  	
							  	//the list of value streams for the current scope
							  	var inScopeValStreams = {
							  		valStreams: valStreams.valStreams
							  	}
							  	
							  	//the list of business roles for the current scope
							  	var inScopeVSInitiators = {
							  		vsInitiators: vsInitiators.vsInitiators
							  	}
							  	<!-- END VIEW SPECIFIC JAVASCRIPT VARIABLES -->
							  	
							  	
							  	//function to create the data structure needed to render table rows
								function renderValStreamTableData() {
									var dataTableSet = [];
									var dataTableRow;

									//Note: The list of valStreams is based on the "inScopeValStreams" variable which ony contains apps visible within the current roadmap time frame
									for (var i = 0; inScopeValStreams.valStreams.length > i; i += 1) {
										dataTableRow = [];
										//get the current Bus Proc
										var aValStream = inScopeValStreams.valStreams[i];
										//Apply handlebars template
										var valStreamLinkHTML = vsNameTemplate(aValStream);
										
										//get the list of initiatos of the value stream
										let prodList=[]
									
										aValStream.products.forEach((e)=>{ 
											let match=inScopeProdTypes.productTypes.find((f)=>{
												return f.id==e;
											}) 
											prodList.push(match)
										})

										var prodTypeList =prodList
										var prodTypeListJSON = {
											instances: prodTypeList
										}							
										//Apply handlebars template
										var prodTypeListHTML = instanceListProductTemplate(prodTypeListJSON);
										let initList=[]
									
										aValStream.initiators.forEach((e)=>{ 
											let match=inScopeVSInitiators.vsInitiators.find((f)=>{
												return f.id==e;
											}) 
											initList.push(match)
										})

										//get the list of initiatos of the value stream
										var initiatorList = initList;
										var initiatorListJSON = {
											instances: initiatorList
										}							
										//Apply handlebars template
										var initiatorListHTML = instanceListTemplate(initiatorListJSON);
										
										
										dataTableRow.push(valStreamLinkHTML);
										dataTableRow.push(aValStream.description);
										dataTableRow.push(prodTypeListHTML);
										dataTableRow.push(initiatorListHTML);
										
										dataTableSet.push(dataTableRow);
									}
									
									return dataTableSet;
								}
								
								
								//funtion to set contents of the catalogue table
								function setValStreamTable() {					
									var tableData = renderValStreamTableData();								
									catalogueTable.clear();
									catalogueTable.rows.add(tableData);
			    					catalogueTable.draw();
								}
								
							  	
							  	<!-- ***REQUIRED*** JAVASCRIPT FUNCTION TO REDRAW THE VIEW WHEN THE ANY SCOPING ACTION IS TAKEN BY THE USER -->
							  	//function to redraw the view based on the current scope
								function redrawView() {
									essResetRMChanges();
									typeInfo = {
										"className": "Value_Stream",
										"label": 'Value Stream',
										"icon": 'fa-chevron-right'
									}
									//console.log('Redrawing View');
									orgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor'); 
						
									inScopeValStreams.valStreams  = essScopeResources(valStreams.valStreams, [orgScopingDef], typeInfo);
									
									inScopeValStreams.valStreams =inScopeValStreams.valStreams.resources;

									<!-- VIEW SPECIFIC JS CALLS -->
									//update the catalogue
									setValStreamTable();
																						
								}
								
								
								$(document).ready(function(){
									var reportURL='<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
									const essLinkLanguage = '<xsl:value-of select="$i18n"/>';

								function essGetMenuName(instance) { 
								
									let menuName = null;
									if(instance){
										if ((instance != null) &amp;&amp;
											(instance.meta != null) &amp;&amp;
											(instance.meta.classes != null)) {
											menuName = instance.meta.menuId;
										} else if (instance.classes != null) {
											menuName = instance.meta.classes;
										}
											return menuName;
										}
									else{
										return 'Business_Process';
									}
								}
								Handlebars.registerHelper('essRenderInstanceLink', function (instance, type) {
									
									let meta =[
										{"classes":["Product_Type"], "menuId":"prodTypeGenMenu"},
										{"classes":["Value_Stream"], "menuId":"valStreamGenMenu"}]
 
									let linkMenuName = essGetMenuName(instance);
									
										let thisMeta = meta.filter((d) => {
											return d.classes.includes(type)
										});
										if(instance){
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
								
									//START COMPILE HANDLEBARS TEMPLATES
									
									//Set up the html templates for technology products, components and capabilities
									var instanceListFragment   = $("#instance-bullets").html();
									instanceListTemplate = Handlebars.compile(instanceListFragment);
									
									var instanceProductListFragment   = $("#instance-bullets-product").html();
									instanceListProductTemplate = Handlebars.compile(instanceProductListFragment);
									
									var vsNameFragment   = $("#val-stream-name").html();
									vsNameTemplate = Handlebars.compile(vsNameFragment);
									
									//END COMPILE HANDLEBAR TEMPLATES

								
									//START INITIALISE UP THE CATALOGUE TABLE
									// Setup - add a text input to each footer cell
								    $('#dt_valStreams tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
								    } );
									
									catalogueTable = $('#dt_valStreams').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "25%" },
									    { "width": "35%" },
                                        { "width": "20%", "type": "html"},
									    { "width": "20%", "type": "html"}
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
								    
								   
								    
								    //END INITIALISE UP THE CATALOGUE TABLE
								    
								    //DRAW THE VIEW
									essInitViewScoping(redrawView,['Group_Actor'], '',true);
								});
							</script>
							<!-- START TEST DIVS -->
							<div id="testStyling1"/>
							<div id="testStyling2"/>
							<!-- END TEST DIVS -->
							<table id="dt_valStreams" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Value Stream')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Products')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Initiators')"/>
										</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Value Stream')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Products')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Initiators')"/>
										</th>
                                    </tr>
								</tfoot>
								<tbody/>								
							</table>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- START HANDLEBARS TEMPLATES -->
				
				<!-- Handlebars template to render a list of technology capabilities -->
				<script id="instance-bullets" type="text/x-handlebars-template">
					<ul>
						{{#instances}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<i class="fa fa-caret-right"></i> {{name}}<br/>
						{{/instances}}
					</ul>
				</script>

				<script id="instance-bullets-product" type="text/x-handlebars-template">
					<ul>
						{{#instances}}
							<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A BULLET DOM ELEMENT -->
							<i class="fa fa-caret-right"></i> {{#essRenderInstanceLink this 'Product_Type'}}{{/essRenderInstanceLink}}<br/>
						{{/instances}}
					</ul>
				</script>
				
				<!-- Handlebars template to render an individual application as text-->
				<script id="val-stream-name" type="text/x-handlebars-template">
					<!-- CALL THE ROADMAP HANDLEBARS TEMPLATE FOR A TEXT DOM ELEMENT -->
				 {{#essRenderInstanceLink this 'Value_Stream'}}{{/essRenderInstanceLink}}<br/>
					
				</script>
				<!-- END HANDLEBARS TEMPLATES -->
				
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	
	<!-- START TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->
	<xsl:template match="node()" mode="RenderInstanceJSON">
		
		{
		<!-- ***REQUIRED*** CALL TEMPLATE TO RENDER REQUIRED COMMON AND ROADMAP RELATED JSON PROPERTIES -->
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		"name": "<xsl:call-template name="RenderMultiLangInstanceName"> 
		<xsl:with-param name="theSubjectInstance" select="current()"/>
		   </xsl:call-template>"} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderValStreamJSON">	
		<xsl:variable name="thisA2r" select="$a2r[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
		<xsl:variable name="thisActors" select="key('actorKey',$thisA2r/name)"/>	
		<xsl:variable name="thisInitiators" select="$allVSInitiators[name = current()/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value]"/>
		<xsl:variable name="thisProductTypes" select="$allProductTypes[name = current()/own_slot_value[slot_reference = 'vs_product_types']/value]"/>	
		{ 
			"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"> 
			<xsl:with-param name="theSubjectInstance" select="current()"/>
		   	</xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription">
			   <xsl:with-param name="isRenderAsJSString" select="true()"/> 
				   <xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>",
		    "products": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisProductTypes"/>], 
			"initiators": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisInitiators"/>],
			<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
		} <xsl:if test="not(position()=last())">,
		</xsl:if>
	</xsl:template>
	
	<!-- END TEMPLATES TO RENDER THE JSON OBJECTS REQUIRED FOR THE VIEW -->

</xsl:stylesheet>
