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


	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>

	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>

	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[type='Technology_Delivery_Model']"/>
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	
	<xsl:variable name="anAPIReportGetBusinessUnits" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get Technology Business Units']"/>
	<xsl:variable name="anAPIReportGetAllTechProds" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get All Tech Product Details']"/>
	<xsl:variable name="anAPIReportGetAllTechProdRoles" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get All Tech Product Roles']"/>
	 
	
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
 <xsl:variable name="apiPathGetBusinessUnits">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetBusinessUnits"/>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="apiPathGetAllTechProds">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetAllTechProds"/>
	</xsl:call-template>
</xsl:variable>	
<xsl:variable name="apiPathGetAllTechProdRoles">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetAllTechProdRoles"/>
	</xsl:call-template>
</xsl:variable>		
	
	

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
					</xsl:call-template>
				</xsl:for-each>
				<title>Technology Reference Model</title>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				

				<xsl:call-template name="refModelLegendInclude"/>
				
				<script type="text/javascript">
					
					var trmTemplate, techDetailTemplate, techDomainTemplate, ragOverlayLegend, noOverlayTRMLegend;
					var currentTechDomain;
					
					const trmMode = 'TRM';
					const techDomainMode = 'TECH_DOMAIN';
					
					var currentMode = trmMode;
					
					var scaleOptions = {};
					
					// the list of JSON objects representing the delivery models for technology products
				  	var techDeliveryModels = [<xsl:apply-templates select="$allTechProdDeliveryTypes" mode="RenderEnumerationJSONList"/>];
					
					// the list of JSON objects representing the environments
				  	var lifecycleStatii = [
						<xsl:apply-templates select="$allLifecycleStatii" mode="getSimpleJSONList"/>					
					];
					
					// the list of JSON objects representing the business units pf the enterprise
	<!--			  	var businessUnits = {
							businessUnits: [<xsl:apply-templates select="$allBusinessUnits" mode="getBusinessUnits"/>
				    	]
				  	};
	-->			  	
				  	// the list of JSON objects representing the technology domains in use across the enterprise
				  	var techDomains = {
						techDomains: [     <xsl:apply-templates select="$allTechDomains" mode="RenderTechDomains"/>
				    	]
				  	};
				  	
				  	// the JSON objects for the Technology Components and Products that implement Technology Capabilities
				  	var techCapDetails = [
				  		<xsl:apply-templates select="$allTechCaps" mode="TechCapDetails"/>
				  	];
				  	
				  	
				  	// the list of JSON objects representing the technology components in use across the enterprise
				  	var techComponents = {
						techComponents: [<xsl:apply-templates select="$allTechComps" mode="RenderTechCompDetails"/>
				    	]
				  	};
				  	
          
					// the JSON objects for the Technology Reference Model (TRM)
				  	var trmData = {
				  		top: [
				  			<!--<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $topRefLayer/name]" mode="RenderTechDomains"/>-->
				  		],
				  		left: [
				  			<!--<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $leftRefLayer/name]" mode="RenderTechDomains"/>-->
				  		],
				  		middle: [
				  			<!--<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $middleRefLayer/name]" mode="RenderTechDomains"/>-->
				  		],
				  		right: [
				  			<!--<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $rightRefLayer/name]" mode="RenderTechDomains"/>-->
				  		],
				  		bottom: [
				  			<!--<xsl:apply-templates select="$allTechDomains[own_slot_value[slot_reference = 'element_classified_by']/value = $bottomRefLayer/name]" mode="RenderTechDomains"/>-->
				  		]
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
						if(count &lt; 2) {
							return rootClass + ' bg-brightgreen-120';
						} else if((count >= 2) &amp;&amp; (count &lt;= 3)) {
							return rootClass + ' bg-orange-120';
						} else {
							return rootClass + ' bg-brightred-120';
						}
					}
					
					//funtion to get the score for a given set of tech prods
					function getTechProdStatusScore(techProds) {
						var techProdCount = 0;
						var statusScore = 0;
						var statusScoreTotal = 0;
						var aTechProd;
						
						for( var i = 0; i &lt; techProds.length; i++ ){
							aTechProd = techProds[i];
							statusScore = aTechProd.statusScore;
							
							if(statusScore > 0) {
								statusScoreTotal = statusScoreTotal + statusScore;
								techProdCount++;
							}
						}
						
						if((techProdCount > 0) &amp;&amp; (statusScoreTotal > 0)) {
							return Math.round(statusScoreTotal / techProdCount);
						} else {
							return 0;
						}
						
					}
					
					//function that returns the style class for a reference model element based on its lifecycle status
					function getStatusStyle(score, rootClass) {
						if(score == 0) {
							return rootClass + ' bg-darkgrey';
						} else if(score > 8) {
							return rootClass + ' bg-brightgreen-120';
						} else if((score > 4) &amp;&amp; (score &lt;= 7)) {
							return rootClass + ' bg-orange-120';
						} else {
							return rootClass + ' bg-brightred-120';
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
					
					
	
					
					<!--<xsl:call-template name="RenderJavascriptScopingFunctions"/>-->
	
					<!-- START PAGE DRAWING FUNCTIONS -->
					
					//function to set the current list of Technology Products for the TRM view
					function setTRMCurrentTechProds() {
						if(selectedBusUnitIDs.length > 0) {
							var techProdArrays = [];
							var currentBU;
							for (i = 0; selectedBusUnits.length > i; i += 1) {
								currentBU = selectedBusUnits[i];
								techProdArrays.push(currentBU.techProds);
							}
							
							selectedTechProdIDs = getUniqueArrayVals(techProdArrays);
							selectedTechProds = getObjectsByIds(techProducts.techProducts, "id", selectedTechProdIDs);
							// console.log("Selected Tech Prod Count: " + selectedTechProds.length);
						} else {
							selectedTechProdIDs = getObjectIds(techProducts.techProducts, "id");
							selectedTechProds = techProducts.techProducts;
						}
					}
					
					//funtion to set the Technology Domain model products in scope
					function setTechDomainProducts(aTechDomain) {
						var techDomainProdCount, techCapProdCount, techCompProdCount;
						techDomainProdCount = 0;
						aTechDomain.childTechCaps.forEach( function(aTechCap) {
							 techCapProdCount = 0;
							 aTechCap.techComponents.forEach( function(aTechComp) {
								techCompProdIDList = aTechComp.techProds;										
								var relevantTechProdIds = getArrayIntersect([techCompProdIDList, selectedTechProdIDs]);
								var relevantTechProds = getObjectsByIds(selectedTechProds, "id", relevantTechProdIds);
								thisTechProdCount = relevantTechProds.length;
								aTechComp['inScopeTechProds'] = relevantTechProds;							
								aTechComp['techProdCount'] = thisTechProdCount;
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
						var techProdList = []
						var techCompDetailList = {};
						techCompDetailList["techCapProds"] = [];
						
						var techCapBlobId = '#' + theTechCap.id + '_blob';
						var infoButtonId = '#' + theTechCap.id + '_info';
						
						
						for( var i = 0; i &lt; techComps.length; i++ ){
							aTechComp = techComps[i];
							techCompProdIDList = aTechComp.techProds;		
							
							var relevantTechProdIds = getArrayIntersect([techCompProdIDList, selectedTechProdIDs]);
							var relevantTechProds = getObjectsByIds(selectedTechProds, "id", relevantTechProdIds);
							thisTechProdCount = relevantTechProds.length;
							
							
							if(thisTechProdCount > 0) {
								aTechCompDetail = {};
								aTechCompDetail["link"] = aTechComp.link;
								aTechCompDetail["description"] = aTechComp.description;
								aTechCompDetail["count"] = thisTechProdCount;
								techProdCount = techProdCount + thisTechProdCount;
								techProdList = techProdList.concat(relevantTechProds);
								
								techCompDetailList.techCapProds.push(aTechCompDetail);
							} 
						}
						
						var techCapBlob = $(techCapBlobId);
						var techCapInfo = $(infoButtonId);
						techCapBlob.removeClass();
						techCapInfo.removeClass();
						
						if((techCompDetailList.techCapProds.length > 0) &amp;&amp; (techProdCount > 0)) {
							//console.log('Setting blob overlay: ' + techCapInfo.attr("id"));
						
							//set the background colour of the technology capability based on the selected overlay
							var techCapStyle;
							var techOverlay = $('input:radio[name=techOverlay]:checked').val();
							if(techOverlay =='duplication') {
								//show duplication overlay
								var techProdDuplicationScore = techProdCount / techCompDetailList.techCapProds.length;
								techCapStyle = getDuplicationStyle(techProdDuplicationScore, 'techRefModel-blob');
							} else if (techOverlay =='status') {
								//show lifecycle status overlay
								var techStatusScore = getTechProdStatusScore(techProdList);
								techCapStyle = getStatusStyle(techStatusScore, 'techRefModel-blob');
							} else {
								//show no overlay
								techCapStyle = 'techRefModel-blob bg-darkblue-80';
							}
							
							techCapBlob.addClass(techCapStyle);
							techCapInfo.attr("class", "refModel-blob-info");
							
							var detailTableBodyId = '#' + theTechCap.id + '_techprod_rows';
							$(detailTableBodyId).html(techDetailTemplate(techCompDetailList));
						}
						else {
							techCapBlob.addClass("techRefModel-blob bg-lightgrey");
							techCapInfo.attr("class", "refModel-blob-info hiddenDiv");
						}
					
					}
					
					//function to refresh the Tech Domain model overlay
					function refreshTechDomainOverlay() {
						var techOverlay = $('input:radio[name=techOverlay]:checked').val();
						console.log('Current Tech Domain overlay: ' + techOverlay);
						if(techOverlay =='duplication') {
							//show duplication overlay
							$('.tech-comp').each(function() {
								thisTechCompId = $(this).attr('eas-id');
								thisTechComp = getObjectById(techComponents.techComponents, "id", thisTechCompId);
								
								techCompStyle = getDuplicationStyle(thisTechComp.techProdCount, 'tech-comp refModel-l1-title');
								$(this).attr("class", techCompStyle);
								$('.tech-prod').each(function() {
									$(this).attr("class", 'tech-prod techRefModel-blob bg-lightblue-80');
								});
							});
							
						} else if (techOverlay =='status') {
							//show lifecycle status overlay
							
						} else {
							//show no overlay
							$('.tech-comp').each(function() {
								$(this).attr("class", 'tech-comp refModel-l1-title bg-darkblue-80');
							});
							$('.tech-prod').each(function() {
								$(this).attr("class", 'tech-prod techRefModel-blob bg-lightblue-80');
							});
						}
					}
					
					<!--//function to scope the relevant elements in acordance with the current roadmap period
					function scopeRoadmapElements() {
						//rmSetElementListRoadmapStatus([applications.applications, techProducts.techProducts]);
					
						setCurrentTechProds();
						
						var techProdsForRM = rmGetVisibleElements(selectedTechProds);
						selectedTechProds = techProdsForRM;
						selectedTechProdIDs = getObjectListPropertyVals(selectedTechProds, "id");
					}-->
					
					
					
					//function to draw the full TRM
					function drawTRM() {
					
						$("#techRefModelContainer").html(trmTemplate(trmData)).promise().done(function(){
					        $('.tech-domain-drill').click(function(){
								var techDomainId = $(this).attr('eas-id');
								
								var selectedTechDomain = techDomains.techDomains.find(function(aTD) {return aTD.id === techDomainId});
								if(selectedTechDomain != null) {
									currentMode = techDomainMode;
									currentTechDomain = selectedTechDomain;
									//console.log('Clicked on ' + selectedTechDomain.name);
									$( "#techRefModelPanel" ).addClass("hidden-ref-model")
										.on('transitionend', function(){
											//update the title header
											$('#ref-model-head-title').html(currentTechDomain.link + '<i class="tech-domain-up fa fa-arrow-circle-up left-5"/>');
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
					
					$(document).ready(function(){	
				
			    Promise.all([
                promise_loadViewerAPIData(viewAPIDataGetBusinessUnits),
                promise_loadViewerAPIData(viewAPIDataGetAllTechProds),
				promise_loadViewerAPIData(viewAPIDataGetAllTechProdRoles)	
					
            	]).then(function(responses) {
			            businessUnits = responses[0];                  
						console.log('businessUnits');		 
						console.log(businessUnits)  ;
					techProducts = responses[1];  
			            console.log('techProds');		 
					 
						console.log(techProducts)
					techProdRoles = responses[2];  
			            console.log('tpr');	
			 
					console.log(techProdRoles)
					
					var tpr = techProdRoles.techProdRoles; 
                    for(var i=0; i &lt; techComponents.techComponents.length;i++) {
                    var techprodslist=[];
                       for(var j=0; j &lt;techComponents.techComponents[i].techProdRoles.length;j++) {
                         
                            var thistpr = tpr.filter(function(d){
                            if(techComponents.techComponents[i].techProdRoles[j] === d.id){  techprodslist.push(d.techProdid);}
                
                        })
                    }
                    let unique = [...new Set(techprodslist)];      
                    techComponents.techComponents[i]['techProds']=unique;
                    
                     <!--   d.techProdRoles.forEach(function(e){
                            var thisTP = techProdRoles.filter(function(f){
                              if(e === f.id){return f.techProdid;}
                            })
                    console.log('thisTP'); console.log(thisTP);
                        })
                    -->
                    };
					
						<!--$('h2').click(function(){
							$(this).next().slideToggle();
						});-->
											
						
						//INITIALISE THE SCOPING DROP DOWN LIST
						$('#busUnitList').select2({
							placeholder: "All",
							allowClear: true,
							theme: "bootstrap"
						});
						
						//Initialise the data
						initTechDomains();
						initTechCapabilities();
						initTRMData();
						
						//INITIALISE THE PAGE WIDE SCOPING VARIABLES					
						allBusUnitIDs = getObjectIds(businessUnits.businessUnits, 'id');
				 
						selectedBusUnitIDs = [];
						selectedBusUnits = [];
						setTRMCurrentTechProds();
									
						$('#busUnitList').on('change', function (evt) {
						  var thisBusUnitIDs = $(this).select2("val");
						  if(thisBusUnitIDs != null) {
						  	selectedBusUnitIDs = thisBusUnitIDs;
							selectedBusUnits = getObjectsByIds(businessUnits.businessUnits, "id", selectedBusUnitIDs);
						  } else {
						  	selectedBusUnitIDs = [];
						  	selectedBusUnits = [];		  	
						  }
						  setTRMCurrentTechProds();
						  <!--if(currentMode == trmMode) {
					  		setTRMCurrentTechProds();
					  	  } else {
					  		setTechDomainProducts(currentTechDomain);
					  	  }-->
						  drawDashboard();
						  //console.log("Select BUs: " + selectedBusUnitIDs);					
						});
						
						
						
						var busUnitSelectFragment   = $("#bus-unit-select-template").html();
						var busUnitSelectTemplate = Handlebars.compile(busUnitSelectFragment);
						$("#busUnitList").html(busUnitSelectTemplate(businessUnits));
						
						
						<!-- SET UP THE REF MODEL LEGENDS -->
						var legendFragment = $("#rag-overlay-legend-template").html();
						var legendTemplate = Handlebars.compile(legendFragment);
						ragOverlayLegend = legendTemplate();
						
						legendFragment = $("#no-overlay-legend-template").html();
						legendTemplate = Handlebars.compile(legendFragment);
						var legendLabels = {};
						legendLabels["inScope"] = 'Technology Products in Use';
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
					    font-size:0.95em;
					    position: relative;
					    top: 1px;
					    
					}
					
					.tech-domain-drill{
						opacity: 0.35;
					
					}
					.tech-domain-up {
						opacity: 0.75;
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
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<xsl:call-template name="RenderDashboardBusUnitFilter"/>
						<xsl:call-template name="techSection"/>
						
						<!--<xsl:call-template name="mockup"/>-->
						
						<!--Setup Closing Tags-->
					</div>
				</div>
<script type="text/javascript">
<xsl:call-template name="RenderViewerAPIJSFunction">
<xsl:with-param name="viewerAPIPathGetBusinessUnits" select="$apiPathGetBusinessUnits"/>
<xsl:with-param name="viewerAPIPathGetAllTechProds" select="$apiPathGetAllTechProds"/>
<xsl:with-param name="viewerAPIPathGetAllTechProdRoles" select="$apiPathGetAllTechProdRoles"/>	
	
	<!--	
	<xsl:with-param name="viewerAPIPath" select="$apiPath"/>
	<xsl:with-param name="viewerAPIPathAPM" select="$apiPathAPM"/>
	<xsl:with-param name="viewerAPIPathTRM" select="$apiPathTRM"/>
	<xsl:with-param name="viewerAPIPathAppStakeholders" select="$apiPathAppStakeholders"/>
	<xsl:with-param name="viewerAPIPathTechStakeholders" select="$apiPathTechStakeholders"/>
	<xsl:with-param name="viewerAPIPathAllApps" select="$apiPathAllApps"/>
	<xsl:with-param name="viewerAPIPathAllTechProds" select="$apiPathAllTechProds"/>
	<xsl:with-param name="viewerAPIPathAllAppCaps" select="$apiPathAllAppCaps"/>
	<xsl:with-param name="viewerAPIPathAllTechCaps" select="$apiPathAllTechCaps"/>
	<xsl:with-param name="viewerAPIPathAllAppProvider" select="$apiPathAllAppProvider"/>

	<xsl:with-param name="viewerAPIPathGetAllTPRs" select="$apiPathGetAllTPRs"/>
	<xsl:with-param name="viewerAPIPathGetAllBusCapDetail" select="$apiPathGetGetAllBusCapDetail"/>
	-->
</xsl:call-template>
</script>	
                     
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>
					$(document).ready(function(){
						$('.match1').matchHeight();
						
						
						
					});
				</script>
				
				<script id="tech-domain-header-template" type="text/x-handlebars-template">
					{{{link}}}<i class="tech-domain-up fa fa-arrow-circle-up left-5"/>
				</script>
				
				<script id="tech-domain-template" type="text/x-handlebars-template">
					<div class="col-xs-12">						
							<div class="row">			
								{{#childTechCaps}}
									{{#if techProdCount}}
										<div class="col-xs-12 bottom-15">
											<div class="refModel-l0-outer" style="">
												<div class="refModel-l0-title large strong">
													{{{link}}}
												</div>
												<div class="row">
													{{#techComponents}}
														{{#if techProdCount}}
															<div class="col-xs-4">
																<div class="refModel-l1-outer">
																	<div class="tech-comp refModel-l1-title bg-darkblue-80">
																		<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
																		{{{link}}}
																	</div>
																	<div class="refModel-l1-inner">
																		<!--Tech Product-->
																		{{#inScopeTechProds}}
																			<div class="tech-prod techRefModel-blob bg-lightblue-80">
																				<xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
																				<div class="refModel-blob-title">
																					{{{link}}}
																				</div>
																				{{#if description.length}}
																					<div class="refModel-blob-info">
																						<i class="fa fa-info-circle text-white" data-original-title="" title=""></i>
																						<div class="hiddenDiv" id="xyz789">
																							<p>{{description}}</p>
																						</div>
																					</div>
																				{{/if}}
																			</div>
																		{{/inScopeTechProds}}
																		<div class="clearfix"></div>
																	<!--End Tech Product-->
																	</div>
																</div>
															</div>
														{{/if}}
													{{/techComponents}}
												</div>								
											</div>
										</div>
									{{/if}}
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
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
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
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
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
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
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
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
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
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
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
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
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
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
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
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
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
									{{{link}}}<i class="tech-domain-drill left-5 fa fa-arrow-circle-down"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
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
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
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
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel">High</div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel">Medium</div>
						<div class="keySampleWide bg-brightgreen-120"/>
						<div class="keyLabel">Low</div>
						<div class="keySampleWide bg-darkgrey"/>
						<div class="keyLabel">Undefined</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayNone" value="none" checked="checked" onchange="setOverlay()"/>Footprint</label>
							<label class="radio-inline"><input type="radio" name="techOverlay" id="techOverlayDup" value="duplication" onchange="setOverlay()"/>Duplication</label>
						</div>
					</div>
					<!-- REFERENCE MODEL CONTAINER -->
					<div class="simple-scroller" id="techRefModelContainer"/>					
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- TECHNOLOGY REFERENCE MODEL DATA TEMPLATES -->
	<xsl:template mode="RenderTechDomains" match="node()">
		<xsl:variable name="techDomainName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techDomainDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techDomainLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childTechCaps" select="current()/own_slot_value[slot_reference = 'contains_technology_capabilities']"/>
		<xsl:variable name="thisRefLayer" select="$refLayers[name = current()/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$techDomainName"/>",
		description: "<xsl:value-of select="eas:renderJSText($techDomainDescription)"/>",
		link: "<xsl:value-of select="$techDomainLink"/>",
		refLayer: "<xsl:value-of select="$thisRefLayer/own_slot_value[slot_reference = 'name']/value"/>", 
		childTechCapIds: [
		<!--<xsl:apply-templates select="$childTechCaps" mode="RenderChildTechCaps"/>-->
			<xsl:for-each select="$childTechCaps/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>		
		]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderChildTechCaps">
		<xsl:variable name="techCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCapDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
	<!--	<xsl:variable name="techComponents" select="$allTechComps[own_slot_value[slot_reference = 'realisation_of_technology_capability']/value = current()/name]"/>-->
        <xsl:variable name="techComponents" select="own_slot_value[slot_reference = 'realisation_of_technology_capability']"/>

		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$techCapName"/>",
			link: "<xsl:value-of select="$techCapLink"/>",
			description: "<xsl:value-of select="eas:renderJSText($techCapDescription)"/>",
			techComponents: [	
				<!--<xsl:apply-templates select="$techComponents" mode="RenderTechCompDetails"/>-->
				<xsl:for-each select="$techComponents/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>		
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="TechCapDetails">
		<xsl:variable name="techCapName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCapDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCapLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="anchorClass">text-white</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="techComponents" select="current()/own_slot_value[slot_reference = 'realised_by_technology_components']"/>
		{
			id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
			name: "<xsl:value-of select="$techCapName"/>",
			link: "<xsl:value-of select="$techCapLink"/>",
			description: "<xsl:value-of select="eas:renderJSText($techCapDescription)"/>",

        techComponentIds: [	
				<!--<xsl:apply-templates select="$techComponents" mode="RenderTechComponents"/>-->
				<xsl:for-each select="$techComponents/value">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>
			]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="node()" mode="RenderTechCompDetails">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="techCompName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCompDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCompLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
		 
	<!--	<xsl:variable name="thisTechProdRoles" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = current()/name]"/>
				<xsl:variable name="allThisTechProdStandards" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $thisTechProdRoles/name]"/>
        <xsl:variable name="thisTechProds" select="$allTechProds[name = $thisTechProdRoles/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
	-->	 <xsl:variable name="thisTechProdRoles2" select="current()/own_slot_value[slot_reference = 'realised_by_technology_products']"/>
		{debug:"test",
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$techCompName"/>",
		link: "<xsl:value-of select="$techCompLink"/>",
		description: "<xsl:value-of select="eas:renderJSText($techCompDescription)"/>",
	<!--	techProds: [<xsl:for-each select="$thisTechProds">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],-->
	<!--	techProdRoles: [<xsl:for-each select="$thisTechProdRoles">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each>],-->
        techProdRoles:[ <xsl:for-each select="$thisTechProdRoles2/value"> "<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]  
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
		<!--<xsl:apply-templates select="$thisTechProdRoles" mode="RenderTechProdRoleJSON">
				<xsl:with-param name="thisTechComp" select="$this"/>
				<xsl:with-param name="hasStandard" select="count($allThisTechProdStandards) > 0"/>
			</xsl:apply-templates>-->
	</xsl:template>
	
	<xsl:template match="node()" mode="RenderTechComponents">
		<xsl:variable name="techCompName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="techCompDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="techCompLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable>
        <xsl:variable name="thisTechProdRoles2" select="own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		{
		id: "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		name: "<xsl:value-of select="$techCompName"/>",
		link: "<xsl:value-of select="$techCompLink"/>",
		description: "<xsl:value-of select="eas:renderJSText($techCompDescription)"/>",
        techProdRole: [<xsl:for-each select="$thisTechProdRoles2/value"> "<xsl:value-of select="."/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>]
		}<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>
	
	
	<xsl:template name="mockup">
		<!--temp-->
		<div class="clearfix top-30"/>
		<!-- end temp-->
		<div class="col-xs-12">
			<div class="dashboardPanel bg-offwhite">
				<h2 class="text-secondary">Technology Domain</h2>
				<div class="row">
					<div class="col-xs-6 bottom-15" id="trmLegend">
						<div class="keyTitle">Legend:</div><div class="keySampleWide bg-lightblue-80"></div><div class="keyLabel">Technology Products in Use</div>
					</div>
					<div class="col-xs-6">
						<div class="pull-right">
							<div class="keyTitle">Overlay:</div>
							<label class="radio-inline">
								<input type="radio" name="techOverlay" id="techOverlayNone" value="none" checked="" onchange="setOverlay()"/>
								None
							</label>
							<label class="radio-inline">
								<input type="radio" name="techOverlay" id="techOverlayDup" value="duplication" onchange="setOverlay()"/>
								Duplication
							</label>
						</div>
					</div>
					<div class="simple-scroller" id="techRefModelContainer">
						<div class="col-xs-12">
							<div class="row">							
								<div class="col-xs-12">
									<div class="refModel-l0-outer" style="">
										<div class="refModel-l0-title fontBlack large">
											Technology Capability
										</div>
										<div class="row">
											<div class="col-xs-4">
												<div class="refModel-l1-outer bg-darkblue-20">
													<div class="refModel-l1-title fontBlack">
														Technology Component
													</div>
													<!--Tech Product-->
													<div class="techRefModel-blob bg-lightblue-80" id="abc123">
														<div class="refModel-blob-title">
															Technology Product
														</div>
														<div class="refModel-blob-info" id="abc456">
															<i class="fa fa-info-circle text-white" data-original-title="" title=""></i>
															<div class="hiddenDiv" id="xyz789">
																<p>Capability for users to interact with a system</p>
															</div>
														</div>
													</div>
													<div class="clearfix"></div>
													<!--End Tech Product-->
												</div>
											</div>
										</div>
										
									</div>
								</div>
							</div>						
						</div>
						<div class="col-xs-12">
							<div class="clearfix bottom-10"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
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
    <xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPathGetBusinessUnits"/>
		<xsl:param name="viewerAPIPathGetAllTechProds"/>
		<xsl:param name="viewerAPIPathGetAllTechProdRoles"/>
		
		
    <!--    <xsl:param name="viewerAPIPath"/>
        <xsl:param name="viewerAPIPathAPM"/>
        <xsl:param name="viewerAPIPathTRM"/>
        <xsl:param name="viewerAPIPathAppStakeholders"/>
        <xsl:param name="viewerAPIPathTechStakeholders"/>
        <xsl:param name="viewerAPIPathAllApps"/>
        <xsl:param name="viewerAPIPathAllTechProds"/>
        <xsl:param name="viewerAPIPathAllAppCaps"/>
        <xsl:param name="viewerAPIPathAllTechCaps"/>
        <xsl:param name="viewerAPIPathAllAppProvider"/>
	
		<xsl:param name="viewerAPIPathGetAllTPRs"/>
		<xsl:param name="viewerAPIPathGetAllBusCapDetail"/>
		-->
		
		
        //a global variable that holds the data returned by an Viewer API Report
    <!--    var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
        var viewAPIDataAPM = '<xsl:value-of select="$viewerAPIPathAPM"/>';
        var viewAPIDataTRM = '<xsl:value-of select="$viewerAPIPathTRM"/>';
        var viewAPIDataAppStakeholders = '<xsl:value-of select="$viewerAPIPathAppStakeholders"/>';
        var viewAPIDataTechStakeholders = '<xsl:value-of select="$viewerAPIPathTechStakeholders"/>';
        var viewAPIDataAllApps = '<xsl:value-of select="$viewerAPIPathAllApps"/>';
        var viewAPIDataTechProds = '<xsl:value-of select="$viewerAPIPathAllTechProds"/>';
        var viewAPIDataAllAppCaps =  '<xsl:value-of select="$viewerAPIPathAllAppCaps"/>';
        var viewAPIDataAllTechCaps =  '<xsl:value-of select="$viewerAPIPathAllTechCaps"/>';
        var viewAPIDataAllAppProvider =  '<xsl:value-of select="$viewerAPIPathAllAppProvider"/>';
		var viewAPIDataGetAllTPRs =  '<xsl:value-of select="$viewerAPIPathGetAllTPRs"/>';
		var viewAPIDataGGetAllBusCapDetail =  '<xsl:value-of select="$viewerAPIPathGetAllBusCapDetail"/>';-->
		var viewAPIDataGetBusinessUnits =  '<xsl:value-of select="$viewerAPIPathGetBusinessUnits"/>';
		var viewAPIDataGetAllTechProds =  '<xsl:value-of select="$viewerAPIPathGetAllTechProds"/>';
		var viewAPIDataGetAllTechProdRoles =  '<xsl:value-of select="$viewerAPIPathGetAllTechProdRoles"/>';

		
		
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
//console.log(apiDataSetURL);    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
//console.log(this.responseText);  
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
        
        
        
        
        $('document').ready(function () {
        
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
        
           
            
    /*    $('#click').click(function(){
        
        promise_loadViewerAPIData(viewAPIDataDM)
            .then(function(response1) {
                //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
                viewAPIData2 = response1;
                 //DO HTML stuff
              

            })
            .catch (function (error) {
                //display an error somewhere on the page   
            });
        }
       
        ); */
        
        
        });
        
    </xsl:template>
   <xsl:template name="RenderAPILinkTextTestingNoCache">
        <xsl:param name="theXML">reportXML.xml</xsl:param>
        <xsl:param name="theXSL"/>
        <xsl:param name="theInstanceID"/>
        <xsl:param name="theHistoryLabel"/>
        <xsl:param name="theParam2"/>
        <xsl:param name="theParam3"/>
        <xsl:param name="theParam4"/>
        <xsl:param name="theContentType"/>
        <xsl:param name="theFilename"/>
        <xsl:param name="theUserParams"/>
        <xsl:param name="viewScopeTerms" select="()"/>
 
        <xsl:text>report?XML=</xsl:text>
        <xsl:value-of select="$theXML"/>
        <xsl:text>&amp;XSL=</xsl:text>
        <xsl:value-of select="$theXSL"/>
       
        <xsl:if test="string-length($theInstanceID) > 0">
            <xsl:text>&amp;PMA=</xsl:text>
            <xsl:value-of select="$theInstanceID"/>
        </xsl:if>
       
        <xsl:if test="string-length($theHistoryLabel) > 0">
            <xsl:text>&amp;LABEL=</xsl:text>
            <xsl:value-of select="encode-for-uri($theHistoryLabel)"/>
        </xsl:if>
        <xsl:if test="string-length($theParam2) > 0">
            <xsl:text>&amp;PMA2=</xsl:text>
            <xsl:value-of select="$theParam2"/>
        </xsl:if>
        <xsl:if test="string-length($theParam3) > 0">
            <xsl:text>&amp;PMA3=</xsl:text>
            <xsl:value-of select="$theParam3"/>
        </xsl:if>
        <xsl:if test="string-length($theParam4) > 0">
            <xsl:text>&amp;PMA4=</xsl:text>
            <xsl:value-of select="$theParam4"/>
        </xsl:if>
        <xsl:if test="(string-length($theContentType) > 0) and (string-length($theFilename) > 0)">
            <xsl:text>&amp;CT=</xsl:text>
            <xsl:value-of select="$theContentType"/>
            <xsl:text>&amp;FILE=</xsl:text>
            <xsl:value-of select="$theFilename"/>
        </xsl:if>
        <xsl:if test="string-length($theUserParams) > 0">
            <xsl:text>&amp;</xsl:text>
            <xsl:value-of select="$theUserParams"/>
        </xsl:if>
        <xsl:if test="count($viewScopeTerms) > 0">
            <xsl:text>&amp;viewScopeTermIds=</xsl:text>
            <xsl:value-of select="eas:queryStringForInstanceIds($viewScopeTerms, '')"/>
        </xsl:if>
       
        <xsl:value-of select="concat('&amp;cl=', $i18n)"/>
    </xsl:template> 
</xsl:stylesheet>
