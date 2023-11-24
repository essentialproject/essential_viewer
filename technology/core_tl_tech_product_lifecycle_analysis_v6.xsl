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
    <xsl:variable name="styles" select="/node()/simple_instance[type='Element_Style']"/>
    <xsl:variable name="lifecycles" select="/node()/simple_instance[type='Vendor_Lifecycle_Status']"/>
    
    <xsl:variable name="applifecycles" select="/node()/simple_instance[type='Lifecycle_Status']"/>
    <xsl:variable name="products" select="/node()/simple_instance[type='Technology_Product']"/>
    <xsl:variable name="productLifecycles" select="/node()/simple_instance[type='Lifecycle_Model'][own_slot_value[slot_reference='lifecycle_model_subject']/value=$products/name]"/>
    <xsl:variable name="productsWithLifecycles" select="/node()/simple_instance[type='Technology_Product'][name=$productLifecycles/own_slot_value[slot_reference='lifecycle_model_subject']/value]"/>
    <xsl:variable name="lifecycleStatusUsages" select="/node()/simple_instance[type='Lifecycle_Status_Usage'][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$productLifecycles/name][own_slot_value[slot_reference='lcm_lifecycle_status']/value=$lifecycles/name]"/>
    <xsl:variable name="lifecycletimeRelations" select="/node()/simple_instance[type=':lifecycle-timeline-relation'][own_slot_value[slot_reference=':FROM']/value=$lifecycleStatusUsages/name]"/>
    <xsl:variable name="lifecycletimeliness" select="/node()/simple_instance[type='Lifecycle_Model_Timeline_Point'][name=$lifecycletimeRelations/own_slot_value[slot_reference=':TO']/value]"/>
     <xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
    <xsl:variable name="allTechComponents" select="/node()/simple_instance[type = 'Technology_Component']"/>
     <xsl:variable name="allSupplier" select="/node()/simple_instance[type = 'Supplier'][name=$productsWithLifecycles/own_slot_value[slot_reference='supplier_technology_product']/value]"/>   
    <!-- standards  -->
     <xsl:variable name="allTechstds" select="/node()/simple_instance[type = 'Technology_Provider_Standard_Specification']"/>
     <xsl:variable name="techProdRoleswithStd" select="$allTechProdRoles[name=$allTechstds/own_slot_value[slot_reference='tps_standard_tech_provider_role']/value]"/>
     <xsl:variable name="techComponentsWithStd" select="$allTechComponents[name=$allTechProdRoles/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
    <xsl:variable name="stdValue" select="/node()/simple_instance[type = 'Standard_Strength']"/>
     <!--  tech for app  -->
   
	<xsl:variable name="allTechProvUsage" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference='provider_as_role']/value=$allTechProdRoles/name]"/>
    <xsl:variable name="allTechBuildArch" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference='contained_architecture_components']/value=$allTechProvUsage/name]"/>
	<xsl:variable name="prodDeploymentRole" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference='technology_provider_architecture']/value=$allTechBuildArch/name]"/>
    <xsl:variable name="appDeployment" select="/node()/simple_instance[type = 'Application_Deployment'][own_slot_value[slot_reference='application_deployment_technical_arch']/value=$prodDeploymentRole/name]"/>
    <xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')][own_slot_value[slot_reference='deployments_of_application_provider']/value=$appDeployment/name]"/>
    
    
	<!--
		* Copyright © Enterprise Architecture Solutions Limited.
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

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
                <script type="text/javascript" src="js/d3/d3_4-11/d3.min.js?release=6.19"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Technology Risk</title>
            <style>
                body{font-family:arial}
                
                .card-header:first-child {
                            border-radius: calc(.25rem - 1px) calc(.25rem - 1px) 0 0;
                        }
                        .card-header {
                            padding: .75rem 1.25rem;
                            margin-bottom: 0;
                            background-color: rgba(0,0,0,.03);
                            border-bottom: 1px solid rgba(0,0,0,.125);
                        }
                        .card {
                            font-weight: bold;
                            position: relative;
                            display: -webkit-box;
                            display: -ms-flexbox;
                            display: flex;
                            -webkit-box-orient: vertical;
                            -webkit-box-direction: normal;
                            -ms-flex-direction: column;
                            flex-direction: column;
                            min-width: 0;
                            word-wrap: break-word;
                            background-color: #fff;
                            background-clip: border-box;
                            border: 1px solid rgba(0,0,0,.125);
                            border-radius: .25rem; 
                            margin-bottom:5px;
                            vertical-align: top;
                        }
                        .card-body {
                            margin: 0;
                            font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
                            font-size: 1rem;
                            font-weight: 400;
                            line-height: 1.5;
                            color: #212529;
                            text-align: left;
                            padding:5px;
                            background-color: #fff;
                        }
                        .card-text {font-weight:bold;padding:3px}
                        p.card-text {
                            margin: 0;
                            font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol";
                            font-size: 1rem;
                            font-weight: 400;
                            line-height: 1.5;
                            color: #212529;
                            text-align: left;
                            background-color: #fff;
                        }
                           .grid-container {
                          display: grid;
                          grid-template-columns: 1fr 1fr 1fr 1fr;
                          grid-template-rows: 1fr 1fr 1fr;
                          grid-template-areas: "Focus Focus Focus Card1 ." "Focus Focus Focus Card2 ." "Focus Focus Focus Card3 .";      
                        }

                        .Focus { grid-area: Focus;-webkit-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        -moz-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        box-shadow: 4px 6px 15px 0px rgba(153,153,153,1); 
                                    margin:10px;padding:5px}

                        .Card1 { grid-area: Card1;-webkit-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        -moz-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        box-shadow: 4px 6px 15px 0px rgba(153,153,153,1); min-height:60px;margin:10px;padding:5px; }

                        .Card2 { grid-area: Card2;-webkit-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        -moz-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);min-height:60px; margin:10px;padding:5px; }

                        .Card3 { grid-area: Card3;-webkit-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        -moz-box-shadow: 4px 6px 15px 0px rgba(153,153,153,1);
                        box-shadow: 4px 6px 15px 0px rgba(153,153,153,1); min-height:60px; margin:10px;padding:5px;}
                
                        
                            .verticaltext {
                                transform: rotate(-90deg);
                                transform-origin: right, top;
                                -ms-transform: rotate(-90deg);
                                -ms-transform-origin:right, top;
                                -webkit-transform: rotate(-90deg);
                                -webkit-transform-origin:right, top;
                                position: absolute; 
                                padding-top: 0px;
                                color: #ffffff;
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
							<div class="">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Technology Product Vendor Lifecycles</span>
								</h1>
							</div>
						</div>
                    </div>
                </div>
						<!--Setup Description Section-->
					   <div class="grid-container">
                           <div class="Focus">  
                        <div style="border:1pt solid #d3d3d3;padding: 3px;margin-bottom:10px">
                            <div style="display:inline-block;width:25px;min-height:75px;padding-top:25px;background-color:#000000">
                                <span class="verticaltext">
                                    Filter
                            </span>
                            </div>
                            
                             <div style="margin:0px;display:inline-block;padding-left:5px;border:1pt solid #d3d3d3;border-radius:5px;padding-right:5px;font-size:8pt;vertical-align: top">
                              <div class="form-group">
                                <label for="sel1">Filter By Vendor</label>
                                  <select class="form-control" id="vendorSel" style="font-size:9pt" onchange="filterDate(this.value)">
                                    <option value='all'>All</option>
                                      <xsl:apply-templates select="$allSupplier" mode="getOptions">
                                        <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
                                      </xsl:apply-templates> 
                                  </select>
                                </div> 
                            </div>
                            <div style="margin:0px;display:inline-block;padding-left:10px;border:1pt solid #d3d3d3;border-radius:5px;padding-right:10px;font-size:8pt;vertical-align: top;min-height:72px">
                                <label for="sel1">Filter By Year</label>
                                <table>
                                <tr><td style="text-align:right;font-weight:bold"><div id="thisYr"/></td><td><input type="range" id="yearsRange" name="years"
                                     min="" max="" onchange="filterDate(this.value);$('#currentYr').text(this.value)"/></td><td style="text-align:left;font-weight:bold"><div id="endYr"/></td></tr>
                                </table>
                                <br/>
                                <span style="font-size:9pt">Products supported in <b><div id="currentYr" style="display:inline-block"/></b></span>.
                            </div>
                        </div>
                        
                                <div id="lfbox" />
                            </div> 
                        
                         <div class="Card1" style="border:1pt solid #d3d3d3;border-radius:4px">
                            <h3>Key</h3>
                             <div style="float:left;margin-left:20px;padding-left:0px;width:150px;height:15px;border-left:15px solid #d3d3d3;background-color:#ffffff;color:#000000;font-size:9pt"><xsl:text> </xsl:text> Applications Impacting</div>
                             <div style="display:inline-block;"><span style="font-size: 7pt">(click for detail)</span></div>
                             <div class="col-xs-12"> </div>
                            <div style="float:left;padding-left:20px"><b>Lifecycles</b></div>
                            <div class="col-xs-12"></div>
                            <div id="buttons" style="float:left;padding-left:20px" />
                             <div class="col-xs-12"></div>
                             <div style="float:left;padding-left:20px"><span style="color:#ac2323;font-size:9pt">* Unsupported </span></div>
                           <div class="col-xs-12"> </div>
                            <div style="float:left;padding-left:20px"><b>Standards</b></div>
                            <div class="col-xs-12"></div>
                            <div id="buttonsStd" style="float:left;padding-left:20px" />
                            <div style="float:left;padding-left:20px;font-size:9pt">Unclassified(Off Strategy) <input type='checkbox' id='' onclick='applyFilter(this.checked,this.id)' checked="true"></input></div><br/>
                            <div class="col-xs-12"> <hr/></div>
                            
                        </div>
                        </div>
                        <!-- MODAL -->
                    
                        <div class="modal" tabindex="-1" role="dialog" id="appModal">
                              <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                  <div class="modal-header">
                                    <h3 class="modal-title">Applications</h3>
                                  </div>
                                  <div class="modal-body">
                                    <div id="modalCards"/>
                                      
                                  </div>
                                  <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                  </div>
                                </div>
                              </div>
                            </div>
                        
     
                        
							<script>
                                
                            appJSON=[<xsl:apply-templates select="$apps" mode="appJSON"/>];                                  
                            var productJSONA=[<xsl:apply-templates select="$products" mode="getProducts"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
                                </xsl:apply-templates>];  
                                
                                
                            $('document').ready(function(){
                                   var appListFragment = $("#app-list-template").html();
                                       appListTemplate = Handlebars.compile(appListFragment);    
                                })
                                
                            lifeColourJSON=[<xsl:apply-templates select="$lifecycles" mode="getElementColours"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/></xsl:apply-templates>];
                            
                            componentwithStdJSON=[<xsl:apply-templates select="$techComponentsWithStd" mode="getComps"/>];
                                
                            stdColourJSON=[<xsl:apply-templates select="$stdValue" mode="getElementColours"/>]    
                                
                            /* Generate buttons  */
                                
                            var container= document.getElementById('buttons'); 
                                lifeColourJSON.sort(function(obj1, obj2) {return obj1.order - obj2.order;});
                                for(var i=0;i&lt;lifeColourJSON.length;i++){
                                var obj= lifeColourJSON[i];
                                var button = "&lt;input type='button' value='' style='font-size:6pt;width:10px;background-color:"+obj.val+";color:"+obj.textcolour+"'>&lt;/input>&lt;span style='font-size:9pt'>"+obj.name+"&lt;/span>&lt;br/>  ";
                                container.innerHTML+=button;
                                }
                                var standards=[]; 
                                standards.push('');
                                
                             var containerStd= document.getElementById('buttonsStd'); 
                                stdColourJSON.sort(function(obj1, obj2) {return obj1.order - obj2.order;});
                                for(var i=0;i&lt;stdColourJSON.length;i++){
                                var obj= stdColourJSON[i];
                                var button = "&lt;input type='button' value='' style='font-size:6pt;width:10px;background-color:"+obj.val+";color:"+obj.textcolour+"'>&lt;/input>&lt;span style='font-size:9pt'> "+obj.name+"&lt;/span> &lt;input type='checkbox' id='"+obj.id+"' onclick='applyFilter(this.checked,this.id)' checked='true'>&lt;/input>&lt;br/>  ";
                                containerStd.innerHTML+=button;
                                standards.push(obj.id);
                                }    
                                
                             /*set dates*/
                            var datesJSON=[];
                              
                            var today=new Date().getTime();  
                            var startyear= new Date(new Date().getFullYear(), 0, 1).getTime();     
                            thisyear=new Date().getFullYear();
                            $('#yearsRange').prop('min',thisyear); 
                            $('#thisYr').append(thisyear);
                            $('#currentYr').append(thisyear);
                            for(i=0;i&lt;8;i++){        
                            datesJSON.push(thisyear);
                            thisyear=thisyear+1;
                            
                            
                           }
                            $('#endYr').append(thisyear);    
                            $('#yearsRange').prop('max',thisyear);  
                            /* set svg height */
                            var prodsWithLife=productJSONA.filter(function (d){
                                  return d.lifecycle.length !== 0;
                                });
                            var svgHeight=productJSONA.length *30+30;
                            
                            
                            var svg = d3.select("#lfbox").append("svg")
                                    .attr("width",1000)
                                    .attr("height", svgHeight)
                                    .attr("id","box");  
 
                                 /* add years */
                            for(i=0;i&lt;5;i++){
                                var years =svg.selectAll("#lfbox")
                                .data(datesJSON)
                                .enter()
                                        .append("text")
                                        .attr("x",(function(d){var calcyear= new Date(d+'-1-1').getTime()-startyear;  set=((((((calcyear)/1000)/60)/60)/24)/5);  return set+350}))
                                        .attr("y",10)
                                        .attr("class", "headerText")
                                        .style('font-size',11)
                                        .text(function(d){return d})
                                        .style("fill", "#898989");;
                                }
   function createMap(productJSON){                        
                            vendorSelected=$('#vendorSel').val();
                            if(vendorSelected==='all'){  } else{productJSON=productJSON.filter(function(d){return d.vendorID ===vendorSelected})}  
                               console.log(productJSON);
                            var prodList='[{"products":[';    
                            for(i=0;i&lt;productJSON.length;i++){
                                
                                var lifeVal='';
                                productJSON[i].lifecycle.sort(function (a, b) {
                                        return b.dateOf.localeCompare(a.dateOf);
                                    });
                                for(j=0;j&lt;productJSON[i].lifecycle.length;j++){
                                    life=lifeColourJSON.filter(function (d){
                                        return d.id===productJSON[i].lifecycle[j].id;
                                });
                                thisApps=[];
                                apps=appJSON.filter(function (d){
                                    
                                    check=d.products.filter(function (e){    
                                        if(e.id===productJSON[i].id){thisApps.push(d)}else{};
                                    })
                                if(check){return check}
                                })
                                
                                
                                thisDate=new Date(productJSON[i].lifecycle[j].dateOf).getTime();
                                
                                daysFromStart=((((((thisDate-startyear)/1000)/60)/60)/24));
                                
                                if(life[0].name==='End of Life'){daysFromStartEnd=new Date(productJSON[i].lifecycle[j+1].dateOf).getTime();
                                
                                daysFromStart=((((((daysFromStartEnd-startyear)/1000)/60)/60)/24))+40;}
                                
                                lifeVal+='{"life":"'+life[0].name+'","date":'+daysFromStart+',"colour":"'+life[0].val+'", "pos":'+i+'}';
                                if(j&lt;productJSON[i].lifecycle.length-1){lifeVal+=','}
        
                                 }
                                stdcolour=stdColourJSON.filter(function (d){
                                  if(productJSON[i].standard){return d.name===productJSON[i].standard}
                                   });
                                     
                                var stdColour;
                                if(stdcolour[0]){stdColour = stdcolour[0].val}else{stdColour ='#f56767' }
                             
                                prodList+='{"product":"'+productJSON[i].name+'","id":"'+productJSON[i].id+'", "appsImpacting":'+thisApps.length+',"stdColour":"'+stdColour+'", "standard":"'+productJSON[i].standard+'", "lifecycles":['+lifeVal+'],"apps":'+JSON.stringify(thisApps)+'}';
                                    if(i&lt;productJSON.length-1){prodList+=','}           
                                }    
                        prodList+=']}]';
                            
                        jsonProd=JSON.parse(prodList);
 
                        var producttext =svg.selectAll("#box")
                                .data(jsonProd[0].products)
                                .enter().append("svg:a")
                                .attr("xlink:href", function(d){return 'report?XML=reportXML.xml&amp;PMA='+d.id+'&amp;cl=en-gb&amp;XSL=technology/core_tl_tech_prod_summary.xsl';})
                                        .append("text")
                                        .attr("y",(function(d,i){return ((i+1)*22)+10}))
                                        .attr("x",10)
                                        .attr("class", "headerText item")
                                        .text(function(d){
                                                    var EOL=[];   
                                                    d.lifecycles.filter(function(e){;if(e.date&gt;-1){EOL.push(e.date)}});
                                                    if(EOL.length===0){ return d.product + ' *'}
                                                    else{ return d.product};
                                               })
                                        .style("fill", function(d){
                                                    var EOL=[];   
                                                    d.lifecycles.filter(function(e){;if(e.date&gt;-1){EOL.push(e.date)}});
                                                    if(EOL.length===0){ return '#ac2323'}
                                                    else{ return '#000000'};
                                               });
                                
                        var productinfo =svg.selectAll("#box")
                                .data(jsonProd[0].products)
                                        .enter()
                                        .append("g").attr("class","item")
                                 
                                productinfo.append("rect")
                                        .attr("y",function(d,i){return ((i+1)*22)})
                                        .attr("x",(250))
                                        .attr("height",(15))
                                        .attr("width",15).attr("class","item")
                                .style("fill", "rgba(219, 219, 219, 1)")
                                .on("click", function(d){showApps(d.apps)});
                                
                         
                                productinfo.append("text")
                                        .attr("y",function(d,i){return ((i+1)*22)+12})
                                        .attr("x",254)
                                .style("font-size","12px").attr("class"," item")
                                        .text(function(d){return d.appsImpacting})
                                        .style("fill", "#000000")
                                .on("click", function(d){showApps(d.apps)});
                               
                                productinfo.append("rect")
                                        .attr("y",function(d,i){return ((i+1)*22)})
                                        .attr("x",(270))
                                        .attr("height",(15))
                                        .attr("width",8)
                                .attr("class"," item")
                                        .style("fill", function(d){if(d.stdColour){return d.stdColour}else{return "#f56767"}});
                                
                                productinfo.append("circle")
                                        .attr("cx",279)
                                        .attr("cy",function(d,i){return ((i+1)*22)+7})
                                        .attr('r', 5)
                                        .style("fill", "#ffffff");
                                productinfo.append("text")
                                        .attr("y",function(d,i){return ((i+1)*22)+11})
                                        .attr("x",277)
                                .attr("class"," item")
                                .style("font-size","10px")
                                        .text(function(d){if (d.standard){return d.standard}else{return 'Off Strategy'}})
                                        .style("fill", "#000000");
                                
                                
                                
                                 var productlines =svg.selectAll("#box")
                                        .data(jsonProd[0].products)
                                        .enter()
                                        .append("g")
                                        .selectAll('rect')
                                        .data(function(d){return d.lifecycles;})
                                        .enter()
                                        .append("rect")
                                        .attr("class","timeitem item")
                                        .attr("y",function(d,i){ ys=d.pos+1;return (((ys+1)*22)-35)+12})
                                        .attr("x",(355))
                                        .attr("height",(1))
                                        .attr("width",(function(d,i){console.log(d.date);wd=((d.date)/5);console.log(wd);if(wd&lt;1){wd=0}
                                        ;return wd}))
                                        .style("fill", function(d){colr=j-1;if(colr&lt;0){colr=0};
                                        return d.colour});
                                
                                d3.selectAll(".timeitem")
                                .transition()
                                .duration(500)
                                .attr("height",(15))
                                
                                }
function filterDate(year){ 
                    var prodSel=$('#yearsRange').val();            
                    var thisdata=[];
                    products=productJSONA.filter(function (d,i){
                                    
                                    check=d.lifecycle.filter(function (e){
                                        var thisDate=new Date(e.dateOf).getFullYear();
                                            
                                        if(thisDate &lt;prodSel){return d}else{thisdata.push(productJSONA[i])};
                                    })
                                if(check){return check}
                                })
                 
                             
                            var newArray = thisdata.filter((thisdata, index, self) =>
    index === self.findIndex((t) => (t.save === thisdata.save &amp;&amp; t.name === thisdata.name)))
                               
        var thisSet=[];                        
             for(var j=0;j&lt;standards.length;j++){
                var filteredArray = newArray.filter(function(d){
                                if(d.standardID===standards[j]){thisSet.push(d)}
                                });
                                }  ;                  
            var sorted = thisSet.sort(function(a, b) {
                    if (a.name > b.name) {
                      return 1;
                    }
                    if (a.name &lt; b.name) {
                      return -1;
                    }
                    return 0;
                  });               
                                

    var items = d3.select("#lfbox").select('svg').selectAll('.item');
        items.style("opacity", 1)
        .transition()
        .duration(300)
        .style("opacity", 0).attr("height", 0)
        .remove();
                                
    var allrect = d3.select("#lfbox").select('svg').selectAll('.timeitem'); 
        allrect.style("height", 0)
        .transition()
        .duration(300)
        .style("opacity", 0).attr("height", 0)
        .remove();
    createMap(sorted);
                            
                    }          
                                
function applyFilter(state,type){
                              
        if(state){
            standards.push(type);
                        } else
                        {
                        for( var i=0; i&lt; standards.length; i++){ 
                           if ( standards[i] === type) {
                             standards.splice(i, 1); 
                           }
                         }
                        }
                filterDate($('#yearsRange').val())          
                    }  

 function showApps(data) { 
            $('#modalCards').empty();
            $('#modalCards').append(appListTemplate(data));   
            $('#appModal').modal('show');                                  
          }

            createMap(productJSONA);   
                                
                               
                            </script>
						

						<!--Setup Closing Tags-->
				 
				
<script id="app-list-template" type="text/x-handlebars-template">
        {{#each this}}
            <div class="card bg-light mb-3" style="display:inline-block;max-width: 18rem;">
                <div class="card-header">{{this.name}}</div>
                  <div class="card-body">
                    <h5 class="card-title">Description</h5>
                    <p class="card-text" style="max-height:60px;overflow-y: scroll; ">{{this.description}}</p>
                      
                      <p class="card-text" style="font-size:9pt"><b>Status</b><br/>
                          <i class="fa fa-caret-right" style="color:#8181d9"></i> {{this.lifecycle}}<br/>
                          <h6>Technology</h6>
                          {{#each this.products}}
                          
                           <i class="fa fa-server" style="color:#8181d9"></i> {{this.name}}<br/>
                          {{/each}}
                          </p>
                  </div>
            </div>
           {{/each}}
</script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
          
		</html> 
	</xsl:template>
    <xsl:template match="node()" mode="getElementColours">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="style" select="$styles[name=$this/own_slot_value[slot_reference='element_styling_classes']/value]"/>{"name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>","id":"<xsl:value-of select="$this/name"/>","val":"<xsl:value-of select="$style/own_slot_value[slot_reference='element_style_colour']/value"/>","textcolour":"<xsl:value-of select="$style/own_slot_value[slot_reference='element_style_text_colour']/value"/>","order":<xsl:value-of select="$this/own_slot_value[slot_reference='enumeration_sequence_number']/value"/><xsl:if test="not($this/own_slot_value[slot_reference='enumeration_sequence_number']/value)">10</xsl:if>}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template>
    
    
    
    
    
    
    <xsl:template match="node()" mode="getProducts"> <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisProdRole" select="$allTechProdRoles[name=$this/own_slot_value[slot_reference='implements_technology_components']/value]"/> 
         <xsl:variable name="thisTechStd" select="$allTechstds[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=$thisProdRole/name]"/>
        <xsl:variable name="thisstdValue" select="$stdValue[name=$thisTechStd/own_slot_value[slot_reference='sm_standard_strength']/value]"/>
        <xsl:variable name="thisTechComp" select="$allTechComponents[own_slot_value[slot_reference='realised_by_technology_products']/value=$thisProdRole/name]"/>
        <xsl:variable name="thisTechCompStd" select="$techComponentsWithStd[own_slot_value[slot_reference='realised_by_technology_products']/value=$thisProdRole/name]"/>
        <xsl:variable name="thisLifecycles" select="$productLifecycles[own_slot_value[slot_reference='lifecycle_model_subject']/value=$this/name]"/>
         <xsl:variable name="thisSupplier" select="$allSupplier[name=$this/own_slot_value[slot_reference='supplier_technology_product']/value]"/>   
        <xsl:if test="$thisLifecycles">{"name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", "id":"<xsl:value-of select="$this/name"/>","vendor":"<xsl:value-of select="$thisSupplier/own_slot_value[slot_reference='name']/value"/>","vendorID":"<xsl:value-of select="$thisSupplier/name"/>", "standardID":"<xsl:value-of select="$thisTechStd/own_slot_value[slot_reference='sm_standard_strength']/value"/>","standard":"<xsl:value-of select="$thisstdValue/own_slot_value[slot_reference='name']/value"/>","component":"<xsl:value-of select="$thisTechComp/name"/>","componentstandard":"<xsl:if test="$thisTechCompStd">Yes</xsl:if>","lifecycle":[<xsl:apply-templates select="$thisLifecycles" mode="getLifecycles"></xsl:apply-templates>]}<xsl:if test="not(position()=last())">,</xsl:if></xsl:if></xsl:template>   
    
    <xsl:template match="node()" mode="getLifecycles">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thislifecycleStatusUsages" select="$lifecycleStatusUsages[own_slot_value[slot_reference='used_in_lifecycle_model']/value=$this/name][own_slot_value[slot_reference='lcm_lifecycle_status']/value=$lifecycles/name]"/><xsl:apply-templates select="$thislifecycleStatusUsages" mode="getLifecyclesData"><xsl:sort select="$lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/></xsl:apply-templates>
    </xsl:template>
    
      <xsl:template match="node()" mode="getLifecyclesData">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thislifecycletimeRelations" select="$lifecycletimeRelations[own_slot_value[slot_reference=':FROM']/value=$this/name]"/>
        <xsl:variable name="thislifecycleStatusUsages" select="$lifecycleStatusUsages[own_slot_value[slot_reference='used_in_lifecycle_model']/value=$this/name][own_slot_value[slot_reference='lcm_lifecycle_status']/value=$lifecycles/name]"/>
        <xsl:variable name="thislifecycletimeliness" select="$lifecycletimeliness[name=$thislifecycletimeRelations/own_slot_value[slot_reference=':TO']/value]"/>{"id":"<xsl:value-of select="$lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/name"/>","dateOf":"<xsl:value-of select="$thislifecycletimeliness/own_slot_value[slot_reference='time_point_iso_8601']/value"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template>
    
    <xsl:template match="node()" mode="appJSON">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisappDeployment" select="$appDeployment[name=$this/own_slot_value[slot_reference='deployments_of_application_provider']/value]"/>
        <xsl:variable name="thisprodDeploymentRole" select="$prodDeploymentRole[name=$thisappDeployment/own_slot_value[slot_reference='application_deployment_technical_arch']/value]"/>
        <xsl:variable name="thistechBuildArch" select="$allTechBuildArch[name=$thisprodDeploymentRole/own_slot_value[slot_reference='technology_provider_architecture']/value]"/>
      <xsl:variable name="thisTechProvUsage" select="$allTechProvUsage[name=$thistechBuildArch/own_slot_value[slot_reference='contained_architecture_components']/value]"/>
  	    <xsl:variable name="thisTechRoles" select="$allTechProdRoles[name=$thisTechProvUsage/own_slot_value[slot_reference='provider_as_role']/value]"/>
        <xsl:variable name="thislifecycle" select="$applifecycles[name=$this/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>
        <xsl:variable name="thisProducts" select="$products[name=$thisTechRoles/own_slot_value[slot_reference='role_for_technology_provider']/value]"/>{"name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", "description":"<xsl:value-of select="$this/own_slot_value[slot_reference='description']/value"/>","lifecycle":"<xsl:value-of select="$thislifecycle/own_slot_value[slot_reference='enumeration_value']/value"/>", "id":"<xsl:value-of select="$this/name"/>", "products":[<xsl:apply-templates select="$thisProducts" mode="getAppProducts"></xsl:apply-templates>]}<xsl:if test="not(position()=last())">,</xsl:if> </xsl:template>
    <xsl:template match="node()" mode="getAppProducts"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="$this/name"/>","name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template>
    <xsl:template match="node()" mode="getAppOptions">
            <xsl:variable name="this" select="current()"/>
            <option value="{$this/name}"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></option>
    </xsl:template>
     <xsl:template match="node()" mode="getOptions"> 
         <xsl:variable name="this" select="current()"/>
         <option value="{$this/name}"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></option> 
    </xsl:template>
       <xsl:template match="node()" mode="getComps"> <xsl:variable name="this" select="current()"/>"<xsl:value-of select="$this/name"/>"<xsl:if test="not(position()=last())">,</xsl:if> </xsl:template>
</xsl:stylesheet>
