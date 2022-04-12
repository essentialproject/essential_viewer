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
	<xsl:variable name="linkClasses" select="('Composite_Application_Provider', 'Application_Provider', 'Application_Provider_Interface', 'Information_View')"/>
	<xsl:variable name="apiPathDataAppDeps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Application Dependencies']"/>

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
					.eas-logo-spinner {​​​​​​​​
						display: flex;
						justify-content: center;
					}​​​​​​​​
					#editor-spinner {​​​​​​​​
						height: 100vh;
						width: 100vw;
						position: fixed;
						top: 0;
						left:0;
						z-index:999999;
						background-color: hsla(255,100%,100%,0.75);
						text-align: center;
					}​​​​​​​​
					#editor-spinner-text {​​​​​​​​
						width: 100vw;
						z-index:999999;
						text-align: center;
					}​​​​​​​​
					.spin-text {​​​​​​​​
						font-weight: 700;
						animation-duration: 1.5s;
						animation-iteration-count: infinite;
						animation-name: logo-spinner-text;
						color: #aaa;
						float: left;
					}​​​​​​​​
					.spin-text2 {​​​​​​​​
						font-weight: 700;
						animation-duration: 1.5s;
						animation-iteration-count: infinite;
						animation-name: logo-spinner-text2;
						color: #666;
						float: left;
					}​​​​​​​​
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
					width: 150px;
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
									<span class="text-darkgrey">Application Dependency Model - </span><span class="text-primary" id="focus-app-name-lbl"></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="simple-scroller">
								<div id="model"/>
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
			</xsl:call-template>
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
					<!--<div class="panel-body">
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
					</div>-->
				</div>
				{{/each}}
				{{else}}
				<p><em>No exchanged information defined</em></p>
				{{/if}}
			</script>

