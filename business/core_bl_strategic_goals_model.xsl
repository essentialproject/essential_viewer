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
	<!-- 27.08.2012 JP  Created	 -->


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

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="smartObjectiveType" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'SMART Objective')]"/>
	<xsl:variable name="goalObjectiveType" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Strategic Goal')]"/>

	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[(type = 'Business_Objective') and not(own_slot_value[slot_reference = 'element_classified_by']/value = $goalObjectiveType/name)]"/>
	<xsl:variable name="allStrategicGoals" select="/node()/simple_instance[(type = 'Business_Goal') or ((type = 'Business_Objective') and (own_slot_value[slot_reference = 'element_classified_by']/value = $goalObjectiveType/name))]"/>
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allBusinessServiceQualities" select="/node()/simple_instance[type = ('Business_Service_Quality','Service_Quality')]"/>

	<xsl:variable name="allBusinessServiceOBJ" select="/node()/simple_instance[type = 'OBJ_TO_SVC_QUALITY_RELATION']"/>
	<xsl:variable name="allBusinessServiceQualityValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value']"/>


	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('Strategic Goals Model')"/>
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
			<xsl:value-of select="eas:i18n('Strategic Goals Model')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<!--<script>
						$(document).ready(function(){
							// Setup - add a text input to each footer cell
						    $('#dt_objective tfoot th').each( function () {
						        var title = $(this).text();
						        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
						    } );
							
							var table = $('#dt_objective').DataTable({
							paging: false,
							info: false,
							sort: false,
							columns: [
							    { "width": "25%" },
							    { "width": "25%" },
							    { "width": "20%" },
							    { "width": "10%" },
							    { "width": "20%" }
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
						});
					</script>-->
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

						<!--Setup Catalogue Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
 
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Strategic Goal Catalogue')"/>
							</h2>
							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The following table lists the Strategic Business Goals for')"/>&#160; <xsl:value-of select="$orgName"/></p>


								<div class="simple-scroller">
									<xsl:call-template name="BusinessObjectivesCatalogue"/>
								</div>

							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template name="BusinessObjectivesCatalogue">
		<table class="table table-bordered table-header-background" id="dt_objective">
			<thead>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Strategic Goal')"/>
					</th>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Objective')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Driver')"/>
					</th>
					<th class="cellWidth-10pc">
						<xsl:value-of select="eas:i18n('Org Unit')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Measure/KPI')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<xsl:choose>
					<xsl:when test="string-length($param4) > 0">
						<xsl:variable name="strategicGoals" select="$allStrategicGoals[own_slot_value[slot_reference = 'element_classified_by']/value = $param4]"/>
						<xsl:apply-templates select="$strategicGoals" mode="StrategicGoal">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$allStrategicGoals" mode="StrategicGoal">
							<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>

	</xsl:template>


	<xsl:template match="node()" mode="StrategicGoal">
		<xsl:variable name="goalBusObjectives" select="$allBusObjectives[own_slot_value[slot_reference = ('objective_supports_objective', 'objective_supports_goals')]/value = current()/name]"/>
		<xsl:variable name="busObjRows" select="max((count($goalBusObjectives), 1))"/>

		<xsl:text disable-output-escaping="yes">&lt;tr></xsl:text>
		<!-- Print out the name of the Strategic Goal-->
		<td>
			<xsl:attribute name="rowspan" select="$busObjRows"/>
			<strong>
				<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
			</strong>
		</td>
		<xsl:choose>
			<xsl:when test="count($goalBusObjectives) = 0">
				<td>-</td>
				<td>-</td>
				<td>-</td>
				<td>-</td>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="string-length($param4) > 0">
				<xsl:variable name="busObjectives" select="$goalBusObjectives[own_slot_value[slot_reference = 'element_classified_by']/value = $param4]"/>
				<xsl:apply-templates select="$busObjectives" mode="BusinessObjective">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$goalBusObjectives" mode="BusinessObjective">
					<xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="BusinessObjective">
		<xsl:variable name="busObjDrivers" select="$allDrivers[name = current()/own_slot_value[slot_reference = 'bo_motivated_by_driver']/value]"/>
		<xsl:variable name="busObjMeasuresOld" select="$allBusinessServiceQualityValues[name = current()/own_slot_value[slot_reference = 'bo_measures']/value]"/>
		<xsl:variable name="busObjServtoObj" select="$allBusinessServiceOBJ[name = current()/own_slot_value[slot_reference = 'bo_performance_measures']/value]"/>		
		<xsl:variable name="busObjMeasuresNew" select="$allBusinessServiceQualities[name =$busObjServtoObj/own_slot_value[slot_reference = 'obj_to_svc_quality_service_quality']/value]"/>
		<xsl:variable name="busObjMeasures" select="$busObjMeasuresOld union $busObjMeasuresNew"/>
		<xsl:variable name="busObjOrgOwners" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
		<xsl:variable name="busObjIndividualOwners" select="$allIndividualActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
		<xsl:variable name="busObjTargetDate" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bo_target_date']/value]"/>
		<!--<tr>-->
		<!-- Print out the name of the Strategic Goal-->
		<!--<td><strong>My Strategic Goal</strong></td>-->

		<xsl:if test="position() > 1">
			<xsl:text disable-output-escaping="yes">&lt;tr></xsl:text>
		</xsl:if>

		<!-- Print out the name of the Business Objective -->
		<td>
			<strong>
				<xsl:variable name="objName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
 
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="userParams" select="$param4"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
				</xsl:call-template>

			</strong>
		</td>


		<!-- Print out the list of Drivers that the objective supports -->
		<td>
			<ul>
				<xsl:apply-templates select="$busObjDrivers" mode="NameBulletItem"/>
			</ul>
		</td>

		<!-- Print out the list of Individual and Group Actors that own the Objective -->
		<td>
			<ul>
				<xsl:apply-templates select="$busObjIndividualOwners" mode="NameBulletItem"/>
				<xsl:apply-templates select="$busObjOrgOwners" mode="NameBulletItem"/>
			</ul>
		</td>

		<!-- Print out the list of Service Quality Values (Measures) -->
		<td> 
			<ul>
				<xsl:apply-templates select="$busObjMeasures" mode="Measure"/>
			</ul>
		</td>


		<xsl:text disable-output-escaping="yes">&lt;/tr></xsl:text>
		<!--</tr>-->
	</xsl:template>

	<!-- TEMPLATE TO PRINT OUT THE LIST OF SERVICE QUALITY VALUES FOR AN OBJECTIVE AS A BULLETED LIST ITEM -->
	<xsl:template match="node()" mode="Measure">
		<xsl:variable name="serviceQuality" select="$allBusinessServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
		<xsl:variable name="serviceQualityVals" select="$allBusinessServiceQualityValues[name = current()/own_slot_value[slot_reference = 'sq_maximum_value']/value]"/>
		<xsl:choose><xsl:when test="$serviceQuality">
		<li>
			<xsl:value-of select="$serviceQuality/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:text> - </xsl:text>
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>
		</li>
	</xsl:when>
	<xsl:otherwise>
		<li>
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:if test="$serviceQualityVals/own_slot_value[slot_reference = 'service_quality_value_value']/value"><xsl:text> - </xsl:text>
			<xsl:value-of select="$serviceQualityVals/own_slot_value[slot_reference = 'service_quality_value_value']/value"/></xsl:if>
		</li>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
