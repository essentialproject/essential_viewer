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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"></xsl:variable>

 
	<xsl:variable name="allGA" select="/node()/simple_instance[type = 'Group_Actor']"></xsl:variable>

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
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title>Data Object Recursion</title>
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
					.app{
						position: relative;
						height: 40px;
						width: 160px;
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
					}
					
					.app:hover{
						border: 1pt solid #666;
						box-shadow: 0 1px 2px rgba(0,0,0,0.25);
					}
					
					.appContainer {
						display: flex;
						margin-top: 10px;
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
					.capTitle {
						font-weight: 600;
					}
					.appTitle {
						text-align: center;
					}
				</style>
				<!-- <xsl:call-template name="refModelStyles"/>		-->
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid" width="100%">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey">Group Actor Recursion</span>
								</h1>
							</div>
						</div>
					
						<div class="col-xs-12">	
							<div id="area"/>
						</div>
					</div>
				</div>
				

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
			<script id="model-template" type="text/x-handlebars-template">
				{{#each this}}
					<div class="capContainer bottom-30" width="100%">
						<div class="capTitleLarge">{{this.name}}</div>
							<div class="clearfix"/>
							
							<div class="clearfix"/>
						{{> partialTemplate}}
					</div>
				{{/each}}
			</script>				
			<script id="model-partial-template" type="text/x-handlebars-template">
				{{#each this.children}}
					<div class="capContainer bottom-15" width="100%"><xsl:attribute name="style">background-color:{{this.colour}}</xsl:attribute>
						<div class="capTitle">{{this.name}}</div>
						<div class="clearfix"/>
						<div class="clearfix"/>
						{{> partialTemplate}}
						</div>
					{{/each}} 
			</script>
			<script>
					var dataObject = [<xsl:apply-templates select="$allGA" mode="groupActors"><xsl:with-param name="depth" select="0"/></xsl:apply-templates>];
					
				console.log(dataObject)
					$(document).ready(function() {
						var modelFragment = $("#model-template").html();
						var modelTemplate = Handlebars.compile(modelFragment);
						templateFragment = $("#model-partial-template").html();
						partialTemplate = Handlebars.compile(templateFragment);
						Handlebars.registerPartial('partialTemplate', partialTemplate)


					$('#area').html(modelTemplate(dataObject));
				});
		 
			
			</script>	
			
		</html>
	</xsl:template>
	<xsl:template match="node()" mode="groupActors">
		<xsl:param name="depth"/>
		<xsl:variable name="specialisation" select="$allGA[name = current()/own_slot_value[slot_reference = 'contained_sub_actors']/value]"></xsl:variable>
	 
		{"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", 
		"name": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>",  
		"special":"<xsl:value-of select="$specialisation/name"/>",
		"level":"<xsl:value-of select="$depth"/>","children": [<xsl:if test="$depth &lt; 10"><xsl:apply-templates select="$specialisation" mode="groupActors"><xsl:with-param name="depth" select="$depth +1"/></xsl:apply-templates></xsl:if>] }<xsl:if test="not(position() = last())"><xsl:text>,
		</xsl:text></xsl:if>
	</xsl:template>

</xsl:stylesheet>
