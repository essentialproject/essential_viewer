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

    <xsl:variable name="busDriver" select="/node()/simple_instance[type='Business_Driver']"/>
	
	
    <xsl:variable name="goalTaxonomy" select="/node()/simple_instance[type='Taxonomy_Term'][own_slot_value[slot_reference='name']/value='Strategic Goal']"/> 
	<xsl:variable name="allBusObjectives" select="/node()/simple_instance[(type = 'Business_Objective') and not(own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name)]"/>
	<xsl:variable name="allStrategicGoals" select="/node()/simple_instance[(type = 'Business_Goal') or ((type = 'Business_Objective') and (own_slot_value[slot_reference = 'element_classified_by']/value = $goalTaxonomy/name))]"/>

	<xsl:variable name="busGoals" select="$allStrategicGoals"/>
	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
 
	<xsl:variable name="allDrivers" select="/node()/simple_instance[type = 'Business_Driver']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor'][name=$allBusObjectives/own_slot_value[slot_reference = 'bo_owners']/value]"/>
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
			<style>
            .goalsTable{
                border-bottom:1pt solid #e8e8e8;
                padding:3px;
            }    
            .goalsTd{
                padding-top:4px
            }
            .ess-blob{
						margin: 0 15px 15px 0;
						border: 1px solid #ccc;
						height: 40px;
						width: 140px;
						border-radius: 4px;
						display: table;
						position: relative;
						text-align: center;
						float: left;
					}

					.orgName{
						font-size:2.4em;
						padding-top:30px;
						text-align:center;
					}

					.ess-blobLabel{
						display: table-cell;
						vertical-align: middle;
						line-height: 1.1em;
						font-size: 90%;
					}
					
					.infoButton > a{
						position: absolute;
						bottom: 0px;
						right: 3px;
						color: #aaa;
						font-size: 90%;
					}
					
					.dataTables_filter label{
						display: inline-block!important;
					}
					
					#summary-content label{
						margin-bottom: 5px;
						font-weight: 600;
						display: block;
					}
					
					#summary-content h3{
						font-weight: 600;
					}
					
					.ess-tag{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						font-size: 90%;
					}
					
					.map{
						width: 100%;
						height: 400px;
						min-width: 450px;
						min-height: 400px;
					}
					
					.dashboardPanel{
						padding: 10px 15px;
						border: 1px solid #ddd;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						width: 100%;
					}
					
					.parent-superflex{
						display: flex;
						flex-wrap: wrap;
						gap: 15px;
					}
					
					.superflex{
						border: 1px solid #ddd;
						padding: 10px;
						box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
						flex-grow: 1;
						flex-basis: 1;
					}
					
					.ess-list-tags{
						padding: 0;
					}
					
					.ess-string{
						background-color: #f6f6f6;
						padding: 5px;
						display: inline-block;
					}
					
					.ess-doc-link{
						padding: 3px 8px;
						border: 1px solid #6dadda;
						border-radius: 4px;
						margin-right: 10px;
						margin-bottom: 10px;
						display: inline-block;
						font-weight: 700;
						background-color: #fff;
						font-size: 85%;
					}
					
					.ess-doc-link:hover{
						opacity: 0.65;
					}
					
					.ess-list-tags li{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						background-color: #eee;
						font-size: 85%;
					}

                    .ess-list-tags-org li{
						padding: 3px 12px;
						border: 1px solid transparent;
						border-radius: 16px;
						margin-right: 10px;
						margin-bottom: 5px;
						display: inline-block;
						font-weight: 700;
						background-color: rgb(133, 199, 195);
						font-size: 85%;
                        padding-left:5px;
					}
					
					.ess-mini-badge {
						display: inline-block!important;
						padding: 2px 5px;
						border-radius: 4px;
					}
					
					@media (min-width : 1220px) and (max-width : 1720px){
						.ess-column-split > div{
							width: 450px;
							float: left;
						}
					}
					
					
					.bdr-left-blue{
						border-left: 2pt solid #5b7dff !important;
					}
					
					.bdr-left-indigo{
						border-left: 2pt solid #6610f2 !important;
					}
					
					.bdr-left-purple{
						border-left: 2pt solid #6f42c1 !important;
					}
					
					.bdr-left-pink{
						border-left: 2pt solid #a180da !important;
					}
					
					.bdr-left-red{
						border-left: 2pt solid #f44455 !important;
					}
					
					.bdr-left-orange{
						border-left: 2pt solid #fd7e14 !important;
					}
					
					.bdr-left-yellow{
						border-left: 2pt solid #fcc100 !important;
					}
					
					.bdr-left-green{
						border-left: 2pt solid #5fc27e !important;
					}
					
					.bdr-left-teal{
						border-left: 2pt solid #20c997 !important;
					}
					
					.bdr-left-cyan{
						border-left: 2pt solid #47bac1 !important;
					}
					
					@media print {
						#summary-content .tab-content > .tab-pane {
						    display: block !important;
						    visibility: visible !important;
						}
						
						#summary-content .no-print {
						    display: none !important;
						    visibility: hidden !important;
						}
						
						#summary-content .tab-pane {
							page-break-after: always;
						}
					}
					
					@media screen {						
						#summary-content .print-only {
						    display: none !important;
						    visibility: hidden !important;
						}
					}
					.stat{
						border:1pt solid #d3d3d3;
						border-radius:4px;
						margin:5px;
						padding:3px;
					}
					.lbl-large{    
						font-size: 200%;
						border-radius: 5px;
						margin-right: 10%;
						margin-left: 10%;
						text-align: center;
						/* display: inline-block; */
						/* width: 60px; */
						box-shadow: 2px 2px 2px #d3d3d3;
					}
					.lbl-big{
						font-size: 150%;
					}
                    .lbl-mid{
						font-size: 90%;
					}
					.roleBlob{
						background-color: rgb(68, 182, 179)
					}
                    .label-success-link{
                        background-color:#dddddd
                    }
                    input{color:#000}
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
                                    <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Strategic Goals Summary')"/> </span><xsl:text> </xsl:text>
                                </h1>
                            </div>
                        </div>
                    </div>
                    <!--Setup Vertical Tabs-->
                    <div class="row">
                        <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2 no-print">
                            <ul class="nav nav-tabs tabs-left">
                                <li class="active">
                                    <a href="#drivers" data-toggle="tab"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('By Driver')"/></a>
                                </li>
                                <li>
                                    <a href="#goals" data-toggle="tab"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('By Goals')"/></a>
                                </li>
                                <li>
                                    <a href="#orgs" data-toggle="tab"><i class="fa fa-fw fa-th right-10"></i><xsl:value-of select="eas:i18n('By Organisation')"/></a>
                                </li> 
                            </ul>
                        </div>
                        <div class="col-xs-12 col-sm-8 col-md-9 col-lg-10"> 
                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div class="tab-pane " id="goals">
                                    <h2 class="print-only"><i class="fa fa-fw fa-bullseye right-10"></i><xsl:value-of select="eas:i18n('By Goals')"/></h2>
                                    <div class="parent-superflex">
                                        <div class="superflex">
                                                <div class="simple-scroller" id="goalsTable"> </div>
                                        </div>
                                    </div>  
                                 </div>
                                 <div class="tab-pane" id="orgs">
                                        <h2 class="print-only"><i class="fa fa-fw fa-users right-10"></i><xsl:value-of select="eas:i18n('By Organisation')"/></h2>
                                        <div class="parent-superflex">
                                            <div class="superflex">
                                                <div class="simple-scroller" id="orgTable"> </div>
                                            </div>
                                        </div>  
                                </div>
                                <div class="tab-pane active" id="drivers">
                                    <h2 class="print-only"><i class="fa fa-fw fa-paper-plane right-10"></i><xsl:value-of select="eas:i18n('By Driver')"/></h2>
                                    <div class="parent-superflex">
                                        <div class="superflex">
                                            <div class="simple-scroller" id="driverTable"> </div>
                                        </div>
                                    </div>  
                                </div>
                            </div>
                        </div>
                    </div>
            </div>


		 <!-- 						
 
			ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
<script id="table-template" type="text/x-handlebars-template">
	<table class="table table-bordered table-header-background" id="organisationTable" width="100%">
			<thead>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Strategic Goal')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Objective')"/>
					</th>
					<th class="cellWidth-15pc">
						<xsl:value-of select="eas:i18n('Driver')"/>
					</th>
					<th class="cellWidth-30pc">
						<xsl:value-of select="eas:i18n('Org Unit')"/>
					</th>
					<th class="cellWidth-15pc">
						<xsl:value-of select="eas:i18n('Measure/KPI')"/>
					</th>
				</tr>
			</thead>
			<tbody>
                {{#each this}} 
                 {{#if this.objectives}}
						{{#each this.objectives}}
							<tr>
								 
								<td class="cellWidth-20pc" style="background-color:#e3e3e3;">
                                        <span class="label label-primary lbl-mid">{{../this.name}}</span>
								</td>
								 
								<td class="cellWidth-20pc">
                                        <span class="label label-success-link lbl-mid"> 	{{{essRenderInstanceMenuLink this}}}</span>
								</td>
								<td class="cellWidth-15pc">
                                    {{#each ../this.drivers}}
                                        <span class="label label-info lbl-mid">{{this.name}}</span>
									{{/each}}
                                       
								</td>
								<td class="cellWidth-30pc">
                                    <ul class="ess-list-tags-org" style="padding-left:5px;">
									{{#each this.busObjOrgOwners}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
								</td>
								<td class="cellWidth-15pc">
                                    <ul class="ess-list-tags">
										{{#each this.busObjMeasures}}
											<li>{{this.name}}</li>
										{{/each}}
									</ul>
								</td>
							</tr> 
                    {{/each}}
                    {{else}}
                    <tr>
                             
                            <td class="cellWidth-20pc" style="background-color:#e3e3e3;">
                                    <span class="label label-primary lbl-mid">{{this.name}}</span>
                            </td>
                           
                            <td class="cellWidth-20pc">
                                    
                            </td>
                            <td class="cellWidth-15pc">
                                {{#each this.drivers}}
                                    <span class="label label-info lbl-mid">{{this.name}}</span>
                                {{/each}}
                                   
                            </td>
                            <td class="cellWidth-30pc">
                                
                            </td>
                            <td class="cellWidth-15pc">
                                
                            </td>
                        </tr> 
                    {{/if}}
				{{/each}}
            </tbody>
            <tfoot>
                <tr>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Strategic Goal')"/>
                    </th>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Objective')"/>
                    </th>
                    <th class="cellWidth-15pc">
                        <xsl:value-of select="eas:i18n('Driver')"/>
                    </th>
                    <th class="cellWidth-30pc">
                        <xsl:value-of select="eas:i18n('Org Unit')"/>
                    </th>
                    <th class="cellWidth-15pc">
                        <xsl:value-of select="eas:i18n('Measure/KPI')"/>
                    </th>
                </tr>
            </tfoot> 
	</table>	
</script>
<script id="driver-template" type="text/x-handlebars-template">
	<table class="table table-bordered table-header-background" id="driverGlTable" width="100%">
			<thead>
				<tr>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Driver')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Strategic Goal')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Objective')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Org Unit')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Measure/KPI')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				{{#each this}}
                    {{#each this.goals}}
                    {{#if this.objectives}}
						{{#each this.objectives}}
							<tr>
							 
								<td class="cellWidth-20pc" style="background-color:#e3e3e3;">
                                        <span class="label label-info lbl-mid">{{../../this.driver}}</span>
								</td>
							 
								<td class="cellWidth-20pc">
                                        <span class="label label-primary lbl-mid"> {{../this.goal}}</span>
								</td>
								<td class="cellWidth-20pc">
                                        <span class="label label-success-link lbl-mid">  {{{essRenderInstanceMenuLink this}}} </span>
								</td>
								<td class="cellWidth-20pc">
                                    <ul class="ess-list-tags-org" style="padding-left:5px;">
									{{#each this.busObjOrgOwners}}
										<li>{{this.name}}</li>
									{{/each}}
									</ul>
								</td>
								<td class="cellWidth-20pc">
                                    <ul class="ess-list-tags">
										{{#each this.busObjMeasures}}
											<li>{{this.name}}</li>
										{{/each}}
									</ul>
								</td>
							</tr>
                        {{/each}}
                        {{else}}
                        <tr> 
                            <td class="cellWidth-20pc" style="background-color:#e3e3e3;">
                                    <span class="label label-info lbl-mid">{{../this.driver}}</span>
                            </td>
                            
                            <td class="cellWidth-20pc">
                                    <span class="label label-primary lbl-mid"> {{this.goal}}</span>
                            </td>
                            <td class="cellWidth-20pc">
                                        
                            </td>
                            <td class="cellWidth-20pc">
                                
                            </td>
                            <td class="cellWidth-20pc">
                                
                            </td>
                        </tr>
                        {{/if}}
					{{/each}}
				{{/each}}
            </tbody>
            <tfoot>
                <tr>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Driver')"/>
                    </th>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Strategic Goal')"/>
                    </th>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Objective')"/>
                    </th>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Org Unit')"/>
                    </th>
                    <th class="cellWidth-20pc">
                        <xsl:value-of select="eas:i18n('Measure/KPI')"/>
                    </th>
                </tr>
            </tfoot>
	</table>	
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
                                        <span class="label label-success-link lbl-mid">{{{essRenderInstanceMenuLink this}}}</span>
								</td>
								<td class="cellWidth-20pc" >
                                    <table>
                                        {{#each this.goals}}
                                        <tr class="goalsTable">
                                            <td class="goalsTd">
                                                    <span class="label label-primary lbl-mid"> {{this.name}}</span>
                                            </td>
                                            <td class="goalsTd">
                                                <ul class="ess-list-tags-org" style=" padding-left:5px" >
                                                {{#each this.mappedDrivers}}
                                                <span class="label label-info lbl-mid">{{this.driver}}</span>
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
 
$(document).ready(function() {
					
	Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
		return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
	});

	var tableFragment   = $("#table-template").html();
        tableTemplate = Handlebars.compile(tableFragment); 

    var driverFragment   = $("#driver-template").html();
        driverTemplate = Handlebars.compile(driverFragment); 

    var otableFragment   = $("#orgtable-template").html();
        otableTemplate = Handlebars.compile(otableFragment);    
        
    orgs.forEach((d)=>{
        d.objectives.forEach((e)=>{
            let gls=[];
            e.goals.forEach((gl)=>{
                let thisdrv=[] 
                let thisGl=goals.find((g)=>{
                    return g.id == gl;
                }); 
                thisGl.drivers.forEach((dr)=>{
                    let thisDr=drivers.find((d)=>{
                        return d.id==dr.id;
                    });
                    thisdrv.push(thisDr);   
                })
                
                thisGl['mappedDrivers']=thisdrv;
                gls.push(thisGl);
            })
            e['goals']=gls;
        })
    });
console.log('goals',goals)
    $('#orgTable').html(otableTemplate(orgs)); 
    $('#goalsTable').html(tableTemplate(goals));
    $('#driverTable').html(driverTemplate(drivers));

    $('#organisationTable tfoot th').each( function () {
		var title = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
    } );
    
    $('#driverGlTable tfoot th').each( function () {
		var drvtitle = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+drvtitle+'" /&gt;' );
    } );

    $('#orgObjTable tfoot th').each( function () {
		var orgtitle = $(this).text();
		$(this).html( '&lt;input type="text" placeholder="Search '+orgtitle+'" /&gt;' );
    } );
    let drivertable = $('#driverGlTable').DataTable({ 
                    scrollCollapse: true,
                    paging: true,
                    info: false, 
                    responsive: false
                });
           
    let orgObjtable = $('#orgObjTable').DataTable({ 
        scrollCollapse: true,
        paging: true,
        info: false,
        sort: true,
        responsive: false
    });            
					
    let orgtable = $('#organisationTable').DataTable({ 
                    scrollCollapse: true,
                    paging: false,
                    info: false,
                    sort: true,
                    responsive: false
                });

	orgtable.columns().every( function () {
			var that = this;
		
			$( 'input', this.footer() ).on( 'keyup change', function () {
				if ( that.search() !== this.value ) {
					that
						.search( this.value )
						.draw();
				}
			} );
		} );
		
	orgtable.columns.adjust();	

    drivertable.columns().every( function () {
			var that = this;
		
			$( 'input', this.footer() ).on( 'keyup change', function () {
				if ( that.search() !== this.value ) {
					that
						.search( this.value )
						.draw();
				}
			} );
		} );
		
    drivertable.columns.adjust();	
   
    orgObjtable.columns().every( function () {
			var that = this;
		
			$( 'input', this.footer() ).on( 'keyup change', function () {
				if ( that.search() !== this.value ) {
					that
						.search( this.value )
						.draw();
				}
			} );
		} );
		
    orgObjtable.columns.adjust();	

});
</script>
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
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Objective')"/>
					</th>
					<th class="cellWidth-20pc">
						<xsl:value-of select="eas:i18n('Driver')"/>
					</th>
					<th class="cellWidth-20pc">
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
<xsl:template match="node()" mode="drivers">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisGoals" select="$busGoals[name=$this/own_slot_value[slot_reference='bd_motivated_objectives']/value]"/>
		{
		"id":"<xsl:value-of select="current()/name"/>",
		"driver":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
		"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>",
		"goals":[<xsl:apply-templates select="$thisGoals" mode="goals"/>]}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template>
	
<xsl:template match="node()" mode="goals">
	<xsl:variable name="this" select="current()"/>
    <xsl:variable name="thisObjsOld" select="$allBusObjectives[name=$this/own_slot_value[slot_reference='objective_supported_by_objective']/value]"/>
    <xsl:variable name="thisObjsNew" select="$allBusObjectives[name=$this/own_slot_value[slot_reference='goal_supported_by_objectives']/value]"/>
    <xsl:variable name="thisObjs" select="$thisObjsOld union $thisObjsNew"/>
    {"goal":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="isForJSONAPI" select="false()"/></xsl:call-template>", 
    "id":"<xsl:value-of select="current()/name"/>",
    "objectives":[<xsl:apply-templates select="$thisObjs" mode="objs"/>]}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template>   
	
<xsl:template match="node()" mode="objs">
	<xsl:variable name="this" select="current()"/>
	<xsl:variable name="busObjMeasuresOld" select="$allBusinessServiceQualityValues[name = current()/own_slot_value[slot_reference = 'bo_measures']/value]"/>
	<xsl:variable name="busObjServtoObj" select="$allBusinessServiceOBJ[name = current()/own_slot_value[slot_reference = 'bo_performance_measures']/value]"/>		
    <xsl:variable name="busObjMeasuresNew" select="$allBusinessServiceQualities[name =$busObjServtoObj/own_slot_value[slot_reference = 'obj_to_svc_quality_service_quality']/value]"/>
    <xsl:variable name="busObjMeasures" select="$busObjMeasuresOld union $busObjMeasuresNew"/>
    <xsl:variable name="busObjOrgOwners" select="$allGroupActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
    <xsl:variable name="busObjIndividualOwners" select="$allIndividualActors[name = current()/own_slot_value[slot_reference = 'bo_owners']/value]"/>
    <xsl:variable name="busObjTargetDate" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bo_target_date']/value]"/>
    <xsl:variable name="thisGoalsOld" select="$busGoals[own_slot_value[slot_reference='objective_supported_by_objective']/value=current()/name]"/> 
    <xsl:variable name="thisGoalsNew" select="$busGoals[own_slot_value[slot_reference='goal_supported_by_objectives']/value=current()/name]"/>
    <xsl:variable name="thisGoals" select="$thisGoalsNew union $thisGoalsOld"/>
	{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
            <xsl:with-param name="theSubjectInstance" select="current()"/>
            <xsl:with-param name="isRenderAsJSString" select="true()"/>
        </xsl:call-template>",
    "className":"<xsl:value-of select="current()/type"/>",
    "id":"<xsl:value-of select="current()/name"/>",
	"date":"<xsl:value-of select="$this/own_slot_value[slot_reference='busObjTargetDate']/value"/>",
	"busObjMeasures":[<xsl:for-each select="$busObjMeasures">{"name":"<xsl:call-template name="RenderMultiLangInstanceName">
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
    "goals":[<xsl:for-each select="$thisGoals">"<xsl:value-of select="current()/name"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
}<xsl:if test="position()!=last()">,</xsl:if> 
</xsl:template> 

<xsl:template match="node()" mode="orgs">
    <xsl:variable name="thisdrivers" select="$allDrivers[own_slot_value[slot_reference='bd_motivated_objectives']/value=current()/name]"/>
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
    <xsl:variable name="thisdrivers" select="$allDrivers[own_slot_value[slot_reference='bd_motivated_objectives']/value=current()/name]"/>
    <xsl:variable name="this" select="current()"/>
    <xsl:variable name="busObjs" select="$allBusObjectives[name=current()/own_slot_value[slot_reference = 'goal_supported_by_objectives']/value]"/>
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
