<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../enterprise/core_el_issue_functions.xsl"/>  
	<xsl:import href="../common/core_js_functions.xsl"/> 
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="apps" select="node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
    <xsl:variable name="approles" select="node()/simple_instance[type = 'Application_Provider_Role'][name=$apps/own_slot_value[slot_reference='provides_application_services']/value]"/>
    
	<xsl:variable name="appservices" select="node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="lifecycleStatus" select="node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="appUsage" select="node()/simple_instance[type = 'Static_Application_Provider_Usage']"/>
	<xsl:variable name="appUsageArch" select="node()/simple_instance[type = 'Static_Application_Provider_Architecture']"/>
	<xsl:variable name="appInterface" select="node()/simple_instance[type = ':APU-TO-APU-STATIC-RELATION']"/>
    <xsl:variable name="codebaseStatus" select="node()/simple_instance[type = 'Codebase_Status'][name=$apps/own_slot_value[slot_reference = 'ap_codebase_status']/value]"/>
    <xsl:variable name="physicalProcesses" select="node()/simple_instance[type = 'APP_PRO_TO_PHYS_BUS_RELATION']"/>  
     <xsl:variable name="physProcesses" select="node()/simple_instance[type = 'Physical_Process']"/>  
    <xsl:variable name="busProcesses" select="node()/simple_instance[type = 'Business_Process']"/>  
     <xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $apps/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
    <xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>
    <xsl:variable name="manualDataEntry" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value='Manual Data Entry']"/>
	<xsl:variable name="allAppStaticUsages" select="/node()/simple_instance[type = 'Static_Application_Provider_Usage']"/>
	<xsl:variable name="allInboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':FROM']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
	<xsl:variable name="allOutboundStaticAppRels" select="/node()/simple_instance[(own_slot_value[slot_reference = ':TO']/value = $allAppStaticUsages/name) and not(own_slot_value[slot_reference = 'apu_to_apu_relation_inforep_acquisition_method']/value = $manualDataEntry/name)]"/>
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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
                <xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Rationalisation Analysis</title>
               		<style>
                    .appCard_Container{
                        width:170px;
                        float: left;
                        margin: 0 15px 30px 0;
                        border-radius: 2px;
                        box-shadow: 0 1px 1px 0 rgba(60,64,67,.08),0 1px 3px 1px rgba(60,64,67,.16);
                    }
                    .appCard_Top{
                        border-radius: 2px 2px 0 0;
                        border: 1px solid #ccc;
                        border-bottom: none;
                        display: flex;
                    }
                    .appCard_Middle{
                        border: 1px solid #ccc;
                        border-bottom: none;
                        display: flex;
                    }
                    .appCard_Bottom{
                        border-radius: 0 0 2px 2px;
                        border: 1px solid #ccc;
                        display: flex;
                    }
                    .appCard_Divider {
                        border-right: 1px solid #ccc;
                    }
                    .appCard_TopLeft {
                        width: 75%;
                        color:#fff;
                        height: 32px;
                        max-height: 32px;
                        overflow: hidden;
                        position: relative;
                        padding: 3px;
                        border-radius: 2px 0 0 0;
                        display: table;
                        float: left;
                        line-height: 1.1em;
                    }
                    .appCard_TopRight {
                        width: 25%;
                        height: 32px;
                        max-height: 32px;
                        color:#333;
                        position: relative;
                        padding: 3px;
                        border-radius: 0 2px 0 0;
                        display: table;
                        float: left;
                    }
                    .appCard_Label {
                        display: table-cell;
                        vertical-align: middle;
                        position: relative;
                    }
                    .appCard_Section25pc {
                        width: 25%;
                        float: left;
                        padding: 3px;
                    }
                    .appCard_Section50pc {
                        width: 50%;
                        float: left;
                        padding: 3px;
                        height: 24px;
                    }
                    .displayTable {
                        position: relative;
                        display: table;
                    }
                    .xxsmall {font-size: 85%;line-height: 1.1em;}
                    .xxxsmall {font-size: 75%;line-height: 1.1em;}
                    .popover {max-width: 400px;}
                    .fa-info-circle:hover {cursor: pointer}
                    .textGold {color: #EEC62A}
                    .textBlue {color: #4196D9}
                </style>
                <link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<script src="js/d3/d3_4-11/d3.min.js"/>
                <script>
                        var appCardTemplate;
						var sourceReport='<xsl:value-of select="$param1"/>';
                        $(document).ready(function() {
                            $('select').select2({
                            	theme: "bootstrap"
                            });
                            
                            var appCardFragment   = $("#app-card-template").html();
                            appCardTemplate = Handlebars.compile(appCardFragment);
	                        
	                        Handlebars.registerHelper('getScore', function(score, options) {
								if (score != null){
									return Math.round(score);
								}
								else {return ''}
							});
                    
    
                     Handlebars.registerHelper('nameSubString', function(name) {
								return name.substring(0, 14);
							});
					
					
					var carriedApps = JSON.parse(sessionStorage.getItem("context"));
			 if(carriedApps){
					if(carriedApps.Composite_Application_Provider.length &gt; 0){
						//if only one don't show basket 
					
						if(carriedApps.Composite_Application_Provider.length==1){ 
					
						$('#application').val(carriedApps.Composite_Application_Provider[0]); // Select the option 
						$('#application').trigger('change');
						}else{
					 
							$('#carriedApps').show()
							var selectArray=[];

								carriedApps.Composite_Application_Provider.forEach(function(d){

									var thisApp=appJSON.filter(function(e){
										return e.id==d;
									});
							selectArray.push({val : thisApp[0].id, text: thisApp[0].application});

								});

							selectArray.sort(function(a, b){
								if(a.text &lt; b.text) { return -1; }
								if(a.text > b.text) { return 1; }
								return 0;
							})
							selectArray.unshift({val : '', text: 'choose'});
							var sel = $('&lt;select id="carriedSelect">').appendTo('#selPlace');
							$(selectArray).each(function() {
							 sel.append($("&lt;option>").attr('value',this.val).text(this.text));
							});
							};
							};
					
					$('#carriedSelect').change(function(){
						selectApp($(this).val());
						getAllApps();
						showInfoTooltips()
					$('#'+$(this).val()).hide();
					
					});
		}
                        });
                        
                        function showFocusType(){
                        		var radioValue = $("input[name='focusType']:checked").val();
                        		if(radioValue == 'radioService'){
                                    $('#selBox').val(null).trigger('change');
                                    $("#application").val(null).trigger('change');
                                    $('#ticks').val(null).trigger('change');
                                    $('#SLs').val(null).trigger('change');
						        	$('#appSearch').hide();
						        	$('#servSearch').show();
						        }
						        else if(radioValue == 'radioApp'){
                                    $('#application').val(null).trigger('change');
                                    $('#ticks').val(null).trigger('change');
                                    $('#SLs').val(null).trigger('change');
						        	$('#servSearch').hide();
						        	$('#appSearch').show();
						        }
                        	};
                        	
                        function showInfoTooltips(){
                        	$('[role="tooltip"]').remove();
							$('.fa-info-circle').popover({
								container: 'body',
								html: true,
								trigger: 'click',
								content: function(){
									return $(this).next().html();
								}
							});
                        };
					function goBack() {
						  window.history.back();
						};  
                </script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 style="font-size: 28px !important ;font-weight: 600 !important;margin-bottom: 20px !important;">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Application Rationalisation Analysis</span>
								</h1>
							</div>
						</div>
							
						<!--Setup Description Section-->
                        <div class="col-xs-2">
                        	
                        	<h3 class="text-primary">Search by:</h3>
                        	
							<label><input class="radio-inline" type="radio" name="focusType" value="radioApp" onclick="showFocusType();ResetAll()" checked="checked" id="radioApp"/>Application</label>
							<label><input class="radio-inline" type="radio" name="focusType" value="radioService"  onclick="showFocusType();ResetAll()"/>Service</label>
                        	
							<div id="appSearch" class="top-15">
							    <h3 class="text-primary" style="display:inline-block">Focus Application</h3>
							    <div class="form-group span-3">
									<select id="application" onchange="selectApp(this.value);getAllApps();showInfoTooltips();" class="form-control select2" style="width:100%;">
							            <option value="1selectOne" selected="true">Select an Application</option>
							            <xsl:apply-templates select="$apps" mode="getOptions">
							                <xsl:sort select="upper-case(own_slot_value[slot_reference='name']/value)" order="ascending"/>
							            </xsl:apply-templates>
									
									</select>
							    </div>
							</div>
							            
							<div id="servSearch" class="top-15 hiddenDiv"> 
							    <h3  class="text-primary" style="display:inline-block">Select Services</h3>
								<select class="servicesNew" name="servicesOnlt" multiple="multiple" style="width:100%;" id="selBox" onchange="showInfoTooltips();">
							        <xsl:apply-templates select="$appservices" mode="getServOptions">
							            <xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/>
							        </xsl:apply-templates>
								</select>
							    <button class="btn btn-sm btn-default top-5" onclick="selectNewApp()">Go</button>
							</div>
							<div id="services" class="top-15"> 
								<h3 class="text-primary">Services</h3>
								<ul id="appServs" class="small fa-ul"/>
								<button id="hide" onclick="$('#appServs').hide();$('#hide').hide();$('#show').show()" class="btn btn-sm btn-default">Hide</button>
								<button id="show" onclick="$('#appServs').show();$('#hide').show();$('#show').hide()" class="btn btn-sm btn-default">Show</button>
							</div>
							<div id="carriedApps" style="display:none;border:1pt solid #d3d3d3;border-radius:3px;padding:3px" class="top-15"> 
								<h3>Applications Basket</h3>
								<div id="selPlace"></div>
								<br/>
								<button class="btn btn-primary btn-sm" onclick="goBack()">Back to Previous</button>
							</div>
							
							
                        </div>	
                        <div class="col-xs-10">
                            <div id="filters">
                            <h3 class="text-primary">Filters</h3>
							
							
							<div class="row">
							<!--	<div class="col-md-2 col-lg-2">
									<div class="bottom-5">
										<i class="fa fa-star textGold right-5" /><strong>Prime Candidates Only:</strong>
									</div>
									<button class="btn btn-sm btn-default left-5" id="primeHide" onclick="$('#primeHide').hide();$('#primeShow').show();showPrime('on')">Off</button>
									<button class="btn btn-sm btn-default left-5" id="primeShow" onclick="$('#primeHide').show();$('#primeShow').hide();showPrime('off')" style="display:none">On</button><br/>
                                    
								</div>
								-->
								<div class="col-md-2 col-lg-2">
									<div class="bottom-5">
										<strong>Services Match:</strong>&#160;&#160;&#160;<span id="servnums"></span>
									</div>
									<input type="range" min="1" max="5" value="1" id="myRange"></input>
									<div class="slidecontainer">
										<script>
										var slider = document.getElementById("myRange");
										var output = document.getElementById("servnums");
										output.innerHTML = slider.value;
										
										slider.oninput = function() {
										    output.innerHTML = this.value;
										    updateCards();
										}
										</script>
									</div>
								</div>
							<!--	
								<div class="col-md-2 col-lg-2">
									<div class="bottom-5">
										<strong>Cost Threshold:</strong>
										<span class="left-5" id="costnums"></span>
									</div>
									<input type="range" min="0" max="50000" value="0" id="myCostRange"></input>
									<div class="slideCostcontainer">
										<script>
										var costslider = document.getElementById("myCostRange");
										var costoutput = document.getElementById("costnums");
										costoutput.innerHTML = costslider.value;
										
										costslider.oninput = function() {
										    costoutput.innerHTML = this.value;
										    updateCards();
										}
										</script>
									</div>
									<div class="xxsmall"><em class="right-5">Greater Than</em><input class="left-5" type="checkbox" id="inverse" name="inverse" value="inverse" onchange="updateCards()" checked="checked"></input></div>
								</div>
							
								<div class="col-md-2 col-lg-2">
									<div class="bottom-5">
										<strong>Interfaces:</strong>
										<span class="left-5" id="interfacenums"></span>
									</div>
									<input type="range" min="0" max="50000" value="0" id="myInterfaceRange"></input>
									<div class="slideInterfacecontainer">
										<script>
										var interfaceslider = document.getElementById("myInterfaceRange");
										var interfaceoutput = document.getElementById("interfacenums");
										interfaceoutput.innerHTML = interfaceslider.value;
										
										interfaceslider.oninput = function() {
										    interfaceoutput.innerHTML = this.value;
										    updateCards();
										}
										</script>
									</div>
								</div>
									-->
								<div class="col-md-2 col-lg-2">
									<div>
										<strong>Codebase:</strong>
									</div>
									
									<select multiple="multiple" id="ticks" style="width:100%;" onchange="updateCards()">
										<xsl:apply-templates select="$codebaseStatus" mode="codebase_select" />
										<option value="Not Defined">Not Defined</option>
									</select>
								</div>
								<div class="col-md-2 col-lg-2">
									<div>
										<strong>Strategic Lifecycle:</strong>
									</div>
									<select multiple="multiple" style="width:100%;" id="SLs"  onchange="updateCards()"/>
								</div>
							</div>
							</div>
                            <hr/>
                            	
							<div id="key" class="bottom-15 small" xstyle="display:none">
								<strong class="right-10">Legend:</strong>
								<i class="fa fa-copy right-5 text-primary" style="color:'+colour+'"></i>Overlap
								<span class="left-5 right-5">|</span>
								<i class="fa essicon-radialdots right-5 text-primary"></i>Total Number of Services
                                <span class="left-5 right-5">|</span>
								<i class="fa fa-exchange right-5 textBlue"></i>Candidates for Replacement by Focus App
                                <button class="btn btn-xs btn-default left-5" id="reset" onclick="ResetAll()" style="display: inline-block;">Reset Filters</button><br/>
							</div>
                            <hr /> 
                        	<div id="cardsBlock"/>
		                </div>
	                    <!--Setup Closing Tags-->
					</div>
				</div>
                   

				<!-- ADD THE PAGE FOOTER
				<xsl:call-template name="Footer"/> -->
        <script>
     
              $('#show').hide();
 
            var appJSON=[<xsl:apply-templates select="$apps" mode="getAppJSON"/>]

            var serviceJSON=[<xsl:apply-templates select="$appservices" mode="getServJSON"/>]

            var appoptions = d3.nest()
                            .key(function(d) { return d.id; })
                            .entries(appJSON);

            var services =d3.nest()
                            .key(function(d) { return d.service; })
                            .entries(serviceJSON);
                    
           	var focusServices;
            var focusedServices=0;  
            var focusProcesses=[];
            var primeType=false;
            
             function selectNewApp(){
                $("#appServs").empty();
                alli=$(".servicesNew").val();
				var selitems=[];	
	
				$('.servicesNew option:selected').each(function(){ selitems.push({"selectId":$(this).attr('name'),"name":$(this).val()}) });	
                focusServices=selitems;
				console.log(focusServices)
                focusedServices=focusServices.length;
            
                $("#appServs > tbody").empty();          
                                <![CDATA[ $("#appServs").append("<tbody>");]]>
                                for(i=0; i &lt; focusServices.length;i++){                                         
                                 <![CDATA[ $("#appServs").append("<li class='servs'><i class='fa fa-li essicon-radialdots'></i> "+focusServices[i].name+"</li>"); ]]>                                        
                                }
                getAllApps();
                }
                     
             function selectApp(appl){
                $("#appServs").empty();
                            focusServices=[];  
                            focusProcesses=[]; 
                            count=0;
                                var appSelected = appoptions.filter(function(d) {
                                        return d.key === appl;
                                    });
            
                            $("#appServs > tbody").empty();          
                                <![CDATA[ $("#appServs").append("<ul>");]]>
                                appSelected.forEach(function(item) {
                                    services= item.values[0].services;     
                                    services.forEach(function(item){
                                         focusServices.push({"selectId":item.serviceId});   
                                        var servSelectedApps = serviceJSON.filter(function(d) {
                                        return d.serviceId === item.serviceId;
                                    });
                              
                                var appsUsingService = servSelectedApps[0].applications;
                                var appsCount = (appsUsingService.length)-1;
                                count=count+1;
                                
                                                                                            
                                 <![CDATA[ $("#appServs").append("<li class='servs'><i class='fa fa-li essicon-radialdots'></i> "+item.service+"</li>"); ]]>                      
        
                                });
     
                                });
                            focusedServices=count; 
            };        
                                 
         
            var allStatus=  appJSON.map(function (d) {return d.status;}) ;   
			let unique = allStatus.filter((item, i, ar) => ar.indexOf(item) === i)
			unique.sort(function(a, b){
						if(a &lt; b) { return -1; }
						if(a > b) { return 1; }
						return 0;
					})
 
            for(i=0;i &lt; unique.length; i++){
                html = '<option id="s'+unique[i].replace(/\s/g, '')+'" name="s'+unique[i].replace(/\s/g, '')+'" value="'+unique[i]+'" onchange="updateCards()">'+unique[i]+'</option>';
                $( "#SLs" ).append(html);
            }
            
            function getRelevantApps(){
        
                      Apps=[];
                            for(i=0;i &lt; serviceJSON.length;i++){
                             for(j=0;j &lt; focusServices.length;j++){
                               if(serviceJSON[i].serviceId==focusServices[j].selectId){
                                    for(k=0;k &lt; serviceJSON[i].applications.length;k++){
                                        Apps.push(serviceJSON[i].applications[k]);
                                        }
                                    }
                                }
                           }
                    }
            
          
            function getAllApps(){
                    $('#key').show();
                            d3.selectAll('.carddiv')
                            .remove()
                            var html='';   
                          
                         getRelevantApps()
                         <!-- var uniqueApps= $.unique(Apps.map(function (d) {return d.application;}));  -->
                        var temp=[];
                        var uniqueApps=Apps.filter(function(x, i) {
                          if (temp.indexOf(x.id) &lt; 0) {
                            temp.push(x.id);
                            return true;
                          }
                          return false;
                        })
                          for(i=0;i &lt; uniqueApps.length;i++){
                    
                            var num=0;
                            var numsOfServs=''
                            if(uniqueApps[i] === 'Unknown'){}else{
            
                            var thisapp = appJSON.filter(function (el) {   
         
                                  return el.application ===uniqueApps[i].application;
                                    });
            
                            var servicesHTML=''; 
                            var switchApp = '';
                           
            
                            for(j=0;j &lt; thisapp[0].services.length;j++){
                                for(k=0;k &lt; focusServices.length;k++){
                                    if(thisapp[0].services[j].serviceId==focusServices[k].selectId){
                                            num = num+1;   
                                            }
                                        }
                                    }                                          
                                }  
                         
                            appid = thisapp[0].id;
                            score=((num/focusedServices)*100);
                            var colour;
                            if(score &lt; 25){colour='#f5a5a5'}else if(score &gt; 75){colour='#97f0bd'} else {colour='#f5d79d'};
                            appS=[];                    
                            for(j=0;j &lt; thisapp[0].services.length;j++)
                                {for(k=0;k &lt; focusServices.length;k++)
                                    {if(thisapp[0].services[j].serviceId==focusServices[k].selectId)
                                        {appS.push({"selectId":thisapp[0].services[j].serviceId,"name":thisapp[0].services[j].service})} 
                                    }
                                };
                          
                            if(thisapp[0].services.length &lt;= num){
                            thisapp[0]['switch']=true}else{thisapp[0]['switch']=false}
                            thisapp[0]['costColour']=colour;
                            thisapp[0]['servicesUsed']=appS;
                            thisapp[0]['num']=num;
                            thisapp[0]['numServices']=thisapp[0].services.length;
                            thisapp[0]['serviceMatch']=appS;
                            thisapp[0]['url']='report?XML=reportXML.xml&amp;PMA='+thisapp[0].id+'&amp;cl=en-gb&amp;XSL=application/core_al_app_provider_summary.xsl';
                            thisapp[0]['score']=score;
                            

                            $("#cardsBlock").append(appCardTemplate(thisapp[0]));
                            }
                            
                          
                            //$( "#cardsBlock" ).append(html);          
                            focusApp=$("#application").val(); 
                            $('#'+focusApp).hide()
                           
                            var $wrapper = $('#cardsBlock');

                                $wrapper.find('.carddiv').sort(function(a, b) {
                                    return +b.dataset.num - +a.dataset.num;
                                })
                                .appendTo($wrapper);
                    
                            <!-- set sliders --> 

                            var highestNum = $(".carddiv").map(function() {
                                return $(this).data('num');
                            }).get();//get all data values in an array

                            var highest = Math.max.apply(Math, highestNum);//find the highest value from them
                            $('.carddiv').filter(function(){
                                return $(this).data('num') == highest;//return the highest div
                            });

                           output.innerHTML = 0;

                           
                    };  
            
            function ResetAll(){
          
            $('#ticks').val(null).trigger('change');
            $('#SLs').val(null).trigger('change');
            $('#myRange').attr('value',0);
            
           
            updateCards($('#ticks').val);
            }
 
            function updateCards(){
            servs= ($('#myRange').val());
            codebase= ($('#ticks').val());
            statusVals=($('#SLs').val());     
            if(codebase.length &gt; 0){
            thisAppCode = appJSON.filter(function (el) {  
                           
                                for(var i=0;i &lt; codebase.length; i++){  
			
                                    if(codebase[i] === el.codebaseID){
                                        return el;
                                        }
                                    else if(codebase[i]==='Not Defined' &amp;&amp; el.codebase ==='Not Defined'){     return el;}
                                     }
                                    }); 
                    }
            else{
                thisAppCode = appJSON;
            }; 
            if(statusVals.length &gt; 0){
            thisAppStatus = thisAppCode.filter(function (el) {  

                                    for(var i=0;i &lt; statusVals.length; i++){  
              
                                    if(statusVals[i] === el.status){
                                        return el;
                                        }
                                     }
                                     });
                }
            else{
            thisAppStatus=thisAppCode;
            }
              
            thisAppServices = thisAppStatus.filter(function (el) {  
                                num=0;
                                 for(j=0;j &lt; el.services.length;j++){
										if(focusServices){
                                        for(k=0;k &lt; focusServices.length;k++){
                                            if(el.services[j].serviceId===focusServices[k].selectId){
                                                num = num+1;                         
                                                }
                                               }
                                            }  
                        
                                    if(num &gt;= servs){
                                        return el;
                                        };
										};
                                    });
           
            $('.carddiv').hide(); 
      
            for(var i=0; i &lt; thisAppServices.length; i++){
                    $('#'+thisAppServices[i].id).show();
                    
                    if(primeType===true){$('.carddiv[data-prime=false]').hide()}
                    }
            focusApp=$("#application").val();; 
                 $('#'+focusApp).hide();
                 
            showInfoTooltips()
                 
            }
           
            
             function hideClass(thisVal){ 
                $('.'+thisVal).hide();            
                    }
            
             function showClass(thisVal){ ;
                $('.'+thisVal).show();
                    }

                </script>
                  <xsl:call-template name="AppCardHandlebarsTemplate"/>
			</body>
		</html>
	</xsl:template>
    
    
    
    
    <xsl:template match="node()" mode="getAppJSON"><xsl:variable name="codeBase" select="current()/own_slot_value[slot_reference = 'ap_codebase_status']/value"/><xsl:variable name="lifecycle" select="current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value"/><xsl:variable name="aprsForApp" select="$approles[name = current()/own_slot_value[slot_reference = 'provides_application_services']/value]"/>
    <xsl:variable name="totalProcesses" select="$physicalProcesses[name=$aprsForApp/own_slot_value[slot_reference='app_pro_role_supports_phys_proc']/value]"/> 
        <!-- Get the integration complexity score -->
		<xsl:variable name="topApp" select="current()"/>
		<xsl:variable name="subApps" select="$apps[name = $topApp/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
        <xsl:variable name="appLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="subSubApps" select="$apps[name = $subApps/own_slot_value[slot_reference = 'contained_application_providers']/value]"/>
		
        {"application":"<xsl:call-template name="RenderMultiLangInstanceName">
  <xsl:with-param name="theSubjectInstance" select="current()"/>
  <xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template>", "id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","services":[<xsl:apply-templates select="$approles[name = current()/own_slot_value[slot_reference = 'provides_application_services']/value]" mode="getAppJSONservices"/>],"link":"<xsl:value-of select="$appLink"/>", "codebase":"<xsl:value-of select="$codebaseStatus[name=$codeBase]/own_slot_value[slot_reference='name']/value"/><xsl:if test="not($codeBase)">Not Defined</xsl:if>","codebaseID":"<xsl:value-of select="eas:getSafeJSString($codebaseStatus[name=$codeBase]/name)"/>","statusID":"<xsl:value-of select="eas:getSafeJSString($lifecycleStatus[name=$lifecycle]/name)"/>","status":"<xsl:value-of select="$lifecycleStatus[name=$lifecycle]/own_slot_value[slot_reference='enumeration_value']/value"/><xsl:if test="not($lifecycle)">Not Defined</xsl:if>"}, </xsl:template>

    <xsl:template match="node()" mode="getAppJSONservices">
		<xsl:variable name="this" select="current()/name"/>
		<xsl:variable name="thisserv" select="$appservices[own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $this]"/>

		<xsl:if test="$thisserv/own_slot_value[slot_reference = 'name']/value"> {"serviceId":"<xsl:value-of select="eas:getSafeJSString($thisserv/name)"/>","service":"<xsl:call-template name="RenderMultiLangInstanceName">
  <xsl:with-param name="theSubjectInstance" select="$thisserv"/>
  <xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template>"}<xsl:if test="not(position() = last())">,</xsl:if>
		</xsl:if>
	</xsl:template>
  

	<xsl:template match="node()" mode="getServJSON"> {"serviceId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>","service":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>", "applications":[<xsl:apply-templates select="$approles[name = current()/own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value]" mode="getServJSONapps"/>]}, </xsl:template>
	
    <xsl:template match="node()" mode="getServJSONapps">
		<xsl:variable name="this" select="eas:getSafeJSString(current()/name)"/>
		<xsl:variable name="thisapp" select="$apps[own_slot_value[slot_reference = 'provides_application_services']/value = $this]"/>{"application":"<xsl:call-template name="RenderMultiLangInstanceName">
  <xsl:with-param name="theSubjectInstance" select="$thisapp"/>
  <xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template><xsl:if test="not($thisapp)">Unknown</xsl:if>","id":"<xsl:value-of select="eas:getSafeJSString($thisapp/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
    
    <xsl:template match="node()" mode="codeOptions">
        <xsl:variable name="this" select="translate(current()/own_slot_value[slot_reference='enumeration_value']/value,' ','')"/>
        <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
        <div style="display: inline-block;">
          <input type="checkbox" id="{$this}" name="{$this}" value="{$thisid}" onchange="updateCards()" checked="true"></input>
        <label for="{$this}"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></label>
      </div>
    </xsl:template>
	
	<xsl:template match="node()" mode="codebase_select">
		<xsl:variable name="this" select="translate(current()/own_slot_value[slot_reference='enumeration_value']/value,' ','')"/>
        <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
		<option id="{$this}" name="{$this}" value="{$thisid}" onchange="updateCards()">			
			<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>
        </option>
	</xsl:template>
    
    <xsl:template match="node()" mode="getOptions">
         <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
        <xsl:variable name="this"><xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template></xsl:variable>
        <option name="{$thisid}" value="{$thisid}"><xsl:value-of select="$this"/></option>
    
    </xsl:template>
     <xsl:template match="node()" mode="getServOptions">
         <xsl:variable name="thisid" select="eas:getSafeJSString(current()/name)"/>
        <xsl:variable name="this"><xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template></xsl:variable>
        <option name="{$thisid}" value="{$this}"><xsl:value-of select="$this"/></option>
    
    </xsl:template>
    
    
    
	<xsl:template name="AppCardHandlebarsTemplate">
		<script id="app-card-template" type="text/x-handlebars-template">
            <div>
                <xsl:attribute name="class">carddiv {{this.codebaseID}} s{{this.statusID}} appCard_Container</xsl:attribute>
                <xsl:attribute name="id">{{this.id}}</xsl:attribute>
                <xsl:attribute name="data-num">{{this.num}}</xsl:attribute>
                <xsl:attribute name="class">carddiv {{this.codebaseID}} s{{this.statusID}} appCard_Container</xsl:attribute>
                <xsl:attribute name="id">{{this.id}}</xsl:attribute>
                <xsl:attribute name="data-num">{{this.num}}</xsl:attribute>
               
			<div class="appCard_Top">
				<div class="appCard_TopLeft small bg-midgrey fontBold">
					<div class="appCard_Label">{{{link}}}</div>
				</div>
				<div class="appCard_TopRight">
					<div class="appCard_Label alignCentre">{{#switch}}<i class="fa fa-exchange textBlue left-5"><xsl:attribute name="onclick">selectApp('{{this.id}}');getAllApps();$("#application").val('{{this.id}}').prop('selected', true).change()</xsl:attribute></i>{{/switch}}</div>
				</div>
			</div>
			<div class="appCard_Middle">
                <div class="appCard_Section50pc appCard_Divider alert-success"><xsl:attribute name="style">background-color:{{costColour}}</xsl:attribute>
					<div class="appCard_Label xxsmall">
						<i class="fa fa-copy right-5"/>{{getScore score}}%
					</div>
				</div>
				<div class="appCard_Section50pc appCard_Divider">
					<div class="appCard_Label xxsmall">
						<i class="fa essicon-radialdots right-5"/>{{services.length}}
					</div>
				</div>
                
			</div>

			<div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Service Match</div>
				</div>
				<div class="appCard_Section50pc displayTable">
					<div class="appCard_Label xxsmall">{{num}}
						<i class="fa fa-info-circle left-5"></i>
						<div class="text-default small hiddenDiv">
							<h5>Matched Services</h5>
							<ul class="small fa-ul">
								{{#each servicesUsed}}<li><i class="fa fa-li essicon-radialdots"/>{{this.name}}</li>{{/each}}
							</ul>
							
						</div>	
					</div>
				</div>
			</div>
			<div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Codebase</div></div>
				<div class="appCard_Section50pc displayTable">
					<div class="appCard_Label xxsmall">{{nameSubString codebase}}</div>
				</div>
			</div>
			<div class="appCard_Middle">
				<div class="appCard_Section50pc appCard_Divider displayTable impact bg-offwhite">
					<div class="appCard_Label xxxsmall">Lifecycle</div>
				</div>
				<div class="appCard_Section50pc displayTable">
					<div class="appCard_Label xxsmall">{{nameSubString status}}</div>
				</div>
			</div>
		
		
		</div>
        </script>
	</xsl:template>
    
</xsl:stylesheet>
