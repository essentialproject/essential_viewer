<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/> 
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
    <!-- Get an API Report instance using the common list of API Reports already captured by core_utilities.xsl -->
    <xsl:variable name="anAPIReportInstance" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"/>
	<xsl:variable name="anAPIClassInstance" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Instances for Class']"/>
	<xsl:variable name="allClasses" select="/node()/class[supertype=':STANDARD-CLASS'][type=':ESSENTIAL-CLASS'][not(contains(name, ':'))]"/>
	
    
   	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
    <xsl:template match="knowledge_base">
        	<xsl:call-template name="docType"/>
         <xsl:variable name="apiPathInstance">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportInstance"/>
            </xsl:call-template>
        </xsl:variable>
		 <xsl:variable name="apiPathClass">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIClassInstance"/>
            </xsl:call-template>
        </xsl:variable>
        <html>
            <head>
            	<xsl:call-template name="commonHeadContent"/>
				<script async="true" src="js/es6-shim/0.9.2/es6-shim.js" type="text/javascript"/>
            	<script src="js/d3/d3_4-11/d3.min.js"></script>
			 	<script src="js/dagre/dagre.min.js"></script>
                <script src="js/dagre/dagre-d3.min.js"></script>	
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderEditorInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
            <style>
                .slot-scroller{
                	overflow-y: scroll;
                	height:calc(100vh - 350px);
                }
                
                .this-spinner {
                	position: absolute;
                	top: 0;
                	left:0;
                	display:none;
                	height: 100%;
                	width: 100%;
                	background-color: #fff;
                	opacity: 0.75;
                }
                
                .this-spinner > div {
                	position: absolute;
                	top: 100px;
                	text-align: center;
                	width: 100%;
                }
                
				.node rect {
				  stroke: #333;
				  fill: #fff;
				}

				.edgePath path {
				  stroke: #333;
				  fill: #333;
				  stroke-width: 1.5px;
				}            
                </style>
            	
            	<script>
            		$(document).ready(function(){
            			
            			// Enable Select2 for the select boxes
            			$('#classSelect').select2({
            				placeholder: 'Select a Class'
            			});
	        			$('#instanceSelect').select2({
	        				placeholder: 'Select an Instance'
	        			});
	        			
	        			// SVG Settings
	        			// Get the Window width and height
	        			var screenWidth = $(window).width();
						var screenHeight = $(window).height();
						// Width of page minus the left column, etc
						var svgWidth = screenWidth*0.73;
						// Height of page minus the header and footer, etc
						var svgHeight = screenHeight-176;
						// Set the size of the SVG
						$('svg').attr('width',svgWidth);
						$('svg').attr('height',svgHeight);
            		});
            	</script>
            </head>
            <body>
              <xsl:call-template name="Heading"/>
            	<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Instance Navigator</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
						<div class="col-md-3">
							
							<div class="form-group">
								<label>Class:</label>
								<div class="bottom-10">
									<select id="classSelect" class="form-control"  style="width: 100%;">
										<option name="none" id="none"></option>
										<xsl:apply-templates select="$allClasses" mode="cls"><xsl:sort order="ascending" select="name"/></xsl:apply-templates>
									</select>
								</div>
								<label>Instance:</label>
								<div>
									<select id="instanceSelect" class="form-control" style="width: 100%;">
										<!--<option name="none" id="none">Select an Instance</option>-->
									</select>
								</div>
							<!--	<label>Instance ID:</label>
								<input class="form-control" type="text" id="oid"></input>
							-->
                                <table><tr><td width="80%">	<button class="btn btn-block btn-success top-10" id="cli">Go</button></td>
                                    <td style="padding-left:5px"><button class="btn btn-block btn-primary top-10" id="clear">Clr</button></td></tr></table>
							
					
							</div>	
							<div id="slots"  class="slot-scroller"></div>
						</div>
						<div class="col-md-9">
							<div id="spinner" class="this-spinner">
								<div class="xlarge"><i class="fa fa-circle-o-notch fa-spin right-10"></i>Calculating<br/><span style="font-size:8pt">This can take some time where lots of relations exist</span></div>
							</div>
							<svg id="svg-canvas" width="100px" height="100px"/>
							
						</div>
						<div class="col-xs-12 hiddenDiv">
							<div id="instancePanel"/>
						</div>
					</div>
            	</div>
           	<xsl:call-template name="Footer"/>    
            </body>
            <script>
            <xsl:call-template name="RenderViewerAPIJSFunction">
                <xsl:with-param name="viewerAPIPath2" select="$apiPathInstance"/>
				<xsl:with-param name="viewerAPIPathClass" select="$apiPathClass"/>
				
            </xsl:call-template>
   
			</script>
		<script id="links-name" type="text/x-handlebars-template">
	 <h2>{{name}}</h2>
	  <svg width="100%"><xsl:attribute name="id">{{this.id}}</xsl:attribute> <xsl:attribute name="height">1000</xsl:attribute> 
                <g><xsl:attribute name="transform">translate(10,0)</xsl:attribute>
						<rect width="100" height="40" style="fill:rgb(205, 242, 202);stroke-width:1;stroke:rgb(0,0,0)" y="0" x="0" ></rect>
	  					</g>         
                  
	{{#each this.children}}  
		  <g><xsl:attribute name="transform">translate(10,0)</xsl:attribute>
			<rect width="100" height="40" style="fill:rgb(205, 242, 202);stroke-width:1;stroke:rgb(0,0,0)" y="60" ><xsl:attribute name="x">{{xpos @index}}</xsl:attribute></rect>
			  <line x1="0" y1="0" x2="200" y2="200" style="stroke:rgb(255,0,0);stroke-width:2">			       <xsl:attribute name="x1">{{../x}}</xsl:attribute>
				<xsl:attribute name="y1">{{../y}}</xsl:attribute>
				<xsl:attribute name="x2">{{x}}</xsl:attribute>
			    <xsl:attribute name="y2">{{y}}</xsl:attribute></line>  
			</g>
		{{this.name}} 
	{{/each}}
		 
	 </svg>
</script>				
	
			<script id="slot-template" type="text/x-handlebars-template">
			{{#each instance}} 
						{{#ifEquals this.slotType "simple_instance"}}	
					{{#unless enum}}
				<i class="fa fa-caret-right"></i><xsl:text> </xsl:text> <b>{{this.name_values.0.type}}</b> 
						<ul class="fa-ul">
									{{#each name_values}}
							
										<li>
											<xsl:attribute name="id">p{{this.id}}</xsl:attribute>
											<xsl:attribute name="class">p{{this.id}}</xsl:attribute>
										<!--	{{#if this.slotType}}
											
														<span>{{this.name}}</span>
											
											{{/if}}
										-->
											<span>{{this.name}} <i class="fa fa-eye">
														<xsl:attribute name="id">{{this.id}}</xsl:attribute>
														</i></span>
										</li>
								
									{{/each}}
								</ul>
				{{/unless}}
			{{/ifEquals}}
            		{{/each}}	
			</script>  
            <script id="instance-template" type="text/x-handlebars-template">
            {{#if this.name}}
            	<div class="large bottom-10"><strong>{{this.name}}</strong></div>
            {{/if}}
            	<ul class="fa-ul">
            		{{#each instance}} 
						{{#ifEquals this.slotType "simple_instance"}}
								
							<li>
								<i class="fa fa-li fa-caret-down"/>
								<span class="right-5 strong">{{this.name_values.0.type}}</span><span class="badge small">{{this.name_values.length}}</span>
								<ul class="fa-ul">
									{{#each name_values}}
										<li>
											<xsl:attribute name="id">p{{this.id}}</xsl:attribute>
											<xsl:attribute name="class">p{{this.id}}</xsl:attribute>
											{{#if this.slotType}}
												{{#unless ../enum}}
													<i class="fa fa-li fa-caret-right">
														<xsl:attribute name="id">{{this.id}}</xsl:attribute>
													</i>
												{{/unless}}
											{{/if}}
											<span class="right-5">{{this.name}}</span>
										</li>
									{{/each}}
								</ul>
							</li>
						{{/ifEquals}}
            		{{/each}}
            	</ul>
            
            </script>   
			
			
<script>
	
</script>			
        </html>
        
    </xsl:template>
    
    
    
    <!-- This XSL Template should probably be defined in core_utilities -->
    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
        
        
        
        
        
    </xsl:template>
    
    <!-- This XSL template contains an example of the view-specific stuff -->
    <xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath2"/>
		<xsl:param name="viewerAPIPathClass"/>
		var classNameId=$('#classSelect').id;
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPathClass"/>&amp;PMA=';
    	var viewClassData = '<xsl:value-of select="$viewerAPIPath2"/>&amp;PMA='+classNameId;
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            <!--$('#ess-data-gen-alert').hide();-->
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
  var thisviewAPIData;   
   var data,  focusNode, focusId;    
    var catalogueTable;
	var i=0;    
	var states=[];	
	var nodeSet=[];	
		
function getData(dta){
	$('#spinner').show();	
     return promise_loadViewerAPIData(dta)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                thisviewAPIData = response1;
               //DO HTML stuff
         thisviewAPIData=response1; 
    $('#spinner').hide();
		if(thisviewAPIData['name']){	
			var focusNode= thisviewAPIData['name'][0];}
		else if(thisviewAPIData['relation_name']){
		var focusNode= thisviewAPIData['relation_name'][0];
		}
		else{
		
		var focusNode= thisviewAPIData.instance.filter(function(d){
 
			
			return d.name=='name' || d.name=='relation_name';
			});
	
		focusNode=thisNode[0].values[0];
		}
		
 	
            }).catch (function (error) {
                //display an error somewhere on the page   
            });
        }        
   
async function getNode(parentNode,idToCall,pos){
 
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath2"/>&amp;PMA='+idToCall;
              
        const result = await getData(viewAPIData);
 
        var getName =thisviewAPIData.instance.find(function(d){
            return d.name==='name'
        });
        var getRelName =thisviewAPIData.instance.find(function(d){
            return d.name==='relation_name'
        });
        var getType =thisviewAPIData.instance.forEach(function(d){
        
                d.name_values.forEach(function(e){
           
            if(e.superclass){
                    e.superclass.find(function(f){
                    if(f==='Enumeration'){
                        d['enum']='True';
                            }
                    });
                    }
                });
            });

		
        
        if(pos===1){
            if(getName){
            thisviewAPIData['name']=getName.values;
            }else
            {
            thisviewAPIData['name']=getRelName.values;
            }
        } 
	if(thisviewAPIData['name']){	
	var thisNode= thisviewAPIData['name'][0];}
		else if(thisviewAPIData['relation_name']){
		var thisNode= thisviewAPIData['relation_name'][0];
		}
		else{
		
		var thisNodeSelected= thisviewAPIData.instance.filter(function(d){
	 
			return d.name=='name' || d.name=='relation_name';;
			});
 
		thisNode =thisNodeSelected[0].values[0];
		}
		focusId=idToCall; 
	if(parentNode==idToCall){
		var focusNode={"id":idToCall,"name":thisNode};
		}
		else
		{
		var focusNode={"id":idToCall,"name":parentNode};
		}
	 

	states.push({"name":thisNode,"id":idToCall});

var temp=[];
var uniqueArray=[];		
		var uniqueStates=states.filter((x, i)=> {
		  if (temp.indexOf(x.id) &lt; 0) {
			temp.push(x.id);
			uniqueArray.push({"id":x.id,"name":x.name})
			return true;
		  }
		  return false;
		})
states=uniqueArray;
 
if(focusNode.name!==thisNode){
 
 

let thisNodeID = states.filter((e)=>{
	return e.name == thisNode
}) 
let focusNodeID = states.filter((e)=>{
	return e.name == focusNode.name
}) 
 
		nodeSet.push({"id":focusNode.id,"parent":focusNodeID[0].id,"child":thisNodeID[0].id})
		}
 	
   data={nodes:nodeSet}	;
 
 
		focusNode=thisNode;
		
		
     createGraph(focusNode);   
		
 
	$('#slots').empty();	
		
	var slots2show=	thisviewAPIData.instance.filter(function(d){
		return d.name!='external_repository_instance_reference';
		})
	slots2show={"instance":slots2show}	 
  	$('#slots').append(slotCardTemplate(slots2show));
       
         
		$('.fa-eye').click(function(d){
		
			var idToCall2=$(this).attr('id');
	  
			getNode(focusNode,idToCall2,2);
        })
          
        };        
        $(document).ready(function(){
		var svgFragment   = $("#links-name").html();
		var svgTemplate = Handlebars.compile(svgFragment);
	
	Handlebars.registerHelper("xpos", function(value, options)
		{
			return parseInt(value) * 110;
		});

		
		
  
         var instanceCardFragment   = $("#instance-template").html();
         instanceCardTemplate = Handlebars.compile(instanceCardFragment);
		
		 var slotCardFragment   = $("#slot-template").html();
         slotCardTemplate = Handlebars.compile(slotCardFragment); 	
		
		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
    		return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});
			
        
    $('#cli').click(function(){  
          $("#instancePanel").empty();
        var objID=$('#instanceSelect option:selected').attr('id');
      
       getNode(objID,objID,1);
        
        });
    
        
       $('#clear').click(function(){  
          $("#svg-canvas").empty();  
        states=[];
         data=[];
         nodeSet=[];
       
        d3.select("#svg-canvas").selectAll("*").remove();  
        });  
        
		
		
	$('#classSelect').change(function(){  
           
        var clsID=$('#classSelect option:selected').attr('id');
 
		var viewClassData = '<xsl:value-of select="$viewerAPIPathClass"/>&amp;PMA='+clsID;
			 promise_loadViewerAPIData(viewClassData)
					.then(function(responseClass) {
			 
					
 $('#instanceSelect').empty()
		responseClass.instances.forEach(function(d){
			$('#instanceSelect').append('&lt;option id="'+d.id+'">'+d.name+'&lt;/option>')
		})
			});
        
        });
		
		
		

	


});	
 function createGraph(fcsNode){	
// Create a new directed graph
	
var g1 = new dagreD3.graphlib.Graph();
var g=g1.setGraph({});

// Automatically label each of the nodes

states.forEach(function(state) { g.setNode(state.id, { label: state.name, class:state.id }); });

data.nodes.forEach(function(d) { g.setEdge(d.parent, d.child,{ label: "",curve: d3.curveBasis}); });	
 
 
var res=dagreD3.graphlib.json.write(g1);
 		
g.nodes().forEach(function(v) {
  var node = g.node(v);
  node.rx = node.ry = 5;	
	 
  node.id = v;
		
 		
});

// Add some custom colors based on state

// SVG Settings
// Get the Window width and height
var screenWidth = $(window).width();
var screenHeight = $(window).height();
// Width of page minus the left column, etc
var svgWidth = screenWidth*0.73;
// Height of page minus the header and footer, etc
var svgHeight = screenHeight-30;

g.graph().rankDir = 'LR';
var svg = d3.select("svg");
svg.append("g").style("width", svgWidth).style("height", svgHeight);

 var inner = svg.select("g");

// Set up zoom support
var zoom = d3.zoom().on("zoom", function() {
      inner.attr("transform", d3.event.transform);
    });
svg.call(zoom);

// Create the renderer
var render = new dagreD3.render();

// Run the renderer. This is what draws the final graph.
render(inner, g);

// Center the graph
if(i==0){	
var initialScale = 1.0;
svg.call(zoom.transform, d3.zoomIdentity.translate((svgWidth - g.graph().width * initialScale) / 2, 20).scale(initialScale));

svg.attr('height', g.graph().height * initialScale + svgHeight);
	i++}

svg.selectAll('.node').on('click', function(d) { 
	thisNode=$(this).attr('id'); 
		var thisFocusNodes= states.filter(function(e){
				return  e.id==thisNode
			});
 	
		newIdToCall=thisFocusNodes[0].id;
 

		getNode(newIdToCall,newIdToCall,2);

	});	 
	<!-- svg.select('#'+fcsNode).selectAll('rect').style('fill','#eab0e3')-->
		d3.selectAll("."+focusId).style("fill", "#3c763d");
		d3.selectAll("."+focusId+">rect").style("fill", "#dff0d8").style("stroke", "#3c763d");
 		
};       
    </xsl:template>
   <xsl:template match="node()" mode="cls">
	<option><xsl:attribute name="id"><xsl:value-of select="current()/own_slot_value[slot_reference='essential_id']/value"/></xsl:attribute>
	   <xsl:value-of select="current()/name"/></option>
	
	</xsl:template> 
</xsl:stylesheet>