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
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>
	<!-- END GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="reportPath" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
	<xsl:variable name="reportPathApps" select="/node()/simple_instance[type = 'Report'][own_slot_value[slot_reference='name']/value='Core: Application Rationalisation Analysis']"/>
	-->
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
	<xsl:variable name="theReport" select="/node()/simple_instance[own_slot_value[slot_reference='name']/value='Core: Application Landscape']"></xsl:variable>
	
	<xsl:variable name="busCapData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Caps']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>
	<xsl:variable name="capsListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"></xsl:variable>
	<xsl:variable name="kpiListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = ('Core API: App KPIs','Core: App KPIs')][1]"></xsl:variable>
	<xsl:variable name="servicesListData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Services']"></xsl:variable>

<!--	<xsl:variable name="scoreData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: App KPIs']"></xsl:variable>
-->
	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<xsl:variable name="apiBCM">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$busCapData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiApps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiCaps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$capsListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiKpi">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$kpiListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiSvcs">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$servicesListData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
	 
<!--		<xsl:variable name="apiScores">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$scoreData"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
	-->
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<script src="js/d3/d3.min.js?release=6.19"></script>
				<title><xsl:value-of select="eas:i18n('Application Landscape')"/></title>
				<style>
						#area {
						
					}
					.app > i {
						position:absolute;
						bottom: 3px;
						right: 5px;
						color: #666;
						font-size: 90%;
					}
					
					.app > .bushealth {
						border-radius:3px;
						position:absolute;
						top:2px;
						left: 2px;
						color: #fff;
						font-size: 1px;
						height: 15px;
						width:5px;
						
					}
					.app > .techhealth {
						border-radius:3px;
						position:absolute;
						top:17px;
						left: 2px;
						color: #fff;
						font-size: 1px;
						height: 15px;
						width:5px;
					}
					.app > .info { 
						position:absolute;
						top:20px;
						right: 2px;
						color: #000; 
					 
					}
					.app{
						position: relative;
						height: 40px;
						width: 140px;
						border: 1pt solid #aaa;
						background-color: #fff;
						color: #333;
						border-radius: 4px;
						margin: 0 10px 10px 0;
						padding: 2px;
						line-height: 1.1em;
						align-items: center;
						display: flex;
						justify-content: center;
						min-width: 140px;
					}
					
					.app:hover{
						border: 1pt solid #666;
						box-shadow: 0 1px 2px rgba(0,0,0,0.25);
					}
					
					.appContainer {
						display: flex;
						margin-top: 10px;
						flex-wrap: wrap;
					}
					.capContainer {
						border:1pt solid #aaa;
						padding:10px 10px 0 10px;
						border-radius:4px;
						background-color:#f6f6f6;						
					}
					.capTitleLarge {
						font-weight: 700;
						font-size: 125%;
					}
					.appTitle {
						text-align: center;
					}
					
					.topcapappcount {
						border-radius: 14px;
						width: 28px;
					}
					
					.subcapappcount {
						border-radius: 11px;
						width: 22px;
					}

					.topcapappcount,.subcapappcount {
						background-color: #fff;
						color: #999;
						display: inline-block;
						margin-left: 5px;
						text-align: center;
						border: 1px solid #aaa;
						padding: 0 4px;
					}
					.blob{
						height:10px;
						border-radius:8px;
						width:30px;
						border:1px solid #666; 
						background-color: #fff;
						}

					.blobNum{
						color: rgb(140, 132, 112);
						font-weight:bold;
						font-size:9pt;
						text-align:center;
					}
					
					.blobBox,.blobBoxTitle{
						display: inline-block;
					}
					
					.blobBox {
						position: relative;
						top: -12px;
					}
					#appPanel {
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
					#appData{

                    }
					.tab-content {
                    	padding-top: 10px;
                    }
                    .ess-tag-default {
                    	background-color: #adb5bd;
                    	color: #333;
                    }
                    
                    .ess-tag-default > a{
                    	color: #333!important;
                    }
                    
                    .ess-tag {
                    	padding: 3px 12px;
                    	border: 1px solid #222;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    }
                	.inline-block {display: inline-block;}
                	.ess-small-tabs > li > a {
                		padding: 5px 15px;
                	}
                	.badge.dark {
                		background-color: #555!important;
                	}
                	.vertical-scroller {
                		overflow-x:hidden;
                		overflow-y: auto;
                		padding-right: 5px;
                	}
					.middle{
						float: left;
						justify-content: center;
						margin-left:25%
					}
					.helpBox{
						position: absolute;
						top: 20px;
						right: 20px;
					}
					.badge-inverse {
						background-color: #fff;
						color: #777
					}
					.fa-info-circle,.fa-question-circle {cursor: pointer;}
					.retirebox{
						display:inline-block;
					}
                    .enumKey{
                        position: relative;
                        top:0px;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Landscape')"></xsl:value-of> </span>
									<span class="text-primary">
										<span id="rootCap"></span>
									</span>
								</h1>
                             
							</div>
							
							
						</div>
						<xsl:call-template name="RenderDataSetAPIWarning"/>
						<div class="col-xs-12">
							<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="helpmodallabel" aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"/></span></button>
											<h3 class="text-primary"><i class="fa fa-question-circle right-5"/><strong><xsl:value-of select="eas:i18n('Help')"/></strong></h3>
										</div>
										<div class="modal-body">
											<h4 class="strong"><xsl:value-of select="eas:i18n('Via Process')"/></h4>
											<p><xsl:value-of select="eas:i18n('Business fit can be mapped via business processes, so the application can be good for this process but poor for a different process.  Essential can pick up the mapping either via the service or the direct mapping of the application to the process.  If you look at the model, a single application can have different colours/values in the capability model if you take this approach')"/></p>
											<h4 class="strong"><xsl:value-of select="eas:i18n('By Application')"/></h4>
											<p><xsl:value-of select="eas:i18n('If this level does not exist then you can also have a simple mapping, i.e. this application is good, and every occurence will be the same colour or value')"/>.</p>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-danger" data-dismiss="modal"><xsl:value-of select="eas:i18n('Close')"/></button>
										</div>
									</div>
								</div>
							</div>
							<div id="editor-spinner" class="hidden">
								<div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;">
									<div class="spin-icon" style="width: 60px; height: 60px;">
										<div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
										<div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
										<div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
									</div>                      
								</div>
								<div id="editor-spinner-text" class="text-center xlarge strong spin-text2"/>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="overlay-selection">
								<!--<label class="right-10">Level:</label>
								<select class="select2" id="level-selection" style="width: 160px;">
								</select>-->
								<div class="pull-left">
									<label class="right-10"><xsl:value-of select="eas:i18n('Overlay')"/>:</label>
									<select class="select2 form-control" id="measure-selection" style="width: 160px;"/>
								</div>
                                <div class="pull-left left-5">
									<label class="right-10"><xsl:value-of select="eas:i18n('Heatmap')"/>:</label>
									<select class="select2 form-control" id="enum-selection" style="width: 160px;"/>
								</div>
								<div class="pull-left left-30 " id="simps">
									<label class="right-10" style="position: relative; top: 2px;"><xsl:value-of select="eas:i18n('Analyse')"/>:</label>
									<label class="radio-inline">
										<input class="anRad" type="radio" name="appProcessSwitch" id="viaProcess" value="viaProcess"/> <xsl:value-of select="eas:i18n('Via Process')"/>
									</label>
									<label class="radio-inline">
										<input class="anRad" type="radio" name="appProcessSwitch" id="viaApp" value="viaApp" checked="checked"/><xsl:value-of select="eas:i18n('Via Application')"/>
									</label>
									<i class="fa fa-question-circle" style="position: relative; top: 2px;" id="helpMe"></i>
								</div>
								
							</div>
							
							<div class="clearfix"/>
							<div class="overlay-selection top-10" id="sqkey"/>
							<div class="overlay-selection top-10" id="nokey"><xsl:value-of select="eas:i18n('No Key Data Defined - set styles in repository')"/></div>
							
						</div>
						<div class="col-sm-6">
							<div class="pull-right"> 
							<div class="overlay-selection top-10 retirebox">
								<strong class="left-30 right-5"><xsl:value-of select="eas:i18n('Show Retired')"/>:</strong>
								<input type="checkbox" id="retired" name="retired"/>
							</div>
								<div id="levelsbox" class="retirebox"/>
							
							</div>
						</div>
                        <div class="col-xs-12">   
                            <div class="pull-right enumKey" id="enumKey"/>
                        </div>
						<div class="col-xs-12 top-15" id="area"/>
					</div>
					<div class="appPanel" id="appPanel">
						<div id="appData"></div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
			<script>			
				<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiBCM"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
					<xsl:with-param name="viewerAPIPathCaps" select="$apiCaps"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathKPIs" select="$apiKpi"></xsl:with-param>  
					<xsl:with-param name="viewerAPIPathSvcs" select="$apiSvcs"></xsl:with-param> 
				</xsl:call-template>  
			</script>
			<script id="modal-template" type="text/x-handlebars-template">		
				<div class="modal-header">
				
				<h4 class="modal-title">{{{this.name}}}</h4>
				</div>
				<div class="modal-body">
					
					Codebase:{{this.codebase}}<br/>
					Delivery Method:{{this.appdelivery}}<br/>
			
				</div>
			</script>		
			<script id="model-template" type="text/x-handlebars-template">
				{{#each this}}
					<div class="capContainer bottom-30 level0" width="100%"><xsl:attribute name="easid">{{this.id}}</xsl:attribute>
						<div class="capTitleLarge bg-darkgrey smallPadding">
							<span class="right-5">{{this.name}}</span><span class="badge badge-inverse">{{this.appList.resources.length}}</span>
						</div>
							<div class="clearfix"/>
							<div class="appContainer"> 
							 
								{{#if this.appList.resources}}
								{{#each this.appList.resources}}
									<div class="app xsmall">
										<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>	
										<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
										<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
										<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
										 <xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
									<!--	<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
										<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>-->
										<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
										<div class="appTitle">{{this.name}}</div>
									</div>
								{{/each}}
								{{#ifGreater this.appList.resources 0}}
									{{#each this.diffs}}
										<div class="app xsmall pull-right">
											<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>	 
											<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute> 
											<xsl:attribute name="style">border:1pt solid #d3d3d3; background-color:#f5f5f5;</xsl:attribute>
											<xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>
											<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
											<div class="appTitle" style="color:#aaaaaa">{{this.name}}</div>
										</div>
									{{/each}}
									{{else}}
								{{/ifGreater}}
								{{else}}
								{{#each this.appList}} 
									<div class="app xsmall">
										<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>	
										<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
										<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
										<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
										 <xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
									<!--	<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
										<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>-->
										<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
										<div class="appTitle">{{this.name}}</div>
									</div>
								{{/each}}
								{{#if this.appList}}
								{{#ifGreater this.appList 0}}
								{{#each this.diffs}}
							
									<div class="app xsmall pull-right">
										<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>	 
										<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute> 
										<xsl:attribute name="style">border:1pt solid #d3d3d3; background-color:#f5f5f5;</xsl:attribute>
										<xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>
										<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
										<div class="appTitle" style="color:#aaaaaa">{{this.name}}</div>
									</div>

									{{/each}}
								{{else}}
								{{/ifGreater}}
								{{/if}}
							{{/if}}
								
							</div>
							<div class="clearfix"/>
						{{> partialTemplate}}
					</div>
				{{/each}}
			</script>				
			<script id="model-partial-template" type="text/x-handlebars-template">
				{{#each this.childrenCaps}}
					<div class="capContainer bottom-15" width="100%"><xsl:attribute name="style">background-color:{{this.colour}}</xsl:attribute>
						<div class="capTitle bg-white medPadding inline-block">
							{{#if this.appList.resources}}
							<strong class="right-5">{{this.name}}</strong><span class="badge">{{this.appList.resources.length}}</span>
							{{else}}
							<strong class="right-5">{{this.name}}</strong><span class="badge">{{this.appList.length}}</span>
							{{/if}}
						</div> 
						<div class="clearfix"/>
						<div class="appContainer">  
						 
							{{#if this.appList.resources}}
							{{#each this.appList.resources}}
							
								<div class="app xsmall">
									<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>
									<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
									<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
									 <xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
									<!--<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
									<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>
									<div>
									<xsl:attribute name="style">border-left: 5px solid;border-image:linear-gradient(to top, red, green) 1 100%;float:right:height:100%;position:relative;left:20</xsl:attribute>.</div>-->
									<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
									<div class="appTitle">{{{this.name}}}</div>
									
								</div>
							{{/each}}
							{{else}}
							{{#each this.appList}}
						   {{#if ../this.appList.resources}}
								<div class="app xsmall">
									<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>
									<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
									<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
									<xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
									<!--<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
									<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>
									<div>
									<xsl:attribute name="style">border-left: 5px solid;border-image:linear-gradient(to top, red, green) 1 100%;float:right:height:100%;position:relative;left:20</xsl:attribute>.</div>-->
									<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
									<div class="appTitle">{{{this.name}}}</div>
									
								</div> 
								{{/if}}
							{{/each}}
							{{/if}}
							{{#each this.diffs}}
									<div class="app xsmall">
										<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>	 
										<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute> 
										<xsl:attribute name="style">border:1pt solid #d3d3d3; background-color:#f5f5f5;</xsl:attribute>
										 <xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>
										<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
										<div class="appTitle" style="color:#aaaaaa">{{this.name}}</div>
									</div>
								{{/each}}
						</div>
						<div class="clearfix"/>
						{{> partialTemplate}}
						</div>
					{{/each}} 
			</script>
			<script id="model-partial-template-other" type="text/x-handlebars-template">
				{{#each this.childrenCaps}}
					<div class="capContainer bottom-15" width="100%"><xsl:attribute name="style">background-color:{{this.colour}}</xsl:attribute>
						<div class="capTitle bg-white medPadding inline-block">
							{{#if this.appList.resources}}
							<strong class="right-5">{{this.name}}</strong><span class="badge">{{this.appList.resources.length}}</span>
							{{else}}
							<strong class="right-5">{{this.name}}</strong><span class="badge">{{this.appList.length}}</span>
							{{/if}}
						</div>
						<div class="clearfix"/>
						<div class="appContainer"> 
						
							{{#if this.appList.resources}}
					 
							{{#each this.appList.resources}}
							
								<div class="app xsmall">
									<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>
									<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
									<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
									 <xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
									<!--<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
									<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>
									<div>
									<xsl:attribute name="style">border-left: 5px solid;border-image:linear-gradient(to top, red, green) 1 100%;float:right:height:100%;position:relative;left:20</xsl:attribute>.</div>-->
									<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
									<div class="appTitle">{{{this.name}}}</div>
									
								</div>
							{{/each}}
							{{else}}
							{{#each this.appList}}
						   {{#if ../this.appList.resources}}
								<div class="app xsmall">
									<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>
									<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
									<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
									<xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
									<!--<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
									<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>
									<div>
									<xsl:attribute name="style">border-left: 5px solid;border-image:linear-gradient(to top, red, green) 1 100%;float:right:height:100%;position:relative;left:20</xsl:attribute>.</div>-->
									<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
									<div class="appTitle">{{{this.name}}}</div>
									
								</div> 
								{{/if}}
							{{/each}}
							{{/if}}
							{{#each this.diffs}}
									<div class="app xsmall pull-right">
										<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>	 
										<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute> 
										<xsl:attribute name="style">border:1pt solid #d3d3d3; background-color:#f5f5f5;</xsl:attribute>
										 <xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
										 {{../this.num}}
										<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
										<div class="appTitle" style="color:#aaaaaa">{{this.name}}</div>
									</div>
								{{/each}}
						</div>
						<div class="clearfix"/>
						{{> partialTemplate}}
						</div>
					{{/each}} 
			</script>
			<script id="app-only-template" type="text/x-handlebars-template">
				<div class="app xsmall">
					<xsl:attribute name="orgids">{{#each this.orgUserIds}}{{this}} {{/each}}</xsl:attribute>
					<xsl:attribute name="style">border-bottom:3pt solid {{this.bottomColour}}</xsl:attribute>
					<xsl:attribute name="criticalityid">{{this.criticality}}</xsl:attribute>
					<xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="appcapid">{{../this.id}}{{this.id}}</xsl:attribute><xsl:attribute name="fittype">{{this.busfit}}</xsl:attribute>
					<xsl:attribute name="apptypeid">{{this.typeid}}</xsl:attribute>	
					<!--<div class="bushealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.fitcolour}};  </xsl:attribute>.</div>
					<div class="techhealth"><xsl:attribute name="style">border:1pt solid #d3d3d3;background-color: {{this.techfitcolour}};  </xsl:attribute>.</div>
					<div>
					<xsl:attribute name="style">border-left: 5px solid;border-image:linear-gradient(to top, red, green) 1 100%;float:right:height:100%;position:relative;left:20</xsl:attribute>.</div>-->
					<div class="info"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute><i class="fa fa-info-circle"><xsl:attribute name="easinfoid">{{this.id}}</xsl:attribute></i></div>
					<div class="appTitle">{{{this.name}}}</div>
					
				</div>
			</script>
			<script id="key-template" type="text/x-handlebars-template">
				<div class="keyTitle"><small>{{this.name}}:</small></div>
				  {{#each this.values}}
						<div>
							<xsl:attribute name="class">keySampleWide</xsl:attribute>
							<xsl:attribute name="style">background-color:{{this.backgroundColor}}</xsl:attribute>
						</div>
						<div>
							<xsl:attribute name="class">keySampleLabel</xsl:attribute>
							<small>{{this.name}}</small>
						</div>
				  {{/each}}
								
			</script>
			<script id="blob-template" type="text/x-handlebars-template">
				<div class="blobBoxTitle right-10"> 
					<strong>Select Level:</strong>
				</div> 
				{{#each this}}
				<div class="blobBox">
					{{#unless @last}}
					<div class="blobNum">{{this.name}}</div>
					  <div class="blob"><xsl:attribute name="id">{{this.level}}</xsl:attribute>
					<xsl:attribute name="style">{{#ifEquals this.level 1}}background-color:#d3d3d3{{else}}{{#ifEquals this.level 0}}background-color:#d3d3d3{{/ifEquals}}{{/ifEquals}}  </xsl:attribute> 
					{{/unless}}
					</div>
				</div>
				{{/each}}
				<div class="blobBox">
					<br/>
					<div class="blobNum"> 
					<!--  hover over to say that blobs are clickable to cnange level
						<i class="fa fa-info-circle levelinfo " style="font-size:10pt"> 
						</i>
					-->	 
					</div>
			
				</div>
			</script>
			<script id="sqkey-template" type="text/x-handlebars-template">
			{{#each this}}
				<div><xsl:attribute name="style">border-radius:3px;height:10px;width:20px;color:{{this.elementColour}};background-color:{{this.elementBackgroundColour}};display:inline-block</xsl:attribute></div> {{this.value}}
			{{/each}}
			</script>
			<script id="app-template" type="text/x-handlebars-template">
				<div class="row">
					<div class="col-sm-8">
						<h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>
						<!--<div class="ess-tag ess-tag-default"><i class="fa fa-money right-5"/>Cost: {{costValue}}</div>
						<div class="inline-block">{{#calcComplexity totalIntegrations capsCount processesSupporting servicesUsed.length}}{{/calcComplexity}}</div>-->
					</div>
					<div class="col-sm-4">
						<div class="text-right">
							<!--<span class="dropdown">
								<button class="btn btn-default btn-sm dropdown-toggle panelHistoryButton" data-toggle="dropdown"><i class="fa fa-clock-o right-5"/>Panel History<i class="fa fa-caret-down left-5"/></button>
								<ul class="dropdown-menu dropdown-menu-right">
									<li><a href="#">Page 1</a></li>
									<li><a href="#">Page 2</a></li>
									<li><a href="#">Page 3</a></li>
								</ul>
							</span>-->
							<i class="fa fa-times closePanelButton left-30"></i>
						</div>
						<div class="clearfix"/>
					</div>
				</div>
				
				<div class="row">
					<div class="col-sm-12">
						<ul class="nav nav-tabs ess-small-tabs">
							<li class="active"><a data-toggle="tab" href="#summary">Summary</a></li>
							<li><a data-toggle="tab" href="#capabilities"><xsl:value-of select="eas:i18n('Capabilities')"/><span class="badge dark">{{caps.length}}</span></a></li>
							<li><a data-toggle="tab" href="#processes"><xsl:value-of select="eas:i18n('Processes')"/><span class="badge dark">{{processes.length}}</span></a></li>
						<!--	<li><a data-toggle="tab" href="#integrations"><xsl:value-of select="eas:i18n('Integrations')"/><span class="badge dark">{{totalIntegrations}}</span></a></li>-->
							 <li><a data-toggle="tab" href="#services"><xsl:value-of select="eas:i18n('Services')"/></a></li>
							<li></li>
						</ul>
						
				
						<div class="tab-content">
							<div id="summary" class="tab-pane fade in active">
								<div>
									<strong><xsl:value-of select="eas:i18n('Description')"/></strong>
									<br/>
									{{description}}    
								</div>
								<div class="ess-tags-wrapper top-10">
									<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#2EB8BF;color:#ffffff</xsl:attribute>
										<i class="fa fa-code right-5"/>{{codebase}}</div>
									<div class="ess-tag ess-tag-default">
											<xsl:attribute name="style">background-color:#24A1B7;color:#ffffff</xsl:attribute>
										<i class="fa fa-desktop right-5"/>{{delivery}}</div>
									<div class="ess-tag ess-tag-default">
											<xsl:attribute name="style">background-color:#A884E9;color:#ffffff</xsl:attribute>
											<i class="fa fa-users right-5"/>{{processes.length}} <xsl:value-of select="eas:i18n('Processes Supported')"/></div>
									<div class="ess-tag ess-tag-default">
											<xsl:attribute name="style">background-color:#6849D0;color:#ffffff</xsl:attribute>
											<i class="fa fa-exchange right-5"/>{{totalIntegrations}} <xsl:value-of select="eas:i18n('Integrations')"/> ({{inI}} in / {{outI}} out)</div>
								</div>
							</div>
							<div id="capabilities" class="tab-pane fade">
								<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Capabilities')"/>:</p>
								<div>
								{{#if caps}} 
								{{#each caps}}
									<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#f5ffa1;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
								{{/each}}
								{{else}}
									<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
								{{/if}}
								</div>
							</div> 
							<div id="processes" class="tab-pane fade">
								<p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Processes, supporting')"/> {{processList.length}} <xsl:value-of select="eas:i18n('processes')"/>:</p>
								<div>
								{{#if processes}}
								{{#each processes}}
									<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</div>
								{{/each}} 
								{{else}}
									<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
								{{/if}}
								</div>
							</div>
							<div id="services" class="tab-pane fade">
								<p class="strong"><xsl:value-of select="eas:i18n('This application provide the following services, i.e. could be used')"/>:</p>
								<div>
								{{#if allServices}}
								{{#each allServices}}
									<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#c1d0db;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
								{{/each}} 
								{{else}}
									<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
								{{/if}}
							</div>
								<p class="strong"><xsl:value-of select="eas:i18n('The following services are actually used in business processes')"/>:</p>
								<div>
								{{#if services}}
								{{#each services}}
									<div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#73B9EE;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
								{{/each}} 
								{{else}}
									<p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
								{{/if}}
								</div>
							</div>
							<div id="integrations" class="tab-pane fade">
							<p class="strong"><xsl:value-of select="eas:i18n('This application has the following integrations')"/>:</p>
							<div class="row">
								<div class="col-md-6">
									<div class="impact bottom-10"><xsl:value-of select="eas:i18n('Inbound')"/></div>
										{{#each inIList}}
										<div class="ess-tag bg-lightblue-100">{{name}}</div>
										{{/each}}
								</div>
								<div class="col-md-6">
									<div class="impact bottom-10"><xsl:value-of select="eas:i18n('Outbound')"/></div>
										{{#each outIList}}
										<div class="ess-tag bg-pink-100">{{name}}</div>
										{{/each}}
								</div>
							</div>
						</div>
						 
						</div>
					</div>
				</div>
			</script>
		</html>
	</xsl:template>


	<xsl:template name="RenderViewerAPIJSFunction">
		<xsl:param name="viewerAPIPath"></xsl:param>
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		<xsl:param name="viewerAPIPathCaps"></xsl:param> 
		<xsl:param name="viewerAPIPathKPIs"></xsl:param>
		<xsl:param name="viewerAPIPathSvcs"></xsl:param>  
		  
		//a global variable that holds the data returned by an Viewer API Report
		var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';
		var viewAPIDataCaps = '<xsl:value-of select="$viewerAPIPathCaps"/>'; 
		var viewAPIDataKPIs = '<xsl:value-of select="$viewerAPIPathKPIs"/>'; 
		var viewAPIDataSvcs = '<xsl:value-of select="$viewerAPIPathSvcs"/>'; 

		$('#simps').hide();

		let filterExcludes = [<xsl:for-each select="$theReport/own_slot_value[slot_reference='report_filter_excluded_slots']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>];
	 
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200){
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
							$('#ess-data-gen-alert').hide();
						}
						
					};
					xmlhttp.onerror = function ()
					{
						reject(false);
					};
					
					xmlhttp.open("GET", apiDataSetURL, true);
					xmlhttp.send();
				} else
				{
					reject(false);
				}
			});
		}; 

	 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};
		$('.appPanel').hide();
		var appListScoped;
		var thisscopedApps=[];
		var modelData, meta;
		var busCapApps=[];
		var thisLevel=1;
		$('document').ready(function ()
		{
			$('#nokey').hide();
			modelFragment = $("#model-template").html();
			modelTemplate = Handlebars.compile(modelFragment);

			sqkeyFragment = $("#sqkey-template").html();
			sqkeyTemplate = Handlebars.compile(sqkeyFragment);
		
			templateFragment = $("#model-partial-template").html();
			partialTemplate = Handlebars.compile(templateFragment);
			Handlebars.registerPartial('partialTemplate', partialTemplate);
		
			templateOtherFragment = $("#model-partial-template-other").html();
			partialTemplateOther = Handlebars.compile(templateOtherFragment);
			Handlebars.registerPartial('partialTemplatOther', partialTemplateOther);
		
			appOnlyFragment = $("#app-only-template").html();
			appOnlyTemplate = Handlebars.compile(appOnlyFragment);

			keyFragment = $("#key-template").html();
			keyTemplate = Handlebars.compile(keyFragment);
		
			modalFragment = $("#modal-template").html();
			modalTemplate = Handlebars.compile(modalFragment);

			blobsFragment = $("#blob-template").html();
			blobTemplate = Handlebars.compile(blobsFragment);

			appFragment = $("#app-template").html();
			appTemplate = Handlebars.compile(appFragment);

			Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
		
			Handlebars.registerHelper('ifGreater', function (arg1, arg2, options) { 
				if(!arg1){arg1=0} 
				return (arg1.length &gt; arg2) ? options.fn(this) : options.inverse(this);
			});
		
			 
			Handlebars.registerHelper('inScopeApp', function (instance) {

				let thisApp = appListScoped.resources.find((e)=>{
					return e.id == instance.id;
				}) 
				if(thisApp){
					return appOnlyTemplate(instance);
				} 
			});

		

			Handlebars.registerHelper('essRenderInstanceLinkMenuOnly', function (instance, type) {
		 
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
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(237, 237, 237)">' + instance.name + '</a>';

		            return instanceLink;
		        }
			});

			Handlebars.registerHelper('essRenderInstanceLinkMenuOnlyLight', function (instance, type) {
		 
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
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(237, 237, 237)">' + instance.name + '</a>';

		            return instanceLink;
		        }
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
			
			var busCaps, pms, pmc, squals, appsList, appSvcs;
			var appToCap=[];
			var processMap=[];
			var appOrgScopingDef ;
			var geoScopingDef;
			var visibilityDef;
			var prodConceptDef;
            var scopedAppsList; 
			var busDomainDef 
			var emergencyColour=[{"id":"ec1","elementColour":"#ffffff","elementBackgroundColour":"#ff0000"},{"id":"ec2","elementColour":"#000000","elementBackgroundColour":"#ffa700"},{"id":"ec3","elementColour":"#000000","elementBackgroundColour":"#fff400"},{"id":"ec4","elementColour":"#000000","elementBackgroundColour":"#a3ff00"},{"id":"ec5","elementColour":"#000000","elementBackgroundColour":"#2cba00"},{"id":"ec5","elementColour":"#000000","elementBackgroundColour":"#cff27e"},{"id":"ec6","elementColour":"#000000","elementBackgroundColour":"#f2dd6e"},{"id":"ec7","elementColour":"#000000","elementBackgroundColour":"#e5b25d"},{"id":"ec8","elementColour":"#000000","elementBackgroundColour":"#a3ff00"},{"id":"ec9","elementColour":"#000000","elementBackgroundColour":"#b87d4b"},{"id":"ec10","elementColour":"#000000","elementBackgroundColour":"#523a34"}] 
			$('.appPanel').hide();

			emergencyColour.forEach((c)=>{
				$("&lt;style type='text/css'> ."+c.id+"{ color:"+c.elementColour+"; background-color:"+c.elementBackgroundColour+"} &lt;/style>").appendTo("head");
				})
			 
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataApps),
			promise_loadViewerAPIData(viewAPIDataCaps), 
	 		promise_loadViewerAPIData(viewAPIDataKPIs), 
	 		promise_loadViewerAPIData(viewAPIDataSvcs)
			]).then(function (responses)
			{
            $('#enumKey').hide();
			appsList=responses[1]
			meta=responses[1].meta
			squals=responses[3].serviceQualities; 

			let codebase=responses[1].codebase;
			let	delivery=responses[1].delivery;
			let	lifecycles=responses[1].lifecycles;
			
			responses[1].applications.forEach((d)=>{
                    d['bottomColour']='#e3e3e3';
					let thisCode=codebase.find((e)=>{
						return e.id == d.codebaseID
					});
		
					if(d.codebaseID.length&gt;0){
					d['codebase']=thisCode.shortname;
					d['codebaseColor']=thisCode.colour;
					d['codebaseText']=thisCode.colourText;
					}
					else
					{
						d['codebase']="Not Set";
						d['codebaseColor']="#d3d3d3";
						d['codebaseText']="#000";
					}
				
				
					let thisLife=lifecycles.find((e)=>{
						return e.id == d.lifecycle_status_application_provider[0];
					})
					if(d.lifecycle_status_application_provider[0]){
						 
						d['lifecycle']=thisLife?.shortname;
						d['lifecycleColor']=thisLife?.colour;
						d['lifecycleText']=thisLife?.colourText;
					}
					else
					{
						d['lifecycle']="Not Set";
						d['lifecycleColor']="#d3d3d3";
						d['lifecycleText']="#000";
					}

					let thisDelivery=delivery.find((e)=>{
						return e.id == d.deliveryID;
					});
					if(d.deliveryID.length&gt;0){
						d['delivery']=thisDelivery.shortname;
						d['deliveryColor']=thisDelivery.colour;
						d['deliveryText']=thisDelivery.colourText;
						}
						else
						{
							d['delivery']="Not Set";
							d['deliveryColor']="#d3d3d3";
							d['deliveryText']="#000";
						}	
					
						d.orgUserIds = d.orgUserIds.filter((elem, index, self) => self.findIndex( (t) => {return (t === elem)}) === index)

						d.realises_application_capabilities = d.allServices.flatMap(s => s.capabilities);
				 });
			appSvcs=responses[4];
			pmc=responses[3].perfCategory;
			pms=responses[3].applications;
			pms.forEach((d) => {
				const updateCategoryId = (item) => {
					if (!item.categoryid &amp;&amp; item.serviceQuals?.[0]) {
						item.categoryid = item.serviceQuals[0].categoryId;
					}
				};
			
				d.perfMeasures?.forEach(updateCategoryId);
			
				d.processPerfMeasures?.forEach((p) => {
					p.scores?.forEach(updateCategoryId);
				});
			});
			
		 
			filters=responses[1].filters;
			capfilters=responses[0].filters;
 
			$("#enum-selection").append('&lt;option easid="None">None&lt;/option>'); 
			for(i=0;i&lt;filters.length;i++){ 
					$("#enum-selection").append(new Option(filters[i].name, filters[i].id));
			}	 
			$("#enum-selection").select2();
			
			responses[1].filters.sort((a, b) => (a.id > b.id) ? 1 : -1) 
			dynamicAppFilterDefs=filters?.map(function(filterdef){
				return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
			});

			dynamicCapFilterDefs=capfilters?.map(function(filterdef){
				return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
			});

			responses[0].busCaptoAppDetails.forEach((bc) => {
				const capArr = responses[2].businessCapabilities.find((e) => e.id === bc.id);
			
				if (capArr) {
					bc.order = parseInt(capArr.sequenceNumber, 10); // Explicit base for parseInt
				}
			
				bc.processes.forEach((bp) => {
					bp.physP.forEach((pbp) => {
						processMap.push({ pbpId: pbp, pr: bp.name, prId: bp.id });
					});
			
					appToCap.push({ procId: bp.id, bc: bc.name, bcId: bc.id });
				});
			});
			
		
			appsList.applications.forEach((app)=>{
			 
				let procsForApp =[]; 
				let capforApp=[];
				app.physP.forEach((pp)=>{  
				 processMap.forEach((php)=>{
				 
					if(php.pbpId ==pp)
					{
						procsForApp.push({"id":php.prId,"name":php.pr})
						let cap=appToCap.filter((ac)=>{
							return ac.procId ==php.prId;
						});
						if(cap.length &gt;0){
					 
							cap.forEach((cp)=>{
								capforApp.push({"id":cp.bcId,"name":cp.bc})
							})
						
						}
					};
				});
				let uniqueProcs=procsForApp.filter((elem, index, self) => self.findIndex( (t)=>{return (t.id === elem.id)}) === index)
				let uniqueCaps=capforApp.filter((elem, index, self) => self.findIndex( (t)=>{return (t.id === elem.id)}) === index)
				 
				app['processes']=uniqueProcs;
				app['caps']=uniqueCaps;
			});

				let thisPerfMeasures=pms.find((e)=>{
					return e.id==app.id;
				});
				if(thisPerfMeasures){
					app['pm']=thisPerfMeasures.perfMeasures;
					app['bpm']=thisPerfMeasures.processPerfMeasures;
				}
				
			})
		


				 busCaps=responses[0].busCapHierarchy;
				 busCapApps =responses[0].busCaptoAppDetails;
 
				busCaps.forEach(function(d){					 
					getKids(d, appsList)
					})
 
				var treeDepth=0;
				busCaps.forEach(function(d,i){
					if(getDepth(busCaps[i])&gt; treeDepth){
						treeDepth=getDepth(busCaps[i]);
						}
				});

				$("#level-selection").empty();
				$("#level-selection").append('&lt;option easid="All">All&lt;/option>');
				let levelData=[];
				for(i=0;i&lt;treeDepth+1;i++){
						$("#level-selection").append(new Option("Level "+(i+1), i));
						levelData.push({"id":i,"level":i, "name":i+1})
				}	

				$('#retired').on('change',function(){
			 		redrawView()
				})

				$('#levelsbox').html(blobTemplate(levelData))
				$("#measure-selection").empty();
				$("#measure-selection").append('&lt;option easid="None">None&lt;/option>'); 
				for(i=0;i&lt;responses[3].perfCategory.length;i++){ 
						$("#measure-selection").append(new Option(responses[3].perfCategory[i].name, responses[3].perfCategory[i].id));
				}	 
				$("#measure-selection").select2();

				modelData=busCaps; 
				$('.blob').on('click',function(){
					thisLevel=$(this).attr('id')
					$('.blob').css('background-color','#ffffff');
					for(i=0;i&lt;thisLevel;i++){
					$('#'+i).css('background-color','#d3d3d3');
					}
					$(this).css('background-color','#b1bbc9');
					redrawScope()
				})

				$("#measure-selection").change(function(){
					redrawScope()
				})
                $("#enum-selection").change(function(){
                    $('#enumKey').slideUp();
                    redrawScope()

                })

				$("[name='appProcessSwitch']").change(function(){
					redrawScope()
				})


				$('#helpMe').on('click', function(){	 
					$('#helpModal').modal('show');
				})

				$('#level-selection').change(function(){
					redrawScope();
				});

				let allFilters=[...responses[0].filters, ...responses[1].filters];

				filterExcludes.forEach((e)=>{
					allFilters=allFilters.filter((f)=>{
						return f.slotName !=e;
					})
				 }) 
 

				hardClasses=[{"class":"Group_Actor", "slot":"stakeholders"},
				{"class":"Geographic_Region", "slot":"ap_site_access"},
				{"class":"SYS_CONTENT_APPROVAL_STATUS", "slot":"system_content_quality_status"},
				{"class":"Product_Concept", "slot":"product_concept_supported_by_capability"},
				{"class":"Business_Domain", "slot":"belongs_to_business_domain"},
				{"class":"ACTOR_TO_ROLE_RELATION", "slot":"act_to_role_to_role"},
				{"class":"Managed_Service", "slot":"ms_managed_app_elements'"},
				{"class":"Application_Capability", "slot":"realises_application_capabilities"}]

				hardClasses = hardClasses.filter(item => 
					!filterExcludes.some(exclude => item.slot.includes(exclude))
				);

			let classesToShow = hardClasses.map(item => item.class);
			 
			essInitViewScoping	(redrawView, classesToShow, allFilters, true);
			}). catch (function (error)
			{
				//display an error somewhere on the page
			});
		getDepth = function (obj) {
				var depth = 0;
				if (obj.childrenCaps) {
					obj.childrenCaps.forEach(function (d) {
						var tmpDepth = getDepth(d)
						if (tmpDepth > depth) {
							depth = tmpDepth;
						}
					})
				}
				return 1 + depth
			};

var appTypeInfo = {
		"className": "Application_Provider",
		"label": 'Application',
		"icon": 'fa-desktop'
}
var busCapTypeInfo = {
	"className": "Business_Capability",
	"label": 'Business Capability',
	"icon": 'fa-landmark'
}

function getChildrenToShow(dataSet,level){
 
	
	var childrenArray=[];
	dataSet.forEach(function(d){ 
	 if(d.level &lt; level+1){
	
		  let thisAllArray = d.allApps.filter(appB => {
              return scopedAppsList.resources.some(appA => appA.id === appB.id);
            });

            thisscopedApps['resources']=thisAllArray

		thisscopedApps.resources=thisscopedApps.resources?.sort((a, b) => a.name.localeCompare(b.name))
		let newAppList=[] 
		d.appList.forEach((e)=>{
			let mapApp=thisscopedApps.resources.find((g)=>{
				return e.id==g.id;
			})
			if(mapApp){
			newAppList.push(mapApp)
			}
		})

		newAppList=newAppList.sort((a, b) => a.name.localeCompare(b.name))

		newAppList={"resources":newAppList};
	 
		if(d.level == lev){ 
			let diff=getDifference(d.appList, thisscopedApps.resources,  d.name, 4);
			let diffArr=[]; 
	 
			diff.forEach((f)=>{
				let match =thisscopedApps.resources.find((g)=>{
					return g.id==f.id
				})
				if(match){}else{
					diffArr.push(f)
					}
				 
			}) 
	 
			childrenArray.push({"id": d.id,"name": d.name,"link": d.link,"description": d.description,"level": d.level,"apps": d.apps,"appList": newAppList, "thisAppList": d.appList, "colour": d.colour,"childrenCaps":getChildrenToShow(d.childrenCaps,level), "level":level, "diffs":diffArr, "num":4,  "allApps":d.allApps});
			 
		}
		else{
		  let thisAllArray = d.allApps.filter(appB => {
              return scopedAppsList.resources.some(appA => appA.id === appB.id);
            });

            thisscopedApps['resources']=thisAllArray


			thisscopedApps.resources=thisscopedApps.resources?.sort((a, b) => a.name.localeCompare(b.name))
			let newAppList=[] 
			d.appList.forEach((e)=>{
				let mapApp=thisscopedApps.resources?.find((g)=>{
					return e.id==g.id;
				})
				if(mapApp){
				newAppList.push(mapApp)
				}
			})
			
			newAppList=newAppList.sort((a, b) => a.name.localeCompare(b.name))
	
			newAppList={"resources":newAppList};
 
			let diff=getDifference(d.allApps, thisscopedApps.resources,  d.name, 5);
			let diffArr=[];  
			diff.forEach((f)=>{
				let match =d.appList.find((g)=>{
					return g.id==f.id
				})
				if(match){}else{
					diffArr.push(f)
					}
				 
			});
 
			if(diffArr.length==0 &amp;&amp; newAppList.resources.length==0){
				diffArr=d.thisappList
			}


  if(d.thisappList.length&gt;0){
		 	
// if no children caps get retired apps

	if(d.childrenCaps.length==0){

		
		let diffNotLeaf=getDifference(d.allApps, thisscopedApps.resources,  d.name, 6);
	 
			let diffArrNotLeaf=[];  
			diffNotLeaf.forEach((f)=>{
				let match =d.thisappList.find((g)=>{
					return g.id==f.id
				})
			
				if(match){}else{
					diffArrNotLeaf.push(f)
					}
				 
			});
	 
		childrenArray.push({"id": d.id,"name": d.name,"link": d.link,"description": d.description,"level": d.level,"apps": d.apps,"appList": newAppList, "thisAppList": d.appList, "colour": d.colour,"childrenCaps":getChildrenToShow(d.childrenCaps,level), "level":level,  "diffs":diffNotLeaf, "num":6, "allApps":d.allApps});
	}
	else{
		childrenArray.push({"id": d.id,"name": d.name,"link": d.link,"description": d.description,"level": d.level,"apps": d.apps,"appList": newAppList, "thisAppList": d.appList, "colour": d.colour,"childrenCaps":getChildrenToShow(d.childrenCaps,level), "level":level,  "diffs":diffArr, "num":5, "allApps":d.allApps});
	
	}
	
			
  }else{
	childrenArray.push({"id": d.id,"name": d.name,"link": d.link,"description": d.description,"level": d.level,"apps": d.apps,"appList": [], "thisAppList": [], "colour": d.colour,"childrenCaps":getChildrenToShow(d.childrenCaps,level), "level":level,  "diffs":diffArr, "num":51, "allApps":d.allApps});
  }
		}
		 
		}
	});				
	 
	return childrenArray;		 
	}

function getDifference(array1, array2, num, id) { 

	if(array1.resources){
		array1=array1.resources;
	}

	
		if(array1){
			if(array2){
				return array1.filter(object1 => {
				return !array2.some(object2 => {
					return object1.id === object2.id;
				}); 
				});
			}
		}
		else{
			return [];
		}
	  }

function getKids(mod, appsList){
	 
	let thisAppArr=[];
	let thisApps =busCapApps.find((bc)=>{
		return bc.id==mod.id;
	}) 
 
	if(thisApps){

	let allAppList=[];	
	let appList=[];	
	<!-- get all apps for this cap and its children -->
	thisApps.apps.forEach((e)=>{
		let appDetail=appsList.applications.find((f)=>{
			return f.id==e;
		});
		allAppList.push(appDetail);
	});

	<!-- get all apps for this cap only -->
	thisApps.thisapps.forEach((e)=>{
		let appDetail=appsList.applications.find((f)=>{
			return f.id==e;
		});
		appList.push(appDetail);
	}); 

	allAppList=allAppList.sort((a, b) => a.name.localeCompare(b.name))
	mod['appList']=allAppList;
	mod['thisappList']=appList; 
	mod['appsforCap']=thisApps.thisapps;	 
	mod['allApps']=allAppList;
 
	}

	mod.childrenCaps.forEach(function(cap){
		<!--
			Javascript to get children apps - handled in API now
		-->
		let thisApps =busCapApps.find((bc)=>{
			return bc.id==cap.id;
		});
	 <!--
		if(thisApps){ 
	//Only needed if recursivey gathering apps and children
		thisAppArr=[...thisAppArr, ...thisApps.apps]
		thisAppArr = [...new Set(thisAppArr)]; 

		//cap['thisApps']=thisApps.apps;
		}
		--> 
		getKids(cap, appsList);
		
		});	
 
}						
var lev;		 
var redrawView=function(){
	console.log('redraw')
	workingCapId=0;

	appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
	prodConceptDef = new ScopingProperty('prodConIds', 'Product_Concept');
	busDomainDef = new ScopingProperty('domainIds', 'Business_Domain');
	let a2rDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION');
	let msDef = new ScopingProperty('ms_managed_app_elements', 'Managed_Service');
	let acDef = new ScopingProperty('realises_application_capabilities', 'Application_Capability');
	
	essResetRMChanges();
	
	scopedCaps = essScopeResources(busCapApps, [appOrgScopingDef, geoScopingDef, visibilityDef,prodConceptDef, busDomainDef].concat(dynamicCapFilterDefs), busCapTypeInfo);
    scopedAppsList= essScopeResources(appsList.applications, [appOrgScopingDef, geoScopingDef, visibilityDef,a2rDef, msDef, acDef].concat(dynamicAppFilterDefs), appTypeInfo);

	let scopedApps;
	let scopedCapsIds=scopedCaps.resourceIds
	lev=thisLevel;
	let thisSelected=$('#enum-selection').val();

	if(thisSelected=='None'){
		//do nothing
	}else{
		$('#enumKey').slideDown()
	}
                        
let thisFilter=filters.find((f)=>{
    return f.id ==thisSelected;
})

$('#enumKey').html(keyTemplate(thisFilter))

        showArray=[]	

        if(lev=='All'){
            showArray=busCaps;
        }
        else
        {
        busCaps.forEach(function(d){
            let inScopeTest=scopedCapsIds.find((c)=>{
                return c==d.id;
            })
            if(inScopeTest){
            var thisArrChildren=[];
            var thisHLApps;
            let filtereappsList= d.appList;
            if($('#retired').is(":checked")==false){
                filtereappsList= d.appList.filter((d)=>{
                    return d.lifecycle != "Retired";
                })
            }
            let newfilteredAppArray = filtereappsList.filter(appB => {
              return scopedAppsList.resources.some(appA => appA.id === appB.id);
            });

            appListScoped=newfilteredAppArray

        if(lev==0){
            scopedApps =appListScoped
            
			scopedApps['resources']=scopedApps
			thisHLApps=scopedApps.resources; 
			scopedApps.resources.forEach((d)=>{

				if(thisFilter){
						 let thisColour=d[thisFilter.slotName];
						 let selectedColour=thisFilter.values.find((c)=>{
							 return c.id==thisColour[0]
						 }) 
						 if(selectedColour){ 
							d.bottomColour=selectedColour.backgroundColor;
						 }else{
							d.bottomColour= '#e3e3e3';
						 }
						}else{
							d.bottomColour= '#e3e3e3';
						}
					})
        }
		
            
        if(d.level &lt; (lev)){

            d.childrenCaps.forEach(function(e){	 

                let inScopeTest=scopedCapsIds.find((c)=>{
                    return c==e.id;
                })
                if(inScopeTest){ 
                var thisApps; 

                if(e.level == lev){
                    let subfiltereappsList=e.appList;
                    if($('#retired').is(":checked")==false){
                        subfiltereappsList= e.appList.filter((d)=>{
                            return d.lifecycle != "Retired";
                        })
                    }

                    let newsubfilteredAppArray = subfiltereappsList.filter(appB => {
                      return scopedAppsList.resources.some(appA => appA.id === appB.id);
                    });
        
                   let scopedApps=[];
                    scopedApps['resources'] = newsubfilteredAppArray;
                    scopedApps.resources.forEach((d)=>{

						if(thisFilter){
								 let thisColour=d[thisFilter.slotName];
								 let selectedColour=thisFilter.values.find((c)=>{
									 return c.id==thisColour[0]
								 }) 
								 if(selectedColour){ 
									d.bottomColour=selectedColour.backgroundColor;
								 }else{
									d.bottomColour= '#e3e3e3';
								 }
								}else{
									d.bottomColour= '#e3e3e3';
								}
							})             
									scopedApps.resources=scopedApps.resources.sort((a, b) => a.name.localeCompare(b.name))
									let diff=getDifference(subfiltereappsList, scopedApps.resources, e.name,1);
								
										let diffArr=[]; 
										if(diff){
											diff.forEach((f)=>{
												let match =scopedApps.resources.find((g)=>{
													return g.id==f.id
												})
												if(match){}else{
													diffArr.push(f)
													}
												
											})		
										}		 
										 
									thisArrChildren.push({"id": e.id,"name": e.name,"link":e.link,"thisappList":e.appList,"appList":scopedApps,"colour":"#ddd","role":2,"level": e.level, "allApps":e.allApps, "childrenCaps":getChildrenToShow(e.childrenCaps,lev), "diffs": diffArr,"num":1 });
									}else{
										let subfiltereappsList= e.thisappList
										if($('#retired').is(":checked")==false){
											subfiltereappsList= e.thisappList.filter((d)=>{
												return d.lifecycle != "Retired";
											})
										}
                                let newAppList = e.thisappList.filter(appB => {
                                    return scopedAppsList.resources.some(appA => appA.id === appB.id);
                                });
								scopedApps = newAppList;
                                scopedApps.resources?.forEach((d)=>{

									if(thisFilter){
												let thisColour=d[thisFilter.slotName];
												let selectedColour=thisFilter.values.find((c)=>{
													return c.id==thisColour[0]
												}) 
												if(selectedColour){ 
												d.bottomColour=selectedColour.backgroundColor;
												}else{
												d.bottomColour= '#e3e3e3';
												}
											}else{
												d.bottomColour= '#e3e3e3';
											}
										})

								scopedApps.resources=scopedApps.resources?.sort((a, b) => a.name.localeCompare(b.name))
								let diff=getDifference(subfiltereappsList, scopedApps.resources,  e.name, 2);
							 
								let diffArr=[]; 
								if(diff){
									diff.forEach((f)=>{
										let match =d.thisappList.find((g)=>{
											return g.id==f.id
										})
										if(match){}else{
											diffArr.push(f)
											}
										
									})	
								}
							
									thisArrChildren.push({"id": e.id,"name": e.name,"link":e.link,"thisappList":e.appList,"appList":scopedApps,"colour":"#ddd","role":2,"level": e.level, "allApps":e.allApps,
									"childrenCaps":getChildrenToShow(e.childrenCaps,lev),  "diffs":diffArr,"num":2});
 
									}
									
								}
							})
						 
						} 

						let filterApps=d.appList

						if($('#retired').is(":checked")==false){
							filterApps= d.appList.filter((d)=>{
								return d.lifecycle != "Retired";
							})
						}

						let diff=getDifference(filterApps,appListScoped,  d.name, 3);
 
								let diffArr=[]; 
							if(diff){
								diff.forEach((f)=>{
									let match =appListScoped.find((g)=>{
										return g.id==f.id
									})
									if(match){}else{
										diffArr.push(f)
										}
									
								})
							}	
								 
						showArray.push({"id": d.id,"name": d.name,"link": d.link,"description": d.description,"level": d.level,"thisappList": d.appList,"appList":thisHLApps,"colour": d.colour,"childrenCaps":thisArrChildren, "role":"l1","diffs":diffArr, "allApps":d.allApps, "num":3});
					 
						}
					});
				 
				};
			 
				modelData=showArray; 
	<!-- set colours-->  
	$('#area').empty();

		   $('#area').html(modelTemplate(modelData));
		
 
	var measure=$('#measure-selection').children(":selected").val();

	let selectedMeasure=pmc.find((e)=>{
		return e.id==measure
	});

	$('.app').attr('class', 'app xsmall');

	if(measure=='None'){
		$('#sqkey').hide()
		$('#simps').hide()
		$("#switch").hide();
	}
	else{
	let keyData=squals.find((sq)=>{
		return sq.id==selectedMeasure.qualities[0]
	});
 
	if(keyData){
	keyData.sqvs.forEach((k)=>{
		if(k.elementBackgroundColour==''){
		 
			if(k.score){
			k.elementBackgroundColour=emergencyColour[k.score-1].elementBackgroundColour;
			if(k.elementBackgroundColour.length&gt;7){
				k.elementBackgroundColour=k.elementBackgroundColour.substring(0,7)
			}
			k.elementColour=emergencyColour[k.score-1].elementColour;
			}else{
				k.elementBackgroundColour='#d3d3d3';
				k.elementColour='#000000';
			}
		}
	})
	keyData.sqvs=keyData.sqvs.sort((a, b) => (parseInt(a.score) > parseInt(b.score)) ? 1 : -1);
 
	$('#sqkey').show()
	$('#noKey').hide();
	$('#sqkey').html(sqkeyTemplate(keyData.sqvs));
	keyData.sqvs.forEach((c,i)=>{
			$("&lt;style type='text/css'> ."+c.id+"{ color:"+c.elementColour+"; background-color:"+c.elementBackgroundColour+"} &lt;/style>").appendTo("head");
	})
}else{
	$('#sqkey').hide();
	$('#noKey').css('display','block')
}
   
	let viaProcess=0;		
		appsList.applications.forEach((app)=>{ 
			let thisPerfMeasures=app.pm?.filter((e)=>{ 
				return e.categoryid.includes(measure)
				//return e.categoryid==measure;
			}); 	
		
			let processPerfMeasures
	if(thisPerfMeasures){			
			thisPerfMeasures.sort((a, b) => (a.date &lt; b.date) ? 1 : -1) 
			
			let inScopePMs=[];
		 
			if(app.bpm.length&gt;0){
			app.bpm.forEach((pr)=>{ 
			 
				processPerfMeasures=pr.scores.filter((e)=>{ 
					return e.categoryid.includes(measure)
					//return e.categoryid==measure;
				});
 
				let ppms=[];
				processPerfMeasures.forEach((p)=>{
					p['procId']=pr.proid; 
					let bcMap= busCapApps.filter((e)=>{ 
						if(e.physP){
							return e.physP.includes(pr.proid)
						}
					})
 
					if(bcMap){ 
						p['busCapId']=bcMap.id;
						bcMap.forEach((c)=>{
							let tempP={'busCapId':c.id,
								'categoryid':p.categoryid,
								'date':p.date,
								'id':p.id,
								'procId':p.procId,
								'serviceQuals':p.serviceQuals} 
							ppms.push(tempP)
						})
					}
				})
 

				inScopePMs=[...inScopePMs, ...ppms, ...processPerfMeasures];
				  
			});
		}

 
let capAppsScores =d3.nest()
	.key(function(d) { return d.busCapId; }) 
	.key(function(d) { return d.procId; })
	.entries(inScopePMs); 

capAppsScores.forEach((d,i)=>{
	 
<!--	if(i==1){
		$('#measure-selection').append($('<option>', {
		value: 1,
		text: 'My option'
		}));
	}-->
	let tot=0;
	let totalScore=[];
	d.values.forEach((e)=>{
		e.values.forEach((f)=>{
			let qualVals =d3.nest()
					.key(function(d) { return d.serviceName; })  
					.entries(f.serviceQuals);
					qualVals['date']=f.date; 
			totalScore=[...totalScore, ...qualVals[0].values]
		});
	 
		totalScore.forEach((ts)=>{
			tot=tot+parseInt(ts.score);
		}); 
	})
	tot=tot/totalScore.length; 
	d['bcScore']=Math.round(tot);
	viaProcess=1;
});
 
app['capsScore']=capAppsScores;
			app['score']=0;

	var selectedValue = $("input[name='appProcessSwitch']:checked").val();

    // You can print the selected value to verify
	if(viaProcess==1){
		$('#simps').show(); 
		$("#switch").show();
	}
	else{
		$('#simps').hide();
		$("#switch").hide();
	}
 
if(selectedValue=='viaProcess'){ 
	
	if(processPerfMeasures?.length&gt;0){
		let appscore=0
		processPerfMeasures[0].serviceQuals.forEach((e)=>{
			appscore=appscore+parseInt(e.score)
		});

	app['score']=appscore / processPerfMeasures[0].serviceQuals.length;
	app['thisQuals']=processPerfMeasures[0].serviceQuals;

	}

}
else{ 
 	
	if(thisPerfMeasures?.length&gt;0){
		let appscore=0
		thisPerfMeasures[0].serviceQuals.forEach((e)=>{
			appscore=appscore+parseInt(e.score)
		});

	app['score']=appscore / thisPerfMeasures[0].serviceQuals.length;
	app['thisQuals']=thisPerfMeasures[0].serviceQuals;

	}

}


			

			let thisColours=keyData?.sqvs.find((d)=>{
				return d.score == Math.round(app.score);
			});
		   
			if ($('#viaProcess').is(':checked')) {
		
				if (thisColours) {    
					
						app.capsScore.forEach((c) => {
							if(c.key=='store_55_Class13'){
							}
							let cpID = c.key + app.id;
							$('.app[appcapid="' + cpID + '"]').addClass(thisColours.id)
						})
					}
					else{
						 
						let thisColourID = 'ec' + Math.round(app.score);
			
						app.capsScore.forEach((c) => {
							let thisColourID = 'ec' + Math.round(c.bcScore);
							let cpID = c.key + app.id;
							$('.app[appcapid="' + cpID + '"]').addClass(thisColourID)
						}) 
					}
				
			} else { 
				if (thisColours) { 
					$('.app[easid="' + app.id + '"]').addClass(thisColours.id)
				} else {
					let thisColourID = 'ec' + Math.round(app.score);
					$('.app[easid="' + app.id + '"]').addClass(thisColourID)
			
				}
			} 
		}
			})
			}

		   $('.info').click(function(){
			let thisi=$(this).attr("easinfoid");
			let appToShow=appsList.applications.find((d)=>{
				return d.id==thisi;
			});
 
			appToShow.allServices = appToShow.allServices.filter((elem, index, self) => self.findIndex(
				(t) => {return (t.id === elem.id)}) === index);		

			appToShow.allServices.forEach((e)=>{
						 
				appSvcs.application_services.forEach((sv)=>{
					let match = sv.aprs.find((f)=>{
						 
						return f == e.id	
					})
				 if(match){
					e['name']=sv.name	 
					 }
				});
			});
			
 
		   $('#appData').html(appTemplate(appToShow));
		   $('.appPanel').show( "blind",  { direction: 'down', mode: 'show' },500 );
		   $('.closePanelButton').on('click',function(){ 
				$('.appPanel').hide();
			})

		   })		 
         
	}


function redrawScope() {
	essRefreshScopingValues()
}
});
 
$('.closePanel').slideDown();

function toggleMiniPanel(element){
	$(element).parent().parent().nextAll('.mini-details').slideToggle();
	$(element).toggleClass('fa-caret-right');
	$(element).toggleClass('fa-caret-down');
};

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
