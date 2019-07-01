<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<xsl:variable name="linkClasses" select="('')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	<xsl:variable name="targetEditor" select="$utilitiesAllEditors[name = $EDITOR]"/>
	<xsl:variable name="targetEditorLabel" select="$targetEditor/own_slot_value[slot_reference = 'report_label']/value"/>
	<xsl:variable name="targetEditorContent" select="$targetEditor/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>

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
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
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
					const essEnvironment = {};

					essEnvironment.repoId = '<xsl:value-of select="repository/repositoryID"/>';
					essEnvironment.baseUrl = '<xsl:value-of select="replace(concat(substring-before($theURLFullPath, '/report?'), ''), 'http://', 'https://')"></xsl:value-of>';

					essEnvironment.csrfToken = '<xsl:value-of select="$X-CSRF-TOKEN"/>';
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
							<p class="lead">{{this}}</p>
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
				
				<!-- Div for the ERROR modal -->
				<div class="modal fade" id="essErrorModal" tabindex="-1" role="dialog" aria-labelledby="essErrorModalLabel" data-backdrop="static" data-keyboard="true">
					<div class="modal-dialog">
						<div class="modal-content" id="essErrorModalContent"/>				
					</div>
				</div>
				
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
