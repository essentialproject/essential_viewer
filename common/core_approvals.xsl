<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="core_utilities.xsl"/>

	<xsl:variable name="contenApprovalsAPIs" select="/node()/simple_instance[own_slot_value[slot_reference = 'name']/value = ('System: Content Approvals Summary', 'System: Content Approvals Detail')]"/>
	<xsl:variable name="contenApprovalsSummaryAPI" select="$contenApprovalsAPIs[own_slot_value[slot_reference = 'name']/value = 'System: Content Approvals Summary']"/>
	<xsl:variable name="contenApprovalsDetailAPI" select="$contenApprovalsAPIs[own_slot_value[slot_reference = 'name']/value = 'System: Content Approvals Detail']"/>

	<xsl:template name="approvalBar">
		<xsl:param name="viewSubject" select="()"/>
		<xsl:param name="theUserId"/>
		<xsl:param name="theUserIsApprover"/>
		
		<xsl:variable name="userIdParam">essuser=jason.powell@e-asolutions.com</xsl:variable>
		
		<xsl:variable name="approvalsSummaryAPIURL">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="$contenApprovalsSummaryAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				<xsl:with-param name="theUserParams" select="$userIdParam"/>
			</xsl:call-template>
		</xsl:variable>
		
		<style type="text/css">
			.stamp {
			  	<!--transform: rotate(2deg);-->
				color: #555;
				font-size: 1.1rem;
				font-weight: 700;
				border: 0.25rem solid #555;
				display: inline-block;
				padding: 0.25rem 1rem;
				text-transform: uppercase;
				border-radius: 0.75rem;
				font-family: "Courier New", Courier, monospace;
				-webkit-mask-image: url('editors/assets/images/grunge.png');
			  	-webkit-mask-size: 944px 604px;
			  	mix-blend-mode: multiply;
			}
			
			.SYS_CONTENT_PROPOSED {
				
			}
			
			.SYS_CONTENT_CHANGES_REQUIRED {
				
			}
			
			.SYS_CONTENT_IN_DRAFT {
				color: #C4C4C4;
				border: 1rem double #C4C4C4;
				<!--transform: rotate(-5deg);-->
			  	<!--font-size: 1rem;-->
			  	border-radius: 0;
			    padding: 0.5rem;
			} 
			
			.SYS_CONTENT_REJECTED {
			  color: #D23;
			  border: 0.5rem double #D23;
			  <!--transform: rotate(3deg);-->
			  -webkit-mask-position: 2rem 3rem; 
			}
			
			.SYS_CONTENT_APPROVED {
				color: #0A9928;
				border: 0.5rem solid #0A9928;
				-webkit-mask-position: 13rem 6rem;
				<!--transform: rotate(-2deg);-->
				border-radius: 0;
			}
			
			
			.approvalBarRow {
				border-bottom: 1px solid #ccc;
			}
			.approvalsBarWrapper{
				width: 100%;
				height: auto;
				padding: 5px 0;
				display: flex;
				align-items: center;
			}
			.approvalRationale {
				width: calc(100vw - 800px);
			}
		</style>
		<script>
			var essApprovalsSummary = {};
			var essApprovalsDetail = {};
			var essApprovalStatii =[];
			const ess_PROPOSE = 'propose';
			const ess_APPROVE = 'approve';
			const ess_REJECT = 'reject';
			const ess_APPROVAL_STATII = {
				'draft': 'SYS_CONTENT_IN_DRAFT',
				'approve': 'SYS_CONTENT_APPROVED',
				'reject': 'SYS_CONTENT_REJECTED',
				'propose': 'SYS_CONTENT_PROPOSED'
			}
			
			var pageSubjectId;
			
			class essApprovalDecision {
			    constructor(resource) {
			        this.id = resource.id;
			        this.meta = {};
			        this.meta.lastModifiedOn = moment().toISOString();
			    }
			}
			
			class essApprovalDecisionComment {
			    constructor(resource, decision, comment, contextResource) {
			        this.subjectId = resource.id;
			        if(resource.meta.createdBy != null) {
			        	this.authorId = resource.meta.createdBy.id;
			        }
			        if(contextResource != null) {
			        	this.contextId = contextResource.id
			        }
			        this.decision = ess_APPROVAL_STATII[decision];
			        if((resource.meta != null) &amp;&amp; (resource.meta.anchorClass != null)) {
			        	this.subjectClass = resource.meta.anchorClass;
			        }
			        this.decisionOn = moment().toISOString();
			        this.decisionOnDisplay = moment().format('DD MMM YYYY, hh:mm');
			        this.decisionBy = {};
			        this.decisionBy.id = essViewer.user.id;
			        this.decisionBy.name = essViewer.user.firstName + ' ' + essViewer.user.lastName;
			        this.comment = comment;
			    }
			}
			
			function essGetContentStatusStyle(aResource) {
				let resStyle = 'stamp';
				if((aResource.meta != null) &amp;&amp; (aResource.meta.contentStatus != null)) {
					resStyle = resStyle + ' ' + aResource.meta.contentStatus.name;
				}
				return resStyle;
			}
	
			
			//function to approve a single resource
			function essApproveResource(aResource, comment, contextResource, decisionCallback) {
				let decision = ess_APPROVE;
				let decisionPromises = [];
				let decisionObj = new essApprovalDecision(aResource);
				let decisionURL = 'content-approvals/' + aResource.id + '/' + decision;				
				decisionPromises.push(essPromise_createAPIElement(essEssentialCoreApiUri, decisionObj, decisionURL, 'Approval Decision'));
				if((comment != null) &amp;&amp; (comment.length > 0)) {
					let decisionComment = new essApprovalDecisionComment(aResource, decision, comment, contextResource);
					decisionPromises.push(essPromise_createNoSQLElement(essEssentialReferenceApiUri, decisionComment, 'approval-decision-comments', 'Approval Decision Comment'));
				}			
				Promise.all(decisionPromises)
				.then(function (responses) {
					aResource['decisionComment'] = comment;
					aResource.meta = responses[0]['meta'];
					if(decisionCallback != null) {
						decisionCallback(responses[0]);
					}
				});
			}
			
			
			//function to reject a single resource
			function essRejectResource(aResource, comment, contextResource, decisionCallback) {
				let decision = ess_REJECT;
				let decisionPromises = [];
				let decisionObj = new essApprovalDecision(aResource);
				let decisionURL = 'content-approvals/' + aResource.id + '/' + decision;				
				decisionPromises.push(essPromise_createAPIElement(essEssentialCoreApiUri, decisionObj, decisionURL, 'Approval Decision'));
				if((comment != null) &amp;&amp; (comment.length > 0)) {
					let decisionComment = new essApprovalDecisionComment(aResource, decision, comment, contextResource);
					decisionPromises.push(essPromise_createNoSQLElement(essEssentialReferenceApiUri, decisionComment, 'approval-decision-comments', 'Approval Decision Comment'));
				}			
				Promise.all(decisionPromises)
				.then(function (responses) {
					aResource.meta = responses[0]['meta'];
					aResource['decisionComment'] = comment;
					if(decisionCallback != null) {
						decisionCallback(responses[0]);
					}
				});
			}
			
			
			//function to reject a list of resources at the same time with the same comment
			function essRejectResources(resources, comment, contextResource, decisionCallback) {
				let decision = ess_REJECT;
				let decisionPromises = [];
				
				//create the list of promises for rejecting all of the resources
				resources.forEach(function(aResource) {
					let decisionObj = new essApprovalDecision(aResource);
					let decisionURL = 'content-approvals/' + aResource.id + '/' + decision;				
					decisionPromises.push(essPromise_createAPIElement(essEssentialCoreApiUri, decisionObj, decisionURL, 'Approval Decision'));
					if((comment != null) &amp;&amp; (comment.length > 0)) {
						let decisionComment = new essApprovalDecisionComment(aResource, decision, comment, contextResource);
						decisionPromises.push(essPromise_createNoSQLElement(essEssentialReferenceApiUri, decisionComment, 'approval-decision-comments', 'Approval Decision Comment'));
					}
				});
										
				Promise.all(decisionPromises)
				.then(function (responses) {
					for (i = 0; i &lt; resources.length; i++) { 
						origRes = resources[i-1];
						aResp = responses[i * 2];
						if((origRes != null) &amp;&amp; (aResp != null)) {
							origRes.meta = aResp.meta;
							origRes['decisionComment'] = comment;
						}
					}
					if(decisionCallback != null) {
						decisionCallback(responses);
					}
				});
			}
			
			
			function setPendingApprovalsCount(summaryObj) {
				let apprSummURL = 'content-approvals/' + essViewer.user.id + '/summary';
				essPromise_getAPIElements(essEssentialCoreApiUri, apprSummURL, 'Content Approval Summary')
					.then(function (response) {
						//...then, update the pending approvals count badge					
						if(response != null) {
							let thisApprContent = response.approvalContent;
							let myApprContent = thisApprContent.filter(function(anAppr) {
								return essViewer.user.approvalClasses.includes(anAppr.meta.anchorClass);
							});
							summaryObj.approvalCount = myApprContent.length;
							summaryObj.approvalContentIds = myApprContent.map(function(anAppr) {
								return anAppr.id;
							});
							$('#approvals-badge').text(summaryObj.approvalCount);
							<!--if((pageSubjectId != null) &amp;&amp; (pageSubjectId.length > 0) &amp;&amp; (essApprovalsSummary != null) &amp;&amp; (essApprovalsSummary.approvalContentIds.includes(pageSubjectId))) {
								$('#subject-approval-bar').show();
							}-->
						}
					})
					.catch (function (error) {
						console.log('Error loading approvals summary data: ' + error.message);
					});		
			}
			
			function updateApprovalCount(contentCount) {
				$('#approvals-badge').text(contentCount);
			}
			
			function setApprovalsDetail() {
				promise_getViewerAPIDataSet('<xsl:value-of select="$approvalsSummaryAPIURL"/>')
					.then(function (response) {
						//...then, show the modal
						approvalsSummary = response;
					})
					.catch (function (error) {
						console.log('Error loading approvals detail data: ' + error.message);
					});		
			}
			
			
			$(document).ready(function(){		
			
				//Init Select2 library
				$('.approvalSelect').select2({theme: "bootstrap"});
		
				<xsl:if test="not($viewSubject/type = ('Portal','Report'))">
					pageSubjectId = "<xsl:value-of select="$viewSubject/name"/>";
				</xsl:if>
				
				if(essViewer.user.approvalClasses.length > 0) {
					setPendingApprovalsCount(essApprovalsSummary);
				} else {
					$('#approvals-badge').addClass('hiddenDiv');
				}
				
			});
		</script>
		<div id="subject-approval-bar" class="row bg-warning approvalBarRow hiddenDiv">
			<div class="col-xs-12">
				<div class="approvalsBarWrapper">
					<span class="impact text-warning right-15">This content is awaiting approval</span>
					<xsl:if test="$theUserIsApprover">
						<span class="right-15">
							<select class="approvalSelect" style="width: 200px;">
								<option>Select Approve or Reject</option>
								<option>Approve</option>
								<option>Reject</option>
							</select>
						</span>
						<span class="right-15">
							<input type="text" class="approvalRationale" placeholder="Comments (required for rejection)"/>
						</span>
						<span>
							<button type="submit" class="btn btn-default btn-sm" title="Submit Approval">Submit</button>
						</span>
					</xsl:if>
				</div>
			</div>
		</div>
		
		
	</xsl:template>

</xsl:stylesheet>