<script id="iface-list-template" type="text/x-handlebars-template">
						
	<svg width="1200px"><xsl:attribute name="height">{{#getFocusHeight this.tot 2}}{{/getFocusHeight}}</xsl:attribute>
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
			<foreignObject class="appBox"  x="10" width="190"  >
				<xsl:attribute name="y">{{#getRow this.num}}{{/getRow}}</xsl:attribute>
				<xsl:attribute name="height">{{#if this.apiApp}}{{#getHeight 0 ../this.interfaces.length}}{{/getHeight}}{{else}}{{#getHeight ../this.values.length ../this.interfaces.length}}{{/getHeight}}{{/if}}</xsl:attribute> 
				<xhtml>
					<div>
						<xsl:attribute name="title">{{this.name}}</xsl:attribute>
						<i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}} {{#getInfo this}}{{/getInfo}}</div>
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
	{{/each}}	

		
	{{#each this.interfaces}}

		<line x1="200"   x2="495"  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
		  <xsl:attribute name="y1">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
		  <xsl:attribute name="y2">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
		</line>
		<!-- add info button to the left of the api-->
		<foreignObject eas-type="fromInterfaceSource" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px;" x="220" width="20" class="lineClick">
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
		<foreignObject eas-type="fromInterfaceTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" x="460" width="20" class="lineClick">
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
		<!-- add api -->		
		<foreignObject class="apiBox" x="255" height="25" width="190"  >
			<xsl:attribute name="y">{{#getAPIRow this.num}}{{/getAPIRow}}</xsl:attribute>
			<xhtml><div>
				<xsl:attribute name="title">{{this.name}}</xsl:attribute>
				<i class="fa fa-exchange fa-rotate-90 fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}</div>
				<!--
				<div class="node-rect wordwrap" style="width: 190px; height:25px;">
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
 		 <line x1="200"   x2="495"  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
		  <xsl:attribute name="y1">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  <xsl:attribute name="y2">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  </line> 
		  <foreignObject eas-type="fromSource" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" x="340" width="20" class="lineClick">
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
				<foreignObject class="appBox"  x="905" width="190"  >
					<xsl:attribute name="y">{{#getRow this.num}}{{/getRow}}</xsl:attribute>
                    <xsl:attribute name="height">{{#if this.apiApp}}{{#getHeight 0 ../this.tointerfaces.length}}{{/getHeight}}{{else}}{{#getHeight ../this.values.length ../this.tointerfaces.length}}{{/getHeight}}{{/if}}</xsl:attribute> 
				<xhtml>
						<div>
							<xsl:attribute name="title">{{this.name}}</xsl:attribute>
							<i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}</div>
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
			{{/each}}	
 
				
			{{#each this.tointerfaces}} 
			<line x1="600"   x2="895"  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)">
				<xsl:attribute name="y1">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>
				<xsl:attribute name="y2">{{#getAPILineRow this.num}}{{/getAPILineRow}}</xsl:attribute>§
			</line>				
			<foreignObject eas-type="toInterfaceTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" x="850" width="20" class="lineClick"   >
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
			<foreignObject eas-type="toInterfaceSource" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" x="620" width="20" class="lineClick"   >
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
			<foreignObject  class="apiBox" x="650" height="25" width="190"  >
				<xsl:attribute name="y">{{#getAPIRow this.num}}{{/getAPIRow}}</xsl:attribute>
				<xhtml>
					<div>
						<xsl:attribute name="title">{{this.name}}</xsl:attribute>
						<i class="fa fa-exchange fa-rotate-90 fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}</div>
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
 		 <line x1="600"   x2="895"  style="stroke:#888;stroke-width:1" marker-end="url(#arrowhead)"  class="lineClick"   >
		  <xsl:attribute name="y1">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  <xsl:attribute name="y2">{{#getLineRow num}}{{/getLineRow}}</xsl:attribute>
		  </line>
		  <foreignObject eas-type="toTarget" style="background-color:rgb(255,255,255);border-radius:5px; padding:3px" x="740" width="20" class="lineClick"   >
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
 
{{/each}} 	
<!-- middle focus app rect and text -->
 
		<foreignObject class="hubApp" x="505" width="110">
			<xsl:attribute name="y">3</xsl:attribute>
			<xsl:attribute name="height">{{#getFocusHeight this.tot 1}}{{/getFocusHeight}}</xsl:attribute>
			<xhtml>
				<div>
					<xsl:attribute name="title">{{this.name}}</xsl:attribute>
					<i class="fa fa-desktop fa-fw right-5"></i>{{{essRenderInstanceMenuLink this}}}	
			<!--	<div class="node-rect wordwrap">
					<xsl:attribute name="style">width: 110px; height:{{#getHeight this.tot 1}}{{/getHeight}}px;</xsl:attribute>
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
				</div>
			</xhtml>
		</foreignObject>
		</svg>

</script>			
<script>

<xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
	<xsl:with-param name="linkClasses" select="$linkClasses"/>
</xsl:call-template>

var infoViewPanelTemplate;
var depData, focusAppm, allAcqMethods;

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

// DO FROM APPS
function setUpData(data){
	depData = data.dependencies;
	allAcqMethods = data.allAcqMethods;
	focusApp = {
		"id": data.id,
		"className": data.className,
		"name": data.name
	}
	$('#focus-app-name-lbl').text(focusApp.name);
	
	depData.receivesFrom?.forEach(src => {
		setDepAcqMethod(src);
	});
	
	depData.sendsTo?.forEach(tgt => {
		setDepAcqMethod(tgt);
	});
	
	depData.fromInterfaces?.forEach(ifc => {
		setDepAcqMethod(ifc);
		ifc.receivesFrom?.forEach(src => {
			setDepAcqMethod(ifc);
		});
	});
	
	depData.toInterfaces?.forEach(ifc => {
		setDepAcqMethod(ifc);
		ifc.sendsTo?.forEach(src => {
			setDepAcqMethod(ifc);
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
        "hasInfo": f.hasInfo,
        "id": f.id,
        "interfaces": f.interfaces,
        "acqMethodId": f.acqMethodId,
        "name": f.name,
        "usageId":f.usageId};

		interfaceFromApps.push(rxFr)
	});
});
 
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
                    "name": d.name,
                    "receivesFrom":d.receivesFrom,
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
                    "name": d.name,
                    "receivesFrom":d.receivesFrom,
                    "usageId":d.usageId
                     } 
		allInterfaces.push(thisi2)
	}
	});

// assign interfaces to apps
ap['interfaces']=allInterfaces;
});
<!-- start -->
interfacesToAdd.forEach((d)=>{
	appCount.push(d)
 });
 <!-- end -->

//remove duplicates

//indirectApps=indirectApps.filter((elem, index, self) => self.findIndex( (t) => {return (t.usageId === elem.usageId)}) === index)


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
          "interfaces": f.interfaces,
          "acqMethodId": f.acqMethodId,
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
                    "name": d.name,
                    "receivesFrom":d.receivesFrom,
                    "usageId":d.usageId
                     } 
		allToInterfaces.push(thisi2)
	}
	});
	//console.log('allToInterfaces',allToInterfaces)
// assign interfaces to apps
ap['tointerfaces']=allToInterfaces; 
});

let totot=0;

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
let tot=0;

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
let dataSet=[]
				dataSet['from']=appCount
				dataSet['to']=appToCount 
				let ht = Math.max(totot, tot)+12;
				dataSet['tot']=ht;
				dataSet['name']=data.name;
				dataSet['className']=data.className;

				dataSet['id']=data.id;
	//console.log('All Dep Data', depData);
	//console.log('ht',ht)
	//console.log('appCount',appCount)
	//console.log('appToCount',appToCount)
	//console.log('Data Set:', dataSet);
	redraw(dataSet)

}

const minFocusHeight = 400;

$(document).ready(function() {
		let ifaceListFragment = $("#iface-list-template").html();
		ifaceListTemplate = Handlebars.compile(ifaceListFragment);

		let infoViewPanelFragment = $('#info-view-panel-template').html();
		infoViewPanelTemplate = Handlebars.compile(infoViewPanelFragment);
		
		let infoRepPanelFragment = $('#info-rep-panel-template').html();
		infoRepPanelTemplate = Handlebars.compile(infoRepPanelFragment);

		Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
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
			return (tot * 30);
		});

		Handlebars.registerHelper('getFocusHeight', function (arg1, arg2, options) {
 
			let tot = arg1+arg2;
			return Math.max(minFocusHeight, (tot * 30));
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
			//console.log('arg1',arg1);
			return ''
		});

		Handlebars.registerHelper('getAPILineRow', function (arg1, options) {
			return (arg1 * 35)+17;
		});
		Handlebars.registerHelper('geticonAPILineRow', function (arg1, options) {
			return (arg1 * 35)+5;
		});
		
		$('#info-exchanged-modal').on('show.bs.modal', function (e) {
			if(currentAppInfoExchange &amp;&amp; currentSource &amp;&amp; currentTarget) {
				$('#modal-source-name').text(currentSource.name);
				$('#modal-target-name').text(currentTarget.name);
				<!--let acqMethod = allAcqMethods.find(am => am.id == currentAppInfoExchange.acqMethodId);
				if(acqMethod) {
					$('#modal-acquisition-method').text(acqMethod?.label);
					$('#modal-acquisition-method').attr('class', 'label label-primary int-method-label');
				} else {
					$('#modal-acquisition-method').text('No integration method defined');
					$('#modal-acquisition-method').attr('class', 'text-italic');
				}-->
				
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

function showEditorSpinner(message){
	$('#editor-spinner-text').text(message);                            
    $('#editor-spinner').removeClass('hidden');
};

function removeEditorSpinner(){
	$('#editor-spinner').addClass('hidden');
    $('#editor-spinner-text').text('');
	};
showEditorSpinner('Creating Diagram')
 

var currentExchangeType, currentAppInfoExchange, currentSource, currentTarget;

function redraw(dataForMap){
	showEditorSpinner('Drawing Diagram')
 
	$('#model').append(ifaceListTemplate(dataForMap)).promise().done(function(){
		removeEditorSpinner();
		//add event listeners
		$('.lineClick').on('click', function(e) {
			let thisDepId = $(this).attr('eas-dep-id');
			currentExchangeType = $(this).attr('eas-type');
			let interfaceId = $(this).attr('eas-int-id');
			//console.log('Interface ID', interfaceId);
			if(thisDepId &amp;&amp; currentExchangeType) {
				switch (currentExchangeType) {
					case 'fromSource':
						currentAppInfoExchange = depData.receivesFrom?.find(dep => dep.dependencyId == thisDepId);
						currentSource = currentAppInfoExchange;
						currentTarget = focusApp;
						break;
					case 'toTarget':
						currentAppInfoExchange = depData.sendsTo?.find(dep => dep.dependencyId == thisDepId);
						currentSource = focusApp;
						currentTarget = currentAppInfoExchange;
						break;
					case 'fromInterfaceSource':
						currentTarget = depData.fromInterfaces?.find(intfc => intfc.id == interfaceId);
						if(currentTarget) {
							currentAppInfoExchange = currentTarget.receivesFrom?.find(dep => dep.dependencyId == thisDepId);
							currentSource = currentAppInfoExchange;
						}						
						break;
					case 'fromInterfaceTarget':
						currentAppInfoExchange = depData.fromInterfaces?.find(intfc => intfc.id == interfaceId);						
						currentSource = currentAppInfoExchange;
						currentTarget = focusApp;
						break;
					case 'toInterfaceSource':
						currentSource = focusApp;
						currentAppInfoExchange = depData.toInterfaces?.find(intfc => intfc.id == interfaceId);		
						currentTarget = currentAppInfoExchange;		
						break;
					case 'toInterfaceTarget':				
						currentSource = depData.toInterfaces?.find(intfc => intfc.id == interfaceId);
						if(currentSource) {
							currentAppInfoExchange = currentSource.sendsTo?.find(dep => dep.dependencyId == thisDepId);
							currentTarget = currentAppInfoExchange;
						}						
						break;
					default:
						break;
				}
			}
			//console.log('Current Dep Type', currentExchangeType);
			//console.log('Current Dependency', currentAppInfoExchange);
			//console.log('Current Source', currentSource);
			//console.log('Current Target', currentTarget);
			$('#info-exchanged-modal').modal('show');
		});
	});

	 
}

</script>	
		</html>
	</xsl:template>
	<xsl:template name="RenderViewerAPIJSFunction">
			<xsl:param name="viewerAPIPath"/>
			let param1='<xsl:value-of select="$param1"/>';
			var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>&amp;PMA='+param1;
//console.log('viewAPIData',viewAPIData)
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
		

		$('document').ready(function () {

			Promise.all([
			promise_loadViewerAPIData(viewAPIData)
			]).then(function (responses)
			{
				removeEditorSpinner()
				//console.log('api',responses[0])
			 	setUpData(responses[0]);
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
