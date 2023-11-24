<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
    <xsl:include href="../common/core_footer.xsl"/>
    <xsl:include href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/> 
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

    <xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
    <xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
    <xsl:variable name="appProcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>

	<!-- START GENERIC PARAMETERS -->
    <xsl:param name="viewScopeTermIds"/>
	<xsl:variable name="elementStyle"  select="/knowledge_base/simple_instance[type='Element_Style']"></xsl:variable>
	<xsl:variable name="labels"  select="/knowledge_base/simple_instance[type=('Label','Commentary')]"></xsl:variable>

	<xsl:key name="labelsKey" match="/knowledge_base/simple_instance[type=('Label','Commentary')]" use="name"/>

 	<xsl:key name="apps" match="/knowledge_base/simple_instance[supertype='Application_Provider']" use="own_slot_value[slot_reference='performance_measures']/value"></xsl:key>
 	<xsl:key name="sqvs" match="/knowledge_base/simple_instance[supertype='Service_Quality_Value']" use="name"></xsl:key>
	<xsl:key name="sqs" match="/knowledge_base/simple_instance[supertype='Service_Quality']" use="name"></xsl:key>
	<xsl:key name="sqvlsbysq" match="/knowledge_base/simple_instance[supertype='Service_Quality_Value']" use="own_slot_value[slot_reference='usage_of_service_quality']/value"></xsl:key> 
    <xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
    <xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Value_Stream','Composite_Application_Provider','Group_Actor')"/>
	<xsl:variable name="valueStream"  select="/knowledge_base/simple_instance[type='Value_Stream']"></xsl:variable>
	<xsl:key name="vsphase" match="/knowledge_base/simple_instance[type='Value_Stage']" use="own_slot_value[slot_reference='vsg_value_stream']/value"></xsl:key>
	<xsl:variable name="roles" select="/knowledge_base/simple_instance[type=('Business_Role','Business_Role_Type')]"/>
	<xsl:key name="rolesKey" match="/knowledge_base/simple_instance[type=('Business_Role','Business_Role_Type')]" use="name"/>
	<xsl:key name="product" match="/knowledge_base/simple_instance[type=('Product_Type','Composite_Product_Type')]" use="name"></xsl:key>
    <xsl:template match="knowledge_base">
        	<xsl:call-template name="docType"/> 
			<xsl:variable name="apiBCM">
				<xsl:call-template name="GetViewerAPIPathTemplate">
					<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="apiApps">
				<xsl:call-template name="GetViewerAPIPathTemplate">
					<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="apiAppProc">
				<xsl:call-template name="GetViewerAPIPathTemplate">
					<xsl:with-param name="apiReport" select="$appProcData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>       
        <html>
            <head>
            	<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderEditorInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Value Stream Application Mapping</title>
				<style>
				.ess-vs-row {
					display: flex;
					<!--justify-content: space-between;-->
				}
				
				.ess-vs-header {
					padding: 2px;
					background-color: #477c98;
					border: 1px solid #d3d3d3;
					color: #ffffff;
					<!--flex-grow: 1;-->
					text-align: center;
				}
				
				.vs {
					padding: 2px;
					background-color: #82bedf;
					border: 1px solid #d3d3d3;
					color: #ffffff; 
				
				}
				
				.ess-vs-column {
					padding: 3px;
					background-color: #ffffff;
					border: 1px solid #d6d6d6;
					<!--flex-grow: 1;-->
				}

				.ess-vs-column-desc {
					border: 1pt solid #d3d3d3;
					color: #000000;
					border-radius: 6px;
					padding:3px;
					margin-bottom:2px;
					<!--flex-grow: 1;-->
				}

				 
				.vsd {
					border: 1pt solid #d3d3d3;
					color: #000000;
					border-radius: 6px;
					padding: 3px;
					font-size: 0.9em;
					flex-grow: 1;
					margin: 2px;
				}
				
				.ess-vs-first-column {
					width: 37px;
					border: 0;
					flex: none;
				}
				
				.appvs {
					height: 60px;
					width: 100px;
					border: 1pt solid #d3d3d3;
					padding: 3px;
					display: flex;
					margin: 2px;
					border-radius: 6px;
					position: relative;
					align-items: center; /* Center vertically */
					justify-content: center;
					box-shadow: 1px 1px 2px rgba(0,0,0,0.25);
					transition: all 0.5s ease;
					text-align: center;
					background-color: #fcfcfc;
				}
				.appvs.expanded {
					width: 100%;
					max-width: 160px;
					height: 146px;
				}
				
				/*	
				.logo{
							text-align:center;
						}	
				.appName{
							position:absolute;
							text-align:center;
							bottom:3px;
							width: 100%;
					}
				*/
				.smallCard {
					display: flex;
					align-items: center;
					padding: 2px;
					border-radius: 5px;
					width: 90;
				}
				
				.logo {
					margin-right: 10px;
					position: absolute;
					bottom: 2pt;
					right: 2pt;
				}
				
				.appName {
					text-align: center;
					word-wrap: break-word;
					overflow-wrap: break-word;
					font-size: 12px;
					line-height: 1.1em;
				}
				
				.chevron-container:first-child:after {
				
					width: 0;
					height: 0;
					border-left: 15px solid transparent;
					border-right: 15px solid #f00; /* Replace #f00 with the background color you desire */
					border-top: 15px solid transparent;
					border-bottom: 15px solid transparent;
					border: 5px solid #fff; /* White border */
					margin: 0px 20px 0 0px;
				}
				.chevron-right-small {
					width: 30px;
					height: 32px;
					background: #49c2b5;
					clip-path: polygon(0% 0%, 95% 0%, 100% 50%, 95% 100%, 0% 100%, 5% 50%);
					display: inline-block;
					margin-bottom: 2pt;
					z-index: 1;
					padding: 2px;
					padding-left: 28px;
					padding-right: 15px;
					vertical-align: top;
				}
				.vstext {
					position: relative;
					top: 0px
				}
				.ess-flat-card-wrapper {
					display: flex;
					flex-direction: row;
					flex-wrap: wrap;
					gap: 15px;
				}
				.ess-flat-card {
					border: 0px solid #33333318;
					width: 100%;
					text-align: center;
				}
				.ess-flat-card-title {
					padding: 2px;
					font-size: 0.8em;
					position: absolute;
					top: 5px;
				}
				.ess-flat-card-body {
					padding: 2px;
				}
				.ess-flat-card-footer {
					padding: 2px;
				
				}
				.ess-flat-card-title > span {
					font-weight: 100;
					font-size: 85%;
				}
				
				.ess-flat-card-title > div {
					font-weight: 400;
					font-size: 90%;
					color: #666;
				}
				.ess-flat-card-widget-wrapper {
					display: flex;
					flex-direction: row;
					flex-wrap: wrap;
					gap: 2;
					justify-content: center;
					align-items: top;
				}
				
				.ess-flat-card-widget > i {
					font-size: 8pt;
					padding-right: 2px;
				}
				
				.ess-flat-card-widget > div {
					font-weight: 700;
					font-size: 80%;
				}
				.ess-flat-card-widget > i.text-muted {
					color: #ccc;
				}
				.ess-flat-card-widget-badge {
					padding: 2px 4px;
				
				}
				.fa-info-circle {
					cursor: pointer;
				}
				.wording {
					font-size: 6pt !important;
					line-height: 1.2;
				}
				.pad {
					padding: 2pt;
				}
				.row2 {
					display: inline-block;
				}
				.enumVals {
					font-size: 8pt;
					display: inline-block;
					width: 60%;
					text-align: left;
					vertical-align: top;
				}
				.enumText {
					font-size: 8pt;
					display: inline-block;
					width: 40%;
					vertical-align: top;
				}
				.eas-logo-spinner {
					display: flex; 
					justify-content: center; 
				}
				#editor-spinner {
					height: 100vh; 
					width: 100vw; 
					position: fixed; 
					top: 0; 
					left:0; 
					z-index:999999; 
					background-color: hsla(255,100%,100%,0.75); 
					text-align: center; 
				}
				#editor-spinner-text{
					width: 100vw; 
					z-index:999999; 
					text-align: center; 
					}
				.spin-text {
					font-weight: 700; 
					animation-duration: 1.5s; 
					animation-iteration-count: infinite; 
					animation-name: logo-spinner-text; 
					color: #aaa; 
					float: left; 
				}
				.spin-text2 {
					font-weight: 700; 
					animation-duration: 1.5s; 
					animation-iteration-count: infinite; 
					animation-name: logo-spinner-text2; 
					color: #666; 
					float: left; 
				}
				</style>
			</head>
			<body>
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				<div class="container-fluid">
					<div class="clearfix top-30"/>
					<div class="text-primary xlarge strong top-10"><xsl:value-of select="eas:i18n('Value Stream Application Mapping')"/></div>
					<div>
						<select id="vs"/>
						<button class="btn btn-default btn-sm left-15" id="expandButton"><xsl:value-of select="eas:i18n('Show Detail')"/></button>
						<button  class="btn btn-default btn-sm left-5" id="shrinkButton"><xsl:value-of select="eas:i18n('Hide Detail')"/></button>
					</div>
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
					<div class="top-10" id="tabcontainer"/>
			
					<script id="columnSet-template" type="text/x-handlebars-template">
						<div class="bottom-5">
							<b><xsl:value-of select="eas:i18n('Name')"/>:</b> {{#essRenderInstanceReportLink this.vs}}{{/essRenderInstanceReportLink}}
						</div>
						<div class="bottom-5">
							<b><xsl:value-of select="eas:i18n('Description')"/>:</b> {{this.vs.description}}
						</div>
						<div class="bottom-5"><b><xsl:value-of select="eas:i18n('Products')"/>:</b> {{#each this.vs.products}}
							<span class="label label-primary right-5">{{this.name}}</span>{{/each}}
						</div>
						<div class="bottom-5">
							<b><xsl:value-of select="eas:i18n('Capabilities')"/>:</b> 
							{{#each this.vs.buscaps}}
								<span class="label label-info right-5">{{this.name}}</span>
							{{/each}}
						</div>
						{{msg}}
						<div class="ess-vs-row top-15">
							<div class="ess-vs-column ess-vs-first-column"></div>
							{{#each this.vsps}}
								<div class="ess-vs-header"><xsl:attribute name="style">flex-basis: {{../colWidth}}px;</xsl:attribute>{{participants}}</div>
							{{/each}}
						</div>
						<div class="ess-vs-row">
							<div class="ess-vs-column ess-vs-first-column"></div>
							{{#each this.vsps}}
								<div class="vs  chevron-right-small"><xsl:attribute name="style">flex-basis: {{../colWidth}}px;</xsl:attribute><span class="vstext">{{label}}</span></div>
							{{/each}}
						</div>
						<div class="ess-vs-row">
							<div class="ess-vs-column ess-vs-first-column" ></div>
							{{#each this.vsps}}
							<div class="ess-vs-column-desc "><xsl:attribute name="style">flex-basis: {{../colWidth}}px;</xsl:attribute><span class="vstext">{{this.description}}</span></div>
							{{/each}}
						</div>
						<div class="holder" style="overflow-y: auto;height: 95vh">
							{{#each item}}	
								<div class="ess-vs-row">
									<div class="ess-vs-column">
										<xsl:attribute name="style">
											padding-right:10px;
											flex-basis: 20px;
											writing-mode: vertical-lr;
											text-align:center;
											transform: rotate(-180deg);
											font-size: 16px;
											font-weight: bold;
										</xsl:attribute>
										{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}}
									</div>
										{{#each this.vsps}}	 
											<div class="ess-vs-column ">
												<xsl:attribute name="style">display:flex; flex-wrap: wrap; gap: 5px; padding-right:10px;flex-basis: {{../width}}px;</xsl:attribute>
												{{#each this.apps}}
													<div class="appvs">
														<xsl:attribute name="style">border: 1px solid {{colour}}</xsl:attribute>
						 								<div class="smallCard">
														 <div class="appName">
															{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}}
														 </div>
													</div>
													<div class="bigCard" style="display:none">
														<div class="ess-flat-card">
															<div class="ess-flat-card-title"> 
																{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}} 
																<!--		<i class="fa fa-info-circle popover-trigger'"></i>
																		<div class="popover">
																			<h4 class="strong">{{this.name}}</h4>
																			<p class="small text-muted">{{this.description}}</p>
																		</div>
																	-->
															</div>
														<div class="ess-flat-card-body"> 
															<div class="ess-flat-card-widget-wrapper">		
														<div>
													</div>
												</div>
												{{#if time}}
												<div class="enumText"><xsl:value-of select="eas:i18n('Disposition')"/>:</div>
												<div class="enumVals">
													<i>
														<xsl:attribute name="class">fa {{time.icon}}</xsl:attribute>
														<xsl:attribute name="style">color:{{time.backgroundColor}}</xsl:attribute>
													</i>
													{{time.name}}
												</div>
												{{/if}}
												{{#if appDel}}
												<div class="enumText"><xsl:value-of select="eas:i18n('Delivery')"/>:</div>
												<div class="enumVals">
													<i>
														<xsl:attribute name="class">fa {{appDel.icon}}</xsl:attribute>
														<xsl:attribute name="style">color:{{appDel.backgroundColor}}</xsl:attribute>
													</i>
													{{appDel.name}}</div>
												{{/if}}
												{{#if codebase}}
												<div class="enumText"><xsl:value-of select="eas:i18n('Codebase')"/>:</div>
												<div class="enumVals">
													<i>
														<xsl:attribute name="class">fa {{codebase.icon}}</xsl:attribute>
														<xsl:attribute name="style">color:{{codebase.backgroundColor}}</xsl:attribute>
													</i>
													{{codebase.name}}
												</div>
												{{/if}}
												{{#if life}}
												<div class="enumText"><xsl:value-of select="eas:i18n('Lifecycle')"/>:</div>
												<div class="enumVals">
													<i>
														<xsl:attribute name="class">fa {{life.icon}}</xsl:attribute>
														<xsl:attribute name="style">color:{{life.backgroundColor}}</xsl:attribute>
													</i>
													{{life.name}}
												</div>
												{{/if}}
											</div>	
										</div>			
									</div>					 
								</div>	
							{{/each}}
							</div>
						{{/each}}
						</div>
						{{/each}}
					</div>
					</script>
			    	<script>
			
			        // Compile the Handlebars template
					<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
														
					function showEditorSpinner(message){
						$('#editor-spinner-text').text(message);                             
						$('#editor-spinner').removeClass('hidden');                          
					};
					 
					function removeEditorSpinner(){
						$('#editor-spinner').addClass('hidden'); 
						$('#editor-spinner-text').text(''); 
					};
					showEditorSpinner('Fetching Data');
			        // Render the template with the data and append to the row-container div
						$(document).ready(function(){
								window.addEventListener('load', (event) => {
									// After page is loaded, add click event to the expandButton
									document.getElementById('expandButton').addEventListener('click', function() {
										 
										$('.appvs').addClass('expanded')
										 
										$('.smallCard').fadeOut('slow', function() {
											// Show big card, fade in, and add rotation animation
											$('.bigCard').fadeIn('slow', function() {
											 
											});
										});
									});
									document.getElementById('shrinkButton').addEventListener('click', function() {
										$('.appvs').removeClass('expanded')
										$('.bigCard').fadeOut('fast', function() { 
											$('.smallCard').fadeIn('slow', function() {
											 
											});
										});
									});
								})
							})
							
			 	</script>
				</div>
           	<xsl:call-template name="Footer"/> 
            </body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param>
					<xsl:with-param name="viewerAPIPathAppsProcs" select="$apiAppProc"></xsl:with-param>  
                </xsl:call-template>
            </script>    
        </html>
	</xsl:template>
	
	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathAppsProcs"></xsl:param>
	
		<!-- var allDisposition=[<xsl:apply-templates select="$allDisposition" mode="allDisposition"/>]; -->
	
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataAppsProcs = '<xsl:value-of select="$viewerAPIPathAppsProcs"/>';
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
		let selectedId='<xsl:value-of select="$param1"/>'
		let vs=[<xsl:apply-templates select="$valueStream" mode="vs"/>];
	let style=[<xsl:apply-templates select="$elementStyle" mode="elementStyle"/>]
	
		var apps;
		var vstemplate, filters; 

		function getSlot(sltnm, id){
			let slot=filters.find((e)=>{
				return e.slotName==sltnm
			})
		
			let res=slot?.values.find((r)=>{
				return r.id==id;
			})
			if(res){
			 
				const idExists = style.some(s => s.ids.includes(id));
			 
				if (idExists) {
				res['icon']=idExists.icon || 'fa-circle';
				} else{
					res['icon']='fa-circle';
					res['backgroundColor']='#d3d3d3';
				}
			}

			return res || "";
		}

		function setAppAttributes(app, getSlot) {
			app['appDel'] = getSlot('ap_delivery_model', app.ap_delivery_model[0]);
			app['time'] = getSlot('ap_disposition_lifecycle_status', app.ap_disposition_lifecycle_status[0]);
			app['codebase'] = getSlot('ap_codebase_status', app.ap_codebase_status[0]);
			app['life'] = getSlot('lifecycle_status_application_provider', app.lifecycle_status_application_provider[0]);
		  }

		$('document').ready(function ()
	{
		    var source = document.getElementById("columnSet-template").innerHTML;
	        var template = Handlebars.compile(source);
			
				Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
					return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
				});
	
				Handlebars.registerHelper('getIcons', function (arg1, icontype) {
					let data='';
					if(arg1){
					for(i=0;i&lt;arg1.sequence;i++){
						data=data+'<i class="fa fa-'+icontype+'"></i>'
					}
	
					return data
					}
				});
	
		var source = document.getElementById("columnSet-template").innerHTML;
		 vstemplate = Handlebars.compile(source);
		
	
	Promise.all([
	    promise_loadViewerAPIData(viewAPIData),
	    promise_loadViewerAPIData(viewAPIDataApps),
	    promise_loadViewerAPIData(viewAPIDataAppsProcs) 
	    ]).then(function (responses)
	    {
			removeEditorSpinner()
			caps=responses[0].busCaptoAppDetails;
			apps=responses[1].applications;

			filters=responses[1].filters;
			dynamicAppFilterDefs=filters?.map(function(filterdef){
				return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
			});
		 
	vs=vs.sort((a, b) => a.name &lt; b.name ? -1 : (a.name > b.name ? 1 : 0));
 	
	vs.forEach((v)=>{
		$('#vs').append('&lt;option value="'+v.id+'">'+v.name+'&lt;/option>')
	})
	$('#vs').select2({
		placeholder: 'Select...'
	});
	$('#vs').val(selectedId).change();
			
			const addvsorgsProperty = (array) => apps.map(item => ({ ...item, vsorgs: [] }));
	
			// Call the function with the originalArray
			 apps = addvsorgsProperty(apps);
			 
	const capMap = new Map(caps.map(f => [f.id, f]));
	const styleMap = new Map(style.map(s => [s.ids[0], s])); 
	const busProcessToAppMap = new Map();

		responses[2].process_to_apps.forEach(e => {
		if (busProcessToAppMap.has(e.processid)) {
			busProcessToAppMap.get(e.processid).push(e);
		} else {
			busProcessToAppMap.set(e.processid, [e]);
		}
		});
 
	const processToAppMap = new Map(responses[2].process_to_apps.map(e => [e.id, e]));

	function addVsOrgs(match, procOrg) { 
		match.vsorgs = match.vsorgs || [];
		match.vsorgs.push({ "id": procOrg.orgid, "name": procOrg.org });
	  }
	  
	  // Create a mapping for quick look-up
	 
	  const appsMap = new Map(apps.map(app => {
		return [app.id, { ...app, vsorgs: [] }];
	  }));
	 
	  vs.forEach(d => {
		let thisVsOrgs=[];
 
		let vsBusCaps = [];
		
		d.vsps.forEach(e => {
		  const mappedApps = new Map();
		
		  e.busProcs.forEach(p => {
	 
			const procOrg = busProcessToAppMap.get(p);
		 
			if (procOrg) {
				procOrg.forEach((or)=>{
					thisVsOrgs.push({ "id": or.orgid, "name": or.org })
					or.appsdirect?.forEach(a => {
						const match = appsMap.get(a.id);
				 
						if (match) {
							match.vsorgs.push({ "id": or.orgid, "name": or.org });
						//addVsOrgs(match, procOrg);
						mappedApps.set(match.id, match);
						}
					});
		
					or.appsviaservice?.forEach(a => {
						const match = appsMap.get(a.appid);
					 
						if (match) {
							match.vsorgs.push({ "id": or.orgid, "name": or.org });
						//addVsOrgs(match, procOrg);
						mappedApps.set(match.id, match);
						}
					});
				})
			}
		  });
		
		 if(e.busProcs.length==0){
		  e.busCaps.forEach(c => {
			const capMatch = capMap.get(c);
			
			if (capMatch &amp;&amp; capMatch.physP) {
			  vsBusCaps.push(capMatch); 
			  capMatch.physP.forEach(process => {
			 
				thisVsOrgs.push({ "id": process.orgid, "name": process.org })
				apps.forEach(app => {
					
				  if (app.physP.includes(process)) {
					
					const procOrg = processToAppMap.get(process);

					//setAppAttributes(app, getSlot);
		
					if (procOrg) {
					  
							app.vsorgs.push({ "id": procOrg.orgid, "name": procOrg.org });
				 
					 // addVsOrgs(app, procOrg);
					  mappedApps.set(app.id, app);
					}
				  }
				});
			  });
			}
		  });

		}

		
		  e['apps'] = Array.from(mappedApps.values());
		});
		
		vsBusCaps = [...new Map(vsBusCaps.map(item => [item.id, item])).values()];

		d['buscaps'] = vsBusCaps;
		d['inScopeOrgs']=thisVsOrgs;
	  });
	  
	
	
			essInitViewScoping(redrawView,['Group_Actor', 'Geographic_Region', 'ACTOR_TO_ROLE_RELATION','SYS_CONTENT_APPROVAL_STATUS','Product_Concept', 'Business_Domain'], filters, true);
			
		    $('.popover-trigger').popover({
	            container: 'body',
	            animation: true,
	            html: true,
	            trigger: 'focus',
	            placement: 'auto',
	            content: function(){
	   
	                return $(this).next().html();
	            }
	        }); 
		})
	})
	
	var appTypeInfo = {
		"className": "Application_Provider",
		"label": 'Application',
		"icon": 'fa-desktop'
	}
	
	var redrawView=function(){
	  
	 
		appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
		geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
		visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
		
		scopedapps = essScopeResources(apps, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), appTypeInfo);
	 
		let selected =vs.find((e)=>{
			return e.id==selectedId;
		});
		if(selected){}else{selected=vs[0]}
		  
		const data = selected
	 let orgInfo=[];
		  function groupAppsByOrgAndvsP(data) {
			const result = {};
			const vspNames = data.vsps.map(vsp => vsp.name);
			 
			let inScopeOrgs=data.inScopeOrgs;
			data.vsps.forEach(vsp => {
			  vsp.apps?.forEach(app => {
				app.vsorgs.forEach(org => {
					
					if (inScopeOrgs.some(inScopeOrg => inScopeOrg.id === org.id)) {
						orgInfo.push({"id": org.id, "name": org.name});
					}
					
				 
				  const orgName = org.id;
				  const vspName = vsp.name; 	
			 
				  // Preprocess scopedapps.resources into a Map for O(1) lookups
				  const scopedAppsMap = new Map();
				  scopedapps.resources.forEach(obj => {
					scopedAppsMap.set(obj.id, obj);
				  });
				  
				  // Prepare a template for result[orgName]
				  const emptyOrgTemplate = {};
				  vspNames.forEach(name => {
					emptyOrgTemplate[name] = [];
				  });
				  
				  data.vsps.forEach(vsp => {
					const vspName = vsp.name;
					
					vsp.apps?.forEach(app => {
					  app.vsorgs.forEach(org => {
						const orgName = org.id;
				  
						// Initialize using a pre-created empty template
						if (!result[orgName]) {
						  result[orgName] = JSON.parse(JSON.stringify(emptyOrgTemplate));
						}
				  
						// Use the pre-created Map for faster lookup
						if (scopedAppsMap.has(app.id)) {
						  result[orgName][vspName].push(app);
						}
					  });
					});
				  });
				  
				});
			  });
			
			});
		  
			return result;
		  }
	
		  const groupedApps = groupAppsByOrgAndvsP(data);
		  const transformedData = Object.keys(groupedApps).map(orgName => {
		  const vsps = Object.keys(groupedApps[orgName]).map(vspName => {
				 
			  return {
				vspName, 
				apps: groupedApps[orgName][vspName],
			  };
			});
		 
			return {
			  orgName, 
			  vsps,
			};
		  });
	 
		  transformedData.forEach((f)=>{
			f.vsps.forEach((l)=>{
		    	l.apps = [...new Map(l.apps.map(item => [item.id, item])).values()];
				
				l.apps.forEach((a)=>{
					setAppAttributes(a, getSlot);
				})
			})
		  })
		  	let dataSet={}
		  if(transformedData.length&gt;0){
		  let vspLength = transformedData[0].vsps.length;
		  var viewportWidth = window.innerWidth-40;;
		  let vspWidth=Math.floor(viewportWidth/vspLength)-20;
		  let vspWidth2=Math.floor(95/vspLength)
		   
		  dataSet["item"]=[];
		  dataSet['vsps']=selected.vsps;
		  dataSet['colWidth']=vspWidth;
		  
		  // Create a map from orgInfo for O(1) lookups
		  const orgInfoMap = new Map(orgInfo.map(e => [e.id, e]));
		  
		  // Loop through transformedData
		  transformedData.forEach((f, i) => {
			const orgi = orgInfoMap.get(f.orgName);
			
			if (orgi) { // make sure orgi is defined
			  f['name'] = orgi.name;
			  f['className'] = 'Group_Actor';
			  f.id = orgi.id;
			  f['width'] = vspWidth;
		  
			  dataSet.item.push(f);
			}
		  });
		  
		  }else{
		
			dataSet['msg']='Either no physical processes are mapped or they have no applications mapped';
		  }
		  dataSet['vs']=selected;

		  let allCaps=dataSet.vs.buscaps
		
		  vsBusCaps = [...new Map(allCaps.map(item => [item.id, item])).values()];

		  dataSet.vs.busCaps=vsBusCaps;
		 
		  $('#tabcontainer').html(vstemplate(dataSet)); 
	 
		  $('#vs').off().on('change', function(){
			selectedId=$(this).val()
			redrawView();
		  })
		}
	
		</xsl:template>
	
<xsl:template match="node()" mode="vs">
	<xsl:variable name="vsp" select="key('vsphase',current()/name)"/>
	<xsl:variable name="prod" select="key('product',current()/own_slot_value[slot_reference='vs_product_types']/value)"/>
	{
		"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"className":"<xsl:value-of select="current()/type"/>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"products":[<xsl:apply-templates select="$prod" mode="vsp"/>], 
		"vsps":[<xsl:apply-templates select="$vsp" mode="vsp"/>]
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="vsp">
<!--	
	<xsl:variable name="lbl" select="$labels[name=current()/own_slot_value[slot_reference='vsg_label']/value]"/>
	<xsl:variable name="thisRoles" select="$roles[name=current()/own_slot_value[slot_reference='vsg_participants']/value]"/>-->
	<xsl:variable name="lbl" select="key('labelsKey',current()/own_slot_value[slot_reference='vsg_label']/value)"/>
	<xsl:variable name="thisRoles" select="key('rolesKey', current()/own_slot_value[slot_reference='vsg_participants']/value)"/>
	{
		"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"participants":[<xsl:for-each select="$thisRoles">"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"label":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$lbl"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template>",
		"busCaps":[<xsl:for-each select="current()/own_slot_value[slot_reference='vsg_required_business_capabilities']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"busProcs":[<xsl:for-each select="current()/own_slot_value[slot_reference='vs_supporting_bus_processes']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="elementStyle">
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"ids":[<xsl:for-each select="current()/own_slot_value[slot_reference='style_for_elements']/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
		"icon":"<xsl:value-of select="current()/own_slot_value[slot_reference='element_style_icon']/value"/>",
		"backgroundColour":"<xsl:value-of select="current()/own_slot_value[slot_reference='element_style_colour']/value"/>",
		"colour":"<xsl:value-of select="current()/own_slot_value[slot_reference='element_style_text_colour']/value"/>"
	}<xsl:if test="position()!=last()">,</xsl:if>
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