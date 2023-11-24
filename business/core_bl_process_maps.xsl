<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
    <xsl:include href="../common/core_footer.xsl"/>
    <xsl:include href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/> 
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

    <xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
    <xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
    <xsl:variable name="appProcData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>

	<!-- START GENERIC PARAMETERS -->
    <xsl:param name="viewScopeTermIds"/>
	<xsl:variable name="elementStyle"  select="/knowledge_base/simple_instance[type='Element_Style']"></xsl:variable>
	<xsl:key name="businessCapability" match="/knowledge_base/simple_instance[type='Business_Capability']" use="own_slot_value[slot_reference='realised_by_business_processes']/value"/>
	<xsl:key name="businessProcesses" match="/knowledge_base/simple_instance[type='Business_Process']" use="name"/>
	<xsl:variable name="bp" select="/knowledge_base/simple_instance[type='Business_Process']"/>
	<xsl:variable name="topBusinessProcesses" select="$bp[not(name=$bp/own_slot_value[slot_reference='bp_sub_business_processes']/value)][count(own_slot_value[slot_reference='bp_sub_business_processes']/value)&gt;0]"/>

	<xsl:variable name="labels"  select="/knowledge_base/simple_instance[type=('Label','Commentary')]"></xsl:variable>
    <xsl:variable name="PMC"  select="/node()/simple_instance[type='Performance_Measure_Category'][own_slot_value[slot_reference='name']/value='RMIT Health']"></xsl:variable>
    <xsl:key name="PMCPerformance" match="/node()/simple_instance[supertype='Performance_Measure']" use="own_slot_value[slot_reference='pm_category']/value"></xsl:key>
 	<xsl:key name="apps" match="/node()/simple_instance[supertype='Application_Provider']" use="own_slot_value[slot_reference='performance_measures']/value"></xsl:key>
 	<xsl:key name="sqvs" match="/node()/simple_instance[supertype='Service_Quality_Value']" use="name"></xsl:key>
	<xsl:key name="sqs" match="/node()/simple_instance[supertype='Service_Quality']" use="name"></xsl:key>
	<xsl:key name="sqvlsbysq" match="/node()/simple_instance[supertype='Service_Quality_Value']" use="own_slot_value[slot_reference='usage_of_service_quality']/value"></xsl:key> 
	<xsl:variable name="custJourney"  select="/node()/simple_instance[type='Value_Stream']"></xsl:variable>
	<xsl:key name="vsphase" match="/node()/simple_instance[type='Value_Stage']" use="own_slot_value[slot_reference='vsg_value_stream']/value"></xsl:key>
	<xsl:variable name="roles" select="/node()/simple_instance[type=('Business_Role','Business_Role_Type')]"/>
	<xsl:key name="product" match="/node()/simple_instance[type='Product']" use="name"></xsl:key>
		<xsl:variable name="maxDepth" select="10"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
    <xsl:variable name="linkClasses" select="('Business_Capability', 'Business_Process', 'Application_Provider','Composite_Application_Provider')"/>
	  <xsl:template match="knowledge_base">
        	<xsl:call-template name="docType"/> 
			<xsl:variable name="apiBCM">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="apiApps">
				<xsl:call-template name="GetViewerAPIPath">
					<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="apiAppProc">
				<xsl:call-template name="GetViewerAPIPath">
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
	<title>Business Hierarchy Application Mapping</title>
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
		height: 52px;
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
<span class="text-primary" style="font-size: 24px;font-weight:400;padding-left:20px"><xsl:value-of select="eas:i18n('Business Process Application Mapping')"/></span>: <select id="vs"/>
<button class="btn btn-default btn-sm" id="expandButton"><xsl:value-of select="eas:i18n('Show Detail')"/></button>
<button  class="btn btn-default btn-sm" id="shrinkButton"><xsl:value-of select="eas:i18n('Hide Detail')"/></button>
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
 <div class="tabpage" id="tabcontainer"/>

 <script id="columnSet-template" type="text/x-handlebars-template">
	<div class="bottom-5">
		<b><xsl:value-of select="eas:i18n('Name')"/>:</b> {{#essRenderInstanceReportLink this.proc}}{{/essRenderInstanceReportLink}}
	</div>
	<div class="bottom-5">
		<b><xsl:value-of select="eas:i18n('Capabilities')"/>:</b> 
		{{#each this.proc.capsSupporting}}
			<span class="label label-info right-5" style="background-color: #e7e7e7">{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}}</span>
		{{/each}}
	</div>
	{{msg}}

	<div class="ess-vs-row">
		<div class="ess-vs-column ess-vs-first-column"></div>
		{{#each this.sps}}
			<div class="vs  chevron-right-small"><xsl:attribute name="style">flex-basis: {{../colWidth}}px;</xsl:attribute><span class="vstext">{{this}}</span></div>
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
					{{this.orgName}}
				</div>
					{{#each this.sps}}	 
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
											<div class="ess-flat-card-widget-wrapper"><div>
										</div>
									</div>
											{{#if time.name}}
											<div class="enumText"><xsl:value-of select="eas:i18n('Disposition')"/>:</div>
											<div class="enumVals">
											<i>
												<xsl:attribute name="class">fa {{time.icon}}</xsl:attribute>
												<xsl:attribute name="style">color:{{time.backgroundColor}}</xsl:attribute>
											</i>
											{{time.name}}
											</div>
											{{/if}}
											{{#if appDel.name}}
											<div class="enumText"><xsl:value-of select="eas:i18n('Delivery')"/>:</div>
											<div class="enumVals">
											<i>
												<xsl:attribute name="class">fa {{appDel.icon}}</xsl:attribute>
												<xsl:attribute name="style">color:{{appDel.backgroundColor}}</xsl:attribute>
											</i>
												{{appDel.name}}
											</div>
											{{/if}}
											{{#if codebase.name}}
											<div class="enumText"><xsl:value-of select="eas:i18n('Codebase')"/>:</div>
											<div class="enumVals">
											<i>
												<xsl:attribute name="class">fa {{codebase.icon}}</xsl:attribute>
												<xsl:attribute name="style">color:{{codebase.backgroundColor}}</xsl:attribute>
											</i>
											{{codebase.name}}
											</div>
											{{/if}}
											{{#if life.name}}
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

											

			
        // Render the template with the data and append to the row-container div
			$(document).ready(function(){
			
window.addEventListener('load', (event) => {
	// After page is loaded, add click event to the expandButton
	document.getElementById('expandButton').addEventListener('click', function() {
		// Iterate over all .app divs
		var appDivs = document.querySelectorAll('.appvs');
		appDivs.forEach(function(div) {
			// Add a class to expand the div
			div.classList.add('expanded');
		});
		$('.smallCard').fadeOut('slow', function() {
			// Show big card, fade in, and add rotation animation
			$('.bigCard').fadeIn('slow', function() {
			 
			});
		});
	});
	document.getElementById('shrinkButton').addEventListener('click', function() {
		// Iterate over all .app divs
		var appDivs = document.querySelectorAll('.appvs');
		appDivs.forEach(function(div) {
			// Add a class to expand the div
			div.classList.remove('expanded');
		});
		$('.bigCard').fadeOut('fast', function() {
			// Show big card, fade in, and add rotation animation
			$('.smallCard').fadeIn('slow', function() {
			 
			});
		});
	});
})
				})
<!--
		appDivs.forEach(function(div) {
			div.classList.toggle('expanded');
		});
-->


 </script>
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
	<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
	<!-- var allDisposition=[<xsl:apply-templates select="$allDisposition" mode="allDisposition"/>]; -->
	function showEditorSpinner(message){
		$('#editor-spinner-text').text(message);                             
		$('#editor-spinner').removeClass('hidden');                          
	};
	 
	function removeEditorSpinner(){
		$('#editor-spinner').addClass('hidden'); 
		$('#editor-spinner-text').text(''); 
	};
	showEditorSpinner('Fetching Data');


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
<!--	let vs=[<xsl:apply-templates select="$custJourney" mode="vs"/>]; -->
	let style=[<xsl:apply-templates select="$elementStyle" mode="elementStyle"/>]
 	let model=[<xsl:apply-templates select="$topBusinessProcesses" mode="model"/>]
 


function collectPhysicalProcesses(objs) {
 
  var physicalProcesses = [];

  function findPhysicalProcesses(obj) {
    if (obj.hasOwnProperty('physicalProcesses')) {
      physicalProcesses = physicalProcesses.concat(obj.physicalProcesses);
    }
    if (obj.hasOwnProperty('subProcess')) {
      obj.subProcess.forEach(findPhysicalProcesses);
    }
  }

  findPhysicalProcesses(objs);

  return physicalProcesses;
}
 
 model.forEach((d)=>{
	d.subProcess.forEach((e)=>{
	var allPhysicalProcesses = collectPhysicalProcesses(e);
	e['physp']=allPhysicalProcesses;

	}) 
	 
 })
 


	var apps;
	var vstemplate 
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
		let filters=responses[1].filters;
		dynamicAppFilterDefs=filters?.map(function(filterdef){
			return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
		});
		
		model=model.sort((a, b) => a.name &lt; b.name ? -1 : (a.name > b.name ? 1 : 0));

model.forEach((v)=>{
	$('#vs').append('&lt;option value="'+v.id+'">'+v.name+'&lt;/option>')
})
$('#vs').select2();
$('#vs').val(selectedId).change();
		function getSlot(sltnm, id){
			let slot=filters.find((e)=>{
				return e.slotName==sltnm
			})
	
			let res=slot?.values.find((r)=>{
				return r.id==id;
			})
			
			const idExists = style.some(s => s.ids.includes(id));
			
			if (idExists) {
				if (idExists.icon) {
					if(idExists.icon!=='' ){
						res['icon']=idExists.icon || 'fa-circle';
					}else{
						res['icon']= 'fa-circle';
					}
				}else{
					if(res){
						res['icon']= 'fa-circle';
					}
				}
			} 
			

			return res || "";
		}
		const addvsorgsProperty = (array) => apps.map(item => ({ ...item, vsorgs: [] }));

		// Call the function with the originalArray
		 apps = addvsorgsProperty(apps);
		 
const capMap = new Map(caps.map(f => [f.id, f]));
const styleMap = new Map(style.map(s => [s.ids[0], s]));

model.forEach(d => {
	// Move the processToAppMap creation outside of the loop if the data doesn't change
	// If it changes for each subProcess, then keep it here
	const processToAppMap = new Map(responses[2].process_to_apps.map(e => [e.id, e]));
	
	// Preprocess apps to add properties
	apps.forEach(app => {
	  app['appDel'] = getSlot('ap_delivery_model', app.ap_delivery_model[0]);
	  app['time'] = getSlot('ap_disposition_lifecycle_status', app.ap_disposition_lifecycle_status[0]);
	  app['life'] = getSlot('lifecycle_status_application_provider', app.lifecycle_status_application_provider[0]);
	  app['codebase'] = getSlot('ap_codebase_status', app.ap_codebase_status[0]);
	  app['className'] = 'Application_Provider';
	});
	
	// Create a Map to group apps by their physP for faster lookup
	const appsByPhysP = new Map();
	apps.forEach(app => {
	  app.physP.forEach(process => {
		if (!appsByPhysP.has(process)) {
		  appsByPhysP.set(process, []);
		}
		appsByPhysP.get(process).push(app);
	  });
	});
	
	// Now iterate through subProcess
	d.subProcess.forEach(e => {
	  const mappedApps = [];
	
	  e.physp.forEach(process => {
		const appsWithThisProcess = appsByPhysP.get(process) || [];
	
		appsWithThisProcess.forEach(app => {
		  const procOrg = processToAppMap.get(process);
		  if (procOrg) {
			app.vsorgs.push({"id": procOrg.orgid, "name": procOrg.org});
			mappedApps.push(app);
		  }
		});
	  });
	
	  // Eliminate duplicate apps by id
	  e['apps'] = [...new Map(mappedApps.map(item => [item.id, item])).values()];
	});
	
});


		essInitViewScoping(redrawView,['Group_Actor', 'Geographic_Region','SYS_CONTENT_APPROVAL_STATUS'], filters, true);
		
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
var vspNames
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
 
	let selected;
	if(selectedId){
	 
		 selected =model.find((e)=>{
			return e.id==selectedId;
		});
	} else{
		selected =model[0];
	}
 
 

	const data = selected

	  function groupAppsByOrgAndvsP(data) {

		const result = {};
		 vspNames = data?.subProcess.map(vsp => vsp.name);
	
		 // Preprocess scopedapps.resourceIds into a Set for O(1) lookups
		 const scopedAppsSet = new Set(scopedapps.resourceIds);
		 
		 // Prepare a template for result[orgName]
		 const emptyOrgTemplate = {};
		 vspNames.forEach(name => {
		   emptyOrgTemplate[name] = [];
		 });
		
		 data.subProcess.forEach(sp => {
		   const spName = sp.name;
		   
		   sp.apps?.forEach(app => {
		
			 app.vsorgs.forEach(org => {
			
			   const orgName = org.name;
		   
			   // Initialize using a pre-created empty template
			   if (!result[orgName]) {
					result[orgName] = JSON.parse(JSON.stringify(emptyOrgTemplate));
			   }
		   
			   // Use the pre-created Set for faster lookup
			   if (scopedAppsSet.has(app.id)) {
				 result[orgName][spName].push(app);
				 
			   }
			 });
		   });
		
		 });
		 
		return result;
	  }
 
	   if(data){
	  const groupedApps = groupAppsByOrgAndvsP(data);
	  const transformedData = Object.keys(groupedApps).map(orgName => {
		const sps = Object.keys(groupedApps[orgName]).map(spName => {
			 
		  return {
			spName, 
			apps: groupedApps[orgName][spName],
		  };
		});
	 
		return {
		  orgName, 
		  sps,
		};
	  });
	  
	  transformedData.forEach((f)=>{
		f.sps.forEach((l)=>{
	    	l.apps = [...new Map(l.apps.map(item => [item.id, item])).values()];
		})
	  })
	  	let dataSet={}

	  if(transformedData.length&gt;0){
	  let vspLength = transformedData[0].sps.length;
	  var viewportWidth = window.innerWidth;
	  let vspWidth=Math.floor(viewportWidth/vspLength)-20;
	  let vspWidth2=Math.floor(95/vspLength)
	
	  dataSet["item"]=[];
	  dataSet['sps']=vspNames;
	  dataSet['colWidth']=vspWidth;
	  transformedData.forEach((f,i)=>{

		f['width']=vspWidth
		f['className']='Business_Process';
			dataSet.item.push(f)
		
	  })
	  }else{
	
		dataSet['msg']='No sub processes are mapped and/or no physical processes are mapped';
	  }
	 
	  dataSet['proc']=selected;
	
		$('#tabcontainer').html(vstemplate(dataSet)); 
		
		}
		$('#vs').off().on('change', function(){
			selectedId=$(this).val()
			redrawView();
		})
	}

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
<xsl:template match="node()" mode="model">
	<xsl:variable name="thissubBusinessProcesses" select="key('businessProcesses',current()/own_slot_value[slot_reference='bp_sub_business_processes']/value)"/>
	<xsl:variable name="thisbusinessCapability" select="key('businessCapability', current()/name)"/>
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", 
	"className":"Business_Process",
	"pos":"<xsl:choose><xsl:when test="number(substring(current()/own_slot_value[slot_reference='business_process_id']/value,1,2))&lt;7">Top</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='business_process_id']/value">Bottom</xsl:when><xsl:otherwise>Top</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
 "subProcess":[<xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"/>],
"capsSupporting":[<xsl:for-each select="$thisbusinessCapability">{"id":"<xsl:value-of select="current()/name"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "className":"Business_Capability"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>	
	
</xsl:template>

<xsl:template match="node()" mode="subProcesses">
	<xsl:param name="depth" select="0"/>
	<xsl:variable name="thissubBusinessProcesses" select="key('businessProcesses',current()/own_slot_value[slot_reference='bp_sub_business_processes']/value)"/>
 
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"physicalProcesses":[<xsl:for-each select="current()/own_slot_value[slot_reference='implemented_by_physical_business_processes']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if>	</xsl:for-each>],
<xsl:if test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">"flow":"yes",</xsl:if>	
	"subProcess":[
		<xsl:if test="$depth &lt;= $maxDepth"><xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"><xsl:with-param name="depth" select="$depth + 1"/></xsl:apply-templates></xsl:if>
	]}<xsl:if test="position()!=last()">,</xsl:if>	
	
</xsl:template>	
</xsl:stylesheet>