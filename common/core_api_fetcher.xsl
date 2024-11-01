<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
<xsl:variable name="apiList" select="/node()/simple_instance[type='Data_Set_API']"/>
    <!-- Get an API Report instance using the common list of API Reports already captured by core_utilities.xsl -->

   
    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        <xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderAPILinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>
         
    </xsl:template>
    <xsl:template name="RenderViewerAPIJSFunction">

    let apis=[<xsl:apply-templates select="$apiList" mode="apis"/>]
   
        //a global variable that holds the data returned by an Viewer API Report
       // var apiArray=[];

        const apiArray = {};

        // Iterate over the original array and add entries to the object
        apis.forEach(item => {
            apiArray[item.label] = item.link;
        });
      
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
        
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState === 4) {
                            if (this.status === 200) {
                                var viewerData = JSON.parse(this.responseText);
                                resolve(viewerData);
                            } else {
                                reject(new Error('Failed to load: ' + this.status));
                            }
                        }
                    };
        
                    xmlhttp.onerror = function () {
                        reject(new Error('XMLHttpRequest error'));
                    };
        
                    xmlhttp.open("GET", apiDataSetURL, true);
                    xmlhttp.send();
                } else {
                    reject(new Error('Invalid URL'));
                }
            });
        };
        
        function fetchAndRenderData(apiNames) {
      
            let promises = apiNames.map(apiName => {
                let fileToLoad = apiArray[apiName]; 
               
                return promise_loadViewerAPIData(fileToLoad).then(response => ({ apiName, response }));
            });
        
            return Promise.all(promises)
                .then(function(responses) {
                    let responseObj = {};
                    responses.forEach(({ apiName, response }) => {
                        responseObj[apiName] = response;
      
                        // DO HTML stuff for each response if needed
                    });
                    return responseObj; // Return all responses as an object
                })
                .catch(function(error) {
                    // Display an error somewhere on the page
                    console.error('Error:', error);
                    displayError(error);
                    throw error; // Re-throw the error to ensure the promise is rejected
                });
        }
        
        
    </xsl:template>
    <xsl:template match="node()" mode="apis">
    {"id":"<xsl:value-of select="current()/name"/>",
    "name":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
    "path":"reportApi?XML=reportXML.xml&amp;XSL=<xsl:value-of select="current()/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>&amp;cl=en-gb",
    "link":"<xsl:call-template name="GetViewerAPIPath"><xsl:with-param name="apiReport" select="current()"/></xsl:call-template>",
    "label":"<xsl:value-of select="translate(translate(current()/own_slot_value[slot_reference = 'dsa_data_label']/value, ' ', '_'), ':','')"/>"
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
    
   
</xsl:stylesheet>