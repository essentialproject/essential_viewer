<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
    <xsl:import href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
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

    <xsl:variable name="allAppProviders" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
    
    <xsl:variable name="appOrgUserRole" select="/node()/simple_instance[(type = 'Group_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Application Organisation User')]"/>
    
    <xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="busCapReportConstant" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $busCapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0BusCaps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
	<xsl:variable name="L1BusCaps" select="$allBusCaps[name = $L0BusCaps/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
    <xsl:variable name="allChildCap2ParentCapRels" select="/node()/simple_instance[type = 'BUSCAP_TO_PARENTBUSCAP_RELATION']"/>
    <xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $allBusCaps/name]"/>
	<xsl:variable name="relevantPhysProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantPhysProc2AppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $relevantPhysProcs/name]"/>
	<xsl:variable name="relevantAppProRoles" select="/node()/simple_instance[name = $relevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
    <xsl:variable name="processToAppRel" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION'][own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value=$allAppProviders/name]"/>
    <xsl:variable name="directProcessToAppRel" select="$processToAppRel[name=$relevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
    <xsl:variable name="directProcessToApp" select="$allAppProviders[name=$directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="relevantApps" select="$allAppProviders[name= $directProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
    <xsl:variable name="relevantApps2" select="$allAppProviders[name = $relevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
    <xsl:variable name="appsWithCaps" select="$relevantApps union $relevantApps2"/>
    <xsl:variable name="allAppOrgUsers2Roles" select="/node()/simple_instance[(name = $appsWithCaps/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appOrgUserRole/name)]"/>

    <xsl:variable name="allLifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
     <xsl:variable name="allElementStyles" select="/node()/simple_instance[type = 'Element_Style']"/>
    <xsl:variable name="BusinessFit" select="/node()/simple_instance[type = 'Business_Service_Quality'][own_slot_value[slot_reference='name']/value=('Business Fit')]"/>
    <xsl:variable name="BFValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value'][own_slot_value[slot_reference='usage_of_service_quality']/value=$BusinessFit/name]"/>
    <xsl:variable name="perfMeasures" select="/node()/simple_instance[type = 'Business_Performance_Measure'][own_slot_value[slot_reference='pm_performance_value']/value=$BFValues/name]"/>
    
    <xsl:variable name="ApplicationFit" select="/node()/simple_instance[type = 'Technology_Service_Quality'][own_slot_value[slot_reference='name']/value=('Technical Fit')]"/>
    <xsl:variable name="AFValues" select="/node()/simple_instance[type = 'Technology_Service_Quality_Value'][own_slot_value[slot_reference='usage_of_service_quality']/value=$ApplicationFit/name]"/>
    <xsl:variable name="appPerfMeasures" select="/node()/simple_instance[type = 'Technology_Performance_Measure'][own_slot_value[slot_reference='pm_performance_value']/value=$AFValues/name]"/>
    <xsl:variable name="unitOfMeasures" select="/node()/simple_instance[type = 'Unit_Of_Measure']"/>
    <xsl:variable name="planningAction" select="/node()/simple_instance[type = 'Planning_Action'][own_slot_value[slot_reference='enumeration_value']/value='Establish']"/>
    <xsl:variable name="plannedChanges" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION'][own_slot_value[slot_reference='plan_to_element_ea_element']/value=$allAppProviders/name][own_slot_value[slot_reference='plan_to_element_change_action']/value=$planningAction/name]"/>
    <xsl:variable name="stratPlans" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan'][own_slot_value[slot_reference='strategic_plan_for_elements']/value=$plannedChanges/name]"/>
    
    <xsl:variable name="allVals" select="$BFValues union $AFValues"/>
    <xsl:variable name="colourElements" select="/node()/simple_instance[type = 'Element_Style'][name=$allVals/own_slot_value[slot_reference='element_styling_classes']/value]"/>
    
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
    <xsl:variable name="allRoadmapInstances" select="$allAppProviders"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>

    <xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="capsSimpleData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
    <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiBCM">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiCaps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsSimpleData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
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
				<title>Business Capability - Application Fit</title>
                <xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
                <style>
                .cap{border:1pt solid #d3d3d3; 
                    height:auto;
                    border-radius:4px;
                    margin-bottom: 15px;
                    padding: 10px;
                    }
                .subCap{
                    min-height:100px;
                    height:auto;
                    margin:2px;}
                .app{
                	border:1pt solid #d3d3d3;
                    border-bottom:0pt solid #d3d3d3;
                    background-color:#fff;
                    min-height:42px;
                    font-weight: 700;
                    width: 100%;
                    padding: 3px;
                    border-radius:4px 4px 0px 0px;
                    text-align:center;
                    box-shadow: 4px 0px 4px -2px #d3d3d3;
                    }
                .outerCap{
                    background-color:#f5f5f5;
                    border-bottom:1pt solid #d3d3d3;
                    border-radius:4px;
                    padding: 5px;
                    width: 100%;
                    margin-bottom: 10px;
                    }
                .appLife{
                	width: 100%;
                    background-color:#d3d3d3;
                    max-height:16px;
                    border-radius: 0px 0px 4px 4px;
                    text-align:center;
                    border:1pt solid #d3d3d3;
                    border-top:1pt solid #fff;
                    box-shadow: 0px 2px 5px -2px hsla(0, 0%, 0%, 0.25);
                    font-size: 8pt;
                    }
                a, a:hover, a:focus, a:active {
				      text-decoration: none;
				      color: inherit;
				 }
                </style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
                <xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<!-- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -->
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
					<div class="clearfix"></div>   
				</div>
                <xsl:call-template name="ViewUserScopingUI"/>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Business Capability - Application Fit</span>
								</h1>
							</div>
						</div>     
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="row">
                                <div class="col-xs-8">
                                	<span class="impact right-30">Filter:</span>
	                            	<label>Type:</label>
	                                <select id="view" class="right-30">
	                                    <xsl:if test="count($ApplicationFit)+count($BusinessFit)=0"><option id="#" value="none">Not Set</option></xsl:if>
	                                    <xsl:if test="$BusinessFit">
	                                        <option id="business" value="business">Business Fit</option></xsl:if>
	                                    <xsl:if test="$ApplicationFit"><option id="technical" value="technical">Technical Fit</option></xsl:if>
                                	</select>                                  
									<label>Capability:</label>
									<select id="capFilter"  class="right-30">
										<option id="all" value="all">All</option>
										<xsl:apply-templates select="$L0BusCaps" mode="appOptions"><xsl:sort order="ascending" select="upper-case(own_slot_value[slot_reference='name']/value)"></xsl:sort></xsl:apply-templates>
									</select>
									<label>Application:</label>
									<select id="appFilter"  class="right-30">
										<option id="all" value="all">All</option>
										<xsl:apply-templates select="$appsWithCaps" mode="appOptions"><xsl:sort order="ascending" select="upper-case(own_slot_value[slot_reference='name']/value)"></xsl:sort></xsl:apply-templates>
									</select>
                                </div>
                               
								<div class="col-xs-4"> 
									<div style="float:right;min-width:360pt" id="busKey">
										<table style="padding:2px;font-size:9pt;text-align:center">
											<tbody>
												<tr>
													<xsl:apply-templates select="$BFValues" mode="legend">
														<xsl:sort select="own_slot_value[slot_reference='service_quality_value_score']/value" order="descending"/>
													</xsl:apply-templates>
												</tr>
											</tbody>
										</table>
									</div>
									<div style="float:right;display:none;min-width:360pt" id="appKey">
									 
												<xsl:apply-templates select="$AFValues" mode="legend">
													<xsl:sort select="own_slot_value[slot_reference='service_quality_value_score']/value" order="descending"/>
												</xsl:apply-templates>
											 
								</div>
							</div>
						</div>
						<hr/>
					</div>
					<div class="col-xs-12">
						<div id="capmodel"/>
					</div>

						<!--Setup Closing Tags-->
					</div>
				</div>
<script>
                             
                            var scoreColours=[<xsl:apply-templates mode="getColours" select="$allVals"/>];
                                    
                               bcmData= {
                                    "bcm": [
                                        <xsl:apply-templates mode="RenderCaps" select="$rootBusCap">
                                            <xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
                                        </xsl:apply-templates>
                                    ]   
                                }
                                    
                                    
                                </script>
<script>
   
    
    var busscores=[<xsl:apply-templates select="$BFValues" mode="getScores"/>]
    var appscores=[<xsl:apply-templates select="$AFValues" mode="getScores"/>]
    
    var bcm;
    var colourToShow;
    var fontToShow;
    
    var filterState = {};
    
    
     $(document).ready(function(){  
            let initState = {
                "fitTypeId": "<xsl:choose><xsl:when test="count($ApplicationFit) + count($BusinessFit) = 0">none</xsl:when><xsl:when test="$BusinessFit">business</xsl:when><xsl:when test="$ApplicationFit">technical</xsl:when></xsl:choose>",
                "busCapId": "all",
                "appId": "all"
           };
            essInitViewState(filterState, initState);
            $('#view').val(filterState.state.fitTypeId).trigger('change');
            

            var capFragment = $("#cap-template").html();
            capTemplate = Handlebars.compile(capFragment); 
    
            bcmData.bcm[0].l1BusCaps.forEach(function(d){
                d.l2BusCaps.forEach(function(e){
        
                    result = [];
                            arr=e.subApps;
                            arr.forEach(function (a) {
                            var count=0;
                                if (!this[a.id]) {
                                    this[a.id] = { name: a.id, busScore: 0 , appScore:0, count : 0};
                                    result.push(this[a.id]);
                                }

                                this[a.id].busScore += parseInt(a.busScore);
                                this[a.id].appScore += parseInt(a.appScore);
                                this[a.id].count += count+1;
                            a['avg']=this[a.id];
                            }, Object.create(null));

                        

                    uniq=uniq_fast(e.subApps);

                        e['subApps']=uniq;
                
            
                    e['showApps']=e.subApps;
                });
            });
    
            $('#capmodel').append(capTemplate(bcmData.bcm[0]));  
    
            bcm= [bcmData.bcm[0]];
    
    
            $('#view').change(function(){  
                filterState.state.fitTypeId = $(this).val();
                essUpdateUserSettings();
                applySelect();
            });


             essInitViewScoping(redrawView);
            //redrawView();
            //applySelect();
    
    $('#capFilter').change(function(){
        filterState.state.busCapId = $(this).val();
        essUpdateUserSettings();
     var thisID=$(this).children(":selected").attr("id");
     if(thisID==='all'){
        $('.cap').show();
        }
    else
        {
        $('.cap').hide();
       
        $('.'+thisID).show();
        }
    })
    
    $('#appFilter').change(function(d){
        
        var thisID=$(this).children(":selected").attr("id");
        filterState.state.appId = $(this).val();
        essUpdateUserSettings();
        if(thisID==='all'){
                $('.app').fadeTo(500,1);
                $('.appLife').fadeTo(500,1);
            }else
            {
                $('.app').fadeTo(300, 0.1);
                $('.appLife').fadeTo(300, 0.1)
                $('*[data-appid='+thisID+']').fadeTo(500,1);
            }
        });
        
        $('#capFilter').val(filterState.state.busCapId).trigger('change');
        $('#appFilter').val(filterState.state.appId).trigger('change');
        //applySelect();
   });
                
    var applySelect = function(){

    
        //var filter = $('#view').children(":selected").attr("id");
        var filter = filterState.state.fitTypeId;
     
       bcm[0].l1BusCaps.forEach(function(d){
            d.l2BusCaps.forEach(function(e){
   
                e.subApps.forEach(function(f){  
                var busFitscore = Math.round(f.avg.busScore / f.avg.count);
                var appFitscore =  Math.round(f.avg.appScore / f.avg.count);
                 if(filter==='business'){
                    $('#appKey').hide();
                    $('#busKey').show();        
    
                var thisCols = scoreColours.filter(function(e){
                        if(e.id===f.busFitVal){
                        return e.id===f.busFitVal;
                        }
                       
                    });
             

        if(thisCols.length &gt; 0){
         
               
                var thisBus = busscores.filter(function(g){
                    return g.score==busFitscore
                })
	
			if(thisBus[0]){	

				colourToShow=thisBus[0].backgroundcolor;
				fontToShow=thisBus[0].color;
    			}
				else
				{
				colourToShow =  '#e3e3e3';
                fontToShow = '#000000';
			   };
            }else
            {
                colourToShow =  '#e3e3e3';
                fontToShow = '#000000';
            }
  
                    }else
                if(filter==='technical'){
                    $('#appKey').show();
                    $('#busKey').hide();
     var thisCols = scoreColours.filter(function(e){
                        if(e.id===f.techFitVal){
                        return e.id===f.techFitVal;
                        }
                       
                    });
      if(thisCols.length &gt; 0){
             var thisApp = appscores.filter(function(g){
                    return g.score==appFitscore;
                })
                 
			if(thisApp[0]){	
	
				 colourToShow=thisApp[0].backgroundcolor;
            	 fontToShow=thisApp[0].color;
    			}
				else
				{
				colourToShow =  '#e3e3e3';
                fontToShow = '#000000';
			   };
           
            }else
            {
                colourToShow =  '#e3e3e3';
                fontToShow = '#000000';
            }
                        }
            
    <!--
                if(f.plans){
                    var thisDate= new Date(f.plans);
                    var today= new Date();
                        if((thisDate - today)&gt;0){
                            colourToShow =  '#fffff';
                            fontToShow = '#000000';
                        };
        
                    }
        -->
                   $('.'+f.capappid).css({"background-color":colourToShow,"color":fontToShow});
                });
             });
            });
        };
    
 var redrawView = function() {

    let appArrayList=[];
    
         bcm[0].l1BusCaps.forEach(function(d){
                d.l2BusCaps.forEach(function(e){
            appArrayList.push(e.subApps);
            });
        });
 <xsl:if test="$isRoadmapEnabled">
     if(roadmapEnabled) {
        rmSetElementListRoadmapStatus(appArrayList);
        }
    </xsl:if>
            bcm[0].l1BusCaps.forEach(function(d){
                d.l2BusCaps.forEach(function(e){
                    let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
            console.log(e.subApps)  
                    let scopedSubApps = essScopeResources(e.subApps, [appOrgScopingDef]);
                    
                    let appsForRM;
                    if(roadmapEnabled) {
                        appsForRM = rmGetVisibleElements(scopedSubApps.resources);
                    }else {
                    appsForRM = scopedSubApps.resources;
                    }
            
                    e['showApps']=appsForRM;
              });
           });
      $('#capmodel').empty();
	
	console.log(bcmData.bcm[0]);
	
      $('#capmodel').append(capTemplate(bcmData.bcm[0]));  
        applySelect();
}
    
    
function uniq_fast(a) {
    var seen = {};
    var out = [];
    var len = a.length;
    var j = 0;
    for(var i = 0; i &lt; len; i++) {
         var item = a[i].id;
         var itemParent=a[i];    
         if(seen[item] !== 1) {
               seen[item] = 1;
               out[j++] = itemParent;
         }
    }
    return out;
}        
</script>
				<script>
					Handlebars.registerHelper('grouped_each', function(every, context, options) {
				    var out = "", subcontext = [], i;
				    if (context &amp;&amp; context.length > 0) {
				        for (i = 0; i &lt; context.length; i++) {
				            if (i > 0 &amp;&amp; i % every === 0) {
				                out += options.fn(subcontext);
				                subcontext = [];
				            }
				            subcontext.push(context[i]);
				        }
				        out += options.fn(subcontext);
				    }
				    return out;
				});
                    
				</script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
    	<script id="cap-template" type="text/x-handlebars-template">
            <div class="row">
            	<div class="col-xs-12 bottom-10">
            		<div class="xlarge">{{this.name}}</div>	
            	</div>
            	{{#each this.l1BusCaps}}
            	<div class="col-xs-12">
                	<div>
                		<xsl:attribute name="class">cap {{this.id}}</xsl:attribute>
	               		<div class="impact large bottom-10">{{this.name}}</div>
                		{{#grouped_each 3 this.l2BusCaps}}
                		<div class="row">
                    	{{#each this}}
                    		<div class="col-xs-12 col-sm-6 col-md-4">
                    			<div class="outerCap pull-left">
                        			<div class="subCap">
                        				<div class="large strong bottom-10">{{this.name}}</div>
                        				<div class="row">
                        					{{#each showApps}}
	                              			<div class="col-xs-4">
	                              				<div class="app-wrapper bottom-10">
		                                  			<div>
														
		                                  				<xsl:attribute name="class">app xsmall {{../this.id}}{{this.id}}</xsl:attribute>
		                                  				<xsl:attribute name="id">{{../this.id}}{{this.id}}</xsl:attribute>
		                                  				<xsl:attribute name="data-appid">{{this.id}}</xsl:attribute>
														
														{{{this.link}}}
		                                  			</div>  
		                                  			<div class="appLife small">
		                                  				<xsl:attribute name="style">background-color:{{this.lifecycleColor}};color: {{this.lifecycleText}}</xsl:attribute>
		                                  				<xsl:attribute name="data-appid">{{this.id}}</xsl:attribute>
		                                  				{{this.lifecycle}}
		                                  			</div>
	                              				</div>
	                              			</div>
                                            {{/each}}
                        				</div>
                            		</div>
                        		</div>    
                    		</div>
                    	{{/each}}
                    </div>
                		{{/grouped_each}}
                </div>
            </div>
            {{/each}}
        </div>
	</script>
            
            </body>
            <script>			
                    <xsl:call-template name="RenderViewerAPIJSFunction">
                            <xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
                            <xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param> 
                    </xsl:call-template>   
                </script>
		</html>
	</xsl:template>
<xsl:template mode="RenderCaps" match="node()">
        <xsl:variable name="rootBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
	{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="$rootBusCapName"/>",
        "description": "<xsl:value-of select="eas:renderJSText($rootBusCapDescription)"/>",
        "link": "<xsl:value-of select="$rootBusCapLink"/>",
        "l1BusCaps": [
		<xsl:apply-templates select="$L0BusCaps" mode="l0_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
        
<!--        
		{
		"l0BusCapId": "<xsl:value-of select="current()/name"/>",
		"l0BusCapName": "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
        "l0BusCapDescription": "<xsl:value-of select="eas:renderJSText(current()/own_slot_value[slot_reference = 'description']/value)"/>",
        "l0BusCapLink": "link",
        "l1BusCaps": [
		<xsl:apply-templates select="$L0BusCaps" mode="l0_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates>
		]
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
-->
	</xsl:template>

	<xsl:template match="node()" mode="l0_caps">
		<xsl:variable name="L1Caps" select="$allBusCaps[name = current()/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
		 <xsl:variable name="thisBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="$thisBusCapName"/>",
		"description": "<xsl:value-of select="$thisBusCapDescription"/>",
		"link": "<xsl:value-of select="$thisBusCapLink"/>",
		"l2BusCaps": [	
        <xsl:apply-templates select="$L1Caps" mode="l1_caps">
			<xsl:sort select="own_slot_value[slot_reference = 'business_capability_index']/value"/>
		</xsl:apply-templates> ]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template> 
    
	<xsl:template match="node()" mode="l1_caps">
        <xsl:variable name="thisCap" select="current()/name"></xsl:variable>
		 <xsl:variable name="thisBusCapName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapDescription">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisBusCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
    <!--    <xsl:variable name="thisrelevantBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = current()/name]"/>
        <xsl:variable name="thisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $thisrelevantBusProcs/name]"/>
        <xsl:variable name="thisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $thisrelevantPhysProcs/name]"/>
        <xsl:variable name="thisrelevantAppProRoles" select="$relevantAppProRoles[name = $thisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
        <xsl:variable name="thisdirectProcessToAppRel" select="$processToAppRel[name=$thisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
        <xsl:variable name="thisdirectProcessToApp" select="$directProcessToApp[name=$thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
        <xsl:variable name="thisrelevantApps" select="$relevantApps[name= $thisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
        <xsl:variable name="thisrelevantApps2" select="$relevantApps2[name = $thisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
        <xsl:variable name="thisappsWithCaps" select="$thisrelevantApps2"/>
        -->
        
        <xsl:variable name="relevantBusCaps" select="eas:findAllSubCaps(current(), ())"/>
        
        <xsl:variable name="sthisrelevantBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
        <xsl:variable name="sthisrelevantPhysProcs" select="$relevantPhysProcs[own_slot_value[slot_reference = 'implements_business_process']/value = $sthisrelevantBusProcs/name]"/>
        <xsl:variable name="sthisrelevantPhysProc2AppProRoles" select="$relevantPhysProc2AppProRoles[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $sthisrelevantPhysProcs/name]"/>
        <xsl:variable name="sthisrelevantAppProRoles" select="$relevantAppProRoles[name = $sthisrelevantPhysProc2AppProRoles/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
        <xsl:variable name="sthisdirectProcessToAppRel" select="$processToAppRel[name=$sthisrelevantPhysProcs/own_slot_value[slot_reference = 'phys_bp_supported_by_app_pro']/value]"/>
        <xsl:variable name="sthisdirectProcessToApp" select="$directProcessToApp[name=$sthisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
        <xsl:variable name="sthisrelevantApps" select="$relevantApps[name= $sthisdirectProcessToAppRel/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
        <xsl:variable name="sthisrelevantApps2" select="$relevantApps2[name = $sthisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
        <xsl:variable name="sthisappsWithCaps" select="$sthisrelevantApps union $sthisrelevantApps2"/>
        <xsl:variable name="allProcs" select="$sthisdirectProcessToAppRel union $sthisrelevantPhysProc2AppProRoles"/>
       

        
        
        <xsl:variable name="this" select="current()/name"/>
		{
			  "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		      "name": "<xsl:value-of select="$thisBusCapName"/>",
		      "description": "<xsl:value-of select="$thisBusCapDescription"/>",
		      "link": "<xsl:value-of select="$thisBusCapLink"/>",
        "debug1":"<xsl:value-of select="count($sthisdirectProcessToAppRel)"/>",
         "debug2":"<xsl:value-of select="count($sthisrelevantPhysProc2AppProRoles)"/>",
        "subAppDirect":"<xsl:value-of select="$sthisrelevantApps/name"/>",
        "subApps":[
        <xsl:for-each select="$allProcs">
            <!-- GET APP IN THE RELATION USING sthisappsWithCaps -->
            <xsl:variable name="thisDirectApp" select="$sthisrelevantApps[name = current()/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
            <!-- set  the org id list for the apps -->
            <xsl:variable name="thisAppProRole" select="$sthisrelevantAppProRoles[name = current()/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
            <xsl:variable name="thisIndirectApp" select="$sthisrelevantApps2[name = $thisAppProRole/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
            <xsl:variable name="thisApp" select="$thisDirectApp union $thisIndirectApp"/>
            <xsl:variable name="thisAppOrgUsers2Roles" select="$allAppOrgUsers2Roles[name = $thisApp/own_slot_value[slot_reference = 'stakeholders']/value]"/>
            <xsl:variable name="thisOrgUserIds" select="$thisAppOrgUsers2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/>

            <xsl:variable name="thisPerfMeasure" select="$perfMeasures[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/>
             <xsl:variable name="thisBFValues" select="$BFValues[name=$thisPerfMeasure/own_slot_value[slot_reference='pm_performance_value']/value]"/>
         <xsl:variable name="busFit" select="$thisBFValues/own_slot_value[slot_reference='service_quality_value_value']/value"/>
         <xsl:variable name="busScore" select="$thisBFValues/own_slot_value[slot_reference='service_quality_value_score']/value"/>      
         <xsl:variable name="thisFitVal" select="$unitOfMeasures[name=$thisBFValues/own_slot_value[slot_reference='service_quality_value_uom']/value]"/>  
            
        <xsl:variable name="thisAppPerfMeasure" select="$appPerfMeasures[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="thisAFValues" select="$AFValues[name=$thisAppPerfMeasure/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <xsl:variable name="appFit" select="$thisAFValues/own_slot_value[slot_reference='service_quality_value_value']/value"/>
        <xsl:variable name="appScore" select="$thisAFValues/own_slot_value[slot_reference='service_quality_value_score']/value"/>        
        <xsl:variable name="thisAppFitVal" select="$unitOfMeasures[name=$thisAFValues/own_slot_value[slot_reference='service_quality_value_uom']/value]"/>  
            

        <xsl:variable name="subthisrelevantAppProRoles" select="$relevantAppProRoles[name = current()/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
        <xsl:variable name="subthisrelevantApps" select="$relevantApps2[name = $subthisrelevantAppProRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
        <xsl:variable name="subthisrelevantAppsDirect" select="$relevantApps[name = current()/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>  
        <xsl:variable name="indirectappLifecycle" select="$allLifecycleStatus[name = $subthisrelevantApps/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]"/>
		<xsl:variable name="directappLifecycle" select="$allLifecycleStatus[name = $subthisrelevantAppsDirect/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]"/>	
		  <xsl:variable name="appLifecycle" select="$indirectappLifecycle union $directappLifecycle"/>	
        <xsl:variable name="thisStyle" select="$allElementStyles[name=$appLifecycle/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>   
        <xsl:variable name="allAppPlans" select="$sthisappsWithCaps union subthisrelevantApps" />   
         <xsl:variable name="thisplannedChanges" select="$plannedChanges[own_slot_value[slot_reference='plan_to_element_ea_element']/value=$subthisrelevantApps/name]"/>
        <xsl:variable name="thisstratPlans" select="$stratPlans[own_slot_value[slot_reference='strategic_plan_for_elements']/value=$thisplannedChanges/name]"/>    
       <xsl:if test="$subthisrelevantApps union $subthisrelevantAppsDirect">    
      {<xsl:choose><xsl:when test="$subthisrelevantApps"><xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="$subthisrelevantApps"/><xsl:with-param name="theDisplayInstance" select="$subthisrelevantApps"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template></xsl:when><xsl:otherwise> <xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="$subthisrelevantAppsDirect"/><xsl:with-param name="theDisplayInstance" select="$subthisrelevantAppsDirect"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template></xsl:otherwise></xsl:choose>,    
          <!--  "id":"<xsl:choose><xsl:when test="$subthisrelevantApps"><xsl:value-of select="eas:getSafeJSString($subthisrelevantApps/name)"/></xsl:when><xsl:otherwise><xsl:value-of select="eas:getSafeJSString($subthisrelevantAppsDirect/name)"/></xsl:otherwise></xsl:choose>",-->
            "capappid":"<xsl:value-of select="eas:getSafeJSString($this)"/><xsl:value-of select="eas:getSafeJSString($subthisrelevantApps/name)"/><xsl:value-of select="eas:getSafeJSString($subthisrelevantAppsDirect/name)"/>",<!--"name":"<xsl:choose><xsl:when test="$subthisrelevantApps"><xsl:value-of select="eas:renderJSText($subthisrelevantApps/own_slot_value[slot_reference='name']/value)"/></xsl:when><xsl:otherwise><xsl:value-of select="eas:renderJSText($subthisrelevantAppsDirect/own_slot_value[slot_reference='name']/value)"/></xsl:otherwise></xsl:choose>",-->
        "debug":"", 
        "orgUserIds": [<xsl:for-each select="$thisOrgUserIds">"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>],
        "busScore":"<xsl:value-of select="$busScore"/>", 
        "busFit":"<xsl:value-of select="$busFit"/>","busFitVal":"<xsl:value-of select="$thisBFValues/name"/>",
        "techFit":"<xsl:value-of select="$appFit"/>",
        "appScore":"<xsl:value-of select="$appScore"/>","techFitVal":"<xsl:value-of select="$thisAFValues/name"/>", "lifecycle":"<xsl:value-of select="$appLifecycle/own_slot_value[slot_reference = 'enumeration_value']/value"/>","lifecycleColor":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"/></xsl:when><xsl:otherwise>#ebdd8f</xsl:otherwise></xsl:choose>","lifecycleText":"<xsl:choose><xsl:when test="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"><xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_text_colour']/value"/></xsl:when><xsl:otherwise>#000000</xsl:otherwise></xsl:choose>",
        "plans":"<xsl:value-of select="$thisstratPlans/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
			</xsl:if>
        </xsl:for-each> ]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>    
       <xsl:function name="eas:findAllSubCaps">
		<xsl:param name="theParentCap"/>
		<xsl:param name="theChildCaps"/>

		<xsl:choose>
			<xsl:when test="count($theParentCap) > 0">
				<xsl:variable name="childRels" select="$allChildCap2ParentCapRels[(own_slot_value[slot_reference = 'buscap_to_parent_parent_buscap']/value = $theParentCap/name)]"/>
				<xsl:variable name="aChildListA" select="$allBusCaps[name = $childRels/own_slot_value[slot_reference = 'buscap_to_parent_child_buscap']/value]"/>
				<xsl:variable name="aChildListB" select="$allBusCaps[name = $theParentCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>
				<xsl:variable name="aChildList" select="$aChildListA union $aChildListB"/>
				<xsl:variable name="aNewList" select="$aChildList except $theParentCap"/>
				<xsl:variable name="aNewChildren" select="$theParentCap union $theChildCaps union $aNewList"/>
				<xsl:copy-of select="eas:findAllSubCaps($aNewList, $aNewChildren)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$theChildCaps"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

    <xsl:template match="node()" mode="appOptions">
        <xsl:variable name="this" select="current()"/>
        <option id="{eas:getSafeJSString($this/name)}" value="{eas:getSafeJSString($this/name)}"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></option>
    </xsl:template>

    <xsl:template match="node()" mode="getColours">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thiscolourElements" select="$colourElements[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
      {"id":"<xsl:value-of select="$this/name"/>",
        "score":"<xsl:value-of select="$this/own_slot_value[slot_reference='service_quality_value_score']/value"/>", 
        "thiscolor":"<xsl:value-of select="$thiscolourElements/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
        "backgroundcolor":"<xsl:value-of select="$thiscolourElements/own_slot_value[slot_reference='element_style_colour']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>

     <xsl:template match="node()" mode="legend">
         <xsl:variable name="thiscolourElements" select="$colourElements[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
         <div class="pull-right"><xsl:attribute name="style">background-color:<xsl:value-of select="$thiscolourElements/own_slot_value[slot_reference='element_style_colour']/value"/>;color:<xsl:value-of select="$thiscolourElements/own_slot_value[slot_reference='element_style_text_colour']/value"/>;border-radius:3px;margin-left:2px;padding:2px;width:70px;font-size:8pt;text-align:center</xsl:attribute><xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/></div>
     </xsl:template>

	<xsl:template match="node()" mode="getApplications">	
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,
		"link":"<xsl:value-of select="$thisLink"/>"}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>

<!--	<xsl:template match="node()" mode="getApplications">		
		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>  -->

    <xsl:template match="node()" mode="getScores">	
         <xsl:variable name="thiscolourElements" select="$colourElements[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
        {"id":"<xsl:value-of select="current()/name"/>","name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>","score":"<xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"/>","backgroundcolor":"<xsl:value-of select="$thiscolourElements/own_slot_value[slot_reference='element_style_colour']/value"/>","color":"<xsl:value-of select="$thiscolourElements/own_slot_value[slot_reference='element_style_text_colour']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
    
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
    <xsl:template match="node()" mode="roadmapCaps">
            {<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,}<xsl:if test="not(position() = last())"><xsl:text>,
          </xsl:text></xsl:if> 
    </xsl:template>
    <xsl:template name="RenderViewerAPIJSFunction">
            <xsl:param name="viewerAPIPath"></xsl:param> 
            <xsl:param name="viewerAPIPathCaps"></xsl:param>
            //a global variable that holds the data returned by an Viewer API Report
            var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
            var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>';
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
   

            $('document').ready(function () {
                
                const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
    
                function essGetMenuName(instance) {
                    let menuName = null;
                    if ((instance != null) &amp;&amp;
                        (instance.meta != null) &amp;&amp;
                        (instance.meta.classes != null)) {
                        menuName = instance.meta.menuId;
                    } else if (instance.classes != null) {
                        menuName = instance.meta.classes;
                    }
                    return menuName;
                }
                
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
                let busCapArr = [];
                Promise.all([
                    promise_loadViewerAPIData(viewAPIData),
                    promise_loadViewerAPIData(viewAPIDataCaps)
                ]).then(function (responses) {
                    meta = responses[0].meta;
                    busCapArr = responses[0].busCaptoAppDetails;
                    busCapInfo = responses[1]
                    
                    console.log(responses[0])
    
                    busCapArr.forEach((d) => {
                        var thisCap = busCapInfo.businessCapabilities.filter((e) => {
                            return d.id == e.id;
                        });
                        <!--required for roadmap
                        var thisRoadmap = roadmapCaps.filter((rm) => {
                            return d.id == rm.id;
                        });
    
                        if(thisRoadmap[0]){
                            d['roadmap'] = thisRoadmap[0].roadmap;
                            }else{
                                d['roadmap'] = [];
                            } 
                         end required	for roadmap-->
                        d['desc'] = thisCap[0].description;
                        d['domain'] = {
                            'name': thisCap[0].businessDomain,
                            'id': d.domainIds[0]
                        };
                        d['meta'] = meta.filter((d) => {
                            return d.classes.includes('Business_Capability')
                        })
                    });
    
                });
    
            });
      
        </xsl:template>   
</xsl:stylesheet>
