<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

	<xsl:template name="comments">
		<xsl:param name="viewSubject" select="()"/>
		
		<script>
			function closeComments() {
				$('#commentsPanel').css('margin-right','-340px');
				$('#commentsPanel').removeClass('active');
			}
			function toggleComments(){
				if ($('#commentsPanel').hasClass('active')){
					$('#commentsPanel').css('margin-right','-340px');
					$('#commentsPanel').removeClass('active');
				}
				else {
					<xsl:if test="$sysIdeationIsOn">
						closeIdeas();
					</xsl:if>
					$('#commentsPanel').css('margin-right','0');
					$('#commentsPanel').addClass('active');
				}
			}
			/*Auto resize panel during scroll*/
			$(window).scroll(function() {
				if ($(this).scrollTop() &gt; 40) {
					$('#commentsPanel').css('position','fixed');
					$('#commentsPanel').css('height','calc(100%)');
					$('#commentsPanel').css('top','0');
					$('.comments').css('max-height','calc(100% - 60px)');
				}
				if ($(this).scrollTop() &lt; 40) {
					$('#commentsPanel').css('position','fixed');
					$('#commentsPanel').css('height','calc(100% - 40px)');
					$('#commentsPanel').css('top','41px');
					$('.comments').css('max-height','calc(100% - 100px)');
				}
			});
		</script>
		<style>
			
			#commentsPanel {
			  height: calc(100% - 40px); /* 100% Full-height minus headers */
			  width: 300px; /* 0 width - change this with JavaScript */
			  margin-right: -340px;
			  position: fixed;
			  z-index: 5000;
			  bottom: 0;
			  right: 0;
			  background-color: #fff;
			  overflow-x: hidden;
			  overflow-y: hidden;
			  transition: margin-right 0.5s,height 0.5s,top 0.5s;
			  box-shadow: -1px 2px 4px 0px hsla(0, 0%, 0%, 0.5);
			}
			
			.comments{
				font-size: 0.9em;
				margin-top: -10px;
				overflow-x: hidden;
				overflow-y: auto;
				max-height: calc(100% - 100px);
				min-width: 300px;
				transition: height 0.5s;
			}
			
			.comment-wrapper{
				padding: 5px 10px;
			}
			
			.comment-author{
				font-weight: 700;
				float: left;
			}
			
			.comment-timestamp{
				font-weight: 300;
				float: left;
				margin-left: 10px;
				color: #aaa;
			}
			
			.comment-actions{
				float: right;
				display: none;
			}
			
			.comment-value{
				clear: both;
			}
			
			.reply-wrapper{
				padding: 5px 10px 5px 30px;
			}
			
			.reply-field{
				padding: 5px 10px 5px 30px;
			}
			
			.comment-field
				padding: 5px 10px 5px 30px;
			}
			
			.comment-wrapper:hover,
			.reply-wrapper:hover{
				background-color: #fff;
			}
			
			.comment-wrapper:hover > .comment-actions,
			.reply-wrapper:hover > .comment-actions{
				display: block;
			}
			
			.comment-actions:hover{
				cursor: pointer;
			}
			.comment-action-trigger > i {
				color: #333;
			}
			
			.ess-start-thread,
			.ess-add-reply-btn {
				text-align: right;
				padding-right: 5px;
				cursor: pointer;
				margin-top: 5px;
			}
			.ess-add-reply-btn:hover {
				opacity: 0.5;
			}
			
			.comment-actions > ul {
				right:0;
				left:auto;
			}
		</style>
		<script>
			var commentListTemplate;

			var essComments = {};
			
			class essThread {
			    constructor(subjectId, viewId, comment) {
			        this.subjectId = subjectId;
			        this.viewId = viewId;
			        this.createdOn = moment().toISOString();
			        this.createdOnDisplay = moment().format('DD MMM YYYY, hh:mm');
			        this.createdBy = {};
			        this.createdBy.id = essViewer.user.id;
			        this.createdBy.name = essViewer.user.firstName + ' ' + essViewer.user.lastName;
			        this.comment = comment;
			        this.replies = [];
			    }
			}
			
			class essThreadReply {
			    constructor(comment) {
			        this.createdOn = moment().toISOString();
			        this.createdOnDisplay = moment().format('DD MMM YYYY, hh:mm');
			        this.createdBy = {};
			        this.createdBy.id = essViewer.user.id;
			        this.createdBy.name = essViewer.user.firstName + ' ' + essViewer.user.lastName;
			        this.comment = comment;
			    }
			}
	
			
			function setCanEdits() {
				essComments.viewComments.forEach(function(aThrd) {
					aThrd['canEdit'] = false;
					if((aThrd.createdBy != null) &amp;&amp; (aThrd.createdBy.id == essViewer.user.id)) {
						aThrd['canEdit'] = true;
					}
					let thisReplies = aThrd.replies;
					if(thisReplies != null) {
						thisReplies.forEach(function(aRply) {
							aRply['canEdit'] = false;
							if((aRply.createdBy != null) &amp;&amp; (aRply.createdBy.id == essViewer.user.id)) {
								aRply['canEdit'] = true;
							}
						});
					}				
				});
			
			}
			
			
			function essDefineCommentsEventListeners() {
     
	            //listener for the delete thread button
	            $('.ess-delete-thread-btn').on('click', function () {
	                let threadId = $(this).attr('ess-thread-id');
					let thisThread = essComments.viewComments.find(function(aThrd) {
						return (aThrd._id != null) &amp;&amp; (aThrd._id.$oid == threadId);
					});
					
					if(thisThread != null) {
						deleteThread(thisThread);
						
						<!--let delIndex = essComments.viewComments.indexOf(thisThread);
						if(delIndex >= 0) {
							essComments.viewComments.splice(delIndex, 1);
						}
						initCommentJS();-->
					}                
	            });
	            
	            
	            //listener for the add reply button
	            $('.ess-add-reply-btn').on('click', function () {
	                let threadId = $(this).attr('ess-thread-id');
					let thisThread = essComments.viewComments.find(function(aThrd) {
						return (aThrd._id != null) &amp;&amp; (aThrd._id.$oid == threadId);
					});
					let replyInput = $('.ess-comment-reply-input[ess-thread-id="' + threadId + '"]');
					
	                if((replyInput != null) &amp;&amp; (thisThread != null)) {
	                
	                	let replyComment = replyInput.val();
	                
	                	if((replyComment != null) &amp;&amp; (replyComment.length > 0)) {
		                	let newReply = new essThreadReply(replyComment);
		                	thisThread.replies.push(newReply);
							//initCommentJS();				
							updateThread(thisThread);
						}
	                }
	                
	            });
	            
	            
	            //listener for the reply thread button
	            $('.ess-delete-reply-btn').on('click', function () {
	                let threadId = $(this).attr('ess-thread-id');
	                let replyIdx = $(this).attr('ess-reply-index');
					let thisThread = essComments.viewComments.find(function(aThrd) {
						return (aThrd._id != null) &amp;&amp; (aThrd._id.$oid == threadId);
					});
					
	                if((replyIdx != null) &amp;&amp; (thisThread != null)) {
	                	if((replyIdx >= 0) &amp;&amp; (thisThread.replies != null)) {
	                		thisThread.replies.splice(replyIdx, 1);
	                		updateThread(thisThread);
	                		//initCommentJS();
	                	}
	                }
	                
	            });
			}
					
			function initCommentJS(){
				
    			//Retrieve the comments (if any) for the view subject and render the comments
    			var commentsForView = essComments.viewComments;
    			//sort the list of comments in reverse date order
    			commentsForView.sort(function(a, b){
    				if (b.createdOn &lt; a.createdOn) {return -1;}
				  	if (a.createdOn > b.createdOn) {return 1;}
				  	return 0;
    			});
    			setCanEdits();
    			$('#ess-new-thread-input').val('');
    			//Set the comments count in the header badge
    			if(commentsForView != null) {
	    			$('#comments-badge').html(commentsForView.length);
	    			
	    			//sort them in reverse date order (most recent first) and pass to the handlebars
	    			$('#comments-list').html(commentListTemplate(commentsForView)).promise().done(function(){
							
						//Add the listener for the Popover for actions elipse on a comment						
						essDefineCommentsEventListeners();
					});
				
				}
			};
			
			
			//load the latest comments for the view subject or the view
			function loadViewSubjectComments() {
				if((essComments.viewSubjectId != null) &amp;&amp; (essComments.viewSubjectId.length > 0)) {
					essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'view-subjects', 'view-subject-comments', 'subjectId', essComments.viewSubjectId, 'View Comment')
					.then(function (response) {
						essComments.viewComments = response['instances'];
						initCommentJS();
				    }). catch (function (error) {
				        console.log('Error loading comments: ' + error.message);
				    });	
				} else {
					essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'view-subjects', 'view-subject-comments', 'viewId', essViewer.currentXSL, 'View Comment')
					.then(function (response) {
						essComments.viewComments = response['instances'];
						initCommentJS();
				    }). catch (function (error) {
				        console.log('Error loading comments: ' + error.message);
				    });				
				}
			}
			
			function startThread(comment) {				
				let newThread = new essThread(essComments.viewSubjectId, essViewer.currentXSL, comment);
				essPromise_createNoSQLElement(essEssentialReferenceApiUri, newThread, 'view-subject-comments', 'Thread')
				.then(function (response) {
					let savedThread = response;
					essComments.viewComments.unshift(savedThread);
					$('#ess-new-thread-container').slideToggle();
					initCommentJS();
			    })
			}
			
			
			function updateThread(updatedThread) {
				if((updatedThread != null)) {
					let threadId = updatedThread['_id']['$oid'];
					essPromise_replaceNoSQLElement(essEssentialReferenceApiUri, 'view-subject-comments', updatedThread, threadId, 'Thread')
					.then(function (response) {
						initCommentJS();
				    }). catch (function (error) {
				        console.log('Error updating the thread: ' + error.message);
				    });	
				}
			}
			
			
			function deleteThread(threadToDelete) {
				if((threadToDelete != null)) {
					essPromise_deleteNoSQLElement(essEssentialRefBatchApiUri, 'view-subject-comments', threadToDelete._id.$oid, 'Thread')
					.then(function (response) {
						let delIndex = essComments.viewComments.indexOf(threadToDelete);
						if(delIndex >= 0) {
							essComments.viewComments.splice(delIndex, 1);
						}
						initCommentJS();
				    }). catch (function (error) {
				        console.log('Error updating the thread: ' + error.message);
				    });	
				}
			}
			
			
			function getParameterByName(paramName) {
			    var urlParams = new URLSearchParams(window.location.search);
			    if(urlParams.has(paramName)) {
			        return urlParams.get(paramName);
			    } else {
			        return null;
			    }
			}
			
			
			$(document).ready(function(){
				essComments.viewSubjectId = getParameterByName('PMA');
				loadViewSubjectComments();
				//essComments.viewComments = testAPIComments['instances'];
				
				//compile the handlebars comments template
				var commentListFragment = $("#ess-comments-template").html();
    			commentListTemplate = Handlebars.compile(commentListFragment);
    			
    			$('#ess-new-thread-toggle-btn').on('click', function (e) {
					//console.log('Clicked on new Thread button');
					$('#ess-new-thread-container').slideToggle();
				});
				
				//listener for the add thread button
	            $('#ess-start-thread-btn').on('click', function () {
	                let threadComment = $('#ess-new-thread-input').val();	 
	                if((threadComment != null) &amp;&amp; (threadComment.length > 0)) {
	                	<!--let newThread = new essThread(essComments.viewSubjectId, '', threadComment);
	                	essComments.viewComments.unshift(newThread);
						initCommentJS();-->
						
						startThread(threadComment);
	                }
	            });	
				//initCommentJS();		
			});
		</script>
		
		
		<!-- Handlebars template to render a list of comment threads -->
		<script id="ess-comments-template" type="text/x-handlebars-template">
			{{#each this}}
				<div class="comment-wrapper">
					<div class="comment-author">{{createdBy.name}}</div>
					<div class="comment-timestamp">{{createdOnDisplay}}</div>
					{{#if canEdit}}
						<div class="comment-actions dropdown">
							<a class="comment-action-trigger dropdown-toggle" data-toggle="dropdown">
								<i class="fa fa-ellipsis-h"/>
							</a>
							<ul class="dropdown-menu">
								<!--<li class="ess-like-thread-btn" title="Like Comment">
									<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
									<a href="#"><i class="fa fa-thumbs-up right-5"/>Like</a>
								</li>
								<li class="ess-dislike-thread-btn" title="Disike Comment">
									<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
									<a href="#"><i class="fa fa-thumbs-down right-5"/>Dislike</a>
								</li>
								<li class="ess-edit-thread-btn" title="Edit Comment">
									<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
									<a href="#"><i class="fa fa-edit right-5"/>Edit</a>
								</li>-->
								<li class="ess-delete-thread-btn" title="Delete Comment">
									<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
									<a href="#"><i class="fa fa-trash right-5"/>Delete</a>
								</li>
							</ul>
						</div>
					{{/if}}
					<div class="comment-value">
						<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
						{{comment}}
					</div>
				</div>
				{{#each replies}}
					<div class="reply-wrapper">
						<div class="comment-author">{{createdBy.name}}</div>
						<div class="comment-timestamp">{{createdOnDisplay}}</div>
						{{#if canEdit}}
							<div class="comment-actions dropdown">
								<a class="comment-action-trigger  dropdown-toggle" data-toggle="dropdown">
									<i class="fa fa-ellipsis-h"/>
								</a>
								<ul class="dropdown-menu">
									<!--<li class="ess-like-comment-btn" title="Like Comment">
										<xsl:attribute name="ess-thread-id">{{../_id.$oid}}</xsl:attribute>
										<xsl:attribute name="ess-reply-index">{{@index}}</xsl:attribute>
										<a href="#"><i class="fa fa-thumbs-up right-5"/>Like</a>
									</li>
									<li class="ess-dislike-comment-btn" title="Disike Comment">
										<xsl:attribute name="ess-thread-id">{{../_id.$oid}}</xsl:attribute>
										<xsl:attribute name="ess-reply-index">{{@index}}</xsl:attribute>
										<a href="#"><i class="fa fa-thumbs-down right-5"/>Dislike</a>
									</li>
									<li class="ess-edit-comment-btn" title="Edit Comment">
										<xsl:attribute name="ess-thread-id">{{../_id.$oid}}</xsl:attribute>
										<xsl:attribute name="ess-reply-index">{{@index}}</xsl:attribute>
										<a href="#"><i class="fa fa-edit right-5"/>Edit</a>
									</li>-->
									<li class="ess-delete-reply-btn" title="Delete Comment">
										<xsl:attribute name="ess-thread-id">{{../_id.$oid}}</xsl:attribute>
										<xsl:attribute name="ess-reply-index">{{@index}}</xsl:attribute>
										<a href="#"><i class="fa fa-trash right-5"/>Delete</a>
									</li>
								</ul>
								
							</div>
						{{/if}}
						<div class="comment-value">
							<xsl:attribute name="eas-id">{{_id.$oid}}</xsl:attribute>
							{{comment}}
						</div>
					</div>
				{{/each}}
				<div class="reply-field">
					<input class="ess-comment-reply-input form-control input-sm" type="text" placeholder="Reply...">
						<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
					</input>
					<div class="ess-add-reply-btn" title="Add Reply">
						<xsl:attribute name="ess-thread-id">{{_id.$oid}}</xsl:attribute>
						<i class="fa fa-paper-plane"/>
					</div>
				</div>
				<hr class="tight"/>
			{{/each}}
		</script>
		
		<div id="commentsPanel">
			<div class="largePadding">
				<span class="pull-right" onclick="closeComments()">
					<i class="fa fa-times"/>
				</span>
				<div class="xlarge text-primary">Comments</div>
				<a id="ess-new-thread-toggle-btn" class="top-5 small">
					<i class="fa fa-plus-circle right-5"/>
					<span>New Thread</span>
				</a>
				<div id="ess-new-thread-container" class="comment-field hiddenDiv">
					<input id="ess-new-thread-input" class="ess-comment-reply-input form-control input-sm" type="text"/>				
					<div id="ess-start-thread-btn" class="ess-start-thread" title="Start Thread">
						<i class="fa fa-paper-plane"/>
					</div>
				</div>
				<hr class="tight"/>
			</div>
			<div id="comments-list" class="comments"/>			
		</div>
	</xsl:template>

</xsl:stylesheet>
