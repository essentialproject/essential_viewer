<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:user="http://www.enterprise-architecture.org/essential/vieweruserdata">
	<xsl:import href="WEB-INF/security/viewer_security.xsl"/>
	<xsl:include href="common/core_doctype.xsl"/>
	<xsl:include href="editors/common/editor_common_head_content.xsl"/>
	<xsl:include href="editors/common/editor_header.xsl"/>
	<xsl:include href="editors/common/editor_footer.xsl"/>
	<xsl:include href="common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:param name="EDITOR"/>
	<xsl:param name="X-CSRF-TOKEN"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->



	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	<xsl:variable name="targetEditor" select="$utilitiesAllEditors[name = $EDITOR]"/>
	<xsl:variable name="targetEditorLabel" select="$targetEditor/own_slot_value[slot_reference = 'report_label']/value"/>
	<xsl:variable name="targetEditorContent" select="$targetEditor/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
	<xsl:variable name="linkClasses" select="$targetEditor/own_slot_value[slot_reference = 'editor_menu_link_classes']/value"/>
	<xsl:variable name="editorLinkMenus" select="$utilitiesAllMenus[(own_slot_value[slot_reference = 'report_menu_is_default']/value = 'true') and (own_slot_value[slot_reference = 'report_menu_class']/value = $linkClasses)]"/>
	<xsl:variable name="editorForClasses" select="$targetEditor/own_slot_value[slot_reference = 'simple_editor_for_classes']/value"/>
	
	<!-- Get the list of supporting data set APIs -->
	<xsl:variable name="supportingAPIs" select="$utilitiesAllDataSetAPIs[name = $targetEditor/own_slot_value[slot_reference = 'editor_data_set_apis']/value]"/>

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
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderEditorInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title><xsl:value-of select="$targetEditorLabel"/></title>
				<!--<script src="js/rocket-loader/js/loader.min.js"/>
				<link href="js/rocket-loader/css/loader.min.css" rel="stylesheet"/>	-->	
			</head>
			<body id="main_section">
				<!-- Loader -->
				<div id="editor-spinner" class="hidden">
					
					<div class="hm-spinner"/>
					<div id="editor-spinner-text" class="text-center xlarge strong"/>
				</div>
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="mode">EDIT</xsl:with-param>
				</xsl:call-template>
					<xsl:choose>
						<xsl:when test="doc-available($targetEditorContent)">
							<xsl:copy-of select="document($targetEditorContent)"/>
						</xsl:when>
						<xsl:otherwise>			
							<xsl:copy-of select="document('editors/platform/editor_not_found_error.html')"/>
							<p><xsl:value-of select="$targetEditorContent"/></p>
						</xsl:otherwise>
					</xsl:choose>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<!-- modal javascript library -->
				<script src="js/lightbox-master/ekko-lightbox.min.js"/>
				<link href="js/lightbox-master/ekko-lightbox.min.css" rel="stylesheet" type="text/css"/>
				
				<!-- Lodash utility functions -->
				<script type="text/javascript" src="js/lodash.js"/>
				
				<!-- Handlebars UI Templating Libraries -->
				<script src="js/handlebars-v4.1.2.js"/>
				
				<!-- setup editor environment -->
				<script type="text/javascript">
					'use strict';

					// define the global object to hold environment variables
					// note we have to define this script in-line to make use of the xsl values
					var essEnvironment = {};
					
					//define the details for the current user
					var essUserDets = {
						'id': '<xsl:value-of select="$userData//user:email"/>',
						'firstName': '<xsl:value-of select="$userData//user:firstname"/>',
						'lastName': '<xsl:value-of select="$userData//user:lastname"/>'
					};

					essEnvironment.repoId = '<xsl:value-of select="repository/repositoryID"/>';
					essEnvironment.baseUrl = '<xsl:value-of select="replace(concat(substring-before($theURLFullPath, '/report?'), ''), 'http://', 'https://')"></xsl:value-of>';

					essEnvironment.csrfToken = '<xsl:value-of select="$X-CSRF-TOKEN"/>';
					essEnvironment.form = {
						'id': '<xsl:value-of select="$targetEditor/name"/>',
						'name': '<xsl:value-of select="$targetEditor/own_slot_value[slot_reference = 'name']/value"/>'
					};
					
					var essDataSetAPIs = {
						<xsl:apply-templates mode="RenderDataSetAPIDetails" select="$supportingAPIs"/>
					};
					
					function essGetDataSetAPIUrl(dataSetLabel) {
						var apiURL = essDataSetAPIs[dataSetLabel];
						return apiURL;
					}
					
					var esslinkMenuNames = {
						<xsl:apply-templates mode="RenderClassMenu" select="$linkClasses"/>
					}
					
					var essEditorForClasses = [<xsl:apply-templates mode="RenderClassList" select="$editorForClasses"/>];
					
					
					
					function essGetMenuName(instance) {
						let menuName = null;
						if((instance != null) &amp;&amp; (instance.meta != null) &amp;&amp; (instance.meta.anchorClass != null)) {
							menuName = esslinkMenuNames[instance.meta.anchorClass];
						}
						return menuName;
					}
					
					const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
					
					Handlebars.registerHelper('essRenderInstanceLink', function(instance){
						if(instance != null) {
							let linkMenuName = essGetMenuName(instance);
							let instanceLink = instance.name;
							if(linkMenuName != null) {
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
					
					
					Handlebars.registerHelper('essInstanceStyle', function(instance, styleProperty, options){
						if((instance != null) &amp;&amp; (instance.styles != null) &amp;&amp; (instance.styles.length > 0) &amp;&amp; (instance.styles[0][styleProperty] != null)) {							
							return instance.styles[0][styleProperty];
					  	} else {
					  		return '';
					  	}
					});
					
					var essTableLinkTemplate;
					$('document').ready(function(){
						let essTableLinkFragment = $("#ess-table-link-template").html();
			    		essTableLinkTemplate = Handlebars.compile(essTableLinkFragment);
		    		});
				</script>

				<!-- main script -->
				<script type="module" src="./editors/assets/js/ess_editor.js" />
				
				<!-- Handlebars template for the contents of the CONFIRM ACTION Modal -->
				<script id="ess-confirm-modal-template" type="text/x-handlebars-template">
					<div class="modal-header">
						<p class="modal-title xlarge" id="essConfirmModalLabel"><i class="fa fa-exclamation-triangle right-10"/><strong><span>{{title}}{{#if resource.name}}: {{/if}}</span><span class="text-primary">{{resource.name}}</span></strong></p>
					</div>
					<div class="modal-body">
						{{#each messages}}
							<p>{{this}}</p>
						{{/each}}
					</div>
					<div class="modal-footer">
						<button type="button" id="essCancelBtn" class="btn btn-danger right-5"><xsl:value-of select="eas:i18n('No')"/></button>
						<button type="button" id="essConfirmBtn" class="btn btn-success">
							<xsl:value-of select="eas:i18n('Yes')"/>
						</button>
					</div>
				</script>
				
				<!-- Div for the CONFIRM ACTION modal -->
				<div class="modal fade" id="essConfirmModal" tabindex="-1" role="dialog" aria-labelledby="essConfirmModalLabel" data-backdrop="static" data-keyboard="false">
					<div class="modal-dialog">
						<div class="modal-content" id="essConfirmModalContent"/>				
					</div>
				</div>
				
				
				<!-- Handlebars template for the contents of the CREATE RESOURCE Modal -->
				<script id="ess-create-modal-template" type="text/x-handlebars-template">
					<div class="modal-header">
						<p class="modal-title xlarge" id="essCreateModalLabel"><i class="fa fa-exclamation-triangle right-10"/><strong><span>New </span><span class="text-primary">{{resourceTypeLabel}}</span></strong></p>
					</div>
					<div class="modal-body">
						<div class="col-xs-12">
							<label for="ess-create-name" class="fontBold">Name</label>
							<textarea id="ess-create-name"  class="bottom-10" placeholder="Enter a name"/>
						</div>
						<div class="col-xs-12">
							<label for="ess-create-desc" class="fontBold">Description</label>
							<textarea id="ess-create-desc" placeholder="Enter a description"/>
						</div>
						<div>
							<p id="ess-create-error" class="ess-modal-error"/>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" id="essCreateCancelBtn" class="btn btn-danger right-5"><xsl:value-of select="eas:i18n('Cancel')"/></button>
						<button type="button" id="essCreateBtn" class="btn btn-success">
							<xsl:value-of select="eas:i18n('Create')"/>
						</button>
					</div>
				</script>
				
				
				<!-- Div for the CREATE RESOURCE modal -->
				<div class="modal fade" id="essCreateModal" tabindex="-1" role="dialog" aria-labelledby="essCreateModalLabel" data-backdrop="static" data-keyboard="false">
					<div class="modal-dialog">
						<div class="modal-content" id="essCreateModalContent"/>				
					</div>
				</div>
				
				
				<!-- Handlebars template for the contents of the ERROR Modal -->
				<script id="ess-error-modal-template" type="text/x-handlebars-template">
					<div class="modal-header">
						<p class="modal-title large" id="essErrorModalLabel"><i class="fa fa-exclamation-circle icon-section textColourRed right-5"/><strong><span class="text-darkgrey">{{title}}</span></strong></p>
					</div>
					<div class="modal-body">
						{{#each messages}}
							<p>{{this}}</p>
						{{/each}}
					</div>
					<div class="modal-footer">
						<button type="button" id="essErrorCloseBtn" class="btn btn-success">
							<xsl:value-of select="eas:i18n('Close')"/>
						</button>
					</div>
				</script>
				
				<!-- Handlebars template for displaying a popup link in a table cell -->
				<script id="ess-table-link-template" type="text/x-handlebars-template">
					<span>{{{essRenderInstanceLink this}}}</span>
				</script>
				
				<!-- Div for the ERROR modal -->
				<div class="modal fade" id="essErrorModal" tabindex="-1" role="dialog" aria-labelledby="essErrorModalLabel" data-backdrop="static" data-keyboard="true">
					<div class="modal-dialog">
						<div class="modal-content" id="essErrorModalContent"/>				
					</div>
				</div>
				
			</body>
		</html>
	</xsl:template>
	
	<xsl:template mode="RenderDataSetAPIDetails" match="node()">
		<!-- Get the URL path for the data set -->
		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="current()/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Get the property label to be used for accessing the data set details -->
		<xsl:variable name="dataSetLabel" select="current()/own_slot_value[slot_reference = 'dsa_data_label']/value"/>
		"<xsl:value-of select="$dataSetLabel"/>": "<xsl:value-of select="$dataSetPath"/>"<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template mode="RenderClassMenu" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisMenus" select="$editorLinkMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
		
		"<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	
	<xsl:template mode="RenderClassList" match="node()">
		<xsl:variable name="this" select="current()"/>
		"<xsl:value-of select="$this"/>"<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

</xsl:stylesheet>
