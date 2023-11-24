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


	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

	<!-- theURLPrefix = parameter passed by the reporting engine containing the context path for th viewing environment (defaults to a standalone installation if not available) -->
	<xsl:param name="theURLPrefix"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($param4) > 0">
				<xsl:variable name="roadmapConstant" select="/node()/simple_instance[own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Data_Roadmap']"/>
				<xsl:variable name="roadmap" select="/node()/simple_instance[name = $roadmapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $param4]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
					<xsl:with-param name="roadmap" select="$roadmap"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="roadmapConstant" select="/node()/simple_instance[(own_slot_value[slot_reference = 'report_constant_short_name']/value = 'Data_Roadmap')][1]"/>
				<xsl:variable name="roadmap" select="/node()/simple_instance[name = $roadmapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="roadmap" select="$roadmap"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Data Roadmap')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="roadmap"/>

		<xsl:variable name="roadmapName" select="$roadmap/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="roadmapDesc" select="$roadmap/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="roadmapMilestones" select="/node()/simple_instance[(name = $roadmap/own_slot_value[slot_reference = 'contained_roadmap_model_elements']/value) and (type = 'Roadmap_Milestone')]"/>
		<xsl:variable name="architectureStates" select="/node()/simple_instance[name = $roadmapMilestones/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
		<xsl:variable name="roadmapRelations" select="/node()/simple_instance[name = $roadmap/own_slot_value[slot_reference = 'contained_roadmap_relations']/value]"/>
		<xsl:variable name="strategicPlans" select="/node()/simple_instance[(supertype = 'Strategic_Plan') and (name = $roadmapRelations/own_slot_value[slot_reference = ':roadmap_strategic_plans']/value)]"/>
		<xsl:variable name="allDates" select="/node()/simple_instance[(type = 'Year') or (type = 'Quarter') or (type = 'Gregorian')]"/>

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
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
						<xsl:for-each select="$roadmapMilestones">
							
							
							<xsl:variable name="currentArchState" select="$architectureStates[name = current()/own_slot_value[slot_reference = 'milestone_architecture_state']/value]"/>
							<xsl:variable name="currentArchStateName" select="$currentArchState/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="currentStateDescription" select="$currentArchState/own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="currentArchStateStart" select="$allDates[name = $currentArchState/own_slot_value[slot_reference = 'start_date']/value]"/>
							<xsl:variable name="formattedStartDate">
								<xsl:call-template name="JSFormatDate">
									<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentArchStateStart)"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="displayStartDate">
								<xsl:call-template name="FullFormatDate">
									<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentArchStateStart)"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="linkURL">
								<xsl:call-template name="RenderFullLinkText">
									<xsl:with-param name="theURLPrefix" select="$theURLPrefix"/>
									<xsl:with-param name="theXSL" select="'information/core_il_data_milestone_summary.xsl'"/>
									<xsl:with-param name="theInstanceID" select="current()/name"/>
									<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
									<xsl:with-param name="theParam4" select="$param4"/> <!-- pass the id of the taxonomy term used for scoping as parameter 4-->
								</xsl:call-template>
							</xsl:variable>
							<xsl:text>{"start": "</xsl:text><xsl:value-of select="$formattedStartDate"/><xsl:text>",</xsl:text>
							<xsl:text>"title": "</xsl:text><xsl:value-of select="$currentArchStateName"/><xsl:text>",</xsl:text>
							"description": "<strong>Milestone Summary</strong><br/><xsl:value-of select="eas:renderJSText($currentStateDescription)"/><br/><br/><strong>Target Date: </strong><xsl:value-of select="$displayStartDate"/><xsl:text>",
								"link": "</xsl:text><xsl:value-of select="$linkURL"/><xsl:text>",
							"caption": "</xsl:text>Architecture State<xsl:text>"
							},
							
							</xsl:text>
						</xsl:for-each>
					
					
					<xsl:for-each select="$strategicPlans">
						
						<xsl:variable name="currentPlanName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="currentPlanDescription" select="current()/own_slot_value[slot_reference = 'description']/value"/>
						<xsl:variable name="currentPlanStart" select="$allDates[name = current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value]"/>
						<xsl:variable name="currentPlanEnd" select="$allDates[name = current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value]"/>
						<xsl:variable name="formattedStartDate">
							<xsl:call-template name="JSFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentPlanStart)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="formattedEndDate">
							<xsl:call-template name="JSFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentPlanEnd)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="displayStartDate">
							<xsl:call-template name="FullFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentPlanStart)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="displayEndDate">
							<xsl:call-template name="FullFormatDate">
								<xsl:with-param name="theDate" select="eas:get_start_date_for_essential_time($currentPlanEnd)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="linkURL">
							<xsl:call-template name="RenderFullLinkText">
								<xsl:with-param name="theURLPrefix" select="$theURLPrefix"/>
								<xsl:with-param name="theXSL" select="'enterprise/core_el_strategic_plan_summary.xsl'"/>
								<xsl:with-param name="theInstanceID" select="current()/name"/>
								<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
								<xsl:with-param name="theParam4" select="$param4"/> <!-- pass the id of the taxonomy term used for scoping as parameter 4-->
							</xsl:call-template>
						</xsl:variable>
						<xsl:text>{"start": "</xsl:text><xsl:value-of select="$formattedStartDate"/><xsl:text>",
							"end": "</xsl:text><xsl:value-of select="$formattedEndDate"/><xsl:text>",</xsl:text>
						<xsl:text>"title": "</xsl:text><xsl:value-of select="$currentPlanName"/><xsl:text>",</xsl:text>
						"description": "<strong><xsl:value-of select="eas:i18n('Strategic Plan Summary')"/></strong><br/><xsl:value-of select="eas:renderJSText($currentPlanDescription)"/><br/><br/><strong>Start Date: </strong><xsl:value-of select="$displayStartDate"/><br/><strong>End Date: </strong><xsl:value-of select="$displayEndDate"/><xsl:text>",
							"link": "</xsl:text><xsl:value-of select="$linkURL"/><xsl:text>",
								"caption": "</xsl:text>change (Strategic Plan)<xsl:text>"
									},
									
								</xsl:text>
					</xsl:for-each>

				   	]
				   	}
				   
				   </script>


			</head>
			<body onload="onLoad();" onresize="onResize();">
				<!-- functions required for timeline-->
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div>
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
						</div>

						<!--Setup Roadmap Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="$roadmapName"/>
								</h2>
							</div>
							<p>
								<xsl:value-of select="$roadmapDesc"/>
							</p>
							<div>
								<div id="timeline1" style="border:1px solid #ddd"/>
								<!--add the special id for the timeline-->
							</div>
							<hr/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>






</xsl:stylesheet>
