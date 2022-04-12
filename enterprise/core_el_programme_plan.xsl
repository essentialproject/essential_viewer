<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Project', 'Programme')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
	<!-- 27.08.2016 JP  Created	 -->
	<!-- 27.08.2016 JMK protect text in javascript rendering using the isRenderAsJSString parameter	 -->

	<xsl:variable name="dateTypes" select="('Year', 'Quarter', 'Gregorian')"/>
	<xsl:variable name="allDates" select="/node()/simple_instance[type = $dateTypes]"/>
	<xsl:variable name="allQuarters" select="$allDates[type = 'Quarter']"/>

	<xsl:variable name="currentProgramme" select="/node()/simple_instance[name = $param1]"/>
	<!--<xsl:variable name="allRoadmapRelations" select="/node()/simple_instance[name = $currentProgramme/own_slot_value[slot_reference = 'contained_roadmap_relations']/value]"/>
	<xsl:variable name="allStrategicPlans" select="/node()/simple_instance[name = $allRoadmapRelations/own_slot_value[slot_reference = ':roadmap_strategic_plans']/value]"/>
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[name = $allStrategicPlans/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
	<xsl:variable name="allMilestones" select="/node()/simple_instance[(type = 'Roadmap_Milestone') and (name = $currentProgramme/own_slot_value[slot_reference = 'contained_roadmap_model_elements']/value)]"/>-->
	<xsl:variable name="allProjects" select="/node()/simple_instance[(name = $currentProgramme/own_slot_value[slot_reference = 'projects_for_programme']/value)]"/>
	<xsl:variable name="allProgrammeMilestones" select="/node()/simple_instance[name = ($allProjects, $currentProgramme)/own_slot_value[slot_reference = 'ca_milestones']/value]"/>
	<xsl:variable name="allProjectStatii" select="/node()/simple_instance[type = 'Project_Lifecycle_Status']"/>


	<xsl:variable name="DEBUG" select="''"/>

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
				<title>Roadmap Timeline</title>
				<script src="js/vis/vis.js"/>
				<link href="js/vis/vis.css" rel="stylesheet" type="text/css"/>
				<script>
					$(document).ready(function(){
						$('#lifecycleLegend').show();
						<!--$('#planProjectForm').click(function() {
							if($('#filterStratPlans').is(':checked')){
								$('#lifecycleLegend').hide();
							};
							if($('#filterProjects').is(':checked')){
								$('#lifecycleLegend').show();
							};
						});	-->
					});
				</script>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">

						<div class="col-xs-12">
							<h1 id="viewName">
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Programme Plan for')"/>&#160;</span>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$currentProgramme"/>
									<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
								</xsl:call-template>
								<xsl:value-of select="$DEBUG"/>
							</h1>
						</div>


						<!--Setup Description Section-->
						<div id="sectionDescription">
							<div class="col-xs-12">
								<div class="sectionIcon">
									<i class="fa fa-calendar icon-section icon-color"/>
								</div>
								<h2>Plan</h2>
								<div class="content-section">
									<p><xsl:value-of select="eas:i18n('This view illustrates the timeline for the projects that form the programme')"/><xsl:text> </xsl:text><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$currentProgramme"/></xsl:call-template>.</p>
								</div>
								<div class="verticalSpacer_10px"/>
								<div class="row">
									<div class="col-xs-12 col-sm-6">
										<xsl:call-template name="dateFilterSection"/>
									</div>
								</div>
								<div class="verticalSpacer_10px"/>
								<xsl:call-template name="roadmapLegend"/>
								<div class="verticalSpacer_20px"/>
								<xsl:call-template name="roadmapNavButtons"/>
								<div class="verticalSpacer_20px"/>
								<div id="visualization"/>
								<div class="verticalSpacer_20px"/>
								<xsl:call-template name="timeline"/>
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

	<xsl:template name="timeline">
		<style>
			.vis-item{
				cursor: pointer;
				border-color: #63A3EC;
				background-color: #91C7FB;
			}
			
			.vis-item .vis-item-overflow{
				overflow: visible;
			}<xsl:for-each select="$allProjectStatii">
				<xsl:variable name="currentStatus" select="current()"/>
				.<xsl:value-of select="lower-case(replace(current()/own_slot_value[slot_reference = 'name']/value, ' ', '-'))"/> {
					background-color: <xsl:value-of select="eas:get_element_style_colour($currentStatus)"/>;
					color: <xsl:value-of select="eas:get_element_style_textcolour($currentStatus)"/>;
					border-color: #666666;
				}<xsl:text>
					
				</xsl:text>
			</xsl:for-each>
			.vis-label.busLayer,
			.vis-label.appLayer,
			.vis-label.entLayer{
				background-color: #333;
			}
			
			.milestone{
				background-color: #333;
				font-weight: bold;
			}
			
			.vis-label.infLayer,
			.vis-label.techLayer{
				background-color: #666;
			}
			
			.vis-background .vis-group.infLayer,
			.vis-background .vis-group.techLayer{
				background-color: #eeeeee;
				opacity: 0.4;
			}
			
			.vis-label .vis-inner{
				font-size: 110%;
				color: #fff;
				font-weight: bold;
				text-transform: uppercase;
				margin-right: 5px;
				width: 150px;
			}
			
			.vis-major{
				font-weight: bold;
			}
			
			.vis-item.vis-dot{
				position: absolute;
				padding: 0;
				border-width: 4px;
				border-style: solid;
				border-radius: 10px;
				background-color: #33333;
			}</style>
		<script type="text/javascript">
		// create a dataset with items
    // we specify the type of the fields `start` and `end` here to be strings
    // containing an ISO date. The fields will be outputted as ISO dates
    // automatically getting data from the DataSet via items.get().
    
    $.arrayIntersect = function(a, b) {
	    return $.grep(a, function(i)
	    {
	        return $.inArray(i, b) > -1;
	    });
	};
    
    var projectItems = new vis.DataSet({
        type: { start: 'ISODate', end: 'ISODate' }
    });
   var groups = new vis.DataSet([
   		{id: 'PROGRAMME', content:'<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="$currentProgramme"/>
                <xsl:with-param name="anchorClass">text-white</xsl:with-param>
            </xsl:call-template>', className: 'entLayer'}
    ]);
    
    // add items to the Project DataSet
    projectItems.add([
    	<xsl:apply-templates mode="RenderProject" select="$allProjects">
			<xsl:with-param name="parentProgrammeId" select="'PROGRAMME'"/>
		</xsl:apply-templates>
		<xsl:if test="count($allProjects) > 0">,
		</xsl:if>
		<xsl:apply-templates mode="RenderMilestones" select="$allProgrammeMilestones">
			<xsl:with-param name="parentProgrammeId" select="'PROGRAMME'"/>
		</xsl:apply-templates>
    ]);
            
var today = new Date();
    var container = document.getElementById('visualization');
    var options = {
    	start: moment().subtract(6, 'months'),
        end: moment().add(18, 'months'),
        editable: false,
        selectable: false,
        stack: true,
        orientation: {axis: 'both'},
  	 	zoomMin: 1000 * 60 * 60 * 24 * 31, //minimum of 1 month inmilliseconds
		zoomMax: 1000 * 60 * 60 * 24 * 356 * 3 //maximum of 3 years inmilliseconds
    };

	// default to projects
	var items = projectItems;
    var timeline = new vis.Timeline(container, items, groups, options);
    
    timeline.on('click', function (properties) {
      var itemId = properties.item;
      if(itemId != null) {
      
      		var itemObject = items.get({
                       
				    filter: function(item) {
				       return (item.id == itemId);
				    }
			    })
			
		  var triggerId = '#trigger' + itemId;
		  var popoverId = '#popover' + itemId;
		  var popupContent = itemObject.popupContent;
		  	/* Popover*/
			$(triggerId).popover({
				container: 'body',
				html: true,
				trigger: 'click',
				placement: 'right',
				content: itemObject[0].popupContent
			});
	 }
	});
    
    document.getElementById('fit').onclick = function() {timeline.fit();}
    document.getElementById('moveLeft').onclick  = function () { move( 0.2); };
    document.getElementById('moveRight').onclick = function () { move(-0.2); };;
    /**
     * Move the timeline a given percentage to left or right
     * @param {Number} percentage   For example 0.1 (left) or -0.1 (right)
     */
    function move (percentage) {
        var range = timeline.getWindow();
        var interval = range.end - range.start;

        timeline.setWindow({
            start: range.start.valueOf() - interval * percentage,
            end:   range.end.valueOf()   - interval * percentage
        });
    }

    /**
     * Zoom the timeline a given percentage in or out
     * @param {Number} percentage   For example 0.1 (zoom out) or -0.1 (zoom in)
     */
    function zoom (percentage) {
        var range = timeline.getWindow();
        var interval = range.end - range.start;

        timeline.setWindow({
            start: range.start.valueOf() - interval * percentage,
            end:   range.end.valueOf()   + interval * percentage
        });
    }
    
			
	var startDateFilter = document.getElementById('startDateFilter');
	var endDateFilter = document.getElementById('endDateFilter');
	// var stratPlanFilter = document.getElementById('filterStratPlans');
	// var projectFilter = document.getElementById('filterProjects');
	var lifecycleLegend = document.getElementById('lifecycleLegend');
    
    //A common filter functon that checks the status of each checkbox and incrementally applies  filters
     var filterFunction = function() {
     		var list;
     		var newList;
     		var layerList = [];
	     		
	   		items = projectItems;
	   		$('.lifecycleLegend').show();
	   		list = items;
	   		
	   		
	   		var startFilterDate = startDateFilter.value;
	     	if(startFilterDate != "ALL") {
	    		list = list.get({
				    filter: function(item) {
				       return (item.start &gt;= startFilterDate);
				    }
			    })											
		    } else {
		    	list = list.get({
				    filter: function(item) {
				       return (true);
				    }
			    })											    
			}			
			
			newList = new vis.DataSet(list);
			var endFilterDate = endDateFilter.value;
	     	if(endFilterDate != "ALL") {
	    		list = newList.get({
				    filter: function(item) {
				       return (item.end &lt;= endFilterDate);
				    }
			    })											
		    } else {
		    	list = newList.get({
				    filter: function(item) {
				       return (true);
				    }
			    })											    
			}	
			newList = new vis.DataSet(list);

			
		    timeline.setData({
			  groups: groups,
			  items: newList
			})
    };
    
  
		startDateFilter.onchange = filterFunction;
		endDateFilter.onchange = filterFunction;
		//stratPlanFilter.onchange = filterFunction;
		//projectFilter.onchange = filterFunction;
		
		$(window).bind("pageshow", filterFunction);
	
	</script>
	</xsl:template>



	<xsl:template mode="RenderProject" match="node()">
		<xsl:param name="parentProgrammeId"/>
		<xsl:variable name="project" select="current()"/>
		<xsl:variable name="projectId" select="concat($parentProgrammeId, '-', $project/name)"/>
		<xsl:variable name="projectName" select="$project/own_slot_value[slot_reference = 'name']/value"/>
		
		<xsl:variable name="proposedISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>
		<xsl:variable name="proposedEssStartDateId" select="$project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value"/>
		<xsl:variable name="jsProposedStartDate">
			<xsl:choose>
				<xsl:when test="string-length($proposedISOStartDate) > 0">
					<xsl:value-of select="xs:date($proposedISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectPlannedStartDate" select="$allDates[name = $proposedEssStartDateId]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($projectPlannedStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="actualISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>
		<xsl:variable name="actualEssStartDateId" select="$project/own_slot_value[slot_reference = 'ca_actual_start_date']/value"/>
		<xsl:variable name="jsActualStartDate">
			<xsl:choose>
				<xsl:when test="string-length($actualISOStartDate) > 0">
					<xsl:value-of select="xs:date($actualISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectActualStartDate" select="$allDates[name = $actualEssStartDateId]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($projectActualStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="jsStartDate">
			<xsl:choose>
				<xsl:when test="(count($actualISOStartDate) + count($actualEssStartDateId) > 0)"><xsl:value-of select="$jsActualStartDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$jsProposedStartDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="targetISOEndDate" select="$project/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>
		<xsl:variable name="targetEssEndDateId" select="$project/own_slot_value[slot_reference = 'ca_target_end_date']/value"/>
		<xsl:variable name="jsTargetEndDate">
			<xsl:choose>
				<xsl:when test="string-length($targetISOEndDate) > 0">
					<xsl:value-of select="xs:date($targetISOEndDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectTargetEndDate" select="$allDates[name = $targetEssEndDateId]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="forecastISOEndDate" select="$project/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>
		<xsl:variable name="forecastEssEndDateId" select="$project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value"/>
		<xsl:variable name="jsForecastEndDate">
			<xsl:choose>
				<xsl:when test="string-length($forecastISOEndDate) > 0">
					<xsl:value-of select="xs:date($forecastISOEndDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectForecastEndDate" select="$allDates[name = $forecastEssEndDateId]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($projectForecastEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="jsEndDate">
			<xsl:choose>
				<xsl:when test="(count($forecastISOEndDate) + count($forecastEssEndDateId) > 0)"><xsl:value-of select="$jsForecastEndDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$jsTargetEndDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--<xsl:variable name="projectPlannedStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value]"/>
		<xsl:variable name="jsPlannedStartDate" select="eas:get_start_date_for_essential_time($projectPlannedStartDate)"/>
		<xsl:variable name="projectActualStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
		<xsl:variable name="jsActualStartDate" select="eas:get_start_date_for_essential_time($projectActualStartDate)"/>
		<xsl:variable name="jsStartDate">
			<xsl:choose>
				<xsl:when test="count($projectActualStartDate) > 0"><xsl:value-of select="$jsActualStartDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$jsPlannedStartDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="projectTargetEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
		<xsl:variable name="jsTargetEndDate" select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>
		<xsl:variable name="projectForecastEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value]"/>
		<xsl:variable name="jsForecastEndDate" select="eas:get_end_date_for_essential_time($projectForecastEndDate)"/>
		<xsl:variable name="jsEndDate">
			<xsl:choose>
				<xsl:when test="count($projectForecastEndDate) > 0"><xsl:value-of select="$jsForecastEndDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$jsTargetEndDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>-->
		
		
		
		<xsl:variable name="projectStatus" select="$allProjectStatii[name = $project/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>
		<xsl:variable name="projectStatusClass" select="lower-case(replace($projectStatus/own_slot_value[slot_reference = 'name']/value, ' ', '-'))"/>
		{id: '<xsl:value-of select="$projectId"/>', content: '<span class="popupTrigger"><xsl:attribute name="id" select="concat('trigger', $projectId)"/><xsl:value-of select="eas:renderJSText($projectName)"/></span>'<xsl:choose><xsl:when test="(count($proposedISOStartDate) + count($proposedEssStartDateId) + count($actualISOStartDate) + count($actualEssStartDateId) + count($targetISOEndDate) + count($targetEssEndDateId) + count($forecastISOEndDate) + count($forecastEssEndDateId) > 0)">, start: '<xsl:value-of select="$jsStartDate"/>', end: '<xsl:value-of select="$jsEndDate"/>'</xsl:when><xsl:otherwise>, start: new Date(), end: new Date()</xsl:otherwise></xsl:choose>,group:'<xsl:value-of select="$parentProgrammeId"/>', <!--subgroup: '<xsl:value-of select="$parentProgrammeId"/>',--> className: '<xsl:value-of select="$projectStatusClass"/>', projectStatus: '<xsl:value-of select="$projectStatus/name"/>', popupContent:'<xsl:call-template name="projectPopupDiv"><xsl:with-param name="project" select="$project"/><xsl:with-param name="projectId" select="$projectId"/><xsl:with-param name="lifecycleStatus" select="$projectStatus"/><xsl:with-param name="plannedStartDate" select="$jsProposedStartDate"/><xsl:with-param name="actualStartDate" select="$jsActualStartDate"/><xsl:with-param name="targetEndDate" select="$jsTargetEndDate"/><xsl:with-param name="forecastEndDate" select="$jsForecastEndDate"/></xsl:call-template>'}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

	<xsl:template mode="RenderMilestones" match="node()">
		<xsl:param name="parentProgrammeId"/>
		<xsl:variable name="milestone" select="current()"/>
		<xsl:variable name="milestoneId" select="concat($parentProgrammeId, '-', $milestone/name)"/>
		<xsl:variable name="milestoneName" select="$milestone/own_slot_value[slot_reference = 'name']/value"/>
		
		
		<xsl:variable name="milestoneISOStartDate" select="$milestone/own_slot_value[slot_reference = 'cm_date_iso_8601']/value"/>
		<xsl:variable name="milestonEsseStartDateId" select="$milestone/own_slot_value[slot_reference = 'cm_date']/value"/>
		<xsl:variable name="jsMilestoneStartDate">
			<xsl:choose>
				<xsl:when test="string-length($milestoneISOStartDate) > 0">
					<xsl:value-of select="xs:date($milestoneISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="milestoneStartDate" select="$allDates[name = $milestonEsseStartDateId]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($milestoneStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--<xsl:variable name="milestoneStartDate" select="$allDates[name = $milestone/own_slot_value[slot_reference = 'cm_date']/value]"/>-->
		
		{id: '<xsl:value-of select="$milestoneId"/>', content: '<span class="popupTrigger"><xsl:attribute name="id" select="concat('trigger', $milestoneId)"/><xsl:value-of select="eas:renderJSText($milestoneName)"/></span>', start: <xsl:choose><xsl:when test="count($milestoneISOStartDate) + count($milestonEsseStartDateId) > 0">'<xsl:value-of select="$jsMilestoneStartDate"/>'</xsl:when><xsl:otherwise>new Date()</xsl:otherwise></xsl:choose>, group:'<xsl:value-of select="$parentProgrammeId"/>', className: 'milestone', type: 'point', popupContent:'<xsl:call-template name="milestonePopupDiv"><xsl:with-param name="milestone" select="$milestone"/><xsl:with-param name="milestoneId" select="$milestoneId"/><xsl:with-param name="startDate" select="$jsMilestoneStartDate"/></xsl:call-template>'}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<xsl:template name="dateFilterSection">
		<div class="pull-left">
			<div class="pull-left text-primary">
				<strong>Filter Projects by Dates:</strong>
			</div>
			<div class="verticalSpacer_5px"/>
			<div class="pull-left">
				<strong>Start Date:</strong>
			</div>
			<div class="horizSpacer_10px pull-left"/>
			<form class="pull-left">
				<select id="startDateFilter" style="width: 80px;">
					<option selected="selected" value="ALL">All</option>
					<xsl:for-each select="$allQuarters">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="dateName" select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="dateString" select="eas:get_start_date_for_essential_time(current())"/>
						<option value="{$dateString}">
							<xsl:value-of select="$dateName"/>
						</option>
					</xsl:for-each>
				</select>
			</form>
			<div class="horizSpacer_20px pull-left"/>
			<div class="pull-left">
				<strong>End Date:</strong>
			</div>
			<div class="horizSpacer_10px pull-left"/>
			<form class="pull-left">
				<select id="endDateFilter" style="width: 80px;">
					<option selected="selected" value="ALL">All</option>
					<xsl:for-each select="$allQuarters">
						<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="dateName" select="own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="dateString" select="eas:get_end_date_for_essential_time(current())"/>
						<option value="{$dateString}">
							<xsl:value-of select="$dateName"/>
						</option>
					</xsl:for-each>
				</select>
			</form>
		</div>
	</xsl:template>

	<xsl:template name="roadmapNavButtons">
		<div class="pull-right" style="margin-top: -5px;">
			<button class="pull-left" id="moveLeft" style="width: 130px;">
				<xsl:value-of select="eas:i18n('Move Backwards')"/>
			</button>
			<div class="horizSpacer_10px pull-left"/>
			<button class="pull-left" id="moveRight" style="width: 130px;">
				<xsl:value-of select="eas:i18n('Move Forwards')"/>
			</button>
			<div class="horizSpacer_10px pull-left"/>
			<button class="pull-left" id="fit" style="width: 130px;">
				<xsl:value-of select="eas:i18n('Reset Zoom')"/>
			</button>
		</div>
	</xsl:template>

	<xsl:template name="roadmapLegend">

		<div class="keyContainer row" id="lifecycleLegend">
			<div class="col-xs-2">
				<div class="keyLabel text-primary"><xsl:value-of select="eas:i18n('Project Lifecycle Legend')"/>:</div>
			</div>
			<div class="verticalSpacer_5px"/>
			<div class="col-xs-10">
				<xsl:for-each select="$allProjectStatii">
					<xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/>
					<xsl:variable name="lifecycleStatusColour" select="eas:get_element_style_colour(current())"/>
					<div class="pull-left">
						<div class="keySampleWide">
							<xsl:attribute name="style" select="concat('background-color:', $lifecycleStatusColour)"/>
						</div>
						<div class="keySampleLabel">
							<xsl:value-of select="current()/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>


	<xsl:template name="projectPopupDiv">
		<xsl:param name="projectId"/>
		<xsl:param name="project"/>
		<xsl:param name="plannedStartDate"/>
		<xsl:param name="actualStartDate"/>
		<xsl:param name="targetEndDate"/>
		<xsl:param name="forecastEndDate"/>
		<xsl:param name="lifecycleStatus"/>

		<xsl:variable name="formattedPlannedStartDate">
			<xsl:choose>
				<xsl:when test="count($plannedStartDate) > 0">
					<xsl:call-template name="FullFormatDate">
						<xsl:with-param name="theDate" select="$plannedStartDate"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="formattedActualStartDate">
			<xsl:choose>
				<xsl:when test="count($actualStartDate) > 0">
					<xsl:call-template name="FullFormatDate">
						<xsl:with-param name="theDate" select="$actualStartDate"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="formattedTargetEndDate">
			<xsl:choose>
				<xsl:when test="count($targetEndDate) > 0">
					<xsl:call-template name="FullFormatDate">
						<xsl:with-param name="theDate" select="$targetEndDate"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="formattedForecastEndDate">
			<xsl:choose>
				<xsl:when test="count($forecastEndDate) > 0">
					<xsl:call-template name="FullFormatDate">
						<xsl:with-param name="theDate" select="$forecastEndDate"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div>
			<xsl:attribute name="id" select="concat('popup', $projectId)"/>
			<p class="fontBlack">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$project"/><xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$project"/><xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<strong>Planned Start Date: </strong>
				<xsl:value-of select="$formattedPlannedStartDate"/>
			</p>
			<p class="small">
				<strong>Actual Start Date: </strong>
				<xsl:value-of select="$formattedActualStartDate"/>
			</p>
			<p class="small">
				<strong>Target End Date: </strong>
				<xsl:value-of select="$formattedTargetEndDate"/>
			</p>
			<p class="small">
				<strong>Forecast End Date: </strong>
				<xsl:value-of select="$formattedForecastEndDate"/>
			</p>
			<xsl:variable name="lifecycleStatusColour" select="$lifecycleStatus/own_slot_value[slot_reference = 'enumeration_icon']/value"/>
			<div class="small">
				<strong>Lifecycle Status: </strong>
				<xsl:value-of select="$lifecycleStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				<div class="keySampleWide">
					<xsl:attribute name="style" select="concat('background-color:', $lifecycleStatusColour)"/>
				</div>
			</div>

		</div>
	</xsl:template>

	<xsl:template name="milestonePopupDiv">
		<xsl:param name="milestoneId"/>
		<xsl:param name="milestone"/>
		<xsl:param name="startDate"/>


		<xsl:variable name="formattedStartDate">
			<xsl:call-template name="FullFormatDate">
				<xsl:with-param name="theDate" select="$startDate"/>
			</xsl:call-template>
		</xsl:variable>
		<div>
			<xsl:attribute name="id" select="concat('popup', $milestoneId)"/>
			<p class="fontBlack">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$milestone"/><xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$milestone"/><xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<strong>Date: </strong>
				<xsl:value-of select="$formattedStartDate"/>
			</p>

		</div>
	</xsl:template>

</xsl:stylesheet>
