<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
     <xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
    <xsl:include href="../common/core_handlebars_functions.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"></xsl:variable>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="timeVals" select="/node()/simple_instance[type = ('Disposition_Lifecycle_Status')]"></xsl:variable>
    <!--<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'ap_disposition_lifecycle_status']/value = $timeVals/name]"></xsl:variable>
    -->
	<xsl:variable name="styles" select="/node()/simple_instance[type = ('Element_Style')]"></xsl:variable>
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="appsAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>

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
        <xsl:call-template name="docType"></xsl:call-template>
        <xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsAPI"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Disposition Model</title>
	 			<style>
                    .ess-tag-dotted {
                    	border: 2px dashed #222;
                    }
                    
                    .ess-tag-dotted > a{
                    	color: #333!important;
                    }
                    
                    .ess-tag-default {
                    	background-color: #fff;
                    	color: #333;
                    	border: 2px solid #222;
                    }
                    
                    .ess-tag-default > a{
                    	color: #333!important;
                    }
                    
                    .ess-tag {
                    	padding: 3px 12px;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    	
					}
					.ess-tag-key {
                    	padding: 3px 12px;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    	
                    }
                    .tabcolumn {
                        vertical-align: top;
                    }
                    .but{
                        display:inline-block;
                    }
                    .eas-logo-spinner {​​​​​
                        display: flex;
                        justify-content: center;
                    }​​​​​
                    #editor-spinner {​​​​​
                        height: 100vh;
                        width: 100vw;
                        position: fixed;
                        top: 0;
                        left:0;
                        z-index:999999;
                        background-color: hsla(255,100%,100%,0.75);
                        text-align: center;
                    }​​​​​
                    #editor-spinner-text {​​​​​
                        width: 100vw;
                        z-index:999999;
                        text-align: center;
                    }​​​​​
                    .spin-text {​​​​​
                        font-weight: 700;
                        animation-duration: 1.5s;
                        animation-iteration-count: infinite;
                        animation-name: logo-spinner-text;
                        color: #aaa;
                        float: left;
                    }​​​​​
                    .spin-text2 {​​​​​
                        font-weight: 700;
                        animation-duration: 1.5s;
                        animation-iteration-count: infinite;
                        animation-name: logo-spinner-text2;
                        color: #666;
                        float: left;
                    }​​​​​
				</style> 
			
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
			 	<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Application Disposition Model')"></xsl:value-of>
									</span>
								</h1>
							</div>
						</div>

						<div class="col-xs-12">
							<div class="row">
								<div class="col-sm-6">
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-search"/></span>
										<input type="text" class="form-control" id="applyFilter" placeholder="Filter..." style="width: 200px;"/>
                                <!--    <xsl:text> </xsl:text>
                                    <div class="but"><button id="applyFilterButton" class="btn btn-primary btn-sm">Apply Filter</button></div>
                                   -->
                                    </div>
								</div>
								<div class="col-sm-6">
									<div class="pull-right top-10 bottom-5">
										<strong class="right-10">Legend:</strong>
										<div class="ess-tag-key ess-tag-default">
											<a><xsl:value-of select="eas:i18n('Active Application')"></xsl:value-of></a>
										</div>
									<!--<div class="ess-tag ess-tag-dotted">
											<a><xsl:value-of select="eas:i18n('Retired')"></xsl:value-of></a>
										</div>
									-->
									</div>
								</div>
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
							<table class="table table-bordered" id="timeTable">
								<thead>
									<tr>
										<xsl:apply-templates select="$timeVals" mode="timeHead">
										    <xsl:sort select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/>
										</xsl:apply-templates>
									</tr>
								</thead>
								<tbody id="timeBody" style="overflow-y:auto">
									
								</tbody>
							</table>
						</div>


						<!--Setup Closing Tags-->
					</div>
                </div>
                <script id="data-template" type="text/x-handlebars-template">
                    {{#each this}}
                        <td class="tabcolumn">
                            {{#each this.apps}}
                                <div class="ess-tag ess-tag-dotted"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="style">border: 2pt solid {{this.colour}}</xsl:attribute>
                                    {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                                </div>
                            {{/each}}  
                        </td>
                    {{/each}}
                </script>
                <script>			
                        <xsl:call-template name="RenderViewerAPIJSFunction">
                            <xsl:with-param name="viewerAPIPath" select="$apiApps"></xsl:with-param> 
                         </xsl:call-template>  
                    </script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
			<script id="disposition-template" type="text/x-handlebars-template"></script>
			<script>
                var timeJSON = [<xsl:apply-templates select="$timeVals" mode="timeJSON"><xsl:sort select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/></xsl:apply-templates>];
                var applications;
 
             
				var inScopeApplications=[];
				// console.log(timeJSON)
				// console.log(applications)
				var newList=[];
				$('document').ready(function () {
					
				});
          
			</script>

		</html>
	</xsl:template>
	<xsl:template match="node()" mode="timeHead">
		<xsl:variable name="this" select="current()"></xsl:variable>
		<xsl:variable name="tcount" select="count($timeVals)"></xsl:variable>
		<xsl:variable name="thisStyle" select="$styles[name = current()/own_slot_value[slot_reference = 'element_styling_classes']/value]"></xsl:variable>

		<th class="bg-offwhite">
			<xsl:attribute name="width"><xsl:value-of select="100 div $tcount"></xsl:value-of>%</xsl:attribute>
			<div class="keySample">
				<xsl:attribute name="style">background-color:<xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:attribute>
			</div>
			<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"></xsl:value-of>
		</th>
    </xsl:template>
    
	<xsl:template match="node()" mode="timeJSON">
        <xsl:variable name="this" select="current()"></xsl:variable>
        <xsl:variable name="thisStyle" select="$styles[name = $this/own_slot_value[slot_reference = 'element_styling_classes']/value]"></xsl:variable>
	
	    {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
        </xsl:call-template>", 
        "colour":"<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"></xsl:value-of>",
        "seq":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>"
        }<xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>
    
    <xsl:template name="RenderViewerAPIJSFunction">
            <xsl:param name="viewerAPIPath"></xsl:param> 
            
         	<xsl:call-template name="RenderHandlebarsUtilityFunctions"/>    
            //a global variable that holds the data returned by an Viewer API Report
            var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>'; 
 
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
    
             function showEditorSpinner(message) {
                $('#editor-spinner-text').text(message);                            
                $('#editor-spinner').removeClass('hidden');                         
            };
    
            function removeEditorSpinner() {
                $('#editor-spinner').addClass('hidden');
                $('#editor-spinner-text').text('');
            };
            var dynamicAppFilterDefs=[];
           
           // showEditorSpinner('Fetching Data...');
            $('document').ready(function ()
            {
                dataFragment = $("#data-template").html();
                dataTemplate = Handlebars.compile(dataFragment);
        
                Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
                    return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
                }); 

                var appArray;
               
                Promise.all([
                promise_loadViewerAPIData(viewAPIData),
                
                ]).then(function (responses)
                {
                
                    let workingArray = responses[0]; 
                    filters=responses[0].filters; 
                    filters.sort((a, b) => (a.id > b.id) ? 1 : -1) 
 
                    dynamicAppFilterDefs=filters?.map(function(filterdef){
                        return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
                    });
 
                    var dispostionFragment = $("#disposition-template").html();
                    var dispostionTemplate = Handlebars.compile(dispostionFragment);
                    applications=workingArray;
                  
                    timeJSON.forEach((d)=>{
                        let appList = applications.applications.filter((e)=>{
                            return d.id == e.dispositionId;
                        }); 
                        let currentCol= d.colour;
                        appList.forEach((e)=>{ 
                            e['colour']=currentCol; 
                        })

                        d['apps']=appList;

                    });
                   
                    inScopeApplications=Object.assign({}, workingArray); 
                      

                    $('#timeBody').append(dataTemplate(timeJSON))
               
                   // redrawView()
					$('#applyFilterButton').on('click',function(){ 
                       // showEditorSpinner('Fetching Data...');
                            let pattern=$('#applyFilter').val().toUpperCase(); 
                           
                            if(pattern ==''){
                                newList=applications.applications
                            }
                            else
                            {
                                newList=applications.applications.filter((d)=>{
                                    return d.name.toUpperCase().includes(pattern)
                                })
                            }
                            inScopeApplications.applications=newList;
							$('.ess-tag').hide();
							redrawViewScope()
					})	

                    $('#applyFilter').on('keyup',function(){
							 
                             let pattern=$(this).val().toUpperCase(); 
                             newList=applications.applications.filter((d)=>{
                                 return d.name.toUpperCase().includes(pattern)
                             })
                             inScopeApplications.applications=newList;
                             redrawViewScope()
                     })	

                    // essInitViewScoping(redrawView, ['Group_Actor'], '', true); 
                   essInitViewScoping(redrawView, ['Group_Actor', 'Business_Domain', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS','Product_Concept'],'',true);

                });

                
            });

            let scopedApps=[]; 

            var redrawView=function(){
                essResetRMChanges();
                let typeInfo = {
                    "className": "Application_Provider",
                    "label": 'Application',
                    "icon": 'fa-desktop'
                }

                let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	            let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	            let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
 
                    $('.ess-tag').hide();
                 
                    let appsList=inScopeApplications.applications;
                   scopedApps = essScopeResources(appsList, [appOrgScopingDef, geoScopingDef, visibilityDef].concat(dynamicAppFilterDefs), typeInfo);
        console.log('sa', scopedApps.resources)
                     timeJSON.forEach((d)=>{
                        let appList = scopedApps.resources.filter((e)=>{
                            return d.id == e.dispositionId;
                        });
                        let currentCol= d.colour;
                        appList.forEach((e)=>{ 
                            e['colour']=currentCol; 
                        })

                        d['apps']=appList;

                    })
                  $('#timeBody').html(dataTemplate(timeJSON))
					
				}

				function drawApps(ele){ 
					ele.forEach(element => {
                        $('[easid="'+element.id+'"]').show(); 
						$('[easid="'+element.id+'"]').css({'border-color': element.colour});
						$('[easid="'+element.id+'"]').addClass('ess-tag-default');
					});
                    removeEditorSpinner();
				}

function redrawViewScope() {
	essRefreshScopingValues()
}                
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
