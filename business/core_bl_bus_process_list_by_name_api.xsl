<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"></xsl:import>
	 <xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS --> 

    <xsl:param name="viewScopeTermIds"/>
    <xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/> 

	<!-- END GENERIC CATALOGUE PARAMETERS -->
    <xsl:variable name="repYN"><xsl:choose><xsl:when test="$targetReportId"><xsl:value-of select="$targetReportId"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>

	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process')"/>

	<!-- START GENERIC LINK VARIABLES -->
 	<!-- END GENERIC LINK VARIABLES -->
 
	 <xsl:variable name="busProcessRoadmap" select="/node()/simple_instance[type='Business_Process']"/>

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
 	 
	<xsl:variable name="processData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"></xsl:variable>
	   <xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiProcs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$processData"></xsl:with-param>
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
                <title><xsl:value-of select="eas:i18n('Business Process Catalogue by Name')"/></title>
              	<!--script to support smooth scroll back to top of page-->
			 
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<style>
					.CharacterContainer {
                            text-align: center;
                            font-size: 1.2em;
                            line-height: 1.5em;
                            background-color: #fff;
                            color: #000;
                            cursor: pointer; 
                            display:inline-block
                            }
					.CharacterElement {
                                margin: 1px;
                                display:inline-block;
                                cursor: pointer; 
                            }
                            
                    .Inactive {
                                color: #f0f0f0;
                                cursor: default;
                            }
                    .Active {
                                font-size: 1.2em;
                                font-weight:bold;
                                color:#000;
                                cursor: default;
								background-color:#e1e1e1;
                            } 
                    .list {padding-left:10px}   

                    .caps {
						padding:1px;
                        border-left: 2pt solid #3fceb9;
                        font-size:1.1em; 
                    }        
					.charBox{
						display:inline-block;
						border:1pt solid #d3d3d3;
					}                 
                                   
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process Catalogue by Name')"/></span>
								</h1>
							</div>
                        </div> 
                        <div class="col-xs-12">
 
                            <div id="nav" class="CharacterContainer"></div>

                            <div id="list" class="list top-15"></div>
                        </div>
                    </div>
                </div>
						
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>

				<!-- caps template -->
		
            </body>
			<script id="char-template" type="text/x-handlebars-template">
				{{#each this}}
				<div><xsl:attribute name="class">charBox CharacterElement {{#ifEquals @index 0}}Active{{/ifEquals}}</xsl:attribute><xsl:attribute name="easId">Letter{{#ifEquals this '.'}}dot{{else}}{{this}}{{/ifEquals}}</xsl:attribute>
					{{this}}
				</div>
				{{/each}}
			</script>
            <script id="list-template" type="text/x-handlebars-template">
                {{#each this.processes}} 
                        <div class="col-xs-4">
                            <div class="caps bottom-5">
								{{#essRenderInstanceLinkSelect this 'Business_Process'}}{{/essRenderInstanceLinkSelect}}{{#essRenderInstanceLink this 'Business_Process'}}{{/essRenderInstanceLink}} 
                            </div>
                        </div>  
                 {{/each}}    
			</script>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
                    <xsl:with-param name="viewerAPIPathProcs" select="$apiProcs"></xsl:with-param> 
				</xsl:call-template>  
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPathProcs"></xsl:param> 
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPathProcs"/>';
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		var promise_loadViewerAPIData = function (apiDataSetURL) {
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
		// numbering based on: http://www.matthiassommer.it/programming/frontend/alphabetical-list-navigation-with-javascript-html-and-css/
		let createArrayAtoZ = _ => {
			return Array
				.apply(null, {
					length: 26
				})
				.map((x, i) => String.fromCharCode(65 + i));
		}

		let createNavigationList = _ => {
			let abcChars = createArrayAtoZ();
			let rest=["0","1","2","3","4","5","6","7","8","9",".","#"]
	 
			abcChars=abcChars.concat(rest); 
		//	const navigationEntries = abcChars.reduce(createDivForCharElement, '');
		
			$('#nav').append(charTemplate(abcChars))
		}

		let createDivForCharElement = (block, charToAdd) => {
			if(charToAdd=='.'){
				return block + "&lt;div id='CharacterElement' class='CharacterElement Inactive dot'>" + charToAdd + "&lt;/div>";
			}else
			{
				return block + "&lt;div id='CharacterElement' class='CharacterElement Inactive " + charToAdd + "'>" + charToAdd + "&lt;/div>";
			}
		}
  
		var characterToShow = 'A';
		//interim fix for roadmaps/     
	 	var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';

		$('document').ready(function () {
			listFragment = $("#list-template").html();
			listTemplate = Handlebars.compile(listFragment);

			charFragment = $("#char-template").html();
			charTemplate = Handlebars.compile(charFragment);

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});

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
			
			Handlebars.registerHelper('essRenderInstanceLinkSelect', function (instance,type) {

				let targetReport = "<xsl:value-of select="$repYN"/>";
		 
				if (targetReport.length &gt; 1) {
			 
					if (instance != null) {
						let linkMenuName = essGetMenuName(instance);
						let instanceLink = instance.name;
					 
						if (linkMenuName != null) {
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
							let linkClass = 'context-menu-' + linkMenuName;
							let linkId = instance.id + 'Link';
							let linkURL = reportURL;
							instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15"> ' + linkClass + '" href="' + linkHref + '" id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select1</button>'
			
						} else if (instanceLink != null) {
							let linkURL = reportURL;
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
							let linkClass = 'context-menu-' + linkMenuName;

							let linkId = instance.id + 'Link';
						//	instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';
							instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15" onclick="location.href=&quot;' + linkHref + '&quot;" id="' + linkId+'"><i class="text-success fa fa-check-circle right-5"></i>Select2</button>'
			
							
		
							return instanceLink;
						} else {
							return '';
						}
					}
				} else {
		 
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
		                let linkURL = reportURL; 
						instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15 ' + linkClass + '" href="' + linkHref + '"  id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'
			
		                return instanceLink;
		            }
				}
			});
			
			Handlebars.registerHelper('essRenderInstanceLink', function (instance,type) {

				let targetReport = "<xsl:value-of select="$repYN"/>";
		 
				if (targetReport.length &gt; 1) {
			 
					if (instance != null) {
						let linkMenuName = essGetMenuName(instance);
						let instanceLink = instance.name;
						if (linkMenuName != null) {
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
							let linkClass = 'context-menu-' + linkMenuName;
							let linkId = instance.id + 'Link';
							let linkURL = reportURL;
							instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';
						} else if (instanceLink != null) {
							let linkURL = reportURL;
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
							let linkClass = 'context-menu-' + linkMenuName;

							let linkId = instance.id + 'Link';
							instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';

							return instanceLink;
						} else {
							return '';
						}
					}
				} else {
		 
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
		                let linkURL = reportURL;
		                instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';
				 
		                return instanceLink;
		            }
				}
			});
			let busProcArr = [];
			createNavigationList()
			Promise.all([
				promise_loadViewerAPIData(viewAPIData) 
			]).then(function (responses) {
				meta = responses[0].meta;
				busProcArr = responses[0].businessProcesses  
			 
 
				busProcArr.forEach((d) => {
					d['meta'] = meta.filter((d) => {
						return d.classes.includes('Business_Process')
					})
				});

				roadmapCaps = [];

				essInitViewScoping(redrawView, ['Group_Actor', 'Geographic_Region', 'Product_Concept', 'SYS_CONTENT_APPROVAL_STATUS'], '', true);


				$('.CharacterElement').on('click', function () {
					$('.CharacterElement').removeClass('Active');
					characterToShow = $(this).html();
					$(this).addClass('CharacterElement Active');
					redrawScope();
				})

			}).catch(function (error) {
				//display an error somewhere on the page
			});


			var redrawView = function () { 
				essResetRMChanges();
				typeInfo = {
					"className": "Business_Process",
					"label": 'Business Process',
					"icon": 'fa-chevron-double-right'
				}
			 
				let capOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
				let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
				let prodConceptScopingDef = new ScopingProperty('prodConIds', 'Product_Concept');
				let domainScopingDef = new ScopingProperty('domainIds', 'Business_Domain');

				let scopedProc = essScopeResources(busProcArr, [capOrgScopingDef, geoScopingDef, prodConceptScopingDef, domainScopingDef], typeInfo);

				let showProcs = scopedProc.resources; 
				showProcs=showProcs.sort((a, b) => (a.name.toLowerCase() > b.name.toLowerCase()) ? 1 : ((b.name.toLowerCase() > a.name.toLowerCase()) ? -1 : 0))
				let chosenProcs = showProcs.filter((d) => {
					return d.name.toUpperCase().substr(0, 1) == characterToShow.trim();
				})
			 
				let viewArray = {};

				viewArray['type'] = "<xsl:value-of select="$repYN"/>";
				viewArray['processes'] = chosenProcs
 
				$('#list').html(listTemplate(viewArray));
 
				let newChars = [];
				showProcs.forEach((d) => {
					newChars.push(d.name.toUpperCase().substr(0, 1))
				});

				$('.CharacterElement').css({
					"border-bottom": "1pt solid #d3d3d3",
					"width": "22px",
					"padding":"3px"
				})

				let uniq = [...new Set(newChars)];
				uniq.forEach((ch) => {
					if(ch=='.'){ch='dot'} 
					$('div [easId="Letter' + ch+'"]').css({
						"border-bottom": "2pt solid red",
						"width": "22px"
					})
				});

			}
		});

		function redrawScope() {
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
