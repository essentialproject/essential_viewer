<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:param name="X-CSRF-TOKEN"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
    <xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process','Group_Actor')"/>
	
	
	<!-- END GENERIC LINK VARIABLES -->
	
	<!-- START VIEW SPECIFIC VARIABLES -->
	<!-- Get available Widgets -->
	<xsl:variable name="allWidgets" select="/node()/simple_instance[own_slot_value[slot_reference = 'pw_is_enabled']/value = 'true']"/>
	<xsl:variable name="allWidgetTags" select="/node()/simple_instance[name = $allWidgets/own_slot_value[slot_reference = 'element_classified_by']/value]"/>

	<!-- Get relevant Widget Templates -->
	<xsl:variable name="allWidgetTemplates" select="/node()/simple_instance[name = $allWidgets/own_slot_value[slot_reference = 'pw_widget_template']/value]"/>
	
	<!-- Get relevant Data Set APIs -->
	<xsl:variable name="allDataSetAPIs" select="/node()/simple_instance[name = $allWidgets/own_slot_value[slot_reference = 'pw_data_set_api']/value]"/>
	
	<!-- Get available Themes -->
	<xsl:variable name="allWidgetThemes" select="/node()/simple_instance[type = 'Widget_Theme']"/>
	<xsl:variable name="allWidgetThemeStyles" select="/node()/simple_instance[name = $allWidgetThemes/own_slot_value[slot_reference = 'pwt_styles']/value]"/>
	<xsl:variable name="allWidgetThemeStyleClasses" select="/node()/simple_instance[name = $allWidgetThemeStyles/own_slot_value[slot_reference = 'pws_styled_class']/value]"/>
	<xsl:variable name="allWidgetThemeColours" select="/node()/simple_instance[name = $allWidgetThemes/own_slot_value[slot_reference = 'pwt_category_colour_scheme']/value]"/>
	
	
	<!-- END VIEW SPECIFIC VARIABLES -->
	
	
	<!--<xsl:variable name="testAPI" select="/node()/simple_instance[type='Data_Set_API'][own_slot_value[slot_reference = 'name']/value = 'Test API']"/>
	<xsl:variable name="testAPIPath">
		<xsl:call-template name="RenderLinkText">
			<xsl:with-param name="theXSL" select="$testAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>-->
	
    

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
					</xsl:call-template>
				</xsl:for-each>

				<xsl:call-template name="dataTablesLibrary"/>
				<title><xsl:value-of select="eas:i18n('CxO Presentation Generator')"/></title>
				
				<!-- d3 library -->
				<script src="js/d3/d3.v5.9.7.min.js"/>
				<script src="js/d3/d3-selection-multi.min.js"/>
				
				<!-- filepond file upload library -->
				<link href="js/filepond/filepond.min.css" rel="stylesheet"/>
				<script src="js/filepond/filepond.min.js"/>
				<script src="js/filepond/filepond-plugin-file-validate-type.min.js"/>
				
				<!-- modal javascript library -->
				<script src="js/lightbox-master/ekko-lightbox.min.js"/>
				<link href="js/lightbox-master/ekko-lightbox.min.css" rel="stylesheet" type="text/css"/>
				
				<script type="text/javascript">
					$(document).delegate('*[data-toggle="lightbox"]', 'click', function(event) {
					    event.preventDefault();
					    $(this).ekkoLightbox({always_show_close: false});
					}); 
				</script>

				<!-- Start Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
								
				
				<!-- Start widget template files -->
				<xsl:apply-templates mode="RenderWidgetTemplateFileImport" select="$allWidgetTemplates"/>
				<!--<script src="svg-widget-templates/core-static-donut-widget.js"/>-->			
				
				<!-- Start widget files -->
				<xsl:apply-templates mode="RenderWidgetFileImport" select="$allWidgets"/>
				<!--<script src="application/widgets/core-al-app-dep-model-donut.js"/>-->
				
				
				<style type="text/css">
	
					.infoButton{
						position: absolute;
						bottom: 3px;
						right: 3px;
					}
					
					.fa-info-circle:hover {cursor: pointer;}					
					
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}
					
					.pl_action_button {
						width: 70px;
						padding: 2px;
					}
					
					.modal_action_button {
						width: 110px;
					}
					
					.modal-icon {
						opacity: 0.8;
					}

					.actionSelected { 
						background-color: hsla(220, 70%, 85%, 1) !important;
					}
					
					
					@media (min-width: 768px) {
					  .modal .modal-xl {
					    width: 90%;
					   max-width:1200px;
					  }
					  
					  .modal .modal-med {
					    width: 50%;
					   	max-width:600px;
					  }
					}
					
					.widget-preview-select:hover {
						cursor: pointer;
						background:#dddddd;
					}
					
					.widget-preview-selected {
						background:#f3f3f3 !important;
					}
					
					.widget-preview-selected:hover {
						cursor: auto !important;
					}
					
					.widget-preview-div {
						border: 1px solid #cccccc;
						padding: 10px;
					}
				</style>
				<xsl:call-template name="RenderMyWidgetsCSS"/>
				<xsl:call-template name="RenderMyPresentationsStyles"/>
				
			</head>
			<body>					
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<!-- Handlebars template for the contents of the Widget Text Editor Modal -->
					<script id="widget-text-editor-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
							<p class="modal-title xlarge" id="widgetTextEditorLabel"><i class="modal-icon right-10 text-primary fa fa-pencil"></i><strong><span class="text-darkgrey"><xsl:value-of select="eas:i18n('Customise Widget')"/>: </span><span class="text-primary">{{name}}</span></strong></p>
							<p>{{description}}</p>
							<div class="clearfix"></div>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-xs-12">
									<div class="pull-left">
										<p class="impact large"><i class="fa fa-comment right-5"/><xsl:value-of select="eas:i18n('Custom Text')"/></p>
										<p class="small pull-left">
											<em><xsl:value-of select="eas:i18n('The following text values can be updated')"/>:</em>
										</p>
									</div>
									<div class="clearfix"></div>
									<form>
							          <div class="form-group" id="widget-text-editor-form">
							          	{{#each customText}}
								            <label class="col-form-label"><xsl:attribute name="for">{{id}}Input</xsl:attribute>{{label}}:</label>
								            <input type="text" class="form-control widget-text-editor-input bottom-10">
								            	<xsl:attribute name="id">{{id}}Input</xsl:attribute>
								            	<xsl:attribute name="value">{{text}}</xsl:attribute>
								            </input>
							          	{{/each}}
							          </div>
							        </form>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-danger" data-dismiss="modal"><xsl:value-of select="eas:i18n('Cancel')"/></button>
							<button type="button" class="saveWidgetTextBtn btn btn-success"><xsl:value-of select="eas:i18n('Update')"/></button>
						</div>
					</script>
					
					<!-- Widget Text Editor Modal -->
					<div class="modal fade" id="widgetTextEditorModal" tabindex="-1" role="dialog" aria-labelledby="widgetTextEditorLabel">
						<div class="modal-dialog modal-xl" role="document">
							<div class="modal-content" id="widgetTextEditorModelContent"/>						
						</div>
					</div>
					
					
					<!-- Handlebars template for the contents of the Confirmation Modal -->
					<script id="confirm-modal-template" type="text/x-handlebars-template">
						<div class="modal-header">
							<p class="modal-title large" id="confirmModalLabel"><strong><span class="text-darkgrey">{{title}}{{#if subject.name}}: {{/if}}</span><span class="text-primary">{{subject.name}}</span></strong></p>
						</div>
						<div class="modal-body">
							{{#each messages}}
								<p>{{this}}</p>
							{{/each}}
						</div>
						<div class="modal-footer">
							<button type="button" class="cancelConfirmBtn btn btn-secondary"><xsl:value-of select="eas:i18n('No')"/></button>
							<button type="button" class="confirmBtn btn btn-primary">
								<xsl:value-of select="eas:i18n('Yes')"/>
							</button>
						</div>
					</script>
					
					
					<!-- Confirmation Modal -->
					<div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="confirmModalLabel" data-backdrop="static" data-keyboard="false">
						<div class="modal-dialog modal-sm">
							<div class="modal-content" id="confirmModalContent"/>				
						</div>
					</div>
					
					
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Presentation Manager')"/></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<ul class="nav nav-tabs" role="tablist">							
								<li role="presentation" class="active">
									<a id="selectWidgetsTab" href="#step1" data-toggle="tab" aria-controls="step1" role="tab">
										<span class="round-tab">
											<i class="fa fa-folder-open right-10"/>Select My Widgets
										</span>
									</a>
								</li>
								
								<li role="presentation">
									<a id="previewWidgetsTab" href="#step2" data-toggle="tab" aria-controls="step2" role="tab">
										<span class="round-tab">
											<i class="fa fa-edit right-10"/>Customise Widgets
										</span>
									</a>
								</li>
								<li role="presentation">
									<a id="myPresTab" href="#step3" data-toggle="tab" aria-controls="step3" role="tab">
										<span class="round-tab">
											<i class="fa fa-file-image-o right-10"/>Create My Presentation
										</span>
									</a>
								</li>
							</ul>
								
								
							<form role="form">
								<div class="tab-content">
									<div class="tab-pane active" role="tabpanel" id="step1">
										<xsl:call-template name="RenderMyWidgetsTab"/>
									</div>
									<div class="tab-pane" role="tabpanel" id="step2">
										<xsl:call-template name="RenderWidgetPreviewSection"/>
									</div>
									<div class="tab-pane" role="tabpanel" id="step3">
										<xsl:call-template name="RenderMyPresentationsSection"/>
									</div>
									<div class="clearfix"></div>
								</div>
							</form>
							
						</div>			
						<div class="col-xs-12">
							<hr/>
						</div>
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<!-- Date formatting library -->
				<script type="text/javascript" src="js/moment/moment.js"/>
				
				<!-- zip library -->
				<script type="text/javascript" src="js/jszip/jszip.min.js"/>
				
				<!-- file saver library -->
				<script type="text/javascript" src="js/FileSaver.min.js"/>
				
                <script>
                	var widgetSelectionTemplate, widgetPreviewTemplate, widgetEditTemplate, widgetTextEditorTemplate, presentationEditorTemplate, presItemTemplate, slideEditorTemplate, slideTemplate, slideWidgetTemplate, confirmModalTemplate, selectedWidgetTemplate, realSlideTemplate, filePond;
					
					// define the global object to hold environment variables
					// note we have to define this script in-line to make use of the xsl values
					var presentationEnvironment = {};
					presentationEnvironment.baseUrl = '<xsl:value-of select="replace(concat(substring-before($theURLFullPath, '/report?'), ''), 'http://', 'https://')"></xsl:value-of>';
					presentationEnvironment.csrfToken = '<xsl:value-of select="$X-CSRF-TOKEN"/>';


					var SLIDE_HEIGHT = 800;
				  	var SLIDE_WIDTH = 450;
				
				  	var MAX_TRANSLATE_X = SLIDE_WIDTH / 2;
				  	var MIN_TRANSLATE_X = -MAX_TRANSLATE_X;
				  	
				  	var MAX_TRANSLATE_Y = SLIDE_HEIGHT / 2;
  					var MIN_TRANSLATE_Y = -MAX_TRANSLATE_Y;
  					
  					var MIN_RECT_WIDTH = 100;
					
					var HANDLE_R = 5;
  					var HANDLE_R_ACTIVE = 10;
					
					var selectedWidgetIds = [];
					var selectedWidgets = {
						widgets: []
					};
					
					var confirmSubject;
					
					var uploadTemplate = function() {
						// check if we have a file and idle (so not still uploading or error with the file)
						// before uploading the template
						if (filePond.getFile() &amp;&amp; filePond.getFile().status === FilePond.FileStatus.IDLE) {
							console.log(filePond.getFile().file);
							// upload the template
							var formData = new FormData()
							formData.append("template", filePond.getFile().file);

							var url = presentationEnvironment.baseUrl+'/api/essential-presentation/template/default';
							var xhr = createCORSRequest('PUT', url, presentationEnvironment.csrfToken);
							if (!xhr) {
								throw new Error('CORS not supported');
							} else {
								// Response handlers.
								var success = function(){
									// TODO add success banner
								};
								var failure = function(){
									// TODO show error message
								};
								xhr.onload = onXhrLoad(xhr, success, failure);
								xhr.onerror = failure;
								xhr.send(formData);
							}
						}
					}

					//anonymous function to remove a bound Widget from the My Widgets library
					var deselectWidgetFunc = function() {
						var confirmObj = this;
						confirmObj.relatedElement.parent().fadeOut(400, function(){
							confirmObj.relatedElement.remove();
							
							var confirmedWidget = confirmObj.subject;
							if(confirmedWidget != null) {
								var widgetIndex = selectedWidgetIds.indexOf(confirmedWidget.id);
								if(widgetIndex > -1) {
									$("#" + confirmedWidget.id + "_atc").html('SELECT')
										.removeClass('added_to_cart');
									selectedWidgetIds.splice(widgetIndex, 1);
									selectedWidgets.widgets.splice(widgetIndex, 1);
									if(selectedPreview.id == confirmedWidget.id) {
										selectedPreview = null;
									};
									removeSlideWidgets(confirmedWidget);
									$('#widget-total').text('MY WIDGETS (' + selectedWidgets.widgets.length + ')');
									if(selectedWidgetIds.length == 0) {
										$("#cart .empty").fadeIn(300);
									}
								}
							}
						})
					};
					
					//function to remove the given widget from Presentations
					function removeSlideWidgets(aWidget) {
						var presIds = Object.keys(aWidget.presentations);
						var aPres, aPresWidgetUsage, slideWidgets, aSlide, aSlideWidget;
						for (var i = 0; presIds.length > i; i += 1) {
							aPresWidgetUsage = aWidget.presentations[presIds[i]];
							aPres = aPresWidgetUsage.presentation;
							slideWidgets = Object.values(aPresWidgetUsage.widgets);
							
							for (var j = 0; slideWidgets.length > j; j += 1) {
								aSlideWidget = slideWidgets[j];
								aSlide = aPres.slides[aSlideWidget.slideId];
								delete aSlide.slideWidgets[aSlideWidget.id];
								//console.log('Deleting slide widget from: ' + Object.keys(aSlide.slideWidgets).length);
							}
						}
						aWidget.presentations = {};
					}
					
					
					function deletePresentation(presDiv) {
						var presId = presDiv.attr('eas-id');
						var aPres = userData.presentations[presId];
						
						if(aPres != null) {
							var thisMessages = [];
							thisMessages.push('<xsl:value-of select="eas:i18n('Are you sure that you want to remove this presentation?')"/>');
							
							confirmSubject = {
								'title': '<xsl:value-of select="eas:i18n('Delete Presentation')"/>',
								'subject': aPres,
								'messages': thisMessages,
								'relatedElement': presDiv,
								'action': null
							};
							
							var boundAction = deletePresentationFunc.bind(confirmSubject);
							confirmSubject.action = boundAction;
							
							$('#confirmModal').modal('show');
						}
					
					}
					
					
					//anonymous function to delete a bound Presentation from the My Presentations library
					var deletePresentationFunc = function() {
						var confirmObj = this;
						var confirmedPresentation = confirmObj.subject;
						
						
						if(confirmedPresentation != null) {
							console.log('Deleted Presentation: ' + confirmedPresentation.name);
							var allWidgets = Object.values(widgets);
							
							var aWidget;
							for (var i = 0; allWidgets.length > i; i += 1) {
								aWidget = allWidgets[i];
								if(aWidget.presentations[confirmedPresentation.id] != null) {
									delete aWidget.presentations[confirmedPresentation.id];
								}
							}
							
							delete userData.presentations[confirmedPresentation.id];
							console.log('Presentation Count: ' + Object.values(userData.presentations).length);
							
							if(currentPresentation.id == confirmedPresentation.id) {
								selectPresentation(null);
							} else {
								selectPresentation(currentPresentation);
							}
													
						}

					};
					
					
					//function to delete a slide
					function deleteSlide(slideDiv) {
						var slideId = slideDiv.attr('eas-id');
						var aSlide = userData.presentations[currentPresentation.id].slides[slideId];
						
						if(aSlide != null) {
							var thisMessages = [];
							thisMessages.push('<xsl:value-of select="eas:i18n('Are you sure that you want to remove this slide?')"/>');
							
							confirmSubject = {
								'title': '<xsl:value-of select="eas:i18n('Delete Slide')"/>',
								'subject': aSlide,
								'messages': thisMessages,
								'relatedElement': slideDiv,
								'action': null
							};
							
							var boundAction = deleteSlideFunc.bind(confirmSubject);
							confirmSubject.action = boundAction;
							
							$('#confirmModal').modal('show');
						}
					
					}
					
					
					//anonymous function to delete a bound Slide from the current Presentation
					var deleteSlideFunc = function() {
						var confirmObj = this;
						var confirmedSlide = confirmObj.subject;
						
						
						if(confirmedSlide != null) {
							console.log('Deleting slide: ' + confirmedSlide.id);
							var slideWidgets = confirmedSlide.slideWidgets;
							
							//delete all references to the contained slide widgets
							var aSlideWidget;
							for (var i = 0; slideWidgets.length > i; i += 1) {
								aSlideWidget = slideWidgets[i];
								if(widgets[aSlideWidget.widgetId].presentations[aSlideWidget.presId].widgets[aSlideWidget.id] != null) {
									delete widgets[aSlideWidget.widgetId].presentations[aSlideWidget.presId].widgets[aSlideWidget.id];
								}
							}
							
							delete userData.presentations[currentPresentation.id].slides[confirmedSlide.id];
							console.log('Presentation Slide Count: ' + Object.values(userData.presentations[currentPresentation.id].slides).length);
							
							var newSlides = Object.values(currentPresentation.slides);
							var aSlide, presName = currentPresentation.name;
							for (var j = 0; newSlides.length > j; j += 1) {
								newSlides[j].name = presName + ' Slide ' + (j + 1);
							}
							
							if(currentSlide.id == confirmedSlide.id) {
								selectSlide(null);
							} else {
								selectSlide(currentSlide);
							}
													
						}

					};
					
					
					
					//function to delete a slide widget
					function deleteSlideWidget(slideWidgetId) {
						if(currentSlide != null) {
							var aSlideWidget = currentSlide.slideWidgets[slideWidgetId];
							
							if(aSlideWidget != null) {
								var thisMessages = [];
								thisMessages.push('<xsl:value-of select="eas:i18n('Are you sure that you want to remove this slide widget?')"/>');
								
								confirmSubject = {
									'title': '<xsl:value-of select="eas:i18n('Delete Slide Widget')"/>',
									'subject': aSlideWidget,
									'messages': thisMessages,
									'relatedElement': null,
									'action': null
								};
								
								var boundAction = deleteSlideWidgetFunc.bind(confirmSubject);
								confirmSubject.action = boundAction;
								
								$('#confirmModal').modal('show');
							}
						}				
					}
					
					
					//anonymous function to delete a bound Slide WIdget from the current Slide
					var deleteSlideWidgetFunc = function() {
						var confirmObj = this;
						var confirmedSlideWidget = confirmObj.subject;
										
						if(confirmedSlideWidget != null) {
							console.log('Deleting slide widget: ' + confirmedSlideWidget.id);
							
							if(widgets[confirmedSlideWidget.widgetId].presentations[confirmedSlideWidget.presId].widgets[confirmedSlideWidget.id] != null) {
								delete widgets[confirmedSlideWidget.widgetId].presentations[confirmedSlideWidget.presId].widgets[confirmedSlideWidget.id];
							}
							
							delete currentSlide.slideWidgets[confirmedSlideWidget.id];
							console.log('Slide Widget Count: ' + Object.values(currentSlide.slideWidgets).length);
							
							refreshSlideList();
													
						}

					};
					

					
					var widgets = {
						<xsl:apply-templates mode="RenderWidgetJSON" select="$allWidgets"/>
					};
					
					var apiData = {};
					
					var widgetData = {};
					
					var widgetThemes = [
						<xsl:apply-templates mode="RenderWidgetTheme" select="$allWidgetThemes"/>
					];
					
					var userData = {
						presentations: {},
						nextPresId: 1,
						nextSlideId: 1,
						nextSlideWidgetId: 1
					}
					
					var selectedPreview, currentWidgetTheme, editedWidget, currentWidget, currentPresentation, currentSlide, currentSlideWidget;
					
					<xsl:call-template name="RenderJavascriptUtilityFunctions"/>
                	
                	<xsl:call-template name="RenderJavascriptRESTFunctions"/>
                	
                	<!-- Start functions for nav bar -->
                	function nextTab(elem) {
					    $(elem).next().find('a[data-toggle="tab"]').click();
					}
					
					function prevTab(elem) {
					    $(elem).prev().find('a[data-toggle="tab"]').click();
					}
					
					
					<!-- assign funcrions to render the widgets to JS variables -->
                	<xsl:apply-templates mode="RenderWidgetFunction" select="$allWidgets"/>
                	
                	<!-- assign funcrions to render the slide widgets to JS variables -->
                	<xsl:apply-templates mode="RenderSlideWidgetFunction" select="$allWidgets"/>
                	
                	
                	<!-- function to render the list of selected widgets -->
                	function renderSelectedWidgets() {
                		var aWidgetId, aWidget;
                	
                		for (var i = 0; selectedWidgetIds.length > i; i += 1) {
                			aWidgetId = selectedWidgetIds[i];
                			renderWidget(aWidgetId);
                		}
                	}
                	
                	<!-- function to initialise the widget themes -->
                	function initWidgetThemes() {
                		var aTheme, themeStyles, themeStyleClasses, aStyleClass, aStyleString, aStyleObject;
                		for (var i = 0; widgetThemes.length > i; i += 1) {
                			aTheme = widgetThemes[i];
                			<!--themeStyles = aTheme.styles;
                			
                			themeStyleClasses = Object.keys(themeStyles);
                			for (var j = 0; themeStyleClasses.length > j; j += 1) {
                				aStyleClass = themeStyleClasses[j];
                				aStyleString = themeStyles[aStyleClass];
                				aStyleObject = JSON.parse(aStyleString);
                				themeStyles[aStyleClass] = aStyleObject;
                			}-->
                			if(aTheme.isDefault) {
                				currentWidgetTheme = aTheme;
                				return;
                			}
                		}
                	}
                	
                	
                	<!-- function to update the theme oapplied to the given list of widgets -->
                	function updateTheme() {
                		
				        if(currentWidgetTheme != null) {
				        	var theSVGId;
				            var svgTheme = currentWidgetTheme;
				            
				            for (var i = 0; selectedWidgets.widgets.length > i; i += 1) {
				            	theSVGId = selectedWidgets.widgets[i].widgetId;
				            	
					            
					            //update the styling of lines used for callouts
					            var svgStyle = svgTheme.styles['widgetSVG'];
					            if(svgStyle != null) {
					                d3.selectAll('.' + theSVGId)
					                    .styles(svgStyle);
					            }
					            
					            //update the styling of lines used for callouts
					            var calloutLineStyle = svgTheme.styles['widgetCalloutLine'];
					            if(calloutLineStyle != null) {
					                d3.selectAll('.widgetCalloutLine')
					                    .styles(calloutLineStyle);
					            }
					            
					            //update the styling of callout titles
					            var calloutTitleStyle = svgTheme.styles['widgetCalloutTitle'];
					            if(calloutTitleStyle != null) {
					                d3.selectAll('.widgetCalloutTitle')
					                    .styles(calloutTitleStyle);
					            }
					            
					            //update the styling of callout text
					            var calloutTextStyle = svgTheme.styles['widgetCalloutText'];
					            if(calloutTextStyle != null) {
					                d3.selectAll('.widgetCalloutText')
					                    .styles(calloutTextStyle);
					            }
					            
					            
					            //update the styling of tagline text
					            var taglineTextStyle = svgTheme.styles['widgetTagline'];
					            if(taglineTextStyle != null) {
					                d3.selectAll('.widgetTagline')
					                    .styles(taglineTextStyle);
					            }
					            
					            //update the styling of tagline container
					            var taglineContainerStyle = svgTheme.styles['widgetTaglineContainer'];
					            if(taglineContainerStyle != null) {
					                d3.selectAll('.widgetTaglineContainer')
					                    .styles(taglineContainerStyle);
					            }
					            
					             //update the fill colours of the pie chart slices
					            var categoryColourScheme = svgTheme.widgetCategories;
					            if(categoryColourScheme != null) {
					                d3.selectAll('.' + theSVGId + 'widgetCategories')
					                    .attr('fill', function(d, i) { 
					                        if(i &lt; categoryColourScheme.length) {
					                            return categoryColourScheme[i]; 
					                        } else {
					                            return 'black';
					                        }
					                     })
					            }
					    	}
				        }
				    }
				    
				    
				    var getSVGContent = function(svg) {
					  // first create a clone of our svg node so we don't mess the original one
					  var clone = svg.cloneNode(true);
					  // parse the styles
					  parseStyles(clone);
					
					  // create a doctype
					  var svgDocType = document.implementation.createDocumentType('svg', "-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd");
					  // a fresh svg document
					  var svgDoc = document.implementation.createDocument('http://www.w3.org/2000/svg', 'svg', svgDocType);
					  // replace the documentElement with our clone 
					  svgDoc.replaceChild(clone, svgDoc.documentElement);
					  // get the data
					  var svgXMLData = (new XMLSerializer()).serializeToString(svgDoc);
					  
					  //return the svg content as a DOMString
					  return svgXMLData;
					  				
					};
					
					
				    
				    var exportSVG = function(svg) {
					  // first create a clone of our svg node so we don't mess the original one
					  var clone = svg.cloneNode(true);
					  // parse the styles
					  parseStyles(clone);
					
					  // create a doctype
					  var svgDocType = document.implementation.createDocumentType('svg', "-//W3C//DTD SVG 1.1//EN", "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd");
					  // a fresh svg document
					  var svgDoc = document.implementation.createDocument('http://www.w3.org/2000/svg', 'svg', svgDocType);
					  // replace the documentElement with our clone 
					  svgDoc.replaceChild(clone, svgDoc.documentElement);
					  // get the data
					  var svgData = (new XMLSerializer()).serializeToString(svgDoc);
					
					  // now you've got your svg data, the following will depend on how you want to download it
					  // e.g yo could make a Blob of it for FileSaver.js
					  /*
					  var blob = new Blob([svgData.replace(/>&lt;/g, '>\n\r&lt;')]);
					  saveAs(blob, 'myAwesomeSVG.svg');
					  */
					  // here I'll just make a simple a with download attribute
					
					  var a = document.createElement('a');
					  a.href = 'data:image/svg+xml; charset=utf8, ' + encodeURIComponent(svgData.replace(/>&lt;/g, '>\n\r&lt;'));
					  a.download = 'myAwesomeSVG.svg';
					  a.innerHTML = 'download the svg file';
					  document.body.appendChild(a);
					
					};
					
					var parseStyles = function(svg) {
					  var styleSheets = [];
					  var i;
					  // get the stylesheets of the document (ownerDocument in case svg is in iframe or object)
					  var docStyles = svg.ownerDocument.styleSheets;
					
					  // transform the live StyleSheetList to an array to avoid endless loop
					  for (i = 0; i &lt; docStyles.length; i++) {
					    styleSheets.push(docStyles[i]);
					  }
					
					  if (!styleSheets.length) {
					    return;
					  }
					
					  var defs = svg.querySelector('defs') || document.createElementNS('http://www.w3.org/2000/svg', 'defs');
					  if (!defs.parentNode) {
					    svg.insertBefore(defs, svg.firstElementChild);
					  }
					  svg.matches = svg.matches || svg.webkitMatchesSelector || svg.mozMatchesSelector || svg.msMatchesSelector || svg.oMatchesSelector;
					
					
					  // iterate through all document's stylesheets
					  for (i = 0; i &lt; styleSheets.length; i++) {
					    var currentStyle = styleSheets[i]
					
					    var rules;
					    try {
					      rules = currentStyle.cssRules;
					    } catch (e) {
					      continue;
					    }
					    // create a new style element
					    var style = document.createElement('style');
					    // some stylesheets can't be accessed and will throw a security error
					    var l = rules &amp;&amp; rules.length;
					    // iterate through each cssRules of this stylesheet
					    for (var j = 0; j &lt; l; j++) {
					      // get the selector of this cssRules
					      var selector = rules[j].selectorText;
					      // probably an external stylesheet we can't access
					      if (!selector) {
					        continue;
					      }
					
					      // is it our svg node or one of its children ?
					      if ((svg.matches &amp;&amp; svg.matches(selector)) || svg.querySelector(selector)) {
					
					        var cssText = rules[j].cssText;
					        // append it to our style node
					        style.innerHTML += cssText + '\n';
					      }
					    }
					    // if we got some rules
					    if (style.innerHTML) {
					      // append the style node to the clone's defs
					      defs.appendChild(style);
					    }
					  }
					
					};
                	
                	
                	<!-- function to render a widget with the given Id -->
                	function renderWidget(aWidgetId) {
                		var aWidget = widgets[aWidgetId];
                		switch (aWidgetId) {
                			<xsl:for-each select="$allWidgets">
                				<xsl:variable name="this" select="current()"/>
								case '<xsl:value-of select="eas:getSafeJSString($this/name)"/>':
									<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_function_name']/value"/>.call(aWidget);
                					setTimeout(function(){	
	                					var customTextList = aWidget.customText;
										var customText;
										for (var i = 0; customTextList.length > i; i += 1) {
				                			customText = customTextList[i];
				                			d3.select('#' + aWidget.widgetId + customText.label).call(wrap, customText.text, aWidget.defaultWidth, aWidget.defaultHeight, 1);				
				                		}
				                	}, 200);
									break;<xsl:text>
								</xsl:text>
                			</xsl:for-each>
						}
                	}
                	
                	
                	<!-- function to render a widget with the given Id in a slide -->
                	function renderSlideWidget(slide, slideWidget) {
                		var aWidget = widgets[slideWidget.widgetId];
                		switch (aWidget.id) {
                			<xsl:for-each select="$allWidgets">
                				<xsl:variable name="this" select="current()"/>
								case '<xsl:value-of select="eas:getSafeJSString($this/name)"/>':
									<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_function_name']/value"/>InSlide.call(aWidget, slide, slideWidget);
                					var customTextList = aWidget.customText;
									var customText;
									for (var i = 0; customTextList.length > i; i += 1) {
			                			customText = customTextList[i];
			                			d3.select('.real-' + slideWidget.id + customText.label).call(wrap, customText.text, (aWidget.defaultWidth * slideWidget.svgScale), (aWidget.defaultHeight * slideWidget.svgScale), slideWidget.svgScale);				
			                		};
									break;<xsl:text>
								</xsl:text>
                			</xsl:for-each>
						}
                	}
                	
                	<!-- function to render a widget with the given Id -->
                	<!--function updateSelectedWidgetText() {
                		for (var i = 0; selectedWidgetIds.length > i; i += 1) {
                			aWidgetId = selectedWidgetIds[i];
                			var aWidget = widgets[aWidgetId];
	                		var customTextList = aWidget.customText;
							var customText;
							for (var i = 0; customTextList.length > i; i += 1) {
	                			customText = customTextList[i];
	                			d3.selectAll('.' + aWidget.widgetId + customText.label).call(wrap, customText.text, 50, 200);	
	                			//console.log('Wrapping with width: ', aWidget.defaultWidth + ', height: ' + aWidget.defaultHeight + ', for :' + aWidget.widgetId + customText.label);
	                		};
                		}
                		
                	}-->
                	
                	
                	<!--function renderAppDepModelDonutChart() {
                		if(apiData['basic-app-data'] == null) {
	                		var xmlhttp = new XMLHttpRequest();
							xmlhttp.onreadystatechange = function() {
							    if (this.readyState == 4 &amp;&amp; this.status == 200) {
							        apiData['basic-app-data'] = JSON.parse(this.responseText);
							        if (widgetData['app-dep-pie-chart-data'] == null) {
							        	widgetData['app-dep-pie-chart-data'] = getAppDepModelDonutChartData(rawData);
						        	}
						        	renderStaticDonutChart(widgetData['app-dep-pie-chart-data']);
							    }
							};
							xmlhttp.open("GET", "<xsl:value-of select="$testAPIPath"/>", true);
							xmlhttp.send();
						} else {
							if (widgetData['app-dep-pie-chart-data'] == null) {
								widgetData['app-dep-pie-chart-data'] = getAppDepModelDonutChartData(rawData);
						    }
						    renderStaticDonutChart(widgetData['app-dep-pie-chart-data']);
						}
                	}-->
                	
                	function writeDownloadLink(){
                		var thisWidgetId = d3.select(this).attr("eas-svg");
                		console.log('Creating download link for: ' + thisWidgetId);
					    var html = d3.select("." + thisWidgetId)
					        .attr("version", 1.1)
					        .attr("xmlns", "http://www.w3.org/2000/svg")
					        .attr("xmlns:xlink", "http://www.w3.org/1999/xlink")
					        .node().parentNode.innerHTML;
					    
					    d3.select(this)
					        .attr("href-lang", "image/svg+xml")
					        .attr("href", "data:image/svg+xml;base64,\n" + btoa(html))
					      //  .on("mouseout", function(){
					      //      d3.select(this)
					      //          .html("Right Click to Download");
					      //  });
					};
					
					
					function writeSlideDownloadLink(){
                		var thisSlideId = d3.select(this).attr("eas-svg");
                		
                		exportSVG(document.getElementById(thisSlideId));
                		
                		<!--console.log('Creating download link for: ' + thisWidgetId);
					    var html = d3.select("#" + thisWidgetId)
					        .attr("title", "svg_title")
					        .attr("version", 1.1)
					        .attr("xmlns", "http://www.w3.org/2000/svg")
					        .node().parentNode.innerHTML;
					    
					    d3.select(this)
					        .attr("href-lang", "image/svg+xml")
					        .attr("href", "data:image/svg+xml;base64,\n" + btoa(html))
					        .on("mouseout", function(){
					            d3.select(this)
					                .html("Right Click to Download");
					        });-->
					};
					
					
					<!-- function to add event listener to customise text buttons -->
					function addCustomiseTextEvtListeners() {
						$('.customise-text-btn').on('click', function (evt) {
							$('#appModal').modal('show');
						});
					}
					
					function initWidgetPreviewTab() {		
                	
                		$('#editWidgetList').html(widgetEditTemplate(selectedWidgets)).promise().done(function(){
                			console.log(widgetData);
                			
                			//add event listener to widget selection divs
                			$('.widget-preview-select').on('click', function (evt) {
                				$('.widget-preview-select').removeClass('widget-preview-selected');
                				$(this).addClass('widget-preview-selected');
                				
    							var aWidgetId = $(this).attr('eas-id');
    							var aWidget = getObjectById(selectedWidgets.widgets, "id", aWidgetId);
    							selectedPreview = aWidget;
    						
								//scroll to the associated Widget Preview
								document.querySelector('#' + aWidget.widgetId + '-div').scrollIntoView({ 
								  behavior: 'smooth' 
								});
								
								
							});
                		});
					
						
						$('#widget-preview-container').html(widgetPreviewTemplate(selectedWidgets)).promise().done(function(){
					        renderSelectedWidgets();
					        updateTheme();
					        
					        $('.widget-download-btn').on("mouseover", writeDownloadLink);
    						
    						$('.customise-text-btn').on('click', function (evt) {
    							console.log('Clicked on edit button');
    							var aWidgetId = $(this).attr('eas-id');
    							editedWidget = getObjectById(selectedWidgets.widgets, "id", aWidgetId);
    						
								$('#widgetTextEditorModal').modal('show');
							});
							
							if(selectedPreview != null) {
								$( '#' + selectedPreview.id + '-select' ).trigger( 'click' );
							}
    						
					    });	
					    
					    
					}
					
					function openWidgetEditor(evt) {
						var aWidgetId = $(this).attr('eas-id');
    					editedWidget = getObjectById(selectedWidgets.widgets, "id", aWidgetId);
    				
						$('#widgetTextEditorModal').modal('show');
					}

					<!-- function to add event listeneers to elements in the My Widgets tab-->
					function addWidgetSelectionListeners() {
						<xsl:call-template name="RenderMyWidgetsTabInitJS"/>
					}
					
					
					<!-- function to refresh the contents of the My Presentations tab-->
					function refreshMyPresentationsTab() {
						<xsl:call-template name="RenderMyPresentationsInitJS"/>
					}
					
					<!-- function to update the displayed list of presentations -->
					function refreshPresentationList() {
						$('#my-presentation-list').html(presItemTemplate(userData)).promise().done(function(){
                			$('.pres-item').on('click', function (evt) {
								//console.log('Clicked on presentation');
								var aPresId = $(this).attr('eas-id');
								var aPres = userData.presentations[aPresId];
								if(aPres != null) {
									selectPresentation(aPres);	
								}
							});
							
							$('.edit-pres-btn').on('click', function (evt) {
	    						//console.log('Clicked on edit presentation button');
	    						var aPresId = $(this).attr('eas-id');
	    						currentPresentation = userData.presentations[aPresId];
	    						
	    						if(currentPresentation != null) {
									$('#presEditorModal').modal('show');
								}
							});
							
							$('.delete-pres-btn').on('click', function () {
								var presentationDiv = $(this);
								deletePresentation(presentationDiv);
							});
							
                		});
					}
					
					<!-- function to select the given presentation in the presentation list -->
                	function selectPresentation(seletedPres) {
                		var aPres;
                		var presList = Object.values(userData.presentations);
                		for (var i = 0; presList.length > i; i += 1) {
                			aPres = presList[i];
                			if(seletedPres == null) {
                				aPres.selected = false;
                			} else if(aPres.id == seletedPres.id) {
                				aPres.selected = true;
                			} else {
                				aPres.selected = false;
                			}
                		}
                		currentPresentation = seletedPres;
                		if(seletedPres != null) {
                			$('#pres-slides-title').text(currentPresentation.name);
                			$('#pres-slides-header').removeClass('pres-slides-title-disabled');	
                		} else {
                			$('#pres-slides-title').text('');
							$('#pres-slides-header').addClass('pres-slides-title-disabled');
						}
						
                		refreshPresentationList();
                		refreshSlideList();
                	}
                	
                	function dragstarted(d) {
                		d3.select(this).raise().classed("drag-active", true);
                	  <!--var slideWidgetId = d3.select(this).attr('id');
                	  if(slideWidgetId != null) {
                	  	currentSlideWidget = currentSlide.slideWidgets[slideWidgetId];
					  	d3.select(this).raise().classed("drag-active", true);
					  }-->
					}
					
					function dragged(d) {
					  var thisSvg = d3.select(this);
					  //console.log('SVG Dimensions- width: ' + thisWidth + ' height: ' + thisHeight);
					  thisSvg.attr("x", d.x = d3.event.x).attr("y", d.y = d3.event.y);
					}
					
					function dragended(d) {
					  d3.select(this).classed("drag-active", false);
					}
                	
                	<!-- function to update the displayed list of slides -->
					function refreshSlideList() {
					
						if(currentPresentation == null) {
							$('#presentation-slides').html('');
							return;
						}
						
						$('#presentation-slides').html(slideTemplate(currentPresentation)).promise().done(function(){
                			$('.slide-widget').on('click', function (evt) {
								var aSlideId = $(this).attr('id');
								var aSlide = currentPresentation.slides[aSlideId];
								currentSlide = aSlide;
								if(aSlide != null) {
									selectSlide(aSlide);
								}
							});
							
							
							$('.slide-widget-svg').on('click', function (evt) {
								if(currentSlide != null) {
									var anSvgWidgetId = $(this).attr('id');
									currentSlideWIdget = currentSlide.slideWidgets[anSvgWidgetId];
									//console.log('Clicked on SVG group: ' + currentSlideWIdget.id);
								}
							});
							
							$('.delete-slide-btn').on('click', function () {
								var slideDiv = $(this);
								deleteSlide(slideDiv);
							});
							
							
							$('.edit-slide-btn').on('click', function (evt) {
								console.log('Clicked on edit slide');
								if(currentPresentation != null) {
									var aSlideId = $(this).attr('eas-id');
									console.log('Clicked on edit slide: ' +  aSlideId);
									if(aSlideId != null) {
		    							currentSlide = currentPresentation.slides[currentSlide.id];
										$('#slideEditorModal').modal('show');
									}
								}
							});
							

							if(currentSlide != null) {
								var currentSlideId = currentSlide.id;
								var slideSVG = d3.select('#' + currentSlideId);
								
								var thisSlideWidgets = d3.selectAll('#' + currentSlideId + ' .slide-widget-svg')
									.datum(function (d, i) { 
										var anSvgWidgetId = $(this).attr('id');
										var anSvgWidget = currentSlide.slideWidgets[anSvgWidgetId];
										return  anSvgWidget; 
									})
									.attr("x",function(d) { return d.x; })
									.attr("y",function(d) { return d.y; })
									.call(d3.drag()
										.on("start", dragstarted)
								        .on("drag", dragged)
								        .on("end", dragended)
								     );
								     
								     
							     var resizeGroup = thisSlideWidgets.append("g")
							      //.classed("grabCircles", true)
							      .attr("transform", "translate(" + 10 + "," + 10 + ")");
							      
							     resizeGroup
							     	.append("g")
	      							.classed("grabCircles", true)
							     	.each(function (d) {
								        var circleG = d3.select(this);
			
								        circleG
								          .append("circle")
								          .classed("topleft", true)
								          .style('opacity', 0)
								          .attr("r", HANDLE_R)
								          .on("mouseenter mouseleave", resizerHover)
								          .call(d3.drag()
								            	.container(slideSVG.node())
									            .subject(function (d) {
									              return d;
									            })
									            .on("start end", rectResizeStartEnd)							            
								            	.on("drag", rectResizing)
								            );
								
								        circleG
								          .append("circle")
								          .classed("bottomright", true)
								          .style('opacity', 0)
								          .attr("r", HANDLE_R)
								          .on("mouseenter mouseleave", resizerHover)
								          .call(d3.drag()
								            	.container(slideSVG.node())
									            .subject(function (d) {
									              return d;
									            })
									            .on("start end", rectResizeStartEnd)							            
								            	.on("drag", rectResizing)
								            );
								            
								         circleG
								          .append("image")
								          .classed("delete-slide-widget", true)
								          .style('opacity', 0)
								          .attr("xlink:href", "images/fa-svg/black/svg/trash.svg")
									      .attr("width", "15px")
									      .attr("height", "15px")
									      .on("mouseover", function(d) {
									      		d3.select(this).style("cursor", "pointer");
									       })
									       .on("mouseout", function(d) {
									      		d3.select(this).style("cursor", "default");
									       })
									       .on("click", function(d) {
										  		deleteSlideWidget(d.id);
									       });
								      });	
								  
								  d3.selectAll("circle.bottomright")
								      .attr("cx", function (d) {
								      	var thisBB = d3.select(this).node().parentNode.parentNode.parentNode.getBBox();
							     		var resizeWidth = thisBB.width;
								        return resizeWidth;
								      })
								      .attr("cy", function (d) {
								      	var thisBB = d3.select(this).node().parentNode.parentNode.parentNode.getBBox();
										var resizeHeight = thisBB.height;
								        return resizeHeight;
								      });
								      
								 d3.selectAll("image.delete-slide-widget")
								      .attr("x", function (d) {
								      	var thisBB = d3.select(this).node().parentNode.parentNode.parentNode.getBBox();
							     		var thisWidth = thisBB.width;
								        return thisWidth;
								      });
								      
								 thisSlideWidgets
								 	.on("mouseover", function(d) {		
							            d3.select(this).selectAll('circle').transition()		
							                .duration(200)		
							                .style("opacity", .9);
							            
							            d3.select(this).selectAll('image').transition()		
							                .duration(200)		
							                .style("opacity", .9);
							         })
							        .on("mouseout", function(d) {		
							            d3.select(this).selectAll('circle').transition()		
							                .duration(300)		
							                .style("opacity", 0);
							                
							            d3.select(this).selectAll('image').transition()		
							                .duration(300)		
							                .style("opacity", 0);
							        });
							        
							       //scroll to the currentSlide
									document.querySelector('#' + currentSlide.id + '-div').scrollIntoView({ 
									  behavior: 'smooth' 
									});
							}
							
							$('.slide-download-btn').on("click", writeSlideDownloadLink);
							
                		});
                		
                		
					}
					
					<!-- function to select the given slide in the slide list -->
                	function selectSlide(selectedSlide) {
                		var aSlide;
                		var slideList = Object.values(currentPresentation.slides);
                		for (var i = 0; slideList.length > i; i += 1) {
                			aSlide = slideList[i];
                			if(selectedSlide == null) {
                				aSlide.selected = false;
                   			} else if(aSlide.id == selectedSlide.id) {
                				aSlide.selected = true;
                			} else {
                				aSlide.selected = false;
                			}
                		}
                		currentSlide = selectedSlide;
                		refreshSlideList();
                	}
                	
                	function resizerHover() {
					    var el = d3.select(this), isEntering = d3.event.type === "mouseenter";
					    el
					      .classed("hovering", isEntering)
					      .attr(
					        "r",
					        isEntering || el.classed("resizing") ?
					          HANDLE_R_ACTIVE : HANDLE_R
					      );
					}
					
					function rectResizeStartEnd(d) {
					    var el = d3.select(this), isStarting = d3.event.type === "start";
					    d3.event.sourceEvent.stopPropagation();
					    d3.select(this)
					      .classed("resizing", isStarting)
					      .attr(
					        "r",
					        isStarting || el.classed("hovering") ?
					          HANDLE_R_ACTIVE : HANDLE_R
					      );
					   if(!isStarting) {
					   		if (el.classed("topleft")) {
						   		var widthDiff = d.newX - d.x;
								var currentWidth = d.maxWidth * d.svgScale;
								var newWidth = currentWidth - widthDiff;
								var newScale = newWidth / d.maxWidth;
						   		console.log('New Scale from: ' + d.svgScale + ' to ' + newScale);
						   		
						   		d.svgScale = newScale;
						   		d.x = d.newX;
						   		d.y = d.newY;
					   		} else {
					   			var currentWidth = d.maxWidth * d.svgScale;
					   			var widthDiff = (d.x + currentWidth) - d.newX;
								
								var newWidth = currentWidth - widthDiff;
								var newScale = newWidth / d.maxWidth;
						   		console.log('New Scale from: ' + (d.x + currentWidth) + ' to ' + d.newX + ', diff: ' + widthDiff);
						   		
						   		d.svgScale = newScale;				   		
					   		}
					   		refreshSlideList();
					   }
					}
					
					
					function rectResizing(d) {
						var el = d3.select(this);
						
					    var dragX = Math.max(
					      Math.min(d3.event.x, MAX_TRANSLATE_X),
					      MIN_TRANSLATE_X
					    );
					
					    var dragY = Math.max(
					      Math.min(d3.event.y, MAX_TRANSLATE_Y),
					      MIN_TRANSLATE_Y
					    );
						
					    if (el.classed("topleft")) {
					    
					    	el.attr('cx', d3.event.x - d.x);
						    el.attr('cy', d3.event.y - d.y);
						    
						    d.newX = d3.event.x;
						    d.newY = d3.event.y;
					
					      <!--var newWidth = Math.max(d.maxWidth + d.x - dragX, MIN_RECT_WIDTH);
					      var newXPos = d.x + d.maxWidth - newWidth;
					      console.log('New XPos from: ' + d.x + ' to ' + d3.event.x);-->
							
					     <!-- d.x += d.width - newWidth;
					      d.width = newWidth;-->
					
					      <!--var newHeight = Math.max(d.height + d.y - dragY, MIN_RECT_HEIGHT);
					
					      d.y += d.height - newHeight;
					      d.height = newHeight;-->
					
					    } else {
					    	var currentWidth = d.maxWidth * d.svgScale;
					    	var currentHeight = d.maxHeight * d.svgScale;
					    	el.attr('cx', d3.event.x + currentWidth - d.x - 30);
						    el.attr('cy', d3.event.y + currentHeight - d.y - 10);
						    
						    d.newX = d3.event.x + currentWidth - 10;
						    d.newY = d3.event.y + currentHeight - 10;
						    
						    console.log('New X Pos: from ' + d.x + ' to ' + d.newX);
					    	
							//var newWidth = Math.max(dragX - d.x, MIN_RECT_WIDTH);
							//console.log('New Width: ' + newWidth);
					      <!--d.width = Math.max(dragX - d.x, MIN_RECT_WIDTH);
					      d.height = Math.max(dragY - d.y, MIN_RECT_HEIGHT);-->
					
					    }

					}
					
					<!-- Function to generate and download a PPTX version of the currently selected Presentation -->
                	function renderRealPres(aPres) {
                		$('#real-presentation-container').html(realSlideTemplate(aPres)).promise().done(function(){
                			$('#download-pres-status').text('Generating ' + aPres.name + '...');
                			renderRealPresSVGs(aPres)
					        .then(generateRealPresPack)
					        .then(uploadPresPack)
					        .then(function() {
					        	// on success - remove the contents of the div containing the generated presentation
					        	$('#real-presentation-container').html('');
					        	$('#download-pres-status').text('');
					        }, function() {
					        	// on error - remove the contents of the div containing the generated presentation
					        	$('#real-presentation-container').html('');
					        	$('#download-pres-status').text('');
					        });
					        <!--.catch(function (error) {
					            // something went wrong
					            console.log(error.message);
					        });-->
                		});
                	}
                	
                	
                	<!-- Promise to render real presentation slide SVGs to be used to generate a presentation file-->
                	var renderRealPresSVGs = function (aPres) {
					    return new Promise(
					        function (resolve, reject) {
					            if(aPres != null) {
					            	var aPresSpec = {
					            		'presentation': aPres,
					            		'id': aPres.id,
					            		'name': aPres.name,
					            		'description': aPres.description,
					            		'timestamp': moment(new Date()).format(),
					            		'template': aPres.template,
					            		'slides': []
					            	}
					            	var presSlides = Object.values(aPres.slides);
					            	var theSlide, theSlideWidgets, theSlideWidget, aSlideSpec;
					            	for (var i = 0; presSlides.length > i; i += 1) {
					            		theSlide = presSlides[i];
					            		theSlideWidgets = Object.values(theSlide.slideWidgets);
					            		for (var j = 0; theSlideWidgets.length > j; j += 1) {
					            			theSlideWidget = theSlideWidgets[j];
					            			renderSlideWidget(theSlide, theSlideWidget);
					            		}
					            		aSlideSpec = {
					            			'title': theSlide.heading,
					            			'svg': 'slides/' + theSlide.id + '.svg'
					            		}
					            		aPresSpec.slides.push(aSlideSpec);
					            	}       				            	
					            	resolve(aPresSpec);
					            } 
					            else {
					            	var anError = new Error('A presentation must be selected');
            						reject(anError); // reject
					            }
					        }
					    );
					};
					
					
					
					<!-- Promise to render real presentation slide SVGs to be used to generate a presentation file-->
                	var generateRealPresPack = function (aPresSpec) {
					    return new Promise(
					        function (resolve) {
					            var presPackZip = new JSZip();
				            	var slideFolder = presPackZip.folder('slides');
				            
				            	var presSlides = Object.values(aPresSpec.presentation.slides);
				            	var aSlide, slideSVGContent;
				            	for (var i = 0; presSlides.length > i; i += 1) {
				            		aSlide = presSlides[i];
				            		slideSVGContent = getSVGContent(document.getElementById('real-slide-svg-' + aSlide.id));
				            		slideFolder.file((aSlide.id + '.svg'), slideSVGContent);
				            	}	 
				            	delete aPresSpec.presentation;
				            	presPackZip.file('ess-pres-spec.json', JSON.stringify(aPresSpec));
				            	aPresSpec.zipFile = presPackZip;
				            	resolve(aPresSpec);
					        }
					    );
					};
					
					<!-- Promise to upload the presentation pack -->
					var extractFilenameFromHeader = function(xhrResponse) {
						// header for content disposition is something like this: content-disposition: attachment; filename=presentation_2019-07-22.zip
						// so extract the value of the filename attribute in the header
						try {
							var header = xhrResponse.getResponseHeader('Content-Disposition');
							var startIndex = header.indexOf("filename=") + 9;
							return header.substring(startIndex);
						} catch (e) {
							// use a generic name for the presentation zip file if there is a problem
							return 'presentation.zip';
						}
					}

                	var uploadPresPack = function (aPresSpec) {
                		return new Promise(
					        function (resolve, reject) {
					            aPresSpec.zipFile.generateAsync({type:"blob"})
									// generate the zip file in the browser
									.then(function(content) {
									    // then upload the presentation pack zip
									    var formData = new FormData()
									    formData.append("doc-pack", content);
									    
										var url = presentationEnvironment.baseUrl+'/api/essential-presentation/generate-presentation';
									    var xhr = createCORSRequest('POST', url, presentationEnvironment.csrfToken);
										if (!xhr) {
										  throw new Error('CORS not supported');
										} else {
											// Response handlers.
											var success = function(xhr){
												// download the pptx generated and sent as a blob in the response body
												var filename = extractFilenameFromHeader(xhr);
												var blob = xhr.response;
												// create a link element, hide it, direct it towards the blob, and then 'click' it programatically
												var a = document.createElement("a");
												a.style = "display: none";
												document.body.appendChild(a);
												// create a DOMString representing the blob and point the link element towards it
												var url = window.URL.createObjectURL(blob);
												a.href = url;
												a.download = filename;
												a.click();
												// release the reference to the file by revoking the Object URL
												window.URL.revokeObjectURL(url);

												resolve();
											};
											var failure = function(){
												// TODO show error message
												reject();
											};
											xhr.responseType = 'blob'; // required to allow the download of the file sent back in the response
											xhr.onload = onXhrLoad(xhr, success, failure);
											xhr.onerror = failure;
											xhr.send(formData);
										}
									});
					        }
					    );             	
                	}
                	
                	
                	
                	<!-- function called when the page is initialised -->
					$(document).ready(function(){

						<!-- initialise file pond file uploader -->
						FilePond.registerPlugin(FilePondPluginFileValidateType);
						filePond = FilePond.create(
							document.querySelector('input[type="file"]'),
							{
								labelIdle: 'Drag &amp; Drop your template (.pptx file) or <span class="filepond--label-action">Browse</span>',
								// set allowed file types with mime types
								acceptedFileTypes: ['application/vnd.openxmlformats-officedocument.presentationml.presentation'],
								// allows mapping of file types to label values to be shown in error label
								fileValidateTypeLabelExpectedTypesMap: {'application/vnd.openxmlformats-officedocument.presentationml.presentation': '.pptx'},
								fileValidateTypeLabelExpectedTypes: 'Expects {lastType}'
							}
						);
						FilePond.setOptions({
							allowReplace: true,
							instantUpload: false
						});

						<!-- initialise the widget themes -->
                		initWidgetThemes();
                		
                		<!-- Add nav-bar event listeners -->
                		//Initialize tooltips
					    $('.nav-tabs > li a[title]').tooltip();
					    
					    //pres-tab-bar
					    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					    	
							var thisTrigger = $(e.target);
					
							if (thisTrigger.attr('id') == 'previewWidgetsTab') {
								initWidgetPreviewTab();
							}
							
							if (thisTrigger.attr('id') == 'myPresTab') {
								refreshMyPresentationsTab();
							}
					    });
					
					    <!--$(".next-step").click(function (e) {
					
					        var $active = $('.pres-tab-bar .nav-tabs li.active');
					        $active.next().removeClass('disabled');
					        nextTab($active);
					
					    });
					    
					    $(".prev-step").click(function (e) {
					
					        var $active = $('.pres-tab-bar .nav-tabs li.active');
					        prevTab($active);
					
					    });-->
					    
					    
					    <!-- Initialise the widget selection tab -->
					    var widgetSelectionFragment = $("#widget-selection-template").html();
						widgetSelectionTemplate = Handlebars.compile(widgetSelectionFragment);
						
						var widgetList = Object.values(widgets);
						var allWidgets = {
							'widgets': widgetList
						};
					    $('#grid').html(widgetSelectionTemplate(allWidgets)).promise().done(function(){
							addWidgetSelectionListeners(); 
							$('#grid-selector').html('Showing <strong>' + widgetList.length + '</strong> of <strong>' + widgetList.length + '</strong> widgets');
						});
					    
					    
					    
					    <!-- Set up the Widget Tag list -->
                		$('#widgetTagList').select2({
                			//allowClear: true,
						    placeholder: "Select tags to filter",
						    theme: "bootstrap"
						});			
						
						$('#widgetTagList').on('change', function (event) {
							var tagObjects = $('#widgetTagList').select2('data');
							var filteredWidgets = [];
							var allWidgets = Object.values(widgets);
							if(tagObjects.length > 0) { 
								var tagIds = getObjectIds(tagObjects, 'id');
								var aWidget;
								for (var i = 0; allWidgets.length > i; i += 1) {
									aWidget = allWidgets[i];
									if(getArrayIntersect([aWidget.tags, tagIds]).length > 0) {
										//console.log('Adding filtered widget: ' + aWidget.name);
										filteredWidgets.push(aWidget);
									}
								}
							} else {
								filteredWidgets = allWidgets;
							}
							
							var filterResult = {
								'widgets': filteredWidgets
							};
						    $('#grid').html(widgetSelectionTemplate(filterResult)).promise().done(function(){
								addWidgetSelectionListeners(); 
								$('#grid-selector').html('Showing <strong>' + filteredWidgets.length + '</strong> of <strong>' + allWidgets.length + '</strong> widgets');
							});
							
							
						});	
						
						
						<!-- Initialise the widget preview/edit handlebars templates -->
                		Handlebars.registerHelper( 'eachInMap', function ( map, block ) {
						   var out = '';
						   Object.keys( map ).map(function( prop ) {
						      out += block.fn( {key: prop, value: map[ prop ]} );
						   });
						   return out;
						});
						
						var confirmModalFragment = $("#confirm-modal-template").html();
						confirmModalTemplate = Handlebars.compile(confirmModalFragment);
						
						var selectedWidgetFragment = $("#selected-widget-template").html();
						selectedWidgetTemplate = Handlebars.compile(selectedWidgetFragment);
                	
						var widgetPreviewFragment = $("#widget-preview-template").html();
						widgetPreviewTemplate = Handlebars.compile(widgetPreviewFragment);
						
						var widgetTextEditorFragment = $("#widget-text-editor-template").html();
						widgetTextEditorTemplate = Handlebars.compile(widgetTextEditorFragment);
						
						var widgetEditFragment = $("#widget-edit-template").html();
						widgetEditTemplate = Handlebars.compile(widgetEditFragment);
						
						var presItemFragment = $("#pres-item-template").html();
						presItemTemplate = Handlebars.compile(presItemFragment);
						
						var slideFragment = $("#slide-template").html();
						slideTemplate = Handlebars.compile(slideFragment);
						
						var slideWidgetFragment = $("#slide-widget-template").html();
						slideWidgetTemplate = Handlebars.compile(slideWidgetFragment);
						
						var realSlideFragment = $("#real-slide-template").html();
						realSlideTemplate = Handlebars.compile(realSlideFragment);
						
						
						<!-- initialise show event listener for confirmation modal -->
						$('#confirmModal').on('show.bs.modal', function (event) {
							  
							  if(confirmSubject != null) {
							  	//render the confirmation modal content
							  	$('#confirmModalContent').html(confirmModalTemplate(confirmSubject)).promise().done(function(){
								
									$('.confirmBtn').on('click', function (evt) {
										//confirmSubject.action();										
										$('#confirmModal').modal('hide');
									});
									
									$('.cancelConfirmBtn').on('click', function (evt) {
										confirmSubject = null;										
										$('#confirmModal').modal('hide');
									});
								});
							 }
						});
						
						<!-- initialise hidden event listener for confirmation modal -->
						$('#confirmModal').on('hidden.bs.modal', function (event) {
							if(confirmSubject != null) {
								confirmSubject.action();
							}
						});
						
						
					
						<!-- Set up the Theme selection box -->
                		$('#widgetThemeList').select2({theme: "bootstrap"});
						
						<!-- Add an event listener to the widget theme list -->
						//add an event listener to the widget themes dropdown list
						$('#widgetThemeList').on('change', function (evt) {
							var aThemeId = $(this).val();
							if(aThemeId != null) {
								currentWidgetTheme = getObjectById(widgetThemes, "id", aThemeId);
								updateTheme();
							}						
						});
						
						<!-- initialise event listener for widget text editor modal -->
						$('#widgetTextEditorModal').on('shown.bs.modal', function (event) {
							  
							  if(editedWidget != null) {
							  	//render the widget text editor modal content
							  	$('#widgetTextEditorModelContent').html(widgetTextEditorTemplate(editedWidget)).promise().done(function(){
								
									$('.widget-text-editor-input').focus(function() { $(this).select(); } );
									
									$('#widget-text-editor-form').children()[1].focus();
								
									$('.saveWidgetTextBtn').on('click', function (evt) {
										//console.log('Clicked on button');
										var customTextList = editedWidget.customText;
										var customText;
										for (var i = 0; customTextList.length > i; i += 1) {
				                			customText = customTextList[i];
				                			newText = $('#' + customText.id + 'Input').val();
				                			customText.text = newText;
				                			d3.select('#' + editedWidget.widgetId + customText.label).call(wrap, newText, editedWidget.defaultWidth, editedWidget.defaultHeight, 1);				
				                		}
										
										editedWidget = null;
										$('#widgetTextEditorModal').modal('hide');
									});
								});
							 }
						});
						
						
						<!-- Initialise the presentation editor handlebars templates -->					
						var presentationEditorFragment = $("#presentation-editor-template").html();
						presentationEditorTemplate = Handlebars.compile(presentationEditorFragment);
						
						$('#add-pres-btn').on('click', function (evt) {
    						//console.log('Clicked on add/edit presentation button');
    						var aPresId = $(this).attr('eas-id');
    						
    						if(aPresId != null) {
    							currentPresentation = userData.presentations[aPresId];
    						} else {
    							currentPresentation = {
    								name: null,
    								description: null,
    								slides: {},
    								template: 'eas-pptx-template.pptx',
    								selected: true
    							}
    						};
    							
							$('#presEditorModal').modal('show');
						});
						
						
						
	
						<!-- initialise event listener for after the presentation editor modal is displayed -->
						$('#presEditorModal').on('show.bs.modal', function (event) {

							  if(currentPresentation != null) {
							  	//render the presentation editor modal content
							  	var thisAction = 'Add';
							  	if(currentPresentation.id != null) {
							  		thisAction = 'Update';
							  	}
							  	var presModalData = {
							  		action: thisAction,
							  		presentation: currentPresentation
							  	}
							  	$('#presEditorModelContent').html(presentationEditorTemplate(presModalData)).promise().done(function(){
								
									$('#presName').focus(function() { $(this).select(); } );
									$('#presDesc').focus(function() { $(this).select(); } );
									
								
									$('.savePresBtn').on('click', function (evt) {
										//console.log('Clicked on save presentation button');

										var presName = $('#presName').val();
										if(presName != null) {
											if(currentPresentation.id == null) {
												currentPresentation.id = 'pres' + userData.nextPresId;
												userData.nextPresId++;
												userData.presentations[currentPresentation.id] = currentPresentation;
												currentSlide = null;
											}
											currentPresentation.name = presName;
											currentPresentation.description = $('#presDesc').val();
											
											//update the list of presentations
											selectPresentation(currentPresentation);
											
											$('#presEditorModal').modal('hide');
										} else {
											$("#presEditorModalError").text('The presentation must have a name');
										}
									});
								});
							 }
						});
						
						$('#presEditorModal').on('shown.bs.modal', function (event) {
							$('#presName').focus();
						});
						
						
						<!-- Initialise the slide editor handlebars templates -->					
						var slideEditorFragment = $("#slide-editor-template").html();
						slideEditorTemplate = Handlebars.compile(slideEditorFragment);
									
						$('#add-slide-btn').on('click', function (evt) {
							if(currentPresentation != null) {
								var newSlideIndex = Object.values(currentPresentation.slides).length + 1;
	    						currentSlide = {
	    							'heading': currentPresentation.name + ' Slide ' + newSlideIndex,
	    							'description': null,
	    							'tagLines': {},
	    							'comments': {},
	    							'slideWidgets': {},
	    							'selected': true
	    						}
	    						$('#slideEditorModal').modal('show');
    						}
						});
						
						
						<!-- initialise event listener for after the slide editor modal is displayed -->
						$('#slideEditorModal').on('show.bs.modal', function (event) {

							  if(currentSlide != null) {
							  	//render the slide editor modal content
							  	var thisAction = 'Add';
							  	if(currentSlide.id != null) {
							  		thisAction = 'Update';
							  	}
							  	var slideModalData = {
							  		action: thisAction,
							  		slide: currentSlide
							  	}
							  	
							  	$('#slideEditorModelContent').html(slideEditorTemplate(slideModalData)).promise().done(function(){
								
									$('#slideHeading').focus(function() { $(this).select(); } );
									$('#slideDesc').focus(function() { $(this).select(); } );
									
								
									$('.saveSlideBtn').on('click', function (evt) {

										var slideHeading = $('#slideHeading').val();
										if(slideHeading != null) {
											if(currentSlide.id == null) {
												currentSlide.id = currentPresentation.id + '-slide' + userData.nextSlideId;
												userData.nextSlideId++;
												currentPresentation.slides[currentSlide.id] = currentSlide;
											}
											currentSlide.heading = slideHeading;
											currentSlide.description = $('#slideDesc').val();
											
											//update the list of slides
											selectSlide(currentSlide);
											
											$('#slideEditorModal').modal('hide');
										} else {
											$("#slideEditorModalError").text('The slide must have a title');
										}
									});
									
									$('#cancelSlideBtn').on('click', function (evt) {
										currentSlide = null;
										$('#slideEditorModal').modal('hide');
									});
								});
							 }
						});
						
						$('#slideEditorModal').on('shown.bs.modal', function (event) {
							$('#slideHeading').focus();
						});
						
						
						$('#download-pres-btn').on('click', function (evt) {

    						if(currentPresentation != null) {
    							if(Object.values(currentPresentation.slides).length > 0) {
    								//download the current presentation
    								renderRealPres(currentPresentation);
    							}
    						}
						});
							
					});
				</script>
			</body>
		</html>
	</xsl:template>
	
	<!-- TEMPLATE TO RENDER THE MY WIDGETS CSS -->
	<xsl:template name="RenderMyWidgetsCSS">
		<style type="text/css">
		#wrapper{
			height:calc(100vh - 280px);
			width: 100%;
			background:#fff;
		}
		
		.tab-main {
			width: calc(100% - 300px);
			float: left;
			padding-left: 15px;
			padding-right: 15px;
			padding-top: 15px;
			height: calc(100vh - 280px);
			overflow-x: hidden;
			overflow-y: auto;
		}

		#grid-selector{
			width: 200px;
		}		 
		
		#grid{	
			width: 100%;
			height: calc(100vh - 280px);
		}
		.right-sidebar{
			float:right;
			background:#fff;
			width:300px;
			padding: 15px 0px 15px 15px;
			height:calc(100vh - 300px);
			border-left:1px solid #eee;
		}
		.left-sidebar {
			float:left;
			background:#fff;
			width:300px;
			padding: 15px 15px 15px 0px;
			height:calc(100vh - 300px);
			border-right:1px solid #eee;
		}
		#cart{padding:0px;}
		#cart .empty{
			font-style:italic;
			color:#a0a3ab;
			font-size:14px;
			letter-spacing:1px;	
		}
		.right-sidebar .checklist{
			padding:0;
		}
		
		.checklist ul li{	
			font-size:14px;
			font-weight:400;
			list-style:none;
			padding: 7px 0 7px 23px;
		}
		.checklist li span{
			float:left;
			width:11px;
			height:11px;
			margin-left:-23px;
			margin-top:4px;
			border: 1px solid #d1d3d7;
			position:relative;	
		}
		.sizes li span, .categories .sizes li{
			-webkit-transition: all 300ms ease-out;
			   -moz-transition: all 300ms ease-out;
			    -ms-transition: all 300ms ease-out;
			     -o-transition: all 300ms ease-out;
			        transition: all 300ms ease-out;
		}
		.checklist li a{
			color:#676a74;
			text-decoration:none;	
			-webkit-transition: all 300ms ease-out;
			   -moz-transition: all 300ms ease-out;
			    -ms-transition: all 300ms ease-out;
			     -o-transition: all 300ms ease-out;
			        transition: all 300ms ease-out;
		}
		.checklist li a:hover{	
			color:#222;
			-webkit-transition: all 300ms ease-out;
			   -moz-transition: all 300ms ease-out;
			    -ms-transition: all 300ms ease-out;
			     -o-transition: all 300ms ease-out;
			        transition: all 300ms ease-out;
		}
		.checklist a:hover span{ 	
			border-color:#a6aab3;	
		}
		.sizes a:hover span, .categories a:hover span{	
			border-color:#a6aab3;
			-webkit-transition: all 300ms ease-out;
			   -moz-transition: all 300ms ease-out;
			    -ms-transition: all 300ms ease-out;
			     -o-transition: all 300ms ease-out;
			        transition: all 300ms ease-out;
		}
		.checklist a span span{border:none;margin:0;float:none; position:absolute;top:0;left:0;}
		.checklist a .x{
			display:block;
			width:0;	 
			height:2px;
			background:#5ff7d2;
			top:6px;
			left:2px;	
			-ms-transform: rotate(45deg); 
		   	-webkit-transform: rotate(45deg); 
		    transform: rotate(45deg);	
			-webkit-transition: all 50ms ease-out;
		}
		.checklist a .x.animate{
			width:4px;
			-webkit-transition: all 100ms ease-in;
			   -moz-transition: all 100ms ease-in;
			    -ms-transition: all 100ms ease-in;
			     -o-transition: all 100ms ease-in;
			        transition: all 100ms ease-in;
		}
		.checklist a .y{
			display:block;
			width:0px; 
			height:2px;
			background:#5ff7d2;
			top:4px;
			left:3px;	
			-ms-transform: rotate(13deg); 
		   	-webkit-transform: rotate(135deg); 
		    transform: rotate(135deg);	
			-webkit-transition: all 50ms ease-out;
		}
		.checklist a .y.animate{
			width:8px;
			-webkit-transition: all 100ms ease-out;
			   -moz-transition: all 100ms ease-out;
			    -ms-transition: all 100ms ease-out;
			     -o-transition: all 100ms ease-out;
			        transition: all 100ms ease-out;
		}
		.checklist .checked span{
			border-color:#8d939f;
		}
		.colors ul, .sizes ul{
			float:left; width:130px;	
		}
		.colors ul li{padding-left:21px;}
		.colors a span{
			border:none;
			position:relative;
			border-radius:100%;
			background-color:#eae3d3;
			width:13px;
			height:13px;
			margin-left:-20px;
		}
		.colors a:hover span{
			width:15px;
			height:15px;
			margin-top:3px;
			margin-left:-21px;
		}
		
		.product{
		    position: relative;
		    left:-15px;
		    perspective: 800px;
		    width:306px;
		    height:371px;
		    transform-style: preserve-3d;
		    transition: transform 5s;
			float:left; 
			margin-right: 23px;
			-webkit-transition: width 500ms ease-in-out;
			   -moz-transition: width 500ms ease-in-out;
				-ms-transition: width 500ms ease-in-out;
				 -o-transition: width 500ms ease-in-out;
		 		    transition: width 500ms ease-in-out;
		}
		.product-front img{width:100%;}
		.product-front, .product-back{
			width:315px;
			height:380px;
			background:#fff;
			position:absolute;
			left:-5px;
			top:-5px;
			-webkit-transition: all 100ms ease-out; 
		       -moz-transition: all 100ms ease-out; 
		         -o-transition: all 100ms ease-out; 
		            transition: all 100ms ease-out; 
		}
		.product-back{
			display:none;
			transform: rotateY( 180deg );
		}
		.make3D.animate .product-back,
		.make3D.animate .product-front,
		div.large .product-back{
			top:0px;
			left:0px;
			-webkit-transition: all 100ms ease-out; 
		       -moz-transition: all 100ms ease-out; 
		         -o-transition: all 100ms ease-out; 
		            transition: all 100ms ease-out; 
		}
		.make3D{
			width:305px;
			height:370px;
			position:absolute;    
			top:10px;
			left:10px;	
			overflow:hidden;
		    transform-style: preserve-3d;
			-webkit-transition:  100ms ease-out; 
		       -moz-transition:  100ms ease-out; 
		         -o-transition:  100ms ease-out; 
		            transition:  100ms ease-out;
		}
		div.make3D.flip-10{
			 -webkit-transform: rotateY( -10deg );
		         -moz-transform: rotateY( -10deg );
		           -o-transform: rotateY( -10deg );
		              transform: rotateY( -10deg );
					   transition:  50ms ease-out; 			
		}
		div.make3D.flip90{
			 -webkit-transform: rotateY( 90deg );
		         -moz-transform: rotateY( 90deg );
		           -o-transform: rotateY( 90deg );
		              transform: rotateY( 90deg );
					   transition:  100ms ease-in; 			
		}
		div.make3D.flip190{
			 -webkit-transform: rotateY( 190deg );
		         -moz-transform: rotateY( 190deg );
		           -o-transform: rotateY( 190deg );
		              transform: rotateY( 190deg );
					   transition:  100ms ease-out; 			
		}
		div.make3D.flip180{
			 -webkit-transform: rotateY( 180deg );
		         -moz-transform: rotateY( 180deg );
		           -o-transform: rotateY( 180deg );
		              transform: rotateY( 180deg );
					   transition:  150ms ease-out; 			
		}
		.make3D.animate{
			top:5px;
			left:5px;
			width:315px;
			height:380px;
			box-shadow:0px 5px 31px -1px rgba(0, 0, 0, 0.15);
			-webkit-transition:  100ms ease-out; 
		       -moz-transition:  100ms ease-out; 
		         -o-transition:  100ms ease-out; 
		            transition:  100ms ease-out; 
		}
		div.large .make3D{
			top:0;
			left:0;
			width:315px;
			height:380px;
			-webkit-transition:  300ms ease-out; 
		       -moz-transition:  300ms ease-out; 
		         -o-transition:  300ms ease-out; 
		            transition:  300ms ease-out; 
		}
		.large div.make3D{box-shadow:0px 5px 31px -1px rgba(0, 0, 0, 0);}
		.large div.flip-back{display:none;}
		
		.stats-container{
			background:#fff;	
			position:absolute;
			top:262px;
			left:0;
			width: 315px;
			height: 200px;
			padding: 24px 40px 35px 32px;
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out;
		}
		.make3D.animate .stats-container{
			top:205px;
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out; 
		}
		.stats-container .product_name{
			font-size: 15px;
		    color: #393c45;
		    font-weight: 700;
		}
		.stats-container p{
			font-size:15px;
			color:#b1b1b3;	
			padding:2px 0 20px 0;
		}
		.stats-container .product_price{
			float:right;
			color:#5ff7d2;
			font-size:22px;
			font-weight:600;
		}
		.image_overlay{
			position:absolute;
			top:0;
			left:0; 
			width:100%;
			height:100%;
			background:#B3002D;
			opacity:0;	
		}
		.make3D.animate .image_overlay{
			opacity:0.6;	
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out; 
		}
		.product-options{
			padding:0;
		}
		.product-options strong{
			font-weight:700;
			color:#393c45;
			font-size:14px;
		}
		.product-options span{	
			color:#969699;
			font-size:14px;
			display:block;
			margin-bottom:8px;
		}
		
		.add_to_cart{	
			position:absolute;
			top:50px;
			left:50%;
			width:152px;
			font-size:15px;
			margin-left:-78px;
			border:2px solid #fff;
			color:#fff;	
			text-align:center;
			text-transform:uppercase;
			font-weight:700;
			padding:10px 0;	
			opacity:0;
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out; 
		}
		
		.add_to_cart:hover{	
			background:#fff;
			color:#B3002D;
			cursor:pointer;
		
		}
		
		.make3D.animate .add_to_cart{
			opacity:1;	
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out; 		
		}
		
		
		.added_to_cart{	
			border:2px solid #BFBFBF;
			color:#BFBFBF;	
		}
		
		.added_to_cart:hover{	
			background:#BFBFBF;
		}
		
		
		.view_gallery{	
			position:absolute;
			top:114px;
			left:50%;
			width:152px;
			font-size:15px;
			margin-left:-78px;
			border:2px solid #fff;
			color:#fff;	
			text-align:center;
			text-transform:uppercase;
			font-weight:700;
			padding:10px 0;	
			opacity:0;
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out; 
		}
		.view_gallery:hover{	
			background:#fff;
			color:#B3002D;
			cursor:pointer;
		
		}
		.make3D.animate .view_gallery{
			opacity:1;	
			-webkit-transition: all 200ms ease-out; 
		       -moz-transition: all 200ms ease-out; 
		         -o-transition: all 200ms ease-out; 
		            transition: all 200ms ease-out; 		
		}
		div.colors div{
			margin-top:3px;
			width:15px; 
			height:15px; 	
			margin-right:5px;
			float:left;
		}
		div.colors div span{
			width:15px; 
			height:15px; 
			display:block;
			border-radius:50%;
		}
		div.colors div span:hover{
			width:17px;
			height:17px;
			margin:-1px 0 0 -1px;
		}
		div.c-blue span{background:#6e8cd5;}
		div.c-red span{background:#f56060;}
		div.c-green span{background:#44c28d;}
		div.c-white span{
			background:#fff;
			width:14px;
			height:14px; 
			border:1px solid #e8e9eb;
		}
		div.shadow{
			width:335px;height:520px;
			opacity:0;
			position:absolute;
			top:0;
			left:0;
			z-index:3;
			display:none;
			background: -webkit-linear-gradient(left,rgba(0,0,0,0.1),rgba(0,0,0,0.2));
		    background: -o-linear-gradient(right,rgba(0,0,0,0.1),rgba(0,0,0,0.2)); 
		    background: -moz-linear-gradient(right,rgba(0,0,0,0.1),rgba(0,0,0,0.2)); 
		    background: linear-gradient(to right, rgba(0,0,0,0.1), rgba(0,0,0,0.2)); 
		}
		.product-back div.shadow{
			z-index:10;
			opacity:1;
			background: -webkit-linear-gradient(left,rgba(0,0,0,0.2),rgba(0,0,0,0.1));
		    background: -o-linear-gradient(right,rgba(0,0,0,0.2),rgba(0,0,0,0.1)); 
		    background: -moz-linear-gradient(right,rgba(0,0,0,0.2),rgba(0,0,0,0.1)); 
		    background: linear-gradient(to right, rgba(0,0,0,0.2), rgba(0,0,0,0.1)); 
		}
		.flip-back{
			position:absolute;
			top:20px;
			right:20px;
			width:30px;
			height:30px;
			cursor:pointer;
		}
		.cx, .cy{
			background:#d2d5dc;
			position:absolute;
			width:0px;
			top:15px;
			right:15px;
			height:3px;
			-webkit-transition: all 250ms ease-in-out;
			   -moz-transition: all 250ms ease-in-out;
				-ms-transition: all 250ms ease-in-out;
				 -o-transition: all 250ms ease-in-out;
					transition: all 250ms ease-in-out;
		}
		.flip-back:hover .cx, .flip-back:hover .cy{
			background:#979ca7;
			-webkit-transition: all 250ms ease-in-out;
			   -moz-transition: all 250ms ease-in-out;
				-ms-transition: all 250ms ease-in-out;
				 -o-transition: all 250ms ease-in-out;
					transition: all 250ms ease-in-out;
		}
		.cx.s1, .cy.s1{	
			right:0;	
			width:30px;	
			-webkit-transition: all 100ms ease-out;
			   -moz-transition: all 100ms ease-out;
				-ms-transition: all 100ms ease-out;
				 -o-transition: all 100ms ease-out;
					transition: all 100ms ease-out;
		}
		.cy.s2{	
			-ms-transform: rotate(50deg); 
			-webkit-transform: rotate(50deg); 
			transform: rotate(50deg);		 
			-webkit-transition: all 100ms ease-out;
			   -moz-transition: all 100ms ease-out;
				-ms-transition: all 100ms ease-out;
				 -o-transition: all 100ms ease-out;
					transition: all 100ms ease-out;
		}
		.cy.s3{	
			-ms-transform: rotate(45deg); 
			-webkit-transform: rotate(45deg); 
			transform: rotate(45deg);		 
			-webkit-transition: all 100ms ease-out;
			   -moz-transition: all 100ms ease-out;
				-ms-transition: all 100ms ease-out;
				 -o-transition: all 100ms ease-out;
					transition: all 100ms ease-out;
		}
		.cx.s1{	
			right:0;	
			width:30px;	
			-webkit-transition: all 100ms ease-out;
			   -moz-transition: all 100ms ease-out;
				-ms-transition: all 100ms ease-out;
				 -o-transition: all 100ms ease-out;
					transition: all 100ms ease-out;
		}
		.cx.s2{	
			-ms-transform: rotate(140deg); 
			-webkit-transform: rotate(140deg); 
			transform: rotate(140deg);		 
			-webkit-transition: all 100ms ease-out;
			   -moz-transition: all 100ms ease-out;
				-ms-transition: all 100ease-out;
				 -o-transition: all 100ms ease-out;
					transition: all 100ms ease-out;
		}
		.cx.s3{	
			-ms-transform: rotate(135deg); 
			-webkit-transform: rotate(135deg); 
			transform: rotate(135deg);		 
			-webkit-transition: all 100ease-out;
			   -moz-transition: all 100ms ease-out;
				-ms-transition: all 100ms ease-out;
				 -o-transition: all 100ms ease-out;
					transition: all 100ms ease-out;
		}
		.carousel{
			width:315px;
			height:500px;
			overflow:hidden;
			position:relative;
		}
		.carousel ul{
			position:absolute;
			top:0;
			left:0;
		}
		.carousel li{
			width:315px;
			height:500px;
			float:left;
			overflow:hidden;	
		}
		.carousel img{
			margin-top: -22px;
			width: 110%;
		}
		.arrows-perspective{
			width:315px;
			height:55px;
			position: absolute;
			top: 218px;
			transform-style: preserve-3d;
		    transition: transform 5s;
			perspective: 335px;
		}
		.carouselPrev, .carouselNext{
			width: 50px;
			height: 55px;
			background: #ccc;
			position: absolute;	
			top:0;
			transition: all 200ms ease-out; 
			opacity:0.9;
			cursor:pointer;
		}
		.carouselNext{
			top:0;
			right: -26px;
			-webkit-transform: rotateY( -117deg );
		         -moz-transform: rotateY( -117deg );
		           -o-transform: rotateY( -117deg );
		              transform: rotateY( -117deg );
					  transition: all 200ms ease-out; 			
		
		}
		.carouselNext.visible{
				right:0;
				opacity:0.8;
				background: #fff;
				-webkit-transform: rotateY( 0deg );
		         -moz-transform: rotateY( 0deg );
		           -o-transform: rotateY( 0deg );
		              transform: rotateY( 0deg );
					  transition: all 200ms ease-out; 
		}
		.carouselPrev{		
			left:-26px;
			top:0;
			-webkit-transform: rotateY( 117deg );
		         -moz-transform: rotateY( 117deg );
		           -o-transform: rotateY( 117deg );
		              transform: rotateY( 117deg );
					  transition: all 200ms ease-out; 
		
		}
		.carouselPrev.visible{
				left:0;
				opacity:0.8;
				background: #fff;
				-webkit-transform: rotateY( 0deg );
		         -moz-transform: rotateY( 0deg );
		           -o-transform: rotateY( 0deg );
		              transform: rotateY( 0deg );
					  transition: all 200ms ease-out; 
		}
		.carousel .x, .carousel .y{
			height:2px;
			width:15px;
			background:#5ff7d2;
			position:absolute;
			top:31px;
			left:17px;
			-ms-transform: rotate(45deg); 
			-webkit-transform: rotate(45deg); 
			transform: rotate(45deg);	
		}
		.carousel .x{
			-ms-transform: rotate(135deg); 	
			-webkit-transform: rotate(135deg); 
			transform: rotate(135deg);		
			top:21px;
		}
		.carousel .carouselNext .x{
			-ms-transform: rotate(45deg); 	
			-webkit-transform: rotate(45deg); 
			transform: rotate(45deg);		
		}
		.carousel .carouselNext .y{
			-ms-transform: rotate(135deg); 	
			-webkit-transform: rotate(135deg); 
			transform: rotate(135deg);		
		}
		div.floating-cart{
			position:fixed;
			top:0;
			right:0; 
			width:315px;	
			height:380px;
			background:#fff;
			z-index:200;
			overflow:hidden;
			box-shadow:0px 5px 31px -1px rgba(0, 0, 0, 0.15);
			display:none;
		}
		
		div.floating-cart .stats-container{display:none;}
		
		div.floating-cart .product-front{width:100%; top:0; right:0;}
		
		div.floating-cart.moveToCart{
		position:fixed;
			right: 208px !important;
			top: 335px !important;
			width: 47px;
			height: 47px;	
			-webkit-transition: all 800ms ease-in-out;
			   -moz-transition: all 800ms ease-in-out;
				-ms-transition: all 800ms ease-in-out;
				 -o-transition: all 800ms ease-in-out;
		 		    transition: all 800ms ease-in-out; 
		}
		body.MakeFloatingCart div.floating-cart.moveToCart{
		position:fixed;
			right: 225px !important;
			top: 420px !important;
			width: 21px;
			height: 22px;
			box-shadow:0px 5px 31px -1px rgba(0, 0, 0, 0);
			-webkit-transition: all 200ms ease-out;
			   -moz-transition: all 200ms ease-out;
				-ms-transition: all 200ms ease-out;
				 -o-transition: all 200ms ease-out;
		 		    transition: all 200ms ease-out;
		}
		body.MakeFloatingCart div.cart-icon-top{z-index:30;}
		body.MakeFloatingCart div.cart-icon-bottom{z-index:300;}
		
		
		#editWidgetList {
			height: 100%;
			overflow-x: hidden;
			overflow-y:scroll;
		}
		
		.cart-item{	
			display: flex;
		    margin-bottom: 15px;
		    padding: 5px;
			position:relative;
			background:#fff;
			-webkit-transition: all 1000ms ease-out;
			   -moz-transition: all 1000ms ease-out;
				-ms-transition: all 1000ms ease-out;
				 -o-transition: all 1000ms ease-out;
		 		    transition: all 1000ms ease-out;
		}
		
		.cart-item.flash{
			background:#fffeb0;
			width:280px; 
			margin-left:-65px;
		}
		
		.cart-item .img-wrap{
			width:50px; 
			height:50px; 
			overflow:hidden;
			float:left;
			margin-right: 5px;
			background-color: #fff;
		    display: flex;
		    justify-items: center;
		    align-items: center;
		    border: 1px solid #ccc;
		}
		
		.cart-item img{width:100%; position:relative;}
		
		.cart-item strong{color:#5ff7d2; font-size:16px;}
		
		.cart-item .delete-item{
			position:absolute;
			bottom: 0px;
			right: 0px;
			width:30px;
			height:30px;
			margin-right:10px;
			display:none;
		}
		.cart-item:hover .delete-item{display:block;cursor:pointer}
		
		
		#info{
			position: absolute;
			top: 20px;
			left: 676px;
			text-align: center;
			width: 413px;
		
		}
		#info p{font-size:15px; padding:3px;color:#b1b1b3}
		#info a{text-decoration:none;} 
		#checkout{
			border: 2px solid #5ff7d2;
			font-size: 13px;
			font-weight: 700;
			padding: 3px 9px;
			position: absolute;
			top: 137px;
			left: 181px;
			color: #5ff7d2;
			display:none;
		}
		
		.product.large{
			width:639px;
			margin-bottom:25px;
			overflow:hidden;
			-webkit-transition: all 500ms ease-in-out;
			   -moz-transition: all 500ms ease-in-out;
				-ms-transition: all 500ms ease-in-out;
				 -o-transition: all 500ms ease-in-out;
		 		    transition: all 500ms ease-in-out;
		}
		
		
		
		
		/* ---------------- */
		.floating-image-large{
			position:absolute;
			top:0;
			left:0;
			width:100%;
		}
		.info-large{
			  display:none;
			  position: absolute;
			  top: 0;
			  left: 0px;
			  padding: 42px;
			  width: 245px;
			  height: 395px;
			  -webkit-transition: all 500ms ease-out;
			   -moz-transition: all 300ms ease-out;
				-ms-transition: all 300ms ease-out;
				 -o-transition: all 300ms ease-out;
		 		    transition: all 300ms ease-out;
		}
		.large .info-large{
			left: 310px;
			-webkit-transition: all 300ms ease-out;
			   -moz-transition: all 300ms ease-out;
				-ms-transition: all 300ms ease-out;
				 -o-transition: all 300ms ease-out;
		 		    transition: all 300ms ease-out;
		}
		
		.info-large h4{
			text-transform:uppercase;
			font-size:28px;
			color:#000;
			font-weight:400;
			padding:0;
		}
		div.sku{
			  font-weight: 700;
			  color: #d0d0d0;
			  font-size: 12px;
			  padding-top: 11px;
		}
		div.sku strong{
			color:#000;
		}
		.price-big{
			font-size: 34px;
		    font-weight: 600;
		    color: #5ff7d2;
		    margin-top: 21px;
		}
		.price-big span{
			color:#d0d0d0;
			font-weight:400;
			text-decoration:line-through;
		}
		
		.add-cart-large{
			  border: 3px solid #000;
			  font-size: 17px;
			  background: #fff;
			  text-transform: uppercase;
			  font-weight: 700;
			  padding: 10px;
			  font-family: "Open Sans", sans-serif;
			  width: 246px;
			  margin-top: 38px;	
			  -webkit-transition: all 200ms ease-out;
			   -moz-transition: all 200ms ease-out;
				-ms-transition: all 200ms ease-out;
				 -o-transition: all 200ms ease-out;
		 		    transition: all 200ms ease-out;
		}
		.add-cart-large:hover{
			color: #5ff7d2;
			border-color:#5ff7d2;
			-webkit-transition: all 200ms ease-out;
			   -moz-transition: all 200ms ease-out;
				-ms-transition: all 200ms ease-out;
				 -o-transition: all 200ms ease-out;
		 		    transition: all 200ms ease-out;
					cursor:pointer;
		}
		.info-large h3{
		    letter-spacing: 1px;
		    color: #262626;
		    text-transform: uppercase;
		    font-size: 14px;
			clear:left;
			margin-top:20px;
		    font-weight: 700;
			margin-bottom:3px;
		}
		
		
		.colors-large{
			margin-bottom:38px;
		}
		.colors-large li{
			float:left;
			list-style:none;
			margin-right:7px;
			width:16px;
			height:16px;
		}
		.colors-large li a{
			float:left;
			width:16px;
			height:16px;
			border-radius:50%;
		}
		.colors-large li a:hover{
			width:19px;
			height:19px;
			position:relative;
			top:-1px;
			left:-1px;
		}
		
		.sizes-large{
		}
		.sizes-large span{
			font-weight:600;
			color:#b0b0b0;
		}
		.sizes-large span:hover{color:#000;cursor:pointer;}
		
		.product.large:hover{
			box-shadow:0px 5px 31px -1px rgba(0, 0, 0, 0.15);	
		}
		</style>
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE INITIALISATION JAVASCRIPT FOR MY WIDGETS TAB -->
	<xsl:template name="RenderMyWidgetsTabInitJS">
		function deselectWidget(widgetDiv) {
			var widgetId = widgetDiv.attr('eas-id');
			var aWidget = widgets[widgetId];
			
			var thisMessages =[];
			var widgetPresIds = Object.keys(aWidget.presentations);
			var aPres, presNames = '';
			if (widgetPresIds.length > 0) {
				for (var i = 0; widgetPresIds.length > i; i += 1) {
					aPres = aWidget.presentations[widgetPresIds[i]].presentation;
					presNames = presNames + aPres.name;
					if (widgetPresIds.length > (i + 1)) {
						presNames = presNames + ', ';
					}
				}
				var presMessage = '<xsl:value-of select="eas:i18n('This widget is currently used in presentations')"/>: ' + presNames;
				thisMessages.push(presMessage);
			}
			
			thisMessages.push('<xsl:value-of select="eas:i18n('Are you sure that you want to remove this widget?')"/>');
			
			
			//console.log('Deleselecting Widget: ' + widgetId);
			confirmSubject = {
				'title': '<xsl:value-of select="eas:i18n('Remove Widget')"/>',
				'subject': aWidget,
				'messages': thisMessages,
				'confirmButtonClass': 'deselect-widget-btn',
				'relatedElement': widgetDiv,
				'action': null
			};
			
			var boundAction = deselectWidgetFunc.bind(confirmSubject);
			confirmSubject.action = boundAction;
			
			$('#confirmModal').modal('show');
		}
		
		
		$(".largeGrid").click(function () {
			$(this).find('a').addClass('active');
			$('.smallGrid a').removeClass('active');
			
			$('.product').addClass('large').each(function () {
			});
			setTimeout(function () {
				$('.info-large').show();
			},
			200);
			setTimeout(function () {
				
				$('.view_gallery').trigger("click");
			},
			400);
			
			return false;
		});
		
		$(".smallGrid").click(function () {
			$(this).find('a').addClass('active');
			$('.largeGrid a').removeClass('active');
			
			$('div.product').removeClass('large');
			$(".make3D").removeClass('animate');
			$('.info-large').fadeOut("fast");
			setTimeout(function () {
				$('div.flip-back').trigger("click");
			},
			400);
			return false;
		});
		
		$(".smallGrid").click(function () {
			$('.product').removeClass('large');
			return false;
		});
		
		$('.colors-large a').click(function () {
			return false;
		});
		
		
		$('.product').each(function (i, el) {
			
			// Lift card and show stats on Mouseover
			$(el).find('.make3D').hover(function () {
				$(this).parent().css('z-index', "20");
				$(this).addClass('animate');
				$(this).find('div.carouselNext, div.carouselPrev').addClass('visible');
			},
			function () {
				$(this).removeClass('animate');
				$(this).parent().css('z-index', "1");
				$(this).find('div.carouselNext, div.carouselPrev').removeClass('visible');
			});
			
			// Flip card to the back side
			$(el).find('.view_gallery').click(function () {
				
				$(el).find('div.carouselNext, div.carouselPrev').removeClass('visible');
				$(el).find('.make3D').addClass('flip-10');
				setTimeout(function () {
					$(el).find('.make3D').removeClass('flip-10').addClass('flip90').find('div.shadow').show().fadeTo(80, 1, function () {
						$(el).find('.product-front, .product-front div.shadow').hide();
					});
				},
				50);
				
				setTimeout(function () {
					$(el).find('.make3D').removeClass('flip90').addClass('flip190');
					$(el).find('.product-back').show().find('div.shadow').show().fadeTo(90, 0);
					setTimeout(function () {
						$(el).find('.make3D').removeClass('flip190').addClass('flip180').find('div.shadow').hide();
						setTimeout(function () {
							$(el).find('.make3D').css('transition', '100ms ease-out');
							$(el).find('.cx, .cy').addClass('s1');
							setTimeout(function () {
								$(el).find('.cx, .cy').addClass('s2');
							},
							100);
							setTimeout(function () {
								$(el).find('.cx, .cy').addClass('s3');
							},
							200);
							$(el).find('div.carouselNext, div.carouselPrev').addClass('visible');
						},
						100);
					},
					100);
				},
				150);
			});
			
			// Flip card back to the front side
			$(el).find('.flip-back').click(function () {
				
				$(el).find('.make3D').removeClass('flip180').addClass('flip190');
				setTimeout(function () {
					$(el).find('.make3D').removeClass('flip190').addClass('flip90');
					
					$(el).find('.product-back div.shadow').css('opacity', 0).fadeTo(100, 1, function () {
						$(el).find('.product-back, .product-back div.shadow').hide();
						$(el).find('.product-front, .product-front div.shadow').show();
					});
				},
				50);
				
				setTimeout(function () {
					$(el).find('.make3D').removeClass('flip90').addClass('flip-10');
					$(el).find('.product-front div.shadow').show().fadeTo(100, 0);
					setTimeout(function () {
						$(el).find('.product-front div.shadow').hide();
						$(el).find('.make3D').removeClass('flip-10').css('transition', '100ms ease-out');
						$(el).find('.cx, .cy').removeClass('s1 s2 s3');
					},
					100);
				},
				150);
			});
			
			makeCarousel(el);
		});
		
		$('.add-cart-large').each(function (i, el) {
			$(el).click(function () {
				var carousel = $(this).parent().parent().find(".carousel-container");
				var img = carousel.find('img').eq(carousel.attr("rel"))[0];
				var position = $(img).offset();
				
				var productName = $(this).parent().find('h4').get(0).innerHTML;
				
				$("body").append('<div class="floating-cart"></div>');
				var cart = $('div.floating-cart');
				$('<img src="' + img.src + '" class="floating-image-large" />').appendTo(cart);
				
				$(cart).css({
					'top': position.top + 'px', "left": position.left + 'px'
				}).fadeIn("slow").addClass('moveToCart');
				setTimeout(function () {
					$("body").addClass("MakeFloatingCart");
				},
				800);
				
				setTimeout(function () {
					$('div.floating-cart').remove();
					$("body").removeClass("MakeFloatingCart");
					
					
					var cartItem = '<div class="cart-item"><div class="img-wrap"><img src="' + img.src + '" alt="" /></div><span>' + productName + '</span><strong>$39</strong><div class="delete-item"></div></div>';
					
					$("#cart .empty").hide();
					$("#cart").append(cartItem);
					$("#checkout").fadeIn(500);
					
					$("#cart .cart-item").last().addClass("flash").find(".delete-item").click(function () {
						var widgetDiv = $(this);
						deselectWidget(widgetDiv);
					});
					
					setTimeout(function () {
						$("#cart .cart-item").last().removeClass("flash");
					},
					10);
				},
				1000);
			});
		})
		
		/* ----  Image Gallery Carousel   ---- */
		function makeCarousel(el) {
			
			
			var carousel = $(el).find('.carousel ul');
			var carouselSlideWidth = 315;
			var carouselWidth = 0;
			var isAnimating = false;
			var currSlide = 0;
			$(carousel).attr('rel', currSlide);
			
			// building the width of the casousel
			$(carousel).find('li').each(function () {
				carouselWidth += carouselSlideWidth;
			});
			$(carousel).css('width', carouselWidth);
			
			// Load Next Image
			$(el).find('div.carouselNext').on('click', function () {
				var currentLeft = Math.abs(parseInt($(carousel).css("left")));
				var newLeft = currentLeft + carouselSlideWidth;
				if (newLeft == carouselWidth || isAnimating === true) {
					return;
				}
				$(carousel).css({
					'left': "-" + newLeft + "px",
					"transition": "300ms ease-out"
				});
				isAnimating = true;
				currSlide++;
				$(carousel).attr('rel', currSlide);
				setTimeout(function () {
					isAnimating = false;
				},
				300);
			});
			
			// Load Previous Image
			$(el).find('div.carouselPrev').on('click', function () {
				var currentLeft = Math.abs(parseInt($(carousel).css("left")));
				var newLeft = currentLeft - carouselSlideWidth;
				if (newLeft &lt; 0 || isAnimating === true) {
					return;
				}
				$(carousel).css({
					'left': "-" + newLeft + "px",
					"transition": "300ms ease-out"
				});
				isAnimating = true;
				currSlide--;
				$(carousel).attr('rel', currSlide);
				setTimeout(function () {
					isAnimating = false;
				},
				300);
			});
		}
		
		$('.sizes a span, .categories a span').each(function (i, el) {
			$(el).append('<span class="x"></span><span class="y"></span>');
			
			$(el).parent().on('click', function () {
				if ($(this).hasClass('checked')) {
					$(el).find('.y').removeClass('animate');
					setTimeout(function () {
						$(el).find('.x').removeClass('animate');
					},
					50);
					$(this).removeClass('checked');
					return false;
				}
				
				$(el).find('.x').addClass('animate');
				setTimeout(function () {
					$(el).find('.y').addClass('animate');
				},
				100);
				$(this).addClass('checked');
				return false;
			});
		});
		
		$('.add_to_cart').click(function () {
			var productCard = $(this).parent();
			
			//get the widget
			var widgetId = productCard.attr('eas-id');
			var newWidget = widgets[widgetId];
			
			if (!(selectedWidgetIds.indexOf(widgetId) > -1)) {
				
				var position = productCard.offset();
				var productImage = $(productCard).find('img').get(0).src;
				var productName = $(productCard).find('.product_name').get(0).innerHTML;
				
				$("body").append('<div class="floating-cart"></div>');
				var cart = $('div.floating-cart');
				productCard.clone().appendTo(cart);
				$(cart).css({
					'top': position.top + 'px', "left": position.left + 'px'
				}).fadeIn("slow").addClass('moveToCart');
				setTimeout(function () {
					$("body").addClass("MakeFloatingCart");
				},
				800);
				setTimeout(function () {
					$('div.floating-cart').remove();
					$("body").removeClass("MakeFloatingCart");
					
					
					<!-- var cartItem = '<div class="cart-item"><div class="img-wrap"><img src="' + productImage + '" alt="" /></div><span>' + productName + '</span><div class="cart-item-border"></div><div class="delete-item"><xsl:attribute name="eas-id"></xsl:attribute><i class="fa fa-trash"/></div></div>';-->
					
					$("#cart .empty").hide();
					$("#cart").append(selectedWidgetTemplate(newWidget)).promise().done(function () {
						//$("#checkout").fadeIn(500);
						
						$("#cart .cart-item").last().addClass("flash").find(".delete-item").click(function () {
							var widgetDiv = $(this);
							deselectWidget(widgetDiv);
							<!-- $(this).parent().fadeOut(300, function () {
								$(this).remove();
								if ($("#cart .cart-item").size() == 0) {
									$("#cart .empty").fadeIn(500);
									$("#checkout").fadeOut(500);
								}
							})-->
						});
						setTimeout(function () {
							$("#cart .cart-item").last().removeClass("flash");
							$("#" + newWidget.id + "_atc").html('SELECTED').addClass('added_to_cart');
							//add the widget
							selectedWidgets.widgets.push(newWidget);
							selectedWidgetIds.push(widgetId);
							$('#widget-total').text('MY WIDGETS (' + selectedWidgets.widgets.length + ')');
						},
						10);
						setTimeout(function () {
							selectedPreview = newWidget;
							$("#previewWidgetsTab").tab("show");
						},
						600);
					});
				},
				1000);
			}
		});
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE MY WIDGETS TAB -->
	<xsl:template name="RenderMyWidgetsTab">
		
		<!-- handlebars template to render a selected widget -->	
		<script id="selected-widget-template" type="text/x-handlebars-template">
			<div class="cart-item">
				<div class="img-wrap">
					<img alt="">
						<xsl:attribute name="src">{{screenshot}}</xsl:attribute>
					</img>
				</div>
				<span class="strong small">{{name}}</span>
				<div class="delete-item"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-trash"/></div>
			</div>
		</script>
		
		<!-- handlebars template to render a widget selection card -->
		<script id="widget-selection-template" type="text/x-handlebars-template">
			{{#each widgets}}
				<div class="product">
			    	<div class="info-large">
			        	<h4>{{name}}</h4>
			            <div class="sku">
			            	{{description}}
			            </div>               
			        </div>
			        <div class="make3D">
			            <div class="product-front">
			            	<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
			                <div class="shadow"></div>
			            	<img alt="" >
			            		<xsl:attribute name="src">{{screenshot}}</xsl:attribute>
			            	</img>
			                <div class="image_overlay"></div>
			                <div class="add_to_cart">
			                	<xsl:attribute name="id">{{id}}_atc</xsl:attribute>
			                	Select
			                </div>
			                <div class="view_gallery">Screenshots</div>                
			                <div class="stats">        	
			                    <div class="stats-container">
			                        <span class="product_name">{{name}}</span>    
			                    	<p>{{description}}</p>                                                                                 
			                    </div>                         
			                </div>
			            </div>
			            
			            <div class="product-back">
			                <div class="shadow"></div>
			                <div class="carousel">
			                    <ul class="carousel-container">
			                        <li>
			                        	<img alt="" >
			                        		<xsl:attribute name="src">{{screenshot}}</xsl:attribute>
			                        	</img>
			                        </li>
			                    </ul>
			                    <div class="arrows-perspective">
			                        <div class="carouselPrev">
			                            <div class="y"></div>
			                            <div class="x"></div>
			                        </div>
			                        <div class="carouselNext">
			                            <div class="y"></div>
			                            <div class="x"></div>
			                        </div>
			                    </div>
			                </div>
			                <div class="flip-back">
			                    <div class="cy"></div>
			                    <div class="cx"></div>
			                </div>
			            </div>	  
			        </div>	
			    </div>
			{{/each}}
		</script>
		
		<div id="wrapper">
			
			
			
			<div class="tab-main">
				<div class="row">
					<div class="col-md-8">
						<h2 class="strong top-15">Widget Library</h2>
					</div>
					<div class="col-md-4">
						<div class="checklist categories pull-right" style="width:100%;">
					    	<select id="widgetTagList" class="select2" multiple="multiple" style="width:100%;">
					    		<option/>
					    		<xsl:for-each select="$allWidgetTags">
					    			<option>
					    				<xsl:attribute name="value"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>
					    				<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
					    			</option>
					    		</xsl:for-each>
					    	</select>
					    </div>
					</div>
				</div>
			    
				<hr/>
				<div id="grid-selector bottom-10">Showing 0 widgets</div>
				<div id="grid">
				    <!--<div class="product">
				    	<div class="info-large">
				        	<h4>APPLICATION DEPLOYMENT PIE CHART</h4>
				            <div class="sku">
				            	PRODUCT SKU: <strong>89356</strong>
				            </div>               
				        </div>
				        <div class="make3D">
				            <div class="product-front">
				                <div class="shadow"></div>
				            	<img src="images/screenshots/app_deployment_summary.png" alt="" />
				                <div class="image_overlay"></div>
				                <div class="add_to_cart">Select</div>
				                <div class="view_gallery">Screenshots</div>                
				                <div class="stats">        	
				                    <div class="stats-container">
				                        <span class="product_name">APPLICATION DEPLOYMENTS PIE CHART</span>    
				                    	<p>Provides a static Pie Chart showing the breakdown of applications accoprding to their deployment model</p>                                                                                 
				                    </div>                         
				                </div>
				            </div>
				            
				            <div class="product-back">
				                <div class="shadow"></div>
				                <div class="carousel">
				                    <ul class="carousel-container">
				                        <li><img src="images/screenshots/app_deployment_summary.png" alt="" /></li>
				                    	<li><img src="images/screenshots/app-radar.png" alt="" /></li>
				                    </ul>
				                    <div class="arrows-perspective">
				                        <div class="carouselPrev">
				                            <div class="y"></div>
				                            <div class="x"></div>
				                        </div>
				                        <div class="carouselNext">
				                            <div class="y"></div>
				                            <div class="x"></div>
				                        </div>
				                    </div>
				                </div>
				                <div class="flip-back">
				                    <div class="cy"></div>
				                    <div class="cx"></div>
				                </div>
				            </div>	  
				        </div>	
				    </div>
					<div class="product">
						<div class="info-large">
							<h4>APPLICATION DEPLOYMENT PIE CHART</h4>
							<div class="sku">
								<strong>Another static Pie Chart showing the breakdown of applications accoprding to their deployment model</strong>
							</div>   
							<button class="add-cart-large">Add To Cart</button> 
						</div>
						<div class="make3D">
							<div class="product-front">
								<div class="shadow"></div>
								<img src="images/screenshots/app-radar.png" alt="" />
								<div class="image_overlay"></div>
								<div class="add_to_cart">Select</div>
								<div class="view_gallery">Screenshots</div>                
								<div class="stats">        	
									<div class="stats-container">
										<span class="product_name">APPLICATION DEPLOYMENTS PIE CHART 2</span>    
										<p>Another static Pie Chart showing the breakdown of applications accoprding to their deployment model</p>                                                                                 
									</div>                         
								</div>
							</div>
							
							<div class="product-back">
								<div class="shadow"></div>
								<div class="carousel">
									<ul class="carousel-container">
										<li><img src="images/screenshots/app-radar.png" alt="" /></li>
									</ul>
									<div class="arrows-perspective">
										<div class="carouselPrev">
											<div class="y"></div>
											<div class="x"></div>
										</div>
										<div class="carouselNext">
											<div class="y"></div>
											<div class="x"></div>
										</div>
									</div>
								</div>
								<div class="flip-back">
									<div class="cy"></div>
									<div class="cx"></div>
								</div>
							</div>	  
						</div>	
					</div>-->
				</div>
			</div>
			<div class="right-sidebar">
				<div class="pull-left right-10">
					<i class="fa fa-shopping-cart fa-2x"/>
				</div>
				<div id="widget-total" class="impact large">My Widgets (0)</div>
			    <div id="cart" class="top-15">
			    	<span class="empty">No widgets selected.</span>       
			    </div>
				<hr/>
				<div class="impact large bottom-10">Setup Presentation Template</div>
				<input type="file" class="filepond" name="filepond"/>
				<button type="button" class="btn btn-default" onclick="uploadTemplate()">Upload template</button>
			</div>
		</div>

	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE PRESENTATION WIDGET SELECTION SECTION -->
		<xsl:template name="RenderWidgetPreviewSection">
		<!-- handlebars template to render a widget selection card -->
		<!--<script id="widget-selection-template" type="text/x-handlebars-template">
			{{#each widgets}}
				<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
					<div class="viewElementContainer">
						<div class=" viewElement">
							<div class="viewElementName fontBold large">
								{{name}}
							</div>
							<div class="viewElementDescription text-darkgrey">
								{{description}}
							</div>
							<div class="viewElementImage hidden-xs">
								<img alt="screenshot" class="img-responsive">
									<xsl:attribute name="src">{{{screenshot}}}</xsl:attribute>
								</img>
							</div>
						</div>
						<div class="viewElement-placeholder"/>
						<div class="report-element-preview">
							<span data-toggle="lightbox" class="text-lightgrey">
								<xsl:attribute name="href">{{{screenshot}}}</xsl:attribute>
								<i class="fa fa-search"/>
							</span>
						</div>
					</div>
				</div>
			{{/each}}
		</script>-->
		
		
		<!-- handlebars template to render a widget populated with data -->	
		<script id="widget-edit-template" type="text/x-handlebars-template">
			{{#each widgets}}
				<div>
					<xsl:attribute name="id">{{id}}-select</xsl:attribute>
					<xsl:attribute name="class">widget-preview-select cart-item</xsl:attribute>
					<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
					<div class="img-wrap">
						<img alt="">
							<xsl:attribute name="src">{{screenshot}}</xsl:attribute>
						</img>
					</div>
					<span class="strong small">{{name}}</span>
				</div>
			{{/each}}
		</script>
			
		<script id="widget-preview-template" type="text/x-handlebars-template">
			{{#each widgets}}
				<div class="widget-preview-div top-15 bottom-15">
					<h3><strong>{{name}}</strong></h3>
					<div class="btn-group">
						<a class="btn btn-default widget-download-btn">
							<xsl:attribute name="eas-svg">{{widgetId}}</xsl:attribute>
							<xsl:attribute name="id">download-{{widgetId}}</xsl:attribute>
							<i class="fa fa-download right-10"/>Right Click to Download SVG
						</a>
						<a class="btn btn-default customise-text-btn">
							<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
							<i class="right-10 fa fa-pencil"/>Edit Widget
						</a>
					</div>
					<div>
						<xsl:attribute name="id">{{widgetId}}-div</xsl:attribute>
					</div>
				</div>
			{{/each}}
		</script>
		
			<div class="left-sidebar">
				<div class="impact large">My Widgets</div>
				<div id="editWidgetList" class="top-10"/>	
			</div>
			<div class="tab-main">
				<span class="impact large right-10 top-15">Select Theme:</span>
				<select id="widgetThemeList" style="width:300px;" class="select2">
					<xsl:for-each select="$allWidgetThemes">
						<option>
							<xsl:attribute name="value"><xsl:value-of select="eas:getSafeJSString(current()/name)"/></xsl:attribute>
							<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
						</option>
					</xsl:for-each>
				</select>
				<div id="widget-preview-container" class="top-15">
					<!--<p class="lead"><strong>This report assists you in the selection of CxO Level Presentation Widgets that can be imported as SVG.</strong></p>
					<div id="app-dep-pie-chart-div"></div>-->
					<!--<div role="tabpanel">
						<!-\- Nav tabs -\->
						<ul class="nav nav-tabs hidden-xs" role="tablist">
							<li role="presentation" class="active">
								<a href="#all" aria-controls="all" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('All')"/>
								</a>
							</li>
							<li role="presentation">
								<a href="#enterprise" aria-controls="enterprise" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('Enterprise')"/>
								</a>
							</li>
							<li role="presentation">
								<a href="#business" aria-controls="business" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('Business')"/>
								</a>
							</li>
							<li role="presentation">
								<a href="#information" aria-controls="information" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('Information')"/>
								</a>
							</li>
							<li role="presentation">
								<a href="#application" aria-controls="application" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('Application')"/>
								</a>
							</li>
							<li role="presentation">
								<a href="#technology" aria-controls="technology" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('Technology')"/>
								</a>
							</li>
							<li role="presentation">
								<a href="#support" aria-controls="support" role="tab" data-toggle="tab">
									<xsl:value-of select="eas:i18n('Support')"/>
								</a>
							</li>
						</ul>
						<div class="verticalSpacer_10px hidden-xs"/>
						<!-\- Tab panes -\->
						<div class="tab-content">
							<div role="tabpanel" class="tab-pane active" id="all">
								<div id="core-app-dep-donut-div"></div>
							</div>
	
							<div role="tabpanel" class="tab-pane" id="enterprise"/>
	
							<div role="tabpanel" class="tab-pane" id="business"/>
							
							<div role="tabpanel" class="tab-pane" id="information"/>
		
							<div role="tabpanel" class="tab-pane" id="application"/>
	
							<div role="tabpanel" class="tab-pane" id="technology"/>
	
							<div role="tabpanel" class="tab-pane" id="support"/>
	
							                                
						</div>
					</div>-->
					<!--Close Left Container-->
				</div>
			</div>
			
			
			<!--Setup Closing Tags-->
		
		
		
		
		<!--<div class="dashboardPanel bg-offwhite bottom-30 pull-left">
			<p class="lead">Please select one or more Presentation Widget Templates to generate.</p>
			
		</div>-->
		
		
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A LIST OF JSON OBJECTS REPRESENTING WIDGETS -->
	<xsl:template mode="RenderWidgetJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Get Widget Template -->
		<xsl:variable name="thisWidgetTemplate" select="$allWidgetTemplates[name = $this/own_slot_value[slot_reference = 'pw_widget_template']/value]"/>
		<xsl:variable name="thisWidgetTags" select="$allWidgetTags[name = $this/own_slot_value[slot_reference = 'element_classified_by']/value]"/>
		
		
		'<xsl:value-of select="eas:getSafeJSString($this/name)"/>': {
			"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>",
			"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>",
			"widgetId": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>",
			"screenshot": "<xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_screenshot_file_path']/value"/>",
			"defaultWidth": <xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_width']/value"/>,
			"defaultHeight": <xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_height']/value"/>,
			"customText": [
				<xsl:for-each select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_user_defined_text']/value">
					{
						"id": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/><xsl:value-of select="current()"/>",
						"label": "<xsl:value-of select="current()"/>",
						"text": "<xsl:value-of select="current()"/>"			
					}<xsl:if test="not(position()=last())">,
					</xsl:if>
				</xsl:for-each>
			],
			"tags": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisWidgetTags"/>],
			"presentations": {}
		}<xsl:if test="not(position()=last())">,
		</xsl:if> 
		
	</xsl:template>
	
	
	<xsl:template mode="RenderWidgetFunction" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Get Widget Template -->
		<xsl:variable name="thisWidgetTemplate" select="$allWidgetTemplates[name = $this/own_slot_value[slot_reference = 'pw_widget_template']/value]"/>
		
		<!-- Get Data Set API -->
		<xsl:variable name="thisDataSetAPI" select="$allDataSetAPIs[name = $this/own_slot_value[slot_reference = 'pw_data_set_api']/value]"/>
		<xsl:variable name="thisDataSetAPIPath">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="$thisDataSetAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
			</xsl:call-template>
		</xsl:variable>
		
		//function to render the <xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/> widget
		var <xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_function_name']/value"/> = function() {
			if(apiData['<xsl:value-of select="$thisDataSetAPI/own_slot_value[slot_reference = 'dsa_data_label']/value"/>'] == null) {
				var xmlhttp = new XMLHttpRequest();
				xmlhttp.onreadystatechange = function() {
					if (this.readyState == 4 &amp;&amp; this.status == 200) {
						apiData['<xsl:value-of select="$thisDataSetAPI/own_slot_value[slot_reference = 'dsa_data_label']/value"/>'] = JSON.parse(this.responseText);
						if (widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'] == null) {
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'] = {};
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].dataSet = <xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_function_name']/value"/>Data(apiData['<xsl:value-of select="$thisDataSetAPI/own_slot_value[slot_reference = 'dsa_data_label']/value"/>']);
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].svgClass = '<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>';
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].containerId = '<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-div';
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].svgTheme = currentWidgetTheme;
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].width = <xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_width']/value"/>;
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].height = <xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_height']/value"/>;
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].scale = 1;
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].xPos = 0;
							widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].yPos = 0;
						}
						<xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_function_name']/value"/>(widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data']);
						
						//console.log('New widget rendered: ' + aWidget.id);
					}
				};
				xmlhttp.open("GET", "<xsl:value-of select="$thisDataSetAPIPath"/>", true);
				xmlhttp.send();
			} else {
				if (widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'] == null) {
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'] = {};
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].dataSet = <xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_function_name']/value"/>Data(apiData['<xsl:value-of select="$thisDataSetAPI/own_slot_value[slot_reference = 'dsa_data_label']/value"/>']);
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].svgClass = '<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>';
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].containerId = '<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-div';
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].svgTheme = currentWidgetTheme;
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].width = <xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_width']/value"/>;
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].height = <xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_height']/value"/>;
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].scale = 1;
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].xPos = 0;
					widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].yPos = 0;
				}
				<xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_function_name']/value"/>(widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data']);
			}
		}<xsl:text>
			
			
		</xsl:text>
	</xsl:template>
	
	
	
	<xsl:template mode="RenderSlideWidgetFunction" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<!-- Get Widget Template -->
		<xsl:variable name="thisWidgetTemplate" select="$allWidgetTemplates[name = $this/own_slot_value[slot_reference = 'pw_widget_template']/value]"/>
		
		
		//function to render the <xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/> widget in slides
		var <xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_function_name']/value"/>InSlide = function(aSlide, aSlideWidget) {
			var slideWidgetData = {
				'dataSet': widgetData['<xsl:value-of select="$this/own_slot_value[slot_reference = 'pw_widget_id']/value"/>-data'].dataSet
			}
			slideWidgetData.svgClass = 'real-' + aSlideWidget.id;
			slideWidgetData.containerId = 'real-slide-svg-' + aSlide.id;
			slideWidgetData.svgTheme = currentWidgetTheme;
			slideWidgetData.width = this.defaultWidth;
			slideWidgetData.height = this.defaultHeight;
			slideWidgetData.scale = aSlideWidget.svgScale;
			slideWidgetData.xPos = aSlideWidget.x;
			slideWidgetData.yPos = aSlideWidget.y;
			<xsl:value-of select="$thisWidgetTemplate/own_slot_value[slot_reference = 'pwt_function_name']/value"/>(slideWidgetData);
		}<xsl:text>
				
		</xsl:text>
	</xsl:template>
	
	
	
	
	<!-- TEMPLATE TO RENDER A JSON OBJECT REPRESENTING A WIDGET THEME -->
	<xsl:template mode="RenderWidgetTheme" match="node()">
		<xsl:variable name="this" select="current()"/>
		
		<xsl:variable name="thisWidgetThemeStyles" select="$allWidgetThemeStyles[name = $this/own_slot_value[slot_reference = 'pwt_styles']/value]"/>
		<xsl:variable name="thisWidgetThemeColours" select="$allWidgetThemeColours[name = $this/own_slot_value[slot_reference = 'pwt_category_colour_scheme']/value]"/>
		
		{
			'id': '<xsl:value-of select="eas:getSafeJSString($this/name)"/>',
			'name': '<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>',
			'styles': {<xsl:for-each select="$thisWidgetThemeStyles">
				<xsl:variable name="thisStyleClass" select="$allWidgetThemeStyleClasses[name = current()/own_slot_value[slot_reference = 'pws_styled_class']/value]"/>
				'<xsl:value-of select="$thisStyleClass/own_slot_value[slot_reference = 'enumeration_value']/value"/>': <xsl:value-of select="current()/own_slot_value[slot_reference = 'pws_style_values']/value"/><xsl:if test="not(position() = last())">,
				</xsl:if>
			</xsl:for-each>},
			'widgetCategories': [<xsl:for-each select="$thisWidgetThemeColours"><xsl:sort select="own_slot_value[slot_reference = 'pwtc_index']/value"/>'<xsl:value-of select="current()/own_slot_value[slot_reference = 'pwtc_colour']/value"/>'<xsl:if test="not(position() = last())">,
			</xsl:if></xsl:for-each>],
			'isDefault': <xsl:choose><xsl:when test="$this/own_slot_value[slot_reference = 'pwt_is_default']/value = 'true'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
		}<xsl:if test="not(position() = last())">,
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER A JAVASCRIPT IMPORT DECLARATION FOR WIDGET TEMPLATES-->
	<xsl:template mode="RenderWidgetTemplateFileImport" match="node()">
		<script>
			<xsl:attribute name="src" select="current()/own_slot_value[slot_reference = 'pwt_renderer_file_path']/value"/>
		</script><xsl:text>
		</xsl:text>
	</xsl:template>
	
	<!-- TEMPLATE TO RENDER A JAVASCRIPT IMPORT DECLARATION FOR WIDGETS-->
	<xsl:template mode="RenderWidgetFileImport" match="node()">
		<script>
			<xsl:attribute name="src" select="current()/own_slot_value[slot_reference = 'pw_render_file_path']/value"/>
		</script><xsl:text>
		</xsl:text>
	</xsl:template>
	
	<!-- TEMPLATE TO RENDER THE CSS STYLES FOR THE MY PRESENTATIONS SECTION -->
	<xsl:template name="RenderMyPresentationsStyles">
		<style type="text/css">		
		.pres-list {
			float: left;
			width: 100%;
			min-height: 450px;
		}
		
		.pres-item {
			width: 100%;
			height: 100px;
			padding: 5px 5px 5px 5px;
			margin-bottom: 10px;
			position:relative;
			float: left;
		}
		
		.pres-item-selected {
			border: 4px solid hsla(200, 80%, 30%, 1); !important;
		}
		
		.pres-item .edit-pres-btn {
			position: absolute;
			top: 10px;
			right: 10px;
			display: none;
		}
		
		.pres-item .delete-pres-btn {
			position: absolute;
			top: 70%;
			right: 10px;
			display: none;
		}
		
		.pres-item-selected:hover .edit-pres-btn {display:block;cursor:pointer}
		
		.pres-item-selected:hover .delete-pres-btn {display:block;cursor:pointer}
		

		.add-item-icon,customise-text-btn {
			cursor: pointer;
		}
		
		.pres-slides-title-disabled {
			display: none;
		}
		
		.pres-slide-deck {
			width: 100%;
			float: left;
		}
		
		.pres-slide {
			border: 2px dotted #555555;
			width: 100%;
			min-height: 450px;
			margin-bottom: 20px;
			position:relative;
			float: left;
			padding: 10px;
		}
		
		.pres-slide-selected {
			border: 4px solid red !important;
		}
		
		.widget-carousel {
			float: left;
			width: 100%;
			min-height: 450px;
		}
		
		
		.slide-widget-item {
			padding: 5px 10 5px 10px;
			height: 80px;
			width: 210px;
			float: left;
			position:relative;
			background:#fff;
		}
		
		.slide-widget-item .widget-thumbnail {
			width:70px; 
			height:70px; 
			overflow:hidden;
			border:1px solid #edeff0;
			float:left;	
		}
		
		.slide-widget-item img{width:100%; position:relative;top: 0;}
		
		.slide-widget-item strong{color:#5ff7d2; font-size:16px;}
		
		.slide-widget-item span{
			margin-left: 10px;
			width:100%; 
			height: 100%;
			color: #393c45;
			display: block;
			font-size: 12px;
		}
		
		.slide-widget-item-border{
			position:absolute;
			bottom: 0;
			left:0;
			background:#edeff0;
			height: 1px;
			width: 210px;
		}
		
		.slide-widget-item .add-widget-btn{
			position:absolute;
			top: 50px;
			right: 10px;
			display:none;
		}
		
		.slide-widget-item:hover .add-widget-btn{display:block;cursor:pointer}
		
		.drag-active {
			stroke: red;
			stroke-width: 2px;
		}
		
		<!--g.grabCircles {
			margin-left: 30px;
		}-->
		
		g.grabCircles circle:hover {
			cursor: move;
		}
		
		.resizing {
			fill: blue;
		}
		
		.real-pres-slide {
			border:1px solid black;
		}
		</style>
	</xsl:template>
	
	
	<!-- TEMPLATE TO RENDER THE INITIATION JAVASCRIPT FOR MY PRESENTATIONS SECTION -->
	<xsl:template name="RenderMyPresentationsInitJS">
			
		
		//setTimeout(function(){updateSelectedWidgetText()}, 200);
		if(currentPresentation != null) {
			refreshSlideList();
		}
		
		$('#pres-widget-carousel').html(slideWidgetTemplate(selectedWidgets)).promise().done(function(){
			
			$('.add-widget-icon').on('click', function (evt) {
			
				if(currentSlide != null) {
					var widgetId = $(this).attr('eas-widget-id');
					var svgId = $(this).attr('eas-id');
					var svgMaxWidth = $(this).attr('eas-width');
					var svgMaxHeight = $(this).attr('eas-height');
					//console.log('adding widget: ' + svgId);
					//var newSlideWidgetIndex = Object.values(currentSlide.slideWidgets).length + 1;
					var newSlideWidget = {
						'id': currentSlide.id + '-widget' + userData.nextSlideWidgetId,
						'svgId': svgId,
						'widgetId': widgetId, 
						'slideId': currentSlide.id,
						'presId': currentPresentation.id,
						'x': 0,
						'y': 0,
						'newX': 0,
						'newY': 0,
						'maxWidth': svgMaxWidth,
						'maxHeight': svgMaxHeight,
						'svgScale': 0.5,
						'selected': true
					}
					currentSlide.slideWidgets[newSlideWidget.id] = newSlideWidget;
					userData.nextSlideWidgetId++;
					
					var thisWidget = widgets[widgetId];
					if(thisWidget != null) {
						if(thisWidget.presentations[currentPresentation.id] == null) {
							thisWidget.presentations[currentPresentation.id] = {
								'presentation': currentPresentation,
								'widgets': {}
							}
						}
						thisWidget.presentations[currentPresentation.id].widgets[newSlideWidget.id] = newSlideWidget;
					}
					
					//update the slides
					currentSlideWidget = newSlideWidget;
					refreshSlideList();
				}
			});
		});
		
	</xsl:template>
	
	
	
	<!-- TEMPLATE TO RENDER THE MY PRESENTATIONS SECTION -->
	<xsl:template name="RenderMyPresentationsSection">
		<script>
			$(window).scroll(function() {
				if ($(this).scrollTop()>400) {
					$('#pres-widget-carousel').css('top','0px');
					$('#pres-widget-carousel').css('position','fixed');
					
					$('#editWidgetList').css('top','0px');
					$('#editWidgetList').css('position','fixed');
				}
				if ($(this).scrollTop()&lt;400) {
					$('#pres-widget-carousel').css('top', '0px');
					$('#pres-widget-carousel').css('position','absolute');
					
					$('#editWidgetList').css('top', '0px');
					$('#editWidgetList').css('position','absolute');
				}
			});
		</script>
		
		<!-- Handlebars template for an item in the presentaton list -->
		<script id="pres-item-template" type="text/x-handlebars-template">
			{{#eachInMap presentations}}
				<div>
					<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
					<xsl:attribute name="class">pres-item bg-lightblue-100 {{#if value.selected}}pres-item-selected{{/if}}</xsl:attribute>
					<span class="impact small">{{value.name}}</span>
					<div class="top-10"><i class="fa fa-file-image-o fa-2x"/></div>
					<div class="edit-pres-btn">
						<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
						<i class="fa fa-pencil"/>	
					</div>
					<div class="delete-pres-btn">
						<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
						<i class="fa fa-trash"/>				
					</div>
				</div>
			{{/eachInMap}}
		</script>
		
		
		<!-- Handlebars template for slide in a presentation -->
		<script id="slide-template" type="text/x-handlebars-template">
			{{#eachInMap slides}}
				<div>
					<xsl:attribute name="id">{{value.id}}-div</xsl:attribute>
					<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
					<xsl:attribute name="class">pres-slide {{#if value.selected}}pres-slide-selected{{/if}}</xsl:attribute>
					
					<span class="slide-heading">{{value.heading}}</span>	
					<div class="btn-group pull-right">
						<a class="btn btn-default edit-slide-btn">
							<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
							<i class="fa fa-pencil right-10"/><span>Edit Slide</span></a>
						<a class="btn btn-default delete-slide-btn">
							<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
							<i class="fa fa-trash right-10"/><span>Delete Slide</span></a>
					</div>
					<div class="clearfix"/>
					<svg width="1200" class="slide-widget" height="450" version="1.1" xmlns="http://www.w3.org/2000/svg">
						<xsl:attribute name="id">{{value.id}}</xsl:attribute>
						<!--<xsl:attribute name="title">{{value.name}}</xsl:attribute>-->
						{{#eachInMap value.slideWidgets}}
							<svg class="slide-widget-svg">
								<xsl:attribute name="id">{{value.id}}</xsl:attribute>
								<xsl:attribute name="x">{{value.x}}</xsl:attribute>
								<xsl:attribute name="y">{{value.y}}</xsl:attribute>
								<use>
									<xsl:attribute name="transform">scale({{value.svgScale}})</xsl:attribute>
									<xsl:attribute name="href">#{{value.svgId}}</xsl:attribute>
								</use>
							</svg>
						{{/eachInMap}}
					</svg>
				</div>
				<!--<div class="pull-left col-xs-12 col-sm-6 col-md-4 col-lg-3">
					<i class="slide-download-btn fa fa-plus-circle">
						<xsl:attribute name="eas-svg">{{value.id}}</xsl:attribute>
						<xsl:attribute name="id">download-{{value.id}}</xsl:attribute>
					</i>
				</div>-->
			{{/eachInMap}}
		</script>
		
		<script id="slide-widget-template" type="text/x-handlebars-template">
			{{#each widgets}}
				<div class="slide-widget-item bottom-10">
					<div class="widget-thumbnail">
						<img alt="">
							<xsl:attribute name="src">{{screenshot}}</xsl:attribute>
						</img>
					</div>
					<span class="left-10">{{name}}</span>
					<div class="slide-widget-item-border"/>
					<div class="add-widget-btn">
						<i class="add-widget-icon left-10 fa fa-plus-circle">
							<xsl:attribute name="eas-widget-id">{{id}}</xsl:attribute>
							<xsl:attribute name="eas-id">{{widgetId}}-id</xsl:attribute>
							<xsl:attribute name="eas-width">{{defaultWidth}}</xsl:attribute>
							<xsl:attribute name="eas-height">{{defaultHeight}}</xsl:attribute>
						</i>
					</div>		
				</div>
			{{/each}}
		</script>
		
		
		<!-- Handlebars template for slide in a real presentation to be generated-->
		<script id="real-slide-template" type="text/x-handlebars-template">
			{{#eachInMap slides}}
				<div>
					<xsl:attribute name="id">real-slide-div-{{value.id}}-div</xsl:attribute>
					<xsl:attribute name="eas-id">{{value.id}}</xsl:attribute>
					<xsl:attribute name="class">real-pres-slide</xsl:attribute>
					<svg width="1200" height="450" preserveAspectRatio="xMinYMin meet" class="slide-widget" version="1.1" xmlns="http://www.w3.org/2000/svg">
						<xsl:attribute name="id">real-slide-svg-{{value.id}}</xsl:attribute>
					</svg>
				</div>
			{{/eachInMap}}
		</script>
		
		
		<!-- Handlebars template for the contents of the Presentation Editor Modal -->
		<script id="presentation-editor-template" type="text/x-handlebars-template">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
				<p class="modal-title xlarge" id="presEditorLabel"><i class="modal-icon right-10 text-primary glyphicon glyphicon-picture"></i><strong><span class="text-darkgrey">{{action}} <xsl:value-of select="eas:i18n('Presentation')"/></span></strong></p>
				<div class="clearfix"></div>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-xs-12">
						<form>
				          <div class="form-group">
					            <label for="presName" class="col-form-label">Name:</label>
					            <input type="text" class="form-control bottom-10" id="presName">
					            	<xsl:attribute name="value">{{presentation.name}}</xsl:attribute>
					            	<xsl:attribute name="placeholder"><xsl:value-of select="eas:i18n('Enter a name for the presentation')"/></xsl:attribute>
					            </input>
				          		<label for="presDesc" class="col-form-label">Description:</label>
					            <textarea class="form-control" id="presDesc"><xsl:attribute name="placeholder"><xsl:value-of select="eas:i18n('Enter a description for the presentation')"/></xsl:attribute>{{presentation.description}}</textarea>
				          </div>
				        </form>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal"><xsl:value-of select="eas:i18n('Cancel')"/></button>
				<button type="button" class="savePresBtn btn btn-success">{{action}}</button>
			</div>
		</script>
		
		<!-- Presentation Editor Modal -->
		<div class="modal fade" id="presEditorModal" tabindex="-1" role="dialog" aria-labelledby="presEditorLabel">
			<div class="modal-dialog modal-med" role="document">
				<div class="modal-content" id="presEditorModelContent"/>						
			</div>
		</div>
		
		
		<!-- Handlebars template for the contents of the Slide Editor Modal -->
		<script id="slide-editor-template" type="text/x-handlebars-template">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
				<p class="modal-title xlarge" id="slideEditorLabel"><i class="modal-icon right-10 text-primary glyphicon glyphicon-picture"></i><strong><span class="text-darkgrey">{{action}} <xsl:value-of select="eas:i18n('Slide')"/></span></strong></p>
				<div class="clearfix"></div>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-xs-12">
						<form>
				          <div class="form-group">
					            <label for="slideHeading" class="col-form-label">Heading:</label>
					            <input type="text" class="form-control bottom-10" id="slideHeading">
					            	<xsl:attribute name="value">{{slide.heading}}</xsl:attribute>
					            	<xsl:attribute name="placeholder"><xsl:value-of select="eas:i18n('Enter a Heading for the slide')"/></xsl:attribute>
					            </input>
				          		<label for="slideDesc" class="col-form-label">Description:</label>
					            <textarea class="form-control" id="slideDesc"><xsl:attribute name="placeholder"><xsl:value-of select="eas:i18n('Enter a description for the slide')"/></xsl:attribute>{{slide.description}}</textarea>
				          </div>
				        </form>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" id="cancelSlideBtn" class="btn btn-danger"><xsl:value-of select="eas:i18n('Cancel')"/></button>
				<button type="button" class="saveSlideBtn btn btn-success">{{action}}</button>
			</div>
		</script>
		
		<!-- Slide Editor Modal -->
		<div class="modal fade" id="slideEditorModal" tabindex="-1" role="dialog" aria-labelledby="slideEditorLabel">
			<div class="modal-dialog modal-med" role="document">
				<div class="modal-content" id="slideEditorModelContent"/>						
			</div>
		</div>
		
		
		<div class="tab-main">
			<div class="row">
				<div class="col-xs-2">
					<div class="impact large">My Presentations</div>
					<a class="btn btn-default top-10 bottom-10" id="add-pres-btn"><i class="fa fa-plus-circle right-10"/>Create Presentation</a>
					<div id="my-presentation-list" class="pres-list"/>
				</div>
				<div class="col-xs-8 ">
					<div id="pres-slides-header" class="impact large pres-slides-title-disabled">
						<span class="">Presentation: </span><span id="pres-slides-title"/>
					</div>
					<div class="top-10 bottom-10">
						<div class="btn-group">
							<a class="btn btn-default" id="add-slide-btn"><i class="right-10 fa fa-plus-circle"/>Add Slide</a>
							<a class="btn btn-default" id="download-pres-btn"><i class="right-10 fa fa-download"/>Download Presentation</a>
							
						</div>
						<span id="download-pres-status" class="left-10 strong"/>
					</div>
					<div id="presentation-slides" class="pres-slide-deck"/>
				</div>
			</div>			
			
			<div class="row">
				<div class="col-xs-12 col-md-9" id="real-presentation-container"/>
			</div>
		</div>
		<div class="right-sidebar">
			<span class="impact large">My Widgets</span>
			<div id="pres-widget-carousel"/>
		</div>
	</xsl:template>


</xsl:stylesheet>
