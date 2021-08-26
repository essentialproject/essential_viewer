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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Project', 'Business_Strategic_Plan', 'Application_Strategic_Plan', 'Information_Strategic_Plan', 'Technology_Strategic_Plan', 'Enterprise_Strategic_Plan', 'Roadmap_Model')"/>
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
	<!-- 15.08.2016 JP  Created	 -->
	<!-- 15.06.2018 JMK  Protect texts in javascript	 -->
	<!-- 07.02.2019 JP  Updated to support simplified Roadmap modelling approach	 -->

	<xsl:variable name="dateTypes" select="('Year', 'Quarter', 'Gregorian')"/>
	<xsl:variable name="allDates" select="/node()/simple_instance[type = $dateTypes]"/>
	<xsl:variable name="allQuarters" select="$allDates[type = 'Quarter']"/>

	<xsl:variable name="currentRoadmap" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="allRoadmapRelations" select="/node()/simple_instance[name = $currentRoadmap/own_slot_value[slot_reference = 'contained_roadmap_relations']/value]"/>
	<xsl:variable name="allStrategicPlans" select="/node()/simple_instance[name = ($allRoadmapRelations, $currentRoadmap)/own_slot_value[slot_reference = (':roadmap_strategic_plans', 'roadmap_strategic_plans')]/value][count(own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value)&gt;0]"/>
	<xsl:variable name="allStrategicPlanRels" select="/node()/simple_instance[name = $allStrategicPlans/own_slot_value[slot_reference = ('strategic_plan_for_elements', 'strategic_plan_for_element')]/value]"/>
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[name = $allStrategicPlans/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
	<xsl:variable name="allMilestones" select="/node()/simple_instance[(type = 'Roadmap_Milestone') and (name = $currentRoadmap/own_slot_value[slot_reference = 'contained_roadmap_model_elements']/value)]"/>
	<xsl:variable name="allArchStates" select="/node()/simple_instance[name = ($allMilestones, $currentRoadmap)/own_slot_value[slot_reference = ('milestone_architecture_state', 'roadmap_architecture_states')]/value][count(own_slot_value[slot_reference='end_date_iso_8601']/value) > 0]"/>
	<xsl:variable name="allDirectProjects" select="/node()/simple_instance[(type = 'Project') and (name = $allStrategicPlans/own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value)][own_slot_value[slot_reference = ('ca_target_end_date_iso_8601', 'ca_forecast_end_date_iso_8601')]/value]"/>
	<xsl:variable name="allProjectsViaPlanRels" select="/node()/simple_instance[name = $allStrategicPlanRels/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value][own_slot_value[slot_reference = ('ca_target_end_date_iso_8601', 'ca_forecast_end_date_iso_8601')]/value]"/>
	<xsl:variable name="allProjects" select="$allDirectProjects union $allProjectsViaPlanRels"/>
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
				<link rel="stylesheet" href="js/jquery.qtip.min.css"/>
				<script src="js/jquery.qtip.min.js"/>
				<script>
					$(document).ready(function(){
						$('#lifecycleLegend').hide();
						$('#planProjectForm').click(function() {
							if($('#filterStratPlans').is(':checked')){
								$('#lifecycleLegend').hide();
							};
							if($('#filterProjects').is(':checked')){
								$('#lifecycleLegend').show();
							};
						});				
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
								<span class="text-darkgrey">Roadmap Timeline for </span>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$currentRoadmap"/>
									<xsl:with-param name="isRenderAsJSString" select="true()"/>
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
								<h2>Roadmap</h2>
								<div class="content-section">
									<p><xsl:value-of select="eas:i18n('This view illustrates the timeline for the strategic plans/projects  of the roadmap')"/><xsl:text> </xsl:text><xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$currentRoadmap"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>.</p>
									<!--<button id="filterToggle" class="pull-right" style="width: 130px;"><span>Show</span> Filters</button>-->
								</div>
								<!--<script>
									$(document).ready(function(){
										$('.filterContainer').hide();
										$('.lifecycleLegend').hide();
										$('#filterToggle').click(function(){
											$('.filterContainer').slideToggle();
											$('span',this).text(function(i,txt) {return txt === "Hide" ? "Show" : "Hide";});
										});
									});
								</script>-->
								<div class="verticalSpacer_10px"/>
								<div class="row          ">
									<div class="col-xs-12 col-sm-6">
										<xsl:call-template name="roadmapLayerFilter"/>
										<div class="verticalSpacer_15px"/>
									</div>
									<div class="col-xs-12 col-sm-6">
										<xsl:call-template name="roadmapFilterSection"/>
									</div>
								</div>
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
			
			.archState{
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
    
    var stratPlanItems = new vis.DataSet({
        type: { start: 'ISODate', end: 'ISODate' }
    });
    var projectItems = new vis.DataSet({
        type: { start: 'ISODate', end: 'ISODate' }
    });
    var groups = new vis.DataSet([
   		{id: 'ROADMAP', content:'<xsl:call-template name="RenderInstanceLink"><xsl:with-param name="theSubjectInstance" select="$currentRoadmap"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="anchorClass">text-white</xsl:with-param></xsl:call-template>', className: 'entLayer'}
    ]);
    // add items to the Strategic Plan DataSet
    stratPlanItems.add([
    	<xsl:apply-templates mode="RenderStrategicPlan" select="$allStrategicPlans">
			<xsl:with-param name="parentRoadmapId" select="'ROADMAP'"/>
		</xsl:apply-templates>
		<xsl:if test="count($allStrategicPlans) > 0">,
		</xsl:if>
		<xsl:apply-templates mode="RenderArchStates" select="$allArchStates">
			<xsl:with-param name="parentRoadmapId" select="'ROADMAP'"/>
		</xsl:apply-templates>
    ]);
    
    // add items to the Project DataSet
    projectItems.add([
    	<xsl:apply-templates mode="RenderProject" select="$allProjects">
			<xsl:with-param name="parentRoadmapId" select="'ROADMAP'"/>
		</xsl:apply-templates>
		<xsl:if test="count($allProjects) > 0">,
		</xsl:if>
		<xsl:apply-templates mode="RenderArchStates" select="$allArchStates">
			<xsl:with-param name="parentRoadmapId" select="'ROADMAP'"/>
		</xsl:apply-templates>
    ]);

    var container = document.getElementById('visualization');
    var options = {
        editable: false,
        selectable: false,
        stack: true,
        orientation: {axis: 'both'},
  	 	zoomMin: 1000 * 60 * 60 * 24 * 31, //minimum of 1 month inmilliseconds
		zoomMax: 1000 * 60 * 60 * 24 * 356 * 3 //maximum of 3 years inmilliseconds
    };

	// default to strategic plans
	var items = stratPlanItems;
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
		  var popupContent = itemObject.popupContent;
		  $(triggerId).qtip({
	        content: {
	            text: itemObject[0].popupContent // Use the "div" element next to the span trigger
	        },
	        style: { classes: 'qtip-bootstrap' },
	        show: 'click',
	        hide: 'unfocus',
	        position: {
		        adjust: {
		            x: -10,
		            y: -10
		        }
		      }
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
	var stratPlanFilter = document.getElementById('filterStratPlans');
	var projectFilter = document.getElementById('filterProjects');
	var lifecycleLegend = document.getElementById('lifecycleLegend');
    
    //A common filter functon that checks the status of each checkbox and incrementally applies  filters
     var filterFunction = function() {
     		var list;
     		var newList;
     		var layerList = [];
	     		
	   		if($('input[name="displayType"]:checked').val() == "stratPlans") {
	   			items = stratPlanItems;
	   			$('.lifecycleLegend').hide();
	   		} else {
	   			items = projectItems;
	   			$('.lifecycleLegend').show();
	   		}
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
				      if(item.className == "archState") {
				       		return (item.start &lt;= endFilterDate);
				       	}
				    	else {
				    		return (item.end &lt;= endFilterDate);
				    	}
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
		stratPlanFilter.onchange = filterFunction;
		projectFilter.onchange = filterFunction;
		
		$(window).bind("pageshow", filterFunction);
	
	</script>
	</xsl:template>



	<xsl:template mode="RenderStrategicPlan" match="node()">
		<xsl:param name="parentRoadmapId"/>
		<xsl:variable name="strategicPlan" select="current()"/>
		<xsl:variable name="strategicPlanId" select="concat($parentRoadmapId, '-', $strategicPlan/name)"/>
		<xsl:variable name="strategicPlanName" select="$strategicPlan/own_slot_value[slot_reference = 'name']/value"/>
		
		<xsl:variable name="strategicPlanISOStartDate" select="$strategicPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
		<xsl:variable name="jsStartDate">
			<xsl:choose>
				<xsl:when test="string-length($strategicPlanISOStartDate) > 0">
					<xsl:value-of select="xs:date($strategicPlanISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="strategicPlanStartDate" select="$allDates[name = $strategicPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($strategicPlanStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="strategicPlanISOEndDate" select="$strategicPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
		<xsl:variable name="jsEndDate">
			<xsl:choose>
				<xsl:when test="string-length($strategicPlanISOEndDate) > 0">
					<xsl:value-of select="xs:date($strategicPlanISOEndDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="strategicPlanEndDate" select="$allDates[name = $strategicPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($strategicPlanEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<!--<xsl:variable name="strategicPlanStartDate" select="$allDates[name = $strategicPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value]"/>
		<xsl:variable name="jsStartDate" select="eas:get_start_date_for_essential_time($strategicPlanStartDate)"/>
		<xsl:variable name="strategicPlanEndDate" select="$allDates[name = $strategicPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value]"/>
		<xsl:variable name="jsEndDate" select="eas:get_end_date_for_essential_time($strategicPlanEndDate)"/>-->
		<xsl:variable name="strategicPlanningAction" select="$allPlanningActions[name = $strategicPlan/own_slot_value[slot_reference = 'strategic_planning_action']/value]"/>
		<xsl:variable name="planningActionClass" select="lower-case($strategicPlanningAction/own_slot_value[slot_reference = 'enumeration_value']/value)"/>
		{
			id: '<xsl:value-of select="$strategicPlanId"/>',
			content: '<span class="popupTrigger"><xsl:attribute name="id" select="concat('trigger', $strategicPlanId)"/><xsl:value-of select="eas:renderJSText($strategicPlanName)"/></span>'<xsl:choose><xsl:when test="($jsStartDate) and ($jsEndDate)">, start: '<xsl:value-of select="$jsStartDate"/>', end: '<xsl:value-of select="$jsEndDate"/>'</xsl:when><xsl:otherwise>, start: new Date(), end: new Date()</xsl:otherwise></xsl:choose> ,group:'<xsl:value-of select="$parentRoadmapId"/>', className: '<xsl:value-of select="$planningActionClass"/>', planAction: '<xsl:value-of select="$strategicPlanningAction/name"/>', popupContent:'<xsl:call-template name="strategicPlanPopupDiv"><xsl:with-param name="strategicPlan" select="$strategicPlan"/><xsl:with-param name="strategicPlanId" select="$strategicPlanId"/><xsl:with-param name="startDate" select="$jsStartDate"/><xsl:with-param name="endDate" select="$jsEndDate"/></xsl:call-template>'}<xsl:if test="not(position() = last())">,
			</xsl:if>
	</xsl:template>


	<xsl:template mode="RenderProject" match="node()">
		<xsl:param name="parentRoadmapId"/>
		<xsl:variable name="project" select="current()"/>
		<xsl:variable name="projectId" select="concat($parentRoadmapId, '-', $project/name)"/>
		<xsl:variable name="projectName" select="$project/own_slot_value[slot_reference = 'name']/value"/>
		
		<!--<xsl:variable name="projectPlannedStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value]"/>
		<xsl:variable name="jsPlannedStartDate" select="eas:get_start_date_for_essential_time($projectPlannedStartDate)"/>-->
		
		<xsl:variable name="plannedISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>
		<xsl:variable name="jsPlannedStartDate">
			<xsl:choose>
				<xsl:when test="string-length($plannedISOStartDate) > 0">
					<xsl:value-of select="xs:date($plannedISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectPlannedStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_proposed_start_date']/value]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($projectPlannedStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<!--<xsl:variable name="projectActualStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
		<xsl:variable name="jsActualStartDate" select="eas:get_start_date_for_essential_time($projectActualStartDate)"/>-->
		
		<xsl:variable name="actualISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>
		<xsl:variable name="jsActualStartDate">
			<xsl:choose>
				<xsl:when test="string-length($actualISOStartDate) > 0">
					<xsl:value-of select="xs:date($actualISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectActualStartDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_actual_start_date']/value]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($projectActualStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="jsStartDate">
			<xsl:choose>
				<xsl:when test="(string-length($actualISOStartDate) > 0) or ($project/own_slot_value[slot_reference = 'ca_actual_start_date']/value)"><xsl:value-of select="$jsActualStartDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$jsPlannedStartDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--<xsl:variable name="projectTargetEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
		<xsl:variable name="jsTargetEndDate" select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>-->
		
		<xsl:variable name="targetEndISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>
		<xsl:variable name="jsTargetEndDate">
			<xsl:choose>
				<xsl:when test="string-length($targetEndISOStartDate) > 0">
					<xsl:value-of select="xs:date($targetEndISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectTargetEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_target_end_date']/value]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($projectTargetEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--<xsl:variable name="projectForecastEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value]"/>
		<xsl:variable name="jsForecastEndDate" select="eas:get_end_date_for_essential_time($projectForecastEndDate)"/>-->
		
		<xsl:variable name="forecastEndISOStartDate" select="$project/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>
		<xsl:variable name="jsForecastEndDate">
			<xsl:choose>
				<xsl:when test="string-length($forecastEndISOStartDate) > 0">
					<xsl:value-of select="xs:date($forecastEndISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="projectForecastEndDate" select="$allDates[name = $project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value]"/>
					<xsl:value-of select="eas:get_end_date_for_essential_time($projectForecastEndDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="jsEndDate">
			<xsl:choose>
				<xsl:when test="(string-length($forecastEndISOStartDate) > 0) or ($project/own_slot_value[slot_reference = 'ca_forecast_end_date']/value)"><xsl:value-of select="$jsForecastEndDate"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$jsTargetEndDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!--<xsl:variable name="projectName">
			<xsl:value-of select="$project/own_slot_value[slot_reference = 'name']/value"/><xsl:value-of select="$jsPlannedStartDate"/>
		</xsl:variable>-->
		<!--		allProjectsViaPlanRels--> 	
		<xsl:variable name="projectStatus" select="$allProjectStatii[name = $project/own_slot_value[slot_reference = 'project_lifecycle_status']/value]"/>
		<xsl:variable name="projectStatusClass" select="lower-case(replace($projectStatus/own_slot_value[slot_reference = 'name']/value, ' ', '-'))"/>
		{id: '<xsl:value-of select="$projectId"/>', content: '<xsl:if test="$allProjectsViaPlanRels[name=$project/name][not(name=$allDirectProjects/name)]"><xsl:text> </xsl:text><i class="fa fa-circle-o" style="color:#d3cfcf"></i></xsl:if><span class="popupTrigger"><xsl:attribute name="id" select="concat('trigger', $projectId)"/><xsl:value-of select="eas:renderJSText($projectName)"/></span> '<xsl:choose><xsl:when test="($jsStartDate) and ($jsEndDate)">, start: '<xsl:value-of select="$jsStartDate"/>', end: '<xsl:value-of select="$jsEndDate"/>'</xsl:when><xsl:otherwise>, start: new Date(), end: new Date()</xsl:otherwise></xsl:choose>,group:'<xsl:value-of select="$parentRoadmapId"/>', className: '<xsl:value-of select="$projectStatusClass"/>', projectStatus: '<xsl:value-of select="$projectStatus/name"/>', popupContent:'<xsl:call-template name="projectPopupDiv"><xsl:with-param name="project" select="$project"/><xsl:with-param name="projectId" select="$projectId"/><xsl:with-param name="lifecycleStatus" select="$projectStatus"/><xsl:with-param name="plannedStartDate" select="$jsPlannedStartDate"/><xsl:with-param name="actualStartDate" select="$jsActualStartDate"/><xsl:with-param name="targetEndDate" select="$jsTargetEndDate"/><xsl:with-param name="forecastEndDate" select="$jsForecastEndDate"/></xsl:call-template>'}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

	<xsl:template mode="RenderArchStates" match="node()">
		<xsl:param name="parentRoadmapId"/>
		<xsl:variable name="archState" select="current()"/>
		<xsl:variable name="archStateId" select="concat($parentRoadmapId, '-', $archState/name)"/>
		<xsl:variable name="archStateName" select="$archState/own_slot_value[slot_reference = 'name']/value"/>
		
		<!--<xsl:variable name="archStateStartDate" select="$allDates[name = $archState/own_slot_value[slot_reference = 'start_date']/value]"/>
		<xsl:variable name="jsStartDate" select="eas:get_start_date_for_essential_time($archStateStartDate)"/>-->
		
		<xsl:variable name="archStateISOStartDate" select="$archState/own_slot_value[slot_reference = 'start_date_iso_8601']/value"/>
		<xsl:variable name="jsStartDate">
			<xsl:choose>
				<xsl:when test="string-length($archStateISOStartDate) > 0">
					<xsl:value-of select="xs:date($archStateISOStartDate)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="archStateStartDate" select="$allDates[name = $archState/own_slot_value[slot_reference = 'start_date']/value]"/>
					<xsl:value-of select="eas:get_start_date_for_essential_time($archStateStartDate)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		{id: '<xsl:value-of select="$archStateId"/>', content: '<span class="popupTrigger"><xsl:attribute name="id" select="concat('trigger', $archStateId)"/><xsl:value-of select="eas:renderJSText($archStateName)"/></span>', start: <xsl:choose><xsl:when test="$jsStartDate">'<xsl:value-of select="$jsStartDate"/>'</xsl:when><xsl:otherwise>new Date()</xsl:otherwise></xsl:choose>, group:'<xsl:value-of select="$parentRoadmapId"/>', className: 'archState', type: 'point', popupContent:'<xsl:call-template name="archStatePopupDiv"><xsl:with-param name="archState" select="$archState"/><xsl:with-param name="archStateId" select="$archStateId"/><xsl:with-param name="startDate" select="$jsStartDate"/></xsl:call-template>'}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>



	<xsl:template name="roadmapLayerFilter">
		<div class="pull-left">
			<strong>Show as:</strong>
		</div>
		<div class="horizSpacer_10px pull-left"/>
		<form class="pull-left" id="planProjectForm">
			<div class="pull-left">
				<input type="radio" name="displayType" id="filterStratPlans" value="stratPlans" checked="checked"/>
				<label for="stratPlans">Architecture Roadmap (Strategic Plans)</label>
			</div>
			<div class="pull-left">
				<input type="radio" name="displayType" id="filterProjects" value="projects"/>
				<label for="projects">Implementation Plan (Projects)</label>
			</div>
		</form>
	</xsl:template>

	<xsl:template name="roadmapFilterSection">
		<div class="pull-right">
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
				<div class="keyLabel"><xsl:value-of select="eas:i18n('Project Lifecycle Legend')"/>:</div>
			</div>
			<div class="col-xs-10">
				<xsl:for-each select="$allProjectStatii">
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
				<div class="pull-left"><i class="fa fa-circle-o" style="color:#d3cfcf"></i> Indirect</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="strategicPlanPopupDiv">
		<xsl:param name="strategicPlanId"/>
		<xsl:param name="strategicPlan"/>
		<xsl:param name="startDate"/>
		<xsl:param name="endDate"/>


		<xsl:variable name="formattedStartDate">
			<xsl:call-template name="FullFormatDate">
				<xsl:with-param name="theDate" select="$startDate"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="formattedEndDate">
			<xsl:call-template name="FullFormatDate">
				<xsl:with-param name="theDate" select="$endDate"/>
			</xsl:call-template>
		</xsl:variable>
		<div>
			<xsl:attribute name="id" select="concat('popup', $strategicPlanId)"/>
			<p class="fontBlack">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$strategicPlan"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$strategicPlan"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<div class="small">
				<strong>Start Date: </strong>
				<xsl:value-of select="$formattedStartDate"/>
			</div>
			<div class="small">
				<strong>End Date: </strong>
				<xsl:value-of select="$formattedEndDate"/>
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
					<xsl:with-param name="theSubjectInstance" select="$project"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$project"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
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
			<xsl:variable name="lifecycleStatusColour" select="eas:get_element_style_colour($lifecycleStatus)"/>
			<div class="small">
				<strong>Lifecycle Status: </strong>
				<xsl:value-of select="$lifecycleStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/>
				<div class="keySampleWide">
					<xsl:attribute name="style" select="concat('background-color:', $lifecycleStatusColour)"/>
				</div>
			</div>

		</div>
	</xsl:template>

	<xsl:template name="archStatePopupDiv">
		<xsl:param name="archStateId"/>
		<xsl:param name="archState"/>
		<xsl:param name="startDate"/>


		<xsl:variable name="formattedStartDate">
			<xsl:call-template name="FullFormatDate">
				<xsl:with-param name="theDate" select="$startDate"/>
			</xsl:call-template>
		</xsl:variable>
		<div>
			<xsl:attribute name="id" select="concat('popup', $archStateId)"/>
			<p class="fontBlack">
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$archState"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="$archState"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>
			</p>
			<p class="small">
				<strong>Date: </strong>
				<xsl:value-of select="$formattedStartDate"/>
			</p>

		</div>
	</xsl:template>

</xsl:stylesheet>
