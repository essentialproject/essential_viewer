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
				
				.appBox i {
					color: hsla(200, 80%, 50%, 1);
				}
				
				.apiBox i {
					color: #c3193c;
				}
				
				.hubAppModule > xhtml, .hubApp > xhtml {
					display: flex;
					flex-direction: row-reverse;
				}
				
				.hubApp div {
					writing-mode: vertical-rl;
					position: relative;
					font-size: 14px;
					padding-right: 2px;
					padding-bottom: 2px;
				}
				
				.hubApp i {
					transform: rotate(90deg);
					margin-bottom: 10px;
				}

				.hubAppModule div {
					writing-mode: vertical-rl;
					position: relative;
					font-size: 14px;
					padding-right: 2px;
					padding-bottom: 2px;
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
									<span class="text-darkgrey">Application Dependency Model - </span><span class="text-primary" id="focus-app-name-lbl"></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
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
							<div class="simple-scroller">
								<div id="model"/>
							</div>
							
						</div>
					
						<!--Setup Closing Tags-->
					</div>
				</div>
				<div class="modal fade" id="info-exchanged-modal" tabindex="-1" role="dialog">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-label="Close">
									<span aria-hidden="true">
										<i class="fa fa-times"></i>
									</span>
								</button>
								<h3 class="modal-title text-darkgrey strong"><i class="fa fa-exchange right-5"></i>Data Exchanged between <span id="modal-source-name" class="text-primary">SOURCE</span> and <span id="modal-target-name" class="text-primary">TARGET</span></h3>
							</div>
							<div class="modal-body">
								<!--<h3><i class="fa fa-cogs right-10"/>Integration Method</h3>	
								<span class="label label-primary" id="modal-acquisition-method"/>																	
								<hr></hr>-->
								<h3><i class="fa fa-file-text-o right-10"/>Data Exchanged</h3>
								<div class="top-15" id="modal-exchanged-info-container"></div>									
								<!-- <div class="panel panel-default">
									<div class="panel-heading">Information View</div>
									<div class="panel-body">
										<div class="parent-superflex">
											<div class="superflex">
												<div class="ess-blobWrapper">
													<div class="ess-blob bdr-left-orange" id="someid">
														<div class="ess-blobLabel"><a href="#" id="someidLink">Customer</a></div>
														<div class="infoButton" id="someid_info"><a tabindex="0" class="popover-trigger"><i class="fa fa-info-circle"></i></a><div class="popover">
															<div class="strong">Object Name</div>
															<div class="small text-muted">Object Description</div>
															</div>
														</div>
													</div>
													<div class="ess-blob bdr-left-orange" id="someid">
														<div class="ess-blobLabel"><a href="#" id="someidLink">Employee</a></div>
														<div class="infoButton" id="someid_info"><a tabindex="0" class="popover-trigger"><i class="fa fa-info-circle"></i></a><div class="popover">
															<div class="strong">Object Name</div>
															<div class="small text-muted">Object Description</div>
															</div>
														</div>
													</div>
													<div class="ess-blob bdr-left-orange" id="someid">
														<div class="ess-blobLabel"><a href="#" id="someidLink">Organisation</a></div>
														<div class="infoButton" id="someid_info"><a tabindex="0" class="popover-trigger"><i class="fa fa-info-circle"></i></a><div class="popover">
															<div class="strong">Object Name</div>
															<div class="small text-muted">Object Description</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div> -->
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
		 
			</body>
			<script>
			<xsl:call-template name="RenderViewerAPIJSFunction">
					<xsl:with-param name="viewerAPIPath" select="$apiPathDeps"/>
					<xsl:with-param name="viewerAPIPathMart" select="$apiPathMart"/>
			</xsl:call-template>
			</script>

			<script id="info-view-panel-template" type="text/x-handlebars-template">
				{{#if this.length}}
					{{#each this}}
						<div class="panel panel-default">
							<div class="panel-heading strong ess-panel-header-link large">
								{{{essRenderInstanceMenuLink this}}}..{{#if acqMethod}}<span class="label label-primary pull-right">{{acqMethod.label}}</span>{{/if}}
								{{#if svcQualVals.length}}
									{{#each svcQualVals}}
										<span class="label label-secondary pull-right right-5">{{valLabel}}</span>
									{{/each}}
								{{/if}}
							</div>
							<div class="panel-body">
								<div class="ess-blobWrapper">
									{{#each dataObjects}}
										<div class="ess-blob bdr-left-blue">
											<div class="ess-blobLabel">{{{essRenderInstanceMenuLink this}}}</div>
											{{#ifEquals this.description.length 0}}
											{{else}}
											<div class="infoButton">
												<a tabindex="0" class="popover-trigger">
													<i class="fa fa-info-circle"></i>
												</a>
												<div class="popover">
													<div class="strong">{{{essRenderInstanceMenuLink this}}}</div>
													<div class="small text-muted">{{#if description}}{{description}}{{else}}-{{/if}}</div>
												</div>
											</div>
											{{/ifEquals}}
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
					<div class="panel-heading strong ess-panel-header-link large">{{{essRenderInstanceMenuLink this}}}
						{{#if acqMethod}}<span class="label label-primary pull-right">{{acqMethod.label}}</span>{{/if}}
						{{#if svcQualVals}} 
							{{#each this.svcQualVals}}
								<span class="label label-danger pull-right right-5">{{valLabel}}</span>
							{{/each}}
						{{/if}}
					</div>
					<div class="panel-body">
						<div class="ess-blobWrapper">
							{{#each dataObjects}}
							<div class="ess-blob bdr-left-blue">
								<div class="ess-blobLabel">{{{essRenderInstanceMenuLink this}}}</div>
								{{#ifEquals this.description.length 0}}
									{{else}}
									<div class="infoButton">
										<a tabindex="0" class="popover-trigger">
											<i class="fa fa-info-circle"></i>
										</a>
										<div class="popover">
											<div class="strong">{{{essRenderInstanceMenuLink this}}}</div>
											<div class="small text-muted">{{#if description}}{{description}}{{else}}-{{/if}}</div>
										</div>
									</div>
								{{/ifEquals}}
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

<script id="iface-list-template" type="text/x-handlebars-template">
						
	<svg id="svgPanel"><xsl:attribute name="height">{{#getFocusHeight this.tot 2}}{{/getFocusHeight}}</xsl:attribute><xsl:attribute name="width">{{#getWidth}}{{/getWidth}}</xsl:attribute>
			   <defs>
				<marker id="arrowhead" markerWidth="7" markerHeight="7" 
				refX="0" refY="3.5" orient="auto">
				  <polygon points="0 0, 7 3.5, 0 7" />
				</marker>
			  </defs>
	{{#each this.from}}
	{{#each this.values}}
	{{#ifEquals @index 0}}
			<!-- rectangle and text --> 
			{{#ifEquals this.name 'Fake1'}}
			{{else}}
			<foreignObject class="appBox"  x="10"><xsl:attribute name="width">{{#getItemWidth box}}{{/getItemWidth}}</xsl:attribute>
				<xsl:attribute name="y">{{#getRow this.num}}{{/getRow}}</xsl:attribute>
				<xsl:attribute name="height">{{#if this.apiApp}}{{#getHeight 0 ../this.interfaces.length}}{{/getHeight}}{{else}}{{#getHeight ../this.values.length ../this.interfaces.length}}{{/getHeight}}{{/if}}</xsl:attribute> 
				<xhtml>
					<div>
						<xsl:attribute name="title">{{this.name}}</xsl:attribute>
						<span class="ess-truncate"><i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}} {{#getInfo this}}{{/getInfo}}</span></div>
				<!--	<div class="node-rect wordwrap">
						<xsl:attribute name="style">width: 190px; height: {{#getHeight ../this.values.length ../this.interfaces.length}}{{/getHeight}}px;</xsl:attribute>
						<div class="node-title">
							<span class="node-title-text" style="position:top">								
								{{{essRenderInstanceMenuLink this}}}
								 
							</span>
						</div>
						<div class="node-body-icon">
							<i class="fa fa-circle fa-sm"></i>
						</div>
					</div>-->
				</xhtml>
			</foreignObject>
			{{/ifEquals}}
	{{/ifEquals}} 
	{{/each}}	

		
	{{#each this.interfaces}}
	{{#ifEquals this.receivesFrom.0.name 'Fake1'}}
		<line style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
			<xsl:attribute name="x1">{{#getItemX 'Api1'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="x2">{{#getItemX 'Line1x2'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="y1">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
			<xsl:attribute name="y2">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
		</line>
		<foreignObject eas-type="fromInterfaceTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px"   width="20" class="lineClick">
			<xsl:attribute name="x">{{#getItemX 'Api1Info2'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="eas-int-id">{{id}}</xsl:attribute>
			<xsl:attribute name="eas-dep-id">{{dependencyId}}</xsl:attribute>
			<xsl:attribute name="y">{{#geticonAPILineRow this.num}}{{/geticonAPILineRow}}</xsl:attribute>
			<xsl:attribute name="height">20</xsl:attribute>
			<xhtml> 
					<div data-toggle="modal" class="node-body-icon">
						<i class="fa fa-info-circle fa-sm"></i>
					</div> 
			</xhtml>
		</foreignObject> 
	{{else}}
		<line style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
		  <xsl:attribute name="x1">{{#getItemX 'Line1'}}{{/getItemX}}</xsl:attribute>
		  <xsl:attribute name="x2">{{#getItemX 'Line1x2'}}{{/getItemX}}</xsl:attribute>
		  <xsl:attribute name="y1">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
		  <xsl:attribute name="y2">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
		</line>
		<!-- add info button to the left of the api-->
		<foreignObject eas-type="fromInterfaceSource" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px;" width="20" class="lineClick">
			<xsl:attribute name="x">{{#getItemX 'Api1Info'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="eas-int-id">{{id}}</xsl:attribute>
			<xsl:attribute name="eas-dep-id">{{receivesFrom.0.dependencyId}}</xsl:attribute>
			<xsl:attribute name="y">{{#geticonAPILineRow this.num}}{{/geticonAPILineRow}}</xsl:attribute>
			<xsl:attribute name="height">20</xsl:attribute>
			<xhtml> 
					<div class="node-body-icon" >
						<i class="fa fa-info-circle fa-sm"></i>
					</div> 
			</xhtml>
		</foreignObject>	
		<!-- add info button to the right of the api-->
		<foreignObject eas-type="fromInterfaceTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px"   width="20" class="lineClick">
			<xsl:attribute name="x">{{#getItemX 'Api1Info2'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="eas-int-id">{{id}}</xsl:attribute>
			<xsl:attribute name="eas-dep-id">{{dependencyId}}</xsl:attribute>
			<xsl:attribute name="y">{{#geticonAPILineRow this.num}}{{/geticonAPILineRow}}</xsl:attribute>
			<xsl:attribute name="height">20</xsl:attribute>
			<xhtml> 
					<div data-toggle="modal" class="node-body-icon">
						<i class="fa fa-info-circle fa-sm"></i>
					</div> 
			</xhtml>
		</foreignObject> 
		{{/ifEquals}}

		<!-- add api -->		
		<foreignObject class="apiBox"  height="25"  >
			<xsl:attribute name="style">width:{{#getItemWidth 'Api1'}}{{/getItemWidth}};white-space: nowrap; margin-right:3px;overflow: hidden; text-overflow: ellipsis; display: inline-block; vertical-align: bottom</xsl:attribute>		
			<xsl:attribute name="x">{{#getItemX 'Api1'}}{{/getItemX}}</xsl:attribute>	
			<xsl:attribute name="y">{{#getAPIRow this.num}}{{/getAPIRow}}</xsl:attribute>
			<xhtml><div>
				<xsl:attribute name="title">{{this.name}}</xsl:attribute>
				<i class="fa fa-exchange fa-rotate-90 fa-fw right-5"></i><span><xsl:attribute name="style">font-size:{{#getFont this.name}}{{/getFont}}em</xsl:attribute>{{{essRenderInstanceMenuLink this}}}</span></div>
				<!--
				<div class="node-rect wordwrap"><xsl:attribute name="style">width:{{#getItemWidth 'Api1'}}{{/getItemWidth}};height:25px</xsl:attribute>	
					<div class="node-title node-title-text">
						<span class="node-title-text">	
							 
							{{{essRenderInstanceMenuLink this}}}
						
						</span>
					</div>
					<div class="node-body-icon">
						<i class="fa fa-exchange"></i>
					</div>
				</div>
			-->
			</xhtml>
		</foreignObject>
	{{/each}}	

	{{#each this.values}}
    {{#if this.apiApp}}{{else}}
		  <line style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
		  <xsl:attribute name="x1">{{#getItemX 'Line1'}}{{/getItemX}}</xsl:attribute>
		  <xsl:attribute name="x2">{{#getItemX 'Line1x2'}}{{/getItemX}}</xsl:attribute>
		  <xsl:attribute name="y1">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  <xsl:attribute name="y2">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  </line> 
		  <foreignObject eas-type="fromSource" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" width="20" class="lineClick">
			<xsl:attribute name="x">{{#getItemX 'Api1i'}}{{/getItemX}}</xsl:attribute>  
 			<xsl:attribute name="eas-dep-id">{{dependencyId}}</xsl:attribute>
			<xsl:attribute name="y">{{#geticonLineRow this.num}}{{/geticonLineRow}}</xsl:attribute>
			<xsl:attribute name="height">20</xsl:attribute>
			<xhtml> 
					<div data-toggle="modal" class="node-body-icon">
						<i class="fa fa-info-circle fa-sm"></i>
					</div> 
			</xhtml>
		</foreignObject>	
        {{/if}}
		 {{/each}} 
 
		{{/each}} 


		{{#each this.to}}
			{{#each this.values}}
			{{#ifEquals @index 0}}
				<!-- to side -->
				{{#ifEquals this.name 'Fake1'}}
				{{else}}
				<foreignObject class="appBox"  >
					<xsl:attribute name="width">{{#getItemWidth 'App2'}}{{/getItemWidth}}</xsl:attribute>	
					<xsl:attribute name="x">{{#getItemX 'App2'}}{{/getItemX}}</xsl:attribute>
					<xsl:attribute name="y">{{#getRow this.num}}{{/getRow}}</xsl:attribute>
                    <xsl:attribute name="height">{{#if this.apiApp}}{{#getHeight 0 ../this.tointerfaces.length}}{{/getHeight}}{{else}}{{#getHeight ../this.values.length ../this.tointerfaces.length}}{{/getHeight}}{{/if}}</xsl:attribute> 
				<xhtml>
						<div>
							<xsl:attribute name="title">{{this.name}}</xsl:attribute>
							<span class="ess-truncate"><i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}</span></div>
					<!--	<div class="node-rect wordwrap">
							<xsl:attribute name="style">width: 190px; height: {{#getHeight ../this.values.length ../this.tointerfaces.length}}{{/getHeight}}px;</xsl:attribute>
							<div class="node-title">
								<span class="node-title-text">
									{{{essRenderInstanceMenuLink this}}}
								</span>
							</div>
							<div class="node-body-icon">
								<i class="fa fa-desktop"></i>
							</div>
						</div>
                        -->
					</xhtml>
				</foreignObject>
				{{/ifEquals}}
			{{/ifEquals}} 
			{{/each}}	
 
				
			{{#each this.tointerfaces}} 
			{{#ifEquals ../this.values.0.name 'Fake1'}}
				<line  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)" class="JOHN">
				<xsl:attribute name="x1">{{#getItemX 'Line2'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="x2">{{#getItemX 'Api2'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="y1">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
				<xsl:attribute name="y2">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>§
			</line>	
			{{else}}
			<line  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
				<xsl:attribute name="x1">{{#getItemX 'Line2'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="x2">{{#getItemX 'Line2x2'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="y1">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
				<xsl:attribute name="y2">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>§
			</line>	

				
			{{/ifEquals}} 
			<foreignObject eas-type="toInterfaceTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" width="20" class="lineClick"   >
				<xsl:attribute name="x">{{#getItemX 'Api2Info2'}}{{/getItemX}}</xsl:attribute>	
				<xsl:attribute name="eas-int-id">{{id}}</xsl:attribute>
				<xsl:attribute name="eas-dep-id">{{sendsTo.0.dependencyId}}</xsl:attribute> 
				<xsl:attribute name="y">{{#geticonAPILineRow this.num}}{{/geticonAPILineRow}}</xsl:attribute>
				<xsl:attribute name="height">20</xsl:attribute>
				<xhtml> 
					<div><i class="fa fa-info-circle fa-sm"></i> {{{essRenderInstanceMenuLink this}}} </div>
						<div class="node-body-icon">
							<i class="fa fa-info-circle  fa-sm"></i>
						</div> 
				</xhtml>
			</foreignObject>	


			{{#ifNotEquals ../this.values.0.name 'Fake1'}}			
			<foreignObject eas-type="toInterfaceSource" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" width="20" class="lineClick"   >
				<xsl:attribute name="x">{{#getItemX 'Api2Info'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="eas-int-id">{{id}}</xsl:attribute>
				<xsl:attribute name="eas-dep-id">{{dependencyId}}</xsl:attribute>
				<xsl:attribute name="y">{{#geticonAPILineRow this.num}}{{/geticonAPILineRow}}</xsl:attribute>
				<xsl:attribute name="height">20</xsl:attribute>
				<xhtml> 
						<div class="node-body-icon">
							<i class="fa fa-info-circle"></i>
						</div> 
				</xhtml>
			</foreignObject>
			{{/ifNotEquals}}
			<foreignObject  class="apiBox"  height="25"  >
				<xsl:attribute name="width">{{#getItemWidth 'Api2'}}{{/getItemWidth}}</xsl:attribute>	
				<xsl:attribute name="x">{{#getItemX 'Api2'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="y">{{#getAPIRow this.num}}{{/getAPIRow}}</xsl:attribute>
				<xhtml>
					<div>
						<xsl:attribute name="title">{{this.name}}</xsl:attribute>
						<i class="fa fa-exchange fa-rotate-90 fa-fw right-5"></i><span><xsl:attribute name="style">font-size:{{#getFont this.name}}{{/getFont}}em</xsl:attribute>{{{essRenderInstanceMenuLink this}}}</span></div>
					<!--<div class="node-rect wordwrap" style="width: 190px; height: 90px;">
						<div class="node-title">
							<span class="node-title-text">
								{{{essRenderInstanceMenuLink this}}}
							</span>
						</div>
						<div class="node-body-icon">
							<i class="fa fa-exchange"></i>
						</div>
					</div>
                    -->
				</xhtml>
			</foreignObject>

			{{/each}}	

	{{#each this.values}}
        {{#if this.apiApp}}{{else}}
		  <line  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)"  class="lineClick"   >
				<xsl:attribute name="x1">{{#getItemX 'Line2'}}{{/getItemX}}</xsl:attribute>
				<xsl:attribute name="x2">{{#getItemX 'Line2x2'}}{{/getItemX}}</xsl:attribute>
		  <xsl:attribute name="y1">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  <xsl:attribute name="y2">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  </line>
		  <foreignObject eas-type="toTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" width="20" class="lineClick"   >
			<xsl:attribute name="x">{{#getItemX 'Api2i'}}{{/getItemX}}</xsl:attribute>  
			<xsl:attribute name="eas-dep-id">{{dependencyId}}</xsl:attribute>
			<xsl:attribute name="y">{{#geticonLineRow this.num}}{{/geticonLineRow}}</xsl:attribute>
			<xsl:attribute name="height">20</xsl:attribute>
			<xhtml> 
					<div data-toggle="modal" class="node-body-icon">
						<i class="fa fa-info-circle"></i>
					</div> 
			</xhtml>
		</foreignObject>	
        {{/if}}
	{{/each}} 
 
{{/each}} 	s
<!-- middle focus app rect and text -->
		{{#checkMain this}} 
		<foreignObject class="hubAppModule" x="505" width="110"> 
			<xsl:attribute name="x">{{#getItemX 'Midpoint'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="y">0</xsl:attribute>
			<xsl:attribute name="height">{{#getFocusHeight this.tot 1}}{{/getFocusHeight}}</xsl:attribute>
			<xhtml>
				<div>
					<xsl:attribute name="title">{{this.name}}</xsl:attribute>
				 
					<i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}	<br/>
					<span class="moduleType">Module</span>
				</div>
			</xhtml>
		</foreignObject>
		{{else}}
		<foreignObject class="hubApp" x="505" width="110"> 
			<xsl:attribute name="x">{{#getItemX 'Midpoint'}}{{/getItemX}}</xsl:attribute>
			<xsl:attribute name="y">0</xsl:attribute>
			<xsl:attribute name="height">{{#getFocusHeight this.tot 1}}{{/getFocusHeight}}</xsl:attribute>
			<xhtml>
				<div>
					<xsl:attribute name="title">{{this.name}}</xsl:attribute>
				 
					<i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}	
		 
				</div>
			</xhtml>
		</foreignObject>
		{{/checkMain}}	
		</svg>

</script>	
<script>

<xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template>
var mainApp;
var focusApp={};
var infoViewPanelTemplate;
var depData, focusAppm, allAcqMethods, allSVCQualVals;
var dataSet=[];
var dependencyMap=[];
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

function setSQVals(obj) {
	let sqVals = obj.svcQualValIds?.map(sqvId => allSVCQualVals.find(sqv => sqv.id == sqvId));
	obj.svcQualVals = sqVals;
}

function setDepSvcQualVals(dep) {
	setSQVals(dep);
	dep.infoViews?.forEach(iv => {
		setSQVals(iv);
	});
	dep.infoReps?.forEach(ir => {
		setSQVals(ir);
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
 
	$('#model').empty();

	let appOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
	let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region');
	let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');
	let a2rScopingDef = new ScopingProperty('sA2R', 'ACTOR_TO_ROLE_RELATION'); 
 
	
 	scopedApps = essScopeResources(fullAppList, [appOrgScopingDef, geoScopingDef,a2rScopingDef, visibilityDef].concat(dynamicAppFilterDefs));
//	scopedCaps = essScopeResources(workingArrayAppsCaps, [appOrgScopingDef, geoScopingDef, visibilityDef, a2rScopingDef]);
  
thefocusApp={};

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
 
getInfoforApp(thefocusApp, DataSet)

$('#focus-app-name-lbl').text(thefocusApp.name);
mainApp=thefocusApp.id
setUpData(thefocusApp, totot, tot)
 
let getKids=fullAppList.find((f)=>{
	return f?.id==thefocusApp.id;
});
 
getKids.children?.forEach((c)=>{
 
let viewAPISubData=viewPath+c;
	Promise.all([
			promise_loadViewerAPIData(viewAPISubData) 
			]).then(function (responses)
			{	 
			let numArray=[];
			let thisApp=responses[0];
			if(thisApp.id!=thefocusApp.id){
			  thisApp['module']='true'; 
			}
	 
				getInfoforApp(thisApp, thisApp);
				setUpData(thisApp, totot, tot);
				//console.log('DEP DATA', depData);
			})
})


}

function getInfoforApp(theApp, dataFromAPI){
	let tfaDependencies=[];
let ttaDependencies=[];
let tfdaDependencies=[];
let ttdaDependencies=[];
dataFromAPI.dependencies.fromInterfaces.forEach((e)=>{
	let inscope;
	e.receivesFrom.forEach((f)=>{
		inscope=scopedApps.resourceIds.find((ap)=>{
		return f.id == ap;
		})
		
	})
	if(!e.infoViews){e["infoViews"]=[]}
		if(e.receivesFrom.length==0){
			e.receivesFrom.push({'className':'Composite_Application_Provider', 'id':'fake1', 'name':'Fake1'})
			
			dependencyMap.push({"depId":e.dependencyId,"debug":"fif", "source": e.name, "target": theApp.name,"infoReps":e.infoReps,"infoViews":e.infoViews});
			 inscope='fake';
		}else{
			dependencyMap.push({"depId":e.dependencyId,"debug":"fi", "source": e.name, "target": theApp.name,"infoReps":e.infoReps,"infoViews":e.infoViews});
			<!-- get other side of interface --> 
			
			if(e.receivesFrom[0].name){ 
				if(!e.receivesFrom[0].infoViews){e.receivesFrom[0]["infoViews"]=[]}
			dependencyMap.push({"depId":e.receivesFrom[0].dependencyId,"debug":"fi", "source": e.receivesFrom[0].name, "target": e.name,"infoReps": e.receivesFrom[0].infoReps,"infoViews": e.receivesFrom[0].infoViews});
			}
		
		}

		if(inscope){tfaDependencies.push(e)}
	 
	})
	theApp.dependencies['fromInterfaces']=tfaDependencies
	dataFromAPI.dependencies.toInterfaces.forEach((e)=>{
		
		let inscope;
		e.sendsTo.forEach((f)=>{
		 	inscope=scopedApps.resourceIds.find((ap)=>{
			return f.id == ap;
			})
		})
		if(!e.infoViews){e["infoViews"]=[]}
		if(e.sendsTo.length==0){
			e.sendsTo.push({'className':'Composite_Application_Provider', 'id':'fake1', 'name':'Fake1'});
			dependencyMap.push({"depId":e.dependencyId,"debug":"fif", "source":  theApp.name, "target": e.name,"infoReps":e.infoReps,"infoViews":e.infoViews});
			inscope='fake';
		}else{
 
			dependencyMap.push({"depId":e.dependencyId,"debug":"ti", "source":  theApp.name, "target": e.name, "infoReps":e.infoReps,"infoViews":e.infoViews});
		}
 
		if(e.sendsTo[0].name){ 
			if(!e.sendsTo[0].infoViews){e.sendsTo[0]["infoViews"]=[]}
			dependencyMap.push({"depId":e.sendsTo[0].dependencyId,"debug":"tip", "target": e.sendsTo[0].name, "source": e.name,"infoReps": e.sendsTo[0].infoReps,"infoViews": e.sendsTo[0].infoViews});
			}

		if(inscope){ttaDependencies.push(e)}
	})
	thefocusApp.dependencies['toInterfaces']=ttaDependencies

	dataFromAPI.dependencies.receivesFrom.forEach((e)=>{
		let inscope=scopedApps.resourceIds.find((ap)=>{
			return e.id == ap;
		})
		if(!e.infoViews){e["infoViews"]=[]}
		if(inscope){tfdaDependencies.push(e)}
		dependencyMap.push({"depId":e.dependencyId, "debug":"rf", "source": e.name, "target": theApp.name, "infoReps":e.infoReps,"infoViews":e.infoViews});
	})
	thefocusApp.dependencies['receivesFrom']=tfdaDependencies

	dataFromAPI.dependencies.sendsTo.forEach((e)=>{
		let inscope=scopedApps.resourceIds.find((ap)=>{
			return e.id == ap;
		})
		if(!e.infoViews){e["infoViews"]=[]}
		if(inscope){ttdaDependencies.push(e)}
		dependencyMap.push({"depId":e.dependencyId,"debug":"st", "source":  theApp.name, "target": e.name, "infoReps":e.infoReps,"infoViews":e.infoViews});
	})
	thefocusApp.dependencies['sendsTo']=ttdaDependencies
 
//setUpData(thefocusApp)
}



function setUpData(data, totot, tot){

	depData = data.dependencies;
	allAcqMethods = data.allAcqMethods;
	allSVCQualVals = data.allSVCQualVals;
	focusApp = {
		"id": data.id,
		"className": data.className,
		"name": data.name
	} 

	depData.receivesFrom?.forEach(src => {
		setDepAcqMethod(src);
		setDepSvcQualVals(src);
	});
	
	depData.sendsTo?.forEach(tgt => {
		setDepAcqMethod(tgt);
		setDepSvcQualVals(tgt);
	});
	
	depData.fromInterfaces?.forEach(ifc => {
		setDepAcqMethod(ifc);
		setDepSvcQualVals(ifc);
		ifc.receivesFrom?.forEach(src => {
			setDepAcqMethod(src);
			setDepSvcQualVals(src);
		});
	});
	
	depData.toInterfaces?.forEach(ifc => {
		setDepAcqMethod(ifc);
		ifc.sendsTo?.forEach(tgt => {
			setDepAcqMethod(tgt);
			setDepSvcQualVals(tgt);
		});
	});

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
		"svcQualValIds": f.svcQualValIds,
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
					"svcQualValIds": d.svcQualValIds,
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
					"svcQualValIds": d.svcQualValIds,
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
		  "svcQualValIds": f.svcQualValIds,
          "name": f.name,
          "usageId":f.usageId};
  
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
					"svcQualValIds": d.svcQualValIds,
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
					"svcQualValIds": d.svcQualValIds,
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
 
//console.log('tot',tot)
//console.log('totot',totot)
 
				dataSet['from']=appCount
				dataSet['to']=appToCount 
				let ht = Math.max(totot, tot)+2;
				dataSet['tot']=ht;
				dataSet['name']=data.name;
				dataSet['className']=data.className;
				dataSet['id']=data.id;
				if(data.module){
				dataSet['module']=data.module;
			}
	//console.log('All Dep Data', depData);
 
	//console.log('appCount',appCount)
	//console.log('appToCount',appToCount)
	//console.log('Data Set:', dataSet);
	redraw(dataSet)

}

const minFocusHeight = 140;
 var totot=0;
 var tot=0;
let totsArray=[];
$(document).ready(function() {
	let ww=wwidth
		let ifaceListFragment = $("#iface-list-template").html();
		ifaceListTemplate = Handlebars.compile(ifaceListFragment);

		let infoViewPanelFragment = $('#info-view-panel-template').html();
		infoViewPanelTemplate = Handlebars.compile(infoViewPanelFragment);
		
		let infoRepPanelFragment = $('#info-rep-panel-template').html();
		infoRepPanelTemplate = Handlebars.compile(infoRepPanelFragment);

		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});
		
		Handlebars.registerHelper('checkMain', function (arg1, options) {
		 
			return (arg1.id !== mainApp) ? options.fn(this) : options.inverse(this);
 
		});

		Handlebars.registerHelper('ifNotEquals', function (arg1, arg2, options) {
			return (arg1 != arg2) ? options.fn(this) : options.inverse(this);
		});

		Handlebars.registerHelper('getRow', function (arg1, options) {
			return (arg1 * 35)+5;
		});
		
		Handlebars.registerHelper('getAPIRow', function (arg1, options) {
			return (arg1 * 35)+5;
		});
		Handlebars.registerHelper('getAPIRowText', function (arg1, options) {
			return (arg1 * 35)+20;
		});
		
		Handlebars.registerHelper('getHeight', function (arg1, arg2, options) {
 
			let tot = arg1+arg2;
			return (tot * 34);
		});
		Handlebars.registerHelper('getItemWidth', function (arg1, options) {
			let ww=wwidth
			if(arg1=='Line'){
				return 300;
			}
			else{
				return ww*0.17
			}
		});
		Handlebars.registerHelper('getFont', function (arg1, options) {
			let boxWidthCharacter=(ww*0.17+10)/9.5;
		
			let nameCharacters=arg1.length; 
			if(nameCharacters &gt; boxWidthCharacter){
				return boxWidthCharacter/nameCharacters;
			}
			else{
				return 1
			}
		});
		
		Handlebars.registerHelper('getItemX', function (arg1, options) {
			let ww=wwidth
			if(arg1=='Line1'){
				return ww*0.17+10;
			}
			if(arg1=='Line1x2'){
				return (ww/2)-65;
			}
			else if(arg1=='Api1Info'){
				return (((ww/2)-55)/2)-40
			}
			else if(arg1=='Api1Info2'){
				return ((((ww/2)-55)/2)+ww*0.17)+20
			}
			else if(arg1=='Api1'){
				return ((ww/2)-55)/2
			}
			else if(arg1=='Midpoint'){
				return (ww/2)-55;
			}
			else if(arg1=='App2'){
				return ww-(ww*0.17+10)-40;
			}
			else if(arg1=='Line2'){
				return (ww/2)+55;;
			}
			else if(arg1=='Line2x2'){
				return (ww-(ww*0.17+10)-50);
			}
			else if(arg1=='Api2'){
				return (ww/2)+((ww*0.17)/2)
			}
			else if(arg1=='Api2Info'){
				return (ww/2)+((ww*0.17)/2)-40
			}
			else if(arg1=='Api2Info2'){
				return (((ww/2)+((ww*0.17)/2))+ww*0.17)+20
			}
			else if(arg1=='Api1i'){
				return (((ww/2)-65) - ((ww*0.17)+10))+55;
			}
			else if(arg1=='Api2i'){
				return ((((ww-(ww*0.17+10)-50)) - ((ww/2)+55))/2)+(ww/2)+55
			}
			
		});
 

		Handlebars.registerHelper('getWidth', function () {
		 
			return wwidth-40;
		});

		Handlebars.registerHelper('getFocusHeight', function (arg1, arg2, options) {
 
			let tot = arg1 ;
			return Math.max(minFocusHeight, (tot * 31));
		});
		
		Handlebars.registerHelper('getTextRow', function (arg1, options) {
			 return (arg1 * 35)+20;
		 });
	 
		
		<!-- Handlebars.registerHelper('getSVGHeight', function (arg1, arg2, options) {
			let tot = arg1+arg2
			return Math.max(400, (tot * 30)+20);
		}); -->
		Handlebars.registerHelper('getLineRow', function (arg1, options) {
			return (arg1 * 35)+12;
		});
		Handlebars.registerHelper('geticonLineRow', function (arg1, options) {
			return (arg1 * 35)+0;
		});

		Handlebars.registerHelper('getInfo', function (arg1, options) {
		 
			return ''
		});

		Handlebars.registerHelper('getAPILineRow', function (arg1, options) {
			return (arg1 * 35)+17;
		});
		Handlebars.registerHelper('geticonAPILineRow', function (arg1, options) {
			return (arg1 * 35)+5;
		});
		
		$('#info-exchanged-modal').off().on('show.bs.modal', function (e) {
			if(currentAppInfoExchange &amp;&amp; currentSource &amp;&amp; currentTarget) {
				$('#modal-source-name').text(currentAppInfoExchange.currentSource);
				$('#modal-target-name').text(currentAppInfoExchange.currentTarget);
				<!--let acqMethod = allAcqMethods.find(am => am.id == currentAppInfoExchange.acqMethodId);
				if(acqMethod) {
					$('#modal-acquisition-method').text(acqMethod?.label);
					$('#modal-acquisition-method').attr('class', 'label label-primary int-method-label');
				} else {
					$('#modal-acquisition-method').text('No integration method defined');
					$('#modal-acquisition-method').attr('class', 'text-italic');
				}-->
			//	console.log('ci',currentAppInfoExchange)
				if(currentAppInfoExchange.infoViews) {
					
					$('#modal-exchanged-info-container').html(infoViewPanelTemplate(currentAppInfoExchange.infoViews)).promise().done(function(){
						//info popover listener
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
				} else {
					$('#modal-exchanged-info-container').html(infoRepPanelTemplate(currentAppInfoExchange.infoReps)).promise().done(function(){

					});
				}
				
			}
		});

		$('#info-exchanged-modal').on('hidden.bs.modal', function (e) {
			currentAppInfoExchange = null;
			currentSource = null;
			currentTarget = null;
		});
	
		
})

var currentExchangeType, currentAppInfoExchange, currentSource, currentTarget;

function redraw(dataForMap){ 
 
	$('#model').append(ifaceListTemplate(dataForMap)).promise().done(function(){
		
		//add event listeners
		$('.lineClick').on('click', function(e) {
			currentAppInfoExchange=[];
			let thisDepId = $(this).attr('eas-dep-id');
	 
			currentExchangeType = $(this).attr('eas-type');
			let interfaceId = $(this).attr('eas-int-id');
 
			let selectedDep=dependencyMap.find((d)=>{
				return d.depId == thisDepId;
			})

			//console.log('Interface ID', interfaceId);

						 currentSource = selectedDep.source;
						 
						 currentAppInfoExchange['currentSource']=selectedDep.source;
						 currentAppInfoExchange['currentTarget']=selectedDep.target;
						 currentAppInfoExchange['infoReps'] = selectedDep.infoReps;	
						 if(selectedDep.infoViews.length&gt;0){

						 currentAppInfoExchange['infoViews'] = selectedDep.infoViews;	
						 }	
						currentTarget = selectedDep.target;	
 
			$('#info-exchanged-modal').modal('show');
		});
	});

	 
}

</script>	
		</html>
	</xsl:template>
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/>
			<xsl:param name="viewerAPIPathMart"/>
			let param1='<xsl:value-of select="$param1"/>';
			var viewPath='<xsl:value-of select="$viewerAPIPath"/>&amp;PMA=';
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
				fullAppList=responses[1].applications.concat(responses[1].apis).filter(app => app != null);
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
</xsl:stylesheet>
