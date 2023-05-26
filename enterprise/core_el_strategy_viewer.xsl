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
	<!-- 27.03.2023 NW/JM Created -->


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
    <xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/> 

	<!-- END GENERIC CATALOGUE PARAMETERS -->
    <xsl:variable name="repYN"><xsl:choose><xsl:when test="$targetReportId"><xsl:value-of select="$targetReportId"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>

	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>


	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Objective', 'Business_Driver', 'Service_Quality', 'Service_Quality_Measure', 'Service_Quality_Value', 'Group_Actor', 'Individual_Actor','Enterprise_Strategic_Plan')"/>
 	<!-- param4 = the optional taxonomy term used to scope the view -->
	<xsl:param name="param4"/>

    <xsl:variable name="busDriver" select="/node()/simple_instance[type='Business_Driver']"/>
	
	
    <xsl:variable name="goalTaxonomy" select="/node()/simple_instance[type='Taxonomy_Term'][own_slot_value[slot_reference='name']/value='Strategic Goal']"/> 
    <xsl:variable name="allBusObjectives" select="/node()/simple_instance[(type = 'Business_Objective') and not(own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name)]"/>
    
	<xsl:variable name="allStrategicGoals" select="/node()/simple_instance[(type = 'Business_Goal') or ((type = 'Business_Objective') and (own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name))]"/>
    <xsl:variable name="busGoals" select="$allStrategicGoals"/>
     
    

