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

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Information_Concept', 'Information_View','Information_Domain','Data_Object')"/>
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
                    
                    .domain {
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        position:relative;
                        min-height:80px;
                        border-left: 3px solid #207465;
                        position: relative;
                        background-color: hsla(130, 50%, 99%, 1);
                    }
                    .concept-wrapper,.infoview-wrapper {
                        display: flex;
                        flex-direction: row;
                        flex-wrap: wrap;
                        gap: 15px;
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
									<span class="text-darkgrey">Information Reference Model</span>
								</h1>
							</div>
						</div>
                        <div class="col-xs-12">
                            <div id="modelHolder"/>
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
                                <p><strong>Description: </strong>{{this.description}}</p>
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
    $('document').ready(function () {
        $('.infoPanel').hide();
        var panelFragment = $("#panel-template").html();
        panelTemplate = Handlebars.compile(panelFragment); 

        var infoFragment = $("#info-template").html();
        infoTemplate = Handlebars.compile(infoFragment); 
        

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
                        infoDoms.forEach((d)=>{
                            let icArray=[];
                            d.infoConcepts.forEach((e)=>{
                                let match=infoConcepts.find((ic)=>{
                                    return ic.id==e.id;
                                })
                                icArray.push(match);
                            })
                            d['info_concepts']=icArray;
                        })
                       // responses[0]=[]; 

                        $('#modelHolder').html(panelTemplate(infoDoms))

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
                    
        })
    })
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
</xsl:stylesheet>
