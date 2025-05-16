<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/> 
    <xsl:import href="../common/core_utilities.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
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
	<xsl:variable name="linkClasses" select="('Technology_Capability', 'Technology_Component', 'Technology_Product', 'Technology_Domain')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Technology Reference Model']"></xsl:variable>
	
<xsl:variable name="reportConfig" select="$theReport/own_slot_value[slot_reference='report_supporting_config']/value"></xsl:variable>
	
	<xsl:variable name="refLayerTaxonomy" select="/node()/simple_instance[(type = 'Taxonomy') and (own_slot_value[slot_reference = 'name']/value = 'Reference Model Layout')]"/>
	<xsl:variable name="refLayers" select="/node()/simple_instance[own_slot_value[slot_reference = 'term_in_taxonomy']/value = $refLayerTaxonomy/name]"/>
	<xsl:variable name="topRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Top']"/>
	<xsl:variable name="leftRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Left']"/>
	<xsl:variable name="rightRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Right']"/>
	<xsl:variable name="middleRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Middle']"/>
	<xsl:variable name="bottomRefLayer" select="$refLayers[own_slot_value[slot_reference = 'name']/value = 'Bottom']"/>
	<xsl:variable name="stdStrength" select="/node()/simple_instance[type = 'Standard_Strength']"/>
	<xsl:variable name="allTechCaps" select="/node()/simple_instance[type = 'Technology_Capability']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component']"/>
 
	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
	<xsl:variable name="allTechProdDeliveryTypes" select="/node()/simple_instance[type='Technology_Delivery_Model']"/>
	<xsl:variable name="allTechDomains" select="/node()/simple_instance[type = 'Technology_Domain']"/>
	
	<xsl:variable name="anAPIReportGetTechLifecycles" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Lifecycles']"/>
	<xsl:variable name="anAPIReportGetAllTechProds" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get All Tech Product Details']"/>
	<xsl:variable name="anAPIReportGetAllTechProdRoles" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: TRM Get All Tech Product Roles']"/>
	
	<xsl:variable name="anAPIReportGetAllTechProdsImport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Products']"/>
	<xsl:variable name="anAPIReportGetAllTechDomain" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Domains']"/>
	<xsl:variable name="anAPIReportGetAllTechCaps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Capabilities']"/>
	<xsl:variable name="anAPIReportGetAllTechComps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Components']"/>
 
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
 <xsl:variable name="apiPathGetTechLifecycles">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetTechLifecycles"/>
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
<xsl:variable name="apiPathGetAllTechProdImport">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetAllTechProdsImport"/>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="apiPathGetAllTechDomain">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetAllTechDomain"/>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="apiPathGetAllTechCaps">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetAllTechCaps"/>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="apiPathGetAllTechProdComps">
	<xsl:call-template name="GetViewerAPIPath">
		<xsl:with-param name="apiReport" select="$anAPIReportGetAllTechComps"/>
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
				<style>
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 3px;
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
						transition: opacity 0.3s ease-out, transform 0.3s ease-out;
						height: 0px;
						 
					}
					
					#techRefModelPanel {
					    transition: all 100ms ease-out;
					} 

					.blob-standard{
						position:absolute;
						left:4px;
						bottom:0px;

					}

					.stdlabel{
						border-radius:5px;
						border:1pt solid #d3d3d3;
						padding:2px;
						padding-left:4px;
						padding-right:4px

					}
                    .refModel-l0-outer{
						<!--background-color: pink;-->
						border: 1px solid #aaa;
						padding: 10px 10px 0px 10px;
						border-radius: 4px;
						background-color: #eee;
					}
					
					.refModel-l0-title{
						margin-bottom: 5px;
                        padding-right:10px;
						line-height: 1.1em;
					}
					
					.refModel-l1-outer{
						border: 1px solid #aaa;
						border-radius: 4px;
						margin-bottom: 10px;
					}
					
					.refModel-l1-inner{
						background-color: #fff;
						padding: 10px;
					}
					
					.refModel-l1-title{
						line-height: 1.1em;
						padding: 5px 10px;
					}
					
					.refModel-blob, .busRefModel-blob, .appRefModel-blob, .techRefModel-blob {
					 
						justify-content: center;
						width: 100%;
						max-width: 140px; 
						min-height:50px;
						padding: 3px;
						overflow: hidden;
						border: 1px solid #aaa;
                        background-color: #e3e3e3;
						border-radius: 4px;
						float: left;
						margin-right: 4px;
						margin-bottom: 4px;
                        margin-top: 0px;
						text-align: center;
						font-size: 12px;
						position: relative;

					}
					
					.appRefModel-blob a {
						color: white;
					}
					
					.busRefModel-blob a {
						color: white;
					}
					
					.techRefModel-blob a {
						color: white;
					}
					
					.refModel-l1-title a {
						color: white !important;
					}
					
					.bg-lightgrey a {
						color: #333 !important;
					}
					
					.refModel-blob:hover {border: 2px solid #666;}
					
					.refModel-blob-title{
						line-height: 1em;
                        margin-right: 7px;
					
					}
                    .refModel-blob-info {                  
                        position: absolute;
                        top: 2px;
                        right: 2px;
                        border-radius: 25px;
                        background-color: white;
                        border: 1px solid #ffffff;
                        width: 15px;
                        height: 15px;
                        font-size: 0.8em;
                        padding-top: -2px;
                        text-align: center;
                        font-weight: bold;
					}
					.refModel-blob-refArch {
						position: absolute;
						bottom: 0px;
						left: 2px;
					}
					.line-break{
                        margin-top:10px
                    }

                    .sidenav{ 
                        height: calc(100vh - 78px); 
                        width: 500px; 
                        position: fixed; 
                        z-index: 1; 
                        top: 78px; 
                        right: 0; 
                        background-color: #f6f6f6; 
                        overflow-x: hidden; 
                        transition: margin-right 0.5s; 
                        padding: 10px 10px 10px 10px; 
                        box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px; 
                        margin-right: -752px; 
                        } 
                        
                    .sidenav .closebtn{ 
                        position: absolute; 
                        top: 5px; 
                        right: 10px; 
                        font-size: 14px; 
                        margin-left: 50px; 
                        } 
                    @media screen and (max-height : 450px){ 
                        .sidenav{ 
                            padding-top: 53px; 
                        } 
                        .sidenav a{ 
                            font-size: 14px; 
                        } 
                    } 
                .componentBlob {
                    border-radius: 4px;
                    margin-bottom: 10px;
                    float: left;
                    width: 100%;
                    border: 1px solid #333;
                    color:#fff;
                    font-weight:bold;
                } 
 
                .componentBlob a {
                    color: #fff!important;
                }
                
                .componentBlob a:hover {
                    color: #ddd!important;
                }
                .componentSummary {
                    background-color: #333;
                    padding: 5px;
                    float: left;
                    width: 100%;
                } 
                .prodBox{
                    background-color:rgb(102, 102, 102);   
                    border-radius:6px;
                    padding:3px;

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
  
.vendor {
    font-size: 0.9em;
    color: #666;
}
 
.info {
    margin: 5px 0;
    font-size: 0.95em;
}

.highlight {
    font-weight: bold;
    color: #2a7bb8;
}

.section {
    margin-top: 15px;
    padding: 10px; 
    border-radius: 6px;
    box-shadow: 0px 1px 5px rgba(0,0,0,0.1);
    width:70%;
    display:inline-block;
    vertical-align:top;
	height: 75%;
}
.costSection {
    margin-top: 15px;
    padding: 10px; 
    border-radius: 6px;
    box-shadow: 0px 1px 5px rgba(0,0,0,0.1);
    width:28%;
    display:inline-block;
    vertical-align:top;
	position:relative;
	top: 50px;
    position: absolute;
	overflow: auto;
	height: 75%;
}

.standard-card {
    padding: 8px;
    border-left: 4px solid #2a7bb8;
	border-bottom: 2pt solid #e3e3e3;
	margin:2px;
    margin-bottom: 5px; 
    border-radius: 5px;
    width:25%;
    display:inline-block;
    vertical-align:top;
	background: rgba(255, 255, 255, 0.2); 
	 
}

.status {
    font-size: 0.85em;
    padding: 2px 6px;
    border-radius: 3px;
    display: inline-block;
}

.usage-container {
    display: flex;
    flex-wrap: wrap;
    gap: 5px;
}

.usage-pill {
    background: #ddd;
    padding: 5px 10px;
    border-radius: 15px;
    font-size: 0.9em;
}

.enums{
        position: relative;
        /* height: 20px; */
        border-radius: 8px;
        min-width: 60px;
        max-width:200px;
        font-size: 12px;
        line-height: 11px;
        padding: 3px 4px;
        border: 2px solid #fff;
        text-align: center;
        background-color: grey;
        color: #fff;
        margin:2px;
        display:inline-block
    }
    .lozenge{
        border-radius: 6px;
        font-size: 0.8em;
        padding:2px;
        border:1pt solid white;
        margin-left:2px;
        margin-right:2px;
        margin-top:2px;
    }
	.scopeLozenge{
        border-radius: 6px;
        font-size: 0.8em;
        padding:2px;
        border:1pt solid rgb(68, 96, 223);
		background-color: #ffffff;
        margin-left:2px;
        margin-right:2px;
        margin-top:2px;
		text-align: center;
    }

	.statusLozenge{
        border-radius: 6px;
        font-size: 0.8em;
        padding:3px;
        border:1pt solid white;
        margin-left:2px;
        margin-right:2px;
        margin-top:2px;
		text-align: center;
		font-weight:bold;
    }

    .circle{
        border: 1pt solid white;
        border-radius: 25px;
        height: 22px;
        width: 15px;
        text-align: center;
    }
	/* Modal Animation */
	.modal.fade .modal-dialog {
		transform: scale(0.8);
		transition: transform 0.3s ease-out;
	}
	.modal.in .modal-dialog {
		transform: scale(1);
	}

	.scope{
		border:1pt solid #d3d3d3;
		background-color: #54c9d1;
		color:#000000;
		border-radius:6px;
		margin:2px;
		padding:3px;
		padding-left: 4px;
		padding-right: 4px;
		max-width: 200px;
		display:inline-block;
		vertical-align: top;
	}
	.dateBox{
		border: 1pt solid #d3d3d3;
		border-radius: 6px;
		padding: 2px;
		font-size: 0.75em;
		display: inline-block;
		margin: 2px;
	}
	.techProductCircle{
		display:none;
		background-color: #aa3471;
		color: #ffffff;
	}
	.techComponentCircle{
		display:visible;
		background-color: #7439b4;
		color: #ffffff;
	}
	.hidden-ref-model{
		opacity: 0;
		transform: scale(0.98);
		transform-origin: center center;
	}

	.blue{
		color:rgb(28, 117, 165)
	}
 

	/* Styles for RTL layout */
	[dir="rtl"] .radio-inline {
		flex-direction: row-reverse; /* Reverse order for RTL */
	}
	.overlay{
		position: absolute;
		right: 15px;
		top: 26px;
	}
	.keyTab{
		width:80px;
		display:inline-block;
		margin-right: 5px;
		padding: 2px;
		text-align: center;
		font-size: 0.8em;
		border-radius:6px;
	}
	.warning{
		position: absolute;
		left: 2px;
		bottom: 2px;
	}
	.lifecycle{
		border: 1pt solid #ffffff;
		border-radius: 6px;
		color: #ffffff;
		padding: 2px;
		margin: 2px;
		width: 110px;
		font-size: 0.7em;
		text-align:center;
		display: inline-block;
	}
 </style>
  
<script type="text/javascript">
    
    <xsl:call-template name="RenderHandlebarsUtilityFunctions"/>
    var trmTemplate, techDetailTemplate, techDomainTemplate, ragOverlayLegend, noOverlayTRMLegend, trmData, dynamicFilterDefs, standardsList, techComponentMap;
    var currentTechDomain, tprMap, filterList, mergedTechProducts, modalTemplate, lifecycleLookupMap, techProducts, techProdRoles, techComponents, techHierarchyMap, filterExcludes;

    var stdStrength=[<xsl:apply-templates select="$stdStrength" mode="stdStrength"/>];
    let currentLocale="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>" 
    
    <xsl:call-template name="RenderJavascriptUtilityFunctions"/>

let configStr = '<xsl:value-of select="$reportConfig"/>';
let config;

try {
  config = JSON.parse(configStr);
  
  // Check if config is null, not an object, or missing expected structure
  if (!config || typeof config !== 'object' || !config.thresholds || !Array.isArray(config.thresholds.techCountThresholds)) {
    throw new Error('Invalid config structure');
  }
} catch (e) {
  config = {
    "thresholds": {
      "techCountThresholds": [
        {
          "label": "High",
          "lowerThreshold": 7,
          "backgroundColour": "#4b0033",  
          "fontColour": "#ffffff"
        },
        {
          "label": "Medium",
          "lowerThreshold": 4,
          "upperThreshold": 6,
          "backgroundColour": "#003c66",   
          "fontColour": "#ffffff"
        },
        {
          "label": "Low",
          "lowerThreshold": 0,
          "upperThreshold": 3,
          "backgroundColour": "#005f30", 
          "fontColour": "#ffffff"
        }
      ]
    }
  };
}
 

	$(document).ready(function() {
	let filterExcludes = [<xsl:for-each select="$theReport/own_slot_value[slot_reference='report_filter_excluded_slots']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>];
<!--
	let currentLang="<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference='name']/value"/>"    
 
	if(currentLang == 'ar'){
		 
		$('body').attr('dir', 'rtl' );
	}
	else{
	 
		$('body').attr('dir', 'ltr' );
	}
-->
	$('#togglePanel').on('click', function() {
		$('#techRefModelPanel').toggleClass('hidden-ref-model');
		$('#techStandardsPanel').toggleClass('hidden-ref-model'); 
		if ($('#techRefModelPanel').hasClass('hidden-ref-model')) {
			// If the reference model panel is hidden, show "Show Reference Model"
			$(this).text('<xsl:value-of select="eas:i18n('Show Reference Model')"/>')
		} else {
			// If the reference model panel is visible, show "Show Standards"
			$(this).text('<xsl:value-of select="eas:i18n('Show Standards')"/>');
		}
	})
    $('.infoPanel').hide();
	Promise.all([
		promise_loadViewerAPIData(viewAPIDataGetTechLifecycles),
		promise_loadViewerAPIData(viewAPIDataGetAllTechProds),
		promise_loadViewerAPIData(viewAPIDataGetAllTechProdRoles),
		promise_loadViewerAPIData(viewAPIDataGetAllTechProdImport),
		promise_loadViewerAPIData(viewAPIDataGetAllTechProdDomain),
		promise_loadViewerAPIData(viewAPIDataGetAllTechProdCaps),
		promise_loadViewerAPIData(viewAPIDataGetAllTechProdComps)
	]).then(function(responses) {
	 
		const today = new Date();

		lifecycleLookupMap = new Map();

		for (const item of responses[0].all_lifecycles) {
		if (item.type === 'Vendor_Lifecycle_Model') {
			const eol = item.dates?.find(date => date.name === "End of Life");
			if (eol &amp;&amp; new Date(eol.dateOf) &lt; today) {
			lifecycleLookupMap.set(item.productId, item);
			}
		}
		}
 
		techProducts = responses[1]; 
        filterList = responses[3].filters
		filters = responses[3].filters
        tprMap = new Map();
 
		techProdRoles=responses[2].techProdRoles
		techProdRoleStandards=responses[3].tprStandards
		techComponents=responses[6].technology_components
		techComponentMap = new Map(
		techComponents.map(tc => [tc.id, tc.name])
		);
	
function mergeById(techProdRoles, techProdRoleStads) {
    const map = new Map();

    // Add all objects from techProdRoles to the map
    techProdRoles.forEach(item => {
        map.set(item.id, { ...item });
    });

    // Merge objects from techProdRoleStads
    techProdRoleStads.forEach(item => {
        if (map.has(item.id)) {
            Object.assign(map.get(item.id), item);
        } else {
            map.set(item.id, { ...item });
        }
    });

    return Array.from(map.values());
}
 
function mergeWithTechComps(mergedArray, techcomps) {
    const map = new Map();

    // Add all objects from mergedArray to the map using id
    mergedArray.forEach(item => {
        map.set(item.id, { ...item });  // Use 'id' as the key
    });

    // Merge objects from techcomps, adding techComponentName
    techcomps.forEach(item => {
        if (map.has(item.techCompid)) {  // Match 'techCompid' to 'id'
            const existingItem = map.get(item.techCompid);
            Object.assign(existingItem, item, { techComponentName: item.name });  // Add techComponentName
        } else {
            map.set(item.techCompid, { ...item, techComponentName: item.name });
        }
    });

    return Array.from(map.values());
}
 
const mergedData = mergeById(techProdRoles, techProdRoleStandards);
 
const finalMergedData = mergeWithTechComps(mergedData, techComponents);
 
standardsList = finalMergedData.filter((d) => { 
	return d.compliance2?.length >  0 
});
 
function groupById(finalMergedData) {
    return finalMergedData.reduce((acc, item) => {
        if (!acc[item.techCompid]) {
            acc[item.techCompid] = [];
        }
        acc[item.techCompid].push(item);
        return acc;
    }, {});
}

// Example usage:
standardsList = groupById(standardsList); 
  
		filters=filters.sort((a, b) => a.slotName.localeCompare(b.slotName));

		

        // Populate the Map
        responses[2].techProdRoles.forEach(item => {
            if (!tprMap.has(item.techCompid)) {
                tprMap.set(item.techCompid, []);
            }
            tprMap.get(item.techCompid).push({
                id: item.techProdid,
                name: item.techProdName,
                className: "Technology_Product",
                standard: item.standard
            });
        });  
 
 updateItemsWithFilters(filterList, responses[3].technology_products)
		techProducts.techProducts.forEach((d) => {
			d['className'] = 'Technology_Product';
            delete d.link;
            delete d.roadmap;
            // Merge stds and usages
 
		})

function deepMerge(obj1, obj2) {
    const merged = {};

    const keys = new Set([...Object.keys(obj1), ...Object.keys(obj2)]);

    keys.forEach(key => {
        if (obj1[key] &amp;&amp; obj2[key]) {
            if (typeof obj1[key] === "object" &amp;&amp; typeof obj2[key] === "object" &amp;&amp; !Array.isArray(obj1[key]) &amp;&amp; !Array.isArray(obj2[key])) {
                merged[key] = deepMerge(obj1[key], obj2[key]);
            } else if (Array.isArray(obj1[key]) &amp;&amp; Array.isArray(obj2[key])) {
                // Merge arrays uniquely
                merged[key] = [...obj1[key], ...obj2[key]].filter(
                    (v, i, a) => a.findIndex(t => JSON.stringify(t) === JSON.stringify(v)) === i
                );
            } else {
                merged[key] = obj2[key]; // Override obj1’s value with obj2’s
            }
        } else {
            merged[key] = obj1[key] || obj2[key];
        }
    });

    return merged;
}

// Convert techProducts to a Map for O(1) lookups
const techProductMap = new Map(responses[3].technology_products.map(p => [p.id.replace(/\./g, '_'), p]));
 
// Create a new merged map
const mergedMap = new Map();

tprMap.forEach((products, key) => {
    const mergedProducts = products.map(product => {
        let matchingTechProduct = techProductMap.get(product.id) || {}; // O(1) lookup
        return deepMerge(product, matchingTechProduct);
    });

    mergedMap.set(key, mergedProducts);
});

// Convert the merged map to an array (if needed)
 mergedTechProducts = mergedMap; 
 
        // Merge product data
        const mergedProducts = [...responses[3].technology_products, ...techProducts.techProducts]
            .reduce((acc, product) => {
                acc[product.id] = { ...acc[product.id], ...product };
                return acc;
            }, {});
 
        // Convert back to array;
        techProducts = Object.values(mergedProducts)
	 
		techProdRoles = responses[2];

		filterExcludes.forEach((e)=>{
					filters=filters.filter((f)=>{
						return f.slotName !=e;
					})
				 })

		dynamicFilterDefs=filters?.map(function(filterdef){
			return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
		});

const techHierarchyMap = responses[5].technology_capability_hierarchy.reduce((map, item) => {
    map[item.id] = item;
    return map;
}, {});
 
// Group by ReferenceModelLayer
 trmData = responses[4].technology_domains.reduce((acc, item) => {
    const layer = item.ReferenceModelLayer || "Unspecified"; // Handle empty values
    if (!acc[layer]) {
        acc[layer] = [];
    }

    // Replace supportingCapabilities IDs with full objects from techHierarchy
    const expandedCapabilities = item.supportingCapabilities.map(capId => techHierarchyMap[capId] || { id: capId, name: "Unknown Component" });

    acc[layer].push({ ...item, supportingCapabilities: expandedCapabilities });
    return acc;
}, {});

$('#dupKey').hide();
 
		<!--SET UP THE TRM MODEL-->
		//initialise the TRM model
		var trmFragment = $("#trm-template").html();
		trmTemplate = Handlebars.compile(trmFragment);
 
		var keyFragment = $("#key-template").html();
		keyTemplate = Handlebars.compile(keyFragment);

		var modalFragment = $("#modal-template").html();
		modalTemplate = Handlebars.compile(modalFragment);
		
    var supportingCapsFragment = $("#supportingCaps-template").html(); 
        Handlebars.registerPartial("supportingCaps-template", supportingCapsFragment); 

		var techDetailFragment = $("#trm-techcap-popup-template").html();
		techDetailTemplate = Handlebars.compile(techDetailFragment);
        
        var componentsFragment = $("#components-template").html();
		componentsTemplate = Handlebars.compile(componentsFragment);
          
        var infoFragment = $("#info-template").html();
		infoTemplate = Handlebars.compile(infoFragment);

		var techStandardFragment = $("#standards-template").html();
		techStandardTemplate = Handlebars.compile(techStandardFragment);
		 
		Handlebars.registerHelper('getCls', function(arg1) {
			return arg1.split(' ').join('-');
		});

		Handlebars.registerHelper('getName', function(arg1) {
			 
			return techComponentMap.get(arg1);
		});

		Handlebars.registerHelper('formatDate', function(arg1) {
			return formatDateforLocale(arg1, currentLocale)     
		});


  

		Handlebars.registerHelper('getHMLValue', function(arg1) {
			if (arg1 === 0) return "None";

			 const threshold = config?.thresholds?.techCountThresholds.find(t => 
				 arg1 >= t.lowerThreshold &amp;&amp; 
    			(typeof t.upperThreshold === 'undefined' || arg1 &lt;= t.upperThreshold)
			);
			return 'background-color: ' + threshold.backgroundColour + '; color: ' + threshold.fontColour;
		});

        Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
            return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
        });

		Handlebars.registerHelper('formatCurrency', function(arg1, arg2, options) {
			var formatter = new Intl.NumberFormat(undefined, {  });
			if(arg1){
			return formatter.format(arg1);
			}
		});
   
		hardClasses=[{"class":"Group_Actor", "slot":"stakeholders"},
						<!--{"class":"Geographic_Region", "slot":"ap_site_access"}, -->
						{"class":"SYS_CONTENT_APPROVAL_STATUS", "slot":"system_content_quality_status"}
						]

						hardClasses = hardClasses.filter(item => 
							!filterExcludes.some(exclude => item.slot.includes(exclude))
						);

					let classesToShow = hardClasses.map(item => item.class);
					 
				essInitViewScoping(redrawView, classesToShow, filters, true); 
 
	});
});


//function to draw the relevant dashboard components based on the currently selected Data Objects
function redrawView() {
	
	let scopedtechList = techProducts  

	let typeInfo = {
		className: "Application_Provider",
		label: "Application",
		icon: "fa-desktop"
	};
 
	essResetRMChanges();
    
	let scopedTech = essScopeResources(
		scopedtechList,
		[
			new ScopingProperty("orgUserIds", "Group_Actor"),
	<!--	new ScopingProperty("geoIds", "Geographic_Region"), -->
			new ScopingProperty("visId", "SYS_CONTENT_APPROVAL_STATUS"),
			...dynamicFilterDefs
		],
		typeInfo
	);
 
function filterProducts(trmData, scopedtech, lifecycleLookupMap) {
    function traverseAndFilter(node) {
        if (Array.isArray(node)) {
            node.forEach(traverseAndFilter);
        } else if (typeof node === "object" &amp;&amp; node !== null) {
            // Check if the node has a 'products' property
            if (node.products &amp;&amp; Array.isArray(node.products)) {
                node.workingprods = node.products
                    .filter(product => {
                        if (!product || !product.id) return false;

                        const isIncluded = scopedtech.includes(product.id);
                        if (isIncluded &amp;&amp; lifecycleLookupMap.has(product.id)) {
                            product.hasLifecycleIssue = true; 
							node.hasLifecycleIssue = true ;// Add lifecycle flag
                        }
                        return isIncluded;
                    });
            }

            // Recursively process child properties
            for (let key in node) {
                if (Object.hasOwnProperty.call(node, key)) {
                    traverseAndFilter(node[key]);
                }
            }
        }
    }

    traverseAndFilter(trmData);
    return trmData;
}


trmData = filterProducts(trmData, scopedTech.resourceIds);
 

function rollUpComponents(data, mergedTechProducts) {
    function traverse(node) {
        // Initialize allComponents with the direct components of the node
        node.allComponents = node.components ? [...node.components] : [];

        // Initialize products as an empty array
        node.products = [];

        node.allComponents.forEach(c => {
            // Assign products based on mergedTechProducts
	
            if (mergedTechProducts.has(c.id)) {
                c.products = [...mergedTechProducts.get(c.id)]; // Keep products as an array
            } else {
                c.products = [];
            }
		
            // Append component products to node.products, avoiding duplicates while keeping order
            c.products.forEach(p => {
				if(lifecycleLookupMap.has(p.id)) {
                            p.hasLifecycleIssue = true; 
							c.hasLifecycleIssue = true ; 
							node.hasLifecycleIssue = true ; 
                        }
                if (!node.products.includes(p)) {
                    node.products.push(p);
                }
            });
        });

        // Process supportingCapabilities recursively
        if (node.supportingCapabilities) {
            node.supportingCapabilities.forEach(child => {
                traverse(child);

                // Merge child components into the current node's allComponents
                node.allComponents.push(...child.allComponents);

                // Merge child products into the current node's products while avoiding duplicates
                child.products.forEach(p => {
                    if (!node.products.includes(p)) {
                        node.products.push(p);
                    }
                });
            });
        }
    }

    // Process each category in data
    Object.keys(data).forEach(category => {
        data[category].forEach(rootNode => traverse(rootNode));
    });

    return data;
}
 
 
rollUpComponents(trmData, mergedTechProducts) 

 
$('#techRefModelContainer').html(trmTemplate(trmData))

let variation=$('input[name="techOverlay"]:checked').val();
 
if(variation =='product'){
	$('.techProductCircle').show();  
}
 
$('#dupKey').html(keyTemplate(config.thresholds.techCountThresholds));

let filteredStds={}
Object.keys(standardsList).forEach(key => {
	filteredStds[key] = standardsList[key].filter(
    item => scopedTech.resourceIds.includes(item.techProdid)
  );
});
 
// Ensure the table is properly rendered before applying DataTable
// First, make sure the data is rendered correctly in the DOM
$('#dataPanel').html(techStandardTemplate(filteredStds));
 
// Ensure the table is correctly rendered and footer is present
$('#standardsTable tfoot th').each(function() {
    var title = $(this).text();
    var titleid = title.replace(/ /g, "_");

    // Add input fields for column search
    $(this).html('<input type="text" class="filter" id="' + titleid + '" placeholder="Search ' + title + '" />');
});

// Initialize DataTable after the table has been rendered
$(document).ready(function() {
    var table = $('#standardsTable').DataTable({
        "paging": true,
        "info": false,
		"pageLength": 10,  
        "searching": true,  // Enable searching for individual columns
        "order": [[0, "asc"]],
        "columnDefs": [
            { "orderable": false, "targets": 0 }
        ]
    });

    // Attach event listeners to each column search input
    table.columns().every(function(index) {
        var that = this;

        // Bind 'keyup' or 'change' events to the input fields in the footer
        $('input', this.footer()).on('keyup change', function() {
            // If value changes, apply search to that column
            if (that.search() !== this.value) {
                that
                    .column(index)  // Apply search only to the specific column
                    .search(this.value)  // Set the search term for that column
                    .draw();  // Redraw the table with the filtered data
            }
        });
    });
});




$('input[name="techOverlay"]').change(function() {
	let selectedValue = $('input[name="techOverlay"]:checked').val();
		if (selectedValue === "component") {
			$('.techProductCircle').fadeOut(300, function() { 
                $('.techComponentCircle').fadeIn(300); 
				$('#dupKey').fadeOut(300)
            });
			
		} else {
			 
			$('.techComponentCircle').fadeOut(300, function() { 
                $('.techProductCircle').fadeIn(300); 
				$('#dupKey').fadeIn(300)
            }); 
		}
})

function findById(data, id) {
    function search(node) {
        if (node.id === id) {
            return node;
        }
        if (node.supportingCapabilities) {
            for (const child of node.supportingCapabilities) {
                const found = search(child);
                if (found) return found;
            }
        } 
        return null;
    }
    
    for (const category in data) {
        for (const rootNode of data[category]) {
            const result = search(rootNode);
            if (result) return result;
        }
    }
    return null;
}

$('.refModel-blob-info').on('click', function(){
    let selected=$(this).attr('techcomp-id');
 
    let match = findById(trmData, selected)
 
    $('#aList').html(componentsTemplate(match)  ) 
    openNav();
     $('.productInfo').on('click',function(){

            let compId=$(this).attr('compid')
			let prodId=$(this).attr('easid');
            let comp = match.allComponents.find((c)=>{return c.id == compId})
    
            let prod = comp.products.find((p)=>{ return p.id == prodId})

            let techDetail=techProducts.find((p)=>{ 
                return p.id == prod.id;
                })

focusprod= prod

if(lifecycleLookupMap.get(focusprod.id)){
	focusprod['lifecycle']=lifecycleLookupMap.get(focusprod.id).dates;
	focusprod.lifecycle=focusprod.lifecycle.slice().sort((a, b) => a.dateOf.localeCompare(b.dateOf));
}
  
 //updateItemsWithFilters(filterList, [focusprod])
 mergeUsagesWithStandard(focusprod)

			$('#panelData').html(infoTemplate(focusprod));
           
			$('.infoPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
	
			//$('#appModal').modal('show');
			$(document).on('click','.closePanelButton', function(){ 
				event.stopPropagation(); // Prevents the event from bubbling up the DOM tree
				event.preventDefault(); 
				$('.infoPanel').hide();
			})

			$('.fa-globe').off().on('click', function(){
				let selected=$(this).attr('geoid');
				let match = focusprod.usages?.find((e)=>{
					return e.id == selected;
				})
		 
				$('#modalContent').html(modalTemplate(match.mergedStandard.scopeGeo));
				$('#modalTitle').html('Geographic Scope');
				$('#infoModal').modal('show');
			})

			$('.fa-sitemap').off().on('click', function(){
				let selected=$(this).attr('orgid');
				let match = focusprod.usages?.find((e)=>{
					return e.id == selected;
				})
			 
				$('#modalContent').html(modalTemplate(match.mergedStandard.scopeOrg));
				$('#modalTitle').html('Organisation Scope');
				$('#infoModal').modal('show');
				
			})
		 })
})
     
}

function updateItemsWithFilters(filters, items) {
  
    // Create a lookup dictionary from the filters array
    let filterLookup = {};
    let nameMap = {};
    filters.forEach(filter => {
        let valueMap = {};
        
        filter.values.forEach(value => {
            valueMap[value.id] = value; // Store full value object instead of just enum_name
        });
        nameMap[filter.slotName]= filter.name;
        filterLookup[filter.slotName] = valueMap;
    });
    // Iterate over the second array and update properties
    items.forEach(item => {
        let enums=[]
        Object.keys(item).forEach(key => {
            if (filterLookup[key] &amp;&amp; Array.isArray(item[key])) {
                let enumerations = []; 
                item[key].forEach(valueId => {
                    if (filterLookup[key][valueId]) {
                        enums.push({"key": nameMap[key], "vals": filterLookup[key][valueId]});
                    }
                });
            }
                item['enumerations']=enums
        });
    });

    return items; // Return the updated items array
}

function mergeUsagesWithStandard(data) {
    // Convert standard array to a map for quick lookup
    let standardMap = new Map();
    data.standard.forEach(std => {
        standardMap.set(std.id, std);
    });
    
    // Merge matching usages with standard properties
    data.usages?.forEach(usage => {
        if (usage.stdid &amp;&amp; standardMap.has(usage.stdid)) {
            let matchedStandard = standardMap.get(usage.stdid);
            usage.mergedStandard = { ...matchedStandard };
        }
    });
    
    return data;
}

function openNav() {  
    document.getElementById("sidenav").style.marginRight = "0px"; 
} 

function closeNav() { 
    document.getElementById("sidenav").style.marginRight = "-752px"; 
} 
				</script>
			 
				
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Reference Model')"/></span>
								</h1>
							</div>
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<xsl:call-template name="techSection"/>
						
						<!--<xsl:call-template name="mockup"/>-->
						
						<!--Setup Closing Tags-->
					</div>
				</div>

                <div class="infoPanel" id="infoPanel">
                    <div class="text-right">
						<i class="fa fa-times closePanelButton left-30"></i>
					</div>
						<div id="panelData"></div>
				</div>

                <div id="sidenav" class="sidenav"> 
                <a href="javascript:void(0)" class="closebtn text-default" onclick="closeNav()"> 
                <i class="fa fa-times"></i> 
                </a> 
                <br/> 
                <div id="aList"/> 
                
                </div> 

				<div id="infoModal" class="modal fade" role="dialog">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"><i class="fa fa-close"></i></button>
								<h4 class="modal-title" id="modalTitle"></h4>
							</div>
							<div class="modal-body" id="modalContent"></div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal"><xsl:value-of select="eas:i18n('Close')"/></button>
							</div>
						</div>
					</div>
				</div>

<script id="key-template" type="text/x-handlebars-template">
	<xsl:value-of select="eas:i18n('Duplication')"/>:
	{{#each this}}
		<div class="keyTab"><xsl:attribute name="style">background-color:{{this.backgroundColour}};color:{{this.fontColour}}</xsl:attribute>{{this.label}}</div>
	{{/each}}
</script>
              
<script type="text/javascript">
<xsl:call-template name="RenderViewerAPIJSFunction">
<xsl:with-param name="viewerAPIPathGetTechLifecycles" select="$apiPathGetTechLifecycles"/>
<xsl:with-param name="viewerAPIPathGetAllTechProds" select="$apiPathGetAllTechProds"/>
<xsl:with-param name="viewerAPIPathGetAllTechProdRoles" select="$apiPathGetAllTechProdRoles"/>	
<xsl:with-param name="viewerAPIPathGetAllTechProdImport" select="$apiPathGetAllTechProdImport"/>	
<xsl:with-param name="viewerAPIPathGetAllTechProdDomain" select="$apiPathGetAllTechDomain"/>	
<xsl:with-param name="viewerAPIPathGetAllTechProdCaps" select="$apiPathGetAllTechCaps"/>	
<xsl:with-param name="viewerAPIPathGetAllTechProdComps" select="$apiPathGetAllTechProdComps"/>	
	  
	
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
  
			</body>
		</html>
	</xsl:template>

	<xsl:template name="techSection">
		<!--Top-->
		<script id="trm-template" type="text/x-handlebars-template">
			<div class="col-xs-12">
				{{#each Top}} 
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}} 
								</div>
								{{> supportingCaps-template }}
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
				{{#each Left}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}  
								</div>
								{{> supportingCaps-template }}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Center-->
			<div class="col-xs-4 col-md-6 col-lg-8 matchHeightTRM">
				{{#each Middle}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer">
								<div class="refModel-l0-title fontBlack large">
									{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
								</div>
								{{> supportingCaps-template }}
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
				{{#each Right}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
								</div>
								{{> supportingCaps-template }}
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
				{{#each Bottom}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
								</div>
								{{> supportingCaps-template }}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			
			<!--Ends-->
			<!--unspecified-->
			<div class="col-xs-12">
				<div class="clearfix bottom-10"/>
				{{#each Unspecified}}
					<div class="row bottom-10">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
								</div>
								{{> supportingCaps-template }}
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

<script id="modal-template" type="text/x-handlebars-template">
   {{#each this}}
		<div class="scope">{{this.name}}</div>
   {{/each}}
</script>
<script id="standards-template" type="text/x-handlebars-template">
<table class="table table-condensed table-striped" id="standardsTable">
	<thead><tr><th><xsl:value-of select="eas:i18n('Product')"/></th><th><xsl:value-of select="eas:i18n('Component')"/></th><th><xsl:value-of select="eas:i18n('Standard')"/></th><th width="200px;"><i class="fa fa-globe blue"/><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Geographic Scope')"/></th><th width="200px;"><i class="fa fa-sitemap blue"/><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Organisation Scope')"/></th></tr></thead>
	<tbody>
	{{#each this}}	
	{{this.techProdName}}
		{{#each this}}
	 
		{{#each this.standard}}	 
		<tr>
			<td>{{../this.techProdName}}</td>
			<td>{{#getName ../this.techCompid}}{{/getName}}</td>
			<td> <div class="statusLozenge"><xsl:attribute name="style">color: {{this.statusColour}};background-color:{{this.statusBgColour}}</xsl:attribute>{{this.status}}</div></td>
			<td>{{#each this.scopeGeo}}
				<div class="scopeLozenge">{{this.name}}</div>
				{{/each}}</td>
			<td>{{#each this.scopeOrg}}
				<div class="scopeLozenge">{{this.name}}</div>
				{{/each}}</td>
		</tr> 
		{{/each}}
		{{/each}}
	
	
{{/each}}
</tbody>
<tfoot><tr><th><xsl:value-of select="eas:i18n('Product')"/></th><th><xsl:value-of select="eas:i18n('Component')"/></th><th><xsl:value-of select="eas:i18n('Standard')"/></th><th width="200px;"><i class="fa fa-globe blue"/><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Geographic Scope')"/></th><th width="200px;"><i class="fa fa-sitemap blue"/><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Organisation Scope')"/></th></tr></tfoot>
</table>
</script>


 <script id="info-template" type="text/x-handlebars-template">
  <h2>{{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}</h2>
  <b><xsl:value-of select="eas:i18n('Supplier')"/></b>: {{vendor}}
    <div class="tech-details">
        {{#if description}}
        <div class="info">
            <strong><xsl:value-of select="eas:i18n('Description')"/>:</strong> {{description}}
        </div>
        {{/if}}

        {{#each this.enumerations}}
            <div class="enums"><xsl:attribute name="style">color: {{this.vals.colour}};background-color:{{this.vals.backgroundColor}}</xsl:attribute>{{this.key}}<br/><b>{{this.vals.enum_name}}</b></div>
        {{/each}} 
		<div class="clearfix"></div>
		 {{#each this.lifecycle}}
            <div class="lifecycle"><b>{{this.name}}</b><br/>{{#formatDate this.dateOf}}{{/formatDate}}</div>{{#unless @last}} <i class="fa fa-caret-right"></i> {{/unless}}
        {{/each}} 
    </div>

    {{#if usages.length}}
    <div class="section">
        <h3><xsl:value-of select="eas:i18n('Usages')"/></h3> 
        {{#each usages}}
        <div class="standard-card">
            <strong>{{name}}</strong><br/>
            <small>Standard</small><br/>
            <span class="status"><xsl:attribute name="style">color:{{this.mergedStandard.statusColour}};background-color:{{this.mergedStandard.statusBgColour}}</xsl:attribute>{{#if this.mergedStandard}}{{this.mergedStandard.status}}{{else}}<xsl:value-of select="eas:i18n('None Defined')"/>{{/if}}</span>
			<div class="pull-right">
				{{#if this.mergedStandard.scopeGeo}}<i class="fa fa-globe"><xsl:attribute name="geoid">{{this.id}}</xsl:attribute></i>{{/if}}
				{{#if this.mergedStandard.scopeOrg}}<i class="fa fa-sitemap"><xsl:attribute name="orgid">{{this.id}}</xsl:attribute></i>{{/if}}
			</div>
        </div>
        {{/each}}
    </div>
    {{/if}}

    {{#if costs.length}}
    <div class="costSection">
        <h3>Costs</h3>
		<table class="table table-condensed">
		<thead><tr><td><xsl:value-of select="eas:i18n('Cost Type')"/></td><td><xsl:value-of select="eas:i18n('Cost')"/></td><td><xsl:value-of select="eas:i18n('Cost Frequency')"/></td><td><xsl:value-of select="eas:i18n('Date Range')"/></td></tr></thead>
		<tbody>
        {{#each costs}}
        <tr>
		<td>{{this.name}}</td>
		<td>
		{{#if this.component_currency}}{{this.component_currency}}{{else}} {{this.currency}}{{/if}}{{#formatCurrency this.cost}}{{/formatCurrency}}
		</td>
		<td>
		<button class="btn btn-default btn-xs" data-toggle="tooltip" data-placement="top">
			{{#ifEquals this.costType 'Annual_Cost_Component'}}<xsl:value-of select="eas:i18n('Annual')"/>{{/ifEquals}}
			{{#ifEquals this.costType 'Monthly_Cost_Component'}}<xsl:value-of select="eas:i18n('Monthly')"/>{{/ifEquals}}
			{{#ifEquals this.costType 'Quarterly_Cost_Component'}}<xsl:value-of select="eas:i18n('Quarterly')"/>{{/ifEquals}}
			{{#ifEquals this.costType 'Adhoc_Cost_Component'}}<xsl:value-of select="eas:i18n('Ad Hoc')"/>{{/ifEquals}}
		</button>
		</td>
		<td>
		{{#if this.fromDate}}
			<div class="dateBox">{{#formatDate this.fromDate}}{{/formatDate}}</div>
		{{/if}}
		{{#if this.toDate}}
			<div class="dateBox">{{#formatDate this.toDate}}{{/formatDate}}</div>
		{{/if}}
		</td>
        </tr>
		{{/each}}
		</tbody>
		</table>
    </div> 
    {{/if}}
 </script>
<script id="components-template" type="text/x-handlebars-template">
<h3>{{this.name}}</h3>
<p><xsl:value-of select="eas:i18n('Technology Components')"/></p>
    {{#each this.allComponents}}
        <div class="componentBlob">
            <div class="componentSummary">
                {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                <div class="prodBox">
				{{#if this.workingprods}}
					{{#each this.workingprods}}
					<i class="fa fa-caret-right"></i> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
				
					{{#if this.enumerations}}
						{{#each this.enumerations}}
						{{#ifEquals this.key 'Vendor Lifecycle Status'}}
						<div class="pull-right left-2 top-2"><div class="lozenge"><xsl:attribute name="style">color: {{this.vals.colour}};background-color:{{this.vals.backgroundColor}}</xsl:attribute>{{this.vals.name}}</div></div>
						{{/ifEquals}}
						{{#ifEquals this.key 'Disposition Lifecycle Status'}}
						<div class="pull-right left-2 top-2"><div class="lozenge"><xsl:attribute name="style">color: {{this.vals.colour}};background-color:{{this.vals.backgroundColor}}</xsl:attribute>{{this.vals.name}}</div></div>
						{{/ifEquals}}
						{{/each}}
					{{/if}}
					<div class="pull-right left-2 top-5 right-5"><i class="fa fa-info-circle productInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="compid">{{../this.id}}</xsl:attribute></i></div>
					{{#if this.standard}}
					<div class="pull-right left-2 top-5 right-5"><i class="fa fa-bookmark productInfo"><xsl:attribute name="style">{{this.standard.0.statusBgColour}}</xsl:attribute><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="compid">{{../this.id}}</xsl:attribute></i></div>
					{{/if}} 
					{{#if this.hasLifecycleIssue}}
					<div class="pull-right left-2 top-5 right-5"><i class="fa fa-exclamation-triangle" style="color:white"></i></div>
					{{/if}}
					<div class="clearfix"/>
			{{/each}}
				{{else}}
                {{#each this.products}}
                    <i class="fa fa-caret-right"></i> {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
                   
                     {{#if this.enumerations}}
                        {{#each this.enumerations}}
           
                        {{#ifEquals this.key 'Vendor Lifecycle Status'}}
                        <div class="pull-right left-2 top-2"><div class="lozenge"><xsl:attribute name="style">color: {{this.vals.colour}};background-color:{{this.vals.backgroundColor}}</xsl:attribute>{{this.vals.name}}</div></div>
                        {{/ifEquals}}
						{{#ifEquals this.key 'Disposition Lifecycle Status'}}
						<div class="pull-right left-2 top-2"><div class="lozenge"><xsl:attribute name="style">color: {{this.vals.colour}};background-color:{{this.vals.backgroundColor}}</xsl:attribute>{{this.vals.name}}</div></div>
						{{/ifEquals}}
                    
                        {{/each}}
                    {{/if}}
					<div class="pull-right left-2 top-5 right-5"><i class="fa fa-info-circle productInfo"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="compid">{{../this.id}}</xsl:attribute></i></div>
                     {{#if this.standard}}
                    <div class="pull-right left-2 top-5 right-5"><i class="fa fa-bookmark productInfo"><xsl:attribute name="style">{{this.standard.0.statusBgColour}}</xsl:attribute><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="compid">{{../this.id}}</xsl:attribute></i></div>
                    {{/if}} 
					{{#if this.hasLifecycleIssue}}
					<div class="pull-right left-2 top-5 right-5"><i class="fa fa-exclamation-triangle" style="color:white"></i></div>
					{{/if}}
                    <div class="clearfix"/>
                {{/each}}
				{{/if}}
                </div>
            </div>
        </div>
    {{/each}}
</script>      
<script id="supportingCaps-template" type="text/x-handlebars-template">
 {{#each supportingCapabilities}}
    <div class="techRefModel-blob">
        <xsl:attribute name="eas-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
        <xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>

        <div class="refModel-blob-title">
            {{#essRenderInstanceMenuLink this}}{{/essRenderInstanceMenuLink}}
            <div class="line-break"/>
            {{#if supportingCapabilities}}
            {{> supportingCaps-template }} 
            {{/if}} 
			{{#ifEquals this.hasLifecycleIssue true}}
			<div class="warning">
				<i class="fa fa-exclamation-triangle"  style="color:red"></i>
			</div>
			{{/ifEquals}}
        </div>

        <div class="refModel-blob-info techComponentCircle">
            <xsl:attribute name="techcomp-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
            {{this.allComponents.length}}
        </div>
		<div class="refModel-blob-info techProductCircle">
			<xsl:attribute name="style">{{#if this.workingprods}}{{#getHMLValue this.workingprods.length}}{{/getHMLValue}}{{else}}{{#getHMLValue this.products.length}}{{/getHMLValue}}{{/if}}</xsl:attribute>
            <xsl:attribute name="techcomp-id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
            {{#if this.workingprods}}{{this.workingprods.length}}{{else}}{{this.products.length}}{{/if}}
        </div>
    </div>
{{/each}}
</script>
		
		<script>
			$(document).ready(function() {
			 	$('.matchHeight1').matchHeight();
			});
		</script>
		<div class="pull-right"><button class="btn btn-xs btn-info right-5 bottom-5" id="togglePanel"><xsl:value-of select="eas:i18n('Show Standards')"/></button></div>
		<div class="col-xs-12">
			<div id="techStandardsPanel"  class="dashboardPanel bg-offwhite hidden-ref-model">
				<h2 id="ref-model-head-title" class="text-secondary"><xsl:value-of select="eas:i18n('Technology Standards')"/></h2>
				<div id="dataPanel"></div>
			</div>
			<div id="techRefModelPanel" class="dashboardPanel bg-offwhite">
				<h2 id="ref-model-head-title" class="text-secondary"><xsl:value-of select="eas:i18n('Reference Model')"/></h2>
				<div class="pull-right overlay right-5 uppercase">
			
							<div class="keyTitle"><xsl:value-of select="eas:i18n('Overlay')"/>:</div>
							<small>
							<label class="radio-inline"><input type="radio" name="techOverlay"  value="component" checked="checked" /><xsl:value-of select="eas:i18n('Components')"/></label>
							<label class="radio-inline"><input type="radio" name="techOverlay"  value="product"/><xsl:value-of select="eas:i18n('Products')"/></label>
							
							<i class="fa fa-exclamation-triangle" style="color:red"></i><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('End of Life Issue')"/><xsl:text> </xsl:text>
							<div id="dupKey"></div>
							</small>
				</div>
				<div class="row">
					<!--   LEGEND SECTION 
					<div class="col-xs-6 bottom-15" id="trmLegend">
						<div class="keyTitle"><xsl:value-of select="eas:i18n('Legend')"/>:</div>
						<div class="keySampleWide bg-brightred-120"/>
						<div class="keyLabel"><xsl:value-of select="eas:i18n('High')"/></div>
						<div class="keySampleWide bg-orange-120"/>
						<div class="keyLabel"><xsl:value-of select="eas:i18n('Medium')"/></div>
						<div class="keySampleWide bg-brightgreen-120"/>
						<div class="keyLabel"><xsl:value-of select="eas:i18n('Low')"/></div>
						<div class="keySampleWide bg-darkgrey"/>
						<div class="keyLabel"><xsl:value-of select="eas:i18n('Undefined')"/></div>
					</div>
					--> 
						
				 
					<!-- REFERENCE MODEL CONTAINER -->
					<div class="simple-scroller" id="techRefModelContainer"/>					
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
		<xsl:param name="viewerAPIPathGetTechLifecycles"/>
		<xsl:param name="viewerAPIPathGetAllTechProds"/>
		<xsl:param name="viewerAPIPathGetAllTechProdRoles"/>
		<xsl:param name="viewerAPIPathGetAllTechProdImport"/> 
		<xsl:param name="viewerAPIPathGetAllTechProdDomain"/>
		<xsl:param name="viewerAPIPathGetAllTechProdCaps"/>
		<xsl:param name="viewerAPIPathGetAllTechProdComps"/>
		

		var viewAPIDataGetTechLifecycles =  '<xsl:value-of select="$viewerAPIPathGetTechLifecycles"/>';
		var viewAPIDataGetAllTechProds =  '<xsl:value-of select="$viewerAPIPathGetAllTechProds"/>';
		var viewAPIDataGetAllTechProdRoles =  '<xsl:value-of select="$viewerAPIPathGetAllTechProdRoles"/>';
		var viewAPIDataGetAllTechProdImport =  '<xsl:value-of select="$viewerAPIPathGetAllTechProdImport"/>'; 
		var viewAPIDataGetAllTechProdDomain =  '<xsl:value-of select="$viewerAPIPathGetAllTechProdDomain"/>';
		var viewAPIDataGetAllTechProdCaps =  '<xsl:value-of select="$viewerAPIPathGetAllTechProdCaps"/>';
		var viewAPIDataGetAllTechProdComps =  '<xsl:value-of select="$viewerAPIPathGetAllTechProdComps"/>';
 
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
     	const promise_loadViewerAPIData = (apiDataSetURL) => {
			return new Promise((resolve, reject) => {
				if (!apiDataSetURL) {
				reject(new Error("API URL is required.")); // Reject with an error object
				return;
				}

				fetch(apiDataSetURL)
				.then((response) => {
					if (!response.ok) {
					throw new Error(`Network response was not ok: ${response.status}`);
					}
					return response.json();
				})
				.then((viewerData) => {
					resolve(viewerData);
					$('#ess-data-gen-alert').hide();
				})
				.catch((error) => {
					reject(error); // Reject with the error object
				});
			});
		};
        
    </xsl:template>
   
	<xsl:template match="node()" mode="stdStrength">
			{"status":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>",
			"cls":"<xsl:value-of select="translate(current()/own_slot_value[slot_reference = 'enumeration_value']/value, ' ','-')"/>",
				"statusColour":"<xsl:value-of select="eas:get_element_style_textcolour(current())"/>",
				"statusBgColour":"<xsl:value-of select="eas:get_element_style_colour(current())"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
