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
    <xsl:variable name="anAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"/>
    <xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Information Reference Model']"></xsl:variable>

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Concept', 'Information_View','Information_Domain','Data_Object')"/>
    <xsl:variable name="infoDomains" select="/node()/simple_instance[type='Information_Domain']"/>
    <xsl:key name="infoDomainsTaxTerms" match="/node()/simple_instance[type='Taxonomy_Term']" use="own_slot_value[slot_reference='classifies_elements']/value"/>
    <xsl:key name="infoDomainsTaxonomy" match="/node()/simple_instance[type='Taxonomy']" use="own_slot_value[slot_reference='taxonomy_terms']/value"/>

    <xsl:variable name="taxTerms" select="key('infoDomainsTaxTerms',$infoDomains/name)"/>
    <xsl:variable name="taxonomiesNames" select="key('infoDomainsTaxonomy',$taxTerms/name)"/>
    <xsl:variable name="taxonomies" select="$taxonomiesNames[own_slot_value[slot_reference='name']/value!='Reference Model Layout']"/>
    <xsl:key name="infoDomainsTaxTermsInverse" match="$taxTerms" use="own_slot_value[slot_reference='term_in_taxonomy']/value"/>
    <xsl:key name="infoDomainsTaxkey" match="$infoDomains" use="own_slot_value[slot_reference='element_classified_by']/value"/>
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
        <xsl:call-template name="docType"/>
        <xsl:variable name="apiPath">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIReport"/>
            </xsl:call-template>
        </xsl:variable>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
                <title>Information Reference Model  </title>
                <style>
                    
                    #modelHolder {
                        display: flex;
                        gap: 15px;
                        width: 100%;
                        flex-direction: column; 
                    }
                    #modelHolder a {color: #24806f;}
                  
                    .taxonomy{
                        position: relative;
                        background-color: #ffffff;
                        padding:2px;
                        border:1px solid #d3d3d3;
                        border-radius:6px;
                        text-align: left; 
                        border-left:5px solid #2a573e;
                    }
                    .taxonomy::before {
                        content: ''; /* Adds a pseudo-element inside the .taxonomy element */
                        position: absolute;
                        top: 50%; /* Center vertically */
                        left: 50%; /* Center horizontally */
                        transform: translate(-50%, -50%) rotate(-90deg); /* Positions and rotates the text */
                        transform-origin: center; /* Ensures rotation happens from the center */
                        white-space: nowrap; /* Prevents text wrapping */
                    }
                    
                    /* Example usage for text inside the element */
                    .taxonomy h3 {
                        position: absolute;
                        top: 50%; /* Center vertically in the middle of the container */
                        left: 20px; /* Center horizontally in the middle of the container */
                        transform: translate(-50%, -50%) rotate(-90deg); /* Rotate around its center */
                        transform-origin: center; /* Ensures rotation happens around the center */
                        white-space: nowrap; /
                    }
                    .domain {
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative;
                        min-height:80px;
                        border-left: 3px solid #207465;
                        position: relative;
                        background-color: hsla(130, 50%, 99%, 1);
                        margin:2px;
                        margin-left:40px;
                    }
                    .domainColumn {
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative;
                        min-height:80px;
                        width:19%;
                        border-left: 3px solid #207465;
                        position: relative;
                        background-color: hsla(130, 50%, 99%, 1);
                        margin:2px;
                        margin-left:2px;
                    }
                    .domain-container {
                        display: flex;             /* Makes the container a flex container */
                        flex-wrap: wrap;           /* Allows the items to wrap to the next line if needed */
                        justify-content: flex-start; /* Aligns items to the start of the container */
                        margin-left: 40px;        /* Counteracts the left margin of the first item */
                    }
                    .concept-wrapper,.infoview-wrapper {
                        display: flex;
                        flex-direction: row;
                        flex-wrap: wrap;
                        gap: 15px;

                        justify-content: flex-start;
                    }
                    .concept i {
                        color: #24806f;
                    }
                    
                    .infoview i {
                        position: absolute;
                        bottom: 5px;
                        right: 5px;
                        color: #24806f;
                    }
                    
                    .concept {
                        padding: 5px 5px 30px 5px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative;
                        min-height:80px;
                        min-width: 200px;
                        max-width: 400px;
                        background-color: hsla(130, 50%, 90%, 1);
                        position: relative;
                    }
                    .conceptColumn {
                        padding: 5px 5px 5px 5px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative; 
                        min-width: 200px;
                        max-width: 400px;
                        background-color: hsla(130, 50%, 90%, 1);
                        position: relative;
                    }
                    .infoview{
                        padding: 5px 5px 30px 5px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative;
                        min-height:80px;
                        background-color: #fff;
                        min-width: 160px;
                        max-width: 160px;
                        position: relative;
                    }
                    .infoviewColumn{
                        padding: 5px 5px 5px 5px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative;
                        min-height:20px;
                        background-color: #fff;
                        min-width: 160px;
                        max-width: 160px;
                        position: relative;
                    }
                    .headName{
                        font-size: 10px;    
                        position: absolute;
                        top: 5px;
                        right: 5px;
                        color:#aaa;
                    }
                    .conceptheadName, .viewheadName, .dataObjBoxHeader{
                        font-size: 10px;    
                        position: absolute;
                        bottom: 5px;
                        left: 5px;
                        color:#aaa;
                    }
                    .conceptheadNameCol, .viewheadNameCol, .dataObjBoxHeaderCol{
                        
                        font-size: 10px;    
                        position: absolute;
                        top: 20px;
                        left: 5px;
                        color:#aaa;
                    }
                    #infoPanel {
                        background-color: rgba(0,0,0,0.85);
                        padding: 10px;
                        border-top: 1px solid #ccc;
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        z-index: 100;
                        width: 100%;
                        height: 350px;
                        color: #fff;
                    }
                    .dataObjBox a {
                        color: #24806f;
                    }
                    .dataObjBox{
                        position:relative;
                        display:inline-block;
                        border-radius:6px;
                        height:70px;
                        width:160px;
                        margin:5px;
                        padding:5px;
                        background-color: hsla(130, 50%, 95%, 1);
                        vertical-align:top;
                        border:1px solid #ccc;
                        word-break: break-all;
                    }      
                    .domain, .domainColumn, .conceptColumn, .infoviewColumn, .concept, .infoview, conceptheadNameCol, .viewheadNameCol, .dataObjBoxHeaderCol,conceptheadName, .viewheadName, .dataObjBoxHeader {
                        transition: all 1s ease; /* Adjust time and easing function as needed */
                      }      
                      .domainDictionary{
                        
                      }
                      .conceptDictionary{
                        padding-left:20px;
                        
                      }
                      .infoviewDictionary{

                        padding-left:40px;

                      }
                      //to override font-awesome
                      .italic-text {
                        font-style: italic;
                        }
                    .domainText{
                        font-size:1.2em;
                    }
                    .conceptText{
                        font-size:1.1em;
                    }
                    .infoviewText{
                        font-size:1em;
                    }
                    .taxonomyBox{
                        padding-left:20px;
                    }

                    .taxonomyBox, .domainDictionary, .conceptDictionary {
                        margin-left: 20px;
                        background: white;
                        padding: 10px;
                        border-left: 1px solid #d3d3d3;
                        margin-bottom: 5px;
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
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="$theReport/own_slot_value[slot_reference='report_label']/value"/></span>
								</h1>
							</div>
                            <div class="pull-right"><xsl:value-of select="eas:i18n('Style')"/>:<xsl:text> </xsl:text>
                                <i class="fa fa-columns boxStyle" id="col"></i>
                                <xsl:text> </xsl:text>
                                <i class="fa fa-align-justify boxStyle" id="row"></i>
                                <xsl:text> </xsl:text>
                                <i class="fa fa-book" id="dictionary"></i>
                            </div>
						</div>
                        <div class="col-xs-12" id="taxonomySelectBox">
                           <b><xsl:value-of select="eas:i18n('Taxonomy')"/>:</b><xsl:text> </xsl:text> <select id="taxonomySelect"/>
                        </div>
                        <div class="col-xs-12">
                            <div id="modelHolder"/>
                            <div id="dictionaryHolder"/>
                        </div>
						<!--Setup Closing Tags-->
					</div>
				</div>
                <div class="infoPanel" id="infoPanel">
						<div id="infoData"></div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
                <xsl:call-template name="Footer"/>
                <script>
                    <xsl:call-template name="RenderViewerAPIJSFunction">
                        <xsl:with-param name="viewerAPIPath" select="$apiPath"/>  
                        <!-- one for each report set above -->
                    </xsl:call-template>
                </script> 
                <script id="info-template" type="text/x-handlebars-template">
                    <div class="row">
                        <div class="col-sm-8">
                            <h4 class="text-normal strong inline-block right-30" >{{this.name}}</h4>
                        </div>
                        <div class="col-sm-4">
                            <div class="text-right">
                                <i class="fa fa-times closePanelButton left-30"></i>
                            </div>
                            <div class="clearfix"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            {{#if this.description}}
                                <p><strong><xsl:value-of select="eas:i18n('Description')"/>: </strong>{{this.description}}</p>
                                <br/>
                            {{/if}}
                            {{#each this.dataObjects}}
                            <div class="dataObjBox">
                                <strong>{{{essRenderInstanceMenuLinkLight this}}}</strong>
                                <div class="dataObjBoxHeader">Data Object</div>
                            </div>
                            {{/each}}
                            {{#each this.info_concepts}}
                                <div class="dataObjBox">
                                    <strong>{{{essRenderInstanceMenuLinkLight this}}}</strong>
                                    <div class="dataObjBoxHeader">Information Concept</div>
                                </div>
                            {{/each}}
                            {{#each this.infoViews}}
                                 <div class="dataObjBox">
                                     <strong>{{{essRenderInstanceMenuLinkLight this}}}</strong>
                                     <div class="dataObjBoxHeader">Information View</div>
                                 </div>
                            {{/each}}
                        </div>
                    </div>
                </script>
                <script id="dictionary-template" type="text/x-handlebars-template">
                    {{#if this.taxonomies}}
                    {{#each this.taxonomies}}
                       <h3>  <i class="fa fa-chevron-right toggle taxonomyToggle"></i><xsl:text> </xsl:text>{{this.name}}</h3> 
                        <div class="taxonomyBox">
                        {{#each this.domains}} 
                        <div class="domainDictionary">
                            <i class="fa fa-chevron-right toggle"></i><xsl:text> </xsl:text> <span class="impact large right-5 domainText">{{{essRenderInstanceMenuLinkLight this}}}</span><i class="italic-text">(Domain)</i> <br/>
                            {{#if this.description}}
                            <b>Description:</b>: <xsl:text> </xsl:text> {{this.description}}
                            {{/if}}
                              
                            {{#each this.info_concepts}}
                            <div class="conceptDictionary">
                             <i class="fa fa-chevron-right toggle"></i><xsl:text> </xsl:text>   
                             <span class="strong right-5 conceptText">{{{essRenderInstanceMenuLinkLight this}}}</span><i class="italic-text">(Information Concept)</i> <br/>
                             {{#if this.description}}
                              <b>Description:</b>: <xsl:text> </xsl:text>{{this.description}}
                            {{/if}}
                                {{#each this.infoViews}}
                                    <div class="infoviewDictionary">
                                        <i class="fa fa-caret-right infoviewText"></i><xsl:text> </xsl:text>   
                                        <span class="right-5 small">{{{essRenderInstanceMenuLinkLight this}}}</span><i class="italic-text">(Information View)</i> <br/>
                                        {{#if this.description}}
                                        <b>Description:</b>: <xsl:text> </xsl:text> {{this.description}}
                                        {{/if}}
                                    </div>
                                {{/each}}
                                </div> 
                            {{/each}}
                            </div>
                        {{/each}}
                    </div>
                {{/each}}
                {{else}}  
                {{#each this}} 
                <div class="domainDictionary">
                    <i class="fa fa-chevron-right toggle"></i><xsl:text> </xsl:text> <span class="impact large right-5 domainText">{{{essRenderInstanceMenuLinkLight this}}}</span><i class="italic-text">(Domain)</i> <br/>
                    {{#if this.description}}
                    <b>Description:</b>: <xsl:text> </xsl:text> {{this.description}}
                    {{/if}}
                    {{#each this.info_concepts}}
                    <div class="conceptDictionary">
                        <i class="fa fa-chevron-right toggle"></i><xsl:text> </xsl:text>   
                        <span class="strong right-5 conceptText">{{{essRenderInstanceMenuLinkLight this}}}</span><i class="italic-text">(Information Concept)</i><br/>
                        {{#if this.description}}
                        <b>Description:</b>: <xsl:text> </xsl:text> {{this.description}}
                        {{/if}}
                        {{#each this.infoViews}}
                            <div class="infoviewDictionary">
                                <i class="fa fa-caret-right"></i><xsl:text> </xsl:text>   
                                <span class="right-5 small infoviewText">{{{essRenderInstanceMenuLinkLight this}}}</span><i class="italic-text">(Information View)</i><br/>
                                {{#if this.description}}
                                <b>Description:</b>: <xsl:text> </xsl:text> {{this.description}}
                                {{/if}}
                            </div>
                        {{/each}}
                        </div> 
                    {{/each}}
                    </div>
                {{/each}}
     
                {{/if}}

                </script>
                <script id="taxonomy-template" type="text/x-handlebars-template">
                    {{#each this.taxonomies}} 
                        <div class="taxonomy">
                            <h3>{{this.name}}</h3>
                            <div class="domain-container">
                            {{#each this.domains}} 
                            <div class="domain">
                                <div class="headName">Domain</div> 
                                <div class="bottom-10">
                                    <span class="impact large right-5">{{{essRenderInstanceMenuLinkLight this}}}</span>
                                    <i class="fa fa-info-circle">
                                        <xsl:attribute name="id">{{this.id}}</xsl:attribute><xsl:attribute name="easType">domain</xsl:attribute>
                                    </i>
                                </div>
                                <div class="concept-wrapper">
                                {{#each this.info_concepts}}
                                <div class="concept">
                                    <div class="conceptheadName">Information Concept</div>
                                    <div class="bottom-10">
                                        <span class="strong right-5">{{{essRenderInstanceMenuLinkLight this}}}</span>
                                        <i class="fa fa-info-circle"><xsl:attribute name="id">{{this.id}}</xsl:attribute><xsl:attribute name="easType">concept</xsl:attribute></i>
                                    </div>                
                                    <div class="infoview-wrapper">
                                    {{#each this.infoViews}}
                                        <div class="infoview">
                                            <div class="viewheadName">Information View</div>
                                            <div class="bottom-10">
                                                <span class="right-5 small">{{{essRenderInstanceMenuLinkLight this}}}</span>
                                                <i class="fa fa-info-circle">
                                                    <xsl:attribute name="id">{{this.id}}</xsl:attribute>
                                                    <xsl:attribute name="easType">view</xsl:attribute>
                                                </i>
                                            </div>
                                        </div>
                                    {{/each}}
                                    </div>
                                </div>
                                {{/each}}
                                </div>
                            </div>
                        {{/each}}
                        </div>
                     </div>
                    {{/each}}
                </script>    
                <script id="panel-template" type="text/x-handlebars-template">
                    {{#each this}} 
                        <div class="domain">
                            <div class="headName">Domain</div> 
                            <div class="bottom-10">
                                <span class="impact large right-5">{{{essRenderInstanceMenuLinkLight this}}}</span>
                                <i class="fa fa-info-circle">
                                    <xsl:attribute name="id">{{this.id}}</xsl:attribute><xsl:attribute name="easType">domain</xsl:attribute>
                                </i>
                            </div>
                            <div class="concept-wrapper">
                            {{#each this.info_concepts}}
                            <div class="concept">
                                <div class="conceptheadName">Information Concept</div>
                                <div class="bottom-10">
                                    <span class="strong right-5">{{{essRenderInstanceMenuLinkLight this}}}</span>
                                    <i class="fa fa-info-circle"><xsl:attribute name="id">{{this.id}}</xsl:attribute><xsl:attribute name="easType">concept</xsl:attribute></i>
                                </div>                
                                <div class="infoview-wrapper">
                                {{#each this.infoViews}}
                                    <div class="infoview">
                                        <div class="viewheadName">Information View</div>
                                        <div class="bottom-10">
                                            <span class="right-5 small">{{{essRenderInstanceMenuLinkLight this}}}</span>
                                            <i class="fa fa-info-circle">
                                                <xsl:attribute name="id">{{this.id}}</xsl:attribute>
                                                <xsl:attribute name="easType">view</xsl:attribute>
                                            </i>
                                        </div>
                                    </div>
                                {{/each}}
                                </div>
                            </div>
                            {{/each}}
                            </div>
                        </div>
                    {{/each}}
                </script>
			</body>
		</html>
	</xsl:template>
<!-- add these 2 templates -->
<xsl:template name="RenderViewerAPIJSFunction">
        <xsl:param name="viewerAPIPath"/>  
        //a global variable that holds the data returned by an Viewer API Report, one for each report
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>'; 
        
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
       
       var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest(); 
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) { 
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            $('#ess-data-gen-alert').hide();
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
        <xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
                <xsl:with-param name="linkClasses" select="$linkClasses"/>
        </xsl:call-template>


    let taxonomies=[<xsl:apply-templates select="$taxonomies" mode="taxonomies"/>];
    console.log('taf',taxonomies)
    $('document').ready(function () {

        $('#taxonomySelect').select2({width:'250px'});
        $('#taxonomySelectBox').hide();
        $('.infoPanel').hide();
        var panelFragment = $("#panel-template").html();
        panelTemplate = Handlebars.compile(panelFragment); 

        var taxonomyFragment = $("#taxonomy-template").html();
        taxonomyTemplate = Handlebars.compile(taxonomyFragment); 

        var infoFragment = $("#info-template").html();
        infoTemplate = Handlebars.compile(infoFragment); 

        var dictionaryFragment = $("#dictionary-template").html();
        dictionaryTemplate = Handlebars.compile(dictionaryFragment); 

        Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
            return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
        }); 

            //get data
            Promise.all([
                    promise_loadViewerAPIData(viewAPIData) 
                    ]).then(function(responses) {
                        <!-- your code here --> 
                        let infoDoms = responses[0].info_domains;
                        let infoConcepts= responses[0].information_concepts;
                        let informationViews=responses[0].information_views;
                        let dataObjects=responses[0].data_objects;
                        $('#dictionaryHolder').hide();

                        infoDoms.forEach((d)=>{
                            let icArray=[];
                            d.infoConcepts.forEach((e)=>{
                                let match=infoConcepts.find((ic)=>{
                                    return ic.id==e.id;
                                })
                                icArray.push(match);
                            })

                                icArray.sort((a, b) => {
                                    // Convert the string values to numbers using parseInt (or Number)
                                    const seqA = parseInt(a.sequence_number, 10);
                                    const seqB = parseInt(b.sequence_number, 10);
                                    return seqA - seqB;
								});
                            console.log('icArray',icArray)
                            d['info_concepts']=icArray;
                        }) 

                        if(taxonomies.length&gt;0){
                            if(taxonomies.length&gt;1){    
                                $('#taxonomySelectBox').show();
                                
                                taxonomies.forEach((ta)=>{
                                    $('#taxonomySelect').append('<option value="' + ta.id + '">' + ta.name + '</option>');

                                })
                            }

                            console.log(taxonomies)
                            taxonomies.forEach((tx)=>{
                            tx.taxonomies.forEach((t) => {
                                t.domains.forEach((dom) => { 
                                    let match = infoDoms.find((infodom) => dom.id == infodom.id);
                                    if (match) {
                                        Object.keys(match).forEach(key => {
                                            dom[key] = match[key];
                                        });
                                        dom.order = dom.order; // Preserve the original order if necessary
                                    }
                                });
                                console.log('t', t);
                                t.domains.sort((a, b) => {
                                    // Check if 'order' is blank, undefined, or null
                                    let isABlank = a.order === '' || a.order === undefined || a.order === null;
                                    let isBBlank = b.order === '' || b.order === undefined || b.order === null;
                            
                                    if (isABlank &amp;&amp; isBBlank) return 0; // Both are blank, keep original order
                                    if (isABlank) return 1; // a is blank, so it should come last
                                    if (isBBlank) return -1; // b is blank, so it should come last
                            
                                    // Otherwise, sort by 'order' normally
                                    return a.order - b.order;
                                });
                            });
                                tx.taxonomies.sort((a, b) => {
                                    // Check if 'order' is blank, undefined, or null
                                    let isABlank = a.order === '' || a.order === undefined || a.order === null;
                                    let isBBlank = b.order === '' || b.order === undefined || b.order === null;
                            
                                    if (isABlank &amp;&amp; isBBlank) return 0; // Both are blank, keep original order
                                    if (isABlank) return 1; // a is blank, so it should come last
                                    if (isBBlank) return -1; // b is blank, so it should come last
                            
                                    // Otherwise, sort by 'order' normally
                                    return a.order - b.order;
                                });
                            })
                            
                            console.log('...tax', taxonomies)
                            $('#modelHolder').html(taxonomyTemplate(taxonomies[0]))
                        }else{

                            $('#modelHolder').html(panelTemplate(infoDoms))
                            $('.domain').css('margin-left','5px')
                            
                        }
                       
                        $('#taxonomySelect').on('change', function(){

                            console.log('ts', $(this).val())
                           let selected = taxonomies.find((tx)=>{
                                return tx.id==$(this).val()
                            })
                            $('#dictionaryHolder').hide()
                            $('#modelHolder').show()
                            
                            $('#modelHolder').html(taxonomyTemplate(selected))
                        })
                        $('.fa-info-circle').off().on('click', function(){
                            let thisId= $(this).attr('id');
                            let eastype=$(this).attr('easType');
                   
                            let focusObject;
                            if(eastype=='domain'){
                                focusObject=infoDoms.find((d)=>{
                                    return d.id==thisId
                                })  
                            }
                            else
                            if(eastype=='concept'){
                                focusObject=infoConcepts.find((d)=>{
                                    return d.id==thisId
                                }) 
                            }
                            else
                            if(eastype=='view'){
                                focusObject=informationViews.find((d)=>{
                                    return d.id==thisId
                                })  

                                focusObject.dataObjects.forEach((f)=>{
                                    let thisDo=dataObjects.find((e)=>{
                                        return e.id==f.id;
                                    })
                                    f['name']=thisDo.name;
                                    f['className']='Data_Object'
                                })

                            }
 
                            $('#infoData').html(infoTemplate(focusObject));
                            $('.infoPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
                    
                            //$('#appModal').modal('show');
                            $('.closePanelButton').on('click',function(){ 
                                $('.infoPanel').hide();
                            })
                    })

                    $('#dictionary').on('click', function(){

                        let tax=$('#taxonomySelect').val();
            
                            console.log('ts',tax);
                            
                           let selected = taxonomies.find((tx)=>{
                                return tx.id==tax
                            })
                            console.log('tx', taxonomies)
                            if(selected){
                                $('#dictionaryHolder').html(dictionaryTemplate(selected))
                            }else  if(!selected &amp;&amp; taxonomies.length&gt;0){
                                $('#dictionaryHolder').html(dictionaryTemplate(taxonomies[0]))
                            }else{
                                console.log('none',infoDoms)
                                $('#dictionaryHolder').html(dictionaryTemplate(infoDoms))
                            }
                            $('#dictionaryHolder').show()
                            $('#modelHolder').hide()
                            $(".toggle").click(function() { 
                                $(this).toggleClass('fa-chevron-right fa-chevron-up'); 
                                if (!$(this).hasClass('taxonomyToggle')) {
                                $(this).parent().children('div').slideToggle("slow");
                                }else{
                                    console.log('has toggle')
                                    $(this).parent().next('div').slideToggle("slow");
                                }
                           
                            });
                    })
                    
        })

        function toggleClasses(idType) {
            const isCol = idType === 'col';
        
            // Define a mapping of selectors to their class changes
            const changes = {
                '.domain': 'domainColumn',
                '.concept': ['conceptColumn', 'concept'],
                '.infoview': 'infoviewColumn',
                '.conceptheadName': 'conceptheadNameCol',
                '.viewheadName': 'viewheadNameCol',
                '.dataObjBoxHeader': 'dataObjBoxHeaderCol'
            };
        
            // Iterate over the mapping and apply the appropriate class changes
            Object.entries(changes).forEach(([selector, classes]) => {
                if (Array.isArray(classes)) {
                    // When there are multiple classes to toggle
                    $(selector).toggleClass(classes[0], isCol)
                               .toggleClass(classes[1], !isCol);
                } else {
                    // When there is a single class to toggle
                    $(selector).toggleClass(classes, isCol);
                }
            });
        }

        $('.boxStyle').on('click', function(){
            let idType= $(this).attr('id');
            if(idType=='col'){
              toggleClasses(idType)
               
            }else{
                toggleClasses(idType)
            }
            $('#dictionaryHolder').hide()
            $('#modelHolder').show()

        })

        
    })

    function redraw(){
        console.log('redraw')
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
    <xsl:template name="RenderJSMenuLinkFunctionsTEMP">
		<xsl:param name="linkClasses" select="()"/>
		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
		var esslinkMenuNames = {
			<xsl:call-template name="RenderClassMenuDictTEMP">
				<xsl:with-param name="menuClasses" select="$linkClasses"/>
			</xsl:call-template>
		}
     
		function essGetMenuName(instance) {  
			let menuName = null;
			if(instance.meta?.anchorClass) {
				menuName = esslinkMenuNames[instance.meta.anchorClass];
			} else if(instance.className) {
				menuName = esslinkMenuNames[instance.className];
			}
			return menuName;
		}
		
        Handlebars.registerHelper('essRenderInstanceMenuLink', function(instance){

			if(instance != null) {
                let linkMenuName = essGetMenuName(instance); 
				let instanceLink = instance.name;    
				if(linkMenuName) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
                } 
                
				return instanceLink;
			} else {
				return '';
			}
        });
        
        Handlebars.registerHelper('essRenderInstanceMenuLinkLight', function(instance){
            console.log('i',instance)
			if(instance != null) {
                let linkMenuName = essGetMenuName(instance); 
				let instanceLink = instance.name;    
				if(linkMenuName) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
                } 
               
				return instanceLink;
			} else {
				return '';
			}
		});
    </xsl:template>
    <xsl:template name="RenderClassMenuDictTEMP">
            <xsl:param name="menuClasses" select="()"/>
            <xsl:for-each select="$menuClasses">
                <xsl:variable name="this" select="."/>
                <xsl:variable name="thisMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
                "<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
                </xsl:if>
            </xsl:for-each>
    </xsl:template>
<xsl:template match="node()" mode="taxonomies">
    <xsl:variable name="thisTaxTerms" select="key('infoDomainsTaxTermsInverse', current()/name)"/>
    {"id":"<xsl:value-of select="current()/name"/>",
    "name": "<xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="isForJSONAPI" select="false()"/>
         <xsl:with-param name="theSubjectInstance" select="current()"/>
    </xsl:call-template>",
    "taxonomies":[<xsl:for-each select="$thisTaxTerms">
    <xsl:variable name="thisDomains" select="key('infoDomainsTaxkey', current()/name)"/>
        {
        "id":"<xsl:value-of select="current()/name"/>",
        "name": "<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="isForJSONAPI" select="false()"/>
             <xsl:with-param name="theSubjectInstance" select="current()"/>
        </xsl:call-template>",
        "order":"<xsl:value-of select="current()/own_slot_value[slot_reference='taxonomy_term_index']/value"/>",
        "domains":[<xsl:for-each select="$thisDomains">{"id":"<xsl:value-of select="current()/name"/>","order":"<xsl:value-of select="current()/own_slot_value[slot_reference='sequence_number']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
        }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
    }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
</xsl:stylesheet>
