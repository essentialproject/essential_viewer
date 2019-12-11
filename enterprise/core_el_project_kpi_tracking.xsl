<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../common/core_js_functions.xsl" />
    <xsl:include href="../common/core_doctype.xsl" />
    <xsl:include href="../common/core_common_head_content.xsl" />
    <xsl:include href="../common/core_header.xsl" />
    <xsl:include href="../common/core_footer.xsl" />
    <xsl:include href="../common/core_external_doc_ref.xsl" />
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes" />

    <xsl:param name="param1" />

    <!-- START GENERIC PARAMETERS -->
    <xsl:param name="viewScopeTermIds" />

    <!-- END GENERIC PARAMETERS -->

    <!-- START GENERIC LINK VARIABLES -->
    <xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)" />
    <xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')" />
    <!-- END GENERIC LINK VARIABLES -->
    <xsl:variable name="projects" select="/node()/simple_instance[type = ('Project', 'Programme', 'Project_Activity')]" />
    <xsl:variable name="ideaElement" select="/node()/simple_instance[type = 'IDEA_TO_ELEMENT_RELATION']" />
    <xsl:variable name="ideaElementElement" select="/node()/simple_instance[name = $ideaElement/own_slot_value[slot_reference = 'idea_to_element_ea_element']/value]" />
    <xsl:variable name="ideaElementChange" select="$projects[name = $ideaElement/own_slot_value[slot_reference = 'idea_to_element_change_activity']/value]" />
    <xsl:variable name="ideaElementPlanningAction" select="/node()/simple_instance[type = 'Planning_Action'][name = $ideaElement/own_slot_value[slot_reference = 'idea_to_element_change_action']/value]" />
    <xsl:variable name="idea" select="/node()/simple_instance[type = 'Idea_Option'][own_slot_value[slot_reference = 'idea_proposed_changes']/value = $ideaElement/name]" />
    <xsl:variable name="businessNeed" select="/node()/simple_instance[type = 'Need'][own_slot_value[slot_reference = 'sr_ideas']/value = $idea/name]" />
    <xsl:variable name="costChange" select="/node()/simple_instance[type = 'Cost_Component_Change'][name = $businessNeed/own_slot_value[slot_reference = 'sr_target_cost_changes']/value]" />
    <xsl:variable name="costComponent" select="/node()/simple_instance[type = 'Cost_Component_Type'][name = $costChange/own_slot_value[slot_reference = 'change_for_cost_component_type']/value]" />
    <xsl:variable name="revenueChange" select="/node()/simple_instance[type = 'Revenue_Component_Change'][name = $businessNeed/own_slot_value[slot_reference = 'sr_target_revenue_changes']/value]" />
    <xsl:variable name="revenueComponent" select="/node()/simple_instance[type = 'Revenue_Component_Type'][name = $revenueChange/own_slot_value[slot_reference = 'change_for_revenue_component_type']/value]" />
    <xsl:variable name="serviceQualityChange" select="/node()/simple_instance[type = 'Service_Quality_Change'][name = $businessNeed/own_slot_value[slot_reference = 'sr_target_service_quality_changes']/value]" />
    <xsl:variable name="serviceQualities" select="/node()/simple_instance[type = 'Business_Service_Quality'][name = $serviceQualityChange/own_slot_value[slot_reference = 'sqc_service_quality']/value]" />




    <xsl:variable name="styleForKPIs" select="/node()/simple_instance[type = 'Element_Style'][name = $serviceQualities/own_slot_value[slot_reference = 'element_styling_classes']/value]" />
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


    <xsl:template match="knowledge_base">
        <xsl:call-template name="docType" />
        <html>

        <head>
            <xsl:call-template name="commonHeadContent" />
            <xsl:call-template name="RenderModalReportContent">
                <xsl:with-param name="essModalClassNames" select="$linkClasses" />
            </xsl:call-template>
            <link href="js/select2/css/select2.min.css" rel="stylesheet" />
            <script src="js/select2/js/select2.min.js" />
            <script type="text/javascript" src="js/handlebars-v4.1.2.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Project KPI Tracker</title>
				<style>
					.projpanel{
						border: 1pt solid #ccc;
						padding: 5px;
						border-radius: 4px;
						background-color: #fff;
						box-shadow: 0 1px 2px hsla(0, 0%, 0%, 0.25);
						margin-top: 10px;
					}</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Project KPI Tracking</span>
								</h1>
							</div>
							<div>
								<span class="right-10 strong">Key:</span>
								<i class="fa fa-bullseye right-5"/><span class="right-10">Original Target</span>
								<i class="fa fa-circle-o right-5"/><span>Actual</span>
							</div>
						</div>

						<div class="col-xs-12">
							<div id="projectList"/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
	<script>
       var externalKPIData;
          <!--   externalKPIData=[{'projectID':'eas_prj_HH_baseline_rep_v11gv1_Class40036','actualKpis':[{'kpiID':'kpi1','actualValue':10}]},{'projectID':'eas_prj_HH_baseline_rep_v11e_Class41374','actualKpis':[{'kpiID':'kpi1','actualValue':10}]}]; -->
    
            projectJSON=[<xsl:apply-templates select="$ideaElementChange" mode="projectStructure"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>];
            kpiJSON=[<xsl:if test="$serviceQualities"><xsl:apply-templates select="$serviceQualities" mode="getServiceQualities"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>,</xsl:if><xsl:if test="$revenueComponent"><xsl:apply-templates select="$revenueComponent" mode="getServiceQualities"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates>,</xsl:if><xsl:if test="$costComponent"><xsl:apply-templates select="$costComponent" mode="getServiceQualities"><xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/></xsl:apply-templates></xsl:if>];


			$(document).ready(function () {
        
        
	    var externalKPIData; 
			$.getJSON("user/kpiData.json", function (json) {
				return json; // this will show the info it in firebug console
			}).done(function (json) {
				externalKPIData = json;
    	      
				
			}).done(function (){
                setupPage(externalKPIData)
                });
			$('select').select2({theme: "bootstrap"});
		});
		
		
		function setupPage(externalKPIData) {
	      console.log(externalKPIData);		
			var projectCardFragment = $("#project-card-template").html();
			projectCardTemplate = Handlebars.compile(projectCardFragment);
			
			projectJSON.forEach(function (d) {
    console.log(d);	    
				var thisActualKPIs =[];
				
				var thisActualKPIs = externalKPIData.filter(function (k2) {
     
					if (k2.projectID === d.id) {
          
						return k2.projectID === d.id;
					}
				});
 
				d.kpis.forEach(function (k) {
				
					kpiJSON.filter(function (ls) {
				
						if (k.id === ls.id) {
							k[ 'kpiName'] = ls.name;
							if (ls.icon) {
								k[ 'icon'] = ls.icon;
							} else {
								k[ 'icon'] = 'circle';
							}
						}
					})
					if (thisActualKPIs[0]) {
						thisActualKPIs[0].actualKpis.filter(function (ak) {
          console.log('k');
        console.log(k);      
        console.log('ak');console.log(ak);
							if (k.id === ak.kpiID) {
								
								k[ 'actual'] = ak.actualValue;
							}
						})
					}

					var difference =(k.actual / k.value) * 100;
					k[ 'diff'] = Math.round(difference);
					if (difference &lt; 70) {
						k[ 'status'] = 'red';
						k[ 'statusIcon'] = 'arrow-down';
					} else if (difference &gt; 69 &amp;&amp; difference &lt; 110) {
						k[ 'status'] = '#ffc400';
						k[ 'statusIcon'] = 'minus';
					} else {
						k[ 'status'] = '#67cc7e';
						k[ 'statusIcon'] = 'arrow-up';
					}
				});
			});
			
			$("#projectList").append(projectCardTemplate(projectJSON));
		};

	</script>

            <xsl:call-template name="ProjectCardHandlebarsTemplate" />
            </body>

        </html>
    </xsl:template>
    <xsl:template name="ProjectCardHandlebarsTemplate">
        <script id="project-card-template" type="text/x-handlebars-template">
            {{#each this}}
                <div class="projpanel">
                    <div class="row">
                        <div class="col-xs-3 name"><span class="large impact">{{name}}</span></div>
                        <div class="col-xs-9">
                            {{#each this.kpis}}
                                <div class="row">
                                    <div class="col-xs-4">
                                        <span>
                                            <i>
                                                <xsl:attribute name="class">fa fa-{{icon}} right-5</xsl:attribute>
                                            </i>
                                            {{kpiName}}
                                        </span>
                                    </div>
                                    <div class="col-xs-2">
                                        <span><i class="fa fa-bullseye right-5" />
                                            {{value}}
                                        </span>
                                    </div>
                                    <div class="col-xs-2">
                                        <span>
                                            <i class="fa fa-circle-o right-5">
                                                <xsl:attribute name="style">{{status}}</xsl:attribute>
                                            </i>
                                            {{actual}}
                                        </span>
                                    </div>
                                    <div class="col-xs-2">
                                        <span>
                                            <i>
                                                <xsl:attribute name="style">color:{{status}}</xsl:attribute>
                                                <xsl:attribute name="class">fa fa-{{statusIcon}} right-5</xsl:attribute>
                                            </i>
                                            {{diff}}%
                                        </span>
                                    </div>
                                </div>
                            {{/each}}
                        </div>
                    </div>
                </div>
            {{/each}}
        </script>
    </xsl:template>

    <xsl:template match="node()" mode="projectStructure">
        <xsl:variable name="thisElementChange" select="$ideaElement[own_slot_value[slot_reference = 'idea_to_element_change_activity']/value = current()/name]" />
        <xsl:variable name="thisideaElementElement" select="$ideaElementElement[name = $thisElementChange/own_slot_value[slot_reference = 'idea_to_element_ea_element']/value]" />
        <xsl:variable name="thisideaElementPlanningAction" select="$ideaElementPlanningAction[name = $thisElementChange/own_slot_value[slot_reference = 'idea_to_element_change_action']/value]" />
        <xsl:variable name="thisidea" select="$idea[own_slot_value[slot_reference = 'idea_proposed_changes']/value = $thisElementChange/name]" />
        <xsl:variable name="thisbusinessNeed" select="$businessNeed[own_slot_value[slot_reference = 'sr_ideas']/value = $thisidea/name]" />
        <xsl:variable name="thiscostChange" select="$costChange[name = $thisbusinessNeed/own_slot_value[slot_reference = 'sr_target_cost_changes']/value]" />
        <xsl:variable name="thiscostComponent" select="$costComponent[name = $thiscostChange/own_slot_value[slot_reference = 'change_for_cost_component_type']/value]" />
        <xsl:variable name="thisrevenueChange" select="$revenueChange[name = $thisbusinessNeed/own_slot_value[slot_reference = 'sr_target_revenue_changes']/value]" />
        <xsl:variable name="thisrevenueComponent" select="$revenueComponent[name = $thisrevenueChange/own_slot_value[slot_reference = 'change_for_revenue_component_type']/value]" />
        <xsl:variable name="thisserviceQualityChange" select="$serviceQualityChange[name = $thisbusinessNeed/own_slot_value[slot_reference = 'sr_target_service_quality_changes']/value]" />
         <xsl:variable name="thisserviceQualities" select="$serviceQualities[name = $thisserviceQualityChange/own_slot_value[slot_reference = 'sqc_service_quality']/value]" />
         {
        "name":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value" />","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />", 
        "cc":"<xsl:value-of select="$thiscostChange/own_slot_value[slot_reference = 'name']/value" />",
        "sq":"<xsl:value-of select="$thisserviceQualities/own_slot_value[slot_reference = 'name']/value" />",
        "rc":"<xsl:value-of select="$thisrevenueComponent/own_slot_value[slot_reference = 'name']/value" />",
        "kpis":[<xsl:if test="$thiscostComponent">
            <xsl:apply-templates select="$thiscostChange" mode="kpiList">
                <xsl:with-param name="valueFor" select="$thiscostChange" />
            </xsl:apply-templates>
            <xsl:choose>
                <xsl:when test="not($thisserviceQualities)">
                    <xsl:if test="$thisrevenueChange">,</xsl:if>
                </xsl:when>
                <xsl:otherwise>,</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$thisserviceQualities">
            <xsl:apply-templates select="$thisserviceQualityChange" mode="kpiListsq">
                 
            </xsl:apply-templates>
            <xsl:choose>
                <xsl:when test="not($thisserviceQualities)">
                    <xsl:if test="$thisrevenueChange">,</xsl:if>
                </xsl:when>
                <xsl:otherwise>,</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$thisrevenueComponent">
            <xsl:apply-templates select="$thisrevenueChange" mode="kpiListrv">
                 
            </xsl:apply-templates>
        </xsl:if>]}<xsl:if test="position()!=last()">,</xsl:if>
    </xsl:template>
    <xsl:template match="node()" mode="getServiceQualities">
        <xsl:variable name="thisStyle" select="$styleForKPIs[name = current()/own_slot_value[slot_reference = 'element_styling_classes']/value]" /> {"cc":"cc","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />","name":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value" />","icon":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'element_style_icon']/value" /><xsl:value-of select="$thisStyle[0]/own_slot_value[slot_reference = 'element_style_icon']/value" />"}, </xsl:template>

    <xsl:template match="node()" mode="kpiList">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thiscostComponent" select="$costComponent[name = current()/own_slot_value[slot_reference = 'change_for_cost_component_type']/value]" />
        <xsl:for-each select="$thiscostComponent">
        {"kp":"<xsl:value-of select="position()"/>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />","name":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value" />","value":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'change_percentage']/value" />"},
            </xsl:for-each>
    </xsl:template>
     <xsl:template match="node()" mode="kpiListsq">
         <xsl:variable name="this" select="current()"/>
         <xsl:variable name="thisserviceQualities" select="$serviceQualities[name = current()/own_slot_value[slot_reference = 'sqc_service_quality']/value]" />
        <xsl:for-each select="$thisserviceQualities">{"sq":"sq","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)" />","name":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value" />","value":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'change_percentage']/value" />"}<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>     
    </xsl:template>
     <xsl:template match="node()" mode="kpiListrv">
        <xsl:variable name="this" select="current()"/> <xsl:variable name="thisrevenueComponent" select="$revenueComponent[name =  current()/own_slot_value[slot_reference = 'change_for_revenue_component_type']/value]" /><xsl:for-each select="$thisrevenueComponent"> {"rv":"rv","id":"
        <xsl:value-of select="eas:getSafeJSString(current()/name)" />","name":"
        <xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value" />","value":"
         <xsl:value-of select="$this/own_slot_value[slot_reference = 'change_percentage']/value" />"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
