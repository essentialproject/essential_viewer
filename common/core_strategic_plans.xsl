<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" version="2.0" xmlns:eas="http://www.enterprise-architecture.org/essential">
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

	<!-- Uncomment this for local testing 
    <xsl:param name="testInParam"/>
    -->
	<!-- Common stylesheet for rendering tabular information about the Strategic plans
         for an element in the architecture
         15.04.2008 JWC
    -->
	<!--May 2011 NJW Removed all formatting and style elements-->

	<xsl:include href="../common/core_utilities.xsl"/>

	<!-- param1 = the application service that is being summarised -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<xsl:param name="reposXML"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Strategic_Plan', 'Information_Strategic_Plan', 'Application_Strategic_Plan', 'Technology_Strategic_Plan', 'Security_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
	
	<xsl:variable name="stratPlanDateTypes" select="('Year', 'Quarter', 'Gregorian')"/>
	<xsl:variable name="stratPlanAllDates" select="/node()/simple_instance[type = $stratPlanDateTypes]"/>

	<!-- Given a reference (instance ID) to an element, find all its plans and render each -->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement" select="current()"/>

		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>

		<xsl:variable name="aDirectStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement/name]"/>
		<xsl:variable name="aStrategicPlanRelSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = $anElement/name]"/>
		<xsl:variable name="aStragegicPlanViaRelSet" select="/node()/simple_instance[name = $aStrategicPlanRelSet/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>

		<xsl:variable name="aStrategicPlanSet" select="$aDirectStrategicPlanSet union $aStragegicPlanViaRelSet"/>
		<xsl:variable name="activePlans" select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anActivePlan/name]"/>
		<xsl:variable name="futurePlans" select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $aFuturePlan/name]"/>
		<xsl:variable name="oldPlans" select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anOldPlan/name]"/>
		<xsl:variable name="noStatusPlans" select="$aStrategicPlanSet[not(name = ($activePlans, $futurePlans, $oldPlans)/name)]"/>

		<!-- Test to see if any plans are defined yet -->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-- Show active plans first -->
				<xsl:apply-templates select="$activePlans" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>

				<!-- Then the future -->
				<xsl:apply-templates select="$futurePlans" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>

				<!-- Then the old -->
				<xsl:apply-templates select="$oldPlans" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>

				<!-- Then the remaining -->
				<xsl:apply-templates select="$noStatusPlans" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No strategic plans defined for this element')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Render the details of a particular strategic plan in a small table -->
	<!-- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -->
	<xsl:template match="node()" mode="StrategicPlanDetailsTable">
		<xsl:param name="theStatus"/>
		
		<xsl:variable name="currentPlan" select="current()"/>

		<xsl:variable name="aStatusID" select="current()/own_slot_value[slot_reference = 'strategic_plan_status']/value"/>
		<xsl:if test="position() = 1">
			<br/>
			<h3>
				<xsl:choose>
					<xsl:when test="$aStatusID = $theStatus">
						<xsl:value-of>
							<xsl:apply-templates select="$aStatusID" mode="RenderEnumerationDisplayName"/>
						</xsl:value-of>&#160;<xsl:value-of select="eas:i18n('Plans')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="eas:i18n('No Status Plans')"/>
					</xsl:otherwise>
				</xsl:choose>
			</h3>
		</xsl:if>
		<script>
               	$(document).ready(function(){
               		// Setup - add a text input to each footer cell
               	    $('#dt_stratPlans_<xsl:value-of select="current()/name"/> tfoot th').each( function () {
               	        var title = $(this).text();
               	        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
               	    } );
               		
               		var table = $('#dt_stratPlans_<xsl:value-of select="current()/name"/>').DataTable({
               		scrollY: "350px",
               		scrollCollapse: true,
               		paging: false,
               		info: false,
               		sort: true,
               		responsive: true,
               		// Add columns as required
               		columns: [
               		    { "width": "25%" },
               		    { "width": "30%" },
               		   <!-- { "width": "10%" },-->
               		    <!--{ "width": "15%" },-->
               		    { "width": "25%" },
               		    { "width": "10%" },
               		    { "width": "10%" }
               		  ],
               		dom: 'Bfrtip',
               	    buttons: [
                           'copyHtml5', 
                           'excelHtml5',
                           'csvHtml5',
                           'pdfHtml5', 'print'
                       ]
               		});
               		
               		
               		// Apply the search
               	    table.columns().every( function () {
               	        var that = this;
               	 
               	        $( 'input', this.footer() ).on( 'keyup change', function () {
               	            if ( that.search() !== this.value ) {
               	                that
               	                    .search( this.value )
               	                    .draw();
               	            }
               	        } );
               	    } );
               	    
               	    table.columns.adjust();
               	    
               	    $(window).resize( function () {
               	        table.columns.adjust();
               	    });
               	});
               </script>
		<table class="table table-striped table-bordered" id="dt_stratPlans">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Plan')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<!--<th><xsl:value-of select="eas:i18n('Plan Status')"/></th>-->
					<!--<th><xsl:value-of select="eas:i18n('Strategic Plan')"/></th>-->
					<th>
						<xsl:value-of select="eas:i18n('Comments')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Start Date')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('End Date')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Plan')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<!--<th><xsl:value-of select="eas:i18n('Plan Status')"/></th>-->
					<!--<th><xsl:value-of select="eas:i18n('Strategic Plan')"/></th>-->
					<th>
						<xsl:value-of select="eas:i18n('Comments')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Start Date')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('End Date')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<tr>
					<td>
						<xsl:for-each select="current()">
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</xsl:for-each>
					</td>
					<td>
						<xsl:if test="string-length(own_slot_value[slot_reference = 'description']/value) = 0">
							<p>-</p>
						</xsl:if>
						<xsl:value-of select="own_slot_value[slot_reference = 'description']/value"/>
					</td>
					<!--<td>
                            <xsl:apply-templates select="$aStatusID" mode="RenderEnumerationDisplayName" />
                        </td>-->
					<!--<td>
                            <xsl:apply-templates select="own_slot_value[slot_reference='strategic_planning_action']/value" mode="RenderEnumerationDisplayName" />
                        </td>-->
					<td>
						<xsl:variable name="aComment" select="own_slot_value[slot_reference = 'strategic_plan_comments']/value"/>
						<xsl:choose>
							<xsl:when test="string($aComment)">
								<xsl:value-of select="$aComment"/>
							</xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:variable name="planISOStartDate" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>
						<xsl:variable name="planEssStartDateId" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_from_date']/value"/>
						<xsl:variable name="jsPlanStartDate">
							<xsl:choose>
								<xsl:when test="string-length($planISOStartDate) > 0">
									<xsl:value-of select="xs:date($planISOStartDate)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="planStartDate" select="$stratPlanAllDates[name = $planEssStartDateId]"/>
									<xsl:value-of select="eas:get_start_date_for_essential_time($planStartDate)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:choose>
							<xsl:when test="count($planISOStartDate) + count($planEssStartDateId) > 0">
								<xsl:variable name="displayStartDate">
									<xsl:call-template name="FullFormatDate">
										<xsl:with-param name="theDate" select="$jsPlanStartDate"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$displayStartDate"/>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('No start date captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:variable name="planISOEndDate" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>
						<xsl:variable name="planEssEndDateId" select="$currentPlan/own_slot_value[slot_reference = 'strategic_plan_valid_to_date']/value"/>
						<xsl:variable name="jsPlanEndDate">
							<xsl:choose>
								<xsl:when test="string-length($planISOEndDate) > 0">
									<xsl:value-of select="xs:date($planISOEndDate)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="planEndDate" select="$stratPlanAllDates[name = $planEssEndDateId]"/>
									<xsl:value-of select="eas:get_start_date_for_essential_time($planEndDate)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:choose>
							<xsl:when test="count($planISOEndDate) + count($planEssEndDateId) > 0">
								<xsl:variable name="displayToDate">
									<xsl:call-template name="FullFormatDate">
										<xsl:with-param name="theDate" select="$jsPlanEndDate"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$displayToDate"/>
							</xsl:when>
							<xsl:otherwise>
								<em>
									<xsl:value-of select="eas:i18n('No end date captured')"/>
								</em>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</tbody>
		</table>
		<br/>

	</xsl:template>

	<!-- Render the name of the Planning Action identified by the supplied instance ID -->
	<xsl:template match="node()" mode="RenderEnumerationDisplayName">
		<xsl:variable name="anInstance" select="node()"/>
		<xsl:variable name="aPlanningAction" select="/node()/simple_instance[name = $anInstance]"/>
		<xsl:value-of select="$aPlanningAction/own_slot_value[slot_reference = 'enumeration_value']/value"/>
	</xsl:template>

	<!-- Render the name of a Strategic plan in a more sensible form -->
	<xsl:template match="node()" mode="RenderStrategicPlanName">
		<xsl:variable name="aPlanName" select="replace(current(), 'Strategic Plan::', '')"/>
		<xsl:value-of select="normalize-space(replace($aPlanName, '::[0-9].', ' - '))"/>
	</xsl:template>
</xsl:stylesheet>
