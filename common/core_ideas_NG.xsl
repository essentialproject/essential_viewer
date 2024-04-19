<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="core_modal_reports_NG.xsl"/>
	<xsl:import href="../common/core_utilities_NG.xsl"/>
	<xsl:import href="../common/datatables_includes.xsl"/>

	<xsl:variable name="busNeedDashboard" select="eas:get_report_by_name('Core: Idea Dashboard')"></xsl:variable>
	<xsl:variable name="busNeedDashboardPath">
		<xsl:call-template name="RenderLinkText">
			<xsl:with-param name="theXSL" select="$busNeedDashboard/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="busNeedEditor" select="$utilitiesAllEditors[own_slot_value[slot_reference = 'name']/value = 'Core: Idea Editor']"/>
	<xsl:variable name="busNeedEditorPath">
		<xsl:call-template name="RenderEditorLinkText">
			<xsl:with-param name="theEditor" select="$busNeedEditor"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:template name="ideas">
		
		<script>
			function closeIdeas() {
				$('#ideasPanel').css('margin-right','-340px');
				$('#ideasPanel').removeClass('active');
			}
			function toggleIdeas(){
				if ($('#ideasPanel').hasClass('active')){
					$('#ideasPanel').css('margin-right','-340px');
					$('#ideasPanel').removeClass('active');
				}
				else {
					closeComments();
					$('#ideasPanel').css('margin-right','0');
					$('#ideasPanel').addClass('active');
				}
			}
			/*Auto resize panel during scroll*/
			$(window).scroll(function() {
				if ($(this).scrollTop() &gt; 40) {
					$('#ideasPanel').css('position','fixed');
					$('#ideasPanel').css('height','calc(100%)');
					$('#ideasPanel').css('top','0');
					$('.ideaElementsList').css('height','calc(100vh - 470px)');
				}
				if ($(this).scrollTop() &lt; 40) {
					$('#ideasPanel').css('position','fixed');
					$('#ideasPanel').css('height','calc(100% - 40px)');
					$('#ideasPanel').css('top','41px');
					$('.ideaElementsList').css('height','calc(100vh - 510px)');
				}
			});
		</script>
		
		
		
		<!--<script type="text/javscript" src="js/lodash.js"/>-->
		
		<script>
			var essIdeas = {
				'ready': false
			};
			essIdeas.PROPOSE_STATUS = 'SYS_CONTENT_PROPOSED';
			const essNeedCreateMode = 'Need';
			const essIdeaCreateMode = 'Idea';
			var essIdeasPanelChangesTemplate, essIdeasInfoTemplate, essIdeationInstanceListTemplate, essIdeationEnumListTemplate, essIdeationTextBulletsTemplate, essIdeationInstanceBulletsTemplate, essIdeationSQChangeBulletsTemplate, essIdeationCostChangeBulletsTemplate, essIdeationRevChangeBulletsTemplate;
			var busNeedDashUri = '<xsl:value-of select="$busNeedDashboardPath"/>';
			var busNeedEditorUri = '<xsl:value-of select="$busNeedEditorPath"/>';
			const essIdeasDefaultSubmitByDate = moment().add(1, 'months').format('YYYY-MM-DD');
			const essIdeasTodaysString = moment().format('YYYY-MM-DD');
	
			class essNeed {
			    constructor(name, description) {
			        this.name = name;
			        this.description = description;
			        this.submitIdeasByDate = essIdeasDefaultSubmitByDate;
			        this.meta = {};
			        this.meta.createdOn = moment().toISOString();
			        this.meta.createdBy = {};
			        this.meta.createdBy.id = essViewer.user.id;
			    }
			}
			
			
			class essIdea {
			    constructor(name, description) {
			        this.name = name;
			        this.description = description;
			        this.meta = {};
			        this.meta.createdOn = moment().toISOString();
			        this.meta.createdBy = {};
			        this.meta.createdBy.id = essViewer.user.id;
			    }
			}
			
			class essIdeaChange {
			    constructor(element, changeAction, rationale) {
			    	this.element = {id: element.id};
			        this.rationale = rationale;
			        this.change = {id: changeAction.id};
			        this.meta = {};
			        this.meta.createdOn = moment().toISOString();
			        this.meta.createdBy = {};
			        this.meta.createdBy.id = essViewer.user.id;
			    }
			}	
			
			function essSetCurrentNeed(aNeed) {
				if(aNeed != null) {
					essIdeas.currentNeed = aNeed;
					localStorage.setItem("essCurrentNeedId", aNeed.id);
				} else {
					essIdeas.currentNeed = null;
					localStorage.removeItem("essCurrentNeedId");
				}		
			}
			
			
			function essSetCurrentIdea(anIdea) {
				if(anIdea != null) {
					essIdeas.currentIdea = anIdea;
					localStorage.setItem("essCurrentIdeaId", anIdea.id);
				} else {
					essIdeas.currentIdea = null;
					localStorage.removeItem("essCurrentIdeaId");
				}
			}
			
			function essInitCurrentNeed() {
				if(essIdeas.currentNeed == null) {
					let needId = localStorage.getItem("essCurrentNeedId");
					if(essIdeas.needs != null) {
						if(needId != null) {
							essIdeas.currentNeed = essIdeas.needs.find(function(aNeed) {
								return aNeed.id == needId;
							});
						}
						
						if((essIdeas.currentNeed == null) &amp;&amp; (essIdeas.needs.length > 0)) {
							essSetCurrentNeed(essIdeas.needs[0]);
						}
					}
				}			
			}
			
			
			function essInitCurrentIdea() {
				if(essIdeas.currentIdea == null) {
					let ideaId = localStorage.getItem("essCurrentIdeaId");
					if((essIdeas.currentNeed != null) &amp;&amp; (essIdeas.currentNeed.ideas != null)) {
						if(ideaId != null) {
							essIdeas.currentIdea = essIdeas.currentNeed.ideas.find(function(anIdea) {
								return anIdea.id == ideaId;
							});
						}
						
						if((essIdeas.currentIdea == null) &amp;&amp; (essIdeas.currentNeed.ideas.length > 0)) {
							essSetCurrentIdea(essIdeas.currentNeed.ideas[0]);
						}
					}
				}			
			}
			
			
			//function to set the details for a new need
			function addNewNeedDetails(newNeed) {
				if(newNeed != null) {
					essIdeas.needs.push(newNeed);
					essSetCurrentNeed(newNeed);
					//essIdeas.currentNeed = newNeed;
					
					let currentNeedDashURL = busNeedDashUri + '&amp;PMA=' + essIdeas.currentNeed.id;
					$('#ess-need-view-link').attr('href', currentNeedDashURL);
					
					let needAuthor = newNeed.meta.createdBy;
					if (needAuthor != null) {
						if (essViewer.user.id == needAuthor.id) {
							// $('#ess-need-edit-link').attr('class', 'top-5 small pull-right');
							$('#ess-need-edit-link').attr('class', '');
							$('#ess-need-delete-link').attr('class', '');
							let currentNeedEditorURL = busNeedEditorUri + '&amp;PMA=' + essIdeas.currentNeed.id;
							$('#ess-need-edit-link').attr('href', currentNeedEditorURL);
						} else {
							$('#ess-need-edit-link').attr('class', 'hiddenDiv');
							$('#ess-need-delete-link').attr('class', 'hiddenDiv');
							//$('#ess-need-edit-link').addClass('hiddenDiv');
						}
					} else {
						$('#ess-need-edit-link').attr('class', 'hiddenDiv');
						$('#ess-need-delete-link').attr('class', 'hiddenDiv');
						//$('#ess-need-edit-link').addClass('hiddenDiv');
					}
					
					essClearIdeaDetails();
					
					$('#ess-panel-need-list').html(essIdeationInstanceListTemplate(essIdeas.needs)).promise().done(function(){
						$('#ess-panel-need-list').val(essIdeas.currentNeed.id).trigger('change');
					});		
					
				}
			}
			
			//functikon to set the details for a new idea
			function addNewIdeaDetails(newIdea) {
				if((essIdeas.currentNeed != null) &amp;&amp; (newIdea != null)) {
					if(essIdeas.currentNeed.ideas == null) {
						essIdeas.currentNeed.ideas = [];
					}
					
					essIdeas.currentNeed.ideas.push(newIdea);
					essSetCurrentIdea(newIdea);
					//essIdeas.currentIdea = newIdea;
					essSetIdeaDetails();								
				}		
			}
			
			//load the latest needs
			function refreshNeedsData() {
				Promise.all([
					essPromise_getAPIElements(essEssentialCoreApiUri, 'planning-actions', 'Planning Action'),
					<!--essPromise_getAPIElements(essEssentialCoreApiUri, 'content-visibilities', 'Content Visibility'),-->
					essPromise_getAPIElements(essEssentialCoreApiUri, 'idea-lifecycle-statii', 'Idea Lifecycle Status'),
			        essPromise_getAPIElements(essEssentialCoreApiUri, 'business-needs', 'Business Need')
				])
				.then(function (responses) {
					essIdeas.planningActions = responses[0]["planning-actions"];
					
					<!--essIdeas.visibilities = responses[1]["content-visibilities"];
					$('#ess-panel-idea-vis-list').html(essIdeationEnumListTemplate(essIdeas.visibilities));-->
					
					//load the list of supported idea Statii
					essIdeas.ideaStatii = responses[1]["idea-lifecycle-statii"];
					essIdeas.proposalStatus = essIdeas.ideaStatii.find(function(aSt) {
						return aSt.name == 'Proposed Idea';
					});
					let filteredIdeaStatii = essIdeas.ideaStatii.filter(function(aSt) {
						return aSt.index &lt;= essIdeas.proposalStatus.index;
					});
					$('#ess-panel-idea-status-list').html(essIdeationEnumListTemplate(filteredIdeaStatii));
					
					let filteredNeeds = responses[2]['business-needs'].filter(function(aNeed) {
						return ((aNeed.submitIdeasByDate == null) || (aNeed.submitIdeasByDate >= essIdeasTodaysString));
					});
					essIdeas['allNeeds'] = responses[2]['business-needs'].filter(function(aNeed) {
						return (aNeed.meta.contentStatus != null) &amp;&amp; (aNeed.meta.contentStatus.name != ess_APPROVAL_STATII.draft);
					});				
					essIdeas.needs = filteredNeeds;
					$('#ideas-badge').text(essIdeas.needs.length);
					essIdeas.ready = true;
					
					//set the current requirement and idea
					if((essIdeas.needs != null) &amp;&amp; (essIdeas.needs.length > 0)) {
						essInitCurrentNeed();
						
						if(essIdeas.currentNeed != null) {
							let currentNeedDashURL = busNeedDashUri + '&amp;PMA=' + essIdeas.currentNeed.id;
							$('#ess-need-view-link').attr('href', currentNeedDashURL);
							
							//populate the idea info popup
							if((essIdeas.currentNeed.meta.createdOn != null) &amp;&amp; (essIdeas.currentNeed.meta.createdOnDisplay == null)) {
								essIdeas.currentNeed.meta.createdOnDisplay = moment(essIdeas.currentNeed.meta.createdOn).format('DD MMM YYYY, hh:mm');
							}
							if((essIdeas.currentNeed.meta.lastModifiedOn != null) &amp;&amp; (essIdeas.currentNeed.meta.lastModifiedOnDisplay == null)) {
								essIdeas.currentNeed.meta.lastModifiedOnDisplay = moment(essIdeas.currentNeed.meta.lastModifiedOn).format('DD MMM YYYY, hh:mm');
							}
							$('#ess-idea-info').html(essIdeasInfoTemplate(essIdeas.currentNeed));
							
							let needAuthor = essIdeas.currentNeed.meta.createdBy;
							if (needAuthor != null) {
								if (essViewer.user.id == needAuthor.id) {
									$('#ess-need-edit-menu').attr('class', '');
									$('#ess-need-delete-menu').attr('class', '');
									let currentNeedEditorURL = busNeedEditorUri + '&amp;PMA=' + essIdeas.currentNeed.id;
									$('#ess-need-edit-link').attr('href', currentNeedEditorURL);
								} else {
									$('#ess-need-edit-menu').attr('class', 'hiddenDiv');
									$('#ess-need-delete-menu').attr('class', 'hiddenDiv');
									//$('#ess-need-edit-link').addClass('hiddenDiv');
								}
							} else {
								$('#ess-need-edit-menu').attr('class', 'hiddenDiv');
								$('#ess-need-delete-menu').attr('class', 'hiddenDiv');
								//$('#ess-need-edit-link').addClass('hiddenDiv');
							}
							<!--let currentNeedEditorURL = busNeedEditorUri + '&amp;PMA=' + essIdeas.currentNeed.id;
							$('#ess-need-edit-link').attr('href', currentNeedEditorURL);-->
							
							$('#ess-panel-need-list').html(essIdeationInstanceListTemplate(essIdeas.needs)).promise().done(function(){
								$('#ess-panel-need-list').val(essIdeas.currentNeed.id);
							});
							
							refreshIdeasData();	
							
						}
						
						
						
					}
					
			    }). catch (function (error) {
			        console.log('Needs Data Loading Error: ' + error.message);
			    });				
			}
			
			function essUpdateIdeaDesc(aDesc) {
				if(essIdeas.currentIdea != null) {
					let priorIdea = {};
					Object.assign(priorIdea, essIdeas.currentIdea);
					essIdeas.currentIdea.description = aDesc;
					essUpdateIdea(priorIdea, essIdeas.currentIdea, ['description']);
				}			
			}
			
			function essUpdateIdeaVis(aVis) {
				if(essIdeas.currentIdea != null) {
					let priorIdea = {};
					Object.assign(priorIdea, essIdeas.currentIdea);
					essIdeas.currentIdea.meta.visibility = aVis;
					essUpdateIdea(priorIdea, essIdeas.currentIdea, ['meta']);
				}			
			}			
			
			
			function essAddChangeToIdea(element, change, rationale) {
				if(essIdeas.currentIdea != null) {
					let newIdeaChange = new essIdeaChange(element, change, rationale);
					
					//let priorIdea = _.cloneDeep(essIdeas.currentIdea);
					let priorIdea = {};
					Object.assign(priorIdea, essIdeas.currentIdea);
					essIdeas.currentIdea.changes.push(newIdeaChange);
					essUpdateIdea(priorIdea, essIdeas.currentIdea, ['changes']);
				}			
			}
			
			
			function essProposeIdea() {
				if(essIdeas.currentIdea != null) {				
					//let priorIdea = _.cloneDeep(essIdeas.currentIdea);
					let priorIdea = {};
					Object.assign(priorIdea, essIdeas.currentIdea);
					essIdeas.currentIdea.status = essIdeas.proposalStatus;			
					essUpdateIdea(priorIdea, essIdeas.currentIdea, ['status']);
				}			
			}
			
			
			//load the latest ideas
			function refreshIdeasData() {
				if(essIdeas.currentNeed != null) {
					let ideasURL = 'business-needs/' + essIdeas.currentNeed.id + '/ideas';
				    essPromise_getAPIElements(essEssentialCoreApiUri, ideasURL, 'Idea')
					.then(function (response) {
						<!--let visibleIdeas = response['ideas'].filter(function(anIdea) {
							return (anIdea.meta.visibility == null) || (anIdea.meta.createdBy == null) || (anIdea.meta.visibility.name == 'SYS PUBLIC CONTENT') || ((anIdea.meta.visibility.name == 'SYS PRIVATE CONTENT') &amp;&amp; (anIdea.meta.createdBy.id == essViewer.user.id));
						});-->
						let visibleIdeas = response['ideas'].filter(function(anIdea) {
							return (anIdea.meta.createdBy == null) || ((anIdea.meta.createdBy != null) &amp;&amp; (anIdea.meta.createdBy.id == essViewer.user.id));
						});
						essIdeas.currentNeed['ideas'] = visibleIdeas;
						
						if((essIdeas.currentNeed.ideas != null) &amp;&amp; (essIdeas.currentNeed.ideas.length > 0)) {
							essInitCurrentIdea();
							//essIdeas.currentIdea = essIdeas.currentNeed.ideas[0];		
							essSetIdeaDetails();
						} else {
							essSetCurrentIdea(null);
							essClearIdeaDetails();
						}							
				    }). catch (function (error) {
				        console.log('Ideas Data Loading Error: ' + error.message);
				    });	
				}
			}
			
			
			function essClearIdeaDetails() {
				//tunn off event listeners
				$('#ess-idea-desc').off();
				
				//empty the lists
				$('#ess-panel-idea-list').html('');
				//$('#ess-panel-idea-vis-list').html('');
				
				$('#option-info-content').addClass('hiddenDiv');
				$('#ess-idea-option-info').html('');
				$('#ess-idea-desc').val('');
				$('#ess-panel-idea-status').html('');
				$('#ess-panel-idea-propose-btn').addClass('disabled');	
				$('#ess-panel-idea-plans').html('');
				
				$('#ess-idea-side-container').attr('class', 'hiddenDiv');
			}
			
			function essSetIdeaDetails() {
				if(essIdeas.currentIdea != null) {
					$('#ess-idea-side-container').attr('class', '');
					
					let optionAuthor = essIdeas.currentIdea.meta.createdBy;
					if (optionAuthor != null) {
						if (essViewer.user.id == optionAuthor.id) {
							$('#ess-idea-option-menu').attr('class', 'dropdown pull-right');
							<!--$('#ess-option-visi-section').attr('class', '');-->
							$("#ess-panel-idea-status-list").prop("disabled", false);
							$('#ess-idea-desc').removeAttr("disabled");
						} else {
							$('#ess-idea-option-menu').attr('class', 'dropdown pull-right hiddenDiv');
							<!--$('#ess-option-visi-section').attr('class', 'hiddenDiv');-->
							$("#ess-panel-idea-status-list").prop("disabled", true);
							$('#ess-idea-desc').attr("disabled", "disabled");
						}
					} else {
						$('#ess-idea-option-menu').attr('class', 'dropdown pull-right hiddenDiv');
						<!--$('#ess-option-visi-section').attr('class', 'hiddenDiv');-->
						$("#ess-panel-idea-status-list").prop("disabled", true);
						$('#ess-idea-desc').attr("disabled", "disabled");
					}
					
				
					$('#ess-panel-idea-list').html(essIdeationInstanceListTemplate(essIdeas.currentNeed.ideas)).promise().done(function(){
						$('#ess-panel-idea-list').val(essIdeas.currentIdea.id).trigger('change');
					});			
					
					
					//populate the idea info popup
					if((essIdeas.currentIdea.meta.createdOn != null) &amp;&amp; (essIdeas.currentIdea.meta.createdOnDisplay == null)) {
						essIdeas.currentIdea.meta.createdOnDisplay = moment(essIdeas.currentIdea.meta.createdOn).format('DD MMM YYYY, hh:mm');
					}
					if((essIdeas.currentIdea.meta.lastModifiedOn != null) &amp;&amp; (essIdeas.currentIdea.meta.lastModifiedOnDisplay == null)) {
						essIdeas.currentIdea.meta.lastModifiedOnDisplay = moment(essIdeas.currentIdea.meta.lastModifiedOn).format('DD MMM YYYY, hh:mm');
					}
					$('#option-info-content').removeClass('hiddenDiv');
					$('#ess-idea-option-info').html(essIdeasInfoTemplate(essIdeas.currentIdea));
					
					
					$('#ess-idea-desc').off();
					$('#ess-idea-desc').val(essIdeas.currentIdea.description);
					
					$('#ess-idea-desc').on('change', function () {
				        let newDesc = $(this).val();
				        essUpdateIdeaDesc(newDesc);
				    });
					
					<!--if(essIdeas.currentIdea.status != null) {
						$('#ess-panel-idea-status').html(essIdeas.currentIdea.status.label);
						
						//enable or diable the button
						if((essIdeas.currentIdea.status != null) &amp;&amp; (essIdeas.currentIdea.status.id == essIdeas.proposalStatus.id)) {
							$('#ess-panel-idea-propose-btn').addClass('disabled');
						} else {
							$('#ess-panel-idea-propose-btn').removeClass('disabled');					
						}
					}-->
					
					var currentIdeaPlansData = {
						"changes": essIdeas.currentIdea.changes,
						"planningActions":  essIdeas.planningActions
					}
					
					
					// Unbind the drop down event listeners
					<!--$('#ess-panel-idea-vis-list').off('select2:select');
					$('#ess-panel-idea-status-list').off('select2:select');
					
					if(essIdeas.currentIdea.meta.visibility != null) {
						$('#ess-panel-idea-vis-list').val(essIdeas.currentIdea.meta.visibility.id).trigger('change');	
					}
		            
		            //Add listener for idea visibility drop-dowm list
		            $('#ess-panel-idea-vis-list').on('select2:select', function (e) {
		            	let visId = e.params.data.id;
						if(visId != null) {
							//update up the ideas list
					    	let selectedVis = essIdeas.visibilities.find(function(aVis) {
					    		return aVis.id == visId;
					    	});
							if(selectedVis != null) {
								essUpdateIdeaVis(selectedVis);						
							}
						}				
		            });-->
		            
		            if((essIdeas.currentIdea != null) &amp;&amp; (essIdeas.currentIdea.status != null)) {
						$('#ess-panel-idea-status-list').val(essIdeas.currentIdea.status.id).trigger('change');
					}
					
					$('#ess-panel-idea-status-list').on('select2:select', function (e) {
						let statusId = e.params.data.id;
						if((essIdeas.currentIdea != null) &amp;&amp; (statusId != null)) {
							let newStatus = essIdeas.ideaStatii.find(function(aSt) {
								return aSt.id == statusId;
							});
							if(newStatus != null) {
								let priorIdea = {};
								Object.assign(priorIdea, essIdeas.currentIdea);
								essIdeas.currentIdea.status = newStatus;
								essUpdateIdea(priorIdea, essIdeas.currentIdea, ['status']);
								
								//if being proposed, record when the idea was submitted as a proposal
								if(newStatus.name = essIdeas.PROPOSE_STATUS) {
									let decisionComment = new essApprovalDecisionComment(essIdeas.currentIdea, ess_PROPOSE, ('<xsl:value-of select="eas:i18n('Submitted as proposal by')"/> ' + essViewer.user.firstName + ' ' + essViewer.user.lastName), essIdeas.currentNeed);
									essPromise_createNoSQLElement(essEssentialReferenceApiUri, decisionComment, 'approval-decision-comments', 'Approval Decision Comment');
								}
							}							
						}
					});
					
					
					$('#ess-panel-idea-plans').html(essIdeasPanelChangesTemplate(currentIdeaPlansData)).promise().done(function(){
						// Remove event handlers to prevent JS being init multiple times
						//$('.ideaElement, .ideaSelect').off();
						
						// Toggle for Idea Element Detail slide down
						$('.ideaElementNameTypeWrapper').click(function(){
							$(this).parent().next('.ideaElementDetail').slideToggle();
						});
						
						essIdeas.currentIdea.changes.forEach(function(aChange) {
							if(aChange.change != null) {
								let changeSelect = $('select[eas-id="' + aChange.id + '"]');
								changeSelect.select2({theme: "bootstrap"});
								let changeActionId = aChange.change.id;
								changeSelect.val(changeActionId).trigger('change');
								
								
								changeSelect.on('select2:select', function (e) {
									let changeActionId = e.params.data.id;
									let changeId = $(this).attr('eas-id');
									let newAction = essIdeas.planningActions.find(function(act) {
										return act.id == changeActionId;
									});
									if(newAction != null) {
										let thisChange = essIdeas.currentIdea.changes.find(function(aCh) {
											return aCh.id == changeId;
										});
										if(thisChange != null) {
											let priorIdea = {};
											Object.assign(priorIdea, essIdeas.currentIdea);
											thisChange.change = newAction;
											essUpdateIdea(priorIdea, essIdeas.currentIdea, ['changes']);
										}
									}
								});
								
								
								$('.ess-idea-chg-rationale[eas-id="' + aChange.id + '"]').on('change', function (e) {
									let changeId = $(this).attr('eas-id');
									let newRat = $(this).val();
									let thisChange = essIdeas.currentIdea.changes.find(function(aCh) {
										return aCh.id == changeId;
									});
									if((thisChange != null) &amp;&amp; (thisChange.rationale != newRat)) {
										let priorIdea = {};
										Object.assign(priorIdea, essIdeas.currentIdea);
										thisChange.rationale = newRat;		
										essUpdateIdea(priorIdea, essIdeas.currentIdea, ['changes']);
									}
								})
								
								
								$('.ess-ideas-remove-change-btn[eas-id="' + aChange.id + '"]').on('click', function (e) {
									console.log('Clicked on delete button for: ' + $(this).attr('eas-id'));
									console.log(essIdeas.currentIdea.changes);
									let changeId = $(this).attr('eas-id');
									if(changeId != null) {
										let thisChange = essIdeas.currentIdea.changes.find(function(aCh) {
											return aCh.id == changeId;
										});
										if(thisChange != null) {
											let changeIdx = essIdeas.currentIdea.changes.indexOf(thisChange);
											let priorIdea = {};
											Object.assign(priorIdea, essIdeas.currentIdea);
											essIdeas.currentIdea.changes.splice(changeIdx, 1);			
											essUpdateIdea(priorIdea, essIdeas.currentIdea, ['changes']);
										}
									}
								});
							}
						});
						
					
						//$('#ess-idea-plan-action-list').val(essIdeas.currentIdea.id);
					});
				} else {
					essClearIdeaDetails();
				}
			}
			
			//initialisation when the page loads
			$(document).ready(function(){
				//compile the ideas panel handlebars template
				let ideaChangesFragment = $("#ess-ideas-panel-changes-template").html();
    			essIdeasPanelChangesTemplate = Handlebars.compile(ideaChangesFragment);
    			
    			let ideaInfoFragment = $("#ess-idea-info-template").html();
    			essIdeasInfoTemplate = Handlebars.compile(ideaInfoFragment);
    			
    			let essIdeationInstanceListFragment = $("#ess-ideation-instance-list-template").html();
    			essIdeationInstanceListTemplate = Handlebars.compile(essIdeationInstanceListFragment);
    			
    			let essIdeationEnumListFragment = $("#ess-ideation-enum-list-template").html();
    			essIdeationEnumListTemplate = Handlebars.compile(essIdeationEnumListFragment);
    			
    			let essIdeationTextBulletsFragment = $("#ess-ideation-text-bullets-template").html();
    			essIdeationTextBulletsTemplate = Handlebars.compile(essIdeationTextBulletsFragment);
    			
    			let essIdeationInstanceBulletsFragment = $("#ess-ideation-instance-bullets-template").html();
    			essIdeationInstanceBulletsTemplate = Handlebars.compile(essIdeationInstanceBulletsFragment);
    			
    			let essIdeationSQChangeBulletsFragment = $("#ess-ideation-sq-change-bullets-template").html();
    			essIdeationSQChangeBulletsTemplate = Handlebars.compile(essIdeationSQChangeBulletsFragment);
    			
    			let essIdeationCostChangeBulletsFragment = $("#ess-ideation-cost-change-bullets-template").html();
    			essIdeationCostChangeBulletsTemplate = Handlebars.compile(essIdeationCostChangeBulletsFragment);
    			
    			let essIdeationRevChangeBulletsFragment = $("#ess-ideation-rev-change-bullets-template").html();
    			essIdeationRevChangeBulletsTemplate = Handlebars.compile(essIdeationRevChangeBulletsFragment);
    			
			
				//get the list of requirements for the user
				refreshNeedsData();
			
			});
			
			
			function setCurrentNeedDetails(selectedReq) {
				essSetCurrentNeed(selectedReq);
				
				if(selectedReq != null) {
					//populate the idea info popup
					if((essIdeas.currentNeed.meta.createdOn != null) &amp;&amp; (essIdeas.currentNeed.meta.createdOnDisplay == null)) {
						essIdeas.currentNeed.meta.createdOnDisplay = moment(essIdeas.currentNeed.meta.createdOn).format('DD MMM YYYY, hh:mm');
					}
					if((essIdeas.currentNeed.meta.lastModifiedOn != null) &amp;&amp; (essIdeas.currentNeed.meta.lastModifiedOnDisplay == null)) {
						essIdeas.currentNeed.meta.lastModifiedOnDisplay = moment(essIdeas.currentNeed.meta.lastModifiedOn).format('DD MMM YYYY, hh:mm');
					}
					$('#ess-idea-info').html(essIdeasInfoTemplate(essIdeas.currentNeed));
					
					let currentNeedDashURL = busNeedDashUri + '&amp;PMA=' + essIdeas.currentNeed.id;
					$('#ess-need-view-link').attr('href', currentNeedDashURL);
					
					let needAuthor = essIdeas.currentNeed.meta.createdBy;
					if (needAuthor != null) {
						if (essViewer.user.id == needAuthor.id) {
							$('#ess-need-edit-menu').attr('class', '');
							$('#ess-need-delete-menu').attr('class', '');
							let currentNeedEditorURL = busNeedEditorUri + '&amp;PMA=' + essIdeas.currentNeed.id;
							$('#ess-need-edit-link').attr('href', currentNeedEditorURL);
						} else {
							$('#ess-need-edit-menu').attr('class', 'hiddenDiv');
							$('#ess-need-delete-menu').attr('class', 'hiddenDiv');
							//$('#ess-need-edit-link').addClass('hiddenDiv');
						}
					} else {
						$('#ess-need-edit-menu').attr('class', 'hiddenDiv');
						$('#ess-need-delete-menu').attr('class', 'hiddenDiv');
						//$('#ess-need-edit-link').addClass('hiddenDiv');
					}
					
					
					essSetCurrentIdea(null);
					if((selectedReq.ideas != null) &amp;&amp; (selectedReq.ideas.length > 0)) {
						essSetCurrentIdea(essIdeas.currentNeed.ideas[0]);
						essSetIdeaDetails();
					} else {
						refreshIdeasData();
					}
				} else {
					essClearIdeaDetails();
				}
			}
			
			function initIdeasJS(){
				//Initialise JS for the Ideas Panel. Triggered by the Ideas icon in the header (core_header.xsl)
				//Init Select2 library
				$('.ideaSelect').select2({theme: "bootstrap"});
				$('#idea-info-trigger,#option-info-trigger').click(function() {
					$('[role="tooltip"]').remove();
				});
				$('#idea-info-trigger,#option-info-trigger').popover({
					container: 'body',
					html: true,
					trigger: 'click',
					placement: 'left',
					content: function(){
						return $(this).next().html();
					}
				});
				
				
				
				//listener for needs list
	            $('#ess-panel-need-list').on('select2:select', function (e) {
					let needId = e.params.data.id;
					if(needId != null) {
						//update up the ideas list
				    	let selectedReq = essIdeas.needs.find(function(aReq) {
				    		return aReq.id == needId;
				    	});
						setCurrentNeedDetails(selectedReq);
					}	                
	            });
	            
	            //listener for ideas list
	            $('#ess-panel-idea-list').on('select2:select', function (e) {
					let ideaId = e.params.data.id;
					if(ideaId != null) {
						//update up the ideas list
				    	let selectedIdea = essIdeas.currentNeed.ideas.find(function(anIdea) {
				    		return anIdea.id == ideaId;
				    	});
						if(selectedIdea != null) {
							//console.log('Clicked on an idea: ' + selectedIdea.name);
							//essIdeas.currentIdea = selectedIdea;
							essSetCurrentIdea(selectedIdea);
							essSetIdeaDetails();
						}
					}	                
	            });
	            
	            
	             //listener for new need button
	            $('#ess-panel-new-need-btn').on('click', function (e) {
	            	essIdeas.createMode = essNeedCreateMode;
	            	$('#ess-new-idea-el-title').text('New Value Proposition');
	            	$('#ess-new-idea-el-modal').modal().show();
	            });
	            
	            
	            
	            //listener for delete need link	            
	            $('#ess-need-delete-link').on('click', function (e) {
	            	if(essIdeas.currentNeed != null) {
	            		essDeleteCurrentNeed();
	            	}
	            });
	            
	            
	            //listener for delete idea link	            
	            $('#ess-option-delete-link').on('click', function (e) {
	            	if(essIdeas.currentIdea != null) {
	            		essDeleteCurrentIdea();
	            	}
	            });
	            
	             //listener for view ideas catalogue menu item
	            $('#ess-need-catalogue-menu').on('click', function (e) {
	            	//clicked on View Ideas menu item
	            	$('#ideasPanel').css('margin-right','-340px');
					$('#ideasPanel').removeClass('active');
	            	$('#ess-idea-catalogue-modal').modal().show();            	
	            });
	            
	            
	            $('#ess-idea-catalogue-modal').on('shown.bs.modal', function (e) {
	            	if(essIdeas.ideasCatalogue == null) {
	            		$('#dt_ideas_cat tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
					    } );
						
						essIdeas.ideasCatalogue = $('#dt_ideas_cat').DataTable({
						scrollY: "300px",
						scrollCollapse: true,
						paging: false,
						deferRender: true,
						info: false,
						sort: true,
						responsive: true,
						data: essIdeas.allNeeds,
						columns: [
						    { 
						    	"data" : "name",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {       
					                	let needDashURL = busNeedDashUri + '&amp;PMA=' + row.id;
					                    return '<a href="' + needDashURL + '">' + data + '</a>';
					                } else {
					                    return "";
					                }
					            }
					    	},
						    { 
						    	"data" : "description",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return data;
					                } else {
					                    return "";
					                }
					            }
					    	},
						    { 
						    	"data" : "meta",
						    	"render": function( data, type, row, meta ) {
					                if((data != null) &amp;&amp; (data.createdBy != null)) {              
					                    return data.createdBy.id;
					                } else {
					                    return "";
					                }
					            }
						    },
						    {
						    	"data" : "meta.createdOn",
						    	"type": "date",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return moment(data).format('DD MMM YYYY');
					                } else {
					                    return "";
					                }
					            }
					    	},
						    {
						    	"data" : "status",
						    	"render": function( data, type, row, meta ) {
					                if((data != null)) {   
					                	if(data.label) {
					                    	return data.label;
				                    	} else {
				                    		data.name;
				                    	}
					                } else {
					                    return "";
					                }
					            }
					    	},
						    {
						    	"data" : "submitIdeasByDate",
						    	"type": "date",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return moment(data).format('DD MMM YYYY');
					                } else {
					                    return "";
					                }
					            }
					    	},
						    {
						    	"data" : "targetPersonas",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationInstanceBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
						    {
						    	"data" : "goalStatements",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationTextBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
					    	{
						    	"data" : "rationaleStatements",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationTextBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
					    	{
						    	"data" : "targetOrgScope",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationInstanceBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
					    	{
						    	"data" : "targetGeoScope",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationInstanceBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
					    	{
						    	"data" : "targetCostChanges",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationCostChangeBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
					    	{
						    	"data" : "targetRevenueChanges",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationRevChangeBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	},
					    	{
						    	"data" : "targetOutcomeChanges",
						    	"render": function( data, type, row, meta ) {
					                if(data != null) {              
					                    return essIdeationSQChangeBulletsTemplate(data);
					                } else {
					                    return "";
					                }
					            },
						    	"visible": false
					    	}
						  ],
						dom: 'Bfrtip',
					    buttons: [
					    	'colvis',
				            'copyHtml5', 
				            'excelHtml5',
				            'csvHtml5',
				            'pdfHtml5',
				            'print'							 
				        ]
						});
						
						
						// Apply the search
					    essIdeas.ideasCatalogue.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    essIdeas.ideasCatalogue.columns.adjust();
					    
					    $(window).resize( function () {
					        essIdeas.ideasCatalogue.columns.adjust();
					    });
	            	
	            	}
	            });
	            
	             //listener for new idea button
	            $('#ess-panel-new-idea-btn').on('click', function (e) {
	            	//clicked on new Need button
	            	$('#ess-new-idea-el-title').text('New Proposal');
	            	essIdeas.createMode = essIdeaCreateMode;
	            	$('#ess-new-idea-el-modal').modal().show();            	
	            });
	            
	           	//listener for cancel new need/idea button
	            $('#ess-cancel-new-idea-el-btn').on('click', function (e) {
	            	$('#ess-new-idea-el-modal').modal().hide();            	
	            });
	            
	            //listener for confirm new need/idea button
	            $('#ess-confirm-new-idea-el-btn').on('click', function (e) {
	            	if(essIdeas.createMode == essNeedCreateMode) {
		            	let needName = $('#ess-new-idea-el-name').val();
		            	let needDesc = $('#ess-new-idea-el-desc').val();
		            	essCreateNeed(needName, needDesc);
	            	} else if(essIdeas.createMode == essIdeaCreateMode) {
	            		let ideaName = $('#ess-new-idea-el-name').val();
		            	let ideaDesc = $('#ess-new-idea-el-desc').val();
		            	essCreateIdea(ideaName, ideaDesc);
	            	}
	            	
		            $('#ess-new-idea-el-modal').modal().hide();
	            });
	            
	            
	            //listener for cancel new need/idea button
	            $('#ess-new-idea-el-modal').on('hidden.bs.modal', function (e) {
	            	$('#ess-new-idea-el-name').val('');
	            	$('#ess-new-idea-el-desc').val('');
	            	essIdeas.createMode = null;           	
	            });
	            
	            <!--Set the Help Text for Ideas Panel-->
				// Define the tour!
				var ideationHelp = {
				  id: "callout-ideation",
				  bubblePadding: 10,
				  showPrevButton: true,
				  steps: [
				    {
				      title: "Ideation",
				      content: "Ideation lets you capture freeform Value Propositions and define, propose and rate Proposals for their delivery as you navigate your portals",
				      target: "esshelp-ideation",
				      placement: "left",
				      yOffset: -15
				    },
				    {
				      title: "Value Propositions",
				      content: "A Value Proposition is a business need or issue that has the potential to be addressed through changes to your business, information/data, applications or technology",
				      target: "esshelp-ideation-idea",
				      placement: "left",
				      yOffset: -20
				    },
				    {
				      title: "Proposals",
				      content: "Define one or more options for how ideas proposed by you or others can be realised",
				      target: "esshelp-ideation-option",
				      placement: "left",
				      yOffset: -20
				    },
				    {
				      title: "Proposal Description",
				      content: "Provide an overall summary of a suggested option",
				      target: "esshelp-ideation-description",
				      placement: "left",
				      yOffset: -20
				    },
				    {
				      title: "Proposal Status",
				      content: "Proposals are initially created with a Draft status and only visible to you, but can be changed to Proposed when ready to be rated by other users, or approved / rejected by an authorised user",
				      target: "esshelp-ideation-status",
				      placement: "left",
				      yOffset: -20
				    },
				    {
				      title: "Proposed Changes",
				      content: "Suggested changes to business, information/data, application or technology elements can be added to Proposals using the Add to Proposal popup menu item",
				      target: "esshelp-ideation-changes",
				      placement: "left",
				      yOffset: -20
				    }
				  ]
				};
				
				// Start the tour!
				$('#esshelp-ideation-trigger').click(function(){
					hopscotch.startTour(ideationHelp);
				});

			};
			
			
			
			// create a mew Business Need
			var essCreateNeed = function (needName, needDesc) {
			    return new Promise(
			    function (resolve, reject) {
			        try {
			            let requestedNeed = new essNeed(needName, needDesc);
			            essPromise_createAPIElement(essEssentialCoreApiUri, requestedNeed, 'business-needs', 'Value Proposition')
			            .then(function (response) {
			                let newNeed = response;
			                addNewNeedDetails(newNeed);
			                resolve(newNeed);
			            }).catch (function (error) {
			            	let createError = new Error('Failed to create the new Value Proposition:  ' + error.message);
			                reject(error);
			            });
			        }
			        catch (error) {
		                let createError = new Error('Failed to create the new Value Proposition:  ' + error.message);
		                reject(createError);
			        }
			    });
			};
			
			
			// create a mew Idea
			var essCreateIdea = function (ideaName, ideaDesc) {
			    return new Promise(
			    function (resolve, reject) {
			        try {
			        	if(essIdeas.currentNeed != null) {
				            let requestedIdea = new essIdea(ideaName, ideaDesc);
				            let ideaResourceUrl = 'business-needs/' + essIdeas.currentNeed.id + '/ideas';
				            essPromise_createAPIElement(essEssentialCoreApiUri, requestedIdea, ideaResourceUrl, 'Idea')
				            .then(function (response) {
				                let newIdea = response;
				                addNewIdeaDetails(newIdea);
				                resolve(newIdea);
				            }).catch (function (error) {
				            	let createError = new Error('Failed to create the new Business Need:  ' + error.message);
				                reject(createError);
				            });
			            } else {
			            	let createError = new Error('A Need must be selected to create a new Idea');
			            	reject(createError);
			            }
			        }
			        catch (error) {
		                let createError = new Error('Failed to create the new Business Need:  ' + error.message);
		                reject(createError);
			        }
			    });
			};
			
			
			// update an Idea
			var essUpdateIdea = function (priorIdea, updatedIdea, ideaAttrList) {
			    return new Promise(
			    function (resolve, reject) {
			        try {
			            var ideaJSONForUpdate = essRenderUpdateJSON(updatedIdea, ideaAttrList);
			            if(ideaJSONForUpdate.meta == null) {
			            	ideaJSONForUpdate.meta = {};	
			            	ideaAttrList.push('meta');
			            }
			            ideaJSONForUpdate.meta.lastModifiedOn = moment().toISOString();			            
			            let ideaResourceUrl = 'business-needs/' + essIdeas.currentNeed.id + '/ideas';
			            essPromise_updateAPIElement(essEssentialCoreApiUri, ideaJSONForUpdate, ideaResourceUrl, 'Idea').then(function (response) {
			                var newIdea = response;
			                ideaAttrList.forEach(function (ideaAttr, attrIndex) {
			                    updatedIdea[ideaAttr] = newIdea[ideaAttr];
			                });
			                essSetIdeaDetails();
			                resolve(updatedIdea);
			            }).catch (function (error) {
			                var ideaAttString = '';
			                ideaAttrList.forEach(function (ideaAttr, attrIndex) {
			                    updatedIdea[ideaAttr] = priorIdea[ideaAttr];
			                    ideaAttString = ideaAttString + ideaAttr + ', ';
			                });
			                var updateError = new Error('Failed to update ' + ideaAttString + 'of ' + updatedIdea.name);
			                console.log('Idea Update Error: ' + updateError.message + ' - ' + error.message);
			                reject(updateError);
			            });
			        }
			        catch (error) {
			            var ideaAttString = '';
		                ideaAttrList.forEach(function (ideaAttr, attrIndex) {
		                    updatedIdea[ideaAttr] = priorIdea[ideaAttr];
		                    ideaAttString = ideaAttString + ideaAttr + ', ';
		                });
		                var updateError = new Error('Failed to update ' + ideaAttString + 'of ' + updatedIdea.name);
		                console.log('Idea Update Error: ' + updateError.message + ' - ' + error.message);
		                reject(updateError);
			        }
			    });
			};
			
			
			// delete a Need
			var essDeleteCurrentNeed = function () {
			    return new Promise(
			    function (resolve, reject) {
			        try {		            
			            essPromise_deleteAPIElement(essEssentialCoreApiUri, essIdeas.currentNeed.id, 'business-needs', 'Idea').then(function (response) {
			                let currentNeedIdx = essIdeas.needs.indexOf(essIdeas.currentNeed);
			                essIdeas.needs.splice(currentNeedIdx, 1);
			                
			                essClearIdeaDetails();
			                $('#ess-panel-need-list').html(essIdeationInstanceListTemplate(essIdeas.needs)).promise().done(function(){
			                	if(essIdeas.needs.length > 0) {
				                	let aNeed = essIdeas.needs[0];
				                	essSetCurrentNeed(aNeed);			                	
				                	$('#ess-panel-need-list').val(essIdeas.currentNeed.id).trigger('change');			    				
				                } else {
				                	essSetCurrentNeed(null);
				                }
							});
							if(essIdeas.currentNeed.ideas == null) {
								refreshIdeasData();
							} else {
								essInitCurrentIdea();
								essSetIdeaDetails();
							}
			                resolve(true);
			            }).catch (function (error) {
			                var deleteError = new Error('Failed to delete idea: ' + essIdeas.currentNeed.name + ' - ' + error.message);
			                reject(deleteError);
			            });
			        }
			        catch (error) {
		                var deleteError = new Error('Failed to delete idea: ' + essIdeas.currentNeed.name + ' - ' + error.message);
		                reject(deleteError);
			        }
			    });
			};
			
			
			// delete an Idea
			var essDeleteCurrentIdea = function () {
			    return new Promise(
			    function (resolve, reject) {
			        try {		            
			            let ideaResourceUrl = 'business-needs/' + essIdeas.currentNeed.id + '/ideas';
			            essPromise_deleteAPIElement(essEssentialCoreApiUri, essIdeas.currentIdea.id, ideaResourceUrl, 'Proposal').then(function (response) {
			                let currentIdeaIdx = essIdeas.currentNeed.ideas.indexOf(essIdeas.currentIdea);
			                essIdeas.currentNeed.ideas.splice(currentIdeaIdx, 1);
			                
			                if(essIdeas.currentNeed.ideas.length > 0) {
			                	essSetCurrentIdea(essIdeas.currentNeed.ideas[0]);
			                } else {
			                	essSetCurrentIdea(null);
			                }
			                essSetIdeaDetails();		                
			                resolve(true);
			            }).catch (function (error) {
			                var deleteError = new Error('Error when deleting idea option: ' + essIdeas.currentIdea.name + ' - ' + error.message);
			                reject(deleteError);
			            });
			        }
			        catch (error) {
		                var deleteError = new Error('Error when deleting idea option: ' + essIdeas.currentIdea.name + ' - ' + error.message);
		                reject(deleteError);
			        }
			    });
			};
		</script>
		<style type="text/css">
			#ideasPanel {
			  height: calc(100% - 40px); /* 100% Full-height minus headers */
			  width: 300px; /* 0 width - change this with JavaScript */
			  margin-right: -340px;
			  position: fixed;
			  z-index: 5000;
			  bottom: 0;
			  right: 0;
			  top: 41px;
			  padding: 5px 10px;
			  background-color: #fff;
			  overflow-x: hidden;
			  overflow-y: hidden;
			  transition: margin-right 0.5s,height 0.5s,top 0.5s;
			  box-shadow: -1px 2px 4px 0px hsla(0, 0%, 0%, 0.5);
			}
			.ideaElementsList{
				width: 100%;
				height: calc(100vh - 510px);
				overflow-x: hidden;
				overflow-y: scroll;
				transition: height 0.5s;
			}
			.ideaElementsList > ul > li {
				width: 100%;
				border: 1px solid #ddd;
				position: relative;
				padding: 5px;
				min-height: 50px;
				border-radius: 4px;
				box-shadow: 1px 0px 2px 0 hsla(0,0%,0%,0.25);
				margin-bottom: 10px;
			}
			.ideaElement {
			}
			
			.ideaElementNameTypeWrapper{
				width: 100%;
			}
			.ideaElementName{
				font-weight: 700;
			}
			.ideaElementType{
				font-size: 0.8em;
				font-style: italic;
				font-weight: 300;
				float:left;
			}
			.ideaElementChange{
				font-size: 0.8em;
				font-weight: 300;
				float: right;
			}
			.ideaElementIconWrapper{
				width: 30px;
				height: 30px;
				background-color: #fff;
				margin-left: 10px;
				float: right;
				border: 1px solid #ccc;
				border-radius: 25px;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			.ideaElementNameTypeWrapper:hover {
				opacity: 0.5;
				cursor: pointer;
			}
			
			.ess-idea-info-btn:hover {
				cursor: pointer;
			}
			
			.ess-idea-action:hover {
				cursor: pointer;
			}
			
			.ess-ideas-remove-change-btn{
				position: absolute;
				top: 0px;
				right: 5px;
				font-size: 0.8em;
				color: #333;
			}
			
			.ess-ideas-remove-change-btn:hover {
				opacity: 0.5;
				cursor: pointer;
			}
			
			.ideaElementDetail {
				color: #333;
				font-size: 0.8em;
				margin-top: 10px;
			}
			
			#idea-section {
				background-color: #f6f6f6;
				margin-left: -10px;
				margin-right: -10px;
				padding: 5px 10px;
				border-top: 1px solid #ccc;
				border-bottom: 1px solid #ccc;
			}
		</style>
		
		<!-- handlebars template for the the need list -->
		<script id="ess-ideation-instance-list-template" type="text/x-handlebars-template">
			{{#each this}}
				<option>
					<xsl:attribute name="value">{{id}}</xsl:attribute>
					{{name}}
				</option>
			{{/each}}
		</script>
		
		<!-- handlebars template for the the idea list -->
		<script id="ess-ideation-enum-list-template" type="text/x-handlebars-template">
			{{#each this}}
				<option>
					<xsl:attribute name="value">{{id}}</xsl:attribute>
					{{label}}
				</option>
			{{/each}}
		</script>
		
		<!-- handlebars template for the idea popup -->
		<script id="ess-idea-info-template" type="text/x-handlebars-template">
			{{#if description}}
			<div><strong>Description: </strong></div>
			<div>{{description}}</div>
			{{/if}}
			<div><strong>Submitted by: </strong></div>
			<div><span id="idea-author">{{meta.createdBy.id}}</span>{{#if meta.createdOnDisplay}}<span> on </span><span id="idea-submitted-date">{{meta.createdOnDisplay}}</span>{{/if}}</div>
			{{#if meta.lastModifiedOnDisplay}}
			<div><strong>Last Modified on: </strong></div>
			<div><span id="idea-submitted-date">{{meta.lastModifiedOnDisplay}}</span></div>
			{{/if}}
		</script>
		
		
		<!-- Handlebars template to render a list in a drop down box-->
		<script id="ess-ideas-panel-changes-template" type="text/x-handlebars-template">
			<ul class="list-unstyled">
				{{#each changes}}
					<li class="text-danger">
						<div class="ideaElement">
							<div class="ess-ideas-remove-change-btn">
								<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
								<i class="fa fa-trash"/>
							</div>
							<div class="ideaElementNameTypeWrapper">
								<div class="ideaElementName">{{element.name}}</div>
								<div class="clearfix"/>
								<div>
									<div class="ideaElementType">{{element.meta.typeLabel}}</div>
									<div class="ideaElementChange">{{change.label}}</div>
								</div>
							</div>
							
							<!--<div class="ideaElementIconWrapper">
								<i>
									<xsl:attribute name="class">fa {{#each change.styles}}{{icon}} {{/each}} fa-lg</xsl:attribute>
								</i>
							</div>-->
							
							<div class="clearfix"/>
						</div>
						<div class="ideaElementDetail hiddenDiv">
							<!--<div class="strong">Description:</div>
							<div>Description of the object goes here.</div>-->
							<div class="strong top-10">Proposed Changes:</div>
							<select class="ess-idea-plan-action select2 ideaSelect small" style="width:100%;">
								<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
								{{#each ../planningActions}}
									<option>
										<xsl:attribute name="value">{{id}}</xsl:attribute>
										{{label}}
									</option>
								{{/each}}
							</select>
							<div class="strong top-10">Rationale:</div>
							<textarea class="ess-idea-chg-rationale" rows="4" cols="" style="width:100%" placeholder="Enter a rationale for selecting this planning action with this element"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>{{rationale}}</textarea>
						</div>
					</li>
				{{/each}}
			</ul>
		</script>
		
		
		<div id="ideasPanel">
			<span class="pull-right" onclick="closeIdeas()">
				<i class="fa fa-times"/>
			</span>
			<div id="esshelp-ideation"><span class="xlarge text-primary">Ideation</span><i id="esshelp-ideation-trigger" class="fa fa-question-circle left-5 fa-align-xl"/></div>
			<div id="idea-section" class="top-5">
				<div>
					<strong id="esshelp-ideation-idea">Value Proposition</strong><i id="idea-info-trigger" class="fa fa-info-circle ess-idea-info-btn left-5" data-toggle="popover"/>
					<div id="ess-idea-info" class="popover small"/>			
					<div class="dropdown pull-right" style="position: relative;">
						<i class="ess-idea-action fa fa-ellipsis-h dropdown-toggle" data-toggle="dropdown"/>
						<ul class="dropdown-menu">
						    <li><a id="ess-need-view-link" target="_blank"><i class="fa fa-eye right-5"/>View Value Proposition</a></li>
							<li id="ess-need-edit-menu"><a id="ess-need-edit-link" target="_blank"><i class="fa fa-pencil right-5"/>Edit Value Proposition</a></li>
							<li id="ess-need-delete-menu"><a id="ess-need-delete-link"><i class="fa fa-trash right-5"/>Delete Value Proposition</a></li>
							<li id="ess-need-catalogue-menu"><a id="ess-need-catalogue-link"><i class="fa fa-list-ul right-5"/>View All Value Propositions</a></li>
						</ul>
					</div>
					<!--<a id="ess-need-view-link" class="small pull-right">
						<i id="ess-panel-view-need-btn" class="fa fa-eye right-5"/>
						<span>View</span>
					</a>-->
				</div>
				<select id="ess-panel-need-list" class="select2 ideaSelect" style="width:100%">
					<!--<option>Reduce field-worker data load</option>
					<option>Requirement 2</option>
					<option>Requirement 3</option>-->
				</select>
				<div>
					<a class="top-5 small" id="ess-panel-new-need-btn">
						<i class="fa fa-plus-circle right-5"/>
						<span>New Value Proposition</span>
					</a>
				</div>
				<!--<a id="ess-need-edit-link" class="top-5 small pull-right" target="_blank">
					<i id="ess-panel-edit-need-btn" class="fa fa-pencil right-5"/>
					<span>Edit</span>
				</a>-->				
				<div class="clearfix"/>
			</div>
			<div class="top-10">
				<div class="pull-left">
					<strong id="esshelp-ideation-option">My Proposals</strong>
				</div>
				<div id="option-info-content" class="pull-left">
					<i id="option-info-trigger" class="ess-idea-info-btn fa fa-info-circle left-5" data-toggle="popover"/>
					<div id="ess-idea-option-info" class="popover small"/>
				</div>
				<div id="ess-idea-option-menu" class="dropdown pull-right" style="position: relative;">
					<i class="ess-idea-action fa fa-ellipsis-h dropdown-toggle" data-toggle="dropdown"/>
					<ul class="dropdown-menu">
					    <!--<li><a id="ess-option-view-link"><i class="fa fa-eye right-5"/>View Proposal</a></li>
					    <li><a id="ess-option-edit-link" target="_blank"><i class="fa fa-pencil right-5"/>Edit Proposal</a></li>-->
						<li><a id="ess-option-delete-link"><i class="fa fa-trash right-5"/>Delete Proposal</a></li>
					</ul>
				</div>
				<!--<a class="pull-right">
					<i class="fa fa-link"/>
				</a>-->
			</div>
			<select id="ess-panel-idea-list" class="select2 ideaSelect" style="width:100%">
				<!--<option>Idea 1</option>
				<option>Idea 2</option>
				<option>Idea 3</option>-->
			</select>
			<a id="ess-panel-new-idea-btn" class="top-5 small">
				<i class="fa fa-plus-circle right-5"/>
				<span>New Proposal</span>
			</a>
			<div id="ess-idea-side-container">
				<div class="top-10">
					<strong id="esshelp-ideation-description">Description</strong>
				</div>
				<textarea rows="2" style="width:100%" id="ess-idea-desc" class="form-control"/>
				<div class="clearfix"/>
				<!--<div id="ess-option-visi-section">
					<div class="top-10">
						<strong>Who can see this option?</strong>
					</div>
					<select id="ess-panel-idea-vis-list" class="select2 ideaSelect" style="width:100%">
						<!-\-<option value="visibility1">Only me</option>
						<option value="visibility2">Everyone in my organisation</option>-\->
					</select>
				</div>-->
				<div class="top-10">
					<strong id="esshelp-ideation-status">Status</strong>
				</div>
				<select id="ess-panel-idea-status-list" class="select2 ideaSelect" style="width:100%"/>
				<hr class="tight"/>
				<p id="esshelp-ideation-changes" class="large impact">Proposed Changes</p>
				<div id="ess-panel-idea-plans" class="ideaElementsList bottom-30"/>
			</div>
		</div>
		
		
		<!-- Handlebars template for the contents of the Business Need Modal -->
		<script type="text/x-handlebars-template" id="ess-new-need-modal-template">
			
		</script>
		
		<!-- Generic Need -->
		<div id="ess-new-idea-el-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="ess-new-idea-el-modal-label">
			<div class="modal-dialog" role="document">
				<div id="ess-new-idea-el-modal-content" class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
						<p id="ess-new-idea-el-modal-label" class="modal-title xlarge text-primary"><i class="fa fa-lightbulb-o right-10"/><strong><span id="ess-new-idea-el-title"></span></strong></p>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-xs-12">
								<p class="impact large text-primary"><i class="fa fa-check-circle right-5"/>Name</p>
								<input type="text" id="ess-new-idea-el-name" class="form-control" placeholder="Enter a short name for the idea"/>
							</div>
							<div class="col-xs-12 top-15">
								<p class="impact large text-primary"><i class="fa fa-check-circle right-5"/>Description</p>
								<textarea id="ess-new-idea-el-desc" class="form-control" placeholder="Enter notes summarising the idea"/>
							</div>	
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" id="ess-cancel-new-idea-el-btn" class="btn btn-danger" data-dismiss="modal">Cancel</button>
						<button type="button" id="ess-confirm-new-idea-el-btn" class="btn btn-success" data-dismiss="modal">Confirm</button>
					</div>
				</div>
			</div>
		</div>
		
		
		<!-- Need Catalogue Modal -->
		<!--<xsl:call-template name="dataTablesLibrary"/>-->
		<!-- Handlebars template for the contents of the Business Need Modal -->
		<script type="text/x-handlebars-template" id="ess-ideation-text-bullets-template">
			<ul>
				{{#each this}}
					<li>{{this}}</li>
				{{/each}}
			</ul>
		</script>
		
		<script type="text/x-handlebars-template" id="ess-ideation-instance-bullets-template">
			<ul>
				{{#each this}}
					<li>{{name}}</li>
				{{/each}}
			</ul>
		</script>
		
		<script type="text/x-handlebars-template" id="ess-ideation-sq-change-bullets-template">
			<ul>
				{{#each this}}
					<li>{{outcome.name}}</li>
				{{/each}}
			</ul>
		</script>
		
		<script type="text/x-handlebars-template" id="ess-ideation-cost-change-bullets-template">
			<ul>
				{{#each this}}
					<li>{{#if costCategory.label}}{{costCategory.label}}{{else}}{{costCategory.name}}{{/if}}</li>
				{{/each}}
			</ul>
		</script>
		
		
		<script type="text/x-handlebars-template" id="ess-ideation-rev-change-bullets-template">
			<ul>
				{{#each this}}
					<li>{{#if revenueCategory.label}}{{revenueCategory.label}}{{else}}{{revenueCategory.name}}{{/if}}</li>
				{{/each}}
			</ul>
		</script>
		
		
		<div id="ess-idea-catalogue-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="ess-idea-catalogue-modal-label">
			<div class="modal-dialog modal-xl" role="document">
				<div id="ess-idea-catalogue-modal-content" class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&#215;</span></button>
						<p id="ess-idea-catalogue-modal-label" class="modal-title xlarge text-primary"><i class="fa fa-lightbulb-o right-10"/><strong><span><xsl:value-of select="eas:i18n('Ideas Catalogue')"/></span></strong></p>
					</div>
					<div class="modal-body">
						<p><xsl:value-of select="eas:i18n('This table lists all Ideas that have been submitted across the enterprise')"/></p>
						<table id="dt_ideas_cat" class="table table-striped table-bordered small">
							<thead>
								<tr>
									<th>
										<xsl:value-of select="eas:i18n('Idea')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Author')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Creation Date')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Status')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Submission Deadline')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Target Personas')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Motivations')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Rationale')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Organisational Scope')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Geographic Scope')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Cost Targets')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Revenue Targets')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('KPI Targets')"/>
									</th>
								</tr>
							</thead>
							<tfoot>
								<tr>
									<th>
										<xsl:value-of select="eas:i18n('Idea')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Description')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Author')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Creation Date')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Status')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Submission Deadline')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Target Personas')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Motivations')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Rationale')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Organisational Scope')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Geographic Scope')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Cost Targets')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('Revenue Targets')"/>
									</th>
									<th>
										<xsl:value-of select="eas:i18n('KPI Targets')"/>
									</th>
								</tr>
							</tfoot>
							<tbody/>									
						</table>
					</div>
					<div class="modal-footer">
						<button type="button" id="ess-close-idea-catalogue-btn" class="btn btn-primary" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
