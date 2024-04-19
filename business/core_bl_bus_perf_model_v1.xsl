<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xpath-default-namespace="http://protege.stanford.edu/xml" version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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


	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>


	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Objective', 'Business_Driver', 'Service_Quality', 'Service_Quality_Measure', 'Service_Quality_Value', 'Group_Actor', 'Individual_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:variable name="allObj2GroupActorRels" select="/node()/simple_instance[own_slot_value[slot_reference = 'act_to_obj_objective']/value = $allBusObjectives/name]"/>
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allBusinessServiceQualities" select="/node()/simple_instance[type = 'Business_Service_Quality']"/>
	<xsl:variable name="allBusinessServiceQualityValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value']"/>
	<xsl:variable name="allTargetDates" select="/node()/simple_instance[name = $allBusObjectives/own_slot_value[slot_reference = 'bo_target_date']/value]"/>
    <xsl:variable name="allsvcToObj" select="/node()/simple_instance[name = $allBusObjectives/own_slot_value[slot_reference = 'bo_performance_measures']/value]"/>

	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('Business Performance Model')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
					<xsl:with-param name="orgName" select="$orgScopeTermName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Business Performance Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:call-template name="dataTablesLibrary"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
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


						<!--Setup Description Section-->
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<div>
								<h2 class="text-primary">
									<xsl:value-of select="eas:i18n('Business Objectives Catalogue')"/>
								</h2>
							</div>
							<p><xsl:value-of select="eas:i18n('The following table lists the Business Objectives for')"/>&#160; <xsl:value-of select="$orgName"/>
							</p>
							<xsl:call-template name="BusinessObjectivesCatalogue"/>
						</div>
						<hr/>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="BusinessObjectivesCatalogue">
		<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_objectives tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
					    } );
						
						var table = $('#dt_objectives').DataTable({
						scrollY: "350px",
						scrollCollapse: true,
						paging: false,
						info: false,
						sort: true,
						responsive: true,
						columns: [
						    { "width": "20%" },
						    { "width": "10%" },
						    { "width": "20%" },
						    { "width": "10%" },
						    { "width": "20%" },
						    { "width": "20%" }
						  ],
						dom: 'Bfrtip',
					    buttons: [
				            'copyHtml5', 
				            'excelHtml5',
				            'csvHtml5',
				            'pdfHtml5',
				            'print'
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
		<table class="table table-striped table-bordered" id="dt_objectives">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Objective')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Type')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Measures')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Target Date')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Owner(s)')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Supported Drivers')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Objective')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Type')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Measures')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Target Date')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Owner(s)')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Supported Drivers')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:choose>
					<xsl:when test="string-length($viewScopeTermIds) > 0">
						<xsl:variable name="busObjectives" select="$allBusObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
						<xsl:apply-templates select="$busObjectives" mode="BusinessObjective">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$allBusObjectives" mode="BusinessObjective">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="node()" mode="BusinessObjective">
		<xsl:variable name="busObj2GroupActorRels" select="$allObj2GroupActorRels[own_slot_value[slot_reference = 'act_to_obj_objective']/value = current()/name]"/>
		<xsl:variable name="busObjGroupActors" select="$allGroupActors[name = $busObj2GroupActorRels/own_slot_value[slot_reference = 'act_to_obj_actor']/value]"/>
		<xsl:variable name="busObjIndivActors" select="$allIndividualActors[name = $busObj2GroupActorRels/own_slot_value[slot_reference = 'act_to_obj_actor']/value]"/>
		<xsl:variable name="busObjGroupActorMeasures" select="$allBusinessServiceQualityValues[name = $busObj2GroupActorRels/own_slot_value[slot_reference = ('act_to_obj_target_value', 'act_to_obj_target_values')]/value]"/>
		<xsl:variable name="busObjDrivers" select="$allDrivers[name = current()/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
        <xsl:variable name="busObjMeasures" select="$allBusinessServiceQualityValues[name = current()/own_slot_value[slot_reference = 'bo_measures']/value]"></xsl:variable>
		<xsl:variable name="busObjOrgOwners" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
		<xsl:variable name="busObjIndividualOwners" select="$allIndividualActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
		<xsl:variable name="busObjTargetDate" select="$allTargetDates[name = current()/own_slot_value[slot_reference = 'bo_target_date']/value]"/>
        <xsl:variable name="busObjTargetDateISO" select="current()/own_slot_value[slot_reference = 'bo_target_date_iso_8601']/value"/>
		<xsl:variable name="aTaxonomy" select="own_slot_value[slot_reference = 'element_classified_by']/value"/> <tr>
			<!-- Print out the name of the Business Objective -->
			<td>
				<strong>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"/>
						<xsl:with-param name="theXML" select="$reposXML"/>
						<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					</xsl:call-template>
				</strong>
			</td>
			<td>
				<xsl:for-each select="$aTaxonomy">
				<xsl:apply-templates select="current()" mode="RenderObjectiveTaxonomyTerm"/>
				</xsl:for-each>
				<xsl:if test="count($aTaxonomy)=0">-</xsl:if>
			</td>
			<!-- Print out the list of Service Quality Values (Measures) -->
			<td>
				<ul>
                    <xsl:apply-templates select="$busObjMeasures union $busObjGroupActorMeasures" mode="Measure">
                        <xsl:with-param name="bo" select="current()"/>
                    </xsl:apply-templates>
				</ul>
			</td>
			<!-- Print out the target date -->
			<td>
              
                <xsl:choose>
                 <xsl:when test="$busObjTargetDateISO">
                    <xsl:value-of select="$busObjTargetDateISO"/>
                 </xsl:when>
                 <xsl:otherwise>
                
				<xsl:if test="count($busObjTargetDate) > 0">
					<xsl:call-template name="FullFormatDate">
						<xsl:with-param name="theDate" select="eas:get_end_date_for_essential_time($busObjTargetDate)"/>
					</xsl:call-template>
				</xsl:if>
                 </xsl:otherwise>    
                </xsl:choose>
			</td>
			<!-- Print out the list of Individual and Group Actors that own the Objective -->
			<td>
				<ul>
					<xsl:apply-templates select="$busObjIndividualOwners union $busObjIndivActors" mode="NameBulletList"/>
					<xsl:apply-templates select="$busObjOrgOwners union $busObjGroupActors" mode="NameBulletList"/>
				</ul>
			</td>
			<!-- Print out the list of Drivers that the objective supports -->
			<td>
				<ul>
					<xsl:apply-templates select="$busObjDrivers" mode="NameBulletList"/>
				</ul>
			</td>
		</tr>
	</xsl:template>

	<!-- TEMPLATE TO PRINT OUT THE LIST OF SERVICE QUALITY VALUES FOR AN OBJECTIVE AS A BULLETED LIST ITEM -->
	<xsl:template match="node()" mode="Measure">
        <xsl:param name="bo"/>
        <xsl:variable name="allsvcToObj" select="/node()/simple_instance[name = $bo/own_slot_value[slot_reference = 'bo_performance_measures']/value]"/>
        <xsl:variable name="serviceQualityVia" select="$allBusinessServiceQualities[name = $allsvcToObj/own_slot_value[slot_reference = 'obj_to_svc_quality_service_quality']/value]"/>
         <xsl:variable name="thisQualityScore" select="$allBusinessServiceQualityValues[name = $serviceQualityVia/own_slot_value[slot_reference = 'sq_maximum_value']/value]"/>
		<xsl:variable name="serviceQuality" select="$allBusinessServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>

		<li>
			<!--<xsl:value-of select="$serviceQuality/own_slot_value[slot_reference='name']/value" />-->
			<!--<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="$serviceQuality"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
			<xsl:text> - </xsl:text>-->
			<!--<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value" />-->
            <xsl:choose><xsl:when test="$thisQualityScore">
                <xsl:call-template name="RenderInstanceLink">
                    <xsl:with-param name="theSubjectInstance" select="$thisQualityScore"/>
                    <xsl:with-param name="theXML" select="$reposXML"/>
                    <xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
                </xsl:call-template>
            </xsl:when>    
            <xsl:otherwise>
                <xsl:call-template name="RenderInstanceLink">
                    <xsl:with-param name="theSubjectInstance" select="current()"/>
                    <xsl:with-param name="theXML" select="$reposXML"/>
                    <xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
                </xsl:call-template>
            </xsl:otherwise>        
        </xsl:choose> 
		</li>
	</xsl:template>

	<xsl:template match="node()" mode="NameBulletList">
		<li>
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>

</xsl:stylesheet>
