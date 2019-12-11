<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="()"/>
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

	<xsl:variable name="ideaDashReport" select="eas:get_report_by_name('Core: Idea Dashboard')"/>
	<xsl:variable name="ideaDashReportHRef">
		<xsl:call-template name="RenderLinkText">
			<!--<xsl:with-param name="theHistoryLabel"><xsl:value-of select="$ideaDashReport/own_slot_value[slot_reference = 'report_history_label']/value"/>{{name}}</xsl:with-param>-->
			<xsl:with-param name="theXSL"><xsl:value-of select="$ideaDashReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/></xsl:with-param>
			<!--<xsl:with-param name="theInstanceID">{{id}}</xsl:with-param>-->
		</xsl:call-template>
	</xsl:variable>

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
				<title><xsl:value-of select="eas:i18n('My Approvals Dashboard')"/></title>
				<xsl:call-template name="dataTablesLibrary"/>
				<style type="text/css">
					#showPendingLink,#showSubmittedLink {
						cursor:pointer;
					}
					#showPendingLink:hover,#showSubmittedLink:hover {
						opacity: 0.5;
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('My Approvals Dashboard')"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<h2>
								<span class="text-primary" id="showPendingLink" onclick="showPendingContent();"><xsl:value-of select="eas:i18n('Items Pending My Approval')"/></span>
								<span class="left-15 right-15" id="tabDivider">|</span>								
								<span id="showSubmittedLink" onclick="showSubmittedContent();"><xsl:value-of select="eas:i18n('My Items Submitted for Approval')"/></span><span class="left-5" id="myContentCount"/>
							</h2>

							<xsl:call-template name="pendingApproval"/>
							<xsl:call-template name="submittedApproval"/>


							<!--Pending Approval Section-->

						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>
				
				<!-- handlebars template for the the idea list -->
				<script id="ess-approvals-enum-list-template" type="text/x-handlebars-template">
					<select class="dt_ApprovalSelect" style="width: 100%;">
						<xsl:attribute name="eas-id">{{content.id}}</xsl:attribute>
						{{#each statii}}
							<option>
								<xsl:attribute name="value">{{id}}</xsl:attribute>
								{{label}}
							</option>
						{{/each}}
					</select>
				</script>
				
				<!-- handlebars template for the the idea list -->
				<script id="ess-approvals-update-btn-template" type="text/x-handlebars-template">
					<button type="submit" class="status-btn btn btn-sm btn-default">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						Update
					</button>
				</script>
				
				<!-- handlebars template for the the idea list -->
				<script id="ess-approvals-decision-comment-template" type="text/x-handlebars-template">
					<!--<div class="row">
						<div class="col-xs-8">
							<textarea rows="2" class="small appr-comment-box" style="width: 100%;">
								<xsl:attribute name="placeholder"><xsl:value-of select="eas:i18n('Comments (required for reject decisions)')"/></xsl:attribute>
								<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
								<xsl:attribute name="value">{{decisionComment.comment}}</xsl:attribute>
							</textarea>
						</div>
						<div class="col-xs-4 appr-decision-btns">
							<button class="top-5 accept-appr-btn btn btn-success btn-sm pull-left right-10" style="width: 60px;"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:value-of select="eas:i18n('Approve')"/></button>
							<button class="top-5 reject-appr-btn btn btn-danger btn-sm btn" style="width: 60px;"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:value-of select="eas:i18n('Reject')"/></button>
						</div>
						<div class="col-xs-12">
							<span class="appr-decision-error textColourRed"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
						</div>
					</div>-->
					<button class="btn btn-sm btn-info approval-link-btn">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						View for Approval
					</button>
				</script>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script type="text/javascript">
					// Setup Select2 on Approval Select dropdown
					
					var approvalReports = {
						"Need": "<xsl:value-of select="$ideaDashReportHRef"/>&amp;PMA=" 	
					}
					
					function initSelect2(){
						$('.dt_ApprovalSelect').select2({theme: "bootstrap"});
					};
					
					//render the button for updating the statis of content
					function renderStatusBtn(theContent) {
						if(theContent != null) {
							return approvalsStatusBtnTemplate(theContent);
						} else {
							return '';
						}
					}
					
					//render the status drop down list, initialised to content's current status
					function renderStatusList(theContent) {
						if(theContent != null) {
							let listObj = {
								content: theContent,
								statii: [draftStatus, theContent.meta.contentStatus]
							}
							return approvalsEnumListTemplate(listObj);
						} else {
							return '';
						}
					}
					
					//render the status comment box, initialised to content's current comment
					function renderDecisionComment(theContent) {
						if(theContent != null) {
							return approvalDecnCommentTemplate(theContent);
						} else {
							return '';
						}
					}
					
					var pendingApprovalsTable, submittedApprovalsTable;
					
					// function to update the contents of the table containing conent awaiting approval
					function refreshPendingDataTables() {
						if(pendingApprovalsTable != null) {
							pendingApprovalsTable.clear();
						    pendingApprovalsTable.rows.add(filteredContentForMyApproval);
				    
						    pendingApprovalsTable.draw();	
					    } else {
					    	initPendingDataTables();
					    }
					}
					
					// Setup Pending Approvals Datatable
					function initPendingDataTables(){
						if(pendingApprovalsTable == null) {
					
							//START INITIALISE UP THE CATALOGUE TABLE
							// Setup - add a text input to each footer cell
						    $('#dt_pendingApprovals tfoot th').not(":eq(5)").each( function () {
						        var title = $(this).text();
						        $(this).html( '&lt;input class="pendingAppsSearch" type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							pendingApprovalsTable = $('#dt_pendingApprovals').DataTable({
							paging: false,
							deferRender:    true,
				            scrollY:        350,
				            scrollCollapse: true,
				            filter: false,
							info: true,
							sort: true,
							responsive: false,
							data: filteredContentForMyApproval,
							<!--fnDrawCallback: function( oSettings ) {
						      	initSelect2();
						      	
						      	$('.accept-appr-btn').on('click', function (e) {
									let contentId = $(this).attr('eas-id');
									approveContent(contentId);
								});
								
								$('.reject-appr-btn').on('click', function (e) {
									let contentId = $(this).attr('eas-id');
									rejectContent(contentId);
								});	
						    },-->
						    "fnDrawCallback": function(settings) {
						    	
							     $('.approval-link-btn').on('click', function() {
							     			
							          let contentId = $(this).attr('eas-id');

							          if(contentId != null) {
							          	let thisCnt = filteredContentForMyApproval.find(function(aCnt) {
							          		return aCnt.id == contentId;
							          	});
							          	
							          	if((thisCnt != null) &amp;&amp; (thisCnt.approvalLink != null)) {
							          		window.open(thisCnt.approvalLink);
							          	}
							          }
				                });
							},
							columns: [	
							    { 
							    	"data" : "name",
							    	"width": "20%" 
							    },
							    {
							    	"data" : "meta",
							    	"width": "10%",
							    	"render": function(d){
						                if(d !== null){   
					                		if(d.typeLabel != 'Unknown') {
					                    		return d.typeLabel;
					                    	} else {
					                    		return d.anchorClass;
					                    	}
							             } else {
							                return "";
							             }
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "25%",
							    	"render": function( data, type, row, meta ) {
						                if(row.description != null) {              
						                    return row.description;
						                } else {
						                    return "";
						                }
						            }
							    },
							    {
							    	"data" : "meta",
							    	"width": "20%",
							    	"render": function(d){
						                if((d != null) &amp;&amp; (d.createdBy != null)){              
						                    return d.createdBy.id;
						                } else {
						                    return "";
						                }
						            }
							    },
							    {
							    	"data" : "meta",
							    	"width": "15%",
							    	"render": function(d){
						                if((d != null) &amp;&amp; (d.lastModifiedOn != null)){              
						                    return moment(d.lastModifiedOn).format('DD MMM YYYY, hh:mm');
						                } else {
						                    return "";
						                }
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "10%",
							    	"type": "html",
							    	"orderable": false,
							    	"render": function( data, type, row, meta ) {
						                //render the decision comment						                
						                return renderDecisionComment(row);
						            }
							    }
							    <!--{
							    	"data" : "id",
							    	"width": "10%",
							    	"type": "html",
							    	"render": function( data, type, row, meta ) {
						                //render the drop down list of statii
						                return renderStatusList(row);
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "20%",
							    	"type": "html",
							    	"render": function( data, type, row, meta ) {
						                //render the decision comment
						                return renderDecisionComment(row);
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "5%",
							    	"type": "html",
							    	"render": function( data, type, row, meta ) {
						                //render the button to update the status of the content
						                return renderStatusBtn(row);
						            }
							    }-->
							 ]
							});
							
							
							// Apply the search
						    pendingApprovalsTable.columns().every( function () {
						        var that = this;
						 
						        $( '.pendingAppsSearch', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						     
						    pendingApprovalsTable.columns.adjust();
						    
						    $(window).resize( function () {
						        pendingApprovalsTable.columns.adjust();
						    });
					    
					    }
					};
					
					
					// function to update the contents of the table containing conent awaiting approval
					function refreshSubmittedDataTables() {
						$('#myContentCount').text('(' + filteredMyContentForApproval.length + ')');
						if(submittedApprovalsTable != null) {
							submittedApprovalsTable.clear();
						    submittedApprovalsTable.rows.add(filteredMyContentForApproval);			    
						    submittedApprovalsTable.draw();	
					    } else {
					    	initSubmittedDataTables();
					    }
					}
					
					
					// Setup Submitted for Approvals Datatable
					function initSubmittedDataTables(){
						if(submittedApprovalsTable == null) {
							//START INITIALISE UP THE CATALOGUE TABLE
							// Setup - add a text input to each footer cell
						    $('#dt_submittedApprovals tfoot th').not(":eq(6)").each( function () {
						        var title = $(this).text();
						        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							submittedApprovalsTable = $('#dt_submittedApprovals').DataTable({
							paging: false,
							deferRender:    true,
				            scrollY:        350,
				            scrollCollapse: true,
				            filter: false,
							info: true,
							sort: true,
							responsive: false,
							data: filteredMyContentForApproval,
							fnDrawCallback: function( oSettings ) {
						    	initSelect2();
						    	
						    	//set the status values in the dorp down boxes
						    	filteredMyContentForApproval.forEach(function(cnt) {
						    		let statusList = $('.dt_ApprovalSelect[eas-id="' + cnt.id + '"]');
									statusList.val(cnt.meta.contentStatus.id).trigger('change');
						    	})
						    	
						    	$('.dt_ApprovalSelect').on('select2:select', function (e) {
									let contentId = $(this).attr('eas-id');
									let newStatusId = e.params.data.id;
									if(contentId != null) {
										//get the content item being updated
										let cnt = filteredMyContentForApproval.find(function(aCnt) {
											return aCnt.id == contentId;
										});									
										//If the status is being changed, it must be to draft and so reset the status of the content to draft
										if(newStatusId != cnt.meta.contentStatus.id) {
											resetMyContentStatus(cnt);
										}
									}
								});
						    },
							columns: [	
							    { 
							    	"data" : "name",
							    	"width": "15%" 
							    },
							    {
							    	"data" : "meta",
							    	"width": "10%",
							    	"render": function(d){
						                if(d !== null){   
					                		if(d.typeLabel != 'Unknown') {
					                    		return d.typeLabel;
					                    	} else {
					                    		return d.anchorClass;
					                    	}
							             } else {
							                return "";
							             }
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "20%",
							    	"render": function( data, type, row, meta ) {
						                if(row.description != null) {              
						                    return row.description;
						                } else {
						                    return "";
						                }
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "10%",
							    	"render": function( data, type, row, meta ) {
						                //render the date in which the content was put forward for approval
						                if((row.proposeComment != null) &amp;&amp; (row.proposeComment.decisionOnDisplay != null)) {
						                	return row.proposeComment.decisionOnDisplay;
						                } else {
						                	return '';
						                }
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "10%",
							    	"type": "html",
							    	"render": function( data, type, row, meta ) {
						                //render the drop down list of statii
						                return renderStatusList(row);
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "10%",
							    	"render": function( data, type, row, meta ) {
						                //render the name of the person that approved the content
						                if((row.decisionComment != null) &amp;&amp; (row.decisionComment.decisionBy != null)) {
						                	return row.decisionComment.decisionBy.name;
						                } else {
						                	return '';
						                }
						            }
							    },
							    {
							    	"data" : "id",
							    	"width": "25%",
							    	"type": "html",
							    	"render": function( data, type, row, meta ) {
						                //render any comment given alongside the decision
						                if((row.decisionComment != null) &amp;&amp; (row.decisionComment.comment != null)) {
						                	return row.decisionComment.comment;
						                } else {
						                	return '';
						                }
						            }
							    }
							 ]
							});
							
							
							// Apply the search
						    submittedApprovalsTable.columns().every( function () {
						        var that = this;
						 
						        $( 'input', this.footer() ).on( 'keyup change', function () {
						            if ( that.search() !== this.value ) {
						                that
						                    .search( this.value )
						                    .draw();
						            }
						        } );
						    } );
						     
						    submittedApprovalsTable.columns.adjust();
						    
						    $(window).resize( function () {
						        submittedApprovalsTable.columns.adjust();
						    });
					    
					    }
					};
					
					// Show the Pending Approval Tab
					function showPendingContent(){
						//destroyJS();
						$('#submittedApprovalContent').hide();
						$('#pendingApprovalContent').show();
						$('#showSubmittedLink').removeClass('text-primary');
						$('#showPendingLink').addClass('text-primary');
						//Init JS for Tab
						initPendingDataTables();
					};
					
					// Show the Submitted for Approval Tab
					function showSubmittedContent(){
						//destroyJS();
						$('#pendingApprovalContent').hide();
						$('#submittedApprovalContent').show();
						$('#showPendingLink').removeClass('text-primary');
						$('#showSubmittedLink').addClass('text-primary');
						//Init JS for Tab
						initSubmittedDataTables();			
						
					};
					
					// Destroy JS
					function destroyJS(){
						$('.dt_submittedApprovalSelect').off();
						$('.dt_pendingApprovalSelect').off();
						$('#dt_submittedApprovals').DataTable().destroy();
						$('#dt_pendingApprovals').DataTable().destroy();
					}
					
					var contentApprovalStatii = [];
					var draftStatus;
					var contentForMyApproval = [];
					var filteredContentForMyApproval = [];
					var myContentForApproval = [];
					var filteredMyContentForApproval = [];
					var myApprovalComments = [];
					var myContentApprovalComments = [];
					
					//load the latest needs
					function loadApprovalsData() {
						showViewSpinner('Loading data...');
						let apprDetsURL = 'content-approvals/' + essViewer.user.id + '/detail';
						Promise.all([
							essPromise_getAPIElements(essEssentialCoreApiUri, 'content-approval-statii', 'Content Approval Status'),
							essPromise_getAPIElements(essEssentialCoreApiUri, apprDetsURL, 'Content Approval Details'),
							essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'approval-comments', 'approval-decision-comments', 'decisionBy.id', essViewer.user.id, 'Approval Decision Comment'),
							essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'approval-comments', 'approval-decision-comments', 'authorId', essViewer.user.id, 'Approval Decision Comment')
						])
						.then(function (responses) {
							contentApprovalStatii = responses[0]['content-approval-statii'];
							draftStatus = contentApprovalStatii.find(function(aSt) {
								return aSt.name == ess_APPROVAL_STATII.draft;
							});
							contentForMyApproval = responses[1]['contentForApproval'];
							filteredContentForMyApproval = contentForMyApproval.filter(function(cnt) {
								return essViewer.user.approvalClasses.includes(cnt.meta.anchorClass);
							});
							
							//add approval link for content awaiting user's approval
							filteredContentForMyApproval.forEach(function(cnt) {
								let approvalLink = approvalReports[cnt.meta.anchorClass] + cnt.id;
						        cnt['approvalLink'] = approvalLink;
							});
							
							
							myContentForApproval = responses[1]['userApprovalContent'];
							filteredMyContentForApproval = myContentForApproval;
							$('#myContentCount').text('(' + filteredMyContentForApproval.length + ')');
							
							myApprovalComments = responses[2]['instances'];
							//add any comments to content that has already approved by the user
							<!--filteredContentForMyApproval.forEach(function(cnt) {
								let cmnt = myApprovalComments.filter(function(myCmnt) {
									return myCmnt.subjectId == cnt.id;
								});
								let decisionCmt = cmnt.find(function(aCmnt) {
									return aCmnt.decision != ess_APPROVAL_STATII.propose;
								});
								let propCmt = cmnt.find(function(aCmnt) {
									return aCmnt.decision == ess_APPROVAL_STATII.propose;
								});
								if(cmnt != null) {
									cnt.proposeComment = propCmt;
									cnt.decisionComment = decisionCmt;
								}
							});-->
							myContentApprovalComments = responses[3]['instances'];
							filteredMyContentForApproval.forEach(function(cnt) {
								let cmnt = myContentApprovalComments.filter(function(myCmnt) {
									return myCmnt.subjectId == cnt.id;
								});
								let decisionCmt = cmnt.find(function(aCmnt) {
									return aCmnt.decision != ess_APPROVAL_STATII.propose;
								});
								let propCmt = cmnt.find(function(aCmnt) {
									return aCmnt.decision == ess_APPROVAL_STATII.propose;
								});
								if(cmnt != null) {
									cnt.proposeComment = propCmt;
									cnt.decisionComment = decisionCmt;
								}
							});
							removeViewSpinner();
							// Page load
							if(essViewer.user.approvalClasses.length > 0) {
								initPendingDataTables();
							} else {
								$('#showPendingLink').addClass('hiddenDiv');
								$('#tabDivider').addClass('hiddenDiv');
								showSubmittedContent();
							}
						})
						.catch (function (error) {
							removeViewSpinner();
					        console.log('Approval Content Loading Error: ' + error.message);
					    });	
					}
					
					
					//function to update the status of the given content item
					function resetMyContentStatus(theContent) {
						//update the content item via core API
						let resetObj = new essApprovalDecision(theContent);
						let decisionURL = 'content-approvals/' + theContent.id + '/reset';	
						essPromise_createAPIElement(essEssentialCoreApiUri, resetObj, decisionURL, 'Approval Decision')
						.then(function (response) {
			                let cntIdx = filteredMyContentForApproval.indexOf(theContent);
							filteredMyContentForApproval.splice(cntIdx, 1);
							refreshSubmittedDataTables();
			                resolve(true);
			            }).catch (function (error) {
			            	let createError = new Error('Failed to reset the status of ' + theContent.name + ' to draft:  ' + error.message);
			                reject(error);
			            });
					}
					
					
					//named function for updating the table containing content for the user's approval
					var updateCntForMyApprTbl = function() {
						refreshPendingDataTables();
					}
					
					
					//functiom to reject a content item
					function rejectContent(contentId) {
						let thisContent = filteredContentForMyApproval.find(function(cnt) {
							return cnt.id == contentId;
						});		
						if(thisContent != null) {
							//approve the content
							let decisionCommentBox = $('.appr-comment-box[eas-id="' + thisContent.id + '"]');
							let decisionComment = null;
							if(decisionCommentBox != null) {
								decisionComment = decisionCommentBox.val();
								if((decisionComment != null) &amp;&amp; (decisionComment.length > 0)) {
									let cntIdx = filteredContentForMyApproval.indexOf(thisContent);
									filteredContentForMyApproval.splice(cntIdx, 1);
									updateApprovalCount(filteredContentForMyApproval.length);
									essRejectResource(thisContent, decisionComment, null, updateCntForMyApprTbl);
								} else {
									let decisionErr = $('.appr-decision-error[eas-id="' + thisContent.id + '"]');
									decisionErr.text('<xsl:value-of select="eas:i18n('A comment must be given when rejecting content')"/>');
								}
							}
						}
					}
					
					
					//function to approve a content item
					function approveContent(contentId) {
						let thisContent = filteredContentForMyApproval.find(function(cnt) {
							return cnt.id == contentId;
						});		
						if(thisContent != null) {

							//approve the content
							let decisionCommentBox = $('.appr-comment-box[eas-id="' + thisContent.id + '"]');
							let decisionComment = null;
							if(decisionCommentBox != null) {
								decisionComment = decisionCommentBox.val();
							}
							let cntIdx = filteredContentForMyApproval.indexOf(thisContent);
							filteredContentForMyApproval.splice(cntIdx, 1);
							updateApprovalCount(filteredContentForMyApproval.length);
							essApproveResource(thisContent, decisionComment, null, updateCntForMyApprTbl);
						}
					}
					
					
					var approvalsEnumListTemplate, approvalsStatusBtnTemplate, approvalDecnCommentTemplate;
					
					$(document).ready(function(){
						//compile the required handlebars templates
						let approvalsFragment = $("#ess-approvals-enum-list-template").html();
    					approvalsEnumListTemplate = Handlebars.compile(approvalsFragment);
    					
    					approvalsFragment = $("#ess-approvals-update-btn-template").html();
    					approvalsStatusBtnTemplate = Handlebars.compile(approvalsFragment);
    					
    					approvalsFragment = $("#ess-approvals-decision-comment-template").html();
    					approvalDecnCommentTemplate = Handlebars.compile(approvalsFragment);
					
						//load the content that requires approval
						loadApprovalsData();			
					});

				</script>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="pendingApproval">
		<div id="pendingApprovalContent">
			<!--<div class="bottom-15 pull-right">
				<span class="strong right-10">Show Items Previously Approved or Rejected:</span>
				<span>
					<input type="checkbox"/>
				</span>
			</div>-->
			<table class="table table-striped" id="dt_pendingApprovals">
				<thead>
					<tr>
						<th>Name</th>
						<th>Type</th>
						<th>Description</th>
						<th>Author</th>
						<th>Submission Date</th>
						<th>&#160;</th>
					</tr>
				</thead>
				<tbody/>
				<tfoot>
					<tr>
						<th>Name</th>
						<th>Type</th>
						<th>Description</th>
						<th>Author</th>
						<th>Submission Date</th>
						<th>&#160;</th>
					</tr>
				</tfoot>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="submittedApproval">
		<div id="submittedApprovalContent" class="hiddenDiv">
			<!--<div class="bottom-15 pull-right">
				<span class="strong right-10">Show Items Previously Approved or Rejected:</span>
				<span>
					<input type="checkbox"/>
				</span>
			</div>-->
			<table class="table table-striped" id="dt_submittedApprovals">
				<thead>
					<tr>
						<th>Name</th>
						<th>Type</th>
						<th>Description</th>
						<th>Submission Date</th>						
						<th>Status</th>
						<th>Approver</th>
						<th>Comment</th>
					</tr>
				</thead>
				<tbody>
					<!--<tr>
						<td>
							<a>My great idea</a>
						</td>
						<td>Idea</td>
						<td>This ideas is all about reducing data load for field workers</td>
						<td>Neil Walsh</td>
						<td>21 July 2019 16:46</td>
						<td>
							<select class="dt_submittedApprovalSelect" style="width: 100%;">
								<option>Proposed</option>
								<option>Draft</option>
							</select>
						</td>
						<td>
							<button type="submit" class="btn btn-sm btn-default">Update</button>
						</td>
					</tr>
					<tr>
						<td>
							<a>My great idea</a>
						</td>
						<td>Idea</td>
						<td>This ideas is all about reducing data load for field workers</td>
						<td>Neil Walsh</td>
						<td>21 July 2019 16:46</td>
						<td>
							<select class="dt_submittedApprovalSelect" style="width: 100%;">
								<option>Proposed</option>
								<option>Approved</option>
								<option>Rejected</option>
							</select>
						</td>
						<td>
							<button type="submit" class="btn btn-sm btn-default">Update</button>
						</td>
					</tr>-->
				</tbody>
				<tfoot>
					<tr>
						<th>Name</th>
						<th>Type</th>
						<th>Description</th>
						<th>Submission Date</th>						
						<th>Status</th>
						<th>Approver</th>
						<th/>
					</tr>
				</tfoot>
			</table>
		</div>
	</xsl:template>

</xsl:stylesheet>
