<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	 
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<xsl:variable name="allValueStreams" select="/node()/simple_instance[(type = 'Value_Stream')]"/>
	<xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = ('Application_Provider','Composite_Application_Provider'))]"/>
	<xsl:key name="allValueStage" match="/node()/simple_instance[(type = 'Value_Stage')]" use="own_slot_value[slot_reference='vsg_value_stream']/value"/>
	<xsl:key name="allBusinessCapabilities" match="/node()/simple_instance[(type = 'Business_Capability')]" use="name"/>
	<xsl:key name="allBusinessProcessesviaCap" match="/node()/simple_instance[(type = 'Business_Process')]" use="own_slot_value[slot_reference='realises_business_capability']/value"/>
	<xsl:key name="allBusinessProcesses" match="/node()/simple_instance[(type = 'Business_Process')]" use="name"/>
	<xsl:key name="allPhysicalProcesses" match="/node()/simple_instance[(type = 'Physical_Process')]" use="own_slot_value[slot_reference='implements_business_process']/value"/>
	<xsl:key name="allPhysicalProcessesApps" match="/node()/simple_instance[(type = 'APP_PRO_TO_PHYS_BUS_RELATION')]" use="own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value"/>	
	<xsl:key name="directApptoProcessKey" match="$allAppProviders" use="own_slot_value[slot_reference = 'app_pro_supports_phys_proc']/value"/>
	<xsl:key name="indirectApptoProcessAPRAppsKey" match="/node()/simple_instance[type=('Application_Provider_Role')]" use="own_slot_value[slot_reference = 'app_pro_role_supports_phys_proc']/value"/>
	<xsl:key name="indirectApptoServiceKey" match="$allAppProviders" use="own_slot_value[slot_reference = 'provides_application_services']/value"/>
	<xsl:key name="a2r" match="/node()/simple_instance[type=('ACTOR_TO_ROLE_RELATION')]" use="own_slot_value[slot_reference = 'performs_physical_processes']/value"/>
	<xsl:key name="orgs" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'performs_physical_processes']/value"/>
	<xsl:key name="a2rorgs" match="/node()/simple_instance[type=('Group_Actor')]" use="own_slot_value[slot_reference = 'actor_plays_role']/value"/>	
	<xsl:key name="proc2Info" match="/node()/simple_instance[type=('PHYSBUSPROC_TO_APPINFOREP_RELATION')]" use="own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value"/>	
	<xsl:key name="proc2InfotoInfo" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION')]" use="name"/>	
	<xsl:key name="inforep" match="/node()/simple_instance[supertype=('Information_Representation_Type')]" use="own_slot_value[slot_reference = 'inforep_used_by_app_pro']/value"/>	
	<xsl:key name="site" match="/node()/simple_instance[type=('Site')]" use="name"/>
	
	<xsl:key name="suppliers" match="/node()/simple_instance[type=('Supplier')]" use="name"/>	

	<xsl:variable name="capData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Value_Stream', 'Value_Stage',  'Business_Capability', 'Application_Provider', 'Group_Actor', 'Site', 'Composite_Application_Provider')"/>
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
		<xsl:variable name="apiDataAppsCaps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
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
				<title>Value Stream Canvas</title>
				<style>
 
					.chevron-right{
					height: 100%;
					min-height:200px;
					font-family:verdana;
					width: 100%;
						clip-path: polygon(95% 0%, 100% 50%, 95% 100%, 0% 100%, 5% 50%, 0% 0%);
						background: #ececec;

								z-index:1;
							}
						.chevron-right-small{
							height: 100px;
							min-height:100px;
							font-size:0.9em;
							width: 150px;
							clip-path: polygon(85% 0%, 100% 50%, 85% 100%, 0% 100%, 15% 50%, 0% 0%);
							background: #49c2b5;
							display:inline-block;
							margin-bottom:2pt;
							z-index:1;
							padding:2px;
							padding-left: 28px;
    						padding-right: 15px;
							vertical-align:top;
							}
							.chev{
								width:150px;
								display:inline-block;
							}
							.oIcon{
								/*
								position:absolute;
								top:10px;
								right:3px;
								z-index:100;
								*/
							}

							.value-chain {
							display: flex;
							justify-content: space-between;
							align-items: center;
							margin-bottom: 20px;
							}
							
							.value-chain div {
							position: relative;
							width: 100px;
							height: 100px;
							background-color: #49c2b5;
							border-radius: 5px;
							display: flex;
							justify-content: center;
							align-items: center;
							}
							
							.value-chain div::before,
							.value-chain div::after {
							content: '';
							position: absolute;
							width: 0;
							height: 0;
							border-style: solid;
							}
							
							.value-chain div::before {
							border-width: 10px 10px 10px 0;
							border-color: transparent #49c2b5 transparent transparent;
							left: -10px;
							}
							
							.value-chain div::after {
							border-width: 10px 0 10px 10px;
							border-color: transparent transparent transparent #49c2b5;
							right: -10px;
							}
							
							/* Adjust the chevron color and size as needed */
							.value-chain div::before,
							.value-chain div::after {
							border-color: transparent #49c2b5 transparent transparent;
							}
							.valueChainBox{
								padding-left: 62px;
								padding-top:10px;
							}
							
							.valueChainBox a {
								color: #ffffff;
							}
							
						.infoBox{
							border:1pt solid #d3d3d3;
							padding: 2px;
							border-radius:6px;
							margin:5px;
							min-height: 170px;
							font-family:verdana;
							overflow: auto; 
						}
						.infoBoxWide
						{
							border:1pt solid #d3d3d3;
							padding: 2px;
							border-radius:6px;
							margin:9px;
							min-height: 150px;
							font-family:verdana;
						}
						.container{
							padding:3px;
						}
						.circle {
							display: flex;
							align-items: center;
							justify-content: center;
							width: 45px;
							height: 45px;
							border-radius: 50%;
							background-color: #66e2cb;
							position:absolute;
								top:10px;
								right:3px;
								z-index:100;
							}
						.circle-process{
							display: flex;
							align-items: center;
							justify-content: center;
							width: 45px;
							height: 45px;
							border-radius: 50%;
							background-color: #66e2cb;
							position:absolute;
								top:10px; 
								z-index:100;
							right:60px;
						}	
						.lead{
							font-weight: bold;
							font-size: 1.4em;
							margin-left: 10px;
							color:#49c2b5;
						}
						.vsOptions{
							font-size:0.9em;
						}
						.selectBox{
							font-size:0.7em;
						}
						.first-letter {
							font-size:1.1em;
							font-weight:bold;
							color:#418ac5;
						}
						#apps{
							text-align:center;
						}
						.labelApps{
							margin:3px;
							font-size:1em;
						}
						.ess-list-tags li{
							padding: 3px 12px;
							border: 1px solid #d3d3d3;
							border-radius: 16px;
							margin-right: 10px;
							margin-bottom: 5px;
							display: inline-block;
							font-weight: 700;
							background-color: #fff;
							font-size: 85%;
							box-shadow: 2px 2px 2px #d3d3d3ee;
							list-style-type: none;
						}
						 

				</style>
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
									<span class="text-primary"><xsl:value-of select="eas:i18n('Value Stream')"/>: </span>
									<span class="text-darkgrey selectBox"><select id="vsOptions"></select></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
				<div class="col-xs-1"></div>	 
				<div class="col-xs-10">
					 <!--<h2><span id="vsName"/></h2>-->
					 <div class="col-xs-1"/>
					    <div class="col-xs-5 infoBox"><h4 class="lead left-5">Suppliers</h4>
							<div class="circle">
								<i class="fa fa-truck oIcon fa-2x"></i>
							</div>
							<div class="info" id="suppliers"/>
						</div> 
						<div class="col-xs-5 infoBox"><h4 class="lead left-5">Locations</h4>
							<div class="circle">
								<i class="fa fa-industry oIcon fa-2x"></i>
							</div>
							<div class="info" id="locations"/>
						</div>
					<div class="col-xs-11 chevron-right"><h4 class="lead left-30" id="vsName"></h4>
							<div class="circle-process">
								<i class="fa fa-chevron-right oIcon fa-2x"></i>
							</div>
							<div class="valueChainBox" id="valueChain"></div>
						</div>
							<div class="col-xs-1"/>
						<div class="col-xs-5 infoBox"><h4 class="lead left-5">Org</h4>
							<div class="circle">
								<i class="fa fa-sitemap oIcon fa-2x"></i>
							</div>
							<div class="info" id="orgs"/>
						</div>
					 
						<div class="col-xs-5 infoBox"><h4 class="lead left-5">Info</h4>
							<div class="circle">
								<i class="fa fa-laptop oIcon fa-2x"></i>
							</div>
							<div class="info" id="infoReps"/>
						</div>
						<div class="clearfix"/>
						<div class="col-xs-1"/>
						<div class="col-xs-10 infoBoxWide"><h4 class="lead left-5">Applications</h4>
							<div class="circle">
								<i class="fa fa-clock-o oIcon fa-2x"></i>
							</div>

							<div class="info" id="apps"/>
						</div>
						 
					</div> 

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
			<script>			
			<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
				<xsl:call-template name="RenderViewerAPIJSFunction"> 
					<xsl:with-param name="viewerAPIPathAC" select="$apiDataAppsCaps"></xsl:with-param>  		
				</xsl:call-template>   
			</script>
	<script id="supplier-template" type="text/x-handlebars-template">
			<ul class="ess-list-tags">
				{{#each this}}
				<li>{{this.name}}</li>
				{{/each}}
			</ul>

	</script>
	<script id="general-template" type="text/x-handlebars-template">
		<ul class="ess-list-tags">
			{{#each this}}
			<li>{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}}{{#ifEquals this.external 'true'}} <span class="label label-info label-xs">External</span> {{/ifEquals}}</li>
			{{/each}}
		</ul>

</script>
	<script id="noLink-template" type="text/x-handlebars-template">
		<ul class="ess-list-tags">
			{{#each this}}
			<li>{{this.name}}</li>
			{{/each}}
		</ul>

</script>
	<script id="vc-template" type="text/x-handlebars-template">
			
				{{#each this}}
				<div class="chevron-right-small">{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}} </div>
				{{/each}} 

	</script>
	<script id="label-template" type="text/x-handlebars-template">
		<ul class="ess-list-tags">
		{{#each this}}
		<li>{{#essRenderInstanceReportLink this}}{{/essRenderInstanceReportLink}} </li>
		{{/each}} 
		</ul>

</script>





		</html>
	</xsl:template>
	<xsl:template name="RenderViewerAPIJSFunction"> 
		<xsl:param name="viewerAPIPathAC"></xsl:param>   
		//a global variable that holds the data returned by an Viewer API Report 
		var viewAPIDataAC = '<xsl:value-of select="$viewerAPIPathAC"/>';   
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

		 function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};

		showEditorSpinner('Fetching Data...'); 

		$('document').ready(function (){ 
		Promise.all([
			promise_loadViewerAPIData(viewAPIDataAC)
			]).then(function (responses){  
 
			})
		})

		var valueStream=[<xsl:apply-templates select="$allValueStreams" mode="valueStream"/>];

		vs=valueStream.sort((a, b) => a.name &lt; b.name ? -1 : (a.name > b.name ? 1 : 0)); 
valueStream.forEach((d)=>{
	$('#vsOptions').append('&lt;option value="'+d.id+'">'+d.name+'&lt;/option>')
})

	$('document').ready(function () {
	viewFragment = $("#general-template").html();
	viewTemplate = Handlebars.compile(viewFragment);

	viewSuppFragment = $("#supplier-template").html();
	viewSuppTemplate = Handlebars.compile(viewSuppFragment);

	viewNLFragment = $("#noLink-template").html();
	viewNLTemplate = Handlebars.compile(viewNLFragment);

	vcFragment = $("#vc-template").html();
	vcTemplate = Handlebars.compile(vcFragment);

	labelFragment = $("#label-template").html();
	labelTemplate = Handlebars.compile(labelFragment);
 
	
	Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
		return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
	});

	let selected=$('#vsOptions').val();
 
	if(selected !=='Choose'){
		let vs=valueStream.find((e)=>{
			return e.id==selected;
		})
		$('#vsName').text(vs.name)
		renderPage(vs)
	}else{
		 
		$('#vsName').text(valueStream[0].name)
		renderPage(valueStream[0])

	}

	
	
			$('#vsOptions').on('change', function(){
				let option=$(this).val();
				let vs=valueStream.find((e)=>{
					return e.id==option;
				})
			 
				$('#vsName').text(vs.name)
				renderPage(vs)
			})

	function renderPage(vsData){
		$('#valueChain').html(vcTemplate(vsData?.processes));
		$('#suppliers').html(viewSuppTemplate(vsData?.suppliers));
		$('#infoReps').html(viewTemplate(vsData?.inforep));
		$('#orgs').html(viewTemplate(vsData?.orgs));
		$('#locations').html(viewNLTemplate(vsData?.sites));
		$('#apps').html(labelTemplate(vsData?.apps));
	
//	$('.info').html(viewTemplate(data))
	 var orgBoxHeight = $("#orgs").outerHeight();
	var infoBoxHeight = $("#infoReps").outerHeight();

	// Find the maximum height between the two
	var maxHeight = Math.max(orgBoxHeight, infoBoxHeight)+20;
	// Set the height of both divs to be the same
	$("#orgs, #infoReps").outerHeight(maxHeight);

	var suppliersBoxHeight = $("#suppliers").outerHeight();
	var locationsBoxHeight = $("#locations").outerHeight();

	// Find the maximum height between the two
	var topmaxHeight = Math.max(suppliersBoxHeight, locationsBoxHeight)+20;
	 
	// Set the height of both divs to be the same
	$("#suppliers, #locations").outerHeight(topmaxHeight);
	}

	})
</xsl:template>
	<xsl:template match="node()" mode="test">
		{"id":"<xsl:value-of select="current()/name"/>",
        "name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
        "description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
		"purpose":"bus app"
        }<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="valueStream">
	<xsl:variable name="thisValueStage" select="key('allValueStage',current()/name)"/>
	<xsl:variable name="thisBusCaps" select="key('allBusinessCapabilities',$thisValueStage/own_slot_value[slot_reference='vsg_required_business_capabilities']/value)"/>
	<xsl:variable name="thisBusprocsviaCaps" select="key('allBusinessProcessesviaCap',$thisBusCaps/name)"/>
	<xsl:variable name="thisBusProcs" select="key('allBusinessProcesses',$thisValueStage/own_slot_value[slot_reference='vs_supporting_bus_processes']/value)"/>

	<xsl:variable name="thisrelevantPhysProcs" select="key('allPhysicalProcesses',$thisBusProcs/name)"/> 
	<xsl:variable name="thisPhysicalProcessesApps" select="key('allPhysicalProcessesApps',$thisrelevantPhysProcs/name)"/> 
	<xsl:variable name="thisdirectApptoProcessKey" select="key('directApptoProcessKey',$thisPhysicalProcessesApps/name)"/> 
	<xsl:variable name="thisindirectApptoProcessAPRAppsKey" select="key('indirectApptoProcessAPRAppsKey',$thisPhysicalProcessesApps/name)"/> 
	<xsl:variable name="thisindirectApptoServiceKey" select="key('indirectApptoServiceKey',$thisindirectApptoProcessAPRAppsKey/name)"/>
	<xsl:variable name="allThisApps" select="$thisdirectApptoProcessKey union $thisindirectApptoServiceKey"/>
	<xsl:variable name="thisa2r" select="key('a2r',$thisrelevantPhysProcs/name)"/>
	<xsl:variable name="thisdirectorgs" select="key('orgs', $thisrelevantPhysProcs/name)"/>
	<xsl:variable name="thisa2rorgs" select="key('a2rorgs', $thisa2r/name)"/>
	<xsl:variable name="thisorgs" select="$thisa2rorgs union $thisdirectorgs"/>
	<xsl:variable name="suppliers" select="key('suppliers',$allThisApps/own_slot_value[slot_reference='ap_supplier']/value)"/>
	<xsl:variable name="allSupp" select="$thisorgs[own_slot_value[slot_reference='external_to_enterprise']/value='true'] union $suppliers"/>
	<!-- ext group actors -->
	<xsl:variable name="thisproc2Info" select="key('proc2Info',$thisrelevantPhysProcs/name)"/>
	<xsl:variable name="thisproc2InfotoInfo" select="key('proc2InfotoInfo',$thisproc2Info/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value)"/>
	<xsl:variable name="thisinforep" select="key('inforep',$thisproc2InfotoInfo/name)"/>
	<xsl:variable name="thisprocSites" select="key('site',$thisrelevantPhysProcs/own_slot_value[slot_reference = 'process_performed_at_sites']/value)"/>
		{ 
		 "id":"<xsl:value-of select="current()/name"/>",
		 "className":"<xsl:value-of select="current()/type"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"thisValueStage":[<xsl:apply-templates select="$thisValueStage" mode="details"/>],
		"processes":[<xsl:apply-templates select="$thisBusProcs" mode="details"/>],
		"apps":[<xsl:apply-templates select="$allThisApps" mode="details"/>],
		"orgs":[<xsl:apply-templates select="$thisorgs" mode="orgdetails"/>],
		"suppliers":[<xsl:apply-templates select="$allSupp" mode="details"/>],
		"sites":[<xsl:apply-templates select="$thisprocSites" mode="details"/>],
		"inforep":[<xsl:apply-templates select="$thisinforep" mode="details"/>]
				}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
<xsl:template match="node()" mode="details">
		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"className":"<xsl:value-of select="current()/type"/>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>"
		}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="orgdetails">
		{"id":"<xsl:value-of select="current()/name"/>",
		"name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"className":"<xsl:value-of select="current()/type"/>",
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
			<xsl:with-param name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>",
		"external":"<xsl:value-of select="current()/own_slot_value[slot_reference='external_to_enterprise']/value"/>"
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
