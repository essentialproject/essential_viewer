<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_js_functions.xsl"/>
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
    <xsl:variable name="lifecycles" select="/node()/simple_instance[type=('Vendor_Lifecycle_Status','Lifecycle_Status')]"/>
        
    
    <xsl:variable name="applifecycles" select="/node()/simple_instance[type=$param1]"/>
    <xsl:variable name="products" select="/node()/simple_instance[type='Technology_Product']"/>

    <xsl:variable name="productLifecycles" select="/node()/simple_instance[type=('Lifecycle_Model','Vendor_Lifecycle_Model')][own_slot_value[slot_reference='lifecycle_model_subject']/value=$products/name]"/>

    <xsl:variable name="lifecycleStatusUsages" select="/node()/simple_instance[type=('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$productLifecycles/name]"/>

    <xsl:variable name="allSupplier" select="/node()/simple_instance[type = 'Supplier']"/> 
    
    <xsl:variable name="allTechstds" select="/node()/simple_instance[type = 'Technology_Provider_Standard_Specification']"/>
    <xsl:variable name="allTechProdRoles" select="/node()/simple_instance[type='Technology_Product_Role']"/>
	<xsl:variable name="techProdRoleswithStd" select="$allTechProdRoles[name = $allTechstds/own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value]"/>
    
    <xsl:variable name="allTechProvUsage" select="/node()/simple_instance[type = 'Technology_Provider_Usage'][own_slot_value[slot_reference='provider_as_role']/value=$allTechProdRoles/name]"/>
    <xsl:variable name="allTechBuildArch" select="/node()/simple_instance[type = 'Technology_Build_Architecture'][own_slot_value[slot_reference='contained_architecture_components']/value=$allTechProvUsage/name]"/>
	<xsl:variable name="prodDeploymentRole" select="/node()/simple_instance[type = 'Technology_Product_Build'][own_slot_value[slot_reference='technology_provider_architecture']/value=$allTechBuildArch/name]"/>
    <xsl:variable name="appDeployment" select="/node()/simple_instance[type = 'Application_Deployment'][own_slot_value[slot_reference='application_deployment_technical_arch']/value=$prodDeploymentRole/name]"/>
    
    
    <xsl:variable name="stdValue" select="/node()/simple_instance[type = 'Standard_Strength']"/>
     <!--  tech for app  -->
   
    <xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>
    
    
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
                <script type="text/javascript" src="js/d3/d3_4-11/d3.min.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Technology Risk</title> 
            <style>
            	text.item:hover {cursor: pointer;}
                .loader {
                  border: 6px solid #f3f3f3;
                  border-radius: 50%;
                  border-top: 6px solid #3498db;
                  width: 70px;
                  height: 70px;
                  -webkit-animation: spin 2s linear infinite; /* Safari */
                  animation: spin 2s linear infinite;
                }

                /* Safari */
                @-webkit-keyframes spin {
                  0% { -webkit-transform: rotate(0deg); }
                  100% { -webkit-transform: rotate(360deg); }
                }

                @keyframes spin {
                  0% { transform: rotate(0deg); }
                  100% { transform: rotate(360deg); }
                }
                </style>    
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row focus">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
	                                <span class="text-darkgrey">Technology Product Lifecycles -</span><xsl:text> </xsl:text> <span id="lifeText"></span>          
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="row">
								<div class="col-md-4">
									<div class="form-group">
										<label for="sel1">Filter By Vendor</label>
										<!-- <select class="form-control" id="vendorSel"  onchange=" $('#appSel').val(0);  ;filterDate(this.value)">-->
										<select class="form-control" id="vendorSel" >
											<option value='all'>All</option>
											<xsl:apply-templates select="$allSupplier" mode="getOptions">
												<xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
											</xsl:apply-templates> 
										</select>
		                            </div>
								</div>
								<div class="col-md-4">
									<span>
		                                <label for="sel1">Filter By Year</label>
		                                <table>
		                                	<tbody>
		                                		<tr>
				                                	<td>
				                                		<div class="strong text-right" id="thisYr"/>
				                                	</td>
				                                	<td>
				                                		<input type="range" id="yearsRange" name="years" min="" max="" onchange="filterDate(this.value);$('#currentYr').text(this.value)"/>
				                                	</td>
				                                	<td>
				                                		<div id="endYr"  class="strong text-left"/>
				                                	</td>
				                                </tr>
		                                	</tbody>
		                                </table>
		                                <div class="top-10">Products supported in <strong><span id="currentYr"/></strong></div>
		                            </span>
								</div>
								<div class="col-md-4">
									<div class="form-group">
										<label for="sel1">Filter By Lifecycle</label>
										<select class="form-control" id="lifeSel"  onchange="$('.loader').show()">
											<option value='Vendor_Lifecycle_Status'>Vendor</option>
											<option value='Lifecycle_Status'>Internal</option>  
										</select>
									</div> 
								</div>
								<div class="col-xs-12">
									<hr class="tight"/>
								</div>
							</div>
							<div class="loader" height="50px"/>
						</div>
						<div class="col-xs-9">
							<div id="lfbox" style="box-shadow: 2px 2px 4px #d3d3d3;" />
						</div>
						<div class="col-xs-3">
                            
                             <!--<div style="float:left;margin-left:20px;padding-left:0px;width:150px;height:15px;border-left:15px solid #d3d3d3;background-color:#ffffff;color:#000000;font-size:9pt"><xsl:text> </xsl:text> 
                                 Applications Impacting</div>
                             <div style="display:inline-block;"><span style="font-size: 7pt">(click for detail)</span></div>-->

                            <div class="impact bottom-10">Lifecycles</div>
                            <div id="buttons" />
                            <div><span class="xsmall text-danger">* Unsupported </span></div>
                            <div class="impact top-15 bottom-10">Standards</div>
                            <div id="buttonsStd" />
                            <!-- <div style="float:left;padding-left:20px;font-size:9pt">Unclassified(Off Strategy) <input type='checkbox' id='' onclick='applyFilter(this.checked,this.id)' checked="true"></input></div>--><br/>
						</div>
						<div class="col-xs-12">
							<div class="modal" tabindex="-1" role="dialog" id="appModal">
								<div class="modal-dialog modal-lg" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<h3 class="modal-title">Applications</h3>
										</div>
										<div class="modal-body">
											<div id="modalCards"/>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--Setup Closing Tags-->
                    </div>  
                </div>
                        <!-- MODAL -->
                    
				
						
				 
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
          <script>
            var productJSON=[<xsl:apply-templates select="$products" mode="getProducts"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
                </xsl:apply-templates>];
 
            var lifecycleModelJSON=[<xsl:apply-templates select="$productLifecycles" mode="getLifecycles"></xsl:apply-templates>];
    
            var lifecycleUsageJSON=[<xsl:apply-templates select="$lifecycleStatusUsages" mode="getLifecycleUsages"></xsl:apply-templates>];
    
            var suppliers=[<xsl:apply-templates select="$allSupplier" mode="getSupplier"></xsl:apply-templates>];
    
            var techStandards=[<xsl:apply-templates select="$techProdRoleswithStd" mode="getTechStandards"></xsl:apply-templates>];
            var check;
             productJSON.map(function(d) {
    
    
                    var lifeId = d.id;
   
    
                var aModel = lifecycleModelJSON.filter(function(aModel) {
                   return aModel.subject === lifeId; 
                        ;
                    });
 
                 var thisModel=[];
                for(var i=0; i&lt; aModel.length;i++){
                   
                    if(aModel[i] != null) {
                         var aLife = lifecycleUsageJSON.filter(function(thisModel) {
                                    return thisModel.model == aModel[i].id;
                            });
  
                    aLife.sort(comp);    
                    thisModel=thisModel.concat(aLife);
    
                    }
                d['lifecycles']=thisModel;
                  }
 		  
                    var aStandard = techStandards.find(function(aStd) {
                      
                        return aStd.id == lifeId;
                    });
		 
                    if(aStandard != null) {
                        d['standard']=aStandard.standardName;
			  			d['standardID']=aStandard.standard;
                    }
			  	 	
                });  
 
				$('#lifeSel').on('change',function(){
						$('.loader').css('display','block'); 
					  createLifeBox();
					createMap(productJSON);
					})    

				function comp(a, b) {
					return new Date(a.dateOf).getTime() - new Date(b.dateOf).getTime();
				}  
							 appJSON=[<xsl:apply-templates select="$apps" mode="appJSON"/>];

							$('document').ready(function(){
								   var appListFragment = $("#app-list-template").html();
									   appListTemplate = Handlebars.compile(appListFragment);  


								})
            
    
            lifeColourJSON=[<xsl:apply-templates select="$lifecycles" mode="getElementColours"><xsl:sort select="own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/></xsl:apply-templates>];

      <!--      componentwithStdJSON=[<xsl:apply-templates select="$techComponentsWithStd" mode="getComps"/>];
-->
            stdColourJSON=[<xsl:apply-templates select="$stdValue" mode="getElementColours"/>]    
stdColourJSON.push({"name":"Not Set","id":"","val":"#ffffff","textcolour":"","order":10,"type":"None"})
            /* Generate buttons  */

                createLifeBox();
    
                var standards=[]; 
                standards.push('');

             var containerStd= document.getElementById('buttonsStd'); 
                stdColourJSON.sort(function(obj1, obj2) {return obj1.order - obj2.order;});
                for(var i=0;i&lt;stdColourJSON.length;i++){
                var obj= stdColourJSON[i];
                var button = "&lt;div class='keySample' style='background-color:"+obj.val+";color:"+obj.textcolour+"'>&lt;/div>&lt;div class='pull-left' style='width: 150px'> "+obj.name+"&lt;/div> &lt;input type='checkbox' id='"+obj.id+"' onclick='applyFilter(this.checked,this.id)' checked='true'>&lt;/input>&lt;br/>  ";
                containerStd.innerHTML+=button;
                standards.push(obj.id);
                }    
			  

             /*set dates*/
            var datesJSON=[];

            var today=new Date().getTime();  
            var startyear= new Date(new Date().getFullYear()-2, 0, 1).getTime();     
            var multiplier = ((((1/1000)/60)/60)/24);
            thisyear=new Date().getFullYear()-2;
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
            var svgHeight=productJSON.length *22+30;


            var svg = d3.select("#lfbox").append("svg")
                    .attr("width",890)
                    .attr("height", svgHeight)
                    .attr("id","box");  

                 /* add years */
            for(i=0;i&lt;5;i++){
                var years =svg.selectAll("#lfbox")
                .data(datesJSON)
                .enter()
                        .append("text")
                        .attr("x",(function(d){var calcyear= new Date(d+'-1-1').getTime()-startyear;  set=((((((calcyear)/1000)/60)/60)/24)/5);  return set+358}))
                        .attr("y",10)
                        .attr("class", "headerText")
                        .style('font-size',11)
                        .text(function(d){return d})
                        .style("fill", "#898989");;
                }
                                
   function createLifeBox(){
    $('#buttons').empty();
     var container= document.getElementById('buttons'); 
                lifeColourJSON.sort(function(obj1, obj2) {return obj1.order - obj2.order;});
    
                for(var i=0;i&lt;lifeColourJSON.length;i++){
                if(lifeColourJSON[i].type===$('#lifeSel').val()){ 
                    var obj= lifeColourJSON[i];
                    var button = "&lt;div class='keySample' style='background-color:"+obj.val+";color:"+obj.textcolour+"'>&lt;/div>&lt;span style='width: 120px'>"+obj.name+"&lt;/span>&lt;br/>  ";
                    container.innerHTML+=button;
                    }
                }
    }                             
   function createMap(productJSON){  
    $('#lifeText').text($('#lifeSel').val().replace(/_/g, " "));
     d3.select('svg').selectAll('.item').remove()
        life2Use=$('#lifeSel').val();
     
        count=0;
        vendorSelected=$('#vendorSel').val();
        if(vendorSelected==='all'){  } else{productJSON=productJSON.filter(function(d){return d.vendorID ===vendorSelected})}  
        var prodList='[{"products":[';    
        for(i=0;i&lt;productJSON.length;i++){

            var lifeVal='';
            var thisApps=[];
        if(productJSON[i].lifecycles&gt;[]) {  

           inscopelifecycles= productJSON[i].lifecycles.filter(function (d){
                    return d.type===life2Use
                })
    
            productJSON[i]['lifecycle']=inscopelifecycles
    
            productJSON[i].lifecycle.sort(function (a, b) {
											return b.dateOf.localeCompare(a.dateOf);
										});

            for(var ct=0; ct&lt; productJSON[i].lifecycle.length;ct++){

                if(productJSON[i].lifecycle[ct].dateOf===''){
                    productJSON[i].lifecycle.splice(ct,1);ct--

                }
            }
         
            if(productJSON[i].lifecycle.length &gt; 0){
                startDateforLifecycle=new Date(productJSON[i].lifecycle[productJSON[i].lifecycle.length-1].dateOf).getTime();

            }
            else
            {startDateforLifecycle=startyear+1}
            startPos=((((((startDateforLifecycle-startyear)/1000)/60)/60)/24));

            for(j=0;j&lt;productJSON[i].lifecycle.length;j++){
                    var life=lifeColourJSON.filter(function (d){
                        return d.id===productJSON[i].lifecycle[j].id;
                });
    
                    apps = appJSON.filter(function (d) {

                    check = d.products.filter(function (e) {
                            if (e.id === productJSON[i].id) {
                                thisApps.push(d)
                            } else {
                            };
                        })
                        if (check) {
                            return check
                        }
                    });
                        var temp=[];
                        var uniqueApps=thisApps.filter((x, i)=> {
                          if (temp.indexOf(x.id) &lt; 0) {
                            temp.push(x.id);
                            return true;
                          }
                          return false;
                        })
                    thisApps=uniqueApps;
                    thisDate = new Date(productJSON[i].lifecycle[j].dateOf).getTime();
                    daysFromStart =((((((thisDate - startDateforLifecycle) / 1000) / 60) / 60) / 24));
                    if (j === 0) {
                        diff = 15;
                    } else {
                        nextDateStart = new Date(productJSON[i].lifecycle[j -1].dateOf).getTime();
                        nextDateStart =(((((((nextDateStart) / 1000) / 60) / 60) / 24)));
                        diff = (((((new Date(productJSON[i].lifecycle[j -1].dateOf).getTime() - new Date(productJSON[i].lifecycle[j].dateOf).getTime()) / 1000) / 60) / 60) / 24)
                    }
            
 lifeVal+='{"life":"'+life[0].name+'","startpos":'+startPos+',"diff":'+diff+',"date":'+daysFromStart+',"colour":"'+life[0].val+'", "pos":'+count+', "dateTxt":"'+productJSON[i].lifecycle[j].dateOf+'","prod":"'+productJSON[i].name+'"}';

            if(j&lt;productJSON[i].lifecycle.length-1){lifeVal+=','}
                
             }

            stdcolour=stdColourJSON.filter(function (d){
              if(productJSON[i].standard){ 
              if(d.name==productJSON[i].standard){return d.name==productJSON[i].standard}else{
  
              var stdstring=productJSON[i].standard.replaceAll('_', ' ')
              return d.name==stdstring;}
                }
               });

            var stdColour;
            if(stdcolour[0]){ ; 
              stdColour = stdcolour[0].val
              }else
              {stdColour ='#e6e6e6' }
     
                prodList+='{"product":"'+productJSON[i].name+'","id":"'+productJSON[i].id+'", "appsImpacting":'+thisApps.length+',"stdColour":"'+stdColour+'","linkid":"'+productJSON[i].linkid+'", "standard":"'+productJSON[i].standard+'", "lifecycles":['+lifeVal+'],"apps":'+JSON.stringify(thisApps)+'}';

             <!--
                if(i&lt;productJSON.length-1){prodList+=','}-->
            prodList+=','
             count++;
            
            }
            }    

    prodList+='{}]}]';
$('.loader').hide();

    jsonProd=JSON.parse(prodList);
            var ll=jsonProd[0].products.length;
            jsonProd[0].products.splice(-1,1);
             var productlines =svg.selectAll("#box")
                    .data(jsonProd[0].products)
                    .enter()
                    .append("g")
                    .selectAll('rect')
                    .data(function(d){return d.lifecycles;})
                    .enter()
                    .append("rect")
                    .attr("class","timeitem item")
                    .attr("y",function(d,i){ ys=d.pos+1; return (((ys+1)*22)-35)+12})
                    .attr("x",function(d,i){;
                            return 355+(d.date/5)+(d.startpos/5)<!--was startpos-->})
                    .attr("height",(1))
                    .attr("width",(function(d,i){;wd=((d.diff)/5);if(wd&lt;1){wd=0}
                    ;return wd<!--was wd --> }))
                    .style("fill", function(d){colr=j-1;if(colr&lt;0){colr=0};
                    return d.colour});        

    var producthidebox =svg.selectAll("#box").data(jsonProd[0].products)
                    .enter()
                    .append("rect")
                    .attr("class","background")
                    .attr("y",10)
                    .attr("x",0)
                    .attr("height", (function(d){return svgHeight}))
                    .attr("width",355) 
                    .style("fill","#ffffff");


    var producttext =svg.selectAll("#box")
            .data(jsonProd[0].products)
			   
             .enter().append("svg:a")
            .attr("xlink:href", function(d){ return 'report?XML=reportXML.xml&amp;PMA='+d.linkid+'&amp;cl=en-gb&amp;XSL=technology/core_tl_tech_prod_summary.xsl';})
 
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
                    .style('font-size',10.5)
                    .style("fill", function(d){
                                var EOL=[];   
                                d.lifecycles.filter(function(e){;if(e.date&gt;-1){EOL.push(e.date)}});
                                if(EOL.length===0){ return '#ac2323'}
                                else{ return '#000000'};
                           }) ;

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
                    .style("fill", function(d){ 
              if(d.stdColour){return d.stdColour}else{return "#ffffff"}});

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
                    .text(function(d){if (d.standard){return d.standard}else{return ''}})
                    .style("fill", "#000000");




            d3.selectAll(".timeitem")
            .transition()
            .duration(500)
            .attr("height",(15))

            }
                                
                              
function filterDate(year){ 
                    $('#appSel').val(0); 
                    var prodSel=$('#yearsRange').val();            
                    var thisdata=[];
                    products=productJSON.filter(function (d,i){
   
                                    if(d.lifecycles){
                                    check=d.lifecycles.filter(function (e){
                                        var thisDate=new Date(e.dateOf).getFullYear();
                                        if(thisDate){    
                                        if(thisDate &lt;prodSel){return d}else{thisdata.push(productJSON[i])};
            }
        })
    }
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
                            
                    };          

$('#vendorSel').on('change',function(){
    $('.loader').show();
var selection=$('#vendorSel').val();
       if(selection==='all'){
            var getVendor = productJSON;
    }else{
            var getVendor = productJSON.filter(function(d){
    
                    return d.vendorID === $('#vendorSel').val();
                }) 
        
        }

    createMap(getVendor)
    })    
function filterApp(app){ 
                    var appSel=$('#appSel').val();            
                    var thisdata=[];
                    appProducts=appJSON.find(function (d){   
                        return d.id===appSel;
                                });
               
                              
                    products=productJSON.filter(function (d,i){
                    
                                    check=appProducts.products.find(function (e){
                    
                                        if(e.id === d.id){ thisdata.push(productJSON[i])};
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

        <!--    createMap(productJSONA);  --> 
            filterDate(startyear)  ;                  
                                
                               
                            </script>
			<script id="app-list-template" type="text/x-handlebars-template">
			<div class="row">		
			{{#each this}}
			<div class="col-md-4">
				<div class="panel panel-default">
				    <div class="panel-heading">{{this.name}}</div>
				      <div class="panel-body">
				      	<div class="strong">Technology</div>
			              {{#each this.products}}
			              <div class="top-5"><i class="fa fa-server right-5"></i>{{this.name}}</div>
			              {{/each}}
				      </div>
				</div>
			</div>
			{{/each}}
			</div>
			</script>
          
          
		</html> 
	</xsl:template>
<xsl:template match="node()" mode="getElementColours">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="style" select="$styles[name=$this/own_slot_value[slot_reference='element_styling_classes']/value]"/>{"name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>","id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","val":"<xsl:value-of select="$style[1]/own_slot_value[slot_reference='element_style_colour']/value"/>","textcolour":"<xsl:value-of select="$style[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>","order":<xsl:value-of select="$this/own_slot_value[slot_reference='enumeration_sequence_number']/value"/><xsl:if test="not($this/own_slot_value[slot_reference='enumeration_sequence_number']/value)">10</xsl:if>,"type":"<xsl:value-of select="$this/type"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
</xsl:template>

    
<xsl:template match="node()" mode="getProducts">
    <xsl:variable name="this" select="current()"/>
    {"name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", "id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","vendor":"","vendorID":"<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='supplier_technology_product']/value)"/>", "standardID":"","standard":"","component":"","componentstandard":"","linkid":"<xsl:value-of select=" $this/name"/>"},</xsl:template>   
    
<xsl:template match="node()" mode="getLifecycles">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thislifecycleStatusUsages" select="$lifecycleStatusUsages[own_slot_value[slot_reference='used_in_lifecycle_model']/value=$this/name][own_slot_value[slot_reference='lcm_lifecycle_status']/value=$lifecycles/name]"/> 
    {"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>", "subject":"<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='lifecycle_model_subject']/value)"/>"},
</xsl:template>     

<xsl:template match="node()" mode="getLifecycleUsages">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thisISODate" select="$this/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>   
    {"id":"<xsl:value-of select="eas:getSafeJSString($lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/name)"/>","dateOf":"<xsl:value-of select="$thisISODate"/>","model":"<xsl:value-of select="eas:getSafeJSString($this/own_slot_value[slot_reference='used_in_lifecycle_model']/value)"/>","thisid":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","type":"<xsl:value-of select="$lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/type"/>"},
</xsl:template>
    
  <xsl:template match="node()" mode="getLifecyclesData">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thisISODate" select="$this/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>   
   {"id":"<xsl:value-of select="eas:getSafeJSString($lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/name)"/>","dateOf":"<xsl:value-of select="$thisISODate"/>","type":"<xsl:value-of select="$lifecycles[name=$this/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/type"/>"},
</xsl:template>
   
<xsl:template match="node()" mode="appJSON">
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="thisappDeployment" select="$appDeployment[name=$this/own_slot_value[slot_reference='deployments_of_application_provider']/value]"/>
    <xsl:variable name="thisprodDeploymentRole" select="$prodDeploymentRole[name=$thisappDeployment/own_slot_value[slot_reference='application_deployment_technical_arch']/value]"/>
    <xsl:variable name="thistechBuildArch" select="$allTechBuildArch[name=$thisprodDeploymentRole/own_slot_value[slot_reference='technology_provider_architecture']/value]"/>
    <xsl:variable name="thisTechProvUsage" select="$allTechProvUsage[name=$thistechBuildArch/own_slot_value[slot_reference='contained_architecture_components']/value]"/>   
    <xsl:variable name="thisTechRoles" select="$allTechProdRoles[name=$thisTechProvUsage/own_slot_value[slot_reference='provider_as_role']/value]"/>
    <xsl:variable name="thisProducts" select="$products[name=$thisTechRoles/own_slot_value[slot_reference='role_for_technology_provider']/value]"/>
        {"name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>", "id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>", "products":[<xsl:apply-templates select="$thisProducts" mode="getAppProducts"/>]}<xsl:if test="not(position()=last())">,</xsl:if> </xsl:template>
    
    
     

    
    
    
<xsl:template match="node()" mode="getAppProducts"><xsl:variable name="this" select="current()"/>{"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="getSupplier">
        <xsl:variable name="this" select="current()"/>
       {"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","name":"<xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="getAppOptions">
        <xsl:variable name="this" select="current()"/>
        <option value="{eas:getSafeJSString($this/name)}"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></option>
</xsl:template>
 <xsl:template match="node()" mode="getOptions"> 
     <xsl:variable name="this" select="current()"/>
     <option value="{eas:getSafeJSString($this/name)}"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></option> 
</xsl:template>
   <xsl:template match="node()" mode="getComps"> <xsl:variable name="this" select="current()"/>"<xsl:value-of select="eas:getSafeJSString($this/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if> </xsl:template>

<xsl:template match="node()" mode="getTechStandards">
<xsl:variable name="thisTechStd" select="$allTechstds[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=current()/name]"/>
    <xsl:variable name="this" select="current()/own_slot_value[slot_reference='role_for_technology_provider']/value"/>
<xsl:apply-templates select="$thisTechStd" mode="getTechStandardsLine"><xsl:with-param name="tech" select="$this"/></xsl:apply-templates>  
</xsl:template>     
<xsl:template match="node()" mode="getTechStandardsLine">
    <xsl:param name="tech"/>
    <xsl:variable name="thisstdValue" select="$stdValue[name=current()/own_slot_value[slot_reference='sm_standard_strength']/value]"/><xsl:if test="$thisstdValue">{"id":"<xsl:value-of select="eas:getSafeJSString($tech)"/>","standard":"<xsl:value-of select="eas:getSafeJSString($thisstdValue/name)"/>","standardName":"<xsl:value-of select="eas:getSafeJSString($thisstdValue/own_slot_value[slot_reference='name']/value)"/>"},</xsl:if>
</xsl:template>
</xsl:stylesheet>
