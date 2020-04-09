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
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BCM List']"/>
    <xsl:variable name="anAPIReportDeliveryModel" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'CORE API: Application List']"/>
    <xsl:variable name="anAPIReportInstance" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Simple Instance']"/>
    
   	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
    <xsl:template match="knowledge_base">
        	<xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathDM">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportDeliveryModel"/>
            </xsl:call-template>
        </xsl:variable>
         <xsl:variable name="apiPathInstance">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReportInstance"/>
            </xsl:call-template>
        </xsl:variable>
        <html>
            <head>
            	<xsl:call-template name="commonHeadContent"/>
                 <script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
            	<script src="https://d3js.org/d3.v4.min.js"></script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderEditorInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
            <style>
                              
			.node circle {
			  fill: #fff;
			  stroke: steelblue;
			  stroke-width: 3px;
			}
			
			.node text { font: 12px sans-serif; }
			
			.node--internal text {
			  text-shadow: 0 1px 0 #fff, 0 -1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff;
			}
			
			.link {
			  fill: none;
			  stroke: #ccc;
			  stroke-width: 2px;
			}                
                </style>
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
						<div class="col-xs-4">
							<div class="form-group">
								<label>Instance ID:</label>
								<input class="form-control" type="text" id="oid"></input>
								<button class="btn btn-success top-10" id="cli">Go</button>
							</div>	
						</div>
						<div class="col-xs-8">
							<div id="instancePanel"/>
						</div>
					</div>
            	</div>
           	<xsl:call-template name="Footer"/>    
            </body>
            <script>
            <xsl:call-template name="RenderViewerAPIJSFunction">
                <xsl:with-param name="viewerAPIPath" select="$apiPath"/>
                <xsl:with-param name="viewerAPIPath2" select="$apiPathInstance"/>
            </xsl:call-template>
      <!--      <xsl:call-template name="RenderViewerAPIJSFunction">
                <xsl:with-param name="viewerAPIPath" select="$apiPathDM"/>
            </xsl:call-template>    
          -->  
			</script>
            <script id="instance-template" type="text/x-handlebars-template">
            {{#if this.name}}
            	<div class="large bottom-10"><strong>{{this.name}}</strong></div>
            {{/if}}
            	<ul class="fa-ul">
            		{{#each instance}} 
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
            		{{/each}}
            	</ul>
            
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
        <xsl:param name="viewerAPIPath"/>
        <xsl:param name="viewerAPIPath2"/>
        //a global variable that holds the data returned by an Viewer API Report
        var viewAPIDataDM = '<xsl:value-of select="$viewerAPIPath"/>';
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath2"/>&amp;PMA=eas_prj_HH_baseline_rep_v11e_Class9221';
    
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
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
  var thisviewAPIData;   
        
        
function getData(dta){
     return promise_loadViewerAPIData(dta)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                thisviewAPIData = response1;
               //DO HTML stuff
               
       
         thisviewAPIData=response1;
      
            }).catch (function (error) {
                //display an error somewhere on the page   
            });
        }        
   
async function getNode(parent,idToCall,pos){
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath2"/>&amp;PMA='+idToCall;
        console.log('calling');
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

    $('#'+parent).append(instanceCardTemplate(thisviewAPIData));
       
         $('.fa').click(function(d){
			var idToCall2=$(this).attr('id');
			var parentDiv=$(this).parent().attr('id');
			$(this).toggleClass('fa-caret-right');
			$(this).toggleClass('fa-caret-down');
			//$(this).next().next('ul').slideToggle();
			getNode(parentDiv,idToCall2,2);
        })
            
        
        };        
        
        
        $('document').ready(function () {
         var instanceCardFragment   = $("#instance-template").html();
         instanceCardTemplate = Handlebars.compile(instanceCardFragment); 
      <!--      //OPTON 1: Call the API request function multiple times (once for each required API Report), then render the view based on the returned data
            Promise.all([
                promise_loadViewerAPIData(apiUrl1),
                promise_loadViewerAPIData(apiUrl2)
            ])
            .then(function(responses) {
                //after the data is retrieved, set the global variable for the dataset and render the view elements from the returned JSON data (e.g. via handlebars templates)
                viewAPIData = responses[0];
                //render the view elements from the first API Report
                anotherAPIData = responses[1];
                //render the view elements from the second API Report
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
            
          -->  
            //OPTON 2: Chain multiple promises so that you can retrieve API Report data and update view elements incrementally
            //I THINK THIS IS THE OPTION YOU WANT IF YOU WANT TO RENDER THE IT ASSET DASHBOARD INCREMENTALLY
        
        
    $('#cli').click(function(){  
          $("#instancePanel").empty();
        var objID=$('#oid').val();
     
       getNode('instancePanel',objID,1);
        
        });
        
        
        $('#click').click(function(){
        $("#svgpanel").empty();
        promise_loadViewerAPIData(viewAPIDataDM)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                viewAPIData2 = response1;
                 //DO HTML stuff
    				
            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
        
        });
   
       
       
        
        });
        
    </xsl:template>
    
</xsl:stylesheet>