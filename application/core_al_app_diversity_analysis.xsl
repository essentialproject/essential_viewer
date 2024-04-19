<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:import href="../common/core_js_functions.xsl"/>
<xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
<xsl:include href="../common/core_doctype.xsl"/>
<xsl:include href="../common/core_common_head_content.xsl"/>
<xsl:include href="../common/core_header.xsl"/>
<xsl:include href="../common/core_footer.xsl"/>
<xsl:include href="../common/core_external_doc_ref.xsl"/>
<xsl:include href="../common/core_handlebars_functions.xsl"/>

	<xsl:output method="html"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Application_Capability', 'Application_Service', 'Application_Provider', 'Supplier', 'Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:param name="param2"/>
	<xsl:variable name="currentCapability" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="capabilityName" select="$currentCapability/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="inScopeAppSvcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_application_capabilities']/value = $currentCapability/name]"/>
	<xsl:key name="inScopeAppSvcsKey" match="/node()/simple_instance[type='Application_Service']" use="own_slot_value[slot_reference = 'realises_application_capabilities']/value"/>
	<xsl:key name="inScopeAppProRolesKey" match="/node()/simple_instance[type='Application_Provider_Role']" use="own_slot_value[slot_reference = 'implementing_application_service']/value"/>
	<xsl:key name="inScopeAppsKey" match="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]" use="own_slot_value[slot_reference = 'provides_application_services']/value"/>
	<xsl:key name="inScopeSupplierKey" match="/node()/simple_instance[type=('Supplier')]" use="name"/>
	<xsl:variable name="inScopeAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $inScopeAppSvcs/name]"/>
	<xsl:variable name="inScopeApps" select="/node()/simple_instance[name = $inScopeAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="inScopeSuppliers" select="/node()/simple_instance[name = $inScopeApps/own_slot_value[slot_reference = 'ap_supplier']/value]"/>

	
	<xsl:variable name="appMartData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Mart']"></xsl:variable>

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
	<!-- 05.11.2008 JWC	Upgraded to XSL v2 and imported edits from live reports -->
	<!-- 06.11.2008	JWC Repaired location of the Page History box -->

	<xsl:template match="knowledge_base">
		<xsl:variable name="apiappMart">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$appMartData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Application Diversity and Duplication Analysis')"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Diversity and Duplication Analysis')"/>&#160;<xsl:value-of select="eas:i18n('for')"/>&#160;<span class="text-primary"><xsl:value-of select="$capabilityName"/></span></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-tablet icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Application Diversity and Duplication Analysis')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following table describes the Application Services that are defined for this Capability and the applications that are being used to implement the each service along with the technology products that are used to deliver the application')"/>. </p>
								<!--new -->
									<div id="newtable"></div>
							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
					<xsl:with-param name="viewerAPIPathAppMart" select="$apiappMart"></xsl:with-param>
				</xsl:call-template>  
			</script>
			<script id="table-template" type="text/x-handlebars-template">

				 
							<table  class="table table-bordered table-striped appcaptable">
								<thead>
									<tr>
										<th><xsl:value-of select="eas:i18n('APPLICATION CAPABILITY')"/></th>
										<th><xsl:value-of select="eas:i18n('APPLICATION SERVICES')"/></th>
										<th><xsl:value-of select="eas:i18n('APPLICATIONS')"/></th>
										<th><xsl:value-of select="eas:i18n('SUPPLIER')"/></th>
										<th><xsl:value-of select="eas:i18n('ENVIRONMENT &amp; PRODUCTS USED')"/></th>
									</tr>
								</thead>
								<tbody>
									{{#each this}}
									<tr>
										<td>{{#essRenderInstanceMenuLink this.applicationCapability}}{{/essRenderInstanceMenuLink}}
													<br/>
													{{this.applicationCapability.description}}

										</td>
										<td>{{#essRenderInstanceMenuLink this.applicationServices}}{{/essRenderInstanceMenuLink}}</td>											
										<td>{{#essRenderInstanceMenuLink this.applications}}{{/essRenderInstanceMenuLink}}</td>
										<td>{{this.supplier}}</td>
										<td>{{this.environment}}<br/>
											{{#each this.environmentProducts}}
												{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
												{{#if this.compname}}
													({{this.compname}})
												{{/if}}
												<br/>

											{{/each}}

										</td>
									</tr>

									{{/each}}
								</tbody>
							</table>
			</script>
		</html>
	</xsl:template>


<xsl:template match="node()" mode="appCapJSON">
	<xsl:variable name="thisSvs" select="key('inScopeAppSvcsKey', current()/name)"/>
{
	"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	<xsl:variable name="temp" as="map(*)" select="map{
		'name': string(current()/own_slot_value[slot_reference = 'name']/value),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', '('))
	}">
	</xsl:variable>
	<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
	<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"/>,
	"services":[<xsl:for-each select="$thisSvs">
		<xsl:variable name="thisAPR" select="key('inScopeAppProRolesKey', current()/name)"/>
		<xsl:variable name="thisApps" select="key('inScopeAppsKey', $thisAPR/name)"/>
	
		{
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		<xsl:variable name="temp" as="map(*)" select="map{
		'name': string(current()/own_slot_value[slot_reference = 'name']/value),
		'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', '('))
		}">
		</xsl:variable>
		<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"/>,
		"applications":[<xsl:for-each select="$thisApps">
			<xsl:variable name="thisSupplier" select="key('inScopeSupplierKey',current()/own_slot_value[slot_reference = 'ap_supplier']/value)"/>
			{
				"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
				<xsl:variable name="temp" as="map(*)" select="map{
				'name': string(current()/own_slot_value[slot_reference = 'name']/value),
				'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', '('))
				}">
				</xsl:variable>
				<xsl:variable name="result" select="serialize($temp, map{'method':'json', 'indent':true()})"/>
				<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"/>,
				"supplier":{"id":"<xsl:value-of select="eas:getSafeJSString($thisSupplier/name)"/>",
				<xsl:variable name="suptemp" as="map(*)" select="map{
				'name': string($thisSupplier/own_slot_value[slot_reference = 'name']/value),
				'description': string(translate(translate($thisSupplier/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', '('))
				}">
				</xsl:variable>
				<xsl:variable name="supresult" select="serialize($suptemp, map{'method':'json', 'indent':true()})"/>  
				<xsl:value-of select="substring-before(substring-after($supresult,'{'),'}')"/>}
			}<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>
		]
	}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>],
	"debug":"<xsl:value-of select="$thisSvs/name"/>"

}
</xsl:template>
<xsl:template name="RenderViewerAPIJSFunction">  
		<xsl:param name="viewerAPIPathAppMart"></xsl:param> 
		var viewAPIDataAppMart = '<xsl:value-of select="$viewerAPIPathAppMart"/>'; 
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
			
let jsonData= <xsl:apply-templates select="$currentCapability" mode="appCapJSON"/>

		<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
		var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200){
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
							$('#ess-data-gen-alert').hide();
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
var occurrenceCounts
	 
$('document').ready(function (){

		var tableFragment = $("#table-template").html();	
		tableTemplate = Handlebars.compile(tableFragment);
		
		
		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('getCount', function (arg1, arg2) {
			let tot= occurrenceCounts[arg1][arg1]
			return tot
		});


		Promise.all([  
		promise_loadViewerAPIData(viewAPIDataAppMart) 
		]).then(function (responses)
		{
			console.log('mart', responses[0])
		appMartdata = responses[0].application_technology;
		appMart = new Map();
		appMartdata.forEach(app => appMart.set(app.id, app));
		console.log('appMartdata',appMartdata)
		allApplications=responses[0].applications
		filters=responses[0].filters || [];
		console.log('filters', filters)
		dynamicAppFilterDefs=filters?.map(function(filterdef){
			return new ScopingProperty(filterdef.slotName, filterdef.valueClass)

		});

		

essInitViewScoping(redrawView,['Group_Actor', 'SYS_CONTENT_APPROVAL_STATUS','ACTOR_TO_ROLE_RELATION','Geographic_Region'], responses[0].filters, true);

	})

	var redrawView = function () { 
	
 
		let appOrgScopingDef = new ScopingProperty('stakeholdersA2R', 'ACTOR_TO_ROLE_RELATION');
		let capOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
		let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
		let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');

		essResetRMChanges();
		let typeInfo = {
			"className": "Application_Provider",
			"label": 'Application',
			"icon": 'fa-desktop'
		}

		let scopedApps = essScopeResources(
    allApplications, 
    [
        capOrgScopingDef, 
        appOrgScopingDef, 
        visibilityDef, 
        geoScopingDef,
        ...(dynamicAppFilterDefs ? dynamicAppFilterDefs : [])
    ], 
    typeInfo
);

 
		scopedAppsList = scopedApps.resourceIds;  
		console.log('jsonData', jsonData)
		jsonData.services.forEach(service => {
			service.toShowApplications = service.applications.filter(application => 
				scopedAppsList.includes(application.id)
			);

			service.toShowApplications.forEach(toShowApp => {
				let foundApp = appMart.get(toShowApp.id);
				if (foundApp) {
				
					if(foundApp.environments){
						foundApp.environments.forEach((e)=>{
								e.products.forEach((p)=>{
									p['className']='Technology_Product'
									p['id']=p.prod;
									p['name']=p.prodname;
							})
						})
					}
					toShowApp.environments = foundApp.environments;
				}
			});
		
		});
		console.log('jsonData2', jsonData)
		function generateCombinationsMarkFirst(data) {
			let combinations = [];
			let firstOccurrenceTracker = {
				applicationCapability: {},
				applicationServices: {},
				applications: {},
				supplier: {},
				environment: {}
			};
		
			data.services.forEach(service => {
				service.toShowApplications.forEach(application => {
					let supplierName = application.supplier ? application.supplier.name : '';
		
					if (application.environments &amp;&amp; application.environments.length > 0) {
						application.environments.forEach(environment => {
							environment.nodes.forEach(node => {
								let combination = {
									applicationCapability: {"id":data.id,"name": data.name, "className":"Application_Capability", "description":data.description},
									applicationServices: {"id":service.id,"name": service.name, "className":"Application_Service"},
									applications: {"id":application.id,"name": application.name, "className":"Application_Provider"},
									supplier: supplierName,
									environment: `${environment.name} - ${node.name}`,
									environmentProducts: environment.products,
									isFirstOccurrence: {}
								};
		
								// Mark the first occurrence of each property value
								['applicationCapability', 'applicationServices', 'applications', 'supplier', 'environment'].forEach(key => {
									if (!firstOccurrenceTracker[key][combination[key]]) {
										firstOccurrenceTracker[key][combination[key]] = true;
										combination.isFirstOccurrence[key] = true; // Mark as first occurrence
									} else {
										combination.isFirstOccurrence[key] = false;
									}
								});
		
								combinations.push(combination);
							});
						});
					} else {
						// For applications without environments
						let combination = {
							applicationCapability: {"id": data.id, "name": data.name, "className": "Application_Capability", "description": data.description},
							applicationServices: {"id": service.id, "name": service.name, "className": "Application_Service"},
							applications: {"id": application.id, "name": application.name, "className": "Application_Provider"},
							supplier: supplierName,
							environment: 'N/A',
							isFirstOccurrence: {
								applicationCapability: !firstOccurrenceTracker.applicationCapability[data.name],
								applicationServices: !firstOccurrenceTracker.applicationServices[service.name],
								applications: !firstOccurrenceTracker.applications[application.name],
								supplier: !firstOccurrenceTracker.supplier[supplierName],
								environment: true // 'N/A' environment is always unique
							}
						};
			
						// Marking first occurrences
						['applicationCapability', 'applicationServices', 'applications', 'supplier'].forEach(key => {
							if (!firstOccurrenceTracker[key][combination[key]]) {
								firstOccurrenceTracker[key][combination[key]] = true;
								combination.isFirstOccurrence[key] = true; // Mark as first occurrence
							} else {
								combination.isFirstOccurrence[key] = false;
							}
						});
			
						combinations.push(combination);
					}
				});
			});
			
			return combinations;
		}
		
		// Sample data
	 
		
		// Generate combinations and mark first occurrences
		let combinationsWithFirstMarked = generateCombinationsMarkFirst(jsonData);
		console.log('combinationsWithFirstMarked', combinationsWithFirstMarked)

		function mergeDuplicateRows() { 
				var table = document.querySelector('.appcaptable');
				var rows = table.rows;
				var i, j, currentCell, nextCell, rowspan;
		 
				// Iterate through each cell except for the first row (headers)
				for (i = 0; i &lt; rows.length - 1; i++) {
					for (j = 0; j &lt; rows[i].cells.length; j++) {
						rowspan = 1;
						currentCell = rows[i].cells[j];
						
						// Iterate downwards from the current cell
						for (var k = i + 1; k &lt; rows.length; k++) {
							nextCell = rows[k].cells[j];
			
							// Check if the cell below has the same content
							if (currentCell.innerHTML === nextCell.innerHTML) {
								rowspan++;
								nextCell.style.display = 'none'; // Hide the current cell
							} else {
								break; // Stop if the next cell is different
							}
						}
			
						// Set the rowspan for the current cell
						if (rowspan > 1) {
							currentCell.rowSpan = rowspan;
						}
					}
				}
			}
			
			console.log('combinationsWithFirstMarked2', combinationsWithFirstMarked)
		$('#newtable').html(tableTemplate(combinationsWithFirstMarked)).promise().done(function() {
			mergeDuplicateRows();
		});

		
}

})
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
</xsl:stylesheet>
