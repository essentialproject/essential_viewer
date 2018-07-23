<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">

	<xsl:import href="../common/core_utilities.xsl"/>

	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="allLifecycleModels" select="/node()/simple_instance[type = 'Lifecycle_Model']"/>
	<xsl:variable name="allLifecycleRelations" select="/node()/simple_instance[name = $allLifecycleModels/own_slot_value[slot_reference = 'contained_lifecycle_model_relations']/value]"/>
	<xsl:variable name="allLifecycleElements" select="/node()/simple_instance[name = $allLifecycleModels/own_slot_value[slot_reference = 'contained_lifecycle_model_elements']/value]"/>
	<xsl:variable name="allLifecycleStatusUsages" select="$allLifecycleElements[type = 'Lifecycle_Status_Usage']"/>
	<xsl:variable name="relevantLifecycleStatii" select="$allLifecycleStatii[name = $allLifecycleStatusUsages/own_slot_value[slot_reference = 'lcm_lifecycle_status']/value]"/>
	<xsl:variable name="allLifecycleTimelinePoints" select="$allLifecycleElements[type = 'Lifecycle_Model_Timeline_Point']"/>
	<xsl:variable name="allLifecycleDates" select="/node()/simple_instance[name = $allLifecycleTimelinePoints/own_slot_value[slot_reference = 'time_point']/value]"/>

	<xsl:variable name="startLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Installed Non-standard']"/>
	<xsl:variable name="startLifecycleStatusUsages" select="$allLifecycleStatusUsages[own_slot_value[slot_reference = 'lcm_lifecycle_status']/value = $startLifecycleStatus/name]"/>
	<xsl:variable name="endLifecycleStatus" select="$allLifecycleStatii[own_slot_value[slot_reference = 'name']/value = 'Retired']"/>
	<xsl:variable name="endLifecycleStatusUsages" select="$allLifecycleStatusUsages[own_slot_value[slot_reference = 'lcm_lifecycle_status']/value = $endLifecycleStatus/name]"/>


	<xsl:function name="eas:get_lifecycle_start_end_dates_for_element" as="node()*">
		<xsl:param name="element"/>

		<xsl:variable name="elementLifecycleModel" select="$allLifecycleModels[name = $element/own_slot_value[slot_reference = 'lifecycle_model_for_element']/value]"/>

		<xsl:variable name="elementStartLifecycleStatusUsage" select="$startLifecycleStatusUsages[name = $elementLifecycleModel/own_slot_value[slot_reference = 'contained_lifecycle_model_elements']/value]"/>
		<xsl:variable name="elementStartLifecycleRelation" select="$allLifecycleRelations[own_slot_value[slot_reference = ':FROM']/value = $elementStartLifecycleStatusUsage/name]"/>
		<xsl:variable name="elementStartLifecycleTimelinePoint" select="$allLifecycleTimelinePoints[name = $elementStartLifecycleRelation/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="elementStartLifecycleDate" select="$allLifecycleDates[name = $elementStartLifecycleTimelinePoint/own_slot_value[slot_reference = 'time_point']/value]"/>

		<xsl:variable name="elementEndLifecycleStatusUsage" select="$endLifecycleStatusUsages[name = $elementLifecycleModel/own_slot_value[slot_reference = 'contained_lifecycle_model_elements']/value]"/>
		<xsl:variable name="elementEndLifecycleRelation" select="$allLifecycleRelations[own_slot_value[slot_reference = ':FROM']/value = $elementEndLifecycleStatusUsage/name]"/>
		<xsl:variable name="elementEndLifecycleTimelinePoint" select="$allLifecycleTimelinePoints[name = $elementEndLifecycleRelation/own_slot_value[slot_reference = ':TO']/value]"/>
		<xsl:variable name="elementEndLifecycleDate" select="$allLifecycleDates[name = $elementEndLifecycleTimelinePoint/own_slot_value[slot_reference = 'time_point']/value]"/>

		<xsl:sequence select="($elementStartLifecycleDate, $elementEndLifecycleDate)"/>

	</xsl:function>


	<xsl:function name="eas:get_current_lifecycle_status_for_element" as="node()*">
		<xsl:param name="element"/>

		<xsl:variable name="elementLifecycleModel" select="$allLifecycleModels[name = $element/own_slot_value[slot_reference = 'lifecycle_model_for_element']/value]"/>

		<xsl:variable name="elementLifecycleStatusUsages" select="$allLifecycleStatusUsages[name = $elementLifecycleModel/own_slot_value[slot_reference = 'contained_lifecycle_model_elements']/value]"/>
		<xsl:variable name="elementLifecycleRelations" select="$allLifecycleRelations[own_slot_value[slot_reference = ':FROM']/value = $elementLifecycleStatusUsages/name]"/>
		<xsl:variable name="elementLifecycleTimelinePoints" select="$allLifecycleTimelinePoints[name = $elementLifecycleRelations/own_slot_value[slot_reference = ':TO']/value]"/>

		<xsl:variable name="inScopeTimelinePoints" select="eas:get_relevant_timeline_points($elementLifecycleTimelinePoints)"/>
		<xsl:variable name="currentTimelinePoint" select="eas:get_latest_timeline_point($inScopeTimelinePoints, current-date(), ())"/>
		<xsl:message><xsl:value-of select="$element/own_slot_value[slot_reference = 'name']/value"/>: TimelinePoints - <xsl:value-of select="count($currentTimelinePoint)"/></xsl:message>

		<xsl:variable name="currentLifecycleRelation" select="$elementLifecycleRelations[own_slot_value[slot_reference = ':TO']/value = $currentTimelinePoint/name]"/>
		<xsl:variable name="currentLifecycleStatusUsage" select="$elementLifecycleStatusUsages[name = $currentLifecycleRelation/own_slot_value[slot_reference = ':FROM']/value]"/>
		<xsl:variable name="currentLifecycleStatus" select="$allLifecycleStatii[name = $currentLifecycleStatusUsage/own_slot_value[slot_reference = 'lcm_lifecycle_status']/value]"/>

		<xsl:sequence select="$currentLifecycleStatus"/>

	</xsl:function>

	<xsl:function name="eas:get_relevant_timeline_points" as="node()*">
		<xsl:param name="timelinePoints"/>

		<xsl:variable name="currentDate" select="current-date()"/>
		<xsl:for-each select="$timelinePoints">
			<xsl:variable name="startDate" select="eas:get_start_date_for_essential_time($allLifecycleDates[name = current()/own_slot_value[slot_reference = 'time_point']/value])"/>
			<xsl:if test="$startDate &lt; $currentDate">
				<xsl:sequence select="current()"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>

	<xsl:function name="eas:get_latest_timeline_point" as="node()*">
		<xsl:param name="timelinePoints" as="node()*"/>
		<xsl:param name="latestTimelineDateXS" as="xs:date"/>
		<xsl:param name="latestTimelinePoint" as="node()*"/>

		<xsl:choose>
			<xsl:when test="count($timelinePoints) > 0">
				<xsl:variable name="nextTimelinePoint" select="$timelinePoints[1]"/>
				<xsl:variable name="newTimelinePointList" select="remove($timelinePoints, 1)"/>
				<xsl:variable name="nextTimelinePointDate" select="$allLifecycleDates[name = $nextTimelinePoint/own_slot_value[slot_reference = 'time_point']/value]"/>
				<xsl:choose>
					<xsl:when test="count($nextTimelinePointDate) > 0">
						<xsl:variable name="nextTimelinePointDateXS" select="eas:get_start_date_for_essential_time($nextTimelinePointDate)"/>
						<xsl:choose>
							<xsl:when test="count($latestTimelinePoint) = 0">
								<xsl:sequence select="eas:get_latest_timeline_point($newTimelinePointList, $nextTimelinePointDateXS, $nextTimelinePoint)"/>
							</xsl:when>
							<xsl:when test="$nextTimelinePointDateXS > $latestTimelineDateXS">
								<xsl:sequence select="eas:get_latest_timeline_point($newTimelinePointList, $nextTimelinePointDateXS, $nextTimelinePoint)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:sequence select="eas:get_latest_timeline_point($newTimelinePointList, $latestTimelineDateXS, $latestTimelinePoint)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="eas:get_latest_timeline_point($newTimelinePointList, $latestTimelineDateXS, $latestTimelinePoint)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$latestTimelinePoint"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>

	<xsl:function name="eas:get_elements_for_lifecycle_status" as="node()*">
		<xsl:param name="elements"/>
		<xsl:param name="lifecycleStatus"/>

		<xsl:for-each select="$elements">
			<xsl:variable name="elementLifecycycleStatus" select="eas:get_current_lifecycle_status_for_element(current())"/>
			<xsl:if test="$elementLifecycycleStatus/name = $lifecycleStatus/name">
				<xsl:sequence select="current()"/>
			</xsl:if>
		</xsl:for-each>

	</xsl:function>

</xsl:stylesheet>
