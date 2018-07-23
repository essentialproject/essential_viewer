<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:math="http://exslt.org/math" extension-element-prefixes="math">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->

	<!-- param1 = the information concept that is being summarised -->
	<xsl:param name="param1"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Project', 'Business_Capability', 'Business_Process', 'Business_Domain', 'Application_Provider', 'Information_Concept', 'Business_Objective')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- Get all of the required types of instances in the repository -->

	<xsl:variable name="allBusinessCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<!--<xsl:variable name="allBusProcs" select="/node()/simple_instance[type='Business_Process']" />
	<xsl:variable name="allApps" select="/node()/simple_instance[(type='Application_Provider') or (type='Composite_Application_Provider')]" />
	<xsl:variable name="allAppServices" select="/node()/simple_instance[(type='Application_Service') or (type='Composite_Application_Service')]"/>
	<xsl:variable name="allAppRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/>
	<xsl:variable name="allBusProc2AppSvcs" select="/node()/simple_instance[type='APP_SVC_TO_BUS_RELATION']"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type='Individual_Actor']" />
	<xsl:variable name="allIndividualRoles" select="/node()/simple_instance[type='Individual_Business_Role']" />
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type='Group_Actor']" />
	<xsl:variable name="allGroupRoles" select="/node()/simple_instance[type='Group_Business_Role']"/>
	<xsl:variable name="allPhysProcs" select="/node()/simple_instance[type='Physical_Process']" />
	<xsl:variable name="allPhysProcs2Apps" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']" />-->

	<xsl:variable name="currentBusCap" select="$allBusinessCaps[name = $param1]"/>
	<xsl:variable name="currentBusCapName" select="$currentBusCap/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="currentBusCapDescription" select="$currentBusCap/own_slot_value[slot_reference = 'description']/value"/>
	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[name = $currentBusCap/own_slot_value[slot_reference = 'business_objectives_for_business_capability']/value]"/>
	<xsl:variable name="busDomain" select="/node()/simple_instance[name = $currentBusCap/own_slot_value[slot_reference = 'belongs_to_business_domain']/value]"/>
	<xsl:variable name="parentCap" select="$allBusinessCaps[name = $currentBusCap/own_slot_value[slot_reference = 'supports_business_capabilities']/value]"/>
	<xsl:variable name="allInfoConcepts" select="/node()/simple_instance[name = $currentBusCap/own_slot_value[slot_reference = 'business_capability_requires_information']/value]"/>
	<xsl:variable name="subBusCaps" select="$allBusinessCaps[name = $currentBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>


	<xsl:variable name="relevantBusCaps" select="$currentBusCap union $subBusCaps"/>
	<xsl:variable name="relevantBusProcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'realises_business_capability']/value = $relevantBusCaps/name]"/>
	<xsl:variable name="currentBusProcs" select="$relevantBusProcs[own_slot_value[slot_reference = 'realises_business_capability']/value = $currentBusCap/name]"/>
	<xsl:variable name="relevantBusProc2AppSvcs" select="/node()/simple_instance[own_slot_value[slot_reference = 'appsvc_to_bus_to_busproc']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="relevantAppSvcs" select="/node()/simple_instance[name = $relevantBusProc2AppSvcs/own_slot_value[slot_reference = 'appsvc_to_bus_from_appsvc']/value]"/>
	<xsl:variable name="relevantAppRoles" select="/node()/simple_instance[own_slot_value[slot_reference = 'implementing_application_service']/value = $relevantAppSvcs/name]"/>
	<xsl:variable name="relevantApps" select="/node()/simple_instance[name = $relevantAppRoles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>

	<xsl:variable name="physProcsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'implements_business_process']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="physProcs2AppsForCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $physProcsForCap/name]"/>
	<xsl:variable name="appRolesForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="appsForRolesCap" select="/node()/simple_instance[name = $appRolesForCap/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="appsForCap" select="/node()/simple_instance[name = $physProcs2AppsForCap/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="allAppsForCap" select="$appsForRolesCap union $appsForCap union $relevantApps"/>


	<xsl:variable name="relevantServiceQualityValues" select="/node()/simple_instance[name = $allBusObjectives/own_slot_value[slot_reference = 'bo_measures']/value]"/>
	<xsl:variable name="relevantServiceQualities" select="/node()/simple_instance[name = $relevantServiceQualityValues/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>

	<xsl:variable name="allDates" select="/node()/simple_instance[(type = 'Year') or (type = 'Quarter') or (type = 'Gregorian')]"/>

	<xsl:variable name="allArchStates" select="/node()/simple_instance[type = 'Architecture_State']"/>
	<xsl:variable name="allProjects" select="/node()/simple_instance[type = 'Project']"/>
	<xsl:variable name="archStatesforBusProcs" select="$allArchStates[own_slot_value[slot_reference = 'arch_state_business_logical']/value = $relevantBusProcs/name]"/>
	<xsl:variable name="archStatesforApps" select="$allArchStates[own_slot_value[slot_reference = 'arch_state_application_logical']/value = $allAppsForCap/name]"/>
	<xsl:variable name="relevantArchitectureStates" select="($archStatesforApps | $archStatesforBusProcs)"/>
	<xsl:variable name="archStateProjects" select="$allProjects[own_slot_value[slot_reference = 'project_start_state']/value = $relevantArchitectureStates/name]"/>

	<xsl:variable name="planToElementRelsForBusCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = ($currentBusCap, $relevantBusProcs, $allAppsForCap)/name]"/>
	<xsl:variable name="directProjectsForBusCap" select="$allProjects[name = $planToElementRelsForBusCap/own_slot_value[slot_reference = 'plan_to_element_change_activity']/value]"/>
	<xsl:variable name="stratPlansForBusCap" select="/node()/simple_instance[name = $planToElementRelsForBusCap/own_slot_value[slot_reference = 'plan_to_element_plan']/value]"/>
	<xsl:variable name="deprecatedStratPlansForBusCap" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = ($currentBusCap, $relevantBusProcs, $allAppsForCap)/name]"/>
	<xsl:variable name="projectsSupportingStratPlans" select="$allProjects[name = ($stratPlansForBusCap, $deprecatedStratPlansForBusCap)/own_slot_value[slot_reference = 'strategic_plan_supported_by_projects']/value]"/>
	<xsl:variable name="relevantProjects" select="$directProjectsForBusCap union $archStateProjects union $projectsSupportingStratPlans"/>
	<xsl:variable name="lifecycleStatus" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
	<xsl:variable name="deliveryModel" select="/node()/simple_instance[type = 'Codebase_Status']"/>
	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:call-template name="BuildPage">
					<!--<xsl:with-param name="inScopeInfoViews" select="$allInfoViews[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" />
					<xsl:with-param name="inScopeDataSubjects" select="$allDataSubjects[own_slot_value[slot_reference='element_classified_by']/value = $viewScopeTerms/name]" />-->
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage">
					<!--<xsl:with-param name="inScopeInfoViews" select="$allInfoViews"/>
					<xsl:with-param name="inScopeDataSubjects" select="$allInfoViews"/>-->
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('Applications Status for Business Capability')"/>
		</xsl:param>
		<xsl:param name="orgName">
			<xsl:value-of select="eas:i18n('the enterprise')"/>
		</xsl:param>
		<xsl:param name="inScopeInfoViews"/>
		<xsl:param name="inScopeDataSubjects"/>


		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<script type="text/javascript">
					$('document').ready(function(){
						 $(".compModelContent").vAlign();
					});
				</script>

				<script src="js/d3/d3.js" charset="utf-8"/>
				<script src="js/radar.js"/>

				<style>
					svg,
					ul{
						float: left;
					}
					
					svg text.name{
						font-family: Arial, Sans-serif;
						font-size: 10px;
						opacity: 1.0
					}
					
					svg line.quadrant{
						stroke-width: 2px;
					}
					
					svg circle.horizon{
						stroke: #999;
						stroke-width: 2px;
						stroke-opacity: 0;
						fill: none;
					}
					
					svg line.direction{
						stroke: black;
						stroke-width: 5px;
						marker-end: url(#arrow);
						opacity: 0.0;
					}
					
					svg #arrow{
						fill: black;
					}
					
					svg path.quadrant{
						fill-opacity: 0.5;
					}
					
					svg text.quadrant{
						font-family: Arial, Sans-serif;
						font-weight: bold;
						color: white;
						opacity: 0.3;
						font-size: 15px;
						text-align: right;
					}</style>


			</head>
			<body>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>

				<!--ADD THE CONTENT-->
				<a id="top"/>
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="$pageLabel"/> - </span>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$currentBusCap"/>
										<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
									</xsl:call-template>
								</h1>
							</div>
						</div>


						<!--Setup Description Section-->
					</div>
					<div class="row">


						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-desktop icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Applications by Lifecycle Status')"/>
							</h2>

							<div class="content-section">
								<div class="row">
									<xsl:choose>
										<xsl:when test="count($allAppsForCap) = 0">
											<em>
												<xsl:value-of select="eas:i18n('No Applications captured')"/>
											</em>
										</xsl:when>
										<xsl:otherwise>
											<p><xsl:value-of select="eas:i18n('Lifecycle status for applications supporting the')"/>&#160; <xsl:value-of select="$currentBusCapName"/>&#160; <xsl:value-of select="eas:i18n('Business Capability.')"/></p>


											<div class="col-xs-12 col-md-6">
												<p>Layers: <i class="fa fa-square" style="color:#eee"/> Under Planning <i class="fa fa-square" style="color:#ccc"/> Prototype-Pilot <i class="fa fa-square" style="color:#aaa"/> Production <i class="fa fa-square" style="color:#999"/> Sunset-Off Strategy <div id="radar" style="width: 1024px; height: 800px"/></p>
												<div id="radar"/>
												<script>

                                                    function entry(start, end, quadrant, position, position_angle, direction, direction_angle) {
	                                                   return { 
                                                        // start date that this entry applies for
                                                        start: start,
                                                        // end date for the entry 
                                                        end: end,
                                                        // the quadrant label
                                                        quadrant: quadrant,
                                                        // position is within the total of horizons.
                                                        position: position,
                                                        // angles are fractions of pi/2 (ie of a quadrant)
                                                        position_angle: position_angle,
                                                        // the learning end point with the total of horizons.
                                                        direction: direction,
                                                        // angles are fractions of pi/2 (ie of a quadrant)
                                                        direction_angle: direction_angle
                                                        };
                                                    }
                                                    radar('#radar',
                                                    // radar data
                                                    {
                                                    horizons: [ 'Sunset', 'Production', 'Rollout', 'Planning'],
                                                    quadrants: [ 'Packaged', 'Bespoke', 'Customised_Package'],
                                                    width: 600,
                                                    height: 600,
                                                    data: [
                                                   <xsl:apply-templates select="$allAppsForCap[own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value]" mode="RenderAppRow2a">
						                              <xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
				                                    </xsl:apply-templates>
                                                    ]
                                                    });
                                                </script>
											</div>
											<div class="col-xs-12 col-md-6">
												<h3>Unclassified Applications</h3>
												<ul>
													<xsl:apply-templates select="$allAppsForCap[not(own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value)]" mode="RenderAppMissing">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
													</xsl:apply-templates>
												</ul>
											</div>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</div>
							<hr/>
						</div>


						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<!-- render a Business Process table row  -->

	<!-- render an Application Provider table row  -->


	<xsl:template match="node()" mode="RenderAppRow2a">
		<xsl:variable name="ThisApp">
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'lifecycle_status_application_provider']/value"/>
		</xsl:variable>
		<xsl:variable name="ThisDM">
			<xsl:value-of select="current()/own_slot_value[slot_reference = 'ap_codebase_status']/value"/>
		</xsl:variable>
		<xsl:variable name="ThisStatus">
			<xsl:value-of select="$lifecycleStatus[name = $ThisApp]/own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
        <xsl:variable name="posn"><xsl:choose><xsl:when test="((position() div 10)) &gt; 1"><xsl:value-of select="1 div ((position() div 10))"/></xsl:when><xsl:otherwise><xsl:value-of select="((position() div 10))"/></xsl:otherwise></xsl:choose></xsl:variable> 
        <xsl:variable name="posn2"><xsl:choose><xsl:when test="((position() mod 2) = 0) and ($posn &lt;0.5)"><xsl:value-of select="$posn + 0.5"/></xsl:when><xsl:otherwise><xsl:value-of select="$posn"/></xsl:otherwise></xsl:choose></xsl:variable> 
		<xsl:if test="$deliveryModel[name = $ThisDM]/own_slot_value[slot_reference = 'name']/value">
			<xsl:if test="$ThisStatus"> { name: '<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>', description: '', links: [''], history: [ entry(new Date(2013,<xsl:value-of select="position()"/>,29),null,'<xsl:value-of select="$deliveryModel[name = $ThisDM]/own_slot_value[slot_reference = 'name']/value"/>', <xsl:choose>
					<xsl:when test="$ThisStatus = 'ProductionStrategic'">
						<xsl:value-of select="0.5 + (((position() div 10) mod 2) div 10)"/></xsl:when>
					<xsl:when test="$ThisStatus = 'OffStrategy'">
						<xsl:value-of select="(((position() div 10) mod 2) div 10)"/></xsl:when>
					<xsl:when test="$ThisStatus = 'Sunset'">
						<xsl:value-of select="0.3 + (((position() div 10) mod 2) div 10)"/></xsl:when>
					<xsl:when test="$ThisStatus = 'Under Planning'">
						<xsl:value-of select="0.9"/></xsl:when>
					<xsl:when test="$ThisStatus = 'Prototype'">
						<xsl:value-of select="0.72"/></xsl:when>
					<xsl:when test="$ThisStatus = 'Pilot'">
						<xsl:value-of select="0.68"/></xsl:when>
					<xsl:otherwise>0.2</xsl:otherwise>
				</xsl:choose>, <xsl:value-of select="$posn2"/>, 0, 0.5) ] } <xsl:if test="not(position() = last())">,</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="RenderAppMissing">
        <li>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
		</li>
    </xsl:template>


</xsl:stylesheet>
