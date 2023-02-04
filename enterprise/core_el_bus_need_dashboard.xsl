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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	<!-- VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="needEditor" select="/node()/simple_instance[(type = ('Editor', 'Simple_Editor')) and (own_slot_value[slot_reference = 'name']/value = 'Core: Idea Editor')]"/>
	
	<xsl:variable name="needEditorHref">
		<xsl:call-template name="RenderEditorLinkHref">
			<xsl:with-param name="theInstanceId" select="$param1"/>
			<xsl:with-param name="theEditor" select="$needEditor"/>
		</xsl:call-template>
	</xsl:variable>

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
				<title>Idea Dashboard</title>
				<link rel="stylesheet" href="js/star-rating/star-rating.min.css"/>
			</head>
			<body>
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid" style="overflow-x: hidden;">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<!--<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>-->
									<span class="text-darkgrey">Idea Dashboard: </span>
									<span id="need-dash-subject" class="text-primary"/>
									<a target="_blank">
										<xsl:attribute name="href" select="$needEditorHref"/>
										<span id="idea-editor-link" class="btn btn-default btn-xs left-10 hiddenDiv"><i class="fa fa-pencil right-5"/>Edit</span>
									</a>
								</h1>
								
							</div>
						</div>
						<style>							
							.idea-wrapper,#need-details-panel {font-size: 90%;}
							
							.ideas-scroller{
								width: 100%;
								overflow-x: auto;
								display: flex;
								flex-wrap: nowrap;
								-webkit-overflow-scrolling: touch;
							}
							
							.idea-wrapper{
								width: 350px;
								flex: 0 0 auto;
								margin-right: 15px;
								min-height: 700px;
							}
							
							#trend-impl-table > tbody > tr > td{
								vertical-align: middle;
							}
							
							.idea-change-wrapper{
								border: 1px solid #ccc;
								background-color: #fcfcfc;
								box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
								border-radius: 4px;
								padding: 5px;
								margin-bottom: 10px;								
							}
							
							.idea-wrapper > .panel > .panel-body {
								max-height: 350px;
								overflow-x: hidden;
								overflow-y: auto;
							}
							
							.panel > .panel-heading{
								position: relative;
							}
							
							.panel-heading > i.fa-lightbulb-o,.panel-heading > i.fa-check-circle {
								position: absolute;
								right: 5px;
								top: 5px;
								font-size: 150%;
							}
							
							#clockdiv{
								color: #fff;
								display: flex;
								font-weight: 700;
								text-align: center;
								font-size: 12px;
								margin-right: 10px;
							}
							
							#clockdiv > div{
								padding: 4px;
								border-radius: 4px;
								background: #ccc;
								margin-right: 5px;
								width: 50px;
							}
							
							#clockdiv div > span{
								border-radius: 4px;
								background: #666;
								display: flex;
								justify-content: center;
							}
							
							.rating-star {
								min-width: 13px;
							}
							
							.smalltext{
								padding-top: 2px;
								font-size: 10px;
							}
							
							#outcomes-nav > li > a{
								padding: 5px 15px;
								color: #333;
								border-radius: 0px;
								border: 1px solid #eee;
							}
							#outcomes-nav > li.active > a{
								color: #fff;
								background-color: #999
							}
							.idea-wrapper > .panel > .panel-body {
								min-height: 200px;
							}
							.need-dash-approval-container {
								border-top: 1px solid #aaa;
							}
							.approval-comment-scroller {
								height: 200px;
								max-height: 200px;
								overflow-x: hidden;
								overflow-y: auto;
							}
						</style>

						<div class="col-xs-5">
							<div class="row">
								<div class="col-xs-6">
									<h2 class="text-primary strong"><i class="fa fa-lightbulb-o right-10"/>Idea</h2>
								</div>
							</div>
							<div id="need-details-panel" class="panel panel-default top-10">
								<div class="panel-heading">
									<i class="fa fa-lightbulb-o"/>
									<div id="need-dash-name" class="large impact"></div>
									<div id="need-dash-desc" class="large"></div>							
									<div class="row">
										<div class="col-xs-6">
											<span class="fontBold right-10">Owner:</span><span id="need-dash-author"/>
										</div>
										<div class="col-xs-6">
											<span class="right-10 need-submit-by-clock hiddenDiv"><strong>Submit Options By:</strong></span><span id="need-submit-date"/>
										</div>
									</div>
									<div class="row top-10">
										<div class="col-xs-6">
											<!--<div><span id="need-dash-status"/></div>-->
										</div>
										<div class="col-xs-6">
											<div class="hiddenDiv need-submit-by-clock">
												<div id="clockdiv">
													<div>
														<span class="days"></span>
														<div class="smalltext">Days</div>
													</div>
													<div>
														<span class="hours"></span>
														<div class="smalltext">Hours</div>
													</div>
													<div>
														<span class="minutes"></span>
														<div class="smalltext">Minutes</div>
													</div>
													<div>
														<span class="seconds"></span>
														<div class="smalltext">Seconds</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div id="show-plan-project-div" class="top-10 hiddenDiv">
										<button class="btn btn-success btn-block" id="show-plan-project-btn">Create Strategic Plan and Project</button>
									</div>
								</div>
								<div class="panel-body">
									<ul class="nav nav-tabs" role="tablist">
										<li role="presentation" class="active">
											<a href="#motivations" role="tab" data-toggle="tab">Motivations &amp; Rationale</a>
										</li>
										<li role="presentation">
											<a href="#scope" role="tab" data-toggle="tab">Scope &amp; Implications</a>
										</li>
										<li role="presentation">
											<a href="#outcomes" role="tab" data-toggle="tab">Target Outcomes</a>
										</li>
									</ul>

									<div class="tab-content">
										<div role="tabpanel" class="tab-pane active" id="motivations">
											<div class="row">
												<div id="need-persona-content" class="col-md-12">
													<div class="lead bottom-10">As a...</div>
													<ul id="need-persona-list" class="large"/>													
												</div>
												<div id="need-goal-content" class="col-md-12">
													<div class="lead bottom-10">I want to...</div>
													<ul id="need-goal-list" class="large"/>													
												</div>
												<div id="need-rationale-content" class="col-md-12">
													<div class="lead bottom-10">So that I can...</div>
													<ul id="need-rationale-list" class="large"/>													
												</div>
											</div>
										</div>
										<div role="tabpanel" class="tab-pane" id="scope">
											<div class="row">
												<div class="col-md-12 top-20">
													<div class="row">
														<div class="col-md-6">
															<div class="large fontBold">Geographic Scope</div>
															<div id="need-country-content">
																<ul id="need-country-list"/>
															</div>
														</div>
														<div class="col-md-6">
															<div class="large fontBold">Organisational Scope</div>
															<div id="need-org-content">
																<ul id="need-org-list"/>
															</div>
														</div>
													</div>
												</div>
												<div class="col-md-12 top-30">
													<div class="large fontBold">Strategic Trend Implications</div>
													<div id="need-impls-content">
														<table class="table" id="trend-impl-table">
															<thead>
																<tr>
																	<th class="text-purple" width="30%">Idea</th>
																	<th width="3%">&#160;</th>
																	<th width="30%">Addresses Implication</th>
																	<th width="3%">&#160;</th>
																	<th width="30%">Of Trend</th>
																</tr>
															</thead>
															<tbody id="need-motivating-implication-tble"/>																						
														</table>
													</div>
												</div>
											</div>
										</div>
										<div role="tabpanel" class="tab-pane" id="outcomes">
											<div class="top-15">
												<!-- Nav tabs -->
												<ul class="nav nav-pills nav-justified" id="outcomes-nav">
													<li class="active"><a href="#need-cost" data-toggle="tab">Costs</a></li>
													<li><a href="#need-revenue" data-toggle="tab">Revenues</a></li>
													<li><a href="#need-kpi" data-toggle="tab">KPIs</a></li>
												</ul>
												<!-- Tab panes -->
												<div class="tab-content">
													<div class="tab-pane active" id="need-cost">
														<div id="need-cost-chart-container" class="need-target-chart simple-scroller">
															<canvas id="need-cost-chart"/>
														</div>
													</div>
													<div class="tab-pane" id="need-revenue">
														<div id="need-revenue-chart-container" class="need-target-chart simple-scroller">
															<canvas id="need-revenue-chart"/>
														</div>
													</div>
													<div class="tab-pane" id="need-kpi">
														<div id="need-kpi-chart-container" class="need-target-chart simple-scroller">
															<canvas id="need-kpi-chart"/>
														</div>
													</div>
												</div>
												
												<div class="clearfix"></div>
											</div>
										</div>
									</div>
								</div>
							</div>

						</div>


						<div class="col-xs-7">
							<h2 class="text-primary strong"><i class="fa fa-check-circle right-10"/>Proposed Options</h2>
							<div id="need-ideas-container" class="ideas-scroller">
								
							</div>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script src="js/star-rating/star-rating.min.js"/>
				
				<!-- Chart library -->
				<script src="js/chartjs/Chart.min.js"/>
					
				<!-- Handlebars template for strings -->
				<script id="need-goal-bullet-template" type="text/x-handlebars-template">
					{{#each goalStatements}}
						<li>{{this}}</li>
					{{/each}}
				</script>
				
				<script id="need-rationale-bullet-template" type="text/x-handlebars-template">
					{{#each rationaleStatements}}
						<li>{{this}}</li>
					{{/each}}
				</script>
				
				
				<!-- Handlebars template for instances -->
				<script id="need-instance-bullet-template" type="text/x-handlebars-template">
					{{#each this}}
						<li>{{name}}</li>
					{{/each}}
				</script>
				
				<!-- Handlebars template for suggested ideas for the need -->
				<script id="need-idea-template" type="text/x-handlebars-template">
					{{#each ideas}}
						<div class="idea-wrapper">
							<div class="panel panel-default top-10">
								<div class="panel-heading">
									<i class="fa fa-check-circle"/>
									<div class="large impact">{{name}}</div>
									<div class="large">{{description}}</div>
									<div><strong>Author: </strong><span>{{meta.createdBy.id}}</span></div>
									<div class="top-10"><!--<span class="right-10"><strong>Status:</strong></span>--><span><xsl:attribute name="class">my-idea-status stamp {{meta.contentStatus.name}}</xsl:attribute><xsl:attribute name="eas-id">{{id}}</xsl:attribute>{{status.label}}</span></div>
								</div>
								<div class="panel-body">
									{{#each changes}}
										<div class="idea-change-wrapper">
											<div class="strong large">{{element.name}}</div>
											<div>
												<em>{{element.meta.typeLabel}}</em>
											</div>
											<div class="">
												<span class="strong">Proposed Change: </span>
												<span>{{change.label}}</span>
											</div>
											<div class="">
												<span class="strong">Rationale: </span>
												<span>{{rationale}}</span>
											</div>
										</div>
									{{/each}}
								</div>
								<div class="panel-footer">									
									<div class="idea-decision-container">
										<div class="row">
											<div class="col-xs-5"><strong>My Rating:</strong></div>
											<div class="col-xs-7">
												<input type="text" class="my-rating rating">
													<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
												</input>
											</div>
											<div class="col-xs-12">
												<label class="top-5">My Comment</label>
												<textarea rows="2" class="my-idea-comment form-control">
													<xsl:attribute name="placeholder"><xsl:value-of select="eas:i18n('What do you think?')"/></xsl:attribute>
													<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
												</textarea>
												<div>
													<button class="rate-idea-btn btn btn-primary btn-sm top-5" style="width: 100px;">
														<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
														Rate
													</button>
													<p class="my-rating-error textColourRed"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></p>
												</div>
											</div>
										</div>
										<div class="row top-10">
											<div class="col-xs-5"><strong>Average Rating:</strong></div>
											<div class="col-xs-7">
												<input type="text" class="av-rating rating">
													<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
												</input>
											</div>
										</div>
										<div class="top-10">
											{{#if ratings.length}}
												<span>{{ratings.length}}</span><span> Ratings</span>
												<a class="pull-right option-comments-review" data-toggle="popover"><i class="fa fa-comment right-5"/>Review Comments</a>
												<div class="popover" style="width: 500px;">
													<div class="approval-comment-scroller">								
															{{#each ratings}}
																<div class="row small bottom-10">
																	<div class="col-xs-6"><strong>{{createdBy.name}}</strong></div>
																	<div class="col-xs-6">
																		{{{renderRating rating}}}
																	</div>
																	<div class="col-xs-12">
																		{{comment}}
																	</div>
																</div>
															{{/each}}								
													</div>
												</div>
											{{else}}
												<span><em><xsl:value-of select="eas:i18n('This option is yet to be rated')"/></em></span>
											{{/if}}
										</div>
										<div class="need-dash-approval-container top-10">
											<div class="xlarge impact top-10">Approval</div>
											<!--<label>Approval:</label>
											<select class="select2 idea-approval-select" style="width:100%;">
												<option>Draft</option>
												<option>Approve</option>
												<option>Reject</option>
											</select>-->
											<label class="top-5">Comments</label>
											<textarea rows="2" class="idea-decision-comment form-control" placeholder="Comments (required for rejection)">
												<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
											</textarea>
											<div class="idea-decision-btns top-10">
												<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
												<button class="accept-idea-btn btn btn-success btn-sm pull-left right-10" style="width: 100px;"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:value-of select="eas:i18n('Approve')"/></button>
												<button class="reject-idea-btn btn btn-danger btn-sm btn" style="width: 100px;"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:value-of select="eas:i18n('Reject')"/></button>
											</div>
											<span class="idea-decision-error textColourRed"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
										</div>
									</div>
								</div>
							</div>
						</div>
					{{/each}}
				</script>
				
				
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
				
				<!-- Handlebars template for the implications that motivate the need -->
				<script id="ess-motivating-impl-template" type="text/x-handlebars-template">
					{{#if implications.length}}
						{{#each implications}} 
							{{#if @first}}
								<tr>
									<td class="text-purple">
										<xsl:attribute name="rowspan">{{../count}}</xsl:attribute>
										{{../name}}
									</td>
									<td>
										<xsl:attribute name="rowspan">{{../count}}</xsl:attribute>
										<i class="text-purple fa fa-caret-right fa-2x"/>
									</td>
									<td>{{name}}</td>
									<td>
										<i class="fa fa-caret-right fa-2x"/>
									</td>
									<td>{{implicationForTrend.name}}</td>
								</tr>
							{{else}}
								<tr>
									<td>{{name}}</td>
									<td>
										<i class="fa fa-caret-right fa-2x"/>
									</td>
									<td>{{implicationForTrend.name}}</td>
								</tr>
							{{/if}}
						{{/each}}
					{{else}}
						<span class="top-20"><em>No related strategic trends</em></span>
					{{/if}}
				</script>
				
				<!-- Div for the ERROR modal -->
				<div class="modal fade" id="need-confirm-modal" tabindex="-1" role="dialog" aria-labelledby="need-confirm-modal-label" data-backdrop="static" data-keyboard="true">
					<div class="modal-dialog">
						<div class="modal-content" id="need-confirm-modal-content">
							<div class="modal-header">
								<p class="modal-title large" id="need-confirm-modal-label"><i class="fa fa-info-circle icon-section textColourGreen right-5"/><strong><span class="text-darkgrey">Idea Option Approved</span></strong></p>
							</div>
							<div class="modal-body">
								<p>The option has been approved and associated Strategic Plans and Projects have been created</p>
							</div>
							<div class="modal-footer">
								<button type="button" id="need-confirm-modal-close-btn" class="btn btn-success">
									<xsl:value-of select="eas:i18n('Close')"/>
								</button>
							</div>
						</div>
					</div>
				</div>
				
				<!-- Div for the ERROR modal -->
				<div class="modal fade" id="create-plan-project-modal" tabindex="-1" role="dialog" aria-labelledby="plan-project-modal-label" data-backdrop="static" data-keyboard="true">
					<div class="modal-dialog">
						<div class="modal-content" id="plan-project-modal-content">
							<div class="modal-header">
								<div class="modal-title xlarge fontLight">Create Plan and Project</div>
							</div>
							<div class="modal-body">
								<div class="row">
								<div class="col-md-12">
									<div class="alert alert-success">Would you like to create a Strategic Plan and a Project for this idea in the current repository?</div>
								</div>
								<div class="col-md-12">
									<input id="ess-create-plan-checkbox" type="checkbox" class="pull-left" checked="checked" disabled="disabled"/>
									<label for="ess-plan-name" class="fontBold">Strategic Plan Name</label>
									<input type="text" id="ess-plan-name" class="form-control bottom-10" placeholder="Enter a name"/>
								</div>
								<div class="col-md-12">
									<input id="ess-create-project-checkbox" type="checkbox" class="pull-left" checked="checked"/>
									<label for="ess-project-name" class="fontBold">Project Name</label>
									<input type="text" id="ess-project-name" class="form-control bottom-10" placeholder="Enter a name"/>
								</div>
								<div class="col-md-12">
									<span id="ess-create-plan-error" class="textColourRed"/>
								</div>								
								<!--<p class="large"><strong>Strategic Plan: </strong><span id="ess-plan-name"/></p>
								<p class="large"><strong>Project: </strong><span id="ess-project-name"/></p>-->
								</div>
							</div>
							<div class="modal-footer">
								<div class="pull-right">
									<button type="button" id="essCreatePlanLaterBtn" class="btn btn-danger right-10">
										<xsl:value-of select="eas:i18n('Later')"/>
									</button>
									<button type="button" id="essCreatePlanCreateBtn" class="btn btn-success">
										<xsl:value-of select="eas:i18n('Create')"/>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				
				<script type="text/javascript">
					class StrategicPlan {
					    constructor(planName, anIdea, plannedChanges, aProject) {
					        this.name = planName;
					        this.description = anIdea.description;
					        this.plannedChanges = plannedChanges;
					        if(aProject != null) {
					        	this.supportingProjects = [aProject];
					       	}
					        this.meta = {};
					        this.meta.createdOn = moment().toISOString();
					        this.meta.createdBy = {};
					        this.meta.createdBy.id = essViewer.user.id;
					    }
					}
					
					class Project {
					    constructor(name, description) {
					        this.name = name;
					        this.description = description;
					        this.meta = {};
					        this.meta.createdOn = moment().toISOString();
					        this.meta.createdBy = {};
					        this.meta.createdBy.id = essViewer.user.id;
					    }
					}
					
					class PlannedChange {
					    constructor(anIdeaChange,project) {
					        this.element = anIdeaChange.element;
					        this.rationale = anIdeaChange.rationale;
					        this.change = anIdeaChange.change;
					        this.project = project;
					        this.meta = {};
					        this.meta.createdOn = moment().toISOString();
					        this.meta.createdBy = {};
					        this.meta.createdBy.id = essViewer.user.id;
					    }
					}
					
					
					function getTimeRemaining(endtime) {
					  var t = Date.parse(endtime) - Date.parse(new Date());
					  var seconds = Math.floor((t / 1000) % 60);
					  var minutes = Math.floor((t / 1000 / 60) % 60);
					  var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
					  var days = Math.floor(t / (1000 * 60 * 60 * 24));
					  return {
					    'total': t,
					    'days': days,
					    'hours': hours,
					    'minutes': minutes,
					    'seconds': seconds
					  };
					}
					
					function initializeClock(id, endtime) {
					  var clock = document.getElementById(id);
					  var daysSpan = clock.querySelector('.days');
					  var hoursSpan = clock.querySelector('.hours');
					  var minutesSpan = clock.querySelector('.minutes');
					  var secondsSpan = clock.querySelector('.seconds');
					
					  function updateClock() {
					    var t = getTimeRemaining(endtime);
					
					    daysSpan.innerHTML = t.days;
					    hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
					    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
					    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);
					
					    if (t.total &lt;= 0) {
					      clearInterval(timeinterval);
					    }
					  }
					
					  updateClock();
					  var timeinterval = setInterval(updateClock, 1000);
					}
					
					
					/********************************************************
					IDEA RATING FUNCTIONS
					********************************************************/
					
					var needRatings = [];
					
					class essIdeaRating {
					    constructor(reqId, ideaId, rating, comment) {
					        this.requirementId = reqId;
					        this.ideaId = ideaId;
					        this.createdOn = moment().toISOString();
					        this.createdOnDisplay = moment().format('DD MMM YYYY, hh:mm');
					        this.createdBy = {};
					        this.createdBy.id = essViewer.user.id;
					        this.createdBy.name = essViewer.user.firstName + ' ' + essViewer.user.lastName;
					        this.comment = comment;
					        this.rating = rating;
					    }
					}
					
					//function to calculate the average rat8ings for the ideas asociated with teh current need
					function calcIdeaAvgRatings() {
						//derive and set the average ratings for each idea
						currentIdeas['ideas'].forEach(function(anIdea) {
							//get the ratings for the current Idea
							calcAvgRatingForIdea(anIdea);
						});
					}
					
					function calcAvgRatingForIdea(anIdea) {
						let thisIdeaRatings = needRatings.filter(function(aRating) {
							return aRating.ideaId == anIdea.id;
						});
						
						if((thisIdeaRatings != null) &amp;&amp; (thisIdeaRatings.length > 0)) {
							let myIdeaRating = thisIdeaRatings.find(function(aRating) {
								return aRating.createdBy.id == essViewer.user.id;
							});
							
							if(myIdeaRating != null) {
								anIdea['myRating'] = myIdeaRating;
							}							
							
							let thisIdeaRatingTotal = thisIdeaRatings.reduce(function(ratingSum, aRating) {
								return ratingSum + aRating.rating;
							}, 0);
							
							if(thisIdeaRatingTotal > 0) {
								let ratingAvg = thisIdeaRatingTotal / thisIdeaRatings.length;
								anIdea['ratings'] = thisIdeaRatings;
								anIdea['avgRating'] = +ratingAvg.toFixed(1);  //rounds to a precision of one decimal place
							}
						}			
					}
					
					//load the latest comments for the view subject
					<!--function loadNeedRatings() {
						if((currentNeed != null)) {
							essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'business-need-ratings', 'idea-ratings', 'requirementId', currentNeed.id, 'Idea Rating')
							.then(function (response) {
								needRatings = response['instances'];
								calcIdeaAvgRatings();
								//init idea ratings
						    }). catch (function (error) {
						        console.log('Error loading idea ratings: ' + error.message);
						    });	
						}
					}-->
					
					function createRating(anIdea, rating, comment) {
						let ideaId = anIdea.id;
						if((currentNeed != null) &amp;&amp; (ideaId != null)) {
							if(anIdea != null) {
								let newRating = new essIdeaRating(currentNeed.id, ideaId, rating, comment);
								essPromise_createNoSQLElement(essEssentialReferenceApiUri, newRating, 'idea-ratings', 'Idea Rating')
								.then(function (response) {
									let savedRating = response;
									needRatings.push(response);
									//update the average rating of the idea							
									calcAvgRatingForIdea(anIdea);
									refreshIdeaRatings(anIdea);
									$('.rate-idea-btn[eas-id="' + anIdea.id + '"]').html('Rate');
							    });
						    }
						}
					}
					
					
					function updateRating(anIdea, updatedRating) {
						if((updatedRating != null)) {
							let ratingId = updatedRating['_id']['$oid'];
							essPromise_replaceNoSQLElement(essEssentialReferenceApiUri, 'idea-ratings', updatedRating, ratingId, 'Idea Rating')
							.then(function (response) {
								//initCommentJS();
								calcAvgRatingForIdea(anIdea);
								refreshIdeaRatings(anIdea);
								$('.rate-idea-btn[eas-id="' + anIdea.id + '"]').html('Rate');
						    }). catch (function (error) {
						        console.log('Error updating the thread: ' + error.message);
						    });	
						}
					}
					
					/********************************************************
					TARGET OUTCOME CHART FUNCTIONS
					********************************************************/
					
					// function to initialise the costs and revenues charts
					function renderTargetOutcomeChart() {
						var chartCtx, needChartData, needChartLabels;
						
						var chartOptions = {
						  responsive: true,
						  legend: {
						    position: "top"
						  },
						  title: {
						    display: false
						  },
						  scales: {
						  	xAxes: [{
								display: true,
								ticks: {
							      	precision: 0,
							      	stepSize: 20,
							      	min: -100,
	                    			max: 100,
							        beginAtZero: true
							      }
							}],
							yAxes: [{
								type: 'category',
								barThickness: 20,
								position: 'left',
								display: true,
								ticks: {
									reverse: true
								},
								afterFit: function(scaleInstance) {
							    	scaleInstance.width = 200; // sets the width to 100px
							    }
							}]						    
						  }
						};
					
						//target cost changes chart
						if((currentNeed.targetCostChanges != null) &amp;&amp; (currentNeed.targetCostChanges.length > 0)) {
							chartCtx = $('#need-cost-chart');
							
							needChartLabels = currentNeed.targetCostChanges.map(function(aChange) {
								return aChange.costCategory.label;
							});
							
							needChartDataSet = currentNeed.targetCostChanges.map(function(aChange) {
								return Math.round(aChange.change * 100);
							});
							
							needChartData = {
							  labels: needChartLabels,
							  datasets: [
							    {
							      label: "% Change",
							      backgroundColor: "hsla(200, 80%, 90%, 1)",
							      borderColor: "hsla(200, 80%, 40%, 1)",
							      borderWidth: 1,							      
							      data: needChartDataSet
							    }
							  ]
							};
			
							new Chart(chartCtx, {
							    type: "horizontalBar",
							    data: needChartData,
							    options: chartOptions
							});
						} else {
							$('#need-cost-chart-container').html('<span class="top-20"><em>No cost changes defined</em></span>');
						}
						
						
						//target revenue changes chart
						if((currentNeed.targetRevenueChanges != null) &amp;&amp; (currentNeed.targetRevenueChanges.length > 0)) {
							chartCtx = $('#need-revenue-chart');
							
							needChartLabels = currentNeed.targetRevenueChanges.map(function(aChange) {
								return aChange.revenueCategory.label;
							});
							
							needChartDataSet = currentNeed.targetRevenueChanges.map(function(aChange) {
								return Math.round(aChange.change * 100);
							});
							
							needChartData = {
							  labels: needChartLabels,
							  datasets: [
							    {
							      label: "% Change",
							      backgroundColor: "hsla(175, 60%, 90%, 1)",
							      borderColor: "hsla(175, 60%, 40%, 1)",
							      borderWidth: 1,
							      data: needChartDataSet
							    }
							  ]
							};
			
							new Chart(chartCtx, {
							    type: "horizontalBar",
							    data: needChartData,
							    options: chartOptions
							});
						} else {
							$('#need-revenue-chart-container').html('<span class="top-20"><em>No revenue changes defined</em></span>');
						}
						
						
						//target kpi changes chart
						if((currentNeed.targetOutcomeChanges != null) &amp;&amp; (currentNeed.targetOutcomeChanges.length > 0)) {
							chartCtx = $('#need-kpi-chart');
							
							needChartLabels = currentNeed.targetOutcomeChanges.map(function(aChange) {
								return aChange.outcome.name;
							});
							
							needChartDataSet = currentNeed.targetOutcomeChanges.map(function(aChange) {
								return Math.round(aChange.change * 100);
							});
							
							needChartData = {
							  labels: needChartLabels,
							  datasets: [
							    {
							      label: "% Change",
							      backgroundColor: "hsla(320, 75%, 90%, 1)",
							      borderColor: "hsla(320, 75%, 35%, 1)",
							      borderWidth: 1,
							      data: needChartDataSet
							    }
							  ]
							};
			
							new Chart(chartCtx, {
							    type: "horizontalBar",
							    data: needChartData,
							    options: chartOptions
							});
						} else {
							$('#need-kpi-chart-container').html('<span class="top-20"><em>No KPI changes defined</em></span>');
						}
				
					}										
					
					<!--var updateIdeasAfterApproval(approvedIdea, rejectedIdeas) {
						updateIdeaDecision(approvedIdea);
						rejectedIdeas.forEach(function(anIdea) {
							updateIdeaDecision(anIdea);
						})
					
					}-->
					
					
					var createProjectFromIdea = function(thisIdea) {
						let planName = $('#ess-plan-name').val();
						if((planName == null) || (planName.length == 0)) {
							$('#ess-create-plan-error').text('The strategic plan must have a name');
							return;
						}
					
						let promiseList = [];
						
						if($('#ess-create-project-checkbox').prop('checked')) {
							let projectName = $('#ess-project-name').val();
							if((projectName == null) || (projectName.length == 0)) {
								$('#ess-create-plan-error').text('The project must have a name');
								return;
							}
							let projectDesc = thisIdea.description;
							let tempProject = new Project(projectName, projectDesc);
							promiseList.push(essPromise_createAPIElement(essEssentialCoreApiUri, tempProject, 'projects', 'Project'));
						}
						
						let projectName = 'Project: ' + thisIdea.name;
						let projectDesc = thisIdea.description;
						let tempProject = new Project(projectName, projectDesc);
						
						Promise.all(promiseList)
						//essPromise_createAPIElement(essEssentialCoreApiUri, tempProject, 'projects', 'Project')
						.then(function(responses) {
							let newProject;
							if(responses.length > 0) {
								newProject = responses[0];
							}
							let plannedChanges = [];
							var newChange;
							thisIdea.changes.forEach(function(aChg) {
								newChange = new PlannedChange(aChg, newProject);
								plannedChanges.push(newChange);
							});
							
							let tempPlan = new StrategicPlan(planName, thisIdea, plannedChanges, newProject);
							essPromise_createAPIElement(essEssentialCoreApiUri, tempPlan, 'strategic-plans', 'Strategic Plan')
							.then(function(planResponse) {
								//update the status of the current need to 'In Planning'
								let needPlanUrl = 'business-needs/' + currentNeed.id + '/plan';
								essPromise_updateAPIElement(essEssentialCoreApiUri, currentNeed, needPlanUrl, 'Idea')
									.then(function(needResponse) {
										currentNeed = needResponse;
										
										//update the status of the business need in the view
										$('#need-dash-status').text(currentNeed.status.label);
										$('#need-dash-status').attr('class', essGetContentStatusStyle(currentNeed));
										
										//remove the create plan/project button
										$('#show-plan-project-div').addClass('hiddenDiv');
										
										//hide the confirmation modal
										$('#create-plan-project-modal').modal('hide');
									})								
							})
							.catch(function (error) {
				        	    console.log('Error creating strategic plan: ' + error.message);
				            });
						})
						.catch(function (error) {
			        	    console.log('Error creating project: ' + error.message);
			            });
					
					}
					
					
					var updateNeedAfterDecision = function(aNeed) {
						if(aNeed != null) {
							let needURL = 'business-needs/' + aNeed.id;
							essPromise_getAPIElement(essEssentialCoreApiUri, needURL, 'Business Need')
								.then(function(response) {
									currentNeed = response;
									$('#need-dash-status').text(currentNeed.status.label);
									$('#need-dash-status').attr('class', essGetContentStatusStyle(currentNeed));
									
									if((approvedIdea != null) &amp;&amp; (currentNeed.status != null) &amp;&amp; (currentNeed.status.name == 'Accepted Idea Requirement')) {
										$('#show-plan-project-div').removeClass('hiddenDiv');
									}
									
									//open the modal dialog to create strategic plans and ideas
									if(approvedIdea != null) {
										$('#create-plan-project-modal').modal('show');
									}									
								});
						}
					}
					
					var updateMultiIdeaDecisions = function(someIdeas) {
						someIdeas.forEach(function (anIdea) {
							if(anIdea.id != null) {
								updateIdeaDecision(anIdea);
							}
						});
					}
					
					
					var updateIdeaDecision = function(theIdea) {
						let ideaId = theIdea.id;
						let thisIdea = currentIdeas['ideas'].find(function(anIdea) {
							return anIdea.id == ideaId;
						});	
						
						if(thisIdea != null) {
							//set my rating for the idea to read only and hide the 'rate' button
							let myRating = $('.my-rating[eas-id="' + ideaId + '"]');
							let myComment = $('.my-idea-comment[eas-id="' + ideaId + '"]');
							
							let myRatingBtn = $('.rate-idea-btn[eas-id="' + ideaId + '"]');
							myRatingBtn.hide();
	
							myRating.rating('refresh', {
							    'readonly': true
							});
							myComment.attr('readonly', true);
					
							//update the status of the idea to REJECTED
							let myStatus = $('.my-idea-status[eas-id="' + ideaId + '"]');
							if((theIdea.meta != null) &amp;&amp; (theIdea.meta.contentStatus != null)) {
								myStatus.text(theIdea.meta.contentStatus.label);
								myStatus.attr('class', essGetContentStatusStyle(theIdea));
							} else {
								myStatus.text('');
							}
							
							//if the user is an approver for ideas, remove the approve/reject buttons and make decision comment box read-only
							if(needUserCanApprove) {
								let decisionButtons = $('.idea-decision-btns[eas-id="' + ideaId + '"]');
								decisionButtons.addClass('hiddenDiv');
								let decisionComment = $('.idea-decision-comment[eas-id="' + ideaId + '"]');
								decisionComment.val(thisIdea['decisionComment']);
								decisionComment.attr('readonly', true);
							}
						}
					}
			
					
					//functiom to reject an idea
					function rejectIdea(ideaId) {
						let thisIdea = currentIdeas['ideas'].find(function(anIdea) {
							return anIdea.id == ideaId;
						});					
						
						if(thisIdea != null) {
							//approve the selected idea
							$('.reject-idea-btn[eas-id="' + ideaId + '"]').html('Updating...');
							
							let ideaDecisionCommentBox = $('.idea-decision-comment[eas-id="' + thisIdea.id + '"]');
							let decisionComment = null;
							if(ideaDecisionCommentBox != null) {
								decisionComment = ideaDecisionCommentBox.val();
								if((decisionComment != null) &amp;&amp; (decisionComment.length > 0)) {
									essRejectResource(thisIdea, decisionComment, currentNeed, updateIdeaDecision);
								} else {
									let decisionErr = $('.idea-decision-error[eas-id="' + ideaId + '"]');
									decisionErr.text('<xsl:value-of select="eas:i18n('A comment must be given for a rejected idea')"/>');
								}
							}
						}
					}
					
					
					//function to accept an idea and reject the others
					var approvedIdea;
					
					function approveIdea(ideaId) {
						let thisIdea = currentIdeas['ideas'].find(function(anIdea) {
							return anIdea.id == ideaId;
						});
						
						
						if(thisIdea != null) {
							$('.accept-idea-btn[eas-id="' + ideaId + '"]').html('Updating...');

							//approve the selected idea
							let ideaDecisionCommentBox = $('.idea-decision-comment[eas-id="' + thisIdea.id + '"]');
							let decisionComment = null;
							if(ideaDecisionCommentBox != null) {
								decisionComment = ideaDecisionCommentBox.val();
							}
							essApproveResource(thisIdea, decisionComment, currentNeed, updateIdeaDecision);
							approvedIdea = thisIdea;
							
							//reject all the other ideas for the business need
							//console.log('All Ideas Again');
							//console.log(allIdeas);
							let otherIdeas = allIdeas['ideas'].filter(function(anIdea) {
								return anIdea.id != thisIdea.id;
							});
							if(otherIdeas.length > 0) {
								essRejectResources(otherIdeas, '<xsl:value-of select="eas:i18n('Alternative idea selected')"></xsl:value-of>', currentNeed, updateMultiIdeaDecisions);
							}
							
							//approve the current need
							essApproveResource(currentNeed, '<xsl:value-of select="eas:i18n('Approved as a result of idea being accepted')"></xsl:value-of>', currentNeed, updateNeedAfterDecision);
						
						}
					}
					
					var needUserCanApprove = essViewer.user.approvalClasses.indexOf('Need') >= 0;
					
					//function to refresh the star ratings for a given Idea
					function refreshIdeaRatings(anIdea) {
						<!--let myRating = $('.my-rating[eas-id="' + anIdea.id + '"]');
						let myRatingVal = anIdea.myRating;
						if(myRatingVal != null) {
							myRating.rating('update', myRatingVal);
						}-->
						
						let avgRating = $('.av-rating[eas-id="' + anIdea.id + '"]');
						let avgRatingVal = anIdea.avgRating;
						if(avgRatingVal != null) {
							avgRating.rating('update', avgRatingVal);
						}
					}
					
					
					function initNeedDashboard() {
						//console.log(essViewer.user.approvalClasses);
						
						$('#need-dash-subject').html(currentNeed.name);
						$('#need-dash-name').html(currentNeed.name);
						$('#need-dash-desc').html(currentNeed.description);
						$('#need-dash-status').text(currentNeed.status.label);
						$('#need-dash-status').attr('class', essGetContentStatusStyle(currentNeed));
						if((currentNeed.meta != null) &amp;&amp; (currentNeed.meta.createdBy != null)) {
							$('#need-dash-author').text(currentNeed.meta.createdBy.id);
						}
						
						//unhide the edit button if the user created the need
						if((currentNeed.meta.createdBy != null) &amp;&amp; (currentNeed.meta.createdBy.id == essViewer.user.id)) {
							$('#idea-editor-link').removeClass('hiddenDiv');
						}
						
						//unhide the create plan/project button if need is in approved status and has at least one approved idea option
						if((needUserCanApprove) &amp;&amp; (currentNeed.status != null) &amp;&amp; (currentNeed.status.name == 'Accepted Idea Requirement')) {
														
							approvedIdea = currentIdeas['ideas'].find(function(anIdea) {
								return (anIdea.meta.contentStatus != null) &amp;&amp; (anIdea.meta.contentStatus.name == ess_APPROVAL_STATII['approve'])
							});
							
							if(approvedIdea != null) {
								$('#show-plan-project-div').removeClass('hiddenDiv');
							}
						}
						
						$('#create-plan-project-modal').on('show.bs.modal', function (event) {
							if(currentNeed != null) {           	      
								$('#ess-plan-name').val('Plan for ' + currentNeed.name);
								$('#ess-project-name').val('Project: ' + currentNeed.name);
							}
						});
						
						let goalListFragment = $("#need-goal-bullet-template").html();
					    let goalListTemplate = Handlebars.compile(goalListFragment);
					    
					    let rationaleListFragment = $("#need-rationale-bullet-template").html();
					    let rationaleListTemplate = Handlebars.compile(rationaleListFragment);
					    
					    let instanceListFragment = $("#need-instance-bullet-template").html();
					    let instanceListTemplate = Handlebars.compile(instanceListFragment);
					    
					    //add handlebars helper for comment ratings
					    Handlebars.registerHelper("renderRating", function(aRating) {
					    	let ratingString = '';
					    	for (i = 0; i &lt;= 4; i++) {
					    		if(i + 0.5 == aRating) {
					    			ratingString = ratingString + new Handlebars.SafeString( '<i class="rating-star fa fa-star-half"/>' );
					    		} else if((i + 1) &lt;= aRating) {				    			
									ratingString = ratingString + new Handlebars.SafeString( '<i class="rating-star fa fa-star"/>' );
					    		} else {
					    			ratingString = ratingString +  new Handlebars.SafeString( '<i class="rating-star fa fa-star-o"/>' );
					    		}
					    	}
					    	return ratingString;
						});
					    
					    
					    //if the business need is awaiting approval, show the idea submission date and countdown clock
					    //console.log('Need requires approval? ' + currentNeed.meta.requiresApproval);
					    //console.log(currentNeed);
					    if(currentNeed.meta.requiresApproval) {
						    if(currentNeed.submitIdeasByDate != null) {
						    	$('#need-submit-date').text(moment(currentNeed.submitIdeasByDate).format('DD MMM YYYY'));
						    	$('.need-submit-by-clock').removeClass('hiddenDiv');
								var deadline = new Date(currentNeed.submitIdeasByDate);
								initializeClock('clockdiv', deadline);
							}
						}
					    
					    let motivImplData = {
					        name: currentNeed.name,
					        implications: currentNeed.motivatingImplications,
					        count: currentNeed.motivatingImplications.length
					    }
					    let motivImplFragment = $("#ess-motivating-impl-template").html();
    					let motivImplTemplate = Handlebars.compile(motivImplFragment);
    					$('#need-motivating-implication-tble').html(motivImplTemplate(motivImplData))
					    
					    let ideasFragment = $("#need-idea-template").html();
					    let ideasTemplate = Handlebars.compile(ideasFragment);
					    
					    if((currentNeed.targetPersonas != null) &amp;&amp; (currentNeed.targetPersonas.length > 0)) {
					    	$('#need-persona-list').html(instanceListTemplate(currentNeed.targetPersonas));
					    } else {
					    	$('#need-persona-content').html('<span class="top-20"><em><xsl:value-of select="eas:i18n('No target personas defined')"/></em></span>');
					    }
					    
					    if((currentNeed.goalStatements != null) &amp;&amp; (currentNeed.goalStatements.length > 0)) {
					    	$('#need-goal-list').html(goalListTemplate(currentNeed));
					    } else {
					    	$('#need-goal-content').html('<span class="top-20"><em><xsl:value-of select="eas:i18n('No target gaols defined')"/></em></span>');
					    }
					    
					    if((currentNeed.rationaleStatements != null) &amp;&amp; (currentNeed.rationaleStatements.length > 0)) {
					    	$('#need-rationale-list').html(rationaleListTemplate(currentNeed));
					    } else {
					    	$('#need-rationale-content').html('<span class="top-20"><em><xsl:value-of select="eas:i18n('No target rationale defined')"/></em></span>');
					    }
					    
					    if((currentNeed.targetGeoScope != null) &amp;&amp; (currentNeed.targetGeoScope.length > 0)) {
					    	$('#need-country-list').html(instanceListTemplate(currentNeed.targetGeoScope));
					    } else {
					    	$('#need-country-content').html('<span class="top-20"><em><xsl:value-of select="eas:i18n('No target countries defined')"/></em></span>');
					    }
					    
					    if((currentNeed.targetOrgScope != null) &amp;&amp; (currentNeed.targetOrgScope.length > 0)) {
					    	$('#need-org-list').html(instanceListTemplate(currentNeed.targetOrgScope));
					    } else {
					    	$('#need-org-content').html('<span class="top-20"><em><xsl:value-of select="eas:i18n('No target organisations defined')"/></em></span>');
					    }
					    	    
					    renderTargetOutcomeChart();					    
					    calcIdeaAvgRatings();
					    					    
					    $('#need-ideas-container').html(ideasTemplate(currentIdeas)).promise().done(function(){
			    			    	
					    	if(!currentNeed.meta.requiresApproval) {
					    		//hide the decision buttons
					    		$('.idea-decision-btns').each(function() {
					    			$(this).addClass('hiddenDiv');
					    		})
					    		
					    		$('.rate-idea-btn').each(function() {
					    			$(this).hide();
					    		})
					    		
					    		if(needUserCanApprove) {
						    		$('.idea-decision-comment').each(function() {
						    			$(this).attr('readonly', true);
						    		})
						    	}				    		
					    	} else {
					    		if(!needUserCanApprove) {
						    		$('.need-dash-approval-container').addClass('hiddenDiv');
						    	}
					    	
					    		$('.accept-idea-btn').on('click', function (e) {
									let ideaId = $(this).attr('eas-id');
									approveIdea(ideaId);
								});
								
								$('.reject-idea-btn').on('click', function (e) {
									let ideaId = $(this).attr('eas-id');
									rejectIdea(ideaId);
								});
																
															
								$('.rate-idea-btn').on('click', function (e) {
									let thisBtn = $(this);
									
									let ideaId = $(this).attr('eas-id');
									let thisIdea = currentIdeas.ideas.find(function(anIdea) {
										return anIdea.id == ideaId;
									});
									
									if(thisIdea == null) {
										let myRatingErr = $('.my-rating-error[eas-id="' + ideaId + '"]');
										myRatingErr.text('<xsl:value-of select="eas:i18n('Could not find idea')"/>');
										return;
									}
									
									let myRating = $('.my-rating[eas-id="' + ideaId + '"]');
									let myComment = $('.my-idea-comment[eas-id="' + ideaId + '"]');
									
									if(myRating != null) {
										let myRatingVal = myRating.val();
										if((myRatingVal != null) &amp;&amp; (myRatingVal > 0)) {
											//update the text on the button
											thisBtn.html('Updating...');
												
											let myCommentTxt = myComment.val();	
											let myCurrRating = thisIdea.myRating;
											//if the user has already given a rating, update the existing rating
											if(myCurrRating != null) {
												myCurrRating.rating = parseFloat(myRatingVal);
												myCurrRating.comment = myCommentTxt;
												updateRating(thisIdea, myCurrRating);
											} else {
											//otherwise, create a new rating	
												createRating(thisIdea, parseFloat(myRatingVal), myCommentTxt);
											}
										} else {
											let myRatingErr = $('.my-rating-error[eas-id="' + ideaId + '"]');
											myRatingErr.text('<xsl:value-of select="eas:i18n('A rating must be greater than 0')"/>');
										}
									}
								});
					    	}
					    	
					    	currentIdeas.ideas.forEach(function(anIdea) {
					    		let ideaDecisionCmmt = currentIdeaComments.find(function(aCmnt) {
					    			return aCmnt.subjectId == anIdea.id;
					    		});
					    		if(ideaDecisionCmmt != null) {
					    			//anIdea['decisionComment'] = ideaDecisionCmmt;
					    			let decisionComment = $('.idea-decision-comment[eas-id="' + anIdea.id + '"]');
									decisionComment.val(ideaDecisionCmmt.comment);
					    		}
					    	
					    		let ideaReadOnly = !(anIdea.meta.requiresApproval);
					    		
					    		let rateBtn = $('.rate-idea-btn[eas-id="' + anIdea.id + '"]');
					    		if(ideaReadOnly) {
					    			rateBtn.addClass('hiddenDiv');
					    		}
					    		
								let myRating = $('.my-rating[eas-id="' + anIdea.id + '"]');								
								myRating.rating({
							   		'size':'sm',
							   		'showCaption': false,
							   		'showClear': false,
							   		'readonly': ideaReadOnly
							    });

							    let myRatingVal = anIdea.myRating;
								if(myRatingVal != null) {
									myRating.rating('update', myRatingVal.rating);
									if(myRatingVal.comment != null) {
										let myComment = $('.my-idea-comment[eas-id="' + anIdea.id + '"]');
										myComment.val(myRatingVal.comment);
										myComment.attr('readonly', ideaReadOnly);
									}									
								}
							   	
							   	let avgRating = $('.av-rating[eas-id="' + anIdea.id + '"]');
							   	avgRating.rating({
							   		'size':'sm',
							   		'showCaption': false,
							   		'showClear': false,
							   		'readonly': true
							    });
								
								let avgRatingVal = anIdea.avgRating;
								if(avgRatingVal != null) {
									avgRating.rating('update', avgRatingVal);
								}
							});	
					    });
					    
					    equalHeightPanels();
						initApprovalSelect();
						$('.option-comments-review').click(function() {
							$('[role="tooltip"]').remove();
						});
						
						
						$('.option-comments-review').popover({
							container: 'body',
							html: true,
							trigger: 'click',
							placement: 'left',
							content: function(){
								return $(this).next().html();
							}
						});	
						
						
						$('#essCreatePlanLaterBtn').click(function(){
							$('#create-plan-project-modal').modal('hide');
						});
						
						$('#essCreatePlanCreateBtn').click(function(){
							$(this).html('Updating...');
							createProjectFromIdea(approvedIdea);
						});
						
						
						$('#show-plan-project-btn').click(function(){
							$('#create-plan-project-modal').modal('show');							
						});
						
						
					}
					
					function initApprovalSelect() {
						$('.idea-approval-select').select2();
					}
					
					function equalHeightPanels(){
						$('.panel-heading').matchHeight();
						$('.idea-wrapper > .panel > .panel-body').matchHeight();
						$('.panel-footer').matchHeight();
					}
					
					
					var currentNeedId = '<xsl:value-of select="$param1"/>';
					var currentNeed;
					var currentIdeas = [];
					var currentIdeaComments = [];
					var allIdeas = {};
					
					$('document').ready(function(){
						showViewSpinner('Loading data...');
						Promise.all([
							essPromise_getAPIElement(essEssentialCoreApiUri, 'business-needs', currentNeedId, 'Business Need'),
							essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'business-need-ratings', 'idea-ratings', 'requirementId', currentNeedId, 'Idea Rating'),
							essPromise_getFileredPropNoSQLElements(essEssentialReferenceApiUri, 'approval-comments', 'approval-decision-comments', 'contextId', currentNeedId, 'Approval Decision Comment')
						])
						.then(function (responses) {
							currentNeed = responses[0];
							needRatings = responses[1]['instances'];
							
							let allIdeaComments = responses[2]['instances'];
							currentIdeaComments = allIdeaComments.filter(function(aCmt) {
								return (aCmt.decision != ess_APPROVAL_STATII.propose) &amp;&amp; (aCmt.decision != ess_APPROVAL_STATII.draft);
							});
							//console.log(currentIdeaComments);
							
							
							if(currentNeed != null) {
								let thisIdeasURL = 'business-needs/' + currentNeed.id + '/ideas';
								essPromise_getAPIElements(essEssentialCoreApiUri, thisIdeasURL, 'Idea')
								.then(function(response) {
									removeViewSpinner();
										allIdeas = response;
									let visibleIdeas = response['ideas'].filter(function(anIdea) {
										return (anIdea.meta.contentStatus != null) &amp;&amp; (anIdea.meta.contentStatus.name != 'SYS_CONTENT_IN_DRAFT') &amp;&amp; ((anIdea.meta.visibility == null) || (anIdea.meta.createdBy == null) || (anIdea.meta.visibility.name == 'SYS PUBLIC CONTENT') || ((anIdea.meta.visibility.name == 'SYS PRIVATE CONTENT') &amp;&amp; (anIdea.meta.createdBy.id == essViewer.user.id)));
									});
									currentIdeas['ideas'] = visibleIdeas;
									//console.log('All Ideas');
									//console.log(allIdeas['ideas']);
									initNeedDashboard();								
								})
								.catch(function (error) {
									removeViewSpinner();
					        	    console.log(error.message);
					            });
							};
						})
												
						.then(function(response) {
						})

						.catch(function (error) {
			        	    console.log(error.message);
			            });
					});					
					
				</script>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
