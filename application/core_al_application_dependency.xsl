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

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider', 'Application_Provider_Interface', 'Information_View', 'Information_Representation')"/>
	<xsl:variable name="apiPathDataAppDeps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Dependencies']"/>
	<xsl:variable name="apiPathDataAppMart" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="containingApps" select="/node()/simple_instance[type=('Composite_Application_Provider', 'Application_Provider')][count(own_slot_value[slot_reference='contained_application_providers']/value)&gt;0]"/>
 
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
		<xsl:variable name="apiPathDeps">
			<xsl:call-template name="GetViewerAPIPath">
				<xsl:with-param name="apiReport" select="$apiPathDataAppDeps"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="apiPathMart">
				<xsl:call-template name="RenderAPILinkText">
						<xsl:with-param name="theXSL" select="$apiPathDataAppMart/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
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
				<title>Application Dependency Model</title>
				<script src="js/d3/d3.v5.7.0.min.js"/>
                <script src="js/dagre/dagre.min.js"></script>
                <script src="js/dagre/dagre-d3.min.js"></script>
			<style>
				.lineClick {
					cursor: pointer;
					}

				.node {
					cursor: pointer;
				}
				
				
				.node-rect-closed {
					stroke-width: 2px;
					stroke: rgb(0,0,0);
				}
				
				.link {
					fill: none;
					stroke: lightsteelblue;
					stroke-width: 2px;
				}
				
				.linkselected {
					fill: none;
					stroke: tomato;
					stroke-width: 2px;
				}
				
				.arrow {
					fill: lightsteelblue;
					stroke-width: 1px;
				}
				
				.arrowselected {
					fill: tomato;
					stroke-width: 2px;
				}
				
				.link text {
					font: 9px sans-serif;
					fill: #CC0000;
				}
				
				.wordwrap {
					white-space: pre-wrap; /* CSS3 */
					white-space: -moz-pre-wrap; /* Firefox */
					white-space: -pre-wrap; /* Opera &lt;7 */
					white-space: -o-pre-wrap; /* Opera 7 */
					word-wrap: break-word; /* IE */
				}
				
				.node-text {
					font: 8px sans-serif;
					color: white;
				}
				
				
				.tooltip-text-container {
					height: 100%;
					width: 100%;
				}
				
				.tooltip-text {
					visibility: hidden;
					font: 7px sans-serif;
					color: white;
					display: block;
					padding: 5px;
				}
				
				.tooltip-box {
					background: rgba(0, 0, 0, 0.7);
					visibility: hidden;
					position: absolute;
					border-style: solid;
					border-width: 1px;
					border-color: black;
					border-top-right-radius: 0.5em;
				}
				
				p {
					display: inline;
				}
				
				.textcolored {
					color: orange;
				}
				
				a.exchangeName {
					color: orange;
				}
				
				.node-rect {
					border-radius: 5px;
					border-style: solid;
					border-width: 1px;
					border-color: #666;
					padding: 3px 5px 3px 3px;
				}
				
				.node-title {
					width: 100%;
					height: 30px;
					margin: 0px 0px 0px 0px;
				}
				
				.node-body-icon {
					<!--width: 30%;-->
					height: 20px;
					float: left;
					color: #666;
					font-family: FontAwesome;
					font-size: 1em;
					//margin: 0px 5px 0px 0px;
					//padding-left: 5px;
					padding-top: 0px;
					vertical-align: top;
				}
				
				.node-body {
					width: 70%;
					height: 65px;
					float: left;
					margin: 0px 0px 0px 0px;
				}
				
				.node-body-content {
					width: 100%;
					height: 40px;
					margin: 0px 0px 0px 0px;
					float: right;
				}
				
				.node-body-footer {
					width: 100%;
					height: 10px;
					margin: 0px 0px 0px 0px;
					float: right;
					text-align: right;
					font-size: 1em;
					padding-right: 3px;
				}
				
				.node-title-text {
					font-size: 14px;
					line-height: 1.1em;
					font-weight: bold;
					color: white;
				}
				
				.node-body-heading {
					font-size: 12px;
					font-weight: bold;
					color: white;
					margin-top: 10px;
					line-height: 1.1em;
				}
				
				.node-body-text {
					font-size: 10px;
					color: white;
					margin-top: 1px;
				}
				
				.node-title-text a {
					color: #000;
					font-size: 12px;
					font-weight: 600;
				}
				
				.node-body-text a {
					color: white;
				}
				
				.legend-icon {
					width: 25px;
					height: 25px;
				}
				
				.png-icon {
					font-size: 1.5em;
				}
				
				td.details-control::after {
					content: "\f0da";
					font-family:'FontAwesome';
					cursor: pointer;
					font-size: 150%;
				}
				tr.shown td.details-control::after {
					content: "\f0d7";
					font-family:'FontAwesome';
					cursor: pointer;
					font-size: 150%;
				}
				tr.shown + tr > td{
					background-color: #f6f6f6;
					padding: 10px;
					font-size: 90%;						
				}
				.details {
					border: 1px solid #ccc;
					padding: 10px;
					background-color: #fff;
				}
				#tree-scroller {
					background-color: #fafafa;
					width: 100%;
					height: 400px;
					overflow: scroll;
					border: 1px solid #ccc;
					padding: 5px;
				}
				.textColourRed > a {
					color: #ba2401;
				}
				.ess-tag-dotted {
					border: 2px dashed #222;
				}
				
				.ess-tag-dotted > a{
					color: #333!important;
				}
				
				.ess-tag-default {
					background-color: #fff;
					color: #333;
					border: 2px solid #222;
				}
				
				.ess-tag-default > a{
					color: #333!important;
				}
				
				.ess-tag {
					padding: 3px 12px;
					border-radius: 16px;
					margin-right: 10px;
					margin-bottom: 5px;
					display: inline-block;
					font-weight: 700;
					
				}
				.ess-tag-key {
					padding: 3px 12px;
					border-radius: 16px;
					margin-right: 10px;
					margin-bottom: 5px;
					display: inline-block;
					font-weight: 700;
					
				}
				
				.hubApp {
				background-color:#47bac1;
					border-radius:4px; 
					padding:5px;
					position: relative;
					border:1px solid #ccc;
					border-bottom:1px solid #999;
				}

				.hubAppModule{
					background-color:#88dce1;
					border-radius:4px; 
					padding:5px;
					position: relative;
					border:8px solid #47bac1; 
				}
				
				.hubApp a,.hubApp i {
					color: #fff;
				}
				
				.appBox a {
					color: #333;
				}
				 
				
				.apiBox i {
					color: #c3193c;
				}
				
				.hubApp div {
					writing-mode: vertical-rl;
					transform: rotate(-180deg);
					position: relative;
					font-size: 18px;
					padding-right: 32px;
					padding-bottom: 16px;
				}
				
				.hubApp i {
					transform: rotate(90deg);
					margin-bottom: 10px;
				}

				.hubAppModule div {
					writing-mode: vertical-rl;
					transform: rotate(-180deg);
					position: relative;
					font-size: 15px;
					padding-right: 25px;
					padding-bottom: 16px;
				}
				.moduleType{  
					 
					font-size: 10px; 
				}
				
				.hubAppModule i {
					transform: rotate(90deg);
					margin-bottom: 10px;
				}
				
				.appBox div {
					background-color:#fff;
					border-radius:4px; 
					border:1px solid #ccc;
					border-left: 3px solid hsla(200, 80%, 50%, 1);
					border-bottom:1px solid #999;
					padding:5px;
					position: relative;
					height: 100%;
				}
				
				.apiBox div{
					background-color:#fff;
					border-radius:4px; 
					padding:5px;
					border:1px solid #ccc;
					border-left:2px solid #c3193c;
					padding-left:2px;
					padding-top: 1px;
					position: relative;
					height: 100%;
				}
				.apiBox a,.appBox a {
					white-space: nowrap;
					overflow: hidden;
					text-overflow: ellipsis;
					display: inline-block;
					vertical-align: bottom;
				}
				.apiBox a {
					color: #333;
				}
				
				.ess-blob{
					margin: 0 15px 15px 0;
					border: 1px solid #ccc;
					height: 40px;
					width: 140px;
					border-radius: 4px;
					display: table;
					position: relative;
					text-align: center;
					float: left;
				}

				.ess-blobLabel{
					display: table-cell;
					vertical-align: middle;
					line-height: 1.1em;
					font-size: 85%;
				}

				.infoButton > a{
					position: absolute;
					bottom: 0px;
					right: 3px;
					color: #aaa;
					font-size: 90%;
				}

				.ess-tag{
					padding: 3px 12px;
					border: 1px solid transparent;
					border-radius: 16px;
					margin-right: 10px;
					margin-bottom: 5px;
					display: inline-block;
					font-weight: 700;
					font-size: 90%;
				}

				.parent-superflex{
					display: flex;
					flex-wrap: wrap;
					gap: 15px;
				}

				.superflex{
					border: 1px solid #ddd;
					padding: 10px;
					box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
					flex-grow: 1;
					flex-basis: 1;
				}

				.ess-list-tags{
					padding: 0;
				}

				.ess-string{
					background-color: #f6f6f6;
					padding: 5px;
					display: inline-block;
				}

				.bdr-left-blue{
					border-left: 2pt solid #5b7dff !important;
				}

				.bdr-left-indigo{
					border-left: 2pt solid #6610f2 !important;
				}

				.bdr-left-purple{
					border-left: 2pt solid #6f42c1 !important;
				}

				.bdr-left-pink{
					border-left: 2pt solid #a180da !important;
				}

				.bdr-left-red{
					border-left: 2pt solid #f44455 !important;
				}

				.bdr-left-orange{
					border-left: 2pt solid #fd7e14 !important;
				}

				.bdr-left-yellow{
					border-left: 2pt solid #fcc100 !important;
				}

				.bdr-left-green{
					border-left: 2pt solid #5fc27e !important;
				}

				.bdr-left-teal{
					border-left: 2pt solid #20c997 !important;
				}

				.bdr-left-cyan{
					border-left: 2pt solid #47bac1 !important;
				}
				
				.bdr-blue{
				border: 1px solid #5b7dff !important;
				}
				
				.bdr-indigo{
				border: 1px solid #6610f2 !important;
				}
				
				.bdr-purple{
				border: 1px solid #6f42c1 !important;
				}
				
				.bdr-pink{
				border: 1px solid #a180da !important;
				}
				
				.bdr-red{
				border: 1px solid #f44455 !important;
				}
				
				.bdr-orange{
				border: 1px solid #fd7e14 !important;
				}
				
				.bdr-yellow{
				border: 1px solid #fcc100 !important;
				}
				
				.bdr-green{
				border: 1px solid #5fc27e !important;
				}
				
				.bdr-teal{
				border: 1px solid #20c997 !important;
				}
				
				.bdr-cyan{
				border: 1px solid #47bac1 !important;
				}
				
				.ess-panel-header-link a {
					color: #333;
				}

				.text-italic {
					font-style:italic;
				}

				.int-method-label {
					font-size: 11.9px;
				}
				.ess-truncate {
					width: 200px;
					white-space: nowrap;
					overflow: hidden;
					text-overflow: ellipsis;
					}

				.eas-logo-spinner {​​​​​​​​​
					    display: flex;
					    justify-content: center;
					}​​​​​​​​​
					#editor-spinner {​​​​​​​​​
					    height: 100vh;
					    width: 100vw;
					    position: fixed;
					    top: 0;
					    left:0;
					    z-index:999999;
					    background-color: hsla(255,100%,100%,0.75);
					    text-align: center;
					}​​​​​​​​​
					#editor-spinner-text {​​​​​​​​​
					    width: 100vw;
					    z-index:999999;
					    text-align: center;
					}​​​​​​​​​
					.spin-text {​​​​​​​​​
					    font-weight: 700;
					    animation-duration: 1.5s;
					    animation-iteration-count: infinite;
					    animation-name: logo-spinner-text;
					    color: #aaa;
					    float: left;
					}​​​​​​​​​
					.spin-text2 {​​​​​​​​​
					    font-weight: 700;
					    animation-duration: 1.5s;
					    animation-iteration-count: infinite;
					    animation-name: logo-spinner-text2;
					    color: #666;
					    float: left;
					}​​​​​​​​​
					.clusters rect {
						fill: #00ffd0;
						stroke: #999;
						stroke-width: 1.5px;
					  }

					  text {
						font-weight: 300;
						font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
						font-size: 10px;
					  }

					  .node rect {
						stroke: #999;
						fill: #fff;
						stroke-width: 1.5px;
					  }

					  .edgePath path {
						stroke: #333;
						stroke-width: 1.5px;
					  }
					  .int-block{
						  float: left;
						  padding:5px;
						  width:240px;
						  border:1pt solid #ccc;
						  border-left: 4px solid;
						  background-color:#fff;
						  margin:0px 5px 5px 0;
						  box-shadow: 1px 1px 2px rgba(0,0,0,0.25);
						  position: relative;
					  }
					  .int-block > i {
						  position: absolute;
						  bottom: 5px;
						  right: 5px
					  }
					  .greenOn{
						  color: rgb(65, 203, 65)
					  }
					  .itsme path.path { 
							stroke: red;
							fill: red;
							stroke-width: 1.5px; 
					}
					.lineSizer path.path{
						stroke-width: 4px; 
					}
			</style>	

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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Dependency')"/></span>
								</h1>
                             
							</div>
						</div>
						<div class="col-xs-12">
								<select id="appNameSelect">
										<option name="selectOne">Choose an Application</option>
								</select> <xsl:text> </xsl:text>
							<button id="switch" easid="switch" class="setMe">Direction <span id="switchText">Vertical</span></button>
					 		
						
						 <!--	<button class="btn btn-default btn-sm left-15" id="refresh"><i class="fa fa-refresh right-5"></i>Reset Image</button>-->
						 
						</div>
						<div class="col-xs-2 top-15" id="appsList"  style="overflow-y:scroll">
						</div>
						<div class="modal fade" id="info-exchanged-modal" tabindex="-1" role="dialog">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							
							<div class="top-15" id="modal-exchanged-info-container">
							</div>	
					
							<div class="modal-footer">
								<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
						<div class="col-xs-10 top-15">
							<svg id="svg-canvas" width="900" height="400"></svg>
						</div>

					</div>
				</div>
		 
				<!-- ADD THE PAGE FOOTER -->
		 
			</body>
			<script id="modal-panel-template" type="text/x-handlebars-template">
				<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">
										<i class="fa fa-times"></i>
									</span>
								</button>
								<h3 class="modal-title text-darkgrey strong"><i class="fa fa-exchange right-5"></i>Data Exchanged between <span id="modal-source-name" class="text-primary">{{this.sourceAppName}}</span> and <span id="modal-target-name" class="text-primary">{{this.targetAppName}}</span></h3>
							</div>
			 
					<div class="col-xs-12  "><h3><i class="fa fa-file-text-o right-10"/>Data Exchanged</h3></div>
					<div class="clearfix"></div>
					<div class="modal-body"> 
					{{#if this.infoViews.length}} 
					{{#each this.infoViews}}
						<div class="panel panel-default">
							<div class="panel-heading strong ess-panel-header-link large">{{{essRenderInstanceMenuLink this}}}{{#if acqMethod}}<span class="label label-primary pull-right">{{acqMethod.label}}</span>{{/if}}</div>
							<div class="panel-body">
								<div class="ess-blobWrapper">
									{{#each dataObjects}}
										<div class="ess-blob bdr-left-blue">
											<div class="ess-blobLabel">{{{essRenderInstanceMenuLink this}}}</div>
											<div class="infoButton">
												<a tabindex="0" class="popover-trigger">
											 		<i class="fa fa-info-circle"></i> 
												</a>
												<div class="popover">
													<div class="strong">{{{essRenderInstanceMenuLink this}}}</div>
													<div class="small text-muted">{{#if description}}{{description}}{{else}}-{{/if}}</div>
												</div>
											</div>
										</div>
									{{/each}}
								</div>
							</div>
						</div>
					{{/each}}
				{{else}}
				{{#if this.infoReps.length}} 
				{{#each this.infoReps}} 
				<div class="panel panel-default">
					<div class="panel-heading strong ess-panel-header-link large">{{{essRenderInstanceMenuLink this}}}{{#if acqMethod}}<span class="label label-primary pull-right">{{acqMethod.label}}</span>{{/if}}</div>
					<div class="panel-body">
						<div class="ess-blobWrapper">
							{{#each dataObjects}}
							<div class="ess-blob bdr-left-blue">
								<div class="ess-blobLabel">{{{essRenderInstanceMenuLink this}}}</div>
								<div class="infoButton">
									<a tabindex="0" class="popover-trigger">
										<i class="fa fa-info-circle"></i>
									</a>
									<div class="popover">
										<div class="strong">{{{essRenderInstanceMenuLink this}}}</div>
										<div class="small text-muted">{{#if description}}{{description}}{{else}}-{{/if}}</div>
									</div>
								</div>
							</div>
							{{/each}}
						</div>
					</div>
				</div>
				{{/each}}
				{{else}}
				<p><em>No exchanged information defined</em></p>
				{{/if}} 
				{{/if}}		
				
					</div>	 
			</script>
			<script id="info-view-panel-template" type="text/x-handlebars-template">
				{{#if this.length}}
					{{#each this}}
						<div class="panel panel-default">
							<div class="panel-heading strong ess-panel-header-link large">{{{essRenderInstanceMenuLink this}}}{{#if acqMethod}}<span class="label label-primary pull-right">{{acqMethod.label}}</span>{{/if}}</div>
							<div class="panel-body">
								<div class="ess-blobWrapper">
									{{#each dataObjects}}
										<div class="ess-blob bdr-left-blue">
											<div class="ess-blobLabel">{{{essRenderInstanceMenuLink this}}}</div>
											<div class="infoButton">
												<a tabindex="0" class="popover-trigger">
													<i class="fa fa-info-circle"></i>
												</a>
												<div class="popover">
													<div class="strong">{{{essRenderInstanceMenuLink this}}}</div>
													<div class="small text-muted">{{#if description}}{{description}}{{else}}-{{/if}}</div>
												</div>
											</div>
										</div>
									{{/each}}
								</div>
							</div>
						</div>
					{{/each}}
				{{else}}
					<p><em>No exchanged information defined</em></p>
				{{/if}}
			</script>
			
			<script id="info-rep-panel-template" type="text/x-handlebars-template">
				{{#if this.length}}
				{{#each this}}
				<div class="panel panel-default">
					<div class="panel-heading strong ess-panel-header-link large">{{{essRenderInstanceMenuLink this}}}{{#if acqMethod}}<span class="label label-primary pull-right">{{acqMethod.label}}</span>{{/if}}</div>
					<div class="panel-body">
						<div class="ess-blobWrapper">
							{{#each dataObjects}}
							<div class="ess-blob bdr-left-blue">
								<div class="ess-blobLabel">{{{essRenderInstanceMenuLink this}}}</div>
								<div class="infoButton">
									<a tabindex="0" class="popover-trigger">
										<i class="fa fa-info-circle"></i>
									</a>
									<div class="popover">
										<div class="strong">{{{essRenderInstanceMenuLink this}}}</div>
										<div class="small text-muted">{{#if description}}{{description}}{{else}}-{{/if}}</div>
									</div>
								</div>
							</div>
							{{/each}}
						</div>
					</div>
				</div>
				{{/each}}
				{{else}}
				<p><em>No exchanged information defined</em></p>
				{{/if}}
			</script>

			<script>
					
			<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiPathDeps"/>
					<xsl:with-param name="viewerAPIPathMart" select="$apiPathMart"/>
			</xsl:call-template>
			</script>
			<script id="iface-list-template" type="text/x-handlebars-template">
	 
					</script>	

			<script id="appList-template" type="text/x-handlebars-template">
				{{#each this}}
					<div class="appBox">{{this.name}} <i class="setMe fa fa-check-circle greenOn"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i></div>
				{{/each}}
			</script>
			
			 
<script>

<xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template> 

let containingApps=[<xsl:apply-templates select="$containingApps" mode="containingApps"/>];
var g; 
var mainAppId;
var linkages=[];
var dontShow=[];
var windowWidth = $(window).innerWidth();
var windowHeight = $(window).innerHeight();
var svgWidth= windowWidth - 45;
var svgHeight = windowHeight - 200;
var currentAppInfoExchange;
var	currentSource;
var currentTarget;
var pairedArray=[];
var focusApp,viewPath;

$('#svg-canvas').innerWidth(svgWidth);
$('#svg-canvas').innerHeight(svgHeight);
let width = svgWidth;
let height = svgHeight;
mainAppId = '<xsl:value-of select="$param1"/>';
var infoViewPanelTemplate,infoRepPanelTemplate, modalpanelTemplate;
var depData=[];
var focusAppm, allAcqMethods;
let dataSet=[];
var wwidth=$(window).width();
function setAcqMethod(dep) {
	let acqMethod = allAcqMethods.find(am => am.id == dep.acqMethodId);
	dep.acqMethod = acqMethod;
}

function setDepAcqMethod(dep) {
	setAcqMethod(dep);
	dep.infoViews?.forEach(iv => {
		setAcqMethod(iv);
	});
	dep.infoReps?.forEach(ir => {
		setAcqMethod(ir);
	});
 
}

function showEditorSpinner(message) {
	$('#editor-spinner-text').text(message);                            
	$('#editor-spinner').removeClass('hidden')
};

function removeEditorSpinner() {
	$('#editor-spinner').addClass('hidden');
	$('#editor-spinner-text').text('')
};

// DO FROM APPS
var redrawView = function () {
 

	let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
	let a2rScopingDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION'); 
 
 	scopedApps = essScopeResources(fullAppList, [appOrgScopingDef, geoScopingDef,a2rScopingDef, visibilityDef].concat(dynamicAppFilterDefs));
//	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef, a2rScopingDef]);
 
let thefocusApp={};

const getCircularReplacer = () => {
  const seen = new WeakSet();
  return (key, value) => {
    if (typeof value === 'object' &amp;&amp; value !== null) {
      if (seen.has(value)) {
        return;
      }
      seen.add(value);
    }
    return value;
  };
};
  
thefocusApp=JSON.parse(JSON.stringify(DataSet, getCircularReplacer()));
 
if(thefocusApp.id!=''){
 
 let getKids=containingApps.find((f)=>{
	return f.id==thefocusApp.id;
});
console.log('gk',getKids)
if(getKids){
	if(getKids.children.length&gt;0){
		nodeArray.push({"id":'Grp'+thefocusApp.id, "name":thefocusApp.name,  "class":thefocusApp.className, "composite":true})
	}
}
getInfoforApp(thefocusApp, DataSet) 
$('#focus-app-name-lbl').text(thefocusApp.name);
setUpData(thefocusApp, totot, tot)
 
if(getKids){
getKids.children?.forEach((c)=>{

let viewAPISubData=viewPath+c;
	Promise.all([
			promise_loadViewerAPIData(viewAPISubData) 
			]).then(function (responses)
			{	 
			let numArray=[];
			let thisApp=responses[0]
			  thisApp['module']='true'; 
			  console.log('thisApp',thisApp)
			 getInfoforApp(thisApp, thisApp)
				setUpData(thisApp, totot, tot)  
			})
})  
}
depData.forEach((p)=>{ 
	p.receivesFrom?.forEach((f)=>{
		pairedArray.push({"direction":"rFrom", "targetAppId": p.appid,"targetAppName":p.appname, "sourceAppId": f.id ,"sourceAppName": f.name, "infoReps":f.infoReps})
	})
	p.sendsTo?.forEach((f)=>{
		pairedArray.push({"direction":"sTo", "sourceAppId": p.appid,"sourceAppName":p.appname, "targetAppId": f.id ,"targetAppName": f.name, "infoReps":f.infoReps})
	})
	p.fromInterfaces?.forEach((f)=>{
		pairedArray.push({"direction":"rFromI", "targetAppId": p.appid,"targetAppName":p.appname, "sourceAppId": f.id ,"sourceAppName": f.name, "infoReps":f.infoReps})
		f.receivesFrom?.forEach((g)=>{
			pairedArray.push({"direction":"rFromI", "targetAppId": f.id,"targetAppName":f.name, "sourceAppId": g.id ,"sourceAppName": g.name, "infoReps":f.infoReps})
		})
	})
	p.toInterfaces?.forEach((f)=>{
		pairedArray.push({"direction":"sToI", "sourceAppId": p.appid,"sourceAppName":p.appname, "targetAppId": f.id ,"targetAppName": f.name, "infoReps":f.infoReps})
		f.sendsTo?.forEach((g)=>{
			pairedArray.push({"direction":"sToI", "targetAppId": f.id,"targetAppName":f.name, "sourceAppId": g.id ,"sourceAppName": g.name, "infoReps":f.infoReps})
		})
	})
}) 
}
	$('#appNameSelect').off().on('change', function(){
		let appID= $('#appNameSelect option:selected').val();
		mainAppId=appID;
		compositeArray=[];
		pairedArray=[];
		nodeArray=[];
		edgeArray=[];
		workingNodeArray=[]
		workingEdgeArray=[];
		workingCompositeArray=[];
		var viewAPIData = viewPath+appID;
		
		
		Promise.all([
			promise_loadViewerAPIData(viewAPIData) 
			]).then(function (responses)
			{ 
				DataSet=responses[0]; 
				redrawView()

	})
})
}
function getInfoforApp(theApp, dataFromAPI){
	let tfaDependencies=[];
let ttaDependencies=[];
let tfdaDependencies=[];
let ttdaDependencies=[];
dataFromAPI.dependencies.fromInterfaces.forEach((e)=>{
		let inscope=scopedApps.resourceIds.find((ap)=>{
			return e.id == ap;
		})
	
		if(inscope){ 
			if(e.receivesFrom.length==0){
				e.receivesFrom.push({'className':'Composite_Application_Provider', 'id':'fake1', 'name':'Fake1'})
			}
			tfaDependencies.push(e)}
	})
	theApp.dependencies['fromInterfaces']=tfaDependencies
	dataFromAPI.dependencies.toInterfaces.forEach((e)=>{
		let inscope=scopedApps.resourceIds.find((ap)=>{
			return e.id == ap;
		})
		if(e.sendsTo.length==0){
			e.sendsTo.push({'className':'Composite_Application_Provider', 'id':'fake1', 'name':'Fake1'})
		}

		if(inscope){ttaDependencies.push(e)}
	})
	theApp.dependencies['toInterfaces']=ttaDependencies

	dataFromAPI.dependencies.receivesFrom.forEach((e)=>{
		let inscope=scopedApps.resourceIds.find((ap)=>{
			return e.id == ap;
		})
		if(inscope){tfdaDependencies.push(e)}
	})
	theApp.dependencies['receivesFrom']=tfdaDependencies

	dataFromAPI.dependencies.sendsTo.forEach((e)=>{
		let inscope=scopedApps.resourceIds.find((ap)=>{
			return e.id == ap;
		})
		if(inscope){ttdaDependencies.push(e)}
	}) 
	theApp.dependencies['sendsTo']=ttdaDependencies
 
	return theApp
}



function setUpData(data, totot, tot){ 
	allAcqMethods = data.allAcqMethods;
	focusApp = {
		"id": data.id,
		"className": data.className,
		"name": data.name
	} 
 
		data.dependencies.receivesFrom?.forEach(src => {
			setDepAcqMethod(src);
		});
		
		data.dependencies.sendsTo?.forEach(tgt => {
			setDepAcqMethod(tgt);
		});
		
		data.dependencies.fromInterfaces?.forEach(ifc => {
			setDepAcqMethod(ifc);
			ifc.receivesFrom?.forEach(src => {
				setDepAcqMethod(ifc);
			});
		});
	
	
		data.dependencies.toInterfaces?.forEach(ifc => {
			setDepAcqMethod(ifc);
			ifc.sendsTo?.forEach(src => {
				setDepAcqMethod(ifc);
			});
		});
	data.dependencies["appid"]=	data.id;
	data.dependencies["appname"]= data.name;
	depData.push(data.dependencies);
	
// get direct apps
var appCount = d3.nest()
  .key(function(d) {  return d.id})
  .entries(data.dependencies.receivesFrom);
  //console.log('appCount',appCount)
<!-- start-->
let interfaceFromApps=[]

data.dependencies.fromInterfaces.forEach((e)=>{

	e.receivesFrom.forEach((f)=>{ 
         
       let rxFr= {"acqMethodId":f.acqMethodId,
       "className":f.className,
       "dependencyId":f.dependencyId, 
	   "lifecycleStatus":f.lifecycleStatus, 
        "hasInfo": f.hasInfo,
        "id": f.id,
        "interfaces": f.interfaces,
        "acqMethodId": f.acqMethodId,
        "name": f.name,
        "usageId":f.usageId};

		interfaceFromApps.push(rxFr)
	});
});

let lifeScopingDef = new ScopingProperty('lifecycleStatus', 'Lifecycle_Status');
 

let scopedinterfaceFromApps = essScopeResources(interfaceFromApps, [lifeScopingDef]);
 

let interfacesToAdd=[];
interfaceFromApps.forEach((e)=>{
 
	let match = Object.keys(appCount).filter((key) => {
	 
		return appCount[key].key==e.id})
	if(match.length&gt;0){   }
	else{
      
      
		interfacesToAdd.push({"key":e.id,
		"interfaces":[],
		"values":[{"className": "Composite_Application_Provider",  
        "id": e.id,
		"dependencyId":e.dependencyId, 
		"lifecycleStatus":e.lifecycleStatus, 
		"name": e.name,
		"apiApp":"true"}]
		})
	}
	
});
interfacesToAdd.forEach((iface)=>{
    appCount.push(iface)
})

<!-- end -->
let indirectApps=[];
appCount.forEach((ap)=>{ 
let allInterfaces=[];

// get apps via APIs and assign relevant apis to app
data.dependencies.fromInterfaces.forEach((d)=>{
	let relInterfaces = d.receivesFrom.filter((e)=>{
		return e.id == ap.key
	});
// get apps that are not direct 
	let newAppsViaInterfaces = d.receivesFrom.filter((e)=>{
		return e.id != ap.key
	});
	if(newAppsViaInterfaces.length&gt; 0){
      
        let thisi= {
                    "acqMethodId": d.acqMethodId,
                    "className": d.className,
                    "dependencyId": d.dependencyId,
                    "description":d.description,
                    "hasInfo": d.hasInfo,
                    "id": d.id,
					"lifecycleStatus":d.lifecycleStatus, 
                    "name": d.name,
                    "receivesFrom":d.receivesFrom,
                    "sendsTo":d.sendsTo,
                    "usageId":d.usageId
                     }


		newAppsViaInterfaces[0]["interfaces"]=thisi;

		indirectApps.push(newAppsViaInterfaces[0])
	}



	if(relInterfaces.length&gt; 0){
        let thisi2= {
                    "acqMethodId": d.acqMethodId,
                    "className": d.className,
                    "dependencyId": d.dependencyId,
                    "description":d.description,
                    "hasInfo": d.hasInfo,
                    "id": d.id,
					"lifecycleStatus":d.lifecycleStatus, 
                    "name": d.name,
                    "receivesFrom":d.receivesFrom,
					"sendsTo":d.sendsTo,
                    "usageId":d.usageId
                     } 
		allInterfaces.push(thisi2)
	}
	});
	
// assign interfaces to apps
ap['interfaces']=allInterfaces;
});

let scopedindirectApps = essScopeResources(indirectApps, [lifeScopingDef]);
 
	
let scopedinterfacesToAdd = essScopeResources(interfacesToAdd, [lifeScopingDef]);
 
<!-- start -->
interfacesToAdd.forEach((d)=>{
	appCount.push(d)
 });
 <!-- end -->

// DO TO APPS ######################

 
// get direct apps
var appToCount = d3.nest()
  .key(function(d) {  return d.id})
  .entries(data.dependencies.sendsTo);
<!-- start -->
let interfaceToApps=[]

//console.log('appToCount',appToCount)
data.dependencies.toInterfaces.forEach((e)=>{

    e.sendsTo.forEach((f)=>{ 
         
         let rxTo= {"acqMethodId":f.acqMethodId,
         "className":f.className,
         "dependencyId":f.dependencyId, 
          "hasInfo": f.hasInfo,
          "id": f.id,
		  "lifecycleStatus":f.lifecycleStatus, 
          "interfaces": f.interfaces,
          "acqMethodId": f.acqMethodId,
          "name": f.name,
          "usageId":f.usageId,
		  "sendsTo":f.sendsTo};
          interfaceToApps.push(rxTo)
      });
});

let interfacesToAddTo=[];
interfaceToApps.forEach((e)=>{
	 
	let match = Object.keys(appToCount).filter((key) => {
 
		return appToCount[key].key==e.id})
	if(match.length&gt;0){}
	else{
		interfacesToAddTo.push({"key":e.id,
		"interfaces":[],
		"values":[{"className": "Composite_Application_Provider", 
        "id": e.id, 
		"dependencyId":e.dependencyId, 
		"lifecycleStatus":e.lifecycleStatus, 
		"name": e.name,
		"apiApp":"true"}]
		})
	}
	
})

interfacesToAddTo.forEach((d)=>{
	appToCount.push(d)
 })
<!-- end -->
let indirectToApps=[];
appToCount.forEach((ap)=>{
let allToInterfaces=[];

// get apps via APIs and assign relevant apis to app
data.dependencies.toInterfaces.forEach((d)=>{
	let relInterfaces = d.sendsTo.filter((e)=>{
		return e.id == ap.key
	});
// get apps that are not direct 
	let newAppsViaInterfaces = d.sendsTo.filter((e)=>{
		return e.id != ap.key
	});

	//console.log('relInterfaces',relInterfaces)
	//console.log('newAppsViaInterfaces',newAppsViaInterfaces)
	if(newAppsViaInterfaces.length&gt; 0){
 
        let thisi= {
                    "acqMethodId": d.acqMethodId,
                    "className": d.className,
                    "dependencyId": d.dependencyId,
                    "description":d.description,
                    "hasInfo": d.hasInfo,
                    "id": d.id,
					"lifecycleStatus":d.lifecycleStatus, 
                    "name": d.name,
                    "sendsTo":d.sendsTo,
                    "usageId":d.usageId
                     }

		newAppsViaInterfaces[0]["interfaces"]=thisi

		indirectToApps.push(newAppsViaInterfaces[0])
	}

	if(relInterfaces.length&gt; 0){
        let thisi2= {
                    "acqMethodId": d.acqMethodId,
                    "className": d.className,
                    "dependencyId": d.dependencyId,
                    "description":d.description,
                    "hasInfo": d.hasInfo,
                    "id": d.id,
					"lifecycleStatus":d.lifecycleStatus, 
                    "name": d.name,
                    "receivesFrom":d.receivesFrom,

                    "sendsTo":d.sendsTo,
                    "usageId":d.usageId
                     } 

					
		allToInterfaces.push(thisi2)
	}
	});
	
	//console.log('allToInterfaces',allToInterfaces)
// assign interfaces to apps
ap['tointerfaces']=allToInterfaces; 
});
 
  totot=0;

appToCount=appToCount.filter((elem, index, self) => self.findIndex( (t) => {return (t.key === elem.key)}) === index)
appToCount.forEach((d)=>{
	i=0;
	d.values.forEach((e)=>{
        if(e.apiApp){
            e['pos']=i;
            e['num']=totot;
			
        }else
        {
            e['pos']=i;
            e['num']=totot;
            i=i+1;
            totot=totot+1;
        }
	});
	d.tointerfaces.forEach((e)=>{
		e['pos']=i;
		e['num']=totot;
		i=i+1;
		totot=totot+1;
	})
	d['tot']=totot;
	
	
})
 
<!-- set positions -->
 tot=0;

var appToCountConsolidated =[];

appCount.forEach((a)=>{
    let allThis=appCount.filter((e)=>{
        return e.key == a.key
    });
    let thisInterfaceArray=[]
    allThis.forEach((inf)=>{
     thisInterfaceArray=[...thisInterfaceArray, ...inf.interfaces]

    })
    //remove duplicates

    thisInterfaceArray=thisInterfaceArray.filter((elem, index, self) => self.findIndex( (t) => {return (t.usageId === elem.usageId)}) === index)
     
    a['interfaces']=thisInterfaceArray;
})
appCount=appCount.filter((elem, index, self) => self.findIndex( (t) => {return (t.key === elem.key)}) === index)
//console.log('appCount',appCount)

 appCount.forEach((d)=>{
 
	i=0;
	d.values.forEach((e)=>{
        if(e.apiApp){
            e['pos']=i;
            e['num']=tot;
        }
        else
        {
            e['pos']=i;
            e['num']=tot;
            i=i+1;
            tot=tot+1;
        }
	});
 if(d.interfaces){
	d.interfaces.forEach((e)=>{
		e['pos']=i;
		e['num']=tot;
		i=i+1;
		tot=tot+1;
	})
 }
 
	d['tot']=tot;
    d['i']=i;
    d['rowpos']=tot;
})
   
				dataSet['from']=appCount
				dataSet['to']=appToCount 
				let ht = Math.max(totot, tot)+2;
				dataSet['tot']=ht;
				dataSet['name']=data.name;
				dataSet['id']=data.id;
				dataSet['className']=data.className;
				if(data.module){
				dataSet['module']=data.module;
			}
 
	redraw(dataSet)

}
var nodeArray=[];
var edgeArray=[];
var compositeArray=[]
var workingNodeArray=[]
var workingEdgeArray=[];
var workingCompositeArray=[];
var direction='LR';
const minFocusHeight = 100;
 var totot=0;
 var tot=0;
 var appListTemplate, ifaceListTemplate;
let totsArray=[];
$(document).ready(function() {
	let ww=wwidth
		let appListFragment = $("#appList-template").html();
		appListTemplate = Handlebars.compile(appListFragment);

		let ifaceListFragment = $("#iface-list-template").html();
		ifaceListTemplate = Handlebars.compile(ifaceListFragment);

		let infoViewPanelFragment = $('#info-view-panel-template').html();
		infoViewPanelTemplate = Handlebars.compile(infoViewPanelFragment);
		
		let infoRepPanelFragment = $('#info-rep-panel-template').html();
		infoRepPanelTemplate = Handlebars.compile(infoRepPanelFragment);

		let modalpanelFragment=$('#modal-panel-template').html();
		modalpanelTemplate = Handlebars.compile(modalpanelFragment);
 
		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('ifNotEquals', function (arg1, arg2, options) {
			return (arg1 != arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('getFocusHeight', function (arg1, arg2, options) {
 
		let tot = arg1 ;
		return Math.max(minFocusHeight, (tot * 31));
		});
	  
		Handlebars.registerHelper('getHeight', function (arg1, arg2, options) {
 
			let tot = arg1+arg2;
			return (tot * 34);
		});  
		
		$('#info-exchanged-modal').on('show.bs.modal', function (e) {
	 
			if(currentAppInfoExchange.length==0){
				currentSource=fullAppList.find((fa)=>{
					return fa.id==currentSource;
				})
				currentTarget=fullAppList.find((fa)=>{
					return fa.id==currentTarget;
				}) 
				currentAppInfoExchange.push({"sourceAppName":currentSource.name, "targetAppName": currentTarget.name});
			}

 			$('#modal-exchanged-info-container').html(modalpanelTemplate(currentAppInfoExchange[0]));
			$('.popover-trigger').popover({
							container: 'body',
							html: true,
							trigger: 'focus',
							placement: 'auto',
							content: function(){
							return $(this).next().html();
							}
						});
		});

		$('#info-exchanged-modal').on('hidden.bs.modal', function (e) {
			currentAppInfoExchange = null;
			currentSource = null;
			currentTarget = null;
		});
	
		
})

var currentExchangeType, currentAppInfoExchange, currentSource, currentTarget;

function setNodes(appToDo){
	
					if(appToDo.id !== mainAppId){  
						compositeArray.push({"id":mainAppId})
						compositeArray.push({"id":appToDo.id})
					}
					nodeArray.push({"id":appToDo.id, "name":appToDo.name,  "class":appToDo.className}) 
				 
					appToDo.from.forEach(function(app){ 
							if(app.interfaces.length&gt;0){
								 
								app.interfaces.forEach((ai)=>{
								nodeArray.push({"id":ai.id, "name":ai.name, "parent":appToDo.id, "parentId":appToDo.id, "class":ai.className})
								edgeArray.push({"from": ai.id,"to": appToDo.id, "depid":ai.dependencyId})
								if(ai.receivesFrom){ 
										nodeArray.push({"id":ai.receivesFrom[0].id, "name":ai.receivesFrom[0].name, "parent":ai.id, "parentId":ai.id, "class":ai.receivesFrom[0].className})
										ai.receivesFrom.forEach((ele)=>{ 
											edgeArray.push({"from": ele.id,"to": ai.id, "depid":ai.dependencyId, "int": ai.id, "type":"fromInterfaceSource", "otherApp":appToDo.id, "id":app.id})
										})
								}
								})  
								if(app.values.length&gt;0){
									nodeArray.push({"id":app.values[0].id, "name":app.values[0].name, "parent":appToDo.id, "parentId":appToDo.id, "class":app.values[0].className})

									if(app.values[0].apiApp!=='true'){
									edgeArray.push({"from": app.values[0].id,"to": appToDo.id, "depid":app.values[0].dependencyId, "int": app.values[0].id, "type":"fromInterfaceTarget", "otherApp":appToDo.id,  "id":app.id})
									}
								} 
							}
							else{
								nodeArray.push({"id":app.values[0].id, "name":app.values[0].name, "parent":appToDo.id, "parentId":appToDo.id, "class":app.values[0].className})
								edgeArray.push({"from": app.values[0].id,"to": appToDo.id, "depid":app.values[0].dependencyId, "type":"fromSource", "otherApp":appToDo.id,  "id":app.id})
							} 
					});

					appToDo.to.forEach(function(app){
							if(app.tointerfaces.length&gt;0){
								 app.tointerfaces.forEach((ai)=>{  
							nodeArray.push({"id":ai.id, "name":ai.name, "parent":appToDo.id, "parentId":appToDo.id, "class":ai.className})
								edgeArray.push({"to": ai.id,"from": appToDo.id, "depid":ai.dependencyId})
								if(ai.sendsTo){  
									nodeArray.push({"id":ai.sendsTo[0].id, "name":ai.sendsTo[0].name, "parent":ai.id, "parentId":ai.id, "class":ai.sendsTo.className})
								 
									edgeArray.push({"to": ai.sendsTo[0].id,"from": ai.id, "depid":ai.dependencyId, "type":"toInterfaceSource","int": ai.id, "otherApp":appToDo.id, "id":app.id})
								}
 
								})
								
								if(app.values.length&gt;0){

									nodeArray.push({"id":app.values[0].id, "name":app.values[0].name, "parent":appToDo.id, "parentId":appToDo.id, "class":app.values[0].className})
									edgeArray.push({"to": app.values[0].id,"from": appToDo.id, "depid":app.values[0].dependencyId, "type":"toInterfaceTarget","int": app.values[0].id, "otherApp":appToDo.id, "id":app.id})
								}
							}
							else{
								nodeArray.push({"id":app.values[0].id, "name":app.values[0].name, "parent":appToDo.id, "parentId":appToDo.id, "class":app.values[0].className})
								edgeArray.push({"to": app.values[0].id,"from": appToDo.id, "depid":app.values[0].dependencyId, "type":"toTarget", "otherApp":appToDo.id, "id":app.id})
							} 
					});
    
			}
 			

function redraw(dataForMap){  
	console.log('redraw dataformap')
	var svg;

	setNodes(dataForMap)
	var parentArray=[];
	var g;

	nodeArray=nodeArray.sort((a, b) => a.name.localeCompare(b.name))
	<!-- fix to handle any orphan instances -->
	nodeArray=nodeArray.filter((e)=>{
		return e.id!=='';
	})
	edgeArray=edgeArray.filter((e)=>{
		return e.to!=='';
	})
	edgeArray=edgeArray.filter((e)=>{
		return e.from!=='';
	})
	  
	nodeArray=nodeArray.filter((elem, index, self) => self.findIndex( (t) =>{return (t.id === elem.id)}) === index)

	console.log('---------------------')
	console.log('focusApp', focusApp )
console.log('nodeArray', nodeArray, )
console.log('edgeArray', edgeArray)
console.log(' CompositeArray', compositeArray)
  
	let appArr1=nodeArray.filter((a)=>{return a.id !== mainAppId});
	let appArr=appArr1.filter((a)=>{return a.id !== 'Grp'+mainAppId});
 	console.log('appArr',appArr)
 	appArr=appArr.filter((elem, index, self) => self.findIndex( (t) =>{return (t.name === elem.name)}) === index)
	$('#appsList').html(appListTemplate(appArr));
	renderImage(nodeArray, edgeArray, compositeArray, direction)
  
	$('.setMe').off().on('click', function(){
	clickedID=$(this).attr('easid');
	clickedStatus=$(this).attr('class'); 
	if(clickedID=='switch'){ 
		if(	direction=='TB'){
				direction= 'LR';  
				$('#switchText').text('Vertical')
			}
			else{
				direction= 'TB'; 
				$('#switchText').text('Horizontal')
			}
		}
		else{
		if(clickedStatus.includes('greenOn')){ 
			$(this).removeClass('greenOn')
			dontShow.push(clickedID)
		}else{ 
			$(this).addClass('greenOn')
	
			dontShow=dontShow.filter((e)=>{ return e!=clickedID})
		} 
	}
	workingNodeArray=nodeArray; 
	workingCompositeArray=compositeArray;
	workingEdgeArray=edgeArray;
	let workingEdgeArrayPre=[] 
	for(i=0;i&lt;dontShow.length;i++){ 
	workingNodeArray=workingNodeArray.filter((e)=>{
		return e.id!==dontShow[i];
	}); 
	workingCompositeArray=workingCompositeArray.filter((e)=>{
		return e.id!==dontShow[i];
	}); 
	workingEdgeArrayPre=workingEdgeArray.filter((e)=>{
		return e.from!==dontShow[i];
	}); 
	workingEdgeArray=workingEdgeArrayPre.filter((e)=>{
		return e.to!==dontShow[i];;
	});  
}


	renderImage(workingNodeArray, workingEdgeArray, workingCompositeArray, direction)
	})

  	
	function renderImage(nodeList, edgeList, compList, dir){
		g=[];
		g = new dagreD3.graphlib.Graph({compound:true})
			  .setGraph({rankdir: dir})
			  .setDefaultEdgeLabel(function() { return {}; });
			 
 
			// set-up nodes 
			compList.forEach(function(d){   
				g.setParent(d.id,'Grp'+mainAppId)
			})
			 
			nodeList.forEach(function(d){    
				if(d.composite){
					g.setNode(d.id,{class: 'composite ' + 'Grp'+d.d, label: d.name+' (Composite)',  clusterLabelPos: 'top', style: 'fill: #e3e3e3', labelStyle: 'font-weight:bold; font-size:1.1em'})
				}
				else if (d.class=='Application_Provider_Interface'){
					g.setNode(d.id, {labelType: "html", style: "fill: orange", label: '<div style="width: auto; height: auto;color:#000">'+d.name+'</div>', class:d.id }); 
				}
				else{
					g.setNode(d.id, {labelType: "html", label: '<div style="width: auto; height: auto;color:#000">'+d.name+'</div>', class:d.id });
				}
				});
 
			edgeList.forEach((e)=>{
				if(!e.int){e['int']=''} 
				someHTML='<div style="color:black" class="edgeId" eas-dep-id="'+e.depid+'" eas-type="'+e.type+'" eas-int-id="'+e.int+'" eas-other-app="'+e.otherApp+'" fromid="'+e.from+'" toid="'+e.to+'"><i class="fa fa-info-circle" infoid="'+e.from+e.to+'"></i></div>';
			g.setEdge(e.from, e.to, {curve: d3.curveBasis, labelType: "html", class:"theEdge"+e.type, label:someHTML});
					})
		 
			//console.log(g.edges());
			g.nodes().forEach(function(v) { 
				
				 if(v){
				 
			  var node = g.node(v);   
					node.rx = node.ry = 5;
				 } 
			});
			// Create the renderer
			var render = new dagreD3.render();
			
			// Set up an SVG group so that we can translate the final graph.
			// Set up an SVG group so that we can translate the final graph.
			 svg = d3.select("svg");
				
			svg.selectAll(".clusters").remove();
			svg.selectAll(".nodes").remove();
			svg.selectAll(".edgePaths").remove();
			svg.selectAll(".edgeLabels").remove();
			
			svgGroup = svg.append("g");
			 
			svg.attr("width", width);
			
			// Run the renderer. This is what draws the final graph.
			var inner = svg.select("g");
			var zoom = d3.zoom().on("zoom", function() {
				inner.attr("transform", d3.event.transform);
			});
			svg.call(zoom);
			
			render(inner, g);
			
			// Center the graph
			//var xCenterOffset = (svg.attr("width") - g.graph().width) / 2;
			//svgGroup.attr("transform", "translate(" + xCenterOffset + ", 20)");
			svg.attr("height", g.graph().height + 40);	
			// Center the graph
			
			var padding = 20,
			  bBox = inner.node().getBBox(),
			  hRatio = height / (bBox.height + padding),
			  wRatio = width / (bBox.width + padding);
			 
			  if(g.graph().width > width){
			  widthSize = width/g.graph().width;
			  }
			  else{
				widthSize=1;
			  }
			 
			
			var initialScale = widthSize;
		//	svg.call(zoom.transform, d3.zoomIdentity.translate(widthSize,height).scale(1)); 
		//	svg.call(zoom.transform, d3.zoomIdentity.translate((svg.attr("width") - g.graph().width * initialScale) / 2, 20).scale(initialScale));
			
			bBox.width = width;
			bBox.height = height;
			g.graph().width = width;
		
			d3.selectAll('g.edgePath').on('click', function(){
				if($(this).attr('class').includes("itsme")){
					$(this).removeClass("itsme");
				}else{
					$(this).addClass("itsme");
				} 
			
			})
 
			d3.selectAll('g.edgePath').on('mouseover', function(){
				$('.theEdge').removeClass("lineSizer");
				$(this).addClass("lineSizer");
				});

			d3.selectAll('g.edgePath').on('mouseout', function(){
				$(this).removeClass("lineSizer"); 
				})	
 
				$('.fa-info-circle').off().on('click', function(e) {
					let fromId = $(this).parent().attr('fromid');
					let toId = $(this).parent().attr('toid');
					let exchangeType = $(this).parent().attr('eas-type'); ;
   
					let thisTargetFilter=pairedArray.filter((d)=>{
							return d.targetAppId==toId;
					})
					let thisSourceFilter=thisTargetFilter.filter((d)=>{
							return d.sourceAppId==fromId;
					}) 
					currentAppInfoExchange=thisSourceFilter;
					currentSource=fromId;
					currentTarget=toId;
 				$('#info-exchanged-modal').modal('show');
				})
	}

}

</script>	
		</html>
	</xsl:template>
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/>
			<xsl:param name="viewerAPIPathMart"/>
			let param1='<xsl:value-of select="$param1"/>';
			viewPath='<xsl:value-of select="$viewerAPIPath"/>&amp;PMA=';
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>&amp;PMA='+param1;
			var viewAPIDataMart = '<xsl:value-of select="$viewerAPIPathMart"/>&amp;PMA='+param1;
 
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

var DataSet=[];	
var fullAppList=[];	
var dynamicAppFilterDefs=[];	
var dynamicCapFilterDefs=[];

$('document').ready(function () {
	showEditorSpinner('Fetching Data')
			Promise.all([
			promise_loadViewerAPIData(viewAPIData),
			promise_loadViewerAPIData(viewAPIDataMart) 
			]).then(function (responses)
			{
				removeEditorSpinner(); 
				DataSet=responses[0];
				let filters=responses[1].filters;
				let capfilters=responses[1].filters;
				fullAppList=responses[1].applications.concat(responses[1].apis) 
			console.log('fullAppList',fullAppList)
				fullAppList.forEach((d)=>{
				 
					$('#appNameSelect').append($('&lt;option>', { 
							value: d.id,
							text : d.name
						}));
				})
				$('#appNameSelect').select2();

				capfilters.forEach((d)=>{
					responses[1].filters.push(d);
				})
				responses[1].filters.sort((a, b) => (a.id > b.id) ? 1 : -1) 
				dynamicAppFilterDefs=filters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				});
				dynamicCapFilterDefs=capfilters?.map(function(filterdef){
					return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
				}); 
			//	 setUpData(DataSet);
				essInitViewScoping(redrawView,['Group_Actor', 'Geographic_Region', 'SYS_CONTENT_APPROVAL_STATUS'], filters);

			})
		})
	</xsl:template>

	<xsl:template name="GetViewerAPIPath">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderLinkText">
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
	<xsl:template match="node()" mode="containingApps">
		{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"children":[<xsl:for-each select="current()/own_slot_value[slot_reference = 'contained_application_providers']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
</xsl:stylesheet>
