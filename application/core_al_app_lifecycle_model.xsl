<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- theURLPrefix = the full context path for the current page -->
	<xsl:param name="theURLPrefix"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('License', 'Application_Provider', 'Project')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Define the full path names for the patterned images used for non-approved/potential activities -->
	<xsl:variable name="strategicProjectPatternFile" select="'red_stripe.png'"/>
	<xsl:variable name="strategicProjectColour" select="'#F20039'"/>

	<xsl:variable name="enhancementPatternFile" select="'orange_stripe.png'"/>
	<xsl:variable name="enhancementProjectColour" select="'#F08B26'"/>

	<xsl:variable name="operationalProjectPatternFile" select="'green_stripe.png'"/>
	<xsl:variable name="operationalProjectColour" select="'#12A626'"/>

	<xsl:variable name="technicalUpgradePatternFile" select="'blue_stripe.png'"/>
	<xsl:variable name="technicalUpgradeColour" select="'#1642C7'"/>

	<xsl:variable name="serviceReviewPatternFile" select="'brown_stripe.png'"/>
	<xsl:variable name="serviceImprovementColour" select="'#6C0003'"/>

	<xsl:variable name="strategicProjectPatternFullPath" select="concat($theURLPrefix, 'images/', $strategicProjectPatternFile)"/>
	<xsl:variable name="enhancementPatternFullPath" select="concat($theURLPrefix, 'images/', $enhancementPatternFile)"/>
	<xsl:variable name="operationalProjectPatternFullPath" select="concat($theURLPrefix, 'images/', $operationalProjectPatternFile)"/>
	<xsl:variable name="technicalUpgradePatternFullPath" select="concat($theURLPrefix, 'images/', $technicalUpgradePatternFile)"/>
	<xsl:variable name="serviceReviewPatternFullPath" select="concat($theURLPrefix, 'images/', $serviceReviewPatternFile)"/>

	<!-- Define the full path name for the license renewal icon -->
	<xsl:variable name="licenseRenewalImageFile" select="'warning_dollar.png'"/>
	<xsl:variable name="licenseRenewalImagePath" select="concat($theURLPrefix, 'images/', $licenseRenewalImageFile)"/>

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


	<!--  SET THE VIEW SPECIFIC VARIABLES -->
	<xsl:variable name="currentApp" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="appName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="appDesc" select="$currentApp/own_slot_value[slot_reference = 'description']/value"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>System Lifecycle Plan - <xsl:value-of select="$appName"/></title>
				<script type="text/javascript">
				<![CDATA[
					Timeline_ajax_url = "js/timeline_ajax/simile-ajax-api.js";
					Timeline_urlPrefix = 'js/timeline_js/';
					Timeline_parameters = 'bundle=true';//]]>
				</script>

				<script src="js/timeline_js/timeline-api.js" type="text/javascript"/>
			</head>
			<body onload="onLoad();" onresize="onResize();">
				<!-- ADD THE PAGE HEADING -->
				<xsl:variable name="parentPortalHome" select="eas:get_report_by_name('AZ: ALCM Portal Home')"/>
				<xsl:call-template name="Heading">
					<xsl:with-param name="subPortalID" select="$parentPortalHome/name"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">System Lifecycle Plan for </span>
									<span class="text-primary">
										<xsl:value-of select="$appName"/>
									</span>
								</h1>
							</div>
						</div>
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-calendar icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">Lifeycle View</h2>
							</div>
							<div class="content-section">
								<p>This view compares the lifecycle of a Solution Architecture with the relevant Strategic Plan and supporting Technology Products.</p>
								<xsl:call-template name="Index"/>
								<div class="multiKeyContainerFullWidth">
									<div id="keyContainer">
										<div class="keyLabel uppercase" style="height:35px;width:200px;">Strategic Projects:</div>

										<div class="pull-left" style="height:35px;width:300px;">
											<div>
												<div class="keySampleWide" style="background-color:#f20039;"/>
												<div class="keySampleLabel">Strategic Initiative (In-Flight)</div>
											</div>
											<div class="clear"/>
											<div>
												<div class="keySampleWide" style="background:url(images/red_stripe.png);"/>
												<div class="keySampleLabel">Strategic Initiative (Planned)</div>
											</div>

										</div>
										<div class="pull-left" style="height:35px;width:300px;">
											<div>
												<div class="keySampleWide" style="background-color:#f08b26;"/>
												<div class="keySampleLabel">Enhancements (Approved)</div>
											</div>
											<div class="clear"/>
											<div>
												<div class="keySampleWide" style="background:url(images/orange_stripe.png);"/>
												<div class="keySampleLabel">Enhancements (To Be Approved)</div>
											</div>
										</div>
										<div class="clear"/>
										<div class="keyLabel uppercase" style="height:35px;width:200px;">Operational Projects:</div>
										<div class="pull-left" style="height:35px;width:300px;">
											<div>
												<div class="keySampleWide backColourGreen" style="background-color:#12a626;"/>
												<div class="keySampleLabel">Operational Initiative (In-Flight)</div>
											</div>
											<div class="clear"/>
											<div>
												<div class="keySampleWide" style="background:url(images/green_stripe.png);"/>
												<div class="keySampleLabel">Operational Initiative (Planned)</div>
											</div>

										</div>
										<div class="pull-left" style="height:35px;width:300px;">
											<div>
												<div class="keySampleWide backColourBlue" style="background-color:#1642c7;"/>
												<div class="keySampleLabel">Technical Upgrade (Approved)</div>
											</div>
											<div class="clear"/>
											<div>
												<div class="keySampleWide" style="background:url(images/blue_stripe.png);"/>
												<div class="keySampleLabel">Technical Upgrade (To Be Approved)</div>
											</div>
										</div>
										<div class="pull-left" style="height:35px;width:300px;">
											<div>
												<div class="keySampleWide" style="background-color:#6c0003;"/>
												<div class="keySampleLabel">Service Improvements</div>
											</div>
											<div class="clear"/>
											<div>
												<div class="keySampleWide" style="background:url(images/brown_stripe.png);"/>
												<div class="keySampleLabel">Service Review</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="verticalSpacer_20px"/>
							<div>
								<script type="text/javascript">        
	        						<![CDATA[
								var tl;
								function onLoad()
								{
									SimileAjax.History.enabled = false;
									var tl_el = document.getElementById("tl");
									var theme1 = Timeline.ClassicTheme.create();
									theme1.autoWidth = true;
									// Set the Timeline's "width" automatically.
									// Set autoWidth on the Timeline's first band's theme,
									// will affect all bands.
									theme1.timeline_start = new Date(Date.UTC(2008, 0, 1));
									theme1.timeline_stop = new Date(Date.UTC(2030, 0, 1));
									theme1.event.tape.height = 7;
									theme1.event.track.height = theme1.event.tape.height + 5;
									var theme2 = Timeline.ClassicTheme.create();
									theme2.autoWidth = true;
									// Set the Timeline's "width" automatically.
									// Set autoWidth on the Timeline's first band's theme,
									// will affect all bands.
									theme2.timeline_start = new Date(Date.UTC(2008, 0, 1));
									theme2.ether.highlightColor = '#fff00';
									theme2.ether.interval.line.show = true;
									theme2.ether.interval.line.color = '#fff00';
									var eventSource1 = new Timeline.DefaultEventSource();
									var eventSource2 = new Timeline.DefaultEventSource();
									var eventSource3 = new Timeline.DefaultEventSource();
									var eventSource4 = new Timeline.DefaultEventSource();
									var bandInfos =[
									Timeline.createBandInfo(
									{
										width: '45', // set to a minimum, autoWidth will then adjust
										intervalUnit: Timeline.DateTime.MONTH,
										multiple: 1,
										intervalPixels: 35,
										eventSource: eventSource1,
										theme: theme1,
										startdate: "2013-01-01",
										layout: 'original' // original, overview, detailed
									}),
									Timeline.createBandInfo(
									{
										width: '100%', // set to a minimum, autoWidth will then adjust
										intervalUnit: Timeline.DateTime.MONTH,
										multiple: 1,
										intervalPixels: 35,
										eventSource: eventSource2,
										theme: theme1,
										startdate: "2013-01-01",
										layout: 'original' // original, overview, detailed
									}),
									Timeline.createBandInfo(
									{
										width: '55', // set to a minimum, autoWidth will then adjust
										intervalUnit: Timeline.DateTime.MONTH,
										multiple: 1,
										intervalPixels: 35,
										eventSource: eventSource3,
										theme: theme1,
										startdate: "2013-01-01",
										layout: 'original' // original, overview, detailed
									}),
									Timeline.createBandInfo(
									{
										width: '35%', // set to a minimum, autoWidth will then adjust
										intervalUnit: Timeline.DateTime.YEAR,
										multiple: 1,
										intervalPixels: 35,
										eventSource: eventSource1,
										theme: theme2,
										startdate: "2013-01-01",
										layout: 'overview' // original, overview, detailed
									})];
									bandInfos[1].syncWith = 0;
									bandInfos[2].syncWith = 0;
									bandInfos[3].syncWith = 0;
									bandInfos[3].highlight = true;
									bandInfos[0].decorators =[
									new Timeline.SpanHighlightDecorator(
									{
										startDate: "2012-11-01",
										endDate: "2012-11-01",
										color: "#FFC080", // set color explicitly
										opacity: 10,
										startLabel: "Strategic Projects",
										theme: theme1
									})];
									bandInfos[1].decorators =[
									new Timeline.SpanHighlightDecorator(
									{
										startDate: "2012-11-01",
										endDate: "2012-11-01",
										color: "#FFC080", // set color explicitly
										opacity: 10,
										startLabel: "Operational Projects",
										theme: theme1
									})];
									bandInfos[2].decorators =[
									new Timeline.SpanHighlightDecorator(
									{
										startDate: "2012-11-01",
										endDate: "2012-11-01",
										color: "#FFC080", // set color explicitly
										opacity: 10,
										startLabel: "License Renewals",
										theme: theme1
									})];
									// create the Timeline
									tl = Timeline.create(tl_el, bandInfos, Timeline.HORIZONTAL);
									var url = '.';
									// The base url for image, icon and background image
									// references in the data
									eventSource1.loadJSON(timeline_data_1, document.location.href);
									// The data was stored into the 	                                                       					  // timeline_data variable.
									eventSource2.loadJSON(timeline_data_3, document.location.href);
									eventSource3.loadJSON(timeline_data_2, document.location.href);
									tl.layout();
									// display the Timeline
								}
								var resizeTimerID = null;
								function onResize()
								{
									if (resizeTimerID == null)
									{
										resizeTimerID = window.setTimeout(function ()
										{
											resizeTimerID = null;
											tl.layout();
										},
										500);
									}
								}//]]>
	  								 </script>


								<!--	   The following script is the event data for the timeline-->
								<script type="text/javascript">
                                        var timeline_data_1 = {
                                            // save as a global variable
                                            'dateTimeFormat': 'iso8601',
                                            
                                            'events':[ 
                                            {
                                                'start': '2012-01-01',
                                                'end': '2012-06-01',
                                                'title': 'Strategic Project 1',
                                                'description': 'Description Goes Here',
                                                'color': '<xsl:value-of select="$strategicProjectColour"/>'
                                            }, {
                                                'start': '2012-06-01',
                                                'end': '2013-02-01',
                                                'title': 'Strategic Project 2',
                                                'description': 'Description Goes Here Again',
                                                'tapeImage': '<xsl:value-of select="$strategicProjectPatternFullPath"/>',
        										'tapeRepeat': 'repeat-x',
        										'color': '<xsl:value-of select="$strategicProjectColour"/>'
                                            }, {
                                                'start': '2013-02-01',
                                                'end': '2013-08-01',
                                                'title': 'Enhancement Project 1',
                                                'description': 'Description Goes Here',
                                                'tapeImage': '<xsl:value-of select="$enhancementPatternFullPath"/>',
        										'tapeRepeat': 'repeat-x',
        										'color': '<xsl:value-of select="$enhancementProjectColour"/>'
                                            }, {
                                                'start': '2013-08-01',
                                                'end': '2014-12-01',
                                                'title': 'Enhancement Project 2',
                                                'description': 'Description Goes Here',
        										'color': '<xsl:value-of select="$enhancementProjectColour"/>'
                                            }
                                            ]
                                        }
	   								</script>
								<!--	   The following script is the event data for the timeline-->
								<script type="text/javascript">
                                        var timeline_data_2 = {
                                            // save as a global variable
                                            'dateTimeFormat': 'iso8601',
                                            
                                            'events':[ 
                                            {
                                                'start': '2012-06-01',
                                                'title': 'Tech Product 1',
                                                'icon': '<xsl:value-of select="$licenseRenewalImagePath"/>',
                                                'description': 'License renewal for Tech Product 1',											
                                            },                                           
                                            {
                                                'start': '2013-07-01',
                                                'title': 'Tech Product 2',
                                                 'icon': '<xsl:value-of select="$licenseRenewalImagePath"/>',
                                                'description': 'License renewal for Tech Product 2',
                                            },
                                            {
                                                'start': '2014-03-01',
                                                'title': 'Tech Product 3',
                                                 'icon': '<xsl:value-of select="$licenseRenewalImagePath"/>',
                                                'description': 'License renewal for Tech Product 3',
                                            }
                                            ]
                                        }
					   </script>
								<script type="text/javascript">
						    var timeline_data_3 = {
						        // save as a global variable
						        'dateTimeFormat': 'iso8601',
						        
						        'events':[ 
						        {
						            'start': '2011-12-01',
						            'end': '2012-06-01',
						            'title': 'Operational Project 1',
						            'description': 'Description Goes Here',
						            'tapeImage': '<xsl:value-of select="$operationalProjectPatternFullPath"/>',
        							'tapeRepeat': 'repeat-x',
        							'color': '<xsl:value-of select="$operationalProjectColour"/>'
						        },
						        {
						            'start': '2012-06-01',
						            'end': '2012-12-01',
						            'title': 'Operational Project 2',
						            'description': 'Description Goes Here',
        							'color': '<xsl:value-of select="$operationalProjectColour"/>'
						        },
						        {
						            'start': '2012-12-01',
						            'end': '2013-03-01',
						            'title': 'Technical Upgrade Project 1',
						            'description': 'Description Goes Here',
						            'tapeImage': '<xsl:value-of select="$technicalUpgradePatternFullPath"/>',
        							'tapeRepeat': 'repeat-x',
        							'color': '<xsl:value-of select="$technicalUpgradeColour"/>'
						        },
						        {
						            'start': '2013-06-01',
						            'end': '2014-01-01',
						            'title': 'Technical Upgrade Project 2',
						            'description': 'Description Goes Here',
        							'color': '<xsl:value-of select="$technicalUpgradeColour"/>'
						        },
						        {
						            'start': '2013-04-01',
						            'end': '2013-05-01',
						            'title': 'Service Review',
						            'description': 'Description Goes Here',
						            'tapeImage': '<xsl:value-of select="$serviceReviewPatternFullPath"/>',
        							'tapeRepeat': 'repeat-x',
        							'color': '<xsl:value-of select="$serviceImprovementColour"/>'
						        },
						        {
						            'start': '2013-11-01',
						            'end': '2014-03-01',
						            'title': 'Service Improvement Project',
						            'description': 'Description Goes Here',
        							'color': '<xsl:value-of select="$serviceImprovementColour"/>'
						        }]
						    }
	   				</script>

								<div id="tl"/>
								<!--add the special id for the timeline-->
							</div>
						</div>

					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="Index"> </xsl:template>

</xsl:stylesheet>
