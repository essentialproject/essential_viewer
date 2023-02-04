<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan xs functx eas ess user" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:user="http://www.enterprise-architecture.org/essential/vieweruserdata">
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
	<!-- 04.11.2008 JWC Migration to report servlet -->
	<!-- 06.11.2008	JWC Fixed page history for link from logo image -->
	<!-- 28.11.2008	JWC	Updated search URL to production Sharepoint server -->
	<!-- 28.01.2009 JWC	Migrate to use of divs for header -->
	<!-- 01.04.2011 NJW	updated for viewer3 -->
	<!-- 15.11.2016 JWC Apply sort by portal_sequence to links in drop-down nav-bar -->

	<xsl:import href="../common/user-settings/core_user_view_settings_templates.xsl"/>
	<xsl:import href="../common/core_header_interactions.xsl"/>
	<xsl:include href="../common/core_utilities.xsl"/>
	<xsl:include href="../common/core_page_history.xsl"/>
	<xsl:include href="../common/core_feedback.xsl"/>
	
	<xsl:param name="pageHistory"/>
	<xsl:param name="theURLFullPath"/>
	<xsl:param name="reposXML">reportXML.xml</xsl:param>
	<xsl:param name="eipMode"/>

	<!-- Specify the selected user -->
	<xsl:param name="userID"/>

	<xsl:variable name="flagFileImage">
		<xsl:choose>
			<xsl:when test="$flagFile = 'language/flags/.png'">
				<xsl:text>language/flags/en-gb.png</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$flagFile"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="headerHomeReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Home Page')]"/>
	<xsl:variable name="homePageXSL" select="$headerHomeReportConstant/own_slot_value[slot_reference = 'report_constant_value']/value"/>
	<xsl:variable name="portalConstant" select="$headerHomeReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value"/>
	<xsl:variable name="portalContantTemplateXSL" select="/node()/simple_instance[type = 'Portal' and name = $portalConstant]/own_slot_value[slot_reference = 'portal_xsl_filename']/value"/>
	<xsl:variable name="portalConstantURL" select="concat('report?XML=',$reposXML,'&amp;PMA=',$portalConstant,'&amp;XSL=',$portalContantTemplateXSL,'&amp;cl=',$currentLanguage/own_slot_value[slot_reference='name']/value,'&amp;LABEL=','Home')"/>
	<xsl:variable name="homePageConstantURL" select="concat('report?XML=',$reposXML,'&amp;XSL=',$homePageXSL,'&amp;cl=',$currentLanguage/own_slot_value[slot_reference='name']/value,'&amp;LABEL=','Home')"/>
	<xsl:variable name="defaultURL" select="concat('report?XML=',$reposXML,'&amp;XSL=','home.xsl','&amp;cl=',$currentLanguage/own_slot_value[slot_reference='name']/value,'&amp;LABEL=','Home')"/>
	
	<xsl:key name="allPortals_key" match="/node()/simple_instance[type = 'Portal']" use="own_slot_value[slot_reference = 'name']/value"/>
	<xsl:key name="allEnablesPortals_key" match="/node()/simple_instance[type = 'Portal']" use="own_slot_value[slot_reference = 'portal_is_enabled']/value"/>

	<xsl:key name="allReports_key" match="/node()/simple_instance[type = 'Report']" use="own_slot_value[slot_reference = 'name']/value"/>
	<xsl:key name="utilitiesAllReports_key" match="$utilitiesAllReports" use="own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
	<xsl:key name="utilitiesAllPDFConfigs_key" match="$utilitiesAllPDFConfigs" use="own_slot_value[slot_reference = 'report_pdf_config_is_default']/value"/>
	
	<xsl:variable name="dynQueryInstance" select="$utilitiesAllEditors[(own_slot_value[slot_reference='name']/value = 'SYS: DYNAMIC QUERY TOOL')]"/>
 
	<xsl:variable name="homeHref">
		<xsl:choose>
			<xsl:when test="count($portalConstant) &gt; 0">
				<xsl:value-of select="$portalConstantURL"/>
			</xsl:when>
			<xsl:when test="(count($portalConstant) = 0) and string-length($homePageXSL) &gt; 0">
				<xsl:value-of select="$homePageConstantURL"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$defaultURL"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="node()" name="Heading">
		<xsl:param name="contentID"/>
		<xsl:param name="subPortalID"/>
		<xsl:param name="mode">VIEW</xsl:param>

		<xsl:variable name="headerStyle">
			<xsl:choose>
				<xsl:when test="$mode = 'EDIT'">navbar navbar-default nav-edit-color</xsl:when>
				<xsl:otherwise>navbar navbar-default nav-color</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<script type="text/javascript">
				$(document).ready(function(){
					$("#historyLink").click(function(){
						$('#feedbackOverlay').hide();
						$('#searchOverlay').hide();
						$('#historyOverlay').slideToggle();	
					});
					$("#feedbackLink").click(function(){					
						$('#searchOverlay').hide();
						$('#historyOverlay').hide();
						$('#feedbackOverlay').slideToggle();
					});
					$("#searchLink").click(function(){
						$('#feedbackOverlay').hide();
						$('#historyOverlay').hide();
						$('#searchOverlay').slideToggle();
					});
					$('li[data-toggle="tooltip"]').tooltip();
					$('.closeHeaderOverlay').click(function(){
						$(this).parent().slideUp();
					});
					$('#shareLink').click(function(evt) {
						$('[role="tooltip"]').remove();
						evt.stopPropagation();
					});
					$('#shareLink').popover({
						container: 'body',
						html: true,
						trigger: 'click',
						placement: 'bottom',
						sanitize: false,
						content: function(){
							return $(this).next().html();
						}
					});
					
				});				
			</script>
		<style>
			.headerOverlay {position: relative}
			.closeHeaderOverlay{position:absolute;top: 10px; right: 10px;}
		</style>

		<!-- Piwik -->
		<xsl:if test="$eipMode = 'true'">
			<script type="text/javascript">
				function getCookie(key) {
					var re = new RegExp(key + "=([^;]+)");
					var value = re.exec(document.cookie);
					return (value != null) ? unescape(value[1]) : null;
				}
				if (tenant = getCookie("tenant")) {
					userTenant = tenant;
				}
                var _paq = _paq || [];
                var userTrack = tenant+'.user';
                  _paq.push(["setDomains", ["*.essentialintelligence.com"]]);
                  _paq.push(['setUserId', userTrack]);
                  _paq.push(['trackPageView']);
                  _paq.push(['enableLinkTracking']);
                  _paq.push(['setSecureCookie', true]);
                  (function() {
                    var u="https://e-asolutions.net/piwik/";
                    _paq.push(['setTrackerUrl', u+'piwik.php']);
                    _paq.push(['setSiteId', 1]);
                    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
                    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
                  })();
            </script>
			<noscript>
				<p>
					<img src="https://e-asolutions.net/piwik/piwik.php?idsite=1" style="border:0;" alt=""/>
				</p>
			</noscript>
		</xsl:if>
		<!-- End Piwik Code -->
		<nav class="{$headerStyle}" id="mainHeader">
			<div class="container-fluid">
				<!-- Brand and toggle get grouped for better mobile display -->
				<div class="navbar-header">
					<a class="navbar-brand" onclick="location.href='{$homeHref}';">
						<div class="tenant-logo">
							<img alt="tenant logo">
								<xsl:variable name="allViewerStyles" select="/node()/simple_instance[type = 'Viewer_Styling']"/>
								<xsl:variable name="activeViewerStyle" select="$allViewerStyles[own_slot_value[slot_reference = 'style_is_active']/value = 'true'][1]"/>
								<xsl:choose>
									<xsl:when test="string-length($activeViewerStyle/own_slot_value[slot_reference = 'header_logo_path']/value) > 0">
										<xsl:attribute name="src" select="$activeViewerStyle/own_slot_value[slot_reference = 'header_logo_path']/value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="src">images/eas_logo_2014_white.png</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</img>
						</div>
					</a>
					<button class="pull-right navbar-toggle collapsed">
						<span class="sr-only"><xsl:value-of select="eas:i18n('Toggle navigation')"/></span>
						<i class="fa fa-bars collapsed text-white" style="font-size:28px;" data-toggle="collapse" data-target="#nav-collapse"/>
					</button>

				</div>

				<div class="row">
					<!-- Collect the nav links, forms, and other content for toggling -->
					<div class="collapse navbar-collapse" id="nav-collapse">

						<ul class="nav navbar-nav navbar-right">
							<li data-toggle="tooltip" data-placement="bottom" data-container="body">
								<xsl:attribute name="title" select="eas:i18n('Share')"/>
								<a href="#" id="shareLink">
									<i class="fa fa-share-alt"/>
								</a>
								<div class="popover">
									<div class="small strong"><xsl:value-of select="eas:i18n('Copy link to this page')"/></div>
									<div class="top-10"><input id="ess-page-link-url" type="text" readonly="readonly" style="width: 300px;" class="form-control input-sm" value="https://example.com"/></div>
									<div class="top-10 pull-right"><button class="btn btn-sm btn-default right-10 closeSharePopover" style="width: 80px;">Cancel</button><button class="btn btn-sm btn-success" id="ess-copy-page-link" style="width: 80px;"><i class="fa fa-copy right-5"/><span><xsl:value-of select="eas:i18n('Copy')"/></span></button></div>
									<div class="clearfix"/>
								</div>
							</li>
							<li data-toggle="tooltip" data-placement="bottom" data-container="body">
								<xsl:attribute name="title" select="eas:i18n('Search')"/>
								<a href="#" id="searchLink">
									<i class="fa fa-search"/>
								</a>
							</li>
							<!-- ONLY SHOW THE FOLLOWING IF IN EIP MODE -->
							<xsl:if test="($eipMode = 'true') and $dynQueryInstance">
								<li data-toggle="tooltip" data-placement="bottom" data-container="body">
									<xsl:attribute name="title" select="eas:i18n('Query')"/>
									<a id="queryLink" target="_blank">
										<xsl:attribute name="href" select="concat('report?XML=reportXML.xml&amp;PMA=&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=Dynamic%20Query%20Tool&amp;SECTION=&amp;EDITOR=',$dynQueryInstance/name)"/>
										<i class="fa fa-table"/>
									</a>
									
								</li>
							</xsl:if>
							<xsl:if test="($eipMode = 'true') and eas:compareVersionNumbers($thisRepoVersion, '6.6')">
								<li data-toggle="tooltip" data-placement="bottom" data-container="body">
									<xsl:attribute name="title" select="eas:i18n('Comments')"/>
									<a href="#" id="commentLink" onclick="toggleComments();setTimeout(initCommentJS,500);">
										<i class="fa fa-comment-o"/>
										<span id="comments-badge" class="badge"/>
									</a>
								</li>
								<xsl:if test="$sysIdeationIsOn">
									<li data-toggle="tooltip" data-placement="bottom" data-container="body">
										<xsl:attribute name="title" select="eas:i18n('Ideas')"/>
										<a href="#" id="ideaLink" onclick="toggleIdeas();setTimeout(initIdeasJS,600);">
											<i class="fa fa-lightbulb-o"/>
											<span id="ideas-badge" class="badge"/>
										</a>
									</li>
									<li data-toggle="tooltip" data-placement="bottom" data-container="body">
										<xsl:attribute name="title" select="eas:i18n('Approvals')"/>
										<a href="#" id="approvalLink">
											<xsl:call-template name="RenderLinkHref">
												<xsl:with-param name="theXSL" select="'enterprise/core_el_approvals_dashboard.xsl'"/>
											</xsl:call-template>
											<i class="fa fa-check"/>
											<span id="approvals-badge" class="badge"/>
										</a>
									</li>
								</xsl:if>
							</xsl:if>
							<li class="disabled" data-toggle="tooltip" data-placement="bottom" data-container="body">
								<xsl:attribute name="title" select="eas:i18n('Roadmaps')"/>
								<a href="#" id="ess-roadmap-widget-toggle">
									<i class="fa fa-road" style="position: relative; top: 1px;"/>
								</a>
							</li>
							<li>
								<xsl:attribute name="title" select="eas:i18n('Print')"/>
								<a href="#" onclick="window.print();">
									<i class="fa fa-print" style="position:relative; top: 1px;"/>
								</a>
							</li>
							<li data-toggle="tooltip" data-placement="bottom" data-container="body">
								<xsl:attribute name="title" select="eas:i18n('Feedback')"/>
								<a href="#" id="feedbackLink">
									<i class="fa fa-envelope"/>
								</a>
							</li>
							<li data-toggle="tooltip" data-placement="bottom" data-container="body">
								<xsl:attribute name="title" select="eas:i18n('History')"/>
								<a href="#" id="historyLink">
									<i class="fa fa-history"/>
								</a>
							</li>
							<li class="dropdown" data-toggle="tooltip" data-placement="bottom" data-container="body">
								<xsl:attribute name="title" select="eas:i18n('Utilities')"/>
								<a href="#" class="dropdown-toggle" data-toggle="dropdown">
									<!--Utilities&#160;<span class="caret"/>-->
									<i class="fa fa-gear"/>
								</a>
								<ul class="dropdown-menu" role="menu">
									<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL">view_manual/view_manual_catalogue.xsl</xsl:with-param>
											</xsl:call-template>
											<span><xsl:value-of select="eas:i18n('View Manuals')"/></span>
										</a>
									</li>
									<!--<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL">integration/core_spreadsheet_template_list.xsl</xsl:with-param>
											</xsl:call-template>
											<span>Spreadsheet Templates</span>
										</a>
									</li>-->
									<!--<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'essential_utilities.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span><xsl:value-of select="eas:i18n('Integration Examples')"/></span>
										</a>
									</li>-->
									<!--<xsl:if test="$eipMode">
										<li>
											<a>
												<xsl:call-template name="CommonRenderLinkHref">
													<xsl:with-param name="theXSL">ext/audit/ess_el_audit_reporting.xsl</xsl:with-param>
												</xsl:call-template>
												<span><xsl:value-of select="eas:i18n('Audit Log')"/></span>
											</a>
										</li>
									</xsl:if>-->
									<!--<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'integration/core_int_all_instances_by_class.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span>All Instances by Class</span>
										</a>
									</li>
									<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'integration/instance_relations_tree.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span>Instance Relationships as Tree</span>
										</a>
									</li>
									<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'integration/instance_overview.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span>Instance Overview</span>
										</a>
									</li>
									<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'integration/class_overview.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span>Class Overview</span>
										</a>
									</li>
									<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'integration/core_ut_completeness_view.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span>Completeness View</span>
										</a>
									</li>
									<li>
										<a>
											<xsl:call-template name="CommonRenderLinkHref">
												<xsl:with-param name="theXSL" select="'integration/core_ut_duplicate_dashboard_filter.xsl'"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
											</xsl:call-template>
											<span>Duplicate Finder</span>
										</a>
									</li>-->
								</ul>
							</li>
							<xsl:choose>
								<xsl:when test="$eipMode = 'true'">
									<li class="dropdown">
										<a href="#" class="dropdown-toggle" data-toggle="dropdown"><xsl:value-of select="$userData//user:firstname"/>&#160;<xsl:value-of select="$userData//user:lastname"/>&#160;<span class="caret"/></a>
										<ul class="dropdown-menu" role="menu">
											<li id="language_select">
												<!--<a href="#">Select Language</a>-->
												<xsl:variable name="currentPageEncodedURL" select="encode-for-uri($theURLFullPath)"/>
												<xsl:variable name="languageSelectPageLink">
													<xsl:text>report?XML=reportXML.xml&amp;XSL=common/core_language_select.xsl&amp;LABEL=Select&#160;a&#160;Language&amp;currentPageLink=</xsl:text>
													<xsl:value-of select="$currentPageEncodedURL"/>
												</xsl:variable>
												<a class="text-primary" href="{$languageSelectPageLink}"><xsl:value-of select="$currentLanguage/own_slot_value[slot_reference = 'lang_native_name']/value"/>&#160;&#160;<img class="flagFix" src="{$flagFileImage}" alt="flag"/></a>
											</li>
											<li class="divider"/>
											<li>
												<a href="logout">Logout</a>
											</li>
										</ul>
									</li>
								</xsl:when>
								<xsl:otherwise>
									<li id="language_select">
										<xsl:variable name="currentPageEncodedURL" select="encode-for-uri($theURLFullPath)"/>
										<xsl:variable name="languageSelectPageLink">
											<xsl:text>report?XML=reportXML.xml&amp;XSL=common/core_language_select.xsl&amp;LABEL=Select&#160;a&#160;Language&amp;currentPageLink=</xsl:text>
											<xsl:value-of select="$currentPageEncodedURL"/>
										</xsl:variable>

										<a class="text-primary" href="{$languageSelectPageLink}">
											<xsl:value-of select="$currentLanguage/own_slot_value[slot_reference = 'lang_native_name']/value"/>
										</a>


									</li>
								</xsl:otherwise>
							</xsl:choose>
						</ul>
					</div>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<!-- /.container-fluid -->
		</nav>
		<!--<div class="nav-contrast"/>-->

		<div class="container-fluid">
			<div class="row">
				<div id="searchOverlay" class="col-xs-12 bg-offwhite headerOverlay" style="border-bottom:1px solid #ccc; display: none;">
					<i class="fa fa-times closeHeaderOverlay"/>
					<div class="verticalSpacer_20px"/>
					<form action="report" method="get" class="-navbar-form navbar-left">
						<div class="form-group">
							<input type="hidden" name="XSL" value="common/core_search_results.xsl"/>
							<input type="hidden" name="XML">
								<xsl:attribute name="value" select="$reposXML"/>
							</input>
							<input type="hidden" name="label" value="Search Query"/>
							<div class="input-group">
								<span class="input-group-addon">
									<i class="fa fa-search"/>
								</span>
								<input type="search" id="SearchQuery" name="SearchQuery" class="form-control" placeholder="Search" style="width: 98%"/>
							</div>
						</div>
						<!--<button type="submit" class="btn btn-default back-green">Search</button>-->
					</form>

				</div>
				
				<xsl:variable name="headerThisReport" select="key('utilitiesAllReports_key',$theCurrentXSL)"/> 
				
				<div id="historyOverlay" class="col-xs-12 bg-offwhite headerOverlay" style="border-bottom:1px solid #ccc;display: none;">
					<i class="fa fa-times closeHeaderOverlay"/>
					<div class="verticalSpacer_20px"/>
					<h2>
						<xsl:value-of select="eas:i18n('Essential Viewer History')"/>
					</h2>
					<p><xsl:value-of select="eas:i18n('Below is a list of the most recent pages viewed in Essential Viewer')"/>.</p>
					<div class="verticalSpacer_10px"/>
					<div id="historyContent">
						<xsl:call-template name="Page_History">
							<xsl:with-param name="breadcrumbs">
								<xsl:value-of select="$pageHistory"/>
							</xsl:with-param>
						</xsl:call-template>
					</div>
				</div>

				<div id="feedbackOverlay" class="col-xs-12 bg-offwhite headerOverlay" style="border-bottom:1px solid #ccc;display: none;">
					<i class="fa fa-times closeHeaderOverlay"/>
					<div class="verticalSpacer_20px"/>
					<h2>
						<xsl:value-of select="eas:i18n('Get In Touch')"/>
					</h2>
					<form action="#" method="post" enctype="multipart/form-data" id="EmailFeedbackForm" name="EmailFeedbackForm">
						<strong><xsl:value-of select="eas:i18n('Name')"/>:</strong>
						<br/>
						<input id="FeedbackFormNameBox" type="text" name="VisitorName" style="width:100%"/>
						<br/>
						<br/>
						<strong><xsl:value-of select="eas:i18n('Feedback Type')"/>:</strong>
						<br/>
						<select id="FeedbackFormList" name="feedbacktype">
							<option value="Choose from the List">
								<xsl:value-of select="eas:i18n('Select an Option')"/>
							</option>
							<option value="Question About Content">
								<xsl:value-of select="eas:i18n('Question About Content')"/>
							</option>
							<option value="Report an Error">
								<xsl:value-of select="eas:i18n('Report an Error')"/>
							</option>
							<option value="Comment on Site">
								<xsl:value-of select="eas:i18n('Comment on Site')"/>
							</option>
							<option value="Other">
								<xsl:value-of select="eas:i18n('Other')"/>
							</option>
						</select>
						<br/>
						<br/>
						<strong><xsl:value-of select="eas:i18n('Your Comment')"/>:</strong>
						<br/>
						<textarea id="FeedbackFormCommentBox" name="VisitorComment" rows="9" style="width:100%"/>
						<br/>
						<br/>
						<!-- Set global or specific content owner email addresses as the recipients of the feedback form -->
						<xsl:variable name="contentOwnerEmails">
							<xsl:call-template name="GetContentOwnerEmailAddresses">
								<xsl:with-param name="contentID" select="$contentID"/>
							</xsl:call-template>
						</xsl:variable>
						<input type="hidden" name="emailTo">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="string-length($contentOwnerEmails) > 0">
										<xsl:value-of select="$contentOwnerEmails"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="GetGlobalContentOwnerEmailAddresses"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
						<!-- Set the hidden field value to the URI of the current page -->
						<xsl:variable name="encodedURL" select="$theURLFullPath"/>
						<input type="hidden" name="pageLink">
							<xsl:attribute name="value">
								<xsl:value-of select="$encodedURL" disable-output-escaping="yes"/>
							</xsl:attribute>
						</input>
						<input type="button" value="Email This Form" onclick="emailForm()"/>
					</form>
					<div class="verticalSpacer_20px"/>
				</div>
			</div>
			<xsl:call-template name="portalBar"/>
			<xsl:call-template name="RenderInteractiveHeaderBars"/>
			<xsl:call-template name="ViewUserSettingsUI"/>
		</div>
		
	</xsl:template>

	<xsl:template name="portalBar">
		<xsl:variable name="allEnabledPortals" select="key('allEnablesPortals_key','true')"/>
		<xsl:variable name="viewLibraryReport" select="key('allReports_key','Core: View Library')"/> 
	<!--	<xsl:variable name="allPortals" select="/node()/simple_instance[type = 'Portal']"/>
		<xsl:variable name="allEnabledPortals2" select="$allPortals[own_slot_value[slot_reference = 'portal_is_enabled']/value = 'true']"/>
		<xsl:variable name="allReports" select="/node()/simple_instance[type = 'Report']"/>
		<xsl:variable name="viewLibraryReport2" select="$allReports[own_slot_value[slot_reference = 'name']/value = 'Core: View Library']"/>-->
		<xsl:variable name="viewLibraryLabel" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_label']/value"/>
		<xsl:variable name="viewLibraryDesc" select="$viewLibraryReport/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="viewLibraryXSL" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		<xsl:variable name="viewLibraryHistoryLabel" select="$viewLibraryReport/own_slot_value[slot_reference = 'report_history_label']/value"/>
		<style type="text/css">
			.portalBar{
				width: 100%;
				height: auto;
				padding: 1px 0 3px 0;
			}
			
			.portalBar a,
			.portalBar a:hover{
				color: white;
			}
			
			.portalBarRow{
				display: none;
			}
			
			@media (max-width : 1024px){
				.portalBarRow{
					display: block;
				}
			}</style>
		<script>
			$(document).ready(function(){
				var timer;
				var delay = 500;	
				<!--$('.portalBarRow').hide();-->
				$('.tenant-logo').hover(
					function(){
					// on mouse in, start a timeout
				    timer = setTimeout(function() {
				        $('.portalBarRow').slideDown();
				    }, delay);
				}, function() {
				    // on mouse out, cancel the timer
				    clearTimeout(timer);
				});
				$('.portalBarRow').hover(
					function(){
					// on mouse in, start a timeout
				    timer = setTimeout(function() {
				        $('.portalBarRow').show();
				    }, delay);
					},
					function(){
					$('.portalBarRow').delay('2000').slideUp();
					clearTimeout(timer);
				});
			});
		</script>
		<div class="row bg-secondary portalBarRow">
			<div class="col-xs-12">
				<div class="portalBar text-white fontSemi">
					<a>
						<xsl:attribute name="href" select="$homeHref"/>
						<span><xsl:value-of select="eas:i18n('Home')"/></span>
					</a>
					<span>&#160;&#160;&#160;|&#160;&#160;&#160;</span>
					<xsl:for-each select="$allEnabledPortals">
						<xsl:sort select="own_slot_value[slot_reference = 'portal_sequence']/value"/>
						<xsl:variable name="portalXSL" select="own_slot_value[slot_reference = 'portal_xsl_filename']/value"/>
						<xsl:variable name="portalHistoryLabel" select="own_slot_value[slot_reference = 'report_history_label']/value"/>
						<a>
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="theXSL" select="$portalXSL"/>
								<xsl:with-param name="theInstanceID" select="current()/name"/>
								<xsl:with-param name="theHistoryLabel" select="$portalHistoryLabel"/>
							</xsl:call-template>
							<span>
								<xsl:value-of select="current()/own_slot_value[slot_reference = 'portal_label']/value"/>
							</span>
						</a>
						<span>&#160;&#160;&#160;|&#160;&#160;&#160;</span>
					</xsl:for-each>
					<xsl:if test="$viewLibraryReport/own_slot_value[slot_reference = 'report_is_enabled']/value = 'true'">
						<a>
							<xsl:call-template name="CommonRenderLinkHref">
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="theXSL" select="$viewLibraryXSL"/>
								<xsl:with-param name="theHistoryLabel" select="$viewLibraryHistoryLabel"/>
							</xsl:call-template>
							<span><xsl:value-of select="$viewLibraryLabel"/></span>
						</a>
					</xsl:if>
				</div>

			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
