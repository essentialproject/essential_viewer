<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
   
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
    <xsl:variable name="rationalAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: App Rationalisation API']"/>
 

	<xsl:template match="knowledge_base">
        <xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$rationalAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
		<html>
			<head>
              <script src="js/d3/d3_4-11/d3.min.js"/>
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
                        width:216px;
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
                    .costApp {
                        border:1pt solid #d3d3d3;
                        box-shadow: 3px 3px #e2e2e2;
                        border-radius:3px;
                        border-left:3px solid #8241ea;
                        font-family:14pt;
                        background-color:#ffffff;
                        padding:3px;
                        margin:3px;
                        font-size:1.05em;
                        min-height:40px}
                    .costNum {
                        border:1pt solid #d3d3d3;
                        box-shadow: 3px 3px #e2e2e2;
                        border-radius:3px;
                        font-family:14pt;
                        padding:3px;
                        margin:3px;
                        min-height:40px}   
                    .costClose{
                            border:1pt solid #d3d3d3;
                            box-shadow: 3px 3px #e2e2e2;
                            border-radius:3px;
                            padding:3px;margin:3px
                            }
                    .costBox {
                        box-shadow:3px 3px 8px #d3d3d3;
                        font-size:13pt;
                        border-radius:0px;
                        margin-left:0px;
                        margin-right:0px;
                        padding:3px;
                        padding-left:10px;
                        padding-right:10px;
                        margin-bottom:20px;margin-top:20px;
                        border:1pt solid #d3d3d3}   
                    .optionsBox {
                        border:0pt solid #644f4f;
                        box-shadow: 3px 3px 8px #b5b5b5;
                        border-radius:3px;
                        padding:3px;margin:5px;
                        margin-top:10px;
                        backgrouns-color:#f7f7f7;
                        }
                    .optionText{
                        position:relative;top:0pt;margin-left:20px;border-radius:1px;font-size:8pt;padding:3pt; border:1pt solid #d3d3d3;background-color:#676767;color:#ffffff;width:100px;font-weight:bold;    
                        }
                    .optioncommentText{
                        position:relative;top:-15pt;margin-left:10px;border-radius:1px;font-size:8pt;padding:3pt; border:1pt solid #d3d3d3;background-color:#676767;color:#ffffff;width:100px;font-weight:bold;    
                        }
                    .commentText{
                        position:relative;
                        top:9pt;
                        margin-left:20px;
                        border-radius:1px;
                        font-size:9pt;
                        padding:3px; 
                        border:1pt solid #d3d3d3;
                        background-color:#676767;
                        color:#ffffff;
                        width:100px;
                        font-weight:bold;    
                        }
                    .removeApp{color:red}     
                </style>
                <link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
                <script>
                        var appCardTemplate;
						var sourceReport='<xsl:value-of select="$param1"/>';
                        $(document).ready(function(){
                            $('select').select2({theme: "bootstrap"});
                            
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

                    
							Handlebars.registerHelper('getCost', function(cost, options) {
								if (cost != null){
									return parseInt(cost).toLocaleString();
								}
								else {return '-'}
							});
                    
                           
							$(".myInterfaceRange").on('change',function(){
								  updateCards();
								});
							$(".ticks").on('change',function(){
								  updateCards();
								});		
					
					
            });

       //end of ready          
       function goBack() {
						  window.history.back();
						};  
                        function showFocusType(){
                        		var radioValue = $("input[name='focusType']:checked").val();
                        		if(radioValue == 'radioService'){
                                    $('#selBox').val(null).trigger('change');
                                    $("#application").val(null).trigger('change');
						        	$('#appSearch').hide();
						        	$('#servSearch').show();
						        }
						        else if(radioValue == 'radioApp'){
                                    $('#application').val(null).trigger('change');
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Rationalisation Analysis')"/></span>
								</h1>
							</div>
						</div>
					<ul class="nav nav-tabs">
                      <li class="active"><a data-toggle="tab" href="#home"><xsl:value-of select="eas:i18n('Analysis')"/></a></li>
                    </ul>

                    <div class="tab-content">
                      <div id="home" class="tab-pane fade in active">
                        <div class="col-xs-2">
                        	<h3 class="text-primary"><xsl:value-of select="eas:i18n('Search by')"/>:</h3>
                        	
							<label><input class="radio-inline" type="radio" name="focusType" value="radioApp" onclick="showFocusType()" checked="checked" id="radioApp"/><xsl:value-of select="eas:i18n('Application')"/></label>
							<label><input class="radio-inline" type="radio" name="focusType" value="radioService"  onclick="showFocusType()"/><xsl:value-of select="eas:i18n('Service')"/></label>
                        	
							<div id="appSearch" class="top-15">
							    <h3 class="text-primary" style="display:inline-block"><xsl:value-of select="eas:i18n('Focus Application')"/></h3>
							    <div class="form-group span-3">
									<select id="application" class="form-control select2" style="width:100%;">
							           <option value="1selectOne" selected="true" disabled="true"><xsl:value-of select="eas:i18n('Select an Application')"/></option>
							           <!-- <xsl:apply-templates select="$apps" mode="getOptions">
							                <xsl:sort select="upper-case(own_slot_value[slot_reference='name']/value)" order="ascending"/>
							            </xsl:apply-templates>
                                        -->
									</select>
							    </div>
							</div>
							            
							<div id="servSearch" class="top-15 hiddenDiv"> 
							    <h3  class="text-primary" style="display:inline-block"><xsl:value-of select="eas:i18n('Select Services')"/></h3>
								<select class="servicesNew select2" name="servicesOnlt" multiple="multiple" style="width:100%;" id="selBox">
							       
								</select>
							    <button class="btn btn-sm btn-default top-5" onclick="selectNewApp();showInfoTooltips();">Go</button>
							</div>
							<div id="services" class="top-15"> 
								<h3 class="text-primary"><xsl:value-of select="eas:i18n('Services')"/></h3>
								<ul id="appServs" class="small fa-ul"/>
								<button id="hide" onclick="$('#appServs').hide();$('#hide').hide();$('#show').show()" class="btn btn-sm btn-default"><xsl:value-of select="eas:i18n('Hide')"/></button>
								<button id="show" onclick="$('#appServs').show();$('#hide').show();$('#show').hide()" class="btn btn-sm btn-default">Show')"/></button>
							</div>
							<div id="carriedApps" style="display:none;border:1pt solid #d3d3d3;border-radius:3px;padding:3px" class="top-15"> 
								<h4><xsl:value-of select="eas:i18n('Application Basket')"/></h4>
								<div id="selPlace"></div>
								<br/>
								<button class="btn btn-primary btn-sm" onclick="goBack()">Back to Previous</button>
							</div>			  
                        </div>	
                        <div class="col-xs-10">
                            <div id="filters">
                            <h3 class="text-primary">Filters</h3>
							
							
							<div class="row">
								 
								
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
								  
								<div class="col-md-2 col-lg-2">
									<div>
										<strong><xsl:value-of select="eas:i18n('Codebase')"/>:</strong>
									</div>
 
									<select multiple="multiple" id="ticks" style="width:100%;" class="ticks">
										<option value="NotDefined"><xsl:value-of select="eas:i18n('Not Defined')"/></option>
									</select>
								</div>
								<div class="col-md-2 col-lg-2">
									<div>
										<strong><xsl:value-of select="eas:i18n('Strategic Lifecycle')"/>:</strong>
									</div>
									<select multiple="multiple" style="width:100%;" id="SLs"/><br/>
                                    <div style="width:100%;text-align:right"><br/><button class="btn btn-xs btn-default left-5" id="reset" onclick="ResetAll()" style="display: inline-block;"><xsl:value-of select="eas:i18n('Reset All Filters')"/></button>
                                    </div>
								</div>
							</div>
							</div>
                            <hr/>
                            	
							<div id="key" class="bottom-15 small" xstyle="display:none">
								<strong class="right-10"><xsl:value-of select="eas:i18n('Legend')"/>:</strong>
                                <i class="fa fa-copy right-5 text-primary" style="color:'+colour+'"></i><xsl:value-of select="eas:i18n('Overlap')"/>
								<span class="left-5 right-5">|</span>
								<i class="fa fa-exchange right-5 textBlue"></i><xsl:value-of select="eas:i18n('Candidates for Replacement by Focus App')"/>
                                <span class="left-5 right-5">|</span>
								
								<i class="fa essicon-radialdots right-5 text-primary"></i><xsl:value-of select="eas:i18n('Total Number of Services')"/>
								<span class="left-5 right-5">|</span>
								  
								
                                <br/>
							</div>
                            <hr /> 
                        	<div id="cardsBlock"/>
		                </div>
                      </div>
                       	 </div>
				</div>
                </div> 

				<!-- ADD THE PAGE FOOTER
				<xsl:call-template name="Footer"/> -->
                <script>      
                    <xsl:call-template name="RenderViewerAPIJSFunction">
                        <xsl:with-param name="viewerAPIPath" select="$apiPath"/> 
                    </xsl:call-template>
                </script>     
            </body>
            <script id="app-card-template" type="text/x-handlebars-template">
            <div>
                <xsl:attribute name="class">carddiv {{this.codebaseID}} s{{this.statusID}} appCard_Container</xsl:attribute>
                <xsl:attribute name="id">{{this.id}}</xsl:attribute>
                <xsl:attribute name="data-num">{{this.num}}</xsl:attribute>  
               
                <div class="appCard_Top">
                    <div class="appCard_TopLeft small bg-midgrey fontBold">
                        <div class="appCard_Label">{{{link}}}</div>
                    </div>
                    <div class="appCard_TopRight">
                        <div class="appCard_Label alignCentre"> {{#switch}}
                        <i class="fa fa-exchange textBlue left-5"><xsl:attribute name="onclick">selectApp('{{this.id}}');getAllApps();$("#application").val('{{this.id}}').prop('selected', true).change()</xsl:attribute></i>{{/switch}}</div>
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
		</html>
	</xsl:template>
    
  
    
    

    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
         <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderAPILinkText"> 
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
        
    </xsl:template>
    <xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/> 
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>'; 
 
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
       
       var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
//console.log(apiDataSetURL);    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
//console.log(this.responseText);  
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
       
        $('#show').hide();
           
           var currency
              var appJSON=[];
              var serviceJSON=[]
              var allStatus
  
              var appoptions  
              
              var services 
              var focusServices;       
              var focusedServices=0;  
              var focusProcesses=[];
              var clickedArray=[]; 
              
               function selectNewApp(){
                  $("#appServs").empty();
                  alli=$(".servicesNew").val();
                  var selitems=[];	
                  $('.servicesNew option:selected').each(function(){ selitems.push({"selectId":$(this).attr('name'),"name":$(this).text()}) });	
                  focusServices=selitems;
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
                                   
             
              function getRelevantApps(){
 
                        Apps=[];
          
                              for(i=0;i &lt; serviceJSON.length;i++){
                              if(focusServices){
                               for(j=0;j &lt; focusServices.length;j++){
                                 if(serviceJSON[i].serviceId==focusServices[j].selectId){
                                      for(k=0;k &lt; serviceJSON[i].applications.length;k++){
                                          Apps.push(serviceJSON[i].applications[k]);
                                          }
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
                
                           getRelevantApps();
 
                          var temp=[];
                          var uniqueApps=Apps.filter((x, i)=> {
                            if (temp.indexOf(x.id) &lt; 0) {
                              temp.push(x.id);
                              return true;
                            }
                            return false;
                          })
    
                            for(i=0;i &lt; uniqueApps.length;i++){
                      
                              var num=0;
                              var numsOfServs='';
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
                              score=((num/thisapp[0].services.length)*100);
                              var colour;
                              if(score &lt; 25){colour='#f5a5a5'}else if(score &gt; 75){colour='#97f0bd'} else {colour='#f5d79d'};
                              appS=[];                    
                              for(j=0;j &lt; thisapp[0].services.length;j++)
                                  {for(k=0;k &lt; focusServices.length;k++)
                                      {
                                          if(thisapp[0].services[j].serviceId==focusServices[k].selectId)
                                          {appS.push({"selectId":thisapp[0].services[j].serviceId,"name":thisapp[0].services[j].service})} 
                                      }  
                                  };
              
                              if(thisapp[0].services.length &lt;= num){
                              thisapp[0]['switch']=true}else{thisapp[0]['switch']=false} 
                              thisapp[0]['servicesUsed']=appS;
                              thisapp[0]['num']=num; 
                              thisapp[0]['numServices']=thisapp[0].services.length; 
                              thisapp[0]['serviceMatch']=appS;  
                              thisapp[0]['score']=score;
                              
   
                              $("#cardsBlock").append(appCardTemplate(thisapp[0]));
              
                              clickedArray.forEach(function(d){
                                    $('.clicked'+d).css('color','green');
                                  });
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
  
                              $('#myRange').attr("max", highest);
   
  
                             var highestInterfaceVal = $(".carddiv").map(function() {
                                  return $(this).data('interface');
                              }).get();//get all data values in an array
  
                              var highestinterface = Math.max.apply(Math, highestInterfaceVal);//find the highest value from them
                              $('.carddiv').filter(function(){
                                  return $(this).data('interface') == highestinterface;//return the highest div
                              });
    
              
                      };
 
            
              
                
              function ResetAll(){
            
              $('#myRange').attr('value',1);;
              $('#ticks').val(null).trigger('change');
              $('#SLs').val(null).trigger('change');
              updateCards();
              }
              
              $('.inverse').on('change',function(){
                updateCards();
              })
           
              
              function updateCards(){
 
              servs= ($('#myRange').val());
              codebase= ($('#ticks').val());
              interfaces=($('#myInterfaceRange').val());
              statusVals=($('#SLs').val());
              
              thisAppCost = appJSON 
              
              if(codebase.length &gt; 0){
              thisAppCode = thisAppCost.filter(function (el) {  
                              
                                   for(var i=0;i &lt; codebase.length; i++){  
                                      if(codebase[i] === el.codebaseID){
                                          return el;
                                          }
                                      else if(codebase[i]==='Not Defined' &amp;&amp; el.codebase ==='Not Defined'){     return el;}
                                       }
                                      });
                      }
                      else
                      {
                          thisAppCode = thisAppCost;
                      }
                          
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
                                                      if(el.services[j].serviceId==focusServices[k].selectId){
                                                          num = num+1;       
                                                          }
                                                      }
                                                      }  
                                                  }
                                              if(num &gt;= servs){
                                                  return el;
                                                  }
                                              });
                     
                      $('.carddiv').hide(); 
              
                      for(var i=0; i &lt; thisAppServices.length; i++){
                              $('#'+thisAppServices[i].id).show();
                              
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
  
        $('document').ready(function () {
    
              Promise.all([
                promise_loadViewerAPIData(viewAPIData) 
            ])
            .then(function(responses) {
                  let viewAPIData = responses[0];
               
              appJSON=viewAPIData.applications;
              serviceJSON=viewAPIData.services;
              codebaseJSON=viewAPIData.codebase;
 

            appoptions = d3.nest()
                            .key(function(d) { return d.id; })
                            .entries(appJSON);
            
            services =d3.nest()
                            .key(function(d) { return d.service; })
                            .entries(serviceJSON);

            allStatus=  appJSON.map(function (d) {return d.status;}) ;   
			let unique = allStatus.filter((item, i, ar) => ar.indexOf(item) === i)
       
			unique=sortList(unique);
 
            for(i=0;i &lt; unique.length; i++){
                $('#SLs').append('<option id="s'+unique[i].replace(/\s/g, '')+'" name="s'+unique[i].replace(/\s/g, '')+'" value="'+unique[i]+'">'+unique[i]+'</option>');
            }


            $('#SLs').on('change',function(){
                updateCards();
            });
            $('#ticks').on('change',function(){
                updateCards();
            });

            for(i=0;i&lt; appJSON.length; i++){
                $('#application').append('<option name="'+appJSON[i].id+'" value="'+appJSON[i].id+'">'+appJSON[i].application+'</option>');
            }
            
            for(i=0;i&lt; serviceJSON.length; i++){
                $('#selBox').append('<option name="'+serviceJSON[i].serviceId+'" value="'+serviceJSON[i].serviceId+'">'+serviceJSON[i].service+'</option>');
            }

            for(i=0;i&lt; codebaseJSON.length; i++){
                $('#ticks').append('<option name="'+codebaseJSON[i].id+'" value="'+codebaseJSON[i].id+'">'+codebaseJSON[i].name+'</option>');
            }
            
            

  function sortList(arr){
            arr.sort(function(a, b){
						if(a &lt; b) { return -1; }
						if(a > b) { return 1; }
						ret;
            });
            return arr
  }          

    $('#application').on('change', function(){
        let thisApp=$(this).val();
    
        selectApp(thisApp);
        getAllApps();
        showInfoTooltips();
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
					
					$('#carriedSelect').change(function(){
						selectApp($(this).val());
						getAllApps();
						showInfoTooltips()
					$('#'+$(this).val()).hide();
					
					});	
                    };	
                    $('#carriedSelect').select2();
					};


		
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
      
          
        
        });
        
    </xsl:template>  
    
</xsl:stylesheet>
