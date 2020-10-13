<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Capability', 'Application_Service', 'Application_Provider', 'Technology_Capability', 'Technology_Component', 'Technology_Product')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<xsl:variable name="confluenceLogoPath">user/images/confluence_icon.png</xsl:variable>

	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>

	
	<xsl:variable name="trmReportAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Technology Reference Model Summary Data']"/>
	<xsl:variable name="trmReportAPIPath">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$trmReportAPI"/>
		</xsl:call-template>
	</xsl:variable>
	
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
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Technology Reference Model</title>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				

				<xsl:call-template name="summaryRefModelLegendInclude"/>
				
				<script type="text/javascript">
					
					var trmTemplate, techDetailTemplate, techDomainTemplate, ragOverlayLegend, noOverlayTRMLegend;
					var currentTechDomain;
					
					const trmMode = 'TRM';
					const techDomainMode = 'TECH_DOMAIN';
					
					var currentMode = trmMode;
					
					var scaleOptions = {};
					
				  	
				  	// the list of JSON objects representing the technology domains in use across the enterprise
				  	var techDomains = {
						techDomains: [     <!--<xsl:apply-templates select="$allTechDomains" mode="RenderTechDomains"/>-->
				    	]
				  	};
				  	
				  	// the JSON objects for the Technology Components and Products that implement Technology Capabilities
				  	var techCapDetails = [
				  		<!--<xsl:apply-templates select="$allTechCaps" mode="TechCapDetails"/>-->
				  	];
				  	
				  	
				  	// the list of JSON objects representing the technology components in use across the enterprise
				  	var techComponents = {
						techComponents: [<!--<xsl:apply-templates select="$allTechComps" mode="RenderTechCompDetails"/>-->
				    	]
				  	};
				  	
				  	
				  	$('html').on('click', function(e) {
					  if (typeof $(e.target).data('original-title') == 'undefined' &amp;&amp; !$(e.target).parents().is('.popover.in')) {
					    $('[data-original-title]').popover('hide');
					  }
					});
				 
                 
					// the JSON objects for the Technology Reference Model (TRM)
				  	var trmData = {
				  		top: [],
				  		left: [],
				  		middle: [],
				  		right: [],
				  		bottom: []
				  	};
			
				  				  	
				  	<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
					
					//function to initialise the child technology capabilities for the technology domains
					function initTechDomains() {
						techDomains.techDomains.forEach(function (aTD) {
							var techCapIds = aTD.childTechCapIds;
							var childTechCaps = getObjectsByIds(techCapDetails, "id", techCapIds);
							aTD.childTechCaps = childTechCaps;
						});
					}
					
					
					//function to initialise the ralising technology components for the technology capabilities
					function initTechCapabilities() {
						techCapDetails.forEach(function (aTechCap) {
							var techCompIds = aTechCap.techComponentIds;
							var thisTechComponents = getObjectsByIds(techComponents.techComponents, "id", techCompIds);
							aTechCap.techComponents = thisTechComponents;
						});
					}
					
					//function to initialise the TRM data structure
					function initTRMData() {
						var topLayer = '<xsl:value-of select="$topRefLayer/own_slot_value[slot_reference = 'name']/value"/>';
						var topLayerDomains = techDomains.techDomains.filter(function(aTD) {return aTD.refLayer == topLayer});
						trmData.top = topLayerDomains;
					
						var leftLayer = '<xsl:value-of select="$leftRefLayer/own_slot_value[slot_reference = 'name']/value"/>';
						var leftLayerDomains = techDomains.techDomains.filter(function(aTD) {return aTD.refLayer == leftLayer});
						trmData.left = leftLayerDomains;
					
						var middleLayer = '<xsl:value-of select="$middleRefLayer/own_slot_value[slot_reference = 'name']/value"/>';
						var middleLayerDomains = techDomains.techDomains.filter(function(aTD) {return aTD.refLayer == middleLayer});
						trmData.middle = middleLayerDomains;
						
						var rightLayer = '<xsl:value-of select="$rightRefLayer/own_slot_value[slot_reference = 'name']/value"/>';
						var rightLayerDomains = techDomains.techDomains.filter(function(aTD) {return aTD.refLayer == rightLayer});
						trmData.right = rightLayerDomains;
						
						var bottomLayer = '<xsl:value-of select="$bottomRefLayer/own_slot_value[slot_reference = 'name']/value"/>';
						var bottomLayerDomains = techDomains.techDomains.filter(function(aTD) {return aTD.refLayer == bottomLayer});
						trmData.bottom = bottomLayerDomains;
					
					}
					
					//function that returns the style class for a reference moel element
					function getDuplicationStyle(count, rootClass) {
						if(count == 0) {
							return rootClass + ' bg-lightgrey';
						} else if(count &lt; 2) {
							return rootClass + ' bg-purple-20';
						} else if((count >= 2) &amp;&amp; (count &lt;= 3)) {
							return rootClass + ' bg-purple-60';
						} else {
							return rootClass + ' bg-purple-100';
						}
					}
					
					
					//function to update the overlay legend
					function updateOverlayLegend() {
						var techOverlay = $('input:radio[name=techOverlay]:checked').val();
						if(techOverlay =='none') {
							//show the basic overlay legend
							$("#trmLegend").html(noOverlayTRMLegend);
						} else {
							//show rag overlay legend
							$("#trmLegend").html(ragOverlayLegend);
						}
					}
					
	
					<!-- START PAGE DRAWING FUNCTIONS -->
					
					//funtion to set the Technology Domain model products in scope
					function setTechDomainProducts(aTechDomain) {
						var techDomainProdCount, techCapProdCount, techCompProdCount;
						techDomainProdCount = 0;
						aTechDomain.childTechCaps.forEach( function(aTechCap) {
							 techCapProdCount = 0;
							 aTechCap.techComponents.forEach( function(aTechComp) {
								let thisTechProdCount = aTechComp['techProdCount'];
								techCapProdCount = techCapProdCount + thisTechProdCount;
								techDomainProdCount = techDomainProdCount + thisTechProdCount;
							});
							aTechCap.techComponents.sort(function(a, b){return b.techProdCount - a.techProdCount});
							aTechCap['techProdCount'] = techCapProdCount;
						});
						aTechDomain['techProdCount'] = techDomainProdCount;		
					}
					
					//function to set the current overlay
					function setOverlay() {
						updateOverlayLegend();
						if(currentMode == trmMode) {
							refreshTechCapabilityOverlay();
						} else {
							refreshTechDomainOverlay();
						}
					}
					
					
					//funtion to set the TRM Overlay
					function refreshTechCapabilityOverlay() {
						var thisTechCapBlobId, thisTechCapId, thisTechCap;
		
						$('.techRefModel-blob').each(function() {
							thisTechCapId = $(this).attr('eas-id');
							//thisTechCapId = thisTechCapBlobId.substring(0, (thisTechCapBlobId.length - 5));
							thisTechCap = getObjectById(techCapDetails, "id", thisTechCapId);
			
							refreshTRMDetailPopup(thisTechCap);
						});
					
					}
							
					
					//function to refresh the table of supporting Technology Components associated with a given technology capability
					function refreshTRMDetailPopup(theTechCap) {
						var techComps = theTechCap.techComponents;
						var aTechCompDetail, techCompProdIDList, aTechComp, techCapBlobId, techCapStyle, thisTechProdCount;
						var techProdCount = 0;
						var techCompDetailList = {};
						techCompDetailList["techCapProds"] = [];
						
						var techCapBlobId = '#' + theTechCap.id + '_blob';
						var infoButtonId = '#' + theTechCap.id + '_info';
												
						for( var i = 0; i &lt; techComps.length; i++ ) {
							aTechComp = techComps[i];	
							thisTechProdCount = aTechComp.techProdCount;						
							
							aTechCompDetail = {};
							aTechCompDetail["link"] = aTechComp.link;
							aTechCompDetail["description"] = aTechComp.description;
							if(aTechComp.docLink != null) {
								aTechCompDetail["docLink"] = aTechComp.docLink;
							}
							aTechCompDetail["count"] = thisTechProdCount;
							techProdCount = techProdCount + thisTechProdCount;
							techCompDetailList.techCapProds.push(aTechCompDetail);
						}
						
						var techCapBlob = $(techCapBlobId);
						var techCapInfo = $(infoButtonId);
						techCapBlob.removeClass();
						//techCapInfo.removeClass();
						
						if((techCompDetailList.techCapProds.length > 0) &amp;&amp; (techProdCount > 0)) {
							//set the background colour of the technology capability based on the selected overlay
							var techCapStyle;
							var techOverlay = $('input:radio[name=techOverlay]:checked').val();
							if(techOverlay =='duplication') {
								//show duplication overlay
								var techProdDuplicationScore = techProdCount / techCompDetailList.techCapProds.length;
								techCapStyle = getDuplicationStyle(techProdDuplicationScore, 'techRefModel-blob');
							} else {
								//show no overlay
								techCapStyle = 'techRefModel-blob bg-darkblue-80';
							}
							
							techCapBlob.addClass(techCapStyle);
							//techCapInfo.attr("class", "refModel-blob-info");														
						}
						else {
							techCapBlob.addClass("techRefModel-blob bg-lightgrey");
							//techCapInfo.attr("class", "refModel-blob-info hiddenDiv");
						}
						var detailTableBodyId = '#' + theTechCap.id + '_techprod_rows';
						$(detailTableBodyId).html(techDetailTemplate(techCompDetailList));
					
					}
					
					//function to refresh the Tech Domain model overlay
					function refreshTechDomainOverlay() {
						var techOverlay = $('input:radio[name=techOverlay]:checked').val();
						//console.log('Current Tech Domain overlay: ' + techOverlay);
						if(techOverlay =='duplication') {
							//show duplication overlay
							$('.tech-comp').each(function() {
								let thisTechCompId = $(this).attr('eas-id');
								let thisTechComp = getObjectById(techComponents.techComponents, "id", thisTechCompId);
								
								let techCompStyle = getDuplicationStyle(thisTechComp.techProdCount, 'tech-comp techRefModel-blob');								
								$(this).attr("class", techCompStyle);
							});
							
							
							$('.techCapBadge').each(function() {
								let thisTechCapId = $(this).attr('eas-id');
								let thisTechCap = getObjectById(techCapDetails, "id", thisTechCapId);
								
								let techProdDuplicationScore = 0;
								let techCompCount = thisTechCap.techComponentIds.length;
								if((techCompCount > 0) &amp;&amp; (thisTechCap.techProdCount > 0)) {
									techProdDuplicationScore = thisTechCap.techProdCount / techCompCount;
								}
								
								let techCapStyle = getDuplicationStyle(techProdDuplicationScore, 'techCapBadge keySampleWide right-5');
								console.log('Setting badge style: ' + techCapStyle);
								$(this).attr("class", techCapStyle);
							});
							
						} else {
							//show no overlay
							$('.tech-comp').each(function() {
								thisTechCompId = $(this).attr('eas-id');
								thisTechComp = getObjectById(techComponents.techComponents, "id", thisTechCompId);
								
								let techCompStyle = 'tech-comp techRefModel-blob bg-lightgrey';
								if(thisTechComp.techProdCount > 0) {
									techCompStyle = 'tech-comp techRefModel-blob bg-darkblue-80';
								}
								$(this).attr("class", techCompStyle);
							});
							
							$('.techCapBadge').each(function() {
								let thisTechCapId = $(this).attr('eas-id');
								let thisTechCap = getObjectById(techCapDetails, "id", thisTechCapId);

								let techCapStyle = 'techCapBadge keySampleWide right-5 bg-lightgrey';
								if(thisTechCap.techProdCount > 0) {
									techCapStyle = 'techCapBadge keySampleWide right-5 bg-darkblue-80';
								}
								
								$(this).attr("class", techCapStyle);
							});
						}
					}

					
					var techDomainHeaderTemplate;
										
					//function to draw the full TRM
					function drawTRM() {
					
						$("#techRefModelContainer").html(trmTemplate(trmData)).promise().done(function(){
					        $('.tech-domain-drill').click(function(){
								var techDomainId = $(this).attr('eas-id');
								
								var selectedTechDomain = techDomains.techDomains.find(function(aTD) {return aTD.id === techDomainId});
								if(selectedTechDomain != null) {
									currentMode = techDomainMode;
									currentTechDomain = selectedTechDomain;
									$( "#techRefModelPanel" ).addClass("hidden-ref-model")
										.on('transitionend', function(){
											//update the title header
											let techDomainHeaderContent = techDomainHeaderTemplate(currentTechDomain);
											$('#ref-model-head-title').html(techDomainHeaderContent);
											//$('#ref-model-head-title').html(currentTechDomain.link + '<i class="tech-domain-up fa fa-arrow-circle-up left-5"/>');
											//draw the drill down view
											drawTechDomainModel();
										  	$('#techRefModelPanel').removeClass('hidden-ref-model');
										});						
								}
								
							});
							$('.matchHeight2').matchHeight();
				 			$('.matchHeightTRM').matchHeight();
				 			
				 			//Update the TRM Model overlays
							refreshTechCapabilityOverlay();
							enableInfoPopups();
					    });		
					}
					
					
					//function to draw the Technology Domain drill down view
					function drawTechDomainModel() {
						if(currentTechDomain != null) {
							setTechDomainProducts(currentTechDomain);
							$("#techRefModelContainer").html(techDomainTemplate(currentTechDomain)).promise().done(function(){
						        $('.tech-domain-up').click(function(){
									//currentTechDomain = null;
									currentMode = trmMode;
									$( "#techRefModelPanel" ).addClass("hidden-ref-model")
										.on('transitionend', function(){
											//update the title header
										  	$('#ref-model-head-title').html('Reference Model');
										  	$('#techRefModelPanel').removeClass('hidden-ref-model');
										  	drawTRM();
										});						
								});
								
								$('.matchHeight2').matchHeight();
				 				$('.matchHeightTRM').matchHeight();
								//Update the Tech Domain Model overlays
								refreshTechDomainOverlay();
								enableInfoPopups();
						    });	
						}
					}
		
					//function to draw the relevant dashboard components based on the currently selected Data Objects
					function drawDashboard() {
						updateOverlayLegend();
						if(currentMode == trmMode) {
							drawTRM();
						} else {
							drawTechDomainModel();
						}				
					}
					
					
					//function to enable the info ppups
					function enableInfoPopups() {
						$('.fa-info-circle').click(function() {
							$('[role="tooltip"]').remove();
							return false;
						});
						$('.fa-info-circle').popover({
							container: 'body',
							html: true,
							trigger: 'click',
							content: function(){
								return $(this).next().html();
							}
						});
					}
					
					var trmDataAPIPath = '<xsl:value-of select="$trmReportAPIPath"/>';
					
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
					
					
					$(document).ready(function(){	
						promise_loadViewerAPIData(trmDataAPIPath)
						.then(function(response) {
						
							techDomains.techDomains = response.techDomains;
							techCapDetails = response.techCapDetails;
							techComponents.techComponents = response.techComponents;
			
							//Initialise the data
							initTechDomains();
							initTechCapabilities();
							initTRMData();						
							
							<!-- SET UP THE REF MODEL LEGENDS -->
							var legendFragment = $("#rag-overlay-legend-template").html();
							var legendTemplate = Handlebars.compile(legendFragment);
							ragOverlayLegend = legendTemplate();
							
							let techDomainHeaderFragment = $("#tech-domain-header-template").html();
							techDomainHeaderTemplate = Handlebars.compile(techDomainHeaderFragment);
							
							legendFragment = $("#no-overlay-legend-template").html();
							legendTemplate = Handlebars.compile(legendFragment);
							var legendLabels = {};
							legendLabels["inScope"] = 'Products in Use';
							noOverlayTRMLegend = legendTemplate(legendLabels);	
							
							<!-- SET UP THE TRM MODEL -->
							//initialise the TRM model
							var trmFragment   = $("#trm-template").html();
							trmTemplate = Handlebars.compile(trmFragment);					
				 			
				 			var techDetailFragment = $("#trm-techcap-popup-template").html();
							techDetailTemplate = Handlebars.compile(techDetailFragment);
							
							var techDomainFragment = $("#tech-domain-template").html();
							techDomainTemplate = Handlebars.compile(techDomainFragment);
							
							drawDashboard();
						});
					});
								  	
				</script>
				<style>
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
						
					}
					
					.popover{
						max-width: 800px;
					}
					
					.tech-domain-drill,.tech-domain-up {
					    <!--font-size:0.95em;-->
					    position: relative;
					}
					
					.tech-domain-drill{
						opacity: 0.35;
					
					}
					.tech-domain-up {
						<!--opacity: 0.75;-->
					}
					
					.tech-domain-drill:hover {
						cursor: pointer;
					}
					
					.tech-domain-up:hover {
						cursor: pointer;
					}
					
					.hidden-ref-model {
					    opacity: 0;
					    transform: scale(0.98);
					    transform-origin: center center;
					}
					
					#techRefModelPanel {
					    transition: all 100ms ease-in;
					}
					
					.prod-count {
						position: absolute;
						bottom: 2px;
						left: 2px;
						<!--border: 1px solid #aaa;-->
						border-radius: 10px;
						color: #333;	
						background-color: #fff;
						font-size: 8px;
						padding: 0 3px;
					}
					
					.fa-info-circle:hover {
						cursor: pointer;
					}

				</style>
				
				<xsl:call-template name="refModelStyles"/>
				
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
									<span class="text-darkgrey">Technology Reference Model</span>
								</h1>
							</div>
						</div>
						<xsl:call-template name="techSection"/>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
						
						
						
					});
				</script>
				
				<script id="tech-domain-header-template" type="text/x-handlebars-template">
					{{{link}}}<i class="tech-domain-up fa fa-arrow-circle-up left-5"/>
					<i class="left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
					<div class="hiddenDiv">
						<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
						<h4>{{name}}</h4>
						<p>{{description}}</p>
						{{#if docLink}}
							<a target="_blank">
								<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
								<img alt="{{docLink.type}}" width="32px">
									<xsl:attribute name="src" select="$confluenceLogoPath"/>
								</img>
								<span class="left-5">{{docLink.type}}</span>
							</a>
						{{/if}}
					</div>
				</script>
				
				<script id="tech-domain-template" type="text/x-handlebars-template">
					<div class="col-xs-12">						
							<div class="row">			
								{{#childTechCaps}}
									<div class="col-xs-12 bottom-15">
										<div class="refModel-l0-outer" style="">
											<div class="refModel-l0-title large strong">
												<div class="techCapBadge keySampleWide right-5"><xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute></div>{{{link}}}
												<i class="left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
												<div class="hiddenDiv">
													<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<h4>{{name}}</h4>
													<p>{{description}}</p>
													{{#if docLink}}
														<a target="_blank">
															<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
															<img alt="{{docLink.type}}" width="24px">
																<xsl:attribute name="src" select="$confluenceLogoPath"/>
															</img>
															<span class="left-5">{{docLink.type}}</span>
														</a>
													{{/if}}
												</div>
											</div>
											<div class="row">
												<div class="col-md-12">
													{{#techComponents}}
														<div class="tech-comp techRefModel-blob">
															<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
															{{#if techProdCount}}
																<div class="prod-count">{{techProdCount}}</div>
															{{/if}}
															<div class="refModel-blob-title">
																{{{link}}}
															</div>
															<div class="refModel-blob-info">
																<i class="fa fa-info-circle text-white" data-original-title="" title=""></i>
																<div class="hiddenDiv" id="xyz789">
																	<h4>{{name}}</h4>
																	<p>{{description}}</p>
																	{{#if docLink}}
																		<a target="_blank">
																			<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
																			<img alt="{{docLink.type}}" width="24px">
																				<xsl:attribute name="src" select="$confluenceLogoPath"/>
																			</img>
																			<span class="left-5">{{docLink.type}}</span>
																		</a>
																	{{/if}}
																</div>
															</div>
														</div>
													{{/techComponents}}
												</div>
											</div>								
										</div>
									</div>
								{{/childTechCaps}}
							</div>
					</div>
				</script>
			</body>
		</html>
	</xsl:template>



	<xsl:template name="techSection">
		<!--Top-->
		<script id="trm-template" type="text/x-handlebars-template">
			<div class="col-xs-12">
				{{#each top}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down textColourBlue"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<i class="tech-domain-info left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<div class="hiddenDiv">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
										<h4>{{name}}</h4>
										<p>{{description}}</p>
										{{#if docLink}}
											<a target="_blank" class="bottom-10">
												<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
												<img alt="{{docLink.type}}" width="32px">
													<xsl:attribute name="src" select="$confluenceLogoPath"/>
												</img>
												<span class="left-5">{{docLink.type}}</span>
											</a>
										{{/if}}
									</div>
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<h4>{{name}}</h4>
													<p>{{description}}</p>
													{{#if docLink}}
														<a target="_blank" class="bottom-10">
															<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
															<img alt="{{docLink.type}}" width="24px">
																<xsl:attribute name="src" select="$confluenceLogoPath"/>
															</img>
															<span class="left-5">{{docLink.type}}</span>
														</a>
													{{/if}}
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Component')"/></th>																
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
																<th class="cellWidth-140">&#160;</th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>					
											</div>
										</div>
									</div>								
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--Ends-->
			<!--Left-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each left}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down textColourBlue"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<i class="tech-domain-info left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<div class="hiddenDiv">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
										<h4>{{name}}</h4>
										<p>{{description}}</p>
										{{#if docLink}}
											<a target="_blank">
												<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
												<img alt="{{docLink.type}}" width="32px">
													<xsl:attribute name="src" select="$confluenceLogoPath"/>
												</img>
												<span class="left-5">{{docLink.type}}</span>
											</a>
										{{/if}}
									</div>
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<h4>{{name}}</h4>
													<p>{{description}}</p>
													{{#if docLink}}
														<a target="_blank" class="bottom-10">
															<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
															<img alt="{{docLink.type}}" width="24px">
																<xsl:attribute name="src" select="$confluenceLogoPath"/>
															</img>
															<span class="left-5">{{docLink.type}}</span>
														</a>
													{{/if}}
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Component')"/></th>																
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
																<th class="cellWidth-140">&#160;</th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>											
											</div>
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Center-->
			<div class="col-xs-4 col-md-6 col-lg-8 matchHeightTRM">
				{{#each middle}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down textColourBlue"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<i class="tech-domain-info left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<div class="hiddenDiv">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
										<h4>{{name}}</h4>
										<p>{{description}}</p>
										{{#if docLink}}
											<a target="_blank">
												<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
												<img alt="{{docLink.type}}" width="32px">
													<xsl:attribute name="src" select="$confluenceLogoPath"/>
												</img>
												<span class="left-5">{{docLink.type}}</span>
											</a>
										{{/if}}
									</div>
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<h4>{{name}}</h4>
													<p>{{description}}</p>
													{{#if docLink}}
														<a target="_blank" class="bottom-10">
															<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
															<img alt="{{docLink.type}}" width="24px">
																<xsl:attribute name="src" select="$confluenceLogoPath"/>
															</img>
															<span class="left-5">{{docLink.type}}</span>
														</a>
													{{/if}}
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Component')"/></th>																
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
																<th class="cellWidth-140">&#160;</th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>											
											</div>
										</div>
									</div>
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
							{{#unless @last}}
								<div class="clearfix bottom-10"/>
							{{/unless}}
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Right-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each right}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down textColourBlue"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<i class="tech-domain-info left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<div class="hiddenDiv">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
										<h4>{{name}}</h4>
										<p>{{description}}</p>
										{{#if docLink}}
											<a target="_blank">
												<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
												<img alt="{{docLink.type}}" width="32px">
													<xsl:attribute name="src" select="$confluenceLogoPath"/>
												</img>
												<span class="left-5">{{docLink.type}}</span>
											</a>
										{{/if}}
									</div>
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<h4>{{name}}</h4>
													<p>{{description}}</p>
													{{#if docLink}}
														<a target="_blank" class="bottom-10">
															<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
															<img alt="{{docLink.type}}" width="24px">
																<xsl:attribute name="src" select="$confluenceLogoPath"/>
															</img>
															<span class="left-5">{{docLink.type}}</span>
														</a>
													{{/if}}
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Component')"/></th>																
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
																<th class="cellWidth-140">&#160;</th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>											
											</div>
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Bottom-->
			<div class="col-xs-12">
				<div class="clearfix bottom-10"/>
				{{#each bottom}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down textColourBlue"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<i class="tech-domain-info left-5 fa fa-info-circle"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									<div class="hiddenDiv">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
										<p>{{description}}</p>
										{{#if docLink}}
											<a target="_blank">
												<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
												<img alt="{{docLink.type}}" width="32px">
													<xsl:attribute name="src" select="$confluenceLogoPath"/>
												</img>
												<span class="left-5">{{docLink.type}}</span>
											</a>
										{{/if}}
									</div>
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<p>{{description}}</p>
													{{#if docLink}}
														<a target="_blank" class="bottom-10">
															<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
															<img alt="{{docLink.type}}" width="24px">
																<xsl:attribute name="src" select="$confluenceLogoPath"/>
															</img>
															<span class="left-5">{{docLink.type}}</span>
														</a>
													{{/if}}
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Component')"/></th>																
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
																<th class="cellWidth-140">&#160;</th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>
												
											</div>
										</div>
									</div>							
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--Ends-->
		</script>
		
		<!-- Handlebars template for the contents of the popup table for a technology capability -->
		<script id="trm-techcap-popup-template" type="text/x-handlebars-template">
			{{#techCapProds}}			
				<tr>
					<td>{{{link}}}</td>
					<td class="alignCentre">{{count}}</td>
					<td>
						{{#if docLink}}
							<a target="_blank">
								<xsl:attribute name="href">{{{docLink.url}}}</xsl:attribute>
								<img alt="{{docLink.type}}" width="16px">
									<xsl:attribute name="src" select="$confluenceLogoPath"/>
								</img>
								<span class="left-5">{{docLink.type}}</span>
							</a>
						{{/if}}
					</td>
				</tr>
			{{/techCapProds}}
		</script>
		
		<script>
			$(document).ready(function() {
			 	$('.matchHeight1').matchHeight();
			});
		</script>
		
		<div class="col-xs-12">
			<div id="techRefModelPanel" class="dashboardPanel bg-offwhite">
				<h2 id="ref-model-head-title" class="text-secondary">Reference Model</h2>
				<div class="row">
					<!-- REFERTENCE MODEL LEGEND SECTION -->
					<div class="col-xs-6 bottom-15" id="trmLegend">
						<div class="keyTitle">Legend:</div>
						<div class="keySampleWide bg-purple-100"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-purple-60"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide bg-purple-20"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide bg-lightgrey"/>
						<div class="keyLabel">No Products in Use</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayNone" value="none" checked="checked" onchange="setOverlay()"/>Footprint</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayDup" value="duplication" onchange="setOverlay()"/>Product Count</label>
						</div>
					</div>
					<!-- REFERENCE MODEL CONTAINER -->
					<div class="simple-scroller" id="techRefModelContainer">
						<div class="alignCentre xlarge">
							<span><xsl:value-of select="eas:i18n('Loading Technology Reference Model')"/>...</span><i class="fa fa-spinner fa-pulse fa-fw"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	
	
	<xsl:template name="summaryRefModelLegendInclude">
		<script id="rag-overlay-legend-template" type="text/x-handlebars-template">
			<div class="keyTitle">Legend:</div>
			<div class="keySampleWide bg-purple-100"/>
			<div class="keyLabel">High</div>
			<div class="keySampleWide bg-purple-60"/>
			<div class="keyLabel">Medium</div>
			<div class="keySampleWide bg-purple-20"/>
			<div class="keyLabel">Low</div>
			<div class="keySampleWide bg-lightgrey"/>
			<div class="keyLabel">No Products In Use</div>
		</script>
		
		<script id="no-overlay-legend-template" type="text/x-handlebars-template">
			<div class="keyTitle">Legend:</div>
			<div class="keySampleWide bg-darkblue-80"/>
			<div class="keyLabel">{{inScope}}</div>
			<div class="keySampleWide bg-lightgrey"/>
			<div class="keyLabel">No Products In Use</div>
		</script>
		
	</xsl:template>
	
	
	<xsl:template name="GetViewerAPIPath">
		<xsl:param name="apiReport"/>
		
		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderAPILinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>		
		<xsl:value-of select="$dataSetPath"/>
	</xsl:template>

</xsl:stylesheet>
