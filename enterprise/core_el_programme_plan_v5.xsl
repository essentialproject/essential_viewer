<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

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

	<!-- param1 = the id of the programme that the roadmap is describing -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4"/>-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Project', 'Programme')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- theURLPrefix = parameter passed by the reporting engine containing the context path for th viewing environment (defaults to a standalone installation if not available) -->
	<xsl:param name="theURLPrefix"/>

	<xsl:variable name="programme" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="programmeName" select="$programme/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="programmeDesc" select="$programme/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="projects" select="/node()/simple_instance[name = $programme/own_slot_value[slot_reference = 'projects_for_programme']/value]"/>
	<xsl:variable name="allDates" select="/node()/simple_instance[(type = 'Year') or (type = 'Quarter') or (type = 'Gregorian')]"/>
	<xsl:variable name="genericPageLabel">
		<xsl:value-of select="eas:i18n('Programme Plan')"/>
	</xsl:variable>
	<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' - ', $programmeName)"/>


	<xsl:template match="knowledge_base">

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>

				<!--	scripts for the timeline -->
				<script>
				Timeline_ajax_url="js/timeline_ajax/simile-ajax-api.js?release=6.19";
				Timeline_urlPrefix='js/timeline_js/';       
				Timeline_parameters='bundle=true';
				</script>

				<script src="js/timeline_js/timeline-api.js?release=6.19" type="text/javascript"/>

				<script>        
			        var tl;
			        function onLoad() {
			        
			            var theme1 = Timeline.ClassicTheme.create();
			            theme1.autoWidth = true; // Set the Timeline's "width" automatically.
			                                     // Set autoWidth on the Timeline's first band's theme,
			                                     // will affect all bands.
			            theme1.timeline_start = new Date(Date.UTC(2008, 0, 1));
			            theme1.timeline_stop  = new Date(Date.UTC(2160, 0, 1));			          
			            
			            var eventSource1 = new Timeline.DefaultEventSource();	            
			            
			            var bandInfos = [
			                Timeline.createBandInfo({
			                    width:          '70%', // set to a minimum, autoWidth will then adjust
			                    intervalUnit:   Timeline.DateTime.MONTH,
			                    multiple: 		1,
			                    intervalPixels: 35,
			                    eventSource:    eventSource1,
			                    theme:          theme1,
			                    layout:         'original'  // original, overview, detailed
			                    
			                }),
	
			                Timeline.createBandInfo({
			                    width:          '30%', // set to a minimum, autoWidth will then adjust
			                    intervalUnit:   Timeline.DateTime.YEAR,
			                    multiple: 		1,
			                    intervalPixels: 210	,
			                    eventSource:    eventSource1,
			                    theme:          theme1,
			                    layout:         'overview'  // original, overview, detailed
			                    
			                })
			                
			            ];
	
			            bandInfos[1].syncWith = 0;
		   				bandInfos[0].highlight = true;
			                                                            
			            // create the Timeline
			            tl = Timeline.create(document.getElementById("timeline1"), bandInfos, Timeline.HORIZONTAL);
			                           
			            eventSource1.loadJSON(timeline_data1, document.location.href); // The data was stored into the 
			                                                       					  // timeline_data variable.		            
			            tl.layout(); // display the Timeline
				        }
				        
				        var resizeTimerID = null;
				        function onResize() {
				            if (resizeTimerID == null) {
				                resizeTimerID = window.setTimeout(function() {
				                    resizeTimerID = null;
				                    tl.layout();
				                }, 500);
				            }
				        }
				</script>


				<!-- The following script is the event data for the timeline-->
				<script type="text/javascript">
				   	
				   	var timeline_data1 = {  // save as a global variable
				   	'dateTimeFormat': 'iso8601',
				   	
				   	'events' : [
					
					
					<xsl:for-each select="$projects">
						
						<xsl:variable name="currentProjectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="currentProjectDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
						<xsl:variable name="currentProjectStart" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
						<xsl:variable name="currentProjectEnd" select="$allDates[name = current()/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
						<xsl:variable name="projectStatus" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>
						<xsl:variable name="projectStatusName" select="$projectStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						<xsl:variable name="formattedStartDate">
							<xsl:call-template name="JSFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentProjectStart)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="formattedEndDate">
							<xsl:call-template name="JSFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentProjectEnd)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="displayStartDate">
							<xsl:call-template name="FullFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentProjectStart)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="displayEndDate">
							<xsl:call-template name="FullFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentProjectEnd)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="linkURL">
							<xsl:call-template name="RenderFullLinkText">
								<xsl:with-param name="theURLPrefix" select="$theURLPrefix"/>
								<xsl:with-param name="theXSL" select="'enterprise/core_el_project_summary.xsl'"/>
								<xsl:with-param name="theInstanceID" select="current()/name"/>
								<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
								<xsl:with-param name="theHistoryLabel">Project Summary - <xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/></xsl:with-param>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:text>{'start': '</xsl:text><xsl:value-of select="$formattedStartDate"/><xsl:text>',
							'end': '</xsl:text><xsl:value-of select="$formattedEndDate"/><xsl:text>',</xsl:text>
						<xsl:text>'title': '</xsl:text><xsl:value-of select="$currentProjectName"/><xsl:text>',</xsl:text>
						'description': '<strong>Summary</strong><br/><xsl:value-of select="$currentProjectDescription"/><br/><br/><strong>Start Date: </strong><xsl:value-of select="$displayStartDate"/><br/><strong>End Date: </strong><xsl:value-of select="$displayEndDate"/><xsl:text>',
							'link': '</xsl:text><xsl:value-of select="$linkURL"/>
						<xsl:text>',
								caption: '</xsl:text>Project Status: <xsl:value-of select="$projectStatusName"/><xsl:text>'
									}</xsl:text><xsl:if test="not(position() = count($projects))">,</xsl:if>
					</xsl:for-each>
				   	]
				   	}
				   
				   </script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

			</head>
			<body onload="onLoad();" onresize="onResize();">
				<!-- functions required for timeline-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Plan')"/>
							</h2>
							<p>
								<xsl:value-of select="$programmeDesc"/>
							</p>
							<div id="timeline1" style="border:1px solid #ddd"/>
							<!--add the special id for the timeline-->

							<hr/>
						</div>



						<!--<!-\-Setup the Supporting Documentation section-\->

							<div class="col-xs-12">
								<div class="sectionIcon"><i class="fa fa-file-text-o icon-section icon-color"/></div>
								<div>
									<h2 class="text-primary">
										<xsl:value-of select="eas:i18n('Related Documents')"/>
									</h2>
								</div>
								<div>
									<!-\-<xsl:call-template name="extDocRef"></xsl:call-template>-\->
									<!-\-<xsl:apply-templates select="$roadmap" mode="ReportExternalDocRef"/>-\->
								</div>
								<hr/>
							</div>
-->


						<!--Setup Closing Tags-->
					</div>
				</div>
				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>






</xsl:stylesheet>
