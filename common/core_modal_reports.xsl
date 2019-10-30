<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<!--<xsl:import href="core_utilities.xsl"/>-->
	
	<xsl:param name="X-CSRF-TOKEN"/>
	<xsl:param name="eipMode"/>
	
	<xsl:variable name="modalRepoVersion" select="/node()/simple_instance[type='Meta_Model_Version'][1]/own_slot_value[slot_reference = 'meta_model_version_id']/value"/>
	<xsl:variable name="essAllModalReports" select="/node()/simple_instance[(type = 'Modal_Report') and (own_slot_value[slot_reference = 'modal_report_is_enabled']/value = 'true')]"/>
	<xsl:variable name="essAllModalDataSetAPIs" select="/node()/simple_instance[name = $essAllModalReports/own_slot_value[slot_reference = 'modal_report_content_apis']/value]"/>
	<xsl:variable name="essAllModalClasses" select="$essAllModalReports/own_slot_value[slot_reference = 'modal_report_for_classes']/value"/>

	<xsl:variable name="essModalFunctionSuffix">Show</xsl:variable>
	
	<xsl:template name="RenderModalReportContent">
		<xsl:param name="essModalClassNames" select="()"/>
		
		<xsl:variable name="modalIdeationConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Ideation Enabled')]/own_slot_value[slot_reference = 'report_constant_value']/value"/>
		<xsl:variable name="modalIdeationIsOn" select="string-length($modalIdeationConstant)"/>
		
		<!-- only add modal content if there is at least one class provided -->
		<xsl:if test="($modalIdeationIsOn) and (count($essModalClassNames) > 0) and ($eipMode = 'true') and ($modalRepoVersion >= '6.6')">
			<xsl:variable name="essRelevantModals" select="$essAllModalReports[own_slot_value[slot_reference = 'modal_report_for_classes']/value = $essModalClassNames]"/>
			<xsl:variable name="essRelevantAPIs" select="$essAllModalDataSetAPIs[name = $essAllModalReports/own_slot_value[slot_reference = 'modal_report_content_apis']/value]"/>
			
			<xsl:if test="count($essRelevantModals) > 0">
				<!-- Add the common modal css -->
				<style type="text/css">
					.infoButton{
							position: absolute;
							bottom: 3px;
							right: 3px;
						}
						
						.lowHeatmapColour{
							background-color: hsla(352, 99%, 41%, 1);
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
							
						.neutralHeatmapColour{
							background-color: hsla(37, 92%, 55%, 1);
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
						
						.mediumHeatmapColour{
							background-color: hsla(89, 73%, 48%, 1);
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
						
						.highHeatmapColour{
							background-color: hsla(119, 42%, 46%, 1);
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
						
						.noHeatmapColour{
							background-color: #999;
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
						
						.in-scope-element {
							background-color: hsla(175, 60%, 40%, 1);
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
						
						.out-of-scope-element{
							background-color: #999;
							color: #fff;
							-webkit-transition: all 0.5s ease;
							-moz-transition: all 0.5s ease;
							-o-transition: all 0.5s ease;
							-ms-transition: all 0.5s ease;
							transition: all 0.5s ease;
						}
						
						.fa-info-circle:hover {cursor: pointer;}
						.summaryBlock,
						.summaryBlockHeader{
							padding: 5px;
							position: relative;
							display: table;
							width: 100%;
						}
						
						.summaryBlock{
							height: 50px;
						}
						
						.summaryBlockLabel{
							display: table-cell;
							vertical-align: middle;
						}
						
						.summaryBlockResult{
							display: table-cell;
							vertical-align: middle;
							text-align: center;
						}
						
						.summaryBlockNumber{
							text-align: center;
						}
						
						.summaryBlockDesc{
							text-align: center;
						}
						
						.summaryBlock > i{
							position: absolute;
							right: 5px;
							bottom: 3px;
						}
						
						.serviceQualOuter{
							height: 90px;
							margin-bottom: 10px;
							border: 1px solid #aaa;
							padding: 10px 10px 0px 30px;
							border-radius: 4px;
							background-color: #eee;
						}
						
						.serviceQual-title{
							margin-bottom: 10px;
							line-height: 1.1em;
						}
						
						.pl_action_button {
							min-width: 80px;
							padding: 2px;
						}
						
						.modal_action_button {
							width: 110px;
						}
	
						.actionSelected { 
							background-color: hsla(220, 70%, 85%, 1) !important;
						}
						
						.helpButton{
							position: absolute;
							z-index: 100;
							top: -80px;
							right: 15px;
							width: 200px;
							box-shadow: rgba(0, 0, 0, 0.117647) 0px 1px 6px 0px, rgba(0, 0, 0, 0.117647) 0px 1px 4px 0px;
						}		
						
						.threeColModel_valueChainColumnContainer .threeColModel_modalValueChainColumnContainer{
						    margin-right: 8px;
						    float: left;
						    position: relative;
						    box-sizing: content-box;
						    display: table;
						}
						
						.threeColModel_valueChainObject{
						    width: 115px;
						    padding: 5px 20px 5px 5px;
						    height: 40px;
						    text-align: center;
						    background: url(images/value_chain_arrow_end_grey.png) no-repeat right center;
						    position: relative;
						    box-sizing: content-box;
						    display: table-cell;
						    vertical-align:middle;
						}
						
						
						.threeColModel_valueChainObject:hover{
						    opacity: 0.75;
						    cursor: pointer;
						    box-sizing: content-box;
						}
						
						.popover {
						    max-width: 400px;
						}
						
						@media (min-width: 768px) {
						  .modal .modal-xl {
						    width: 90%;
						   max-width:1200px;
						  }
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
						
						.dt-checkboxes-select-all,.dt-checkboxes-cell {text-align:left!important;}
						
						.selected-gantt-plan {
							background: #23964d;
							border: 2px solid #23964d;
						}
						
						.selected-gantt-title {
							color: #23964d;
						}
						
						/********************************************************************/
						/*** SERVICE QUALITY GAUGE STYLES ***/
						.gaugePanel{
						  width: 100%;
						  float: left;
						}
						
						.gaugeLabel{
						  width: 100%;
						  float: left;
						  line-height: 1.1em;
						  text-align: center;
						}
						
						.gaugeContainer{
						  width: 100%;
						  float: left;
						  text-align: center;
						}
						/********************************************************************/
						
						ul.multi-column-list {
						  columns: 2;
						  -webkit-columns: 2;
						  -moz-columns: 2;
						}
				</style>
				
				<!-- Start Service Quality Gauge library -->
				<script type="text/javascript" src="js/gauge.min.js"></script>
				
				<!-- Add the common modal javascript variables and functions -->
				<script type="text/javascript">
					
					/*************************************************
					Start Commmon Modal API variables Functions
					**************************************************/
					
					
					/****** END COMMON MODAL API VARIABLES AND FUNCTIONS  ******/
					
					/*********************************************
					START COMMON MODAL UI VARIABLES AND FUNCTIONS
					*********************************************/
					var essModalHistory = []; 
					var essCurrentModal;
					var essNextModalElement;							
					var essElementUnderReview;
					var essModalActionId;
					var essInitModalActionId;
					var essModalData = {};
					var essModalHeatmap;
					var planningActionButtonTemplate, noActionButtonTemplate;
					
					<xsl:if test="count($essRelevantModals) > 0">
					var <xsl:apply-templates mode="RenderModalHBTemplateVars" select="$essRelevantModals"/>;
					</xsl:if>
					
					 //function to reset the modal history
					function essResetModalHistory() {
						essModalHistory = []; 
						essCurrentModal = null;
						essNextModalElement = null;							
						essElementUnderReview = null;
						essInitModalActionId = null;
					}
					
					
					//function to update the list of ideas/options in a modal
					function essUpdateIdeasModalNeeds() {
						//set up the requirements list
						if(essIdeas.needs != null) {
							$('.ideaReqList').html(essEAElementListTemplate(essIdeas.needs)).promise().done(function(){
								//set up the ideas list
								if(essIdeas.currentNeed != null) {
									$('.ideaReqList').val(essIdeas.currentNeed['id']).trigger('change');
								}	
							});
						}
							
						if((essIdeas.currentNeed != null) &amp;&amp; (essIdeas.currentNeed.ideas != null)) {
							$('.ideaList').html(essEAElementListTemplate(essIdeas.currentNeed.ideas)).promise().done(function(){
								if(essIdeas.currentIdea != null) {
									$('.ideaList').val(essIdeas.currentIdea['id']).trigger('change');
								}
							});
						}								
					}
					
					
					//function to update the list of ideas/options in a modal
					function essUpdateIdeasModalIdeas() {				
						
						$('.ideaList').html(essEAElementListTemplate(essIdeas.currentNeed.ideas)).promise().done(function(){
							if(essIdeas.currentIdea != null) {
								$('.ideaList').val(essIdeas.currentIdea['id']).trigger('change');
							}
						});
					}
					
					//function to reset the input fields in the form that creates a new need and idea
					function essResetCreateNeedModalForm() {
						$('#create-idea-name').val('');
						$('#create-option-name').val('');
						$('#create-idea-desc').val('');
						$('#create-idea-error').val('');
					}
					
					
					//function to reset the input fields in the form that creates a new idea
					function essResetCreateIdeaOnlyModalForm() {
						$('#create-option-only-name').val('');
						$('#create-option-only-desc').val('');
						$('#create-option-only-error').val('');
					}
					
					
					//function to add common event listerens to ideas modals
					function essAddIdeasModalListeners() {
					
						//set up the requirements list
						if(essIdeas.needs != null) {
							$('.ideaReqList').html(essEAElementListTemplate(essIdeas.needs));							
						}
						
						//set up the ideas list
						if((essIdeas.currentNeed != null) &amp;&amp; (essIdeas.currentNeed.ideas != null)) {
							$('.ideaList').html(essEAElementListTemplate(essIdeas.currentNeed.ideas));
						}	
					
						$('.ideaReqList').select2({
							'placeholder': 'Select a requirement'
						});
						
						if(essIdeas.currentNeed != null) {
							$('.ideaReqList').val(essIdeas.currentNeed['id']).trigger('change');
						}
						
						$('.ideaReqList').on('select2:select', function (e) {
						    var newReqId = e.params.data.id;
						    if(newReqId != null) {
						    	//update up the ideas list
						    	var selectedReq = essIdeas.needs.find(function(aReq) {
						    		return aReq.id == newReqId;
						    	});
								if(selectedReq != null) {
									essIdeas.currentNeed = selectedReq;
									essIdeas.currentIdea = null;
									if(selectedReq.ideas != null) {
										$('.ideaList').html(essEAElementListTemplate(selectedReq.ideas));	
										if(selectedReq.ideas.length > 0) {
											essIdeas.currentIdea = selectedReq.ideas[0];
											$('.ideaList').val(essIdeas.currentIdea['id']).trigger('change');
										}
									}
								}
						    }
						});
						
						
						$('.ideaList').select2({
							'placeholder': 'Select an idea'
						});
						
						$('.ideaList').on('select2:select', function (e) {
						    var newIdeaId = e.params.data.id;
						    if(newIdeaId != null) {
						    	//update up the ideas list
						    	var selectedIdea = essIdeas.currentNeed.ideas.find(function(anIdea) {
						    		return anIdea.id == newIdeaId;
						    	});
								if(selectedIdea != null) {
									essIdeas.currentIdea = selectedIdea;
								}
						    }
						});
						
						
						if(essIdeas.currentIdea != null) {
							$('.ideaList').val(essIdeas.currentIdea['id']).trigger('change');
						}
						
						
						
						
						$('.planningActionlist').select2();
						
						$('.planningActionlist').on('select2:select', function (e) {
						    var newActionId = e.params.data.id;
						    essModalActionId = newActionId;
						    let selectedAction = essElementUnderReview.planningActions.find(function(anAction) {
					    		return anAction.id == essModalActionId;
					    	});
					    	
					    	var actionStyleClass;
					    	if((selectedAction != null) &amp;&amp; (selectedAction.style != null) &amp;&amp; (selectedAction.style.styleClass != null)  &amp;&amp; (selectedAction.style.styleClass.length > 0)) {
					    		actionStyleClass = selectedAction.style.styleClass;
					    	} else {
					    		actionStyleClass = 'actionSelected';
					    	}
						    
						    if(newActionId == 'NO_CHANGE') {
								$(".planningActionlist + .select2 .select2-selection__rendered").removeClass('actionSelected');
							} else {
								$(".planningActionlist + .select2 .select2-selection__rendered").addClass('actionSelected');
							}
						});
						
						$('#create-idea-btn').on('click', function (evt) {
							let thisButton = $(this);
							thisButton.prop('disabled', true);
							let needName = $('#create-idea-name').val();
							let ideaName = $('#create-option-name').val();
							
							$('#create-idea-error').text('');
							if((needName == null) || (ideaName == null) || (needName.length == 0) || (ideaName.length == 0)) {
								$('#create-idea-error').text('An idea name and option name must be provided');
								thisButton.prop('disabled', false);
							} else {
								thisButton.html('Updating...');
								let ideaDesc = $('#create-option-desc').val();
								
								essCreateNeed(needName, '')
								.then(function (response) {
									let newNeed = response;
									addNewNeedDetails(newNeed);
									
									essCreateIdea(ideaName, ideaDesc)
									.then(function (response) {
										<!--let newIdea = response;
										addNewIdeaDetails(newIdea);-->
										essUpdateIdeasModalNeeds();
										
										$('#create-idea-form').slideUp();
										thisButton.html('Create');
										thisButton.prop('disabled', false);
										essResetCreateNeedModalForm();
									})
									.catch (function (error) {
										thisButton.html('Create');
								        $('#create-idea-error').text('An error occurred when creating the new option');
								        thisButton.prop('disabled', false);
								    });	
								})
								.catch (function (error) {
									thisButton.html('Create');
							        $('#create-idea-error').text('An error occurred when creating the new idea');
							        thisButton.prop('disabled', false);
							    });	
							}
						});
						
						
						$('#create-option-only-btn').on('click', function (evt) {
							let thisButton = $(this);			
							thisButton.prop('disabled', true);
							let ideaName = $('#create-option-only-name').val();
							
							$('#create-option-only-error').text('');
							if((ideaName == null) || (ideaName.length == 0)) {
								$('#create-option-only-error').text('An option name must be provided');
								thisButton.prop('disabled', false);
							} else {
								thisButton.html('Updating...');
								let ideaDesc = $('#create-option-only-desc').val();
								essCreateIdea(ideaName, ideaDesc)
								.then(function (response) {
									essUpdateIdeasModalIdeas();
									
									$('#create-option-only-form').slideUp();
									thisButton.html('Create');
									thisButton.prop('disabled', false);
									essResetCreateIdeaOnlyModalForm();
								})
								.catch (function (error) {
									thisButton.html('Create');
							        $('#create-option-only-error').text('An error occurred when creating the new option');
							        thisButton.prop('disabled', false);
							    });	
							}
						});
						
						
					
					    $('.openModalBtn').on('click', function (evt) {
					
							var elementId = $(this).attr('eas-id');
							var elementList = $(this).attr('eas-elements');
							var element = essModalData[elementList].find(function(anEl) {
								return anEl.id == elementId;
							});					
							//var element = getObjectById(essModalData[elementList], "id", elementId);
							
							essNextModalElement = element;
							essModalHistory.push(essElementUnderReview);
					        
					        //hide the current modal
					        essCurrentModal.modal('hide');
							//$('#busCapModal').modal('hide');
						});
						
						
						$('.essModalCancelButton').on('click', function (evt) {
											
							//hide the current modal
							essCurrentModal.modal('hide');
							
							//reset the modal history
							essResetModalHistory();
						});
						
						$('.essModalConfirmButton').on('click', function (evt) {
							var errorList = [];
							if(essIdeas.currentIdea == null) {
								errorList.push('An idea must be selected');
							}
							if(essInitModalActionId == essModalActionId) {
								errorList.push('The proposed action has not been changed');
							}
							
							let selectedAction = essIdeas.planningActions.find(function(anAction) {
					    		return anAction.id == essModalActionId;
					    	});
					    	if(selectedAction == null) {
								errorList.push('The planning action is invalid');
							}
						
							if(errorList.length == 0) {
								
								//get the rationale
								var theRationale = $('#essIdeaModalRationale').val();
								
								//let newIdeaAction = new essIdeaChange(essElementUnderReview, selectedAction, theRationale);
								essAddChangeToIdea(essElementUnderReview, selectedAction, theRationale);
								
								//create the new action and add it to the idea
								//console.log('Proposal to ' + essModalActionId + ' on ' + essElementUnderReview.name + ' as part of ' + essIdeas.currentIdea.name + ' with rationale ' +  theRationale);
								//console.log(newIdeaAction);
								
								//hide the current modal
								essCurrentModal.modal('hide');
								
								//reset the modal history
								essResetModalHistory();
							} else {
								//show an error
								console.log('Update errors');
								console.log(errorList);
							}
						});
						
					}
					
					
					<!--//function to show the next modal when another modal is hidden
					function essShowNextModal(essElementUnderReview) {
						//console.log('Next Element: ' + essNextModalElement);
						essElementUnderReview = null;	
						if(essNextModalElement != null) {
							var elementModal = essNextModalElement.editorId;
							$('#' + elementModal).modal('show');
						} else if(essModalHistory.length > 0) {
							essNextModalElement = essModalHistory.pop();
							var elementModal = essNextModalElement.editorId;
							$('#' + elementModal).modal('show');	
						}
					}
					
					
					//function to return the HTML for a planning action button
					function renderReviewButton(objectList, anId) {
						var theObj = objectList.find(function(anObj) {
						   return anObj.id == anId; 
						})
						//getObjectById(objectList, "id" , anId);
						if(theObj != null) {
							if(theObj.planningAction != null) {
								return planningActionButtonTemplate(theObj);							
							} else {
								return noActionButtonTemplate(theObj);
							}
						} else {
							return "";
						}
					}-->
					
					
					<xsl:for-each select="$essModalClassNames">
						<xsl:call-template name="RenderModalFuncsForClass">
							<xsl:with-param name="className" select="."/>
						</xsl:call-template>
					</xsl:for-each>		
					
					$(document).ready(function(){
						essAddViewerDataSetAPIUrls([<xsl:apply-templates mode="RenderViewerDataSetAPIDetails" select="$essRelevantAPIs"/>]);
	
					
						<xsl:apply-templates mode="RenderModalHBCompiles" select="$essRelevantModals"/>
					
						<xsl:for-each select="$essModalClassNames">
							<xsl:call-template name="RenderModalListenersForClass">
								<xsl:with-param name="className" select="."/>
							</xsl:call-template>
						</xsl:for-each>				
					});
					
					/****** END COMMON MODAL UI VARIABLES AND FUNCTIONS  ******/
					
				</script>
				
				<!-- Handlebars template to render value stages -->
				<script id="ess-modals-list-template" type="text/x-handlebars-template">
					{{#each this}}
						<option/>
						<option>
							<xsl:attribute name="value">{{id}}</xsl:attribute>
				  			{{name}}
				  		</option>
					{{/each}}
				</script>
				
				
				<xsl:for-each select="$essModalClassNames">
					<xsl:call-template name="RenderModalsForClass">
						<xsl:with-param name="className" select="."/>
					</xsl:call-template>
				</xsl:for-each>
				
				<!-- For each class -->
				
		</xsl:if>
		</xsl:if>
	
	</xsl:template>
	
	
	
	<xsl:template mode="RenderModalHBTemplateVars" match="node()">
		<xsl:variable name="thisModal" select="current()"/>
		
		<xsl:value-of select="$thisModal/own_slot_value[slot_reference = 'modal_report_js_name']/value"/>Template<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	<xsl:template mode="RenderModalHBCompiles" match="node()">
		<xsl:variable name="thisModalShortName" select="current()/own_slot_value[slot_reference = 'modal_report_js_name']/value"/>
		<xsl:variable name="thisModalTemplateName" select="current()/own_slot_value[slot_reference = 'modal_report_template_name']/value"/>
		
		
		<!-- Render JS to complie relevant Handlebars template-->
		var <xsl:value-of select="$thisModalShortName"/>Fragment   = $("#<xsl:value-of select="$thisModalTemplateName"/>").html();
		<xsl:value-of select="$thisModalShortName"/>Template = Handlebars.compile(<xsl:value-of select="$thisModalShortName"/>Fragment);
	</xsl:template>
	
	
	<xsl:template name="RenderModalsForClass">
		<xsl:param name="className"/>
		
		<xsl:choose>
			<xsl:when test="$className = 'Business_Capability'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">busCap</xsl:with-param>
					<xsl:with-param name="templatePrefix">bus-cap</xsl:with-param>
					<xsl:with-param name="subjectType">Business Capability</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Business_Process'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">busProc</xsl:with-param>
					<xsl:with-param name="templatePrefix">bus-proc</xsl:with-param>
					<xsl:with-param name="subjectType">Business Process</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Group_Actor'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">org</xsl:with-param>
					<xsl:with-param name="templatePrefix">org</xsl:with-param>
					<xsl:with-param name="subjectType">Organisation</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Site'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">site</xsl:with-param>
					<xsl:with-param name="templatePrefix">site</xsl:with-param>
					<xsl:with-param name="subjectType">Office/Site</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Application_Capability'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">appCap</xsl:with-param>
					<xsl:with-param name="templatePrefix">app-cap</xsl:with-param>
					<xsl:with-param name="subjectType">Application Capability</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Application_Service'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">appSvc</xsl:with-param>
					<xsl:with-param name="templatePrefix">app-svc</xsl:with-param>
					<xsl:with-param name="subjectType">Application Service</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = ('Application_Provider', 'Composite_Application_Provider')">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">appProv</xsl:with-param>
					<xsl:with-param name="templatePrefix">app-prov</xsl:with-param>
					<xsl:with-param name="subjectType">Application</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Capability'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">techCap</xsl:with-param>
					<xsl:with-param name="templatePrefix">tech-cap</xsl:with-param>
					<xsl:with-param name="subjectType">Technology Capability</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Component'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">techComp</xsl:with-param>
					<xsl:with-param name="templatePrefix">tech-comp</xsl:with-param>
					<xsl:with-param name="subjectType">Technology Component</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Product'">
				<xsl:call-template name="RenderGenericIdeaModal">
					<xsl:with-param name="prefix">techProd</xsl:with-param>
					<xsl:with-param name="templatePrefix">tech-prod</xsl:with-param>
					<xsl:with-param name="subjectType">Technology Product</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>		
	</xsl:template>
	
	
	<xsl:template name="RenderModalFuncsForClass">
		<xsl:param name="className"/>
		
		<xsl:choose>
			<xsl:when test="$className = 'Business_Capability'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">busCap</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderBusCap</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Business_Process'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">busProc</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderBusProc</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Group_Actor'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">org</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderOrg</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Site'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">site</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderSite</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Application_Capability'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">appCap</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderAppCap</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Application_Service'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">appSvc</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderAppSvc</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = ('Application_Provider', 'Composite_Application_Provider')">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">appProv</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderAppProv</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Capability'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">techCap</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderTechCap</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Component'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">techComp</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderTechComp</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Product'">
				<xsl:call-template name="RenderGenericIdeaModalFuncs">
					<xsl:with-param name="prefix">techProd</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderTechProd</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>		
	</xsl:template>
	
	
	<xsl:template name="RenderModalListenersForClass">
		<xsl:param name="className"/>
		
		<xsl:choose>
			<xsl:when test="$className = 'Business_Capability'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">busCap</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderBusCap</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Business_Process'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">busProc</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderBusProc</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Group_Actor'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">org</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderOrg</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Site'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">site</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderSite</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Application_Capability'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">appCap</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderAppCap</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Application_Service'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">appSvc</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderAppSvc</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = ('Application_Provider', 'Composite_Application_Provider')">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">appProv</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderAppProv</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Capability'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">techCap</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderTechCap</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Component'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">techComp</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderTechComp</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$className = 'Technology_Product'">
				<xsl:call-template name="GenericIdeaModalListener">
					<xsl:with-param name="prefix">techProd</xsl:with-param>
					<xsl:with-param name="functionPrefix">renderTechProd</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>	
	</xsl:template>
	
	
	<xsl:template name="RenderShowModalJSFunction">
		<xsl:param name="aModal"/>
		
		<xsl:variable name="modalId" select="$aModal/own_slot_value[slot_reference = 'modal_report_js_name']/value"/>
		<xsl:variable name="modalAPI" select="$essAllModalDataSetAPIs[name = $aModal/own_slot_value[slot_reference = 'modal_report_content_apis']/value]"/>
		<xsl:variable name="modalAPILabel" select="$modalAPI/own_slot_value[slot_reference = 'dsa_data_label']/value"/>
		
		function <xsl:value-of select="$modalId"/><xsl:value-of select="$essModalFunctionSuffix"/>(key,opt) {
			if(essIdeas.ready) {
				var subjectId = getViewerAPISubjectId(opt.$trigger.attr("href"));
				//call the API to retrieve the data
				promise_getViewerAPIData('<xsl:value-of select="$modalAPILabel"/>', subjectId)
				.then(function (response) {
					//...then, show the modal
					essViewer.viewerAPIData['<xsl:value-of select="$modalId"/>'] = response;
					essNextModalElement = essViewer.viewerAPIData['<xsl:value-of select="$modalId"/>']['focusInstance'];
					
					if(essNextModalElement != null) {
						essElementUnderReview = essNextModalElement;
						$('#<xsl:value-of select="$modalId"/>').modal('show');
					}
				})
				.catch (function (error) {
					console.log('Error loading modal data: ' + error.message);
				});		
			} else {
				console.log('Ideas Loading. Please wait...');
			}
		}
	</xsl:template>
	
	
	<xsl:template name="RenderGenericIdeaModalFuncs">
		<xsl:param name="functionPrefix"/>
		<xsl:param name="prefix"/>
		
		// function to render the content of the idea action modal dialog -->
		function <xsl:value-of select="$functionPrefix"/>IdeaModalContent(anInstance) {
		
			//FRAMEWORK VARIABLES
			essElementUnderReview = anInstance;
			essCurrentModal = $('#<xsl:value-of select="$prefix"/>IdeaModal');
			
			
			//set up the list of planning actions of the modal
			var planningActionList = [];
			var anAction, actionOption, isSelected;
			var currentAction = essElementUnderReview.planningAction;
			if(currentAction != null) {
				essInitModalActionId = currentAction.id;
			}
			actionOption = {
				id: "NO_CHANGE",
				name: "No Change"
			};
			planningActionList.push(actionOption);
			var relevantPAs = essIdeas.planningActions;
			relevantPAs.forEach(function(aPA) {
				actionOption = {
					id: aPA.id,
					name: aPA.name
				};
				planningActionList.push(actionOption);
			});
			
			
			//render the modal content
			//set up the object to be pasesed to handlebars
			var instanceContentJSON = {
				focusInstance: anInstance,
				planningActions: planningActionList,
				modalHistory: essModalHistory
			}
			$("#<xsl:value-of select="$prefix"/>IdeaModalContent").html(<xsl:value-of select="$prefix"/>IdeaModalTemplate(instanceContentJSON));
		
			<!--Show Hide the Create Idea Panel in the Modal-->
			$('#modal-create-new-idea').click(function(){
				$('#create-idea-form').slideDown();
			});
			$('#cancel-idea-btn').click(function(){
	      		$('#create-idea-form').slideUp();
	      		essResetCreateNeedModalForm();
	      	});
	      	<!--Show Hide the Create Option Panel in the Modal-->
			$('#modal-create-new-option').click(function(){
				$('#create-option-only-form').slideDown();
			});
			$('#cancel-option-only-btn').click(function(){
	      		$('#create-option-only-form').slideUp();
	      		essResetCreateIdeaOnlyModalForm();
	      	});
			
			
			//Add the ideas modal event listeners
			essAddIdeasModalListeners();
		
		}
	</xsl:template>
	
	<xsl:template name="GenericIdeaModalListener">
		<xsl:param name="functionPrefix"/>
		<xsl:param name="prefix"/>

		//initialise event listener for business capability idea action modal being displayed-->
		$('#<xsl:value-of select="$prefix"/>IdeaModal').on('show.bs.modal', function (event) {
		if(essNextModalElement != null) {
			<xsl:value-of select="$functionPrefix"/>IdeaModalContent(essNextModalElement);
			essNextModalElement = null;
		}
		});
		
		//initialise event listener for business capability idea action modal being hidden-->
		$('#<xsl:value-of select="$prefix"/>IdeaModal').on('hidden.bs.modal', function (event) {
				<!--essShowNextModal(essElementUnderReview);-->
				
		});
		
	</xsl:template>
	
	
	<xsl:template name="RenderGenericIdeaModal">
		<xsl:param name="templatePrefix"/>
		<xsl:param name="prefix"/>
		<xsl:param name="subjectType"/>
		
		
		<!-- Handlebars template for the contents of the Business Process Modal -->
		<script type="text/x-handlebars-template">
			<xsl:attribute name="id"><xsl:value-of select="$templatePrefix"/>-idea-modal-template</xsl:attribute>
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
				<p class="modal-title xlarge"><xsl:attribute name="id"><xsl:value-of select="$prefix"/>ModalLabel</xsl:attribute><strong><span class="text-darkgrey"><xsl:value-of select="$subjectType"/>: </span><span class="text-primary">{{{focusInstance.link}}}</span></strong></p>
				<p>{{focusInstance.description}}</p>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-6">
						<p class="impact large text-primary"><i class="fa fa-lightbulb-o right-5"/>Idea:</p>
						<select class="select2 ideaReqList" style="width: 100%;">
							<xsl:attribute name="id"><xsl:value-of select="$prefix"/>IdeaReqList</xsl:attribute>
							{{#each ideaReqs}}
								<option>
									<xsl:attribute name="value">{{id}}</xsl:attribute>
									{{name}}
								</option>
							{{/each}}
						</select>
						<button class="btn btn-sm btn-block btn-default top-10" id="modal-create-new-idea"><i class="fa fa-plus right-5"/>Create New Idea</button>
					</div>
					<div class="col-md-6">
						<p class="impact large text-primary"><i class="fa fa-check-circle right-5"/>Option:</p>
						<select class="select2 ideaList" style="width: 100%;">
							<xsl:attribute name="id"><xsl:value-of select="$prefix"/>IdeaList</xsl:attribute>
							<option/>
						</select>
						<button class="btn btn-sm btn-block btn-default top-10" id="modal-create-new-option"><i class="fa fa-plus right-5"/>Create New Option</button>
					</div>
					<div class="col-xs-6">
						<div id="create-idea-form" class="small top-10 bottom-10 new-simple-object-form hiddenDiv">
							<label>Idea Name:</label>
							<input id="create-idea-name" class="form-control" type="text" placeholder="Add Idea..."/>
							<label class="top-5">Option Name:</label>
							<input id="create-option-name" class="form-control" type="text" placeholder="Add Option..."/>
							<label class="top-5">Description:</label>
							<textarea id="create-idea-desc" class="form-control" rows="2" placeholder="Add Description..."/>
							<span id="create-idea-error" class="textColourRed"/>
							<div class="top-10 pull-right">
								<button id="cancel-idea-btn" class="btn btn-sm btn-danger cancel-new-object right-10">Cancel</button>								
								<button id="create-idea-btn" class="btn btn-sm btn-success update-new-object">Create</button>
							</div>
							<div class="clearfix"/>
						</div>
						
					</div>
					<div class="col-xs-6">
						<div id="create-option-only-form" class="small top-10 bottom-10 new-simple-object-form hiddenDiv">
							<label>Option Name:</label>
							<input id="create-option-only-name" class="form-control" type="text" placeholder="Add Name..."/>
							<label class="top-5">Description:</label>
							<textarea id="create-option-only-desc" class="form-control" rows="2" placeholder="Add Description..."/>
							<span id="create-option-only-error" class="textColourRed"/>
							<div class="top-10 pull-right">
								<button id="cancel-option-only-btn" class="btn btn-sm btn-danger cancel-new-object right-10">Cancel</button>
								<button id="create-option-only-btn" class="btn btn-sm btn-success update-new-object">Create</button>
							</div>
							<div class="clearfix"/>
						</div>
					</div>
					<div class="col-xs-12"><hr/></div>
					<div class="col-md-6">
						<p class="impact large text-darkgreen"><i class="fa fa-lightbulb-o right-5"/>Proposed Change:</p>
						<select class="select2 planningActionlist" style="width: 100%;">
							<xsl:attribute name="id"><xsl:value-of select="$prefix"/>ModalPlanningActionList</xsl:attribute>
							{{#each planningActions}}
								<option>
									<xsl:attribute name="value">{{id}}</xsl:attribute>
									{{name}}
								</option>
							{{/each}}
						</select>
					</div>
					<div class="col-md-6">
						<p class="impact large text-darkgreen"><i class="fa fa-edit right-5"/>Rationale:</p>
						<textarea id="essIdeaModalRationale" class="essIdeaPlanRationale form-control" placeholder="Enter notes to explain rationale for the planning action">{{focusInstance.planningNotes}}</textarea>
					</div>	
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="essModalCancelButton btn btn-danger">Cancel</button>
				<button type="button" class="essModalConfirmButton btn btn-success" data-dismiss="modal">Update</button>
			</div>
		</script>
		
		<!-- Generic Modal -->
		<div class="modal fade" tabindex="-1" role="dialog">
			<xsl:attribute name="id"><xsl:value-of select="$prefix"/>IdeaModal</xsl:attribute>
			<xsl:attribute name="aria-labelledby"><xsl:value-of select="$prefix"/>IdeaModalLabel</xsl:attribute>
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<xsl:attribute name="id"><xsl:value-of select="$prefix"/>IdeaModalContent</xsl:attribute>
				</div>
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