<xsl:key name="drvKey" match="$busDriver" use="own_slot_value[slot_reference = 'bd_motivated_objectives']/value"/>
<xsl:key name="oldGlsKey" match="$allStrategicGoals" use="own_slot_value[slot_reference = 'bo_motivated_by_driver']/value"/>
<xsl:key name="busGlsKey" match="$allStrategicGoals" use="own_slot_value[slot_reference = 'bo_motivated_by_driver']/value"/>
<xsl:key name="busObjKey" match="$allBusObjectives" use="own_slot_value[slot_reference = 'objective_supports_objective']/value"/>
<xsl:key name="busObjNewKey" match="$allBusObjectives" use="own_slot_value[slot_reference = 'objective_supports_goals']/value"/>
<xsl:key name="newglsKey" match="$allStrategicGoals" use="own_slot_value[slot_reference = 'goal_supported_by_objectives']/value"/>

    <!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
 
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor'][name=$allBusObjectives/own_slot_value[slot_reference = 'bo_owners']/value]"/>
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allBusinessServiceQualities" select="/node()/simple_instance[type = ('Business_Service_Quality','Service_Quality')]"/>

    <xsl:variable name="allBusinessServiceOBJ" select="/node()/simple_instance[type = 'OBJ_TO_SVC_QUALITY_RELATION']"/>
    <xsl:key name="busSvcKey" match="$allBusinessServiceOBJ" use="own_slot_value[slot_reference = 'obj_to_svc_quality_objective']/value"/>
 
    
	<xsl:variable name="allBusinessServiceQualityValues" select="/node()/simple_instance[type = 'Business_Service_Quality_Value']"/>
    <xsl:key name="stratPlans" match="/node()/simple_instance[type='Enterprise_Strategic_Plan']" use="own_slot_value[slot_reference='strategic_plan_supports_objective']/value"/> 
    <xsl:key name="planToElementkey" match="/node()/simple_instance[type='PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference='plan_to_element_plan']/value"/>
    <xsl:key name="projectskey" match="/node()/simple_instance[type='Project']" use="own_slot_value[slot_reference='ca_planned_changes']/value"/>
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
				<link type="text/css" href="css/animate.min.css" rel="stylesheet"></link>
				<style>
					:root {
						--light-blue: #EBF5FA;
						--blue: #007ACE;
						--light-purple: #F6F0FD;
						--purple: #9C6ADE;
						--light-teal: #E0F5F5;
						--teal: #47C1BF;
						--light-yellow: #FFEA8A;
						--yellow: #EEC200;
						--light-orange: #FFC58B;
						--orange:#F49342;						
						--light-red: #FEAF9A;
						--red: #ED6347;
						--dark-red:#BF0711;
						--light-green: #BBE5B3;
						--green: #50B83C;
						--dark-green: #108043;						
						--light-grey: #F4F6F8;
						--dark-grey: #454F5B;
						--white: #FFF;
					}
					
					#strat-panel-wrapper {
						height: calc(100vh - 220px);
						width: 100%;
						position: relative;
					}
					.strat-panel {
						position: absolute;
						background-color: #fff;
						height: calc(100vh - 140px);
						width: 100%;
						overflow-y:hidden;
					}
					
					#driver-panel{
						height: calc(100vh - 300px);
						overflow-y:auto;
						padding-bottom: 15px;
					}
					
					.detail-scroller{
						height: calc(100vh - 260px);
						overflow-y:auto;
						padding-bottom: 15px;
					}
					
					.vision-blob {
						display: flex;
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.35);
						border-radius: 8px;
					}
					.vision-blob-left,
					.vision-blob-right {
						padding: 15px;
						font-weight: 900;
						font-size: 150%;
					}
					.vision-blob-left {
					}
					.vision-blob-right {
					}
					
					.dash-blob-wrapper {
						display: flex;
						gap: 15px;
						align-items: center;
						justify-content: center;
					}
					.dash-blob {
						position: relative;
						flex-grow: 1;
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.35);
						border-radius: 8px;
						padding: 10px;
						color: #fff;
					}
					.dash-title {
						font-size: 200%;
						font-weight: 700;
					}
					.dash-subtitle {
						font-size: 110%;
						font-style: italic;
						font-weight: 400;
						line-height: 1.1em;
					}
					.dash-type {
						font-size: 125%;
						font-weight: 300;
						text-transform: uppercase;
						margin-bottom: 10px;
					}
					.dash-blob > i {
						position: absolute;
						bottom: 10px;
						right: 10px;
						font-size: 200%;
						opacity: 0.5;
					}
					
					.blob-summary:hover {
						cursor: help;
					}
					
					.detail-outer-wrapper {
						display: flex;
						gap: 15px;
						flex-wrap: wrap;
						justify-content: space-between;
					}
					#side-nav .detail-outer-wrapper {
						height: auto;
					}
					.detail-outer {
						padding: 10px 10px 20px 10px;
						position: relative;
						flex-basis: 550px;
						flex-grow: 1;
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.35);
						background-color: var(--light-grey);
					}
					.detail-outer-name {
						font-size: 115%;
						font-weight: 700;
						display: inline-block;
					}
					.detail-outer-type {
						opacity: 0.75;
					}
					.detail-outer-obj-count {
						position: absolute;
						top: 5px;
						right: 5px;
						letter-spacing: 1px;
						cursor: help;
					}
					.count-bar {
						border-radius: 3px;
						<!--background-color: #EEC200;-->
						width: 100%;
						height: 5px;
					}
					
					.detail-inner-wrapper {
						display: flex;
						gap: 15px;
						flex-wrap: wrap;
						flex-direction: row;
					}
					.detail-inner {
						min-width: 160px;
						padding: 5px 20px 25px 20px;
						position: relative;
						border-radius: 30px;
						flex-basis: auto;
						font-weight: 600;
						font-size: 1em;
						box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.35);
						background-color: var(--dark-grey);
					}
					.detail-inner-name {
					}
					.detail-inner-type {
						position: absolute;
						bottom: 5px;
						left: 20px;
						opacity: 0.5;
						font-weight: 300;
						font-size: 80%;
					}
					.detail-inner > i {
						position: absolute;
						bottom: 5px;
						right: 15px;
						opacity: 0.5;
						font-size: 90%;
					}
					.back-to-dash-driver:hover,
					.back-to-dash-goal:hover {
						cursor: pointer;
						opacity: 0.5;
					}
					.driver-detail:hover,
					.goal-detail:hover,
					.obj-detail:hover,
					.driver-to-goal-detail:hover {
						cursor: pointer;
						opacity: 0.5;
						text-decoration: underline;
					}
					.side-nav{
						height: calc(100vh - 41px);
						overflow-y: auto;
						width: 40vw;
						position: fixed;
						z-index: 1;
						top: 41px;
						right: 0;
						background-color: #ffffff;
						overflow-x: hidden;
						transition: margin-right 0.5s;
						padding: 10px 10px 10px 10px;
						box-shadow: rgba(0, 0, 0, 0.5) -1px 2px 4px 0px;
						margin-right: -40vw;
					}
					
					.side-nav .clsPanel{
						position: absolute;
						top: 10px;
						right: 10px;
						font-size: 16px;
						color: #ccc;
					}
					
					@media screen and (max-height : 450px){
						.side-nav{
							padding-top: 15px;
						}
					
						.side-nav a{
							font-size: 14px;
						}
					}
					.planClick > a {
						color: #fff;
					}
                    .infoBlock{
                        border-radius: 50px;
                        padding: 5px 10px;
						font-weight: 700;
                    }
                    .impactCount{
                        background-color: #30dac9;
                        color:#fff;
                        }
                    .projectCount{
                        background-color: #c679f5;
                        color:#fff;
                    }
                    .popover {
                    	max-height: 400px;
                    	max-width: 600px;
                    	font-size: 90%;
                    	overflow-y: auto;
                    	overflow-x: hidden;
                    }
				</style>
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
	            <div class="container-fluid" id="summary-content">
	                <div class="row">
	                    <div class="col-xs-12">
	                        <div class="page-header">
	                            <h1>
	                                <span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
	                                <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Strategic Summary')"/> </span><xsl:text> </xsl:text>
	                            </h1>
	                        </div>
	                    </div>
	                </div>
	            	<div id="strat-panel-wrapper">
						<div id="vision-panel" class="strat-panel animate__animated animate__zoomIn">
							<div id="vision-blobs-panel" style="display:none;"/>
							<div id="dash-blobs-panel"/>
							<div id="driver-panel" class="top-30"/>
						</div>
	            		<div id="driver-detail-panel" class="strat-panel hiddenDiv animate__animated animate__zoomOut"/>
	            		<div id="goal-detail-panel" class="strat-panel hiddenDiv animate__animated animate__zoomOut"/> 
	            	</div>
	            	<div id="side-nav" class="side-nav">
                        <i class="fa fa-times clsPanel"/>
                        <div id="obj-panel" class="top-20"/>
                    </div>
	            </div>
				 <!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				
				<script id="vision-template" type="text/x-handlebars-template">
					<div class="vision-blob bottom-30" style="background-color: var(--yellow);color:var(--white);">
						<div class="vision-blob-left" style="background-color:var(--light-yellow);color:var(--yellow);">
							<span>Vision</span>
						</div>
						<div class="vision-blob-right">
							<span>To help people throughout the world realize their full potential</span>
						</div>
					</div>
				</script>
				
				<script id="dash-blobs-template" type="text/x-handlebars-template">
					<div class="dash-blob-wrapper">
						<div class="dash-blob blob-summary" tabindex="0" role="button" data-toggle="popover" data-trigger="click" style="background-color:var(--blue);">
							<div class="dash-title text-white">
								{{this.drivers.length}}
							</div>
							<div class="dash-type text-white">Drivers</div>
							<i class="fa fa-fw fa-truck right-5"></i>
						</div>
						<div class="popover">
							<div class="impact">Drivers</div>
							<hr class="tight"></hr>
							<ul>
								<xsl:for-each select="$allDrivers">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</div>
						<div>
							<i class="fa fa-caret-right" style="font-size: 64px;color: var(--dark-grey);"/>
						</div>
						<div class="dash-blob blob-summary" tabindex="0" role="button" data-toggle="popover" data-trigger="click" style="background-color:var(--purple);">
							<div class="dash-title">
								{{this.goals.length}}
							</div>
							<div class="dash-type">Goals</div>
							<i class="fa fa-fw fa-plane right-5"></i>
						</div>
						<div class="popover">
							<div class="impact">Goals</div>
							<hr class="tight"></hr>
							<ul>
								<xsl:for-each select="$busGoals">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</div>
						<div>
							<i class="fa fa-caret-right" style="font-size: 64px;color: var(--dark-grey);"/>
						</div>
						<div class="dash-blob blob-summary" tabindex="0" role="button" data-toggle="popover" data-trigger="click" style="background-color: var(--teal);">
							<div class="dash-title">
								{{this.objectives.length}}
							</div>
							<div class="dash-type">Objectives</div>
							<i class="fa fa-fw fa-check-circle right-5"></i>
						</div>
						<div class="popover">
							<div class="impact">Objectives</div>
							<hr class="tight"></hr>
							<ul>
								<xsl:for-each select="$allBusObjectives">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</div>
					</div>
				</script>
				
				<script id="driver-template" type="text/x-handlebars-template">
					<div class="detail-outer-wrapper">
					{{#each this.drivers}}
					<div class="detail-outer">
						<div class="detail-outer-name driver-detail driverClick">
							<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
							{{this.name}}
						</div>
						<div class="detail-outer-type uppercase small" style="color: var(--blue);"><i class="fa fa-fw fa-truck right-5"></i>Driver</div>
						<div class="detail-outer-obj-count xsmall" tabindex="0" role="button" data-toggle="popover" data-trigger="focus">
							<div class="count-bar" style="background-color: var(--teal)"/>
							{{#getObjectives this}}{{/getObjectives}}
							<span> Objectives</span>
						</div>
						<div class="popover">
							<div class="impact">Objectives</div>
							<hr class="tight"></hr>
							<ul>
								{{#each this.goals}} 
					                {{#each this.objectives}} 
										<li>{{this.name}}</li>
									{{/each}}
								{{/each}}
							</ul>
						</div>						
						<div class="detail-inner-wrapper top-10">
							{{#each this.goals}}
								<div class="detail-inner text-white">
									<div class="detail-inner-name goal-detail goalClick">
										<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
										{{this.name}}
									</div>
									<div class="detail-inner-type uppercase xxsmall">Goal</div>
									<i class="fa fa-fw fa-plane right-5"></i>
								</div>
							{{/each}}
						</div>
					</div>
					{{/each}}
					</div>
				</script>
				
				<script id="driver-summary-template" type="text/x-handlebars-template">	
					<div class="back-to-dash-driver xlarge bottom-15" style="color:var(--dark-grey)">
						<i class="fa fa-fw fa-chevron-circle-left right-5"></i>
						<span class="fontBlack">Back to Dashboard</span>
					</div>
					<div class="dash-blob" style="background-color:var(--blue);">
						<div class="dash-title text-white">{{this.name}}</div>
						<div class="dash-subtitle text-white">{{this.description}}</div>
						<div class="dash-type text-white">Driver</div>
						<i class="fa fa-fw fa-truck right-5"></i>
					</div>
					<div class="detail-scroller">
						<div class="detail-outer-wrapper top-30">
							{{#each this.goals}}
							<div class="detail-outer" style="background-color: var(--light-grey);">
								<div class="detail-outer-name driver-to-goal-detail goalClick">
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
									{{this.name}}</div>
								<div class="detail-outer-type uppercase small" style="color: var(--purple);"><i class="fa fa-fw fa-plane right-5"></i>Goal</div>
								<div class="detail-outer-obj-count xsmall" tabindex="0" role="button" data-toggle="popover" data-trigger="focus">
									<div class="count-bar" style="background-color: var(--orange)"></div>
									<span>{{#getPlans this}}{{/getPlans}}</span>
									<span> Strategic Plans</span>
								</div>
								<div class="popover">
									<div class="impact">Strategic Plans</div>
									<hr class="tight"></hr>
									<ul>
										{{#each this.objectives}} 
							                {{#each this.plans}} 
												<li>{{this.name}}</li>
											{{/each}}
										{{/each}}
									</ul>
								</div>
								<div class="detail-inner-wrapper top-10">
									{{#each this.objectives}}
									<div class="detail-inner text-white">
										<div class="detail-inner-name obj-detail objClick">
											<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
											{{this.name}}
										</div>
										<div class="detail-inner-type uppercase xxsmall">Objective</div>
										<i class="fa fa-fw fa-check-circle right-5"></i>
									</div>
									{{/each}}
								</div>
							</div>
							{{/each}}
						</div>
					</div>
				</script>

				<script id="goal-summary-template" type="text/x-handlebars-template">
				    <div class="back-to-dash-goal xlarge bottom-15" style="color:var(--dark-grey)">
						<i class="fa fa-fw fa-chevron-circle-left right-5"></i>
						<span class="fontBlack">Back to Dashboard</span>
					</div>
					<div class="dash-blob" style="background-color:var(--purple);">
						<div class="dash-title">{{this.name}}</div>
						<div class="dash-subtitle">{{this.description}}</div>
						<div class="dash-type">Goal</div>
						<i class="fa fa-fw fa-plane right-5"></i>
					</div>
					<div class="detail-scroller">
						<div class="detail-outer-wrapper top-30">
							{{#each this.objectives}}
							<div class="detail-outer" style="background-color: var(--light-grey);">
								<div class="detail-outer-name obj-detail objClick">
									<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
									{{this.name}}
								</div>
								<div class="detail-outer-type uppercase small" style="color: var(--teal);"><i class="fa fa-fw fa-plane right-5"></i>Objective</div>
								<div class="detail-outer-obj-count xsmall" tabindex="0" role="button" data-toggle="popover" data-trigger="focus">
									<div class="count-bar" style="background-color: var(--yellow)"/>
									<span>{{#getElements this}}{{/getElements}}</span>
									<span> Impacted Elements</span>
								</div>
								<div class="popover">
									<div class="impact">Impacted Elements</div>
									<hr class="tight"></hr>
									<ul>
									{{#each this.plans}}
										{{#each this.plan2elements}}
											<li>
												{{this.name}}
											</li>
										{{/each}}
									{{/each}}
									</ul>
								</div>
								<div class="detail-inner-wrapper top-10">
									{{#each this.plans}}
									<div class="detail-inner text-white">
										<div class="detail-inner-name">{{this.name}}</div>
										<div class="detail-inner-type uppercase">Strategic Plan</div>
										<i class="fa fa-fw fa-calendar right-5"></i>
									</div>
									{{/each}}
								</div>
							</div>
							{{/each}}
						</div>
					</div>
				</script>
				
				
				<script id="obj-template" type="text/x-handlebars-template">
					<div class="dash-blob" style="background-color:var(--teal);font-size: 80%;">
						<div class="dash-title text-white">{{this.name}}</div>
						<div class="dash-subtitle text-white">{{this.description}}</div>
						<div class="dash-type text-white">Objective</div>
						<i class="fa fa-fw fa-check-circle right-5"></i>
					</div>
					<div class="detail-outer-wrapper top-15">
						{{#each this.plans}}
						<div class="detail-outer" style="background-color: var(--dark-grey);flex-basis:250px; color: #fff;">
							<div class="detail-outer-name obj-detail planClick">
								<xsl:attribute name="easid">{{this.id}}</xsl:attribute>
								{{#essRenderInstanceLink this 'Enterprise_Strategic_Plan'}}{{/essRenderInstanceLink}}
							</div>
							<div class="dash-subtitle text-white">{{this.description}}</div>
							<div class="detail-outer-type uppercase small top-5"><i class="fa fa-fw fa-calendar right-5"></i>Plan</div>
							<div class="top-10"><strong>Start Date: </strong>{{this.startDate}}</div>
						    <div><strong>End Date: </strong>{{this.endDate}}</div>
							<div class="plan-attr-wrapper top-10" style="display: flex; gap:10px;">
							    <div class="infoBlock" style="background-color: var(--yellow);">{{this.plan2elements.length}}<span> Impacts</span></div>
							    <div class="infoBlock" style="background-color: var(--orange);">{{this.projects.length}}<span> Projects</span></div>
							</div>
						</div>
						{{/each}}
					</div>
				</script>
				
				<script id="orgtable-template" type="text/x-handlebars-template">
					<table class="table table-bordered table-header-background" id="orgObjTable" width="100%">
						<thead>
							<tr>
								<th class="cellWidth-20pc">
									<xsl:value-of select="eas:i18n('Organisation')"/>
								</th>
								<th class="cellWidth-20pc">
									<xsl:value-of select="eas:i18n('Objective')"/>
								</th>
								<th class="cellWidth-20pc">
									<xsl:value-of select="eas:i18n('Supports Strategic Goals &amp; Drivers')"/>
								</th>
							<!--	<th class="cellWidth-10pc">
									<xsl:value-of select="eas:i18n('Supports Drivers')"/>
								</th>
			                -->
							</tr>
						</thead>
						<tbody>
			                {{#each this}} 
			                    {{#each this.objectives}} 
									<tr>	 
										<td class="cellWidth-20pc" style="background-color:#e3e3e3;">
											<b>{{../this.name}}</b>
										</td>
										<td class="cellWidth-20pc"> 
		                                        <div class="objectivesBlob">{{{essRenderInstanceMenuLink this}}}</div>
										</td>
										<td class="cellWidth-20pc" >
		                                    <table>
		                                        {{#each this.goals}}
		                                        <tr class="goalsTable">
		                                            <td class="goalsTd"> 
		                                                    <div class="goalsBlob">{{this.name}}</div>
		                                            </td>
		                                            <td class="goalsTd">
		                                                <ul class="ess-list-tags-org" style=" padding-left:5px" >
		                                                {{#each this.mappedDrivers}} 
		                                                <div class="driversBlob">{{this.driver}}</div>
		                                                {{/each}}
		                                                </ul>
		                                            </td>
		                                        </tr>
		                                        {{/each}}
		                                    </table>	                                  
										</td>										 
									</tr> 
			                    {{/each}} 
			                {{/each}}
			            </tbody>
			            <tfoot>
			                <tr>
			                    <th class="cellWidth-20pc">
			                        <xsl:value-of select="eas:i18n('Organisation')"/>
			                    </th>
			                    <th class="cellWidth-20pc">
			                        <xsl:value-of select="eas:i18n('Objective')"/>
			                    </th>
			                    <th class="cellWidth-20pc">
			                        <xsl:value-of select="eas:i18n('Supports Strategic Goals &amp; Drivers')"/>
			                    </th>
			                <!--	<th class="cellWidth-10pc">
			                        <xsl:value-of select="eas:i18n('Supports Drivers')"/>
			                    </th>
			                -->
			                </tr>
			            </tfoot>
					</table>	
				</script>
				
				<script>
				<xsl:call-template name="RenderJSMenuLinkFunctionsTEMP">
					<xsl:with-param name="linkClasses" select="$linkClasses"/>
				</xsl:call-template>
				let drivers=[<xsl:apply-templates select="$busDriver" mode="drivers"/>] 
				let orgs=[<xsl:apply-templates select="$allGroupActors" mode="orgs"/>] 
				let goals=[<xsl:apply-templates select="$busGoals" mode="busgoals"/>] 
				let strategyMap= {"strategy":{ "vision": "some about the text for the organisation","drivers":[<xsl:apply-templates select="$busDriver" mode="strategydrivers"/>],
				"goals":[<xsl:apply-templates select="$busGoals" mode="goals"/>],
				"objectives":[<xsl:apply-templates select="$allBusObjectives" mode="objs"/>]}};
				
				//console.log('strategyMap', strategyMap)
				//console.log('orgs', orgs)
				
				$(document).ready(function () {
					
					Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
						return (arg1 == arg2) ? options.fn(this): options.inverse(this);
					});
					
					Handlebars.registerHelper('getObjectives', function (arg1, options) {
						let oCount = 0;
						//console.log('a', arg1)
						arg1.goals.forEach((e) => {
							oCount = oCount + e.objectives.length
						})
						return oCount
					});
					Handlebars.registerHelper('getPlans', function (arg1, options) {
						let pCount = 0;
						//console.log('a', arg1)
						arg1.objectives.forEach((e) => {
							pCount = pCount + e.plans.length
						})
						return pCount
					});
					
					Handlebars.registerHelper('getElements', function (arg1, options) {
						let elCount = 0;
						//console.log('a', arg1)
						arg1.plans.forEach((e) => {
							elCount = elCount + e.plan2elements.length
						})
						return elCount
					});
					
					var visionFragment = $("#vision-template").html();
						visionTemplate = Handlebars.compile(visionFragment);
					
					var driverFragment = $("#driver-template").html();
						driverTemplate = Handlebars.compile(driverFragment);
					
					var driverSummaryFragment = $("#driver-summary-template").html();
						driverSummaryTemplate = Handlebars.compile(driverSummaryFragment);
					
					var goalSummaryFragment = $("#goal-summary-template").html();
						goalSummaryTemplate = Handlebars.compile(goalSummaryFragment);
					
					var objFragment = $("#obj-template").html();
						objTemplate = Handlebars.compile(objFragment);
					
					var dashBlobsFragment = $("#dash-blobs-template").html();
						dashBlobsTemplate = Handlebars.compile(dashBlobsFragment);
					
					$('#vision-blobs-panel').html(visionTemplate(strategyMap.strategy));
					$('#dash-blobs-panel').html(dashBlobsTemplate(strategyMap.strategy));
					$('#driver-panel').html(driverTemplate(strategyMap.strategy));
					$('#driver-detail-panel').html(driverTemplate(strategyMap.strategy));
					
					const visionPanel = document.querySelector('#vision-panel');
					const driverDetailPanel = document.querySelector('#driver-detail-panel');
					const goalDetailPanel = document.querySelector('#goal-detail-panel');
					
					// Wait for the vision detail animation to end (avoid JS race conditions)
					visionPanel.addEventListener('animationend', () => {
						// Add listeners for drivers
						$('.driverClick').on('click', function () {
							let focus = strategyMap.strategy.drivers.find((d) => {
								return d.id == $(this).attr('easid')
							});
							$('#driver-detail-panel').html(driverSummaryTemplate(focus));
							initDetailPopovers();
							
							// Hide Vision Panel
							$('#vision-panel').removeClass('animate__zoomIn').addClass('animate__zoomOut').fadeOut();
							// Show Driver Panel
							$('#driver-detail-panel').show().addClass('animate__zoomIn').removeClass('animate__zoomOut');
							
							
						});
						// Add listeners for goals
						$('.goalClick').on('click', function () {
							let focus = strategyMap.strategy.goals.find((d) => {
								return d.id == $(this).attr('easid');
							});
							$('#goal-detail-panel').html(goalSummaryTemplate(focus));
							initDetailPopovers();
							$('.objClick').on('click', function () {
								let focus = strategyMap.strategy.objectives.find((d) => {
									return d.id == $(this).attr('easid');
								});
								//console.log('focus', focus);
								$('#obj-panel').html(objTemplate(focus));
							});
							// Hide Side Bar
							closeNav();
							// Hide Vision Panel
							$('#vision-panel').removeClass('animate__zoomIn').addClass('animate__zoomOut').fadeOut();
							// Show Goal Panel
							$('#goal-detail-panel').show().addClass('animate__zoomIn').removeClass('animate__zoomOut');
						});
					});
					
					// Wait for the driver detail animation to end
					driverDetailPanel.addEventListener('animationend', () => {					
						// Add Listener for goal details
						$('.goalClick').on('click', function () {
							let focus = strategyMap.strategy.goals.find((d) => {
								return d.id == $(this).attr('easid');
							});
							$('#goal-detail-panel').html(goalSummaryTemplate(focus));
							initDetailPopovers();
							$('.objClick').on('click', function () {
								let focus = strategyMap.strategy.objectives.find((d) => {
									return d.id == $(this).attr('easid');
								});
								//console.log('focus', focus);
								$('#obj-panel').html(objTemplate(focus));
							});
							
							// Hide Side Bar
							closeNav();
							// Hide Driver Detail Panel
							$('#driver-detail-panel').removeClass('animate__zoomIn').addClass('animate__zoomOut').fadeOut();
							// Show Goal Panel
							$('#goal-detail-panel').show().addClass('animate__zoomIn').removeClass('animate__zoomOut');
						});
						
						// Add Listener for Objectives
						$('.objClick').on('click', function () {
							let focus = strategyMap.strategy.objectives.find((d) => {
								return d.id == $(this).attr('easid')
							});
							//console.log('focus', focus)
							$('#obj-panel').html(objTemplate(focus));
							openNav()
							$('.clsPanel').on('click', function () {
								closeNav();
							});
						});
						
						// Add Listener for Back to Dashboard
						$('.back-to-dash-driver').click(function(){
							// Hide Side Bar
							closeNav();
							// Hide Driver Panel
							$('#driver-detail-panel').removeClass('animate__zoomIn').addClass('animate__zoomOut').fadeOut();
							// Show Dashboard Panel
							$('#vision-panel').show().addClass('animate__zoomIn').removeClass('animate__zoomOut');
						});
					});
					
					// Wait for the goal detail animation to end
					goalDetailPanel.addEventListener('animationend', () => {
						// Add Listener for Back to Dashboard
						$('.back-to-dash-goal').click(function(){
							// Hide Side Bar
							closeNav();
							// Hide Goal Panel
							$('#goal-detail-panel').removeClass('animate__zoomIn').addClass('animate__zoomOut').fadeOut();
							// Show Dashboard Panel
							$('#vision-panel').show().addClass('animate__zoomIn').removeClass('animate__zoomOut');
						});
						
						// Add Listener for Objectives
						$('.objClick').on('click', function () {
							let focus = strategyMap.strategy.objectives.find((d) => {
								return d.id == $(this).attr('easid')
							});
							//console.log('focus', focus)
							$('#obj-panel').html(objTemplate(focus));
							openNav()
							$('.clsPanel').on('click', function () {
								closeNav();
							});
						});
					});
					
					function openNav(){document.getElementById("side-nav").style.marginRight = "0px";}		
					function closeNav(){document.getElementById("side-nav").style.marginRight = "-40vw";}
					
					$('.blob-summary').popover({
						container: 'body',
						animation: true,
						html: true,
						sanitize: false,
						trigger: 'click',
						placement: 'bottom',
						content: function () {
							return $(this).next().html();
						}
					});
					
					initDetailPopovers();
					
					function initDetailPopovers() {
						$('.detail-outer-obj-count').popover({
							container: 'body',
							animation: true,
							html: true,
							sanitize: false,
							trigger: 'focus',
							placement: 'auto',
							content: function () {
								return $(this).next().html();
							}
						});
					}
					
					const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
					
					var reportURL = '<xsl:value-of select="$targetReport/own_slot_value[slot_reference=' report_xsl_filename ']/value"/>';
					var meta =[ {
						"classes":[ "Enterprise_Strategic_Plan"], "menuId": "stratPlanGenMenu"
					}];
					function essGetMenuName(instance) {
						let menuName = null;
						if ((instance != null) &amp;&amp;
						(instance.meta != null) &amp;&amp;
						(instance.meta.classes != null)) {
							menuName = instance.meta.menuId;
						} else if (instance.classes != null) {
							menuName = instance.meta.classes;
						}
						return menuName;
					}
					
					Handlebars.registerHelper('essRenderInstanceLink', function (instance, type) {
						
						let targetReport = "<xsl:value-of select=" $repYN "/>";
						let linkMenuName = essGetMenuName(instance);
						
						if (targetReport.length &gt; 1) {
							let linkURL = reportURL;
							let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
							let linkId = instance.id + 'Link';
							instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';
							
							return instanceLink;
						} else {
							let thisMeta = meta.filter((d) => {
								return d.classes.includes(type)
							});
							instance[ 'meta'] = thisMeta[0]
							let linkMenuName = essGetMenuName(instance);
							let instanceLink = instance.name;
							
							if (linkMenuName != null) {
								let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
								let linkClass = 'context-menu-' + linkMenuName;
								let linkId = instance.id + 'Link';
								let linkURL = reportURL;
								instanceLink = '<a class="' + linkClass + '" href="' + linkHref + '"  id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';
								
								return instanceLink;
							}
						}
					})
				});
				</script>
			</body>
		</html>
    </xsl:template>
    
    <xsl:template match="node()" mode="strategydrivers">
            <xsl:variable name="this" select="current()"/>
 <!--   <xsl:variable name="thisGoals" select="$busGoals[name=$this/own_slot_value[slot_reference='bd_motivated_objectives']/value]"/>
 -->          <xsl:variable name="thisGoals" select="key('busGlsKey',current()/name)"/>
            {"id":"<xsl:value-of select="current()/name"/>",
            "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
            "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
            "goals":[<xsl:apply-templates select="$thisGoals" mode="goals"/>]}<xsl:if test="position()!=last()">,</xsl:if> 
    </xsl:template> 

<xsl:template match="node()" mode="drivers">
		<xsl:variable name="this" select="current()"/>
<!-- <xsl:variable name="thisGoals" select="$busGoals[name=$this/own_slot_value[slot_reference='bd_motivated_objectives']/value]"/>
-->
        <xsl:variable name="thisGoals" select="key('busGlsKey',current()/name)"/>
		{
		"id":"<xsl:value-of select="current()/name"/>",
		"driver":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
		"goals":[<xsl:apply-templates select="$thisGoals" mode="goals"/>]}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template>
	
<xsl:template match="node()" mode="goals">
	<xsl:variable name="this" select="current()"/>
   <!-- <xsl:variable name="thisObjsOld" select="$allBusObjectives[name=$this/own_slot_value[slot_reference='objective_supported_by_objective']/value]"/> 
 <xsl:variable name="thisObjsNew" select="$allBusObjectives[name=$this/own_slot_value[slot_reference='goal_supported_by_objectives']/value]"/>
-->
    <xsl:variable name="thisObjsOld" select="key('busObjKey',current()/name)"/>
    <xsl:variable name="thisObjsNew" select="key('busObjNewKey',current()/name)"/>
    
    <xsl:variable name="thisObjs" select="$thisObjsOld union $thisObjsNew"/>
    {"goal":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
    "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
    "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
    "id":"<xsl:value-of select="current()/name"/>",
    "objectives":[<xsl:apply-templates select="$thisObjs" mode="objs"/>]}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template>   
	
<xsl:template match="node()" mode="objs">
	<xsl:variable name="this" select="current()"/>
	<xsl:variable name="busObjMeasuresOld" select="$allBusinessServiceQualityValues[name = current()/own_slot_value[slot_reference = 'bo_measures']/value]"/>
  <!--  <xsl:variable name="busObjServtoObj" select="$allBusinessServiceOBJ[name = current()/own_slot_value[slot_reference = 'bo_performance_measures']/value]"/>	-->
    <xsl:variable name="busObjServtoObj" select="key('busSvcKey',current()/name)"/>
    	
    <xsl:variable name="busObjMeasuresNew" select="$allBusinessServiceQualities[name =$busObjServtoObj/own_slot_value[slot_reference = 'obj_to_svc_quality_service_quality']/value]"/>
    <xsl:variable name="busObjMeasures" select="$busObjMeasuresOld union $busObjMeasuresNew"/>
    <xsl:variable name="busObjOrgOwners" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
    <xsl:variable name="busObjIndividualOwners" select="$allIndividualActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
    <xsl:variable name="busObjTargetDate" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bo_target_date']/value]"/>
    <!--
    <xsl:variable name="thisGoalsOld" select="$busGoals[own_slot_value[slot_reference='objective_supported_by_objective']/value=current()/name]"/> 
    <xsl:variable name="thisGoalsNew" select="$busGoals[own_slot_value[slot_reference='goal_supported_by_objectives']/value=current()/name]"/>
    -->
    <xsl:variable name="thisGoalsOld" select="key('busObjKey',current()/name)"/>
    <xsl:variable name="thisGoalsNew" select="key('newglsKey',current()/name)"/>

    <xsl:variable name="thisGoals" select="$thisGoalsNew union $thisGoalsOld"/>
    <xsl:variable name="thisPlans" select="key('stratPlans', current()/name)"/>
     
	{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
    "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",	
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>",
	"date":"<xsl:value-of select="$this/own_slot_value[slot_reference='busObjTargetDate']/value"/>",
	"busObjMeasures":[<xsl:for-each select="$busObjMeasures">{"id":"<xsl:value-of select="current()/name"/>", "name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>],
	"busObjOrgOwners":[<xsl:for-each select="$busObjOrgOwners">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="current()"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
	</xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>],
	"busObjIndividualOwners":[<xsl:for-each select="$busObjIndividualOwners">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
		<xsl:with-param name="theSubjectInstance" select="current()"/>
		<xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if> </xsl:for-each>],
    "goals":[<xsl:for-each select="$thisGoals">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    "plans":[<xsl:for-each select="$thisPlans">
            <xsl:variable name="thisImpacts" select="key('planToElementkey', current()/name)"/>
            <xsl:variable name="thisProjects" select="key('projectskey', $thisImpacts/name)"/>{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
    "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",	
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>",
    "startDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"/>",
    "endDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"/>",
    "plan2elements":[<xsl:for-each select="$thisImpacts">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
    		<xsl:with-param name="isForJSONAPI" select="true()"/>
        </xsl:call-template>",
    "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",	
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
    "projects":[<xsl:for-each select="$thisProjects">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
    "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",	
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>",
    "proposedStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_proposed_start_date_iso_8601']/value"/>",
    "targetEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_target_end_date_iso_8601']/value"/>",
    "actualStartDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_actual_start_date_iso_8601']/value"/>",
    "forecastEndDate":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'ca_forecast_end_date_iso_8601']/value"/>"
    }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]

    }<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template> 

<xsl:template match="node()" mode="orgs">
   <!-- <xsl:variable name="thisdrivers" select="$allDrivers[own_slot_value[slot_reference='bd_motivated_objectives']/value=current()/name]"/>
-->
    <xsl:variable name="thisdrivers" select="key('drvKey', current()/name)"/>
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="busObjs" select="$allBusObjectives[own_slot_value[slot_reference = 'bo_owners']/value=current()/name]"/> 
    {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>", 
    "objectives":[<xsl:apply-templates select="$busObjs" mode="objs"/>],
    "drivers":[<xsl:for-each select="$thisdrivers">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template> 

<xsl:template match="node()" mode="busgoals">
  <!--  <xsl:variable name="thisdrivers" select="$allDrivers[own_slot_value[slot_reference='bd_motivated_objectives']/value=current()/name]"/>
  -->
    <xsl:variable name="thisdrivers" select="key('drvKey', current()/name)"/>
    <xsl:variable name="this" select="current()"/>
  <!--  <xsl:variable name="busObjs" select="$allBusObjectives[name=current()/own_slot_value[slot_reference = 'goal_supported_by_objectives']/value]"/>
  -->
    <xsl:variable name="busObjs" select="key('busObjNewKey',current()/name)"/>
    {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>", 
    "objectives":[<xsl:apply-templates select="$busObjs" mode="objs"/>],
    "drivers":[<xsl:for-each select="$thisdrivers">{"id":"<xsl:value-of select="current()/name"/>","name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template> 

<xsl:template name="RenderJSMenuLinkFunctionsTEMP">
		<xsl:param name="linkClasses" select="()"/>
		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
		var esslinkMenuNames = {
			<xsl:call-template name="RenderClassMenuDictTEMP">
				<xsl:with-param name="menuClasses" select="$linkClasses"/>
			</xsl:call-template>
		}
     
		function essGetMenuName(instance) {  
			let menuName = null;
			if(instance.meta?.anchorClass) {
				menuName = esslinkMenuNames[instance.meta.anchorClass];
			} else if(instance.className) {
				menuName = esslinkMenuNames[instance.className];
			}
			return menuName;
		}
		
		Handlebars.registerHelper('essRenderInstanceMenuLink', function(instance){ 
          
			if(instance != null) {
                let linkMenuName = essGetMenuName(instance); 
				let instanceLink = instance.name;    
				if(linkMenuName) {
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
                } 
				return instanceLink;
			} else {
				return '';
			}
		});
    </xsl:template>
    <xsl:template name="RenderClassMenuDictTEMP">
		<xsl:param name="menuClasses" select="()"/>
		<xsl:for-each select="$menuClasses">
			<xsl:variable name="this" select="."/>
			<xsl:variable name="thisMenus" select="$allMenus[own_slot_value[slot_reference = 'report_menu_class']/value = $this]"/>
			"<xsl:value-of select="$this"/>": <xsl:choose><xsl:when test="count($thisMenus) > 0">"<xsl:value-of select="$thisMenus[1]/own_slot_value[slot_reference = 'report_menu_short_name']/value"></xsl:value-of>"</xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose><xsl:if test="not(position() = last())">,
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
</xsl:stylesheet>
<!-- buttons Copyright (c) 2022 by Florin Pop (https://codepen.io/FlorinPop17/pen/dyPvNKK)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->